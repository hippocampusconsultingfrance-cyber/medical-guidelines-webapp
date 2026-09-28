"use client";

// Bouton « menu » de la version mobile : ouvre et ferme la barre latérale.
export default function MenuToggle() {
  return (
    <div className="menu-toggle">
      <button
        type="button"
        aria-label="Menu"
        onClick={() => document.getElementById("sidebar")?.classList.toggle("is-open")}
      >
        ☰
      </button>
      medical-guidelines.net
    </div>
  );
}
