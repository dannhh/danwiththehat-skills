# Rules in detail

Each rule: why it exists, then a bad and a good example.

## 1. Formatter decides formatting

- Why: formatting debates and noisy diffs cost review time and find no bugs.
- Use `ruff format` (Black-compatible), 88 columns. Code lines belong to the formatter (ignore E501); docstrings and comments are held to 88 by W505 (`max-doc-length`).
- Long log f-strings may exceed the limit; splitting a log sentence hurts more than it helps.

## 2. Lint for correctness first

- Why: rule families differ in value. Bugbear (B) and Ruff-specific (RUF) catch real bugs (mutable defaults, `zip` without `strict`, loop-variable capture); style rules mostly do not.
- Start with E, W, F, I, B, UP, RUF. Add D (docstrings) and ANN (type hints) for library code (`src/`), not scripts. Add N, SIM, PT, S when the project needs them.
- Allow upper-case array names (`X`, `D`, `P`): ignore N803/N806 if N is enabled.

## 3. Fail loudly

- Why: in research code a silent fallback runs the wrong experiment and produces a plausible number.

Bad:

```python
def to_raw(y, mode="offset"):
    if mode == "affine":
        return (y - B) / A
    return y - OFFSET          # mode="afine" silently lands here
```

Good:

```python
def to_raw(y: np.ndarray, mode: Mode = "offset") -> np.ndarray:
    if y.shape[-1] != N_TARGETS:
        raise ValueError(f"y must end with {N_TARGETS} targets, got {y.shape}")
    if mode == "offset":
        return y - OFFSET
    if mode == "affine":
        return (y - B) / A
    raise ValueError(f"unknown mode {mode!r}; use 'offset' or 'affine'")
```

## 4. Make invalid states unrepresentable

- `Mode = Literal["offset", "affine"]` lets the IDE and type checker catch typos.
- Calibration constants: `CONST.setflags(write=False)` plus a shape assert at import.
- Fixed choices with data attached: `enum.Enum` or a frozen dataclass, not dicts of strings.

## 5. Type hints on function boundaries

- Every function in library code: arguments and return type.
- Inside functions only when the type is not obvious.
- Do not annotate `x: np.ndarray = np.array(...)`; the right-hand side says it.

## 6. Shapes are contracts

- Shape bugs are worse than syntax bugs: they broadcast silently.
- Name domain sizes once (`N_AGES = len(AGES)`, `N_YEARS = 40`) and use the names.
- Real case: a model had `n_age=15` (age-feature size, 1 + 2 × 7 targets) next to 15 seed ages. Equal by accident; one rename would have broken the other silently. Name them separately (`AGE_TRIPLET_DIM`, `N_AGES`).
- Docstrings state shapes: `x (B, 40, 12, C) -> (B, 40, 7)`.
- Check shapes where data enters the system, with a message that names the expected shape.

## 7. No hidden mutation

Bad:

```python
def fix(test_x):
    test_x[..., RAD] -= offsets(test_x)   # the caller's array changes
    return test_x
```

Good: `test_x = test_x.copy()` first, or name it `fix_inplace`. Mutating an array the function itself just created or loaded is fine.

## 8. Small functions, no clever code

- One job per function; `# step 1`, `# step 2` comments are a signal to split.
- Prefer a named intermediate (`raw = (y - b) / a; return np.maximum(raw, floor)`) over a dense one-liner.
- No class or factory until a second caller needs it.
- Do not hide expensive operations behind innocent names; a reviewer should see where the sort or the full pass over the data happens.

## 9. Comments say why; notes hold evidence

Bad:

```python
# Subtract offset
y = y - OFFSET
# Synthetic-shift test 2026-10-06: ignoring the slope raises the score 0.025 -> 0.085
```

Good:

```python
# The test files store y shifted from the raw training scale.
# Evidence: notes/findings/test-data.md
y = y - OFFSET
```

Full sentences, capitalized. Research numbers, dates and LB scores live in notes.

## 10. Docstrings (Google style)

```python
def radiation_offsets(test_x: np.ndarray, site_step: int = 5) -> np.ndarray:
    """Return the night value of each radiation driver.

    test_x is (sites, years, months, drivers). The value is identical at every site,
    so every `site_step`-th site is enough.
    """
```

- Summary line: imperative, one line, ends with a period.
- `Args:`/`Returns:` sections only when they list everything; otherwise prose.
- Required for public functions in library code; scripts document themselves in the module docstring (usage lines).
- Write them by hand. Automatic reflow cuts sentences in mixed prose/table blocks.

## 11. Test invariants

Worth testing:

- round-trips (`to_raw(raw * A + B, "affine") == raw`)
- invalid inputs raise (`mode="afine"`, wrong shape)
- domain invariants (`all(SLOPE > 0)`)
- layout contracts shared by modules (row i*15 + a is site i, age a)
- formulas the project's decisions rely on (blend score formula, estimators)
- naming/config guards (two configs cannot get the same name) Not worth testing: trivial wrappers, plotting, one-off scripts.

## 12. Provenance and config

- Experiments are configs (JSON/YAML) with inheritance, not `if version == "v3":` code.
- Every checkpoint and output file records: resolved config, git commit, uncommitted files, seed, time. See ML-RESEARCH.md.
