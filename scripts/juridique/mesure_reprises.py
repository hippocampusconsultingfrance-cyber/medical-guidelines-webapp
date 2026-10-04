#!/usr/bin/env python3
"""Mesure de la reprise des sources dans les fiches (audit juridique du
01/10/2026, §4). Pour chaque fiche dont la source est un PDF, deux taux,
calculés après normalisation (minuscules, accents, ponctuation et coupures de
ligne ignorés) :
  - reprise : part des suites de 8 mots de la fiche retrouvées à l'identique
    dans le PDF (copie mot pour mot de passages entiers) ;
  - proximité : part des suites de 4 mots retrouvées (reprise quasi
    littérale, à quelques mots près).

Usage : python3 scripts/juridique/mesure_reprises.py postgres:///base sortie.md
(la base contient documents.presentation_json, par exemple la base de test
construite par tests/base/lancer.sh). Nécessite pdftotext (poppler)."""
import hashlib, html as html_mod, json, os, re, subprocess, sys, unicodedata, urllib.request

DSN, SORTIE = sys.argv[1], sys.argv[2]
CACHE = os.environ.get("CACHE_PDF", "/tmp/mesure_reprises")
os.makedirs(CACHE, exist_ok=True)
N = 8

def norm(t):
    t = unicodedata.normalize("NFKD", t).encode("ascii", "ignore").decode().lower()
    t = re.sub(r"-\s*\n\s*", "", t)          # mots coupés en fin de ligne
    return re.findall(r"[a-z0-9]+", t)

def shingles(mots, n=N):
    return {" ".join(mots[i:i + n]) for i in range(len(mots) - n + 1)}

def html(t):
    # Seules les vraies balises : « <21 si >70 ans » est du texte.
    return re.sub(r"</?[a-zA-Z][^>]*>", " ", t or "").replace("&nbsp;", " ")

def textes(p):
    """Texte de la fiche : paragraphes et cellules, hors blocs « source »."""
    out = []
    def cell(c):
        if isinstance(c, list):
            for x in c: cell(x)
            return
        if not isinstance(c, dict): return
        if c.get("t") == "p": out.append(html(c.get("html")))
        elif c.get("t") == "table":
            for r in c.get("rows", []): [cell(x) for x in r]
    def bloc(b):
        if isinstance(b, list):
            for x in b: bloc(x)
            return
        if not isinstance(b, dict): return
        t = b.get("t")
        if t == "p" and b.get("style") != "source": out.append(html(b.get("html")))
        elif t == "panel": bloc(b.get("content"))
        elif t == "table":
            for r in b.get("rows", []): [cell(x) for x in r]
    for s in p.get("sections", []):
        for b in s.get("items", []): bloc(b)
    return "\n".join(out)

def pdf_texte(url):
    """Texte de la source : PDF (pdftotext) ou page web (balises retirées)."""
    url = url.split("#")[0]
    f = os.path.join(CACHE, hashlib.sha1(url.encode()).hexdigest())
    if not os.path.exists(f + ".txt"):
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0 (audit medical-guidelines.net)"})
        with urllib.request.urlopen(req, timeout=60) as r:
            corps = r.read()
        if corps[:5] == b"%PDF-":
            open(f + ".pdf", "wb").write(corps)
            subprocess.run(["pdftotext", f + ".pdf", f + ".txt"], check=True, capture_output=True)
        else:
            t = corps.decode("utf-8", errors="ignore")
            t = re.sub(r"(?is)<(script|style|nav|header|footer)[^>]*>.*?</\1>", " ", t)
            t = html_mod.unescape(re.sub(r"<[^>]+>", " ", t))
            open(f + ".txt", "w").write(t)
    return open(f + ".txt", encoding="utf-8", errors="ignore").read()

rows = subprocess.run(
    ["psql", DSN, "-AtX", "-c",
     "select json_agg(json_build_object('id', d.id, 'titre', coalesce(d.card_json->>'title', d.title), "
     "'societe', coalesce(s.acronym, '?'), 'pdf', coalesce(d.pdf_url, d.source_url), 'p', d.presentation_json) order by s.acronym, d.title) "
     "from documents d left join societies s on s.id = d.society_id "
     "where d.presentation_json is not null and d.published_at is not null and coalesce(d.pdf_url, d.source_url) is not null"],
    check=True, capture_output=True, text=True).stdout
docs = json.loads(rows)

def libelles(p):
    """Libellés de recommandation : cellules « cell » des tableaux."""
    out = []
    def walk(x):
        if isinstance(x, list):
            for i in x: walk(i)
        elif isinstance(x, dict):
            if x.get("t") == "p" and x.get("style") == "cell": out.append(html(x.get("html")))
            for v in x.values():
                if isinstance(v, (list, dict)): walk(v)
    walk(p)
    return out

resultats = []
lib = {"total": 0, "litteral": 0, "quasi": 0}
for d in docs:
    mots = norm(textes(d["p"]))
    sh, sh4 = shingles(mots), shingles(mots, 4)
    try:
        src = " ".join(norm(pdf_texte(d["pdf"])))
        taux = round(100 * sum(1 for s in sh if s in src) / len(sh)) if sh else None
        prox = round(100 * sum(1 for s in sh4 if s in src) / len(sh4)) if sh4 else None
        resultats.append((d, taux, prox))
        for c in libelles(d["p"]):
            w = norm(c)
            if len(w) < 12: continue
            lib["total"] += 1
            r8 = sum(x in src for x in shingles(w)) / len(shingles(w))
            r4 = sum(x in src for x in shingles(w, 4)) / len(shingles(w, 4))
            if r8 >= 0.8: lib["litteral"] += 1
            elif r4 >= 0.6: lib["quasi"] += 1
    except Exception:  # PDF inaccessible
        resultats.append((d, None, None))
    print(f"{d['societe']:8} {resultats[-1][1]!s:>4} {resultats[-1][2]!s:>4} {d['titre'][:70]}", flush=True)

ok = [r for r in resultats if r[1] is not None]
def classe(t): return "élevée (≥ 60 %)" if t >= 60 else "moyenne (35–59 %)" if t >= 35 else "faible (< 35 %)"
lignes = [
    "# Mesure de la reprise des sources dans les fiches",
    "",
    f"Fiches mesurées : {len(ok)} sur {len(resultats)} fiches avec une source (PDF ou page web) "
    f"({len(resultats) - len(ok)} sources inaccessibles), hors blocs « source ». "
    f"**Reprise** : suites de {N} mots retrouvées à l'identique dans le PDF. "
    "**Proximité** : suites de 4 mots retrouvées (reprise quasi littérale, à quelques mots près). "
    "Le texte propre à la fiche (avertissements, repères, périmètre) fait baisser les deux taux ; "
    "pour une source web qui n'est qu'une page de présentation du document, la mesure sous-estime la reprise.",
    "",
    "## Libellés de recommandation (cellules des tableaux, 12 mots ou plus)",
    "",
    "| Libellés | Nombre | Part |", "|---|---|---|",
    f"| Recopiés quasi mot pour mot (≥ 80 % des suites de 8 mots) | {lib['litteral']} | {round(100 * lib['litteral'] / max(lib['total'], 1))} % |",
    f"| Très proches (≥ 60 % des suites de 4 mots) | {lib['quasi']} | {round(100 * lib['quasi'] / max(lib['total'], 1))} % |",
    f"| Reformulés | {lib['total'] - lib['litteral'] - lib['quasi']} | {round(100 * (lib['total'] - lib['litteral'] - lib['quasi']) / max(lib['total'], 1))} % |",
    f"| **Total** | {lib['total']} | 100 % |",
    "",
    "## Fiches entières",
    "",
    "| Proximité avec la source | Fiches |", "|---|---|",
]
for c in ["élevée (≥ 60 %)", "moyenne (35–59 %)", "faible (< 35 %)"]:
    lignes.append(f"| {c} | {sum(1 for r in ok if classe(r[2]) == c)} |")
par_soc = {}
for d, t, p in ok: par_soc.setdefault(d["societe"], []).append((t, p))
lignes += ["", "| Société | Fiches | Reprise moyenne | Proximité moyenne |", "|---|---|---|---|"]
for s, ts in sorted(par_soc.items(), key=lambda x: -len(x[1])):
    lignes.append(f"| {s} | {len(ts)} | {round(sum(t for t, _ in ts) / len(ts))} % | {round(sum(p for _, p in ts) / len(ts))} % |")
lignes += ["", "## Détail (de la plus proche à la moins proche de la source)", "",
           "| Société | Fiche | Reprise | Proximité |", "|---|---|---|---|"]
for d, t, p in sorted(resultats, key=lambda r: -(r[2] if r[2] is not None else -1)):
    lignes.append(f"| {d['societe']} | {d['titre'].replace('|', '/')} | "
                  + (f"{t} % | {p} % |" if t is not None else "source inaccessible | |"))
open(SORTIE, "w").write("\n".join(lignes) + "\n")
print("Rapport :", SORTIE)
