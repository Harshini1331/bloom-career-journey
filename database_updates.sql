-- =====================================================
-- ENHANCED STUDENT MANAGEMENT DATABASE SCHEMA
-- For Teacher Dashboard (Vidya Saathi) Implementation
-- =====================================================

-- 1. ENHANCE USERS TABLE - Add profile fields
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS bio TEXT,
ADD COLUMN IF NOT EXISTS interests TEXT,
ADD COLUMN IF NOT EXISTS career_goals TEXT,
ADD COLUMN IF NOT EXISTS strengths TEXT,
ADD COLUMN IF NOT EXISTS areas_for_growth TEXT,
ADD COLUMN IF NOT EXISTS profile_picture_url TEXT,
ADD COLUMN IF NOT EXISTS date_of_birth DATE,
ADD COLUMN IF NOT EXISTS gender TEXT CHECK (gender IN ('male', 'female', 'other', 'prefer_not_to_say')),
ADD COLUMN IF NOT EXISTS address TEXT,
ADD COLUMN IF NOT EXISTS emergency_contact TEXT,
ADD COLUMN IF NOT EXISTS emergency_contact_relation TEXT,
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT NOW();

-- 2. ENHANCE STUDENTS TABLE - Add more student-specific fields
ALTER TABLE students 
ADD COLUMN IF NOT EXISTS enrollment_date TIMESTAMP DEFAULT NOW(),
ADD COLUMN IF NOT EXISTS enrollment_status TEXT DEFAULT 'active' CHECK (enrollment_status IN ('active', 'inactive', 'pending', 'graduated', 'transferred')),
ADD COLUMN IF NOT EXISTS previous_school TEXT,
ADD COLUMN IF NOT EXISTS special_needs TEXT,
ADD COLUMN IF NOT EXISTS parent_guardian_name TEXT,
ADD COLUMN IF NOT EXISTS parent_guardian_phone TEXT,
ADD COLUMN IF NOT EXISTS parent_guardian_email TEXT,
ADD COLUMN IF NOT EXISTS parent_guardian_occupation TEXT,
ADD COLUMN IF NOT EXISTS family_income_range TEXT CHECK (family_income_range IN ('below_50000', '50000_100000', '100000_200000', '200000_500000', 'above_500000')),
ADD COLUMN IF NOT EXISTS academic_performance TEXT CHECK (academic_performance IN ('excellent', 'good', 'average', 'below_average', 'needs_improvement')),
ADD COLUMN IF NOT EXISTS attendance_percentage DECIMAL(5,2) DEFAULT 100.00,
ADD COLUMN IF NOT EXISTS notes TEXT,
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT NOW();

-- 3. ENHANCE TEACHERS TABLE - Add teacher-specific fields
ALTER TABLE teachers 
ADD COLUMN IF NOT EXISTS specialization TEXT,
ADD COLUMN IF NOT EXISTS experience_years INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS qualification TEXT,
ADD COLUMN IF NOT EXISTS bio TEXT,
ADD COLUMN IF NOT EXISTS contact_phone TEXT,
ADD COLUMN IF NOT EXISTS contact_email TEXT,
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true,
ADD COLUMN IF NOT EXISTS joining_date DATE DEFAULT CURRENT_DATE,
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT NOW();

-- 4. CREATE COUNSELLING ACTIVITIES TABLE
CREATE TABLE IF NOT EXISTS counselling_activities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  sequence_order INTEGER NOT NULL,
  category TEXT CHECK (category IN ('self_discovery', 'career_exploration', 'skill_assessment', 'goal_setting', 'action_planning')),
  duration_minutes INTEGER DEFAULT 60,
  difficulty_level TEXT CHECK (difficulty_level IN ('beginner', 'intermediate', 'advanced')),
  target_grade TEXT CHECK (target_grade IN ('8', '9', '10', '11', '12', 'all')),
  resource_links JSONB DEFAULT '[]',
  worksheet_url TEXT,
  instructions TEXT,
  learning_objectives TEXT[],
  prerequisites TEXT[],
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  created_by UUID REFERENCES users(id)
);

-- 5. CREATE STUDENT ACTIVITY PROGRESS TABLE (Enhanced)
DROP TABLE IF EXISTS student_activity_progress;
CREATE TABLE student_activity_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID REFERENCES students(id) ON DELETE CASCADE,
  activity_id UUID REFERENCES counselling_activities(id) ON DELETE CASCADE,
  teacher_id UUID REFERENCES teachers(id),
  status TEXT DEFAULT 'not_started' CHECK (status IN ('not_started', 'assigned', 'in_progress', 'completed', 'on_hold')),
  assigned_date TIMESTAMP DEFAULT NOW(),
  started_date TIMESTAMP,
  completed_date TIMESTAMP,
  due_date TIMESTAMP,
  results_data JSONB DEFAULT '{}',
  counsellor_notes TEXT,
  student_feedback TEXT,
  completion_percentage INTEGER DEFAULT 0 CHECK (completion_percentage >= 0 AND completion_percentage <= 100),
  time_spent_minutes INTEGER DEFAULT 0,
  difficulty_rating INTEGER CHECK (difficulty_rating >= 1 AND difficulty_rating <= 5),
  enjoyment_rating INTEGER CHECK (enjoyment_rating >= 1 AND enjoyment_rating <= 5),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(student_id, activity_id)
);

-- 6. CREATE STUDENT NOTES TABLE
CREATE TABLE IF NOT EXISTS student_notes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID REFERENCES students(id) ON DELETE CASCADE,
  teacher_id UUID REFERENCES teachers(id),
  note_type TEXT CHECK (note_type IN ('observation', 'meeting', 'progress', 'concern', 'achievement', 'follow_up')),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  is_private BOOLEAN DEFAULT false,
  tags TEXT[],
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 7. CREATE STUDENT GROUPS TABLE
CREATE TABLE IF NOT EXISTS student_groups (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  teacher_id UUID REFERENCES teachers(id),
  school_id UUID REFERENCES schools(id),
  class_id UUID REFERENCES classes(id),
  max_students INTEGER DEFAULT 30,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 8. CREATE STUDENT GROUP MEMBERS TABLE
CREATE TABLE IF NOT EXISTS student_group_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id UUID REFERENCES student_groups(id) ON DELETE CASCADE,
  student_id UUID REFERENCES students(id) ON DELETE CASCADE,
  joined_date TIMESTAMP DEFAULT NOW(),
  is_active BOOLEAN DEFAULT true,
  UNIQUE(group_id, student_id)
);

-- 9. CREATE COUNSELLING RESOURCES TABLE
CREATE TABLE IF NOT EXISTS counselling_resources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  type TEXT CHECK (type IN ('pdf', 'video', 'chart', 'slides', 'worksheet', 'template', 'guide')),
  file_url TEXT,
  thumbnail_url TEXT,
  file_size_bytes BIGINT,
  duration_minutes INTEGER, -- for videos
  tags TEXT[],
  target_audience TEXT CHECK (target_audience IN ('students', 'teachers', 'parents', 'all')),
  grade_level TEXT CHECK (grade_level IN ('8', '9', '10', '11', '12', 'all')),
  is_active BOOLEAN DEFAULT true,
  download_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  created_by UUID REFERENCES users(id)
);

-- 10. CREATE ENROLLMENT REQUESTS TABLE (for future Option B implementation)
CREATE TABLE IF NOT EXISTS enrollment_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID REFERENCES students(id) ON DELETE CASCADE,
  teacher_id UUID REFERENCES teachers(id),
  requested_by UUID REFERENCES users(id),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'cancelled')),
  request_reason TEXT,
  response_notes TEXT,
  requested_at TIMESTAMP DEFAULT NOW(),
  responded_at TIMESTAMP,
  responded_by UUID REFERENCES users(id)
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Students table indexes
CREATE INDEX IF NOT EXISTS idx_students_teacher_id ON students(teacher_id);
CREATE INDEX IF NOT EXISTS idx_students_class_id ON students(class_id);
CREATE INDEX IF NOT EXISTS idx_students_enrollment_status ON students(enrollment_status);
CREATE INDEX IF NOT EXISTS idx_students_enrollment_date ON students(enrollment_date);

-- Student activity progress indexes
CREATE INDEX IF NOT EXISTS idx_student_activity_progress_student_id ON student_activity_progress(student_id);
CREATE INDEX IF NOT EXISTS idx_student_activity_progress_activity_id ON student_activity_progress(activity_id);
CREATE INDEX IF NOT EXISTS idx_student_activity_progress_status ON student_activity_progress(status);
CREATE INDEX IF NOT EXISTS idx_student_activity_progress_due_date ON student_activity_progress(due_date);

-- Counselling activities indexes
CREATE INDEX IF NOT EXISTS idx_counselling_activities_sequence ON counselling_activities(sequence_order);
CREATE INDEX IF NOT EXISTS idx_counselling_activities_category ON counselling_activities(category);
CREATE INDEX IF NOT EXISTS idx_counselling_activities_target_grade ON counselling_activities(target_grade);

-- Student notes indexes
CREATE INDEX IF NOT EXISTS idx_student_notes_student_id ON student_notes(student_id);
CREATE INDEX IF NOT EXISTS idx_student_notes_teacher_id ON student_notes(teacher_id);
CREATE INDEX IF NOT EXISTS idx_student_notes_note_type ON student_notes(note_type);

-- =====================================================
-- SAMPLE DATA FOR TESTING
-- =====================================================

-- Insert sample counselling activities
INSERT INTO counselling_activities (title, description, sequence_order, category, target_grade, learning_objectives) VALUES
('Self-Introduction & Goal Setting', 'Help students introduce themselves and set initial career goals', 1, 'self_discovery', 'all', ARRAY['Build self-awareness', 'Set initial career goals', 'Establish rapport']),
('Interest & Hobby Exploration', 'Explore student interests and hobbies to identify potential career paths', 2, 'career_exploration', 'all', ARRAY['Identify personal interests', 'Connect hobbies to careers', 'Explore passion areas']),
('Strengths & Skills Assessment', 'Assess student strengths and identify skill development areas', 3, 'skill_assessment', 'all', ARRAY['Identify key strengths', 'Assess current skills', 'Plan skill development']),
('Career Path Research', 'Research different career paths and educational requirements', 4, 'career_exploration', '10', ARRAY['Research career options', 'Understand requirements', 'Explore educational paths']),
('Action Plan Creation', 'Create personalized action plan for career development', 5, 'action_planning', '11', ARRAY['Set specific goals', 'Create timeline', 'Identify resources needed']);

-- =====================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Enable RLS on new tables
ALTER TABLE counselling_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_activity_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_group_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE counselling_resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE enrollment_requests ENABLE ROW LEVEL SECURITY;

-- Basic RLS policies (can be enhanced later)
CREATE POLICY "Teachers can view all counselling activities" ON counselling_activities FOR SELECT USING (true);
CREATE POLICY "Teachers can manage student activity progress" ON student_activity_progress FOR ALL USING (true);
CREATE POLICY "Teachers can manage student notes" ON student_notes FOR ALL USING (true);
CREATE POLICY "Teachers can manage student groups" ON student_groups FOR ALL USING (true);
CREATE POLICY "Teachers can manage group members" ON student_group_members FOR ALL USING (true);
CREATE POLICY "Teachers can view counselling resources" ON counselling_resources FOR SELECT USING (true);
CREATE POLICY "Teachers can manage enrollment requests" ON enrollment_requests FOR ALL USING (true);

-- =====================================================
-- COMMENTS FOR DOCUMENTATION
-- =====================================================

COMMENT ON TABLE counselling_activities IS 'Defines the sequence of counselling activities for students';
COMMENT ON TABLE student_activity_progress IS 'Tracks student progress through counselling activities';
COMMENT ON TABLE student_notes IS 'Stores teacher observations and notes about students';
COMMENT ON TABLE student_groups IS 'Allows teachers to create custom groups for targeted activities';
COMMENT ON TABLE counselling_resources IS 'Repository of educational materials and resources';
COMMENT ON TABLE enrollment_requests IS 'Manages student enrollment requests between teachers';

COMMENT ON COLUMN students.enrollment_status IS 'Current enrollment status of the student';
COMMENT ON COLUMN students.family_income_range IS 'Family income range for scholarship considerations';
COMMENT ON COLUMN students.academic_performance IS 'Overall academic performance rating';
COMMENT ON COLUMN students.attendance_percentage IS 'Student attendance percentage';

COMMENT ON COLUMN student_activity_progress.completion_percentage IS 'Percentage completion of the activity (0-100)';
COMMENT ON COLUMN student_activity_progress.difficulty_rating IS 'Student rating of activity difficulty (1-5)';
COMMENT ON COLUMN student_activity_progress.enjoyment_rating IS 'Student rating of activity enjoyment (1-5)';
