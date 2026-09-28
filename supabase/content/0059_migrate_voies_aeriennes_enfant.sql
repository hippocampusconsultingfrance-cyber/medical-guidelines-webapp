-- Migration : Gestion des voies aériennes de l'enfant — Recommandations
-- Formalisées d'Experts communes SFAR-ADARPEF. Anesth Reanim.
-- 2019;5:408-426. Comité de 17 experts, coordination C. Dadure (SFAR), N.
-- Sabourdin et F. Veyckemans (ADARPEF). Texte validé par le CA SFAR
-- (21/06/2018) et le CA ADARPEF (24/05/2018). Ne s'applique pas à la
-- population néonatale et à l'enfant prématuré (exclusion explicite de la
-- source). Source : rfe-sfar-website/build/content_voies_aeriennes_enfant.json
-- (17 recommandations + 3 algorithmes sur 7 questions PICO).
--
-- **DERNIÈRE FICHE DU LOT TÂCHE 1 (59/59)** — voir
-- `supabase/migrations/MIGRATION_PROGRESS.md` pour le suivi complet des 59
-- fiches migrées.
--
-- MÉTHODOLOGIE : GRADE®, tags « (GRADE X+/-) ACCORD FORT » et « AVIS
-- D'EXPERTS » imprimés littéralement après chaque recommandation — cités
-- ici tels quels. `grade` reproduit tel quel le chip source.
-- `evidence_level` laissé NULL.
--
-- COMPTAGE — EXACTEMENT RECONCILIÉ (cas propre, aucun mismatch) : le
-- résumé officiel annonce "17 recommandations ; 6 de niveau de preuve
-- élevé (Grade 1), 6 de niveau de preuve faible (Grade 2), 5 avis
-- d'experts". Inventaire direct : R1-R12 (12 recommandations numérotées) +
-- 5 avis d'experts numérotés "n°1" à "n°5" (non rattachés à un repère
-- Rx.y mais explicitement comptés par la source dans son total de "17
-- recommandations") = 17, avec 6×Grade1 (tous 1+ : R2, R3, R4, R5, R8,
-- R10) + 6×Grade2 (5×2+ : R1, R6, R7, R9, R11 ; 1×2- : R12) + 5×AE (les 5
-- avis d'experts) — exactement reconcilié sur les deux axes. L'avis
-- d'experts n°4 (extubation) contient dans son propre paragraphe DEUX
-- suggestions distinctes (réveil complet + 3 min ventilation spontanée ;
-- OU extubation sur guide échangeur creux si risque suspecté) migrées ICI
-- comme UNE seule ligne combinée, pour rester fidèle au décompte "5 avis
-- d'experts" officiellement annoncé par la source (pas de ligne
-- supplémentaire inventée pour atteindre un compte différent).
--
-- PÉRIMÈTRE — volontairement pas migrés : (1) les 3 questions
-- explicitement déclarées « Pas de recommandation » PAR LA SOURCE
-- ELLE-MÊME (retrait du DSG sous AG profonde vs éveil ; extubation
-- profonde vs éveillée chez l'enfant sans difficulté ; choix DSG vs sonde
-- chez l'enfant enrhumé si masque facial non utilisable) — correspond
-- exactement aux "3 questions" sans recommandation possible annoncées par
-- le résumé officiel ; (2) les 3 algorithmes (intubation difficile
-- imprévue, ventilation au masque difficile, CICO — adaptés de Black AE
-- et al., Pediatr Anesth 2015, pures images en source, transcrits en
-- tableaux de décision par le contenu construit et vérifiés visuellement)
-- : la source elle-même les compte SÉPARÉMENT des "17 recommandations"
-- ("17 recommandations ... et 3 algorithmes"), aucune étape individuelle
-- n'y porte de chip de grade GRADE — protocoles opérationnels de
-- référence, même traitement que les algorithmes exclus ailleurs dans ce
-- corpus (`intubation_difficile_adulte`/0027, `intubation_reanimation`/
-- 0028, `traumatisme_vertebromedullaire`/0056).
--
-- POPULATION : l'intégralité du document concerne une population unique
-- (enfant, hors nouveau-né/prématuré, exclusion explicite de la source) —
-- `population` laissé NULL sur toutes les lignes plutôt que de répéter une
-- valeur triviale sur 17/17 lignes (même convention que `preeclampsie`/
-- 0038 et `urgences_obstetricales`/0057).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Seule la SFAR (dans le seed Annexe B) liée en document_societies ;
--    l'ADARPEF (co-auteur à égalité, "communes SFAR-ADARPEF" dans le
--    titre) hors seed, non liée.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Gestion des voies aériennes de l''enfant',
  'RFE', 'fr', '2018-09-29',
  'https://sfar.org/gestion-des-voies-aeriennes-de-lenfant/',
  'https://sfar.org/wp-content/uploads/2019/10/rfe-gestion-des-voies-aeriennes-de-lenfant.pdf',
  'GRADE® : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ probablement recommandé / 2- probablement non recommandé) ; AE = avis d''experts. Comptage source ("17 recommandations : 6 Grade1, 6 Grade2, 5 avis d''experts, accord fort 100 %") exactement reconcilié, aucun écart. 3 questions sans recommandation possible et 3 algorithmes (comptés séparément par la source) non gradués individuellement.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/gestion-des-voies-aeriennes-de-lenfant/'
  and s.acronym in ('SFAR') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/gestion-des-voies-aeriennes-de-lenfant/'
  and s.slug in ('anesthesie_reanimation', 'pediatrie', 'orl_et_chirurgie_cervico_faciale')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/gestion-des-voies-aeriennes-de-lenfant/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000059-R01', 'Il est probablement recommandé d''utiliser un dispositif supraglottique plutôt qu''une sonde d''intubation en cas de chirurgie superficielle programmée de courte durée afin de diminuer l''incidence des laryngospasmes et des hypoxémies lors du retrait du dispositif.', '2+', 'Champ 1 (1/2) — DSG, place générale (Réf. R1)'),
  ('MG-ANES-000059-R02', 'Lors d''une intervention pour amygdalectomie, il est recommandé de protéger les voies aériennes supérieures à l''aide d''une sonde d''intubation à ballonnet.', '1+', 'Champ 1 (2/2) — Amygdalectomie et adénoïdectomie (Réf. R2)'),
  ('MG-ANES-000059-R03', 'Lors d''une intervention pour adénoïdectomie, les experts suggèrent de protéger les voies aériennes avec une sonde d''intubation à ballonnet.', 'AE', 'Champ 1 (2/2) — Amygdalectomie et adénoïdectomie (Avis d''experts n°1)'),
  ('MG-ANES-000059-R04', 'En cas d''intubation et de ventilation difficiles non prévues, il est recommandé d''utiliser un dispositif supraglottique pour tenter d''assurer l''oxygénation de l''enfant.', '1+', 'Champ 1 (2/2) — DSG en situation difficile (Réf. R3)'),
  ('MG-ANES-000059-R05', 'Il est recommandé d''utiliser un manomètre pour monitorer la pression dans le coussinet d''un dispositif supraglottique gonflable et de limiter celle-ci à 40 cmH2O.', '1+', 'Champ 1 (2/2) — DSG en situation difficile (Réf. R4)'),
  ('MG-ANES-000059-R06', 'Pour l''intubation trachéale, il est recommandé d''utiliser des sondes à ballonnet plutôt que des sondes sans ballonnet, et de monitorer la pression du ballonnet (sans dépasser 20 cmH2O).', '1+', 'Champ 2 — Sondes à ballonnet (Réf. R5)'),
  ('MG-ANES-000059-R07', 'Il est probablement recommandé d''utiliser un vidéolaryngoscope en première intention chez les patients avec intubation difficile prévue et ventilation au masque possible, ou après échec de la laryngoscopie directe, afin d''augmenter les chances de succès de l''intubation.', '2+', 'Champ 3 — Vidéolaryngoscopes (Réf. R6)'),
  ('MG-ANES-000059-R08', 'Hors situations relevant d''une indication à une induction à séquence rapide et à l''utilisation d''un curare dépolarisant, il est probablement recommandé d''utiliser un curare non dépolarisant pour améliorer les conditions d''intubation au cours de l''anesthésie générale par induction intraveineuse chez l''enfant.', '2+', 'Champ 4 — Curares pour l''intubation (Réf. R7)'),
  ('MG-ANES-000059-R09', 'Dans l''induction en séquence rapide classique, il est recommandé d''utiliser un curare d''action rapide.', '1+', 'Champ 5 — Induction en séquence rapide (Réf. R8)'),
  ('MG-ANES-000059-R10', 'Dans l''induction en séquence rapide classique, il est probablement recommandé d''utiliser chez l''enfant la succinylcholine en première intention. En cas de contre-indication à la succinylcholine, il est probablement recommandé d''utiliser du rocuronium.', '2+', 'Champ 5 — Induction en séquence rapide (Réf. R9)'),
  ('MG-ANES-000059-R11', 'Les experts suggèrent de ne pas pratiquer de pression cricoïdienne lors de l''induction à séquence rapide chez l''enfant pour diminuer l''incidence des complications respiratoires.', 'AE', 'Champ 5 — Induction en séquence rapide (Avis d''experts n°2)'),
  ('MG-ANES-000059-R12', 'Lors d''une induction en séquence rapide, les experts suggèrent de ventiler l''enfant au masque avec une FiO2 ≥ 0,8 et de faibles niveaux de pression de ventilation (juste suffisants pour soulever le thorax et éviter une insufflation gastrique, idéalement < 15 cmH2O) dès que la SpO2 est inférieure à 95 %, afin de diminuer le risque d''hypoxémie durant l''intubation et immédiatement après (« séquence d''induction rapide contrôlée »).', 'AE', 'Champ 5 — Induction en séquence rapide (Avis d''experts n°3)'),
  ('MG-ANES-000059-R13', 'Les experts suggèrent d''extuber un enfant difficile à intuber après réveil complet et une ventilation spontanée en O2 100 % pendant au moins 3 minutes, sous monitorage complet, en présence d''un aide compétent et d''un chariot de matériel d''intubation difficile. Les experts suggèrent d''extuber sur un guide échangeur creux (GEC) un enfant chez qui on suspecte une extubation à risque.', 'AE', 'Champ 6 — Extubation de l''enfant (Avis d''experts n°4)'),
  ('MG-ANES-000059-R14', 'Chez l''enfant enrhumé, il est recommandé d''utiliser le masque facial si le degré d''urgence, le type et la durée de la chirurgie le permettent.', '1+', 'Champ 7 — Enfant enrhumé (Réf. R10)'),
  ('MG-ANES-000059-R15', 'Chez l''enfant enrhumé, avant l''âge de 6 ans, il est probablement recommandé de réaliser une nébulisation de salbutamol avant l''anesthésie générale.', '2+', 'Champ 7 — Enfant enrhumé (Réf. R11)'),
  ('MG-ANES-000059-R16', 'Chez l''enfant enrhumé, il n''est probablement pas recommandé d''administrer à l''induction de la lidocaïne (IV ou locale) pour diminuer l''incidence des complications respiratoires.', '2-', 'Champ 7 — Enfant enrhumé (Réf. R12)'),
  ('MG-ANES-000059-R17', 'Chez l''enfant enrhumé, les experts suggèrent de ne pas utiliser le desflurane, du fait d''une augmentation des résistances des voies aériennes démontrée par rapport au propofol et au sévoflurane chez l''enfant à hyperréactivité bronchique.', 'AE', 'Champ 7 — Enfant enrhumé (Avis d''experts n°5)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/gestion-des-voies-aeriennes-de-lenfant/'
on conflict (recommendation_code) do nothing;
