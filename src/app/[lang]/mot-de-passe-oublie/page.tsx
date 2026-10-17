import { textes } from "@/i18n/serveur";
import { AUTH } from "../textes-auth";
import MotDePasseOublieForm from "./formulaire";

export default async function MotDePasseOubliePage() {
  const { t } = await textes(AUTH);
  return <MotDePasseOublieForm t={t.oublie} />;
}
