-- Migration : Recommandations concernant la mise en place, la gestion,
-- l'utilisation et l'évaluation d'une salle d'accueil des urgences vitales
-- (SAUV, "salle de déchoquage") — SFMU (à l'initiative), avec Samu de
-- France, la SRLF et la SFAR. Reçu et accepté le 5 novembre 2003, publié
-- Ann Fr Anesth Réanim 23 (2004) 850-855 et Journal Européen des Urgences
-- 2003;16:15165-15170.
-- Source : rfe-sfar-website/build/content_sauv.json.
--
-- ⚠️ DISCLOSURE MAJEURE — DOCUMENT ORGANISATIONNEL, PAS UN RÉFÉRENTIEL DE
-- RECOMMANDATIONS CLINIQUES GRADÉES : ce texte fixe des critères minimaux
-- d'architecture, d'équipement, de personnel et de procédures pour une
-- SAUV — la source le dit elle-même explicitement ("aucun système de
-- cotation... chaque recommandation est une norme collective, jamais
-- gradée individuellement"). Le modèle `recommendations` de ce schéma est
-- pensé pour des énoncés cliniques (grade/niveau de preuve/population de
-- patients) ; ce document n'en comporte pas au sens strict. Décision
-- disclosed (comme pour `ponction_lombaire`/0075, également sans système
-- de grade) : chaque sous-section numérotée normative du texte est migrée
-- comme une ligne `recommendations` avec `grade` NULL et `population`
-- NULL (ce ne sont pas des critères par population de patients mais des
-- normes organisationnelles) — `condition_topic` porte le domaine
-- normatif (architecture, équipement, ressources humaines, etc.) à la
-- place d'un sujet clinique. Ce n'est pas une fabrication d'atomicité :
-- chaque ligne correspond à une sous-section explicitement numérotée par
-- la source elle-même (3, 4.1, 4.2, 4.3, 5, 5.2, 6, 7.1, 7.2.1-7.2.5, 8.1,
-- 8.2, 9, 10).
--
-- Hors périmètre de cette migration (disclosed par la source elle-même,
-- non détaillé) : les 10 références réglementaires citées (décrets/
-- circulaires 1991-2001), non reproduites individuellement dans le contenu
-- construit — se référer au texte intégral.
--
-- `doc_type` = 'Autre' (exact_type de `library_final.json` — ni RFE ni RPP,
-- texte organisationnel).
--
-- SOURCE_URL / PDF_URL : `library_final.json` (recherche "SAUV" —
-- exactement 1 correspondance) donne un `href` identique au
-- `direct_pdf_url` (le PDF sert directement de page de destination, pas de
-- page HTML dédiée) — utilisé pour les deux colonnes ci-dessous.
-- `exact_date` = 2003-11-05, cohérent avec "reçu et accepté le 5 novembre
-- 2003" du contenu construit — aucune divergence à disclosed ici.
--
-- `specialties` : `medecine_d_urgence` si présente au seed, sinon
-- `anesthesie_reanimation` — vérifié : le seed Annexe B ne contient pas de
-- slug "médecine d'urgence" à ce jour, seul `anesthesie_reanimation` est
-- retenu (SFAR co-autrice, sujet transversal urgences/réanimation).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Recommandations concernant la mise en place, la gestion, l''utilisation et l''évaluation d''une salle d''Accueil des Urgences vitales (SAUV)',
  'Autre', 'fr', '2003-11-05',
  'https://sfar.org/wp-content/uploads/2016/01/Recommandations-concernant-la-mise-en-place-la-gestion-l-utilisation-et-l-evaluation-d-une-salle-d-accueil-des-urgences-vitales.pdf',
  'https://sfar.org/wp-content/uploads/2016/01/Recommandations-concernant-la-mise-en-place-la-gestion-l-utilisation-et-l-evaluation-d-une-salle-d-accueil-des-urgences-vitales.pdf',
  'Texte organisationnel/réglementaire, sans système de cotation ni niveau de preuve individuel — chaque recommandation est une norme collective de la source elle-même, jamais gradée. 21 sous-sections normatives numérotées migrées ci-dessous en `recommendations`, `grade` NULL sur toutes les lignes (disclosure intégrale de ce choix en commentaire de migration, même traitement que `ponction_lombaire`/0075).',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/wp-content/uploads/2016/01/Recommandations-concernant-la-mise-en-place-la-gestion-l-utilisation-et-l-evaluation-d-une-salle-d-accueil-des-urgences-vitales.pdf'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'), ('SFMU', 'France'), ('SRLF', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/wp-content/uploads/2016/01/Recommandations-concernant-la-mise-en-place-la-gestion-l-utilisation-et-l-evaluation-d-une-salle-d-accueil-des-urgences-vitales.pdf'
  and s.slug in ('anesthesie_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.source_section,
  'https://sfar.org/wp-content/uploads/2016/01/Recommandations-concernant-la-mise-en-place-la-gestion-l-utilisation-et-l-evaluation-d-une-salle-d-accueil-des-urgences-vitales.pdf',
  'draft'
from public.documents d, (values
  ('MG-ANES-000084-R01', 'L''admission dans une SAUV concerne tous les patients en situation de détresse vitale existante ou potentielle. La décision d''admission est prise par le médecin du service des urgences, et le cas échéant par l''IAO, le médecin du SMUR, ou le médecin régulateur du Samu, en s''appuyant sur des procédures cliniques et si possible des scores de gravité validés et partagés. La prise en charge des urgences internes de l''établissement dans la SAUV doit rester exceptionnelle.', null, 'Critères d''admission', 'Section 3 — Critères d''admission'),
  ('MG-ANES-000084-R02', 'La SAUV doit être localisée de préférence dans l''enceinte du service des urgences, sinon à proximité immédiate, à un emplacement réduisant les durées de transport vers le plateau technique (imagerie, réanimation, bloc opératoire).', null, 'Architecture — localisation', 'Section 4.1 — Localisation'),
  ('MG-ANES-000084-R03', 'La SAUV doit disposer d''une signalétique spécifique dès l''arrivée aux urgences, de couloirs de plain-pied entre sas d''arrivée, urgences et SAUV, et de couloirs vers le plateau technique suffisamment larges pour permettre le croisement de brancards, sans mobilier entravant la circulation.', null, 'Architecture — accès', 'Section 4.2 — Accès'),
  ('MG-ANES-000084-R04', 'La SAUV doit comporter un ou plusieurs emplacements adaptés à l''activité, avec au minimum : au moins 1 emplacement pour les services d''urgence non SAU, au moins 2 pour les services >15 000 passages/an et pour les SAU ; par emplacement, ≥2 prises oxygène, ≥1 prise air, ≥3 prises vide, ≥6 prises électricité (dont 2 sécurisées souhaitables) ; surface SAUV ≥25 m² (≥15 m²/emplacement hors rangements si plusieurs emplacements) ; par pièce, ≥1 poste de lavage des mains, ≥1 dispositif d''affichage des radiographies, ≥1 plan de travail, ≥1 téléphone avec accès extérieur et ≥1 téléphone dédié à une liaison Samu.', null, 'Architecture — structure et équipements minimaux', 'Section 4.3 — Structure'),
  ('MG-ANES-000084-R05', 'Équipement minimal de réanimation respiratoire (Niveau 1) : fluides médicaux + bouteille O2 de secours ; ventilateur type transport ; matériel d''intubation trachéale et d''intubation difficile ; insufflateur manuel + réservoir O2 ; aspirateur électrique + aspiration manuelle de secours ; monitorage SpO2 et capnographe CO2 expiratoire quantitatif ; débitmètre de pointe ; drainage thoracique.', null, 'Équipement Niveau 1 — réanimation respiratoire', 'Section 5 — Équipement Niveau 1'),
  ('MG-ANES-000084-R06', 'Équipement minimal de réanimation cardiovasculaire (Niveau 1) : électrocardioscope ; tensiomètre automatique + manuel ; défibrillateur ; stimulation transthoracique ; ECG multipiste ; ≥2 pousse-seringues électriques ; matériel d''accès veineux périphérique/central préconditionné ; accélérateur-réchauffeur de perfusion, autotransfusion, garrot pneumatique ; kit transfusionnel ; mesure de l''hémoglobine ; aimant pour contrôle des dispositifs implantés.', null, 'Équipement Niveau 1 — réanimation cardiovasculaire', 'Section 5 — Équipement Niveau 1'),
  ('MG-ANES-000084-R07', 'La SAUV doit disposer de l''ensemble des médicaments pour défaillances respiratoires/circulatoires/neurologiques, de solutés de perfusion et de remplissage, et d''une liste pré-établie connue de tous (analgésiques, sédatifs, antibiotiques, catécholamines, thrombolytiques, principaux antidotes).', null, 'Équipement Niveau 1 — médicaments', 'Section 5 — Équipement Niveau 1'),
  ('MG-ANES-000084-R08', 'La SAUV doit disposer d''un matelas à dépression et/ou d''un dispositif de transfert, ainsi que de plusieurs dispositifs adaptés d''immobilisation du rachis et des membres.', null, 'Équipement Niveau 1 — immobilisation', 'Section 5 — Équipement Niveau 1'),
  ('MG-ANES-000084-R09', 'La SAUV doit disposer d''un brancard radiotransparent, d''un dispositif de mesure de la glycémie capillaire, de thermomètres (dont un adapté à l''hypothermie), de moyens de réchauffement corporel, de sondes gastriques, de matériel de drainage urinaire y compris sus-pubien, et de moyens propres pour mobiliser un patient ventilé avec tout son monitorage et ses dispositifs de traitement.', null, 'Équipement Niveau 1 — divers', 'Section 5 — Équipement Niveau 1'),
  ('MG-ANES-000084-R10', 'Pour les SAU (Niveau 2), en complément des moyens du Niveau 1 : au moins un ventilateur dit "de réanimation" permettant plusieurs modes ventilatoires en volume ou en pression. Il est en outre souhaitable que la SAUV puisse disposer de la mesure de la pression artérielle invasive et de la fibroscopie bronchique.', null, 'Équipement Niveau 2 (SAU)', 'Section 5.2 — Équipement Niveau 2'),
  ('MG-ANES-000084-R11', 'La durée de prise en charge en SAUV doit être la plus courte possible : le médecin de la SAUV doit avoir pour objectif la prise en charge immédiate, continue et coordonnée du patient, pour la remise en disponibilité rapide de la SAUV.', null, 'Durée de prise en charge', 'Section 6 — Durée de prise en charge'),
  ('MG-ANES-000084-R12', 'Les relations Samu/SAUV sont essentielles pour l''admission et l''orientation des patients : le Samu prévient la SAUV des difficultés d''aval, les patients amenés par le Smur sont systématiquement annoncés, le Smur indique toute modification de l''état clinique du patient, et la transmission (médecin à médecin, infirmier à infirmier, dossier complet et vérifié) doit être effectuée avant que l''équipe du Smur ne quitte le patient.', null, 'Collaboration — relation avec le Samu-Smur', 'Section 7.1 — Relation avec le Samu-Smur'),
  ('MG-ANES-000084-R13', 'Des procédures doivent être établies avec le service d''anesthésie-réanimation et/ou les services de réanimation ; l''anesthésiste-réanimateur et/ou le réanimateur doit venir renforcer la SAUV à la demande de l''équipe. Si la SAUV est intégrée provisoirement dans une structure accueillant régulièrement des détresses vitales (SSPI, unité de réanimation d''urgence), un contrat entre les deux services doit en définir clairement le fonctionnement.', null, 'Collaboration — anesthésie-réanimation et réanimations', 'Section 7.2.1'),
  ('MG-ANES-000084-R14', 'La SAUV doit disposer des listes actualisées de gardes et astreintes de tous les spécialistes de l''établissement, et pouvoir les contacter directement sans passer par leur service d''origine, selon des modalités et délais définis à l''avance dans un règlement intérieur validé par les instances médico-administratives.', null, 'Collaboration — les consultants', 'Section 7.2.2'),
  ('MG-ANES-000084-R15', 'La SAUV doit bénéficier d''un accès privilégié à l''imagerie (priorités définies si le plateau technique n''est pas dédié aux urgences) et au(x) laboratoire(s), pour accélérer l''obtention des résultats ; biologie délocalisée en l''absence d''alternative.', null, 'Collaboration — services médicotechniques', 'Section 7.2.3'),
  ('MG-ANES-000084-R16', 'Les patients de la SAUV doivent être acceptés en priorité et sans délai par les services d''aval dès que leur départ peut être envisagé, pour maintenir la capacité d''accueil des urgences vitales. Les protocoles de transfert interne doivent détailler le personnel et le matériel engagés, sans compromettre la sécurité de la SAUV.', null, 'Collaboration — services d''aval', 'Section 7.2.4'),
  ('MG-ANES-000084-R17', 'L''ensemble des collaborations nécessaires au fonctionnement en sécurité de la SAUV doit faire l''objet d''un protocole d''accord validé par les instances médico-administratives de l''établissement.', null, 'Collaboration — contractualisation', 'Section 7.2.5'),
  ('MG-ANES-000084-R18', 'Le personnel médical et paramédical affecté à la SAUV doit avoir bénéficié d''une formation lui permettant de prendre en charge l''ensemble des situations menaçant le pronostic vital, ainsi que d''une formation d''adaptation à l''emploi.', null, 'Ressources humaines — formation de l''équipe', 'Section 8.1 — Formation de l''équipe'),
  ('MG-ANES-000084-R19', 'L''effectif de l''équipe soignante dépend du flux de patients, mais doit comporter au minimum un médecin, un(e) infirmier(e) et un(e) aide-soignant(e) ou agent hospitalier par SAUV, quels que soient l''heure et le jour, pouvant se libérer immédiatement ; il est ainsi impossible, sauf circonstances exceptionnelles, que le médecin de la SAUV assure seul et simultanément la régulation Samu et/ou les interventions Smur.', null, 'Ressources humaines — équipe soignante', 'Section 8.2 — Équipe soignante'),
  ('MG-ANES-000084-R20', 'Des procédures et protocoles doivent être mis en place dans la SAUV : alerte, appel des membres de l''équipe, recours à un avis spécialisé, préparation de la SAUV, accueil et prise en charge initiale, prise en charge des pathologies les plus fréquentes fondée sur les données de la médecine fondée sur les preuves, critères et modalités de transfert, et formation d''adaptation à l''emploi. La liste nominative de l''équipe et le matériel doivent être vérifiés au moins une fois par jour (check-lists, registre ad hoc).', null, 'Procédures et protocoles', 'Section 9 — Procédures et protocoles'),
  ('MG-ANES-000084-R21', 'Un registre de l''activité de la SAUV doit être mis en place, comportant au minimum état civil et origine du patient, mode d''admission, horaires et durée de prise en charge, motif d''admission, actes diagnostiques et thérapeutiques réalisés, devenir et orientation du patient. Une analyse qualitative régulière des dossiers et une analyse collective des situations ayant conduit à un dysfonctionnement ou un décès sont souhaitables.', null, 'Évaluation', 'Section 10 — Évaluation')
) as v(code, statement, grade, condition_topic, source_section)
where d.source_url = 'https://sfar.org/wp-content/uploads/2016/01/Recommandations-concernant-la-mise-en-place-la-gestion-l-utilisation-et-l-evaluation-d-une-salle-d-accueil-des-urgences-vitales.pdf'
on conflict (recommendation_code) do nothing;
