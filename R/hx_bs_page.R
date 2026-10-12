#' Generate a complete HTML page with htmx and Bootstrap 5
#'
#' Like [htmxr::hx_page()], but automatically injects Bootstrap 5 CSS and JS
#' in the page head. Use [hx_bs_serve_assets()] to configure your plumber2 API
#' to serve the required static files.
#'
#' @param ... page content. Use [htmxr::hx_head()] to add elements to the head.
#' @param theme an `hx_bs_theme` object created by [hx_bs_theme()], or `NULL`
#'   (default). When supplied, Bootstrap is recompiled from SCSS with your
#'   variable overrides and injected as an inline `<style>` tag instead of the
#'   pre-built `bootstrap.min.css`. Requires the \pkg{sass} package.
#' @param color_mode Bootstrap 5.3 colour mode: `"light"`, `"dark"`, or `NULL`
#'   (default, no `data-bs-theme` attribute). Sets `data-bs-theme` on `<html>`.
#' @param lang language code for the `<html>` element (default `"en"`).
#' @param html_attrs a named list of additional attributes to set on the
#'   `<html>` element.
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
#' hx_bs_page(color_mode = "dark", tags$h1("Dark mode"))
#'
#' @export
hx_bs_page <- function(
  ...,
  theme = NULL,
  color_mode = NULL,
  lang = "en",
  html_attrs = list()
) {
  if (!is.null(theme) && !inherits(theme, "hx_bs_theme")) {
    stop(
      "`theme` must be an `hx_bs_theme` object created by `hx_bs_theme()`.",
      call. = FALSE
    )
  }

  color_mode <- check_arg_or_null(color_mode, c("light", "dark"))

  if (!is.null(color_mode)) {
    html_attrs[["data-bs-theme"]] <- color_mode
  }

  if (!is.null(theme)) {
    css <- compile_bs_theme(theme)
    bs_css <- tags$style(css)
    bs_js <- tags$script(
      src = "/htmxr.bootstrap/assets/bootstrap/5.3.8/js/bootstrap.bundle.min.js"
    )
    bs_head <- structure(list(bs_css, bs_js), class = "hx_head")
  } else {
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
  }

  hx_page(bs_head, ..., lang = lang, html_attrs = html_attrs)
}
