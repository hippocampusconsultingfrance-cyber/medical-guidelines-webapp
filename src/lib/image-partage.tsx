import { ImageResponse } from "next/og";
import { LOGO_DATA_URI } from "@/lib/logo-svg";

// Image de partage (LinkedIn, messageries…) 1200 × 630 aux couleurs du site :
// logo, surtitre, titre et pied de page.
export const TAILLE_PARTAGE = { width: 1200, height: 630 };

export function imagePartage({ surtitre, titre, pied }: { surtitre: string; titre: string; pied: string }) {
  const long = titre.length > 90;
  return new ImageResponse(
    (
      <div
        style={{
          width: "100%",
          height: "100%",
          display: "flex",
          flexDirection: "column",
          justifyContent: "space-between",
          padding: "64px 72px",
          background: "linear-gradient(160deg, #EEF6FB 0%, #FFFFFF 60%)",
          borderBottom: "14px solid #0E3A78",
        }}
      >
        <div style={{ display: "flex", alignItems: "center", gap: 20 }}>
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src={LOGO_DATA_URI} width={96} height={67} alt="" />
          <div style={{ display: "flex", fontSize: 38, fontWeight: 700, color: "#0E3A78" }}>
            medical-guidelines<span style={{ color: "#3AA8E0" }}>.net</span>
          </div>
        </div>
        <div style={{ display: "flex", flexDirection: "column", gap: 18 }}>
          <div style={{ display: "flex", fontSize: 26, fontWeight: 700, letterSpacing: 2, textTransform: "uppercase", color: "#177E73" }}>
            {surtitre}
          </div>
          <div style={{ display: "flex", fontSize: long ? 50 : 62, fontWeight: 700, lineHeight: 1.12, color: "#0E3A78" }}>
            {titre.length > 150 ? `${titre.slice(0, 147)}…` : titre}
          </div>
        </div>
        <div style={{ display: "flex", fontSize: 26, color: "#475569" }}>{pied}</div>
      </div>
    ),
    TAILLE_PARTAGE,
  );
}
