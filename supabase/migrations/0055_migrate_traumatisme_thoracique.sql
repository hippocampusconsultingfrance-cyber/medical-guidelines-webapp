-- Migration : Traumatisme thoracique : prise en charge des 48 premières
-- heures — Recommandations Formalisées d'Experts communes SFAR-SFMU, avec
-- la SFCTCV (chirurgie thoracique et cardiovasculaire) et la SFR. Anesth
-- Reanim. 2015;1:272-287, en ligne le 23/05/2015. Président P. Michelet
-- (SFAR), secrétaire L. Ducros (SFMU). Première RFE française sur ce
-- sujet — aucune recommandation antérieure d'une société savante
-- française n'existait sur la prise en charge spécifique du traumatisme
-- thoracique (disclosure de la source elle-même). Source :
-- rfe-sfar-website/build/content_traumatisme_thoracique.json (48
-- recommandations réparties sur 7 questions au format PICO).
--
-- MÉTHODOLOGIE : GRADE®, format PICO, cotation Delphi en 2 tours. Tags
-- littéraux « (G1+/-) », « (G2+/-) » ou « (Avis d'experts) » imprimés
-- après chaque proposition — cités ici tels quels (« AE » = Avis
-- d'experts). `grade` reproduit tel quel le chip source. `evidence_level`
-- laissé NULL.
--
-- PIÈGE D'EXTRACTION IDENTIFIÉ ET CORRIGÉ AVANT INTÉGRATION (disclosure de
-- la source elle-même, reprise ici) : le signe moins de 5 tags « G1- »/
-- « G2- » a été corrompu en caractère de contrôle non imprimable par
-- l'extraction automatique du PDF source — confirmé par rendu visuel de la
-- page 3 (le paragraphe méthodologique lui-même définit littéralement
-- « GRADE 1+ ou 1- » / « GRADE 2+ ou 2- ») avant correction. Les grades
-- '1-' et '2-' ci-dessous (R28/6.B.1(a), R44/6.B.1(b), R48/7.B(b)) sont
-- donc reproduits post-correction.
--
-- COMPTAGE — DIVERGENCE DISCLOSED, NON RÉCONCILIÉE PAR LA SOURCE
-- ELLE-MÊME : le résumé officiel de la source annonce un total agrégé de
-- « 60 recommandations formalisées » (accord fort pour 50 [90 %], accord
-- faible pour 10), chiffre cité tel quel dans l'introduction sans être
-- recalculé ni réparti ligne par ligne — la source elle-même ne détaille
-- pas cette correspondance exacte. Inventaire direct : 48 énoncés
-- individuellement gradés (chaque « Proposition » numérotée par la source
-- pouvant regrouper plusieurs phrases distinctement graduées, ici
-- éclatées en lignes séparées selon leur propre tag de grade). Distribution
-- directe : 19×1+, 17×2+, 7×AE, 4×2-, 1×1-. La correspondance exacte entre
-- ce compte de 48 et le chiffre agrégé de 60 (et la répartition
-- fort/faible 50/10) n'est pas reconstituable depuis le texte publié — ni
-- forcée ni recalculée ici, disclosed telle quelle.
--
-- PÉRIMÈTRE — exclusions explicites de la source elle-même : atteintes
-- cardiaques et diaphragmatiques, et prise en charge au-delà des 48
-- premières heures. Aucune table de classification ou figure de référence
-- identifiée nécessitant une exclusion additionnelle dans ce document (à
-- la différence de traumatisme_membre ou traumatisme_pelvien) — le
-- contenu construit est composé presque intégralement des 7 tableaux
-- Réf./Recommandation/Grade formellement structurés.
--
-- POPULATION : aucun contenu spécifiquement pédiatrique ou obstétrical
-- identifié dans la source — population laissée NULL sur toutes les
-- lignes.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFAR et SFMU (toutes deux dans le seed Annexe B) liées en
--    document_societies ; SFCTCV et SFR (co-auteurs) hors seed, non
--    liées.
-- 2. `exact_date` de library_final.json n'indique que l'année ("2015"),
--    sans mois/jour ; la source elle-même précise « en ligne le
--    23/05/2015 » — cette date de mise en ligne est utilisée comme
--    publication_date, plus précise que l'entrée d'index.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Traumatisme thoracique : prise en charge des 48 premières heures',
  'RFE', 'fr', '2015-05-23',
  'https://sfar.org/traumatisme-thoracique-prise-en-charge-des-48-premieres-heures/',
  'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Traumatisme-thoracique-_prise-en-charge-des-48-premieres-heures.pdf',
  'GRADE® : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ probablement recommandé / 2- probablement non recommandé) ; AE = avis d''experts. Comptage direct : 48 recommandations (19×1+, 17×2+, 7×AE, 4×2-, 1×1-). La source annonce un total agrégé de "60 recommandations formalisées (accord fort 50, accord faible 10)" non réparti ligne par ligne par la source elle-même — divergence disclosed, non réconciliée.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/traumatisme-thoracique-prise-en-charge-des-48-premieres-heures/'
  and s.acronym in ('SFAR', 'SFMU') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/traumatisme-thoracique-prise-en-charge-des-48-premieres-heures/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'medecine_d_urgence', 'chirurgie_thoracique', 'chirurgie_vasculaire', 'radiologie_et_imagerie_medicale')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/traumatisme-thoracique-prise-en-charge-des-48-premieres-heures/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000055-R01', 'Les experts recommandent de considérer comme éléments de gravité potentielle les antécédents du patient : un âge de plus de 65 ans, une pathologie pulmonaire ou cardiovasculaire chronique, un trouble de la coagulation congénital ou acquis (traitement anticoagulant ou antiagrégant), les circonstances de survenue telles qu''un traumatisme de forte cinétique et/ou un traumatisme pénétrant.', '1+', 'Q1 — Critères de gravité et orientation (Réf. 1A)'),
  ('MG-ANES-000055-R02', 'Les experts recommandent de considérer comme critères de gravité lors d''un traumatisme thoracique : l''existence de plus de 2 fractures de côtes, surtout chez un patient âgé de plus de 65 ans, la constatation d''une détresse respiratoire clinique (FR > 25/min et/ou hypoxémie SpO2 < 90 % sous air ou < 95 % malgré oxygénothérapie), d''une détresse circulatoire (chute de PAS > 30 % ou PAS < 110 mmHg).', '1+', 'Q1 — Critères de gravité et orientation (Réf. 1B (a))'),
  ('MG-ANES-000055-R03', 'Les experts proposent l''utilisation du score de MGAP afin de trier les patients ne présentant pas de critère de gravité initiale.', '2+', 'Q1 — Critères de gravité et orientation (Réf. 1B (b))'),
  ('MG-ANES-000055-R04', 'Les experts recommandent un transport médicalisé pour tout patient présentant des critères potentiels de gravité ou des signes de détresse vitale. L''orientation se fera vers un centre de référence dès l''existence de signes de détresse respiratoire et/ou circulatoire.', '1+', 'Q1 — Critères de gravité et orientation (Réf. 1C (a))'),
  ('MG-ANES-000055-R05', 'Les experts proposent que tout patient présentant un terrain à risque bénéficie d''un avis spécialisé, si nécessaire par téléphone ou télétransmission. Ces patients doivent pouvoir être surveillés pendant 24 heures. Les experts proposent de mettre en place des conventions entre établissements pour organiser les conditions de réalisation des avis spécialisés.', 'AE', 'Q1 — Critères de gravité et orientation (Réf. 1C (b))'),
  ('MG-ANES-000055-R06', 'En préhospitalier, en complément de l''examen clinique, les experts suggèrent que l''échographie pleuropulmonaire soit associée à la FAST échographie à la recherche d''un épanchement gazeux ou liquidien, associée à une évaluation péricardique. Cet examen doit être réalisé par un praticien expérimenté et ne doit pas retarder la prise en charge.', '2+', 'Q2 — Stratégie diagnostique (Réf. 2A (a))'),
  ('MG-ANES-000055-R07', 'Au déchocage, les experts recommandent l''échographie pleuropulmonaire associée à la FAST échographie et la radiographie du thorax en première intention.', '1+', 'Q2 — Stratégie diagnostique (Réf. 2A (b))'),
  ('MG-ANES-000055-R08', 'Chez les patients avec critères de gravité, les experts recommandent la réalisation systématique d''une tomodensitométrie thoracique avec injection en tant qu''élément de la tomodensitométrie corps entier.', '1+', 'Q2 — Stratégie diagnostique (Réf. 2B (a))'),
  ('MG-ANES-000055-R09', 'Les experts suggèrent de faire une échographie pleuropulmonaire et de ne pas réaliser de radiographies du thorax si l''examen clinique ne met en évidence qu''une lésion pariétale bénigne isolée sans critère de gravité.', '2+', 'Q2 — Stratégie diagnostique (Réf. 2B (b))'),
  ('MG-ANES-000055-R10', 'En cas de lésion thoracique, autre que pariétale, suspectée par l''examen clinique ou révélée par l''échographie pleuropulmonaire ou une radiographie du thorax, les experts recommandent la réalisation d''une tomodensitométrie thoracique injectée.', '1+', 'Q2 — Stratégie diagnostique (Réf. 2B (c))'),
  ('MG-ANES-000055-R11', 'En milieu intrahospitalier, face à une hypoxémie, les experts recommandent de délivrer une ventilation non invasive de type VSAI-PEP après réalisation d''une tomodensitométrie et du drainage d''un pneumothorax lorsqu''il est indiqué, en l''absence de contre-indication à la VNI et dans un environnement disposant d''une surveillance continue.', '1+', 'Q3 — Support ventilatoire (Réf. 3.A.1)'),
  ('MG-ANES-000055-R12', 'La ventilation mécanique après intubation en induction séquence rapide est recommandée en l''absence d''amélioration clinique ou gazométrique à une heure.', '1+', 'Q3 — Support ventilatoire (Réf. 3.A.2)'),
  ('MG-ANES-000055-R13', 'Les experts recommandent que le volume courant soit réglé entre 6 et 8 mL/kg de poids idéal en raison du caractère non homogène du poumon traumatisé. La pression plateau doit être maintenue < 30 cmH2O.', '1+', 'Q3 — Support ventilatoire (Réf. 3.B.1)'),
  ('MG-ANES-000055-R14', 'Chez le patient hypoxémique, les experts proposent d''adapter la PEP afin de maintenir une FiO2 < 60 % et une SpO2 > 92 % si la tolérance hémodynamique et ventilatoire le permet. La PEP doit être au moins égale à 5 cmH2O.', '2+', 'Q3 — Support ventilatoire (Réf. 3.B.2)'),
  ('MG-ANES-000055-R15', 'Le contrôle de la douleur est une urgence. Les experts recommandent une évaluation systématique de l''intensité de la douleur en utilisant une échelle numérique (EN) de première intention, sinon une échelle verbale simple (EVS). La mesure doit se faire au repos, mais aussi lors de la toux et de l''inspiration profonde.', '2+', 'Q4 — Analgésie, préhospitalier (Réf. 4.A.1)'),
  ('MG-ANES-000055-R16', 'En présence d''une douleur intense, une titration par morphine est recommandée avec pour objectif le soulagement défini par une EN ≤ 3 ou EVS < 2.', '1+', 'Q4 — Analgésie, préhospitalier (Réf. 4.A.2)'),
  ('MG-ANES-000055-R17', 'Pour la mobilisation du patient, après une titration morphinique bien conduite mais insuffisante, les experts recommandent l''utilisation de la kétamine.', 'AE', 'Q4 — Analgésie, préhospitalier (Réf. 4.A.3 (a))'),
  ('MG-ANES-000055-R18', 'Si un geste invasif s''avère nécessaire, il doit se faire avec une analgésie sédation efficace.', 'AE', 'Q4 — Analgésie, préhospitalier (Réf. 4.A.3 (b))'),
  ('MG-ANES-000055-R19', 'Les experts suggèrent d''évaluer la douleur spontanée de repos et d''effort (toux efficace et inspiration profonde) grâce aux échelles EN ou EVS, avec pour objectif cible une EN ≤ 3 ou une EVS ≤ 2.', '2+', 'Q4 — Analgésie, intrahospitalier (Réf. 4.B.1)'),
  ('MG-ANES-000055-R20', 'L''anesthésie locorégionale (ALR) doit pouvoir être proposée chez le patient à risque ainsi que chez le patient présentant une douleur non contrôlée dans les 12 heures.', '1+', 'Q4 — Analgésie, intrahospitalier (Réf. 4.B.2 (a))'),
  ('MG-ANES-000055-R21', 'Il faut probablement préférer le bloc para vertébral à l''analgésie péridurale lors de lésions costales unilatérales, et si possible sous contrôle échographique pour la mise en place d''un cathéter.', '2+', 'Q4 — Analgésie, intrahospitalier (Réf. 4.B.2 (b))'),
  ('MG-ANES-000055-R22', 'Lors de lésions complexes (multi-étagées) ou bilatérales, les experts recommandent que l''analgésie péridurale soit proposée, le geste devant être alors réalisé par un anesthésiste réanimateur.', '1+', 'Q4 — Analgésie, intrahospitalier (Réf. 4.B.2 (c))'),
  ('MG-ANES-000055-R23', 'Les experts recommandent que l''analgésie soit multimodale (dans le respect des contre-indications) en privilégiant la morphine avec une administration par mode PCA (analgésie contrôlée par le patient). Cette technique peut compléter efficacement un bloc paravertébral.', '1+', 'Q4 — Analgésie, intrahospitalier (Réf. 4.B.3 (a))'),
  ('MG-ANES-000055-R24', 'Les experts suggèrent de ne pas utiliser le mode PCA pour la morphine en systémique en présence d''une analgésie péridurale.', '2-', 'Q4 — Analgésie, intrahospitalier (Réf. 4.B.3 (b))'),
  ('MG-ANES-000055-R25', 'Les experts recommandent une décompression en urgence en cas de détresse respiratoire aiguë ou hémodynamique avec forte suspicion de tamponnade gazeuse.', '1+', 'Q5 — Drainage pleural (Réf. 5.A (a))'),
  ('MG-ANES-000055-R26', 'Les experts suggèrent une thoracostomie par voie axillaire en cas d''arrêt cardiaque et/ou en cas d''échec de l''exsufflation.', '2+', 'Q5 — Drainage pleural (Réf. 5.A (b))'),
  ('MG-ANES-000055-R27', 'Les experts recommandent de drainer sans délai tout pneumothorax complet, tout épanchement liquidien ou aérique responsable d''un retentissement respiratoire et/ou hémodynamique.', '1+', 'Q5 — Drainage pleural (Réf. 5.B (a))'),
  ('MG-ANES-000055-R28', 'Les experts suggèrent de drainer un hémothorax évalué à plus de 500 mL (critère échographique et/ou radio-TDM).', '2+', 'Q5 — Drainage pleural (Réf. 5.B (b))'),
  ('MG-ANES-000055-R29', 'En cas de pneumothorax minime, unilatéral et sans retentissement clinique, le drainage n''est pas systématique : surveillance simple avec nouvelle radiographie de contrôle à 12 h. En cas de nécessité d''une ventilation mécanique invasive, le drainage thoracique n''est pas systématique non plus. En cas de bilatéralité du pneumothorax, s''ils sont minimes, le drainage n''est pas systématique mais discuté au cas par cas selon le caractère de l''épanchement gazeux.', 'AE', 'Q5 — Drainage pleural (Réf. 5.B (c))'),
  ('MG-ANES-000055-R30', 'Les experts suggèrent que le drainage ou la décompression soit réalisé par voie axillaire au 4e ou 5e EIC sur la ligne axillaire moyenne plutôt que par voie antérieure. Les experts suggèrent la mise en place de drains non traumatisants à bout mousse, en évitant l''usage d''un trocart court et/ou à bout tranchant.', '2+', 'Q5 — Drainage pleural (Réf. 5.C.1)'),
  ('MG-ANES-000055-R31', 'Les experts proposent l''emploi de drains de faible calibre (18 à 24 F) pour le drainage des pneumothorax isolés. En cas d''hémothorax, les experts proposent d''utiliser des drains de gros calibre (28 à 36 F). L''emploi de drains de petit calibre de type « queue de cochon » est considéré comme une alternative possible pour le drainage des pneumothorax isolés, sans épanchement hématique associé.', '2+', 'Q5 — Drainage pleural (Réf. 5.C.2)'),
  ('MG-ANES-000055-R32', 'Les experts ne proposent pas de recourir à une antibioprophylaxie avant drainage thoracique dans le cas des traumatismes thoraciques fermés.', '2-', 'Q5 — Drainage pleural (Réf. 5.C.3)'),
  ('MG-ANES-000055-R33', 'Les experts recommandent un traitement endovasculaire des lésions traumatiques de l''isthme aortique en première intention.', '1+', 'Q6 — Chirurgie et radiologie interventionnelle (Réf. 6.A.1 (a))'),
  ('MG-ANES-000055-R34', 'En l''absence de rupture complète, la prise en charge d''une autre urgence vitale prime sur la mise en place de l''endoprothèse. Les lésions aortiques minimes (rupture intimo-médiale) bénéficient d''un avis spécialisé.', 'AE', 'Q6 — Chirurgie et radiologie interventionnelle (Réf. 6.A.1 (b))'),
  ('MG-ANES-000055-R35', 'Les experts proposent le traitement endovasculaire des lésions traumatiques axillaires ou sous-clavières comme une alternative possible à la chirurgie.', '2+', 'Q6 — Chirurgie et radiologie interventionnelle (Réf. 6.A.2)'),
  ('MG-ANES-000055-R36', 'Les experts ne recommandent pas la réalisation d''une thoracotomie de ressuscitation en préhospitalier pour le traumatisme thoracique fermé.', '1-', 'Q6 — Chirurgie et radiologie interventionnelle (Réf. 6.B.1 (a))'),
  ('MG-ANES-000055-R37', 'En intrahospitalier, les experts suggèrent de ne pas réaliser de thoracotomie de ressuscitation en cas d''arrêt cardiaque après traumatisme thoracique fermé, si la durée de réanimation cardiopulmonaire dépasse 10 min sans récupération d''une activité circulatoire, et/ou lors d''une asystolie initiale en l''absence de tamponnade.', '2-', 'Q6 — Chirurgie et radiologie interventionnelle (Réf. 6.B.1 (b))'),
  ('MG-ANES-000055-R38', 'Les experts proposent qu''une thoracotomie d''hémostase soit réalisée : en cas d''instabilité hémodynamique et de saignement intrathoracique actif dans le drain thoracique (sans autre cause de saignement) ; ou en cas de stabilité hémodynamique si le débit du drain est supérieur à 1500 mL d''emblée avec poursuite > 200 mL/h dès la première heure, ou inférieur à 1500 mL avec poursuite > 200 mL/h pendant 3 heures.', 'AE', 'Q6 — Chirurgie et radiologie interventionnelle (Réf. 6.B.2)'),
  ('MG-ANES-000055-R39', 'Les experts recommandent la réalisation d''une thoracoscopie chirurgicale pour les hémothorax résiduels malgré un premier drainage thoracique bien conduit.', '1+', 'Q6 — Chirurgie et radiologie interventionnelle (Réf. 6.B.3)'),
  ('MG-ANES-000055-R40', 'Les experts recommandent une fixation chirurgicale chez le patient présentant un volet thoracique et ventilé mécaniquement, si l''état respiratoire ne permet pas un sevrage de la ventilation mécanique dans les 36 heures suivant leur admission.', '1+', 'Q6 — Chirurgie et radiologie interventionnelle (Réf. 6.B.4 (a))'),
  ('MG-ANES-000055-R41', 'Les experts proposent que tout fracas costal déplacé ou complexe bénéficie d''un avis spécialisé.', 'AE', 'Q6 — Chirurgie et radiologie interventionnelle (Réf. 6.B.4 (b))'),
  ('MG-ANES-000055-R42', 'Les experts suggèrent d''orienter directement sur un centre disposant d''un plateau technique spécialisé les patients qui présentent un traumatisme pénétrant de l''aire cardiaque (stable ou instable) ou du thorax avec état circulatoire ou respiratoire instable ou stabilisé.', '1+', 'Q7 — Traumatisme pénétrant (Réf. 7.A (a))'),
  ('MG-ANES-000055-R43', 'Les experts suggèrent d''orienter sur le centre chirurgical de proximité les patients dont l''état hémodynamique ne permet pas le transport vers un centre spécialisé. Pour les patients stables, transfert secondaire si des lésions intrathoraciques sont objectivées sur le bilan.', '2+', 'Q7 — Traumatisme pénétrant (Réf. 7.A (b))'),
  ('MG-ANES-000055-R44', 'Les experts suggèrent la réalisation d''une thoracotomie de ressuscitation en cas d''arrêt cardiaque après traumatisme thoracique pénétrant, après avoir éliminé un pneumothorax compressif et en cas de détresse circulatoire majeure chez les patients échappant aux mesures réanimatoires.', '2+', 'Q7 — Traumatisme pénétrant (Réf. 7.B (a))'),
  ('MG-ANES-000055-R45', 'En intrahospitalier, les experts suggèrent de ne pas réaliser de thoracotomie de ressuscitation en cas d''arrêt cardiaque après traumatisme thoracique pénétrant, si la durée de réanimation cardiopulmonaire dépasse 15 min sans signe de vie, et lors d''une asystolie initiale en l''absence de tamponnade.', '2-', 'Q7 — Traumatisme pénétrant (Réf. 7.B (b))'),
  ('MG-ANES-000055-R46', 'Les experts suggèrent l''abord chirurgical du thorax (thoracotomie antéro-latérale gauche, transverse ou sternotomie) en urgence en cas d''instabilité hémodynamique et/ou d''épanchement péricardique compressif à l''échographie.', '2+', 'Q7 — Traumatisme pénétrant (Réf. 7.C (a))'),
  ('MG-ANES-000055-R47', 'Les experts suggèrent une surveillance simple, en milieu spécialisé, en l''absence d''épanchement péricardique, d''hémothorax et de stabilité hémodynamique stricte après bilan tomodensitométrique.', '2+', 'Q7 — Traumatisme pénétrant (Réf. 7.C (b))'),
  ('MG-ANES-000055-R48', 'Les experts suggèrent de réaliser une antibioprophylaxie en cas de traumatisme pénétrant du thorax. Par exemple, l''association amoxicilline + acide clavulanique et en cas d''allergie à la pénicilline, l''association clindamycine + aminoside, pendant 24 à 48 h, en fonction de la nature et de l''importance de la plaie.', '2+', 'Q7 — Traumatisme pénétrant (Réf. 7.D)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/traumatisme-thoracique-prise-en-charge-des-48-premieres-heures/'
on conflict (recommendation_code) do nothing;
