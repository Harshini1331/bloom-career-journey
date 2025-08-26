create table if not exists public.ilp_queries (
  id uuid primary key default gen_random_uuid(),
  teacher_user_id uuid references public.users(id) on delete set null,
  subject text not null,
  message text not null,
  status text not null default 'open',
  created_at timestamp with time zone default now()
);

alter table public.ilp_queries enable row level security;

-- Teachers can insert and read their own queries
create policy if not exists "teachers can insert ilp queries" on public.ilp_queries
for insert to authenticated with check (exists (select 1 from public.users u where u.id = auth.uid() and u.role in ('teacher','admin')));

create policy if not exists "teachers can view own ilp queries" on public.ilp_queries
for select to authenticated using (teacher_user_id = auth.uid());

-- Admins can view all
create policy if not exists "admins view all ilp queries" on public.ilp_queries
for select using (exists (select 1 from public.users u where u.id = auth.uid() and u.role = 'admin'));

-- Admins can update status
create policy if not exists "admins update ilp queries" on public.ilp_queries
for update using (exists (select 1 from public.users u where u.id = auth.uid() and u.role = 'admin'));


