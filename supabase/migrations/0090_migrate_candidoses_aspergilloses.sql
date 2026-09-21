-- Migration : Prise en charge des candidoses et aspergilloses invasives de
-- l'adulte — Conférence de Consensus commune SFAR / SPILF / SRLF, avec la
-- participation de la Société Française d'Hématologie, de la Société
-- Française de Mycologie Médicale et de la Société Française de Greffe de
-- Mœlle, 13 mai 2004 (Paris, Institut Pasteur). Texte « Résumé » (5
-- questions), pas le texte long/argumentaire.
-- Source : rfe-sfar-website/build/content_candidoses_aspergilloses.json.
--
-- SOCIÉTÉS — VÉRIFICATION EXPLICITE (liste complète du seed comparée mot à
-- mot, jamais une commande tronquée) : le colophon du contenu construit
-- ("Comité d'organisation : SFAR — ... ; SPILF — ... ; SRLF — ...") ne cite
-- QUE ces 3 sociétés comme organisatrices ; les 3 autres ("avec la
-- participation de...") sont des contributrices, pas des organisatrices.
-- SFAR, SPILF et SRLF sont TOUTES LES TROIS présentes dans le seed Annexe B
-- (`('SFAR','France')`, `('SPILF','France')`, `('SRLF','France')`,
-- confirmé par lecture intégrale de `schema_v2.sql` section 15, pas un
-- grep partiel) — les 3 sont donc liées en `document_societies`. Société
-- Française d'Hématologie, Société Française de Mycologie Médicale et
-- Société Française de Greffe de Mœlle sont ABSENTES du seed (aucune
-- entrée à un acronyme correspondant dans la liste complète des 18 lignes
-- du seed) — non liées, disclosed (elles ne sont de toute façon citées par
-- la source que comme participantes, pas comme organisatrices).
--
-- SPÉCIALITÉS — vérification explicite contre la liste complète des 76
-- slugs du seed Annexe A : `anesthesie_reanimation` (SFAR organisatrice,
-- prise en charge en réanimation explicitement dans le champ du texte),
-- `medecine_intensive_reanimation` (SRLF organisatrice, patients de
-- réanimation explicitement visés par le champ), `infectiologie_maladies_
-- infectieuses_et_tropicales` (SPILF organisatrice, sujet = infections
-- fongiques invasives) et `hematologie` (population d'hématologie
-- explicitement visée par le champ et par la Question 4.2 dédiée à la
-- chimio-prophylaxie en hématologie — même raisonnement que `anemie`/0007,
-- `civd`/0015, `tih`/0047 déjà migrés, qui lient tous `hematologie` sur ce
-- même critère). Pas de slug "mycologie"/"infectiologie fongique" dédié
-- dans le seed — `infectiologie_maladies_infectieuses_et_tropicales` est
-- le slug le plus proche existant.
--
-- MÉTHODOLOGIE DE GRADATION — VÉRIFIÉE LIGNE PAR LIGNE, PAS SUPPOSÉE GRADE
-- PAR DÉFAUT : ce texte « Résumé » cote certaines affirmations par un code
-- LETTRE+CHIFFRE entre crochets, imprimé en ligne dans le texte (ex. [A1],
-- [B2], [B3], [C3], [A2], ou un [A] SANS chiffre pour une occurrence en
-- Question 5) — CE N'EST NI GRADE 1+/1-/2+/2- (sepsis, sujet_age_esf...),
-- NI le système Grade A/B/C+Accord fort/faible (amygdalectomie_enfant),
-- NI le RAND/UCLA Delphi (brule_grave), NI l'absence totale de grade
-- (sauv/0084, ponction_lombaire/0075) : un système à part, propre à ce
-- document. Le contenu construit le disclose lui-même explicitement :
-- AUCUNE légende de ce code n'est publiée dans ce document « Résumé »
-- (elle figure vraisemblablement dans le texte long de la conférence, non
-- disponible pour cette migration). Décision disclosed : le code complet
-- (lettre+chiffre) est reproduit TEL QUEL dans `grade`, comme une unité
-- opaque — aucune signification n'est prêtée au chiffre (non défini par la
-- source elle-même, à la différence de `corticotherapie`/0017 où lettre et
-- chiffre sont deux axes explicitement distincts et nommés par la source).
-- `evidence_level` reste NULL sur les 59 lignes en conséquence. Une
-- affirmation sans code entre crochets n'est simplement pas cotée par la
-- source — `grade` NULL, jamais un grade inventé par défaut.
--
-- ⚠️ PIÈGE VÉRIFIÉ ET ÉVITÉ : le panneau méthodologique du contenu construit
-- lui-même utilise 3 codes ([A1], [B3], [C3]) à titre PUREMENT ILLUSTRATIF
-- pour expliquer la convention de coloration ("le texte source cote
-- certaines affirmations par un code lettre+chiffre entre parenthèses [A1]
-- [B3] [C3] — mais ce document ... n'en publie aucune légende"). Ces 3
-- occurrences NE SONT PAS rattachées à un énoncé clinique réel. Un
-- comptage brut des balises `<font color=` dans le JSON source donne 22
-- occurrences ; 22 - 3 (exemples du panneau méthodologique) = 19 codes
-- réellement rattachés à une recommandation, vérifiés un par un dans
-- l'ordre du document et retrouvés tous les 19 ci-dessous (répartition :
-- Q1 = 4, Q3 = 7, Q4 = 5, Q5 = 3).
--
-- PORTÉE DES CODES SUR LES DEUX ARBRES DÉCISIONNELS (Q3, 1.1.1 et 1.1.2) :
-- chaque arbre porte UN SEUL code [A1] imprimé sur son EN-TÊTE de
-- sous-section (pas un code par branche/cellule) — même convention que les
-- tableaux à grade de section déjà rencontrés dans ce corpus (ex.
-- `infarctus_myocarde`/0068, tableau tachycardies "grade B" appliqué à ses
-- 7 lignes). Ce grade d'en-tête est donc appliqué aux 7 lignes de l'arbre
-- 1.1.1 (R26-R32) et aux 5 lignes de l'arbre 1.1.2 (R33-R37) — ce n'est PAS
-- un grade individuellement réimprimé sur chaque branche, disclosed comme
-- tel, jamais un grade "par ligne" inventé indépendamment de la source.
--
-- CONTENU VOLONTAIREMENT NON MIGRÉ EN `recommendations` (disclosed, pas un
-- oubli) :
-- 1. Les deux tableaux de données de référence de la Question 2 (« Spectre
--    d'activité » page 3 — sensibilité S/I/R/SDD par espèce x antifongique,
--    y compris 2 cellules avec une incertitude non levée par la source
--    elle-même « S/ ?? » — et « Voies d'administration et effets
--    indésirables » page 4) : ce sont des données de référence
--    pharmacologiques (profils de sensibilité in vitro, effets
--    indésirables), pas des recommandations d'action graduées — même
--    traitement que le Tableau 1 (définitions) exclu dans
--    `sepsis_hemodynamique`/0045 ou l'Annexe 1 (échelle de gradation HAS)
--    exclue dans `infarctus_myocarde`/0068. Ces deux tableaux restent
--    reproduits verbatim dans le contenu HTML de la fiche (règle 1 du
--    cahier des charges qualité du projet), simplement absents du modèle
--    SQL `recommendations`, qui est réservé aux énoncés actionnables.
--    L'unique note actionnable rattachée à ce second tableau (relais oral
--    précoce chez l'insuffisant rénal pour Sporanox®/Vfend®, note "*") EST
--    en revanche migrée individuellement (R25), car c'est un énoncé d'action
--    à part entière, pas une donnée de la grille elle-même.
-- 2. Phrases purement descriptives/épidémiologiques ou d'incertitude
--    d'évaluation, sans formulation actionnable ("il faut/il est
--    recommandé de faire X") : ex. "l'antigénémie précède souvent les
--    signes radiologiques ... sa valeur prédictive reste à préciser",
--    "hors hématologie, la valeur diagnostique de l'antigénémie est moins
--    bien précisée", "la recherche couplée d'anticorps circulants ...
--    intérêt doit être confirmé", "les techniques de biologie moléculaire
--    ... non standardisées et non disponibles en routine" (Q1) ; "le taux
--    de réponse avec l'itraconazole varie de 39 à 63 % dans des essais non
--    contrôlés", "le seul essai avec la caspofungine ... rapporte 45 % de
--    réponses favorables" (Q5, données d'essais cliniques, pas des
--    directives) ; "les nouveaux antifongiques injectables sont coûteux
--    (500-650 €/jour)" (Q2, aspect médico-économique, pas clinique).
-- 3. Absence de recommandation formulée faute de données, disclosed par la
--    source elle-même — même traitement que `thrombectomie`/0082 (2
--    questions sans recommandation, non migrées) et `echo_acces_
--    vasculaires`/0078 R7 : "Aucune donnée n'est actuellement disponible
--    avec le voriconazole" en chimio-prophylaxie primaire (Q4) et "Aucune
--    étude contrôlée n'a été réalisée avec l'adjonction du G-CSF" (Q5) —
--    aucune position de la source à reproduire comme recommandation.
--
-- ⚠️ INCOHÉRENCE INTERNE DE LA SOURCE DISCLOSED, NON RÉSOLUE (R42) : la
-- durée de traitement de la candidose hépato-splénique ("6 mois en
-- moyenne") N'EST PAS cotée par un code lettre+chiffre dans le texte
-- source, À LA DIFFÉRENCE des phrases voisines sur le même thème
-- (candidémie 1.2.1, autres localisations 1.2.3, toutes deux cotées) —
-- disclosure déjà faite par le contenu construit lui-même, reproduite
-- sans tentative de deviner un code qui n'existe pas dans la source.
--
-- -- A VERIFIER (R50, ambiguïté non résolue, PAS devinée) : le contenu
-- construit annote lui-même la clause C3 sur la restriction de
-- l'itraconazole en chimio-prophylaxie primaire (Q4.2.1) d'un commentaire
-- affirmant que « deux cotations distinctes [sont] fusionnées en une seule
-- phrase dans le texte source, scindées ici en deux affirmations » — or le
-- JSON fourni pour cette migration ne contient qu'UNE SEULE situation
-- clinique nommée ("corticothérapie prolongée post-allogreffe de CSH") en
-- regard de ce commentaire, jamais une deuxième. Impossible de déterminer,
-- à partir du seul contenu construit disponible ici, si une deuxième
-- clause a été omise de l'extraction JSON ou si ce commentaire est un
-- reliquat d'une version antérieure du script de construction de la fiche.
-- Une seule ligne (R50) est migrée, pour la seule situation clinique
-- effectivement présente dans le contenu — AUCUNE deuxième situation n'est
-- inventée par cette migration. À corriger par un relecteur humain ayant
-- accès au PDF source complet (`sources/candidoses_aspergilloses.txt` côté
-- rfe-sfar-website, non consulté directement pour cette migration SQL, qui
-- travaille uniquement à partir du `content_*.json` déjà construit).
--
-- SOURCE_URL / PDF_URL : `library_final.json` (recherche "candidose"/
-- "aspergillose" — EXACTEMENT 1 correspondance, vérifiée par grep sur
-- l'intégralité du fichier, `"title": "Prise en charge des candidoses et
-- aspergilloses invasives de l'adulte"`, `exact_type: "CC"`, `exact_date:
-- "2004"`, `status: "en vigueur"` — pas "abrogé", construction autorisée)
-- donne `href` (page HTML dédiée) et `direct_pdf_url` (fichier PDF),
-- valeurs DIFFÉRENTES ici (contrairement à `sauv`/0084 où elles étaient
-- identiques) : `href` utilisé pour `source_url` (convention dominante du
-- corpus — page de citation officielle), `direct_pdf_url` pour `pdf_url`.
-- Note : le colophon du contenu construit lui-même labellise sa propre
-- « URL source » avec la valeur du PDF (`direct_pdf_url`), pas avec
-- `href` — divergence de libellé interne à la fiche, disclosed, non jugée
-- bloquante (les deux URLs pointent vers le même document sfar.org, la
-- page HTML étant simplement la page de renvoi vers le PDF).
-- `publication_date` = 2004-05-13 ("13 mai 2004, Paris, Institut
-- Pasteur", donnée précise du contenu construit lui-même, plus fine que
-- `exact_date: "2004"` de `library_final.json`).
--
-- `doc_type` = 'CC' (Conférence de Consensus — `exact_type` de
-- `library_final.json`, cohérent avec l'auto-désignation de la source
-- elle-même et le vocabulaire déjà utilisé pour `corticotherapie`/0017,
-- `civd`/0015, `sepsis_hemodynamique`/0045, etc.).
--
-- `freshness_status` = 'revision_detectee' : la fiche construite porte son
-- propre avertissement explicite en fin de document ("les posologies,
-- spectres de sensibilité et stratégies antifongiques ayant
-- considérablement évolué depuis 2004 (nouvelles molécules, résistances
-- émergentes, recommandations plus récentes), se référer impérativement à
-- un avis spécialisé et aux recommandations actualisées") — même critère
-- que `avc_precoce`/0069, `infarctus_myocarde`/0068, `monitorage_
-- traumatise`/0067 (disclosure explicite d'obsolescence par la source/la
-- fiche elle-même, pas une supposition de cette migration).
--
-- Vérification anti-doublon : `grep -rli "candidos\|aspergillos\|mycos\|
-- antifongiq"` sur `supabase/migrations/` (avant écriture de ce fichier)
-- ne retourne aucune migration existante couvrant ce document sous une
-- autre clé — première migration de ce sujet.
--
-- `population` renseigné uniquement quand la source restreint
-- explicitement une affirmation à une sous-population nommée (patient
-- d'hématologie, allogreffe de CSH, leucémies aiguës/autogreffes,
-- insuffisant rénal) ; NULL partout ailleurs (critères de situation
-- clinique — créatininémie, neutropénie, azolé antérieur — portés par
-- `condition_topic`/`statement`, pas par `population`, qui n'est pas un
-- axe démographique dans ces cas).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge des candidoses et aspergilloses invasives de l''adulte',
  'CC', 'fr', '2004-05-13',
  'https://sfar.org/prise-en-charge-des-candidoses-et-aspergilloses-invasives-de-ladulte/',
  'https://sfar.org/wp-content/uploads/2015/10/2_SFAR_Prise-en-charge-des-candidoses-et-aspergilloses-invasives-de-ladulte.pdf',
  'Conférence de Consensus — cotation par code lettre+chiffre entre crochets (A1, A2, B2, B3, C3…, ou une occurrence "A" seule sans chiffre) directement dans le texte, SANS légende publiée dans ce document "Résumé". Le code complet est reproduit tel quel dans `grade`, comme unité opaque ; aucune signification n''est prêtée au chiffre (non défini par la source) ; `evidence_level` NULL sur toutes les lignes. 3 occurrences de code dans le panneau méthodologique du contenu construit sont des exemples illustratifs de la convention de coloration, pas des grades réels (disclosure intégrale en commentaire de migration). 19 codes réels recensés un par un (Q1=4, Q3=7, Q4=5, Q5=3) ; une affirmation sans code n''est simplement pas cotée par la source (`grade` NULL).',
  'revision_detectee'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-des-candidoses-et-aspergilloses-invasives-de-ladulte/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'), ('SPILF', 'France'), ('SRLF', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-des-candidoses-et-aspergilloses-invasives-de-ladulte/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'infectiologie_maladies_infectieuses_et_tropicales', 'hematologie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.condition_topic, v.source_section,
  'https://sfar.org/prise-en-charge-des-candidoses-et-aspergilloses-invasives-de-ladulte/',
  'draft'
from public.documents d, (values
  -- Question 1 — Diagnostic et suivi des candidoses et aspergilloses invasives
  ('MG-ANES-000090-R01', 'La recherche de levures et de champignons filamenteux (examen mycologique) doit être systématique chez les patients à risque.', null, null, 'Dépistage mycologique systématique', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R02', 'L''examen direct doit être systématique et réalisé rapidement, avec des techniques spécifiques : il oriente le diagnostic et peut rester, dans certains cas, le seul argument biologique disponible.', null, null, 'Examen direct — systématique et rapide', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R03', 'La présence de Candida sp. dans les sécrétions des voies aériennes inférieures (y compris le lavage broncho-alvéolaire) n''a pas de valeur diagnostique.', 'B3', null, 'Candida sp. dans les sécrétions respiratoires — absence de valeur diagnostique', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R04', 'La présence d''Aspergillus sp. dans les sécrétions respiratoires est à interpréter en fonction du risque de colonisation bronchique et du degré d''immunodépression ; elle est prédictive d''aspergillose pulmonaire invasive chez le patient d''hématologie.', 'B2', null, 'Aspergillus sp. dans les sécrétions respiratoires — interprétation', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R05', 'Une seule hémoculture positive à Candida sp. suffit au diagnostic de candidose invasive (les hémocultures ne sont positives que dans environ 50 % des candidoses invasives).', null, null, 'Hémocultures — Candida sp.', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R06', 'Sauf exception, la présence d''Aspergillus sp. en hémoculture correspond à une contamination, non à une aspergillose invasive.', null, null, 'Hémocultures — Aspergillus sp.', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R07', 'Utiliser le milieu de Sabouraud comme milieu de référence, incubé à 30 °C pendant 21 jours, pour la culture mycologique (Candida sp. et Aspergillus sp. se développent le plus souvent aussi sur les milieux usuels de bactériologie).', null, null, 'Culture — milieu de référence', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R08', 'L''identification au niveau de l''espèce doit être réalisée pour tous les champignons isolés.', null, null, 'Identification de l''espèce — systématique', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R09', 'En hématologie, utiliser l''antigénémie aspergillaire par technique ELISA : examen sensible lorsqu''il est répété, spécifique s''il est confirmé par un deuxième prélèvement à 24-48 heures.', 'A1', 'Patient d''hématologie', 'Antigénémie aspergillaire (ELISA)', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R10', 'Pour Candida sp., utiliser la méthode Etest® (réalisable en routine, seule méthode actuellement corrélée à la méthode de référence NCCLS) pour déterminer les concentrations minimales inhibitrices (CMI) du fluconazole, de l''itraconazole et de la flucytosine.', 'B2', null, 'Antifongigramme — Etest® (Candida sp.)', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R11', 'Pour Aspergillus sp., l''intérêt de la détermination des concentrations minimales inhibitrices (CMI) n''est pas confirmé.', null, null, 'Antifongigramme — Aspergillus sp.', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R12', 'Le choix de l''antifongique repose avant tout sur la connaissance de l''épidémiologie locale et/ou de l''espèce isolée.', null, null, 'Choix de l''antifongique — épidémiologie locale/espèce', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R13', 'Réaliser précocement une TDM thoracique en haute résolution pour l''imagerie de l''aspergillose pulmonaire invasive (la radiographie de thorax standard est peu sensible et peu spécifique).', null, null, 'Imagerie de l''API — TDM thoracique HR précoce', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R14', 'Chez le patient d''hématologie en aplasie post-chimiothérapie, le signe du halo au scanner — précoce mais transitoire — est très évocateur d''aspergillose pulmonaire invasive ; en dehors de cette population, il est moins spécifique.', null, 'Patient d''hématologie en aplasie post-chimiothérapie', 'Imagerie de l''API — signe du halo', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R15', 'Injecter un produit de contraste lors de la TDM thoracique pour préciser les rapports entre lésions et structures vasculaires (indication chirurgicale), guider une éventuelle ponction diagnostique, suivre l''évolution et faire le bilan des lésions résiduelles en vue d''une éventuelle chirurgie de propreté.', null, null, 'Imagerie de l''API — injection de produit de contraste', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R16', 'Réaliser une TDM des sinus à la recherche d''une lyse osseuse (invasion loco-régionale).', null, null, 'Imagerie — TDM des sinus', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R17', 'Dans l''aspergillose cérébrale, l''IRM est l''examen le plus sensible.', null, null, 'Imagerie — aspergillose cérébrale (IRM)', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R18', 'En cas de candidémie, réaliser systématiquement un examen ophtalmologique.', null, null, 'Candidémie — examen ophtalmologique systématique', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R19', 'En cas de candidémie, l''échographie et/ou la TDM sont utiles pour rechercher des métastases septiques, en particulier lors de la sortie d''aplasie.', null, null, 'Candidémie — recherche de métastases septiques', 'Question 1 — Diagnostic et suivi'),
  ('MG-ANES-000090-R20', 'Dans les candidoses hépato-spléniques, l''IRM semble être l''examen le plus sensible.', null, null, 'Candidose hépato-splénique — imagerie (IRM)', 'Question 1 — Diagnostic et suivi'),
  -- Question 2 — Moyens thérapeutiques disponibles (tableaux de référence exclus, cf. disclosure en tête de fichier)
  ('MG-ANES-000090-R21', 'Le suivi des concentrations plasmatiques à l''équilibre (dosage pharmacologique) est pertinent pour l''itraconazole (variabilité d''absorption et de métabolisme hépatique, interactions médicamenteuses fréquentes), le voriconazole (15 à 20 % de métaboliseurs lents chez les patients d''origine asiatique, interactions médicamenteuses fréquentes) et la flucytosine (toxicité dose-dépendante).', null, null, 'Suivi thérapeutique pharmacologique', 'Question 2 — Moyens thérapeutiques disponibles'),
  ('MG-ANES-000090-R22', 'La prescription d''amphotéricine B (Fungizone®) est déconseillée en association avec d''autres médicaments néphrotoxiques (aminosides, ciclosporine…), avec les digitaliques et avec les diurétiques hypokaliémiants.', null, null, 'Interactions médicamenteuses — amphotéricine B', 'Question 2 — Moyens thérapeutiques disponibles'),
  ('MG-ANES-000090-R23', 'Le voriconazole est contre-indiqué en co-prescription avec le sirolimus et avec les inducteurs enzymatiques susceptibles d''en diminuer les concentrations plasmatiques (rifampicine, carbamazépine, phénobarbital).', null, null, 'Interactions médicamenteuses — voriconazole', 'Question 2 — Moyens thérapeutiques disponibles'),
  ('MG-ANES-000090-R24', 'Le fluconazole, l''amphotéricine B liposomale (Ambisome®) et la caspofungine ne présentent pas d''interactions majeures à l''origine de contre-indications.', null, null, 'Interactions médicamenteuses — absence d''interactions majeures', 'Question 2 — Moyens thérapeutiques disponibles'),
  ('MG-ANES-000090-R25', 'Chez l''insuffisant rénal, privilégier un relais oral précoce pour l''itraconazole (Sporanox®) et le voriconazole (Vfend®), en raison de l''accumulation d''un excipient toxique de la forme intraveineuse.', null, 'Insuffisant rénal', 'Relais oral précoce — insuffisance rénale', 'Question 2 — Moyens thérapeutiques disponibles'),
  -- Question 3 — Stratégie thérapeutique des candidoses systémiques : arbre 1.1.1 (avant identification de l'espèce), grade A1 d'en-tête appliqué aux 7 branches
  ('MG-ANES-000090-R26', 'Avant identification de l''espèce, chez un patient avec créatininémie < 1,5 N, neutropénique et moins de 2 traitements néphrotoxiques associés : utiliser l''amphotéricine B (Fungizone®) IV 1 mg/kg/j.', 'A1', null, 'Choix du traitement avant identification de l''espèce', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 1.1.1'),
  ('MG-ANES-000090-R27', 'Avant identification de l''espèce, chez un patient avec créatininémie < 1,5 N, neutropénique et 2 traitements néphrotoxiques associés ou plus : utiliser la caspofungine (Cancidas®) IV (70 mg à J1 puis 50 mg/j) ou l''amphotéricine B liposomale (Ambisome®) IV 3 mg/kg/j.', 'A1', null, 'Choix du traitement avant identification de l''espèce', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 1.1.1'),
  ('MG-ANES-000090-R28', 'Avant identification de l''espèce, chez un patient avec créatininémie < 1,5 N, non-neutropénique, sans traitement antérieur par azolé : utiliser l''amphotéricine B (Fungizone®) IV 1 mg/kg/j ou le fluconazole (Triflucan®) IV 12 mg/kg/j.', 'A1', null, 'Choix du traitement avant identification de l''espèce', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 1.1.1'),
  ('MG-ANES-000090-R29', 'Avant identification de l''espèce, chez un patient avec créatininémie < 1,5 N, non-neutropénique, avec un traitement antérieur par azolé : utiliser l''amphotéricine B (Fungizone®) IV 1 mg/kg/j.', 'A1', null, 'Choix du traitement avant identification de l''espèce', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 1.1.1'),
  ('MG-ANES-000090-R30', 'Avant identification de l''espèce, chez un patient avec créatininémie ≥ 1,5 N, non-neutropénique, sans traitement antérieur par azolé : utiliser le fluconazole (Triflucan®) IV 12 mg/kg/j.', 'A1', null, 'Choix du traitement avant identification de l''espèce', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 1.1.1'),
  ('MG-ANES-000090-R31', 'Avant identification de l''espèce, chez un patient avec créatininémie ≥ 1,5 N, non-neutropénique, avec un traitement antérieur par azolé : utiliser la caspofungine (Cancidas®) IV (70 mg à J1 puis 50 mg/j) ou l''amphotéricine B liposomale (Ambisome®) IV 3 mg/kg/j.', 'A1', null, 'Choix du traitement avant identification de l''espèce', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 1.1.1'),
  ('MG-ANES-000090-R32', 'Avant identification de l''espèce, chez un patient avec créatininémie ≥ 1,5 N et neutropénique (quel que soit le statut vis-à-vis des traitements néphrotoxiques) : utiliser la caspofungine (Cancidas®) IV (70 mg à J1 puis 50 mg/j) ou l''amphotéricine B liposomale (Ambisome®) IV 3 mg/kg/j.', 'A1', null, 'Choix du traitement avant identification de l''espèce', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 1.1.1'),
  -- arbre 1.1.2 (après identification de l'espèce), grade A1 d'en-tête appliqué aux 5 branches
  ('MG-ANES-000090-R33', 'Après identification de l''espèce, pour un Candida sensible au fluconazole (neutropénique ou non) : utiliser le fluconazole (Triflucan®) IV 6 mg/kg/j, avec relais per os dès que possible.', 'A1', null, 'Choix du traitement après identification de l''espèce', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 1.1.2'),
  ('MG-ANES-000090-R34', 'Après identification de l''espèce, pour un Candida résistant au fluconazole ou de sensibilité dose-dépendante (SDD), chez un patient non-neutropénique avec créatininémie < 1,5 N : utiliser l''amphotéricine B (Fungizone®) IV 1 mg/kg/j.', 'A1', null, 'Choix du traitement après identification de l''espèce', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 1.1.2'),
  ('MG-ANES-000090-R35', 'Après identification de l''espèce, pour un Candida résistant au fluconazole ou SDD, chez un patient neutropénique avec créatininémie < 1,5 N et moins de 2 traitements néphrotoxiques associés : utiliser l''amphotéricine B (Fungizone®) IV 1 mg/kg/j.', 'A1', null, 'Choix du traitement après identification de l''espèce', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 1.1.2'),
  ('MG-ANES-000090-R36', 'Après identification de l''espèce, pour un Candida résistant au fluconazole ou SDD, chez un patient neutropénique avec créatininémie < 1,5 N et 2 traitements néphrotoxiques associés ou plus : utiliser la caspofungine (Cancidas®) IV 50 mg/j ou l''amphotéricine B liposomale (Ambisome®) IV 3 mg/kg/j, ou, s''il s''agit de C. krusei, le voriconazole (Vfend®) 12 mg/kg/j à J1 puis 8 mg/kg/j.', 'A1', null, 'Choix du traitement après identification de l''espèce', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 1.1.2'),
  ('MG-ANES-000090-R37', 'Après identification de l''espèce, pour un Candida résistant au fluconazole ou SDD, avec créatininémie ≥ 1,5 N (neutropénique ou non) : utiliser la caspofungine (Cancidas®) IV 50 mg/j ou l''amphotéricine B liposomale (Ambisome®) IV 3 mg/kg/j, ou, s''il s''agit de C. krusei, le voriconazole (Vfend®) 12 mg/kg/j à J1 puis 8 mg/kg/j.', 'A1', null, 'Choix du traitement après identification de l''espèce', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 1.1.2'),
  ('MG-ANES-000090-R38', 'Pour toutes les situations ci-dessus hors Candida sensible au fluconazole, un relais par voriconazole (Vfend®) par voie orale peut être effectué si l''infection paraît contrôlée.', null, null, 'Relais oral — voriconazole', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 1.1.2 (note du schéma)'),
  ('MG-ANES-000090-R39', 'En cas de candidémie, il n''y a pas d''argument pour une association d''antifongiques (sauf certaines localisations spécifiques : oculaire, méningée, cardiaque).', 'B3', null, 'Candidémie — pas d''association systématique', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 1.2.1'),
  ('MG-ANES-000090-R40', 'En cas de candidémie, la durée de traitement est de 2 semaines après la dernière hémoculture positive et la disparition des symptômes, ou d''au moins 7 jours après la correction de la neutropénie.', 'C3', null, 'Candidémie — durée de traitement', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 1.2.1'),
  ('MG-ANES-000090-R41', 'En cas de candidémie, le retrait du cathéter intravasculaire est recommandé.', 'B3', null, 'Candidémie — retrait du cathéter', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 1.2.1'),
  ('MG-ANES-000090-R42', 'Dans la candidose hépato-splénique (chronique disséminée), la durée du traitement est de 6 mois en moyenne.', null, null, 'Candidose hépato-splénique — durée de traitement', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 1.2.2'),
  ('MG-ANES-000090-R43', 'Dans les localisations oculaires, méningées et cardiaques (associées ou non à une candidémie), l''association amphotéricine B + flucytosine est proposée (les durées de traitement y sont souvent plus prolongées).', 'B3', null, 'Localisations oculaire/méningée/cardiaque — association thérapeutique', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 1.2.3'),
  ('MG-ANES-000090-R44', 'En réanimation, un traitement antifongique préemptif peut être instauré, malgré l''absence de validation formelle, devant un tableau septique préoccupant sans autre documentation microbiologique, une colonisation de plusieurs sites par Candida sp. et des facteurs de risque de candidose invasive (mêmes schémas thérapeutiques que pour une candidose documentée).', 'C3', null, 'Traitement préemptif en réanimation', 'Question 3 — Stratégie thérapeutique des candidoses systémiques, 2'),
  -- Question 4 — Chimio-prophylaxie antifongique en réanimation et en hématologie
  ('MG-ANES-000090-R45', 'En réanimation, il n''y a pas d''argument en faveur de l''utilisation d''une chimioprophylaxie antifongique.', 'A2', null, 'Chimioprophylaxie en réanimation', 'Question 4 — Chimio-prophylaxie, 1'),
  ('MG-ANES-000090-R46', 'L''amphotéricine B, quelle que soit sa voie d''administration (respiratoire ou veineuse) ou sa formulation, ne réduit pas l''incidence des infections fongiques invasives en chimioprophylaxie.', null, null, 'Chimioprophylaxie primaire — amphotéricine B inefficace', 'Question 4 — Chimio-prophylaxie, 2.1'),
  ('MG-ANES-000090-R47', 'Dans l''allogreffe de cellules souches hématopoïétiques, le fluconazole (400 mg/j) est recommandé en chimioprophylaxie primaire car il réduit la fréquence des candidoses invasives et leur mortalité.', 'A1', 'Allogreffe de cellules souches hématopoïétiques (CSH)', 'Chimioprophylaxie primaire — fluconazole', 'Question 4 — Chimio-prophylaxie, 2.1'),
  ('MG-ANES-000090-R48', 'Pour les leucémies aiguës et les autogreffes, l''incidence habituelle des candidoses invasives n''a pas permis de documenter l''intérêt d''une chimioprophylaxie, et le fluconazole n''est pas recommandé dans cette indication.', null, 'Leucémies aiguës et autogreffes', 'Chimioprophylaxie primaire — fluconazole non recommandé', 'Question 4 — Chimio-prophylaxie, 2.1'),
  ('MG-ANES-000090-R49', 'L''itraconazole peut également être prescrit en chimioprophylaxie primaire dans l''allogreffe de cellules souches hématopoïétiques.', 'A1', 'Allogreffe de cellules souches hématopoïétiques (CSH)', 'Chimioprophylaxie primaire — itraconazole', 'Question 4 — Chimio-prophylaxie, 2.1'),
  ('MG-ANES-000090-R50', 'En raison de sa difficulté d''utilisation, la prescription d''itraconazole en chimioprophylaxie doit être restreinte à certaines situations à risque, dont la corticothérapie prolongée post-allogreffe de cellules souches hématopoïétiques. -- A VERIFIER: le contenu construit signale une deuxième situation clinique fusionnée dans la phrase source, jamais nommée dans le JSON fourni ici — non devinée, voir disclosure en tête de fichier.', 'C3', null, 'Chimioprophylaxie primaire — restriction de l''itraconazole', 'Question 4 — Chimio-prophylaxie, 2.1'),
  ('MG-ANES-000090-R51', 'La chimioprophylaxie secondaire doit être systématique, utiliser une molécule active vis-à-vis du champignon précédemment isolé ou suspecté, et couvrir toute la période d''immunodépression.', 'C3', null, 'Chimioprophylaxie secondaire', 'Question 4 — Chimio-prophylaxie, 2.2'),
  -- Question 5 — Stratégie thérapeutique des aspergilloses invasives
  ('MG-ANES-000090-R52', 'Parmi les polyènes, l''amphotéricine B liposomale (Ambisome®) a démontré sa supériorité sur l''amphotéricine B désoxycholate dans un essai randomisé prospectif ; les autres études démontrent une meilleure tolérance des formes lipidiques.', 'A', null, 'Aspergillose invasive — polyènes, ABLp vs AmB', 'Question 5 — Stratégie thérapeutique des aspergilloses invasives, 1'),
  ('MG-ANES-000090-R53', 'Le voriconazole (IV puis relais per os) est proposé comme traitement de première ligne de l''aspergillose invasive, sur la base d''un essai randomisé le comparant à l''amphotéricine B.', 'A1', null, 'Aspergillose invasive — traitement de première ligne (voriconazole)', 'Question 5 — Stratégie thérapeutique des aspergilloses invasives, 2'),
  ('MG-ANES-000090-R54', 'En deuxième intention, utiliser l''amphotéricine B liposomale (3 ou 5 mg/kg/jour) ou la caspofungine.', null, null, 'Aspergillose invasive — traitement de deuxième intention', 'Question 5 — Stratégie thérapeutique des aspergilloses invasives, 2'),
  ('MG-ANES-000090-R55', 'L''itraconazole IV pourrait constituer une alternative thérapeutique dans l''aspergillose invasive.', null, null, 'Aspergillose invasive — itraconazole IV, alternative', 'Question 5 — Stratégie thérapeutique des aspergilloses invasives, 2'),
  ('MG-ANES-000090-R56', 'Chez les malades dont l''infection paraît contrôlée, un relais par voie orale (voriconazole ou itraconazole) peut être effectué.', 'C3', null, 'Aspergillose invasive — relais oral', 'Question 5 — Stratégie thérapeutique des aspergilloses invasives, 2'),
  ('MG-ANES-000090-R57', 'Le traitement de l''aspergillose invasive doit être poursuivi jusqu''à la guérison et la disparition des facteurs prédisposants.', null, null, 'Aspergillose invasive — durée du traitement', 'Question 5 — Stratégie thérapeutique des aspergilloses invasives, 2'),
  ('MG-ANES-000090-R58', 'L''efficacité clinique des associations d''antifongiques dans l''aspergillose invasive n''a pas été démontrée dans des études prospectives ; leur place reste inconnue et certaines associations peuvent être potentiellement antagonistes, toxiques et coûteuses.', null, null, 'Aspergillose invasive — associations d''antifongiques, absence de preuve', 'Question 5 — Stratégie thérapeutique des aspergilloses invasives, 1-2'),
  ('MG-ANES-000090-R59', 'Un geste chirurgical peut être nécessaire dans l''aspergillose invasive : en urgence pour l''exérèse de lésions pulmonaires au contact d''un gros vaisseau, secondairement en cas de lésion persistante circonscrite avant un nouveau traitement aplasiant, ou en cas de non-réponse au traitement à visée de diagnostic mycologique formel.', null, null, 'Aspergillose invasive — indications chirurgicales', 'Question 5 — Stratégie thérapeutique des aspergilloses invasives, 3')
) as v(code, statement, grade, population, condition_topic, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-des-candidoses-et-aspergilloses-invasives-de-ladulte/'
on conflict (recommendation_code) do nothing;
