import Link from "next/link";
import { textes } from "@/i18n/serveur";
import Logo from "../logo";
import SelonConnexion from "../selon-connexion";
import { RECOMMANDATIONS } from "./textes";

// En-tête des pages publiques : logo et accès au compte (choisi dans le
// navigateur, cf. SelonConnexion : les pages publiques sont mises en cache).
export default async function PublicHeader() {
  const { t, lien } = await textes(RECOMMANDATIONS);
  return (
    <header className="border-b border-slate-200 bg-white">
      <div className="mx-auto flex max-w-5xl items-center justify-between gap-3 px-4 py-3 sm:px-6">
        <Link href={lien("/")} aria-label={t.entete.accueilAria}>
          <Logo />
        </Link>
        <nav aria-label={t.entete.compte} className="flex items-center gap-1 text-sm sm:gap-2">
          <SelonConnexion
            connecte={
              <Link
                href={lien("/bibliotheque")}
                className="whitespace-nowrap rounded-lg bg-[#0E3A78] px-4 py-2 font-semibold text-white hover:bg-[#0B2F63]"
              >
                {t.entete.bibliotheque}
              </Link>
            }
            visiteur={
              <>
                <Link
                  href={lien("/connexion")}
                  className="whitespace-nowrap rounded-lg px-2 py-2 font-medium text-slate-700 hover:bg-slate-100 sm:px-3"
                >
                  {t.entete.seConnecter}
                </Link>
                <Link
                  href={lien("/inscription")}
                  className="hidden whitespace-nowrap rounded-lg bg-[#0E3A78] px-4 py-2 font-semibold text-white hover:bg-[#0B2F63] sm:inline-block"
                >
                  {t.entete.creerCompte}
                </Link>
              </>
            }
          />
        </nav>
      </div>
    </header>
  );
}
