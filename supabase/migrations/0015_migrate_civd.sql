-- Migration : Coagulations Intra-Vasculaires Disséminées (CIVD) en réanimation — Définition,
-- classification et traitement — SRLF (XXIIe Conférence de Consensus, avec SFAR/GEHT/GFRUP),
-- 10 octobre 2002
-- Source : rfe-sfar-website/build/content_civd.json (22 recommandations atomiques, grille
-- SRLF à deux axes distincts "Preuve" (a>b>c>d) et "Force" (1>2>3, imprimée seulement quand
-- le jury l'a jugé possible) — même méthodologie et même convention de migration que
-- asthme_aigu_grave (0013) : Force -> grade, Preuve -> evidence_level, tous deux
-- distinctement renseignés et jamais l'un déduit de l'autre.
--
-- Le contenu construit annonce lui-même exactement "22 énoncés cotés au total dans le corps
-- du texte" — décompte qui correspond exactement aux 22 lignes migrées ci-dessous (aucune
-- divergence à disclose ici, contrairement à d'autres migrations de ce corpus).
--
-- PÉRIMÈTRE — deux tableaux volontairement pas migrés (référence/algorithme, pas des
-- recommandations individuellement graduées) : le tableau des critères de consommation
-- "Paramètre (unité) | Majeur | Mineur" (définitionnel, sans colonne Preuve/Force) et
-- l'organigramme de stratégie thérapeutique (page 5 de la source, reconstruit par le
-- contenu construit depuis un rendu visuel à 200dpi car "texte scramblé par l'extraction
-- automatique sur cette page" — le contenu construit le disclose lui-même) : c'est un arbre
-- décisionnel transcrit en tableau, pas des énoncés Preuve/Force individuels — son contenu
-- clinique (transfusion plaquettaire/PFC selon seuils, absence de traitement spécifique) est
-- de toute façon déjà couvert par les recommandations R07/R08/R16/R19 migrées ci-dessous.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Document de 2002 : le contenu construit disclose lui-même explicitement que "la prise
--    en charge thérapeutique de la CIVD a évolué depuis 2002" (protéine C activée
--    recombinante retirée du marché depuis) — `freshness_status` reste 'a_jour' faute
--    d'information de retrait dans `library_final.json`, mais à vérifier par un relecteur
--    humain avant publication.
-- 2. SRLF (coordonnateur) et SFAR liées en document_societies (toutes deux dans le seed
--    Annexe B). GEHT (Groupe d'Étude sur l'Hémostase et la Thrombose, société fille de la
--    Société Française d'Hématologie) et GFRUP (Groupe Francophone de Réanimation et
--    Urgences Pédiatriques), co-organisateurs, n'y figurent pas — non liés.
-- 3. Champ explicitement exclu par la source : cancers et hémopathies malignes (non couverts
--    par cette conférence de consensus).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Coagulations Intra-Vasculaires Disséminées (CIVD) en réanimation – Définition, classification et traitement',
  'CC', 'fr', '2002-10-10',
  'https://sfar.org/wp-content/uploads/2015/10/86-civdccons.pdf',
  'https://sfar.org/wp-content/uploads/2015/10/86-civdccons.pdf',
  'Pas de système GRADE — chaque énoncé peut porter une lettre de niveau de preuve (Preuve : a>b>c>d, selon le type d''étude) et, quand jugé possible, un chiffre de niveau de recommandation (Force : 1>2>3). 22 énoncés cotés au total.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/10/86-civdccons.pdf'
  and s.acronym in ('SRLF', 'SFAR') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/10/86-civdccons.pdf'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'hematologie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, evidence_level, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.evidence_level, v.condition_topic, v.source_section,
  'https://sfar.org/wp-content/uploads/2015/10/86-civdccons.pdf',
  'draft'
from public.documents d, (values
  ('MG-ANES-000015-R01', 'Induction de la synthèse et de l''expression membranaire du FT par des cellules au contact du sang, en réponse à des stimuli inflammatoires : le sepsis est la principale cause, mais d''autres situations peuvent aboutir à une réaction inflammatoire systémique et à une activation de la coagulation (hypothermie, hyperthermie maligne, choc hémorragique).', null, 'c', 'Mécanisme 1 — induction du FT', 'Question 2 — Situations cliniques à risque de CIVD'),
  ('MG-ANES-000015-R02', 'Contact entre le FT constitutif extra-vasculaire et le FVIIa lié à une effraction vasculaire : traumatismes (crâniens en particulier), complications obstétricales (hématome rétroplacentaire, mort in utero, rétention intra-utérine), brûlures, pancréatites, complications transfusionnelles, hémolyses.', null, 'c', 'Mécanisme 2 — effraction vasculaire', 'Question 2 — Situations cliniques à risque de CIVD'),
  ('MG-ANES-000015-R03', 'Contact entre le FT et le FVIIa exprimé à la surface de cellules anormales : cancers métastasés et hémopathies malignes.', null, 'c', 'Mécanisme 3 — cellules anormales', 'Question 2 — Situations cliniques à risque de CIVD'),
  ('MG-ANES-000015-R04', 'L''association de polymorphismes génétiques avec la CIVD reste du domaine de la recherche.', null, 'c', 'Polymorphismes génétiques', 'Question 2 — Situations cliniques à risque de CIVD'),
  ('MG-ANES-000015-R05', 'Le diagnostic de CIVD biologique est retenu si les D-dimères sont augmentés et s''il existe un critère majeur ou deux critères mineurs de consommation (voir tableau ci-dessous). Technique recommandée : test d''agglutination de particules de latex avec lecture automatisée, seuil 500 µg/L. L''élévation des D-dimères n''est pas spécifique de CIVD.', '2', 'c', 'Diagnostic biologique', 'Question 3 — Diagnostic clinique et biologique'),
  ('MG-ANES-000015-R06', 'Une association entre syndrome de défaillance multiviscérale, mortalité et CIVD a été constatée, mais la notion d''imputabilité directe de la CIVD dans les défaillances d''organe n''est pas démontrée.', null, 'b', 'Défaillance multiviscérale', 'Question 3 — Diagnostic clinique et biologique'),
  ('MG-ANES-000015-R07', 'Indiquée uniquement en cas d''association d''une thrombopénie < 50 G/L et de facteurs de risque hémorragique (acte invasif, thrombopathie associée), ou d''hémorragie grave (CIVD compliquée). Choix entre mélange de concentrés standard et concentré d''aphérèse selon la disponibilité.', null, 'd', 'Transfusion plaquettaire', 'Question 4 — Moyens thérapeutiques et indications spécifiques'),
  ('MG-ANES-000015-R08', 'Indiqué (10 à 15 ml/kg) dans les CIVD avec effondrement des facteurs de coagulation (TP < 35–40 %), associées à une hémorragie active ou potentielle (acte invasif). Choix entre plasma sécurisé et plasma viro-atténué (efficacité identique) selon disponibilité et coût.', null, 'd', 'Plasma frais congelé (PFC)', 'Question 4 — Moyens thérapeutiques et indications spécifiques'),
  ('MG-ANES-000015-R09', 'Aucune indication démontrée à l''utilisation du fibrinogène dans la CIVD.', null, 'd', 'Fibrinogène', 'Question 4 — Moyens thérapeutiques et indications spécifiques'),
  ('MG-ANES-000015-R10', 'Potentiellement thrombogène : contre-indiqué au cours des CIVD.', null, 'd', 'Complexe prothrombique (PPSB)', 'Question 4 — Moyens thérapeutiques et indications spécifiques'),
  ('MG-ANES-000015-R11', 'Administration non validée dans le traitement de la CIVD.', null, 'c', 'Concentrés de protéine C', 'Question 4 — Moyens thérapeutiques et indications spécifiques'),
  ('MG-ANES-000015-R12', 'Pas d''information sur l''efficacité dans le traitement de la CIVD.', null, 'd', 'Protéine C activée recombinante (drotrécogine α)', 'Question 4 — Moyens thérapeutiques et indications spécifiques'),
  ('MG-ANES-000015-R13', 'Améliore la CIVD au cours du sepsis ; la puissance insuffisante des études ne permet pas de conclure à un effet sur les défaillances d''organes et la mortalité.', null, 'a', 'Antithrombine (AT)', 'Question 4 — Moyens thérapeutiques et indications spécifiques'),
  ('MG-ANES-000015-R14', 'Efficacité non démontrée dans le traitement de la CIVD.', null, 'c', 'Héparines', 'Question 4 — Moyens thérapeutiques et indications spécifiques'),
  ('MG-ANES-000015-R15', 'Efficacité non démontrée dans le traitement de la CIVD.', null, 'c', 'Modulateurs de la fibrinolyse', 'Question 4 — Moyens thérapeutiques et indications spécifiques'),
  ('MG-ANES-000015-R16', 'L''objectif thérapeutique est de limiter le saignement : transfusion de concentrés plaquettaires et de PFC jusqu''à arrêt du saignement.', '2', 'c', 'CIVD compliquée d''hémorragie grave', 'Question 5 — Stratégie thérapeutique selon la situation clinique'),
  ('MG-ANES-000015-R17', 'En cas de procédure invasive, ces produits (concentrés plaquettaires et PFC) doivent être transfusés immédiatement avant sa réalisation.', '2', 'c', 'Procédure invasive', 'Question 5 — Stratégie thérapeutique selon la situation clinique'),
  ('MG-ANES-000015-R18', 'La stratégie thérapeutique immédiate repose sur la symptomatologie clinique.', '3', 'c', 'Purpura fulminans / CIVD obstétricale', 'Question 5 — Stratégie thérapeutique selon la situation clinique'),
  ('MG-ANES-000015-R19', 'Aucun traitement spécifique de la CIVD n''existe, quelle que soit l''étiologie : héparines, fibrinolytiques, antifibrinolytiques, AT, PC, PCa ne sont pas recommandés.', '2', 'c', 'Toute étiologie', 'Question 5 — Stratégie thérapeutique selon la situation clinique'),
  ('MG-ANES-000015-R20', 'L''utilisation de l''aprotinine est fréquente en cas de défibrination ; aucune étude n''a démontré son efficacité et son utilisation n''est pas recommandée.', '3', 'c', 'Hémorragie de la délivrance', 'Question 5 — Stratégie thérapeutique selon la situation clinique'),
  ('MG-ANES-000015-R21', 'L''héparinothérapie est habituellement utilisée ; aucune étude n''a démontré son efficacité et son utilisation n''est pas recommandée.', '3', 'c', 'Embolie amniotique', 'Question 5 — Stratégie thérapeutique selon la situation clinique'),
  ('MG-ANES-000015-R22', 'L''héparinothérapie est souvent utilisée ; aucune étude n''a démontré son efficacité et son utilisation n''est pas recommandée.', '3', 'c', 'Purpura fulminans post-infectieux', 'Question 5 — Stratégie thérapeutique selon la situation clinique')) as v(code, statement, grade, evidence_level, condition_topic, source_section)
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/10/86-civdccons.pdf'
on conflict (recommendation_code) do nothing;
