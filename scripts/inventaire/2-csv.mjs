// Inventaire de la vague 0, étape 2 : dédoublonnage par DOI, homonymes de
// sigle écartés, correspondance avec le catalogue actuel, puis
// docs/referentiel/inventaire-recommandations-v0.csv.
import fs from "node:fs";
const rows = JSON.parse(fs.readFileSync("rows.json"));
// Homonymes de sigle (CARO, CFAR, GRACE) : on ne garde que les textes français.
const homonyme = r => ["CARO","CFAR","GRACE"].includes(r.societe) && !/French|France|CNGOF/i.test(r.titre);
// Correspondance manuelle avec le catalogue actuel (titre de la fiche en base).
const CAT = [
 [/Tracheotomy in the intensive care/i,"Trachéotomie en réanimation"],
 [/Targeted temperature management in the ICU/i,"Contrôle ciblé de la température en réanimation"],
 [/intubation and extubation of the ICU/i,"Intubation et extubation du patient de réanimation"],
 [/prevention of anemia/i,"Gestion et prévention de l'anémie … soins critiques"],
 [/Acute kidney injury in the perioperative/i,"Insuffisance rénale aiguë en périopératoire et en réanimation"],
 [/Renal replacement therapy in adult and pediatric/i,"Épuration extrarénale en réanimation adulte et pédiatrique"],
 [/Intrahospital transport/i,"Transport intrahospitalier des patients à risque vital"],
 [/reduce curative antibiotic/i,"Stratégies de réduction de l’utilisation des antibiotiques …"],
 [/intra-abdominal infections/i,"Prise en charge des infections intra-abdominales"],
 [/Pleural Fluid Effusion/i,"Épanchement pleural liquidien de l'adulte en soins critiques"],
 [/Emergency intubation of an adult/i,"Intubation en urgence d'un adulte hors bloc …"],
 [/choice of intravenous fluids/i,"Choix du soluté pour le remplissage vasculaire en situation critique"],
 [/urgent obstetric situations/i,"Prise en charge des urgences obstétricales en médecine d'urgence"],
 [/mild traumatic brain injury/i,"Traumatisme crânien léger de l'adulte"],
 [/severe abdominal trauma/i,"Traumatisme abdominal grave de l'adulte"],
 [/severe pelvic injury/i,"Traumatisés pelviens graves à la phase précoce"],
 [/severe traumatic brain injury/i,"Traumatisés crâniens graves à la phase précoce"],
 [/heparin-induced thrombocytopenia/i,"Thrombopénie induite par l'héparine"],
 [/antiplatelet therapy for non.elective/i,"Agents antiplaquettaires, procédure non programmée ou hémorragie"],
 [/antiplatelet therapy in patients undergoing elective/i,"Agents antiplaquettaires, procédure programmée"],
 [/dabigatran/i,"Gestion des patients sous AOD (dabigatran) en urgence"],
 [/direct oral anticoagulants in patients undergoing elective/i,"Gestion périopératoire des patients sous AOD pour un acte programmé"],
 [/major bleeding complications and emergency surgery/i,"Complications hémorragiques graves … anti-IIa ou anti-Xa direct"],
 [/Anticoagulant management in Emergency/i,"Gestion de l'anticoagulation dans un contexte d'urgence"],
 [/perioperative venous thromboembolism/i,"Prévention de la MTEV péri-opératoire"],
 [/Sedation and analgesia in the emergency/i,"Sédation et analgésie en structure d'urgence"],
 [/medical examinations in biology/i,"À vérifier : Pertinence des examens biologiques … en réanimation"],
 [/cardiogenic shock/i,""],
];
const parDoc = new Map();
for (const r of rows) {
  if (homonyme(r) || /^Corrigendum/i.test(r.titre)) continue;
  const k = r.doi ? r.doi.toLowerCase() : "pmid:" + r.pmid;
  const d = parDoc.get(k);
  if (d) { if (!d.societes.includes(r.societe)) d.societes.push(r.societe); continue; }
  const cat = CAT.find(([re]) => re.test(r.titre))?.[1] ?? "";
  parDoc.set(k, { ...r, societes: [r.societe], au_catalogue: cat });
}
const docs = [...parDoc.values()].sort((a, b) => b.date.localeCompare(a.date));
const esc = v => /[",\n]/.test(v) ? `"${String(v).replace(/"/g, '""')}"` : v;
const lic = l => /creativecommons\.org\/licenses\/([a-z-]+)\/([\d.]+)/.exec(l)?.slice(1).join(" ").toUpperCase().replace(/^/, "CC ")
  ?? (/elsevier\.com\/open-access/.test(l) ? "Elsevier open access (à préciser)" : l ? "Droits réservés de l'éditeur" : "Non renseignée");
const head = ["vague","societes_reperees","titre_pubmed","date_publication","langue","revue","doi","pmid","licence_crossref","licence_url","au_catalogue","statut_inventaire"];
const lines = [head.join(",")];
for (const d of docs) lines.push([ "V0", d.societes.join(" "), d.titre, d.date, d.langue, d.revue, d.doi, d.pmid, lic(d.licence), d.licence.split(" ").find(u=>/creativecommons|open-access/.test(u)) ?? "", d.au_catalogue, d.au_catalogue && !d.au_catalogue.startsWith("À vérifier") ? "déjà couvert" : "à examiner" ].map(v => esc(v ?? "")).join(","));
fs.writeFileSync("docs/referentiel/inventaire-recommandations-v0.csv", "﻿" + lines.join("\n") + "\n");
const nb = s => docs.filter(d => d.societes.includes(s)).length;
console.log(docs.length, "documents ;", docs.filter(d=>d.au_catalogue && !d.au_catalogue.startsWith("À")).length, "déjà couverts");
for (const s of ["SRLF","SFMU","ADARPEF","ANARLF","ARCOTHOVA","CARO","CFAR","CFRC","GFRUP","GIHP","GRACE","SFB","SOFIA"]) console.log(s, nb(s));
