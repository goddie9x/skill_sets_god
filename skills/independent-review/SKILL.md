---
name: independent-review
description: >-
  Before reporting a deliverable done, have a separate independent subagent
  review and test it from scratch (never self-certify). Use for anything you
  produced — code, docs, artifacts, reports, test results — or anything the
  user asked you to test. Optional: needs multi-agent support; where
  unavailable, do a deliberate fresh-pass review yourself and say so.
---

# Independent review

Transparency + anti-hallucination: never self-certify your own deliverable.
A second, independent set of eyes checks the work before you report it done.

## When to use

- Anything you produced: code, docs, artifacts, reports, test results.
- Anything the user asked you to test or verify.
- Skip for: short answers, quick lookups, one-step chores.

## How

- Spawn ONE independent subagent with a brief containing:
  - The ORIGINAL requirements — not your summary of them.
  - Concrete, checkable acceptance criteria.
  - Explicit instruction: verify from scratch. Re-run the tests, re-read the
    code, re-check the live state. Do not trust the parent's conclusions;
    report only what was independently verified, with evidence.
- The subagent inherits your context, but still put everything it needs in
  the brief: file paths, commands, URLs, expected values. No credentials.
- Its result arrives as a handoff. Do not report the work done before it
  lands. A spawn receipt is not a review.

## If the reviewer disagrees with you

- Believe the evidence, not seniority. Re-investigate, fix, and re-verify;
  re-run the review if the fix was material.
- Report the disagreement and how it was resolved honestly to the user.
  A caught mistake is a win, not an embarrassment.

## When subagents are unavailable

- This skill is optional by design: not every environment supports multiple
  agents. Never block the work waiting for a capability that does not exist.
- Fallback: do the review yourself as a deliberate fresh pass — re-read the
  original requirements, re-run every check from scratch, and explicitly list
  what you re-verified versus what you could not. Say plainly that no
  independent review was possible.
