-- Karteikasten: Update für Kategorien (Ober- und Unterkategorien).
-- In Supabase unter "SQL Editor" einfügen und einmal ausführen ("Run").
-- Kann gefahrlos mehrfach ausgeführt werden.

create table if not exists public.categories (
  id          text primary key,
  user_id     uuid not null default auth.uid() references auth.users (id) on delete cascade,
  name        text not null default '',
  color       text not null default '',
  parent_id   text,                              -- Oberkategorie, leer = oberste Ebene
  created_at  text not null default '',
  updated_at  bigint not null default 0,
  deleted     boolean not null default false,
  synced_at   timestamptz not null default now()
);

-- Fächer merken sich ihre Kategorie
alter table public.decks add column if not exists category_id text;

drop trigger if exists categories_touch on public.categories;
create trigger categories_touch before insert or update on public.categories for each row execute function public.karteikasten_touch();
create index if not exists categories_user_synced on public.categories (user_id, synced_at);

alter table public.categories enable row level security;
drop policy if exists "eigene Kategorien" on public.categories;
create policy "eigene Kategorien" on public.categories for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- PostgREST sofort über die neue Spalte und Tabelle informieren
notify pgrst, 'reload schema';
