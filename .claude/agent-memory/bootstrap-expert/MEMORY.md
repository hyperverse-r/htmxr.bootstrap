# Bootstrap Expert — Persistent Memory

See `patterns.md` for detailed component notes.

## Established API conventions in htmxr.bootstrap

- `variant` — lowercase Bootstrap suffix without prefix: `"primary"`, not `"btn-primary"`
- `size` — `NULL` (default, no modifier), `"sm"`, `"lg"`
- `outline = FALSE` — boolean, controls `btn-outline-{variant}` vs `btn-{variant}`
- `disabled = FALSE` — boolean
- `active = FALSE` — boolean (not yet implemented in hx_bs_button, recommended addition)
- `class = NULL` — extra CSS classes, appended after Bootstrap-generated classes
- `...` passthrough always present for arbitrary HTML attributes

## Key Bootstrap 5 vs Bootstrap 4 gotchas

- Block buttons: Bootstrap 5 uses `<div class="d-grid gap-2">` wrapper, NOT `btn-block` class on the button
- Float utilities: `float-start`/`float-end` (not `float-left`/`float-right`)
- Disabled `<a>` buttons: need `.disabled` class + `aria-disabled="true"` — but `<button disabled>` needs NO `.disabled` class

## Components audited

- `hx_bs_button()` — see `patterns.md#button`
