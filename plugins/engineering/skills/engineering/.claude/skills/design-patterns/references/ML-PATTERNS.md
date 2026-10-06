# ML and research patterns

Patterns for experiments, models and pipelines. Names in *italics* come from *Machine Learning Design Patterns* (Lakshmanan, Robinson, Munn, O'Reilly 2020).

## Experiment structure

### Config-driven experiments

- Every experiment is a config file; a `base` key inherits from another config, so a variant is a few lines.
- Command-line overrides (`--set train.epochs=1`) for quick tests; overrides of hyperparameters only mark the run as a dev run so they never overwrite a real one.
- Names are generated from the config content (see `python-code-standard`, ML-RESEARCH.md).
- Anti-pattern it replaces: `if version == "v3":` branches and copy-pasted training scripts per version.

### One engine, many models

- A registry of model classes; one training engine handles every model that follows the interface (`is_sequence`, a fixed `forward` signature).
- A new model is one class and one config; the engine does not change.
- When two model families need different loops, give the engine one branch per family, chosen once, not per call site.

### Run context

- One `@dataclass` with config, device, data, models, logger and random generator, built by `setup_run`, passed to `train`, `evaluate`, `predict_test`.
- Keeps the orchestration function short and the steps testable.

## Data and features

### *Transform*

- One function maps raw inputs to model inputs; it is used identically in training, validation and inference.
- Keep calibration constants (offsets, slopes, normalization statistics) next to the transform, read-only, with their evidence in notes.
- Bug it prevents: training and test inputs that silently differ in scale.

### *Repeatable sampling* and seeds

- Splits come from a seeded generator or a hash of a stable id, never from global random state.
- All randomness flows from the config's seed; consume the generator in a fixed order so a refactor does not change results.

### *Bridged schema*

- When an input source changes shape or meaning, write an explicit adapter from the new form to the old instead of special cases in the model.

## Training

### *Checkpoints* with metric-based selection

- Save the best checkpoint by the metric that matters (the competition metric on a validation rollout), not by training loss.
- Support `--predict-only` from the saved best.

### *Useful overfitting*, *Hyperparameter tuning*, *Transfer learning*

- Overfit a tiny subset first to prove the pipeline can learn.
- Tune with the cheapest faithful proxy; record every trial as a config.

### Curriculum and windowing

- Random training windows break memorization of one shared timeline; positions relative to the window start.

## Evaluation and selection

### *Heuristic benchmark*

- Score a trivial baseline (persistence, mean, last value) with the same metric before training anything; report every model against it.

### *Ensemble*

- Diverse models blend better than similar strong ones; choose weights with an exact formula when the metric allows (for MSE the blend score follows from pairwise distances).

### *Continuous model evaluation* and validation honesty

- When offline validation cannot reproduce the deployment shift, track the offline/online gap explicitly and never tune to the offline number alone.

## Pipelines and reproducibility

### *Workflow pipeline* with cached stages

- One function per stage, cached outputs by name, stages callable alone; a full rerun is cheap to reason about.

### *Model versioning* and provenance

- Each artifact (checkpoint, prediction file) has the resolved config and the git commit next to it.

## ML anti-patterns (Sculley et al., *Hidden Technical Debt in Machine Learning Systems*, NeurIPS 2015)

- **Glue code**: most of the system adapts data to generic packages. Remedy: a narrow wrapper per external package.
- **Pipeline jungles**: preprocessing grown by accretion. Remedy: one transform function and a staged pipeline.
- **Dead experimental code paths**: branches for old experiments left in production code. Remedy: experiments are configs; delete code paths no config uses.
- **Configuration debt**: configs nobody can read or validate. Remedy: inheritance, generated names, validation that fails loudly.
- **Undeclared consumers**: outputs used by unknown downstream code. Remedy: provenance and explicit interfaces.
