-- Migration : Prise en charge du traumatisme abdominal grave de l'adulte :
-- les 48 premières heures — Recommandations Formalisées d'Experts, groupe
-- de travail SFAR/SFMU avec AFC, AFU, SFRI, École du Val de Grâce. Texte
-- validé par le CA SFAR (20/06/2019) et le CA SFMU (16/09/2019). Source :
-- rfe-sfar-website/build/content_traumatisme_abdominal.json (15
-- recommandations réparties en 3 champs : diagnostic, thérapeutique,
-- surveillance).
--
-- CHAMP EXPLICITEMENT EXCLU PAR LA SOURCE ELLE-MÊME : patients pédiatriques
-- et femmes enceintes exclus du champ de cette RFE — disclosure de portée,
-- pas une restriction de mon fait ; `population` laissée NULL sur toutes
-- les lignes (aucun sous-groupe démographique distinct au sein du champ
-- couvert).
--
-- MÉTHODOLOGIE : GRADE (force forte 1+/1- ou faible 2+/2- via GRADE Grid ;
-- avis d'experts AE lorsque la littérature ne permettait pas de graduer).
-- `grade` reproduit tel quel le chip source. `evidence_level` laissé NULL.
--
-- COMPTAGE — TOTAL RECONCILIÉ, RÉPARTITION DIVERGENTE DISCLOSÉE (principe
-- 1.5 du projet) : le résumé officiel de la source annonce « cinq [recos]
-- ont un niveau de preuve élevé (Grade 1+/-), six ont un niveau de preuve
-- faible (Grade 2+/-) et quatre sont des avis d'experts » (5+6+4=15). Un
-- inventaire direct, vérifié tag par tag sur les 15 recommandations,
-- dénombre 4 GRADE1 (R1:1-, R2.2:1+, R2.3:1-, R3.1:1+) et 7 GRADE2 (R2.1,
-- R3.2, R5, R6.1, R7.1, R7.2, R8.1, tous 2+, aucun 2-) et 4 AE (R4, R6.2,
-- R8.2, R8.3) — le TOTAL (15) et le compte d'AE (4) concordent avec le
-- résumé officiel, mais PAS la répartition GRADE1/GRADE2 annoncée (5+6 vs
-- 4+7 constaté). Chaque tag individuel est reproduit ici tel qu'imprimé à
-- côté de sa recommandation dans le tableau source, sans chercher à faire
-- correspondre le total par grade au résumé.
--
-- PÉRIMÈTRE — volontairement pas migrés (avis d'experts au niveau du
-- protocole/algorithme global, PAS une cotation individuelle ligne par
-- ligne, cohérent avec le principe déjà appliqué ailleurs dans ce corpus) :
-- la Fiche réflexe préhospitalière (Figure 1, transcrite depuis une
-- affiche-poster pure image de la page 30 du document source) et
-- l'Algorithme de prise en charge hospitalière (Figure 2, transcrit depuis
-- un algorithme-poster pure image de la page 31), tous deux sans chip de
-- grade individuel par étape.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFAR et SFMU (toutes deux dans le seed Annexe B) liées en
--    document_societies ; AFC, AFU, SFRI et École du Val de Grâce
--    (co-auteurs) hors seed, non liés.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge du traumatisme abdominal grave de l''adulte : les 48 premières heures',
  'RFE', 'fr', '2019-09-21',
  'https://sfar.org/prise-en-charge-du-traumatisme-abdominal-grave-de-ladulte-les-48-premieres-heures/',
  'https://sfar.org/download/rfe-urgence-trauma-abdominal/?wpdmdl=24463',
  'GRADE® : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ probablement recommandé / 2- probablement non recommandé) ; avis d''experts (AE). Résumé officiel "5 GRADE1 + 6 GRADE2 + 4 AE" sur les 15 recommandations ; comptage direct tag par tag trouve 4 GRADE1 + 7 GRADE2 + 4 AE — le total (15) et le compte d''AE concordent, pas la répartition GRADE1/GRADE2 annoncée. Divergence disclosée, non résolue.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-du-traumatisme-abdominal-grave-de-ladulte-les-48-premieres-heures/'
  and s.acronym in ('SFAR', 'SFMU') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-du-traumatisme-abdominal-grave-de-ladulte-les-48-premieres-heures/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'medecine_d_urgence', 'chirurgie_digestive_et_viscerale', 'urologie', 'radiologie_et_imagerie_medicale')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/prise-en-charge-du-traumatisme-abdominal-grave-de-ladulte-les-48-premieres-heures/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000050-R01', 'Chez les patients traumatisés graves, il n''est pas recommandé de se limiter à l''examen clinique pour affirmer ou infirmer la présence d''une lésion abdominale.', '1-', 'Champ 1 — Stratégie diagnostique : examen clinique & FAST (Réf. R1)'),
  ('MG-ANES-000050-R02', 'En cas de suspicion de traumatisme abdominal, il est probablement recommandé d''utiliser l''échographie de type FAST en préhospitalier pour diagnostiquer la présence d''un épanchement intra-péritonéal.', '2+', 'Champ 1 — Stratégie diagnostique : examen clinique & FAST (Réf. R2.1)'),
  ('MG-ANES-000050-R03', 'En cas de suspicion de traumatisme abdominal, il est recommandé d''utiliser l''échographie de type FAST en intra-hospitalier pour : (i) affirmer la présence d''un épanchement intra-péritonéal lorsqu''elle est positive ; (ii) éliminer un hémopéritoine supérieur à 500 mL lorsqu''elle est négative.', '1+', 'Champ 1 — Stratégie diagnostique : examen clinique & FAST (Réf. R2.2)'),
  ('MG-ANES-000050-R04', 'En cas de suspicion de traumatisme abdominal, il n''est pas recommandé d''utiliser l''échographie de type FAST en pré- ou intra-hospitalier pour (i) éliminer une lésion d''organe ; (ii) affirmer ou éliminer la présence d''un épanchement rétropéritonéal.', '1-', 'Champ 1 — Stratégie diagnostique : examen clinique & FAST (Réf. R2.3)'),
  ('MG-ANES-000050-R05', 'En cas de suspicion de traumatisme abdominal, il est recommandé de réaliser un scanner thoraco-abdomino-pelvien avec injection de produit de contraste pour faire le diagnostic des lésions abdominales traumatiques.', '1+', 'Champ 1 — Stratégie diagnostique : scanner (Réf. R3.1)'),
  ('MG-ANES-000050-R06', 'En cas de suspicion de traumatisme abdominal grave, il est probablement recommandé de réaliser un scanner corps entier avec injection de produit de contraste pour réduire la morbi-mortalité.', '2+', 'Champ 1 — Stratégie diagnostique : scanner (Réf. R3.2)'),
  ('MG-ANES-000050-R07', 'En cas de traumatisme abdominal associé à un épanchement intra-abdominal abondant, les experts suggèrent de réaliser une laparotomie sans délai lorsque l''état hémodynamique après réanimation initiale du patient n''est pas compatible avec la réalisation d''un scanner injecté.', 'AE', 'Champ 2 — Stratégie thérapeutique : laparotomie & damage control (Réf. R4)'),
  ('MG-ANES-000050-R08', 'Lorsqu''une laparotomie est réalisée après un traumatisme abdominal fermé ou ouvert chez les patients en état de choc, il est probablement recommandé d''effectuer une stratégie de type damage control afin de diminuer la mortalité.', '2+', 'Champ 2 — Stratégie thérapeutique : laparotomie & damage control (Réf. R5)'),
  ('MG-ANES-000050-R09', 'En cas de doute sur le caractère pénétrant du traumatisme abdominal, il est probablement recommandé de réaliser, après l''imagerie initiale, une cœlioscopie diagnostique afin de rechercher une effraction péritonéale en l''absence de signe de péritonite ou d''éviscération.', '2+', 'Champ 2 — Stratégie thérapeutique : cœlioscopie, TNO & embolisation (Réf. R6.1)'),
  ('MG-ANES-000050-R10', 'En cas de traumatisme abdominal fermé grave sans état de choc, les experts suggèrent d''envisager une voie cœlioscopique diagnostique et/ou thérapeutique afin de diminuer la morbidité, dans les cas suivants : (i) à la phase aiguë, lorsque l''imagerie fait suspecter une lésion diaphragmatique et/ou d''organe creux ; (ii) à distance, en complément du traitement non-opératoire (TNO).', 'AE', 'Champ 2 — Stratégie thérapeutique : cœlioscopie, TNO & embolisation (Réf. R6.2)'),
  ('MG-ANES-000050-R11', 'En l''absence d''hémorragie intra-abdominale active et/ou de perforation digestive d''origine traumatique, il est probablement recommandé de réaliser un traitement non-opératoire afin de réduire la morbi-mortalité.', '2+', 'Champ 2 — Stratégie thérapeutique : cœlioscopie, TNO & embolisation (Réf. R7.1)'),
  ('MG-ANES-000050-R12', 'En présence d''une hémorragie intra-abdominale active diagnostiquée, il est probablement recommandé d''envisager, après concertation multidisciplinaire, une angio-embolisation hémostatique en urgence afin de réduire la morbi-mortalité.', '2+', 'Champ 2 — Stratégie thérapeutique : cœlioscopie, TNO & embolisation (Réf. R7.2)'),
  ('MG-ANES-000050-R13', 'Chez les patients à risque d''hyperpression abdominale après un traumatisme abdominal grave, il est probablement recommandé de surveiller la pression intra-abdominale en unité de soins critiques afin de dépister précocement un syndrome du compartiment abdominal.', '2+', 'Champ 3 — Modalités précoces de surveillance (Réf. R8.1)'),
  ('MG-ANES-000050-R14', 'En cas de lésion abdominale grave (AIS ≥ 3) traitée par TNO, les experts suggèrent une hospitalisation pour surveillance clinico-biologique pendant une durée minimale de 3 à 5 jours, dans une unité de soins critiques au moins les 24 premières heures, puis dans un service de chirurgie. La possibilité d''accès à un plateau médico-technique complet est nécessaire.', 'AE', 'Champ 3 — Modalités précoces de surveillance (Réf. R8.2)'),
  ('MG-ANES-000050-R15', 'En cas de lésion abdominale grave (AIS ≥ 3) traitée par TNO, les experts suggèrent de réaliser un scanner abdomino-pelvien injecté de contrôle en cas de lésion abdominale à risque et/ou lorsqu''une complication infectieuse ou hémorragique est suspectée avant la sortie d''hospitalisation.', 'AE', 'Champ 3 — Modalités précoces de surveillance (Réf. R8.3)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-du-traumatisme-abdominal-grave-de-ladulte-les-48-premieres-heures/'
on conflict (recommendation_code) do nothing;
