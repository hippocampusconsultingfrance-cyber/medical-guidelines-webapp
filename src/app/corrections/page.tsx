import type { Metadata } from "next";
import Link from "next/link";
import { chargerCorrections, CRITICITES, dateCorrection } from "@/lib/corrections";
import { ficheSlug } from "@/lib/seo";
import { createClient } from "@/lib/supabase/server";
import PublicHeader from "../recommandations/public-header";

export const metadata: Metadata = {
  title: "Journal des corrections — medical-guidelines.net",
  description: "Corrections apportées aux fiches de synthèse : date, fiche, criticité et résumé de la modification.",
};

// Journal public des corrections (cahier des charges §9.4), accessible sans
// compte : date, fiche, criticité, résumé. Aucune donnée personnelle.
export default async function CorrectionsPage() {
  const supabase = await createClient();
  const [corrections, { data: auth }] = await Promise.all([chargerCorrections(supabase), supabase.auth.getUser()]);

  return (
    <div className="min-h-screen bg-white text-slate-800">
      <PublicHeader connected={Boolean(auth.user)} />
      <main className="mx-auto max-w-3xl px-4 py-10 sm:px-6">
        <h1 className="text-3xl font-bold text-[#0E3A78]">Journal des corrections</h1>
        <p className="mt-3 text-slate-600">
          Chaque erreur confirmée dans une fiche est corrigée puis consignée ici : date, fiche, criticité
          et résumé de la modification. Une erreur repérée ? Signalez-la depuis la fiche concernée.
        </p>
        {corrections.length === 0 ? (
          <p className="mt-8 rounded-lg bg-slate-50 p-4 text-sm text-slate-600">Aucune correction publiée à ce jour.</p>
        ) : (
          <ul className="mt-8 divide-y divide-slate-200">
            {corrections.map((c) => {
              const titre = c.documents?.card_json?.title ?? c.documents?.title ?? "Fiche";
              const key = c.documents?.fiche_key;
              return (
                <li key={c.id} className="py-4">
                  <p className="text-xs text-slate-500">
                    {dateCorrection(c.corrected_at)} ·{" "}
                    <span className={c.criticite === "critique" ? "font-semibold text-red-700" : "font-semibold"}>
                      {CRITICITES[c.criticite] ?? c.criticite}
                    </span>
                  </p>
                  <p className="mt-1 font-semibold text-slate-900">
                    {key ? (
                      <Link href={`/recommandations/${ficheSlug(key)}`} className="hover:underline">
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
