"use client";

// Coche ou décoche toutes les fiches de la liste.
export default function ToutCocher() {
  const basculer = (valeur: boolean) =>
    document.querySelectorAll<HTMLInputElement>("input[name=ids]").forEach((c) => (c.checked = valeur));
  return (
    <span style={{ display: "inline-flex", gap: 8 }}>
      <button type="button" className="btn btn-ghost btn-sm" onClick={() => basculer(true)}>
        Tout cocher
      </button>
      <button type="button" className="btn btn-ghost btn-sm" onClick={() => basculer(false)}>
        Tout décocher
      </button>
    </span>
  );
}
