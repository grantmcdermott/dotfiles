options(repos = c(PPM = "https://packagemanager.posit.co/cran/latest"
                  # , CRAN = "https://cran.rstudio.com/"
                  ))
options(Ncpus=parallel::detectCores()-2)
options(browser = "epiphany")
#format_list_item.lm = function(x, ...) sprintf('<lm:%s>', format(x$call$formula))
options(dplyr.summarise.inform = FALSE) ## Turn off annoying dplyr group_by messages
# options(collapse_mask = "all") # https://sebkrantz.github.io/collapse/reference/collapse-options.html
options(tigris_use_cache=TRUE)
# ttps://github.com/REditorSupport/languageserver#customizing-formatting-style
options(languageserver.formatting_style = function(options) {
    style = styler::tidyverse_style(indent_by = options$tabSize)
    style$token$force_assignment_op = NULL
    style
})
# options(usethis.protocol = "ssh", usethis.full_name = "Grant McDermott")
