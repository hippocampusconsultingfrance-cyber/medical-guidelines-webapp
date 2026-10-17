import type { Metadata } from "next";
import Link from "next/link";
import { riche } from "@/i18n/format";
import { textes } from "@/i18n/serveur";
import { INDEXABLE, alternatives } from "@/lib/seo";
import PublicHeader from "../recommandations/public-header";
import { PARTENAIRES } from "./textes";

export async function generateMetadata(): Promise<Metadata> {
  const { t, langue } = await textes(PARTENAIRES);
  return {
    title: t.titreMeta,
    description: t.descriptionMeta,
    alternates: alternatives(langue, "/partenaires"),
    robots: { index: INDEXABLE, follow: INDEXABLE },
  };
}

// Offre de partenariat aux sociétés savantes (page publique). Ce qui est
// promis ici doit rester aligné sur la politique de confidentialité (§3.3 :
// statistiques anonymes, au-delà de 10 lecteurs) : aucune donnée
// individuelle de membre n'est transmise.
// Page publique mise en cache (identique pour tous les visiteurs),
// régénérée au plus toutes les 5 minutes.
export const revalidate = 300;

export default async function PartenairesPage() {
  const { t, lien } = await textes(PARTENAIRES);
  return (
    <div className="min-h-screen bg-white text-slate-800">
      <PublicHeader />
      <main className="mx-auto max-w-3xl px-4 py-10 sm:px-6">
        <p className="text-sm font-semibold uppercase tracking-wide text-[#177E73]">{t.surtitre}</p>
        <h1 className="mt-2 text-3xl font-bold text-[#0E3A78]">{t.titre}</h1>
        <p className="mt-3 text-lg text-slate-600">{t.intro}</p>

        <ul className="mt-8 grid gap-4 sm:grid-cols-3">
          {t.offre.map(([titre, texte]) => (
            <li key={titre} className="rounded-2xl border border-slate-200 p-5">
              <h2 className="font-bold text-slate-900">{titre}</h2>
              <p className="mt-2 text-sm leading-relaxed text-slate-700">{texte}</p>
            </li>
          ))}
        </ul>

        <section className="mt-10 rounded-2xl bg-[#EEF6FB] p-6">
          <h2 className="text-xl font-bold text-[#0E3A78]">{t.contactTitre}</h2>
          <p className="mt-3 leading-relaxed text-slate-700">{t.contactTexte}</p>
          <p className="mt-3">
            <a
              href={`mailto:contact@medical-guidelines.net?subject=${encodeURIComponent(t.contactObjet)}`}
              className="font-semibold text-[#1A74A6] underline"
            >
              contact@medical-guidelines.net
            </a>
          </p>
        </section>

        <p className="mt-8 text-sm leading-relaxed text-slate-500">
          {riche(t.note, {
            demarche: (c) => (
              <Link href={lien("/demarche")} className="underline">
                {c}
              </Link>
            ),
          })}
        </p>
      </main>
    </div>
  );
}
