import type { Metadata } from "next";
import Link from "next/link";
import Logo from "./logo";

export const metadata: Metadata = {
  title: "Page introuvable — medical-guidelines.net",
  robots: { index: false, follow: false },
};

// Page 404 aux couleurs du site (au lieu de la page anglaise de Next.js).
export default function NotFound() {
  return (
    <main className="mx-auto flex min-h-[70vh] max-w-xl flex-col items-center justify-center px-4 py-16 text-center">
      <Link href="/" aria-label="medical-guidelines.net, accueil">
        <Logo />
      </Link>
      <p className="mt-10 font-mono text-sm font-semibold uppercase tracking-wider text-[#2BB5A6]">Erreur 404</p>
      <h1 className="mt-2 text-3xl font-bold text-[#0E3A78]">Page introuvable</h1>
      <p className="mt-4 text-slate-600">
        Cette adresse ne correspond à aucune page. La fiche a peut-être changé de nom : retrouvez-la dans la
        liste des recommandations.
      </p>
      <div className="mt-8 flex flex-col gap-3 sm:flex-row">
        <Link
          href="/recommandations"
          className="rounded-lg bg-[#0E3A78] px-6 py-3 font-semibold text-white hover:bg-[#0B2F63]"
        >
          Voir les recommandations
        </Link>
        <Link
          href="/"
          className="rounded-lg border border-slate-300 bg-white px-6 py-3 font-semibold text-slate-800 hover:bg-slate-50"
        >
          Retour à l&apos;accueil
        </Link>
      </div>
    </main>
  );
}
