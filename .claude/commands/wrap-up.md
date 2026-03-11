# /wrap-up

Update CLAUDE.md at the end of a session to reflect what changed.
Follow every step in order. Do not skip steps or reorder them.

---

## STEP 1 — Ask the user (wait for answer before continuing)

Ask: "Were any new environment variables added to .env.local this
session? If yes, list them with their purpose."

Store the answer. You will need it in Step 5 item 3.

---

## STEP 2 — Guard check

Check if CLAUDE.md exists at the project root.
- If it does not exist: stop and tell the user
  "CLAUDE.md not found. Create it first before running /wrap-up."
- If it exists: continue to Step 3.

---

## STEP 3 — Gather session data (run all, do not skip any)

Run all of these and collect the outputs:

a) `git diff --stat` — unstaged changes
b) `git diff --cached --stat` — staged but uncommitted changes
c) `git status --short` — full picture including untracked files
d) `git diff HEAD package.json` — check for new/removed npm packages
   (catches both staged and unstaged changes to package.json)

Migration count (try PowerShell first, fall back to bash):
- PowerShell: `Get-ChildItem supabase/migrations -Filter *.sql | Measure-Object | Select-Object -ExpandProperty Count`
- Bash fallback: `find supabase/migrations -name "*.sql" | wc -l`

Then build a unified file list:
- Take the union of outputs from (a), (b), (c)
- Deduplicate by filename — if a file appears in multiple outputs, list it once
- Categorize each as: ADDED, MODIFIED, or DELETED
- This unified list is your source of truth for Step 5

---

## STEP 4 — Read CLAUDE.md fully before making any edits

Read the entire current CLAUDE.md into context.
Before adding anything, check if it already exists in the file.
Never add a duplicate entry. If it already exists, update it in place instead.

---

## STEP 5 — Update CLAUDE.md

Make only these updates, in this order:

**1. Project structure tree**
- ADDED files → add to correct section of tree (one line: filename + description)
  Covers: src/, scripts/, docs/, .claude/commands/, server/
- DELETED files → remove from tree entirely
- DELETED slash commands → remove from .claude/commands/ section of tree
- Do not add route listings (routes are implied by pages listed)
- Test plan files (docs/test-plan-*.md) — these are ephemeral test artifacts, not project structure. Never add them to CLAUDE.md.

**2. New DB tables**
- Add to schema section: table name + key columns only
- No verbose column lists

**3. Environment variables**
- Add any vars the user reported in Step 1 to the env vars table
- Format: one row per variable (name + purpose)
- Do not add vars already in the table

**4. npm packages**
- If `git diff HEAD package.json` shows new dependencies → add to Key Libraries section
- If packages were removed → remove from Key Libraries section
- Format: `packagename` — one-line purpose

**5. Migration count + Recent Migrations table**
- Update the migration count and date range using the count from Step 3
- Add new migrations to "Recent Migrations" table:
  - Date: from filename timestamp
  - Name: filename without timestamp prefix
  - Description: infer from filename. If ambiguous, read the
    first comment line of the migration file for clarification.
- Keep last 5 entries. If Step 6 requires trimming, reduce to 3.
- Remove oldest entry when table exceeds 5 rows.

**6. Feature status changes**
- Update implementation status table for any assessment or feature
  that changed state this session
- Include partial progress (❌→⚠️), not just completions (⚠️→✅)

**7. Resolved deferred items**
- Remove from Known Issues table if resolved this session

**8. New deferred items**
- Add to Known Issues table: one row, name + one-line description
- Do not add items that are already listed

**9. Stale information**
Stale means one of these specific things — do not remove anything else:
- A file listed in project structure that was DELETED per the unified file list
- A Known Issue marked as resolved per git diff or user confirmation
- A migration entry beyond the last 5 in the Recent Migrations table
- A library in Key Libraries that was removed per git diff HEAD package.json
- Do NOT remove anything based on your own judgment — only remove
  what is explicitly confirmed as stale by the above criteria

---

## STEP 6 — File size check and trim if needed

Count lines using:
- PowerShell: `Get-Content CLAUDE.md | Measure-Object -Line | Select-Object -ExpandProperty Lines`
- Bash fallback: `wc -l < CLAUDE.md`

If over 400 lines, trim in this exact order (stop as soon as target is met):
1. Remove resolved deferred items (if any remain)
2. Collapse verbose descriptions to one-liners
3. Reduce Recent Migrations table from 5 to 3 entries
   → Print: "⚠️ Migration table trimmed to 3 entries to meet size target"
4. NEVER trim these regardless of size:
   - Project structure tree
   - Schema tables
   - Environment variables table
   - Key conventions section
   - Implementation status table
   - Active known issues

If 400 lines cannot be reached without removing essential content:
- Keep the file longer
- Add this comment on line 2 of the file:
  `<!-- Note: file exceeds 400 lines — all content is essential -->`

After trimming, recount lines and confirm the final count.

---

## STEP 7 — task.md check

Check if `task.md` exists. If it does:
- Read it and check if any E2E testing phases were completed this session
- If yes, update the status of those phases in task.md
  (✅ done / ❌ not started / 🔄 in progress)
- If no changes needed, leave task.md untouched

---

## STEP 8 — Print wrap-up summary

## Session Wrap-up
- Files changed this session: [unified list: ADDED/MODIFIED/DELETED]
- Added to CLAUDE.md: [list each item added]
- Removed from CLAUDE.md: [list each item removed]
- New deferred items: [list or "none"]
- Migration count: [old count] → [new count]
- CLAUDE.md line count (final, after any trimming): [number]
- task.md updated: [yes — list phases updated / no]

---

## STEP 9 — Remind user to commit

Summarize the most significant change made this session in 3-5 words.
Then print:

"CLAUDE.md has been updated. Don't forget to stage and commit it:
  git add CLAUDE.md
  git commit -m 'chore: wrap-up — [your 3-5 word summary here]'

Example: 'chore: wrap-up — added sync-sheet command'"
