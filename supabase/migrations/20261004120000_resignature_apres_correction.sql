-- Relecture après correction : une fiche signée « Équipe médicale interne »
-- puis corrigée (entrée au journal public des corrections postérieure à sa
-- dernière signature) peut être signée à nouveau depuis la page de relecture
-- groupée, après relecture des corrections par l'équipe médicale.
--
--   - fiches_corrigees_apres_signature() : fiches concernées (validateurs
--     uniquement) ; la date de référence est la dernière signature inscrite
--     au journal d'audit, à défaut la date de relecture affichée ;
--   - signer_relecture_equipe() accepte désormais ces fiches en plus des
--     fiches jamais signées. Une fiche signée nominativement n'est jamais
--     modifiée ; le journal précise s'il s'agit d'une nouvelle signature.
-- Idempotent.

create or replace function public.fiches_corrigees_apres_signature()
returns setof uuid
language sql
stable
security definer
set search_path = public
as $fn$
  select d.id
    from public.documents d
   where public.has_editorial_role('validateur')
     and d.relue_par_nom = 'Équipe médicale interne'
     and exists (
       select 1 from public.corrections_log l
        where l.document_id = d.id
          and l.created_at > coalesce(
                (select max(a.created_at) from public.audit_log a
                  where a.entity_id = d.id and a.action = 'fiche_relue'),
                d.relue_le::timestamptz)
     );
$fn$;
revoke execute on function public.fiches_corrigees_apres_signature() from public, anon;
grant execute on function public.fiches_corrigees_apres_signature() to authenticated;

create or replace function public.signer_relecture_equipe(doc_ids uuid[])
returns integer
language plpgsql
security definer
set search_path = public
as $fn$
declare
  uid uuid := auth.uid();
  n integer;
begin
  if uid is null or not public.has_editorial_role('validateur') then
    raise exception 'Réservé aux validateurs' using errcode = '42501';
  end if;
  if coalesce(array_length(doc_ids, 1), 0) = 0 or array_length(doc_ids, 1) > 500 then
    raise exception 'Entre 1 et 500 fiches' using errcode = '22023';
  end if;

  with cibles as (
    select d.id, d.relue_par_nom is not null as nouvelle_signature
      from public.documents d
     where d.id = any(doc_ids)
       and (d.relue_par_nom is null
            or d.id in (select public.fiches_corrigees_apres_signature()))
  ), signees as (
    update public.documents d
       set relue_par_nom = 'Équipe médicale interne',
           relue_le = (now() at time zone 'Europe/Paris')::date
      from cibles c
     where d.id = c.id
    returning d.id, c.nouvelle_signature
  ), journal as (
    insert into public.audit_log (actor_id, action, entity_type, entity_id, after)
    select uid, 'fiche_relue', 'documents', s.id,
           jsonb_build_object('relue_par_nom', 'Équipe médicale interne', 'attestation', true,
                              'apres_corrections', s.nouvelle_signature)
      from signees s
    returning 1
  )
  select count(*) into n from journal;
  return n;
end;
$fn$;
revoke execute on function public.signer_relecture_equipe(uuid[]) from public, anon;
grant execute on function public.signer_relecture_equipe(uuid[]) to authenticated;
