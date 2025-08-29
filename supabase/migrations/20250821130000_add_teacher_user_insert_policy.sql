-- Add RLS policies to allow teachers to create new users and students
-- This fixes the "User not allowed" error when teachers try to add students

-- First, add school_id column to users table if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'school_id') THEN
        ALTER TABLE public.users ADD COLUMN school_id UUID REFERENCES public.schools(id);
    END IF;
END $$;

-- Fix the email constraint issue - make email nullable again for mobile-only users
ALTER TABLE public.users ALTER COLUMN email DROP NOT NULL;

-- Drop the problematic constraint that requires email
ALTER TABLE public.users DROP CONSTRAINT IF EXISTS users_email_format_check;
ALTER TABLE public.users DROP CONSTRAINT IF EXISTS users_mobile_or_email_check;

-- Allow teachers to insert new users (for creating student accounts)
CREATE POLICY "Teachers can insert new users" ON public.users
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.users u
            JOIN public.teachers t ON u.id = t.user_id
            WHERE u.id = auth.uid() 
            AND u.role = 'teacher'
        )
    );

-- Allow teachers to insert new students
CREATE POLICY "Teachers can insert new students" ON public.students
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.teachers t
            WHERE t.user_id = auth.uid()
            AND t.id = teacher_id
        )
    );

-- Allow teachers to view users they created (for their students)
CREATE POLICY "Teachers can view their students' users" ON public.users
    FOR SELECT USING (
        id IN (
            SELECT s.user_id FROM public.students s
            JOIN public.teachers t ON s.teacher_id = t.id
            WHERE t.user_id = auth.uid()
        )
    );
