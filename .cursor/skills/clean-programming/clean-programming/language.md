# English

Use English for every artifact the machine or a future reader will parse.

## Must be English

- Identifiers: files, folders, functions, types, variables, enums, constants.
- Comments and doc comments (when any are allowed).
- Commit messages, PR titles, PR bodies, and code-review notes you write.
- Test names (`loadsInvoiceForOwner`, `returns404WhenMissing`).
- User-facing copy only when the product UI is English. If the product is localized, keep keys and source strings as the project already does; still name the keys in English (`error.invoiceExpired`).

## Chat with the user

- Match the user's language in conversation.
- Keep all code and git text in English even when the user writes in another language.

## Naming style

- Use clear, common English words. No clever slang.
- Do not mix languages in one identifier (`tinhTienInvoice` is wrong; `calculateInvoiceTotal` is right).
- Domain terms stay in their usual English form (`invoice`, `webhook`, `payload`).

## Docs you create

READMEs, skill files, and ADRs you add: English, short, and specific.
