#!/usr/bin/env python3
import json
import re
import sys
from pathlib import Path


def patterns(root: Path) -> list[str]:
    lines = (root / "install" / "ai-ignore.patterns").read_text(encoding="utf-8").splitlines()
    return [line.strip() for line in lines if line.strip() and not line.strip().startswith("#")]


def block(items: list[str]) -> str:
    return "# BEGIN skill-sets-god\n" + "\n".join(items) + "\n# END skill-sets-god\n"


def merge_file(path: Path, body: str) -> None:
    text = path.read_text(encoding="utf-8") if path.exists() else ""
    rx = re.compile(r"# BEGIN skill-sets-god\r?\n.*?# END skill-sets-god\r?\n", re.S)
    if rx.search(text):
        text = rx.sub(body, text, count=1)
    else:
        if text and not text.endswith("\n"):
            text += "\n"
        if text.strip():
            text += "\n"
        text += body
    path.write_text(text, encoding="utf-8")


def global_glob(pattern: str) -> str:
    raw = pattern.strip()
    is_dir = raw.endswith("/")
    name = raw.rstrip("/")
    if name.startswith("**/"):
        return name
    if is_dir:
        return f"**/{name}/**"
    return f"**/{name}"


def cursor_settings_path() -> Path | None:
    home = Path.home()
    candidates = [
        home / "Library/Application Support/Cursor/User/settings.json",
        home / ".config/Cursor/User/settings.json",
        Path.home() / "AppData/Roaming/Cursor/User/settings.json",
    ]
    for path in candidates:
        if path.is_file():
            return path
    return None


def merge_cursor_global(items: list[str]) -> None:
    path = cursor_settings_path()
    if path is None:
        print("skip cursor global (settings.json not found)")
        return
    data = json.loads(path.read_text(encoding="utf-8-sig"))
    key = "cursor.general.globalCursorIgnoreList"
    existing = list(data.get(key) or [])
    for glob in (global_glob(item) for item in items):
        if glob not in existing:
            existing.append(glob)
    data[key] = existing
    path.write_text(json.dumps(data, indent=4) + "\n", encoding="utf-8")
    print(f"ok cursor global {path} ({len(items)} patterns)")


def main() -> None:
    root = Path(sys.argv[1])
    target = Path(sys.argv[2]) if len(sys.argv) > 2 and sys.argv[2] else Path.cwd()
    items = patterns(root)
    if not items:
        raise SystemExit("No ignore patterns")
    if not target.is_dir():
        raise SystemExit(f"Not a directory: {target}")
    body = block(items)
    for name in (".cursorignore", ".geminiignore", ".antigravityignore"):
        dest = target / name
        merge_file(dest, body)
        print(f"ok ignore {dest}")
    merge_cursor_global(items)


if __name__ == "__main__":
    main()
