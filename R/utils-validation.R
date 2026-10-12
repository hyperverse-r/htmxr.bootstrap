# Internal validation helpers — @noRd
# These are not exported and not documented publicly.

# check_arg_or_null ----------------------------------------------------------
# Validates a string argument against a set of allowed choices.
# NULL means "feature disabled / not specified" — returns NULL as-is.
# Usage:
#   variant <- check_arg_or_null(variant, c("primary", "secondary", ...))
#   size    <- check_arg_or_null(size, c("sm", "lg"))
check_arg_or_null <- function(arg, choices) {
  if (is.null(arg)) NULL else match.arg(arg, choices)
}

# check_bool_or_null ------------------------------------------------------------
# Validates a logical argument: NULL → pass-through; TRUE/FALSE → pass-through;
# NA, strings, integers, etc. → stop().
# Usage:
#   enable_rounded <- check_bool_or_null(enable_rounded)
check_bool_or_null <- function(x, arg = deparse(substitute(x))) {
  if (is.null(x)) return(invisible(NULL))
  if (!is.logical(x) || length(x) != 1 || is.na(x))
    stop(sprintf("`%s` must be TRUE or FALSE (not NA).", arg), call. = FALSE)
  invisible(x)
}
