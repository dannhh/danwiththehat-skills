# Markdown rules in detail

Bad and good examples for each rule in SKILL.md.

## Content rules

### Minimum viable docs

- Three planning files that each restate the status (`plan.md`, `plan-v2.md`, `ideas.md`) become one `roadmap.md` plus one `status.md` that holds the numbers.
- One `README.md` per folder of notes, listing every file and what it holds.
- Delete or archive a doc as soon as it is superseded; say where its content went.

### Bullets over prose

Bad:

```markdown
The CO2 trend shifts by −46.5 train-sd: the present-day trend is about the same at
every site, while the test has +7 (SSP126) and +26 (SSP585). No present-day site
resembles that, so no model can learn the trend's effect from present-day data.
```

Good:

```markdown
- CO2 trend: −46.5 train-sd shift.
  - present-day: ≈ +57 ppm over 40 years at every site
  - test: +7 (SSP126), +26 (SSP585)
- So its effect cannot be learned from present-day data.
```

### Plain, human sentences

Bad (shorthand only the author can decode):

```markdown
| fix_off | 0.179 | same + Y0_OFFSET → targets raw |
```

Good:

```markdown
| fix_off | 0.179 | Same model, but we add the offset back to the predictions. Worse by 0.030, and the offset is the only difference, so the targets are on the raw scale. |
```

For logs of experiments or submissions, two columns work well: "What we wanted to know" and "What we learned".

### Tables only for two-dimensional data

- Good: many rows with the same attributes (submissions × date/file/score/lesson; configs × proxies).
- Bad: two rows and six columns, half empty; a column whose value never changes; cells holding paragraphs. Use headings plus bullets instead.
- Keep cells short; move long links to reference definitions.

### Evidence next to claims

```markdown
- Best LB 0.088 (as of 2026-10-07, blend `ens_20261006_opt_aff`).
- LEAP winners relied on ensembles ([write-up](https://example.com/leap-9th)).
```

## Layout rules

### Document layout

```markdown
# Leaderboard log

Every submission on the main account, with what it tested. Scores are public LB.

## Submissions

...

## Lessons

...

## See also

- [Experiment table](experiments.csv)
```

### Headings

Bad: `Results` underlined with `-------` (setext), `##Results` (no space), two `### Summary` headings under different parents, Title Case Everywhere.

Good: `## GBDT results`, `### GBDT summary`, sentence case, blank lines around.

## Syntax rules

### Lists

```markdown
- Bullet.
  - Nested bullet, 2 spaces.
- Next bullet.

1. Short fixed list.
2. Numbered in full.

1. Long list that will change:
1. lazy numbering renders 1, 2, 3.
```

### Code

````markdown
Run `uv run pytest` before committing; the example URL is `https://host/search?q=$TERM`.

```bash
uv run scripts/train.py --config configs/model/<name>.json \
    --set train.epochs=1
```
````

Never indent code by four spaces to make a block: the language cannot be declared and the block boundaries are ambiguous.

### Links

Bad:

```markdown
See [here](validation.md) for details, or https://github.com/org/repo.
```

Good:

```markdown
See the [validation notes](validation.md) or the [benchmark code](https://github.com/org/repo).
```

Long URLs and tables:

```markdown
| Source | Lesson |
|---|---|
| [9th place][leap9] | preprocessing beat architecture |

[leap9]: https://example.com/a/very/long/path/to/the/write-up
```

### Line length

- Prose: no hard wrapping; one bullet or one short paragraph per line.
- Repos that already wrap at 80 keep doing so (match the corpus).
- Links, tables, headings and code blocks are never wrapped.

### Whitespace and HTML

- No trailing spaces (they create invisible `<br>`); a blank line makes a paragraph.
- GitHub alerts are fine: `> [!NOTE]`, `> [!IMPORTANT]`, `> [!WARNING]`.
- `<details>` is acceptable for long optional blocks on GitHub; nothing else.

### Images

```markdown
![LB score per submission, falling from 0.230 to 0.088](figures/lb-history.png)
```
