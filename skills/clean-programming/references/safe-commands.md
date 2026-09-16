# Safe Commands

In the current project, run every safe command immediately. Do not ask.

Do not write "Should I run…?", "I can run… if you want", or wait for approval in chat.

## Safe — run now, no question

Any command that stays inside this project and does not destroy work:

- Read and search: list files, read files, `rg`, `find`, `git status`, `git diff`, `git log`, `git show`, `git branch`.
- Quality: format, lint, typecheck, analyze, compile.
- Tests: unit, widget, integration, e2e already defined in the project.
- Project tooling: install **declared** dependencies, generate code the project already uses, run the project's test/dev/build scripts.
- Local process control already used by the project: start/stop the dev app, hot reload, read logs of this app.
- Creates and edits the user asked for: new files, folders, and refactors **inside** the project root.

After you change code, run the matching checks yourself (typecheck/lint/tests). Treat that as part of the task, not an extra ask.

## Unsafe — ask once, or refuse

Stop and ask (or refuse if harmful) before:

- Destructive git: `push --force`, `reset --hard`, `checkout --` that discards edits, `clean -fdx`.
- Changing git config.
- Deleting files the user did not ask to delete, especially bulk delete.
- Commands that leave the project root and change the machine.
- Production deploy, dropping or wiping databases, mutating shared/staging data.
- Touching secrets, credentials, `.env` production values, or private keys.
- Installing unsolicited global tools or undeclared dependencies (ask first).
- Skipping hooks or signing (`--no-verify`, `--no-gpg-sign`) unless the user asked.

When you must ask, show the exact command and why it is unsafe. One question, then wait.

## How to run

- Prefer the project's existing scripts (`npm test`, `dart test`, `make lint`) over ad-hoc commands.
- Prefer the dedicated MCP/tool for the stack when one is available (for example Dart/Flutter MCP over raw shell).
- If a safe command fails, fix the cause and rerun. Do not ask whether to rerun a safe check.
