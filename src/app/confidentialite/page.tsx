import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Politique de confidentialité — medical-guidelines.net",
};

export default function ConfidentialitePage() {
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">
        Politique de Confidentialité
      </h1>
      <p className="mt-2 text-slate-500">
        Dernière mise à jour : 3 octobre 2026. Conforme au Règlement Général sur la
        Protection des Données (RGPD).
      </p>

      <div className="mt-6 rounded-md border-l-4 border-[#2BB5A6] bg-[#EEF6FB] p-4">
        <p className="font-medium text-slate-900">En résumé</p>
        <ul className="mt-2 list-disc space-y-1 pl-5">
          <li>
            Nous collectons votre nom, prénom, téléphone, email et profession
            pour créer et sécuriser votre compte.
          </li>
          <li>
            Ces données ne sont <strong>jamais</strong> partagées avec des
            partenaires commerciaux, sauf si vous cochez explicitement et
            séparément la case correspondante lors de l&apos;inscription (ou
            plus tard depuis la page « Mon compte »).
          </li>
          <li>
            Vous pouvez à tout moment consulter, corriger, exporter ou faire
            supprimer vos données.
          </li>
        </ul>
      </div>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        1. Responsable du traitement
      </h2>
      <p className="mt-2">
        Le responsable du traitement des données collectées sur ce site est
        Hippocampus Consulting, SARL au capital de 1 000 €, 6 rue
        d&apos;Armaillé, 75017 Paris (SIREN 999 259 252), joignable à
        l&apos;adresse contact@medical-guidelines.net. Voir aussi les{" "}
        <a href="/mentions-legales" className="underline">
          mentions légales
        </a>
        .
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        2. Données collectées
      </h2>
      <p className="mt-2">À l&apos;inscription : nom, prénom, numéro de téléphone, adresse
        email, profession (précisée si &laquo;&nbsp;Autre&nbsp;&raquo;), spécialité consultée,
        puis un identifiant et un mot de passe (stocké de façon chiffrée,
        jamais en clair) lors de la finalisation du compte.
      </p>
      <p className="mt-2">
        Pendant l&apos;utilisation : fiches débloquées, fiches mises en
        favori, historique des fiches consultées, sociétés savantes suivies
        et préférence d&apos;alerte e-mail, ainsi que la liste des alertes
        envoyées. En cas d&apos;abonnement PREMIUM : statut et dates de
        l&apos;abonnement, date d&apos;acceptation des conditions de vente et
        de la renonciation au droit de rétractation, identifiants Stripe du
        client et de l&apos;abonnement. Les données de carte bancaire sont
        saisies chez Stripe et ne nous sont jamais transmises. Ces données servent à afficher votre espace personnel
        (reprendre la lecture, favoris, mises à jour de vos fiches) et à
        vous envoyer les alertes. Le classement « les plus consultées » ne
        repose que sur des nombres de lecteurs agrégés : il n&apos;affiche
        jamais ce qu&apos;a lu une personne.
      </p>
      <p className="mt-2">
        Sécurité du contenu : chaque ouverture d&apos;une fiche est journalisée (compte, fiche, date et
        heure) pendant 30 jours, afin de détecter une extraction automatisée ; un rythme anormal suspend
        temporairement la lecture et prévient un administrateur. Tarif professionnel en formation : le justificatif
        déposé n&apos;est consulté que par un administrateur et il est supprimé dès la décision prise ; seuls
        le statut déclaré, l&apos;année universitaire et la décision sont conservés.
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        3. Finalités et bases légales
      </h2>
      <p className="mt-2">
        <strong>3.1. Fonctionnement du compte (obligatoire).</strong> Vos
        données sont utilisées pour créer votre compte, vous authentifier,
        assurer la sécurité du site et, le cas échéant, gérer votre
        abonnement. Base légale : exécution du contrat qui vous lie à
        Medical Guidelines lorsque vous créez un compte (article 6.1.b du
        RGPD).
      </p>
      <p className="mt-2">
        <strong>3.2. Partage avec des partenaires commerciaux (facultatif).</strong>{" "}
        Si — et seulement si — vous avez coché la case dédiée lors de
        l&apos;inscription, vos données (nom, email, profession) peuvent être
        transmises à des entreprises partenaires proposant des produits ou
        services liés à votre activité professionnelle. Base légale :
        consentement explicite (article 6.1.a du RGPD), recueilli
        séparément de l&apos;acceptation des CGU, jamais pré-coché, et
        retirable à tout moment sans affecter votre accès au service.
      </p>
      <p className="mt-2">
        <strong>3.3. Statistiques anonymes communiquées aux auteurs.</strong>{" "}
        Nous pouvons communiquer aux sociétés savantes et aux auteurs des
        recommandations des statistiques anonymes et agrégées sur la
        consultation de leurs recommandations (nombre de lecteurs par fiche,
        par mois et par spécialité), seulement au-delà de 10 lecteurs, et
        jamais l&apos;identité ni le parcours d&apos;un membre. Base légale :
        intérêt légitime de l&apos;éditeur à rendre compte aux auteurs de la
        diffusion de leurs recommandations (article 6.1.f du RGPD).
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        4. Durée de conservation
      </h2>
      <p className="mt-2">
        Vos données sont conservées tant que votre compte est actif, puis
        supprimées dans un délai de 12 mois après suppression du compte ou
        après 3 ans d&apos;inactivité, sauf obligation légale contraire. Les
        factures et les pièces relatives aux paiements sont conservées 10 ans
        (obligation comptable, article L123-22 du code de commerce).
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        5. Vos droits
      </h2>
      <p className="mt-2">
        Conformément au RGPD, vous disposez d&apos;un droit d&apos;accès, de
        rectification, d&apos;effacement, de limitation, de portabilité et
        d&apos;opposition sur vos données, ainsi que du droit de retirer à
        tout moment votre consentement au partage avec des partenaires
        (sans effet rétroactif et sans impact sur l&apos;accès au service).
        Vous pouvez exercer ces droits depuis la page{" "}
        <a href="/compte" className="underline">
          Mon compte
        </a>{" "}
        (modification de vos informations, retrait du consentement, export
        de vos données, suppression du compte) ou en contactant
        l&apos;éditeur du site. Vous disposez également du
        droit d&apos;introduire une réclamation auprès de la CNIL
        (www.cnil.fr).
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        6. Sécurité
      </h2>
      <p className="mt-2">
        Les mots de passe sont hachés et jamais stockés en clair. Les accès
        aux données sont restreints par des règles de sécurité au niveau de
        la base de données (chaque utilisateur ne peut voir que son propre
        profil).
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        7. Hébergement
      </h2>
      <p className="mt-2">
        La base de données (comptes et profils) est hébergée par Supabase
        Inc. dans l&apos;Union européenne (Francfort, Allemagne). Le site est
        servi par Vercel Inc. via son réseau mondial de distribution. Ces
        deux prestataires sont des sociétés établies aux États-Unis, qui
        agissent en tant que sous-traitants et encadrent les éventuels
        transferts hors de l&apos;Union européenne par les clauses
        contractuelles types de la Commission européenne et/ou le Data
        Privacy Framework UE–États-Unis.
      </p>
      <p className="mt-2">
        Les paiements de l&apos;abonnement PREMIUM sont traités par Stripe
        Payments Europe, Ltd. (Dublin, Irlande), prestataire de services de
        paiement, qui reçoit votre adresse e-mail, votre adresse de
        facturation et vos données de paiement, et émet les factures.
      </p>
      <p className="mt-2">
        Les e-mails de service (confirmation d&apos;inscription, mot de passe
        oublié) et les alertes e-mail (nouvelles recommandations des sociétés
        suivies, mises à jour de vos fiches, pour les abonnés PREMIUM qui les
        ont activées) sont envoyés par Resend, qui agit en tant que
        sous-traitant dans les mêmes conditions. Chaque alerte comporte un
        lien de désinscription ; les alertes se désactivent aussi depuis la
        page « Mon compte ».
      </p>
      <p className="mt-2">
        Deux e-mails de suivi peuvent aussi vous être adressés, une seule fois chacun : un rappel si
        votre inscription n&apos;est pas finalisée après 24 heures, et une information sur
        l&apos;abonnement lorsque vos crédits gratuits sont épuisés. Ils comportent un lien de
        désinscription, qui désactive aussi les alertes.
      </p>
      <p className="mt-2">
        La fréquentation du site est mesurée par Vercel Web Analytics, sans cookies ni
        identifiant persistant : seules des statistiques agrégées (pages vues, pays, type
        d&apos;appareil, site de provenance) sont produites. Les polices de caractères sont
        hébergées par le site lui-même.
      </p>
      <p className="mt-2">
        Les erreurs techniques du site sont transmises à Sentry (Functional Software, Inc.),
        hébergé dans l&apos;Union européenne (Allemagne), qui agit en tant que sous-traitant :
        message d&apos;erreur, page concernée et type de navigateur, sans adresse IP, cookies,
        identité ni contenu des fiches. Ces données servent uniquement à corriger les
        dysfonctionnements et sont conservées 90 jours au plus.
      </p>
      <p className="mt-2">
        <b>Suggestions des membres.</b> Lorsque vous envoyez une suggestion (bouton « Une idée ? »),
        nous conservons votre message, son type, la page d&apos;où il est envoyé, sa date et le lien
        avec votre compte, afin de le traiter et de vous en indiquer le suivi. Seule l&apos;équipe
        d&apos;administration y a accès. Le message est supprimé avec votre compte. N&apos;y indiquez
        aucune donnée concernant un patient.
      </p>
      <p className="mt-2">
        <b>Assistant de recherche (bêta).</b> Lorsque vous l&apos;utilisez, votre question et des
        extraits des fiches sont transmis à Anthropic (Anthropic PBC, États-Unis), qui agit en tant
        que sous-traitant pour produire la réponse, avec des transferts encadrés par les clauses
        contractuelles types de la Commission européenne. Ni la question ni la réponse ne sont
        conservées par le site : seuls la date et le nombre d&apos;extraits sont enregistrés, pour
        appliquer la limite quotidienne. Ne saisissez aucune donnée permettant d&apos;identifier un
        patient.
      </p>
      <p className="mt-2">
        Chaque changement de votre consentement au partage avec des
        partenaires est horodaté et conservé dans un historique consultable
        depuis la page « Mon compte ».
      </p>
    </div>
  );
}
