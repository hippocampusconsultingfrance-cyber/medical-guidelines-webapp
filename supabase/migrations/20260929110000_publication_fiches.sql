-- Publication et dépublication d'une fiche par un validateur
-- (cahier des charges V4.5, §9.2 et §9.4 ; checklist 2.4).
--
-- publish_document(doc_id, publier) :
--   - réservé aux profils validateur ou admin ;
--   - publier = true : toutes les recommandations en brouillon ou en relecture
--     de la fiche passent au statut « active », avec relecteur, validateur,
--     auteur et date de publication tracés (le validateur connecté) ;
--   - publier = false : dépublication immédiate, les recommandations actives
--     passent « under_review » et disparaissent pour les membres.
-- Une fiche retirée ou sans URL source n'est jamais publiée. La trace est
-- portée par les recommandations elles-mêmes (reviewed_by, approved_by,
-- published_by, published_at, revision_reason). Idempotent.

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
    if not exists (
      select 1 from public.documents d
      where d.id = doc_id and d.source_url is not null and d.freshness_status <> 'retiree'
    ) then
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

revoke execute on function public.publish_document(uuid, boolean) from public, anon;
grant execute on function public.publish_document(uuid, boolean) to authenticated, service_role;

-- État de publication par fiche, pour l'interface des relecteurs (évite de
-- lire les 4 000+ recommandations une à une). Exécutée avec les droits de
-- l'appelant : un membre n'y voit que ce que les règles d'accès lui montrent.
create or replace function public.document_publication_status()
returns table (document_id uuid, active int, total int)
language sql
stable
security invoker
set search_path = public
as $$
  select r.document_id,
         count(*) filter (where r.status = 'active')::int,
         count(*)::int
  from public.recommendations r
  group by r.document_id;
$$;

revoke execute on function public.document_publication_status() from public, anon;
grant execute on function public.document_publication_status() to authenticated, service_role;
