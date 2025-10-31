-- Lang-aware RPCs that fallback to English when Kannada missing

-- About Me fields as JSONB array with translated question/help text when available
create or replace function public.get_about_me_fields_i18n(p_lang text)
returns jsonb
language sql
stable
as $$
  with base as (
    select * from public.get_about_me_fields()
  )
  select jsonb_agg(
    jsonb_build_object(
      'field_key', b.field_key,
      'question_text', coalesce(public.get_translation('about_me_question', b.field_key, p_lang), b.question_text),
      'help_text', coalesce(public.get_translation('about_me_help', b.field_key, p_lang), b.help_text),
      'field_type', b.field_type,
      'section', b.section,
      'sequence_number', b.sequence_number
    )
  )
  from base b;
$$;

-- Inspiration questions as JSONB array with translated help_text by ordinality
create or replace function public.get_inspiration_questions_i18n(p_lang text)
returns jsonb
language sql
stable
as $$
  with base as (
    select q.*, row_number() over() as rn
    from public.get_inspiration_questions() as q
  )
  select jsonb_agg(
    jsonb_set(
      jsonb_set(
        to_jsonb(base) - 'rn',
        '{help_text}',
        to_jsonb(coalesce(public.get_translation('inspiration_help', 'question' || base.rn, p_lang), base.help_text))
      ),
      '{question_text}',
      to_jsonb(coalesce(public.get_translation('inspiration_question', 'question' || base.rn, p_lang), base.question_text))
    )
  )
  from base;
$$;


