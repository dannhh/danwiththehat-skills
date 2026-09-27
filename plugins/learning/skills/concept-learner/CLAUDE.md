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

1. **RECALL** — read `<VAULT>/index.md`, load the concept's note and its quiz history
2. **TEACH** — explain the concept, adapt depth to what you already know
3. **REINFORCE** — quiz, score, write findings back to the vault

## Vault (resolve FIRST)

Notes live in an Obsidian vault laid out as a second-brain LLM wiki. Resolve it before any read or write:

```bash
echo "${NOTES_DIR:-}"
```

If it is empty, stop: ask the user to set `NOTES_DIR` to their vault path in `~/.claude/settings.json` (`{ "env": { "NOTES_DIR": "/Users/<you>/notes" } }`) and restart Claude Code. Never write notes into this skill folder.

`<VAULT>` = `$NOTES_DIR`.

Then read `<VAULT>/_CLAUDE.md`. **It is authoritative** for folders, naming, frontmatter, the AI-first rules, and propagation. If anything below disagrees with it, the vault wins.

| What | Where |
|---|---|
| Catalog (read first) | `<VAULT>/index.md` |
| Concept notes | `<VAULT>/wiki/concepts/<Concept Title>.md` |
| Tools, libraries studied | `<VAULT>/wiki/entities/<Name>.md` |
| Study materials | `<VAULT>/wiki/concepts/<Concept Title> - <Format>.md` |
| Quiz progress | concept note frontmatter (`last_studied`, `last_quizzed`, `quiz_avg`) + its `## Quiz History` section |
| Daily note | `<VAULT>/wiki/daily/<YYYY-MM-DD>.md`, section `## Learned` |
| Operation log | `<VAULT>/log.md` |

## Progressive Disclosure

| Level | What | When to Load |
|-------|------|--------------|
| **0** | This file | Always |
| **1** | `<VAULT>/_CLAUDE.md` + `<VAULT>/index.md` | Before every session |
| **2** | The concept's note | When studying or quizzing a specific concept |

## Pitfalls

- Always load prior concept notes before starting a study session — avoid re-explaining things already mastered
- Never fabricate quiz answers as correct — if uncertain, mark as "needs review"
- Adapt explanation depth to the user's background; ask if unknown
