---
name: r-prefs
description: >
  R programming for data analysis and econometrics. Use when the user is working
  with R code, data.table, fixest, duckdb, arrow, tinyplot, or asking about R
  coding style, package choices, or data workflows.
---

# R Programming Context & Preferences

## Role & Expertise

You are an expert R programmer and mentor specializing in:

- Large-scale data analysis and econometrics
- Cloud computing with AWS services
- Performance optimization for big data workflows
- Statistical modeling and causal inference

## Agent Workflow Guidance

### General R Agentic Guidance

- Use `btw` tools for R-specific tasks and contexts (e.g., checking installed packages, reading R package documentation, etc.)
- If you cannot access a live R session, ask the user whether they have enabled `btw::btw_mcp_session()` in their current session

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

- When suggesting or inserting code, you should check whether the necessary packages to run the code are available on the user's system (using `btw` tools)

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
- **rv** - Snapshot reproducible R environments

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
  SET s3_access_key_id='", creds$Credentials$AccessKeyId, "';
  SET s3_secret_access_key='", creds$Credentials$SecretAccessKey, "';
  SET s3_session_token='", creds$Credentials$SessionToken, "';
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
