-- Migration : Prévention de l'hypothermie peropératoire accidentelle au bloc opératoire chez
-- l'adulte — Recommandations Formalisées d'Experts (RFE), SFAR. Première RFE française sur
-- ce sujet. Texte validé par le Comité des Référentiels Cliniques SFAR le 12/06/2018, CA SFAR
-- le 21/06/2018. Source : rfe-sfar-website/build/content_hypothermie.json (14 recommandations
-- formalisées, 2 parties).
--
-- MÉTHODOLOGIE : GRADE classique (force forte 1+/1-, force faible 2+/2-, avis d'experts AE
-- lorsque la littérature ne permettait pas de graduer). `grade` reproduit tel quel le chip
-- source. `evidence_level` laissé NULL (pas de second axe imprimé par ligne dans ce
-- document — voir toutefois le point Accord ci-dessous, disclosure ponctuelle et non
-- systématique).
--
-- COMPTAGE — RECONCILIÉ EXACTEMENT, CONFIRMÉ PAR LA SOURCE ELLE-MÊME : le contenu construit
-- annonce "14 recommandations formalisées, réparties en 5 Grade 1 + 7 Grade 2 + 2 avis
-- d'experts (total confirmé par comptage direct des 14 grades littéraux, conforme au résumé
-- de la source — aucun écart à signaler cette fois)". Comptage direct des 14 lignes migrées
-- ci-dessous : 1+ ×5 (R1,R4,R6,R7,R12), 2+ ×6 (R2,R3,R5,R8,R10,R13), 2- ×1 (R9) = 7 Grade 2,
-- AE ×2 (R11, R14) = reconciliation exacte 5+7+2=14 avec le chiffre annoncé par la source.
-- R14 (« Proposition de stratégie de prévention... ») est explicitement numérotée R14 par le
-- source elle-même (titre "R14 — Proposition de stratégie...") et comptée par la source
-- comme la 14e recommandation/2e avis d'experts, bien que rendue par le contenu construit
-- sous forme d'un tableau de synthèse en 3 phases (Accueil / Per-anesthésie / SSPI) plutôt
-- qu'une phrase-recommandation isolée — reformulée ici en un seul `statement` narratif
-- couvrant les 3 phases, avec renvoi explicite aux recommandations R3/R4/R6/R7/R8/R12/R13
-- qu'elle synthétise (comme le fait la source elle-même), sans ajouter aucun contenu
-- nouveau.
--
-- DISCLOSURE PONCTUELLE (pas systématique, contrairement à glycemie/0022 ou eer/0020) : la
-- source précise qu'un accord fort a été obtenu pour 93 % des recommandations (13/14) après
-- 3 tours de cotation ; R8 (réchauffement des liquides d'irrigation) est la SEULE exception
-- disclosée avec un « Accord faible » malgré son grade GRADE 2+ — noté explicitement dans le
-- `source_section` de R8 ci-dessous plutôt que dans un champ `evidence_level` séparé (la
-- source n'imprime pas cette information pour les 13 autres lignes, donc pas un axe de
-- cotation systématique à extraire pour tout le document, à la différence de glycemie/eer).
--
-- PÉRIMÈTRE — volontairement pas migré : la Question 8 (réchauffement des fluides gazeux —
-- gaz anesthésiques, CO2 de cœlioscopie), pour laquelle la source déclare explicitement
-- qu'« aucune recommandation n'a pu être rédigée » faute de consensus — cohérent avec le
-- principe de ce projet de ne jamais migrer une absence de recommandation comme une ligne
-- graduée.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Seule la SFAR est société organisatrice de cette RFE — liée seule en
--    document_societies.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prévention de l''hypothermie peropératoire accidentelle au bloc opératoire chez l''adulte',
  'RFE', 'fr', '2018-09-29',
  'https://sfar.org/prevention-de-lhypothermie-peroperatoire-accidentelle-au-bloc-operatoire-chez-ladulte/',
  'https://sfar.org/wp-content/uploads/2018/09/2_RFE-Hypothermie-Version-Finale-_-Validee-CRC120618.pdf',
  'GRADE® : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ proposé / 2- proposé de ne pas faire) ; avis d''experts (AE) lorsque la littérature ne permettait pas de graduer. Accord fort obtenu pour 93 % des recommandations (13/14) après 3 tours de cotation ; R8 seule exception avec un Accord faible (disclosé ponctuellement dans son propre source_section, pas un axe systématique imprimé par ligne).',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prevention-de-lhypothermie-peroperatoire-accidentelle-au-bloc-operatoire-chez-ladulte/'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prevention-de-lhypothermie-peroperatoire-accidentelle-au-bloc-operatoire-chez-ladulte/'
  and s.slug in ('anesthesie_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/prevention-de-lhypothermie-peroperatoire-accidentelle-au-bloc-operatoire-chez-ladulte/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000025-R01', 'Lutter contre l''hypothermie péri-opératoire afin de diminuer la survenue des complications infectieuses, cardio-vasculaires et hémorragiques chez le patient anesthésié.', '1+', 'Partie I — Hypothermie : conséquences et seuil cible (Réf. R1)'),
  ('MG-ANES-000025-R02', 'Maintenir une T°C ≥ 36,5°C afin de diminuer les complications hémorragiques chez le patient anesthésié.', '2+', 'Partie I — Hypothermie : conséquences et seuil cible (Réf. R2)'),
  ('MG-ANES-000025-R03', 'Effectuer un réchauffement cutané actif avant l''induction de l''anesthésie (pré-warming) pour prévenir l''hypothermie et/ou diminuer la fréquence des complications infectieuses.', '2+', 'Partie II — Techniques de réchauffement (Réf. R3)'),
  ('MG-ANES-000025-R04', 'Utiliser le réchauffement cutané actif pour diminuer les complications de l''hypothermie chez le patient anesthésié.', '1+', 'Partie II — Techniques de réchauffement (Réf. R4)'),
  ('MG-ANES-000025-R05', 'Privilégier le réchauffement cutané actif au réchauffement passif par isolation cutanée (vêtements ou couvertures réfléchissants) pour maintenir la T°C.', '2+', 'Partie II — Techniques de réchauffement (Réf. R5)'),
  ('MG-ANES-000025-R06', 'Lorsque le volume administré est important, réchauffer les fluides i.v. avec un matériel dédié, toujours en association avec un réchauffement cutané actif, afin de limiter la chute de la T°C.', '1+', 'Partie II — Techniques de réchauffement (Réf. R6)'),
  ('MG-ANES-000025-R07', 'Réchauffer les produits sanguins labiles avec un matériel dédié, toujours en association avec un réchauffement cutané actif, afin de limiter la chute de la T°C et les complications cardiaques liées à leur basse température.', '1+', 'Partie II — Techniques de réchauffement (Réf. R7)'),
  ('MG-ANES-000025-R08', 'Réchauffer les liquides d''irrigation chirurgicaux avant de les administrer dans le but de maintenir une T°C > 36°C. Le réchauffement des liquides d''irrigation seul est cependant insuffisant et doit être accompagné de techniques de réchauffement cutané actif.', '2+', 'Partie II — Techniques de réchauffement (Réf. R8) [Accord Faible — seule exception disclosée par la source parmi les 14 recommandations, malgré le grade GRADE 2+]'),
  ('MG-ANES-000025-R09', 'Ne pas utiliser les aminoacides i.v. pour limiter la chute de la T°C et/ou diminuer les complications hémorragiques des patients anesthésiés.', '2-', 'Partie II — Techniques de réchauffement (Réf. R9)'),
  ('MG-ANES-000025-R10', 'Utiliser les dispositifs de réchauffement actifs sans craindre une augmentation du risque infectieux attribuable à leur utilisation.', '2+', 'Partie II — Techniques de réchauffement (Réf. R10)'),
  ('MG-ANES-000025-R11', 'Les dispositifs de réchauffement actif peuvent être pourvoyeurs de complications à type de brûlure en cas d''usage inapproprié.', 'AE', 'Partie II — Techniques de réchauffement (Réf. R11)'),
  ('MG-ANES-000025-R12', 'En cas d''hypothermie à l''arrivée en SSPI, utiliser un dispositif de réchauffement cutané actif pour atteindre la normothermie le plus rapidement possible.', '1+', 'Partie II — Techniques de réchauffement (Réf. R12)'),
  ('MG-ANES-000025-R13', 'Préférer les dispositifs utilisant l''air chaud pulsé aux dispositifs à circulation d''eau chaude pour atteindre la normothermie.', '2+', 'Partie II — Techniques de réchauffement (Réf. R13)'),
  ('MG-ANES-000025-R14', 'Stratégie proposée de prévention de l''hypothermie accidentelle péri-anesthésique, en trois phases : (1) Accueil du patient au bloc opératoire — température de la salle d''opération à 20°C à l''accueil et pendant l''induction, mesure de la T°C de départ, réchauffement cutané actif avant l''induction (pré-warming, R3) puis pendant l''induction ; (2) Per-anesthésie au bloc opératoire — monitorage per-anesthésique continu de la T°C, réchauffement cutané actif (R4), des fluides i.v. (R6), des produits sanguins labiles (R7) et des liquides d''irrigation (R8), objectif de maintenir la T°C à 36,5°C sans passer sous le seuil de 36°C ; (3) SSPI — mesure de la T°C à l''arrivée, réchauffement cutané actif en cas d''hypothermie (R12), par air chaud pulsé de préférence (R13), mesure de la T°C à la sortie, objectif T°C à 36,5°C.', 'AE', 'R14 — Proposition de stratégie de prévention de l''hypothermie accidentelle péri-anesthésique (synthèse des recommandations R3/R4/R6/R7/R8/R12/R13, non individuellement gradée dans la source, comptée par la source elle-même comme la 14e recommandation « avis d''experts »)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/prevention-de-lhypothermie-peroperatoire-accidentelle-au-bloc-operatoire-chez-ladulte/'
on conflict (recommendation_code) do nothing;
