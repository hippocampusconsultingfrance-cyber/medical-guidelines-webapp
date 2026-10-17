import type { Metadata } from "next";
import Link from "next/link";
import { FICHE } from "@/i18n/fiche";
import { textes } from "@/i18n/serveur";
import { chargerCorrections, dateCorrection } from "@/lib/corrections";
import { INDEXABLE, alternatives, ficheSlug } from "@/lib/seo";
import { createPublicClient } from "@/lib/supabase/public";
import PublicHeader from "../recommandations/public-header";
import { CORRECTIONS } from "./textes";

export async function generateMetadata(): Promise<Metadata> {
  const { t, langue } = await textes(CORRECTIONS);
  return {
    title: t.titreMeta,
    description: t.descriptionMeta,
    alternates: alternatives(langue, "/corrections"),
    robots: { index: INDEXABLE, follow: INDEXABLE },
  };
}

// Journal public des corrections (cahier des charges §9.4), accessible sans
// compte : date, fiche, criticité, résumé. Aucune donnée personnelle.
// Page publique mise en cache (identique pour tous les visiteurs),
// régénérée au plus toutes les 5 minutes.
export const revalidate = 300;

export default async function CorrectionsPage() {
  const { t, langue, lien, locale } = await textes(CORRECTIONS);
  const criticites = FICHE[langue].criticites;
  const corrections = await chargerCorrections(createPublicClient());

  return (
    <div className="min-h-screen bg-white text-slate-800">
      <PublicHeader />
      <main className="mx-auto max-w-3xl px-4 py-10 sm:px-6">
        <h1 className="text-3xl font-bold text-[#0E3A78]">{t.titre}</h1>
        <p className="mt-3 text-slate-600">{t.intro}</p>
        {t.enFrancais && <p className="mt-2 text-sm text-slate-500">{t.enFrancais}</p>}
        {corrections.length === 0 ? (
          <p className="mt-8 rounded-lg bg-slate-50 p-4 text-sm text-slate-600">{t.aucune}</p>
        ) : (
          <ul className="mt-8 divide-y divide-slate-200">
            {corrections.map((c) => {
              const titre = c.documents?.card_json?.title ?? c.documents?.title ?? t.fiche;
              const key = c.documents?.fiche_key;
              return (
                <li key={c.id} className="py-4">
                  <p className="text-xs text-slate-500">
                    {dateCorrection(c.corrected_at, locale)} ·{" "}
                    <span className={c.criticite === "critique" ? "font-semibold text-red-700" : "font-semibold"}>
                      {criticites[c.criticite] ?? c.criticite}
                    </span>
                  </p>
                  <p className="mt-1 font-semibold text-slate-900">
                    {key ? (
                      <Link href={lien(`/recommandations/${ficheSlug(key)}`)} className="hover:underline">
                        {titre}
                      </Link>
                    ) : (
                      titre
                    )}
                  </p>
                  <p className="mt-1 text-sm text-slate-700">{c.resume}</p>
                </li>
              );
            })}
          </ul>
        )}
      </main>
    </div>
  );
}
