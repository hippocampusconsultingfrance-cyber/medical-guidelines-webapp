import CadreAuth from "../cadre-auth";

export default function Layout({ children }: { children: React.ReactNode }) {
  return <CadreAuth large>{children}</CadreAuth>;
}
