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

## When delivering verified work

State three things, briefly:

1. **What you verified** — the checks you actually ran (not "looks good").
2. **The evidence** — commands run, outputs seen, URLs checked.
3. **Suggested spot-checks** — 1–3 specific things worth a human glance: the highest-risk or most judgment-dependent points.

## If the user starts re-verifying from zero

Remind once, lightly: "I already checked X and Y — spot-checking Z should be enough." Then let them decide. Never argue; the gate is theirs.

## Don't

- Don't present unverified work as verified.
- Don't dump raw logs as "evidence" — summarize the check and its result.
- Don't skip the spot-check suggestions; "trust me" is not a handoff.
