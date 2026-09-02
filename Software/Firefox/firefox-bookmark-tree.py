#!/usr/bin/env python3
"""
Tree view of a Firefox bookmarks JSON export, with per-folder counts.

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
from pathlib import Path

ROOT_LABELS = {
    "bookmarksMenuFolder": "Bookmarks Menu",
    "toolbarFolder": "Bookmarks Toolbar",
    "unfiledBookmarksFolder": "Other Bookmarks",
    "mobileFolder": "Mobile Bookmarks",
}
FOLDER = "text/x-moz-place-container"
BOOKMARK = "text/x-moz-place"
SEPARATOR = "text/x-moz-place-separator"

# Column headings as (symbol, cells it occupies). The emoji are ones Unicode
# marks as wide and that carry no variation selector, so every terminal draws
# them two cells wide; that is why the width can be a constant here.
COLUMNS = (("🔖", 2), ("📁", 2), ("➖", 2), ("Σ", 1))   # bookmarks, folders, separators, sum
SORT_MODES = ("position", "count", "name")   # position = as stored in Firefox

MOZLZ4 = b"mozLz40\0"    # header of Firefox's own bookmark backups

# Only needed for those backups; a manual .json export works without it. The lz4
# command line tool is no help here - it speaks the LZ4 frame format, Mozilla
# stores a bare block.
NEEDS_LZ4 = """Reading jsonlz4 needs the lz4 module - install it with:
    apt install python3-lz4      (Debian, Ubuntu)
    pip install lz4              (anywhere else)
  or use a manual .json export instead"""


class MissingLZ4(Exception):
    """Nothing wrong with the file, so this is reported without naming it."""


try:
    from lz4.block import decompress as lz4_decompress
except ImportError:
    lz4_decompress = None


class Node:
    """A folder. Bookmarks are only ever counted, never kept as objects."""

    __slots__ = ("title", "children", "expanded", "depth", "pos",
                 "bookmarks", "folders", "seps")

    def __init__(self, title, depth=0):
        self.title = title
        self.children = []
        self.expanded = False
        self.depth = depth
        self.pos = 0        # index in Firefox's own order, so it can be restored
        # all three count the whole subtree, not just direct children
        self.bookmarks = 0
        self.folders = 0
        self.seps = 0

    def counts(self, seps):
        """Numbers to print, sum last; separators only count when they are shown."""
        if seps:
            total = self.bookmarks + self.folders + self.seps   # what Firefox counts
            return (self.bookmarks, self.folders, self.seps, total)
        return (self.bookmarks, self.folders, self.bookmarks + self.folders)


def build(entry, depth=0):
    node = Node(entry.get("title", ""), depth)
    for child in entry.get("children", []):
        kind = child.get("type")
        if kind == BOOKMARK:
            node.bookmarks += 1
        elif kind == SEPARATOR:
            node.seps += 1
        elif kind == FOLDER:
            sub = build(child, depth + 1)
            sub.pos = len(node.children)
            node.children.append(sub)
            node.folders += 1 + sub.folders
            node.bookmarks += sub.bookmarks
            node.seps += sub.seps
    return node


def read_json(path):
    """A manual export is plain JSON; an automatic backup is the same JSON behind
    Mozilla's 8-byte magic plus the uncompressed size, then a raw LZ4 block."""
    raw = Path(path).read_bytes()
    if raw[:8] == MOZLZ4:
        if lz4_decompress is None:
            raise MissingLZ4(NEEDS_LZ4)
        size = int.from_bytes(raw[8:12], "little") if len(raw) >= 12 else -1
        if not 0 <= size <= 1 << 29:    # a truncated file would ask for absurd memory
            raise ValueError("damaged backup: implausible size in the mozlz4 header")
        try:
            raw = lz4_decompress(raw[12:], uncompressed_size=size)
        except Exception as err:        # LZ4BlockError, OverflowError, ... all mean the same
            raise ValueError(f"damaged backup: {err}") from None
    return json.loads(raw)


def newest_backup(folder):
    """Newest automatic backup in a profile folder (or in bookmarkbackups itself).

    Firefox names them bookmarks-YYYY-MM-DD_<items>_<hash>.jsonlz4, so the names
    sort by date; mtime only breaks ties between several backups of one day.
    """
    if (folder / "bookmarkbackups").is_dir():
        folder = folder / "bookmarkbackups"
    files = list(folder.glob("bookmarks-*.jsonlz4")) + list(folder.glob("bookmarks-*.json"))
    if not files:
        raise FileNotFoundError(f"no bookmark backups in {folder}")
    return max(files, key=lambda p: (p.name, p.stat().st_mtime))


def load(path):
    data = read_json(path)
    if data.get("root") == "placesRoot":
        entries = [c for c in data.get("children", []) if c.get("root") != "tagsFolder"]
    else:
        entries = [data]   # export of a single subfolder

    roots = []
    for entry in entries:
        node = build(entry)
        node.title = ROOT_LABELS.get(entry.get("root"), node.title or "Bookmarks")
        roots.append(node)
    return roots


def sort_tree(nodes, mode):
    """Reorder in place. Sorting is destructive, so `position` restores from Node.pos."""
    keys = {"position": lambda c: c.pos,
            "count": lambda c: (-c.bookmarks, c.title.lower()),
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


def digits(roots, seps):
    """Widest number we will actually print, so the block is no wider than needed."""
    widest = 0
    stack = list(roots)
    while stack:
        node = stack.pop()
        widest = max(widest, node.counts(seps)[-1])   # the sum is the largest
        stack.extend(node.children)
    return len(str(widest))


def header(dw, seps):
    cols = COLUMNS if seps else COLUMNS[:2] + COLUMNS[3:]
    # pad by cells, not by characters, so a heading sits over its own numbers
    return "".join(f"{sym:>{dw + 3 - cells}}" for sym, cells in cols) + "  TITLE"


def render(node, prefix, last, dw, seps):
    branch = "" if node.depth == 0 else ("└─ " if last else "├─ ")
    if not node.children:
        icon = "  "                                   # nothing to unfold
    else:
        icon = "▾ " if node.expanded else "▸ "
    numbers = "".join(f"{v:>{dw + 2}}" for v in node.counts(seps))
    return f"{numbers}  {prefix}{branch}{icon}{node.title or '(no title)'}"


def expand_to(nodes, level):
    """Unfold the tree down to `level` levels; None means all the way."""
    for n in nodes:
        n.expanded = level is None or n.depth + 1 < level
        expand_to(n.children, level)


def totals(roots):
    return (sum(r.bookmarks for r in roots), sum(r.folders for r in roots),
            sum(r.seps for r in roots))


def backup_date(path):
    """The date out of bookmarks-YYYY-MM-DD_<items>_<hash>.jsonlz4, if it looks like one."""
    stem = path.name.split("_")[0]
    return stem[10:] if stem.startswith("bookmarks-") and len(stem) == 20 else path.name


def print_plain(roots, seps, depth, src=None):
    expand_to(roots, depth)
    dw = digits(roots, seps)
    if src:
        print(f"# {src.name}")
    print(header(dw, seps))
    for node, prefix, last in flatten(roots):
        print(render(node, prefix, last, dw, seps))
    bm, fld, sep = totals(roots)
    print(f"\n{bm} bookmarks + {fld} folders + {sep} separators = {bm + fld + sep} items"
          f" (+{len(roots)} roots = {bm + fld + sep + len(roots)})")


def run_tui(stdscr, roots, seps, sort, depth, src=None):
    curses.curs_set(0)
    if curses.has_colors():
        curses.use_default_colors()
        curses.init_pair(1, curses.COLOR_CYAN, -1)

    sort_idx = SORT_MODES.index(sort)
    stamp = f"backup {backup_date(src)}" if src else ""
    expand_to(roots, depth)
    cursor = top = 0
    bm, fld, sep = totals(roots)
    dw = digits(roots, seps)

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
        # the date comes before the sort mode: on a narrow terminal the line is cut
        # from the right, and how old the tree is matters more than how it is ordered
        title = (f" {bm} bookmarks, {fld} folders, {sep} separators = {bm + fld + sep} items"
                 + (f" | {stamp}" if stamp else "")
                 + f" | sort: {SORT_MODES[sort_idx]} ")
        put(0, title, curses.A_REVERSE, w)
        put(1, header(dw, seps), curses.A_BOLD | curses.A_UNDERLINE, w)

        for i in range(body):
            idx = top + i
            if idx >= len(rows):
                break
            node, prefix, last = rows[idx]
            attr = curses.color_pair(1) if curses.has_colors() else curses.A_NORMAL
            if node.depth == 0:
                attr |= curses.A_BOLD
            if idx == cursor:
                attr = curses.A_REVERSE
            put(2 + i, render(node, prefix, last, dw, seps), attr, w)

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


DESCRIPTION = """
Tree view of Firefox bookmarks: which folder holds how many. Nothing is
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

  firefoxbookmarktree.py bookmarks.json
  firefoxbookmarktree.py bookmarks.json --plain --sort count --depth 1 --separators
  firefoxbookmarktree.py --profile ~/.mozilla/firefox/f1r3f0x.default-release
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
        help="A bookmarks file, in either format Firefox writes:\n"
             "  .json      an export you made yourself, via Bookmarks >\n"
             "             Manage bookmarks > Import and Backup > Backup...\n"
             "  .jsonlz4   one automatic backup file out of a profile;\n"
             "             see --profile, including the lz4 module it needs")
    where.add_argument(
        "-p", "--profile", metavar="DIR",
        help="A Firefox profile folder, so no export is needed at all.\n"
             "Takes the newest bookmarks-*.jsonlz4 from DIR/bookmarkbackups,\n"
             "where Firefox drops one by itself shortly after a start, at\n"
             "most once a day. The tree is therefore as old as your last\n"
             "Firefox restart - which backup was used, and from when, is\n"
             "shown in the header line.")

    ap.add_argument(
        "--plain", action="store_true",
        help="Print the tree once and exit, instead of opening the\n"
             "interactive view.")
    ap.add_argument(
        "--separators", action="store_true",
        help="Add the separator column and count separators in the sum,\n"
             "which is how Firefox itself counts items. Off by default,\n"
             "because separators are furniture rather than bookmarks.")
    ap.add_argument(
        "--sort", choices=SORT_MODES, default=SORT_MODES[0],
        help="How the folders on each level are ordered; s cycles through\n"
             "these in the interactive view.\n"
             "  position   as stored in Firefox, the sidebar order (default)\n"
             "  count      most bookmarks first\n"
             "  name       alphabetically, case is ignored")
    ap.add_argument(
        "--depth", type=int, metavar="N", default=2,
        help="How many levels are unfolded to begin with.\n"
             "  0   everything, however deep it goes\n"
             "  1   the roots only\n"
             "  2   roots and their direct subfolders (default)\n"
             "In the interactive view, E unfolds all of it and C folds it\n"
             "back to the roots.")
    args = ap.parse_args()
    if args.depth < 0:
        ap.error("--depth cannot be negative")
    depth = args.depth or None      # 0 means no limit

    if hasattr(signal, "SIGPIPE"):   # exit quietly on `| head` / `| less`
        signal.signal(signal.SIGPIPE, signal.SIG_DFL)

    src = None                      # set only when we picked the file ourselves
    if args.profile:
        folder = Path(args.profile).expanduser()
        if not folder.is_dir():
            ap.error(f"--profile: {folder} is not a folder")
        try:
            path = src = newest_backup(folder)
        except OSError as err:
            print(err, file=sys.stderr)
            return 1
    else:
        path = Path(args.file).expanduser()
        if path.is_dir():
            ap.error(f"{path} is a folder - use --profile to read the newest backup in it")

    try:
        roots = load(path)
    except MissingLZ4 as err:       # about the setup, not about this file
        print(err, file=sys.stderr)
        return 1
    except (OSError, ValueError, AttributeError) as err:   # ValueError covers bad JSON and garbled lz4
        print(f"Cannot read {path}: {err}", file=sys.stderr)
        return 1

    sort_tree(roots, args.sort)

    if args.plain:
        print_plain(roots, args.separators, depth, src)
        return 0

    curses.wrapper(run_tui, roots, args.separators, args.sort, depth, src)
    return 0


if __name__ == "__main__":
    sys.exit(main())
