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

## Fiches migrées (14 / 59)

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

**Total : 755 recommandations atomiques, 14 documents, 7 sociétés du seed
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

## Fiches restantes (45 / 59)

Un lot par prochaine session, dans l'ordre de priorité clinique déjà suivi
par `rfe-sfar-website/CLAUDE.md` (aigu/garde avant routine/administratif) :

civd,
controle_temperature, corticotherapie, curares, eclsa, eer,
epanchement_pleural, glycemie, hsa, hyperthermie_maligne, hypothermie, ih,
intubation_difficile_adulte, intubation_reanimation, intubation_urgence,
ira, lat_soins_critiques, mal_epileptique, mtev_perioperatoire, nutrition,
nvpo, pancreatite, pavm, preeclampsie, remplissage, sdra,
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
