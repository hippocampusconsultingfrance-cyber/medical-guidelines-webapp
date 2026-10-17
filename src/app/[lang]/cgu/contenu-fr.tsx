import { CGU_VERSION } from "@/lib/legal";
import Mediation from "../mediation";

// Texte français (seul à faire foi).
export default function CguFr() {
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">
        Conditions Générales d&apos;Utilisation
      </h1>
      <p className="mt-2 text-slate-500">Version du {CGU_VERSION.split("-").reverse().join("/")}.</p>

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
        Le compte gratuit donne accès à 5 fiches complètes au total, à vie,
        sans carte bancaire, choisies dans la spécialité indiquée à
        l&apos;inscription ou, tant que le catalogue couvre encore peu cette
        spécialité (moins de 20 fiches publiées), parmi toutes les fiches
        publiées. L&apos;abonnement PREMIUM (toutes les fiches de la
        spécialité choisie), proposé pour les spécialités couvertes par le
        catalogue, est au prix de 50 € TTC par an, payable
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
        lire sous forme de synthèses rédigées par l&apos;éditeur et relues par son
        équipe médicale (la date de relecture figure sur chaque fiche), de
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
        6. Suppression, suspension et fermeture du compte
      </h2>
      <p className="mt-2">
        L&apos;utilisateur peut supprimer son compte à tout moment depuis la
        page « Mon compte » ; ses données personnelles sont alors effacées
        immédiatement, sous réserve des obligations légales de conservation
        (pièces comptables).
      </p>
      <p className="mt-2">
        L&apos;éditeur peut suspendre l&apos;accès d&apos;un compte, après
        avoir prévenu l&apos;utilisateur par e-mail et l&apos;avoir invité à
        s&apos;expliquer, en cas de manquement aux présentes conditions :
        extraction ou copie systématique du contenu, partage ou prêt des
        identifiants, contournement des mesures de protection, fausse
        déclaration de qualité professionnelle. En cas de manquement grave ou
        répété, le compte peut être fermé ; un abonnement en cours est alors
        remboursé au prorata de la période restante, sauf fraude. La
        suspension automatique et temporaire de la lecture en cas de rythme
        anormal (article 3) n&apos;est pas une sanction.
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        7. Responsabilité et disponibilité
      </h2>
      <p className="mt-2">
        Les fiches et l&apos;assistant de recherche sont des outils d&apos;aide
        à la lecture destinés à des professionnels de santé. Ils ne
        remplacent ni le texte officiel des recommandations, ni l&apos;examen
        du patient, ni le jugement clinique : toute décision diagnostique ou
        thérapeutique relève de la seule responsabilité du professionnel qui
        la prend. L&apos;éditeur apporte le plus grand soin à la fidélité des
        fiches à leurs sources et corrige toute erreur signalée (journal des
        corrections public), sans garantir l&apos;absence d&apos;erreur ni
        l&apos;exhaustivité du contenu.
      </p>
      <p className="mt-2">
        L&apos;éditeur s&apos;efforce d&apos;assurer l&apos;accès au site en
        permanence, sans obligation de résultat : des interruptions pour
        maintenance, mise à jour ou incident technique peuvent survenir. Les
        liens vers les sites des sociétés savantes et d&apos;autres sites
        relèvent de leurs éditeurs respectifs.
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        8. Assistant de recherche (intelligence artificielle)
      </h2>
      <p className="mt-2">
        L&apos;assistant de recherche, réservé aux abonnés PREMIUM, utilise un
        modèle d&apos;intelligence artificielle pour retrouver dans les fiches
        les passages qui répondent à une question. Ses réponses sont produites
        automatiquement : elles peuvent contenir des erreurs ou des oublis, et
        chaque passage doit être vérifié dans la fiche et dans la source
        officielle citée avant toute décision. L&apos;assistant ne donne aucun
        avis sur un patient. Il est interdit d&apos;y saisir une donnée
        permettant d&apos;identifier un patient. Les questions ne sont pas
        conservées par le site ; leur traitement est décrit dans la politique
        de confidentialité.
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        9. Modification des conditions
      </h2>
      <p className="mt-2">
        L&apos;éditeur peut modifier les présentes conditions, notamment pour
        tenir compte d&apos;une évolution du service ou de la réglementation.
        Toute modification importante est notifiée par e-mail au moins 30
        jours avant son entrée en vigueur. L&apos;utilisateur qui ne
        l&apos;accepte pas peut supprimer son compte avant cette date ; la
        poursuite de l&apos;utilisation du site après cette date vaut
        acceptation. La version acceptée lors de l&apos;inscription est
        enregistrée.
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        10. Droit applicable, litiges et médiation
      </h2>
      <p className="mt-2">
        Les présentes CGU sont soumises au droit français. En cas de
        différend, l&apos;utilisateur est invité à contacter d&apos;abord
        l&apos;éditeur à contact@medical-guidelines.net. À défaut
        d&apos;accord amiable, le litige est porté devant les tribunaux
        compétents de Paris lorsque l&apos;utilisateur agit à titre
        professionnel ; l&apos;utilisateur consommateur peut saisir la
        juridiction de son choix dans les conditions prévues par la loi et
        recourir gratuitement à la médiation de la consommation :
      </p>
      <Mediation />
    </div>
  );
}
