-- Migration : Thrombopénie induite par l'héparine (TIH) (SFAR, en
-- collaboration avec le GEHT/SFH, la SFC et la SRLF, Conférence d'experts,
-- 2002, Ann Fr Anesth Reanim 2003;22:150-159)
-- Source : rfe-sfar-website/build/content_tih_2002.json (67 recommandations
-- atomiques identifiées à la lecture, sur les 12 questions du texte —
-- diagnostic clinique/biologique, prévention, traitements de substitution
-- avec posologies, contre-indications, stratégies par contexte clinique y
-- compris chirurgie cardiaque sous CEC).
--
-- ⚠️ PROVENANCE — DISCLOSURE OBLIGATOIRE : `content_tih_2002.json` fait
-- partie des 9 fichiers "KNOWN DRIFT" documentés dans `rfe-sfar-website/
-- CLAUDE.md` — récupéré depuis l'Artifact publié en ligne sans qu'aucun
-- `fiche_*.py` ni fichier source n'ait jamais été committé dans ce dépôt.
-- Ce contenu N'A PAS suivi le pipeline de triple-lecture + audit
-- indépendant normalement exigé par ce projet et N'A PAS été re-vérifié
-- contre le PDF source par cette migration. Statut `draft` comme toute
-- migration, mais attention de relecture supérieure recommandée (même
-- disclosure que `examens_preinterventionnels`/0065 et les fiches
-- précédentes de ce lot).
--
-- MÉTHODOLOGIE — AUCUN système de grade formel. La source le dit
-- explicitement (disclosure reproduite ici) : "le niveau de preuve des
-- études est faible et la force des recommandations en médecine factuelle
-- [...] est du niveau le plus bas. Les experts ont donc estimé inutile
-- d'assortir chaque proposition d'un grade de recommandation." `grade` et
-- `evidence_level` sont donc NULL sur les 67 lignes — aucune force n'est
-- devinée ni inventée. La fiche source elle-même remplace la colonne de
-- grade habituelle par une colonne "Thème" (reproduite ici dans
-- `condition_topic`).
--
-- ⚠️ DOCUMENT EXPLICITEMENT SUPERSEDÉ — disclosure la plus forte de ce lot
-- (pas une inférence de cette migration, une déclaration de la fiche
-- source elle-même, dès son panneau d'introduction) : "une fiche plus
-- récente existe dans cette bibliothèque : les « Propositions du GIHP et
-- du GFHT pour le diagnostic et la prise en charge d'une TIH » (2019) sont
-- le document de référence ACTUEL sur ce sujet [...] Consultez-les en
-- priorité pour une décision thérapeutique." Ce document 2019 est DÉJÀ
-- migré dans ce corpus : voir `tih`/0047 (40 propositions, GIHP/GFHT/SFAR).
-- `freshness_status = 'revision_detectee'` ET `superseded_by_document_id`
-- pointé vers ce document 2019 via une UPDATE post-insertion (le document
-- 2019 existe déjà en base, migré par 0047 dans une session antérieure).
-- Cette fiche de 2002 reste néanmoins migrée intégralement (statut
-- `draft`, jamais fusionnée avec 0047) pour sa valeur documentaire propre
-- (critères diagnostiques cliniques/biologiques largement toujours
-- pertinents, protocoles détaillés de chirurgie cardiaque sous CEC absents
-- du document 2019) — décision de dépréciation éditoriale complète laissée
-- à la relecture humaine, jamais automatique.
--
-- ⚠️ OBSOLESCENCE THÉRAPEUTIQUE SPÉCIFIQUE (disclosure de la fiche source,
-- absente du texte original de 2002, ajoutée par le pipeline de
-- construction et reproduite ici) : la lépirudine (Refludan®), présentée
-- dans ce document comme option de 1re ligne, a été retirée du marché
-- européen en 2012 et n'est plus disponible. L'argatroban et le
-- fondaparinux, cités par la source comme "non encore disponibles en
-- France" en 2002, sont aujourd'hui des alternatives courantes. Les
-- posologies et protocoles ci-dessous sont reproduits FIDÈLEMENT depuis le
-- texte source de 2002 à titre documentaire — ne jamais les appliquer sans
-- vérifier le protocole local actualisé.
--
-- STRUCTURE DES DONNÉES : les 7 lignes issues du tableau comparatif
-- "Traitements de substitution" (R22-R28) fusionnent, par thème (mécanisme,
-- demi-vie, etc.), les données des 3 molécules comparées côte à côte par
-- la source (danaparoïde sodique, lépirudine, désirudine) en un seul
-- `statement` — reproduction du contenu comparatif de la source, pas une
-- fragmentation ni une fusion de forces divergentes (aucun grade n'existe
-- ici de toute façon).
--
-- PÉRIMÈTRE — volontairement pas migré en recommandation distincte
-- (disclosure, pas un oubli) : la phrase de clôture du chapitre
-- "Traitements de substitution" ("Aucune étude comparative directe entre
-- danaparoïde sodique et lépirudine [...] ; aucun antagoniste
-- pharmacologique pour ces deux médicaments") est une synthèse de contexte
-- déjà couverte par les lignes R22-R28, pas une proposition distincte.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Le GEHT (Groupe d'Étude Hémostase et Thrombose de la Société
--    française d'hématologie), co-organisateur explicite de cette
--    conférence au même titre que la SFC et la SRLF, ne figure pas dans
--    le seed Annexe B — seules SFAR, SFC et SRLF (toutes trois dans le
--    seed) sont liées en `document_societies`.
-- 2. `population` renseigné 'Femme enceinte' et 'Pédiatrie' pour les 2
--    lignes explicitement dédiées (R48-R49, stratégies milieu médical) ;
--    NULL ailleurs.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Thrombopénie induite par l''héparine',
  'CE', 'fr', '2002-01-01',
  'https://sfar.org/thrombopenie-induite-par-lheparine/',
  'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Thrombopenie-induite-par-lheparine.pdf',
  'Aucun système de grade formel — la source le dit explicitement : "les experts ont estimé inutile d''assortir chaque proposition d''un grade de recommandation" (faible niveau de preuve disponible en 2002). Colonne "Thème" remplaçant la colonne de grade habituelle. Document explicitement présenté par la fiche construite elle-même comme superseded par les Propositions GIHP/GFHT 2019 (déjà migrées, voir tih/0047) — à consulter en priorité pour toute décision thérapeutique actuelle ; lépirudine retirée du marché depuis 2012.',
  'revision_detectee'
)
on conflict (source_url) do nothing;

update public.documents set superseded_by_document_id = (
  select id from public.documents where source_url = 'https://sfar.org/download/diagnostic-et-prise-en-charge-dune-thrombopenie-induite-par-lheparine/?wpdmdl=34610'
)
where source_url = 'https://sfar.org/thrombopenie-induite-par-lheparine/'
  and superseded_by_document_id is null
  and exists (select 1 from public.documents where source_url = 'https://sfar.org/download/diagnostic-et-prise-en-charge-dune-thrombopenie-induite-par-lheparine/?wpdmdl=34610');

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/thrombopenie-induite-par-lheparine/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'), ('SFC', 'France'), ('SRLF', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/thrombopenie-induite-par-lheparine/'
  and s.slug in ('hematologie', 'anesthesie_reanimation', 'cardiologie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, population, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.population, v.condition_topic, v.source_section,
  'https://sfar.org/thrombopenie-induite-par-lheparine/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000072-R01', 'Depuis 1980, deux types de thrombopénie sous héparine sont distingués. Type I : bénigne, non immune, précoce, sans complication thrombotique, régresse malgré la poursuite de l''héparine. Type II : potentiellement grave, d''origine immune, d''apparition en règle plus tardive — c''est la TIH proprement dite, qu''elle survienne sous HNF ou HBPM.', null, 'Type I vs type II', 'Définitions et physiopathologie'),
  ('MG-ANES-000072-R02', 'Syndrome clinico-biologique induit par des anticorps (souvent IgG) reconnaissant le facteur 4 plaquettaire (F4P) modifié par l''héparine, avec activation plaquettaire intense et activation de la coagulation pouvant aboutir à des thromboses veineuses et/ou artérielles. La thrombopénie résulte de l''activation massive des plaquettes in vivo et de leur élimination par le système des phagocytes mononucléés.', null, 'Mécanisme', 'Définitions et physiopathologie'),
  ('MG-ANES-000072-R03', 'Fréquence de la TIH sous HNF plus élevée en milieu chirurgical (environ 3 % en moyenne) qu''en milieu médical (environ 1 % en moyenne), pouvant atteindre 5 % en chirurgie cardiaque et orthopédique. Sous HBPM, la TIH est plus rare mais possible.', null, 'Épidémiologie', 'Définitions et physiopathologie'),
  ('MG-ANES-000072-R04', 'Le diagnostic est difficile lorsque d''autres causes de thrombopénie existent, notamment en période postopératoire ou en réanimation. Il doit intégrer les circonstances cliniques et les traitements associés ; il ne peut être établi formellement que plusieurs jours après la suspicion et ne doit jamais retarder l''arrêt de l''héparine et la prescription d''un antithrombotique de substitution à action immédiate.', null, 'Difficulté diagnostique', 'Définitions et physiopathologie'),
  ('MG-ANES-000072-R05', 'Deux éléments caractérisent la TIH : la chronologie de la thrombopénie par rapport à l''administration d''héparine, et la rareté des manifestations hémorragiques contrastant avec la fréquence des accidents thrombotiques veineux et/ou artériels.', null, 'Particularités cliniques', 'Circonstances évocatrices du diagnostic'),
  ('MG-ANES-000072-R06', 'Délai de survenue typique : 5 à 8 jours après le début de l''héparinothérapie. Peut être plus court (avant le 5e jour, voire dès le 1er jour) chez un patient exposé à l''héparine dans les 3 mois précédents. Peut aussi être plus long, notamment avec les HBPM, pouvant excéder 3 semaines.', null, 'Délai de survenue', 'Circonstances évocatrices du diagnostic'),
  ('MG-ANES-000072-R07', 'Diagnostic à évoquer devant une numération plaquettaire < 100 G/l et/ou une diminution > 40 % par rapport à la numération initiale ; la thrombopénie est comprise entre 30 et 70 G/l chez 80 % des patients. Une CIVD est rapportée dans 10-20 % des cas — elle n''exclut pas le diagnostic de TIH et aggrave la thrombopénie.', null, 'Seuil de numération', 'Circonstances évocatrices du diagnostic'),
  ('MG-ANES-000072-R08', 'Complications thrombotiques très évocatrices : TVP chez 50 % des patients (recherche systématique justifiée), embolie pulmonaire dans 10 à 25 % des cas, thromboses artérielles (tous territoires possibles, plus grande fréquence pour l''aorte abdominale), résistance à l''héparinothérapie avec extension du processus thrombotique, complications neurologiques chez 9,5 % des patients (AVC ischémiques, thromboses veineuses cérébrales, états confusionnels, amnésies transitoires).', null, 'Complications thrombotiques', 'Circonstances évocatrices du diagnostic'),
  ('MG-ANES-000072-R09', 'Complications plus rarement observées : lésions dermatologiques (nécroses cutanées aux points d''injection, pouvant précéder la thrombopénie), nécroses hémorragiques des surrénales, complications hémorragiques (rares, favorisées par une CIVD, associées à une mortalité élevée).', null, 'Autres complications', 'Circonstances évocatrices du diagnostic'),
  ('MG-ANES-000072-R10', 'La confirmation de la thrombopénie est indispensable et urgente : prélèvement sur tube citraté et/ou capillaire, avec contrôle sur lame. Une CIVD doit être recherchée systématiquement.', null, 'Confirmation', 'Diagnostic biologique et démarche pratique'),
  ('MG-ANES-000072-R11', 'Les tests Elisa détectent les anticorps (IgG, IgM, IgA) dirigés contre le F4P en présence d''héparine — simples, sensibilité environ 95 %. Peuvent être positifs sans TIH associée, notamment au décours d''une CEC.', null, 'Tests Elisa', 'Diagnostic biologique et démarche pratique'),
  ('MG-ANES-000072-R12', 'Tests fonctionnels d''activation plaquettaire (agrégation plaquettaire — AP, ou sérotonine radiomarquée — SRA) montrant la présence d''anticorps IgG héparine-dépendants activant les plaquettes. AP : spécificité jusqu''à 80 %, sensibilité jusqu''à 91 %. SRA : sensibilité supérieure à l''AP, meilleure spécificité (environ 100 %), réactif disponible dans quelques laboratoires seulement.', null, 'Tests d''activation plaquettaire', 'Diagnostic biologique et démarche pratique'),
  ('MG-ANES-000072-R13', 'Le diagnostic repose sur un faisceau d''arguments : chronologiques, séméiologiques, biologiques, après recherche rigoureuse d''une autre cause. La normalisation de la numération à l''arrêt de l''héparine est capitale (ré-ascension dès la 48e h, correction moyenne au-dessus de 150 G/l en 4 à 7 j). Une authentique TIH peut survenir sans thrombopénie vraie : seule une baisse > 40 % par rapport à une référence préthérapeutique suffit.', null, 'Démarche pratique', 'Diagnostic biologique et démarche pratique'),
  ('MG-ANES-000072-R14', 'Interrogatoire/anamnèse rigoureux (traitements associés potentiellement thrombopéniants). L''arrêt de l''héparine et son remplacement par un antithrombotique d''action immédiate doivent être décidés dès la suspicion, sans attendre les résultats biologiques. Prélèvement pour recherche d''anticorps de préférence après l''arrêt de l''héparine ; délai de résultat optimal 48-72 h.', null, 'Autres éléments diagnostiques', 'Diagnostic biologique et démarche pratique'),
  ('MG-ANES-000072-R15', 'Les deux types de tests (Elisa + fonctionnel) sont complémentaires, à réaliser systématiquement ensemble : si les 2 sont positifs, TIH très probable ; si les 2 sont négatifs, TIH peu probable (mais non formellement exclue si la probabilité clinique reste élevée).', null, 'Interprétation combinée des tests', 'Diagnostic biologique et démarche pratique'),
  ('MG-ANES-000072-R16', 'Au terme de l''épisode, aboutir à une conclusion diagnostique claire intégrant l''évolution plaquettaire. Déclaration obligatoire au centre régional de pharmacovigilance de toute suspicion de TIH.', null, 'Conclusion et déclaration', 'Diagnostic biologique et démarche pratique'),
  ('MG-ANES-000072-R17', 'Une thrombopénie précoce (2 premiers jours), modérée, peut résulter de l''effet proagrégant de l''HNF, ou témoigner d''une TIH de survenue précoce après réintroduction d''héparine chez un patient déjà sensibilisé.', null, 'Diagnostic différentiel — lié à l''héparine', 'Diagnostic différentiel, prévention, surveillance'),
  ('MG-ANES-000072-R18', 'Diagnostics différentiels autres : hémodilution postopératoire, consommation plaquettaire dans les circuits extracorporels, purpura post-transfusionnel (diagnostic indispensable compte tenu de l''urgence de la décision), inhibiteurs des glycoprotéines GPIIb-IIIa, chimiothérapies antimitotiques chez le patient cancéreux.', null, 'Diagnostic différentiel — autres causes', 'Diagnostic différentiel, prévention, surveillance'),
  ('MG-ANES-000072-R19', 'Prévention primaire, trois axes : utiliser les héparines uniquement dans les indications validées ; durée d''utilisation la plus courte possible avec relais précoce par AVK ; utilisation préférentielle des HBPM dans les indications démontrées.', null, 'Prévention primaire', 'Diagnostic différentiel, prévention, surveillance'),
  ('MG-ANES-000072-R20', 'Établissement, pour chaque patient ayant présenté une TIH, d''un certificat médical attestant le diagnostic.', null, 'Prévention secondaire', 'Diagnostic différentiel, prévention, surveillance'),
  ('MG-ANES-000072-R21', 'Surveillance systématique de tous les patients recevant de l''héparine : numération plaquettaire avant le début du traitement, puis à partir du 5e jour, au moins 2 fois par semaine pendant au moins le premier mois. Chez un patient déjà exposé dans les 3 mois précédents : surveillance dès les premières heures après réintroduction. Rechercher une TIH devant toute thrombose ou aggravation d''une thrombose préexistante sous héparine.', null, 'Surveillance systématique', 'Diagnostic différentiel, prévention, surveillance'),
  ('MG-ANES-000072-R22', 'Mécanisme d''action des traitements de substitution : danaparoïde sodique (Orgaran®) — héparinoïde, activité anti-Xa prédominante, faible activité anti-IIa. Lépirudine (Refludan®) — hirudine recombinante, inhibiteur direct de la thrombine. Désirudine (Revasc®) — hirudine recombinante, voie sous-cutanée uniquement.', null, 'Mécanisme (traitements de substitution)', 'Traitements de substitution'),
  ('MG-ANES-000072-R23', 'Demi-vie des traitements de substitution : danaparoïde — anti-Xa environ 25 h, anti-IIa environ 7 h. Lépirudine — 0,8 à 1,7 h, élimination essentiellement rénale. Désirudine — 2 à 3 h, élimination urinaire 40-50 % de la dose.', null, 'Demi-vie (traitements de substitution)', 'Traitements de substitution'),
  ('MG-ANES-000072-R24', 'Voie et indication AMM : danaparoïde — SC (prophylaxie) ou IV continue, prophylaxie MTEV et traitement curatif des manifestations thromboemboliques de la TIH. Lépirudine — IV uniquement, traitement des patients atteints de TIH et de maladie thromboembolique. Désirudine — SC uniquement 15 mg x2/j, prévention de la thrombose veineuse après prothèse de hanche/genou (non étudiée en TIH à la phase aiguë, proposable en prévention chez un patient aux antécédents de TIH).', null, 'Voie / indication (traitements de substitution)', 'Traitements de substitution'),
  ('MG-ANES-000072-R25', 'Posologie phase aiguë de TIH — danaparoïde : SC prophylactique 750 U x3/j (<= 90 kg) ou 1250 U x3/j (> 90 kg) ; IV curatif charge selon poids (1250 à 3750 U) puis entretien 400 U/h puis 300 U/h puis 150-200 U/h ajusté à l''activité anti-Xa (cible 0,5-0,8 U/ml) ; pédiatrie (thrombose constituée) bolus 30 U/kg puis entretien 1,2-2,0 U/kg/h. Lépirudine : bolus IV 0,4 mg/kg puis perfusion continue 0,15 mg/kg/h, adapter en cas d''insuffisance rénale. Désirudine : 15 mg SC x2/j fixe, précautions si risque hémorragique accru.', null, 'Posologie phase aiguë (traitements de substitution)', 'Traitements de substitution'),
  ('MG-ANES-000072-R26', 'Surveillance des traitements de substitution : danaparoïde — numération plaquettaire quotidienne jusqu''à normalisation, activité anti-Xa si besoin (cible 0,5-0,8 U/ml). Lépirudine — TCA (limites reconnues), centres spécialisés recommandés. Désirudine — TCA en cas d''insuffisance rénale (ratio < 2 au pic).', null, 'Surveillance (traitements de substitution)', 'Traitements de substitution'),
  ('MG-ANES-000072-R27', 'En cas d''échec ou surdosage : danaparoïde — évoquer une réactivité croisée et envisager la lépirudine ; en cas d''hémorragie grave, transfusion de plasma frais/plaquettes, plasmaphérèse si hémorragie incontrôlable (la protamine ne le neutralise que partiellement et n''est pas recommandée par le RCP). Lépirudine — pas d''antagoniste ; en cas d''hémorragie menaçante, hémofiltration/hémodialyse à haut flux peuvent être utiles. Désirudine — pas d''antagoniste connu.', null, 'Échec / surdosage (traitements de substitution)', 'Traitements de substitution'),
  ('MG-ANES-000072-R28', 'Particularités : danaparoïde — réactivité croisée in vitro 5-10 % (conséquences cliniques rares), ne passe pas la barrière placentaire (recommandé chez la femme enceinte), relais AVK possible après 5-7 j de traitement et plaquettes > 100 G/L. Lépirudine — contre-indiquée chez la femme enceinte, relais AVK débuté seulement après réduction progressive de la lépirudine.', null, 'Particularités (traitements de substitution)', 'Traitements de substitution'),
  ('MG-ANES-000072-R29', 'Les HBPM sont formellement contre-indiquées en cas de TIH sous HNF. Les AVK ne doivent jamais être utilisés seuls.', null, 'Contre-indications formelles', 'Contre-indications'),
  ('MG-ANES-000072-R30', 'La transfusion plaquettaire n''est pas recommandée car elle peut favoriser la survenue de thromboses ou le processus de consommation. Les hémorragies associées à la TIH sont exceptionnelles, mais des transfusions plaquettaires sont envisageables en cas de saignement grave.', null, 'Transfusion plaquettaire', 'Contre-indications'),
  ('MG-ANES-000072-R31', 'Antécédents de TIH avec anticoagulation nécessaire : éviter la réintroduction d''héparine sous quelque forme/dose que ce soit, en particulier dans les 3 mois suivant la TIH et si anticorps encore détectables. Exception : CEC en chirurgie cardiaque, HNF seule envisageable en l''absence d''anticorps détectables, ou sous couvert d''un antiplaquettaire si anticorps persistants. Danaparoïde sodique SC recommandé pour la prophylaxie, sauf possiblement en chirurgie de prothèse de hanche/genou où la désirudine peut être préférée.', null, 'Situation 1 — antécédents de TIH', 'Tableau 1 — Principes généraux de prise en charge'),
  ('MG-ANES-000072-R32', 'Phase aiguë de TIH, pour tous les patients : dès suspicion, arrêter immédiatement toute héparine (y compris purges de cathéter) ; supprimer toute ligne intravasculaire pré-enduite d''héparine ; hospitaliser en unité de soins intensifs ; contacter un laboratoire d''hémostase spécialisé ; rechercher systématiquement une TVP et quotidiennement une complication thromboembolique.', null, 'Situation 2 — phase aiguë, tous patients', 'Tableau 1 — Principes généraux de prise en charge'),
  ('MG-ANES-000072-R33', 'Phase aiguë de TIH sans indication de traitement curatif : danaparoïde sodique à doses au moins prophylactiques jusqu''à correction plaquettaire, relais AVK envisagé si prévention prolongée. Lépirudine semble aussi efficace mais risque hémorragique probablement plus élevé (pas de comparaison randomisée directe) ; sans AMM française dans cette indication.', null, 'Situation 2a — sans indication de traitement curatif', 'Tableau 1 — Principes généraux de prise en charge'),
  ('MG-ANES-000072-R34', 'Phase aiguë de TIH avec thrombose artérielle ou veineuse : danaparoïde sodique ou lépirudine à doses curatives (efficacité voisine, risque hémorragique probablement plus élevé avec la lépirudine). Adapter la dose à la fonction rénale. Si pronostic fonctionnel du membre et/ou vital engagé : thrombolyse médicamenteuse ou geste chirurgical/radiologique sous danaparoïde ou lépirudine.', null, 'Situation 2b — avec thrombose artérielle ou veineuse', 'Tableau 1 — Principes généraux de prise en charge'),
  ('MG-ANES-000072-R35', 'Les antagonistes de la vitamine K ne doivent jamais être utilisés seuls à la phase aiguë ; introduits au plus tôt lorsque la ré-ascension plaquettaire est confirmée, sous couvert d''un anticoagulant efficace (danaparoïde ou hirudine).', null, 'Antagonistes de la vitamine K', 'Autres traitements possibles'),
  ('MG-ANES-000072-R36', 'Les agents antiplaquettaires ne peuvent être utilisés seuls. L''association aspirine + anticoagulant augmente le risque hémorragique sans efficacité validée. Iloprost et époprosténol : risque d''hypotension sévère, non indiqués hors chirurgie cardiovasculaire. Antagonistes des récepteurs GPIIb-IIIa utilisés avec succès dans de rares cas d''occlusion coronaire aiguë post-angioplastie au cours de TIH.', null, 'Agents antiplaquettaires', 'Autres traitements possibles'),
  ('MG-ANES-000072-R37', 'Les thrombolytiques ont une indication possible dans la prise en charge des complications thrombotiques graves survenant au cours des TIH.', null, 'Thrombolytiques', 'Autres traitements possibles'),
  ('MG-ANES-000072-R38', 'Les immunoglobulines et plasmaphérèses sont utilisées exceptionnellement.', null, 'Immunoglobulines, plasmaphérèses', 'Autres traitements possibles'),
  ('MG-ANES-000072-R39', 'La pose d''un filtre cave est proposable en cas d''embolie pulmonaire grave associée à un risque hémorragique élevé, mais avec un risque d''oblitération thrombotique aiguë du filtre.', null, 'Interruption cave', 'Autres traitements possibles'),
  ('MG-ANES-000072-R40', 'La thromboembolectomie chirurgicale fait partie de l''éventail thérapeutique, mais sa pratique est exceptionnelle — justifiée lorsque l''ischémie menace le pronostic fonctionnel du membre et/ou le pronostic vital.', null, 'Chirurgie', 'Autres traitements possibles'),
  ('MG-ANES-000072-R41', 'L''argatroban et le ximelagatran sont cités comme potentiellement intéressants mais non encore disponibles/rapportés dans la TIH à la date de la source (2002). Le fondaparinux : utilisation thérapeutique dans la TIH non encore rapportée à la date de la source. Ces molécules sont aujourd''hui d''usage courant (voir avertissement d''actualité thérapeutique).', null, 'Molécules non disponibles en France en 2002', 'Autres traitements possibles'),
  ('MG-ANES-000072-R42', 'Anticoagulation curative en milieu médical (MTEV, insuffisance coronaire aiguë, cardiopathies arythmiques) : lépirudine ou danaparoïde sodique utilisés prioritairement selon le terrain (risque hémorragique, insuffisance rénale) et les possibilités locales de surveillance biologique.', null, 'Anticoagulation curative', 'Stratégies — milieu médical'),
  ('MG-ANES-000072-R43', 'Prophylaxie MTEV en milieu médical : usage préférentiel du danaparoïde sodique recommandé.', null, 'Prophylaxie MTEV', 'Stratégies — milieu médical'),
  ('MG-ANES-000072-R44', 'Radiologie interventionnelle : lépirudine recommandée ; danaparoïde sodique possible.', null, 'Radiologie interventionnelle', 'Stratégies — milieu médical'),
  ('MG-ANES-000072-R45', 'Hémodialyse séquentielle : danaparoïde sodique utilisable avec surveillance biologique étroite (risque hémorragique plusieurs heures après la fin de la dialyse). Lépirudine envisageable avec membranes de faible perméabilité, mais risque hémorragique augmenté. Citrate de sodium ou prostacycline envisageables en centres expérimentés.', null, 'Hémodialyse séquentielle', 'Stratégies — milieu médical'),
  ('MG-ANES-000072-R46', 'Hémofiltration : danaparoïde sodique, solution la plus logique. Lépirudine en 2e intention (expérience limitée). Citrate de sodium et prostacycline : facteurs limitants majeurs.', null, 'Hémofiltration', 'Stratégies — milieu médical'),
  ('MG-ANES-000072-R47', 'Héparinisation des cathéters : arrêt impératif de toute héparinisation et ablation des matériels imprégnés d''héparine. Perméabilité maintenue sans anticoagulant ou avec citrate de sodium ; coumadine à dose fixe 1 mg/j : alternative possible.', null, 'Héparinisation des cathéters', 'Stratégies — milieu médical'),
  ('MG-ANES-000072-R48', 'Femme enceinte : danaparoïde sodique recommandé (ne passe pas la barrière placentaire). Lépirudine contre-indiquée.', 'Femme enceinte', 'Femme enceinte', 'Stratégies — milieu médical'),
  ('MG-ANES-000072-R49', 'Enfant : danaparoïde sodique ou lépirudine utilisables avec adaptation des doses et surveillance biologique adaptée.', 'Pédiatrie', 'Enfant', 'Stratégies — milieu médical'),
  ('MG-ANES-000072-R50', 'Chirurgie vasculaire : protocoles de chirurgie cardiaque proposables pour la chirurgie aortique si anticoagulation péri-opératoire nécessaire. Certaines chirurgies artérielles proximales réalisables sans anticoagulant.', null, 'Chirurgie vasculaire', 'Stratégies — chirurgie non cardiaque'),
  ('MG-ANES-000072-R51', 'Thrombose artérielle en chirurgie non cardiaque : désobstruction chirurgicale ou thrombolyse à discuter.', null, 'Thrombose artérielle', 'Stratégies — chirurgie non cardiaque'),
  ('MG-ANES-000072-R52', 'Antécédent de TIH avec anticoagulation préventive nécessaire (chirurgie non cardiaque) : danaparoïde sodique préférentiellement indiqué. Alternative après prothèse de hanche/genou : désirudine, avec relais précoce par AVK si nécessaire.', null, 'Antécédent de TIH — anticoagulation préventive', 'Stratégies — chirurgie non cardiaque'),
  ('MG-ANES-000072-R53', 'Antécédent de TIH avec anticoagulation curative nécessaire (chirurgie non cardiaque) : danaparoïde sodique en 1re intention, relais AVK entre le 5e et le 7e jour.', null, 'Antécédent de TIH — anticoagulation curative', 'Stratégies — chirurgie non cardiaque'),
  ('MG-ANES-000072-R54', 'TIH en cours sans thrombose (chirurgie non cardiaque) : danaparoïde sodique, relais AVK si possible entre le 5e et le 7e jour.', null, 'TIH en cours, sans thrombose', 'Stratégies — chirurgie non cardiaque'),
  ('MG-ANES-000072-R55', 'TIH en cours avec thrombose (chirurgie non cardiaque) : danaparoïde sodique ou lépirudine, relais AVK entre le 5e et le 7e jour.', null, 'TIH en cours, avec thrombose', 'Stratégies — chirurgie non cardiaque'),
  ('MG-ANES-000072-R56', 'Embolie pulmonaire grave avec anticoagulant contre-indiqué (chirurgie non cardiaque) : barrage cave à discuter.', null, 'Embolie pulmonaire grave + anticoagulant contre-indiqué', 'Stratégies — chirurgie non cardiaque'),
  ('MG-ANES-000072-R57', 'Choix de 1re intention en chirurgie cardiaque sous CEC : HNF associée à un antiplaquettaire puissant, ou lépirudine — choix basé sur la disponibilité des médicaments et des moyens de surveillance biologique, l''expérience de l''équipe et les morbidités associées du patient.', null, 'Choix de 1re intention (CEC)', 'Stratégies en chirurgie cardiaque avec/sans CEC'),
  ('MG-ANES-000072-R58', 'Protocole HNF + iloprost/époprosténol en CEC : iloprost débuté dès l''induction (3 ng/kg/min, paliers jusqu''à 30-50 ng/kg/min) avec vérification de l''inhibition de l''agrégation plaquettaire avant l''injection d''HNF (300 U/kg) ; en fin de CEC, iloprost réduit puis arrêté après protamine. Époprosténol utilisable en remplacement de l''iloprost.', null, 'HNF + iloprost/époprosténol (CEC)', 'Stratégies en chirurgie cardiaque avec/sans CEC'),
  ('MG-ANES-000072-R59', 'Protocole HNF + tirofiban en CEC : tirofiban 10 µg/kg en bolus 5 min avant l''héparine, puis perfusion continue 0,15 µg/kg/min arrêtée au déclampage aortique ; HNF 400 UI/kg en bolus, neutralisée par protamine en fin de CEC. Recommandé pour les patients avec insuffisance rénale préopératoire (risque de saignement majoré avec la lépirudine).', null, 'HNF + tirofiban (CEC)', 'Stratégies en chirurgie cardiaque avec/sans CEC'),
  ('MG-ANES-000072-R60', 'Protocole lépirudine en CEC : bolus 0,25 mg/kg + 0,20 mg/kg dans le volume d''amorçage, puis perfusion continue 0,15 mg/kg/h ; surveillance par ECT (temps de coagulation à l''écarine) toutes les 15 min — une CEC réglée sans monitorage ECT n''est pas raisonnable sous lépirudine. Demi-vie prolongée en insuffisance rénale ; hémofiltration veino-veineuse sans anticoagulant proposable pour l''élimination.', null, 'Lépirudine, protocole CEC', 'Stratégies en chirurgie cardiaque avec/sans CEC'),
  ('MG-ANES-000072-R61', 'Le danaparoïde sodique n''est pas recommandé en 1re intention pour l''anticoagulation per-CEC en raison de sa demi-vie longue (environ 25 h) et de la fréquence élevée de saignements postopératoires excessifs rapportés — sauf en l''absence de toute autre alternative.', null, 'Danaparoïde sodique en CEC', 'Stratégies en chirurgie cardiaque avec/sans CEC'),
  ('MG-ANES-000072-R62', 'Anticoagulation postopératoire après chirurgie cardiaque : après antiplaquettaire + HNF, relais par danaparoïde sodique ou lépirudine ; après lépirudine, relais par lépirudine ou danaparoïde sodique ; après danaparoïde sodique, traitement continué.', null, 'Anticoagulation postopératoire (CEC)', 'Stratégies en chirurgie cardiaque avec/sans CEC'),
  ('MG-ANES-000072-R63', 'Si l''anticoagulation de la CEC est réalisée avec HNF + antiplaquettaire, le choix d''un circuit pré-héparinés ne modifie pas les problèmes liés à la TIH. Si l''anticoagulation est réalisée avec un anticoagulant autre que l''HNF, les circuits pré-héparinés ne doivent pas être utilisés.', null, 'Circuits pré-héparinés', 'Stratégies en chirurgie cardiaque avec/sans CEC'),
  ('MG-ANES-000072-R64', 'Stratégie chez le patient en TIH active nécessitant une chirurgie cardiaque : HNF seule est interdite dans tous les cas. Chirurgie non urgente : attendre la disparition des anticorps. Chirurgie non différable, fonction rénale normale : HNF + antiplaquettaire puissant ou lépirudine, voire danaparoïde sodique. Fonction rénale altérée : HNF + antiplaquettaire puissant, voire lépirudine avec hémofiltration.', null, 'Stratégie — patient en TIH active (CEC)', 'Stratégies en chirurgie cardiaque avec/sans CEC'),
  ('MG-ANES-000072-R65', 'Stratégie chez le patient aux antécédents de TIH nécessitant une chirurgie cardiaque : rechercher la présence d''anticorps anti-F4P-héparine. Anticorps présents : même conduite que si TIH active, ou attente d''au moins 3 mois. Anticorps absents : HNF proscrite en pré/postopératoire mais utilisable seule pendant l''intervention ; danaparoïde sodique ou lépirudine recommandés en postopératoire. L''aspirine ne doit jamais être utilisée seule après pontage aorto-coronarien.', null, 'Stratégie — patient aux antécédents de TIH (CEC)', 'Stratégies en chirurgie cardiaque avec/sans CEC'),
  ('MG-ANES-000072-R66', 'En chirurgie cardiaque urgente : pour la lépirudine sans monitorage ECT disponible, bolus 0,25 mg/kg + 0,20 mg/kg dans le volume d''amorçage puis perfusion continue 0,15 mg/kg/h, monitorage par ACT toutes les 15 min (cible > 400 s). Après l''arrêt de la CEC : élimination par diurèse forcée. Patients oligo-anuriques : hémofiltration veino-veineuse sans anticoagulant.', null, 'Chirurgie cardiaque en urgence', 'Stratégies en chirurgie cardiaque avec/sans CEC'),
  ('MG-ANES-000072-R67', 'Revascularisation coronaire sans CEC : danaparoïde sodique utilisable (expérience clinique limitée). Protocole proposé : bolus 2250 U IV au début du prélèvement de l''artère mammaire interne, puis perfusion continue 150 U/h arrêtée 45 min avant la fin présumée de l''intervention. Surveillance par activité anti-Xa toutes les 15 min (cible 0,6 U anti-Xa/ml).', null, 'Revascularisation coronaire sans CEC', 'Stratégies en chirurgie cardiaque avec/sans CEC')
) as v(code, statement, population, condition_topic, source_section)
where d.source_url = 'https://sfar.org/thrombopenie-induite-par-lheparine/'
on conflict (recommendation_code) do nothing;
