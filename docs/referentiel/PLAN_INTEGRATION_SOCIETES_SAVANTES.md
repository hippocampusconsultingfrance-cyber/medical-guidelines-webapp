# Plan d’intégration des recommandations de toutes les sociétés savantes d’anesthésie-réanimation

Version 0.1 — 01/10/2026 — **brouillon à valider par le porteur de projet**.

S’appuie sur : le référentiel des 439 organisations (`societes-savantes-anesthesie-reanimation-monde.md` / `.csv`), l’affectation de chacune à une vague (`plan-integration-vagues.csv`), le cahier des charges V4.5 (CDC), la spécification technique V4.5 et l’état du code au 01/10/2026.

---

## 0. En bref

- **Objectif** : intégrer dans medical-guidelines.net, sous forme de fiches de synthèse et de recommandations atomiques, les recommandations en vigueur de toutes les sociétés savantes d’anesthésie-réanimation du référentiel, en respectant les règles non négociables du CDC (source officielle, grade exact, relecture humaine, registre juridique validé, du plus récent au plus ancien).
- **Volume** : de l’ordre de **2 000 documents** (fourchette 1 500 à 3 000), soit plusieurs dizaines de milliers de recommandations atomiques. À titre de comparaison, le corpus SFAR actuel compte 159 fiches, dont 99 déjà migrées en 4 138 recommandations. Ce chiffre sera remplacé par une mesure réelle à l’issue de l’inventaire (chantier 1).
- **Deux contraintes dominent tout le reste** :
  1. **les droits** : la plupart des recommandations étrangères sont publiées dans des revues sous licences variées. Celles-ci peuvent interdire l’usage commercial (NC) ou les œuvres dérivées et traductions (ND). Or le site est payant et publie une fiche en français pour chaque source ;
  2. **la relecture médicale** : la production par l’atelier n’est pas le goulot (environ 100 fiches ont été produites entre le 11 et le 27/09/2026). Chaque fiche exige en revanche une relecture tracée, par langue publiée, et le stock SFAR (112 points « À VÉRIFIER ») attend déjà ces mêmes relecteurs.
- **Acquis** : le verrou de publication (registre juridique « validé » obligatoire), le registre rempli par société, l’encadré des divergences et l’import des traductions anglaises existent déjà sur `main`. Le plan s’appuie dessus.
- **Démarche** : un socle technique (lot 0), quatre chantiers (inventaire, registre juridique, production, veille) et **six vagues** de sociétés, ouvertes l’une après l’autre quand leurs critères d’entrée sont remplis.
- **Avant de lancer**, le porteur de projet doit trancher **10 décisions** (section 2). La plus importante : le CDC interdit toute extension avant la validation commerciale de la phase 1. Je recommande de lancer tout de suite ce qui ne publie rien (socle, inventaire, registre juridique), ainsi que la vague 0, déjà comprise dans le périmètre de la phase 1. Les vagues internationales attendraient le critère de passage.

---

## 1. Point de départ

### 1.1 Ce qui existe

| Élément | État au 01/10/2026 | Source |
|---|---|---|
| Référentiel des sociétés | 439 organisations hors SFAR, dont 160 sociétés nationales d’anesthésie et 89 de réanimation | `docs/referentiel/` |
| Corpus SFAR | 159 fiches dans l’atelier ; 99 migrées (4 138 recommandations en brouillon, 112 points « À VÉRIFIER ») ; au moins 10 conventions de cotation différentes | `supabase/content/SUIVI_CONTENU.md` |
| Chaîne de contenu | atelier (`rfe-sfar-website`) → `scripts/import-atelier.mjs` → base → publication par fiche | spécification technique §3 |
| Modèle de données | `societies`, `documents`, `document_societies`, `source_legal_profiles`, `recommendations`, `document_translations`, `divergences`, `watch_sources` | `supabase/schema_v2.sql` et `supabase/migrations/` |
| Cadre produit | phase 1 = anesthésie-réanimation France ; phase 2 = sociétés européennes et internationales (CDC §15) | CDC V4.5 |

### 1.2 Volume : échantillon mesuré le 01/10/2026

Comptage des documents listés sur la page officielle des recommandations de quelques grandes sociétés :

| Société | Documents listés | Remarque |
|---|---:|---|
| SCCM | 42 | page « List of Guidelines » |
| ESICM | ≈ 60 | inclut les éditions successives de la Surviving Sepsis Campaign (2008 → 2026) et de nombreuses co-publications (ATS, ERS, ERC, ESCMID…) |
| ASA | ≈ 120 à 150 | principes, standards, recommandations, avis et prises de position : une minorité seulement sont des recommandations de pratique clinique |
| DAS | 8 | plus les recommandations conjointes avec l’OAA, l’APAGBI, etc. |
| SSAI | ≈ 15 | ses propres recommandations, plus environ 20 recommandations d’autres sociétés qu’elle approuve (« endorsed ») |
| ESAIC, ASRA | non mesurés | pages inaccessibles lors du test (boucle de redirection, page déplacée) |

**Enseignements** : (1) une part importante des listes est faite de **versions remplacées** (non traitées, CDC §4.2), de **co-publications** et d’**approbations** de documents d’autres sociétés (à dédoublonner) ; (2) la nature des documents est hétérogène (recommandations, consensus, standards, prises de position), ce qui impose de **décider des types retenus** (D3) ; (3) certaines sources sont structurées (plateforme MAGICapp utilisée par la SSAI), ce qui faciliterait l’extraction.

### 1.3 Ce qui est déjà en place, et ce qui manque (code de `main` au 01/10/2026)

**Déjà en place**, et réutilisé tel quel par ce plan :

- **Verrou de publication** (`supabase/migrations/20261001110000_verrou_publication_registre.sql`) : une fiche n’est mise en ligne qu’avec une URL source, une date de publication et un profil juridique « validé ». Le contrôle porte sur `publish_document()`, `publish_all_documents()` et sur toute mise en ligne directe par l’API.
- **Registre juridique** (écran `/bibliotheque/juridique`) : il se remplit par société porteuse, en une fois pour toutes ses fiches. Chaque fiche peut ensuite recevoir son propre profil.
- **Encadré « Recommandations divergentes »** (`20260930140000_recommandations_divergentes.sql`) : une question clinique avec 2 à 4 positions, chacune rattachée à une fiche, saisie par un validateur.
- **Traductions anglaises** importées en brouillon et relues (`20260930090000_traductions.sql`, table `document_translations`). Leur publication est prévue dans une étape ultérieure.
- **Veille des fiches** (nouvelle version, statut de fraîcheur) et **lettre mensuelle**.

**Ce qui manque** pour intégrer des sources non SFAR, traité dans le lot 0 (section 3) :

1. **Traduction non contrôlée par le verrou** : `document_non_publiable()` ne regarde pas `translation_allowed`. Or, pour une source non francophone, la fiche française est elle-même une traduction-reformulation (CDC §7 et §9.2).
2. **Sociétés reliées par sigle seul** : `import-atelier.mjs` rattache un document via `s.acronym in (...)` (ligne 207), et `societies` n’a pas de slug, alors que les adresses prévues (`/{langue}/{spécialité}/{société}/{fiche}`) en exigent un. Or **14 sigles** du référentiel sont portés par plusieurs organisations : AoA, ASA, CACCN, HAS, ISA, ISCCM, PSA, PSCCM, SARM, SATA, SCAR, SEA, SPA (×3), TSCCM. La base contient déjà 93 sigles, créés automatiquement comme co-signataires des textes SFAR, souvent sans pays, et des collisions existent dès aujourd’hui :
   - « HAS » y désigne la Haute Autorité de Santé, et dans le référentiel la History of Anaesthesia Society ;
   - « SSA », co-signataire de la recommandation SFAR sur le traumatisme de membre (vraisemblablement le Service de santé des armées), désigne dans le référentiel la Scottish Society of Anaesthetists ;
   - la base dit « ASRA » là où le référentiel dit « ASRA Pain Medicine » ;
   - les noms complets de l’ANARLF et de la SFB diffèrent entre la base et les sites officiels.
3. **Régions non harmonisées** : le jeu initial (fin de `schema_v2.sql`) range ESAIC, ESICM, SCCM, ASA, DAS et ASRA sous « International », alors que le référentiel utilise « Europe », « États-Unis » ou « Royaume-Uni ». Avec la contrainte `unique (acronym, country_or_region)`, un import naïf créerait des doublons.
4. **Pas de rôle dans `document_societies`** : impossible de distinguer l’auteur, le co-auteur et la société qui approuve seulement.
5. **Un document, plusieurs URL** : la Surviving Sepsis Campaign paraît simultanément dans deux revues, alors que `documents.source_url` est unique. Il faut une identité par DOI et des URL secondaires.
6. **Pas d’héritage du profil juridique** : l’écran remplit le registre par société, mais le stockage reste par document. Une fiche importée plus tard n’hérite donc pas de la politique de sa société ; avec environ 2 000 documents, il faut un profil par défaut au niveau de la société.
7. **Divergences limitées à 4 positions** : c’est suffisant pour comparer la SFAR à une ou deux sociétés, mais pas pour une question traitée par de nombreuses sociétés (sepsis, voies aériennes difficiles).
8. **Recherche en français uniquement** : les index plein texte utilisent la configuration `'french'` (`20260929150000_recherche_contenu.sql`), inadaptée aux titres et énoncés anglais.
9. **La bibliothèque charge tout le catalogue** : `loadLibrary()` (`src/app/bibliotheque/data.ts`) lit tous les documents en une requête, ce qui ne tiendra pas à plusieurs milliers de fiches.
10. **L’atelier est taillé pour la SFAR** : métadonnées dans `site/app.js` (`DOC_META`) et `library_final.json`, et correspondance catégorie → spécialités codée en dur dans `import-atelier.mjs`.
11. **Systèmes de cotation non référencés** : `grading_system` est un texte libre. L’affichage (`src/lib/fiches.ts`) colore 1+, 2+, 2−, 1−, A, B, C et AE, et laisse les autres libellés en neutre : ce n’est pas bloquant, mais les systèmes GRADE (fort/faible + certitude), ASA, AWMF et NICE gagneraient à être décrits.

---

## 2. Décisions à prendre par le porteur de projet

| # | Décision | Recommandation |
|---|---|---|
| D1 | **Calendrier face au test commercial** : le CDC interdit toute extension avant validation de la phase 1. | Lancer maintenant ce qui ne publie rien (lot 0, inventaire, registre juridique) et la vague 0 (France, déjà dans le périmètre de la phase 1). N’ouvrir la vague 1 qu’au critère de passage, ou après une décision explicite de lever cette règle. |
| D2 | **Politique juridique** : avis d’un conseil en propriété intellectuelle, prise de contact avec les sociétés, traitement des licences NC et ND. | Avis écrit d’un conseil sur la table de décision du chantier 2 avant toute publication étrangère. Pour la vague 1 : demande d’autorisation écrite aux six sociétés, ce qui ouvre aussi la voie à un partenariat. Le CDC n’exclut le contact préalable que pour la SFAR. |
| D3 | **Types de documents retenus.** | Retenir les recommandations de pratique clinique, les consensus formalisés et les standards cliniques. Les prises de position organisationnelles ou éthiques seraient de simples « documents de référence », sans recommandations atomiques ni quota. |
| D4 | **Langues sources acceptées et ordre.** | Français et anglais d’abord ; puis espagnol, italien, allemand et portugais ; enfin néerlandais, langues nordiques, japonais, coréen, chinois… La traduction ne s’ouvre qu’avec un relecteur maîtrisant la langue. |
| D5 | **Ordre de traitement multi-sociétés.** | Une file unique triée par date de publication décroissante, limitée aux sources admises (vague ouverte et registre juridique validé). C’est conforme au CDC §4.2 ; les nouveautés de la veille passent en tête. |
| D6 | **Rattachement aux spécialités** (un compte = une spécialité). | Les recommandations de réanimation sont rattachées à la fois à « anesthésie-réanimation » et à « médecine intensive-réanimation » ; la pédiatrie, l’obstétrique et les IADE selon le thème, comme dans l’import actuel. |
| D7 | **Douleur** : dans le périmètre ou non (8 organisations, dont la SFETD). | Hors périmètre de la phase 2, sauf les recommandations douleur des sociétés d’anesthésie elles-mêmes (ASRA, ESRA…). |
| D8 | **Capacité de relecture** : nombre de relecteurs, bilingues, rémunération, objectif de débit. | Au moins 4 relecteurs, dont 2 bilingues anglais, avant d’ouvrir la vague 1 (section 7). |
| D9 | **Profil juridique par société** (hérité par chaque document). | Oui : saisir par défaut au niveau de la société, puis confirmer document par document. |
| D10 | **Affichage des co-publications et approbations.** | Une fiche par document ; elle apparaît sous chaque société autrice. Les sociétés qui ne font qu’approuver sont mentionnées sans dupliquer la fiche. |

---

## 3. Lot 0 — Socle technique (avant tout import non SFAR)

Chaque point fait l’objet d’une demande d’intégration distincte, testée sur l’environnement de test (spécification technique §7).

| # | Travail | Pourquoi | Priorité |
|---|---|---|---|
| T1 | **Compléter le verrou** (`document_non_publiable()`) : pour une source dont `original_language` n’est pas le français, exiger `translation_allowed` = « oui » (ou « conditions » remplies). Même règle à la future publication des versions anglaises. | CDC §7 et §9.2 (constat 1) | **Bloquant** |
| T2 | **Référentiel des sociétés** : ajout d’un `slug` unique (sigle + code pays ISO en cas d’homonymie, ex. `asa-us`, `asa-au`, `spa-py`), du code pays et du nom complet. Rapprochement des 93 sigles déjà en base (HAS, SSA, ASRA…) et des lignes « International » du jeu initial. Import des 439 organisations au statut `a_valider` par un script de contenu, sur le modèle de `supabase/content/0201_societes_noms_complets.sql`, sans écraser un nom déjà saisi. Enfin, `import-atelier.mjs` relie les sociétés par slug. | Constats 2 et 3 | **Bloquant** |
| T3 | **Rôle** dans `document_societies` : `auteur`, `co_auteur` ou `approbation`. | Constat 4, D10 | **Bloquant** |
| T4 | **Identité par DOI** et table des URL secondaires d’un document. | Constat 5 ; dédoublonnage | **Bloquant** |
| T5 | **Profil juridique par société** (politique par défaut) hérité automatiquement par toute nouvelle fiche, en complément de l’écran actuel. Nouveaux champs : URL de licence (ex. CC BY-NC-ND 4.0), origine de l’information (site, Crossref, échange écrit), date. | Constat 6, D9 | **Bloquant** |
| T6 | **Référentiel des systèmes de cotation** (GRADE, ASA, AWMF, NICE, Oxford, conventions SFAR…) : le libellé est toujours affiché tel que dans la source ; seule la couleur dépend du système. | Constat 11 ; CDC §1.3 (aucun grade transformé) | Vague 1 |
| T7 | **Recherche multilingue** : index anglais sur les traductions et les titres originaux. | Constat 8 | Vague 1 |
| T8 | **Bibliothèque paginée** avec filtres société, spécialité et année côté serveur. | Constat 9 | Avant 500 fiches |
| T9 | **Atelier multi-sociétés** : un manifeste par document (sociétés et rôles, URL, DOI, langue originale, licence, système de cotation, date, document remplacé) et un dossier par société ; import générique. | Constat 10 | **Bloquant** |
| T12 | **Divergences au-delà de 4 positions** : lever la limite, ou présenter une question par paire de sociétés. | Constat 7 | Vague 2 |
| T10 | **Back-office** : file éditoriale multi-sociétés, relecture par lot, tableau de bord par vague, comparaison côte à côte de la fiche et de la source. | Débit de relecture | Vague 1 |
| T11 | **Veille** : nouvelles méthodes `pubmed` et `crossref` dans `watch_sources` (requête par société et par type de publication). | Chantier 4 | Vague 1 |

---

## 4. Chantier 1 — Inventaire des recommandations

**But** : remplacer les estimations par une liste mesurée, document par document, et confirmer la vague de chaque société (V4 si elle publie des recommandations, V5 sinon).

**Pour chaque document** : société(s) et rôle, titre, type, langue, date de publication, statut (en vigueur ou remplacé), URL officielle, DOI ou PMID, support (article de revue, PDF sur le site, espace réservé aux membres), licence affichée, système de cotation, nombre approximatif de recommandations.

**Méthode** :
1. parcours automatique de la page des recommandations de chaque société, à partir des URL du référentiel ;
2. requête PubMed par société (types de publication « Practice Guideline » et « Consensus Development Conference », auteur collectif ou affiliation) ; elle détecte aussi les documents publiés hors du site de la société ;
3. métadonnées Crossref par DOI (date, revue, **licence**) ;
4. dédoublonnage par DOI, puis rattachement des co-publications ;
5. contrôle humain d’un échantillon par société.

**Livrables** : `docs/referentiel/inventaire-recommandations.csv` (une ligne par document) et un score par société (volume en vigueur, influence, langue, licence, complémentarité avec le corpus SFAR).

**Ordre** : V0 et V1, puis V2, puis V3, puis les 248 organisations « V4/V5 ». La routine peut le faire sans relecteur ; le porteur de projet valide la synthèse.

---

## 5. Chantier 2 — Registre juridique

**Principe (CDC §12.4)** : aucune fiche n’est publiée sans profil juridique « validé ». Les fiches sont des reformulations éditoriales : jamais de reproduction de tableaux, d’algorithmes ou de mise en page, seulement des citations courtes selon l’avis juridique.

**Table de décision proposée, à faire valider par un conseil (D2)** :

| Situation de la source | Réutilisation commerciale | Traduction d’un résumé | Statut proposé par défaut |
|---|---|---|---|
| Licence CC BY | oui, avec attribution | oui | `validé` après contrôle |
| Licence CC BY-NC | **incertain** : le site est payant | incertain | `autorisation requise` |
| Licence CC BY-ND ou BY-NC-ND | incertain | **non** pour une traduction du texte ; un résumé reformulé reste à qualifier | `autorisation requise` |
| Tous droits réservés (revue sur abonnement, site de la société) | reformulation seulement | à qualifier | `en revue` ; autorisation recommandée pour les sociétés majeures |
| Document réservé aux membres | — | — | `bloqué` tant que la source n’est pas publique (le CDC exige une URL officielle accessible) |
| Algorithmes et figures (la DAS publie par exemple une procédure de demande d’autorisation pour ses algorithmes) | jamais reproduits | — | autorisation écrite obligatoire |

**Organisation** :
- un profil par défaut par société (T5), prérempli à partir des licences Crossref et des mentions du site ;
- une revue juridique au document seulement en cas d’exception ;
- un modèle de demande d’autorisation (français et anglais), une procédure de retrait sur demande et un journal des échanges ;
- un indicateur : la part des documents inventoriés ayant un profil validé, par vague.

---

## 6. Chantier 3 — Production des fiches

### 6.1 Étapes

1. **Sélection** : document en vigueur, non remplacé, dédoublonné, de type retenu (D3), dont la société appartient à une vague ouverte et dont le profil juridique est validé.
2. **File unique** triée par date de publication décroissante (D5).
3. **Extraction dans la langue originale** : énoncé, grade et niveau de preuve **exactement comme dans la source**, population, section et page.
4. **Rédaction** de la fiche en français et en anglais. Pour une source anglaise, la version française est une reformulation traduite, d’où la nécessité de l’autorisation de traduction.
5. **Contrôles automatiques** : chaque grade figure bien dans la source, liens valides, similarité textuelle (pour éviter toute reproduction), champs obligatoires.
6. **Relecture médicale** par langue publiée, tracée (nom, date) ; les points « À VÉRIFIER » sont arbitrés.
7. **Publication** sous verrou (T1).
8. **Divergences** : dès la relecture, le relecteur signale les questions cliniques déjà traitées par une autre fiche (SFAR ou autre). Le validateur crée alors l’encadré « Recommandations divergentes » avec les tables existantes `divergences` et `divergence_positions` (CDC §4.4). C’est le principal apport du multi-sociétés.

### 6.2 Points de vigilance tirés du corpus SFAR

- Les énoncés « aucune recommandation possible » ou purement définitionnels ne reçoivent **jamais** de grade inventé (`grade` reste vide).
- Chaque société, et parfois chaque document, a sa propre convention de cotation : on la décrit dans `grading_system` (T6), sans conversion.
- Une mise à jour partielle (« focused update ») ne remplace que les recommandations concernées.
- Les codes restent au format `MG-{SPÉCIALITÉ}-{séquence}-R{rang}`, avec une séquence commune à toutes les sociétés.

---

## 7. Capacité et calendrier

Le débit est fixé par la relecture. Durée d’une vague ≈ documents ÷ (relecteurs × fiches par relecteur et par semaine), sur environ 45 semaines utiles par an.

| Scénario | Relecteurs | Fiches / relecteur / semaine | Fiches validées par an |
|---|---:|---:|---:|
| A | 2 | 5 | ≈ 450 |
| B | 4 | 5 | ≈ 900 |
| C | 6 | 8 | ≈ 2 150 |

Hypothèses à confirmer avec les relecteurs : une fiche d’environ 40 recommandations, comparée à la source. Une source étrangère publiée en français et en anglais demande deux relectures tracées, ce qui ajoute environ 50 % d’effort. Ces relecteurs doivent aussi absorber le stock SFAR.

**Calendrier indicatif, à partir de la décision D1** :

| Période | Contenu |
|---|---|
| Mois 0 à 1 | Lot 0 bloquant (T1 à T5, T9) ; inventaire V0 et V1 ; registre juridique V1 ; demandes d’autorisation V1 ; production V0 |
| Mois 1 à 2 | Inventaire V2 et V3 ; T6, T7, T10, T11, T12 ; recrutement des relecteurs |
| Mois 2 à 6 | Vague 1 (≈ 250 à 350 documents avant dédoublonnage) : 4 à 5 mois en scénario B |
| Mois 6 et au-delà | Vague 2, puis vague 3, au rythme des relecteurs ; inventaire V4/V5 |

---

## 8. Les vagues

L’affectation de chacune des 439 organisations figure dans `plan-integration-vagues.csv` (colonne `motif`). Elle sera confirmée ou modifiée par l’inventaire.

| Vague | Organisations | Contenu | Critères d’entrée |
|---|---:|---|---|
| **V0 — France hors SFAR** | 12 | SRLF, ADARPEF, CARO, ARCOTHOVA, ANARLF, GIHP, GRACE, GFRUP, CFAR, CFRC, SFB, SOFIA (IADE). S’y ajoutent la HAS, prévue au CDC mais absente du référentiel car c’est une agence publique, et deux organisations déjà en base comme co-signataires de textes SFAR, à ajouter au référentiel : CARORL (Club d’anesthésie-réanimation en ORL) et ARMPO (CNP d’anesthésie-réanimation et médecine péri-opératoire) | T2, T3, T5, T9 ; registre juridique ; déjà dans le périmètre de la phase 1 |
| **V1 — pilote international (annexe B)** | 6 | ESAIC, ESICM, SCCM, ASA (États-Unis), DAS, ASRA | Décision D1 ; lot 0 bloquant terminé ; autorisations ou avis juridique ; 2 relecteurs bilingues |
| **V2 — anglophones** | 82 | Organisations internationales et européennes publiant en anglais (ERC, ELSO, ERAS Society, ESRA, ESPA, EACTAIC, ESPNIC, SSAI…) ; sociétés et collèges des États-Unis, du Royaume-Uni, d’Irlande, du Canada, d’Australie et de Nouvelle-Zélande (AoA, RCoA, FICM, ICS, OAA, APAGBI, ANZCA, CICM, ANZICS, CAS, CCCS, SOAP, SCA, SNACC, SPA…) | Bilan de la V1 (divergences, débit, juridique) |
| **V3 — francophonie hors France** | 33 | Belgique, Suisse, Québec, Luxembourg, Maghreb, Afrique francophone, Liban, Haïti ; SARAF | Inventaire ; aucun obstacle de langue ; production souvent faible |
| **V4 — sociétés régionales de surspécialité** | 9 | AOSRA-PM, ASCA, ASPA, ASNACC, LASRA, AFSRA, SLACIP, RCA, RCSA | Inventaire |
| **V4/V5 — selon l’inventaire** | 248 | Autres sociétés nationales (Allemagne, Italie, Espagne, Pays-Bas, pays nordiques, Europe de l’Est, Amérique latine, Asie, Moyen-Orient, Afrique anglophone…) et autres surspécialités | V4 si des recommandations sont identifiées, avec un relecteur de la langue (D4) ; sinon V5 |
| **V5 — veille seulement** | 31 | Fédérations sans production propre (CLASA, FEPIMCTI, sections régionales WFSA…), sociétés de recherche, d’enseignement, de simulation ou d’histoire | Aucune production : surveillance annuelle |
| **Douleur** | 8 | IASP, EFIC, WIP, AAPM, FPM, ISSP, JSPC, SFETD | Décision D7 |
| **Paramédicaux** | 10 | IFNA, WFCCN, EfCCNa, AANA, AACN… (la SOFIA relève de la V0) | Décision d’ouvrir ces professions |

**Critère de sortie d’une vague** : les documents en vigueur inventoriés sont tous publiés ou écartés avec un motif (juridique, type, doublon), et les sources de la vague sont toutes inscrites dans la veille.

---

## 9. Chantier 4 — Veille

- Inscription dans `watch_sources` de chaque société ayant au moins un document, avec la méthode adaptée : flux RSS, sitemap, empreinte de la page des recommandations, requête PubMed ou Crossref (T11).
- Cycle mensuel du CDC §8, inchangé. Une nouveauté passe en tête de file, mais seulement si sa société appartient à une vague ouverte et si son profil juridique est validé. Sinon elle est enregistrée et signalée dans le compte rendu mensuel.
- Les organisations en V5 sont contrôlées une fois par an.

---

## 10. Indicateurs de pilotage

- Documents inventoriés, puis retenus, par vague.
- Part des profils juridiques validés, par vague ; nombre d’autorisations demandées, obtenues et refusées.
- Fiches produites, relues, publiées et en attente, par semaine ; délai entre production et publication.
- Points « À VÉRIFIER » ouverts.
- Encadrés « Recommandations divergentes » publiés.
- Taux de liens sources valides.
- Signalements d’erreur pour 1 000 consultations, par société.
- Effet commercial : fiches non SFAR consultées, conversions attribuées.

---

## 11. Risques et parades

| Risque | Parade |
|---|---|
| Publication d’une source sans droits | Verrou en base déjà en place, complété pour la traduction (T1) ; table de décision validée par un conseil ; autorisations écrites pour la V1 |
| Relecture débordée, qualité dégradée | Vagues ouvertes selon la capacité réelle ; relecture par lot (T10) ; aucune publication sans relecture tracée |
| Grade mal retranscrit (conventions hétérogènes) | Grade toujours verbatim ; contrôle automatique « grade présent dans la source » ; référentiel des systèmes (T6) |
| Doublons et co-publications affichés plusieurs fois | Identité par DOI (T4), rôles (T3) |
| Mauvaise société rattachée (sigles homonymes) | Slug unique (T2) |
| Contenu obsolète | Seuls les documents en vigueur sont traités ; veille mensuelle ; statut de fraîcheur |
| Dérive du périmètre face au test commercial | D1 : rien de nouveau n’est publié hors V0 avant le critère de passage |
| Dépendance à un seul relecteur par langue | Au moins deux relecteurs par langue publiée (CDC §9.4) |

---

## 12. Prochaines étapes proposées (2 à 4 semaines)

Réalisables sans attendre les décisions, car rien n’est publié :

1. **T1 — compléter le verrou** pour les sources non francophones (migration et tests).
2. **T2 et T3 — référentiel des sociétés** (slugs, rapprochement des 93 sigles déjà en base, rôles), puis import des 439 organisations au statut « à valider ».
3. **Inventaire V0 et V1** (chantier 1) : liste mesurée, document par document, avec licences Crossref.
4. **Table de décision juridique** mise en forme pour le conseil, avec modèles de demande d’autorisation en français et en anglais.

En attente d’arbitrage : D1 à D10 (section 2), en priorité **D1, D2 et D8**.
