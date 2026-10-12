#' Create a Bootstrap 5 theme by overriding Sass variables
#'
#' @description
#' Constructs a theme object that overrides Bootstrap 5 Sass variables before
#' compilation. Requires the \pkg{sass} package. Pass the result to the
#' `theme` argument of [hx_bs_page()].
#'
#' Bootstrap 5 compiles its component colours (hover, active, disabled states
#' of buttons, alerts, badges, etc.) from Sass variables. The pre-built
#' `bootstrap.min.css` contains hardcoded hex values — overriding
#' `--bs-primary` in plain CSS alone does **not** change `.btn-primary`.
#' `hx_bs_theme()` triggers a recompilation from the bundled SCSS sources,
#' injecting your values before Bootstrap's `!default` declarations.
#'
#' @param primary,secondary,success,info,warning,danger,light,dark
#'   Brand colour overrides (hex strings, e.g. `"#e74c3c"`).
#' @param body_bg,body_color Page background and text colour.
#' @param font_size_base Base font size (e.g. `"1rem"`).
#' @param border_radius Default border radius (e.g. `"0.375rem"`).
#' @param link_color Hyperlink colour.
#' @param enable_rounded,enable_shadows,enable_gradients
#'   Toggle Bootstrap global options (`TRUE`/`FALSE`).
#' @param ... Additional Sass variable overrides. Parameter names use
#'   underscores and are automatically converted to hyphenated Sass variable
#'   names (e.g. `nav_link_color` → `$nav-link-color`).
#'
#' @return An S3 object of class `"hx_bs_theme"` — a named list mapping Sass
#'   variable names (without `$`) to their string values.
#'
#' @examples
#' hx_bs_theme(primary = "#e74c3c", secondary = "#2ecc71")
#'
#' hx_bs_theme(enable_rounded = FALSE, enable_shadows = TRUE)
#'
#' @export
hx_bs_theme <- function(
  primary = NULL,
  secondary = NULL,
  success = NULL,
  info = NULL,
  warning = NULL,
  danger = NULL,
  light = NULL,
  dark = NULL,
  body_bg = NULL,
  body_color = NULL,
  font_size_base = NULL,
  border_radius = NULL,
  link_color = NULL,
  enable_rounded = NULL,
  enable_shadows = NULL,
  enable_gradients = NULL,
  ...
) {
  enable_rounded <- check_bool_or_null(enable_rounded)
  enable_shadows <- check_bool_or_null(enable_shadows)
  enable_gradients <- check_bool_or_null(enable_gradients)

  named_args <- list(
    primary = primary,
    secondary = secondary,
    success = success,
    info = info,
    warning = warning,
    danger = danger,
    light = light,
    dark = dark,
    "body-bg" = body_bg,
    "body-color" = body_color,
    "font-size-base" = font_size_base,
    "border-radius" = border_radius,
    "link-color" = link_color,
    "enable-rounded" = enable_rounded,
    "enable-shadows" = enable_shadows,
    "enable-gradients" = enable_gradients
  )

  dots <- list(...)
  if (length(dots) > 0) {
    if (is.null(names(dots)) || any(names(dots) == "")) {
      stop(
        "All `...` arguments must be named Sass variable overrides.",
        call. = FALSE
      )
    }
    names(dots) <- gsub("_", "-", names(dots), fixed = TRUE)
  }

  all_vars <- c(named_args, dots)
  all_vars <- Filter(Negate(is.null), all_vars)

  # Convert R logicals to Sass boolean strings
  all_vars <- lapply(all_vars, function(v) {
    if (is.logical(v)) {
      if (is.na(v)) stop("Sass boolean values cannot be NA.", call. = FALSE)
      if (isTRUE(v)) "true" else "false"
    } else {
      as.character(v)
    }
  })

  structure(all_vars, class = "hx_bs_theme")
}

#' Compile a Bootstrap 5 theme object to CSS
#'
#' Builds the SCSS override block from an `hx_bs_theme` object, then compiles
#' the bundled Bootstrap SCSS sources using \pkg{sass}. Returns the resulting
#' compressed CSS as a character string.
#'
#' @param theme An `"hx_bs_theme"` object returned by [hx_bs_theme()].
#' @return A character string containing the compiled and compressed CSS.
#' @noRd
compile_bs_theme <- function(theme) {
  if (!requireNamespace("sass", quietly = TRUE)) {
    stop(
      "The 'sass' package is required to compile Bootstrap themes. ",
      "Install it with: install.packages('sass')",
      call. = FALSE
    )
  }

  scss_path <- system.file(
    "assets/bootstrap/5.3.8/scss/bootstrap.scss",
    package = "htmxr.bootstrap"
  )

  if (scss_path == "") {
    stop(
      "Bootstrap SCSS sources not found. ",
      "The 'htmxr.bootstrap' package may not be properly installed.",
      call. = FALSE
    )
  }

  if (length(theme) == 0) {
    return(sass::sass(
      input = sass::sass_file(scss_path),
      options = sass::sass_options(output_style = "compressed"),
      cache = sass::sass_cache_get()
    ))
  }

  # sass_layer() places `defaults` before `rules` in the compiled output.
  # Our declarations have no `!default`, so they set the variable first.
  # Bootstrap's `$primary: $blue !default;` then sees a variable already
  # defined and skips the assignment — our value wins.
  override_block <- paste0(
    "$",
    names(theme),
    ": ",
    unlist(theme),
    ";",
    collapse = "\n"
  )

  sass::sass(
    input = sass::sass_layer(
      defaults = override_block,
      rules = sass::sass_file(scss_path)
    ),
    options = sass::sass_options(output_style = "compressed"),
    cache = sass::sass_cache_get()
  )
}
