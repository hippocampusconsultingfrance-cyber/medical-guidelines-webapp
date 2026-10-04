# Relecture des fiches par Claude — rapport

Relecture faite dans la session Claude Code (octobre 2026). Chaque ligne de fiche (« unité ») a été comparée au texte de la recommandation source ; les tableaux et figures absents du texte extrait ont été vérifiés sur l'image de la page. Les avis détaillés sont dans `scripts/verification/avis-claude/<fiche>.json`.

Ce rapport ne vaut pas validation médicale : chaque écart doit être confirmé par un médecin avant correction de la fiche.

## Bilan

- Fiches relues : **159**
- Unités vérifiées : 9012 — conformes : 8332, sans objet (intertitres, notes) : 571, **écarts : 108** (dans 58 fiches), non retrouvées : 1

## À corriger en priorité (risque clinique)

- **sepsis** (score de Phoenix, annexe 1) : u11 lactate ≥ 11 mmol/L placé à 3 points (source : 2 points) et palier 5–10,9 mmol/L = 1 point omis ; u13 Glasgow ≤ 10 compté 2 points (source : 1 point ; 2 points = pupilles fixes) ; u14 seuils de PAM du 2 points omis.
- **allergie_prevention** : u16 tryptase « > 25 microg/mL » au lieu de > 25 µg/L ; u31/u54 colonne IDR des curares en mg/mL au lieu de µg/mL (facteur 1000).
- **diabete_perioperatoire_2025** : u56 resucrage (G30 %) placé dans la mauvaise bande glycémique ; u33 branche cétose sous SGLT2 mal attribuée ; u54 plafond de 30 UI à l'initiation omis.
- **tih** u46 : figure 1, branche intermédiaire — omet l'arrêt de l'héparine si le résultat arrive > 3 h et l'anticoagulant non héparinique si anticorps positifs.
- **mtev_perioperatoire** : u14 un seul grade 2+ pour un encadré gradé 1+/2+/AE ; u42 tableau rénal sans ses couleurs (l'information est perdue).
- **coronarien** u108/u109 : figure 1 — ordre Lee → MET inversé, seuils de Lee (0–1 vasculaire / 0–2 non vasculaire) omis.
- **anaphylaxie** u42–u44 : tableau latex–aliments mal réparti.
- **hsa** u30 : l'index bicaudé est dit diminuer avec l'âge (il augmente).
- **mort_encephalique** : u142 chronologie du PMO omise ; u40 énoncé sur les HEA omis ; u92 cotation omise.
- **anticoagulants** : u10 « J-5 si risque très élevé » affiché 2+ (source : avis d'experts) ; u19 R5.5 cotée 2- regroupée sous 2+ ; u74 « IRC sévère (DFGe 30–49) » → c'est l'IRC modérée.

## Autres constats

- **Bug de l'outil corrigé** : le texte compris entre « < » et « > » (ex. « <21 si >70 ans ») était effacé comme une balise HTML. Corrigé dans `scripts/verification/verifier-fiches.mjs`, `src/lib/assistant.ts`, `src/app/bibliotheque/reformulations/page.tsx` et `scripts/juridique/mesure_reprises.py`. Les faux écarts qu'il avait créés ont été retirés.
- **Limite de l'outil** : les lignes de tableau de moins de 4 mots ne sont pas vérifiées automatiquement. Pendant cette relecture, je les ai regardées au cas par cas (surtout avant de signaler un oubli), pas une par une ; une vérification automatique ne les couvre pas.
- **Vocabulaire interne visible par le lecteur** dans environ 90 fiches (« disclosure », « chip », « vérifié par grep », « installment 8/n », « library_final.json », noms de scripts, « rendu à 400 dpi »…). Ce n'est pas une erreur médicale, mais ces notes de rédaction devraient être retirées ou reformulées. Liste détaillée : section « Vocabulaire interne » ci-dessous.
- **Téléchargements** : 29 sources n'ont pas pu être téléchargées par le workflow automatique (délai dépassé). Le workflow devra être relancé pour elles.
- **Deuxième avis** : relancer le workflow GitHub de vérification avec `ia=gemini` et `fiches=toutes` (après recharge du crédit Google AI Studio) pour obtenir un avis indépendant.

## Tous les écarts, fiche par fiche

### aap_endoprotheses_coronaires

- **u10** (sens) : La source admet une substitution possible après arrêt total (avis d'experts) et dit seulement qu'aucune des deux options (AINS ou HBPM) n'est préférable ; la fiche dit qu'aucun argument ne plaide pour une substitution.

### allergie_prevention

- **u16** (chiffre) : La source donne > 25 µg/L ; la fiche écrit « > 25 microg/mL » (unité 1000 fois trop grande). Le reste (grades 1-2) est conforme.
- **u31** (chiffre) : La colonne « IDR CM » est en µg/mL dans la source ; l'en-tête de la fiche dit « IDR CM (mg/mL) ». Les valeurs elles-mêmes sont justes, mais affichées avec une unité 1000 fois trop grande (ex. atracurium 10 µg/mL et non 10 mg/mL). Les colonnes C et PT CM sont bien en mg/mL.
- **u54** (chiffre) : Même erreur que pour le Tableau 3 : l'IDR CM est en µg/mL (chlorhexidine 50 µg/mL, povidone 10 000 µg/mL, bleu patenté 2500 µg/mL, bleu de méthylène 100 µg/mL) ; la fiche indique mg/mL.

### anaphylaxie

- **u42** (sens) : Répartition fausse : la fiche met la châtaigne en « régulièrement » (source : occasionnellement) et oublie la papaye dans cette ligne (source : régulièrement).
- **u43** (sens) : La fiche place papaye, figue, fruits exotiques et sarrasin en « occasionnellement » ; la source y met seulement la châtaigne (papaye = régulièrement ; figue, fruits exotiques, sarrasin = rarement).
- **u44** (omission) : La fiche ne cite que tomate, pêche, poivron ; figue, fruits exotiques et sarrasin manquent (placés à tort en « occasionnellement »).

### anesth_cardiopathie_congenitale

- **u9** (ajout) : Le statut D de la source (Tableau 3, d'après AHA 2018) liste : NYHA IV, dilatation aortique sévère, arythmie réfractaire, hypoxémie sévère, HTAP sévère, syndrome d'Eisenmenger, dysfonction d'organe réfractaire. « Dysfonction ventriculaire sévère » n'y figure pas ; elle est ajoutée par la fiche.
- **u24** (autre) : Dans la fiche pratique #1, la mention « Arrêt ≥ 12h (Traitement de l'HTA) » figure sur la ligne « Inhibiteurs SRAA », pas sur la ligne IEC. La fiche l'a déplacée vers les IEC (u24) et l'a retirée des inhibiteurs SRAA (u26).
- **u26** (omission) : La mention « Arrêt ≥ 12h (traitement de l'HTA) » de la ligne SRAA est omise ici (elle a été placée sur la ligne IEC, u24).

### antibioprophylaxie

- **u1** (autre) : La fiche cite la V3.0 du 04/05/2026 comme version courante ; la source en ligne est désormais la V3.1 du 10/07/2026 (amendement du Champ 3 pédiatrique, non couvert par la fiche).

### anticoagulants

- **u10** (grade) : La partie « J-5 si risque hémorragique très élevé (neurochirurgie intracrânienne, neuraxial) » vient de R3.4, cotée Avis d'experts ; la fiche affiche [2+] pour toute la ligne (2+ ne vaut que pour J-3, R3.3).
- **u19** (grade) : La fiche regroupe R3.3 (2+) et R5.5 sous un seul [2+] ; R5.5 (pas de relais héparinique, FA sous AOD) est cotée 2- dans la source (page 26).
- **u74** (population) : La fiche écrit « AOD en IRC sévère (DFGe 30-49) » ; selon la classification de la fiche elle-même (u47) et la source, 30–49 correspond à l'IRC modérée (stade 3), la sévère étant 15–29. Délais et grades corrects.

### aod_dabigatran_urgence_2016

- **u2** (force) : Dose, absence d'ajustement et 2e dose conformes. Mais la source recommande la mesure de la concentration AVANT l'antidote (« prélèvement… doit être réalisé le plus tôt possible », sans retarder l'administration) ; seule la nouvelle mesure à 12-18 h est « envisagée si la situation l'exige ». La fiche applique « si la situation l'exige » aux deux mesures.

### blocs_perimedullaires_complications_2006

- **u77** (population) : La source limite cet énoncé à l'obstétrique ; la fiche l'énonce sans cette précision.
- **u83** (omission) : Dans la source, cet énoncé concerne la prévention du prurit ; la fiche le range sous les NVPO sans intertitre « Prurit », ce qui peut le faire lire comme une prévention des nausées.
- **u84** (omission) : Même problème : dans la source, il s'agit de la prévention du prurit, mais la fiche ne l'indique pas (intertitre « Prurit » absent).

### blocs_perimedullaires_terrain_cardioresp_2006

- **u10** (omission) : La fiche omet la mise en garde qui suit : une APD thoracique peut déstabiliser une insuffisance cardiaque en diminuant la contractilité myocardique.

### blocs_peripheriques_membres

- **u15** (chiffre) : La source écrit « largeur du garrot × 3 » dans la formule ; la fiche omet le « × 3 ». Le reste (garrot double, avant-bras, exsanguination, 50 mmHg, grades A/B) est conforme.
- **u32** (grade) : Écart mineur : la fiche attribue un « Grade E » aux 2 stimulations sur le radial, alors que dans la source cette phrase n'est pas gradée (le « (E) » qui précède porte sur le bloc infraclaviculaire). Le reste de l'unité est conforme.
- **u77** (omission) : La fiche omet l'énoncé gradé B qui ouvre la question 11 (complications neurologiques périphériques plus fréquentes après AG qu'après ALR). Le reste (E, E/D, E, D, D, E) est conforme.

### coronarien

- **u19** (ajout) : Écart mineur : la fiche ajoute « risque chirurgical estimé faible » à la ligne « Modérée » ; dans la source, cette case est vide (« Faible » n'est imprimé que pour « Excellente », « Intermédiaire à élevé » pour « Faible »).
- **u108** (sens) : L'ordre des étapes est inversé. Dans la figure, on stratifie d'abord par le score de Lee, puis on évalue les MET seulement si le Lee est élevé. La fiche fait l'inverse (MET d'abord, puis Lee si < 4 MET). Le résultat diffère dans certains cas (voir u109).
- **u109** (omission) : La fiche écrit « 0-1 facteur de Lee » sans distinguer vasculaire / non vasculaire. Elle omet qu'en chirurgie non vasculaire un score de 2 permet d'opérer sans examen ; avec la fiche, ce patient (Lee 2, non vasculaire, < 4 MET) ne relève d'aucune branche.

### corticotherapie

- **u12** (population) : La source formule la recherche systématique d'infection avant corticothérapie pour le SDRA ; la fiche l'étend au choc septique (« SDRA comme choc septique »).

### curares

- **u76** (grade) : Formulation négative (« il est recommandé de ne pas modifier ») de grade fort ; par la convention du document, c'est un 1−, la fiche affiche [1+]. Texte conforme.

### diabete_perioperatoire_2025

- **u33** (sens) : Dans la source, la branche 0,5-1,5 mmol/L va directement au tableau (4/6/10 UI, sans GDS), et c'est la branche > 1,5 mmol/L avec pH > 7,20 qui rejoint ce tableau. La fiche attache « si pH > 7,20 au GDS » à la ligne 0,5-1,5 et ne dit pas que cétonémie > 1,5 avec pH > 7,20 se traite par le tableau. Surveillance glycémie + cétonémie à H4 non reprise.
- **u54** (omission) : Basal 0,3 UI/kg/j et adaptation ±2 UI conformes, mais la fiche omet le plafond de 30 UI à l'initiation.
- **u56** (sens) : La source place « 1 ampoule G30 % IV ou 15 g de sucre PO » dans la bande < 3,3 mmol/L (hypoglycémie). La fiche l'attache à la bande > 16,5 mmol/L (« 6 UI SC, ou 1 ampoule G30 % … si hypoglycémie associée »), ce qui est incohérent et peut induire en erreur. La bande < 3,3 mmol/L manque.

### douleur_accouchement_2025

- **u43** (autre) : La fiche écrit « → arrêt et réévaluation complète ». Dans l'algorithme, ces deux situations mènent à la repose du cathéter (MAR expérimenté, PRC/PPD si travail avancé). Le reste du bloc (BIP + PCEA, objectif T10 sans bloc moteur, évaluation à 30 min puis toutes les heures) est conforme.

### douleur_postoperatoire

- **u41** (force) : Écart mineur : la fiche regroupe sous un seul [Fort] deux phrases de force différente. « On peut administrer des AINS aux enfants asthmatiques » est, selon la règle de la source (« il est possible… »), une recommandation optionnelle ; seule « il est recommandé de corriger la déshydratation/hypovolémie » est forte. La fiche dit pourtant ne jamais fusionner deux forces.

### douleur_reactualisation_2016

- **u36** (omission) : La fiche annonce le tableau des doses maximales (première injection, adulte ASA 1) mais ne le reproduit pas : lidocaïne adrénalinée 7, mépivacaïne 5, lévobupivacaïne 3, ropivacaïne 3 mg/kg.
- **u39** (ajout) : La recommandation est conforme, mais la précision « (toxicité directe sur les chondrocytes) » n'est pas dans la source. Ajout mineur.

### echo_acces_vasculaires

- **u4** (chiffre) : La fiche indique 3 études et ~450-500 patients pour tous les critères, alors que le pneumothorax repose sur 2 études (446 patients) et l'hémothorax sur 1 étude (401 patients).

### eclsa

- **u20** (autre) : Dans la figure, TV/TP/FV ne mènent pas directement à « Indication possible » : ils renvoient vers l'évaluation de la durée de low-flow (colonne centrale), comme une durée de no-flow 0-5 min. La fiche écrit qu'ils « réintègrent » la colonne Indication possible.

### eer

- **u1** (chiffre) : La fiche annonce « 78 recommandations numérotées » ; le décompte des numéros de la source (champ 1 : 5, 2.1 : 12, 2.2 : 5, 2.3 : 10, 2.4 : 1, 3.1 : 3, 3.2 : 3, 3.3 : 5, 3.4 : 10, 4.1 : 2, 4.2 : 7, 4.3 : 15) donne 83. Le reste (18 experts, RAND/UCLA, 2 tours) est conforme.
- **u25** (omission) : La source porte « (Avis d’experts) » sur 2.2.4 ; la fiche, qui dit conserver cette mention verbatim, l'omet. Texte et accord conformes.
- **u63** (force) : Source prescriptive (« il faut utiliser des débits inférieurs ») ; la fiche est descriptive (« les débits sont plus bas »). Écart mineur.

### erreurs_medicamenteuses_ar_2016

- **u7** (force) : La source dit que double lecture et seringues à code-barres sont « peut-être des mesures efficaces » ; la fiche les présente sans cette réserve. Elle omet aussi l'absence de robinets sur les tubulures d'ALR.
- **u11** (force) : La source impose la déclaration au Guichet Erreurs Médicamenteuses de l'ANSM (« doit être déclarée ») ; la fiche la présente comme seulement « possible ».

### examens_pertinence_rea

- **u15** (chiffre) : La source imprime « RCRI à 1 » ; la fiche écrit « ≤1 » (interprétation ajoutée, probablement juste mais non imprimée). Grade 1- conforme.

### gestion_traitements_chroniques_cardio_2009

- **u25** (population) : La source réserve la position antéropostérieure des électrodes de CEE au porteur d'un stimulateur ou d'un DCI dont la fonction antiarythmique est déprogrammée ; la fiche écrit « porteur d'un DCI actif ».

### gestion_traitements_chroniques_neuro_psy_2011

- **u22** (ajout) : La recommandation en accord fort est inconditionnelle (« doit être maintenu avec une discussion pluridisciplinaire ») ; la condition « si le risque de décompensation psychiatrique apparaît important » vient de la phrase suivante, gradée D (« peut être maintenu… »). La fiche fusionne les deux et attache la condition à l'accord fort.

### hospit_ambulatoire

- **u70** (sens) : Source : < 60 semaines = exclusion ; au-delà, seuls « certains patients d'âge postconceptionnel supérieur à 60 semaines et jusqu'à un an peuvent être inclus après accord préalable anesthésiste/opérateur ». La fiche présente ≥ 60 semaines comme éligible d'emblée et omet « l'accord préalable anesthésiste/opérateur » (aussi pour les < 3 mois nés à terme).

### hsa

- **u30** (sens) : La fiche dit que la valeur normale de l'index bicaudé est « décroissant avec l'âge » ; dans la source elle augmente avec l'âge (≤ 30 ans < 0,16 ; 50 ans < 0,18 ; 60 ans < 0,19 ; 80 ans < 0,21 ; 100 ans < 0,25). Le tableau des valeurs, lui, est bien reproduit.

### impact_environnemental_ag

- **u4** (force) : La source présente la bouteille comme « une alternative » possible ; la fiche en fait une préférence (« préférer »).

### infarctus_myocarde

- **u14** (omission) : La fiche ne mentionne, pour cette branche, que fibrinolyse puis angioplastie de sauvetage si échec. Elle omet qu'en cas de contre-indication à la thrombolyse, on fait une angioplastie primaire (même si le délai dépasse 45 min).

### infections_intra_abdominales

- **u50** (omission) : Critère BMR n°4 : la source dit « EHPAD médicalisé ou soins de longue durée ET sonde à demeure et/ou gastrostomie » ; la fiche omet « ou soins de longue durée ». Reste de R42 conforme (grade 2+).

### lat_soins_critiques

- **u19** (force) : La fiche présente comme une simple possibilité l'engagement de la procédure à la demande de la personne de confiance ou des proches, alors que la source en fait une obligation pour le médecin.
- **u28** (chiffre) : La cible RASS -5 est une donnée observationnelle (étude Le Dorze) ; le protocole proposé et la HAS retiennent une cible RASS -4 ou -5, et non -5 seul.
- **u70** (omission) : La source exige un protocole de sédation profonde et continue en cas d'extubation ; la fiche parle seulement d'un protocole de sédation « adapté », perdant l'exigence de profondeur et de continuité.

### monitorage_traumatise

- **u59** (force) : La source dit que l'oxymètre « peut s'avérer utile » et que la dotation « pourra être complétée » d'un mini-tensiomètre et d'un mini-cardioscope/DSA ; la fiche parle d'une « dotation minimale », plus impérative que le texte.

### mort_encephalique

- **u40** (omission) : Le remplissage (7,5) est conforme, mais la fiche omet l'énoncé coté 7 qui suit : les hydroxyéthylamidons de dernière génération (≤ 30 ml/kg/j) utilisables comme les gélatines, sans risque rénal, données à confirmer.
- **u92** (grade) : La fiche marque cette ligne « — » (non cotée) ; dans la source, la phrase sur l'éthylisme chronique porte une cotation (8). Le reste (diabète, HTA, cytolyse : non cotés) est conforme.
- **u142** (omission) : La fiche annonce « Chronologie du PMO (telle que décrite par le texte source) » mais n'en reproduit aucune étape. Manquent les 7 étapes, dont « héparinisation dix minutes avant le clampage et perfusion in situ » (cotée 9).

### mtev_perioperatoire

- **u14** (grade) : La fiche attribue un seul grade [2+] à tout l'encadré. Or la figure (et le tableau de recommandations juste au-dessus) donne 1+ à l'anticoagulant et à la durée, 2+ seulement au délai H12-H24, et « avis d'experts » au début H6-H12.
- **u42** (omission) : Les 6 lignes sont présentes dans la fiche, mais toutes les cases sont vides et sans couleur (seul « ½ dose » de l'enoxaparine est écrit). Or l'information du tableau est portée par la couleur (rouge = non recommandé AMM, orange = non recommandé GIHP, vert = recommandé). Tel quel, le tableau ne dit rien ; la note u46 ne couvre que les AOD et le fondaparinux.

### nutrition_perioperatoire

- **u1** (autre) : La source dit avoir suivi une méthode « non formalisée des avis d'experts » et n'imprime aucun grade : seule la formulation (« il faut » / « il faut probablement ») porte la force. La fiche affiche des grades [1+]/[2+]/[1-]/[2-] sans préciser qu'ils sont déduits de la formulation. Les grades déduits sont cohérents avec le texte, mais il faudrait l'indiquer.

### optimisation_beta_lactamines_2018

- **u23** (omission) : La fiche dit seulement « augmenter la dose unitaire ». Elle omet le chiffre (+25 à 50 %), le maintien de la fréquence et le bolus complémentaire si besoin.
- **u28** (sens) : La fiche présente les plages chiffrées et la « CMI seuil » comme la colonne « infection documentée ». D'après les notes du Tableau 1 (* et £), ces plages calculées sur une CMI seuil correspondent à la colonne « infection non documentée / probabiliste ». En infection documentée, la cible est CminL ou CéqL ≥ 4× la CMI de la bactérie, sous un plafond (ex. < 80 mg/L).
- **u40** (sens) : La note dit que la colonne « infection non documentée » n'est pas reproduite, alors que les plages reproduites sont précisément celles de cette colonne (cf. u28). L'avertissement u41 reprend la même inversion.

### organisation_anesthesie_pediatrique_2023

- **u28** (omission) : Les deux organisations possibles pour les 1-3 ans sont bien reprises, mais la dernière phrase de R4.3.2 manque : en cas de risque élevé de complication respiratoire sévère, deux professionnels de l'anesthésie pédiatrique (dont au moins un MAR) doivent être présents à l'induction et au réveil, quelle que soit l'organisation.

### preeclampsie

- **u21** (aucun) : La posologie « dose de charge 4 g IV » n'apparaît pas dans le texte source (seul l'essai Magpie est cité, sans protocole). Information ajoutée hors source, même si la fiche renvoie au protocole local.

### raac_cardiaque_2021

- **u7** (omission) : La fiche omet le seuil HbA1c >8 % qui déclenche l'avis diabétologique et l'éventuel report de la chirurgie.
- **u9** (omission) : La fiche omet la chlorhexidine biquotidienne, le début au moins 48 h avant et la durée totale de 5-7 jours.
- **u10** (omission) : La fiche omet que les bêtabloquants sont utilisés en première intention.

### raac_colorectal

- **u43** (autre) : La fiche classe « non en préop non carcinologique » et « non en postop » comme secondaires : classement absent du tableau source.
- **u44** (autre) : La fiche le classe secondaire.
- **u45** (autre) : La fiche le classe secondaire.
- **u46** (autre) : La fiche classe l'antibioprophylaxie secondaire.
- **u54** (autre) : La fiche classe l'anastomose sous-péritonéale secondaire.
- **u58** (autre) : La fiche les classe secondaires.

### raac_orthopedique_2019

- **u2** (omission) : La source contient 4 mentions « ABSENCE DE RECOMMANDATION », pas 3 : outre Q2, Q3 et Q7, une 4e (juste après R10.2) porte sur l'analgésie locale/locorégionale après arthroplastie de HANCHE. Elle est absente de la fiche (u2, u5, u12, u29), qui ne garde que R10.2 (genou).

### reduction_antibiotiques_reanimation_2014

- **u16** (population) : La source limite la recommandation au choix de l'antibiothérapie probabiliste d'une PAVM ou d'une bactériémie nosocomiale ; la fiche ne reprend pas cette restriction.
- **u19** (omission) : La fiche omet la conduite positive : considérer un carbapénème si au moins 2 facteurs parmi C3G/FQ/TZP dans les 3 mois, portage BLSE ou P. aeruginosa caz-R < 3 mois, hospitalisation à l'étranger < 12 mois, EHPAD/SLD avec sonde ou gastrostomie, épidémie à BMR dont la seule option est un carbapénème.
- **u48** (sens) : La source recommande une perfusion « allongée » sur 3 ou 4 heures ; la fiche écrit « prolongée/continue », alors que la perfusion continue fait l'objet d'une recommandation distincte, plus restrictive (4a/4b : pas systématiquement, accord faible).
- **u61** (omission) : La fiche omet deux conditions de la source : hémocultures négativées dans les 3 premiers jours, et cathéter retiré.

### remplissage

- **u33** (force) : La fiche déclare les hydroxyéthylamidons « non recommandés » aussi au cours du choc hémorragique, alors que la source n'y formule qu'une recommandation optionnelle (« probablement pas recommandé », GRADE 2-) ; le GRADE 1- ne concerne que le sepsis.

### resection_hepatique_2025

- **u51** (sens) : La fiche regroupe « hépatectomie mineure sur foie sain ou majeure » avec l'option péridurale ; dans la figure, la péridurale n'est proposée que pour l'hépatectomie mineure sur foie sain (cohérent avec R2.7.5).
- **u72** (sens) : La fiche fait passer bas grade et grade intermédiaire par l'étape 4 ; seuls le grade intermédiaire et la cœlioscopie (grade élevé) y passent.

### sdra

- **u4** (ajout) : La source ne mentionne ni les préférences ni les coûts comme déterminants de la force des recommandations ; cette énumération est ajoutée par la fiche.
- **u16** (ajout) : La source préconise une prise en charge médicalisée précoce, sans mentionner de prise en charge « en centre expert » ; le transfert en centre expert y est même cité comme une co-intervention limitant CESAR.

### securisation_proc

- **u134** (grade) : La source ne donne aucune cotation pour cette phrase (la cotation « accord fort » précédente porte sur la surveillance de la VNI) ; la fiche affiche [Fort]. Par cohérence avec les lignes 3.1 sans cotation, afficher [?] ou « non coté ».

### sedation_procedurale_2026

- **u35** (grade) : Formulation négative (« il est recommandé de ne pas utiliser ») taguée GRADE 1 dans la source ; selon la convention, c'est un 1−, la fiche affiche [1+]. Le texte de la fiche est correct.
- **u57** (autre) : La source dit « notamment pendant les 30 premières minutes » ; la fiche écrit « pendant au moins les 30 premières minutes », qui transforme une mise en avant en durée minimale. GRADE 2 conforme.

### sepsis

- **u11** (sens) : La fiche place « Lactate ≥ 11 mmol/L » dans la colonne 3 points (la source le compte 2 points) et omet le palier lactate 5–10,9 mmol/L = 1 point. Le score cardiovasculaire calculé avec la fiche est donc faux pour le lactate.
- **u13** (chiffre) : la source donne 1 point pour Glasgow ≤ 10 et 2 points pour pupilles fixes ; la fiche met Glasgow ≤ 10 dans la colonne 2 points.
- **u14** (omission) : La fiche ne donne que le seuil du 1 point (« < 30 », « < 38 »…) et omet les seuils du 2 points (< 17, < 25, < 31, < 32, < 36, < 51 mmHg). Le sous-score cardiovasculaire peut donc être sous-estimé.

### sepsis_hemodynamique

- **u5** (autre) : La source imprime « > 176 mmol/l » et « > 78 mmol/l ». La fiche les remplace par des µmol/l (correction probable d'une coquille, signalée en u8). Le reste de la ligne est conforme (thrombopénie < 10⁵ = 100 000, 8×10⁴ = 80 000). Cette correction éditoriale est à valider par le médecin relecteur.
- **u18** (grade) : Cet énoncé porte un grade D dans la source. La fiche le présente comme une phrase de liaison non gradée, alors qu'il compte parmi les 2 énoncés de grade D.
- **u43** (ajout) : La source ne porte aucun signe devant « 9 µg/dl » (symbole manquant). La fiche ajoute « < 9 µg/dl », ce qui est vraisemblable mais n'est pas lisible dans le document. À confirmer par le relecteur.

### tabagisme

- **u8** (sens) : Dans la source, « quel que soit son délai » concerne l'augmentation de l'arrêt définitif ; la fiche l'attache au bénéfice proportionnel à la durée, alors qu'un arrêt de 2-4 semaines ne réduit pas les complications respiratoires.
- **u12** (chiffre) : La source s'appuie sur 3 essais randomisés (1246 patients), dont 2 comparant cigarette nicotinée versus placebo, et non sur un seul essai versus absence d'intervention.

### tc_readaptation

- **u12** (grade) : La source distingue deux niveaux : TDM d'admission = recommandation B ; TDM de la 24e heure = avis d'experts. La fiche attribue « AE » à l'ensemble, ce qui sous-cote la TDM d'admission.

### tih

- **u46** (omission) : La fiche dit seulement « si résultat < 3 h, possibilité d'attendre ». Elle omet les deux consignes actives de la figure : arrêter l'héparine et passer à un anticoagulant non héparinique si le résultat demande plus de 3 h, et, si les anticorps sont positifs, poursuivre ou prescrire un anticoagulant non héparinique en attendant le test fonctionnel.

### transfusion_plasma

- **u2** (chiffre) : Comptage des grades : la source porte 7 énoncés grade B (dont « arade B » pour les MAT, coquille), 11 grade C, 16 accord professionnel = 34, et non 6 B / 33. Sans effet sur les recommandations elles-mêmes.

### traumatisme_cranien

- **u16** (force) : La source formule R6.4 « il est probablement recommandé » (tag AE) ; la fiche écrit « il faut », formulation plus impérative.

### traumatisme_membre

- **u25** (omission) : Le tableau de gradation du risque comporte aussi des lignes « lésions anatomiques » (ISS < 25 / > 25 / > 40, TC modéré ou grave, trauma thoracique sévère, lésions abdominales…) et « chirurgie lourde à risque » (laparotomie, ostéosynthèse du rachis en décubitus ventral, angio-embolisation…), absentes de la fiche.
- **u34** (autre) : La fiche écrit « clindamycine ± gentamicine ». La figure source indique une association systématique (« + »). Les autres items (lavage, pansement humide, immobilisation, statut antitétanique, prise en charge chirurgicale) sont conformes.

### traumatisme_vertebromedullaire

- **u5** (sens) : La fiche associe « transport sur matelas coquille » à l'absence d'immobilisation. Dans l'algorithme, le matelas coquille suit l'extraction sur plan dur avec fixateur de tête (u6). La synthèse u41 reprend la même inversion.
- **u6** (omission) : Il manque l'étape « transport matelas coquille » qui suit l'extraction sur plan dur (cf. u5).
- **u41** (sens) : La synthèse reprend « sinon pas d'immobilisation systématique (transport matelas coquille) ». Dans la Figure 1, le matelas coquille suit l'extraction sur plan dur (cf. u5).

### urgences_ob_extrahosp

- **u64** (autre) : La dose retenue par la fiche (100 à 500 µg/h) est juste. Mais la note affirme que la source « imprime 100 à 500 mg/h » : c'est faux, le PDF porte bien « µg/h » (seule l'extraction texte perd le « µ »). La note cite aussi un nom de fichier interne (fiche_sujet_age_esf.py). À reformuler ou supprimer.

### urgences_obstetricales

- **u18** (autre) : Décalage de numérotation : dans la source, R4.1 cite la R2.1 2020 (antihypertenseur si PAS ≥160 / PAD ≥110). La fiche ne donne pour R4.1 que l'argumentaire, et place le contenu de la R2.1 sous R4.2.
- **u19** (autre) : Dans la source, R4.2 cite la R2.8 2020 (MgSO4 anténatal si pré-éclampsie sévère avec signe de gravité), pas la R2.1. Les R4.x sont des avis d'experts qui citent des recommandations GRADE 1+.
- **u20** (autre) : Dans la source, R4.3 ne cite que la R2.12 (MgSO4 après éclampsie) ; la R2.8 appartient à R4.2.

### vni

- **u8** (grade) : La fiche classe l'IRA hypoxémique de l'immunodéprimé et le post-opératoire de chirurgie thoracique et abdominale en G1+ (« il faut faire »). La source les classe G2+ (« il faut probablement faire »), ce que confirment les recommandations de la Q2 (G2+).
- **u9** (omission) : Ces deux indications manquent dans la ligne G2+ de la fiche (déplacées à tort en G1+, cf. u8).

## Vocabulaire interne visible (à nettoyer)

- blocs_perimedullaires_infectieux_2006 u1 : texte de travail interne visible par le lecteur (« installment 8/n », « superseded », liste des fiches à venir) — à reformuler.
- blocs_perimedullaires_terrain_cardioresp_2006 u1 : texte de travail interne visible (« installment 5/n », « superseded ») — à reformuler.
- blocs_perimedullaires_hemostase_2006 u1, u20 : texte de travail interne visible (« installment 6/n », « chippée », « disclosed ») — à reformuler.
- blocs_perimedullaires_echec_2006 u1, u34 : texte de travail interne visible (« installment 9/n », « installment à venir ») — à reformuler.
- blocs_perimedullaires_neuro_2006 u1, u25, u42 : texte de travail interne visible (« installment 7/n », « disclosed (règle 4) ») — à reformuler.
- blocs_perimedullaires_cesarienne_2006 u1 : texte de travail interne visible (« installment 3/n », « superseded ») — à reformuler.
- blocs_perimedullaires_technique_2006 u1 : texte de travail interne visible (« installment 2/n ») — à reformuler.
- blocs_perimedullaires_complications_2006 u1, u23, u51 : texte de travail interne visible (« installment 10/10 », « chip », « disclosed (règle 4) ») — à reformuler.
- blocs_perimedullaires_postop_2006 u1, u99 : texte de travail interne visible (« installment 4/n », « Disclosure méthodologique », « grade X ») — à reformuler.
- antibioprophylaxie u1, u21 : la fiche cite la V3.0 du 04/05/2026 ; la source en ligne est la V3.1 du 10/07/2026 (amendement chirurgie digestive néonatale, Champ 3 non couvert). u2 : « disclosure explicite » visible.
- corticotherapie u2, u9, u15, u25 : vocabulaire interne visible (« chip », « disclosée ») — à reformuler.
- gestion_traitements_chroniques_cardio_2009 u1 : « disclosed explicitement » visible.
- gestion_traitements_chroniques_douleur_toxico_2009 u1, u48 : vocabulaire interne visible (« disclosed », « règle anti-fabrication de grade »).
- gestion_traitements_chroniques_neuro_psy_2011 u2 : vocabulaire interne visible (« disclosed », « chips »). u22 : condition d'un énoncé grade D rattachée à l'accord fort (IMAO ancienne génération).
- facteurs_humains_2022 u1 : « Décompte source vérifié exact » (note de travail interne visible).
- aod_programme u2 : « Aucun chip de grade » ; u3 : note interne sur le doublon d'indexation de la bibliothèque ; u18/u23 : « transcrit fidèlement depuis un rendu visuel 220dpi » — notes de travail visibles.
- thrombectomie u2, u15, u22, u28 : « disclosure(s) » visible ; u15/u22 notes sur les variantes de titres de champs (internes).
- raac_orthopedique_2019 u2 : « disclosed », « voir docstring du script » (jargon interne visible) ; la 4e absence de recommandation (analgésie hanche) manque.
- mieux_vivre_reanimation u2 : « sans chip numérique inventé » (jargon interne).
- traumatisme_abdominal u22, u28 : « pure image, sans calque de texte extractible — vérifié visuellement » (note de travail visible).
- aap_programmee u1 : « Complète la fiche déjà construite dans ce site » ; u2 : « disclosure », « disclosés » (jargon interne visible).
- tests_viscoelastiques u26 : « (disclosed) » visible.
- relations_anesth_chir u2 : « chip de grade inventé » ; u11 : « Disclosure » (jargon interne visible).
- tc_readaptation u2 : « disclosed » visible.
- anesth_cardiopathie_congenitale u34 : « disclosed comme hors périmètre de cette passe » + note sur les noms de fichiers sfar.org (notes internes visibles). Fiche pratique #1 vérifiée sur le PDF des fiches pratiques (wpdmdl=50051), absent du cache du script.
- eeg_cortical u8 : description du relevé (« relevé pixel », « règle 1 », « première lecture visuelle ») et u15 : « disclosed » — notes de travail visibles.
- erreurs_medicamenteuses_2024 u1 : « fiche déjà git-trackée » (jargon interne visible).
- programme_optimisation_perioperatoire_2022 u1, u25 : « git-trackées », « décompte source vérifié exact » (jargon interne visible).
- remplissage_perioperatoire u22 : « Disclosure » visible.
- transfusion_gr_anesth_2014 u1 : « disclosed explicitement » visible.
- eclsa u1 : « tableau à chips » ; u14 : « Exception disclosée » (jargon interne visible).
- tracheotomie u3 : « Note de correction d'extraction (disclosure) », « bug d'extraction » (notes internes visibles).
- traumatisme_pelvien u1 : « disclosure de la source » visible.
- alr_pediatrique_2026 u1 : « trouvé hors du processus habituel de ce dépôt (absent de library_final.json) » (note interne visible).
- brule_grave u2 : note interne sur la vérification des annexes (« rendu visuel à 170dpi de 9 pages cibles ») visible.
- sauv u2 : « chip de grade inventé » (jargon interne visible).
- traumatisme_cranien_grave_precoce u2 : « Vérifié par recomptage exhaustif » ; u35 : « vérifié ligne à ligne » (notes internes visibles).
- controle_temperature u2 : « Vérification indépendante… ce corpus » ; u3 : « disclosure », « chips » (jargon interne visible).
- organisation_anesthesie_pediatrique_2023 u1 : « fiche déjà git-trackée » (jargon interne visible).
- raac_lobectomie_pulmonaire_2019 u12 : « cf. légende ci-dessus », « l'un des 2 ou 3 cas selon la section » (note interne visible).
- voies_aeriennes_bloc_2026 u1 : « trouvé hors du processus habituel de ce dépôt (absent de library_final.json) », « disclosed » (notes internes visibles).
- aap_urgence u1 : « chipée « AE » » — jargon interne visible (chip/pastille).
- douleur_reactualisation_2016 u3/u4/u13/u18/u34 : « disclosée », « disclosure », « tag par tag », « tag imprimé », « imprime » — jargon interne visible ; u36 annonce un tableau de doses maximales absent de la fiche.
- sevrage_vm u3 : « disclosed », « grade_chip », « vérifié par extraction exhaustive » — jargon interne visible.
- urgences_vitales_ih_2026 u1 : « library_final.json », « disclosed », « trouvé hors du processus habituel de ce dépôt » — jargon interne visible.
- ivg_14sa u2 « disclosed … cf. règle 5 du projet », u3 « chip AP », u36 « incohérence source disclosed » — jargon interne ; u11 texte tronqué « (séjour (AP) ».
- pavm u5 : « vérifié tag par tag » — jargon interne visible.
- sujet_age_esf u2 : « chip », « chippé », « Disclosure — bug d'extraction PDF corrigé », « rendu visuel à 200 dpi » — jargon interne visible.
- ponction_lombaire u2 : « sans chip de force » — jargon interne visible.
- erreurs_medicamenteuses u2 : « jamais en chip de grade inventé » — jargon interne visible.
- insuffisance_analgesie_cesarienne u2/u3/u22/u36 : « tag », « Disclosure », « rendu visuel à 200dpi », « couche texte » — jargon interne visible.
- urgences_transfusionnelles_obstetricales u2/u3/u19/u48 : « disclosure », « chip de grade », « library_final.json », « index interne du projet » — jargon interne visible (u3 entier à retirer de l'affichage).
- aod_urgence u3/u14/u31/u42 : « disclosed », « Défaut de production du PDF source disclosed » — jargon interne visible.
- infections_intra_abdominales_2026 u1 : « library_final.json », « trouvé via recherche web » — jargon interne visible.
- bris_dentaires u2 : « chippée », « extension locale de la légende de ce site » — jargon interne visible.
- chir_ambu_proctologie u44 : « Disclosure », « chippées AE » — jargon interne visible.
- civd u18 : « (disclosure) » — jargon interne visible.
- examens_preinterventionnels u2 : « Vérifié par grep exhaustif », « tags », « Disclosure » — jargon interne visible.
- infarctus_myocarde u9 : « voir disclosure méthodologique » — jargon interne visible.
- sepsis_hemodynamique u1/u2/u8/u50/u52 : « disclosure », « comptage automatisé », « rendu à 600 dpi », « funnel_diagram de la fiche IRA » — jargon interne visible.
- catheters_veineux_centraux u2: « Convention de couleur de cette fiche » (texte interne visible)
- examens_pertinence_rea u2/u40: « règle 5, disclosed », « anomalie disclosed »
- raac_colorectal u2: « chip AP »
- nutrition_clinique_2026 u1: « trouvé via recherche web (absent de library_final.json) »
- sedation_reanimation u1: « chipée AE »
- pancreatite u2: « chip AE », « chip SR »
- voies_aeriennes_adulte u1/u2/u65: « disclosées », « disclosure », « disclosé »
- infections_intra_abdominales u53: « rendu visuel direct à 170dpi » ; u6: « Disclosure »
- traumatisme_cranien u2: « chippée AE »
- sedation_procedurale_2026 u1: « absent de library_final.json »
- resection_hepatique_2025 u28: « déjà git-trackée dans ce corpus » ; u76: « disclosed »
- candidoses_aspergilloses u63: « cf. docstring du module » ; u2/u22/u54: « disclosure »
- hospit_ambulatoire: u2 « par un chip déduit » (jargon d'interface : chip)
- antibiotherapie_probabiliste: u1 « Méthodologie et disclosure », « Vérifié par lecture exhaustive » (méta-commentaire de rédaction)
- glycemie: u2/u3/u38/u44 « chips », « Disclosure », « disclosés », « 250 dpi » (méta-commentaire de rédaction)
- allergie_prevention: u1/u2 « disclosure », « chip de grade » ; u69/u82 renvois au nom de fichier Fiche_SFAR_Anaphylaxie_2025.pdf
- recommandations_avk: u2 « chip AP », « Vérifié exhaustivement par grep (texte aplati) », « Disclosure »
- hsa: u2 « disclosure », « disclosés »
- asthme_aigu_grave: u3 « disclosed tel quel », u79 « Limite disclosed »
- mtev_perioperatoire: u2/u3 « vérifiée par recherche exhaustive sur l'extraction texte », u61 « vérifié par rendu visuel », « Redessin structuré »
- mtev_perioperatoire: u2/u3 « vérifiée par recherche exhaustive », u61 « vérifié par rendu visuel », « Redessin structuré »
- avc_precoce: u2 « Vérifié exhaustivement par grep (texte aplati…) », « chip AP » ; u53 « disclosure méthodologique »
- nutrition_perioperatoire: u88 « portée partielle disclosed »
- nutrition: u1 « chip coloré » ; u2 « disclosure »
- blocs_peripheriques_membres: u2 « chip CP »
- douleur_postoperatoire: u2 « Chip Fort/Faible », « résolution textuelle disclosée »
- coronarien: u50 « Disclosure » ; u103 « rendu à 150dpi »
- urgences_ob_extrahosp: u64 nom de script interne « fiche_sujet_age_esf.py », « disclosed » ; u55/u85 « disclosed »
- tih: u2 « vérifié exhaustivement » ; u58/u87 « Disclosure »
- mort_encephalique: u2 « audit indépendant à l'aveugle … grep exhaustif », « Chip », « disclosée »
- mal_epileptique u1/u2: « disclosure », « grep », « script source »
- sedation_urgences u49/u58/u60/u68 : notes de transcription (400dpi, « en tête de fichier »)
- securisation_proc u31-35 : chip [?] sans légende
