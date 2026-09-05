# Self-Documenting Code

Code is the comment. Comments are the exception.

## Default

Write names, types, and small functions so a reader never needs a comment.

Replace a comment with one of these, in order:

1. A better name.
2. A smaller extracted function or type.
3. A clearer control-flow (guard clause, early return).
4. A type that encodes the invariant.

## Forbidden comments

- Restating the next line or block ("increment counter", "loop users").
- Section banners (`// ===== Helpers =====`).
- Narrating the change (`// fix bug`, `// added validation`).
- Commented-out code.
- TODOs without an owner and a reason (prefer a ticket or just do the work).
- Redundant docstrings that repeat the function name.

## Allowed comments (rare)

Write a short English comment only when the code cannot say it:

- **Why**, not what: a non-obvious business rule, legal constraint, or spec quirk.
- **Workaround**: a compiler, runtime, or third-party bug, with a link or ticket id.
- **Invariant** the type system cannot express.
- **Required docs**: language or tool requires a doc comment on a public API. Keep it to contract and edge cases, not a paraphrase of the body.

A valid comment is one or two sentences. If it is longer, the design is unclear — split the code.

## Checklist before adding a comment

- Can I rename this?
- Can I extract a function whose name is the comment?
- Can a type, assertion, or test lock the intent?

If yes to any, do that. Do not add the comment.
