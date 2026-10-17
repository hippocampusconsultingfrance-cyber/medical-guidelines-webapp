import Link from "next/link";
import { COMMUN } from "@/i18n/commun";
import { textes } from "@/i18n/serveur";
import Logo from "./logo";

// En-tête minimal (pages de compte, pages légales) : logo et retour à
// l'accueil, sans dépendre de la session.
export default async function EnteteSimple() {
  const { t, lien } = await textes(COMMUN);
  return (
    <header className="mx-auto flex max-w-5xl items-center justify-between gap-3 px-4 py-4 sm:px-6">
      <Link href={lien("/")} aria-label={t.entete.accueilAria}>
        <Logo />
      </Link>
      <Link href={lien("/")} className="whitespace-nowrap text-sm font-medium text-slate-600 hover:text-[#0E3A78]">
        {t.entete.accueil}
      </Link>
    </header>
  );
}
