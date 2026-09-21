-- Migration : Ventilation Non Invasive au cours de l'insuffisance
-- respiratoire aiguë (nouveau-né exclu) — 3e Conférence de Consensus
-- commune SFAR-SPLF-SRLF, avec la participation de la SFMU, du SAMU de
-- France, du GFRUP et de l'ADARPEF. Paris, Institut Montsouris, 12 octobre
-- 2006. Président du jury : R. Robert (Poitiers). Source :
-- rfe-sfar-website/build/content_vni.json (4 questions, 4 tableaux).
--
-- MÉTHODOLOGIE : GRADE, grades (G1+/G1-/G2+/G2-) imprimés directement dans
-- le texte source après chaque recommandation — contrairement aux
-- conférences de sédation-analgésie 2007/2010 de ce même corpus
-- (`sedation_reanimation`/0042) où la polarité devait être déduite de la
-- formulation, ici aucune déduction n'est nécessaire. `grade` reproduit
-- tel quel le chip source. `evidence_level` laissé NULL. Certaines
-- situations sont explicitement présentées par la source comme « sans
-- cotation possible » (preuve insuffisante même pour un avis d'experts) —
-- non migrées (même traitement que les catégories officielles "pas de
-- recommandation possible" d'autres fiches du corpus, ex. `sepsis`/0044).
--
-- STRUCTURE PARTICULIÈRE — « Tableau 2 » (niveaux de recommandation par
-- indication), DISCLOSURE DÉTAILLÉE : ce tableau groupe plusieurs
-- indications sous un même niveau de grade (une ligne = 1 grade partagé
-- par plusieurs indications listées à puces), à la différence des
-- tableaux "Thème | Recommandation | Grade" habituels de ce document
-- (une ligne = 1 recommandation + 1 grade). La plupart des indications de
-- ce Tableau 2 sont détaillées séparément, avec un grade concordant, dans
-- les tableaux "Thème | Recommandation | Grade" qui suivent (migrées
-- depuis CES tableaux détaillés, pas depuis le Tableau 2, pour éviter la
-- redondance). MAIS 5 indications du Tableau 2 n'ont AUCUNE ligne détaillée
-- correspondante ailleurs dans le document (vérifié par lecture
-- exhaustive) : les 4 indications cotées G2- (pneumopathie hypoxémiante,
-- SDRA, traitement de l'IRA post-extubation, maladies neuromusculaires
-- aiguës réversibles — la section "Pneumopathies hypoxémiantes" qui suit
-- ne porte qu'un panneau d'avertissement SANS chip de grade individuel)
-- et 1 indication cotée G2+ (traumatisme thoracique fermé isolé — la note
-- correspondante ailleurs dans le document porte sur le CHOIX DU MODE
-- ventilatoire, explicitement non gradé, pas sur l'indication elle-même).
-- Ces 5 indications sont donc migrées directement depuis le Tableau 2, en
-- reformulant chaque indication en énoncé déclaratif complet à partir du
-- libellé du niveau de grade correspondant (ex. "Aucun avantage démontré
-- — il ne faut probablement pas faire" -> "il ne faut probablement pas
-- utiliser la VNI en première intention dans...") — disclosure : reprise
-- fidèle de contenu déjà présent (grade + indication), reformulation
-- grammaticale minimale pour cohérence de style, aucun contenu ajouté.
--
-- COMPTAGE : la source ne publie PAS de total agrégé officiel de
-- recommandations à comparer (contrairement à la majorité du corpus) — 26
-- lignes comptées directement (tableaux "Thème | Recommandation | Grade"
-- + les 5 items propres au Tableau 2 identifiés ci-dessus), répartition
-- vérifiée 4×1+/17×2+/5×2-=26.
--
-- PÉRIMÈTRE — volontairement pas migrés : Tableau 1 (contre-indications
-- absolues, liste sans grade individuel par item) ; le reste du Tableau 2
-- déjà couvert par les tableaux détaillés (voir disclosure ci-dessus) ;
-- les 3 « situations sans cotation possible » (asthme aigu grave, syndrome
-- d'obésité-hypoventilation, bronchiolite aiguë du nourrisson hors forme
-- apnéisante) — la source elle-même déclare l'absence de cotation
-- possible ; Tableau 3 (effets indésirables/mesures préventives, référence
-- clinique sans grade) ; Tableau 4 (critères de risque d'échec, référence
-- clinique sans grade) ; le paragraphe "Critères de poursuite et d'arrêt
-- de la VNI" (prose descriptive, aucun chip de grade associé).
--
-- POPULATION : source signale ses particularités pédiatriques par la
-- notation littérale « [pédiatrie] » (disclosure de méthode faite par le
-- contenu construit lui-même) — appliquée à `population='Pédiatrie'`
-- uniquement sur R19 (Réf. "Autres indications [pédiatrie]", seule ligne
-- graduée entièrement dédiée à la pédiatrie) ; les autres mentions
-- ponctuelles de la pédiatrie (interfaces, humidification) figurent en
-- note libre ou intégrées au texte d'une recommandation à portée
-- générale, non isolées en ligne dédiée.
--
-- DISCLOSURE D'OBSOLESCENCE EXPLICITE PAR LA SOURCE ELLE-MÊME : « Document
-- ancien (2006) — les pratiques de VNI ont évolué depuis (interfaces,
-- oxygénothérapie à haut débit) » — `freshness_status = 'revision_detectee'`
-- malgré `library_final.json` "en vigueur" (même pattern que eclsa/0019,
-- glycemie/0022, hsa/0023, mal_epileptique/0032).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFAR, SRLF ET SFMU (dans le seed Annexe B) liées en
--    document_societies ; SPLF (co-organisatrice à égalité avec SFAR/SRLF
--    dans le titre de la conférence "commune SFAR-SPLF-SRLF"), ainsi que
--    le SAMU de France, le GFRUP et l'ADARPEF (participants), hors seed,
--    non liés.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Ventilation Non Invasive au cours de l''insuffisance respiratoire aiguë (nouveau-né exclu)',
  'CC', 'fr', '2006-10-12',
  'https://sfar.org/ventilation-non-invasive%E2%80%A8au-cours-de-linsuffisance-respiratoire-aigue-nouveau-ne-exclu/',
  'https://sfar.org/wp-content/uploads/2015/10/2a_SFAR_texte-court_Ventilation-Non-Invasive-au-cours-del-insuffisance-respiratoire-aigue.pdf',
  'GRADE : grades (1+/1-/2+/2-) imprimés directement dans le texte source après chaque recommandation, aucune déduction nécessaire. 26 recommandations comptées directement (4×1+, 17×2+, 5×2-) ; pas de total agrégé officiel publié par la source à comparer. Document de 2006 : la source avertit elle-même que les pratiques de VNI ont évolué depuis (interfaces, oxygénothérapie à haut débit).',
  'revision_detectee'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/ventilation-non-invasive%E2%80%A8au-cours-de-linsuffisance-respiratoire-aigue-nouveau-ne-exclu/'
  and s.acronym in ('SFAR', 'SRLF', 'SFMU') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/ventilation-non-invasive%E2%80%A8au-cours-de-linsuffisance-respiratoire-aigue-nouveau-ne-exclu/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'medecine_d_urgence', 'pneumologie', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status, population)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/ventilation-non-invasive%E2%80%A8au-cours-de-linsuffisance-respiratoire-aigue-nouveau-ne-exclu/',
  'draft', v.population
from public.documents d, (values
  ('MG-ANES-000058-R01', 'La fibroscopie bronchique chez les patients hypoxémiques peut être réalisée sous VNI.', '2+', 'Q1 — Autres usages (Thème : Autres usages)', null),
  ('MG-ANES-000058-R02', 'La VNI peut être utilisée en pré-oxygénation avant intubation pour insuffisance respiratoire aiguë.', '2+', 'Q1 — Autres usages (Thème : Autres usages)', null),
  ('MG-ANES-000058-R03', 'La VNI peut être réalisée chez des patients pour lesquels la ventilation invasive n''est pas envisagée (refus du patient ou mauvais pronostic).', '2+', 'Q1 — Limitations thérapeutiques (Thème : Limitations thérapeutiques)', null),
  ('MG-ANES-000058-R04', 'Il ne faut probablement pas utiliser la VNI en première intention dans la pneumopathie hypoxémiante, aucun avantage n''étant démontré.', '2-', 'Q1 — Tableau 2, niveaux de recommandation par indication (catégorie « Aucun avantage démontré »)', null),
  ('MG-ANES-000058-R05', 'Il ne faut probablement pas utiliser la VNI en première intention dans le SDRA, aucun avantage n''étant démontré.', '2-', 'Q1 — Tableau 2, niveaux de recommandation par indication (catégorie « Aucun avantage démontré »)', null),
  ('MG-ANES-000058-R06', 'Il ne faut probablement pas utiliser la VNI à visée curative dans le traitement de l''insuffisance respiratoire aiguë déjà installée après extubation, aucun avantage n''étant démontré (à distinguer de son usage préventif, également non recommandé par ailleurs).', '2-', 'Q1 — Tableau 2, niveaux de recommandation par indication (catégorie « Aucun avantage démontré »)', null),
  ('MG-ANES-000058-R07', 'Il ne faut probablement pas utiliser la VNI dans les maladies neuromusculaires aiguës réversibles, aucun avantage n''étant démontré.', '2-', 'Q1 — Tableau 2, niveaux de recommandation par indication (catégorie « Aucun avantage démontré »)', null),
  ('MG-ANES-000058-R08', 'Il faut probablement proposer la VNI dans le traumatisme thoracique fermé isolé, son intérêt n''étant pas établi de façon certaine.', '2+', 'Q1 — Tableau 2, niveaux de recommandation par indication (catégorie « Intérêt non établi de façon certaine »)', null),
  ('MG-ANES-000058-R09', 'La VNI en mode VS-AI-PEP est recommandée dans les décompensations de BPCO avec acidose respiratoire et pH < 7,35.', '1+', 'Q2 — Critères cliniques d''instauration & modes (Thème : BPCO)', null),
  ('MG-ANES-000058-R10', 'La VS-PEP ne doit pas être utilisée dans les décompensations de BPCO.', '2-', 'Q2 — Critères cliniques d''instauration & modes (Thème : BPCO)', null),
  ('MG-ANES-000058-R11', 'La VNI dans l''OAP cardiogénique ne se conçoit qu''en association au traitement médical optimal ; elle doit être instaurée sur le mode VS-PEP ou VS-AI-PEP, en cas d''hypercapnie avec PaCO2 > 45 mmHg.', '1+', 'Q2 — Critères cliniques d''instauration & modes (Thème : OAP cardiogénique)', null),
  ('MG-ANES-000058-R12', 'La VNI dans l''OAP cardiogénique ne doit pas retarder la prise en charge spécifique d''un syndrome coronarien aigu ; elle doit être instaurée en cas de signes cliniques de détresse respiratoire, sans attendre le résultat des gaz du sang.', '2+', 'Q2 — Critères cliniques d''instauration & modes (Thème : OAP cardiogénique)', null),
  ('MG-ANES-000058-R13', 'La VNI en mode VS-AI-PEP est à proposer en première intention chez le patient immunodéprimé en cas d''insuffisance respiratoire aiguë (PaO2/FiO2 < 200 mmHg) avec infiltrat pulmonaire.', '2+', 'Q2 — Critères cliniques d''instauration & modes (Thème : IRA de l''immunodéprimé)', null),
  ('MG-ANES-000058-R14', 'La VNI est indiquée en cas d''insuffisance respiratoire aiguë après chirurgie de résection pulmonaire ou sus-mésocolique (VS-PEP ou VS-AI-PEP), sans retarder la recherche et la prise en charge d''une complication chirurgicale.', '2+', 'Q2 — Critères cliniques d''instauration & modes (Thème : Post-opératoire)', null),
  ('MG-ANES-000058-R15', 'La VNI prophylactique (VS-PEP) est probablement à proposer après chirurgie d''anévrysme aortique thoracique et abdominal ; la VS-PEP est envisageable si PaO2/FiO2 < 300 mmHg après abord sus-mésocolique.', '2+', 'Q2 — Critères cliniques d''instauration & modes (Thème : Post-opératoire)', null),
  ('MG-ANES-000058-R16', 'La VS-AI-PEP est envisageable en cas de sevrage difficile de la ventilation invasive chez un patient BPCO, ou en prévention de l''insuffisance respiratoire aiguë après extubation chez le patient hypercapnique.', '2+', 'Q2 — Critères cliniques par pathologie, suite (Thème : Sevrage de la VI)', null),
  ('MG-ANES-000058-R17', 'Chez le patient atteint de pathologie neuromusculaire, des signes cliniques de lutte (même frustres) ou une hypercapnie dès 45 mmHg constituent des indications formelles de VNI, associée au désencombrement (modes possibles : VS-AI-PEP, VAC en pression ou en volume).', '2+', 'Q2 — Critères cliniques par pathologie, suite (Thème : Pathologies neuromusculaires)', null),
  ('MG-ANES-000058-R18', 'La VS-AI-PEP est le mode ventilatoire de première intention dans les insuffisances respiratoires aiguës des mucoviscidoses, chez l''enfant comme chez l''adulte (les modes VACp et VACv restent également possibles).', '2+', 'Q2 — Critères cliniques par pathologie, suite (Thème : Mucoviscidose)', null),
  ('MG-ANES-000058-R19', 'La VNI est à envisager dans les formes apnéisantes des bronchiolites du nourrisson, et au cours des insuffisances respiratoires aiguës sur laryngo-trachéomalacie (mode VS-PEP).', '2+', 'Q2 — Critères cliniques par pathologie, suite (Thème : Autres indications [pédiatrie])', 'Pédiatrie'),
  ('MG-ANES-000058-R20', 'Un protocole de VNI peut être proposé lors d''une endoscopie bronchique en cas de rapport PaO2/FiO2 < 250 mmHg.', '2+', 'Q2 — Critères cliniques par pathologie, suite (Thème : Endoscopie bronchique)', null),
  ('MG-ANES-000058-R21', 'Le masque naso-buccal est recommandé en première intention comme interface de VNI. Les interfaces doivent être disponibles en plusieurs tailles et modèles ; en cas de complications liées à l''interface, d''autres modèles (masque total, casque) peuvent améliorer la tolérance.', '2+', 'Q3 — Moyens requis pour la mise en œuvre (Thème : Interfaces)', null),
  ('MG-ANES-000058-R22', 'L''humidification peut améliorer la tolérance de la VNI ; un humidificateur chauffant est à privilégier en pédiatrie (ou, à défaut, un filtre échangeur de chaleur et d''humidité).', '2+', 'Q3 — Moyens requis pour la mise en œuvre (Thème : Humidification)', null),
  ('MG-ANES-000058-R23', 'Une surveillance clinique est indispensable sous VNI, particulièrement durant la première heure. La mesure répétée de la fréquence respiratoire est essentielle, ainsi que la surveillance de la pression artérielle, de la fréquence cardiaque et de l''oxymétrie de pouls.', '1+', 'Q3 — Moyens requis pour la mise en œuvre (Thème : Suivi et monitorage)', null),
  ('MG-ANES-000058-R24', 'En pré-hospitalier et aux urgences, la VNI dans l''OAP se limite à la VS-PEP.', '1+', 'Q4 — Efficacité, échec et risques (Thème : Pré-hospitalier/urgences)', null),
  ('MG-ANES-000058-R25', 'En pré-hospitalier et aux urgences, la VS-AI-PEP (OAP cardiogénique ou décompensation de BPCO) est réservée aux équipes formées et entraînées disposant de respirateurs adaptés.', '2+', 'Q4 — Efficacité, échec et risques (Thème : Pré-hospitalier/urgences)', null),
  ('MG-ANES-000058-R26', 'La VNI peut être envisagée pour les décompensations modérées de BPCO (pH ≥ 7,30) en service de médecine, dans un environnement aux conditions de surveillance adaptées.', '2+', 'Q4 — Efficacité, échec et risques (Thème : Services de médecine)', null)
) as v(code, statement, grade, source_section, population)
where d.source_url = 'https://sfar.org/ventilation-non-invasive%E2%80%A8au-cours-de-linsuffisance-respiratoire-aigue-nouveau-ne-exclu/'
on conflict (recommendation_code) do nothing;
