-- Migration : Prise en charge de la douleur postopératoire (DPO) chez
-- l'adulte et l'enfant (SFAR, RFE 2008, actualisation de la conférence de
-- consensus de 1997)
-- Source : rfe-sfar-website/build/content_douleur_postoperatoire.json (101
-- recommandations atomiques identifiées à la lecture, sur les 8 thèmes du
-- texte).
--
-- ⚠️ PROVENANCE — DISCLOSURE OBLIGATOIRE : `content_douleur_postoperatoire.json`
-- fait partie des 9 fichiers "KNOWN DRIFT" documentés dans
-- `rfe-sfar-website/CLAUDE.md` — récupéré depuis l'Artifact publié en
-- ligne sans qu'aucun `fiche_*.py` ni fichier source n'ait jamais été
-- committé dans ce dépôt. Ce contenu N'A PAS suivi le pipeline de
-- triple-lecture + audit indépendant normalement exigé par ce projet et
-- N'A PAS été re-vérifié contre le PDF source par cette migration. Statut
-- `draft` comme toute migration, mais attention de relecture supérieure
-- recommandée (même disclosure que `examens_preinterventionnels`/0065 et
-- les fiches suivantes de ce lot).
--
-- MÉTHODOLOGIE — particularité disclosée par la fiche construite
-- elle-même : cette source N'IMPRIME AUCUN tag individuel (pas de
-- « grade X », pas de « Accord fort/faible ») à côté de chaque
-- recommandation. La force est encodée dans le VERBE de chaque phrase,
-- selon une convention que la source définit elle-même : « recommandation
-- forte » = « il est recommandé »/« il faut »/« nous recommandons
-- fortement » (et formes négatives) ; « recommandation optionnelle » =
-- « il est probablement recommandé »/« il est possible/probable de » (et
-- formes négatives). `grade` = 'Fort'/'Faible' résolu selon cette règle
-- textuelle explicite de la source (PAS un tag inventé — résolution
-- disclosée par la fiche source elle-même). `evidence_level` laissé NULL.
-- La source NE NUMÉROTE AUCUNE recommandation individuellement (contrairement
-- à la majorité du corpus) : le découpage en lignes ci-dessous est
-- thématique (regroupement de clauses consécutives de même sujet et même
-- force ; JAMAIS deux forces différentes fusionnées sous un chip unique),
-- et le nombre de lignes (101) ne recoupe donc pas le chiffre agrégé
-- "124 recommandations consensuelles" annoncé par la source elle-même
-- (disclosure explicite de la fiche construite, reproduite ici — pas une
-- divergence introduite par cette migration).
--
-- ⚠️ NOUVELLE DISCLOSURE TROUVÉE PAR CETTE MIGRATION (pas mentionnée par
-- la fiche source elle-même) : `library_final.json` (index 160 items)
-- contient une SECONDE entrée, distincte de ce document, intitulée
-- « Réactualisation de la recommandation sur la douleur postopératoire »
-- (SFAR, RFE, daté 2016-09-01, href
-- sfar.org/reactualisation-de-la-recommandation-sur-la-douleur-postoperatoire/)
-- — une mise à jour officielle SFAR de CETTE MÊME RFE, PAS ENCORE construite
-- comme fiche dans ce corpus (absente de `site/app.js` FICHE_HREF_MATCH à
-- la date de cette migration). L'avertissement de la fiche 2008
-- construite se limite à "certaines pratiques ... peuvent avoir évolué
-- depuis 2008" sans mentionner l'existence de cette réactualisation 2016
-- précise. `freshness_status = 'revision_detectee'` retenu EN CONSÉQUENCE
-- (critère renforcé : succession documentée dans l'index du corpus, pas
-- seulement une disclosure générique de péremption). À signaler comme
-- candidat prioritaire pour la Tâche 2 (prochaine fiche à construire).
--
-- POPULATION : `population = 'Sujet âgé'` (spécificités R27-R29) et
-- 'Pédiatrie' (R30-R31, R36-R40, R95) sur les lignes explicitement dédiées
-- à ces populations ; NULL ailleurs (y compris R84/R89, qui s'appliquent
-- explicitement "adulte et enfant" — pas de population unique à assigner).
--
-- PÉRIMÈTRE — volontairement pas migré (disclosure explicite de la fiche
-- source elle-même) : les sections 1-3 de la source (introduction,
-- justification du choix RFE/GRADE) sont résumées dans le panneau de
-- méthodologie plutôt que retranscrites — contenu procédural sur
-- l'élaboration du référentiel, sans recommandation clinique.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. R72 (bloc paravertébral, chirurgie majeure du sein, "probablement
--    recommandé") : la fiche construite signale elle-même une divergence
--    source-interne — le même document qualifie ailleurs (infiltrations
--    continues, R61) ce même bloc pour la même indication de "recommandé
--    en priorité" SANS "probablement". Les deux formulations sont
--    reproduites telles quelles (R61 en Faible car "probablement
--    recommandée" y qualifie la PERFUSION CONTINUE, R72 en Faible pour le
--    BLOC lui-même) — non résolu silencieusement, cf. disclosure complète
--    dans la fiche construite.
-- 2. `publication_date` = 2008-01-01 (année seule connue, Ann Fr Anesth
--    Reanim 2008;27:1035-1041) — convention établie (`allergie_prevention`/
--    0006).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge de la douleur postopératoire chez l''adulte et l''enfant',
  'RFE', 'fr', '2008-01-01',
  'https://sfar.org/prise-en-charge-de-la-douleur-postoperatoire-chez-ladulte-et-lenfant-2/',
  'https://sfar.org/wp-content/uploads/2015/09/2a_AFAR_Prise-en-charge-de-la-douleur-postoperatoire-chez-ladulte-et-lenfant.pdf',
  'Méthode GRADE, mais AUCUN tag individuel imprimé par la source : la force est encodée dans le verbe de chaque phrase ("il est recommandé" = Fort ; "il est probablement recommandé" = Faible), résolution textuelle disclosée par la fiche construite, jamais un tag inventé. 124 recommandations consensuelles annoncées par la source (4 tours de cotation, 8 thèmes) ; le découpage thématique de cette migration (101 lignes) ne recoupe pas ce chiffre agrégé (disclosure explicite). Une réactualisation SFAR 2016 de cette même RFE existe dans library_final.json mais n''est pas encore construite dans ce corpus (voir commentaire de migration).',
  'revision_detectee'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-de-la-douleur-postoperatoire-chez-ladulte-et-lenfant-2/'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-de-la-douleur-postoperatoire-chez-ladulte-et-lenfant-2/'
  and s.slug in ('anesthesie_reanimation', 'medecine_de_la_douleur_algologie', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.source_section,
  'https://sfar.org/prise-en-charge-de-la-douleur-postoperatoire-chez-ladulte-et-lenfant-2/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000071-R01', 'Insister sur l''importance d''une implication institutionnelle avec des objectifs concernant la douleur dans le projet de l''établissement ; inscrire la qualité de la PEC de la DPO dans la réhabilitation postopératoire (récupération fonctionnelle rapide).', 'Fort', null, '1 — Évaluer et améliorer la prise en charge de la DPO'),
  ('MG-ANES-000071-R02', 'Démarche concertée multidisciplinaire avec définition de référents et responsabilisation des acteurs ; aborder conjointement organisation d''équipes, formation, désignation de personnel référent, information du patient, évaluation de la douleur et procédures de soins.', 'Fort', null, '1 — Évaluer et améliorer la prise en charge de la DPO'),
  ('MG-ANES-000071-R03', 'Développer des postes d''infirmier référent douleur.', 'Fort', null, '1 — Évaluer et améliorer la prise en charge de la DPO'),
  ('MG-ANES-000071-R04', 'Informer le patient oralement en pré- puis postopératoire, avec support écrit ; tracer cette information dans le dossier.', 'Fort', null, '1 — Évaluer et améliorer la prise en charge de la DPO'),
  ('MG-ANES-000071-R05', 'Évaluer l''intensité de la douleur par autoévaluation chiffrée (échelle numérique ou verbale) en préopératoire et en SSPI (critère de sortie de SSPI) ; poursuivre régulièrement en postopératoire (repos, mouvement, après traitement), associée à l''évaluation de la sédation et de la ventilation, et tracée dans le dossier. Évaluer aussi l''incidence de la douleur chronique postchirurgicale (DCPC).', 'Fort', null, '1 — Évaluer et améliorer la prise en charge de la DPO'),
  ('MG-ANES-000071-R06', 'Développer des protocoles de traitement utilisant les techniques efficaces (ACP morphinique, analgésie multimodale, ALR), intégrant surveillance, prévention et traitement des effets secondaires.', 'Fort', null, '1 — Évaluer et améliorer la prise en charge de la DPO'),
  ('MG-ANES-000071-R07', 'La prescription à la demande n''est pas recommandée ; prescrire des doses de secours sur des critères fiables (score d''intensité douloureuse).', 'Fort', null, '1 — Évaluer et améliorer la prise en charge de la DPO'),
  ('MG-ANES-000071-R08', 'Standardisation, prérédaction, voire informatisation des prescriptions dans le cadre de procédures thérapeutiques.', 'Fort', null, '1 — Évaluer et améliorer la prise en charge de la DPO'),
  ('MG-ANES-000071-R09', 'Mesurer la qualité de la PEC de la DPO en évaluant parallèlement structure, procédures et résultats pour le patient, de façon continue et prolongée.', 'Fort', null, '1 — Évaluer et améliorer la prise en charge de la DPO'),
  ('MG-ANES-000071-R10', 'Pour la structure : recenser le nombre d''infirmières référentes douleur, les moyens financiers/matériels/humains et les formations dispensées ; faire participer l''équipe à toutes les étapes de la démarche qualité.', 'Fort', null, '1 — Évaluer et améliorer la prise en charge de la DPO'),
  ('MG-ANES-000071-R11', 'Utiliser d''autres méthodes d''évaluation des pratiques professionnelles (chemin clinique, réunions de morbi-mortalité, suivi d''indicateurs — dont ceux de la HAS —, staffs EPP).', 'Fort', null, '1 — Évaluer et améliorer la prise en charge de la DPO'),
  ('MG-ANES-000071-R12', 'Réaliser des enquêtes « patients » pour évaluer les résultats ; associer l''intensité douloureuse et les effets indésirables (la satisfaction seule est un critère insuffisamment spécifique).', 'Fort', null, '1 — Évaluer et améliorer la prise en charge de la DPO'),
  ('MG-ANES-000071-R13', 'Réserver les voies sous-cutanée et IV aux patients pour lesquels la voie orale n''est pas disponible ; utiliser la morphine à libération immédiate par voie orale en postopératoire immédiat ou en relais de la voie parentérale (le traitement peut débuter avec la reprise de l''alimentation orale).', 'Fort', null, '2 — Morphiniques oraux'),
  ('MG-ANES-000071-R14', 'Il n''y a pas de place pour la titration morphinique par voie orale en postopératoire immédiat — la titration IV est préférable.', 'Fort', null, '2 — Morphiniques oraux'),
  ('MG-ANES-000071-R15', 'Les morphiniques oraux sont un traitement de secours efficace en association avec l''analgésie multimodale. L''oxycodone per os peut être une alternative à la morphine en postopératoire de chirurgie douloureuse (hors AMM).', null, null, '2 — Morphiniques oraux'),
  ('MG-ANES-000071-R16', 'Ne pas utiliser le dextropropoxyphène dans l''analgésie postopératoire.', 'Fort', null, '2 — Morphiniques oraux'),
  ('MG-ANES-000071-R17', 'La codéine est probablement efficace après chirurgie à douleur faible ou modérée ; efficacité et tolérance imprévisibles (variations génétiques).', null, null, '2 — Morphiniques oraux'),
  ('MG-ANES-000071-R18', 'Utiliser le tramadol, seul ou associé aux antalgiques non morphiniques, en cas de chirurgie à douleur modérée (non contre-indiqué avec la morphine).', 'Fort', null, '2 — Morphiniques oraux'),
  ('MG-ANES-000071-R19', 'La morphine est l''opioïde recommandé pour une titration IV postopératoire immédiate, à partir d''une valeur seuil d''intensité douloureuse (échelle d''auto- ou d''hétéroévaluation, patients non somnolents).', 'Fort', null, '2 — Titration intraveineuse & ACP morphine'),
  ('MG-ANES-000071-R20', 'Bolus de 2 ou 3 mg toutes les 5 minutes.', 'Faible', null, '2 — Titration intraveineuse & ACP morphine'),
  ('MG-ANES-000071-R21', 'Interrompre la titration en cas de somnolence ; surveiller (neurologique, respiratoire, hémodynamique) pendant la titration et jusqu''à 1h après (pic d''action de la morphine, risque de dépression respiratoire).', 'Fort', null, '2 — Titration intraveineuse & ACP morphine'),
  ('MG-ANES-000071-R22', 'Une titration IV postopératoire en morphine n''est pas recommandée dans les unités d''hospitalisation chirurgicale conventionnelle.', 'Fort', null, '2 — Titration intraveineuse & ACP morphine'),
  ('MG-ANES-000071-R23', 'En cas de chirurgie à douleur modérée ou sévère prédictible nécessitant des morphiniques : utiliser l''ACP (morphine, opiacé de choix — aucun avantage à la remplacer par le tramadol), associée à une analgésie multimodale.', 'Fort', null, '2 — Titration intraveineuse & ACP morphine'),
  ('MG-ANES-000071-R24', 'L''association perfusion continue + mode bolus n''améliore pas l''analgésie et majore le risque de dépression respiratoire (seule indication : substitution d''un traitement morphinique préopératoire).', null, null, '2 — Titration intraveineuse & ACP morphine'),
  ('MG-ANES-000071-R25', 'En prévention des NVPO (effet indésirable le plus fréquent) : associer en première intention le dropéridol à la morphine dans la pompe d''ACP.', 'Fort', null, '2 — Titration intraveineuse & ACP morphine'),
  ('MG-ANES-000071-R26', 'Le dispositif analgésique transdermique iontophorétique a une efficacité comparable à l''ACP morphine (chirurgie à douleur modérée/sévère prédictible) ; appliquer les mêmes modalités de surveillance.', 'Fort', null, '2 — Titration intraveineuse & ACP morphine'),
  ('MG-ANES-000071-R27', 'Chez le sujet âgé : titration selon les mêmes modalités que chez le sujet plus jeune, mais dose titrée réduite au-delà de 85 ans, en cas d''altération rénale/hépatique ou de troubles des fonctions supérieures.', 'Faible', 'Sujet âgé', '2 — Spécificités : sujet âgé et enfant'),
  ('MG-ANES-000071-R28', 'Réduire les doses unitaires de morphine SC et/ou augmenter l''intervalle entre injections chez le sujet âgé, en tenant compte des scores de douleur. L''ACP n''est pas contre-indiquée (programmation identique, mais oxygénothérapie systématique et dose limite horaire).', 'Fort', 'Sujet âgé', '2 — Spécificités : sujet âgé et enfant'),
  ('MG-ANES-000071-R29', 'Ne pas utiliser le dextropropoxyphène chez le sujet âgé.', 'Fort', 'Sujet âgé', '2 — Spécificités : sujet âgé et enfant'),
  ('MG-ANES-000071-R30', 'Chez le nouveau-né, le nourrisson et l''enfant, après chirurgie majeure : utiliser la morphine plutôt que les agonistes de palier II (doses réduites chez le nouveau-né et le nourrisson < 3 mois, immaturité hépatique).', 'Fort', 'Pédiatrie', '2 — Spécificités : sujet âgé et enfant'),
  ('MG-ANES-000071-R31', 'L''ACP est recommandée dès que le niveau de participation est suffisant (en pratique dès 6-7 ans) ; ne pas utiliser la morphine par voie sous-cutanée chez l''enfant (injection douloureuse).', 'Fort', 'Pédiatrie', '2 — Spécificités : sujet âgé et enfant'),
  ('MG-ANES-000071-R32', 'Associer au moins un antalgique non morphinique lorsque la morphine est utilisée en postopératoire par voie systémique.', 'Fort', null, '3 — Antalgiques non morphiniques (ANM)'),
  ('MG-ANES-000071-R33', 'Associer un AINS à la morphine en l''absence de contre-indications ; ne pas utiliser les AINS/coxibs en cas d''hypoperfusion rénale ; prendre en compte la majoration du risque hémorragique (AINS non sélectif) et les facteurs de risque athérothrombotique pour les coxibs (respecter les contre-indications Afssaps).', 'Fort', null, '3 — Antalgiques non morphiniques (ANM)'),
  ('MG-ANES-000071-R34', 'Ne pas utiliser seul le paracétamol associé à la morphine dans les chirurgies à douleur modérée à sévère ; ne pas l''administrer par voie IV dès que la voie orale est utilisable.', 'Fort', null, '3 — Antalgiques non morphiniques (ANM)'),
  ('MG-ANES-000071-R35', 'Néfopam probablement recommandé après chirurgie à douleur modérée à sévère en association avec les morphiniques — utiliser probablement avec prudence chez le patient coronarien (risque de tachycardie).', 'Faible', null, '3 — Antalgiques non morphiniques (ANM)'),
  ('MG-ANES-000071-R36', 'Chez l''enfant : en dehors du syndrome de Fernand-Widal, on peut administrer des AINS aux enfants asthmatiques. Corriger les états de déshydratation/hypovolémie avant l''administration d''AINS.', 'Fort', 'Pédiatrie', '3 — Antalgiques non morphiniques (ANM)'),
  ('MG-ANES-000071-R37', 'Kétoprofène IV probablement utilisable dès 1 an chez l''enfant (hors AMM) ; diclofénac probablement préférable à l''acide niflumique par voie rectale.', 'Faible', 'Pédiatrie', '3 — Antalgiques non morphiniques (ANM)'),
  ('MG-ANES-000071-R38', 'Pas de recommandation possible concernant l''utilisation des coxibs chez l''enfant (données insuffisantes).', null, 'Pédiatrie', '3 — Antalgiques non morphiniques (ANM)'),
  ('MG-ANES-000071-R39', 'Ne pas prescrire d''AINS pour l''analgésie postamygdalectomie (risque hémorragique, reprise chirurgicale).', 'Fort', 'Pédiatrie', '3 — Antalgiques non morphiniques (ANM)'),
  ('MG-ANES-000071-R40', 'Chez l''enfant : ne pas administrer le paracétamol par voie IV dès que la voie orale est utilisable, ni par voie rectale (biodisponibilité faible/imprévisible) ; l''administrer de façon systématique et non « à la demande ».', 'Fort', 'Pédiatrie', '3 — Antalgiques non morphiniques (ANM)'),
  ('MG-ANES-000071-R41', 'Limiter probablement la consommation d''opioïdes peropératoires pour réduire le risque de tolérance aiguë à la morphine en postopératoire immédiat.', 'Faible', null, '4 — Agents antihyperalgésiques'),
  ('MG-ANES-000071-R42', 'Kétamine (antagoniste NMDA le plus efficace) : bolus peropératoire 0,15-0,50 mg/kg, relais 0,125-0,25 mg/kg/h si chirurgie > 2h, arrêt de la perfusion 30 min avant la fin de l''anesthésie ; administrer le premier bolus après l''induction (éviter les effets psychodysleptiques).', 'Fort', null, '4 — Agents antihyperalgésiques'),
  ('MG-ANES-000071-R43', 'Ne pas utiliser l''association morphine-kétamine dans l''ACP postopératoire.', 'Fort', null, '4 — Agents antihyperalgésiques'),
  ('MG-ANES-000071-R44', 'Ne pas utiliser le magnésium IV en prévention de l''hyperalgésie (ne limite pas les douleurs ni la consommation de morphine postopératoires).', 'Fort', null, '4 — Agents antihyperalgésiques'),
  ('MG-ANES-000071-R45', 'Utilisation de la clonidine en prévention des hyperalgésies postopératoires : ne peut être recommandée (effets indésirables hémodynamiques trop marqués).', null, null, '4 — Agents antihyperalgésiques'),
  ('MG-ANES-000071-R46', 'Gabapentine en prémédication probablement recommandée (épargne morphinique, réduction des scores de douleur).', 'Faible', null, '4 — Agents antihyperalgésiques'),
  ('MG-ANES-000071-R47', 'Lidocaïne IV probablement recommandée pour l''analgésie après chirurgie abdominale en l''absence d''ALR.', 'Faible', null, '4 — Agents antihyperalgésiques'),
  ('MG-ANES-000071-R48', 'Prendre en compte la possibilité d''une chronicisation de la douleur postchirurgicale.', 'Fort', null, '5 — Prévenir la chronicisation de la DPO (DCPC)'),
  ('MG-ANES-000071-R49', 'Rechercher en préopératoire les facteurs de risque de chronicisation (intensité de la douleur préopératoire, type de chirurgie, technique opératoire).', 'Faible', null, '5 — Prévenir la chronicisation de la DPO (DCPC)'),
  ('MG-ANES-000071-R50', 'Une forte DPO (surtout neuropathique) est prédictive d''un risque élevé de DCPC : diagnostiquer et prendre en charge rapidement une douleur neuropathique postopératoire.', 'Fort', null, '5 — Prévenir la chronicisation de la DPO (DCPC)'),
  ('MG-ANES-000071-R51', 'Utiliser le questionnaire DN4 comme outil de dépistage de la douleur neuropathique postopératoire.', 'Faible', null, '5 — Prévenir la chronicisation de la DPO (DCPC)'),
  ('MG-ANES-000071-R52', 'Chirurgie très ou modérément douloureuse : utiliser de faibles doses de kétamine peropératoire pour prévenir la DCPC.', 'Fort', null, '5 — Prévenir la chronicisation de la DPO (DCPC)'),
  ('MG-ANES-000071-R53', 'Infiltration d''anesthésiques locaux du site chirurgical : limite probablement la DCPC après prise de greffon osseux iliaque.', 'Faible', null, '5 — Prévenir la chronicisation de la DPO (DCPC)'),
  ('MG-ANES-000071-R54', 'Bloc paravertébral probablement recommandé pour réduire la DCPC après chirurgie majeure du sein.', 'Faible', null, '5 — Prévenir la chronicisation de la DPO (DCPC)'),
  ('MG-ANES-000071-R55', 'Infiltrer la cicatrice de cholécystectomie par laparotomie ; utiliser le bloc des droits pour la cure de hernie ombilicale.', 'Fort', null, '6 — Infiltrations en injection unique'),
  ('MG-ANES-000071-R56', 'Cholécystectomie et chirurgie gynécologique par laparoscopie : infiltration des orifices de trocarts et instillation intrapéritonéale recommandées. Pour les autres laparotomies abdominales, l''infiltration cicatricielle en injection unique n''a pas d''intérêt significatif en dehors du TAP block.', 'Fort', null, '6 — Infiltrations en injection unique'),
  ('MG-ANES-000071-R57', 'Cure de hernie inguinale : infiltration avec un anesthésique local à longue durée d''action (injection en plans profonds ou bloc ilio-inguinal plus efficaces que l''injection SC) ; s''applique aussi aux cicatrices transversales basses (ex. césarienne sous AG).', 'Fort', null, '6 — Infiltrations en injection unique'),
  ('MG-ANES-000071-R58', 'Chirurgie hémorroïdaire : infiltration périanale « en quadrants » ou bloc pudendal avec neurostimulation.', 'Fort', null, '6 — Infiltrations en injection unique'),
  ('MG-ANES-000071-R59', 'Infiltrer la cicatrice de thyroïdectomie avec des anesthésiques locaux à longue durée d''action.', 'Fort', null, '6 — Infiltrations en injection unique'),
  ('MG-ANES-000071-R60', 'Perfusion continue cicatricielle sur laparotomies sous-costales et médianes (cathéter en plans profonds/prépéritonéal) ; infiltration continue en plans profonds après hystérectomie par voie abdominale et césarienne.', 'Fort', null, '6 — Infiltrations continues'),
  ('MG-ANES-000071-R61', 'Chirurgie majeure du sein et curage axillaire : perfusion continue cicatricielle probablement recommandée (alternative au bloc paravertébral, recommandé en priorité).', 'Faible', null, '6 — Infiltrations continues'),
  ('MG-ANES-000071-R62', 'Cure de hernie inguinale : perfusion continue cicatricielle probablement pas utile (malgré une efficacité démontrée).', 'Faible', null, '6 — Infiltrations continues'),
  ('MG-ANES-000071-R63', 'Chirurgie cardiaque : infiltration continue cicatricielle (cathéter sur la face antérieure du sternum).', 'Fort', null, '6 — Infiltrations continues'),
  ('MG-ANES-000071-R64', 'Chirurgie de l''épaule : infiltration continue subacromiale d''un anesthésique local (en chirurgie ouverte, cathéter possible en sous-cutané, efficacité inférieure à une ALR plexique).', 'Fort', null, '6 — Infiltrations continues'),
  ('MG-ANES-000071-R65', 'Prise de greffon iliaque : infiltration continue à proximité de l''os.', 'Fort', null, '6 — Infiltrations continues'),
  ('MG-ANES-000071-R66', 'Chirurgie du genou : cathéter intra-articulaire probablement pas recommandé (efficacité limitée, risque pour le cartilage).', 'Faible', null, '6 — Infiltrations continues'),
  ('MG-ANES-000071-R67', 'Proposer une technique d''analgésie aux anesthésiques locaux chaque fois que possible ; préférer les blocs périphériques aux blocs centraux dès que possible (meilleur rapport bénéfice/risque).', 'Fort', null, '7 — Place de l''ALR — règles générales'),
  ('MG-ANES-000071-R68', 'Utiliser de préférence la ropivacaïne ou la lévobupivacaïne pour l''analgésie péridurale ou les blocs périphériques (moindre toxicité cardiaque que la bupivacaïne).', 'Faible', null, '7 — Place de l''ALR — règles générales'),
  ('MG-ANES-000071-R69', 'Respecter les recommandations de pratique clinique de l''ALR pour l''information, la pose et la surveillance des cathéters nerveux/périduraux ; respecter les règles d''asepsie chirurgicale (le repérage échographique est une alternative pour localiser les nerfs périphériques).', 'Fort', null, '7 — Place de l''ALR — règles générales'),
  ('MG-ANES-000071-R70', 'Associer probablement une analgésie multimodale à l''ALR pour compléter l''efficacité et/ou prévenir la douleur à la levée du bloc.', 'Faible', null, '7 — Place de l''ALR — règles générales'),
  ('MG-ANES-000071-R71', 'Bloc paravertébral (injection unique ou cathéter) pour diminuer les scores de douleur et l''incidence des NVPO après chirurgie thoracique (alternative utile à la péridurale).', 'Fort', null, '7 — Place de l''ALR — blocs du tronc'),
  ('MG-ANES-000071-R72', 'Bloc paravertébral probablement recommandé après chirurgie majeure du sein. Divergence source-interne : la même source qualifie ailleurs (infiltrations continues) ce même bloc de « recommandé en priorité » (sans « probablement ») pour la même indication — les deux formulations sont retranscrites sans résolution silencieuse.', 'Faible', null, '7 — Place de l''ALR — blocs du tronc'),
  ('MG-ANES-000071-R73', 'Le bloc interpleural ne peut être recommandé (bénéfice limité ne contrebalançant pas le risque de résorption systémique des anesthésiques locaux).', null, null, '7 — Place de l''ALR — blocs du tronc'),
  ('MG-ANES-000071-R74', 'Cathéter nerveux périphérique recommandé dès lors que la douleur prévisible modérée à sévère dure > 24h.', 'Fort', null, '7 — Place de l''ALR — blocs nerveux périphériques'),
  ('MG-ANES-000071-R75', 'Mode continu + ACP périnerveuse probablement recommandé pour l''administration d''anesthésiques locaux.', 'Faible', null, '7 — Place de l''ALR — blocs nerveux périphériques'),
  ('MG-ANES-000071-R76', 'Le risque de syndrome des loges n''est pas une contre-indication au bloc (sous surveillance adaptée) ; ne pas poser de cathéter en cas d''immobilisation plâtrée postopératoire.', 'Fort', null, '7 — Place de l''ALR — blocs nerveux périphériques'),
  ('MG-ANES-000071-R77', 'Épaule : bloc interscalénique recommandé.', 'Fort', null, '7 — Place de l''ALR — blocs nerveux périphériques'),
  ('MG-ANES-000071-R78', 'Épaule, si bloc interscalénique contre-indiqué : bloc suprascapulaire et infiltrations intra-articulaires probablement recommandés.', 'Faible', null, '7 — Place de l''ALR — blocs nerveux périphériques'),
  ('MG-ANES-000071-R79', 'Bras et coude : blocs supraclaviculaire ou infraclaviculaire probablement recommandés.', 'Faible', null, '7 — Place de l''ALR — blocs nerveux périphériques'),
  ('MG-ANES-000071-R80', 'Avant-bras, poignet, main : blocs axillaire ou au canal huméral probablement recommandés.', 'Faible', null, '7 — Place de l''ALR — blocs nerveux périphériques'),
  ('MG-ANES-000071-R81', 'Doigts (rééducation active nécessaire) : blocs tronculaires distaux probablement recommandés.', 'Faible', null, '7 — Place de l''ALR — blocs nerveux périphériques'),
  ('MG-ANES-000071-R82', 'Membre inférieur : ne pas utiliser l''analgésie péridurale (blocs périphériques aussi efficaces, moins d''effets indésirables).', 'Fort', null, '7 — Place de l''ALR — blocs nerveux périphériques'),
  ('MG-ANES-000071-R83', 'Hanche : bloc fémoral probablement recommandé.', 'Faible', null, '7 — Place de l''ALR — blocs nerveux périphériques'),
  ('MG-ANES-000071-R84', 'Diaphyse fémorale, chirurgie ou traumatisme (adulte et enfant) : bloc fémoral recommandé.', 'Fort', null, '7 — Place de l''ALR — blocs nerveux périphériques'),
  ('MG-ANES-000071-R85', 'Chirurgie invasive du genou (ex. prothèse totale) : cathéter fémoral recommandé.', 'Fort', null, '7 — Place de l''ALR — blocs nerveux périphériques'),
  ('MG-ANES-000071-R86', 'Chirurgie invasive du genou : bloc sciatique en injection unique probablement recommandé en complément du bloc fémoral.', 'Faible', null, '7 — Place de l''ALR — blocs nerveux périphériques'),
  ('MG-ANES-000071-R87', 'Chirurgie ligamentaire du genou : bloc fémoral (cathéter ou injection unique) probablement recommandé.', 'Faible', null, '7 — Place de l''ALR — blocs nerveux périphériques'),
  ('MG-ANES-000071-R88', 'Arthroscopie mineure du genou : administration intra-articulaire d''anesthésique local (± adjuvant) ou bloc fémoral en injection unique recommandés.', 'Fort', null, '7 — Place de l''ALR — blocs nerveux périphériques'),
  ('MG-ANES-000071-R89', 'Jambe, cheville, pied (adulte et enfant) : bloc sciatique recommandé.', 'Fort', null, '7 — Place de l''ALR — blocs nerveux périphériques'),
  ('MG-ANES-000071-R90', 'Chirurgie mineure du pied : bloc de cheville probablement recommandé (cathéter possible au niveau du nerf tibial).', 'Faible', null, '7 — Place de l''ALR — blocs nerveux périphériques'),
  ('MG-ANES-000071-R91', 'Injection intrathécale de morphine <= 0,1 mg chez le sujet ASA I/II : surveillance possible en secteur traditionnel.', null, null, '7 — Place de l''ALR — analgésie périmédullaire'),
  ('MG-ANES-000071-R92', 'Analgésie péridurale : anesthésiques locaux à faible concentration + morphinique, cathéter inséré au milieu de la zone des dermatomes à bloquer.', 'Fort', null, '7 — Place de l''ALR — analgésie périmédullaire'),
  ('MG-ANES-000071-R93', 'Analgésie périmédullaire recommandée après chirurgie thoracique ou intra-abdominale majeure (gastrique, pancréatique, colique, grêle, œsophage, cystectomie) — améliore l''analgésie, réduit la durée de l''iléus, raccourcit le délai d''extubation.', 'Fort', null, '7 — Place de l''ALR — analgésie périmédullaire'),
  ('MG-ANES-000071-R94', 'Ne pas utiliser probablement l''analgésie péridurale après chirurgie vasculaire périphérique (aucun impact sur l''analgésie, la morbidité respiratoire/cardiovasculaire).', 'Faible', null, '7 — Place de l''ALR — analgésie périmédullaire'),
  ('MG-ANES-000071-R95', 'Enfant : réaliser un bloc pénien pour l''analgésie après circoncision.', 'Fort', 'Pédiatrie', '7 — Place de l''ALR — analgésie périmédullaire'),
  ('MG-ANES-000071-R96', 'Les établissements ayant une activité ambulatoire doivent développer une stratégie spécifique d''évaluation/traitement de la DPO à domicile, évaluée régulièrement et de façon pluridisciplinaire.', 'Fort', null, '8 — Organiser l''analgésie en chirurgie ambulatoire'),
  ('MG-ANES-000071-R97', 'Apprécier les éléments prédictifs de la DPO et de la tolérance aux analgésiques prescrits à domicile ; expliquer les modalités de l''analgésie orale dès la consultation préopératoire (chirurgie, anesthésie).', 'Fort', null, '8 — Organiser l''analgésie en chirurgie ambulatoire'),
  ('MG-ANES-000071-R98', 'Remettre les ordonnances d''antalgiques dès la consultation de chirurgie/anesthésie, précisant les horaires de prise systématique et les conditions de recours à un palier supérieur si nécessaire.', 'Fort', null, '8 — Organiser l''analgésie en chirurgie ambulatoire'),
  ('MG-ANES-000071-R99', 'Prise en charge de la DPO à domicile par voie locorégionale : informer le médecin traitant par avance et le prévenir de la sortie du patient.', 'Fort', null, '8 — Organiser l''analgésie en chirurgie ambulatoire'),
  ('MG-ANES-000071-R100', 'Utiliser les infiltrations et blocs périphériques en injection unique pour la chirurgie ambulatoire lorsque l''indication opératoire s''y prête ; la sortie malgré l''absence de levée du bloc est possible si analgésie de secours, attelles, information écrite, assistance à domicile et procédures d''appel sont prévues.', 'Fort', null, '8 — Organiser l''analgésie en chirurgie ambulatoire'),
  ('MG-ANES-000071-R101', 'Cathéters périnerveux à domicile : réserver aux interventions dont la DPO est totalement (ou en grande partie) couverte par le bloc périnerveux ; contact téléphonique quotidien recommandé.', 'Fort', null, '8 — Organiser l''analgésie en chirurgie ambulatoire')
) as v(code, statement, grade, population, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-de-la-douleur-postoperatoire-chez-ladulte-et-lenfant-2/'
on conflict (recommendation_code) do nothing;
