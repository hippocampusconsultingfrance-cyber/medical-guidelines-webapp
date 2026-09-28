-- Migration : Prise en charge des patients présentant, ou à risque, de
-- traumatisme vertébro-médullaire — Recommandations Formalisées d'Experts
-- SFAR, avec ANARLF, SFCR, SFMU, SOFCOT, SOFMER et le SSA. Texte validé par
-- le Comité des Référentiels Cliniques (15/05/2019) et le CA SFAR
-- (24/05/2019). Actualisation de la conférence d'experts de 2004 (document
-- distinct de `library_final.json`, non migré séparément ici — remplacé
-- par ce document 2019). Comité de 27 experts, coordination A. Roquilly,
-- B. Vigué. Source : rfe-sfar-website/build/content_traumatisme_vertebromedullaire.json
-- (19 recommandations sur 12 questions au format PICO).
--
-- MÉTHODOLOGIE : GRADE®, tags « (GRADE X+/-) accord FORT » ou « Avis
-- d'experts » imprimés littéralement après chaque recommandation — cités
-- ici tels quels. `grade` reproduit tel quel le chip source.
-- `evidence_level` laissé NULL.
--
-- COMPTAGE — EXACTEMENT RECONCILIÉ (cas propre, aucun mismatch) : le
-- résumé officiel annonce "19 recommandations ; 2 de niveau de preuve
-- élevé (GRADE 1+/-), 12 de niveau de preuve faible (GRADE 2+/-), 5 avis
-- d'experts. Accord fort obtenu pour 100 % des recommandations". Inventaire
-- direct : R1.1-R12.1 (19 recommandations numérotées de façon continue par
-- question) = 19, avec 1×1+ (R10.2) + 1×1- (R5.1) = 2×GRADE1, 12×GRADE2
-- (tous 2+ : R1.1, R2.2, R3.1, R4.1, R6.2, R7.1, R8.1, R8.2, R9.1, R10.1,
-- R11.2, R12.1) et 5×AE (R2.1, R3.2, R6.1, R9.2, R11.1) — exactement
-- reconcilié sur les deux axes, aucune ligne manquante ni en trop.
--
-- PÉRIMÈTRE — volontairement pas migrés : les 2 algorithmes de la source
-- (Figure 1 — immobilisation rachidienne ; Figure 2 — procédure
-- d'intubation trachéale), diagrammes de décision reformulés par le
-- contenu construit en tableaux "Situation/Contexte | Conduite/Technique"
-- vérifiés par rendu visuel des pages source (10 et 21) — non gradués
-- individuellement par le jury (contrairement à R1.1/R2.1/R2.2/R8.1/R8.2
-- qui, elles, portent un vrai chip et sont migrées) ; leur contenu
-- clinique concret est déjà résumé par ces recommandations graduées.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFAR et SFMU (toutes deux dans le seed Annexe B) liées en
--    document_societies ; ANARLF, SFCR, SOFCOT, SOFMER et le SSA
--    (co-auteurs) hors seed, non liés.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge des patients présentant, ou à risque, de traumatisme vertébro-médullaire',
  'RFE', 'fr', '2019-09-21',
  'https://sfar.org/prise-en-charge-des-patients-presentant-ou-a-risque-de-traumatisme-vertebromedullaire/',
  'https://sfar.org/download/rfe-trauma-vertebro-medulaire/?wpdmdl=24464',
  'GRADE® : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ probablement recommandé / 2- probablement non recommandé) ; AE = avis d''experts. Comptage source ("19 recommandations : 2 GRADE1, 12 GRADE2, 5 AE, accord fort 100 %") exactement reconcilié, aucun écart.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-des-patients-presentant-ou-a-risque-de-traumatisme-vertebromedullaire/'
  and s.acronym in ('SFAR', 'SFMU') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-des-patients-presentant-ou-a-risque-de-traumatisme-vertebromedullaire/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'medecine_d_urgence', 'neurochirurgie', 'chirurgie_orthopedique_et_traumatologique', 'medecine_physique_et_de_readaptation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/prise-en-charge-des-patients-presentant-ou-a-risque-de-traumatisme-vertebromedullaire/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000056-R01', 'Il faut probablement immobiliser précocement le rachis de tout patient traumatisé suspect de lésion rachidienne pour limiter l''apparition ou l''aggravation d''un déficit neurologique à la phase initiale.', '2+', 'Q1 — Immobilisation du rachis (Réf. R1.1)'),
  ('MG-ANES-000056-R02', 'Chez le patient avec ou à risque de lésion médullaire cervicale, les experts suggèrent une stabilisation manuelle en ligne, associée à un retrait de la partie antérieure du collier cervical pendant les manœuvres d''intubation trachéale afin de limiter la mobilisation du rachis cervical et favoriser l''exposition glottique.', 'AE', 'Q2 — Intubation oro-trachéale en préhospitalier (Réf. R2.1)'),
  ('MG-ANES-000056-R03', 'Chez le patient avec ou à risque de lésion médullaire cervicale, pour l''intubation trachéale en préhospitalier, il faut probablement réaliser une procédure intégrant induction en séquence rapide avec laryngoscopie directe, utilisation d''une bougie type mandrin d''Eschmann et maintien du rachis cervical dans l''axe sans manœuvre de Sellick pour augmenter le taux de succès à la première tentative.', '2+', 'Q2 — Intubation oro-trachéale en préhospitalier (Réf. R2.2)'),
  ('MG-ANES-000056-R04', 'Chez le patient avec risque de lésion médullaire, il faut probablement maintenir un niveau de pression artérielle systolique > 110 mmHg avant réalisation du bilan lésionnel pour diminuer la mortalité.', '2+', 'Q3 — Objectifs de la réanimation hémodynamique (Réf. R3.1)'),
  ('MG-ANES-000056-R05', 'Chez le patient avec risque de lésion médullaire, les experts proposent de maintenir le niveau de pression artérielle moyenne > 70 mmHg pendant la première semaine pour limiter le risque d''aggravation du déficit neurologique.', 'AE', 'Q3 — Objectifs de la réanimation hémodynamique (Réf. R3.2)'),
  ('MG-ANES-000056-R06', 'Il faut probablement transférer directement en filière de soins spécialisée le patient avec traumatisme rachidien et déficit neurologique, y compris transitoire, pour diminuer la morbi-mortalité.', '2+', 'Q4 — Filière de soins (Réf. R4.1)'),
  ('MG-ANES-000056-R07', 'Chez le patient atteint d''une lésion médullaire traumatique, complète ou incomplète, il ne faut pas administrer de corticoïdes à la phase précoce dans l''objectif d''améliorer le pronostic neurologique.', '1-', 'Q5 — Corticothérapie à la phase initiale (Réf. R5.1)'),
  ('MG-ANES-000056-R08', 'Les experts suggèrent de réaliser une IRM médullaire dans les plus brefs délais devant toute anomalie de l''examen neurologique post-traumatique non expliquée par un scanner du rachis, pour indiquer la prise en charge chirurgicale.', 'AE', 'Q6 — Indications de l''IRM dans le bilan lésionnel (Réf. R6.1)'),
  ('MG-ANES-000056-R09', 'Si une IRM est réalisable sans retarder le traitement chirurgical et sans mettre le patient en danger, il faut probablement réaliser une IRM médullaire pré-opératoire afin d''améliorer la prise en charge chirurgicale.', '2+', 'Q6 — Indications de l''IRM dans le bilan lésionnel (Réf. R6.2)'),
  ('MG-ANES-000056-R10', 'Chez les patients avec lésion médullaire traumatique, il faut probablement réaliser une décompression chirurgicale en urgence, au plus tard dans les 24 heures du déficit neurologique, pour augmenter la récupération neurologique à long terme.', '2+', 'Q7 — Délai optimal de prise en charge chirurgicale (Réf. R7.1)'),
  ('MG-ANES-000056-R11', 'En urgence, il faut probablement réaliser une induction séquence rapide et, pour diminuer le risque d''échec d''intubation au premier essai, s''aider d''une vidéolaryngoscopie en première intention pour faciliter l''intubation.', '2+', 'Q8 — Intubation trachéale en milieu hospitalier (Réf. R8.1)'),
  ('MG-ANES-000056-R12', 'En dehors de l''urgence et chez un patient coopérant, il faut probablement réaliser une intubation fibroscopique en ventilation spontanée chez les patients à risque d''échec de ventilation au masque et/ou de laryngoscopie indirecte (ouverture de bouche < 2,5 cm) pour diminuer le risque d''échec d''intubation au premier essai.', '2+', 'Q8 — Intubation trachéale en milieu hospitalier (Réf. R8.2)'),
  ('MG-ANES-000056-R13', 'Il faut probablement associer un ensemble standardisé de méthodes pour faciliter le sevrage ventilatoire, incluant par exemple : ceinture abdominale chez le patient assis en ventilation spontanée ; kinésithérapie de drainage bronchique et de renforcement diaphragmatique ; toux assistée avec insufflateur/exsufflateur ; aérosolthérapie (bêta-2 mimétiques ± atropiniques) ; autonomisation respiratoire progressive.', '2+', 'Q9 — Sevrage de la ventilation mécanique (Réf. R9.1)'),
  ('MG-ANES-000056-R14', 'Les experts suggèrent la réalisation d''une trachéotomie pour accélérer le sevrage ventilatoire dans les 7 premiers jours en cas d''atteinte du rachis cervical haut (C2-C5), et uniquement après échec d''une ou plusieurs tentatives d''extubation réalisées dans des conditions optimales en cas d''atteinte du rachis cervical bas (C6-C7), y compris en cas d''atteinte complète.', 'AE', 'Q9 — Sevrage de la ventilation mécanique (Réf. R9.2)'),
  ('MG-ANES-000056-R15', 'Il faut probablement introduire une analgésie multimodale associant analgésique non morphinique et anti-hyperalgésique (kétamine) aux opioïdes lors de la prise en charge chirurgicale pour prévenir la survenue de douleurs prolongées chez les blessés vertébro-médullaires.', '2+', 'Q10 — Traitement antalgique spécifique (Réf. R10.1)'),
  ('MG-ANES-000056-R16', 'Pour contrôler les douleurs neuropathiques des blessés vertébro-médullaires, il faut introduire un traitement par voie orale par gabapentinoïdes pour une durée prolongée (>6 mois), et y associer un antidépresseur tricyclique ou un inhibiteur mixte de la recapture de la sérotonine et de la noradrénaline si l''efficacité d''une monothérapie est insuffisante.', '1+', 'Q10 — Traitement antalgique spécifique (Réf. R10.2)'),
  ('MG-ANES-000056-R17', 'Afin de diminuer les complications neuro-orthopédiques et la spasticité des membres, les experts suggèrent de mettre en place au moins une fois par jour, dès la phase aiguë : rééducation et mobilisation passive des articulations intéressées par le déficit moteur ; installation des articulations dans le sens inverse de la déformation prévisible ; mise en place d''orthèses ; renforcement musculaire manuel.', 'AE', 'Q11 — Installation et mobilisation spécifiques (Réf. R11.1)'),
  ('MG-ANES-000056-R18', 'Dès la phase aiguë, il faut probablement mettre en place au moins une fois par jour, pour prévenir la survenue d''escarres : mobilisation précoce dès que le rachis est fixé ; vérifications visuelles et tactiles quotidiennes des zones à risque ; repositionnement toutes les 2 à 4 heures avec contrôle des zones d''appui ; outils de décharge (coussins, mousses, oreillers) ; support de prévention de haut niveau (matelas perte d''air, matelas dynamique).', '2+', 'Q11 — Installation et mobilisation spécifiques (Réf. R11.2)'),
  ('MG-ANES-000056-R19', 'Il faut probablement mettre en place une stratégie permettant un sondage urinaire intermittent dès que le volume de diurèse quotidien le permet, afin de diminuer les complications urologiques (infection urinaire, lithiase urinaire) chez les patients avec lésion médullaire.', '2+', 'Q12 — Sondage vésical intermittent précoce (Réf. R12.1)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-des-patients-presentant-ou-a-risque-de-traumatisme-vertebromedullaire/'
on conflict (recommendation_code) do nothing;
