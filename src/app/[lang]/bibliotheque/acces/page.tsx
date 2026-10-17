import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { RAISONS } from "@/lib/extraction";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import { loadLibrary } from "../data";
import Shell from "../shell";
import { leverSuspension } from "./actions";

export const metadata: Metadata = {
  title: "Accès anormaux — medical-guidelines.net",
};

type Bloc = {
  id: number;
  user_id: string;
  reason: string;
  distinct_documents: number;
  blocked_at: string;
  blocked_until: string;
  lifted_at: string | null;
};

const MESSAGES: Record<string, string> = {
  levee: "Suspension levée : le compte peut de nouveau lire ses fiches.",
  erreur: "La levée de la suspension n'a pas abouti.",
};

// Heure de la requête (lue une fois, hors du rendu).
function clock() {
  const now = Date.now();
  return { now, since30: new Date(now - 30 * 24 * 3600 * 1000).toISOString() };
}

const quand = (v: string) =>
  new Date(v).toLocaleString("fr-FR", { day: "numeric", month: "short", hour: "2-digit", minute: "2-digit", timeZone: "Europe/Paris" });

// Suspensions de lecture décidées par la base (anti-extraction, §11 du
// cahier des charges), sur 30 jours : qui, pourquoi, jusqu'à quand.
export default async function AccesPage({ searchParams }: PageProps<"/[lang]/bibliotheque/acces">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");

  const { now, since30 } = clock();
  const lib = await loadLibrary(supabase, user.id);
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("access_blocks")
    .select("id, user_id, reason, distinct_documents, blocked_at, blocked_until, lifted_at")
    .gte("blocked_at", since30)
    .order("blocked_at", { ascending: false })
    .limit(100);
  const blocs = (data ?? []) as Bloc[];
  const emails = new Map<string, string>();
  await Promise.all(
    [...new Set(blocs.map((b) => b.user_id))].map(async (id) => {
      const { data: u } = await admin.auth.admin.getUserById(id);
      if (u?.user?.email) emails.set(id, u.user.email);
    }),
  );

  const r = (await searchParams).r;
  const message = typeof r === "string" ? MESSAGES[r] : undefined;

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Administration</div>
        <h1>Accès anormaux</h1>
        <div className="doc-header__meta">
          <span>
            Lecture suspendue automatiquement au-delà de 20 fiches différentes en 10 minutes (1 h) ou de 60 en
            24 heures (24 h). L&apos;équipe éditoriale n&apos;est jamais concernée.
          </span>
        </div>
      </div>
      {message && (
        <div className="credit-strip" role="status">
          <b>{message}</b>
        </div>
      )}
      {error ? (
        <div className="panel warn">Migration anti-extraction pas encore appliquée dans Supabase.</div>
      ) : blocs.length === 0 ? (
        <div className="lib-empty">Aucun accès anormal ces 30 derniers jours.</div>
      ) : (
        <div className="table-scroll">
          <table className="rfe">
            <thead>
              <tr>
                <th>Compte</th>
                <th>Motif</th>
                <th>Suspendu le</th>
                <th>État</th>
              </tr>
            </thead>
            <tbody>
              {blocs.map((b) => {
                const actif = new Date(b.blocked_until).getTime() > now;
                return (
                  <tr key={b.id}>
                    <td>{emails.get(b.user_id) ?? b.user_id}</td>
                    <td>
                      {RAISONS[b.reason] ?? b.reason} ({b.distinct_documents} fiches)
                    </td>
                    <td>{quand(b.blocked_at)}</td>
                    <td>
                      {actif ? (
                        <form action={leverSuspension} style={{ display: "flex", gap: 8, alignItems: "center", flexWrap: "wrap" }}>
                          <span className="state-pill state-draft">jusqu&apos;au {quand(b.blocked_until)}</span>
                          <input type="hidden" name="id" value={b.id} />
                          <button className="btn btn-ghost btn-sm">Lever</button>
                        </form>
                      ) : (
                        <span className="state-pill state-open">{b.lifted_at ? "Levée" : "Terminée"}</span>
                      )}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </Shell>
  );
}
