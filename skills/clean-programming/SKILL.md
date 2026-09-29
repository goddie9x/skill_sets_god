---
name: clean-programming
description: >-
  Enforce clean, self-documenting, modular English code, run safe
  in-project commands without asking, and answer only the main problem.
  Use when writing, reviewing, refactoring, generating, or fixing any
  code; when splitting files, classes, or functions; when deciding
  which files to read; when deciding whether to comment; when running
  tests, lint, format, typecheck, build, git, or other local project
  commands; when drafting any reply.
---

# Clean Programming

Apply these rules on every coding task in the current project.

1. **Clean code** — intent lives in names and structure. See [clean-code.md](references/clean-code.md).
2. **Self-documenting** — almost no comments; the code explains itself. See [self-documenting.md](references/self-documenting.md).
3. **Safe commands run now** — never ask to run a safe command in this project. See [safe-commands.md](references/safe-commands.md).
4. **Small units** — split files, classes, and functions early. See [modular-size.md](references/modular-size.md).
5. **English** — all code artifacts are English. See [language.md](references/language.md).
6. **Focused replies** — drop extra talk; solve only the main problem. See [focused-replies.md](references/focused-replies.md).
7. **Related files only** — search to find them, then read those files. Do not read the whole project. See [modular-size.md](references/modular-size.md).

If a project convention is stricter, follow the project. If it is looser, follow this skill.

## Workflow

1. Search for the files that own the change. Read only those files. Create a new small module if none fits.
2. Write code that compiles, names intent, and needs no narration.
3. Split any unit that hits the limits in [modular-size.md](references/modular-size.md) before finishing.
4. Run the relevant safe commands immediately (typecheck, lint, format, tests).
5. Leave the tree compiling, with no leftover comments, dead code, or commented-out blocks.

## Hard stops

- Do not ship a function, class, or file over the hard limits.
- Do not add comments that restate what the code does.
- Do not ask permission for commands listed as safe.
- Do not use non-English identifiers, comments, commits, or docs.
- Do not pad replies with recap, options, or process the user did not need.
- Do not open or read the whole project. Read only files tied to the current task.

## Examples

Before/after samples: [examples.md](references/examples.md).
