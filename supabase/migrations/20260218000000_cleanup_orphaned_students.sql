-- Clean up orphaned student records
-- Ideally, we should add a foreign key constraint, but first let's fix the data.

-- 1. Identify students with missing user_id (NULL)
SELECT count(*) FROM students WHERE user_id IS NULL;

-- 2. Identify students with user_id that does not exist in users table
SELECT count(*) 
FROM students s 
LEFT JOIN users u ON s.user_id = u.id 
WHERE u.id IS NULL;

-- 3. Delete students with invalid user_id (orphaned)
-- WARNING: This deletes data. Ensure backups.
DELETE FROM students 
WHERE user_id IS NULL 
   OR user_id NOT IN (SELECT id FROM users);

-- 4. Check if we can add NOT NULL constraint
-- ALTER TABLE students ALTER COLUMN user_id SET NOT NULL;

-- 5. Check if we can add Foreign Key constraint
-- ALTER TABLE students 
-- ADD CONSTRAINT fk_students_users 
-- FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
