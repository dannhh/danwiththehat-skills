# Concept Learner

A self-improving learning skill that guides you through mastering new concepts via structured study, generated materials, and spaced repetition.

## What This Is

A **Claude Code skill** that acts as a personal tutor. Given any concept, it breaks it down, explains it progressively, generates study materials, and tracks your retention over time via quizzes.

Unlike a generic assistant, this learner **accumulates knowledge about you** — it remembers what you've studied, where you struggled, and adapts future sessions accordingly.

## Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `study` | `/study` | Guided session — break down a concept, explain progressively, check understanding |
| `materials` | `/materials` | Generate notes, summaries, flashcards, or reference docs for a concept |
| `quiz` | `/quiz` | Quiz on a studied concept, score responses, update retention tracking |

## How This Works

```
RECALL → TEACH → REINFORCE → repeat
```

1. **RECALL** — read `lt-memory/_index.md`, load prior concept notes and progress
2. **TEACH** — explain the concept, adapt depth to what you already know
3. **REINFORCE** — quiz, score, write findings back to `lt-memory/`

## Progressive Disclosure

| Level | What | When to Load |
|-------|------|--------------|
| **0** | This file | Always |
| **1** | `lt-memory/_index.md` | Before every session |
| **2** | `lt-memory/concepts/<concept>.md` | When studying or quizzing a specific concept |
| **3** | `lt-memory/progress/<concept>.md` | Before a quiz to tailor difficulty |

## lt-memory Structure

```
lt-memory/
├── _index.md         ← Catalog of all studied concepts (read FIRST)
├── concepts/         ← Notes and breakdowns per concept
└── progress/         ← Quiz scores and retention levels per concept
```

**Rule:** `concepts/` = what was taught. `progress/` = how well it was retained. Never mix them.

## Pitfalls

- Always load prior concept notes before starting a study session — avoid re-explaining things already mastered
- Never fabricate quiz answers as correct — if uncertain, mark as "needs review"
- Adapt explanation depth to the user's background; ask if unknown

## Progress Tracking

| Timeframe | Where |
|-----------|-------|
| **Concepts studied** | `lt-memory/concepts/` |
| **Retention scores** | `lt-memory/progress/` |
| **Index** | `lt-memory/_index.md` |