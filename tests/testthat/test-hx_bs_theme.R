# hx_bs_theme() — object construction ----------------------------------------

test_that("hx_bs_theme() with no args returns an empty hx_bs_theme", {
  t <- hx_bs_theme()
  expect_s3_class(t, "hx_bs_theme")
  expect_length(t, 0)
})

test_that("hx_bs_theme(primary = ...) stores key 'primary'", {
  t <- hx_bs_theme(primary = "#e74c3c")
  expect_true("primary" %in% names(t))
  expect_equal(t[["primary"]], "#e74c3c")
})

test_that("hx_bs_theme(body_bg = ...) converts underscore to hyphen", {
  t <- hx_bs_theme(body_bg = "#ffffff")
  expect_true("body-bg" %in% names(t))
  expect_equal(t[["body-bg"]], "#ffffff")
})

test_that("hx_bs_theme(enable_rounded = FALSE) converts logical to 'false'", {
  t <- hx_bs_theme(enable_rounded = FALSE)
  expect_equal(t[["enable-rounded"]], "false")
})

test_that("hx_bs_theme(enable_shadows = TRUE) converts logical to 'true'", {
  t <- hx_bs_theme(enable_shadows = TRUE)
  expect_equal(t[["enable-shadows"]], "true")
})

test_that("hx_bs_theme() NULLs are filtered out", {
  t <- hx_bs_theme(primary = "#e74c3c", secondary = NULL)
  expect_false("secondary" %in% names(t))
  expect_length(t, 1)
})

test_that("hx_bs_theme(...) converts underscore names to hyphens", {
  t <- hx_bs_theme(nav_link_color = "#ff0000")
  expect_true("nav-link-color" %in% names(t))
  expect_equal(t[["nav-link-color"]], "#ff0000")
})

test_that("hx_bs_theme() returns S3 class 'hx_bs_theme'", {
  expect_s3_class(hx_bs_theme(primary = "#000"), "hx_bs_theme")
})

test_that("hx_bs_theme() errors on unnamed ... arguments", {
  # Pass valid values for all 16 named params, then one extra unnamed → hits ...
  named_args <- list(
    primary = "#abc",
    secondary = "#abc",
    success = "#abc",
    info = "#abc",
    warning = "#abc",
    danger = "#abc",
    light = "#abc",
    dark = "#abc",
    body_bg = "#abc",
    body_color = "#abc",
    font_size_base = "1rem",
    border_radius = "0.375rem",
    link_color = "#abc",
    enable_rounded = FALSE,
    enable_shadows = FALSE,
    enable_gradients = FALSE
  )
  expect_error(
    do.call(hx_bs_theme, c(named_args, list("#extra"))),
    "named"
  )
})

# enable_* validation — Bug 1 (NA logical) and Bug 2 (non-logical) ------------

test_that("hx_bs_theme(enable_rounded = NA) raises an error", {
  expect_error(hx_bs_theme(enable_rounded = NA), "TRUE or FALSE")
})

test_that("hx_bs_theme() with NA via ... raises an error", {
  expect_error(
    do.call(hx_bs_theme, list(custom_flag = NA)),
    "NA"
  )
})

test_that("hx_bs_theme(enable_rounded = 'yes') raises an error", {
  expect_error(hx_bs_theme(enable_rounded = "yes"), "TRUE or FALSE")
})

test_that("hx_bs_theme(enable_shadows = 1L) raises an error", {
  expect_error(hx_bs_theme(enable_shadows = 1L), "TRUE or FALSE")
})

# bs_theme alias ---------------------------------------------------------------

test_that("bs_theme is identical to hx_bs_theme", {
  expect_identical(bs_theme, hx_bs_theme)
})

# hx_bs_page() — theme type guard ---------------------------------------------

test_that("hx_bs_page() errors when theme is not an hx_bs_theme object", {
  expect_error(hx_bs_page(theme = list(primary = "#e74c3c")), "hx_bs_theme")
})

# hx_bs_page() — color_mode ---------------------------------------------------

test_that("hx_bs_page(color_mode = 'dark') adds data-bs-theme='dark' to <html>", {
  html <- as.character(hx_bs_page(color_mode = "dark", tags$h1("x")))
  expect_match(html, 'data-bs-theme="dark"', fixed = TRUE)
})

test_that("hx_bs_page(color_mode = 'light') adds data-bs-theme='light' to <html>", {
  html <- as.character(hx_bs_page(color_mode = "light", tags$h1("x")))
  expect_match(html, 'data-bs-theme="light"', fixed = TRUE)
})

test_that("hx_bs_page(color_mode = 'blue') raises an error", {
  expect_error(hx_bs_page(color_mode = "blue"))
})

test_that("hx_bs_page() without color_mode has no data-bs-theme attribute", {
  html <- as.character(hx_bs_page(tags$h1("x")))
  expect_false(grepl("data-bs-theme", html, fixed = TRUE))
})

# hx_bs_page() — fast path (no theme) ----------------------------------------

test_that("hx_bs_page() without theme links bootstrap.min.css", {
  html <- as.character(hx_bs_page(tags$h1("x")))
  expect_match(html, "bootstrap.min.css", fixed = TRUE)
})

test_that("hx_bs_page() without theme has no inline <style> for Bootstrap", {
  html <- as.character(hx_bs_page(tags$h1("x")))
  # The only <style> content should not contain Bootstrap CSS
  # (there is no <style> at all in the fast path)
  expect_false(grepl("<style>", html, fixed = TRUE))
})

# hx_bs_page() — SCSS theme path ----------------------------------------------

test_that("hx_bs_page(theme = hx_bs_theme()) injects <style> and omits <link> for Bootstrap CSS", {
  skip_if_not_installed("sass")
  skip_on_cran()

  t <- hx_bs_theme(primary = "#e74c3c")
  html <- as.character(hx_bs_page(theme = t, tags$h1("x")))

  expect_match(html, "<style>", fixed = TRUE)
  expect_false(grepl("bootstrap.min.css", html, fixed = TRUE))
})

test_that("compiled theme CSS contains Bootstrap custom property for primary colour", {
  skip_if_not_installed("sass")
  skip_on_cran()

  t <- hx_bs_theme(primary = "#e74c3c")
  css <- htmxr.bootstrap:::compile_bs_theme(t)

  expect_match(css, "--bs-primary:", fixed = TRUE)
})

# hx_bs_page() — theme + color_mode are orthogonal ----------------------------

test_that("hx_bs_page() accepts both theme and color_mode simultaneously", {
  skip_if_not_installed("sass")
  skip_on_cran()

  t <- hx_bs_theme(primary = "#e74c3c")
  html <- as.character(hx_bs_page(theme = t, color_mode = "dark", tags$h1("x")))

  expect_match(html, 'data-bs-theme="dark"', fixed = TRUE)
  expect_match(html, "<style>", fixed = TRUE)
})
