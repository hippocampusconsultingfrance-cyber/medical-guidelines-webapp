-- Migration : Position of the French Working Group on Perioperative
-- Haemostasis (GIHP) on viscoelastic tests: What role for which indication
-- in bleeding situations? — Roullet S, de Maistre E, Ickx B, Blais N,
-- Susen S, Faraoni D, Garrigue D, Bonhomme F, Godier A, Lasne D, et le
-- GIHP. Anaesth Crit Care Pain Med 2019;38:539-548 (en ligne le
-- 03/02/2018). Article en libre accès (CC BY-NC-ND), Elsevier Masson SAS
-- pour la Sfar.
--
-- ⚠️ DISCLOSURE — LANGUE ORIGINALE : ARTICLE EN ANGLAIS, PAS EN FRANÇAIS.
-- Le contenu construit le confirme explicitement dans son propre
-- avertissement final : "cette fiche de synthèse indépendante, traduite et
-- condensée de l'anglais". Bien que le GIHP soit un groupe de travail
-- français, cet article a été publié en anglais dans Anaesthesia Critical
-- Care & Pain Medicine — `original_language` = 'en', PAS 'fr' par défaut
-- (piège identifié et vérifié explicitement, pas une supposition).
--
-- Source : rfe-sfar-website/build/content_tests_viscoelastiques.json.
-- MÉTHODOLOGIE — revue narrative de la littérature, SANS GRILLE DE
-- COTATION (ni niveaux de preuve, ni grades) — chaque situation clinique
-- aboutit à une "Position du GIHP" formulée en prose ("The GIHP
-- proposes…"), pas un tag de force individuelle. `grade` NULL sur toutes
-- les lignes migrées (même traitement que `sauv`/0084, `ponction_
-- lombaire`/0075 et `relations_anesth_chir`/0097, sources également sans
-- grade).
--
-- ATOMISATION DES 9 POSITIONS DU GIHP (le contenu construit annonce lui-
-- même "l'intégralité des 9 positions du GIHP explicitement formulées" —
-- décompte vérifié par relecture intégrale des 4 panneaux "Position du
-- GIHP" du contenu construit, chacun regroupant plusieurs propositions
-- distinctes en un seul paragraphe de prose) : traumatisme sévère (3
-- positions : diagnostic précoce/prédiction transfusionnelle + guidage du
-- traitement hémostatique ; ne pas guider l'acide tranexamique sur les
-- TVE ; inclusion dans des algorithmes locaux), HPP (2 positions :
-- évaluation rapide du fibrinogène + utilité des TVE ; ne pas guider
-- l'acide tranexamique sur les TVE), chirurgie cardiaque (2 positions :
-- usage en cas d'hémorragie de fin d'intervention/postopératoire ;
-- inclusion dans des algorithmes), transplantation hépatique (2
-- positions : aide à limiter la transfusion de PSL ; ne pas attendre un
-- tracé typique d'hyperfibrinolyse pour utiliser un antifibrinolytique si
-- d'autres signes cliniques sont présents) — total 3+2+2+2 = 9, cohérent
-- avec le compte annoncé par la source.
--
-- EXCLUSIONS EXPLICITES (disclosed, pas un oubli) :
-- 1. Section Pédiatrie : la source elle-même déclare une "absence de
--    position propre du GIHP" (études insuffisantes) — non migrée. La
--    source cite uniquement une recommandation EXTERNE (Société
--    Européenne d'Anesthésiologie, ESA, Kozek-Langenecker et al. 2013,
--    grade 2C sur la grille de cotation propre à l'ESA) — ce grade
--    n'appartient PAS à ce document GIHP et n'est donc PAS attribué à une
--    ligne `recommendations` de cette migration (même principe que
--    l'exclusion de l'annexe HAS 2012 dans `plyo_transfusion`/0083 : ne
--    pas attribuer à tort le grade/la paternité d'un autre référentiel).
-- 2. Section "Positionnement : chevet ou laboratoire ?" : critères
--    organisationnels/logistiques à peser au cas par cas (délai, personnel,
--    réglementation biologie délocalisée), pas une position GIHP formulée
--    ("The GIHP proposes…") — non migrée comme ligne `recommendations`
--    distincte.
-- 3. Section "Principes des tests viscoélastiques" et "Conclusion
--    (source)" : contenu explicatif/de synthèse générale, pas des
--    positions cliniques individualisées.
--
-- SOURCE_URL / PDF_URL : `library_final.json` (recherche "viscoélastiques"
-- — exactement 1 correspondance) donne `href`/`direct_pdf_url` identiques
-- au contenu construit, et `exact_date` = 2018-02-03, cohérent avec "en
-- ligne le 03/02/2018" cité par le contenu construit — aucune divergence.
--
-- `doc_type` = 'Autre' (`exact_type` de `library_final.json` — position
-- de groupe de travail publiée en revue, ni RFE ni RPP).
--
-- `specialties` : `anesthesie_reanimation` et `medecine_intensive_
-- reanimation` (traumatisme sévère, chirurgie cardiaque) — pas de
-- spécialité "hématologie/hémostase" dédiée retenue au-delà de ces deux
-- libellés, le sujet transversal (traumatologie, obstétrique, chirurgie
-- cardiaque, hépatologie) ne pointant vers aucune spécialité chirurgicale
-- unique.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Position of the French Working Group on Perioperative Haemostasis (GIHP) on viscoelastic tests: What role for which indication in bleeding situations?',
  'Autre', 'en', '2018-02-03',
  'https://sfar.org/download/tests-viscoelastiques-2018/?wpdmdl=34421',
  'https://sfar.org/download/tests-viscoelastiques-2018/?wpdmdl=34421',
  'Revue narrative de la littérature, sans grille de cotation (ni niveaux de preuve, ni grades) — chaque situation clinique aboutit à une "Position du GIHP" formulée en prose. 9 positions au total sur 4 situations cliniques (traumatisme sévère, HPP, chirurgie cardiaque, transplantation hépatique) — décompte confirmé par la source elle-même et vérifié par relecture intégrale. Aucune position propre en pédiatrie (études insuffisantes) — la source cite uniquement une recommandation externe de l''ESA (grade 2C, grille de cotation ESA) non attribuée à ce document.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/download/tests-viscoelastiques-2018/?wpdmdl=34421'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/download/tests-viscoelastiques-2018/?wpdmdl=34421'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.source_section,
  'https://sfar.org/download/tests-viscoelastiques-2018/?wpdmdl=34421',
  'draft'
from public.documents d, (values
  ('MG-ANES-000098-R01', 'Les tests viscoélastiques (TVE) peuvent être utilisés pour le diagnostic précoce de la coagulopathie chez le traumatisé sévère ; ils prédisent le besoin de transfusion en CGR ou le recours à une transfusion massive, et doivent guider le traitement hémostatique et sensibiliser l''équipe à la gravité du traumatisme.', null, 'TVE pour diagnostic précoce et guidage thérapeutique en traumatologie', 'Traumatisme sévère — Position du GIHP (1/3)'),
  ('MG-ANES-000098-R02', 'En raison de leur faible sensibilité pour diagnostiquer l''activation de la fibrinolyse, les TVE ne doivent pas guider l''administration d''acide tranexamique chez le traumatisé sévère — celui-ci doit être administré le plus tôt possible ; en revanche, la détection d''une hyperfibrinolyse par TVE reste un prédicteur de mortalité.', null, 'Non-guidage de l''acide tranexamique par les TVE en traumatologie', 'Traumatisme sévère — Position du GIHP (2/3)'),
  ('MG-ANES-000098-R03', 'Les TVE doivent être inclus dans des algorithmes locaux, avec des seuils pré-établis pour guider produits sanguins labiles et concentrés de facteurs, chez le traumatisé sévère — des études prospectives multicentriques restent nécessaires.', null, 'Inclusion des TVE dans des algorithmes locaux en traumatologie', 'Traumatisme sévère — Position du GIHP (3/3)'),
  ('MG-ANES-000098-R04', 'En cas d''hémorragie du post-partum (HPP), la concentration de fibrinogène doit être rapidement évaluée et les TVE peuvent y être utiles.', null, 'Évaluation rapide du fibrinogène et utilité des TVE en HPP (obstétrique)', 'Hémorragie du post-partum — Position du GIHP (1/2)'),
  ('MG-ANES-000098-R05', 'Compte tenu des limites des TVE dans l''évaluation de l''activité fibrinolytique, il est proposé de ne pas guider l''administration d''acide tranexamique sur les TVE en cas d''HPP, mais de l''administrer le plus tôt possible.', null, 'Non-guidage de l''acide tranexamique par les TVE en HPP', 'Hémorragie du post-partum — Position du GIHP (2/2)'),
  ('MG-ANES-000098-R06', 'En chirurgie cardiaque, les TVE doivent être utilisés en cas d''hémorragie en fin d''intervention et en postopératoire — réalisés essentiellement en fin de circulation extracorporelle, après neutralisation de l''héparine, pour guider la stratégie thérapeutique.', null, 'Usage des TVE en cas d''hémorragie en chirurgie cardiaque', 'Chirurgie cardiaque — Position du GIHP (1/2)'),
  ('MG-ANES-000098-R07', 'En chirurgie cardiaque, les TVE doivent être inclus dans des algorithmes.', null, 'Inclusion des TVE dans des algorithmes en chirurgie cardiaque', 'Chirurgie cardiaque — Position du GIHP (2/2)'),
  ('MG-ANES-000098-R08', 'En transplantation hépatique, les TVE peuvent aider à limiter la transfusion de produits sanguins labiles, probablement au prix d''une augmentation de la transfusion de fibrinogène.', null, 'TVE pour limiter la transfusion de PSL en transplantation hépatique', 'Transplantation hépatique — Position du GIHP (1/2)'),
  ('MG-ANES-000098-R09', 'Les TVE manquant de sensibilité pour le diagnostic d''hyperfibrinolyse en transplantation hépatique, il est proposé de ne pas attendre l''apparition d''un tracé typique d''hyperfibrinolyse pour utiliser des antifibrinolytiques si d''autres signes cliniques sont présents (saignement diffus ou massif).', null, 'Utilisation précoce d''antifibrinolytiques en transplantation hépatique', 'Transplantation hépatique — Position du GIHP (2/2)')
) as v(code, statement, grade, condition_topic, source_section)
where d.source_url = 'https://sfar.org/download/tests-viscoelastiques-2018/?wpdmdl=34421'
on conflict (recommendation_code) do nothing;
