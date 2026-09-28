-- Migration : Gestion des agents antiplaquettaires (AAP) pour une procédure invasive
-- programmée (GIHP/GFHT, en collaboration avec la SFAR, RFE 2018)
-- Source : rfe-sfar-website/build/content_aap_programmee.json (34 recommandations
-- atomiques identifiées à la lecture, sur 6 tableaux de propositions + 1 note isolée
-- explicitement taguée "(accord fort)" dans le corps du texte source).
--
-- Méthodologie source : PAS de GRADE. Propositions rédigées par cinq groupes de travail
-- GIHP/GFHT puis validées par un vote (n=37) : proposition retenue si >=50% d'accord et
-- <20% d'opposition, « accord fort » si >=70% d'accord. grade constant = 'Fort' (le
-- libellé du chip source — seul tag de force imprimé par la source à côté de chaque
-- proposition individuelle). evidence_level laissé null : pas de système de niveau de
-- preuve distinct du grade dans ce document.
--
-- DIVERGENCE SOURCE-INTERNE (disclosure, section 1.3 du cahier des charges — jamais
-- résolue silencieusement) : le contenu déjà construit et audité de cette fiche relève
-- que le Résumé du document source affirme "toutes [les propositions] sauf une ont fait
-- l'objet d'un accord fort", alors qu'une vérification exhaustive du corps du texte
-- (34 propositions retrouvées, y compris celles associées à la Figure 1 et au Tableau I)
-- montre que TOUTES portent explicitement le tag "(accord fort)", sans exception
-- identifiable. Les deux faits sont reproduits tels quels ci-dessous (grade constant
-- 'Fort' sur les 34 lignes) — l'exception annoncée par le résumé n'est PAS devinée ni
-- assignée arbitrairement à l'une des 34 propositions.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. La Figure 1 (matrice risque hémorragique × risque thrombotique) et le Tableau I
--    (caractéristiques d'un stent à haut risque thrombotique) sont des synthèses/
--    définitions reproduites intégralement dans le contenu construit, mais ne portent
--    aucun chip de force individuel dans la source (ce sont des tableaux de données, pas
--    des propositions votées séparément) — le panneau de divergence source-interne du
--    contenu construit indique que leur contenu correspond aux propositions textuelles
--    déjà chipées "(accord fort)" ailleurs dans le corps du texte (durées d'interruption,
--    gestion selon indication, bithérapie stent). PAS migrées comme recommandations
--    séparées ici, pour éviter de fragmenter artificiellement les mêmes recommandations
--    en lignes supplémentaires non distinctement sourcées.
-- 2. Une note non chipée ("des données récentes suggèrent que la chirurgie semi-urgente
--    de pontage aortocoronaire puisse être réalisée après une interruption plus courte du
--    ticagrélor, de 3 à 5 jours...") apparaît DEUX fois dans le texte source à des
--    endroits différents : une fois comme simple note en bas de la section "Durées
--    d'interruption, relais & gestion selon l'indication" (PAS chipée — présentée comme
--    donnée de la littérature, pas comme proposition votée : non migrée), et une seconde
--    fois comme ligne à part entière du tableau "Chirurgie de pontage aortocoronaire",
--    CETTE FOIS chipée "Fort" (migrée ci-dessous en R34). Le texte des deux occurrences
--    est quasi identique dans la source ; seule celle explicitement votée/chipée est
--    reprise comme recommandation atomique, conformément au principe 1.3 (pas de grade
--    deviné ni fusionné) — un chip trouvé une fois ailleurs ne peut pas être étendu à une
--    occurrence textuelle non chipée du même contenu.
-- 3. Panneau "Absence de proposition" (recours ou non à une dose de charge lors de la
--    reprise des anti-P2Y12 après interruption préopératoire) : la source déclare
--    explicitement qu'aucune proposition ne peut être faite sur ce point précis — PAS
--    migré comme ligne recommendations (aucun statement/grade réel à porter), disclosure
--    volontaire ici pour que le lecteur du script sache que ce point de la fiche source a
--    été lu et écarté à dessein, pas oublié.
-- 4. GIHP et GFHT (auteurs principaux, SFAR co-signataire — cf. "en collaboration avec la
--    SFAR" dans le texte source) ne figurent pas dans le seed Annexe B (societies) : seule
--    SFAR est liée en document_societies ci-dessous, comme pour aap_urgence (0004) et les
--    migrations précédentes dans ce même cas de figure.

insert into public.documents (title, doc_type, original_language, publication_date, doi, source_url, pdf_url, grading_system, freshness_status)
values (
  'Gestion des agents antiplaquettaires pour une procédure invasive programmée',
  'RFE', 'fr', '2018-03-06',
  '10.1016/j.anrea.2018.01.002',
  'https://sfar.org/wp-content/uploads/2018/03/2_Gestion-des-agents-antiplaquettaires-pour-une-procedure-invasive-programmee.pdf',
  'https://sfar.org/wp-content/uploads/2018/03/2_Gestion-des-agents-antiplaquettaires-pour-une-procedure-invasive-programmee.pdf',
  'GIHP/GFHT — vote (n=37) ; proposition retenue si >=50% d''accord et <20% d''opposition, « accord fort » si >=70% d''accord (pas de GRADE)',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/wp-content/uploads/2018/03/2_Gestion-des-agents-antiplaquettaires-pour-une-procedure-invasive-programmee.pdf'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/wp-content/uploads/2018/03/2_Gestion-des-agents-antiplaquettaires-pour-une-procedure-invasive-programmee.pdf'
  and s.slug in ('anesthesie_reanimation', 'cardiologie', 'chirurgie_cardiaque')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.population, v.source_section,
  'https://sfar.org/wp-content/uploads/2018/03/2_Gestion-des-agents-antiplaquettaires-pour-une-procedure-invasive-programmee.pdf',
  'draft'
from public.documents d, (values
  ('MG-ANES-000005-R01', 'Il est proposé de diviser le risque hémorragique associé à la procédure invasive en risque élevé, intermédiaire et faible.', 'Fort', 'Principe (classification du risque hémorragique)', null, 'Classification du risque hémorragique de la procédure'),
  ('MG-ANES-000005-R02', 'Les procédures à risque hémorragique élevé sont définies comme non réalisables sous AAP, même sous aspirine en monothérapie. Ce sont celles pour lesquelles le risque hémorragique sous aspirine est soit inconnu mais considéré comme potentiellement préoccupant, soit inacceptable ou jugé comme tel (risque létal ou fonctionnel). Elles sont peu fréquentes et incluent, par exemple, certains actes d''urologie lorsque des techniques alternatives ne peuvent pas être utilisées, de nombreux actes de neurochirurgie intracrânienne, les chirurgies avec des délabrements importants ou de grandes dissections, certains actes de chirurgie hépatique ou thoracique.', 'Fort', 'Risque hémorragique élevé', null, 'Classification du risque hémorragique de la procédure'),
  ('MG-ANES-000005-R03', 'Les procédures à risque hémorragique intermédiaire sont définies comme réalisables sous aspirine seule. Il s''agit de la majorité des procédures invasives.', 'Fort', 'Risque hémorragique intermédiaire', null, 'Classification du risque hémorragique de la procédure'),
  ('MG-ANES-000005-R04', 'Les procédures à faible risque hémorragique sont définies comme réalisables sous bithérapie antiplaquettaire. Elles incluent, par exemple, la chirurgie de la cataracte, certains actes de chirurgie buccodentaire, certains actes d''urologie telle l''uréthrocystoscopie, certains actes de chirurgie vasculaire, certaines bronchoscopies, certains actes d''endoscopie digestive (endoscopies diagnostiques avec ou sans biopsies, cholangio-pancréatographies rétrogrades endoscopiques sans sphinctérotomie, polypectomies coliques < 1 cm). L''expérience de ces procédures avec le ticagrélor ou le prasugrel est toutefois limitée ; l''administration associée d''autres médicaments interférant avec l''hémostase, ou l''existence d''une comorbidité augmentant le risque hémorragique, peuvent conduire à choisir l''interruption de l''anti-P2Y12.', 'Fort', 'Risque hémorragique faible', null, 'Classification du risque hémorragique de la procédure'),
  ('MG-ANES-000005-R05', 'Lorsqu''il n''existe pas de consensus ou de référentiel pour classer un acte invasif dans une des catégories de risque hémorragique, il est proposé qu''une équipe référente (opérateur, anesthésiste, cardiologue, pneumologue, médecin vasculaire, hémostasien…) dans l''établissement de santé définisse une attitude de prise en charge, au cas par cas, ou pour un profil de patient ou de geste. Ces décisions sont notifiées dans le dossier du patient ou dans les procédures de l''établissement.', 'Fort', 'Absence de consensus sur le classement du risque', null, 'Classification du risque hémorragique de la procédure'),
  ('MG-ANES-000005-R06', 'Concernant les endoscopies digestives, il est proposé que des stratégies de gestion des AAP soient définies dans chaque centre en fonction du profil des patients pris en charge et du geste invasif potentiellement réalisable pendant l''endoscopie : si la probabilité d''un geste nécessitant une interruption des AAP est jugée élevée pour un profil de patient donné, cette stratégie est adoptée (ex. sphinctérotomie, gastrostomie…) ; si la probabilité est faible, la poursuite des AAP est privilégiée (ex. maladies inflammatoires chroniques de l''intestin, dyspepsie…) ; quand la probabilité et la nature des lésions à réséquer ne sont pas connues a priori, chaque centre détermine son attitude (ex. recherche de polypes).', 'Fort', 'Endoscopies digestives', null, 'Classification du risque hémorragique de la procédure'),
  ('MG-ANES-000005-R07', 'Si l''interruption des AAP avant une procédure invasive est indiquée, il est proposé de les interrompre de la façon suivante : dernière prise d''aspirine à J-3 (J0 correspond au jour de la procédure) ; dernière prise de clopidogrel et de ticagrélor à J-5 ; dernière prise de prasugrel à J-7.', 'Fort', 'Durées d''interruption', null, 'Durées d''interruption des AAP et relais'),
  ('MG-ANES-000005-R08', 'Il est recommandé de n''utiliser ni les héparines (HNF ou HBPM) ni les AINS en relais des AAP.', 'Fort', 'Relais', null, 'Durées d''interruption des AAP et relais'),
  ('MG-ANES-000005-R09', 'Chez les patients traités au long cours par aspirine à des posologies allant jusqu''à 300 mg/j, il est proposé de ne pas réduire la posologie en vue de la chirurgie.', 'Fort', 'Aspirine — posologie', null, 'Durées d''interruption des AAP et relais'),
  ('MG-ANES-000005-R10', 'Pour la neurochirurgie intracrânienne, il est proposé que la dernière prise soit à J-5 pour l''aspirine, J-7 pour le clopidogrel et le ticagrélor, J-9 pour le prasugrel.', 'Fort', 'Durées d''interruption — neurochirurgie intracrânienne', 'Neurochirurgie intracrânienne', 'Note (neurochirurgie intracrânienne), section Durées d''interruption des AAP et relais'),
  ('MG-ANES-000005-R11', 'Il est proposé de ne pas initier un traitement par aspirine en préopératoire d''une chirurgie non cardiaque (à l''exception de l''endartériectomie carotidienne) dans le but de réduire les évènements cardiovasculaires périopératoires.', 'Fort', 'Prévention primaire — non-initiation', null, 'Gestion des AAP en fonction de leur indication'),
  ('MG-ANES-000005-R12', 'Il est proposé d''arrêter l''aspirine en préopératoire lorsqu''elle est prescrite en prévention primaire.', 'Fort', 'Prévention primaire — arrêt', null, 'Gestion des AAP en fonction de leur indication'),
  ('MG-ANES-000005-R13', 'Il est proposé de ne pas arrêter l''aspirine en préopératoire lorsqu''elle est prescrite en prévention cardiovasculaire secondaire (post-accident vasculaire cérébral ischémique, coronaropathie, artériopathie des membres inférieurs), à l''exception des procédures à risque hémorragique élevé.', 'Fort', 'Prévention secondaire — poursuite', null, 'Gestion des AAP en fonction de leur indication'),
  ('MG-ANES-000005-R14', 'Il est proposé que chez les patients traités par un anti-P2Y12 en monothérapie et programmés pour une chirurgie à risque intermédiaire, l''AAP soit remplacé par de l''aspirine, à la dose journalière 75 à 100 mg. Ce changement pourrait avoir lieu plus de sept jours avant la chirurgie, afin de permettre une correction complète de l''inhibition plaquettaire induite par l''anti-P2Y12.', 'Fort', 'Anti-P2Y12 monothérapie — relais aspirine', null, 'Gestion des AAP en fonction de leur indication'),
  ('MG-ANES-000005-R15', 'Il est proposé que la reprise de l''AAP soit aussi précoce que possible, en fonction du risque de saignement postopératoire, chez les patients ayant une indication à un traitement par AAP en monothérapie au long cours.', 'Fort', 'Reprise postopératoire', null, 'Gestion des AAP en fonction de leur indication'),
  ('MG-ANES-000005-R16', 'Il est proposé que la gestion préopératoire des AAP et leur reprise postopératoire soit discutée avec le cardiologue du patient ou un cardiologue référent et tracée dans le dossier lorsqu''il s''agit d''une procédure à risque hémorragique intermédiaire ou élevé.', 'Fort', 'Décision multidisciplinaire', 'Patients porteurs de stent coronaire', 'Bithérapie antiplaquettaire chez le patient porteur de stent coronaire'),
  ('MG-ANES-000005-R17', 'Il est proposé de reporter toute chirurgie non cardiaque à la fin de la durée recommandée de la bithérapie antiplaquettaire quand cela ne génère pas de risque vital ou fonctionnel majeur pour le patient.', 'Fort', 'Report de la chirurgie', 'Patients porteurs de stent coronaire', 'Bithérapie antiplaquettaire chez le patient porteur de stent coronaire'),
  ('MG-ANES-000005-R18', 'Si le report de la chirurgie n''est pas possible, il est proposé de repousser toute chirurgie non cardiaque au-delà du 1er mois qui suit la pose de stent, quel que soit le type de stent, quelle que soit l''indication (IDM ou coronaropathie stable). Si le geste ne peut être différé au-delà du 1er mois, il est proposé de réaliser cette chirurgie en poursuivant l''aspirine et dans un centre ayant un plateau de cardiologie interventionnelle actif 24 heures sur 24.', 'Fort', 'Si report impossible', 'Patients porteurs de stent coronaire', 'Bithérapie antiplaquettaire chez le patient porteur de stent coronaire'),
  ('MG-ANES-000005-R19', 'Chez les patients sous bithérapie antiplaquettaire dans les suites d''un IDM ou en cas de pose de stent associé à des caractéristiques à haut risque thrombotique, il est proposé de reporter toute chirurgie non cardiaque au-delà du 6e mois qui suit la pose de stent.', 'Fort', 'Haut risque thrombotique / IDM', 'Patients porteurs de stent coronaire', 'Bithérapie antiplaquettaire chez le patient porteur de stent coronaire'),
  ('MG-ANES-000005-R20', 'Il est recommandé de poursuivre l''aspirine en préopératoire chez le patient porteur de stent coronaire. Si elle a été interrompue, il est recommandé de la reprendre aussi précocement que possible après la procédure invasive, au mieux le jour même, en fonction du risque de saignement postopératoire.', 'Fort', 'Aspirine — poursuite', 'Patients porteurs de stent coronaire', 'Bithérapie antiplaquettaire chez le patient porteur de stent coronaire'),
  ('MG-ANES-000005-R21', 'Si les deux AAP doivent être interrompus dans le 1er mois suivant la pose de stent, un relais par des AAP parentéraux réversibles comme le tirofiban ou le cangrélor peut être discuté au cas par cas, avec une approche multidisciplinaire (utilisation hors AMM). Dans ces situations exceptionnelles, associées à un haut risque hémorragique et thrombotique, le relais doit être réalisé en soins intensifs et la chirurgie doit être réalisée dans un centre ayant un service de cardiologie interventionnelle actif 24 heures sur 24.', 'Fort', 'Relais parentéral (cas exceptionnels)', 'Patients porteurs de stent coronaire', 'Bithérapie antiplaquettaire chez le patient porteur de stent coronaire'),
  ('MG-ANES-000005-R22', 'Si les anti-P2Y12 ont été interrompus avant la chirurgie, ils doivent être repris précocement, au mieux dans les 24 à 72 heures après la chirurgie, compte tenu de l''augmentation du risque thrombotique. La reprise se fait avec le même anti-P2Y12 qu''en préopératoire.', 'Fort', 'Reprise des anti-P2Y12', 'Patients porteurs de stent coronaire', 'Bithérapie antiplaquettaire chez le patient porteur de stent coronaire'),
  ('MG-ANES-000005-R23', 'Il est proposé de ne pas administrer d''AINS en périopératoire chez les patients traités par bithérapie antiplaquettaire.', 'Fort', 'AINS', 'Patients porteurs de stent coronaire, bithérapie antiplaquettaire', 'Bithérapie antiplaquettaire chez le patient porteur de stent coronaire'),
  ('MG-ANES-000005-R24', 'L''aspirine ne contre-indique pas une anesthésie locorégionale rachidienne (ALR-R) si le rapport bénéfice-risque est favorable, en vérifiant l''absence d''anomalie associée de l''hémostase, incluant un traitement anticoagulant. Il est proposé de préférer si possible la rachianesthésie en ponction unique à la péridurale.', 'Fort', 'Aspirine (ALR rachidienne)', null, 'Anesthésie locorégionale rachidienne (ALR-R)'),
  ('MG-ANES-000005-R25', 'L''ALR rachidienne est contre-indiquée en cas de traitement par anti-P2Y12 (clopidogrel, prasugrel, ticagrélor), sauf si ces AAP ont été interrompus respectivement 5, 7 et 5 jours avant le geste.', 'Fort', 'Anti-P2Y12 (ALR rachidienne)', null, 'Anesthésie locorégionale rachidienne (ALR-R)'),
  ('MG-ANES-000005-R26', 'La mise en place d''un cathéter péridural expose à une gestion complexe des AAP. Le retrait du cathéter suit les mêmes règles que la pose. Le recours au cathéter péridural ne doit pas compromettre la reprise postopératoire des AAP, et en particulier des anti-P2Y12.', 'Fort', 'Cathéter péridural', null, 'Anesthésie locorégionale rachidienne (ALR-R)'),
  ('MG-ANES-000005-R27', 'Il est proposé que les blocs nerveux périphériques à faible risque hémorragique puissent être réalisés sous AAP, en mono- ou en bithérapie, si le rapport bénéfice/risque est favorable.', 'Fort', 'Blocs à faible risque hémorragique', null, 'Blocs nerveux périphériques'),
  ('MG-ANES-000005-R28', 'Il est proposé que les blocs nerveux périphériques à haut risque hémorragique puissent être réalisés sous aspirine en monothérapie si le rapport bénéfice/risque est favorable. Ces blocs sont contre-indiqués sous anti-P2Y12 (clopidogrel, prasugrel, ticagrélor), sauf si ces AAP ont été interrompus respectivement 5, 7 et 5 jours avant le geste.', 'Fort', 'Blocs à haut risque hémorragique', null, 'Blocs nerveux périphériques'),
  ('MG-ANES-000005-R29', 'Il est proposé que les blocs nerveux périphériques (superficiels ou profonds) soient réalisés par échoguidage et par un opérateur expérimenté.', 'Fort', 'Échoguidage', null, 'Blocs nerveux périphériques'),
  ('MG-ANES-000005-R30', 'La mise en place d''un cathéter périnerveux ne doit pas compromettre la reprise postopératoire des AAP, et en particulier des anti-P2Y12. Son retrait suit les mêmes règles que la pose.', 'Fort', 'Cathéter périnerveux', null, 'Blocs nerveux périphériques'),
  ('MG-ANES-000005-R31', 'Il est proposé que la stratégie de gestion des AAP en vue de pontage aortocoronaire (PAC) soit décidée de façon multidisciplinaire en fonction du risque hémorragique et du risque thrombotique de chaque patient.', 'Fort', 'Décision multidisciplinaire', 'Chirurgie de pontage aortocoronaire (PAC)', 'Chirurgie cardiaque de pontage aortocoronaire (PAC)'),
  ('MG-ANES-000005-R32', 'Il est proposé de poursuivre l''aspirine pour la chirurgie de pontage aortocoronaire (PAC).', 'Fort', 'Aspirine', 'Chirurgie de pontage aortocoronaire (PAC)', 'Chirurgie cardiaque de pontage aortocoronaire (PAC)'),
  ('MG-ANES-000005-R33', 'Pour les patients traités par bithérapie antiplaquettaire, il est proposé de réaliser les procédures de pontage aortocoronaire (PAC) après interruption des anti-P2Y12, avec dernière prise de clopidogrel et de ticagrélor à J-5 et une dernière prise de prasugrel à J-7.', 'Fort', 'Anti-P2Y12 — durées', 'Chirurgie de pontage aortocoronaire (PAC)', 'Chirurgie cardiaque de pontage aortocoronaire (PAC)'),
  ('MG-ANES-000005-R34', 'Des données récentes suggèrent que la chirurgie semi-urgente de pontage aortocoronaire puisse être réalisée après une interruption plus courte du ticagrélor, de 3 à 5 jours, sans surrisque hémorragique pour la majorité des patients. Cependant, dans cette situation, les patients n''ayant pas une correction de l''inhibition plaquettaire induite par le ticagrélor sont exposés à un risque d''hémorragie.', 'Fort', 'Ticagrélor — données récentes', 'Chirurgie de pontage aortocoronaire (PAC), patients sous ticagrélor', 'Chirurgie cardiaque de pontage aortocoronaire (PAC)')
) as v(code, statement, grade, condition_topic, population, source_section)
where d.source_url = 'https://sfar.org/wp-content/uploads/2018/03/2_Gestion-des-agents-antiplaquettaires-pour-une-procedure-invasive-programmee.pdf'
on conflict (recommendation_code) do nothing;
