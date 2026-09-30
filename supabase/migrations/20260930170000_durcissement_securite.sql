-- Durcissement de la sécurité de la base (audit du 30/09/2026). Défense en
-- profondeur : les règles d'accès (RLS) protègent déjà chaque table ; on
-- retire en plus les droits que les rôles de l'API n'utilisent jamais.
--
--   1. TRUNCATE, TRIGGER, REFERENCES : jamais utiles aux rôles de l'API
--      (TRUNCATE échappe même aux règles RLS) ;
--   2. aucune écriture pour le visiteur non connecté (anon) : inscription et
--      paiement passent par des fonctions et des clés serveur ;
--   3. fonctions non utilisées par le site retirées de l'API ;
--   4. signalements d'erreur limités (anti-spam) : 20 par membre et par 24 h.
-- Idempotent.

-- 1 et 2. Droits sur toutes les tables du schéma public.
do $$
declare
  t record;
begin
  for t in select c.relname from pg_class c join pg_namespace n on n.oid = c.relnamespace
           where n.nspname = 'public' and c.relkind in ('r', 'p') loop
    execute format('revoke truncate, trigger, references on public.%I from anon, authenticated', t.relname);
    execute format('revoke insert, update, delete on public.%I from anon', t.relname);
  end loop;
end $$;

-- Tables créées plus tard : mêmes règles par défaut.
alter default privileges in schema public revoke truncate, trigger, references on tables from anon, authenticated;
alter default privileges in schema public revoke insert, update, delete on tables from anon;

-- 3. Fonctions sans usage par le site : plus appelables par l'API.
do $$
begin
  if to_regprocedure('public.get_editorial_role(uuid)') is not null then
    revoke execute on function public.get_editorial_role(uuid) from public, anon, authenticated;
  end if;
  if to_regprocedure('public.check_promotion_code(text, text)') is not null then
    revoke execute on function public.check_promotion_code(text, text) from public, anon, authenticated;
  end if;
end $$;

-- 4. Anti-spam des signalements d'erreur (l'équipe éditoriale n'est pas
--    limitée).
create or replace function public.limiter_signalements()
returns trigger language plpgsql security definer set search_path = public
as $$
begin
  if public.has_editorial_role('relecteur') then
    return new;
  end if;
  if (select count(*) from public.error_reports
      where user_id = new.user_id and created_at > now() - interval '24 hours') >= 20 then
    raise exception 'Trop de signalements en 24 heures' using errcode = '54000';
  end if;
  return new;
end;
$$;
revoke execute on function public.limiter_signalements() from public, anon, authenticated;

drop trigger if exists limiter_signalements on public.error_reports;
create trigger limiter_signalements before insert on public.error_reports
  for each row execute function public.limiter_signalements();
