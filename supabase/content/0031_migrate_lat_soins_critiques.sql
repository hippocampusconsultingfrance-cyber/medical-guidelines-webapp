-- Migration : Décisions de limitation et d'arrêt de traitements (LAT) en soins critiques de
-- l'adulte — Recommandations Formalisées d'Experts, SFAR en association avec la SOFMER
-- (Société Française de Médecine Physique et de Réadaptation). Comité de 20 experts
-- (dont un expert usager HAS et un expert soins palliatifs), coordination M. Giabicani.
-- Texte validé par le Comité des Référentiels Cliniques SFAR le 10/05/2025, CA SFAR le
-- 15/07/2025. Champ : adulte uniquement (soins critiques pédiatriques explicitement
-- exclus par la source). Source : rfe-sfar-website/build/content_lat_soins_critiques.json
-- (9 recommandations, 3 champs, 9 questions PICO).
--
-- MÉTHODOLOGIE — PARTICULARITÉ DE CE DOCUMENT (disclosure explicite du contenu construit
-- lui-même) : GRADE 1 (force forte), GRADE 2 (force faible/optionnelle), avis d'experts
-- (AE) — MAIS **aucun tag GRADE de cette source ne porte de signe +/-**, contrairement à
-- la quasi-totalité des autres RFE de ce corpus. Le contenu construit indique avoir lui-même
-- inféré la polarité (toutes positives pour les 3 recommandations gradées 1/2 de ce
-- document) et ajouté un signe « + » "par cohérence visuelle avec le reste du corpus" —
-- CECI EST UNE CONVENTION ÉDITORIALE DE LA FICHE, PAS UNE COTATION IMPRIMÉE PAR LA SOURCE.
-- Pour rester strictement fidèle à ce que la source imprime réellement (principe 1.3 du
-- projet : jamais de grade inventé), `grade` reproduit ici les valeurs BRUTES de la source
-- ('1', '2', 'AE'), SANS le signe « + » ajouté éditorialement par la fiche — divergence
-- volontaire par rapport au chip visuel du contenu construit, disclosure explicite. Aucune
-- des recommandations de ce document n'est de polarité négative de toute façon (donc aucune
-- perte d'information : "1" ici signifierait "1+" si le signe existait, mais il n'existe
-- pas dans la source, donc "1" seul est la reproduction fidèle). `evidence_level` laissé
-- NULL.
--
-- COMPTAGE — RECONCILIÉ EXACTEMENT, CONFIRMÉ PAR LA SOURCE ELLE-MÊME : "9 recommandations
-- avec accord fort après 1 tour de vote (1 GRADE 1, 2 GRADE 2, 6 avis d'experts) et 2
-- absences de recommandation". Comptage direct des 9 lignes migrées : 1×"1" (R3.1), 2×"2"
-- (R1.4, R3.3.2), 6×AE (R1.1, R1.2, R1.3, R2.1, R3.2, R3.3.1) = reconciliation exacte.
--
-- FORMULATION R1.3 ET R2.1 : disclosure de la source elle-même — le texte du « Tableau
-- récapitulatif recommandations » diffère très légèrement de celui imprimé sous
-- l'argumentaire de chaque question (R1.3 : ajout de « et au sein de l'équipe soignante » ;
-- R2.1 : « protocole de sédation » vs « protocole pour l'administration de la sédation »).
-- La méthode de la source précise que ce tableau récapitulatif intègre les « amendements
-- validés par les experts concernés et le coordinateur, ainsi que les groupes de lecture » —
-- c'est donc cette formulation finale amendée qui est reproduite ici pour R1.3 et R2.1,
-- cohérent avec le choix déjà fait par le contenu construit source.
--
-- PÉRIMÈTRE — volontairement pas migrés (référence/algorithme/protocole opérationnel, pas
-- des recommandations individuellement graduées par le jury, cohérent avec le principe déjà
-- appliqué ailleurs dans ce corpus) : les 8 figures/encadrés de la source — Figures 1, 2, 4
-- (encadrés réglementaires : directives anticipées, personne de confiance, procédure
-- collégiale et intervenant extérieur), Figure 3 (algorithme décisionnel de LAT), Figure 5
-- (déroulement en 5 phases + check-list d'une procédure collégiale), Figure 6 (protocole de
-- sédation profonde et continue, posologies, échelles RASS/BPS/RDOS), Figure 7 (stratégie
-- d'accompagnement des proches), Figure 8 (outils de communication) — reproduites
-- intégralement dans la fiche de synthèse elle-même (contenu réglementaire/pratique de
-- grande valeur clinique), simplement pas migrées comme des lignes `recommendations`
-- individuellement graduées, car non cotées une à une par le jury RFE.
-- Également volontairement pas migrées, les 2 « absences de recommandation » explicitement
-- disclosées par la source (extubation vs sevrage progressif après décision d'arrêt des
-- traitements ; intervention d'une équipe de médiation) — cohérent avec le principe de ce
-- projet de ne jamais migrer une absence de recommandation comme une ligne graduée.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SOFMER (Société Française de Médecine Physique et de Réadaptation), co-organisatrice
--    de cette RFE au même titre que la SFAR, n'a pas d'entrée correspondante dans le seed
--    Annexe B de schema_v2.sql — seule la SFAR est liée en document_societies.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Décisions de limitation et d''arrêt de traitements (LAT) en soins critiques de l''adulte',
  'RFE', 'fr', '2025-07-15',
  'https://sfar.org/decisions-de-limitation-et-darret-de-traitements-lat-en-soins-critiques-de-ladulte/',
  'https://sfar.org/download/decisions-de-limitation-et-darret-de-traitements-lat-en-soins-critiques-de-ladulte/?wpdmdl=123089',
  'GRADE® : GRADE 1 (force forte), GRADE 2 (force faible/optionnelle), avis d''experts (AE). Particularité de ce document : AUCUN tag GRADE de la source ne porte de signe +/-, à la différence de la plupart des autres RFE de ce corpus — grade reproduit ici tel quel ("1"/"2"/"AE"), sans signe ajouté. Accord fort obtenu pour les 9 recommandations après 1 seul tour de vote. Champ adulte uniquement, soins critiques pédiatriques explicitement exclus par la source.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/decisions-de-limitation-et-darret-de-traitements-lat-en-soins-critiques-de-ladulte/'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/decisions-de-limitation-et-darret-de-traitements-lat-en-soins-critiques-de-ladulte/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'medecine_palliative_et_soins_palliatifs')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/decisions-de-limitation-et-darret-de-traitements-lat-en-soins-critiques-de-ladulte/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000031-R01', 'Les experts suggèrent d''organiser des réunions pluriprofessionnelles régulières de réflexion et d''échange autour du projet de soins des patients afin d''améliorer la qualité des soins.', 'AE', 'Champ 1 — Réunions pluriprofessionnelles et volontés du patient (Réf. R1.1)'),
  ('MG-ANES-000031-R02', 'Les experts suggèrent de rechercher les volontés du patient hospitalisé en soins critiques précocement et par tout moyen possible afin d''améliorer la qualité des soins.', 'AE', 'Champ 1 — Réunions pluriprofessionnelles et volontés du patient (Réf. R1.2)'),
  ('MG-ANES-000031-R03', 'Pour les patients hospitalisés en soins critiques, lors d''une réflexion autour d''une prise de décision de limitation et/ou d''arrêt des traitements, les experts suggèrent d''utiliser un protocole de service d''aide à la décision et de communication avec les proches et au sein de l''équipe soignante pour améliorer la qualité des soins.', 'AE', 'Champ 1 — Protocole d''aide à la décision et équipes paramédicales (Réf. R1.3)'),
  ('MG-ANES-000031-R04', 'Pour les patients hospitalisés en service de soins critiques, il est probablement recommandé d''inclure la participation active des équipes paramédicales aux réunions de procédure collégiale de limitation et/ou arrêt des traitements afin d''améliorer la qualité des soins.', '2', 'Champ 1 — Protocole d''aide à la décision et équipes paramédicales (Réf. R1.4)'),
  ('MG-ANES-000031-R05', 'Chez les patients hospitalisés en soins critiques, après une décision d''arrêt des traitements, les experts suggèrent d''utiliser un protocole de sédation profonde et continue maintenue jusqu''au décès pour améliorer la qualité des soins.', 'AE', 'Champ 2 — Sédation profonde et continue et extubation (Réf. R2.1)'),
  ('MG-ANES-000031-R06', 'Pour les proches de patients hospitalisés en services de soins critiques, il est recommandé d''utiliser une stratégie d''accompagnement structurée après une décision d''arrêt et/ou limitation de traitements, incluant des interactions proactives avec l''équipe soignante et/ou des supports de communication, pour améliorer la qualité des soins.', '1', 'Champ 3 — Relations avec les proches, communication, conflits (Réf. R3.1)'),
  ('MG-ANES-000031-R07', 'En service de soins critiques, les experts suggèrent de former l''équipe médico-soignante à la communication pour permettre de prévenir les conflits entre proches et équipes médico-soignantes.', 'AE', 'Champ 3 — Relations avec les proches, communication, conflits (Réf. R3.2)'),
  ('MG-ANES-000031-R08', 'Pour les proches de patients hospitalisés et l''équipe médico-soignante en service de soins critiques, en cas de désaccords/conflits autour d''une décision de limitation et/ou arrêt des traitements, les experts suggèrent de faire intervenir une structure d''éthique clinique pour améliorer la qualité des soins.', 'AE', 'Champ 3 — Relations avec les proches, communication, conflits (Réf. R3.3.1)'),
  ('MG-ANES-000031-R09', 'Pour les proches de patients hospitalisés et l''équipe médico-soignante en service de soins critiques, en prévention d''un désaccord/conflit entre proches et équipes soignantes dans une situation à risque de conflit de valeurs autour d''une décision de limitation et/ou arrêt des traitements, il est probablement recommandé de faire intervenir une structure d''éthique clinique pour améliorer la qualité des soins.', '2', 'Champ 3 — Relations avec les proches, communication, conflits (Réf. R3.3.2)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/decisions-de-limitation-et-darret-de-traitements-lat-en-soins-critiques-de-ladulte/'
on conflict (recommendation_code) do nothing;
