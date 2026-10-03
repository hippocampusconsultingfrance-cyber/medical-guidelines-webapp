// Inventaire de la vague 0, étape 1 : PubMed (recommandations, consensus) puis
// licence Crossref de chaque DOI. Écrit rows.json dans le dossier courant.
// Usage : node scripts/inventaire/1-pubmed-crossref.mjs && node scripts/inventaire/2-csv.mjs
import fs from "node:fs";
const SOC = [
 ["SRLF","Societe de Reanimation de Langue Francaise","French Intensive Care Society"],
 ["SFMU","Societe Francaise de Medecine d'Urgence","French Society of Emergency Medicine"],
 ["ADARPEF","Association des Anesthesistes-Reanimateurs Pediatriques d'Expression Francaise",""],
 ["ANARLF","Association de Neuro-Anesthesie Reanimation de Langue Francaise","French Society of Neuroanaesthesia"],
 ["ARCOTHOVA","Association pour la Recherche en Anesthesie-Reanimation Coeur-Thorax-Vaisseaux",""],
 ["CARO","Club d'Anesthesie-Reanimation en Obstetrique","French Obstetric Anaesthesia"],
 ["CFAR","College Francais des Anesthesistes-Reanimateurs",""],
 ["CFRC","Conseil Francais de Reanimation Cardiovasculaire","French Council of Resuscitation"],
 ["GFRUP","Groupe Francophone de Reanimation et Urgences Pediatriques","French-speaking group of pediatric intensive and emergency care"],
 ["GIHP","Groupe d'Interet en Hemostase Perioperatoire","French Working Group on Perioperative Haemostasis"],
 ["GRACE","Groupe francophone de Rehabilitation Amelioree apres Chirurgie",""],
 ["SFB","Societe Francaise de Brulologie","French Society for Burn Injuries"],
 ["SOFIA","Societe Francaise des Infirmier(e)s Anesthesistes",""],
];
const sleep = ms => new Promise(r=>setTimeout(r,ms));
const pt = `("practice guideline"[pt] OR "guideline"[pt] OR "consensus"[pt] OR "consensus development conference"[pt] OR guideline*[ti] OR recommendation*[ti] OR consensus[ti] OR recommandation*[ti])`;
async function j(u){ for(let i=0;i<4;i++){ const r=await fetch(u); if(r.ok) return r.json(); await sleep(1500*(i+1)); } return null; }
const rows=[];
for (const [acr, fr, en] of SOC) {
  const parts=[`"${fr}"[ad]`, `"${fr}"[cn]`, `${acr}[ti]`];
  if (en) parts.push(`"${en}"[ad]`, `"${en}"[cn]`);
  if (acr==="SRLF"||acr==="SFMU") parts.push(`${acr}[tiab]`);
  const term=`(${parts.join(" OR ")}) AND ${pt} AND 2010:2026[dp]`;
  const s=await j(`https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&retmode=json&retmax=200&term=${encodeURIComponent(term)}`);
  const ids=s?.esearchresult?.idlist??[]; await sleep(400);
  console.error(acr, ids.length);
  for (let k=0;k<ids.length;k+=100){
    const sm=await j(`https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&retmode=json&id=${ids.slice(k,k+100).join(",")}`); await sleep(400);
    for (const id of ids.slice(k,k+100)) { const d=sm?.result?.[id]; if(!d) continue;
      const doi=(d.articleids||[]).find(a=>a.idtype==="doi")?.value??"";
      rows.push({societe:acr,pmid:id,doi,titre:d.title,revue:d.fulljournalname||d.source,date:d.sortpubdate?.slice(0,10).replace(/\//g,"-"),langue:(d.lang||[]).join("|"),types:(d.pubtype||[]).join("|")});
    }
  }
}
// licences Crossref
for (const r of rows) { if(!r.doi){r.licence="";continue;}
  const c=await j(`https://api.crossref.org/works/${encodeURIComponent(r.doi)}?mailto=contact@medical-guidelines.net`);
  r.licence=(c?.message?.license||[]).map(l=>l.URL).filter((v,i,a)=>a.indexOf(v)===i).join(" ");
}
fs.writeFileSync("rows.json", JSON.stringify(rows,null,1));
