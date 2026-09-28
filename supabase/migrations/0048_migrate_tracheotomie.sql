-- Migration : Trachéotomie en réanimation — Recommandations Formalisées
-- d'Experts communes SRLF-SFAR, avec la participation de la SFMU et de la
-- SFORL. 16 experts + 2 coordonnateurs (J-L. Trouillet/SRLF, O. Collange/
-- SFAR). Texte validé par le CA SFAR (15/12/2016) et le CA SRLF
-- (13/12/2016), publié Anesth Reanim. 2018;4:508-522. Source :
-- rfe-sfar-website/build/content_tracheotomie.json (18 recommandations
-- réparties en 5 champs + 3 protocoles de soins associés).
--
-- MÉTHODOLOGIE : GRADE, format PICO. `grade` reproduit tel quel le chip
-- source. `evidence_level` laissé NULL.
--
-- COMPTAGE — EXACTEMENT RECONCILIÉ (cas propre, aucun mismatch) : le
-- résumé officiel annonce "18 recommandations (8 recommandations
-- formalisées + 10 avis d'experts), 2 GRADE1 (1+/1-) + 6 GRADE2 (2+/2-)".
-- Inventaire direct : R1.1-R1.4, R2.1-R2.3, R3.1-R3.5, R4.1-R4.3,
-- R5.1-R5.3 = 18, avec 2×GRADE1 (R1.3:1-, R2.1:1+), 6×GRADE2 (R2.3:2+,
-- R3.1:2+, R3.2:2-, R3.3:2+, R5.2:2+, R5.3:2+), 10×AE — exactement
-- reconcilié sur les deux axes.
--
-- CORRECTION D'EXTRACTION DISCLOSÉE PAR LE CONTENU CONSTRUIT LUI-MÊME :
-- R1.3 et R3.2 sont imprimées dans la source « (Grade 1-) » et
-- « (Grade 2-) » (confirmé par rendu visuel des pages sources), mais
-- l'extraction automatique du texte PDF perd le signe « moins » pour ces
-- deux tags (bug d'extraction déjà rencontré à plusieurs reprises dans ce
-- corpus, cf. choc_hemorragique/0014) — corrigé par le contenu construit
-- avec le signe réellement imprimé ; `grade` migré ici reflète cette
-- correction (1- et 2-, pas 1/2 bruts).
--
-- PÉRIMÈTRE — volontairement pas migrés (avis d'experts au niveau du
-- protocole global, PAS une cotation individuelle ligne par ligne,
-- cohérent avec le principe déjà appliqué ailleurs dans ce corpus) : les 3
-- protocoles de soins associés à R3.5 (procédure standardisée de
-- trachéotomie percutanée, matériel/personnel/préparation/conditions/
-- après canulation), R4.1 (gestion post-trachéotomie par période : soins
-- immédiats, 0-4j, à distance) et R5.1 (algorithme séquentiel de
-- décanulation en 5 étapes, d'après Warnecke et al. Crit Care Med 2013,
-- transcrit par le contenu construit depuis une image de la page 11 du
-- texte source). Champ explicitement exclu par la source elle-même : la
-- gestion en urgence des voies aériennes (traumatisme/brûlure
-- cervico-faciale) — ces recommandations couvrent uniquement la
-- trachéotomie PROGRAMMÉE en réanimation chez l'adulte.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SRLF, SFAR et SFMU (toutes trois dans le seed Annexe B) liées en
--    document_societies ; SFORL (participante) hors seed, non liée.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Trachéotomie en réanimation',
  'RFE', 'fr', '2017-01-11',
  'https://sfar.org/tracheotomie-en-reanimation/',
  'https://sfar.org/wp-content/uploads/2017/01/Tracheotomie-en-reanimation-ANREA.pdf',
  'GRADE® : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ probablement recommandé / 2- probablement non recommandé) ; avis d''experts (AE). Comptage source ("18 recommandations : 8 formalisées [2 GRADE1 + 6 GRADE2] + 10 avis d''experts") exactement reconcilié, aucun écart. Correction d''extraction disclosée par le contenu construit : R1.3 et R3.2 imprimées "(Grade 1-)"/"(Grade 2-)" dans la source, signe "moins" perdu par l''extraction automatique du PDF, corrigé avec le signe réellement imprimé.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/tracheotomie-en-reanimation/'
  and s.acronym in ('SRLF', 'SFAR', 'SFMU') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/tracheotomie-en-reanimation/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'medecine_d_urgence', 'orl_et_chirurgie_cervico_faciale')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/tracheotomie-en-reanimation/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000048-R01', 'Les experts suggèrent que la trachéotomie soit proposée en cas de sevrage ventilatoire prolongé et de pathologie neuromusculaire acquise et potentiellement réversible (ex. Guillain-Barré, neuromyopathie acquise en réanimation, myasthénie, myélite lupique).', 'AE', 'Champ 1 — Indications et contre-indications (Réf. R1.1)'),
  ('MG-ANES-000048-R02', 'Les experts suggèrent que l''indication de la trachéotomie chez les patients ayant une insuffisance respiratoire chronique fasse l''objet d''une concertation multidisciplinaire.', 'AE', 'Champ 1 — Indications et contre-indications (Réf. R1.2)'),
  ('MG-ANES-000048-R03', 'Il ne faut pas réaliser de trachéotomie en réanimation avant le quatrième jour de ventilation mécanique.', '1-', 'Champ 1 — Indications et contre-indications (Réf. R1.3)'),
  ('MG-ANES-000048-R04', 'Les experts suggèrent que la trachéotomie (percutanée ou chirurgicale) ne soit pas réalisée en réanimation dans les situations à haut risque de complication : instabilité hémodynamique, hypertension intracrânienne avec PIC > 15 mmHg, hypoxémie sévère (PaO2/FiO2 < 100 mmHg sous PEP > 10 cmH2O), troubles de l''hémostase non corrigés (plaquettes < 50 000/mm³ et/ou INR > 1,5 et/ou TCA > 2× la normale), refus du patient et/ou de la famille, patient moribond ou suivant une procédure de limitation des thérapeutiques actives.', 'AE', 'Champ 1 — Indications et contre-indications (Réf. R1.4)'),
  ('MG-ANES-000048-R05', 'Il faut privilégier la trachéotomie percutanée comme la méthode standard de réalisation d''une trachéotomie chez les patients de réanimation.', '1+', 'Champ 2 — Techniques de mise en place (Réf. R2.1)'),
  ('MG-ANES-000048-R06', 'Les experts suggèrent qu''une concertation médicochirurgicale décide de la technique de trachéotomie à utiliser en cas de situation à risque de complication.', 'AE', 'Champ 2 — Techniques de mise en place (Réf. R2.2)'),
  ('MG-ANES-000048-R07', 'Il faut probablement privilégier la technique de trachéotomie percutanée par dilatation unique progressive comme la méthode standard de réalisation d''une trachéotomie percutanée chez les patients de réanimation.', '2+', 'Champ 2 — Techniques de mise en place (Réf. R2.3)'),
  ('MG-ANES-000048-R08', 'Il faut probablement réaliser une fibroscopie avant et pendant la réalisation de la trachéotomie percutanée.', '2+', 'Champ 3 — Conditions de réalisation (Réf. R3.1)'),
  ('MG-ANES-000048-R09', 'Il ne faut probablement pas recourir à la pose d''un masque laryngé pendant la réalisation de la trachéotomie percutanée en réanimation.', '2-', 'Champ 3 — Conditions de réalisation (Réf. R3.2)'),
  ('MG-ANES-000048-R10', 'Il faut probablement réaliser une échographie cervicale lors de la réalisation d''une trachéotomie percutanée en réanimation.', '2+', 'Champ 3 — Conditions de réalisation (Réf. R3.3)'),
  ('MG-ANES-000048-R11', 'Les experts suggèrent de ne pas prescrire d''antibioprophylaxie lors de la réalisation de la trachéotomie.', 'AE', 'Champ 3 — Conditions de réalisation (Réf. R3.4)'),
  ('MG-ANES-000048-R12', 'Les experts suggèrent qu''une procédure standardisée soit mise en place dans les services de réanimation pratiquant des trachéotomies percutanées.', 'AE', 'Champ 3 — Conditions de réalisation (Réf. R3.5)'),
  ('MG-ANES-000048-R13', 'Les experts suggèrent que les services de réanimation disposent d''un protocole de soins définissant la gestion de la trachéotomie.', 'AE', 'Champ 4 — Prise en charge du patient trachéotomisé (Réf. R4.1)'),
  ('MG-ANES-000048-R14', 'Les experts suggèrent de réaliser une humidification des voies aériennes chez les patients ayant une trachéotomie en réanimation.', 'AE', 'Champ 4 — Prise en charge du patient trachéotomisé (Réf. R4.2)'),
  ('MG-ANES-000048-R15', 'Les experts suggèrent de ne pas changer la canule de trachéotomie de façon systématique en réanimation.', 'AE', 'Champ 4 — Prise en charge du patient trachéotomisé (Réf. R4.3)'),
  ('MG-ANES-000048-R16', 'Les experts suggèrent qu''un protocole multidisciplinaire de décanulation soit disponible dans les services de réanimation.', 'AE', 'Champ 5 — Décanulation (Réf. R5.1)'),
  ('MG-ANES-000048-R17', 'Il faut probablement envisager de dégonfler le ballonnet de la canule de trachéotomie lorsque les patients sont en ventilation spontanée.', '2+', 'Champ 5 — Décanulation (Réf. R5.2)'),
  ('MG-ANES-000048-R18', 'Il faut probablement réaliser un examen pharyngolaryngé lors ou au-décours de la décanulation.', '2+', 'Champ 5 — Décanulation (Réf. R5.3)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/tracheotomie-en-reanimation/'
on conflict (recommendation_code) do nothing;
