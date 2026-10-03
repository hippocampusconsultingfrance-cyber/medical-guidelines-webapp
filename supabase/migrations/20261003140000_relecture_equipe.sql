-- Relecture signée « Équipe médicale interne » (audit du 03/10/2026, faille 1).
--
-- Un validateur atteste, pour une ou plusieurs fiches, qu'elles ont été
-- relues par l'équipe médicale interne : la fiche affiche alors « Relue par
-- Équipe médicale interne, le … ». L'attestation est personnelle : le
-- journal d'administration garde le compte du validateur qui l'a donnée.
-- Une fiche déjà signée nominativement n'est jamais écrasée.
-- Idempotent.

create or replace function public.signer_relecture_equipe(doc_ids uuid[])
returns integer
language plpgsql
security definer
set search_path = public
as $$
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

  with signees as (
    update public.documents d
       set relue_par_nom = 'Équipe médicale interne',
           relue_le = (now() at time zone 'Europe/Paris')::date
     where d.id = any(doc_ids)
       and d.relue_par_nom is null
    returning d.id
  ), journal as (
    insert into public.audit_log (actor_id, action, entity_type, entity_id, after)
    select uid, 'fiche_relue', 'documents', s.id,
           jsonb_build_object('relue_par_nom', 'Équipe médicale interne', 'attestation', true)
      from signees s
    returning 1
  )
  select count(*) into n from journal;
  return n;
end;
$$;

revoke execute on function public.signer_relecture_equipe(uuid[]) from public, anon;
grant execute on function public.signer_relecture_equipe(uuid[]) to authenticated;
