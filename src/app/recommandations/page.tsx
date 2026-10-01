import type { Metadata } from "next";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { formatDate } from "@/lib/fiches";
import { INDEXABLE, SITE_URL, ficheSlug } from "@/lib/seo";
import { groupBySection } from "../bibliotheque/data";
import { loadPublicFiches } from "./data";
import PublicHeader from "./public-header";

export const metadata: Metadata = {
  title: "Recommandations médicales des sociétés savantes — fiches de synthèse | medical-guidelines.net",
  description:
    "Les recommandations des sociétés savantes françaises (SFAR, SRLF, SFMU, HAS…) en fiches de synthèse claires et sourcées, grades conservés : anesthésie-réanimation, réanimation, urgences, pédiatrie et d'autres spécialités.",
  alternates: { canonical: `${SITE_URL}/recommandations` },
  robots: { index: INDEXABLE, follow: INDEXABLE },
};

// Catalogue public des fiches : titres, sociétés et dates uniquement.
export default async function RecommandationsPage() {
  const supabase = await createClient();
  const [{ data: auth }, fiches] = await Promise.all([supabase.auth.getUser(), loadPublicFiches(supabase)]);
  const groups = groupBySection(fiches.map((f) => ({ ...f, published_at: null })));

  return (
    <div className="min-h-screen bg-white text-slate-800">
      <PublicHeader connected={Boolean(auth.user)} />
      <main className="mx-auto max-w-5xl px-4 py-10 sm:px-6">
        <p className="text-sm font-semibold uppercase tracking-wide text-[#2BB5A6]">Toutes spécialités</p>
        <h1 className="mt-2 text-3xl font-bold text-[#0E3A78]">
          {fiches.length} recommandations en fiches de synthèse
        </h1>
        <p className="mt-3 max-w-2xl text-slate-600">
          Recommandations des sociétés savantes françaises et partenaires, de la plus récente à la plus
          ancienne. Chaque fiche garde les grades de la source et renvoie au document officiel.
        </p>
        <Link
          href="/inscription"
          className="mt-6 inline-block rounded-lg bg-[#0E3A78] px-6 py-3 font-semibold text-white hover:bg-[#0B2F63]"
        >
          Créer un compte gratuit : 5 fiches offertes
        </Link>

        {groups.map(([section, list]) => (
          <section key={section} className="mt-12" aria-labelledby={`s-${section}`}>
            <h2 id={`s-${section}`} className="text-xl font-bold text-[#0E3A78]">
              {section} <span className="text-base font-medium text-slate-400">({list.length})</span>
            </h2>
            <ul className="mt-4 divide-y divide-slate-100 rounded-2xl ring-1 ring-slate-200">
              {list.map((f) => {
                const fiche = fiches.find((x) => x.id === f.id)!;
                return (
                  <li key={f.id}>
                    <Link
                      href={`/recommandations/${ficheSlug(fiche.fiche_key)}`}
                      className="flex flex-col gap-1 px-4 py-3 hover:bg-slate-50 sm:flex-row sm:items-baseline sm:justify-between sm:gap-6"
                    >
                      <span className="font-medium text-slate-900">{fiche.card_json?.title ?? fiche.title}</span>
                      <span className="shrink-0 font-mono text-xs text-slate-500">
                        {[fiche.societies.slice(0, 3).join(" / "), formatDate(fiche.publication_date)]
                          .filter(Boolean)
                          .join(" · ")}
                      </span>
                    </Link>
                  </li>
                );
              })}
            </ul>
          </section>
        ))}
      </main>
    </div>
  );
}
