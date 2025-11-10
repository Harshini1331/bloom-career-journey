-- Migration: Update About Me Assessment Questions
-- This migration replaces the existing About Me questions with new structured questions organized into 4 sections (A, B, C, D)

-- Clear existing About Me fields
DELETE FROM about_me_fields;

-- Insert new About Me fields with updated questions
INSERT INTO about_me_fields (field_key, question_text, help_text, field_type, section, sequence_number) VALUES

-- A. My Personal Space
('family_comfort_discuss', 'Within your family, who do you feel comfortable discussing your thoughts and emotions openly with, and why do you think you can be so candid with this person?', 'Think about which family member you trust most and can share your innermost thoughts with. Explain what makes this relationship special and why you feel comfortable opening up to them.', 'textarea', 'A. My Personal Space', 1),
('outside_family_individuals', 'Outside your family, are there individuals with whom you can freely engage in conversations, share your opinions, thoughts, and feelings?', 'Consider friends, teachers, mentors, or other trusted people in your life. Describe who these individuals are and what makes you comfortable sharing with them.', 'textarea', 'A. My Personal Space', 2),
('domestic_chores', 'What domestic chores do you handle regularly?', 'List the household tasks you regularly perform. Examples: Grocery/Vegetable purchase, Gardening, Cleaning, Pet-care, Paying bills, Cooking, Washing dishes, etc.', 'textarea', 'A. My Personal Space', 3),

-- B. Activities You Enjoy
('enjoyable_school_hours', 'Activities you find most enjoyable and fulfilling - During school hours', 'Write about the subjects, activities, or tasks at school that bring you joy and satisfaction. What makes these activities meaningful to you?', 'textarea', 'B. Activities You Enjoy', 4),
('enjoyable_pre_post_school', 'Activities you find most enjoyable and fulfilling - Pre and post school hours', 'Describe the activities you do before or after school that you find enjoyable and fulfilling. This could include hobbies, sports, creative pursuits, or other interests.', 'textarea', 'B. Activities You Enjoy', 5),
('independent_activities', 'What activities do you enjoy doing independently or on your own?', 'Think about things you prefer to do alone. These could be reading, drawing, writing, exercising, or any solo pursuits that bring you peace and happiness.', 'textarea', 'B. Activities You Enjoy', 6),
('proactive_activities', 'What activities do you proactively engage in, without being instructed or directed and Why do you think you are proactive in it?', 'Describe the tasks or activities you take initiative on without being asked. Explain what motivates you to be proactive in these areas and why you feel driven to do them.', 'textarea', 'B. Activities You Enjoy', 7),

-- C. Tasks or activities you find challenging
('challenging_school_tasks', 'Identify the school tasks or activities that you find challenging or difficult', 'Think about subjects, assignments, or activities at school that are particularly difficult for you. What makes them challenging?', 'textarea', 'C. Tasks or activities you find challenging', 8),
('challenging_outside_school', 'Identify the tasks or activities outside of school that you find challenging or difficult', 'Consider responsibilities, chores, or activities in your daily life outside of school that you struggle with or find difficult to complete.', 'textarea', 'C. Tasks or activities you find challenging', 9),
('dislike_compelled_tasks', 'List the tasks that you dislike but you are compelled or forced to do', 'Think about tasks or responsibilities you don''t enjoy but must complete anyway. These could be chores, obligations, or duties you cannot avoid.', 'textarea', 'C. Tasks or activities you find challenging', 10),
('natural_work_activities', 'List the work/activities that you naturally engage in during your work/activities', 'Describe tasks or activities that come naturally to you and that you perform instinctively or without much effort. What makes these activities feel natural?', 'textarea', 'C. Tasks or activities you find challenging', 11),
('not_natural_tasks', 'Identify the tasks that are not inherently natural or typical for you', 'Think about activities that don''t come naturally to you, require extra effort, or feel out of your comfort zone. What makes these tasks difficult for you?', 'textarea', 'C. Tasks or activities you find challenging', 12),

-- D. Let's delve deeper into understanding more about you
('qualities_love_about_self', 'What qualities or aspects do you love & appreciate about yourself?', 'Reflect on your strengths, positive traits, and aspects of yourself that make you proud. Think about what you value most in yourself.', 'triple', 'D. Let''s delve deeper into understanding more about you', 13),
('qualities_others_appreciate', 'What qualities do you believe others, such as your parents, teachers, friends, and close relatives, appreciate in you?', 'Consider asking your parents, teachers, friends, or close relatives what they value about you. Write down the positive qualities they see in you.', 'triple', 'D. Let''s delve deeper into understanding more about you', 14),
('traits_improve_change', 'What traits of yours would you like to improve or change?', 'Think about aspects of yourself that you would like to work on or develop further. Be honest about areas where you see room for growth.', 'triple', 'D. Let''s delve deeper into understanding more about you', 15),
('qualities_others_want_develop', 'What qualities/characteristics of yours do others want you to develop and also suggest you improve?', 'Reflect on feedback you''ve received from family, teachers, or friends about qualities they''d like to see you develop. Consider their suggestions thoughtfully.', 'triple', 'D. Let''s delve deeper into understanding more about you', 16),
('aspire_to_be', 'If you had the chance to be anything/ anyone in life, what/who would you want to be?', 'Think about your dreams and aspirations. Who do you admire or what kind of person would you like to become? Consider both personal qualities and professional aspirations.', 'textarea', 'D. Let''s delve deeper into understanding more about you', 17),
('proud_moment', 'Reflect on a time when you felt proud of yourself. What did you accomplish, and why was it meaningful to you?', 'Think about a specific moment or achievement that made you feel proud. Describe what you accomplished, how it made you feel, and why it was significant to you.', 'textarea', 'D. Let''s delve deeper into understanding more about you', 18),
('challenge_overcome', 'Think about a challenge or obstacle you''ve faced recently. How did you overcome it and what did you learn from the experience?', 'Describe a recent challenge you encountered, the steps you took to overcome it, and the lessons you learned. Reflect on how this experience helped you grow.', 'textarea', 'D. Let''s delve deeper into understanding more about you', 19),
('misunderstood_moment', 'Reflect on a time when you felt misunderstood by others. How did you handle the situation, and what did you learn from it?', 'Think about a situation where you felt others didn''t understand you. Describe how you handled it, what you did, and what insights you gained about communication and understanding.', 'textarea', 'D. Let''s delve deeper into understanding more about you', 20);

-- Verify data insertion
DO $$
DECLARE
    field_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO field_count FROM about_me_fields;
    
    RAISE NOTICE 'About Me Fields Update Complete:';
    RAISE NOTICE 'Total About Me Fields: %', field_count;
    
    IF field_count = 20 THEN
        RAISE NOTICE '✅ All 20 About Me fields inserted successfully!';
    ELSE
        RAISE NOTICE '⚠️ Expected 20 fields, but found %', field_count;
    END IF;
END $$;

