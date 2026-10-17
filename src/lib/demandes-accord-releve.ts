import "server-only";
import type { Adresse } from "@/lib/demandes-accord-etats";

// Relevé des adresses électroniques publiées sur le site officiel d'une
// société : accueil, pages de contact, mentions légales, bureau, secrétariat
// (même site, 12 pages au plus, 40 s au plus). Seules les adresses de la
// société sont gardées : adresses sur son domaine (présidence, secrétariat,
// contact, équipe), boîtes à son nom hébergées ailleurs, adresses de rôle sur
// une page de contact. Écartées : adresses personnelles de médecins,
// services sans rapport (comptabilité, congrès, presse, DPO…), agences,
// exemples et coquilles. Mêmes règles que le relevé du 16/10/2026 (atelier).

const MOTS = /contact|nous-ecrire|ecrivez|mention|legal|bureau|secretariat|conseil-d-administration|gouvernance|qui-sommes|presentation|association|organisation|equipe|about|instances/i;
const CHEMINS = ["contact", "contact/", "nous-contacter", "contactez-nous", "mentions-legales", "mentions-legales/"];
const RE_MAIL = /[A-Za-z0-9][A-Za-z0-9._%+-]*@[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,12}/g;
const REJET = /\.(png|jpe?g|gif|svg|webp|css|js)$|sentry|wixpress|example\.|domain\.|exemple\.|votre|your|email@|nom@|name@|prenom|xxx|@2x|u00|\.wix|cloudflare|godaddy/i;
const GENERIQUES = new Set(["gmail.com", "orange.fr", "wanadoo.fr", "yahoo.fr", "yahoo.com", "free.fr", "hotmail.com", "hotmail.fr", "laposte.net", "outlook.fr", "outlook.com", "sfr.fr", "neuf.fr", "aol.com", "icloud.com", "club-internet.fr", "live.fr", "proton.me", "noos.fr", "mac.com", "me.com"]);
const ROLE = /^(contact|info|infos|secretariat|secrétariat|secretaire|president|presidence|bureau|direction|admin|accueil|siege|courrier|tresorier|vice-president|secretaire-adjoint)\b|secretariat|secretaire|president|contact|bureau/i;
const HORS_SUJET = /^(webmaster|webmestre|webmasters|dpo|rgpd|privacy|noreply|no-reply|newsletter|presse|press|communication|comptabilite|formation|formations|accreditation|dpc|congres|inscription|prix|benevolat|concours|partenariat|editorial|recensement|moderation|rh|seminaires|support|emailcontact|mailcontact)|dpc\.|redaction|partnering|adhesion|congres|paramedical|journee|events|filotheque|recherche|registres|lanceur|factures|mecenat|masterclass/i;
const FAUX = /@(mail\.com|masociete\.fr|domaine\.|example|exemple|secretariat\.org)|jean\.dupont|martindupont|adresse@|utilisateur@|example@/i;
const ROT13 = new Set(["pbz", "se", "bet", "arg", "rh"]);

const sansAccents = (s: string) => s.normalize("NFKD").replace(/[̀-ͯ]/g, "").toLowerCase();
const compact = (s: string) => sansAccents(s).replace(/[^a-z0-9]/g, "");
const hote = (u: string) => {
  try {
    return new URL(u).hostname.toLowerCase().replace(/^www\./, "");
  } catch {
    return "";
  }
};

function rot13(s: string) {
  return s.replace(/[a-z]/gi, (c) => {
    const b = c <= "Z" ? 65 : 97;
    return String.fromCharCode(((c.charCodeAt(0) - b + 13) % 26) + b);
  });
}

function entites(t: string) {
  return t
    .replace(/&#(\d+);/g, (_, n: string) => String.fromCharCode(Number(n)))
    .replace(/&#x([0-9a-f]+);/gi, (_, n: string) => String.fromCharCode(parseInt(n, 16)))
    .replace(/&commat;/g, "@")
    .replace(/&period;/g, ".")
    .replace(/&amp;/g, "&");
}

function cfDecode(h: string) {
  const k = parseInt(h.slice(0, 2), 16);
  let out = "";
  for (let i = 2; i < h.length; i += 2) out += String.fromCharCode(parseInt(h.slice(i, i + 2), 16) ^ k);
  return out;
}

export function extraireAdresses(html: string) {
  let t = entites(html);
  t += " " + [...html.matchAll(/data-cfemail="([0-9a-fA-F]+)"/g)].map((m) => cfDecode(m[1])).join(" ");
  t += " " + [...t.matchAll(/mailto:([^"'?>\s]+)/gi)].map((m) => {
    try {
      return decodeURIComponent(m[1]);
    } catch {
      return m[1];
    }
  }).join(" ");
  t = t.replace(/\s*[[({]\s*(at|arobase|@)\s*[\])}]\s*/gi, "@").replace(/\s*[[({]\s*(dot|point)\s*[\])}]\s*/gi, ".");
  const out = new Set<string>();
  for (const m of t.match(RE_MAIL) ?? []) {
    let a = m.replace(/^\.+|\.+$/g, "").toLowerCase();
    if (REJET.test(a)) continue;
    const tld = a.split(".").pop() ?? "";
    if (ROT13.has(tld)) a = rot13(a);
    out.add(a);
  }
  return out;
}

// Nature de l'adresse pour la demande, ou null si elle n'est pas à garder.
export function classerAdresse(adresse: string, page: string, site: string, sigle: string) {
  const [loc, dom] = adresse.split("@");
  if (!loc || !dom || FAUX.test(adresse) || HORS_SUJET.test(loc)) return null;
  const h = hote(site);
  const racine = h.split(".").slice(-2).join(".");
  const s = compact(sigle);
  const domaineSociete =
    Boolean(h) && (dom === h || dom === racine || dom.endsWith("." + racine) || (s.length >= 3 && compact(dom).includes(s)));
  const boiteSociete = s.length >= 3 && compact(loc).includes(s);
  if (domaineSociete && (ROLE.test(loc) || boiteSociete)) return "société";
  if (domaineSociete) return "équipe ou bureau (adresse de la société)";
  if (boiteSociete || (GENERIQUES.has(dom) && ROLE.test(loc) && /asso|societe|college|soc/.test(loc + dom))) {
    return "société (boîte hébergée ailleurs)";
  }
  let chemin = "";
  try {
    chemin = new URL(page).pathname;
  } catch {}
  if (ROLE.test(loc) && /contact|bureau|mention|secretariat|ecrire/i.test(chemin) && !GENERIQUES.has(dom)) {
    return "société (adresse publiée sur sa page de contact)";
  }
  return null;
}

async function lire(url: string, signal: AbortSignal) {
  try {
    const res = await fetch(url, {
      redirect: "follow",
      signal: AbortSignal.any([signal, AbortSignal.timeout(8000)]),
      headers: { "User-Agent": "Mozilla/5.0 (demande d'autorisation medical-guidelines.net)", Accept: "text/html" },
    });
    if (!res.ok || !(res.headers.get("content-type") ?? "").includes("html")) return null;
    const texte = await res.text();
    return { url: res.url || url, html: texte.slice(0, 2_000_000) };
  } catch {
    return null;
  }
}

export async function releverAdresses(site: string, sigle: string) {
  const base = site.endsWith("/") ? site : site + "/";
  const h = hote(site);
  if (!h) return { adresses: [] as Adresse[], pages: 0, formulaire: "" };
  const fin = new AbortController();
  const minuterie = setTimeout(() => fin.abort(), 40_000);
  const aLire = [site, ...CHEMINS.map((c) => new URL(c, base).toString())];
  const vus = new Set<string>();
  const trouvees = new Map<string, string>();
  let formulaire = "";
  try {
    while (aLire.length && vus.size < 12 && !fin.signal.aborted) {
      const u = aLire.shift()!;
      if (vus.has(u)) continue;
      vus.add(u);
      const page = await lire(u, fin.signal);
      if (!page) continue;
      for (const a of extraireAdresses(page.html)) if (!trouvees.has(a)) trouvees.set(a, page.url);
      if (!formulaire && /contact/i.test(new URL(page.url).pathname) && /<form/i.test(page.html)) formulaire = page.url;
      if (u === site) {
        for (const m of page.html.matchAll(/href="([^"#]+)"/g)) {
          let v: URL;
          try {
            v = new URL(entites(m[1]), page.url);
          } catch {
            continue;
          }
          if (v.hostname.toLowerCase().replace(/^www\./, "") !== h || !MOTS.test(v.pathname)) continue;
          if (/\.(pdf|jpe?g|png|docx?|zip)$/i.test(v.pathname)) continue;
          const lien = v.toString().split("#")[0];
          if (!aLire.includes(lien) && aLire.length < 30) aLire.push(lien);
        }
      }
    }
  } finally {
    clearTimeout(minuterie);
  }
  const adresses: Adresse[] = [];
  for (const [adresse, page] of trouvees) {
    const nature = classerAdresse(adresse, page, site, sigle);
    if (nature) adresses.push({ adresse, nature, page });
  }
  return { adresses, pages: vus.size, formulaire };
}
