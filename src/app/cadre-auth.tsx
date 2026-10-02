import EnteteSimple from "./entete-simple";

// Cadre des pages de compte (connexion, inscription, mot de passe,
// finalisation, double authentification) : logo cliquable, retour à
// l'accueil, formulaire présenté dans une carte.
export default function CadreAuth({ children, large = false }: { children: React.ReactNode; large?: boolean }) {
  return (
    <div className="min-h-screen bg-gradient-to-b from-[#EEF6FB] to-white">
      <EnteteSimple />
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
