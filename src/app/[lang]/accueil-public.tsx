import Link from "next/link";
import { textes } from "@/i18n/serveur";
import Logo from "./logo";
import { formatDate } from "@/lib/fiches";
import { ficheSlug } from "@/lib/seo";
import type { PublicFiche } from "./recommandations/data";
import { ACCUEIL } from "./textes-accueil";

// Page d'accueil publique (visiteur non connecté). Couleurs du logo :
// bleu marine #0E3A78, turquoise #2BB5A6, bleu ciel #3AA8E0. Ne promettre
// que ce qui existe réellement sur le site.

// Icônes des principes (textes : textes-accueil.ts, dans le même ordre).
const ICONES_PRINCIPES = [
  "M4 6h16M4 12h16M4 18h10",
  "M10 14a4 4 0 0 0 5.7 0l3-3a4 4 0 0 0-5.7-5.7l-1 1M14 10a4 4 0 0 0-5.7 0l-3 3a4 4 0 0 0 5.7 5.7l1-1",
  "M9 12l2 2 4-4M12 3l7 3v6c0 4.5-3 8-7 9-4-1-7-4.5-7-9V6z",
  "M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12zM12 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6z",
];

const CHIPS: Record<string, string> = {
  "1+": "bg-emerald-50 text-emerald-800",
  "2+": "bg-sky-50 text-sky-800",
  AE: "bg-slate-100 text-slate-700",
};

// Aperçu : extrait réel de la fiche « Anticoagulants & procédure invasive »
// (SFAR / GIHP, RFE 2026), à titre d'illustration (textes-accueil.ts).

const primaryBtn =
  "rounded-lg bg-[#0E3A78] px-6 py-3 text-center font-semibold text-white shadow-sm hover:bg-[#0B2F63] focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#3AA8E0]";

export default async function AccueilPublic({ recentes = [] }: { recentes?: PublicFiche[] }) {
  const { t, lien, locale } = await textes(ACCUEIL);
  return (
    <div className="flex min-h-screen flex-col bg-white text-slate-800">
      <a
        href="#contenu"
        className="sr-only focus:not-sr-only focus:absolute focus:left-4 focus:top-4 focus:rounded focus:bg-white focus:px-3 focus:py-2 focus:text-[#0E3A78]"
      >
        {t.allerContenu}
      </a>

      <header className="sticky top-0 z-20 border-b border-slate-200 bg-white/90 backdrop-blur">
        <div className="mx-auto flex max-w-6xl items-center justify-between gap-3 px-4 py-3 sm:px-6">
          <Link href={lien("/")} aria-label="medical-guidelines.net">
            <Logo />
          </Link>
          <nav aria-label={t.navCompte} className="flex items-center gap-1 text-sm sm:gap-2">
            <Link
              href={lien("/connexion")}
              className="whitespace-nowrap rounded-lg px-2 py-2 font-medium text-slate-700 hover:bg-slate-100 sm:px-3"
            >
              {t.seConnecter}
            </Link>
            <Link
              href={lien("/inscription")}
              className="hidden rounded-lg bg-[#0E3A78] px-4 py-2 font-semibold text-white hover:bg-[#0B2F63] sm:inline-block"
            >
              {t.creerCompte}
            </Link>
          </nav>
        </div>
      </header>

      <main id="contenu" className="flex-1">
        {/* Accroche */}
        <section className="relative overflow-hidden bg-gradient-to-b from-[#EEF6FB] to-white">
          <div className="mx-auto grid max-w-6xl items-center gap-12 px-4 py-14 sm:px-6 sm:py-20 lg:grid-cols-[1.1fr_1fr]">
            <div>
              <p className="inline-flex items-center gap-2 rounded-full bg-white px-3 py-1 text-xs font-semibold uppercase tracking-wide text-[#0E3A78] ring-1 ring-[#3AA8E0]/30">
                <span className="h-1.5 w-1.5 rounded-full bg-[#2BB5A6]" aria-hidden="true" />
                {t.surtitre}
              </p>
              <h1 className="mt-5 text-3xl font-bold leading-tight tracking-tight text-[#0E3A78] sm:text-5xl">
                {t.titre}
              </h1>
              <p className="mt-5 max-w-xl text-lg text-slate-600">
                {t.accroche}
              </p>
              <div className="mt-8 flex flex-col gap-3 sm:flex-row">
                <Link href={lien("/inscription")} className={primaryBtn}>
                  {t.creerCompteGratuit}
                </Link>
                <Link
                  href={lien("/connexion")}
                  className="rounded-lg border border-slate-300 bg-white px-6 py-3 text-center font-semibold text-slate-800 hover:bg-slate-50"
                >
                  {t.dejaCompte}
                </Link>
              </div>
              <form action={lien("/recommandations")} role="search" className="mt-6 flex max-w-xl gap-2">
                <label htmlFor="q-accueil" className="sr-only">
                  {t.rechercheLibelle}
                </label>
                <input
                  id="q-accueil"
                  name="q"
                  type="search"
                  placeholder={t.recherchePlaceholder}
                  className="min-w-0 flex-1 rounded-lg border border-slate-300 bg-white px-4 py-3 text-base text-slate-900 shadow-sm placeholder:text-slate-400 focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30"
                />
                <button className="shrink-0 rounded-lg border border-[#0E3A78] bg-white px-4 py-3 font-semibold text-[#0E3A78] hover:bg-[#EEF6FB]">
                  {t.chercher}
                </button>
              </form>
              <p className="mt-3 text-sm">
                <Link href={lien("/recommandations")} className="font-semibold text-[#1A74A6] underline">
                  {t.voirListe}
                </Link>
              </p>
              <ul className="mt-6 flex flex-wrap gap-x-5 gap-y-2 text-sm text-slate-600">
                {t.atouts.map((atout) => (
                  <li key={atout} className="flex items-center gap-1.5">
                    <svg viewBox="0 0 20 20" className="h-4 w-4 text-[#177E73]" fill="currentColor" aria-hidden="true">
                      <path d="M16.7 5.3a1 1 0 0 1 0 1.4l-8 8a1 1 0 0 1-1.4 0l-4-4a1 1 0 1 1 1.4-1.4L8 12.6l7.3-7.3a1 1 0 0 1 1.4 0z" />
                    </svg>
                    {atout}
                  </li>
                ))}
              </ul>
            </div>

            {/* Aperçu d'une fiche */}
            <figure className="relative">
              <div className="absolute -inset-3 -z-10 rounded-3xl bg-gradient-to-br from-[#2BB5A6]/20 to-[#3AA8E0]/20 blur-2xl" aria-hidden="true" />
              <div className="overflow-hidden rounded-2xl bg-white shadow-xl ring-1 ring-slate-200">
                <div className="border-b border-slate-100 px-5 py-4">
                  <p className="font-mono text-[0.68rem] font-semibold uppercase tracking-wider text-[#177E73]">
                    {t.apercu.surtitre}
                  </p>
                  <p className="mt-1 text-lg font-bold text-[#0E3A78]">{t.apercu.titre}</p>
                  <p className="mt-1 text-xs text-slate-500">
                    <b className="text-slate-700">{t.apercu.methodologie}</b> GRADE · <b className="text-slate-700">{t.apercu.version}</b>{" "}
                    {t.apercu.versionDate}
                  </p>
                </div>
                <div className="px-5 py-4">
                  <p className="text-sm font-semibold text-slate-900">{t.apercu.section}</p>
                  <table className="mt-3 w-full text-start text-[0.8rem]">
                    <thead>
                      <tr className="bg-[#0E3A78] text-white">
                        <th className="rounded-s-md px-2 py-1.5 font-semibold">{t.apercu.ref}</th>
                        <th className="px-2 py-1.5 font-semibold">{t.apercu.recommandation}</th>
                        <th className="rounded-e-md px-2 py-1.5 font-semibold">{t.apercu.grade}</th>
                      </tr>
                    </thead>
                    <tbody>
                      {t.apercu.lignes.map(([ref, texte, grade]) => (
                        <tr key={ref} className="border-b border-slate-100 align-top last:border-0">
                          <td className="px-2 py-2 font-mono font-semibold text-slate-600">{ref}</td>
                          <td className="px-2 py-2 text-slate-700">{texte}</td>
                          <td className="px-2 py-2">
                            <span className={`rounded-full px-2 py-0.5 font-mono text-xs font-semibold ${CHIPS[grade]}`}>{grade}</span>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                  <p className="mt-3 text-xs font-medium text-[#1A74A6]">{t.apercu.source}</p>
                </div>
              </div>
              <figcaption className="mt-3 text-center text-xs text-slate-500">
                {t.apercu.legende}
              </figcaption>
            </figure>
          </div>
        </section>

        {/* Sources */}
        <section aria-label={t.sourcesAria} className="border-y border-slate-100 bg-white">
          <div className="mx-auto flex max-w-6xl flex-col items-center gap-3 px-4 py-6 text-center sm:flex-row sm:justify-center sm:gap-6 sm:px-6">
            <p className="text-sm text-slate-500">{t.sourcesTexte}</p>
            <p className="flex flex-wrap justify-center gap-x-5 gap-y-1 text-sm font-bold tracking-wide text-[#0E3A78]">
              <span>SFAR</span>
              <span>SRLF</span>
              <span>HAS</span>
              <span className="font-medium text-slate-500">{t.sourcesAutres}</span>
            </p>
          </div>
        </section>

        {/* Recommandations les plus récentes (métadonnées publiques) */}
        {recentes.length > 0 && (
          <section aria-labelledby="recentes" className="mx-auto max-w-6xl px-4 pt-16 sm:px-6">
            <div className="flex flex-wrap items-baseline justify-between gap-3">
              <h2 id="recentes" className="text-2xl font-bold text-[#0E3A78] sm:text-3xl">
                {t.recentes}
              </h2>
              <Link href={lien("/recommandations")} className="text-sm font-semibold text-[#1A74A6] underline">
                {t.toutes}
              </Link>
            </div>
            <ul className="mt-8 grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
              {recentes.map((f) => (
                <li key={f.id}>
                  <Link
                    href={lien(`/recommandations/${ficheSlug(f.fiche_key)}`)}
                    className="flex h-full flex-col rounded-2xl border border-slate-200 p-5 transition hover:border-[#3AA8E0] hover:shadow-md"
                  >
                    <span className="font-mono text-[0.7rem] font-semibold uppercase tracking-wider text-[#177E73]">
                      {f.societies.slice(0, 3).join(" / ")}
                    </span>
                    <span className="mt-2 font-semibold leading-snug text-slate-900">{f.card_json?.title ?? f.title}</span>
                    <span className="mt-auto pt-4 text-xs text-slate-500">{formatDate(f.publication_date, locale)}</span>
                  </Link>
                </li>
              ))}
            </ul>
          </section>
        )}

        {/* Principes */}
        <section aria-labelledby="principes" className="mx-auto max-w-6xl px-4 py-16 sm:px-6">
          <h2 id="principes" className="text-center text-2xl font-bold text-[#0E3A78] sm:text-3xl">
            {t.principesTitre}
          </h2>
          <ul className="mt-10 grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
            {t.principes.map((p, i) => (
              <li key={p.titre} className="rounded-2xl border border-slate-200 p-6 transition hover:shadow-md">
                <span className="flex h-11 w-11 items-center justify-center rounded-xl bg-gradient-to-br from-[#2BB5A6] to-[#3AA8E0] text-white">
                  <svg viewBox="0 0 24 24" className="h-5 w-5" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                    <path d={ICONES_PRINCIPES[i]} />
                  </svg>
                </span>
                <h3 className="mt-4 font-semibold text-slate-900">{p.titre}</h3>
                <p className="mt-2 text-sm leading-relaxed text-slate-600">{p.texte}</p>
              </li>
            ))}
          </ul>
        </section>

        {/* Étapes */}
        <section aria-labelledby="etapes" className="bg-[#F4F8FB]">
          <div className="mx-auto max-w-6xl px-4 py-16 sm:px-6">
            <h2 id="etapes" className="text-center text-2xl font-bold text-[#0E3A78] sm:text-3xl">
              {t.etapesTitre}
            </h2>
            <ol className="mt-10 grid gap-5 sm:grid-cols-3">
              {t.etapes.map(([titre, d], i) => (
                <li key={titre} className="rounded-2xl bg-white p-6 shadow-sm ring-1 ring-slate-200">
                  <span aria-hidden="true" className="flex h-9 w-9 items-center justify-center rounded-full bg-[#0E3A78] text-sm font-bold text-white">
                    {i + 1}
                  </span>
                  <h3 className="mt-4 font-semibold text-slate-900">{titre}</h3>
                  <p className="mt-2 text-sm leading-relaxed text-slate-600">{d}</p>
                </li>
              ))}
            </ol>
          </div>
        </section>

        {/* Offre */}
        <section aria-labelledby="offre" className="mx-auto max-w-5xl px-4 py-16 sm:px-6">
          <h2 id="offre" className="text-center text-2xl font-bold text-[#0E3A78] sm:text-3xl">
            {t.offreTitre}
          </h2>
          <div className="mt-10 grid gap-6 md:grid-cols-2">
            <div className="flex flex-col rounded-2xl border-2 border-[#2BB5A6] p-7">
              <h3 className="text-lg font-semibold text-slate-900">{t.gratuit}</h3>
              <p className="mt-2 text-4xl font-bold text-[#0E3A78]">{t.gratuitPrix}</p>
              <ul className="mt-5 space-y-2.5 text-sm text-slate-700">
                {t.gratuitPoints.map((point) => (
                  <li key={point}>✓ {point}</li>
                ))}
              </ul>
              <Link href={lien("/inscription")} className={`mt-7 ${primaryBtn}`}>
                {t.commencer}
              </Link>
            </div>
            <div className="flex flex-col rounded-2xl border border-slate-200 bg-slate-50 p-7">
              <h3 className="text-lg font-semibold text-slate-900">{t.premium}</h3>
              <p className="mt-2 text-4xl font-bold text-[#0E3A78]">
                {t.premiumPrix} <span className="text-base font-normal text-slate-500">{t.premiumPeriode}</span>
              </p>
              <ul className="mt-5 space-y-2.5 text-sm text-slate-700">
                {t.premiumPoints.map((point) => (
                  <li key={point}>✓ {point}</li>
                ))}
              </ul>
              <Link href={lien("/abonnement")} className={`mt-7 ${primaryBtn}`}>
                {t.sabonner}
              </Link>
              <p className="mt-3 text-xs text-slate-500">
                {t.premiumNote}{" "}
                <Link href={lien("/demarche")} className="underline">
                  {t.demarche}
                </Link>
              </p>
            </div>
          </div>
        </section>

        {/* Sociétés savantes partenaires */}
        <section aria-labelledby="partenaires" className="mx-auto max-w-5xl px-4 pb-16 sm:px-6">
          <div className="flex flex-col gap-4 rounded-2xl border border-[#BFD9EA] bg-[#EEF6FB] p-6 sm:flex-row sm:items-center sm:justify-between">
            <div>
              <h2 id="partenaires" className="text-xl font-bold text-[#0E3A78]">
                {t.partenairesTitre}
              </h2>
              <p className="mt-2 text-slate-700">{t.partenairesTexte}</p>
            </div>
            <Link
              href={lien("/partenaires")}
              className="shrink-0 rounded-lg bg-[#0E3A78] px-5 py-2.5 text-center font-semibold text-white hover:bg-[#0B2F63]"
            >
              {t.partenairesBouton}
            </Link>
          </div>
        </section>

        {/* Médecins relecteurs */}
        <section aria-labelledby="relecteurs" className="mx-auto max-w-5xl px-4 pb-16 sm:px-6">
          <div className="flex flex-col gap-4 rounded-2xl border border-[#BFE3DE] bg-[#EEF8F6] p-6 sm:flex-row sm:items-center sm:justify-between">
            <div>
              <h2 id="relecteurs" className="text-xl font-bold text-[#0E3A78]">
                {t.relecteursTitre}
              </h2>
              <p className="mt-2 text-slate-700">{t.relecteursTexte}</p>
            </div>
            <Link
              href={lien("/relecteurs")}
              className="shrink-0 rounded-lg bg-[#177E73] px-5 py-2.5 text-center font-semibold text-white hover:bg-[#126A61]"
            >
              {t.relecteursBouton}
            </Link>
          </div>
        </section>

        {/* FAQ */}
        <section aria-labelledby="faq" className="bg-[#F4F8FB]">
          <div className="mx-auto max-w-3xl px-4 py-16 sm:px-6">
            <h2 id="faq" className="text-center text-2xl font-bold text-[#0E3A78] sm:text-3xl">
              {t.faqTitre}
            </h2>
            <div className="mt-8 divide-y divide-slate-200 rounded-2xl bg-white ring-1 ring-slate-200">
              {t.faq.map(([q, r]) => (
                <details key={q} className="group p-5">
                  <summary className="flex cursor-pointer list-none items-center justify-between gap-4 font-semibold text-slate-900">
                    {q}
                    <span className="text-[#3AA8E0] transition group-open:rotate-45" aria-hidden="true">+</span>
                  </summary>
                  <p className="mt-3 text-sm leading-relaxed text-slate-600">{r}</p>
                </details>
              ))}
            </div>
          </div>
        </section>

        {/* Appel final */}
        <section className="bg-[#0E3A78]">
          <div className="mx-auto flex max-w-6xl flex-col items-center gap-5 px-4 py-14 text-center sm:px-6">
            <h2 className="text-2xl font-bold text-white sm:text-3xl">{t.appelTitre}</h2>
            <p className="max-w-xl text-[#CFE6F5]">{t.appelTexte}</p>
            <Link
              href={lien("/inscription")}
              className="rounded-lg bg-white px-7 py-3 font-semibold text-[#0E3A78] shadow-sm hover:bg-[#EEF6FB]"
            >
              {t.creerCompteGratuit}
            </Link>
          </div>
        </section>
      </main>

      {/* Pied de page commun (liens légaux) fourni par le layout racine. */}
      <section aria-label={t.aProposAria} className="border-t border-slate-200 bg-white">
        <div className="mx-auto flex max-w-6xl flex-col gap-4 px-4 py-8 text-sm text-slate-600 sm:px-6">
          <Logo tagline={t.tagline} />
          <p className="max-w-3xl">{t.avertissement}</p>
          <p>
            <Link href={lien("/demarche")} className="underline hover:text-slate-900">
              {t.demarche}
            </Link>{" "}
            ·{" "}
            <Link href={lien("/corrections")} className="underline hover:text-slate-900">
              {t.corrections}
            </Link>{" "}
            · {t.contact}{" "}
            <a href="mailto:contact@medical-guidelines.net" className="underline hover:text-slate-900">
              contact@medical-guidelines.net
            </a>{" "}
            · © Hippocampus Consulting
          </p>
        </div>
      </section>
    </div>
  );
}
