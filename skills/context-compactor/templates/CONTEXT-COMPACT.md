# CONTEXT-COMPACT — session state (do not commit)

<!-- Written by the context-compactor skill. A fresh session reads ONLY
     this file first, states goal / open tasks / next step in 3 lines,
     then continues. Keep it under ~10% of max context. -->

## 1. Goal

<!-- One or two sentences: what the user actually wants, in their terms. -->

## 2. Decisions (verbatim)

<!-- Decisions and chosen options, copied word-for-word where the wording
     matters. Never paraphrase an ID, a number, a name, or a commitment. -->

-

## 3. Open tasks

<!-- What is still unfinished, with its current state. Done work gets one
     line in section 8 history, not a paragraph here. -->

- [ ]

## 4. Next step

<!-- The single next action, specific enough to start without questions. -->

## 5. File map

<!-- One line per relevant file: path — purpose — key functions/exports —
     depends on / used by. Generate with:
     python3 context_compact.py filemap <project>
     then fill in the purpose where the script could not infer it. -->

| File | Lines | Lang | Key symbols | Purpose / first doc line |
| --- | ---: | --- | --- | --- |

## 6. User preferences and corrections (verbatim)

<!-- Standing rules and corrections that apply to this work, quoted.
     If the user corrected you, their exact wording lives here so the
     next session does not need the same correction twice. -->

-

## 7. Errors and evidence

<!-- Current blockers and the evidence behind them: exact error messages,
     failing commands, what was already tried and its result. Crushed logs
     go here (context_compact.py crush-log), never the raw log. -->

-

## 8. Session state

- Declared max context (tokens):
- Estimated usage at compact time:
- Compact count:
- Last compacted at:
- History (one line per finished chunk of work):
  -
