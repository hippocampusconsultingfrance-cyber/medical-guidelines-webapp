import type { Metadata } from "next";
import CadreAuth from "../cadre-auth";

export const metadata: Metadata = { title: "Code de sécurité — medical-guidelines.net" };

export default function Layout({ children }: { children: React.ReactNode }) {
  return <CadreAuth>{children}</CadreAuth>;
}
