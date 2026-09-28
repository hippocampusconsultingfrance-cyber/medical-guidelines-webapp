-- Migration : Pratique des anesthésies locales et locorégionales par des
-- médecins non spécialisés en anesthésie-réanimation, dans le cadre des
-- urgences — Conférence d'experts, texte court, SFAR / Samu de France /
-- Société francophone de médecine d'urgence (SFMU), 2002. Publié Ann Fr
-- Anesth Réanim 23 (2004) 167-176, doi:10.1016/S0750-7658(03)00527-6.
-- Source : rfe-sfar-website/build/content_alr_non_specialiste.json.
--
-- CHAMP D'APPLICATION (disclosed, pas modélisé en `recommendations` mais
-- nécessaire pour interpréter correctement chaque ligne ci-dessous) :
-- s'adresse aux médecins DE L'URGENCE non spécialisés en
-- anesthésie-réanimation (structures d'accueil des urgences, urgences
-- préhospitalières), lorsque le même praticien réalise à la fois l'AL/ALR
-- et l'acte d'urgence. Exclut explicitement : l'anesthésie « chirurgicale »
-- (bloc opératoire, compétence exclusive des anesthésistes-réanimateurs),
-- les ALR périmédullaires (rachianesthésie, péridurale), les blocs du
-- tronc/intercostaux/paravertébraux/interpleuraux et le multibloc laryngé.
--
-- VÉRIFICATION PDF SOURCE (téléchargé et lu directement pour cette
-- migration, pas seulement via le contenu déjà construit) : page 1
-- confirme l'en-tête "CONFÉRENCE D'EXPERTS, TEXTE COURT, 2002" et le bas de
-- page "Annales Françaises d'Anesthésie et de Réanimation 23 (2004)
-- 167-176 © 2003 ... doi:10.1016/S0750-7658(03)00527-6" ; aucun tampon
-- d'obsolescence/retrait n'a été trouvé en page 1 ni en dernière page (10
-- pages au total), cohérent avec `library_final.json` (`"status": "en
-- vigueur"`). DOI relevé directement dans le PDF, jamais deviné.
--
-- ⚠️ DISCLOSURE — TROIS ANNÉES DIFFÉRENTES DANS LA SOURCE ELLE-MÊME, NON
-- RÉSOLUES ARBITRAIREMENT : le texte porte "2002" (année de la conférence
-- d'experts, en-tête page 1 ET `content_alr_non_specialiste.json` lui-même
-- dans son panneau "Sources et traçabilité"), "© 2003" (copyright Elsevier,
-- pied de page 1) et "23 (2004) 167-176" (volume/année de la revue Ann Fr
-- Anesth Réanim où le texte a été publié) ; `library_final.json` ne retient
-- que "2004" (son seul champ `year`/`exact_date`, sans jour ni mois). Les
-- trois faits sont ici constatés, aucun n'est présenté comme le seul
-- correct. `publication_date` ci-dessous utilise '2004-01-01' par
-- convention (année seule de `library_final.json`, PAS une date exacte
-- devinée — même traitement que `allergie_prevention`/0006).
--
-- ⚠️ DISCLOSURE — AUTO-QUALIFICATION DE LA SOURCE VS. `exact_type` DE
-- L'INDEX : le texte se qualifie lui-même de "CONFÉRENCE D'EXPERTS" (une
-- terminologie SFAR antérieure et distincte de la "RFE" au sens strict
-- ultérieur), alors que `library_final.json` classe ce document
-- `exact_type: "RFE"`. `doc_type` ci-dessous reprend "RFE" (valeur de
-- l'index canonique, comme demandé par la procédure de migration), ce
-- désaccord de vocabulaire étant disclosed ici plutôt que silencieusement
-- résolu dans un sens ou dans l'autre.
--
-- MÉTHODOLOGIE — PAS le système GRADE (pas de 1+/1-/2+/2-), ni un simple
-- accord fort/faible : grille EBM à deux échelons propre à ce texte
-- (Tableaux 1 et 2 de la source, reproduits dans le contenu construit) —
-- (1) "Niveau de preuve" I à V (I = études aléatoires, faible risque α/β,
-- puissance élevée ; II = risque α élevé ou faible puissance ; III = non
-- aléatoires, témoins contemporains ; IV = non aléatoires, témoins non
-- contemporains ; V = études de cas/avis d'experts), puis (2) "Grade" A à E
-- dérivé du niveau de preuve (A = ≥2 études de niveau I ; B = 1 étude de
-- niveau I ; C = étude(s) de niveau II ; D = étude(s) de niveau III ; E =
-- étude(s) de niveau IV ou V). Chaque grade A-E est repris tel quel, jamais
-- fusionné ni recalculé (aucune occurrence de grade composite formé de deux
-- crans GRADE 1/2 plus/moins collés entre eux dans ce texte — safety net
-- anti-fusion de grades exécuté sur ce fichier avant commit, 0 occurrence,
-- comme attendu vu que ce document n'utilise pas GRADE mais la grille
-- Niveau I-V / Grade A-E propre à ce texte).
--
-- COUVERTURE ET PÉRIMÈTRE DU MODÈLE `recommendations` (disclosure
-- exhaustive, rien n'est silencieusement omis) : le contenu construit
-- annonce lui-même sa couverture comme "l'intégralité des 34 énoncés
-- gradés individuellement (Questions 1-5) et des 5 tableaux du texte
-- source (niveaux de preuve, grades, toxicité neurologique, posologie des
-- AL, gestion des complications)". Les 34 lignes ci-dessous correspondent
-- EXACTEMENT à ces "34 énoncés gradés individuellement" (compte revérifié
-- ligne par ligne pendant cette migration, cf. rang R01-R34 sans trou —
-- aucune exclusion volontaire ne tombe DANS cette séquence, voir plus bas
-- pour ce qui est exclu AVANT elle). Sont volontairement exclus du modèle
-- `recommendations` (contenu intégralement conservé dans la fiche/site,
-- disclosure ici seulement sur la portée du modèle atomique en base) :
--   1. Les 5 tableaux eux-mêmes : Tableau 1 (niveaux de preuve I-V) et
--      Tableau 2 (grades A-E) sont la légende méthodologique, reprise dans
--      `grading_system` ci-dessous plutôt que comme des recommandations ;
--      Tableau 3 (signes cliniques/conduite à tenir de la toxicité
--      neurologique) et Tableau 5 (prévention/signes/traitement de 3
--      complications) sont des tableaux de référence clinique DESCRIPTIFS,
--      sans grade par ligne dans la source ; aucun des deux n'est un
--      énoncé "il faut faire X" gradé individuellement.
--   2. Tableau 4 (posologie maximum par agent/présentation, 9 lignes) :
--      CAS PARTICULIER — la source lui attache explicitement une note "*
--      Colonne « Posologie maximum » gradée D dans le texte source", donc
--      CE tableau porte bien un grade contrairement aux tableaux 3/5.
--      Néanmoins non converti en lignes `recommendations` : la note grade
--      la colonne entière du tableau (9 présentations pharmaceutiques
--      distinctes — lidocaïne à 3 concentrations, 4 présentations de
--      Xylocaïne®/Emla®, mépivacaïne, ropivacaïne), pas un énoncé unique.
--      La convertir en une seule ligne fusionnerait 9 posologies
--      distinctes sous un grade/statement unique (interdit, cf. règle
--      "jamais fusionner un grade ou un énoncé") ; la convertir en 9 lignes
--      inventerait une atomicité que le texte source ne délimite pas
--      lui-même par un énoncé narratif propre à chaque ligne (contrairement
--      aux 34 énoncés R01-R34, qui sont chacun une phrase déclarative
--      complète dans le texte). Choix : reproduire le tableau tel quel
--      dans la fiche/site (déjà fait), l'exclure du modèle atomique, et
--      disclosed ce choix ici explicitement plutôt que de deviner.
--   3. Prose procédurale/narrative non gradée individuellement par la
--      source : le panneau "Résumé" (cadre général, §1), le paragraphe
--      d'intro §2.2 "Aspects pratiques" (une phrase "il faut" mais SANS
--      tag de grade dans la source), le paragraphe d'intro §4.1
--      "Complications", la liste à puces §4.2 "Mesures de précaution" (17
--      puces), le paragraphe §4.3 "Monitorage", le paragraphe d'intro
--      "Milieu difficile" et le paragraphe d'intro "5.1", et l'intégralité
--      de la Question 5 "Formation nécessaire" (liste à puces + un
--      paragraphe de clôture). Aucune de ces phrases ne porte de tag de
--      grade individuel dans le texte source — les inclure comme lignes
--      `recommendations` avec `grade` NULL aurait, de fait, élargi le
--      périmètre du modèle atomique au-delà des "34 énoncés gradés
--      individuellement" que la source (et la fiche déjà construite et
--      auditée) délimitent elles-mêmes explicitement comme le périmètre
--      couvert. Texte intégral conservé dans `content_alr_non_specialiste.json`
--      / la fiche PDF / le site — rien n'est perdu, seulement non dupliqué
--      comme ligne `recommendations` individuelle.
--
-- NUMÉROTATION `recommendation_code` : R01-R34, dans l'ordre de lecture du
-- texte source (Questions 1 à 5). Le texte source n'a PAS de numérotation
-- Rx.y native (à la différence de `brule_grave`/0086) — chaque recomman-
-- dation y est identifiée par un renvoi de type "§2.1.3.2" ou "§3.2.2.1"
-- (colonne "Réf." des tableaux de recommandations), repris tel quel dans
-- `source_section` ci-dessous ; R01-R34 est donc une numérotation
-- éditoriale de cette migration (ordre de rencontre dans le texte), pas un
-- identifiant natif de la source. Aucun trou dans cette séquence : les
-- exclusions volontaires décrites ci-dessus (tableaux, prose non graduée)
-- sont toutes en dehors de la séquence des "34 énoncés gradés
-- individuellement" et ne créent donc pas de trou DANS R01-R34.
--
-- `population` : renseignée seulement quand l'énoncé restreint
-- explicitement (par son texte ou par la sous-section source qui le
-- regroupe) une classe d'âge — 'Adulte' (R16, seul énoncé disant
-- explicitement "chez l'adulte"), 'Enfant (< 3 mois)' (R04, Emla®),
-- 'Enfant' (R17 volume pédiatrique ; R32/R33, les 4 lignes de la
-- sous-section source "5.1 Particularités chez l'enfant" étant toutes
-- structurellement regroupées sous ce même intitulé — R31/R34 précisent
-- déjà l'âge dans leur propre texte, R32/R33 non, d'où la mention
-- générique 'Enfant' pour ces deux dernières plutôt qu'une tranche d'âge
-- non énoncée par la source), 'Enfant (< 1 an)' (R31), 'Enfant (> 4 ans)'
-- (R34). NULL partout ailleurs (énoncé non stratifié par âge dans la
-- source, ex. R11 "chez l'enfant comme chez l'adulte" — s'applique aux
-- deux indifféremment, donc NULL plutôt qu'un choix arbitraire, même
-- convention que `brule_grave`/0086).
--
-- SOURCE_URL / PDF_URL / DOC_TYPE : `library_final.json` (recherche sur le
-- titre exact "Pratique des anesthésies locales et locorégionales par des
-- médecins non spécialisés en anesthésie-réanimation, dans le cadre des
-- urgences" — recherche élargie aussi sur "non spécialisés"/"ALR"/
-- "locorégional" : 3 résultats au total, dont 2 clairement écartés car sur
-- un tout autre sujet — "Techniques analgésiques locorégionales et douleur
-- chronique" (2013) et "Échographie en anesthésie locorégionale" (2011) —
-- laissant EXACTEMENT 1 correspondance pour ce document précis) donne
-- `href` et `direct_pdf_url` ; `exact_date` = "2004" (année seule, voir
-- disclosure ci-dessus). `exact_type` = "RFE".
--
-- VÉRIFICATION ANTI-DOUBLON : `grep -ril` sur tout
-- `supabase/migrations/` pour "pratique-des-anesthesies-locales-et-
-- locoregionales", "non spécialisés en anesthésie", "medecins non
-- specialis" et "medecine d'urgence" — 0 migration existante ne couvre
-- déjà ce document précis sous une autre clé. `0080_migrate_alr_perinerveuse.sql`
-- existe dans ce dossier mais porte sur un document totalement différent
-- (`https://sfar.org/anesthesie-loco-regionale-perinerveuse/`, l'ALR
-- périnerveuse par les anesthésistes-réanimateurs eux-mêmes) — pas de
-- chevauchement de `source_url`, pas de doublon.
--
-- `document_societies` : SFAR + Société francophone de médecine d'urgence
-- (SFMU) — les deux sociétés co-signataires présentes dans le seed Annexe
-- B (`(s.acronym, s.country_or_region) in (('SFAR','France'),
-- ('SFMU','France'))`, vérifié contre la liste COMPLÈTE des 18 sociétés du
-- seed telle que reproduite intégralement dans `schema_v2.sql` section 15,
-- pas une commande grep tronquée). "Samu de France" (3e société
-- co-signataire nommée par le texte source lui-même, page 1 : "Société
-- française d'anesthésie et de réanimation, Samu de France, Société
-- francophone de médecine d'urgence") est ABSENTE du seed Annexe B —
-- vérifié explicitement contre la liste complète des 18 couples
-- (acronyme, pays/région) ci-dessus, aucune entrée "Samu de France" ni
-- variante ; elle n'est donc PAS liée en `document_societies` (fait
-- disclosed, pas une supposition).
--
-- `document_specialties` : `anesthesie_reanimation` (SFAR, techniques
-- d'AL/ALR) et `medecine_d_urgence` (public cible explicite du texte —
-- "médecins de l'urgence... structures d'accueil des urgences... urgences
-- préhospitalières" ; SFMU et Samu de France co-signataires), les deux
-- slugs vérifiés présents dans la liste COMPLÈTE des specialties du seed
-- (`schema_v2.sql` section 14, 84 slugs, lue intégralement — pas une
-- commande head/grep tronquée). `medecine_generale_medecine_de_famille`
-- (slug également présent dans le seed) a été explicitement envisagée
-- comme candidate puis ÉCARTÉE après lecture intégrale du texte source :
-- aucune occurrence de "médecine générale", "médecin traitant", "cabinet"
-- ou d'un contexte de soins ambulatoires/de ville dans les 10 pages du
-- PDF téléchargé et relu pour cette migration — le texte restreint
-- explicitement son champ aux "structures d'accueil des urgences" et aux
-- "urgences préhospitalières" (SAU, Smur/Samu), jamais à la médecine
-- générale de ville. Décision fondée sur cette lecture, pas une
-- supposition dans un sens ou dans l'autre.
--
-- STATUT DE FRAÎCHEUR : `library_final.json` indique `"status": "en
-- vigueur"` pour ce document (pas "abrogé") ; confirmé par la relecture
-- directe du PDF source pour cette migration (aucun tampon de retrait en
-- page 1 ni en dernière page, voir plus haut). `freshness_status` =
-- 'a_jour' ci-dessous, comme pour les migrations précédentes de ce corpus
-- (`brule_grave`/0086, `sauv`/0084) dans le même cas de figure.

insert into public.documents (title, doc_type, original_language, publication_date, doi, source_url, pdf_url, grading_system, freshness_status)
values (
  'Pratique des anesthésies locales et locorégionales par des médecins non spécialisés en anesthésie-réanimation, dans le cadre des urgences',
  'RFE', 'fr', '2004-01-01',
  '10.1016/S0750-7658(03)00527-6',
  'https://sfar.org/pratique-des-anesthesies-locales-et-locoregionales-par-des-medecins-non-specialises-en-anesthesie-reanimation/',
  'https://sfar.org/wp-content/uploads/2016/01/2_AFAR_Pratique-des-anesthesies-locales-et-locoregionales-par-des-medecins-non-specialises-en-anesthesie-reanimation-dans-le-cadre-des-urgences.pdf',
  'Conférence d''experts SFAR/Samu de France/SFMU (2002 ; publié Ann Fr Anesth Réanim 2004;23:167-176), grille EBM propre au texte (PAS GRADE) : Niveau de preuve I-V (Tableau 1) puis Grade A-E dérivé (Tableau 2 : A = ≥2 études niveau I, B = 1 étude niveau I, C = étude(s) niveau II, D = étude(s) niveau III, E = étude(s) niveau IV ou V). 34 énoncés gradés individuellement A-E (aucune fusion), plus 5 tableaux de référence (niveaux de preuve, grades, toxicité neurologique, posologie des AL, complications) et de la prose procédurale non graduée individuellement, tous deux exclus du modèle `recommendations` et disclosed en détail en commentaire de migration.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/pratique-des-anesthesies-locales-et-locoregionales-par-des-medecins-non-specialises-en-anesthesie-reanimation/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'), ('SFMU', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/pratique-des-anesthesies-locales-et-locoregionales-par-des-medecins-non-specialises-en-anesthesie-reanimation/'
  and s.slug in ('anesthesie_reanimation', 'medecine_d_urgence')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.population, v.source_section,
  'https://sfar.org/pratique-des-anesthesies-locales-et-locoregionales-par-des-medecins-non-specialises-en-anesthesie-reanimation/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000087-R01', 'Toxicité neurologique centrale (prodromes puis convulsions, coma avec dépression cardiorespiratoire au stade ultime — Tableau 3) : le traitement doit être rapide — arrêt de l''injection, oxygénation et contrôle des voies aériennes, voire administration parentérale d''anticonvulsivants.', 'D', 'Toxicité neurologique centrale — conduite à tenir', null, 'Question 1 — Toxicité des anesthésiques locaux, §2.1.3.2'),
  ('MG-ANES-000087-R02', 'En cas d''arrêt cardiaque toxique lié aux anesthésiques locaux, aucun médicament anti-arythmique habituellement préconisé dans l''arrêt cardiaque ne doit être utilisé.', 'D', 'Arrêt cardiaque toxique — antiarythmiques contre-indiqués', null, 'Question 1 — Toxicité des anesthésiques locaux, §2.1.3.2'),
  ('MG-ANES-000087-R03', 'La ropivacaïne (réputée moins cardiotoxique que la bupivacaïne à dose égale) est une alternative intéressante à la bupivacaïne, dans les rares cas où un agent de longue durée d''action est requis.', 'D', 'Choix de l''agent en cas de nécessité d''un anesthésique local de longue durée d''action', null, 'Question 1 — Toxicité des anesthésiques locaux, §2.1.3.2'),
  ('MG-ANES-000087-R04', 'L''utilisation de l''Emla® n''est pas contre-indiquée chez l''enfant de moins de trois mois.', 'B', 'Emla® chez le nourrisson', 'Enfant (< 3 mois)', 'Question 2 — 3.1 Anesthésie locale (AL), §3.1.2.2'),
  ('MG-ANES-000087-R05', 'Pour diminuer la douleur de l''injection : aiguilles de petit calibre, solutions réchauffées, injection intradermique régulière et lente dans les berges de la plaie et de proche en proche (technique également requise pour prévenir le risque septique en peau saine si la plaie est contaminée, et éviter l''injection intravasculaire).', 'B', 'Réduction de la douleur de l''infiltration', null, 'Question 2 — Anesthésie par infiltration, §3.1.3.2'),
  ('MG-ANES-000087-R06', 'Deux situations se prêtent, de manière schématique, à la mise en œuvre d''une ALR dans le cadre de ces recommandations : les traumatismes des membres et les traumatismes de la face.', 'A', 'Indications de l''ALR en urgence', null, 'Question 2 — 3.2 Blocs locorégionaux (ALR), §3.2'),
  ('MG-ANES-000087-R07', 'Le seul bloc qui, de manière consensuelle, semble adapté à l''urgence extrahospitalière est le bloc du nerf fémoral.', 'D', 'Bloc adapté à l''urgence extrahospitalière', null, 'Question 2 — 3.2 Blocs locorégionaux (ALR), §3.2'),
  ('MG-ANES-000087-R08', 'Il est indispensable, avant tout bloc, de consigner par écrit les données de l''examen neurologique (motricité, sensibilité) de la zone considérée.', 'E', 'Examen neurologique écrit préalable au bloc', null, 'Question 2 — 3.2.1 Contraintes et spécificités de l''urgence, §3.2.1'),
  ('MG-ANES-000087-R09', 'L''interrogatoire, lorsqu''il est possible, doit rechercher une anomalie constitutionnelle ou acquise de l''hémostase (un bilan biologique d''hémostase systématique n''est pas utile).', 'E', 'Recherche d''un trouble de l''hémostase à l''interrogatoire', null, 'Question 2 — 3.2.1 Contraintes et spécificités de l''urgence, §3.2.1'),
  ('MG-ANES-000087-R10', 'Avant la réalisation d''une ALR (bloc fémoral ou iliofascial), un niveau élevé de douleur, spontanée ou induite par une éventuelle mobilisation du malade, justifie une analgésie première par voie systémique.', 'E', 'Analgésie systémique préalable si douleur importante', null, 'Question 2 — 3.2.1 Contraintes et spécificités de l''urgence, §3.2.1'),
  ('MG-ANES-000087-R11', 'Le bloc du nerf fémoral pour fracture de la diaphyse fémorale est la technique d''ALR la plus répandue et la plus éprouvée en urgence, procurant de manière prévisible une analgésie d''excellente qualité, chez l''enfant comme chez l''adulte, pour l''urgence pré- et intrahospitalière.', 'A', 'Bloc fémoral pour fracture de diaphyse fémorale', null, 'Question 2 — 3.2.2 ALR et traumatismes des membres (bloc fémoral/iliofascial), §3.2.2.1'),
  ('MG-ANES-000087-R12', 'Indications : analgésie pour fracture de diaphyse fémorale ainsi que pour les plaies du genou — permettent, dans d''excellentes conditions d''analgésie, la mobilisation et le transport, la réalisation de clichés radiographiques, et la mise d''une attelle après pose éventuelle d''une broche de traction.', 'A', 'Indications du bloc fémoral/iliofascial', null, 'Question 2 — 3.2.2 ALR et traumatismes des membres (bloc fémoral/iliofascial), §3.2.2.1'),
  ('MG-ANES-000087-R13', 'Ces blocs sont partiellement efficaces pour la prise en charge analgésique des fractures des extrémités supérieure ou inférieure du fémur.', 'B', 'Efficacité partielle sur les fractures des extrémités du fémur', null, 'Question 2 — 3.2.2 ALR et traumatismes des membres (bloc fémoral/iliofascial), §3.2.2.1'),
  ('MG-ANES-000087-R14', 'Le bloc iliofascial doit être recommandé comme la technique de référence dans le cadre de l''urgence et permet de s''affranchir de l''utilisation d''un neurostimulateur.', 'A', 'Bloc iliofascial — technique de référence en urgence', null, 'Question 2 — 3.2.2 ALR et traumatismes des membres (bloc fémoral/iliofascial), §3.2.2.1'),
  ('MG-ANES-000087-R15', 'Avec cette technique, le taux de succès est de 88 % pour le nerf fémoral (crural), de 90 % pour le nerf cutané latéral (fémorocutané), et de 38 % pour le nerf obturateur — le bloc « 3 en 1 » échappe souvent au territoire obturateur (partie inféro-interne de la cuisse, adducteurs).', 'B', 'Taux de succès du bloc « 3 en 1 » par territoire nerveux', null, 'Question 2 — 3.2.2 ALR et traumatismes des membres (bloc fémoral/iliofascial), §3.2.2.1'),
  ('MG-ANES-000087-R16', 'Des volumes de 0,3 à 0,4 ml/kg de lidocaïne à 1 % sont suffisants chez l''adulte pour anesthésier les trois branches du plexus lombaire — le recours à des volumes plus importants n''améliore pas la qualité du bloc.', 'C', 'Volume de lidocaïne pour le bloc fémoral/iliofascial', 'Adulte', 'Question 2 — 3.2.2 ALR et traumatismes des membres (bloc fémoral/iliofascial), §3.2.2.1'),
  ('MG-ANES-000087-R17', 'Chez l''enfant, à défaut d''information précise sur le poids, le volume de lidocaïne 1 % peut être estimé à 1 ml/année d''âge (ropivacaïne non validée dans cette indication).', 'C', 'Volume de lidocaïne pour le bloc fémoral/iliofascial', 'Enfant', 'Question 2 — 3.2.2 ALR et traumatismes des membres (bloc fémoral/iliofascial), §3.2.2.1'),
  ('MG-ANES-000087-R18', 'Les blocs du pied sont proposés pour la prise en charge de plaies du pied.', 'D', 'Blocs du pied — indication', null, 'Question 2 — 3.2.2 ALR et traumatismes des membres (blocs du pied), §3.2.2.2'),
  ('MG-ANES-000087-R19', 'Ces blocs tronculaires périphériques permettent l''exploration et la suture de plaies n''intéressant qu''un ou deux territoires de la main.', 'D', 'Blocs tronculaires du membre supérieur — indication', null, 'Question 2 — 3.2.2 ALR et traumatismes des membres (membre supérieur / gaine des fléchisseurs), §3.2.2.3'),
  ('MG-ANES-000087-R20', 'Cette technique doit être adoptée en lieu et place de l''ancienne technique d''anesthésie des nerfs collatéraux des doigts — relativement douloureuse et incriminée dans la survenue d''ischémie par compression d''artérioles terminales.', 'B', 'Bloc de la gaine des fléchisseurs — technique de référence pour les doigts', null, 'Question 2 — 3.2.2 ALR et traumatismes des membres (membre supérieur / gaine des fléchisseurs), §3.2.2.3'),
  ('MG-ANES-000087-R21', 'Les blocs de la face devraient supplanter au service d''accueil des urgences les traditionnelles anesthésies locales de la face, où l''on finit par infiltrer des volumes excessifs d''anesthésique local pour suturer des plaies aux berges devenues succulentes.', 'E', 'Blocs de la face — à privilégier sur les AL traditionnelles', null, 'Question 2 — 3.2.3 ALR et traumatismes de la face, §3.2.3'),
  ('MG-ANES-000087-R22', 'L''anesthésie tronculaire de la face représente une alternative de choix à l''anesthésie générale, chez des malades à l''estomac plein, pour sutures de plaies multiples de la face.', 'D', 'Anesthésie tronculaire de la face — alternative à l''anesthésie générale', null, 'Question 2 — 3.2.3 ALR et traumatismes de la face, §3.2.3'),
  ('MG-ANES-000087-R23', 'L''échec partiel ou total d''un bloc ne constitue en aucun cas l''indication d''une sédation.', 'E', 'Échec du bloc — pas une indication de sédation', null, 'Question 2 — 3.3 Sédation associée, §3.3'),
  ('MG-ANES-000087-R24', 'Un score de Ramsay égal à 2 (patient coopérant, orienté et tranquille) est l''objectif souhaité — l''utilisation de médicaments facilement antagonisables est un gage de sécurité. Le midazolam (anxiolyse et amnésie), en titration par bolus de 0,5 à 1 mg, est la benzodiazépine la mieux adaptée à l''urgence (variabilité interindividuelle importante) ; les autres hypnotiques sont inadaptés à la sédation de complément d''une ALR en urgence.', 'E', 'Objectif de sédation (Ramsay 2) et choix du midazolam', null, 'Question 2 — 3.3 Sédation associée, §3.3'),
  ('MG-ANES-000087-R25', 'Le risque de dépression respiratoire est majoré par l''association à un morphinique.', 'B', 'Dépression respiratoire — risque majoré par l''association à un morphinique', null, 'Question 2 — 3.3 Sédation associée, §3.3'),
  ('MG-ANES-000087-R26', 'L''association d''un morphinique à la sédation d''une ALR doit donc être évitée.', 'E', 'Association d''un morphinique à la sédation d''une ALR — à éviter', null, 'Question 2 — 3.3 Sédation associée, §3.3'),
  ('MG-ANES-000087-R27', 'La morphine est l''opiacé de référence pour assurer une analgésie préalable ou de complément (bolus initial 0,05 mg/kg IV, puis bolus titrés de 2-3 mg toutes les 5 min) — les opiacés agonistes partiels ne sont pas recommandés.', 'D', 'Morphine — opiacé de référence pour l''analgésie de complément', null, 'Question 2 — 3.4 Analgésie associée, §3.4'),
  ('MG-ANES-000087-R28', 'Le mélange équimolaire oxygène-protoxyde d''azote (MEOPA), par son action sédative et analgésique, peut également être utilisé en complément d''une ALR.', 'E', 'MEOPA en complément d''une ALR', null, 'Question 2 — 3.4 Analgésie associée, §3.4'),
  ('MG-ANES-000087-R29', 'Toutes les techniques d''anesthésie locale préconisées dans ces recommandations peuvent être utilisées sous couvert des règles habituelles de sécurité — le bloc iliofascial doit être largement diffusé dans ce contexte, en particulier en cas d''afflux de victimes.', 'E', 'ALR en milieu difficile — techniques utilisables sous réserve des règles de sécurité', null, 'Question 4 — Milieu difficile, §Milieu diff.'),
  ('MG-ANES-000087-R30', 'Dans certains cas particuliers (patient incarcéré, victime en milieu périlleux…), une analgésie préalable par voie intraveineuse peut s''avérer nécessaire, mais ne contre-indique pas la réalisation ultérieure de l''ALR.', 'E', 'ALR en milieu difficile — analgésie IV préalable dans les cas particuliers', null, 'Question 4 — Milieu difficile, §Milieu diff.'),
  ('MG-ANES-000087-R31', 'Chez l''enfant de moins d''un an, la pharmacologie des anesthésiques locaux diffère fondamentalement de l''adulte (immaturité des métabolismes hépatique et rénal, diminution de certaines protéines plasmatiques), majorant le risque d''accumulation et de toxicité ; seule la lidocaïne est recommandée, à dose rapportée au poids corporel.', 'D', 'Anesthésiques locaux chez l''enfant de moins d''un an — seule la lidocaïne est recommandée', 'Enfant (< 1 an)', 'Question 4 — 5.1 Particularités chez l''enfant, §5.1'),
  ('MG-ANES-000087-R32', 'Comme chez l''adulte, le maintien du contact verbal est essentiel.', 'C', 'Maintien du contact verbal chez l''enfant', 'Enfant', 'Question 4 — 5.1 Particularités chez l''enfant, §5.1'),
  ('MG-ANES-000087-R33', 'Les solutions associant de la cocaïne aux anesthésiques locaux doivent être évitées en raison de leurs dangers.', 'D', 'Solutions à base de cocaïne — à éviter chez l''enfant', 'Enfant', 'Question 4 — 5.1 Particularités chez l''enfant, §5.1'),
  ('MG-ANES-000087-R34', 'Le mélange équimoléculaire oxygène-protoxyde d''azote est utilisable chez l''enfant de plus de quatre ans, en respectant ses contre-indications habituelles.', 'C', 'MEOPA chez l''enfant de plus de 4 ans', 'Enfant (> 4 ans)', 'Question 4 — 5.1 Particularités chez l''enfant, §5.1')
) as v(code, statement, grade, condition_topic, population, source_section)
where d.source_url = 'https://sfar.org/pratique-des-anesthesies-locales-et-locoregionales-par-des-medecins-non-specialises-en-anesthesie-reanimation/'
on conflict (recommendation_code) do nothing;
