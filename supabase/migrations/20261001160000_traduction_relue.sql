-- Traductions (checklist 2.1-2 et 2.3-3) : en plus de l'autorisation de
-- traduction au registre juridique (migration 20261001140000), une
-- traduction ne peut être publiée qu'après sa relecture (statut « relue »).
-- Idempotent.

create or replace function public.verrou_traduction()
returns trigger language plpgsql security definer set search_path = public
as $$
begin
  if new.status = 'publiee' and (tg_op = 'INSERT' or old.status is distinct from 'publiee') then
    if tg_op = 'INSERT' or old.status is distinct from 'relue' then
      raise exception 'Publication de la traduction refusée : traduction non relue'
        using errcode = '23514';
    end if;
    if not exists (
      select 1 from public.source_legal_profiles l
      where l.document_id = new.document_id
        and l.legal_review_status = 'valide'
        and l.translation_allowed = 'oui'
    ) then
      raise exception 'Publication de la traduction refusée : traduction non autorisée dans le registre juridique'
        using errcode = '23514';
    end if;
  end if;
  return new;
end;
$$;
revoke execute on function public.verrou_traduction() from public, anon, authenticated;
