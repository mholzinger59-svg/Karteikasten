-- Karteikasten: Einrichtung für den Abgleich zwischen Geräten.
-- In Supabase unter "SQL Editor" einfügen und einmal ausführen ("Run").
-- Kann gefahrlos mehrfach ausgeführt werden.

-- Fächer
create table if not exists public.decks (
  id          text primary key,
  user_id     uuid not null default auth.uid() references auth.users (id) on delete cascade,
  name        text not null default '',
  color       text not null default '',
  created_at  text not null default '',
  updated_at  bigint not null default 0,      -- Zeitpunkt der Änderung auf dem Gerät (ms)
  deleted     boolean not null default false,
  synced_at   timestamptz not null default now()  -- vom Server gesetzt, für den Abruf neuer Änderungen
);

-- Karten (eine Zeile pro Karte; Inhalt, Bilder-Verweise und Lernstand in "data")
create table if not exists public.cards (
  id          text primary key,
  user_id     uuid not null default auth.uid() references auth.users (id) on delete cascade,
  deck_id     text,
  data        jsonb not null default '{}'::jsonb,
  updated_at  bigint not null default 0,
  deleted     boolean not null default false,
  synced_at   timestamptz not null default now()
);

-- Lernstatistik je Gerät
create table if not exists public.stats (
  user_id     uuid not null default auth.uid() references auth.users (id) on delete cascade,
  device_id   text not null,
  days        jsonb not null default '{}'::jsonb,
  updated_at  bigint not null default 0,
  synced_at   timestamptz not null default now(),
  primary key (user_id, device_id)
);

create or replace function public.karteikasten_touch() returns trigger
language plpgsql as $$
begin
  new.synced_at := clock_timestamp();
  return new;
end $$;

drop trigger if exists decks_touch on public.decks;
create trigger decks_touch before insert or update on public.decks for each row execute function public.karteikasten_touch();
drop trigger if exists cards_touch on public.cards;
create trigger cards_touch before insert or update on public.cards for each row execute function public.karteikasten_touch();
drop trigger if exists stats_touch on public.stats;
create trigger stats_touch before insert or update on public.stats for each row execute function public.karteikasten_touch();

create index if not exists decks_user_synced on public.decks (user_id, synced_at);
create index if not exists cards_user_synced on public.cards (user_id, synced_at);
create index if not exists stats_user_synced on public.stats (user_id, synced_at);

-- Zugriff: jede Person sieht und ändert nur ihre eigenen Daten
alter table public.decks enable row level security;
alter table public.cards enable row level security;
alter table public.stats enable row level security;

drop policy if exists "eigene Faecher" on public.decks;
create policy "eigene Faecher" on public.decks for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());
drop policy if exists "eigene Karten" on public.cards;
create policy "eigene Karten" on public.cards for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());
drop policy if exists "eigene Statistik" on public.stats;
create policy "eigene Statistik" on public.stats for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- Privater Bildspeicher: Ordner pro Person (<user-id>/<bild-id>)
insert into storage.buckets (id, name, public, file_size_limit)
values ('images', 'images', false, 26214400)
on conflict (id) do nothing;

drop policy if exists "eigene Bilder lesen" on storage.objects;
create policy "eigene Bilder lesen" on storage.objects for select to authenticated
  using (bucket_id = 'images' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "eigene Bilder hochladen" on storage.objects;
create policy "eigene Bilder hochladen" on storage.objects for insert to authenticated
  with check (bucket_id = 'images' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "eigene Bilder ersetzen" on storage.objects;
create policy "eigene Bilder ersetzen" on storage.objects for update to authenticated
  using (bucket_id = 'images' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "eigene Bilder loeschen" on storage.objects;
create policy "eigene Bilder loeschen" on storage.objects for delete to authenticated
  using (bucket_id = 'images' and (storage.foldername(name))[1] = auth.uid()::text);
