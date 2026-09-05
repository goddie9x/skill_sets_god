# Grants

## safe-commands

Classify the command first.

Safe (in-project, non-destructive): status, diff, log, search, format, lint, typecheck, test, build, declared-dep install, the edit the user asked for.

Then run it. Do not ask. If it fails, fix and rerun. Do not ask to rerun.

## auto-review

Before commit or push, read the diff yourself.

Drop secrets, debug leftovers, and broken install flags. Fix those, then continue.

Do not wait for a separate review bot unless the user named one.

## auto-commit

When the task is done and `auto-commit` is on, commit without asking.

Follow the repo commit style. English message. Stage only the files for this task.

Skip the commit if there is nothing to commit.

## auto-push

After a successful commit, `git push` the current branch (set upstream if needed).

Do not force-push. Do not push if the commit step was skipped.
