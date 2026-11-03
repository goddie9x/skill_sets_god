---
name: read-ladder
description: >-
  Read source code and docs with a token-saving ladder: state the
  requirement, then dir tree, file tree, relevant dirs, relevant files,
  and only then read — following refs/imports one justified hop at a
  time when going deeper is needed. Use when exploring an unfamiliar
  codebase, fixing a bug, or adding a small feature. Never read the
  whole project for a small change.
---

# Read Ladder

Reading the whole project to fix a small bug is the most expensive way
to learn a codebase. Climb the ladder instead: each rung is cheaper
than the next, and you stop as soon as you have what you need.

## The ladder

0. **Requirement first.** Say in one sentence what you are looking for:
   the bug, the feature, the question. If you cannot, you do not know
   what to read yet — go back to `pre-task-split` before touching the
   tree.
1. **Dir tree.** Print the filtered directory tree
   (`read_ladder.py tree`). Learn the layout: where code, tests, docs,
   and config live. Do not open any file yet.
2. **File tree.** List files in the candidate areas
   (`read_ladder.py files`). Names tell you roles; line counts tell
   you cost.
3. **Relevant dirs.** Name 1–3 directories that could own the change —
   explicitly, before reading anything. If you cannot narrow it to
   three, your rung-0 sentence is too vague.
4. **Relevant files.** Within those dirs, pick files by name and role.
   Triage large files first (`read_ladder.py symbols`): read the head
   and the symbols, then targeted sections. **Files at or under 200
   lines may be read directly** — the ladder exists to save tokens,
   not to add ceremony.
5. **Read.** Read the chosen files. This is the first expensive step,
   and it comes last on purpose.
6. **Deeper only if needed.** Follow refs/imports one hop at a time,
   each hop justified by something you saw in the previous file. Never
   fan out blindly; never "read the neighbors just in case".

## Token rules

- Tree output is cheap; file reads are expensive. Spend reads, not trees.
- Binary, build, and dependency directories are never listed — the
  script skips them (`node_modules`, `dist`, `.next`, `__pycache__`, …).
- Do not re-read a file you already read in this session unless it
  changed on disk.
- The small-file exception (≤200 lines) is for efficiency, not
  laziness: a 40-line config costs less than the tree commands that
  would locate it twice.

## For docs

The same ladder applies: requirement → doc tree (`docs/`, README,
wiki) → relevant doc dirs → relevant pages → read. A doc index or
site nav is the "file tree" rung; a page's headings are its "symbols".

## Relationship to other skills

- `clean-programming` already says "related files only, do not read
  the whole project" — this skill is the procedure that makes that
  rule executable. It does not replace or weaken it.
- `context-compactor`'s `filemap` is for summarizing a project you
  already work in; the ladder is for deciding what to read when you
  arrive. Use filemap output as a rung-2 shortcut when it exists.

## Don't

- Don't open the project root and start reading files alphabetically.
- Don't read a 2000-line file "to get context" — symbols first, then
  the section you need.
- Don't follow every import in a file. One justified hop at a time.
- Don't skip rung 0. "Let me look around the codebase" is how a
  5-minute bug fix costs 50k tokens.

Worked example: [ladder.md](references/ladder.md).
Script: `scripts/read_ladder.py` (stdlib only).
