# Examples

## Comments → names

Bad:

```ts
// check if user can edit
if (u.r === 1 && u.exp > Date.now()) {
  // allow
}
```

Good:

```ts
if (user.canEdit()) {
```

```ts
canEdit(): boolean {
  return this.role === Role.editor && !this.isExpired();
}
```

## Split a growing function

Bad: one 80-line handler that validates, loads, maps, and writes.

Good:

```ts
export async function submitInvoice(input: SubmitInvoiceInput): Promise<Invoice> {
  const draft = parseSubmitInvoiceInput(input);
  const account = await loadBillableAccount(draft.accountId);
  const invoice = buildInvoice(draft, account);
  return saveInvoice(invoice);
}
```

Each helper lives in its own small file or next to its type, under the hard size limits.

## Safe commands

User: "Add validation to the login form."

Do:

1. Edit the small form/validator modules.
2. Run the project test and analyze commands immediately.
3. Report what failed and fix it.

Do not: ask "Want me to run the tests?"

## Focused replies

Bad: recap the ask, list unused options, then the fix, then "I can also…".

Good: the fix, the files, whether checks passed.

## English identifiers

Bad: `tinhTongTien()`, `nguoiDung`, `hoaDon.dart`.

Good: `calculateTotal()`, `user`, `invoice.dart`.
