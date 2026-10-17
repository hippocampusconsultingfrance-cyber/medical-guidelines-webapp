import type { Metadata } from "next";
import Link from "next/link";
import { PROFESSIONS_MEDECIN } from "@/lib/relecteurs";
import { createClient } from "@/lib/supabase/server";
import { INDEXABLE, SITE_URL } from "@/lib/seo";
import PublicHeader from "../recommandations/public-header";
import { envoyerCandidature } from "./actions";

export const metadata: Metadata = {
  title: "Médecins relecteurs — medical-guidelines.net",
  description:
    "Vous êtes médecin ? Participez à la correction des fiches, déjà relues deux fois par des outils d'intelligence artificielle : accès gratuit et illimité au site, plus 5 accès gratuits illimités pour les personnes de votre choix.",
  alternates: { canonical: `${SITE_URL}/relecteurs` },
  robots: { index: INDEXABLE, follow: INDEXABLE },
};

const MESSAGES: Record<string, [string, boolean]> = {
  merci: ["Merci ! Votre candidature a bien été envoyée : nous vous recontactons rapidement.", true],
  nom: ["Indiquez votre nom et votre prénom.", false],
  telephone: ["Le numéro de téléphone n'est pas valide.", false],
  email: ["L'adresse e-mail n'est pas valide.", false],
  profession: ["Choisissez votre profession dans la liste.", false],
  specialite: ["Choisissez la spécialité dont vous souhaitez corriger les fiches.", false],
  consentement: ["Cochez la case d'accord pour que nous puissions vous recontacter.", false],
  limite: ["Vous avez déjà envoyé plusieurs candidatures aujourd'hui : nous les avons bien reçues.", false],
  erreur: ["L'envoi n'a pas abouti. Réessayez dans un instant.", false],
};

type SpecialtyRow = { slug: string; name_i18n: { fr?: string } | null };

const champ =
  "mt-1 block w-full rounded-lg border border-slate-300 bg-white px-3 py-2.5 text-base sm:text-sm focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30";

// Appel aux médecins relecteurs (page publique) : participer à la correction
// des fiches en échange d'un accès gratuit et de 5 accès offerts aux personnes de son choix.
export default async function RelecteursPage({ searchParams }: PageProps<"/[lang]/relecteurs">) {
  const supabase = await createClient();
  const [{ data }, params] = await Promise.all([
    supabase.from("specialties").select("slug, name_i18n").eq("category", "medicale"),
    searchParams,
  ]);
  const specialites = ((data ?? []) as SpecialtyRow[])
    .map((s) => ({ slug: s.slug, nom: s.name_i18n?.fr ?? s.slug }))
    .sort((a, b) => a.nom.localeCompare(b.nom, "fr"));
  const r = typeof params.r === "string" ? MESSAGES[params.r] : undefined;

  return (
    <div className="min-h-screen bg-white text-slate-800">
      <PublicHeader />
      <main className="mx-auto max-w-3xl px-4 py-10 sm:px-6">
        <p className="text-sm font-semibold uppercase tracking-wide text-[#177E73]">Médecins relecteurs</p>
        <h1 className="mt-2 text-3xl font-bold text-[#0E3A78]">
          Vous êtes médecin et vous souhaitez participer à la correction des fiches&nbsp;?
        </h1>
        <p className="mt-3 text-lg text-slate-600">
          Chaque fiche a déjà été relue deux fois par des outils d&apos;intelligence artificielle, qui la comparent
          au texte de la recommandation source. Votre regard de praticien permet d&apos;aller plus loin.
        </p>

        <section className="mt-8 rounded-2xl border border-[#BFD9EA] bg-[#EEF6FB] p-6">
          <h2 className="text-xl font-bold text-[#0E3A78]">Ce que nous vous offrons</h2>
          <ul className="mt-3 list-disc space-y-1 pl-5 text-slate-700">
            <li>
              un <b>accès gratuit et illimité</b> au site ;
            </li>
            <li>
              ainsi que <b>5 accès gratuits illimités</b> pour les personnes que vous désignez.
            </li>
          </ul>
          <p className="mt-3 text-sm text-slate-600">
            Laissez-nous vos coordonnées et la spécialité dont vous souhaitez corriger les fiches : nous vous
            recontactons pour convenir des modalités.
          </p>
        </section>

        <section id="candidature" className="mt-10">
          <h2 className="text-xl font-bold text-[#0E3A78]">Je souhaite participer</h2>
          {r && (
            <p
              role="status"
              className={`mt-4 rounded-lg p-3 text-sm ${r[1] ? "bg-emerald-50 text-emerald-900" : "bg-amber-50 text-amber-900"}`}
            >
              {r[0]}
            </p>
          )}
          <form action={envoyerCandidature} className="mt-6 grid gap-4 sm:grid-cols-2">
            <label className="block text-sm font-medium text-slate-700">
              Nom
              <input name="nom" required maxLength={100} autoComplete="family-name" className={champ} />
            </label>
            <label className="block text-sm font-medium text-slate-700">
              Prénom
              <input name="prenom" required maxLength={100} autoComplete="given-name" className={champ} />
            </label>
            <label className="block text-sm font-medium text-slate-700">
              Numéro de téléphone
              <input name="telephone" type="tel" required maxLength={30} autoComplete="tel" className={champ} />
            </label>
            <label className="block text-sm font-medium text-slate-700">
              Adresse e-mail
              <input name="email" type="email" required maxLength={254} autoComplete="email" className={champ} />
            </label>
            <label className="block text-sm font-medium text-slate-700">
              Profession
              <select name="profession" required defaultValue="" className={champ}>
                <option value="" disabled>
                  Sélectionnez votre profession
                </option>
                {PROFESSIONS_MEDECIN.map((p) => (
                  <option key={p} value={p}>
                    {p}
                  </option>
                ))}
              </select>
            </label>
            <label className="block text-sm font-medium text-slate-700">
              Spécialité dont vous souhaitez corriger les fiches
              <select name="specialite" required defaultValue="" className={champ}>
                <option value="" disabled>
                  {specialites.length ? "Sélectionnez une spécialité" : "Liste indisponible : rechargez la page"}
                </option>
                {specialites.map((s) => (
                  <option key={s.slug} value={s.slug}>
                    {s.nom}
                  </option>
                ))}
              </select>
            </label>
            <label className="block text-sm font-medium text-slate-700 sm:col-span-2">
              Message (facultatif)
              <textarea name="message" maxLength={2000} rows={4} className={champ} />
            </label>
            {/* Piège à robots : invisible et ignoré par les lecteurs d'écran. */}
            <div aria-hidden="true" className="absolute -left-[10000px] h-px w-px overflow-hidden">
              <label>
                Site web
                <input name="site_web" tabIndex={-1} autoComplete="off" />
              </label>
            </div>
            <label className="flex items-start gap-2 text-sm text-slate-700 sm:col-span-2">
              <input type="checkbox" name="consentement" value="oui" required className="mt-0.5 h-4 w-4" />
              <span>
                J&apos;accepte que ces informations soient utilisées pour me recontacter au sujet de cette proposition
                (voir la{" "}
                <Link href="/confidentialite" className="underline">
                  politique de confidentialité
                </Link>
                ).
              </span>
            </label>
            <div className="sm:col-span-2">
              <button className="w-full rounded-lg bg-[#0E3A78] px-4 py-3 text-sm font-semibold text-white shadow-sm hover:bg-[#0B2F63]">
                Envoyer ma candidature
              </button>
            </div>
          </form>
        </section>
      </main>
    </div>
  );
}
