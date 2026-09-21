-- Migration : Diagnostic et prise en charge d'une thrombopénie induite par
-- l'héparine (TIH, de type II/immune) — Propositions du Groupe d'Intérêt
-- en Hémostase Périopératoire (GIHP) et du Groupe Français d'études sur
-- l'Hémostase et la Thrombose (GFHT), en collaboration avec le Comité des
-- Référentiels Cliniques de la SFAR, 2019 (actualise la conférence
-- d'experts SFAR de 2002). Source : rfe-sfar-website/build/content_tih.json
-- (12 questions, 40 propositions — comptage source exactement reconcilié).
--
-- NATURE DU DOCUMENT — disclosure : `library_final.json` classe ce
-- document `"exact_type": "Autre"` — ni RFE, ni CC/CE au sens usuel du
-- corpus, cohérent avec le fait que le texte source se présente lui-même
-- comme des "Propositions" du GIHP/GFHT plutôt qu'une conférence
-- d'experts formelle. `doc_type = 'Propositions GIHP/GFHT'` retenu,
-- conforme à l'auto-description de la source. Un document distinct et
-- plus ancien, "Thrombopénie induite par l'héparine" (SFAR, CE 2002),
-- explicitement décrit comme le prédécesseur actualisé par CE document,
-- existe dans `library_final.json` — non confondu (href/contenu vérifiés
-- distincts), non migré séparément (superseded).
--
-- MÉTHODOLOGIE — UN SEUL AXE « ACCORD », PAS DE GRADE : la source précise
-- explicitement avoir choisi, comme en 2002, de ne pas attribuer de grade
-- (littérature jugée de faible niveau de preuve). Vote de 32 membres du
-- GIHP/GFHT : accord si ≥ 50 % pour et < 20 % contre ; "fort" si ≥ 70 %
-- pour. **Les 40 propositions ont TOUTES recueilli un accord fort**
-- (vérifié exhaustivement par la source elle-même et confirmé par
-- inventaire direct) — colonne Accord constante, reproduite fidèlement
-- (`grade = 'Fort'` sur toutes les lignes, pas une valeur par défaut
-- inventée). `evidence_level` laissé NULL (axe unique, pas de niveau de
-- preuve distinct).
--
-- COMPTAGE — EXACTEMENT RECONCILIÉ : "12 questions, 40 propositions"
-- annoncé par la source dès l'introduction, confirmé par inventaire direct
-- exhaustif des 40 lignes "Prop. N" (Prop. 1 à Prop. 40, aucun gap).
--
-- PÉRIMÈTRE — volontairement pas migrés (référence pharmacologique,
-- diagnostique ou algorithmique, jamais un chip d'accord individuel) :
-- Tableau I (niveaux de risque par contexte/héparine) ; Score des 4T
-- (outil de calcul diagnostique) ; Algorithme diagnostique clinique et
-- biologique (Figure 1) ; Tableau des posologies danaparoïde ; Algorithme
-- de prescription/surveillance de l'argatroban (Figure 2) ; Tableau II
-- (ajustement posologique par score de gravité, d'après Alatri et al.) ;
-- Relais argatroban→AVK (Figure 3 — **incohérence interne disclosée par
-- le contenu construit lui-même, non résolue** : le corps du texte
-- introduit "≥ 4" comme seuil d'arrêt de l'argatroban, la figure elle-même
-- trace "> 4" — les deux formulations coexistent dans la source, non
-- réharmonisées) ; Tableau IV (résultats AOD, Warkentin/Davis/Cuker) ;
-- Tableau V (délais d'arrêt pré-procéduraux) ; Stratégies chirurgie
-- cardiaque avec CEC (Figure 4) ; Tableau III (posologies bivalirudine en
-- chirurgie cardiaque). Les références bibliographiques [1]-[114] de la
-- source elle-même ne sont pas retranscrites (disclosure de la source
-- elle-même, "non pertinentes pour un aide-mémoire clinique").
--
-- POPULATION : Prop. 36 (grossesse) taguée `population = 'Grossesse'` ;
-- Prop. 37 et Prop. 38 (enfant) taguées `population = 'Pédiatrie''` ; le
-- reste (adulte par défaut) laissé NULL.
--
-- FRAÎCHEUR : `freshness_status = 'a_jour'` retenu (document 2019, pas de
-- disclosure d'obsolescence globale des pratiques comme sur d'autres
-- fiches du corpus) — la source signale néanmoins un caveat ponctuel de
-- disponibilité commerciale ("plusieurs molécules — bivalirudine,
-- lépirudine — ne sont plus commercialisées en France, vérifier les
-- disponibilités actuelles"), reproduit dans `grading_system` ci-dessous,
-- mais jugé de nature différente d'une obsolescence méthodologique globale
-- (pas de `revision_detectee`).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Seule la SFAR (collaboratrice, dans le seed Annexe B) est liée en
--    document_societies — GIHP et GFHT (auteurs principaux) hors seed,
--    non liés.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Diagnostic et prise en charge d''une thrombopénie induite par l''héparine',
  'Propositions GIHP/GFHT', 'fr', '2019-01-01',
  'https://sfar.org/download/diagnostic-et-prise-en-charge-dune-thrombopenie-induite-par-lheparine/?wpdmdl=34610',
  'https://sfar.org/download/diagnostic-et-prise-en-charge-dune-thrombopenie-induite-par-lheparine/?wpdmdl=34610',
  'Axe unique « Accord » (pas de grade GRADE) : vote de 32 membres du GIHP/GFHT, accord si ≥ 50% pour et < 20% contre, "fort" si ≥ 70% pour. Les 40 propositions ont toutes recueilli un accord fort (vérifié exhaustivement). Comptage source ("12 questions, 40 propositions") exactement reconcilié. Caveat de disponibilité : plusieurs molécules citées (bivalirudine, lépirudine) ne sont plus commercialisées en France (disclosure de la source elle-même, à vérifier au moment de la consultation).',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/download/diagnostic-et-prise-en-charge-dune-thrombopenie-induite-par-lheparine/?wpdmdl=34610'
  and s.acronym in ('SFAR') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/download/diagnostic-et-prise-en-charge-dune-thrombopenie-induite-par-lheparine/?wpdmdl=34610'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'cardiologie', 'gynecologie_obstetrique', 'pediatrie', 'hematologie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.source_section,
  'https://sfar.org/download/diagnostic-et-prise-en-charge-dune-thrombopenie-induite-par-lheparine/?wpdmdl=34610',
  'draft'
from public.documents d, (values
  ('MG-ANES-000047-R01', 'Il est proposé de distinguer trois stades différents de TIH selon son ancienneté : TIH aiguë (< 1 mois, anticorps anti-FP4 activateurs le plus souvent présents, risque thrombotique élevé) ; TIH subaiguë (1 à 3 mois, anticorps souvent présents à titre bas) ; antécédent de TIH (> 3 mois, anticorps le plus souvent indétectables).', 'Fort', null, 'Question 1 — Stades et niveaux de risque de TIH (Prop. 1)'),
  ('MG-ANES-000047-R02', 'Il est proposé de définir le niveau de risque de TIH sous héparine comme faible (< 0,1 %), intermédiaire (0,1-1 %) ou élevé (> 1 %) selon le contexte et le type d''héparine — voir Tableau I.', 'Fort', null, 'Question 1 — Stades et niveaux de risque de TIH (Prop. 2)'),
  ('MG-ANES-000047-R03', 'Il est proposé de réaliser systématiquement chez tous les patients traités par une héparine (HNF ou HBPM) une numération plaquettaire avant l''initiation du traitement (ou à défaut le plus tôt possible, avant J4).', 'Fort', null, 'Question 2 — Surveillance de la numération plaquettaire (NP) (Prop. 3)'),
  ('MG-ANES-000047-R04', 'Il est proposé de ne pas surveiller la NP chez les patients à risque faible de TIH.', 'Fort', null, 'Question 2 — Surveillance de la numération plaquettaire (NP) (Prop. 4)'),
  ('MG-ANES-000047-R05', 'Risque intermédiaire : surveiller la NP 1 à 2 fois/semaine entre J4 et J14, puis 1 fois/semaine pendant 1 mois si l''héparine est poursuivie.', 'Fort', null, 'Question 2 — Surveillance de la numération plaquettaire (NP) (Prop. 5)'),
  ('MG-ANES-000047-R06', 'Risque élevé : surveiller la NP 2 à 3 fois/semaine entre J4 et J14, puis 1 fois/semaine pendant 1 mois si l''héparine est poursuivie.', 'Fort', null, 'Question 2 — Surveillance de la numération plaquettaire (NP) (Prop. 6)'),
  ('MG-ANES-000047-R07', 'Quel que soit le risque de TIH, il est proposé de contrôler systématiquement la NP de tout malade traité par héparine en cas d''événement clinique inattendu : apparition/aggravation d''une thrombose veineuse ou artérielle, nécrose cutanée, ou réaction inhabituelle après injection d''héparine (frisson, hypotension, dyspnée, amnésie).', 'Fort', null, 'Question 3 — Circonstances évocatrices de TIH (Prop. 7)'),
  ('MG-ANES-000047-R08', 'En cas de suspicion de TIH, il est proposé de définir la probabilité clinique de TIH à l''aide du score des 4T, en dehors d''un contexte de chirurgie cardiaque.', 'Fort', null, 'Question 4 — Diagnostics différentiels & probabilité clinique (Prop. 8)'),
  ('MG-ANES-000047-R09', 'En cas de suspicion, il est proposé de rechercher le plus rapidement possible des anticorps anti-FP4 si la probabilité clinique de TIH est intermédiaire ou élevée.', 'Fort', null, 'Question 5 — Examens biologiques (Prop. 9)'),
  ('MG-ANES-000047-R10', 'Si la probabilité pré-test est faible (4T ≤ 3), le diagnostic de TIH peut être exclu et l''héparine poursuivie, sans test biologique spécifique — rechercher une autre étiologie avec suivi rapproché de la NP.', 'Fort', null, 'Question 6 — Prise en charge initiale d''une suspicion de TIH (Prop. 10)'),
  ('MG-ANES-000047-R11', 'Si la probabilité pré-test est intermédiaire (4-5) ou élevée (≥ 6), des tests biologiques (anticorps anti-FP4) doivent systématiquement être réalisés.', 'Fort', null, 'Question 6 — Prise en charge initiale d''une suspicion de TIH (Prop. 11)'),
  ('MG-ANES-000047-R12', 'Si probabilité intermédiaire et recherche anti-FP4 négative : le diagnostic de TIH est exclu, l''héparine peut être poursuivie/reprise avec suivi rapproché de la NP.', 'Fort', null, 'Question 6 — Prise en charge initiale d''une suspicion de TIH (Prop. 12)'),
  ('MG-ANES-000047-R13', 'Si probabilité élevée (4T ≥ 6 ou profil biphasique post-CEC) : l''héparine doit être immédiatement arrêtée et remplacée par un anticoagulant non héparinique à doses curatives, sans attendre les résultats biologiques.', 'Fort', null, 'Question 6 — Prise en charge initiale d''une suspicion de TIH (Prop. 13)'),
  ('MG-ANES-000047-R14', 'Si probabilité intermédiaire/élevée et titre significatif d''anticorps anti-FP4 détecté : un test fonctionnel doit être réalisé. S''il est positif, le diagnostic de TIH est confirmé.', 'Fort', null, 'Question 6 — Prise en charge initiale d''une suspicion de TIH (Prop. 14)'),
  ('MG-ANES-000047-R15', 'Les anticoagulants utilisables à la phase aiguë d''une TIH sont l''argatroban, la bivalirudine, le danaparoïde, le fondaparinux, et les anticoagulants oraux directs (AOD).', 'Fort', null, 'Question 7 — Anticoagulants de substitution à la phase aiguë (Prop. 15)'),
  ('MG-ANES-000047-R16', 'Le danaparoïde n''est pas recommandé en 1re intention en cas d''insuffisance rénale sévère.', 'Fort', null, 'Question 7 — Anticoagulants de substitution à la phase aiguë (Prop. 16)'),
  ('MG-ANES-000047-R17', 'Le danaparoïde à dose prophylactique n''est pas recommandé à la phase aiguë : des doses curatives IV sont plus efficaces, avec surveillance de l''activité anti-Xa (gamme danaparoïde).', 'Fort', null, 'Question 7 — Anticoagulants de substitution à la phase aiguë (Prop. 17)'),
  ('MG-ANES-000047-R18', 'L''absence de correction de la NP, ou l''apparition/extension d''une thrombose sous danaparoïde, doit conduire à le remplacer par un autre anticoagulant.', 'Fort', null, 'Question 7 — Anticoagulants de substitution à la phase aiguë (Prop. 18)'),
  ('MG-ANES-000047-R19', 'L''argatroban est à utiliser en priorité en cas d''insuffisance rénale sévère. Contre-indiqué si insuffisance hépatique sévère (Child-Pugh C). À utiliser en structure spécialisée.', 'Fort', null, 'Question 7 — Anticoagulants de substitution à la phase aiguë (Prop. 19)'),
  ('MG-ANES-000047-R20', 'Posologie initiale d''argatroban : 1 µg/kg/min, réduite à 0,5 µg/kg/min chez les patients de réanimation, de chirurgie cardiaque, et en cas d''insuffisance hépatique modérée (Child-Pugh B).', 'Fort', null, 'Question 7 — Anticoagulants de substitution à la phase aiguë (Prop. 20)'),
  ('MG-ANES-000047-R21', 'Surveillance quotidienne de l''argatroban : TCA (cible 1,5-3 × témoin, sans dépasser 100 sec) si normal avant traitement, ou de préférence temps de thrombine diluée/test à l''écarine (cible 0,5-1,5 µg/mL).', 'Fort', null, 'Question 7 — Anticoagulants de substitution à la phase aiguë (Prop. 21)'),
  ('MG-ANES-000047-R22', 'Un AVK ne doit être prescrit à la phase aiguë que lorsque la NP est corrigée (> 150 G/L), en relais sous couvert d''un traitement parentéral.', 'Fort', null, 'Question 7 — Anticoagulants de substitution à la phase aiguë (Prop. 22)'),
  ('MG-ANES-000047-R23', 'Choix selon le profil du patient : (1) stable, sans IR/IH sévère ni risque hémorragique → fondaparinux ou AOD possibles en 1re intention ; (2) instable ou à risque hémorragique/soins intensifs → injectable de ½ vie courte (argatroban ou bivalirudine) + surveillance biologique stricte ; (3) thrombose sévère (EP massive, thrombose extensive/artérielle, gangrène, CIVD) → argatroban ou bivalirudine en priorité ; (4) insuffisance rénale sévère (clairance < 30 mL/min) → seul l''argatroban peut être utilisé ; (5) insuffisance hépatique sévère (Child-Pugh C) → bivalirudine, danaparoïde ou fondaparinux.', 'Fort', null, 'Question 7 — Anticoagulants de substitution à la phase aiguë (Prop. 23)'),
  ('MG-ANES-000047-R24', 'Il est recommandé de ne pas transfuser de plaquettes à la phase aiguë d''une TIH en l''absence de saignement menaçant le pronostic vital ou fonctionnel.', 'Fort', null, 'Question 8 — Place d''autres traitements (Prop. 24)'),
  ('MG-ANES-000047-R25', 'Il est recommandé de ne pas prescrire d''agent antiplaquettaire oral pour traiter une TIH à la phase aiguë.', 'Fort', null, 'Question 8 — Place d''autres traitements (Prop. 25)'),
  ('MG-ANES-000047-R26', 'Il est proposé de ne pas prescrire en 1re intention d''immunoglobulines polyvalentes IV à la phase aiguë d''une TIH.', 'Fort', null, 'Question 8 — Place d''autres traitements (Prop. 26)'),
  ('MG-ANES-000047-R27', 'Il est proposé de ne pas mettre de filtre cave à la phase aiguë d''une TIH.', 'Fort', null, 'Question 8 — Place d''autres traitements (Prop. 27)'),
  ('MG-ANES-000047-R28', 'TIH aiguë (< 1 mois) : il est proposé de reporter toute chirurgie au-delà du 1er mois suivant le diagnostic si cela ne génère pas de risque vital/fonctionnel majeur, et d''en définir les modalités en concertation multidisciplinaire.', 'Fort', null, 'Question 9 — TIH en milieu chirurgical (hors chirurgie cardiaque) (Prop. 28)'),
  ('MG-ANES-000047-R29', 'Chirurgie chez un patient sous anticoagulant oral avec TIH aiguë : arrêter l''anticoagulant, discuter un relais préopératoire par argatroban (arrêt perfusion 4h avant l''intervention) ou bivalirudine (arrêt 2h avant).', 'Fort', null, 'Question 9 — TIH en milieu chirurgical (hors chirurgie cardiaque) (Prop. 29)'),
  ('MG-ANES-000047-R30', 'Post-opératoire, si anticoagulation prolongée indiquée et risque hémorragique contrôlé : traiter préférentiellement par fondaparinux ou un anticoagulant oral (AVK ou AOD).', 'Fort', null, 'Question 9 — TIH en milieu chirurgical (hors chirurgie cardiaque) (Prop. 30)'),
  ('MG-ANES-000047-R31', 'Avant toute chirurgie cardiaque chez un patient avec antécédent documenté de TIH, il est proposé de rechercher systématiquement en ELISA des anticorps anti-FP4.', 'Fort', null, 'Question 10 — Chirurgie cardiaque avec ou sans CEC (Prop. 31)'),
  ('MG-ANES-000047-R32', 'Avant chirurgie cardiaque avec CEC chez un patient en TIH aiguë ou subaiguë (< 3 mois) : définir le protocole d''anticoagulation péri-opératoire en concertation pluridisciplinaire.', 'Fort', null, 'Question 10 — Chirurgie cardiaque avec ou sans CEC (Prop. 32)'),
  ('MG-ANES-000047-R33', 'TIH aiguë/subaiguë avec titre significatif d''anticorps (ELISA DO > 1) nécessitant une CEC : associer un antiplaquettaire IV (tirofiban ou cangrelor) + HNF, ou une antithrombine directe IV (bivalirudine ou argatroban) avec surveillance biologique étroite. En urgence : privilégier l''association antiplaquettaire IV + HNF.', 'Fort', null, 'Question 10 — Chirurgie cardiaque avec ou sans CEC (Prop. 33)'),
  ('MG-ANES-000047-R34', 'TIH aiguë avec syndrome coronarien aigu nécessitant une angioplastie transluminale : traiter préférentiellement par bivalirudine (ou un analogue), ou à défaut par argatroban.', 'Fort', null, 'Question 11 — TIH en médecine, obstétrique, pédiatrie (Prop. 34)'),
  ('MG-ANES-000047-R35', 'TIH nécessitant une épuration extra-rénale : utiliser préférentiellement le citrate ou l''argatroban pour l''anticoagulation du circuit.', 'Fort', null, 'Question 11 — TIH en médecine, obstétrique, pédiatrie (Prop. 35)'),
  ('MG-ANES-000047-R36', 'TIH pendant la grossesse : traiter préférentiellement par le danaparoïde (ne traverse pas le placenta) ou, à défaut, le fondaparinux.', 'Fort', 'Grossesse', 'Question 11 — TIH en médecine, obstétrique, pédiatrie (Prop. 36)'),
  ('MG-ANES-000047-R37', 'Les modalités de surveillance de la NP des enfants traités par héparine sont identiques à celles de l''adulte.', 'Fort', 'Pédiatrie', 'Question 11 — TIH en médecine, obstétrique, pédiatrie (Prop. 37)'),
  ('MG-ANES-000047-R38', 'Le traitement d''une TIH chez l''enfant repose sur le danaparoïde sodique ou l''argatroban, avec adaptation rigoureuse des doses au poids et aux tests biologiques.', 'Fort', 'Pédiatrie', 'Question 11 — TIH en médecine, obstétrique, pédiatrie (Prop. 38)'),
  ('MG-ANES-000047-R39', 'Une consultation d''hémostase dans un délai de 3 mois suivant le diagnostic de TIH est proposée, avec remise au patient d''une carte attestant la complication, précisant les résultats biologiques et préconisant l''éviction de tout traitement par héparine.', 'Fort', null, 'Question 12 — Prévention de la survenue ou d''une récidive (Prop. 39)'),
  ('MG-ANES-000047-R40', 'En cas d''antécédent de TIH, il est proposé de prescrire un anticoagulant oral (AVK ou AOD) ou le fondaparinux lorsqu''une anticoagulation prophylactique ou curative est indiquée. Argatroban, bivalirudine et danaparoïde ne sont à envisager que si les anticoagulants oraux et le fondaparinux sont contre-indiqués.', 'Fort', null, 'Question 12 — Prévention de la survenue ou d''une récidive (Prop. 40)')) as v(code, statement, grade, population, source_section)
where d.source_url = 'https://sfar.org/download/diagnostic-et-prise-en-charge-dune-thrombopenie-induite-par-lheparine/?wpdmdl=34610'
on conflict (recommendation_code) do nothing;
