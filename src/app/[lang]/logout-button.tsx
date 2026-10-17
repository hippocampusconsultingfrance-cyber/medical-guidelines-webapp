import { seDeconnecter } from "./actions";

// Formulaire plutôt que bouton client : aucune bibliothèque Supabase à
// charger dans le navigateur pour la page d'accueil.
export default function LogoutButton() {
  return (
    <form action={seDeconnecter}>
      <button className="rounded-md border border-slate-300 px-3 py-1.5 text-sm text-slate-700 hover:bg-slate-50">
        Se déconnecter
      </button>
    </form>
  );
}
