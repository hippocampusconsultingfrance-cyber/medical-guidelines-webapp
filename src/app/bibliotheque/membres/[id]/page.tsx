import type { Metadata } from "next";
import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { PROFESSION_GROUPS } from "@/lib/professions";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import { loadLibrary } from "../../data";
import Shell from "../../shell";
import { activerPremium, desactiverPremium, modifierMembre } from "../actions";

export const metadata: Metadata = {
  title: "Fiche membre — medical-guidelines.net",
};

const UUID = /^[0-9a-f-]{36}$/i;

const MESSAGES: Record<string, [string, boolean]> = {
  enregistre: ["Modifications enregistrées.", true],
  premium_active: ["PREMIUM activé pour ce membre.", true],
  premium_desactive: ["PREMIUM désactivé pour ce membre.", true],
  champs_requis: ["Nom, prénom et profession sont obligatoires.", false],
  propre_role: ["Vous ne pouvez pas modifier votre propre rôle depuis cette page.", false],
  email_invalide: ["Adresse e-mail invalide.", false],
  email_erreur: ["L'adresse e-mail n'a pas pu être changée (déjà utilisée par un autre compte ?).", false],
  date_invalide: ["La date de fin doit être postérieure à aujourd'hui.", false],
  abonnement_stripe: [
    "Ce membre a un abonnement payé en cours : il se gère dans Stripe (résiliation, remboursement), pas ici.",
    false,
  ],
  deja_inactif: ["Ce membre n'a pas de PREMIUM actif.", false],
  introuvable: ["Membre introuvable.", false],
  erreur: ["L'enregistrement n'a pas abouti.", false],
};

// Heure de la requête (lue une fois, hors du rendu).
function clock() {
  return Date.now();
}

const jour = (v: string | null | undefined) =>
  v ? new Date(v).toLocaleDateString("fr-FR", { day: "numeric", month: "long", year: "numeric", timeZone: "Europe/Paris" }) : "—";

// Fiche d'un membre (administrateurs) : toutes les informations du compte
// sont modifiables, et le PREMIUM peut être offert ou retiré sans paiement.
export default async function MembrePage({ params, searchParams }: PageProps<"/bibliotheque/membres/[id]">) {
  const { id } = await params;
  if (!UUID.test(id)) notFound();
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");

  const admin = createAdminClient();
  const [lib, { data: p }, { data: compte }, { data: sub }, { data: specialites }] = await Promise.all([
    loadLibrary(supabase, user.id),
    admin.from("profiles").select("*").eq("id", id).maybeSingle(),
    admin.auth.admin.getUserById(id),
    admin
      .from("subscriptions")
      .select("status, current_period_end, canceled_at, stripe_subscription_id, created_at")
      .eq("user_id", id)
      .maybeSingle(),
    admin.from("specialties").select("id, name_i18n, is_other"),
  ]);
  if (!p) notFound();

  const r = (await searchParams).r;
  const message = typeof r === "string" ? MESSAGES[r] : undefined;
  const now = clock();
  const email = compte?.user?.email ?? "";
  const fin = sub?.current_period_end as string | null | undefined;
  const premiumActif = sub?.status === "actif" && (!fin || new Date(fin).getTime() > now);
  const paye = Boolean(sub?.stripe_subscription_id);
  const professions = PROFESSION_GROUPS.flatMap((g) => g.options);
  const listeSpecialites = ((specialites ?? []) as { id: string; name_i18n: { fr?: string } | null; is_other: boolean }[])
    .map((s) => ({ id: s.id, nom: s.name_i18n?.fr ?? "—", autre: s.is_other }))
    .sort((a, b) => Number(a.autre) - Number(b.autre) || a.nom.localeCompare(b.nom, "fr"));
  const soimeme = id === user.id;
  const dansUnAn = new Date(now + 365 * 24 * 3600 * 1000).toISOString().slice(0, 10);
  const grille = { display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(220px, 1fr))", gap: "0 16px" };
  const caseACocher = (nom: string, label: string, valeur: unknown) => (
    <label style={{ display: "flex", gap: 8, alignItems: "flex-start", fontSize: "0.88rem", margin: "6px 0" }}>
      <input type="checkbox" name={nom} defaultChecked={Boolean(valeur)} style={{ marginTop: 3 }} />
      <span>{label}</span>
    </label>
  );

  return (
    <Shell lib={lib}>
      <p style={{ marginTop: 8 }}>
        <Link href="/bibliotheque/membres">← Membres inscrits</Link>
      </p>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Administration · fiche membre</div>
        <h1>{[p.prenom, p.nom].filter(Boolean).join(" ") || "(nom non renseigné)"}</h1>
        <div className="doc-header__meta">
          <span>Inscrit le {jour(p.created_at as string)}</span>
          <span>Dernière connexion : {compte?.user?.last_sign_in_at ? jour(compte.user.last_sign_in_at) : "jamais"}</span>
        </div>
      </div>

      {message && (
        <div className={`panel${message[1] ? "" : " crit"}`} role="status">
          {message[0]}
        </div>
      )}

      <section className="unlock-box" style={{ marginTop: 18 }}>
        <h2>Abonnement PREMIUM</h2>
        {premiumActif ? (
          <p>
            <b>Actif</b>
            {paye ? " — payé par le membre (Stripe)" : " — offert par l'administration"}
            {fin ? `, jusqu'au ${jour(fin)}` : ", sans date de fin"}
            {sub?.canceled_at ? " (résiliation enregistrée)" : ""}.
          </p>
        ) : (
          <p>
            <b>Inactif</b>
            {sub ? ` (dernier abonnement : ${sub.status === "en_retard" ? "paiement en retard" : sub.status}, fin ${jour(fin)})` : " — compte gratuit"}.
          </p>
        )}
        {paye && (premiumActif || sub?.status === "en_retard") ? (
          <p style={{ fontSize: "0.86rem", color: "var(--ink-muted)" }}>
            Abonnement payé : la résiliation et un éventuel remboursement se font dans le tableau de bord Stripe.
          </p>
        ) : (
          <div style={{ display: "flex", gap: 16, flexWrap: "wrap", alignItems: "flex-end" }}>
            <form action={activerPremium} style={{ display: "flex", gap: 8, flexWrap: "wrap", alignItems: "flex-end" }}>
              <input type="hidden" name="id" value={id} />
              <div className="field" style={{ marginBottom: 0 }}>
                <label htmlFor="fin">{premiumActif ? "Nouvelle date de fin" : "Jusqu'au"}</label>
                <input id="fin" type="date" name="fin" defaultValue={premiumActif ? (fin?.slice(0, 10) ?? "") : dansUnAn} />
                <div className="field__hint">Vide = sans date de fin</div>
              </div>
              <button className="btn btn-primary">{premiumActif ? "Mettre à jour" : "Activer le PREMIUM"}</button>
            </form>
            {premiumActif && (
              <form action={desactiverPremium}>
                <input type="hidden" name="id" value={id} />
                <button className="btn btn-ghost">Désactiver le PREMIUM</button>
              </form>
            )}
          </div>
        )}
      </section>

      <form action={modifierMembre} className="unlock-box" style={{ marginTop: 18 }}>
        <input type="hidden" name="id" value={id} />
        <h2>Identité et contact</h2>
        <div style={grille}>
          <div className="field">
            <label htmlFor="prenom">Prénom</label>
            <input id="prenom" name="prenom" defaultValue={p.prenom ?? ""} required maxLength={200} />
          </div>
          <div className="field">
            <label htmlFor="nom">Nom</label>
            <input id="nom" name="nom" defaultValue={p.nom ?? ""} required maxLength={200} />
          </div>
          <div className="field">
            <label htmlFor="email">E-mail de connexion</label>
            <input id="email" name="email" type="email" defaultValue={email} maxLength={254} />
            <div className="field__hint">Changé immédiatement, sans e-mail de confirmation.</div>
          </div>
          <div className="field">
            <label htmlFor="telephone">Téléphone</label>
            <input id="telephone" name="telephone" defaultValue={p.telephone ?? ""} maxLength={40} />
          </div>
        </div>

        <h2>Exercice</h2>
        <div style={grille}>
          <div className="field">
            <label htmlFor="profession">Profession</label>
            <select id="profession" name="profession" defaultValue={p.profession ?? ""} required>
              {!professions.includes(p.profession) && p.profession && <option value={p.profession}>{p.profession}</option>}
              {PROFESSION_GROUPS.map((g) => (
                <optgroup key={g.label} label={g.label}>
                  {g.options.map((o) => (
                    <option key={o} value={o}>
                      {o}
                    </option>
                  ))}
                </optgroup>
              ))}
            </select>
          </div>
          <div className="field">
            <label htmlFor="profession_autre">Précision (si « Autre »)</label>
            <input id="profession_autre" name="profession_autre" defaultValue={p.profession_autre ?? ""} maxLength={200} />
          </div>
          <div className="field">
            <label htmlFor="specialty_id">Spécialité (fiches visibles)</label>
            <select id="specialty_id" name="specialty_id" defaultValue={p.specialty_id ?? ""}>
              <option value="">— Aucune —</option>
              {listeSpecialites.map((s) => (
                <option key={s.id} value={s.id}>
                  {s.nom}
                </option>
              ))}
            </select>
          </div>
          <div className="field">
            <label htmlFor="pays_exercice">Pays d&apos;exercice</label>
            <input id="pays_exercice" name="pays_exercice" defaultValue={p.pays_exercice ?? ""} maxLength={80} />
          </div>
          <div className="field">
            <label htmlFor="langue_preferee">Langue préférée</label>
            <select id="langue_preferee" name="langue_preferee" defaultValue={p.langue_preferee ?? "fr"}>
              <option value="fr">Français</option>
              <option value="en">Anglais</option>
            </select>
          </div>
        </div>

        <h2>Vérification et rôle</h2>
        <div style={grille}>
          <div className="field">
            <label htmlFor="professional_verification_status">Vérification professionnelle</label>
            <select
              id="professional_verification_status"
              name="professional_verification_status"
              defaultValue={p.professional_verification_status ?? "non_demandee"}
            >
              <option value="non_demandee">Non demandée</option>
              <option value="en_cours">En cours</option>
              <option value="verifiee">Vérifiée</option>
              <option value="refusee">Refusée</option>
            </select>
          </div>
          <div className="field">
            <label htmlFor="editorial_role">Rôle éditorial</label>
            <select id="editorial_role" name="editorial_role" defaultValue={p.editorial_role ?? ""} disabled={soimeme}>
              <option value="">Membre (aucun rôle)</option>
              <option value="relecteur">Relecteur</option>
              <option value="validateur">Validateur</option>
              <option value="admin">Administrateur</option>
            </select>
            {soimeme ? (
              <>
                <input type="hidden" name="editorial_role" value={p.editorial_role ?? ""} />
                <div className="field__hint">Votre propre rôle ne se modifie pas ici.</div>
              </>
            ) : (
              <div className="field__hint">Un rôle donne accès à toutes les fiches, brouillons compris.</div>
            )}
          </div>
        </div>
        {caseACocher("verified_badge", "Badge « vérifié » affiché", p.verified_badge)}
        {caseACocher("member_comite_consultatif", "Membre du comité consultatif", p.member_comite_consultatif)}

        <h2>Compte et préférences</h2>
        {caseACocher("setup_completed", "Compte finalisé", p.setup_completed)}
        {caseACocher("email_alerts", "Reçoit les alertes par e-mail (nouvelles fiches, mises à jour)", p.email_alerts)}
        {caseACocher("specialty_visibility_public", "Spécialité visible publiquement", p.specialty_visibility_public)}
        {caseACocher("consent_partners", "Accepte les communications des partenaires", p.consent_partners)}
        <p className="field__hint" style={{ margin: "4px 0 14px" }}>
          Le consentement aux partenaires est un choix du membre : ne le modifiez qu&apos;à sa demande (le changement est tracé).
        </p>

        <button className="btn btn-primary">Enregistrer les modifications</button>
      </form>
    </Shell>
  );
}
