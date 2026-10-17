import type { Metadata } from "next";
import { INDEXABLE, SITE_URL } from "@/lib/seo";
import PublicHeader from "../recommandations/public-header";

export const metadata: Metadata = {
  title: "Notre démarche — medical-guidelines.net",
  description:
    "Les recommandations restent en accès libre sur les sites des sociétés savantes. L'abonnement couvre l'hébergement, le développement et les outils d'IA du site, pas les recommandations.",
  alternates: { canonical: `${SITE_URL}/demarche` },
  robots: { index: INDEXABLE, follow: INDEXABLE },
};

// Positionnement vis-à-vis des sociétés savantes (cahier des charges §12.4
// et §12.5) : les recommandations ne sont pas vendues ; l'abonnement finance
// le service (outils d'IA, hébergement, relecture) ; projet construit avec
// des volontaires ; procédure de demande ou de retrait pour les sociétés.
// Page publique mise en cache (identique pour tous les visiteurs),
// régénérée au plus toutes les 5 minutes.
export const revalidate = 300;

export default function DemarchePage() {
  const sections: [string, string[]][] = [
    [
      "Les recommandations restent libres et gratuites",
      [
        "Les recommandations sont l'œuvre des sociétés savantes et des autorités de santé qui les publient. Elles restent en accès libre sur leurs sites, et chaque fiche renvoie directement au texte officiel.",
        "Nous ne vendons pas les recommandations : nous n'en revendiquons aucun droit, n'en proposons ni copie ni téléchargement, et la fiche ne remplace jamais le texte de référence.",
      ],
    ],
    [
      "L'abonnement ne sert pas à tirer profit des recommandations",
      [
        "L'abonnement PREMIUM n'est pas le prix d'une recommandation. Il sert à couvrir ce que coûte le site : l'hébergement sécurisé, les développeurs qui le construisent et le maintiennent, et les outils d'intelligence artificielle qui aident à extraire, structurer et tenir à jour les fiches.",
        "L'intelligence artificielle aide, elle ne décide pas : chaque fiche est relue par l'équipe médicale, et la date de cette relecture figure sur la fiche ; toute erreur signalée est corrigée publiquement dans le journal des corrections.",
      ],
    ],
    [
      "Un projet construit avec des volontaires",
      [
        "Ce site n'existerait pas sans des personnes volontaires qui ont permis sa construction. Qu'elles en soient remerciées.",
      ],
    ],
    [
      "Indépendance",
      [
        "Les fiches sont des synthèses indépendantes et non officielles. Elles ne sont ni éditées, ni validées, ni financées par les sociétés savantes citées, qui ne sont associées à aucune offre commerciale du site.",
        "Aucun partenaire commercial n'influence le contenu. Les divergences entre sociétés savantes sont présentées côte à côte, sans arbitrage.",
      ],
    ],
  ];

  return (
    <div className="min-h-screen bg-white text-slate-800">
      <PublicHeader />
      <main className="mx-auto max-w-3xl px-4 py-10 sm:px-6">
        <h1 className="text-3xl font-bold text-[#0E3A78]">Notre démarche</h1>
        <p className="mt-3 text-lg text-slate-600">
          Un outil indépendant pour aider les professionnels de santé à lire, retrouver et appliquer les
          recommandations françaises, au service de leur diffusion.
        </p>
        {sections.map(([titre, paragraphes]) => (
          <section key={titre} className="mt-8">
            <h2 className="text-xl font-bold text-slate-900">{titre}</h2>
            {paragraphes.map((p) => (
              <p key={p.slice(0, 30)} className="mt-3 leading-relaxed text-slate-700">
                {p}
              </p>
            ))}
          </section>
        ))}
        <section className="mt-10 rounded-2xl bg-[#EEF6FB] p-6">
          <h2 className="text-xl font-bold text-[#0E3A78]">Sociétés savantes et auteurs : à votre écoute</h2>
          <p className="mt-3 leading-relaxed text-slate-700">
            Vous représentez une société savante ou êtes l&apos;auteur d&apos;une recommandation ? Toute demande
            — correction, mention, mise à jour ou retrait d&apos;une fiche — est traitée en priorité : la fiche
            est retirée du site sur simple demande pendant l&apos;examen, et une réponse motivée vous est
            adressée sous 7 jours.
          </p>
          <p className="mt-3 leading-relaxed text-slate-700">
            Nous proposons aussi aux sociétés savantes un partenariat gratuit : accès PREMIUM offert, statistiques
            anonymes de lecture de leurs recommandations et signalements d&apos;erreurs des lecteurs sur leurs fiches.{" "}
            <a href="/partenaires" className="font-semibold text-[#1A74A6] underline">
              Devenir partenaire
            </a>
          </p>
          <p className="mt-3">
            <a href="mailto:contact@medical-guidelines.net" className="font-semibold text-[#1A74A6] underline">
              contact@medical-guidelines.net
            </a>
          </p>
        </section>
      </main>
    </div>
  );
}
