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
