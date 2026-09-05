# Modular Size

Small units are easier to read, cheaper to load, and cheaper for the model to edit.

Prefer more files over large files. The agent should open only the modules it needs.

## Limits

| Unit | Soft max | Hard max | Split when |
| --- | --- | --- | --- |
| Function / method | 20 lines | 40 lines | Second responsibility, deep nesting, or mixed I/O and logic |
| Class / struct / mixin | 120 lines | 200 lines | Second reason to change |
| File | 200 lines | 300 lines | Second concept, or imports keep growing |
| Parameters | 3 | 5 | Introduce a typed object |
| Nesting | 2 levels | 3 levels | Extract a named function |

Counts exclude blank lines and the rare allowed comment. If a language's generated file or a data fixture must be large, keep it data-only and do not mix behavior into it.

## How to split

- **Function**: one action. Extract helpers named after the why (`hasPaidInvoice`, not `check`).
- **Class**: one actor or one policy. Move unrelated methods to a new type.
- **File**: one type or one capability (`user_auth.dart`, not `user_helpers.dart` that also formats dates).
- **Layer**: keep UI, domain, and I/O in different files. Do not grow a widget until it also fetches and maps data.

When adding code would cross a hard max, split first, then add.

## Token efficiency

- Do not put unrelated helpers in a "utils" dump. Name the capability.
- Avoid mega barrel exports that pull an entire folder into every edit.
- Colocate code that changes together; split code that changes for different reasons.
- New feature = new small file when the existing file is already near the soft max.
- Do not copy-paste a 300-line file to change 10 lines — extract the seam, then edit the small piece.

## Readability test

A reviewer can state the file's job in one sentence. If they cannot, split it.
