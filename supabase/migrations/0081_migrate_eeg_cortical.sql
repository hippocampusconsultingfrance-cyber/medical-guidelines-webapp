-- Migration : Monitorage de l'adéquation/profondeur de l'anesthésie à
-- partir de l'analyse de l'EEG cortical — RFE texte court, SFAR, rédigée
-- septembre 2009, publiée 2010 (BIS®, Entropie® — les deux moniteurs
-- commercialisés en France en 2010).
-- Source : rfe-sfar-website/build/content_eeg_cortical.json.
--
-- ⚠️ DISCLOSURE MAJEURE — DOCUMENT SANS RECOMMANDATIONS GRADÉES : ce texte
-- est explicitement construit en format Question/Réponse "sans grille de
-- cotation" (ni niveaux de preuve, ni grades) — le contenu construit le
-- précise lui-même. Le Module A ("connaissances nécessaires") est
-- explicitement qualifié par la source elle-même de "non conçu comme des
-- recommandations". Le Module B (questions 2-5) reste, à la lecture
-- intégrale, de nature explicative/descriptive (performance diagnostique
-- des moniteurs, liste non exhaustive de situations cliniques où le
-- monitorage peut affiner le raisonnement médical) — aucun énoncé "il faut/
-- il est recommandé de faire X" identifiable à un grade ou une force de
-- recommandation, à l'exception des 2 énoncés de la question 6 ci-dessous.
-- Conformément au principe du projet "ne pas fabriquer d'atomicité qui
-- n'existe pas dans la source" : SEULS ces 2 énoncés de la question 6
-- (pédiatrie) sont migrés en `recommendations` ; le reste du contenu
-- (Modules A et B questions 2-5, la figure dose-réponse des halogénés)
-- reste dans la fiche de synthèse HTML mais n'a pas de contrepartie
-- atomique en base — ce n'est PAS un oubli mais une décision disclosed,
-- cohérente avec le traitement déjà appliqué aux panneaux de contexte/
-- méthodologie des autres fiches (ex. Question 5 de `tabagisme`/0077).
-- `grade` est NULL sur les 2 lignes migrées (aucun système de grade dans
-- ce document — même cas que `ponction_lombaire`/0075).
--
-- À VÉRIFIER : l'énoncé "enfant <2 ans : aucune étude ne permet
-- actuellement de recommander l'utilisation du monitorage EEG cortical
-- dans cette tranche d'âge" est une absence de recommandation positive (pas
-- une contre-indication formelle) — reproduit tel quel comme une
-- recommandation de prudence/non-usage faute de preuve, sans inventer de
-- grade "négatif" qui n'existe pas dans la source.
--
-- SOURCE_URL / PDF_URL : `library_final.json` (recherche "EEG cortical" —
-- exactement 1 correspondance) donne `href` et `direct_pdf_url`, identique
-- à l'"URL source" citée par le contenu construit.
--
-- ⚠️ DISCLOSURE — DIVERGENCE DE DATE : le contenu construit indique
-- "septembre 2009 (publié 2010)" pour la rédaction/publication du texte,
-- alors que `library_final.json` donne `exact_date` = "2011" (année seule).
-- Les deux valeurs sont disclosed ; cette migration retient 2010-01-01
-- (plus précis et cohérent avec la citation du texte source lui-même),
-- pas 2011 (année seule de l'index, qui ne se réfère peut-être qu'à
-- l'ajout du document à l'index et non à sa date de rédaction).
--
-- `specialties` : `anesthesie_reanimation` uniquement.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Monitorage de l''adéquation/profondeur de l''anesthésie à partir de l''analyse de l''EEG cortical',
  'RFE', 'fr', '2010-01-01',
  'https://sfar.org/monitorage-de-ladequation-profondeur-de-lanesthesie-a-partir-de-lanalyse-de-leeg-cortical/',
  'https://sfar.org/wp-content/uploads/2015/10/2_SFAR_Monitorage-de-ladequation-profondeur-de-lanesthesie-a-partir-de-lanalyse-de-lEEG-cortical.pdf',
  'Aucune grille de cotation (ni niveaux de preuve, ni grades) : format Question/Réponse. Le Module A ("connaissances nécessaires") est explicitement qualifié par la source de "non conçu comme des recommandations". Seuls 2 énoncés directement actionnables sont identifiés dans tout le document (question 6, pédiatrie) et migrés ci-dessous, `grade` NULL sur les deux — voir disclosure complète de ce choix dans le commentaire de migration.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/monitorage-de-ladequation-profondeur-de-lanesthesie-a-partir-de-lanalyse-de-leeg-cortical/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/monitorage-de-ladequation-profondeur-de-lanesthesie-a-partir-de-lanalyse-de-leeg-cortical/'
  and s.slug in ('anesthesie_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.source_section,
  'https://sfar.org/monitorage-de-ladequation-profondeur-de-lanesthesie-a-partir-de-lanalyse-de-leeg-cortical/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000081-R01', 'Compte tenu de la grande variabilité interindividuelle pharmacodynamique et pharmacocinétique chez l''enfant, l''utilisation du BIS® (moniteur le plus étudié) peut être recommandée dans le contexte d''une anesthésie intraveineuse à objectif de concentration (AIVOC)/totale intraveineuse (TIVA).', null, 'Enfant > 2 ans, anesthésie AIVOC/TIVA', 'Question 6 — Particularités en pédiatrie'),
  ('MG-ANES-000081-R02', 'Aucune étude ne permet actuellement de recommander l''utilisation du monitorage EEG cortical chez l''enfant de moins de 2 ans (et surtout de moins de 6 mois) — pourtant probablement la population la plus vulnérable face aux effets délétères potentiels des anesthésiques généraux et aux processus de mémorisation implicite.', null, 'Enfant < 2 ans, en particulier < 6 mois', 'Question 6 — Particularités en pédiatrie')
) as v(code, statement, grade, population, source_section)
where d.source_url = 'https://sfar.org/monitorage-de-ladequation-profondeur-de-lanesthesie-a-partir-de-lanalyse-de-leeg-cortical/'
on conflict (recommendation_code) do nothing;
