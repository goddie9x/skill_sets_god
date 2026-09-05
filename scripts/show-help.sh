#!/usr/bin/env bash
set -euo pipefail
SOURCE_ROOT="${1:?source root required}"
LIST_ONLY="${2:-}"

if [[ "${LIST_ONLY}" != "list" ]]; then
  cat <<'EOF'
Skill Sets installer

Usage:
  ./install.sh [--bundle <id>] [--policy <id>[,<id>...]] [--skill <name>] [--list] [--help]
  .\install.ps1 [-Bundle <id>] [-Policy <id>[,<id>...]] [-Skill <name>...] [-List] [-Help]

Default: --bundle basic --policy safe-run

Examples:
  ./install.sh
  ./install.sh --bundle basic --policy ship
  ./install.sh --policy autopilot
  ./install.sh --policy safe-test
  ./install.sh --bundle none --skill clean-programming
  ./install.sh --list
  ./install.sh --help

After the first clone:
  ~/.skill-sets-god/install.sh --bundle basic --policy autopilot

EOF
fi

python3 - "${SOURCE_ROOT}" <<'PY'
import json, sys
from pathlib import Path
root = Path(sys.argv[1])

def show(title, path, key, extra_key):
    print(title)
    data = json.loads(path.read_text(encoding="utf-8"))[key]
    for row in data:
        extra = ", ".join(row.get(extra_key) or ([row.get("skillsDir")] if row.get("skillsDir") else []))
        print(f"  {row['id']:<12} {row.get('description', '')} [{extra}]")

show("Bundles", root / "install/bundles.json", "bundles", "skills")
print()
show("Policies (clusters)", root / "install/policies.json", "policies", "grants")
print()
print("Skills")
for path in sorted((root / "skills").iterdir()):
    if path.is_dir() and (path / "SKILL.md").is_file():
        print(f"  {path.name}")
print()
show("Targets", root / "install/targets.json", "targets", "detect")
PY
