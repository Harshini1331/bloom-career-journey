# /sync-sheet

Compare Google Sheet question content against the live database,
generate a readable diff report, and on approval generate one SQL
migration file per changed assessment.

Usage:
  /sync-sheet                          → run diff and generate report only
  /sync-sheet apply                    → generate migrations for ALL changed assessments
  /sync-sheet apply <type>             → generate migration for one assessment
  /sync-sheet apply <type1>,<type2>    → generate migrations for specific assessments

Valid assessment types:
  inspiration, about_me, dreams, school_learning, hobbies, role_models

Follow every step in order. Do not skip steps.

---

## STEP 1 — Validate input

Valid subcommands: (none), apply
Valid assessment types: inspiration, about_me, dreams, school_learning,
                        hobbies, role_models

If apply is used with assessment types, validate each type against
the list above. If any type is invalid:
- Stop and print:
  "Unknown assessment type: [type]
   Valid types: inspiration, about_me, dreams, school_learning,
                hobbies, role_models"
- Do not continue.

---

## STEP 2 — Guard checks

Check that ALL of the following are set in `.env.local`:
- `GOOGLE_SERVICE_ACCOUNT_JSON`
- `GOOGLE_SHEET_ID`
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`

If any are missing:
- Stop and print:
  "🔴 Missing environment variables. Check .env.local contains:
   GOOGLE_SERVICE_ACCOUNT_JSON   — Google Sheets service account credentials
   GOOGLE_SHEET_ID               — ID of the CSM PWA Module Questions sheet
   VITE_SUPABASE_URL             — Supabase project URL
   VITE_SUPABASE_ANON_KEY        — Supabase anon key
   SUPABASE_SERVICE_ROLE_KEY     — Supabase service role key (required to bypass RLS)

   See docs/google-sheets-setup.md for setup instructions."
- Do not continue.

Note: SUPABASE_SERVICE_ROLE_KEY is intentionally NOT prefixed with VITE_
because it must never be exposed to the browser bundle.
It is only used in server-side scripts (scripts/*.ts).

⚠️ Security: Before storing SUPABASE_SERVICE_ROLE_KEY in .env.local,
verify .env.local is gitignored:
  git check-ignore -v .env.local
If it is not ignored, add it to .gitignore before proceeding.

---

## STEP 3 — Run diff (always runs, even for apply)

Run: `npx tsx scripts/sync_sheet.ts`

If the script doesn't exist:
- Stop and print:
  "🔴 scripts/sync_sheet.ts not found.
   This script needs to be built first.
   See the full implementation prompt in your project docs."
- Do not continue.

The script must:

### 3a — Authenticate with Google Sheets API
- Load `GOOGLE_SERVICE_ACCOUNT_JSON` from `.env.local`
- Authenticate using googleapis JWT client
- Scope: https://www.googleapis.com/auth/spreadsheets.readonly

### 3b — Read only these 6 sheets
- 9.1_My Inspiration             → inspiration
- 9.2_About Me                   → about_me
- 9.3_My Dreams                  → dreams
- 9.4_My School, Learnings and I → school_learning
- 9.5_My Talents and Hobbies     → hobbies
- 9.6_My Role Models             → role_models

If a sheet tab is not found in the Google Sheet:
- Print: "⚠️ Sheet tab '[name]' not found — skipping this assessment.
  Verify tab names match exactly in the Google Sheet."
- Skip this assessment entirely — do not treat it as zero changes
- Do not include it in the diff report as having no changes
- List it in a "Skipped Tabs" section at the top of the report

### 3c — Fields to check per assessment (all 4 languages: en/kn/ta/hi)
- Module title
- Title text
- Subtitle text
- Question text (all questions)
- Help text (all questions)
- Summary title
- Summary questions (all summary questions)

### 3d — Unicode verification (CRITICAL)
For every native language field extracted from the sheet:
- Kannada: verify characters are in range U+0C80–U+0CFF
- Tamil: verify characters are in range U+0B80–U+0BFF
- Hindi: verify characters are in range U+0900–U+097F

If a native language field contains ONLY Latin characters
(no characters in the expected Unicode range):
- Flag as ENCODING_WARNING
- Do NOT include this field in any generated SQL
- Record full details for the report:
  assessment, field name, question number, language, actual value
  (first 50 chars), expected Unicode range

### 3e — Fetch current DB values
Query Supabase using SUPABASE_SERVICE_ROLE_KEY (not anon key).
The service role key bypasses RLS and is required to read all
translations across all students and assessments.
Never use VITE_SUPABASE_ANON_KEY for this operation.

Fetch all current values of the 7 field types across all 6
assessments and all 4 languages.

### 3f — Diff
Compare sheet vs DB field by field. Categorize each difference as:
- CHANGED — field exists in both but text differs
- NEW — field exists in sheet but not in DB
- MISSING — field exists in DB but not in sheet
  (flag only, never delete — just report)
- ENCODING_WARNING — native language field failed Unicode check

---

## STEP 4 — Generate diff report

Save timestamped report to:
`docs/sync-report-[YYYY-MM-DD].md`

Also overwrite (or create):
`docs/sync-report-latest.md`
with identical content to the timestamped file.

Both files must be written. If either fails, print an error and stop.

Report structure:

---
# Sheet Sync Report — [date]
Generated: [timestamp]

## Skipped Tabs ⚠️
(only show this section if any tabs were not found)
- [tab name] — not found in Google Sheet

## Encoding Warnings ⚠️
(show this section before the detailed diff if any warnings exist)
| Assessment | Field | Question | Language | Value Found | Expected Range |
|------------|-------|----------|----------|-------------|----------------|

These fields have been EXCLUDED from migration generation.
Fix the encoding issue in the Google Sheet before re-running.

## Summary
| Assessment | Changed | New | Missing | Encoding Warnings | Skipped |
|------------|---------|-----|---------|-------------------|---------|
| My Inspiration | | | | | |
| About Me | | | | | |
| My Dreams | | | | | |
| My School, My Learning and I | | | | | |
| My Talents and Hobbies | | | | | |
| My Role Models | | | | | |
| **TOTAL** | | | | | |

## Detailed Diff

### [Assessment Name]

#### [Field Type] — [Question Number if applicable] — [CHANGED/NEW/MISSING]
| Language | Current (DB) | New (Sheet) |
|----------|-------------|-------------|
| en | "..." | "..." |
| kn | "..." | "..." |
| ta | "..." | "..." |
| hi | "..." | "..." |

(show "unchanged" for languages with no diff)
(show "not in DB" or "not in sheet" for NEW/MISSING)

### [Assessment with no changes]
(no changes)

---

## Assessments With Changes
[list only assessments that have at least one CHANGED or NEW field]

## Next Steps
/sync-sheet apply              → generate migrations for all changed assessments
/sync-sheet apply inspiration  → generate migration for My Inspiration only
/sync-sheet apply inspiration,about_me → generate for specific assessments
---

---

## STEP 5 — If subcommand is (none) — stop here

Print:
"✅ Diff report saved:
   docs/sync-report-[date].md
   docs/sync-report-latest.md

Review the report, then run:
  /sync-sheet apply              → all changed assessments
  /sync-sheet apply <type>       → one assessment only
  /sync-sheet apply <t1>,<t2>   → specific assessments

⚠️ No SQL has been generated yet."

Stop. Do not generate any SQL.

---

## STEP 6 — If subcommand is `apply`

### 6a — Determine which assessments to generate for

If `/sync-sheet apply` (no types specified):
- Use all assessments that have CHANGED or NEW fields in the diff
- If no assessments have changes, print:
  "✅ No changes detected — nothing to migrate."
  and stop.

If `/sync-sheet apply <type>` or `/sync-sheet apply <t1>,<t2>`:
- Use only the specified assessment types
- If a specified assessment has no changes, print:
  "⚠️ [type] has no changes in the diff report. Skipping."
  and skip it.

### 6b — Check for encoding warnings

If any of the target assessments have ENCODING_WARNING fields:
- Print:
  "🔴 Encoding warnings detected in: [assessment list]

   The following fields have been excluded from SQL generation:
   [list each: assessment, field name, language, value found]

   These fields contain unexpected characters and may be corrupted
   in the Google Sheet. Fix the encoding issue in the sheet and
   re-run /sync-sheet before applying.

   Proceed with generating SQL for all OTHER fields in these
   assessments? (yes/no)"
- Wait for user response.
- If no: stop entirely.
- If yes: continue but skip ALL ENCODING_WARNING fields.

### 6c — Generate timestamps for migration files

Do not generate timestamps mentally or increment manually.

Instead:
1. List all existing files in `supabase/migrations/`
2. Find the highest existing timestamp prefix (format YYYYMMDDHHMMSS)
3. Increment by 1 second for each new file needed
4. If the incremented timestamp would still conflict with an existing
   file, increment again until no conflict exists
5. Verify each final timestamp against the full migrations directory
   before using it

### 6d — Generate one migration file per assessment

For each target assessment, create:
`supabase/migrations/[timestamp]_sync_[assessment_type].sql`

Migration file structure:

-- ============================================================
-- Sync Migration: [assessment_type]
-- Generated: [timestamp]
-- Source: Google Sheet ([GOOGLE_SHEET_ID])
-- Changes: [N changed, N new fields]
-- Encoding warnings excluded: [N fields or "none"]
-- Review before applying: supabase db push
-- ============================================================

-- ⚠️ UNICODE REMINDER
-- All native language strings use dollar-quoting ($...$)
-- Never edit these to use single quotes

BEGIN;

-- MODULE TITLE (only if changed/new)
INSERT INTO content_translations (resource_type, resource_key, lang, value)
VALUES
  ('[type]_module', 'title', 'en', $[value]$),
  ('[type]_module', 'title', 'kn', $[value]$),
  ('[type]_module', 'title', 'ta', $[value]$),
  ('[type]_module', 'title', 'hi', $[value]$)
ON CONFLICT (resource_type, resource_key, lang)
DO UPDATE SET value = EXCLUDED.value;

-- TITLE TEXT (only if changed/new)

-- SUBTITLE TEXT (only if changed/new)

-- QUESTION [N] (one block per changed/new question)
UPDATE [base_table]
SET
  question_text = $[en value]$,
  help_text = $[en help text]$
WHERE [key_column] = '[question_key]';

INSERT INTO content_translations (resource_type, resource_key, lang, value)
VALUES
  ('[type]_question', '[key]', 'kn', $[kn value]$),
  ('[type]_question', '[key]', 'ta', $[ta value]$),
  ('[type]_question', '[key]', 'hi', $[hi value]$)
ON CONFLICT (resource_type, resource_key, lang)
DO UPDATE SET value = EXCLUDED.value;

-- SUMMARY TITLE (only if changed/new)

-- SUMMARY QUESTION [N] (one block per changed/new summary question)

COMMIT;

CRITICAL Unicode rules for generated SQL:
- Write file with explicit UTF-8 encoding: { encoding: 'utf8' }
- ALL native language strings (kn/ta/hi) must use dollar-quoting: $text$
- NEVER use single quotes for native language strings
- After writing each file, read it back and verify a sample
  kn/ta/hi string matches the original from the sheet
- If verification fails: delete the file, print an error, and stop
  Do not proceed to the next assessment file if one fails.

Only include SQL blocks for CHANGED or NEW fields.
Do not include unchanged fields.
Do not include ENCODING_WARNING fields.

### 6e — Update snapshot (only if ALL files succeeded)

Track success/failure for each migration file generated.
If ANY file failed (Unicode verification failed, write error, etc.):
- Do NOT update questions_snapshot.json
- Print:
  "🔴 Snapshot NOT updated — [N] migration file(s) failed.
   Fix the errors above and re-run /sync-sheet apply."
- Stop.

Only if ALL files were generated and verified successfully:
- Update `scripts/questions_snapshot.json` with the current
  sheet state so the next run only diffs new changes.
- Print: "✅ Snapshot updated."

---

## STEP 7 — Print final report

Print:

✅ Sync complete

## Migrations Generated
[list each file with assessment type and change count]
  supabase/migrations/[timestamp]_sync_inspiration.sql (N changes)
  supabase/migrations/[timestamp]_sync_about_me.sql (N changes)

## Encoding Warnings (excluded from SQL)
[list each excluded field or "none"]

## Snapshot
[updated / not updated — with reason if not updated]

## Next Steps
1. Review each migration file carefully
2. Verify dollar-quoting is used for all kn/ta/hi strings
3. Run: supabase db push
4. Verify UI reflects changes in all 4 languages
5. Run /ship to confirm frontend build still passes
   (note: /ship validates TypeScript and Vite only — does not validate SQL)
6. Commit everything:
   git add supabase/migrations/ scripts/questions_snapshot.json
   git commit -m "chore: sync questions from Google Sheet [date]"

⚠️ Do not use git add . — stage only the migration files and snapshot.
