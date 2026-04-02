-- Migration: Enable RLS on 18 public content/question tables
-- These are mostly read-only content tables. SECURITY DEFINER RPCs bypass RLS,
-- but direct client queries (supabase.from(...).select()) need SELECT policies.

BEGIN;

-- ============================================================
-- 1. Enable RLS on all 18 tables
-- ============================================================

ALTER TABLE assessment_summary_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE my_next_project_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE my_next_project_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE career_guidance_tools_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE assessment_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE assessment_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE assessment_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE assessment_question_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE assessment_media_sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE holland_code_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE inspiration_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE inspiration_videos ENABLE ROW LEVEL SECURITY;
ALTER TABLE dreams_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE school_learning_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE about_me_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE school_learning_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE hobbies_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE about_me_fields ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- 2. SELECT policy for authenticated users (read-only content)
-- ============================================================

CREATE POLICY "Authenticated users can read assessment_summary_templates"
  ON assessment_summary_templates FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read my_next_project_questions"
  ON my_next_project_questions FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read career_guidance_tools_questions"
  ON career_guidance_tools_questions FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read assessment_templates"
  ON assessment_templates FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read assessment_sections"
  ON assessment_sections FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read assessment_questions"
  ON assessment_questions FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read assessment_question_options"
  ON assessment_question_options FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read assessment_media_sources"
  ON assessment_media_sources FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read holland_code_questions"
  ON holland_code_questions FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read inspiration_questions"
  ON inspiration_questions FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read inspiration_videos"
  ON inspiration_videos FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read dreams_questions"
  ON dreams_questions FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read school_learning_options"
  ON school_learning_options FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read about_me_questions"
  ON about_me_questions FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read school_learning_questions"
  ON school_learning_questions FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read hobbies_questions"
  ON hobbies_questions FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read about_me_fields"
  ON about_me_fields FOR SELECT
  USING (auth.role() = 'authenticated');

-- ============================================================
-- 3. my_next_project_responses — student owns own data
-- ============================================================

CREATE POLICY "Students can manage own next project responses"
  ON my_next_project_responses FOR ALL
  USING (student_id IN (SELECT id FROM students WHERE user_id = auth.uid()))
  WITH CHECK (student_id IN (SELECT id FROM students WHERE user_id = auth.uid()));

-- Teachers can read their students' responses
CREATE POLICY "Teachers can read student next project responses"
  ON my_next_project_responses FOR SELECT
  USING (
    student_id IN (
      SELECT s.id FROM students s
      JOIN teachers t ON s.teacher_id = t.id
      WHERE t.user_id = auth.uid()
    )
  );

COMMIT;
