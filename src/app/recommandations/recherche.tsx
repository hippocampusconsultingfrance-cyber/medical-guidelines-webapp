"use client";

import { useState } from "react";

const normaliser = (s: string) =>
  s
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase();

// Filtre instantané du catalogue public : masque les fiches (et les
// rubriques vides) dont le titre ou les sociétés ne contiennent pas tous les
// mots saisis. La liste complète reste rendue par le serveur (référencement,
// fonctionnement sans JavaScript).
export default function RechercheCatalogue({ total }: { total: number }) {
  const [q, setQ] = useState("");
  const [visibles, setVisibles] = useState(total);

  function filtrer(valeur: string) {
    setQ(valeur);
    const mots = normaliser(valeur).split(/\s+/).filter(Boolean);
    let n = 0;
    for (const section of document.querySelectorAll<HTMLElement>("[data-rubrique]")) {
      let dansRubrique = 0;
      for (const li of section.querySelectorAll<HTMLElement>("[data-q]")) {
        const ok = mots.every((m) => li.dataset.q!.includes(m));
        li.hidden = !ok;
        if (ok) dansRubrique++;
      }
      section.hidden = dansRubrique === 0;
      n += dansRubrique;
    }
    for (const lien of document.querySelectorAll<HTMLElement>("[data-raccourci]")) {
      const section = document.getElementById(lien.dataset.raccourci!);
      lien.hidden = Boolean(section?.hidden);
    }
    setVisibles(n);
  }

  return (
    <div className="mt-8">
      <label htmlFor="recherche" className="sr-only">
        Rechercher une recommandation
      </label>
      <div className="relative">
        <svg
          viewBox="0 0 24 24"
          className="pointer-events-none absolute left-3.5 top-1/2 h-5 w-5 -translate-y-1/2 text-slate-400"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
          strokeLinecap="round"
          aria-hidden="true"
        >
          <circle cx="11" cy="11" r="7" />
          <path d="m20 20-3.5-3.5" />
        </svg>
        <input
          id="recherche"
          type="search"
          value={q}
          onChange={(e) => filtrer(e.target.value)}
          placeholder="Rechercher : sepsis, ALR, SRLF, intubation…"
          autoComplete="off"
          className="w-full rounded-xl border border-slate-300 bg-white py-3 pl-11 pr-4 text-base text-slate-900 shadow-sm placeholder:text-slate-400 focus:border-[#3AA8E0] focus:outline-none focus:ring-2 focus:ring-[#3AA8E0]/30"
        />
      </div>
      <p className="mt-2 text-sm text-slate-500" role="status" aria-live="polite">
        {q ? (visibles ? `${visibles} fiche${visibles > 1 ? "s" : ""} trouvée${visibles > 1 ? "s" : ""}` : "Aucune fiche ne correspond à cette recherche.") : ""}
      </p>
    </div>
  );
}
