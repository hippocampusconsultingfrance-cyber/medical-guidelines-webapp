-- Migration : Prise en charge des patients présentant un traumatisme
-- crânien léger de l'adulte — Recommandations de Pratiques Professionnelles
-- de la SFMU, en association avec la SFAR, avec SFBC, SFR, SOFMER. 2022,
-- texte validé par la Commission des Référentiels de la SFMU (19/05/2022),
-- le CA SFMU (24/05/2022), le Comité des Référentiels Cliniques SFAR
-- (03/09/2022), le CA SFAR (15/09/2022). Comité de 22 experts, coordination
-- C. Gil-Jardiné (SFMU), J-F. Payen (SFAR). Source :
-- rfe-sfar-website/build/content_traumatisme_cranien_leger.json (14
-- énoncés individuellement formulés selon le cadre PICO propre du texte,
-- répartis en 3 champs : évaluation pré-hospitalière, prise en charge aux
-- urgences, modalités de sortie).
--
-- CHAMP DE LA SOURCE : patients adultes pris en charge en structure de
-- médecine d'urgence dans les 24h suivant un TC non pénétrant, GCS initial
-- 13-15 (définition OMS 2004, Tableau 1 non migré — outil de référence
-- diagnostique).
--
-- MÉTHODOLOGIE — FORMAT RPP, PAS DE GRADE NUMÉRIQUE : choix méthodologique
-- explicite de la source (« format RPP plutôt que RFE, faute de niveau de
-- preuve suffisant pour la méthode GRADE numérique ») — AUCUNE
-- recommandation de ce document ne porte de grade « 1/2 » ; toutes portent
-- le tag littéral unique « Avis d'experts (Accord Fort) ». `grade = 'AE'`
-- sur toutes les lignes migrées, jamais un grade GRADE inventé.
-- `evidence_level` laissé NULL.
--
-- COMPTAGE — DIVERGENCE DISCLOSÉE PAR LE CONTENU CONSTRUIT LUI-MÊME, NON
-- RÉSOLUE : le résumé officiel de la source annonce « 13 recommandations »,
-- mais un inventaire direct des énoncés individuellement formulés selon le
-- cadre PICO du texte (R1, R2.1, R2.2.1-2, R2.3, R2.4, R2.5, R2.6.1-3,
-- R2.7, R2.8, R3.1, R3.2) en dénombre 14 — le contenu construit précise
-- lui-même que « le chiffre "13" est cité tel quel dans l'introduction sans
-- être recalculé, la source ne détaillant pas la correspondance exacte
-- avec le découpage par énoncé individuel ». Les 14 énoncés réellement
-- présents dans le JSON de build sont tous migrés, aucun retranché pour
-- forcer une correspondance à "13".
--
-- NUMÉROTATION SOURCE — INTERVERTISSEMENT DISCLOSÉ, REPRODUIT FIDÈLEMENT :
-- R2.4 (délai de la TDM) est littéralement imprimé sous la Question 2.3,
-- et R2.3 (Doppler transcrânien) est littéralement imprimé sous la
-- Question 2.4 dans le document source lui-même — anomalie propre à la
-- source, conservée telle quelle (pas une correction de ma part).
--
-- PÉRIMÈTRE — volontairement pas migrés : Tableau 1 (définition OMS 2004
-- du TCL, référence diagnostique) ; Tableaux 2-3 (signes de fracture,
-- éléments de cinétique élevée — critères de référence déjà cités inline
-- dans R2.1) ; le panneau « Absence de recommandation » (prise en charge
-- des inhibiteurs P2Y12 — clopidogrel/prasugrel/ticagrelor — faute de
-- données suffisantes, cohérent avec le principe du projet) ; l'Annexe 1
-- (comparatif de 7 scores cliniques internationaux, non reproduite
-- intégralement par le contenu construit lui-même : "tableau multi-
-- colonnes à l'extraction disloquée", disclosure de la source) ; l'Annexe
-- 2 (fiche d'information de sortie patient — contenu informationnel
-- destiné au patient, pas une recommandation graduée pour le clinicien).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFMU et SFAR (toutes deux dans le seed Annexe B) liées en
--    document_societies ; SFBC, SFR et SOFMER (co-auteurs) hors seed, non
--    liées.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge des patients présentant un traumatisme crânien léger de l''adulte',
  'RPP', 'fr', '2022-09-15',
  'https://sfar.org/prise-en-charge-des-patients-presentant-un-traumatisme-cranien-leger-de-ladulte/',
  'https://sfar.org/download/prise-en-charge-des-patients-presentant-un-traumatisme-cranien-leger-de-ladulte/?wpdmdl=37891',
  'Format RPP (pas de grade GRADE numérique) : choix méthodologique explicite de la source faute de niveau de preuve suffisant. Toutes les recommandations portent le tag littéral unique "Avis d''experts (Accord Fort)". Comptage source ("13 recommandations") vs inventaire direct des 14 énoncés PICO individuellement formulés — divergence disclosée par le contenu construit lui-même ("13" cité tel quel sans détail de correspondance), non résolue ; les 14 énoncés réels sont tous migrés.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-des-patients-presentant-un-traumatisme-cranien-leger-de-ladulte/'
  and s.acronym in ('SFMU', 'SFAR') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-des-patients-presentant-un-traumatisme-cranien-leger-de-ladulte/'
  and s.slug in ('medecine_d_urgence', 'anesthesie_reanimation', 'neurologie', 'radiologie_et_imagerie_medicale')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/prise-en-charge-des-patients-presentant-un-traumatisme-cranien-leger-de-ladulte/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000052-R01', 'Les experts proposent que les patients victimes d''un traumatisme crânien léger, pour lesquels la régulation médicale est sollicitée, ne soient pas orientés de façon systématique vers une structure des urgences s''ils peuvent être surveillés par une tierce personne, en l''absence de : trouble de coagulation préexistant (dont traitement anticoagulant) ; âge > 65 ans ET traitement par antiplaquettaire(s) ; intoxication (médicamenteuse, alcool, autre) ; symptômes en dehors de céphalées (vomissement, perte de connaissance, amnésie > 30 min, convulsion, déficit focalisé, altération de la vigilance) ; signe de traumatisme (hématome en lunettes, embarrure, signes de fracture de la base du crâne, hématome mastoïdien).', 'AE', 'Champ 1 — Évaluation pré-hospitalière (Réf. R1)'),
  ('MG-ANES-000052-R02', 'Les experts proposent de stratifier le risque d''aggravation clinique ou de lésion intracrânienne selon la classification suivante — Risque élevé : troubles de l''hémostase (anticoagulants, bithérapie antiplaquettaire, maladie hémorragique congénitale) ; signes de fracture de la voûte ou de la base du crâne ; GCS < 15 à 2h du traumatisme sans intoxication ; plus d''un épisode de vomissements ; convulsions post-traumatiques ; déficit neurologique focalisé. Risque intermédiaire : âge ≥ 65 ans avec mono-antiagrégation plaquettaire ; GCS < 15 à 2h du traumatisme avec intoxication ; traumatisme à cinétique élevée ; amnésie des faits survenus plus de 30 min avant le traumatisme.', 'AE', 'Champ 2 — Éléments cliniques à risque & biomarqueurs (Réf. R2.1)'),
  ('MG-ANES-000052-R03', 'Les experts proposent de réaliser un dosage sanguin de la protéine S100B, lorsque celui-ci est disponible, dans les 3h suivant le traumatisme, chez les patients à risque intermédiaire (cf. R2.1) pour limiter le nombre de scanners cérébraux.', 'AE', 'Champ 2 — Éléments cliniques à risque & biomarqueurs (Réf. R2.2.1)'),
  ('MG-ANES-000052-R04', 'Les experts proposent de réaliser un dosage sanguin combinant UCH-L1 et GFAP, lorsque ceux-ci sont disponibles, dans les 12h suivant le traumatisme, chez les patients à risque intermédiaire (cf. R2.1) pour limiter le nombre de scanners cérébraux.', 'AE', 'Champ 2 — Éléments cliniques à risque & biomarqueurs (Réf. R2.2.2)'),
  ('MG-ANES-000052-R05', 'Les experts proposent de réaliser une TDM cérébrale le plus précocement possible pour identifier les lésions intracrâniennes significatives, chez les patients présentant un TCL : idéalement dans l''heure suivant l''admission pour les patients à risque élevé d''aggravation clinique ou de lésion intracrânienne ; au plus tard dans les 8 heures pour les patients à risque intermédiaire.', 'AE', 'Champ 2 — Délai de la TDM & Doppler transcrânien (Réf. R2.4, numérotation source intervertie avec R2.3, conservée fidèlement)'),
  ('MG-ANES-000052-R06', 'Les experts proposent de réaliser, après un scanner cérébral anormal, un Doppler Transcrânien chez les patients traumatisés crâniens légers pour évaluer le risque d''aggravation neurologique précoce.', 'AE', 'Champ 2 — Délai de la TDM & Doppler transcrânien (Réf. R2.3, numérotation source intervertie avec R2.4, conservée fidèlement)'),
  ('MG-ANES-000052-R07', 'Les experts proposent de ne pas réaliser d''imagerie de contrôle aux patients présentant une lésion intracrânienne sur la TDM initiale, en dehors des situations suivantes : aggravation neurologique ; patient âgé de plus de 65 ans ; troubles de l''hémostase, en dehors de la prise d''aspirine seule.', 'AE', 'Champ 2 — Imagerie de contrôle & réversion des anticoagulants (Réf. R2.5)'),
  ('MG-ANES-000052-R08', 'Les experts proposent de réaliser une réversion immédiate des anti-vitamine K chez les patients présentant une lésion hémorragique intracrânienne objectivée par une imagerie après un TCL, pour limiter le risque d''aggravation neurologique.', 'AE', 'Champ 2 — Imagerie de contrôle & réversion des anticoagulants (Réf. R2.6.1)'),
  ('MG-ANES-000052-R09', 'Les experts proposent de réaliser une réversion immédiate des anticoagulants oraux directs chez les patients présentant une lésion hémorragique intracrânienne objectivée par une imagerie après un TCL, pour limiter le risque d''aggravation neurologique.', 'AE', 'Champ 2 — Imagerie de contrôle & réversion des anticoagulants (Réf. R2.6.2)'),
  ('MG-ANES-000052-R10', 'Les experts proposent de discuter la conduite à tenir de façon collégiale chez les patients porteurs d''une valve cardiaque mécanique.', 'AE', 'Champ 2 — Imagerie de contrôle & réversion des anticoagulants (Réf. R2.6.3)'),
  ('MG-ANES-000052-R11', 'Les experts proposent de ne pas neutraliser l''aspirine chez un patient traité par aspirine avec lésion hémorragique intracrânienne après un TCL, pour limiter le risque d''aggravation neurologique.', 'AE', 'Champ 2 — Antiplaquettaires & retour à domicile (Réf. R2.7)'),
  ('MG-ANES-000052-R12', 'Les experts proposent d''autoriser un retour à domicile des patients depuis la structure des urgences, même en présence d''anticoagulants ou d''agents antiplaquettaires, si au moins un de ces éléments est présent : patient à faible risque de saignement (cf. R2.1) ; dosage d''un biomarqueur sérique négatif ; TDM initiale ne retrouvant pas de saignement.', 'AE', 'Champ 2 — Antiplaquettaires & retour à domicile (Réf. R2.8)'),
  ('MG-ANES-000052-R13', 'Les experts proposent que la persistance de symptômes jugés invalidants par le patient au-delà de 7 jours après le traumatisme doive amener à une évaluation médicale.', 'AE', 'Champ 3 — Filière de soins & information de sortie (Réf. R3.1)'),
  ('MG-ANES-000052-R14', 'Les experts proposent que les patients présentant un TCL traité en ambulatoire, et le cas échéant leur entourage, bénéficient d''une information éclairée écrite et orale standardisée sur les motifs devant amener à reconsulter aux urgences dans les 48 heures suivant le retour à domicile.', 'AE', 'Champ 3 — Filière de soins & information de sortie (Réf. R3.2)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-des-patients-presentant-un-traumatisme-cranien-leger-de-ladulte/'
on conflict (recommendation_code) do nothing;
