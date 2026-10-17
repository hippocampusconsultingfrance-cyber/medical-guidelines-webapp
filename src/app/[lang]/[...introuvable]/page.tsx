import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { metadata as metadata404 } from "../not-found";

// Toute adresse sans page : la page 404 du site, dans la langue de l'adresse
// (src/app/[lang]/not-found.tsx), au lieu de la page anglaise de Next.js.
export const metadata: Metadata = metadata404;

export default function Introuvable() {
  notFound();
}
