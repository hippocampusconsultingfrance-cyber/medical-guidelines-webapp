-- Migration : Intubation difficile et extubation en anesthésie chez l'adulte —
-- Recommandations Formalisées d'Experts (RFE), SFAR, Anesth Reanim 2017;3:552-571.
-- Actualisation de la Conférence d'Experts « Intubation difficile » de 2006. Comité de 13
-- experts, méthode GRADE®, format PICO, 6 questions. Source :
-- rfe-sfar-website/build/content_intubation_difficile_adulte.json (13 recommandations).
--
-- MÉTHODOLOGIE : GRADE classique (1+/1-/2+/2-), tags « (Grade X+/-) Accord FORT » (ou
-- « Accord faible » pour R2.3 uniquement) imprimés littéralement après chaque
-- recommandation par la source. `grade` reproduit tel quel le chip GRADE. `evidence_level`
-- laissé NULL.
--
-- COMPTAGE — RECONCILIÉ EXACTEMENT : la source annonce elle-même "13 recommandations
-- formalisées ; 5 de niveau de preuve élevé (Grade 1), 8 de niveau de preuve faible
-- (Grade 2)". Comptage direct des 13 lignes migrées ci-dessous : 1+ ×5 (R1.1,R1.2,R2.1,
-- R4.1,R6.1), 2+ ×8 (R1.3,R2.2,R2.3,R4.2,R5.1,R5.2,R5.3,R5.4) = reconciliation exacte 5+8=13.
-- Numérotation source non continue par construction : la source précise elle-même
-- "13 recommandations (R1.1-R1.3, R2.1-R2.3, R4.1-R4.2, R5.1-R5.4, R6.1) — pas de R3, la
-- question 3 a abouti à « pas de recommandation »" — le saut R2→R4 (pas de "R3.x") est donc
-- intentionnel et documenté par la source, pas un repère manquant.
--
-- DISCLOSURE PONCTUELLE : R2.3 est la SEULE recommandation de cette RFE à ne pas avoir
-- recueilli d'« Accord FORT » — son grade est explicitement qualifié d'« Accord faible »
-- dans le texte source (malgré son grade GRADE 2+, comme les 8 autres recommandations
-- Grade 2 de ce document qui ont, elles, toutes un Accord fort) — notée dans son propre
-- `source_section` plutôt que dans un champ `evidence_level` séparé (la source ne
-- l'imprime pas systématiquement ligne à ligne).
--
-- PÉRIMÈTRE — volontairement pas migrés (référence/algorithme, pas des recommandations
-- individuellement graduées, cohérent avec le principe déjà appliqué ailleurs dans ce
-- corpus, ex. curares/0018) :
-- 1. Le tableau "# | Question" (sommaire des 6 questions traitées, pas des
--    recommandations).
-- 2. Les 5 algorithmes-organigrammes (Algorithme 1 — intubation difficile prévue ;
--    Algorithme 2 — intubation difficile non prévue ; Algorithme 3 — oxygénation en cas de
--    ventilation au masque inefficace et échec d'intubation ; Algorithme 4 — facteurs de
--    risque d'extubation ; Algorithme 5 — leadership et décision d'extubation) —
--    "transcrits intégralement depuis le rendu visuel de la source (pures images)" d'après
--    le contenu construit lui-même, reconstruits en tableaux "Étape/Décision" ou
--    "Branche/Facteurs" pour la lisibilité mais sans chip de cotation individuelle par
--    étape : synthèses opérationnelles des recommandations R1-R6 déjà graduées
--    individuellement ci-dessus, pas de nouvelles recommandations distinctes.
-- Également volontairement pas migrées, les 2 questions « pas de recommandation »
-- explicitement disclosées par la source (Question 3 : AIVOC/AINOC vs sédation par bolus ;
-- utilisation des vidéolaryngoscopes en cas d'estomac plein/induction en séquence rapide,
-- mentionnée dans le prérequis de Q2) — cohérent avec le principe de ce projet de ne jamais
-- migrer une absence de recommandation comme une ligne graduée.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Seule la SFAR est société organisatrice de cette RFE — liée seule en
--    document_societies.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Intubation difficile et extubation en anesthésie chez l''adulte',
  'RFE', 'fr', '2017-09-22',
  'https://sfar.org/actualisation-de-recommandations-intubation-difficile-et-extubation-en-anesthesie-chez-ladulte/',
  'https://sfar.org/wp-content/uploads/2017/09/RFE-ANREA-Intubation-difficile-et-extubation-en-anesthesie-chez-l-adulte.pdf',
  'GRADE® : force forte (1+ il faut faire / 1- il ne faut pas faire) ou faible (2+ il faut probablement / 2- il ne faut probablement pas). Tags « (Grade X+/-) Accord FORT » imprimés littéralement après chaque recommandation, sauf R2.3 (seule exception, « Accord faible »). Actualisation de la Conférence d''Experts « Intubation difficile » de 2006.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/actualisation-de-recommandations-intubation-difficile-et-extubation-en-anesthesie-chez-ladulte/'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/actualisation-de-recommandations-intubation-difficile-et-extubation-en-anesthesie-chez-ladulte/'
  and s.slug in ('anesthesie_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/actualisation-de-recommandations-intubation-difficile-et-extubation-en-anesthesie-chez-ladulte/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000027-R01', 'Il faut prévenir systématiquement la désaturation artérielle en oxygène lors des manœuvres d''intubation trachéale ou d''insertion de dispositif supraglottique en raison des conséquences en termes de morbidité et de mortalité lors de sa survenue.', '1+', 'Question 1 — Préoxygénation et oxygénation apnéique (Réf. R1.1)'),
  ('MG-ANES-000027-R02', 'Afin de prévenir une désaturation artérielle lors des manœuvres d''intubation trachéale ou d''insertion de dispositif supraglottique, il faut réaliser systématiquement une procédure de préoxygénation (3 min / 8 inspirations profondes), y compris dans le cadre de l''urgence.', '1+', 'Question 1 — Préoxygénation et oxygénation apnéique (Réf. R1.2)'),
  ('MG-ANES-000027-R03', 'Dans certains cas, il faut probablement utiliser des techniques d''oxygénation apnéique avec des techniques spécifiques pour prévenir une désaturation artérielle en oxygène.', '2+', 'Question 1 — Préoxygénation et oxygénation apnéique (Réf. R1.3)'),
  ('MG-ANES-000027-R04', 'Dans le cadre d''une chirurgie programmée, il faut utiliser en première intention les vidéolaryngoscopes chez les patients avec une ventilation au masque possible et au moins deux critères d''intubation difficile.', '1+', 'Question 2 (1/2) — Vidéolaryngoscopes : intubation difficile prévue (Réf. R2.1)'),
  ('MG-ANES-000027-R05', 'Si une intubation difficile n''est pas prévue, il faut probablement utiliser les vidéolaryngoscopes en seconde intention chez les patients avec un stade de Cormack et Lehane III ou plus, si la ventilation au masque est possible.', '2+', 'Question 2 (1/2) — Vidéolaryngoscopes : intubation difficile prévue (Réf. R2.2)'),
  ('MG-ANES-000027-R06', 'Il faut probablement utiliser les vidéolaryngoscopes en technique alternative à l''utilisation du fibroscope chez les patients en ventilation spontanée, avec des critères d''intubation prévue difficile ou impossible et de ventilation au masque difficile.', '2+', 'Question 2 (2/2) — Vidéolaryngoscopes en ventilation spontanée (Réf. R2.3) [Accord faible — seule exception disclosée par la source parmi les 13 recommandations, malgré le grade GRADE 2+]'),
  ('MG-ANES-000027-R07', 'Il faut maintenir un niveau d''anesthésie profond afin d''optimiser les conditions de ventilation au masque et d''intubation en utilisant des agents rapidement réversibles.', '1+', 'Questions 3-4 — Anesthésie et curarisation (Réf. R4.1)'),
  ('MG-ANES-000027-R08', 'En cas d''intubation difficile prévue, il faut probablement utiliser un curare afin d''améliorer les conditions de ventilation au masque et d''intubation, en utilisant un curare d''action courte ou rapidement inactivée sous couvert du monitorage systématique de la curarisation.', '2+', 'Questions 3-4 — Anesthésie et curarisation (Réf. R4.2)'),
  ('MG-ANES-000027-R09', 'Il faut probablement adapter la prise en charge aux facteurs de risque d''échec d''extubation car la réintubation est source d''une surmorbidité et de surmortalité.', '2+', 'Question 5 (1/2) — Critères et stratégie d''extubation (Réf. R5.1)'),
  ('MG-ANES-000027-R10', 'Il faut probablement rechercher des facteurs de risque d''échec avant extubation.', '2+', 'Question 5 (1/2) — Critères et stratégie d''extubation (Réf. R5.2)'),
  ('MG-ANES-000027-R11', 'Il faut probablement extuber un patient en suivant une stratégie rigoureuse.', '2+', 'Question 5 (2/2) — Mesures préventives et prise en charge (Réf. R5.3)'),
  ('MG-ANES-000027-R12', 'Il faut probablement prendre des mesures préventives en présence de facteurs de risque de difficultés d''extubation.', '2+', 'Question 5 (2/2) — Mesures préventives et prise en charge (Réf. R5.4)'),
  ('MG-ANES-000027-R13', 'Il faut s''appuyer sur des arbres décisionnels ou algorithmes pour optimiser la gestion d''un contrôle difficile des voies aériennes.', '1+', 'Question 6 — Arbres décisionnels et algorithmes (Réf. R6.1)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/actualisation-de-recommandations-intubation-difficile-et-extubation-en-anesthesie-chez-ladulte/'
on conflict (recommendation_code) do nothing;
