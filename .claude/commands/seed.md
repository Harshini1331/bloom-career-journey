# /seed

Set up or tear down test data for local development and E2E testing.

Usage:
  /seed local        → create all test accounts + assessment responses
  /seed clean        → delete everything created by /seed local
  /seed status       → check which test accounts exist

Follow every step in order. Do not skip steps.

---

## STEP 1 — Validate input

If no argument was provided:
- Stop and print:
  "Usage:
     /seed local    — create test accounts and assessment responses
     /seed clean    — delete all seeded test data
     /seed status   — check which test accounts currently exist"
- Do not continue.

If argument is not one of: local, clean, status:
- Stop and print:
  "Unknown argument: [argument]
   Valid options: local, clean, status"
- Do not continue.

---

## STEP 2 — Guard checks (run for all subcommands)

Check that the following exist before proceeding:
- `.env.local` file exists at project root
- `VITE_SUPABASE_URL` is set in `.env.local`
- `VITE_SUPABASE_ANON_KEY` is set in `.env.local`

If any are missing:
- Stop and print:
  "🔴 Missing environment variables. Check .env.local contains:
   VITE_SUPABASE_URL
   VITE_SUPABASE_ANON_KEY"
- Do not continue.

Also warn:
"⚠️ /seed only supports local environment.
 Never run this against staging or production."

---

## STEP 3A — If argument is `status`

Check Supabase directly for these emails in public.users:
- teacher_test@ilp.test
- student_en@ilp.test
- student_kn@ilp.test
- student_ta@ilp.test
- student_hi@ilp.test

For each account that exists, also check assessment_responses
to see if completed responses exist (completed_at IS NOT NULL).

Print a status table:
| Account | Email | Exists | Has Responses |
|---------|-------|--------|---------------|
| Teacher | teacher_test@ilp.test | ✅/❌ | N/A |
| Student EN | student_en@ilp.test | ✅/❌ | ✅/❌ |
| Student KN | student_kn@ilp.test | ✅/❌ | ✅/❌ |
| Student TA | student_ta@ilp.test | ✅/❌ | ✅/❌ |
| Student HI | student_hi@ilp.test | ✅/❌ | ✅/❌ |

Then stop. Do not proceed to seeding or cleaning.
Do not print the AI summaries note (Step 4) after status.

---

## STEP 3B — If argument is `local`

### Check for existing data first
Before creating anything, run the status check from STEP 3A
to check if test accounts already exist.

If any accounts already exist:
- Print:
  "⚠️ Some test accounts already exist:
   [list which ones]

   Choose one:
   1. Skip existing accounts, create only missing ones
   2. Delete all existing test data and start fresh
      (same as /seed clean followed by /seed local)
   3. Abort"
- Wait for user response before continuing.

### Run the seed script
Run: `npx tsx scripts/seed_test_data.ts`

If the script doesn't exist:
- Stop and print:
  "🔴 scripts/seed_test_data.ts not found.
   This script needs to be created first.
   It should:
   1. Create teacher_test@ilp.test (password: Test@1234)
   2. Create student_en@ilp.test (EN, class 8, linked to teacher)
   3. Create student_kn@ilp.test (KN, class 8, linked to teacher)
   4. Create student_ta@ilp.test (TA, class 8, linked to teacher)
   5. Create student_hi@ilp.test (HI, class 8, linked to teacher)
   6. Insert completed assessment responses for all 6 assessments
      for each student using realistic rural Indian student answers
   7. Print a verification report on completion

   Create this script first, then re-run /seed local."
- Do not continue.

### Verify after seeding
After the script completes, run the status check from STEP 3A
and confirm all 5 accounts exist and all students have responses.

Print:
✅ Seed complete

| Account | Email | Status |
|---------|-------|--------|
| Teacher | teacher_test@ilp.test | ✅ Created |
| Student EN | student_en@ilp.test | ✅ Created + responses inserted |
| Student KN | student_kn@ilp.test | ✅ Created + responses inserted |
| Student TA | student_ta@ilp.test | ✅ Created + responses inserted |
| Student HI | student_hi@ilp.test | ✅ Created + responses inserted |

Test accounts are ready. Next steps:
1. Open http://localhost:5173
2. Log in with any test account (password: Test@1234)
3. Or run /test-plan <feature> to generate a test checklist

Then continue to Step 4.

---

## STEP 3C — If argument is `clean`

### Confirm before deleting
Print:
"⚠️ This will permanently delete all test data including:
 - All assessment summaries for test accounts
 - All assessment responses for test accounts
 - All profile_card_cache rows for test accounts
 - All career_roadmap rows for test accounts
 - All notifications for test accounts
 - All chat_channels and chat_messages for test accounts
 - students + teachers records
 - public.users records
 - auth.users records (last — after all dependents removed)

 Type YES to confirm, anything else to abort."

Wait for user response. Only continue if response is exactly "YES".

### Run the cleanup script
Run: `npx tsx scripts/cleanup_test_data.ts`

If the script doesn't exist:
- Stop and print:
  "🔴 scripts/cleanup_test_data.ts not found.
   This script needs to be created first.
   Delete rows in this exact order to respect FK constraints:

   1. assessment_summaries
      (FK → assessment_responses)
   2. assessment_responses
      (FK → students)
   3. profile_card_cache
      (FK → users)
   4. career_roadmap
      (FK → users)
   5. notifications
      (FK → users)
   6. chat_messages
      (FK → chat_channels)
   7. chat_channels
      (FK → users)
   8. students
      (FK → users)
   9. teachers
      (FK → users)
   10. public.users
       (FK → auth.users)
   11. auth.users
       ← delete last, after all dependents removed

   Filter every delete by the 5 test emails:
   teacher_test@ilp.test, student_en@ilp.test,
   student_kn@ilp.test, student_ta@ilp.test,
   student_hi@ilp.test

   Create this script first, then re-run /seed clean."
- Do not continue.

### Verify after cleanup
After the script completes, run the status check from STEP 3A
and confirm all 5 accounts no longer exist.

Print:
✅ Cleanup complete — all test data removed.

To reseed: /seed local

Do not print the AI summaries note (Step 4) after clean.

---

## STEP 4 — AI summaries note
Only print this after a successful /seed local. Skip for clean and status.

Print:
"ℹ️  Note: Assessment responses have been inserted but AI summaries
have NOT been auto-generated. To generate summaries:
1. Log in as each student at http://localhost:5173
2. The app will trigger summary generation automatically on first view
   OR
3. Ask the agent to call aiSummaryService.generate*Summary() manually
   for each student + assessment combination.

Teacher approval is also required before summaries are
visible to students."
