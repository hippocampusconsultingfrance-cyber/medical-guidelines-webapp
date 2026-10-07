import type { Metadata } from "next";
import Link from "next/link";
import PublicHeader from "../recommandations/public-header";

export const metadata: Metadata = {
  title: "Sociétés savantes partenaires — medical-guidelines.net",
  description:
    "Sociétés savantes : devenez partenaires. Accès PREMIUM offert, statistiques anonymes de lecture de vos recommandations et signalements d'erreurs des lecteurs sur vos fiches.",
};

// Offre de partenariat aux sociétés savantes (page publique). Ce qui est
// promis ici doit rester aligné sur la politique de confidentialité (§3.3 :
// statistiques anonymes, au-delà de 10 lecteurs) : aucune donnée
// individuelle de membre n'est transmise.
// Page publique mise en cache (identique pour tous les visiteurs),
// régénérée au plus toutes les 5 minutes.
export const revalidate = 300;

export default function PartenairesPage() {
  const offre: [string, string][] = [
    [
      "Accès PREMIUM offert",
      "Les membres désignés par votre société (bureau, conseil scientifique, comité des référentiels) reçoivent un accès PREMIUM gratuit : toutes les fiches de leur spécialité et l'assistant de recherche.",
    ],
    [
      "Statistiques de lecture de vos recommandations",
      "Nombre de lecteurs par fiche, par mois et par spécialité, toujours anonymes et agrégées (jamais en dessous de 10 lecteurs, jamais l'identité ni le parcours d'un membre).",
    ],
    [
      "Signalements d'erreurs sur vos fiches",
      "Les erreurs et imprécisions signalées par les lecteurs sur les fiches tirées de vos recommandations vous sont transmises, avec la correction apportée.",
    ],
  ];

  return (
    <div className="min-h-screen bg-white text-slate-800">
      <PublicHeader />
      <main className="mx-auto max-w-3xl px-4 py-10 sm:px-6">
        <p className="text-sm font-semibold uppercase tracking-wide text-[#177E73]">Sociétés savantes</p>
        <h1 className="mt-2 text-3xl font-bold text-[#0E3A78]">Devenez notre partenaire</h1>
        <p className="mt-3 text-lg text-slate-600">
          Vous représentez une société savante&nbsp;? Nous vous proposons un partenariat gratuit, au service de la
          diffusion de vos recommandations auprès des professionnels de santé.
        </p>

        <ul className="mt-8 grid gap-4 sm:grid-cols-3">
          {offre.map(([titre, texte]) => (
            <li key={titre} className="rounded-2xl border border-slate-200 p-5">
              <h2 className="font-bold text-slate-900">{titre}</h2>
              <p className="mt-2 text-sm leading-relaxed text-slate-700">{texte}</p>
            </li>
          ))}
        </ul>

        <section className="mt-10 rounded-2xl bg-[#EEF6FB] p-6">
          <h2 className="text-xl font-bold text-[#0E3A78]">Nous contacter</h2>
          <p className="mt-3 leading-relaxed text-slate-700">
            Écrivez-nous en précisant votre société et la personne à contacter : nous vous répondons sous 7 jours
            pour définir ensemble les modalités du partenariat.
          </p>
          <p className="mt-3">
            <a href="mailto:contact@medical-guidelines.net?subject=Partenariat%20soci%C3%A9t%C3%A9%20savante" className="font-semibold text-[#1A74A6] underline">
              contact@medical-guidelines.net
            </a>
          </p>
        </section>

        <p className="mt-8 text-sm leading-relaxed text-slate-500">
          Un partenariat ne vaut ni validation ni approbation des fiches par la société : elles restent des synthèses
          indépendantes et non officielles, qui renvoient toujours au texte de référence. Toute demande de correction,
          de mise à jour ou de retrait reste traitée en priorité, partenaire ou non (voir{" "}
          <Link href="/demarche" className="underline">
            Notre démarche
          </Link>
          ).
        </p>
      </main>
    </div>
  );
}
