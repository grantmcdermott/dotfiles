# Platform-specific settings
if (Sys.info()[["sysname"]] == "Linux") {
  options(HTTPUserAgent = sprintf(
    "R/%s R (%s)",
    getRversion(),
    paste(getRversion(), R.version["platform"], R.version["arch"], R.version["os"])
  ))
  options(repos = c(CRAN = "https://p3m.dev/cran/__linux__/manylinux_2_28/latest"))
} else {
  options(repos = c(CRAN = "https://cloud.r-project.org"))
}

# General options
options(width = 120)
options(setWidthOnResize = TRUE)
options(dplyr.summarise.inform = FALSE)
options(tigris_use_cache = TRUE)
options(tinyplot_file.width = 8, tinyplot_file.height = 5)

# Custom data.frame print method
print.data.frame = function(x, ..., topn = 5, nrows = 20) {
  nr = nrow(x)

  if (nr <= nrows) {
    out = x
    splitprint = FALSE
  } else {
    out = rbind(head(x, topn), tail(x, topn))
    splitprint = TRUE
  }

  type_map = c(
    numeric = "<num>", integer = "<int>", character = "<chr>",
    factor = "<fct>", logical = "<lgl>", Date = "<Date>",
    POSIXct = "<dttm>", complex = "<cpl>", ordered = "<ord>"
  )
  classes = sapply(x, \(col) class(col)[1])
  abbs = unname(type_map[classes])
  abbs[is.na(abbs)] = paste0("<", classes[is.na(abbs)], ">")
  names(abbs) = colnames(x)

  cols = lapply(out, \(col) format(col, ..., justify = "right"))
  toprint = do.call(cbind, cols)
  dimnames(toprint) = list(rownames(out), colnames(x))

  if (identical(rownames(x), as.character(seq_len(nr)))) {
    rn = if (splitprint) {
      c(seq_len(topn), seq.int(to = nr, length.out = topn))
    } else {
      seq_len(nr)
    }
    rownames(toprint) = format(rn, right = TRUE)
  }

  toprint = rbind(abbs, toprint)
  rownames(toprint)[1] = " "

  if (splitprint) {
    sep_row = matrix("", 1, ncol(toprint))
    toprint = rbind(
      head(toprint, topn + 1),
      sep_row,
      tail(toprint, topn)
    )
    rownames(toprint)[topn + 2] = "---"
    rownames(toprint) = format(rownames(toprint), justify = "right")
  }

  print(toprint, right = TRUE, quote = FALSE)
  invisible(x)
}

# btw MCP session (if available)
if (requireNamespace("btw", quietly = TRUE)) btw::btw_mcp_session()
