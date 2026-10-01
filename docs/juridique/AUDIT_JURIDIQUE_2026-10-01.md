# Audit juridique — medical-guidelines.net (01/10/2026)

> Ce document est une analyse préparatoire, pas un avis d'avocat. Il sert à
> préparer l'échange avec le conseil juridique qui relit les CGV (§12.4 du
> cahier des charges). Les points notés **[AVOCAT]** doivent lui être
> soumis.

## 1. En résumé

| Sujet | Niveau de risque | Ce qui protège déjà | À faire |
|---|---|---|---|
| Libellés des recommandations recopiés ou très proches (≈ 40 %, mesuré) | **Moyen à élevé** pour les sources « tous droits réservés » (SFAR, SFMU…) | Source citée, lien vers le texte officiel, pas de PDF, pas de logo | Politique de citation, registre juridique, demande d'autorisation |
| Sources HAS | **Faible** | Réutilisation libre sous conditions | Indiquer la date de dernière mise à jour HAS |
| Traductions anglaises | **Élevé** si publiées sans autorisation | Aucune publiée ; verrou en base ajouté | Garder non publiées jusqu'à autorisation écrite |
| Noms et sigles des sociétés (SFAR, SRLF…) | Faible | Usage pour désigner la source, aucun logo, « ni éditée ni validée » | Rien |
| Abonnement payant | Moyen (perception) | Page « Notre démarche », pas de vente des PDF | Cohérence des textes, réinvestissement réel |
| Assistant de recherche (IA) | Moyen (dispositif médical) | Extraits exacts, refus des cas patients, réservé à l'équipe | Avis réglementaire avant ouverture |
| Parasitisme / concurrence déloyale | Faible à moyen | Renvoi systématique vers la source, procédure de retrait | Procédure de retrait publiée (faite) |

## 2. Le principe juridique

- **Les idées et les informations ne sont pas protégées** par le droit
  d'auteur : seule leur **forme** (le texte rédigé, la structure des
  tableaux, la mise en page) l'est (Code de la propriété intellectuelle,
  art. L111-1 et L112-1). Dire qu'« une fièvre d'origine infectieuse
  contre-indique une anesthésie périmédullaire » est une information libre ;
  recopier la phrase exacte de la SFAR est une reproduction de sa forme.
- **Exception de courte citation** (art. L122-5, 3° a) : autorisée si elle
  est *courte*, *justifiée* (caractère pédagogique, scientifique,
  d'information), *incorporée dans une œuvre propre* et accompagnée du
  **nom de l'auteur et de la source**. Une reprise **systématique de toutes
  les recommandations** d'un texte n'est en général plus une « courte
  citation ».
- **Traduire** un texte est un droit réservé à son auteur (art. L122-4).
- Vendre un service n'est pas interdit en soi : ce qui compte, c'est ce qui
  est reproduit, pas le fait d'être payant. Mais le caractère commercial rend
  les juges plus exigeants sur la courte citation.

## 3. Ce que disent les sources (recherche du 01/10/2026)

| Source | Fiches en ligne | Conditions trouvées | Conséquence |
|---|---|---|---|
| **HAS** | 9 | Contenus « librement et gratuitement réutilisables » (art. L321-1 du code des relations entre le public et l'administration), **à condition** de ne pas les altérer ni en dénaturer le sens, et de mentionner la source et la date de dernière mise à jour. Les contenus avec droits de tiers exigent un accord. | Réutilisation commerciale permise : peut être « validé » au registre, en vérifiant l'absence de droits de tiers sur chaque document. |
| **SFAR** | 110 | Mentions légales sans clause de réutilisation ; pied de page « Tous droits réservés ». Les RFE récentes sont publiées dans *Anaesthesia Critical Care & Pain Medicine* (Elsevier) ; les anciennes RPC dans les *Annales françaises d'anesthésie et de réanimation* (Elsevier). Le titulaire des droits peut donc être Elsevier ou la SFAR selon le document. | Régime par défaut : autorisation nécessaire pour reproduire le texte. Registre : « à vérifier » ou « autorisation requise ». **[AVOCAT]** |
| **SFMU** | 6 | Mentions légales : contenus propriété exclusive de la SFMU ; « toute reproduction ou copie, totale ou partielle, sans le consentement de l'auteur […] est illicite ». | Autorisation nécessaire pour reprendre le texte. |
| SRLF, GIHP, autres (30) | 34 | Non trouvées en ligne lors de cet audit. | À vérifier une par une ; par défaut, « tous droits réservés ». |

Si un document est publié sous licence Creative Commons **CC BY-NC-ND**, deux
clauses posent problème : **NC** (pas d'usage commercial) et **ND** (pas
d'adaptation ni de traduction). Une licence **CC BY** permettrait l'usage
commercial avec attribution. Vérifier la licence imprimée sur chaque article.

## 4. Constat sur nos fiches

**Mesure complète** (script `scripts/juridique/mesure_reprises.py`, rapport
détaillé fiche par fiche : `docs/juridique/MESURE_REPRISES.md`). Les 158
fiches en ligne ont été comparées automatiquement à leur source officielle
(PDF ou page web). Pour une source web qui n'est qu'une page d'accueil du
document, la mesure sous-estime la reprise.

| Libellés de recommandation (5 705) | Part |
|---|---|
| Recopiés quasi mot pour mot | **10 %** (569) |
| Très proches de la source, à quelques mots près | **30 %** (1 705) |
| Reformulés | **60 %** (3 431) |

- **Bonne nouvelle** : les fiches ne sont pas des copies des documents. En
  moyenne, seule une petite partie du texte d'une fiche se retrouve à
  l'identique dans la source (12 % pour la SFAR, 22 % pour la SRLF). Une
  seule fiche dépasse 50 % (GIHP, agents antiplaquettaires).
- **Point de vigilance** : environ 4 libellés sur 10 restent recopiés ou très
  proches du texte de la source, par exemple « De principe, la fièvre est une
  contre-indication à l'APM ». C'est voulu pour la fidélité médicale, mais
  juridiquement il s'agit d'une reproduction, à couvrir par la courte
  citation (guillemets, source) ou par une autorisation.
- Le cahier des charges (§12.4) prévoit « reformulation éditoriale ; citation
  courte du libellé exact selon avis juridique » : la pratique est donc
  majoritairement conforme, avec un reste à traiter.
- Les fiches ne reproduisent ni l'argumentaire, ni les figures, ni la mise en
  page, ni les logos, et renvoient toujours au document officiel.
- **Registre juridique** : SFAR (110 fiches) en « en revue » ; autres sources
  non renseignées. Depuis le 01/10, aucune nouvelle fiche ne peut être
  publiée sans statut validé (verrou en base).

## 5. Améliorations déjà faites (01/10/2026)

1. **Verrou de publication** : une fiche ne peut être publiée sans source,
   date et statut juridique « validé ».
2. **Verrou des traductions** : une traduction ne peut être publiée que si le
   registre autorise la traduction (`translation_allowed = oui`) et que le
   statut est « validé ».
3. **Page « Notre démarche »** : recommandations en accès libre chez leurs
   auteurs ; pas de vente des documents ; l'abonnement ne sert pas à en tirer
   profit, il couvre l'hébergement, les développeurs et les outils d'IA ;
   indépendance ; volontaires remerciés.
4. **Procédure de retrait** publiée (page « Notre démarche » et mentions
   légales) : demande traitée en priorité, retrait immédiat possible.
5. **Mentions légales** : les recommandations restent l'œuvre de leurs
   auteurs ; le site ne vend ni ne diffuse les documents originaux.
6. Pas de PDF, pas d'impression, pas d'export, filigrane, anti-extraction :
   le site ne permet pas de récupérer en masse le texte des sources.

## 6. Améliorations proposées, par priorité

### Priorité 1 — avant d'accélérer la communication
1. **Remplir le registre juridique** (tableau de bord → Registre juridique) :
   - HAS : « validé », réutilisation commerciale « oui », en notant la
     condition (pas d'altération, source et date).
   - SFAR, SFMU et sociétés « tous droits réservés » : « en revue » tant que
     la politique de citation n'est pas appliquée ou qu'une autorisation n'est
     pas obtenue. **[AVOCAT]**
2. **Choisir une politique de citation** et l'appliquer aux fiches :
   - **Option A — reformulation** : les fiches reformulent chaque
     recommandation (même sens, même grade, autres mots) et ne citent le
     libellé exact que pour quelques phrases décisives, entre guillemets,
     avec la référence. C'est le plus sûr sans autorisation, mais il faut un
     contrôle médical de la fidélité.
   - **Option B — autorisation** : demander à chaque société (et à Elsevier
     si nécessaire) une autorisation écrite de reprendre les libellés courts
     des recommandations, avec renvoi vers leur site (modèle au §8).
   - **Option C — mixte** (recommandée) : demander l'autorisation à la SFAR
     (110 fiches) et, pour les autres sources, reformuler les libellés
     recopiés (liste fiche par fiche dans `MESURE_REPRISES.md`, en
     commençant par les fiches les plus proches) ou les présenter comme
     citations courtes, entre guillemets. **[AVOCAT]**
3. **Traductions anglaises** : ne pas les publier tant qu'aucune
   autorisation écrite de traduction n'existe (verrou en place).

### Priorité 2
4. **Mention de citation sous chaque fiche** : « Libellés des
   recommandations cités d'après [société], [titre], [année], [revue] — texte
   intégral : [lien]. Les recommandations restent la propriété de leurs
   auteurs. » (à adapter selon l'option choisie).
5. **HAS** : afficher sur chaque fiche HAS la date de dernière mise à jour de
   la page HAS (condition de réutilisation).
6. **Tableaux** : vérifier qu'aucun tableau n'est reproduit à l'identique
   (structure, ordre des colonnes) ; sinon le réorganiser.
7. **Abonnement** : garder une formulation exacte. « Ne sert pas à tirer
   profit des recommandations » est juste tant que les recettes servent
   réellement au site. Ne pas écrire « association à but non lucratif »
   (Hippocampus Consulting est une société commerciale). **[AVOCAT]**

### Priorité 3
8. **Assistant de recherche** : avant toute ouverture aux abonnés, avis
   réglementaire écrit (règlement 2017/745, §12.6) et mention IA (règlement
   européen sur l'IA, §12.5). Il reste réservé à l'équipe tant que
   `ASSISTANT_PUBLIC` n'est pas activé.
9. **Assurance** : vérifier que la responsabilité civile professionnelle
   couvre l'activité d'éditeur en ligne de contenus médicaux, y compris le
   risque de contrefaçon.
10. **Revue annuelle** du registre et des conditions des sources.

## 7. Ce qu'il faut demander à l'avocat

1. La reprise systématique des libellés courts des recommandations (avec
   grade, source et lien) relève-t-elle de la courte citation, dans un
   service payant ?
2. Qui détient les droits : la SFAR ou Elsevier (*AFAR*, *ACCPM*) ?
3. Formulation sûre du message sur l'abonnement (pas de profit sur les
   recommandations) pour une société commerciale.
4. Validation du modèle de demande d'autorisation (§8).
5. Assistant de recherche : statut au regard du règlement sur les dispositifs
   médicaux.

## 8. Modèle de demande d'autorisation (à faire relire)

> Objet : demande d'autorisation — citation de vos recommandations sur
> medical-guidelines.net
>
> Madame, Monsieur,
>
> Je suis le Dr Ahmed Ben Lallahom, éditeur de medical-guidelines.net
> (Hippocampus Consulting, SIREN 999 259 252). Le site propose aux
> professionnels de santé des fiches de synthèse indépendantes des
> recommandations françaises, lisibles sur téléphone, qui renvoient
> systématiquement au texte officiel sur votre site.
>
> Nous ne diffusons ni vos documents, ni vos figures, ni vos logos. Les
> fiches citent le libellé court de chaque recommandation avec son grade,
> afin de ne pas en altérer le sens. L'abonnement des membres ne sert pas à
> tirer profit de vos recommandations : il couvre l'hébergement, le
> développement et les outils d'intelligence artificielle du site.
>
> Nous sollicitons votre autorisation de citer ainsi les libellés de vos
> recommandations, avec la mention de votre société, de la référence complète
> et un lien vers votre site. Toute demande de modification ou de retrait
> serait traitée immédiatement.
>
> Nous restons à votre disposition pour vous présenter le site.
>
> Dr Ahmed Ben Lallahom — contact@medical-guidelines.net

## Sources consultées

- HAS, mentions légales : https://www.has-sante.fr/jcms/c_518191/en/mentions-legales
- SFAR, mentions légales : https://sfar.org/mentions-legales-credits/
- SFMU, mentions légales : https://www.sfmu.org/fr/mentions-legales/
- Code de la propriété intellectuelle, art. L122-5 : https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000037388886/
- Réutilisation des informations publiques (CRPA, art. L321-1 s.) : https://www.legifrance.gouv.fr/codes/section_lc/LEGITEXT000031366350/LEGISCTA000031367750/
- *Anaesthesia Critical Care & Pain Medicine*, options de licence : https://www.sciencedirect.com/journal/anaesthesia-critical-care-and-pain-medicine
