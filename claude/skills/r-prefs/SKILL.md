---
name: r-prefs
description: >
  R programming for data analysis and econometrics. Use when the user is working
  with R code, data.table, fixest, duckdb, arrow, tinyplot, or asking about R
  coding style, package choices, or data workflows.
---

# R Programming Context & Preferences

## Agent Workflow Guidance

### General R Agentic Guidance

- Use corteza MCP tools for R tasks: `r_help` for documentation, `run_r` for code execution, `installed_packages` for package checks
- For reading URLs, prefer the host's builtin web-fetch tool over corteza's `fetch_url`
- For file operations (read, write, edit, list, search), prefer the host's builtin file tools over corteza equivalents
- For git write operations (commit, branch), prefer the host's builtin shell over corteza git tools
- If the corteza package and tools are unavailable:
  - Check if the `corteza` R package is installed - if not, offer to install on behalf of the user: `Rscript -e "install.packages('corteza')"`
  - Note that the agent can still function regardless — use Bash with Rscript as a fallback

### Package Installation

- Use the default configured repos when installing R packages
  - Do not specify repos explicitly in `install.packages()` calls
  - Exception: If `getOption("repos")` returns NULL or "@CRAN@", then repos must be specified
- Always ask the user before installing a package, unless they give explicit permission for the remainder of the session

### R Package Documentation

- When a user requests help with a particular function or method, _always_ consult the help documentation before making suggestions
- If the help documentation is sparse, look for relevant package vignettes
- If you cannot access the help documentation because a package is not installed, ask the user if you can install it on their behalf (using the rules for package installation above)

### Code suggestions

- When suggesting or inserting code, you should check whether the necessary packages to run the code are available on the user's system (using corteza's `installed_packages` tool)

## Code Style & Philosophy

### Documentation Approach

- Write clear, concise code with high-level documentation
- Focus on explaining **what** and **why**, not obvious **how**
- Avoid excessive inline comments for self-explanatory code
- Include function documentation for complex operations

### Dependency Management

- **Prefer**: Simple base R solutions when performance is adequate
- **Accept**: Well-established packages for significant performance gains or specialized functionality
- **Avoid**: Unnecessary dependencies that add complexity without clear benefit

## Package Ecosystem & Usage Patterns

### Data Wrangling (Priority Order)

1. **data.table** - Primary choice for in-memory operations
   - Used in ~95% of projects
   - Preferred for: joins, aggregations, transformations
   - Syntax: `DT[i, j, by]` pattern

2. **duckdb** - Out-of-memory operations on large datasets
   - Use case: Hive-partitioned parquet files >RAM
   - Very often combined with data.table for hybrid workflows
   - Can replace data.table entirely for very large datasets

3. **arrow** - S3 connectivity and parquet I/O
   - Primary use: Reading from AWS S3 buckets
   - Complements duckdb for cloud data pipelines

4. **dplyr** and **tidyr** - Interface layer
   - Used primarily via dbplyr for duckdb/arrow integration
   - Not preferred for pure in-memory operations, unless these are relatively small tasks and sticking with dplyr/tidyr would give overall syntax consistency to a script.

### Statistical Analysis

- **fixest** - Primary econometrics package
  - Used in nearly every project.
  - Fast estimation of linear/nonlinear models
  - Built-in clustering, fixed effects, instrumental variables
  - Preferred over `lm()`/`glm()` for applied work

- **marginaleffects** - Post-estimation analysis
  - Marginal effects, predictions, contrasts
  - Integrates seamlessly with fixest

### Visualization Strategy

- **tinyplot** - Primary plotting package
  - Lightweight, flexible base graphics wrapper
  - Preferred for exploratory analysis and production plots

- **ggplot2** - Secondary option
  - Use when tinyplot limitations are encountered
  - Particularly for complex multi-panel layouts

### Output & Reporting

- **tinytable** - Table export and formatting
  - LaTeX, HTML, Word output
  - Integrates with regression objects

### Project Management

- **here** - Path management (used in every project)
  - Ensures reproducible relative paths
  - Call `here::here()` for all file operations
- **[rv](https://a2-ai.github.io/rv-docs/)** - Declarative, reproducible R project package manager
  - Rust-based CLI tool (not a CRAN package) — the R equivalent of `uv` for Python
  - Available in the RISE-R image
  - Alternative to `renv`; resolves full dependency tree ahead of time for faster, more reliable reproducibility

## Coding Conventions

### Element Access

```r
# Preferred — no partial matching, works with variables
x[["name"]]
settings[["verbose"]]

# Avoid
x$name
settings$verbose
```

### Assignment Operator

```r
# Preferred
x = 5
data = fread("file.csv")

# Avoid
x <- 5
data <- fread("file.csv")
```

### Base pipe

```r
# Preferred multi-line style
mtcars |>
    subset(cyl == 4) |>
    head(5)

mtcarsDT[
  ,
  lapply(.SD, sum),
  by = cyl,
  .SDcols = c("mpg", "wt", "hp")
][
  1:2
]

# Avoid excessive nesting and/or long lines
head(subset(mtcars, cyl == 4), 5)
mtcarsDT[, lapply(.SD, sum), by = cyl, .SDcols = c("mpg", "wt", "hp")][1:2]

# Avoid using the magrittr pipe (over the base pipe)
dat %>%
    subset(cyl == 4) %>%
    head(5)
```

### Function definitions

```r
# Use lambda syntax for simple functions
percent_format = \(x) {
    x = as.numeric(x)
    ifelse(is.na(x), NA_character_, sprintf('%.1f%%', round(x*100, 1)))
}
```

### Output Display

```r
# Preferred - rely on native print methods
summary_stats
model_results

# Avoid unnecessary explicit printing
print(summary_stats)  # Only when needed for side effects
```

### Plotting themes

```r
# Use tinyplot themes for nicer looking plots
library(tinyplot)

# Ephemeral theme (preferred for interactive use)
plt(Sepal.Length ~ Petal.Length | Species, iris, theme = "clean")
plt_add(type = "lm")

# Persistent theme (preferred for writing whole scripts)
tinytheme("clean")
plt(Sepal.Length ~ Petal.Length | Species, iris)
plt_add(type = "lm")
tinytheme() # reset
```

### Scoping and conciseness

```r
# Preferred
dat = within(dat, {
  xsq = x^2
  y = x + a - b
})

# Avoid
dat$xsq = dat$x^2
dat$y = dat$x + dat$a - dat$b
```

### Line length

```r
# Preferred - wrap at 80 characters
model = feols(
  outcome ~ treatment + control1 + control2,
  data = dat,
  cluster = ~id
)

# Avoid - long single lines
model = feols(outcome ~ treatment + control1 + control2, data = dat, cluster = ~id)
```

### Code sections

```r
# Use section headers with four trailing dashes for code folding

# libs ----

library(here)
library(data.table)

# data ----

dat = fread(here("data/file.csv"))

# analysis ----

model = feols(y ~ x, data = dat)
```

## AWS Integration Patterns

- Use `arrow` for simple S3 data access
- The `paws.common` package is an R equivalent to `boto3` and can enable AWS authentication for more complicated cases and access requirements.
- Leverage duckdb for serverless-style analytics
- Consider AWS Batch/Fargate for compute-intensive tasks
- Store intermediate results as parquet in S3

## Performance Considerations

- Profile code with large datasets before optimization
- Use data.table for operations <=1-2GB in memory
- Switch to duckdb for operations >2GB or complex SQL-like queries
- Consider parallel processing with future/furrr for embarrassingly parallel tasks

## Common Workflow Patterns

1. **Data ingestion**: (arrow →) duckdb → data.table
2. **Analysis**: fixest → marginaleffects
3. **Visualization**: tinyplot (+ ggplot2 if needed)
4. **Output**: tinytable for tables, here() for file paths

## Tips & Idioms

### Use temp variables inside data.table aggregations

When computing related summary statistics, use a function with local
variables to avoid recalculating the same expression multiple times.

```r
# Good — compute once, reuse
dat[
  ,
  unlist(lapply(.SD, \(x) {
    m = mean(x, na.rm = TRUE)
    se = sd(x, na.rm = TRUE) / sqrt(.N)
    list(mean = m, lwr = m - 1.96 * se, upr = m + 1.96 * se)
  }), recursive = FALSE),
  by = .(treat, post),
  .SDcols = outcomes
]

# Avoid — redundant calls to mean() and sd()
dat[
  ,
  .(
    mean = mean(x, na.rm = TRUE),
    lwr = mean(x, na.rm = TRUE) - 1.96 * (sd(x, na.rm = TRUE) / sqrt(.N)),
    upr = mean(x, na.rm = TRUE) + 1.96 * (sd(x, na.rm = TRUE) / sqrt(.N))
  ),
  by = .(treat, post)
]
```

### Aggregate and reshape in one step with `dcast`

`dcast` accepts multiple aggregation functions and multiple value columns
simultaneously, avoiding a separate collapse-then-reshape workflow.

```r
# One-step: multiple stats × multiple variables, reshaped wide
dcast(
  dat, origin ~ .,
  fun.aggregate = list(min, mean, max),
  value.var = c("dep_delay", "arr_delay")
)

# Avoid: aggregate first, then reshape manually
tmp = dat[, .(
  min_dep = min(dep_delay), mean_dep = mean(dep_delay), max_dep = max(dep_delay),
  min_arr = min(arr_delay), mean_arr = mean(arr_delay), max_arr = max(arr_delay)
), by = origin]
```

### Non-equi joins for range-based matching

Use `on = .(key, val >= start, val <= end)` to merge over intervals
(e.g. date ranges) instead of a cross join + filter.

```r
# Define carrier-specific date windows
windows = data.table(
  carrier     = c("AA", "UA"),
  start_month = c(1, 4),
  end_month   = c(3, 6)
)

# Single-step range join
dat[windows, on = .(carrier, month >= start_month, month <= end_month)]

# Avoid: merge on carrier alone, then filter
merge(dat, windows, by = "carrier")[month >= start_month & month <= end_month]
```

### Melt into multiple value columns with `measure(value.name, ...)`

When column names encode both a variable and a grouping (e.g.
`votes_Rep`, `ev_Rep`, `votes_Dem`, `ev_Dem`), use the special
`value.name` keyword inside `measure()` to produce one value column
per variable. This is easy to overlook because `value.name` looks like
the regular `melt(..., value.name = <string>)` argument, but inside
`measure()` it acts as a special symbol.

```r
# Columns: state, votes_Rep, ev_Rep, votes_Dem, ev_Dem
# Goal: long by party, with separate votes and ev columns

# Good — value.name produces multiple value columns
melt(dat, measure.vars = measure(value.name, party, sep = "_"))
#>      state party  votes ev
#> 1: Oklahoma   Rep 1036213  7
#> 2:   Oregon   Rep  919480  0
#> 3: Oklahoma   Dem  499599  0
#> 4:   Oregon   Dem 1240600  8

# Without value.name, you'd need two separate melts + merge
```

### fixest: Multi-model estimation in a single call

fixest can estimate many specifications at once, sharing fixed-effect
computation across models. This avoids loops and is much faster.

```r
# Multiple dependent variables
feols(c(wage, educ) ~ age + marr | countyfips + year, dat)

# Cumulative stepwise: progressively adds controls
feols(wage ~ educ + csw0(age, marr, hisp) | countyfips, dat)
# Produces 4 models: no controls, +age, +age+marr, +age+marr+hisp

# Split sample estimation
feols(wage ~ educ | countyfips, dat, fsplit = ~hisp)
# Produces 3 models: full sample, hisp==0, hisp==1

# All of the above can be combined
feols(c(wage, educ) ~ csw0(age, marr) | countyfips, dat, fsplit = ~hisp)
```

### fixest: Formula macros with `.[vector]`

Use `.[ctrls]` to inject a character vector of variable names into a
fixest formula. Avoids `paste()`/`reformulate()` gymnastics.

```r
ctrls = c("age", "black", "hisp", "marr")
feols(wage ~ educ + .[ctrls] | countyfips, dat)

# Regex column selection with ..()
feols(wage ~ educ + ..("^race"), dat)
```

### fixest: Varying slopes in fixed effects

Use bracket notation `fe[continuous]` for group-specific slopes (e.g.
state-specific time trends). Distinct from `fe^var` which creates
interaction FEs.

```r
# State-specific linear time trends
feols(wage ~ educ | statefips[year], dat)

# Compare: interaction FE (a separate FE for each state×year)
feols(wage ~ educ | statefips^year, dat)
```

### fixest: Report multiple SEs for the same model

`etable()` can display the same model under different variance
estimators side by side, without re-estimating.

```r
est = feols(wage ~ educ | countyfips + year, dat)
etable(est, vcov = list("iid", "hc1", ~countyfips, ~countyfips + year))
```

### fixest: Preview formula expansion with `xpd()`

Use `xpd()` to debug complex formulas with interpolation, stepwise,
or regex before running the estimation.

```r
ctrls = c("age", "black", "hisp")
xpd(wage ~ educ + .[ctrls] | csw0(statefips, year))
#> wage ~ educ + age + black + hisp | csw0(statefips, year)
```

### fixest: `only.coef` for fast simulation loops

When running bootstrap or Monte Carlo simulations, `only.coef = TRUE`
skips building the full fixest object and returns just the coefficient
vector — much faster in tight loops.

```r
boot_coefs = lapply(1:999, \(i) {
  idx = sample(nrow(dat), replace = TRUE)
  feols(wage ~ educ | countyfips, dat[idx], only.coef = TRUE)
})
boot_vcov = var(do.call(rbind, boot_coefs))
```

### fixest: Bin and rebase factor levels in-formula with `i()`

Use `i(var, ref, bin)` to change the reference level or merge factor
levels directly in the formula, without recoding the variable.

```r
# Change reference to period 5
feols(y ~ i(period, ref = 5) | id, dat)

# Bin periods 1-3 into a single "pre" category
feols(y ~ i(period, bin = list(pre = 1:3)) | id, dat)
```

## S3 Data I/O Examples

### Reading from S3

#### Single files with arrow

```r
library(arrow)

# Confirm S3 support
arrow_with_s3()

# Read single parquet file
bucket = s3_bucket("your-bucket-name")
dat = read_parquet(bucket$path("path/to/file.parquet"))

# Alternative syntax
dat = read_parquet("s3://your-bucket-name/path/to/file.parquet")
```

#### Datasets (partitioned files)

```r
library(arrow)
library(dplyr)

# Open dataset connection
bucket = s3_bucket("your-bucket-name")
ds = open_dataset(bucket$path("partitioned-dataset/"))

# Query with filter pushdown
result = ds |>
  filter(year >= 2022) |>
  select(id, value, category) |>
  collect()
```

#### DuckDB integration for larger queries

```r
library(duckdb)
library(paws)

# Set up AWS credentials for DuckDB
sts_client = sts()
creds = sts_client$assume_role_with_web_identity(
  RoleArn = Sys.getenv("AWS_ROLE_ARN"),
  RoleSessionName = "r-session",
  WebIdentityToken = readLines(Sys.getenv("AWS_WEB_IDENTITY_TOKEN_FILE"), warn = FALSE)
)

con = dbConnect(duckdb())
dbExecute(con, paste0("
  INSTALL httpfs; LOAD httpfs;
  SET s3_region='us-east-1';
  SET s3_access_key_id='", creds[["Credentials"]][["AccessKeyId"]], "';
  SET s3_secret_access_key='", creds[["Credentials"]][["SecretAccessKey"]], "';
  SET s3_session_token='", creds[["Credentials"]][["SessionToken"]], "';
"))

# Query S3 data directly
result = dbGetQuery(con, "
  SELECT * FROM read_parquet('s3://your-bucket/file.parquet')
  WHERE year >= 2022 LIMIT 1000
")
```

### Writing to S3

#### Single files

```r
# Write parquet file
write_parquet(dat, "s3://your-bucket/output.parquet")

# Using bucket object
bucket = s3_bucket("your-bucket")
write_parquet(dat, bucket$path("output.parquet"))
```

#### Partitioned datasets

```r
# Write partitioned dataset
write_dataset(
  dat,
  "s3://your-bucket/partitioned-output/",
  partitioning = c("year", "month")
)
```

### Large datasets workflow

For datasets >2GB, download locally first:

```bash
# Download via AWS CLI
aws s3 cp s3://source-bucket/large-dataset/ data/large-dataset --recursive
```

Then process locally with DuckDB:

```r
library(arrow)
library(duckdb)

# Process local data efficiently
ds = open_dataset(here("data/large-dataset/"))
result = ds |>
  to_duckdb() |>
  filter(year >= 2022) |>
  summarise(total = sum(value), .by = category) |>
  collect()
```
