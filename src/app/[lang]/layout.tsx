import type { Metadata, Viewport } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import { Analytics } from "@vercel/analytics/next";
import "../globals.css";
import { notFound } from "next/navigation";
import ChoixLangue from "@/i18n/choix-langue";
import { COMMUN } from "@/i18n/commun";
import { riche } from "@/i18n/format";
import { textes } from "@/i18n/serveur";
import { LANGUES_OUVERTES, chemin, direction, estOuverte } from "@/lib/langues";
import { SITE_URL } from "@/lib/seo";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export async function generateMetadata(): Promise<Metadata> {
  const { t } = await textes(COMMUN);
  return {
    // Adresses absolues des images de partage (opengraph-image).
    metadataBase: new URL(SITE_URL),
    title: "Medical Guidelines",
    description: t.meta.description,
    robots: { index: false, follow: false },
    icons: { apple: "/icones/180.png" },
    appleWebApp: { capable: true, title: "Guidelines", statusBarStyle: "default" },
    openGraph: { siteName: "medical-guidelines.net", locale: t.meta.ogLocale, type: "website" },
  };
}

export const viewport: Viewport = { themeColor: "#0E3A78" };

// Les pages publiques listées dans src/proxy.ts sont mises en cache ; toutes
// les autres sont rendues à chaque requête avec le jeton CSP de la page
// (src/proxy.ts), appliqué par Next.js à ses propres scripts (elles lisent
// les cookies de session, ou le déclarent via RenduParRequete).
// Une mise en page par langue ouverte (src/lib/langues.ts) ; src/proxy.ts
// n'envoie ici que des langues ouvertes.
export function generateStaticParams() {
  return LANGUES_OUVERTES.map((lang) => ({ lang }));
}

export default async function RootLayout({ children, params }: LayoutProps<"/[lang]">) {
  const { lang } = await params;
  if (!estOuverte(lang)) notFound();
  const t = COMMUN[lang];
  const lien = (p: string) => chemin(lang, p);
  return (
    <html
      lang={lang}
      dir={direction(lang)}
      className={`${geistSans.variable} ${geistMono.variable} h-full antialiased`}
    >
      <body className="min-h-full flex flex-col">
        <div className="flex-1">{children}</div>
        <footer className="border-t border-slate-200 px-6 py-4 text-center text-xs text-slate-500">
          <p className="mb-2 text-sm text-slate-700">
            {riche(t.pied.societe, { b: (c) => <b>{c}</b> })}{" "}
            <a href={lien("/partenaires")} className="font-semibold text-[#1A74A6] hover:underline">
              {t.pied.societeLien}
            </a>
          </p>
          <p className="mb-2 text-sm text-slate-700">
            {riche(t.pied.medecin, { b: (c) => <b>{c}</b> })}{" "}
            <a href={lien("/relecteurs")} className="font-semibold text-[#1A74A6] hover:underline">
              {t.pied.medecinLien}
            </a>
          </p>
          <a href={lien("/mentions-legales")} className="hover:underline">
            {t.pied.mentions}
          </a>
          {" · "}
          <a href={lien("/cgu")} className="hover:underline">
            {t.pied.cgu}
          </a>
          {" · "}
          <a href={lien("/cgv")} className="hover:underline">
            {t.pied.cgv}
          </a>
          {" · "}
          <a href={lien("/confidentialite")} className="hover:underline">
            {t.pied.confidentialite}
          </a>
          {" · "}
          <a href={lien("/corrections")} className="hover:underline">
            {t.pied.corrections}
          </a>
          <ChoixLangue libelle={t.pied.langues} className="mt-3" />
        </footer>
        {/* Mesure d'audience Vercel : sans cookies ni identifiant persistant. */}
        <Analytics />
      </body>
    </html>
  );
}
