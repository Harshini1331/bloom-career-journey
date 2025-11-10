-- Migration: Add Simplified Kannada Translations for About Me Assessment
-- Simplified for rural grade 8 students - using simple, everyday Kannada words
-- Short sentences, clear meaning, avoiding technical or literary words

-- ============================================================================
-- ABOUT ME ASSESSMENT - Simplified Kannada Questions and Help Text
-- ============================================================================
-- Note: field_key values are used as resource_key in content_translations

-- Section A: My Personal Space
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
-- Question: family_comfort_discuss
('about_me_question', 'family_comfort_discuss', 'kn', 'ನಿಮ್ಮ ಕುಟುಂಬದಲ್ಲಿ, ನಿಮ್ಮ ಯೋಚನೆಗಳು ಮತ್ತು ಭಾವನೆಗಳ ಬಗ್ಗೆ ನೀವು ಯಾರೊಂದಿಗೆ ಮುಕ್ತವಾಗಿ ಮಾತನಾಡಬಹುದು, ಮತ್ತು ಏಕೆ ನೀವು ಈ ವ್ಯಕ್ತಿಯೊಂದಿಗೆ ಇಷ್ಟು ಮುಕ್ತವಾಗಿರಬಹುದು?', NOW()),
('about_me_help', 'family_comfort_discuss', 'kn', 'ನಿಮ್ಮ ಕುಟುಂಬದಲ್ಲಿ ನೀವು ಹೆಚ್ಚು ನಂಬಿಕೆ ಇಡುವ ಮತ್ತು ನಿಮ್ಮ ಆಳವಾದ ಯೋಚನೆಗಳನ್ನು ಹಂಚಿಕೊಳ್ಳಬಹುದಾದ ವ್ಯಕ್ತಿಯ ಬಗ್ಗೆ ಯೋಚಿಸಿ. ಈ ಸಂಬಂಧವು ಏಕೆ ವಿಶೇಷವಾಗಿದೆ ಮತ್ತು ನೀವು ಏಕೆ ಅವರೊಂದಿಗೆ ಮುಕ್ತವಾಗಿರುತ್ತೀರಿ ಎಂಬುದನ್ನು ವಿವರಿಸಿ.', NOW()),

-- Question: outside_family_individuals
('about_me_question', 'outside_family_individuals', 'kn', 'ನಿಮ್ಮ ಕುಟುಂಬದ ಹೊರಗೆ, ನಿಮ್ಮ ಅಭಿಪ್ರಾಯಗಳು, ಯೋಚನೆಗಳು ಮತ್ತು ಭಾವನೆಗಳನ್ನು ನೀವು ಮುಕ್ತವಾಗಿ ಹಂಚಿಕೊಳ್ಳಬಹುದಾದ ವ್ಯಕ್ತಿಗಳು ಯಾರು?', NOW()),
('about_me_help', 'outside_family_individuals', 'kn', 'ಸ್ನೇಹಿತರು, ಶಿಕ್ಷಕರು, ಮಾರ್ಗದರ್ಶಕರು ಅಥವಾ ನಿಮ್ಮ ಜೀವನದಲ್ಲಿ ನಂಬಿಕೆಯ ಇತರ ವ್ಯಕ್ತಿಗಳ ಬಗ್ಗೆ ಯೋಚಿಸಿ. ಈ ವ್ಯಕ್ತಿಗಳು ಯಾರು ಮತ್ತು ನೀವು ಅವರೊಂದಿಗೆ ಹಂಚಿಕೊಳ್ಳಲು ಏಕೆ ಆರಾಮವಾಗಿರುತ್ತೀರಿ ಎಂಬುದನ್ನು ವಿವರಿಸಿ.', NOW()),

-- Question: domestic_chores
('about_me_question', 'domestic_chores', 'kn', 'ನೀವು ನಿಯಮಿತವಾಗಿ ಮಾಡುವ ಮನೆಯ ಕೆಲಸಗಳು ಯಾವುವು?', NOW()),
('about_me_help', 'domestic_chores', 'kn', 'ನೀವು ನಿಯಮಿತವಾಗಿ ಮಾಡುವ ಮನೆಯ ಕೆಲಸಗಳ ಪಟ್ಟಿ ಮಾಡಿ. ಉದಾಹರಣೆಗಳು: ಕಿರಾಣಿ/ತರಕಾರಿ ಖರೀದಿ, ತೋಟಗಾರಿಕೆ, ಸ್ವಚ್ಛತೆ, ಸಾಕುಪ್ರಾಣಿ ಆರೈಕೆ, ಬಿಲ್ ಪಾವತಿ, ಅಡುಗೆ, ಪಾತ್ರೆ ತೊಳೆಯುವುದು, ಇತ್ಯಾದಿ.', NOW()),

-- Section B: Activities You Enjoy
-- Question: enjoyable_school_hours
('about_me_question', 'enjoyable_school_hours', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ನೀವು ಹೆಚ್ಚು ಆನಂದಿಸುವ ಮತ್ತು ತೃಪ್ತಿ ಪಡುವ ಚಟುವಟಿಕೆಗಳು ಯಾವುವು?', NOW()),
('about_me_help', 'enjoyable_school_hours', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ನಿಮಗೆ ಸಂತೋಷ ಮತ್ತು ತೃಪ್ತಿ ನೀಡುವ ವಿಷಯಗಳು, ಚಟುವಟಿಕೆಗಳು ಅಥವಾ ಕಾರ್ಯಗಳ ಬಗ್ಗೆ ಬರೆಯಿರಿ. ಈ ಚಟುವಟಿಕೆಗಳು ನಿಮಗೆ ಏಕೆ ಅರ್ಥಪೂರ್ಣವಾಗಿವೆ?', NOW()),

-- Question: enjoyable_pre_post_school
('about_me_question', 'enjoyable_pre_post_school', 'kn', 'ಶಾಲೆಗೆ ಮೊದಲು ಮತ್ತು ನಂತರ ನೀವು ಹೆಚ್ಚು ಆನಂದಿಸುವ ಮತ್ತು ತೃಪ್ತಿ ಪಡುವ ಚಟುವಟಿಕೆಗಳು ಯಾವುವು?', NOW()),
('about_me_help', 'enjoyable_pre_post_school', 'kn', 'ಶಾಲೆಗೆ ಮೊದಲು ಅಥವಾ ನಂತರ ನೀವು ಮಾಡುವ ಮತ್ತು ಆನಂದಿಸುವ ಚಟುವಟಿಕೆಗಳನ್ನು ವಿವರಿಸಿ. ಇದು ಹವ್ಯಾಸಗಳು, ಕ್ರೀಡೆಗಳು, ಸೃಜನಶೀಲ ಚಟುವಟಿಕೆಗಳು ಅಥವಾ ಇತರ ಆಸಕ್ತಿಗಳನ್ನು ಒಳಗೊಂಡಿರಬಹುದು.', NOW()),

-- Question: independent_activities
('about_me_question', 'independent_activities', 'kn', 'ನೀವು ಸ್ವತಂತ್ರವಾಗಿ ಅಥವಾ ನಿಮ್ಮದೇ ಆದ ಮೇಲೆ ಮಾಡಲು ಇಷ್ಟಪಡುವ ಚಟುವಟಿಕೆಗಳು ಯಾವುವು?', NOW()),
('about_me_help', 'independent_activities', 'kn', 'ನೀವು ಒಂಟಿಯಾಗಿ ಮಾಡಲು ಇಷ್ಟಪಡುವ ವಿಷಯಗಳ ಬಗ್ಗೆ ಯೋಚಿಸಿ. ಇವು ಓದುವುದು, ಬರೆಯುವುದು, ವ್ಯಾಯಾಮ ಮಾಡುವುದು, ಅಥವಾ ನಿಮಗೆ ಶಾಂತಿ ಮತ್ತು ಸಂತೋಷ ನೀಡುವ ಯಾವುದೇ ಒಂಟಿ ಚಟುವಟಿಕೆಗಳಾಗಿರಬಹುದು.', NOW()),

-- Question: proactive_activities
('about_me_question', 'proactive_activities', 'kn', 'ನೀವು ಸಕ್ರಿಯವಾಗಿ ಮಾಡುವ ಚಟುವಟಿಕೆಗಳು ಯಾವುವು, ನಿಮಗೆ ಹೇಳದೆ ಅಥವಾ ನಿರ್ದೇಶಿಸದೆ, ಮತ್ತು ನೀವು ಅದರಲ್ಲಿ ಸಕ್ರಿಯವಾಗಿರುತ್ತೀರಿ ಎಂದು ನೀವು ಏಕೆ ಭಾವಿಸುತ್ತೀರಿ?', NOW()),
('about_me_help', 'proactive_activities', 'kn', 'ನಿಮಗೆ ಹೇಳದೆ ನೀವು ಪ್ರಾರಂಭಿಸುವ ಕಾರ್ಯಗಳು ಅಥವಾ ಚಟುವಟಿಕೆಗಳನ್ನು ವಿವರಿಸಿ. ಈ ಪ್ರದೇಶಗಳಲ್ಲಿ ನೀವು ಸಕ್ರಿಯವಾಗಿರಲು ಏನು ಪ್ರೇರೇಪಿಸುತ್ತದೆ ಮತ್ತು ನೀವು ಅವುಗಳನ್ನು ಮಾಡಲು ಏಕೆ ಪ್ರೇರೇಪಿತರಾಗುತ್ತೀರಿ ಎಂಬುದನ್ನು ವಿವರಿಸಿ.', NOW()),

-- Section C: Tasks or activities you find challenging
-- Question: challenging_school_tasks
('about_me_question', 'challenging_school_tasks', 'kn', 'ನಿಮಗೆ ಸವಾಲು ಅಥವಾ ಕಷ್ಟಕರವಾಗಿರುವ ಶಾಲೆಯ ಕಾರ್ಯಗಳು ಅಥವಾ ಚಟುವಟಿಕೆಗಳನ್ನು ಗುರುತಿಸಿ', NOW()),
('about_me_help', 'challenging_school_tasks', 'kn', 'ನಿಮಗೆ ವಿಶೇಷವಾಗಿ ಕಷ್ಟಕರವಾಗಿರುವ ಶಾಲೆಯ ವಿಷಯಗಳು, ಕಾರ್ಯಗಳು ಅಥವಾ ಚಟುವಟಿಕೆಗಳ ಬಗ್ಗೆ ಯೋಚಿಸಿ. ಅವು ಏಕೆ ಸವಾಲು ಎಂಬುದನ್ನು ವಿವರಿಸಿ.', NOW()),

-- Question: challenging_outside_school
('about_me_question', 'challenging_outside_school', 'kn', 'ಶಾಲೆಯ ಹೊರಗೆ ನಿಮಗೆ ಸವಾಲು ಅಥವಾ ಕಷ್ಟಕರವಾಗಿರುವ ಕಾರ್ಯಗಳು ಅಥವಾ ಚಟುವಟಿಕೆಗಳನ್ನು ಗುರುತಿಸಿ', NOW()),
('about_me_help', 'challenging_outside_school', 'kn', 'ಶಾಲೆಯ ಹೊರಗೆ ನಿಮ್ಮ ದೈನಂದಿನ ಜೀವನದಲ್ಲಿ ನಿಮಗೆ ಕಷ್ಟಕರವಾಗಿರುವ ಜವಾಬ್ದಾರಿಗಳು, ಮನೆಯ ಕೆಲಸಗಳು ಅಥವಾ ಚಟುವಟಿಕೆಗಳನ್ನು ಪರಿಗಣಿಸಿ.', NOW()),

-- Question: dislike_compelled_tasks
('about_me_question', 'dislike_compelled_tasks', 'kn', 'ನೀವು ಇಷ್ಟಪಡದ ಆದರೆ ಮಾಡಲು ಬಲವಂತಿಸಲ್ಪಟ್ಟ ಅಥವಾ ಒತ್ತಾಯಿಸಲ್ಪಟ್ಟ ಕಾರ್ಯಗಳ ಪಟ್ಟಿ ಮಾಡಿ', NOW()),
('about_me_help', 'dislike_compelled_tasks', 'kn', 'ನೀವು ಆನಂದಿಸದ ಆದರೆ ಹೇಗಾದರೂ ಪೂರ್ಣಗೊಳಿಸಬೇಕಾದ ಕಾರ್ಯಗಳು ಅಥವಾ ಜವಾಬ್ದಾರಿಗಳ ಬಗ್ಗೆ ಯೋಚಿಸಿ. ಇವು ನೀವು ತಪ್ಪಿಸಿಕೊಳ್ಳಲಾಗದ ಮನೆಯ ಕೆಲಸಗಳು, ಕರ್ತವ್ಯಗಳು ಅಥವಾ ಬಾಧ್ಯತೆಗಳಾಗಿರಬಹುದು.', NOW()),

-- Question: natural_work_activities
('about_me_question', 'natural_work_activities', 'kn', 'ನಿಮ್ಮ ಕೆಲಸ/ಚಟುವಟಿಕೆಗಳ ಸಮಯದಲ್ಲಿ ನೀವು ಸ್ವಾಭಾವಿಕವಾಗಿ ಮಾಡುವ ಕೆಲಸ/ಚಟುವಟಿಕೆಗಳ ಪಟ್ಟಿ ಮಾಡಿ', NOW()),
('about_me_help', 'natural_work_activities', 'kn', 'ನಿಮಗೆ ಸ್ವಾಭಾವಿಕವಾಗಿ ಬರುವ ಮತ್ತು ನೀವು ಸುಲಭವಾಗಿ ಮಾಡುವ ಕಾರ್ಯಗಳು ಅಥವಾ ಚಟುವಟಿಕೆಗಳನ್ನು ವಿವರಿಸಿ. ಈ ಚಟುವಟಿಕೆಗಳು ಸ್ವಾಭಾವಿಕವಾಗಿ ಏಕೆ ಅನಿಸುತ್ತವೆ?', NOW()),

-- Question: not_natural_tasks
('about_me_question', 'not_natural_tasks', 'kn', 'ನಿಮಗೆ ಸ್ವಾಭಾವಿಕವಾಗಿ ಅಥವಾ ವಿಶಿಷ್ಟವಾಗಿ ಇಲ್ಲದ ಕಾರ್ಯಗಳನ್ನು ಗುರುತಿಸಿ', NOW()),
('about_me_help', 'not_natural_tasks', 'kn', 'ನಿಮಗೆ ಸ್ವಾಭಾವಿಕವಾಗಿ ಬರದ, ಹೆಚ್ಚಿನ ಪ್ರಯತ್ನದ ಅಗತ್ಯವಿರುವ, ಅಥವಾ ನಿಮ್ಮ ಆರಾಮದ ವಲಯದ ಹೊರಗೆ ಅನಿಸುವ ಚಟುವಟಿಕೆಗಳ ಬಗ್ಗೆ ಯೋಚಿಸಿ. ಈ ಕಾರ್ಯಗಳು ನಿಮಗೆ ಏಕೆ ಕಷ್ಟಕರವಾಗಿವೆ?', NOW()),

-- Section D: Let's delve deeper into understanding more about you
-- Question: qualities_love_about_self
('about_me_question', 'qualities_love_about_self', 'kn', 'ನಿಮ್ಮಲ್ಲಿ ನೀವು ಪ್ರೀತಿಸುವ ಮತ್ತು ಮೆಚ್ಚುವ ಗುಣಗಳು ಅಥವಾ ಅಂಶಗಳು ಯಾವುವು?', NOW()),
('about_me_help', 'qualities_love_about_self', 'kn', 'ನಿಮ್ಮ ಶಕ್ತಿಗಳು, ಧನಾತ್ಮಕ ಗುಣಗಳು ಮತ್ತು ನಿಮ್ಮನ್ನು ಹೆಮ್ಮೆಪಡಿಸುವ ನಿಮ್ಮ ಅಂಶಗಳ ಬಗ್ಗೆ ಯೋಚಿಸಿ. ನಿಮ್ಮಲ್ಲಿ ನೀವು ಹೆಚ್ಚು ಮೌಲ್ಯವನ್ನಿಟ್ಟು ಕಾಪಾಡುವುದನ್ನು ಯೋಚಿಸಿ.', NOW()),

-- Question: qualities_others_appreciate
('about_me_question', 'qualities_others_appreciate', 'kn', 'ನಿಮ್ಮ ಪೋಷಕರು, ಶಿಕ್ಷಕರು, ಸ್ನೇಹಿತರು ಮತ್ತು ನಿಕಟ ಸಂಬಂಧಿಕರು ನಿಮ್ಮಲ್ಲಿ ಮೆಚ್ಚುವ ಗುಣಗಳು ಯಾವುವು ಎಂದು ನೀವು ನಂಬುತ್ತೀರಿ?', NOW()),
('about_me_help', 'qualities_others_appreciate', 'kn', 'ನಿಮ್ಮ ಪೋಷಕರು, ಶಿಕ್ಷಕರು, ಸ್ನೇಹಿತರು ಅಥವಾ ನಿಕಟ ಸಂಬಂಧಿಕರಿಗೆ ನಿಮ್ಮಲ್ಲಿ ಏನು ಮೌಲ್ಯವಾಗಿದೆ ಎಂದು ಕೇಳುವುದನ್ನು ಪರಿಗಣಿಸಿ. ಅವರು ನಿಮ್ಮಲ್ಲಿ ನೋಡುವ ಧನಾತ್ಮಕ ಗುಣಗಳನ್ನು ಬರೆಯಿರಿ.', NOW()),

-- Question: traits_improve_change
('about_me_question', 'traits_improve_change', 'kn', 'ನಿಮ್ಮಲ್ಲಿ ನೀವು ಸುಧಾರಿಸಲು ಅಥವಾ ಬದಲಾಯಿಸಲು ಬಯಸುವ ಗುಣಗಳು ಯಾವುವು?', NOW()),
('about_me_help', 'traits_improve_change', 'kn', 'ನೀವು ಕೆಲಸ ಮಾಡಲು ಅಥವಾ ಮತ್ತಷ್ಟು ಅಭಿವೃದ್ಧಿಪಡಿಸಲು ಬಯಸುವ ನಿಮ್ಮ ಅಂಶಗಳ ಬಗ್ಗೆ ಯೋಚಿಸಿ. ಬೆಳವಣಿಗೆಯ ಸ್ಥಳಗಳ ಬಗ್ಗೆ ನೀವು ನೋಡುವ ಪ್ರದೇಶಗಳಲ್ಲಿ ಪ್ರಾಮಾಣಿಕರಾಗಿರಿ.', NOW()),

-- Question: qualities_others_want_develop
('about_me_question', 'qualities_others_want_develop', 'kn', 'ನಿಮ್ಮಲ್ಲಿ ಇತರರು ಅಭಿವೃದ್ಧಿಪಡಿಸಲು ಬಯಸುವ ಮತ್ತು ನೀವು ಸುಧಾರಿಸಲು ಸೂಚಿಸುವ ಗುಣಗಳು/ಲಕ್ಷಣಗಳು ಯಾವುವು?', NOW()),
('about_me_help', 'qualities_others_want_develop', 'kn', 'ಕುಟುಂಬ, ಶಿಕ್ಷಕರು ಅಥವಾ ಸ್ನೇಹಿತರಿಂದ ನೀವು ಪಡೆದ ಪ್ರತಿಕ್ರಿಯೆಯ ಬಗ್ಗೆ ಯೋಚಿಸಿ, ಅವರು ನಿಮ್ಮಲ್ಲಿ ಅಭಿವೃದ್ಧಿಪಡಿಸಲು ಬಯಸುವ ಗುಣಗಳ ಬಗ್ಗೆ. ಅವರ ಸಲಹೆಗಳನ್ನು ಎಚ್ಚರಿಕೆಯಿಂದ ಪರಿಗಣಿಸಿ.', NOW()),

-- Question: aspire_to_be
('about_me_question', 'aspire_to_be', 'kn', 'ನಿಮ್ಮ ಜೀವನದಲ್ಲಿ ನೀವು ಏನಾದರೂ/ಯಾರಾದರೂ ಆಗಲು ಅವಕಾಶವಿದ್ದರೆ, ನೀವು ಏನು/ಯಾರು ಆಗಲು ಬಯಸುತ್ತೀರಿ?', NOW()),
('about_me_help', 'aspire_to_be', 'kn', 'ನಿಮ್ಮ ಕನಸುಗಳು ಮತ್ತು ಆಕಾಂಕ್ಷೆಗಳ ಬಗ್ಗೆ ಯೋಚಿಸಿ. ನೀವು ಯಾರನ್ನು ಮೆಚ್ಚುತ್ತೀರಿ ಅಥವಾ ನೀವು ಯಾವ ರೀತಿಯ ವ್ಯಕ್ತಿಯಾಗಲು ಬಯಸುತ್ತೀರಿ? ವೈಯಕ್ತಿಕ ಗುಣಗಳು ಮತ್ತು ವೃತ್ತಿ ಆಕಾಂಕ್ಷೆಗಳನ್ನು ಪರಿಗಣಿಸಿ.', NOW()),

-- Question: proud_moment
('about_me_question', 'proud_moment', 'kn', 'ನೀವು ನಿಮ್ಮ ಬಗ್ಗೆ ಹೆಮ್ಮೆಪಡಿಸಿದ ಸಮಯದ ಬಗ್ಗೆ ಯೋಚಿಸಿ. ನೀವು ಏನು ಸಾಧಿಸಿದ್ದೀರಿ ಮತ್ತು ಅದು ನಿಮಗೆ ಏಕೆ ಅರ್ಥಪೂರ್ಣವಾಗಿತ್ತು?', NOW()),
('about_me_help', 'proud_moment', 'kn', 'ನಿಮಗೆ ಹೆಮ್ಮೆಪಡಿಸಿದ ನಿರ್ದಿಷ್ಟ ಕ್ಷಣ ಅಥವಾ ಸಾಧನೆಯ ಬಗ್ಗೆ ಯೋಚಿಸಿ. ನೀವು ಏನು ಸಾಧಿಸಿದ್ದೀರಿ, ಅದು ನಿಮಗೆ ಹೇಗೆ ಅನಿಸಿತು ಮತ್ತು ಅದು ನಿಮಗೆ ಏಕೆ ಮುಖ್ಯವಾಗಿತ್ತು ಎಂಬುದನ್ನು ವಿವರಿಸಿ.', NOW()),

-- Question: challenge_overcome
('about_me_question', 'challenge_overcome', 'kn', 'ನೀವು ಇತ್ತೀಚೆಗೆ ಎದುರಿಸಿದ ಸವಾಲು ಅಥವಾ ಅಡಚಣೆಯ ಬಗ್ಗೆ ಯೋಚಿಸಿ. ನೀವು ಅದನ್ನು ಹೇಗೆ ಜಯಿಸಿದ್ದೀರಿ ಮತ್ತು ಅನುಭವದಿಂದ ನೀವು ಏನು ಕಲಿತಿದ್ದೀರಿ?', NOW()),
('about_me_help', 'challenge_overcome', 'kn', 'ನೀವು ಎದುರಿಸಿದ ಇತ್ತೀಚಿನ ಸವಾಲನ್ನು ವಿವರಿಸಿ, ಅದನ್ನು ಜಯಿಸಲು ನೀವು ತೆಗೆದುಕೊಂಡ ಹಂತಗಳು ಮತ್ತು ನೀವು ಕಲಿತ ಪಾಠಗಳು. ಈ ಅನುಭವವು ನಿಮ್ಮ ಬೆಳವಣಿಗೆಗೆ ಹೇಗೆ ಸಹಾಯ ಮಾಡಿತು ಎಂಬುದನ್ನು ಯೋಚಿಸಿ.', NOW()),

-- Question: misunderstood_moment
('about_me_question', 'misunderstood_moment', 'kn', 'ಇತರರು ನಿಮ್ಮನ್ನು ತಪ್ಪಾಗಿ ಅರ್ಥಮಾಡಿಕೊಂಡ ಸಮಯದ ಬಗ್ಗೆ ಯೋಚಿಸಿ. ನೀವು ಪರಿಸ್ಥಿತಿಯನ್ನು ಹೇಗೆ ನಿಭಾಯಿಸಿದ್ದೀರಿ ಮತ್ತು ಅದರಿಂದ ನೀವು ಏನು ಕಲಿತಿದ್ದೀರಿ?', NOW()),
('about_me_help', 'misunderstood_moment', 'kn', 'ಇತರರು ನಿಮ್ಮನ್ನು ಅರ್ಥಮಾಡಿಕೊಳ್ಳಲಿಲ್ಲ ಎಂದು ನೀವು ಭಾವಿಸಿದ ಪರಿಸ್ಥಿತಿಯ ಬಗ್ಗೆ ಯೋಚಿಸಿ. ನೀವು ಅದನ್ನು ಹೇಗೆ ನಿಭಾಯಿಸಿದ್ದೀರಿ, ನೀವು ಏನು ಮಾಡಿದ್ದೀರಿ ಮತ್ತು ಸಂವಹನ ಮತ್ತು ತಿಳುವಳಿಕೆಯ ಬಗ್ಗೆ ನೀವು ಪಡೆದ ಒಳನೋಟಗಳನ್ನು ವಿವರಿಸಿ.', NOW())
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- ============================================================================
-- VERIFICATION
-- ============================================================================
DO $$
DECLARE
    about_me_question_count INTEGER;
    about_me_help_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO about_me_question_count
    FROM content_translations
    WHERE resource_type = 'about_me_question' AND lang = 'kn';
    
    SELECT COUNT(*) INTO about_me_help_count
    FROM content_translations
    WHERE resource_type = 'about_me_help' AND lang = 'kn';
    
    RAISE NOTICE '✅ About Me Kannada translations added: % questions, % help texts', 
        about_me_question_count, about_me_help_count;
END $$;
