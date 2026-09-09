-- Migration : Gestion des agents antiplaquettaires (AAP) en cas de procédure invasive
-- non programmée ou d'hémorragie (GIHP/GFHT, en collaboration avec la SFAR, 2018/2019)
-- Source : rfe-sfar-website/build/content_aap_urgence.json (21 recommandations atomiques
-- identifiées à la lecture, sur 4 tableaux de propositions).
--
-- Méthodologie source : PAS de GRADE. Propositions rédigées par groupes de travail
-- GIHP/GFHT puis validées par un vote Delphi (n=38) : accord retenu si >=50% d'accord et
-- <20% d'opposition, « accord fort » si >=70% d'accord. Le contenu construit (et audité)
-- indique que TOUTES les propositions retenues dans le document ont recueilli un accord
-- fort (aucune "accord faible" dans le texte source) : la colonne grade est donc
-- constante ('AE', le libellé du chip source), pas une valeur par défaut devinée.
-- evidence_level laissé null : ce document n'emploie aucun système de niveau de preuve
-- distinct du grade (pas de GRADE, pas de NP1-4 appliqué aux propositions elles-mêmes).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Date de publication ambiguë dans la source : "disponible en ligne le 23/11/2018"
--    mais citation imprimée "Anesth Reanim. 2019;5:218-237". publication_date ci-dessous
--    utilise la date de mise en ligne (la plus précise/datée des deux) ; à confirmer si la
--    date de parution imprimée (2019, mois non précisé) est préférée pour ce champ.
-- 2. Deux tableaux de la section "Algorithme hémorragie & traçabilité" (Figures 1 et 2 et
--    leur tableau récapitulatif "moyens de neutralisation proposés (Figure 2)") reformulent
--    en schéma/tableau des propositions DÉJÀ chipées AE dans les tableaux précédents
--    (neutralisation par AAP, prise en charge de l'hémorragie) : ce ne sont pas de
--    nouvelles propositions distinctes dans la source (pas de nouveau chip AE sur ce
--    contenu), donc PAS migrées comme recommandations séparées ici pour éviter de
--    fragmenter artificiellement une même recommandation en plusieurs lignes.
-- 3. GIHP et GFHT (auteurs principaux de ce document, SFAR seulement co-signataire —
--    cf. "en collaboration avec la SFAR" dans le texte source) ne figurent pas dans le
--    seed Annexe B (societies) : seule SFAR est liée en document_societies ci-dessous,
--    comme pour les migrations précédentes dans ce même cas de figure (ecbu,
--    transport_intrahospitalier).
-- 4. build/library_final.json donne un direct_pdf_url différent de celui cité dans le
--    panneau "Sources et traçabilité" du contenu déjà construit et audité
--    (content_aap_urgence.json) : la bibliothèque indique
--    'https://sfar.org/wp-content/uploads/2019/10/rfe-gestion-des-agents-antiplaquettaires.pdf',
--    le contenu vérifié cite 'https://sfar.org/download/gestion-perioperatoire-des-patients-sous-aap-en-urgence/?wpdmdl=34414'.
--    Comme pour le même cas déjà rencontré sur ecbu (migration 0002), c'est cette seconde
--    URL (celle réellement lue/auditée au moment de la construction de la fiche) qui est
--    utilisée ci-dessous comme source_url — à confirmer/mettre à jour si la bibliothèque a
--    raison et que le fichier a été remplacé depuis.

insert into public.documents (title, doc_type, original_language, publication_date, doi, source_url, pdf_url, grading_system, freshness_status)
values (
  'Gestion des agents antiplaquettaires en cas de procédure invasive non programmée ou d''hémorragie',
  'propositions', 'fr', '2018-11-23',
  '10.1016/j.anrea.2018.10.003',
  'https://sfar.org/download/gestion-perioperatoire-des-patients-sous-aap-en-urgence/?wpdmdl=34414',
  'https://sfar.org/download/gestion-perioperatoire-des-patients-sous-aap-en-urgence/?wpdmdl=34414',
  'GIHP/GFHT — vote Delphi (n=38) ; accord retenu si >=50% d''accord et <20% d''opposition, « accord fort » si >=70% d''accord (pas de GRADE)',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/download/gestion-perioperatoire-des-patients-sous-aap-en-urgence/?wpdmdl=34414'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/download/gestion-perioperatoire-des-patients-sous-aap-en-urgence/?wpdmdl=34414'
  and s.slug in ('anesthesie_reanimation', 'medecine_d_urgence', 'medecine_intensive_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.source_section,
  'https://sfar.org/download/gestion-perioperatoire-des-patients-sous-aap-en-urgence/?wpdmdl=34414',
  'draft'
from public.documents d, (values
  ('MG-ANES-000004-R01', 'Utiliser un test fonctionnel plaquettaire en préopératoire pour identifier des dysfonctions plaquettaires (liées ou non aux AAP) quand elles sont suspectées sur une base clinique, dans les équipes ayant ce type de test à disposition et habituées à son utilisation.', 'AE', 'Préopératoire', 'Tests fonctionnels plaquettaires — place dans l''urgence'),
  ('MG-ANES-000004-R02', 'En cas de chirurgie de pontage coronaire semi-urgente, utiliser un test fonctionnel plaquettaire pour raccourcir les durées d''arrêt des AAP (inhibiteurs de P2Y12 en particulier), dans les équipes formées à son utilisation.', 'AE', 'Pontage coronaire semi-urgent', 'Tests fonctionnels plaquettaires — place dans l''urgence'),
  ('MG-ANES-000004-R03', 'Si un test fonctionnel plaquettaire est utilisé en dehors du laboratoire (POCT), le faire en coordination avec l''équipe d''hémostase et le dispositif local de médecine de laboratoire, en accord avec la réglementation en vigueur, et en l''insérant dans une organisation codifiée avec les algorithmes transfusionnels retenus localement.', 'AE', 'Utilisation en POCT', 'Tests fonctionnels plaquettaires — place dans l''urgence'),
  ('MG-ANES-000004-R04', 'Tenir compte du type d''AAP et de l''heure de la dernière prise (présence ou non d''un ou plusieurs métabolites actifs en circulation).', 'AE', 'Principe (neutralisation des AAP)', 'Moyens de neutralisation des AAP — propositions'),
  ('MG-ANES-000004-R05', 'Aspirine : transfuser des plaquettes, dose de 0,5 à 0,7×10^11 pour 10 kg de poids. Avec les formes galéniques autres qu''à libération prolongée, le produit actif disparaît de la circulation en moins de 2 heures.', 'AE', 'Aspirine (neutralisation)', 'Moyens de neutralisation des AAP — propositions'),
  ('MG-ANES-000004-R06', 'Clopidogrel / prasugrel : transfuser des plaquettes, à une dose plus élevée que pour l''aspirine (au moins le double, plus importante pour le prasugrel que pour le clopidogrel). Efficacité réduite si la dernière prise date de moins de 6 heures.', 'AE', 'Clopidogrel / prasugrel (neutralisation)', 'Moyens de neutralisation des AAP — propositions'),
  ('MG-ANES-000004-R07', 'Ne pas administrer de rFVIIa pour neutraliser le clopidogrel ou le prasugrel.', 'AE', 'Clopidogrel / prasugrel (neutralisation)', 'Moyens de neutralisation des AAP — propositions'),
  ('MG-ANES-000004-R08', 'Ticagrelor : si dernière prise < 24h, aucune prise en charge spécifique ne peut être recommandée (transfusion plaquettaire aux doses habituelles inefficace ; efficacité de fortes doses ou du rFVIIa non évaluée). Si dernière prise > 24h, la transfusion plaquettaire pourrait permettre une neutralisation partielle.', 'AE', 'Ticagrelor (neutralisation)', 'Moyens de neutralisation des AAP — propositions'),
  ('MG-ANES-000004-R09', 'Administrer de l''acide tranexamique pour son efficacité à réduire le saignement, que le patient soit ou non traité par AAP.', 'AE', 'Acide tranexamique (neutralisation)', 'Moyens de neutralisation des AAP — propositions'),
  ('MG-ANES-000004-R10', 'Ne pas utiliser la desmopressine pour neutraliser les AAP.', 'AE', 'Desmopressine (neutralisation)', 'Moyens de neutralisation des AAP — propositions'),
  ('MG-ANES-000004-R11', 'Distinguer procédures de sauvetage (minutes ; ex. rupture d''anévrisme aortique, syndrome de loge), procédures urgentes (heures ; ex. péritonite par perforation, ischémie aiguë de membre), procédures semi-urgentes (jours ; ex. décollement de rétine, syndrome occlusif sur tumeur).', 'AE', 'Classification NCEPOD', 'Procédure invasive non programmée — propositions'),
  ('MG-ANES-000004-R12', 'Quand possible (procédures semi-urgentes essentiellement), prendre en compte les durées optimales d''interruption : dernière prise d''aspirine à J-3, de clopidogrel et ticagrelor à J-5, de prasugrel à J-7 (+2 jours pour la neurochirurgie intracrânienne, quel que soit l''AAP).', 'AE', 'Durées d''interruption', 'Procédure invasive non programmée — propositions'),
  ('MG-ANES-000004-R13', 'Aspirine ou clopidogrel en monothérapie, procédure non réalisable dans le délai optimal : débuter la procédure non neurochirurgicale sans neutralisation ; neutraliser avant un acte de neurochirurgie intracrânienne urgent ou de sauvetage.', 'AE', 'Monothérapie, non réalisable en délai', 'Procédure invasive non programmée — propositions'),
  ('MG-ANES-000004-R14', 'Bithérapie antiplaquettaire, procédure non réalisable dans le délai optimal : débuter la procédure non neurochirurgicale sans neutralisation — si le saignement per-procédural n''est pas contrôlable par l''opérateur senior et est attribué à la bithérapie, la neutraliser alors. Réaliser les procédures semi-urgentes plus de 24h après la dernière prise de prasugrel ou de ticagrelor. Neutraliser avant un acte de neurochirurgie intracrânienne urgent ou de sauvetage.', 'AE', 'Bithérapie, non réalisable en délai', 'Procédure invasive non programmée — propositions'),
  ('MG-ANES-000004-R15', 'Chez les patients sous inhibiteur de P2Y12 (mono- ou bithérapie), ne pas réaliser de geste d''anesthésie locorégionale rachidienne (rachianesthésie, péridurale).', 'AE', 'ALR rachidienne', 'Procédure invasive non programmée — propositions'),
  ('MG-ANES-000004-R16', 'Le traitement étiologique (gestes hémostatiques mécaniques) s''impose dans tous les cas d''hémorragie associée aux AAP, associé au traitement symptomatique (remplissage, vasopresseurs, transfusion de CGR, lutte contre l''hypothermie, acide tranexamique précoce).', 'AE', 'Principe général (hémorragie)', 'Hémorragie associée aux AAP — propositions'),
  ('MG-ANES-000004-R17', 'Hémorragie intracrânienne avec neurochirurgie urgente indiquée : neutraliser le traitement antiplaquettaire en préopératoire.', 'AE', 'Hémorragie intracrânienne, neurochirurgie urgente indiquée', 'Hémorragie associée aux AAP — propositions'),
  ('MG-ANES-000004-R18', 'Hémorragie intracrânienne sans neurochirurgie urgente indiquée : ne pas transfuser de plaquettes si le patient est traité par aspirine et présente un score de Glasgow > 8 à l''arrivée. Dans les autres cas, aucune proposition ne peut être faite ni en faveur ni en défaveur de la neutralisation. Interrompre les AAP dans tous les cas.', 'AE', 'Hémorragie intracrânienne, pas de neurochirurgie urgente', 'Hémorragie associée aux AAP — propositions'),
  ('MG-ANES-000004-R19', 'Choc hémorragique chez un patient sous bithérapie antiplaquettaire : neutraliser le traitement antiplaquettaire.', 'AE', 'Choc hémorragique, bithérapie', 'Hémorragie associée aux AAP — propositions'),
  ('MG-ANES-000004-R20', 'Autres hémorragies graves : neutraliser le traitement antiplaquettaire en cas de persistance de l''hémorragie après échec des traitements étiologiques et symptomatiques.', 'AE', 'Autres hémorragies graves', 'Hémorragie associée aux AAP — propositions'),
  ('MG-ANES-000004-R21', 'Hémorragies non graves : traitement symptomatique, sans neutraliser le traitement antiplaquettaire (réévaluer systématiquement l''indication du traitement en cours).', 'AE', 'Hémorragies non graves', 'Hémorragie associée aux AAP — propositions')
) as v(code, statement, grade, condition_topic, source_section)
where d.source_url = 'https://sfar.org/download/gestion-perioperatoire-des-patients-sous-aap-en-urgence/?wpdmdl=34414'
on conflict (recommendation_code) do nothing;
