library(htmxr.bootstrap)
library(htmxr)

#* @get /
#* @parser none
#* @serializer html
function() {
  hx_bs_page(
    hx_head(title = "Hello, Bootstrap!"),
    tags$div(
      class = "container py-5",
      tags$h1(class = "mb-4", "Hello, Bootstrap!"),
      tags$p(
        class = "text-muted mb-4",
        "Click a button to greet the server."
      ),
      tags$div(
        class = "d-flex gap-2 mb-4",
        hx_bs_button(
          "Say hello",
          variant = "warning",
          get = "/greet",
          target = "#result",
          swap = "innerHTML"
        ),
        hx_bs_button(
          "Say hello (outline)",
          variant = "secondary",
          outline = TRUE,
          get = "/greet",
          target = "#result",
          swap = "innerHTML"
        ),
        hx_bs_button("Disabled", disabled = TRUE)
      ),
      tags$div(id = "result", class = "alert alert-light border")
    )
  )
}

#* @get /greet
#* @parser none
#* @serializer none
function() {
  tags$span(
    paste("Hello from the server!", format(Sys.time(), "%H:%M:%S"))
  )
}
