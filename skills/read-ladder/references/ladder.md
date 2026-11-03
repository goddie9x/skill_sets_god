# Worked example: fix a small bug with the ladder

Task: "login button does nothing on the deployed site."

## Rung 0 — requirement

One sentence: *the login form submits but no request reaches the auth
endpoint.* What I need: the submit handler and whatever it calls.

## Rung 1 — dir tree

```
$ python3 scripts/read_ladder.py tree .
/srv/app/
  src/  (48 files)
  tests/  (12 files)
  docs/  (6 files)

2 dirs, 66 files (0 at root, depth <= 3)
```

`node_modules/`, `dist/`, `.git/` are skipped by the script — they
never appear, so they never tempt a read.

## Rung 2 — file tree (candidate area: src)

```
$ python3 scripts/read_ladder.py files src --ext ts,tsx
src/
  auth/LoginForm.tsx  (86 lines)  [small, read directly]
  auth/useAuth.ts  (240 lines)
  auth/api.ts  (45 lines)  [small, read directly]
  ...
```

## Rung 3 — relevant dirs

`src/auth/` — the only dir whose name matches the requirement.

## Rung 4 — relevant files

- `LoginForm.tsx` (86 lines ≤ 200): read directly.
- `api.ts` (45 lines ≤ 200): read directly.
- `useAuth.ts` (240 lines > 200): triage first.

```
$ python3 scripts/read_ladder.py symbols src/auth/useAuth.ts
src/auth/useAuth.ts  (240 lines)
verdict: LARGE — read targeted sections, not the whole file
symbols: useAuth, login, logout, refreshToken
```

## Rung 5 — read

`LoginForm.tsx` calls `login()` from `useAuth.ts`. Reading the
`login` function (not the whole file) shows it posts to `/api/auth`
— but `api.ts` defines the base URL from an env var that is empty in
production.

## Rung 6 — one justified hop

The env var name in `api.ts` justifies exactly one hop: check where
the deploy sets env vars (deploy config, one file). Found: the var
was renamed in code but not on the server. Fix, verify, done.

## What did not happen

- No reading of `tests/`, `docs/`, or the other 45 files in `src/`.
- No following of every import in `useAuth.ts` — only the env-var hop
  the evidence justified.
- Total files read: 4 (two small whole, one function, one config).
  A "look around the codebase" pass would have read dozens.
