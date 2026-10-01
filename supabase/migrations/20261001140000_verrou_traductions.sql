-- Verrou des traductions (cahier des charges V4.5 §7 et §12.4 ; audit
-- juridique du 01/10/2026) : traduire un texte est un droit réservé à son
-- auteur (CPI art. L122-4). Une traduction ne peut passer au statut
-- « publiee » que si le registre juridique de la fiche autorise la
-- traduction d'un résumé (translation_allowed = 'oui') et si le statut de
-- revue juridique est « valide ». S'applique à toute écriture, y compris par
-- le serveur.
-- Idempotent.

create or replace function public.verrou_traduction()
returns trigger language plpgsql security definer set search_path = public
as $$
begin
  if new.status = 'publiee' and (tg_op = 'INSERT' or old.status is distinct from 'publiee') then
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

do $$
begin
  if to_regclass('public.document_translations') is not null then
    drop trigger if exists verrou_traduction on public.document_translations;
    create trigger verrou_traduction before insert or update of status on public.document_translations
      for each row execute function public.verrou_traduction();
  end if;
end $$;
