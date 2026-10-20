---
name: context-compactor
description: >-
  Compact a long conversation, a codebase's file contents, or long logs
  and tool outputs into one small, verified summary file before context
  runs out — so any AI agent or tool, including ones with no built-in
  compaction, can drop the raw history and keep working without losing
  decisions, facts, or open tasks. Use when estimated context use reaches
  70% of the declared max, when switching tasks or chats, before a
  handoff, or when a single file or log is too large to load whole.
---

# Context Compactor

Context loss is not a memory problem. It is a procedure problem: nobody
wrote the state down before the window filled up. This skill is that
procedure, plus a stdlib-only script (`scripts/context_compact.py`) that
measures, maps, crushes, and verifies — so the compact is checked by
code, not by optimism.

The output is always one file in the project root: `CONTEXT-COMPACT.md`.
It is **gitignored** — it is local session state, not project content.

## Step 0: Declare your max context

At the start of a session, write down the max context of the model/tool
you are running on (you declare it; do not guess silently). Record it in
section 8 of the compact file. Every trigger below is a percentage of
that number. If your tool reports real usage, use its number. If it does
not, estimate the loaded material with the script:

```bash
python3 scripts/context_compact.py measure <files-or-dirs...> \
    --max-context <declared> --threshold 0.70
```

Exit code 10 means COMPACT NOW. Estimates are `chars/4` unless the
optional `tiktoken` package is installed; good enough for a trigger,
never quote them as exact.

## When to compact

Compact **before** continuing when any of these is true:

- Estimated usage reaches **70%** of the declared max context.
- You are about to switch tasks, start a new chat, or hand off.
- One input (log, tool output, file dump) is large enough that loading
  it whole would crowd out the work itself.
- The tool is about to auto-compact or truncate on its own — do it
  yourself first, while you still control what survives.

Do not compact early "just in case" below ~50%: a compact you rewrite
five times costs more than it saves.

## The compact procedure

1. **Freeze.** Finish the current atomic step. Never compact mid-edit.
2. **Inventory with code.** Run `filemap` on the project and `measure`
   on everything loaded. Do not list files from memory.
3. **Extract must-keep facts first.** Before summarizing anything, copy
   the verbatim facts into a scratch list (one per line): decisions,
   IDs, hashes, paths, commands, numbers, dates, exact error messages,
   and the user's own wording for corrections and preferences. This list
   is the input to `check --facts` in step 6.
4. **Summarize in layers** into `CONTEXT-COMPACT.md` (create it with
   `init`, which also gitignores it):
   - Goal and decisions — decisions verbatim, never paraphrased.
   - Open tasks with their real state, and one concrete next step.
   - File map from the script; fill in purpose where the script could
     only find a first line. One line per file: purpose, key
     functions/exports, what it depends on.
   - Errors and evidence: crushed logs (step 5), not raw logs.
   - Finished work: one history line per chunk. Detail is loss; the
     state is the value.
5. **Crush big inputs instead of loading them.** For logs and long tool
   output: `crush-log` dedupes repeated lines with counts, keeps unique
   error/warning lines verbatim, and keeps head + tail. Work from the
   crushed version; keep the raw file on disk, out of context.
6. **Verify with code, not vibes.** Run:

   ```bash
   python3 scripts/context_compact.py check CONTEXT-COMPACT.md \
       --facts <must-keep-facts.txt> --sources <original files...>
   ```

   It must PASS: all 8 sections present, every must-keep fact present
   verbatim, and it prints the compression ratio. If it fails, fix the
   compact — do not proceed on a failed check.
7. **Resume lean.** Drop the raw history. Continue (or start the new
   chat) with only `CONTEXT-COMPACT.md` plus the specific files the next
   step needs. A healthy compact is under ~10% of max context.

## Restoring in a fresh session

Read `CONTEXT-COMPACT.md` first, before any other file. Then state the
goal, the open tasks, and the next step in three lines so the user can
catch a bad compact immediately. If a needed fact is missing, go back to
the original source for that fact only — never reload the whole history
"to be safe".

## What must never be summarized away

- Identifiers: IDs, commit hashes, paths, URLs, config keys, port numbers.
- Numbers and dates the user may act on.
- Exact error messages and the command that produced them.
- The user's decisions and corrections **in their own wording**.
- Commitments: what was promised, to whom, by when, and what is still open.

Summarize explanations, exploration, dead ends, and repeated output.
Those are the bulk of a long context and the least valuable part.

## The three inputs

- **Conversation** — the layered summary above. The transcript is the
  raw log; the compact file is its crushed form.
- **Files / codebase** — `filemap` gives structure; you add the one-line
  purpose per file. After compacting, re-read a file only when editing
  it, not to "refresh" yourself.
- **Logs / tool output** — `crush-log` first, always. A 10,000-line log
  usually carries ~50 lines of signal.

## Don't

- Don't commit `CONTEXT-COMPACT.md`. `init` gitignores it; keep it that way.
- Don't paraphrase a decision to make it shorter. Shorter is not the
  goal; lossless-where-it-matters is.
- Don't compact from memory — inventory and measure with the script.
- Don't skip the `check` step because the summary "looks complete".
- Don't paste the raw transcript into the compact file. That is not a
  compact, that is a copy.
- Don't rebuild the old transcript in a new chat (see `token-optimizer`).
  The compact file replaces it.

Format details and a worked example: `references/compact-format.md`.
