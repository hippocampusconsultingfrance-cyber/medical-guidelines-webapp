import { textes } from "@/i18n/serveur";
import { SECURITE } from "../compte/securite/textes";
import MfaForm from "./formulaire";

export default async function MfaPage() {
  const { t } = await textes(SECURITE);
  return <MfaForm t={t} />;
}
