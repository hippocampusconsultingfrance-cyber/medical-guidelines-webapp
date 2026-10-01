-- Verrou de publication complet (cahier des charges V4.5 §9.2 et §12.4 ;
-- spécification technique : « contrainte en base qui refuse la publication
-- si l'une des conditions manque » ; checklist 2.1-1) : une fiche n'est mise
-- en ligne qu'avec
--   - une URL de la source officielle,
--   - une date de publication de la source,
--   - un statut juridique « validé » dans le registre juridique
--     (source_legal_profiles), seul statut qui permet la publication.
--
--   - document_non_publiable(doc_id) : raison du refus, ou null ;
--   - publish_document refuse avec cette raison ; publish_all_documents ne
--     met en ligne que les fiches publiables ;
--   - garde-fou sur la table documents : la même règle s'applique à toute
--     mise en ligne faite par un compte (API), y compris hors de ces
--     fonctions. Les fiches déjà en ligne ne sont pas retirées.
--   - les modifications du registre sont tracées dans le journal
--     d'administration.
-- Idempotent.

create or replace function public.document_non_publiable(doc_id uuid)
returns text language sql stable security definer set search_path = public
as $$
  select case
    when d.id is null then 'Fiche introuvable'
    when d.freshness_status = 'retiree' then 'Fiche retirée'
    when coalesce(trim(d.source_url), '') = '' then 'URL de la source officielle manquante'
    when d.publication_date is null then 'Date de publication de la source manquante'
    when not exists (
      select 1 from public.source_legal_profiles l
      where l.document_id = d.id and l.legal_review_status = 'valide'
    ) then 'Statut juridique non validé dans le registre juridique'
  end
  from (select doc_id as id) x
  left join public.documents d on d.id = x.id;
$$;
revoke execute on function public.document_non_publiable(uuid) from public, anon;
grant execute on function public.document_non_publiable(uuid) to authenticated, service_role;

create or replace function public.publish_document(doc_id uuid, publier boolean)
returns int
language plpgsql
volatile
security definer
set search_path = public
as $$
declare
  uid uuid := auth.uid();
  n int;
  raison text;
begin
  if uid is null or not public.has_editorial_role('validateur') then
    raise exception 'Réservé aux validateurs' using errcode = '42501';
  end if;

  if publier then
    raison := public.document_non_publiable(doc_id);
    if raison is not null then
      raise exception 'Publication refusée : %', raison using errcode = '23514';
    end if;
    update public.documents d
       set published_at = coalesce(d.published_at, now())
     where d.id = doc_id;

    update public.recommendations r
       set status = 'active',
           reviewed_by = uid,
           approved_by = uid,
           published_by = uid,
           published_at = now()
     where r.document_id = doc_id
       and r.status in ('draft', 'review', 'under_review');
  else
    update public.documents d set published_at = null where d.id = doc_id;
    update public.recommendations r
       set status = 'under_review',
           revision_reason = coalesce(r.revision_reason, 'Dépubliée par un validateur')
     where r.document_id = doc_id
       and r.status = 'active';
  end if;

  get diagnostics n = row_count;
  return n;
end;
$$;

create or replace function public.publish_all_documents()
returns int
language plpgsql
volatile
security definer
set search_path = public
as $$
declare
  n int;
begin
  if auth.uid() is null or not public.is_admin() then
    raise exception 'Réservé à l''administrateur' using errcode = '42501';
  end if;
  update public.documents d
     set published_at = now()
   where d.published_at is null
     and d.presentation_json is not null
     and public.document_non_publiable(d.id) is null;
  get diagnostics n = row_count;
  return n;
end;
$$;

revoke execute on function public.publish_all_documents() from public, anon;
grant execute on function public.publish_all_documents() to authenticated, service_role;

-- Garde-fou : mise en ligne directe par un compte (API). Fonction exécutée
-- avec les droits de l'appelant : current_user vaut « authenticated » pour
-- une requête de l'API, et le propriétaire des fonctions ci-dessus quand la
-- mise en ligne passe par elles (déjà contrôlée).
create or replace function public.verrou_publication()
returns trigger language plpgsql security invoker set search_path = public
as $$
declare
  raison text;
begin
  if old.published_at is null and new.published_at is not null
     and current_user in ('authenticated', 'anon') then
    raison := public.document_non_publiable(new.id);
    if raison is not null then
      raise exception 'Publication refusée : %', raison using errcode = '23514';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists verrou_publication on public.documents;
create trigger verrou_publication before update of published_at on public.documents
  for each row execute function public.verrou_publication();

-- Journal des modifications du registre juridique.
drop trigger if exists journal_source_legal_profiles on public.source_legal_profiles;
create trigger journal_source_legal_profiles after insert or update or delete on public.source_legal_profiles
  for each row execute function public.journaliser_modification(
    'legal_review_status', 'copyright_status', 'commercial_reuse_allowed', 'translation_allowed', 'permission_obtained');

-- Le registre n'est pas public.
revoke all on public.source_legal_profiles from anon;
