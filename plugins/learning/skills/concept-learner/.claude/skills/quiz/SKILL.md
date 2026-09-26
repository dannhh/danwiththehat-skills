---
name: quiz
description: >
  Quiz the user on a studied concept using spaced repetition logic. Selects questions
  based on prior scores, grades responses, gives feedback, and updates retention tracking.
  Use when the user wants to test or reinforce their knowledge of a concept.
---

# Quiz

Spaced repetition quiz: load history → select questions → grade → save scores.

> **Paths:** resolve `<MEM>` and `<JOURNAL>` from `NOTES_DIR` first — see "Storage Location" in the concept-learner `CLAUDE.md`.

## Phase 0 — Load History

Read `<MEM>/progress/<concept>-progress.md` to determine:
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

Write to `<MEM>/progress/<concept>-progress.md`:

```markdown
---
tags: [progress]
concept: "[[<concept>]]"
---
# <Concept> — Progress

## Sessions

### <YYYY-MM-DD>
- Questions asked: N
- Average score: X.X / 5
- Weak areas: [list topics that scored ≤ 2]
- Strong areas: [list topics that scored ≥ 4]

## Retention Summary
| Topic | Last Score | Last Quizzed |
|-------|-----------|--------------|
| ...   | ...       | ...          |
```

Update `<MEM>/_index.md` with latest quiz date and average score.

Append under `## Learned` in today's daily note (`<JOURNAL>/<YYYY-MM-DD>.md`):
`- HH:MM /quiz [[<concept>]] — X.X/5, weak: <topics>`

## Rules

- Never reveal the answer before the user responds
- Score honestly — a friendly wrong answer is still wrong
- Always prioritize weak areas from prior sessions
- If the user scores ≥ 4 on all topics, flag the concept as mastered