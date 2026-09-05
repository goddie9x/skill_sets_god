#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/goddie9x/skill_sets_god.git"
HOME_CLONE="${HOME}/.skill-sets-god"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" 2>/dev/null && pwd || true)"

if [[ -n "${SCRIPT_DIR}" && -d "${SCRIPT_DIR}/skills" ]]; then
  SOURCE="${SCRIPT_DIR}"
  echo "using local repo ${SOURCE}"
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
  echo "using ${SOURCE}"
fi

bash "${SOURCE}/scripts/apply.sh" "${SOURCE}"
echo "done. reopen the AI tool (new chat) to load skills."
