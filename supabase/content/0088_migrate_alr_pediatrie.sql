-- Migration : Anesthésie loco-régionale en pédiatrie — Recommandations
-- Formalisées d'Experts, SFAR en collaboration avec l'ADARPEF (Association
-- des Anesthésistes Réanimateurs Pédiatriques d'Expression Française), 2010
-- (actualisation de la Conférence d'Experts SFAR 1997).
-- Source : rfe-sfar-website/build/content_alr_pediatrie.json (3 fichiers de
-- section — Q1-2 anesthésiques locaux/adjuvants, Q3-5 localisation/
-- matériels/complications, Q6 choix de la technique + sources —, 6
-- Questions numérotées §1 à §6, chaque puce porteuse d'une puce de force
-- FORT/OPT étant déjà atomique).
--
-- SOURCE_URL / PDF_URL / DATE : `library_final.json` (recherche
-- "Anesthésie loco-régionale en pédiatrie" — exactement 1 correspondance,
-- confirmé par grep intégral, pas une commande tronquée) donne `href`
-- ("https://sfar.org/anesthesie-loco-regionale-en-pediatrie/"),
-- `direct_pdf_url`
-- ("https://sfar.org/wp-content/uploads/2015/09/2_SFAR_Anesthesie-loco-regionale-en-pediatrie.pdf"),
-- `exact_type` "RFE" et `status` "en vigueur" (pas "abrogé" — migration
-- autorisée). `href` est utilisé ci-dessous comme `source_url` (convention
-- de ce dépôt, cf. 0086/0080) et `direct_pdf_url` comme `pdf_url` — note :
-- le panneau "Sources et traçabilité" du contenu construit lui-même
-- libelle son propre champ "URL source" avec la valeur du PDF direct (pas
-- le `href` de la page d'atterrissage) ; les deux URLs de
-- `library_final.json` sont néanmoins correctement réparties entre
-- `source_url`/`pdf_url` ci-dessous, aucune perte d'information. `exact_date`
-- ne donne que l'année ("2010", ni mois ni jour) — `publication_date`
-- utilise 2010-01-01 par convention, même traitement que
-- `allergie_prevention`/0006, `examens_preinterventionnels`/0065 et
-- `douleur_postoperatoire`/0071.
--
-- DOUBLON VÉRIFIÉ : grep du dossier `supabase/migrations/` pour
-- pédiatrie/ALR/loco-régional ne fait remonter aucune migration existante
-- couvrant ce document précis sous un autre nom de clé — `0059_migrate_
-- voies_aeriennes_enfant.sql` (voies aériennes, sujet distinct),
-- `0073_migrate_amygdalectomie_enfant.sql` (amygdalectomie, sujet
-- distinct) et `0080_migrate_alr_perinerveuse.sql` (ALR périnerveuse
-- ADULTE, RFE SFAR 2016 — document totalement différent, pas de
-- chevauchement de source_url) sont les seules migrations pédiatriques/ALR
-- voisines par le nom ; aucune ne porte sur ce document 2010.
--
-- MÉTHODOLOGIE — PAS DE GRILLE GRADE A-E : le contenu construit le dit
-- explicitement en tête de fiche — méthode GRADE quand pertinente, sinon
-- accord professionnel (méthode de type Groupe Nominal, RAND/UCLA modifiée)
-- — la force de chaque recommandation est encodée UNIQUEMENT dans le verbe
-- employé par la source, sur une échelle binaire :
--   * "Forte" (`grade` = 'Forte') : « il faut faire » / « il ne faut pas
--     faire ».
--   * "Optionnelle" (`grade` = 'Optionnelle') : « il est possible de » /
--     « il faut probablement » / « les experts proposent » / « il faut
--     penser à ».
-- Ces deux libellés reproduisent exactement le vocabulaire du panneau de
-- légende de la source (contenu construit, section Q1-2) — aucune
-- correspondance vers un grade GRADE (1+/1-/2+/2-) ou un accord fort/faible
-- n'est inventée : la source elle-même ne fournit aucun niveau de preuve
-- (`evidence_level`) distinct de cette force binaire, colonne laissée NULL
-- sur les 92 lignes, sans exception.
-- Sécurité anti-fusion (CLAUDE.md, "Standing quality bar" #4) : vérifié par
-- `grep -n '"[12][+-]/[12][+-]'` sur ce fichier avant commit — 0 résultat
-- (la question ne se pose même pas ici, aucune notation GRADE numérique
-- n'étant utilisée par cette source, mais le garde-fou a été exécuté
-- quand même, sans exception de méthodologie).
--
-- 92 RECOMMANDATIONS ATOMIQUES — comptage exhaustif direct (pas une
-- estimation) : chaque ligne d'un tableau de recommandations du contenu
-- construit portant EXACTEMENT une puce de force (FORT ou OPT) en 3e
-- cellule a été reprise ; 55 "Forte", 37 "Optionnelle" (55+37=92, vérifié
-- programmatiquement). Numérotées R01-R92 dans l'ordre d'apparition du
-- contenu construit (Q1 puis Q2 puis Q3 puis Q4 puis Q5 puis Q6) — aucun
-- trou de numérotation dans cette migration (chaque rang 1..92 est utilisé
-- une fois).
--
-- A VERIFIER : DÉCALAGE ENTRE LE COMPTE ANNONCÉ PAR LE CONTENU CONSTRUIT
-- LUI-MÊME ET LE COMPTE DIRECT DES LIGNES GRADABLES (ambiguïté non
-- résolue, ne pas deviner laquelle des deux valeurs est "la bonne") : le
-- panneau "Sources
-- et traçabilité" du contenu construit affirme une couverture de
-- "l'intégralité des 106 énoncés (puces) des 6 Questions du texte source,
-- y compris le Tableau 1 (choix des aiguilles) et les formules
-- Armitage/Schulte-Steinberg" — un compte de 106 qui NE correspond PAS aux
-- 92 lignes réellement porteuses d'une puce de force individuelle FORT/OPT
-- dénombrées ci-dessus. Cet écart n'est PAS résolu silencieusement ici :
-- les deux chiffres (106 annoncé, 92 gradable) sont disclosed tels quels.
-- Explication plausible mais NON garantie (le contenu construit ne détaille
-- pas lui-même sa méthode de comptage à 106, et le texte source original
-- n'a pas été relu par cette migration) : le "Tableau 1" cité (7 lignes de
-- tailles d'aiguilles par technique/âge, rattachées à R41/§4-1 mais sans
-- puce de force individuelle propre), les 2 formules de calcul
-- Armitage/Schulte-Steinberg (rattachées à R09/§1-4-1-1), et plusieurs
-- paragraphes de contexte explicitement non gradés (comparaison
-- ropivacaïne/lévobupivacaïne en §1-3 ; absence de données sur les
-- morphiniques périmédullaires du nouveau-né en préambule §2-2 ; absence de
-- spécificité pédiatrique en §4-5, §5-1-2 et §5-4 ; préambule sur la
-- coagulopathie en §5-3) pourraient expliquer une bonne part de l'écart de
-- 14 énoncés si le contenu construit les a comptés comme des "puces"
-- individuelles — mais ceci reste une hypothèse de reconstruction, pas un
-- fait vérifié contre le PDF source original (non relu par cette
-- migration). Aucun de ces éléments ne porte de puce de force FORT/OPT
-- propre : ils sont donc EXCLUS du modèle `recommendations` (voir liste
-- exhaustive des exclusions ci-dessous), pas fusionnés dans une ligne
-- existante ni forcés à un grade deviné.
--
-- CONTENU EXPLICITEMENT EXCLU DU MODÈLE `recommendations` (aucune force
-- FORT/OPT individuelle dans le contenu construit — pas un oubli) :
--   1. Panneau de résumé/méthodologie en tête de fiche (Q1-2) — présentation,
--      pas une recommandation.
--   2. §1-3 "Nouveaux ALx" — comparaison descriptive ropivacaïne/
--      lévobupivacaïne (bloc moteur, toxicité), sans verbe "il faut"/force.
--   3. Note de calcul liée à §1-4-1-1 (schéma d'Armitage, formule de
--      Schulte-Steinberg) — aide de calcul citée par R09, pas une
--      recommandation distincte.
--   4. Préambule §2-2 ("l'effet pharmacologique des morphiniques
--      périmédullaires chez le nouveau-né et le nourrisson n'est pas
--      connu") — constat, pas une force.
--   5. Tableau 1 (§4-1, choix des aiguilles par technique/âge/poids, 7
--      lignes de tailles) et sa note *  (risque de tumeur dermoïde
--      intraspinale) — données de référence rattachées à R41, sans force
--      individuelle.
--   6. Note §4-5 ("aucune preuve ne justifie l'usage préférentiel de
--      cathéters stimulants... aucune particularité pédiatrique avérée
--      pour les autres matériels") — absence de recommandation déclarée
--      par la source elle-même.
--   7. Note §5-1-2 (toxicité locale — "aucune précaution... n'est
--      recommandée", en l'absence de données) — absence de recommandation
--      déclarée par la source elle-même.
--   8. Préambule §5-3 (contre-indication de principe de l'ALR en cas de
--      coagulopathie) — contexte, la conduite à tenir gradée suit en R59-62.
--   9. Note §5-4 (complications septiques — "aucune spécificité
--      pédiatrique avérée") — absence de recommandation déclarée par la
--      source elle-même.
--   10. Panneaux "Document source"/"Méthodologie"/"URL source"/
--       "Couverture" et avertissement final — métadonnées de traçabilité
--       et clause de non-substitution, déjà portées par les colonnes
--       `documents` et par ce commentaire de migration.
--
-- `population` : laissé NULL sur les 92 lignes. Plusieurs recommandations
-- ci-dessous portent une population explicite dans leur `statement` même
-- (nouveau-né/nourrisson, enfant >2 mois, enfant <2 ans, adolescent/grand
-- enfant, ancien prématuré 44-60 semaines d'âge conceptuel, cardiopathie...)
-- mais la formulation source mélange souvent, DANS LA MÊME PHRASE, une
-- population restrictive et une information complémentaire sur une AUTRE
-- tranche d'âge (ex. R16, R26, R34) — réduire cela à une seule valeur
-- `population` par ligne tronquerait ou dupliquerait l'information déjà
-- intégralement présente dans `statement`. Même choix éditorial et même
-- justification que `examens_preinterventionnels`/0065 (voir son
-- commentaire point 3) : le champ n'est pas renseigné par cette migration,
-- à trancher par la relecture humaine si une normalisation par population
-- est souhaitée.
--
-- SOCIÉTÉS — VÉRIFICATION EXHAUSTIVE CONTRE LA LISTE COMPLÈTE DU SEED
-- (18 entrées de `schema_v2.sql` section 15, comparées une à une, pas une
-- commande grep/head tronquée) : le document est co-publié SFAR + ADARPEF
-- (source : panneau "Document source" du contenu construit). SFAR EST dans
-- le seed (`('SFAR', 'France')`). **ADARPEF N'EST PAS dans le seed** — les
-- 18 acronymes exacts du seed sont SFAR, SRLF, HAS, SPILF, SFMU, CNGOF,
-- SFC, SFN, SFD, ESAIC, ESICM, SCCM, ASA, DAS, ASRA, NICE, AWMF, SEMICYUC ;
-- ADARPEF n'y figure sous aucune variante. Seule SFAR est donc liée en
-- `document_societies` ci-dessous ; ADARPEF reste non modélisable tant
-- qu'elle n'aura pas été ajoutée au référentiel `societies` (hors périmètre
-- de cette migration DML).
--
-- SPÉCIALITÉS — VÉRIFICATION EXHAUSTIVE CONTRE LA LISTE COMPLÈTE DU SEED
-- (79 slugs de `schema_v2.sql` section 14, comparés un à un) : `chirurgie_
-- pediatrique` et `pediatrie` EXISTENT bien dans le seed, en plus de
-- `anesthesie_reanimation`. Les 3 sont liées ci-dessous :
--   * `anesthesie_reanimation` : discipline porteuse de la RFE (SFAR),
--     geste et surveillance anesthésiques.
--   * `chirurgie_pediatrique` : la Question 6 (R74-R92) structure
--     explicitement le choix du bloc PAR TYPE DE CHIRURGIE pédiatrique
--     (face, membre supérieur/inférieur, rachis, uro-génital, thorax,
--     abdomen) — contenu directement actionnable pour le chirurgien
--     pédiatrique planifiant l'analgésie périopératoire avec l'anesthésiste.
--   * `pediatrie` : posologies/contre-indications strictement dépendantes
--     de l'âge/du poids et de la physiologie pédiatrique (ex. apnée du
--     prématuré R69, toxicité systémique du nouveau-né R70, immaturité
--     hépatique R04) — pertinent au suivi pédiatrique général, pas
--     seulement au geste anesthésique lui-même.
--
-- Grade `recommendation_code` : MG-ANES-000088-R01 à -R92, aucun trou de
-- numérotation (voir ci-dessus).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Anesthésie loco-régionale en pédiatrie',
  'RFE', 'fr', '2010-01-01',
  'https://sfar.org/anesthesie-loco-regionale-en-pediatrie/',
  'https://sfar.org/wp-content/uploads/2015/09/2_SFAR_Anesthesie-loco-regionale-en-pediatrie.pdf',
  'Pas de grille GRADE A-E : force binaire encodée dans le verbe de chaque recommandation — "Forte" (« il faut »/« il ne faut pas ») ou "Optionnelle" (« il est possible de »/« il faut probablement »/« les experts proposent »). Méthode GRADE quand pertinente, sinon accord professionnel (Groupe Nominal, RAND/UCLA modifiée). 92 recommandations reproduites (compte exhaustif direct : 55 Forte, 37 Optionnelle) ; evidence_level non applicable (aucun niveau de preuve distinct de cette force binaire dans la source). Le panneau de couverture du contenu construit annonce "106 énoncés (puces)" incluant le Tableau 1 des aiguilles et les formules de calcul Armitage/Schulte-Steinberg, non individuellement gradés — écart disclosed, non résolu, voir commentaire de migration.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/anesthesie-loco-regionale-en-pediatrie/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/anesthesie-loco-regionale-en-pediatrie/'
  and s.slug in ('anesthesie_reanimation', 'chirurgie_pediatrique', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.source_section,
  'https://sfar.org/anesthesie-loco-regionale-en-pediatrie/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000088-R01', 'Les ALx habituellement utilisés pour l''ALR pédiatrique sont ceux du groupe des amino-amides.', 'Forte', 'Anesthésiques locaux — familles utilisées (amino-amides)', 'Question 1 — Anesthésiques locaux (ALx) : choix et posologies, §1-1'),
  ('MG-ANES-000088-R02', 'Chez le nouveau-né et le nourrisson, il faut utiliser des ALx moins concentrés que chez l''adulte.', 'Forte', 'Concentration des anesthésiques locaux selon l''âge', 'Question 1 — Anesthésiques locaux (ALx) : choix et posologies, §1-2'),
  ('MG-ANES-000088-R03', 'Chez l''enfant >2 mois, il faut utiliser un volume d''ALx d''autant plus important par rapport au poids que l''enfant est jeune.', 'Forte', 'Volume d''anesthésique local selon l''âge', 'Question 1 — Anesthésiques locaux (ALx) : choix et posologies, §1-2'),
  ('MG-ANES-000088-R04', 'Il faut réduire les posologies d''ALx chez l''enfant <2 ans (fréquence cardiaque de base élevée, vulnérabilité à la toxicité cardiaque) — risque renforcé <1 an (protéines sériques basses) et encore plus <6 mois (immaturité hépatique, surtout si réinjections/administration continue).', 'Forte', 'Réduction des posologies d''anesthésiques locaux avant 2 ans', 'Question 1 — Anesthésiques locaux (ALx) : choix et posologies, §1-2'),
  ('MG-ANES-000088-R05', 'Il faut privilégier la ropivacaïne à 2 mg/ml ou la lévobupivacaïne à 2,5 mg/ml.', 'Forte', 'Choix de l''anesthésique local — injection unique péridurale/caudale', 'Question 1 — Anesthésiques locaux (ALx) : choix et posologies, §1-4-1-1'),
  ('MG-ANES-000088-R06', 'En caudale, il ne faut pas dépasser 2 mg/kg pour la ropivacaïne ou la lévobupivacaïne.', 'Forte', 'Dose maximale — bloc caudal (ropivacaïne/lévobupivacaïne)', 'Question 1 — Anesthésiques locaux (ALx) : choix et posologies, §1-4-1-1'),
  ('MG-ANES-000088-R07', 'En péridurale, il ne faut pas dépasser 1,7 mg/kg pour la ropivacaïne.', 'Forte', 'Dose maximale — péridurale (ropivacaïne)', 'Question 1 — Anesthésiques locaux (ALx) : choix et posologies, §1-4-1-1'),
  ('MG-ANES-000088-R08', 'En péridurale, il ne faut probablement pas dépasser 1,7 mg/kg de lévobupivacaïne.', 'Optionnelle', 'Dose maximale — péridurale (lévobupivacaïne)', 'Question 1 — Anesthésiques locaux (ALx) : choix et posologies, §1-4-1-1'),
  ('MG-ANES-000088-R09', 'Il faut adapter le volume injecté au niveau métamérique à atteindre.', 'Forte', 'Volume injecté et niveau métamérique', 'Question 1 — Anesthésiques locaux (ALx) : choix et posologies, §1-4-1-1'),
  ('MG-ANES-000088-R10', 'Rachianesthésie : il faut probablement limiter l''usage de la bupivacaïne racémique à cette technique — 1 mg/kg à 0,5 % chez l''enfant <5 kg, 0,4 mg/kg de 5 à 15 kg, 0,3 mg/kg >15 kg.', 'Optionnelle', 'Bupivacaïne racémique — rachianesthésie', 'Question 1 — Anesthésiques locaux (ALx) : choix et posologies, §1-4-1-2'),
  ('MG-ANES-000088-R11', 'Blocs périphériques du tronc/membres : il ne faut probablement pas injecter plus de 0,5 ml/kg de ropivacaïne à 2 mg/ml ou de lévobupivacaïne à 2,5 mg/ml.', 'Optionnelle', 'Dose maximale — blocs périphériques du tronc/membres', 'Question 1 — Anesthésiques locaux (ALx) : choix et posologies, §1-4-1-3'),
  ('MG-ANES-000088-R12', 'Péridurale continue de ropivacaïne : concentrations ≤2 mg/ml chez l''enfant, 1 mg/ml chez le nourrisson. Posologie maximale : 0,20 mg/kg/h avant 1 mois, 0,30 mg/kg/h avant 6 mois, 0,40 mg/kg/h après 6 mois.', 'Forte', 'Péridurale continue de ropivacaïne — concentrations et posologie maximale', 'Question 1 — Anesthésiques locaux (ALx) : choix et posologies, §1-4-2'),
  ('MG-ANES-000088-R13', 'Il faut probablement appliquer les mêmes recommandations à l''administration périnerveuse périphérique continue de ropivacaïne.', 'Optionnelle', 'Administration périnerveuse périphérique continue de ropivacaïne', 'Question 1 — Anesthésiques locaux (ALx) : choix et posologies, §1-4-2'),
  ('MG-ANES-000088-R14', 'En l''absence de données pharmacologiques suffisantes sur la lévobupivacaïne continue en pédiatrie, il faut probablement l''administrer aux concentrations/posologies retenues pour la ropivacaïne.', 'Optionnelle', 'Lévobupivacaïne en administration continue', 'Question 1 — Anesthésiques locaux (ALx) : choix et posologies, §1-4-2'),
  ('MG-ANES-000088-R15', 'Il ne faut probablement pas administrer plus de 2 µg/kg de clonidine lors d''une ALR (effets indésirables — somnolence, bradycardie, hypotension — observés à 5 µg/kg).', 'Optionnelle', 'Clonidine — dose maximale par ALR', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-1'),
  ('MG-ANES-000088-R16', 'Il ne faut pas recourir à la clonidine péridurale ou intrathécale chez le nouveau-né et le nourrisson sans surveillance continue (risque d''apnée postopératoire). Chez l''enfant plus âgé, 1-2 µg/kg par voie péridurale/intrathécale provoquent une sédation et dépriment faiblement la respiration.', 'Forte', 'Clonidine périmédullaire — surveillance selon l''âge', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-1'),
  ('MG-ANES-000088-R17', 'Pour la plupart des blocs tronculaires, il est possible de prolonger l''analgésie en ajoutant 1-2 µg/kg de clonidine à la solution d''ALx (augmente l''incidence du bloc moteur).', 'Optionnelle', 'Clonidine adjuvant — blocs tronculaires', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-1'),
  ('MG-ANES-000088-R18', 'Il est possible de prolonger l''analgésie de la péridurale caudale en ajoutant 1 µg/kg de clonidine à une solution d''ALx ≥0,125 %.', 'Optionnelle', 'Clonidine adjuvant — péridurale caudale', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-1'),
  ('MG-ANES-000088-R19', 'Il est possible d''améliorer l''analgésie postopératoire de la péridurale lombaire en associant de la clonidine (1-2 µg/kg en bolus, ou 0,08-0,12 µg/kg/h en continu).', 'Optionnelle', 'Clonidine adjuvant — péridurale lombaire', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-1'),
  ('MG-ANES-000088-R20', 'Chez l''enfant/l''adolescent, il est possible d''ajouter 1-2 µg/kg de clonidine à la bupivacaïne 0,5 % pour la rachianesthésie — risque important de bradycardie et d''hypotension.', 'Optionnelle', 'Clonidine adjuvant — rachianesthésie', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-1'),
  ('MG-ANES-000088-R21', 'En cas d''administration périmédullaire de morphiniques, il faut éviter toute co-administration d''un morphinique par une autre voie.', 'Forte', 'Morphiniques périmédullaires — co-administration par une autre voie', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-2'),
  ('MG-ANES-000088-R22', 'La morphine périmédullaire permet une analgésie de bonne qualité — bolus de 25-30 µg/kg (solution à 10 µg/ml) possible pour prolonger l''analgésie en péridurale lombaire ou caudale, 4-10 µg/kg en rachianesthésie.', 'Optionnelle', 'Morphine périmédullaire — posologie', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-2'),
  ('MG-ANES-000088-R23', 'Il est possible d''améliorer l''analgésie péridurale lombaire/thoracique continue en associant fentanyl ou sufentanil à une solution d''ALx faiblement concentrée, sans dépasser 0,2 µg/kg/h pour l''une ou l''autre substance.', 'Optionnelle', 'Fentanyl/sufentanil adjuvant — péridurale continue', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-2'),
  ('MG-ANES-000088-R24', 'Il ne faut pas attendre de bénéfice à l''utilisation de fentanyl ou sufentanil par voie caudale.', 'Forte', 'Fentanyl/sufentanil — voie caudale', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-2'),
  ('MG-ANES-000088-R25', 'Il est possible de prolonger l''analgésie de la rachianesthésie en administrant du fentanyl 2 µg/kg.', 'Optionnelle', 'Fentanyl adjuvant — rachianesthésie', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-2'),
  ('MG-ANES-000088-R26', 'La dépression respiratoire liée aux morphiniques périmédullaires est précoce pour les dérivés lipophiles, tardive pour la morphine (s''annonce généralement par une sédation excessive) — risque plus élevé chez le nouveau-né/nourrisson : surveillance continue dans cette population, surveillance clinique rigoureuse dans les autres tranches d''âge.', 'Forte', 'Morphiniques périmédullaires — surveillance de la dépression respiratoire', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-2'),
  ('MG-ANES-000088-R27', 'Pour traiter une rétention d''urine sans diminuer l''analgésie, il est possible d''administrer 1 µg/kg de naloxone ou 0,1 mg/kg de nalbuphine IV.', 'Optionnelle', 'Rétention d''urine sous morphiniques périmédullaires', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-2'),
  ('MG-ANES-000088-R28', 'Pour les nausées/vomissements (plus fréquents avec la morphine qu''avec les dérivés lipophiles), il faut un traitement symptomatique.', 'Forte', 'Nausées/vomissements sous morphiniques périmédullaires', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-2'),
  ('MG-ANES-000088-R29', 'Pour le prurit (plus fréquent avec la morphine), il faut soit un bolus IV de 1-2 µg/kg de naloxone suivi de 1-2 µg/kg/h en continu, soit des antihistaminiques de type HT3.', 'Forte', 'Prurit sous morphiniques périmédullaires', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-2'),
  ('MG-ANES-000088-R30', 'Il est possible de diminuer le risque toxique des ALx d''action courte en utilisant des solutions adrénalinées à 5 µg/ml maximum (1/200 000ème) — diminue la résorption systémique, effets hémodynamiques (chute modérée de la PAM/RVP, hausse du débit cardiaque).', 'Optionnelle', 'Adrénaline — réduction du risque toxique des ALx d''action courte', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-3'),
  ('MG-ANES-000088-R31', 'Il ne faut pas ajouter d''adrénaline aux ALx pour un bloc en territoire à vascularisation terminale (rachianesthésie, bloc pénien, pudendal, digital, lobe de l''oreille, certains blocs de la face…).', 'Forte', 'Adrénaline — contre-indication en territoire à vascularisation terminale', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-3'),
  ('MG-ANES-000088-R32', 'Il ne faut probablement pas associer d''adrénaline à un AL administré par voie caudale, périnerveuse ou locale pour prolonger l''analgésie.', 'Optionnelle', 'Adrénaline — prolongation de l''analgésie (caudale/périnerveuse/locale)', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-3'),
  ('MG-ANES-000088-R33', 'En l''absence d''études de toxicité/innocuité, l''utilisation de tramadol, midazolam, néostigmine et kétamine par voie périmédullaire chez l''enfant n''est pas recommandée.', 'Forte', 'Adjuvants périmédullaires non recommandés (tramadol, midazolam, néostigmine, kétamine)', 'Question 2 — Adjuvants pour l''ALR chez l''enfant, §2-4'),
  ('MG-ANES-000088-R34', 'Péridurale : en termes de sécurité, il n''est pas possible de trancher entre mandrin liquide, mixte ou gazeux. En efficacité (par assimilation à l''adulte), il faut probablement utiliser un mandrin mixte ou liquide <5 ml chez l''adolescent/grand enfant ; un mandrin gazeux est possible chez le nouveau-né/nourrisson à condition de limiter le volume de gaz à 1 ml et de ne pas multiplier les tentatives en cas d''échec.', 'Optionnelle', 'Péridurale — technique de perte de résistance (mandrin)', 'Question 3 — Méthodes de localisation pour l''ALR pédiatrique, §3-1-1'),
  ('MG-ANES-000088-R35', 'Caudale : il ne faut pas utiliser de mandrin liquide, mixte ou gazeux — seule la perte de résistance au franchissement de la membrane sacro-coccygienne doit guider la localisation.', 'Forte', 'Caudale — technique de perte de résistance (mandrin)', 'Question 3 — Méthodes de localisation pour l''ALR pédiatrique, §3-1-2'),
  ('MG-ANES-000088-R36', 'Blocs périphériques de diffusion : il faut utiliser une aiguille à biseau court sans mandrin liquide, mixte ou gazeux.', 'Forte', 'Blocs périphériques de diffusion — aiguille', 'Question 3 — Méthodes de localisation pour l''ALR pédiatrique, §3-1-3'),
  ('MG-ANES-000088-R37', 'Neurostimulation : même technique que chez l''adulte, y compris chez l''enfant anesthésié. Il ne faut pas rechercher de réponse pour une intensité <0,5 mA.', 'Forte', 'Neurostimulation — seuil d''intensité', 'Question 3 — Méthodes de localisation pour l''ALR pédiatrique, §3-2'),
  ('MG-ANES-000088-R38', 'Stimulation transcutanée : il est possible de l''utiliser comme aide à la localisation des nerfs mixtes (probablement plus utile en pédiatrie où la croissance modifie les rapports anatomiques) — ne remplace pas le stimulateur de nerfs ni les connaissances anatomiques.', 'Optionnelle', 'Stimulation transcutanée — aide à la localisation', 'Question 3 — Méthodes de localisation pour l''ALR pédiatrique, §3-3'),
  ('MG-ANES-000088-R39', 'Il faut probablement pratiquer l''ALR chez l''enfant sous échoguidage : diminue le délai d''installation du bloc sensitif et moteur, augmente la durée du bloc sensitif, diminue la quantité d''ALx injectée, améliore le taux de succès.', 'Optionnelle', 'Échoguidage pour l''ALR', 'Question 3 — Méthodes de localisation pour l''ALR pédiatrique, §3-4'),
  ('MG-ANES-000088-R40', 'Il ne faut probablement pas opacifier systématiquement tous les cathéters d''ALR — il faut vérifier la position de ceux dont un trajet aberrant aurait des conséquences graves (ex. cathéters interscaléniques, paravertébraux lombaires/thoraciques).', 'Optionnelle', 'Opacification systématique des cathéters d''ALR', 'Question 3 — Méthodes de localisation pour l''ALR pédiatrique, §3-5'),
  ('MG-ANES-000088-R41', 'Il faut privilégier les aiguilles adaptées à la technique, l''âge et/ou le poids de l''enfant (Tableau 1 ci-dessous).', 'Forte', 'Choix de l''aiguille selon technique/âge/poids (Tableau 1)', 'Question 4 — Matériels pour l''ALR chez l''enfant, §4-1'),
  ('MG-ANES-000088-R42', 'Chez le petit enfant, il faut utiliser des cathéters en polyamide/polyéthylène sans mandrin, gradués ≥cm, à orifice d''injection unique et terminal.', 'Forte', 'Cathéters — caractéristiques chez le petit enfant', 'Question 4 — Matériels pour l''ALR chez l''enfant, §4-2'),
  ('MG-ANES-000088-R43', 'Il ne faut probablement pas mettre en place un cathéter thoracique par voie caudale.', 'Optionnelle', 'Cathéter thoracique par voie caudale', 'Question 4 — Matériels pour l''ALR chez l''enfant, §4-2'),
  ('MG-ANES-000088-R44', 'Il ne faut pas introduire une longueur de cathéter >1,5-3 cm pour un bloc nerveux périphérique.', 'Forte', 'Longueur de cathéter — bloc nerveux périphérique', 'Question 4 — Matériels pour l''ALR chez l''enfant, §4-2'),
  ('MG-ANES-000088-R45', 'Il est possible d''utiliser des perfuseurs élastomériques pour les ALR périphériques continues (confort, autonomie, traitement à domicile).', 'Optionnelle', 'Perfuseurs élastomériques — ALR périphérique continue', 'Question 4 — Matériels pour l''ALR chez l''enfant, §4-3'),
  ('MG-ANES-000088-R46', 'Il faut privilégier des sondes échographiques linéaires 8-14 MHz.', 'Forte', 'Sondes échographiques — fréquence', 'Question 4 — Matériels pour l''ALR chez l''enfant, §4-4'),
  ('MG-ANES-000088-R47', 'Quel que soit le bloc, il faut impérativement faire un test d''aspiration avant d''injecter (valeur seulement si positif — pas de sécurité absolue).', 'Forte', 'Test d''aspiration avant injection', 'Question 5 — Prévention, signes et traitement des complications, §5-1-1-1'),
  ('MG-ANES-000088-R48', 'Il est possible d''injecter une dose test adrénalinée pour le bloc caudal, la péridurale lombaire/thoracique et les blocs périphériques profonds, même avec ropivacaïne/lévobupivacaïne — probablement plus utile chez l''enfant anesthésié/non communicant.', 'Optionnelle', 'Dose test adrénalinée', 'Question 5 — Prévention, signes et traitement des complications, §5-1-1-1'),
  ('MG-ANES-000088-R49', 'Il faut toujours injecter l''ALx lentement, de façon fractionnée, entrecoupée de tests d''aspiration répétés.', 'Forte', 'Injection lente et fractionnée', 'Question 5 — Prévention, signes et traitement des complications, §5-1-1-1'),
  ('MG-ANES-000088-R50', 'Il faut administrer une émulsion lipidique en cas de manifestation toxique systémique cardiaque ou neurologique ne répondant pas rapidement à la réanimation habituelle.', 'Forte', 'Émulsion lipidique — toxicité systémique', 'Question 5 — Prévention, signes et traitement des complications, §5-1-1-2'),
  ('MG-ANES-000088-R51', 'Il ne faut pas que cette thérapeutique retarde ou remplace la réanimation cardiopulmonaire habituelle.', 'Forte', 'Émulsion lipidique — non-substitution à la réanimation cardiopulmonaire', 'Question 5 — Prévention, signes et traitement des complications, §5-1-1-2'),
  ('MG-ANES-000088-R52', 'Il faut utiliser l''Intralipide® 20 % : 1,5 ml/kg en bolus puis perfusion à 0,5-1 ml/kg/min selon la réponse clinique (probablement), sans dépasser 10 ml/kg.', 'Forte', 'Émulsion lipidique — posologie (Intralipide 20 %)', 'Question 5 — Prévention, signes et traitement des complications, §5-1-1-2'),
  ('MG-ANES-000088-R53', 'Il faut utiliser des aiguilles sans biseau ou à biseau le plus court possible, pour diminuer le risque de lésion nerveuse.', 'Forte', 'Aiguilles — biseau et risque de lésion nerveuse', 'Question 5 — Prévention, signes et traitement des complications, §5-2-1'),
  ('MG-ANES-000088-R54', 'Il faut interrompre l''injection devant toute résistance inhabituelle, pour diminuer le risque de lésion nerveuse.', 'Forte', 'Résistance à l''injection — conduite à tenir', 'Question 5 — Prévention, signes et traitement des complications, §5-2-2'),
  ('MG-ANES-000088-R55', 'Chez l''adolescent/grand enfant, un mandrin gazeux pour la péridurale augmente le risque de brèche méningée (par assimilation à l''adulte).', 'Forte', 'Mandrin gazeux péridurale — risque de brèche méningée', 'Question 5 — Prévention, signes et traitement des complications, §5-2-3'),
  ('MG-ANES-000088-R56', 'Pour le bloc caudal, il faut éviter d''introduire l''aiguille >1 cm dans le canal sacré, en ponctionnant précisément au sommet du triangle équilatéral hiatus sacré/épines iliaques postéro-supérieures.', 'Forte', 'Bloc caudal — profondeur d''introduction de l''aiguille', 'Question 5 — Prévention, signes et traitement des complications, §5-2-3'),
  ('MG-ANES-000088-R57', 'Chez le nouveau-né/petit nourrisson, il ne faut pas réaliser de rachianesthésie avec une aiguille dont l''orifice est décalé de la pointe (risque accru d''injection à cheval sur la dure-mère).', 'Forte', 'Rachianesthésie — orifice de l''aiguille', 'Question 5 — Prévention, signes et traitement des complications, §5-2-3'),
  ('MG-ANES-000088-R58', 'En cas de brèche méningée, risque de céphalée posturale comparable à l''adulte — prise en charge similaire.', 'Forte', 'Brèche méningée — céphalée posturale', 'Question 5 — Prévention, signes et traitement des complications, §5-2-3'),
  ('MG-ANES-000088-R59', 'Quel que soit l''âge, avant toute ALR, il faut évaluer l''hémostase par examen clinique + anamnèse minutieuse (antécédents personnels/familiaux).', 'Forte', 'Évaluation de l''hémostase avant ALR', 'Question 5 — Prévention, signes et traitement des complications, §5-3'),
  ('MG-ANES-000088-R60', 'Il ne faut pas pratiquer de bilan biologique systématique lorsque la marche est acquise et l''étape clinique totalement négative.', 'Forte', 'Bilan biologique d''hémostase — absence d''indication systématique', 'Question 5 — Prévention, signes et traitement des complications, §5-3'),
  ('MG-ANES-000088-R61', 'Si la marche n''est pas acquise ou qu''un bilan est nécessaire, il faut le limiter à un TCA et une numération plaquettaire.', 'Forte', 'Bilan biologique d''hémostase — limité (TCA, plaquettes)', 'Question 5 — Prévention, signes et traitement des complications, §5-3'),
  ('MG-ANES-000088-R62', 'Toute anomalie du bilan initial persistant après contrôle doit être explorée (avis hémobiologiste si besoin) selon l''anomalie et la chirurgie.', 'Forte', 'Anomalie du bilan d''hémostase — exploration', 'Question 5 — Prévention, signes et traitement des complications, §5-3'),
  ('MG-ANES-000088-R63', 'Pour éviter une erreur d''injection, il faut séparer les seringues contenant l''ALx de celles destinées aux injections systémiques (chariot d''ALR dédié recommandé).', 'Forte', 'Prévention des erreurs d''injection — séparation des seringues', 'Question 5 — Prévention, signes et traitement des complications, §5-5'),
  ('MG-ANES-000088-R64', 'Il faut identifier clairement le circuit IV et le circuit d''ALR continue (étiquettes, couleur de connexion…).', 'Forte', 'Identification des circuits IV et d''ALR continue', 'Question 5 — Prévention, signes et traitement des complications, §5-5'),
  ('MG-ANES-000088-R65', 'Les experts proposent qu''une couleur unique et/ou une modification (inversion, détrompeur…) des connexions Luer-Lock soit imposée pour la fabrication des cathéters d''ALR.', 'Optionnelle', 'Connexions Luer-Lock des cathéters d''ALR', 'Question 5 — Prévention, signes et traitement des complications, §5-5'),
  ('MG-ANES-000088-R66', 'Pour le confort et la sécurité, il faut privilégier l''association ALR/AG préalable chez les jeunes enfants.', 'Forte', 'Association ALR/AG préalable', 'Question 6 — Quelle technique choisir pour une ALR chez l''enfant ?, §6-1'),
  ('MG-ANES-000088-R67', 'Chez les enfants plus grands, une ALR sans AG associée est possible.', 'Optionnelle', 'ALR sans AG associée', 'Question 6 — Quelle technique choisir pour une ALR chez l''enfant ?, §6-1'),
  ('MG-ANES-000088-R68', 'Il ne faut probablement pas réaliser d''anesthésie caudale chez l''enfant >20 kg.', 'Optionnelle', 'Anesthésie caudale — limite de poids', 'Question 6 — Quelle technique choisir pour une ALR chez l''enfant ?, §6-1'),
  ('MG-ANES-000088-R69', 'Chez l''ancien prématuré de 44-60 semaines d''âge conceptuel (chirurgie sous-ombilicale), associer AG et bloc neuraxial n''augmente probablement pas le risque d''apnée postopératoire par rapport à un bloc neuraxial seul.', 'Optionnelle', 'Bloc neuraxial et AG — apnée postopératoire chez l''ancien prématuré', 'Question 6 — Quelle technique choisir pour une ALR chez l''enfant ?, §6-1'),
  ('MG-ANES-000088-R70', 'Il faut être vigilant en cas d''association d''adrénaline aux ALx chez le nouveau-né (baisse significative de la tension artérielle).', 'Forte', 'Adrénaline associée aux ALx chez le nouveau-né', 'Question 6 — Quelle technique choisir pour une ALR chez l''enfant ?, §6-1'),
  ('MG-ANES-000088-R71', 'En cas de cardiopathie, il ne faut pas contre-indiquer de façon absolue un bloc neuraxial par ALx et/ou morphiniques.', 'Forte', 'Bloc neuraxial et cardiopathie', 'Question 6 — Quelle technique choisir pour une ALR chez l''enfant ?, §6-1'),
  ('MG-ANES-000088-R72', 'En bénéfice/risque, il faut réaliser un bloc périphérique plutôt qu''un bloc central dès que l''alternative se présente.', 'Forte', 'Choix bloc périphérique vs bloc central', 'Question 6 — Quelle technique choisir pour une ALR chez l''enfant ?, §6-2'),
  ('MG-ANES-000088-R73', 'En chirurgie lourde viscérale ou ostéo-articulaire, il est possible d''assurer une analgésie postopératoire de qualité par un bloc continu.', 'Optionnelle', 'Bloc continu — chirurgie lourde viscérale/ostéo-articulaire', 'Question 6 — Quelle technique choisir pour une ALR chez l''enfant ?, §6-2'),
  ('MG-ANES-000088-R74', 'Chirurgie de la face : le bloc infra-orbitaire est la technique recommandée pour la chirurgie isolée de la lèvre supérieure (dont réparation de fente labiale).', 'Forte', 'Bloc infra-orbitaire — chirurgie de la lèvre supérieure', 'Question 6 — Quelle technique choisir pour une ALR chez l''enfant ?, §6-2-1'),
  ('MG-ANES-000088-R75', 'Il est possible d''assurer l''analgésie de l''épaule/tiers supérieur du bras par bloc parascalénique — le bloc interscalénique est une alternative plus risquée (paralysie phrénique, Claude Bernard-Horner, Pourfour du Petit…).', 'Optionnelle', 'Bloc parascalénique — épaule/tiers supérieur du bras', 'Question 6 — Quelle technique choisir pour une ALR chez l''enfant ?, §6-2-2'),
  ('MG-ANES-000088-R76', 'Il faut privilégier le bloc axillaire (± cathéter) pour l''analgésie des deux tiers inférieurs du bras, coude, avant-bras et/ou main (faible morbidité).', 'Forte', 'Bloc axillaire — deux tiers inférieurs du bras/coude/avant-bras/main', 'Question 6 — Quelle technique choisir pour une ALR chez l''enfant ?, §6-2-2'),
  ('MG-ANES-000088-R77', 'Il est possible de réaliser un bloc médian/ulnaire/radial au tiers inférieur de l''avant-bras si la chirurgie ne concerne qu''un seul territoire de la main.', 'Optionnelle', 'Bloc médian/ulnaire/radial — avant-bras', 'Question 6 — Quelle technique choisir pour une ALR chez l''enfant ?, §6-2-2'),
  ('MG-ANES-000088-R78', 'Il faut privilégier un bloc intrathécal (digital) simple pour la chirurgie de la 3e phalange des 2e, 3e et 4e doigts.', 'Forte', 'Bloc intrathécal digital — chirurgie de la 3e phalange', 'Question 6 — Quelle technique choisir pour une ALR chez l''enfant ?, §6-2-2'),
  ('MG-ANES-000088-R79', 'Chirurgie unilatérale de la hanche : bloc fémoral ou ilio-fascial possible (le bloc du plexus lombaire postérieur est une alternative).', 'Optionnelle', 'Bloc fémoral/ilio-fascial — chirurgie unilatérale de la hanche', 'Question 6 (suite) — Membre inférieur, rachis, tronc, uro-génital, thorax, digestif, §6-2-3'),
  ('MG-ANES-000088-R80', 'Chirurgie bilatérale de la hanche : il faut préférer la péridurale lombaire.', 'Forte', 'Péridurale lombaire — chirurgie bilatérale de la hanche', 'Question 6 (suite) — Membre inférieur, rachis, tronc, uro-génital, thorax, digestif, §6-2-3'),
  ('MG-ANES-000088-R81', 'Chirurgie/traumatisme du fémur : il faut privilégier le bloc ilio-fascial (le bloc fémoral est une alternative).', 'Forte', 'Bloc ilio-fascial — chirurgie/traumatisme du fémur', 'Question 6 (suite) — Membre inférieur, rachis, tronc, uro-génital, thorax, digestif, §6-2-3'),
  ('MG-ANES-000088-R82', 'Chirurgie de la cheville et/ou du pied : il faut réaliser un bloc sciatique tronculaire.', 'Forte', 'Bloc sciatique tronculaire — chirurgie cheville/pied', 'Question 6 (suite) — Membre inférieur, rachis, tronc, uro-génital, thorax, digestif, §6-2-3'),
  ('MG-ANES-000088-R83', 'Chirurgie du rachis : la morphine intrathécale peut assurer l''analgésie postopératoire (alternative : cathéters périduraux mis en place par le chirurgien en fin d''intervention).', 'Optionnelle', 'Morphine intrathécale — chirurgie du rachis', 'Question 6 (suite) — Membre inférieur, rachis, tronc, uro-génital, thorax, digestif, §6-2-4'),
  ('MG-ANES-000088-R84', 'Chirurgie du canal péritonéo-vaginal : il faut un bloc ilio-inguinal/ilio-hypogastrique, associé à un bloc pudendal pour l''analgésie scrotale en cas d''orchidopexie (péridurale caudale = alternative si petit poids ou chirurgie bilatérale).', 'Forte', 'Bloc ilio-inguinal/ilio-hypogastrique et pudendal — canal péritonéo-vaginal', 'Question 6 (suite) — Membre inférieur, rachis, tronc, uro-génital, thorax, digestif, §6-2-5'),
  ('MG-ANES-000088-R85', 'Fermeture de hernie ombilicale/ligne blanche, pylorotomie par abord ombilical strict : bloc para-ombilical possible.', 'Optionnelle', 'Bloc para-ombilical — hernie ombilicale/pylorotomie', 'Question 6 (suite) — Membre inférieur, rachis, tronc, uro-génital, thorax, digestif, §6-2-5'),
  ('MG-ANES-000088-R86', 'Posthectomie/circoncision : il faut privilégier le bloc pénien (bénéfice/risque).', 'Forte', 'Bloc pénien — posthectomie/circoncision', 'Question 6 (suite) — Membre inférieur, rachis, tronc, uro-génital, thorax, digestif, §6-2-6'),
  ('MG-ANES-000088-R87', 'Chirurgie de l''hypospadias : la péridurale caudale peut être remplacée par un bloc pudendal bilatéral (analgésie verge/scrotum) — utilisable aussi pour chirurgie péri-anale et gynécologique superficielle (vulve, petites lèvres, clitoris).', 'Optionnelle', 'Bloc pudendal bilatéral — hypospadias et chirurgie périnéale superficielle', 'Question 6 (suite) — Membre inférieur, rachis, tronc, uro-génital, thorax, digestif, §6-2-6'),
  ('MG-ANES-000088-R88', 'Cure de reflux vésico-urétéral : la péridurale caudale est la technique d''ALR la plus habituelle.', 'Forte', 'Péridurale caudale — reflux vésico-urétéral', 'Question 6 (suite) — Membre inférieur, rachis, tronc, uro-génital, thorax, digestif, §6-2-6'),
  ('MG-ANES-000088-R89', 'Abord rénal par lombotomie : bloc paravertébral thoracique possible.', 'Optionnelle', 'Bloc paravertébral thoracique — abord rénal par lombotomie', 'Question 6 (suite) — Membre inférieur, rachis, tronc, uro-génital, thorax, digestif, §6-2-6'),
  ('MG-ANES-000088-R90', 'Chirurgie thoracique : péridurale thoracique ou bloc paravertébral thoracique possibles pour l''analgésie.', 'Optionnelle', 'Péridurale thoracique/bloc paravertébral — chirurgie thoracique', 'Question 6 (suite) — Membre inférieur, rachis, tronc, uro-génital, thorax, digestif, §6-2-7'),
  ('MG-ANES-000088-R91', 'Chirurgie abdominale majeure : il faut choisir une analgésie péridurale continue.', 'Forte', 'Péridurale continue — chirurgie abdominale majeure', 'Question 6 (suite) — Membre inférieur, rachis, tronc, uro-génital, thorax, digestif, §6-2-8'),
  ('MG-ANES-000088-R92', 'Bloc au triangle de J.L. Petit possible pour l''analgésie de la paroi abdominale — probablement efficace pour les prises de greffon osseux iliaque, alternative au bloc ilio-inguinal/ilio-hypogastrique en chirurgie du canal péritonéo-vaginal.', 'Optionnelle', 'Bloc au triangle de J.L. Petit — analgésie pariétale abdominale', 'Question 6 (suite) — Membre inférieur, rachis, tronc, uro-génital, thorax, digestif, §6-2-8')
) as v(code, statement, grade, condition_topic, source_section)
where d.source_url = 'https://sfar.org/anesthesie-loco-regionale-en-pediatrie/'
on conflict (recommendation_code) do nothing;
