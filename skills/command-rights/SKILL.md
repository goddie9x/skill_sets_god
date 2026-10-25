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

## Skills advise, checks enforce (AI-native SDLC)

A skill is an advisory control: it makes the agent likely to follow a
policy while writing code, but nothing forces a session to comply with
it. A policy that must always hold needs a deterministic layer behind
the skill — a script, a hook, or a review pass that re-checks it.
Apply that split deliberately:

- **Advisory (skill text is enough):** conventions, style, preferred
  patterns — violations are visible in review and cheap to fix.
- **Enforced (script/hook/check required):** protected paths that must
  not be edited, secrets that must not enter a diff, test files during
  a fix task, production gates. If no check exists yet, say so and
  propose one instead of pretending the skill text enforces it.
- **A block must explain itself.** When a check stops an action, the
  message must name the rule and the route to approval — a silent or
  cryptic block just gets worked around.
- **Approval prompts belong at gates, not in the inner loop.** A
  prompt on every edit puts a human back on the critical path of every
  session. Reserve human approval for the deploy/production gate (see
  `pre-deploy-checklist`).

## Deploy pipeline and production behavior (learned 2026-10-06, my-digital-space incident)

- **CI/workflow files are off-limits without explicit permission.** Never modify
  `.github/workflows/*` or any deploy pipeline config on your own — the pipeline
  is the user's domain. (Broke this once by adding a `TypeCheck` step to
  `nextjs.yml` unasked; had to revert.)
- **Never change production rendering/caching behavior on theory alone.**
  Switching `force-dynamic` → ISR/`revalidate` broke the live homepage, menu,
  and sitemap because MongoDB is unreachable at build time on the CI runner —
  the DAL's `catch { return null }` caused empty pages to be prerendered and
  cached. Rule: verify the infrastructure assumption (DB reachable during build?
  who serves the prerender?) before applying any "optimization" to production
  rendering. When in doubt, ask the user first — they know their infra.
- **New env vars are a deploy-time contract.** Adding a `process.env.X` the
  server doesn't have can break auth/email on the next deploy. Prefer existing
  variable names; if a new one is truly needed, flag it to the user BEFORE
  pushing so they can set it on the server.
- **Never rename env vars or change their default values on your own.**
  Keep the existing keywords (`JWT_SECRET`, `QSTASH_TOKEN`, …) and their
  fallbacks exactly as they are. If a default looks wrong, ask the user —
  don't "fix" it silently.
