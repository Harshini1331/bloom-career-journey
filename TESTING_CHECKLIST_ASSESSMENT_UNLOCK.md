# Testing Checklist: Assessment Unlock Flow

## ✅ Ready for Testing!

All unlock checks have been implemented. Use this checklist to verify everything works correctly.

---

## 🧪 Test Scenarios

### 1. **Direct URL Access Tests** (Most Important)

Test accessing assessments via direct URL without completing prerequisites:

- [ ] **Test 1.1**: Navigate to `/student/assessment/about-me` without completing "My Inspiration"
  - **Expected**: Should redirect to `/student` with error message "Please complete 'My Inspiration' first."
  
- [ ] **Test 1.2**: Navigate to `/student/assessment/dreams` without completing "About Me"
  - **Expected**: Should redirect to `/student` with error message "Please complete 'My Inspiration, About Me' first."
  
- [ ] **Test 1.3**: Navigate to `/student/assessment/school-learning` without completing "My Dreams"
  - **Expected**: Should redirect to `/student` with error message showing missing prerequisites
  
- [ ] **Test 1.4**: Navigate to `/student/assessment/hobbies` without completing "My School"
  - **Expected**: Should redirect to `/student` with error message showing missing prerequisites
  
- [ ] **Test 1.5**: Navigate to `/student/assessment/role-models` without completing "My Hobbies"
  - **Expected**: Should redirect to `/student` with error message showing missing prerequisites
  
- [ ] **Test 1.6**: Navigate to `/student/assessment/holland-code` without completing "My Role Models"
  - **Expected**: Should redirect to `/student` with error message showing missing prerequisites
  
- [ ] **Test 1.7**: Navigate to `/student/assessment/career-guidance-tools` without completing "Holland Code"
  - **Expected**: Should redirect to `/student` with error message showing missing prerequisites

---

### 2. **Card Click Tests**

Test clicking locked cards from the dashboard:

- [ ] **Test 2.1**: Click "About Me" card without completing "My Inspiration"
  - **Expected**: Toast message "Assessment Locked" + "Complete the previous assessment to unlock this one."
  - **Expected**: Should NOT navigate to the assessment page
  
- [ ] **Test 2.2**: Click "My Dreams" card without completing "About Me"
  - **Expected**: Toast message + no navigation
  
- [ ] **Test 2.3**: Click any locked card
  - **Expected**: Toast message + no navigation

---

### 3. **Sequential Unlock Tests**

Test that assessments unlock in the correct order:

- [ ] **Test 3.1**: Complete "My Inspiration"
  - **Expected**: "About Me" card should unlock (blue, clickable, "Available" badge)
  
- [ ] **Test 3.2**: Complete "About Me"
  - **Expected**: "My Dreams" card should unlock
  
- [ ] **Test 3.3**: Complete "My Dreams"
  - **Expected**: "My School, My Learning and I" card should unlock
  
- [ ] **Test 3.4**: Complete "My School, My Learning and I"
  - **Expected**: "My Talents and Hobbies" card should unlock
  
- [ ] **Test 3.5**: Complete "My Talents and Hobbies"
  - **Expected**: "My Role Models" card should unlock
  
- [ ] **Test 3.6**: Complete "My Role Models"
  - **Expected**: "Holland Code (RIASEC) Test" card should unlock
  
- [ ] **Test 3.7**: Complete "Holland Code (RIASEC) Test"
  - **Expected**: "Exploring Career Guidance Tools" card should unlock

---

### 4. **Visual State Tests**

Test that cards show correct visual states:

- [ ] **Test 4.1**: Locked cards show gray background, "Locked" badge, disabled cursor
- [ ] **Test 4.2**: Unlocked cards show blue background, "Available" badge, clickable cursor
- [ ] **Test 4.3**: Completed cards show green background, "Completed" badge, clickable cursor

---

### 5. **Language Tests**

Test error messages in both languages:

- [ ] **Test 5.1**: Switch to English, try accessing locked assessment
  - **Expected**: Error message in English
  
- [ ] **Test 5.2**: Switch to Kannada, try accessing locked assessment
  - **Expected**: Error message in Kannada (ಮೌಲ್ಯಮಾಪನ ಲಾಕ್ ಮಾಡಲಾಗಿದೆ)

---

### 6. **Teacher Access Tests**

Test that teachers can view completed assessments:

- [ ] **Test 6.1**: As a teacher, view a student's completed assessment in read-only mode
  - **Expected**: Should load without redirect (unlock check skipped)
  - **Expected**: Assessment should be in read-only mode

---

### 7. **Edge Cases**

Test edge cases:

- [ ] **Test 7.1**: Try accessing assessment while logged out
  - **Expected**: Should redirect to auth page (handled by ProtectedRoute)
  
- [ ] **Test 7.2**: Complete assessment, then try accessing it again
  - **Expected**: Should load successfully (completed assessments are accessible)
  
- [ ] **Test 7.3**: Try accessing "My Inspiration" directly
  - **Expected**: Should load successfully (always unlocked)

---

## 🐛 What to Look For

### ✅ Should Work:
- Direct URL access to locked assessments redirects to dashboard
- Error messages show correct missing prerequisites
- Cards unlock in correct sequence
- Visual states are correct (locked/unlocked/completed)
- Error messages work in both languages
- Teachers can view completed assessments

### ❌ Potential Issues to Watch For:
- Infinite redirect loops
- Error messages showing incorrect prerequisites
- Cards not unlocking after completion
- Unlock check running in read-only mode (should be skipped)
- Performance issues (too many database queries)

---

## 📝 Notes

- All unlock checks run on component mount (via `useEffect`)
- The check is skipped if `readOnlyView === true` (for teacher access)
- Error messages include all missing prerequisites, not just the first one
- The unlock check queries the `assessment_responses` table for `completed_at` timestamps

---

## 🚀 Ready to Test!

Start with **Test 1.1** (Direct URL Access) as this is the most critical test. If that works, proceed with the rest of the tests.

If you encounter any issues, note them down and we can fix them!

