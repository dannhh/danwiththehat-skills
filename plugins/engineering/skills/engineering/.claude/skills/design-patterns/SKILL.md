---
name: design-patterns
description: |
  Use this skill when deciding how to structure Python code: adding a variant or feature,
  choosing between a function, a class, a registry or a config, reviewing a design, or
  removing an abstraction that hurts. Tuned for ML and research code (experiments,
  models, pipelines, transforms).
  Triggers: "which design pattern", "should this be a class", "how do I add a new
  variant", "design review", "too many if/else", "refactor this into", "nên dùng pattern
  gì", "có nên tạo class không", "thêm version mới thế nào", "thiết kế code", "design
  pattern".
  Modes: design (new code: smallest structure that fits) → review (smells → a pattern,
  or remove one).
metadata:
  tags: [python, design-patterns, architecture, refactoring, ml, research]
---

# Design Patterns

Pick the smallest structure that solves the problem in front of you, in its Python form. A pattern is a name for a solution to a recurring problem; without the problem it is overhead.

Related skills: `improve-codebase-architecture` (deepening existing modules), `python-code-standard` (style, fail-loudly, provenance).

## When to Use

- Writing new code that will grow variants (models, losses, data sources, transforms) → **Design**.
- A design feels heavy, or every change touches many files or adds another `elif` → **Review**.
- The user asks which pattern to use, whether to make a class, or how to add a version.

## Principles (in priority order)

1. **Problem first.** Name the axis of change ("new model types", "new test-time transforms") before choosing any structure. No axis of change → plain functions.
2. **Duplication is cheaper than the wrong abstraction** (Metz). Abstract on the third repetition, and only if the shared contract fits in one sentence without "and also". A wrong abstraction is fixed by inlining it back into its callers, then extracting again.
3. **Composition over inheritance.** When variants combine along several axes, pass the parts in; a subclass per combination grows as the product of the axes.
4. **Python already has the pattern.** Functions and classes are values: a factory is a callable parameter, a singleton is a module-level object, a strategy is a function, a builder is keyword arguments.
5. **Functional core, imperative shell.** Pure functions hold the logic and take values; a thin outer layer does I/O, devices, files and logging. The core gets many fast tests, the shell a few.
6. **Configuration is data, not code.** Experiments are config files with inheritance; code reads them. No `if version == "v3":`.
7. **Dependencies come in as arguments.** What a function needs (paths, a model, a clock, a random generator) is passed in, so a test can pass a fake.
8. **Deep over shallow.** A small interface over a lot of behaviour; a class with one method and no state is a function.

## Decision guide (Python forms and examples: references/CATALOG.md)

| Symptom | Use | Not when |
|---|---|---|
| Pick an implementation by name from config | **Registry**: dict + `@register("name")` decorator | only one implementation exists |
| Interchangeable algorithms | **Strategy as a function** parameter | the behaviours share state; then a small class |
| Variants combine along 2+ axes | **Composition**: pass the parts | a single axis; then a registry is enough |
| Collaborator must be swappable or faked in tests | **Dependency injection** via parameters with defaults | nothing ever varies |
| Many values shared by the steps of one run | **Context object**: a `@dataclass` passed to small functions | two or three values; pass them directly |
| Fixed record of fields | **`@dataclass(frozen=True)`** or `NamedTuple`, not a dict | truly open-ended keys |
| Contract with several implementations | **`typing.Protocol`** (structural) | one implementation |
| Behaviour around many functions (timing, retry, caching) | **Function decorator** | it changes the function's meaning |
| Acquire/release a resource | **Context manager** (`with`, `contextlib`) | — |
| Ordered stages that may be cached or skipped | **Pipeline** of functions with cached outputs | a single linear script |
| "No value" distinct from `None` | **Sentinel** object | `None` already means "absent" |
| Storage that varies (files, DB, memory for tests) | **Repository** with a narrow interface | one backend and no tests need a fake |
| Many `if mode == ...` branches across files | **Registry or strategy**, plus a final `raise` | two stable modes in one place |
| Notify several listeners of events (epoch end) | **Callbacks** list | one listener |

Python forms that replace classic GoF patterns: factory method or abstract factory → pass a callable; singleton → module-level instance; builder → keyword arguments, defaults and `dataclasses.replace`; prototype → `copy.copy`; iterator → generators; command → a function or `functools.partial`; template method → a function taking the varying step as a parameter.

## ML and research patterns (details: references/ML-PATTERNS.md)

- **Config-driven experiments** with `base` inheritance and names generated from content.
- **Model registry** plus a shared engine; a new model is one class and one config.
- **Transform** (Lakshmanan et al.): one function maps raw inputs to model inputs, used identically in training, validation and inference.
- **Repeatable sampling and seeds**: splits by hash or seeded generator, all randomness from one seed in the config.
- **Checkpoints with metric-based selection**; resume and predict-only from the saved best.
- **Workflow pipeline with cached stages**: expensive arrays cached by name; stages rerunnable alone.
- **Heuristic benchmark**: a trivial baseline (persistence, mean) scored with the same metric before any model.
- **Ensembles** of diverse models, weights chosen by an exact formula where one exists.
- **Provenance / model versioning**: config + commit next to every artifact.

ML anti-patterns to remove (Sculley et al., 2015): glue code, pipeline jungles, dead experimental code paths, configuration debt, undeclared consumers of outputs.

## Instructions

### Design (new code)

1. State the axis of change in one sentence. If none, write functions and stop.
2. Check the decision guide; pick the smallest row that fits. Prefer a function over a class, a registry over subclass trees, composition over inheritance.
3. Write the interface first: signature with types, docstring with shapes, the error for unsupported input.
4. Split the pure core from the I/O shell; pass dependencies in.
5. Show where the next variant goes: "a new X is one entry in Y". If that sentence is long, the design is wrong.
6. No speculative generality: build the second implementation's seam when the second implementation arrives.

### Review (existing code)

1. Find the smells: long functions with step comments, `if/elif` on strings in several places, classes with one method, subclass per combination, parameters that only flip branches, abstractions with one caller, globals mutated across modules, I/O mixed into logic.
2. For each, propose the decision-guide row that fixes it, or propose **removing** an abstraction that has one caller or keeps growing flags.
3. Rank by cost of change avoided; propose at most three changes at a time.
4. Refactor without changing behaviour; prove it (see `python-code-standard`: baseline outputs, AST and weight comparisons).

## Output

- Design: the axis of change, the chosen structure and why, the interface sketch, where the next variant goes.
- Review: a table of smell → location → proposed change (or removal) → benefit, then the changes made and the equivalence evidence.

## References

- references/CATALOG.md: each pattern's problem, Python form, example, and when not to use it.
- references/ML-PATTERNS.md: patterns for experiments, models and pipelines, with the ML anti-patterns.
- references/SOURCES.md: books, talks and articles behind these rules.
