-- Migration : Prise en charge de l'infarctus du myocarde à la phase aiguë
-- en dehors des services de cardiologie (HAS/SAMU de France/Société
-- francophone de médecine d'urgence/Société française de cardiologie,
-- Conférence de consensus, 23 novembre 2006, texte court publié 2007)
-- Source : rfe-sfar-website/build/content_infarctus_myocarde.json (56
-- recommandations atomiques identifiées à la lecture — ce document N'EST
-- PAS structuré en liste numérotée R1/R2 par la source elle-même (à la
-- différence de la majorité du corpus) : c'est un texte de conférence de
-- consensus en prose continue, mêlant 4 algorithmes décisionnels
-- restructurés en tableaux, 1 tableau "Traitements adjuvants" classique,
-- et de nombreux paragraphes narratifs. Chaque recommandation ci-dessous
-- correspond à un énoncé actionnable autonome identifié à la lecture du
-- corps du texte, PAS une conversion mécanique d'un tableau préexistant.
--
-- ⚠️ PROVENANCE — DISCLOSURE OBLIGATOIRE : `content_infarctus_myocarde.json`
-- fait partie des 9 fichiers "KNOWN DRIFT" documentés dans
-- `rfe-sfar-website/CLAUDE.md` — récupéré depuis l'Artifact publié en ligne
-- sans qu'aucun `fiche_*.py` ni fichier source n'ait jamais été committé
-- dans ce dépôt. Ce contenu N'A PAS suivi le pipeline de triple-lecture +
-- audit indépendant normalement exigé par ce projet et N'A PAS été
-- re-vérifié contre le PDF source par cette migration. Statut `draft`
-- comme toute migration, mais attention de relecture PARTICULIÈREMENT
-- élevée recommandée ici : ce document, contrairement aux autres fiches de
-- ce lot, n'a pas de structure R1/R2 imprimée par la source pour ancrer
-- l'atomisation — le découpage en 56 lignes ci-dessous est un jugement
-- éditorial de cette migration, à vérifier avec un soin particulier par un
-- relecteur humain (voir aussi les 2 points "À VÉRIFIER" sur le découpage
-- en fin de commentaire).
--
-- MÉTHODOLOGIE — grades HAS A/B/C (échelle des études thérapeutiques), À
-- LA DIFFÉRENCE du GRADE 1+/2+ utilisé ailleurs dans ce corpus : A = preuve
-- scientifique établie (niveau 1) ; B = présomption scientifique (niveau
-- 2) ; C = faible niveau de preuve (niveaux 3-4). Méthode "Conférence de
-- consensus" HAS : jury de non-experts, huis clos 48h après séance
-- publique — la GRANDE MAJORITÉ des énoncés du texte (dont les 4
-- algorithmes décisionnels) reposent sur un simple CONSENSUS DU JURY, SANS
-- grade associé (disclosure explicite de la source elle-même : "11
-- mentions explicites de grade figurent dans le corps du texte, 3xA, 7xB,
-- 1xC"). `grade` est donc NULL sur la majorité des 56 lignes ci-dessous —
-- reproduction fidèle de cette absence, PAS un oubli ni un grade deviné.
-- `evidence_level` laissé NULL (pas de niveau distinct du grade HAS
-- lui-même).
--
-- POPULATION : `population` renseigné explicitement pour Q4 (situations
-- particulières) — 'Sujet âgé', 'Diabète', 'Périopératoire' — et NULL
-- ailleurs (population adulte hors cardiologie implicite, déjà dans le
-- titre/champ).
--
-- PÉRIMÈTRE — volontairement pas migré en recommandation distincte
-- (disclosure, pas un oubli) : l'Algorithme 3 (filières SAMU-Centre 15 ->
-- effecteur -> SCDI) est une description de chaîne opérationnelle à un
-- seul chemin (pas de branchement décisionnel selon une variable clinique,
-- contrairement aux algorithmes 1/2/4 migrés en tableaux ci-dessus/dessous)
-- — même traitement que les algorithmes/protocoles opérationnels déjà
-- exclus ailleurs dans ce corpus (`voies_aeriennes_enfant`/0059,
-- `intubation_reanimation`/0028, `traumatisme_vertebromedullaire`/0056).
-- L'Annexe 1 (échelle de gradation HAS elle-même, A/B/C) est une grille
-- méthodologique, pas une proposition clinique.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. DÉCOUPAGE ÉDITORIAL : ce document mêlant prose narrative et
--    recommandations implicites, le découpage en 56 lignes atomiques
--    ci-dessous est un jugement de cette migration (contrairement aux
--    fiches à numérotation R1/R2 imprimée par la source) — un relecteur
--    pourrait légitimement re-regrouper ou re-fragmenter différemment
--    certaines lignes (ex. R36-R38, les 3 options de bradycardie).
-- 2. Le grade "(grade B)" imprimé UNE FOIS dans la phrase d'introduction de
--    la section "Tachycardies" ("plusieurs options thérapeutiques peuvent
--    être envisagées (grade B)") est ici appliqué aux 7 lignes du tableau
--    de décision qui suit (R39-R45) — reproduction d'un grade de section
--    unique sur ses lignes, même convention que `aap_programmee`/0005
--    ("Fort" imprimé une fois, appliqué à toutes les propositions du
--    tableau qu'il introduit).
-- 3. "Société francophone de médecine d'urgence" (promoteur nommé
--    explicitement par la source, distinct de "Société Française de
--    Médecine d'Urgence" / SFMU présente dans le seed Annexe B sous cet
--    acronyme précis) N'EST PAS liée à SFMU ci-dessous — possible
--    variante de dénomination historique de la même société (le sigle
--    SFMU n'apparaît pas explicitement dans le texte cité), mais cette
--    migration ne résout PAS cette ambiguïté par supposition. Seules SFAR,
--    SRLF et HAS (partenaire méthodologique explicite), toutes trois dans
--    le seed sous leur dénomination exacte, sont liées en
--    `document_societies`. SAMU de France, Afssaps, APNET, Bataillon des
--    marins-pompiers de Marseille, Brigade de sapeurs-pompiers de Paris,
--    Société française de biologie clinique, Société française de
--    médecine sapeur-pompier et SOS Médecins France restent hors seed,
--    non liées.
-- 4. `library_final.json` classe ce document `exact_type: "RFE"` ; la
--    source se désigne elle-même comme une "Conférence de consensus" HAS
--    — `doc_type` reprend l'auto-désignation de la source.
-- 5. Freshness : la source elle-même déclare "Les stratégies de
--    reperfusion et les traitements adjuvants du SCA ST+ ont évolué depuis
--    2006 (nouveaux antiplaquettaires P2Y12, protocoles de délais,
--    recommandations ESC ultérieures)" — `freshness_status =
--    'revision_detectee'` retenu (même critère que `monitorage_traumatise`/
--    0067).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge de l''infarctus du myocarde à la phase aiguë en dehors des services de cardiologie',
  'Conférence de consensus', 'fr', '2006-11-23',
  'https://sfar.org/prise-en-charge-de-linfarctus-du-myocarde-a-la-phase-aigue-en-dehors-des-services-de-cardiologie/',
  'https://sfar.org/wp-content/uploads/2015/10/2a_HAS_TEXTE-COURT_Prise-en-charge-de-linfarctus-du-myocarde.pdf',
  'Grades HAS A/B/C (échelle des études thérapeutiques), à la différence du GRADE 1+/2+ utilisé ailleurs dans ce corpus. Méthode "Conférence de consensus" HAS (jury de non-experts) : seules 11 mentions explicites de grade figurent dans le corps du texte (3xA, 7xB, 1xC) ; la grande majorité des énoncés, dont les 4 algorithmes décisionnels, reposent sur un simple consensus du jury sans grade associé. evidence_level non applicable (pas de niveau distinct du grade HAS).',
  'revision_detectee'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-de-linfarctus-du-myocarde-a-la-phase-aigue-en-dehors-des-services-de-cardiologie/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'), ('SRLF', 'France'), ('HAS', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-de-linfarctus-du-myocarde-a-la-phase-aigue-en-dehors-des-services-de-cardiologie/'
  and s.slug in ('cardiologie', 'medecine_d_urgence', 'anesthesie_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.condition_topic, v.source_section,
  'https://sfar.org/prise-en-charge-de-linfarctus-du-myocarde-a-la-phase-aigue-en-dehors-des-services-de-cardiologie/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000068-R01', 'Probabilité clinique de SCA forte, ECG contributif : désobstruction urgente.', null, null, 'Probabilité forte / ECG contributif', 'Q1 — Critères décisionnels de désobstruction coronaire'),
  ('MG-ANES-000068-R02', 'Probabilité clinique de SCA forte, ECG non contributif, troponines positives : désobstruction urgente.', null, null, 'Probabilité forte / ECG non contributif / troponines positives', 'Q1 — Critères décisionnels de désobstruction coronaire'),
  ('MG-ANES-000068-R03', 'Probabilité clinique de SCA forte, ECG non contributif, troponines négatives : pas de stratégie invasive (suivi médical, évaluation secondaire).', null, null, 'Probabilité forte / ECG non contributif / troponines négatives', 'Q1 — Critères décisionnels de désobstruction coronaire'),
  ('MG-ANES-000068-R04', 'Probabilité clinique de SCA faible, ECG contributif : stratégie invasive différée (24-48 h).', null, null, 'Probabilité faible / ECG contributif', 'Q1 — Critères décisionnels de désobstruction coronaire'),
  ('MG-ANES-000068-R05', 'Probabilité clinique de SCA faible, ECG non contributif : pas de stratégie invasive (suivi médical, évaluation secondaire).', null, null, 'Probabilité faible / ECG non contributif', 'Q1 — Critères décisionnels de désobstruction coronaire'),
  ('MG-ANES-000068-R06', 'Pour la prise en charge hors cardiologie, scinder le délai international premier contact médical-expansion du ballonnet (objectif global : 90 minutes) en 2 délais : le délai porte à porte cardio (premier contact médical → arrivée au service de cardiologie interventionnelle, seuil décisionnel recommandé : 45 minutes) et le délai porte cardio-ballon (arrivée en cardiologie interventionnelle → expansion du ballonnet).', null, null, 'Stratégie de délais', 'Q2 — Reperfusion et traitements adjuvants du SCA ST+'),
  ('MG-ANES-000068-R07', 'Pour la fibrinolyse, le jury recommande la ténectéplase (produit fibrino-spécifique, bolus IV unique d''environ 10 secondes, demi-vie courte, adaptable au poids, dose maximale 10 000 UI/50 mg) ; la streptokinase n''est pas recommandée.', null, null, 'Choix du fibrinolytique', 'Q2 — Reperfusion et traitements adjuvants du SCA ST+'),
  ('MG-ANES-000068-R08', 'Délai porte à porte cardio < 45 min ET somme des 2 délais < 90 min, début des symptômes < 3 h : choix entre fibrinolyse (TL) ou angioplastie primaire (APL) selon procédures locales écrites et évaluées ; contre-indication à la TL → APL.', null, null, 'Stratégie de reperfusion selon délais', 'Q2 — Reperfusion et traitements adjuvants du SCA ST+'),
  ('MG-ANES-000068-R09', 'Délai porte à porte cardio < 45 min ET somme des 2 délais < 90 min, début des symptômes 3-12 h : angioplastie primaire privilégiée ; contre-indication à la TL → APL.', null, null, 'Stratégie de reperfusion selon délais', 'Q2 — Reperfusion et traitements adjuvants du SCA ST+'),
  ('MG-ANES-000068-R10', 'Délai porte à porte cardio > 45 min, ou délai porte cardio-ballon non estimable (quel que soit le délai depuis le début des symptômes) : fibrinolyse ; en cas d''échec de la fibrinolyse → angioplastie de sauvetage.', null, null, 'Stratégie de reperfusion selon délais', 'Q2 — Reperfusion et traitements adjuvants du SCA ST+'),
  ('MG-ANES-000068-R11', 'Il est impératif que l''ensemble des structures d''urgences (SMUR et accueil des urgences) dispose des moyens de pratiquer une fibrinolyse (recommandation unanime du jury).', null, null, 'Organisation de la fibrinolyse', 'Q2 — Reperfusion et traitements adjuvants du SCA ST+'),
  ('MG-ANES-000068-R12', 'Dans tous les cas, après fibrinolyse, le patient doit être dirigé vers un centre disposant d''une salle de coronarographie diagnostique et interventionnelle (SCDI).', null, null, 'Organisation de la fibrinolyse', 'Q2 — Reperfusion et traitements adjuvants du SCA ST+'),
  ('MG-ANES-000068-R13', 'Le jury recommande la mise en place de registres d''évaluation de la stratégie de reperfusion, destinés à la faire évoluer.', null, null, 'Organisation de la fibrinolyse', 'Q2 — Reperfusion et traitements adjuvants du SCA ST+'),
  ('MG-ANES-000068-R14', 'Acide acétylsalicylique : bénéfice largement démontré dans le traitement des SCA.', 'A', null, 'Traitements adjuvants — Acide acétylsalicylique', 'Q2 — Reperfusion et traitements adjuvants du SCA ST+'),
  ('MG-ANES-000068-R15', 'Clopidogrel : recommandé à la phase précoce d''un SCA ST+, en association avec l''aspirine ou seul si celle-ci est contre-indiquée.', 'A', null, 'Traitements adjuvants — Clopidogrel', 'Q2 — Reperfusion et traitements adjuvants du SCA ST+'),
  ('MG-ANES-000068-R16', 'Antagonistes GPIIb/IIIa : l''abciximab est utilisé en phase aiguë de SCA ST+ avant une angioplastie primaire.', null, null, 'Traitements adjuvants — Antagonistes GPIIb/IIIa', 'Q2 — Reperfusion et traitements adjuvants du SCA ST+'),
  ('MG-ANES-000068-R17', 'Anticoagulants : en cas de fibrinolyse, l''énoxaparine est supérieure à l''HNF chez les patients de moins de 75 ans à fonction rénale normale. En cas d''angioplastie, l''HNF est le traitement de référence.', 'B', null, 'Traitements adjuvants — Anticoagulants', 'Q2 — Reperfusion et traitements adjuvants du SCA ST+'),
  ('MG-ANES-000068-R18', 'Dérivés nitrés : non recommandés en dehors de l''OAP et éventuellement d''une poussée hypertensive.', 'C', null, 'Traitements adjuvants — Dérivés nitrés', 'Q2 — Reperfusion et traitements adjuvants du SCA ST+'),
  ('MG-ANES-000068-R19', 'Oxygénothérapie : non systématique.', null, null, 'Traitements adjuvants — Oxygénothérapie', 'Q2 — Reperfusion et traitements adjuvants du SCA ST+'),
  ('MG-ANES-000068-R20', 'Antalgiques : traitement de choix, morphine en titration IV.', null, null, 'Traitements adjuvants — Antalgiques', 'Q2 — Reperfusion et traitements adjuvants du SCA ST+'),
  ('MG-ANES-000068-R21', 'Bêtabloquants : administration non préconisée de façon systématique.', null, null, 'Traitements adjuvants — Bêtabloquants', 'Q2 — Reperfusion et traitements adjuvants du SCA ST+'),
  ('MG-ANES-000068-R22', 'IEC et antagonistes calciques : aucun argument ne permet de les recommander.', null, null, 'Traitements adjuvants — IEC et antagonistes calciques', 'Q2 — Reperfusion et traitements adjuvants du SCA ST+'),
  ('MG-ANES-000068-R23', 'Insuline : recommandée pour corriger une hyperglycémie en phase aiguë d''IDM ; la solution glucose-insuline-potassium (GIK) n''est pas recommandée.', 'A', null, 'Traitements adjuvants — Insuline', 'Q2 — Reperfusion et traitements adjuvants du SCA ST+'),
  ('MG-ANES-000068-R24', 'Compte tenu des pertes de chances induites par le retard diagnostique et thérapeutique, il faut insister sur la réalisation répétée de campagnes d''éducation du grand public et des professionnels de santé — objectif « prescrire le 15 ».', null, null, 'Éducation et alerte', 'Q3 — Filières de prise en charge'),
  ('MG-ANES-000068-R25', 'Le jury recommande que le médecin régulateur du SAMU soit le « gardien du temps » du déroulement de l''intervention, faisant le lien entre l''équipe d''intervention et l''équipe d''accueil.', null, null, 'Régulation SAMU', 'Q3 — Filières de prise en charge'),
  ('MG-ANES-000068-R26', 'Dans les situations d''exception (isolement, défaut d''accessibilité durable et prévisible aux secours médicalisés et aux moyens d''évacuation rapides), le jury recommande la rédaction préalable de protocoles décisionnels.', null, null, 'Situations d''isolement', 'Q3 — Filières de prise en charge'),
  ('MG-ANES-000068-R27', 'Chez la personne âgée, la stratégie thérapeutique globale ne doit pas différer de celle des sujets jeunes malgré un risque de complications plus élevé, à l''exception du choc cardiogénique, où le recours à la reperfusion n''est pas systématique mais discuté cas par cas.', 'B', 'Sujet âgé', 'Personnes âgées', 'Q4 — Situations particulières'),
  ('MG-ANES-000068-R28', 'L''HNF est préférée aux HBPM chez le sujet de plus de 75 ans.', 'B', 'Sujet âgé (> 75 ans)', 'Personnes âgées', 'Q4 — Situations particulières'),
  ('MG-ANES-000068-R29', 'Chez la personne diabétique, la stratégie globale ne diffère pas de celle des sujets non diabétiques.', 'B', 'Diabète', 'Personnes diabétiques', 'Q4 — Situations particulières'),
  ('MG-ANES-000068-R30', 'Chez la personne diabétique, déterminer la glycémie capillaire au plus tôt, y compris en préhospitalier ; réduction précoce de l''hyperglycémie par l''insuline et réduction des apports glucidiques à la phase aiguë.', null, 'Diabète', 'Personnes diabétiques', 'Q4 — Situations particulières'),
  ('MG-ANES-000068-R31', 'IDM survenant dans un service de soins non cardiologiques : prise en charge organisée par des protocoles locaux pour une réponse dans les plus brefs délais.', null, null, 'IDM en service non cardiologique', 'Q4 — Situations particulières'),
  ('MG-ANES-000068-R32', 'En cas de décision de reperfusion en urgence pour un IDM survenant dans un service de soins non cardiologiques : les patients dans des sites avec plateau de cardiologie interventionnelle accessible doivent avoir une angioplastie primaire ; dans les autres cas, la stratégie de reperfusion ne diffère pas de celle proposée en dehors des structures de soins.', null, null, 'IDM en service non cardiologique', 'Q4 — Situations particulières'),
  ('MG-ANES-000068-R33', 'IDM périopératoire : prévention fondée sur l''analyse du segment ST et la correction rapide de toute anomalie hémodynamique (hypotension, hypertension, tachycardie) ou métabolique importante (anémie, hypothermie).', null, 'Périopératoire', 'IDM périopératoire', 'Q4 — Situations particulières'),
  ('MG-ANES-000068-R34', 'IDM périopératoire : détection par analyse ECG quotidienne et dosages répétés de troponine postopératoire ; prise en charge graduée selon la modification du segment ST et la cinétique de la troponine.', null, 'Périopératoire', 'IDM périopératoire', 'Q4 — Situations particulières'),
  ('MG-ANES-000068-R35', 'IDM périopératoire : le recours systématique en urgence à une coronarographie n''est licite qu''en cas de sus-décalage du segment ST.', null, 'Périopératoire', 'IDM périopératoire', 'Q4 — Situations particulières'),
  ('MG-ANES-000068-R36', 'Bradycardie bien tolérée et sans risque d''asystolie : surveillance électrocardioscopique seule.', null, null, 'Bradycardies', 'Q5 — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R37', 'Bradycardie symptomatique avec intolérance hémodynamique (habituellement liée à un BAV de haut degré), en cas de risque d''asystolie, ou si l''atropine est inefficace : entraînement électrosystolique externe.', null, null, 'Bradycardies', 'Q5 — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R38', 'Bradycardie symptomatique aiguë sans cause réversible : l''atropine est la thérapeutique de choix ; l''isoprénaline n''est pas recommandée et l''adrénaline ne doit être utilisée qu''en dernier recours.', null, null, 'Bradycardies', 'Q5 — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R39', 'Tachycardie chez un patient en arrêt circulatoire : choc électrique externe (CEE) immédiat, asynchrone, sans sédation, et réanimation cardio-pulmonaire médicalisée.', 'B', null, 'Tachycardies — Arrêt circulatoire', 'Q5 — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R40', 'Tachycardie avec état de choc cardiogénique ou OAP massif : sédation si le patient est conscient, CEE synchrone si possible, et gestes de réanimation.', 'B', null, 'Tachycardies — État de choc cardiogénique / OAP massif', 'Q5 — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R41', 'Tachycardie sans autre signe d''intolérance : surveillance clinique et paraclinique (scope).', 'B', null, 'Tachycardies — Pas d''autres signes d''intolérance', 'Q5 — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R42', 'Tachycardie à rythme irrégulier, QRS fin < 0,12 s (FA rapide) : amiodarone IV 300 mg sur 20-60 min puis 900 mg/24 h ; en cas d''échec, esmolol IV (500 µg/kg puis 50-200 µg/kg/4 min) ou aténolol (5 mg IV puis 75 mg per os).', 'B', null, 'Tachycardies — FA rapide (QRS fin, rythme irrégulier)', 'Q5 — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R43', 'Tachycardie à rythme irrégulier, QRS large > 0,12 s (TV polymorphe) : amiodarone IV (même schéma) ; en cas d''échec, CEE synchrone.', 'B', null, 'Tachycardies — TV polymorphe (QRS large, rythme irrégulier)', 'Q5 — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R44', 'Tachycardie à rythme régulier, QRS fin < 0,12 s (tachycardie sinusale) : surveillance attentive.', 'B', null, 'Tachycardies — Tachycardie sinusale (QRS fin, rythme régulier)', 'Q5 — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R45', 'Tachycardie à rythme régulier, QRS large > 0,12 s (TV) : amiodarone IV (même schéma) ; en cas d''échec, CEE synchrone.', 'B', null, 'Tachycardies — TV (QRS large, rythme régulier)', 'Q5 — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R46', 'Mesures initiales pour tout patient présentant une tachycardie : oxygène en fonction de la SpO2, monitoring ECG, surveillance continue de la pression artérielle et de la SpO2, accès veineux.', null, null, 'Tachycardies — mesures initiales', 'Q5 — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R47', 'Le contexte ischémique de l''arrêt circulatoire ne modifie pas les recommandations générales de la réanimation cardio-pulmonaire.', null, null, 'Arrêt circulatoire', 'Annexe — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R48', 'Si l''arrêt circulatoire survient sur un IDM déjà diagnostiqué et qu''une reprise d''activité circulatoire spontanée (RACS) est obtenue, la stratégie de reperfusion repose sur l''accès rapide à une salle de coronarographie diagnostique et interventionnelle (SCDI) opérationnelle.', null, null, 'Arrêt circulatoire', 'Annexe — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R49', 'Le massage cardiaque externe ne contre-indique pas la fibrinolyse ; chez un patient fibrinolysé, la survenue d''un arrêt circulatoire peut être un signe de reperfusion coronaire — une réanimation prolongée (60 à 90 minutes après l''injection du fibrinolytique) est justifiée pour favoriser son efficacité.', null, null, 'Arrêt circulatoire', 'Annexe — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R50', 'En l''absence de reprise d''activité circulatoire spontanée après arrêt circulatoire, il n''y a pas d''argument scientifique pour recommander ou interdire la fibrinolyse.', null, null, 'Arrêt circulatoire', 'Annexe — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R51', 'Si l''arrêt circulatoire constitue la première manifestation de l''IDM, il n''y a pas d''argument pour recommander une fibrinolyse.', null, null, 'Arrêt circulatoire', 'Annexe — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R52', 'Choc cardiogénique : stratégie reposant sur le traitement étiologique associé au traitement symptomatique — désobstruction coronaire précoce, préférentiellement par angioplastie, associée à des mesures de diminution de la consommation myocardique en oxygène (analgésie, oxygène).', 'B', null, 'Choc cardiogénique', 'Annexe — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R53', 'Choc cardiogénique : restauration hémodynamique par remplissage vasculaire prudent (en l''absence de signes d''insuffisance ventriculaire gauche), avec si nécessaire catécholamines titrées (dobutamine en 1re intention, noradrénaline en 2e intention).', null, null, 'Choc cardiogénique', 'Annexe — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R54', 'La contre-pulsion par ballonnet intra-aortique (CPBIA) favorise la stabilisation initiale des patients en choc cardiogénique secondaire à un IDM.', 'B', null, 'Choc cardiogénique', 'Annexe — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R55', 'Transferts interhospitaliers des infarctus compliqués : toujours des transports médicalisés par le SMUR, dont le premier objectif est de permettre au patient d''accéder à un niveau de soins supérieur tout en assurant sa sécurité.', null, null, 'Transferts interhospitaliers', 'Annexe — Prise en charge des complications initiales'),
  ('MG-ANES-000068-R56', 'Les équipes du SMUR doivent être formées aux techniques d''assistance circulatoire (contre-pulsion par ballonnet intra-aortique de plus en plus couramment utilisée, très rarement assistance circulatoire périphérique), ou l''équipe peut être complétée par un médecin maîtrisant ces techniques dans le cadre d''un protocole en réseau.', null, null, 'Transferts interhospitaliers', 'Annexe — Prise en charge des complications initiales')
) as v(code, statement, grade, population, condition_topic, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-de-linfarctus-du-myocarde-a-la-phase-aigue-en-dehors-des-services-de-cardiologie/'
on conflict (recommendation_code) do nothing;
