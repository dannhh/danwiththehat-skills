---
name: python-code-standard
description: |
  Use this skill when writing, reviewing, or setting up Python code, especially ML and
  research code: a new project's pyproject/ruff/pytest setup, code style, docstrings,
  type hints, naming, tests, or reproducibility of experiments.
  Triggers: "code style", "lint", "format", "review my code", "clean up the code",
  "set up a new Python project", "is this code good", "chuẩn code", "style code",
  "review code", "dọn code", "setup project python", "code có theo style nào không".
  Modes: setup (new project) → write (apply the rules) → audit (existing repo, fix in
  safe commits).
metadata:
  tags: [python, code-style, ruff, pytest, ml, research, reproducibility]
---

# Python Code Standard

One standard for Python projects, tuned for ML and research code: boring, predictable code so that the experiments are the only interesting part.

## When to Use

- Starting a Python project or adding tooling to one → **Setup**.
- Writing or changing Python code in any project → **Write** (apply the rules silently).
- The user asks whether code follows a style, wants a review, or wants it cleaned up → **Audit**.

## The rules (one line each; details and examples in references/RULES.md)

1. **Formatter decides formatting.** `ruff format`, Black style, 88 columns. Never format by hand, never argue with it.
2. **Lint for correctness first.** E, W, F, I, B, UP, RUF; then D (Google docstrings) and ANN (type hints) for library code. Do not `select = ["ALL"]`.
3. **Fail loudly.** Unknown modes, wrong shapes, missing keys raise at the boundary with a message that names the expected value. No silent fallback branch.
4. **Make invalid states unrepresentable.** `Literal[...]` for modes, enums or frozen dataclasses for fixed choices, read-only constants (`arr.setflags(write=False)`).
5. **Type hints on every function boundary**; inside functions only where they help.
6. **Shapes are contracts.** Name domain sizes (`N_YEARS`, `N_TARGETS`) instead of literals; write shapes in docstrings `(sites, years, months, drivers)`; check them where data enters. Two equal literals with different meanings are a bug waiting.
7. **No hidden mutation.** A function returns new arrays unless its name says `_inplace`. Mutating a fresh local array is fine.
8. **Small functions, one job, no clever code.** Several `# step 1/2/3` comments mean split. No abstraction without a second user.
9. **Comments say why; code says what; notes hold evidence.** Numbers, dates and experiment results go to notes/, code links to them.
10. **Docstrings: Google style.** One-line imperative summary ("Return ...", "Build ..."), blank line, details; `Args:` only when it lists every argument.
11. **Test invariants, not trivia.** Round-trips, invalid inputs, shape/layout contracts, formulas the project relies on. No tests of `add(a, b)`.
12. **Every result has provenance.** Config + git commit + dirty files + seed recorded next to every checkpoint and output file. Config ≠ code.

ML/research specifics (experiment naming, provenance sidecars, reproducibility checks): references/ML-RESEARCH.md.

## Instructions

### Setup (new project)

1. Copy references/pyproject-template.toml sections into `pyproject.toml`; adjust `target-version` and package paths. Add dev deps: `uv add --dev ruff pytest`.
2. Create `tests/` with at least one invariant test for the first transform the project relies on.
3. Add a "Code style" section to the README pointing to these rules (short list, not a copy of this skill).
4. Run `uv run ruff format`, `uv run ruff check`, `uv run pytest`; all must pass.

### Write (any code change)

- Follow the 12 rules. Before finishing: run format, lint and tests if the project has them; fix what you introduced.
- Match the surrounding code where the project has its own established convention; this standard fills gaps, it does not override a project's explicit choices.

### Audit (existing repo)

1. **Measure, don't guess.** Run `ruff check --statistics` with the template rules, line length stats, and the greps in references/REVIEW-CHECKLIST.md. Report a short table:
   what follows a convention, what does not, with counts.
2. **Agree on choices** that are taste (line length 88 vs 100, docstring style) with the user; recommend one.
3. **Record a baseline before changing anything**: md5 of key outputs (submission files, metrics) and a smoke run, so equivalence can be proven afterwards.
4. **Change in separate commits:**
   1. format only (`ruff format`), no logic change; easy to skip in `git blame`
   2. docstrings and comments, written by hand (auto-reflow cuts sentences)
   3. lint fixes and design changes (fail loudly, constants, type hints)
   4. tests
5. **Prove nothing changed:** compare ASTs with docstrings stripped (script in references/REVIEW-CHECKLIST.md), rerun the smoke run and compare output md5 with the baseline. Report any intentional behaviour change separately.
6. Never commit files the user is editing; say which ones were left out.

## Output

- Audit: a table of findings with counts, the recommended choices, then the commits made and the equivalence evidence (AST diff result, md5 before/after).
- Write/Setup: the changed files and the commands that passed.

## References

- references/RULES.md: each rule with why, bad and good examples.
- references/ML-RESEARCH.md: experiment naming from config, provenance, shapes, calibration constants, reproducibility checks.
- references/REVIEW-CHECKLIST.md: audit greps, AST-equivalence script, review checklist.
- references/pyproject-template.toml: ruff and pytest configuration.
