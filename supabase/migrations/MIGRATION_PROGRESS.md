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

## Fiches migrées (6 / 59)

| Séquence | Clé | Fichier migration | Titre | Recommandations |
|---|---|---|---|---|
| 000001 | `transport_intrahospitalier` | `0001_migrate_transport_intrahospitalier.sql` | Transport intrahospitalier des patients à risque vital (SRLF/SFAR/SFMU, RFE 2011) | 99 |
| 000002 | `ecbu` | `0002_migrate_ecbu.sql` | Place de l'ECBU avant une prise en charge urologique (AFU/CIAFU, RBP 2026) | 46 |
| 000003 | `mort_encephalique` | `0003_migrate_mort_encephalique.sql` | Mort encéphalique et prélèvement d'organes (SFAR/SRLF/ABM, 2005) | 142 |
| 000004 | `aap_urgence` | `0004_migrate_aap_urgence.sql` | Gestion des AAP en cas de procédure invasive non programmée ou d'hémorragie (GIHP/GFHT/SFAR, 2018) | 21 |
| 000005 | `aap_programmee` | `0005_migrate_aap_programmee.sql` | Gestion des AAP pour une procédure invasive programmée (GIHP/GFHT/SFAR, RFE 2018) | 34 |
| 000006 | `allergie_prevention` | `0006_migrate_allergie_prevention.sql` | Prévention du risque allergique péranesthésique. Texte court (Sfar/SFA, RFE 2011) | 47 |

**Total : 389 recommandations atomiques, 6 documents, 3 sociétés savantes
nouvellement liées (dont ABM, ajoutée à `societies` — absente du seed Annexe
B, qui se décrit lui-même comme non exhaustif, section 14.1).**

### Points laissés `-- À VÉRIFIER` dans ces 6 migrations (à trancher par un relecteur humain)

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

## Fiches restantes (53 / 59)

Un lot par prochaine session, dans l'ordre de priorité clinique déjà suivi
par `rfe-sfar-website/CLAUDE.md` (aigu/garde avant routine/administratif) :

anaphylaxie, anemie,
antibioprophylaxie, antibiotherapie_probabiliste, anticoag_urgence,
anticoagulants, asthme_aigu_grave, choc_hemorragique, civd,
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
   patron des 3 fichiers déjà présents (insert documents -> document_societies
   -> document_specialties -> recommendations, tout en `on conflict do
   nothing`, statut toujours `draft`).
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
