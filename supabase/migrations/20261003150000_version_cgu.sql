-- Version des CGU acceptée à l'inscription (audit du 03/10/2026) : les CGV
-- l'étaient déjà à chaque souscription, pas les CGU. Le formulaire
-- d'inscription transmet la version (src/lib/legal.ts, CGU_VERSION) dans les
-- métadonnées du compte ; elle est recopiée dans le profil à sa création,
-- sans modifier le déclencheur de création de profil existant.
-- Idempotent.

alter table public.profiles add column if not exists cgu_version text;

create or replace function public.profil_version_cgu()
returns trigger
language plpgsql
security definer
set search_path = public, auth
as $$
begin
  if new.cgu_version is null then
    select nullif(left(u.raw_user_meta_data ->> 'cgu_version', 20), '')
      into new.cgu_version
      from auth.users u
     where u.id = new.id;
  end if;
  return new;
end;
$$;

revoke execute on function public.profil_version_cgu() from public, anon, authenticated;

create or replace trigger profil_version_cgu
  before insert on public.profiles
  for each row execute function public.profil_version_cgu();

-- Preuve de l'acceptation : un membre ne peut pas modifier sa version.
create or replace function public.proteger_version_cgu()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  if new.cgu_version is distinct from old.cgu_version and not public.is_privileged_context() then
    raise exception 'cgu_version : modification réservée au serveur' using errcode = '42501';
  end if;
  return new;
end;
$$;

create or replace trigger proteger_version_cgu
  before update of cgu_version on public.profiles
  for each row execute function public.proteger_version_cgu();
