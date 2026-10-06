# Sources

The rules in this skill are distilled from these works (checked 2026-10-07 unless noted).

## Python design patterns

- Brandon Rhodes, [Python Design Patterns](https://python-patterns.guide/): which Gang of Four patterns Python makes unnecessary (factory method → pass a callable, singleton → module object), composition over inheritance, sentinel and global object patterns.
- Harry Percival and Bob Gregory, [Architecture Patterns with Python](https://www.cosmicpython.com/) (O'Reilly 2020): repository, service layer, unit of work, dependency injection, events.
- Gamma, Helm, Johnson, Vlissides, *Design Patterns* (1994): the original catalog; [Refactoring.Guru](https://refactoring.guru/design-patterns) for a readable version.

## Design principles

- Sandi Metz, [The Wrong Abstraction](https://sandimetz.com/blog/2016/1/20/the-wrong-abstraction) (2016): duplication is far cheaper than the wrong abstraction; inline to recover.
- [Rule of three](https://en.wikipedia.org/wiki/Rule_of_three_(computer_programming)): abstract on the third repetition.
- Gary Bernhardt, *Boundaries* talk: functional core, imperative shell.
- John Ousterhout, *A Philosophy of Software Design* (2018): deep modules, small interfaces (from memory; see also the `improve-codebase-architecture` skill).

## Machine learning

- Lakshmanan, Robinson, Munn, *Machine Learning Design Patterns* (O'Reilly 2020): 30 patterns; list in the [companion repository](https://github.com/GoogleCloudPlatform/ml-design-patterns).
- Sculley et al., *Hidden Technical Debt in Machine Learning Systems* (NeurIPS 2015): glue code, pipeline jungles, dead experimental code paths, configuration debt (from memory).

## Practice

- The patterns in ML-PATTERNS.md were also applied and verified in a research codebase (config inheritance with generated names, model registry, run context, provenance sidecars, refactors proven equivalent by weight comparison).
