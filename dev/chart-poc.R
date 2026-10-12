library(plumber2)
library(htmxr)
library(htmltools)
library(jsonlite)

# Glue script — lit le JSON embarqué dans le DOM après chaque swap htmx
# et initialise Chart.js sur le canvas cible
glue_script <- r"(
document.addEventListener("htmx:afterSwap", function(evt) {
  const container = evt.detail.target;
  const scriptTag = container.querySelector("script[type='application/json']");
  if (!scriptTag) return;
  const config  = JSON.parse(scriptTag.textContent);
  const canvas  = container.querySelector("#" + scriptTag.dataset.chartTarget);
  if (!canvas) return;
  const existing = Chart.getChart(canvas);
  if (existing) existing.destroy();
  new Chart(canvas, config);
});
)"

#* @get /
#* @serializer html
#* @parser none
function() {
  hx_page(
    hx_head(title = "chartr POC"),
    # Chart.js via CDN (POC uniquement)
    tags$script(src = "https://cdn.jsdelivr.net/npm/chart.js"),
    tags$script(HTML(glue_script)),
    tags$div(
      style = "max-width: 600px; margin: 2rem auto;",
      tags$h1("chartr POC"),
      tags$span(
        id = "chart-indicator",
        class = "htmx-indicator",
        "Chargement..."
      ),
      tags$div(
        `hx-get` = "/chart",
        `hx-trigger` = "load",
        `hx-swap` = "innerHTML",
        `hx-indicator` = "#chart-indicator"
      )
    )
  )
}

#* @get /chart
#* @serializer html
#* @parser none
function() {
  Sys.sleep(4)
  config <- list(
    type = "bar",
    data = list(
      labels = c("Jan", "Fév", "Mar", "Avr", "Mai"),
      datasets = list(list(
        label = "Ventes",
        data = c(12, 19, 8, 15, 22),
        backgroundColor = "rgba(54, 162, 235, 0.5)",
        borderColor = "rgba(54, 162, 235, 1)",
        borderWidth = 1
      ))
    )
  )

  tags$div(
    tags$canvas(id = "my-chart"),
    tags$script(
      type = "application/json",
      `data-chart-target` = "my-chart",
      HTML(toJSON(config, auto_unbox = TRUE))
    )
  )
}
