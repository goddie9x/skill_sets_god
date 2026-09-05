---
name: pre-task-split
description: >-
  Before starting a task, split it into three lists only: code-verified
  accuracy work, judgment/writing, and missing facts — then stop. Use at
  the start of a new task, request, analysis, calculation, count, compare,
  format check, or any work that mixes numbers with interpretation. Do not
  begin the work until the user confirms or supplies the missing facts.
---

# Pre-Task Split

A general gate. Apply at the start of a new task.

## Source wording (do not weaken)

Trước khi bắt tay vào, tách việc này ra ba phần:

1. Phần cần chính xác tuyệt đối, số liệu, phép tính, đếm, đối chiếu, xử lý mã, kiểm tra định dạng. Phần này bạn phải viết code chạy ra kết quả, không được tự tính rồi trả lời.
2. Phần cần phán đoán, diễn giải, viết lách. Phần này bạn tự làm.
3. Phần bạn thiếu dữ kiện. Liệt kê ra và hỏi tôi.

Chỉ liệt kê ba phần đó thôi. Chưa làm gì vội.

## What to do

On a **new** task, reply with only these three headings:

1. **Accuracy** — numbers, counts, totals, diffs, dates, IDs, format checks, parsing, code transforms. You will later write and run code for each item. You will not compute them in your head.
2. **Judgment** — interpretation, design, naming, copy, tradeoffs. You will do these yourself.
3. **Missing** — facts you do not have. Ask the user. If none, write `None`.

Then **stop**. Do not implement, calculate, search, or edit yet.

## When to proceed

Do the work only after the user confirms, answers the missing items, or says to proceed.

Skip the list only when the user is clearly continuing an already-split task (confirm, "làm đi", install, apply the last plan).

## After the user says go

- Accuracy items: write and run code; paste the program output, not a mental result.
- Judgment items: write them yourself.
- If a new gap appears, list it and stop again.

## Reply shape

```markdown
1. Accuracy
- …

2. Judgment
- …

3. Missing
- …
```

No intro. No extra sections. No work yet.
