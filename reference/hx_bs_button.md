# Bootstrap Button

Creates a `<button>` element styled with Bootstrap 5 classes. Wraps
[`htmxr::hx_button()`](https://hyperverse-r.github.io/htmxr/reference/hx_button.html)
and injects Bootstrap classes automatically.

## Usage

``` r
hx_bs_button(
  label,
  id = NULL,
  variant = "primary",
  size = NULL,
  outline = FALSE,
  disabled = FALSE,
  class = NULL,
  get = NULL,
  post = NULL,
  target = NULL,
  swap = NULL,
  trigger = NULL,
  indicator = NULL,
  swap_oob = NULL,
  confirm = NULL,
  ...
)

bs_button(
  label,
  id = NULL,
  variant = "primary",
  size = NULL,
  outline = FALSE,
  disabled = FALSE,
  class = NULL,
  get = NULL,
  post = NULL,
  target = NULL,
  swap = NULL,
  trigger = NULL,
  indicator = NULL,
  swap_oob = NULL,
  confirm = NULL,
  ...
)
```

## Arguments

- label:

  Button label (text or HTML content).

- id:

  Optional element id.

- variant:

  Bootstrap colour variant. One of `"primary"`, `"secondary"`,
  `"success"`, `"danger"`, `"warning"`, `"info"`, `"light"`, `"dark"`,
  `"link"`, or `NULL` (no colour class, just `"btn"`).

- size:

  Button size: `NULL` (default), `"sm"`, or `"lg"`.

- outline:

  If `TRUE`, applies the `btn-outline-{variant}` class instead of
  `btn-{variant}`.

- disabled:

  If `TRUE`, adds the `disabled` HTML attribute.

- class:

  Additional CSS classes appended after the Bootstrap classes.

- get:

  URL for `hx-get`.

- post:

  URL for `hx-post`.

- target:

  CSS selector for `hx-target`.

- swap:

  Swap strategy for `hx-swap`.

- trigger:

  Trigger specification for `hx-trigger`.

- indicator:

  CSS selector for `hx-indicator`.

- swap_oob:

  Out-of-band swap targets for `hx-swap-oob`.

- confirm:

  Confirmation message for `hx-confirm`.

- ...:

  Additional HTML attributes passed to the `<button>` element.

## Value

An
[htmltools::tags](https://rstudio.github.io/htmltools/reference/builder.html)
object.

## Examples

``` r
# Default primary button
hx_bs_button("Click me")
#> <button type="button" class="btn btn-primary">Click me</button>

# Danger outline button, small
hx_bs_button("Delete", variant = "danger", outline = TRUE, size = "sm")
#> <button type="button" class="btn btn-outline-danger btn-sm">Delete</button>

# Button with htmx GET request
hx_bs_button("Load data", get = "/api/data", target = "#result")
#> <button type="button" class="btn btn-primary" hx-get="/api/data" hx-target="#result">Load data</button>

# Disabled button
hx_bs_button("Unavailable", disabled = TRUE)
#> <button type="button" class="btn btn-primary" disabled>Unavailable</button>
```
