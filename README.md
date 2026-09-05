# Skill Sets

Portable AI skills. Copy a folder into a project or into your user skills directory, then reuse it.

## Skills

| Skill | Use when |
| --- | --- |
| [clean-programming](skills/clean-programming/SKILL.md) | Writing, reviewing, or refactoring code. Enforces clean, self-documenting, modular English code, runs safe in-project commands without asking, and keeps replies on the main problem. |

## Install `clean-programming`

**This Cursor project**

```powershell
New-Item -ItemType Directory -Force -Path .cursor/skills | Out-Null
Copy-Item -Recurse -Force skills/clean-programming .cursor/skills/clean-programming
Copy-Item -Force skills/clean-programming/RULE.template.mdc .cursor/rules/clean-programming.mdc
```

Create `.cursor/rules` first if needed. The rule makes the skill apply in every chat.

**All Cursor projects (user skills)**

```powershell
New-Item -ItemType Directory -Force -Path "$HOME/.cursor/skills" | Out-Null
Copy-Item -Recurse -Force skills/clean-programming "$HOME/.cursor/skills/clean-programming"
```

Do not copy into `~/.cursor/skills-cursor/` — that folder is reserved.

**Claude Code / other agents that read `SKILL.md`**

Copy `skills/clean-programming` into that tool's skills path.

## Add another skill later

Create `skills/<skill-name>/SKILL.md` with YAML `name` and `description`, then add a row to the table above.
