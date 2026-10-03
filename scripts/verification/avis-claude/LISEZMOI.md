# Avis de Claude enregistrés

Un fichier par fiche (`<fiche_key>.json`) : le verdict de Claude pour chaque
unité de la fiche, rendu selon les mêmes consignes que la vérification par API
(`SYSTEME` dans `../verifier-fiches.mjs`) en lisant le PDF de la source, mais
hors API (relecture faite dans une session Claude Code, sans coût d'API).

Le workflow « Vérifier les fiches (IA) » n'appelle alors que Gemini et reprend
ces avis (`--avis-claude=scripts/verification/avis-claude`). Le script refait
lui-même les contrôles mécaniques : l'extrait cité doit figurer mot pour mot
dans la source, et chaque avis ne vaut que pour le texte relu (`empreinte`) :
une unité modifiée depuis repasse en orange (« unité modifiée depuis la
relecture de Claude »), jusqu'à une nouvelle relecture.

Format :

```json
{
  "cle": "sdra",
  "date": "2026-10-03",
  "relecture": "Claude (…)",
  "unites": [
    { "id": "u1", "empreinte": "…", "verdict": "conforme", "type_ecart": "aucun",
      "citation": "extrait exact de la source", "explication": "", "page": 3 }
  ]
}
```

`id` et `empreinte` viennent de `resultats.json` d'une exécution sans IA
(`--sans-ia`) sur les mêmes fiches. Ces avis orientent la relecture médicale :
ils ne valident aucune fiche.
