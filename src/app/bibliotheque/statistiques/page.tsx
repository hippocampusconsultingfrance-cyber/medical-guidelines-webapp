import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { FREE_QUOTA } from "@/lib/fiches";
import { cardTitle, loadLibrary } from "../data";
import Shell from "../shell";

export const metadata: Metadata = {
  title: "Statistiques — medical-guidelines.net",
};

const DAY = 24 * 3600 * 1000;

// Heure de la requête (lue une fois, hors du rendu).
function clock() {
  const now = Date.now();
  return { now, since30: new Date(now - 30 * DAY).toISOString() };
}

// Tableau de bord du porteur de projet (administrateur) : inscriptions,
// tunnel gratuit → PREMIUM, fiches les plus débloquées et consultées. Chiffres
// lus dans la base (aucun cookie, aucun outil tiers). Les listes détaillées
// sont limitées à 1 000 lignes par l'API ; au-delà, passer par une fonction
// d'agrégation en base.
export default async function StatistiquesPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");

  const { since30, now } = clock();
  const [lib, profiles, unlocks, subs, views] = await Promise.all([
    loadLibrary(supabase, user.id),
    supabase.from("profiles").select("id, created_at, setup_completed, is_admin, specialty:specialties(name_i18n)").limit(1000),
    supabase.from("document_unlocks").select("user_id, document_id, unlocked_at").limit(1000),
    supabase.from("subscriptions").select("user_id, status, current_period_end, canceled_at").limit(1000),
    supabase.from("consultation_history").select("user_id, document_id, viewed_at").gte("viewed_at", since30).limit(1000),
  ]);

  const members = (profiles.data ?? []).filter((p) => !p.is_admin);
  const memberIds = new Set(members.map((p) => p.id as string));
  const recent = (days: number) =>
    members.filter((p) => now - new Date(p.created_at as string).getTime() < days * DAY).length;

  const unlockRows = (unlocks.data ?? []).filter((u) => memberIds.has(u.user_id as string));
  const perUser = new Map<string, number>();
  for (const u of unlockRows) perUser.set(u.user_id as string, (perUser.get(u.user_id as string) ?? 0) + 1);
  const premium = (subs.data ?? []).filter(
    (s) => memberIds.has(s.user_id as string) && s.status === "actif" && (!s.current_period_end || new Date(s.current_period_end as string).getTime() > now),
  );

  const funnel = [
    { label: "Comptes créés", n: members.length },
    { label: "Comptes finalisés (mot de passe choisi)", n: members.filter((p) => p.setup_completed).length },
    { label: "Au moins 1 fiche débloquée", n: perUser.size },
    { label: `Crédits épuisés (${FREE_QUOTA} fiches)`, n: [...perUser.values()].filter((n) => n >= FREE_QUOTA).length },
    { label: "Abonnés PREMIUM actifs", n: premium.length },
  ];

  const titleOf = new Map(lib.docs.map((d) => [d.id, cardTitle(d)]));
  const top = (rows: { document_id: unknown }[]) => {
    const counts = new Map<string, number>();
    for (const r of rows) counts.set(r.document_id as string, (counts.get(r.document_id as string) ?? 0) + 1);
    return [...counts.entries()].sort((a, b) => b[1] - a[1]).slice(0, 10);
  };
  const topUnlocked = top(unlockRows);
  const topViewed = top((views.data ?? []).filter((v) => memberIds.has(v.user_id as string)));

  const bySpecialty = new Map<string, number>();
  for (const p of members) {
    const s = p.specialty as { name_i18n: { fr?: string } | null } | { name_i18n: { fr?: string } | null }[] | null;
    const name = (Array.isArray(s) ? s[0] : s)?.name_i18n?.fr ?? "Non renseignée";
    bySpecialty.set(name, (bySpecialty.get(name) ?? 0) + 1);
  }

  const card = { background: "var(--surface)", border: "1px solid var(--border)", borderRadius: "var(--radius)", padding: "16px 18px" };

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Administration</div>
        <h1>Statistiques</h1>
        <div className="doc-header__meta">
          <span>Membres (hors administrateurs) · consultations des 30 derniers jours</span>
        </div>
      </div>

      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(160px, 1fr))", gap: 12, marginTop: 18 }}>
        {[
          ["Inscrits", members.length],
          ["Inscrits (7 jours)", recent(7)],
          ["Inscrits (30 jours)", recent(30)],
          ["Fiches débloquées", unlockRows.length],
          ["PREMIUM actifs", premium.length],
        ].map(([label, n]) => (
          <div key={label as string} style={card}>
            <div style={{ fontFamily: "var(--font-display)", fontSize: "1.8rem", fontWeight: 800, color: "var(--brand-ink)" }}>{n}</div>
            <div style={{ fontSize: "0.8rem", color: "var(--ink-muted)" }}>{label}</div>
          </div>
        ))}
      </div>

      <h2 className="block-section" style={{ marginTop: 32 }}>Tunnel gratuit → PREMIUM</h2>
      <div className="table-scroll">
        <table className="rfe">
          <thead>
            <tr>
              <th>Étape</th>
              <th className="num">Membres</th>
              <th className="num">% des inscrits</th>
            </tr>
          </thead>
          <tbody>
            {funnel.map((f) => (
              <tr key={f.label}>
                <td>{f.label}</td>
                <td className="num">{f.n}</td>
                <td className="num">{members.length ? Math.round((100 * f.n) / members.length) : 0} %</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {[
        ["Fiches les plus débloquées", topUnlocked],
        ["Fiches les plus consultées (30 jours)", topViewed],
      ].map(([title, rows]) => (
        <section key={title as string}>
          <h2 className="block-section" style={{ marginTop: 32 }}>{title as string}</h2>
          {(rows as [string, number][]).length === 0 ? (
            <div className="empty-state">Pas encore de données.</div>
          ) : (
            <div className="table-scroll">
              <table className="rfe">
                <tbody>
                  {(rows as [string, number][]).map(([id, n]) => (
                    <tr key={id}>
                      <td>
                        <Link href={`/bibliotheque/${id}`}>{titleOf.get(id) ?? "Fiche"}</Link>
                      </td>
                      <td className="num">{n}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </section>
      ))}

      <h2 className="block-section" style={{ marginTop: 32 }}>Inscrits par spécialité</h2>
      <div className="table-scroll">
        <table className="rfe">
          <tbody>
            {[...bySpecialty.entries()]
              .sort((a, b) => b[1] - a[1])
              .map(([name, n]) => (
                <tr key={name}>
                  <td>{name}</td>
                  <td className="num">{n}</td>
                </tr>
              ))}
          </tbody>
        </table>
      </div>

      <p className="block-p is-note" style={{ marginTop: 28 }}>
        Visites et provenance des visiteurs : tableau de bord Vercel, onglet « Analytics » (mesure
        sans cookies).
      </p>
    </Shell>
  );
}
