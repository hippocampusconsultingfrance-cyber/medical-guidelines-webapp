-- Migration : Prévention des erreurs médicamenteuses en anesthésie —
-- recommandations de la SFAR, novembre 2006. Rédigées par un groupe
-- d'experts (G. Aulagner, P. Dewachter, P. Diemunsch, Ph. Garnerin,
-- M. Latourte, Q. Levrat, A. Mignon, V. Piriou), amendées et validées par
-- le Comité Analyse et Maîtrise du Risque de la SFAR.
-- Source : rfe-sfar-website/build/content_erreurs_medicamenteuses.json
-- (2 champs de fiche : méthodologie/état des lieux/Figure 1/recommandations
-- générales/prévention de la reconstitution ; prévention de l'administration/
-- Tableau 1/sources).
--
-- ⚠️ DÉDOUBLONNAGE / COLLISION DE TITRE VÉRIFIÉE (4 entrées voisines dans
-- `library_final.json`, LU INTÉGRALEMENT — pas une recherche tronquée) :
--   - index 12 : "Prévention des erreurs médicamenteuses", RPP, exact_date
--     2024-05-27, href .../prevention-des-erreurs-medicamenteuses-en-
--     anesthesie-reanimation/ — DOCUMENT DIFFÉRENT, plus récent.
--   - index 73 : "Prévention des erreurs médicamenteuses en A-R",
--     "Préconisation", exact_date 2016-11-10, href .../preconisations-2016-
--     prevention-des-erreurs-medicamenteuses-en-a-r/ (SFAR+SFPC selon le nom
--     du fichier PDF) — DOCUMENT DIFFÉRENT, plus récent.
--   - index 128 : "Prévention des erreurs médicamenteuses en anesthésie",
--     exact_type "Autre", exact_date "2006-11", href = direct_pdf_url =
--     https://sfar.org/wp-content/uploads/2014/04/preverreurmedic_recos.pdf
--     — CORRESPONDANCE EXACTE ET UNIQUE avec le contenu construit (même
--     titre mot pour mot, même URL donnée par le panneau "Sources et
--     traçabilité" du contenu construit, même date "novembre 2006").
--   Un `grep -il` sur "erreur"/"medicament"/"seringue" contre les 92
--   fichiers `NNNN_migrate_*.sql` déjà présents dans ce dossier ne retourne
--   AUCUNE correspondance sur l'URL ci-dessus : ce document précis n'a
--   jamais été migré, sous aucune clé.
--
-- ⚠️ DISCLOSURE MAJEURE — CE DOCUMENT DE 2006 A DEUX SUCCESSEURS CONNUS SUR
-- LE MÊME SUJET, NI L'UN NI L'AUTRE ENCORE MIGRÉS : une "Préconisation"
-- SFAR/SFPC 2016 et un RPP SFAR 2024 couvrent la même question clinique
-- (prévention des erreurs médicamenteuses en anesthésie-réanimation) — voir
-- les 2 entrées de library_final.json ci-dessus. Le contenu construit lui-
-- même porte un panneau d'avertissement explicite en fin de fiche : « les
-- pratiques d'étiquetage et de prévention des erreurs médicamenteuses ayant
-- pu évoluer depuis 2006 (recommandations plus récentes, nouveaux
-- dispositifs), se référer à un avis spécialisé et aux recommandations
-- actualisées avant toute décision. » En conséquence, `freshness_status`
-- est mis à 'revision_detectee' (PAS 'a_jour') ci-dessous — fait constaté et
-- disclosed, pas résolu silencieusement en gardant la valeur par défaut.
-- `superseded_by_document_id` reste NULL : les documents 2016/2024 ne sont
-- pas encore des lignes `documents` de cette base (pas encore migrés), donc
-- aucun id à référencer pour l'instant.
-- -- À VÉRIFIER : une fois les documents 2016 et/ou 2024 migrés, un humain
-- devrait probablement soit repasser ce document en 'remplacee' avec
-- `superseded_by_document_id` renseigné, soit confirmer qu'il doit rester
-- 'revision_detectee' si le contenu 2006 reste jugé partiellement valide en
-- parallèle des versions plus récentes (ce n'est pas tranché ici).
--
-- ⚠️ `doc_type` — DIVERGENCE AVEC L'INDICE DE TÂCHE : l'énoncé de tâche
-- qualifie ce document de « RFE SFAR 2006 ». Vérification directe (pas pris
-- pour acquis) : ni `library_final.json` (exact_type = "Autre", pas "RFE")
-- ni le contenu construit lui-même (panneau méthodologie : "texte narratif
-- appuyé sur une bibliographie... rédigé par un groupe d'experts, amendé et
-- validé par le Comité Analyse et Maîtrise du Risque de la SFAR" — aucune
-- mention de procédure RFE, de cotation GRADE Grid, ni de vote Delphi) ne
-- confirment un format RFE. `doc_type` est donc fixé à 'Autre', identique à
-- l'exact_type de library_final.json, PAS à 'RFE'. -- À VÉRIFIER si un humain
-- dispose d'une source distincte confirmant le format RFE.
--
-- ⚠️ MÉTHODOLOGIE EXACTE — AUCUN SYSTÈME DE GRADATION : le contenu construit
-- le dit explicitement ("aucun système de cotation GRADE ni niveau de
-- preuve individuel par recommandation... les recommandations reposent sur
-- un consensus d'experts"), appuyé sur une bibliographie de 20 références.
-- `grade` = NULL et `evidence_level` = NULL (colonne omise) sur les 7
-- lignes ci-dessous — AUCUNE valeur GRADE/AE inventée par défaut, conforme
-- à la consigne explicite de la Tâche 1 pour les documents sans système de
-- grade (même traitement que `sauv`/0084 et `ponction_lombaire`/0075) :
-- décomposition par sous-section normative de la source plutôt que
-- fabrication d'un grade.
--
-- ⚠️ GRANULARITÉ DE DÉCOMPOSITION (disclosed, pas une conversion mécanique) :
-- cette source ne numérote AUCUNE de ses sous-sections (contrairement à
-- `sauv`/0084 qui a des sections numérotées 3, 4.1, 4.2...) — seuls des
-- titres de rubrique en gras ("Erreurs de spécialité :", "Erreurs de
-- dilution :", etc.) et des titres de section ("section" navy) structurent
-- le texte. Chaque ligne `recommendations` ci-dessous correspond à UNE
-- rubrique nommée par la source (titre de section, ou label en gras suivi
-- de sa liste de mesures passives quand il y en a une) — même granularité
-- que le précédent `sauv`/0084 (une ligne par thème nommé, pas une ligne
-- par puce individuelle de la liste). Les listes à puces internes à une
-- rubrique (ex. les 7 mesures passives des erreurs de spécialité, les 9
-- mesures passives des erreurs de seringues) sont conservées intégralement
-- dans le texte de `statement`, jointes par point-virgule — aucune perte
-- d'information, juste pas une ligne par puce.
--
-- ⚠️ CONTENU VOLONTAIREMENT EXCLU DU MODÈLE `recommendations` (justifié
-- ligne par ligne, aucune omission silencieuse) :
--  - Panneau "Champ" et panneau "Méthodologie" (préambule) : prose de
--    contexte/disclosure méthodologique, ne formule aucun énoncé "il faut
--    faire X".
--  - Section "État des lieux" (épidémiologie : fréquence des erreurs,
--    statistiques France/États-Unis, répartition par type d'erreur) :
--    donnée descriptive, pas un énoncé d'action.
--  - Section "Origine des erreurs médicamenteuses — Figure 1" (arbre des
--    pannes complet, sa légende de symboles, et le paragraphe de
--    conclusion "Le modèle met en évidence que...") : modélisation
--    étiologique/taxonomie des types d'erreurs, pas un énoncé prescriptif —
--    préservée intégralement dans `documents.presentation_json` (le
--    contenu construit la reproduit en tableau), pas migrée comme ligne
--    `recommendations`.
--  - Paragraphe "Périmètre" (sous "Recommandations — Généralités") :
--    ATTENTION, ceci est une exclusion DE LA SOURCE ELLE-MÊME, pas un choix
--    de cette migration — la source déclare explicitement hors de son
--    propre champ la prévention des erreurs de moment, des erreurs de
--    volume/débit, et des erreurs de patient (objet d'une recommandation
--    séparée non détaillée ici). Aucune ligne `recommendations` ne peut
--    donc exister pour ces 3 sous-types : il n'y a rien à atomiser, la
--    source ne développe aucune mesure les concernant dans ce texte.
--  - Tableau 1 (codes couleurs/trames par classe pharmacologique) : table
--    de référence descriptive (13 classes pharmacologiques), pas un énoncé
--    d'action séparé — référencée depuis le texte de R07 ("Erreurs de
--    seringues") qui s'appuie dessus, et reproduite intégralement dans
--    `documents.presentation_json`, pas comme ligne `recommendations`
--    propre (migrer une ligne par classe pharmacologique aurait fabriqué
--    une atomicité que la source ne présente pas comme 13 recommandations
--    distinctes, mais comme un seul tableau de référence).
--  - Section "Sources et traçabilité" (document source, version, méthodo,
--    URL source, bibliographie des 20 références, panneau d'avertissement
--    2006) : métadonnées de traçabilité et bibliographie, pas des énoncés
--    cliniques — la bibliographie et l'avertissement 2006 sont cités dans
--    ce commentaire de migration mais non répliqués comme lignes
--    `recommendations`.
-- Aucun "trou" de numérotation R01-R07 au sens propre (la source ne
-- numérote rien à sauter) : les 7 lignes ci-dessous couvrent la totalité
-- des rubriques prescriptives identifiées par lecture complète du contenu
-- construit ; toutes les autres rubriques du document sont listées et
-- justifiées ci-dessus comme non-recommandationnelles.
--
-- `population` : NON renseignée (colonne omise) — le texte ne stratifie
-- aucune de ses 7 rubriques par population de patients (adulte/enfant non
-- mentionnés ; le texte s'adresse uniformément à "la structure de soins
-- réalisant des anesthésies").
--
-- ⚠️ SOCIÉTÉS — VÉRIFICATION EXHAUSTIVE CONTRE LA LISTE COMPLÈTE DU SEED (18
-- entrées lues intégralement dans `schema_v2.sql`, section 15 : SFAR, SRLF,
-- HAS, SPILF, SFMU, CNGOF, SFC, SFN, SFD, ESAIC, ESICM, SCCM, ASA, DAS,
-- ASRA, NICE, AWMF, SEMICYUC) : la source ne cite AUCUNE société co-
-- rédactrice ou co-validatrice autre que la SFAR elle-même ("rédigées par
-- un groupe d'experts, amendées et validées par le Comité Analyse et
-- Maîtrise du Risque de la SFAR"). `('SFAR', 'France')` EXISTE dans le seed
-- — aucune société absente à signaler pour ce document. (Le co-auteur SFPC
-- apparaît uniquement dans le nom de fichier du successeur 2016, PAS dans
-- ce document 2006 — non pertinent ici, et de toute façon SFPC n'existe pas
-- dans le seed Annexe B.)
--
-- ⚠️ SPÉCIALITÉS — VÉRIFICATION EXHAUSTIVE CONTRE LA LISTE COMPLÈTE DU SEED
-- (77 slugs lus intégralement dans `schema_v2.sql`, section 14) :
-- `anesthesie_reanimation` EXISTE dans le seed et est l'unique spécialité
-- retenue — le champ du document est explicitement "en anesthésie" de bout
-- en bout. Considéré puis ÉCARTÉ : `pharmacienne` (le pharmacien de
-- l'établissement est cité à plusieurs reprises comme partie prenante des
-- protocoles/concertations, mais le document n'est ni rédigé ni destiné en
-- premier lieu aux pharmaciens — mention de collaboration, pas de public
-- cible) et `infirmierere_anesthesiste_iade` (les IADE administrent
-- concrètement les seringues décrites, mais ne sont cités nulle part comme
-- rédacteurs, validateurs, ou destinataires nommés du texte — contrairement
-- à `sauv`/0084 où la SFMU est société CO-AUTRICE justifiant l'ajout de
-- `medecine_d_urgence`, ici il n'y a qu'une seule société, la SFAR, et
-- aucune profession paramédicale nommée comme public cible dans le texte
-- lui-même). Décision disclosed, pas une omission silencieuse.
--
-- SOURCE_URL / PDF_URL : `library_final.json` (recherche "erreurs
-- médicamenteuses"/"erreur médicamenteuse" — 4 correspondances au total,
-- UNE SEULE exacte pour ce contenu, voir dédoublonnage ci-dessus, index
-- 128) donne un `href` identique au `direct_pdf_url` (le PDF sert
-- directement de page de destination) — utilisé pour les deux colonnes
-- ci-dessous, cohérent avec l'"URL source" citée par le contenu construit
-- lui-même. `exact_date` = "2006-11" (mois connu, jour inconnu) —
-- `publication_date` = 2006-11-01, jour non précisé par la source (même
-- convention que `thrombectomie`/0082).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prévention des erreurs médicamenteuses en anesthésie',
  'Autre', 'fr', '2006-11-01',
  'https://sfar.org/wp-content/uploads/2014/04/preverreurmedic_recos.pdf',
  'https://sfar.org/wp-content/uploads/2014/04/preverreurmedic_recos.pdf',
  'Texte narratif appuyé sur une bibliographie de 20 références (citées entre crochets) — aucun système de cotation GRADE ni niveau de preuve individuel par recommandation. Les recommandations reposent sur un consensus d''experts (groupe d''experts SFAR, amendé et validé par le Comité Analyse et Maîtrise du Risque de la SFAR), restituées ici par rubrique thématique nommée par la source (pas de numérotation source à reproduire). 7 rubriques prescriptives migrées en `recommendations`, `grade` NULL sur toutes les lignes (disclosure intégrale en tête de fichier de migration, même traitement que `sauv`/0084 et `ponction_lombaire`/0075). Document de 2006 disposant de 2 successeurs connus non encore migrés sur le même sujet (Préconisation SFAR/SFPC 2016, RPP SFAR 2024) — `freshness_status` mis à `revision_detectee` en conséquence, voir disclosure complète en commentaire de migration.',
  'revision_detectee'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/wp-content/uploads/2014/04/preverreurmedic_recos.pdf'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/wp-content/uploads/2014/04/preverreurmedic_recos.pdf'
  and s.slug in ('anesthesie_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.source_section,
  'https://sfar.org/wp-content/uploads/2014/04/preverreurmedic_recos.pdf',
  'draft'
from public.documents d, (values
  ('MG-ANES-000093-R01', 'Une structure de soins réalisant des anesthésies doit mener une réflexion pérenne sur les moyens à mettre en œuvre pour prévenir les erreurs médicamenteuses, aboutissant à des mesures de prévention spécifiques, communes à toute la structure et formalisées par écrit. Les actions mises en place doivent être réévaluées régulièrement. Les événements médicamenteux indésirables évitables, avérés ou potentiels, doivent pouvoir être déclarés — notamment à la commission du médicament et des dispositifs médicaux stériles — et faire l''objet d''une analyse détaillée, de préférence interdisciplinaire. L''ensemble de la démarche conduite par la structure doit être documenté, et les preuves de son existence apportées.', null, 'Gouvernance de la prévention des erreurs médicamenteuses (démarche pérenne, réévaluation, déclaration/analyse, documentation)', 'Recommandations — Généralités'),
  ('MG-ANES-000093-R02', 'D''une manière générale, des dispositions destinées à limiter les perturbations lors des tâches de préparation des médicaments devraient être prises.', null, 'Prévention des erreurs de reconstitution — principe général', 'Prévention des erreurs de reconstitution — Principe général'),
  ('MG-ANES-000093-R03', 'Erreurs de spécialité : contrôle actif des informations notées sur le conditionnement, par lecture attentive (nécessité à rappeler périodiquement), complété par des mesures passives : choix des médicaments d''anesthésie restreint au strict nécessaire, en concertation incluant les médecins anesthésistes et le pharmacien de l''établissement ; stock disponible de chaque spécialité restreint au minimum ; système de rangement clair, commun à l''ensemble des sites de travail (armoires, chariots d''urgence, table d''anesthésie, plateaux) ; médicaments et concentrations disponibles limités aux seuls régulièrement utilisés ; identification, signalement et, si possible, élimination systématiques des similitudes de forme/couleur/dénomination entre spécialités présentes ; information des utilisateurs de tout changement affectant les médicaments mis à disposition ; prise en compte, dans la réflexion générale, du retour des médicaments non utilisés vers leur lieu de rangement initial (source d''erreur).', null, 'Prévention des erreurs de spécialité (reconstitution)', 'Prévention des erreurs de reconstitution — Erreurs de spécialité'),
  ('MG-ANES-000093-R04', 'Erreurs de dilution : protocoles de préparation des médicaments, faciles à mettre en œuvre, si possible communs à la structure d''anesthésie et aux autres structures de soins aigus de l''institution, précisant les modalités de reconstitution, la concentration (mg/ml, µg/ml, UI/ml), le volume à préparer et celui de la seringue utilisée. En accord avec le pharmacien : associations médicamenteuses utilisables et durée de conservation des préparations précisées. Le recours à des médicaments prêts à l''emploi (industrie pharmaceutique ou pharmacie de l''institution) devrait être encouragé.', null, 'Prévention des erreurs de dilution (reconstitution)', 'Prévention des erreurs de reconstitution — Erreurs de dilution'),
  ('MG-ANES-000093-R05', 'Erreurs d''étiquetage : chaque médicament doit être reconstitué et étiqueté au cours d''une seule séquence de gestes, par la même personne, sans interruption ni changement de lieu.', null, 'Prévention des erreurs d''étiquetage (reconstitution)', 'Prévention des erreurs de reconstitution — Erreurs d''étiquetage'),
  ('MG-ANES-000093-R06', 'Erreurs de voie d''administration : contrôle actif du point d''insertion de la voie (nécessité à rappeler périodiquement), complété par des mesures passives : voies d''administration identifiées par étiquettes mentionnant explicitement leur nature, apposées à proximité du patient et de tous les points d''entrée ; présence de robinets sur les cathéters/tubulures d''ALR à éviter ; recours à des systèmes physiques de limitation des erreurs (détrompeurs à connectique différente selon la voie, cathéters de couleur/forme différentes, ex. hélicoïdal) à considérer.', null, 'Prévention des erreurs de voie d''administration', 'Prévention des erreurs d''administration — Erreurs de voie d''administration'),
  ('MG-ANES-000093-R07', 'Erreurs de seringues (administration directe ou continue) : contrôle actif par lecture attentive des informations de l''étiquette (rappel périodique), complété par des mesures passives : seringues systématiquement étiquetées, étiquette lisible sans masquer les graduations ; interdiction d''utiliser une seringue sans nom de spécialité ou sans concentration ; système uniforme d''étiquetage au sein de la structure, comprenant des étiquettes autocollantes pré-imprimées (DCI du médicament) et un emplacement libre réservé à la concentration (unité pré-imprimée) ; système d''étiquetage appuyé sur les codes internationaux de couleurs et de trames par classe pharmacologique (voir Tableau 1) ; combinaison variable de majuscules/minuscules à considérer comme moyen supplémentaire (ex. DOBUTamine, DOPAmine, ATROpine, aPROTInine) ; sauf médicaments de l''urgence, pas de préparation à l''avance si l''utilisation pendant l''anesthésie n''est pas certaine ; sauf nécessité absolue, pas de plusieurs concentrations du même médicament simultanément disponibles sur un même plateau ; seringues préparées rangées dans les plateaux selon un plan prédéfini, commun à toute la structure ; plateaux d''anesthésie protégés, portant la date et l''heure de préparation et l''identification du préparateur.', null, 'Prévention des erreurs de seringues (étiquetage, codes couleurs, gestion des plateaux)', 'Prévention des erreurs d''administration — Erreurs de seringues')
) as v(code, statement, grade, condition_topic, source_section)
where d.source_url = 'https://sfar.org/wp-content/uploads/2014/04/preverreurmedic_recos.pdf'
on conflict (recommendation_code) do nothing;
