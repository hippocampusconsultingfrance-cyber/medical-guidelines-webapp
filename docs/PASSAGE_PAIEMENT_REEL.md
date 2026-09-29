# Passage au paiement réel — liste et vérifications du jour J

Le site encaisse aujourd'hui en **mode test** : aucun débit réel, et le
bouton « Payer » n'est proposé qu'à l'équipe éditoriale (les membres voient
« Les abonnements ouvrent bientôt »). Le passage au réel se fait en changeant
trois variables dans Vercel. Le médiateur (CM2C) étant renseigné, la vente
s'ouvre à tous dès que les clés réelles sont en place : ne les mettre
qu'après la relecture du juriste (A1) et le réglage de la TVA (A3).

Qui fait quoi : **Vous** (porteur de projet), **Claude** (code et
vérifications), **Juriste**, **Expert-comptable**.

---

## A. Juridique et comptable — avant tout (Vous, avec vos conseils)

### A1. Faire relire par un juriste
Documents à transmettre : pages `/cgv`, `/cgu`, `/confidentialite` et
`/mentions-legales` du site. Points à lui soumettre explicitement :

- [ ] **Renonciation au droit de rétractation** (art. L221-28 13° du code de
      la consommation) : double case à cocher avant paiement, enregistrée
      avec la date et la version des CGV. Le libellé suffit-il ?
- [ ] **Reconduction tacite annuelle** (art. L215-1) : le consommateur doit
      être informé par écrit, 1 à 3 mois avant l'échéance, de sa faculté de
      ne pas reconduire. Stripe peut envoyer ce rappel automatiquement (voir
      B2) : le contenu de cet e-mail convient-il ?
- [ ] **Clientèle mixte** : médecins libéraux (professionnels) et internes
      (consommateurs). Faut-il distinguer les conditions ?
- [ ] **Responsabilité** : clause sur les synthèses médicales (CGV §8, CGU).
- [ ] **Mentions légales** : ajouter le numéro RCS et le numéro de TVA
      intracommunautaire s'ils existent.
- [ ] **Confidentialité** : la section sur Stripe et la conservation des
      factures (10 ans) a été ajoutée ; à valider.

### A2. Adhérer à un médiateur de la consommation
Obligatoire avant toute vente à un consommateur (art. L612-1). Choisir un
médiateur référencé par la CECMC (liste sur economie.gouv.fr, rubrique
« médiation de la consommation »). Adhésion payante, de quelques dizaines à
quelques centaines d'euros par an selon l'organisme.

- [x] Adhésion faite : **CM2C** (49 rue de Ponthieu, 75008 Paris). Mention
      officielle affichée dans les CGV (§9) et les mentions légales.

### A3. TVA — avec l'expert-comptable
- [ ] **Régime de TVA** de la société :
      - franchise en base (art. 293 B du CGI) : pas de TVA facturée, mention
        obligatoire sur les factures ;
      - ou TVA à 20 % (service électronique vendu en France), incluse dans les
        50 € TTC.
- [ ] **Clients dans d'autres pays de l'UE** : au-delà de 10 000 € de ventes
      par an aux particuliers européens, TVA du pays du client (guichet
      unique OSS). Stripe Tax peut la calculer (option B8).
- [ ] **Numéro de TVA intracommunautaire** (factures et mentions légales).

---

## B. Stripe en mode réel (Vous, dans le tableau de bord Stripe)

Basculer le tableau de bord sur **mode réel** : interrupteur « Mode test » en
haut à droite, désactivé.

- [ ] **B1. Activer le compte** (Paramètres → Détails de l'entreprise) :
      société, SIREN, représentant légal et pièce d'identité, **IBAN** pour
      les virements. Libellé sur les relevés bancaires :
      `MEDICAL-GUIDELINES`.
- [ ] **B2. E-mails aux clients** (Paramètres → E-mails clients) : activer
      les reçus de paiement, les factures et les **rappels de
      renouvellement** pour les abonnements annuels (30 jours avant ; voir
      A1). Dans Paramètres → Facturation → Abonnements, activer les
      nouvelles tentatives automatiques en cas d'échec de paiement.
- [ ] **B3. Factures** (Paramètres → Facturation → Factures) : raison
      sociale, adresse, SIREN, TVA intracommunautaire, et mention « TVA non
      applicable, art. 293 B du CGI » si franchise.
- [ ] **B4. Produit et prix** (Catalogue de produits → Ajouter un produit) :
      « Abonnement PREMIUM », **50,00 € EUR**, récurrent **annuel**,
      comportement fiscal « TVA incluse ». Copier l'identifiant du prix
      (`price_…`).
- [ ] **B5. Code FONDATEURS** : Catalogue de produits → Coupons → Nouveau
      coupon : **30 %**, durée **une fois**. Puis sur ce coupon, ajouter un
      code promotionnel `FONDATEURS`, limité à **100** utilisations.
- [ ] **B6. Portail client** (Paramètres → Facturation → Portail client) :
      activer l'historique des factures, la mise à jour du moyen de paiement
      et la **résiliation en fin de période**. Pas de changement d'offre.
      Enregistrer.
- [ ] **B7. Webhook** (Développeurs → Webhooks → Ajouter un point de
      terminaison) :
      - URL : `https://www.medical-guidelines.net/api/stripe/webhook`
      - événements : `checkout.session.completed`,
        `customer.subscription.created`, `customer.subscription.updated`,
        `customer.subscription.deleted`
      - copier le **secret de signature** (`whsec_…`).
- [ ] **B8. Stripe Tax** (optionnel, selon A3) : Paramètres → Taxes →
      renseigner l'adresse et l'immatriculation TVA France.
- [ ] **B9. Clé secrète réelle** (Développeurs → Clés API) : révéler la clé
      `sk_live_…`. Ne jamais l'envoyer par message ni en capture d'écran.

---

## C. Jour J — bascule (Vous et Claude)

1. **Claude** : date la nouvelle version des CGV (`CGV_VERSION` dans
   `src/lib/stripe.ts`) et intègre les corrections du juriste. Le médiateur
   (CM2C) est déjà renseigné : **la vente s'ouvre dès que les clés réelles
   sont en place**. Mise en ligne par une PR, avec les
   contrôles automatiques au vert.
2. **Vous**, dans Vercel → projet → Settings → Environment Variables, en
   cochant **uniquement « Production »** pour chaque variable :
   | Variable | Valeur |
   |---|---|
   | `STRIPE_SECRET_KEY` | `sk_live_…` (B9) |
   | `STRIPE_PRICE_ID` | `price_…` réel (B4) |
   | `STRIPE_WEBHOOK_SECRET` | `whsec_…` réel (B7) |
   | `STRIPE_TAX` | `1` si Stripe Tax est activé (B8), sinon ne pas créer |

   Garder les valeurs de test pour « Preview », afin que les essais restent
   gratuits. Puis Deployments → dernier déploiement → ⋯ → **Redeploy**.
3. **Claude** : supprime de la base les abonnements créés en mode test
   (y compris celui du compte d'essai), avec votre accord. Requête
   exécutée dans Supabase → SQL Editor :
   ```sql
   -- À lancer AVANT le premier paiement réel : il n'existe alors que des
   -- abonnements de test.
   select user_id, status, stripe_subscription_id from public.subscriptions;
   delete from public.subscriptions where stripe_subscription_id is not null;
   ```

## D. Jour J — vérifications, dans cet ordre

- [ ] **D1.** `https://www.medical-guidelines.net/abonnement/verification`
      (compte administrateur) : tous les points en ✓, bandeau vert
      « Paiement réel prêt ».
- [ ] **D2. Premier achat réel, par vous**, avec votre carte et le code
      `FONDATEURS` (35 €) :
      - retour sur le site avec le message « Merci » ;
      - « Votre abonnement PREMIUM est actif » sur `/abonnement` ;
      - une fiche jamais débloquée est lisible ;
      - Stripe → Développeurs → Webhooks → le point de terminaison : les 4
        derniers envois sont en **200** ;
      - reçu et facture reçus par e-mail, avec les bonnes mentions (B3).
- [ ] **D3. Portail** : bouton « Factures, moyen de paiement, résiliation »
      → la facture est visible → **résilier** → retour sur le site :
      « actif jusqu'au … (résiliation enregistrée) », accès maintenu.
- [ ] **D4. Remboursement** de cet achat d'essai : Stripe → Paiements → le
      paiement → Rembourser.
- [ ] **D5. Compte membre ordinaire** (non éditorial) : `/abonnement`
      affiche le prix et le bouton « Payer et activer PREMIUM ».
- [ ] **D6. Lendemain** : aucune erreur dans Stripe → Webhooks ; la
      surveillance GitHub (onglet Actions) est verte.

## E. En cas de problème

- **Fermer la vente sans rien casser** : dans Vercel (Production),
  supprimer `STRIPE_PRICE_ID` puis Redeploy. Les membres revoient « ouvre
  bientôt » ; les abonnements déjà payés continuent d'être enregistrés
  (webhook et clé inchangés).
- **Ne pas remettre les clés de test en production** une fois des
  abonnements réels vendus : les renouvellements ne seraient plus
  enregistrés.
- Un paiement débité sans PREMIUM activé : Stripe → Webhooks → renvoyer
  l'événement `checkout.session.completed` ; sinon prévenir Claude.

---

### Garde-fous déjà en place dans le code

| Situation | Effet |
|---|---|
| Clé de test (`sk_test_…`) | Paiement réservé à l'équipe éditoriale ; les membres voient « ouvre bientôt ». |
| Clé réelle, médiateur non renseigné | Vente fermée à tous. |
| Clé réelle et médiateur renseigné | Vente ouverte. |
| Client Stripe créé en test, paiement en réel | Nouveau client créé automatiquement, sans erreur. |
| Page `/abonnement/verification` | Contrôle en lecture seule : compte, prix, webhook, portail, code FONDATEURS, TVA, médiateur. |
