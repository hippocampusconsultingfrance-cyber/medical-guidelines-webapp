import { COMMUN } from "@/i18n/commun";
import { textes } from "@/i18n/serveur";
import { seDeconnecter } from "./actions";

// Formulaire plutôt que bouton client : aucune bibliothèque Supabase à
// charger dans le navigateur pour la page d'accueil.
export default async function LogoutButton() {
  const { t } = await textes(COMMUN);
  return (
    <form action={seDeconnecter}>
      <button className="rounded-md border border-slate-300 px-3 py-1.5 text-sm text-slate-700 hover:bg-slate-50">
        {t.deconnexion}
      </button>
    </form>
  );
}
