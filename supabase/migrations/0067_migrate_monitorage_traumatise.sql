-- Migration : Monitorage du patient traumatisé grave en préhospitalier
-- (SFAR/Samu de France/SFMU/SRLF, Conférence d'experts, texte court, 2006)
-- Source : rfe-sfar-website/build/content_monitorage_traumatise.json (55
-- recommandations individuelles réparties sur 8 questions — exactement le
-- compte que la fiche construite annonce elle-même : "55 recommandations
-- individuelles reproduites... sur 75 lettres de grade imprimées au total
-- dans le document, le reste étant des faits de contexte/justification non
-- promus en ligne de tableau").
--
-- ⚠️ PROVENANCE — DISCLOSURE OBLIGATOIRE : `content_monitorage_traumatise.json`
-- fait partie des 9 fichiers "KNOWN DRIFT" documentés dans
-- `rfe-sfar-website/CLAUDE.md` — récupéré depuis l'Artifact publié en ligne
-- sans qu'aucun `fiche_*.py` ni fichier source n'ait jamais été committé
-- dans ce dépôt. Ce contenu N'A PAS suivi le pipeline de triple-lecture +
-- audit indépendant normalement exigé par ce projet et N'A PAS été
-- re-vérifié contre le PDF source par cette migration. Statut `draft`
-- comme toute migration, mais attention de relecture supérieure
-- recommandée (même disclosure que `examens_preinterventionnels`/0065,
-- `traumatisme_cranien_grave_precoce`/0066).
--
-- MÉTHODOLOGIE — conférence d'experts, PAS de système GRADE. Niveaux de
-- preuve I à V, d'où une force de recommandation A à E imprimée après
-- chaque énoncé (A = >= 2 études niveau I ; B = 1 étude niveau I ; C =
-- étude(s) niveau II ; D = étude(s) niveau III ; E = étude(s) niveau IV/V,
-- avis d'experts). `grade` reproduit cette lettre A-E telle quelle.
-- `evidence_level` laissé NULL : un seul axe de cotation dans ce document
-- (même convention que `hsa`/0023 pour un système de force A-E analogue).
--
-- DISCLOSURE DÉJÀ FAITE PAR LA FICHE SOURCE (reproduite ici) : plusieurs
-- passages de prose portent une lettre de grade sans être promus en ligne
-- de tableau distincte, car ils reprennent/précisent un thème déjà couvert
-- par une ligne migrée (ex. écho-Doppler non gradé, FAST Grade E/D déjà
-- couvert par R12, PETCO2 pronostique Grade D non repris car même thème
-- que la capnographie R24-R29, monitorage minimal Grade E en Q6 non repris
-- car même thème que R36-R39). Volontairement pas dupliqué en lignes
-- supplémentaires — disclosure, pas un oubli.
--
-- POPULATION : `population = 'Femme enceinte'` sur les 3 lignes RCF (Q7) ;
-- `population = 'Pédiatrie'` sur les 4 lignes "— enfant" (Q7). NULL
-- ailleurs (48 lignes, population adulte traumatisé grave implicite,
-- déjà dans le titre/champ du document).
--
-- PÉRIMÈTRE — volontairement pas migrés en recommandations distinctes
-- (disclosure, pas un oubli) : le Tableau (légende) "niveaux de preuve I-V
-- -> force A-E" (grille de définition méthodologique, pas une proposition
-- clinique) ; la section "Synthèse et messages clés" en fin de document
-- (résumé de haut niveau des recommandations déjà migrées, pas un contenu
-- supplémentaire).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Samu de France, co-auteur de cette conférence d'experts au même titre
--    que la SFAR, ne figure pas dans le seed Annexe B. SFMU et SRLF, en
--    revanche, figurent dans le seed et SONT liées ci-dessous avec la SFAR
--    (contrairement au traitement "SFAR seule" de plusieurs autres fiches
--    de ce lot).
-- 2. `library_final.json` classe ce document `exact_type: "RFE"` ; la
--    source se désigne elle-même comme une "Conférence d'experts, texte
--    court" — `doc_type` reprend l'auto-désignation de la source, la
--    classification de l'index reproduite en commentaire pour traçabilité.
-- 3. `library_final.json` ne donne que l'année ("2006") — `publication_date`
--    utilise 2006-01-01 par convention (même traitement que
--    `allergie_prevention`/0006).
-- 4. Freshness : la source elle-même déclare "Document de 2006 : les
--    pratiques de monitorage préhospitalier (échographie, biologie
--    délocalisée) ont pu évoluer depuis" — `freshness_status =
--    'revision_detectee'` retenu (même critère que `sepsis_hemodynamique`/
--    0045, `sevrage_vm`/0046 : disclosure explicite de péremption possible
--    par la source elle-même).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Monitorage du patient traumatisé grave en préhospitalier',
  'Conférence d''experts', 'fr', '2006-01-01',
  'https://sfar.org/monitorage-du-patient-traumatise-grave-en-prehospitalier/',
  'https://sfar.org/wp-content/uploads/2015/10/2_SFAR_texte-court_Monitorage-du-patient-traumatise-grave-en-prehospitalier.pdf',
  'Conférence d''experts, pas de système GRADE. Niveaux de preuve I à V, force de recommandation A à E (A = >= 2 études niveau I ; B = 1 étude niveau I ; C = niveau II ; D = niveau III ; E = niveau IV/V, avis d''experts). library_final.json classe ce document "RFE" ; la source se désigne elle-même comme "Conférence d''experts, texte court" — divergence reproduite, non résolue arbitrairement. evidence_level non applicable (axe de cotation unique).',
  'revision_detectee'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/monitorage-du-patient-traumatise-grave-en-prehospitalier/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'), ('SFMU', 'France'), ('SRLF', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/monitorage-du-patient-traumatise-grave-en-prehospitalier/'
  and s.slug in ('anesthesie_reanimation', 'medecine_d_urgence')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.condition_topic, v.source_section,
  'https://sfar.org/monitorage-du-patient-traumatise-grave-en-prehospitalier/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000067-R01', 'Seule la mise en place systématique d''un oxymètre de pouls permet de s''assurer de l''existence d''une oxygénation adaptée.', 'D', null, 'Oxygénation', 'Q1 — Justification du monitorage'),
  ('MG-ANES-000067-R02', 'Le positionnement endotrachéal de la sonde d''intubation et l''adéquation de la ventilation sont optimisés par l''utilisation de la capnographie.', 'D', null, 'Ventilation / IOT', 'Q1 — Justification du monitorage'),
  ('MG-ANES-000067-R03', 'La réalisation d''une échographie pleurale peut s''avérer être une aide diagnostique, pour limiter les gestes potentiellement délétères comme un drainage thoracique iatrogène.', 'E', null, 'Échographie pleurale', 'Q1 — Justification du monitorage'),
  ('MG-ANES-000067-R04', 'Le monitorage répété de l''intensité douloureuse par les échelles d''autoévaluation (échelle visuelle analogique ou échelle numérique) est nécessaire pour améliorer le soulagement des patients.', 'D', null, 'Douleur', 'Q1 — Justification du monitorage'),
  ('MG-ANES-000067-R05', 'La surveillance électrocardioscopique est indispensable.', 'D', null, 'ECG', 'Q2 (1/2) — Monitorage cardiovasculaire'),
  ('MG-ANES-000067-R06', 'La réalisation d''un ECG est recommandée en cas de traumatisme grave (peut être différée jusqu''à l''arrivée au centre hospitalier selon le contexte).', 'E', null, 'ECG', 'Q2 (1/2) — Monitorage cardiovasculaire'),
  ('MG-ANES-000067-R07', 'La mesure de la pression artérielle nécessite l''utilisation d''un brassard de taille adaptée au bras du patient et son positionnement correct sur le trajet artériel.', 'D', null, 'PA non invasive', 'Q2 (1/2) — Monitorage cardiovasculaire'),
  ('MG-ANES-000067-R08', 'La méthode oscillométrique n''est pas fiable en cas d''hypotension, de frissons, d''arythmie ou de mobilisation du patient.', 'D', null, 'PA non invasive', 'Q2 (1/2) — Monitorage cardiovasculaire'),
  ('MG-ANES-000067-R09', 'En intrahospitalier, la mesure invasive de la pression artérielle permet d''obtenir une mesure fiable et continue même en cas d''hypotension sévère ou de mobilisation du patient — élément indispensable dans la prise en charge des états de choc post-traumatiques.', 'A', null, 'PA invasive', 'Q2 (1/2) — Monitorage cardiovasculaire'),
  ('MG-ANES-000067-R10', 'La mise en place précoce, dès la phase préhospitalière, d''un cathéter artériel peut être envisagée dans la mesure où la pose est réalisée sur un seul site artériel et dans un délai maximal de 10 minutes (bénéfice/risque à évaluer au cas par cas ; abord fémoral privilégié).', 'D', null, 'PA invasive', 'Q2 (1/2) — Monitorage cardiovasculaire'),
  ('MG-ANES-000067-R11', 'Un apprentissage préalable et un entraînement régulier de toute l''équipe sont indispensables pour que la pose d''un cathéter artériel puisse être réalisée en préhospitalier.', 'E', null, 'PA invasive', 'Q2 (1/2) — Monitorage cardiovasculaire'),
  ('MG-ANES-000067-R12', 'L''échographie selon la technique FAST (Focused Abdominal Sonography for Trauma) permet d''améliorer le triage des patients en cas de victimes multiples.', 'D', null, 'Échographie FAST', 'Q2 (1/2) — Monitorage cardiovasculaire'),
  ('MG-ANES-000067-R13', 'La mesure de la température en préhospitalier est recommandée : l''hypothermie, fréquente chez le traumatisé grave, est associée à une forte mortalité.', 'C', null, 'Température', 'Q2 (2/2) — Monitorage thermique'),
  ('MG-ANES-000067-R14', 'La voie rectale, d''accessibilité difficile, est peu utilisée ; on lui préfère la mesure tympanique (patient non intubé) ou œsophagienne (patient intubé).', 'E', null, 'Température', 'Q2 (2/2) — Monitorage thermique'),
  ('MG-ANES-000067-R15', 'En cas d''hypothermie majeure, la voie œsophagienne est contre-indiquée en raison du risque de fibrillation ventriculaire à la pose de la sonde.', 'E', null, 'Température', 'Q2 (2/2) — Monitorage thermique'),
  ('MG-ANES-000067-R16', 'La mesure de la température buccale ou axillaire, trop influencée par les conditions environnantes, doit être abandonnée.', 'D', null, 'Température', 'Q2 (2/2) — Monitorage thermique'),
  ('MG-ANES-000067-R17', 'L''oxymètre de pouls est un outil indispensable en préhospitalier ; il permet une détection plus précoce et plus fiable de l''hypoxémie que l''évaluation clinique.', 'D', null, 'SpO2', 'Q3 — Monitorage respiratoire'),
  ('MG-ANES-000067-R18', 'Les critères décisionnels amenant à la réalisation d''une intubation trachéale prennent en compte les valeurs de SpO2, notamment chez le patient traumatisé.', 'E', null, 'SpO2', 'Q3 — Monitorage respiratoire'),
  ('MG-ANES-000067-R19', 'En cas de difficultés d''intubation, l''utilisation de la SpO2 semble limiter la survenue et la durée des épisodes d''hypoxémie sévère.', 'E', null, 'SpO2', 'Q3 — Monitorage respiratoire'),
  ('MG-ANES-000067-R20', 'La SpO2 semble être un facteur pronostique de gravité en traumatologie, permettant d''intégrer ce paramètre dans le triage des patients.', 'E', null, 'SpO2 — pronostic', 'Q3 — Monitorage respiratoire'),
  ('MG-ANES-000067-R21', 'Un seuil de SpO2 au moins égal à 94 % doit être ciblé pour détecter toutes les SaO2 < 90 %.', 'E', null, 'SpO2 — seuil', 'Q3 — Monitorage respiratoire'),
  ('MG-ANES-000067-R22', 'Le monitorage de la pression du ballonnet de la sonde d''intubation est nécessaire pour limiter les complications trachéales liées à l''intubation.', 'B', null, 'Ballonnet IOT', 'Q3 — Monitorage respiratoire'),
  ('MG-ANES-000067-R23', 'Les alarmes du respirateur à régler et à surveiller sont les alarmes de pression inspiratoire maximale et minimale, ainsi que celles de spirométrie.', 'E', null, 'Ventilation mécanique', 'Q3 — Monitorage respiratoire'),
  ('MG-ANES-000067-R24', 'Le monitorage de la capnographie est fortement recommandé en préhospitalier lors de la réalisation de l''intubation trachéale ; c''est la méthode de référence pour détecter l''intubation œsophagienne.', 'D', null, 'Capnographie', 'Q3 — Monitorage respiratoire'),
  ('MG-ANES-000067-R25', 'Sa mise en place dès les manœuvres de préoxygénation est souhaitable.', 'E', null, 'Capnographie', 'Q3 — Monitorage respiratoire'),
  ('MG-ANES-000067-R26', 'La capnographie permet d''optimiser rapidement et de façon non invasive la ventilation en préhospitalier.', 'B', null, 'Capnographie', 'Q3 — Monitorage respiratoire'),
  ('MG-ANES-000067-R27', 'La visualisation du capnogramme est un élément de sécurité indispensable pour la surveillance du patient ventilé.', 'E', null, 'Capnographie', 'Q3 — Monitorage respiratoire'),
  ('MG-ANES-000067-R28', 'Pour les patients qui justifient d''un contrôle strict de la PaCO2 (notamment en cas de souffrance neurologique), le monitorage de la capnographie doit être complété par une mesure des gaz du sang dès que possible.', 'D', null, 'Capnographie', 'Q3 — Monitorage respiratoire'),
  ('MG-ANES-000067-R29', 'L''évolution de la PETCO2 permet de guider les manœuvres de réanimation en cas d''arrêt cardiaque.', 'D', null, 'Capnographie', 'Q3 — Monitorage respiratoire'),
  ('MG-ANES-000067-R30', 'La prévention des agressions cérébrales secondaires d''origine systémique (ACSOS) passe avant tout par la prévention et le traitement des épisodes d''hypotension et d''hypoxie.', 'D', null, 'ACSOS', 'Q4 — Monitorage neurologique'),
  ('MG-ANES-000067-R31', 'Le maintien de la PaCO2 entre 35 et 40 mmHg est recommandé chez le traumatisé crânien grave.', 'B', null, 'PaCO2 cible', 'Q4 — Monitorage neurologique'),
  ('MG-ANES-000067-R32', 'Le maintien de l''osmolarité plasmatique est recommandé.', 'E', null, 'Osmolarité', 'Q4 — Monitorage neurologique'),
  ('MG-ANES-000067-R33', 'La technique du Doppler transcrânien est actuellement utilisée pour le traitement et le suivi thérapeutique en intrahospitalier ; son intérêt en médecine préhospitalière reste à évaluer.', 'D', null, 'Doppler transcrânien', 'Q4 — Monitorage neurologique'),
  ('MG-ANES-000067-R34', 'L''utilisation d''un hémoglobinomètre type Hémocue® est préférable à la mesure de l''hématocrite par microméthode.', 'A', null, 'Hémoglobine', 'Q5 — Monitorage biologique'),
  ('MG-ANES-000067-R35', 'Chez le patient victime d''un traumatisme crânien grave, la mesure des gaz du sang permet une adaptation des paramètres ventilatoires plus précise que lorsque celle-ci est réalisée à partir de la seule mesure de la PETCO2.', 'D', null, 'Gaz du sang', 'Q5 — Monitorage biologique'),
  ('MG-ANES-000067-R36', 'Avant le transport, devant une instabilité hémodynamique, une échographie abdominale et pleurale est une aide à la décision d''orientation et/ou de traitement.', 'E', null, 'Échographie avant transport', 'Q6 — Monitorage en intervention secondaire (transferts)'),
  ('MG-ANES-000067-R37', 'Lorsque le patient est ventilé pendant le transfert, le monitorage de la capnographie est indispensable.', 'B', null, 'Ventilation mécanique', 'Q6 — Monitorage en intervention secondaire (transferts)'),
  ('MG-ANES-000067-R38', 'Les paramètres respiratoires doivent être ajustés en fonction du contrôle gazométrique effectué sous ventilation par le respirateur de transport.', 'E', null, 'Ventilation mécanique', 'Q6 — Monitorage en intervention secondaire (transferts)'),
  ('MG-ANES-000067-R39', 'Le monitorage invasif de la pression artérielle se justifie par la gravité du patient et par la durée prévisible du transfert, en particulier chez le patient présentant un traumatisme crânien grave et/ou une hémorragie.', 'E', null, 'PA invasive', 'Q6 — Monitorage en intervention secondaire (transferts)'),
  ('MG-ANES-000067-R40', 'La surveillance du rythme cardiaque fœtal (RCF), réalisée préférentiellement de façon continue, est l''élément clé de la surveillance de la vitalité fœtale après un traumatisme chez la femme enceinte.', 'C', 'Femme enceinte', 'RCF — femme enceinte', 'Q7 — Femme enceinte et enfant traumatisés graves'),
  ('MG-ANES-000067-R41', 'La surveillance du RCF en préhospitalier est faisable.', 'D', 'Femme enceinte', 'RCF — femme enceinte', 'Q7 — Femme enceinte et enfant traumatisés graves'),
  ('MG-ANES-000067-R42', 'La surveillance du RCF en préhospitalier est souhaitable.', 'E', 'Femme enceinte', 'RCF — femme enceinte', 'Q7 — Femme enceinte et enfant traumatisés graves'),
  ('MG-ANES-000067-R43', 'La mesure de la fréquence cardiaque, de la pression artérielle non invasive, de l''oxymétrie pulsée et de la capnographie est recommandée pour tous les enfants traumatisés graves, avec un matériel adapté à leur gabarit.', 'A', 'Pédiatrie', 'Monitorage — enfant', 'Q7 — Femme enceinte et enfant traumatisés graves'),
  ('MG-ANES-000067-R44', 'La connaissance du mode ventilatoire, des pressions de crête, et de la spirométrie expirée est souhaitable chez l''enfant traumatisé grave.', 'E', 'Pédiatrie', 'Ventilation — enfant', 'Q7 — Femme enceinte et enfant traumatisés graves'),
  ('MG-ANES-000067-R45', 'La surveillance de la pression du ballonnet de la sonde d''intubation est utile pour la prévention des lésions trachéales ischémiques chez l''enfant.', 'D', 'Pédiatrie', 'Ballonnet IOT — enfant', 'Q7 — Femme enceinte et enfant traumatisés graves'),
  ('MG-ANES-000067-R46', 'Il est recommandé de mesurer la température corporelle, la concentration en hémoglobine, la glycémie et l''intensité de la douleur sur une échelle adaptée à l''enfant.', 'D', 'Pédiatrie', 'Autres paramètres — enfant', 'Q7 — Femme enceinte et enfant traumatisés graves'),
  ('MG-ANES-000067-R47', 'En montagne, le monitorage de la température doit être systématique, le patient traumatisé grave étant le plus souvent hypotherme.', 'E', null, 'Montagne — température', 'Q8 — Monitorage en milieu difficile'),
  ('MG-ANES-000067-R48', 'Lorsque le patient n''est pas en arrêt circulatoire, le site de mesure privilégié en terrain périlleux est le conduit auditif externe (température épitympanique), au mieux par un thermomètre tympanique résistant au froid.', 'E', null, 'Montagne — température', 'Q8 — Monitorage en milieu difficile'),
  ('MG-ANES-000067-R49', 'En cas d''arrêt circulatoire, la mesure de la température ne peut se faire que par une sonde œsophagienne ou, éventuellement, rectale ; elle permet de trier les patients susceptibles de bénéficier d''une circulation extracorporelle de réchauffement.', 'D', null, 'Montagne — température', 'Q8 — Monitorage en milieu difficile'),
  ('MG-ANES-000067-R50', 'En milieu hostile, la dotation minimale comprend un petit oxymètre de pouls, un mini-tensiomètre électronique et un mini-cardioscope ou défibrillateur semi-automatique débrayable en mode manuel avec câble ECG 3 brins.', 'E', null, 'Montagne — matériel', 'Q8 — Monitorage en milieu difficile'),
  ('MG-ANES-000067-R51', 'En situation de catastrophe, les appareils de monitorage employés doivent être dotés d''alarmes sonores, avoir une autonomie suffisante, fonctionner de préférence avec des piles à usage unique et être résistants aux chocs.', 'E', null, 'Catastrophe — matériel', 'Q8 — Monitorage en milieu difficile'),
  ('MG-ANES-000067-R52', 'Le monitorage de la pression artérielle en situation de catastrophe sera, en cas de traumatisme grave, préférentiellement réalisé à l''aide d''un brassard automatique.', 'E', null, 'Catastrophe — PA', 'Q8 — Monitorage en milieu difficile'),
  ('MG-ANES-000067-R53', 'La position endotrachéale de la sonde d''intubation peut être vérifiée, en complément de l''auscultation, par l''utilisation d''indicateurs colorimétriques et/ou par un test à la seringue.', 'D', null, 'Catastrophe — IOT', 'Q8 — Monitorage en milieu difficile'),
  ('MG-ANES-000067-R54', 'L''échographie permet d''identifier rapidement un épanchement pleural ou péritonéal au poste médical avancé (PMA).', 'D', null, 'Catastrophe — échographie', 'Q8 — Monitorage en milieu difficile'),
  ('MG-ANES-000067-R55', 'L''échographie pourrait avoir un intérêt comme outil de tri au PMA, afin d''évacuer ces patients en priorité.', 'E', null, 'Catastrophe — échographie', 'Q8 — Monitorage en milieu difficile')
) as v(code, statement, grade, population, condition_topic, source_section)
where d.source_url = 'https://sfar.org/monitorage-du-patient-traumatise-grave-en-prehospitalier/'
on conflict (recommendation_code) do nothing;
