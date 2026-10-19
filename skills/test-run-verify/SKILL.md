---
name: test-run-verify
description: >-
  Testing discipline: always RUN tests after writing them (writing test files
  is not testing), and verify web apps against the real deployed site — not
  just localhost. Use after any code change, before push/merge, and after
  every deploy.
---

# Test-Run-Verify

Writing test files is not testing. A test you never ran proves nothing.
A green CI badge is not proof the live site works.

## Rule 1: Run the tests. Every time.

After writing or changing code:

1. Write or update tests covering the change.
2. **Run them.** Watch the actual output — do not assume.
3. Report real numbers: `12/12 passed`, `76/76 passed`. Never "should pass",
   "looks fine", or a pass count from before your last edit.

Moments that require a test run, no exceptions:

- New feature or bugfix code written
- Test files added or modified
- Before every push or merge to main/master
- After resolving a merge conflict

If the repo has no test setup, say so explicitly and do a manual
verification instead — never silently skip. If tests fail, fix or report;
do not push over red.

## Rule 2: Web apps get verified on the live deployment

Local passing is not production working. After every web deploy:

1. Confirm the deployed version is the one you shipped
   (`/api/version`, `/version.json`, or equivalent — compare the hash).
2. Purge CDN cache for HTML entry points if frontend assets changed
   (see the `cloudflare` skill — standing rule, do it autonomously).
3. Test the actual user-facing behavior in a browser against the **live URL**.
   Not localhost. Not a dev screenshot. The real site, as a user sees it.

When you **cannot test locally** (no local env, device-specific behavior,
auth-gated flows, mobile viewport quirks) — the live deployment IS the
test environment. Do not ship and hope; deploy, then verify live.

## What "verified" means in a report

- Tests: the command you ran + pass/fail counts.
  ("`npm test` → 76/76 passed", not "tests pass")
- Live web: the URL checked + what you observed.
  ("tuxian.hmt9x.dev loads, version 75fc8db, login works on mobile viewport")
- Anything you could not verify gets named explicitly:
  "chưa verify X vì Y" — never implied, never omitted.

## Rule 3: Static checks are not runtime verification

`node --check`, `tsc --noEmit`, linters — these catch syntax and types,
not behavior. A file can pass every static check and still be broken
at runtime (lesson 2026-10-13: `node --check` passed a bookmark-cleaner
file that had an ESM syntax error only visible on real import).

- After any static check passes, verify with the real runtime:
  actually import/run the module, actually render the page.
- For UI: static code review never replaces opening the real browser
  and interacting with real mouse operations.

## Don't

- Don't write tests and call it done without running them.
- Don't treat a passing static check (`node --check`, lint) as proof
  the code works — run it in the real runtime.
- Don't report a pass count from before your latest edit.
- Don't verify a web app only on localhost when a live deployment exists.
- Don't claim "deployed successfully" from a green pipeline alone —
  check the live site actually responds.
- Don't let "I'll test it later" survive the turn. Test now or state
  exactly what is unverified and why.
