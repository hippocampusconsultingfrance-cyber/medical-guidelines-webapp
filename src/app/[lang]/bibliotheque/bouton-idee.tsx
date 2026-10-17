"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useLien } from "@/i18n/client";

// Bouton flottant présent sur toutes les pages de l'espace membre : ouvre le
// formulaire de suggestion en indiquant la page d'où il est envoyé.
export default function BoutonIdee({ libelle }: { libelle: string }) {
  const page = usePathname();
  const lien = useLien();
  return (
    <Link
      href={lien(`/suggestions?page=${encodeURIComponent(page)}`)}
      className="btn btn-primary btn-sm"
      style={{ position: "fixed", right: 16, bottom: 16, zIndex: 40, boxShadow: "0 4px 14px rgba(0,0,0,.15)" }}
    >
      {libelle}
    </Link>
  );
}
