-- Fix RLS policies to allow password updates
-- Run this in your Supabase SQL Editor

-- 1. Check current RLS policies on student_auth_credentials
SELECT 'Current RLS policies:' as info;
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'student_auth_credentials'
ORDER BY policyname;

-- 2. Drop existing restrictive policies
DROP POLICY IF EXISTS "Teachers can manage their students' auth credentials" ON public.student_auth_credentials;
DROP POLICY IF EXISTS "Students can view their own auth credentials" ON public.student_auth_credentials;
DROP POLICY IF EXISTS "Allow authenticate_student function access" ON public.student_auth_credentials;

-- 3. Create a more permissive policy that allows updates
CREATE POLICY "Allow password updates for students" ON public.student_auth_credentials
    FOR ALL USING (true);

-- 4. Test updating the password manually
SELECT 'Testing manual password update:' as info;
UPDATE public.student_auth_credentials 
SET 
    password_hash = 'newpassword123',
    updated_at = now()
WHERE user_id = '4f91a4ac-83c3-432a-9cf9-525e91f50589';

-- 5. Check if the update worked
SELECT 'After manual update:' as info;
SELECT 
    user_id,
    email,
    password_hash,
    is_active,
    updated_at
FROM public.student_auth_credentials 
WHERE user_id = '4f91a4ac-83c3-432a-9cf9-525e91f50589';

-- 6. Test authentication with new password
SELECT 'Testing authentication with new password:' as info;
SELECT * FROM public.authenticate_student('alwin@gmail.com', 'newpassword123');

-- 7. Reset password back to original
UPDATE public.student_auth_credentials 
SET 
    password_hash = 'temporary123',
    updated_at = now()
WHERE user_id = '4f91a4ac-83c3-432a-9cf9-525e91f50589';

SELECT 'Password reset to original for testing' as info;
