"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { enregistrerPieceJointe, preparerDepot } from "./actions";

// Dépôt d'un PDF (pièce jointe d'une société, ou pièce jointe par défaut du
// modèle) : lien signé demandé au serveur, fichier envoyé directement au
// stockage, puis enregistré sur la demande.
export default function PieceJointe({ cible, actuelle }: { cible: string; actuelle: string | null }) {
  const router = useRouter();
  const [message, setMessage] = useState<string>("");
  const [enCours, setEnCours] = useState(false);

  async function deposer(fichier: File) {
    setEnCours(true);
    setMessage("Envoi du fichier…");
    try {
      const prep = await preparerDepot(cible, fichier.name);
      if (!prep.ok) return setMessage(prep.message);
      const { error } = await createClient()
        .storage.from("demandes-accord")
        .uploadToSignedUrl(prep.chemin, prep.jeton, fichier, { contentType: "application/pdf" });
      if (error) return setMessage(`Dépôt refusé : ${error.message}`);
      const r = await enregistrerPieceJointe(cible, prep.chemin, fichier.name);
      setMessage(r.message);
      if (r.ok) router.refresh();
    } finally {
      setEnCours(false);
    }
  }

  return (
    <div className="field">
      <label htmlFor={`pj-${cible}`}>{actuelle ? `Remplacer la pièce jointe (${actuelle})` : "Ajouter une pièce jointe (PDF, 15 Mo au plus)"}</label>
      <input
        id={`pj-${cible}`}
        type="file"
        accept="application/pdf"
        disabled={enCours}
        onChange={(e) => {
          const f = e.target.files?.[0];
          if (f) void deposer(f);
          e.target.value = "";
        }}
      />
      {message && (
        <div className="field__hint" role="status">
          {message}
        </div>
      )}
    </div>
  );
}
