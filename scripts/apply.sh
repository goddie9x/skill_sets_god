#!/usr/bin/env bash
set -euo pipefail

SOURCE_ROOT="${1:?source root required}"
SKILLS_ROOT="${SOURCE_ROOT}/skills"
TARGETS_PATH="${SOURCE_ROOT}/install/targets.json"

[[ -d "${SKILLS_ROOT}" ]] || { echo "No skills folder at ${SKILLS_ROOT}" >&2; exit 1; }
[[ -f "${TARGETS_PATH}" ]] || { echo "Missing ${TARGETS_PATH}" >&2; exit 1; }

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required to read install/targets.json" >&2
  exit 1
fi

link_skill() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "${dest}")"
  rm -rf "${dest}"
  if ln -s "${src}" "${dest}" 2>/dev/null; then
    echo "link"
  else
    cp -R "${src}" "${dest}"
    echo "copy"
  fi
}

python3 - "${SOURCE_ROOT}" <<'PY' | while IFS=$'\t' read -r action dest src extra; do
import json, sys
from pathlib import Path

root = Path(sys.argv[1])
home = Path.home()
skills = [p for p in (root / "skills").iterdir() if p.is_dir() and (p / "SKILL.md").is_file()]
spec = json.loads((root / "install/targets.json").read_text(encoding="utf-8"))
for target in spec["targets"]:
    detect = target.get("detect") or []
    active = bool(target.get("always")) or any((home / rel).exists() for rel in detect if rel)
    if not active:
        print(f"skip\t{target['id']}\t\t")
        continue
    for skill in skills:
        dest = home / target["skillsDir"] / skill.name
        print(f"skill\t{dest}\t{skill}\t{target['id']}")
        rules_dir = target.get("rulesDir")
        rule_src = skill / "RULE.template.mdc"
        if rules_dir and rule_src.is_file():
            print(f"rule\t{home / rules_dir / (skill.name + '.mdc')}\t{rule_src}\t{target['id']}")
PY
  case "${action}" in
    skip)
      echo "skip ${dest} (tool not on this machine)"
      ;;
    skill)
      mode="$(link_skill "${src}" "${dest}")"
      echo "ok ${extra} $(basename "${src}") (${mode})"
      ;;
    rule)
      mkdir -p "$(dirname "${dest}")"
      cp "${src}" "${dest}"
      echo "ok ${extra} rule $(basename "${dest}" .mdc)"
      ;;
  esac
done
