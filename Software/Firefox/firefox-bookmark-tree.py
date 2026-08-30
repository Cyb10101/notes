#!/usr/bin/env python3
"""
Tree view of a Firefox bookmarks JSON export, with per-folder counts.

[Extract bookmarks](https://support.mozilla.org/en-US/kb/restore-bookmarks-from-backup-or-move-them#w_manual-backup):

- Menu > Bookmarks > Manage bookmarks
- Import and Backup > Backup

Shows folders only: how many bookmarks sit where. Counts come first so the
title can be any width - emoji, CJK, whatever the terminal decides to draw.

Keys in the TUI:
    j / k / arrows   move            Enter / Space / l / h   expand / collapse
    E / C            expand / collapse all
    s                cycle sort: position | count | name (see --sort)
    g / G or Home / End      top / bottom            q   quit
"""

import argparse
import curses
import json
import signal
import sys

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


def load(path):
    with open(path, encoding="utf-8") as fh:
        data = json.load(fh)
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
    for n in nodes:
        n.children.sort(key=keys[mode])
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


def print_plain(roots, seps, depth):
    expand_to(roots, depth)
    dw = digits(roots, seps)
    print(header(dw, seps))
    for node, prefix, last in flatten(roots):
        print(render(node, prefix, last, dw, seps))
    bm, fld, sep = totals(roots)
    print(f"\n{bm} bookmarks + {fld} folders + {sep} separators = {bm + fld + sep} items"
          f" (+{len(roots)} roots = {bm + fld + sep + len(roots)})")


def run_tui(stdscr, roots, seps, sort, depth):
    curses.curs_set(0)
    if curses.has_colors():
        curses.use_default_colors()
        curses.init_pair(1, curses.COLOR_CYAN, -1)

    sort_idx = SORT_MODES.index(sort)
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
        title = (f" {bm} bookmarks, {fld} folders, {sep} separators = {bm + fld + sep} items"
                 f" | sort: {SORT_MODES[sort_idx]} ")
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

        foot = " j/k move  Enter expand  E/C all  s sort  q quit "
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


def main():
    ap = argparse.ArgumentParser(description="Tree view of a Firefox bookmarks JSON export.")
    ap.add_argument("file", help="bookmarks .json export")
    ap.add_argument("--plain", action="store_true", help="print tree instead of TUI")
    ap.add_argument("--separators", action="store_true",
                    help="show the separator column and count it in the sum")
    ap.add_argument("--sort", choices=SORT_MODES, default=SORT_MODES[0],
                    help=f"initial sort order (default: {SORT_MODES[0]})")
    ap.add_argument("--depth", type=int, metavar="N", default=2,
                    help="unfold N levels (1 = roots only, 0 = everything; default: 2)")
    args = ap.parse_args()
    if args.depth < 0:
        ap.error("--depth cannot be negative")
    depth = args.depth or None      # 0 means no limit

    if hasattr(signal, "SIGPIPE"):   # exit quietly on `| head` / `| less`
        signal.signal(signal.SIGPIPE, signal.SIG_DFL)

    try:
        roots = load(args.file)
    except (OSError, json.JSONDecodeError, AttributeError) as err:
        print(f"Cannot read {args.file}: {err}", file=sys.stderr)
        return 1

    sort_tree(roots, args.sort)

    if args.plain:
        print_plain(roots, args.separators, depth)
        return 0

    curses.wrapper(run_tui, roots, args.separators, args.sort, depth)
    return 0


if __name__ == "__main__":
    sys.exit(main())
