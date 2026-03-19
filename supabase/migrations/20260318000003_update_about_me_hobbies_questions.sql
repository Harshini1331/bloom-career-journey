-- ============================================================
-- Update about_me_fields and hobbies_questions from Google Sheet
-- Source: scripts/sheet_dump_2026-03-18.json
-- ============================================================

BEGIN;

-- ============================================================
-- 1. about_me_fields — DELETE and re-INSERT (19 rows)
-- ============================================================

DELETE FROM about_me_fields;

INSERT INTO about_me_fields (field_key, question_text, help_text, field_type, section, sequence_number, is_active) VALUES
('question1', $$In your family, with whom can you freely share your opinions and feelings without fear or hesitation? And why do you trust them so much?$$, $$Choose the family member you feel safest talking to.$$, 'textarea', $$A. Your Profile$$, 1, true),
('question2', $$Other than your family members, with whom can you freely share your opinions and feelings without fear or hesitation?$$, $$Think about someone outside your family whom you trust and feel comfortable talking to.$$, 'textarea', $$A. Your Profile$$, 2, true),
('question3', $$What are the tasks you do at home?
(e.g., helping in agricultural activities, bringing vegetables and groceries from the shop, money-related work, taking care of animals, filling water, etc.)$$, $$Think about the daily work you help with at home.$$, 'textarea', $$A. Your Profile$$, 3, true),
('question4', $$Activities you find most enjoyable and fulfilling:$$, $$Write the activities you enjoy doing during and after school.$$, 'textarea', $$B. What is your favourite work?$$, 4, true),
('question5', $$What are the activities you like to do alone, independently?
(Tasks you do by yourself)$$, $$Think about activities you enjoy doing by yourself.$$, 'textarea', $$B. What is your favourite work?$$, 5, true),
('question6', $$What activities do you like to do in a group or with your friends?$$, $$Think about activities you enjoy doing with friends.$$, 'textarea', $$B. What is your favourite work?$$, 6, true),
('question7', $$What activities do you find difficult at school? Write them.$$, $$Think about school activities that are hard for you.$$, 'textarea', $$C. The job that you find difficult to carry out$$, 7, true),
('question8', $$Apart from school work or activities, what other tasks do you find difficult?$$, $$Think about tasks outside school that you find difficult.$$, 'textarea', $$C. The job that you find difficult to carry out$$, 8, true),
('question9', $$List the tasks that you don't like doing but have to do.$$, $$Write about the tasks you have to do even if you don't like them.$$, 'textarea', $$C. The job that you find difficult to carry out$$, 9, true),
('question10', $$List the activities that you get involved in naturally/effortlessly.$$, $$Write about the tasks that come easily to you.$$, 'textarea', $$C. The job that you find difficult to carry out$$, 10, true),
('question12', $$List the activities that do not come naturally to you.$$, $$Write about the tasks that are not easy for you.$$, 'textarea', $$C. The job that you find difficult to carry out$$, 12, true),
('question13', $$What qualities or aspects do you love & appreciate about yourself?$$, $$Write about the qualities you like in yourself.$$, 'textarea', $$D. Answer the below questions to share more information about yourself$$, 13, true),
('question14', $$Which of your qualities do you think these people (parents, teachers, friends, etc.) like?$$, $$Write about the qualities that others like in you.$$, 'textarea', $$D. Answer the below questions to share more information about yourself$$, 14, true),
('question15', $$Which habit or behaviour of yours do you want to improve or change?$$, $$Is there any habit or behaviour you want to change or improve?$$, 'textarea', $$D. Answer the below questions to share more information about yourself$$, 15, true),
('question16', $$Which of your qualities or behaviors do others suggest you should correct or change?$$, $$Write about the quality that others tell you to change or improve.$$, 'textarea', $$D. Answer the below questions to share more information about yourself$$, 16, true),
('question17', $$If you had a chance to become something or someone in the future, what/who would you like to become?$$, $$Write about what you want to become in the future.$$, 'textarea', $$D. Answer the below questions to share more information about yourself$$, 17, true),
('question18', $$Reflect on a time when you felt proud of yourself. Which of your actions earned you appreciation? How did you achieve it?$$, $$Write about the work or action for which you received appreciation.$$, 'textarea', $$D. Answer the below questions to share more information about yourself$$, 18, true),
('question19', $$Think about a difficult or challenging situation you faced recently.
How did you face it or overcome it?
What lesson did you learn from it?$$, $$Write about a recent difficult event and how you handled it.$$, 'textarea', $$D. Answer the below questions to share more information about yourself$$, 19, true),
('question20', $$Recall a situation where others misunderstood you. How did you handle that situation and what did you learn from it?$$, $$Was there a time when someone thought wrongly about you? Write about how you corrected it.$$, 'textarea', $$D. Answer the below questions to share more information about yourself$$, 20, true);

-- ============================================================
-- 2. hobbies_questions — DELETE and re-INSERT (14 rows)
-- ============================================================

DELETE FROM hobbies_questions;

INSERT INTO hobbies_questions (id, question_text, help_text, sequence_number, section, is_active) VALUES
(gen_random_uuid(), $$What activities / work do you do in your free time?$$, $$Write about activities like reading, drawing or playing$$, 1, 'section1', true),
(gen_random_uuid(), $$Do you have any hobbies? List them.$$, $$List activities you do for joy (e.g., gardening, singing).$$, 2, 'section1', true),
(gen_random_uuid(), $$Among the hobbies listed above, which is your favorite? Why?$$, $$Choose your favorite and explain why it brings you joy.$$, 3, 'section1', true),
(gen_random_uuid(), $$Have your hobbies changed at any time?$$, $$Mention if your interests have changed over the years$$, 4, 'section1', true),
(gen_random_uuid(), $$What inspired your hobbies?$$, $$Mention who or what inspired you (family, friends, etc.).$$, 5, 'section1', true),
(gen_random_uuid(), $$Do you know anyone who has similar hobbies?$$, $$Name a friend, relative, or teacher with the same hobby.$$, 6, 'section1', true),
(gen_random_uuid(), $$How do you feel when engaging in your favorite hobby?$$, $$Write whether your favorite hobby makes you feel happy, relaxed, or more confident.$$, 7, 'section1', true),
(gen_random_uuid(), $$List the talents you have.$$, $$List skills you are naturally good at (e.g., Math, Singing).$$, 8, 'section2', true),
(gen_random_uuid(), $$Are you trying to improve your talent further? If yes, explain how.$$, $$Mention how you practice or learn to get better.$$, 9, 'section2', true),
(gen_random_uuid(), $$Do you get encouragement and opportunities at school or at home to continue and showcase your talents?$$, $$Mention if you get chances to show what you are good at.$$, 10, 'section3', true),
(gen_random_uuid(), $$Do your parents support your efforts to further improve your talent? If yes, in what way?$$, $$Write how your parents support you in developing your talent.$$, 11, 'section3', true),
(gen_random_uuid(), $$Does any of your hobby match with your natural talents?$$, $$e.g., You love cricket (Hobby) and are a fast runner (Talent).$$, 12, 'section3', true),
(gen_random_uuid(), $$Can any of your hobbies be pursued as a career? If yes, how?$$, $$If yes, what steps or plans do you have to achieve this?$$, 13, 'section3', true),
(gen_random_uuid(), $$Do you know anyone who turned a hobby into a career?$$, $$Briefly mention someone who turned their passion into a profession.$$, 14, 'section3', true);

COMMIT;