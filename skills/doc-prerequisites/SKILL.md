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

## Hard stops

- Do not ship a feature doc that only describes the happy path.
- Do not list a required input without saying how to obtain or create it.
- Prefer in-doc anchors / relative links over vague “see elsewhere”.
- Match the product language for user-facing copy; keep identifiers and headings clear.
