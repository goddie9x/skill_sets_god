# Doc Structure

Use this shape for each feature (adapt headings to the project style):

```markdown
## <Feature name>

### Overview
One short paragraph: what it does and who it is for.

### Prerequisites / input validation
- Required: <item> — must exist / must pass <rule>
- Optional: <item> — default <value> if omitted

### If missing
- <item>: create at <path or UI location> — see [<section>](<link-or-anchor>)
```

## Rules

- **Overview first.** No setup steps before the reader knows what the feature is.
- **Validate inputs explicitly.** Required vs optional. Formats, ranges, uniqueness, auth, env, prior records.
- **Every required item needs a create path.** Name the screen, CLI, API, or file. Link to the section that documents creating it.
- **Same doc preferred.** If create steps live in another section of this doc, use an anchor. If they live in another file in the repo, use a relative path.
- **Do not invent screens.** If the create path is unknown, mark it as missing and ask — do not guess product URLs.
- **User-facing copy** follows the product locale. Technical field names stay exact.

## Checklist before finishing

- [ ] Overview present
- [ ] Required inputs listed with validation rules
- [ ] Each required input has create-if-missing + ref
- [ ] Links resolve to real sections or files in the project
