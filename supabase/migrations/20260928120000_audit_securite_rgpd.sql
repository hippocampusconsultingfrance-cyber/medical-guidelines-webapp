-- Correctifs issus de l'audit du 28/09/2026 (docs/audit/AUDIT_2026-09-28.md).
-- Idempotent : peut être rejoué sans effet de bord.
--
--   E4  table error_reports (bouton « Signaler une erreur » des fiches)
--   E5  suppression de compte par l'utilisateur (delete_my_account)
--   M5  droits d'exécution des fonctions SECURITY DEFINER, RLS en (select auth.uid())
--   M6  colonnes de profiles modifiables limitées + journal des consentements

-- ---------------------------------------------------------------------------
-- Rôle administrateur (relecture des signalements). Non modifiable par
-- l'utilisateur : absent des droits UPDATE par colonne ci-dessous.
-- ---------------------------------------------------------------------------
alter table public.profiles
  add column if not exists is_admin boolean not null default false;

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(
    (select is_admin from public.profiles where id = (select auth.uid())),
    false
  );
$$;

revoke execute on function public.is_admin() from public, anon;
grant execute on function public.is_admin() to authenticated;

-- ---------------------------------------------------------------------------
-- M6 — l'utilisateur ne peut plus modifier la preuve de son consentement
-- (consent_service, consent_recorded_at) ni son rôle.
-- ---------------------------------------------------------------------------
revoke all on public.profiles from anon;
revoke insert, update, delete, truncate, references, trigger
  on public.profiles from authenticated;
grant select on public.profiles to authenticated;
grant update (
  nom, prenom, telephone, profession, profession_autre,
  username, consent_partners, setup_completed
) on public.profiles to authenticated;

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
  on public.profiles for select
  to authenticated
  using ((select auth.uid()) = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
  on public.profiles for update
  to authenticated
  using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);

-- Journal horodaté des consentements : chaque changement est conservé,
-- l'utilisateur peut le lire mais pas l'écrire.
create table if not exists public.consent_log (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  consent_type text not null check (consent_type in ('service', 'partners')),
  value boolean not null,
  recorded_at timestamptz not null default now()
);

create index if not exists consent_log_user_id_idx on public.consent_log (user_id);

alter table public.consent_log enable row level security;

revoke all on public.consent_log from anon, authenticated;
grant select on public.consent_log to authenticated;

drop policy if exists "consent_log_select_own" on public.consent_log;
create policy "consent_log_select_own"
  on public.consent_log for select
  to authenticated
  using ((select auth.uid()) = user_id);

create or replace function public.track_consent_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    insert into public.consent_log (user_id, consent_type, value, recorded_at)
    values
      (new.id, 'service', new.consent_service, new.consent_recorded_at),
      (new.id, 'partners', new.consent_partners, new.consent_recorded_at);
  elsif new.consent_partners is distinct from old.consent_partners then
    new.consent_recorded_at := now();
    insert into public.consent_log (user_id, consent_type, value)
    values (new.id, 'partners', new.consent_partners);
  end if;
  return new;
end;
$$;

revoke execute on function public.track_consent_change() from public, anon, authenticated;

drop trigger if exists profiles_consent_insert on public.profiles;
create trigger profiles_consent_insert
  after insert on public.profiles
  for each row execute function public.track_consent_change();

drop trigger if exists profiles_consent_update on public.profiles;
create trigger profiles_consent_update
  before update on public.profiles
  for each row execute function public.track_consent_change();

-- Reprise de l'existant : une entrée initiale par profil déjà créé.
insert into public.consent_log (user_id, consent_type, value, recorded_at)
select p.id, c.consent_type, c.value, p.consent_recorded_at
from public.profiles p
cross join lateral (
  values ('service', p.consent_service), ('partners', p.consent_partners)
) as c (consent_type, value)
where not exists (
  select 1 from public.consent_log l where l.user_id = p.id
);

-- ---------------------------------------------------------------------------
-- M5 — fonctions SECURITY DEFINER non appelables sans connexion.
-- ---------------------------------------------------------------------------
revoke execute on function public.handle_new_user() from public, anon, authenticated;
revoke execute on function public.is_username_available(text) from public, anon;
grant execute on function public.is_username_available(text) to authenticated;

-- ---------------------------------------------------------------------------
-- E5 — suppression du compte par l'utilisateur lui-même. Le profil et le
-- journal des consentements partent en cascade ; les signalements d'erreurs
-- sont conservés sans lien avec la personne.
-- ---------------------------------------------------------------------------
create or replace function public.delete_my_account()
returns void
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  uid uuid := auth.uid();
begin
  if uid is null then
    raise exception 'Non authentifié';
  end if;
  delete from auth.users where id = uid;
end;
$$;

revoke execute on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;

-- ---------------------------------------------------------------------------
-- E4 — signalements d'erreurs sur les fiches.
-- ---------------------------------------------------------------------------
create table if not exists public.error_reports (
  id uuid primary key default gen_random_uuid(),
  user_id uuid default auth.uid() references auth.users (id) on delete set null,
  doc text not null check (char_length(doc) between 1 and 200),
  doc_title text check (char_length(doc_title) <= 500),
  section text check (char_length(section) <= 500),
  description text not null check (char_length(description) between 1 and 5000),
  status text not null default 'nouveau'
    check (status in ('nouveau', 'valide', 'rejete')),
  created_at timestamptz not null default now(),
  decided_at timestamptz,
  decided_by uuid references auth.users (id) on delete set null
);

create index if not exists error_reports_created_at_idx
  on public.error_reports (created_at desc);
create index if not exists error_reports_user_id_idx
  on public.error_reports (user_id);
create index if not exists error_reports_decided_by_idx
  on public.error_reports (decided_by);

alter table public.error_reports enable row level security;

revoke all on public.error_reports from anon, authenticated;
grant select, insert on public.error_reports to authenticated;
grant update (status, decided_at, decided_by) on public.error_reports to authenticated;

-- Chacun voit ses propres signalements ; les administrateurs voient tout.
drop policy if exists "error_reports_select" on public.error_reports;
create policy "error_reports_select"
  on public.error_reports for select
  to authenticated
  using (user_id = (select auth.uid()) or (select public.is_admin()));

drop policy if exists "error_reports_insert_own" on public.error_reports;
create policy "error_reports_insert_own"
  on public.error_reports for insert
  to authenticated
  with check (user_id = (select auth.uid()) and status = 'nouveau');

drop policy if exists "error_reports_update_admin" on public.error_reports;
create policy "error_reports_update_admin"
  on public.error_reports for update
  to authenticated
  using ((select public.is_admin()))
  with check ((select public.is_admin()));
