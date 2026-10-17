"use client";

import { useEffect } from "react";

function setAll(open: boolean) {
  document.querySelectorAll<HTMLDetailsElement>("details.acc").forEach((d) => (d.open = open));
}

// Boutons « Tout déplier / Tout replier » et ouverture automatique de la
// section visée par un lien du sommaire (#ancre).
export default function AccordionControls({ deplier, replier }: { deplier: string; replier: string }) {
  useEffect(() => {
    const openTarget = () => {
      const id = decodeURIComponent(window.location.hash.slice(1));
      const el = id ? document.getElementById(id) : null;
      if (el instanceof HTMLDetailsElement) {
        el.open = true;
        el.scrollIntoView({ block: "start" });
      }
    };
    openTarget();
    window.addEventListener("hashchange", openTarget);
    return () => window.removeEventListener("hashchange", openTarget);
  }, []);

  return (
    <div className="acc-controls">
      <button type="button" className="btn btn-ghost btn-sm" onClick={() => setAll(true)}>
        {deplier}
      </button>
      <button type="button" className="btn btn-ghost btn-sm" onClick={() => setAll(false)}>
        {replier}
      </button>
    </div>
  );
}
