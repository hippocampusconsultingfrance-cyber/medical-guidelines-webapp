-- Base vide de test pour la sauvegarde hebdomadaire (.github/workflows/sauvegarde.yml) :
-- rôles et extensions fournis par Supabase, absents d'un PostgreSQL nu.
-- Les schémas public et auth viennent de la sauvegarde elle-même.
do $$
begin
  if not exists (select 1 from pg_roles where rolname = 'anon') then create role anon nologin; end if;
  if not exists (select 1 from pg_roles where rolname = 'authenticated') then create role authenticated nologin; end if;
  if not exists (select 1 from pg_roles where rolname = 'service_role') then create role service_role nologin bypassrls; end if;
end $$;
create schema if not exists extensions;
create extension if not exists unaccent with schema extensions;
create extension if not exists pgcrypto with schema extensions;
