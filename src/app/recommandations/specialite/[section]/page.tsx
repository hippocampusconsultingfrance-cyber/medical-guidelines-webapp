import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { formatDate } from "@/lib/fiches";
import { INDEXABLE, SITE_URL, ficheSlug, sectionLibelle, sectionSlug } from "@/lib/seo";
import { groupBySection } from "../../../bibliotheque/data";
import { loadPublicFiches } from "../../data";
import PublicHeader from "../../public-header";
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

const pluriel = (n: number, mot: string) => `${n} ${mot}${n > 1 ? "s" : ""}`;

async function rubrique(slug: string) {
  const groups = groupBySection(await loadPublicFiches());
  return groups.find(([section]) => sectionSlug(section) === slug) ?? null;
}

export async function generateMetadata({ params }: PageProps<"/recommandations/specialite/[section]">): Promise<Metadata> {
  const { section: slug } = await params;
  const trouvee = await rubrique(slug);
  if (!trouvee) return { title: "Spécialité introuvable — medical-guidelines.net" };
  const [section, list] = trouvee;
  const libelle = sectionLibelle(section);
  const societes = [...new Set(list.flatMap((f) => f.societies))].slice(0, 5).join(", ");
  const title = `Recommandations en ${libelle} : ${pluriel(list.length, "fiche")} de synthèse | medical-guidelines.net`;
  const description = `Les recommandations en ${libelle} des sociétés savantes françaises (${societes}…) en fiches de synthèse indépendantes, sourcées, grades conservés, de la plus récente à la plus ancienne.`;
  const url = `${SITE_URL}/recommandations/specialite/${slug}`;
  return {
    title,
    description,
    alternates: { canonical: url },
    robots: { index: INDEXABLE, follow: INDEXABLE },
    openGraph: { title, description, url, siteName: "medical-guidelines.net", locale: "fr_FR", type: "website" },
    twitter: { card: "summary_large_image" },
  };
}

export default async function SpecialitePage({ params }: PageProps<"/recommandations/specialite/[section]">) {
  const { section: slug } = await params;
  const trouvee = await rubrique(slug);
  if (!trouvee) notFound();
  const [section, list] = trouvee;
  const libelle = sectionLibelle(section);
  const recentes = list.filter((f) => f.publication_date && f.publication_date >= "2020-01-01").length;
  const url = `${SITE_URL}/recommandations/specialite/${slug}`;

  return (
    <div className="min-h-screen bg-white text-slate-800">
      <PublicHeader />
      <DonneesStructurees
        data={{
          "@context": "https://schema.org",
          "@type": "CollectionPage",
          name: `Recommandations en ${libelle}`,
          url,
          inLanguage: "fr",
          mainEntity: {
            "@type": "ItemList",
            numberOfItems: list.length,
            itemListElement: list.map((f, i) => ({
              "@type": "ListItem",
              position: i + 1,
              name: f.card_json?.title ?? f.title,
              url: `${SITE_URL}/recommandations/${ficheSlug(f.fiche_key)}`,
            })),
          },
        }}
      />
      <DonneesStructurees
        data={{
          "@context": "https://schema.org",
          "@type": "BreadcrumbList",
          itemListElement: [
            { "@type": "ListItem", position: 1, name: "Accueil", item: SITE_URL },
            { "@type": "ListItem", position: 2, name: "Recommandations", item: `${SITE_URL}/recommandations` },
            { "@type": "ListItem", position: 3, name: section, item: url },
          ],
        }}
      />
      <main>
        <div className="bg-gradient-to-b from-[#EEF6FB] to-white">
          <div className="mx-auto max-w-5xl px-4 pb-8 pt-10 sm:px-6">
            <p className="text-sm">
              <Link href="/recommandations" className="text-[#1A74A6] underline">
                ← Toutes les spécialités
              </Link>
            </p>
            <h1 className="mt-4 text-3xl font-bold text-[#0E3A78] sm:text-4xl">Recommandations en {libelle}</h1>
            <p className="mt-3 max-w-2xl text-slate-600">
              {pluriel(list.length, "recommandation")} des sociétés savantes françaises en fiches de synthèse
              indépendantes{recentes > 0 ? `, dont ${recentes} publiée${recentes > 1 ? "s" : ""} depuis 2020` : ""}. Chaque fiche garde les grades de la source et renvoie au document
              officiel ; elle n&apos;est ni éditée ni validée par les sociétés savantes.
            </p>
            <SelonConnexion
              connecte={
                <Link
                  href="/bibliotheque"
                  className="mt-6 inline-block rounded-lg bg-[#0E3A78] px-6 py-3 font-semibold text-white hover:bg-[#0B2F63]"
                >
                  Ouvrir ma bibliothèque
                </Link>
              }
              visiteur={
                <Link
                  href="/inscription"
                  className="mt-6 inline-block rounded-lg bg-[#0E3A78] px-6 py-3 font-semibold text-white hover:bg-[#0B2F63]"
                >
                  Créer un compte gratuit : 5 fiches offertes
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
                  href={`/recommandations/${ficheSlug(fiche.fiche_key)}`}
                  className="flex flex-col gap-1 px-4 py-3 hover:bg-slate-50 sm:flex-row sm:items-baseline sm:justify-between sm:gap-6"
                >
                  <span className="font-medium text-slate-900">
                    {fiche.card_json?.title ?? fiche.title}
                    {fiche.freshness_status === "remplacee" && (
                      <span className="ml-2 rounded bg-amber-50 px-1.5 py-0.5 align-middle text-xs font-semibold text-amber-800">
                        Remplacée
                      </span>
                    )}
                    {fiche.freshness_status === "revision_detectee" && (
                      <span className="ml-2 rounded bg-amber-50 px-1.5 py-0.5 align-middle text-xs font-semibold text-amber-800">
                        Révision en cours
                      </span>
                    )}
                  </span>
                  <span className="shrink-0 font-mono text-xs text-slate-500">
                    {[fiche.societies.slice(0, 3).join(" / "), formatDate(fiche.publication_date)].filter(Boolean).join(" · ")}
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
