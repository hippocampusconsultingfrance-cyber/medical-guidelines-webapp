-- Migration : Contrôle de la glycémie en réanimation et en anesthésie — Recommandations
-- Formalisées d'Experts Sfar/SRLF, en partenariat avec l'Alfediam, l'Adarpef, le Gefrup, la
-- Sbar (Société belge d'anesthésie-réanimation), la SFNEP et la SIZ. 21 experts francophones
-- (France, Belgique, Suisse), coordination Carole Ichai. Ann Fr Anesth Reanim 2009;28:410-415,
-- doi:10.1016/j.annfar.2009.02.020. Validées juillet 2008.
-- Source : rfe-sfar-website/build/content_glycemie.json (74 recommandations, champs 5-10).
--
-- MÉTHODOLOGIE — DEUX AXES INDÉPENDANTS (encore une convention distincte de ce corpus,
-- documentée en détail dans `rfe-sfar-website/build/fiche_glycemie.py`, docstring) : la
-- méthode GRADE a servi de cadre général, mais CHAQUE recommandation porte, dans le texte
-- source, DEUX cotations distinctes et indépendantes, jamais fusionnées :
--   - NGP (Niveau Global de Preuve) : Fort / Modéré / Faible — solidité de la littérature ;
--   - Accord : Fort / Faible (+ 1 cas unique « Indécision ») — force du consensus des
--     experts (vote 1-9, médiane, 3 zones).
-- La source le précise explicitement : « il est possible d'obtenir un accord fort sur une
-- proposition avec faible NGP et inversement ». Convention de mapping retenue ici, cohérente
-- avec celle déjà utilisée dans ce corpus pour d'autres systèmes à deux axes indépendants
-- (Force -> grade, Preuve -> evidence_level, ex. 0013_migrate_asthme_aigu_grave.sql,
-- 0015_migrate_civd.sql) : **Accord -> `grade`, NGP -> `evidence_level`** (Accord est
-- l'axe le plus proche conceptuellement de la force d'une recommandation GRADE classique ;
-- NGP est l'axe le plus proche de la qualité de preuve GRADE classique). Valeurs reproduites
-- littéralement ('Fort'/'Modéré'/'Faible'/'Indécision'), jamais converties vers la notation
-- GRADE 1+/2+/AE utilisée ailleurs dans ce corpus.
--
-- DEUX ANOMALIES SOURCE-INTERNES CONFIRMÉES (disclosées telles quelles dans le docstring du
-- script de construction de la fiche, `fiche_glycemie.py`, lui-même vérifié par lecture
-- directe du PDF à 250 dpi — reproduites ici pour la migration) :
-- 1. Sur les 74 recommandations, UNE SEULE (Champ 7, « Mesure en SSPI ») ne porte AUCUNE
--    cotation imprimée dans le texte source (ni NGP ni Accord) — R31 ci-dessous, `grade` et
--    `evidence_level` laissés NULL plutôt qu'une cotation inventée, `source_section` note
--    explicitement l'anomalie. Ceci concilie les deux comptages que la source donne
--    elle-même : "74 recommandations" (introduction) et "73 ont fait l'objet d'un accord
--    (fort ou faible) et une seule est restée en indécision" (73 + 1 [Modéré, cf. point 2]
--    + ... = 74, moins la phrase SSPI non cotée du tout).
-- 2. La méthodologie déclarée ne définit QUE « fort »/« faible » pour l'axe Accord — pourtant
--    une recommandation (R32 ci-dessous, Champ 8, « Arrêt insuline IV / relais ») porte
--    littéralement le tag « (accord modéré) » dans la source, niveau non prévu par la
--    méthodologie pour cet axe. Transcrit ici verbatim (`grade = 'Modéré'`), SANS le forcer
--    vers 'Fort' ou 'Faible' — ce serait une invention non disclosée.
-- Le seul cas d'« Indécision » (R34, Champ 8, glucose chez le cérébrolésé) est également
-- reproduit littéralement (`grade = 'Indécision'`), jamais assimilé à un Accord standard.
--
-- COMPTAGE — RECONCILIÉ EXACTEMENT : 74 lignes migrées, comptage direct des tableaux
-- "Thème | Recommandation | NGP | Accord" des champs 5 à 10 — correspond exactement au
-- chiffre que la source annonce elle-même dans son introduction.
--
-- PÉRIMÈTRE — volontairement pas migrés : les champs 1 à 4 (métabolisme du glucose/de
-- l'insuline en situation physiologique/pathologique) — la source dit elle-même
-- explicitement que ces champs "ne pouvaient pas faire l'objet de recommandations avec de
-- vraies cotations" et sont "résumés sous forme de points forts élaborés par les experts" :
-- contenu de contexte physiopathologique, pas des recommandations individuellement cotées,
-- cohérent avec le principe de ce projet de ne jamais fabriquer une cotation absente.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Document de 2009 — la fiche source elle-même avertit : "vérifier l'existence d'une
--    actualisation plus récente en cas de doute (les cibles glycémiques en réanimation ont
--    notamment évolué depuis dans la littérature)". `freshness_status` mis à
--    `revision_detectee` (et non `a_jour`) pour cette raison, bien que `library_final.json`
--    indique `"status": "en vigueur"` — divergence disclosée, à trancher par un relecteur
--    humain (même pattern que `eclsa`/0019).
-- 2. Sociétés partenaires (Alfediam, Adarpef, Gefrup, Sbar, SFNEP, SIZ) : aucune ne
--    correspond à un acronyme du seed Annexe B de schema_v2.sql — seules SFAR et SRLF sont
--    liées en document_societies (organisatrices principales).

insert into public.documents (title, doc_type, original_language, publication_date, doi, source_url, pdf_url, grading_system, freshness_status)
values (
  'Contrôle de la glycémie en réanimation et en anesthésie',
  'RFE', 'fr', '2009-03-27',
  '10.1016/j.annfar.2009.02.020',
  'https://sfar.org/controle-de-la-glycemie-en-reanimation-et-en-anesthesie/',
  'https://sfar.org/wp-content/uploads/2015/10/2b_AFAR_Contrele-de-la-glycemie-en-reanimation-et-en-anesthesie_une-reactualisation-necessaire.pdf',
  'Méthode GRADE adaptée à DEUX axes indépendants, jamais fusionnés : NGP (Niveau Global de Preuve : Fort/Modéré/Faible, solidité de la littérature) et Accord (Fort/Faible + 1 cas « Indécision », force du consensus des experts par vote 1-9). La source précise explicitement qu''un accord fort est possible avec un NGP faible et inversement. Convention de migration : Accord -> grade, NGP -> evidence_level. 2 anomalies disclosées : 1 recommandation sans aucune cotation imprimée (N/D), 1 recommandation avec un tag « accord modéré » non prévu par la méthodologie déclarée (reproduit littéralement).',
  'revision_detectee'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/controle-de-la-glycemie-en-reanimation-et-en-anesthesie/'
  and s.acronym in ('SFAR', 'SRLF') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/controle-de-la-glycemie-en-reanimation-et-en-anesthesie/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'endocrinologie_diabetologie_maladies_metaboliques', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, evidence_level, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.evidence_level, v.population, v.source_section,
  'https://sfar.org/controle-de-la-glycemie-en-reanimation-et-en-anesthesie/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000022-R01', 'Chez les patients de réanimation, il faut probablement un seuil glycémique inférieur à 3,3 mmol/l (0,6 g/l) pour définir une hypoglycémie.', 'Faible', 'Faible', null, 'Champ 5 — L''hypoglycémie : diagnostic et risques — Thème : Seuil hypoglycémie'),
  ('MG-ANES-000022-R02', 'Chez les patients de réanimation, il faut probablement un seuil glycémique inférieur à 2,2 mmol/l (0,4 g/l) pour définir une hypoglycémie sévère.', 'Fort', 'Faible', null, 'Champ 5 — L''hypoglycémie : diagnostic et risques — Thème : Seuil hypoglycémie sévère'),
  ('MG-ANES-000022-R03', 'Par analogie avec le patient diabétique, il est probable que le caractère prolongé d''une hypoglycémie se définisse pour une durée de plus de deux heures.', 'Faible', 'Faible', null, 'Champ 5 — L''hypoglycémie : diagnostic et risques — Thème : Durée prolongée'),
  ('MG-ANES-000022-R04', 'Il est possible que l''application de stratégies publiées de contrôle glycémique strict expose à une augmentation de l''incidence des hypoglycémies sévères.', 'Fort', 'Fort', null, 'Champ 5 — L''hypoglycémie : diagnostic et risques — Thème : Contrôle strict — incidence'),
  ('MG-ANES-000022-R05', 'Il est possible que l''application de stratégies publiées de contrôle glycémique strict expose à une augmentation de la durée des hypoglycémies sévères.', 'Fort', 'Fort', null, 'Champ 5 — L''hypoglycémie : diagnostic et risques — Thème : Contrôle strict — durée'),
  ('MG-ANES-000022-R06', 'Une hypoglycémie sévère et prolongée peut induire des lésions cérébrales irréversibles.', 'Fort', 'Fort', null, 'Champ 5 — L''hypoglycémie : diagnostic et risques — Thème : Risque cérébral'),
  ('MG-ANES-000022-R07', 'Chez les patients de réanimation ne pouvant pas s''exprimer, il ne faut pas se baser uniquement sur les signes cliniques évocateurs pour dépister les épisodes d''hypoglycémies.', 'Fort', 'Fort', null, 'Champ 5 — L''hypoglycémie : diagnostic et risques — Thème : Dépistage clinique insuffisant'),
  ('MG-ANES-000022-R08', 'Il est probable que la survenue d''une hypoglycémie sévère soit associée à un risque de surmortalité, sans lien démontré de causalité entre les deux.', 'Faible', 'Modéré', null, 'Champ 5 — L''hypoglycémie : diagnostic et risques — Thème : Surmortalité'),
  ('MG-ANES-000022-R09', 'Il est possible que les lésions neurologiques observées au décours des hypoglycémies soient en partie liées à la recharge excessive en glucose.', 'Fort', 'Faible', null, 'Champ 5 — L''hypoglycémie : diagnostic et risques — Thème : Recharge en glucose'),
  ('MG-ANES-000022-R10', 'Dans le cadre d''une stratégie de contrôle glycémique strict, il faut réaliser une surveillance rapprochée des mesures de glycémie pour le dépistage précoce des hypoglycémies sévères.', 'Fort', 'Fort', null, 'Champ 5 — L''hypoglycémie : diagnostic et risques — Thème : Surveillance rapprochée'),
  ('MG-ANES-000022-R11', 'Chez les patients de réanimation chez qui on suspecte une hypoglycémie, l''utilisation d''échantillons artériels ou veineux est plus appropriée que celle réalisée sur l''échantillon capillaire qui surestime le plus souvent la valeur de la glycémie.', 'Fort', 'Fort', null, 'Champ 5 — L''hypoglycémie : diagnostic et risques — Thème : Choix du prélèvement'),
  ('MG-ANES-000022-R12', 'Il faut probablement exercer un contrôle du niveau glycémique avec une cible inférieur à 6,1 mmol/l (1,1 g/l) chez les patients adultes en réanimation car ce contrôle permet de diminuer les complications pendant l''hospitalisation.', 'Faible', 'Fort', null, 'Champ 6 — Le contrôle glycémique en réanimation — Thème : Cible < 6,1 mmol/l — adultes'),
  ('MG-ANES-000022-R13', 'Il faut exercer un contrôle strict de la glycémie (< 6,1 mmol/l ou 1,1 g/l) chez les patients adultes chirurgicaux en réanimation.', 'Faible', 'Fort', null, 'Champ 6 — Le contrôle glycémique en réanimation — Thème : Contrôle strict — chirurgicaux'),
  ('MG-ANES-000022-R14', 'Il faut maintenir une glycémie inférieure à 6,1 mmol/l (1,1 g/l) chez les patients de chirurgie cardiaque en réanimation.', 'Faible', 'Fort', null, 'Champ 6 — Le contrôle glycémique en réanimation — Thème : Chirurgie cardiaque'),
  ('MG-ANES-000022-R15', 'Il n''est pas raisonnable de recommander un contrôle strict de la glycémie en urgence.', 'Fort', 'Faible', null, 'Champ 6 — Le contrôle glycémique en réanimation — Thème : Contrôle strict en urgence'),
  ('MG-ANES-000022-R16', 'En réanimation, il faut probablement éviter les variations glycémiques trop importantes.', 'Fort', 'Faible', null, 'Champ 6 — Le contrôle glycémique en réanimation — Thème : Variations glycémiques'),
  ('MG-ANES-000022-R17', 'En dehors de l''insuline intraveineuse, il n''est pas possible d''utiliser d''autres moyens pour le contrôle glycémique en réanimation.', 'Faible', 'Fort', null, 'Champ 6 — Le contrôle glycémique en réanimation — Thème : Voie d''administration'),
  ('MG-ANES-000022-R18', 'La perfusion de glucose-insuline-potassium (GIK), n''a probablement pas d''effet bénéfique si le niveau glycémique n''est pas contrôlé.', 'Faible', 'Fort', null, 'Champ 6 — Le contrôle glycémique en réanimation — Thème : Perfusion GIK'),
  ('MG-ANES-000022-R19', 'L''insulinorésistance, cause principale de l''hyperglycémie périopératoire, peut apparaître dans les premières heures de l''intervention et se prolonger au moins deux à trois semaines en postopératoire.', 'Faible', 'Fort', null, 'Champ 7 — Le contrôle glycémique en périopératoire — Thème : Insulinorésistance périop.'),
  ('MG-ANES-000022-R20', 'Il est possible de diminuer l''hyperglycémie périopératoire induite par l''insulinorésistance en apportant de l''insuline exogène durant cette période.', 'Faible', 'Fort', null, 'Champ 7 — Le contrôle glycémique en périopératoire — Thème : Insuline exogène'),
  ('MG-ANES-000022-R21', 'Il est possible de diminuer la durée de séjour postopératoire en limitant l''insulinorésistance périopératoire avec maintien d''une normoglycémie.', 'Faible', 'Fort', null, 'Champ 7 — Le contrôle glycémique en périopératoire — Thème : Durée de séjour'),
  ('MG-ANES-000022-R22', 'Il faut lutter contre l''hypothermie, les pertes sanguines, l''agression chirurgicale intense qui accentuent l''insulinorésistance périopératoire.', 'Fort', 'Modéré', null, 'Champ 7 — Le contrôle glycémique en périopératoire — Thème : Facteurs aggravants'),
  ('MG-ANES-000022-R23', 'Il faut favoriser la réhabilitation postopératoire précoce de façon à limiter l''insulinorésistance postopératoire.', 'Fort', 'Modéré', null, 'Champ 7 — Le contrôle glycémique en périopératoire — Thème : Réhabilitation précoce'),
  ('MG-ANES-000022-R24', 'Le jeûne glucidique préopératoire de plus de 12 heures aggrave l''insulinorésistance périopératoire. Il faut le limiter, quand cela est possible, en autorisant les liquides clairs jusqu''à deux à trois heures préopératoires.', 'Fort', 'Modéré', null, 'Champ 7 — Le contrôle glycémique en périopératoire — Thème : Jeûne glucidique'),
  ('MG-ANES-000022-R25', 'En dehors des patients à estomac plein (occlusion, grossesse, diabète, etc.), l''apport d''hydrates de carbone en préopératoire (100 g la veille et 50 g trois heures avant l''intervention) peut être recommandé afin de limiter l''insulinorésistance périopératoire.', 'Fort', 'Modéré', null, 'Champ 7 — Le contrôle glycémique en périopératoire — Thème : Apport HC préopératoire'),
  ('MG-ANES-000022-R26', 'En dehors des patients diabétiques et des nourrissons, il ne faut probablement pas administrer d''hydrates de carbone en peropératoire.', 'Faible', 'Faible', null, 'Champ 7 — Le contrôle glycémique en périopératoire — Thème : HC peropératoire'),
  ('MG-ANES-000022-R27', 'Au cours de la chirurgie à risque (cardiovasculaire, obèse, âgé, chirurgie de longue durée ou urgente), il faut probablement éviter l''hyperglycémie supérieure à 10 mmol/l (1,8 g/l).', 'Fort', 'Faible', null, 'Champ 7 — Le contrôle glycémique en périopératoire — Thème : Chirurgie à risque'),
  ('MG-ANES-000022-R28', 'L''insulinothérapie peropératoire doit être intraveineuse continue et impose un contrôle glycémique toutes les 30 minutes.', 'Faible', 'Fort', null, 'Champ 7 — Le contrôle glycémique en périopératoire — Thème : Voie IV peropératoire'),
  ('MG-ANES-000022-R29', 'Il faut adapter les valeurs cibles de glycémie périopératoire aux ressources disponibles et à l''expérience de l''unité en charge du patient, en privilégiant des niveaux d''exigences croissants.', 'Faible', 'Fort', null, 'Champ 7 — Le contrôle glycémique en périopératoire — Thème : Cibles adaptées'),
  ('MG-ANES-000022-R30', 'Il faut probablement mesurer la glycémie peropératoire au cours des interventions à risque.', 'Fort', 'Faible', null, 'Champ 7 — Le contrôle glycémique en périopératoire — Thème : Mesure peropératoire'),
  ('MG-ANES-000022-R31', 'Chez les patients à risque, il faut réaliser une mesure de glycémie durant le séjour en salle de surveillance post-interventionnelle (SSPI).', null, null, null, 'Champ 7 — Le contrôle glycémique en périopératoire — Thème : Mesure en SSPI [anomalie source : aucune cotation NGP/Accord imprimée, cf. disclosure]'),
  ('MG-ANES-000022-R32', 'L''insuline intraveineuse à la seringue électrique doit probablement être interrompue lorsque le patient a repris une alimentation orale et la surveillance glycémique doit être poursuivie par au moins trois contrôles préprandiaux.', 'Modéré', 'Faible', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.1. Les apports glucidiques — Thème : Arrêt insuline IV / relais'),
  ('MG-ANES-000022-R33', 'Durant la phase aiguë, la quantité maximale de glucose intraveineux ne doit pas dépasser 100 g/24 h ; la quantité totale d''hydrates de carbone (entérale et parentérale) ne doit pas dépasser 200 g/24 h.', 'Fort', 'Faible', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.1. Les apports glucidiques — Thème : Apports maximaux'),
  ('MG-ANES-000022-R34', 'Durant la phase aiguë, chez tous les patients et y compris chez le cérébrolésé, il ne faut probablement pas proscrire l''apport de glucose à condition de contrôler la glycémie.', 'Indécision', 'Faible', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.1. Les apports glucidiques — Thème : Glucose chez le cérébrolésé'),
  ('MG-ANES-000022-R35', 'Il est possible que l''adaptation combinée du débit d''infusion de la nutrition entérale et du débit de perfusion d''insuline puisse améliorer l''observance de la cible glycémique.', 'Faible', 'Faible', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.1. Les apports glucidiques — Thème : Adaptation nutrition/insuline'),
  ('MG-ANES-000022-R36', 'Il faut considérer que la glycémie mesurée au laboratoire est actuellement la valeur de référence.', 'Fort', 'Fort', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.2. Les modalités de surveillance — Thème : Référence laboratoire'),
  ('MG-ANES-000022-R37', 'Il faut probablement privilégier dans l''ordre, le prélèvement artériel, puis veineux, puis capillaire.', 'Fort', 'Fort', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.2. Les modalités de surveillance — Thème : Ordre des prélèvements'),
  ('MG-ANES-000022-R38', 'Du fait des différences de valeur entre sang total et plasma, il faut connaître les caractéristiques précises du lecteur de glycémie que l''on utilise (seuls certains appliquent directement le facteur de correction).', 'Fort', 'Fort', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.2. Les modalités de surveillance — Thème : Sang total vs plasma'),
  ('MG-ANES-000022-R39', 'Du fait de nombreuses interférences physicochimiques endogènes et exogènes, il faut connaître les caractéristiques précises du lecteur de glycémie et des bandelettes que l''on utilise.', 'Fort', 'Fort', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.2. Les modalités de surveillance — Thème : Interférences physicochimiques'),
  ('MG-ANES-000022-R40', 'Au sein d''une équipe, il faut choisir le même protocole formalisé de contrôle glycémique.', 'Fort', 'Fort', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.3. Algorithmes et protocoles — Thème : Protocole unique d''équipe'),
  ('MG-ANES-000022-R41', 'Tout protocole de contrôle glycémique strict doit inclure au minimum des recommandations relatives à l''utilisation d''une insuline d''action rapide en perfusion continue à la seringue électrique.', 'Fort', 'Fort', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.3. Algorithmes et protocoles — Thème : Insuline rapide obligatoire'),
  ('MG-ANES-000022-R42', 'Tout protocole de contrôle glycémique strict doit inclure au minimum des procédures de correction et de surveillance des épisodes d''hypoglycémie.', 'Fort', 'Fort', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.3. Algorithmes et protocoles — Thème : Procédures anti-hypoglycémie'),
  ('MG-ANES-000022-R43', 'Il faut probablement privilégier l''utilisation d''une voie permettant d''assurer un débit constant pour administrer l''insuline intraveineuse en continu.', 'Fort', 'Modéré', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.3. Algorithmes et protocoles — Thème : Voie à débit constant'),
  ('MG-ANES-000022-R44', 'Parmi les différents protocoles de contrôle glycémique strict existants, il est impossible d''en privilégier un par rapport aux autres.', 'Faible', 'Fort', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.3. Algorithmes et protocoles — Thème : Pas de protocole supérieur'),
  ('MG-ANES-000022-R45', 'Il faut abandonner les protocoles de contrôle glycémique statiques qui déterminent le débit d''insuline uniquement à partir de la glycémie la plus récente.', 'Fort', 'Modéré', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.3. Algorithmes et protocoles — Thème : Abandon des protocoles statiques'),
  ('MG-ANES-000022-R46', 'Tout protocole de contrôle glycémique devrait prendre en compte les apports d''hydrate de carbone pour la détermination du débit d''insuline.', 'Fort', 'Modéré', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.3. Algorithmes et protocoles — Thème : Prise en compte des apports HC'),
  ('MG-ANES-000022-R47', 'Un protocole de contrôle glycémique strict basé sur plus de deux paramètres d''entrée et de sortie devrait être géré par un logiciel informatique.', 'Faible', 'Modéré', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.3. Algorithmes et protocoles — Thème : Protocole informatisé'),
  ('MG-ANES-000022-R48', 'L''augmentation de charge de travail paramédical doit être prise en compte lors de la mise en œuvre d''un protocole de contrôle glycémique strict.', 'Fort', 'Fort', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.3. Algorithmes et protocoles — Thème : Charge de travail paramédical'),
  ('MG-ANES-000022-R49', 'Il faut prévoir un temps de formation du personnel soignant pour mettre en route un protocole de contrôle glycémique.', 'Fort', 'Fort', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.3. Algorithmes et protocoles — Thème : Formation du personnel'),
  ('MG-ANES-000022-R50', 'L''efficacité d''un protocole de contrôle glycémique strict doit reposer sur l''ensemble des critères suivants : temps de formation, performance du contrôle, risque d''hypoglycémie sévère, taux moyen d''erreur, charge en soins infirmiers.', 'Faible', 'Modéré', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.3. Algorithmes et protocoles — Thème : Critères d''efficacité'),
  ('MG-ANES-000022-R51', 'Il est souhaitable d''évaluer l''efficacité d''un protocole de contrôle glycémique strict par les principaux paramètres suivants : pourcentage de temps passé dans la cible glycémique et au dessus de cette cible, index d''hyperglycémie, variabilité de la glycémie.', 'Faible', 'Faible', null, 'Champ 8 — Réalisation pratique du contrôle glycémique — 6.3. Algorithmes et protocoles — Thème : Paramètres d''évaluation'),
  ('MG-ANES-000022-R52', 'La glycémie doit être surveillée régulièrement chez tout patient diabétique admis en réanimation.', 'Fort', 'Fort', null, 'Champ 9 — Les spécificités du patient diabétique — Thème : Surveillance systématique'),
  ('MG-ANES-000022-R53', 'Chez le patient diabétique admis en réanimation, l''impact d''un contrôle strict de la glycémie (4,4-6,1 mmol/l ou 0,8-1,1 g/l) sur la morbimortalité n''est pas démontré.', 'Fort', 'Modéré', null, 'Champ 9 — Les spécificités du patient diabétique — Thème : Impact du contrôle strict'),
  ('MG-ANES-000022-R54', 'Il est indispensable de proposer un traitement de l''hyperglycémie pour tout patient diabétique admis en réanimation dont la glycémie est supérieure à 10 mmol/l (1,8 g/l). Entre 8,3 et 10 mmol/l (1,5 et 1,8 g/l), un tel traitement apparaît souhaitable bien que le bénéfice ne soit pas totalement établi.', 'Fort', 'Modéré', null, 'Champ 9 — Les spécificités du patient diabétique — Thème : Seuil de traitement'),
  ('MG-ANES-000022-R55', 'L''objectif de traitement de l''hyperglycémie des patients diabétiques admis en réanimation n''est pas formellement défini. Néanmoins, des valeurs de glycémie inférieures à 6,1 mmol/l (1,1 g/l) et supérieures ou égales à 8,3 mmol/l (1,5 g/l) semblent délétères et doivent être évitées.', 'Faible', 'Faible', null, 'Champ 9 — Les spécificités du patient diabétique — Thème : Objectif non défini'),
  ('MG-ANES-000022-R56', 'En peropératoire, il faut probablement maintenir un niveau glycémique inférieur à 8,3 mmol/l (1,5 g/l) chez les patients diabétiques. En postopératoire, il semble souhaitable de maintenir cet objectif de traitement pendant trois jours (en l''absence de complications).', 'Faible', 'Modéré', null, 'Champ 9 — Les spécificités du patient diabétique — Thème : Cible péri-opératoire'),
  ('MG-ANES-000022-R57', 'Chez le patient diabétique, il faut choisir l''insuline en perfusion intraveineuse continue pour contrôler la glycémie en cas de déséquilibre préopératoire, ainsi qu''en périopératoire d''une chirurgie majeure ou réalisée en urgence, ou en cas d''admission postopératoire en réanimation. Il ne faut probablement pas modifier l''insulinothérapie périopératoire du patient diabétique bien équilibré bénéficiant d''une chirurgie mineure sous réserve de la mise en place d''une perfusion de sérum glucosé pendant et après l''intervention avec surveillance glycémique rapprochée.', 'Fort', 'Fort', null, 'Champ 9 — Les spécificités du patient diabétique — Thème : Insuline IV selon contexte'),
  ('MG-ANES-000022-R58', 'Pour les patients diabétiques traités antérieurement par des antidiabétiques oraux, la reprise orale du traitement doit être réévaluée après la phase aiguë de réanimation, en respectant les contre-indications de ces médicaments.', 'Fort', 'Fort', null, 'Champ 9 — Les spécificités du patient diabétique — Thème : Reprise des antidiabétiques oraux'),
  ('MG-ANES-000022-R59', 'Pour les patients diabétiques traités antérieurement par insuline, il est impératif de ne jamais interrompre ce traitement sauf si l''arrêt est transitoire et justifié par une hypoglycémie.', 'Faible', 'Fort', null, 'Champ 9 — Les spécificités du patient diabétique — Thème : Insuline antérieure jamais interrompue'),
  ('MG-ANES-000022-R60', 'Les patients admis en réanimation avec une hyperglycémie persistante, mais sans notion de diabète, devraient bénéficier d''une évaluation métabolique ultérieure et si possible avant la sortie de l''hôpital. Cette évaluation pourrait inclure une glycémie à jeun et une mesure de l''hémoglobine A1c. Une hyperglycémie provoquée par voie orale peut être utile dans certains cas.', 'Faible', 'Modéré', null, 'Champ 9 — Les spécificités du patient diabétique — Thème : Dépistage post-hyperglycémie'),
  ('MG-ANES-000022-R61', 'À la sortie de la réanimation et avant la sortie de l''hôpital, une prise en charge optimale du contrôle glycémique doit probablement être proposée pour les patients diabétiques, nouveaux diagnostiqués ou insulinorésistants.', 'Faible', 'Faible', null, 'Champ 9 — Les spécificités du patient diabétique — Thème : Sortie de réanimation'),
  ('MG-ANES-000022-R62', 'Le risque d''hypoglycémie est d''autant plus important que l''enfant est jeune et que la période de jeûne se prolonge.', 'Fort', 'Fort', null, 'Champ 10 — Les spécificités en pédiatrie — Thème : Risque accru — jeune enfant'),
  ('MG-ANES-000022-R63', 'Il faut rechercher les signes d''alerte d''hypoglycémie, difficiles à détecter chez le jeune enfant incapable d''exprimer une sensation de malaise.', 'Faible', 'Fort', 'Pédiatrie / nouveau-né', 'Champ 10 — Les spécificités en pédiatrie — Thème : Signes d''alerte'),
  ('MG-ANES-000022-R64', 'La survenue d''hypoglycémies sévères et récidivantes chez le jeune enfant peut altérer définitivement le développement cérébral et psychomoteur.', 'Fort', 'Modéré', 'Pédiatrie / nouveau-né', 'Champ 10 — Les spécificités en pédiatrie — Thème : Développement cérébral'),
  ('MG-ANES-000022-R65', 'Le traitement des hypoglycémies en réanimation ou en période périopératoire repose sur l''administration intraveineuse d''un bolus de 2 à 5 mg/kg de soluté glucosé à 10 % (0,2 à 0,5 g/kg), renouvelable selon le contrôle effectué 30 minutes plus tard.', 'Faible', 'Faible', null, 'Champ 10 — Les spécificités en pédiatrie — Thème : Traitement — bolus IV'),
  ('MG-ANES-000022-R66', 'Les besoins de base en glucose sont deux à trois fois plus importants chez le nourrisson (5-8 mg/kg par minute) que chez l''adulte.', 'Fort', 'Fort', 'Pédiatrie / nouveau-né', 'Champ 10 — Les spécificités en pédiatrie — Thème : Besoins de base'),
  ('MG-ANES-000022-R67', 'Il faut réaliser une mesure de la glycémie dès l''admission et au moins une fois par jour pendant la phase aiguë en réanimation chez l''enfant, même en l''absence d''insulinothérapie.', 'Fort', 'Fort', 'Pédiatrie / nouveau-né', 'Champ 10 — Les spécificités en pédiatrie — Thème : Mesure systématique'),
  ('MG-ANES-000022-R68', 'Chez l''enfant, une alimentation parentérale ne doit pas être brutalement interrompue.', 'Faible', 'Faible', 'Pédiatrie / nouveau-né', 'Champ 10 — Les spécificités en pédiatrie — Thème : Alimentation parentérale'),
  ('MG-ANES-000022-R69', 'Il n''est pas possible actuellement de recommander en pédiatrie une stratégie de contrôle glycémique strict par insulinothérapie en réanimation ou en période périopératoire.', 'Fort', 'Modéré', 'Pédiatrie / nouveau-né', 'Champ 10 — Les spécificités en pédiatrie — Thème : Pas de contrôle strict'),
  ('MG-ANES-000022-R70', 'Chez le nourrisson, en cas de jeûne prolongé (plus de quatre heures) ou de chirurgie longue (plus d''une heure), une mesure de la glycémie peropératoire doit être faite.', 'Fort', 'Faible', 'Pédiatrie / nouveau-né', 'Champ 10 — Les spécificités en pédiatrie — Thème : Mesure chez le nourrisson'),
  ('MG-ANES-000022-R71', 'Les apports hydroélectrolytiques du nourrisson au cours d''une chirurgie longue doivent être basés sur la perfusion de solutions contenant du NaCl (0,7-0,8 %) et du glucose (1-2,5 %).', 'Faible', 'Modéré', null, 'Champ 10 — Les spécificités en pédiatrie — Thème : Apports hydroélectrolytiques'),
  ('MG-ANES-000022-R72', 'Il ne faut jamais prescrire de solutions glucosés sans ions chez le nourrisson et l''enfant, quel que soit l''âge, en raison du risque d''encéphalopathie hyponatrémique potentiellement létal.', 'Fort', 'Fort', 'Pédiatrie / nouveau-né', 'Champ 10 — Les spécificités en pédiatrie — Thème : Solutions avec ions'),
  ('MG-ANES-000022-R73', 'En situation aiguë, les posologies d''insuline à action rapide en perfusion intraveineuse varient de 0,02 à 0,15 UI/kg par heure. Il n''est actuellement pas possible de recommander un modèle de protocole et de seuil glycémique cible en pédiatrie.', 'Fort', 'Faible', 'Pédiatrie / nouveau-né', 'Champ 10 — Les spécificités en pédiatrie — Thème : Posologie / absence de modèle'),
  ('MG-ANES-000022-R74', 'L''acidocétose diabétique doit être prise en charge en tenant compte d''un risque particulièrement important de survenue d''œdème cérébral.', 'Faible', 'Modéré', null, 'Champ 10 — Les spécificités en pédiatrie — Thème : Acidocétose diabétique')
) as v(code, statement, grade, evidence_level, population, source_section)
where d.source_url = 'https://sfar.org/controle-de-la-glycemie-en-reanimation-et-en-anesthesie/'
on conflict (recommendation_code) do nothing;
