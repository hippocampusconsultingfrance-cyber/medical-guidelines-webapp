"use client";

import { useState } from "react";

// Bloc repliable « Instruction pour corriger » avec bouton de copie.
export default function Instruction({ texte }: { texte: string }) {
  const [copie, setCopie] = useState(false);
  return (
    <details style={{ marginTop: 10 }}>
      <summary style={{ cursor: "pointer", fontWeight: 600 }}>Instruction pour corriger</summary>
      <pre
        style={{
          whiteSpace: "pre-wrap",
          fontSize: "0.8rem",
          background: "var(--surface-2, #f4f6f8)",
          border: "1px solid var(--border)",
          borderRadius: 8,
          padding: 10,
          marginTop: 8,
        }}
      >
        {texte}
      </pre>
      <button
        type="button"
        className="btn btn-ghost btn-sm"
        onClick={() =>
          navigator.clipboard.writeText(texte).then(
            () => setCopie(true),
            () => setCopie(false),
          )
        }
      >
        {copie ? "Copié ✓" : "Copier l'instruction"}
      </button>
      <span style={{ fontSize: "0.78rem", color: "var(--ink-muted)", marginLeft: 8 }}>
        À coller dans une conversation avec Claude.
      </span>
    </details>
  );
}
