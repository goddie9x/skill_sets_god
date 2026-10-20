#!/usr/bin/env python3
"""Context Compactor helper — stdlib only.

Subcommands:
  measure    Estimate tokens for files / stdin, compare against a
             self-declared max context and a threshold (default 70%).
  filemap    Scan a project tree and emit a one-line-per-file map:
             path | lines | language | key symbols | first doc line.
  crush-log  Deterministically shrink a long log / tool output:
             dedupe repeated lines with counts, keep unique error
             lines verbatim, keep head and tail.
  init       Create CONTEXT-COMPACT.md in a project from the bundled
             template and add it to that project's .gitignore.
  check      Verify a CONTEXT-COMPACT.md: required sections present,
             every must-keep fact from a facts file present verbatim,
             and report the compression ratio vs the source files.

Token counts are estimates unless the optional `tiktoken` package is
installed (then cl100k_base is used). The estimate is chars/4 rounded
up, the standard rough heuristic for mixed code + prose. Estimates are
for trigger decisions, not billing.
"""

import argparse
import ast
import math
import os
import re
import sys
from collections import Counter

DEFAULT_THRESHOLD = 0.70
COMPACT_FILENAME = "CONTEXT-COMPACT.md"
GITIGNORE_BLOCK = (
    "# context-compactor (local session state, never commit)\n"
    "CONTEXT-COMPACT.md\n"
    ".context-compact/\n"
)

REQUIRED_SECTIONS = [
    "## 1. Goal",
    "## 2. Decisions (verbatim)",
    "## 3. Open tasks",
    "## 4. Next step",
    "## 5. File map",
    "## 6. User preferences and corrections (verbatim)",
    "## 7. Errors and evidence",
    "## 8. Session state",
]

SKIP_DIRS = {
    ".git", "node_modules", ".next", "dist", "build", "out", "target",
    "__pycache__", ".venv", "venv", ".cache", "coverage", ".turbo",
    "vendor", "Pods", ".dart_tool", ".gradle",
}
BINARY_EXTS = {
    ".png", ".jpg", ".jpeg", ".gif", ".webp", ".ico", ".pdf", ".zip",
    ".gz", ".tar", ".exe", ".dll", ".so", ".dylib", ".woff", ".woff2",
    ".mp3", ".mp4", ".mov", ".bin", ".lock",
}


def estimate_tokens(text):
    """Return (tokens, method). Uses tiktoken when available."""
    try:
        import tiktoken

        enc = tiktoken.get_encoding("cl100k_base")
        return len(enc.encode(text)), "tiktoken/cl100k_base"
    except Exception:
        return math.ceil(len(text) / 4), "estimate chars/4"


def read_text(path):
    with open(path, "r", encoding="utf-8", errors="replace") as fh:
        return fh.read()


# ---------------------------------------------------------------- measure
def cmd_measure(args):
    sources = []
    if args.stdin:
        sources.append(("<stdin>", sys.stdin.read()))
    for path in args.paths:
        if os.path.isdir(path):
            for root, dirs, files in os.walk(path):
                dirs[:] = [d for d in dirs if d not in SKIP_DIRS]
                for name in sorted(files):
                    full = os.path.join(root, name)
                    if os.path.splitext(name)[1].lower() in BINARY_EXTS:
                        continue
                    try:
                        sources.append((full, read_text(full)))
                    except OSError:
                        pass
        else:
            sources.append((path, read_text(path)))

    if not sources:
        print("measure: nothing to measure (pass files/dirs or --stdin)")
        return 2

    total_tokens = 0
    method = None
    print(f"{'source':<60} {'chars':>10} {'tokens~':>10}")
    for name, text in sources:
        tokens, method = estimate_tokens(text)
        total_tokens += tokens
        if len(sources) <= 50:
            print(f"{name[:60]:<60} {len(text):>10} {tokens:>10}")
    print(f"{'TOTAL':<60} {'':>10} {total_tokens:>10}   ({method})")

    if args.max_context:
        pct = total_tokens / args.max_context
        limit = args.max_context * args.threshold
        print(
            f"max context (self-declared): {args.max_context} | "
            f"used: {pct:.1%} | threshold: {args.threshold:.0%} "
            f"({int(limit)} tokens)"
        )
        if total_tokens >= limit:
            print("VERDICT: COMPACT NOW — at or past the threshold.")
            return 10
        print("VERDICT: OK — under the threshold.")
    return 0


# ---------------------------------------------------------------- filemap
def python_symbols(text):
    try:
        tree = ast.parse(text)
    except SyntaxError:
        return [], ""
    symbols = []
    doc = (ast.get_docstring(tree) or "").splitlines()
    for node in tree.body:
        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
            symbols.append(f"fn {node.name}()")
        elif isinstance(node, ast.ClassDef):
            symbols.append(f"class {node.name}")
    return symbols, (doc[0] if doc else "")


def js_symbols(text):
    symbols = []
    patterns = [
        r"export\s+(?:default\s+)?function\s+([A-Za-z_$][\w$]*)",
        r"export\s+class\s+([A-Za-z_$][\w$]*)",
        r"export\s+const\s+([A-Za-z_$][\w$]*)\s*=",
        r"^function\s+([A-Za-z_$][\w$]*)",
        r"^class\s+([A-Za-z_$][\w$]*)",
    ]
    for line in text.splitlines():
        for pat in patterns:
            match = re.search(pat, line)
            if match:
                symbols.append(match.group(1))
                break
    return symbols[:12]


def first_meaningful_line(text):
    for line in text.splitlines():
        stripped = line.strip().strip("#/ *").strip()
        if stripped:
            return stripped[:100]
    return ""


def cmd_filemap(args):
    root = args.root
    rows = []
    for dirpath, dirs, files in os.walk(root):
        dirs[:] = [d for d in sorted(dirs) if d not in SKIP_DIRS]
        for name in sorted(files):
            full = os.path.join(dirpath, name)
            rel = os.path.relpath(full, root)
            ext = os.path.splitext(name)[1].lower()
            if ext in BINARY_EXTS:
                continue
            try:
                text = read_text(full)
            except OSError:
                continue
            if args.max_lines and text.count("\n") + 1 < 1:
                continue
            lines = text.count("\n") + (1 if text else 0)
            symbols, hint = [], ""
            if ext == ".py":
                symbols, hint = python_symbols(text)
            elif ext in (".js", ".jsx", ".ts", ".tsx", ".mjs", ".cjs"):
                symbols = js_symbols(text)
                hint = first_meaningful_line(text)
            elif ext == ".md":
                hint = first_meaningful_line(text)
            else:
                hint = first_meaningful_line(text)
            symbol_str = ", ".join(symbols[:8]) if symbols else "-"
            rows.append((rel, lines, ext.lstrip(".") or "?", symbol_str, hint))

    print("| File | Lines | Lang | Key symbols | Purpose / first doc line |")
    print("| --- | ---: | --- | --- | --- |")
    for rel, lines, lang, symbols, hint in rows:
        hint = hint.replace("|", "/")
        print(f"| `{rel}` | {lines} | {lang} | {symbols} | {hint} |")
    print(f"\n<!-- {len(rows)} files mapped under {root} -->")
    return 0


# ---------------------------------------------------------------- crush-log
ERROR_RE = re.compile(
    r"(error|fail|exception|traceback|warn|denied|timeout|refused)",
    re.IGNORECASE,
)


def cmd_crush_log(args):
    text = sys.stdin.read() if args.path == "-" else read_text(args.path)
    lines = text.splitlines()
    counts = Counter(lines)
    error_lines = []
    seen_err = set()
    for line in lines:
        if ERROR_RE.search(line) and line not in seen_err:
            seen_err.add(line)
            error_lines.append(line)

    head = lines[: args.head]
    tail = lines[-args.tail :] if args.tail else []
    repeated = [(ln, c) for ln, c in counts.most_common(args.top) if c > 1]

    out = []
    out.append(f"# crushed log: {len(lines)} lines, {len(counts)} unique")
    out.append("")
    out.append(f"## repeated lines (top {args.top}, count > 1)")
    for ln, c in repeated:
        out.append(f"- x{c}: {ln}")
    out.append("")
    out.append(f"## unique error/warning lines ({len(error_lines)}, verbatim)")
    for ln in error_lines:
        out.append(f"- {ln}")
    out.append("")
    out.append(f"## head ({len(head)} lines, verbatim)")
    out.extend(head)
    out.append("")
    out.append(f"## tail ({len(tail)} lines, verbatim)")
    out.extend(tail)
    result = "\n".join(out) + "\n"

    orig_tokens, _ = estimate_tokens(text)
    new_tokens, _ = estimate_tokens(result)
    sys.stdout.write(result)
    ratio = (new_tokens / orig_tokens * 100) if orig_tokens else 0
    print(
        f"<!-- tokens: {orig_tokens} -> {new_tokens} ({ratio:.1f}% kept) -->",
        file=sys.stderr,
    )
    return 0


# ---------------------------------------------------------------- init
def cmd_init(args):
    project = args.project
    target = os.path.join(project, COMPACT_FILENAME)
    template_path = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "..",
        "templates",
        COMPACT_FILENAME,
    )
    if os.path.exists(target) and not args.force:
        print(f"init: {target} already exists (use --force to overwrite)")
        return 2
    with open(template_path, "r", encoding="utf-8") as fh:
        template = fh.read()
    with open(target, "w", encoding="utf-8") as fh:
        fh.write(template)
    print(f"init: wrote {target}")

    gitignore = os.path.join(project, ".gitignore")
    existing = read_text(gitignore) if os.path.exists(gitignore) else ""
    if COMPACT_FILENAME not in existing:
        with open(gitignore, "a", encoding="utf-8") as fh:
            if existing and not existing.endswith("\n"):
                fh.write("\n")
            fh.write("\n" + GITIGNORE_BLOCK)
        print(f"init: added {COMPACT_FILENAME} to {gitignore}")
    else:
        print(f"init: {COMPACT_FILENAME} already in .gitignore")
    return 0


# ---------------------------------------------------------------- check
def cmd_check(args):
    compact = read_text(args.compact)
    problems = []

    for section in REQUIRED_SECTIONS:
        if section not in compact:
            problems.append(f"missing section: {section}")

    if args.facts:
        facts = [
            ln.strip() for ln in read_text(args.facts).splitlines() if ln.strip()
        ]
        missing = [f for f in facts if f not in compact]
        for fact in missing:
            problems.append(f"must-keep fact NOT present verbatim: {fact}")
        print(f"check: {len(facts) - len(missing)}/{len(facts)} facts present")

    compact_tokens, method = estimate_tokens(compact)
    print(f"check: compact file tokens~ {compact_tokens} ({method})")
    if args.sources:
        total = 0
        for path in args.sources:
            tokens, _ = estimate_tokens(read_text(path))
            total += tokens
        if total:
            print(
                f"check: sources tokens~ {total} -> compact {compact_tokens} "
                f"({compact_tokens / total:.1%} kept)"
            )

    if problems:
        print("check: FAIL")
        for problem in problems:
            print(f"  - {problem}")
        return 1
    print("check: PASS — all sections present, all facts preserved")
    return 0


def main(argv=None):
    parser = argparse.ArgumentParser(prog="context_compact")
    sub = parser.add_subparsers(dest="command", required=True)

    p = sub.add_parser("measure", help="estimate tokens vs a threshold")
    p.add_argument("paths", nargs="*", help="files or directories")
    p.add_argument("--stdin", action="store_true", help="also read stdin")
    p.add_argument(
        "--max-context",
        type=int,
        default=0,
        help="self-declared max context of your tool/model, in tokens",
    )
    p.add_argument("--threshold", type=float, default=DEFAULT_THRESHOLD)
    p.set_defaults(func=cmd_measure)

    p = sub.add_parser("filemap", help="one-line-per-file project map")
    p.add_argument("root", nargs="?", default=".")
    p.add_argument("--max-lines", type=int, default=0, help="reserved")
    p.set_defaults(func=cmd_filemap)

    p = sub.add_parser("crush-log", help="dedupe + shrink a long log")
    p.add_argument("path", help="log file, or - for stdin")
    p.add_argument("--head", type=int, default=20)
    p.add_argument("--tail", type=int, default=20)
    p.add_argument("--top", type=int, default=20)
    p.set_defaults(func=cmd_crush_log)

    p = sub.add_parser("init", help="create CONTEXT-COMPACT.md + gitignore it")
    p.add_argument("project", nargs="?", default=".")
    p.add_argument("--force", action="store_true")
    p.set_defaults(func=cmd_init)

    p = sub.add_parser("check", help="verify a compact file keeps everything")
    p.add_argument("compact", help="path to CONTEXT-COMPACT.md")
    p.add_argument(
        "--facts",
        help="file with one must-keep fact per line; each must appear "
        "verbatim in the compact file",
    )
    p.add_argument(
        "--sources",
        nargs="*",
        default=[],
        help="original files to compare token size against",
    )
    p.set_defaults(func=cmd_check)

    args = parser.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
