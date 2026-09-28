-- Migration : Gestion du traitement antiplaquettaire oral (AAP) chez les
-- patients porteurs d'endoprothèses coronaires (SFAR/AFAR, Propositions du
-- groupe d'experts, 31 mars 2006)
-- Source : rfe-sfar-website/build/content_aap_endoprotheses_coronaires.json
-- (16 recommandations atomiques identifiées à la lecture : 9 lignes du
-- tableau thématique du corps du texte — le document source lui-même
-- regroupe ses 10 propositions initiales en ces 9 lignes, les 2 dernières
-- "registre" et "carte de liaison" étant condensées en une seule ligne
-- thématique — + les 6 cellules du Tableau 1, matrice de décision
-- risque-thrombose x risque-hémorragique, + 1 consigne transversale
-- s'appliquant dans tous les cas de figure).
--
-- MÉTHODOLOGIE : avis d'un groupe d'experts, PAS de système GRADE, PAS de
-- vote/pourcentage d'accord formalisé (à la différence des propositions
-- GIHP/GFHT/SFAR 2018 plus récentes sur la gestion générale des AAP, déjà
-- migrées : voir aap_urgence/0004 et aap_programmee/0005). La source
-- souligne elle-même à plusieurs reprises l'absence de données de haut
-- niveau de preuve ("ne repose sur aucune étude prospective", "avis
-- d'experts, en l'absence d'étude de haut niveau de preuve"). `grade` et
-- `evidence_level` sont donc laissés NULL sur les 16 lignes : aucune force
-- n'est devinée ni inventée (principe 1.3 du cahier des charges).
--
-- FRAÎCHEUR : `freshness_status = 'revision_detectee'` retenu — la fiche
-- source elle-même (panneau d'introduction ET avertissement final)
-- explicite : "Document historique (2006), antérieur aux propositions
-- GIHP/GFHT/SFAR 2018 [...] mais conservé ici pour son objet plus étroit"
-- et "Document ancien et étroit (stents coronaires uniquement) : pour la
-- gestion périopératoire générale des AAP, se référer aux propositions
-- GIHP/GFHT/SFAR 2018". Ces deux RFE 2018 existent déjà dans ce corpus
-- (aap_urgence/0004, aap_programmee/0005) et couvrent la gestion générale
-- des AAP ; ce document-ci reste néanmoins la seule source du corpus dédiée
-- spécifiquement à la matrice de décision "stent coronaire", d'où sa
-- migration séparée (statut `draft`, aucune fusion ni dépréciation
-- automatique — décision éditoriale laissée à la relecture humaine).
--
-- DIVERGENCE DE CLASSIFICATION (disclosure, non résolue silencieusement) :
-- `library_final.json` (index 160 items) classe ce document `exact_type:
-- "RFE"`. La source elle-même se désigne comme une "Information
-- professionnelle" (mention explicite dans sa propre légende de
-- publication), rédigée comme des "Propositions du groupe d'experits" SANS
-- la structure méthodologique (vote, cotation) d'une RFE au sens des
-- documents SFAR plus récents de ce corpus. `doc_type` ci-dessous reprend
-- l'auto-désignation de la source ("Information professionnelle") plutôt
-- que la classification de l'index, cette dernière étant reproduite ici
-- pour traçabilité plutôt que silencieusement écartée.
--
-- PÉRIMÈTRE — volontairement pas migrés (disclosure, pas un oubli) :
-- 1. Le panneau "Champ" (cadrage du sujet : gestion périopératoire des AAP
--    chez les porteurs de stent) : contexte, pas une proposition
--    actionnable distincte.
-- 2. Les 3 notes de définition accompagnant le Tableau 1 ("Risque
--    hémorragique — Majeur/Modéré/Mineur : ..." et "Risque de thrombose
--    d'EC pharmacoactive — Majeur/Modéré : ...") : ce sont des définitions
--    nécessaires à l'interprétation des 6 cellules migrées en R10-R15, pas
--    des propositions cliniques indépendantes.
-- 3. La section "Sources et traçabilité" (référence bibliographique
--    Ann Fr Anesth Reanim 2006, liste des auteurs, note de couverture) :
--    métadonnées, aucun contenu clinique actionnable propre.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. `population` laissé NULL sur les 16 lignes : le document entier
--    concerne une population unique (patients porteurs d'une endoprothèse
--    coronaire devant subir un acte invasif), déjà exprimée dans le titre.
-- 2. Les 6 cellules du Tableau 1 (R10-R15) portent un `condition_topic`
--    décrivant la combinaison risque-thrombose x risque-hémorragique
--    plutôt qu'un intitulé de thème isolé (aucun intitulé de ligne/colonne
--    individuel ne suffirait à décrire une cellule de matrice 2D) — lecture
--    éditoriale, pas une donnée imprimée telle quelle par la source.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Gestion du traitement antiplaquettaire oral chez les patients porteurs d''endoprothèses coronaires',
  'Information professionnelle', 'fr', '2006-03-31',
  'https://sfar.org/gestion-du-traitement-anti-plaquettaire-oral-chez-les-patients-porteurs-dendoprotheses-coronaires/',
  'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Gestion-du-traitement-anti-plaquettaire-.pdf',
  'Aucun système de gradation formalisé — avis d''un groupe d''experts (propositions du 31 mars 2006), sans GRADE ni vote/pourcentage d''accord, à la différence des propositions GIHP/GFHT/SFAR 2018 sur la gestion générale des AAP (aap_urgence/0004, aap_programmee/0005). library_final.json classe ce document "RFE" ; la source se désigne elle-même comme une "Information professionnelle" — divergence reproduite, non résolue arbitrairement.',
  'revision_detectee'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/gestion-du-traitement-anti-plaquettaire-oral-chez-les-patients-porteurs-dendoprotheses-coronaires/'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/gestion-du-traitement-anti-plaquettaire-oral-chez-les-patients-porteurs-dendoprotheses-coronaires/'
  and s.slug in ('anesthesie_reanimation', 'cardiologie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.source_section,
  'https://sfar.org/gestion-du-traitement-anti-plaquettaire-oral-chez-les-patients-porteurs-dendoprotheses-coronaires/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000062-R01', 'Maintenir le double traitement AAP au moins 4 à 6 semaines après l''implantation d''une endoprothèse coronaire (EC) nue, et au moins 6 à 12 mois en cas d''EC pharmacoactive.', null, 'Durée du double traitement AAP', 'Propositions du groupe d''experts (31 mars 2006)'),
  ('MG-ANES-000062-R02', 'En cas de traitement AAP bien conduit, le risque de thrombose aiguë serait le même quelle que soit la nature de l''EC. L''arrêt des AAP est un facteur de risque majeur de thrombose pour tous les stents, en particulier de thrombose tardive pour les EC pharmacoactives, ce qui justifie a priori un traitement AAP prolongé. La fréquence réelle de thrombose d''EC pharmacoactive en contexte périopératoire reste inconnue à ce jour : seuls des cas cliniques isolés sont rapportés dans la littérature.', null, 'Risque de thrombose', 'Propositions du groupe d''experts (31 mars 2006)'),
  ('MG-ANES-000062-R03', 'La pose d''une endoprothèse coronaire doit toujours être discutée en amont ; si une chirurgie est envisagée dans les 6 à 12 mois, la pose d''une EC nue est préférable. Avant l''implantation d''une EC pharmacoactive, la possible réalisation d''une chirurgie ultérieure doit toujours être évoquée.', null, 'Choix du stent avant chirurgie prévue', 'Propositions du groupe d''experts (31 mars 2006)'),
  ('MG-ANES-000062-R04', 'Identifier en particulier les patients à très haut risque de thrombose de stent : arrêt des AAP dans les 6 à 12 mois après la pose de l''EC, antécédent de thrombose de stent, plusieurs stents ou stent(s) de grande longueur ou posé(s) sur une bifurcation, patients tri-tronculaires non complètement revascularisés, récidive sous traitement, diabète, fraction d''éjection basse.', null, 'Patients à très haut risque de thrombose', 'Propositions du groupe d''experts (31 mars 2006)'),
  ('MG-ANES-000062-R05', 'La discussion pluridisciplinaire est obligatoire pour guider la prise en charge : cardiologue, spécialiste de l''hémostase, chirurgien/médecin réalisant l''acte invasif, et anesthésiste-réanimateur. Le risque hémorragique (chirurgie sous AAP) et le risque thrombotique (arrêt d''AAP) doivent être discutés collégialement pour décider de la prise en charge périopératoire, voire d''un report ou d''une annulation du geste. Un relevé de conclusions doit être rédigé, disponible dans le dossier, et le patient informé.', null, 'Discussion pluridisciplinaire', 'Propositions du groupe d''experts (31 mars 2006)'),
  ('MG-ANES-000062-R06', 'Si l''intervention doit survenir pendant une période où la bithérapie ne peut pas être arrêtée totalement (risque thrombotique élevé) : poursuite de l''aspirine hautement souhaitable, fenêtre courte de 5 jours d''arrêt du clopidogrel envisageable (proposition ne reposant sur aucune étude prospective, mais sur un compromis entre la durée de vie des plaquettes [10 jours], le risque hémorragique de la poursuite et le risque thrombotique de l''interruption). Reprise postopératoire la plus précoce possible ; dose de charge de clopidogrel ≥ 300 mg évoquée par certains experts.', null, 'EC pharmacoactive, bithérapie non interruptible', 'Propositions du groupe d''experts (31 mars 2006)'),
  ('MG-ANES-000062-R07', 'Il est préférable d''opérer sous aspirine. Prudence et discussion collégiale particulièrement recommandées si l''hémostase chirurgicale est difficile (grands décollements, aorte, prostate, neurochirurgie, ORL, segment postérieur de l''œil). Hors chirurgie cardiaque, aucune donnée de la littérature sur le risque hémorragique périopératoire sous clopidogrel ; les données sous ticlopidine (risque hémorragique équivalent) sont très peu nombreuses, même si un accroissement du risque hémorragique par rapport à l''aspirine a été rapporté. Pour une EC nue au-delà de la 6e semaine, aucune recommandation forte ne pourra être formulée avant les résultats de l''étude STRATAGEM.', null, 'EC pharmacoactive, quel que soit le délai', 'Propositions du groupe d''experts (31 mars 2006)'),
  ('MG-ANES-000062-R08', 'Si le risque hémorragique de la chirurgie est considéré comme majeur, ou en cas d''impossibilité de surseoir à l''intervention, l''arrêt complet du traitement (bithérapie) doit être discuté au cas par cas (risque thrombotique redoutable). Il n''y a pas d''argument en faveur d''une substitution par AINS (flurbiprofène 50 mg x 2, arrêt 24h avant) ou par HBPM à dose anticoagulante (85-100 UI anti-Xa/kg/12h SC, dose non préventive) — cette substitution expose elle-même à un risque hémorragique périopératoire non négligeable.', null, 'Si aucun AAP ne peut être maintenu', 'Propositions du groupe d''experts (31 mars 2006)'),
  ('MG-ANES-000062-R09', 'Mise en place proposée d''un registre des événements périopératoires chez les patients porteurs de stent (services d''anesthésie/cardiologie volontaires, cadre EPP, sous l''égide du Cfar), et diffusion d''une carte de liaison pour les patients sous AAP oraux au long cours (motif, type/nombre d''AAP, durée, coordonnées du médecin à contacter en cas d''interruption envisagée).', null, 'Registre et carte de liaison', 'Propositions du groupe d''experts (31 mars 2006)'),
  ('MG-ANES-000062-R10', 'Risque de thrombose du stent majeur et risque hémorragique de l''intervention majeur : reporter l''intervention au-delà de 6 mois à 1 an après la pose de l''endoprothèse coronaire pharmacoactive. Si impossible : arrêt aspirine-clopidogrel 5 jours, ou arrêt aspirine-clopidogrel 10 jours maximum et substitution.', null, 'Risque de thrombose du stent majeur / risque hémorragique majeur', 'Tableau 1 — Matrice de décision périopératoire'),
  ('MG-ANES-000062-R11', 'Risque de thrombose du stent majeur et risque hémorragique de l''intervention intermédiaire : reporter l''intervention au-delà de 6 mois à 1 an après la pose de l''EC. Si impossible : maintien de l''aspirine, arrêt du clopidogrel 5 jours.', null, 'Risque de thrombose du stent majeur / risque hémorragique intermédiaire', 'Tableau 1 — Matrice de décision périopératoire'),
  ('MG-ANES-000062-R12', 'Risque de thrombose du stent majeur et risque hémorragique de l''intervention mineur : maintien de l''aspirine et du clopidogrel.', null, 'Risque de thrombose du stent majeur / risque hémorragique mineur', 'Tableau 1 — Matrice de décision périopératoire'),
  ('MG-ANES-000062-R13', 'Risque de thrombose du stent modéré et risque hémorragique de l''intervention majeur : arrêt aspirine-clopidogrel 5 jours, ou arrêt aspirine-clopidogrel 10 jours maximum et substitution.', null, 'Risque de thrombose du stent modéré / risque hémorragique majeur', 'Tableau 1 — Matrice de décision périopératoire'),
  ('MG-ANES-000062-R14', 'Risque de thrombose du stent modéré et risque hémorragique de l''intervention intermédiaire : maintien de l''aspirine, arrêt du clopidogrel 5 jours.', null, 'Risque de thrombose du stent modéré / risque hémorragique intermédiaire', 'Tableau 1 — Matrice de décision périopératoire'),
  ('MG-ANES-000062-R15', 'Risque de thrombose du stent modéré et risque hémorragique de l''intervention mineur : maintien de l''aspirine et du clopidogrel, ou maintien de l''aspirine et arrêt du clopidogrel 5 jours.', null, 'Risque de thrombose du stent modéré / risque hémorragique mineur', 'Tableau 1 — Matrice de décision périopératoire'),
  ('MG-ANES-000062-R16', 'Dans tous les cas, l''intervention doit être reportée au-delà de six semaines d''un syndrome coronaire aigu dans la mesure du possible.', null, 'Consigne transversale', 'Tableau 1 — Matrice de décision périopératoire')
) as v(code, statement, grade, condition_topic, source_section)
where d.source_url = 'https://sfar.org/gestion-du-traitement-anti-plaquettaire-oral-chez-les-patients-porteurs-dendoprotheses-coronaires/'
on conflict (recommendation_code) do nothing;
