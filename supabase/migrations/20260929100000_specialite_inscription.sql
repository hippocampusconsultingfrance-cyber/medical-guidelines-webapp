-- Spécialité choisie à l'inscription (cahier des charges V4.5 : « un compte =
-- une spécialité, celle choisie à l'inscription »).
--
-- Le formulaire d'inscription transmet le slug de la spécialité dans les
-- métadonnées (specialty_slug). Il n'est retenu que s'il correspond à une
-- spécialité existante ; sinon, la spécialité est déduite de la profession,
-- comme auparavant. L'utilisateur ne peut pas la modifier ensuite (aucun
-- droit UPDATE sur profiles.specialty_id). Idempotent.

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (
    id, nom, prenom, telephone, profession, profession_autre,
    consent_service, consent_partners, consent_recorded_at, specialty_id
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
    now(),
    coalesce(
      (select s.id from public.specialties s
        where s.slug = new.raw_user_meta_data ->> 'specialty_slug'),
      public.resolve_specialty_id(coalesce(new.raw_user_meta_data ->> 'profession', ''))
    )
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

-- Déclencheur exécuté par Supabase Auth uniquement.
revoke execute on function public.handle_new_user() from public, anon, authenticated;
