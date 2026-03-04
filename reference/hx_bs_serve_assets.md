# Serve htmxr.bootstrap static assets

Configures a plumber2 API to serve both htmxr's assets (htmx.js) and
htmxr.bootstrap's assets (Bootstrap CSS and JS) as static files. This is
a convenience wrapper that replaces calling both
[`htmxr::hx_serve_assets()`](https://hyperverse-r.github.io/htmxr/reference/hx_serve_assets.html)
and the Bootstrap-specific statics separately.

## Usage

``` r
hx_bs_serve_assets(api)

bs_serve_assets(api)
```

## Arguments

- api:

  a plumber2 API object

## Value

the API object (modified, for piping)

## Examples

``` r
if (FALSE) { # \dontrun{
  plumber2::api() |>
    hx_bs_serve_assets()
} # }
```
