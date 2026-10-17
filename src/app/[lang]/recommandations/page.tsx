import type { Metadata } from "next";
import Link from "next/link";
import { FICHE } from "@/i18n/fiche";
import { plur } from "@/i18n/format";
import { rubrique } from "@/i18n/rubriques";
import { textes } from "@/i18n/serveur";
import { formatDate } from "@/lib/fiches";
import { INDEXABLE, LANGUES_CONTENU, SITE_URL, alternatives, contenuIndexable, ficheSlug, sectionSlug } from "@/lib/seo";
import { groupBySection } from "../bibliotheque/data";
import { loadPublicFiches } from "./data";
import PublicHeader from "./public-header";
import RechercheCatalogue from "./recherche";
import SelonConnexion from "../selon-connexion";
import DonneesStructurees from "../donnees-structurees";
import { RECOMMANDATIONS } from "./textes";

export async function generateMetadata(): Promise<Metadata> {
  const { t, langue } = await textes(RECOMMANDATIONS);
  const adresses = alternatives(langue, "/recommandations", LANGUES_CONTENU);
  return {
    title: t.catalogue.titreMeta,
    description: t.catalogue.descriptionMeta,
    alternates: adresses,
    robots: { index: contenuIndexable(langue), follow: INDEXABLE },
    openGraph: {
      title: t.catalogue.titreOg,
      description: t.catalogue.descriptionOg,
      url: adresses.canonical,
      siteName: "medical-guidelines.net",
      locale: t.catalogue.ogLocale,
      type: "website",
    },
    twitter: { card: "summary_large_image" },
  };
}

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

// Catalogue public des fiches : titres, sociétés et dates uniquement. Page
// mise en cache (identique pour tous), régénérée au plus toutes les 5 minutes
// ou dès qu'une fiche est publiée ou retirée (étiquette des fiches publiques).
export const revalidate = 300;

export default async function RecommandationsPage() {
  const { t, langue, lien, locale } = await textes(RECOMMANDATIONS);
  const tf = FICHE[langue];
  const fiches = await loadPublicFiches();
  const groups = groupBySection(fiches);

  return (
    <div className="min-h-screen bg-white text-slate-800">
      <PublicHeader />
      <DonneesStructurees
        data={{
          "@context": "https://schema.org",
          "@type": "CollectionPage",
          name: t.catalogue.titreOg,
          url: `${SITE_URL}${lien("/recommandations")}`,
          inLanguage: langue,
          mainEntity: {
            "@type": "ItemList",
            numberOfItems: fiches.length,
            itemListElement: fiches.map((f, i) => ({
              "@type": "ListItem",
              position: i + 1,
              name: f.card_json?.title ?? f.title,
              url: `${SITE_URL}${lien(`/recommandations/${ficheSlug(f.fiche_key)}`)}`,
            })),
          },
        }}
      />
      <main>
        <div className="bg-gradient-to-b from-[#EEF6FB] to-white">
          <div className="mx-auto max-w-5xl px-4 pb-6 pt-10 sm:px-6">
            <p className="text-sm font-semibold uppercase tracking-wide text-[#177E73]">{t.catalogue.surtitre}</p>
            <h1 className="mt-2 text-3xl font-bold text-[#0E3A78] sm:text-4xl">
              {plur(locale, fiches.length, t.catalogue.titre)}
            </h1>
            <p className="mt-3 max-w-2xl text-slate-600">{t.catalogue.texte}</p>
            {tf.enFrancais && <p className="mt-3 max-w-2xl text-sm text-slate-500">{tf.enFrancais}</p>}
            <SelonConnexion
              connecte={
                <Link
                  href={lien("/bibliotheque")}
                  className="mt-6 inline-block rounded-lg bg-[#0E3A78] px-6 py-3 font-semibold text-white hover:bg-[#0B2F63]"
                >
                  {t.ouvrirBibliotheque}
                </Link>
              }
              visiteur={
                <Link
                  href={lien("/inscription")}
                  className="mt-6 inline-block rounded-lg bg-[#0E3A78] px-6 py-3 font-semibold text-white hover:bg-[#0B2F63]"
                >
                  {t.creerCompteOffert}
                </Link>
              }
            />
            <RechercheCatalogue total={fiches.length} t={t.recherche} locale={locale} />
          </div>
        </div>

        <nav
          aria-label={t.catalogue.specialites}
          className="sticky top-0 z-10 border-y border-slate-200 bg-white/95 backdrop-blur"
        >
          <ul className="mx-auto flex max-w-5xl gap-2 overflow-x-auto px-4 py-2.5 sm:px-6">
            {groups.map(([section, list]) => (
              <li key={section} data-raccourci={ancre(section)} className="shrink-0">
                <a
                  href={`#${ancre(section)}`}
                  className="inline-flex items-center gap-1.5 rounded-full border border-slate-200 px-3 py-1.5 text-sm font-medium text-slate-700 hover:border-[#3AA8E0] hover:text-[#0E3A78]"
                >
                  {rubrique(section, langue).nom}
                  <span className="text-xs text-slate-500" data-compte={ancre(section)}>
                    {list.length}
                  </span>
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
                <Link href={lien(`/recommandations/specialite/${sectionSlug(section)}`)} className="hover:underline">
                  {rubrique(section, langue).nom}
                </Link>{" "}
                <span className="text-base font-medium text-slate-500">
                  (<span data-compte={ancre(section)}>{list.length}</span>)
                </span>
              </h2>
              <ul className="mt-4 divide-y divide-slate-100 overflow-hidden rounded-2xl ring-1 ring-slate-200">
                {list.map((fiche) => {
                  const titre = fiche.card_json?.title ?? fiche.title;
                  return (
                    <li key={fiche.id} data-q={motsCles(`${titre} ${fiche.title} ${fiche.societies.join(" ")}`)}>
                      <Link
                        href={lien(`/recommandations/${ficheSlug(fiche.fiche_key)}`)}
                        className="flex flex-col gap-1 px-4 py-3 hover:bg-slate-50 sm:flex-row sm:items-baseline sm:justify-between sm:gap-6"
                      >
                        <span className="font-medium text-slate-900">
                          {titre}
                          {fiche.freshness_status === "remplacee" && (
                            <span className="ms-2 rounded bg-amber-50 px-1.5 py-0.5 align-middle text-xs font-semibold text-amber-800">
                              {tf.remplacee}
                            </span>
                          )}
                          {fiche.freshness_status === "revision_detectee" && (
                            <span className="ms-2 rounded bg-amber-50 px-1.5 py-0.5 align-middle text-xs font-semibold text-amber-800">
                              {tf.revision}
                            </span>
                          )}
                        </span>
                        <span className="shrink-0 font-mono text-xs text-slate-500">
                          {[fiche.societies.slice(0, 3).join(" / "), formatDate(fiche.publication_date, locale)]
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
