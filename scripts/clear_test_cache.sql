DELETE FROM profile_card_cache
WHERE student_id IN (
  SELECT user_id FROM students 
  WHERE teacher_id IN (
    SELECT user_id FROM teachers 
    WHERE user_id IN (
      SELECT id FROM users WHERE email = 'teacher_test@ilp.test'
    )
  )
);
