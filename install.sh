#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/goddie9x/skill_sets_god.git"
HOME_CLONE="${HOME}/.skill-sets-god"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" 2>/dev/null && pwd || true)"

HELP=0
LIST=0
BUNDLE="basic"
POLICIES=()
SKILLS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) HELP=1; shift ;;
    --list) LIST=1; shift ;;
    --bundle) BUNDLE="${2:?}"; shift 2 ;;
    --policy) POLICIES+=("${2:?}"); shift 2 ;;
    --skill) SKILLS+=("${2:?}"); shift 2 ;;
    *) echo "Unknown option: $1" >&2; echo "Try: ./install.sh --help" >&2; exit 1 ;;
  esac
done

if [[ -n "${SCRIPT_DIR}" && -d "${SCRIPT_DIR}/skills" ]]; then
  SOURCE="${SCRIPT_DIR}"
else
  if ! command -v git >/dev/null 2>&1; then
    echo "git is required. Install Git, then rerun." >&2
    exit 1
  fi
  if [[ -d "${HOME_CLONE}/.git" ]]; then
    git -C "${HOME_CLONE}" pull --ff-only
  elif [[ -e "${HOME_CLONE}" ]]; then
    echo "${HOME_CLONE} exists and is not a git clone" >&2
    exit 1
  else
    git clone "${REPO_URL}" "${HOME_CLONE}"
  fi
  SOURCE="${HOME_CLONE}"
fi

echo "using ${SOURCE}"

if [[ "${HELP}" -eq 1 ]]; then
  bash "${SOURCE}/scripts/show-help.sh" "${SOURCE}"
  exit 0
fi
if [[ "${LIST}" -eq 1 ]]; then
  bash "${SOURCE}/scripts/show-help.sh" "${SOURCE}" list
  exit 0
fi

apply_args=(--source "${SOURCE}" --bundle "${BUNDLE}")
if [[ ${#POLICIES[@]} -gt 0 ]]; then
  for policy in "${POLICIES[@]}"; do apply_args+=(--policy "${policy}"); done
fi
for skill in "${SKILLS[@]+"${SKILLS[@]}"}"; do
  apply_args+=(--skill "${skill}")
done

bash "${SOURCE}/scripts/apply.sh" "${apply_args[@]}"
echo "done. reopen the AI tool (new chat) to load skills."
