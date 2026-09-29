import type { Metadata } from "next";
import Mediation from "../mediation";
import { CGV_VERSION } from "@/lib/stripe";

export const metadata: Metadata = {
  title: "Conditions Générales de Vente — medical-guidelines.net",
};

// Projet de CGV rédigé d'après le cahier des charges V4.5 (§10.3). À faire
// valider par un conseil juridique avant la première vente. Le médiateur de
// la consommation est renseigné dans lib/legal.ts ; toute modification du
// texte s'accompagne d'une nouvelle CGV_VERSION (lib/stripe.ts), enregistrée
// avec chaque souscription.
export default function CgvPage() {
  const h2 = "mt-8 text-lg font-semibold text-slate-900";
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-semibold text-slate-900">Conditions Générales de Vente</h1>
      <p className="mt-2 text-slate-500">Version du {CGV_VERSION.split("-").reverse().join("/")}.</p>

      <h2 className={h2}>1. Vendeur</h2>
      <p className="mt-2">
        Hippocampus Consulting, SARL au capital de 1 000 €, 6 rue d&apos;Armaillé, 75017 Paris,
        SIREN 999 259 252, éditrice du site medical-guidelines.net. Contact :
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

      <h2 className={h2}>3. Prix</h2>
      <p className="mt-2">
        50 € toutes taxes comprises par an pour les consommateurs. La TVA applicable est
        calculée selon le pays et le statut de l&apos;acheteur (particulier ou professionnel
        disposant d&apos;un numéro de TVA). Le prix payé, les éventuelles réductions et la date de
        renouvellement sont indiqués avant le paiement.
      </p>

      <h2 className={h2}>4. Réductions</h2>
      <p className="mt-2">
        Offre membres fondateurs : −30 % sur la première année pour les 100 premiers abonnés.
        Tarif interne ou étudiant : −30 % sur la première année, sur présentation d&apos;une
        attestation d&apos;inscription de l&apos;année universitaire en cours, validée par
        l&apos;éditeur, qui adresse alors un code personnel à usage unique ; un nouveau
        justificatif est demandé à chaque renouvellement. Les réductions ne sont pas cumulables.
        Les justificatifs sont supprimés après décision, ou conservés un an au plus si
        nécessaire à la preuve.
      </p>

      <h2 className={h2}>5. Durée, renouvellement et résiliation</h2>
      <p className="mt-2">
        L&apos;abonnement est conclu pour un an et se renouvelle automatiquement au tarif alors en
        vigueur. L&apos;abonné peut le résilier à tout moment depuis la page « Abonnement » ;
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
