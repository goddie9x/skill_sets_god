#!/usr/bin/env bash
set -euo pipefail

SOURCE_ROOT=""
BUNDLE="basic"
POLICIES=()
SKILLS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source) SOURCE_ROOT="${2:?}"; shift 2 ;;
    --bundle) BUNDLE="${2:?}"; shift 2 ;;
    --policy) POLICIES+=("${2:?}"); shift 2 ;;
    --skill) SKILLS+=("${2:?}"); shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

[[ -n "${SOURCE_ROOT}" ]] || { echo "--source is required" >&2; exit 1; }

args=(--source "${SOURCE_ROOT}" --bundle "${BUNDLE}")
if [[ ${#POLICIES[@]} -eq 0 ]]; then
  args+=(--policy safe-run)
else
  for policy in "${POLICIES[@]}"; do args+=(--policy "${policy}"); done
fi
for skill in "${SKILLS[@]+"${SKILLS[@]}"}"; do
  args+=(--skill "${skill}")
done

python3 "${SOURCE_ROOT}/scripts/apply-core.py" "${args[@]}"
