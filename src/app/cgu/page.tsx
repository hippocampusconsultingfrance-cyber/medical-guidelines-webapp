import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Conditions Générales d'Utilisation — medical-guidelines.net",
};

export default function CguPage() {
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">
        Conditions Générales d&apos;Utilisation
      </h1>
      <p className="mt-2 text-slate-500">Dernière mise à jour : 3 octobre 2026.</p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        1. Objet et accès au service
      </h2>
      <p className="mt-2">
        Medical Guidelines est un site de fiches de synthèse des
        recommandations professionnelles françaises de plusieurs spécialités
        (anesthésie-réanimation, médecine critique, médecine d&apos;urgence,
        pédiatrie…). L&apos;accès au contenu est réservé aux
        professionnels de santé et étudiants des filières médicales et
        paramédicales, sous réserve de la création d&apos;un compte.
        Le compte gratuit donne accès, dans la spécialité choisie à
        l&apos;inscription, à 5 fiches complètes au total, à vie, sans carte
        bancaire. L&apos;abonnement PREMIUM (toutes les fiches de la
        spécialité choisie) est proposé au prix de 50 € TTC par an, payable
        annuellement d&apos;avance ; il se renouvelle automatiquement à la
        date anniversaire et peut être résilié à tout moment, l&apos;accès
        étant maintenu jusqu&apos;à la fin de l&apos;année payée. Le tarif de
        l&apos;année en cours est garanti ; toute hausse ne s&apos;applique
        qu&apos;au renouvellement, après information au moins 30 jours à
        l&apos;avance avec lien de résiliation. Les conditions de
        souscription (réductions, droit de rétractation, facturation) sont
        précisées dans les conditions générales de vente, distinctes des
        présentes conditions et acceptées à chaque souscription.
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        2. Nature du service et du contenu — absence de valeur médicale opposable
      </h2>
      <p className="mt-2">
        Medical Guidelines est un service d&apos;aide à la lecture des
        recommandations professionnelles : il permet de les retrouver, de les
        lire sous forme de synthèses rédigées et relues par l&apos;éditeur, de
        les comparer et d&apos;être alerté de leurs mises à jour. Les documents
        officiels des recommandations ne sont ni vendus ni diffusés par le
        site : ils restent l&apos;œuvre et la propriété de leurs auteurs, en
        accès libre sur leurs sites, vers lesquels chaque fiche renvoie.
        L&apos;abonnement rémunère le service : rédaction et relecture médicale
        des synthèses, outils de recherche, alertes et hébergement.
      </p>
      <p className="mt-2">
        Les fiches publiées sont des synthèses indépendantes, produites à
        titre d&apos;aide-mémoire, à partir des documents publiés par les
        sociétés savantes. Elles ne remplacent pas la lecture du texte
        intégral des recommandations officielles et n&apos;engagent pas la
        responsabilité des sociétés savantes concernées. Aucun logo, marque ou
        élément protégé d&apos;une société savante n&apos;est reproduit sur ce
        site. En cas de doute clinique, l&apos;utilisateur doit se référer au
        texte intégral de la recommandation ou à un avis spécialisé.
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        3. Propriété intellectuelle et usage autorisé
      </h2>
      <p className="mt-2">
        Les recommandations citées (libellés, grades, tableaux, figures)
        appartiennent à leurs auteurs et à leurs éditeurs ; les fiches les
        citent avec leur référence et le lien vers le texte officiel. Les
        synthèses, leur sélection, leur organisation, la base de données et le
        logiciel du site appartiennent à l&apos;éditeur (articles L341-1 et
        suivants du code de la propriété intellectuelle pour la base de
        données).
      </p>
      <p className="mt-2">
        Le compte donne un droit d&apos;accès personnel, pour un usage
        professionnel. Sont interdits : la copie ou l&apos;extraction
        systématique des fiches, y compris par un robot ou un programme ; la
        revente ou la diffusion du contenu ; le contournement des mesures de
        protection du site. En cas de lecture à un rythme anormal, la lecture
        est suspendue automatiquement pour une durée limitée, et un
        administrateur en est prévenu (voir la{" "}
        <a href="/confidentialite" className="underline">
          politique de confidentialité
        </a>
        ).
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        4. Compte utilisateur
      </h2>
      <p className="mt-2">
        La création d&apos;un compte nécessite la communication de données
        d&apos;identification (nom, prénom, téléphone, email, profession) et
        la validation de l&apos;adresse email. Le compte est personnel : ses
        identifiants ne doivent être ni partagés ni prêtés. L&apos;utilisateur
        est responsable de la confidentialité de son mot de passe et de toute
        activité effectuée depuis son compte.
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        5. Données personnelles
      </h2>
      <p className="mt-2">
        Le traitement des données personnelles est décrit intégralement dans
        notre{" "}
        <a href="/confidentialite" className="underline">
          Politique de Confidentialité
        </a>
        , document distinct que nous vous invitons à lire avant toute
        inscription. Le consentement au partage de données avec des
        partenaires commerciaux est distinct de l&apos;acceptation des
        présentes CGU et n&apos;est jamais requis pour créer un compte.
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        6. Résiliation
      </h2>
      <p className="mt-2">
        L&apos;utilisateur peut supprimer son compte à tout moment. La
        suppression entraîne l&apos;effacement des données personnelles
        associées, sous réserve des obligations légales de conservation.
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        7. Droit applicable
      </h2>
      <p className="mt-2">
        Les présentes CGU sont soumises au droit français.
      </p>
    </div>
  );
}
