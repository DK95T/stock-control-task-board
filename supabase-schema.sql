-- Uruchom ten skrypt w Supabase: SQL Editor -> New query -> Run
create table if not exists public.tasks (
  id bigint primary key,
  order_date date not null,
  assigned_to text not null,
  assigned_by text not null,
  description text not null,
  deadline date not null,
  status text not null default 'pending' check (status in ('pending', 'completed', 'archived')),
  notes text default '',
  completion_date date,
  updated_at timestamptz not null default now()
);

alter table public.tasks enable row level security;

drop policy if exists "public can read tasks" on public.tasks;
drop policy if exists "public can insert tasks" on public.tasks;
drop policy if exists "public can update tasks" on public.tasks;
drop policy if exists "public can delete tasks" on public.tasks;

create policy "public can read tasks" on public.tasks for select to anon, authenticated using (true);
create policy "public can insert tasks" on public.tasks for insert to anon, authenticated with check (true);
create policy "public can update tasks" on public.tasks for update to anon, authenticated using (true) with check (true);
create policy "public can delete tasks" on public.tasks for delete to anon, authenticated using (true);

insert into public.tasks (id, order_date, assigned_to, assigned_by, description, deadline, status, notes, completion_date)
values
(1, '2026-09-20', 'Magdalena Kowalska', 'Janusz Nowak', 'Sprawdzić stan magazynu części A1-B5', '2026-09-25', 'pending', 'Priorytet: wysoki', null),
(2, '2026-09-18', 'Dział Logistyki', 'Anna Wiśniewska', 'Zamówić nowe opakowania foliowe', '2026-09-22', 'completed', 'Zrealizowano w terminie', '2026-09-20'),
(3, '2026-09-15', 'Piotr Lewandowski', 'Magdalena Kowalska', 'Przeprowadzić inwentaryzację półki C7-D3', '2026-09-24', 'pending', 'Opóźnienie spowodowane brakiem pracownika', null)
on conflict (id) do nothing;