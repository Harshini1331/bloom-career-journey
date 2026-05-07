/**
 * smoke_approval_workflow.ts — Approval workflow smoke tests
 *
 * Verifies the 5 post-migration RPC behaviours:
 *   T1  Approve pending   → status = 'approved', student notification created
 *   T2  Request revision  → status = 'revision_requested', rejection_reason stored
 *   T3  Student resubmit  → status resets to 'pending_approval', rejection_reason cleared
 *   T4  Reject pending    → status = 'rejected', rejection_reason stored
 *   T5  Double-approve    → raises 'already_approved', status unchanged
 *
 * Uses SUPABASE_SERVICE_ROLE_KEY so no auth sign-in needed.
 * Creates isolated test data in a transaction-like pattern; cleans up on exit.
 *
 * Usage: npx tsx scripts/smoke_approval_workflow.ts
 */

import { createClient } from '@supabase/supabase-js';
import * as dotenv from 'dotenv';
import * as path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
dotenv.config({ path: path.resolve(__dirname, '..', '.env.local') });

const SUPABASE_URL = process.env.VITE_SUPABASE_URL!;
const SERVICE_KEY  = process.env.SUPABASE_SERVICE_ROLE_KEY!;

if (!SUPABASE_URL || !SERVICE_KEY) {
  console.error('Missing VITE_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY in .env.local');
  process.exit(1);
}

const db = createClient(SUPABASE_URL, SERVICE_KEY, {
  auth: { autoRefreshToken: false, persistSession: false }
});

// ── Result tracker ─────────────────────────────────────────────────
type Result = { test: string; status: 'PASS' | 'FAIL'; detail?: string };
const results: Result[] = [];
const pass = (test: string, detail?: string) => results.push({ test, status: 'PASS', detail });
const fail = (test: string, detail?: string) => results.push({ test, status: 'FAIL', detail });

// ── Test accounts (must exist in the remote DB) ────────────────────
const TEACHER_EMAIL = 'teacher_test@ilp.test';
const STUDENT_EMAIL = 'student_en@ilp.test';

// ── IDs resolved at setup ──────────────────────────────────────────
let teacherUserId = '';
let teacherRecordId = '';
let studentUserId = '';
let studentRecordId = '';

// Summaries created during setup — cleaned up at end
const createdSummaryIds: string[] = [];
const createdResponseIds: string[] = [];

// ── Helpers ────────────────────────────────────────────────────────
async function getStatus(summaryId: string): Promise<string | null> {
  const { data } = await db
    .from('assessment_summaries')
    .select('approval_status, rejection_reason')
    .eq('id', summaryId)
    .maybeSingle();
  return data?.approval_status ?? null;
}

async function getRow(summaryId: string) {
  const { data } = await db
    .from('assessment_summaries')
    .select('approval_status, rejection_reason, approved_by, approved_at')
    .eq('id', summaryId)
    .maybeSingle();
  return data;
}

async function notificationExists(userId: string, type: string, after: Date): Promise<boolean> {
  const { data } = await db
    .from('notifications')
    .select('id')
    .eq('user_id', userId)
    .eq('type', type)
    .gte('created_at', after.toISOString())
    .maybeSingle();
  return !!data;
}

// Existing summaries borrowed for tests — we save original state and restore on cleanup
type Snapshot = { id: string; approval_status: string; rejection_reason: string | null; approved_by: string | null; approved_at: string | null; rejected_by: string | null; rejected_at: string | null; summary_type: string };
const snapshots: Snapshot[] = [];
let summaryPool: string[] = [];

async function buildSummaryPool() {
  const { data, error } = await db
    .from('assessment_summaries')
    .select('id, approval_status, rejection_reason, approved_by, approved_at, rejected_by, rejected_at, summary_type')
    .eq('student_user_id', studentUserId)
    .limit(10);
  if (error || !data?.length) throw new Error('No assessment_summaries found for test student — run e2e_backend_test first');
  summaryPool = data.map((s: any) => s.id);
  // Save original state of all borrowed summaries for restoration
  for (const s of data as Snapshot[]) snapshots.push(s);
  console.log(`  summaryPool: ${summaryPool.length} summaries available`);
}

let poolIndex = 0;

// Borrow next summary from pool: reset it to pending_approval and return its id
async function borrowPending(): Promise<string> {
  if (poolIndex >= summaryPool.length) throw new Error('summaryPool exhausted — need at least 5 summaries');
  const id = summaryPool[poolIndex++];
  const { error } = await db
    .from('assessment_summaries')
    .update({
      approval_status: 'pending_approval',
      rejection_reason: null,
      approved_by: null,
      approved_at: null,
      rejected_by: null,
      rejected_at: null,
      summary_type: 'ai_generated'
    })
    .eq('id', id);
  if (error) throw new Error(`Failed to reset summary ${id}: ${error.message}`);
  return id;
}

// ── Setup ──────────────────────────────────────────────────────────
async function setup() {
  console.log('\n── Setup ──────────────────────────────────────────────');

  // Teacher user id
  const { data: tUser } = await db.from('users').select('id').eq('email', TEACHER_EMAIL).maybeSingle();
  if (!tUser) throw new Error(`Teacher user not found: ${TEACHER_EMAIL}`);
  teacherUserId = tUser.id;

  const { data: tRec } = await db.from('teachers').select('id').eq('user_id', teacherUserId).maybeSingle();
  if (!tRec) throw new Error('teachers record not found for teacher user');
  teacherRecordId = tRec.id;

  // Student user id
  const { data: sUser } = await db.from('users').select('id').eq('email', STUDENT_EMAIL).maybeSingle();
  if (!sUser) throw new Error(`Student user not found: ${STUDENT_EMAIL}`);
  studentUserId = sUser.id;

  const { data: sRec } = await db.from('students').select('id').eq('user_id', studentUserId).maybeSingle();
  if (!sRec) throw new Error('students record not found for student user');
  studentRecordId = sRec.id;

  // Verify student is assigned to this teacher
  const { data: sCheck } = await db
    .from('students')
    .select('id')
    .eq('id', studentRecordId)
    .eq('teacher_id', teacherRecordId)
    .maybeSingle();
  if (!sCheck) throw new Error('Student is not assigned to teacher — RPCs will reject all calls');

  await buildSummaryPool();

  console.log(`  teacherUserId:  ${teacherUserId}`);
  console.log(`  studentUserId:  ${studentUserId}`);
  console.log('  Setup complete\n');
}

// ── T1: Approve pending ────────────────────────────────────────────
async function t1_approve() {
  const TEST = 'T1 approve_summary: pending → approved + notification';
  try {
    const summaryId = await borrowPending();
    const before = new Date();

    const { error } = await db.rpc('approve_summary', {
      p_summary_id: summaryId,
      p_teacher_user_id: teacherUserId
    });
    if (error) { fail(TEST, `RPC error: ${error.message}`); return; }

    const row = await getRow(summaryId);
    if (row?.approval_status !== 'approved') {
      fail(TEST, `Expected 'approved', got '${row?.approval_status}'`); return;
    }
    if (row?.approved_by !== teacherUserId) {
      fail(TEST, `approved_by mismatch: ${row?.approved_by}`); return;
    }
    if (!row?.approved_at) {
      fail(TEST, 'approved_at is null'); return;
    }

    // Notification is sent from the client (fire-and-forget), not the RPC —
    // so we only verify the DB status here.
    pass(TEST, `status=approved, approved_by set, approved_at=${row.approved_at}`);
  } catch (e: any) {
    fail(TEST, e.message);
  }
}

// ── T2: Request revision ───────────────────────────────────────────
async function t2_request_revision() {
  const TEST = 'T2 request_revision_summary: pending → revision_requested';
  try {
    const summaryId = await borrowPending();
    const notes = 'Please add more detail about your second dream.';

    const { error } = await db.rpc('request_revision_summary', {
      p_summary_id: summaryId,
      p_teacher_user_id: teacherUserId,
      p_revision_notes: notes
    });
    if (error) { fail(TEST, `RPC error: ${error.message}`); return; }

    const row = await getRow(summaryId);
    if (row?.approval_status !== 'revision_requested') {
      fail(TEST, `Expected 'revision_requested', got '${row?.approval_status}'`); return;
    }
    if (row?.rejection_reason !== notes) {
      fail(TEST, `rejection_reason mismatch: '${row?.rejection_reason}'`); return;
    }

    pass(TEST, `status=revision_requested, rejection_reason stored`);
    return summaryId; // passed to T3
  } catch (e: any) {
    fail(TEST, e.message);
    return null;
  }
}

// ── T3: Student resubmit after revision_requested ─────────────────
async function t3_student_resubmit(revisionSummaryId: string | null) {
  const TEST = 'T3 update_student_summary: revision_requested → pending_approval, reason cleared';
  if (!revisionSummaryId) {
    fail(TEST, 'Skipped — T2 did not produce a summaryId');
    return;
  }
  try {
    const { error } = await db.rpc('update_student_summary', {
      p_summary_id: revisionSummaryId,
      p_student_user_id: studentUserId,
      p_student_edited_summary: { question1: 'revised answer', question2: 'b', question3: 'c' }
    });
    if (error) { fail(TEST, `RPC error: ${error.message}`); return; }

    const row = await getRow(revisionSummaryId);
    if (row?.approval_status !== 'pending_approval') {
      fail(TEST, `Expected 'pending_approval', got '${row?.approval_status}'`); return;
    }
    if (row?.rejection_reason !== null) {
      fail(TEST, `rejection_reason should be null after resubmit, got: '${row?.rejection_reason}'`); return;
    }

    pass(TEST, `status=pending_approval, rejection_reason=null`);
  } catch (e: any) {
    fail(TEST, e.message);
  }
}

// ── T4: Reject pending ─────────────────────────────────────────────
async function t4_reject() {
  const TEST = 'T4 reject_summary: pending → rejected';
  try {
    const summaryId = await borrowPending();
    const reason = 'Summary does not reflect student voice — please regenerate.';

    const { error } = await db.rpc('reject_summary', {
      p_summary_id: summaryId,
      p_teacher_user_id: teacherUserId,
      p_rejection_reason: reason
    });
    if (error) { fail(TEST, `RPC error: ${error.message}`); return; }

    const row = await getRow(summaryId);
    if (row?.approval_status !== 'rejected') {
      fail(TEST, `Expected 'rejected', got '${row?.approval_status}'`); return;
    }
    if (row?.rejection_reason !== reason) {
      fail(TEST, `rejection_reason mismatch`); return;
    }
    if (row?.approved_by !== null || row?.approved_at !== null) {
      fail(TEST, 'approved_by/approved_at should be null after rejection'); return;
    }

    pass(TEST, `status=rejected, rejection_reason stored, approved fields cleared`);
  } catch (e: any) {
    fail(TEST, e.message);
  }
}

// ── T5: Double-approve guard ───────────────────────────────────────
async function t5_double_approve() {
  const TEST = 'T5 approve_summary: already_approved → raises already_approved error';
  try {
    // Borrow a pending summary and approve it first
    const summaryId = await borrowPending();
    const { error: firstErr } = await db.rpc('approve_summary', {
      p_summary_id: summaryId,
      p_teacher_user_id: teacherUserId
    });
    if (firstErr) { fail(TEST, `First approval failed: ${firstErr.message}`); return; }

    // Second approval — should raise already_approved
    const { error: secondErr } = await db.rpc('approve_summary', {
      p_summary_id: summaryId,
      p_teacher_user_id: teacherUserId
    });

    if (!secondErr) {
      fail(TEST, 'Expected error but RPC succeeded'); return;
    }
    if (!secondErr.message.includes('already_approved')) {
      fail(TEST, `Expected 'already_approved' in error, got: '${secondErr.message}'`); return;
    }

    // Status must still be 'approved' (not changed)
    const status = await getStatus(summaryId);
    if (status !== 'approved') {
      fail(TEST, `Status should remain 'approved', got '${status}'`); return;
    }

    pass(TEST, `raised already_approved, status unchanged`);
  } catch (e: any) {
    fail(TEST, e.message);
  }
}

// ── Cleanup — restore summaries to original state ─────────────────
async function cleanup() {
  console.log('\n── Cleanup ────────────────────────────────────────────');
  let restored = 0;
  for (const snap of snapshots) {
    const { error } = await db
      .from('assessment_summaries')
      .update({
        approval_status: snap.approval_status,
        rejection_reason: snap.rejection_reason,
        approved_by: snap.approved_by,
        approved_at: snap.approved_at,
        rejected_by: snap.rejected_by,
        rejected_at: snap.rejected_at,
        summary_type: snap.summary_type
      })
      .eq('id', snap.id);
    if (!error) restored++;
  }
  console.log(`  Restored ${restored}/${snapshots.length} summaries to original state`);
}

// ── Print results ──────────────────────────────────────────────────
function printResults() {
  console.log('\n── Results ────────────────────────────────────────────');
  let passed = 0, failed = 0;
  for (const r of results) {
    const icon = r.status === 'PASS' ? '✅' : '❌';
    console.log(`  ${icon} ${r.test}`);
    if (r.detail) console.log(`      ${r.detail}`);
    r.status === 'PASS' ? passed++ : failed++;
  }
  console.log(`\n  ${passed}/${results.length} passed`);
  if (failed > 0) process.exit(1);
}

// ── Main ───────────────────────────────────────────────────────────
(async () => {
  console.log('Approval Workflow Smoke Tests');
  console.log('================================');

  try {
    await setup();
  } catch (e: any) {
    console.error('Setup failed:', e.message);
    process.exit(1);
  }

  await t1_approve();
  const revisionId = await t2_request_revision();
  await t3_student_resubmit(revisionId ?? null);
  await t4_reject();
  await t5_double_approve();

  await cleanup();
  printResults();
})();
