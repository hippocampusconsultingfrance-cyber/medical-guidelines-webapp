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
  es: {
    cgu: "Condiciones de uso — medical-guidelines.net",
    cgv: "Condiciones de venta — medical-guidelines.net",
    confidentialite: "Política de privacidad — medical-guidelines.net",
    mentions: "Aviso legal — medical-guidelines.net",
    avis:
      "Esta versión en español es una traducción facilitada solo a título informativo. Únicamente la versión francesa tiene valor jurídico; en caso de discrepancia, prevalece la versión francesa.",
  },
  de: {
    cgu: "Nutzungsbedingungen — medical-guidelines.net",
    cgv: "Verkaufsbedingungen — medical-guidelines.net",
    confidentialite: "Datenschutzerklärung — medical-guidelines.net",
    mentions: "Impressum — medical-guidelines.net",
    avis:
      "Diese deutsche Fassung ist eine Übersetzung, die nur zur Information dient. Rechtsverbindlich ist allein die französische Fassung; bei Abweichungen geht die französische Fassung vor.",
  },
  ar: {
    cgu: "شروط الاستخدام — medical-guidelines.net",
    cgv: "شروط البيع — medical-guidelines.net",
    confidentialite: "سياسة الخصوصية — medical-guidelines.net",
    mentions: "البيانات القانونية — medical-guidelines.net",
    avis:
      "هذه النسخة العربية ترجمة مقدَّمة للعلم فقط. النسخة الفرنسية وحدها هي الملزمة قانونًا، وفي حال وجود أي اختلاف تسود النسخة الفرنسية.",
  },
  zh: {
    cgu: "使用条款 — medical-guidelines.net",
    cgv: "销售条款 — medical-guidelines.net",
    confidentialite: "隐私政策 — medical-guidelines.net",
    mentions: "法律声明 — medical-guidelines.net",
    avis: "本中文版本为仅供参考的译文。只有法文版本具有法律约束力；如有任何不一致，以法文版本为准。",
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
