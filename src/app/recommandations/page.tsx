import type { Metadata } from "next";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { formatDate } from "@/lib/fiches";
import { INDEXABLE, SITE_URL, ficheSlug } from "@/lib/seo";
import { groupBySection } from "../bibliotheque/data";
import { loadPublicFiches } from "./data";
import PublicHeader from "./public-header";
import RechercheCatalogue from "./recherche";

export const metadata: Metadata = {
  title: "Recommandations médicales des sociétés savantes — fiches de synthèse | medical-guidelines.net",
  description:
    "Les recommandations des sociétés savantes françaises (SFAR, SRLF, SFMU, HAS…) en fiches de synthèse claires et sourcées, grades conservés : anesthésie-réanimation, réanimation, urgences, pédiatrie et d'autres spécialités.",
  alternates: { canonical: `${SITE_URL}/recommandations` },
  robots: { index: INDEXABLE, follow: INDEXABLE },
};

const ancre = (section: string) =>
  "s-" +
  section
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "");

const motsCles = (s: string) =>
  s
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase();

// Catalogue public des fiches : titres, sociétés et dates uniquement.
export default async function RecommandationsPage() {
  const supabase = await createClient();
  const [{ data: auth }, fiches] = await Promise.all([supabase.auth.getUser(), loadPublicFiches(supabase)]);
  const groups = groupBySection(fiches);

  return (
    <div className="min-h-screen bg-white text-slate-800">
      <PublicHeader connected={Boolean(auth.user)} />
      <main>
        <div className="bg-gradient-to-b from-[#EEF6FB] to-white">
          <div className="mx-auto max-w-5xl px-4 pb-6 pt-10 sm:px-6">
            <p className="text-sm font-semibold uppercase tracking-wide text-[#177E73]">Toutes spécialités</p>
            <h1 className="mt-2 text-3xl font-bold text-[#0E3A78] sm:text-4xl">
              {fiches.length} recommandations en fiches de synthèse
            </h1>
            <p className="mt-3 max-w-2xl text-slate-600">
              Recommandations des sociétés savantes françaises et partenaires, de la plus récente à la plus
              ancienne. Chaque fiche garde les grades de la source et renvoie au document officiel.
            </p>
            <Link
              href={auth.user ? "/bibliotheque" : "/inscription"}
              className="mt-6 inline-block rounded-lg bg-[#0E3A78] px-6 py-3 font-semibold text-white hover:bg-[#0B2F63]"
            >
              {auth.user ? "Ouvrir ma bibliothèque" : "Créer un compte gratuit : 5 fiches offertes"}
            </Link>
            <RechercheCatalogue total={fiches.length} />
          </div>
        </div>

        <nav
          aria-label="Spécialités"
          className="sticky top-0 z-10 border-y border-slate-200 bg-white/95 backdrop-blur"
        >
          <ul className="mx-auto flex max-w-5xl gap-2 overflow-x-auto px-4 py-2.5 sm:px-6">
            {groups.map(([section, list]) => (
              <li key={section} data-raccourci={ancre(section)} className="shrink-0">
                <a
                  href={`#${ancre(section)}`}
                  className="inline-flex items-center gap-1.5 rounded-full border border-slate-200 px-3 py-1.5 text-sm font-medium text-slate-700 hover:border-[#3AA8E0] hover:text-[#0E3A78]"
                >
                  {section}
                  <span className="text-xs text-slate-500">{list.length}</span>
                </a>
              </li>
            ))}
          </ul>
        </nav>

        <div className="mx-auto max-w-5xl px-4 pb-16 sm:px-6">
          {groups.map(([section, list]) => (
            <section
              key={section}
              id={ancre(section)}
              data-rubrique
              className="scroll-mt-16 pt-10"
              aria-labelledby={`t-${ancre(section)}`}
            >
              <h2 id={`t-${ancre(section)}`} className="text-xl font-bold text-[#0E3A78]">
                {section} <span className="text-base font-medium text-slate-500">({list.length})</span>
              </h2>
              <ul className="mt-4 divide-y divide-slate-100 overflow-hidden rounded-2xl ring-1 ring-slate-200">
                {list.map((fiche) => {
                  const titre = fiche.card_json?.title ?? fiche.title;
                  return (
                    <li key={fiche.id} data-q={motsCles(`${titre} ${fiche.title} ${fiche.societies.join(" ")}`)}>
                      <Link
                        href={`/recommandations/${ficheSlug(fiche.fiche_key)}`}
                        className="flex flex-col gap-1 px-4 py-3 hover:bg-slate-50 sm:flex-row sm:items-baseline sm:justify-between sm:gap-6"
                      >
                        <span className="font-medium text-slate-900">{titre}</span>
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
        </div>
      </main>
    </div>
  );
}
