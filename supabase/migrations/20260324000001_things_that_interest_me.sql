CREATE TABLE things_that_interest_me (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  student_id uuid NOT NULL REFERENCES users(id),
  subject text NOT NULL DEFAULT '',
  lesson_chapter text NOT NULL DEFAULT '',
  why_factors text NOT NULL DEFAULT '',
  compatible_career text NOT NULL DEFAULT '',
  source_assessment text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- RLS
ALTER TABLE things_that_interest_me ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Students can manage their own interests"
ON things_that_interest_me FOR ALL
USING (student_id = (SELECT user_id FROM students WHERE user_id = auth.uid()))
WITH CHECK (student_id = (SELECT user_id FROM students WHERE user_id = auth.uid()));

-- Index
CREATE INDEX idx_things_interest_student ON things_that_interest_me(student_id);
