"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

// Bouton flottant présent sur toutes les pages de l'espace membre : ouvre le
// formulaire de suggestion en indiquant la page d'où il est envoyé.
export default function BoutonIdee() {
  const page = usePathname();
  return (
    <Link
      href={`/suggestions?page=${encodeURIComponent(page)}`}
      className="btn btn-primary btn-sm"
      style={{ position: "fixed", right: 16, bottom: 16, zIndex: 40, boxShadow: "0 4px 14px rgba(0,0,0,.15)" }}
    >
      💡 Une idée ? Un problème ?
    </Link>
  );
}
