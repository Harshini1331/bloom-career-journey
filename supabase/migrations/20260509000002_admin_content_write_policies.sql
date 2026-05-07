-- Migration: Admin write policies for content management tables
-- The Apr-2026 RLS pass added read-only SELECT for authenticated users on content tables.
-- Admins need write access for the admin dashboard to manage these tables directly.
-- RPCs that are SECURITY DEFINER (upsert_media_source etc.) already bypass RLS; this
-- migration covers the admin-dashboard paths that use direct table queries.

BEGIN;

-- ── assessment_summary_templates ─────────────────────────────────────────────
-- Admin needs to toggle is_active and edit summary_questions JSONB.
CREATE POLICY "Admins can update assessment_summary_templates"
  ON public.assessment_summary_templates FOR UPDATE
  USING  (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'))
  WITH CHECK (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'));

-- ── assessment_media_sources ──────────────────────────────────────────────────
-- INSERT/UPDATE done via SECURITY DEFINER RPC upsert_media_source.
-- Admin also needs DELETE for the "remove media" action.
CREATE POLICY "Admins can delete assessment_media_sources"
  ON public.assessment_media_sources FOR DELETE
  USING (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'));

-- ── inspiration_sources ───────────────────────────────────────────────────────
-- Not covered by the April 2026 RLS pass; enable RLS idempotently then add policies.
ALTER TABLE public.inspiration_sources ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read inspiration_sources"
  ON public.inspiration_sources FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Admins can manage inspiration_sources"
  ON public.inspiration_sources FOR ALL
  USING  (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'))
  WITH CHECK (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'));

-- ── content_translations ──────────────────────────────────────────────────────
-- Previously read-only for all authenticated users. Admins need INSERT/UPDATE/DELETE.
CREATE POLICY "Admins can manage content_translations"
  ON public.content_translations FOR ALL
  USING  (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'))
  WITH CHECK (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'));

COMMIT;
