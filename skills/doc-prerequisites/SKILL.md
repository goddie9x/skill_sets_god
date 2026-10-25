---
name: doc-prerequisites
description: >-
  Require docs to include a basic feature description plus input
  validation and prerequisites, with links to where missing items are
  created. Use when writing, editing, or reviewing documentation,
  README sections, user-facing help, API/feature docs, or any text
  shown to end users that describes how to use a feature.
---

# Doc Prerequisites

Apply whenever you write or edit docs for users (README, help UI copy, feature guides, API usage notes).

Every feature section must include all of:

1. **Overview** — what the feature does, in plain language.
2. **Input validation / prerequisites** — what must already exist or pass checks before this feature works.
3. **Create-if-missing** — if a required item is missing, where to create it, with a link or ref to that section.

Details: [structure.md](references/structure.md). Examples: [examples.md](references/examples.md).

## Spec docs: flagged concerns and open questions (AI-native SDLC)

A spec or design doc is not finished when it reads smoothly — it is
finished when a reader can see what is still uncertain. When writing
or editing a spec:

- **Flag concerns in the doc itself**, especially where policies
  contradict each other or a requirement cannot be satisfied as
  written. Do not silently resolve a contradiction in favor of one
  policy; name both and route the decision to the policy owner.
- **Carry open questions forward** from the intent into the spec and
  from the spec into the plan, marked as open until answered. A
  question that disappears from the docs without an answer will
  reappear as rework after build starts.
- **Record what the spec is checked against**: the intent it came
  from, and the plan it will be checked against in review.

## Hard stops

- Do not ship a feature doc that only describes the happy path.
- Do not list a required input without saying how to obtain or create it.
- Prefer in-doc anchors / relative links over vague “see elsewhere”.
- Match the product language for user-facing copy; keep identifiers and headings clear.
