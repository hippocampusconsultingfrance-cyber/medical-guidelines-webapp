import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { FICHE } from "@/i18n/fiche";
import { fmt, plur } from "@/i18n/format";
import { rubrique } from "@/i18n/rubriques";
import { textes } from "@/i18n/serveur";
import { formatDate } from "@/lib/fiches";
import { INDEXABLE, LANGUES_CONTENU, SITE_URL, alternatives, contenuIndexable, ficheSlug, sectionSlug } from "@/lib/seo";
import { groupBySection } from "../../../bibliotheque/data";
import { loadPublicFiches } from "../../data";
import PublicHeader from "../../public-header";
import { RECOMMANDATIONS } from "../../textes";
import DonneesStructurees from "../../../donnees-structurees";
import SelonConnexion from "../../../selon-connexion";

// Page d'entrée d'une spécialité : les fiches d'une rubrique du catalogue,
// de la plus récente à la plus ancienne, avec leurs sociétés et dates.
// Titres, sociétés et dates uniquement, comme le catalogue.
// Pages mises en cache comme le catalogue (5 minutes au plus).
export const revalidate = 300;
export function generateStaticParams() {
  return [];
}

async function trouver(slug: string) {
  const groups = groupBySection(await loadPublicFiches());
  return groups.find(([section]) => sectionSlug(section) === slug) ?? null;
}

export async function generateMetadata({ params }: PageProps<"/[lang]/recommandations/specialite/[section]">): Promise<Metadata> {
  const { section: slug } = await params;
  const { t, langue, locale } = await textes(RECOMMANDATIONS);
  const trouvee = await trouver(slug);
  if (!trouvee) return { title: t.specialite.introuvable };
  const [section, list] = trouvee;
  const libelle = rubrique(section, langue).phrase;
  const societes = [...new Set(list.flatMap((f) => f.societies))].slice(0, 5).join(", ");
  const title = fmt(t.specialite.titreMeta, { libelle, fiches: plur(locale, list.length, FICHE[langue].fiches) });
  const description = fmt(t.specialite.descriptionMeta, { libelle, societes });
  const adresses = alternatives(langue, `/recommandations/specialite/${slug}`, LANGUES_CONTENU);
  return {
    title,
    description,
    alternates: adresses,
    robots: { index: contenuIndexable(langue), follow: INDEXABLE },
    openGraph: { title, description, url: adresses.canonical, siteName: "medical-guidelines.net", locale: t.catalogue.ogLocale, type: "website" },
    twitter: { card: "summary_large_image" },
  };
}

export default async function SpecialitePage({ params }: PageProps<"/[lang]/recommandations/specialite/[section]">) {
  const { section: slug } = await params;
  const { t, langue, lien, locale } = await textes(RECOMMANDATIONS);
  const tf = FICHE[langue];
  const trouvee = await trouver(slug);
  if (!trouvee) notFound();
  const [section, list] = trouvee;
  const { nom, phrase: libelle } = rubrique(section, langue);
  const recentes = list.filter((f) => f.publication_date && f.publication_date >= "2020-01-01").length;
  const url = `${SITE_URL}${lien(`/recommandations/specialite/${slug}`)}`;

  return (
    <div className="min-h-screen bg-white text-slate-800">
      <PublicHeader />
      <DonneesStructurees
        data={{
          "@context": "https://schema.org",
          "@type": "CollectionPage",
          name: fmt(t.specialite.titre, { libelle }),
          url,
          inLanguage: langue,
          mainEntity: {
            "@type": "ItemList",
            numberOfItems: list.length,
            itemListElement: list.map((f, i) => ({
              "@type": "ListItem",
              position: i + 1,
              name: f.card_json?.title ?? f.title,
              url: `${SITE_URL}${lien(`/recommandations/${ficheSlug(f.fiche_key)}`)}`,
            })),
          },
        }}
      />
      <DonneesStructurees
        data={{
          "@context": "https://schema.org",
          "@type": "BreadcrumbList",
          itemListElement: [
            { "@type": "ListItem", position: 1, name: t.accueil, item: alternatives(langue, "/").canonical },
            { "@type": "ListItem", position: 2, name: t.recommandations, item: `${SITE_URL}${lien("/recommandations")}` },
            { "@type": "ListItem", position: 3, name: nom, item: url },
          ],
        }}
      />
      <main>
        <div className="bg-gradient-to-b from-[#EEF6FB] to-white">
          <div className="mx-auto max-w-5xl px-4 pb-8 pt-10 sm:px-6">
            <p className="text-sm">
              <Link href={lien("/recommandations")} className="text-[#1A74A6] underline">
                {t.specialite.retour}
              </Link>
            </p>
            <h1 className="mt-4 text-3xl font-bold text-[#0E3A78] sm:text-4xl">{fmt(t.specialite.titre, { libelle })}</h1>
            <p className="mt-3 max-w-2xl text-slate-600">
              {plur(locale, list.length, t.specialite.texte)}
              {recentes > 0 ? plur(locale, recentes, t.specialite.dontRecentes) : ""}
              {t.specialite.texteFin}
            </p>
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
          </div>
        </div>

        <div className="mx-auto max-w-5xl px-4 pb-16 sm:px-6">
          <ul className="mt-4 divide-y divide-slate-100 overflow-hidden rounded-2xl ring-1 ring-slate-200">
            {list.map((fiche) => (
              <li key={fiche.id}>
                <Link
                  href={lien(`/recommandations/${ficheSlug(fiche.fiche_key)}`)}
                  className="flex flex-col gap-1 px-4 py-3 hover:bg-slate-50 sm:flex-row sm:items-baseline sm:justify-between sm:gap-6"
                >
                  <span className="font-medium text-slate-900">
                    {fiche.card_json?.title ?? fiche.title}
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
                    {[fiche.societies.slice(0, 3).join(" / "), formatDate(fiche.publication_date, locale)].filter(Boolean).join(" · ")}
                  </span>
                </Link>
              </li>
            ))}
          </ul>
        </div>
      </main>
    </div>
  );
}
