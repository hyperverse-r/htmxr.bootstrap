# Component Patterns

## Button (`hx_bs_button`)

**Audited:** 2026-02-24

### Required Bootstrap 5 classes

- `btn` — always required, unconditional base class
- `btn-{variant}` or `btn-outline-{variant}` — when variant is non-NULL
- `btn-{size}` — only when size is "sm" or "lg"; omit entirely for default size

### Disabled state rules (Bootstrap 5)

- `<button>` element: add `disabled` boolean HTML attribute only. No `.disabled` class needed.
- `<a>` element used as button: add `.disabled` class + `aria-disabled="true"`. No `disabled` HTML attribute (anchors don't support it).
- htmltools convention: `disabled = NA` produces a valueless boolean attribute.

### Active state rules (Bootstrap 5)

- Add `.active` class to button
- Add `aria-pressed="true"` HTML attribute
- For JS toggle: add `data-bs-toggle="button"` (can be passed via `...`)
- Active state is NOT implemented in current hx_bs_button — recommended as `active = FALSE` parameter

### Edge case: outline = TRUE + variant = NULL

- Produces only class `"btn"` — technically valid but semantically wrong
- Should emit a warning: `warning("outline = TRUE has no effect when variant = NULL")`

### Valid variants (Bootstrap 5.3)

Filled: primary, secondary, success, danger, warning, info, light, dark, link
Outline: primary, secondary, success, danger, warning, info, light, dark
(No `btn-outline-link` — link is filled-only)

### Block buttons

NOT a class on `<button>`. Bootstrap 5 uses a `<div class="d-grid gap-2">` wrapper.
Do not expose a `block` parameter on the button function itself — belongs to a layout wrapper.

---

## Theme (`hx_bs_theme` + `hx_bs_page`)

**Audited:** 2026-02-27

### Confirmed Bootstrap 5.3 Sass variable names (no prefix, no `!default` needed in overrides)

- Theme colors: `$primary`, `$secondary`, `$success`, `$info`, `$warning`, `$danger`, `$light`, `$dark`
- Body: `$body-bg` (default `$white`), `$body-color` (default `$gray-900`)
- Typography: `$font-size-base`
- Shape: `$border-radius`, `$border-radius-sm`, `$border-radius-lg`
- Links: `$link-color` (default `$primary`)
- Enable flags: `$enable-rounded` (true), `$enable-shadows` (false), `$enable-gradients` (false),
  `$enable-transitions` (true), `$enable-dark-mode` (true), `$enable-negative-margins` (false),
  and ~13 others — full list at https://getbootstrap.com/docs/5.3/customize/options/

### R parameter naming convention for Sass variables

- R uses underscores: `body_bg`, `font_size_base`, `enable_rounded`
- Conversion to hyphens happens inside the function; user never sees a hyphen
- `...` accepts additional variables; names must be provided (unnamed dots produce `$: value;` malformed SCSS)

### `sass_layer()` defaults slot semantics

- `sass_layer(defaults = override_block, rules = sass_file(...))` places `defaults` BEFORE `rules`
- Override block with NO `!default` → wins against Bootstrap's `$var: value !default` because Sass
  skips `!default` assignment when variable is already defined
- Correctness depends on `bootstrap.scss` importing `_variables.scss` after `_functions.scss`
  (this is the official Bootstrap import order — safe for the bundled SCSS)

### Color mode (`data-bs-theme`)

- Bootstrap 5.3 uses `data-bs-theme="light"` or `data-bs-theme="dark"` on `<html>`
- R parameter: `color_mode = NULL | "light" | "dark"` — validated with `check_arg_or_null()`
- When `enable_dark_mode = FALSE` is compiled into CSS, `data-bs-theme` has no effect;
  pair these two parameters for consistency

### Validation gaps confirmed in audit (2026-02-27)

- `theme` argument in `hx_bs_page()` DOES have a type guard: `!inherits(theme, "hx_bs_theme")` raises stop() — correct
- Unnamed dots in `hx_bs_theme(...)` correctly raise stop() — the guard is present
- BLOCKING BUG: `enable_rounded = NA` produces `$enable-rounded: false;` silently — `isTRUE(NA)` is FALSE.
  Fix: guard `if (is.logical(v) && is.na(v)) stop(...)` before boolean conversion in `lapply` at line 77-80
- BLOCKING: named `enable_*` parameters accept strings silently — `enable_rounded = "yes"` bypasses conversion
  and emits `$enable-rounded: yes;` (valid Sass string, semantically wrong boolean)

### Named parameters confirmed missing (non-blocking suggestions)

- `font_family_base` — most common branding override after theme colors; only via `...` currently
- `border_radius_sm`, `border_radius_lg` — needed for complete rounding control; base only is exposed
- `enable_dark_mode`, `enable_transitions` — complete the `$enable-*` family; `enable_dark_mode`
  has a silent interaction with `hx_bs_page(color_mode = "dark")`

### Footgun: `enable_dark_mode = FALSE` + `color_mode = "dark"`

When a user passes `enable_dark_mode = FALSE` via `...` to `hx_bs_theme()` and separately sets
`color_mode = "dark"` in `hx_bs_page()`, Bootstrap's dark mode CSS is not compiled but
`data-bs-theme="dark"` is still set on `<html>`. Result: broken page with no warning.
Mitigation: inspect compiled theme object in `hx_bs_page()` for `theme[["enable-dark-mode"]] == "false"`
and emit `warning()` when `color_mode` is simultaneously set.

### `...` escape hatch correctness

- Underscore → hyphen conversion: `gsub("_", "-", names(dots), fixed = TRUE)` — correct
- Unnamed dots guard: present and raises stop() — correct
- String passthrough bypasses boolean conversion — correct for CSS values, but exposes enable_* abuse
