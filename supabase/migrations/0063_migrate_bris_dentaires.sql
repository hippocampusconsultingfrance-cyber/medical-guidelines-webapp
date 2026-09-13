-- Migration : Bris dentaires périanesthésiques — texte court (RFE commune
-- SFAR/Adarpef/SFSCMF, 2012)
-- Source : rfe-sfar-website/build/content_bris_dentaires.json (36
-- recommandations atomiques identifiées à la lecture : les 31 propositions
-- numérotées du texte court, réparties sur 3 chapitres / 10 questions, +
-- les 5 encarts pédiatriques distincts « Proposition enfant » intercalés
-- dans le corps du texte, non numérotés par la source mais individuellement
-- actionnables et rattachés à une population explicite).
--
-- MÉTHODOLOGIE : PAS de système GRADE (aucun tag "GRADE", aucun suffixe
-- 1+/2+ dans tout le document). La source imprime une seule mention de
-- force, GLOBALE, immédiatement après l'introduction : « Toutes les
-- propositions ont reçu un accord fort lors des votes par le groupe de
-- travail. » Il n'existe donc aucune distinction fort/faible entre
-- propositions individuelles dans la source elle-même — `grade = 'Fort'`
-- est appliqué de façon uniforme sur les 36 lignes (reproduction de la
-- mention globale de la source, PAS un GRADE numérique inventé ni une
-- distinction individuelle qui n'existe pas). `evidence_level` laissé NULL
-- (pas de système de niveau de preuve distinct dans ce document). La
-- formulation verbale de chaque proposition ("il faut" / "il faut
-- probablement" / "il ne faut probablement pas" / "il ne faut pas") est
-- reprise telle quelle dans `statement` ; elle reflète une nuance de
-- rédaction de la source, pas une force de vote distincte.
--
-- POPULATION : les 31 propositions numérotées portent une population
-- implicite (patient adulte/tout-venant, non explicitée par un marqueur de
-- population dans la source) — `population` laissé NULL. Les 5 encarts
-- "Proposition enfant" (R32-R36) sont explicitement introduits par "chez
-- l'enfant" dans la source elle-même — `population = 'Pédiatrie'` sur ces
-- 5 lignes uniquement.
--
-- PÉRIMÈTRE — volontairement pas migrés (disclosure, pas un oubli) :
-- 1. Le panneau "Champ" (cadrage du sujet) et le panneau "Méthodologie"
--    (disclosure de gradation, reproduite dans ce commentaire) : contexte,
--    pas des propositions actionnables.
-- 2. La phrase de fin de corps de texte ("Le groupe de travail suggère que
--    les propositions 1, 2, 3, 6, 9, 11 et 23 puissent faire l'objet d'une
--    évaluation des pratiques professionnelles [EPP]") : note administrative
--    sur des propositions déjà migrées, pas une proposition supplémentaire.
-- 3. La section "Sources et traçabilité" (référence bibliographique,
--    disclosure de couverture, avertissement 2012) : métadonnées.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. ADARPEF (Association des anesthésistes réanimateurs pédiatriques
--    d'expression française) et SFSCMF (Société française de stomatologie
--    et chirurgie maxillo-faciale), co-auteurs de cette RFE commune au même
--    titre que la SFAR, ne figurent pas dans le seed Annexe B — seule la
--    SFAR est liée en `document_societies`, même traitement que `ecbu`/0002
--    et `aap_endoprotheses_coronaires`/0062 pour des co-sociétés hors seed.
-- 2. CE FICHE A DÉJÀ SUIVI LE PIPELINE COMPLET du projet rfe-sfar-website
--    (fiche 63, git-native, triple-lecture + audit indépendant déjà
--    effectués — voir rfe-sfar-website/CLAUDE.md) : contrairement à
--    plusieurs autres fichiers `content_*.json` en attente de migration
--    dans ce lot, celui-ci n'a PAS de réserve de provenance à signaler.
--
-- PROVENANCE DES 5 PROPOSITIONS PÉDIATRIQUES : numérotées ici R32-R36 dans
-- l'ordre d'apparition dans le corps du texte (après les propositions 8,
-- 10, 14, 22 et 26 respectivement) — cette numérotation R32-R36 est une
-- convention de ce script de migration (pour respecter l'unicité de
-- `recommendation_code`), PAS une numérotation imprimée par la source
-- elle-même (qui les présente comme des encarts non numérotés).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Bris dentaires périanesthésiques : texte court',
  'RFE', 'fr', '2012-02-24',
  'https://sfar.org/bris-dentaires-perianesthesiques/',
  'https://sfar.org/wp-content/uploads/2015/09/2_AFAR_COURT_Bris-dentaires-perianesthesiques-copie.pdf',
  'Aucun système GRADE — propositions rédigées par un groupe de travail commun SFAR/Adarpef/SFSCMF, validées par les comités des référentiels cliniques et le CA de la SFAR. Mention de force UNIQUE et GLOBALE imprimée par la source : "Toutes les propositions ont reçu un accord fort lors des votes par le groupe de travail" — aucune distinction fort/faible individuelle entre les 31 propositions.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/bris-dentaires-perianesthesiques/'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/bris-dentaires-perianesthesiques/'
  and s.slug in ('anesthesie_reanimation', 'odontologie_chirurgie_dentaire', 'chirurgie_maxillo_faciale')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, 'Fort', v.population, v.condition_topic, v.source_section,
  'https://sfar.org/bris-dentaires-perianesthesiques/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000063-R01', 'Rechercher les critères d''intubation difficile et de ventilation au masque difficile.', null, 'Facteurs prédictifs', 'Chapitre 1, Q1 — Spécificités de la consultation préanesthésique'),
  ('MG-ANES-000063-R02', 'Rechercher lors de l''interrogatoire les facteurs de risque de bris dentaires : existence de prothèses, de restaurations (dent naturelle antérieure restaurée par résine composite ou facette collée — élément très fragile) et de traitement orthodontique, de mobilité des dents et des prothèses, ou d''antécédents traumatiques ou parodontaux.', null, 'Facteurs prédictifs', 'Chapitre 1, Q1 — Spécificités de la consultation préanesthésique'),
  ('MG-ANES-000063-R03', 'Insérer probablement des questions relatives à l''état buccodentaire dans un questionnaire rempli par le patient en vue de la consultation d''anesthésie.', null, 'Facteurs prédictifs', 'Chapitre 1, Q1 — Spécificités de la consultation préanesthésique'),
  ('MG-ANES-000063-R04', 'Porter une attention particulière aux incisives supérieures et inférieures, notamment en cas de dent isolée lors de la consultation d''anesthésie.', null, 'Facteurs prédictifs', 'Chapitre 1, Q1 — Spécificités de la consultation préanesthésique'),
  ('MG-ANES-000063-R05', 'Consigner les signes prédictifs d''intubation et de ventilation au masque difficile dans le compte rendu de la consultation d''anesthésie.', null, 'Traçabilité des signes cliniques prédictifs', 'Chapitre 1, Q2 — Traçabilité des signes cliniques prédictifs'),
  ('MG-ANES-000063-R06', 'Consigner de façon compréhensible (schéma dentaire simplifié conseillé) les signes relatifs à l''état dentaire sur le dossier d''anesthésie.', null, 'Traçabilité des signes cliniques prédictifs', 'Chapitre 1, Q2 — Traçabilité des signes cliniques prédictifs'),
  ('MG-ANES-000063-R07', 'Informer le patient du risque dentaire, et lui suggérer en cas de risque identifié une prise en charge par un odonto-stomatologiste avec panoramique dentaire. Chez un patient à risque avec traitement en cours ou prévu, évoquer le report d''intervention chirurgicale ou des soins dentaires dans l''information sur le rapport bénéfice-risque.', null, 'Classes de risque et conduite à tenir de prévention', 'Chapitre 1, Q3 — Classes de risque & conduite à tenir de prévention'),
  ('MG-ANES-000063-R08', 'Il ne faut probablement pas adresser systématiquement le patient chez le dentiste et/ou le stomatologue dans les autres cas.', null, 'Classes de risque et conduite à tenir de prévention', 'Chapitre 1, Q3 — Classes de risque & conduite à tenir de prévention'),
  ('MG-ANES-000063-R32', 'Chez l''enfant, en cas de traitement orthodontique en cours limitant l''ouverture de bouche (type bielle de Herbst fixe), ou présentant un obstacle au niveau du tiers antérieur du palais (grilles antilangue, antisuccion) avec un risque de bris et d''inhalation et/ou de matériel pouvant être abîmé au cours de l''acte chirurgical intrabuccal (bistouri électrique, ouvre-bouche), il faut probablement demander un avis spécialisé (possibilité de suspendre le traitement ou de démonter le dispositif) en dehors d''un contexte d''urgence.', 'Pédiatrie', 'Facteurs prédictifs — encart pédiatrique', 'Chapitre 1, Q3 — encart "Proposition enfant"'),
  ('MG-ANES-000063-R09', 'Informer oralement et remettre un document au cours d''une consultation d''anesthésie précisant que les traumatismes dentaires sont possibles au cours de toute anesthésie. La preuve de cette information doit être consignée dans le dossier d''anesthésie, au moins pour les patients avec risque de bris dentaire identifié.', null, 'Traçabilité de l''information donnée au patient', 'Chapitre 1, Q4 — Traçabilité de l''information donnée au patient'),
  ('MG-ANES-000063-R10', 'La note d''information remise au patient doit lui recommander de signaler toute prothèse ou toute fragilité dentaire particulière, notamment au niveau des incisives supérieures et inférieures.', null, 'Traçabilité de l''information donnée au patient', 'Chapitre 1, Q4 — Traçabilité de l''information donnée au patient'),
  ('MG-ANES-000063-R33', 'Chez l''enfant, en cas d''accès aux voies aériennes potentiellement difficile, informer les parents du risque de luxation accidentelle d''une dent temporaire ou d''une dent définitive immature.', 'Pédiatrie', 'Traçabilité de l''information — encart pédiatrique', 'Chapitre 1, Q4 — encart "Proposition enfant"'),
  ('MG-ANES-000063-R11', 'Au vu de l''ensemble des risques évalués, proposer une stratégie de prise en charge anesthésique dans le dossier.', null, 'Prévention lors du choix du protocole d''anesthésie', 'Chapitre 2, Q5 — Prévention lors du choix du protocole d''anesthésie & traçabilité'),
  ('MG-ANES-000063-R12', 'Pour améliorer la qualité des soins et la gestion du risque, mettre en place une stratégie d''équipe pour diminuer l''incidence des bris dentaires.', null, 'Prévention lors du choix du protocole d''anesthésie', 'Chapitre 2, Q5 — Prévention lors du choix du protocole d''anesthésie & traçabilité'),
  ('MG-ANES-000063-R13', 'En cas de risque de bris dentaire identifié, favoriser la pratique de l''anesthésie locorégionale dans le cadre de l''analyse bénéfice/risque.', null, 'Prévention lors du choix du protocole d''anesthésie', 'Chapitre 2, Q5 — Prévention lors du choix du protocole d''anesthésie & traçabilité'),
  ('MG-ANES-000063-R14', 'Obtenir un relâchement musculaire optimal pour faciliter les conditions d''intubation trachéale.', null, 'Prévention lors du choix du protocole d''anesthésie', 'Chapitre 2, Q5 — Prévention lors du choix du protocole d''anesthésie & traçabilité'),
  ('MG-ANES-000063-R34', 'Chez l''enfant entre 3 et 14 ans, rechercher avant l''induction de l''anesthésie une éventuelle dent temporaire devenue mobile depuis la consultation d''anesthésie, en vérifier l''état aux différents temps périopératoires (après l''intubation jusqu''à la sortie de la salle de soins postinterventionnels) et tracer l''information dans le dossier.', 'Pédiatrie', 'Prévention — encart pédiatrique', 'Chapitre 2, Q5 — encart "Proposition enfant"'),
  ('MG-ANES-000063-R15', 'En cas d''intubation et/ou de ventilation au masque difficile prévue, tenir compte de l''état dentaire dans la stratégie de contrôle des voies aériennes supérieures.', null, 'Matériel de contrôle des voies aériennes supérieures', 'Chapitre 2, Q6 — Matériel de contrôle des voies aériennes supérieures'),
  ('MG-ANES-000063-R16', 'En cas de risque identifié de bris dentaire et en l''absence de difficulté de ventilation au masque, il ne faut probablement pas utiliser systématiquement une canule oropharyngée.', null, 'Matériel de contrôle des voies aériennes supérieures', 'Chapitre 2, Q6 — Matériel de contrôle des voies aériennes supérieures'),
  ('MG-ANES-000063-R17', 'Avoir probablement recours à des solutions alternatives à une canule oropharyngée pour la prévention de la morsure de la sonde (compresses roulées).', null, 'Matériel de contrôle des voies aériennes supérieures', 'Chapitre 2, Q6 — Matériel de contrôle des voies aériennes supérieures'),
  ('MG-ANES-000063-R18', 'En cas de risque identifié de bris dentaire, le contrôle des voies aériennes doit être assuré par un opérateur expérimenté.', null, 'Matériel de contrôle des voies aériennes supérieures', 'Chapitre 2, Q6 — Matériel de contrôle des voies aériennes supérieures'),
  ('MG-ANES-000063-R19', 'Si une anesthésie générale est décidée et que l''indication s''y prête, privilégier probablement le choix d''un dispositif supraglottique.', null, 'Matériel de contrôle des voies aériennes supérieures', 'Chapitre 2, Q6 — Matériel de contrôle des voies aériennes supérieures'),
  ('MG-ANES-000063-R20', 'Si une intubation de la trachée est indiquée, utiliser probablement une lame de laryngoscope type Macintosh métallique pour une intubation par laryngoscopie conventionnelle.', null, 'Matériel de contrôle des voies aériennes supérieures', 'Chapitre 2, Q6 — Matériel de contrôle des voies aériennes supérieures'),
  ('MG-ANES-000063-R21', 'Après discussion avec le patient et pour limiter le risque de bris dentaire, recommander probablement l''utilisation d''une protection dentaire (gouttière) — tenir compte, dans son choix, de l''épaisseur du dispositif qui peut rendre l''accès aux voies aériennes plus difficile.', null, 'Matériel de contrôle des voies aériennes supérieures', 'Chapitre 2, Q6 — Matériel de contrôle des voies aériennes supérieures'),
  ('MG-ANES-000063-R22', 'Si l''utilisation d''une gouttière est retenue, recommander probablement une gouttière sur mesure plutôt qu''une gouttière standard, et tracer l''information « incité à fournir un protège-dents sur mesure » dans le dossier (délai de réalisation et coût pour le patient, libre d''accepter ou de refuser).', null, 'Matériel de contrôle des voies aériennes supérieures', 'Chapitre 2, Q6 — Matériel de contrôle des voies aériennes supérieures'),
  ('MG-ANES-000063-R35', 'Chez l''enfant, utiliser une lame de laryngoscope dont la taille est la mieux adaptée à sa morphologie, notamment en présence de dents fragilisées (maladie carieuse précoce). En période néonatale, éviter d''exercer une pression avec la lame du laryngoscope au niveau de la gencive du maxillaire supérieur — risque d''altération/lésion des germes dentaires ou de déplacement de germes.', 'Pédiatrie', 'Matériel de contrôle des voies aériennes — encart pédiatrique', 'Chapitre 2, Q6 — encart "Proposition enfant"'),
  ('MG-ANES-000063-R23', 'Pour les patients présentant un risque dentaire identifié, tracer probablement l''absence de dommage dentaire directement visible lié à l''anesthésie.', null, 'Surveillance péri- et postopératoire de l''état dentaire', 'Chapitre 2, Q7 — Surveillance péri- et postopératoire de l''état dentaire'),
  ('MG-ANES-000063-R24', 'En cas de risque de bris dentaire élevé, l''extubation trachéale doit probablement être réalisée par un opérateur expérimenté chez un patient complètement réveillé, sans curarisation résiduelle, et avec une ventilation spontanée efficace.', null, 'Surveillance péri- et postopératoire de l''état dentaire', 'Chapitre 2, Q7 — Surveillance péri- et postopératoire de l''état dentaire'),
  ('MG-ANES-000063-R25', 'Si une luxation complète (dent totalement sortie de son alvéole) d''une dent définitive est constatée, la remettre probablement en place rapidement ou la conserver dans du sérum physiologique ou, si disponible, dans une Hank''s Balanced Salt Solution (HBSS — conservation dans un milieu isotonique au desmodonte à température ambiante), et demander un avis spécialisé dans le plus bref délai.', null, 'Conduite à tenir devant un bris dentaire', 'Chapitre 3, Q8 — Que faire en cas de bris dentaire ?'),
  ('MG-ANES-000063-R26', 'En cas de bris dentaire constaté : prendre en charge une éventuelle complication (inhalation ou ingestion, radiographie thoracique éventuelle) et la traiter ; conserver si possible la dent ou ce qu''il en reste dans du sérum physiologique ; conserver les prothèses descellées et les restaurations.', null, 'Conduite à tenir devant un bris dentaire', 'Chapitre 3, Q8 — Que faire en cas de bris dentaire ?'),
  ('MG-ANES-000063-R36', 'Chez l''enfant, il ne faut pas réimplanter une dent temporaire en cas de luxation complète.', 'Pédiatrie', 'Conduite à tenir — encart pédiatrique', 'Chapitre 3, Q8 — encart "Proposition enfant"'),
  ('MG-ANES-000063-R27', 'Au décours d''un traumatisme dentaire : proposer un avis spécialisé avec panoramique dentaire ; établir un constat descriptif et factuel des lésions dans le dossier du patient (sans opinion ni jugement personnel) ; informer le patient rapidement, noter sa réaction et ses réponses ; garder pour soi-même un aide-mémoire détaillé et conserver les photocopies du dossier complet.', null, 'Conduite à tenir devant un bris dentaire', 'Chapitre 3, Q8 — Que faire en cas de bris dentaire ?'),
  ('MG-ANES-000063-R28', 'Prendre probablement des photographies des lésions et les conserver.', null, 'Conduite à tenir devant un bris dentaire', 'Chapitre 3, Q8 — Que faire en cas de bris dentaire ?'),
  ('MG-ANES-000063-R29', 'En cas de dommage constaté par le patient ultérieurement sans avoir été constaté en périopératoire : le patient doit être reçu par le professionnel ou un représentant de l''établissement de santé pour être informé sur les causes et circonstances du dommage, dans les 15 jours suivant la découverte du dommage ou la demande du patient ; récupérer un éventuel panoramique antérieur à l''acte anesthésique ; prévoir un avis spécialisé.', null, 'Conduite à tenir devant un bris dentaire', 'Chapitre 3, Q8 — Que faire en cas de bris dentaire ?'),
  ('MG-ANES-000063-R30', 'Le praticien doit effectuer, selon son mode d''activité, une déclaration de bris dentaire auprès de son assurance civile professionnelle, ou du service qualité / gestion des évènements indésirables (ou service de contentieux) de son établissement.', null, 'Déclaration de bris dentaire', 'Chapitre 3, Q9 — Déclaration de bris dentaire'),
  ('MG-ANES-000063-R31', 'Apporter une information claire au patient, l''accompagner et lui fournir : les coordonnées du service qualité et relation avec les usagers de son établissement ; la radio panoramique effectuée en postopératoire ; les coordonnées du dentiste ou stomatologue ayant constaté l''incident.', null, 'Documents et information à remettre au patient', 'Chapitre 3, Q10 — Documents et information à remettre au patient')
) as v(code, statement, population, condition_topic, source_section)
where d.source_url = 'https://sfar.org/bris-dentaires-perianesthesiques/'
on conflict (recommendation_code) do nothing;
