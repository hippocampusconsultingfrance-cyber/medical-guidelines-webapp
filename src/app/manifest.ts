import type { MetadataRoute } from "next";

// Installation sur l'écran d'accueil (« Ajouter à l'écran d'accueil ») :
// le site s'ouvre en plein écran, comme une application.
export default function manifest(): MetadataRoute.Manifest {
  return {
    name: "medical-guidelines.net",
    short_name: "Guidelines",
    description: "Synthèses des recommandations des sociétés savantes, par spécialité.",
    lang: "fr",
    start_url: "/",
    scope: "/",
    display: "standalone",
    background_color: "#ffffff",
    theme_color: "#0E3A78",
    icons: [
      { src: "/icones/192.png", sizes: "192x192", type: "image/png", purpose: "any" },
      { src: "/icones/512.png", sizes: "512x512", type: "image/png", purpose: "any" },
      { src: "/icon.svg", sizes: "any", type: "image/svg+xml" },
    ],
  };
}
