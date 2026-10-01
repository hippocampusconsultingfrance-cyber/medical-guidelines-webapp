-- Journal d'administration (audit de sécurité ; cahier des charges §11
-- « journalisation » et §14 « dépublication et audit ») : qui a fait quoi,
-- quand. Table audit_log existante (lecture : administrateurs ; écriture :
-- serveur et déclencheurs ci-dessous, jamais par l'API).
--
--   - fiches : publication, dépublication, statut de fraîcheur, remplacement
--     (seulement les changements faits par un compte connecté : les imports
--     de contenu ne sont pas journalisés) ;
--   - versions de fiche, décisions sur les signalements, relecture des
--     traductions ;
--   - rôle éditorial d'un compte : toujours journalisé, quelle que soit
--     l'origine (élévation de droits = événement de sécurité) ;
--   - les autres décisions (justificatifs, suspensions, corrections, recette,
--     actualisations, divergences, lettre) sont journalisées par le site.
-- Idempotent.

revoke insert, update, delete, truncate on public.audit_log from anon, authenticated;

create or replace function public.journaliser_modification()
returns trigger language plpgsql security definer set search_path = public
as $$
declare
  avant jsonb;
  apres jsonb;
  champs text[] := tg_argv;
begin
  if tg_op = 'UPDATE' then
    select jsonb_object_agg(k, to_jsonb(old) -> k), jsonb_object_agg(k, to_jsonb(new) -> k)
      into avant, apres
      from unnest(champs) k
     where (to_jsonb(old) -> k) is distinct from (to_jsonb(new) -> k);
    if avant is null then
      return new;
    end if;
  elsif tg_op = 'INSERT' then
    select jsonb_object_agg(k, to_jsonb(new) -> k) into apres from unnest(champs) k;
  else
    select jsonb_object_agg(k, to_jsonb(old) -> k) into avant from unnest(champs) k;
  end if;
  -- Contenu importé par le serveur (sans compte connecté) : non journalisé,
  -- sauf pour les rôles éditoriaux.
  if auth.uid() is null and tg_table_name <> 'profiles' then
    return coalesce(new, old);
  end if;
  insert into public.audit_log (actor_id, action, entity_type, entity_id, before, after)
  values (auth.uid(), lower(tg_op), tg_table_name, coalesce(to_jsonb(coalesce(new, old)) ->> 'id', to_jsonb(coalesce(new, old)) ->> 'document_id')::uuid, avant, apres);
  return coalesce(new, old);
end;
$$;
revoke execute on function public.journaliser_modification() from public, anon, authenticated;

drop trigger if exists journal_documents on public.documents;
create trigger journal_documents after update on public.documents
  for each row execute function public.journaliser_modification('published_at', 'freshness_status', 'superseded_by_document_id');

drop trigger if exists journal_document_versions on public.document_versions;
create trigger journal_document_versions after insert or update or delete on public.document_versions
  for each row execute function public.journaliser_modification('document_id', 'version_label', 'change_type', 'published_at');

drop trigger if exists journal_error_reports on public.error_reports;
create trigger journal_error_reports after update on public.error_reports
  for each row execute function public.journaliser_modification('status');

drop trigger if exists journal_profiles_role on public.profiles;
create trigger journal_profiles_role after update of editorial_role on public.profiles
  for each row execute function public.journaliser_modification('editorial_role');

do $$
begin
  if to_regclass('public.document_translations') is not null then
    drop trigger if exists journal_document_translations on public.document_translations;
    create trigger journal_document_translations after update on public.document_translations
      for each row execute function public.journaliser_modification('status', 'lang');
  end if;
end $$;

create index if not exists audit_log_created_idx on public.audit_log (created_at desc);
