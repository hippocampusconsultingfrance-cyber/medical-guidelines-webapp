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

## Fiches migrées (3 / 59)

| Séquence | Clé | Fichier migration | Titre | Recommandations |
|---|---|---|---|---|
| 000001 | `transport_intrahospitalier` | `0001_migrate_transport_intrahospitalier.sql` | Transport intrahospitalier des patients à risque vital (SRLF/SFAR/SFMU, RFE 2011) | 99 |
| 000002 | `ecbu` | `0002_migrate_ecbu.sql` | Place de l'ECBU avant une prise en charge urologique (AFU/CIAFU, RBP 2026) | 46 |
| 000003 | `mort_encephalique` | `0003_migrate_mort_encephalique.sql` | Mort encéphalique et prélèvement d'organes (SFAR/SRLF/ABM, 2005) | 142 |

**Total : 287 recommandations atomiques, 3 documents, 3 sociétés savantes
nouvellement liées (dont ABM, ajoutée à `societies` — absente du seed Annexe
B, qui se décrit lui-même comme non exhaustif, section 14.1).**

### Points laissés `-- À VÉRIFIER` dans ces 3 migrations (à trancher par un relecteur humain)

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

## Fiches restantes (56 / 59)

Un lot par prochaine session, dans l'ordre de priorité clinique déjà suivi
par `rfe-sfar-website/CLAUDE.md` (aigu/garde avant routine/administratif) :

aap_programmee, aap_urgence, allergie_prevention, anaphylaxie, anemie,
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
3. **Tester réellement** avant de committer : PostgreSQL local (stub
   `auth.users`/`auth.uid()` minimal, voir la méthode utilisée pour les 3
   premiers fichiers), `schema.sql` + `schema_v2.sql` + les migrations déjà
   commitées + la nouvelle, deux fois de suite (idempotence), plus une
   vérification du compte de lignes attendu.
4. Mettre à jour ce fichier (déplacer les clés migrées, ajouter la ligne au
   tableau, documenter les `-- À VÉRIFIER` du lot).
5. Committer avec le décompte migré/restant dans le message, comme pour les
   fiches individuelles de `rfe-sfar-website`.
