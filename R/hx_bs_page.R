#' Generate a complete HTML page with htmx and Bootstrap 5
#'
#' Like [htmxr::hx_page()], but automatically injects Bootstrap 5 CSS and JS
#' in the page head. Use [hx_bs_serve_assets()] to configure your plumber2 API
#' to serve the required static files.
#'
#' @param ... page content. Use [htmxr::hx_head()] to add elements to the head.
#' @param lang language code for the `<html>` element (default `"en"`).
#' @param html_attrs a named list of additional attributes to set on the
#'   `<html>` element (e.g. `list("data-bs-theme" = "dark")` for dark mode).
#'
#' @importFrom htmltools tags
#' @importFrom htmxr hx_page
#'
#' @return A length-one character string containing the full HTML document
#'   (including `<!DOCTYPE html>`), ready to be served as an HTTP response.
#'
#' @examples
#' hx_bs_page(tags$h1("Hello, Bootstrap!"))
#'
#' hx_bs_page(
#'   hx_head(title = "My app"),
#'   tags$p("Hello, world!")
#' )
#'
#' @export
hx_bs_page <- function(..., lang = "en", html_attrs = list()) {
  bs_head <- structure(
    list(
      tags$link(
        rel = "stylesheet",
        href = "/htmxr.bootstrap/assets/bootstrap/5.3.8/css/bootstrap.min.css"
      ),
      tags$script(
        src = "/htmxr.bootstrap/assets/bootstrap/5.3.8/js/bootstrap.bundle.min.js"
      )
    ),
    class = "hx_head"
  )
  hx_page(bs_head, ..., lang = lang, html_attrs = html_attrs)
}
