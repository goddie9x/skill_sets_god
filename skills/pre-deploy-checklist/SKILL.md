---
name: pre-deploy-checklist
description: >-
  Before deploying to production (especially with no staging server), run
  the 5-line pre-deploy checklist: what changed, how to verify, how to
  roll back, cache invalidation, and blast radius. Use before every
  production deploy, merge to main, or release push.
---

# Pre-Deploy Checklist

No staging server is not an excuse to skip checks. A 5-line checklist catches most "oops" deploys. Run it before every production deploy.

## The checklist

1. **What changed?** — one-line summary of what's in this deploy (commits, migrations, env changes).
2. **How do I verify?** — the exact URL, command, or check that proves the deploy worked. "It should be fine" is not verification.
3. **How do I roll back?** — the exact command or step that undoes this deploy (previous release, git revert, restart the old process).
4. **Cache?** — what must be invalidated after deploy (CDN/Cloudflare cache, service worker, ISR). Purge the HTML entry points per the deploy cache rule.
5. **Who is affected if it breaks?** — blast radius, and whether anyone needs a heads-up before you ship.

## Rules

- If you cannot answer #3 (rollback), do not deploy. Fix that first.
- Migrations: confirm they are backward-compatible or have a down path before deploying.
- After deploy, run the verification from #2 immediately. Do not assume.
- Log the deploy (what / when / result) so the next debug session starts with facts, not guesses.
