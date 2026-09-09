-- Medical Guidelines — schéma cible V2 (recommandations atomiques)
-- Réfère : Cahier des charges medical-guidelines.net V2.1 (fourni par le
-- propriétaire du projet le 2026-09-08 ; voir sections citées dans les
-- commentaires ci-dessous). Ce fichier COMPLÈTE schema.sql (V1 :
-- profils/auth) — les deux scripts sont conçus pour être exécutés l'un
-- après l'autre sur le même projet Supabase (Dashboard -> SQL Editor ->
-- New query -> coller -> Run), dans l'ordre schema.sql puis schema_v2.sql.
--
-- Toutes les instructions sont idempotentes (create table/column/extension
-- if not exists ; drop policy/trigger if exists avant recréation) pour
-- pouvoir être rejouées sans erreur.
--
-- CE FICHIER EST LE MODÈLE DE DONNÉES (DDL). Les recommandations
-- atomiques elles-mêmes, extraites fiche par fiche depuis
-- rfe-sfar-website/build/content_*.json, sont écrites comme des scripts
-- de migration DML séparés dans supabase/migrations/ (jamais exécutées
-- directement en base par la routine — pas d'identifiants de production).

create extension if not exists pgcrypto; -- gen_random_uuid()

-- =========================================================================
-- 0. Fonction utilitaire partagée : maintien de updated_at
-- =========================================================================
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- =========================================================================
-- 1. Extension du profil utilisateur (section 5.1, 5.2, 8.2, 12.1)
-- =========================================================================
-- Le profil de base (nom/prénom/téléphone/profession/consentements) existe
-- déjà dans schema.sql (V1). On y ajoute uniquement les champs V2 :
-- pays d'exercice, langue préférée, rattachement à la taxonomie
-- "specialties" (créée plus bas — d'où l'ALTER après la table), statut de
-- vérification professionnelle renforcée (5.1), rôle éditorial pour la
-- traçabilité des relectures (8.2), appartenance au comité consultatif
-- (12.1), et visibilité de la spécialité (5.2 : "privée par défaut ; toute
-- visibilité publique nécessite un mécanisme de consentement distinct").
alter table public.profiles add column if not exists pays_exercice text;
alter table public.profiles add column if not exists langue_preferee text not null default 'fr';
alter table public.profiles add column if not exists specialty_visibility_public boolean not null default false;
alter table public.profiles add column if not exists specialty_visibility_consented_at timestamptz;

-- CORRECTIF POST-AUDIT : schema.sql (V1) déclare profiles.telephone NOT NULL,
-- ce qui contredit deux exigences explicites de ce cahier des charges —
-- 5.1 ("téléphone international si sa finalité est justifiée") et 13
-- ("Minimisation des données personnelles ; ne collecter le téléphone que
-- si une finalité explicite existe"). V2 est le point d'évolution du
-- modèle V1 (section 17 : "Conserver et durcir SI NÉCESSAIRE") ; ici c'est
-- l'inverse, assouplir pour respecter la minimisation — d'où ce DROP NOT
-- NULL plutôt qu'une modification de schema.sql lui-même.
alter table public.profiles alter column telephone drop not null;

-- Vérification professionnelle renforcée (5.1) : facultative au lancement,
-- généralisable ensuite. "verifiee" pilote l'affichage du badge de profil
-- vérifié — colonne générée plutôt que dupliquée, pour ne jamais désynchro-
-- niser badge et statut. 5.1 cite 3 méthodes distinctes ("domaine
-- institutionnel, numéro professionnel ou justificatif") : method identifie
-- laquelle a été utilisée, evidence porte sa valeur/référence.
alter table public.profiles add column if not exists professional_verification_status text
  not null default 'non_demandee'
  check (professional_verification_status in ('non_demandee', 'en_cours', 'verifiee', 'refusee'));
alter table public.profiles add column if not exists professional_verification_method text
  check (professional_verification_method is null
    or professional_verification_method in ('domaine_institutionnel', 'numero_professionnel', 'justificatif'));
alter table public.profiles add column if not exists professional_verification_evidence text;
alter table public.profiles add column if not exists verified_badge boolean
  generated always as (professional_verification_status = 'verifiee') stored;

-- Rôle éditorial (8.2 : "Traçabilité des rôles" ; 12 : back-office et
-- gouvernance). null = utilisateur standard, sans droit éditorial.
alter table public.profiles add column if not exists editorial_role text
  check (editorial_role is null or editorial_role in ('relecteur', 'validateur', 'admin'));
-- 12.1 : Comité consultatif scientifique multi-spécialités — indépendant du
-- rôle éditorial courant (un membre du comité n'est pas nécessairement
-- relecteur/validateur au quotidien).
alter table public.profiles add column if not exists member_comite_consultatif boolean not null default false;

-- Déclaration de conflit d'intérêts au niveau du profil (8.2 : "lorsque
-- pertinente" — donc pas de contrainte NOT NULL, seulement un espace pour
-- la déclarer quand elle existe).
alter table public.profiles add column if not exists conflict_of_interest_notes text;

-- 5.1 : "Option « Autre » avec file de revue du référentiel" — la "file" est
-- une vue filtrée sur profiles.profession_autre (pas de table dédiée : cf.
-- profiles_select_admin plus bas, qui rend cette colonne lisible côté
-- back-office). Index pour que ce filtre reste rapide à l'échelle.
create index if not exists profiles_profession_autre_idx on public.profiles(profession_autre)
  where profession_autre is not null;

-- Helper RLS : un rôle éditorial (relecteur/validateur/admin) peut écrire
-- le contenu de référence ; seul 'admin' gère utilisateurs/référentiels/
-- profils juridiques. SECURITY DEFINER pour être appelable depuis les
-- policies sans exposer profiles à une lecture croisée non désirée.
create or replace function public.has_editorial_role(min_role text)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1 from public.profiles p
    where p.id = auth.uid()
      and (
        p.editorial_role = 'admin'
        or (min_role = 'relecteur' and p.editorial_role in ('relecteur', 'validateur'))
        or (min_role = 'validateur' and p.editorial_role = 'validateur')
      )
  );
$$;

create or replace function public.is_admin()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1 from public.profiles p where p.id = auth.uid() and p.editorial_role = 'admin'
  );
$$;

-- CORRECTIF POST-AUDIT : les triggers ci-dessous (protect_privileged_
-- profile_columns, check_recommendation_review_roles,
-- check_translation_review_role) gardent des colonnes sensibles derrière
-- is_admin(), qui dépend de auth.uid() — or les scripts de migration DML
-- (Tâche 1, supabase/migrations/) qui écriront les recommandations
-- atomiques extraites des fiches tournent typiquement en tant que rôle
-- privilégié (service_role/postgres via l'éditeur SQL Supabase ou
-- `supabase db push`), SANS session utilisateur donc SANS auth.uid(). Sans
-- ce bypass, ces triggers bloqueraient à la fois la toute première
-- promotion admin (aucun admin n'existe encore pour l'accorder) et la
-- totalité du pipeline de migration. Un rôle qui a déjà rolbypassrls
-- (superuser/service_role, qui contourne déjà RLS au niveau base) ne doit
-- pas être plus restreint par un garde-fou applicatif qui vise seulement les
-- utilisateurs finaux authentifiés.
create or replace function public.is_privileged_context()
returns boolean
language sql
stable
as $$
  -- rolsuper ET rolbypassrls testés séparément : un rôle superuser (ex.
  -- 'postgres') bypass RLS via rolsuper indépendamment de rolbypassrls ;
  -- service_role (Supabase) n'est pas superuser mais a rolbypassrls=true.
  select public.is_admin()
    or coalesce((select rolsuper or rolbypassrls from pg_roles where rolname = current_user), false);
$$;

-- (document_has_active_recommendation()/document_is_visible(), utilisées par
-- les policies RLS de documents/recommendations, sont définies plus bas —
-- section 5bis — car elles référencent la table recommendations, qui
-- n'existe pas encore à ce point du script ; les fonctions LANGUAGE SQL sont
-- résolues contre le catalogue dès leur création, contrairement à plpgsql.)

-- CORRECTIF CRITIQUE POST-AUDIT : schema.sql (V1) définit profiles_update_own
-- comme "for update using (auth.uid() = id)" SANS with check — en RLS
-- Postgres, une policy UPDATE sans with check réutilise la clause using
-- comme check, donc la SEULE condition est que la ligne reste la sienne.
-- Or toute policy éditoriale/admin de ce fichier (has_editorial_role(),
-- is_admin()) dérive son autorité de profiles.editorial_role /
-- professional_verification_status / member_comite_consultatif — des
-- colonnes que ce même profiles_update_own laisserait n'importe quel
-- utilisateur modifier sur SA PROPRE ligne (auto-promotion admin). Ce
-- trigger bloque toute modification de ces 3 colonnes par quiconque n'est
-- pas déjà admin, indépendamment de la policy RLS V1 qu'il ne faut pas
-- modifier autrement (elle reste correcte pour nom/téléphone/profession).
-- PAS de "security definer" ici, délibérément (bug trouvé en testant le
-- correctif ci-dessus) : PostgreSQL fait passer current_user à l'identité
-- du propriétaire de la fonction pendant TOUTE la durée d'exécution d'une
-- fonction security definer — y compris pour les appels imbriqués qu'elle
-- fait elle-même. Si CE trigger était security definer, is_privileged_context()
-- (qui inspecte current_user via pg_roles) verrait toujours le propriétaire
-- de la fonction (postgres, superuser) au lieu du rôle réellement appelant,
-- et le garde-fou serait silencieusement inopérant. Cette fonction n'a de
-- toute façon besoin d'aucun privilège élevé : elle ne fait que comparer
-- NEW/OLD et appeler is_privileged_context()/is_admin() (qui, eux, restent
-- security definer pour leur propre lookup interne — l'élévation reste
-- circonscrite à cette portion, sans corrompre l'identité vue ici).
create or replace function public.protect_privileged_profile_columns()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  if (new.editorial_role is distinct from old.editorial_role
      or new.professional_verification_status is distinct from old.professional_verification_status
      or new.member_comite_consultatif is distinct from old.member_comite_consultatif)
     and not public.is_privileged_context()
  then
    raise exception 'editorial_role / professional_verification_status / member_comite_consultatif : modification reservee aux administrateurs.';
  end if;
  return new;
end;
$$;

drop trigger if exists protect_privileged_profile_columns on public.profiles;
create trigger protect_privileged_profile_columns
  before update on public.profiles
  for each row execute function public.protect_privileged_profile_columns();

-- =========================================================================
-- 2. Taxonomie transversale (section 4.2, 9.2)
-- =========================================================================
-- "spécialités, pathologies, symptômes, médicaments, interventions,
-- dispositifs, populations, contextes de soins et sociétés savantes" —
-- 9.2 nomme explicitement 4 tables de taxonomie ("topics / drugs /
-- interventions / populations") en plus de specialties/societies, qui ont
-- leur propre rôle métier (référentiel d'inscription, back-office) et sont
-- donc modélisées séparément ci-dessous. "topic" couvre ici pathologie,
-- symptôme et contexte de soins (aucun champ distinct n'est demandé pour
-- ces trois dans le cahier des charges) ; "device" (dispositif) est
-- fusionné avec "drug" dans le champ recommandations.drug_device (4.1),
-- donc pas de table dispositifs séparée à ce stade.
create table if not exists public.specialties (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  category text not null check (category in ('medicale', 'paramedicale')),
  -- "Autre (champ libre)" (Annexe A, fin de la liste paramédicale) : entrée
  -- catch-all pour la file de revue du référentiel (5.1), jamais une vraie
  -- spécialité à afficher dans les filtres publics.
  is_other boolean not null default false,
  name_i18n jsonb not null, -- {"fr": "...", "en": "..."} ; fr obligatoire au lancement
  created_at timestamptz not null default now()
);
alter table public.profiles add column if not exists specialty_id uuid references public.specialties(id);

create table if not exists public.topics (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  name_i18n jsonb not null,
  created_at timestamptz not null default now()
);

create table if not exists public.drugs (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  name_i18n jsonb not null,
  created_at timestamptz not null default now()
);

create table if not exists public.interventions (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  name_i18n jsonb not null,
  created_at timestamptz not null default now()
);

create table if not exists public.populations (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  name_i18n jsonb not null,
  created_at timestamptz not null default now()
);

-- =========================================================================
-- 3. Sociétés savantes (Annexe B) et profil juridique par source (14.1)
-- =========================================================================
-- Annexe B est explicitement une "liste indicative à intégrer
-- progressivement après validation de la pertinence scientifique, de
-- l'URL officielle, de la méthode de veille et du profil juridique" — donc
-- website_url et le développé de l'acronyme restent nullable ici : le seed
-- (fin de fichier) ne peuple que l'acronyme + le pays/la région, jamais un
-- nom développé deviné ou une URL non vérifiée.
create table if not exists public.societies (
  id uuid primary key default gen_random_uuid(),
  acronym text not null,
  full_name text, -- rempli lors de la validation (14.1), jamais deviné ici
  country_or_region text, -- ex. 'France', 'International', 'Royaume-Uni'
  website_url text,
  vetting_status text not null default 'a_valider'
    check (vetting_status in ('a_valider', 'valide', 'ecarte')),
  created_at timestamptz not null default now(),
  unique (acronym, country_or_region)
);

-- Registre juridique par source (14.1). Rattaché au document (voir note
-- ci-dessous) plutôt qu'à la société : le cahier des charges liste
-- source_legal_profiles séparément de documents dans 9.2 ("Licence,
-- copyright, scraping, traduction, usage commercial, permissions, statut
-- juridique"), et 1.1/2.1 raisonnent au niveau du document source. Le
-- champ "obligatoire" cité en 4.1 est source_url (sur recommendations),
-- pas ce registre — celui-ci peut donc rester incomplet le temps de la
-- revue juridique (legal_review_status = 'non_revu').
-- À VÉRIFIER : le cahier des charges ne précise pas explicitement si un
-- profil juridique peut être partagé par plusieurs documents d'une même
-- société (ex. tous les textes courts SFAR sous le même régime) ou doit
-- être ressaisi document par document. Modélisé ici 1 profil = 1 document
-- (le plus fin, jamais faux même si redondant) ; à confirmer avec le
-- porteur de projet si une mutualisation par société est souhaitée.
create table if not exists public.source_legal_profiles (
  id uuid primary key default gen_random_uuid(),
  document_id uuid not null, -- FK ajoutée après la table documents (dépendance circulaire évitée)
  copyright_status text not null default 'a_verifier'
    check (copyright_status in ('connu', 'a_verifier', 'autorisation_requise')),
  license_type text,
  commercial_reuse_allowed text check (commercial_reuse_allowed in ('oui', 'non', 'incertain')),
  automated_access_allowed text check (automated_access_allowed in ('oui', 'non', 'conditions')),
  translation_allowed text check (translation_allowed in ('oui', 'non', 'conditions')),
  permission_obtained text check (permission_obtained in ('oui', 'non', 'non_necessaire')),
  legal_review_status text not null default 'non_revu'
    check (legal_review_status in ('non_revu', 'en_revue', 'valide', 'bloque')),
  legal_notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (document_id)
);

-- =========================================================================
-- 4. Documents et versions (section 4.1, 4.3, 5.4, 7.3, 9.2)
-- =========================================================================
create table if not exists public.documents (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  society_id uuid references public.societies(id),
  doc_type text, -- ex. 'RBP', 'RFE', 'consensus', 'guideline' — vocabulaire libre (hétérogène par société, 1.1)
  -- CORRECTIF POST-AUDIT : pas de defaut 'fr'. "Langue originale" (4.3) est
  -- un champ exact-source au même titre que grade/evidence_level (1.3) ;
  -- un défaut silencieux produirait une valeur fausse et invisible pour
  -- toute source non francophone (NICE, AWMF, ASA... — cf. Annexe B) au
  -- lieu d'une absence visible. NOT NULL : à renseigner explicitement par
  -- le script de migration à chaque insertion, jamais hérité par défaut.
  original_language text not null,
  publication_date date,
  revision_date date,
  -- 4.3 : identifiants scientifiques
  doi text,
  pmid text,
  -- 4.1/16.3 : "Aucune fiche publiée sans source URL valide" — appliqué au
  -- document autant qu'à chaque recommandation (recommendations.source_url).
  source_url text not null,
  pdf_url text, -- distinct de source_url lorsque applicable (4.3)
  -- 6.3 : "Avertissement lorsque les populations, définitions ou systèmes
  -- de grading ne sont pas directement comparables" — le comparateur a
  -- besoin de savoir QUEL système de gradation un document utilise pour
  -- décider si deux recommandations sont comparables ; vocabulaire libre
  -- (le corpus source utilise au moins 7 conventions distinctes — GRADE,
  -- RAND/UCLA, accord fort/faible, etc. — cf. rfe-sfar-website/CLAUDE.md).
  grading_system text,
  -- 16.2 KPI "Taux de liens sources valides" : santé du lien source,
  -- distincte de la veille de nouvelle version (watch_sources).
  link_status text not null default 'inconnu' check (link_status in ('ok', 'rompu', 'inconnu')),
  link_last_checked_at timestamptz,
  -- 5.4 : statut de fraîcheur visible. Slugs ASCII pour les valeurs
  -- CHECK ; le libellé français exact affiché à l'utilisateur est celui du
  -- tableau 5.4 ("À jour" / "Révision détectée" / "Remplacée" / "Retirée"),
  -- porté par la couche présentation, pas dupliqué ici.
  freshness_status text not null default 'a_jour'
    check (freshness_status in ('a_jour', 'revision_detectee', 'remplacee', 'retiree')),
  superseded_by_document_id uuid references public.documents(id),
  -- 9.3 : "Le contenu ne doit pas être stocké comme HTML monolithique."
  -- Réutilisation explicite (section 17) des content_*.json déjà produits
  -- par le pipeline rfe-sfar-website (arbre sections/panneaux/tableaux) :
  -- stockés ici tels quels pour la présentation web/PDF, SANS
  -- ré-extraction, en complément des recommandations atomiques qui, elles,
  -- sont de nouvelles lignes structurées dans la table recommendations.
  presentation_json jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- ALTER TABLE ... ADD CONSTRAINT n'a pas d'équivalent IF NOT EXISTS en
-- PostgreSQL : on protège l'idempotence via un bloc DO + vérification dans
-- pg_constraint (le rejeu de ce script ne doit jamais échouer ici).
do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'source_legal_profiles_document_id_fkey'
  ) then
    alter table public.source_legal_profiles
      add constraint source_legal_profiles_document_id_fkey
      foreign key (document_id) references public.documents(id) on delete cascade;
  end if;
end;
$$;

-- CORRECTIF POST-AUDIT (LOW) : trigger de maintenance manquant — la colonne
-- updated_at déclarée sur cette table (comme sur documents/recommendations/
-- recommendation_translations) ne se mettait jamais à jour après l'insertion
-- initiale.
drop trigger if exists set_source_legal_profiles_updated_at on public.source_legal_profiles;
create trigger set_source_legal_profiles_updated_at
  before update on public.source_legal_profiles
  for each row execute function public.set_updated_at();

drop trigger if exists set_documents_updated_at on public.documents;
create trigger set_documents_updated_at
  before update on public.documents
  for each row execute function public.set_updated_at();

-- 6.1 : "Recherche plein texte" ; 9.1 : "Recherche PostgreSQL full-text au
-- départ, moteur dédié si nécessaire." Config 'french' fixe : correcte pour
-- le corpus FR au lancement (10) ; une config par locale sera nécessaire à
-- l'extension multilingue de la recherche (hors périmètre de ce script).
alter table public.documents add column if not exists search_vector tsvector
  generated always as (to_tsvector('french', coalesce(title, ''))) stored;
create index if not exists documents_search_vector_idx on public.documents using gin(search_vector);

-- Table de jonction documents <-> specialties (une "fiche"/un document peut
-- relever de plusieurs spécialités, ex. les fiches transversales
-- anesthésie-réanimation/urgences déjà construites — cf.
-- rfe-sfar-website/build/library_final.json "category").
create table if not exists public.document_specialties (
  document_id uuid not null references public.documents(id) on delete cascade,
  specialty_id uuid not null references public.specialties(id) on delete restrict,
  primary key (document_id, specialty_id)
);

-- 7.3 : versionnage. Une ligne par version successive détectée/publiée.
create table if not exists public.document_versions (
  id uuid primary key default gen_random_uuid(),
  document_id uuid not null references public.documents(id) on delete cascade,
  version_label text not null,
  change_type text not null check (change_type in ('majeure', 'mineure')),
  diff_summary text, -- résultat du diff automatique (7.2), résumé lisible pour la revue humaine
  detected_at timestamptz not null default now(),
  published_at timestamptz,
  created_by uuid references public.profiles(id) on delete set null,
  unique (document_id, version_label)
);

-- =========================================================================
-- 5. Recommandations atomiques (section 4.1 — cœur du modèle V2)
-- =========================================================================
create table if not exists public.recommendations (
  id uuid primary key default gen_random_uuid(),
  -- recommendation_code : identifiant permanent lisible, ex.
  -- "MG-ANES-000124-R03" (4.1, Annexe C). Attribué par le script de
  -- migration/l'éditeur au moment de la création (pas de génération
  -- automatique en base : la numérotation par spécialité+document est une
  -- décision applicative, cf. commentaire de migration).
  recommendation_code text unique not null,
  -- CORRECTIF POST-AUDIT : "on delete cascade" ici ferait disparaître sans
  -- trace des recommandations publiées (et leur historique editorial_reviews)
  -- à la moindre suppression d'un document — alors que le modèle prévoit
  -- déjà un cycle de vie explicite pour ça (freshness_status='retiree',
  -- status='withdrawn'/'archived'/'superseded'). "restrict" force à
  -- retirer/archiver explicitement les recommandations avant de pouvoir
  -- supprimer physiquement le document.
  document_id uuid not null references public.documents(id) on delete restrict,
  statement text not null, -- "Formulation éditoriale validée ou citation courte autorisée selon politique juridique" (4.1/14.2)
  -- grade / evidence_level : EXACTEMENT ceux de la source, jamais devinés
  -- ni moyennés (4.1 ; principe non négociable 1.3 : "Pas de grade
  -- inventé, fusionné ou extrapolé"). null si absent de la source.
  grade text,
  evidence_level text,
  population text,
  condition_topic text, -- "condition / topic" (4.1)
  intervention text,
  drug_device text, -- "drug / device" (4.1)
  source_section text,
  source_page int,
  source_url text not null, -- 4.1 : "URL officielle obligatoire" (au niveau de la recommandation elle-même)
  -- 16.2 KPI "Taux de liens sources valides" — au niveau de la recommandation
  -- (source_url peut différer de documents.source_url, cf. 4.3).
  link_status text not null default 'inconnu' check (link_status in ('ok', 'rompu', 'inconnu')),
  link_last_checked_at timestamptz,
  -- Annexe C ("Dernière vérification : AAAA-MM-JJ") + 5.3 ("Source, date,
  -- société, URL officielle et dernière vérification") : date à laquelle la
  -- source a été reconfirmée conforme — distincte de updated_at/published_at
  -- (un simple edit éditorial ou une publication ne "vérifient" pas la
  -- source contre l'original).
  last_verified_at date,
  -- 8.1 étape 6 ("Contrôle automatisé : source, champs obligatoires,
  -- cohérence, similarité textuelle, liens") / 14.2 ("Contrôle automatisé de
  -- similarité textuelle comme filet de sécurité") : résultat de ce contrôle,
  -- alimente la revue humaine sans jamais publier seul (7.2/8.1).
  automated_check_status text not null default 'non_execute'
    check (automated_check_status in ('non_execute', 'ok', 'alerte')),
  automated_check_notes text,
  -- À VÉRIFIER (disclosure, pas une invention) : le cahier des charges
  -- (4.1) énumère littéralement "draft / review / active / under_review /
  -- superseded / withdrawn / archived" SANS jamais distinguer 'review' de
  -- 'under_review' ailleurs dans le texte (aucune section ne les oppose).
  -- Lecture la plus probable, non confirmée : 'review' = relecture initiale
  -- avant première publication (8.1, étapes 6-8) ; 'under_review' = contenu
  -- déjà 'active' remis en question (ex. suite à un signalement critique,
  -- 8.3) et en cours de re-vérification. Les deux valeurs sont reproduites
  -- telles quelles (rien n'est retiré ni fusionné) ; leur usage exact reste
  -- à confirmer avec le porteur de projet.
  status text not null default 'draft'
    check (status in ('draft', 'review', 'active', 'under_review', 'superseded', 'withdrawn', 'archived')),
  version text not null default '1.0',
  -- 8.2 : traçabilité des rôles. "on delete set null" (plutôt que bloquer ou
  -- cascader) : un profil doit rester supprimable (13 : droit à
  -- l'effacement RGPD) sans perdre l'historique éditorial de la
  -- recommandation elle-même.
  created_by uuid references public.profiles(id) on delete set null,
  edited_by uuid references public.profiles(id) on delete set null,
  reviewed_by uuid references public.profiles(id) on delete set null,
  approved_by uuid references public.profiles(id) on delete set null,
  published_by uuid references public.profiles(id) on delete set null,
  published_at timestamptz,
  revision_reason text, -- "motif de modification" (8.2)
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  -- Implémentation directe des principes non négociables 1.3 ("Relecture
  -- humaine obligatoire avant publication") et 8.1 (étapes 7-8 : relecture
  -- médicale spécialisée puis validation finale par un rôle autorisé) :
  -- un statut "active" (l'équivalent, dans le vocabulaire V2.1, d'un
  -- contenu publié/publiquement visible) exige une relecture ET une
  -- validation tracées. Cette contrainte n'est PAS littéralement nommée
  -- dans le cahier des charges — elle en formalise l'exigence.
  constraint recommendations_active_requires_review
    check (status <> 'active' or (reviewed_by is not null and approved_by is not null))
);

drop trigger if exists set_recommendations_updated_at on public.recommendations;
create trigger set_recommendations_updated_at
  before update on public.recommendations
  for each row execute function public.set_updated_at();

create index if not exists recommendations_document_id_idx on public.recommendations(document_id);
create index if not exists recommendations_status_idx on public.recommendations(status);

alter table public.recommendations add column if not exists search_vector tsvector
  generated always as (to_tsvector('french',
    coalesce(statement, '') || ' ' || coalesce(condition_topic, '') || ' ' || coalesce(intervention, ''))) stored;
create index if not exists recommendations_search_vector_idx on public.recommendations using gin(search_vector);

-- CORRECTIF POST-AUDIT (recursion RLS) : documents_select_public et
-- recommendations_select_public (section 13) se vérifient mutuellement
-- ("un document est public s'il a une recommandation active" / "une
-- recommandation est publique si son document n'est pas retiré") — en
-- policy RLS brute (sous-requête directe sur l'autre table protégée par
-- RLS), Postgres évalue chaque policy en ré-évaluant l'autre, qui ré-évalue
-- la première, etc. : "infinite recursion detected in policy". Ces deux
-- fonctions SECURITY DEFINER cassent la boucle exactement comme is_admin()
-- le fait déjà pour profiles (leur requête interne s'exécute hors RLS,
-- comme le propriétaire de la fonction). Définies ici (pas section 1) car
-- elles référencent recommendations, qui doit déjà exister : une fonction
-- LANGUAGE SQL est résolue contre le catalogue dès sa création.
create or replace function public.document_has_active_recommendation(doc_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (select 1 from public.recommendations r where r.document_id = doc_id and r.status = 'active');
$$;

create or replace function public.document_is_visible(doc_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (select 1 from public.documents d where d.id = doc_id and d.freshness_status <> 'retiree');
$$;

-- Lookup étroit et delibérément le SEUL point security definer de ce
-- garde-fou : lire le rôle éditorial d'un profil ARBITRAIRE (celui visé par
-- reviewed_by/approved_by, pas forcément l'appelant) exige de contourner
-- profiles_select_own/profiles_select_admin (RLS), sans quoi un simple
-- relecteur ne verrait jamais le rôle d'un validateur tiers. Isolé dans sa
-- propre fonction pour que les fonctions appelantes ci-dessous puissent
-- rester SECURITY INVOKER (voir leur commentaire).
create or replace function public.get_editorial_role(profile_id uuid)
returns text
language sql
security definer
set search_path = public
stable
as $$
  select editorial_role from public.profiles where id = profile_id;
$$;

-- CORRECTIF POST-AUDIT (HIGH) : recommendations_active_requires_review ne
-- vérifiait que la non-nullité de reviewed_by/approved_by, jamais que ces
-- profils détiennent réellement le rôle requis, ni qu'ils diffèrent de
-- l'auteur — un simple 'relecteur' pouvait donc s'auto-publier en renseignant
-- son propre id (ou l'id de n'importe qui) dans les deux champs. Ce trigger
-- impose : reviewed_by tient au moins le rôle relecteur (8.1 étape 7),
-- approved_by tient le rôle validateur/admin (8.1 étape 8, "rôle autorisé"),
-- approved_by <> created_by (séparation rédaction/validation), et que
-- l'auteur de l'écriture ne peut renseigner ces champs que pour lui-même
-- (sauf admin/migration). PAS de "security definer" ici (même bug que
-- protect_privileged_profile_columns, voir son commentaire) : is_privileged_
-- context() a besoin de voir le VRAI current_user de l'appelant, pas celui
-- du propriétaire de cette fonction — d'où le lookup délégué à
-- get_editorial_role() ci-dessus, seule portion élevée.
create or replace function public.check_recommendation_review_roles()
returns trigger
language plpgsql
set search_path = public
as $$
declare
  reviewer_role text;
  approver_role text;
begin
  if new.status = 'active' then
    reviewer_role := public.get_editorial_role(new.reviewed_by);
    approver_role := public.get_editorial_role(new.approved_by);

    if reviewer_role is null or reviewer_role not in ('relecteur', 'validateur', 'admin') then
      raise exception 'reviewed_by doit referencer un profil avec un role editorial (8.1, etape 7).';
    end if;
    if approver_role is null or approver_role not in ('validateur', 'admin') then
      raise exception 'approved_by doit referencer un profil validateur ou admin (8.1, etape 8).';
    end if;
    if new.approved_by = new.created_by then
      raise exception 'approved_by ne peut pas etre identique a created_by (separation redaction/validation).';
    end if;
    if not public.is_privileged_context() and (new.reviewed_by <> auth.uid() or new.approved_by <> auth.uid()) then
      raise exception 'reviewed_by et approved_by doivent correspondre a l''auteur de l''ecriture (sauf admin/migration).';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists check_recommendation_review_roles on public.recommendations;
create trigger check_recommendation_review_roles
  before insert or update on public.recommendations
  for each row execute function public.check_recommendation_review_roles();

-- Jonctions recommandation <-> taxonomie (many-to-many : "Une même
-- recommandation peut appartenir à plusieurs axes", 4.2).
create table if not exists public.recommendation_topics (
  recommendation_id uuid not null references public.recommendations(id) on delete cascade,
  topic_id uuid not null references public.topics(id) on delete restrict,
  primary key (recommendation_id, topic_id)
);
create table if not exists public.recommendation_drugs (
  recommendation_id uuid not null references public.recommendations(id) on delete cascade,
  drug_id uuid not null references public.drugs(id) on delete restrict,
  primary key (recommendation_id, drug_id)
);
create table if not exists public.recommendation_interventions (
  recommendation_id uuid not null references public.recommendations(id) on delete cascade,
  intervention_id uuid not null references public.interventions(id) on delete restrict,
  primary key (recommendation_id, intervention_id)
);
create table if not exists public.recommendation_populations (
  recommendation_id uuid not null references public.recommendations(id) on delete cascade,
  population_id uuid not null references public.populations(id) on delete restrict,
  primary key (recommendation_id, population_id)
);

-- 9.2 : "Relations thématiques et supersession" entre recommandations
-- individuelles (distinct de documents.superseded_by_document_id, qui
-- couvre le remplacement au niveau du document entier).
create table if not exists public.recommendation_links (
  id uuid primary key default gen_random_uuid(),
  recommendation_id uuid not null references public.recommendations(id) on delete cascade,
  linked_recommendation_id uuid not null references public.recommendations(id) on delete cascade,
  -- Vocabulaire non énuméré littéralement dans le cahier des charges au-delà
  -- de "thématiques et supersession" (9.2) — inféré a minima.
  link_type text not null check (link_type in ('lien_thematique', 'supersede')),
  created_at timestamptz not null default now(),
  check (recommendation_id <> linked_recommendation_id),
  unique (recommendation_id, linked_recommendation_id, link_type)
);

-- =========================================================================
-- 6. Traductions validées (section 10)
-- =========================================================================
create table if not exists public.recommendation_translations (
  id uuid primary key default gen_random_uuid(),
  recommendation_id uuid not null references public.recommendations(id) on delete cascade,
  locale text not null, -- 'en', 'ar', 'es', 'de', ... (10 : déploiement progressif FR+EN puis extensions)
  statement_translated text not null,
  -- "Conservation du grade et du niveau de preuve dans leur forme source"
  -- (10) : PAS de grade/evidence_level dupliqués ici à dessein — la
  -- traduction porte uniquement l'énoncé, le grade reste lu depuis
  -- recommendations (une seule source de vérité, jamais retraduit).
  translated_by uuid references public.profiles(id) on delete set null,
  reviewed_by uuid references public.profiles(id) on delete set null, -- "Validation humaine spécialisée avant publication d'une traduction clinique" (10)
  status text not null default 'draft'
    check (status in ('draft', 'review', 'active', 'under_review', 'superseded', 'withdrawn', 'archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (recommendation_id, locale),
  constraint recommendation_translations_active_requires_review
    check (status <> 'active' or reviewed_by is not null)
);

drop trigger if exists set_recommendation_translations_updated_at on public.recommendation_translations;
create trigger set_recommendation_translations_updated_at
  before update on public.recommendation_translations
  for each row execute function public.set_updated_at();

-- Même correctif que check_recommendation_review_roles, adapté : section 10
-- exige seulement "validation humaine spécialisée" (pas de rôle validateur
-- distinct nommé pour les traductions) — reviewed_by doit donc tenir au
-- moins le rôle relecteur, différer de translated_by, et n'être renseigné
-- que par son propre titulaire (sauf admin/migration). PAS de "security
-- definer" ici, même raison que ci-dessus (get_editorial_role() porte la
-- seule élévation nécessaire).
create or replace function public.check_translation_review_role()
returns trigger
language plpgsql
set search_path = public
as $$
declare
  reviewer_role text;
begin
  if new.status = 'active' then
    reviewer_role := public.get_editorial_role(new.reviewed_by);
    if reviewer_role is null or reviewer_role not in ('relecteur', 'validateur', 'admin') then
      raise exception 'reviewed_by doit referencer un profil avec un role editorial (section 10).';
    end if;
    if new.reviewed_by = new.translated_by then
      raise exception 'reviewed_by ne peut pas etre identique a translated_by (validation humaine specialisee distincte, section 10).';
    end if;
    if not public.is_privileged_context() and new.reviewed_by <> auth.uid() then
      raise exception 'reviewed_by doit correspondre a l''auteur de l''ecriture (sauf admin/migration).';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists check_translation_review_role on public.recommendation_translations;
create trigger check_translation_review_role
  before insert or update on public.recommendation_translations
  for each row execute function public.check_translation_review_role();

-- =========================================================================
-- 7. Veille scientifique (section 7.1)
-- =========================================================================
-- Rattachable soit à une société (veille de flux/page de publications au
-- niveau de la source), soit à un document précis (repolling ciblé d'une
-- page déjà publiée) — le cahier des charges décrit les deux usages (7.1)
-- sans trancher, d'où les deux FK nullables + la contrainte "au moins
-- l'une des deux".
create table if not exists public.watch_sources (
  id uuid primary key default gen_random_uuid(),
  society_id uuid references public.societies(id),
  document_id uuid references public.documents(id),
  method text not null
    check (method in ('rss_atom', 'sitemap', 'api_officielle', 'page_publications', 'empreinte_hash', 'autre')),
  url text not null,
  check_frequency interval not null default '7 days', -- "hebdomadaire par défaut au lancement" (7.1)
  last_checked_at timestamptz,
  last_status text not null default 'inconnu' check (last_status in ('ok', 'erreur', 'inconnu')),
  last_error text,
  -- 7.1 : "Contrôle préalable des conditions d'accès automatisé de chaque
  -- source" — se réfère au profil juridique du document concerné plutôt
  -- que de dupliquer le champ ici.
  created_at timestamptz not null default now(),
  check (society_id is not null or document_id is not null)
);

-- =========================================================================
-- 8. Workflow éditorial (section 8.1, 8.2, 12.1)
-- =========================================================================
create table if not exists public.editorial_reviews (
  id uuid primary key default gen_random_uuid(),
  recommendation_id uuid not null references public.recommendations(id) on delete cascade,
  -- CORRECTIF POST-AUDIT : nullable + "on delete set null" (au lieu de NOT
  -- NULL sans on delete) — un profil ne doit jamais devenir indéfiniment
  -- non supprimable au seul motif qu'il a un jour soumis une relecture (13 :
  -- droit à l'effacement RGPD). La ligne d'audit elle-même est conservée.
  reviewer_id uuid references public.profiles(id) on delete set null,
  -- Étape du workflow cible en 10 points (8.1) à laquelle cette relecture
  -- se rattache (ex. 7 = "Relecture médicale spécialisée", 8 = "Validation
  -- finale par un rôle autorisé", ou une intervention du comité consultatif
  -- — 12.1 — sur un cas litigieux).
  workflow_step text not null
    check (workflow_step in ('relecture_medicale', 'validation_finale', 'comite_consultatif')),
  decision text not null check (decision in ('approuve', 'rejete', 'modifications_demandees')),
  comments text,
  -- 8.2 : "Déclaration de conflits d'intérêts des relecteurs lorsque pertinente."
  conflict_of_interest_declared boolean not null default false,
  conflict_of_interest_notes text,
  created_at timestamptz not null default now()
);
create index if not exists editorial_reviews_recommendation_id_idx on public.editorial_reviews(recommendation_id);

-- =========================================================================
-- 9. Signalements d'erreur et SLA (section 8.3, 12, 16.2)
-- =========================================================================
-- Cible SLA par criticité (8.3), documentée ici en commentaire plutôt que
-- calculée en base : "< 24 h" / "< 5 jours ouvrés" / "< 15 jours" mêle des
-- unités calendaires et ouvrées — un calcul fiable de jours ouvrés
-- appartient à la couche applicative (jours fériés, fuseaux), pas à une
-- contrainte SQL fragile. La colonne target_resolution_at est donc remplie
-- par l'application au moment de l'insertion, pas générée ici.
--   critique -> cible 24 h ; modérée -> cible 5 jours ouvrés ; mineure -> cible 15 jours.
create table if not exists public.error_reports (
  id uuid primary key default gen_random_uuid(),
  -- CORRECTIF POST-AUDIT : "on delete set null" plutôt qu'aucune action —
  -- un signalement garde sa valeur (KPI 16.2, historique SLA) même si la
  -- recommandation/le document visé ou son auteur sont ensuite supprimés ;
  -- sans quoi la suppression d'une recommandation pouvait échouer de façon
  -- peu lisible dès qu'un signalement existait contre elle.
  recommendation_id uuid references public.recommendations(id) on delete set null,
  document_id uuid references public.documents(id) on delete set null,
  reported_by uuid references public.profiles(id) on delete set null, -- nullable : signalement possible sans compte selon UX retenue
  criticality text not null check (criticality in ('critique', 'moderee', 'mineure')),
  description text not null,
  -- Statut opérationnel : NON énuméré littéralement dans le cahier des
  -- charges (qui ne donne que la table des cibles SLA, 8.3) — inféré a
  -- minima pour piloter le tri par criticité (12).
  status text not null default 'nouveau'
    check (status in ('nouveau', 'en_cours', 'resolu', 'rejete')),
  target_resolution_at timestamptz,
  resolved_at timestamptz,
  resolution_notes text,
  created_at timestamptz not null default now()
  -- Pas de CHECK "au moins une cible renseignée" ici : recommendation_id et
  -- document_id sont tous deux "on delete set null" (ci-dessus), donc une
  -- ligne ancienne peut légitimement finir avec les deux à null après
  -- suppression de sa cible d'origine — un CHECK à l'insertion appartient à
  -- la couche application, pas à une contrainte qui bloquerait alors la
  -- suppression elle-même.
);
create index if not exists error_reports_status_idx on public.error_reports(status);
create index if not exists error_reports_criticality_idx on public.error_reports(criticality);

-- =========================================================================
-- 10. Abonnement et institutions (section 11.1, 18)
-- =========================================================================
create table if not exists public.subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  plan text not null check (plan in ('gratuit', 'pro', 'etudiant_interne', 'institution')),
  status text not null default 'actif' check (status in ('actif', 'en_retard', 'annule', 'expire')),
  stripe_customer_id text,
  stripe_subscription_id text,
  current_period_end timestamptz,
  created_at timestamptz not null default now(),
  canceled_at timestamptz,
  unique (user_id)
);

-- 11.1 ("Institution : SSO, gestion de sièges...") / 18 (SSO et gestion
-- multi-établissements) : structure minimale pour amorcer la Phase 6, pas
-- une implémentation SSO complète (hors périmètre détaillé du cahier des
-- charges à ce stade).
create table if not exists public.institutions (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  seats_purchased int not null default 0 check (seats_purchased >= 0),
  billing_notes text,
  created_at timestamptz not null default now()
);
create table if not exists public.institution_members (
  institution_id uuid not null references public.institutions(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  added_at timestamptz not null default now(),
  primary key (institution_id, user_id)
);

-- =========================================================================
-- 11. Suivis et notifications (section 5.2)
-- =========================================================================
-- "Suivis : spécialités, sociétés, thèmes, documents et recommandations
-- individuelles" (5.2) — cinq cibles possibles, une seule par ligne (FK
-- nullables + contrainte "exactement une renseignée"). À VÉRIFIER : la
-- déduplication (un même utilisateur suit deux fois la même cible) n'est
-- pas contrainte ici au niveau base (une contrainte unique propre à des FK
-- polymorphiques nullables est peu robuste en SQL pur) ; à gérer côté
-- application au moment de la création du suivi.
create table if not exists public.notification_preferences (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  -- CORRECTIF POST-AUDIT : "on delete cascade" sur document_id/
  -- recommendation_id — un suivi n'a plus aucun sens une fois sa cible
  -- supprimée (contrairement à error_reports/notifications_log, qui sont un
  -- historique à préserver) ; sans cascade, supprimer un document/une
  -- recommandation suivis échouait purement et simplement. specialty_id/
  -- society_id/topic_id restent en NO ACTION par défaut : ces référentiels
  -- ne sont normalement jamais supprimés physiquement (dépubliés via un
  -- statut, cf. societies.vetting_status), donc le risque est négligeable.
  specialty_id uuid references public.specialties(id),
  society_id uuid references public.societies(id),
  topic_id uuid references public.topics(id),
  document_id uuid references public.documents(id) on delete cascade,
  recommendation_id uuid references public.recommendations(id) on delete cascade,
  frequency text not null default 'immediat' check (frequency in ('immediat', 'digest_hebdo')),
  locale text not null default 'fr',
  created_at timestamptz not null default now(),
  check (
    num_nonnulls(specialty_id, society_id, topic_id, document_id, recommendation_id) = 1
  )
);

create table if not exists public.notifications_log (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  subject text not null,
  body text,
  -- "on delete set null" : le journal d'envoi (KPI 16.1) doit survivre à la
  -- suppression de la cible notifiée.
  recommendation_id uuid references public.recommendations(id) on delete set null,
  document_id uuid references public.documents(id) on delete set null,
  channel text not null default 'email' check (channel in ('email', 'digest_hebdo')),
  sent_at timestamptz not null default now(),
  opened_at timestamptz, -- KPI 16.1 : "Ouverture/clic des notifications"
  clicked_at timestamptz
);
create index if not exists notifications_log_user_id_idx on public.notifications_log(user_id);

-- CORRECTIF POST-AUDIT (gaps trouvés lors de la revue de couverture) :
-- favoris et historique de consultation, deux tables nommées explicitement
-- (5.2 "Historique de consultation et favoris" ; 5.3 "Bouton suivre/favori"
-- — distinct du bouton "suivre" ci-dessus ; 11.1 les liste comme deux
-- fonctionnalités Pro séparées ; KPI 16.1 "Taux d'usage des favoris, suivis
-- et comparaisons") mais absentes de la première version de ce schéma.
create table if not exists public.favorites (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  document_id uuid references public.documents(id) on delete cascade,
  recommendation_id uuid references public.recommendations(id) on delete cascade,
  created_at timestamptz not null default now(),
  check (num_nonnulls(document_id, recommendation_id) = 1),
  unique (user_id, document_id),
  unique (user_id, recommendation_id)
);

create table if not exists public.consultation_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  document_id uuid references public.documents(id) on delete cascade,
  recommendation_id uuid references public.recommendations(id) on delete cascade,
  viewed_at timestamptz not null default now(),
  check (num_nonnulls(document_id, recommendation_id) = 1)
);
create index if not exists consultation_history_user_id_idx on public.consultation_history(user_id, viewed_at desc);

-- =========================================================================
-- 12. Journal d'audit (section 13)
-- =========================================================================
create table if not exists public.audit_log (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references public.profiles(id) on delete set null, -- null = action système (ex. veille automatisée) ou profil depuis supprimé
  action text not null,
  entity_type text not null,
  entity_id uuid,
  before jsonb,
  after jsonb,
  created_at timestamptz not null default now()
);
create index if not exists audit_log_entity_idx on public.audit_log(entity_type, entity_id);

-- =========================================================================
-- 13. Row Level Security
-- =========================================================================
-- Principe général (13 : "Sécurité au niveau base de données, pas
-- uniquement interface") : lecture publique du contenu réellement validé
-- (documents/recommendations/recommendation_translations et leurs tables de
-- jonction : seulement si la recommandation — et son document parent — sont
-- 'active' / non retirés, pas simplement non-'draft' ; specialties/
-- societies/topics/drugs/interventions/populations restent des référentiels
-- ouverts en lecture), écriture réservée aux rôles éditoriaux. Tables
-- personnelles (subscriptions, notification_preferences, notifications_log,
-- favorites, consultation_history) : chacun voit/gère les siennes, admin
-- inclus. Tables sensibles (source_legal_profiles, watch_sources,
-- editorial_reviews, error_reports en lecture, audit_log, profiles au-delà
-- de sa propre ligne) : réservées aux rôles éditoriaux/admin.
-- À VÉRIFIER : le cahier des charges ne précise pas le détail exact de ce
-- qui distingue l'accès "Gratuit" de l'accès "Pro" au sein d'une même
-- recommandation active (texte intégral vs. aperçu, 11.1/16.3) — non
-- modélisé ici (RLS ouvre la lecture du contenu 'active' à tout visiteur
-- authentifié ou non ; le filtrage fin par plan d'abonnement, s'il doit
-- exister au niveau base plutôt qu'en présentation, reste à spécifier).

-- CORRECTIF POST-AUDIT : schema.sql (V1) n'ajoute qu'une policy
-- profiles_select_own — aucun rôle éditorial ne pouvait lire la table
-- profiles (nécessaire pour 12 "Gestion utilisateurs... et institutions" et
-- 5.1, file de revue "Autre"). Policies SELECT multiples sur une même table
-- sont combinées en OR par Postgres : ceci AJOUTE l'accès admin sans retirer
-- l'accès self-service défini en V1.
drop policy if exists profiles_select_admin on public.profiles;
create policy profiles_select_admin on public.profiles for select using (public.is_admin());

alter table public.specialties enable row level security;
drop policy if exists specialties_select_all on public.specialties;
create policy specialties_select_all on public.specialties for select using (true);
drop policy if exists specialties_write_admin on public.specialties;
create policy specialties_write_admin on public.specialties for all using (public.is_admin()) with check (public.is_admin());

alter table public.topics enable row level security;
drop policy if exists topics_select_all on public.topics;
create policy topics_select_all on public.topics for select using (true);
drop policy if exists topics_write_editorial on public.topics;
create policy topics_write_editorial on public.topics for all using (public.has_editorial_role('relecteur')) with check (public.has_editorial_role('relecteur'));

alter table public.drugs enable row level security;
drop policy if exists drugs_select_all on public.drugs;
create policy drugs_select_all on public.drugs for select using (true);
drop policy if exists drugs_write_editorial on public.drugs;
create policy drugs_write_editorial on public.drugs for all using (public.has_editorial_role('relecteur')) with check (public.has_editorial_role('relecteur'));

alter table public.interventions enable row level security;
drop policy if exists interventions_select_all on public.interventions;
create policy interventions_select_all on public.interventions for select using (true);
drop policy if exists interventions_write_editorial on public.interventions;
create policy interventions_write_editorial on public.interventions for all using (public.has_editorial_role('relecteur')) with check (public.has_editorial_role('relecteur'));

alter table public.populations enable row level security;
drop policy if exists populations_select_all on public.populations;
create policy populations_select_all on public.populations for select using (true);
drop policy if exists populations_write_editorial on public.populations;
create policy populations_write_editorial on public.populations for all using (public.has_editorial_role('relecteur')) with check (public.has_editorial_role('relecteur'));

alter table public.societies enable row level security;
drop policy if exists societies_select_all on public.societies;
create policy societies_select_all on public.societies for select using (true);
drop policy if exists societies_write_admin on public.societies;
create policy societies_write_admin on public.societies for all using (public.is_admin()) with check (public.is_admin());

alter table public.source_legal_profiles enable row level security;
drop policy if exists source_legal_profiles_editorial_only on public.source_legal_profiles;
create policy source_legal_profiles_editorial_only on public.source_legal_profiles for all
  using (public.has_editorial_role('validateur')) with check (public.has_editorial_role('validateur'));

alter table public.documents enable row level security;
drop policy if exists documents_select_public on public.documents;
-- CORRECTIF POST-AUDIT : freshness_status seul ne dit rien de l'état de
-- validation éditoriale (il vaut 'a_jour' par défaut dès l'insertion, avant
-- toute relecture) — un document, avec son presentation_json complet, était
-- donc public dès sa création. On exige désormais au moins une
-- recommandation 'active' pour qu'un document soit visible publiquement.
create policy documents_select_public on public.documents for select
  using (
    (freshness_status <> 'retiree' and public.document_has_active_recommendation(documents.id))
    or public.has_editorial_role('relecteur')
  );
drop policy if exists documents_write_editorial on public.documents;
create policy documents_write_editorial on public.documents for all
  using (public.has_editorial_role('validateur')) with check (public.has_editorial_role('validateur'));

alter table public.document_specialties enable row level security;
drop policy if exists document_specialties_select_all on public.document_specialties;
create policy document_specialties_select_all on public.document_specialties for select using (true);
drop policy if exists document_specialties_write_editorial on public.document_specialties;
create policy document_specialties_write_editorial on public.document_specialties for all
  using (public.has_editorial_role('relecteur')) with check (public.has_editorial_role('relecteur'));

alter table public.document_versions enable row level security;
drop policy if exists document_versions_select_all on public.document_versions;
create policy document_versions_select_all on public.document_versions for select using (true);
drop policy if exists document_versions_write_editorial on public.document_versions;
create policy document_versions_write_editorial on public.document_versions for all
  using (public.has_editorial_role('relecteur')) with check (public.has_editorial_role('relecteur'));

alter table public.recommendations enable row level security;
drop policy if exists recommendations_select_public on public.recommendations;
-- CORRECTIF POST-AUDIT : une recommandation 'active' restait lisible même
-- si son document parent était 'retiree' (retrait du document par la
-- source/pour raison éditoriale/juridique, 5.4, ne masquait pas son contenu
-- publié). Ajout de la vérification du document parent.
create policy recommendations_select_public on public.recommendations for select
  using (
    (status = 'active' and public.document_is_visible(recommendations.document_id))
    or public.has_editorial_role('relecteur')
  );
drop policy if exists recommendations_write_editorial on public.recommendations;
create policy recommendations_write_editorial on public.recommendations for all
  using (public.has_editorial_role('relecteur')) with check (public.has_editorial_role('relecteur'));

-- CORRECTIF POST-AUDIT (4 policies ci-dessous) : "using (true)" rendait le
-- tagging thématique/médicament/intervention/population lisible par tous
-- même pour une recommandation encore 'draft' — fuite de métadonnées sur du
-- contenu non publié. Gate désormais sur le statut de la recommandation
-- parente (ou rôle éditorial).
alter table public.recommendation_topics enable row level security;
drop policy if exists recommendation_topics_select_all on public.recommendation_topics;
create policy recommendation_topics_select_all on public.recommendation_topics for select
  using (
    exists (select 1 from public.recommendations r where r.id = recommendation_topics.recommendation_id and r.status = 'active')
    or public.has_editorial_role('relecteur')
  );
drop policy if exists recommendation_topics_write_editorial on public.recommendation_topics;
create policy recommendation_topics_write_editorial on public.recommendation_topics for all
  using (public.has_editorial_role('relecteur')) with check (public.has_editorial_role('relecteur'));

alter table public.recommendation_drugs enable row level security;
drop policy if exists recommendation_drugs_select_all on public.recommendation_drugs;
create policy recommendation_drugs_select_all on public.recommendation_drugs for select
  using (
    exists (select 1 from public.recommendations r where r.id = recommendation_drugs.recommendation_id and r.status = 'active')
    or public.has_editorial_role('relecteur')
  );
drop policy if exists recommendation_drugs_write_editorial on public.recommendation_drugs;
create policy recommendation_drugs_write_editorial on public.recommendation_drugs for all
  using (public.has_editorial_role('relecteur')) with check (public.has_editorial_role('relecteur'));

alter table public.recommendation_interventions enable row level security;
drop policy if exists recommendation_interventions_select_all on public.recommendation_interventions;
create policy recommendation_interventions_select_all on public.recommendation_interventions for select
  using (
    exists (select 1 from public.recommendations r where r.id = recommendation_interventions.recommendation_id and r.status = 'active')
    or public.has_editorial_role('relecteur')
  );
drop policy if exists recommendation_interventions_write_editorial on public.recommendation_interventions;
create policy recommendation_interventions_write_editorial on public.recommendation_interventions for all
  using (public.has_editorial_role('relecteur')) with check (public.has_editorial_role('relecteur'));

alter table public.recommendation_populations enable row level security;
drop policy if exists recommendation_populations_select_all on public.recommendation_populations;
create policy recommendation_populations_select_all on public.recommendation_populations for select
  using (
    exists (select 1 from public.recommendations r where r.id = recommendation_populations.recommendation_id and r.status = 'active')
    or public.has_editorial_role('relecteur')
  );
drop policy if exists recommendation_populations_write_editorial on public.recommendation_populations;
create policy recommendation_populations_write_editorial on public.recommendation_populations for all
  using (public.has_editorial_role('relecteur')) with check (public.has_editorial_role('relecteur'));

alter table public.recommendation_links enable row level security;
drop policy if exists recommendation_links_select_all on public.recommendation_links;
create policy recommendation_links_select_all on public.recommendation_links for select
  using (
    exists (select 1 from public.recommendations r where r.id = recommendation_links.recommendation_id and r.status = 'active')
    or public.has_editorial_role('relecteur')
  );
drop policy if exists recommendation_links_write_editorial on public.recommendation_links;
create policy recommendation_links_write_editorial on public.recommendation_links for all
  using (public.has_editorial_role('relecteur')) with check (public.has_editorial_role('relecteur'));

alter table public.recommendation_translations enable row level security;
drop policy if exists recommendation_translations_select_public on public.recommendation_translations;
-- CORRECTIF POST-AUDIT : défense en profondeur — une traduction 'active'
-- dont la recommandation source aurait depuis été retirée/dépubliée ne doit
-- pas rester lisible seule.
create policy recommendation_translations_select_public on public.recommendation_translations for select
  using (
    (status = 'active' and exists (
      select 1 from public.recommendations r where r.id = recommendation_translations.recommendation_id and r.status = 'active'
    ))
    or public.has_editorial_role('relecteur')
  );
drop policy if exists recommendation_translations_write_editorial on public.recommendation_translations;
create policy recommendation_translations_write_editorial on public.recommendation_translations for all
  using (public.has_editorial_role('relecteur')) with check (public.has_editorial_role('relecteur'));

alter table public.watch_sources enable row level security;
drop policy if exists watch_sources_editorial_only on public.watch_sources;
create policy watch_sources_editorial_only on public.watch_sources for all
  using (public.has_editorial_role('relecteur')) with check (public.has_editorial_role('relecteur'));

alter table public.editorial_reviews enable row level security;
drop policy if exists editorial_reviews_editorial_only on public.editorial_reviews;
create policy editorial_reviews_editorial_only on public.editorial_reviews for all
  using (public.has_editorial_role('relecteur')) with check (public.has_editorial_role('relecteur'));

alter table public.error_reports enable row level security;
-- N'importe qui peut signaler une erreur (2.1 : "Signaler une erreur ou
-- une ambiguïté", ouvert à tout utilisateur du site) ; seule l'équipe
-- éditoriale lit/traite la file complète. Un auteur voit son propre
-- signalement (suivi de son statut), pas ceux des autres.
drop policy if exists error_reports_insert_any on public.error_reports;
create policy error_reports_insert_any on public.error_reports for insert
  with check (reported_by is null or reported_by = auth.uid());
drop policy if exists error_reports_select_own_or_editorial on public.error_reports;
create policy error_reports_select_own_or_editorial on public.error_reports for select
  using (reported_by = auth.uid() or public.has_editorial_role('relecteur'));
drop policy if exists error_reports_update_editorial on public.error_reports;
create policy error_reports_update_editorial on public.error_reports for update
  using (public.has_editorial_role('relecteur')) with check (public.has_editorial_role('relecteur'));

alter table public.subscriptions enable row level security;
drop policy if exists subscriptions_select_own on public.subscriptions;
create policy subscriptions_select_own on public.subscriptions for select
  using (user_id = auth.uid() or public.is_admin());
drop policy if exists subscriptions_write_own_or_admin on public.subscriptions;
create policy subscriptions_write_own_or_admin on public.subscriptions for all
  using (user_id = auth.uid() or public.is_admin()) with check (user_id = auth.uid() or public.is_admin());

alter table public.institutions enable row level security;
drop policy if exists institutions_admin_only on public.institutions;
create policy institutions_admin_only on public.institutions for all using (public.is_admin()) with check (public.is_admin());

alter table public.institution_members enable row level security;
drop policy if exists institution_members_select_own_or_admin on public.institution_members;
create policy institution_members_select_own_or_admin on public.institution_members for select
  using (user_id = auth.uid() or public.is_admin());
drop policy if exists institution_members_write_admin on public.institution_members;
create policy institution_members_write_admin on public.institution_members for all
  using (public.is_admin()) with check (public.is_admin());

alter table public.notification_preferences enable row level security;
drop policy if exists notification_preferences_own on public.notification_preferences;
create policy notification_preferences_own on public.notification_preferences for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());

alter table public.notifications_log enable row level security;
drop policy if exists notifications_log_select_own on public.notifications_log;
create policy notifications_log_select_own on public.notifications_log for select
  using (user_id = auth.uid() or public.is_admin());
drop policy if exists notifications_log_write_admin on public.notifications_log;
create policy notifications_log_write_admin on public.notifications_log for insert
  with check (public.is_admin());

alter table public.audit_log enable row level security;
drop policy if exists audit_log_admin_only on public.audit_log;
create policy audit_log_admin_only on public.audit_log for select using (public.is_admin());
-- Pas de policy INSERT ouverte : le journal d'audit est écrit exclusivement
-- via des fonctions SECURITY DEFINER dédiées (à ajouter au fil des
-- besoins), jamais directement par un rôle applicatif.

alter table public.favorites enable row level security;
drop policy if exists favorites_own on public.favorites;
create policy favorites_own on public.favorites for all
  using (user_id = auth.uid() or public.is_admin()) with check (user_id = auth.uid() or public.is_admin());

alter table public.consultation_history enable row level security;
drop policy if exists consultation_history_own on public.consultation_history;
create policy consultation_history_own on public.consultation_history for all
  using (user_id = auth.uid() or public.is_admin()) with check (user_id = auth.uid() or public.is_admin());

-- =========================================================================
-- 14. Seeds — Annexe A (taxonomie initiale des spécialités)
-- =========================================================================
-- "Liste de départ destinée à alimenter le référentiel « specialties » et
-- le formulaire d'inscription, complétée dans le temps via les saisies
-- « Autre »" (Annexe A). Reproduit ici EXACTEMENT les deux listes du cahier
-- des charges (aucun ajout, aucune omission) ; l'entrée "Autre" reste hors
-- seed de spécialité normale (is_other = true) et n'est pas destinée à
-- apparaître dans les filtres publics.
insert into public.specialties (slug, category, name_i18n) values
('medecine_generale_medecine_de_famille', 'medicale', '{"fr": "Médecine générale / médecine de famille"}'),
('allergologie', 'medicale', '{"fr": "Allergologie"}'),
('anesthesie_reanimation', 'medicale', '{"fr": "Anesthésie-réanimation"}'),
('cardiologie', 'medicale', '{"fr": "Cardiologie"}'),
('chirurgie_cardiaque', 'medicale', '{"fr": "Chirurgie cardiaque"}'),
('chirurgie_digestive_et_viscerale', 'medicale', '{"fr": "Chirurgie digestive et viscérale"}'),
('chirurgie_de_la_main', 'medicale', '{"fr": "Chirurgie de la main"}'),
('chirurgie_maxillo_faciale', 'medicale', '{"fr": "Chirurgie maxillo-faciale"}'),
('chirurgie_orthopedique_et_traumatologique', 'medicale', '{"fr": "Chirurgie orthopédique et traumatologique"}'),
('chirurgie_pediatrique', 'medicale', '{"fr": "Chirurgie pédiatrique"}'),
('chirurgie_plastique_reconstructrice_et_esthetique', 'medicale', '{"fr": "Chirurgie plastique, reconstructrice et esthétique"}'),
('chirurgie_thoracique', 'medicale', '{"fr": "Chirurgie thoracique"}'),
('chirurgie_urologique', 'medicale', '{"fr": "Chirurgie urologique"}'),
('chirurgie_vasculaire', 'medicale', '{"fr": "Chirurgie vasculaire"}'),
('dermatologie_et_venereologie', 'medicale', '{"fr": "Dermatologie et vénéréologie"}'),
('endocrinologie_diabetologie_maladies_metaboliques', 'medicale', '{"fr": "Endocrinologie, diabétologie, maladies métaboliques"}'),
('gastro_enterologie_et_hepatologie', 'medicale', '{"fr": "Gastro-entérologie et hépatologie"}'),
('genetique_medicale', 'medicale', '{"fr": "Génétique médicale"}'),
('geriatrie', 'medicale', '{"fr": "Gériatrie"}'),
('gynecologie_obstetrique', 'medicale', '{"fr": "Gynécologie-obstétrique"}'),
('hematologie', 'medicale', '{"fr": "Hématologie"}'),
('immunologie_clinique', 'medicale', '{"fr": "Immunologie clinique"}'),
('infectiologie_maladies_infectieuses_et_tropicales', 'medicale', '{"fr": "Infectiologie / maladies infectieuses et tropicales"}'),
('medecine_du_travail', 'medicale', '{"fr": "Médecine du travail"}'),
('medecine_du_sport', 'medicale', '{"fr": "Médecine du sport"}'),
('medecine_d_urgence', 'medicale', '{"fr": "Médecine d''urgence"}'),
('medecine_intensive_reanimation', 'medicale', '{"fr": "Médecine intensive-réanimation"}'),
('medecine_interne', 'medicale', '{"fr": "Médecine interne"}'),
('medecine_legale', 'medicale', '{"fr": "Médecine légale"}'),
('medecine_nucleaire', 'medicale', '{"fr": "Médecine nucléaire"}'),
('medecine_palliative_et_soins_palliatifs', 'medicale', '{"fr": "Médecine palliative et soins palliatifs"}'),
('medecine_physique_et_de_readaptation', 'medicale', '{"fr": "Médecine physique et de réadaptation"}'),
('medecine_de_la_douleur_algologie', 'medicale', '{"fr": "Médecine de la douleur / algologie"}'),
('neonatologie', 'medicale', '{"fr": "Néonatologie"}'),
('nephrologie', 'medicale', '{"fr": "Néphrologie"}'),
('neurochirurgie', 'medicale', '{"fr": "Neurochirurgie"}'),
('neurologie', 'medicale', '{"fr": "Neurologie"}'),
('odontologie_chirurgie_dentaire', 'medicale', '{"fr": "Odontologie / chirurgie dentaire"}'),
('oncologie_medicale', 'medicale', '{"fr": "Oncologie médicale"}'),
('ophtalmologie', 'medicale', '{"fr": "Ophtalmologie"}'),
('orl_et_chirurgie_cervico_faciale', 'medicale', '{"fr": "ORL et chirurgie cervico-faciale"}'),
('pediatrie', 'medicale', '{"fr": "Pédiatrie"}'),
('pedopsychiatrie', 'medicale', '{"fr": "Pédopsychiatrie"}'),
('pneumologie', 'medicale', '{"fr": "Pneumologie"}'),
('psychiatrie', 'medicale', '{"fr": "Psychiatrie"}'),
('radiologie_et_imagerie_medicale', 'medicale', '{"fr": "Radiologie et imagerie médicale"}'),
('radiotherapie_oncologie_radiotherapique', 'medicale', '{"fr": "Radiothérapie / oncologie radiothérapique"}'),
('rhumatologie', 'medicale', '{"fr": "Rhumatologie"}'),
('sante_publique_et_medecine_sociale', 'medicale', '{"fr": "Santé publique et médecine sociale"}'),
('toxicologie', 'medicale', '{"fr": "Toxicologie"}'),
('urologie', 'medicale', '{"fr": "Urologie"}'),
('infirmierere_soins_generaux', 'paramedicale', '{"fr": "Infirmier(ère) — soins généraux"}'),
('infirmierere_anesthesiste_iade', 'paramedicale', '{"fr": "Infirmier(ère) anesthésiste (IADE)"}'),
('infirmierere_de_bloc_operatoire_ibode', 'paramedicale', '{"fr": "Infirmier(ère) de bloc opératoire (IBODE)"}'),
('infirmierere_en_pratique_avancee_ipa', 'paramedicale', '{"fr": "Infirmier(ère) en pratique avancée (IPA)"}'),
('infirmierere_puericulteurrice', 'paramedicale', '{"fr": "Infirmier(ère) puériculteur(rice)"}'),
('sage_femme_maieuticienne', 'paramedicale', '{"fr": "Sage-femme / maïeuticien(ne)"}'),
('kinesitherapeute_physiotherapeute', 'paramedicale', '{"fr": "Kinésithérapeute / physiothérapeute"}'),
('ergotherapeute', 'paramedicale', '{"fr": "Ergothérapeute"}'),
('orthophoniste', 'paramedicale', '{"fr": "Orthophoniste"}'),
('orthoptiste', 'paramedicale', '{"fr": "Orthoptiste"}'),
('psychomotricienne', 'paramedicale', '{"fr": "Psychomotricien(ne)"}'),
('dieteticienne_nutritionniste', 'paramedicale', '{"fr": "Diététicien(ne) / nutritionniste"}'),
('pharmacienne', 'paramedicale', '{"fr": "Pharmacien(ne)"}'),
('preparateurrice_en_pharmacie', 'paramedicale', '{"fr": "Préparateur(rice) en pharmacie"}'),
('manipulateurrice_en_electroradiologie_medicale', 'paramedicale', '{"fr": "Manipulateur(rice) en électroradiologie médicale"}'),
('technicienne_de_laboratoire_medical', 'paramedicale', '{"fr": "Technicien(ne) de laboratoire médical"}'),
('audioprothesiste', 'paramedicale', '{"fr": "Audioprothésiste"}'),
('podologue', 'paramedicale', '{"fr": "Podologue"}'),
('opticienne', 'paramedicale', '{"fr": "Opticien(ne)"}'),
('ambulancierere', 'paramedicale', '{"fr": "Ambulancier(ère)"}'),
('aide_soignante', 'paramedicale', '{"fr": "Aide-soignant(e)"}'),
('auxiliaire_de_puericulture', 'paramedicale', '{"fr": "Auxiliaire de puériculture"}'),
('assistante_dentaire', 'paramedicale', '{"fr": "Assistant(e) dentaire"}'),
('prothesiste_dentaire', 'paramedicale', '{"fr": "Prothésiste dentaire"}'),
('perfusionniste', 'paramedicale', '{"fr": "Perfusionniste"}'),
('technicienne_en_physiologie_medicale', 'paramedicale', '{"fr": "Technicien(ne) en physiologie médicale"}'),
('osteopathe', 'paramedicale', '{"fr": "Ostéopathe"}'),
('chiropracteurrice', 'paramedicale', '{"fr": "Chiropracteur(rice)"}'),
('assistante_sociale_en_sante', 'paramedicale', '{"fr": "Assistant(e) social(e) en santé"}')
on conflict (slug) do nothing;

insert into public.specialties (slug, category, is_other, name_i18n) values
('autre_paramedical', 'paramedicale', true, '{"fr": "Autre (champ libre)"}')
on conflict (slug) do nothing;

-- =========================================================================
-- 15. Seeds — Annexe B (référentiel initial des sociétés savantes)
-- =========================================================================
-- "Liste indicative à intégrer progressivement après validation..."
-- (Annexe B) : seedée ici a minima (acronyme + pays/région), vetting_status
-- = 'a_valider' par défaut — full_name et website_url volontairement NULL
-- (voir commentaire sur la table societies) plutôt que devinés.
insert into public.societies (acronym, country_or_region) values
('SFAR', 'France'), ('SRLF', 'France'), ('HAS', 'France'), ('SPILF', 'France'),
('SFMU', 'France'), ('CNGOF', 'France'), ('SFC', 'France'), ('SFN', 'France'), ('SFD', 'France'),
('ESAIC', 'International'), ('ESICM', 'International'), ('SCCM', 'International'),
('ASA', 'International'), ('DAS', 'International'), ('ASRA', 'International'),
('NICE', 'Royaume-Uni'),
('AWMF', 'Allemagne'),
('SEMICYUC', 'Espagne / Amérique latine')
on conflict (acronym, country_or_region) do nothing;
