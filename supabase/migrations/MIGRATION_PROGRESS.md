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

## Fiches migrées (67 / 72 disponibles côté rfe-sfar-website — TÂCHE 1 initialement close à 59/59,
## reprise le 2026-09-11 après ajout des fiches 60 puis 61, reprise à nouveau
## le 2026-09-13 (routine planifiée) après découverte de 11 fichiers
## `content_*.json` supplémentaires non encore migrés — voir note de reprise
## en fin de tableau)

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

**Total : 2911 recommandations atomiques, 67 documents, 8 sociétés du seed
Annexe B utilisées en document_societies au fil des migrations (SFAR, SRLF,
SPILF, SFMU, SFC, CNGOF, HAS, plus ABM ajoutée au seed lui-même en 0003 —
seule société non couverte par l'Annexe B d'origine, qui se décrit elle-même comme
non exhaustive, section 14.1).**

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
