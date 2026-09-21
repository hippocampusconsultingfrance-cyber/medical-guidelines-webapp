-- Migration : Curarisation et décurarisation en anesthésie — SFAR (actualisation de la CC
-- SFAR 1999), RFE validée par le CA de la SFAR le 21 juin 2018
-- Source : rfe-sfar-website/build/content_curares.json (33 recommandations atomiques,
-- tableaux "Réf. | Recommandation | Grade" répartis sur 8 questions, méthodologie GRADE).
--
-- Grade : reproduit tel quel depuis le chip source (1+/1-/2+/2-/AE). evidence_level laissé
-- NULL : pas de système de niveau de preuve distinct de la force GRADE dans ce document.
--
-- Le contenu construit annonce lui-même exactement "33 recommandations numérotées (R1.1 à
-- R8.14, dont 2 avis d'experts)" — décompte qui correspond exactement aux 33 lignes migrées
-- ci-dessous (vérifié par recherche exhaustive de tous les repères Rx.y du texte source :
-- aucun absent des tableaux), aucune divergence à disclose.
--
-- PÉRIMÈTRE — volontairement pas migrés (référence/algorithme, pas des recommandations
-- individuellement graduées) : le tableau "# | Question" (sommaire des 8 questions, pas des
-- recommandations), les 2 algorithmes de décurarisation (néostigmine/sugammadex, tableaux
-- "Évaluation initiale | Conduite à tenir | Résultat attendu" — reconstruits par le contenu
-- construit depuis des pages d'organigramme à faible contenu textuel extractible, vérifiées
-- visuellement), le tableau de posologie du sugammadex par degré de bloc, et le tableau de
-- posologie de succinylcholine par âge chez l'enfant (références pharmacologiques, comme les
-- tableaux de posologie déjà exclus dans d'autres migrations de ce corpus). Le contenu
-- construit signale par ailleurs "5 questions/sous-questions «pas de recommandation»"
-- reproduites intégralement dans la fiche mais non chiffrées — cohérent avec le principe de
-- ce projet de ne jamais migrer une absence de recommandation comme une ligne graduée.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Seule la SFAR est société organisatrice de cette RFE (comité de consensus de 16
--    experts propre à la SFAR, pas de co-signataires multiples comme pour d'autres
--    documents de ce corpus) — liée seule en document_societies, sans disclosure de société
--    manquante à faire ici.
-- 2. RFE de 2018 : le contenu construit invite lui-même à se référer "aux recommandations
--    ultérieures" en cas de doute — `freshness_status` reste 'a_jour' faute d'information
--    de retrait dans `library_final.json` (`status: "en vigueur"`), à vérifier par un
--    relecteur humain avant publication.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Curarisation et décurarisation en anesthésie',
  'RFE', 'fr', '2018-10-05',
  'https://sfar.org/wp-content/uploads/2018/10/2_RFE-CURARE-3.pdf',
  'https://sfar.org/wp-content/uploads/2018/10/2_RFE-CURARE-3.pdf',
  'GRADE® : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ probablement recommandé / 2- probablement non recommandé) ; avis d''experts (AE). Tags imprimés littéralement après chaque recommandation dans le texte source.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/wp-content/uploads/2018/10/2_RFE-CURARE-3.pdf'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/wp-content/uploads/2018/10/2_RFE-CURARE-3.pdf'
  and s.slug in ('anesthesie_reanimation', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/wp-content/uploads/2018/10/2_RFE-CURARE-3.pdf',
  'draft'
from public.documents d, (values
  ('MG-ANES-000018-R01', 'Il n''est probablement pas recommandé de tester la possibilité de ventiler au masque avant d''administrer un curare.', '2-', 'Question 1 — Ventilation au masque facial (R1.1)'),
  ('MG-ANES-000018-R02', 'Il est probablement recommandé d''administrer un curare pour faciliter la ventilation au masque facial.', '2+', 'Question 1 — Ventilation au masque facial (R1.2)'),
  ('MG-ANES-000018-R03', 'Il est recommandé d''administrer un curare pour faciliter l''intubation de la trachée.', '1+', 'Question 2 — Intubation de la trachée (R2.1)'),
  ('MG-ANES-000018-R04', 'Il est recommandé d''administrer un curare pour réduire les traumatismes du pharynx et/ou du larynx.', '1+', 'Question 2 — Intubation de la trachée (R2.2)'),
  ('MG-ANES-000018-R05', 'Il est probablement recommandé d''administrer un curare à délai d''action court pour l''induction en séquence rapide.', '2+', 'Question 2 — Intubation de la trachée (R2.3)'),
  ('MG-ANES-000018-R06', 'Il n''est probablement pas recommandé d''administrer systématiquement un curare pour faciliter la pose d''un dispositif supra-glottique.', '2-', 'Question 3 — Dispositifs supra-glottiques (R3.1)'),
  ('MG-ANES-000018-R07', 'Il est probablement recommandé d''administrer un curare en cas d''obstruction des voies aériennes liée à un dispositif supra-glottique.', '2+', 'Question 3 — Dispositifs supra-glottiques (R3.2)'),
  ('MG-ANES-000018-R08', 'Les experts suggèrent que si un monitorage instrumental de la curarisation est utilisé, le muscle sourcilier soit le site utilisé du fait de sa sensibilité aux curares et de sa cinétique de curarisation comparables à celles des muscles laryngés.', 'AE', 'Question 4 — Monitorage et contrôle des voies aériennes (R4.1)'),
  ('MG-ANES-000018-R09', 'Il est recommandé d''administrer un curare pour faciliter l''acte opératoire en chirurgie abdominale par laparotomie ou par laparoscopie.', '1+', 'Question 5 — Procédures interventionnelles (R5.1)'),
  ('MG-ANES-000018-R10', 'Il est probablement recommandé d''administrer un curare pour faciliter l''acte opératoire en chirurgie ORL sous laser.', '2+', 'Question 5 — Procédures interventionnelles (R5.2)'),
  ('MG-ANES-000018-R11', 'Il est recommandé de monitorer la curarisation en peropératoire.', '1+', 'Question 6 — Monitorage peropératoire (R6.1)'),
  ('MG-ANES-000018-R12', 'Il est probablement recommandé d''utiliser la stimulation par train de quatre du nerf ulnaire à l''adducteur du pouce pour monitorer la curarisation peropératoire.', '2+', 'Question 6 — Monitorage peropératoire (R6.2)'),
  ('MG-ANES-000018-R13', 'Il est probablement recommandé d''utiliser un monitorage quantitatif de la curarisation à l''adducteur du pouce pour le diagnostic de la curarisation résiduelle et d''obtenir un rapport T4/T1 ≥ 0,9 à l''adducteur du pouce pour éliminer formellement le diagnostic de curarisation résiduelle.', '2+', 'Question 7 — Curarisation résiduelle : diagnostic (R7.1)'),
  ('MG-ANES-000018-R14', 'Il est recommandé après l''administration d''un curare non dépolarisant d''attendre une décurarisation spontanée égale à quatre réponses musculaires à l''adducteur du pouce après une stimulation en train de quatre au nerf ulnaire avant d''injecter de la néostigmine.', '1+', 'Question 7 — Décurarisation par la néostigmine (R7.2)'),
  ('MG-ANES-000018-R15', 'Il est recommandé d''administrer la néostigmine sous couvert d''un monitorage de la curarisation à l''adducteur du pouce, d''administrer une dose comprise entre 40 et 50 µg/kg adaptée à la masse idéale, de ne pas augmenter la dose au-delà et de ne pas l''administrer en l''absence de bloc résiduel.', '1+', 'Question 7 — Décurarisation par la néostigmine (R7.3)'),
  ('MG-ANES-000018-R16', 'Il est probablement recommandé de réduire la dose de néostigmine de moitié en cas de bloc résiduel très faible.', '2+', 'Question 7 — Décurarisation par la néostigmine (R7.4)'),
  ('MG-ANES-000018-R17', 'Il est recommandé de poursuivre le monitorage quantitatif de la curarisation après l''administration de la néostigmine jusqu''à l''obtention d''un rapport du train de quatre supérieur ou égal à 0,9.', '1+', 'Question 7 — Décurarisation par la néostigmine (R7.5)'),
  ('MG-ANES-000018-R18', 'Il est recommandé d''ajuster la dose de sugammadex sur la masse idéale et en fonction du degré de bloc neuromusculaire induit par le rocuronium.', '1+', 'Question 7 — Décurarisation par le sugammadex (R7.6)'),
  ('MG-ANES-000018-R19', 'Il est probablement recommandé de poursuivre le monitorage quantitatif de la curarisation après l''administration de sugammadex afin de détecter une recurarisation.', '2+', 'Question 7 — Décurarisation par le sugammadex (R7.7)'),
  ('MG-ANES-000018-R20', 'Il est probablement recommandé d''administrer un curare à délai d''action court pour l''électro-convulsivothérapie.', '2+', 'Question 8 — Populations spéciales : ECT et obésité (R8.1)'),
  ('MG-ANES-000018-R21', 'Il est probablement recommandé chez l''obèse massif (IMC ≥ 40 kg/m²) d''administrer un curare à délai d''action court pour faciliter l''intubation de la trachée.', '2+', 'Question 8 — Populations spéciales : ECT et obésité (R8.2)'),
  ('MG-ANES-000018-R22', 'Il est probablement recommandé d''administrer la succinylcholine à la dose de 1 mg/kg adaptée sur la masse réelle de l''obèse.', '2+', 'Question 8 — Populations spéciales : ECT et obésité (R8.3)'),
  ('MG-ANES-000018-R23', 'Les experts suggèrent d''administrer le curare non dépolarisant à une dose calculée sur la masse maigre du patient obèse.', 'AE', 'Question 8 — Populations spéciales : ECT et obésité (R8.4)'),
  ('MG-ANES-000018-R24', 'Il est probablement recommandé d''utiliser le sugammadex adapté à la masse idéale en cas d''utilisation de rocuronium chez l''obèse massif (IMC ≥ 40 kg/m²) compte tenu de l''allongement du délai de décurarisation et du risque de recurarisation avec la néostigmine.', '2+', 'Question 8 — Populations spéciales : ECT et obésité (R8.5)'),
  ('MG-ANES-000018-R25', 'Hors situations relevant d''une indication à une induction à séquence rapide et à l''utilisation d''un curare dépolarisant, il est probablement recommandé d''utiliser un curare non dépolarisant pour améliorer les conditions d''intubation au cours de l''anesthésie générale par induction intraveineuse chez l''enfant.', '2+', 'Question 8 — Populations spéciales : l''enfant (R8.6)'),
  ('MG-ANES-000018-R26', 'Dans l''induction en séquence rapide classique, il est recommandé d''utiliser un curare d''action rapide chez l''enfant.', '1+', 'Question 8 — Populations spéciales : l''enfant (R8.7)'),
  ('MG-ANES-000018-R27', 'Dans l''induction en séquence rapide classique, il est probablement recommandé d''utiliser chez l''enfant la succinylcholine en première intention pour l''induction en séquence rapide. En cas de contre-indication à la succinylcholine, il est probablement recommandé d''utiliser du rocuronium.', '2+', 'Question 8 — Populations spéciales : l''enfant (R8.8)'),
  ('MG-ANES-000018-R28', 'Il n''est pas recommandé d''utiliser la succinylcholine en cas d''atteinte musculaire primitive (myopathies) ou de dérégulation haute du récepteur nicotinique à l''acétylcholine de la plaque motrice (déficit moteur chronique).', '1-', 'Question 8 — Populations spéciales : maladies neuromusculaires (R8.9)'),
  ('MG-ANES-000018-R29', 'Il est probablement recommandé de monitorer la curarisation en cas d''administration de curare chez un patient atteint d''une maladie neuromusculaire.', '2+', 'Question 8 — Populations spéciales : maladies neuromusculaires (R8.10)'),
  ('MG-ANES-000018-R30', 'Il est probablement recommandé d''administrer du sugammadex pour le traitement d''une curarisation résiduelle en cas d''administration de curare stéroïdien chez un patient atteint d''une maladie neuromusculaire.', '2+', 'Question 8 — Populations spéciales : maladies neuromusculaires (R8.11)'),
  ('MG-ANES-000018-R31', 'Il est probablement recommandé d''utiliser un curare de type benzylisoquinolines (atracurium/cis-atracurium) en cas d''insuffisance rénale ou hépatique.', '2+', 'Question 8 — Insuffisance rénale, hépatique, sujet âgé (R8.12)'),
  ('MG-ANES-000018-R32', 'Il est recommandé de ne pas modifier la dose initiale en cas d''insuffisance rénale ou hépatique quel que soit le type de curare.', '1+', 'Question 8 — Insuffisance rénale, hépatique, sujet âgé (R8.13)'),
  ('MG-ANES-000018-R33', 'En cas d''utilisation du sugammadex chez l''insuffisant rénal, il est probablement recommandé de l''utiliser aux doses habituelles.', '2+', 'Question 8 — Insuffisance rénale, hépatique, sujet âgé (R8.14)')) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/wp-content/uploads/2018/10/2_RFE-CURARE-3.pdf'
on conflict (recommendation_code) do nothing;
