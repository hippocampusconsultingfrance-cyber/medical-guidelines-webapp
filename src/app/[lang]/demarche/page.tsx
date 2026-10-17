import type { Metadata } from "next";
import { textes } from "@/i18n/serveur";
import { INDEXABLE, alternatives } from "@/lib/seo";
import PublicHeader from "../recommandations/public-header";
import { DEMARCHE } from "./textes";

export async function generateMetadata(): Promise<Metadata> {
  const { t, langue } = await textes(DEMARCHE);
  return {
    title: t.titreMeta,
    description: t.descriptionMeta,
    alternates: alternatives(langue, "/demarche"),
    robots: { index: INDEXABLE, follow: INDEXABLE },
  };
}

// Positionnement vis-à-vis des sociétés savantes (cahier des charges §12.4
// et §12.5) : les recommandations ne sont pas vendues ; l'abonnement finance
// le service (outils d'IA, hébergement, relecture) ; projet construit avec
// des volontaires ; procédure de demande ou de retrait pour les sociétés.
// Page publique mise en cache (identique pour tous les visiteurs),
// régénérée au plus toutes les 5 minutes.
export const revalidate = 300;

export default async function DemarchePage() {
  const { t, lien } = await textes(DEMARCHE);
  return (
    <div className="min-h-screen bg-white text-slate-800">
      <PublicHeader />
      <main className="mx-auto max-w-3xl px-4 py-10 sm:px-6">
        <h1 className="text-3xl font-bold text-[#0E3A78]">{t.titre}</h1>
        <p className="mt-3 text-lg text-slate-600">{t.intro}</p>
        {t.sections.map(([titre, paragraphes]) => (
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
          <h2 className="text-xl font-bold text-[#0E3A78]">{t.ecouteTitre}</h2>
          <p className="mt-3 leading-relaxed text-slate-700">{t.ecouteTexte}</p>
          <p className="mt-3 leading-relaxed text-slate-700">
            {t.partenariat}{" "}
            <a href={lien("/partenaires")} className="font-semibold text-[#1A74A6] underline">
              {t.devenirPartenaire}
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
