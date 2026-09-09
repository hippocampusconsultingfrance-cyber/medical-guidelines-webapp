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

## Fiches migrées (36 / 59)

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

**Total : 1653 recommandations atomiques, 36 documents, 7 sociétés du seed
Annexe B utilisées en document_societies au fil des migrations (SFAR, SRLF,
SPILF, SFMU, SFC, CNGOF, plus ABM ajoutée au seed lui-même en 0003 — seule
société non couverte par l'Annexe B d'origine, qui se décrit elle-même comme
non exhaustive, section 14.1).**

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

## Fiches restantes (23 / 59)

Un lot par prochaine session, dans l'ordre de priorité clinique déjà suivi
par `rfe-sfar-website/CLAUDE.md` (aigu/garde avant routine/administratif) :

pavm, preeclampsie, remplissage, sdra,
securisation_proc, sedation_reanimation, sedation_urgences, sepsis,
sepsis_hemodynamique, sevrage_vm, tih, tracheotomie, transfusion_plasma,
traumatisme_abdominal, traumatisme_cranien, traumatisme_cranien_leger,
traumatisme_membre, traumatisme_pelvien, traumatisme_thoracique,
traumatisme_vertebromedullaire, urgences_obstetricales, vni,
voies_aeriennes_enfant.

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
