-- Spécialités encore peu couvertes par le catalogue (moins de
-- seuil_specialite_couverte() fiches publiées) : un membre de ces
-- spécialités voit tout le catalogue et choisit ses 5 fiches gratuites
-- parmi toutes les fiches publiées. L'abonnement PREMIUM (toutes les fiches
-- de la spécialité) ne lui est pas proposé tant que sa spécialité n'est pas
-- couverte (contrôle côté site : abonnement, relances).
--
-- has_specialty_access() porte la règle : catalogue, recherche, fiches les
-- plus lues, déblocage et droit de lecture en dépendent déjà. Le droit de
-- lecture exige toujours un déblocage ou un abonnement (can_read_document).
-- Idempotent.

create or replace function public.seuil_specialite_couverte()
returns integer
language sql
immutable
set search_path = public
as $fn$
  select 20
$fn$;

-- Spécialité couverte : au moins seuil_specialite_couverte() fiches
-- publiées et non retirées. Security definer : appelée depuis la règle de
-- lecture des fiches, elle compte sans repasser par cette règle.
create or replace function public.specialite_couverte(spec uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $fn$
  select spec is not null and (
    select count(distinct ds.document_id)
      from public.document_specialties ds
      join public.documents d on d.id = ds.document_id
     where ds.specialty_id = spec
       and d.published_at is not null
       and d.freshness_status <> 'retiree'
  ) >= public.seuil_specialite_couverte()
$fn$;

-- Catalogue ouvert au membre connecté : sa spécialité n'est pas couverte.
create or replace function public.catalogue_ouvert()
returns boolean
language sql
stable
security definer
set search_path = public
as $fn$
  select auth.uid() is not null and not public.specialite_couverte(
    (select p.specialty_id from public.profiles p where p.id = auth.uid())
  )
$fn$;

create or replace function public.has_specialty_access(target_specialty_id uuid)
returns boolean
language sql
stable
set search_path = public
as $fn$
  select auth.uid() is not null and (
    exists (
      select 1 from public.profiles p
       where p.id = auth.uid() and p.specialty_id = target_specialty_id
    )
    or public.catalogue_ouvert()
  )
$fn$;

-- Spécialités couvertes (identifiants courts), pour l'inscription.
create or replace function public.specialites_couvertes()
returns setof text
language sql
stable
security definer
set search_path = public
as $fn$
  select s.slug from public.specialties s where public.specialite_couverte(s.id)
$fn$;

-- Appelées par la règle de lecture des fiches, y compris pour les visiteurs
-- (elles renvoient faux sans connexion) : exécution laissée à anon.
grant execute on function public.seuil_specialite_couverte() to anon, authenticated;
grant execute on function public.specialite_couverte(uuid) to anon, authenticated;
grant execute on function public.catalogue_ouvert() to anon, authenticated;
grant execute on function public.specialites_couvertes() to anon, authenticated;
