# Skill Sets

Portable AI skills. One command on a new machine. Re-run the same command to update.

## New machine

Needs Git.

**Windows**

```powershell
irm https://raw.githubusercontent.com/goddie9x/skill_sets_god/main/install.ps1 | iex
```

**macOS / Linux**

```bash
curl -fsSL https://raw.githubusercontent.com/goddie9x/skill_sets_god/main/install.sh | bash
```

Default: bundle `basic`, policy `safe-run`. Applies to Cursor always, and to Claude / Codex / Copilot / Gemini when that tool is on the machine.

Open a new chat after install.

## Options

```powershell
.\install.ps1 -Help
.\install.ps1 -List
.\install.ps1 -Bundle basic -Policy ship
.\install.ps1 -Policy autopilot
.\install.ps1 -Bundle none -Skill clean-programming
```

```bash
./install.sh --help
./install.sh --list
./install.sh --bundle basic --policy ship
./install.sh --policy autopilot
./install.sh --bundle none --skill clean-programming
```

After the first clone:

```powershell
& "$HOME\.skill-sets-god\install.ps1" -Bundle basic -Policy autopilot
```

### Bundles

| Id | Skills |
| --- | --- |
| `basic` | clean-programming, pre-task-split, command-rights (default) |
| `none` | none — pair with `-Skill` |

### Policies (clusters)

| Id | Grants |
| --- | --- |
| `safe-run` | safe-commands (default) |
| `review` | auto-review |
| `commit` | auto-commit |
| `push` | auto-push |
| `ship` | review + commit + push |
| `autopilot` | safe-run + ship |

Combine clusters: `-Policy safe-run,ship` or `--policy safe-run --policy ship`.

Config is written to `~/.skill-sets-god/config.json`. Cursor also gets `~/.cursor/rules/command-rights.mdc`.

## Add a tool later

Add one object to `install/targets.json`, then rerun install.

| Field | Meaning |
| --- | --- |
| `id` | Label in the log |
| `always` | Apply even if the tool folder is missing |
| `detect` | Home-relative folders that mean the tool is installed |
| `skillsDir` | Home-relative skills path |
| `rulesDir` | Optional. Copies each skill's `RULE.template.mdc` here |

Add a bundle in `install/bundles.json`. Add a policy cluster in `install/policies.json`.

## Skills

| Skill | Use when |
| --- | --- |
| [clean-programming](skills/clean-programming/SKILL.md) | Writing, reviewing, or refactoring code. Enforces clean, self-documenting, modular English code, runs safe in-project commands without asking, and keeps replies on the main problem. |
| [pre-task-split](skills/pre-task-split/SKILL.md) | Start of a new task. List only accuracy (code-verified), judgment, and missing facts — then stop until the user confirms. |
| [command-rights](skills/command-rights/SKILL.md) | Honor the installed policy grants for safe-run, review, commit, and push. |

## Add another skill

Create `skills/<skill-name>/SKILL.md` with YAML `name` and `description`. Add a row above. Add it to a bundle or pass `-Skill`. Rerun install.

Do not put skills in `~/.cursor/skills-cursor/` — that folder is reserved.
