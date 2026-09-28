-- Migration : Prévention de la maladie thromboembolique veineuse (MTEV) péri-opératoire chez
-- l'adulte (toutes chirurgies) et chez l'enfant — Recommandations Formalisées d'Experts du
-- Groupe d'intérêt en Hémostase Péri-opératoire (GIHP), en collaboration avec la SFAR, la
-- Société Française de Thrombose et d'Hémostase (SFTH) et la Société Française de Médecine
-- Vasculaire (SFMV) ; endossée par la SFCD, la SFPT et le réseau INNOVTE. Actualise la RFE
-- SFAR de 2011 sur le même sujet. Vote n=37 participants. Source :
-- rfe-sfar-website/build/content_mtev_perioperatoire.json (77 recommandations graduées,
-- 14 questions PICO, 21 sous-thèmes cliniques).
--
-- MÉTHODOLOGIE : GRADE classique (force forte 1+/1-, force faible 2+/2-, avis d'experts AE).
-- `grade` reproduit tel quel le chip source. `evidence_level` laissé NULL.
--
-- PARTICULARITÉ DISCLOSÉE PAR LA SOURCE ELLE-MÊME (vérifiée par recherche exhaustive sur
-- l'extraction texte complète des 79 pages source) : les 77 recommandations portent TOUTES
-- la mention d'accord « Fort » — AUCUNE occurrence d'« Accord Faible » nulle part dans le
-- document, contrairement à la quasi-totalité des autres RFE de ce corpus. La fiche source
-- n'affiche donc pas de colonne « Accord » distincte (elle serait constante, non
-- informative) — reproduit ici de la même façon, sans colonne/valeur `evidence_level`
-- dédiée à l'accord.
--
-- COMPTAGE — RECONCILIÉ EXACTEMENT : la source annonce elle-même "77 recommandations
-- individuelles graduées des 14 questions PICO... comportant au total 21 sous-thèmes
-- cliniques". Comptage direct des 77 lignes migrées ci-dessous : 19×1+, 7×1-, 31×2+, 10×2-,
-- 10×AE = reconciliation exacte.
--
-- PÉRIMÈTRE — volontairement pas migrées, DISCLOSURE DÉTAILLÉE (cas différent de la plupart
-- des exclusions "algorithme" de ce corpus) : les 3 figures de synthèse de la source
-- (Figure 1 p.16, thromboprophylaxie après PTH/PTG ; Figure 2 p.74, prise en charge d'une
-- TVP distale post-opératoire ; Figure 3 p.79, schéma de synthèse global) sont explicitement
-- décrites par le contenu construit lui-même comme des "images pures, redessinées ici en
-- tableaux/panneaux structurés fidèles au contenu ET AUX GRADES IMPRIMÉS" — c'est-à-dire que,
-- contrairement aux algorithmes ungraded exclus ailleurs dans ce corpus (curares/0018,
-- hsa/0023, ih/0026, intubation_difficile_adulte/0027), ces 3 figures portent de VRAIS
-- grades individuels fidèlement reproduits depuis les images sources, pas des synthèses
-- inventées. Elles ne sont néanmoins PAS migrées comme des lignes `recommendations`
-- distinctes ici, pour deux raisons disclosées explicitement : (1) un examen des blocs de
-- la Figure 1 (ex. "Thromboprophylaxie SÉQUENTIELLE : anticoagulant 5 jours puis aspirine...",
-- grade 1+) montre qu'ils restatent, sous forme d'arbre décisionnel, un sous-ensemble du
-- contenu déjà couvert par les lignes "Indication/Durée/Modalités" de la section PTH/PTG
-- migrées ci-dessous (même grade 1+, même contenu clinique) — les migrer séparément
-- risquerait de créer des doublons non exactement identifiables comme tels (paraphrases,
-- pas des citations verbatim identiques) ; (2) une analyse exhaustive bloc par bloc,
-- nécessaire pour distinguer avec certitude les segments réellement nouveaux des segments
-- redondants au sein des 3 figures, n'a pas été menée dans cette migration compte tenu du
-- volume. Ce choix est disclosé explicitement ici plutôt que silencieux : un relecteur
-- humain souhaitant les migrer individuellement devra d'abord établir cette correspondance
-- bloc/doublon. Les 3 figures restent entièrement reproduites, fidèles aux grades imprimés,
-- dans la fiche de synthèse elle-même (rfe-sfar-website).
-- Également volontairement pas migrés : le tableau "Anticoagulant (dose préventive) |
-- Demi-vie | Délai minimum avant le geste neuraxial" (référence posologique), le tableau
-- d'adaptation posologique par DFG estimé (référence posologique), et les 3 tableaux de
-- méta-analyses chiffrées (Événement/Odds ratio, Daltéparine vs HNF, Comparaison/Risque
-- relatif) — données d'argumentaire scientifique brutes, pas des recommandations graduées.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Sociétés co-organisatrices/collaboratrices (GIHP, SFTH, SFMV) et endosseurs (SFCD,
--    SFPT, réseau INNOVTE) : aucune ne correspond à un acronyme du seed Annexe B de
--    schema_v2.sql — seule la SFAR (collaboratrice) est liée en document_societies.
-- 2. `library_final.json` contient à la fois cette RFE 2024 ("en vigueur") ET la RFE SFAR
--    2011 qu'elle actualise et remplace, ÉGALEMENT marquée `"status": "en vigueur"` dans cet
--    index — la RFE 2011 devrait probablement être marquée obsolète/abrogée dans
--    `library_final.json`, incohérence à corriger par un relecteur humain de ce fichier
--    (pas de ce projet de migration) ; source de 2024 utilisée ici, la plus récente.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prévention de la maladie thromboembolique veineuse (MTEV) péri-opératoire',
  'RFE', 'fr', '2024-05-01',
  'https://sfar.org/prevention-de-la-maladie-thromboembolique-veineuse-peri-operatoire/',
  'https://sfar.org/download/prevention-de-la-maladie-thromboembolique-veineuse-peri-operatoire/?wpdmdl=62247',
  'GRADE® : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ proposé / 2- proposé de ne pas faire) ; avis d''experts (AE). Vote n=37 : accord fort si ≥70% d''accord et <20% d''opposition. Particularité disclosée par la source elle-même : les 77 recommandations portent TOUTES la mention "Accord Fort" — aucune occurrence d''"Accord Faible" dans les 79 pages source (vérifié par recherche exhaustive) ; pas de colonne Accord distincte pour cette raison. Actualise et remplace la RFE SFAR de 2011 sur le même sujet.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prevention-de-la-maladie-thromboembolique-veineuse-peri-operatoire/'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prevention-de-la-maladie-thromboembolique-veineuse-peri-operatoire/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'chirurgie_orthopedique_et_traumatologique', 'chirurgie_vasculaire', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.source_section,
  'https://sfar.org/prevention-de-la-maladie-thromboembolique-veineuse-peri-operatoire/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000033-R01', 'Il est recommandé d''implémenter localement des protocoles de thromboprophylaxie veineuse pour réduire le risque de complications péri-opératoires. Ces protocoles incluent la déambulation précoce et la thromboprophylaxie pharmacologique et mécanique, dont l''indication, les modalités et la durée dépendent du risque thromboembolique veineux de la chirurgie et du patient, du risque hémorragique et du parcours de soin.', '1+', null, 'Q1 — Impact de l''implémentation de protocoles de thromboprophylaxie — Thème : Protocoles locaux'),
  ('MG-ANES-000033-R02', 'Après une chirurgie à faible risque thromboembolique veineux, si le patient présente un facteur de risque majeur ou plusieurs facteurs de risque mineurs, il est proposé de prescrire une thromboprophylaxie par anticoagulant pendant une durée minimale de 7 jours.', '2+', null, 'Q2 — Facteurs de risque thromboembolique veineux liés au patient — Thème : Chirurgie faible risque + FdR patient'),
  ('MG-ANES-000033-R03', 'En cas de thrombophilie majeure sans traitement anticoagulant au long cours, il est suggéré de se rapprocher d''un centre spécialisé afin de documenter la thrombophilie et d''évaluer le risque thromboembolique veineux.', 'AE', null, 'Q2 — Facteurs de risque thromboembolique veineux liés au patient — Thème : Thrombophilie majeure sans AC'),
  ('MG-ANES-000033-R04', 'Il est recommandé de prescrire une thromboprophylaxie pharmacologique après PTH ou PTG.', '1+', null, 'Orthopédie — Prothèse totale de hanche (PTH) ou de genou (PTG), hors fracture — Thème : Indication'),
  ('MG-ANES-000033-R05', 'Il est recommandé que la durée de thromboprophylaxie pharmacologique soit de 35 jours après PTH et 14 jours après PTG.', '1+', null, 'Orthopédie — Prothèse totale de hanche (PTH) ou de genou (PTG), hors fracture — Thème : Durée'),
  ('MG-ANES-000033-R06', 'Il est recommandé de prescrire soit un anticoagulant (AOD, HBPM ou fondaparinux) pendant toute la durée, soit une thromboprophylaxie séquentielle (5 jours d''anticoagulant puis aspirine 75-100 mg/j pendant 30 jours après PTH ou 9 jours après PTG) si le patient est pris en charge dans un parcours de RAAC réussi et sans facteur de risque thromboembolique veineux majeur** ni plusieurs facteurs mineurs.', '1+', null, 'Orthopédie — Prothèse totale de hanche (PTH) ou de genou (PTG), hors fracture — Thème : Modalités'),
  ('MG-ANES-000033-R07', 'Une thromboprophylaxie par anticoagulant (HBPM ou fondaparinux) est recommandée pendant 4 semaines après la chirurgie.', '1+', null, 'Fracture de l''extrémité supérieure du fémur (ESF) — Thème : Anticoagulant'),
  ('MG-ANES-000033-R08', 'Si la chirurgie est retardée, il est proposé de débuter la thromboprophylaxie en pré-opératoire, en préférant une HBPM et en respectant un délai de 12h entre la dernière injection d''HBPM et la chirurgie.', '2+', null, 'Fracture de l''extrémité supérieure du fémur (ESF) — Thème : Chirurgie retardée'),
  ('MG-ANES-000033-R09', 'Une thromboprophylaxie par anticoagulant (AOD anti-Xa ou HBPM) est recommandée après chirurgie pour ces fractures/ruptures.', '1+', null, 'Fracture diaphyse fémorale, plateau tibial, rotule, tibia, cheville, tendon d''Achille — Thème : Anticoagulant'),
  ('MG-ANES-000033-R10', 'Il est proposé de préférer un AOD anti-Xa à une HBPM (essai PRONOMOS : rivaroxaban plus efficace que l''enoxaparine sans excès hémorragique).', '2+', null, 'Fracture diaphyse fémorale, plateau tibial, rotule, tibia, cheville, tendon d''Achille — Thème : Choix'),
  ('MG-ANES-000033-R11', 'Si l''intervention est prévue plus de 12h après l''hospitalisation, une thromboprophylaxie pré-opératoire par HBPM est proposée (délai 12h avant la chirurgie).', '2+', null, 'Fracture diaphyse fémorale, plateau tibial, rotule, tibia, cheville, tendon d''Achille — Thème : Chirurgie différée'),
  ('MG-ANES-000033-R12', 'Il est proposé de poursuivre jusqu''à l''appui plantaire avec déroulé du pied, durée minimale 7 jours.', '2+', null, 'Fracture diaphyse fémorale, plateau tibial, rotule, tibia, cheville, tendon d''Achille — Thème : Durée'),
  ('MG-ANES-000033-R13', 'Il n''est pas recommandé de prescrire de l''aspirine pour la thromboprophylaxie veineuse.', '1-', null, 'Fracture diaphyse fémorale, plateau tibial, rotule, tibia, cheville, tendon d''Achille — Thème : Aspirine'),
  ('MG-ANES-000033-R14', 'Il est proposé de ne pas prescrire de thromboprophylaxie pharmacologique systématique après ces gestes.', '2-', null, 'Ligamentoplastie du genou, arthroscopie simple, méniscectomie, chir. avant-pied, ablation de matériel — Thème : Pas de systématique'),
  ('MG-ANES-000033-R15', 'Si le patient présente un facteur de risque thromboembolique veineux majeur ou plusieurs facteurs mineurs, une thromboprophylaxie par anticoagulant (AOD anti-Xa ou HBPM) est proposée.', '2+', null, 'Ligamentoplastie du genou, arthroscopie simple, méniscectomie, chir. avant-pied, ablation de matériel — Thème : Si FdR patient'),
  ('MG-ANES-000033-R16', 'Si une thromboprophylaxie pharmacologique est prescrite, une durée de 7 jours minimum est suggérée.', 'AE', null, 'Ligamentoplastie du genou, arthroscopie simple, méniscectomie, chir. avant-pied, ablation de matériel — Thème : Durée si prescrite'),
  ('MG-ANES-000033-R17', 'Après chirurgie abdomino-pelvienne à risque élevé (carcinologique ou non), il est recommandé de prescrire une thromboprophylaxie par HBPM pour une durée de 4 semaines, y compris en cas de chirurgie mini-invasive ou de parcours de RAAC.', '1+', null, 'Chirurgie abdomino-pelvienne (carcinologique ou non) — Thème : Risque élevé — HBPM'),
  ('MG-ANES-000033-R18', 'Il est proposé que le fondaparinux puisse être utilisé en alternative aux HBPM.', '2+', null, 'Chirurgie abdomino-pelvienne (carcinologique ou non) — Thème : Risque élevé — fondaparinux'),
  ('MG-ANES-000033-R19', 'Il est proposé que les AOD anti-Xa puissent être utilisés en relais des HBPM après reprise du transit.', '2+', null, 'Chirurgie abdomino-pelvienne (carcinologique ou non) — Thème : Risque élevé — AOD en relais'),
  ('MG-ANES-000033-R20', 'Il est proposé de prescrire une thromboprophylaxie par HBPM pour une durée minimale de 7 jours.', '2+', null, 'Chirurgie abdomino-pelvienne (carcinologique ou non) — Thème : Risque intermédiaire'),
  ('MG-ANES-000033-R21', 'Il est proposé de ne pas prescrire de thromboprophylaxie pharmacologique systématique. Elle est proposée si le patient présente un facteur de risque majeur, plusieurs facteurs mineurs, une chirurgie prolongée ou une complication post-opératoire.', '2-', null, 'Chirurgie abdomino-pelvienne (carcinologique ou non) — Thème : Risque faible'),
  ('MG-ANES-000033-R22', 'Après chirurgie carcinologique à risque thromboembolique élevé, il est recommandé de prescrire une thromboprophylaxie par HBPM pour une durée minimale de 7 jours.', '1+', null, 'Chirurgie carcinologique (hors abdomino-pelvienne : sein, ORL, poumon…) — Thème : Risque élevé'),
  ('MG-ANES-000033-R23', 'Il est proposé de commencer la thromboprophylaxie pharmacologique en post-opératoire.', '2+', null, 'Chirurgie carcinologique (hors abdomino-pelvienne : sein, ORL, poumon…) — Thème : Délai'),
  ('MG-ANES-000033-R24', 'Il est proposé d''utiliser la CPI en per- et post-opératoire en cas de très haut risque thromboembolique veineux# ou de contre-indication à la thromboprophylaxie pharmacologique.', '2+', null, 'Chirurgie carcinologique (hors abdomino-pelvienne : sein, ORL, poumon…) — Thème : CPI'),
  ('MG-ANES-000033-R25', 'Après chirurgie carotidienne, il est proposé de ne pas prescrire de thromboprophylaxie veineuse systématique.', '2-', null, 'Chirurgie vasculaire — Thème : Carotidienne'),
  ('MG-ANES-000033-R26', 'Après chirurgie aortique abdominale (ouverte ou endoprothèse) ou revascularisation artérielle des membres inférieurs par voie ouverte, il est proposé de prescrire une thromboprophylaxie jusqu''à reprise de la marche.', '2+', null, 'Chirurgie vasculaire — Thème : Aortique / revasc. MI ouverte'),
  ('MG-ANES-000033-R27', 'Après procédure endovasculaire artérielle (angioplastie et/ou endoprothèse) des membres inférieurs, il est proposé de ne pas prescrire de thromboprophylaxie systématique.', '2-', null, 'Chirurgie vasculaire — Thème : Endovasculaire MI'),
  ('MG-ANES-000033-R28', 'Chez un patient éligible au rivaroxaban 2,5 mg x2/j + aspirine 100 mg/j (prévention cardiovasculaire), il est proposé de différer l''introduction du rivaroxaban à la fin de la thromboprophylaxie veineuse par HBPM lorsque celle-ci est indiquée.', '2+', null, 'Chirurgie vasculaire — Thème : Revasc. MI + rivaroxaban'),
  ('MG-ANES-000033-R29', 'Il est proposé de ne pas utiliser de CPI en péri-opératoire de chirurgie de revascularisation artérielle des membres inférieurs (risque d''altération de la perfusion artérielle).', 'AE', null, 'Chirurgie vasculaire — Thème : CPI contre-indiquée'),
  ('MG-ANES-000033-R30', 'Après chirurgie ouverte de varices (stripping), il est proposé de réaliser une thromboprophylaxie de courte durée (≤ 7 jours).', '2+', null, 'Chirurgie vasculaire — Thème : Varices — chirurgie ouverte'),
  ('MG-ANES-000033-R31', 'Après procédure thermique endovasculaire des varices, il est proposé de ne pas prescrire de thromboprophylaxie sauf en cas de facteurs de risque liés au patient.', '2-', null, 'Chirurgie vasculaire — Thème : Varices — endoveineux thermique'),
  ('MG-ANES-000033-R32', 'En chirurgie programmée, lorsqu''une thromboprophylaxie pharmacologique est indiquée, il est proposé d''en administrer la première dose en post-opératoire pour réduire le risque hémorragique.', '2+', null, 'Délai d''introduction de la thromboprophylaxie pharmacologique — Thème : Post-opératoire'),
  ('MG-ANES-000033-R33', 'Il est proposé de débuter la thromboprophylaxie entre la 12e et la 24e heure post-opératoire (le lendemain matin pour la chirurgie programmée).', '2+', null, 'Délai d''introduction de la thromboprophylaxie pharmacologique — Thème : H12-H24'),
  ('MG-ANES-000033-R34', 'En cas de risque thromboembolique veineux élevé lié au patient# les experts proposent de débuter entre la 6e et la 12e heure post-opératoire, en commençant par une HBPM quel que soit l''anticoagulant du lendemain.', 'AE', null, 'Délai d''introduction de la thromboprophylaxie pharmacologique — Thème : H6-H12 si FdR élevé'),
  ('MG-ANES-000033-R35', 'En cas de chirurgie urgente différée de plus de 12h, il est proposé de débuter la thromboprophylaxie en pré-opératoire par une HBPM, en respectant un délai de 12h avant la chirurgie.', '2+', null, 'Délai d''introduction de la thromboprophylaxie pharmacologique — Thème : Chirurgie urgente différée'),
  ('MG-ANES-000033-R36', 'Il est recommandé de respecter les délais minimaux de sécurité entre la thromboprophylaxie pharmacologique et la réalisation de procédures d''ALR neuraxiale.', '1+', null, 'Délai d''introduction de la thromboprophylaxie pharmacologique — Thème : Délais avant ALR'),
  ('MG-ANES-000033-R37', 'Il est recommandé d''utiliser la CPI si une thromboprophylaxie veineuse est indiquée mais que les anticoagulants sont contre-indiqués.', '1+', null, 'Compression pneumatique intermittente (CPI) — Thème : Si AC contre-indiqués'),
  ('MG-ANES-000033-R38', 'En cas de très haut risque thromboembolique veineux§, il est proposé d''associer la CPI en per- et post-opératoire à la thromboprophylaxie pharmacologique.', '2+', null, 'Compression pneumatique intermittente (CPI) — Thème : Très haut risque'),
  ('MG-ANES-000033-R39', 'Il est proposé que l''usage de la CPI ne retarde pas la reprise de la déambulation.', 'AE', null, 'Compression pneumatique intermittente (CPI) — Thème : Déambulation'),
  ('MG-ANES-000033-R40', 'Les contentions élastiques graduées ne sont pas recommandées pour la thromboprophylaxie péri-opératoire, quel que soit le risque thromboembolique veineux.', '1-', null, 'Contentions élastiques graduées — Thème : Non recommandées'),
  ('MG-ANES-000033-R41', 'Il est proposé de ne pas poser de filtre cave pour la thromboprophylaxie veineuse péri-opératoire primaire.', '2-', null, 'Filtre cave — Thème : Prévention primaire'),
  ('MG-ANES-000033-R42', 'Il est proposé de discuter la mise en place d''un filtre cave optionnel en pré-opératoire d''une chirurgie à risque hémorragique lorsque celle-ci doit être réalisée moins d''un mois après une EP et/ou une TVP proximale des membres inférieurs.', '2+', null, 'Filtre cave — Thème : Prévention secondaire — pose'),
  ('MG-ANES-000033-R43', 'Il est recommandé de programmer le retrait du filtre cave dès que le traitement anticoagulant curatif a pu être repris sans complication.', '1+', null, 'Filtre cave — Thème : Retrait'),
  ('MG-ANES-000033-R44', 'Il est recommandé d''adapter les modalités de thromboprophylaxie pharmacologique à la fonction rénale.', '1+', null, 'Insuffisance rénale — Thème : Adapter à la fonction rénale'),
  ('MG-ANES-000033-R45', 'En cas d''insuffisance rénale sévère (DFG estimé 15-30 mL/min/1,73 m²), il est proposé d''utiliser les HBPM en première intention plutôt que l''HNF ou les AOD.', '2+', null, 'Insuffisance rénale — Thème : IR sévère — 1re intention'),
  ('MG-ANES-000033-R46', 'Il est recommandé d''utiliser : enoxaparine 2000 UI x1/j SC si DFG 15-30 ; tinzaparine 4500 UI x1/j SC si DFG > 20.', '1+', null, 'Insuffisance rénale — Thème : IR sévère — schémas AMM'),
  ('MG-ANES-000033-R47', 'En cas d''insuffisance rénale terminale, il est recommandé d''utiliser la calciparine (HNF) 5000 UI x2/j SC, les autres thérapeutiques n''étant pas recommandées.', '1+', null, 'Insuffisance rénale — Thème : IR terminale (DFG <15)'),
  ('MG-ANES-000033-R48', 'Chez les patients présentant une obésité de classe I ou II nécessitant une thromboprophylaxie pharmacologique, il est proposé d''utiliser un schéma posologique standard.', '2+', null, 'Obésité et poids extrêmes — Thème : Classe I-II (IMC 30-39)'),
  ('MG-ANES-000033-R49', 'Il est proposé d''utiliser : enoxaparine 4000 UI x2/j SC (ou 6000 UI x1/j ; 6000 UI x2/j réservé aux patients >150 kg) ; daltéparine 5000 UI x2/j SC ; tinzaparine 75 UI/kg (poids réel) x1/j SC ; fondaparinux 5 mg x1/j SC ; apixaban 2,5 mg x2/j PO ; rivaroxaban 10 mg x1/j PO (peu d''expérience AOD si IMC >50 ou poids >150 kg).', '2+', null, 'Obésité et poids extrêmes — Thème : Classe III+ (IMC ≥40)'),
  ('MG-ANES-000033-R50', 'Il est proposé d''associer une CPI à la thromboprophylaxie pharmacologique.', '2+', null, 'Obésité et poids extrêmes — Thème : Classe III + chirurgie à risque élevé'),
  ('MG-ANES-000033-R51', 'Il est proposé de prescrire une thromboprophylaxie post-opératoire par HBPM ou fondaparinux pour une durée minimale de 10 jours.', '2+', null, 'Obésité et poids extrêmes — Thème : Chirurgie bariatrique'),
  ('MG-ANES-000033-R52', 'Chez les patients de petit poids, il est proposé d''adapter les schémas posologiques (risque d''accumulation et d''hémorragie).', '2+', null, 'Obésité et poids extrêmes — Thème : Petit poids'),
  ('MG-ANES-000033-R53', 'Il est proposé qu''à partir de la puberté ou de l''âge de 14 ans, la thromboprophylaxie pharmacologique réponde aux mêmes recommandations que chez l''adulte.', '2+', 'Pédiatrie', 'Chirurgie pédiatrique — Thème : Dès la puberté / 14 ans'),
  ('MG-ANES-000033-R54', 'Les experts suggèrent que la présence de plusieurs facteurs de risque thromboembolique veineux conduise à discuter au cas par cas le bénéfice-risque d''une thromboprophylaxie pharmacologique.', 'AE', 'Pédiatrie', 'Chirurgie pédiatrique — Thème : Avant la puberté / 14 ans'),
  ('MG-ANES-000033-R55', 'Il est recommandé d''administrer une thromboprophylaxie pharmacologique chez les patients de réanimation pour réduire les complications thromboemboliques veineuses.', '1+', null, 'Patient de réanimation — Thème : Indication'),
  ('MG-ANES-000033-R56', 'En l''absence d''insuffisance rénale terminale, il est recommandé de prescrire des HBPM à doses prophylactiques plutôt que de l''HNF.', '1+', null, 'Patient de réanimation — Thème : HBPM > HNF'),
  ('MG-ANES-000033-R57', 'Lors d''une thromboprophylaxie par HBPM, il est proposé de ne pas monitorer l''activité anti-Xa pour adapter les posologies.', '2-', null, 'Patient de réanimation — Thème : Pas de monitorage anti-Xa'),
  ('MG-ANES-000033-R58', 'Il est proposé d''adapter les posologies d''HBPM chez les patients de petits poids, les obèses de classe III et plus, et en cas d''insuffisance rénale sévère.', '2+', null, 'Patient de réanimation — Thème : Adapter les posologies'),
  ('MG-ANES-000033-R59', 'En cas d''insuffisance rénale sévère stable (DFG 15-30), il est proposé d''utiliser les HBPM en 1re intention selon les schémas AMM (enoxaparine 2000 UI x1/j si DFG 15-30 ; tinzaparine 4500 UI x1/j si DFG >20).', '2+', null, 'Patient de réanimation — Thème : IR sévère stable'),
  ('MG-ANES-000033-R60', 'En cas d''insuffisance rénale terminale (DFG <15), il est recommandé d''utiliser la calciparine 5000 UI x2/j SC.', '1+', null, 'Patient de réanimation — Thème : IR terminale'),
  ('MG-ANES-000033-R61', 'Il n''est pas recommandé d''associer systématiquement une CPI à une thromboprophylaxie pharmacologique.', '1-', null, 'Patient de réanimation — Thème : Pas de CPI systématique associée'),
  ('MG-ANES-000033-R62', 'La CPI est recommandée en cas de contre-indication à une thromboprophylaxie par anticoagulants, en particulier si risque hémorragique élevé.', '1+', null, 'Patient de réanimation — Thème : CPI si contre-indication'),
  ('MG-ANES-000033-R63', 'Les contentions élastiques graduées ne sont pas recommandées, quel que soit le risque thromboembolique veineux.', '1-', null, 'Patient de réanimation — Thème : Contentions non recommandées'),
  ('MG-ANES-000033-R64', 'Il est recommandé de ne pas modifier les modalités de thromboprophylaxie en cas d''administration d''acide tranexamique.', '1-', null, 'Acide tranexamique et thromboprophylaxie veineuse — Thème : Pas de modification'),
  ('MG-ANES-000033-R65', 'Il est proposé de ne pas mesurer l''activité anti-Xa au cours d''une thromboprophylaxie par HBPM.', '2-', null, 'Monitorage biologique — surveillance du niveau d''anticoagulation — Thème : Pas de mesure sous HBPM'),
  ('MG-ANES-000033-R66', 'Les experts proposent de ne pas mesurer le niveau d''anticoagulation au cours d''une prophylaxie par AOD, fondaparinux ou HNF.', 'AE', null, 'Monitorage biologique — surveillance du niveau d''anticoagulation — Thème : Pas de mesure AOD/fondaparinux/HNF'),
  ('MG-ANES-000033-R67', 'Chez les patients de poids extrêmes et les insuffisants rénaux, il est proposé de ne pas mesurer le niveau d''anticoagulation.', '2-', null, 'Monitorage biologique — surveillance du niveau d''anticoagulation — Thème : Poids extrêmes / IR'),
  ('MG-ANES-000033-R68', 'En cas d''hémorragie sous thromboprophylaxie (AOD, HBPM, HNF, fondaparinux), les experts suggèrent de déterminer le niveau d''anticoagulation pour estimer sa contribution à l''hémorragie et aider la prise en charge.*', 'AE', null, 'Monitorage biologique — surveillance du niveau d''anticoagulation — Thème : Si hémorragie'),
  ('MG-ANES-000033-R69', 'Les experts suggèrent d''établir une procédure institutionnelle définissant le bon usage de la mesure du niveau d''anticoagulation (conditions de prélèvement, valeurs seuils) et la prise en charge.', 'AE', null, 'Monitorage biologique — surveillance du niveau d''anticoagulation — Thème : Procédure d''établissement'),
  ('MG-ANES-000033-R70', 'Il est proposé de surveiller la numération plaquettaire pour un dépistage précoce de TIH : sous HBPM, une à deux fois par semaine entre J4 et J14 puis une fois par semaine pendant un mois si le traitement est poursuivi ; sous HNF, deux à trois fois par semaine entre J4 et J14 puis une fois par semaine pendant un mois ; et en cas de survenue d''une thrombose malgré la thromboprophylaxie.', '2+', null, 'Monitorage biologique — surveillance plaquettaire et risque de TIH — Thème : Numération plaquettaire'),
  ('MG-ANES-000033-R71', 'Il est recommandé de ne pas faire de dépistage systématique des TVP asymptomatiques post-opératoires.', '1-', null, 'Découverte d''une thrombose veineuse profonde distale post-opératoire — Thème : Pas de dépistage systématique'),
  ('MG-ANES-000033-R72', 'Il est recommandé de ne pas traiter systématiquement les TVP distales isolées post-opératoires par un anticoagulant à dose curative.', '1-', null, 'Découverte d''une thrombose veineuse profonde distale post-opératoire — Thème : Pas de traitement systématique'),
  ('MG-ANES-000033-R73', 'En cas de TVP distale isolée post-opératoire, il est recommandé d''évaluer le risque d''extension thrombotique (TVPd bilatérale ou multiple, antécédent de MTEV, cancer actif) et le risque hémorragique (patient et procédure) pour décider des modalités thérapeutiques.', '1+', null, 'Découverte d''une thrombose veineuse profonde distale post-opératoire — Thème : Évaluer les risques'),
  ('MG-ANES-000033-R74', 'En l''absence de facteur de risque d''extension, il est proposé d''introduire ou poursuivre la thromboprophylaxie par anticoagulant pendant 35 jours, sans contrôle écho-Doppler.', '2+', null, 'Découverte d''une thrombose veineuse profonde distale post-opératoire — Thème : Sans FdR d''extension'),
  ('MG-ANES-000033-R75', 'Il est proposé d''introduire un traitement anticoagulant à dose curative pendant 6 à 12 semaines.', '2+', null, 'Découverte d''une thrombose veineuse profonde distale post-opératoire — Thème : FdR extension + risque hémorragique faible'),
  ('MG-ANES-000033-R76', 'Les experts proposent d''introduire ou poursuivre la thromboprophylaxie pendant 6 à 12 semaines (contrôle écho-Doppler possible à J7 ; passage à dose curative si le risque hémorragique diminue).', 'AE', null, 'Découverte d''une thrombose veineuse profonde distale post-opératoire — Thème : FdR extension + risque hémorragique élevé'),
  ('MG-ANES-000033-R77', 'En cas de contre-indication à un traitement anticoagulant préventif, il est proposé de ne pas anticoaguler, de ne pas poser de filtre cave, et de contrôler l''écho-Doppler à J7 (recherche d''extension proximale).', '2-', null, 'Découverte d''une thrombose veineuse profonde distale post-opératoire — Thème : Anticoagulant contre-indiqué')
) as v(code, statement, grade, population, source_section)
where d.source_url = 'https://sfar.org/prevention-de-la-maladie-thromboembolique-veineuse-peri-operatoire/'
on conflict (recommendation_code) do nothing;
