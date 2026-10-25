---
name: ai-native-sdlc-optional
description: >-
  The enterprise half of Anthropic's AI-native SDLC playbook: formal
  intent/spec/plan file chain for every change, continuous evals in CI,
  managed PR review, managed settings and sandbox allowlists,
  non-interactive pipeline agents, deterministic metric bands, scheduled
  security scans, and tagged on-call agents. OPTIONAL — not in the basic
  bundle. Use only when the team scale, CI budget, and enterprise
  infrastructure exist to support it; the portable half already lives
  in the basic skills. Install with --bundle basic --skill
  ai-native-sdlc-optional.
---

# AI-Native SDLC (Optional)

This skill is the part of Anthropic's AI-native SDLC playbook that is
*not* in the default install. It is here so a growing team has the
checklist ready — and so a solo workflow does not pay enterprise
overhead for enterprise controls it cannot enforce.

Source: Anthropic, "The AI-native SDLC playbook"
(https://academy.claude.com/courses/ai-native-sdlc-playbook and
https://claude.com/blog/the-ai-native-sdlc-playbook). Full summary:
the author's private learning repo, `sources/anthropic-ai-native-sdlc-playbook.md`.
The portable half of the same playbook is already sprinkled into the
basic skills (`pre-task-split`, `clean-programming`,
`test-run-verify`, `verify-handoff`, `command-rights`,
`pre-deploy-checklist`, `doc-prerequisites`, `context-compactor`) —
do not duplicate it here; this skill adds only what those do not cover.

## Adoption order

Start with any "clay" play — one nothing points into, so it needs
nothing first (intent capture, the project knowledge file, skills,
the feedback loop). For any other play, adopt its dependencies first:

intent.md → spec.md → plan mode → feedback loop → PR review →
hooks as gates → CI/CD agents → closing the loop on metrics.

Do not jump to pipeline agents or autonomous maintenance before the
review gate and the hooks exist: automation accelerates whatever is
already through the gates, including mistakes.

## 1. Formal artifact chain for every change

The light form in `pre-task-split` (split → plan → diff → review) is
enough for most work. The formal form is for regulated or
multi-team work, where the audit trail itself is a deliverable:

- Every change has `intent.md` (originator's own words: problem,
  outcome, affected users/systems, constraints, open questions),
  `spec.md` (requirements + design, policy skills applied, concerns
  flagged), and `plan.md` (files, order, tests, risks, proof) — each
  committed, each approved by a named human before the next starts.
- Acceptance of one artifact is the trigger for the next stage
  (merge of `intent.md` starts the spec pass; acceptance of `spec.md`
  starts plan mode; a merged PR starts the pipeline).
- Name one system of truth per artifact when legacy systems exist
  (Jira, ServiceNow, a requirements tool): either the repo is
  authoritative and the legacy system links to it, or the legacy
  system is authoritative and the markdown files are working copies
  written back through a connector — or, as a minimum bar, every
  artifact notes the record ID and every legacy record notes the
  commit SHA. Two unlinked sources of truth are the failure mode.

## 2. Continuous evals in CI

Evals are the regression suite for the agent's configuration, not for
the product code:

- Collect 20–50 real past tasks with their accepted outcomes. Each
  eval is a prompt plus checks (tests pass, lint clean, behavior
  unchanged, policy followed).
- Run the suite non-interactively in CI on a schedule AND on any
  change to the project knowledge file, skills, or hooks — the
  configuration that steers the agent deserves the same regression
  testing as the code it writes.
- Gate configuration changes on the pass rate: a skill change that
  drops it gets reviewed before it merges.
- Every production incident becomes a permanent eval, written by the
  team that owned the incident.
- Replace cases that stop discriminating as models improve; a suite
  that always passes is a suite that measures nothing.

Prerequisites to check before enabling: a CI runner that can run the
agent non-interactively, an API budget for eval runs, and CI minutes
to spend. Without those, keep the light stand-in from the basic
skills (a small hand-run eval set checked after any skill or
knowledge-file change) — do not enable a gate you cannot afford to
run.

## 3. Managed PR review

Beyond the three-pass self-review in `verify-handoff`:

- A review service or pipeline action reviews every PR against a
  written `REVIEW.md` at the repo root: passes (bugs, security,
  compliance vs `spec.md` + `plan.md`), what counts as Important vs
  Nit, what to skip (generated paths, anything CI already enforces).
- Findings never approve or block a PR on their own; branch
  protection still requires a human code owner, and the agent that
  wrote the code has no route to approve it.
- Review comments addressed by the agent arrive as fixes in the PR
  thread, until the PR is green and waiting only on code-owner
  approval.
- Tune monthly: rate findings, cap nit volume, exclude what CI
  already enforces. Unrated, uncapped review output is noise, and
  noise gets ignored — including the Important findings.

## 4. Hooks as approval gates, managed

Beyond the guardrail split in `command-rights`:

- List every human approval gate that must survive (change sign-off,
  release authorization, protected paths) and express each as a hook
  script that can allow, ask, or block before the agent acts.
- Team hooks live in versioned settings in git; non-negotiable hooks
  live in managed settings the individual engineer cannot switch off.
  A gate an engineer can silently disable is not a gate.
- For a regulated setup, managed settings also cover: deny lists for
  secret paths and arbitrary network egress, pre-approved safe
  commands (so the deny list does not become prompt fatigue), a
  sandbox with a domain allowlist that fails closed, stripped secrets
  in sandboxed command environments, and a minimum tool version.
  Tailor the deny list to the repo's data classification — every deny
  trades against capability.

## 5. Non-interactive agents in CI/CD

- Start with read-only judgment steps in the pipeline: triage a
  failed build, summarize a flaky test, draft a changelog.
- Add write steps behind existing gates only: lint fixes, generated
  docs, review-comment fixes — everything the agent writes arrives as
  a PR through branch protection, never a direct push to main.
- Run agent jobs sandboxed, under a network policy, with short-lived
  scoped tokens and no standing production credentials.
- Expose deployment through scoped tool integrations (deploy, status,
  rollback per environment) instead of a shell script with
  credentials, so the agent's deployment power is an allowlist.
- Tier autonomy by environment and enforce it with a hook: dev free,
  staging middle, production prepared by the agent and authorized by
  a named release manager. The agent acts up to the production gate
  and nothing past it.

## 6. Closing the loop on metrics

- Pick one metric with a stable rolling baseline (CI test failure
  rate, post-deploy 5xx rate, PR cycle time). Detection stays
  entirely deterministic — a version-controlled, unit-tested script
  (rolling mean/standard deviation, drift rules), no model involved
  in detection.
- Tiered bands in version-controlled config: at 1σ log only; at 2σ
  invoke the agent read-only to diagnose; at 3σ the agent may act
  only by opening a PR into the review gate or triggering a
  pre-approved runbook. The agent writes its diagnosis as `intent.md`
  and the finding re-enters the pipeline like any other change.
- Triage queue: fix now, schedule, or dismiss — dismissals tune the
  bands and reduce noise. When a fix ships, add an eval for the
  incident class (see section 2).
- Related, same pattern: recurring codebase scans on a schedule
  (findings validated before anyone reads them, bounded findings
  through the review gate, larger ones as `intent.md`, dismissals
  recorded with reasons), and tagged on-call agents in the incident
  channel (the thread is the audit trail; the post-mortem goes to a
  versioned lessons file future investigations can read).

## Measures (per play, leading → lagging)

- Intent: time to committed `intent.md` → acceptance rate into Design.
- Spec: intent→spec time → spec rework after `plan.md` exists.
- Plan: first-pass merge share, plan→merged-PR time → rework cycles,
  diff-vs-plan match rate.
- Knowledge file: repeat-mistake rate → time to first merged PR for
  a newcomer.
- Skills: policy-change→skill-merge time → policy-cited review
  findings (should fall toward zero).
- Feedback loop: first-pass CI success → review time per PR,
  change failure rate.
- Evals: eval pass rate over time → regressions caught in CI vs in
  production.
- Review: time to first review → defects caught pre-merge vs escaped.
- Gates: wait time per gate → gate violations reaching production.
- CI/CD agents: pipeline failures triaged without paging a human →
  DORA measures.
- Closing the loop: breach→`intent.md` time → share of findings
  merged, repeat incidents of the same class.

## Don't

- Don't enable a gate you cannot run (no CI budget, no runner, no
  managed settings) and call it enforced.
- Don't let the formal artifact chain replace judgment: a perfect
  `intent.md` for a one-line fix is ceremony, and ceremony gets
  skipped — including where it matters.
- Don't put approval prompts in the inner loop; gates belong at
  stage boundaries and at production.
- Don't treat a managed review service or a scan as approval. The
  human code owner approves; everything else is evidence.

Plays map (stage → play → where it lives): `references/plays-map.md`.
