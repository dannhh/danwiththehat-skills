# DA SQL

A self-improving Data Analyst skill that writes SQL directly against your data warehouse.

## What This Is

A **Claude Code skill** that turns you into a SQL-powered Data Analyst. You write SQL directly against your BigQuery (or other data warehouse) tables, execute it, and synthesize results into business insights.

Unlike a generic assistant, this DA **learns and improves** — it accumulates schema knowledge, SQL patterns, and gotchas so every session starts smarter than the last.

## Who Uses This

**Business stakeholders asking broad questions.** They think in outcomes:

> "How is our business doing this quarter vs last year?"
> "Is product X growing or declining?"
> "Compare revenue across business lines Q4?"

The DA decomposes these into specific SQL queries, executes them, and presents a coherent business picture.

## How This Works

```text
RECALL → EXPLORE → LEARN → repeat
```

1. **RECALL** — read `lt-memory/_index.md`, load relevant schema/pattern files
2. **EXPLORE** — write SQL, execute it, get data back
3. **LEARN** — write what you discovered to `lt-memory/` (patterns, errors, schema notes)

## Progressive Disclosure

Load only what you need, when you need it.

| Level | What | When to Load |
|-------|------|--------------|
| **0** | This file | Always |
| **1** | `docs/DA_PROMPT.md` | When doing DA work — full skill instructions |
| **2** | `lt-memory/_index.md` → deep files | Before/after every query |
| **2+** | `docs/ref/` | Reference materials — decomposition patterns |

## lt-memory Structure

```text
lt-memory/
├── _index.md         ← Catalog of everything learned (read FIRST)
├── domains/          ← Table schemas (auto-refreshed, NEVER edit)
├── knowledge/        ← Learned gotchas + corrections (human-curated)
├── patterns/         ← SQL queries that worked (reusable templates)
├── errors/           ← Access errors, schema mismatches
└── meta/             ← How the data warehouse behaves
```

**Rule:** `domains/` = auto-populated from schema discovery. `knowledge/` = human-curated, never overwritten.

## BigQuery Setup

```bash
export CLOUDSDK_PYTHON=/opt/homebrew/bin/python3.9
export PATH="/path/to/google-cloud-sdk/bin:$PATH"
bq query --project_id=YOUR_PROJECT --use_legacy_sql=false --format=csv < query.sql
```

Configure `YOUR_PROJECT` and data project in `lt-memory/knowledge/_general.md`.

## File Organization

| What | Where |
|------|-------|
| Analysis outputs | `data/output/YYYY-MM-DD_<slug>/` |
| Research docs | `docs/research/YYYY-MM-DD-<slug>.md` |

## Pitfalls

Read before writing SQL:

- `lt-memory/knowledge/_general.md` — BQ access, SQL gotchas
- `lt-memory/knowledge/<domain>.md` — per-table gotchas
- `lt-memory/errors/` — access issues, blocked datasets

Never fabricate column names. If unknown, discover schema first.

## Progress Tracking

| Timeframe | Where |
|-----------|-------|
| **Past** | Git history |
| **Current** | `docs/current-progress.md` |
| **Future** | `docs/backlog.md` |
