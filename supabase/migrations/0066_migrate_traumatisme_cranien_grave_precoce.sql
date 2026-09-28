-- Migration : Prise en charge des traumatisés crâniens graves à la phase
-- précoce (24 premières heures) (SFAR/Anarlf/SFMU/SFNC/GFRUP/Adarpef, RFE
-- 2016, actualisation des recommandations françaises de 1998)
-- Source : rfe-sfar-website/build/content_traumatisme_cranien_grave_precoce.json
-- (32 recommandations numérotées R1.1-R11.3, réparties sur 11 champs
-- cliniques — exactement le total revendiqué par la source elle-même,
-- recompté un pour un contre sa propre synthèse page 441 : 10x Grade 1,
-- 18x Grade 2, 4x AE = 32/32).
--
-- ⚠️ PROVENANCE — DISCLOSURE OBLIGATOIRE : `content_traumatisme_cranien_
-- grave_precoce.json` fait partie des 9 fichiers "KNOWN DRIFT" documentés
-- dans `rfe-sfar-website/CLAUDE.md` — récupéré depuis l'Artifact publié en
-- ligne sans qu'aucun `fiche_*.py` ni fichier source n'ait jamais été
-- committé dans ce dépôt. Ce contenu N'A PAS suivi le pipeline de
-- triple-lecture + audit indépendant normalement exigé par ce projet et
-- N'A PAS été re-vérifié contre le PDF source par cette migration. Statut
-- `draft` comme toute migration, mais attention de relecture supérieure
-- recommandée (voir `examens_preinterventionnels`/0065, même disclosure).
--
-- MÉTHODOLOGIE GRADE — 1+/1- (preuve forte) ; 2+/2- (preuve modérée/
-- faible/très faible) ; AE (avis d'experts, littérature inexistante ou
-- trop pauvre, validé à plus de 70 % d'accord). `grade` reproduit le chip
-- source tel quel. `evidence_level` laissé NULL (même convention que
-- `sepsis`/0044, `sujet_age_esf`/0064, `examens_preinterventionnels`/0065 :
-- pas de niveau de preuve distinct du tag de force dans ce document).
-- Accord FORT obtenu pour 100 % des 32 recommandations (disclosure de la
-- source elle-même) — pas de mention "(accord faible)" à reproduire ici,
-- contrairement à `sujet_age_esf`/0064.
--
-- POPULATION : `population = 'Adulte'` sur R9.1 (marqueur explicite "chez
-- l'adulte" dans la source, en miroir du champ 11 dédié à l'enfant) ;
-- `population = 'Pédiatrie'` sur R11.1-R11.3 (champ 11, "Particularités du
-- traumatisme crânien grave chez l'enfant"). NULL ailleurs (24 lignes,
-- population adulte implicite par le champ de la RFE : "n'inclut pas les
-- TC légers/modérés").
--
-- PÉRIMÈTRE — volontairement pas migré (disclosure explicite de la fiche
-- source elle-même, reproduite ici) : le champ 12 "Contrôle ciblé de la
-- température" (R12.1-R12.6) est présenté PAR LA SOURCE ELLE-MÊME comme
-- une "retranscription partielle" de la RFE 2016 SFAR/SRLF dédiée — déjà
-- migrée séparément dans ce corpus (`controle_temperature`/0016, mêmes
-- énoncés/mêmes grades vérifiés ligne à ligne par la fiche construite).
-- Ne pas remigrer ces 6 recommandations ici pour éviter un doublon
-- (recommendation_code distinct mais contenu identique à 0016).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Anarlf, SFNC, GFRUP et Adarpef, co-auteurs de cette RFE au même titre
--    que la SFAR, ne figurent pas dans le seed Annexe B. La SFMU, elle,
--    figure dans le seed et EST liée ci-dessous avec la SFAR (contrairement
--    au traitement "SFAR seule" de plusieurs autres fiches de ce lot).
-- 2. `publication_date` = 2016-09-21 (date de validation par le CA de la
--    Sfar, citée explicitement par la source elle-même dans sa propre
--    section "Sources et traçabilité") plutôt que le 2016-09-24 de
--    `library_final.json` — écart mineur entre les deux dates, celle
--    imprimée par le document source retenue par préférence à celle de
--    l'index (disclosure, pas une divergence majeure comme
--    `urgences_transfusionnelles_obstetricales`/0061).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge des traumatisés crâniens graves à la phase précoce (24 premières heures)',
  'RFE', 'fr', '2016-09-21',
  'https://sfar.org/prise-en-charge-des-traumatises-craniens-graves-a-la-phase-precoce/',
  'https://sfar.org/wp-content/uploads/2017/09/RFE-ANREA-Prise-en-charge-des-traumatises-craniens-graves-a-la-phase-precoce.pdf',
  'GRADE — 1+/1- (preuve forte), 2+/2- (preuve modérée/faible/très faible), AE (avis d''experts). 32 recommandations, accord FORT pour 100% d''entre elles (10x Grade 1, 18x Grade 2, 4x AE, recompté par la fiche construite contre la synthèse de la source page 441). evidence_level non applicable (pas de niveau de preuve distinct du tag de force).',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-des-traumatises-craniens-graves-a-la-phase-precoce/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'), ('SFMU', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-des-traumatises-craniens-graves-a-la-phase-precoce/'
  and s.slug in ('anesthesie_reanimation', 'neurochirurgie', 'medecine_d_urgence')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.source_section,
  'https://sfar.org/prise-en-charge-des-traumatises-craniens-graves-a-la-phase-precoce/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000066-R01', 'Évaluer la gravité initiale à l''aide de l''échelle de Glasgow (en rapportant obligatoirement sa composante motrice, seule robuste sous sédation/intubation) ainsi que la taille et la réactivité pupillaire. Répéter l''examen clinique pendant la prise en charge initiale ; toute baisse >= 2 points du Glasgow doit faire réaliser en urgence une nouvelle TDM cérébrale.', '1+', null, '1 — Décrire et évaluer la gravité initiale (R1.1)'),
  ('MG-ANES-000066-R02', 'Rechercher et traiter les facteurs systémiques d''agression cérébrale secondaire : l''hypotension artérielle (PAS < 90 mmHg >= 5 min) double la mortalité ; l''hypoxémie (~20 % des patients) est associée à une surmortalité ; leur association atteint jusqu''à 75 % de mortalité.', '1+', null, '1 — Décrire et évaluer la gravité initiale (R1.2)'),
  ('MG-ANES-000066-R03', 'Évaluer la gravité initiale sur des critères cliniques ET radiologiques (TDM). Scanner cérébral et du rachis cervical systématique et sans délai chez tout TC grave (GCS <= 8) ou modéré (GCS 9-13).', '1+', null, '1 — Décrire et évaluer la gravité initiale (R1.3)'),
  ('MG-ANES-000066-R04', 'Évaluer probablement la gravité initiale à l''aide du Doppler transcrânien (DTC) — index de pulsatilité (IP), vélocité diastolique (Vd) : doit faire partie du bilan initial du polytraumatisé au même titre que l''échographie abdominale ; abandonner après 10 min si difficultés techniques.', '2+', null, '1 — Décrire et évaluer la gravité initiale (R1.4)'),
  ('MG-ANES-000066-R05', 'Ne pas doser probablement les biomarqueurs (S100β, NSE, UCH-L1, GFAP, protéine tau...) en routine clinique pour évaluer la gravité initiale : performance insuffisante, valeur ajoutée non démontrée.', '2-', null, '1 — Décrire et évaluer la gravité initiale (R1.5)'),
  ('MG-ANES-000066-R06', 'Le TC grave doit être pris en charge par une équipe médicale préhospitalière, régulé par le SAMU, et adressé dès que possible dans un centre spécialisé avec plateau technique neurochirurgical — améliore le pronostic même pour un patient ne nécessitant finalement pas de neurochirurgie (expertise et disponibilité de l''équipe).', '1+', null, '2 — Prise en charge préhospitalière (R2.1)'),
  ('MG-ANES-000066-R07', 'Maintenir probablement une PAS > 110 mmHg avant de disposer d''un monitorage cérébral : prévenir toute hypotension (pas d''hypnotique hypotenseur à l''induction, sédation continue, lutte contre l''hypovolémie) ; traitement rapide par amines vasopressives (phényléphrine et/ou noradrénaline) en cas d''hypotension.', '2+', null, '2 — Prise en charge préhospitalière (R2.2)'),
  ('MG-ANES-000066-R08', 'Contrôler la ventilation par intubation trachéale, ventilation mécanique et surveillance du CO2 expiré (EtCO2) dès la prise en charge préhospitalière — cible EtCO2 autour de 30-35 mmHg (l''hypocapnie est vasoconstrictrice et ischémiante).', '1+', null, '2 — Prise en charge préhospitalière (R2.3)'),
  ('MG-ANES-000066-R09', 'Réaliser sans délai une TDM cérébrale et du rachis cervical (sans injection) — coupes natives inframillimétriques, double fenêtrage (parenchyme + os). Examen de 1er choix, conditionne la prise en charge neurochirurgicale et le choix du monitorage.', '1+', null, '3 — Stratégie de l''imagerie médicale (R3.1)'),
  ('MG-ANES-000066-R10', 'Faire probablement précocement une angio-TDM des troncs supra-aortiques et vaisseaux intracrâniens chez les patients à risque de dissection traumatique (fracture du rachis cervical, déficit neurologique focal inexpliqué, syndrome de Claude Bernard Horner, fractures faciales Lefort II/III ou de la base du crâne, lésions des tissus mous du cou) — élargir probablement les indications chez les patients les plus graves (examen neurologique peu contributif).', '2+', null, '3 — Stratégie de l''imagerie médicale (R3.2)'),
  ('MG-ANES-000066-R11', 'Réaliser probablement un drainage ventriculaire externe pour contrôler l''HTIC après échec du traitement de 1ère ligne. Indications neurochirurgicales formelles précoces : évacuation d''un hématome extra-dural symptomatique (quelle que soit sa localisation), d''un hématome sous-dural aigu significatif (épaisseur > 5 mm, déviation ligne médiane > 5 mm), drainage d''une hydrocéphalie aiguë, parage/fermeture immédiate des embarrures ouvertes ; embarrure fermée compressive à opérer.', '2+', null, '4 — Indications neurochirurgicales, hors monitorage (R4.1)'),
  ('MG-ANES-000066-R12', 'Réaliser probablement une craniectomie décompressive pour contrôler la PIC en cas d''HTIC réfractaire, dans le cadre d''une discussion multidisciplinaire — décision au cas par cas (côté de la lésion indifférent). Étude RESCUE-ICP : mortalité réduite à 26,9 % (vs 48,9 % traitement médical) mais davantage de comas végétatifs/états pauci-relationnels (8,5 % vs 2,1 %) ; devenir favorable global inchangé.', '2+', null, '4 — Indications neurochirurgicales, hors monitorage (R4.2)'),
  ('MG-ANES-000066-R13', 'En dehors d''une HTIC ou d''un état de mal épileptique, appliquer aux TC graves les mêmes recommandations de maintien/arrêt de la sédation-analgésie que pour les autres patients de réanimation. Priorité au contrôle de l''hémodynamique systémique dans le choix des drogues (barbituriques, bolus de midazolam ou fortes doses de morphiniques en bolus peuvent provoquer une hypotension délétère).', 'AE', null, '5 — Sédation, analgésie (R5.1)'),
  ('MG-ANES-000066-R14', 'Avoir recours probablement à un monitorage systématique de la PIC après TC grave pour détecter une HTIC si : signe(s) d''HTIC sur l''imagerie, chirurgie périphérique urgente (hors urgence vitale), ou évaluation neurologique impossible. PIC 20-40 mmHg : risque de mortalité x3 ; PIC > 40 mmHg : x7.', '2+', null, '6 — Monitorage cérébral (R6.1)'),
  ('MG-ANES-000066-R15', 'Ne pas avoir recours probablement à un monitorage systématique de la PIC si le TC grave est isolé, la TDM initiale normale, sans critère de gravité clinique ni anomalie au DTC — bénéfice non démontré (étude BEST-TRIP), risques du monitorage (échec de pose ~10 %, infection 2,5-10 %, hémorragie 0-4 %). Si décidé malgré tout : préférer les fibres intra-parenchymateuses aux drains ventriculaires.', '2-', null, '6 — Monitorage cérébral (R6.2)'),
  ('MG-ANES-000066-R16', 'Avoir recours probablement à un monitorage systématique de la PIC après évacuation d''un hématome intracrânien post-traumatique si 1 seul critère suffit : Glasgow moteur préop <= 5, anisocorie/mydriase bilatérale préop, instabilité hémodynamique préop, signes de gravité à l''imagerie préop, œdème peropératoire, ou nouvelles lésions à l''imagerie postopératoire.', '2+', null, '6 — Monitorage cérébral (R6.3)'),
  ('MG-ANES-000066-R17', 'Recourir à un monitorage multimodal (DTC et/ou pression tissulaire cérébrale en oxygène PtiO2) pour optimiser le débit sanguin et l''oxygénation cérébrale. Seuil ischémique PtiO2 environ 15-20 mmHg (seuils modulés selon durée : < 5 mmHg/30 min, < 10 mmHg/1h45, < 15 mmHg/4h).', 'AE', null, '6 — Monitorage cérébral (R6.4)'),
  ('MG-ANES-000066-R18', 'Individualiser probablement les objectifs de PIC et de PPC correspondant à la meilleure autorégulation cérébrale, sur la base du monitorage multimodal (index de réactivité pressionnelle PRx). PIC entre 20 et 25 mmHg généralement retenue comme critère de gravité ; réflexion thérapeutique dès que la PIC dépasse 20 mmHg.', '2+', null, '7 — Prise en charge médicale de l''hypertension intracrânienne (R7.1)'),
  ('MG-ANES-000066-R19', 'En l''absence de monitorage multimodal, cibler probablement une PPC entre 60 et 70 mmHg (PPC = PAM − PIC, PAM mesurée au niveau du tragus). Une PPC > 70 mmHg systématique n''est pas recommandée (5x plus de détresses respiratoires, sans bénéfice neurologique) ; une PPC spontanément > 90 mmHg est associée à un moins bon devenir (majoration de l''œdème vasogénique).', '2+', null, '7 — Prise en charge médicale de l''hypertension intracrânienne (R7.2)'),
  ('MG-ANES-000066-R20', 'Administrer du mannitol 20 % ou du sérum salé hypertonique (250 mosmol) en 15-20 min en traitement d''urgence d''une HTIC sévère ou de signes d''engagement, après contrôle des agressions cérébrales secondaires — efficacité comparable à dose équi-osmotique ; effet maximal 10-15 min, durée théorique 2-4h.', '1+', null, '7 — Prise en charge médicale de l''hypertension intracrânienne (R7.3)'),
  ('MG-ANES-000066-R21', 'Ne pas faire probablement d''hypocapnie comme traitement d''une HTIC (hyperventilation prolongée non recommandée sans monitorage de l''oxygénation cérébrale pour vérifier l''absence d''hypoxie induite) — objectif de normocapnie recherché.', '2-', null, '7 — Prise en charge médicale de l''hypertension intracrânienne (R7.4)'),
  ('MG-ANES-000066-R22', 'Ne pas administrer probablement d''albumine à 4 % comme soluté de remplissage chez le TC grave — étude SAFE : surmortalité chez les TC graves réanimés à l''albumine (24,5 % vs 15,1 % au NaCl 0,9 %).', '2-', null, '7 — Prise en charge médicale de l''hypertension intracrânienne (R7.5)'),
  ('MG-ANES-000066-R23', 'En cas de polytraumatisme associé, privilégier la stabilisation hémodynamique et respiratoire avant la TDM corps entier injectée — incidence des lésions neurochirurgicales faible comparée aux lésions nécessitant une chirurgie d''hémostase (2,5 % vs 21 %). TDM cérébrale obligatoire dès stabilisation, intégrée à la TDM corps entier.', 'AE', null, '8 — Stratégie de prise en charge du polytraumatisé avec TC grave (R8.1)'),
  ('MG-ANES-000066-R24', 'En dehors de l''urgence vitale immédiate, ne pas réaliser de chirurgie à risque hémorragique dans un contexte d''HTIC (aggravation des lésions cérébrales, risque de SDRA/défaillance multiviscérale) — les gestes orthopédiques peu hémorragiques restent réalisables précocement (< 24h) si HTIC absente.', 'AE', null, '8 — Stratégie de prise en charge du polytraumatisé avec TC grave (R8.2)'),
  ('MG-ANES-000066-R25', 'Mettre en place ou poursuivre probablement le monitorage intracérébral pendant la procédure chirurgicale — une étude retrouve 82 % de mortalité en cas d''hypotension peropératoire (PAS < 90 mmHg) vs 32 % sans hypotension.', '2+', null, '8 — Stratégie de prise en charge du polytraumatisé avec TC grave (R8.3)'),
  ('MG-ANES-000066-R26', 'Chez l''adulte, ne pas administrer probablement de médicament antiépileptique en prévention primaire systématique de l''épilepsie post-traumatique (incidence clinique 1,5-5 % quel que soit le traitement, aucun bénéfice net démontré sur 11 essais). Peut être envisagée en cas de facteur de risque (contusion, hématome sous-dural aigu, embarrure, fracture du crâne, PC/amnésie > 24h, âge > 65 ans, craniectomie) : préférer alors le lévétiracétam à la phénytoïne (moins d''effets secondaires).', '2-', 'Adulte', '9 — Détection et traitement préventif des crises épileptiques (R9.1)'),
  ('MG-ANES-000066-R27', 'Ne pas induire probablement une hypernatrémie prolongée pour contrôler la PIC — pas d''étude randomisée validant cette stratégie chez l''adulte ; risque de rebond de PIC à la correction, d''aggravation des contusions si barrière hémato-encéphalique lésée, d''hyperchlorémie délétère.', '2-', null, '10 — Homéostasie biologique (R10.1)'),
  ('MG-ANES-000066-R28', 'Ne pas administrer de glucocorticoïdes à forte dose après un TC grave — l''étude CRASH (> 10 000 patients) a montré une surmortalité importante dans le groupe traité.', '1-', null, '10 — Homéostasie biologique (R10.2)'),
  ('MG-ANES-000066-R29', 'Surveiller étroitement la glycémie et réaliser un contrôle glycémique ciblant 8-11 mM/L (1,4-2 g/L) chez le TC grave, adulte et enfant — l''hyperglycémie > 2 g/L majore la mortalité et la morbidité neurologique ; le contrôle « strict » < 6-7 mM n''apporte aucun bénéfice et expose à l''hypoglycémie et à la crise énergétique cérébrale (microdialyse).', '1+', null, '10 — Homéostasie biologique (R10.3)'),
  ('MG-ANES-000066-R30', 'Mesurer probablement la PIC après TC grave de l''enfant, y compris chez le nourrisson et en cas de traumatisme crânien infligé — le TC infligé est une étiologie prépondérante chez le nourrisson (< 2 ans), à risque élevé d''HTIC et de pronostic péjoratif ; pas de surrisque de complications du monitorage démontré dans ce sous-groupe.', '2+', 'Pédiatrie', '11 — Particularités du traumatisme crânien grave chez l''enfant (R11.1)'),
  ('MG-ANES-000066-R31', 'Adapter probablement les seuils minimaux de PPC selon l''âge : 40 mmHg pour 0-5 ans, 50 mmHg pour 5-11 ans, 50-60 mmHg au-delà de 11 ans. Seuil de traitement de la PIC généralement 20 mmHg (envisager un seuil plus bas dans les tranches d''âge les plus jeunes selon des données encore limitées).', '2+', 'Pédiatrie', '11 — Particularités du traumatisme crânien grave chez l''enfant (R11.2)'),
  ('MG-ANES-000066-R32', 'Prendre en charge l''enfant TC grave dans un Trauma Center pédiatrique, ou à défaut un Trauma Center adulte avec compétences pédiatriques — réduit la morbi-mortalité (nombreuses études, niveaux de preuve faible à modéré mais effectifs cumulés importants).', '1+', 'Pédiatrie', '11 — Particularités du traumatisme crânien grave chez l''enfant (R11.3)')
) as v(code, statement, grade, population, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-des-traumatises-craniens-graves-a-la-phase-precoce/'
on conflict (recommendation_code) do nothing;
