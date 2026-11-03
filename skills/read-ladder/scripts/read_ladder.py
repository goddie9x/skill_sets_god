#!/usr/bin/env python3
"""Read Ladder helper — stdlib only.

Prints cheap structural views of a project so the agent can narrow
down what to read BEFORE spending tokens on file reads.

Subcommands:
  tree     Filtered directory tree with file counts (rung 1).
  files    Flat file list with line counts, per directory (rung 2).
  symbols  Key symbols + first doc line of one file (rung 4 triage).

Build, dependency, VCS, and binary-output directories are never
listed. Exit code is always 0 on success.
"""

import argparse
import ast
import os
import re
import sys

SMALL_FILE_LINES = 200  # at or under this: read directly, skip triage

SKIP_DIRS = {
    ".git", ".hg", ".svn",
    "node_modules", "bower_components", ".pnpm-store", ".yarn",
    "vendor", "Pods",
    "__pycache__", ".venv", "venv", ".tox", ".mypy_cache",
    ".pytest_cache", ".ruff_cache",
    "dist", "build", "out", "target", ".next", ".nuxt", ".output",
    ".turbo", "coverage", ".parcel-cache", ".cache", ".sass-cache",
    ".gradle", ".dart_tool", ".idea", ".vs",
}

SKIP_FILES = {
    ".DS_Store", "Thumbs.db", ".eslintcache", "*.tsbuildinfo",
}


def iter_files(root, max_depth):
    """Yield (rel_dir, name, full_path, depth) for non-skipped files."""
    root = os.path.abspath(root)
    for dirpath, dirs, files in os.walk(root):
        rel = os.path.relpath(dirpath, root)
        depth = 0 if rel == "." else rel.count(os.sep) + 1
        dirs[:] = sorted(d for d in dirs if d not in SKIP_DIRS)
        if depth > max_depth:
            dirs[:] = []
            continue
        for name in sorted(files):
            if name in SKIP_FILES or name.endswith(".tsbuildinfo"):
                continue
            yield rel, name, os.path.join(dirpath, name), depth


def count_lines(path):
    try:
        with open(path, "rb") as fh:
            return sum(1 for _ in fh)
    except OSError:
        return -1


def cmd_tree(args):
    counts = {}
    for rel, _name, _full, depth in iter_files(args.root, args.depth):
        counts[rel] = counts.get(rel, 0) + 1
    print(f"{os.path.abspath(args.root)}/")
    for rel in sorted(counts):
        if rel == ".":
            continue
        depth = rel.count(os.sep) + 1
        if depth > args.depth:
            continue
        indent = "  " * depth
        print(f"{indent}{os.path.basename(rel)}/  ({counts[rel]} files)")
    root_files = counts.get(".", 0)
    print(f"\n{len(counts) - (1 if '.' in counts else 0)} dirs, "
          f"{sum(counts.values())} files "
          f"({root_files} at root, depth <= {args.depth})")
    return 0


def cmd_files(args):
    exts = None
    if args.ext:
        exts = {e.strip().lower().lstrip(".") for e in args.ext.split(",")}
    current_dir = None
    total = 0
    for rel, name, full, _depth in iter_files(args.root, args.depth):
        if exts and os.path.splitext(name)[1].lower().lstrip(".") not in exts:
            continue
        if rel != current_dir:
            current_dir = rel
            print(f"\n{rel}/")
        lines = count_lines(full)
        tag = "  [small, read directly]" if 0 <= lines <= SMALL_FILE_LINES else ""
        print(f"  {name}  ({lines} lines){tag}")
        total += 1
    print(f"\n{total} files listed")
    return 0


def python_symbols(text):
    try:
        tree = ast.parse(text)
    except SyntaxError:
        return [], ""
    symbols = []
    for node in tree.body:
        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
            symbols.append(f"def {node.name}()")
        elif isinstance(node, ast.ClassDef):
            symbols.append(f"class {node.name}")
    doc = (ast.get_docstring(tree) or "").splitlines()
    return symbols, (doc[0] if doc else "")


def js_symbols(text):
    symbols = []
    patterns = [
        r"export\s+(?:default\s+)?(?:async\s+)?function\s+([A-Za-z_$][\w$]*)",
        r"export\s+class\s+([A-Za-z_$][\w$]*)",
        r"export\s+(?:const|let|var)\s+([A-Za-z_$][\w$]*)",
        r"^function\s+([A-Za-z_$][\w$]*)",
        r"^class\s+([A-Za-z_$][\w$]*)",
    ]
    for line in text.splitlines():
        for pat in patterns:
            m = re.search(pat, line)
            if m:
                symbols.append(m.group(1))
                break
    return symbols[:15]


def cmd_symbols(args):
    path = args.file
    try:
        with open(path, "r", encoding="utf-8", errors="replace") as fh:
            text = fh.read()
    except OSError as exc:
        print(f"symbols: cannot read {path}: {exc}", file=sys.stderr)
        return 2
    lines = text.count("\n") + (1 if text else 0)
    ext = os.path.splitext(path)[1].lower()
    if ext == ".py":
        symbols, doc = python_symbols(text)
    elif ext in (".js", ".jsx", ".ts", ".tsx", ".mjs", ".cjs"):
        symbols, doc = js_symbols(text), ""
        for line in text.splitlines():
            s = line.strip().strip("#/ *").strip()
            if s:
                doc = s[:100]
                break
    else:
        symbols, doc = [], ""
    print(f"{path}  ({lines} lines)")
    if lines <= SMALL_FILE_LINES:
        print("verdict: SMALL — read the file directly, skip triage")
    else:
        print("verdict: LARGE — read targeted sections, not the whole file")
    if doc:
        print(f"doc: {doc}")
    if symbols:
        print("symbols: " + ", ".join(symbols))
    else:
        print("symbols: (none found — check imports/exports manually)")
    return 0


def main(argv=None):
    parser = argparse.ArgumentParser(prog="read_ladder")
    sub = parser.add_subparsers(dest="command", required=True)

    p = sub.add_parser("tree", help="filtered directory tree (rung 1)")
    p.add_argument("root", nargs="?", default=".")
    p.add_argument("--depth", type=int, default=3)
    p.set_defaults(func=cmd_tree)

    p = sub.add_parser("files", help="file list with line counts (rung 2)")
    p.add_argument("root", nargs="?", default=".")
    p.add_argument("--depth", type=int, default=3)
    p.add_argument("--ext", help="comma-separated extensions, e.g. py,js,ts")
    p.set_defaults(func=cmd_files)

    p = sub.add_parser("symbols", help="triage one file (rung 4)")
    p.add_argument("file")
    p.set_defaults(func=cmd_symbols)

    args = parser.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
