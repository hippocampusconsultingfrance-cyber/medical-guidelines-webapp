-- Migration : Gestion et prévention de l'anémie (hors hémorragie aiguë) chez le patient
-- adulte de soins critiques (SFAR/SRLF, avec SFTS/SFVTT, RFE 2019)
-- Source : rfe-sfar-website/build/content_anemie.json (10 recommandations atomiques,
-- méthodologie GRADE classique — chip 1+/1-/2+/2-/AE, comme la légende du document).
--
-- Grade : reproduit tel quel depuis le chip source (1+/1-/2+/2-/AE). evidence_level laissé
-- NULL : ce document n'utilise pas de système de niveau de preuve distinct du grade GRADE
-- (pas de NP1-4 séparé, contrairement à allergie_prevention/0006).
--
-- DIVERGENCE SOURCE-INTERNE (disclosure, déjà faite par le contenu construit — reproduite
-- ici sans ré-argumentation) : le résumé de la source annonce "3 grade élevé, 4 grade
-- faible et 2 avis d'experts" (somme = 9), alors qu'un comptage direct des 10 grades
-- littéraux imprimés à côté de chaque recommandation donne 3 Grade 1 (R2.1, R2.2, R2.5 —
-- NB R2.5 est "1-", donc "élevé" au sens fort/faible de force, pas au sens favorable) +
-- 4 Grade 2 (R2.3, R2.4, R3.1, R3.3) + 3 avis d'experts (R1.1, R2.6, R3.2) = 10, le total
-- correct annoncé par ailleurs dans le document ("10 recommandations formalisées"). Les
-- deux comptages sont contradictoires ; celui qui reconcilie le total de 10 (3 Grade 1 /
-- 4 Grade 2 / 3 AE) est celui utilisé implicitement par les grades ci-dessous, reproduits
-- tels quels depuis chaque chip individuel — pas une réconciliation arbitraire de ma part.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. R3.4 ("Absence de recommandation" — administration de vitamines, numérotée par la RFE
--    elle-même) N'EST PAS migrée comme ligne recommendations : la source déclare
--    explicitement qu'aucune recommandation n'a pu être formulée sur ce point (pas de
--    statement ni de grade réels à porter) — même traitement que le panneau "Absence de
--    proposition" de aap_programmee (0005). Disclosure volontaire ici pour ne pas donner
--    l'impression d'un oubli : R3.4 a été lu et écarté à dessein.
-- 2. La Figure 1 (cibles d'Hb par contexte clinique, redessinée en tableau depuis un
--    graphique en bandes dégradées) n'est PAS remigrée comme recommandations
--    supplémentaires pour "réanimation générale"/"traumatisme"/"sepsis"/"lésions
--    cérébrales" : le contenu construit précise lui-même que ces fourchettes sont
--    "volontairement approximatives... pas des seuils exacts" (sauf R2.1-R2.2, déjà
--    migrées avec leurs seuils précis) — les migrer comme recommandations gradées
--    fabriquerait une précision numérique que la source elle-même dit ne pas avoir.
-- 3. `library_final.json` (direct_pdf_url, exact_date 2019-09-21) et le contenu construit
--    (validation CA SFAR 20/06/2019, CA SRLF 26/06/2019) donnent des dates différentes —
--    pas une contradiction (validation par les CA vs date de publication/mise en ligne,
--    deux jalons distincts), mais disclosure quand même : publication_date ci-dessous
--    utilise la date de library_final.json (la plus proche d'une date de publication), les
--    dates de validation CA restent dans ce commentaire plutôt que dans un champ dédié
--    (schema_v2.sql n'a pas de colonne "date de validation par les conseils
--    d'administration" distincte de publication_date/revision_date).
-- 4. SFTS (Société Française de Transfusion Sanguine) et SFVTT (Société Française de
--    Vigilance et de Thérapeutique Transfusionnelle), co-autrices de la RFE, ne figurent
--    pas dans le seed Annexe B : seules SFAR et SRLF sont liées en document_societies
--    ci-dessous (les deux figurent dans le seed, contrairement aux cas précédents où un
--    seul co-signataire y figurait).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Gestion et prévention de l''anémie (hors hémorragie aiguë) chez le patient adulte de soins critiques',
  'RFE', 'fr', '2019-09-21',
  'https://sfar.org/download/rfe-gestion-anemie-reanimation/?wpdmdl=24462',
  'https://sfar.org/download/rfe-gestion-anemie-reanimation/?wpdmdl=24462',
  'GRADE : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ proposé / 2- proposé de ne pas faire) ; avis d''experts (AE) lorsque la littérature ne permettait pas de graduer. Accord fort obtenu pour l''ensemble des recommandations après 2 tours de cotation et un amendement.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/download/rfe-gestion-anemie-reanimation/?wpdmdl=24462'
  and s.acronym in ('SFAR', 'SRLF') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/download/rfe-gestion-anemie-reanimation/?wpdmdl=24462'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'hematologie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.population, v.source_section,
  'https://sfar.org/download/rfe-gestion-anemie-reanimation/?wpdmdl=24462',
  'draft'
from public.documents d, (values
  ('MG-ANES-000007-R01', 'Appliquer une stratégie de réduction des prélèvements sanguins (en volume et en nombre) pour diminuer l''incidence de l''anémie et la transfusion en soins critiques.', 'AE', 'Prévention non pharmacologique de l''anémie', null, 'Champ 1 — Prévention non pharmacologique de l''anémie (R1.1)'),
  ('MG-ANES-000007-R02', 'Suivre une stratégie transfusionnelle restrictive (seuil d''Hb à 7,0 g/dL) chez les patients de soins critiques en général, y compris les patients septiques, afin de réduire le recours à la transfusion de concentrés érythrocytaires sans augmenter la morbi-mortalité.', '1+', 'Seuil transfusionnel restrictif — soins critiques en général', 'Patients de soins critiques, y compris septiques', 'Champ 2 — Stratégies transfusionnelles (R2.1)'),
  ('MG-ANES-000007-R03', 'Suivre une stratégie transfusionnelle restrictive (seuil d''Hb entre 7,5 et 8,0 g/dL) chez les patients de soins critiques en postopératoire de chirurgie cardiaque, afin de réduire le recours à la transfusion de concentrés érythrocytaires sans augmenter la morbi-mortalité.', '1+', 'Seuil transfusionnel restrictif — postopératoire chirurgie cardiaque', 'Patients en postopératoire de chirurgie cardiaque', 'Champ 2 — Stratégies transfusionnelles (R2.2)'),
  ('MG-ANES-000007-R04', 'Ne pas suivre une stratégie transfusionnelle libérale ciblant un objectif d''Hb > 10,0 g/dL pour diminuer la morbi-mortalité chez les patients ayant un syndrome coronarien aigu, revascularisé ou non.', '2-', 'Stratégie transfusionnelle libérale — non recommandée', 'Patients avec syndrome coronarien aigu, revascularisé ou non', 'Champ 2 — Stratégies transfusionnelles (R2.3)'),
  ('MG-ANES-000007-R05', 'Ne pas suivre une stratégie transfusionnelle libérale ciblant un objectif d''Hb > 10,0 g/dL pour diminuer la morbi-mortalité chez les patients cérébrolésés.', '2-', 'Stratégie transfusionnelle libérale — non recommandée', 'Patients cérébrolésés', 'Champ 2 — Stratégies transfusionnelles (R2.4)'),
  ('MG-ANES-000007-R06', 'Ne pas choisir les concentrés érythrocytaires en fonction de leur durée de stockage pour diminuer la morbi-mortalité chez les patients de soins critiques.', '1-', 'Choix des concentrés érythrocytaires — durée de stockage', null, 'Champ 2 — Stratégies transfusionnelles (R2.5)'),
  ('MG-ANES-000007-R07', 'Adopter une stratégie transfusionnelle restrictive basée sur la transfusion d''un concentré érythrocytaire unitaire suivie d''une réévaluation de l''indication transfusionnelle, afin de réduire la consommation de concentrés érythrocytaires sans augmenter la morbi-mortalité.', 'AE', 'Transfusion unitaire avec réévaluation', null, 'Champ 2 — Stratégies transfusionnelles (R2.6)'),
  ('MG-ANES-000007-R08', 'Utiliser des agents stimulants de l''érythropoïèse (ASE) chez les patients de soins critiques anémiques (Hb <= 10-12 g/dL) et/ou traumatisés, en l''absence de contre-indication (notamment antécédents cardio-vasculaires ischémiques et/ou thrombo-emboliques veineux), afin de réduire le recours à la transfusion de concentrés érythrocytaires et de diminuer la mortalité.', '2+', 'Agents stimulants de l''érythropoïèse — indication', 'Patients de soins critiques anémiques (Hb <= 10-12 g/dL) et/ou traumatisés', 'Champ 3 — Traitement non transfusionnel de l''anémie (R3.1)'),
  ('MG-ANES-000007-R09', 'Arrêter les agents stimulants de l''érythropoïèse lorsque l''hémoglobine se stabilise entre 10,0 et 12,0 g/dL, afin de réduire la morbi-mortalité.', 'AE', 'Agents stimulants de l''érythropoïèse — arrêt', null, 'Champ 3 — Traitement non transfusionnel de l''anémie (R3.2)'),
  ('MG-ANES-000007-R10', 'En dehors d''une association avec un traitement par agent stimulant de l''érythropoïèse, ne pas administrer de fer pour réduire le recours à la transfusion érythrocytaire ou la morbi-mortalité.', '2-', 'Fer — non-administration hors association ASE', null, 'Champ 3 — Traitement non transfusionnel de l''anémie (R3.3)')
) as v(code, statement, grade, condition_topic, population, source_section)
where d.source_url = 'https://sfar.org/download/rfe-gestion-anemie-reanimation/?wpdmdl=24462'
on conflict (recommendation_code) do nothing;
