-- Journal de Trading : à coller dans Supabase > SQL Editor > New query, puis "Run".
-- Crée la table des données, la protège (chacun ne voit que ses propres données),
-- active la synchro en direct et crée l'espace de stockage privé des captures.

create table if not exists public.records (
  user_id    uuid not null default auth.uid() references auth.users(id) on delete cascade,
  id         text not null,
  kind       text not null check (kind in ('trade','setup','day','settings')),
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

alter table public.records enable row level security;

drop policy if exists "records_select_own" on public.records;
drop policy if exists "records_insert_own" on public.records;
drop policy if exists "records_update_own" on public.records;
drop policy if exists "records_delete_own" on public.records;
create policy "records_select_own" on public.records for select to authenticated using ((select auth.uid()) = user_id);
create policy "records_insert_own" on public.records for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "records_update_own" on public.records for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "records_delete_own" on public.records for delete to authenticated using ((select auth.uid()) = user_id);

-- Synchro en direct entre le Mac et l'iPhone
do $$ begin
  alter publication supabase_realtime add table public.records;
exception when duplicate_object then null; end $$;

-- Stockage privé des captures d'écran
insert into storage.buckets (id, name, public) values ('captures', 'captures', false)
on conflict (id) do nothing;

drop policy if exists "captures_select_own" on storage.objects;
drop policy if exists "captures_insert_own" on storage.objects;
drop policy if exists "captures_delete_own" on storage.objects;
create policy "captures_select_own" on storage.objects for select to authenticated
  using (bucket_id = 'captures' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "captures_insert_own" on storage.objects for insert to authenticated
  with check (bucket_id = 'captures' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "captures_delete_own" on storage.objects for delete to authenticated
  using (bucket_id = 'captures' and (storage.foldername(name))[1] = (select auth.uid())::text);
