-- Debug student authentication issue
-- Run this in your Supabase SQL Editor

-- 1. Check if alwin exists in users table
SELECT 'Checking alwin in users table:' as info;
SELECT 
    id,
    full_name,
    email,
    mobile,
    role,
    created_at
FROM public.users 
WHERE email = 'alwin@gmail.com' OR mobile = 'alwin@gmail.com'
ORDER BY created_at DESC;

-- 2. Check if alwin has auth credentials
SELECT 'Checking alwin auth credentials:' as info;
SELECT 
    sac.id,
    sac.user_id,
    sac.email,
    sac.mobile,
    sac.password_hash,
    sac.is_active,
    sac.created_at,
    sac.updated_at
FROM public.student_auth_credentials sac
JOIN public.users u ON sac.user_id = u.id
WHERE u.email = 'alwin@gmail.com' OR u.mobile = 'alwin@gmail.com';

-- 3. Test the authenticate_student function
SELECT 'Testing authenticate_student function:' as info;
SELECT * FROM public.authenticate_student('alwin@gmail.com', 'temporary123');

-- 4. Check if there are any RLS issues
SELECT 'Checking RLS policies:' as info;
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd
FROM pg_policies 
WHERE tablename = 'student_auth_credentials'
ORDER BY policyname;

-- 5. Try to manually update the password to test
SELECT 'Manually updating password for testing:' as info;
UPDATE public.student_auth_credentials 
SET 
    password_hash = 'temporary123',
    is_active = true,
    updated_at = now()
WHERE user_id = (
    SELECT id FROM public.users 
    WHERE email = 'alwin@gmail.com' OR mobile = 'alwin@gmail.com'
    LIMIT 1
);

-- 6. Test authentication again
SELECT 'Testing authentication after manual update:' as info;
SELECT * FROM public.authenticate_student('alwin@gmail.com', 'temporary123');
