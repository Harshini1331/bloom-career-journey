# /test-plan

Generate a structured manual test checklist for a given feature.
Saves to docs/test-plan-[feature]-[date].md.

Usage: /test-plan <feature>
Example: /test-plan sync-sheet
Example: /test-plan assessment-summary-lock

Follow every step in order. Do not skip steps.

---

## STEP 1 — Validate input

If no feature name was provided:
- Stop and print:
  "Usage: /test-plan <feature>
   Example: /test-plan sync-sheet
   Feature name should describe what you are testing."
- Do not continue.

---

## STEP 2 — Ask the user two questions (wait for both answers)

Ask:
"1. Which user roles are relevant for this feature?
   a) Student only
   b) Teacher only
   c) Admin only
   d) Student + Teacher
   e) Student + Teacher + Admin

2. Which languages should be tested?
   a) English only
   b) English + Kannada
   c) English + Tamil
   d) English + Hindi
   e) All 4 languages (en/kn/ta/hi)
   f) Custom — specify which ones"

Store both answers. Do not continue until user responds.

---

## STEP 3 — Read project context

Before generating the test plan, read these files to understand
the feature being tested:
- CLAUDE.md — for project structure, DB schema, and conventions
- Any relevant component files mentioned in CLAUDE.md related
  to the feature name
- Any existing test files in docs/ related to this feature

This ensures the test plan uses real field names, real routes,
and real DB table names — not generic placeholders.

---

## STEP 4 — Generate test plan

Create the file:
`docs/test-plan-[feature]-[YYYY-MM-DD].md`

Use this structure:

# Test Plan: [Feature Name]
**Date:** [today's date]
**Roles tested:** [from Step 2 answer 1]
**Languages tested:** [from Step 2 answer 2]
**Tester:** [ ]
**Overall status:** [ ] Not started / [ ] In progress / [ ] Complete

---

## Pre-conditions
- [ ] Dev server running at http://localhost:5173
- [ ] Test accounts exist — run: `/seed local` (preferred) or `npx tsx scripts/seed_test_data.ts`
- [ ] [any other feature-specific pre-conditions]

---

## Test Accounts
| Role | Email | Password | Notes |
|------|-------|----------|-------|
| Student (EN) | student_en@ilp.test | Test@1234 | Seeded |
| Student (KN) | student_kn@ilp.test | Test@1234 | Seeded |
| Student (TA) | student_ta@ilp.test | Test@1234 | Seeded |
| Student (HI) | student_hi@ilp.test | Test@1234 | Seeded |
| Teacher | teacher_test@ilp.test | Test@1234 | Seeded |
| Admin | admin_test@ilp.test | Test@1234 | ⚠️ Not seeded — create manually if testing Admin |

Only include rows for roles and languages selected in Step 2.

---

## [Role 1] Flow

### Happy Path
- [ ] [step 1 — specific to the feature, use real UI labels]
- [ ] [step 2]
- [ ] [step 3]

### Edge Cases
- [ ] [edge case 1 — empty states, missing data]
- [ ] [edge case 2 — concurrent actions]
- [ ] [edge case 3 — network failures if relevant]

### Language Checks
(one sub-section per language being tested)

#### English
- [ ] All labels display in English
- [ ] [feature-specific English check]

#### Kannada (if selected)
- [ ] UI switches to Kannada automatically for kn student
- [ ] All labels display in Kannada script (not Latin)
- [ ] [feature-specific Kannada check]

#### Tamil (if selected)
- [ ] UI switches to Tamil automatically for ta student
- [ ] All labels display in Tamil script (not Latin)
- [ ] [feature-specific Tamil check]

#### Hindi (if selected)
- [ ] UI switches to Hindi automatically for hi student
- [ ] All labels display in Hindi script (not Latin)
- [ ] [feature-specific Hindi check]

---

## [Role 2] Flow (if applicable)
(same structure as Role 1)

---

## DB Verification
After completing UI steps, verify DB state directly in Supabase.
To access: open Supabase dashboard → Table Editor, or run: `supabase db studio`

- [ ] [table name]: [what to check — use real table names from CLAUDE.md]
- [ ] [table name]: [what to check]
- [ ] No orphaned rows left behind

---

## Error & Edge Case Scenarios
- [ ] What happens if the user loses internet mid-action?
- [ ] What happens if the user submits the same action twice?
- [ ] What happens with empty/null data?
- [ ] [feature-specific error scenario]

---

## Screenshot Checklist
Take screenshots at these points and save to docs/test-screenshots/:
- [ ] [screenshot 1 — describe what to capture]
- [ ] [screenshot 2]
- [ ] [screenshot 3]

Filename format: [feature]_[step]_[lang]_[date].png
Example: sync-sheet_diff-report_en_2026-03-10.png

---

## Bug Log
If any bugs are found during testing, log them here.
Do NOT fix bugs during testing — log and continue.

| # | Role | Language | Step | Expected | Actual | Screenshot |
|---|------|----------|------|----------|--------|------------|
| 1 | | | | | | |

---

## Sign-off
- [ ] All happy path steps passed
- [ ] All edge cases tested
- [ ] All languages verified
- [ ] DB state verified
- [ ] Screenshots saved
- [ ] Bugs logged in bug table above

**Tested by:** _______________
**Date completed:** _______________

---

## STEP 5 — Print confirmation

Print:

📋 Test plan created:
docs/test-plan-[feature]-[date].md

To run this test:
1. Start dev server: npm run dev
2. Set up test accounts if needed: /seed local
   Note: admin_test@ilp.test is not seeded —
   create it manually if your test plan requires admin testing
3. Open the test plan and work through each section top to bottom
4. Log any bugs in the Bug Log table — do not fix during testing
5. Once complete, run /ship before committing any fixes

Note: /wrap-up will not add this file to CLAUDE.md — test plan files
are intentionally excluded from project memory as ephemeral artifacts.
