---
name: quiz
description: >
  Quiz the user on a studied concept using spaced repetition logic. Selects questions
  based on prior scores, grades responses, gives feedback, and updates retention tracking.
  Use when the user wants to test or reinforce their knowledge of a concept.
---

# Quiz

Spaced repetition quiz: load history → select questions → grade → save scores.

> **Vault:** resolve `<VAULT>` and read `<VAULT>/_CLAUDE.md` first; it is authoritative for folders, naming, frontmatter, and writing rules. See "Vault" in the concept-learner `CLAUDE.md`.

## Phase 0 — Load History

Find the concept's note via `<VAULT>/index.md` and read its `last_quizzed` / `quiz_avg` frontmatter and `## Quiz History` section to determine:

- What has been quizzed before
- Which areas scored low (< 70%) — prioritize these
- When last quizzed — flag if overdue (> 7 days)

If no history exists, run a baseline quiz covering all key points.

## Phase 1 — Select Questions

Pick 5–10 questions based on retention gaps. Mix of:

| Type | Example |
|------|---------|
| Definition | "In your own words, what is X?" |
| Explain | "Why does X behave this way?" |
| Apply | "Given this scenario, what would X do?" |
| Compare | "What's the difference between X and Y?" |
| Edge case | "What happens when X meets condition Z?" |

Weight toward areas with lowest prior scores.

## Phase 2 — Quiz

Ask one question at a time. Wait for the user's response before proceeding.

After each response, score it:

| Score | Meaning |
|-------|---------|
| 5 | Perfect — confident, complete |
| 4 | Good — correct with minor gaps |
| 3 | Partial — right idea, missing depth |
| 2 | Weak — significant gaps |
| 1 | Incorrect — fundamental misunderstanding |

Give brief feedback after each answer:

- What was right
- What was missing or wrong
- The correct answer if score ≤ 2

## Phase 3 — Save Progress

In the concept's note:

1. Set frontmatter `last_quizzed: <YYYY-MM-DD>` and `quiz_avg: X.X` (a snapshot, dated by `last_quizzed`).
2. Append a dated entry to `## Quiz History` at the end of the note (create the section if missing). Entries are snapshots; never rewrite old ones:

```markdown
## Quiz History

### <YYYY-MM-DD>
- Questions: N · Average: X.X / 5
- Weak: [topics scored ≤ 2]
- Strong: [topics scored ≥ 4]
```

Then propagate:

- today's daily note `<VAULT>/wiki/daily/<YYYY-MM-DD>.md`, under `## Learned`: `- HH:MM /quiz [[<Concept Title>]] — X.X/5, weak: <topics>`
- `<VAULT>/log.md`: `## [<YYYY-MM-DD>] quiz | <Concept Title> X.X/5`

## Rules

- Never reveal the answer before the user responds
- Score honestly — a friendly wrong answer is still wrong
- Always prioritize weak areas from prior sessions
- If the user scores ≥ 4 on all topics, flag the concept as mastered
