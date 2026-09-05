-- Medical Guidelines — schema d'authentification et de profils utilisateurs
-- A exécuter une fois dans Supabase : Dashboard -> SQL Editor -> New query -> coller -> Run

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  nom text not null,
  prenom text not null,
  telephone text not null,
  profession text not null,
  profession_autre text,
  username text unique,
  consent_service boolean not null default true,
  consent_partners boolean not null default false,
  consent_recorded_at timestamptz not null default now(),
  setup_completed boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

-- Chaque utilisateur ne peut lire/modifier que sa propre fiche profil.
create policy "profiles_select_own"
  on public.profiles for select
  using (auth.uid() = id);

create policy "profiles_update_own"
  on public.profiles for update
  using (auth.uid() = id);

-- L'insertion se fait uniquement via le trigger ci-dessous (contexte serveur,
-- security definer) : aucune policy insert cote client n'est necessaire.

-- A la creation d'un compte (auth.users), on cree automatiquement la ligne
-- de profil correspondante a partir des metadonnees passees au signup
-- (voir options.data dans supabase.auth.signInWithOtp cote app).
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (
    id, nom, prenom, telephone, profession, profession_autre,
    consent_service, consent_partners, consent_recorded_at
  )
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'nom', ''),
    coalesce(new.raw_user_meta_data ->> 'prenom', ''),
    coalesce(new.raw_user_meta_data ->> 'telephone', ''),
    coalesce(new.raw_user_meta_data ->> 'profession', ''),
    new.raw_user_meta_data ->> 'profession_autre',
    coalesce((new.raw_user_meta_data ->> 'consent_service')::boolean, true),
    coalesce((new.raw_user_meta_data ->> 'consent_partners')::boolean, false),
    now()
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Verifie qu'un nom d'utilisateur est libre avant de le proposer (utilise
-- cote client sur la page de finalisation de compte).
create or replace function public.is_username_available(candidate text)
returns boolean
language sql
security definer
set search_path = public
as $$
  select not exists (
    select 1 from public.profiles where username = candidate
  );
$$;
