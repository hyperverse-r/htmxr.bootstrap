# htmxr.bootstrap

## Commandes courantes

| Raccourci | Tâche | Commande |
|-----------|-------|----------|
| `/check` | Vérifier le package | `R -e "devtools::check()"` |
| `/test` | Lancer les tests | `R -e "devtools::test()"` |
| `/document` | Mettre à jour la doc | `R -e "devtools::document()"` |
| `/attach` | Mettre à jour le package | `R -e "attachment::att_amend_desc()"` |
| `/site` | Construire le site pkgdown | `R -e "pkgdown::build_site()"` |
| `/format` | Formater le code | `air format .` |

## Agents

| Raccourci | Rôle | Quand l'invoquer |
|-----------|------|-----------------|
| `/bootstrap-expert` | Revue fidélité et idiomaticité Bootstrap 5 | Nouvelle primitive créée ou modifiée |


## Contexte du projet

`htmxr.bootstrap` est une surcouche opinionated Bootstrap 5 sur `htmxr`. Il fournit
des composants UI prêts à l'emploi — boutons, inputs, containers, cards, etc. — avec
les classes Bootstrap appliquées automatiquement. L'utilisateur n'a pas besoin de
connaître les classes Bootstrap.

Ce package est **opinionated** par nature : il fait des choix CSS à la place de
l'utilisateur. Il dépend de `htmxr` et ne remplace pas plumber2.

## Écosystème hyperverse

`htmxr.bootstrap` fait partie de l'écosystème hyperverse, structuré à l'image du tidyverse.
Le package ombrelle **`hyperverse`** permettra d'importer l'ensemble de l'écosystème
en une seule commande (`library(hyperverse)`).

### Packages de l'écosystème

| Package | Rôle |
|---------|------|
| `htmxr` | Core — primitives htmx (CSS-agnostique) |
| `htmxr.bootstrap` | Surcouche opinionated Bootstrap 5 (ce package) |
| `htmxr.daisy` | Surcouche opinionated DaisyUI |
| `alpiner` | Wrapper Alpine.js — logique client déclarative |
| `supar` | Client Supabase pour R — requêtes HTTP sans SQL |
| `hyperverse` | Meta-package ombrelle — charge tout l'écosystème |

### Notes

- `htmxr.bootstrap` est destiné à une publication sur le CRAN
- L'écosystème est CSS-agnostique au niveau core (`htmxr`) ; Bootstrap est opté
  explicitement via ce package

## Stack technique

- **R** avec conventions tidyverse
- **htmxr** comme dépendance core
- **htmltools** pour la génération HTML
- **Bootstrap 5.3.8** comme framework CSS — sources téléchargées localement dans
  `inst/www/` (CSS + JS bundle). Pas de dépendance CDN au runtime.
- **plumber2** comme serveur HTTP dans les exemples (pas plumber v1)
- **roxygen2** pour la documentation

## Architecture du package

```
htmxr.bootstrap/
├── R/
│   ├── hx_bs_button.R        # hx_bs_button() — <button> Bootstrap
│   ├── hx_bs_select_input.R  # hx_bs_select_input() — <select> Bootstrap
│   ├── hx_bs_slider_input.R  # hx_bs_slider_input() — <input range> Bootstrap
│   ├── hx_bs_container.R     # hx_bs_container(), hx_bs_fluid_container()
│   ├── hx_bs_card.R          # hx_bs_card() — Bootstrap card
│   ├── utils-validation.R    # helpers internes (check_arg_or_null, etc.)
│   ├── zzz-aliases.R         # bs_* aliases — chargé en dernier (ordre alpha)
│   └── reexports.R           # réexports htmxr / htmltools
├── inst/
│   ├── www/
│   │   ├── bootstrap.min.css   # Bootstrap 5.3.8 — source locale
│   │   └── bootstrap.bundle.min.js
│   └── examples/
├── man/
├── DESCRIPTION
└── NAMESPACE
```

## Exemples

Les exemples se trouvent dans `inst/examples/`. Chaque sous-dossier contient un
fichier `api.R` démontrant un composant ou un pattern Bootstrap + htmx.

### Convention de nommage des dossiers

Nommés selon le **concept pédagogique** démontré, pas selon le dataset utilisé.

- ✅ `bs-button` — démontre `hx_bs_button()` avec variants et états
- ✅ `bs-card-list` — démontre le pattern liste de cards avec chargement htmx
- ❌ `diamonds-explorer` — nom de usecase, pas de concept

## Conventions de nommage

### Fonctions

- Préfixe **`hx_bs_`** — forme complète, explicite : `hx_bs_button()`, `hx_bs_card()`
- Alias **`bs_`** — raccourci pour les utilisateurs qui préfèrent la concision : `bs_button()`
- Les alias sont définis dans `R/zzz-aliases.R` via simple assignation : `bs_button <- hx_bs_button`
- Pas de `paste0()` pour construire du HTML — utiliser `htmltools::tags`

### Paramètres Bootstrap

- `variant` — variante de couleur Bootstrap : `"primary"`, `"secondary"`, `"danger"`, etc.
- `size` — taille : `"sm"`, `"lg"`, `NULL` (défaut)
- `class` — classes CSS supplémentaires (en plus des classes Bootstrap auto-générées)
- Paramètres htmx inchangés : `get`, `post`, `target`, `swap`, `trigger`, `indicator`, `swap_oob`, `confirm`

## Patterns d'implémentation

### Conventions de nommage Bootstrap

Les noms de paramètres suivent directement la terminologie
[Bootstrap 5](https://getbootstrap.com/docs/5.3/) :

- `variant` — variante de couleur (`"primary"`, `"secondary"`, `"danger"`, …)
- `size` — taille (`"sm"`, `"lg"`)
- `disabled`, `active` — états booléens
- `class` — remplace `className` (convention htmltools)

### Validation des paramètres

- Paramètres string nullables : `check_arg_or_null(arg, choices)` défini dans `R/utils-validation.R`
  - `NULL` = feature désactivée / non spécifiée — retourné tel quel
  - Valeur non-NULL → validée via `match.arg()`
- Paramètres booléens : `stopifnot(is.logical(x), length(x) == 1)`

```r
# Exemples
variant <- check_arg_or_null(variant, c("primary", "secondary", "danger", ...))
size    <- check_arg_or_null(size, c("sm", "lg"))
stopifnot(is.logical(outline), length(outline) == 1)
```

### Construction des classes Bootstrap

Assembler les classes via `paste(c(...), collapse = " ")` — R supprime les `NULL`
automatiquement dans `c()`, sans laisser d'espaces superflus.

```r
bs_class <- paste(c("base-class", variant_class, size_class, class), collapse = " ")
```

### Fichier des alias

Le fichier `R/zzz-aliases.R` est nommé avec le préfixe `zzz-` pour garantir qu'il
est chargé **en dernier** par R (ordre alphabétique). Les alias ne peuvent référencer
que des fonctions déjà définies au moment du sourcing.

Chaque alias doit porter `@rdname` pour éviter l'avertissement R CMD check :

```r
#' @rdname hx_bs_button
#' @export
bs_button <- hx_bs_button
```

## Règles générales

- Toujours lire la documentation Bootstrap 5 avant d'implémenter un composant
- Toujours lire le fichier htmxr correspondant avant d'écrire la version Bootstrap
- Ne pas réimplémenter la logique htmx — appeler directement la fonction `htmxr`
  correspondante en injectant la classe Bootstrap via le paramètre `class`
- Les classes Bootstrap sont générées automatiquement — l'utilisateur ne doit pas
  avoir à les connaître
- Tester les fonctions dans la console R avant de les proposer

### Règles Bootstrap 5 confirmées

- **`disabled` sur `<button>`** — utiliser l'attribut HTML booléen uniquement
  (`htmltools::tagAppendAttributes(btn, disabled = NA)`). Pas de classe CSS `.disabled`
  (contrairement aux `<a>` utilisés comme boutons).
- **`btn-outline-link` n'existe pas** — Bootstrap 5 ne définit pas de variante outline
  pour `"link"`. Toujours lever une erreur si `outline = TRUE` + `variant = "link"`.
- **`outline = TRUE` sans `variant`** — doit émettre un `warning()` car le flag serait
  silencieusement ignoré.
