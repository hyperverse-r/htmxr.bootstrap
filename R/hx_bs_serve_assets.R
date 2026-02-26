#' Serve htmxr.bootstrap static assets
#'
#' Configures a plumber2 API to serve both htmxr's assets (htmx.js) and
#' htmxr.bootstrap's assets (Bootstrap CSS and JS) as static files.
#' This is a convenience wrapper that replaces calling both
#' [htmxr::hx_serve_assets()] and the Bootstrap-specific statics separately.
#'
#' @param api a plumber2 API object
#'
#' @importFrom htmxr hx_serve_assets
#' @importFrom plumber2 api_statics
#'
#' @return the API object (modified, for piping)
#'
#' @examples
#' \dontrun{
#'   plumber2::api() |>
#'     hx_bs_serve_assets()
#' }
#'
#' @export
hx_bs_serve_assets <- function(api) {
  api <- hx_serve_assets(api)
  api_statics(
    api,
    at = "/htmxr.bootstrap/assets/",
    path = system.file("assets", package = "htmxr.bootstrap")
  )
}
