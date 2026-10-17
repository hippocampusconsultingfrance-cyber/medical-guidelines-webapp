import { textes } from "@/i18n/serveur";
import { AUTH } from "../../textes-auth";
import RetourLien from "./retour";

export default async function AuthCallbackPage() {
  const { t } = await textes(AUTH);
  return <RetourLien t={t.retour} />;
}
