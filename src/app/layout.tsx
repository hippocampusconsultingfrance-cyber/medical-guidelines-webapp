import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import { Analytics } from "@vercel/analytics/next";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "Medical Guidelines",
  description:
    "Fiches de synthèse des recommandations professionnelles, pour le personnel médical et paramédical.",
  robots: { index: false, follow: false },
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html
      lang="fr"
      className={`${geistSans.variable} ${geistMono.variable} h-full antialiased`}
    >
      <body className="min-h-full flex flex-col">
        <div className="flex-1">{children}</div>
        <footer className="border-t border-slate-200 px-6 py-4 text-center text-xs text-slate-500">
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
        </footer>
        {/* Mesure d'audience Vercel : sans cookies ni identifiant persistant. */}
        <Analytics />
      </body>
    </html>
  );
}
