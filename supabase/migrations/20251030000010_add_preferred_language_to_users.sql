-- Add preferred_language to users with safe default and constraint
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS preferred_language TEXT NOT NULL DEFAULT 'en'
  CHECK (preferred_language IN ('en','kn'));

-- Backfill any existing NULLs just in case (older rows without default)
UPDATE public.users
SET preferred_language = 'en'
WHERE preferred_language IS NULL;


