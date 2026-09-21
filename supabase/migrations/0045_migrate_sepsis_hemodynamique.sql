-- Migration : Prise en charge hémodynamique du sepsis grave (nouveau-né
-- exclu) — Conférence de Consensus commune Sfar/SRLF, 2006, texte court du
-- jury. Publication e-only Ann Fr Anesth Réanim 2006;25 / Réanimation
-- 2006;15. Source : rfe-sfar-website/build/content_sepsis_hemodynamique.json
-- (33 recommandations graduées réparties en 5 questions). **Distinct de la
-- fiche `sepsis` (HAS RPC 2025, migration 0044)** : périmètre strictement
-- hémodynamique/circulatoire (le jury précise explicitement que les autres
-- défaillances d'organe — rein, foie, système nerveux, hémostase — ne sont
-- pas traitées ici), document plus ancien (2006), href et contenu vérifiés
-- distincts dans `library_final.json`.
--
-- MÉTHODOLOGIE — COTATION À LETTRE UNIQUE, NON-GRADE : chaque énoncé porte
-- une seule lettre « grade X » (B/C/D/E dans ce texte, AUCUNE occurrence de
-- grade A). Le texte court ne redéfinit nulle part la signification de
-- chaque lettre — disclosure explicite de la source elle-même (échelle
-- présumée détaillée dans l'argumentaire scientifique long, non disponible
-- pour cette fiche), même situation que hsa/0023 (grades A/B/D/E non
-- définis). `grade` reproduit littéralement la lettre source. `evidence_level`
-- laissé NULL.
--
-- COMPTAGE — EXACTEMENT RECONCILIÉ (33 = 18E + 10B + 3C + 2D) : le contenu
-- construit annonce lui-même ce total exact, confirmé par comptage direct.
-- **1 recommandation (grade D, "après la phase initiale : poursuivre le
-- remplissage...") est imprimée par la source comme un paragraphe autonome
-- suivi d'une note "Grade D" séparée, PAS dans le tableau à 3 colonnes
-- Réf./Recommandation/Grade utilisé partout ailleurs dans ce document** —
-- disclosure explicite : `source_section` le signale "sans repère imprimé"
-- plutôt que d'inventer un numéro Réf. inexistant dans la source (aucune
-- table Réf./Recommandation/Grade ne la contient).
--
-- ANOMALIES DE LA SOURCE DISCLOSÉES PAR LE CONTENU CONSTRUIT LUI-MÊME (non
-- résolues silencieusement, vérifiées à 600dpi contre le rendu visuel du
-- PDF, pas un artefact d'extraction) — concernent le Tableau 1
-- (définitions, NON migré, cf. ci-dessous) donc mentionnées ici pour
-- traçabilité complète : (1) deux valeurs pédiatriques (recoloration
-- capillaire, SpO2) ne portent explicitement aucun repère "(E)" dans le
-- texte source, contrairement aux autres lignes du même tableau ; (2) le
-- texte source imprime littéralement "> 176 mmol/l" et "> 78 mmol/l" pour
-- la créatininémie/bilirubinémie — valeurs cliniquement impossibles dans
-- cette unité, très probable coquille pour µmol/l (seuils standards
-- ACCP/SCCM), reproduites en µmol/l par le contenu construit plutôt que
-- littéralement trompeuses ; (3) le seuil de non-réponse au test ACTH
-- (Réf. 4.1) est imprimé avec un blanc typographique avant "9 µg/dl" dans
-- la source (aucun symbole visible) — "< 9 µg/dl" retenu comme la
-- définition usuelle de la non-réponse au Synacthène, disclosure du
-- contenu construit reproduite dans le `statement` migré de la Réf. 4.1.
--
-- PÉRIMÈTRE — volontairement pas migrés : Tableau 1 (définitions du
-- sepsis/sepsis grave/choc septique — contenu de référence diagnostique,
-- pas une recommandation graduée) ; l'algorithme décisionnel de la
-- Question 5 (Figure 1, redessiné par le contenu construit en 3 panneaux
-- séquentiels pour la lisibilité — synthèse du contenu déjà gradué,
-- SANS chip individuel par étape).
--
-- POPULATION : 6 recommandations marquées "P" par la source (repère
-- Rx.y P) taguées `population = 'Pédiatrie'` ; le reste (adulte par
-- défaut, nouveau-né exclu du champ) laissé NULL.
--
-- FRAÎCHEUR — disclosure explicite de la source elle-même, reproduite :
-- « Conférence de 2006 : se référer également, en complément, aux données
-- et pratiques plus récentes sur la prise en charge du sepsis (Surviving
-- Sepsis Campaign, RFE françaises postérieures) et à un avis spécialisé en
-- cas de doute. » — `freshness_status = 'revision_detectee'` retenu.
-- **Cette RFE/RPC plus récente existe désormais dans ce même corpus** :
-- voir `sepsis`/0044 (HAS RPC 2025), qui reproduit intégralement la
-- Surviving Sepsis Campaign 2021/2020 et couvre un périmètre beaucoup plus
-- large (149 items vs 33 ici) — les deux documents restent migrés
-- séparément (statut `draft`, pas de fusion ni de dépréciation automatique
-- : décision de dépréciation éditoriale à laisser à la relecture humaine).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFAR et SRLF (toutes deux dans le seed Annexe B, conférence commune)
--    liées en document_societies.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge hémodynamique du sepsis grave (nouveau-né exclu)',
  'CC', 'fr', '2006-01-01',
  'https://sfar.org/prise-en-charge-hemodynamique-du-sepsis-grave-nouveau-ne-exclu/',
  'https://sfar.org/wp-content/uploads/2015/10/2a_TEXTE-COURT_Prise-en-charge-hemodynamique-du-sepsis-grave.pdf',
  'Cotation à lettre unique (grade B/C/D/E dans ce texte, aucun grade A utilisé) — non-GRADE. Signification de chaque lettre non redéfinie dans ce texte court (disclosure explicite de la source). 33 recommandations exactement reconciliées (18E, 10B, 3C, 2D), dont 1 imprimée hors du tableau standard Réf./Recommandation/Grade (paragraphe autonome + note de grade séparée).',
  'revision_detectee'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-hemodynamique-du-sepsis-grave-nouveau-ne-exclu/'
  and s.acronym in ('SFAR', 'SRLF') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-hemodynamique-du-sepsis-grave-nouveau-ne-exclu/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.source_section,
  'https://sfar.org/prise-en-charge-hemodynamique-du-sepsis-grave-nouveau-ne-exclu/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000045-R01', 'La diurèse horaire et l''évolution biologique de la fonction rénale et de la lactatémie au cours du traitement sont les seuls paramètres de surveillance de la microcirculation disponibles (les possibilités de monitorage de la microcirculation sont limitées et les thérapeutiques spécifiques inexistantes).', 'E', null, 'Question 1 — Quelles sont les cibles thérapeutiques ? (Réf. 1.1)'),
  ('MG-ANES-000045-R02', 'Le remplissage vasculaire précoce est recommandé : il augmente le transport de l''oxygène, corrige l''hypotension artérielle et améliore le pronostic des patients en sepsis grave.', 'B', null, 'Question 1 — Quelles sont les cibles thérapeutiques ? (Réf. 1.2)'),
  ('MG-ANES-000045-R03', 'En dehors du traitement de la vasoplégie par amines vasoconstrictrices, il n''existe pas de thérapeutique spécifique de la dysfonction vasculaire.', 'B', null, 'Question 1 — Quelles sont les cibles thérapeutiques ? (Réf. 1.3)'),
  ('MG-ANES-000045-R04', 'Seuls 10 à 20 % des patients adultes évoluent vers la défaillance cardiaque (index cardiaque et SvO2 bas persistant après expansion volémique) ; le traitement inotrope positif est réservé à ces patients.', 'B', null, 'Question 1 — Quelles sont les cibles thérapeutiques ? (Réf. 1.4)'),
  ('MG-ANES-000045-R05', '(Pédiatrie) Le sepsis grave de l''enfant se caractérise par une défaillance myocardique plus fréquente et une hypovolémie majeure répondant bien au remplissage. Le diagnostic est difficile (hypotension souvent tardive) : la rapidité du diagnostic et d''une expansion volémique agressive associée à une antibiothérapie très précoce est recommandée (mortalité pédiatrique plus faible que chez l''adulte ; le Purpura fulminans mérite d''être individualisé).', 'D', 'Pédiatrie', 'Question 1 — Quelles sont les cibles thérapeutiques ? (Réf. 1.5 P)'),
  ('MG-ANES-000045-R06', 'L''urgence est au remplissage vasculaire systématique (hypovolémie constante) : aucun indice prédictif de la réponse au remplissage n''est nécessaire pour sa mise en œuvre. Objectif recommandé : PAM > 65 mmHg.', 'C', null, 'Question 2 — Modalités de l''expansion volémique (y compris transfusion) (Réf. 2.1a)'),
  ('MG-ANES-000045-R07', 'Lorsque l''hypotension engage le pronostic vital (ex. PAD < 40 mmHg), le recours aux agents vasopresseurs doit être immédiat, quelle que soit la volémie.', 'E', null, 'Question 2 — Modalités de l''expansion volémique (y compris transfusion) (Réf. 2.1b)'),
  ('MG-ANES-000045-R08', 'Après la phase initiale : poursuivre le remplissage en utilisant des indices prédictifs dynamiques de l''état de réserve de précharge.', 'D', null, 'Question 2 — Modalités de l''expansion volémique (y compris transfusion) (Réf. sans repère imprimé, suite de 2.1)'),
  ('MG-ANES-000045-R09', 'Cristalloïdes/colloïdes titrés pour un même objectif hémodynamique ont une efficacité équivalente ; compte tenu d''un coût moindre et de leur innocuité, les cristalloïdes isotoniques sont recommandés, surtout à la phase initiale du choc (produits sanguins, dextrans et amidons de PM > 150 kDa proscrits comme solutés de remplissage).', 'B', null, 'Question 2 — Modalités de l''expansion volémique (y compris transfusion) (Réf. 2.2)'),
  ('MG-ANES-000045-R10', 'Le remplissage s''effectue par séquences de 500 ml de cristalloïdes isotoniques en 15 min.', 'E', null, 'Question 2 — Modalités de l''expansion volémique (y compris transfusion) (Réf. 2.3a)'),
  ('MG-ANES-000045-R11', 'Ces séquences doivent être répétées jusqu''à obtention d''une PAM > 65 mmHg, en l''absence de signes d''œdème pulmonaire.', 'B', null, 'Question 2 — Modalités de l''expansion volémique (y compris transfusion) (Réf. 2.3b)'),
  ('MG-ANES-000045-R12', 'Si l''objectif de PAM n''est pas atteint, le recours aux amines vasopressives est indiqué.', 'E', null, 'Question 2 — Modalités de l''expansion volémique (y compris transfusion) (Réf. 2.3c)'),
  ('MG-ANES-000045-R13', 'Objectif : taux d''hémoglobine de 8 à 9 g/dl.', 'C', null, 'Question 2 — Modalités de l''expansion volémique (y compris transfusion) (Réf. 2.4a)'),
  ('MG-ANES-000045-R14', 'Des taux différents peuvent être justifiés par une intolérance clinique et/ou la mesure de la SvcO2.', 'E', null, 'Question 2 — Modalités de l''expansion volémique (y compris transfusion) (Réf. 2.4b)'),
  ('MG-ANES-000045-R15', '(Pédiatrie) Au cours de la première heure, un remplissage vasculaire jusqu''à 60 ml/kg est recommandé car il réduit la mortalité.', 'E', 'Pédiatrie', 'Question 2 — Modalités de l''expansion volémique (y compris transfusion) (Réf. 2.5a P)'),
  ('MG-ANES-000045-R16', '(Pédiatrie) Pour les mêmes raisons que chez l''adulte, les cristalloïdes sont préférés.', 'B', 'Pédiatrie', 'Question 2 — Modalités de l''expansion volémique (y compris transfusion) (Réf. 2.5b P)'),
  ('MG-ANES-000045-R17', 'Les vasoconstricteurs doivent être utilisés si le remplissage vasculaire ne permet pas d''obtenir une PAM > 65 mmHg.', 'B', null, 'Question 3 — Place des médicaments inotropes positifs et vasoactifs (Réf. 3.1a)'),
  ('MG-ANES-000045-R18', 'Leur utilisation précoce est recommandée : elle permet de limiter la survenue des défaillances viscérales.', 'E', null, 'Question 3 — Place des médicaments inotropes positifs et vasoactifs (Réf. 3.1b)'),
  ('MG-ANES-000045-R19', 'La noradrénaline, amine vasoconstrictrice la plus puissante, doit être utilisée en première intention.', 'E', null, 'Question 3 — Place des médicaments inotropes positifs et vasoactifs (Réf. 3.1c)'),
  ('MG-ANES-000045-R20', 'La vasopressine (0,01 à 0,04 U/min) ou la terlipressine (bolus de 1 à 2 mg) peut être utilisée dans les chocs réfractaires.', 'E', null, 'Question 3 — Place des médicaments inotropes positifs et vasoactifs (Réf. 3.1d)'),
  ('MG-ANES-000045-R21', 'L''adjonction systématique des inotropes n''est pas recommandée.', 'E', null, 'Question 3 — Place des médicaments inotropes positifs et vasoactifs (Réf. 3.2a)'),
  ('MG-ANES-000045-R22', 'Chez un patient ayant bénéficié d''un traitement bien conduit (optimisation de la volémie, vasopresseurs, correction d''une anémie), l''indication des inotropes ne peut pas se justifier par une valeur isolée de débit cardiaque : elle doit toujours être associée à une SvcO2 < 70 %.', 'B', null, 'Question 3 — Place des médicaments inotropes positifs et vasoactifs (Réf. 3.2b)'),
  ('MG-ANES-000045-R23', 'Il est recommandé d''évaluer l''efficacité du traitement inotrope sur l''amélioration de la SvcO2, la baisse de la lactatémie et la surveillance des paramètres de fonction myocardique.', 'E', null, 'Question 3 — Place des médicaments inotropes positifs et vasoactifs (Réf. 3.2c)'),
  ('MG-ANES-000045-R24', 'L''association dobutamine + noradrénaline (composantes α1/β2 adaptées séparément) est recommandée en première intention ; l''adrénaline apparaît aussi efficace mais ses effets métaboliques peuvent restreindre son utilisation (non gradé).', 'E', null, 'Question 3 — Place des médicaments inotropes positifs et vasoactifs (Réf. 3.2d)'),
  ('MG-ANES-000045-R25', '(Pédiatrie) La noradrénaline peut être recommandée en première intention.', 'E', 'Pédiatrie', 'Question 3 — Place des médicaments inotropes positifs et vasoactifs (Réf. 3.3a P)'),
  ('MG-ANES-000045-R26', '(Pédiatrie) Les inhibiteurs de la phosphodiestérase de type III peuvent être envisagés dans les états de bas débit cardiaque à PA normale.', 'C', 'Pédiatrie', 'Question 3 — Place des médicaments inotropes positifs et vasoactifs (Réf. 3.3b P)'),
  ('MG-ANES-000045-R27', 'La corticothérapie est recommandée précocement au cours du choc septique chez les patients non répondeurs à l''injection de 250 µg d''ACTH (augmentation de la cortisolémie < 9 µg/dl‡).', 'B', null, 'Question 4 — Place des traitements complémentaires (Réf. 4.1)'),
  ('MG-ANES-000045-R28', 'Hémisuccinate d''hydrocortisone 200 à 300 mg/j, pendant au moins cinq jours, suivi d''une décroissance progressive.', 'E', null, 'Question 4 — Place des traitements complémentaires (Réf. 4.2)'),
  ('MG-ANES-000045-R29', 'La protéine C activée recombinante d''origine humaine ne doit pas être utilisée dans l''indication hémodynamique exclusive.', 'E', null, 'Question 4 — Place des traitements complémentaires (Réf. 4.3)'),
  ('MG-ANES-000045-R30', 'L''hémofiltration n''est pas recommandée pour la prise en charge hémodynamique du choc septique en dehors d''une défaillance rénale associée.', 'E', null, 'Question 4 — Place des traitements complémentaires (Réf. 4.4)'),
  ('MG-ANES-000045-R31', 'Les autres techniques d''épuration des médiateurs ne sont pas recommandées.', 'E', null, 'Question 4 — Place des traitements complémentaires (Réf. 4.5)'),
  ('MG-ANES-000045-R32', 'Il est recommandé de ne pas utiliser les inhibiteurs non sélectifs de la NO synthase inductible : ils augmentent la mortalité.', 'B', null, 'Question 4 — Place des traitements complémentaires (Réf. 4.6)'),
  ('MG-ANES-000045-R33', '(Pédiatrie) Dose d''hydrocortisone recommandée : 1 mg/kg toutes les six heures.', 'E', 'Pédiatrie', 'Question 4 — Place des traitements complémentaires (Réf. 4.7 P)')) as v(code, statement, grade, population, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-hemodynamique-du-sepsis-grave-nouveau-ne-exclu/'
on conflict (recommendation_code) do nothing;
