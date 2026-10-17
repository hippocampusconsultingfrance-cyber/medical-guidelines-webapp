import type { Metadata } from "next";
import { textes } from "@/i18n/serveur";
import AccueilPublic from "./accueil-public";
import DonneesStructurees from "./donnees-structurees";
import { loadPublicFiches } from "./recommandations/data";
import { ACCUEIL } from "./textes-accueil";
import { INDEXABLE, SITE_URL, alternatives } from "@/lib/seo";

export async function generateMetadata(): Promise<Metadata> {
  const { t, langue } = await textes(ACCUEIL);
  const adresses = alternatives(langue, "/");
  return {
    title: t.titreMeta,
    description: t.descriptionMeta,
    alternates: adresses,
    robots: { index: INDEXABLE, follow: INDEXABLE },
    openGraph: {
      title: t.titreMeta,
      description: t.descriptionMeta,
      url: adresses.canonical,
      siteName: "medical-guidelines.net",
      locale: t.ogLocale,
      type: "website",
    },
    twitter: { card: "summary_large_image" },
  };
}

// Accueil public, mis en cache (identique pour tous les visiteurs) et
// régénéré au plus toutes les 5 minutes. Un membre connecté reçoit à la
// place son espace (src/app/espace, servi à la même adresse par le proxy).
export const revalidate = 300;

export default async function Home() {
  const { langue } = await textes(ACCUEIL);
  // Les plus récentes d'abord (ordre de loadPublicFiches).
  const recentes = await loadPublicFiches(undefined, 4);
  return (
    <>
      <DonneesStructurees
        data={{
          "@context": "https://schema.org",
          "@graph": [
            {
              "@type": "Organization",
              "@id": `${SITE_URL}/#organisation`,
              name: "medical-guidelines.net",
              url: SITE_URL,
              logo: `${SITE_URL}/icones/512.png`,
              email: "contact@medical-guidelines.net",
            },
            {
              "@type": "WebSite",
              "@id": `${SITE_URL}/#site`,
              name: "medical-guidelines.net",
              url: SITE_URL,
              inLanguage: langue,
              publisher: { "@id": `${SITE_URL}/#organisation` },
            },
          ],
        }}
      />
      <AccueilPublic recentes={recentes} />
    </>
  );
}
