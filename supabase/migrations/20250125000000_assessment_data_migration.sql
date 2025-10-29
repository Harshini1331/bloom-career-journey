-- Migration: Move Assessment Data to Database
-- This migration creates tables to store all assessment questions, options, help text, and media sources

-- Create assessment_templates table for assessment metadata
CREATE TABLE IF NOT EXISTS assessment_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assessment_type assessment_type NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    instructions TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create assessment_sections table for organizing questions into sections
CREATE TABLE IF NOT EXISTS assessment_sections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assessment_template_id UUID REFERENCES assessment_templates(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    sequence_number INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create assessment_questions table for individual questions
CREATE TABLE IF NOT EXISTS assessment_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    section_id UUID REFERENCES assessment_sections(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    question_type TEXT NOT NULL CHECK (question_type IN ('text', 'textarea', 'checkbox', 'radio', 'multiple_choice', 'rating', 'boolean')),
    help_text TEXT,
    is_required BOOLEAN DEFAULT true,
    sequence_number INTEGER NOT NULL,
    validation_rules JSONB, -- Store validation rules as JSON
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create assessment_question_options table for multiple choice options
CREATE TABLE IF NOT EXISTS assessment_question_options (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id UUID REFERENCES assessment_questions(id) ON DELETE CASCADE,
    option_text TEXT NOT NULL,
    option_value TEXT NOT NULL,
    sequence_number INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create assessment_media_sources table for videos, audio, and other media
CREATE TABLE IF NOT EXISTS assessment_media_sources (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assessment_template_id UUID REFERENCES assessment_templates(id) ON DELETE CASCADE,
    media_type TEXT NOT NULL CHECK (media_type IN ('video', 'audio', 'image', 'document')),
    title TEXT NOT NULL,
    url TEXT NOT NULL,
    description TEXT,
    thumbnail_url TEXT,
    duration_seconds INTEGER,
    sequence_number INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_assessment_templates_type ON assessment_templates(assessment_type);
CREATE INDEX IF NOT EXISTS idx_assessment_templates_active ON assessment_templates(is_active);
CREATE INDEX IF NOT EXISTS idx_assessment_sections_template ON assessment_sections(assessment_template_id);
CREATE INDEX IF NOT EXISTS idx_assessment_sections_sequence ON assessment_sections(sequence_number);
CREATE INDEX IF NOT EXISTS idx_assessment_questions_section ON assessment_questions(section_id);
CREATE INDEX IF NOT EXISTS idx_assessment_questions_sequence ON assessment_questions(sequence_number);
CREATE INDEX IF NOT EXISTS idx_assessment_question_options_question ON assessment_question_options(question_id);
CREATE INDEX IF NOT EXISTS idx_assessment_question_options_sequence ON assessment_question_options(sequence_number);
CREATE INDEX IF NOT EXISTS idx_assessment_media_sources_template ON assessment_media_sources(assessment_template_id);
CREATE INDEX IF NOT EXISTS idx_assessment_media_sources_sequence ON assessment_media_sources(sequence_number);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_assessment_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_assessment_templates_updated_at
    BEFORE UPDATE ON assessment_templates
    FOR EACH ROW
    EXECUTE FUNCTION update_assessment_updated_at();

-- Insert assessment templates
INSERT INTO assessment_templates (assessment_type, title, description, instructions) VALUES
('inspiration', 'My Inspiration', 'Reflect on inspirational videos and audio content', 'Watch each video and answer the reflection questions thoughtfully.'),
('dreams', 'My Dreams', 'Explore your future aspirations and goals', 'Think about your dreams and what you want to achieve in life.'),
('school_learning', 'My School Learning', 'Reflect on your school experience and learning preferences', 'Answer honestly about your school experience and learning style.'),
('role_models', 'My Role Models', 'Identify and reflect on people who inspire you', 'Think about people who have influenced you positively.'),
('hobbies', 'My Hobbies', 'Explore your interests and activities', 'Share your interests and what activities you enjoy.'),
('personality', 'Holland Code Test', 'Discover your personality type and career interests', 'Answer honestly about your preferences and interests.'),
('career_aptitude', 'Career Aptitude', 'Assess your career interests and aptitudes', 'Reflect on your career interests and strengths.');

-- Get template IDs for reference
DO $$
DECLARE
    inspiration_template_id UUID;
    dreams_template_id UUID;
    school_template_id UUID;
    role_models_template_id UUID;
    hobbies_template_id UUID;
    personality_template_id UUID;
    career_template_id UUID;
BEGIN
    -- Get template IDs
    SELECT id INTO inspiration_template_id FROM assessment_templates WHERE assessment_type = 'inspiration';
    SELECT id INTO dreams_template_id FROM assessment_templates WHERE assessment_type = 'dreams';
    SELECT id INTO school_template_id FROM assessment_templates WHERE assessment_type = 'school_learning';
    SELECT id INTO role_models_template_id FROM assessment_templates WHERE assessment_type = 'role_models';
    SELECT id INTO hobbies_template_id FROM assessment_templates WHERE assessment_type = 'hobbies';
    SELECT id INTO personality_template_id FROM assessment_templates WHERE assessment_type = 'personality';
    SELECT id INTO career_template_id FROM assessment_templates WHERE assessment_type = 'career_aptitude';

    -- Insert sections for Inspiration Assessment
    INSERT INTO assessment_sections (assessment_template_id, title, description, sequence_number) VALUES
    (inspiration_template_id, 'Video Reflections', 'Reflect on each inspirational video', 1);

    -- Insert sections for Dreams Assessment
    INSERT INTO assessment_sections (assessment_template_id, title, description, sequence_number) VALUES
    (dreams_template_id, 'Future Dreams', 'Explore your aspirations and goals', 1),
    (dreams_template_id, 'Achievement Planning', 'Plan how to achieve your dreams', 2);

    -- Insert sections for School Learning Assessment
    INSERT INTO assessment_sections (assessment_template_id, title, description, sequence_number) VALUES
    (school_template_id, 'School Experience', 'Reflect on your school experience', 1),
    (school_template_id, 'Learning Preferences', 'Identify your learning style', 2),
    (school_template_id, 'School Environment', 'Share thoughts about your school environment', 3);

    -- Insert sections for Role Models Assessment
    INSERT INTO assessment_sections (assessment_template_id, title, description, sequence_number) VALUES
    (role_models_template_id, 'Role Model Identification', 'Identify people who inspire you', 1);

    -- Insert sections for Hobbies Assessment
    INSERT INTO assessment_sections (assessment_template_id, title, description, sequence_number) VALUES
    (hobbies_template_id, 'Interests and Activities', 'Share your hobbies and interests', 1);

    -- Insert sections for Personality Assessment (Holland Code)
    INSERT INTO assessment_sections (assessment_template_id, title, description, sequence_number) VALUES
    (personality_template_id, 'Interest Assessment', 'Rate your interest in various activities', 1);

    -- Insert sections for Career Aptitude Assessment
    INSERT INTO assessment_sections (assessment_template_id, title, description, sequence_number) VALUES
    (career_template_id, 'Career Interests', 'Explore your career interests and aptitudes', 1);

    -- Insert Inspiration Assessment Questions
    INSERT INTO assessment_questions (section_id, question_text, question_type, help_text, sequence_number) 
    SELECT s.id, q.question_text, q.question_type, q.help_text, q.sequence_number
    FROM assessment_sections s
    CROSS JOIN (VALUES
        ('Write about the moments or messages you enjoyed or that made you feel motivated.', 'textarea', 'Write about the moments or messages you enjoyed or that made you feel motivated.', 1),
        ('Mention the main lessons or ideas you got from watching or listening.', 'textarea', 'Mention the main lessons or ideas you got from watching or listening.', 2),
        ('Say what actions, habits, or thoughts from the video you want to try in your own life.', 'textarea', 'Say what actions, habits, or thoughts from the video you want to try in your own life.', 3),
        ('Write how this video might change the way you think, feel, or behave.', 'textarea', 'Write how this video might change the way you think, feel, or behave.', 4),
        ('Write about the good qualities or values in the characters that you also have.', 'textarea', 'Write about the good qualities or values in the characters that you also have.', 5),
        ('Describe what you would do or feel if you were in the same situation.', 'textarea', 'Describe what you would do or feel if you were in the same situation.', 6),
        ('Write about the part of the video/audio that motivated or inspired you the most.', 'textarea', 'Write about the part of the video/audio that motivated or inspired you the most.', 7)
    ) AS q(question_text, question_type, help_text, sequence_number)
    WHERE s.assessment_template_id = inspiration_template_id;

    -- Insert Dreams Assessment Questions
    INSERT INTO assessment_questions (section_id, question_text, question_type, help_text, sequence_number) 
    SELECT s.id, q.question_text, q.question_type, q.help_text, q.sequence_number
    FROM assessment_sections s
    CROSS JOIN (VALUES
        ('What are your future dreams?', 'textarea', 'Think about what you want to achieve in life', 1),
        ('What educational degree would you like to pursue?', 'textarea', 'Consider your educational goals', 2),
        ('What career would you like to have?', 'textarea', 'Think about your ideal profession', 3),
        ('Would you like to play any professional sport?', 'textarea', 'Consider sports and physical activities', 4),
        ('Would you like to write books, articles, or stories?', 'textarea', 'Think about writing and creative expression', 5),
        ('Would you like to learn to play any musical instrument?', 'textarea', 'Consider music and artistic pursuits', 6),
        ('Which college would you like to go to?', 'textarea', 'Think about higher education', 7),
        ('Would you like to help others in any way?', 'textarea', 'Consider how you want to contribute to society', 8),
        ('Where would you like to live?', 'textarea', 'Think about your ideal living situation', 9),
        ('Would you like to do any form of art?', 'textarea', 'Consider artistic and creative activities', 10),
        ('Do you have any other dreams?', 'textarea', 'Share any other aspirations you have', 11),
        ('Do you want to make your dreams come true?', 'textarea', 'Reflect on your commitment to your dreams', 12)
    ) AS q(question_text, question_type, help_text, sequence_number)
    WHERE s.assessment_template_id = dreams_template_id AND s.sequence_number = 1;

    INSERT INTO assessment_questions (section_id, question_text, question_type, help_text, sequence_number) 
    SELECT s.id, q.question_text, q.question_type, q.help_text, q.sequence_number
    FROM assessment_sections s
    CROSS JOIN (VALUES
        ('What do you think you need to achieve your dreams?', 'textarea', 'Think about the resources and support you need', 1),
        ('What is the first step you would take to achieve your dreams?', 'textarea', 'Consider the immediate actions you can take', 2),
        ('Do you have the willpower and enthusiasm to achieve your dreams?', 'textarea', 'Reflect on your motivation and determination', 3),
        ('What obstacles do you think you might face?', 'textarea', 'Consider potential challenges and how to overcome them', 4)
    ) AS q(question_text, question_type, help_text, sequence_number)
    WHERE s.assessment_template_id = dreams_template_id AND s.sequence_number = 2;

    -- Insert School Learning Assessment Questions
    INSERT INTO assessment_questions (section_id, question_text, question_type, help_text, sequence_number) 
    SELECT s.id, q.question_text, q.question_type, q.help_text, q.sequence_number
    FROM assessment_sections s
    CROSS JOIN (VALUES
        ('Do you like to come to school?', 'textarea', 'Reflect on your feelings about school', 1),
        ('Why do you like to come to school?', 'textarea', 'Think about what makes school enjoyable for you', 2),
        ('Why don''t you like coming to school?', 'textarea', 'Consider what challenges you face at school', 3),
        ('Who is your best friend at school?', 'textarea', 'Think about your social connections at school', 4),
        ('Which is your favourite subject/topic?', 'textarea', 'Identify subjects you enjoy most', 5),
        ('Why do you like these topics?', 'textarea', 'Reflect on what makes these subjects interesting', 6),
        ('Which subject/s do you not like?', 'textarea', 'Consider subjects that are challenging for you', 7)
    ) AS q(question_text, question_type, help_text, sequence_number)
    WHERE s.assessment_template_id = school_template_id AND s.sequence_number = 1;

    INSERT INTO assessment_questions (section_id, question_text, question_type, help_text, sequence_number) 
    SELECT s.id, q.question_text, q.question_type, q.help_text, q.sequence_number
    FROM assessment_sections s
    CROSS JOIN (VALUES
        ('Why do you not like these subjects?', 'textarea', 'Think about what makes these subjects difficult', 1),
        ('In which subject/s do you score more marks?', 'textarea', 'Identify your academic strengths', 2),
        ('In which subject/s do you score less marks?', 'textarea', 'Consider areas where you need improvement', 3),
        ('How do you like to learn?', 'checkbox', 'Select all learning methods that work for you', 4),
        ('Apart from school curriculum, what attracts you to school?', 'textarea', 'Think about extracurricular activities and social aspects', 5)
    ) AS q(question_text, question_type, help_text, sequence_number)
    WHERE s.assessment_template_id = school_template_id AND s.sequence_number = 2;

    INSERT INTO assessment_questions (section_id, question_text, question_type, help_text, sequence_number) 
    SELECT s.id, q.question_text, q.question_type, q.help_text, q.sequence_number
    FROM assessment_sections s
    CROSS JOIN (VALUES
        ('What school activities would you like to participate in?', 'textarea', 'Think about clubs, sports, and other activities', 1),
        ('What would you want to change about your school?', 'textarea', 'Consider improvements you would like to see', 2),
        ('What is your favourite place to study and why?', 'textarea', 'Reflect on your ideal study environment', 3),
        ('Is school important for your learning?', 'textarea', 'Think about the value of school in your education', 4),
        ('How can schooling help you realise your dreams?', 'textarea', 'Connect your school experience to your future goals', 5)
    ) AS q(question_text, question_type, help_text, sequence_number)
    WHERE s.assessment_template_id = school_template_id AND s.sequence_number = 3;

    -- Insert Holland Code Test Questions (Personality Assessment)
    INSERT INTO assessment_questions (section_id, question_text, question_type, help_text, sequence_number) 
    SELECT s.id, q.question_text, q.question_type, q.help_text, q.sequence_number
    FROM assessment_sections s
    CROSS JOIN (VALUES
        -- Realistic (R) questions
        ('I like to fix a car', 'boolean', 'Rate your interest in mechanical activities', 1),
        ('I like to build things', 'boolean', 'Consider your interest in construction and building', 2),
        ('I like to take care of animals', 'boolean', 'Think about your interest in animal care', 3),
        ('I like working outdoors', 'boolean', 'Consider your preference for outdoor work', 4),
        ('I like to play a sport', 'boolean', 'Think about your interest in sports and physical activity', 5),
        ('I like to paint a room', 'boolean', 'Consider your interest in hands-on activities', 6),
        ('I like to cook', 'boolean', 'Think about your interest in cooking and food preparation', 7),
        
        -- Investigative (I) questions
        ('I like to do experiments', 'boolean', 'Consider your interest in scientific inquiry', 8),
        ('I like to figure out how things work', 'boolean', 'Think about your curiosity and problem-solving', 9),
        ('I am good with numbers and charts', 'boolean', 'Consider your mathematical and analytical abilities', 10),
        ('I enjoy science', 'boolean', 'Think about your interest in scientific subjects', 11),
        ('I like to do puzzles', 'boolean', 'Consider your interest in mental challenges', 12),
        ('I like to analyze things (problems/solutions)', 'boolean', 'Think about your analytical thinking', 13),
        ('I like to evaluate a crime scene', 'boolean', 'Consider your interest in investigation and analysis', 14),
        
        -- Artistic (A) questions
        ('I like acting in a play', 'boolean', 'Think about your interest in performing arts', 15),
        ('I like to sing or play an instrument', 'boolean', 'Consider your interest in music', 16),
        ('I like to draw', 'boolean', 'Think about your interest in visual arts', 17),
        ('I like to design stage sets', 'boolean', 'Consider your interest in design and creativity', 18),
        ('I like to take photographs', 'boolean', 'Think about your interest in photography', 19),
        ('I enjoy creative writing', 'boolean', 'Consider your interest in writing and storytelling', 20),
        ('I like to read about art and music', 'boolean', 'Think about your interest in arts and culture', 21),
        
        -- Social (S) questions
        ('I like to get into discussions about issues', 'boolean', 'Consider your interest in social issues and debate', 22),
        ('I like trying to help people solve their problems', 'boolean', 'Think about your desire to help others', 23),
        ('I like helping people', 'boolean', 'Consider your interest in service and support', 24),
        ('I like to teach or train people', 'boolean', 'Think about your interest in education and mentoring', 25),
        ('I like to meet new people', 'boolean', 'Consider your social preferences', 26),
        ('I like to volunteer for a charity', 'boolean', 'Think about your interest in community service', 27),
        ('I like to work in teams', 'boolean', 'Consider your preference for collaborative work', 28),
        
        -- Enterprising (E) questions
        ('I like selling things', 'boolean', 'Think about your interest in sales and commerce', 29),
        ('I like to start a club', 'boolean', 'Consider your leadership and organizational interests', 30),
        ('I like to take charge', 'boolean', 'Think about your leadership preferences', 31),
        ('I like to manage money', 'boolean', 'Consider your interest in finance and management', 32),
        ('I like to lead', 'boolean', 'Think about your leadership qualities', 33),
        ('I would like to start my own business', 'boolean', 'Consider your entrepreneurial interests', 34),
        ('I like to give speeches', 'boolean', 'Think about your interest in public speaking', 35),
        
        -- Conventional (C) questions
        ('I follow a recipe', 'boolean', 'Consider your preference for structured activities', 36),
        ('I like to organize things (files, desks/offices)', 'boolean', 'Think about your organizational skills', 37),
        ('I like to create a budget', 'boolean', 'Consider your interest in planning and finance', 38),
        ('I like to follow instructions', 'boolean', 'Think about your preference for clear guidelines', 39),
        ('I like to be a bank teller', 'boolean', 'Consider your interest in financial services', 40),
        ('I would like to work in an office', 'boolean', 'Think about your preference for office environments', 41),
        ('I am good at keeping records of my work', 'boolean', 'Consider your attention to detail and record-keeping', 42)
    ) AS q(question_text, question_type, help_text, sequence_number)
    WHERE s.assessment_template_id = personality_template_id;

    -- Insert media sources for Inspiration Assessment
    INSERT INTO assessment_media_sources (assessment_template_id, media_type, title, url, description, sequence_number) VALUES
    (inspiration_template_id, 'video', 'Inspirational Video 1', 'https://youtu.be/U7-HlfpvQIA?si=_gakjQozpgbZC2aQ', 'First inspirational content for self-reflection', 1),
    (inspiration_template_id, 'video', 'Inspirational Video 2', 'https://www.youtube.com/watch?v=xqb1hfgfcl8', 'Second inspirational content for self-reflection', 2),
    (inspiration_template_id, 'video', 'Inspirational Video 3', 'https://youtu.be/z3PYJ9MfMH4', 'Third inspirational content for self-reflection', 3),
    (inspiration_template_id, 'video', 'Inspirational Video 4', 'https://youtu.be/X9wViEY5tPQ?si=qDOuMSUatButKwZk', 'Fourth inspirational content for self-reflection', 4),
    (inspiration_template_id, 'video', 'Inspirational Video 5', 'https://youtu.be/PP-kmxMY1ts', 'Fifth inspirational content for self-reflection', 5),
    (inspiration_template_id, 'video', 'Inspirational Video 6', 'https://youtu.be/GPeeZ6viNgY?si=sg4hFF33p3cF4X25', 'Sixth inspirational content for self-reflection', 6);

    -- Insert learning method options for School Learning Assessment
    INSERT INTO assessment_question_options (question_id, option_text, option_value, sequence_number)
    SELECT q.id, o.option_text, o.option_value, o.sequence_number
    FROM assessment_questions q
    JOIN assessment_sections s ON q.section_id = s.id
    JOIN assessment_templates t ON s.assessment_template_id = t.id
    CROSS JOIN (VALUES
        ('Looking at pictures', 'lookingAtPictures', 1),
        ('Reading', 'reading', 2),
        ('Listening', 'listening', 3),
        ('Doing experiments', 'experiment', 4),
        ('Discussions', 'discussions', 5),
        ('Practice', 'practice', 6),
        ('Group sessions', 'groupSessions', 7),
        ('Others', 'others', 8)
    ) AS o(option_text, option_value, sequence_number)
    WHERE t.assessment_type = 'school_learning' 
    AND q.question_text = 'How do you like to learn?';

END $$;
