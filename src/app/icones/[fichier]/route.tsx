import { ImageResponse } from "next/og";
import { LOGO_DATA_URI } from "@/lib/logo-svg";

// Icônes de l'application installée (écran d'accueil) : le logo du site
// (src/lib/logo-svg.ts) centré sur fond blanc, en PNG carré. Tailles : 180
// (iPhone), 192 et 512 (Android, manifeste), 48 (/favicon.ico, cf. next.config.ts).
const TAILLES: Record<string, number> = { "48.png": 48, "180.png": 180, "192.png": 192, "512.png": 512 };

export async function GET(_request: Request, { params }: { params: Promise<{ fichier: string }> }) {
  const taille = TAILLES[(await params).fichier];
  if (!taille) return new Response("Introuvable", { status: 404 });
  const src = LOGO_DATA_URI;
  const largeur = Math.round(taille * 0.72);
  return new ImageResponse(
    (
      <div style={{ width: "100%", height: "100%", display: "flex", alignItems: "center", justifyContent: "center", background: "#ffffff" }}>
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img src={src} width={largeur} height={Math.round((largeur * 84) / 120)} alt="" />
      </div>
    ),
    { width: taille, height: taille, headers: { "Cache-Control": "public, max-age=86400, immutable" } },
  );
}
