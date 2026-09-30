-- Traductions des fiches (cahier des charges V4.5 §7, §9.2, §12.4) : versions
-- anglaises préparées par l'atelier (build/en/), importées en brouillon pour
-- relecture médicale. Rien n'est publié par cette migration : la lecture est
-- réservée à l'équipe éditoriale (relecteur et plus) ; la publication des
-- versions anglaises fera l'objet d'une étape ultérieure (relecture médicale
-- ET accord sur le droit de traduire le résumé de la source).
--
--   - document_translations : une ligne par fiche et par langue ;
--     content_sha256 = empreinte du brouillon importé (un brouillon modifié
--     repasse en « brouillon ») ; fr_a_jour = la traduction part du contenu
--     français actuel de la fiche ;
--   - review_translation(doc_id, lang, relue, notes) : un relecteur marque la
--     traduction relue (ou la repasse en brouillon), avec ses remarques.
-- Écriture du contenu : scripts d'import seulement (supabase/content/0210_…).
-- Idempotent.

create table if not exists public.document_translations (
  document_id uuid not null references public.documents(id) on delete cascade,
  lang text not null check (lang in ('en')),
  card_json jsonb,
  presentation_json jsonb,
  key_points jsonb,
  a_verifier jsonb,
  source_publication_date date,
  content_sha256 text not null,
  fr_a_jour boolean not null default true,
  status text not null default 'brouillon' check (status in ('brouillon', 'relue', 'publiee')),
  review_notes text,
  reviewed_by uuid references public.profiles(id) on delete set null,
  reviewed_at timestamptz,
  imported_at timestamptz not null default now(),
  primary key (document_id, lang)
);

alter table public.document_translations enable row level security;
revoke all on public.document_translations from anon, authenticated;
grant select on public.document_translations to authenticated;

drop policy if exists document_translations_select_editorial on public.document_translations;
create policy document_translations_select_editorial on public.document_translations for select
  to authenticated
  using (public.has_editorial_role('relecteur'));

create or replace function public.review_translation(doc_id uuid, target_lang text, relue boolean, notes text)
returns boolean
language plpgsql
volatile
security definer
set search_path = public
as $$
begin
  if not public.has_editorial_role('relecteur') then
    return false;
  end if;
  update public.document_translations
     set status = case when relue then 'relue' else 'brouillon' end,
         review_notes = nullif(left(coalesce(notes, ''), 4000), ''),
         reviewed_by = auth.uid(),
         reviewed_at = now()
   where document_id = doc_id
     and lang = target_lang
     and status <> 'publiee';
  return found;
end;
$$;

revoke execute on function public.review_translation(uuid, text, boolean, text) from public, anon;
grant execute on function public.review_translation(uuid, text, boolean, text) to authenticated, service_role;
