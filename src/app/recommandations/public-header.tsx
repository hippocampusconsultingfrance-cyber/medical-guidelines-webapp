import Link from "next/link";
import Logo from "../logo";
import SelonConnexion from "../selon-connexion";

// En-tête des pages publiques : logo et accès au compte (choisi dans le
// navigateur, cf. SelonConnexion : les pages publiques sont mises en cache).
export default function PublicHeader() {
  return (
    <header className="border-b border-slate-200 bg-white">
      <div className="mx-auto flex max-w-5xl items-center justify-between gap-3 px-4 py-3 sm:px-6">
        <Link href="/" aria-label="medical-guidelines.net, accueil">
          <Logo />
        </Link>
        <nav aria-label="Compte" className="flex items-center gap-1 text-sm sm:gap-2">
          <SelonConnexion
            connecte={
              <Link
                href="/bibliotheque"
                className="whitespace-nowrap rounded-lg bg-[#0E3A78] px-4 py-2 font-semibold text-white hover:bg-[#0B2F63]"
              >
                Ma bibliothèque
              </Link>
            }
            visiteur={
              <>
                <Link href="/connexion" className="whitespace-nowrap rounded-lg px-2 py-2 font-medium text-slate-700 hover:bg-slate-100 sm:px-3">
                  Se connecter
                </Link>
                <Link
                  href="/inscription"
                  className="hidden whitespace-nowrap rounded-lg bg-[#0E3A78] px-4 py-2 font-semibold text-white hover:bg-[#0B2F63] sm:inline-block"
                >
                  Créer un compte
                </Link>
              </>
            }
          />
        </nav>
      </div>
    </header>
  );
}
