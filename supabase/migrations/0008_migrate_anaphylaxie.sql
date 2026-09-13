-- Migration : Diagnostic et prise en charge des réactions d'hypersensibilité immédiate
-- périopératoires (anaphylaxie péri-opératoire) — SFAR/SFA, RFE 2025
-- Source : rfe-sfar-website/build/content_anaphylaxie.json (62 recommandations atomiques :
-- 61 lignes de tableaux "Réf. | Recommandation | Grade" + R4.1, seule recommandation
-- graduée du document noyée dans un paragraphe de prose plutôt qu'un tableau — repérée par
-- recherche exhaustive de tous les repères "Rx.y" du texte source, pas seulement les
-- tableaux, avant d'écrire ce script).
--
-- La RFE source compte 70 recommandations au total (6 Grade 1, 16 Grade 2, 48 avis
-- d'experts) sur 4 champs ; cette fiche reproduit intégralement les champs 1
-- (bilan diagnostique), 2 (facteurs de risque) et 4 (traitement), plus R3.4/R3.5 du champ 3
-- (chirurgie urgente chez un patient rapportant une HSI non explorée) — le reste du champ 3
-- (prévention programmée au-delà de R3.4/R3.5) N'EST PAS repris par le contenu construit
-- (le déclare lui-même explicitement), donc pas migré ici : 62/70 recommandations de la RFE
-- migrées, 8 restantes hors du périmètre de cette fiche.
--
-- Grade : reproduit tel quel depuis le chip source (1+/1-/2+/2-/AE, méthodologie GRADE
-- classique, même légende que anemie/0007). evidence_level laissé NULL : pas de système de
-- niveau de preuve distinct du grade dans ce document.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. `library_final.json` titre le document "Diagnostic et prise en charge des réactions
--    d'hypersensibilité immédiate périopératoires" (utilisé ci-dessous comme titre canonique
--    de `documents.title`), le contenu construit cite lui-même une formulation légèrement
--    différente dans son panneau "Document source" ("Prise en charge de l'hypersensibilité
--    immédiate péri-opératoire (anaphylaxie péri-opératoire)") — même document, deux
--    libellés de titre, pas une divergence de fond, mais disclosure quand même.
-- 2. SFA (Société Française d'Allergologie, co-autrice avec la SFAR) ne figure pas dans le
--    seed Annexe B (societies) : seule SFAR est liée en document_societies ci-dessous, même
--    cas de figure que allergie_prevention (0006), sa fiche compagnon.
-- 3. Les annexes purement instrumentales citées par le contenu construit mais non
--    reproduites intégralement (Annexe 1 — score ISPAR complet, Annexe 4 — concentrations
--    détaillées des tests cutanés, Annexe 8 — arbre décisionnel bilan négatif) ne portent
--    de toute façon aucune recommandation graduée propre (ce sont des outils/tableaux de
--    référence cités par certaines recommandations, R1.9.2 notamment) : rien n'est omis
--    d'atomique ici, seulement du matériel instrumental non gradé.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Diagnostic et prise en charge des réactions d''hypersensibilité immédiate périopératoires',
  'RFE', 'fr', '2025-03-04',
  'https://sfar.org/download/diagnostic-et-prise-en-charge-des-reactions-dhypersensibilite-immediate-perioperatoires/?wpdmdl=103153',
  'https://sfar.org/download/diagnostic-et-prise-en-charge-des-reactions-dhypersensibilite-immediate-perioperatoires/?wpdmdl=103153',
  'GRADE : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ proposé / 2- proposé de ne pas faire) ; avis d''experts (AE) lorsque la littérature ne permettait pas de graduer. 70 recommandations au total dans la RFE (6 Grade 1, 16 Grade 2, 48 avis d''experts).',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/download/diagnostic-et-prise-en-charge-des-reactions-dhypersensibilite-immediate-perioperatoires/?wpdmdl=103153'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/download/diagnostic-et-prise-en-charge-des-reactions-dhypersensibilite-immediate-perioperatoires/?wpdmdl=103153'
  and s.slug in ('anesthesie_reanimation', 'allergologie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/download/diagnostic-et-prise-en-charge-des-reactions-dhypersensibilite-immediate-perioperatoires/?wpdmdl=103153',
  'draft'
from public.documents d, (values
  ('MG-ANES-000008-R01', 'Il est probablement recommandé de se fonder sur la suspicion clinique d''HSI plutôt que sur l''utilisation de scores cliniques (score ISPAR), pour adresser le patient en consultation d''allergo-anesthésie.', '2+', 'Champ 1 (1/4) — Scores diagnostiques & imputabilité (R1.1)'),
  ('MG-ANES-000008-R02', 'Considérer les caractéristiques cliniques de la réaction, le type de substance, la voie d''exposition et le délai entre l''exposition et la réaction, pour évaluer le degré d''imputabilité à une substance donnée.', 'AE', 'Champ 1 (1/4) — Scores diagnostiques & imputabilité (R1.2)'),
  ('MG-ANES-000008-R03', 'Effectuer au moins deux dosages de tryptase pour identifier une activation mastocytaire : 1er dosage entre 30 min et 2h après le début des symptômes (pic) ; 2ème dosage au moins 24h après la résolution des symptômes (taux basal).', '1+', 'Champ 1 (2/4) — Tryptase, histamine (R1.3.1)'),
  ('MG-ANES-000008-R04', 'Se baser sur une augmentation de la tryptasémie selon une formule prenant en compte le taux basal (ex. tryptase aiguë > 1,2 × tryptase basale + 2 µg/L) pour définir une activation mastocytaire.', '2+', 'Champ 1 (2/4) — Tryptase, histamine (R1.3.2)'),
  ('MG-ANES-000008-R05', 'Ne pas prendre en compte les résultats des dosages de tryptasémie pour décider d''adresser le patient en consultation d''allergo-anesthésie.', 'AE', 'Champ 1 (2/4) — Tryptase, histamine (R1.3.3)'),
  ('MG-ANES-000008-R06', 'Réaliser le dosage de l''histamine plasmatique à la phase aiguë (< 30 min après la réaction), dans les centres ayant la capacité de le réaliser en respectant les conditions pré-analytiques, pour améliorer la performance diagnostique.', '2+', 'Champ 1 (2/4) — Tryptase, histamine (R1.4)'),
  ('MG-ANES-000008-R07', 'Doser la tryptase et l''histamine pendant, ou au plus tard à l''arrêt des manœuvres de réanimation cardio-pulmonaire, pour apporter des arguments en faveur du caractère anaphylactique de la réaction (suspicion de décès par anaphylaxie).', '2+', 'Champ 1 (2/4) — Tryptase, histamine (R1.5)'),
  ('MG-ANES-000008-R08', 'Doser les IgE spécifiques vis-à-vis des allergènes suspects, incluant en 1ère intention les IgE spécifiques des ammoniums quaternaires, du latex et de la chlorhexidine, pour orienter le bilan diagnostique.', '2+', 'Champ 1 (3/4) — IgE spécifiques, test d''activation des basophiles, concertation (R1.6.1)'),
  ('MG-ANES-000008-R09', 'Réaliser les dosages d''IgE spécifiques sériques dès que possible, sans délai minimal par rapport à la réaction, pour améliorer le rendement diagnostique.', 'AE', 'Champ 1 (3/4) — IgE spécifiques, test d''activation des basophiles, concertation (R1.6.2)'),
  ('MG-ANES-000008-R10', 'Réaliser un test d''activation des basophiles (TAB) en 2ème intention lors du bilan allergologique, pour améliorer la performance diagnostique.', 'AE', 'Champ 1 (3/4) — IgE spécifiques, test d''activation des basophiles, concertation (R1.7.1)'),
  ('MG-ANES-000008-R11', 'Respecter un délai minimal de 4 jours après la réaction avant de réaliser un TAB, pour améliorer la sensibilité du bilan.', 'AE', 'Champ 1 (3/4) — IgE spécifiques, test d''activation des basophiles, concertation (R1.7.2)'),
  ('MG-ANES-000008-R12', 'Mettre en place une concertation multidisciplinaire (allergologue, anesthésiste-réanimateur, biologiste) pour prendre en charge les patients suspects d''une réaction d''HSI péri-opératoire, afin d''améliorer la qualité du diagnostic et le conseil pour les anesthésies ultérieures.', '2+', 'Champ 1 (3/4) — IgE spécifiques, test d''activation des basophiles, concertation (R1.8)'),
  ('MG-ANES-000008-R13', 'Réaliser des tests cutanés avec l''ensemble des substances auxquelles le patient a été exposé avant la réaction, pour identifier le ou les agent(s) responsable(s).', '1+', 'Champ 1 (4/4) — Tests cutanés, tests de provocation, bilan négatif, cas particuliers (R1.9.1)'),
  ('MG-ANES-000008-R14', 'Réaliser les tests cutanés aux concentrations recommandées (cf. Annexe 4) afin d''éviter le risque de faux positifs.', '1+', 'Champ 1 (4/4) — Tests cutanés, tests de provocation, bilan négatif, cas particuliers (R1.9.2)'),
  ('MG-ANES-000008-R15', 'Si les tests cutanés sont positifs au curare auquel le patient a été exposé, tester tous les autres curares disponibles pour identifier les sensibilisations croisées.', '2+', 'Champ 1 (4/4) — Tests cutanés, tests de provocation, bilan négatif, cas particuliers (R1.9.3)'),
  ('MG-ANES-000008-R16', 'Respecter un délai minimal de 4 semaines après la résolution de la réaction avant de réaliser les tests cutanés, afin d''en améliorer la sensibilité.', 'AE', 'Champ 1 (4/4) — Tests cutanés, tests de provocation, bilan négatif, cas particuliers (R1.9.4)'),
  ('MG-ANES-000008-R17', 'En cas de nouvelle intervention urgente, réaliser les tests cutanés dès le 4ème jour mais ne considérer que les résultats positifs ; si négatifs, les renouveler à partir de 4 semaines après la réaction.', 'AE', 'Champ 1 (4/4) — Tests cutanés, tests de provocation, bilan négatif, cas particuliers (R1.9.5)'),
  ('MG-ANES-000008-R18', 'Ne pas réaliser de manière systématique un test de provocation (TP) aux agents anesthésiques intraveineux, pour limiter le risque lié à leur usage.', 'AE', 'Champ 1 (4/4) — Tests cutanés, tests de provocation, bilan négatif, cas particuliers (R1.10.1)'),
  ('MG-ANES-000008-R19', 'Réaliser un TP aux anesthésiques généraux uniquement lorsque le bilan bien conduit n''a pas identifié la substance en cause et que les éléments clinico-biologiques sont très en faveur d''une HSI péri-opératoire.', 'AE', 'Champ 1 (4/4) — Tests cutanés, tests de provocation, bilan négatif, cas particuliers (R1.10.2)'),
  ('MG-ANES-000008-R20', 'Réaliser les TP aux anesthésiques généraux dans des centres experts en allergo-anesthésie, après concertation multidisciplinaire, sous surveillance d''un médecin anesthésiste-réanimateur, selon des protocoles validés localement.', 'AE', 'Champ 1 (4/4) — Tests cutanés, tests de provocation, bilan négatif, cas particuliers (R1.10.3)'),
  ('MG-ANES-000008-R21', 'Bilan négatif et probabilité clinique faible : autoriser la réutilisation des médicaments initialement suspectés, pour limiter la morbidité liée aux alternatives.', 'AE', 'Champ 1 (4/4) — Tests cutanés, tests de provocation, bilan négatif, cas particuliers (R1.11.1)'),
  ('MG-ANES-000008-R22', 'Substance identifiée et autres molécules testées négatives : autoriser la réutilisation des autres molécules, y compris les curares.', 'AE', 'Champ 1 (4/4) — Tests cutanés, tests de provocation, bilan négatif, cas particuliers (R1.11.2)'),
  ('MG-ANES-000008-R23', 'Bilan négatif, probabilité clinique élevée et/ou activation mastocytaire prouvée : décision au cas par cas, en revérifiant l''exhaustivité du dossier avec l''équipe présente (diagnostics différentiels, allergènes « cachés », recherche d''un désordre mastocytaire).', 'AE', 'Champ 1 (4/4) — Tests cutanés, tests de provocation, bilan négatif, cas particuliers (R1.11.3)'),
  ('MG-ANES-000008-R24', 'Chez l''enfant : conduire le bilan allergologique de manière similaire à l''adulte.', '2+', 'Champ 1 (4/4) — Tests cutanés, tests de provocation, bilan négatif, cas particuliers (R1.12.1)'),
  ('MG-ANES-000008-R25', 'Chez la femme enceinte : réaliser les tests cutanés de manière similaire pour les anesthésiques généraux et locaux.', '2+', 'Champ 1 (4/4) — Tests cutanés, tests de provocation, bilan négatif, cas particuliers (R1.12.2)'),
  ('MG-ANES-000008-R26', 'Chez la parturiente en début de travail, suspicion d''HSI aux anesthésiques locaux non explorée ou tests douteux : réaliser un test de réintroduction en présence d''un médecin anesthésiste-réanimateur, après évaluation bénéfice/risque.', 'AE', 'Champ 1 (4/4) — Tests cutanés, tests de provocation, bilan négatif, cas particuliers (R1.12.3)'),
  ('MG-ANES-000008-R27', 'Rechercher systématiquement en consultation d''anesthésie au moins un facteur de risque (hypersensibilité suspectée à un médicament de l''anesthésie, hypersensibilité ancienne à un médicament dont de nouvelles molécules de la même classe sont apparues depuis, réaction inexpliquée lors d''une précédente anesthésie, réaction à la viande de mammifère [alpha-gal], réaction suspectée au latex) pour adresser en consultation d''allergo-anesthésie.', 'AE', 'Champ 2 (1/2) — Facteurs de risque généraux & latex (R2.1)'),
  ('MG-ANES-000008-R28', 'Rechercher systématiquement les signes cliniques évocateurs d''allergie au latex (réaction au préservatif, ballons, etc.) ou les facteurs de risque de sensibilisation (allergie alimentaire du groupe latex, Tableau 4).', '2+', 'Champ 2 (1/2) — Facteurs de risque généraux & latex (R2.2)'),
  ('MG-ANES-000008-R29', 'Ne pas retenir le diagnostic d''allergie aux bêtalactamines si l''histoire rapportée repose sur un antécédent familial, la prise ultérieure du même antibiotique sans réaction, ou une clinique non évocatrice (troubles digestifs isolés).', 'AE', 'Bêtalactamines & céfazoline (R2.3.1)'),
  ('MG-ANES-000008-R30', 'Éruption cutanée isolée avant 6 ans, sans signe de gravité, suite à une pénicilline : autoriser la céfazoline en antibioprophylaxie.', 'AE', 'Bêtalactamines & céfazoline (R2.3.2)'),
  ('MG-ANES-000008-R31', 'Ne pas utiliser des scores cliniques (ex. PEN-FAST) pour décider de l''administration d''une bêtalactamine en antibioprophylaxie chez un patient rapportant une allergie aux pénicillines.', 'AE', 'Bêtalactamines & céfazoline (R2.3.3)'),
  ('MG-ANES-000008-R32', 'Il n''est probablement pas recommandé d''exclure les curares chez les patients ayant consommé un sirop de pholcodine dans l''année précédant l''anesthésie.', '2-', 'Champ 2 (2/2) — Pholcodine, dépistage systématique, mastocytose (R2.4.1)'),
  ('MG-ANES-000008-R33', 'Il n''est probablement pas recommandé de réaliser un bilan allergo-anesthésique chez ces patients, pour limiter la morbidité liée à l''exclusion des curares.', '2-', 'Champ 2 (2/2) — Pholcodine, dépistage systématique, mastocytose (R2.4.2)'),
  ('MG-ANES-000008-R34', 'En l''absence de facteur de risque (cf. R2.1), il n''est pas recommandé de réaliser un bilan allergo-anesthésique de dépistage.', '1-', 'Champ 2 (2/2) — Pholcodine, dépistage systématique, mastocytose (R2.5)'),
  ('MG-ANES-000008-R35', 'En cas de mastocytose systémique : adapter la stratégie anesthésique, prémédication systématique par anti-H1 et éviction des substances histaminolibératrices (Tableau 5).', 'AE', 'Champ 2 (2/2) — Pholcodine, dépistage systématique, mastocytose (R2.6.1)'),
  ('MG-ANES-000008-R36', 'En cas de mastocytose, SAMA ou alpha-tryptasémie héréditaire : approche pluridisciplinaire (anesthésistes-réanimateurs, chirurgiens, allergologues, spécialiste référent) avant l''intervention, pour évaluer individuellement le risque péri-opératoire.', 'AE', 'Champ 2 (2/2) — Pholcodine, dépistage systématique, mastocytose (R2.6.2)'),
  ('MG-ANES-000008-R37', 'Les experts suggèrent d''utiliser l''échelle de Ring & Messmer modifiée pour guider la prise en charge initiale, afin de réduire la morbi-mortalité de la réaction. Classification retenue par l''OMS dans la CIM-11.', 'AE', 'Champ 4 (1/4) — Classification de gravité (R4.1)'),
  ('MG-ANES-000008-R38', 'Considérer une baisse de l''EtCO2 comme signe précoce dans les réactions sévères lorsque le patient est ventilé de manière invasive (seuils rapportés : chute sous 20-25 mmHg évocatrice d''un grade III/IV), afin de réduire la morbi-mortalité de la réaction.', '2+', 'Détection précoce (R4.2)'),
  ('MG-ANES-000008-R39', 'Injecter de l''adrénaline sans délai pour les réactions de grade II à IV, afin de réduire la morbi-mortalité de la réaction.', 'AE', 'Adrénaline — traitement de première intention (R4.3.1)'),
  ('MG-ANES-000008-R40', 'Ne pas utiliser la noradrénaline en 1ère intention à la place de l''adrénaline.', 'AE', 'Adrénaline — traitement de première intention (R4.3.2)'),
  ('MG-ANES-000008-R41', 'Titrer l''adrénaline en intraveineux, avec un monitorage continu comportant au minimum un suivi électrocardioscopique et la mesure automatisée de la pression artérielle.', 'AE', 'Adrénaline — traitement de première intention (R4.3.3)'),
  ('MG-ANES-000008-R42', 'Grade II : titration IV 10 à 20 µg chez l''adulte, 1 µg/kg chez l''enfant (max 10 µg), toutes les 2 minutes.', 'AE', 'Adrénaline — traitement de première intention (R4.3.4)'),
  ('MG-ANES-000008-R43', 'Grade III : titration IV 100 à 200 µg chez l''adulte, au minimum 1 µg/kg (jusqu''à 5-10 µg/kg, max 100 µg) chez l''enfant, toutes les 2 minutes.', 'AE', 'Adrénaline — traitement de première intention (R4.3.5)'),
  ('MG-ANES-000008-R44', 'Grade IV : respecter les recommandations internationales sur l''adrénaline en arrêt cardiorespiratoire, en considérant son administration précoce.', 'AE', 'Adrénaline — traitement de première intention (R4.3.6)'),
  ('MG-ANES-000008-R45', 'Grade III-IV, instabilité hémodynamique persistante malgré 3 bolus IV : débuter une adrénaline IV continue, débit initial 0,05-0,1 µg/kg/min, ajusté selon la réponse clinique.', 'AE', 'Adrénaline — traitement de première intention (R4.3.7)'),
  ('MG-ANES-000008-R46', 'Adrénaline IM (face antérolatérale de la cuisse, 10 µg/kg jusqu''à 500 µg/dose, grades II-III) uniquement en l''absence de monitorage et/ou d''accès veineux.', 'AE', 'Adrénaline — traitement de première intention (R4.3.8)'),
  ('MG-ANES-000008-R47', 'Chez la femme enceinte : mêmes doses que les autres adultes, en y associant le déplacement de l''utérus sur la gauche à partir de 20 SA pour améliorer le retour veineux.', 'AE', 'Adrénaline — traitement de première intention (R4.3.9)'),
  ('MG-ANES-000008-R48', 'Grade II ou plus : réaliser systématiquement un remplissage vasculaire à débit élevé, en association au traitement par adrénaline.', '1+', 'Remplissage vasculaire (R4.4.1)'),
  ('MG-ANES-000008-R49', 'Volume minimal : 10 ml/kg (grade II) ou 20 ml/kg (grades III-IV), dans les 30 minutes suivant le début de la réaction.', 'AE', 'Remplissage vasculaire (R4.4.2)'),
  ('MG-ANES-000008-R50', 'En l''absence de stabilisation hémodynamique après le remplissage initial : réaliser dès que possible une échographie cardiaque et/ou un monitorage du débit cardiaque pour guider la poursuite du remplissage.', 'AE', 'Remplissage vasculaire (R4.4.3)'),
  ('MG-ANES-000008-R51', 'Cristalloïde isotonique en 1ère intention ; colloïde seulement si hypovolémie persistante malgré ≥ 20 ml/kg de cristalloïdes.', 'AE', 'Remplissage vasculaire (R4.4.4)'),
  ('MG-ANES-000008-R52', 'Vasoplégie intense persistante malgré adrénaline + remplissage (après exclusion d''une hypovolémie persistante et/ou d''une dysfonction myocardique) : associer noradrénaline, OU bleu de méthylène (1,5-3 mg/kg sur 20-30 min, CI si déficit en G6PD), OU argipressine (0,01 UI/min soit 0,6 UI/h, majoration toutes les 15-20 min jusqu''à 0,03 UI/min soit 1,8 UI/h) — selon expertise et disponibilité locale.', 'AE', 'Anaphylaxie réfractaire (R4.5.1)'),
  ('MG-ANES-000008-R53', 'Arrêt cardio-respiratoire lié à l''anaphylaxie : considérer l''ECLS (Extracorporeal Life Support) dans les centres qui y ont accès.', 'AE', 'Anaphylaxie réfractaire (R4.5.2)'),
  ('MG-ANES-000008-R54', 'Ne pas utiliser le sugammadex en traitement de l''HSI réfractaire suspecte d''être liée au rocuronium.', 'AE', 'Anaphylaxie réfractaire (R4.5.3)'),
  ('MG-ANES-000008-R55', 'Anaphylaxie stabilisée après prise en charge initiale, après concertation pluridisciplinaire si réaction sévère : il n''est probablement pas recommandé d''interrompre systématiquement l''intervention, pour limiter la morbidité liée au report ou à une nouvelle anesthésie.', '2-', 'Poursuivre ou interrompre la chirurgie ? (R4.6) — orientation post-réaction (R4.6.1)'),
  ('MG-ANES-000008-R56', 'En cas de poursuite de l''intervention : ne pas réutiliser les classes pharmacologiques suspectées d''être à l''origine de la réaction.', 'AE', 'Poursuivre ou interrompre la chirurgie ? (R4.6) — orientation post-réaction (R4.6.2)'),
  ('MG-ANES-000008-R57', 'En cas de poursuite de l''intervention : passer systématiquement en environnement sans latex et changer la classe d''antiseptique.', 'AE', 'Poursuivre ou interrompre la chirurgie ? (R4.6) — orientation post-réaction (R4.6.3)'),
  ('MG-ANES-000008-R58', 'Surveiller en structure de soins critiques (ou SSPI prolongée) en cas de réaction sévère (grade III-IV), notamment si l''adrénaline doit être poursuivie ou en cas de défaillance d''organe persistante.', 'AE', 'Poursuivre ou interrompre la chirurgie ? (R4.6) — orientation post-réaction (R4.7.1)'),
  ('MG-ANES-000008-R59', 'Si admission en soins critiques ou SSPI prolongée : surveiller au moins 24 h après la résolution complète des symptômes.', 'AE', 'Poursuivre ou interrompre la chirurgie ? (R4.6) — orientation post-réaction (R4.7.2)'),
  ('MG-ANES-000008-R60', 'Intervention urgente, réaction d''HSI non explorée lors d''une précédente anesthésie locale ou locorégionale : éviction des anesthésiques locaux (AL) du même groupe, ou privilégier une anesthésie générale si le protocole antérieur est inconnu.', 'AE', 'Chirurgie urgente chez un patient rapportant une HSI non explorée (R3.4, R3.5) (R3.4.1)'),
  ('MG-ANES-000008-R61', 'Intervention urgente, notion d''HSI non explorée aux AL, balance bénéfice-risque très en faveur d''une anesthésie locale/locorégionale : réaliser un test de réintroduction aux AL plutôt que d''imposer une anesthésie générale.', 'AE', 'Chirurgie urgente chez un patient rapportant une HSI non explorée (R3.4, R3.5) (R3.4.2)'),
  ('MG-ANES-000008-R62', 'Il n''est probablement pas recommandé de prescrire systématiquement une prémédication (antihistaminiques, corticoïdes) aux patients à risque de réaction d''HSI périopératoire (hors mastocytose).', '2-', 'Chirurgie urgente chez un patient rapportant une HSI non explorée (R3.4, R3.5) (R3.5)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/download/diagnostic-et-prise-en-charge-des-reactions-dhypersensibilite-immediate-perioperatoires/?wpdmdl=103153'
on conflict (recommendation_code) do nothing;
