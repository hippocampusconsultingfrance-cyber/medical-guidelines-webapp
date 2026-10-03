# Vague 0 — inventaire et socle (03/10/2026)

Préparation de la vague 0 du plan d’intégration (`PLAN_INTEGRATION_SOCIETES_SAVANTES.md`, sections 3, 4 et 8). **Rien n’est publié** : les fiches de la vague 0 restent à rédiger, puis à relire et à valider par un médecin, et leur registre juridique reste à remplir.

## 1. Inventaire mesuré (chantier 1, première passe)

Le fichier `inventaire-recommandations-v0.csv` contient une ligne par document. Il a été produit par `scripts/inventaire/` : requête PubMed par société (recommandations, consensus et conférences de consensus, 2010-2026), licence lue sur Crossref, dédoublonnage par DOI. Les homonymes de sigle ont été écartés : GRACE désigne aussi un registre coronarien et des recommandations américaines d’urgence, CARO un groupe de radiothérapie, CFAR un centre de recherche sur le VIH.

| Société | Documents repérés |
|---|---:|
| SRLF | 40 |
| SFMU | 27 |
| GFRUP | 12 |
| GIHP | 12 |
| ADARPEF | 5 |
| ANARLF | 3 |
| CARO | 2 |
| ARCOTHOVA, CFAR, CFRC, GRACE, SFB, SOFIA | 0 sur PubMed : leurs recommandations sont publiées sur leur site, à inventorier à la main |

**Au total, 72 documents** :

- **31 sont déjà couverts** par une fiche du site (colonne `au_catalogue`), souvent parce qu’ils sont co-signés par la SFAR.
- **41 sont « à examiner »**. Ce sont les candidats à de nouvelles fiches, par exemple :
  - choc cardiogénique (2026) ;
  - trachéotomie, soins et sevrage (2026) ;
  - détresse respiratoire aux urgences (2026) ;
  - épuration extrarénale SRLF-GFRUP (2025) ;
  - nutrition en réanimation SRLF-GFRUP (2025) ;
  - oxygénothérapie SRLF-SFMU (2024) ;
  - pneumothorax spontané (2023) ;
  - insuffisance cardiaque du sujet âgé aux urgences (2023) ;
  - cathéters intravasculaires (2020) ;
  - acidose métabolique (2019) ;
  - LAT en réanimation pédiatrique (2021) ;
  - don d’organes Maastricht III pédiatrique (2022).

**Licences relevées sur Crossref** :

| Licence | Documents |
|---|---:|
| CC BY 4.0 | 20 |
| CC BY-NC-ND 4.0 | 17 |
| Droits réservés de l’éditeur | 25 |
| Accès ouvert Elsevier, à préciser | 6 |
| Non renseignée | 3 |
| CC BY 2.0 | 1 |

Ces licences alimentent la table de décision juridique (D2) ; elles ne valent pas autorisation de reprise.

**Limites de cette première passe** :

- Certains résultats sont hors sujet et seront écartés au contrôle humain : une étude pédiatrique sur le pneumothorax, une recommandation allemande, une déclaration ATS de 2010.
- Plusieurs lignes peuvent être des versions d’un même texte (traduction française, publication dans deux revues).
- Les textes publiés seulement sur les sites des sociétés (PDF, espaces membres) ne sont pas encore recensés.

## 2. Socle technique (lot 0, T2 et T3)

La migration `20261003100000_referentiel_societes.sql` ajoute trois choses :

- **un `slug` unique pour chaque société**, calculé à partir du sigle. En cas d’homonymie, on ajoute le code pays (`asa-us`, `asa-au`), sinon un numéro ;
- **un code pays ISO** (`FR`, `US`…) ;
- **le rôle de chaque société sur un document** : auteur (la société porteuse), co-auteur, ou approbation (décision D10).

Le script de contenu `0202_societes_vague0.sql` complète les sociétés de la vague 0, plus la HAS, la SFMU, le CARORL et l’ARMPO :

- il renseigne le pays France, le code FR et le site officiel quand ils manquent ;
- il crée, au statut « à valider », les sociétés absentes de la base : ARCOTHOVA, CFAR, CFRC, GRACE, SOFIA ;
- il ne remplace jamais un nom déjà saisi.

Les vérifications automatiques de la base (`tests/base/parcours.sql`, section 25) couvrent ces règles.

## 3. Points à trancher par l’équipe éditoriale

- **Noms complets** : la base et le référentiel divergent pour le CARO (« Club » dans la base, « Collège » sur le site officiel) et pour l’ANARLF. Le nom de la base est conservé jusqu’à vérification.
- **Statut des sociétés** : il reste « à valider » ; leur validation (`vetting_status`) relève de l’équipe éditoriale.
- **Prochaines étapes du plan** :
  - T5 : profil juridique par société, hérité par chaque fiche ;
  - T9 : atelier multi-sociétés ;
  - contrôle humain d’un échantillon de l’inventaire ;
  - recensement des textes publiés seulement sur les sites des sociétés.
