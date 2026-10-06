# ML and research code

Patterns that keep experiment results trustworthy. Each one fixed a real failure.

## Layout
```
src/<pkg>/      library code (typed, documented, tested)
scripts/        entry points and one-off analysis (module docstring = usage)
configs/        one file per experiment, with `base` inheritance
tests/          invariants
notes/          findings, decisions, experiment table, leaderboard log
runs/           checkpoints, logs, caches (gitignored)
outputs/ subs/  result files + provenance sidecars (gitignored)
```

## Experiment names generated from the config
Problem: hand-written names drift from content (`model_best_v2`, `_affine` added by one
engine but not another, "best" that stops being best).

Pattern:
- Name = `<family>[_token]..._s<seed>`, listing only what differs from the family's
  root config, in a fixed axis order (e.g. test-time transform → input drops → feature
  form → context → architecture → training → seed).
- One word per setting, each word belongs to one axis (`aff`, `noco2`, `prof`, `win`).
- `load_config` generates the name and refuses a config file whose file name differs.
- Duplicate guard: if two configs get the same name, a setting has no token yet;
  refuse both and say so. (Cheaper than declaring every key's axis.)
- `run_name` = name without test-time tokens → variants that differ only at inference
  share one checkpoint folder.
- Overrides: changing a setting changes the name (`--set data.seed=2` → `_s2`);
  changing only hyperparameters (epochs, subset size) appends `_dev`, so a smoke test
  can never overwrite a real checkpoint. Scratch configs start with `_`.
- A frozen, resolved config (copied into a remote job) is used as is.
- Blends and probes get their own short schemes (`ens_<date>_<method>_<members>`,
  `probe_<what>`).

## Provenance
- `load_config` adds `cfg["code"] = {git_commit, dirty_files (src/scripts/configs only),
  recorded_at}`. In a remote job without git, the config embedded at build time keeps
  the version recorded locally.
- Each checkpoint folder keeps `config.json` (resolved, with `code`).
- Each output file `X.csv` gets `X.json`: the resolved config, or for a blend the
  components, weights and their scores.
- Keep an experiment table (one row per experiment: id, parent, axis changed, offline
  metrics, online score, conclusion). One change per experiment relative to a named
  parent, so every score difference is attributable.

## Calibration constants and transforms
- Constants estimated from data (offsets, slopes): module-level arrays with a shape
  assert, read-only, one-line comment pointing to the evidence note.
- Transform functions take a `Literal` mode, validate shape, raise on unknown modes,
  return new arrays.
- When a constant looks wrong but scored results depend on it, keep it, document the
  doubt next to it, and log the fix as a separate experiment instead of silently
  changing results.

## Reproducibility checks for refactors
1. Before: save md5 of key outputs and run a smoke config end to end (including the
   inference/output step).
2. After: AST comparison with docstrings stripped (REVIEW-CHECKLIST.md); rerun the
   smoke; md5 must match. For a deterministic model, regenerate one real output and
   compare it with the scored copy.
3. Back up any file the check will overwrite.

## Validation honesty
- When offline validation cannot see the deployment shift, say so and track the
  online/offline mismatch in the notes; do not tune to the offline proxy.
- Log every online submission with what it tested and what it taught, in sentences.
