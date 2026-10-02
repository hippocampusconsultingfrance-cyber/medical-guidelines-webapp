# Archives des anciennes branches

Branches GitHub supprimées le 01/10/2026 (recette 6.2-1). Rien de ce
qu'elles contenaient n'est perdu :

| Branche | Dernier commit | Contenu absent de `main` | Où il se trouve |
|---|---|---|---|
| `claude/quirky-bell-3mzekr` | `cd409a6` | aucun (entièrement fusionnée) | — |
| `claude/practical-feynman-uqujz1` | `8bdab6b` | plan d'intégration des sociétés savantes et référentiel des 439 organisations | `docs/referentiel/` |
| `routine/travail` | `c41392d` | essai de page d'accueil du 28/09/2026 (illustrations, inscription intégrée), jamais mis en ligne | `branche-routine-travail-accueil-2026-09-28.patch` |

Pour retrouver l'essai de page d'accueil sur une branche de travail :

```bash
git checkout -b essai-accueil 3ec1a9f   # base d'origine de la branche
git am docs/archives/branche-routine-travail-accueil-2026-09-28.patch
```
