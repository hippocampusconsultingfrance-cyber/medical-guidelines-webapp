import type { Metadata } from "next";
import Link from "next/link";
import { riche } from "@/i18n/format";
import { textes } from "@/i18n/serveur";
import { nomProfession, nomSpecialite } from "@/i18n/specialites";
import { PROFESSIONS_MEDECIN } from "@/lib/relecteurs";
import { createClient } from "@/lib/supabase/server";
import { INDEXABLE, alternatives } from "@/lib/seo";
import PublicHeader from "../recommandations/public-header";
import { envoyerCandidature } from "./actions";
import { RELECTEURS } from "./textes";

export async function generateMetadata(): Promise<Metadata> {
  const { t, langue } = await textes(RELECTEURS);
  return {
    title: t.titreMeta,
    description: t.descriptionMeta,
    alternates: alternatives(langue, "/relecteurs"),
    robots: { index: INDEXABLE, follow: INDEXABLE },
  };
}

// Messages de retour du formulaire : vert pour « merci », orange sinon.
const SUCCES = new Set(["merci"]);

type SpecialtyRow = { slug: string; name_i18n: { fr?: string } | null };

const champ =
  "mt-1 block w-full rounded-lg border border-slate-300 bg-white px-3 py-2.5 text-base sm:text-sm focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30";

// Appel aux médecins relecteurs (page publique) : participer à la correction
// des fiches en échange d'un accès gratuit et de 5 accès offerts aux personnes de son choix.
export default async function RelecteursPage({ searchParams }: PageProps<"/[lang]/relecteurs">) {
  const { t, langue, lien, locale } = await textes(RELECTEURS);
  const supabase = await createClient();
  const [{ data }, params] = await Promise.all([
    supabase.from("specialties").select("slug, name_i18n").eq("category", "medicale"),
    searchParams,
  ]);
  const specialites = ((data ?? []) as SpecialtyRow[])
    .map((s) => ({ slug: s.slug, nom: nomSpecialite(s.slug, s.name_i18n?.fr ?? s.slug, langue) }))
    .sort((a, b) => a.nom.localeCompare(b.nom, locale));
  const cle = typeof params.r === "string" && params.r in t.messages ? params.r : null;
  const r = cle ? ([t.messages[cle], SUCCES.has(cle)] as const) : undefined;

  return (
    <div className="min-h-screen bg-white text-slate-800">
      <PublicHeader />
      <main className="mx-auto max-w-3xl px-4 py-10 sm:px-6">
        <p className="text-sm font-semibold uppercase tracking-wide text-[#177E73]">{t.surtitre}</p>
        <h1 className="mt-2 text-3xl font-bold text-[#0E3A78]">{t.titre}</h1>
        <p className="mt-3 text-lg text-slate-600">{t.intro}</p>

        <section className="mt-8 rounded-2xl border border-[#BFD9EA] bg-[#EEF6FB] p-6">
          <h2 className="text-xl font-bold text-[#0E3A78]">{t.offreTitre}</h2>
          <ul className="mt-3 list-disc space-y-1 ps-5 text-slate-700">
            {t.offre.map((o) => (
              <li key={o}>{riche(o, { b: (c) => <b>{c}</b> })}</li>
            ))}
          </ul>
          <p className="mt-3 text-sm text-slate-600">{t.offreTexte}</p>
        </section>

        <section id="candidature" className="mt-10">
          <h2 className="text-xl font-bold text-[#0E3A78]">{t.formulaireTitre}</h2>
          {r && (
            <p
              role="status"
              className={`mt-4 rounded-lg p-3 text-sm ${r[1] ? "bg-emerald-50 text-emerald-900" : "bg-amber-50 text-amber-900"}`}
            >
              {r[0]}
            </p>
          )}
          <form action={envoyerCandidature} className="mt-6 grid gap-4 sm:grid-cols-2">
            <input type="hidden" name="langue" value={langue} />
            <label className="block text-sm font-medium text-slate-700">
              {t.nom}
              <input name="nom" required maxLength={100} autoComplete="family-name" className={champ} />
            </label>
            <label className="block text-sm font-medium text-slate-700">
              {t.prenom}
              <input name="prenom" required maxLength={100} autoComplete="given-name" className={champ} />
            </label>
            <label className="block text-sm font-medium text-slate-700">
              {t.telephone}
              <input name="telephone" type="tel" required maxLength={30} autoComplete="tel" className={champ} />
            </label>
            <label className="block text-sm font-medium text-slate-700">
              {t.email}
              <input name="email" type="email" required maxLength={254} autoComplete="email" className={champ} />
            </label>
            <label className="block text-sm font-medium text-slate-700">
              {t.profession}
              <select name="profession" required defaultValue="" className={champ}>
                <option value="" disabled>
                  {t.choisirProfession}
                </option>
                {PROFESSIONS_MEDECIN.map((p) => (
                  <option key={p} value={p}>
                    {nomProfession(p, langue)}
                  </option>
                ))}
              </select>
            </label>
            <label className="block text-sm font-medium text-slate-700">
              {t.specialite}
              <select name="specialite" required defaultValue="" className={champ}>
                <option value="" disabled>
                  {specialites.length ? t.choisirSpecialite : t.listeIndisponible}
                </option>
                {specialites.map((s) => (
                  <option key={s.slug} value={s.slug}>
                    {s.nom}
                  </option>
                ))}
              </select>
            </label>
            <label className="block text-sm font-medium text-slate-700 sm:col-span-2">
              {t.message}
              <textarea name="message" maxLength={2000} rows={4} className={champ} />
            </label>
            {/* Piège à robots : invisible et ignoré par les lecteurs d'écran. */}
            <div aria-hidden="true" className="absolute -left-[10000px] h-px w-px overflow-hidden">
              <label>
                {t.siteWeb}
                <input name="site_web" tabIndex={-1} autoComplete="off" />
              </label>
            </div>
            <label className="flex items-start gap-2 text-sm text-slate-700 sm:col-span-2">
              <input type="checkbox" name="consentement" value="oui" required className="mt-0.5 h-4 w-4" />
              <span>
                {riche(t.consentement, {
                  confidentialite: (c) => (
                    <Link href={lien("/confidentialite")} className="underline">
                      {c}
                    </Link>
                  ),
                })}
              </span>
            </label>
            <div className="sm:col-span-2">
              <button className="w-full rounded-lg bg-[#0E3A78] px-4 py-3 text-sm font-semibold text-white shadow-sm hover:bg-[#0B2F63]">
                {t.envoyer}
              </button>
            </div>
          </form>
        </section>
      </main>
    </div>
  );
}
