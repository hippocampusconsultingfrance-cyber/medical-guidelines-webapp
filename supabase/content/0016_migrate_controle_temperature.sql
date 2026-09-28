-- Migration : Contrôle ciblé de la température en réanimation (hors nouveau-nés) —
-- SRLF/SFAR + ANARLF/GFRUP/SFMU/SFNV, RFE 2016
-- Source : rfe-sfar-website/build/content_controle_temperature.json (30 recommandations
-- atomiques : 24 "adulte" + 6 "pédiatrique" dédiées, tableaux "Réf. | Recommandation |
-- Grade").
--
-- PARTICULARITÉ DE NOTATION DE LA SOURCE (disclosure déjà faite par le contenu construit,
-- vérifiée par inventaire exhaustif de chaque tag imprimé) : cette RFE n'imprime JAMAIS de
-- suffixe "-" — contrairement à la majorité des autres RFE de ce corpus (1+/1-/2+/2-), les
-- recommandations de sens négatif ("il ne faut probablement pas...") portent leur grade SANS
-- signe (ex. '2' au lieu de '2-'). Grade reproduit tel quel depuis le chip source (1+/2+/2/AE
-- — jamais de '1-'/'2-' dans ce document précis, le sens négatif est porté par le texte du
-- `statement` lui-même, jamais par le grade). evidence_level laissé NULL : pas de système de
-- niveau de preuve distinct de la force GRADE dans ce document.
--
-- Le contenu construit annonce et vérifie lui-même exactement "30 recommandations" (24
-- adulte + 6 pédiatriques) et une répartition (3 grade 1, 13 grade 2, 14 avis d'experts)
-- confirmée par inventaire exhaustif — décompte qui correspond exactement aux 30 lignes
-- migrées ci-dessous, aucune divergence à disclose. "Aucun tableau ni figure dans le corps
-- du texte source" (vérifié par le contenu construit) : pas de contenu de référence à
-- exclure pour cette fiche, contrairement à la plupart des migrations précédentes.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. `library_final.json` donne exact_date 2016-05-25 (date de publication initiale,
--    utilisée ci-dessous comme publication_date) ; le contenu construit cite par ailleurs
--    "texte validé par le CA de la SRLF et de la SFAR le 18/02/2016" (antérieure à la
--    publication — validation puis publication, pas une contradiction) et une double
--    republication (Anaesth Crit Care Pain Med 2018, puis Anesth Reanim 2019 —
--    doi:10.1016/j.anrea.2018.10.004) : trois dates distinctes pour trois jalons différents,
--    disclosure sans réconciliation arbitraire d'une "seule vraie date".
-- 2. SRLF et SFAR (coordonnateurs) ET SFMU sont liées en document_societies (toutes trois
--    dans le seed Annexe B). ANARLF (Association Nationale des Anesthésistes-Réanimateurs
--    en Ligne Francophones), GFRUP et SFNV (Société Française Neuro-Vasculaire), également
--    co-auteurs, n'y figurent pas — non liées.
-- 3. Document de 2016 : le contenu construit lui-même invite à "vérifier l'existence d'une
--    actualisation" — `freshness_status` reste 'a_jour' faute d'information de retrait dans
--    `library_final.json` (`status: "en vigueur"`), à confirmer par un relecteur humain.

insert into public.documents (title, doc_type, original_language, publication_date, doi, source_url, pdf_url, grading_system, freshness_status)
values (
  'Contrôle ciblé de la température en réanimation (hors nouveau-nés)',
  'RFE', 'fr', '2016-05-25',
  '10.1016/j.anrea.2018.10.004',
  'https://sfar.org/wp-content/uploads/2019/10/rfe-controle-cible-de-la-temperature-en-reanimation.pdf',
  'https://sfar.org/wp-content/uploads/2019/10/rfe-controle-cible-de-la-temperature-en-reanimation.pdf',
  'GRADE : 1+ (recommandé, forte) ; 2+ (probablement recommandé, faible) ; 2 (sens négatif, faible — cette source n''imprime jamais de suffixe "-", le sens négatif est porté par le texte de la recommandation) ; AE (avis d''experts). 30 recommandations au total (3 grade 1, 13 grade 2, 14 avis d''experts), vérifié par inventaire exhaustif.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/wp-content/uploads/2019/10/rfe-controle-cible-de-la-temperature-en-reanimation.pdf'
  and s.acronym in ('SRLF', 'SFAR', 'SFMU') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/wp-content/uploads/2019/10/rfe-controle-cible-de-la-temperature-en-reanimation.pdf'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'neurologie', 'medecine_d_urgence', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/wp-content/uploads/2019/10/rfe-controle-cible-de-la-temperature-en-reanimation.pdf',
  'draft'
from public.documents d, (values
  ('MG-ANES-000016-R01', 'Chez les patients comateux après réanimation d''un arrêt cardiaque (AC) extra-hospitalier avec rythme initial choquable (FV ou TV), il faut pratiquer un CCT dans le but d''améliorer la survie avec bon pronostic neurologique.', '1+', 'Champ 1 — Contrôle ciblé de la température après arrêt cardiaque (R1.1)'),
  ('MG-ANES-000016-R02', 'Chez les patients comateux après réanimation d''un AC extra-hospitalier avec rythme initial non choquable (asystolie ou rythme sans pouls), il faut probablement pratiquer un CCT dans le but d''améliorer la survie avec bon pronostic neurologique.', '2+', 'Champ 1 — Contrôle ciblé de la température après arrêt cardiaque (R1.2)'),
  ('MG-ANES-000016-R03', 'Chez les patients comateux après réanimation d''un AC intra-hospitalier, il faut probablement pratiquer un CCT dans le but d''améliorer la survie avec bon pronostic neurologique.', 'AE', 'Champ 1 — Contrôle ciblé de la température après arrêt cardiaque (R1.3)'),
  ('MG-ANES-000016-R04', 'Chez les patients traités par CCT après AC, il faut probablement cibler un niveau de température entre 32 et 36 °C dans le but d''améliorer la survie avec bon pronostic neurologique.', '2+', 'Champ 1 — Contrôle ciblé de la température après arrêt cardiaque (R1.4)'),
  ('MG-ANES-000016-R05', 'Parmi les méthodes de CCT disponibles en préhospitalier, chez les patients traités par CCT après AC, il ne faut probablement pas débuter le CCT par perfusion de solutés froids pendant le transport vers l''hôpital, dans le but d''améliorer la survie avec bon pronostic neurologique.', '2', 'Champ 1 — Contrôle ciblé de la température après arrêt cardiaque (R1.5)'),
  ('MG-ANES-000016-R06', '(Pédiatrique) Chez les enfants comateux après réanimation d''un AC intra- ou extra-hospitalier sur rythme non choquable ou choquable, il faut probablement effectuer un CCT avec pour objectif la normothermie pour améliorer le pronostic neurologique.', 'AE', 'Champ 1 — Contrôle ciblé de la température après arrêt cardiaque (R1.1 P)'),
  ('MG-ANES-000016-R07', '(Pédiatrique) Chez les enfants comateux après réanimation d''un AC extra-hospitalier sur rythme non choquable ou choquable, il ne faut probablement pas pratiquer un CCT avec un objectif de température entre 32 et 34 °C dans le but d''améliorer la survie avec bon pronostic neurologique.', '2', 'Champ 1 — Contrôle ciblé de la température après arrêt cardiaque (R1.2 P)'),
  ('MG-ANES-000016-R08', 'Chez les patients traumatisés crâniens graves, il faut probablement pratiquer un CCT entre 35 et 37 °C dans le but de prévenir l''hypertension intracrânienne.', '2+', 'Champ 2 — Contrôle ciblé de la température après traumatisme crânien (R2.1)'),
  ('MG-ANES-000016-R09', 'Chez les patients traumatisés crâniens graves, il faut probablement pratiquer un CCT entre 35 et 37 °C dans le but d''améliorer la survie avec bon pronostic neurologique.', '2+', 'Champ 2 — Contrôle ciblé de la température après traumatisme crânien (R2.2)'),
  ('MG-ANES-000016-R10', 'Chez les patients traumatisés crâniens avec hypertension intracrânienne malgré un traitement médical bien conduit, il faut probablement pratiquer un CCT entre 34 et 35 °C dans le but de faire baisser la pression intracrânienne.', '2+', 'Champ 2 — Contrôle ciblé de la température après traumatisme crânien (R2.3)'),
  ('MG-ANES-000016-R11', '(Pédiatrique) Chez l''enfant traumatisé crânien grave, il faut faire un CCT visant à maintenir une normothermie.', 'AE', 'Champ 2 — Contrôle ciblé de la température après traumatisme crânien (R2.1 P)'),
  ('MG-ANES-000016-R12', '(Pédiatrique) Chez l''enfant traumatisé crânien grave, il ne faut pas induire de CCT avec pour but d''obtenir une hypothermie thérapeutique entre 32 et 34 °C pour améliorer le pronostic ou pour contrôler l''HTIC.', '1', 'Champ 2 — Contrôle ciblé de la température après traumatisme crânien (R2.2 P)'),
  ('MG-ANES-000016-R13', 'Chez les patients à la phase aiguë d''un AVC ischémique grave, il faut probablement pratiquer un CCT ciblant la normothermie.', 'AE', 'Champ 3 — AVC grave et autres hémorragies cérébrales (R3.1)'),
  ('MG-ANES-000016-R14', 'Chez les patients comateux avec hématome intraparenchymateux spontané, il faut probablement réaliser un CCT entre 35 et 37 °C pour faire baisser la pression intracrânienne.', 'AE', 'Champ 3 — AVC grave et autres hémorragies cérébrales (R3.2)'),
  ('MG-ANES-000016-R15', 'Chez les patients comateux avec une hémorragie sous-arachnoïdienne, il faut probablement réaliser un CCT pour faire baisser la pression intracrânienne et/ou améliorer le pronostic neurologique.', 'AE', 'Champ 3 — AVC grave et autres hémorragies cérébrales (R3.3)'),
  ('MG-ANES-000016-R16', '(Pédiatrique) Chez l''enfant présentant une hémorragie sous-arachnoïdienne, il faut probablement faire un CCT avec une température cible entre 36 et 37,5 °C dans le but de limiter l''HTIC.', 'AE', 'Champ 3 — AVC grave et autres hémorragies cérébrales (R3.1 P)'),
  ('MG-ANES-000016-R17', 'Chez les patients avec un état de mal épileptique réfractaire ou superréfractaire, persistant sous anesthésie générale, il faut probablement faire un CCT entre 32 et 35 °C pour contrôler l''activité épileptique.', 'AE', 'Champ 4 — Autres agressions cérébrales (méningite, état de mal épileptique) (R4.1)'),
  ('MG-ANES-000016-R18', 'Chez les patients dans le coma avec une méningite ou une méningo-encéphalite, il ne faut probablement pas pratiquer de CCT lorsque la fièvre est bien tolérée.', 'AE', 'Champ 4 — Autres agressions cérébrales (méningite, état de mal épileptique) (R4.2)'),
  ('MG-ANES-000016-R19', 'Chez les patients dans le coma avec une méningite bactérienne, en l''absence d''HTIC, il ne faut probablement pas pratiquer d''hypothermie, en comparaison avec une normothermie, dans le but d''améliorer la survie avec bon pronostic neurologique.', 'AE', 'Champ 4 — Autres agressions cérébrales (méningite, état de mal épileptique) (R4.3)'),
  ('MG-ANES-000016-R20', 'Chez les patients dans le coma avec une méningite bactérienne et une HTIC, il faut probablement pratiquer une hypothermie, en comparaison avec une normothermie, dans le but d''améliorer la survie avec bon pronostic neurologique.', 'AE', 'Champ 4 — Autres agressions cérébrales (méningite, état de mal épileptique) (R4.4)'),
  ('MG-ANES-000016-R21', '(Pédiatrique) Chez l''enfant présentant un état de mal épileptique, il faut probablement réaliser un CCT (normothermie) à visée neuroprotectrice.', 'AE', 'Champ 4 — Autres agressions cérébrales (méningite, état de mal épileptique) (R4.1 P)'),
  ('MG-ANES-000016-R22', 'Chez les patients en choc cardiogénique, il ne faut probablement pas pratiquer un CCT ciblant une température inférieure à 36 °C dans le but d''améliorer la survie.', '2', 'Champ 5 — États de choc (choc cardiogénique, choc septique) (R5.1)'),
  ('MG-ANES-000016-R23', 'Chez les patients en choc septique, il ne faut probablement pas pratiquer un CCT ciblant une température inférieure à 36 °C dans le but d''améliorer la survie.', '2', 'Champ 5 — États de choc (choc cardiogénique, choc septique) (R5.2)'),
  ('MG-ANES-000016-R24', 'Chez les patients en choc septique, il faut probablement pratiquer un CCT ciblant la normothermie dans le but d''améliorer l''hémodynamique.', '2+', 'Champ 5 — États de choc (choc cardiogénique, choc septique) (R5.3)'),
  ('MG-ANES-000016-R25', 'Chez les patients traités par CCT, il faut utiliser des méthodes asservies à la température corporelle, par comparaison aux méthodes non asservies, dans le but d''améliorer la qualité du CCT.', '1+', 'Champ 6 — Modalités pratiques de mise en œuvre et de surveillance du CCT (R6.1)'),
  ('MG-ANES-000016-R26', 'Chez les patients traités par CCT, il faut probablement contrôler la vitesse du réchauffement.', 'AE', 'Champ 6 — Modalités pratiques de mise en œuvre et de surveillance du CCT (R6.2)'),
  ('MG-ANES-000016-R27', 'Chez les patients traités par CCT, il faut probablement privilégier des sites de mesure de température centrale.', '2+', 'Champ 6 — Modalités pratiques de mise en œuvre et de surveillance du CCT (R6.3)'),
  ('MG-ANES-000016-R28', 'Chez les patients traités par CCT, il faut probablement surveiller la survenue de certaines complications : sepsis, pneumopathie, arythmie, hypokaliémie.', '2+', 'Champ 6 — Modalités pratiques de mise en œuvre et de surveillance du CCT (R6.4)'),
  ('MG-ANES-000016-R29', '(Pédiatrique) Chez les enfants pour lesquels le CCT a été retenu, il faut probablement utiliser des méthodes asservies à la température corporelle, par comparaison aux méthodes non asservies, dans le but d''améliorer la qualité du CCT.', 'AE', 'Champ 6 — Modalités pratiques de mise en œuvre et de surveillance du CCT (R6.1 P)'),
  ('MG-ANES-000016-R30', '(Pédiatrique) Chez les enfants traités par CCT, il faut probablement privilégier des sites de mesure de température centrale.', '2+', 'Champ 6 — Modalités pratiques de mise en œuvre et de surveillance du CCT (R6.2 P)')) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/wp-content/uploads/2019/10/rfe-controle-cible-de-la-temperature-en-reanimation.pdf'
on conflict (recommendation_code) do nothing;
