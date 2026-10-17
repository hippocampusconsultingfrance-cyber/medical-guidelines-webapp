import Mediation from "../mediation";
import { CGV_VERSION } from "@/lib/stripe";

// CGV rédigées d'après le cahier des charges V4.5 (§10.3), validées par le
// conseil juridique du porteur de projet (septembre 2026). Le médiateur de
// la consommation est renseigné dans lib/legal.ts ; toute modification du
// texte s'accompagne d'une nouvelle CGV_VERSION (lib/stripe.ts), enregistrée
// avec chaque souscription. Version du 03/10/2026 : le §2 précise ce que
// rémunère l'abonnement (le service, pas les documents des sociétés savantes).
// Révision 2 du 03/10/2026 : RCS et téléphone du vendeur, suppression
// immédiate des justificatifs, information avant renouvellement, bouton de
// résiliation.
// Texte français (seul à faire foi).
export default function CgvFr() {
  const h2 = "mt-8 text-lg font-semibold text-slate-900";
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">Conditions Générales de Vente</h1>
      <p className="mt-2 text-slate-500">
        Version du {CGV_VERSION.slice(0, 10).split("-").reverse().join("/")}
        {CGV_VERSION.length > 10 ? ` (révision ${CGV_VERSION.slice(11)})` : ""}.
      </p>

      <h2 className={h2}>1. Vendeur</h2>
      <p className="mt-2">
        Hippocampus Consulting, SARL au capital de 1 000 €, 6 rue d&apos;Armaillé, 75017 Paris,
        RCS Paris 999 259 252, TVA intracommunautaire FR43 999 259 252, éditrice du site medical-guidelines.net. Téléphone : +33 9 72 15 24 13. Contact :
        contact@medical-guidelines.net.
      </p>

      <h2 className={h2}>2. Offre</h2>
      <p className="mt-2">
        L&apos;abonnement PREMIUM donne accès, en consultation en ligne uniquement, à toutes les
        fiches de synthèse de la spécialité choisie à l&apos;inscription, pendant la durée de
        l&apos;abonnement. Aucun téléchargement, export ni impression n&apos;est proposé. Les fiches
        sont des synthèses indépendantes qui ne remplacent ni les recommandations officielles ni
        le jugement clinique (voir les{" "}
        <a href="/cgu" className="underline">
          conditions générales d&apos;utilisation
        </a>
        ).
      </p>
      <p className="mt-2">
        L&apos;abonnement rémunère le service : rédaction et relecture médicale des synthèses,
        outils de recherche, alertes et hébergement. Les documents officiels des recommandations
        ne sont ni vendus ni diffusés par le site : ils restent l&apos;œuvre et la propriété de
        leurs auteurs, en accès libre sur leurs sites, vers lesquels chaque fiche renvoie.
      </p>

      <h2 className={h2}>3. Prix</h2>
      <p className="mt-2">
        50 € toutes taxes comprises par an, dont TVA française au taux de 20 % (soit
        41,67 € hors taxes). Le prix payé, les éventuelles réductions et la date de
        renouvellement sont indiqués avant le paiement ; la facture mentionne le montant de la
        TVA.
      </p>

      <h2 className={h2}>4. Réductions</h2>
      <p className="mt-2">
        Offre membres fondateurs : −30 % sur la première année pour les 100 premiers abonnés.
        Tarif professionnel de santé en formation (étudiants en médecine ou paramédicaux,
        internes, résidents, docteurs juniors) : −30 % sur la première année, sur présentation
        d&apos;une attestation d&apos;inscription de l&apos;année universitaire en cours, validée
        par l&apos;éditeur. Une fois le justificatif validé, la réduction, personnelle et à usage
        unique, est appliquée automatiquement au paiement. Un nouveau justificatif est demandé à
        chaque renouvellement. Les réductions ne sont pas cumulables.
        Le justificatif n&apos;est consulté que par l&apos;éditeur et il est supprimé dès la décision
        prise ; seuls le statut déclaré, l&apos;année universitaire et la décision sont conservés.
      </p>

      <h2 className={h2}>5. Durée, renouvellement et résiliation</h2>
      <p className="mt-2">
        L&apos;abonnement est conclu pour un an et se renouvelle automatiquement au tarif alors en
        vigueur. L&apos;abonné est informé par e-mail de l&apos;échéance et de la possibilité de ne pas
        renouveler entre un et trois mois avant celle-ci (article L215-1 du code de la consommation).
        Il peut résilier à tout moment depuis la page « Abonnement », bouton « Résilier mon
        abonnement » ;
        l&apos;accès est maintenu jusqu&apos;à la fin de l&apos;année payée, puis le compte redevient
        gratuit, sans perte des fiches débloquées avec les crédits gratuits. En cas d&apos;évolution
        du tarif, l&apos;abonné est informé par e-mail au moins 30 jours avant le renouvellement,
        avec la possibilité de résilier.
      </p>

      <h2 className={h2}>6. Paiement et facture</h2>
      <p className="mt-2">
        Le paiement est effectué par carte bancaire via Stripe, prestataire de paiement ;
        l&apos;éditeur n&apos;a pas accès aux données de carte. Une facture est émise à chaque
        paiement et envoyée par e-mail.
      </p>

      <h2 className={h2}>7. Droit de rétractation</h2>
      <p className="mt-2">
        Le consommateur dispose en principe d&apos;un délai de 14 jours pour se rétracter.
        L&apos;accès au contenu étant immédiat, l&apos;abonné demande expressément, lors de la
        souscription, l&apos;exécution immédiate du service et renonce à son droit de
        rétractation dès le début de l&apos;accès ; cette demande est enregistrée avec la date de
        la souscription et la version des présentes conditions.
      </p>

      <h2 className={h2}>8. Responsabilité</h2>
      <p className="mt-2">
        L&apos;éditeur apporte le plus grand soin à la fidélité des fiches à leurs sources, sans
        garantir l&apos;absence d&apos;erreur. Toute erreur peut être signalée depuis la fiche. La
        responsabilité de l&apos;éditeur ne saurait être engagée du fait d&apos;une décision
        clinique, qui relève du seul professionnel de santé.
      </p>

      <h2 className={h2}>9. Médiation et droit applicable</h2>
      <Mediation />
      <p className="mt-2">Les présentes conditions sont soumises au droit français.</p>
    </div>
  );
}
