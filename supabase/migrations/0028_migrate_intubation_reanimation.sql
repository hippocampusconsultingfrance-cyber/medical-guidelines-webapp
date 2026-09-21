-- Migration : Intubation et extubation du patient de réanimation — Recommandations
-- Formalisées d'Experts (RFE) communes SFAR-SRLF, avec SFMU, GFRUP, ADARPEF, SKR.
-- Anesth Reanim. 2018;4:523-547. Champ : patient ADULTE de réanimation (hors prise en
-- charge pré-hospitalière, explicitement exclue par la source). Source :
-- rfe-sfar-website/build/content_intubation_reanimation.json (32 recommandations adultes).
--
-- MÉTHODOLOGIE : GRADE classique (1+/1-/2+/2-, avis d'experts AE), format PICO. `grade`
-- reproduit tel quel le chip GRADE. `evidence_level` laissé NULL.
--
-- COMPTAGE — RECONCILIÉ EXACTEMENT : la source annonce elle-même "32 recommandations
-- [adultes] ; 12 de niveau de preuve élevé (Grade 1+/-), 19 de niveau de preuve faible
-- (Grade 2+/-), 1 avis d'experts". Comptage direct des 32 lignes migrées ci-dessous :
-- 1+ ×12, 2+ ×18 + 2- ×1 = 19 Grade 2, AE ×1 (R4.2) = reconciliation exacte 12+19+1=32.
--
-- DISCLOSURE PONCTUELLE : R7.5 est la SEULE recommandation adulte de cette RFE à accord
-- qualifié « FAIBLE » (et non « FORT ») dans le texte source lui-même — cohérent avec le
-- résumé officiel de la source, « accord fort pour 31/32 (97 %) » des recommandations
-- adultes — notée dans son propre `source_section` plutôt qu'un champ `evidence_level`
-- séparé (non imprimé systématiquement ligne à ligne par la source).
--
-- PÉRIMÈTRE — volontairement pas migrés :
-- 1. Le VOLET PÉDIATRIQUE de cette même RFE : la source contient également "15
--    recommandations pédiatriques parallèles (5 Grade1, 9 Grade2, 1 avis d'experts)" —
--    explicitement PAS reproduites dans le contenu construit source
--    (`content_intubation_reanimation.json`), qui se limite lui-même au volet adulte ("cette
--    fiche, centrée sur l'adulte — se référer au texte intégral pour le volet pédiatrique").
--    Rien à migrer ici pour le volet pédiatrique : il est absent de la source de cette
--    migration, pas exclu par choix éditorial de ce fichier de migration.
-- 2. Tableau I — Complications de l'intubation (sévères/modérées) et Tableau II — Score
--    MACOCHA (grille de risque d'intubation difficile, 0-12 points) — référencés
--    respectivement par R1.x et par l'algorithme IOT, mais ce sont des tableaux de
--    référence/classification établis, pas des recommandations individuellement graduées.
-- 3. Les 2 algorithmes de synthèse (Algorithme IOT en réanimation — source elle-même notée
--    "avis d'experts, ACCORD FAIBLE" ; Algorithme d'extubation en réanimation — source notée
--    "avis d'experts, ACCORD FORT") — "transcrits en tableau de décision, vérifiés par rendu
--    visuel" d'après le contenu construit, synthèses opérationnelles des recommandations
--    R1-R7 déjà graduées individuellement ci-dessus, sans chip de cotation individuelle par
--    étape — cohérent avec le principe déjà appliqué ailleurs dans ce corpus (ex.
--    intubation_difficile_adulte/0027).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Sociétés co-organisatrices : SFAR et SRLF (toutes deux dans le seed Annexe B), avec
--    SFMU (également dans le seed), GFRUP, ADARPEF et SKR (aucune des trois dans le seed) —
--    seules SFAR, SRLF et SFMU liées en document_societies.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Intubation et extubation du patient de réanimation',
  'RFE', 'fr', '2016-09-24',
  'https://sfar.org/intubation-et-extubation-du-patient-de-reanimation/',
  'https://sfar.org/wp-content/uploads/2016/09/Intubation-et-extubation-du-patient-en-reanimation-ANREA.pdf',
  'GRADE® : force forte (1+ il faut faire) ou faible (2+ il faut probablement / 2- il ne faut probablement pas) ; avis d''experts (AE). Tags « (Grade X+/-) Accord FORT/FAIBLE » ou « Avis d''experts » imprimés littéralement après chaque recommandation. Accord fort pour 31/32 (97 %) des recommandations adultes ; seule exception R7.5 (Accord faible). Document couvre aussi un volet pédiatrique parallèle (15 recommandations) non repris par cette fiche, centrée sur l''adulte.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/intubation-et-extubation-du-patient-de-reanimation/'
  and s.acronym in ('SFAR', 'SRLF', 'SFMU') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/intubation-et-extubation-du-patient-de-reanimation/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'medecine_d_urgence')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/intubation-et-extubation-du-patient-de-reanimation/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000028-R01', 'Il faut considérer tous les patients de réanimation à risque d''intubation compliquée.', '1+', 'Champ 1 — Intubation compliquée en réanimation (Réf. R1.1)'),
  ('MG-ANES-000028-R02', 'Afin d''en réduire l''incidence, il faut que les complications respiratoires et hémodynamiques de l''intubation soient anticipées et prévenues grâce à une préparation soigneuse de la procédure, intégrant le maintien de l''oxygénation et de l''hémodynamique systémiques tout au long de la procédure.', '1+', 'Champ 1 — Intubation compliquée en réanimation (Réf. R1.2)'),
  ('MG-ANES-000028-R03', 'Il faut différencier les facteurs prédictifs d''intubation compliquée des facteurs prédictifs d''intubation difficile.', '1+', 'Champ 1 — Intubation compliquée en réanimation (Réf. R1.3)'),
  ('MG-ANES-000028-R04', 'Il faut mettre en œuvre un contrôle capnographique de l''intubation en réanimation pour confirmer la bonne position de la sonde d''intubation, du dispositif supra-glottique ou de l''abord trachéal direct.', '1+', 'Champ 2 — Matériel de l''intubation (Réf. R2.1)'),
  ('MG-ANES-000028-R05', 'Il faut disposer d''un chariot d''intubation difficile et d''un bronchoscope (usuel ou à usage unique) en réanimation afin de pouvoir faire face immédiatement aux situations d''intubation difficile.', '1+', 'Champ 2 — Matériel de l''intubation (Réf. R2.2)'),
  ('MG-ANES-000028-R06', 'Il faut employer des lames métalliques pour les laryngoscopies directes en réanimation afin d''en améliorer les chances de succès.', '1+', 'Champ 2 — Matériel de l''intubation (Réf. R2.3)'),
  ('MG-ANES-000028-R07', 'Pour limiter les échecs d''intubation, il faut probablement utiliser les vidéolaryngoscopes (VL) pour l''intubation en réanimation, soit d''emblée soit après échec de la laryngoscopie directe.', '2+', 'Champ 2 — Matériel de l''intubation (Réf. R2.4)'),
  ('MG-ANES-000028-R08', 'Il faut utiliser les dispositifs supra-glottiques (DSG) dans la gestion des intubations difficiles en réanimation, pour oxygéner le patient puis favoriser l''intubation sous contrôle bronchoscopique.', '1+', 'Champ 2 — Matériel de l''intubation (Réf. R2.5)'),
  ('MG-ANES-000028-R09', 'Les connaissances théoriques et pratiques en matière d''intubation doivent être acquises et régulièrement entretenues.', '1+', 'Champ 2 — Matériel de l''intubation (Réf. R2.6)'),
  ('MG-ANES-000028-R10', 'Il faut probablement choisir un hypnotique (étomidate, kétamine, propofol) permettant l''induction en séquence rapide (ISR) en fonction du terrain et de la situation clinique du patient.', '2+', 'Champ 3 — Agents d''induction (Réf. R3.1)'),
  ('MG-ANES-000028-R11', 'Chez le patient de réanimation, il faut probablement utiliser la succinylcholine comme curare de première intention lors de l''ISR afin de réduire la durée de la procédure et le risque d''inhalation.', '2+', 'Champ 3 — Agents d''induction (Réf. R3.2)'),
  ('MG-ANES-000028-R12', 'Il faut utiliser le rocuronium à une dose supérieure à 0,9 mg/kg [1,0-1,2 mg/kg] en cas de contre-indication à la succinylcholine et permettre un accès rapide au sugammadex en cas d''utilisation de celui-ci.', '1+', 'Champ 3 — Agents d''induction (Réf. R3.3)'),
  ('MG-ANES-000028-R13', 'Il faut probablement utiliser la VNI pour la préoxygénation des patients hypoxémiques en réanimation.', '2+', 'Champ 4 — Protocoles et bundles de l''intubation (Réf. R4.1)'),
  ('MG-ANES-000028-R14', 'Il est possible d''utiliser l''oxygénothérapie nasale haut débit (ONHD) pour la préoxygénation en réanimation, notamment pour les patients non sévèrement hypoxémiques.', 'AE', 'Champ 4 — Protocoles et bundles de l''intubation (Réf. R4.2)'),
  ('MG-ANES-000028-R15', 'Il faut probablement utiliser un protocole d''intubation incluant un versant ventilatoire au cours de l''intubation en réanimation pour diminuer les complications respiratoires.', '2+', 'Champ 4 — Protocoles et bundles de l''intubation (Réf. R4.3)'),
  ('MG-ANES-000028-R16', 'Il faut probablement utiliser une manœuvre de recrutement post-intubation chez les patients de réanimation hypoxémiques en l''intégrant dans un protocole ventilatoire.', '2+', 'Champ 4 — Protocoles et bundles de l''intubation (Réf. R4.4)'),
  ('MG-ANES-000028-R17', 'Il faut probablement appliquer une PEEP d''au moins 5 cm H2O après intubation des patients hypoxémiques.', '2+', 'Champ 4 — Protocoles et bundles de l''intubation (Réf. R4.5)'),
  ('MG-ANES-000028-R18', 'Il faut probablement utiliser un protocole hémodynamique, définissant les modalités du remplissage vasculaire et de la mise en place précoce de catécholamines pour diminuer les complications hémodynamiques lors de l''intubation des patients en réanimation.', '2+', 'Champ 4 — Protocoles et bundles de l''intubation (Réf. R4.6)'),
  ('MG-ANES-000028-R19', 'Il faut réaliser une épreuve de sevrage en VS avant toute extubation chez le patient de réanimation ventilé depuis plus de 48 h afin de réduire le risque d''échec d''extubation.', '1+', 'Champ 5 — Pré-requis à l''extubation (Réf. R5.1)'),
  ('MG-ANES-000028-R20', 'L''épreuve de sevrage n''étant pas suffisante pour dépister tous les patients à risque d''échec d''extubation, il faut probablement rechercher les causes et facteurs de risque plus spécifiques d''échec incluant l''inefficacité de la toux, l''abondance des sécrétions bronchiques, l''inefficacité de la déglutition, et les troubles de la conscience.', '2+', 'Champ 5 — Pré-requis à l''extubation (Réf. R5.2)'),
  ('MG-ANES-000028-R21', 'Il faut probablement effectuer un test de fuite avant l''extubation pour prédire la survenue d''un œdème laryngé.', '2+', 'Champ 6 — Échecs de l''extubation (œdème laryngé) (Réf. R6.1)'),
  ('MG-ANES-000028-R22', 'Il faut réaliser le test de fuite chez les patients de réanimation ayant au moins un facteur de risque de dyspnée laryngée afin de réduire les échecs d''extubation en rapport avec l''œdème laryngé.', '1+', 'Champ 6 — Échecs de l''extubation (œdème laryngé) (Réf. R6.2)'),
  ('MG-ANES-000028-R23', 'Il faut probablement mettre en œuvre des mesures limitant les lésions laryngées au cours de la ventilation mécanique.', '2+', 'Champ 6 — Échecs de l''extubation (œdème laryngé) (Réf. R6.3)'),
  ('MG-ANES-000028-R24', 'Si le volume de fuite est faible ou nul, il faut probablement prescrire une corticothérapie pour prévenir les échecs d''extubation en rapport avec l''œdème laryngé.', '2+', 'Champ 6 — Échecs de l''extubation (œdème laryngé) (Réf. R6.4)'),
  ('MG-ANES-000028-R25', 'Lorsqu''elle est décidée, la corticothérapie doit être débutée au moins 6 heures avant l''extubation pour être efficace.', '1+', 'Champ 6 — Échecs de l''extubation (œdème laryngé) (Réf. R6.5)'),
  ('MG-ANES-000028-R26', 'En préventif, il faut probablement utiliser l''oxygénothérapie nasale à haut débit en postopératoire de chirurgie cardiothoracique.', '2+', 'Champ 7 — Gestion pratique de l''extubation (Réf. R7.1)'),
  ('MG-ANES-000028-R27', 'En préventif, il faut probablement utiliser l''oxygénothérapie nasale à haut débit après extubation programmée en réanimation chez les patients hypoxémiques ou à risque faible de réintubation.', '2+', 'Champ 7 — Gestion pratique de l''extubation (Réf. R7.2)'),
  ('MG-ANES-000028-R28', 'En préventif, il faut probablement utiliser la VNI prophylactique après extubation programmée en réanimation chez les patients à haut risque de réintubation, notamment chez les patients hypercapniques.', '2+', 'Champ 7 — Gestion pratique de l''extubation (Réf. R7.3)'),
  ('MG-ANES-000028-R29', 'En curatif, il faut probablement utiliser la VNI curative en cas d''insuffisance respiratoire aiguë postopératoire, notamment après chirurgie abdominale ou résection pulmonaire.', '2+', 'Champ 7 — Gestion pratique de l''extubation (Réf. R7.4)'),
  ('MG-ANES-000028-R30', 'En curatif, il ne faut probablement pas utiliser la VNI curative en cas d''insuffisance respiratoire aiguë survenant après extubation programmée en réanimation, excepté chez les patients BPCO ou en cas d''OAP évident.', '2-', 'Champ 7 — Gestion pratique de l''extubation (Réf. R7.5) [Accord Faible — seule exception disclosée par la source parmi les 32 recommandations adultes, malgré le grade GRADE 2-]'),
  ('MG-ANES-000028-R31', 'Il faut probablement faire intervenir un kinésithérapeute avant et après l''extubation chez les patients ventilés plus de 48 h afin de diminuer la durée de sevrage et limiter le risque de réintubation.', '2+', 'Champ 7 — Gestion pratique de l''extubation (Réf. R7.6)'),
  ('MG-ANES-000028-R32', 'Il faut probablement faire intervenir un kinésithérapeute au cours du geste de l''extubation, afin de limiter les complications immédiates liées au sur-encombrement chez les patients à risque.', '2+', 'Champ 7 — Gestion pratique de l''extubation (Réf. R7.7)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/intubation-et-extubation-du-patient-de-reanimation/'
on conflict (recommendation_code) do nothing;
