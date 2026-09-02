#!/usr/bin/env python3
"""
Tree view of the tabs Firefox has open, with per-group counts.

Windows and tab groups alone would be three levels and nothing to unfold, so
the depth comes out of the URLs themselves:

    window > tab group > host > first path segments

Tab groups are shown in the colour they carry in the tab strip.

Only counts are shown, never single tabs - with a few thousand tabs the
interesting question is not which tab, it is where they piled up. The second
column counts duplicates: tabs whose URL is open more than once anywhere in
that subtree.

Keys in the TUI:
  arrows / j / k        | move
  Enter / Space / l / h | expand / collapse
  E / C                 | expand / collapse all
  s                     | cycle sort: position | count | name (see --sort)
  Home / End or g / G   | top / bottom
  q                     | quit
"""

import argparse
import curses
import json
import signal
import sys
from datetime import datetime
from pathlib import Path
from urllib.parse import urlsplit

# Where a profile keeps its session. recovery.jsonlz4 is the live one, rewritten
# every 15 seconds while Firefox runs; sessionstore.jsonlz4 only exists after a
# clean shutdown. Newest mtime wins, so a running and a closed Firefox both work.
SESSION_FILES = ("sessionstore.jsonlz4",
                 "sessionstore-backups/recovery.jsonlz4",
                 "sessionstore-backups/recovery.baklz4",
                 "sessionstore-backups/previous.jsonlz4")

# Column headings as (symbol, cells it occupies). Emoji that Unicode marks as
# wide and that carry no variation selector, so every terminal draws them two
# cells wide; that is why the width can be a constant here.
COLUMNS = (("\U0001F4C4", 2), ("\U0001F501", 2))     # tabs, duplicates
SORT_MODES = ("position", "count", "name")   # position = as stored in the session

# The nine colours a tab group can have. The numbers are xterm-256 slots picked
# to look like what Firefox paints; on an 8-colour terminal the fallback has to
# make orange, pink and purple share with their nearest neighbour.
GROUP_COLORS = {
    "blue": (39, curses.COLOR_BLUE), "cyan": (51, curses.COLOR_CYAN),
    "green": (41, curses.COLOR_GREEN), "yellow": (220, curses.COLOR_YELLOW),
    "orange": (208, curses.COLOR_YELLOW), "red": (203, curses.COLOR_RED),
    "pink": (213, curses.COLOR_MAGENTA), "purple": (141, curses.COLOR_MAGENTA),
    "grey": (245, curses.COLOR_WHITE),
}

MOZLZ4 = b"mozLz40\0"    # Firefox compresses both bookmarks and sessions this way

NEEDS_LZ4 = """Reading jsonlz4 needs the lz4 module - install it with:
    apt install python3-lz4      (Debian, Ubuntu)
    pip install lz4              (anywhere else)"""

class MissingLZ4(Exception):
    """Nothing wrong with the file, so this is reported without naming it."""


try:
    from lz4.block import decompress as lz4_decompress
except ImportError:
    lz4_decompress = None


class Node:
    """One group of tabs. Single tabs are only ever counted, never kept."""

    __slots__ = ("title", "color", "children", "expanded", "depth", "pos",
                 "tabs", "dupes")

    def __init__(self, title, color=None, depth=0):
        self.title = title
        self.color = color  # only tab groups have one, and only if Firefox stored it
        self.children = []
        self.expanded = False
        self.depth = depth
        self.pos = 0        # order the session had them in, so it can be restored
        self.tabs = 0       # whole subtree, not just direct children
        self.dupes = 0

    def counts(self):
        return (self.tabs, self.dupes)


def read_json(path):
    """Session files are JSON behind Mozilla's 8-byte magic plus the uncompressed
    size, then a raw LZ4 block - the same wrapping the bookmark backups use."""
    raw = Path(path).read_bytes()
    if raw[:8] == MOZLZ4:
        if lz4_decompress is None:
            raise MissingLZ4(NEEDS_LZ4)
        size = int.from_bytes(raw[8:12], "little") if len(raw) >= 12 else -1
        if not 0 <= size <= 1 << 29:    # a truncated file would ask for absurd memory
            raise ValueError("damaged session: implausible size in the mozlz4 header")
        try:
            raw = lz4_decompress(raw[12:], uncompressed_size=size)
        except Exception as err:        # LZ4BlockError, OverflowError, ... all mean the same
            raise ValueError(f"damaged session: {err}") from None
    return json.loads(raw)


def newest_session(folder):
    """The freshest of the session files a profile keeps."""
    found = [p for p in (folder / name for name in SESSION_FILES) if p.is_file()]
    if not found:
        raise FileNotFoundError(f"no session file in {folder}")
    return max(found, key=lambda p: p.stat().st_mtime)


def current_url(tab):
    """A tab carries its whole history; entries[index - 1] is the page on screen."""
    entries = tab.get("entries") or []
    if not entries:
        return tab.get("userTypedValue") or ""
    i = tab.get("index", len(entries))
    return entries[max(0, min(i, len(entries)) - 1)].get("url", "")


def url_levels(url, path_depth):
    """The levels one tab contributes below its group: host, then path pieces.

    The host is taken as it is, apart from a leading www. - forum.domain.de and
    domain.de are different places and stay apart. Folding them into one site
    would need the public suffix list to tell domain.co.uk from domain.de, and
    that is a lot of machinery for a counter.
    """
    if not url:
        return ["(no url)"]
    parts = urlsplit(url)
    if parts.scheme not in ("http", "https"):
        # about:, file:, moz-extension:, view-source: - an extension id is not a
        # domain, so these are kept apart instead of pretending to be sites
        rest = (parts.netloc or parts.path).strip("/")
        return [f"({parts.scheme or '?'}:)"] + ([rest.split("/")[0]] if rest else [])

    host = parts.netloc.lower().rsplit("@", 1)[-1].split(":")[0].removeprefix("www.")
    if not host:
        return ["(no host)"]
    levels = [host]
    if path_depth:
        levels += [f"/{seg}" for seg in parts.path.split("/") if seg][:path_depth]
    return levels


def group_labels(window):
    """Tab group id -> (name, colour) for one window, if this Firefox stores any.

    Tab groups are young, so the keys are read defensively: whatever the list is
    called, an entry needs an id and something printable. Windows without groups
    simply skip that level instead of showing one empty node. The colour is the
    one the group carries in the tab strip - blue, cyan, grey, green, orange,
    pink, purple, red, yellow - and is simply absent if this version has none.
    """
    raw = window.get("groups") or window.get("tabGroups") or []
    labels = {}
    for group in raw:
        if not isinstance(group, dict):
            continue
        gid = group.get("id") or group.get("groupId")
        if gid:
            name = group.get("name") or group.get("title") or "(unnamed group)"
            color = str(group.get("color") or "").lower().replace("gray", "grey")
            labels[gid] = (name, color if color in GROUP_COLORS else None)
    return labels


def tab_group(tab):
    return tab.get("groupId") or tab.get("group") or None


def collect(data, path_depth):
    """Every tab as (levels, url), plus the numbers for the summary line."""
    rows, stats = [], {"windows": 0, "pinned": 0, "closed": 0, "groups": 0}
    windows = data.get("windows") or []
    multi = len(windows) > 1

    for w, window in enumerate(windows, 1):
        stats["windows"] += 1
        stats["closed"] += len(window.get("_closedTabs") or [])
        labels = group_labels(window)
        stats["groups"] += len(labels)
        tabs = window.get("tabs") or []
        # a single window would only ever be one root, and one root is no tree
        head = [(f"Window {w} ({len(tabs)} tabs)", None)] if multi else []

        for tab in tabs:
            if tab.get("pinned"):
                stats["pinned"] += 1
            url = current_url(tab)
            levels = list(head)
            if labels:              # skip the level entirely when unused
                levels.append(labels.get(tab_group(tab), ("(ungrouped)", None)))
            # every level is (label, colour); only a tab group ever has one
            levels += [(label, None) for label in url_levels(url, path_depth)]
            rows.append((levels, url))

    stats["closed"] += sum(len(w.get("tabs") or [])
                           for w in (data.get("_closedWindows") or []))
    # counted here, not from the roots: the same URL open in two windows is one
    # unique URL, which a per-root sum would miss
    urls = [url for _, url in rows]
    stats["tabs"] = len(urls)
    stats["unique"] = len(set(urls))
    return rows, stats


def build(rows):
    """Turn the (levels, url) rows into the tree, counting on the way back up."""
    tree = {}       # (label, colour) -> [subtree, urls parked at this level]

    for levels, url in rows:
        here = tree
        for i, key in enumerate(levels):
            slot = here.setdefault(key, [{}, []])
            if i == len(levels) - 1:
                slot[1].append(url)
            here = slot[0]

    def convert(key, slot, depth):
        node = Node(key[0], key[1], depth)
        urls = list(slot[1])
        for i, (sub_key, sub) in enumerate(slot[0].items()):
            child, child_urls = convert(sub_key, sub, depth + 1)
            child.pos = i
            node.children.append(child)
            urls += child_urls
        node.tabs = len(urls)
        node.dupes = len(urls) - len(set(urls))
        return node, urls

    roots = []
    for i, (key, slot) in enumerate(tree.items()):
        node, _ = convert(key, slot, 0)
        node.pos = i
        compact(node)
        roots.append(node)
    return roots


def lift(nodes):
    """One level closer to the root, for the whole subtree."""
    for node in nodes:
        node.depth -= 1
        lift(node.children)


def compact(node):
    """Fold away levels that add no information.

    A host with a single path below it (reddit.com > /r) is one thing shown as
    two, so it becomes reddit.com/r. Folding needs equal counts, so a host that
    also has tabs of its own keeps those visibly apart from the deeper ones.
    """
    for child in node.children:
        compact(child)

    while (len(node.children) == 1 and node.children[0].tabs == node.tabs
           and node.children[0].title.startswith("/")):
        kid = node.children[0]
        node.title += kid.title
        node.children = kid.children
        node.dupes = kid.dupes
        lift(node.children)


def sort_tree(nodes, mode):
    """Reorder in place, the given level included - the top level here is the tab
    groups, and leaving those unsorted would ignore --sort where it matters most.
    Sorting is destructive, so `position` restores from Node.pos."""
    keys = {"position": lambda c: c.pos,
            "count": lambda c: (-c.tabs, c.title.lower()),
            "name": lambda c: c.title.lower()}
    nodes.sort(key=keys[mode])
    for n in nodes:
        sort_tree(n.children, mode)


def flatten(roots):
    """Every currently visible row as (node, prefix, is_last_child)."""
    out = []

    def walk(node, prefix, last):
        out.append((node, prefix, last))
        if not node.expanded:
            return
        for i, child in enumerate(node.children):
            walk(child, prefix + ("   " if last else "│  "), i == len(node.children) - 1)

    for root in roots:
        walk(root, "", True)
    return out


def digits(roots):
    """Widest number we will actually print, so the block is no wider than needed."""
    widest = 0
    stack = list(roots)
    while stack:
        node = stack.pop()
        widest = max(widest, node.tabs)
        stack.extend(node.children)
    return len(str(widest))


def header(dw):
    # pad by cells, not by characters, so a heading sits over its own numbers
    return "".join(f"{sym:>{dw + 3 - cells}}" for sym, cells in COLUMNS) + "  GROUP"


def render(node, prefix, last, dw, paint=None):
    branch = "" if node.depth == 0 else ("└─ " if last else "├─ ")
    icon = ("▾ " if node.expanded else "▸ ") if node.children else "  "
    numbers = "".join(f"{v:>{dw + 2}}" for v in node.counts())
    title = paint(node.title, node.color) if paint and node.color else node.title
    return f"{numbers}  {prefix}{branch}{icon}{title}"


def ansi_painter(mode):
    """Colour for --plain. Escapes are zero width, so the columns stay aligned;
    they are only ever wrapped around the title, never around the numbers."""
    if mode == "never" or (mode == "auto" and not sys.stdout.isatty()):
        return None
    return lambda text, color: f"\033[38;5;{GROUP_COLORS[color][0]}m{text}\033[0m"


def expand_to(nodes, level):
    """Unfold the tree down to `level` levels; None means all the way."""
    for n in nodes:
        n.expanded = level is None or n.depth + 1 < level
        expand_to(n.children, level)


def summary(stats, short=False):
    tabs, unique = stats["tabs"], stats["unique"]
    if short:      # the title bar also has to fit a file name and the sort mode
        return f"{tabs} tabs, {unique} unique"
    line = (f"{tabs} tabs in {stats['windows']} window(s), "
            f"{unique} unique URLs ({tabs - unique} duplicates)")
    extra = []
    if stats["groups"]:
        extra.append(f"{stats['groups']} tab groups")
    if stats["pinned"]:
        extra.append(f"{stats['pinned']} pinned")
    if stats["closed"]:
        extra.append(f"{stats['closed']} closed tabs still restorable")
    return line + (" | " + ", ".join(extra) if extra else "")


def stamp(path):
    when = datetime.fromtimestamp(path.stat().st_mtime).strftime("%Y-%m-%d %H:%M")
    return f"{path.name} {when}"


def print_plain(roots, depth, stats, src=None, paint=None):
    expand_to(roots, depth)
    dw = digits(roots)
    if src:
        print(f"# {stamp(src)}")
    print(header(dw))
    for node, prefix, last in flatten(roots):
        print(render(node, prefix, last, dw, paint))
    print(f"\n{summary(stats)}")


def run_tui(stdscr, roots, sort, depth, stats, src=None):
    curses.curs_set(0)
    pairs = {}
    if curses.has_colors():
        curses.use_default_colors()
        curses.init_pair(1, curses.COLOR_CYAN, -1)
        # one pair per tab group colour, 256 slots where the terminal has them
        rich = curses.COLORS >= 256
        for i, (name, (fine, plain)) in enumerate(GROUP_COLORS.items(), start=2):
            try:
                curses.init_pair(i, fine if rich else plain, -1)
            except curses.error:        # fewer pairs than we asked for
                break
            pairs[name] = curses.color_pair(i)

    sort_idx = SORT_MODES.index(sort)
    when = stamp(src) if src else ""
    expand_to(roots, depth)
    cursor = top = 0
    head = summary(stats, short=True)
    dw = digits(roots)

    def put(y, text, attr, w):
        try:                    # curses raises at the bottom-right cell
            stdscr.addnstr(y, 0, text.ljust(w - 1), w - 1, attr)
        except curses.error:
            pass

    while True:
        rows = flatten(roots)
        cursor = max(0, min(cursor, len(rows) - 1))
        h, w = stdscr.getmaxyx()
        body = h - 3
        top = min(top, cursor)
        if cursor >= top + body:
            top = cursor - body + 1

        stdscr.erase()
        # how old the session is comes before the sort mode: a narrow terminal
        # cuts from the right, and staleness matters more than the ordering
        title = f" {head}" + (f" | {when}" if when else "") + \
                f" | sort: {SORT_MODES[sort_idx]} "
        put(0, title, curses.A_REVERSE, w)
        put(1, header(dw), curses.A_BOLD | curses.A_UNDERLINE, w)

        for i in range(body):
            idx = top + i
            if idx >= len(rows):
                break
            node, prefix, last = rows[idx]
            attr = curses.color_pair(1) if curses.has_colors() else curses.A_NORMAL
            if node.color in pairs:         # the group's own colour wins
                attr = pairs[node.color]
            if node.depth == 0:
                attr |= curses.A_BOLD
            if idx == cursor:               # reverse video and a colour would fight
                attr = curses.A_REVERSE
            put(2 + i, render(node, prefix, last, dw), attr, w)

        foot = " j/k move | Enter expand | E/C expand all | s sort | q quit "
        put(h - 1, foot, curses.A_REVERSE, w)
        stdscr.refresh()

        key = stdscr.getch()
        node = rows[cursor][0]

        if key in (ord("q"), 27):
            return
        elif key in (curses.KEY_DOWN, ord("j")):
            cursor += 1
        elif key in (curses.KEY_UP, ord("k")):
            cursor -= 1
        elif key == curses.KEY_NPAGE:
            cursor += body
        elif key == curses.KEY_PPAGE:
            cursor -= body
        elif key in (ord("g"), curses.KEY_HOME, curses.KEY_FIND, curses.KEY_SHOME):
            cursor = 0
        elif key in (ord("G"), curses.KEY_END, curses.KEY_SELECT, curses.KEY_SEND):
            cursor = len(rows) - 1
        elif key in (curses.KEY_ENTER, 10, 13, ord(" ")):
            if node.children:
                node.expanded = not node.expanded
        elif key in (curses.KEY_RIGHT, ord("l")):
            if node.children:
                node.expanded = True
        elif key in (curses.KEY_LEFT, ord("h")):
            if node.expanded and node.children:
                node.expanded = False
            else:
                for i in range(cursor - 1, -1, -1):
                    if rows[i][0].depth < node.depth:
                        cursor = i
                        break
        elif key == ord("E"):
            expand_to(roots, None)
        elif key == ord("C"):
            expand_to(roots, 1)
            cursor = 0
        elif key == ord("s"):
            sort_idx = (sort_idx + 1) % len(SORT_MODES)
            sort_tree(roots, SORT_MODES[sort_idx])


def inspect(data):
    """What this Firefox actually wrote, for when the group level looks wrong.

    Tab groups are new enough that the keys may differ between versions; this
    prints the shape, never a URL or a page title.
    """
    windows = data.get("windows") or []
    print(f"top level keys : {sorted(data)}")
    print(f"version        : {data.get('version')}")
    print(f"windows        : {len(windows)}")
    for w, window in enumerate(windows, 1):
        tabs = window.get("tabs") or []
        print(f"\nwindow {w}: {len(tabs)} tabs, keys: {sorted(window)}")
        for key in ("groups", "tabGroups", "closedGroups"):
            if key in window:
                print(f"  {key}: {json.dumps(window[key])[:400]}")
        if tabs:
            print(f"  tab keys: {sorted(tabs[0])}")
            seen = {tab_group(t) for t in tabs}
            print(f"  distinct group ids on tabs: {sorted(map(str, seen))[:10]}")


DESCRIPTION = """
Tree view of the tabs Firefox has open: which site holds how many. Nothing is
ever written, and a running Firefox is neither needed nor touched.
"""

EPILOG = """
where the profile folder is (about:profiles in Firefox names yours):

  Linux           ~/.mozilla/firefox/<profile>
  Linux, snap     ~/snap/firefox/common/.mozilla/firefox/<profile>
  Linux, flatpak  ~/.var/app/org.mozilla.firefox/.mozilla/firefox/<profile>
  macOS           ~/Library/Application Support/Firefox/Profiles/<profile>
  Windows         %APPDATA%\\Mozilla\\Firefox\\Profiles\\<profile>

examples:

  firefoxtabtree.py --profile ~/.mozilla/firefox/f1r3f0x.default-release
  firefoxtabtree.py -p ~/.mozilla/firefox/f1r3f0x.default-release --plain --sort count
  firefoxtabtree.py -p ~/.mozilla/firefox/f1r3f0x.default-release --path-depth 2
  firefoxtabtree.py recovery.jsonlz4 --plain --depth 0 | less
"""


class ManStyle(argparse.RawTextHelpFormatter):
    """Every option on its own line, its explanation indented underneath.

    Raw text, so the help below is printed exactly as written instead of being
    reflowed into one paragraph. max_help_position pushes the text off the
    option line: argparse only keeps them on one line while the option fits in
    help_position - 4 cells, and no option is that short.
    """

    def __init__(self, prog):
        super().__init__(prog, max_help_position=6)


def main():
    ap = argparse.ArgumentParser(description=DESCRIPTION, epilog=EPILOG,
                                 formatter_class=ManStyle)

    where = ap.add_mutually_exclusive_group(required=True)
    where.add_argument(
        "file", nargs="?", metavar="FILE",
        help="A session file: sessionstore.jsonlz4, or one of the\n"
             "recovery/previous files out of sessionstore-backups.")
    where.add_argument(
        "-p", "--profile", metavar="DIR",
        help="A Firefox profile folder; takes the freshest session file in\n"
             "it. While Firefox runs that is sessionstore-backups/\n"
             "recovery.jsonlz4, which it rewrites every 15 seconds, so the\n"
             "tree is at most that far behind. Which file was read, and\n"
             "when it was written, is shown in the header line.")

    ap.add_argument(
        "--plain", action="store_true",
        help="Print the tree once and exit, instead of opening the\n"
             "interactive view.")
    ap.add_argument(
        "--path-depth", type=int, metavar="N", default=1,
        help="How many path segments below the host become levels of their\n"
             "own, so a site with hundreds of tabs can be taken apart.\n"
             "  0   stop at the host\n"
             "  1   /issues, /pull, ...          (default)\n"
             "  2   /issues/1234, /pull/99, ...")
    ap.add_argument(
        "--sort", choices=SORT_MODES, default="count",
        help="How the groups on each level are ordered; s cycles through\n"
             "these in the interactive view.\n"
             "  count      most tabs first (default)\n"
             "  position   as the session stores them, roughly tab order\n"
             "  name       alphabetically, case is ignored")
    ap.add_argument(
        "--depth", type=int, metavar="N", default=2,
        help="How many levels are unfolded to begin with.\n"
             "  0   everything, however deep it goes\n"
             "  1   the top level only\n"
             "  2   top level and its direct children (default)\n"
             "In the interactive view, E unfolds all of it and C folds it\n"
             "back to the top.")
    ap.add_argument(
        "--color", choices=("auto", "always", "never"), default="auto",
        help="Paint tab groups in the colour Firefox gives them - blue, cyan,\n"
             "grey, green, orange, pink, purple, red, yellow.\n"
             "  auto     colour when printing to a terminal (default)\n"
             "  always   colour even into a pipe or a file\n"
             "  never    no escape sequences at all\n"
             "The interactive view always colours; a terminal with only 8\n"
             "colours has to let orange, pink and purple share.")
    ap.add_argument(
        "--inspect", action="store_true",
        help="Print what the session file structurally contains - window and\n"
             "tab keys, tab group entries - and exit. For when the group\n"
             "level looks wrong. Prints no URLs and no page titles.")
    args = ap.parse_args()
    for name in ("depth", "path_depth"):
        if getattr(args, name) < 0:
            ap.error(f"--{name.replace('_', '-')} cannot be negative")
    depth = args.depth or None      # 0 means no limit

    if hasattr(signal, "SIGPIPE"):   # exit quietly on `| head` / `| less`
        signal.signal(signal.SIGPIPE, signal.SIG_DFL)

    src = None                      # set only when we picked the file ourselves
    if args.profile:
        folder = Path(args.profile).expanduser()
        if not folder.is_dir():
            ap.error(f"--profile: {folder} is not a folder")
        try:
            path = src = newest_session(folder)
        except OSError as err:
            print(err, file=sys.stderr)
            return 1
    else:
        path = Path(args.file).expanduser()
        if path.is_dir():
            ap.error(f"{path} is a folder - use --profile to read the session in it")

    try:
        data = read_json(path)
    except MissingLZ4 as err:       # about the setup, not about this file
        print(err, file=sys.stderr)
        return 1
    except (OSError, ValueError, AttributeError) as err:   # ValueError covers bad JSON and garbled lz4
        print(f"Cannot read {path}: {err}", file=sys.stderr)
        return 1

    if args.inspect:
        inspect(data)
        return 0

    rows, stats = collect(data, args.path_depth)
    if not rows:
        print(f"{path} holds no open tabs", file=sys.stderr)
        return 1
    roots = build(rows)
    sort_tree(roots, args.sort)

    if args.plain:
        print_plain(roots, depth, stats, src, ansi_painter(args.color))
        return 0

    curses.wrapper(run_tui, roots, args.sort, depth, stats, src)
    return 0


if __name__ == "__main__":
    sys.exit(main())
