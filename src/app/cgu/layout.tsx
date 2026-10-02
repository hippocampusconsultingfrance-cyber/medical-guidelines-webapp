import EnteteSimple from "../entete-simple";

export default function Layout({ children }: { children: React.ReactNode }) {
  return (
    <>
      <div className="border-b border-slate-200 bg-white">
        <EnteteSimple />
      </div>
      <main>{children}</main>
    </>
  );
}
