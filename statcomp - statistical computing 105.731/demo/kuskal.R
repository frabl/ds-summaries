kwtest <- function (x, g, ...) {
  if (is.list(x)) {
    if (length(x) < 2L) {
      stop("'x' must be a list with at least 2 elements")
    }

    if (!missing(g)) {
      warning("'x' is a list, so ignoring argument 'g'")
    }

    if (!all(sapply(x, is.numeric))) {
      warning("some elements of 'x' are not numeric and will be coerced to numeric")
    }
    k <- length(x)
    l <- lengths(x)

    if (any(l == 0L)) {
      stop("all groups must contain data")
    }
    g <- factor(rep.int(seq_len(k), l))
    x <- unlist(x)

  } else {
    if (length(x) != length(g)) {
      stop("'x' and 'g' must have the same length")
    }
    g <- factor(g)
    k <- nlevels(g)
    if (k < 2L) {
      stop("all observations are in the same group")
    }
  }

  n <- length(x)
  if (n < 2L) {
    stop("not enough observations")
  }

  r <- rank(x)
  TIES <- table(x)
  STATISTIC <- sum(tapply(r, g, sum)^2/tapply(r, g, length))
  STATISTIC <- ((12 * STATISTIC/ (n * (n + 1)) - 3 * (n + 1))/(1 - sum(TIES^3 - TIES)/(n^3 - n)))
  PARAMETER <- k - 1L
  PVAL <- pchisq(STATISTIC, PARAMETER, lower.tail = FALSE)
  names(STATISTIC) <- "Kruskal-Wallis chi-squared"
  names(PARAMETER) <- "df"

  RVAL <- list(statistic = STATISTIC, parameter = PARAMETER, p.value = PVAL, method = "Kruskal-Wallis rank sum test")

  return(RVAL)
}
