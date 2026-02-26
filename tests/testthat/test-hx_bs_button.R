test_that("hx_bs_button() creates a <button> with type='button'", {
  result <- hx_bs_button("Click me")
  expect_equal(result$name, "button")
  expect_equal(result$attribs$type, "button")
})

test_that("hx_bs_button() always has class 'btn'", {
  result <- hx_bs_button("Click me")
  expect_match(result$attribs$class, "\\bbtn\\b")
})

test_that("hx_bs_button() default variant='primary' adds btn-primary", {
  result <- hx_bs_button("Click me")
  expect_match(result$attribs$class, "\\bbtn-primary\\b")
})

test_that("hx_bs_button() variant='danger' adds btn-danger", {
  result <- hx_bs_button("Click me", variant = "danger")
  expect_match(result$attribs$class, "\\bbtn-danger\\b")
  expect_no_match(result$attribs$class, "\\bbtn-primary\\b")
})

test_that("hx_bs_button() outline=TRUE uses btn-outline-{variant}", {
  result <- hx_bs_button("Click me", outline = TRUE)
  expect_match(result$attribs$class, "\\bbtn-outline-primary\\b")
  expect_no_match(result$attribs$class, "\\bbtn-primary\\b")
})

test_that("hx_bs_button() outline=TRUE with variant='danger'", {
  result <- hx_bs_button("Click me", variant = "danger", outline = TRUE)
  expect_match(result$attribs$class, "\\bbtn-outline-danger\\b")
  expect_no_match(result$attribs$class, "\\bbtn-danger\\b")
})

test_that("hx_bs_button() size='sm' adds btn-sm", {
  result <- hx_bs_button("Click me", size = "sm")
  expect_match(result$attribs$class, "\\bbtn-sm\\b")
})

test_that("hx_bs_button() size='lg' adds btn-lg", {
  result <- hx_bs_button("Click me", size = "lg")
  expect_match(result$attribs$class, "\\bbtn-lg\\b")
})

test_that("hx_bs_button() size=NULL (default) adds no size class", {
  result <- hx_bs_button("Click me")
  expect_no_match(result$attribs$class, "\\bbtn-sm\\b")
  expect_no_match(result$attribs$class, "\\bbtn-lg\\b")
})

test_that("hx_bs_button() invalid size raises an error", {
  expect_error(hx_bs_button("Click me", size = "toto"))
})

test_that("hx_bs_button() invalid variant raises an error", {
  expect_error(hx_bs_button("Click me", variant = "nope"))
})

test_that("hx_bs_button() disabled=TRUE adds disabled attribute", {
  result <- hx_bs_button("Click me", disabled = TRUE)
  expect_true("disabled" %in% names(result$attribs))
})

test_that("hx_bs_button() disabled=FALSE (default) has no disabled attribute", {
  result <- hx_bs_button("Click me")
  expect_false("disabled" %in% names(result$attribs))
})

test_that("hx_bs_button() class appends extra CSS classes", {
  result <- hx_bs_button("Click me", class = "mt-2")
  expect_match(result$attribs$class, "\\bbtn\\b")
  expect_match(result$attribs$class, "\\bbtn-primary\\b")
  expect_match(result$attribs$class, "\\bmt-2\\b")
})

test_that("hx_bs_button() variant=NULL gives just 'btn'", {
  result <- hx_bs_button("Click me", variant = NULL)
  expect_equal(result$attribs$class, "btn")
})

test_that("hx_bs_button() passes htmx attributes", {
  result <- hx_bs_button(
    "Load",
    get = "/api/data",
    target = "#result",
    confirm = "Sure?"
  )
  expect_equal(result$attribs$`hx-get`, "/api/data")
  expect_equal(result$attribs$`hx-target`, "#result")
  expect_equal(result$attribs$`hx-confirm`, "Sure?")
})

test_that("outline=TRUE with variant='link' raises an error", {
  expect_error(hx_bs_button("Click me", variant = "link", outline = TRUE))
})

test_that("outline=TRUE with variant=NULL emits a warning", {
  expect_warning(hx_bs_button("Click me", variant = NULL, outline = TRUE))
})

test_that("bs_button is identical to hx_bs_button", {
  expect_identical(bs_button, hx_bs_button)
})
