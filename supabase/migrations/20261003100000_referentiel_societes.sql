-- Référentiel des sociétés et rôle des sociétés sur un document (plan
-- d'intégration des sociétés savantes, docs/referentiel/, lot 0, T2 et T3).
--
--   - societies.slug : identifiant unique, utilisable dans les adresses
--     (/{langue}/{spécialité}/{société}/{fiche}). Calculé à l'insertion à
--     partir du sigle ; en cas d'homonymie (14 sigles du référentiel sont
--     portés par plusieurs organisations : ASA, SPA…), le code pays est
--     ajouté (asa-us, asa-au), sinon un numéro.
--   - societies.country_code : code pays ISO 3166-1 alpha-2 (FR, US…),
--     vide pour une organisation internationale.
--   - document_societies.role : auteur (société porteuse, documents.society_id),
--     co_auteur (co-signataire) ou approbation (société qui approuve
--     seulement : mentionnée sans dupliquer la fiche, décision D10).
--
-- Rien n'est publié ni affiché par cette migration. Idempotent.

alter table public.societies add column if not exists slug text;
alter table public.societies add column if not exists country_code text;
do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'societies_country_code_check') then
    alter table public.societies
      add constraint societies_country_code_check check (country_code ~ '^[A-Z]{2}$');
  end if;
end $$;

-- Sigle → slug : minuscules, sans accents, tirets pour tout autre caractère.
create or replace function public.slug_societe(p_texte text)
returns text
language sql
immutable
set search_path = ''
as $$
  select trim(both '-' from regexp_replace(
    lower(translate(coalesce(p_texte, ''),
      'ÀÂÄÁÃÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝàâäáãçéèêëíìîïñóòôöõúùûüýÿ',
      'AAAAACEEEEIIIINOOOOOUUUUYaaaaaceeeeiiiinooooouuuuyy')),
    '[^a-z0-9]+', '-', 'g'));
$$;

create or replace function public.societies_slug_defaut()
returns trigger
language plpgsql
set search_path = ''
as $$
declare
  base text;
  candidat text;
  n int := 1;
begin
  if new.slug is not null and new.slug <> '' then
    return new;
  end if;
  base := coalesce(nullif(public.slug_societe(new.acronym), ''), 'societe');
  candidat := base;
  if exists (select 1 from public.societies where slug = candidat and id <> new.id)
     and new.country_code is not null then
    candidat := base || '-' || lower(new.country_code);
  end if;
  while exists (select 1 from public.societies where slug = candidat and id <> new.id) loop
    n := n + 1;
    candidat := base || '-' || n;
  end loop;
  new.slug := candidat;
  return new;
end;
$$;

drop trigger if exists societies_slug_defaut on public.societies;
create trigger societies_slug_defaut
  before insert or update of slug on public.societies
  for each row execute function public.societies_slug_defaut();

-- Sociétés existantes : slug calculé une fois (les sigles en base sont
-- distincts ; le déclencheur départage sinon).
update public.societies set slug = null where slug is null;

create unique index if not exists societies_slug_key on public.societies (slug);
alter table public.societies alter column slug set not null;

-- Rôle d'une société sur un document.
alter table public.document_societies add column if not exists role text not null default 'co_auteur';
do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'document_societies_role_check') then
    alter table public.document_societies
      add constraint document_societies_role_check check (role in ('auteur', 'co_auteur', 'approbation'));
  end if;
end $$;

-- La société porteuse est l'auteur.
update public.document_societies ds
   set role = 'auteur'
  from public.documents d
 where d.id = ds.document_id
   and d.society_id = ds.society_id
   and ds.role <> 'auteur';
