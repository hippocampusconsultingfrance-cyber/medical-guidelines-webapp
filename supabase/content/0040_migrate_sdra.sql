-- Migration : Recommandations pour la prise en charge du SDRA — traduction
-- résumée officielle par le comité Réanimation de la SFAR (M. Garnier, M.
-- Jabaudon, A. Monsel, C. Quesnel, J-M. Constantin) de : An Official
-- American Thoracic Society / European Society of Intensive Care Medicine /
-- Society of Critical Care Medicine Clinical Practice Guideline: Mechanical
-- Ventilation in Adult Patients with Acute Respiratory Distress Syndrome
-- (Am J Respir Crit Care Med 2017;195(9):1253-1263, incl. erratum
-- 2017;195(11):1540). Texte validé par le Comité des Référentiels Cliniques
-- SFAR (12/12/2017) et le CA SFAR (02/02/2018). Source :
-- rfe-sfar-website/build/content_sdra.json (5 recommandations R1-R5 + 1
-- question sans recommandation possible/ECMO — comptage source
-- exactement reconcilié, aucun écart).
--
-- NATURE DU DOCUMENT — disclosure importante : il ne s'agit PAS d'une RFE
-- rédigée par un comité d'experts SFAR (contrairement à la quasi-totalité
-- des autres documents de ce corpus), mais d'une traduction française
-- résumée d'un guideline international déjà publié par un comité ATS/
-- ESICM/SCCM. Le contenu construit le précise lui-même explicitement en
-- tête de document. `library_final.json` classe pourtant ce document sous
-- `exact_type: "RFE"` comme les autres — divergence disclosée, non résolue
-- (le format de présentation imite le gabarit RFE SFAR, mais l'origine
-- éditoriale diffère).
--
-- MÉTHODOLOGIE : GRADE (force forte 1+/1-, force faible 2+/2-). Pas de
-- catégorie "avis d'experts" dans ce document (absence disclosée, pas un
-- oubli). `grade` reproduit tel quel le chip source. `evidence_level`
-- laissé NULL : la version originale anglaise reporte une "confiance
-- globale dans l'estimation de l'effet" (Haute/Modérée/Basse/Très basse)
-- par critère de jugement, mais la traduction française ne la reporte
-- volontairement pas en fin d'énoncé (disclosure de la source
-- elle-même, "note des traducteurs") — cette confiance, HÉTÉROGÈNE au
-- sein d'une même recommandation (plusieurs critères de jugement, chacun
-- sa propre confiance), n'est donc pas extraite dans un champ structuré
-- unique ici, cohérent avec le choix des traducteurs.
--
-- COMPTAGE — EXACTEMENT RECONCILIÉ : "les 5 recommandations numérotées
-- (R1-R5) et l'absence de recommandation sur l'ECMO (Question 6) sont
-- reproduites intégralement" (source elle-même). Aucun tableau, figure ou
-- algorithme dans ce document (vérifié par la source, lecture intégrale
-- des 21 pages) — contenu purement narratif, rien d'autre à migrer.
--
-- PÉRIMÈTRE — volontairement pas migré : Question 6 (ECMO veino-veineuse
-- dans le SDRA sévère) — absence de recommandation explicitement déclarée
-- par le comité international, faute de preuves suffisantes au moment du
-- texte source (essai EOLIA alors en cours). Champ d'application limité à
-- la stratégie VENTILATOIRE du SDRA, non extrapolable à d'autres causes
-- d'insuffisance respiratoire aiguë (disclosure de portée de la source
-- elle-même, pas une restriction de mon fait).
--
-- SOCIÉTÉS — À VÉRIFIER (disclosure, pas une invention) :
-- 1. Seule la SFAR est liée en document_societies : c'est elle qui publie
--    et signe ce document précis (source_url sfar.org, traduction sous sa
--    responsabilité éditoriale). Le guideline ORIGINAL anglais a été
--    élaboré par un comité international ATS/ESICM/SCCM — ESICM et SCCM
--    figurent tous deux dans le seed Annexe B (sous 'International'),
--    mais ne sont PAS des signataires du document français publié à ce
--    source_url ; ATS n'est de toute façon pas dans le seed. Choix de
--    prudence : ne pas lier ESICM/SCCM à ce document-ci (ils seraient
--    liés au guideline original anglais, un document distinct non migré
--    ici) — décision non tranchée unilatéralement, à confirmer par un
--    relecteur humain si un modèle de "document source traduit" devait
--    être introduit plus tard dans le schéma.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Recommandations pour la prise en charge du SDRA',
  'traduction résumée SFAR d''un guideline international (format RFE)', 'fr', '2018-03-06',
  'https://sfar.org/recommandations-prise-charge-sdra/',
  'https://sfar.org/wp-content/uploads/2018/03/2_Recos-SDRA.pdf',
  'GRADE® : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ probablement recommandé / 2- probablement non recommandé). Traduction française résumée d''un guideline international ATS/ESICM/SCCM 2017, pas une RFE SFAR au sens usuel du corpus (disclosure explicite de la source elle-même) ; library_final.json le classe pourtant "RFE" comme les autres, divergence non résolue. Comptage source ("5 recommandations R1-R5 + 1 question sans recommandation/ECMO") exactement reconcilié, aucun écart.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/recommandations-prise-charge-sdra/'
  and s.acronym in ('SFAR') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/recommandations-prise-charge-sdra/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'pneumologie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/recommandations-prise-charge-sdra/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000040-R01', 'Il est recommandé que les patients adultes atteints de SDRA soient ventilés avec une stratégie limitant le volume courant (Vt 4-8 mL/kg de poids théorique) et la pression de plateau (Pplat < 30 cmH2O).', '1+', 'Volumes courants/pression de plateau & décubitus ventral (Réf. R1)'),
  ('MG-ANES-000040-R02', 'Il est recommandé que les patients adultes atteints de SDRA sévère soient positionnés en décubitus ventral pendant plus de 12 heures par jour.', '1+', 'Volumes courants/pression de plateau & décubitus ventral (Réf. R2)'),
  ('MG-ANES-000040-R03', 'Il est recommandé de ne pas utiliser la ventilation par oscillations à haute fréquence (VOHF) en routine chez les patients atteints de SDRA modéré ou sévère.', '1-', 'VOHF & pression expiratoire positive (PEP) élevée (Réf. R3)'),
  ('MG-ANES-000040-R04', 'Il est probablement recommandé que les patients adultes atteints de SDRA modéré à sévère soient ventilés avec une PEP élevée plutôt qu''avec une PEP basse.', '2+', 'VOHF & pression expiratoire positive (PEP) élevée (Réf. R4)'),
  ('MG-ANES-000040-R05', 'Il est probablement recommandé d''appliquer des manœuvres de recrutement chez les patients adultes atteints de SDRA modéré à sévère.', '2+', 'Manœuvres de recrutement & ECMO (Réf. R5)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/recommandations-prise-charge-sdra/'
on conflict (recommendation_code) do nothing;
