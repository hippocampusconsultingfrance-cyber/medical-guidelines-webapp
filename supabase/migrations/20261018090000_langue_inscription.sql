-- Langue du membre (interface multilingue, src/lib/langues.ts) : la langue de
-- la page d'inscription, transmise dans les métadonnées du compte
-- (« langue »), est recopiée dans profiles.langue_preferee à la création du
-- profil, sans modifier le déclencheur de création existant (même principe
-- que la version des CGU). Le membre peut ensuite la changer (Mon compte).
-- Idempotent.

create or replace function public.profil_langue_inscription()
returns trigger
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  choisie text;
begin
  select u.raw_user_meta_data ->> 'langue' into choisie from auth.users u where u.id = new.id;
  if choisie in ('fr', 'en', 'es', 'de', 'ar', 'zh') then
    new.langue_preferee := choisie;
  end if;
  return new;
end;
$$;

revoke execute on function public.profil_langue_inscription() from public, anon, authenticated;

create or replace trigger profil_langue_inscription
  before insert on public.profiles
  for each row execute function public.profil_langue_inscription();

alter table public.profiles drop constraint if exists profiles_langue_preferee_check;
alter table public.profiles add constraint profiles_langue_preferee_check
  check (langue_preferee in ('fr', 'en', 'es', 'de', 'ar', 'zh'));

grant update (langue_preferee) on public.profiles to authenticated;
