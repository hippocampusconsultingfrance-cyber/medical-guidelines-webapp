-- Migration : Recommandations concernant les relations entre
-- anesthésistes-réanimateurs et chirurgiens, autres spécialistes ou
-- professionnels de santé — Conseil national de l'Ordre des médecins
-- (CNOM), en collaboration avec la SFAR et de nombreuses sociétés
-- savantes/syndicats. Texte original mai 1994 (Pr Bernard Glorion),
-- édition actualisée décembre 2001 (Pr Bernard Hoerni).
-- Source : rfe-sfar-website/build/content_relations_anesth_chir.json.
--
-- ⚠️ DISCLOSURE MAJEURE — DOCUMENT DÉONTOLOGIQUE ET JURIDIQUE, PAS UN
-- RÉFÉRENTIEL DE RECOMMANDATIONS CLINIQUES GRADÉES : la source le dit
-- elle-même explicitement — articles du code de déontologie médicale,
-- décrets, articles du code de la santé publique, recommandations ANAES,
-- "aucun système de cotation scientifique (pas de GRADE, pas de niveau de
-- preuve)". Même situation que `sauv`/0084 (également sans grade) :
-- chaque règle d'organisation/obligation légale ou déontologique
-- identifiable dans le texte est migrée comme une ligne `recommendations`
-- avec `grade` NULL — ce n'est pas une fabrication d'atomicité, chaque
-- ligne correspond à une règle ou un regroupement de règles explicitement
-- délimité par la structure numérotée de la source (sections 1.1-1.2,
-- 2.1-2.2, 3.1-3.2, 4.1-4.9, 5, 6). Quand plusieurs puces non numérotées
-- individuellement forment un seul développement cohérent sous un même
-- point de la source (ex. la liste des 6 responsabilités exclusives du
-- médecin anesthésiste en section 6), elles sont regroupées en une seule
-- ligne plutôt que sur-atomisées — même principe que `sauv`/0084 pour ses
-- propres listes à puces non numérotées.
--
-- ⚠️ DISCLOSURE — INCOHÉRENCE INTERNE À LA SOURCE (reproduite du contenu
-- construit lui-même) : le même texte législatif du 4 juillet 2001 est
-- cité sous deux numéros différents à deux endroits — "loi n° 2001-586"
-- en section 1.1 (clause de conscience pour la stérilisation
-- contraceptive) et "loi n° 2001-588" en section 1.2 (consentement d'une
-- mineure à l'IVG) — non tranché ici, les deux numéros sont reproduits
-- tels quels dans les statements concernés.
--
-- `doc_type` = 'Autre' (`exact_type` de `library_final.json` — ni RFE, ni
-- RPP, ni Préconisation : un texte déontologique/organisationnel de
-- l'Ordre des médecins).
--
-- SOCIÉTÉS : le CNOM (organisme porteur) n'est pas un acronyme de société
-- savante médicale au sens du seed Annexe B et n'y figure pas ; les
-- "nombreuses sociétés savantes et syndicats" cités en collaboration
-- (cardiologie, endoscopie digestive, chirurgie digestive, gynécologie-
-- obstétrique, radiologie, Ordre des sages-femmes, syndicats
-- d'anesthésistes) ne sont identifiées par la source que génériquement,
-- sans acronyme exploitable, à l'exception de la SFAR — vérifiée présente
-- dans le seed Annexe B (liste complète des 18 sociétés) — seule liée en
-- `document_societies` ci-dessous.
--
-- SOURCE_URL / PDF_URL : `library_final.json` (recherche "relations...
-- anesthésistes-réanimateurs et chirurgiens" — exactement 1
-- correspondance) donne `href` et `direct_pdf_url` identiques, et
-- `exact_date` = "2001-12" (mois connu, jour inconnu) — `publication_date`
-- = 2001-12-01, cohérent avec "édition actualisée décembre 2001" du
-- contenu construit.
--
-- `specialties` : `anesthesie_reanimation` (sujet central), `sage_femme_
-- maieuticienne` (section 5, entièrement consacrée aux relations avec les
-- sages-femmes) et `infirmierere_anesthesiste_iade` (section 6,
-- entièrement consacrée aux IADE) — les deux dernières spécialités
-- vérifiées présentes dans la liste complète des specialties du seed
-- Annexe A.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Recommandations concernant les relations entre anesthésistes-réanimateurs et chirurgiens, autres spécialistes ou professionnels de santé',
  'Autre', 'fr', '2001-12-01',
  'https://sfar.org/wp-content/uploads/2014/04/196-reco-anesth-chir-autres-2001.pdf',
  'https://sfar.org/wp-content/uploads/2014/04/196-reco-anesth-chir-autres-2001.pdf',
  'Texte déontologique et juridique (CNOM) — articles du code de déontologie médicale, décrets, code de la santé publique, recommandations ANAES. Aucun système de cotation scientifique (pas de GRADE, pas de niveau de preuve) — chaque recommandation est une règle de bonne pratique organisationnelle ou une obligation légale/déontologique. `grade` NULL sur toutes les lignes migrées, disclosure intégrale de ce choix en commentaire de migration (même traitement que `sauv`/0084).',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/wp-content/uploads/2014/04/196-reco-anesth-chir-autres-2001.pdf'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/wp-content/uploads/2014/04/196-reco-anesth-chir-autres-2001.pdf'
  and s.slug in ('anesthesie_reanimation', 'sage_femme_maieuticienne', 'infirmierere_anesthesiste_iade')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.source_section,
  'https://sfar.org/wp-content/uploads/2014/04/196-reco-anesth-chir-autres-2001.pdf',
  'draft'
from public.documents d, (values
  ('MG-ANES-000097-R01', 'Les règles du code de déontologie s''appliquent entre confrères de disciplines différentes mais complémentaires (pas d''injure, d''insulte, de calomnie, ni de pression matérielle ou morale). Nul médecin ne doit entreprendre d''actes pour lesquels il n''est pas compétent (art. 32 et 70) : recours à un tiers compétent chaque fois que nécessaire.', null, 'Principes déontologiques généraux entre confrères', 'Section 1.1 — Généralités'),
  ('MG-ANES-000097-R02', 'Chirurgien et anesthésiste-réanimateur forment une équipe de spécialités complémentaires ; la réunion de plusieurs compétences implique une décision collective, la responsabilité restant individuelle (art. 64). L''article 64 permet à chaque médecin de refuser librement sa collaboration ou de la retirer, à condition de ne pas nuire au patient et d''en avertir ses confrères — un refus de collaboration suppose une information préalable argumentée sur des éléments objectifs.', null, 'Décision collective, responsabilité individuelle et refus de collaboration', 'Section 1.1 — Généralités'),
  ('MG-ANES-000097-R03', 'L''échange d''informations réciproques doit être le plus large possible (dialogue et écrit) : le chirurgien informe l''anesthésiste des constatations de son examen, des propositions thérapeutiques et de l''importance de l''intervention ; l''anesthésiste informe l''opérateur de toute contre-indication anesthésique ou difficulté suspectée.', null, 'Échange réciproque d''informations chirurgien-anesthésiste', 'Section 1.1 — Généralités'),
  ('MG-ANES-000097-R04', 'L''opérateur doit tenir compte de l''avis de l''anesthésiste et ne peut lui imposer d''agir contre sa conscience (clause de conscience pour l''IVG, art. 18 ; loi n° 2001-586 du 4 juillet 2001 relative à l''IVG et à la contraception, un médecin n''est jamais tenu de pratiquer une stérilisation à visée contraceptive mais doit en informer l''intéressée dès la première consultation). En cas de désaccord, une conciliation doit être recherchée (confrères, hiérarchie médicale, CME, instances ordinales) — le patient ne doit jamais être témoin ou otage du différend.', null, 'Clause de conscience et conciliation en cas de désaccord', 'Section 1.1 — Généralités'),
  ('MG-ANES-000097-R05', 'Principes d''information fixés par le code de déontologie : information loyale, claire et appropriée (art. 35) ; consentement recherché dans tous les cas, respect du refus après information des conséquences, information des proches si le patient ne peut exprimer sa volonté sauf urgence (art. 36) ; obligations envers un mineur ou un majeur protégé définies à l''art. 42. L''ANAES recommande que chaque médecin informe des éléments relevant de sa discipline, sans supposer que d''autres l''ont déjà fait.', null, 'Obligation d''information — principes déontologiques', 'Section 1.2 — L''obligation d''information'),
  ('MG-ANES-000097-R06', 'Contenu de l''information selon l''ANAES : état du patient et évolution prévisible ; description des examens/soins/interventions envisagés et de leurs alternatives ; objectif, utilité, bénéfices escomptés ; conséquences et inconvénients ; complications et risques (y compris exceptionnels) ; précautions recommandées.', null, 'Contenu de l''information selon l''ANAES', 'Section 1.2 — L''obligation d''information'),
  ('MG-ANES-000097-R07', 'Le chirurgien (ou tout opérateur) informe sur la maladie, l''évolution sans traitement, le motif et les modalités de l''intervention, ses avantages/conséquences/inconvénients/risques et alternatives ; l''anesthésiste-réanimateur informe sur la technique anesthésique envisagée, ses avantages/inconvénients/risques/alternatives, et sur le terrain du patient — chevauchement inévitable entre les deux informations, à gérer avec tact.', null, 'Répartition de l''information entre chirurgien et anesthésiste', 'Section 1.2 — L''obligation d''information'),
  ('MG-ANES-000097-R08', 'Le dossier médical doit conserver une trace écrite de l''information donnée, et permettre à tout médecin devant apporter ses soins au patient de comprendre la nature de l''intervention chirurgicale, de la technique anesthésique et de l''éventuelle réanimation envisagées ; si le médecin informant n''est pas celui qui interviendra, il en informe le patient et transmet les renseignements nécessaires.', null, 'Traçabilité écrite de l''information dans le dossier médical', 'Section 1.2 — L''obligation d''information'),
  ('MG-ANES-000097-R09', 'Une mineure peut consentir seule à une IVG et aux actes liés (loi n° 2001-588 du 4 juillet 2001) — l''anesthésiste doit s''assurer que ce consentement a bien été obtenu.', null, 'Consentement d''une mineure à l''IVG', 'Section 1.2 — L''obligation d''information'),
  ('MG-ANES-000097-R10', 'L''accréditation des établissements de soins (décret n° 97-311) engage à la validation de procédures écrites ; il est recommandé que anesthésistes-réanimateurs, chirurgiens et autres professionnels rédigent et cosignent des chartes de fonctionnement, prenant en compte les recommandations de bonne pratique des sociétés savantes validées par l''ANAES.', null, 'Démarches qualité et chartes de fonctionnement cosignées', 'Section 2.1 — Démarches qualité'),
  ('MG-ANES-000097-R11', 'Une charte de fonctionnement des équipes anesthésiques et chirurgicales est nécessaire, portant sur 5 points : la consultation d''anesthésie, le programme opératoire, le réveil anesthésique, les soins intensifs/réanimation chirurgicale, et l''hospitalisation. Pour chaque point, la répartition des tâches et responsabilités doit être explicite.', null, 'Contenu de la charte de fonctionnement (5 points)', 'Section 2.2 — Charte de fonctionnement'),
  ('MG-ANES-000097-R12', 'En établissement public, l''activité s''exerce dans le cadre d''un service ; les anesthésistes relèvent de l''autorité du chef de service d''anesthésie-réanimation mais participent aux activités du service de chirurgie où ils travaillent. Le médecin anesthésiste est responsable du fonctionnement de la SSPI. Le rattachement des secteurs de soins intensifs/réanimation chirurgicale dépend de leur fonctionnement réel, avec reconnaissance de la responsabilité thérapeutique et de l''autorité médicale des anesthésistes qui y travaillent si rattaché à un service de chirurgie.', null, 'Organisation en établissement public', 'Section 3.1 — Établissement public'),
  ('MG-ANES-000097-R13', 'En établissement privé, les relations sont globalement similaires au public, avec des conflits plus spécifiques liés aux intérêts individuels (fixation des honoraires, critères de gestion) — le statut de propriétaire/actionnaire majoritaire ne peut justifier la privation de moyens indispensables aux patients ni des contraintes abusives (art. 71). Prévention : respect de la déontologie, contrats soumis à l''Ordre, conférences médicales.', null, 'Organisation en établissement privé', 'Section 3.2 — Établissement privé'),
  ('MG-ANES-000097-R14', 'La consultation pré-anesthésique est obligatoire (décret n° 94-1050) pour toute anesthésie générale ou locorégionale, réalisée à distance de l''intervention pour un consentement libre et éclairé, intégrée dans une procédure commune d''évaluation préopératoire. Il est préférable que l''anesthésiste consultant réalise lui-même la visite pré-anesthésique et l''anesthésie ; sinon, le patient en est informé et le médecin qui opère prend connaissance du dossier avant l''intervention.', null, 'Consultation pré-anesthésique', 'Section 4.1 — Consultation pré-anesthésique'),
  ('MG-ANES-000097-R15', 'Pour une consultation de cardiologie (ou autre spécialiste) à l''occasion d''une anesthésie, 4 principes s''appliquent : (1) demande précise, réponse en rapport ; (2) anesthésiste et opérateur se tiennent mutuellement informés des demandes et résultats ; (3) la décision finale de l''indication et des modalités d''anesthésie relève de l''anesthésiste-réanimateur ; (4) en cas de désaccord, chacun assume ses responsabilités dans son domaine, mais une concertation réelle doit précéder la décision.', null, 'Consultation de spécialiste à l''occasion d''une anesthésie', 'Section 4.2 — Consultation de cardiologie ou autre spécialiste'),
  ('MG-ANES-000097-R16', 'Le programme opératoire est établi par les médecins opérateurs, les anesthésistes concernés et le responsable du secteur opératoire (décret n° 94-1050, art. D.712-42), tenant compte des disponibilités de chacun — on ne peut imposer plusieurs anesthésies simultanées à un anesthésiste. Recommandé par écrit, signé au plus tard la veille. Gestion des urgences définie à l''avance.', null, 'Établissement du programme opératoire', 'Section 4.3 — Le programme opératoire'),
  ('MG-ANES-000097-R17', 'Le fonctionnement de la SSPI est prioritaire (moyens définis au décret n° 94-1050, art. D.712-47/49). Suivi sous surveillance conjointe chirurgien/anesthésiste ; l''anesthésiste précise par écrit nature et rythme des soins, le chirurgien consigne par écrit ses prescriptions post-opératoires immédiates. La sortie de SSPI n''est décidée que par l''anesthésiste-réanimateur ; l''orientation ultérieure est une décision commune.', null, 'Surveillance post-interventionnelle et sortie de SSPI', 'Section 4.4 — La surveillance post-interventionnelle'),
  ('MG-ANES-000097-R18', 'Le patient orienté en soins intensifs/réanimation chirurgicale est sous la responsabilité médicale de l''anesthésiste-réanimateur ; certaines décisions restent au chirurgien (mobilisation, ablation sondes/drains). Techniques de réanimation et prescriptions médicamenteuses reviennent à l''anesthésiste-réanimateur sur protocole écrit précisant les domaines de chacun ; prescriptions écrites, datées et signées. Entrée/sortie de ces secteurs sur accord conjoint.', null, 'Responsabilités en soins intensifs et réanimation chirurgicale', 'Section 4.5 — Les soins intensifs et la réanimation chirurgicale'),
  ('MG-ANES-000097-R19', 'Le patient retourné en hospitalisation est sous la responsabilité de l''opérateur, qui répond des suites opératoires ; le règlement interne précise les procédures en cas d''événement inopiné/complication tardive. En urgence, la déontologie exclut qu''un médecin se retranche derrière sa spécialité pour s''exonérer de sa mission d''assistance en cas de complication postopératoire.', null, 'Responsabilité pendant l''hospitalisation', 'Section 4.6 — L''hospitalisation'),
  ('MG-ANES-000097-R20', 'Une anesthésie générale ou locorégionale ne peut être mise en œuvre sans anesthésiste-réanimateur (art. D.712-40 et suivants ; art. 40 interdisant un risque injustifié). L''anesthésie locale/sédation par un chirurgien ou autre opérateur requiert formation/expérience particulières et, le cas échéant, le concours de l''anesthésiste, avec un règlement écrit fixant les modalités. En conclusion : soit un acte nécessite un anesthésiste, soit non — les situations intermédiaires sont à éviter.', null, 'Anesthésie/sédation par des spécialistes non anesthésistes-réanimateurs', 'Section 4.7 — Anesthésie/sédation par des spécialistes non anesthésistes-réanimateurs'),
  ('MG-ANES-000097-R21', 'La chirurgie ambulatoire est programmée et organisée (décret n° 92-1102) : amplitude d''ouverture ≤ 12h ; présence minimale permanente d''un médecin qualifié plus, en sus, présence permanente d''un anesthésiste-réanimateur dans la structure. Le patient reçoit à sa sortie un bulletin signé mentionnant les intervenants et les consignes post-opératoires/anesthésiques. Règlement intérieur commun fait respecter par un médecin coordonnateur.', null, 'Organisation de la chirurgie ambulatoire', 'Section 4.8 — La chirurgie ambulatoire'),
  ('MG-ANES-000097-R22', 'Pour les transfusions sanguines, la responsabilité incombe au chirurgien, à l''anesthésiste, ou aux deux selon la phase : en préopératoire, le chirurgien détient l''essentiel de l''information (risque hémorragique) à porter au dossier, l''anesthésiste évalue les besoins ; en peropératoire, information mutuelle, l''anesthésiste commande et réalise la transfusion ; en postopératoire, responsabilité selon l''organisation. Documents portant toujours le nom lisible du prescripteur ; motif tracé au dossier.', null, 'Responsabilités relatives aux transfusions sanguines', 'Section 4.9 — Les transfusions sanguines'),
  ('MG-ANES-000097-R23', 'Les sages-femmes doivent appeler le gynécologue-obstétricien de garde en cas d''accouchement dystocique ou de suites de couches pathologiques, et un médecin anesthésiste-réanimateur pour tout acte autorisé susceptible de nécessiter une anesthésie autre que locale. Pour les autres actes, la prescription d''intervention est faite par le gynécologue-obstétricien, le choix de la technique anesthésique revenant à l''anesthésiste.', null, 'Obligations générales des sages-femmes envers gynécologue-obstétricien et anesthésiste', 'Section 5 — Sages-femmes, gynécologues-obstétriciens et anesthésistes-réanimateurs'),
  ('MG-ANES-000097-R24', 'Pour l''analgésie périmédullaire lors d''un accouchement présumé normal, la sage-femme apprécie le moment et transmet à l''anesthésiste dès accord de principe de l''équipe obstétricale ; pour une cause médicale/obstétricale, la demande est faite par le gynécologue-obstétricien. La décision de réalisation et de technique appartient dans tous les cas au médecin anesthésiste-réanimateur.', null, 'Décision de réalisation de l''analgésie périmédullaire', 'Section 5 — Sages-femmes, gynécologues-obstétriciens et anesthésistes-réanimateurs'),
  ('MG-ANES-000097-R25', 'La sage-femme peut participer à l''entretien de l''analgésie locorégionale (hors période d''expulsion) si un anesthésiste est à tout moment disponible à proximité — réinjections par le dispositif posé par le médecin (première injection médicale obligatoire), selon prescriptions écrites et signées ou protocoles validés. Toute sage-femme qui s''estime ne pas être en mesure d''assurer une technique en sécurité peut légitimement refuser sa prise en charge.', null, 'Participation de la sage-femme à l''entretien de l''ALR', 'Section 5 — Sages-femmes, gynécologues-obstétriciens et anesthésistes-réanimateurs'),
  ('MG-ANES-000097-R26', 'L''anesthésie est un acte médical ne pouvant être pratiqué que par un médecin anesthésiste-réanimateur qualifié. L''IADE aide le médecin mais ne peut entreprendre seul une anesthésie, quel qu''en soit le type, en l''absence d''un médecin qualifié. Il est sous la responsabilité exclusive du médecin anesthésiste-réanimateur et/ou du chef de service — aucun autre spécialiste ne peut s''y substituer ou l''autoriser à exercer seul.', null, 'Statut de l''anesthésie comme acte médical et rôle de l''IADE', 'Section 6 — Les infirmier(e)s anesthésistes diplômé(e)s d''État (IADE)'),
  ('MG-ANES-000097-R27', 'Le médecin peut confier temporairement à l''IADE, sous sa propre responsabilité, la surveillance d''un patient anesthésié ne présentant pas de risque particulier, à condition d''être immédiatement joignable et disponible à proximité. L''IADE participe à toute ALR et pratique des réinjections dès lors que le dispositif a été posé par un médecin, sur prescription écrite.', null, 'Délégation temporaire de surveillance et participation de l''IADE à l''ALR', 'Section 6 — Les infirmier(e)s anesthésistes diplômé(e)s d''État (IADE)'),
  ('MG-ANES-000097-R28', 'L''anesthésiste doit pouvoir être assisté par un autre médecin et/ou un IADE si nécessaire (début/fin d''anesthésie, moments délicats, complications, actes à risque spécifique) — la présence d''un médecin anesthésiste auprès d''un IADE est toujours nécessaire. Le décret n° 94-1050 impose la présence permanente d''au moins un IDE formé (si possible IADE) en SSPI, sous la responsabilité médicale d''un médecin anesthésiste-réanimateur qui doit pouvoir intervenir sans délai.', null, 'Assistance de l''anesthésiste et présence IDE/IADE en SSPI', 'Section 6 — Les infirmier(e)s anesthésistes diplômé(e)s d''État (IADE)'),
  ('MG-ANES-000097-R29', 'Demeurent du ressort exclusif du médecin anesthésiste-réanimateur : la consultation pré-anesthésique ; la prescription de l''anesthésie (type, agents, modalités de surveillance) ; le geste technique d''ALR (bloc tronculaire/plexique, rachianesthésie, péridurale/caudale, anesthésie locale IV) ; la prescription de médicaments ou transfusions rendus nécessaires en cours d''anesthésie ; la mise en œuvre de techniques invasives (voies veineuses profondes, sondes de Swan-Ganz) ; la prescription des soins et examens post-opératoires ; la décision de sortie de la salle de surveillance post-interventionnelle.', null, 'Responsabilités exclusives du médecin anesthésiste-réanimateur', 'Section 6 — Les infirmier(e)s anesthésistes diplômé(e)s d''État (IADE)')
) as v(code, statement, grade, condition_topic, source_section)
where d.source_url = 'https://sfar.org/wp-content/uploads/2014/04/196-reco-anesth-chir-autres-2001.pdf'
on conflict (recommendation_code) do nothing;
