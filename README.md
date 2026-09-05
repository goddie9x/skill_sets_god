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

That clones or pulls `~/.skill-sets-god`, then applies every skill to:

- **Cursor** — always (`~/.cursor/skills` + always-apply rules)
- **Claude / Codex / Copilot / Gemini** — only if that tool is already on the machine

Open a new chat after install.

From this repo (apply local files, no clone):

```powershell
.\install.ps1
```

## Add a tool later

Add one object to `install/targets.json`, then rerun the install command.

| Field | Meaning |
| --- | --- |
| `id` | Label in the log |
| `always` | Apply even if the tool folder is missing |
| `detect` | Home-relative folders that mean the tool is installed |
| `skillsDir` | Home-relative skills path |
| `rulesDir` | Optional. Copies each skill's `RULE.template.mdc` here |

## Skills

| Skill | Use when |
| --- | --- |
| [clean-programming](skills/clean-programming/SKILL.md) | Writing, reviewing, or refactoring code. Enforces clean, self-documenting, modular English code, runs safe in-project commands without asking, and keeps replies on the main problem. |
| [pre-task-split](skills/pre-task-split/SKILL.md) | Start of a new task. List only accuracy (code-verified), judgment, and missing facts — then stop until the user confirms. |

## Add another skill

Create `skills/<skill-name>/SKILL.md` with YAML `name` and `description`. Add a row above. Rerun install.

Do not put skills in `~/.cursor/skills-cursor/` — that folder is reserved.
