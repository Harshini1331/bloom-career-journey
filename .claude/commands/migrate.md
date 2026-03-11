---
# /migrate

Scaffold a new Supabase migration file with the correct format,
timestamp, and project-specific reminders.

Usage: /migrate <name>
Example: /migrate add_hindi_language

Follow every step in order. Do not skip steps.

---

## STEP 1 — Validate input

If no name was provided after /migrate:
- Stop and print:
  "Usage: /migrate <name>
   Example: /migrate add_hindi_language
   Name should be lowercase with underscores, describing what the migration does."
- Do not continue.

Sanitize the name:
- Convert spaces to underscores
- Convert to lowercase
- Remove any special characters except underscores
- If name is longer than 50 characters, truncate and warn the user

---

## STEP 2 — Generate timestamp

Do not use the current wall-clock time to generate the timestamp.
Instead use this deterministic approach:

1. List all existing files in `supabase/migrations/`
2. Find the highest existing timestamp prefix (format YYYYMMDDHHMMSS)
3. Increment that timestamp by 1 second for the new file
4. Check that the resulting timestamp does not conflict with any
   existing file in `supabase/migrations/`
5. If it still conflicts, increment by 1 second again and repeat
   until no conflict exists
6. Use the final conflict-free timestamp for the new migration file

If `supabase/migrations/` is empty or does not exist:
- Use the current date at 000001 as the timestamp
  Example: 20260310000001

If a conflict exists after incrementing:
- Stop and print:
  "⚠️ Could not generate a unique timestamp for this migration.
   Existing file: [conflicting filename]
   Please wait a moment and re-run /migrate [name]."
- Do not continue until user re-runs the command.

---

## STEP 3 — Create migration file

Create the file:
`supabase/migrations/[timestamp]_[name].sql`

With this exact template:

-- ============================================================
-- Migration: [timestamp]_[name].sql
-- Created: [today's date in readable format e.g. 10 Mar 2026]
-- Description: [infer a one-line description from the name]
-- ============================================================

-- ⚠️  UNICODE REMINDER — CRITICAL
-- All Kannada, Tamil, and Hindi text MUST use dollar-quoting.
-- ✅ CORRECT:   value = $ಕನ್ನಡ$
-- ❌ INCORRECT: value = 'ಕನ್ನಡ'
-- Single quotes will corrupt or silently truncate native script.
-- Unicode ranges:
--   Kannada U+0C80–U+0CFF
--   Tamil   U+0B80–U+0BFF
--   Hindi   U+0900–U+097F

-- ⚠️  DRY-RUN CHECKLIST — review before running `supabase db push`
-- [ ] All table names match existing schema exactly
-- [ ] All column names are correct
-- [ ] RLS policies don't conflict with existing ones
-- [ ] Dollar-quoting used for ALL multilingual strings
-- [ ] Transaction will not leave DB in partial state if it fails
-- [ ] Rollback plan filled in (required for destructive changes)

-- ============================================================
-- ROLLBACK PLAN (optional — required for destructive changes)
-- Destructive = DROP TABLE, DROP COLUMN, ALTER TYPE, DELETE data
-- Additive changes (CREATE TABLE, ADD COLUMN) do not need this
-- ============================================================
-- [Describe or write the SQL to reverse this migration if needed]
-- Example: DROP TABLE IF EXISTS new_table;
-- Example: ALTER TABLE x DROP COLUMN IF EXISTS new_col;

BEGIN;

-- ============================================================
-- SCHEMA CHANGES
-- ============================================================

-- [Your schema changes here]
-- Examples:
-- CREATE TABLE IF NOT EXISTS table_name (
--   id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
--   user_id uuid REFERENCES users(id) ON DELETE CASCADE,
--   created_at timestamptz DEFAULT now()
-- );

-- ALTER TABLE existing_table ADD COLUMN IF NOT EXISTS new_column text;


-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

-- Enable RLS on any new tables (required for all tables)
-- ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;

-- ⚠️ Adapt each policy to your table's ownership model.
-- The templates below are for student-owned data.
-- Tables like counselling_resources or summary_templates
-- have different ownership — adjust accordingly.

-- Student policy — students access only their own rows
-- CREATE POLICY "students_own_rows" ON table_name
--   FOR ALL USING (
--     auth.uid() = user_id
--   );

-- Teacher policy — teachers access students in their state
-- ⚠️ This 3-table JOIN is correct for student-owned tables only.
-- Do not use this pattern for non-student-owned tables.
-- CREATE POLICY "teachers_read_state_students" ON table_name
--   FOR SELECT USING (
--     EXISTS (
--       SELECT 1 FROM students s
--       JOIN users u ON u.id = auth.uid()
--       JOIN teachers t ON t.user_id = u.id
--       WHERE s.user_id = table_name.user_id
--       AND t.state_id = (
--         SELECT state_id FROM users WHERE id = s.user_id
--       )
--     )
--   );

-- Admin policy — admins have full access
-- CREATE POLICY "admins_full_access" ON table_name
--   FOR ALL USING (
--     EXISTS (
--       SELECT 1 FROM users WHERE id = auth.uid() AND role = 'admin'
--     )
--   );


-- ============================================================
-- DATA / TRANSLATIONS
-- ============================================================

-- For multilingual content use dollar-quoting:
-- INSERT INTO content_translations (resource_type, resource_key, lang, value)
-- VALUES
--   ('module_name', 'key', 'en', $English text$),
--   ('module_name', 'key', 'kn', $ಕನ್ನಡ ಪಠ್ಯ$),
--   ('module_name', 'key', 'ta', $தமிழ் உரை$),
--   ('module_name', 'key', 'hi', $हिन्दी पाठ$)
-- ON CONFLICT (resource_type, resource_key, lang)
-- DO UPDATE SET value = EXCLUDED.value;


COMMIT;

---

## STEP 4 — Open the file in editor

Check if VS Code is available:
- Run: `code --version`
- If it succeeds: run `code supabase/migrations/[timestamp]_[name].sql`
- If it fails: try `notepad supabase/migrations/[timestamp]_[name].sql` (Windows)
- If neither works: print the full file path and tell the user
  to open it manually

---

## STEP 5 — Print confirmation

Print:

📄 Migration file created:
supabase/migrations/[timestamp]_[name].sql

Before applying:
1. Fill in your schema changes in the SCHEMA CHANGES section
2. Uncomment and adapt the RLS policies to match your table's ownership model
3. Add multilingual content using dollar-quoting for all kn/ta/hi strings
4. Fill in the ROLLBACK PLAN (optional but recommended for destructive
   changes like DROP TABLE, DROP COLUMN, ALTER TYPE, or DELETE)
5. Review and check off every item in the dry-run checklist
6. Run: supabase db push
7. Run /ship to verify the frontend build still passes
   (note: /ship validates TypeScript and Vite only — it does not validate SQL)

⚠️ Remember: dollar-quote ALL Kannada, Tamil, and Hindi strings.
