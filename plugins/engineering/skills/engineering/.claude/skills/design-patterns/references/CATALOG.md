# Pattern catalog (Python forms)

Each entry: the problem, the Python form, an example, and when not to use it.

## Registry

- Problem: pick an implementation by a name that comes from config or the command line.
- Python form: a module-level dict and a decorator that fills it; a `build()` that raises on unknown names.

```python
MODELS: dict[str, type] = {}

def register(name: str):
    def deco(cls: type) -> type:
        MODELS[name] = cls
        return cls
    return deco

def build(cfg: dict) -> nn.Module:
    if cfg["type"] not in MODELS:
        raise ValueError(f"unknown model.type {cfg['type']!r}; known: {sorted(MODELS)}")
    return MODELS[cfg["type"]](**{k: v for k, v in cfg.items() if k != "type"})

@register("seqtf_causal")
class SeqTFCausal(nn.Module): ...
```

- A new variant is one decorated class plus one config.
- Not when: there is one implementation, or the names never come from data.

## Strategy as a function

- Problem: one step of an algorithm varies (loss, metric, sampling).
- Python form: pass the function.

```python
def train(model, data, loss_fn: Callable[[Tensor, Tensor], Tensor] = mse): ...
train(model, data, loss_fn=partial(weighted_mse, weights=w))
```

- Not when: the variants need shared state across calls; then a small class with `__call__`.

## Composition over inheritance

- Problem: variants combine along several axes (model × loss × sampler).
- Bad: `WindowedWeightedSeqModel(WeightedSeqModel(SeqModel))`, one subclass per combination.
- Good: one engine that receives the parts.

```python
run(model=build(cfg["model"]), loss=LOSSES[cfg["loss"]], sampler=SAMPLERS[cfg["sampler"]])
```

- Not when: there is truly one axis; a registry alone is simpler.

## Dependency injection (plain parameters)

- Problem: code creates its own collaborators (opens files, reads the clock, makes a random generator), so tests cannot replace them.
- Python form: parameters with defaults; the caller passes fakes.

```python
def split_sites(n: int, val_frac: float, rng: np.random.Generator) -> tuple[np.ndarray, np.ndarray]: ...
split_sites(100, 0.1, np.random.default_rng(0))   # deterministic in tests
```

- Not when: nothing ever varies; do not inject constants.

## Context object

- Problem: one run shares many values (config, device, data, model, logger, random generator); closures inside a 200-line function hold them.
- Python form: a `@dataclass` built once, passed to small top-level functions.

```python
@dataclass
class RunContext:
    cfg: dict
    dev: torch.device
    log: logging.Logger
    rng: np.random.Generator
    data: Data
    model: nn.Module

def run(cfg):
    ctx = setup_run(cfg)
    try:
        train(ctx, *split_sites(ctx))
        write_submission(predict_test(ctx), ctx.cfg["name"], ctx.cfg)
    finally:
        close_logger(ctx.log)
```

- Not when: two or three values; pass them directly. Do not let it become a bag that every function mutates.

## Value objects

- Problem: dicts with fixed keys (`{"height": ..., "agb": ...}`) travel everywhere; typos become `KeyError` at run time.
- Python form: `@dataclass(frozen=True)`, `NamedTuple`, or `TypedDict` for JSON-shaped configs.
- Not when: keys are open-ended (a config merged from files can stay a dict at the boundary).

## Protocol (structural interface)

- Problem: several implementations must offer the same methods; callers should not depend on a base class.
- Python form:

```python
class StepModel(Protocol):
    is_sequence: bool
    def forward(self, clim: Tensor, state: Tensor, age: Tensor) -> Tensor: ...
```

- Prefer over `abc.ABC` unless shared implementation is inherited too.
- Not when: one implementation.

## Decorator and context manager

- Function decorator: behaviour around many functions (timing, retry, caching via `functools.cache`). Not when the wrapper changes what the function means.
- Context manager: acquire and release (files, loggers, devices, temporary state). Write with `contextlib.contextmanager`; never leave a resource opened without `with` or `try/finally`.

## Pipeline with cached stages

- Problem: an expensive sequence (load → features → fit → predict) where only later stages change.
- Python form: one function per stage; a `cached(name, fn)` helper that stores arrays by name; each stage callable alone.
- Not when: the whole thing runs in seconds.

## Sentinel

- Problem: need "argument not given" distinct from `None`.
- Python form: `_MISSING = object()`; `def get(key, default=_MISSING)`.

## Repository

- Problem: storage varies (files, a database, memory in tests) and logic should not know which.
- Python form: a class with `get` / `add` / `list` methods, one per backend.
- Not when: one backend and no test needs a fake; read the file directly.

## Callbacks

- Problem: several listeners at fixed points (epoch end: log, checkpoint, early stop).
- Python form: a list of callables invoked with a small event value.
- Not when: one listener; call it directly.

## Classic GoF patterns and their Python replacements

| GoF pattern | Python form |
|---|---|
| Factory method, abstract factory | pass a callable (class, function, `partial`) |
| Singleton | module-level instance; the module is the singleton |
| Builder | keyword arguments with defaults; `dataclasses.replace` |
| Prototype | `copy.copy` / `copy.deepcopy` |
| Iterator | generator functions, `yield` |
| Command | function or `functools.partial` |
| Template method | function taking the varying step as a parameter |
| Observer | callbacks list |
| Strategy | function parameter |

## Smells and removals

- **Class with one method and no state** → a function.
- **Abstraction with one caller** → inline it.
- **Parameter that only selects a branch** (`flag=True`) used by one caller → two functions.
- **Growing flags on a shared helper** (the wrong abstraction) → inline into callers, delete unused branches, re-extract only what is shared.
- **`if mode == ...` in several files** → one registry or strategy, unknown names raise.
- **Mixins and multiple inheritance for reuse** → composition.
- **Deep inheritance for configuration** (`class V3(V2)` changing one number) → config files with `base`.
