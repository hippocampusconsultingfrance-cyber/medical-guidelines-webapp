import { textes } from "@/i18n/serveur";
import { AUTH } from "../textes-auth";
import NouveauMotDePasseForm from "./formulaire";

// Atteinte après le lien de réinitialisation (voir /auth/callback) : la
// session est déjà ouverte, il ne reste qu'à enregistrer le mot de passe.
export default async function NouveauMotDePassePage() {
  const { t } = await textes(AUTH);
  return <NouveauMotDePasseForm t={t.nouveau} regle={t.regleMotDePasse} />;
}
