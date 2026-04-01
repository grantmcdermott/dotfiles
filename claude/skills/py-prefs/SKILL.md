---
name: py-prefs
description: >
  Python programming conventions and patterns. Use when the user is writing
  Python code, asking about style, logging, testing, docstrings, or project
  structure.
---

# Python Conventions & Preferences

## Package Preferences

Prefer lean, fast libraries over heavier alternatives:

- **polars** over pandas for data manipulation
- **numpy** for numerical computing
- **pyfixest** for econometrics (bridges R's fixest)
- **plotnine** for visualization in interactive scripts (ggplot2 syntax), despite heavier footprint than matplotlib
- **ibis** as a portable dataframe interface (duckdb, Spark, etc.)
- **boto3** for AWS service access
- **pyarrow** for parquet and S3 I/O

### Tips

Convert Spark DataFrames to polars efficiently via Arrow (avoids pandas intermediate):

```python
df = pl.from_arrow(spark_df._collect_as_arrow())
```

## Project Management

Use `uv` for Python project and dependency management.

## Development Environment

Avoid Jupyter notebooks (`.ipynb`)! Instead, use plain `.py` files with VS Code Jupyter magic cells (`# %%`) for interactive development. This avoids misread state, keeps code diffable, lintable, and version-control friendly.

```python
# %% [markdown]
# # Analysis Title
#
# Narrative description of the analysis goes here.

# %% libs
import polars as pl
import numpy as np
from pathlib import Path

# %% Parameters
THRESHOLD = 10
DATA_DIR = Path("../data")

# %% [markdown]
# ## Load and transform data

# %% Main query
dat = pl.read_parquet(DATA_DIR / "input.parquet")
```

Use `# %% [markdown]` for narrative sections and `# %% label` for named code cells.

## Coding Style

### Naming

- Meaningful variable names — avoid `x`, `df`, `temp`, `data`
- Functions use verb phrases: `calculate_total`, `fetch_records`
- Booleans read as conditions: `is_valid`, `has_permission`, `should_retry`
- Constants: `UPPER_SNAKE_CASE`
- Avoid abbreviations unless widely understood (`url`, `id` are fine; `proc_dat` is not)

### Type Hints

Add type hints to all function signatures:

```python
def process_data(input_path: str, threshold: int = 10) -> dict[str, Any]:
    return {"result": threshold}
```

### Method Visibility

Mark private methods with leading underscore. Public methods at top, private below.

```python
def main(input_path: str) -> None:
    data = _load_data(input_path)
    _process_data(data)
    return

def _load_data(path: str) -> dict:
    return {}

def _process_data(data: dict) -> None:
    return
```

### File Organization

- Public methods at top, private methods below
- Explicit return statements at end of all methods (even `return` or `return None`)
- Entry point scripts use `if __name__ == "__main__"` with argparse:

```python
import argparse

def main(input_path: str, output_path: str) -> None:
    return

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input_path", type=str, required=True)
    parser.add_argument("--output_path", type=str, required=True)
    args = parser.parse_args()
    main(input_path=args.input_path, output_path=args.output_path)
```

## Docstrings

Follow the Google Python Style Guide. Use triple quotes immediately after definitions.

```python
def add_numbers(a: float, b: float) -> float:
    """Add two numbers.

    This function takes two numeric arguments and returns their sum.

    Args:
        a: The first number to be added.
        b: The second number to be added.

    Returns:
        The sum of the two input numbers.
    """
    return a + b
```

```python
class BankAccount:
    """Represents a bank account with deposit and withdrawal capabilities.

    Attributes:
        balance: The current balance of the bank account.
    """

    def __init__(self, initial_balance: float = 0.0):
        """Initialize a new BankAccount instance.

        Args:
            initial_balance: The initial balance. Defaults to 0.0.
        """
        self.balance = initial_balance
```

- First line: brief summary in imperative mood ("Add" not "Adds")
- Use `Args:`, `Returns:`, `Raises:` sections
- Include types in descriptions only if no type annotations exist
- Comments explain WHY, not WHAT

## Logging

### Centralized Logger

Create a `helpers/logger.py` with a static factory method. Do not configure logging inline in individual modules.

```python
import logging


class Logger:
    @staticmethod
    def get_logger(name: str) -> logging.Logger:
        if name in logging.Logger.manager.loggerDict:
            return logging.getLogger(name)

        logger = logging.getLogger(name)
        logger.setLevel(logging.INFO)
        logger.propagate = False

        formatter = logging.Formatter(
            fmt="%(asctime)s %(levelname)-8s %(message)s",
            datefmt="%Y-%m-%d %H:%M:%S",
        )

        handler = logging.StreamHandler()
        handler.setLevel(logging.INFO)
        handler.setFormatter(formatter)
        logger.addHandler(handler)

        return logger
```

### Per-Module Usage

One logger per module, at the top. Never inside functions or classes.

```python
from mypackage.helpers.logger import Logger

logger = Logger.get_logger(__name__)
```

### Log Levels

| Level     | When to use |
|-----------|-------------|
| `info`    | Normal operations: step execution, resource creation, progress |
| `warning` | Recoverable issues: retryable failures, deprecated usage |
| `error`   | Failures that affect the operation: validation errors, missing resources |

Avoid `debug` and `critical` unless there is a specific need.

### Conventions

- Use f-strings: `logger.info(f"Created bucket: {bucket_name}")`
- Include exceptions: `logger.error(f"Failed to update: {e}")`
- Log before re-raising; never silently swallow exceptions
- Log script name and args after parsing:

```python
logger.info(f"Starting {__file__}")
for arg, value in vars(args).items():
    logger.info(f'"{arg}" : "{value}"')
```

## Testing

### Framework

Use pytest for all tests. Leverage fixtures, parametrize, and assertion introspection.

### Scope

- Test public methods only
- Private methods (`_name`) are tested indirectly through public interfaces

### Patterns

```python
@pytest.fixture
def sample_processor():
    return DataProcessor(config={"mode": "test"})

def test_process_data_returns_filtered_results(sample_processor):
    result = sample_processor.process_data(input_data)
    assert len(result) == 5

def test_process_data_raises_on_invalid_input():
    processor = DataProcessor()
    with pytest.raises(ValueError, match="Invalid input"):
        processor.process_data(None)

@pytest.mark.parametrize("input_val,expected", [
    (10, 20),
    (5, 10),
    (0, 0),
])
def test_double_value(input_val, expected):
    assert double(input_val) == expected
```
