---
name: token-optimizer
description: >-
  Cut token cost by starting a fresh chat for a new task and by naming
  the cheaper path for simple work. Use when a chat has already finished
  several tasks, when the user starts a new feature or bug, or when the
  task is a refactor, tests, or basic logic. Short replies and reading
  only related files stay in clean-programming.
---

# Token Optimizer

Do not repeat clean-programming. That skill already owns short answers and reading only related files.

## New chat

Before continuing, tell the user to open a new chat when either is true:

- The current thread already completed other features or bugs.
- The next request is a different feature or bug.

One sentence. Then wait. Do not rebuild the old transcript in the new chat.

## Cheaper model

For a refactor, tests, or straightforward logic, suggest a lower-cost model. Do not switch the model yourself. Do not name a model the user did not already use.
