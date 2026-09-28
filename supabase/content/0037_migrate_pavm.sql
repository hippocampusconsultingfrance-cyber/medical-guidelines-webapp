-- Migration : Pneumonies associées aux soins de réanimation (PAS, incluant la PAVM —
-- pneumonie acquise sous ventilation mécanique) — Recommandations Formalisées d'Experts
-- communes SFAR-SRLF, en collaboration avec l'ADARPEF et le GFRUP pour la pédiatrie. 16
-- experts francophones. Anesth Reanim 2017. Source :
-- rfe-sfar-website/build/content_pavm.json (15 recommandations adultes + 2 pédiatriques =
-- 17 recommandations, 3 champs : prévention, diagnostic, traitement).
--
-- MÉTHODOLOGIE : GRADE (force forte 1+/1-, force faible 2+/2-, avis d'experts AE), format
-- PICO. `grade` reproduit tel quel le chip source. `evidence_level` laissé NULL.
--
-- COMPTAGE — TOTAL RECONCILIÉ, RÉPARTITION DIVERGENTE DISCLOSÉE (principe 1.5 du projet) :
-- le résumé officiel de la source annonce « 3 recommandations GRADE 1 et 11 GRADE 2 » (+1
-- avis d'experts = 15 recommandations adultes). Un inventaire direct, vérifié tag par tag
-- sur les 15 recommandations adultes, dénombre 4 recommandations GRADE 1 (R1.1, R3.2, R3.5,
-- R3.7) et 10 GRADE 2 (+1 AE) — le TOTAL (15) concorde avec le résumé officiel, mais PAS la
-- répartition annoncée (3+11 vs 4+10 constaté). Chaque tag individuel est reproduit ici tel
-- qu'imprimé à côté de sa recommandation dans le tableau source, sans chercher à faire
-- correspondre le total par grade au résumé erroné. Comptage global vérifié sur les 17
-- lignes migrées (15 adultes + 2 pédiatriques) : 1+ ×2, 1- ×2 (4 GRADE1), 2+ ×9, 2- ×3
-- (12 GRADE2), AE ×1 = 17.
--
-- POPULATIONS SPÉCIFIQUES : la source dit avoir « analysé » 4 populations spécifiques
-- (BPCO, neutropénie, postopératoire, pédiatrie), mais seules la BPCO (R1.5) et la
-- pédiatrie (R1.1 P, R2.2 P — `population = 'Pédiatrie'` ci-dessous) ont donné lieu à des
-- recommandations numérotées propres ; neutropénie et postopératoire n'ont informé que
-- l'argumentaire d'autres recommandations, sans recommandation dédiée — rien à migrer pour
-- ces deux dernières populations, cohérent avec le contenu réel de la source.
--
-- PÉRIMÈTRE — volontairement pas migrés (avis d'experts au niveau du protocole global, PAS
-- une cotation individuelle ligne par ligne, cohérent avec le principe déjà appliqué
-- ailleurs dans ce corpus) : les 4 "protocoles de soins" (avis d'experts, à titre
-- indicatif, d'après le résumé officiel de la source elle-même) — Protocole n°1 (Figure 1,
-- prévention multimodale, tableau "Étape/Contenu") ; Protocole n°2 (décontamination
-- digestive sélective, recette) et son Tableau III associé (préparation officinale,
-- posologique — avec une incohérence interne à la source elle-même disclosée par le
-- contenu construit : "tobramycine" dans le texte du protocole vs "gentamicine" dans la
-- recette du Tableau III) ; Protocole n°3 (Figure 2, procédure diagnostique) ; Protocole
-- n°4 (Tableau IV, schémas thérapeutiques par situation clinique — référence posologique).
-- Également volontairement pas migré : le Tableau I (critères de définition d'une
-- pneumonie associée aux soins) — définition de référence, pas une recommandation graduée.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFAR et SRLF (toutes deux dans le seed Annexe B) liées en document_societies ; ADARPEF
--    et GFRUP (collaborateurs pédiatriques), hors seed.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Pneumonies associées aux soins de réanimation',
  'RFE', 'fr', '2017-09-22',
  'https://sfar.org/pneumonies-associees-aux-soins-de-reanimation/',
  'https://sfar.org/wp-content/uploads/2017/09/Pneumonies-associees-au-soins-de-reanimation-ANREA.pdf',
  'GRADE® : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ probablement recommandé / 2- probablement non recommandé) ; avis d''experts (AE). Résumé officiel "3 GRADE1 + 11 GRADE2" sur les 15 recommandations adultes ; comptage direct tag par tag trouve 4 GRADE1 + 10 GRADE2 (+1 AE) — le total (15) concorde, pas la répartition annoncée. Divergence disclosée, non résolue.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/pneumonies-associees-aux-soins-de-reanimation/'
  and s.acronym in ('SFAR', 'SRLF') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/pneumonies-associees-aux-soins-de-reanimation/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'pneumologie', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.source_section,
  'https://sfar.org/pneumonies-associees-aux-soins-de-reanimation/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000037-R01', 'Il faut utiliser une approche standardisée multimodale de prévention des pneumonies associées aux soins pour diminuer la morbidité des patients hospitalisés en réanimation.', '1+', null, 'Prévention (Réf. R1.1)'),
  ('MG-ANES-000037-R02', '(Pédiatrique) Il faut probablement utiliser une approche standardisée multimodale visant la prévention des pneumonies associées aux soins pour diminuer la morbidité des patients hospitalisés en réanimation pédiatrique.', '2+', 'Pédiatrie', 'Prévention (Réf. R1.1 P)'),
  ('MG-ANES-000037-R03', 'Dans les unités où la prévalence des bactéries multirésistantes est faible (<20 %), il faut probablement appliquer une décontamination digestive sélective associant un topique antiseptique par voie entérale et une antibioprophylaxie par voie systémique pour une durée inférieure à 5 jours pour diminuer la mortalité.', '2+', null, 'Prévention (Réf. R1.2)'),
  ('MG-ANES-000037-R04', 'Dans le cadre d''une prévention multimodale, il faut probablement associer certaines des méthodes suivantes : favoriser le recours à la VNI pour éviter l''intubation (notamment en postopératoire de chirurgie digestive et chez le BPCO) ; limiter les doses et durées des sédatifs/analgésiques (échelles de sédation/douleur/confort, arrêts quotidiens) ; initier précocement une nutrition entérale ; contrôler régulièrement la pression du ballonnet ; réaliser une aspiration sous-glottique (toutes les 6-8h) ; préférer la voie orotrachéale pour l''intubation.', '2+', null, 'Prévention (Réf. R1.3)'),
  ('MG-ANES-000037-R05', 'Il ne faut probablement pas utiliser les méthodes suivantes : trachéotomie précoce systématique (hors indication spécifique) ; prophylaxie anti-ulcéreuse hors indication ; nutrition entérale post-pylorique hors indication ; probiotiques/synbiotiques ; changement précoce systématique des filtres humidificateurs ; systèmes clos d''aspiration endotrachéale ; sonde d''intubation imprégnée d''antiseptique ou ballonnet « optimisé » ; décontamination oropharyngée à la polyvidone iodée ; antibioprophylaxie par aérosols ; décontamination cutanée quotidienne antiseptique.', '2-', null, 'Prévention (Réf. R1.4)'),
  ('MG-ANES-000037-R06', 'Au cours du sevrage des patients BPCO, il faut probablement utiliser la VNI pour réduire la durée de ventilation mécanique invasive, l''incidence des pneumonies associées aux soins et la morbi-mortalité.', '2+', null, 'Prévention (Réf. R1.5)'),
  ('MG-ANES-000037-R07', 'Il ne faut probablement pas utiliser les scores cliniques (CPIS, CPIS modifié) pour le diagnostic des pneumonies associées aux soins.', '2-', null, 'Diagnostic (Réf. R2.1)'),
  ('MG-ANES-000037-R08', 'Il faut probablement réaliser des prélèvements microbiologiques des voies aériennes, quel que soit le type, avant toute introduction ou modification de l''antibiothérapie.', '2+', null, 'Diagnostic (Réf. R2.2)'),
  ('MG-ANES-000037-R09', '(Pédiatrique) Il faut probablement réaliser des prélèvements microbiologiques des voies aériennes, quel que soit le type, avant toute introduction ou modification de l''antibiothérapie.', '2+', 'Pédiatrie', 'Diagnostic (Réf. R2.2 P)'),
  ('MG-ANES-000037-R10', 'Il ne faut probablement pas mesurer les concentrations plasmatiques de procalcitonine ou alvéolaires de TREM-1 soluble pour diagnostiquer une pneumonie associée aux soins.', '2-', null, 'Diagnostic (Réf. R2.3)'),
  ('MG-ANES-000037-R11', 'Il faut probablement réaliser les prélèvements et initier le traitement antibiotique en tenant compte des facteurs de risque de bactéries résistantes immédiatement en cas de suspicion de pneumonie avec signes de gravité hémodynamique (choc), respiratoire (SDRA) ou de terrain fragile (immunodépression).', '2+', null, 'Traitement (Réf. R3.1)'),
  ('MG-ANES-000037-R12', 'Il faut traiter par monothérapie en probabiliste les pneumonies associées aux soins du patient immunocompétent sous ventilation mécanique, en dehors de la présence de facteurs de risque de bactéries multirésistantes, de bacilles à Gram négatif non fermentants, et/ou de facteurs de risque élevé de mortalité (choc septique, défaillances d''organes).', '1+', null, 'Traitement (Réf. R3.2)'),
  ('MG-ANES-000037-R13', 'Les experts suggèrent de ne pas utiliser de manière probabiliste et systématique un antibiotique actif contre S. aureus résistant à la méticilline (SARM) dans le traitement des pneumonies associées aux soins.', 'AE', null, 'Traitement (Réf. R3.3)'),
  ('MG-ANES-000037-R14', 'Il faut probablement réduire le spectre et privilégier une monothérapie pour l''antibiothérapie des pneumonies associées aux soins après documentation, y compris pour les bacilles à Gram négatif non fermentants.', '2+', null, 'Traitement (Réf. R3.4)'),
  ('MG-ANES-000037-R15', 'Il ne faut pas prolonger plus de 7 jours la durée du traitement antibiotique pour les pneumonies associées aux soins, y compris pour les pneumonies à bacille à Gram négatif non fermentant, en dehors de certaines situations (immunodépression, empyème, pneumonie nécrosante ou abcédée).', '1-', null, 'Traitement (Réf. R3.5)'),
  ('MG-ANES-000037-R16', 'Dans le cadre des pneumonies documentées à bacilles à Gram négatif multirésistants, sensibles à la colimycine et/ou aux aminosides et lorsque aucun autre antibiotique n''est efficace, il faut probablement administrer la colimycine (colistiméthate sodique) et/ou un aminoside par voie nébulisée.', '2+', null, 'Traitement (Réf. R3.6)'),
  ('MG-ANES-000037-R17', 'Il ne faut pas administrer des statines comme traitement adjuvant des pneumonies associées aux soins.', '1-', null, 'Traitement (Réf. R3.7)')
) as v(code, statement, grade, population, source_section)
where d.source_url = 'https://sfar.org/pneumonies-associees-aux-soins-de-reanimation/'
on conflict (recommendation_code) do nothing;
