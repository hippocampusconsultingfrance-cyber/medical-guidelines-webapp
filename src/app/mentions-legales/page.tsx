import type { Metadata } from "next";
import Mediation from "../mediation";

export const metadata: Metadata = {
  title: "Mentions légales — Medical Guidelines",
};

export default function MentionsLegalesPage() {
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">Mentions légales</h1>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">Éditeur</h2>
      <p className="mt-2">
        Le site medical-guidelines.net est édité par Hippocampus Consulting,
        société à responsabilité limitée (SARL) au capital de 1 000 €.
      </p>
      <ul className="mt-2 list-disc pl-5">
        <li>Siège social : 6 rue d&apos;Armaillé, 75017 Paris, France</li>
        <li>RCS Paris 999 259 252 (SIREN 999 259 252)</li>
        <li>N° de TVA intracommunautaire : FR43 999 259 252</li>
        <li>
          Téléphone :{" "}
          <a href="tel:+33972152413" className="underline">
            +33 9 72 15 24 13
          </a>
        </li>
        <li>
          Contact :{" "}
          <a href="mailto:contact@medical-guidelines.net" className="underline">
            contact@medical-guidelines.net
          </a>
        </li>
      </ul>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        Directeur de la publication
      </h2>
      <p className="mt-2">Dr Ahmed Ben Lallahom.</p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">Hébergeur</h2>
      <p className="mt-2">
        Vercel Inc., 440 N Barranca Ave #4133, Covina, CA 91723, États-Unis ;
        téléphone : +1 (951) 383-6898 ; vercel.com.
      </p>
      <p className="mt-2">
        La base de données est hébergée par Supabase dans l&apos;Union
        européenne (Francfort, Allemagne). Le détail des prestataires figure
        dans la{" "}
        <a href="/confidentialite" className="underline">
          politique de confidentialité
        </a>
        .
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        Médiation de la consommation
      </h2>
      <Mediation />

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        Propriété intellectuelle
      </h2>
      <p className="mt-2">
        Les fiches publiées sont des synthèses indépendantes, rédigées par
        l&apos;éditeur à partir des recommandations des sociétés savantes, dont
        la source officielle est toujours indiquée. Elles n&apos;engagent pas
        ces sociétés savantes, dont aucun logo ni élément protégé n&apos;est
        reproduit. Les recommandations restent l&apos;œuvre et la propriété de
        leurs auteurs et des sociétés savantes ou institutions qui les
        publient ; elles demeurent en accès libre sur leurs sites, vers
        lesquels chaque fiche renvoie. Le site ne vend ni ne diffuse les
        documents originaux. Toute reproduction ou extraction du contenu du
        site, même partielle, est interdite sans autorisation écrite de
        l&apos;éditeur.
      </p>
      <p className="mt-2">
        <b>Demande d&apos;un titulaire de droits.</b> Tout auteur, société
        savante ou éditeur peut demander la correction, la mention, la
        modification ou le retrait d&apos;un contenu à{" "}
        <a href="mailto:contact@medical-guidelines.net" className="underline">
          contact@medical-guidelines.net
        </a>
        , en indiquant son identité et sa qualité, le document concerné, la
        fiche du site et l&apos;objet de la demande. La demande est traitée en
        priorité : la fiche visée est retirée du site, sur simple demande,
        pendant l&apos;examen, et une réponse motivée est adressée sous 7
        jours. Les demandes et leurs suites sont conservées.
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        Nature du contenu
      </h2>
      <p className="mt-2">
        Le site est destiné aux professionnels de santé et aux étudiants des
        filières de santé. Il ne remplace ni la lecture du texte intégral des
        recommandations, ni le jugement clinique. Les conditions d&apos;usage
        sont précisées dans les{" "}
        <a href="/cgu" className="underline">
          conditions générales d&apos;utilisation
        </a>
        .
      </p>
    </div>
  );
}
