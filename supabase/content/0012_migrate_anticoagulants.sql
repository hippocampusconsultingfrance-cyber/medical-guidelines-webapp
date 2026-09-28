-- Migration : Gestion des anticoagulants pour une procédure invasive programmée — GIHP/SFAR
-- + 25 sociétés savantes, RFE 20/04/2026
-- Source : rfe-sfar-website/build/content_anticoagulants.json (64 recommandations
-- atomiques : le "principe général" R1 embarqué en prose, les tableaux "Réf. |
-- Recommandation | Grade | Accord" par indication, les tableaux de délais d'arrêt par
-- molécule/fonction rénale, et les tableaux de relais héparinique par stade d'IRC).
--
-- Grade : reproduit tel quel depuis le chip source (1+/1-/2+/2-/AE). La colonne "Accord"
-- (Fort/Faible — niveau de consensus du vote d'experts, distinct de la force GRADE elle-même)
-- est conservée en citation inline dans `statement` ("(accord fort)"/"(accord faible)"),
-- jamais fusionnée dans `grade` : ce sont deux informations différentes de la source (force
-- de recommandation vs. niveau de consensus du vote), le champ `grade` ne doit porter que la
-- première pour rester comparable aux autres documents de ce corpus. evidence_level laissé
-- NULL : pas de système de niveau de preuve distinct de la force GRADE dans ce document.
--
-- PÉRIMÈTRE — disclosure explicite : cette RFE compte, en plus des recommandations gradées
-- migrées ci-dessous, ~20 tableaux de classification du risque hémorragique par acte et par
-- spécialité chirurgicale (Annexe du contenu construit : radiologie interventionnelle,
-- rhumatologie, cardiologie interventionnelle, chirurgie thoracique, orale, ORL, endoscopie
-- digestive, viscérale, proctologie, gynécologie, urologie, plastique, orthopédie,
-- neurochirurgie — chacun produit par la société savante de la spécialité concernée). Ces
-- tableaux classent des actes en "risque faible / risque élevé" SANS chip de grade propre :
-- ce sont des tables de référence (quel acte appartient à quelle catégorie de risque), pas
-- des recommandations cliniques graduées en tant que telles — la décision clinique elle-même
-- (arrêt ou non, délai, relais) reste entièrement portée par les recommandations générales et
-- les tableaux de délais migrés ci-dessous. Non migrées comme recommandations atomiques,
-- cohérent avec le traitement des tables de classification/référence dans les migrations
-- précédentes (ex. Tableau I de aap_programmee, tables de posologie de allergie_prevention).
-- Également exclus : le tableau de posologie des AOD par DFGe (référence pharmacologique
-- pure, pas de grade) et le tableau des stades IRC/CKD-EPI (définitionnel, pas de grade).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Deux tableaux ont des cellules fusionnées visuellement (rowspan) dans le contenu
--    construit (colonne "Molécule" du tableau délai-AOD-DFGe, colonne "Stade IRC" des 3
--    tableaux de relais héparinique) : le libellé de groupe n'apparaît qu'à la première
--    ligne de chaque groupe, les lignes suivantes ont une cellule vide dans le JSON source.
--    Reconstruit ici en reportant explicitement le dernier libellé non vide sur chaque ligne
--    du même groupe (`statement` de chaque ligne migrée est donc complet et autoporteur),
--    pas une fusion arbitraire — la structure de groupement elle-même vient du contenu
--    construit, seule la reformulation en phrase complète par ligne est de mon fait.
-- 2. GIHP (coordonnateur principal) ne figure pas dans le seed Annexe B. Parmi les 25 autres
--    sociétés co-signataires citées par le contenu construit, seules SFC et CNGOF y figurent
--    en plus de SFAR — les 23 autres (SFMV, SFNV, SFTH, SFNDT, INNOVTE, SFPT, SFCO, SFED,
--    SFCD, ACHBPT, SOFFCO-MM, SFCP-CH, SNFCP, AFU, FRI, SFR, SOFCOT, SFA, SFCM, SFHG,
--    GSF-GETO, SFCR, SFNC, SFORL, SoFCPRE, SFCTCV, SCVE) n'y figurent pas et ne sont donc pas
--    liées en document_societies.
-- 3. Fiche compagnon de `anticoag_urgence` (0011, gestion en contexte d'urgence) — celle-ci
--    couvre la procédure invasive PROGRAMMÉE, même paire thématique que aap_urgence/
--    aap_programmee (0004/0005).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Gestion des anticoagulants pour une procédure invasive programmée',
  'RFE', 'fr', '2026-04-20',
  'https://sfar.org/wp-content/uploads/2026/04/RFE-20.4.2026-deifinitif-et-validei.pdf',
  'https://sfar.org/wp-content/uploads/2026/04/RFE-20.4.2026-deifinitif-et-validei.pdf',
  'GRADE : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ proposé / 2- proposé de ne pas faire) ; avis d''experts (AE). Niveau de consensus du vote (Fort si >=70% d''accord et <20% d''opposition, Faible sinon) conservé en citation inline dans chaque `statement`, distinct du grade.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/wp-content/uploads/2026/04/RFE-20.4.2026-deifinitif-et-validei.pdf'
  and s.acronym in ('SFAR', 'SFC', 'CNGOF') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/wp-content/uploads/2026/04/RFE-20.4.2026-deifinitif-et-validei.pdf'
  and s.slug in ('anesthesie_reanimation', 'cardiologie', 'hematologie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/wp-content/uploads/2026/04/RFE-20.4.2026-deifinitif-et-validei.pdf',
  'draft'
from public.documents d, (values
  ('MG-ANES-000012-R01', 'La gestion péri-procédurale des anticoagulants se décide en croisant 3 éléments : le risque hémorragique de la procédure, le risque thromboembolique du patient, et les conséquences d''un report de la procédure si les deux risques sont élevés. (accord fort)', '1+', 'Principes généraux & délais d''arrêt (R1)'),
  ('MG-ANES-000012-R02', 'AVK : poursuivre le traitement ; contrôler l''INR dans la semaine précédant la procédure (absence de surdosage). (accord fort)', '2+', 'Procédure à risque hémorragique FAIBLE — pas d''arrêt (2.1)'),
  ('MG-ANES-000012-R03', 'AOD (apixaban, dabigatran, édoxaban, rivaroxaban) : sauter la prise de la veille au soir ET celle du matin de la procédure (quel que soit le schéma), reprise aux doses habituelles ≥ 6h après le geste. (accord fort)', '2+', 'Procédure à risque hémorragique FAIBLE — pas d''arrêt (2.2)'),
  ('MG-ANES-000012-R04', 'AVK — Warfarine (Coumadine®) : dernière prise/injection J-6, puis contrôle INR la veille (objectif ≤ 1,5 ; ≤ 1,2 si neurochirurgie/neuraxial).', '2+', 'Procédure à risque hémorragique ÉLEVÉ — délais d''arrêt pré-procédural — AVK — Warfarine (Coumadine®)'),
  ('MG-ANES-000012-R05', 'AVK — Fluindione (Préviscan®) : dernière prise/injection J-5, puis contrôle INR la veille.', '2+', 'Procédure à risque hémorragique ÉLEVÉ — délais d''arrêt pré-procédural — AVK — Fluindione (Préviscan®)'),
  ('MG-ANES-000012-R06', 'AVK — Acénocoumarol (Sintrom®) : dernière prise/injection J-4, puis contrôle INR la veille.', '2+', 'Procédure à risque hémorragique ÉLEVÉ — délais d''arrêt pré-procédural — AVK — Acénocoumarol (Sintrom®)'),
  ('MG-ANES-000012-R07', 'AOD anti-Xa (apixaban, édoxaban, rivaroxaban) : dernière prise/injection J-3 si fonction rénale normale ; J-5 si risque hémorragique très élevé (neurochirurgie intracrânienne, neuraxial).', '2+', 'Procédure à risque hémorragique ÉLEVÉ — délais d''arrêt pré-procédural — AOD anti-Xa (apixaban, édoxaban, rivaroxaban)'),
  ('MG-ANES-000012-R08', 'Dabigatran : dernière prise/injection J-3 (fonction rénale normale) ; adapter si IRC (cf. tableau rénal).', '2+', 'Procédure à risque hémorragique ÉLEVÉ — délais d''arrêt pré-procédural — Dabigatran'),
  ('MG-ANES-000012-R09', 'HBPM dose curative : dernière prise/injection 24h avant la procédure.', 'AE', 'Procédure à risque hémorragique ÉLEVÉ — délais d''arrêt pré-procédural — HBPM dose curative'),
  ('MG-ANES-000012-R10', 'HNF sous-cutanée dose curative : dernière prise/injection 24h avant la procédure.', 'AE', 'Procédure à risque hémorragique ÉLEVÉ — délais d''arrêt pré-procédural — HNF sous-cutanée dose curative'),
  ('MG-ANES-000012-R11', 'HNF IVSE dose curative : dernière prise/injection 6h avant la procédure.', 'AE', 'Procédure à risque hémorragique ÉLEVÉ — délais d''arrêt pré-procédural — HNF IVSE dose curative'),
  ('MG-ANES-000012-R12', 'Fondaparinux dose curative : dernière prise/injection J-4.', 'AE', 'Procédure à risque hémorragique ÉLEVÉ — délais d''arrêt pré-procédural — Fondaparinux dose curative'),
  ('MG-ANES-000012-R13', 'ATCD d''AVC ischémique : différer la procédure au-delà du 3ème mois post-AVC si possible (sauf urgence vitale/fonctionnelle). (accord fort)', '2+', 'Fibrillation atriale (FA) — patient sous AOD (5.1)'),
  ('MG-ANES-000012-R14', 'Risque hémorragique élevé : arrêt AOD, dernière prise à J-3 (DFG normal), sans relais héparinique. (accord fort)', '2+', 'Fibrillation atriale (FA) — patient sous AOD (3.3/5.5)'),
  ('MG-ANES-000012-R15', 'Reprise du traitement curatif par l''AOD habituel, idéalement entre 48h et 72h, sans relais héparinique. (accord fort)', '2+', 'Fibrillation atriale (FA) — patient sous AOD (5.6)'),
  ('MG-ANES-000012-R16', 'Thromboprophylaxie veineuse post-procédurale dans l''attente de la reprise curative. (accord fort)', '1+', 'Fibrillation atriale (FA) — patient sous AOD (4.7)'),
  ('MG-ANES-000012-R17', 'Arrêt AVK avant procédure à risque élevé (délais p.1) + contrôle INR veille ; vitamine K si besoin. (accord fort)', '2+', 'Fibrillation atriale (FA) — patient sous AVK (3.1/3.2)'),
  ('MG-ANES-000012-R18', 'Sans ATCD d''AVC/AIT/embolie systémique : PAS de relais héparinique pré-procédural. (accord fort)', '1-', 'Fibrillation atriale (FA) — patient sous AVK (5.2)'),
  ('MG-ANES-000012-R19', 'Avec ATCD d''AVC/AIT/embolie systémique : relais pré-procédural par HBPM dose curative (1ère inj. soir J-3, dernière au plus tard matin J-1), sans contrôle anti-Xa systématique. (accord fort)', '2+', 'Fibrillation atriale (FA) — patient sous AVK (5.3)'),
  ('MG-ANES-000012-R20', 'Reprise des AVK dans les 24 premières heures post-procédure, posologie habituelle, sans dose de charge, sans relais héparinique. (accord fort)', '1+', 'Fibrillation atriale (FA) — patient sous AVK (4.1)'),
  ('MG-ANES-000012-R21', 'Si reprise AVK impossible <24h : héparine dose curative (HBPM préférée), idéalement 48-72h post-procédure. (accord fort)', '2+', 'Fibrillation atriale (FA) — patient sous AVK (4.2)'),
  ('MG-ANES-000012-R22', 'Relais pré-procédural systématique par HBPM dose curative 2x/j (1ère inj. soir J-3, dernière matin J-1), sans contrôle anti-Xa. (accord fort)', '2+', 'Valve cardiaque mécanique (AVK) (6.1)'),
  ('MG-ANES-000012-R23', 'Programmer la procédure le matin pour ne pas prolonger l''arrêt des anticoagulants. (accord fort)', 'AE', 'Valve cardiaque mécanique (AVK) (6.2)'),
  ('MG-ANES-000012-R24', 'Valve aortique à double ailettes, rythme sinusal, sans ATCD thrombotique : pas de relais héparinique post-procédural si AVK repris <24h. (accord fort)', '2+', 'Valve cardiaque mécanique (AVK) (6.3)'),
  ('MG-ANES-000012-R25', 'Autres cas : relais héparinique post-procédural (HBPM 2x/j), débuté idéalement 48-72h après, arrêté au 1er INR ≥ 2. (accord fort)', '2+', 'Valve cardiaque mécanique (AVK) (6.4)'),
  ('MG-ANES-000012-R26', 'Risque hémorragique élevé, cas non complexe : arrêt AOD, dernière prise à J-3 (DFG normal), sans relais. (accord fort)', '2+', 'MTEV — patient sous AOD (3.3)'),
  ('MG-ANES-000012-R27', 'EP/TVP proximale < 1 mois : stratégie personnalisée multidisciplinaire. (accord fort)', '2+', 'MTEV — patient sous AOD (7.8)'),
  ('MG-ANES-000012-R28', 'Autres cas de MTEV : interrompre l''AOD sans relais héparinique pré-procédural. (accord fort)', '2+', 'MTEV — patient sous AOD (7.9)'),
  ('MG-ANES-000012-R29', 'Reprise du traitement curatif par l''AOD habituel, idéalement 48-72h après, sans relais héparinique. (accord fort)', '2+', 'MTEV — patient sous AOD (7.10)'),
  ('MG-ANES-000012-R30', 'Si le traitement curatif ne peut pas être repris par l''AOD habituel, initier une anticoagulation par héparines à dose curative (HBPM de préférence), idéalement 48-72h après la procédure. (accord fort)', '2+', 'MTEV — patient sous AOD (4.6)'),
  ('MG-ANES-000012-R31', 'EP/TVP proximale < 3 mois : relais pré-procédural par HBPM dose curative (1ère inj. soir J-3, dernière au plus tard matin J-1). (accord fort)', '2+', 'MTEV — patient sous AVK (7.4)'),
  ('MG-ANES-000012-R32', 'Risque de récidive modéré : PAS de relais héparinique pré-procédural. (accord fort)', '2-', 'MTEV — patient sous AVK (7.5)'),
  ('MG-ANES-000012-R33', 'EP/TVP < 3 mois ou déficit connu en prot. C/S : relais post-procédural par héparine dose curative, débuté 48-72h après, arrêté au 1er INR ≥ 2. (accord fort)', '2+', 'MTEV — patient sous AVK (7.6)'),
  ('MG-ANES-000012-R34', 'Autres cas : pas de relais post-procédural si AVK repris < 24h. (accord fort)', '2+', 'MTEV — patient sous AVK (7.7)'),
  ('MG-ANES-000012-R35', 'EP/TVP proximale < 1 mois + procédure à risque hémorragique élevé : discuter un filtre cave optionnel pré-procédural. (accord fort)', '2+', 'MTEV — filtre cave & thromboprophylaxie mécanique (7.11)'),
  ('MG-ANES-000012-R36', 'Retrait du filtre programmé dès reprise de l''anticoagulation curative (idéalement < 3 mois). (accord fort)', '2+', 'MTEV — filtre cave & thromboprophylaxie mécanique (7.12)'),
  ('MG-ANES-000012-R37', 'TVP distale symptomatique : différer la procédure au-delà du 1er mois suivant la thrombose si cela ne génère pas de risque vital/fonctionnel majeur. (accord fort)', '2+', 'MTEV — filtre cave & thromboprophylaxie mécanique (7.13)'),
  ('MG-ANES-000012-R38', 'Risque hémorragique ET thromboembolique élevés : compression pneumatique intermittente per- et post-procédurale, en association à la prophylaxie pharmacologique. (accord fort)', '2+', 'MTEV — filtre cave & thromboprophylaxie mécanique (7.14)'),
  ('MG-ANES-000012-R39', 'Contentions élastiques graduées : NON recommandées quel que soit le risque thromboembolique. (accord fort)', '1-', 'MTEV — filtre cave & thromboprophylaxie mécanique (7.15)'),
  ('MG-ANES-000012-R40', 'Apixaban / Édoxaban / Rivaroxaban, DFGe ≥ 50 mL/min : délai à risque hémorragique faible = Pas d''arrêt (sauter J-1 soir + matin) ; délai à risque hémorragique élevé = J-3.', '2+', 'Délai d''arrêt pré-procédural des AOD selon le DFGe (FA) — Apixaban / Édoxaban / Rivaroxaban (DFGe ≥ 50)'),
  ('MG-ANES-000012-R41', 'Apixaban / Édoxaban / Rivaroxaban, DFGe 30 – 49 mL/min : délai à risque hémorragique faible = idem ; délai à risque hémorragique élevé = J-3.', '2+', 'Délai d''arrêt pré-procédural des AOD selon le DFGe (FA) — Apixaban / Édoxaban / Rivaroxaban (DFGe 30 – 49)'),
  ('MG-ANES-000012-R42', 'Apixaban / Édoxaban / Rivaroxaban, DFGe 15 – 29 mL/min : délai à risque hémorragique faible = idem ; délai à risque hémorragique élevé = J-5.', 'AE', 'Délai d''arrêt pré-procédural des AOD selon le DFGe (FA) — Apixaban / Édoxaban / Rivaroxaban (DFGe 15 – 29)'),
  ('MG-ANES-000012-R43', 'Apixaban / Édoxaban / Rivaroxaban, DFGe < 15 mL/min : délai à risque hémorragique faible = Pas d''AOD / pas de dosage validé ; délai à risque hémorragique élevé = —.', '2-', 'Délai d''arrêt pré-procédural des AOD selon le DFGe (FA) — Apixaban / Édoxaban / Rivaroxaban (DFGe < 15)'),
  ('MG-ANES-000012-R44', 'Dabigatran, DFGe ≥ 50 mL/min : délai à risque hémorragique faible = idem ; délai à risque hémorragique élevé = J-3.', '2+', 'Délai d''arrêt pré-procédural des AOD selon le DFGe (FA) — Dabigatran (DFGe ≥ 50)'),
  ('MG-ANES-000012-R45', 'Dabigatran, DFGe 30 – 49 mL/min : délai à risque hémorragique faible = idem ; délai à risque hémorragique élevé = J-5.', '2+', 'Délai d''arrêt pré-procédural des AOD selon le DFGe (FA) — Dabigatran (DFGe 30 – 49)'),
  ('MG-ANES-000012-R46', 'Dabigatran, DFGe < 30 mL/min : délai à risque hémorragique faible = Non recommandé ; délai à risque hémorragique élevé = —.', '1-', 'Délai d''arrêt pré-procédural des AOD selon le DFGe (FA) — Dabigatran (DFGe < 30)'),
  ('MG-ANES-000012-R47', 'Stade IRC Sévère/terminale(< 30 mL/min) : HNF IVSE débutée le soir de J-3, arrêtée 6h avant la procédure (surveillance/adaptation identiques à la population générale).', '1+', 'Relais AVK par héparines selon le stade d''IRC (Q10) — Modalités du relais héparinique pré-procédural (Sévère/terminale(< 30 mL/min))'),
  ('MG-ANES-000012-R48', 'Stade IRC Sévère/terminale(< 30 mL/min) : Alternative (notamment prise en charge extra-hospitalière) : HNF calcique SC 333 UI/kg le soir de J-3, puis 250 UI/kg/12h, dernière injection le matin de J-1, sans surveillance biologique.', 'AE', 'Relais AVK par héparines selon le stade d''IRC (Q10) — Modalités du relais héparinique pré-procédural (Sévère/terminale(< 30 mL/min))'),
  ('MG-ANES-000012-R49', 'Stade IRC Sévère(15-29 mL/min) : HBPM en alternative à l''HNF : tinzaparine 175 UI/kg x1/j OU énoxaparine 100 UI/kg x1/j — 1ère injection le soir de J-3, dernière le soir de J-2 (2 doses au total, pas d''injection la veille), sans surveillance biologique.', '2+', 'Relais AVK par héparines selon le stade d''IRC (Q10) — Modalités du relais héparinique pré-procédural (Sévère(15-29 mL/min))'),
  ('MG-ANES-000012-R50', 'Stade IRC Terminale(< 15 mL/min) : Tinzaparine 175 UI/kg x1/j en alternative à l''HNF — 1ère injection le soir de J-3, dernière le soir de J-2 (2 injections au total), sans surveillance biologique. Les autres HBPM ne sont pas recommandées.', 'AE', 'Relais AVK par héparines selon le stade d''IRC (Q10) — Modalités du relais héparinique pré-procédural (Terminale(< 15 mL/min))'),
  ('MG-ANES-000012-R51', 'Stade IRC Sévère/terminale(< 30 mL/min) : HNF à dose curative, schéma posologique et surveillance identiques à la population générale.', '1+', 'Relais AVK par héparines selon le stade d''IRC (Q10) — Relais post-procédural (héparine curative, idéalement 48-72h après) (Sévère/terminale(< 30 mL/min))'),
  ('MG-ANES-000012-R52', 'Stade IRC Sévère(15-29 mL/min) : HBPM en alternative à l''HNF : tinzaparine 175 UI/kg x1/j ou énoxaparine 100 UI/kg x1/j.', '2+', 'Relais AVK par héparines selon le stade d''IRC (Q10) — Relais post-procédural (héparine curative, idéalement 48-72h après) (Sévère(15-29 mL/min))'),
  ('MG-ANES-000012-R53', 'Stade IRC Terminale(< 15 mL/min) : Tinzaparine 175 UI/kg x1/j en alternative à l''HNF, avec mesure de l''activité anti-Xa 4 à 6h après la 3ème injection (objectif ≤1,5 UI/mL) — contacter le laboratoire d''hémostase référent si dépassement.', 'AE', 'Relais AVK par héparines selon le stade d''IRC (Q10) — Relais post-procédural (héparine curative, idéalement 48-72h après) (Terminale(< 15 mL/min))'),
  ('MG-ANES-000012-R54', 'Stade IRC Sévère/terminale(< 30 mL/min) : Héparine calcique SC 5 000 UI x2/j.', '1+', 'Relais AVK par héparines selon le stade d''IRC (Q10) — Thromboprophylaxie veineuse post-procédurale (dans l''attente du curatif) (Sévère/terminale(< 30 mL/min))'),
  ('MG-ANES-000012-R55', 'Stade IRC Sévère(15-29 mL/min) : HBPM en alternative à l''HNF : tinzaparine 4 500 UI x1/j ou énoxaparine 2 000 UI x1/j.', '2+', 'Relais AVK par héparines selon le stade d''IRC (Q10) — Thromboprophylaxie veineuse post-procédurale (dans l''attente du curatif) (Sévère(15-29 mL/min))'),
  ('MG-ANES-000012-R56', 'Stade IRC Terminale(< 15 mL/min) : Tinzaparine 4 500 UI x1/j en alternative à l''HNF.', 'AE', 'Relais AVK par héparines selon le stade d''IRC (Q10) — Thromboprophylaxie veineuse post-procédurale (dans l''attente du curatif) (Terminale(< 15 mL/min))'),
  ('MG-ANES-000012-R57', 'En cas de suspicion d''AVC péri-procédural : imagerie cérébrale (parenchyme + vaisseaux) en urgence ; contacter une équipe neurovasculaire (reperfusion envisageable jusqu''à 24h) ; décubitus dorsal, PAS d''antithrombotique avant l''imagerie ; respecter l''HTA jusqu''à 220/120 mmHg. (accord fort)', '1+', 'AVC péri-procédural (Q9) (9.1)'),
  ('MG-ANES-000012-R58', 'Après un AVC ischémique chez un patient avec pathologie thromboembolique artérielle (ex. FA) : reprendre l''anticoagulation curative par AOD dans les 4 jours, ou dans les 48h si AVC mineur. (accord fort)', '2+', 'AVC péri-procédural (Q9) (9.2)'),
  ('MG-ANES-000012-R59', 'AVK + reprise curative envisageable à 24-48h : NE PAS interrompre les AVK ; antagonisation temporaire par CCP seuls (sans vitamine K), dose selon INR pré-procédure pour objectif INR <1,5 (~20 UI/kg) ; reprise des AVK le soir même à dose habituelle sans relais héparinique ; contrôle INR quotidien jusqu''à cible (2-3). (accord fort)', '2+', 'Assistance ventriculaire gauche longue durée — LVAD (Q8) (8.1)'),
  ('MG-ANES-000012-R60', 'Autres cas à risque hémorragique élevé : arrêter les AVK, relais pré-procédural par HBPM dose curative (1ère inj. soir J-3, dernière au plus tard matin J-1, sans contrôle anti-Xa) ; reprise des AVK dans les 24 premières heures, sans relais héparinique post-procédural. (accord fort)', '2+', 'Assistance ventriculaire gauche longue durée — LVAD (Q8) (8.2)'),
  ('MG-ANES-000012-R61', 'Poids ≥ 100 kg nécessitant un relais péri-procédural : utiliser les HBPM à dose curative sans surveillance biologique en 1ère intention ; HNF seulement en 2ème intention. (accord fort)', '2+', 'Poids extrême (Q11) (11.1)'),
  ('MG-ANES-000012-R62', 'Poids ≥ 100 kg sous HBPM : ne pas dépasser les doses recommandées pour 100 kg — ex. 18 000 UI x1/j (tinzaparine, daltéparine, nadroparine) ou 10 000 UI x2/j (énoxaparine). (accord fort)', 'AE', 'Poids extrême (Q11) (11.2)'),
  ('MG-ANES-000012-R63', 'Poids ≥ 100 kg sous HNF IVSE curative : débuter à dose réduite par rapport au schéma habituel (ex. 1500 UI/h soit 36 000 UI/j quel que soit le poids), puis adapter comme en population générale. (accord fort)', 'AE', 'Poids extrême (Q11) (11.3)'),
  ('MG-ANES-000012-R64', 'Poids < 50 kg nécessitant un relais péri-procédural : HBPM à dose curative en 1ère intention, ajustées au poids selon le RCP ; HNF en 2ème intention. (accord fort)', '2+', 'Poids extrême (Q11) (11.4)')) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/wp-content/uploads/2026/04/RFE-20.4.2026-deifinitif-et-validei.pdf'
on conflict (recommendation_code) do nothing;
