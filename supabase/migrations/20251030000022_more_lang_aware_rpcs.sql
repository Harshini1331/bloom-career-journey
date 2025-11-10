-- Additional lang-aware helper RPCs for other assessments

-- Dreams: questions 1..18
create or replace function public.get_dreams_questions_i18n(p_lang text)
returns jsonb
language sql
stable
as $$
  select jsonb_agg(
    jsonb_build_object(
      'key', 'question' || i,
      'text', public.get_translation('dreams_question', 'question' || i::text, p_lang)
    )
  )
  from generate_series(1,18) as g(i);
$$;

-- School & Learning: questions 1..21
create or replace function public.get_school_learning_questions_i18n(p_lang text)
returns jsonb
language sql
stable
as $$
  select jsonb_agg(
    jsonb_build_object(
      'key', 'question' || i,
      'text', public.get_translation('school_question', 'question' || i::text, p_lang)
    )
  )
  from generate_series(1,21) as g(i);
$$;

-- Hobbies: questions 1..14
create or replace function public.get_hobbies_questions_i18n(p_lang text)
returns jsonb
language sql
stable
as $$
  select jsonb_agg(
    jsonb_build_object(
      'key', 'question' || i,
      'text', public.get_translation('hobbies_question', 'question' || i::text, p_lang)
    )
  )
  from generate_series(1,14) as g(i);
$$;

-- Role Models: questions 1..11 (per role model). Use keys rm_q1..rm_q11 (content layer can scope per tab later)
create or replace function public.get_role_models_questions_i18n(p_lang text)
returns jsonb
language sql
stable
as $$
  select jsonb_agg(
    jsonb_build_object(
      'key', 'rm_q' || i,
      'text', public.get_translation('role_models_question', 'rm_q' || i::text, p_lang)
    )
  )
  from generate_series(1,13) as g(i);
$$;


