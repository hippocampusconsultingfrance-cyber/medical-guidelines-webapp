-- Migration : Prise en charge anesthésique péri-procédurale d'une
-- revascularisation cérébrale par thrombectomie mécanique (TM) — RPP, SFAR
-- en association avec l'ANARLF, avec la participation de la SFNR, la SFNV
-- et le GFHT. Comité de 15 experts, texte validé par le Comité des
-- Référentiels Cliniques SFAR (16/05/2022), le CA SFAR (29/06/2022), le
-- bureau ANARLF (29/06/2022), le CS/CA SFNV (07/10/2022) et le CS SFNR
-- (16/08/2022). Processus mené indépendamment de tout financement
-- industriel.
-- Source : rfe-sfar-website/build/content_thrombectomie.json (4 champs —
-- modalités per-interventionnelles R1.1.1-R1.2, gestion des ACSOS
-- R2.1.1-R2.5, antiagrégants/anticoagulants R3.1-R3.4.2, post-
-- interventionnel/orientation R4.1.1-R4.3 — chaque énoncé numéroté est déjà
-- atomique, un seul sujet).
--
-- 2 questions N'ONT DONNÉ LIEU À AUCUNE RECOMMANDATION (littérature
-- insuffisante, disclosure explicite de la source elle-même reproduite
-- telle quelle) et ne sont donc PAS migrées en recommandation : (1)
-- héparinisation systémique per-procédure chez le patient SANS thrombolyse
-- intraveineuse préalable, (2) stratégie d'extubation précoce guidée par
-- des échelles (score VISAGE, etc.) après TM sous AG. Même traitement que
-- les questions sans recommandation formulée des autres fiches déjà
-- migrées (ex. R7 de `echo_acces_vasculaires`/0078).
--
-- MÉTHODOLOGIE — format RPP (pas RFE, choix motivé par la source
-- elle-même : trop peu d'études de puissance suffisante sur le critère de
-- jugement majeur, le pronostic neurologique à 3 mois/score de Rankin) ;
-- analyse de la littérature guidée par GRADE® (niveau de preuve par
-- référence) mais SANS distinction GRADE 1+/1-/2+/2- individuelle sur les
-- recommandations elles-mêmes. Les 18 préconisations portent toutes la même
-- mention imprimée par la source : "Avis d'experts (Accord fort)" —
-- `grade` = 'AE' sur les 18 lignes, `evidence_level` NULL (le niveau de
-- preuve par référence bibliographique n'est pas attribué individuellement
-- par préconisation dans le contenu construit).
--
-- ⚠️ DISCLOSURE — TITRES DE CHAMP DIVERGENTS DANS LA SOURCE ELLE-MÊME
-- (reproduite du contenu construit) : le Champ 3 est intitulé "Gestion des
-- anticoagulants et antiagrégants plaquettaires" en en-tête de section mais
-- "Gestion des antiagrégants plaquettaires et des anticoagulants" dans le
-- résumé des champs ; le Champ 4 est intitulé "Prise en charge post-
-- interventionnelle immédiate et orientation" en en-tête mais "Gestion
-- post-interventionnelle et orientation" dans le résumé — divergences non
-- résolues par la source elle-même, titres d'en-tête retenus dans
-- `source_section` ci-dessous.
--
-- ANARLF, SFNR, SFNV, GFHT (co-auteurs/participants), ne figurent PAS dans
-- le seed Annexe B (`public.societies`) : seule SFAR (dans le seed) est
-- liée en `document_societies` ci-dessous.
--
-- SOURCE_URL / PDF_URL : `library_final.json` (recherche "thrombectomie" —
-- exactement 1 correspondance) donne `href` et `direct_pdf_url`, identique
-- à l'"URL source" du contenu construit. `exact_date` = "2022-09" (mois
-- connu, jour inconnu) — `publication_date` = 2022-09-01, jour non
-- disclosed par l'index ni par le contenu construit (qui donne seulement
-- "Version : 2022").
--
-- `specialties` : `anesthesie_reanimation` (procédure anesthésique) et
-- `neurologie` si présente au seed (AVC ischémique, cf. `avc_precoce`/0069)
-- — vérifié : seul `anesthesie_reanimation` retenu, la neurologie n'étant
-- pas le sujet propre du document (sujet = prise en charge anesthésique
-- péri-procédurale, pas le traitement neurologique de l'AVC lui-même).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge anesthésique péri-procédurale d''une revascularisation cérébrale par thrombectomie',
  'RPP', 'fr', '2022-09-01',
  'https://sfar.org/prise-en-charge-anesthesique-peri-procedurale-dune-revascularisation-cerebrale-par-thrombectomie/',
  'https://sfar.org/download/prise-en-charge-anesthesique-peri-procedurale-dune-revascularisation-cerebrale-par-thrombectomie/?wpdmdl=37892',
  'Format RPP (pas RFE, littérature insuffisamment puissante pour RFE selon la source) ; analyse guidée par GRADE® mais sans distinction 1+/1-/2+/2- individuelle. 18 préconisations, toutes "Avis d''experts (Accord fort)" après 2 tours de cotation Delphi GRADE Grid. 2 questions n''ont donné lieu à aucune recommandation (littérature insuffisante) — non migrées, disclosure intégrale en base (voir commentaire de migration).',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-anesthesique-peri-procedurale-dune-revascularisation-cerebrale-par-thrombectomie/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-anesthesique-peri-procedurale-dune-revascularisation-cerebrale-par-thrombectomie/'
  and s.slug in ('anesthesie_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.source_section,
  'https://sfar.org/prise-en-charge-anesthesique-peri-procedurale-dune-revascularisation-cerebrale-par-thrombectomie/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000082-R01', 'Les experts suggèrent de privilégier l''AG avec intubation orotrachéale, réalisée par une équipe anesthésique, plutôt que l''anesthésie locale seule, lorsqu''au moins une des situations suivantes est présente : atteinte de la circulation postérieure ; neuronavigation radiologique prévue délicate ; NIHSS ≥ 15 ; altération de la vigilance ; défaillance respiratoire ; agitation du patient ; vomissements.', 'AE', 'Choix AG vs anesthésie locale — situations nécessitant l''AG', 'Champ 1 — Modalités de prise en charge per-interventionnelle, R1.1.1'),
  ('MG-ANES-000082-R02', 'À l''exception des situations nécessitant une intubation (cf. R1.1.1), les experts suggèrent de ne pas privilégier l''AG par rapport à une anesthésie locale sous surveillance par une équipe d''anesthésie.', 'AE', 'Choix AG vs anesthésie locale — cas général', 'Champ 1 — Modalités de prise en charge per-interventionnelle, R1.1.2'),
  ('MG-ANES-000082-R03', 'À l''exception des situations nécessitant une intubation (cf. R1.1.1), les experts suggèrent de ne pas privilégier l''AG par rapport à une sédation procédurale (SP), l''une et l''autre réalisées par une équipe anesthésique.', 'AE', 'Choix AG vs sédation procédurale', 'Champ 1 — Modalités de prise en charge per-interventionnelle, R1.2'),
  ('MG-ANES-000082-R04', 'En cas de recanalisation TICI <2b, les experts suggèrent de maintenir une PA systolique post-procédure entre 130 et 180 mmHg.', 'AE', 'Cible tensionnelle post-recanalisation — TICI <2b', 'Champ 2 — Gestion des ACSOS, R2.1.1'),
  ('MG-ANES-000082-R05', 'En cas de recanalisation TICI ≥2b, les experts suggèrent de maintenir une PA systolique post-procédure entre 130 et 160 mmHg.', 'AE', 'Cible tensionnelle post-recanalisation — TICI ≥2b', 'Champ 2 — Gestion des ACSOS, R2.1.2'),
  ('MG-ANES-000082-R06', 'Les experts suggèrent de maintenir la SpO2 du patient ≥ 95% en per- et post-procédure.', 'AE', 'Cible de SpO2 péri-procédurale', 'Champ 2 — Gestion des ACSOS, R2.2'),
  ('MG-ANES-000082-R07', 'Lors des procédures sous AG, les experts suggèrent de surveiller l''etCO2 et de le maintenir entre 35 et 40 mmHg.', 'AE', 'Cible d''etCO2 sous AG', 'Champ 2 — Gestion des ACSOS, R2.3'),
  ('MG-ANES-000082-R08', 'Lors des procédures sous sédation, les experts suggèrent de monitorer en continu l''etCO2 afin de surveiller la persistance de la ventilation spontanée.', 'AE', 'Monitorage de l''etCO2 sous sédation', 'Champ 2 — Gestion des ACSOS, R2.4'),
  ('MG-ANES-000082-R09', 'Les experts suggèrent de monitorer et traiter les épisodes d''hyperglycémie, tout en évitant les hypoglycémies induites par ce contrôle.', 'AE', 'Contrôle glycémique péri-procédural', 'Champ 2 — Gestion des ACSOS, R2.5'),
  ('MG-ANES-000082-R10', 'Chez les patients ayant bénéficié préalablement d''une thrombolyse intraveineuse, les experts suggèrent de ne pas procéder à une héparinisation systémique en per-procédure.', 'AE', 'Héparinisation systémique après thrombolyse IV préalable', 'Champ 3 — Gestion des anticoagulants et antiagrégants plaquettaires, R3.1'),
  ('MG-ANES-000082-R11', 'En l''absence de thrombolyse intraveineuse préalable, les experts suggèrent de ne pas administrer systématiquement à tous les patients une antiagrégation plaquettaire par anti-GPIIb/IIIa ou inhibiteur direct de la thrombine ; ce traitement peut être proposé en cas d''emboles distaux pendant la procédure ou d''occlusion persistante en fin de procédure.', 'AE', 'Antiagrégation systématique par anti-GPIIb/IIIa ou inhibiteur direct de la thrombine', 'Champ 3 — Gestion des anticoagulants et antiagrégants plaquettaires, R3.2'),
  ('MG-ANES-000082-R12', 'Les experts suggèrent de ne pas administrer d''aspirine en per-procédure, que les patients aient bénéficié ou non d''une thrombolyse intraveineuse préalable, afin de ne pas augmenter le risque d''hémorragie intra-parenchymateuse symptomatique.', 'AE', 'Aspirine en per-procédure', 'Champ 3 — Gestion des anticoagulants et antiagrégants plaquettaires, R3.3'),
  ('MG-ANES-000082-R13', 'Les experts suggèrent d''utiliser une antiagrégation plaquettaire (simple ou double) lors de la pose d''un stent pour éviter sa thrombose.', 'AE', 'Antiagrégation lors de la pose d''un stent', 'Champ 3 — Gestion des anticoagulants et antiagrégants plaquettaires, R3.4.1'),
  ('MG-ANES-000082-R14', 'Les experts suggèrent de n''initier cette antiagrégation qu''après avoir éliminé une hémorragie cérébrale par imagerie de contrôle au cours des premières 24 heures suivant le geste.', 'AE', 'Antiagrégation post-stent — délai après imagerie de contrôle', 'Champ 3 — Gestion des anticoagulants et antiagrégants plaquettaires, R3.4.2'),
  ('MG-ANES-000082-R15', 'Les experts suggèrent d''arrêter les médicaments d''anesthésie dès la fin de la procédure de TM en l''absence de défaillance ventilatoire ou de complications faisant craindre une HTIC ou un état de mal épileptique.', 'AE', 'Arrêt des médicaments d''anesthésie en fin de procédure', 'Champ 4 — Prise en charge post-interventionnelle immédiate et orientation, R4.1.1'),
  ('MG-ANES-000082-R16', 'Les experts suggèrent d''extuber le patient immédiatement après la procédure si les prérequis habituels sont présents et l''état de vigilance satisfaisant (composante visuelle du score de Glasgow ≥ 3 ; la réponse aux ordres n''est pas nécessaire). Déglutition et toux à évaluer spécifiquement pour les occlusions de la circulation postérieure.', 'AE', 'Extubation immédiate post-procédure', 'Champ 4 — Prise en charge post-interventionnelle immédiate et orientation, R4.1.2'),
  ('MG-ANES-000082-R17', 'Les experts suggèrent que le patient soit admis en unité de soins critiques, en priorité en USINV, avec surveillance clinique (glycémie, température) et monitorage (PA, SpO2, ECG), au minimum jusqu''à l''imagerie cérébrale de contrôle à H24.', 'AE', 'Orientation post-procédure — admission en soins critiques', 'Champ 4 — Prise en charge post-interventionnelle immédiate et orientation, R4.2'),
  ('MG-ANES-000082-R18', 'Les experts suggèrent de ne pas ré-adresser le patient immédiatement après la procédure vers le centre adresseur en cas d''instabilité hémodynamique, de déficit neurologique sévère (NIHSS ≥ 15), ou de résultat incomplet au contrôle de la procédure (TICI <2b).', 'AE', 'Ré-adressage précoce vers le centre adresseur — contre-indications', 'Champ 4 — Prise en charge post-interventionnelle immédiate et orientation, R4.3')
) as v(code, statement, grade, condition_topic, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-anesthesique-peri-procedurale-dune-revascularisation-cerebrale-par-thrombectomie/'
on conflict (recommendation_code) do nothing;
