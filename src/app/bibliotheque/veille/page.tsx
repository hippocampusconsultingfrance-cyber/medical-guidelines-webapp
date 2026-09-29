import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { emailEnabled, siteUrl } from "@/lib/email";
import {
  chargerDestinataires,
  chargerLettre,
  composerLettre,
  libelleMois,
  moisValide,
  pourSpecialite,
} from "@/lib/lettre";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import { loadLibrary } from "../data";
import Shell from "../shell";
import { envoyerEssai, envoyerLettre } from "./actions";

export const metadata: Metadata = {
  title: "Lettre de veille — medical-guidelines.net",
};

// Mois en cours (heure de Paris), lu hors du rendu.
function moisCourant() {
  return new Intl.DateTimeFormat("fr-CA", { timeZone: "Europe/Paris", year: "numeric", month: "2-digit" })
    .format(new Date())
    .slice(0, 7);
}

function moisVoisin(mois: string, delta: number) {
  const [y, m] = mois.split("-").map(Number);
  const d = new Date(Date.UTC(y, m - 1 + delta, 1));
  return d.toISOString().slice(0, 7);
}

function message(r: string | undefined) {
  if (!r) return null;
  if (r.startsWith("envoyee_")) return `Lettre envoyée à ${r.slice(8)} abonné(s).`;
  if (r.startsWith("partiel_")) {
    const [, ok, ko] = r.split("_");
    return `Envoi partiel : ${ok} envoyée(s), ${ko} en échec. Relancez l'envoi : ceux qui l'ont reçue ne la recevront pas deux fois.`;
  }
  return (
    {
      essai_envoye: "Essai envoyé à votre adresse (objet préfixé [ESSAI]).",
      vide: "Aucune fiche ce mois-ci pour votre spécialité : rien à envoyer en essai.",
      confirmation: "Cochez la case de confirmation avant l'envoi.",
      sans_cle: "Envoi impossible : RESEND_API_KEY n'est pas configurée.",
      erreur: "L'envoi n'a pas abouti. Réessayez dans un instant.",
    } as Record<string, string>
  )[r] ?? null;
}

// Lettre mensuelle de veille (administrateurs) : relecture des fiches du
// mois, aperçu de l'e-mail, essai à sa propre adresse, puis envoi aux
// membres PREMIUM. La routine prépare le contenu ; l'envoi reste une
// décision humaine.
export default async function VeillePage({ searchParams }: PageProps<"/bibliotheque/veille">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");

  const params = await searchParams;
  const mois = moisValide(params.mois) ? params.mois : moisCourant();
  const intro = typeof params.intro === "string" ? params.intro.slice(0, 2000) : "";
  const notice = message(typeof params.r === "string" ? params.r : undefined);

  const admin = createAdminClient();
  const [lib, lettre, destinataires, { data: profile }, { data: specialties }] = await Promise.all([
    loadLibrary(supabase, user.id),
    chargerLettre(admin, mois),
    chargerDestinataires(admin, mois),
    supabase.from("profiles").select("prenom, specialty_id").eq("id", user.id).single(),
    admin.from("specialties").select("id, name_i18n"),
  ]);
  const nomSpecialite = new Map(
    ((specialties ?? []) as { id: string; name_i18n: { fr?: string } | null }[]).map((s) => [s.id, s.name_i18n?.fr ?? s.id]),
  );

  // Destinataires qui recevraient au moins une fiche, par spécialité.
  const parSpecialite = new Map<string, number>();
  let concernes = 0;
  for (const d of destinataires) {
    const { news, updates } = pourSpecialite(lettre, d.specialtyId);
    if (!news.length && !updates.length) continue;
    concernes++;
    const nom = d.specialtyId ? (nomSpecialite.get(d.specialtyId) ?? "?") : "Sans spécialité";
    parSpecialite.set(nom, (parSpecialite.get(nom) ?? 0) + 1);
  }

  const apercu = composerLettre(
    lettre,
    {
      email: user.email ?? "",
      prenom: (profile?.prenom as string | null) ?? null,
      alertsToken: "apercu",
      specialtyId: (profile?.specialty_id as string | null) ?? null,
    },
    intro,
    siteUrl(),
  );

  const liste = (titre: string, docs: typeof lettre.news) => (
    <>
      <h3 style={{ fontSize: "1rem", margin: "18px 0 6px" }}>
        {titre} ({docs.length})
      </h3>
      {docs.length ? (
        <ul style={{ margin: 0, paddingLeft: 18, fontSize: "0.9rem" }}>
          {docs.map((d) => (
            <li key={d.id}>
              <Link href={`/bibliotheque/${d.id}`}>{d.card_json?.title ?? d.title}</Link>
              {d.version ? ` — version ${d.version.version_label}` : ""}
              {" · "}
              {d.specialties.map((s) => nomSpecialite.get(s) ?? s).join(", ")}
            </li>
          ))}
        </ul>
      ) : (
        <p style={{ fontSize: "0.9rem", color: "var(--ink-muted)" }}>Aucune.</p>
      )}
    </>
  );

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Administration</div>
        <h1>Lettre de veille — {libelleMois(mois)}</h1>
        <p className="block-p">
          <Link href={`/bibliotheque/veille?mois=${moisVoisin(mois, -1)}`}>← {libelleMois(moisVoisin(mois, -1))}</Link>
          {" · "}
          <Link href={`/bibliotheque/veille?mois=${moisVoisin(mois, 1)}`}>{libelleMois(moisVoisin(mois, 1))} →</Link>
        </p>
      </div>

      {notice && (
        <div className="credit-strip" role="status">
          <b>{notice}</b>
        </div>
      )}
      {!emailEnabled() && (
        <div className="panel warn">RESEND_API_KEY absente : aucun e-mail ne peut partir.</div>
      )}

      <div className="unlock-box" style={{ marginTop: 18 }}>
        <h2>1. Fiches du mois</h2>
        <p style={{ fontSize: "0.9rem" }}>
          Fiches publiées (bouton « Publier ») et versions publiées (bloc « Veille » d&apos;une fiche) en{" "}
          {libelleMois(mois)}. Pour ajouter une fiche, publiez-la d&apos;abord.
        </p>
        {liste("Nouvelles fiches", lettre.news)}
        {liste("Fiches mises à jour", lettre.updates)}
      </div>

      <form className="unlock-box" style={{ marginTop: 18 }}>
        <h2>2. Mot d&apos;introduction (facultatif)</h2>
        <input type="hidden" name="mois" value={mois} />
        <div className="field">
          <label htmlFor="lv-intro">
            Texte en tête de la lettre (sinon une phrase standard). Paragraphes séparés par une ligne vide.
          </label>
          <textarea id="lv-intro" name="intro" maxLength={2000} rows={5} defaultValue={intro} />
        </div>
        <button className="btn btn-ghost">Mettre à jour l&apos;aperçu</button>
      </form>

      <div className="unlock-box" style={{ marginTop: 18 }}>
        <h2>3. Aperçu (votre spécialité)</h2>
        {apercu ? (
          <>
            <p style={{ fontSize: "0.9rem" }}>
              <b>Objet :</b> {apercu.subject}
            </p>
            <iframe
              title="Aperçu de la lettre"
              srcDoc={apercu.html}
              sandbox=""
              style={{ width: "100%", height: 560, border: "1px solid var(--border)", borderRadius: 8, background: "#fff" }}
            />
            <form action={envoyerEssai} style={{ marginTop: 12 }}>
              <input type="hidden" name="mois" value={mois} />
              <input type="hidden" name="intro" value={intro} />
              <button className="btn btn-ghost">M&apos;envoyer un essai ({user.email})</button>
            </form>
          </>
        ) : (
          <p style={{ fontSize: "0.9rem" }}>Aucune fiche ce mois-ci pour votre spécialité.</p>
        )}
      </div>

      <form action={envoyerLettre} className="unlock-box" style={{ marginTop: 18 }}>
        <h2>4. Envoi aux abonnés PREMIUM</h2>
        <input type="hidden" name="mois" value={mois} />
        <input type="hidden" name="intro" value={intro} />
        <p style={{ fontSize: "0.9rem" }}>
          <b>{concernes}</b> abonné{concernes > 1 ? "s" : ""} PREMIUM recevr{concernes > 1 ? "ont" : "a"} la lettre
          (alertes activées, adresse confirmée, au moins une fiche de sa spécialité, pas encore reçue ce mois-ci)
          {parSpecialite.size ? " : " : "."}
          {[...parSpecialite.entries()].map(([s, n]) => `${s} ${n}`).join(" · ")}
        </p>
        {concernes > 0 && (
          <>
            <label style={{ display: "flex", gap: 8, alignItems: "flex-start", fontSize: "0.86rem", margin: "4px 0 12px" }}>
              <input type="checkbox" name="confirme" value="1" required style={{ marginTop: 3 }} />
              <span>
                J&apos;ai relu les fiches et l&apos;aperçu : j&apos;envoie la lettre de {libelleMois(mois)} à {concernes}{" "}
                abonné{concernes > 1 ? "s" : ""}.
              </span>
            </label>
            <button className="btn btn-primary">Envoyer la lettre</button>
          </>
        )}
      </form>
      <p className="block-p is-note" style={{ marginTop: 24 }}>
        Chaque abonné ne reçoit la lettre d&apos;un mois qu&apos;une fois ; un désabonnement des alertes
        l&apos;exclut aussi de la lettre.
      </p>
    </Shell>
  );
}
