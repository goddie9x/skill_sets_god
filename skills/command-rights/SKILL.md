---
name: command-rights
description: >-
  Honor the machine command-rights policy: safe-run, safe-test,
  auto-review, auto-commit, and auto-push. Use when running shell,
  tests, or git commands, committing, pushing, reviewing a diff, or
  deciding whether to ask the user before a command.
---

# Command Rights

Read `$HOME/.skill-sets-god/config.json`. Only the listed `grants` are on.

Grant details: [grants.md](references/grants.md).

If that file is missing, treat grants as `safe-commands` only.

## Hard stops (always)

- No `push --force` to main/master.
- No `reset --hard`, hook skip, or git config edits unless the user asked.
- No commit of secrets (`.env`, keys, credentials).
- Ask once before any unsafe command, even when grants are on.
