-- Enable RLS on student_auth_credentials so direct table queries are blocked.
-- SECURITY DEFINER RPCs (authenticate_student, update_user_profile) bypass RLS
-- and continue to work. No policies are needed — the table must only ever be
-- reached through those guarded RPCs, never via direct client queries.
ALTER TABLE public.student_auth_credentials ENABLE ROW LEVEL SECURITY;
