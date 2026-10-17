import type { Traductions } from "./serveur";

// Pages légales (CGU, CGV, confidentialité, mentions légales) : titres et
// mention de la traduction. Le texte français fait seul foi ; les autres
// langues en sont une traduction d'information (contenu-<langue>.tsx de
// chaque page).
export const JURIDIQUE: Traductions<{
  cgu: string;
  cgv: string;
  confidentialite: string;
  mentions: string;
  avis: string;
}> = {
  fr: {
    cgu: "Conditions Générales d'Utilisation — medical-guidelines.net",
    cgv: "Conditions Générales de Vente — medical-guidelines.net",
    confidentialite: "Politique de confidentialité — medical-guidelines.net",
    mentions: "Mentions légales — medical-guidelines.net",
    avis: "",
  },
  en: {
    cgu: "Terms of Use — medical-guidelines.net",
    cgv: "Terms of Sale — medical-guidelines.net",
    confidentialite: "Privacy Policy — medical-guidelines.net",
    mentions: "Legal notice — medical-guidelines.net",
    avis:
      "This English version is a translation provided for information only. Only the French version is legally binding; in the event of any discrepancy, the French version prevails.",
  },
};

export function AvisTraduction({ texte }: { texte: string }) {
  if (!texte) return null;
  return (
    <p role="note" className="mx-auto mt-8 max-w-3xl rounded-lg bg-amber-50 px-4 py-3 text-sm text-amber-900">
      {texte}
    </p>
  );
}
