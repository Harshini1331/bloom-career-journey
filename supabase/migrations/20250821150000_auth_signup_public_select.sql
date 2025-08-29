-- Allow unauthenticated (anon) users to read schools and classes for the signup page
-- This fixes 500/authorization errors on the /auth page when loading school/class dropdowns

-- Schools: keep existing authenticated policy, add anon SELECT
DO $$
BEGIN
  -- Create anon select policy for schools if it doesn't already exist
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' AND tablename = 'schools' AND policyname = 'Public can view schools (signup)'
  ) THEN
    CREATE POLICY "Public can view schools (signup)" ON public.schools
      FOR SELECT TO anon USING (true);
  END IF;
END $$;

-- Classes: add anon SELECT so users can pick class during signup
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' AND tablename = 'classes' AND policyname = 'Public can view classes (signup)'
  ) THEN
    CREATE POLICY "Public can view classes (signup)" ON public.classes
      FOR SELECT TO anon USING (true);
  END IF;
END $$;


