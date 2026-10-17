"use client";

import { usePathname } from "next/navigation";
import { COOKIE_LANGUE, LANGUES_OUVERTES, NOMS_LANGUES, chemin, decouper } from "@/lib/langues";
import { useLangue } from "./client";

// Choix de la langue : la même page dans une autre langue, et le choix
// retenu (cookie « langue », cf. src/proxy.ts) pour les liens sans langue
// des e-mails. Liens ordinaires : la langue change la mise en page entière.
export default function ChoixLangue({ libelle, className = "" }: { libelle: string; className?: string }) {
  const actuelle = useLangue();
  const { reste } = decouper(usePathname() ?? "/");
  return (
    <nav aria-label={libelle} className={`flex flex-wrap items-center justify-center gap-x-3 gap-y-1 ${className}`}>
      {LANGUES_OUVERTES.map((l) => (
        <a
          key={l}
          href={chemin(l, reste)}
          lang={l}
          hrefLang={l}
          aria-current={l === actuelle ? "true" : undefined}
          onClick={() => {
            document.cookie = `${COOKIE_LANGUE}=${l}; path=/; max-age=31536000; samesite=lax`;
          }}
          className={l === actuelle ? "font-semibold text-[#0E3A78]" : "hover:underline"}
        >
          {NOMS_LANGUES[l]}
        </a>
      ))}
    </nav>
  );
}
