# Examples

## Good

```markdown
## Export invoice PDF

### Overview
Builds a PDF for one invoice and downloads it in the browser.

### Prerequisites / input validation
- Required: `invoiceId` — existing invoice owned by the current account
- Required: account has a billing address on file
- Optional: `locale` — defaults to account language

### If missing
- Invoice: create under **Invoices → New** — see [Create an invoice](#create-an-invoice)
- Billing address: set under **Settings → Billing** — see [Billing address](#billing-address)
```

## Bad

```markdown
## Export invoice PDF
Click Export to download the PDF.
```

Missing overview depth, validation, and create paths.

## Partial — fix before shipping

```markdown
## Export invoice PDF

### Overview
Builds a PDF for one invoice.

### Prerequisites / input validation
- Required: invoice
```

Still missing validation detail and where to create the invoice.
