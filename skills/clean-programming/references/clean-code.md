# Clean Code

Write code a stranger can change without a briefing.

## Names

- Functions and methods: verbs that state the outcome (`loadUserById`, not `doIt`).
- Types, classes, structs: nouns (`InvoiceDraft`, not `Data2`).
- Booleans: predicates (`isExpired`, `hasAccess`, not `flag` / `status`).
- Avoid abbreviations unless the project already uses them (`url`, `id`, `ctx`).
- If a name needs a comment, rename it.

## Shape

- One reason to change per function, class, and file.
- Prefer many small functions over one branching function.
- Use guard clauses; flatten `if/else` ladders.
- Do not pass boolean flags that pick a code path — split into two functions.
- Keep parameter lists short (soft max 3, hard max 5). Group extras in a typed object.
- Prefer pure functions. Push I/O to the edges.
- Fail fast with explicit errors. Do not swallow exceptions or return magic values.

## Hygiene

- Delete dead code, unused exports, and commented-out blocks. Git keeps history.
- Do not duplicate logic. Extract a named function when the same idea appears twice.
- Do not invent a new abstraction for a single use.
- Match the project's formatter, linter, and existing patterns.
- Keep imports tight. Avoid barrel files that re-export an entire layer unless the project already depends on them.
- Public APIs stay small. Hide helpers in the same module or a nearby private module.

## Structure over cleverness

- Obvious code beats clever code.
- Use the language's standard library before adding a dependency.
- When two designs work, pick the one with fewer concepts and fewer lines in the hot path.
