import type { Metadata } from "next";
import AccueilPublic from "./accueil-public";
import DonneesStructurees from "./donnees-structurees";
import { loadPublicFiches } from "./recommandations/data";
import { INDEXABLE, SITE_URL } from "@/lib/seo";

const TITRE = "medical-guidelines.net — Recommandations médicales et paramédicales en fiches";
const DESCRIPTION =
  "Les recommandations des sociétés savantes en fiches claires et sourcées, grades conservés, pour les médecins et les professionnels paramédicaux. 5 fiches gratuites.";

export const metadata: Metadata = {
  title: TITRE,
  description: DESCRIPTION,
  alternates: { canonical: SITE_URL },
  robots: { index: INDEXABLE, follow: INDEXABLE },
  openGraph: { title: TITRE, description: DESCRIPTION, url: SITE_URL, siteName: "medical-guidelines.net", locale: "fr_FR", type: "website" },
  twitter: { card: "summary_large_image" },
};

// Accueil public, mis en cache (identique pour tous les visiteurs) et
// régénéré au plus toutes les 5 minutes. Un membre connecté reçoit à la
// place son espace (src/app/espace, servi à la même adresse par le proxy).
export const revalidate = 300;

export default async function Home() {
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
              inLanguage: "fr",
              publisher: { "@id": `${SITE_URL}/#organisation` },
            },
          ],
        }}
      />
      <AccueilPublic recentes={recentes} />
    </>
  );
}
