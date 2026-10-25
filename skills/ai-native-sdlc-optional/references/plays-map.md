# Plays map — Anthropic AI-native SDLC playbook

Source: https://claude.com/blog/the-ai-native-sdlc-playbook (full text
read 2026-10-25). "Basic" = sprinkled into the default bundle;
"Optional" = this skill only.

| Stage | Play | Lives in |
| --- | --- | --- |
| Plan | 1. Capture as intent.md | Basic (light form, `pre-task-split`); formal file chain → Optional §1 |
| Plan | 2. Requirements and design → spec.md | Basic (`doc-prerequisites` flagged concerns + open questions); formal chain → Optional §1 |
| Build | 3. Plan mode as default starting point | Basic (`pre-task-split` artifact chain) |
| Build | 4. The CLAUDE.md | Basic (`clean-programming` institutional knowledge) |
| Build | 5. Skills as institutional knowledge | Basic (the skill set itself; advisory-vs-enforced in `command-rights`) |
| Build | Hooks as build-time guardrails (sidebar) | Basic (`command-rights`) |
| Build | Parallel sessions and subagents | Basic (`clean-programming`) |
| Build | Auto mode (sidebar) | Basic, gated: only for routine work once guardrails mature (`pre-task-split`, `command-rights`) |
| Test | 7. Give Claude a feedback loop | Basic (`test-run-verify` Rule 4) |
| Test | 8. Continuous evals in CI | Optional §2 |
| Deploy | 9. AI in the PR review loop | Basic (`verify-handoff` three passes); managed service → Optional §3 |
| Deploy | 10. Hooks as approval gates | Basic (`command-rights`); managed settings → Optional §4 |
| Deploy | 11. CI/CD integration and deployment | Basic (`pre-deploy-checklist` production gate); non-interactive agents → Optional §5 |
| Maintain | 12. Closing the loop on metrics | Basic (`test-run-verify` Rule 5, `context-compactor` re-entry); deterministic bands + scans + on-call → Optional §6 |

Cross-cutting: every stage commits an artifact the next stage reads;
humans judge at gates, not line by line; skills advise, hooks enforce;
measure each play with a leading and a lagging indicator (see
SKILL.md, "Measures").
