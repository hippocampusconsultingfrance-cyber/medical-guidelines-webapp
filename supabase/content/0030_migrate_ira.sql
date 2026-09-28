-- Migration : Insuffisance rénale aiguë en périopératoire et en réanimation (à l'exclusion
-- des techniques d'épuration extrarénale, objet d'une RFE SRLF dédiée, `eer`/0020) —
-- Recommandations Formalisées d'Experts, SFAR et SRLF, avec la participation du GFRUP
-- (volet pédiatrique) et de la SFN. 24 experts, 9 groupes de travail. Texte validé par le
-- CA SFAR le 19/06/2015, CA SRLF le 06/08/2015. Anesth Reanim. 2016;2:184-205,
-- doi:10.1016/j.anrea.2016.01.006. Source : rfe-sfar-website/build/content_ira.json
-- (33 recommandations, 8 champs, dont volet pédiatrique intégré).
--
-- MÉTHODOLOGIE : GRADE (force forte 1+/1-, force faible 2+/2- via GRADE Grid et méthode
-- Delphi ; avis d'experts AE lorsque la littérature ne permettait pas de graduer). `grade`
-- reproduit tel quel le chip source. `evidence_level` laissé NULL.
--
-- COMPTAGE — RECONCILIÉ EXACTEMENT, CONFIRMÉ PAR LA SOURCE ELLE-MÊME : "33 recommandations
-- formalisées... 9 sont fortes (Grade 1), 16 sont faibles (Grade 2) et, pour 8
-- recommandations, la méthode GRADE ne pouvait pas s'appliquer... avis d'experts... un
-- comptage exact recommandation par recommandation confirme ce total (9+16+8=33), sans
-- écart à signaler cette fois". Comptage direct des 33 lignes migrées ci-dessous : 1+/1- ×9
-- (3×1+, 6×1-), 2+/2- ×16 (13×2+, 3×2-), AE ×8 = reconciliation exacte.
--
-- VOLET PÉDIATRIQUE : contrairement à `intubation_reanimation`/0028 (où 15 recommandations
-- pédiatriques parallèles étaient explicitement absentes du contenu construit), ce document
-- intègre ICI ses 3 recommandations pédiatriques (repères "R1.1 P", "R1.2 P", "R7.1 P")
-- directement DANS le total de 33 — migrées ci-dessous avec `population = 'Pédiatrie'`.
--
-- DISCLOSURE PONCTUELLE : R2.1 est la SEULE des 33 recommandations à n'avoir obtenu qu'un
-- « Accord Faible » lors de la cotation Delphi du groupe de relecture, MALGRÉ un grade
-- GRADE fort (1-) — cohérent avec le résumé de la source, « accord fort obtenu pour 32 des
-- 33 recommandations (99 %) » — noté dans son propre `source_section`, pas un axe
-- `evidence_level` séparé (non imprimé systématiquement ligne à ligne).
--
-- PÉRIMÈTRE — volontairement pas migrés (référence/classification, pas des recommandations
-- individuellement graduées, cohérent avec le principe déjà appliqué ailleurs dans ce
-- corpus) :
-- 1. TABLEAU I — Classification de l'IRA selon les critères KDIGO (référencé par R1.2).
-- 2. TABLEAU II — Critères diagnostiques et de gravité de l'IRA en pédiatrie (pRIFLE)
--    (référencé par R1.2 P).
-- 3. TABLEAU III — Principaux facteurs de risque d'IRA liés au terrain et aux procédures
--    (référencé par R3.1).
-- 4. TABLEAU IV — Principaux agents néphrotoxiques responsables d'IRA (liste de référence,
--    pas une recommandation graduée).
-- 5. FIGURE 1 — De l'agression à la dysfonction rénale (schéma pédagogique à cercles
--    concentriques, redessiné par le contenu construit depuis un schéma source).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. **Collision d'acronyme potentielle SFN**, même pattern que la collision « SFD » déjà
--    documentée dans `eer`/0020 : la source cite comme participante « la SFN » (Société
--    française de néphrologie, d'après le contexte du document — RFE sur l'insuffisance
--    RÉNALE aiguë). Le seed Annexe B de schema_v2.sql contient déjà un acronyme 'SFN'
--    ('France') mais SANS `full_name` renseigné (colonne volontairement NULL,
--    vetting_status='a_valider') — l'expansion la plus courante de ce sigle est toutefois
--    « Société Française de Neurologie », une société complètement différente. PAR
--    PRUDENCE, la SFN de cette source n'est PAS liée au 'SFN' du seed dans cette
--    migration — collision d'acronyme non résolue silencieusement, à trancher par un
--    relecteur humain disposant du `full_name` réel des deux entités. GFRUP non plus dans
--    le seed. Seules SFAR et SRLF liées en document_societies.

insert into public.documents (title, doc_type, original_language, publication_date, doi, source_url, pdf_url, grading_system, freshness_status)
values (
  'Insuffisance rénale aiguë en périopératoire et en réanimation',
  'RFE', 'fr', '2015-06-19',
  '10.1016/j.anrea.2016.01.006',
  'https://sfar.org/insuffisance-renale-aigue/',
  'https://sfar.org/wp-content/uploads/2016/05/ANREA_132_RFE-IRA-.pdf',
  'GRADE® (force forte 1+/1- ou faible 2+/2- via GRADE Grid et méthode Delphi ; avis d''experts AE). 9 Grade1 + 16 Grade2 + 8 AE = 33 recommandations, comptage confirmé exactement par la source elle-même. Accord fort pour 32/33 (99 %) ; seule exception R2.1 (Accord faible malgré un grade fort 1-). Intègre un volet pédiatrique (3 recommandations, repères "Rx.y P") directement dans le total de 33 (contrairement à d''autres RFE de ce corpus où le volet pédiatrique est séparé).',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/insuffisance-renale-aigue/'
  and s.acronym in ('SFAR', 'SRLF') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/insuffisance-renale-aigue/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'nephrologie', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.source_section,
  'https://sfar.org/insuffisance-renale-aigue/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000030-R01', 'Il faut utiliser les critères KDIGO (stade 1) pour définir une IRA par la présence d''au moins 1 des 3 critères diagnostiques suivants : augmentation de la créatinine plasmatique ≥ 26,5 µmol/L en 48 h ; augmentation de la créatinine plasmatique ≥ 1,5 fois la valeur de base au cours des 7 derniers jours ; diurèse < 0,5 mL/kg/h pendant 6 h.', 'AE', null, 'Champ 1 — Diagnostic de l''IRA et évaluation de sa gravité (Réf. R1.1)'),
  ('MG-ANES-000030-R02', 'Il faut utiliser la classification KDIGO pour caractériser la gravité d''une IRA, selon le tableau I ci-dessous.', 'AE', null, 'Champ 1 — Diagnostic de l''IRA et évaluation de sa gravité (Réf. R1.2)'),
  ('MG-ANES-000030-R03', 'Si l''on souhaite estimer le débit de filtration glomérulaire (DFG), il ne faut pas utiliser les formules estimées (Cockroft-Gault, MDRD, CKD-EPI) chez le patient de réanimation ou en postopératoire.', '1-', null, 'Champ 1 — Diagnostic de l''IRA et évaluation de sa gravité (Réf. R1.3)'),
  ('MG-ANES-000030-R04', 'Si l''on souhaite estimer le DFG, il faut probablement utiliser la formule de calcul de la clairance de la créatinine (UV/P créatinine).', '2+', null, 'Champ 1 — Diagnostic de l''IRA et évaluation de sa gravité (Réf. R1.4)'),
  ('MG-ANES-000030-R05', '(Pédiatrique) Chez l''enfant, il faut probablement établir le diagnostic d''IRA en utilisant la classification de RIFLE modifiée pour la pédiatrie (pRIFLE) : clairance estimée de la créatinine diminuée d''au moins 25 %, ou diurèse < 0,5 mL/kg/h pendant 8 heures.', 'AE', 'Pédiatrie', 'Champ 1 — Diagnostic de l''IRA et évaluation de sa gravité (Réf. R1.1 P)'),
  ('MG-ANES-000030-R06', '(Pédiatrique) Chez l''enfant, il faut probablement évaluer la gravité d''une IRA selon les critères de la classification pRIFLE (tableau II ci-dessous).', 'AE', 'Pédiatrie', 'Champ 1 — Diagnostic de l''IRA et évaluation de sa gravité (Réf. R1.2 P)'),
  ('MG-ANES-000030-R07', 'Il ne faut pas utiliser les biomarqueurs rénaux pour faire le diagnostic précoce d''IRA.', '1-', null, 'Champ 2 — Stratégies de diagnostic précoce de l''IRA (Réf. R2.1) [Accord Faible — seule exception disclosée par la source parmi les 33 recommandations, malgré le grade GRADE 1-]'),
  ('MG-ANES-000030-R08', 'Il ne faut probablement pas utiliser l''index de résistance mesuré par le Doppler rénal pour diagnostiquer ou traiter une IRA.', '2-', null, 'Champ 2 — Stratégies de diagnostic précoce de l''IRA (Réf. R2.2)'),
  ('MG-ANES-000030-R09', 'Il faut rechercher les facteurs de risque d''IRA liés au terrain et/ou au contexte (tableau III).', 'AE', null, 'Champ 3 — Évaluation du risque d''IRA (Réf. R3.1)'),
  ('MG-ANES-000030-R10', 'Il faut probablement, dans les situations à risque, surveiller la diurèse et la créatinine plasmatique pour objectiver la survenue d''une atteinte rénale aiguë et prendre les mesures préventives appropriées.', 'AE', null, 'Champ 3 — Évaluation du risque d''IRA (Réf. R3.2)'),
  ('MG-ANES-000030-R11', 'En réanimation, il ne faut pas utiliser les hydroxyéthylamidons (HEA).', '1-', null, 'Champ 4 — Stratégies de prévention non spécifiques de l''IRA (Réf. R4.1)'),
  ('MG-ANES-000030-R12', 'Il faut probablement préférer les cristalloïdes aux colloïdes en cas de remplissage vasculaire.', '2+', null, 'Champ 4 — Stratégies de prévention non spécifiques de l''IRA (Réf. R4.2)'),
  ('MG-ANES-000030-R13', 'Il faut probablement préférer les solutés balancés en cas de remplissage vasculaire important.', '2+', null, 'Champ 4 — Stratégies de prévention non spécifiques de l''IRA (Réf. R4.3)'),
  ('MG-ANES-000030-R14', 'Il faut maintenir un niveau minimal de pression artérielle moyenne (PAM) compris entre 60 et 70 mmHg pour prévenir et traiter l''IRA.', '1+', null, 'Champ 4 — Stratégies de prévention non spécifiques de l''IRA (Réf. R4.4)'),
  ('MG-ANES-000030-R15', 'Il faut probablement considérer que les patients hypertendus requièrent un objectif de PAM > 70 mmHg.', '2+', null, 'Champ 4 — Stratégies de prévention non spécifiques de l''IRA (Réf. R4.5)'),
  ('MG-ANES-000030-R16', 'Il faut monitorer et optimiser le volume d''éjection systolique ou ses dérivés en période périopératoire afin de guider le remplissage vasculaire.', '1+', null, 'Champ 4 — Stratégies de prévention non spécifiques de l''IRA (Réf. R4.6)'),
  ('MG-ANES-000030-R17', 'Il faut probablement appliquer les mêmes recommandations de monitorage/optimisation hémodynamique en réanimation.', '2+', null, 'Champ 4 — Stratégies de prévention non spécifiques de l''IRA (Réf. R4.7)'),
  ('MG-ANES-000030-R18', 'Après stabilisation hémodynamique, il faut probablement éviter la surcharge hydro-sodée en réanimation.', '2+', null, 'Champ 4 — Stratégies de prévention non spécifiques de l''IRA (Réf. R4.8)'),
  ('MG-ANES-000030-R19', 'Si un vasoconstricteur est nécessaire, il faut probablement utiliser la noradrénaline en première intention pour maintenir les objectifs de PAM.', '2+', null, 'Champ 4 — Stratégies de prévention non spécifiques de l''IRA (Réf. R4.9)'),
  ('MG-ANES-000030-R20', 'Il ne faut probablement pas retarder la réalisation d''examens complémentaires ou l''administration de médicaments potentiellement néphrotoxiques s''ils sont nécessaires à la prise en charge du patient.', 'AE', null, 'Champ 4 — Stratégies de prévention non spécifiques de l''IRA (Réf. R4.10)'),
  ('MG-ANES-000030-R21', 'Il faut probablement recourir à une hydratation par cristalloïdes pour prévenir la néphropathie associée aux produits de contraste iodés, idéalement avant l''injection et en poursuivant l''hydratation pendant 6 à 12 heures.', '2+', null, 'Champ 5 — Gestion des agents néphrotoxiques (Réf. R5.1)'),
  ('MG-ANES-000030-R22', 'Il ne faut probablement pas utiliser la N-acétylcystéine et/ou le bicarbonate de sodium en prévention de la néphropathie associée aux produits de contraste.', '2-', null, 'Champ 5 — Gestion des agents néphrotoxiques (Réf. R5.2)'),
  ('MG-ANES-000030-R23', 'Il faut probablement appliquer les règles suivantes lorsque l''usage d''aminosides est nécessaire : administrer en une injection par jour ; monitorer les taux résiduels au-delà d''une injection ; administrer au maximum 3 jours à chaque fois que possible.', '2+', null, 'Champ 5 — Gestion des agents néphrotoxiques (Réf. R5.3)'),
  ('MG-ANES-000030-R24', 'Il faut probablement ne pas utiliser les anti-inflammatoires non stéroïdiens (AINS), inhibiteurs de l''enzyme de conversion (IEC) et antagonistes des récepteurs de l''angiotensine 2 (ARA2) chez les patients à risque d''IRA.', 'AE', null, 'Champ 5 — Gestion des agents néphrotoxiques (Réf. R5.4)'),
  ('MG-ANES-000030-R25', 'Il ne faut pas utiliser de diurétiques dans l''objectif de prévenir ou traiter une IRA ; il faut probablement les réserver au traitement de la surcharge hydro-sodée.', '1-', null, 'Champ 6 — Stratégies pharmacologiques de prévention et de traitement de l''IRA (Réf. R6.1)'),
  ('MG-ANES-000030-R26', 'Il ne faut probablement pas utiliser le bicarbonate de sodium pour prévenir ou traiter une IRA.', '2-', null, 'Champ 6 — Stratégies pharmacologiques de prévention et de traitement de l''IRA (Réf. R6.2)'),
  ('MG-ANES-000030-R27', 'Il ne faut pas utiliser les traitements suivants dans l''objectif de prévenir ou traiter une IRA : mannitol, dopamine, fenoldopam, facteur atrial natriurétique, N-acétylcystéine, insulin-like growth factor-1, érythropoïétine, antagonistes des récepteurs de l''adénosine.', '1-', null, 'Champ 6 — Stratégies pharmacologiques de prévention et de traitement de l''IRA (Réf. R6.3)'),
  ('MG-ANES-000030-R28', 'Il faut probablement appliquer les mêmes règles de support nutritionnel chez le patient de réanimation en présence ou non d''une IRA (sans EER).', '2+', null, 'Champ 7 — Modalités de nutrition en cas d''IRA (Réf. R7.1)'),
  ('MG-ANES-000030-R29', 'Il ne faut pas limiter les apports nutritionnels dans le seul but de prévenir la surcharge hydro-sodée et/ou le recours à l''EER.', '1-', null, 'Champ 7 — Modalités de nutrition en cas d''IRA (Réf. R7.2)'),
  ('MG-ANES-000030-R30', '(Pédiatrique) Il faut probablement adapter les apports protéiques en fonction de l''âge des enfants présentant une IRA.', '2+', 'Pédiatrie', 'Champ 7 — Modalités de nutrition en cas d''IRA (Réf. R7.1 P)'),
  ('MG-ANES-000030-R31', 'Il faut considérer à risque de survenue d''insuffisance rénale chronique les patients ayant présenté une IRA.', '1+', null, 'Champ 8 — Évaluation de la récupération de la fonction rénale après IRA (Réf. R8.1)'),
  ('MG-ANES-000030-R32', 'Il faut probablement évaluer la fonction rénale des patients ayant présenté une IRA 6 mois après la survenue de l''épisode aigu.', '2+', null, 'Champ 8 — Évaluation de la récupération de la fonction rénale après IRA (Réf. R8.2)'),
  ('MG-ANES-000030-R33', 'Il faut probablement définir la non-récupération de la fonction rénale après IRA comme suit : augmentation de la créatinine plasmatique de plus de 25 % de la valeur de base, ou dépendance à l''EER.', '2+', null, 'Champ 8 — Évaluation de la récupération de la fonction rénale après IRA (Réf. R8.3)')
) as v(code, statement, grade, population, source_section)
where d.source_url = 'https://sfar.org/insuffisance-renale-aigue/'
on conflict (recommendation_code) do nothing;
