-- Publication au niveau de la fiche (décision du porteur de projet du
-- 28/09/2026 : toutes les fiches en ligne, bloquées par défaut ; 5 crédits
-- pour un compte gratuit, tout pour un compte PREMIUM).
--
--   - documents.fiche_key : identifiant de la fiche dans l'atelier
--     (rfe-sfar-website), pour les imports ;
--   - documents.published_at : date de mise en ligne de la fiche. Une fiche
--     publiée est visible (bloquée) par les membres de sa spécialité, même
--     si ses recommandations atomiques sont encore en brouillon : son
--     contenu est alors sa mise en page (presentation_json) ;
--   - publish_all_documents() : mise en ligne de toutes les fiches mises en
--     page, réservée à l'administrateur.
-- Idempotent.

alter table public.documents add column if not exists fiche_key text;
alter table public.documents add column if not exists published_at timestamptz;
create unique index if not exists documents_fiche_key_key on public.documents (fiche_key);
grant select (fiche_key, published_at) on public.documents to anon, authenticated;

-- Une fiche est en ligne si elle a été publiée ou si au moins une de ses
-- recommandations est active (règle précédente, conservée). Cette fonction
-- est utilisée par la règle d'accès aux documents et par unlock_document().
create or replace function public.document_has_active_recommendation(doc_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (select 1 from public.documents d where d.id = doc_id and d.published_at is not null)
      or exists (select 1 from public.recommendations r where r.document_id = doc_id and r.status = 'active');
$$;

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
begin
  if uid is null or not public.has_editorial_role('validateur') then
    raise exception 'Réservé aux validateurs' using errcode = '42501';
  end if;

  if publier then
    update public.documents d
       set published_at = coalesce(d.published_at, now())
     where d.id = doc_id and d.source_url is not null and d.freshness_status <> 'retiree';
    get diagnostics n = row_count;
    if n = 0 then
      raise exception 'Fiche introuvable, retirée ou sans source officielle';
    end if;

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

-- Mise en ligne de toutes les fiches mises en page et non retirées.
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
     and d.source_url is not null
     and d.freshness_status <> 'retiree';
  get diagnostics n = row_count;
  return n;
end;
$$;

revoke execute on function public.publish_all_documents() from public, anon;
grant execute on function public.publish_all_documents() to authenticated, service_role;
