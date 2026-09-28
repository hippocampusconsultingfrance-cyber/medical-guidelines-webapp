-- Migration : Prise en charge des surdosages en antivitamines K (AVK), des
-- situations à risque hémorragique et des accidents hémorragiques chez les
-- patients traités par AVK en ville et en milieu hospitalier (GEHT, en
-- partenariat avec la HAS, Recommandations professionnelles, avril 2008)
-- Source : rfe-sfar-website/build/content_recommandations_avk.json (62
-- recommandations atomiques identifiées à la lecture, sur les chapitres 2
-- (surdosage, dont les 7 cellules actionnables du Tableau 1), 3
-- (hémorragies), 4.1-4.2 (chirurgie/relais héparinique), 4.3-4.4
-- (modalités du relais + prise en charge par indication) et 4.5 (acte
-- urgent)).
--
-- ⚠️ PROVENANCE — DISCLOSURE OBLIGATOIRE : `content_recommandations_avk.json`
-- fait partie des 9 fichiers "KNOWN DRIFT" documentés dans
-- `rfe-sfar-website/CLAUDE.md` — récupéré depuis l'Artifact publié en
-- ligne sans qu'aucun `fiche_*.py` ni fichier source n'ait jamais été
-- committé dans ce dépôt. Ce contenu N'A PAS suivi le pipeline de
-- triple-lecture + audit indépendant normalement exigé par ce projet et
-- N'A PAS été re-vérifié contre le PDF source par cette migration. Statut
-- `draft` comme toute migration, mais attention de relecture supérieure
-- recommandée (même disclosure que `examens_preinterventionnels`/0065 et
-- les fiches suivantes de ce lot).
--
-- MÉTHODOLOGIE — grades HAS A/B/C + « accord professionnel » (AP), à la
-- différence du GRADE 1+/2+ utilisé ailleurs dans ce corpus (même schéma
-- que `avc_precoce`/0069, `transfusion_plasma`/0049). `grade` reproduit la
-- lettre/sigle tel quel. `evidence_level` laissé NULL (pas de niveau
-- distinct du grade HAS/AP). Vérifié exhaustivement par la fiche
-- construite (grep sur texte aplati) : 28 citations "(grade X)" explicites
-- dans le corps du texte — 5xA, 2xB, 21xC — reconciliées EXACTEMENT avec le
-- décompte des lignes migrées ci-dessous (voir vérification en base après
-- exécution). Le reste des énoncés repose sur un accord professionnel
-- (AP) ou, pour 9 lignes, sur une absence totale de tag dans la source
-- (grade NULL, PAS un "AP" par défaut ni un grade deviné).
--
-- DISCLOSURE DÉJÀ FAITE PAR LA FICHE SOURCE (reproduite ici, PAS résolue
-- silencieusement) : 2 énoncés cliniquement très analogues à des clauses
-- gradées C dans la même sous-section n'ont, dans la source, AUCUN tag de
-- grade imprimé — retranscrits ici avec 'AP' plutôt qu'un 'C' inventé par
-- analogie : (1) relais préopératoire AVK chez le patient ACFA à haut
-- risque thromboembolique (§4.2, R39 ci-dessous — la source cite "niveau
-- de preuve 2" en prose mais n'imprime aucun tag "(grade X)" sur cette
-- clause précise) ; (2) clause MTEV "risque de récidive modéré" (§4.4, R55
-- ci-dessous — clause symétrique de son équivalent "haut risque" gradé C,
-- mais elle-même non taguée par la source).
--
-- POPULATION : renseigné explicitement pour les clauses par indication de
-- traitement (§4.2/4.4) — 'Prothèse valvulaire mécanique', 'ACFA...',
-- 'MTEV...' — NULL ailleurs.
--
-- PÉRIMÈTRE — volontairement pas migrés en recommandations distinctes
-- (disclosure, pas un oubli) :
-- 1. La cellule "INR mesuré < 4 / INR cible >= 3" du Tableau 1 : la source
--    elle-même la marque d'un hachurage diagonal ("sans objet" — un
--    INR < 4 n'est par définition pas un surdosage relatif à une cible
--    >= 3), pas une recommandation.
-- 2. Annexe 1 (risque hémorragique des actes invasifs de rhumatologie, 22
--    lignes type d'acte -> niveau 1/2/3) : grille de classification citée
--    en soutien de R35, pas une proposition clinique en soi — même
--    traitement que les tableaux de classification déjà exclus ailleurs
--    dans ce corpus (Annexe A ACC/AHA de `examens_preinterventionnels`/
--    0065).
-- 3. Annexe 2 (exemple de relais préopératoire AVK-héparine, calendrier
--    J-5 à J0) : illustration chronologique d'un seul cas d'école, déjà
--    couverte en substance par R43 (modalités générales du relais
--    préopératoire) — pas une proposition distincte.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. GEHT (Groupe d'Étude sur l'Hémostase et la Thrombose), promoteur
--    principal de ce texte, ne figure pas dans le seed Annexe B — seule
--    la HAS (partenaire méthodologique) est liée en `document_societies`
--    (même traitement que GEHT hors seed ailleurs dans ce corpus, ex.
--    `mtev_perioperatoire`/0033, `tih`/0047).
-- 2. `library_final.json` ne donne que le mois/année ("avril 2008" cité
--    par la source elle-même, date de validation du Collège de la HAS) —
--    `publication_date` utilise 2008-04-01 par convention (même
--    traitement que `avc_precoce`/0069).
-- 3. Freshness : contrairement à `avc_precoce`/0069 et
--    `infarctus_myocarde`/0068, l'avertissement de cette fiche ne déclare
--    PAS explicitement que "les stratégies ont évolué" — il se limite à
--    recommander de vérifier l'actualité des disponibilités commerciales
--    et posologies des spécialités citées (Kaskadil®, Octaplex®).
--    `freshness_status` laissé à 'a_jour' en conséquence (le critère
--    "disclosure explicite de péremption par la source elle-même" n'est
--    ici que partiellement rempli) — un relecteur humain pourrait
--    légitimement juger que ce document de 2008 sur la gestion des AVK
--    mériterait 'revision_detectee' compte tenu de l'essor des AOD depuis,
--    sujet que la source elle-même n'aborde pas (trop tôt en 2008).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge des surdosages en antivitamines K, des situations à risque hémorragique et des accidents hémorragiques chez les patients traités par antivitamines K en ville et en milieu hospitalier',
  'RBP', 'fr', '2008-04-01',
  'https://sfar.org/prise-en-charge-des-surdosages-en-antivitamines-k-des-situations-a-risque-hemorragique-et-des-accidents-hemorragiques-chez-les-patients-traites-par-antivitamines-k-en-ville-et-en-milieu-hospitalier/',
  'https://sfar.org/wp-content/uploads/2015/10/2_HAS_Prise-en-charge-des-surdosages-en-antivitamines-K.pdf',
  'Grades HAS A/B/C + "accord professionnel" (AP), à la différence du GRADE 1+/2+ utilisé ailleurs dans ce corpus. 28 citations "(grade X)" explicites dans le corps du texte (5xA, 2xB, 21xC), vérifiées par grep exhaustif et reconciliées exactement avec les lignes migrées. 2 clauses cliniquement analogues à des clauses gradées C n''ont aucun tag imprimé par la source (retranscrites AP, jamais un C inventé par analogie). evidence_level non applicable.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-des-surdosages-en-antivitamines-k-des-situations-a-risque-hemorragique-et-des-accidents-hemorragiques-chez-les-patients-traites-par-antivitamines-k-en-ville-et-en-milieu-hospitalier/'
  and s.acronym = 'HAS' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-des-surdosages-en-antivitamines-k-des-situations-a-risque-hemorragique-et-des-accidents-hemorragiques-chez-les-patients-traites-par-antivitamines-k-en-ville-et-en-milieu-hospitalier/'
  and s.slug in ('hematologie', 'anesthesie_reanimation', 'medecine_d_urgence')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.condition_topic, v.source_section,
  'https://sfar.org/prise-en-charge-des-surdosages-en-antivitamines-k-des-situations-a-risque-hemorragique-et-des-accidents-hemorragiques-chez-les-patients-traites-par-antivitamines-k-en-ville-et-en-milieu-hospitalier/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000070-R01', 'Privilégier une prise en charge ambulatoire, si le contexte médical et social le permet. L''hospitalisation est préférable s''il existe un ou plusieurs facteurs de risque hémorragique individuel (âge, antécédent hémorragique, comorbidité). En l''absence d''hospitalisation : informer le patient et son entourage du risque hémorragique à court terme et des signes d''alerte (tout saignement, même minime, ou symptôme nouveau → consultation médicale sans délai).', 'AP', null, null, '2 — Conduite à tenir en cas de surdosage asymptomatique'),
  ('MG-ANES-000070-R02', 'Pas de saut de prise. Pas d''apport de vitamine K.', null, null, 'Tableau 1 — INR < 4, INR cible 2,5 (fenêtre 2-3)', '2 — Conduite à tenir en cas de surdosage asymptomatique'),
  ('MG-ANES-000070-R03', 'Saut d''une prise. Pas d''apport de vitamine K.', null, null, 'Tableau 1 — 4 <= INR < 6, INR cible 2,5', '2 — Conduite à tenir en cas de surdosage asymptomatique'),
  ('MG-ANES-000070-R04', 'Pas de saut de prise. Pas d''apport de vitamine K.', null, null, 'Tableau 1 — 4 <= INR < 6, INR cible >= 3 (fenêtre 2,5-3,5 ou 3-4,5)', '2 — Conduite à tenir en cas de surdosage asymptomatique'),
  ('MG-ANES-000070-R05', 'Arrêt du traitement par AVK. 1 à 2 mg de vitamine K par voie orale (1/2 à 1 ampoule buvable forme pédiatrique).', 'A', null, 'Tableau 1 — 6 <= INR < 10, INR cible 2,5', '2 — Conduite à tenir en cas de surdosage asymptomatique'),
  ('MG-ANES-000070-R06', 'Saut d''une prise. Avis spécialisé (ex. cardiologue si prothèse valvulaire mécanique) recommandé pour discuter un traitement éventuel par 1 à 2 mg de vitamine K par voie orale.', null, null, 'Tableau 1 — 6 <= INR < 10, INR cible >= 3', '2 — Conduite à tenir en cas de surdosage asymptomatique'),
  ('MG-ANES-000070-R07', 'Arrêt du traitement par AVK. 5 mg de vitamine K par voie orale (1/2 ampoule buvable forme adulte).', 'A', null, 'Tableau 1 — INR >= 10, INR cible 2,5', '2 — Conduite à tenir en cas de surdosage asymptomatique'),
  ('MG-ANES-000070-R08', 'Avis spécialisé sans délai ou hospitalisation recommandé.', null, null, 'Tableau 1 — INR >= 10, INR cible >= 3', '2 — Conduite à tenir en cas de surdosage asymptomatique'),
  ('MG-ANES-000070-R09', 'À faire dans tous les cas : rechercher la cause du surdosage (prise en compte pour l''adaptation éventuelle de la posologie). Contrôle de l''INR le lendemain. En cas de persistance d''un INR suprathérapeutique, les mesures du Tableau 1 restent valables et doivent être reconduites. Surveillance ultérieure de l''INR calquée sur celle de la mise en route du traitement.', 'AP', null, null, '2 — Conduite à tenir en cas de surdosage asymptomatique'),
  ('MG-ANES-000070-R10', 'Prise en charge ambulatoire par le médecin traitant, si l''environnement médico-social et le type d''hémorragie le permettent (ex. épistaxis rapidement contrôlable).', 'AP', null, null, '3 — Hémorragie non grave'),
  ('MG-ANES-000070-R11', 'Mesure de l''INR en urgence. En cas de surdosage : mêmes mesures de correction que pour le surdosage asymptomatique (Tableau 1). Recherche de la cause du saignement. Absence de contrôle de l''hémorragie par les moyens usuels = critère de gravité → indication de prise en charge hospitalière pour antagonisation rapide.', 'AP', null, null, '3 — Hémorragie non grave'),
  ('MG-ANES-000070-R12', 'Ne pas utiliser le plasma dans le seul but d''antagonisation des effets des AVK, sauf en cas d''indisponibilité d''un CCP.', 'B', null, null, '3 — Médicaments utilisables en cas d''hémorragie grave'),
  ('MG-ANES-000070-R13', 'Ne pas utiliser le facteur VII activé recombinant (eptacog alpha, NovoSeven®) dans le but d''antagonisation des effets des AVK.', 'C', null, null, '3 — Médicaments utilisables en cas d''hémorragie grave'),
  ('MG-ANES-000070-R14', 'Prise en charge hospitalière obligatoire. Formalisation de procédures organisationnelles pluridisciplinaires (améliore rapidité et qualité de la prise en charge). Geste hémostatique (chirurgical, endoscopique, endovasculaire) discuté rapidement avec chirurgiens/radiologues.', 'AP', null, null, '3 — Conduite à tenir en cas d''hémorragie grave'),
  ('MG-ANES-000070-R15', 'Mesurer l''INR en urgence à l''admission — la mise en route du traitement ne doit pas attendre le résultat si celui-ci ne peut être obtenu rapidement ; INR par microméthode au lit du patient si délai prévisible > 30-60 min. Objectif : restauration d''une hémostase normale (INR < 1,5) dans un délai le plus bref possible (quelques minutes).', 'AP', null, null, '3 — Conduite à tenir en cas d''hémorragie grave'),
  ('MG-ANES-000070-R16', 'Arrêter l''AVK.', 'AP', null, null, '3 — Conduite à tenir en cas d''hémorragie grave'),
  ('MG-ANES-000070-R17', 'Administrer en urgence du CCP et de la vitamine K.', 'C', null, null, '3 — Conduite à tenir en cas d''hémorragie grave'),
  ('MG-ANES-000070-R18', 'Assurer simultanément le traitement usuel d''une éventuelle hémorragie massive (correction de l''hypovolémie, transfusion de culots globulaires si besoin).', 'AP', null, null, '3 — Conduite à tenir en cas d''hémorragie grave'),
  ('MG-ANES-000070-R19', 'En l''absence de circuit d''approvisionnement rapide : réserve de quelques flacons de CCP dans les services concernés (urgences, réanimation, certains blocs opératoires), en accord avec la pharmacie.', 'AP', null, null, '3 — Conduite à tenir en cas d''hémorragie grave'),
  ('MG-ANES-000070-R20', 'Dose de CCP si l''INR contemporain de l''hémorragie n''est pas disponible : 25 UI/kg d''équivalent facteur IX (1 ml/kg pour un CCP dosé à 25 U/ml). Si l''INR contemporain est disponible : dose suivant le RCP de la spécialité utilisée.', 'C', null, null, '3 — Conduite à tenir en cas d''hémorragie grave'),
  ('MG-ANES-000070-R21', 'Vitesse d''injection IV du CCP : 4 ml/min préconisé par les fabricants (des données préliminaires indiquent qu''un bolus de 3 min obtient un taux de correction comparable, niveau de preuve 4).', null, null, null, '3 — Conduite à tenir en cas d''hémorragie grave'),
  ('MG-ANES-000070-R22', 'Administrer 10 mg de vitamine K par voie orale ou IV lente en même temps que le CCP, quel que soit l''INR de départ.', 'C', null, null, '3 — Conduite à tenir en cas d''hémorragie grave'),
  ('MG-ANES-000070-R23', 'Contrôles biologiques : INR à 30 min après le CCP (complément de CCP si INR > 1,5, adapté au RCP) ; INR à 6-8h puis quotidien pendant la période critique.', 'AP', null, null, '3 — Conduite à tenir en cas d''hémorragie grave'),
  ('MG-ANES-000070-R24', 'Mesurer l''INR en urgence et adopter la même conduite que pour les hémorragies spontanées (grave ou non grave), suivant la nature du traumatisme.', 'AP', null, null, '3 — Patient victime d''un traumatisme'),
  ('MG-ANES-000070-R25', 'Traumatisme crânien : hospitalisation systématique pour surveillance >= 24h. Scanner cérébral immédiat si symptomatologie neurologique.', 'AP', null, null, '3 — Patient victime d''un traumatisme'),
  ('MG-ANES-000070-R26', 'Traumatisme crânien sans symptomatologie neurologique : scanner cérébral dans un délai rapide (4 à 6 heures).', 'C', null, null, '3 — Patient victime d''un traumatisme'),
  ('MG-ANES-000070-R27', 'Si l''indication des AVK est maintenue et le saignement contrôlé : traitement par héparine (HNF ou HBPM) à dose curative en parallèle de la reprise des AVK, en milieu hospitalier sous surveillance clinique et biologique. Modalités fonction du siège de l''hémorragie et de l''indication des AVK.', 'AP', null, null, 'Réintroduction des AVK après une hémorragie grave'),
  ('MG-ANES-000070-R28', 'Hémorragie intracrânienne, patient porteur d''une prothèse valvulaire mécanique (PVM) : la PVM impose la reprise d''une anticoagulation au long cours.', 'A', 'Prothèse valvulaire mécanique', null, 'Réintroduction des AVK après une hémorragie grave'),
  ('MG-ANES-000070-R29', 'Hémorragie intracrânienne, patient porteur d''une PVM : fenêtre thérapeutique de normocoagulation de 1 à 2 semaines proposée (discussion multidisciplinaire souhaitable pour en fixer la durée).', 'C', 'Prothèse valvulaire mécanique', null, 'Réintroduction des AVK après une hémorragie grave'),
  ('MG-ANES-000070-R30', 'Hémorragie intracrânienne à localisation hémisphérique et ACFA non valvulaire : arrêt définitif du traitement anticoagulant recommandé.', 'A', 'ACFA non valvulaire', null, 'Réintroduction des AVK après une hémorragie grave'),
  ('MG-ANES-000070-R31', 'Hémorragie intracrânienne, patient ayant une MTEV : fenêtre thérapeutique de normocoagulation de 1 à 2 semaines proposée (discussion multidisciplinaire ; filtre cave discuté si MTEV < 1 mois).', 'C', 'MTEV', null, 'Réintroduction des AVK après une hémorragie grave'),
  ('MG-ANES-000070-R32', 'Autres hémorragies graves : fenêtre thérapeutique de 48 à 72h, modulée selon le risque thromboembolique. Reprise d''autant plus précoce qu''un geste hémostatique garantit une faible probabilité de récidive.', 'AP', null, null, 'Réintroduction des AVK après une hémorragie grave'),
  ('MG-ANES-000070-R33', 'Chirurgie cutanée, dans la zone thérapeutique usuelle (INR 2-3), après vérification de l''absence de surdosage.', 'C', null, null, '4.1 — Procédures réalisables sans interrompre les AVK'),
  ('MG-ANES-000070-R34', 'Chirurgie de la cataracte, dans la zone thérapeutique usuelle.', 'C', null, null, '4.1 — Procédures réalisables sans interrompre les AVK'),
  ('MG-ANES-000070-R35', 'Actes de rhumatologie à faible risque hémorragique (voir Annexe 1) ; certains actes bucco-dentaires et d''endoscopie digestive (se référer aux recommandations des sociétés spécialisées correspondantes).', null, null, null, '4.1 — Procédures réalisables sans interrompre les AVK'),
  ('MG-ANES-000070-R36', 'Dans les autres cas : arrêt des AVK ou antagonisation en urgence. Seuil d''INR <= 1,5 (<= 1,2 en neurochirurgie) retenu comme absence de majoration du risque hémorragique périopératoire. Injections sous-cutanées possibles sans interrompre les AVK ; injections intramusculaires déconseillées (risque hémorragique).', 'AP', null, null, '4.1 — Procédures réalisables sans interrompre les AVK'),
  ('MG-ANES-000070-R37', 'Risque thromboembolique élevé (selon l''indication du traitement AVK) : relais pré- et postopératoire par héparine à dose curative. Dans les autres cas : relais postopératoire recommandé si la reprise des AVK à 24-48h postopératoires est impossible (voie entérale indisponible).', 'AP', null, null, '4.2 — Situations imposant un relais héparinique (acte programmé)'),
  ('MG-ANES-000070-R38', 'PVM cardiaque, quel que soit le type : relais pré- et postopératoire des AVK par les héparines recommandé.', 'C', 'Prothèse valvulaire mécanique', null, '4.2 — Situations imposant un relais héparinique (acte programmé)'),
  ('MG-ANES-000070-R39', 'ACFA à haut risque thromboembolique (ATCD d''AVC/AIT ou d''embolie systémique) : relais pré- et postopératoire des AVK par les héparines recommandé.', 'AP', 'ACFA à haut risque thromboembolique', null, '4.2 — Situations imposant un relais héparinique (acte programmé)'),
  ('MG-ANES-000070-R40', 'ACFA, autres cas : l''anticoagulation par AVK peut être interrompue sans relais préopératoire (reprise à 24-48h postopératoires).', 'C', 'ACFA', null, '4.2 — Situations imposant un relais héparinique (acte programmé)'),
  ('MG-ANES-000070-R41', 'MTEV à haut risque thromboembolique (épisode < 3 mois, ou maladie récidivante idiopathique >= 2 épisodes dont >= 1 sans facteur déclenchant) : relais pré- et postopératoire des AVK par les héparines recommandé.', 'C', 'MTEV à haut risque thromboembolique', null, '4.2 — Situations imposant un relais héparinique (acte programmé)'),
  ('MG-ANES-000070-R42', 'MTEV, autres cas : l''anticoagulation par AVK peut être interrompue sans relais préopératoire (reprise à 24-48h postopératoires).', 'C', 'MTEV', null, '4.2 — Situations imposant un relais héparinique (acte programmé)'),
  ('MG-ANES-000070-R43', 'Relais préopératoire : mesurer l''INR 7 à 10 jours avant l''intervention. Si en zone thérapeutique : arrêter l''AVK 4-5 jours avant l''intervention (tous AVK), débuter l''héparine à dose curative 48h après la dernière prise de fluindione/warfarine, ou 24h après la dernière prise d''acénocoumarol. Si hors zone thérapeutique : avis de l''équipe médico-chirurgicale. Hospitaliser au plus tard la veille si le relais n''est pas géré en ville. INR la veille de l''intervention ; si INR > 1,5 : 5 mg de vitamine K per os (contrôle le matin de l''intervention). Interventions programmées de préférence le matin. Arrêt préopératoire des héparines : HNF IV à la seringue électrique 4-6h avant ; HNF SC 8-12h avant ; HBPM, dernière dose 24h avant.', null, null, null, '4.3 — Modalités du relais héparinique (acte programmé)'),
  ('MG-ANES-000070-R44', 'Relais postopératoire : héparines à dose curative reprises 6-48h postopératoires selon le risque hémorragique/thromboembolique (jamais avant la 6e heure — si la reprise à dose curative n''est pas possible dès la 6e heure, prévention postopératoire de la MTEV selon les modalités habituelles). AVK repris dans les 24 premières heures (sinon dès que possible), aux posologies habituelles, sans dose de charge. Si voie entérale indisponible > 24-48h : poursuivre l''héparine à dose curative jusqu''à reprise possible des AVK. Héparine interrompue après 2 INR successifs en zone thérapeutique à 24h d''intervalle.', null, null, null, '4.3 — Modalités du relais héparinique (acte programmé)'),
  ('MG-ANES-000070-R45', 'Relais des AVK par des héparines recommandé en périopératoire.', 'C', 'Prothèse valvulaire mécanique cardiaque', null, '4.4 — Patient porteur d''une valve mécanique cardiaque'),
  ('MG-ANES-000070-R46', 'Relais possible par HBPM (hors AMM, dose curative, 2 injections SC/jour — enoxaparine ou dalteparine), par HNF IV à la seringue électrique, ou par HNF SC (2-3 injections/jour) à dose curative : ces trois options sont possibles.', 'B', 'Prothèse valvulaire mécanique cardiaque', null, '4.4 — Patient porteur d''une valve mécanique cardiaque'),
  ('MG-ANES-000070-R47', 'En l''absence de données périopératoires, pour les procédures à risque hémorragique modéré ou élevé : l''HBPM à dose curative en une injection/jour ou le fondaparinux ne peuvent être recommandés. Héparines à dose curative dans les 6-48h postopératoires (jamais avant la 6e heure ; sinon prévention MTEV postopératoire précoce habituelle).', 'AP', 'Prothèse valvulaire mécanique cardiaque', null, '4.4 — Patient porteur d''une valve mécanique cardiaque'),
  ('MG-ANES-000070-R48', 'Risque thromboembolique élevé : relais préopératoire des AVK par HBPM ou HNF à dose curative recommandé.', 'C', 'ACFA à risque thromboembolique élevé', null, '4.4 — Patient traité pour arythmie chronique par fibrillation auriculaire (ACFA)'),
  ('MG-ANES-000070-R49', 'Risque thromboembolique élevé : relais préférentiellement par des HBPM.', 'C', 'ACFA à risque thromboembolique élevé', null, '4.4 — Patient traité pour arythmie chronique par fibrillation auriculaire (ACFA)'),
  ('MG-ANES-000070-R50', 'Risque thromboembolique faible ou modéré : l''anticoagulation par AVK peut être interrompue sans relais préopératoire. Si reprise des AVK impossible à 24-48h postopératoires : relais postopératoire par HBPM ou HNF à dose curative à envisager.', 'C', 'ACFA à risque thromboembolique faible ou modéré', null, '4.4 — Patient traité pour arythmie chronique par fibrillation auriculaire (ACFA)'),
  ('MG-ANES-000070-R51', 'Dans tous les cas, en l''absence de données périopératoires, pour les procédures à risque hémorragique modéré ou élevé : HBPM à dose curative en une injection/jour ou fondaparinux non recommandés.', 'AP', 'ACFA', null, '4.4 — Patient traité pour arythmie chronique par fibrillation auriculaire (ACFA)'),
  ('MG-ANES-000070-R52', 'Haut risque de récidive : différer une chirurgie réglée si possible, au minimum au-delà du 1er mois suivant l''épisode, de préférence au-delà du 3e mois.', 'AP', 'MTEV à haut risque de récidive', null, '4.4 — Patient traité pour un antécédent de MTEV'),
  ('MG-ANES-000070-R53', 'Haut risque de récidive, chirurgie dans le 1er mois : mise en place d''un filtre cave préopératoire (éventuellement optionnel) à discuter.', 'C', 'MTEV à haut risque de récidive', null, '4.4 — Patient traité pour un antécédent de MTEV'),
  ('MG-ANES-000070-R54', 'Haut risque de récidive : relais préopératoire des AVK par HBPM à dose curative ou par HNF (IV à la seringue électrique ou SC 2-3 injections/jour) recommandé.', 'C', 'MTEV à haut risque de récidive', null, '4.4 — Patient traité pour un antécédent de MTEV'),
  ('MG-ANES-000070-R55', 'Risque de récidive modéré : l''anticoagulation par AVK peut être interrompue sans relais préopératoire ; reprise des AVK recommandée à 24-48h postopératoires (sinon relais postopératoire par HBPM/HNF à dose curative).', 'AP', 'MTEV à risque de récidive modéré', null, '4.4 — Patient traité pour un antécédent de MTEV'),
  ('MG-ANES-000070-R56', 'Dans tous les cas (MTEV) : prévention postopératoire précoce de la MTEV réalisée jusqu''à ce que l''INR soit en zone thérapeutique (ou la reprise des héparines à dose curative). En l''absence de données périopératoires, le fondaparinux à dose curative ne peut être recommandé. Privilégier l''HBPM à dose curative en 2 injections/jour ; l''HBPM en une injection/jour peut être discutée au cas par cas.', 'AP', 'MTEV', null, '4.4 — Patient traité pour un antécédent de MTEV'),
  ('MG-ANES-000070-R57', 'Mesurer l''INR à l''admission du patient.', 'AP', null, null, '4.5 — Chirurgie ou acte invasif urgent à risque hémorragique'),
  ('MG-ANES-000070-R58', 'Administration de CCP recommandée, selon les modalités de la prise en charge de l''hémorragie grave.', 'C', null, null, '4.5 — Chirurgie ou acte invasif urgent à risque hémorragique'),
  ('MG-ANES-000070-R59', 'Associer 5 mg de vitamine K à l''administration de CCP, sauf si la correction de l''hémostase n''est nécessaire que pendant moins de 4 heures.', 'C', null, null, '4.5 — Chirurgie ou acte invasif urgent à risque hémorragique'),
  ('MG-ANES-000070-R60', 'Privilégier la voie entérale pour la vitamine K, lorsqu''elle est possible.', 'A', null, null, '4.5 — Chirurgie ou acte invasif urgent à risque hémorragique'),
  ('MG-ANES-000070-R61', 'INR recommandé dans les 30 min suivant le CCP et avant l''acte (complément de CCP si insuffisamment corrigé) ; INR à 6-8h après l''antagonisation.', 'AP', null, null, '4.5 — Chirurgie ou acte invasif urgent à risque hémorragique'),
  ('MG-ANES-000070-R62', 'Si l''acte est compatible avec une réversion par la seule vitamine K (délai 6-24h selon l''INR) : CCP non nécessaire ; vitamine K 5-10 mg (voie entérale si possible) ; INR répété toutes les 6-8h jusqu''à l''intervention. Prise en charge postopératoire identique à celle d''un acte programmé.', 'AP', null, null, '4.5 — Chirurgie ou acte invasif urgent à risque hémorragique')
) as v(code, statement, grade, population, condition_topic, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-des-surdosages-en-antivitamines-k-des-situations-a-risque-hemorragique-et-des-accidents-hemorragiques-chez-les-patients-traites-par-antivitamines-k-en-ville-et-en-milieu-hospitalier/'
on conflict (recommendation_code) do nothing;
