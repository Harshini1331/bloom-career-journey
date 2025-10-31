-- Content translations storage
create table if not exists public.content_translations (
  id uuid primary key default gen_random_uuid(),
  resource_type text not null,
  resource_key text not null,
  lang text not null check (lang in ('en','kn')),
  text text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(resource_type, resource_key, lang)
);

create index if not exists idx_content_translations_lookup
  on public.content_translations (resource_type, resource_key, lang);

alter table public.content_translations enable row level security;

-- Service role can do anything; readers can select
do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'content_translations'
      and policyname = 'content_translations_select'
  ) then
    create policy "content_translations_select"
      on public.content_translations for select
      to authenticated, anon
      using (true);
  end if;
end $$;

-- Utility: get_translation with fallback to English
create or replace function public.get_translation(p_resource_type text, p_resource_key text, p_lang text)
returns text language sql stable as $$
  select coalesce(
    (select t.text from public.content_translations t where t.resource_type = p_resource_type and t.resource_key = p_resource_key and t.lang = p_lang limit 1),
    (select t.text from public.content_translations t where t.resource_type = p_resource_type and t.resource_key = p_resource_key and t.lang = 'en' limit 1)
  );
$$;

-- Helper RPC to clear and refresh via external job runner/script
create or replace function public.refresh_translations(p_lang text)
returns integer
language plpgsql
security definer
as $$
declare
  v_count integer;
begin
  delete from public.content_translations where lang = p_lang returning 1 into v_count;
  return coalesce(v_count, 0);
end;
$$;


