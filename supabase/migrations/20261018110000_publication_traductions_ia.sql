-- Publication des traductions des fiches (décision du porteur du
-- 17/10/2026) : une traduction peut être publiée
--   - relue par un médecin dans sa langue (statut « relue », comme avant) ;
--   - ou réalisée par IA et NON relue dans sa langue, avec la mention
--     « Traduction réalisée par IA à partir de la fiche française relue par
--     un médecin. Non relue dans cette langue. La version française et le
--     texte officiel font foi. » (publiee_sans_relecture), seulement si :
--       · la fiche française est publiée et relue par un médecin (relue_le) ;
--       · la traduction part du contenu français actuel (fr_a_jour) ;
--       · aucun point « à vérifier » ne reste (doutes de l'IA et
--         signalements des contrôles automatiques : doses, unités, grades,
--         négations — build/trad_ia.py de l'atelier).
-- Dans les deux cas, le registre juridique doit autoriser la traduction
-- (translation_allowed = 'oui', revue juridique « valide ») : traduire est un
-- droit de l'auteur (CPI art. L122-4).
-- Lecture : get_translation (membres qui ont le droit de lire la fiche, mêmes
-- garde-fous anti-extraction) ; carte publique traduite :
-- get_translation_card ; langues publiées : langues_traduites.
-- Idempotent.

alter table public.document_translations add column if not exists publiee_sans_relecture boolean not null default false;
alter table public.document_translations add column if not exists publiee_le timestamptz;
alter table public.document_translations add column if not exists publiee_par uuid references public.profiles(id) on delete set null;
create index if not exists document_translations_publiee_par_idx on public.document_translations (publiee_par);

create or replace function public.verrou_traduction()
returns trigger language plpgsql security definer set search_path = public
as $$
begin
  if new.status = 'publiee' and (tg_op = 'INSERT' or old.status is distinct from 'publiee') then
    if new.publiee_sans_relecture then
      if not new.fr_a_jour then
        raise exception 'Publication de la traduction refusée : la fiche française a changé depuis la traduction'
          using errcode = '23514';
      end if;
      if coalesce(jsonb_array_length(new.a_verifier), 0) > 0 then
        raise exception 'Publication de la traduction refusée : points à vérifier non traités'
          using errcode = '23514';
      end if;
      if not exists (
        select 1 from public.documents d
        where d.id = new.document_id and public.document_is_visible(d.id) and d.relue_le is not null
      ) then
        raise exception 'Publication de la traduction refusée : fiche française non publiée ou non relue par un médecin'
          using errcode = '23514';
      end if;
    elsif tg_op = 'INSERT' or old.status is distinct from 'relue' then
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

-- Publier ou retirer une traduction (validateur ou administrateur). Une
-- traduction relue est publiée comme telle ; sinon, comme traduction par IA
-- non relue (conditions vérifiées par le verrou). Renvoie « ok » ou le motif
-- du refus.
create or replace function public.publish_translation(doc_id uuid, target_lang text, publier boolean)
returns text language plpgsql volatile security definer set search_path = public
as $$
declare
  n int;
begin
  if not public.has_editorial_role('validateur') then
    return 'Droits de validateur requis';
  end if;
  if publier then
    update public.document_translations
       set publiee_sans_relecture = (status <> 'relue'),
           status = 'publiee',
           publiee_le = now(),
           publiee_par = auth.uid()
     where document_id = doc_id and lang = target_lang and status <> 'publiee';
  else
    update public.document_translations
       set status = case when reviewed_at is not null and not publiee_sans_relecture then 'relue' else 'brouillon' end,
           publiee_sans_relecture = false,
           publiee_le = null,
           publiee_par = null
     where document_id = doc_id and lang = target_lang and status = 'publiee';
  end if;
  get diagnostics n = row_count;
  return case when n = 1 then 'ok' else 'Traduction introuvable ou déjà dans cet état' end;
exception when check_violation then
  return sqlerrm;
end;
$$;
revoke execute on function public.publish_translation(uuid, text, boolean) from public, anon;
grant execute on function public.publish_translation(uuid, text, boolean) to authenticated;

-- Contenu d'une traduction publiée, pour un membre qui a le droit de lire la
-- fiche : même contrôle et même journal de lecture que la fiche française.
create or replace function public.get_translation(doc_id uuid, target_lang text)
returns jsonb language plpgsql volatile security definer set search_path = public
as $$
begin
  if not exists (
    select 1 from public.document_translations t
    where t.document_id = doc_id and t.lang = target_lang and t.status = 'publiee' and t.fr_a_jour
  ) then
    return null;
  end if;
  if public.get_document_presentation(doc_id) is null then
    return null;
  end if;
  return (
    select jsonb_build_object(
      'card', t.card_json,
      'presentation', t.presentation_json,
      'key_points', t.key_points,
      'ia_non_relue', t.publiee_sans_relecture
    )
    from public.document_translations t
    where t.document_id = doc_id and t.lang = target_lang
  );
end;
$$;
revoke execute on function public.get_translation(uuid, text) from public, anon;
grant execute on function public.get_translation(uuid, text) to authenticated, service_role;

-- Carte publique traduite (titre, résumé : publics comme la carte
-- française) d'une fiche publiée.
create or replace function public.get_translation_card(doc_id uuid, target_lang text)
returns jsonb language sql stable security definer set search_path = public
as $$
  select jsonb_build_object('card', t.card_json, 'ia_non_relue', t.publiee_sans_relecture)
  from public.document_translations t
  where t.document_id = doc_id and t.lang = target_lang and t.status = 'publiee' and t.fr_a_jour
    and public.document_is_visible(doc_id);
$$;
revoke execute on function public.get_translation_card(uuid, text) from public;
grant execute on function public.get_translation_card(uuid, text) to anon, authenticated, service_role;

-- Langues dans lesquelles une fiche publiée a une traduction publiée.
create or replace function public.langues_traduites(doc_id uuid)
returns text[] language sql stable security definer set search_path = public
as $$
  select coalesce(array_agg(t.lang order by t.lang), '{}')
  from public.document_translations t
  where t.document_id = doc_id and t.status = 'publiee' and t.fr_a_jour
    and public.document_is_visible(doc_id);
$$;
revoke execute on function public.langues_traduites(uuid) from public;
grant execute on function public.langues_traduites(uuid) to anon, authenticated, service_role;

-- Toutes les traductions publiées des fiches en ligne (plan du site).
create or replace function public.traductions_publiees()
returns table (document_id uuid, lang text) language sql stable security definer set search_path = public
as $$
  select t.document_id, t.lang
  from public.document_translations t
  where t.status = 'publiee' and t.fr_a_jour and public.document_is_visible(t.document_id)
  order by t.document_id, t.lang;
$$;
revoke execute on function public.traductions_publiees() from public;
grant execute on function public.traductions_publiees() to anon, authenticated, service_role;
