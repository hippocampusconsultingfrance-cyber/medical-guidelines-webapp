import type { Metadata, Viewport } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import { Analytics } from "@vercel/analytics/next";
import "./globals.css";
import { SITE_URL } from "@/lib/seo";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  // Adresses absolues des images de partage (opengraph-image).
  metadataBase: new URL(SITE_URL),
  title: "Medical Guidelines",
  description:
    "Fiches de synthèse des recommandations professionnelles, pour le personnel médical et paramédical.",
  robots: { index: false, follow: false },
  icons: { apple: "/icones/180.png" },
  appleWebApp: { capable: true, title: "Guidelines", statusBarStyle: "default" },
  openGraph: { siteName: "medical-guidelines.net", locale: "fr_FR", type: "website" },
};

export const viewport: Viewport = { themeColor: "#0E3A78" };

// Les pages publiques listées dans src/proxy.ts sont mises en cache ; toutes
// les autres sont rendues à chaque requête avec le jeton CSP de la page
// (src/proxy.ts), appliqué par Next.js à ses propres scripts (elles lisent
// les cookies de session, ou le déclarent via RenduParRequete).
export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html
      lang="fr"
      className={`${geistSans.variable} ${geistMono.variable} h-full antialiased`}
    >
      <body className="min-h-full flex flex-col">
        <div className="flex-1">{children}</div>
        <footer className="border-t border-slate-200 px-6 py-4 text-center text-xs text-slate-500">
          <p className="mb-2 text-sm text-slate-700">
            <b>Société savante&nbsp;?</b> Devenez notre partenaire : accès PREMIUM offert, statistiques anonymes de lecture
            et signalements d&apos;erreurs sur vos fiches.{" "}
            <a href="/partenaires" className="font-semibold text-[#1A74A6] hover:underline">
              En savoir plus
            </a>
          </p>
          <p className="mb-2 text-sm text-slate-700">
            <b>Médecin&nbsp;?</b> Participez à la correction des fiches : accès gratuit au site et 5 accès offerts aux personnes de votre choix.{" "}
            <a href="/relecteurs" className="font-semibold text-[#1A74A6] hover:underline">
              Devenir relecteur
            </a>
          </p>
          <a href="/mentions-legales" className="hover:underline">
            Mentions légales
          </a>
          {" · "}
          <a href="/cgu" className="hover:underline">
            CGU
          </a>
          {" · "}
          <a href="/cgv" className="hover:underline">
            CGV
          </a>
          {" · "}
          <a href="/confidentialite" className="hover:underline">
            Confidentialité
          </a>
          {" · "}
          <a href="/corrections" className="hover:underline">
            Journal des corrections
          </a>
        </footer>
        {/* Mesure d'audience Vercel : sans cookies ni identifiant persistant. */}
        <Analytics />
      </body>
    </html>
  );
}
