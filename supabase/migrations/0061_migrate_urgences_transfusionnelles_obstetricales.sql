-- Migration : Le traitement des urgences transfusionnelles obstétricales
-- (Conclusions de la table ronde organisée par l'Établissement Français du
-- Sang (EFS), réunie le 26/09/2000, texte daté 21/12/01-07/06/01, mis en
-- ligne sfar.org 2015). Soumis pour avis à la SFAR, au Collège des
-- Obstétriciens, aux Directeurs d'établissement de l'EFS et à la Société
-- Française de Transfusion Sanguine (SFTS).
-- Source : rfe-sfar-website/build/content_urgences_transfusionnelles_obstetricales.json
-- (25 recommandations atomiques identifiées à la lecture, sur 8 blocs
-- thématiques du corps du texte : I. niveaux d'urgence (3), II-1 typage
-- érythrocytaire (1), II-2 RAI (4), II-2-2 identification (1), III-1 ES (4),
-- III-2 ST (4), III-3 ES+ST (5), IV évaluation-suivi (3)).
--
-- MÉTHODOLOGIE : cette source n'imprime AUCUN système de gradation (ni
-- GRADE, ni cotation RAND/UCLA, ni vote chiffré, ni échelle ANAES) —
-- chaque proposition est rédigée en prose continue par le groupe d'experts,
-- sans tag de force ou de niveau de preuve individuel. `grade` et
-- `evidence_level` sont donc laissés NULL sur les 25 lignes : aucun grade
-- n'est deviné ni inventé (principe non négociable 1.3 du cahier des
-- charges).
--
-- INCOHÉRENCE DE MÉTADONNÉES DISCLOSUREE (déjà documentée dans la fiche
-- elle-même, section intro — reproduite ici pour traçabilité de la
-- migration, non résolue silencieusement) : `library_final.json` (le 160-
-- item index du dépôt rfe-sfar-website) intitule cet item « Hémorragies du
-- post-partum immédiat » avec `exact_date: "2014"` ET `exact_type: "RFE"`.
-- Le href/pdf-url de CE MÊME item pointent pourtant (correspondance
-- vérifiée unique) vers CE document précis, dont (a) le contenu est daté
-- 2000 (table ronde) / 2001 (texte finalisé, tamponné sur chaque page), (b)
-- la page sfar.org qui l'héberge affiche `datePublished` 2015-09-29, et (c)
-- ce n'est PAS une RFE gradée mais des conclusions de table ronde en prose
-- continue, sans aucun système de gradation. Les trois dates (2014 index /
-- 2000-2001 contenu / 2015 mise en ligne) sont mutuellement incompatibles ;
-- aucune n'est retenue par supposition comme "la bonne" — `publication_date`
-- est donc laissé NULL ci-dessous plutôt que d'en choisir une arbitrairement
-- (le contenu réel, daté et signé, est de 2000-2001 ; voir `grading_system`
-- et ce commentaire pour la traçabilité complète). `freshness_status` mis à
-- `revision_detectee` (document réel vieux de ~25 ans, malgré un statut
-- `library_final.json` "en vigueur") — même convention que hsa/0023,
-- eclsa/0019, glycemie/0022, voies_aeriennes_adulte/0060.
--
-- PÉRIMÈTRE — volontairement pas migrés (disclosure, pas un oubli) :
-- 1. « Deux types de risque » (panneau d'introduction, risque
--    immunologique / risque lié au retard à la transfusion) : cadrage
--    contextuel/épidémiologique, pas une proposition actionnable distincte
--    — même traitement que les panneaux "Champ"/contexte non migrés
--    ailleurs dans ce corpus.
-- 2. Tableau I (procédure d'urgence vitale, arbre décisionnel reproduit
--    intégralement dans la fiche) : aucune étape individuelle ne porte de
--    tag de force propre, et le contenu de l'arbre est déjà couvert par les
--    recommandations R01-R03 (niveaux d'urgence) et R14-R17 (rôle du site
--    transfusionnel) — même traitement que les algorithmes/arbres
--    décisionnels déjà exclus ailleurs dans ce corpus (voies_aeriennes_
--    enfant/0059, intubation_difficile_adulte/0027, intubation_
--    reanimation/0028, traumatisme_vertebromedullaire/0056 : "protocoles
--    opérationnels de référence", pas des propositions gradées
--    individuellement).
-- 3. « Liste des items — procédure générale » (15 items : ce qu'une
--    procédure écrite doit définir au minimum, en fin de document) : PAS
--    migrée comme 15 recommandations distinctes. À VÉRIFIER (disclosure,
--    jugement éditorial, pas une invention) : cette liste est un cahier des
--    charges/checklist de spécification (« toute procédure doit définir
--    au moins... »), pas 15 propositions cliniques individuellement
--    sourcées comme le sont R01-R25 ci-dessous — un relecteur pourrait
--    juger qu'elle mérite d'être migrée comme recommandations
--    additionnelles (ex. MG-ANES-000061-R26 à R40) ; laissée de côté ici
--    pour éviter de fragmenter artificiellement un unique cahier des
--    charges en 15 lignes de nature différente des 25 propositions
--    cliniques/organisationnelles ci-dessous.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. EFS (auteur principal), Collège des Obstétriciens et SFTS (co-
--    destinataires pour avis) ne figurent pas dans le seed Annexe B
--    (societies) : seule la SFAR est liée en document_societies ci-dessous
--    — même traitement que ecbu/0002 (AFU/CIAFU hors seed, relais SFAR
--    seul lié).
-- 2. R08 (surveillance RAI post-partum) reproduit un point que LA SOURCE
--    ELLE-MÊME qualifie d'insuffisamment documenté (« serait à préconiser
--    ... à confirmer par une étude prospective ») — reproduit tel quel,
--    pas renforcé ni affaibli par cette migration.
-- 3. `population` laissé NULL sur les 25 lignes : l'intégralité du document
--    concerne une population unique (grossesse/péripartum, explicite dans
--    le titre et le corps du texte) — même convention que preeclampsie/
--    0038, urgences_obstetricales/0057, voies_aeriennes_enfant/0059.

insert into public.documents (title, doc_type, original_language, source_url, pdf_url, grading_system, freshness_status)
values (
  'Le traitement des urgences transfusionnelles obstétricales',
  'Conclusions de table ronde', 'fr',
  'https://sfar.org/le-traitement-des-urgences-transfusionnelles-obstetricales/',
  'https://sfar.org/wp-content/uploads/2015/09/2_SFAR_Traitement-des-urgences-transfusionnelles-obstetricales.pdf',
  'Aucun système de gradation imprimé par la source (ni GRADE, ni RAND/UCLA, ni vote chiffré, ni échelle ANAES) — conclusions de table ronde EFS (26/09/2000, texte daté 21/12/01-07/06/01) en prose continue. À noter : library_final.json (le 160-item index du dépôt) intitule cet item « Hémorragies du post-partum immédiat » / exact_date "2014" / exact_type "RFE" — les trois divergent du contenu réel (voir commentaire de migration en tête de fichier) ; publication_date laissé NULL en conséquence plutôt que de choisir arbitrairement entre 2000/2001/2014/2015.',
  'revision_detectee'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/le-traitement-des-urgences-transfusionnelles-obstetricales/'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/le-traitement-des-urgences-transfusionnelles-obstetricales/'
  and s.slug in ('anesthesie_reanimation', 'gynecologie_obstetrique', 'hematologie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.source_section,
  'https://sfar.org/le-traitement-des-urgences-transfusionnelles-obstetricales/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000061-R01', 'Urgence vitale immédiate (UVI) : délai d''obtention des PSL sans délai. Les CGR sont distribués immédiatement, éventuellement sans groupe sanguin s''il n''est pas disponible ; la prescription le mentionne, et les prélèvements pour les analyses immuno-hématologiques sont acheminés dès que possible.', null, 'Niveau d''urgence — UVI', 'I. Définition des niveaux d''urgence'),
  ('MG-ANES-000061-R02', 'Urgence vitale (UV) : délai d''obtention des PSL inférieur à 30 minutes. Les CGR sont distribués avec un groupe conforme, éventuellement sans RAI si l''examen n''est pas disponible ; la prescription le mentionne, les échantillons l''accompagnent, et la RAI est réalisée dès que possible.', null, 'Niveau d''urgence — UV', 'I. Définition des niveaux d''urgence'),
  ('MG-ANES-000061-R03', 'Transfusion urgente : délai de 2 à 3 heures le plus souvent, permettant la réalisation de l''ensemble des examens immuno-hématologiques (dont la RAI si elle date de plus de 3 jours) et l''obtention de PSL isogroupes et, au besoin, compatibilisés. La situation hémorragique pouvant se modifier à tout moment, il est possible de requalifier le niveau de l''urgence à tout instant.', null, 'Niveau d''urgence — transfusion urgente', 'I. Définition des niveaux d''urgence'),
  ('MG-ANES-000061-R04', 'Typage érythrocytaire (décret n°92-143, jugé bien adapté) : pour une première grossesse, lors du premier examen prénatal (3e mois), si la patiente ne possède pas de carte de groupe sanguin complète avec un phénotype Rh et Kell, une première détermination des groupes sanguins ABO, Rh et Kell est réalisée, puis une deuxième détermination lors du 8e (6e examen prénatal) ou 9e mois (7e examen prénatal) de grossesse, si nécessaire.', null, 'Typage érythrocytaire', 'II-1. Typage érythrocytaire'),
  ('MG-ANES-000061-R05', 'Pour les femmes RhD négatif (avec ou sans antécédent transfusionnel) ou RhD positif avec antécédent transfusionnel ou obstétrical, la surveillance du décret n°92-143 est jugée bien adaptée : RAI lors du 3e mois (1er examen prénatal), puis aux 6e (4e examen), 8e (6e examen) et 9e mois (7e examen).', null, 'RAI — RhD négatif ou RhD positif avec antécédent', 'II-2. Recherche d''anticorps anti-érythrocytaires (RAI) — dépistage'),
  ('MG-ANES-000061-R06', 'Pour les femmes RhD positif sans antécédent transfusionnel, il est recommandé de réaliser une RAI au moins à 2 reprises avant l''accouchement : avant la fin du 3e mois (1er examen) et au cours du 8e ou 9e mois (6e/7e examen), avec une préférence au 9e mois si la première recherche était négative, en raison de la fréquence des hémorragies fœto-maternelles au 3e trimestre.', null, 'RAI — RhD positif sans antécédent transfusionnel', 'II-2. Recherche d''anticorps anti-érythrocytaires (RAI) — dépistage'),
  ('MG-ANES-000061-R07', 'Pour les femmes RhD positif sans antécédent transfusionnel mais faisant l''objet de manœuvres obstétricales à risque de passages importants d''hématies fœtales (ponction amniotique, chute ou traumatisme, décollement d''un placenta normalement ou anormalement inséré…), il convient d''évaluer au cas par cas l''opportunité d''une RAI supplémentaire.', null, 'RAI — manœuvres obstétricales à risque', 'II-2. Recherche d''anticorps anti-érythrocytaires (RAI) — dépistage'),
  ('MG-ANES-000061-R08', 'Une grossesse étant considérée comme un épisode transfusionnel (transfusion in utero), la surveillance de la survenue d''une immunisation secondaire par une RAI en post-partum serait à préconiser — point jugé insuffisamment documenté par la source elle-même, à confirmer par une étude prospective sur la surveillance des immunisations post-natales chez la femme RhD positif.', null, 'RAI — surveillance en post-partum (point non confirmé par la source)', 'II-2. Recherche d''anticorps anti-érythrocytaires (RAI) — dépistage'),
  ('MG-ANES-000061-R09', 'En cas de dépistage positif, une identification et un titrage des anticorps sont immédiatement réalisés ; le rythme des examens ultérieurs est décidé en fonction de la spécificité, du titre et de la concentration des anticorps.', null, 'RAI — identification', 'II-2-2. Identification'),
  ('MG-ANES-000061-R10', 'Il est proposé que l''établissement de santé (ES) dispose des résultats au moment opportun dès l''entrée de la femme en salle de travail, en vérifiant la conformité de tous les documents nécessaires à une transfusion (carte de groupe sanguin complète, résultat de la RAI du dernier examen prénatal) ; la meilleure solution serait la disponibilité des résultats par transmission informatique, réalisant la compatibilité électronique avec la distribution des PSL.', null, 'Organisation ES — disponibilité des résultats', 'III-1. Ce qui revient à l''établissement de santé (ES)'),
  ('MG-ANES-000061-R11', 'Il est proposé que l''établissement de santé (ES) avertisse le site transfusionnel (ST) du caractère de l''urgence (UVI, UV ou urgence transfusionnelle classique) afin que toutes les procédures soient mises en œuvre immédiatement — par exemple identification claire de l''urgence vitale sur la fiche de prescription accompagnée d''un appel téléphonique, ou transmission d''un fax complétée d''un appel téléphonique.', null, 'Organisation ES — alerte du ST', 'III-1. Ce qui revient à l''établissement de santé (ES)'),
  ('MG-ANES-000061-R12', 'Il est proposé que l''établissement de santé (ES) avertisse le ST en cas de RAI positive, afin que des produits sanguins compatibles soient préparés le plus rapidement possible en vue d''une éventuelle transfusion.', null, 'Organisation ES — alerte RAI positive', 'III-1. Ce qui revient à l''établissement de santé (ES)'),
  ('MG-ANES-000061-R13', 'Il est proposé que l''établissement de santé (ES) dépiste les usurpations d''identité et, en cas de doute, contrôle sur de nouveaux échantillons, notamment pour les patientes prises en charge en urgence et n''ayant pas fait l''objet d''un contrôle de groupe sanguin en cours de grossesse.', null, 'Organisation ES — dépistage des usurpations d''identité', 'III-1. Ce qui revient à l''établissement de santé (ES)'),
  ('MG-ANES-000061-R14', 'Il est proposé que le site transfusionnel (ST) reconnaisse les prescriptions de PSL relevant d''une UVI, d''une UV ou d''une transfusion urgente et y réponde par une distribution adéquate : distribution immédiate, distribution différée (sang préparé mais gardé en réserve au ST), ou acheminement de précaution vers le dépôt (pose le problème des produits inutilisés, réflexion spécifique non tranchée par la source).', null, 'Organisation ST — distribution adéquate', 'III-2. Ce qui revient au site transfusionnel (ST)'),
  ('MG-ANES-000061-R15', 'Il est proposé que le site transfusionnel (ST) mette en route les examens immuno-hématologiques dès réception des échantillons, en communiquant les résultats au prescripteur le plus rapidement possible ; le prélèvement de la RAI (moins de 3 jours) doit permettre de mettre en évidence un anticorps d''apparition récente, même si la RAI de fin de grossesse diminue déjà le risque immunologique.', null, 'Organisation ST — examens immuno-hématologiques', 'III-2. Ce qui revient au site transfusionnel (ST)'),
  ('MG-ANES-000061-R16', 'Il est proposé que le site transfusionnel (ST) réalise une association informatique combinant les résultats immuno-hématologiques et les produits distribués, avec transfert informatique des données validées du laboratoire vers le service de distribution ; en cas de prise en compte manuelle de résultats issus d''un autre laboratoire, ces données doivent obligatoirement répondre aux critères réglementaires en vigueur.', null, 'Organisation ST — association informatique', 'III-2. Ce qui revient au site transfusionnel (ST)'),
  ('MG-ANES-000061-R17', 'Il est proposé que le site transfusionnel (ST) prenne en compte un résultat de RAI négatif réalisé dans un autre laboratoire que celui du site distributeur, dès lors que l''analyse a été réalisée selon les critères réglementaires.', null, 'Organisation ST — RAI négatif d''un autre laboratoire', 'III-2. Ce qui revient au site transfusionnel (ST)'),
  ('MG-ANES-000061-R18', 'Il est proposé d''analyser, dans chaque département, le maillage entre les services de gynéco-obstétrique et les sites transfusionnels, en concertation avec les services déconcentrés de l''État et l''Agence Régionale d''Hospitalisation ; les établissements pratiquant des accouchements doivent pouvoir disposer de CGR en 30 minutes ou moins, 24 heures sur 24 toute l''année, via un site transfusionnel EFS à proximité, un dépôt de sang autorisé dans l''établissement, ou un dépôt d''urgence vitale autorisé sous conditions strictement réglementées ; le nombre de dépôts d''urgence doit être réduit à son strict minimum. Ce maillage, pour être réussi, suppose une concertation parfaite entre tous les acteurs et doit évoluer en fonction de la restructuration de l''organisation nationale des maternités.', null, 'Organisation commune — maillage ES/ST', 'III-3. Ce qui revient à la fois à l''ES et au ST'),
  ('MG-ANES-000061-R19', 'Il est proposé d''établir la quantité et la qualité des stocks d''urgence vitale : stock volontairement réduit, composé de 2 CGR O RH:-1-2-3 KEL:-1 (anciennement ccddee, K-) et de 2 CGR O RH:12-3-45 KEL:-1 (anciennement CCDee) ; la qualification CMV négatif n''est pas nécessaire dans ce contexte.', null, 'Organisation commune — stock d''urgence vitale', 'III-3. Ce qui revient à la fois à l''ES et au ST'),
  ('MG-ANES-000061-R20', 'Il est proposé de réaliser des procédures de prescription d''urgence vitale avec l''ensemble des acteurs (comités de sécurité transfusionnelle et d''hémovigilance), au niveau de l''ES et du ST, en clarifiant les modalités de communication (fax, téléphone, informatisation…), pouvant prendre la forme d''un arbre décisionnel d''utilisation des CGR en urgence vitale.', null, 'Organisation commune — procédures de prescription', 'III-3. Ce qui revient à la fois à l''ES et au ST'),
  ('MG-ANES-000061-R21', 'Il est proposé de prévoir le réapprovisionnement du dépôt d''urgence : le responsable du dépôt doit être prévenu sans attendre afin d''alerter le site transfusionnel pour assurer une bonne prise en charge des besoins transfusionnels ultérieurs.', null, 'Organisation commune — réapprovisionnement du dépôt', 'III-3. Ce qui revient à la fois à l''ES et au ST'),
  ('MG-ANES-000061-R22', 'Il est proposé d''organiser les transports (problème non réglé et non défini selon la source elle-même) en précisant qui apporte les examens, qui transporte le sang, dans quels délais, les horaires d''ouverture et modalités des jours fériés, les moyens utilisés (type de véhicule, containers, conservation sous contrôle) et qui réapprovisionne le dépôt ; un cahier des charges précis et/ou un contrat d''engagement doit définir clairement les points du transport liant ES, ST et transporteur.', null, 'Organisation commune — transports', 'III-3. Ce qui revient à la fois à l''ES et au ST'),
  ('MG-ANES-000061-R23', 'Il est proposé que l''évaluation de l''efficacité des mesures mises en place soit clairement définie dans un calendrier : hebdomadaire dans un premier temps, puis mensuelle, puis trimestrielle.', null, 'Évaluation — calendrier', 'IV. Évaluation et suivi des actions'),
  ('MG-ANES-000061-R24', 'Il est proposé que cette évaluation soit réalisée à la fois par l''établissement de santé et par le site transfusionnel.', null, 'Évaluation — acteurs', 'IV. Évaluation et suivi des actions'),
  ('MG-ANES-000061-R25', 'Il est recommandé que toute trace écrite des éventuels événements figure dans le dossier clinique, à des fins d''enquête ou d''évaluation ultérieure.', null, 'Évaluation — traçabilité', 'IV. Évaluation et suivi des actions')
) as v(code, statement, grade, condition_topic, source_section)
where d.source_url = 'https://sfar.org/le-traitement-des-urgences-transfusionnelles-obstetricales/'
on conflict (recommendation_code) do nothing;
