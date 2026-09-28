-- Migration : Antibioprophylaxie en chirurgie et médecine interventionnelle adulte et
-- pédiatrique — Champ 1 (recommandations générales) — SFAR/SPILF, RFE V3.0/V3.1
-- Source : rfe-sfar-website/build/content_antibioprophylaxie.json (11 recommandations
-- atomiques, méthodologie GRADE — chips "GRADE 1"/"GRADE 2"/"AE", tableaux "Réf. |
-- Recommandation | Niveau").
--
-- Grade : reproduit tel quel depuis le chip source ("GRADE 1"/"GRADE 2"/"AE" — libellé
-- exact imprimé par la source, distinct de la notation "1+/2-" utilisée par d'autres RFE
-- de ce corpus). evidence_level laissé NULL : pas de système de niveau de preuve distinct
-- du grade dans ce document.
--
-- PÉRIMÈTRE — disclosure déjà faite par le contenu construit lui-même : le document source
-- couvre 3 champs (Champ 1 — 11 recommandations générales ; Champs 2 et 3 — 18 tableaux
-- disciplinaires de posologie par procédure, adultes et pédiatriques, ~85 pages). Cette
-- fiche NE COUVRE QUE le Champ 1 (les Champs 2-3 sont des tableaux de référence consultés
-- au cas par cas, pas des recommandations narratives) : les 11 recommandations migrées
-- ci-dessous sont donc l'intégralité du contenu graduable de cette fiche, pas un
-- sous-ensemble arbitraire.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. `library_final.json` contient TROIS entrées distinctes pour "Antibioprophylaxie en
--    chirurgie et médecine interventionnelle" (2023-12, 2018-08-29, 2017/2018), TOUTES
--    marquées "status: en vigueur". Le contenu construit (et cette migration) suivent la
--    version 2023-12 (direct_pdf_url wpdmdl=68362), dont l'historique de versions propre
--    (V1.0 08/12/2023 -> V3.1 10/07/2026, reflétée par cette fiche) montre qu'il s'agit
--    d'un document évolutif à URL stable, pas de plusieurs documents distincts. Les entrées
--    2018/2017 de library_final.json semblent être des versions antérieures obsolètes non
--    marquées "abrogé" (cf. CLAUDE.md : "SFAR retire parfois un document sans mettre à jour
--    cet index") — non migrées ici (ni comme documents distincts, ni fusionnées), signalé
--    pour que le mainteneur de library_final.json tranche/nettoie ces entrées.
-- 2. Le document est co-écrit par 32 sociétés savantes en plus de SFAR/SPILF (AFU, SOFCOT,
--    CNGOF, SFC, GPIP, etc., liste complète dans le panneau "Document source" du contenu
--    construit) ; seules SFAR et SPILF figurent dans le seed Annexe B et sont donc liées
--    en document_societies ci-dessous — cas plus favorable que la plupart des migrations
--    précédentes (SPILF, contrairement à GIHP/GFHT/SFA/SFTS/SFVTT, est dans le seed).

insert into public.documents (title, doc_type, original_language, publication_date, revision_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Antibioprophylaxie en chirurgie et médecine interventionnelle adulte et pédiatrique',
  'RFE', 'fr', '2023-12-08', '2026-05-04',
  'https://sfar.org/download/antibioprophylaxie-en-chirurgie-et-medecine-interventionnelle/?wpdmdl=68362',
  'https://sfar.org/download/antibioprophylaxie-en-chirurgie-et-medecine-interventionnelle/?wpdmdl=68362',
  'GRADE® : GRADE 1 (preuve globale forte, recommandation forte), GRADE 2 (preuve modérée/faible, recommandation optionnelle), AE (avis d''experts). Cotation collective GRADE Grid, accord retenu à >=70% d''opinions convergentes et <20% d''opinions contraires. Les 11 recommandations du Champ 1 ont toutes obtenu un accord fort.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/download/antibioprophylaxie-en-chirurgie-et-medecine-interventionnelle/?wpdmdl=68362'
  and s.acronym in ('SFAR', 'SPILF') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/download/antibioprophylaxie-en-chirurgie-et-medecine-interventionnelle/?wpdmdl=68362'
  and s.slug in ('anesthesie_reanimation', 'infectiologie_maladies_infectieuses_et_tropicales')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.source_section,
  'https://sfar.org/download/antibioprophylaxie-en-chirurgie-et-medecine-interventionnelle/?wpdmdl=68362',
  'draft'
from public.documents d, (values
  ('MG-ANES-000009-R01', 'Il est recommandé d''administrer l''antibioprophylaxie par céphalosporine (ou ses alternatives en cas d''allergie, hors vancomycine) au plus tôt 60 minutes avant et au plus tard avant l''incision chirurgicale ou le début de la procédure interventionnelle, pour diminuer l''incidence d''ISO.', 'GRADE 1', 'Délai d''administration', 'Quand administrer l''antibioprophylaxie ? (R1.1)'),
  ('MG-ANES-000009-R02', 'En cas d''utilisation de la vancomycine, les experts suggèrent d''en débuter l''administration intraveineuse sur 60 minutes chez le patient non obèse au plus tôt 60 minutes avant, et au plus tard 30 minutes avant l''incision ou le début de la procédure, pour diminuer l''incidence d''ISO.', 'AE', 'Délai d''administration — vancomycine', 'Quand administrer l''antibioprophylaxie ? (R1.2)'),
  ('MG-ANES-000009-R03', 'Il est recommandé de réadministrer une à plusieurs dose(s) peropératoire(s) d''antibioprophylaxie en cas de prolongation de la chirurgie ou de l''acte interventionnel, pour diminuer l''incidence d''ISO.', 'GRADE 1', 'Réinjection peropératoire — indication', 'Réinjection peropératoire (R1.3.1)'),
  ('MG-ANES-000009-R04', 'Il est probablement recommandé de réadministrer cette (ces) dose(s), à la moitié de la dose initiale, toutes les 2 demi-vies de l''antibiotique utilisé, pour diminuer l''incidence d''ISO.', 'GRADE 2', 'Réinjection peropératoire — posologie et rythme', 'Réinjection peropératoire (R1.3.2)'),
  ('MG-ANES-000009-R05', 'Il n''est pas recommandé, dans la très grande majorité des cas (et hors exceptions mentionnées dans chaque tableau disciplinaire), de prolonger l''administration de l''antibioprophylaxie au-delà de la fin de la chirurgie, pour diminuer l''incidence d''ISO.', 'GRADE 1', 'Durée de l''antibioprophylaxie', 'Durée de l''antibioprophylaxie (R1.4)'),
  ('MG-ANES-000009-R06', 'Il n''est probablement pas recommandé d''augmenter la dose unitaire de céphalosporine chez le patient obèse pour diminuer l''incidence d''ISO, en dehors de cas particuliers (notamment IMC > 50 kg/m²).', 'GRADE 2', 'Adaptation chez le patient obèse — céphalosporines', 'Adaptation chez le patient obèse (R1.5.1)'),
  ('MG-ANES-000009-R07', 'Les experts suggèrent de ne pas augmenter la dose unitaire d''amoxicilline-clavulanate chez le patient obèse, en dehors de cas particuliers (notamment IMC > 50 kg/m²).', 'AE', 'Adaptation chez le patient obèse — amoxicilline-clavulanate', 'Adaptation chez le patient obèse (R1.5.2)'),
  ('MG-ANES-000009-R08', 'Pour les alternatives aux bêtalactamines en cas d''allergie, les experts suggèrent d''utiliser des doses adaptées à l''IMC chez le patient obèse (clindamycine : 900 mg pour IMC 30-45 kg/m², 1200 mg pour IMC 46-60 kg/m², 1600 mg pour IMC > 60 kg/m² ; gentamicine : 6 à 7 mg/kg de poids ajusté, comme chez le non-obèse ; vancomycine : 20 mg/kg de poids total, comme chez le non-obèse ; teicoplanine : non recommandée chez le patient obèse, absence de donnée dans cette population), pour diminuer l''incidence d''ISO.', 'AE', 'Adaptation chez le patient obèse — alternatives aux bêtalactamines', 'Adaptation chez le patient obèse (R1.6)'),
  ('MG-ANES-000009-R09', 'Dans les centres où la prévalence de colonisation digestive à entérobactéries productrices de BLSE (E-BLSE) des patients opérés de chirurgie colorectale est >= 10 %, les experts suggèrent un dépistage de la colonisation rectale à E-BLSE dans le mois précédant la chirurgie, pour adapter l''antibioprophylaxie et diminuer l''incidence d''ISO.', 'AE', 'Patient colonisé à E-BLSE — dépistage', 'Patient colonisé au niveau rectal à E-BLSE, chirurgie colo-rectale (R1.7.1)'),
  ('MG-ANES-000009-R10', 'En cas de positivité du dépistage, les experts suggèrent d''administrer, pour une chirurgie colo-rectale, une antibioprophylaxie ciblée active sur la souche d''E-BLSE identifiée, pour diminuer l''incidence d''ISO.', 'AE', 'Patient colonisé à E-BLSE — antibioprophylaxie ciblée', 'Patient colonisé au niveau rectal à E-BLSE, chirurgie colo-rectale (R1.7.2)'),
  ('MG-ANES-000009-R11', 'Les experts suggèrent une prise en charge multidisciplinaire (anesthésiste-réanimateur, chirurgien, infectiologue ou référent en infectiologie, microbiologiste) pour individualiser l''antibioprophylaxie des patients colonisés au niveau rectal à E-BLSE en chirurgie colo-rectale.', 'AE', 'Patient colonisé à E-BLSE — prise en charge multidisciplinaire', 'Patient colonisé au niveau rectal à E-BLSE, chirurgie colo-rectale (R1.7.3)')
) as v(code, statement, grade, condition_topic, source_section)
where d.source_url = 'https://sfar.org/download/antibioprophylaxie-en-chirurgie-et-medecine-interventionnelle/?wpdmdl=68362'
on conflict (recommendation_code) do nothing;
