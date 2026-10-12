library(htmxr.bootstrap)


brand_theme <- hx_bs_theme(
  primary = "#EFD9CE",
  secondary = "#DEC0F1",
  success = "#B79CED",
  danger = "#957FEF",
  border_radius = "0.125rem",
  enable_shadows = TRUE
)

#* @get /
#* @parser none
#* @serializer html
function() {
  hx_bs_page(
    theme = brand_theme,
    color_mode = "dark",
    hx_head(
      title = "Custom Bootstrap theme"
    ),
    tags$div(
      class = "container py-5",
      tags$h1(
        class = "mb-1",
        "Custom Bootstrap theme"
      ),
      tags$p(
        class = "text-muted mb-4",
        tags$code("hx_bs_theme()"),
        " recompiles Bootstrap from SCSS — hover states, alerts, badges",
        " all reflect the brand colours below."
      ),

      tags$h5(
        class = "mt-4 mb-2",
        "Brand colours"
      ),
      tags$div(
        class = "d-flex gap-2 mb-4",
        tags$span(
          class = "badge bg-primary fs-6",
          "primary #e74c3c"
        ),
        tags$span(
          class = "badge bg-secondary fs-6",
          "secondary #2ecc71"
        ),
        tags$span(
          class = "badge bg-success fs-6",
          "success #27ae60"
        ),
        tags$span(
          class = "badge bg-danger fs-6",
          "danger #c0392b"
        )
      ),

      tags$h5(
        class = "mt-2 mb-2",
        "Buttons"
      ),
      tags$div(
        class = "d-flex flex-wrap gap-2 mb-4",
        hx_bs_button(
          "Primary",
          variant = "primary",
          get = "/ping",
          target = "#result",
          swap = "innerHTML"
        ),
        hx_bs_button(
          "Secondary",
          variant = "secondary",
          get = "/ping",
          target = "#result",
          swap = "innerHTML"
        ),
        hx_bs_button(
          "Success",
          variant = "success",
          get = "/ping",
          target = "#result",
          swap = "innerHTML"
        ),
        hx_bs_button(
          "Danger",
          variant = "danger",
          get = "/ping",
          target = "#result",
          swap = "innerHTML"
        ),
        hx_bs_button(
          "Outline",
          variant = "primary",
          outline = TRUE,
          get = "/ping",
          target = "#result",
          swap = "innerHTML"
        )
      ),
      tags$div(
        id = "result",
        class = "alert alert-light border mb-4",
        "Click a button to test the htmx round-trip."
      ),

      tags$h5(
        class = "mb-2",
        "Alerts"
      ),
      tags$div(
        class = "alert alert-primary",
        "alert-primary"
      ),
      tags$div(
        class = "alert alert-secondary",
        "alert-secondary"
      ),
      tags$div(
        class = "alert alert-success",
        "alert-success"
      ),
      tags$div(
        class = "alert alert-danger",
        "alert-danger"
      )
    )
  )
}

#* @get /ping
#* @parser none
#* @serializer none
function() {
  tags$span(paste("Pong!", format(Sys.time(), "%H:%M:%S")))
}
