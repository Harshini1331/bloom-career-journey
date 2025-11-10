# Complete Workflow Test Checklist

## 🎯 Test Scenario: Student Submission → Teacher Approval → Student Notification

### Prerequisites
- ✅ Student account logged in
- ✅ Teacher account logged in (in separate browser/incognito)
- ✅ Student has completed "My Inspiration" assessment previously (or will complete it now)

---

## Step 1: Student Submits Assessment ✅

### Actions:
1. **Student** logs in and navigates to "My Inspiration" assessment
2. **Student** completes all required questions
3. **Student** clicks "Submit Assessment"

### Expected Results:
- ✅ Assessment is saved successfully
- ✅ AI summary is generated automatically
- ✅ Toast notification: "Summary Generated! 📝 Your teacher will review your reflection summary."
- ✅ **Teacher receives notification**:
  - Type: `assessment_submitted`
  - Title: `[Student Name] completed My Inspiration assessment`
  - Message: `A new My Inspiration assessment summary is ready for review.`
  - Link: `/teacher/ai-summary-review`
- ✅ Console log: `✅ Notification sent to teacher for summary review: [teacher_user_id]`

### Verification:
- Check teacher's notification bell (should show new notification)
- Check browser console for success logs
- Check database: `assessment_summaries` table should have new record with `approval_status = 'pending_approval'`

---

## Step 2: Teacher Reviews Summary ✅

### Actions:
1. **Teacher** logs in and navigates to `/teacher/ai-summary-review`
2. **Teacher** sees the pending summary in the list
3. **Teacher** clicks on the summary to review it

### Expected Results:
- ✅ Summary card displays with student name
- ✅ Summary content is visible
- ✅ "Approve" and "Reject" buttons are available
- ✅ Status shows "Pending Approval"

### Verification:
- Summary is visible in teacher dashboard
- All summary content is displayed correctly

---

## Step 3: Teacher Approves Summary ✅

### Actions:
1. **Teacher** reviews the summary
2. **Teacher** clicks "Approve" button
3. **Teacher** confirms approval (if dialog appears)

### Expected Results:
- ✅ Toast notification: "Summary Approved! ✅ [Student Name]'s reflection summary is now visible to them."
- ✅ Summary status changes to "Approved" in teacher dashboard
- ✅ **Student receives notification**:
  - Type: `summary_approved`
  - Title: `My Inspiration summary approved`
  - Message: `Your mentor approved your AI summary. Tap to view.`
  - Link: `/student`
- ✅ Console log: `✅ Notification sent to student: [student_user_id]`
- ✅ Database update: `assessment_summaries.approval_status = 'approved'`

### Verification:
- Check student's notification bell (should show new notification)
- Check browser console for success logs
- Check database: `assessment_summaries.approval_status = 'approved'` and `approved_at` is set

---

## Step 4: Student Dashboard Updates ✅

### Actions:
1. **Student** navigates to `/student` dashboard (or refreshes if already there)
2. **Student** checks the "My Inspiration" section

### Expected Results:
- ✅ **Real-time update** (if student dashboard is open):
  - Console log: `📢 Summary status updated (real-time): [payload]`
  - Console log: `🔄 Refreshing Inspiration summary...`
  - Summary status changes from "Pending Review" to "Approved" automatically
- ✅ **Periodic refresh** (every 30 seconds):
  - Console log: `🔄 Periodic summary refresh...`
  - Summary status updates if real-time didn't trigger
- ✅ **Page focus refresh**:
  - Console log: `👁️ Page focused, refreshing summaries...`
  - Summary status updates when page regains focus
- ✅ Summary section shows:
  - Status: "✅ Approved" (green badge)
  - Summary content is visible
  - "View Summary" button is enabled
- ✅ Console logs show:
  - `🔍 Calling get_summary_by_assessment RPC:`
  - `📊 RPC Response:` with summary data
  - `📊 Summary fetched:` with `approval_status: 'approved'`
  - `📊 Inspiration Summary State Updated:` with `isApproved: true`

### Verification:
- Student dashboard shows "Approved" status
- Summary content is visible
- No "Summary Pending Review" message
- Console shows successful fetch with approved status

---

## 🔍 Debugging Tips

### If Teacher Doesn't Receive Notification:
1. Check browser console for errors
2. Verify `notificationService.create()` returns `success: true`
3. Check database: `notifications` table should have new record
4. Verify teacher's `user_id` matches the notification's `user_id`

### If Student Doesn't Receive Notification:
1. Check browser console for errors
2. Verify `summary.student_user_id` is correct
3. Check database: `notifications` table should have new record with `type = 'summary_approved'`
4. Verify student's `user_id` matches the notification's `user_id`

### If Student Dashboard Doesn't Update:
1. **Check Real-time Subscription:**
   - Console should show: `📡 Real-time subscription status: SUBSCRIBED`
   - Console should show: `📢 Summary status updated (real-time):` when teacher approves
2. **Check RPC Function:**
   - Console should show: `🔍 Calling get_summary_by_assessment RPC:`
   - Console should show: `📊 RPC Response:` with data
   - If no data, check: `🔍 Direct query result:` to see if summary exists
3. **Check Database:**
   - Run: `SELECT id, assessment_response_id, approval_status FROM assessment_summaries WHERE assessment_response_id = '[id]';`
   - Should return one row with `approval_status = 'approved'`
4. **Check Function Authorization:**
   - Verify student's `user_id` matches the assessment response's student
   - Check RLS policies on `assessment_summaries` table

### If Summary Shows "No summary found":
1. Check if summary exists in database
2. Verify `get_summary_by_assessment` RPC is returning data
3. Check console logs for RPC errors
4. Verify student's `user_id` is correct in the RPC call

---

## 📊 Database Queries for Verification

### Check Summary Status:
```sql
SELECT 
    id,
    assessment_response_id,
    approval_status,
    approved_at,
    approved_by,
    student_user_id
FROM assessment_summaries
WHERE assessment_response_id = '[assessment_response_id]';
```

### Check Notifications:
```sql
-- Teacher notification
SELECT * FROM notifications 
WHERE user_id = '[teacher_user_id]' 
  AND type = 'assessment_submitted'
ORDER BY created_at DESC 
LIMIT 1;

-- Student notification
SELECT * FROM notifications 
WHERE user_id = '[student_user_id]' 
  AND type = 'summary_approved'
ORDER BY created_at DESC 
LIMIT 1;
```

### Test RPC Function:
```sql
SELECT * FROM get_summary_by_assessment(
    '[assessment_response_id]'::UUID,
    '[student_user_id]'::UUID
);
```

---

## ✅ Success Criteria

The workflow is successful if:
1. ✅ Student submits assessment → Teacher receives notification
2. ✅ Teacher approves summary → Student receives notification
3. ✅ Student dashboard updates automatically (real-time or within 30 seconds)
4. ✅ Student dashboard shows "Approved" status
5. ✅ Summary content is visible to student
6. ✅ All console logs show successful operations
7. ✅ Database records are correct

---

## 🚀 Ready to Test!

Follow the steps above and check each expected result. If any step fails, use the debugging tips to identify the issue.

