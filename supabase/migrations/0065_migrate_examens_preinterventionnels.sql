-- Migration : Examens pré-interventionnels systématiques (SFAR, RFE 2012,
-- actualisation des recommandations Anaes 1998)
-- Source : rfe-sfar-website/build/content_examens_preinterventionnels.json
-- (38 recommandations atomiques — le document source lui-même les regroupe
-- sous 9 références "R1"-"R9" par grand thème d'examen, chaque référence
-- couvrant plusieurs propositions individuellement graduées : 6+3+7+2+6+3+
-- 4+3+4 = 38, exactement le compte que la fiche source annonce elle-même
-- : "38 recommandations tagués (14x 1+, 14x 1-, 9x 2+, 1x 2-)").
--
-- ⚠️ PROVENANCE — DISCLOSURE OBLIGATOIRE (lire avant de faire confiance à ce
-- contenu comme aux autres migrations de ce lot) : `content_examens_
-- preinterventionnels.json` fait partie des 9 fichiers "KNOWN DRIFT"
-- documentés dans `rfe-sfar-website/CLAUDE.md` — récupérés depuis l'Artifact
-- publié en ligne (le 11/09/2026) sans qu'aucun `fiche_*.py` ni fichier
-- source (PDF/texte extrait) n'ait jamais été committé dans ce dépôt. Ce
-- contenu N'A PAS suivi le pipeline de triple-lecture + audit indépendant
-- normalement exigé par ce projet (voir standing quality bar du CLAUDE.md
-- cité) et n'a PAS été re-vérifié contre le PDF source par cette migration
-- (qui travaille uniquement à partir du JSON déjà construit, comme l'exige
-- la Tâche 1). Statut `draft` (jamais `active`) ci-dessous, comme pour
-- toute migration — mais un relecteur humain devrait accorder une attention
-- PARTICULIÈRE à ce document avant validation, plus qu'aux fiches
-- git-natives auditées de ce corpus (ex. `bris_dentaires`/0063,
-- `sujet_age_esf`/0064).
--
-- MÉTHODOLOGIE GRADE — Grade 1+/1- ("forte", il faut faire/ne pas faire) ;
-- Grade 2+/2- ("faible", il est possible de faire/ne pas faire). `grade`
-- reproduit le chip déjà résolu dans le JSON construit. `evidence_level`
-- laissé NULL (pas de niveau de preuve distinct du tag de force, même
-- convention que `sepsis`/0044, `sujet_age_esf`/0064). DISCLOSURE DÉJÀ
-- FAITE PAR LA FICHE CONSTRUITE (reproduite ici, pas résolue à nouveau par
-- cette migration) : la source omet le signe +/- sur 13 des 38 tags
-- (imprime juste "GRADE 1" ou "GRADE 2") ; le signe a été résolu par le
-- pipeline de construction à partir du sens univoque de chaque phrase
-- ("il est recommandé de ne pas prescrire..." = négatif), jamais le
-- niveau (1 vs 2, toujours explicite dans la source) — la fiche construite
-- ne précise pas QUELLES lignes parmi les 38 sont concernées par cette
-- résolution ; cette migration reproduit donc les chips déjà résolus sans
-- pouvoir distinguer, ligne par ligne, un signe imprimé tel quel d'un
-- signe inféré.
--
-- PÉRIMÈTRE — volontairement pas migrés en recommandations distinctes
-- (disclosure, pas un oubli) :
-- 1. Tableau 1 (indication de l'analyse d'urine par type de chirurgie x
--    niveau de risque IU/CU) : reproduit intégralement le contenu déjà
--    couvert par les 4 propositions graduées R35-R38 (dépistage
--    infectieux), sous forme de grille croisée plutôt que de propositions
--    votées séparément — même traitement que les tableaux de synthèse déjà
--    exclus ailleurs dans ce corpus (ex. Tableau I de `aap_programmee`/0005).
-- 2. Tableau 2 (synthèse ASA x risque opératoire, "pas d'examens
--    complémentaires systématiques" / "prescription en fonction du
--    risque") : résumé de haut niveau des 38 recommandations déjà migrées,
--    pas une proposition supplémentaire distincte.
-- 3. Annexe A (stratification du risque cardiaque ACC/AHA : faible <1%,
--    intermédiaire 1-5%, élevé >5%, avec exemples de chirurgies) : grille
--    de classification citée en soutien de R01-R06 (examens cardiologiques),
--    pas une recommandation en soi.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Sociétés validatrices hors seed Annexe B : AFC, AFU, EFS, SCGP, SFCD,
--    GEHT, SF2H, SOFOP, SFORL, SFR-FRI, SFSCMF, SPLF — non liées en
--    `document_societies`. CNGOF et SFC, en revanche, figurent dans le
--    seed Annexe B et SONT liées ci-dessous (avec SFAR), contrairement au
--    traitement "SFAR seule" appliqué aux autres migrations de ce lot pour
--    des co-sociétés toutes hors seed.
-- 2. `library_final.json` ne donne que l'année de publication ("2012", pas
--    de mois/jour) — `publication_date` utilise 2012-01-01 par convention
--    (même traitement que `allergie_prevention`/0006).
-- 3. `population` laissé NULL sauf mentions explicites (R28-R31 : femme
--    enceinte ; R15 : enfant n'ayant pas acquis la marche ; R32-R34 :
--    femme en âge de procréer) — ces mentions sont conservées en clair
--    dans `statement`/`condition_topic` mais PAS dupliquées dans la colonne
--    `population` par cette migration (le schéma ne force pas une seule
--    valeur par ligne et le texte source mêle souvent condition et
--    population dans la même phrase ; à trancher par la relecture humaine
--    si une normalisation par population est souhaitée).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Examens pré-interventionnels systématiques',
  'RFE', 'fr', '2012-01-01',
  'https://sfar.org/examens-preinterventionnels-systematiques/',
  'https://sfar.org/wp-content/uploads/2015/10/AFAR_Examens-preinterventionnels-systematiques.pdf',
  'GRADE — 1+/1- (force forte) ou 2+/2- (force faible). 38 recommandations regroupées sous 9 références R1-R9 par thème d''examen. La source omet le signe +/- sur 13 des 38 tags (imprime "GRADE 1"/"GRADE 2" seul) ; signe résolu par le pipeline de construction à partir du sens de la phrase, niveau (1 vs 2) toujours explicite. evidence_level non applicable (pas de niveau de preuve distinct du tag de force).',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/examens-preinterventionnels-systematiques/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'), ('CNGOF', 'France'), ('SFC', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/examens-preinterventionnels-systematiques/'
  and s.slug in ('anesthesie_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/examens-preinterventionnels-systematiques/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000065-R01', 'ECG de repos — quel que soit l''âge : ne pas prescrire un nouvel ECG si un tracé de moins de 12 mois est disponible sans modification clinique.', '1-', '1 — Examens cardiologiques (Réf. R1)'),
  ('MG-ANES-000065-R02', 'Ne pas prescrire un ECG de repos pour une intervention mineure.', '1-', '1 — Examens cardiologiques (Réf. R1)'),
  ('MG-ANES-000065-R03', 'ECG de repos — avant 65 ans : ne pas prescrire un ECG 12 dérivations avant une intervention à risque intermédiaire/élevé (sauf artérielle) en l''absence de signes d''appel, FDR ou pathologie cardiovasculaire.', '1-', '1 — Examens cardiologiques (Réf. R1)'),
  ('MG-ANES-000065-R04', 'ECG de repos — après 65 ans : il faut probablement prescrire un ECG 12 dérivations avant toute intervention à risque élevé/intermédiaire, même sans signe clinique, FDR ni pathologie cardiovasculaire.', '2+', '1 — Examens cardiologiques (Réf. R1)'),
  ('MG-ANES-000065-R05', 'Échocardiographie transthoracique : ne pas prescrire de façon systématique une échocardiographie de repos préinterventionnelle.', '1-', '1 — Examens cardiologiques (Réf. R1)'),
  ('MG-ANES-000065-R06', 'Limiter les indications d''échocardiographie préinterventionnelle aux sous-groupes bénéficiaires : patients symptomatiques (dyspnée, insuffisance cardiaque inconnue/aggravée, souffle systolique non connu, suspicion d''HTAP).', '2+', '1 — Examens cardiologiques (Réf. R1)'),
  ('MG-ANES-000065-R07', 'Ne pas prescrire de manière systématique une radiographie de thorax préinterventionnelle en chirurgie non cardiothoracique, quel que soit l''âge, sauf pathologie cardiopulmonaire évolutive/aiguë.', '1-', '2 — Examens respiratoires (Réf. R2)'),
  ('MG-ANES-000065-R08', 'Ne pas prescrire de manière systématique des gaz du sang artériels préinterventionnels en chirurgie non cardiothoracique, quel que soit l''âge, sauf pathologie pulmonaire évolutive/aiguë.', '1-', '2 — Examens respiratoires (Réf. R2)'),
  ('MG-ANES-000065-R09', 'Ne pas prescrire de manière systématique des EFR préinterventionnelles en chirurgie non cardiothoracique, quel que soit l''âge, sauf pathologie pulmonaire évolutive/aiguë.', '1-', '2 — Examens respiratoires (Réf. R2)'),
  ('MG-ANES-000065-R10', 'Évaluer le risque hémorragique d''après l''anamnèse personnelle/familiale de diathèse hémorragique et l''examen physique.', '1+', '3 — Examens d''hémostase (Réf. R3)'),
  ('MG-ANES-000065-R11', 'Utiliser probablement un questionnaire standardisé de recherche de manifestations hémorragiques pour l''anamnèse.', '2+', '3 — Examens d''hémostase (Réf. R3)'),
  ('MG-ANES-000065-R12', 'Ne pas prescrire de façon systématique un bilan d''hémostase si l''anamnèse/examen clinique ne fait pas suspecter un trouble — quel que soit le grade ASA, le type d''intervention et l''âge (hors enfants n''ayant pas acquis la marche).', '1-', '3 — Examens d''hémostase (Réf. R3)'),
  ('MG-ANES-000065-R13', 'Ne pas prescrire de façon systématique un bilan d''hémostase si l''anamnèse/examen clinique ne fait pas suspecter un trouble — quel que soit le type d''anesthésie (générale, neuraxiale, blocs périphériques/combinées), y compris en obstétrique.', '1-', '3 — Examens d''hémostase (Réf. R3)'),
  ('MG-ANES-000065-R14', 'Demander un avis spécialisé en cas d''anamnèse de diathèse hémorragique évocatrice d''un trouble de l''hémostase.', '1+', '3 — Examens d''hémostase (Réf. R3)'),
  ('MG-ANES-000065-R15', 'Chez l''enfant n''ayant pas acquis la marche : prescrire probablement un TCA et une numération plaquettaire (dépistage de pathologies constitutionnelles, ex. hémophilie).', '2+', '3 — Examens d''hémostase (Réf. R3) — population : enfant n''ayant pas acquis la marche'),
  ('MG-ANES-000065-R16', 'Chez l''adulte non interrogeable : prescrire probablement un TP, un TCA et une numération plaquettaire (pathologies constitutionnelles ou acquises).', '2+', '3 — Examens d''hémostase (Réf. R3) — population : adulte non interrogeable'),
  ('MG-ANES-000065-R17', 'Intervention à risque mineur, quel que soit l''âge : ne pas prescrire un hémogramme avant l''acte.', '1-', '4 — Hémogramme (Réf. R4)'),
  ('MG-ANES-000065-R18', 'Intervention à risque intermédiaire ou élevé, quel que soit l''âge : prescrire un hémogramme avant l''acte (caractère pronostique, stratégie transfusionnelle).', '1+', '4 — Hémogramme (Réf. R4)'),
  ('MG-ANES-000065-R19', 'Risque de transfusion/saignement nul à faible : ne pas prescrire de groupage sanguin ni de RAI.', '1-', '5 — Examens immunohématologiques (Réf. R5)'),
  ('MG-ANES-000065-R20', 'Risque de transfusion intermédiaire/élevé ou de saignement important : prescrire un groupage sanguin et une RAI.', '1+', '5 — Examens immunohématologiques (Réf. R5)'),
  ('MG-ANES-000065-R21', 'Disposer des examens immunohématologiques et de leurs résultats avant l''intervention en cas de risque de saignement important (check-list « sécurité au bloc opératoire »).', '1+', '5 — Examens immunohématologiques (Réf. R5)'),
  ('MG-ANES-000065-R22', 'Disposer des examens immunohématologiques et de leurs résultats avant l''intervention en cas de risque de transfusion intermédiaire/élevé.', '1+', '5 — Examens immunohématologiques (Réf. R5)'),
  ('MG-ANES-000065-R23', 'S''assurer probablement que les examens immunohématologiques soient disponibles avec leurs résultats lors de la visite préanesthésique.', '2+', '5 — Examens immunohématologiques (Réf. R5)'),
  ('MG-ANES-000065-R24', 'Prolonger la durée de validité de la RAI négative de 3 à 21 jours si l''absence de circonstances immunisantes (transfusion, grossesse, greffe) a été vérifiée dans les 6 mois précédents.', '1+', '5 — Examens immunohématologiques (Réf. R5)'),
  ('MG-ANES-000065-R25', 'Ne pas prescrire d''examen biochimique sanguin préinterventionnel systématique, en dehors de signes d''appel, en chirurgie mineure.', '1-', '6 — Examens biochimiques (Réf. R6)'),
  ('MG-ANES-000065-R26', 'Évaluer probablement la fonction rénale (débit de filtration glomérulaire) préopératoire chez les patients à risque devant bénéficier d''une chirurgie intermédiaire ou majeure.', '2+', '6 — Examens biochimiques (Réf. R6)'),
  ('MG-ANES-000065-R27', 'Ne pas prescrire d''examen biochimique urinaire systématique, quel que soit l''âge, quel que soit le type de chirurgie.', '1-', '6 — Examens biochimiques (Réf. R6)'),
  ('MG-ANES-000065-R28', 'Ne pas prescrire un bilan systématique d''hémostase (TQ, TCA, fibrinogène, plaquettes) dans le cadre d''une grossesse normale sans élément anamnestique/clinique évocateur, y compris avant une ALR périmédullaire.', '1-', '7 — Femme enceinte en prépartum (Réf. R7) — population : femme enceinte'),
  ('MG-ANES-000065-R29', 'Réévaluer la normalité de la grossesse de façon répétée, notamment à l''arrivée en salle de naissance par l''équipe obstétricale, et transmettre à l''anesthésiste.', '1+', '7 — Femme enceinte en prépartum (Réf. R7) — population : femme enceinte'),
  ('MG-ANES-000065-R30', 'Ne pas prescrire systématiquement une RAI à l''entrée en salle de travail si contrôle de moins d''1 mois disponible et grossesse normale. En présence de situations à risque hémorragique dépistées avant la naissance (ATCD HPP, HELLP, hématome rétroplacentaire, MFIU, anomalie d''insertion placentaire, grossesse gémellaire, utérus cicatriciel, chorioamniotite, trouble d''hémostase connu), disposer d''une RAI de moins de 3 jours.', '1+', '7 — Femme enceinte en prépartum (Réf. R7) — population : femme enceinte'),
  ('MG-ANES-000065-R31', 'Dans le cadre d''une césarienne programmée, disposer d''une RAI de moins de 3 jours.', '1+', '7 — Femme enceinte en prépartum (Réf. R7) — population : femme enceinte'),
  ('MG-ANES-000065-R32', 'Poser la question à toute femme en âge de procréer sur sa méthode de contraception et une possibilité de grossesse, avant tout acte nécessitant une anesthésie.', '1+', '8 — Test de grossesse (Réf. R8) — population : femme en âge de procréer'),
  ('MG-ANES-000065-R33', 'Si possibilité de grossesse à l''interrogatoire : prescrire un dosage plasmatique des bHCG après consentement de la patiente.', '1+', '8 — Test de grossesse (Réf. R8) — population : femme en âge de procréer'),
  ('MG-ANES-000065-R34', 'Si bHCG plasmatiques positifs : reporter l''intervention chaque fois que possible.', '1+', '8 — Test de grossesse (Réf. R8) — population : femme en âge de procréer'),
  ('MG-ANES-000065-R35', 'Chirurgie urologique (plaie opératoire en contact avec l''urine, y compris endoscopique) : réaliser systématiquement un ECBU préopératoire.', '1+', '9 — Dépistage infectieux, ECBU (Réf. R9)'),
  ('MG-ANES-000065-R36', 'Hors chirurgie urologique, patients avec facteur de risque d''infection urinaire et chirurgie à risque fort (prolapsus/incontinence gynécologique, orthopédie prothétique) : réaliser probablement un ECBU préopératoire systématique.', '2+', '9 — Dépistage infectieux, ECBU (Réf. R9)'),
  ('MG-ANES-000065-R37', 'Patients sans facteur de risque d''infection urinaire, chirurgie à risque fort : réaliser probablement une bandelette urinaire (BU), complétée par un ECBU si positive (nitrites/leucocyte-estérase).', '2+', '9 — Dépistage infectieux, ECBU (Réf. R9)'),
  ('MG-ANES-000065-R38', 'Chirurgie à risque faible de complication liée à l''infection urinaire, patients sans facteur de risque : ne pas pratiquer probablement d''analyse d''urine (BU ou ECBU).', '2-', '9 — Dépistage infectieux, ECBU (Réf. R9)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/examens-preinterventionnels-systematiques/'
on conflict (recommendation_code) do nothing;
