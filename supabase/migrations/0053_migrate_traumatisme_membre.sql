-- Migration : Prise en charge des patients présentant un traumatisme
-- sévère de membre(s) (TSM) — Recommandations Formalisées d'Experts
-- communes SFAR-SFMU, en association avec la SOFCOT, la SCVE et le SSA.
-- Comité de 21 experts, coordination J. Pottecher (SFAR), H. Lefort
-- (SFMU). Texte validé par le Comité des Référentiels Cliniques le
-- 16/06/2020, le CA SFAR le 25/08/2020, le CA SFMU le 15/09/2020. Source :
-- rfe-sfar-website/build/content_traumatisme_membre.json (19
-- recommandations réparties en 11 questions). Les traumatismes pelviens
-- (RFE dédiée) sont explicitement exclus du champ.
--
-- MÉTHODOLOGIE : GRADE®. `grade` reproduit tel quel le chip source.
-- `evidence_level` laissé NULL.
--
-- COMPTAGE — EXACTEMENT RECONCILIÉ (cas propre, aucun mismatch) : le
-- résumé officiel annonce "19 recommandations : 4 GRADE1 (1+/1-), 12
-- GRADE2 (2+/2-), 3 AE". Inventaire direct : R1, R2.1-R2.2, R3, R4.1-R4.2,
-- R5.1-R5.2, R6.1-R6.2, R7.1-R7.2, R8, R9.1-R9.2, R10.1-R10.3, R11 = 19,
-- avec 4×GRADE1 (R1:1+, R4.1:1+, R7.1:1+, R7.2:1-), 12×GRADE2 (R2.1, R3,
-- R4.2, R5.1, R5.2, R6.1, R9.1, R9.2, R10.1, R10.2 tous 2+, R6.2 et R10.3
-- 2-), 3×AE (R2.2, R8, R11) — exactement reconcilié sur les deux axes.
--
-- PÉRIMÈTRE — volontairement pas migrés (référence diagnostique/
-- classificatoire ou algorithme global, jamais un chip individuel) :
-- Figure 1 (critères de Vittel) et Figure 2 (classification de Gustilo des
-- fractures ouvertes) — outils de référence ; Tableau 1 (gradation du
-- risque de complications secondaires, associé à R4.1/R4.2) — grille
-- d'aide à la décision, pas une recommandation graduée en soi ; Figure 3
-- (algorithme d'orientation, transcrit en tableau) et Figure 4 (checklist
-- de prévention infectieuse associée à R6.1, transcrite depuis une
-- affiche-image) — synthèses opérationnelles du contenu déjà gradué, sans
-- chip individuel par étape. L'Annexe 1 (codes techniques AIS détaillés,
-- plusieurs centaines d'entrées) n'est pas reproduite par le contenu
-- construit lui-même (disclosure de la source : "se référer au texte
-- intégral pour le codage AIS détaillé") — rien à migrer au-delà du seuil
-- déjà cité en introduction (AIS ≥ 3).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFAR et SFMU (toutes deux dans le seed Annexe B) liées en
--    document_societies ; SOFCOT, SCVE et SSA (co-auteurs) hors seed, non
--    liées.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge des patients présentant un traumatisme sévère de membre(s)',
  'RFE', 'fr', '2019-09-21',
  'https://sfar.org/prise-en-charge-des-patients-presentant-un-traumatisme-severe-de-membres/',
  'https://sfar.org/download/prise-en-charge-des-patients-presentant-un-traumatisme-severe-de-membres/?wpdmdl=30307',
  'GRADE® : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ probablement recommandé / 2- probablement non recommandé) ; avis d''experts (AE). Comptage source ("19 recommandations : 4 GRADE1, 12 GRADE2, 3 AE") exactement reconcilié, aucun écart.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-des-patients-presentant-un-traumatisme-severe-de-membres/'
  and s.acronym in ('SFAR', 'SFMU') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-des-patients-presentant-un-traumatisme-severe-de-membres/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'medecine_d_urgence', 'chirurgie_orthopedique_et_traumatologique', 'chirurgie_vasculaire')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/prise-en-charge-des-patients-presentant-un-traumatisme-severe-de-membres/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000053-R01', 'Chez les patients victimes de traumatisme sévère de membre(s), il est recommandé d''admettre en centre spécialisé de traumatologie grave les patients ayant au moins un critère de Vittel en préhospitalier.', '1+', 'Question 1 — Orientation vers un centre spécialisé (Réf. R1)'),
  ('MG-ANES-000053-R02', 'En cas d''hémorragie active de membre et d''inefficacité de la compression directe, d''amputation, de corps étranger au sein de la plaie hémorragique, d''absence de pouls radial (critère hémodynamique) ou de multiples actions simultanées à mener, il est probablement recommandé de mettre en place un garrot.', '2+', 'Question 2 — Réduire le saignement en préhospitalier (Réf. R2.1)'),
  ('MG-ANES-000053-R03', 'En cas de pose d''un garrot, les experts suggèrent de réévaluer, dès que possible, son efficacité, son utilité et sa localisation sur le membre, y compris lors de la phase pré-hospitalière, afin de limiter sa morbidité (temps de pose le plus court et zone d''ischémie la plus limitée possible).', 'AE', 'Question 2 — Réduire le saignement en préhospitalier (Réf. R2.2)'),
  ('MG-ANES-000053-R04', 'Pour ne pas méconnaître une lésion vasculaire chez un traumatisé grave de membre(s), il est probablement recommandé de réaliser en première intention un angioscanner en cas de présence d''un ou plusieurs des éléments suivants : notion de saignement extériorisé d''origine artérielle ; proximité du traumatisme avec un axe vasculaire principal ; présence d''un hématome non expansif ; déficit neurologique isolé ; Indice de pression systolique (IPS) cheville-bras < 0,9.', '2+', 'Question 3 — Dépister une lésion vasculaire (Réf. R3)'),
  ('MG-ANES-000053-R05', 'En l''absence d''autre lésion traumatique sévère (cérébrale, thoraco-abdomino-pelvienne ou médullaire), d''état de choc hémorragique, d''instabilité circulatoire ou respiratoire, il est recommandé de réaliser l''ostéosynthèse définitive et sûre du (des) foyer(s) de fracture des os longs dans les 24 premières heures afin de réduire l''incidence de complications locales ou systémiques associées, particulièrement pour les fractures diaphysaires fémorales et tibiales à haut risque de complications respiratoires (SDRA, embolie graisseuse).', '1+', 'Question 4 — Moment et modalités de l''ostéosynthèse (Réf. R4.1)'),
  ('MG-ANES-000053-R06', 'En présence d''une ou plusieurs lésions traumatiques sévères (cérébrale, thoraco-abdomino-pelvienne ou médullaire) ou d''un état de choc hémorragique, d''une instabilité circulatoire ou d''une atteinte respiratoire sévère, il est probablement recommandé de retarder l''ostéosynthèse définitive au profit d''une stabilisation temporaire (fixateur externe ou traction selon les délais envisagés) pour réduire la survenue de complications systémiques induites par l''agression chirurgicale, les pertes sanguines péri-opératoires, la coagulopathie, ainsi que le risque d''embolie graisseuse. L''ostéosynthèse définitive et sûre devra être réalisée le plus précocement possible par la suite.', '2+', 'Question 4 — Moment et modalités de l''ostéosynthèse (Réf. R4.2)'),
  ('MG-ANES-000053-R07', 'En cas de stabilité hémodynamique, il est probablement recommandé de procéder à un sauvetage du membre.', '2+', 'Question 5 — Sauvetage de membre ou amputation (Réf. R5.1)'),
  ('MG-ANES-000053-R08', 'En cas de choc hémorragique associé à un traumatisme grave de membre(s), il est probablement recommandé d''appliquer une stratégie de damage control. Aucun critère de gravité considéré isolément n''impose le recours à une amputation.', '2+', 'Question 5 — Sauvetage de membre ou amputation (Réf. R5.2)'),
  ('MG-ANES-000053-R09', 'Il est probablement recommandé d''administrer une antibioprophylaxie en cas de traumatisme sévère avec fracture ouverte de membres le plus rapidement possible et pour une durée maximale de 48 à 72 heures (à l''exception d''une infection avérée).', '2+', 'Question 6 — Prévention du risque septique (Réf. R6.1)'),
  ('MG-ANES-000053-R10', 'Il ne faut probablement pas réaliser de prélèvements microbiologiques systématiques au bloc opératoire lors d''un traumatisme sévère avec fracture ouverte de membres.', '2-', 'Question 6 — Prévention du risque septique (Réf. R6.2)'),
  ('MG-ANES-000053-R11', 'Chez les patients victimes de traumatisme sévère de membre(s) inférieur(s), il est recommandé d''instaurer une thromboprophylaxie médicamenteuse précoce par héparine de bas poids moléculaire (HBPM), après contrôle de l''hémorragie et de l''hémostase, dont le délai d''instauration sera modulé par le bilan lésionnel.', '1+', 'Question 7 — Prévention de la maladie thromboembolique veineuse (Réf. R7.1)'),
  ('MG-ANES-000053-R12', 'Il n''est pas recommandé de mettre en place un filtre cave chez des patients à risque thrombo-embolique majeur en dehors d''une contre-indication au traitement pharmacologique et mécanique (par compression veineuse intermittente).', '1-', 'Question 7 — Prévention de la maladie thromboembolique veineuse (Réf. R7.2)'),
  ('MG-ANES-000053-R13', 'Chez le patient traumatisé sévère de membre(s), les experts suggèrent d''effectuer une fasciotomie précoce en cas de syndrome de loge récemment constitué pour réduire l''incidence des répercussions fonctionnelles.', 'AE', 'Question 8 — Syndrome des loges (Réf. R8)'),
  ('MG-ANES-000053-R14', 'Pour détecter le risque de survenue d''une insuffisance rénale aiguë chez le patient atteint de rhabdomyolyse aiguë post-traumatique après traumatisme de membre(s), il est probablement recommandé de réaliser : un bilan biologique répété associant un dosage plasmatique de la myoglobine, de la créatine phosphokinase (CPK) et de la kaliémie ; un sondage urinaire permettant de monitorer la diurèse horaire et le pH urinaire (objectif ≥ 6,5).', '2+', 'Question 9 — Rhabdomyolyse aiguë post-traumatique (Réf. R9.1)'),
  ('MG-ANES-000053-R15', 'Concernant les mesures de prévention de l''insuffisance rénale aiguë chez le patient atteint de rhabdomyolyse aiguë post-traumatique après traumatisme de membre, les préconisations sont celles des recommandations formalisées d''experts SFAR-SRLF de 2016 « insuffisance rénale aiguë en péri-opératoire et en réanimation ».', '2+', 'Question 9 — Rhabdomyolyse aiguë post-traumatique (Réf. R9.2)'),
  ('MG-ANES-000053-R16', 'Il est probablement recommandé de réaliser un traitement chirurgical d''une fracture de la diaphyse des os longs dans les 24 premières heures post-traumatiques pour limiter les complications respiratoires à type de SDRA ou d''embolie graisseuse.', '2+', 'Question 10 — Embolie graisseuse et atteintes inflammatoires systémiques (Réf. R10.1)'),
  ('MG-ANES-000053-R17', 'Il est probablement recommandé de réaliser en première intention une ostéosynthèse définitive des fractures diaphysaires d''os longs pour prévenir le risque de SDRA et d''embolie graisseuse. Chez les patients hémodynamiquement instables ou présentant une atteinte respiratoire sévère en préopératoire, la balance bénéfice-risque entre une ostéosynthèse définitive ou la pose d''un fixateur externe doit faire l''objet d''une discussion multidisciplinaire.', '2+', 'Question 10 — Embolie graisseuse et atteintes inflammatoires systémiques (Réf. R10.2)'),
  ('MG-ANES-000053-R18', 'Il est probablement recommandé de ne pas administrer de corticoïdes pour prévenir l''embolie graisseuse en cas de fracture diaphysaire des os longs.', '2-', 'Question 10 — Embolie graisseuse et atteintes inflammatoires systémiques (Réf. R10.3)'),
  ('MG-ANES-000053-R19', 'Les experts suggèrent qu''en cas de traumatisme sévère de membre(s) l''utilisation d''une stratégie d''analgésie multimodale soit favorisée et que le rapport bénéfice/risque des molécules choisies soit évalué à l''aune de la volémie et de l''atteinte musculaire.', 'AE', 'Question 11 — Contrôle de la douleur aiguë (Réf. R11)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-des-patients-presentant-un-traumatisme-severe-de-membres/'
on conflict (recommendation_code) do nothing;
