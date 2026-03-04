# Generate a complete HTML page with htmx and Bootstrap 5

Like
[`htmxr::hx_page()`](https://hyperverse-r.github.io/htmxr/reference/hx_page.html),
but automatically injects Bootstrap 5 CSS and JS in the page head. Use
[`hx_bs_serve_assets()`](https://hyperverse-r.github.io/htmxr.bootstrap/reference/hx_bs_serve_assets.md)
to configure your plumber2 API to serve the required static files.

## Usage

``` r
hx_bs_page(..., lang = "en", html_attrs = list())

bs_page(..., lang = "en", html_attrs = list())
```

## Arguments

- ...:

  page content. Use
  [`htmxr::hx_head()`](https://hyperverse-r.github.io/htmxr/reference/hx_head.html)
  to add elements to the head.

- lang:

  language code for the `<html>` element (default `"en"`).

- html_attrs:

  a named list of additional attributes to set on the `<html>` element
  (e.g. `list("data-bs-theme" = "dark")` for dark mode).

## Value

A length-one character string containing the full HTML document
(including `<!DOCTYPE html>`), ready to be served as an HTTP response.

## Examples

``` r
hx_bs_page(tags$h1("Hello, Bootstrap!"))
#> [1] "<!DOCTYPE html>\n<html lang=\"en\">\n  <head>\n    <meta charset=\"UTF-8\"/>\n    <script src=\"/htmxr/assets/htmx/2.0.8/htmx.min.js\"></script>\n    <link rel=\"stylesheet\" href=\"/htmxr.bootstrap/assets/bootstrap/5.3.8/css/bootstrap.min.css\"/>\n    <script src=\"/htmxr.bootstrap/assets/bootstrap/5.3.8/js/bootstrap.bundle.min.js\"></script>\n  </head>\n  <body>\n    <h1>Hello, Bootstrap!</h1>\n  </body>\n</html>"

hx_bs_page(
  hx_head(title = "My app"),
  tags$p("Hello, world!")
)
#> [1] "<!DOCTYPE html>\n<html lang=\"en\">\n  <head>\n    <meta charset=\"UTF-8\"/>\n    <script src=\"/htmxr/assets/htmx/2.0.8/htmx.min.js\"></script>\n    <link rel=\"stylesheet\" href=\"/htmxr.bootstrap/assets/bootstrap/5.3.8/css/bootstrap.min.css\"/>\n    <script src=\"/htmxr.bootstrap/assets/bootstrap/5.3.8/js/bootstrap.bundle.min.js\"></script>\n    <title>My app</title>\n  </head>\n  <body>\n    <p>Hello, world!</p>\n  </body>\n</html>"
```
