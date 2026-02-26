#' Bootstrap Button
#'
#' Creates a `<button>` element styled with Bootstrap 5 classes.
#' Wraps [htmxr::hx_button()] and injects Bootstrap classes automatically.
#'
#' @param label Button label (text or HTML content).
#' @param id Optional element id.
#' @param variant Bootstrap colour variant. One of `"primary"`, `"secondary"`,
#'   `"success"`, `"danger"`, `"warning"`, `"info"`, `"light"`, `"dark"`,
#'   `"link"`, or `NULL` (no colour class, just `"btn"`).
#' @param size Button size: `NULL` (default), `"sm"`, or `"lg"`.
#' @param outline If `TRUE`, applies the `btn-outline-{variant}` class instead
#'   of `btn-{variant}`.
#' @param disabled If `TRUE`, adds the `disabled` HTML attribute.
#' @param class Additional CSS classes appended after the Bootstrap classes.
#' @param get URL for `hx-get`.
#' @param post URL for `hx-post`.
#' @param target CSS selector for `hx-target`.
#' @param swap Swap strategy for `hx-swap`.
#' @param trigger Trigger specification for `hx-trigger`.
#' @param indicator CSS selector for `hx-indicator`.
#' @param swap_oob Out-of-band swap targets for `hx-swap-oob`.
#' @param confirm Confirmation message for `hx-confirm`.
#' @param ... Additional HTML attributes passed to the `<button>` element.
#'
#' @return An [htmltools::tags] object.
#'
#' @importFrom htmxr hx_button
#' @importFrom htmltools tagAppendAttributes
#'
#' @examples
#' # Default primary button
#' hx_bs_button("Click me")
#'
#' # Danger outline button, small
#' hx_bs_button("Delete", variant = "danger", outline = TRUE, size = "sm")
#'
#' # Button with htmx GET request
#' hx_bs_button("Load data", get = "/api/data", target = "#result")
#'
#' # Disabled button
#' hx_bs_button("Unavailable", disabled = TRUE)
#'
#' @export
hx_bs_button <- function(
  label,
  id = NULL,
  variant = "primary",
  size = NULL,
  outline = FALSE,
  disabled = FALSE,
  class = NULL,
  get = NULL,
  post = NULL,
  target = NULL,
  swap = NULL,
  trigger = NULL,
  indicator = NULL,
  swap_oob = NULL,
  confirm = NULL,
  ...
) {
  # 1. Validation
  variant <- check_arg_or_null(
    variant,
    c(
      "primary",
      "secondary",
      "success",
      "danger",
      "warning",
      "info",
      "light",
      "dark",
      "link"
    )
  )
  size <- check_arg_or_null(size, c("sm", "lg"))
  stopifnot(is.logical(outline), length(outline) == 1)
  stopifnot(is.logical(disabled), length(disabled) == 1)

  # 2. Outline guards
  if (outline && is.null(variant)) {
    warning("`outline = TRUE` has no effect when `variant = NULL`.")
  }
  if (outline && identical(variant, "link")) {
    stop(
      "`btn-outline-link` does not exist in Bootstrap 5. ",
      "Use `variant = \"link\"` without `outline = TRUE`."
    )
  }

  # 3. Build Bootstrap class string
  btn_variant <- if (!is.null(variant)) {
    if (outline) paste0("btn-outline-", variant) else paste0("btn-", variant)
  } else {
    NULL
  }
  btn_size <- if (!is.null(size)) paste0("btn-", size) else NULL
  bs_class <- paste(c("btn", btn_variant, btn_size, class), collapse = " ")

  # 4. Delegate to the htmxr primitive
  btn <- hx_button(
    label,
    id = id,
    class = bs_class,
    get = get,
    post = post,
    target = target,
    swap = swap,
    trigger = trigger,
    indicator = indicator,
    swap_oob = swap_oob,
    confirm = confirm,
    ...
  )

  # 5. Disabled state — HTML boolean attribute (NA = attribute without value)
  if (disabled) btn <- tagAppendAttributes(btn, disabled = NA)

  btn
}
