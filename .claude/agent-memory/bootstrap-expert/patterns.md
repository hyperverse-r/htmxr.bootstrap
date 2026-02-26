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
