# Concept Learner

A self-improving learning skill that guides you through mastering new concepts via structured study, generated materials, and spaced repetition.

## What This Is

A **Claude Code skill** that acts as a personal tutor. Given any concept, it breaks it down, explains it progressively, generates study materials, and tracks your retention over time via quizzes.

Unlike a generic assistant, this learner **accumulates knowledge about you** — it remembers what you've studied, where you struggled, and adapts future sessions accordingly.

## Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `study` | `/study` | Guided session — break down a concept, explain progressively, check understanding |
| `note` | `/note` | Quick capture — log what you learned today into the daily note and merge it into the concept page |
| `materials` | `/materials` | Generate notes, summaries, flashcards, or reference docs for a concept |
| `quiz` | `/quiz` | Quiz on a studied concept, score responses, update retention tracking |

## How This Works

```
RECALL → TEACH → REINFORCE → repeat
```

1. **RECALL** — read `<MEM>/_index.md`, load prior concept notes and progress
2. **TEACH** — explain the concept, adapt depth to what you already know
3. **REINFORCE** — quiz, score, write findings back to `<MEM>/`

## Storage Location (resolve FIRST)

Notes live in an Obsidian vault so they sync across devices. Resolve paths before any read/write:

```bash
echo "${NOTES_DIR:-}"
```

| `NOTES_DIR` | `<MEM>` | `<JOURNAL>` |
|---|---|---|
| set | `$NOTES_DIR/learning` | `$NOTES_DIR/journal` |
| empty | `lt-memory` (this skill dir) | `lt-memory/journal` |

Create missing directories on first write. Always use absolute paths once resolved.

## Progressive Disclosure

| Level | What | When to Load |
|-------|------|--------------|
| **0** | This file | Always |
| **1** | `<MEM>/_index.md` | Before every session |
| **2** | `<MEM>/concepts/<concept>.md` | When studying or quizzing a specific concept |
| **3** | `<MEM>/progress/<concept>-progress.md` | Before a quiz to tailor difficulty |

## Memory Structure

```
<MEM>/
├── _index.md                       ← Catalog of all studied concepts (read FIRST)
├── concepts/<concept>.md           ← Notes and breakdowns per concept
├── progress/<concept>-progress.md  ← Quiz scores and retention levels per concept
└── materials/<concept>/            ← Generated notes, flashcards, cheat sheets
<JOURNAL>/<YYYY-MM-DD>.md           ← Daily note (shared with the worklog skill)
```

**Rule:** `concepts/` = what was taught. `progress/` = how well it was retained. Never mix them.

## Obsidian Conventions

- `<concept>` file names: lowercase, hyphenated (`paged-attention.md`). Must be unique across the vault — that is what `[[concept]]` resolves to.
- Link concepts with `[[wikilinks]]` (`[[vllm]]`, `[[kv-cache|KV cache]]`), never with file paths.
- Every concept file starts with frontmatter:
  ```yaml
  ---
  tags: [concept]
  created: YYYY-MM-DD
  updated: YYYY-MM-DD
  ---
  ```
- Daily note format and append rules: see `.claude/skills/note/SKILL.md`.
- Never read or write anything under `.obsidian/` — that is the app's config.
- Append or edit in place; never overwrite a file the user may have edited in Obsidian.

## Pitfalls

- Always load prior concept notes before starting a study session — avoid re-explaining things already mastered
- Never fabricate quiz answers as correct — if uncertain, mark as "needs review"
- Adapt explanation depth to the user's background; ask if unknown

## Progress Tracking

| Timeframe | Where |
|-----------|-------|
| **Day by day** | `<JOURNAL>/` |
| **Concepts studied** | `<MEM>/concepts/` |
| **Retention scores** | `<MEM>/progress/` |
| **Index** | `<MEM>/_index.md` |
