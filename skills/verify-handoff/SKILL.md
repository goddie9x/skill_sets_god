---
name: verify-handoff
description: >-
  When handing over work you already verified, state what was checked and
  suggest spot-checks instead of full re-verification. If the user starts
  re-verifying from scratch, remind them gently once. Use after completing
  any verified task: deploys, code changes, content, data work.
---

# Verify-Handoff

The user verifies technical claims independently and will re-check your work. That is good — but full re-verification of already-verified work is double work. Hand over verification cleanly so a spot-check is enough.

## Golden rule: test before you report

**Never report work as "done" or "successful" without testing it first.** This is non-negotiable.

For every task:
1. **Make the change** — code, config, data, etc.
2. **Test it** — run the actual verification: build, typecheck, API call, live site check, etc.
3. **Confirm it works** — see the expected result with your own eyes/tools.
4. **Then report** — only after steps 1-3 succeed.

If you cannot test (e.g. need user action, external service down), say so explicitly: "Code xong, chưa test được vì X — bro test giúp nhé" instead of "Xong rồi!".

## When delivering verified work

State three things, briefly:

1. **What you verified** — the checks you actually ran (not "looks good").
2. **The evidence** — commands run, outputs seen, URLs checked.
3. **Suggested spot-checks** — 1–3 specific things worth a human glance: the highest-risk or most judgment-dependent points.

## Review passes before handover (AI-native SDLC)

Before handing over, review your own diff in three passes — the same
passes an external reviewer would run, so the human gate can judge
intent and risk instead of re-doing mechanical review:

1. **Bugs** — logic errors, broken edge cases, subtle regressions.
2. **Security** — injection risks, authentication gaps, secrets or
   personal data in logs and error messages.
3. **Compliance** — the change matches the approved plan and the
   original intent, and follows the project's design principles.

Tag each finding **Important** (would break behavior, leak data, or
breach a policy) or **Nit** (style, naming). Report at most five
nits; summarize the rest as a count. Skip generated files and
anything CI already enforces.

Two rules that do not bend:

- **Writer ≠ approver.** Your own findings never approve your own
  work. The human gate (or a fresh reviewer) decides; you report.
- **Feed findings back.** When a review flags the same mistake a
  second time, the correction goes into the project's
  institutional-knowledge file — that is how the next review catches
  it before it happens.

## If the user starts re-verifying from zero

Remind once, lightly: "I already checked X and Y — spot-checking Z should be enough." Then let them decide. Never argue; the gate is theirs.

## Don't

- Don't present unverified work as verified.
- Don't dump raw logs as "evidence" — summarize the check and its result.
- Don't skip the spot-check suggestions; "trust me" is not a handoff.
