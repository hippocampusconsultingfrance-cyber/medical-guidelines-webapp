import { notFound } from "next/navigation";

// Toute adresse sans page : la page 404 du site, dans la langue de l'adresse
// (src/app/[lang]/not-found.tsx), au lieu de la page anglaise de Next.js.
export { generateMetadata } from "../not-found";

export default function Introuvable() {
  notFound();
}
