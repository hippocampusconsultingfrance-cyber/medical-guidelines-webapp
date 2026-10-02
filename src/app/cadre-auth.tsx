import Link from "next/link";
import Logo from "./logo";

// Cadre des pages de compte (connexion, inscription, mot de passe,
// finalisation, double authentification) : logo cliquable, retour à
// l'accueil, formulaire présenté dans une carte.
export default function CadreAuth({ children, large = false }: { children: React.ReactNode; large?: boolean }) {
  return (
    <div className="min-h-screen bg-gradient-to-b from-[#EEF6FB] to-white">
      <header className="mx-auto flex max-w-5xl items-center justify-between gap-3 px-4 py-4 sm:px-6">
        <Link href="/" aria-label="medical-guidelines.net, accueil">
          <Logo />
        </Link>
        <Link href="/" className="whitespace-nowrap text-sm font-medium text-slate-600 hover:text-[#0E3A78]">
          ← Accueil
        </Link>
      </header>
      <main className="px-4 pb-16 pt-4 sm:pt-10">
        <div
          className={`mx-auto w-full ${large ? "max-w-lg" : "max-w-md"} rounded-2xl bg-white px-6 py-8 shadow-sm ring-1 ring-slate-200 sm:px-8`}
        >
          {children}
        </div>
      </main>
    </div>
  );
}
