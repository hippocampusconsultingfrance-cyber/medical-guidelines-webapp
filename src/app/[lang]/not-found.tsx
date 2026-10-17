import type { Metadata } from "next";
import Link from "next/link";
import { COMMUN } from "@/i18n/commun";
import { textes } from "@/i18n/serveur";
import Logo from "./logo";

export async function generateMetadata(): Promise<Metadata> {
  const { t } = await textes(COMMUN);
  return { title: t.introuvable.titreMeta, robots: { index: false, follow: false } };
}

// Page 404 aux couleurs du site (au lieu de la page anglaise de Next.js).
export default async function NotFound() {
  const { t, lien } = await textes(COMMUN);
  return (
    <main className="mx-auto flex min-h-[70vh] max-w-xl flex-col items-center justify-center px-4 py-16 text-center">
      <Link href={lien("/")} aria-label={t.entete.accueilAria}>
        <Logo />
      </Link>
      <p className="mt-10 font-mono text-sm font-semibold uppercase tracking-wider text-[#177E73]">{t.introuvable.surtitre}</p>
      <h1 className="mt-2 text-3xl font-bold text-[#0E3A78]">{t.introuvable.titre}</h1>
      <p className="mt-4 text-slate-600">{t.introuvable.texte}</p>
      <div className="mt-8 flex flex-col gap-3 sm:flex-row">
        <Link
          href={lien("/recommandations")}
          className="rounded-lg bg-[#0E3A78] px-6 py-3 font-semibold text-white hover:bg-[#0B2F63]"
        >
          {t.introuvable.recommandations}
        </Link>
        <Link
          href={lien("/")}
          className="rounded-lg border border-slate-300 bg-white px-6 py-3 font-semibold text-slate-800 hover:bg-slate-50"
        >
          {t.introuvable.accueil}
        </Link>
      </div>
    </main>
  );
}
