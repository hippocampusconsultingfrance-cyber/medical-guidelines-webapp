-- Migration : Prise en charge du coronarien qui doit être opéré en
-- chirurgie non cardiaque / Perioperative assessment of cardiac risk
-- patient in non-cardiac surgery — RFE conjointe Sfar/SFC. Coordinateurs :
-- G. Derumeaux (SFC), V. Piriou (Sfar) ; aide méthodologique E. Marret.
-- Coordinateurs par question : Q1 C. Girard/G. Vanzetto ; Q2 E. Donal/
-- D. Longrois ; Q3 E. Samain/M. Elbaz ; Q4 J. Machecourt/V. Piriou.
-- Groupes de lecture : CA de la Sfar (17 décembre 2010), CA de la SFC
-- (octobre 2010). Publié Ann Fr Anesth Réanim 30 (2011) e5-e29,
-- doi:10.1016/j.annfar.2011.05.013.
-- Source : rfe-sfar-website/build/content_coronarien.json.
--
-- DÉDOUBLONNAGE VÉRIFIÉ : `grep -rln` sur les URL/PDF de ce document
-- ('prise-en-charge-du-coronarien-opere-en-chirurgie-non-cardiaque' et
-- '2_AFAR_Prise-en-charge-du-coronarien') contre les 90 fichiers
-- `NNNN_migrate_*.sql` déjà présents dans ce dossier ne retourne AUCUNE
-- correspondance. Deux autres migrations existantes portent sur un sujet
-- cardiaque voisin mais sont des documents SFAR distincts, vérifiés par
-- leur `source_url` propre : `aap_endoprotheses_coronaires`/0062
-- ('.../gestion-du-traitement-anti-plaquettaire-oral-chez-les-patients-
-- porteurs-dendoprotheses-coronaires/', avis d'experts 2006, gestion des
-- AAP sous endoprothèse — sujet voisin mais document différent, non
-- superseded l'un par l'autre) et `infarctus_myocarde`/0068
-- ('.../prise-en-charge-de-linfarctus-du-myocarde-a-la-phase-aigue-en-
-- dehors-des-services-de-cardiologie/', conférence de consensus HAS 2006,
-- IDM constitué hors service de cardiologie — periopératoire préventif
-- ici, pathologie aiguë là-bas). Aucune collision de clé.
--
-- ⚠️ MÉTHODOLOGIE EXACTE — DEUX AXES DE COTATION DISTINCTS (source elle-
-- même, reproduits sans jamais être fusionnés) :
--   (1) GRADE — force/sens de la recommandation, seul axe individuellement
--       tagué par recommandation : 1+ (recommandé de faire), 1- (recommandé
--       de ne pas faire), 2+ (probablement/suggéré de faire), 2- (probablement
--       recommandé de ne pas faire). C'est CET axe qui alimente la colonne
--       `grade` ci-dessous, valeur reproduite telle qu'imprimée.
--   (2) Accord Delphi (vote des experts, échelle 1-9, fort si tous sauf un
--       cotent 7-9 ; faible si tous sauf un cotent 4-9 avec majorité 7-9) —
--       axe EXPLICITEMENT dit "distinct du GRADE" par la source. Fort par
--       défaut ; seules 5 recommandations (R27, R28, R32, R48, R49) portent
--       la mention explicite "(accord faible)", et cette mention fait
--       PARTIE DU TEXTE de l'énoncé lui-même dans le contenu construit (pas
--       une métadonnée séparée) — reproduite donc telle quelle dans
--       `statement`, jamais recodée dans `grade` ni `evidence_level` pour ne
--       pas fusionner deux axes que la source dit elle-même distincts.
-- `evidence_level` (niveau de preuve GRADE, distinct de la force ci-dessus)
-- N'EST PAS fourni individuellement par recommandation dans cette source —
-- seule la définition générale de l'axe est donnée en préambule, jamais une
-- valeur par énoncé. Laissé NULL sur les 65 lignes (aucune valeur devinée),
-- même convention que `sujet_age_esf`/0064 et `sepsis`/0044.
--
-- ⚠️ INCOHÉRENCES SOURCE-INTERNES DISCLOSED, JAMAIS RÉSOLUES SILENCIEUSEMENT :
--  (a) R7 et R22 sont toutes deux imprimées avec un tag GRADE "1+" alors que
--      leur texte formule une recommandation NÉGATIVE ("il n'est pas
--      recommandé de..."). Incohérence de signe présente dans le document
--      source tel qu'extrait (déjà signalée par le contenu construit
--      lui-même) — le tag "1+" est conservé tel quel sur les deux lignes,
--      PAS "corrigé" en 1-, faute de pouvoir confirmer l'intention exacte
--      des experts sans accès à une version haute résolution du tableau
--      récapitulatif du PDF.
--  (b) R32 (choix de la technique de revascularisation) contient la mention
--      littérale « avant une chirurgie cardiaque » alors que la totalité du
--      document traite de chirurgie NON cardiaque (titre, champ, les 64
--      autres recommandations) — probable erreur du texte source, non
--      corrigée : la citation entre guillemets français dans `statement`
--      reproduit le texte source mot pour mot, disclosure ici plutôt que
--      silencieuse "correction" en "chirurgie non cardiaque".
--  (c) Divergence mineure, non contradictoire : `library_final.json` porte
--      `"year": "2010"` (probablement l'année des validations CA Sfar/SFC,
--      décembre/octobre 2010, citées par la source) alors que `exact_date`
--      = "2011" (année de publication effective dans Ann Fr Anesth Réanim
--      30, citée explicitement par le contenu construit avec le DOI) —
--      lecture la plus probable (validation 2010, publication 2011), pas
--      une contradiction du même fait, mais notée pour traçabilité.
--      `exact_date` retenu pour `publication_date` (précision année
--      seule connue) : 2011-01-01, même convention que `eeg_cortical`/0081.
--  (d) Hors périmètre de cette migration (table exclue, voir plus bas) mais
--      notée pour complétude : le Tableau 1 (score de Lee) imprime le
--      critère rénal comme "Créatinine > 2,0 mg/dL" tout en donnant entre
--      parenthèses l'équivalent "177 mmol/L" — 177 mmol/L de créatinine est
--      cliniquement incompatible avec la vie (probable erreur d'unité pour
--      177 µmol/L, qui correspond bien à 2,0 mg/dL) ; incohérence du
--      document source telle quelle, non corrigée, non modélisée en base
--      puisque ce tableau définitionnel n'est de toute façon pas migré
--      comme recommandation (voir liste des exclusions ci-dessous).
--
-- ⚠️ SOCIÉTÉS — VÉRIFICATION EXHAUSTIVE CONTRE LA LISTE COMPLÈTE DU SEED
-- (18 entrées de schema_v2.sql, section 15, lues intégralement, PAS une
-- commande grep tronquée) : ce document est une RFE CONJOINTE Sfar/SFC (les
-- deux CA de lecture cités par la source, aucune autre société savante
-- nommée). SFAR ET SFC sont TOUTES DEUX présentes dans le seed
-- (`('SFAR', 'France')`, `('SFC', 'France')`) — aucune société absente à
-- signaler pour ce document, cas rare dans ce corpus où toutes les sociétés
-- co-organisatrices sont déjà dans l'Annexe B.
--
-- ⚠️ SPÉCIALITÉS — VÉRIFICATION EXHAUSTIVE CONTRE LA LISTE COMPLÈTE DU SEED
-- (77 slugs de schema_v2.sql, section 14, lus intégralement) : `slug`
-- `cardiologie` EXISTE dans le seed (spécialité médicale, ligne 4 de la
-- liste). Ajoutée en plus de `anesthesie_reanimation` (public cible
-- principal, gestion périopératoire anesthésique), cohérent avec la
-- co-paternité SFC et le contenu du document (risque cardiaque, examens
-- cardiologiques, revascularisation, traitements cardiovasculaires).
-- `medecine_d_urgence` volontairement PAS ajoutée : bien que l'algorithme de
-- la Q4 mentionne la chirurgie "urgente/vitale" comme une branche de
-- décision, ce document n'est ni co-écrit ni co-lu par la SFMU et ne porte
-- pas sur la médecine d'urgence en tant que telle (contrairement à
-- `sauv`/0084 ou `monitorage_traumatise`/0067, où la SFMU est promotrice).
--
-- ⚠️ CONTENU VOLONTAIREMENT EXCLU DU MODÈLE `recommendations` (justifié
-- ligne par ligne, aucune omission silencieuse) :
--  - Le panneau "Résumé" et le paragraphe de méthodologie (préambule) : prose
--    narrative de contexte, ne formule aucun énoncé "il faut faire X".
--  - Le tableau de définition des chips GRADE/Accord (badge_head) : légende
--    méthodologique, pas une recommandation.
--  - Tableau 1 (score de risque cardiaque de Lee) et la phrase d'incidence
--    de complications (0,4/0,9/7/11 %) : outil de stratification/donnée
--    épidémiologique descriptive, pas un énoncé d'action gradé.
--  - Tableau 2 (capacité à l'effort, échelle de Duke/MET) : classification
--    définitionnelle, pas un énoncé d'action gradé.
--  - Tableau 3 (indication de l'ECG selon risque chirurgical × patient) :
--    matrice de synthèse qui ré-applique en tableau croisé les
--    recommandations déjà gradées individuellement (R8-R12) — pas un
--    énoncé supplémentaire distinct, éviter un doublon de contenu.
--  - Le paragraphe "Contexte (non un tag de recommandation)" sur les
--    bêta-bloquants (essai POISE) : EXPLICITEMENT désigné comme non
--    recommandationnel par le contenu construit lui-même — contexte
--    scientifique justifiant R39/R42, pas un énoncé d'action séparé.
--  - Tableau 4 (gestion des antiplaquettaires, matrice risque thrombotique ×
--    hémorragique) : opérationnalisation en matrice des principes déjà
--    individuellement gradés en R54-R61 — reformulation croisée, pas de
--    nouveaux tags GRADE propres à chaque cellule ; migrer cette matrice
--    aurait exigé d'inventer un grade par cellule, ce que ce projet
--    s'interdit explicitement.
--  - Intégralité de la Question 4 (algorithme global) : le contenu construit
--    l'affirme lui-même explicitement — "Aucune nouvelle recommandation
--    formellement gradée dans cette section : synthèse narrative qui
--    ré-applique les grades établis en Q1-Q3". Couvre Figure 1 (algorithme
--    général 4 étapes), Figure 2 (gestion antiplaquettaire post-
--    angioplastie), le paragraphe "Autres points narratifs de la Q4" (HTA,
--    valvuloplastie, relais AVK/FA, surveillance troponine postopératoire —
--    non gradés, non numérotés), et l'Annexe 2 (classification CCS de
--    l'angor, table de définition clinique, pas une recommandation).
--  - Annexe 1 (fiche de liaison anesthésiste-cardiologue) : n'est de toute
--    façon pas reproduite dans le contenu construit (JSON source) — décrite
--    par le panneau de couverture comme "un formulaire de recueil de
--    données sans contenu recommandationnel propre", rien à migrer.
--  - Le paragraphe sur l'absence de section "conflits d'intérêts" dans le
--    texte source extrait : flag de traçabilité du contenu construit
--    lui-même, pas un contenu clinique.
-- Aucun trou de numérotation R1-R65 : les 65 recommandations formellement
-- numérotées et gradées de la source sont migrées à 100 % (Q1 : R1-R4 ;
-- Q2 : R5-R24 ; Q3 : R25-R65), exactement le total que le panneau de
-- couverture du contenu construit revendique lui-même
-- ("intégralité des 65 recommandations formellement gradées").
--
-- `population` : NON renseigné (colonne omise) — ce document ne stratifie
-- AUCUNE de ses 65 recommandations par population de patients (pas de
-- distinction adulte/enfant, sujet âgé, grossesse : le champ entier
-- s'adresse au patient coronarien adulte devant une chirurgie non
-- cardiaque, sans sous-population nommée nulle part dans le texte).
--
-- SOURCE_URL / PDF_URL : `library_final.json` (recherche "coronarien" —
-- exactement 1 correspondance, lignes 1879-1896) donne `href` (utilisé ici
-- comme `source_url`, cohérent avec le reste du corpus : page de renvoi
-- SFAR) et `direct_pdf_url` (utilisé comme `pdf_url`). Note : le contenu
-- construit cite dans son propre panneau "URL source" directement le PDF
-- (`direct_pdf_url`), et non le `href` HTML — divergence de convention
-- interne au contenu construit, pas une erreur de cette migration ; les
-- deux URL désignent sans ambiguïté le même document et proviennent toutes
-- deux de la même entrée unique de `library_final.json`.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge du coronarien qui doit être opéré en chirurgie non cardiaque',
  'RFE', 'fr', '2011-01-01',
  'https://sfar.org/prise-en-charge-du-coronarien-opere-en-chirurgie-non-cardiaque/',
  'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Prise-en-charge-du-coronarien-qui-doit-etre-opere-en-chirurgie-non-cardiaque.pdf',
  'GRADE (force/sens de la recommandation : 1+ recommandé de faire, 1- recommandé de ne pas faire, 2+ probablement/suggéré de faire, 2- probablement recommandé de ne pas faire), croisé avec un accord Delphi (vote des experts 1-9, fort/faible) EXPLICITEMENT décrit par la source comme un axe distinct du GRADE — accord fort par défaut, "(accord faible)" mentionné dans le texte de l''énoncé lui-même sur 5 recommandations (R27, R28, R32, R48, R49) plutôt que porté par une colonne dédiée. 65 recommandations formellement gradées (Q1 : 4, Q2 : 20, Q3 : 41). `evidence_level` (niveau de preuve GRADE) non fourni individuellement par la source — NULL sur toutes les lignes. Deux incohérences grade/texte non résolues, reproduites telles quelles : R7 et R22 imprimées "1+" avec un texte de sens négatif. R32 contient la mention littérale probablement erronée "avant une chirurgie cardiaque" dans un document entièrement consacré à la chirurgie NON cardiaque — disclosure intégrale en tête de ce fichier.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-du-coronarien-opere-en-chirurgie-non-cardiaque/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'), ('SFC', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-du-coronarien-opere-en-chirurgie-non-cardiaque/'
  and s.slug in ('anesthesie_reanimation', 'cardiologie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.source_section,
  'https://sfar.org/prise-en-charge-du-coronarien-opere-en-chirurgie-non-cardiaque/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000092-R01', 'Chez le patient coronarien ou à risque de maladie coronaire (Lee clinique ≥ 2) opéré d''une chirurgie non cardiaque à risque intermédiaire ou élevé, il est recommandé de réaliser de manière répétée dans les 48 premières heures postopératoires : ECG, dosage de troponine Ic, mesure de l''hémoglobine.', '1+', 'Surveillance postopératoire (ECG/troponine/hémoglobine) chez le patient à risque', 'Question 1 — Quantification du risque, R1'),
  ('MG-ANES-000092-R02', 'Chez le patient à risque de maladie coronaire opéré d''une chirurgie à risque élevé, il n''est pas recommandé de doser en postopératoire myoglobine, isoenzyme CK-MB, BNP/NT-proBNP, CRP/hsCRP.', '1-', 'Biomarqueurs postopératoires non recommandés (myoglobine/CK-MB/BNP/CRP)', 'Question 1 — Quantification du risque, R2'),
  ('MG-ANES-000092-R03', 'Il est recommandé d''évaluer le risque périopératoire sur 3 critères : risque lié à l''intervention chirurgicale, risque lié à l''état cardiaque du patient, capacité à effectuer un effort.', '1+', 'Évaluation du risque périopératoire — 3 critères', 'Question 1 — Quantification du risque, R3'),
  ('MG-ANES-000092-R04', 'Il n''est pas recommandé de doser en préopératoire BNP/NT-proBNP, troponine, CRP/hsCRP pour évaluer le risque périopératoire.', '1-', 'Biomarqueurs préopératoires non recommandés (BNP/troponine/CRP)', 'Question 1 — Quantification du risque, R4'),
  ('MG-ANES-000092-R05', 'Il n''est pas recommandé de réaliser des examens spécialisés (échocardiographie dobutamine, scintigraphie thallium-persantine) lorsque leurs résultats ne sont pas susceptibles de modifier la stratégie périopératoire.', '1-', 'Examens spécialisés non recommandés si sans impact sur la stratégie', 'Question 2 — Examens complémentaires, Principe général et ECG, R5'),
  ('MG-ANES-000092-R06', 'Il n''est pas recommandé de dépister systématiquement la coronaropathie chez un patient asymptomatique, quelle que soit la chirurgie.', '1-', 'Dépistage systématique de la coronaropathie non recommandé', 'Question 2 — Examens complémentaires, Principe général et ECG, R6'),
  ('MG-ANES-000092-R07', 'Il n''est pas recommandé de refaire un ECG (ou une autre exploration) chez un coronarien ayant un bilan cardiologique et un ECG de moins d''un an disponibles, en l''absence d''événement intercurrent ; l''ECG doit être transmis à la consultation d''anesthésie.', '1+', 'ECG non répété si bilan cardiologique de moins d''un an disponible', 'Question 2 — Examens complémentaires, Principe général et ECG, R7'),
  ('MG-ANES-000092-R08', 'Il est recommandé de faire un ECG de repos 12 dérivations avant chirurgie vasculaire artérielle pour maladie athéromateuse avec facteurs de risque (score de Lee).', '1+', 'ECG de repos avant chirurgie vasculaire avec facteurs de risque', 'Question 2 — Examens complémentaires, Principe général et ECG, R8'),
  ('MG-ANES-000092-R09', 'Il est suggéré de faire un ECG de repos avant chirurgie vasculaire même sans facteur de risque au score de Lee, pour disposer d''un ECG de référence.', '2+', 'ECG de repos avant chirurgie vasculaire sans facteur de risque', 'Question 2 — Examens complémentaires, Principe général et ECG, R9'),
  ('MG-ANES-000092-R10', 'Il est recommandé de faire un ECG de repos chez tout patient > 50 ans ayant > 1 facteur de risque (score de Lee) avant chirurgie à risque intermédiaire ou élevé.', '1+', 'ECG de repos chez le patient de plus de 50 ans à risque', 'Question 2 — Examens complémentaires, Principe général et ECG, R10'),
  ('MG-ANES-000092-R11', 'Il n''est pas recommandé de réaliser un ECG systématique avant chirurgie à risque faible.', '1-', 'ECG systématique non recommandé avant chirurgie à risque faible', 'Question 2 — Examens complémentaires, Principe général et ECG, R11'),
  ('MG-ANES-000092-R12', 'Il est recommandé de réaliser un ECG 12 dérivations (avec V3R, V4R, V7-V9) en périopératoire chez tout patient présentant une symptomatologie cardiologique de diagnostic non évident.', '1+', 'ECG 12 dérivations en cas de symptomatologie cardiologique périopératoire', 'Question 2 — Examens complémentaires, Principe général et ECG, R12'),
  ('MG-ANES-000092-R13', 'Il n''est pas recommandé de prescrire un Holter ECG pour prédire le risque d''événement cardiaque périopératoire.', '1-', 'Holter ECG non recommandé', 'Question 2 — Examens complémentaires, Holter/ECG d''effort/échocardiographie, R13'),
  ('MG-ANES-000092-R14', 'Il n''est pas recommandé de réaliser un ECG d''effort — surtout s''il risque d''être sous-maximal (< 85 % FMT) — pour prédire le risque ischémique périopératoire.', '1-', 'ECG d''effort non recommandé', 'Question 2 — Examens complémentaires, Holter/ECG d''effort/échocardiographie, R14'),
  ('MG-ANES-000092-R15', 'Il n''est pas recommandé de prescrire une échocardiographie de repos pour évaluer le risque coronaire périopératoire.', '1-', 'Échocardiographie de repos non recommandée', 'Question 2 — Examens complémentaires, Holter/ECG d''effort/échocardiographie, R15'),
  ('MG-ANES-000092-R16', 'Il est recommandé de prescrire une échocardiographie de stress si le niveau de risque impose un dépistage et si l''examen peut être réalisé/interprété selon les recommandations de l''EAE dans le centre.', '1+', 'Échocardiographie de stress si dépistage indiqué', 'Question 2 — Examens complémentaires, Holter/ECG d''effort/échocardiographie, R16'),
  ('MG-ANES-000092-R17', 'Il est recommandé de rediscuter l''indication opératoire et de proposer un complément d''investigation si l''échocardiographie de stress est anormale sur > 4/17 segments (avec ou sans dysfonction/dilatation VG).', '1+', 'Complément d''investigation si échocardiographie de stress anormale', 'Question 2 — Examens complémentaires, Holter/ECG d''effort/échocardiographie, R17'),
  ('MG-ANES-000092-R18', 'Il est recommandé de prescrire une scintigraphie myocardique si le niveau de risque impose un dépistage et si l''examen peut être réalisé/interprété dans le centre avec une expertise suffisante.', '1+', 'Scintigraphie myocardique si dépistage indiqué', 'Question 2 — Examens complémentaires, Scintigraphie/coronarographie/imagerie en coupe, R18'),
  ('MG-ANES-000092-R19', 'Il est recommandé de proposer un complément d''investigation, en tenant compte du contexte chirurgical, si la scintigraphie retrouve un défect perfusionnel > 20 %.', '1+', 'Complément d''investigation si défect perfusionnel supérieur à 20 %', 'Question 2 — Examens complémentaires, Scintigraphie/coronarographie/imagerie en coupe, R19'),
  ('MG-ANES-000092-R20', 'Il est recommandé de discuter le choix scintigraphie/échographie de stress selon les disponibilités et compétences locales (en tenant compte du caractère irradiant de la scintigraphie) ; une feuille de liaison anesthésiste-cardiologue est encouragée (indication, score de Lee, tolérance à l''effort, traitements, justification du test → résultats et attitude proposée).', '1+', 'Choix scintigraphie vs échographie de stress', 'Question 2 — Examens complémentaires, Scintigraphie/coronarographie/imagerie en coupe, R20'),
  ('MG-ANES-000092-R21', 'Il est recommandé que le cardiologue ayant réalisé l''examen propose à l''équipe d''anesthésie-réanimation des éléments de prise en charge (optimisation du traitement, discussion d''une revascularisation, report de chirurgie) selon le contexte opératoire.', '1+', 'Transmission des éléments de prise en charge par le cardiologue', 'Question 2 — Examens complémentaires, Scintigraphie/coronarographie/imagerie en coupe, R21'),
  ('MG-ANES-000092-R22', 'Il n''est pas recommandé de prescrire en première intention une coronarographie pour prédire le risque de complication ischémique postopératoire.', '1+', 'Coronarographie de première intention non recommandée', 'Question 2 — Examens complémentaires, Scintigraphie/coronarographie/imagerie en coupe, R22'),
  ('MG-ANES-000092-R23', 'Il est recommandé que toute décision de coronarographie avant chirurgie non cardiaque programmée soit collégiale et tracée dans le dossier.', '1+', 'Décision de coronarographie collégiale et tracée', 'Question 2 — Examens complémentaires, Scintigraphie/coronarographie/imagerie en coupe, R23'),
  ('MG-ANES-000092-R24', 'Il n''est pas recommandé de proposer un coroscanner, une IRM ou une TEP pour dépister le risque coronaire en période préopératoire.', '1-', 'Coroscanner/IRM/TEP non recommandés en dépistage préopératoire', 'Question 2 — Examens complémentaires, Scintigraphie/coronarographie/imagerie en coupe, R24'),
  ('MG-ANES-000092-R25', 'La décision de revascularisation avant chirurgie non cardiaque doit être consensuelle entre praticiens, tracée dans le dossier (bénéfices/risques/alternatives, optimisation du traitement médical) et expliquée au patient.', '1+', 'Décision de revascularisation consensuelle et tracée', 'Question 3 — Revascularisation et médicaments, Indications de la revascularisation myocardique préopératoire, R25'),
  ('MG-ANES-000092-R26', 'La revascularisation myocardique préalable à une chirurgie non cardiaque doit rester exceptionnelle.', '1+', 'Revascularisation préopératoire — caractère exceptionnel', 'Question 3 — Revascularisation et médicaments, Indications de la revascularisation myocardique préopératoire, R26'),
  ('MG-ANES-000092-R27', 'Situation clinique pouvant faire envisager une revascularisation : syndrome coronaire aigu préopératoire, avec ou sans sus-décalage ST. (accord faible)', '1+', 'Indication de revascularisation — syndrome coronaire aigu préopératoire', 'Question 3 — Revascularisation et médicaments, Indications de la revascularisation myocardique préopératoire, R27'),
  ('MG-ANES-000092-R28', 'Situation clinique : coronaropathie stable avec statut anatomique ou ischémique mettant en jeu un territoire myocardique important. (accord faible)', '2+', 'Indication de revascularisation — coronaropathie stable à territoire important', 'Question 3 — Revascularisation et médicaments, Indications de la revascularisation myocardique préopératoire, R28'),
  ('MG-ANES-000092-R29', 'Situation anatomique : atteinte du tronc commun gauche ou des trois troncs coronaires, si patient symptomatique et/ou ischémie authentifiée sur ≥ 3 segments.', '1+', 'Indication de revascularisation — atteinte du tronc commun/tritronculaire symptomatique', 'Question 3 — Revascularisation et médicaments, Indications de la revascularisation myocardique préopératoire, R29'),
  ('MG-ANES-000092-R30', 'Situation anatomique : occlusion d''un tronc coronaire dans un statut anatomique particulier (tronc commun, ou statut pluritronculaire impliquant l''IVA).', '1+', 'Indication de revascularisation — occlusion coronaire en situation anatomique particulière', 'Question 3 — Revascularisation et médicaments, Indications de la revascularisation myocardique préopératoire, R30'),
  ('MG-ANES-000092-R31', 'En dehors de ces situations, il n''est pas recommandé de revasculariser, notamment en cas d''occlusion chronique avec ischémie/viabilité modérées (bénéfice non démontré).', '1-', 'Revascularisation non recommandée en dehors des situations ciblées', 'Question 3 — Revascularisation et médicaments, Indications de la revascularisation myocardique préopératoire, R31'),
  ('MG-ANES-000092-R32', 'Le pontage aortocoronaire est la technique de référence « avant une chirurgie cardiaque » si : atteinte du tronc commun/tritronculaire, altération de la FEVG, ou geste différable de quelques semaines. (accord faible)', '1+', 'Choix de la technique de revascularisation — pontage aortocoronaire', 'Question 3 — Revascularisation et médicaments, Choix de la technique de revascularisation, R32'),
  ('MG-ANES-000092-R33', 'L''angioplastie coronaire préopératoire n''est pas recommandée en prévention des événements ischémiques périopératoires, sauf situation clinique instable (difficultés de gestion périopératoire des antiplaquettaires) ; envisageable en cas de syndrome coronaire aigu préopératoire.', '1-', 'Angioplastie coronaire préopératoire non recommandée en prévention', 'Question 3 — Revascularisation et médicaments, Choix de la technique de revascularisation, R33'),
  ('MG-ANES-000092-R34', 'Si angioplastie réalisée avant chirurgie non cardiaque, il est recommandé de poser une endoprothèse nue (4-6 semaines de double antiagrégation seulement, limitant le report de chirurgie).', '1+', 'Endoprothèse nue privilégiée en cas d''angioplastie préopératoire', 'Question 3 — Revascularisation et médicaments, Choix de la technique de revascularisation, R34'),
  ('MG-ANES-000092-R35', 'La chirurgie après endoprothèse nue doit être réalisée au minimum 6 semaines plus tard, idéalement 3 mois plus tard.', '1+', 'Délai de chirurgie après pose d''une endoprothèse nue', 'Question 3 — Revascularisation et médicaments, Choix de la technique de revascularisation, R35'),
  ('MG-ANES-000092-R36', 'Il n''est pas recommandé de poser une endoprothèse active/recouverte (double antiagrégation prolongée ≥ 1 an, voire plus).', '1-', 'Endoprothèse active/recouverte non recommandée', 'Question 3 — Revascularisation et médicaments, Choix de la technique de revascularisation, R36'),
  ('MG-ANES-000092-R37', 'Cette attitude peut être reconsidérée si chirurgie fonctionnelle non vitale différable ≥ 1 an, ou chirurgie à très faible risque hémorragique réalisable sous double antiagrégation.', '2+', 'Endoprothèse active — situations de reconsidération', 'Question 3 — Revascularisation et médicaments, Choix de la technique de revascularisation, R37'),
  ('MG-ANES-000092-R38', 'Si une endoprothèse coronaire est choisie, la conduite à tenir sur le traitement antiplaquettaire périopératoire doit être discutée et transmise aux équipes anesthésie/chirurgie (risque hémorragique vs thrombotique).', '1+', 'Conduite du traitement antiplaquettaire discutée si endoprothèse', 'Question 3 — Revascularisation et médicaments, Choix de la technique de revascularisation, R38'),
  ('MG-ANES-000092-R39', 'Pour tout traitement bêta-bloquant, la posologie doit être ajustée pour une cible de FC préopératoire de 60-70 b/min, sans hypotension.', '1+', 'Cible de fréquence cardiaque sous bêta-bloquant', 'Question 3 — Revascularisation et médicaments, Bêta-bloquants, R39'),
  ('MG-ANES-000092-R40', 'Il est recommandé de poursuivre en périopératoire un traitement bêta-bloquant prescrit pour insuffisance coronaire (avec ou sans trouble du rythme/insuffisance cardiaque associés).', '1+', 'Poursuite du bêta-bloquant périopératoire pour insuffisance coronaire', 'Question 3 — Revascularisation et médicaments, Bêta-bloquants, R40'),
  ('MG-ANES-000092-R41', 'La mise en route préopératoire d''un bêta-bloquant est recommandée chez les patients ayant une insuffisance coronaire clinique ou des signes d''ischémie à un examen non invasif.', '1+', 'Mise en route préopératoire d''un bêta-bloquant — insuffisance coronaire/ischémie', 'Question 3 — Revascularisation et médicaments, Bêta-bloquants, R41'),
  ('MG-ANES-000092-R42', 'Chez les patients à risque CV élevé/intermédiaire (score de Lee clinique ≥ 2, hors item chirurgie) opérés à haut risque, il peut être recommandé de débuter un bêta-bloquant (en tenant compte du risque d''hypotension/bradycardie peropératoire) ; pour une chirurgie à risque intermédiaire, la décision est plus discutable.', '2+', 'Bêta-bloquant chez le patient à risque cardiovasculaire élevé/intermédiaire', 'Question 3 — Revascularisation et médicaments, Bêta-bloquants, R42'),
  ('MG-ANES-000092-R43', 'Il n''est pas recommandé de débuter un bêta-bloquant avant chirurgie à faible risque.', '1-', 'Bêta-bloquant non recommandé avant chirurgie à faible risque', 'Question 3 — Revascularisation et médicaments, Bêta-bloquants, R43'),
  ('MG-ANES-000092-R44', 'Chez les patients à faible risque, la mise en route préopératoire d''un bêta-bloquant n''est pas indiquée.', '1-', 'Mise en route de bêta-bloquant non indiquée chez le patient à faible risque', 'Question 3 — Revascularisation et médicaments, Bêta-bloquants, R44'),
  ('MG-ANES-000092-R45', 'Si un traitement est débuté en préopératoire, un agent cardiosélectif sans activité sympathomimétique intrinsèque est recommandé (aténolol, métoprolol, bisoprolol).', '1+', 'Choix de l''agent bêta-bloquant', 'Question 3 — Revascularisation et médicaments, Bêta-bloquants, R45'),
  ('MG-ANES-000092-R46', 'Le traitement doit être administré lors de la prémédication, à la dose habituelle.', '1+', 'Modalités d''administration du bêta-bloquant en prémédication', 'Question 3 — Revascularisation et médicaments, Bêta-bloquants, R46'),
  ('MG-ANES-000092-R47', 'En peropératoire, il est recommandé de surveiller strictement FC et PA, et de traiter hypotension et/ou bradycardie par les mesures appropriées.', '1+', 'Surveillance peropératoire FC/PA sous bêta-bloquant', 'Question 3 — Revascularisation et médicaments, Bêta-bloquants, R47'),
  ('MG-ANES-000092-R48', 'Bien que les alpha2-agonistes réduisent le risque de décès et d''IDM postopératoire chez le coronarien opéré de chirurgie vasculaire, leur administration n''est probablement pas à recommander (retentissement hémodynamique). (accord faible)', '2-', 'Alpha2-agonistes non recommandés — chirurgie vasculaire', 'Question 3 — Revascularisation et médicaments, Alpha2-agonistes, R48'),
  ('MG-ANES-000092-R49', 'Il n''est probablement pas recommandé d''administrer un alpha2-agoniste chez le coronarien/patient à risque CV pour réduire le risque périopératoire en chirurgie non vasculaire. (accord faible)', '2-', 'Alpha2-agonistes non recommandés — chirurgie non vasculaire', 'Question 3 — Revascularisation et médicaments, Alpha2-agonistes, R49'),
  ('MG-ANES-000092-R50', 'Si une statine est indiquée mais non prescrite, il est recommandé de la débuter avant chirurgie vasculaire, si possible au moins 1 semaine auparavant.', '1+', 'Introduction d''une statine avant chirurgie vasculaire', 'Question 3 — Revascularisation et médicaments, Statines et hypolipémiants, R50'),
  ('MG-ANES-000092-R51', 'Les patients devant subir une chirurgie vasculaire artérielle pourraient bénéficier de l''introduction d''une statine.', '2+', 'Bénéfice possible d''une statine avant chirurgie vasculaire artérielle', 'Question 3 — Revascularisation et médicaments, Statines et hypolipémiants, R51'),
  ('MG-ANES-000092-R52', 'Un traitement par statine chronique doit être poursuivi en périopératoire : administré le soir précédant l''intervention et repris le soir de l''intervention.', '1+', 'Poursuite périopératoire d''une statine chronique', 'Question 3 — Revascularisation et médicaments, Statines et hypolipémiants, R52'),
  ('MG-ANES-000092-R53', 'Il n''y a pas d''indication ni de bénéfice démontré à prescrire un hypolipémiant autre qu''une statine en périopératoire.', '1-', 'Hypolipémiant autre qu''une statine — absence d''indication', 'Question 3 — Revascularisation et médicaments, Statines et hypolipémiants, R53'),
  ('MG-ANES-000092-R54', 'Une endoprothèse active posée dans les 12 mois précédents implique la poursuite de la double thérapie antiplaquettaire.', '1+', 'Endoprothèse active récente — poursuite de la bithérapie antiplaquettaire', 'Question 3 — Revascularisation et médicaments, Agents antiplaquettaires (AAP), R54'),
  ('MG-ANES-000092-R55', 'Une endoprothèse nue implique une double antiagrégation pendant 4 à 6 semaines.', '1+', 'Endoprothèse nue — durée de la double antiagrégation', 'Question 3 — Revascularisation et médicaments, Agents antiplaquettaires (AAP), R55'),
  ('MG-ANES-000092-R56', 'La survenue d''un syndrome coronaire aigu implique si possible une double antiagrégation pendant 1 an ; si risque hémorragique périopératoire élevé, l''interruption du clopidogrel avec poursuite de l''aspirine peut être indiquée.', '2+', 'Syndrome coronaire aigu — durée de la double antiagrégation', 'Question 3 — Revascularisation et médicaments, Agents antiplaquettaires (AAP), R56'),
  ('MG-ANES-000092-R57', 'En cas d''arrêt d''un antiplaquettaire (aspirine, clopidogrel), il est recommandé de réaliser la chirurgie après 5 jours d''arrêt (réduit le risque hémorragique, limite le risque thrombotique — maximal au-delà du 8e jour d''arrêt).', '1+', 'Délai de chirurgie après arrêt d''un antiplaquettaire', 'Question 3 — Revascularisation et médicaments, Agents antiplaquettaires (AAP), R57'),
  ('MG-ANES-000092-R58', 'En cas de traitement par aspirine seule, il est recommandé de le poursuivre, sauf contre-indication liée à un très haut risque hémorragique chirurgical.', '1+', 'Poursuite de l''aspirine en monothérapie', 'Question 3 — Revascularisation et médicaments, Agents antiplaquettaires (AAP), R58'),
  ('MG-ANES-000092-R59', 'Si le patient est sous clopidogrel seul et que la chirurgie ne peut pas être réalisée sous ce médicament, il est recommandé de le remplacer par de l''aspirine (en l''absence de CI).', '1+', 'Substitution du clopidogrel par l''aspirine si besoin', 'Question 3 — Revascularisation et médicaments, Agents antiplaquettaires (AAP), R59'),
  ('MG-ANES-000092-R60', 'Si le patient est sous bithérapie, il est recommandé de conserver au moins un antiplaquettaire, idéalement l''aspirine, sauf contre-indication hémorragique.', '1+', 'Bithérapie — conservation d''au moins un antiplaquettaire', 'Question 3 — Revascularisation et médicaments, Agents antiplaquettaires (AAP), R60'),
  ('MG-ANES-000092-R61', 'Après la chirurgie et en concertation avec le chirurgien, il est recommandé de reprendre précocement le traitement antiplaquettaire interrompu (dose de charge possible si risque thrombotique élevé).', '2+', 'Reprise postopératoire du traitement antiplaquettaire', 'Question 3 — Revascularisation et médicaments, Agents antiplaquettaires (AAP), R61'),
  ('MG-ANES-000092-R62', 'Chez les coronariens, il est recommandé de maintenir les IEC/ARA2 en périopératoire lorsqu''ils sont prescrits pour une insuffisance cardiaque (tenir compte alors du risque d''hypotension en chirurgie majeure ou rachianesthésie).', '1+', 'Maintien périopératoire des IEC/ARA2 pour insuffisance cardiaque', 'Question 3 — Revascularisation et médicaments, IEC/ARA2 — dérivés nitrés — inhibiteurs calciques, R62'),
  ('MG-ANES-000092-R63', 'Il est recommandé d''interrompre un IEC/ARA2 au moins 12 h avant l''intervention lorsqu''il constitue un traitement de fond de l''hypertension.', '1+', 'Interruption préopératoire des IEC/ARA2 pour hypertension', 'Question 3 — Revascularisation et médicaments, IEC/ARA2 — dérivés nitrés — inhibiteurs calciques, R63'),
  ('MG-ANES-000092-R64', 'L''administration de dérivés nitrés (quelle que soit la voie) n''est pas recommandée en prévention des complications cardiaques périopératoires.', '1-', 'Dérivés nitrés non recommandés en prévention', 'Question 3 — Revascularisation et médicaments, IEC/ARA2 — dérivés nitrés — inhibiteurs calciques, R64'),
  ('MG-ANES-000092-R65', 'Il n''est pas recommandé d''administrer un inhibiteur calcique pour la prévention des complications cardiaques périopératoires.', '1-', 'Inhibiteurs calciques non recommandés en prévention', 'Question 3 — Revascularisation et médicaments, IEC/ARA2 — dérivés nitrés — inhibiteurs calciques, R65')
) as v(code, statement, grade, condition_topic, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-du-coronarien-opere-en-chirurgie-non-cardiaque/'
on conflict (recommendation_code) do nothing;
