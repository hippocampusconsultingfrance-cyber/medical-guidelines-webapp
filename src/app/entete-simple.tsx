import Link from "next/link";
import Logo from "./logo";

// En-tête minimal (pages de compte, pages légales) : logo et retour à
// l'accueil, sans dépendre de la session.
export default function EnteteSimple() {
  return (
    <header className="mx-auto flex max-w-5xl items-center justify-between gap-3 px-4 py-4 sm:px-6">
      <Link href="/" aria-label="medical-guidelines.net, accueil">
        <Logo />
      </Link>
      <Link href="/" className="whitespace-nowrap text-sm font-medium text-slate-600 hover:text-[#0E3A78]">
        ← Accueil
      </Link>
    </header>
  );
}
