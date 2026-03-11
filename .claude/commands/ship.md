---
# /ship

Run the full pre-commit verification pipeline. Fix any errors found,
then confirm the build is clean before committing.

Follow every step in order. Do not skip steps.

---

## STEP 1 — Guard check

Before running anything, verify the environment:

Run: `npx tsc --version`
- If output contains "command not found" or "Cannot find module typescript":
  Stop and print:
  "🔴 TypeScript not found. Run `npm install` first, then re-run /ship."
  Do not continue.

Run: `npx vite --version`
- If output contains "command not found" or "Cannot find module vite":
  Stop and print:
  "🔴 Vite not found. Run `npm install` first, then re-run /ship."
  Do not continue.

If both are found, continue to Step 2.

---

## STEP 2 — Run TypeScript check

Run: `npx tsc --noEmit`

If it passes:
- Print: "✅ TypeScript — no errors"
- Continue to Step 3

If it fails:
- Print: "❌ TypeScript errors found — fixing now..."
- Read every error carefully
- Fix all errors one by one, starting with the most fundamental
  (fixing one error often resolves others downstream)
- Rules while fixing:
  - Never use `any` to silence an error
  - Never add `// @ts-ignore` or `// @ts-expect-error`
  - Never change strict mode settings in tsconfig.json
  - If an error requires a significant logic change, stop and
    explain the issue to the user before making the change
- After fixing, re-run `npx tsc --noEmit`
- Repeat until zero errors
- Print: "✅ TypeScript — fixed [N] errors, now clean"

If the error output looks like a system/environment error rather than
a type error (e.g. missing modules, path errors, config not found):
- Stop and explain the environment issue to the user
- Do not attempt to fix it as if it were a code error

---

## STEP 3 — Run Vite build

Run: `npx vite build`

If it passes:
- Print: "✅ Vite build — successful"
- Continue to Step 4

Ignore these — they are not errors and must not block the build:
- Any warning about chunk sizes exceeding 500kb
- Any warning about "Some chunks are larger than..."
- Sourcemap warnings

If it fails with actual errors (not warnings):
- Print: "❌ Vite build failed — fixing now..."
- Read the full error output carefully
- Common causes to check first:
  - Missing imports or exports
  - Circular dependencies
  - Assets not found
  - Environment variables referenced incorrectly
    (must use `import.meta.env.VITE_*` not `process.env.*`)
- Fix the errors
- Rules while fixing:
  - Never suppress build errors with config changes unless
    absolutely necessary
  - If suppressing is the only option, explain why to the
    user before doing it
  - If an error requires a significant logic change, stop and
    explain the issue to the user before making the change
- After fixing, re-run `npx vite build`
- Repeat until build succeeds
- Print: "✅ Vite build — fixed, now passing"

If the error looks like a system/environment error:
- Stop and explain the environment issue to the user
- Do not attempt to fix it as if it were a code error

---

## STEP 4 — Update last verified build date in CLAUDE.md

Find the "Current Implementation Status" section in CLAUDE.md
by its heading text (not by section number — section numbers
may change over time).

If a "Last verified build" line already exists in that section:
- Update the date to today

If it does not exist:
- Add this line immediately after the section heading:
  `**Last verified build:** [today's date]`

---

## STEP 5 — Print final status and commit reminder

If both checks passed (with or without fixes), print:

🚀 Ship check complete — all clear

✅ TypeScript: clean
✅ Vite build: passing
✅ CLAUDE.md updated

Run `git diff HEAD --stat` to see what has changed, then stage
and commit:

  git add -p   ← stage interactively, review each chunk before staging
  git commit -m "[suggested message below]"

⚠️ Do not use `git add .` — review what you are staging first.

Suggested commit message:
  [infer from `git diff HEAD --stat` — pick the most significant change]

Commit message format:
- New feature → feat: [what was added]
- Bug fix → fix: [what was fixed]
- Refactor → refactor: [what was restructured]
- DB migration → chore: [migration name]
- Documentation → docs: [what was documented]
- Tests → test: [what was tested]

Examples:
  git commit -m "feat: add /ship slash command"
  git commit -m "fix: resolve summary tab lock bypass in role models"
  git commit -m "chore: update assessment questions from Google Sheet"

Generate one specific suggested message — do not use a generic placeholder.

---

If either check failed and could not be fixed automatically, print:

🔴 Ship blocked — manual intervention required

❌ [tsc / vite build] could not be fixed automatically
Error: [exact error message]
File: [filename and line number]

What to do:
[specific explanation of what needs to be fixed and why]

Do not suggest committing if either check is still failing.
