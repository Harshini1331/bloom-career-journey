-- Migration: Create Career Guidance Tools Assessment
-- This migration creates the database structure for "Exploring Career Guidance Tools" (8th assessment)

-- Add career_guidance_tools to assessment_type enum if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_type WHERE typname = 'assessment_type'
    ) THEN
        CREATE TYPE assessment_type AS ENUM ('inspiration', 'about_me', 'my_next_project', 'dreams', 'school_learning', 'role_models', 'hobbies', 'personality', 'career_guidance_tools');
    ELSE
        -- Add career_guidance_tools to existing enum if not present
        IF NOT EXISTS (
            SELECT 1 FROM pg_enum 
            WHERE enumlabel = 'career_guidance_tools' 
            AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'assessment_type')
        ) THEN
            ALTER TYPE assessment_type ADD VALUE IF NOT EXISTS 'career_guidance_tools';
        END IF;
    END IF;
END $$;

-- Create career_guidance_tools_questions table
CREATE TABLE IF NOT EXISTS career_guidance_tools_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_text TEXT NOT NULL,
    question_type TEXT NOT NULL CHECK (question_type IN ('textarea', 'checkbox', 'input')),
    help_text TEXT,
    sequence_number INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Clear existing questions (if any)
DELETE FROM career_guidance_tools_questions;

-- Insert 7 questions for Career Guidance Tools assessment
INSERT INTO career_guidance_tools_questions (question_text, question_type, help_text, sequence_number) VALUES

-- Question 1: Textarea
('Did you know that there are many different career paths before you took a look at the career chart and career planner?', 'textarea', 'Reflect on your awareness of career options before this workshop. Think about how much you knew about different career paths, fields, and opportunities before exploring the career chart and planner. Be honest about your previous knowledge.', 1),

-- Question 2: Textarea (list 5 careers)
('List 5 new career options that you didn''t know about before and learned about - from this workshop.', 'textarea', 'Think about the career chart, planner, website, and chatbot you explored. Identify at least 5 careers or professions that were completely new to you or that you didn''t know existed. List them clearly and if possible, mention what interests you about them.', 2),

-- Question 3: Textarea (list 2 careers with multiple paths)
('List 2 careers that can be reached with more than one path on the career chart. (For e.g. - You can become a lawyer by taking Arts courses in PUC, B. A and then LLB or by choosing the science stream in PUC, B.Sc. and then LLB.)', 'textarea', 'Look at the career chart carefully. Find careers that can be achieved through different educational paths or streams. For each career you list, describe at least two different educational routes to reach that career. This shows flexibility in career planning.', 3),

-- Question 4: Textarea (admission process)
('List the admission process for any career you are interested in, see the career chart and planner for the required educational qualifications, job opportunities, skills, and courses.', 'textarea', 'Choose a career that interests you from the career chart or planner. Research and list: 1) Required educational qualifications (10th, PUC, degree, etc.), 2) Admission process (entrance exams, eligibility, application steps), 3) Job opportunities in that field, 4) Skills needed, 5) Courses or subjects to study. Be detailed and specific.', 4),

-- Question 5: Textarea (ILP website information)
('Visit the ILP website and list out all the information required for career guidance.', 'textarea', 'Navigate through the ILP (Career Guidance) website. Explore different sections, resources, tools, and information available. List all the types of information, resources, or tools you found that can help with career guidance. This could include articles, assessments, career descriptions, educational paths, etc.', 5),

-- Question 6: Checkbox (Yes/No for mobile app)
('ILP''s mobile application is available in the Android Play Store', 'checkbox', 'This is a Yes/No question. If you found or know that ILP has a mobile application available in the Android Play Store, select Yes. If not, or if you''re unsure, select No.', 6),

-- Question 7: Input (chatbot number)
('Write down ILP''s mobile chat bot number.', 'input', 'If you explored the WhatsApp chatbot during the workshop, write down the phone number or contact information for ILP''s mobile chatbot. This could be a WhatsApp number, phone number, or chatbot identifier that you can use to access career guidance support.', 7);

-- Create function to get career guidance tools questions
CREATE OR REPLACE FUNCTION get_career_guidance_tools_questions()
RETURNS TABLE (
    id UUID,
    question_text TEXT,
    question_type TEXT,
    help_text TEXT,
    sequence_number INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.id,
        c.question_text,
        c.question_type,
        c.help_text,
        c.sequence_number
    FROM career_guidance_tools_questions c
    WHERE c.is_active = true
    ORDER BY c.sequence_number;
END $$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_career_guidance_tools_questions() TO authenticated;

-- Verify data insertion
DO $$
DECLARE
    tools_q_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO tools_q_count FROM career_guidance_tools_questions;
    
    RAISE NOTICE 'Career Guidance Tools Questions Update Complete:';
    RAISE NOTICE 'Total Questions: %', tools_q_count;
    
    IF tools_q_count = 7 THEN
        RAISE NOTICE '✅ All 7 questions inserted successfully!';
    ELSE
        RAISE WARNING '⚠️ Expected 7 questions, found %', tools_q_count;
    END IF;
END $$;

