import { textes } from "@/i18n/serveur";
import { AUTH } from "../textes-auth";
import FinaliserCompteForm from "./formulaire";

export default async function FinaliserComptePage() {
  const { t } = await textes(AUTH);
  return <FinaliserCompteForm t={t.finaliser} regle={t.regleMotDePasse} />;
}
