# Suivi de la migration Tâche 1 — fiches → recommandations atomiques

Chaque fichier `NNNN_migrate_<clé>.sql` migre un fiche de
`rfe-sfar-website/build/content_<clé>.json` vers `documents` +
`document_societies` + `document_specialties` + `recommendations` (schéma
`supabase/schema_v2.sql`). Tous idempotents (`on conflict ... do nothing`),
testés par exécution réelle contre PostgreSQL 16 avant commit. Toutes les
recommandations sont insérées en statut `draft` — jamais `active` : la
relecture/validation humaine (contrainte `recommendations_active_requires_review`
de `schema_v2.sql`) reste entièrement à faire par l'équipe éditoriale.

Numérotation `recommendation_code` : `MG-ANES-{séquence document sur 6
chiffres}-R{rang}`. La séquence est attribuée dans l'ordre de migration
(pas de rapport avec l'ordre des 160 items de `library_final.json`) — le
tableau ci-dessous fait foi pour éviter toute collision entre lots.

## Fiches migrées (99 / 99 disponibles côté rfe-sfar-website — TÂCHE 1
## COMPLÈTE au 2026-09-20. Initialement close à 59/59, reprise le 2026-09-11
## après ajout des fiches 60 puis 61, reprise à nouveau le 2026-09-13 (routine
## planifiée) après découverte de 11 fichiers `content_*.json`
## supplémentaires non encore migrés (close à 72/72), reprise une troisième
## fois le 2026-09-15 (routine planifiée) après découverte de 4 fichiers
## `content_*.json` supplémentaires ajoutés côté rfe-sfar-website entre-temps
## (`amygdalectomie_enfant`, `douleur_reactualisation_2016`, `ponction_lombaire`,
## `protection_oculaire`), tous les quatre migrés (close à 76/76, "TÂCHE 1
## COMPLÈTE" à l'époque) — puis reprise une quatrième fois le 2026-09-19
## (routine planifiée) après découverte que `rfe-sfar-website` avait en
## réalité avancé à 99 fiches construites sur une branche orpheline
## (`claude/loving-ritchie-t2ggs2`, jamais rattachée à la PR ouverte) —
## voir section "Lot du 2026-09-19" ci-dessous pour le détail de cette
## découverte et l'état de la reconciliation de branches.)

## ⚠️ Fiches 100-144 en attente de migration (ajoutées côté rfe-sfar-website le 2026-09-20/22)

Une routine planifiée a construit cinq fiches supplémentaires côté
`rfe-sfar-website` dans la même session :

- **100 : `hospit_ambulatoire`** — "Prise en charge anesthésique en
  hospitalisation ambulatoire", SFAR RFE 2009, 71 recommandations, 8e
  convention de cotation distincte de ce corpus : force encodée
  uniquement par le verbe modal, pas de grille GRADE imprimée.
- **101 : `echo_alr`** — "Échographie en anesthésie locorégionale", SFAR
  RFE 2011, 9e convention de cotation distincte : texte narratif sans
  numérotation, force à 3 niveaux (R/PR/P) portée par une locution
  modale du texte source. Contient un vrai tableau (Tableau 1 —
  classement des dispositifs médicaux) à reproduire fidèlement si migré
  en `source_section`/notes.
- **102 : `alr_douleur_chronique`** — "Techniques analgésiques
  locorégionales et douleur chronique", SFAR RFE 2013, méthodologie
  GRADE standard (pas une nouvelle convention), 43 énoncés (33
  recommandations réellement gradées 1+/1-/2+/2-/AE + 9 énoncés où la
  source déclare explicitement qu'aucune recommandation n'est possible
  faute de données [distinct d'un grade négatif — attention à ne PAS
  migrer ces 9 avec un `grade` négatif inventé, `grade` doit rester NULL
  pour elles] + 1 énoncé permissif non gradé explicitement). 7 des 9
  énoncés "aucune reco possible" sont, de façon incohérente, aussi
  étiquetés "Avis d'experts" par la source elle-même malgré n'être pas
  des recommandations — disclosed dans la fiche, à re-disclosed si migré.
- **103 : `infections_nosocomiales_rea`** — "Prévention des infections
  nosocomiales en réanimation", 5e Conférence de Consensus SFAR/SRLF
  2008/2009, 10e convention de cotation distincte : la source dit
  s'inspirer de GRADE mais n'imprime jamais de symbole — force portée
  par la locution verbale (« il faut »/« il faut probablement »),
  transcrite en chips standard 1+/1-/2+/2- (équivalence explicitement
  énoncée par la source elle-même) + un chip « 0/ » pour 3 énoncés sans
  position possible (même piège que pour `alr_douleur_chronique` : NE
  PAS migrer ces 3 avec un `grade` négatif inventé, `grade` doit rester
  NULL). Contient un vrai tableau chiffré (Tableau 1, épidémiologie REA
  Raisin 2006) et 5 encadrés de critères diagnostiques condensés en
  tableau de référence.
- **104 : `nutrition_perioperatoire`** — "Nutrition périopératoire
  (chirurgie programmée de l'adulte)", actualisation 2010 SFAR/SFNEP.
  À NE PAS CONFONDRE avec le document déjà migré `nutrition` (2014,
  patients de réanimation) — deux documents distincts, vérifié. Méthode
  avis d'experts avec correspondance GRADE fort/faible explicitement
  énoncée par la source, transcrite en 1+/1-/2+/2-. 71 recommandations
  numérotées R1-R71, dont 10 énoncés purement définitionnels/descriptifs
  (chip « Def. » — NE PAS migrer ces 10 avec un `grade` GRADE inventé,
  `grade` doit rester NULL pour elles, même piège que les fiches
  précédentes). Portée partielle disclosed sur les Tableaux 3-6
  (protocoles croisés très denses) — condensés en synthèse plutôt que
  reproduits intégralement, à rester disclosed si migré.
- **105 : `ivg_14sa`** — "Prise en charge de l'interruption volontaire de
  grossesse jusqu'à 14 semaines", ANAES, mars 2001 (màj partielle déc.
  2010 par la HAS, IVG médicamenteuse uniquement). Grille de grade
  propre à ce document — **PAS GRADE, PAS le système Sfar fort/faible** :
  grille ANAES à 3 niveaux **A/B/C** (A = essais randomisés de forte
  puissance/méta-analyses ; B = essais randomisés de faible puissance/
  cohortes ; C = cas-témoins/séries de cas), avec un chip **AP** (accord
  professionnel) pour tout énoncé non explicitement gradé — convention
  explicite du texte source lui-même (« en l'absence de précision, les
  recommandations proposées correspondent à un accord professionnel »).
  **NE PAS migrer les items AP avec un `grade` NULL confondu avec les
  chips « 0/ » d'`alr_douleur_chronique` ou « Def. » de
  `nutrition_perioperatoire`** — sémantiquement différent : AP signifie
  ici *consensus professionnel explicite* (le texte source le nomme
  ainsi), pas *absence de position possible* (0/) ni *item purement
  descriptif* (Def.). Si le schéma de migration a besoin d'un champ
  texte pour la grille (`grade_scale` ou équivalent), consigner "ANAES
  A/B/C + AP" pour ce document plutôt que "GRADE" par défaut. 29 blocs de
  contenu au total (thèmes + recommandations gradées), dont seulement 8
  énoncés portent un grade A/B/C explicite (3×A, 3×B, 2×C — décompte
  vérifié par grep sur le texte source avant finalisation ; une première
  version du script avait mal compté "7" au lieu de 8, corrigée en
  audit). Disclosure retenue dans la fiche : le
  PDF source indique que les passages modifiés en 2010 apparaissent « en
  rouge » dans le document original, information de couleur perdue à
  l'extraction texte — impossible de distinguer le texte 2001 du texte
  amendé 2010 dans le contenu migré ; ce document couvre uniquement la
  technique **chirurgicale** et les éléments communs aux deux méthodes
  d'IVG (l'IVG médicamenteuse elle-même est explicitement hors périmètre,
  renvoyée aux recommandations HAS 2010 non incluses dans le PDF source).
- **106 : `aod_programme`** — "Gestion des Anticoagulants Oraux Directs
  pour la chirurgie et les actes invasifs programmés", GIHP, propositions
  réactualisées septembre 2015. **Aucune grille de grade** — ni GRADE, ni
  A/B/C, ni fort/faible Sfar : ce document est un ensemble de
  "propositions" pragmatiques d'un groupe d'intérêt, sans cotation
  formelle. **Si le schéma de migration exige un `grade` non-NULL par
  recommandation, ce document ne peut pas en fournir un** — les 17 blocs
  de contenu (thèmes + 2 tableaux transcrits visuellement) doivent migrer
  avec `grade = NULL` en totalité, pas seulement pour un sous-ensemble
  comme pour les fiches précédentes de ce lot. Distinct de la fiche déjà
  migrée `aod_urgence` (gestion en URGENCE) — celui-ci couvre la gestion
  PROGRAMMÉE (acte électif, délai d'arrêt préétabli) ; vérifié par grep
  avant construction, aucune collision de contenu. **Doublon d'indexation
  disclosed** : ce document apparaît deux fois dans
  `rfe-sfar-website/build/library_final.json` sous deux années
  différentes ("2015" et "2021", deux URL sfar.org distinctes) mais il
  s'agit du même document (page de titre et bibliographie de 18
  références strictement identiques entre les deux PDF sources) — la
  fiche est indexée sous les deux needles côté site pour couvrir les deux
  entrées, mais **une seule recommandation-set doit être migrée**, pas
  deux, si jamais un futur script de migration itère sur
  `library_final.json` plutôt que sur `content_<clé>.json` (piège
  potentiel à surveiller).
- **107 : `blocs_peripheriques_membres`** — "Les blocs périphériques des
  membres chez l'adulte", SFAR/Sofcot/Sofmer, RPC 22 septembre 2001
  (Ann Fr Anesth Réanim 22 (2003) 567-581). **Grille EBM propre à ce
  document — PAS GRADE, PAS ANAES A/B/C, PAS Sfar fort/faible** : 5
  niveaux de preuve **A/B/C/D/E** (A = ≥2 études niveau I, la plus forte,
  jusqu'à E = études niveau IV/V) **plus un chip CP** (consensus
  professionnel/avis d'experts) pour les énoncés sans aucune étude — CP
  est sémantiquement distinct du Grade E : Grade E reste une catégorie de
  preuve (études de faible niveau), CP signale l'absence totale d'étude.
  **Ne pas confondre les 5 niveaux A-E de ce document avec les 3 niveaux
  A/B/C d'`ivg_14sa` (fiche 105)** — même lettres, échelles différentes,
  bien vérifier quel document est migré avant de mapper un grade. 31
  blocs de contenu (dont 2 tableaux transcrits visuellement : Tableau 1
  indications chirurgicales membre supérieur, tableau des doses
  maximales d'anesthésiques locaux). Document RPC de 2001, non abrogé,
  toujours actif dans le corpus SFAR (complété mais non remplacé par la
  RFE 2011 sur l'échographie en ALR déjà migrée sous `alr_perinerveuse`).
- **108 : `raac_colorectal`** — "Réhabilitation rapide après une chirurgie
  colorectale programmée", SFAR/SFCD, RFE 2014. 35 recommandations,
  méthode GRADE standard (1+/1-/2+/2-, déjà connue de ce corpus).
  **Particularité de migration à ne pas perdre : chaque recommandation
  porte DEUX cotations indépendantes** — le grade GRADE habituel (absent
  pour 5/35 recommandations, faute de preuves suffisantes — ces 5
  doivent migrer avec `grade = NULL`, même piège que les fiches
  précédentes) ET un résultat de vote Delphi séparé, "Accord Fort" ou
  "Accord Faible" (présent pour les 35 sans exception). Si le schéma de
  migration ne prévoit qu'un seul champ de force/cotation par
  recommandation, **ces deux informations ne doivent pas être fusionnées
  ni l'une écrasée par l'autre** — envisager un champ texte libre
  supplémentaire (ex. `consensus_note`) pour conserver le résultat
  Delphi si le schéma n'a pas de colonne dédiée. Inclut un tableau
  annexe de synthèse par paramètre (21 lignes, recommandation
  principale/secondaire/absence de recommandation) reproduit
  intégralement depuis la source.
- **109 : `chir_ambu_proctologie`** — "Chirurgie ambulatoire en
  proctologie", SNFCP/ANAP/SFAR, mars 2015. Grille A/B/C/AE (accord
  d'experts) — **sur 43 recommandations, seules 3 portent un grade A
  explicite ; le reste (40/43) doit migrer avec `grade = NULL`** si le
  schéma ne modélise pas "AE" comme une valeur de grade à part entière
  (piège identique aux fiches précédentes de ce lot, mais ici la
  proportion non gradée est particulièrement élevée : 93 %). Deux
  recommandations sources (R15, R27) fusionnaient dans le texte
  original une clause gradée A et une clause non gradée dans le même
  paragraphe numéroté — scindées ici en `R15a/R15b/R15c` et
  `R27a/R27b` (46 lignes au total pour 43 recommandations numérotées) ;
  **un futur import ne doit pas tenter de refusionner ces sous-lettres
  dans une seule ligne R15/R27**, la scission est intentionnelle
  (anti-composite-grade). Deux recommandations (R37, R40) n'ont aucun
  marqueur de grade imprimé dans la source ; chippées "AE" par défaut
  et disclosed comme telles dans la fiche — à vérifier si une relecture
  humaine ultérieure du texte source confirme ce choix par défaut.
- **110 : `mieux_vivre_reanimation`** — "Mieux vivre la Réanimation",
  SFAR/SRLF, 6e Conférence de Consensus, novembre 2009. **Convention de
  cotation la plus éloignée d'un système de grade migrable telle
  quelle** : ce document n'imprime AUCUN symbole de grade — la force de
  chaque énoncé est portée uniquement par le verbe modal du texte
  français lui-même (« il faut », « il faut probablement », « il est
  possible »...), plus un sigle **RC** (recommandation consensuelle)
  pour les énoncés sans référence scientifique. **Si le schéma de
  migration a une colonne `grade` typée (ex. enum GRADE), ce document
  entier doit migrer avec `grade = NULL`** — il n'y a pas de mapping
  raisonnable entre les locutions modales françaises et une échelle
  A/B/C/GRADE/1+/2+ sans fabriquer une correspondance que le texte
  source ne fournit pas. Envisager de conserver la locution modale
  elle-même dans un champ texte (ex. `grade_note` ou équivalent) plutôt
  que de la perdre. 16 blocs de contenu couvrant 5 thématiques
  (barrières, environnement, soins, communication, processus
  décisionnel) — la Question 1 (barrières, très majoritairement
  descriptive/épidémiologique) a été condensée dans la fiche
  conformément à la règle de projet sur l'argumentaire minimal ; les
  Questions 2-5 sont transcrites intégralement.
- **111 : `preparation_colique`** — "Préparation colique et anesthésie
  générale", position commune SFED/SFAR, validée 7 juillet 2016 (SFED)
  / 21 septembre 2016 (SFAR). **Aucune grille de grade, aucune
  recommandation numérotée** — texte de position commune, synthèse
  narrative de la littérature (méta-analyses, essais cliniques) avec
  conclusions pratiques et deux tableaux. **Si le schéma de migration
  exige un `grade` non-NULL, ce document entier doit migrer avec
  `grade = NULL`**, comme `aod_programme` (fiche 106) et
  `mieux_vivre_reanimation` (fiche 110) — pas de mapping possible entre
  ce texte narratif et une échelle de grade. 20 blocs de contenu,
  incluant les deux tableaux pratiques de la source reproduits
  intégralement (Tableau I : liste des situations ralentissant la
  vidange gastrique ; Tableau II : délais de jeûne — alimentation
  légère/préparation colique/autres liquides clairs — selon l'horaire
  programmé de la coloscopie). Recommandation pratique centrale : délai
  de 3h entre dernière prise de préparation colique et induction
  anesthésique (vs 2h pour les autres liquides clairs standards).
  Distinct de `raac_colorectal` (fiche 108), qui mentionne la
  préparation colique mécanique uniquement comme pratique jugée inutile
  en chirurgie colorectale — pas de chevauchement de contenu, vérifié
  avant construction.
- **112 : `organisation_ar_obstetricale`** — "Organisation de
  l'anesthésie-réanimation obstétricale", SFAR (avec Caro, CNGOF, CNSF,
  Société française de néonatologie), Recommandations Professionnelles,
  validées 11 décembre 2015, Anesth Réanim 2016;2:206-212. **Convention
  de cotation la plus simple de ce corpus : un seul niveau de consensus
  pour l'ensemble du document** — cotation Delphi (échelle 1-9, 2
  tours), accord fort obtenu pour les 30 recommandations sans exception
  (100 %, vérifié par comptage direct contre l'affirmation du texte
  source). **Si le schéma de migration a une colonne `grade` typée
  GRADE/A-E/etc., ce document doit migrer avec un chip/valeur dédiée
  "Accord Fort" (ou `grade = NULL` si le schéma ne modélise pas de
  consensus Delphi) — pas de mapping vers une échelle GRADE qui
  n'existe pas dans ce texte.** Particularité distincte à ne pas perdre
  : **13 des 30 recommandations portent en plus un astérisque dans le
  texte source lui-même**, signalant qu'elles relèvent aussi d'une
  disposition légale ou réglementaire (décrets de 1994/1998, circulaire
  de 2006, etc.) — information disjointe du niveau de consensus (toutes
  les 30 sont "accord fort", légales ou non) ; si le schéma de migration
  a un champ booléen ou texte libre disponible (ex. `legal_basis` ou
  `notes`), envisager de le préserver plutôt que de le perdre au
  passage. Vérifié un par un contre le texte source avant finalisation
  (13/30 marquées : RP1, RP2.1, RP2.5.2, RP2.6, RP3.1, RP3.4, RP3.6,
  RP3.8, RP3.9, RP3.14, RP4.3, RP4.4, RP4.5). 29 blocs de contenu
  couvrant les 4 chapitres du texte source (locaux/équipements,
  personnels/effectifs, parcours de soins, qualité/formation) plus
  l'Annexe 1 (soins maternels de recours, liste de conditions
  opérationnelles) reproduite intégralement. Document sans lien de
  contenu avec les fiches obstétricales déjà migrées (`preeclampsie`,
  `hemorragie_post_partum`, etc.) — celui-ci porte sur l'organisation
  des services, pas sur la prise en charge clinique d'une pathologie
  donnée ; vérifié par grep avant construction, aucune collision.
- **113 : `erreurs_medicamenteuses_ar_2016`** — "Prévention des erreurs
  médicamenteuses en anesthésie et en réanimation" (texte court), SFAR
  en partenariat avec la SFPC, actualisation 2016. **Aucune grille de
  grade — 10 préconisations narratives numérotées (1 à 10), même
  convention que `aod_programme` (fiche 106)** : si le schéma de
  migration exige un `grade` non-NULL, ce document entier doit migrer
  avec `grade = NULL`. **Piège de collision de clé à ne pas commettre**
  : il existe déjà une fiche migrée sous la clé `erreurs_medicamenteuses`
  ("Prévention des erreurs médicamenteuses en anesthésie", SFAR seule,
  **2006**) — **113 est un document différent** (actualisation 2016,
  coécrite avec la SFPC, périmètre élargi explicitement à la
  réanimation, ajout d'une préconisation dédiée aux soins critiques) ;
  vérifié par needle sur les deux URLs sfar.org
  (`preverreurmedic_recos.pdf` en 2006 vs `texte-court-preco-erreurs-
  med-2016` en 2016), aucun chevauchement d'URL ni de clé côté site. Si
  une future migration traite les deux documents comme un seul parce
  qu'ils partagent un titre très proche, elle fusionnerait à tort deux
  jeux de recommandations distincts (le document 2006 reste
  spécifiquement anesthésie ; le document 2016 couvre aussi la
  réanimation et remplace/actualise le premier sans l'annuler côté
  bibliothèque SFAR — les deux restent indexés séparément dans
  `library_final.json`). 12 blocs de contenu couvrant les 10
  préconisations (stratégie/organisation, facteurs de risque/formation,
  spécificités réanimation, prévention active/passive, rangement/
  étiquetage détaillé par sous-point a-e, protocoles, gestion des
  erreurs/retour d'expérience).
- **114 : `anesth_pediatrique_structures`** — "Recommandations pour les
  structures et le matériel de l'anesthésie pédiatrique", SFAR,
  septembre 2000. **Aucune grille de grade, aucune recommandation
  numérotée** — texte narratif de spécifications structurelles (salle
  d'intervention, transferts, SSPI, hospitalisation post-opératoire,
  laboratoires) et matérielles (assistance respiratoire, abord
  vasculaire, défibrillateur, monitorage, hypothermie, transport,
  solutés), avec beaucoup de valeurs chiffrées concrètes (tailles de
  sondes/masques/cathéters, volumes, débits, températures). **Si le
  schéma de migration exige un `grade` non-NULL, ce document entier
  doit migrer avec `grade = NULL`**, même famille que `aod_programme`
  (106) et `preparation_colique` (111). **Particularité à ne pas
  perdre au moment de la migration** : contrairement aux fiches
  purement "recommandation" de ce corpus, une bonne partie du contenu
  actionnable ici est une **valeur numérique de spécification**
  (ex. "tailles de sondes 2,5 à 6,5", "brassards tailles 1 à 4",
  "délai 3-5h") plutôt qu'une phrase de type "il est recommandé de..."
  — si le schéma de migration attend un champ `recommendation_text`
  de forme impérative, ces blocs de spécification matérielle
  devraient probablement être migrés tels quels (valeur + contexte)
  plutôt que reformulés en fausses recommandations verbales. Distinct
  de la RPP SFAR 2023 "Organisation de l'anesthésie pédiatrique"
  (organisation des centres, non construite dans ce lot) — vérifié par
  titre avant construction, aucune collision. 11 blocs de contenu
  couvrant les 2 parties du texte source (Structures, Matériel).
- **115 : `aod_dabigatran_urgence_2016`** — "Prise en charge des
  hémorragies et des gestes invasifs urgents chez les patients recevant
  un anticoagulant oral et direct anti-IIa (dabigatran)", GIHP,
  réactualisation septembre 2016. **Aucune grille de grade** —
  propositions pragmatiques du GIHP, même famille que `aod_programme`
  (106) et `aod_urgence` (déjà migré) : si le schéma exige un `grade`
  non-NULL, ce document entier migre avec `grade = NULL`.
  **Particularité de contenu unique dans ce corpus à ce jour** : le
  cœur actionnable n'est pas une liste de recommandations textuelles
  mais **3 algorithmes décisionnels** (arbres de décision) reçus comme
  images pures dans le PDF source (vérifié via `page.get_images()`,
  aucune couche de texte) et **transcrits en tableaux de décision**
  (colonnes Situation / Critère / Conduite à tenir) plutôt qu'en
  recommandations numérotées classiques. **Si un futur script de
  migration itère sur un pattern `R\d+` ou une liste de
  recommandations numérotées pour extraire les lignes à migrer, il ne
  trouvera rien pour ce document** — les 20 blocs de contenu de
  `content_aod_dabigatran_urgence_2016.json` sont structurés en lignes
  de tableau de décision (condition → action), pas en recommandations
  R1/R2 ; un mapping dédié sera nécessaire pour ce document (et pour
  tout futur document de la même famille "algorithme décisionnel").
  **Piège de collision à ne pas commettre** : ce document est
  **complémentaire, pas doublon**, de la fiche déjà migrée
  `aod_urgence` (GIHP 2013, dabigatran + rivaroxaban, PRE-antidote
  spécifique, déjà disclosed comme daté/incomplet) — celui-ci le
  remplace uniquement pour le volet dabigatran (nouvel antidote
  idarucizumab intégré) ; `aod_urgence` reste la seule source pour les
  principes généraux applicables au rivaroxaban dans ce corpus. Ne pas
  fusionner les deux documents ni supprimer `aod_urgence` lors d'une
  future migration — vérifié par needle et par contenu (49 occurrences
  "idarucizumab", absentes de `aod_urgence`) avant construction.
- **116 : `tc_readaptation`** — "Les traumatisés crâniens adultes en
  médecine physique et réadaptation : du coma à l'éveil", SOFMER,
  Conférence de consensus, 8 octobre 2001. **Grille de grade la plus
  complexe rencontrée dans ce corpus à ce jour : DEUX échelles A/B/C
  DIFFÉRENTES au sein d'un même document**, selon la question traitée
  (Questions 1-2 : échelle pronostique/validation d'échelle ;
  Questions 3-4 : échelle Canadian Task Force d'efficacité
  thérapeutique) — **mêmes lettres A/B/C, critères différents**. La
  fiche a fait un choix délibéré de ne PAS créer deux jeux de chips
  visuellement distincts (aurait nécessité un système de double-lettre
  ou de couleur dédoublée) et a disclosed la distinction dans le texte
  de méthodologie à la place. **Si le schéma de migration a un champ
  `grade_scale` ou équivalent, ce document nécessite de savoir, pour
  chaque recommandation migrée, sous quelle Question (donc quelle
  échelle) elle a été énoncée** — l'information Q1/Q2 vs Q3/Q4 est
  disponible via le préfixe de la référence assignée par la fiche
  (`Q1.x`/`Q2.x` vs `Q3.x`/`Q4.x`), à ne pas jeter lors d'une
  migration. En plus des grades A/B/C, deux catégories non gradées
  **distinctes l'une de l'autre selon le texte source lui-même** :
  **AE** (avis d'experts — situé dans la littérature, au niveau C/III)
  et **AP** (accord professionnel — aucune publication dans la
  littérature) ; ne pas les fusionner sous un même "pas de preuve" si
  le schéma de migration a une distinction équivalente disponible.
  **Numérotation Q#.# entièrement assignée par cette fiche** — le
  texte source ne numérote aucune de ses recommandations (contrairement
  à la plupart des RFE/RPC de ce corpus) ; ne pas présenter cette
  numérotation comme native à la source dans une future migration. 21
  blocs de contenu couvrant les 4 questions du jury. Distinct des deux
  autres documents SFAR sur les traumatismes crâniens déjà indexés
  dans `library_final.json` (traumatisme crânien léger 2022, traitement
  de la phase précoce/24 premières heures 2016, déjà migré sous un
  autre nom) — celui-ci couvre spécifiquement la phase de réadaptation/
  réveil de coma, un troisième volet distinct ; vérifié par titre avant
  construction, aucune collision.
- **117 : `impact_environnemental_ag`** — "Réduction de l'impact
  environnemental de l'anesthésie générale", SFAR avec SF2H et SFPC,
  RPP 2022. **Grille la plus simple à migrer de ce lot : un seul
  niveau, uniforme sur les 17 recommandations** — "Avis d'experts
  (Accord fort)", parce que la méthode GRADE visée n'a pas pu être
  appliquée à l'ensemble des questions (disclosed par la source
  elle-même dans son propre résumé). **Si le schéma de migration a une
  colonne `grade` typée GRADE, ce document entier migre avec
  `grade = NULL`** (ou une valeur dédiée "avis d'experts + accord
  fort" si le schéma la modélise) — pas de 1+/1-/2+/2- nulle part dans
  ce document, à ne pas confondre avec un document qui utiliserait
  GRADE normalement. 11 blocs de contenu couvrant les 17
  recommandations en 3 champs (vapeurs/gaz anesthésiques, médicaments
  intraveineux, dispositifs médicaux/environnement de travail).
  Particularité de contenu : plusieurs recommandations comparent deux
  alternatives sans indiquer clairement laquelle est strictement
  préférée (ex. R1.5 : vapeurs inhalées OU AIVOC au propofol
  "indifféremment", chacune ayant un type d'impact différent) — à
  garder tel quel lors d'une migration, ne pas forcer un choix unique
  que la source ne fait pas. Document sans lien de contenu avec les
  fiches déjà migrées sur le choix des agents anesthésiques
  (`agents_halogenes` ou équivalents) — celui-ci traite spécifiquement
  du critère environnemental, pas de l'efficacité clinique ; vérifié
  par titre avant construction, aucune collision.
- **118 : `diabete_perioperatoire_2025`** — "Prise en charge du patient
  diabétique en péri opératoire", Fiches simplifiées, Groupe SFAR/SFD,
  version 2025. **Nature de contenu radicalement différente de tout ce
  qui a été migré jusqu'ici dans ce corpus : ce ne sont pas des
  recommandations textuelles mais des algorithmes de dosage et des
  tableaux posologiques** (protocoles d'insulinothérapie IVSE et SC,
  seuils de glycémie/cétonémie, doses en UI). **Aucune grille de
  grade** — si le schéma de migration exige un `grade` non-NULL, ce
  document entier migre avec `grade = NULL`. **Avertissement critique
  pour une future migration** : ce contenu est un outil de dosage
  clinique actif (valeurs numériques prescriptives : unités
  d'insuline, seuils mmol/L et g/L, débits mL/h) — une migration doit
  impérativement conserver l'intégrité exacte de chaque valeur
  numérique et de son unité, sans arrondi ni reformulation, et
  idéalement faire vérifier chaque table migrée contre le PDF source
  par une relecture humaine avant toute mise en `active` (la
  contrainte `recommendations_active_requires_review` de
  `schema_v2.sql` s'applique ici avec une importance particulière,
  compte tenu du risque clinique direct d'une erreur de dosage
  d'insuline). Le document source lui-même est déjà un outil simplifié
  destiné à l'usage clinique direct (pas une RFE/RPC narrative) — la
  fiche elle-même porte un avertissement de sécurité explicite en ce
  sens, à répercuter dans l'interface si ce contenu est un jour migré
  et affiché aux utilisateurs. 43 blocs de contenu sur 6 sections
  (généralités DT1/DT2, pré-opératoire, hyper/hypoglycémie, IVSE +
  relais, Basal Bolus + reprise des AD, intervention courte durée).
- **119 : `anesth_cardiopathie_congenitale`** — "Anesthésie et
  cardiopathie congénitale de l'adulte", SFAR/SFC/SFP/CARO/SFCTCV, RPP
  2023. **Grade uniforme "Avis d'experts (Accord fort)" pour les 11
  recommandations (méthode GRADE Grid mais pas de grade GRADE
  numérique imprimé)** — si le schéma exige un `grade` non-NULL,
  ce document entier migre avec `grade = NULL`, même famille que
  `impact_environnemental_ag` (117) et `bris_dentaires`. **Piège
  d'URL de téléchargement SFAR trouvé pendant la construction, à ne
  jamais réutiliser sans vérification** : `library_final.json` pointe
  vers `wpdmdl=50051` pour ce titre, mais ce fichier contient en
  réalité les fiches pratiques annexes (10 pages, infographies
  visuelles) et NON le texte principal — le texte des 11
  recommandations vient de `wpdmdl=50052` (dont le slug contient
  pourtant "-annexes", nom trompeur). **Si une future migration ou un
  script de retéléchargement automatique utilise
  `direct_pdf_url` de `library_final.json` tel quel pour ce titre, il
  récupérera le mauvais fichier** — `library_final.json` lui-même
  n'a pas été corrigé (risque de collision avec ce même piège pour
  quiconque retéléchargerait ce document plus tard). **Scope
  disclosed, non migré depuis cette fiche** : le Tableau 6 (score de
  risque composite croisé par lésion cardiaque spécifique — une
  classification cardiologique exhaustive sur plusieurs pages) et les
  5 fiches pratiques annexes #2-6 (infographies visuelles : pièges du
  monitorage, principes d'anesthésie, protocoles d'urgence HTAP/
  Fontan, conduite obstétricale) ne sont pas dans le contenu migré —
  seuls le Tableau 3 (statut physiologique A-D), le Tableau 5 (risque
  chirurgical) et la Fiche pratique #1 (gestion périopératoire des
  traitements, sous forme de tableau texte) le sont intégralement. 22
  blocs de contenu sur 4 champs cliniques (risque préopératoire,
  stratégie anesthésique, postopératoire, obstétrique) + annexe.
- **120 : `ressources_humaines_anesthesie_2024`** — "Préconisations pour
  les ressources humaines médicales en anesthésie programmée", SFAR/CNP
  ARMPO, RPP validée par le CA de la SFAR le 02/12/2024. **Deux statuts
  distincts, ni l'un ni l'autre n'étant un grade GRADE numérique** : "RR"
  (Rappel à la réglementation, 4 items R1.1-R1.4 — la question trouve sa
  réponse dans un texte légal/réglementaire déjà en vigueur, pas dans une
  cotation d'experts) et "AE" (Avis d'experts, 7 items R2.1-R2.4/R3.1-R3.3
  — méthode GRADE grid mais format RPP, terminologie "les experts
  suggèrent"). Le texte source précise explicitement que les 11
  préconisations ont recueilli un accord fort dès le premier tour de
  cotation, **sans distinction de force entre elles** — si un futur schéma
  de migration a une colonne `grade` unique, ce document a besoin d'une
  colonne supplémentaire (ou d'une valeur composite du type
  `"RR"`/`"AE"`) distincte de tout champ `consensus`/`accord`, pour ne pas
  perdre l'information sur la nature de la source (loi vs avis d'expert)
  ni la fusionner avec le niveau de consensus (qui est uniforme "accord
  fort" pour les 11 items). Champ explicitement restreint : hors urgence/
  soins critiques, hors anesthésie pédiatrique et obstétricale (renvoi
  vers des fiches dédiées), hors consultation préanesthésique/médecine
  périopératoire. Aucune collision de titre/clé trouvée (`grep -i
  "ressources humaines"` sur `site/app.js` et `library_final.json` avant
  construction) — document génuinement absent de `FICHE_HREF_MATCH`
  avant cette fiche. Argumentaire minimal appliqué dès la construction
  (règle 2026-09-14) : les statistiques/études de risque citées à l'appui
  (OR, %, cohortes Burns et al. JAMA Surgery 2022, Arbous et al.
  Anesthesiology 2005) ne sont pas transcrites — seuls les points
  cliniquement actionnables (rôles MAR/IADE/DJ-AR, limites de 1-2 salles
  par MAR, proximité des salles, procédure de recours) sont retenus. Le
  texte source cite 40 références bibliographiques réparties sur 3
  numérotations indépendantes par question (23 + 13 + 4, chaque question
  redémarrant à [1] dans le texte — piège trouvé et corrigé pendant
  l'audit : la fiche affichait d'abord "36" par erreur de calcul avant
  vérification ligne par ligne des 3 listes de références). 15 blocs de
  contenu sur 1 section (3 questions/tableaux + repères réglementaires).
- **121 : `demarches_anticipees_don_organes_2024`** — "Recommandations de
  bonne pratique relatives aux démarches anticipées en vue de don
  d'organes et de tissus", Agence de la biomédecine (ABM), RBP,
  septembre 2024. **Méthode de cotation différente de GRADE** : RAND/UCLA
  à 2 tours (échelle continue 1-9, 3 zones désaccord/indécision/accord,
  "fort" si la médiane reste dans une zone, "faible" si elle empiète sur
  une borne) — même famille que la fiche déjà migrée-candidate
  `mort_encephalique` (SFAR/SRLF/ABM 2005). **29 blocs à accord fort + 1
  seul bloc à accord faible** (conduite à tenir en cas de défaillance
  vitale immédiate pendant le repérage d'un donneur possible) — si un
  futur schéma de migration a une colonne `grade` calée sur GRADE
  (1+/1-/2+/2-/AE), ce document a besoin d'un mapping vers un vocabulaire
  RAND/UCLA distinct ("accord fort"/"accord faible"/"désaccord"/
  "indécision" — seuls les deux premiers apparaissent ici, mais le
  texte source prévoit les 4 valeurs possibles). **Piège de comptage
  déjà résolu pendant l'audit** : le texte source tague chaque bloc de
  texte APRÈS le bloc concerné (convention "l'accord signalé concerne
  tout ce qui précède depuis l'accord précédent"), donc un futur import
  automatisé du PDF source ne doit pas supposer qu'un tag `(accord X)`
  ne couvre que la phrase immédiatement précédente. **Distinction de
  périmètre vérifiée avant construction** (lecture complète du texte
  source) : ce document traite d'un patient **avant** la mort cérébrale
  (coma grave sans perspective thérapeutique, admission en réanimation
  dans le seul but d'un don), par opposition à `mort_encephalique` qui
  traite d'un donneur **déjà** en mort encéphalique — deux documents,
  deux clés, aucun chevauchement de contenu clinique. 25 blocs de
  contenu sur 1 section (5 sous-sections I à V : prérequis
  institutionnels, définitions, prérequis cliniques, les 4 étapes de la
  démarche, formation des professionnels).
- **122 : `raac_orthopedique_2019`** — "Réhabilitation améliorée après
  chirurgie orthopédique lourde du membre inférieur (arthroplastie de
  hanche et de genou)", SFAR, RFE, validée 20/09/2019. Méthode GRADE
  standard (8 items GRADE1 + 15 items GRADE2 + 1 avis d'experts = 24
  items dénombrés directement). **3 incohérences internes au texte
  source trouvées et disclosed, jamais résolues** — un futur import
  automatisé de ce PDF doit connaître ces 3 pièges avant de faire
  confiance aux chiffres de synthèse imprimés en tête de document :
  (1) la synthèse (français ET anglais) annonce "23 recommandations"
  (7 GRADE1 + 15 GRADE2 + 1 avis d'experts) mais un dénombrement direct
  des items R1.1 à R15 (avec sous-items) totalise **24**, l'écart de 1
  étant localisé sur le sous-total GRADE1 (8 dénombrés, pas 7) — le
  sous-total GRADE2 (15) et avis d'experts (1) correspondent
  exactement à l'annonce ; (2) la synthèse affirme "un accord fort a
  été obtenu pour l'ensemble des recommandations" après 2 tours + 1
  amendement, mais R2 (gabapentinoïdes) porte elle-même, imprimé dans
  le texte juste après son grade GRADE 2-, le tag **"(accord
  faible)"** — si un futur schéma de migration a un champ `consensus`
  séparé du `grade` GRADE, ce document a besoin d'une valeur
  "faible" pour R2 spécifiquement, malgré ce que dit le résumé du
  document ; (3) la synthèse annonce "deux questions [qui] n'ont pas
  trouvé de réponse dans la littérature" mais le texte imprime la
  mention explicite **"ABSENCE DE RECOMMANDATION"** à 3 reprises (Q2
  information/éducation préopératoire, Q3 préhabilitation, Q7
  apports liquidiens peropératoires) — un futur schéma de migration
  doit prévoir de représenter ces 3 "questions sans recommandation"
  d'une manière ou d'une autre (ligne à `grade = NULL` avec un texte
  explicatif, ou table séparée), pas seulement les 24 items gradés.
  20 blocs de contenu sur 1 section (regroupée par phase clinique :
  généralités + préopératoire, peropératoire, postopératoire
  analgésie/thromboprophylaxie, postopératoire récupération).
- **123 : `reduction_antibiotiques_reanimation_2014`** — "Stratégies de
  réduction de l'utilisation des antibiotiques à visée curative en
  réanimation (adulte et pédiatrique)", SRLF/SFAR (GFRUP/SFM/SPILF/SF2H),
  RFE, Juin 2014. **Méthode de cotation entièrement différente de GRADE
  numérique** : le texte source n'imprime AUCUN grade GRADE (1+/1-/2+/2-)
  par item — seule la cotation collective RAND/UCLA (Accord Fort/Accord
  Faible, 2 tours, échelle 1-9) est explicite ; la force "il faut" vs
  "il faut probablement" reste dans le libellé textuel de chaque
  recommandation, jamais formalisée en symbole. Un futur schéma de
  migration calé sur GRADE (colonne `grade` avec valeurs 1+/1-/2+/2-)
  ne peut PAS s'appliquer tel quel à ce document — il faut soit un champ
  `consensus` séparé (Accord Fort/Faible) soit dériver mécaniquement un
  pseudo-grade depuis le texte ("il faut" → fort, "il faut probablement"
  → faible), au choix du schéma cible, mais ne jamais fabriquer un grade
  numérique qui n'existe pas dans la source. **Piège de comptage majeur,
  déjà résolu pendant la construction** : le texte source annonce lui-même
  "54 recommandations... certaines scindées en différents items (n=74)" —
  vérifié exact par extraction programmatique (47 Accord Fort + 27 Accord
  Faible = 74). Mais **11 des 54 recommandations numérotées contiennent en
  réalité plusieurs sous-votes internes** (bullets "•" ou phrases
  successives), chacun avec son propre tag Accord Fort/Faible, **parfois
  de niveaux différents au sein d'une même recommandation numérotée**
  (ex. l'item Q2.7 sur les antigénuries : positivité pneumocoque = Accord
  faible, négativité pneumocoque = Accord fort, positivité légionelle =
  Accord faible, négativité légionelle = Accord faible — 4 faits, 2
  niveaux, sous le même numéro "7" dans le texte source). **Un futur
  import automatisé qui se contenterait de découper le texte source par
  numéro de recommandation (1., 2., 3...) fusionnerait à tort des faits de
  niveaux d'accord différents sous une seule cotation** — cette fiche a
  scindé les 11 recommandations concernées en sous-lignes (ex. "Q2.7a"/
  "Q2.7b") precisément pour éviter ce piège, jamais l'inverse (jamais deux
  niveaux fusionnés). Résultat : 62 lignes de synthèse pour 74 votes
  source, vérifiées une par une par relecture complète du texte source
  (pas de décompte deviné). 29 blocs de contenu sur 1 section (12
  sous-sections : Q1 résistance/épidémiologie, Q2 données
  microbiologiques, Q3a-d choix de l'antibiothérapie [colonisation,
  carbapénèmes, quinolones, anti-SARM probabiliste/documenté], Q4a-d
  optimisation de l'administration [indication, dosage/TDM, modalités,
  associations], Q5 réévaluation/durée).
- **124 : `simulation_soins_critiques_2019`** — "Intérêts de
  l'apprentissage par simulation en soins critiques", SRLF/SFAR/SFMU/
  SOFRASIMS, RPP, textes validés par les CA respectifs (déc. 2018 -
  janv. 2019). Méthode GRADE grid, 24 recommandations réparties en 3
  champs (10 compétences techniques, 12 compétences non techniques, 2
  situations sanitaires exceptionnelles). **Cas le plus simple de ce
  batch pour une future migration** : les 24 recommandations ont TOUTES
  recueilli un accord fort, sans une seule exception (vérifié par grep
  exhaustif : 24× "Accord fort", 0× "Accord faible" dans le texte
  source) — pas de nuance de cotation à représenter, un simple
  `grade = 'accord_fort'` uniforme suffit pour les 24 lignes. Seule
  curiosité mineure : le slug de l'URL de téléchargement source contient
  "rfe" (`rfe-interets-de-lapprentissage-par-simulation-en-soins-
  critiques.pdf`) mais le texte précise explicitement avoir choisi un
  format RPP plutôt que RFE — un futur script qui déduirait le type de
  document depuis le nom de fichier se tromperait pour celui-ci. 13
  blocs de contenu sur 1 section (3 champs).
- **125 : `optimisation_beta_lactamines_2018`** — "Optimisation du
  traitement par bêta-lactamines chez le patient de soins critiques",
  SFPT (Groupe STP/PT) / SFAR, RPP, 2018. Méthode GRADE grid, 21
  recommandations officiellement dénombrées mais **26 sous-items cotés
  individuellement** (ex. R1.2.1/R1.2.2, R4.7.1/R4.7.2, R4.8.1/R4.8.2/
  R4.8.3 comptent chacun pour UNE seule recommandation-parent dans le
  total de 21, mais chaque sous-item est rédigé et déclaré comme une
  suggestion distincte) — **piège similaire à celui déjà noté pour la
  fiche 122 (raac_orthopedique_2019)** : un futur import automatisé qui
  ne découperait le texte que par numéro de premier niveau (R1, R2...)
  perdrait la granularité des sous-items ; celui qui compterait chaque
  ligne "Les experts suggèrent..." comme une recommandation séparée
  obtiendrait 26 et non les 21 annoncés par la synthèse — les deux
  chiffres sont réels et non contradictoires (juste deux niveaux de
  granularité), contrairement aux vraies incohérences trouvées ailleurs
  dans ce batch. **Toutes les recommandations sont à accord fort** (une
  seule mention "Accord fort" imprimée UNE FOIS pour l'ensemble du
  document, pas par item individuel — contrairement aux fiches 121/123/
  124 de ce batch qui impriment un tag par item) : un futur schéma qui
  chercherait un tag de cotation après chaque recommandation ne le
  trouvera pas ici, il faut utiliser la déclaration collective. Contient
  le **Tableau 1** (cibles thérapeutiques plasmatiques pour 11
  bêta-lactamines par CMI/fraction libre) intégralement repris pour la
  colonne "infection documentée" — la colonne "infection non documentée"
  et les notes de bas de tableau ne sont PAS dans le contenu migré
  (scope disclosed). **Vérifié complémentaire, pas redondant**, avec la
  fiche 123 (`reduction_antibiotiques_reanimation_2014`, SRLF/SFAR 2014)
  qui couvre déjà brièvement le dosage/perfusion continue des
  bêta-lactamines de façon générale — celle-ci est un RPP dédié
  beaucoup plus détaillé et spécifique, comparaison faite avant
  construction, aucune recommandation dupliquée à l'identique entre les
  deux fiches. 16 blocs de contenu sur 1 section (4 champs + Tableau 1).
- **126 : `raac_lobectomie_pulmonaire_2019`** — "Réhabilitation
  améliorée après lobectomie pulmonaire", SFAR/SFCTCV, RFE, validée
  20/09/2019. Méthode GRADE standard, 32 recommandations dénombrées
  exactement (contrairement aux fiches 122 et 125 de ce batch, les
  items numérotés à 3 niveaux ici — R1.2.1/R1.2.2, R2.1.1/R2.1.2,
  R2.5.1/R2.5.2, R3.3.1/R3.3.2, R3.4.1/R3.4.2, R4.4.1-4.4.4 — sont
  chacun une recommandation distincte à part entière, pas des
  sous-votes d'un parent ; 32 items = 32 recommandations annoncées,
  vérifié). 7 GRADE1+, 18 GRADE2+, 5 GRADE2-, 2 avis d'experts ; 31
  accord fort + 1 accord faible (R2.5.2 — seule exception, comme pour
  la fiche 122 son propre cas d'accord faible isolé). **Incohérence
  interne trouvée et disclosed** : le résumé en tête de document
  ("Résultats") annonce "pour 2 questions, aucune recommandation n'a
  pu être formulée", mais la section corps "Synthèse des résultats"
  annonce "pour 3 questions" — écart de 1, non résolu. Recherche
  exhaustive : seulement 2 tags explicites "ABSENCE DE RECOMMANDATION"
  imprimés (prémédication préopératoire ; aspiration du drain
  thoracique), plus un 3e cas mentionné uniquement en prose dans
  l'argumentaire d'une question par ailleurs graduée (décolonisation
  nasale du portage de S. aureus, mentionnée dans l'argumentaire de la
  question sur la désinfection oropharyngée à la chlorhexidine, R2.4)
  — les 3 cas sont documentés dans la fiche, aucun résolu en faveur de
  l'un ou l'autre chiffre. Pour une future migration : si un schéma de
  base de données doit représenter les "questions sans réponse", ce
  document illustre qu'un simple comptage des tags "ABSENCE DE
  RECOMMANDATION" (=2) peut sous-compter par rapport à ce que le texte
  source lui-même revendique (=3) — un import automatisé devrait
  signaler cet écart plutôt que de le résoudre silencieusement. 21
  blocs de contenu sur 1 section (5 champs).
- **127 : `raac_cardiaque_2021`** — "Réhabilitation améliorée après
  chirurgie cardiaque adulte sous CEC ou à cœur battant", SFAR/SFCTCV,
  RFE, validée 25/09/2021. Méthode GRADE standard, 33 recommandations
  dénombrées exactement (7×1+ + 3×1- + 15×2+ + 4×2- + 4 avis d'experts
  = 33, correspond exactement à la synthèse du texte source). **Cas le
  plus "propre" des 3 fiches RAAC de ce batch (122, 126, 127)** : les
  33 recommandations ont TOUTES recueilli un accord fort — aucune
  exception, contrairement à `raac_orthopedique_2019` (R2 à accord
  faible) et `raac_lobectomie_pulmonaire_2019` (R2.5.2 à accord
  faible) — et les 3 tags "ABSENCE DE RECOMMANDATION" trouvés
  correspondent exactement aux "3 questions sans réponse" annoncées
  par la synthèse (aucun écart de comptage, contrairement aux 2
  fiches sœurs). Pour une future migration, ce document peut servir
  de "cas de référence" sans piège de comptage à documenter — un bon
  test de non-régression pour un futur pipeline d'import automatisé
  avant de s'attaquer aux cas pièges (122, 125, 126). Note structurelle :
  2 des 3 absences de recommandation partagent la même question
  numérotée du texte source (Champ 4, Question 1 sur les voies
  d'abord mini-invasives, qui traite successivement chirurgie
  valvulaire aortique [absence], chirurgie mitrale [R4.1, avis
  d'experts] et chirurgie coronaire [absence]) — une seule "Question 1"
  du texte source contient donc à la fois une recommandation et 2
  absences, ce qui est cohérent avec le total mais illustre qu'une
  "question" n'est pas toujours 1:1 avec un statut unique
  (recommandation OU absence). 22 blocs de contenu sur 1 section (6
  champs).
- **128 : `optimisation_hemodynamique_pediatrie_2024`** — "Optimisation
  hémodynamique périopératoire – Pédiatrie", SFAR, RPP, mars 2024
  (transfusion exclue du champ). Méthode GRADE grid, **9 avis d'experts
  décomptés exactement** (R1.1.1/1.1.2/1.1.3 partagent un seul tag
  "Avis d'experts (Accord fort)" imprimé une fois après les 3 — ce sont
  3 sous-strates d'âge d'une même question, pas 3 votes indépendants —
  alors que R4.1.1/R4.1.2 portent chacune leur PROPRE tag séparé bien
  que numérotées de façon similaire : **piège de généralisation à
  éviter pour une future migration** — la présence d'un tag partagé vs.
  répété après des items `X.Y.Z` n'est pas prévisible depuis le seul
  schéma de numérotation, il faut lire le texte source pour chaque
  groupe). **4 tags "ABSENCE DE RECOMMANDATION" = 4 questions sans
  réponse annoncées, décompte exact, aucune incohérence**. Document
  **entièrement non gradé** (aucun GRADE 1+/1-/2+/2- imprimé nulle
  part, contrairement à la plupart des RFE/RPP GRADE de ce corpus) —
  seul le statut "Avis d'experts (Accord fort)" existe, un futur schéma
  de migration ne doit pas s'attendre à un grade numérique pour ce
  document. **Distinction explicite du texte source à préserver** :
  une "absence de recommandation" (littérature insuffisante) est
  différente d'une "recommandation négative" ("il ne faut pas faire",
  absente de ce document en particulier) — si un futur schéma de
  migration a un champ `grade` avec une valeur "négatif", ne pas
  l'utiliser pour représenter les 4 "absences" de ce document (elles
  doivent être `grade = NULL` avec texte explicatif, pas une valeur
  "négative"). Vérifié complémentaire, pas redondant, de la fiche
  `remplissage_perioperatoire` (RFE SFAR/Adarpef 2012, adulte à haut
  risque, mention pédiatrique minimale). 18 blocs de contenu sur 1
  section (4 champs).
- **129 : `optimisation_hemodynamique_adulte_2024`** — "Optimisation
  hémodynamique périopératoire – Adulte dont obstétrique", SFAR, RFE,
  janvier 2024 (réactualisation de `remplissage_perioperatoire`, RFE
  SFAR/Adarpef 2012, déjà git-tracked). **Piège de décompte le plus
  significatif de tout ce batch** : le résumé du texte source annonce
  "24 recommandations", mais un décompte direct exhaustif (chaque item
  numéroté relu individuellement, y compris les items préfixés "OBS"
  pour la césarienne sous rachianesthésie) trouve seulement **18
  recommandations réelles**. Fait notable : les 3 SOUS-totaux du résumé
  (2 GRADE1, 8 GRADE2, 6 questions sans réponse) correspondent TOUS
  exactement au décompte direct — seul le total final (24 vs 18) diverge.
  18 + 6 absences = 24, ce qui suggère fortement que le résumé du texte
  source traite les "absences de recommandation" comme des
  "recommandations formulées" au sens large (24 questions ayant reçu une
  réponse quelconque, positive ou négative-par-absence), plutôt qu'une
  vraie recommandation manquante de mon décompte — **mais ceci reste une
  hypothèse, pas une certitude**, disclosed comme telle dans la fiche.
  **Pour une future migration automatisée** : ne JAMAIS faire confiance
  au chiffre total annoncé dans un résumé/abstract sans le recouper avec
  les sous-totaux détaillés ET un décompte direct des items — ce
  document est la preuve qu'un total peut être correct en apparence
  (24) tout en dissimulant une divergence de définition ("recommandation"
  incluant ou non les absences) qui ferait échouer une validation basée
  uniquement sur le total. **Particularité de format disclosed** : ce
  document imprime "GRADE 1"/"GRADE 2" SANS signe +/- (contrairement au
  format standard 1+/1-/2+/2- utilisé par la plupart des RFE de ce
  corpus) — un schéma de migration avec une colonne `grade` typée
  strictement "1+"/"1-"/"2+"/"2-" ne peut pas accueillir les valeurs de
  ce document telles quelles ; il faudra soit une valeur "1"/"2" neutre,
  soit dériver le signe depuis le verbe de la recommandation (comme fait
  dans cette fiche, jamais deviné sans vérification). 27 blocs de
  contenu sur 1 section (5 champs, dont 2 sous-sections obstétricales
  dédiées).

- **130 : `resection_hepatique_2025`** — "Prise en charge péri-opératoire
  du patient adulte lors d'une résection hépatique", HAS, recommandation
  de bonne pratique adoptée par le Collège le 11 septembre 2025, élaborée
  par la SFAR avec l'AFEF (Société Française d'Hépatologie) et l'ACHBPT.
  Méthode GRADE, 3 champs / 14 questions, 40 recommandations numérotées
  (accord fort) + 3 absences de recommandation. **Piège de décompte du
  même type que `optimisation_hemodynamique_adulte_2024` (fiche 129),
  mais dans l'autre sens** : le résumé du texte source annonce "39
  recommandations" (7 GRADE1 + 21 GRADE2 + 11 avis d'experts), mais un
  décompte direct exhaustif — chaque marqueur `R x.y.z` apparié
  individuellement à son chip de grade suivant dans le texte, sans
  chevauchement possible avec un marqueur d'absence voisin, revérifié
  paire par paire — trouve **40 recommandations** (7 GRADE1 + **22**
  GRADE2 + 11 avis d'experts). Les sous-totaux GRADE1 (7) et avis
  d'experts (11) correspondent EXACTEMENT au résumé ; seul le sous-total
  GRADE2 diverge (22 trouvés vs 21 annoncés), contrairement à la fiche
  129 où c'était le total global qui divergeait pour une raison
  identifiée (absences comptées comme "recommandations"). Ici, les 3
  absences de recommandation du résumé correspondent exactement aussi —
  l'écart porte donc uniquement sur un item GRADE2 numéroté en trop par
  rapport au résumé, sans hypothèse de résolution identifiée (contrairement
  à la fiche 129, cette divergence n'a pas d'explication candidate
  évidente). **Pour une future migration automatisée** : ce document est
  un second exemple, indépendant de la fiche 129, qu'un total ou un
  sous-total annoncé dans un résumé source ne doit jamais remplacer un
  décompte direct — ici c'est un SOUS-total (GRADE2) qui est faux, pas le
  total global, ce qui est un mode de divergence différent et donc un
  piège de validation différent (une validation qui ne vérifierait que le
  total global 39 contre 40 aurait détecté l'erreur, mais une validation
  qui ferait confiance aux 3 sous-totaux individuellement annoncés sans
  les re-sommer ne l'aurait pas détectée). **Distinction ABS/AE explicite
  dès la légende du texte source lui-même** (page 2) : "ABS — Pas de
  recommandation" (absence d'études concluantes, aucune proposition
  faite) est explicitement différenciée de "AE — Avis d'experts"
  (proposition malgré l'absence de preuves fortes) — même piège que la
  fiche 128 (`optimisation_hemodynamique_pediatrie_2024`), à ne pas
  fusionner dans un futur schéma de migration (`grade` doit rester NULL
  pour les 3 ABS, distinct d'un avis d'experts). **Particularité de
  format identique à la fiche 129** : le document imprime "1"/"2" SANS
  signe +/- (pas de format standard 1+/1-/2+/2-) — mêmes implications
  pour un futur schéma `grade` typé strictement sur le format à signe.
  **Autre disclosure mineure** : le texte source lui-même numérote DEUX
  annexes différentes "Annexe 3" (une p.13 sur le risque d'insuffisance
  hépatique post-hépatectomie chez les patients CHC, une p.18 sur
  l'antibioprophylaxie) — doublon de numérotation propre au document
  source, non corrigé dans la fiche, à noter si une future migration
  cherche à référencer des "annexes" par numéro. 51 blocs de contenu sur
  7 sections (3 champs + annexes 1/2 + méthode/sources).

- **131 : `programme_optimisation_perioperatoire_2022`** — "Programme
  d'optimisation périopératoire du patient adulte", SFAR, RFE, texte
  validé par le Comité des Référentiels Cliniques le 13/06/2022 et le
  Conseil d'Administration le 29/06/2022. Socle commun de mesures
  applicables quelle que soit la chirurgie — règle de scope explicite du
  texte source : une mesure devait être valable dans AU MOINS 3 domaines
  chirurgicaux distincts pour faire l'objet d'une recommandation ici,
  contrairement aux 4 RFE de réhabilitation améliorée déjà git-trackées
  qui sont chacune spécifique à UNE chirurgie (`raac_lobectomie_pulmonaire_2019`,
  `raac_cardiaque_2021`, `raac_orthopedique_2019`, `raac_colorectal`) —
  **un futur schéma de migration devrait pouvoir distinguer ces deux
  niveaux (socle générique vs spécialisation par chirurgie) plutôt que de
  les traiter comme des documents indépendants sans relation**, puisque
  cette RFE elle-même se positionne explicitement comme leur dénominateur
  commun. Méthode GRADE standard (1+/1-/2+/2-/AE, PAS de convention non
  standard cette fois), 4 champs, 30 recommandations numérotées + 2
  absences de recommandation. **Premier cas de décompte totalement
  "propre" de ce batch de fiches (100-131)** : les 5 sous-totaux annoncés
  par le résumé du texte source (16 GRADE1+, 3 GRADE1-, 10 GRADE2+, 0
  GRADE2-, 1 avis d'experts = 30) correspondent EXACTEMENT à un décompte
  direct item par item (chaque marqueur `Rx.y[.z] -` apparié
  individuellement à son tag de grade), de même que les 2 questions sans
  réponse — contrairement aux fiches 129 (`optimisation_hemodynamique_adulte_2024`,
  écart sur le TOTAL, 24 annoncé vs 18 réel) et 130 (`resection_hepatique_2025`,
  écart sur un SOUS-total GRADE2, 22 trouvés vs 21 annoncés). **Utile
  comme cas de test de référence positif pour un futur schéma de
  migration automatisée** : un document où la validation par
  recoupement des totaux/sous-totaux annoncés contre un décompte direct
  ne devrait PAS lever d'alerte, à la différence des fiches 129 et 130.
  Un item R4.5 est scindé en deux recommandations numérotées séparément
  (R4.5.1 GRADE1+ et R4.5.2 GRADE2+) portant sur la même mesure
  (déambulation précoce) mais deux critères de jugement différents (durée
  de séjour vs complications) — piège de numérotation à noter (une seule
  "Question" source peut produire 2 recommandations numérotées avec des
  grades différents, pas nécessairement le même). 22 blocs de contenu sur
  3 sections (4 champs, fusionnés en 3 sections après vérification
  visuelle de la densité de page).

- **132 : `facteurs_humains_2022`** — "Facteurs humains en situations
  critiques", SFAR en association avec le Groupe Facteurs Humains en
  Santé (FHS), RPP, texte validé le 14/05/2022 (SFAR) et le 04/07/2022
  (FHS). Crisis resource management en anesthésie-réanimation. Méthode
  GRADE prévue en amont (format PICO) mais explicitement déclarée non
  applicable en totalité par le texte source lui-même faute d'essais
  randomisés sur le sujet — **les 21 recommandations sont donc TOUTES
  des avis d'experts, à accord fort pour 100% d'entre elles** (décompte
  vérifié exact : 21 tags "Avis d'experts (accord fort)" trouvés pour 21
  items numérotés, aucune divergence). **Piège de numérotation
  spécifique à ce document, distinct des pièges de décompte déjà
  documentés pour les fiches 128/129/130** : le texte source alterne,
  sans justification apparente, entre les formats "R3.8"/"R3.9" et
  "R.3.8"/"R.3.10" (point après le "R") pour des items CONSÉCUTIFS de la
  même sous-liste — purement typographique, aucune signification
  clinique, mais un parseur automatisé cherchant uniquement le motif
  `^R\d` sans la variante `R\.\d` manquerait silencieusement 2 des 21
  recommandations (trouvé uniquement par une relecture manuelle
  intégrale du texte, pas par une regex seule — **une future migration
  automatisée par regex sur ce corpus devrait explicitement tolérer un
  point optionnel après le "R"**). Sur les 16 annexes du document
  source, une seule a été jugée à la fois autoportante ET non redondante
  avec le texte des recommandations elles-mêmes : l'Annexe 14, une fiche
  pratique "réagir face à un comportement hostile" (campagne SFAR/CFAR
  "1Patient1Equipe", méthode DESC en 4 étapes pour exprimer un
  désaccord) — les 15 autres annexes sont soit de simples liens externes
  vers des mémos HAS/SFAR déjà publiés ailleurs (rien à migrer), soit des
  exemples de cas cliniques illustratifs redondants avec le texte des
  recommandations (omis par la règle argumentaire-minimal). 17 blocs de
  contenu sur 3 sections (4 champs, dont Champ 1+2 fusionnés en une
  section après vérification visuelle de densité de page).

- **133 : `douleur_accouchement_2025`** — "Prise en charge de la douleur
  de l'accouchement : analgésie périmédullaire et alternatives
  médicamenteuses", HAS, RBP validée par le Collège le 30 avril 2025,
  promue par la SFAR et le Collège d'Anesthésie et Réanimation en
  Obstétrique (CARO). Actualisation des recommandations SFAR de 2006 sur
  l'analgésie obstétricale. Même convention de grade que la fiche 130
  (`resection_hepatique_2025`, même famille de documents HAS) — "1"/"2"
  SANS signe +/-, chip ABS distinct d'AE. 34 recommandations + 5
  absences de recommandation (39 items) sur 5 champs. **Différence
  notable avec la fiche 130** : ce document N'IMPRIME AUCUNE synthèse
  chiffrée globale ("XX recommandations, Y niveau élevé...") — aucune
  vérification croisée résumé-vs-décompte n'était donc possible ici,
  contrairement aux fiches 129/130/131 qui avaient toutes une phrase de
  synthèse à recouper. Le décompte de cette fiche (34+5=39) est un
  décompte direct exhaustif SANS résumé source de référence — **une
  future migration automatisée ne doit pas supposer qu'un document
  HAS/SFAR de cette famille contient toujours une phrase de synthèse
  chiffrée exploitable pour validation croisée : certains n'en ont
  pas, et le seul filet de sécurité est alors la relecture manuelle
  intégrale**. Piège de comptage disclosed : sur les 5 absences de
  recommandation, 2 n'ont AUCUN numéro "R" du tout (port de la casaque
  stérile ; monitorage systématique maternel/RCF pendant la pose) —
  present dans le texte comme question explicitement posée puis
  répondue par une absence, sans jamais recevoir de numéro, contrairement
  aux 3 autres absences qui suivent le même motif d'encadrement ABS mais
  sont positionnées entre deux items numérotés adjacents (repérable
  seulement par lecture, pas par un saut de numérotation visible). Inclut
  la Figure 4 du source (algorithme de gestion de l'insuffisance/échec de
  l'analgésie périmédullaire, d'après Rackelboom) retranscrite en tableau
  condensé. 37 blocs de contenu sur 5 sections (5 champs).

- **134 : `erreurs_medicamenteuses_2024`** — "Prévention des erreurs
  médicamenteuses en anesthésie-réanimation", SFAR en collaboration avec
  la Société Française de Pharmacie Clinique (SFPC), RPP, texte validé
  le 30 avril 2024. **Réactualisation d'un document déjà git-tracké** :
  ce corpus suivait déjà `erreurs_medicamenteuses_ar_2016` (préconisation
  SFAR/SFPC, novembre 2016, même sujet) — cette fiche 2024 est
  volontairement conservée sous une clé DISTINCTE plutôt que de
  remplacer la fiche 2016, car beaucoup plus étendue (29 recommandations
  sur 4 champs vs le format "préconisation" plus court de 2016) : **un
  futur schéma de migration devrait pouvoir représenter une relation de
  succession/réactualisation entre deux documents du même corpus sans
  perdre l'ancien** (même pattern déjà noté pour
  `optimisation_hemodynamique_adulte_2024` vis-à-vis de
  `remplissage_perioperatoire`). Format RPP choisi en amont (pas RFE)
  car le texte source lui-même déclare qu'il n'existait pas assez
  d'études pour une cotation GRADE numérique — **les 29 recommandations
  sont donc TOUTES des avis d'experts, à accord fort pour 100%
  d'entre elles** (décompte vérifié exact : recherche de toutes les
  occurrences du tag "avis d'experts", correspond exactement aux 29
  marqueurs R numérotés). 4 champs : environnement de travail et
  processus (19 recommandations — logiciels de prescription,
  étiquetage, seringues préremplies, traçabilité...), facteurs humains
  et organisationnels (6), gestion des risques a posteriori (2),
  pénuries médicamenteuses (2). 2 absences de recommandation
  (informatisation de la prescription en anesthésie ; systèmes
  data-matrix/RFID), chacune imprimée en encadrement avant ET après son
  texte dans le source (motif déjà rencontré sur les fiches HAS de ce
  corpus, ici sur un document SFAR/SFPC RPP — pas limité à une seule
  famille de documents). 31 blocs de contenu sur 3 sections (4 champs,
  fusionnés en 3 sections après vérification visuelle de densité de
  page).

- **135 : `organisation_anesthesie_pediatrique_2023`** — "Organisation
  structurelle, matérielle et fonctionnelle des centres effectuant de
  l'anesthésie pédiatrique", SFAR-ADARPEF, RPP, texte validé le
  19/01/2023. **Relation à deux échelles avec un document déjà
  git-tracké**, anticipée avant même la construction de cette fiche :
  `anesth_pediatrique_structures` (RFE SFAR 2000) portait déjà, dans son
  propre `short`, la mention "Distinct de la RPP SFAR 2023 « Organisation
  de l'anesthésie pédiatrique »" — cette fiche 135 EST ce document
  anticipé. Vérifié non redondant : le document 2000 détaille le
  matériel chiffré (tailles de sondes, masques...) au sein D'UN site ;
  celui-ci (2023) porte sur l'organisation ENTRE sites/centres (réseaux
  ville/centre spécialisé, criètres d'orientation par âge/ASA, effectifs
  minimaux par tranche d'âge) — **un futur schéma de migration devrait
  pouvoir représenter deux documents du même corpus portant sur des
  ÉCHELLES différentes du même sujet (site unique vs réseau de sites)
  sans les traiter comme redondants ou comme une simple
  succession temporelle** (différent du pattern de réactualisation pure
  déjà noté pour `erreurs_medicamenteuses_2024`/`ar_2016` ou
  `optimisation_hemodynamique_adulte_2024`/`remplissage_perioperatoire`).
  Méthode GRADE prévue en amont mais les 34 recommandations
  ("préconisations") sont TOUTES avis d'experts, accord fort à 100%
  (décompte source vérifié exact, PAS d'absence de recommandation dans
  ce document — contrairement à plusieurs autres RPP de ce corpus). 4
  champs : structure et logistique (6), équipement et matériel (12),
  formation (3), organisation fonctionnelle (13, dont R4.3.1-4.3.4 =
  critères d'effectifs minimaux par tranche d'âge, du type le plus
  directement actionnable de tout ce corpus : ex. "&lt;1 an ou ASA 4-5 →
  2 professionnels dédiés exclusivement"). 20 blocs de contenu sur 4
  sections (4 champs).

- **136 : `organisation_usc_2018`** — "Recommandations pour le
  fonctionnement des Unités de Surveillance Continue (USC) dans les
  Établissements de Santé", Conseils Nationaux Professionnels de
  Médecine Intensive Réanimation, d'Anesthésie-Réanimation et de
  Médecine d'Urgence, 2018. **Nouvelle convention de cotation pour ce
  corpus, distincte à la fois de GRADE (1+/1-/2+/2-/AE) et du format
  "recommandation numérotée sans signe" (HAS)** : ce document suit
  chaque recommandation de la seule mention "Accord Fort", sans aucune
  distinction de niveau de preuve ni d'avis d'experts séparé — 26
  recommandations, toutes à ce même niveau unique (décompte vérifié
  exact, aucune absence de recommandation). Même convention que la
  fiche déjà git-trackée `bris_dentaires` (accord fort uniforme, chip
  "Fort" déjà défini dans `style.py` et réutilisé tel quel ici, sans
  modification) — **un futur schéma de migration a maintenant DEUX
  fiches de référence pour ce pattern "accord fort sans grade", utile
  pour ne pas le confondre avec un pattern "avis d'experts" (AE) qui a
  une sémantique différente** (balance bénéfices/risques indéterminée)
  déjà documenté pour d'autres fiches (128, 130, 132, 134, 135). 5
  champs (typologie des patients, structure des USC, organisation
  paramédicale, organisation médicale, USC dans le contexte des GHT).
  Inclut le tableau des critères d'admission en USC de l'American
  College of Critical Care (référence externe citée PAR le source, pas
  une recommandation SFAR/CNP propre — distinction à préserver si migré :
  ce tableau n'a pas le même statut d'autorité que les 26
  recommandations elles-mêmes) reproduit intégralement par appareil. 19
  blocs de contenu sur 3 sections (5 champs, fusionnés en 3 sections).
- **137 : `transfusion_gr_anesth_2014`** — "Transfusion de globules
  rouges homologues : produits, indications, alternatives", HAS,
  recommandation de bonne pratique, novembre 2014. **Fiche à périmètre
  volontairement limité** (même pattern que sepsis/anaphylaxie déjà
  git-trackées) : le document source complet (72 pages) comporte 4
  parties très hétérogènes — seule la Partie 2 (sections 5 à 8 :
  anesthésie, réanimation, chirurgie, urgence) est couverte ici,
  intégralement ; les Parties 1 (médecine transfusionnelle générale), 3
  (hématologie-oncologie : drépanocytose, thalassémie, leucémies) et 4
  (néonatologie : exsanguino-transfusion) sont hors du périmètre
  anesthésie/réanimation adulte de ce corpus et NE SONT PAS traitées —
  disclosed explicitement dans l'encadré d'intro de la fiche, le
  docstring et `DOC_META`. **11e convention de cotation distincte pour ce
  corpus** : grille HAS classique **A/B/C/AE** (A = preuve scientifique
  établie ; B = présomption scientifique ; C = faible niveau de preuve ;
  AE = accord d'experts) — distincte à la fois du format SFAR
  1+/1-/2+/2- et de la grille ANAES A/B/C/AP déjà vue pour `ivg_14sa` (AE
  y remplace AP, avec un chip **ABS** ajouté localement pour les
  absences de recommandation explicites). 26 recommandations gradées
  (A:3, B:10, C:1, AE:12) + 4 absences de recommandation explicitement
  énoncées par la source elle-même (seuil transfusionnel en
  neuroréanimation ; âge/durée de conservation des CGR ; acide
  tranexamique et rFVIIa dans l'hémorragie du post-partum — **NE PAS
  migrer ces 4 avec un `grade` inventé, `grade` doit rester NULL pour
  elles**, même piège que plusieurs fiches précédentes de ce lot).
  Contient aussi plusieurs précisions de contexte non gradées
  séparément (patient traumatisé, transfusion massive, règles RH/KEL
  pour la femme en âge de procréer) transcrites en note italique
  distincte, sans grade fabriqué. 27 blocs de contenu sur 3 sections
  (5 sections d'origine fusionnées en 3 après vérification visuelle —
  plusieurs pages étaient sous 60% de remplissage).
- **138 : `gestion_traitements_chroniques_cardio_2009`** — "Gestion
  périopératoire des traitements chroniques et dispositifs médicaux",
  SFAR, Recommandations Formalisées d'Experts, Ann Fr Anesth Réanim 28
  (2009) 1037-1045. **Fiche à périmètre volontairement limité** : le
  PDF source téléchargé (36 pages) est en réalité un document
  COMPOSITE fusionnant plusieurs articles AFAR distincts publiés entre
  2009 et 2011, correspondant aux 4 modules annoncés par le Préambule
  du référentiel (Cardiovasculaire ; Douleur chronique/toxicomanie ;
  Infectieux/immunosuppresseurs ; Neurologique-psychiatrique et/ou
  endocrinien). Cette fiche couvre UNIQUEMENT le **Module 1 —
  Pathologies cardiovasculaires** (pages 3-11 du PDF fusionné, le plus
  transversal à toute anesthésie programmée) — les 3 autres modules ne
  sont pas traités, chacun nécessitant sa propre lecture/audit dédiée
  pour identifier ses limites de pages exactes dans le PDF fusionné
  (le fichier ne les sépare pas explicitement). Les traitements
  antithrombotiques (antiagrégants plaquettaires, AVK) sont
  explicitement exclus de l'ENSEMBLE du référentiel par son comité
  d'organisation lui-même, déjà couverts par d'autres textes SFAR/HAS
  distincts (ex. `aap_programmee` déjà git-tracké) — aucun risque de
  chevauchement. **12e convention de cotation distincte pour ce
  corpus** : grille ANAES 2004 A/B/C/D, avec particularité disclosed
  par le Préambule lui-même — les recommandations de grade D jugées
  les plus importantes ont été renforcées par une méthode Delphi à
  deux tours, aboutissant dans la quasi-totalité des cas à un "accord
  fort" (seule forme de grade D effectivement imprimée dans le Module
  1 — aucune occurrence de "accord professionnel" nu) — chip local
  "AF" distinct du chip "AE" déjà utilisé ailleurs dans ce corpus (sens
  légèrement différent : ici consensus explicite renforcé par méthode
  Delphi, vs. balance bénéfice/risque indéterminée pour AE). 15
  recommandations gradées (A:0, B:3, C:3, AF:9) + 1 recommandation
  explicitement NON GRADÉE par la source elle-même (antiarythmiques
  classe I, interruption 24h avant chirurgie programmée — **NE PAS
  migrer avec un `grade` inventé, `grade` doit rester NULL pour cette
  ligne**, même piège que plusieurs fiches précédentes de ce lot) + 1
  section pratique non gradée (stimulateurs cardiaques/défibrillateurs
  automatiques implantables — DCI), la source n'y attachant AUCUN
  grade A/B/C/D à aucun moment, incluant 2 points explicitement
  signalés par la source comme ne faisant PAS l'objet d'un consensus
  (reprogrammation préopératoire en mode asynchrone chez le patient
  stimulo-dépendant ; déprogrammation de la fonction d'asservissement)
  — à ne pas non plus grader si migré. **Disclosure supplémentaire** :
  plusieurs classes thérapeutiques (bêtabloquants, statines) énoncent
  la même action ("ne pas interrompre") deux fois dans des
  sous-sections différentes du texte source, chacune avec un grade
  différent attaché (ex. bêtabloquants : grade C dans la sous-section
  "risque d'événement", puis "accord fort" dans la sous-section
  "stratégie") — jamais fusionnées en un chip composite ; le grade
  retenu pour la ligne d'action est celui de la sous-section
  "stratégie", l'autre citation étant reportée en note de contexte
  séparée. 34 blocs de contenu sur 4 sections (tentative de fusion de
  sections 4→2 essayée puis annulée : n'a pas réduit le nombre de
  pages réel).
- **139 : `gestion_traitements_chroniques_douleur_toxico_2009`** —
  "Gestion périopératoire des traitements chroniques et dispositifs
  médicaux — Douleur chronique, toxicomanie", SFAR RFE, Ann Fr Anesth
  Réanim 28 (2009) 1046-1056. **Module 2/4 du même référentiel
  composite que la fiche 138** (pages 12-22 du même PDF fusionné) :
  opioïdes (traitement chronique de la douleur, avec table de
  conversion complète), AINS/coxibs, antiépileptiques, antidépresseurs,
  benzodiazépines, cathéters intrathécaux/périmédullaires, stimulateurs
  médullaires, toxicomanie substituée (méthadone/buprénorphine, avec sa
  propre table de conversion), et toxicomanie active (cannabis,
  héroïne, cocaïne, autres excitants du SNC, médicaments détournés).
  Les modules Infectieux/immunosuppresseurs et
  Neurologique-psychiatrique/endocrinien restent hors périmètre, comme
  disclosed pour la fiche 138. **Particularité méthodologique propre à
  ce module** (différente du module 1) : la grande majorité des
  énoncés prescriptifs du texte source ne portent AUCUNE citation de
  grade — seulement 28 citations de grade explicites sur l'ensemble du
  module (A:0, B:4, C:9, accord fort:15). Conformément à la règle
  anti-fabrication de grade, seules ces 28 citations (consolidées en 26
  lignes de tableau lorsque 2 citations consécutives partagent le même
  grade — jamais lorsque les grades diffèrent) apparaissent dans les
  tableaux de recommandations gradées ; tous les autres énoncés
  prescriptifs du texte source sont regroupés en blocs de "repères
  pratiques non gradés" par substance, disclosed une fois par section
  plutôt que par un encadré répété à chaque ligne — **si migré, NE PAS
  attribuer de `grade` à ces repères pratiques, `grade` doit rester
  NULL pour eux**, seules les 26 lignes de tableau portent un `grade`
  réel. **Particularité de routage propre à cette fiche** : elle
  partage la MÊME entrée `library_final.json` (même href/PDF) que la
  fiche 138 — `FICHE_HREF_MATCH` n'a délibérément PAS été modifié pour
  cette fiche (reste résolu vers le Module 1/fiche 138 pour la ligne du
  tableau bibliographique), cette fiche étant rendue accessible
  uniquement via `RAW`/`DOC_META` (qui pilotent indépendamment la barre
  latérale et la grille de cartes de la page d'accueil) — vérifié par
  Playwright que la ligne du tableau bibliographique route toujours
  vers le Module 1 et que les deux modules apparaissent comme entrées
  distinctes dans la barre latérale. **Si migré vers Supabase, ce
  routage web n'a pas d'équivalent direct** — les deux fiches
  partageront probablement une seule `document_id`/entrée source avec
  deux jeux de recommandations distincts, ou nécessiteront une
  décision de modélisation dédiée (à trancher au moment de la
  migration, pas anticipée ici). 32 blocs de contenu sur 2 sections
  (fusion de 4→2 sections qui a RÉDUIT le nombre de pages réel de 5 à
  4, contrairement à la fiche 138 — a aussi corrigé un bloc orphelin
  isolé seul sur une page).
- **140 : `gestion_traitements_chroniques_neuro_psy_2011`** — "Gestion
  périopératoire des traitements chroniques et dispositifs médicaux —
  Pathologies neurologiques et psychiatriques" + texte court
  "Phytothérapie", SFAR RFE, Ann Fr Anesth Réanim 30 (2011) 191-194 et
  200. **Module 4/4, dernier module du même référentiel composite que
  les fiches 138/139** (pages 32-36 du même PDF fusionné) :
  antiparkinsoniens, antidépresseurs (avec une sous-section IMAO
  dédiée — ancienne/nouvelle génération, choix d'opiacés pour éviter
  un syndrome sérotoninergique), et le texte court « Phytothérapie »
  (bundled dans cette fiche vu sa taille très réduite — moins d'une
  page source, même auteur/responsable). Le Module 3
  (Infectieux/immunosuppresseurs) reste hors périmètre. **Un module
  "pathologies endocriniennes" annoncé par le préambule du référentiel
  (voir fiche 138) a été activement recherché dans les 36 pages du PDF
  fusionné et n'y a pas été trouvé** — disclosed comme probablement
  jamais publié sous cette forme ou publié ailleurs, plutôt que
  silencieusement omis. **Deux divergences méthodologiques réelles
  disclosed par rapport aux modules 1/2** (fiches 138/139) : (1) ce
  module (groupe de travail différent, publié 2011) utilise « grade D »
  ET « accord fort » comme DEUX notations distinctes et non
  interchangeables — contrairement aux modules 1/2 où D n'apparaissait
  jamais autrement que relabellisé accord fort — chip local "D" séparé
  ajouté pour ce module uniquement ; (2) une citation source imprime un
  grade hésitant explicite "(grade B ou C)" (association
  imipraminique-anticholinergique) — reproduit tel quel avec un chip
  neutre "B/C", **jamais tranché arbitrairement en faveur de l'un ou
  l'autre si migré**. 27 lignes de recommandations/repères gradés (A:3,
  B:5, C:6, D:4, accord fort:8, B/C:1) — **si migré, le chip "B/C" ne
  doit pas être forcé vers un `grade` unique, et prévoir un traitement
  dédié pour cette valeur si le schéma Supabase n'accepte qu'un seul
  grade par recommandation**. Tally initialement mal estimé au moment
  d'écrire le docstring (avant l'écriture effective du code) puis
  corrigé après l'audit indépendant par regex — corrigé avant le
  commit, pas après (aucune valeur erronée n'a été poussée). Même
  particularité de routage que la fiche 139 (`FICHE_HREF_MATCH`
  inchangé, résolution du tableau bibliographique vers le Module 1,
  fiche accessible via `RAW`/`DOC_META` seuls — revérifié par
  Playwright avec les 3 fiches désormais présentes). Tentative de
  fusion de sections (4→3) essayée puis annulée : n'a pas réduit le
  nombre de pages réel (contrairement à la fiche 139, comme la fiche
  138).
- **141 : `gestion_traitements_chroniques_infectieux_2009`** —
  "Gestion périopératoire des traitements chroniques et dispositifs
  médicaux — Anti-infectieux, immunosuppresseurs", SFAR RFE, Ann Fr
  Anesth Réanim 28 (2009) 1057-1065. **Module 3/4, ACHÈVE la
  couverture des 4 modules du même référentiel composite que les
  fiches 138/139/140** (pages 23-31 du même PDF fusionné) :
  antituberculeux, antirétroviraux, et 6 immunosuppresseurs distincts
  (inhibiteurs de calcineurine [ciclosporine, tacrolimus], thalidomide,
  méthotrexate, azathioprine, mycophénolate mofétil, cyclophosphamide,
  anticorps monoclonaux anti-TNF). Seuls DEUX grades apparaissent
  effectivement dans ce module (grade C et accord fort, vérifié
  exhaustivement par grep — aucune citation A/B/D nue), plus simple que
  les échelles mixtes des modules 1/2/4. **Disclosure réelle** : la
  section anti-TNF énonce essentiellement le même fait clinique trois
  fois à travers deux sous-sections, toutes gradées C — dont une
  citation est un doublon mot pour mot littéral d'une autre —
  consolidées en UNE seule ligne de tableau, jamais en fusionnant des
  grades différents (règle anti-composite respectée : mêmes grade et
  scénario clinique uniquement). 30 lignes de recommandations gradées
  (accord fort:16, grade C:14) — **le décompte estimé dans le
  docstring avant écriture du code était erroné (15 au lieu de 14 pour
  grade C) et corrigé après l'audit indépendant par regex, avant le
  commit**. **Deux bugs trouvés et corrigés pendant ce build** : (1)
  une fonction `_section_sources()` définie mais jamais câblée dans
  `SECTIONS`, supprimant silencieusement le bloc Sources/avertissement
  du premier PDF généré — détecté par relecture visuelle page par
  page, pas supposé complet après un build réussi sans erreur ; (2)
  après fusion de sections pour densifier (5→3 pages), les textes
  `DOC_META` des fiches 138 et 139 ont aussi été corrigés — ils
  affirmaient encore que les autres modules "ne sont pas traités",
  ce qui était vrai au moment de leur écriture mais obsolète une fois
  les 4 modules effectivement construits. Même particularité de
  routage que les fiches 139/140 (`FICHE_HREF_MATCH` inchangé,
  résolution vers le Module 1, fiche accessible via `RAW`/`DOC_META`
  seuls — revérifié par Playwright avec les 4 fiches désormais
  présentes). 30 blocs de contenu sur 2 sections (deux fusions
  successives de sections ont RÉDUIT le nombre de pages réel de 5 à 3,
  la seconde corrigeant aussi un bloc orphelin isolé).
- **142 : `delivrance_information_2012`** — "Délivrance de l'information
  à la personne sur son état de santé", HAS, Recommandation de Bonne
  Pratique, validée par le Collège de la HAS en **mai 2012**. Texte
  fondamental sur le consentement éclairé/l'information du patient,
  applicable à toute consultation d'anesthésie : contenu et qualités
  de l'information, modalités de délivrance (entretien individuel,
  accompagnant, personne de confiance, documents écrits, coordination
  entre plusieurs professionnels, traçabilité), information du mineur/
  majeur protégé/majeur inapte (cas particuliers détaillés), évaluation
  de l'information donnée. Actualise et remplace « Information des
  patients — Recommandations destinées aux médecins » (ANAES, mars
  2000) — ce document 2000 est lui-même un lien mort sur sfar.org,
  aucun risque de collision. **Deux problèmes d'index bibliothèque
  disclosed et corrigés plutôt que de provoquer un échec silencieux** :
  (1) `library_final.json` contient une coquille dans son
  `direct_pdf_url` ("l-information" avec un tiret superflu) qui 404 —
  l'URL fonctionnelle (sans le tiret) a été trouvée en grattant la
  page href elle-même ; (2) l'index date ce document de "2010", mais
  le PDF lui-même affiche "Mai 2012" comme date de validation par le
  Collège de la HAS — la fiche utilise la date réellement imprimée sur
  le document, divergence disclosed plutôt que tranchée arbitrairement
  (si migré, utiliser mai 2012 comme date de référence, pas 2010).
  **Méthodologie** : la grille HAS A/B/C/AE est définie en préambule du
  document MAIS jamais citée individuellement dans le corps du texte
  (vérifié par grep exhaustif, zéro occurrence de "(A)"/"(B)"/"(C)"/
  "(AE)") — le document énonce lui-même que l'absence de données
  scientifiques suffisantes fait reposer TOUTES les recommandations
  sur un accord d'experts. Chip "AE" appliqué uniformément aux 28
  items (même pattern que `bris_dentaires`/`organisation_usc_2018` pour
  un grade uniforme disclosed par la source elle-même — **si migré, ne
  pas fabriquer de différenciation A/B/C qui n'existe pas dans le
  texte, `grade` doit être 'AE' pour les 28 lignes**). Contrairement
  aux fiches 139-141, ce document a sa PROPRE entrée `library_final.json`
  (non partagée) — `FICHE_HREF_MATCH` ajouté normalement, revérifié par
  Playwright que la ligne du tableau bibliographique route bien vers
  cette fiche. 15 blocs de contenu sur 3 sections (fusion de 4→3
  sections qui a RÉDUIT le nombre de pages réel de 4 à 3).
- **143 : `blocs_perimedullaires_ci_2006`** — "Les blocs périmédullaires
  chez l'adulte", SFAR/Sofcot/Sofmer, Recommandations pour la Pratique
  Clinique, présentées le 24 septembre 2005 (47e congrès SFAR), Annales
  Françaises d'Anesthésie et de Réanimation 26 (2007) 720-752. **Fiche à
  périmètre limité** : le document source compte 15 « Questions »
  cliniques et 369 citations de grade individuelles au total — beaucoup
  trop dense pour une seule fiche. Cette fiche couvre INTÉGRALEMENT les
  Questions 1 et 2 (information au patient ; contre-indications
  générales, surveillance et monitorage), le socle applicable à toute
  anesthésie-analgésie périmédullaire. Les Questions 3 à 15 (technique
  rachianesthésie/péridurale, association AG-bloc, travail obstétrical,
  césarienne, analgésie postopératoire, terrains spécifiques, gestion de
  l'échec, facteurs de risque de complications) NE SONT PAS couvertes —
  installments futurs du même document, disclosed explicitement en page
  1 de la fiche. **Grille EBM classique A/B/C/AE** — la seule occurrence
  du texte source en « avis d'experts » est traitée comme équivalente à
  l'« accord professionnel » (même palier le plus bas), disclosed comme
  variation terminologique et non un palier distinct **(si migré : ne
  pas fabriquer de palier séparé pour « avis d'experts », `grade` doit
  être 'AE' pour cette ligne comme pour les autres accords professionnels)**.
  41 recommandations gradées au total sur les 2 questions, vérifiées par
  audit indépendant (regex sur le script final, pas seulement estimation
  à la lecture) : A:3, C:31, AE:7. **Corrige une évaluation erronée d'une
  session antérieure** qui avait conclu à tort que ce document ne
  comportait aucune citation gradée — cette conclusion venait d'une
  recherche sensible à la casse sur « Grade » (majuscule) qui ne trouvait
  aucune occurrence ; le texte source utilise systématiquement la
  minuscule « grade », d'où les 369 citations réelles retrouvées. 4 pages
  après une fusion de sections réussie (5→4). Needle `FICHE_HREF_MATCH`
  ('les-blocs-perimedullaires-chez-ladulte') vérifié comme correspondant
  à exactement 1 entrée `library_final.json`.
- **144 : `blocs_perimedullaires_technique_2006`** — deuxième installment du
  même document que la fiche 143 ("Les blocs périmédullaires chez l'adulte",
  SFAR/Sofcot/Sofmer RPC 2006-2007). Couvre INTÉGRALEMENT les Questions 3
  (modalités de la rachianesthésie), 4 (modalités de la péridurale) et 5
  (association blocs périmédullaires-anesthésie générale : chronologie,
  surveillance peropératoire) — le « groupe technique » déjà annoncé comme
  installment futur dans la fiche 143. 24 recommandations gradées (A:11,
  B:4, C:8, AE:1), vérifiées par audit indépendant (regex sur le script
  final) — correct dès la première passe cette fois, sans correction de
  décompte nécessaire. **Méthodologie de consolidation disclosed** : 31
  citations de grade brutes dans le texte source (A×17, B×5, C×8,
  « consensus professionnel » ×1, vérifié par grep) sont regroupées en 24
  lignes de tableau lorsque plusieurs citations portent le MÊME grade pour
  le MÊME point clinique au sein d'un seul paragraphe source — jamais deux
  grades DIFFÉRENTS fusionnés dans une seule ligne (safety net anti-grade-
  composite vérifié propre). **Nouvelle variante terminologique** trouvée
  dans la Question 5 : « consensus professionnel », une troisième
  formulation du palier de preuve le plus faible (avec « accord
  professionnel » et « avis d'experts » déjà rencontrés dans les Questions
  1-2 de la fiche 143) — toutes trois disclosed comme équivalentes, pas des
  paliers distincts (**si migré : `grade` doit être 'AE' pour cette ligne
  comme pour les autres accords professionnels de ce document**). Trois
  tableaux pharmacologiques reproduits verbatim (facteurs déterminant le
  bloc en rachianesthésie ; pharmacodynamie comparée des AL en
  rachianesthésie ; en péridurale), y compris leurs cellules réellement
  vides dans le source — vérifié par rendu visuel du PDF source à 200dpi
  (pages 726-728) avant rédaction, pas supposé à partir du seul texte
  extrait (risque connu de ce corpus sur les tableaux multi-colonnes,
  non constaté ici après vérification). QA visuelle : deux corrections
  faites avant commit (titre de section trop long débordant de sa barre de
  couleur, raccourci ; première colonne du Tableau 4 trop étroite coupant
  "Lévobupivacaïne" en deux lignes, élargie). Partage l'entrée
  `FICHE_HREF_MATCH` de la fiche 143 (pas de doublon) mais possède ses
  propres entrées `RAW`/`DOC_META` complètes, la rendant indépendamment
  accessible (menu latéral/page d'accueil) — même pattern que les fiches
  139-141 partageant l'entrée de la fiche 138.

Voir `rfe-sfar-website/build/content_hospit_ambulatoire.json`,
`content_echo_alr.json`, `content_alr_douleur_chronique.json`,
`content_infections_nosocomiales_rea.json`,
`content_nutrition_perioperatoire.json`, `content_ivg_14sa.json`,
`content_aod_programme.json`, `content_blocs_peripheriques_membres.json`,
`content_raac_colorectal.json`, `content_chir_ambu_proctologie.json`,
`content_mieux_vivre_reanimation.json`, `content_preparation_colique.json`,
`content_organisation_ar_obstetricale.json`,
`content_erreurs_medicamenteuses_ar_2016.json`,
`content_anesth_pediatrique_structures.json`,
`content_aod_dabigatran_urgence_2016.json`,
`content_tc_readaptation.json`,
`content_impact_environnemental_ag.json`,
`content_diabete_perioperatoire_2025.json`,
`content_anesth_cardiopathie_congenitale.json`,
`content_ressources_humaines_anesthesie_2024.json`,
`content_demarches_anticipees_don_organes_2024.json`,
`content_raac_orthopedique_2019.json`,
`content_reduction_antibiotiques_reanimation_2014.json`,
`content_simulation_soins_critiques_2019.json`,
`content_optimisation_beta_lactamines_2018.json`,
`content_raac_lobectomie_pulmonaire_2019.json`,
`content_raac_cardiaque_2021.json`,
`content_optimisation_hemodynamique_pediatrie_2024.json`,
`content_optimisation_hemodynamique_adulte_2024.json`,
`content_resection_hepatique_2025.json`,
`content_programme_optimisation_perioperatoire_2022.json`,
`content_facteurs_humains_2022.json`,
`content_douleur_accouchement_2025.json`,
`content_erreurs_medicamenteuses_2024.json`,
`content_organisation_anesthesie_pediatrique_2023.json`,
`content_organisation_usc_2018.json`, `content_transfusion_gr_anesth_2014.json`,
`content_gestion_traitements_chroniques_cardio_2009.json`,
`content_gestion_traitements_chroniques_douleur_toxico_2009.json`,
`content_gestion_traitements_chroniques_neuro_psy_2011.json`,
`content_gestion_traitements_chroniques_infectieux_2009.json`,
`content_delivrance_information_2012.json`,
`content_blocs_perimedullaires_ci_2006.json`,
`content_blocs_perimedullaires_technique_2006.json`
et la PR #1 de ce dépôt pour
le détail complet du build/audit de chacune (y compris, pour `echo_alr`,
un bug de grade composite trouvé et corrigé avant la finalisation — une
phrase source avec deux clauses de force différente avait été fusionnée
en une seule ligne, scindée en 2 conformément à la règle
anti-grade-composite ; pour `alr_douleur_chronique`, une autre scission
similaire sur intrathécale/péridurale en douleur cancéreuse ; et pour
`infections_nosocomiales_rea`, 4 bugs trouvés à l'audit — 3 scissions de
grade composite et 1 recommandation entière initialement omise, ajoutée
après coup ; et pour `nutrition_perioperatoire`, un bug critique de
couverture — une section entière de 7 recommandations jamais intégrée
au build, trouvée et corrigée avant finalisation).
Le tableau ci-dessous reste donc à jour pour 99/99 uniquement — la migration
de `hospit_ambulatoire`, `echo_alr`, `alr_douleur_chronique`,
`infections_nosocomiales_rea` puis `nutrition_perioperatoire` est le
prochain élément de la Tâche 1 à
traiter (même pipeline que les 99 précédents :
`documents`/`document_societies`/`document_specialties`/`recommendations`,
statut `draft`, `recommendation_code` suivant, safety net grade composite
vérifié).

| Séquence | Clé | Fichier migration | Titre | Recommandations |
|---|---|---|---|---|
| 000001 | `transport_intrahospitalier` | `0001_migrate_transport_intrahospitalier.sql` | Transport intrahospitalier des patients à risque vital (SRLF/SFAR/SFMU, RFE 2011) | 99 |
| 000002 | `ecbu` | `0002_migrate_ecbu.sql` | Place de l'ECBU avant une prise en charge urologique (AFU/CIAFU, RBP 2026) | 46 |
| 000003 | `mort_encephalique` | `0003_migrate_mort_encephalique.sql` | Mort encéphalique et prélèvement d'organes (SFAR/SRLF/ABM, 2005) | 142 |
| 000004 | `aap_urgence` | `0004_migrate_aap_urgence.sql` | Gestion des AAP en cas de procédure invasive non programmée ou d'hémorragie (GIHP/GFHT/SFAR, 2018) | 21 |
| 000005 | `aap_programmee` | `0005_migrate_aap_programmee.sql` | Gestion des AAP pour une procédure invasive programmée (GIHP/GFHT/SFAR, RFE 2018) | 34 |
| 000006 | `allergie_prevention` | `0006_migrate_allergie_prevention.sql` | Prévention du risque allergique péranesthésique. Texte court (Sfar/SFA, RFE 2011) | 47 |
| 000007 | `anemie` | `0007_migrate_anemie.sql` | Gestion et prévention de l'anémie (hors hémorragie aiguë) chez le patient adulte de soins critiques (SFAR/SRLF, RFE 2019) | 10 |
| 000008 | `anaphylaxie` | `0008_migrate_anaphylaxie.sql` | Diagnostic et prise en charge des réactions d'hypersensibilité immédiate périopératoires (SFAR/SFA, RFE 2025) | 62 |
| 000009 | `antibioprophylaxie` | `0009_migrate_antibioprophylaxie.sql` | Antibioprophylaxie en chirurgie et médecine interventionnelle adulte et pédiatrique — Champ 1 (SFAR/SPILF, RFE V3.0/V3.1) | 11 |
| 000010 | `antibiotherapie_probabiliste` | `0010_migrate_antibiotherapie_probabiliste.sql` | Antibiothérapie probabiliste des états septiques graves (SFAR/SRLF/SPILF/SFMU, Conférence d'experts 2004) | 37 |
| 000011 | `anticoag_urgence` | `0011_migrate_anticoag_urgence.sql` | Gestion de l'anticoagulation dans un contexte d'urgence (SFMU/SFAR/GIHP/SFTH, RFE 2024) | 91 |
| 000012 | `anticoagulants` | `0012_migrate_anticoagulants.sql` | Gestion des anticoagulants pour une procédure invasive programmée (GIHP/SFAR + 25 sociétés, RFE 2026) | 64 |
| 000013 | `asthme_aigu_grave` | `0013_migrate_asthme_aigu_grave.sql` | Prise en charge des crises d'asthme aiguës graves (SRLF, révision 2002 d'une CC 1988) | 62 |
| 000014 | `choc_hemorragique` | `0014_migrate_choc_hemorragique.sql` | Recommandations sur la réanimation du choc hémorragique (SFAR/SRLF/SFMU/GEHT, RFE 2014/2015) | 29 |
| 000015 | `civd` | `0015_migrate_civd.sql` | Coagulations Intra-Vasculaires Disséminées (CIVD) en réanimation (SRLF, CC 2002) | 22 |
| 000016 | `controle_temperature` | `0016_migrate_controle_temperature.sql` | Contrôle ciblé de la température en réanimation (SRLF/SFAR/SFMU, RFE 2016) | 30 |
| 000017 | `corticotherapie` | `0017_migrate_corticotherapie.sql` | Corticothérapie au cours du choc septique et du SDRA (SFAR/SPILF, CC 2000) | 18 |
| 000018 | `curares` | `0018_migrate_curares.sql` | Curarisation et décurarisation en anesthésie (SFAR, RFE 2018) | 33 |
| 000019 | `eclsa` | `0019_migrate_eclsa.sql` | Indications de l'assistance circulatoire dans le traitement des arrêts cardiaques réfractaires (9 sociétés dont SFAR/SFMU/SFC/SRLF, 2009) | 12 |
| 000020 | `eer` | `0020_migrate_eer.sql` | Épuration extrarénale en réanimation adulte et pédiatrique (SRLF/SFAR/GFRUP/SFD, RFE 2014) | 78 |
| 000021 | `epanchement_pleural` | `0021_migrate_epanchement_pleural.sql` | Épanchement pleural liquidien de l'adulte en soins critiques (SFAR/SFMU/SPLF/SFCTCV, RPP 2023) | 25 |
| 000022 | `glycemie` | `0022_migrate_glycemie.sql` | Contrôle de la glycémie en réanimation et en anesthésie (Sfar/SRLF + 6 partenaires, RFE 2009) | 74 |
| 000023 | `hsa` | `0023_migrate_hsa.sql` | Hémorragie sous-arachnoïdienne grave (SFAR/ANARLF + 2 sociétés, CE 2004) | 60 |
| 000024 | `hyperthermie_maligne` | `0024_migrate_hyperthermie_maligne.sql` | Prise en charge de l'Hyperthermie Maligne (SFAR, RPP 2019) | 11 |
| 000025 | `hypothermie` | `0025_migrate_hypothermie.sql` | Prévention de l'hypothermie peropératoire accidentelle au bloc opératoire chez l'adulte (SFAR, RFE 2018) | 14 |
| 000026 | `ih` | `0026_migrate_ih.sql` | Insuffisance hépatique en soins critiques (SFAR/AFEF, RFE 2018) | 19 |
| 000027 | `intubation_difficile_adulte` | `0027_migrate_intubation_difficile_adulte.sql` | Intubation difficile et extubation en anesthésie chez l'adulte (SFAR, RFE 2017) | 13 |
| 000028 | `intubation_reanimation` | `0028_migrate_intubation_reanimation.sql` | Intubation et extubation du patient de réanimation (SFAR/SRLF/SFMU + 3 sociétés, RFE 2016) | 32 |
| 000029 | `intubation_urgence` | `0029_migrate_intubation_urgence.sql` | Intubation en urgence d'un adulte hors bloc opératoire et hors unité des soins critiques (SFAR/SFMU, RFE 2025) | 28 |
| 000030 | `ira` | `0030_migrate_ira.sql` | Insuffisance rénale aiguë en périopératoire et en réanimation (SFAR/SRLF, RFE 2015) | 33 |
| 000031 | `lat_soins_critiques` | `0031_migrate_lat_soins_critiques.sql` | Décisions de limitation et d'arrêt de traitements (LAT) en soins critiques de l'adulte (SFAR/SOFMER, RFE 2025) | 9 |
| 000032 | `mal_epileptique` | `0032_migrate_mal_epileptique.sql` | États de mal épileptiques de l'adulte et de l'enfant (SRLF/GFRUP/SFMU, RFE 2008) | 163 |
| 000033 | `mtev_perioperatoire` | `0033_migrate_mtev_perioperatoire.sql` | Prévention de la maladie thromboembolique veineuse péri-opératoire (GIHP/SFAR/SFTH/SFMV, RFE 2024) | 77 |
| 000034 | `nutrition` | `0034_migrate_nutrition.sql` | Nutrition artificielle en réanimation (SFAR/SRLF/SFNEP, RFE 2014) | 70 |
| 000035 | `nvpo` | `0035_migrate_nvpo.sql` | Prise en charge des nausées et vomissements postopératoires (SFAR, CE 2008) | 53 |
| 000036 | `pancreatite` | `0036_migrate_pancreatite.sql` | Pancréatite aigüe grave du patient adulte en soins critiques (SFAR + 4 sociétés, RFE 2021) | 24 |
| 000037 | `pavm` | `0037_migrate_pavm.sql` | Pneumonies associées aux soins de réanimation (PAS, incluant la PAVM) (SFAR/SRLF + ADARPEF/GFRUP pédiatrique, RFE 2017) | 17 |
| 000038 | `preeclampsie` | `0038_migrate_preeclampsie.sql` | Prise en charge de la patiente avec une pré-éclampsie sévère (SFAR/CNGOF, RFE 2020) | 27 |
| 000039 | `remplissage` | `0039_migrate_remplissage.sql` | Choix du soluté pour le remplissage vasculaire en situation critique (SFAR/SFMU, RFE 2021) | 9 |
| 000040 | `sdra` | `0040_migrate_sdra.sql` | Recommandations pour la prise en charge du SDRA (traduction SFAR d'un guideline ATS/ESICM/SCCM, 2018) | 5 |
| 000041 | `securisation_proc` | `0041_migrate_securisation_proc.sql` | Sécurisation des procédures à risques en réanimation, risque infectieux exclu (SRLF/SFAR, 2008) | 198 |
| 000042 | `sedation_reanimation` | `0042_migrate_sedation_reanimation.sql` | Sédation et analgésie en réanimation, nouveau-né exclu (Conférence de Consensus SFAR-SRLF, 2007) | 45 |
| 000043 | `sedation_urgences` | `0043_migrate_sedation_urgences.sql` | Sédation et analgésie en structure d'urgence (SFAR/SFMU, 2010) | 160 |
| 000044 | `sepsis` | `0044_migrate_sepsis.sql` | Prise en charge du sepsis du nouveau-né, de l'enfant et de l'adulte (HAS, avec SFAR/SRLF/SFMU/SPILF, RPC 2025) | 130 |
| 000045 | `sepsis_hemodynamique` | `0045_migrate_sepsis_hemodynamique.sql` | Prise en charge hémodynamique du sepsis grave, nouveau-né exclu (SFAR/SRLF, CC 2006) | 33 |
| 000046 | `sevrage_vm` | `0046_migrate_sevrage_vm.sql` | Sevrage de la ventilation mécanique, nouveau-né et réveil d'anesthésie exclus (SRLF/SFAR, CC 2001) | 17 |
| 000047 | `tih` | `0047_migrate_tih.sql` | Diagnostic et prise en charge d'une thrombopénie induite par l'héparine (GIHP/GFHT, avec SFAR, Propositions 2019) | 40 |
| 000048 | `tracheotomie` | `0048_migrate_tracheotomie.sql` | Trachéotomie en réanimation (SRLF/SFAR, avec SFMU/SFORL, RFE 2016/2017) | 18 |
| 000049 | `transfusion_plasma` | `0049_migrate_transfusion_plasma.sql` | Transfusion de plasma thérapeutique : produits, indications (ANSM/HAS, 2012) | 40 |
| 000050 | `traumatisme_abdominal` | `0050_migrate_traumatisme_abdominal.sql` | Prise en charge du traumatisme abdominal grave de l'adulte : les 48 premières heures (SFAR/SFMU, RFE 2019) | 15 |
| 000051 | `traumatisme_cranien` | `0051_migrate_traumatisme_cranien.sql` | Prises en charge neurochirurgicales des traumatismes cranio-encéphaliques (SFNC, avec SFAR/SPILF, RPP 2025) | 43 |
| 000052 | `traumatisme_cranien_leger` | `0052_migrate_traumatisme_cranien_leger.sql` | Prise en charge des patients présentant un traumatisme crânien léger de l'adulte (SFMU/SFAR, RPP 2022) | 14 |
| 000053 | `traumatisme_membre` | `0053_migrate_traumatisme_membre.sql` | Prise en charge des patients présentant un traumatisme sévère de membre(s) (SFAR/SFMU, RFE 2019/2020) | 19 |
| 000054 | `traumatisme_pelvien` | `0054_migrate_traumatisme_pelvien.sql` | Prise en charge des traumatisés pelviens graves à la phase précoce (SFMU/SFAR, RFE 2017) | 22 |
| 000055 | `traumatisme_thoracique` | `0055_migrate_traumatisme_thoracique.sql` | Traumatisme thoracique : prise en charge des 48 premières heures (SFAR/SFMU, avec SFCTCV/SFR, RFE 2015) | 48 |
| 000056 | `traumatisme_vertebromedullaire` | `0056_migrate_traumatisme_vertebromedullaire.sql` | Prise en charge des patients présentant, ou à risque, de traumatisme vertébro-médullaire (SFAR, avec ANARLF/SFCR/SFMU/SOFCOT/SOFMER/SSA, RFE 2019) | 19 |
| 000057 | `urgences_obstetricales` | `0057_migrate_urgences_obstetricales.sql` | Prise en charge des urgences obstétricales en médecine d'urgence (SFMU/SFAR/CNGOF, RPP 2022) | 15 |
| 000058 | `vni` | `0058_migrate_vni.sql` | Ventilation Non Invasive au cours de l'insuffisance respiratoire aiguë, nouveau-né exclu (SFAR/SPLF/SRLF, avec SFMU/SAMU de France/GFRUP/ADARPEF, CC 2006) | 26 |
| 000059 | `voies_aeriennes_enfant` | `0059_migrate_voies_aeriennes_enfant.sql` | Gestion des voies aériennes de l'enfant (SFAR/ADARPEF, RFE 2018) | 17 |
| 000060 | `voies_aeriennes_adulte` | `0060_migrate_voies_aeriennes_adulte.sql` | Prise en charge des voies aériennes en anesthésie adulte à l'exception de l'intubation difficile (SFAR, Conférence de Consensus, texte court 2002/publié 2003) | 53 |
| 000061 | `urgences_transfusionnelles_obstetricales` | `0061_migrate_urgences_transfusionnelles_obstetricales.sql` | Le traitement des urgences transfusionnelles obstétricales (EFS, Conclusions de table ronde 2000-2001, soumis pour avis SFAR/Collège des Obstétriciens/SFTS) | 25 |
| 000062 | `aap_endoprotheses_coronaires` | `0062_migrate_aap_endoprotheses_coronaires.sql` | Gestion du traitement antiplaquettaire oral chez les patients porteurs d'endoprothèses coronaires (SFAR/AFAR, avis d'experts 2006) | 16 |
| 000063 | `bris_dentaires` | `0063_migrate_bris_dentaires.sql` | Bris dentaires périanesthésiques : texte court (SFAR/Adarpef/SFSCMF, RFE 2012) | 36 |
| 000064 | `sujet_age_esf` | `0064_migrate_sujet_age_esf.sql` | Anesthésie du sujet âgé : l'exemple de fracture de l'extrémité supérieure du fémur (SFAR/SOFCOT/SFGG/SFPC, RFE 2017) | 26 |
| 000065 | `examens_preinterventionnels` | `0065_migrate_examens_preinterventionnels.sql` | Examens pré-interventionnels systématiques (SFAR, RFE 2012) — ⚠️ KNOWN DRIFT, non ré-audité contre le PDF source | 38 |
| 000066 | `traumatisme_cranien_grave_precoce` | `0066_migrate_traumatisme_cranien_grave_precoce.sql` | Traumatisés crâniens graves, phase précoce (SFAR/Anarlf/SFMU/SFNC/GFRUP/Adarpef, RFE 2016) — ⚠️ KNOWN DRIFT | 32 |
| 000067 | `monitorage_traumatise` | `0067_migrate_monitorage_traumatise.sql` | Monitorage du patient traumatisé grave en préhospitalier (SFAR/Samu de France/SFMU/SRLF, Conférence d'experts 2006) — ⚠️ KNOWN DRIFT | 55 |
| 000068 | `infarctus_myocarde` | `0068_migrate_infarctus_myocarde.sql` | Infarctus du myocarde à la phase aiguë hors cardiologie (HAS/SAMU de France/SFAR/SRLF, Conférence de consensus 2006) — ⚠️ KNOWN DRIFT, découpage narratif éditorial | 56 |
| 000069 | `avc_precoce` | `0069_migrate_avc_precoce.sql` | AVC : prise en charge précoce (HAS, RBP mai 2009) — ⚠️ KNOWN DRIFT | 54 |
| 000070 | `recommandations_avk` | `0070_migrate_recommandations_avk.sql` | Surdosages/hémorragies/chirurgie sous AVK (GEHT/HAS, RBP avril 2008) — ⚠️ KNOWN DRIFT | 62 |
| 000071 | `douleur_postoperatoire` | `0071_migrate_douleur_postoperatoire.sql` | Douleur postopératoire chez l'adulte et l'enfant (SFAR, RFE 2008) — ⚠️ KNOWN DRIFT, réactualisation 2016 SFAR migrée séparément, voir 0074 (ne la remplace pas) | 101 |
| 000072 | `tih_2002` | `0072_migrate_tih_2002.sql` | Thrombopénie induite par l'héparine (SFAR/GEHT/SFC/SRLF, CE 2002) — ⚠️ KNOWN DRIFT, superseded_by tih/0047 (2019) | 67 |
| 000073 | `amygdalectomie_enfant` | `0073_migrate_amygdalectomie_enfant.sql` | Anesthésie pour amygdalectomie chez l'enfant (SFAR/Adarpef/Carorl, CE 2005) | 72 |
| 000074 | `douleur_reactualisation_2016` | `0074_migrate_douleur_reactualisation_2016.sql` | Réactualisation de la recommandation sur la douleur postopératoire (SFAR/ANREA, RFE 2016) — complète (n'abroge pas) douleur_postoperatoire/0071 | 17 |
| 000075 | `ponction_lombaire` | `0075_migrate_ponction_lombaire.sql` | Prévention et prise en charge des effets indésirables après ponction lombaire (HAS, fiche mémo 2019) — aucun système de grade | 72 |
| 000076 | `protection_oculaire` | `0076_migrate_protection_oculaire.sql` | Protection oculaire en Anesthésie et Réanimation (SFAR/SRLF, RFE 2016) — ⚠️ KNOWN DRIFT | 12 |
| 000077 | `tabagisme` | `0077_migrate_tabagisme.sql` | Recommandations sur la prise en charge du tabagisme en période périopératoire (SFAR/SFT/CNCT/SOFCOT + 2 CNP, RFE 2016) | 4 |
| 000078 | `echo_acces_vasculaires` | `0078_migrate_echo_acces_vasculaires.sql` | Utilisation de l'échographie lors de la mise en place des accès vasculaires (SFAR, RFE 2015) — R7 (sous-clavière enfant) sans grade formulé, non migrée | 9 |
| 000079 | `tenue_vestimentaire` | `0079_migrate_tenue_vestimentaire.sql` | Tenue vestimentaire au bloc opératoire (SFAR/SF2H + AFC/CERES, RPP 2021) — incohérence interne source "13" vs 16 comptées | 16 |

**Total (au 2026-09-19) : 3453 recommandations atomiques, 79 documents, 8
sociétés du seed Annexe B utilisées en document_societies au fil des
migrations (SFAR, SRLF, SPILF, SFMU, SFC, CNGOF, HAS, plus ABM ajoutée au
seed lui-même en 0003 — seule société non couverte par l'Annexe B d'origine,
qui se décrit elle-même comme non exhaustive, section 14.1). Rejeu cumulatif
`schema.sql` + `schema_v2.sql` + `0001`..`0079` sur base fraîche : insertion
en une passe, 0 ligne en seconde passe (idempotence confirmée), safety net
grade composite (`grep -n '"[12][+-]/[12][+-]'`) sans résultat sur les 3
nouveaux fichiers.

### Lot du 2026-09-19 (routine planifiée) — découverte de branches divergentes
### côté rfe-sfar-website + fiches 77-86 (86/99, 13 restantes)

**Découverte critique en tout début de session, avant toute migration** :
la routine planifiée de ce jour a reçu pour instruction de développer sur
des branches fraîches (`claude/laughing-cannon-32te58` côté webapp,
`claude/loving-ritchie-32te58` côté rfe-sfar-website) — mais chaque session
planifiée précédente semble avoir reçu, de la même façon, un nom de branche
nouveau à chaque exécution, sans visibilité sur les branches des sessions
antérieures. Résultat : sur rfe-sfar-website, la PR ouverte #1 pointait sur
`claude/loving-ritchie-v2c5i7` (76 fiches, dernière mise à jour 2026-09-14),
mais une branche `claude/loving-ritchie-t2ggs2` (descendante directe de
`v2c5i7`, jamais rattachée à la PR ni mentionnée nulle part) contenait en
réalité **99 fiches construites**, 23 de plus — travail réel, jamais perdu,
mais invisible tant que l'arbre git n'a pas été exploré branche par branche.
Deux autres branches orphelines (`claude/loving-ritchie-pju8m8`,
`claude/loving-ritchie-1lkmry`) contenaient un troisième chemin de
construction indépendant et divergent : mêmes noms de fiches, mais **au
moins 2 fichiers `content_*.json` avec un contenu réellement différent
selon la branche** (`content_voies_aeriennes_adulte.json` : 2 versions
distinctes ; `content_protection_oculaire.json` : **3 versions distinctes**
sur les 3 branches, dont une vide sur `pju8m8`) — vraisemblablement deux
routines planifiées ayant travaillé en parallèle, chacune sans savoir que
l'autre existait. **Aucune fusion automatique de ces 2 branches orphelines
n'a été tentée** : le risque de mélanger silencieusement deux versions
auditées indépendamment d'une même fiche (ou de réintroduire une version
non finalisée) est jugé trop élevé pour une décision autonome — cf. section
1.3 du cahier des charges V2.1 (relecture humaine obligatoire) et le
principe "disclose, ne résous jamais silencieusement" de ce projet. Ces 2
branches sont laissées intactes sur origin pour investigation humaine ;
elles ne contiennent aucune fiche absente de `t2ggs2` (mêmes 69 noms de
fichiers, tous déjà présents dans les 99 de `t2ggs2`), donc aucun travail
n'est à risque de perte — seule la question "quelle version de
`voies_aeriennes_adulte`/`protection_oculaire` est la bonne" reste ouverte.
**Action prise** : la branche `claude/loving-ritchie-v2c5i7` (support de la
PR #1 ouverte) a été avancée par fast-forward jusqu'à `t2ggs2` (avance
strictement linéaire, aucun commit perdu, aucun conflit) et poussée sous ce
même nom — la PR #1 reflète donc maintenant les 99 fiches sans qu'une
nouvelle PR ait été ouverte, conformément à la consigne "ne pas empiler une
2e PR sur le même sujet". Côté webapp, `claude/laughing-cannon-pju8m8`
s'est révélée être un ancêtre strict de `claude/laughing-cannon-v2c5i7`
(aucune divergence) — rien à réconcilier de ce côté.

Cette découverte porte le périmètre de la Tâche 1 de 76/76 (faux complet) à
76/99 restant à traiter — 20 fiches restent après les 3 migrées ci-dessous.

- **`tabagisme`/0077** (4 recos) : RFE SFAR 2016. Fiche courte, déjà
  entièrement atomique (tableau R1-R4), toutes grade 1+, aucune ambiguïté.
  Question 5 (cigarette électronique) : aucune recommandation formulée
  (seuil de consensus GRADE Grid non atteint) — non migrée, disclosed.
  **À VÉRIFIER** : SFT/CNCT/SOFCOT/CNP Chirurgie Plastique/CNP Chirurgie
  Thoracique et Cardio-vasculaire, co-auteurs, absents du seed Annexe B.
- **`echo_acces_vasculaires`/0078** (9 recos) : RFE SFAR 2015 (méthode
  GRADE, qualité de preuve explicite par recommandation → portée par
  `evidence_level`, distincte du grade de force). R7 (voie sous-clavière
  chez l'enfant) : chip "?", aucune recommandation formulée faute d'essai
  randomisé disponible — non migrée, disclosed ; numérotation native R1-R10
  conservée telle quelle (saut de R06 à R08).
- **`tenue_vestimentaire`/0079** (16 recos) : RPP SFAR-SF2H (+ AFC/CERES)
  2021, GRADE non intégralement applicable (avis d'expert majoritaire,
  grade AE uniforme, Accord fort à 100%). **Incohérence interne source
  disclosed** : la source annonce "13 recommandations" mais 16 énoncés
  individuellement gradés sont dénombrés directement (R1.1.1-R4.2) — aucun
  regroupement ne réconcilie les deux chiffres ; 16 retenu (compte
  vérifiable). **À VÉRIFIER** : SF2H (co-autrice à parité), AFC et CERES
  (validateurs), absents du seed Annexe B.

- **`alr_perinerveuse`/0080** (12 recos) : RFE SFAR 2016 (ALR-PN), met à
  jour sans remplacer la RPC-ALR 2003. **Incohérence interne source
  disclosed** : paragraphe méthodologique contient un texte non finalisé
  ("XX recommandations", répartition annoncée 4/5/5=14) incompatible avec
  le compte direct de 12 (R1.1-R5.2) — 12 retenu.
- **`eeg_cortical`/0081** (2 recos seulement) : RFE texte court SFAR
  2009/2010, format Question/Réponse **sans grille de cotation** (source
  elle-même : Module A "non conçu comme des recommandations"). Décision
  disclosed de ne migrer QUE les 2 énoncés directement actionnables de la
  question 6 (pédiatrie, `grade` NULL) — tout le reste du contenu (Modules
  A et B questions 2-5, figure dose-réponse des halogénés) est explicatif/
  descriptif, sans énoncé "il faut faire X" gradable, et reste dans la
  fiche HTML sans contrepartie atomique en base. **À VÉRIFIER** :
  divergence de date entre le contenu construit ("2009, publié 2010") et
  `library_final.json` (`exact_date` = "2011" seule) — 2010-01-01 retenu.

- **`thrombectomie`/0082** (18 recos) : RPP SFAR/ANARLF (+SFNR/SFNV/GFHT)
  2022. 2 questions sans recommandation formulée (littérature insuffisante),
  non migrées, disclosed. **À VÉRIFIER** : ANARLF/SFNR/SFNV/GFHT absents du
  seed Annexe B ; titres de 2 champs divergents dans la source elle-même
  (en-tête vs résumé des champs).
- **`plyo_transfusion`/0083** (10 recos) : RPP SFAR/SFMU (+7 sociétés) 2020.
  Divergence de granularité disclosed : source annonce "8 recommandations"
  (groupées) vs 10 énoncés individuellement gradés (retenus). Tableau annexe
  "Posologies HAS 2012" explicitement NON migré (grades appartenant à un
  autre référentiel HAS, pas à cette RPP PLYO). **À VÉRIFIER** : ADARPEF/
  CARO/CNCRH/CTSA/EFS/GFRUP/GIHP/SSA absents du seed Annexe B.

- **`sauv`/0084** (21 recos, `grade` NULL sur toutes) : texte organisationnel
  SFMU/Samu de France/SRLF/SFAR 2003 (normes d'architecture/équipement/
  personnel pour une salle d'accueil des urgences vitales) — **PAS un
  référentiel de recommandations cliniques gradées**, la source le dit
  elle-même explicitement. Décision disclosed : chaque sous-section
  normative numérotée de la source (3, 4.1-4.3, 5, 5.2, 6, 7.1, 7.2.1-7.2.5,
  8.1-8.2, 9, 10 — 21 au total) migrée comme une ligne `recommendations`
  sans grade ni population de patients (`condition_topic` porte le domaine
  normatif à la place). Même traitement de principe que `ponction_
  lombaire`/0075 (source également sans système de grade).

- **`remplissage_perioperatoire`/0085** (15 recos) : RFE SFAR/Adarpef 2012,
  distincte de `remplissage`/0039 (RFE 2021 "situation critique" — sujet et
  source différents). Divergence interne disclosed sur R4 (résumé module la
  posologie selon la durée du geste, texte de la recommandation donne un
  intervalle unique) — texte de la recommandation retenu.
- **`brule_grave`/0086** (24 recos, toutes AE/Accord fort) : RPP SFAR/SFB/
  SFMU/Adarpef 2019. **10 annexes citées par la source absentes du PDF
  téléchargé** (vérifié : 0 image sur 38 pages) — non reproduites,
  disclosed. **À VÉRIFIER** : SFB/SFMU/Adarpef absents du seed Annexe B.

### Lot du 2026-09-20 (routine planifiée) — fiches 87-99, TÂCHE 1 COMPLÈTE (99/99)

Reprise de la session du 2026-09-19 (interrompue par une limite de session
en cours de workflow multi-agents — 9 fiches déjà construites et testées
individuellement par les agents, sans audit indépendant complété). Cette
session a : (a) revérifié les 9 fichiers déjà produits (0087-0095) par
relecture ciblée + rejeu PostgreSQL déterministe plutôt qu'un nouvel audit
multi-agents coûteux (leçon de coût tirée de la session précédente) —
trouvés corrects, avec correction de 2 erreurs de vérification (voir
commit dédié "Fix society/specialty tagging errors") ; (b) construit et
testé individuellement, sans agents parallèles, les 4 dernières fiches
(insuffisance_analgesie_cesarienne, relations_anesth_chir,
tests_viscoelastiques, urgences_ob_extrahosp) ; (c) rejeu cumulatif complet
final sur base fraîche : **99 documents, 4138 recommandations, idempotent
(0 ligne en 2e passe), safety net grade composite propre, 100% des
recommendation_code au format attendu**.

- **`alr_non_specialiste`/0087** (34 recos) : Conférence d'experts SFAR sur
  les ALR par médecins non spécialisés en urgence. `medecine_d_urgence` +
  `anesthesie_reanimation`. DOI relevé directement dans le PDF re-téléchargé
  pour cette migration (absent du contenu construit et de l'index).
- **`alr_pediatrie`/0088** (92 recos) : RFE SFAR/ADARPEF (ADARPEF absente du
  seed). Écart disclosed 106 (résumé) vs 92 (compte direct) non résolu.
- **`aod_urgence`/0089** (21 recos) : Propositions du GIHP (absent du seed —
  aucune société liée, requête intentionnellement à 0 ligne, disclosed).
  Distinct de `anticoag_urgence`/0011 et `anticoagulants`/0012 (source_url
  différents, vérifié).
- **`candidoses_aspergilloses`/0090** (59 recos) : Conférence de Consensus
  SFAR/SPILF/SRLF 2004. Distinction organisatrices (liées) vs participantes
  (SF Hématologie/Mycologie/Greffe de Mœlle, absentes du seed) vérifiée
  contre le colophon exact de la source.
- **`catheters_veineux_centraux`/0091** (71 recos) : Réactualisation 12e
  conférence de consensus SRLF 2002/2003 — grille bespoke "Niveau (1-3) -
  Score (a-d)" propre à cette conférence, correctement identifiée et non
  confondue avec du GRADE générique.
- **`coronarien`/0092** (65 recos) : RFE SFAR/SFC.
- **`erreurs_medicamenteuses`/0093** (7 recos) : RFE SFAR 2006.
- **`examens_pertinence_rea`/0094** (43 recos) : RFE SFAR/SRLF.
- **`infections_intra_abdominales`/0095** (44 recos) : RFE SFAR/SRLF/SPILF +
  2 sociétés chirurgicales absentes du seed (specialty
  `chirurgie_digestive_et_viscerale` retenue à leur place).
- **`insuffisance_analgesie_cesarienne`/0096** (24 recos, `grade` NULL) :
  Préconisations CARO/CNGOF/SFAR (+7 partenaires absents du seed) 2021,
  aucun système de cotation. Doublon d'impression P1.7/P1.8 dans la source
  reproduit tel quel (2 lignes identiques, non fusionnées). Incohérence
  chiffrée non réconciliée sur la fréquence de l'insuffisance d'analgésie.
- **`relations_anesth_chir`/0097** (29 recos, `grade` NULL) : texte
  déontologique/juridique CNOM/SFAR 2001 — même traitement que `sauv`/0084
  (aucun système de cotation scientifique). Incohérence interne disclosed
  (loi n°2001-586 vs n°2001-588 pour le même texte).
- **`tests_viscoelastiques`/0098** (9 recos, `grade` NULL) : position GIHP
  publiée **en anglais** (Anaesth Crit Care Pain Med 2019) — `original_
  language`='en', piège identifié et vérifié explicitement (pas une
  supposition 'fr' par défaut). 9 positions du GIHP réparties sur 4
  situations cliniques (3+2+2+2), décompte vérifié conforme à la source.
  Grade 2C d'une recommandation externe (ESA) explicitement NON attribué à
  ce document. Absence de position propre en pédiatrie disclosed, non migrée.
- **`urgences_ob_extrahosp`/0099** (85 recos, la plus volumineuse migration
  du corpus) : RFE SFAR/SFMU/CNGOF 2010, 9 chapitres. 2 corrections d'unité
  déjà faites par le contenu construit lui-même (sulprostone mg/h→µg/h,
  créatininémie mmol/L→µmol/L, artefacts d'extraction PDF) conservées telles
  quelles. Tableaux de référence diagnostique différentielle et algorithmes
  figuratifs dupliquant un tableau adjacent explicitement exclus (disclosed)
  pour éviter le doublonnage plutôt que la perte de couverture.

**Note de méthode (coût)** : le lot 0087-0095 a initialement été produit via
un workflow à agents parallèles (construction + audit indépendant par
fiche) qui a consommé ~2M tokens et heurté une limite de session avant la
fin. Sur demande explicite du porteur de projet, cette approche est
abandonnée pour la suite du pipeline (Tâche 2) : traitement séquentiel,
sans flotte d'agents parallèles par défaut, la vérification directe
(lecture complète + rejeu PostgreSQL déterministe) étant suffisante et
nettement moins coûteuse pour ce type de travail.

## ✅ TÂCHE 1 COMPLÈTE — 99/99 fiches migrées (2026-09-20)

Plus aucune fiche `content_*.json` de `rfe-sfar-website` (branche
`claude/loving-ritchie-t2ggs2`, 99 fiches au 2026-09-19) n'attend de
migration. **4138 recommandations atomiques au total**, toutes en statut
`draft`. Passage à la Tâche 2 (reprise du pipeline de construction de
nouvelles fiches côté `rfe-sfar-website`) à la prochaine session — sous
réserve que le fork de branches non résolu (`claude/loving-ritchie-pju8m8`,
`claude/loving-ritchie-1lkmry`, voir "Lot du 2026-09-19" ci-dessus) reste
sans conséquence sur les fiches déjà migrées ici (vérifié : aucune des 2
fiches divergentes, `voies_aeriennes_adulte` et `protection_oculaire`, n'a
été retouchée dans cette migration au-delà de leur contenu déjà migré en
0060 et 0076 respectivement — une décision humaine sur ces 2 branches
orphelines reste nécessaire indépendamment de l'avancement de la Tâche 1).

### Lot du 2026-09-15 (routine planifiée) — fiches 73-76, TÂCHE 1 COMPLÈTE (76/76)

Découverte au démarrage de cette session que `rfe-sfar-website` avait avancé
à 76 fiches `content_*.json` construites (branche `claude/loving-ritchie-v2c5i7`)
alors que la migration Tâche 1 s'était arrêtée à 72/72 lors de la session
précédente (close le 2026-09-13) — 4 fiches ajoutées entre-temps restaient
non migrées : `amygdalectomie_enfant`, `douleur_reactualisation_2016`,
`ponction_lombaire`, `protection_oculaire`. Les 4 migrations ont été
produites en parallèle (un sous-agent par fiche, chacun avec sa propre base
de test PostgreSQL isolée), puis validées ensemble par un rejeu cumulatif
des 76 migrations dans l'ordre sur une base fraîche (`schema.sql` +
`schema_v2.sql` + `0001`..`0076`) : 76 documents / 3424 recommandations
insérés en une passe, 0 ligne insérée en seconde passe (idempotence globale
confirmée), aucune violation du format `recommendation_code`, aucun grade
composite détecté.

- **`amygdalectomie_enfant`/0073** (72 recos) : Conférence d'experts SFAR/
  Adarpef/Carorl 2005. Deux systèmes de cotation combinés sans jamais être
  fusionnés sur une même ligne (Grade A/B/C selon la littérature ; Accord
  fort/faible RAND/UCLA modifié en l'absence de preuve suffisante) — 48
  Accord fort, 3 Grade A, 6 Grade B, 14 Grade C, 1 Accord faible. Vérifié :
  aucune proposition ne porte un grade D/E (présents seulement dans la
  légende méthodologique). **À VÉRIFIER** : Adarpef et Carorl, co-organisateurs
  à égalité avec la SFAR, absents du seed Annexe B — seule la SFAR est liée
  en `document_societies`.
- **`douleur_reactualisation_2016`/0074** (17 recos) : SFAR/ANREA, RFE 2016.
  Complète explicitement (n'abroge pas) la RFE SFAR 2008 déjà migrée en
  0071 — aucune relation `superseded_by`/`freshness_status` posée entre les
  deux documents (vérifié en base après migration : 0071 inchangé). Numérotation
  source R1.1-R1.5/R3.1-R3.9/R4.1-R4.3 reproduite telle quelle, y compris
  l'absence de tout R2.x (disclosure de la source elle-même : la question du
  monitorage de l'analgésie n'a abouti à aucune recommandation formalisée).
  **Divergence source-interne disclosée** (non résolue) : l'intro annonce
  "11 fortes/3 faibles/3 avis d'experts" (11+3+3=17) mais le recompte tag par
  tag des 17 recommandations donne 10 fortes/4 faibles/3 avis d'experts
  (10+4+3=17 également, mais 10 et non 11 fortes) — les 17 tags individuels
  font foi. **À VÉRIFIER** : ANREA absent du seed Annexe B (seule la SFAR est
  liée) ; trois dates de validation/publication distinctes selon la source
  consultée (retenue : mise en ligne du 31/10/2016, les deux autres restant
  documentées dans le fichier de migration).
- **`ponction_lombaire`/0075** (72 recos) : fiche mémo HAS, juin 2019 —
  premier document du corpus sans aucun système de grade ni de cotation
  d'accord (synthèse narrative de littérature, disclosure explicite de la
  source elle-même) ; `grade`/`evidence_level` NULL sur les 72 lignes,
  confirmé par requête. 11 lignes pédiatriques dédiées (`population` =
  'Pédiatrie', R62-R72). HAS est dans le seed Annexe B, aucune société
  manquante à disclosed.
- **`protection_oculaire`/0076** (12 recos) : ⚠️ **PROVENANCE — KNOWN DRIFT**
  (même disclosure que 0065/0072 et consorts) — contenu récupéré depuis
  l'Artifact publié en ligne, aucun `fiche_*.py` ni PDF source jamais committé
  côté rfe-sfar-website, jamais audité contre le PDF original ; publication
  du contenu still pending décision du porteur de projet côté rfe-sfar-website
  (voir la PR ouverte de ce dépôt). Migré en `draft` comme toute fiche de ce
  lot — la relecture humaine reste entièrement à faire, avec une vigilance
  accrue sur cette fiche en particulier. **À VÉRIFIER** (plusieurs, disclosure
  volontairement renforcée compte tenu de la provenance) : incohérence
  interne sur le décompte ("10 recommandations" annoncé par la méthodologie
  source vs. 12 réellement dénombrées, les 12 faisant foi) ; le tag Delphi
  "Accord FORT" n'est imprimé individuellement que sur 3 des 12 items gradés
  GRADE mais affirmé globalement par un paragraphe de synthèse (non modélisé,
  schéma sans colonne dédiée) ; 6 des 9 lignes tagguées AE emploient une
  formulation ("il est probablement recommandé") que la méthodologie de la
  source associe habituellement à GRADE 2+ — non résolu, le tag AE imprimé
  est conservé tel quel ; SFO absent du seed Annexe B (seules SFAR et SRLF
  liées) ; aucune URL source n'était citée dans le contenu récupéré lui-même,
  celle utilisée provient de `library_final.json` (cohérente par titre/sujet/
  année, non re-vérifiée contre le PDF).

### Fiche 72 — `tih_2002` (`0072_migrate_tih_2002.sql`, ajoutée 2026-09-13, routine planifiée) — dernière fiche du lot du 2026-09-13 (Tâche 1 rouverte le 2026-09-15, voir le lot 73-76 ci-dessus pour la clôture réelle à 76/76)

Thrombopénie induite par l'héparine (SFAR/GEHT/SFC/SRLF, Conférence
d'experts, 2002). **⚠️ PROVENANCE** : KNOWN DRIFT (même disclosure que
0065-0071).

**Aucun système de grade formel** — la source le dit explicitement
("les experts ont estimé inutile d'assortir chaque proposition d'un
grade"). `grade`/`evidence_level` NULL sur les 67 lignes. La colonne
"Thème" de la source remplace la colonne de grade habituelle
(`condition_topic`).

**⚠️ Document explicitement superseded** — disclosure la plus forte de ce
lot, faite par la fiche source elle-même dès son introduction : "une
fiche plus récente existe... les Propositions du GIHP et du GFHT (2019)
sont le document de référence ACTUEL". Ce document 2019 est déjà migré
(`tih`/0047). `freshness_status = 'revision_detectee'` ET
`superseded_by_document_id` effectivement pointé vers ce document via
UPDATE post-insertion (vérifié en base : `superseded_by` = "Diagnostic et
prise en charge d'une thrombopénie induite par l'héparine"). Lépirudine
(Refludan®) retirée du marché depuis 2012 — posologies reproduites
fidèlement à titre documentaire uniquement.

Les 7 lignes du tableau comparatif "Traitements de substitution"
(R22-R28) fusionnent par thème les données des 3 molécules comparées
(danaparoïde, lépirudine, désirudine) en un seul `statement` chacune.

**À VÉRIFIER** : GEHT hors seed Annexe B — SFAR/SFC/SRLF (dans le seed)
liées. `population` = 'Femme enceinte' (R48) et 'Pédiatrie' (R49).

**Testé par exécution réelle** : total recommandations en base après
coup : 3251 (3184 + 67) ; `superseded_by_document_id` vérifié pointer
correctement vers le document 2019 ; idempotence confirmée (INSERT/UPDATE
0 sur ré-exécution complète, y compris l'UPDATE de supersession).

---

## ✅ TÂCHE 1 COMPLÈTE (2026-09-13) — 72/72 fiches `content_*.json` migrées

Les 11 fichiers découverts non migrés en début de session (routine
planifiée du 2026-09-13) ont tous été migrés dans cette même session :
`aap_endoprotheses_coronaires`/0062, `bris_dentaires`/0063,
`sujet_age_esf`/0064, `examens_preinterventionnels`/0065,
`traumatisme_cranien_grave_precoce`/0066, `monitorage_traumatise`/0067,
`infarctus_myocarde`/0068, `avc_precoce`/0069, `recommandations_avk`/0070,
`douleur_postoperatoire`/0071, `tih_2002`/0072. Total final : 3251
recommandations atomiques, 72 documents, 62 migrations 0001-0072 rejouées
sans erreur contre PostgreSQL 16 local à chaque étape.

**9 de ces 11 fiches restent "KNOWN DRIFT"** (0065-0071, hors
`bris_dentaires`/0063 et `sujet_age_esf`/0064 qui avaient déjà suivi le
pipeline complet du projet rfe-sfar-website) : leur `content_*.json` a été
récupéré depuis l'Artifact live sans jamais avoir suivi le pipeline de
triple-lecture + audit indépendant de ce projet. Chaque migration
correspondante porte une disclosure explicite en tête de fichier. La
Tâche 1 (migration structurelle vers le modèle atomique) est terminée
pour ces 9 fiches, mais une relecture humaine renforcée — voire un audit
complet contre le PDF source — reste recommandée avant de faire passer
leurs recommandations en `published`.

**2 nouvelles disclosures trouvées pendant cette session** (non signalées
par les fiches sources elles-mêmes) : (1) `sujet_age_esf`/0064, R5.4 —
même incohérence formulation-négative/tag-positif que R3.3/R3.4, non
disclosée par la fiche source ; (2) `douleur_postoperatoire`/0071 —
existence d'une réactualisation SFAR 2016 de cette même RFE, non
mentionnée par la fiche 2008, non encore construite dans le corpus
rfe-sfar-website (candidat prioritaire pour la Tâche 2).

**Suite (Tâche 2)** : reprendre le pipeline de construction de nouvelles
fiches côté rfe-sfar-website — diff entre `library_final.json` (160 items)
et `site/app.js` `FICHE_HREF_MATCH` (72 clés après cette session) pour
identifier le prochain document prioritaire à construire. Voir
rfe-sfar-website/CLAUDE.md pour le pipeline complet.

### Fiche 71 — `douleur_postoperatoire` (`0071_migrate_douleur_postoperatoire.sql`, ajoutée 2026-09-13, routine planifiée)

Prise en charge de la douleur postopératoire (DPO) chez l'adulte et
l'enfant (SFAR, RFE 2008). **⚠️ PROVENANCE** : KNOWN DRIFT (même
disclosure que 0065-0070).

**Particularité méthodologique** : cette source n'imprime AUCUN tag
individuel — la force est encodée dans le VERBE de chaque phrase ("il est
recommandé" = Fort, "il est probablement recommandé" = Faible), résolution
textuelle disclosée par la fiche construite elle-même. La source ne
numérote aucune recommandation ; le découpage en 101 lignes est thématique
et ne recoupe PAS le chiffre agrégé "124 recommandations" que la source
annonce (disclosure explicite, pas une divergence introduite par cette
migration). Répartition en base : Fort:67 / Faible:27 / NULL:7 (=101).
`population` = 'Sujet âgé' (3) et 'Pédiatrie' (8).

**⚠️ NOUVELLE DISCLOSURE trouvée par cette migration** (pas mentionnée par
la fiche source elle-même) : `library_final.json` contient une
réactualisation SFAR 2016 de CETTE MÊME RFE ("Réactualisation de la
recommandation sur la douleur postopératoire", 2016-09-01), pas encore
construite comme fiche dans ce corpus (absente de `FICHE_HREF_MATCH`).
`freshness_status = 'revision_detectee'` retenu sur ce critère renforcé
(succession documentée, pas seulement une disclosure générique) — signalé
comme candidat prioritaire pour la Tâche 2 (prochaine fiche à construire).

**À VÉRIFIER** : R72 (bloc paravertébral sein, "probablement recommandé")
— divergence source-interne déjà disclosée par la fiche construite
elle-même vs R61 ("recommandé en priorité" sans "probablement" pour la
même indication) : les deux formulations reproduites telles quelles.

**Testé par exécution réelle** : total recommandations en base après
coup : 3184 (3083 + 101) ; idempotence confirmée.

### Fiche 70 — `recommandations_avk` (`0070_migrate_recommandations_avk.sql`, ajoutée 2026-09-13, routine planifiée)

Surdosages en AVK, situations à risque hémorragique et accidents
hémorragiques sous AVK (GEHT/HAS, RBP, avril 2008). **⚠️ PROVENANCE** :
KNOWN DRIFT (même disclosure que 0065-0069).

Grades HAS A/B/C + AP. 62 recommandations sur 5 chapitres (surdosage dont
7 cellules du Tableau 1, hémorragies, chirurgie/relais 4.1-4.2, modalités/
indications 4.3-4.4, acte urgent 4.5). Répartition en base 5A/2B/21C/25AP/
9 NULL — les 5A/2B/21C reconcilient EXACTEMENT les "28 citations (grade X)
explicites" que la fiche construite annonce elle-même (grep exhaustif).

**Disclosure déjà faite par la source, reproduite** : 2 clauses (R39 ACFA
haut risque, R55 MTEV risque modéré) cliniquement analogues à des clauses
gradées C dans la même sous-section n'ont AUCUN tag imprimé — retranscrites
AP, jamais un C inventé par analogie.

**Volontairement pas migrés** : cellule Tableau 1 "INR<4/cible>=3" (hachurée
"sans objet" par la source) ; Annexe 1 (grille risque hémorragique
rhumatologie, classification) ; Annexe 2 (exemple chronologique J-5→J0,
déjà couvert en substance par R43).

**À VÉRIFIER** : GEHT (promoteur) hors seed Annexe B — seule HAS liée.
`freshness_status` laissé 'a_jour' (l'avertissement de la source ne
déclare pas explicitement une péremption de stratégie, contrairement à
0068/0069 — jugement éditorial documenté, discutable par un relecteur vu
l'essor des AOD depuis 2008).

**Testé par exécution réelle** : total recommandations en base après
coup : 3083 (3021 + 62) ; idempotence confirmée.

### Fiche 69 — `avc_precoce` (`0069_migrate_avc_precoce.sql`, ajoutée 2026-09-13, routine planifiée)

AVC : prise en charge précoce (alerte, phase préhospitalière, phase
hospitalière initiale, indications de la thrombolyse) (HAS, RBP, mai
2009). **⚠️ PROVENANCE** : KNOWN DRIFT (même disclosure que 0065-0068).

Grades HAS A/B/C + "accord professionnel" (AP, comme `transfusion_
plasma`/0049), PAS le GRADE 1+/2+ utilisé ailleurs. 54 recommandations sur
5 sous-sections cliniques (alerte 13, préhospitalier 14, hospitalier
initial 16, thrombolyse IV 8, thrombolyse IA 3) — répartition en base
1A/2B/4C/43AP/4 NULL, EXACTEMENT le compte que la fiche construite annonce
elle-même. Les 4 lignes NULL sont des énoncés explicitement non tagués par
la source elle-même (scanner à défaut d'IRM, orientation systématique UNV,
sonothrombolyse, thrombolyse combinée/mécanique) — reproduits tels quels,
aucun grade inventé. `population` = 'Sujet âgé (> 80 ans)' (R46) et
'Pédiatrie (< 18 ans)' (R47).

**Volontairement pas migrés** : Annexe 1 (algorithme, chaîne opérationnelle
à un seul chemin, déjà couverte par les recommandations individuelles) ;
Annexe 2 (contre-indications ACTILYSE®, extrait littéral du RCP/AMM du
fabricant — donnée réglementaire pharmaceutique, pas une recommandation
formulée/gradée par le groupe de travail HAS).

**À VÉRIFIER** : Société française neuro-vasculaire (société savante) et
DHOS (une administration, pas une société savante) hors seed — seule la
HAS est liée. `publication_date` = 2009-05-01 (mois+année connus, jour
non précisé). `freshness_status = 'revision_detectee'` — la source
elle-même déclare la thrombolyse/thrombectomie "évoluées depuis 2009".

**Testé par exécution réelle** : total recommandations en base après
coup : 3021 (2967 + 54) ; idempotence confirmée.

### Fiche 68 — `infarctus_myocarde` (`0068_migrate_infarctus_myocarde.sql`, ajoutée 2026-09-13, routine planifiée)

Prise en charge de l'infarctus du myocarde à la phase aiguë en dehors des
services de cardiologie (HAS/SAMU de France/Société francophone de
médecine d'urgence/Société française de cardiologie, Conférence de
consensus, 23/11/2006). **⚠️ PROVENANCE** : KNOWN DRIFT (même disclosure
que 0065-0067).

**⚠️ PARTICULARITÉ DE CE LOT** : contrairement aux autres fiches, ce
document N'EST PAS structuré en liste numérotée R1/R2 par la source — texte
de conférence de consensus en prose continue (4 algorithmes décisionnels +
1 tableau "Traitements adjuvants" + paragraphes narratifs). Les 56
recommandations ci-dessous sont un DÉCOUPAGE ÉDITORIAL de cette migration
(chaque énoncé actionnable autonome identifié à la lecture), pas une
transcription mécanique d'une numérotation source — à vérifier avec un
soin particulier par un relecteur humain.

Grades HAS A/B/C (PAS le GRADE 1+/2+ utilisé ailleurs dans ce corpus) —
seules 11 mentions explicites de grade dans tout le texte (3xA, 7xB, 1xC,
disclosure de la fiche source elle-même) ; `grade` NULL sur la majorité des
56 lignes (consensus du jury sans grade individuel, reproduit fidèlement).
Vérifié en base : 3 A, 1 C, 13 B — les 13 B se décomposent en 6 mentions
individuelles + 1 mention de section ("(grade B)" introduisant le tableau
tachycardies) appliquée à ses 7 lignes = 6+7=13 lignes pour 7 mentions
imprimées, cohérent avec le compte "7xB" de la source (11 mentions
imprimées au total, 17 lignes portent un grade en base : 3+13+1=17).
`population` renseigné pour Q4 (Sujet âgé, Diabète, Périopératoire).

**Volontairement pas migré** : Algorithme 3 (filières SAMU → effecteur →
SCDI, chaîne opérationnelle à un seul chemin, pas de branchement
décisionnel) ; Annexe 1 (échelle de gradation HAS elle-même).

**À VÉRIFIER** : "Société francophone de médecine d'urgence" (promoteur
nommé par la source) N'EST PAS liée à SFMU du seed (ambiguïté de
dénomination non résolue par supposition) — seules SFAR, SRLF et HAS
(partenaire méthodologique explicite) sont liées. `doc_type` = "Conférence
de consensus" (auto-désignation) vs `library_final.json` "RFE" —
divergence disclosée. `freshness_status = 'revision_detectee'` — la source
elle-même déclare les stratégies "évoluées depuis 2006 (P2Y12,
recommandations ESC ultérieures)".

**Testé par exécution réelle** : total recommandations en base après
coup : 2967 (2911 + 56) ; idempotence confirmée ; safety net grade
composite sans résultat.

### Fiche 67 — `monitorage_traumatise` (`0067_migrate_monitorage_traumatise.sql`, ajoutée 2026-09-13, routine planifiée)

Monitorage du patient traumatisé grave en préhospitalier (SFAR/Samu de
France/SFMU/SRLF, Conférence d'experts, texte court, 2006). **⚠️
PROVENANCE** : KNOWN DRIFT, même disclosure que 0065/0066.

PAS de GRADE — force A-E (A = >= 2 études niveau I ... E = niveau IV/V,
avis d'experts), `evidence_level` NULL (même convention que `hsa`/0023).
55 recommandations sur 8 questions — exactement le compte que la fiche
construite annonce ("55 recommandations... sur 75 lettres de grade
imprimées au total", le reste étant du contexte non promu en ligne).
Répartition en base A:3/B:4/C:2/D:22/E:24 (=55). `population` = 'Femme
enceinte' (3 lignes RCF) et 'Pédiatrie' (4 lignes "— enfant"), NULL
ailleurs.

**À VÉRIFIER** : Samu de France hors seed Annexe B ; SFMU et SRLF (dans le
seed) SONT liées avec SFAR. `doc_type` = "Conférence d'experts" (auto-
désignation de la source) vs `library_final.json` "RFE" — divergence
disclosée. `publication_date` = 2006-01-01 (année seule connue).
`freshness_status = 'revision_detectee'` — disclosure explicite de la
source elle-même ("les pratiques ... ont pu évoluer depuis").

**Testé par exécution réelle** : total recommandations en base après
coup : 2911 (2856 + 55) ; idempotence confirmée.

### Fiche 66 — `traumatisme_cranien_grave_precoce` (`0066_migrate_traumatisme_cranien_grave_precoce.sql`, ajoutée 2026-09-13, routine planifiée)

Prise en charge des traumatisés crâniens graves à la phase précoce (24
premières heures) (SFAR/Anarlf/SFMU/SFNC/GFRUP/Adarpef, RFE 2016). **⚠️
PROVENANCE** : fait partie des 9 fichiers "KNOWN DRIFT" — même disclosure
que `examens_preinterventionnels`/0065 (récupéré depuis l'Artifact live
sans fiche_*.py ni fichier source committé).

GRADE 1+/1-/2+/2-/AE. 32 recommandations R1.1-R11.3 sur 11 champs
cliniques — répartition en base 10 grade1 / 18 grade2 / 4 AE, EXACTEMENT
le compte que la source revendique elle-même (recompté page 441). Accord
FORT pour 100% des 32 recommandations (pas de mention "(accord faible)"
à reproduire, contrairement à `sujet_age_esf`/0064). `population` =
'Adulte' (R9.1, marqueur explicite) et 'Pédiatrie' (R11.1-R11.3, champ 11
dédié) ; NULL ailleurs.

**Volontairement pas migré** : le champ 12 "Contrôle ciblé de la
température" (R12.1-R12.6) — la source elle-même le présente comme une
"retranscription partielle" de la RFE 2016 SFAR/SRLF dédiée, déjà migrée
séparément (`controle_temperature`/0016, mêmes énoncés/grades vérifiés
ligne à ligne par la fiche construite). Non remigré ici pour éviter un
doublon de contenu sous un code différent.

**À VÉRIFIER** : Anarlf, SFNC, GFRUP, Adarpef hors seed Annexe B ; SFMU
(dans le seed) EST liée avec SFAR. `publication_date` = 2016-09-21 (date
de validation CA Sfar citée par la source elle-même) plutôt que le
2016-09-24 de `library_final.json` (écart mineur, disclosure).

**Testé par exécution réelle** : total recommandations en base après
coup : 2856 (2824 + 32) ; idempotence confirmée ; safety net grade
composite sans résultat.

### Fiche 65 — `examens_preinterventionnels` (`0065_migrate_examens_preinterventionnels.sql`, ajoutée 2026-09-13, routine planifiée)

Examens pré-interventionnels systématiques (SFAR, RFE 2012). **⚠️
PROVENANCE** : `content_examens_preinterventionnels.json` fait partie des 9
fichiers "KNOWN DRIFT" du CLAUDE.md rfe-sfar-website — récupéré depuis
l'Artifact live sans `fiche_*.py` ni fichier source committé, PAS
re-audité contre le PDF source. Détail complet en tête du fichier de
migration ; à traiter avec une attention de relecture supérieure aux
fiches git-natives auditées (`bris_dentaires`/0063, `sujet_age_esf`/0064).

GRADE 1+/1-/2+/2-. 38 recommandations regroupées sous 9 références "R1"-
"R9" par thème d'examen (cardio, respiratoire, hémostase, hémogramme,
immunohématologie, biochimie, femme enceinte, test de grossesse, dépistage
infectieux) — chaque référence couvre plusieurs propositions
individuellement graduées. Répartition en base 1+:14/1-:14/2+:9/2-:1,
EXACTEMENT le compte que la fiche source annonce elle-même. `evidence_level`
NULL (pas de niveau distinct du tag de force).

**Volontairement pas migrés** : Tableau 1 (grille ECBU/BU par type de
chirurgie x risque, déjà couvert par R35-R38), Tableau 2 (synthèse ASA x
risque, résumé de haut niveau) et Annexe A (stratification risque cardiaque
ACC/AHA, classification citée en soutien de R01-R06) — tableaux de
synthèse/classification, pas des propositions votées séparément.

**À VÉRIFIER** : CNGOF et SFC figurent dans le seed Annexe B et SONT liées
en `document_societies` avec SFAR (contrairement au traitement "SFAR seule"
des autres fiches de ce lot) ; 12 autres sociétés validatrices (AFC, AFU,
EFS, SCGP, SFCD, GEHT, SF2H, SOFOP, SFORL, SFR-FRI, SFSCMF, SPLF) restent
hors seed, non liées. `publication_date` = 2012-01-01 par convention (année
seule connue, même traitement que `allergie_prevention`/0006).

**Testé par exécution réelle** : total recommandations en base après coup :
2824 (2786 + 38) ; idempotence confirmée ; safety net grade composite sans
résultat.

### Fiche 64 — `sujet_age_esf` (`0064_migrate_sujet_age_esf.sql`, ajoutée 2026-09-13, routine planifiée)

Anesthésie du sujet âgé : l'exemple de FESF (SFAR/SOFCOT/SFGG/SFPC, RFE
2017). GRADE® (force 1+/1-/2+/2-/AE + accord Delphi, fort par défaut, faible
pour R1.4/R5.1 seulement, cité inline). 26 recommandations R1.1-R8.2.
`evidence_level` NULL (pas de niveau de preuve distinct du tag de force,
même convention que `sepsis`/0044).

**NOUVELLE DISCLOSURE trouvée par cette migration** (pas signalée par la
fiche source rfe-sfar-website elle-même) : R5.4 présente la même
incohérence que R3.3/R3.4 déjà disclosée par la fiche (formulation négative
"il ne faut probablement pas…" mais imprimée "GRADE 2+ (ACCORD FORT)") —
vérifiée directement contre `rfe-sfar-website/sources/anesthesie_sujet_age.txt`
ligne 846 (texte source brut, pas une erreur d'extraction du pipeline).
Tag imprimé "2+" conservé tel quel (ni corrigé ni deviné). À reporter dans
la disclosure méthodologique de la fiche rfe-sfar-website elle-même — hors
périmètre de ce script SQL.

**À VÉRIFIER** : SOFCOT, SFGG, SFPC hors seed Annexe B — seule la SFAR
liée en `document_societies`. Tableau I (délai d'intervention, données
épidémiologiques par référence bibliographique) volontairement pas migré
en recommandation distincte (contexte appuyant R12/R4.1, pas une
proposition).

**Testé par exécution réelle** : total recommandations en base après coup :
2786 (2760 + 26), répartition grade 1+:7 / 1-:1 / 2+:12 / 2-:2 / AE:4
(= 26) vérifiée en base ; idempotence confirmée ; safety net grade composite
(`grep -n '"[12][+-]/[12][+-]'`) sans résultat.

### Fiche 63 — `bris_dentaires` (`0063_migrate_bris_dentaires.sql`, ajoutée 2026-09-13, routine planifiée)

Bris dentaires périanesthésiques : texte court (RFE commune SFAR/Adarpef/
SFSCMF, 2012). **Aucun GRADE** — mention de force unique et globale
imprimée par la source ("toutes les propositions ont reçu un accord fort") :
`grade = 'Fort'` uniforme sur les 36 lignes, pas une distinction inventée.
36 recommandations : 31 propositions numérotées (R01-R31, `population` NULL)
+ 5 encarts "Proposition enfant" non numérotés par la source, intercalés
dans le corps du texte (R32-R36, `population = 'Pédiatrie'` — marqueur
explicite "chez l'enfant" dans chaque encart). Numérotation R32-R36 : pure
convention de ce script pour l'unicité de `recommendation_code`, la source
ne les numérote pas. Contrairement à plusieurs autres fichiers de ce lot,
cette fiche a déjà suivi le pipeline complet du projet rfe-sfar-website
(git-native, triple-lecture + audit indépendant déjà faits — voir son
CLAUDE.md) : aucune réserve de provenance à signaler ici.

**À VÉRIFIER** : ADARPEF et SFSCMF (co-auteurs de la RFE, même titre que la
SFAR) ne figurent pas dans le seed Annexe B — seule la SFAR est liée en
`document_societies`, même traitement que `ecbu`/0002 et
`aap_endoprotheses_coronaires`/0062.

**Testé par exécution réelle** : total recommandations en base après coup :
2760, soit exactement 2724 + 36 (63 migrations 0001-0063 rejouées dans
l'ordre sans erreur) ; idempotence vérifiée par ré-exécution isolée du
fichier (4x `INSERT 0 0`) ; 5 lignes `population = 'Pédiatrie'` confirmées
en base.

### Fiche 62 — `aap_endoprotheses_coronaires` (`0062_migrate_aap_endoprotheses_coronaires.sql`, ajoutée 2026-09-13, routine planifiée)

Gestion du traitement antiplaquettaire oral (AAP) chez les patients porteurs
d'endoprothèses coronaires (SFAR/AFAR, avis d'un groupe d'experts, 31 mars
2006, Ann Fr Anesth Reanim 2006;25:796-798). **Aucun système de gradation**
(ni GRADE, ni vote/pourcentage d'accord) — `grade`/`evidence_level` NULL sur
les 16 lignes. 16 recommandations atomiques : 9 lignes du tableau thématique
du corps du texte (le document source condense lui-même ses 10 propositions
initiales en ces 9 lignes) + 6 cellules du Tableau 1 (matrice de décision
risque-thrombose x risque-hémorragique) + 1 consigne transversale
s'appliquant dans tous les cas ("reporter au-delà de 6 semaines d'un SCA").
`population` NULL sur les 16 lignes (population unique, déjà dans le titre).

**Fraîcheur** : `revision_detectee` — la fiche source elle-même (intro ET
avertissement final) déclare explicitement ce document "antérieur aux
propositions GIHP/GFHT/SFAR 2018" (déjà migrées : `aap_urgence`/0004,
`aap_programmee`/0005) et recommande de s'y référer pour la gestion générale
des AAP ; ce document-ci reste néanmoins la seule source du corpus dédiée à
la matrice de décision spécifique "stent coronaire", d'où sa migration
séparée sans fusion ni dépréciation automatique.

**Divergence de classification disclosurée** : `library_final.json` classe
ce document `exact_type: "RFE"` ; la source se désigne elle-même comme une
"Information professionnelle", sans la structure méthodologique (vote,
cotation) d'une RFE. `doc_type` reprend l'auto-désignation de la source ;
la classification de l'index est reproduite en commentaire pour traçabilité,
non silencieusement écartée.

**Volontairement pas migrés en recommandations distinctes** : le panneau
"Champ" (cadrage, pas une proposition) ; les 3 notes de définition du
Tableau 1 (nécessaires à l'interprétation de R10-R15, pas des propositions
indépendantes) ; la section "Sources et traçabilité" (métadonnées
bibliographiques).

**Testé par exécution réelle** contre PostgreSQL 16 local (`schema.sql` +
`schema_v2.sql` + les 62 migrations 0001-0062 rejouées dans l'ordre sans
erreur, stub `auth.users`/`auth.uid()` comme pour les migrations
précédentes ; total recommandations en base après coup : 2724, soit
exactement 2708 + 16). `document_societies` (SFAR seule — société
publicatrice du journal AFAR/relais sfar.org, cohérent avec le traitement
"SFAR comme société hébergeuse" déjà appliqué à `ecbu`/0002 pour une source
non-SFAR) et `document_specialties`
(`anesthesie_reanimation`/`cardiologie`) vérifiés en base après migration.

### Fiche 61 — `urgences_transfusionnelles_obstetricales` (`0061_migrate_urgences_transfusionnelles_obstetricales.sql`, ajoutée 2026-09-11)

EFS (Établissement Français du Sang), Conclusions de la table ronde du
26/09/2000 (texte daté 21/12/01-07/06/01, mis en ligne sfar.org 2015),
soumise pour avis à la SFAR, au Collège des Obstétriciens, aux Directeurs
d'établissement de l'EFS et à la SFTS. **Aucun système de gradation dans la
source** (ni GRADE, ni RAND/UCLA, ni vote chiffré, ni échelle ANAES) —
`grade` et `evidence_level` laissés NULL sur les 25 lignes, aucun grade
deviné. 25 recommandations atomiques couvrant les 4 chapitres opérationnels
du corps du texte : I. niveaux d'urgence (3 : UVI/UV/transfusion urgente),
II. surveillance immuno-hématologique de la grossesse (typage érythrocytaire
+ 4 règles RAI + identification = 6), III. organisation ES/ST/ES+ST (4+4+5 =
13), IV. évaluation et suivi (3). `population` NULL sur les 25 lignes
(document mono-population grossesse/péripartum, même convention que
`preeclampsie`/0038 et `urgences_obstetricales`/0057).

**Incohérence de métadonnées disclosurée** (déjà documentée dans la fiche
source elle-même) : l'index `library_final.json` de rfe-sfar-website
intitule cet item « Hémorragies du post-partum immédiat » avec
`exact_date: "2014"` et `exact_type: "RFE"`, alors que le contenu réel de
CE MÊME document (correspondance href/pdf-url vérifiée unique) est daté
2000-2001, n'est pas une RFE gradée mais des conclusions de table ronde en
prose continue, et la page qui l'héberge affiche un `datePublished` 2015.
`documents.publication_date` est laissé NULL plutôt que de choisir
arbitrairement entre ces dates incompatibles ; le détail complet des trois
dates est conservé dans `grading_system` et dans les commentaires en tête du
fichier de migration. `freshness_status` mis à `revision_detectee` (même
convention que `hsa`/0023, `eclsa`/0019, `glycemie`/0022,
`voies_aeriennes_adulte`/0060).

**Volontairement pas migrés en recommandations distinctes** (disclosure,
pas un oubli — détail complet dans les commentaires de tête du fichier de
migration) : le panneau contextuel « Deux types de risque » (cadrage, pas
une proposition actionnable) ; le Tableau I (arbre décisionnel de la
procédure d'urgence vitale — protocole opérationnel sans tag de force
individuel, déjà couvert par R01-R03 et R14-R17, même traitement que les
algorithmes déjà exclus dans `voies_aeriennes_enfant`/0059,
`intubation_difficile_adulte`/0027, `intubation_reanimation`/0028,
`traumatisme_vertebromedullaire`/0056) ; la « Liste des items — procédure
générale » (15 items, cahier des charges de spécification, pas 15
propositions cliniques individuellement sourcées — **À VÉRIFIER** : un
relecteur pourrait juger que ces 15 items méritent d'être migrés comme
recommandations additionnelles R26-R40 dans une migration de suivi).

**Testé par exécution réelle** contre PostgreSQL 16 local (`schema.sql` +
`schema_v2.sql` + les 61 migrations 0001-0061 rejouées dans l'ordre sans
erreur, avec un stub minimal `auth.users`/`auth.uid()` pour satisfaire les
dépendances de `schema.sql` en dehors de l'environnement Supabase réel ;
total recommandations en base après coup : 2708, soit exactement 2683 + 25)
et **idempotence vérifiée par ré-exécution** de
`0061_migrate_urgences_transfusionnelles_obstetricales.sql` seule (4×
`INSERT 0 0`, aucune ligne dupliquée, comptes inchangés). `document_societies`
(SFAR seule) et `document_specialties`
(`anesthesie_reanimation`/`gynecologie_obstetrique`/`hematologie`) vérifiés
en base après migration.

**À VÉRIFIER** (voir aussi les commentaires en tête du fichier de migration,
plus détaillés) :
1. EFS (auteur principal), Collège des Obstétriciens et SFTS (co-
   destinataires pour avis) ne figurent pas dans le seed Annexe B — seule la
   SFAR est liée en `document_societies`, même traitement que `ecbu`/0002.
2. R08 (surveillance RAI en post-partum) reproduit un point que la source
   elle-même qualifie d'insuffisamment documenté (« à confirmer par une
   étude prospective ») — reproduit tel quel, ni renforcé ni affaibli.
3. La « Liste des items » (15 items, voir ci-dessus) : décision de ne pas la
   migrer comme recommandations distinctes, à confirmer par un relecteur
   humain.

### Fiche 60 — `voies_aeriennes_adulte` (`0060_migrate_voies_aeriennes_adulte.sql`, ajoutée 2026-09-11)

SFAR, Conférence de Consensus, Recommandations du Jury, texte court, 2002
(publié Ann Fr Anesth Réanim 2003;22:745-749), label de qualité Anaes. 53
recommandations atomiques (grade A à E, échelle ANAES à axe unique
explicitement définie par la source — ni GRADE 1+/2+, ni RAND/UCLA — 2×A,
1×B, 10×C, 14×D, 26×E, reconciliation exacte via script Python dédié
contournant un piège de coupure de ligne PDF). `evidence_level` NULL sur
les 53 lignes (axe unique, pas de second axe Preuve/Force séparé dans cette
source, à la différence de `asthme_aigu_grave`/0013 ou `civd`/0015).
`population` NULL sur les 53 lignes (document mono-population adulte,
pédiatrie explicitement exclue au niveau document). Seule la SFAR liée en
document_societies ; seule `anesthesie_reanimation` liée en
document_specialties. `freshness_status` mis à `revision_detectee` (source
de 2002/2003, le contenu construit disclose lui-même l'évolution des
pratiques depuis) malgré `library_final.json` "en vigueur" — même pattern
que `hsa`/0023, `eclsa`/0019, `glycemie`/0022.

**Testé par exécution réelle** contre PostgreSQL 16 local (schema.sql +
schema_v2.sql + les 60 migrations 0001-0060 rejouées dans l'ordre sans
erreur ; total recommandations en base après coup : 2683, soit exactement
2630 + 53) et **idempotence vérifiée par ré-exécution** de
`0060_migrate_voies_aeriennes_adulte.sql` seule (4× `INSERT 0 0`, aucune
ligne dupliquée, comptes inchangés).

**À VÉRIFIER** (voir aussi les commentaires en tête du fichier de
migration lui-même, plus détaillés) :
1. Deux cellules du contenu construit (Q4.15 lidocaïne/esmolol, Q5.10 LMA/
   tube laryngé) associaient un énoncé gradé et un aside contextuel NON
   gradé par la source dans la même cellule — seul l'énoncé gradé est migré
   (R31, R41), l'aside non gradé n'est pas repris comme ligne séparée.
2. **Divergence découverte le même jour, documentée dans
   `rfe-sfar-website/CLAUDE.md` (section "KNOWN DRIFT")** : le site publié
   (Artifact) contenait déjà, au moment de cette migration, une fiche
   `voies_aeriennes_adulte` construite indépendamment pour ce même document
   par une session non tracée dans le git de rfe-sfar-website (même URL
   source, même tally 53/2A-1B-10C-14D-26E) — cette migration-ci utilise le
   contenu de CE dépôt (`content_voies_aeriennes_adulte.json`, construit et
   audité dans la session qui a écrit cette migration), pas celui du site
   publié. Un relecteur pourrait vouloir comparer les deux versions avant
   toute publication `active` de ces recommandations. Plus largement, le
   site publié a 69 clés `FICHE_HREF_MATCH` contre 60 dans ce dépôt au
   moment de cette migration (9 fiches vivent uniquement sur le site
   publié, sans aucune trace git ni migration correspondante) — une
   reconciliation dédiée est nécessaire avant de considérer "60/160" comme
   le compte réel de fiches disponibles pour la Tâche 1.

### Points laissés `-- À VÉRIFIER` dans ces 10 migrations (à trancher par un relecteur humain)

- `ecbu` : `library_final.json` et le contenu déjà audité de la fiche citent
  deux URL PDF différentes (dates de fichier différentes) — celle
  effectivement lue/auditée a été retenue, à confirmer.
- `ecbu` : la synthèse source numérote ses recommandations sur 3 pistes
  indépendantes (Q1/Q2/Q3) redémarrant chacune à R1 (pas une collision) ;
  R5(Q2) est absent sans explication dans la source (gap reproduit tel quel).
- `ecbu` : document élaboré par l'AFU/CIAFU (SFAR seulement co-signataire
  relais) — AFU/CIAFU/AFUF/SF2H/SFM/Renaloo/Le Lien ne sont pas dans le seed
  Annexe B ; non ajoutées pour ne pas fabriquer de lignes `societies` hors du
  périmètre validé.
- `transport_intrahospitalier` : seule SFAR est liée en `document_societies`
  (SRLF/SFMU co-signataires mais absentes d'une entrée Annexe B distincte
  pour ce document précis).
- `mort_encephalique` : voir aussi les disclosures déjà présentes dans
  `rfe-sfar-website/build/fiche_mort_encephalique.py` (méthodologie RAND/UCLA,
  décimales françaises `7,5`/`8,5`, anomalie de cotation de la source) —
  reproduites à l'identique dans la migration, pas ré-argumentées ici.
- `aap_urgence` : même divergence d'URL source que `ecbu` (URL `library_final.json`
  différente de celle citée par le contenu déjà audité) — celle du contenu
  audité retenue, à confirmer. GIHP/GFHT (auteurs principaux) non liés en
  `document_societies` (absents de l'Annexe B, seule SFAR co-signataire liée).
  Figures 1/2 et leur tableau récapitulatif ne sont pas remigrés séparément
  (reformulation en schéma de propositions déjà chipées ailleurs).
- `aap_programmee` : divergence source-interne disclosée — le résumé du
  document annonce "toutes [les propositions] sauf une" en accord fort, mais
  aucune exception n'est identifiable dans le corps du texte (34/34 taguées
  "Fort") ; les deux faits sont reproduits sans résolution silencieuse. Une
  note sur le ticagrélor (pontage semi-urgent) apparaît deux fois dans la
  source, chipée une seule des deux fois — seule l'occurrence chipée est
  migrée (R34). Panneau "Absence de proposition" (dose de charge anti-P2Y12)
  volontairement pas migré (aucune proposition réelle à porter). Même
  restriction `document_societies` que `aap_urgence` (GIHP/GFHT non liés).
- `allergie_prevention` : texte narratif (Sfar/SFA, 2011) SANS aucun chip de
  grade par recommandation — grade/evidence_level laissés NULL sur les 47
  lignes (disclosure explicite déjà faite par le contenu construit lui-même :
  recherche exhaustive de "Grade A/B/C"/"accord professionnel" dans la
  source = aucune occurrence ; les NP1-4 qualifient un constat de
  l'argumentaire, jamais la force d'une recommandation, donc conservés
  seulement en citation inline dans `statement`, jamais promus en
  `evidence_level`). Méthode d'atomisation différente des 5 fiches
  précédentes : chaque repère "Sx.x.x" officiellement numéroté par la RFE
  source = 1 recommandation atomique, quelle que soit sa forme grammaticale
  (y compris les items purement définitionnels S4.1.1-S4.1.5, "patients à
  risque" — un relecteur pourrait préférer les modéliser en critères de
  `population` plutôt qu'en recommandations séparées, choix non tranché
  unilatéralement ici) ; le reste (prose sans repère Sx.x.x) suit les
  marqueurs directifs que le contenu construit énonce lui-même
  ("il faut"/"il est recommandé de"/"il ne faut pas"/"il n'y a pas lieu
  de"...). Question 6 (traitement du choc) délibérément PAS migrée : le
  contenu construit la présente lui-même comme un résumé avec renvoi vers
  `Fiche_SFAR_Anaphylaxie_2025.pdf` (fiche `anaphylaxie`, pas encore
  migrée) qui la couvre intégralement — à extraire de cette source-là le
  moment venu, pas d'un résumé paraphrasé. SFA (co-auteur) non liée en
  `document_societies` (absente de l'Annexe B, même cas que GIHP/GFHT).
- `anemie` : divergence source-interne disclosée — le résumé de la RFE
  annonce "3 grade élevé, 4 grade faible et 2 avis d'experts" (somme = 9),
  un comptage direct des 10 grades littéraux donne 3 Grade 1 + 4 Grade 2 +
  3 avis d'experts (total correct de 10, cohérent avec "10 recommandations
  formalisées" annoncé par ailleurs) — reproduit tel quel, pas réconcilié
  arbitrairement. R3.4 ("Absence de recommandation", vitamines) PAS migrée
  (même traitement que le panneau homologue de `aap_programmee`). Figure 1
  (cibles d'Hb par contexte clinique) PAS remigrée en recommandations
  supplémentaires : le contenu construit précise lui-même que ses
  fourchettes sont "volontairement approximatives", pas des seuils exacts,
  sauf R2.1/R2.2 (déjà migrées). SFTS/SFVTT (co-autrices) non liées en
  `document_societies` — SFAR ET SRLF, elles, sont toutes deux dans le seed
  Annexe B et donc bien liées (contrairement aux lots précédents où un seul
  co-signataire y figurait).
- `anaphylaxie` : fiche compagnon de `allergie_prevention` (0006), RFE SFAR/
  SFA 2025 — première fiche de ce projet où j'ai dû chercher les repères
  "Rx.y" au-delà des seuls tableaux "Réf. | Recommandation | Grade" : R4.1
  (échelle de Ring & Messmer modifiée) est noyée dans un paragraphe de prose
  entre R4.0 (légende) et le tableau de R4.2 — recherche exhaustive de tous
  les repères Rx.y du texte source effectuée avant d'écrire le script pour
  ne pas la manquer. 62/70 recommandations de la RFE migrées (le reste du
  Champ 3, prévention programmée au-delà de R3.4/R3.5, hors périmètre de
  cette fiche — non couvert par le contenu construit lui-même). SFA non liée
  en `document_societies` (même cas que `allergie_prevention`). Question 6
  de `allergie_prevention` (traitement, actuellement résumée avec renvoi)
  pourrait être enrichie/reliée à cette migration-ci lors d'une prochaine
  passe de relecture éditoriale — pas fait automatiquement ici pour ne pas
  modifier une migration déjà commitée sans relecture humaine.
- `antibioprophylaxie` : fiche limitée au Champ 1 (11 recommandations
  générales) — les Champs 2-3 (18 tableaux disciplinaires de posologie par
  procédure, ~85 pages) sont explicitement hors périmètre du contenu
  construit lui-même (pas des recommandations narratives, des tableaux de
  référence au cas par cas). `library_final.json` contient 3 entrées
  distinctes pour ce document (2023, 2018, 2017), toutes marquées
  "en vigueur" — seule celle de 2023 (dont l'historique de versions propre
  va jusqu'à V3.1 2026-07-10) a été utilisée ; les 2 autres semblent des
  versions obsolètes non nettoyées de l'index, signalé pour le mainteneur
  de `library_final.json`, pas résolu unilatéralement ici. SFAR ET SPILF
  liées en document_societies (les deux dans le seed Annexe B) ; les 32
  autres sociétés co-signataires n'y figurant pas, non liées.
- `antibiotherapie_probabiliste` : conférence d'experts 2004, AUCUN grade ni
  niveau de preuve associé à une proposition individuelle nulle part dans le
  document (vérifié par lecture exhaustive) — grade/evidence_level NULL sur
  les 37 lignes, cas encore plus radical que `allergie_prevention` (qui, elle,
  conservait des citations NP ponctuelles). Tableau final de posologies
  génériques (24 lignes, Famille/Antibiotique/Posologie/Voie) volontairement
  pas migré (référence pharmacologique, pas des recommandations
  situationnelles). SFAR, SRLF, SPILF ET SFMU toutes liées en
  document_societies (4 sociétés du seed Annexe B citées sous leur nom
  complet par le contenu construit — le cas le plus favorable rencontré
  jusqu'ici dans cette migration). Document de 2004 : un relecteur humain
  devrait vérifier l'existence d'une actualisation plus récente avant
  publication (écologie bactérienne évolutive), disclosure volontaire.
- `anticoag_urgence` : 91 recommandations extraites des tableaux, mais le
  décompte annoncé par la RFE est 102 — écart d'abord non expliqué par le
  contenu construit. Investigation complémentaire faite ici (téléchargement
  et lecture directe du PDF source, pas une supposition) : les 9 items
  manquants sont tous des recommandations-pointeurs "les experts suggèrent
  d'utiliser l'algorithme suivant (figure N)", dont le contenu clinique réel
  est décomposé par les items numérotés suivants (déjà migrés) — même
  logique d'exclusion que les figures-résumés d'autres RFE de ce corpus,
  mais vérifiée ici contre le texte source plutôt que déduite. 1 "Absence de
  recommandation" et 1 phrase d'argumentaire (pas un item séparé) complètent
  la reconciliation exacte (91+9+1+1=102). SFAR ET SFMU liées en
  document_societies ; GIHP et SFTH non liés (hors seed Annexe B).
- `anticoagulants` : fiche compagnon de `anticoag_urgence` (procédure
  programmée vs urgence). ~20 tableaux "Annexe — Classification du risque
  hémorragique par spécialité" (radiologie interventionnelle, rhumatologie,
  cardiologie, chirurgie thoracique/orale/ORL, endoscopie, viscérale,
  proctologie, gynéco, urologie, plastique, orthopédie, neurochirurgie)
  volontairement pas migrés : ce sont des tables de classification d'actes
  par risque, sans chip de grade propre — la décision clinique elle-même
  reste portée par les 64 recommandations migrées. Deux tableaux à cellules
  fusionnées (rowspan visuel : colonne Molécule/Stade IRC vide sauf sur la
  première ligne d'un groupe) reconstruits en reportant le dernier libellé
  non vide sur chaque ligne, pour que chaque `statement` migré reste
  autoporteur — la structure de groupement vient du contenu construit,
  seule la mise en phrase complète est de mon fait. Colonne "Accord"
  (niveau de consensus du vote, Fort/Faible) conservée en citation inline
  dans `statement`, jamais fusionnée dans `grade` (deux informations
  différentes de la source). SFAR, SFC ET CNGOF liées en document_societies
  (3 sur les ~27 sociétés co-signataires citées, les autres hors seed
  Annexe B) ; GIHP (coordonnateur principal) non lié.
- `asthme_aigu_grave` (SRLF, révision 2002 d'une Conférence de Consensus
  1988) : 62 recommandations. Grille SRLF à DEUX axes réellement distincts —
  "Preuve" (a>b>c>d, niveau de preuve de la référence) et "Force" (1>2>3,
  niveau de recommandation, imprimé seulement quand le jury l'a jugé
  possible) — première fiche du corpus migrée avec `grade` ET
  `evidence_level` tous deux renseignés distinctement (Force -> grade,
  Preuve -> evidence_level), au lieu d'un seul champ ou de citations
  inline. `grade` NULL quand la Force n'est pas imprimée ("—" dans la
  source), jamais déduit de la Preuve. Document de 2002 : le contenu
  construit disclose lui-même que les pratiques ont évolué depuis (place
  élargie du sulfate de magnésium) — à vérifier par le relecteur humain.
- `choc_hemorragique` (SFAR/SRLF/SFMU/GEHT, RFE 2014/2015) : 29
  recommandations extraites de 24 numéros de référence source (4 numéros
  portent chacun plusieurs lignes à grades DIFFÉRENTS et contenu distinct,
  ex. réf. 15 : traumatisé 1+, non-traumatisé 2+, négative au-delà de la
  3e heure 1- — pas des doublons, donc pas fusionnées, désambiguïsées en
  1a/1b/15a/15b/15c/etc. dans `source_section`). **Bug méthodologique
  trouvé et corrigé pendant cette migration** : le script Python
  d'extraction utilisé depuis `anaphylaxie` (0008) avait une regex de
  nettoyage HTML trop permissive (`<[^>]+>`) qui, en présence d'un texte
  source contenant un opérateur "<" suivi plus loin d'un ">" SANS balise
  HTML réelle entre les deux (ex. "objectif INR < 1,5 ... si INR > 1,5"),
  supprimait silencieusement tout le texte entre les deux comme si
  c'était une balise. Trouvé sur 1 ligne de cette migration (réf. 23,
  CCP/vitamine K) pendant la relecture, corrigé avant commit par une
  regex qui ne cible que les balises HTML réellement utilisées dans ce
  corpus (b/i/br/sup/sub/u). **Audit rétroactif fait sur toutes les
  migrations précédentes construites par script** (`anaphylaxie` 0008,
  `antibiotherapie_probabiliste` 0010, `anticoag_urgence` 0011,
  `anticoagulants` 0012) par re-extraction et diff contre le SQL déjà
  commité : aucune n'était affectée (le motif "< N ... > N" sans balise
  entre les deux ne s'était par chance jamais produit ailleurs) — pas de
  correctif rétroactif nécessaire sur les migrations déjà poussées.
  **Pour toute prochaine extraction scriptée** : utiliser une regex de
  nettoyage HTML qui ne cible que des noms de balises connus, jamais
  `<[^>]+>` seul.
- `civd` (SRLF, CC 2002, avec SFAR/GEHT/GFRUP) : 22 recommandations, même
  grille SRLF à deux axes (Preuve/Force) que `asthme_aigu_grave` (0013),
  même convention de migration (Force -> grade, Preuve -> evidence_level).
  Décompte du contenu construit ("22 énoncés cotés") exactement reconcilié
  avec les 22 lignes migrées, aucune divergence. Tableau des critères de
  consommation majeurs/mineurs et organigramme de stratégie thérapeutique
  (reconstruit par le contenu construit depuis un rendu visuel à 200dpi,
  "texte scramblé par l'extraction automatique" sur cette page-là)
  volontairement pas migrés (référence/algorithme, contenu déjà couvert
  par les recommandations textuelles). SRLF et SFAR liées en
  document_societies ; GEHT et GFRUP non liés (hors seed Annexe B).
- `controle_temperature` (SRLF/SFAR + ANARLF/GFRUP/SFMU/SFNV, RFE 2016) :
  30 recommandations (24 adulte + 6 pédiatriques dédiées). Particularité
  de notation disclosée par le contenu construit et vérifiée par
  inventaire exhaustif des tags : cette source n'imprime JAMAIS de
  suffixe "-" — le sens négatif d'une recommandation ("il ne faut
  probablement pas...") est porté par le texte du `statement`, jamais par
  le grade (donc grade '2', jamais '2-', dans ce document précis — à ne
  pas confondre avec un oubli). Décompte du contenu construit ("30
  recommandations", répartition 3/13/14 par force) exactement reconcilié.
  SRLF, SFAR ET SFMU liées en document_societies (toutes trois dans le
  seed) ; ANARLF/GFRUP/SFNV non liées.
- `corticotherapie` (SFAR, CC 2000, avec SPILF/SPLF/GFRUP) : 18
  recommandations. Cotation à deux axes INDÉPENDANTS non-GRADE, imprimée
  comme un chip COMPOSITE unique par la source elle-même ("1a", "2b"...) —
  décomposé proprement en `grade` (partie chiffrée) et `evidence_level`
  (partie lettrée), pas un grade composite fabriqué (la légende de la
  source nomme explicitement les deux axes). "N.C." (non coté, anomalie
  disclosée par le contenu construit pour Q4 et l'énoncé 5.5) -> les deux
  champs NULL. SFAR et SPILF liées en document_societies.
- `curares` (SFAR, RFE 2018, actualisation de la CC SFAR 1999) : 33
  recommandations. Décompte source ("33 recommandations numérotées, R1.1
  à R8.14") exactement reconcilié par recherche exhaustive de tous les
  repères Rx.y (aucun absent des tableaux — ma première estimation
  manuelle de 30 lignes était une erreur de comptage à la lecture du
  résultat intermédiaire, corrigée avant écriture du fichier final).
  2 algorithmes de décurarisation et 2 tableaux de posologie
  (sugammadex/succinylcholine enfant) volontairement pas migrés
  (référence/algorithme). Seule la SFAR organise cette RFE — liée seule.
- `eclsa` (9 sociétés dont SFAR/SFMU/SFC/SRLF, Ann Fr Anesth Reanim 2009) :
  12 recommandations — **CAS PARTICULIER DE CE CORPUS**, à relire en
  priorité. Ce document est en PROSE CONTINUE, SANS GRADE, SANS
  numérotation R1/R2, SANS aucun tableau "Réf. | Recommandation | Grade" :
  une seule mention de niveau de preuve imprimée pour tout le texte
  (« niveau 5 », avis d'experts), reproduite comme `grade = 'AE'` sur
  chacune des 12 lignes (un seul grade global, pas un grade composite
  fabriqué). Contrairement aux précédents de ce corpus (aap_urgence,
  aap_programmee, anticoagulants, curares, civd) où un algorithme/figure a
  été exclu parce que son contenu était redondant avec des recommandations
  déjà graduées ailleurs, ici l'algorithme décisionnel (Fig. 1, 3
  colonnes "Indication possible / Incertitude / Pas d'indication") EST la
  seule source de critères cliniques concrets de tout le document — décision
  prise de le convertir fidèlement en recommandations déclaratives (R01-R06)
  plutôt que de ne migrer aucune recommandation clinique exploitable pour ce
  document. R05 documente une exception disclosée par la source elle-même
  (seuil low-flow > 100 min non contre-indicatif en cas d'intoxication par
  cardiotrope). `freshness_status` mis à `revision_detectee` (et non
  `a_jour`) à cause de l'avertissement de la source sur les essais ECPR
  modernes postérieurs (ARREST 2020, PRAGUE-OHCA 2022, INCEPTION 2023) —
  alors que `library_final.json` indique lui `"status": "en vigueur"`,
  divergence disclosée, à trancher par un relecteur humain. Seules SFAR,
  SFMU, SFC et SRLF (sur les 9 sociétés co-signataires de la source) sont
  dans le seed Annexe B — les 5 autres (Conseil français de réanimation
  cardiopulmonaire, SFCTCV, Société française de pédiatrie, GFRUP, Société
  française de perfusion) non liées, absentes du seed.
- `eer` (SRLF, avec SFAR/GFRUP/SFD, Réanimation 2014) : 78 recommandations.
  Encore une convention de cotation propre à ce corpus : analyse littérature
  GRADE mais cotation COLLECTIVE RAND/UCLA (chip « Fort »/« Faible » de force
  du consensus, PAS un synonyme des tags GRADE 1+/2+ utilisés ailleurs —
  `grade` reproduit littéralement 'Fort'/'Faible', pas de conversion
  inventée). Décompte du contenu construit ("78 recommandations numérotées
  au total") exactement reconcilié : les 63 lignes du tableau classique
  "Réf. | Recommandation | Accord" (champs 1-4.2) + les 15 items du champ
  4.3 (tableau "Étape | Recommandations" à puces, SANS repères Rx.y.z
  individuels dans le contenu construit — migrés avec disclosure explicite
  de cette perte de numérotation plutôt qu'une correspondance inventée) =
  78, correspondance exacte. Les 15 items du champ 4.3 étaient des fragments
  télégraphiques à la source ("deux personnes pour réaliser le
  branchement...") reformulés en phrases complètes "Il faut..." pour rester
  cohérents avec le style du reste du document (disclosure : complétion
  grammaticale, aucun contenu ajouté). **Collision d'acronyme détectée et
  disclosée** : la source cite une société co-participante « SFD (Société
  francophone de dialyse) » — le seed Annexe B contient déjà un acronyme
  'SFD' mais sans `full_name`, très probablement une société différente
  (Société Française de Diabétologie, plus probable dans le contexte de ce
  corpus) ; PAR PRUDENCE, non liée dans cette migration (ni GFRUP, absent du
  seed) — seules SRLF et SFAR liées en document_societies. Titre du document
  divergent de `library_final.json` (qui dit "continue... à l'exclusion de
  la dialyse péritonéale" alors que la source couvre continue+intermittente
  ET un champ dédié dialyse péritonéale) — titre de la source retenu,
  divergence disclosée.
- `epanchement_pleural` (SFAR, avec SFMU/SPLF/SFCTCV, RPP 2023) : 25
  recommandations, RPP (pas RFE) — méthode GRADE grid utilisée pour le
  vote, mais AUCUNE recommandation graduée numériquement faute de
  littérature ; toutes cotées « AE » (avis d'experts) avec accord FORT sans
  exception après 4 tours de cotation. Décompte source ("25 recommandations
  réparties en 4 champs") exactement reconcilié. 3 items « Absence de
  recommandation » (drainage vs ponction, position du patient, temps du
  cycle respiratoire au retrait sous VM) volontairement pas migrés — les
  experts déclarent explicitement ne pas pouvoir statuer, faute de
  données. Tableau de référence posologique "anticoagulants avant drainage"
  (7 lignes par molécule) pas migré séparément — déjà couvert par R14
  (Réf. R2.4.3). **Incohérence interne à la source disclosée sans être
  résolue** : résumé source "15 experts" vs comptage direct des 4 listes
  nominatives imprimées = 16 noms (SFAR 9 + SFCTCV 3 + SFMU 2 + SPLF 2) —
  les deux chiffres reproduits, aucun tranché. Champ hors pleurésie
  purulente/hémothorax/néoplasique et hors pédiatrie (disclosé au niveau
  document). SFAR et SFMU liées en document_societies (SPLF/SFCTCV hors
  seed).
- `glycemie` (Sfar/SRLF + Alfediam/Adarpef/Gefrup/Sbar/SFNEP/SIZ, RFE 2009) :
  74 recommandations. Encore un système à deux axes indépendants, propre à
  cette fiche (documenté en détail dans `fiche_glycemie.py` côté
  rfe-sfar-website) : NGP (Niveau Global de Preuve : Fort/Modéré/Faible) et
  Accord (Fort/Faible + 1 « Indécision »), jamais fusionnés — la source dit
  explicitement qu'un accord fort est possible avec un NGP faible et
  inversement. Convention retenue : Accord -> `grade`, NGP ->
  `evidence_level` (même logique que asthme_aigu_grave/civd Force/Preuve).
  Décompte exactement reconcilié avec les "74 recommandations" que la
  source annonce (champs 5-10 ; champs 1-4 = physiopathologie, "ne
  pouvaient pas faire l'objet de recommandations avec de vraies cotations"
  dixit la source, non migrés). **2 anomalies source-internes confirmées
  par lecture directe du PDF et disclosées, non résolues silencieusement** :
  (1) 1 recommandation (Champ 7, mesure en SSPI) sans AUCUNE cotation
  imprimée — grade/evidence_level NULL plutôt qu'inventés ; (2) 1
  recommandation (Champ 8, arrêt insuline IV) porte un tag "(accord
  modéré)" alors que la méthodologie déclarée ne définit que fort/faible
  pour cet axe — reproduit littéralement (`grade = 'Modéré'`), pas forcé.
  Document de 2009 : la source elle-même avertit que les cibles
  glycémiques ont évolué depuis — `freshness_status = 'revision_detectee'`
  malgré `library_final.json` "en vigueur" (même pattern que eclsa/0019).
  Seules SFAR et SRLF liées en document_societies (6 sociétés partenaires
  hors seed).
- `hsa` (SFAR, avec ANARLF/neurochirurgie/neuroradiologie, CE 2004) : 60
  recommandations. Conférence d'experts (pas GRADE), motivée par la source
  elle-même par le faible niveau de preuve disponible. Grades A/B/D/E
  imprimés par le jury (aucune occurrence de Grade C) — **A et B définis
  littéralement par le texte court (preuve forte / présomption
  scientifique), D et E NON définis** (le texte court n'en donne nulle
  part la signification, probablement présente dans l'argumentaire
  scientifique complet non disponible pour cette fiche) : disclosure
  explicite plutôt qu'une définition devinée, `grade` reproduit
  littéralement la lettre source. Comptage source ("2×A, 1×B, 10×D, 48×E"
  = 61 occurrences textuelles) reconcilié avec les 60 lignes migrées :
  écart d'une occurrence expliqué par une 2e mention de "Grade D" dans le
  panneau de champ d'application (hors tableau de recommandations), pas
  une ligne manquante. 4 tableaux de classification de référence (WFNS,
  Hunt et Hess, Fisher, index bicaudé) volontairement pas migrés
  (échelles cliniques établies, pas des recommandations graduées par le
  jury). Conférence de 2004, source avertit elle-même de se référer aux
  pratiques plus récentes — `freshness_status = 'revision_detectee'`
  malgré `library_final.json` "en vigueur". Seule la SFAR liée en
  document_societies (3 sociétés partenaires hors seed).
- `hyperthermie_maligne` (SFAR, RPP 2019, remplace la RFE 2013 abrogée) : 11
  recommandations, toutes « AE » (avis d'experts, seule cotation de ce
  document). **Écart de comptage disclosé, non résolu silencieusement** :
  le contenu construit annonce "12 recommandations" en introduction, mais
  un parcours exhaustif programmatique de tous les repères Rx.y du JSON
  (pas seulement les tableaux visibles) n'en trouve que 11 — les deux
  chiffres reproduits dans le fichier de migration, aucune ligne inventée
  pour atteindre 12. Volontairement pas migrés : la reconstruction
  "Situation | Conduite à tenir" de la Figure 1 (arbre décisionnel, pure
  image source, déjà reformulée par le contenu construit "pour la
  lisibilité"), le protocole "Annexe 2" de traitement de la crise (15
  étapes) et le protocole de reconstitution du dantrolène (7 étapes) — tous
  trois transcrits depuis des affiches-photos SANS chip de cotation
  individuelle, donc des protocoles opérationnels non gradués un par un,
  pas des recommandations RPP au sens de ce modèle (contrairement à
  `eclsa`/0019, où exclure l'algorithme aurait réduit la migration à zéro :
  ici 11 recommandations graduées existent indépendamment). Seule la SFAR
  liée en document_societies.
- `hypothermie` (SFAR, RFE 2018, 1re RFE française sur le sujet) : 14
  recommandations, GRADE classique (1+/1-/2+/2-/AE). Décompte source ("5
  Grade1 + 7 Grade2 + 2 avis d'experts") exactement reconcilié. **R14
  (« Proposition de stratégie », synthèse en 3 phases Accueil/Per-anesthésie/
  SSPI) est explicitement numérotée et comptée par la source elle-même comme
  la 14e recommandation** (2e avis d'experts) bien que rendue sous forme de
  tableau de synthèse plutôt qu'une phrase isolée — migrée comme un seul
  `statement` narratif renvoyant aux recommandations R3/R4/R6/R7/R8/R12/R13
  qu'elle synthétise, sans contenu nouveau ajouté. Disclosure ponctuelle (pas
  systématique) : R8 est la seule des 14 recommandations avec un « Accord
  faible » malgré son grade GRADE 2+ — notée dans son propre
  `source_section`, pas un axe `evidence_level` extrait pour tout le
  document (la source ne l'imprime pas ligne à ligne, à la différence de
  glycemie/eer). Question 8 (réchauffement des fluides gazeux, aucun
  consensus atteint) volontairement pas migrée. Seule la SFAR liée en
  document_societies.
- `ih` (SFAR/AFEF, RFE 2018) : 19 recommandations, GRADE classique. **Deux
  incohérences internes à la source disclosées, non reconciliées** : (1)
  nombre d'experts — "23" au résumé (confirmé par comptage direct des
  listes nominatives) vs "vingt" en introduction du même document ; (2)
  nombre de recommandations — "18" annoncées par une phrase du résumé, mais
  la répartition par grade imprimée dans ce même résumé (6+7+6=19)
  confirme 19, cohérent avec le comptage direct des 19 items numérotés :
  19 migrées, "18" traité comme une coquille de la source, disclosé sans
  trancher silencieusement. Accord fort à 100 % (aucune exception, à la
  différence de hypothermie/0025). 5 tableaux/figures de référence
  (symptomatique IHA, algorithme IHA sévère, KDIGO modifié cirrhotique +
  algorithme IRA, définition SHR, CLIF-SOFA + grade ACLF) volontairement
  pas migrés (classification/algorithme, pas des recommandations
  graduées). Question 9 (thromboprophylaxie médicamenteuse, aucun
  consensus) pas migrée. AFEF hors seed — seule la SFAR liée en
  document_societies.
- `intubation_difficile_adulte` (SFAR, RFE 2017, actualise la CE 2006) : 13
  recommandations, GRADE classique (5×1+, 8×2+). Décompte source ("13
  recommandations ; 5 Grade1, 8 Grade2") exactement reconcilié. Numérotation
  source non continue (R1→R2→R4→R5→R6, pas de "R3.x") documentée par la
  source elle-même : la question 3 a abouti à « pas de recommandation »,
  pas un repère manquant. R2.3 seule exception « Accord faible » disclosée
  ponctuellement (comme hypothermie/0025 et non systématique). 5
  algorithmes-organigrammes (intubation prévue/non prévue, oxygénation de
  sauvetage, facteurs de risque et leadership d'extubation), tous
  "transcrits depuis le rendu visuel de la source (pures images)" d'après
  le contenu construit, volontairement pas migrés (synthèses opérationnelles
  des recommandations déjà graduées, sans chip individuel). Seule la SFAR
  liée en document_societies.
- `intubation_reanimation` (SFAR/SRLF, avec SFMU/GFRUP/ADARPEF/SKR, RFE
  2016) : 32 recommandations ADULTES, GRADE classique (12×1+, 19×Grade2
  incl. 1×2-, 1×AE). Décompte source ("32 recommandations ; 12 Grade1, 19
  Grade2, 1 AE") exactement reconcilié. **La source contient aussi 15
  recommandations pédiatriques parallèles, explicitement absentes du
  contenu construit lui-même** ("cette fiche, centrée sur l'adulte") — rien
  à migrer pour le volet pédiatrique, absent de la source de cette
  migration (pas un choix d'exclusion de ce fichier). R7.5 seule exception
  « Accord faible » disclosée ponctuellement. 2 tableaux de référence
  (complications de l'intubation, score MACOCHA) et 2 algorithmes de
  synthèse (IOT, extubation), tous transcrits depuis un rendu visuel de la
  source, volontairement pas migrés (mêmes critères que
  intubation_difficile_adulte/0027). SFAR/SRLF/SFMU liées en
  document_societies (GFRUP/ADARPEF/SKR hors seed).
- `intubation_urgence` (SFAR/SFMU, RFE 2025, hors bloc/hors soins
  critiques) : 28 recommandations migrées, GRADE classique. **Écart de
  comptage EXPLIQUÉ, pas une ligne manquante** : source annonce "32
  recommandations (5 Grade1, 12 Grade2, 15 AE)" ; le tableau classique ne
  compte que 28 lignes (5×1+, 12×Grade2, 11×AE) — l'écart de 4 AE
  correspond EXACTEMENT à la sous-section « Conduite à tenir en cas
  d'échec d'intubation (R4.3.1 à R4.3.4, avis d'experts, accord fort) »,
  rendue par le contenu construit sous forme de 2 algorithmes parallèles
  (Figures 3 extrahospitalier/4 intrahospitalier, ~6 étapes chacun) SANS
  qu'aucune étape ne soit rattachée à l'un des 4 repères R4.3.x — aucune
  correspondance étape→repère récupérable sans deviner, donc PAS migrées
  individuellement (disclosure plutôt qu'invention). 28+4=32, 5+12+15=32,
  reconciliation exacte vérifiée sur les deux axes. 4 questions « sans
  recommandation possible » volontairement pas migrées. SFAR et SFMU
  (toutes deux dans le seed) liées en document_societies.
- `ira` (SFAR/SRLF, avec GFRUP/SFN, RFE 2015) : 33 recommandations, GRADE
  classique (9×Grade1, 16×Grade2, 8×AE), reconciliation EXACTE confirmée
  par la source elle-même ("un comptage exact... confirme ce total,
  9+16+8=33, sans écart à signaler cette fois"). **Volet pédiatrique
  intégré directement dans les 33** (3 recommandations, repères "Rx.y P",
  `population='Pédiatrie'`) — contrairement à intubation_reanimation/0028
  où le volet pédiatrique parallèle était totalement absent de la source.
  R2.1 seule exception « Accord faible » disclosée ponctuellement, malgré
  un grade fort (1-). **Collision d'acronyme potentielle "SFN"** (même
  pattern que "SFD" dans eer/0020) : la source cite une "SFN" (Société
  française de néphrologie d'après le contexte), le seed contient déjà un
  'SFN' sans `full_name` — expansion la plus courante du sigle étant
  "Société Française de Neurologie" (différente) ; PAR PRUDENCE, non liée
  dans cette migration. 5 tableaux/figure de référence (KDIGO, pRIFLE,
  facteurs de risque, agents néphrotoxiques, schéma agression→dysfonction)
  volontairement pas migrés. SFAR et SRLF liées en document_societies.
- `lat_soins_critiques` (SFAR/SOFMER, RFE 2025, adulte uniquement) : 9
  recommandations. **Particularité disclosée par la source elle-même :
  aucun tag GRADE de ce document ne porte de signe +/-** (contrairement à
  la quasi-totalité des autres RFE du corpus) — le contenu construit avait
  lui-même inféré la polarité et ajouté un « + » "par cohérence visuelle
  avec le reste du corpus" ; cette migration s'en écarte volontairement et
  reproduit les valeurs BRUTES de la source ('1'/'2'/'AE', sans signe) pour
  rester strictement fidèle à ce qui est réellement imprimé — divergence
  disclosée par rapport au chip visuel de la fiche, pas par rapport à la
  source. Décompte source ("1 GRADE1, 2 GRADE2, 6 AE = 9") exactement
  reconcilié. R1.3/R2.1 : formulation du tableau récapitulatif amendé de la
  source retenue (légèrement différente du texte sous l'argumentaire),
  cohérent avec le choix déjà fait par le contenu construit source. 8
  figures/encadrés réglementaires et protocoles opérationnels (directives
  anticipées, personne de confiance, algorithme décisionnel, check-list de
  procédure collégiale, protocole de sédation + échelles RASS/BPS/RDOS,
  accompagnement des proches, outils de communication) volontairement pas
  migrés (non cotés individuellement par le jury). 2 absences de
  recommandation pas migrées. SOFMER hors seed — seule la SFAR liée en
  document_societies.
- `mal_epileptique` (SRLF/GFRUP/SFMU, RFE 2008) : **163 recommandations —
  document le plus volumineux du corpus à ce jour**, numérotation
  `recommendation_code` étendue à 3 chiffres (R001-R163, vs 2 chiffres
  partout ailleurs ; format `R{rang}` du projet supporte nativement la
  largeur variable). Méthode RAND/UCLA à un seul axe (Fort/Faible),
  PAS GRADE. **Divergence de comptage majeure disclosée, non résolue** : le
  panneau méthodologique source annonce 190 tags bruts (167 fort + 23
  faible) consolidés en "149 lignes (141 thématiques + 8 classification)" ;
  un parcours exhaustif et dédupliqué du contenu construit JSON (aucun
  statement dupliqué) trouve 163 lignes distinctes (155 thématiques + 8
  classification, 140 fort + 23 faible) — le compte de tags "faible" (23)
  correspond exactement au brut annoncé, mais 155 thématiques trouvées vs
  141 annoncées est un écart dans le sens INVERSE de ce qu'une
  consolidation produirait. Les 163 lignes réellement présentes dans le
  JSON de build (l'artefact faisant foi pour ce projet) sont toutes
  migrées, aucune retranchée pour forcer une correspondance à "149".
  Classification opérationnelle de l'EME (champ 1, 8 formes cliniques) :
  contrairement aux tableaux de classification purs exclus ailleurs dans
  ce corpus (WFNS/Hunt&Hess/Fisher de `hsa`/0023, sans cotation), CE
  tableau porte un tag Accord individuel par forme clinique — migré comme
  8 recommandations reformulées en phrases déclaratives (R008-R015).
  Spécificités pédiatriques repérées par le marqueur littéral "(enfant)"
  de la source, présent sur 18 lignes → `population='Pédiatrie'`.
  Document de 2008 dont la source dit elle-même littéralement (R163)
  qu'il "devra être réactualisé dans un délai maximum de trois ans" —
  échéance dépassée de 14+ ans ; `freshness_status='revision_detectee'`
  malgré `library_final.json` "en vigueur". SRLF et SFMU liées en
  document_societies (GFRUP hors seed).
- `mtev_perioperatoire` (GIHP, avec SFAR/SFTH/SFMV, RFE 2024, actualise la
  RFE SFAR 2011) : 77 recommandations, GRADE classique. **Particularité
  disclosée par la source elle-même** : les 77 recommandations sont
  TOUTES à Accord Fort — aucune Accord Faible dans tout le document
  (vérifié par recherche exhaustive), donc pas de colonne Accord/
  evidence_level distincte pour ce document. Décompte source ("77
  recommandations, 14 questions PICO, 21 sous-thèmes") exactement
  reconcilié. **3 figures (PTH/PTG, TVP distale, schéma de synthèse)
  volontairement pas migrées malgré une disclosure explicite de la source
  qu'elles portent de VRAIS grades fidèlement reproduits** (contrairement
  aux algorithmes non gradés exclus ailleurs dans ce corpus) : un examen
  ponctuel montre qu'elles restatent en arbre décisionnel du contenu déjà
  couvert par les lignes Indication/Durée/Modalités migrées, et une
  analyse bloc-par-bloc pour séparer avec certitude le nouveau du
  redondant n'a pas été menée vu le volume — disclosure explicite, décision
  documentée pour reprise ultérieure par un relecteur humain. Tableaux
  posologiques (délai neuraxial par anticoagulant, adaptation par DFG) et
  tableaux de méta-analyses chiffrées volontairement pas migrés (données
  d'argumentaire, pas des recommandations). `library_final.json` liste
  encore la RFE 2011 remplacée comme "en vigueur" — incohérence de cet
  index disclosée, hors périmètre de correction de ce projet. Seule la
  SFAR (collaboratrice) liée en document_societies.
- `nutrition` (SFAR/SRLF/SFNEP, RFE 2014) : 70 recommandations. Cotation à
  un seul axe Accord fort/faible (comme eer/0020, dont la source signale
  explicitement partager cette particularité). Force GRADE (1/2)
  déductible du verbe de l'énoncé mais jamais réimprimée séparément par la
  source — inférence de lecture, pas extraite dans un champ structuré
  (`evidence_level` NULL), même logique que le "+" de
  lat_soins_critiques/0031. **Divergence de comptage disclosée par la
  source elle-même** : résumé officiel "69 recommandations" (6 derniers
  champs) vs 71 encadrés numérotés trouvés par inventaire direct sur les
  10 champs (dont 4 encadrés des champs 1-3, décrits comme "points forts"
  non cotés par la méthodologie mais portant en pratique un vrai tag
  Accord) — aucun sous-ensemble ne correspond à "69". 1 encadré (9.3.1)
  sans tag, traité comme absence de recommandation → 71-1=70 lignes
  effectivement migrées. Tableaux de référence chiffrés (besoins
  énergétiques du brûlé, apports pédiatriques j1-j4) volontairement pas
  migrés. SFAR et SRLF liées en document_societies (SFNEP hors seed).
- `nvpo` (SFAR, CE 2008, panel international) : 53 recommandations. GRADE
  avec une convention propre : G1+/G2+/G1-/G2-, PAS de catégorie "avis
  d'experts" — 4 items "pas de recommandation possible" explicitement
  disclosés par le panel lui-même, non migrés (cohérent avec le principe
  du projet). Pas de chiffre-résumé officiel à comparer (source ne publie
  pas de total agrégé) — 53 lignes comptées directement, répartition
  vérifiée 15×1+/6×1-/22×2+/10×2-=53. 4 tableaux de référence (scores
  Apfel/Koivuranta, pharmacocinétique AR-5HT3, facteurs de risque
  pédiatriques, posologies pédiatriques) et 1 figure de stratégie par
  niveau de risque volontairement pas migrés — aucun ne porte de colonne
  Grade/Accord (contrairement à la classification EME de
  mal_epileptique/0032). Seule la SFAR liée en document_societies.
- `pancreatite` (SFAR + SNFGE/SFR/SFNCM/SFED, RFE 2021) : 24
  recommandations, GRADE (8×Grade1, 12×Grade2, 4×AE), accord fort 100 %.
  **Deux incohérences internes à la source disclosées, non résolues** :
  (1) le résumé FR et l'abstract EN annoncent tous deux "8 GRADE1/12
  GRADE2" (confirmé par tally direct), mais la section "2.2
  Recommandations" du même document annonce l'inverse "9/11" — le tally
  direct (8/12) est retenu, sans trancher laquelle des deux mentions
  internes est erronée ; (2) le texte source répète le même débit "2
  L/min" pour les paliers FiO2 25% et 30% du score de Marshall (Tableau 1,
  non migré). 4 lignes "SR" (sans recommandation) figurant littéralement
  dans la colonne "Niveau" des tableaux — plus visible que dans les autres
  fiches où l'absence de reco est hors tableau — non migrées. Figure 1
  (algorithme, image pure) et Annexe 1 (scores Balthazar) volontairement
  pas migrées. Seule la SFAR liée en document_societies.
- `pavm` (SFAR/SRLF, avec ADARPEF/GFRUP pédiatrique, RFE 2017) : 17
  recommandations (15 adultes + 2 pédiatriques dédiées, repères "Rx.y P"),
  GRADE classique. **Écart de répartition GRADE disclosé, non résolu** : le
  résumé officiel annonce "3 recommandations GRADE 1 et 11 GRADE 2" (+1 avis
  d'experts = 15 recommandations adultes) ; un inventaire direct, vérifié tag
  par tag sur les 15 lignes adultes, dénombre 4 GRADE1 (R1.1, R3.2, R3.5,
  R3.7) et 10 GRADE2 (+1 AE) — le TOTAL (15) concorde avec le résumé
  officiel, mais PAS la répartition annoncée (3+11 vs 4+10 constaté) ; chaque
  tag individuel migré est reproduit tel qu'imprimé à côté de sa
  recommandation, sans forcer la répartition au résumé erroné. La source dit
  avoir "analysé" 4 populations spécifiques (BPCO, neutropénie,
  postopératoire, pédiatrie), mais seules BPCO (R1.5) et pédiatrie (R1.1 P,
  R2.2 P) ont donné lieu à des recommandations numérotées propres —
  neutropénie/postopératoire n'ont informé que l'argumentaire d'autres
  recommandations, rien à migrer pour ces deux-là (cohérent avec le contenu
  réel de la source, pas une omission). 4 "protocoles de soins" (avis
  d'experts au niveau du protocole global d'après le résumé officiel
  lui-même, PAS une cotation individuelle ligne par ligne) volontairement pas
  migrés : Protocole n°1 (Figure 1, prévention multimodale) ; Protocole n°2
  (décontamination digestive sélective) et son Tableau III associé
  (préparation officinale — **incohérence interne à la source disclosée** :
  "tobramycine" dans le texte du protocole vs "gentamicine" dans la recette
  du Tableau III, non résolue) ; Protocole n°3 (Figure 2, procédure
  diagnostique) ; Protocole n°4 (Tableau IV, schémas thérapeutiques par
  situation clinique). Tableau I (critères de définition, pas une
  recommandation graduée) également pas migré. SFAR et SRLF (toutes deux
  dans le seed) liées en document_societies ; ADARPEF et GFRUP
  (collaborateurs pédiatriques) hors seed, non liés.
- `preeclampsie` (SFAR/CNGOF, RFE 2020) : 27 recommandations, GRADE
  classique. **Écart de comptage disclosé, isolé précisément, non résolu** :
  le résumé officiel annonce "25 recommandations (8 GRADE1, 9 GRADE2, avis
  d'experts pour le reste)". Un inventaire direct tag par tag trouve bien
  8 GRADE1 et 9 GRADE2 (sous-totaux EXACTEMENT concordants avec le résumé),
  mais 10 avis d'experts (AE) au lieu des 8 implicitement attendus
  (25-8-9=8) — l'écart de 2 correspond précisément à R1.1 et R1.2 (Champ 1,
  définition de la pré-éclampsie sévère et de son aggravation), deux items
  à tag AE individuel et distinct dans le contenu construit, hypothèse
  plausible mais non vérifiable qu'ils aient été comptés comme une seule
  entrée définitionnelle par le résumé officiel — les 27 lignes réellement
  taguées sont toutes migrées, aucune retranchée pour forcer 25. Les 3
  "questions sans recommandation possible" annoncées, elles, sont
  exactement reconciliées (fullPIERS/Champ 1, échographie thoracique/
  Champ 3, simulation-aides cognitives/Champ 7). **Supersession disclosée,
  non résolue** : la source dit se substituer aux recommandations SFAR/
  CNGOF antérieures sur le même champ, mais `library_final.json` liste
  encore une RFE 2009/2010 distincte ("formes graves de prééclampsie")
  comme "en vigueur" — incohérence de cet index signalée, pas corrigée
  unilatéralement (même pattern que mtev_perioperatoire/0033). Algorithme
  de prise en charge de l'HTA (Champ 2, synoptique à 2 colonnes sans chip
  propre, restatement de R2.1-R2.7) et rappel posologique du sulfate de
  magnésium volontairement pas migrés. `population` laissée NULL sur les
  27 lignes : l'intégralité du document concerne une population unique
  (pré-éclampsie sévère anté/post-partum), contrairement à `pavm`/0037 où
  seul un sous-ensemble était pédiatrique. SFAR et CNGOF (toutes deux déjà
  dans le seed, aucune société nouvelle ajoutée à l'ensemble utilisé)
  liées en document_societies.
- `remplissage` (SFAR/SFMU, RFE 2021, "situation critique" — distinct de la
  RFE 2012 "périopératoire" du même thème général, hrefs vérifiés non
  confondus) : 9 recommandations, GRADE classique, répartition EXACTEMENT
  reconciliée avec le résumé officiel (2 GRADE1, 6 GRADE2, 1 AE ; 2
  questions "absence de recommandation" également reconciliées) — aucun
  écart, cas le plus propre de ce corpus depuis `civd`/0015 et `ira`/0030.
  **Incohérence interne à la source disclosée par le contenu construit
  lui-même, reproduite sans être résolue** : le résumé officiel de la RFE
  annonce "trois protocoles de prise en charge" élaborés par les experts,
  absents du texte court après vérification visuelle exhaustive des 28
  pages (ni texte, ni figure) — non reproduits, hors périmètre du contenu
  disponible. Tableau 1 (composition ionique comparée de 5 solutés, donnée
  de référence pharmacologique) volontairement pas migré. Panneau
  "Exception SSH" (Champ 2 — un bolus de sérum salé hypertonique reste
  indiqué en cas de choc hémorragique associé à un traumatisme crânien
  grave avec signe de focalisation, nuance clinique importante à R2.3)
  volontairement pas migré séparément : SANS chip de grade propre,
  contrairement à R2.3 elle-même individuellement cotée '1-'. `population`
  laissée NULL sur les 9 lignes : les 4 "champs" de cette RFE sont des
  contextes cliniques (sepsis, hémorragie, cérébrolésion, péripartum), pas
  des sous-groupes démographiques au sens des autres fiches du corpus —
  contexte clinique de chaque ligne porté par `source_section`. SFAR et
  SFMU (toutes deux dans le seed) liées en document_societies.
- `sdra` (SFAR, 2018) : 5 recommandations (R1-R5), GRADE classique,
  comptage exactement reconcilié avec la source ("5 recommandations R1-R5
  + 1 question sans recommandation/ECMO"), aucun écart. **Nature du
  document disclosée en tête de migration** : contrairement à la
  quasi-totalité du corpus, ce n'est PAS une RFE rédigée par un comité
  d'experts SFAR, mais la traduction française résumée officielle d'un
  guideline international déjà publié (An Official ATS/ESICM/SCCM
  Clinical Practice Guideline, Am J Respir Crit Care Med 2017) — disclosé
  explicitement par le contenu construit lui-même. `library_final.json`
  classe pourtant ce document `"exact_type": "RFE"` comme les autres —
  divergence disclosée, non résolue. `evidence_level` laissé NULL : la
  "confiance globale dans l'estimation de l'effet" (Haute/Modérée/Basse/
  Très basse) de la version anglaise originale n'est volontairement pas
  reportée par les traducteurs SFAR eux-mêmes en fin d'énoncé (elle varie
  par critère de jugement au sein d'une même recommandation, donc pas
  extractible dans un champ structuré unique). Question 6 (ECMO
  veino-veineuse) volontairement pas migrée — absence de recommandation
  explicitement déclarée par le comité international faute de preuves
  suffisantes (essai EOLIA alors en cours). **Choix de prudence sur
  document_societies, à vérifier par un relecteur humain** : seule la
  SFAR est liée (organisme qui publie ce document précis à ce
  source_url) ; ESICM et SCCM, auteurs du guideline anglais ORIGINAL et
  tous deux présents dans le seed Annexe B, ne sont PAS liés ici — ils ne
  sont pas signataires du document français publié à cette URL, mais du
  texte anglais qu'il traduit, un document distinct non migré dans ce
  projet.
- `securisation_proc` (SRLF/SFAR, 2008, risque infectieux explicitement
  exclu du champ) : **198 recommandations — 2e plus grande migration de ce
  corpus après mal_epileptique/0032 (163)**, extraite par script Python
  (walk programmatique du JSON réparti en 8 champs cliniques, PAS une
  transcription manuelle vu le volume), contrôlée par inventaire exhaustif
  et tally avant écriture du SQL final (155 Fort + 35 Faible + 5 non
  cotées + 3 Indécision = 198, cohérent). **Méthodologie RAND/UCLA
  adaptée SRLF-SFAR à un seul axe (PAS GRADE)** : `grade` reproduit
  littéralement 'Fort'/'Faible'/'Indécision', jamais converti en échelle
  GRADE 1+/2+. 5 propositions "non cotées" (Champ 3.1 uniquement,
  disclosure de la source elle-même) migrées avec `grade = NULL` plutôt
  qu'un tag '?' fabriqué. 3 propositions en "zone d'indécision" (catégorie
  distincte explicitement identifiée par les auteurs, médiane 4-6) migrées
  avec `grade = 'Indécision'`, jamais reclassées en Fort/Faible. Champ 8
  (spécificités pédiatriques, 12 lignes) seul taggé `population =
  'Pédiatrie'`, le reste laissé NULL (adulte/enfant mêlés dans les Champs
  1-7 sans marqueur individuel dans la source). **Pas de numérotation Rx.y
  propre à ce document** — le rang `[Réf. N]` de `source_section` est un
  ordre de lecture séquentiel du tableau JSON, PAS un identifiant imprimé
  par la source, disclosure explicite (même pattern que le Champ 4.3
  d'eer/0020). `freshness_status = 'a_jour'` retenu : contrairement à
  eclsa/glycemie/hsa/mal_epileptique, cette fiche ne contient AUCUNE
  mention explicite d'obsolescence dans le contenu construit — pas de
  `revision_detectee` inventé par simple analogie d'ancienneté (2008),
  disclosure du choix. SFAR et SRLF (toutes deux dans le seed) liées en
  document_societies.
- `sedation_reanimation` (SFAR/SRLF, Conférence de Consensus 2007/2008,
  nouveau-né exclu) : 45 recommandations réparties en 5 questions.
  **Nature du document disclosée** : `library_final.json` classe ce
  document "RFE", mais c'est en réalité une Conférence de Consensus (CC)
  — `doc_type = 'CC'` retenu, conforme au texte source. **Grades DÉDUITS,
  pas imprimés individuellement** : particularité méthodologique unique à
  cette fiche dans le corpus — aucun tag GRADE n'accompagne chaque
  recommandation dans le texte source ; le jury énonce en préambule une
  convention de formulation EXPLICITE ("il faut faire" = 1+, "il faut
  probablement" = 2+, etc.) que le contenu construit applique pour dériver
  chaque chip — DIFFÉRENT du "+" non sourcé de lat_soins_critiques/0031 :
  ici la convention de dérivation est elle-même explicitement énoncée par
  le jury source, pas une inférence visuelle du contenu construit.
  Comptage direct (26×1+, 8×1-, 6×2+, 0×2-, 5×AE = 45), aucun total
  officiel source à réconcilier. Tableau 2 (agents de la sédation,
  posologies), Tableau 3 (morphiniques, posologies) et l'algorithme de la
  Question 5 (transcrit depuis une image pure, sans chip individuel par
  étape) volontairement pas migrés. 5 recommandations marquées
  "[Pédiatrie]"/"[pédiatrie]" par la source taguées `population =
  'Pédiatrie'`. **`freshness_status = 'revision_detectee'`** retenu :
  contrairement à securisation_proc/0041, LA SOURCE ELLE-MÊME avertit
  explicitement que "les pratiques de sédation-analgésie en réanimation
  ont évolué depuis (échelles, molécules)" — disclosure positive, pas une
  inférence par ancienneté. Date de conférence (15/11/2007) retenue comme
  `publication_date`, plus précise que le "2008" de `library_final.json`
  (probablement l'année de publication AFAR). SFAR et SRLF (toutes deux
  dans le seed, co-organisatrices) liées en document_societies.
- `sedation_urgences` (SFAR/SFMU, RFE 2010, réactualisation de la CE SFAR
  1999) : **160 recommandations — 3e plus grande migration de ce corpus
  après securisation_proc/0041 (198) et mal_epileptique/0032 (163)**,
  réparties en 16 sous-sections (Q1, Q2 1/2 et 2/2, Q3, Q4, Q5a-h [8
  circonstances particulières], Q6 1/2 et 2/2 [pédiatrie], Surveillance
  SOAPME). Extraction par script Python (walk programmatique du JSON),
  contrôlée par inventaire exhaustif et tally avant écriture du SQL final
  (39×1+ + 8×1- + 45×2+ + 11×2- + 57×AE = 160, cohérent). **Type de
  document divergent disclosé** : `library_final.json` classe ce document
  "CE" (Conférence d'experts), mais le contenu construit le décrit
  lui-même comme une RFE SFAR-SFMU (réactualisation de la CE 1999) —
  `doc_type = 'RFE'` retenu, conforme à l'auto-description du document
  2010 lui-même. **Fiabilité de source disclosée** : la page 9 du PDF
  (Figure 2, Question 4 "Patient intubé-ventilé" en intégralité, phrase
  d'ouverture de Q5a) est entièrement rastérisée sans texte extractible —
  contenu migré retranscrit depuis le rendu visuel vérifié à 400dpi par
  le contenu construit, pas depuis un calque de texte (disclosure
  conservée pour relecture future). GRADE adaptée à 3 niveaux
  (disclosure explicite de la source : méthode classique adaptée faute
  d'études de haut niveau suffisantes) — Niveau 1→1+/1-, Niveau 2→2+/2-,
  Niveau 3→AE. "Accord faible" signalé par la source pour certaines
  recommandations, conservé entre parenthèses dans `statement` (jamais un
  champ `evidence_level` séparé — même convention que hypothermie/0025 et
  intubation_difficile_adulte/0027). Figure 1 (algorithme traitement
  antalgique, Q2) et Figure 2 (algorithme intubation, Q3/Q4) — synoptiques
  restatant du contenu déjà gradué — volontairement pas migrées ; Question
  7 (prérequis/formation, prose organisationnelle continue sans chip)
  volontairement pas migrée. 44 recommandations des sous-questions
  pédiatriques (Q6 1/2, Q6 2/2, SOAPME) taguées `population = 'Pédiatrie'`.
  SFAR et SFMU (toutes deux dans le seed) liées en document_societies.
- `sepsis` (HAS, avec SFAR/SRLF/SFMU/SPILF + 12 autres promoteurs, RPC
  2025) : **130 recommandations migrées sur 149 dénombrées par la source
  elle-même (84 adulte + 65 enfant)** — 1er document HAS (pas SFAR) de ce
  corpus, reproduisant intégralement en Annexe 5/6 la Surviving Sepsis
  Campaign (SSC) 2021 adulte et 2020 enfant "validée pour le contexte
  français". **Périmètre de migration restreint aux recommandations
  directionnelles réelles, disclosure explicite** : 19 des 149 items
  portent le grade officiel "?" (= "Pas de recommandation possible",
  catégorie de LÉGENDE SOURCE, pas un marqueur ad hoc comme le '?' de
  securisation_proc/0041) — non migrés, même traitement que les panneaux
  "Absence de recommandation" de tout le corpus et les lignes "SR" de
  pancreatite/0036 ; seules les 130 lignes à grade directionnel réel
  (38×1+, 7×1-, 48×2+, 37×2- = 130) sont migrées. Le total officiel "149"
  de la source INCLUT ces 19 items sans recommandation — divergence de
  convention de comptage disclosée entre source et migration.
  **Numérotation source reproduite avec ses propres discontinuités**
  (numéros absents disclosés par la source elle-même : "items exclus de
  la validation française de la SSC"), pas une renumérotation de ma part.
  **Simplification disclosée pour l'Annexe 6 (pédiatrique)** : la source
  SSC imprime deux axes (force + niveau de certitude) par recommandation
  pédiatrique, que le contenu construit a lui-même synthétisés en un seul
  chip — reproduit tel quel, simplification disclosée pour relecture
  future. Définitions, scores diagnostiques (Phoenix, feux NICE, signes
  vitaux), messages clés du parcours de soins, bonnes pratiques
  hémoculture et facteurs de risque BMR volontairement pas migrés (aucun
  n'est compté dans les "149" de la source, tous sans chip individuel).
  Annexe 6 (pédiatrique, 54 lignes) intégralement taguée `population =
  'Pédiatrie'`. **Collision d'acronyme "SFN"** (même pattern que eer/0020
  et ira/0030, probablement "Société Française de Néonatologie" ici, pas
  vérifiable) — non liée par prudence. SFAR, SRLF, SFMU, SPILF (4 des 16
  promoteurs) ET HAS elle-même (organisme publiant/validant — 1ère
  utilisation de cette société du seed dans ce corpus) liées en
  document_societies ; les 11 autres promoteurs hors seed, non liés. Un
  document distinct et plus ancien (CC SRLF 2005/2006, hémodynamique
  uniquement, nouveau-né exclu) existe dans `library_final.json`, non
  confondu (href/contenu vérifiés distincts).
- `sepsis_hemodynamique` (SFAR/SRLF, CC 2006, nouveau-né exclu) : c'est
  précisément ce "document distinct et plus ancien" évoqué ci-dessus pour
  `sepsis`/0044 — 33 recommandations, cotation à LETTRE UNIQUE non-GRADE
  (B/C/D/E, aucune occurrence de A, signification des lettres non
  redéfinie par la source — même situation que hsa/0023). Comptage
  exactement reconcilié (18E+10B+3C+2D=33). **1 recommandation (grade D)
  imprimée hors du tableau standard Réf./Recommandation/Grade** — un
  paragraphe autonome suivi d'une note "Grade D" séparée — disclosure
  explicite (`source_section` marquée "sans repère imprimé" plutôt qu'un
  numéro Réf. inventé). Plusieurs anomalies de la source vérifiées à
  600dpi et disclosées (valeurs pédiatriques du Tableau 1 sans repère
  "(E)", coquille probable mmol/l pour µmol/l sur 2 seuils, symbole absent
  avant un seuil de cortisolémie) — Tableau 1 lui-même (définitions) et
  l'algorithme décisionnel de la Question 5 (Figure 1, redessiné, sans
  chip individuel) volontairement pas migrés. 6 recommandations marquées
  "P" taguées `population = 'Pédiatrie'`. **`freshness_status =
  'revision_detectee'`** : disclosure explicite de la source elle-même
  ("se référer aux données plus récentes, Surviving Sepsis Campaign, RFE
  postérieures") — cette RFE/RPC plus récente existe désormais dans ce
  même corpus (`sepsis`/0044, HAS RPC 2025, périmètre bien plus large),
  les deux documents restant migrés séparément sans fusion ni dépréciation
  automatique. SFAR et SRLF (toutes deux dans le seed) liées en
  document_societies.
- `sevrage_vm` (SRLF, avec SFAR/Société de Pneumologie de Langue
  Française/GFRUP, CC 2001) : **CAS PARTICULIER DE CE CORPUS, 17
  recommandations seulement — comptage volontairement restreint, disclosure
  extensive**. Méthodologie SCCM Rating System (1997, non-GRADE, même
  principe que civd/0015), mais le texte source mêle dans les MÊMES
  crochets des cotations preuve/force ("[a, 1]", "[c, 3]") et de simples
  renvois bibliographiques numérotés sans lettre ("[2]", "[3]" seuls — 32
  occurrences sur 101 crochets, vérifié exhaustivement) — rien ne permet
  de distinguer les deux avec certitude. Le contenu construit a fait le
  choix explicite de NE JAMAIS convertir un crochet en grade_chip et de
  tous les reproduire verbatim en texte inline — cette migration respecte
  intégralement ce choix : `grade`/`evidence_level` laissés NULL sur
  TOUTES les lignes, sans extraction sélective des crochets les moins
  ambigus (qui aurait réintroduit, de façon incohérente, l'interprétation
  que la source a précisément choisi d'éviter). **Atomisation restreinte
  aux 4 tableaux "Thème/Énoncé/Réf." du document (17 blocs thématiques,
  Q1 : 3, Q2 : 3, Q4 : 7, Q5 : 4)** — la Question 3 (conduite de l'épreuve
  de VS) et les paragraphes d'ouverture de Q1/Q4/Q5 sont en PROSE CONTINUE
  sans repère individuel (contiennent pourtant des directives importantes,
  ex. "la VACI ne doit pas être proposée [a, 1]") — NON migrés séparément
  pour éviter un découpage arbitraire incohérent avec le traitement des 17
  blocs, disclosure explicite qu'une relecture future pourrait juger utile
  d'atomiser cette prose plus finement. Organigramme "Procédure de
  sevrage" (Figure 1, reconstruit depuis un rendu à 150dpi) volontairement
  pas migré. Bloc "Patients pédiatriques" taggé `population =
  'Pédiatrie'`. `freshness_status = 'revision_detectee'` : disclosure
  explicite de la source elle-même ("les pratiques ont évolué depuis
  2001"). SRLF et SFAR (toutes deux dans le seed) liées en
  document_societies ; Société de Pneumologie de Langue Française et
  GFRUP hors seed, non liées.
- `tih` (GIHP/GFHT, avec SFAR, Propositions 2019 — actualise la CE SFAR
  2002 : NE PAS CONFONDRE avec `transport_intrahospitalier`/0001, malgré
  l'acronyme "TIH" partagé — c'est ici "thrombopénie induite par
  l'héparine", vérifié dès l'ouverture du contenu construit) : 40
  propositions (12 questions), comptage exactement reconcilié avec le
  résumé officiel de la source. **Axe unique "Accord", pas de grade GRADE**
  (comme en 2002) : vote de 32 membres GIHP/GFHT, "fort" si ≥ 70 % pour —
  **les 40 propositions ont TOUTES recueilli un accord fort**, colonne
  Accord constante reproduite fidèlement (`grade = 'Fort'` partout, pas
  une valeur par défaut inventée). **Nature du document disclosée** :
  `library_final.json` classe ce document "Autre" (ni RFE ni CC/CE) —
  `doc_type = 'Propositions GIHP/GFHT'` retenu, conforme à
  l'auto-description de la source. Volume important de tableaux/figures
  de référence pharmacologique et algorithmique (5 tableaux, 4 figures)
  volontairement pas migrés — dont une **incohérence interne disclosée
  par le contenu construit lui-même, non résolue** : le corps du texte
  introduit "≥ 4" comme seuil d'arrêt de l'argatroban lors du relais AVK,
  la figure correspondante trace "> 4" — les deux formulations coexistent
  dans la source. Prop. 36 (grossesse) taguée `population = 'Grossesse'`
  (1er usage de cette valeur dans ce corpus) ; Prop. 37/38 (enfant)
  taguées `population = 'Pédiatrie'`. Un document distinct et plus ancien
  (CE SFAR 2002, prédécesseur explicitement actualisé par celui-ci) existe
  dans `library_final.json`, non confondu, non migré séparément
  (superseded). Seule la SFAR (collaboratrice, dans le seed) liée en
  document_societies ; GIHP et GFHT (auteurs principaux) hors seed, non
  liés.
- `tracheotomie` (SRLF/SFAR, avec SFMU/SFORL, RFE 2016/2017) : 18
  recommandations (R1.1-R5.3), GRADE classique, comptage EXACTEMENT
  reconcilié sur les deux axes (total 18 = 8 formalisées [2 GRADE1 + 6
  GRADE2] + 10 AE), cas propre sans écart. **Correction d'extraction
  disclosée par le contenu construit lui-même** : R1.3 et R3.2 imprimées
  "(Grade 1-)"/"(Grade 2-)" dans la source (confirmé par rendu visuel),
  mais l'extraction automatique du PDF perd le signe "moins" pour ces
  deux tags (bug déjà rencontré, cf. choc_hemorragique/0014) — corrigé
  par le contenu construit avec le signe réellement imprimé, grade migré
  reflète cette correction (1-/2-, pas 1/2 bruts). 3 protocoles de soins
  associés (R3.5 : procédure standardisée de trachéotomie percutanée ;
  R4.1 : gestion post-trachéotomie par période ; R5.1 : algorithme
  séquentiel de décanulation en 5 étapes d'après Warnecke et al.)
  volontairement pas migrés séparément (avis d'experts au niveau du
  protocole global, pas une cotation individuelle). Champ explicitement
  limité à la trachéotomie PROGRAMMÉE (la trachéotomie en urgence est
  hors champ, disclosure de portée de la source). SRLF, SFAR et SFMU
  (toutes trois dans le seed) liées en document_societies ; SFORL hors
  seed, non liée.
- `transfusion_plasma` (ANSM/HAS, actualisation 2012) : 40 énoncés migrés.
  **NATURE DU DOCUMENT DISCLOSÉE, CAS UNIQUE DU CORPUS** : ce n'est pas un
  document SFAR — la SFAR n'est ni auteure ni co-signataire, seulement
  hébergeuse d'une copie sur son site ; `library_final.json` classe
  pourtant ce document "RFE" comme les autres — divergence disclosée, non
  résolue. **SFAR volontairement NON liée en document_societies** pour
  cette raison précise (1er cas de ce type dans le corpus). Méthodologie
  HAS/ANAES (grades A/B/C + « accord professionnel », différente de
  GRADE) : 33 énoncés tagués exactement reconciliés avec le comptage du
  contenu construit (6B + 11C + 16AP, aucun A) ; **7 énoncés
  cliniquement substantiels supplémentaires SANS tag explicite** dans la
  source (disclosure de la source elle-même) migrés avec `grade = NULL`
  — pas des items "absence de recommandation possible" (contrairement au
  '?' de sepsis/0044) mais des indications/non-indications réelles
  simplement non gradées, même traitement que les "non cotés" de
  securisation_proc/0041. Total migré 40 = 33 gradés + 7 non gradés.
  Tableau des 4 plasmas thérapeutiques homologues et toute la prose
  produit/pharmacologique (décongélation, compatibilité ABO,
  contre-indications, tests biologiques) volontairement pas migrés
  (référence produit, jamais un chip individuel). 6 énoncés de la section
  pédiatrie/néonatologie taggés `population = 'Pédiatrie'` ; 3 énoncés
  préfixés "Obstétrique" taggés `population = 'Grossesse'`. Seule la HAS
  (2e utilisation de cette société du seed) liée en document_societies ;
  ANSM hors seed, non liée. Un document distinct et plus récent (SFAR,
  RPP 2020, PLYO en choc hémorragique) existe dans `library_final.json`,
  non confondu, non couvert par cette migration.
- `traumatisme_abdominal` (SFAR/SFMU, avec AFC/AFU/SFRI/École du Val de
  Grâce, RFE 2019) : 15 recommandations réparties en 3 champs (diagnostic,
  thérapeutique, surveillance), champ EXPLICITEMENT restreint à l'adulte
  hors grossesse (pédiatrie et femmes enceintes exclus par la source
  elle-même — `population` laissée NULL, disclosure de portée). **Écart
  de répartition GRADE disclosé, isolé précisément, non résolu** : le
  résumé officiel annonce "5 GRADE1, 6 GRADE2, 4 AE" ; un inventaire
  direct tag par tag trouve 4 GRADE1 (2×1+, 2×1-) et 7 GRADE2 (7×2+,
  aucun 2-) — le total (15) ET le compte d'AE (4) concordent avec le
  résumé officiel, mais pas la répartition GRADE1/GRADE2 annoncée (5+6 vs
  4+7 constaté). Fiche réflexe préhospitalière (Figure 1) et Algorithme de
  prise en charge hospitalière (Figure 2), tous deux transcrits depuis des
  posters-images sans chip individuel, volontairement pas migrés. SFAR et
  SFMU (toutes deux dans le seed) liées en document_societies ; AFC, AFU,
  SFRI et École du Val de Grâce hors seed, non liés.
- `traumatisme_cranien` (SFNC, avec SFNCP/SFNCL/ANARLF/SFAR/GFRUP/SFNR/
  SPILF/SOFMER, RPP 2025) : **première RPP portée spécifiquement par la
  neurochirurgie depuis 2006** (disclosure de la source elle-même). 43
  recommandations réelles (R1.1-R15.2) réparties en 7 champs + 2 items
  "Absence de recommandation" (R11.4, R14.2, non migrés). **"43" et "45"
  du résumé officiel réconciliés par la source elle-même, reproduit tel
  quel** : 45 items formulés au total, dont 43 recommandations réelles (39
  AE + 4 "GRADE 2") et 2 "Absence de recommandation" explicites — les deux
  chiffres comptent des ensembles différents, aucune divergence réelle,
  contrairement aux nombreuses vraies divergences disclosées ailleurs dans
  ce corpus. **Méthodologie GRADE simplifiée à 2 niveaux** (pas de palier
  GRADE1, pas de suffixe +/- imprimé sur les tags "GRADE 2") : le sens
  +/- de chaque "GRADE 2" est déduit de la formulation littérale de la
  phrase par le contenu construit — disclosure explicite de cette
  dérivation. **Incohérence source relevée et signalée par le contenu
  construit lui-même (vérifiée par rendu visuel), non corrigée
  silencieusement** : R6.4 utilise la formule verbale du Grade 2 mais est
  littéralement taguée "avis d'experts" — le tag imprimé retenu (AE), pas
  la formulation verbale. Annexes de référence (mFI-5, score SPIN,
  critères scanographiques, GOSE, Clinical Frailty Scale) volontairement
  pas migrées. 7 recommandations du Champ 7 (particularités pédiatriques,
  nouveau-né/nourrisson <2 ans) taguées `population = 'Pédiatrie'`. SFAR
  et SPILF (2 des 9 sociétés du groupe de travail, toutes deux dans le
  seed) liées en document_societies ; SFNC (coordinatrice), SFNCP, SFNCL,
  ANARLF, GFRUP, SFNR et SOFMER hors seed, non liées.
- `traumatisme_cranien_leger` (SFMU/SFAR, avec SFBC/SFR/SOFMER, RPP 2022) :
  14 énoncés individuellement formulés selon le cadre PICO propre du
  texte, tous "avis d'experts" (AE). **Format RPP, pas de GRADE numérique**
  — choix méthodologique explicite de la source, faute de niveau de preuve
  suffisant. **Divergence de comptage disclosée par le contenu construit
  lui-même, non résolue** : le résumé officiel annonce "13 recommandations"
  mais l'inventaire direct des 14 énoncés PICO en dénombre 14 — le contenu
  construit précise lui-même que "13" est cité tel quel sans détail de
  correspondance avec le découpage individuel ; les 14 énoncés réels sont
  tous migrés, aucun retranché. **Intervertissement de numérotation
  disclosé par la source elle-même, reproduit fidèlement** : R2.4 (délai
  de la TDM) est imprimé sous la Question 2.3, et R2.3 (Doppler
  transcrânien) sous la Question 2.4 — anomalie propre à la source, non
  corrigée. Absence de recommandation (inhibiteurs P2Y12, faute de
  données), Tableaux 1-3 (définition OMS, signes de fracture, cinétique
  élevée), Annexe 1 (comparatif de 7 scores, non reproduite intégralement
  par le contenu construit lui-même — extraction disloquée) et Annexe 2
  (fiche d'information patient, contenu informationnel non gradué)
  volontairement pas migrés. SFMU et SFAR (toutes deux dans le seed) liées
  en document_societies ; SFBC, SFR et SOFMER hors seed, non liées.
- `traumatisme_membre` (SFAR/SFMU, avec SOFCOT/SCVE/SSA, RFE 2019/2020) :
  19 recommandations (R1-R11), GRADE classique, comptage EXACTEMENT
  reconcilié sur les deux axes (19 = 4 GRADE1 + 12 GRADE2 + 3 AE), cas
  propre sans écart (comme tracheotomie/0048, sepsis_hemodynamique/0045).
  Traumatismes pelviens explicitement exclus du champ par la source
  elle-même (RFE dédiée distincte). Figures 1-2 (critères de Vittel,
  classification de Gustilo), Tableau 1 (gradation du risque, aide à la
  décision R4.1/R4.2), Figure 3 (algorithme d'orientation) et Figure 4
  (checklist de prévention infectieuse, transcrite depuis une affiche
  associée à R6.1) volontairement pas migrés — références/synthèses
  opérationnelles sans chip individuel. Annexe 1 (codes AIS détaillés,
  plusieurs centaines d'entrées) non reproduite par le contenu construit
  lui-même — rien à migrer au-delà du seuil déjà cité en introduction.
  SFAR et SFMU (toutes deux dans le seed) liées en document_societies ;
  SOFCOT, SCVE et SSA hors seed, non liées.
- `traumatisme_pelvien` (SFMU/SFAR, avec SFR/SSA/AFU/SOFCOT/SFCD, RFE
  2017) : 22 recommandations (5 préhospitalières + 17 hospitalières),
  GRADE classique, comptage EXACTEMENT reconcilié sur les deux axes (22 =
  11 GRADE1 + 11 GRADE2), cas propre sans écart (3e cas de ce type de
  suite dans ce lot, après traumatisme_membre/0053). **Disclosure
  méthodologique particulière de la source elle-même, reproduite sans
  invention** : 9 questions n'ayant pu aboutir qu'à un avis d'experts
  (littérature insuffisante pour GRADE) ont été délibérément exclues du
  document publié par la source elle-même — contrairement à la
  quasi-totalité du corpus, ce document ne contient donc AUCUN panneau
  "Absence de recommandation" ni item avis d'experts résiduel. Les
  classifications Young-Burgess et Tile (planches anatomiques illustrées,
  non reproduites par le contenu construit lui-même) volontairement pas
  migrées séparément — leur contenu clinique de référence résumé en
  tableau texte associé à R2.7 (seule recommandation graduée liée).
  Traitement du choc hémorragique explicitement exclu du champ (RFE
  dédiée distincte). SFMU et SFAR (toutes deux dans le seed) liées en
  document_societies ; SFR, SSA, AFU, SOFCOT et SFCD hors seed, non
  liées.
- `traumatisme_thoracique` (SFAR/SFMU, avec SFCTCV/SFR, Anesth Reanim.
  2015;1:272-287, en ligne 23/05/2015) : 48 recommandations sur 7
  questions PICO, GRADE classique (19×1+, 17×2+, 7×AE, 4×2-, 1×1-).
  **Première RFE française sur ce sujet, disclosure de la source
  elle-même** (aucune recommandation antérieure d'une société savante
  française sur la prise en charge spécifique du traumatisme thoracique).
  **Divergence de comptage disclosée, non réconciliée par la source
  elle-même** : le résumé officiel annonce un total agrégé de "60
  recommandations formalisées" (accord fort 50/90 %, accord faible 10),
  chiffre cité tel quel en introduction sans être recalculé ni réparti
  ligne par ligne — inventaire direct = 48 énoncés individuellement
  gradés (chaque « Proposition » numérotée par la source pouvant regrouper
  plusieurs phrases distinctement graduées, ici éclatées en lignes
  séparées selon leur propre tag) ; la correspondance exacte entre 48 et
  60 n'est pas reconstituable depuis le texte publié. **Piège d'extraction
  disclosé par la source elle-même et corrigé avant intégration** : le
  signe moins de 5 tags "G1-"/"G2-" a été corrompu en caractère de
  contrôle non imprimable par l'extraction automatique du PDF, confirmé
  par rendu visuel de la page 3 (même famille de bug que
  `tracheotomie`/0048 et `choc_hemorragique`/0014). Aucune table de
  classification ou figure de référence identifiée nécessitant une
  exclusion (contrairement à `traumatisme_membre`/0053 ou
  `traumatisme_pelvien`/0054) — le contenu construit est composé presque
  intégralement des 7 tableaux Réf./Recommandation/Grade formellement
  structurés. Aucun contenu pédiatrique ou obstétrical identifié —
  population NULL sur toutes les lignes. `publication_date` = date de
  mise en ligne disclosée par la source (23/05/2015), plus précise que
  l'entrée `library_final.json` qui n'indique que l'année ("2015"). SFAR
  et SFMU (toutes deux dans le seed) liées en document_societies ; SFCTCV
  et SFR (co-auteurs) hors seed, non liées.
- `traumatisme_vertebromedullaire` (SFAR, avec ANARLF/SFCR/SFMU/SOFCOT/
  SOFMER/SSA, RFE 2019, actualisation de la CE 2004) : 19 recommandations
  sur 12 questions PICO, GRADE classique, comptage EXACTEMENT reconcilié
  sur les deux axes (19 = 2×GRADE1 [1×1+, 1×1-] + 12×GRADE2 [tous 2+] +
  5×AE), 100 % accord fort — cas propre, aucun écart avec le résumé
  officiel de la source. 2 algorithmes de la source (Figure 1 —
  immobilisation rachidienne ; Figure 2 — procédure d'intubation
  trachéale) reformulés par le contenu construit en tableaux de décision
  condensés (vérifiés par rendu visuel des pages source), non gradués
  individuellement par le jury donc volontairement pas migrés séparément
  — leur contenu clinique concret est déjà couvert par les recommandations
  graduées migrées (R1.1, R2.1/R2.2, R8.1/R8.2). SFAR et SFMU (toutes deux
  dans le seed) liées en document_societies ; ANARLF, SFCR, SOFCOT,
  SOFMER et le SSA (co-auteurs) hors seed, non liés.
- `urgences_obstetricales` (SFMU/SFAR/CNGOF, RPP 2022, remplace la RFE 2010
  "Urgences Obstétricales Extrahospitalières" de `library_final.json`) : 15
  recommandations sur 6 champs cliniques (+ formation), méthodologie RPP
  (avis d'experts « AE », pas GRADE), sauf 2 des 4 recommandations
  explicitement reprises littéralement d'une RFE antérieure qui conservent
  leur tag GRADE d'origine. **Traitement non uniforme des 4 reprises
  disclosé, non résolu** : R2.1 (reprise de la RPC HPP CNGOF/SFAR 2014) et
  R4.1 (reprise de la RFE pré-éclampsie SFAR/CNGOF 2020) sont re-taguées
  "AE" par ce document, tandis que R4.2/R4.3 (également reprises de la RFE
  2020) conservent leur tag GRADE d'origine "1+" — `grade` reproduit ce qui
  est effectivement imprimé dans CE document, pas le grade de la RFE
  source. **Ambiguïté de comptage disclosed, non résolue** : le panneau
  méthodologique annonce "15 recommandations + 4 recommandations reprises"
  — lu ici comme "15 au total, dont 4 reprises" (cohérent avec l'inventaire
  direct de 15 repères Rx.y.z distincts), pas "15+4=19" (aucune 4e ligne
  supplémentaire identifiable). 2 questions "Absence de recommandation"
  disclosées PAR LA SOURCE ELLE-MÊME (transfert inter-hospitalier HPP
  grave ; extraction fœtale en arrêt cardiaque) volontairement pas
  migrées — correspond exactement aux "2 questions sans recommandation
  possible" annoncées. Tableau de seuils de dose d'exposition fœtale et
  panneau "Points clés" (arrêt cardiaque) volontairement pas migrés
  (référence/contenu accompagnant une question sans recommandation).
  Population laissée NULL sur toutes les lignes (document entièrement
  consacré à la grossesse, même convention que `preeclampsie`/0038). SFMU,
  SFAR ET CNGOF (toutes trois dans le seed) liées en document_societies.
- `vni` (3e Conférence de Consensus commune SFAR-SPLF-SRLF, avec
  participation SFMU/SAMU de France/GFRUP/ADARPEF, 2006) : 26
  recommandations, GRADE classique (4×1+, 17×2+, 5×2-), grades imprimés
  littéralement (pas de déduction de polarité nécessaire, contrairement à
  `sedation_reanimation`/0042). **Pas de total agrégé officiel publié par
  la source** — 26 lignes comptées directement, aucun chiffre-résumé à
  réconcilier. **Structure "Tableau 2" disclosée en détail** : ce tableau
  groupe plusieurs indications sous un même grade partagé (contrairement
  aux tableaux "Thème | Recommandation | Grade" habituels) ; la plupart de
  son contenu est déjà couvert par des lignes détaillées migrées séparément
  (pour éviter la redondance), SAUF 5 indications sans ligne détaillée
  correspondante ailleurs (4×2- : pneumopathie hypoxémiante, SDRA,
  traitement de l'IRA post-extubation, maladies neuromusculaires aiguës
  réversibles ; 1×2+ : traumatisme thoracique fermé isolé) — migrées
  directement depuis ce Tableau 2, avec reformulation grammaticale minimale
  disclosée (aucun contenu ajouté). 3 "situations sans cotation possible"
  (asthme aigu grave, syndrome d'obésité-hypoventilation, bronchiolite
  aiguë du nourrisson hors forme apnéisante) déclarées PAR LA SOURCE
  ELLE-MÊME, volontairement pas migrées. Tableau 1 (contre-indications,
  liste sans grade), Tableau 3 (effets indésirables) et Tableau 4 (critères
  de risque d'échec) volontairement pas migrés (référence clinique sans
  grade individuel). Particularités pédiatriques signalées par la notation
  littérale "[pédiatrie]" de la source — `population='Pédiatrie'`
  uniquement sur R19 (seule ligne graduée entièrement dédiée). **Document
  de 2006, source avertit elle-même que les pratiques de VNI ont évolué
  depuis** (interfaces, oxygénothérapie à haut débit) —
  `freshness_status='revision_detectee'` malgré `library_final.json` "en
  vigueur" (même pattern que eclsa/0019, glycemie/0022, hsa/0023,
  mal_epileptique/0032). SFAR, SRLF ET SFMU (dans le seed) liées en
  document_societies ; SPLF (co-organisatrice à égalité dans le titre de
  la conférence), SAMU de France, GFRUP et ADARPEF hors seed, non liés.
- `voies_aeriennes_enfant` (SFAR/ADARPEF, RFE 2019;5:408-426, comité de 17
  experts) : **59e et dernière fiche du lot.** 17 recommandations, GRADE
  classique, comptage EXACTEMENT reconcilié sur les deux axes (17 = 6
  Grade1 [tous 1+] + 6 Grade2 [5×2+, 1×2-] + 5 avis d'experts), 100 %
  accord fort — cas propre, aucun écart avec le résumé officiel de la
  source. Les 5 avis d'experts (numérotés "n°1" à "n°5" par la source, non
  rattachés à un repère Rx.y) sont migrés comme des lignes à part entière,
  comptées dans le total de 17 conformément à la source ; l'avis d'experts
  n°4 (extubation) combine dans une seule ligne ses deux suggestions
  distinctes (réveil complet + 3 min ventilation spontanée ; OU extubation
  sur guide échangeur creux), pour rester fidèle au décompte officiel "5
  avis d'experts" plutôt que de le porter artificiellement à 6. 3
  questions "Pas de recommandation" déclarées PAR LA SOURCE ELLE-MÊME
  (retrait DSG sous AG profonde vs éveil ; extubation profonde vs
  éveillée ; choix DSG/sonde chez l'enfant enrhumé si masque facial non
  utilisable) volontairement pas migrées — correspond exactement aux "3
  questions" annoncées. 3 algorithmes (intubation difficile imprévue,
  ventilation au masque difficile, CICO — transcrits en tableaux de
  décision depuis des figures pures images, vérifiés visuellement)
  volontairement pas migrés : la source elle-même les compte séparément
  des "17 recommandations", aucune étape individuelle n'y porte de chip de
  grade (même traitement que les algorithmes exclus ailleurs dans ce
  corpus). Population laissée NULL sur toutes les lignes (document
  entièrement consacré à l'enfant, hors nouveau-né/prématuré exclu par la
  source elle-même — même convention que `preeclampsie`/0038 et
  `urgences_obstetricales`/0057). Seule la SFAR (dans le seed) liée en
  document_societies ; l'ADARPEF (co-auteur à égalité, "communes
  SFAR-ADARPEF" dans le titre) hors seed, non liée.

## Fiches restantes (0 / 59)

**Aucune — les 59 fiches construites (`rfe-sfar-website/build/content_*.json`)
sont maintenant toutes migrées vers le modèle relationnel de
`schema_v2.sql`.** Total final : 2630 recommandations atomiques, 59
documents, 8 sociétés du seed Annexe B utilisées, toutes en statut
`draft` — la relecture/validation éditoriale humaine complète (par
document et par recommandation individuelle) reste entièrement à faire
avant toute promotion en statut `active`. Voir les nombreuses sections
`-- À VÉRIFIER` ci-dessus, fiche par fiche, pour le détail des points
disclosed nécessitant une décision humaine (conventions de cotation
non-GRADE, écarts de comptage source-internes, sociétés hors seed Annexe
B, documents disclosant leur propre obsolescence, etc.).

Conformément aux instructions de la Tâche 1, cette migration n'a jamais
été exécutée contre la base de production — uniquement validée par
exécution réelle (fresh-apply + rejeu complet pour vérifier l'idempotence)
contre une instance PostgreSQL 16 locale, fiche par fiche, avant chaque
commit.

**Prochaine étape (Tâche 2)** : reprendre le pipeline de construction de
fiches documenté dans `rfe-sfar-website/CLAUDE.md` pour construire la
prochaine fiche prioritaire non encore construite parmi les 160 items de
la bibliothèque SFAR (`build/library_final.json`), maintenant que la
Tâche 1 est complète.

(`tih` ci-dessus = une fiche distincte de `transport_intrahospitalier`,
malgré l'acronyme partagé — à vérifier son sujet exact avant migration,
ne pas confondre les deux.)

## Comment ajouter un lot

1. Choisir 2-4 fiches dans la liste restante.
2. Pour chacune : lire `build/content_<clé>.json` en entier, identifier
   chaque recommandation atomique à la lecture (pas une conversion
   mécanique — cf. instruction Tâche 1), vérifier tout chip composite
   (`grep -n '"[12][+-]/[12][+-]'` sur le fiche script source si besoin),
   choisir le prochain numéro de séquence document libre (voir tableau
   ci-dessus, incrémenter), écrire `NNNN_migrate_<clé>.sql` suivant le
   patron des fichiers déjà présents (insert documents -> document_societies
   -> document_specialties -> recommendations, tout en `on conflict do
   nothing`, statut toujours `draft`).
   - Pour les fiches à tableaux "Réf. | Recommandation | Grade" réguliers
     (la majorité), un script Python d'extraction automatique (walk du
     JSON, table par table) est plus fiable qu'une transcription manuelle
     à ce volume — mais **jamais** avec une regex de nettoyage HTML du
     type `<[^>]+>` (elle mange silencieusement tout texte source
     contenant un "<" suivi plus loin d'un ">" sans balise réelle entre
     les deux, ex. "INR < 1,5 ... si INR > 1,5" — bug trouvé et corrigé
     sur `choc_hemorragique`/0014). Utiliser une regex qui ne cible que
     les balises réellement présentes dans ce corpus :
     ```python
     import re, html as ihtml
     def strip_tags(s):
         s = re.sub(r'<(?:b|/b|i|/i|br/?|sup|/sup|sub|/sub|u|/u)>', '', s or '')
         s = ihtml.unescape(s)
         return re.sub(r'\s*\n\s*', ' ', s).strip()
     ```
     Après extraction scriptée, **toujours diffuser un contrôle** :
     ré-exécuter l'extraction et comparer (`in`/diff) chaque statement
     généré contre le texte brut de la source — pas seulement un comptage
     de lignes, un vrai contrôle de contenu — avant d'écrire le fichier
     SQL final.
3. **Tester réellement** avant de committer : PostgreSQL 16 local (déjà
   installé dans cet environnement — `service postgresql start`), stub
   `auth.users`/`auth.uid()` minimal :
   ```sql
   create database mgtest;
   \c mgtest
   create extension if not exists pgcrypto;
   create schema if not exists auth;
   create table auth.users (id uuid primary key default gen_random_uuid(), email text);
   create or replace function auth.uid() returns uuid language sql stable as $$ select null::uuid $$;
   ```
   Puis `\i schema.sql`, `\i schema_v2.sql`, `\i` chaque migration dans
   l'ordre (`schema.sql` seul n'est PAS idempotent — pas de `drop policy if
   exists` avant ses `create policy` — donc ne le rejouer qu'une fois ; pour
   le test d'idempotence, rejouer seulement `schema_v2.sql` + toutes les
   migrations une seconde fois sur la même base). Vérifier : la 2e passe
   insère 0 ligne partout (`insert 0 0`), le compte de lignes
   `recommendations` par document correspond à celui annoncé dans le message
   de commit, et `select recommendation_code from recommendations where
   recommendation_code !~ '^MG-ANES-[0-9]{6}-R[0-9]+$'` ne renvoie rien.
   Le safety net `grep -n '"[12][+-]/[12][+-]'` (grade composite) doit
   rester sans résultat sur chaque nouveau fichier de migration.
4. Mettre à jour ce fichier (déplacer les clés migrées, ajouter la ligne au
   tableau, documenter les `-- À VÉRIFIER` du lot).
5. Committer avec le décompte migré/restant dans le message, comme pour les
   fiches individuelles de `rfe-sfar-website`.
