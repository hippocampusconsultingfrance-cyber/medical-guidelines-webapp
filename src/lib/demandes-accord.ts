import "server-only";
import type { Adresse, Etat } from "@/lib/demandes-accord-etats";

// Demandes d'accord aux sociétés savantes : courriel personnalisé à partir
// du modèle, mise en forme HTML, choix des destinataires et envoi par
// Resend avec la pièce jointe.
// Variables d'environnement (Vercel), toutes facultatives sauf la clé :
//   RESEND_API_KEY        clé d'API Resend (la même que pour les alertes)
//   DEMANDES_FROM         expéditeur, par défaut
//                         « Dr Ahmed Ben Lallahom <contact@medical-guidelines.net> »
//   DEMANDES_REPLY_TO     adresse de réponse, par défaut contact@medical-guidelines.net
//   DEMANDES_COPIE        copie cachée de chaque envoi (par défaut l'adresse
//                         de réponse ; vide : aucune copie)
//   DEMANDES_PLAFOND_JOUR envois au plus sur 24 h glissantes (par défaut 25)

export const BUCKET = "demandes-accord";

export type Demande = {
  id: string;
  societe_slug: string;
  sigle: string;
  nom: string | null;
  type: string | null;
  specialite: string | null;
  site: string | null;
  priorite: number | null;
  nb_fiches: number;
  nb_porteuse: number;
  adresses: Adresse[];
  destinataires: string[];
  designation: string | null;
  formule_appel: string | null;
  exemple: string | null;
  revues: string | null;
  paragraphe_specifique: string | null;
  objet: string | null;
  corps: string | null;
  piece_jointe_chemin: string | null;
  piece_jointe_nom: string | null;
  etat: Etat;
  envoye_le: string | null;
  envoi_id: string | null;
  nb_envois: number;
  relance_le: string | null;
  reponse_le: string | null;
  erreur: string | null;
  notes: string | null;
  releve_le: string | null;
};

export type Modele = {
  objet: string;
  corps: string;
  exemple_defaut: string;
  relance_objet: string;
  relance_corps: string;
  piece_jointe_chemin: string | null;
  piece_jointe_nom: string | null;
};

export const ADRESSE = /^[A-Za-z0-9][A-Za-z0-9._%+-]*@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,12}$/;

export const institution = (d: Pick<Demande, "type">) => (d.type ?? "").includes("institution");

// « la SFAR », « le GIHP », « l'AFU », « la HAS » (sigle lu lettre à lettre :
// pas d'élision devant H) : article d'après le nom de l'organisme.
export function designationParDefaut(sigle: string, nom: string | null) {
  const n = (nom ?? "").trim();
  const voyelle = /^[AEIOUÉ]/i.test(sigle);
  if (/^(Collège|Groupe|Groupement|Club|Cercle|Conseil|Comité|Syndicat|Centre)/i.test(n)) return voyelle ? `l'${sigle}` : `le ${sigle}`;
  return voyelle ? `l'${sigle}` : `la ${sigle}`;
}

// « de la SRLF », « du GIHP », « de l'AFU ».
export const deLa = (designation: string) => (/^le\s/i.test(designation) ? `du ${designation.slice(3)}` : `de ${designation}`);

export const formuleParDefaut = (d: Pick<Demande, "type">) =>
  institution(d) ? "Madame, Monsieur" : "Madame la Présidente, Monsieur le Président";

const majuscule = (s: string) => s.charAt(0).toUpperCase() + s.slice(1);
const pronom = (designation: string) => (/^le\s/i.test(designation) ? "il" : "elle");

function paragraphePlace(d: Demande, laSociete: string) {
  const debut =
    "Ce travail a commencé avec la SFAR, dont plus de 100 recommandations sont aujourd'hui présentées sur le site, et la SFAR nous a donné son accord pour cette reprise.";
  if (d.societe_slug === "sfar") return "";
  if (d.nb_fiches > 0) {
    const fiches = d.nb_fiches > 1 ? `${d.nb_fiches} fiches portent` : "Une fiche porte";
    const porteuse =
      d.nb_porteuse > 0
        ? `, et ${pronom(laSociete)} en est le premier signataire pour ${d.nb_porteuse > 1 ? `${d.nb_porteuse} d'entre elles` : "l'une d'elles"}`
        : "";
    return `${debut} ${majuscule(laSociete)} y occupe une place importante : ${fiches} sur des recommandations auxquelles ${pronom(laSociete)} a participé${porteuse}. Nous les avons construites dans le respect des textes :`;
  }
  return `${debut} Nous élargissons maintenant le site à toutes les spécialités, et les recommandations ${deLa(laSociete)} y auraient naturellement leur place. Nos fiches sont construites dans le respect des textes :`;
}

// Remplit le modèle pour une société. Un paragraphe (ou un élément de liste)
// dont le repère est vide disparaît.
export function genererCourriel(m: Modele, d: Demande) {
  const laSociete = d.designation?.trim() || designationParDefaut(d.sigle, d.nom);
  const formule = d.formule_appel?.trim() || formuleParDefaut(d);
  const revues = d.revues?.trim();
  const valeurs: Record<string, string> = {
    formule_appel: formule,
    la_societe: laSociete,
    de_la_societe: deLa(laSociete),
    paragraphe_place: paragraphePlace(d, laSociete),
    paragraphe_exemple: d.exemple?.trim() || m.exemple_defaut.trim(),
    offre_lien: institution(d)
      ? "un lien vers votre site sur chacune de ces fiches."
      : "un lien vers votre site, votre adhésion et votre congrès sur chacune de ces fiches.",
    paragraphe_specifique: d.paragraphe_specifique?.trim() ?? "",
    paragraphe_revues:
      institution(d) && !revues
        ? ""
        : `Si certains droits sont détenus par l'éditeur des revues qui publient vos recommandations${revues ? ` (${revues})` : ""}, pourriez-vous nous indiquer l'interlocuteur à contacter ?`,
  };
  return { objet: (d.objet?.trim() || m.objet).trim(), corps: remplir(m.corps, valeurs) };
}

export function genererRelance(m: Modele, d: Demande) {
  const laSociete = d.designation?.trim() || designationParDefaut(d.sigle, d.nom);
  const dateEnvoi = d.envoye_le ? dateLongue(d.envoye_le) : "";
  const tete = remplir(m.relance_corps, {
    formule_appel: d.formule_appel?.trim() || formuleParDefaut(d),
    la_societe: laSociete,
    de_la_societe: deLa(laSociete),
    date_envoi: dateEnvoi,
  });
  const objetInitial = d.objet?.trim() || m.objet;
  // Courriel envoyé hors de l'outil (texte absent) : la relance seule.
  const cite = d.corps?.trim() ? `\n\n— Message du ${dateEnvoi} —\n\nObjet : ${objetInitial}\n\n${d.corps.trim()}` : "";
  return { objet: m.relance_objet.trim(), corps: tete + cite };
}

function remplir(modele: string, valeurs: Record<string, string>) {
  const texte = modele.replace(/\{\{\s*([a-z_]+)\s*\}\}/g, (_, cle: string) => valeurs[cle] ?? "");
  return texte
    .split(/\n{2,}/)
    .map((p) =>
      p
        .split("\n")
        .filter((l) => l.trim() !== "-" && l.trim() !== "")
        .join("\n"),
    )
    .filter((p) => p.trim())
    .join("\n\n")
    .trim();
}

export const dateLongue = (v: string) =>
  new Date(v).toLocaleDateString("fr-FR", { day: "numeric", month: "long", year: "numeric", timeZone: "Europe/Paris" });

// Ajouté à chaque envoi, hors modèle : d'où vient l'adresse, comment ne
// plus être contacté (prospection entre professionnels, recommandations CNIL).
export function piedDePage(d: Demande) {
  const laSociete = d.designation?.trim() || designationParDefaut(d.sigle, d.nom);
  return `Vous recevez ce message parce que cette adresse est publiée comme contact ${deLa(laSociete)} sur son site. Si vous ne souhaitez plus être contacté, répondez simplement « STOP » : nous ne vous écrirons plus.`;
}

const echapper = (s: string) =>
  s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");

function liens(s: string) {
  return s.replace(/https?:\/\/[^\s<]+[^\s<.,;:!?)»]/g, (u) => `<a href="${u}" style="color:#0E3A78">${u}</a>`);
}

// Texte du courriel (paragraphes séparés par une ligne vide, listes en « - »)
// en HTML simple, lisible dans toutes les messageries.
export function texteVersHtml(texte: string, pied?: string) {
  const blocs = texte
    .split(/\n{2,}/)
    .map((p) => {
      const lignes = p.split("\n");
      if (lignes.every((l) => l.startsWith("- "))) {
        return `<ul style="margin:0 0 14px;padding-left:22px">${lignes
          .map((l) => `<li style="margin:0 0 6px">${liens(echapper(l.slice(2)))}</li>`)
          .join("")}</ul>`;
      }
      return `<p style="margin:0 0 14px">${lignes.map((l) => liens(echapper(l))).join("<br>")}</p>`;
    })
    .join("");
  const bas = pied
    ? `<p style="margin:24px 0 0;padding-top:12px;border-top:1px solid #D8E3E3;font-size:12px;color:#60747A">${echapper(pied)}</p>`
    : "";
  return `<div style="font-family:Arial,Helvetica,sans-serif;font-size:15px;line-height:1.55;color:#12232B;max-width:680px">${blocs}${bas}</div>`;
}

// Destinataires proposés : adresses de la société d'abord, présidence puis
// secrétariat puis contact ; deux au plus.
export function choisirDestinataires(adresses: Adresse[]) {
  const rang = (a: Adresse) =>
    (a.nature.startsWith("société") ? 0 : 10) +
    (/president|presidence/.test(a.adresse) ? 0 : /secr/.test(a.adresse) ? 1 : /contact|info|accueil|courrier/.test(a.adresse) ? 2 : 3);
  const tri = [...adresses].filter((a) => ADRESSE.test(a.adresse)).sort((a, b) => rang(a) - rang(b));
  return tri.slice(0, 2).map((a) => a.adresse);
}

// Début de la fenêtre du plafond d'envois (24 h glissantes).
export const debutFenetreEnvois = () => new Date(Date.now() - 24 * 3600 * 1000).toISOString();

export function plafondJour() {
  const n = Number(process.env.DEMANDES_PLAFOND_JOUR ?? 25);
  return Number.isFinite(n) && n > 0 ? Math.floor(n) : 25;
}

// Envoi d'un courriel avec sa pièce jointe (PDF). La clé d'idempotence évite
// un double envoi si l'appel est rejoué.
export async function envoyerCourriel(args: {
  a: string[];
  objet: string;
  texte: string;
  html: string;
  pieceJointe: { nom: string; contenu: Uint8Array } | null;
  cle: string;
}) {
  const key = process.env.RESEND_API_KEY;
  if (!key) return { ok: false as const, erreur: "RESEND_API_KEY manquant : envoi impossible." };
  const from = process.env.DEMANDES_FROM ?? "Dr Ahmed Ben Lallahom <contact@medical-guidelines.net>";
  const replyTo = process.env.DEMANDES_REPLY_TO ?? "contact@medical-guidelines.net";
  const copie = process.env.DEMANDES_COPIE ?? replyTo;
  const [premier, ...autres] = args.a;
  const res = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: { Authorization: `Bearer ${key}`, "Content-Type": "application/json", "Idempotency-Key": args.cle },
    body: JSON.stringify({
      from,
      to: [premier],
      ...(autres.length ? { cc: autres } : {}),
      ...(copie ? { bcc: [copie] } : {}),
      ...(replyTo ? { reply_to: replyTo } : {}),
      subject: args.objet,
      text: args.texte,
      html: args.html,
      ...(args.pieceJointe
        ? { attachments: [{ filename: args.pieceJointe.nom, content: Buffer.from(args.pieceJointe.contenu).toString("base64") }] }
        : {}),
    }),
  });
  const corps = await res.text();
  if (!res.ok) return { ok: false as const, erreur: `Resend ${res.status} : ${corps.slice(0, 300)}` };
  let id = "";
  try {
    id = String((JSON.parse(corps) as { id?: string }).id ?? "");
  } catch {}
  return { ok: true as const, id };
}
