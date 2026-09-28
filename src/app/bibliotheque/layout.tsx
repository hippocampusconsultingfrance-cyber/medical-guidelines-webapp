import { Archivo, IBM_Plex_Mono, Public_Sans } from "next/font/google";
import "./fiches.css";

// Polices de l'ancienne page, hébergées par le site (next/font) : aucun
// appel à Google Fonts depuis le navigateur.
const archivo = Archivo({ subsets: ["latin"], variable: "--font-archivo" });
const publicSans = Public_Sans({
  subsets: ["latin"],
  style: ["normal", "italic"],
  variable: "--font-public-sans",
});
const plexMono = IBM_Plex_Mono({ subsets: ["latin"], weight: ["500", "600"], variable: "--font-plex-mono" });

export default function BibliothequeLayout({ children }: LayoutProps<"/bibliotheque">) {
  return (
    <div className={`${archivo.variable} ${publicSans.variable} ${plexMono.variable}`}>{children}</div>
  );
}
