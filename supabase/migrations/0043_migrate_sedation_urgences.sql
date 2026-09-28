-- Migration : Sédation et analgésie en structure d'urgence — réactualisation
-- de la Conférence d'experts SFAR de 1999. Recommandations Formalisées
-- d'Experts SFAR-SFMU, 18 experts (coord. B. Vivien, F. Adnet, et al.). Ann
-- Fr Anesth Reanim 2010;29:934-949 (doi:10.1016/j.annfar.2010.10.005).
-- Source : rfe-sfar-website/build/content_sedation_urgences.json (160
-- recommandations réparties en 7 questions, dont 8 circonstances
-- particulières en Q5 [a-h] et 2 sous-questions pédiatriques en Q6 [1/2 et
-- 2/2] + une section de surveillance pédiatrique SOAPME).
--
-- MÉTHODOLOGIE — GRADE ADAPTÉE À 3 NIVEAUX (disclosure explicite de la
-- source, le groupe de travail ayant explicitement adapté GRADE faute
-- d'études de haut niveau suffisantes) : Niveau 1 (preuve élevée) — « il
-- faut faire »/« il ne faut pas faire » → 1+/1- ; Niveau 2 (preuve
-- modérée) — « les experts recommandent de faire/de ne pas faire » →
-- 2+/2- ; Niveau 3 (preuve faible ou absente) — « les experts proposent »
-- → AE. Un accord DELPHI/RAND-UCLA modifié a validé chaque recommandation ;
-- « accord faible » est signalé explicitement par la source pour certaines
-- d'entre elles et reproduit ici entre parenthèses DANS LE TEXTE de
-- `statement` (pas un champ `evidence_level` séparé — la source ne
-- l'imprime pas de façon systématique ligne à ligne, même convention que
-- hypothermie/0025 et intubation_difficile_adulte/0027). `grade` reproduit
-- tel quel le chip source. `evidence_level` laissé NULL.
--
-- COMPTAGE — 160 recommandations, inventaire direct programmatique exhaustif
-- des tables "Thème/Recommandation (formulation des experts)/Grade" des 16
-- sous-sections du document (Q1, Q2 1/2 et 2/2, Q3, Q4, Q5a-h, Q6 1/2 et
-- 2/2, Surveillance SOAPME) : 39×1+, 8×1-, 45×2+, 11×2-, 57×AE
-- (39+8+45+11+57=160). Le contenu construit ne publie pas de total
-- officiel agrégé — rien à réconcilier, comptage direct retenu tel quel.
-- **3e plus grande migration de ce corpus après securisation_proc/0041
-- (198) et mal_epileptique/0032 (163).**
--
-- FIABILITÉ DE SOURCE — disclosure explicite reproduite : la page 9 du PDF
-- source (Figure 2 — algorithme d'intubation, Question 4 « Patient
-- intubé-ventilé » en intégralité, et la phrase d'ouverture de la question
-- 5a « État de choc ») est ENTIÈREMENT RASTÉRISÉE, sans aucun texte
-- extractible dans le PDF — ce contenu a été intégralement retranscrit
-- depuis le rendu visuel de cette page (vérifié à 400dpi par le contenu
-- construit), et non depuis un calque de texte. Les recommandations de
-- Q4 et Q5a SONT migrées (retranscription vérifiée visuellement, pas une
-- supposition), mais cette origine est disclosée ici pour toute relecture
-- future.
--
-- PÉRIMÈTRE — volontairement pas migrés (avis d'experts au niveau du
-- protocole global, PAS des recommandations graduées ligne par ligne,
-- cohérent avec le principe déjà appliqué ailleurs dans ce corpus) :
-- Figure 1 (Question 2, algorithme de traitement antalgique selon
-- l'intensité de la douleur, transcrite depuis un diagramme de la page 7)
-- et Figure 2 (Question 3/4, algorithme d'intubation trachéale en urgence,
-- transcrite depuis la page 9 rasterisée) — synoptiques restatant le
-- contenu déjà couvert par les recommandations textuelles graduées. Champ
-- explicitement exclu par la source elle-même : sédation de l'état de mal
-- épileptique et des états d'agitation aiguë psychiatrique (référentiels
-- dédiés), sédation pour imagerie, analgésie-sédation en bloc opératoire
-- (disclosure de portée, pas une omission de ma part). Question 7
-- (prérequis et formation, prose narrative organisationnelle sans chip de
-- grade individuel) volontairement pas migrée — un seul paragraphe
-- continu sans structure Thème/Recommandation/Grade.
--
-- POPULATION : les 44 recommandations des sous-questions pédiatriques
-- explicites (Q6 1/2, Q6 2/2, Surveillance SOAPME) taguées `population =
-- 'Pédiatrie'` ; le reste (Q1-Q5, adulte par défaut, y compris Q5d Femme
-- enceinte qui reste une population adulte au sens de ce champ) laissé
-- NULL.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFAR et SFMU (toutes deux dans le seed Annexe B) liées en
--    document_societies.
-- 2. Document volumineux (160 recommandations) extrait par script Python
--    (walk programmatique du JSON), contrôlé par inventaire exhaustif et
--    tally avant écriture du SQL final (39+8+45+11+57=160, cohérent).
-- 3. Type de document divergent disclosé : `library_final.json` classe ce
--    document `"exact_type": "CE"` (Conférence d'experts), mais le
--    contenu construit le décrit lui-même comme une "Recommandations
--    Formalisées d'Experts SFAR-SFMU" (réactualisation de la Conférence
--    d'experts SFAR de 1999) — `doc_type = 'RFE'` retenu, conforme à
--    l'auto-description du document 2010 lui-même (la CE de 1999 est son
--    prédécesseur, pas ce document-ci) ; divergence non résolue.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Sédation et analgésie en structure d''urgence',
  'RFE', 'fr', '2010-01-01',
  'https://sfar.org/sedation-analgesie-structure-durgence/',
  'https://sfar.org/wp-content/uploads/2016/01/2_AFAR_Sedation-analgesie-en-structure-d-urgence.pdf',
  'GRADE adaptée à 3 niveaux (disclosure explicite de la source, méthode classique GRADE adaptée faute d''études de haut niveau suffisantes) : Niveau 1 (1+/1-, preuve élevée), Niveau 2 (2+/2-, preuve modérée), Niveau 3 (AE, preuve faible/absente). "Accord faible" signalé explicitement par la source pour certaines recommandations, reproduit entre parenthèses dans le statement. 160 recommandations (39×1+, 8×1-, 45×2+, 11×2-, 57×AE), comptage direct sans total officiel source à réconcilier.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/sedation-analgesie-structure-durgence/'
  and s.acronym in ('SFAR', 'SFMU') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/sedation-analgesie-structure-durgence/'
  and s.slug in ('anesthesie_reanimation', 'medecine_d_urgence', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.source_section,
  'https://sfar.org/sedation-analgesie-structure-durgence/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000043-R001', 'Un nombre restreint d''agents sédatifs et analgésiques doit être sélectionné pour l''utilisation en urgence.', 'AE', null, 'Question 1 — Pharmacologie des agents utilisés en urgence (Principe) [Réf. 1]'),
  ('MG-ANES-000043-R002', 'Adapter la posologie de tout agent anesthésique/sédatif (tous dépresseurs cardiovasculaires et respiratoires) à la situation d''urgence, en se basant sur la titration, sauf pour les médicaments de l''induction en séquence rapide (ISR).', '2+', null, 'Question 1 — Pharmacologie des agents utilisés en urgence (Titration) [Réf. 2]'),
  ('MG-ANES-000043-R003', 'Administrer 0,1 à 0,3 mg/kg IV pour l''analgésie d''un patient en ventilation spontanée.', '2+', null, 'Question 1 — Pharmacologie des agents utilisés en urgence (Kétamine) [Réf. 3]'),
  ('MG-ANES-000043-R004', 'Administrer 0,1 à 0,2 mg/kg IV pour une coanalgésie en association avec un morphinique.', 'AE', null, 'Question 1 — Pharmacologie des agents utilisés en urgence (Kétamine) [Réf. 4]'),
  ('MG-ANES-000043-R005', 'Administrer 2 à 3 mg/kg IV pour faciliter l''intubation trachéale.', '2+', null, 'Question 1 — Pharmacologie des agents utilisés en urgence (Kétamine — intubation) [Réf. 5]'),
  ('MG-ANES-000043-R006', 'En dehors du MEOPA (mélange équimoléculaire oxygène-protoxyde d''azote, agent analgésique intéressant en médecine d''urgence), les autres agents anesthésiques par inhalation ne sont pas recommandés en situation d''urgence.', '2-', null, 'Question 1 — Pharmacologie des agents utilisés en urgence (Agents inhalés autres) [Réf. 6]'),
  ('MG-ANES-000043-R007', 'L''utilisation des salicylés (aspirine) n''est pas recommandée.', '2-', null, 'Question 1 — Pharmacologie des agents utilisés en urgence (Salicylés) [Réf. 7]'),
  ('MG-ANES-000043-R008', 'Administrer la morphine en bolus titrés par voie intraveineuse (opiacé de référence pour les douleurs aiguës sévères en ventilation spontanée).', '2+', null, 'Question 1 — Pharmacologie des agents utilisés en urgence (Morphine) [Réf. 8]'),
  ('MG-ANES-000043-R009', 'Les opiacés agonistes partiels et agonistes-antagonistes ont un effet-plafond rapide et n''ont pas moins d''effets secondaires que la morphine à doses équi-analgésiques (pas d''avantage démontré).', 'AE', null, 'Question 1 — Pharmacologie des agents utilisés en urgence (Agonistes-antagonistes) [Réf. 9]'),
  ('MG-ANES-000043-R010', 'Curare dépolarisant, délai d''action 60-90 s. Contre-indications : hyperkaliémie connue/suspectée, antécédents d''allergie ou d''hyperthermie maligne/myopathie, plaie du globe oculaire, dénervation étendue (hémi/para/tétraplégie), brûlé grave après 24h, rhabdomyolyse.', 'AE', null, 'Question 1 — Pharmacologie des agents utilisés en urgence (Succinylcholine) [Réf. 10]'),
  ('MG-ANES-000043-R011', 'Curare non dépolarisant d''action rapide (1,2 mg/kg → conditions d''intubation proches de la succinylcholine en 60-90 s, durée ≥ 50 min) ; antagonisable par sugammadex (16 mg/kg), le rendant utilisable pour l''ISR en cas de contre-indication à la succinylcholine.', 'AE', null, 'Question 1 — Pharmacologie des agents utilisés en urgence (Rocuronium) [Réf. 11]'),
  ('MG-ANES-000043-R012', 'Ne se conçoit que chez un patient intubé, ventilé et correctement sédaté (sauf rocuronium en alternative à la succinylcholine).', 'AE', null, 'Question 1 — Pharmacologie des agents utilisés en urgence (Curares non dépolarisants) [Réf. 12]'),
  ('MG-ANES-000043-R013', 'Traiter toute douleur aiguë en urgence, quelle que soit la pathologie, dès le début de la prise en charge ; prévenir et traiter les douleurs induites par les soins.', '1+', null, 'Question 2 (1/2) — Ventilation spontanée : évaluation & objectifs (Principe) [Réf. 13]'),
  ('MG-ANES-000043-R014', 'Évaluer l''intensité de la douleur dès le début de la prise en charge, après mise en œuvre des mesures non médicamenteuses (information, immobilisation, prévention de l''hypothermie, cryothérapie si besoin).', '1+', null, 'Question 2 (1/2) — Ventilation spontanée : évaluation & objectifs (Évaluation initiale) [Réf. 14]'),
  ('MG-ANES-000043-R015', 'Le traitement de la douleur en urgence doit reposer sur des protocoles, associés à une formation des équipes et des évaluations régulières des pratiques (EPP).', '1+', null, 'Question 2 (1/2) — Ventilation spontanée : évaluation & objectifs (Protocoles) [Réf. 15]'),
  ('MG-ANES-000043-R016', 'Réévaluer l''intensité de la douleur pour apprécier l''efficacité des thérapeutiques, avec des échelles d''autoévaluation (EVA, échelle numérique EN) chez l''adulte communicant.', '1+', null, 'Question 2 (1/2) — Ventilation spontanée : évaluation & objectifs (Réévaluation) [Réf. 16]'),
  ('MG-ANES-000043-R017', 'Si EVA/EN non réalisables, utiliser l''échelle verbale simple à cinq niveaux.', 'AE', null, 'Question 2 (1/2) — Ventilation spontanée : évaluation & objectifs (Échelle verbale simple) [Réf. 17]'),
  ('MG-ANES-000043-R018', 'Si l''autoévaluation n''est pas réalisable : échelles ECPA ou Algoplus proposées pour les personnes âgées (il n''existe pas d''échelle validée chez l''adulte non communicant, accord faible).', 'AE', null, 'Question 2 (1/2) — Ventilation spontanée : évaluation & objectifs (Hétéro-évaluation) [Réf. 18]'),
  ('MG-ANES-000043-R019', 'Utiliser le questionnaire DN4 pour rechercher une douleur neuropathique.', 'AE', null, 'Question 2 (1/2) — Ventilation spontanée : évaluation & objectifs (Douleur neuropathique) [Réf. 19]'),
  ('MG-ANES-000043-R020', 'Évaluer le niveau de sédation.', '1+', null, 'Question 2 (1/2) — Ventilation spontanée : évaluation & objectifs (Niveau de sédation) [Réf. 20]'),
  ('MG-ANES-000043-R021', 'Utiliser un score de sédation adapté à la médecine d''urgence (Ramsay, EDS ou ATICE).', 'AE', null, 'Question 2 (1/2) — Ventilation spontanée : évaluation & objectifs (Score de sédation) [Réf. 21]'),
  ('MG-ANES-000043-R022', 'Cibler EVA ≤ 30 mm ou EN ≤ 3, avec un score de sédation Ramsay = 2, EDS < 2 ou ATICE ≥ 4.', '2+', null, 'Question 2 (1/2) — Ventilation spontanée : évaluation & objectifs (Objectifs thérapeutiques) [Réf. 22]'),
  ('MG-ANES-000043-R023', 'Utiliser les techniques d''anesthésie locale et/ou locorégionale lorsqu''elles sont indiquées et réalisables.', '1+', null, 'Question 2 (1/2) — Ventilation spontanée : évaluation & objectifs (ALR) [Réf. 23]'),
  ('MG-ANES-000043-R024', 'Traiter les douleurs faibles à modérées par des antalgiques de palier I ou II, seuls ou en association.', '1+', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Paliers I/II) [Réf. 24]'),
  ('MG-ANES-000043-R025', 'Utiliser le MEOPA en traumatologie légère et pour les douleurs induites par les soins.', '2+', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (MEOPA) [Réf. 25]'),
  ('MG-ANES-000043-R026', 'Pour les douleurs intenses (EVA ≥ 60 mm ou EN ≥ 6), recourir d''emblée aux morphiniques intraveineux en titration, seuls ou en analgésie multimodale.', '1+', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Douleurs intenses) [Réf. 26]'),
  ('MG-ANES-000043-R027', 'Ne pas administrer les morphiniques de type agonistes-antagonistes ou agonistes partiels.', '2-', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Agonistes-antagonistes) [Réf. 27]'),
  ('MG-ANES-000043-R028', 'Protocole de titration IV en morphine par bolus de 2 mg (patient < 60 kg) à 3 mg (patient ≥ 60 kg) toutes les 5 minutes, applicable à toutes les situations d''urgence y compris chez les sujets âgés. Un bolus initial rapporté au poids (0,05-0,1 mg/kg) peut être autorisé chez certains patients ciblés, sous surveillance médicale permanente prolongée (accord faible) — pas d''argument scientifique pour le recommander largement.', '2+', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Titration morphine) [Réf. 28]'),
  ('MG-ANES-000043-R029', 'Non recommandés pour l''analgésie du patient en ventilation spontanée (rémifentanil et alfentanil insuffisamment évalués dans ce contexte).', '2-', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Fentanyl/sufentanil VS) [Réf. 29]'),
  ('MG-ANES-000043-R030', 'Privilégier les associations d''antalgiques (analgésie multimodale).', '2+', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Multimodale) [Réf. 30]'),
  ('MG-ANES-000043-R031', 'En traumatologie : MEOPA, kétamine, néfopam et/ou ALR en association à la morphine.', 'AE', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Multimodale — traumatologie) [Réf. 31]'),
  ('MG-ANES-000043-R032', 'Néfopam et/ou kétamine à faible posologie, en association aux antalgiques usuels (accord faible).', 'AE', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Douleur neuropathique aiguë) [Réf. 32]'),
  ('MG-ANES-000043-R033', 'Diffuser plus largement les techniques d''ALR (bloc iliofascial, blocs au poignet, à la cheville, blocs de la face).', 'AE', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (ALR diffusion) [Réf. 33]'),
  ('MG-ANES-000043-R034', 'En cas de titration IV morphinique : surveillance clinique systématique (score de sédation EDS, fréquence respiratoire), complétée selon les cas par surveillance hémodynamique et SpO2.', 'AE', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Surveillance titration) [Réf. 34]'),
  ('MG-ANES-000043-R035', 'Mettre en place des procédures précisant les modalités d''interruption de la titration voire l''utilisation d''antagonistes.', '2+', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Procédures d''alerte) [Réf. 35]'),
  ('MG-ANES-000043-R036', 'Administrer la naloxone en titration par bolus réitérés de 0,04 mg IV si sédation excessive (EDS > 2), apnée, bradypnée < 10/min ou désaturation.', '1+', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Naloxone) [Réf. 36]'),
  ('MG-ANES-000043-R037', 'Dropéridol (1,25 mg IV) ou antagonistes 5HT3 (ondansétron 4 mg IV) pour prévention/traitement des nausées-vomissements liés à la titration morphinique (accord faible).', 'AE', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Nausées-vomissements) [Réf. 37]'),
  ('MG-ANES-000043-R038', 'Sortie vers un service non monitoré autorisée au plus tôt 1h après la dernière injection IV de morphine ; aptitude à la rue au plus tôt 2h après.', 'AE', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Sortie du SAU) [Réf. 38]'),
  ('MG-ANES-000043-R039', 'Initier le relais analgésique après la titration morphinique avant la récidive douloureuse.', '2+', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Relais analgésique) [Réf. 39]'),
  ('MG-ANES-000043-R040', 'Un protocole de relais tenant compte du potentiel évolutif douloureux et de l''efficacité observée au SAU est proposé.', 'AE', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Relais — protocole) [Réf. 40]'),
  ('MG-ANES-000043-R041', 'Si relais morphinique envisagé : privilégier PCA ou voie sous-cutanée (données insuffisantes pour recommander la voie orale, accord faible).', 'AE', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Relais — voie) [Réf. 41]'),
  ('MG-ANES-000043-R042', 'Favoriser molécules à pharmacocinétique rapide, MEOPA, anesthésie locale et/ou locorégionale dès que possible.', 'AE', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Douleurs induites par les soins) [Réf. 42]'),
  ('MG-ANES-000043-R043', 'Ne pas associer à la titration morphinique une sédation par benzodiazépines (potentialisation des effets secondaires).', '2-', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Benzodiazépines + morphine) [Réf. 43]'),
  ('MG-ANES-000043-R044', 'Sauf agitation persistante malgré analgésie bien conduite : réserver alors le midazolam en titration IV par bolus de 1 mg, sous stricte surveillance (accord faible).', 'AE', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Agitation persistante) [Réf. 44]'),
  ('MG-ANES-000043-R045', 'Chez le patient sous morphiniques au long cours ou toxicomane, ne pas interrompre brutalement les traitements morphiniques sans relais.', '1-', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Toxicomanie) [Réf. 45]'),
  ('MG-ANES-000043-R046', 'Privilégier la co-analgésie, l''administration de kétamine, ainsi que l''ALR, en complément de la titration morphinique.', 'AE', null, 'Question 2 (2/2) — Ventilation spontanée : traitement & surveillance (Toxicomanie — alternatives) [Réf. 46]'),
  ('MG-ANES-000043-R047', 'Administrer une sédation pour toutes les indications de l''intubation trachéale, excepté chez le patient en arrêt cardiaque (pas de sédation nécessaire).', '2+', null, 'Question 3 — Intubation sous ISR et sous anesthésie locale (Sédation systématique) [Réf. 47]'),
  ('MG-ANES-000043-R048', 'Si intubation présumée difficile : anesthésie locale de proche en proche possible, associée ou non à une sédation légère et titrée par voie générale.', 'AE', null, 'Question 3 — Intubation sous ISR et sous anesthésie locale (Intubation vigile) [Réf. 48]'),
  ('MG-ANES-000043-R049', 'Utiliser les techniques d''ISR associant un hypnotique d''action rapide (étomidate ou kétamine) et un curare d''action brève (succinylcholine).', '2+', null, 'Question 3 — Intubation sous ISR et sous anesthésie locale (Choix ISR) [Réf. 49]'),
  ('MG-ANES-000043-R050', 'Thiopental (5 mg/kg) comme hypnotique pour l''ISR chez le patient hémodynamiquement stable, dans l''attente de l''actualisation de la Conférence de Consensus dédiée.', '2+', null, 'Question 3 — Intubation sous ISR et sous anesthésie locale (État de mal épileptique) [Réf. 50]'),
  ('MG-ANES-000043-R051', 'En cas de contre-indication à la succinylcholine : rocuronium (1,2 mg/kg IVL), sous réserve de pouvoir l''antagoniser par sugammadex (16 mg/kg IVL) en cas d''échec de l''intubation.', 'AE', null, 'Question 3 — Intubation sous ISR et sous anesthésie locale (Rocuronium alternatif) [Réf. 51]'),
  ('MG-ANES-000043-R052', 'Évaluer le rapport bénéfice/risque avant la procédure, compte tenu des risques de tentatives infructueuses et de l''utilisation des médicaments anesthésiques.', '2+', null, 'Question 3 — Intubation sous ISR et sous anesthésie locale (Bénéfice/risque) [Réf. 52]'),
  ('MG-ANES-000043-R053', 'Traiter les effets hémodynamiques liés à la sédation par expansion volémique et éphédrine (bolus de 3-6 mg IVD) ; chez le patient hypovolémique/vasoplégique, recourir d''emblée aux catécholamines type noradrénaline.', '2+', null, 'Question 3 — Intubation sous ISR et sous anesthésie locale (Effets hémodyn.) [Réf. 53]'),
  ('MG-ANES-000043-R054', 'La sédation chez le patient ventilé en structure d''urgence doit débuter immédiatement après la réalisation de l''intubation trachéale.', '1+', null, 'Question 4 — Patient intubé-ventilé (Début immédiat) [Réf. 54]'),
  ('MG-ANES-000043-R055', 'Des protocoles écrits et validés doivent être disponibles au sein de chaque structure, précisant les médicaments à utiliser, leurs modes d''administration et les éléments de monitorage.', '1+', null, 'Question 4 — Patient intubé-ventilé (Protocoles) [Réf. 55]'),
  ('MG-ANES-000043-R056', 'Midazolam et propofol pour les hypnotiques, fentanyl et sufentanil pour les antalgiques, sont les médicaments les plus adaptés chez le patient ventilé.', 'AE', null, 'Question 4 — Patient intubé-ventilé (Molécules) [Réf. 56]'),
  ('MG-ANES-000043-R057', 'Il est possible de débuter la sédation-analgésie par la prescription d''un bolus, préférentiellement de morphinique.', 'AE', null, 'Question 4 — Patient intubé-ventilé (Bolus initial) [Réf. 57]'),
  ('MG-ANES-000043-R058', 'Le monitorage des patients sédatés doit comporter au minimum la surveillance électrocardioscopique, de la pression artérielle non invasive, de la SpO2, des pressions inspiratoires et expiratoires, des données spirométriques et de la capnographie.', '1+', null, 'Question 4 — Patient intubé-ventilé (Monitorage) [Réf. 58]'),
  ('MG-ANES-000043-R059', 'Optimiser la sédation avant d''envisager le recours à une curarisation pour faciliter la ventilation mécanique, sous réserve d''avoir éliminé une complication de celle-ci.', '2+', null, 'Question 4 — Patient intubé-ventilé (Curarisation) [Réf. 59]'),
  ('MG-ANES-000043-R060', 'Si la curarisation est indiquée, éviter les agents les plus histamino-libérateurs au profit d''agents comme le cisatracurium, le vécuronium ou le rocuronium (accord faible).', '1+', null, 'Question 4 — Patient intubé-ventilé (Curarisation — choix) [Réf. 60]'),
  ('MG-ANES-000043-R061', 'Le rapport bénéfice/risque de la sédation-analgésie et de la ventilation mécanique doit être posé, en raison des effets hémodynamiques des agents et de la ventilation, en particulier chez le patient hypovolémique et/ou en tamponade.', '1+', null, 'Question 5a — Circonstances particulières : état de choc (Principe) [Réf. 61]'),
  ('MG-ANES-000043-R062', 'Diminuer les posologies des médicaments administrés chez le patient en état de choc.', '1+', null, 'Question 5a — Circonstances particulières : état de choc (Posologies) [Réf. 62]'),
  ('MG-ANES-000043-R063', 'Étomidate ou kétamine (posologies diminuées) pour l''induction du patient en état de choc.', '2+', null, 'Question 5a — Circonstances particulières : état de choc (Induction) [Réf. 63]'),
  ('MG-ANES-000043-R064', 'Ne pas utiliser le propofol ou le thiopental pour l''induction (effets hémodynamiques marqués) ; midazolam et gamma-hydroxybutyrate de sodium non recommandés (pharmacocinétique).', '2-', null, 'Question 5a — Circonstances particulières : état de choc (Induction — à éviter) [Réf. 64]'),
  ('MG-ANES-000043-R065', 'Conserver une ventilation spontanée si possible ; si intubation nécessaire, l''effectuer en position demi-assise et en ventilation spontanée — kétamine particulièrement adaptée.', '2+', null, 'Question 5a — Circonstances particulières : état de choc (Tamponade) [Réf. 65]'),
  ('MG-ANES-000043-R066', 'Si l''état de choc n''a pu être corrigé avant l''induction, anticiper les effets hémodynamiques délétères par expansion volémique et/ou catécholamines.', '1+', null, 'Question 5a — Circonstances particulières : état de choc (Choc non corrigé) [Réf. 66]'),
  ('MG-ANES-000043-R067', 'Administration continue d''un morphinique (fentanyl ou sufentanil), associée si nécessaire à du midazolam à faible posologie (accord faible).', '2+', null, 'Question 5a — Circonstances particulières : état de choc (Entretien) [Réf. 67]'),
  ('MG-ANES-000043-R068', 'Utiliser les benzodiazépines avec précaution (effet vasoplégiant, hypotension d''autant plus marquée que le patient est en état de choc).', '2+', null, 'Question 5a — Circonstances particulières : état de choc (Benzodiazépines) [Réf. 68]'),
  ('MG-ANES-000043-R069', 'Kétamine + midazolam peut remplacer le morphinique, voire kétamine seule pour la sédation du patient intubé-ventilé ; kétamine + morphinique possible pour la sédation continue en état de choc (accord faible).', 'AE', null, 'Question 5a — Circonstances particulières : état de choc (Kétamine alternative) [Réf. 69]'),
  ('MG-ANES-000043-R070', 'Ne pas utiliser les barbituriques comme agent de sédation en urgence, en dehors de l''état de mal épileptique.', '1-', null, 'Question 5b — Atteinte neurologique aiguë (Barbituriques) [Réf. 70]'),
  ('MG-ANES-000043-R071', 'Midazolam, ou en alternative propofol, pour l''entretien de la sédation, dans l''attente de l''actualisation de la Conférence de Consensus dédiée.', '2+', null, 'Question 5b — Atteinte neurologique aiguë (État de mal épileptique) [Réf. 71]'),
  ('MG-ANES-000043-R072', 'Association midazolam + fentanyl ou sufentanil en administration continue pour la sédation-analgésie.', '2+', null, 'Question 5b — Atteinte neurologique aiguë (Intubé-ventilé) [Réf. 72]'),
  ('MG-ANES-000043-R073', 'Propofol en administration continue possible pour faciliter une réévaluation neurologique répétée, sous réserve de respecter les objectifs de pression de perfusion cérébrale ; kétamine + hypnotique possible, notamment en cas d''instabilité hémodynamique (intérêt neuroprotecteur potentiel).', 'AE', null, 'Question 5b — Atteinte neurologique aiguë (Réévaluation neuro) [Réf. 73]'),
  ('MG-ANES-000043-R074', 'L''association midazolam-morphinique peut être remplacée par la kétamine seule (accord faible).', 'AE', null, 'Question 5b — Atteinte neurologique aiguë (Kétamine seule) [Réf. 74]'),
  ('MG-ANES-000043-R075', 'Ne pas effectuer de curarisation systématique en entretien.', '1-', null, 'Question 5b — Atteinte neurologique aiguë (Curarisation entretien) [Réf. 75]'),
  ('MG-ANES-000043-R076', 'Dans la prise en charge initiale d''un traumatisme crânien grave, l''indication d''une curarisation associée à la sédation peut être large (accord faible).', 'AE', null, 'Question 5b — Atteinte neurologique aiguë (Curarisation préhospitalière) [Réf. 76]'),
  ('MG-ANES-000043-R077', 'Effectuer une curarisation pour éviter le frisson lors de l''induction d''une hypothermie après anoxie cérébrale aiguë.', '2+', null, 'Question 5b — Atteinte neurologique aiguë (Frisson post-anoxie) [Réf. 77]'),
  ('MG-ANES-000043-R078', 'Poursuivre la sédation après intubation pour assurer le confort, l''adaptation au respirateur et réduire les lésions liées à la ventilation mécanique.', 'AE', null, 'Question 5c — Insuffisance respiratoire aiguë (Poursuite de sédation) [Réf. 78]'),
  ('MG-ANES-000043-R079', 'Agent aux propriétés bronchodilatatrices (propofol ou kétamine) possible chez le patient en état de mal asthmatique ventilé.', 'AE', null, 'Question 5c — Insuffisance respiratoire aiguë (Asthme aigu grave) [Réf. 79]'),
  ('MG-ANES-000043-R080', 'La réduction du volume courant n''impose pas d''augmentation systématique des posologies d''agents sédatifs.', 'AE', null, 'Question 5c — Insuffisance respiratoire aiguë (SDRA) [Réf. 80]'),
  ('MG-ANES-000043-R081', 'Curarisation possible lors de la phase initiale de la sédation-analgésie (accord faible).', 'AE', null, 'Question 5c — Insuffisance respiratoire aiguë (Curarisation initiale) [Réf. 81]'),
  ('MG-ANES-000043-R082', 'Curarisation en continu recommandée en cas de difficulté pour ventiler le patient, sous réserve d''avoir éliminé une complication de la ventilation mécanique.', '2+', null, 'Question 5c — Insuffisance respiratoire aiguë (Curarisation continue) [Réf. 82]'),
  ('MG-ANES-000043-R083', 'Choisir des molécules anciennes, très largement utilisées, sans effet tératogène démontré chez l''animal ni en clinique.', '1+', null, 'Question 5d — Femme enceinte (Choix des molécules) [Réf. 83]'),
  ('MG-ANES-000043-R084', 'En cas de détresse vitale immédiate, le pronostic maternel prime — aucune contre-indication formelle n''est opposable si le bénéfice escompté est évident.', 'AE', null, 'Question 5d — Femme enceinte (Urgence vitale) [Réf. 84]'),
  ('MG-ANES-000043-R085', 'Ne pas utiliser les techniques d''ALR (notamment péridurale) en dehors d''un environnement adapté (maternité, salle d''opération).', '2-', null, 'Question 5d — Femme enceinte (ALR péridurale) [Réf. 85]'),
  ('MG-ANES-000043-R086', 'Utiliser le MEOPA en première intention et de manière large pour l''analgésie lors du travail obstétrical (efficacité prouvée à tous les stades, pas de complication materno-fœtale connue).', '2+', null, 'Question 5d — Femme enceinte (MEOPA travail) [Réf. 86]'),
  ('MG-ANES-000043-R087', 'Morphine IV titrée possible en cas d''accouchement imminent, en anticipant les effets secondaires respiratoires néonataux.', 'AE', null, 'Question 5d — Femme enceinte (Accouchement imminent) [Réf. 87]'),
  ('MG-ANES-000043-R088', 'Paracétamol PO/IV pour les douleurs autres (traumatiques ou médicales) — l''un des meilleurs profils de tolérance connus.', 'AE', null, 'Question 5d — Femme enceinte (Paracétamol) [Réf. 88]'),
  ('MG-ANES-000043-R089', 'Ne pas administrer d''AINS lors des 1er et 3e trimestres de la grossesse.', '1-', null, 'Question 5d — Femme enceinte (AINS) [Réf. 89]'),
  ('MG-ANES-000043-R090', 'Morphine titrée recommandée pour la douleur sévère à tous les stades de la grossesse, hors accouchement imminent (ALR privilégiée dès que réalisable).', '2+', null, 'Question 5d — Femme enceinte (Douleur sévère) [Réf. 90]'),
  ('MG-ANES-000043-R091', 'Prévenir et traiter toutes les douleurs induites par les soins (réalignements de membre fracturé, réductions de luxation), en informant le patient si possible du déroulement et des risques.', '1+', null, 'Question 5e — Réalisation d''actes douloureux (Prévention) [Réf. 91]'),
  ('MG-ANES-000043-R092', 'Techniques d''analgésie locale ou locorégionale lorsqu''elles sont possibles.', 'AE', null, 'Question 5e — Réalisation d''actes douloureux (ALR) [Réf. 92]'),
  ('MG-ANES-000043-R093', 'Morphine en titration IV, associée à MEOPA et/ou kétamine (0,5-1 mg/kg IV en titration), chez le patient vigile ; midazolam en complément possible (potentialisation des effets respiratoires/hémodynamiques à anticiper, surveillance prolongée, accord faible). Alfentanil possible mais insuffisamment documenté.', 'AE', null, 'Question 5e — Réalisation d''actes douloureux (Réalignement/réduction) [Réf. 93]'),
  ('MG-ANES-000043-R094', 'Si sédation profonde nécessaire (ex. réduction de luxation) : recours à un médecin anesthésiste-réanimateur privilégié ; à défaut, propofol lent et titré à faible posologie (1-1,5 mg/kg IV, à diminuer chez le sujet âgé/fragile), comme alternative à l''ISR classique.', 'AE', null, 'Question 5e — Réalisation d''actes douloureux (Sédation profonde) [Réf. 94]'),
  ('MG-ANES-000043-R095', 'En présence d''un arrêt circulatoire (tachycardie sans pouls, ou arrêt cardiaque survenant devant l''équipe) : effectuer immédiatement le CEE, sans sédation préalable.', '1+', null, 'Question 5f — Choc électrique externe (CEE) (ACR) [Réf. 95]'),
  ('MG-ANES-000043-R096', 'Pratiquer une sédation avant d''effectuer le CEE chez le patient conscient.', '2+', null, 'Question 5f — Choc électrique externe (CEE) (Patient conscient) [Réf. 96]'),
  ('MG-ANES-000043-R097', 'Si tachycardie responsable d''une décompensation avec espoir de retour à l''état antérieur : CEE sous sédation brève, propofol lent et titré à faible posologie (0,5-0,8 mg/kg IV — meilleur rapport bénéfice/risque, utilisé hors AMM après formation dédiée).', 'AE', null, 'Question 5f — Choc électrique externe (CEE) (Sédation brève) [Réf. 97]'),
  ('MG-ANES-000043-R098', 'Midazolam en titration IV, suivi ou non d''une réversion par flumazénil IV continu, en alternative au propofol (accord faible).', 'AE', null, 'Question 5f — Choc électrique externe (CEE) (Alternative midazolam) [Réf. 98]'),
  ('MG-ANES-000043-R099', 'Dans les situations à haut risque (obésité, grossesse, hernie hiatale, diabète, repas récent) : évaluer le rapport bénéfice/risque d''une ISR avec intubation orotrachéale.', 'AE', null, 'Question 5f — Choc électrique externe (CEE) (Risque de régurgitation) [Réf. 99]'),
  ('MG-ANES-000043-R100', 'Si tachycardie dans un contexte de défaillance cardiaque gauche aiguë non directement responsable : ISR selon les modalités habituelles, CEE, puis maintien sous ventilation mécanique pour traiter la défaillance (notamment infarctus aigu, angioplastie).', '2+', null, 'Question 5f — Choc électrique externe (CEE) (Défaillance cardiaque gauche) [Réf. 100]'),
  ('MG-ANES-000043-R101', 'Administrer de l''oxygène ; matériel d''aspiration, de ventilation, d''intubation et naloxone immédiatement disponibles ; envisager l''analgésie/sédation au plus tôt.', '1+', null, 'Question 5g — Patient incarcéré (Fonctions vitales) [Réf. 101]'),
  ('MG-ANES-000043-R102', 'Tolérer une douleur modérée pendant la désincarcération plutôt que de rechercher une analgésie totale exposant à hypoventilation/perte des réflexes de protection des voies aériennes (accord faible).', 'AE', null, 'Question 5g — Patient incarcéré (Douleur tolérée) [Réf. 102]'),
  ('MG-ANES-000043-R103', 'Chez le blessé conscient : morphine IV en titration par bolus répétés de 2-3 mg toutes les 5 min, sous surveillance de la fréquence respiratoire et de la SpO2.', '2+', null, 'Question 5g — Patient incarcéré (Morphine) [Réf. 103]'),
  ('MG-ANES-000043-R104', 'Toujours évaluer le rapport bénéfice/risque d''une intubation précoce (potentiellement difficile chez l''incarcéré) versus une intubation temporisée réalisée après extraction en décubitus dorsal.', '1+', null, 'Question 5g — Patient incarcéré (Intubation précoce) [Réf. 104]'),
  ('MG-ANES-000043-R105', 'Chez un patient comateux, assis, sans signe de décortication/décérébration ni hypoventilation, si la désincarcération va être rapide : temporiser l''intubation pour la réaliser en décubitus dorsal.', '2+', null, 'Question 5g — Patient incarcéré (Patient comateux stable) [Réf. 105]'),
  ('MG-ANES-000043-R106', 'Technique de sauvetage dans certaines situations extrêmes (patient non allongeable), pratiquée par des opérateurs expérimentés — ne peut pas être recommandée en routine.', '2-', null, 'Question 5g — Patient incarcéré (Intubation « au piolet ») [Réf. 106]'),
  ('MG-ANES-000043-R107', 'Non contre-indiquée à la phase initiale (< 6h) de la prise en charge d''un patient incarcéré.', 'AE', null, 'Question 5g — Patient incarcéré (Succinylcholine) [Réf. 107]'),
  ('MG-ANES-000043-R108', 'Réaliser une anesthésie générale (procédure d''induction/entretien sans particularité par rapport au patient non incarcéré, sous réserve d''accessibilité aux voies aériennes supérieures) ; au mieux par une équipe chirurgicale complète.', '2+', null, 'Question 5g — Patient incarcéré (Amputation de sauvetage) [Réf. 108]'),
  ('MG-ANES-000043-R109', 'En cas d''afflux saturant, un triage préalable est nécessaire pour réserver l''analgésie/sédation aux blessés devant en bénéficier en priorité ; débuter par des mesures non spécifiques (communication, immobilisation, extraction rapide, réchauffement).', 'AE', null, 'Question 5h — Afflux de victimes (Triage) [Réf. 109]'),
  ('MG-ANES-000043-R110', 'Antalgique de palier 2 par voie orale pour les douleurs modérées (30 ≤ EVA < 60 mm, 3 ≤ EN < 6) (accord faible).', 'AE', null, 'Question 5h — Afflux de victimes (Douleur modérée) [Réf. 110]'),
  ('MG-ANES-000043-R111', 'Morphine par voie sous-cutanée (0,1 mg/kg, soit 5-10 mg adulte, analgésie 4-6h) pour les blessés stables.', 'AE', null, 'Question 5h — Afflux de victimes (Douleur intense — blessés stables) [Réf. 111]'),
  ('MG-ANES-000043-R112', 'La voie orale n''est pas recommandée (délai d''action, biodisponibilité imprévisible).', '2-', null, 'Question 5h — Afflux de victimes (Douleur intense — voie orale) [Réf. 112]'),
  ('MG-ANES-000043-R113', 'Titration intraveineuse selon les modalités classiques pour les blessés instables (généralement déjà équipés d''une voie veineuse).', '2+', null, 'Question 5h — Afflux de victimes (Douleur intense — blessés instables) [Réf. 113]'),
  ('MG-ANES-000043-R114', 'Hydroxyzine comme anxiolytique (pas d''effet dépresseur respiratoire notable, pas de surveillance spécifique requise) — voie orale, IM ou IVL, ~1 mg/kg.', 'AE', null, 'Question 5h — Afflux de victimes (Anxiolyse) [Réf. 114]'),
  ('MG-ANES-000043-R115', 'Kétamine pour la sédation-analgésie de gestes courts sur le terrain (réalignement, réduction) : 0,25-0,50 mg/kg en titration IV par bolus de 5-10 mg, éventuellement associée à du midazolam en titration IV.', 'AE', null, 'Question 5h — Afflux de victimes (Gestes courts) [Réf. 115]'),
  ('MG-ANES-000043-R116', 'Mettre en balance la nécessité d''une intubation versus sa temporisation, compte tenu des contraintes organisationnelles/logistiques des patients intubés-ventilés en situation d''afflux.', 'AE', null, 'Question 5h — Afflux de victimes (Intubation différée) [Réf. 116]'),
  ('MG-ANES-000043-R117', 'La clairance plasmatique des benzodiazépines, de la kétamine et de l''étomidate est généralement plus élevée chez l''enfant que chez l''adulte (demi-vie d''élimination réduite).', 'AE', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (Pharmacocinét.) [Réf. 117]'),
  ('MG-ANES-000043-R118', 'Ne pas l''utiliser chez l''enfant de moins de 2 ans (AMM contre-indiquée dans cette tranche d''âge).', '1-', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (Étomidate) [Réf. 118]'),
  ('MG-ANES-000043-R119', 'Doubler la posologie (2 mg/kg) lors de l''ISR chez l''enfant de moins de 18 mois (volume de distribution accru).', '1+', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (Succinylcholine — dose) [Réf. 119]'),
  ('MG-ANES-000043-R120', 'Ne pas attendre la survenue de fasciculations pour intuber les enfants de moins de 4 ans (exceptionnelles à cet âge).', '1-', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (Succinylcholine — fasciculations) [Réf. 120]'),
  ('MG-ANES-000043-R121', 'Ne pas modifier les posologies chez les enfants de moins de 5 ans (l''augmentation du volume de distribution est compensée par une sensibilité accrue de la plaque motrice).', '1-', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (Curares non dépolarisants) [Réf. 121]'),
  ('MG-ANES-000043-R122', 'Pratiquer une analgésie, et si nécessaire une sédation, en présence de douleurs ou lorsqu''un geste invasif doit être réalisé, chez l''enfant en ventilation spontanée.', '1+', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (Analgésie systématique) [Réf. 122]'),
  ('MG-ANES-000043-R123', 'Souci permanent de l''environnement de l''enfant et de sa famille, dialogue informatif sur ce qui va être fait.', '1+', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (Environnement) [Réf. 123]'),
  ('MG-ANES-000043-R124', 'Réaliser une évaluation de la douleur.', '1+', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (Évaluation) [Réf. 124]'),
  ('MG-ANES-000043-R125', 'Autoévaluation chez l''enfant âgé de plus de 5 ans, hétéroévaluation avant cet âge.', '2+', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (Évaluation — modalité) [Réf. 125]'),
  ('MG-ANES-000043-R126', 'Pas de contre-indication à une analgésie en ventilation spontanée quel que soit l''état général (classe ASA) de l''enfant.', 'AE', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (Pas de CI par ASA) [Réf. 126]'),
  ('MG-ANES-000043-R127', 'Sédation et/ou analgésie chez l''enfant en ventilation spontanée sans indication d''intubation : douleur évidente, frayeur/angoisse/anxiété/agitation, ou geste invasif.', '2+', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (Sédation — indications) [Réf. 127]'),
  ('MG-ANES-000043-R128', 'Bon état général (ASA 1-2) requis pour bénéficier d''une sédation en ventilation spontanée (ASA 3-4 = contre-indications relatives) ; précautions particulières si estomac plein.', '1+', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (Sédation — ASA) [Réf. 128]'),
  ('MG-ANES-000043-R129', 'Traumatisme crânien en ventilation spontanée, insuffisance respiratoire, instabilité hémodynamique, troubles de conscience ou perte des réflexes de protection des voies aériennes chez un patient non intubé, allergie connue/suspectée aux agents sédatifs.', 'AE', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (Contre-indic.) [Réf. 129]'),
  ('MG-ANES-000043-R130', 'Évaluer très régulièrement le contact verbal (objectif : sédation consciente) et le noter sur la feuille de surveillance.', '1+', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (Sédation consciente) [Réf. 130]'),
  ('MG-ANES-000043-R131', 'La réalisation d''une sédation associée ou non à une analgésie doit être effectuée dans des conditions structurelles et humaines permettant de dépister rapidement les complications et d''en assurer la prise en charge optimale.', '2+', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (Conditions) [Réf. 131]'),
  ('MG-ANES-000043-R132', 'Évaluation clinique préalable, consentement éclairé des parents/de l''enfant (sauf urgence immédiate), personnel formé, respect du jeûne (ou précautions), moyens de surveillance, score de sédation continu (Ramsay/Comfort B), locaux adéquats, critères précis de retour à domicile.', '1+', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (Conditions requises) [Réf. 132]'),
  ('MG-ANES-000043-R133', 'Monothérapie en première intention, tant pour la sédation que pour l''analgésie.', '2+', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (Monothérapie) [Réf. 133]'),
  ('MG-ANES-000043-R134', 'Ne pas associer benzodiazépine et morphinique (risque de dépression respiratoire considérablement accru).', '2-', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (BZD + morphinique) [Réf. 134]'),
  ('MG-ANES-000043-R135', 'Disposer de protocoles écrits pour les actes de sédation les plus courants et connaître les antagonistes ; en cas d''échec à posologie maximale, recourir à d''autres modalités.', '1+', 'Pédiatrie', 'Question 6 (1/2) — Pédiatrie : pharmacologie & ventilation spontanée (Protocoles & antagonistes) [Réf. 135]'),
  ('MG-ANES-000043-R136', 'Topiques locaux (peau saine) pour abord veineux/artériel, ponction de chambre implantable, libération d''adhérences préputiales, ponctions lombaires.', '2+', 'Pédiatrie', 'Question 6 (2/2) — Pédiatrie : analgésie, intubation & surveillance (Topiques locaux) [Réf. 136]'),
  ('MG-ANES-000043-R137', 'Lidocaïne = anesthésique de référence ; ropivacaïne+lidocaïne pour bloc fémoral/iliofascial (analgésie prolongée 4-6h, insuffisamment documenté en urgence). Pour les blocs périphériques à circulation terminale (digital, pénien) : ne pas utiliser la lidocaïne adrénalinée.', '1-', 'Pédiatrie', 'Question 6 (2/2) — Pédiatrie : analgésie, intubation & surveillance (ALR) [Réf. 137]'),
  ('MG-ANES-000043-R138', 'Paracétamol PO/IV et/ou codéine PO.', '2+', 'Pédiatrie', 'Question 6 (2/2) — Pédiatrie : analgésie, intubation & surveillance (Douleurs légères/modérées) [Réf. 138]'),
  ('MG-ANES-000043-R139', 'Passer directement au palier III pour une efficacité rapide.', '2+', 'Pédiatrie', 'Question 6 (2/2) — Pédiatrie : analgésie, intubation & surveillance (Échec palier I / douleur sévère) [Réf. 139]'),
  ('MG-ANES-000043-R140', 'Administrer la morphine (AMM > 6 mois) PO à la dose de 0,2-0,4 mg/kg toutes les 4h ou 1-2 mg/kg/j en 6 prises (compléments possibles de 0,1-0,2 mg/kg entre les prises).', '1+', 'Pédiatrie', 'Question 6 (2/2) — Pédiatrie : analgésie, intubation & surveillance (Morphine PO) [Réf. 140]'),
  ('MG-ANES-000043-R141', 'Titration IV : injection initiale de 0,05 mg/kg, puis réinjections de 0,01 mg/kg toutes les 5-7 min jusqu''à obtention de l''analgésie désirée.', '2+', 'Pédiatrie', 'Question 6 (2/2) — Pédiatrie : analgésie, intubation & surveillance (Morphine IV) [Réf. 141]'),
  ('MG-ANES-000043-R142', '0,4 mg/kg en l''absence de voie veineuse (accord faible).', 'AE', 'Pédiatrie', 'Question 6 (2/2) — Pédiatrie : analgésie, intubation & surveillance (Nalbuphine intra-rectale) [Réf. 142]'),
  ('MG-ANES-000043-R143', 'MEOPA, midazolam ou kétamine en traitement préventif d''une procédure courte peu douloureuse mais anxiogène.', 'AE', 'Pédiatrie', 'Question 6 (2/2) — Pédiatrie : analgésie, intubation & surveillance (Prévention procédure courte) [Réf. 143]'),
  ('MG-ANES-000043-R144', 'Actes peu douloureux ≤ 30 min, enfant > 4 ans, coopérant, ASA 1-2 — associer à l''anesthésie locale et/ou aux antalgiques de palier I.', 'AE', 'Pédiatrie', 'Question 6 (2/2) — Pédiatrie : analgésie, intubation & surveillance (MEOPA — indications) [Réf. 144]'),
  ('MG-ANES-000043-R145', '0,5-1,0 mg/kg IV lente ou 3-4 mg/kg IM pour l''analgésie de gestes courts en ventilation spontanée.', '2+', 'Pédiatrie', 'Question 6 (2/2) — Pédiatrie : analgésie, intubation & surveillance (Kétamine — gestes courts) [Réf. 145]'),
  ('MG-ANES-000043-R146', 'Recours à l''ISR pour intuber les enfants en urgence, sauf arrêt cardiaque ou intubation difficile prévisible.', '2+', 'Pédiatrie', 'Question 6 (2/2) — Pédiatrie : analgésie, intubation & surveillance (ISR pédiatrique) [Réf. 146]'),
  ('MG-ANES-000043-R147', 'Étomidate chez l''enfant > 2 ans (0,3-0,4 mg/kg IV) ; kétamine chez l''enfant < 2 ans (3-4 mg/kg IV si < 18 mois, 2 mg/kg IV si plus âgé).', '2+', 'Pédiatrie', 'Question 6 (2/2) — Pédiatrie : analgésie, intubation & surveillance (Hypnotique ISR) [Réf. 147]'),
  ('MG-ANES-000043-R148', 'Curare à utiliser pour l''ISR chez l''enfant (2 mg/kg IV si < 18 mois, 1 mg/kg IV si plus âgé).', '1+', 'Pédiatrie', 'Question 6 (2/2) — Pédiatrie : analgésie, intubation & surveillance (Succinylcholine ISR) [Réf. 148]'),
  ('MG-ANES-000043-R149', 'Midazolam = agent de référence chez l''enfant intubé-ventilé.', 'AE', 'Pédiatrie', 'Question 6 (2/2) — Pédiatrie : analgésie, intubation & surveillance (Sédation intubé-ventilé) [Réf. 149]'),
  ('MG-ANES-000043-R150', 'Non recommandé en sédation continue chez l''enfant de moins de 15 ans (effets hémodynamiques, risque de syndrome de perfusion du propofol / PRIS).', '2-', 'Pédiatrie', 'Question 6 (2/2) — Pédiatrie : analgésie, intubation & surveillance (Propofol pédiatrie) [Réf. 150]'),
  ('MG-ANES-000043-R151', 'Utilisation recommandée lors du transport de l''enfant intubé-ventilé, en particulier chez l''enfant asthmatique ou brûlé.', '2+', 'Pédiatrie', 'Question 6 (2/2) — Pédiatrie : analgésie, intubation & surveillance (Kétamine transport) [Réf. 151]'),
  ('MG-ANES-000043-R152', 'Fentanyl ou sufentanil chez l''enfant intubé-ventilé, en association avec le midazolam (perfusion continue).', '2+', 'Pédiatrie', 'Question 6 (2/2) — Pédiatrie : analgésie, intubation & surveillance (Morphiniques intubé-ventilé) [Réf. 152]'),
  ('MG-ANES-000043-R153', 'Disposer de matériel d''aspiration à dépression réglable et de sondes adaptées à l''âge.', '1+', 'Pédiatrie', 'Surveillance pédiatrique — acronyme SOAPME (S — Succion) [Réf. 153]'),
  ('MG-ANES-000043-R154', 'Pouvoir faire varier l''apport d''oxygène (FiO2) de façon linéaire selon les besoins (débit-litre, respirateurs).', '1+', 'Pédiatrie', 'Surveillance pédiatrique — acronyme SOAPME (O — Oxygen) [Réf. 154]'),
  ('MG-ANES-000043-R155', 'En cas d''extubation accidentelle, disposer de tout l''équipement nécessaire à une réintubation et/ou ventilation manuelle d''attente.', '1+', 'Pédiatrie', 'Surveillance pédiatrique — acronyme SOAPME (A — Airway) [Réf. 155]'),
  ('MG-ANES-000043-R156', 'Disposer d''un nombre limité de médicaments (sédatifs, antalgiques, antagonistes) dont le maniement est bien connu.', '1+', 'Pédiatrie', 'Surveillance pédiatrique — acronyme SOAPME (P — Pharmacy) [Réf. 156]'),
  ('MG-ANES-000043-R157', 'Surveillance continue par monitorage : ECG, fréquence respiratoire, pression artérielle non invasive, SpO2, EtCO2.', '1+', 'Pédiatrie', 'Surveillance pédiatrique — acronyme SOAPME (M — Monitors) [Réf. 157]'),
  ('MG-ANES-000043-R158', 'Limiter les mouvements de l''enfant pendant le transport, s''assurer de la bonne fixation et position des prothèses.', '1+', 'Pédiatrie', 'Surveillance pédiatrique — acronyme SOAPME (E — Equipment) [Réf. 158]'),
  ('MG-ANES-000043-R159', 'Appareil non invasif de base pour la surveillance de l''oxygénation, à utiliser très largement en pédiatrie.', '1+', 'Pédiatrie', 'Surveillance pédiatrique — acronyme SOAPME (Oxymétrie pulsée) [Réf. 159]'),
  ('MG-ANES-000043-R160', 'Monitorer l''EtCO2 chez l''enfant intubé et ventilé.', '1+', 'Pédiatrie', 'Surveillance pédiatrique — acronyme SOAPME (EtCO2) [Réf. 160]')) as v(code, statement, grade, population, source_section)
where d.source_url = 'https://sfar.org/sedation-analgesie-structure-durgence/'
on conflict (recommendation_code) do nothing;
