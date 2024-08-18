library(tinyplot)
library(httpgd)
hgd(); hgd_browse()
library(showtext)
showtext_auto()

# with(mtcars, plt(wt, mpg, by = cyl, width = 8, height = 5))
with(mtcars, plt(wt, mpg, by = cyl))

plt(Sepal.Length ~ Petal.Length | Species, data = iris, pch = 19)

hgd_close()

