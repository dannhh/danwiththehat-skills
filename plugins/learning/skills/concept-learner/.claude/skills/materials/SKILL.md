---
name: materials
description: >
  Generate study materials for a concept: structured notes, summaries, flashcards,
  or reference docs. Use when the user wants a tangible artifact to study from,
  rather than an interactive session. Works best after a /study session has been run,
  but can generate from scratch.
---

# Materials

Generate study artifacts for a concept on demand.

## Phase 0 — Clarify

Before generating, ask only what's missing:

| What | Examples |
|------|---------|
| Concept | "gradient descent", "TCP/IP", "options pricing" |
| Format | Notes, summary, flashcards, reference sheet |
| Depth | Beginner overview, intermediate, advanced |

Load `lt-memory/concepts/<concept>.md` if available — use existing notes as the source of truth.

## Formats

### Notes
Full structured breakdown:
- Overview
- Key concepts with explanations
- Examples
- Common pitfalls
- Further reading

### Summary
One-page cheat sheet:
- 3-sentence definition
- Key points as bullets
- One worked example
- Key terms glossary

### Flashcards
Q&A pairs covering:
- Definitions
- How/why questions
- Apply-it scenarios
- Common misconceptions

Format:
```
Q: <question>
A: <answer>
```

### Reference Sheet
Quick-lookup format:
- Formulas, syntax, or rules
- Decision trees or when-to-use guides
- Side-by-side comparisons

## Output

Save to `materials/<concept>/<format>-<YYYY-MM-DD>.md`.

Update `lt-memory/_index.md` with a pointer to the generated file.

## Rules

- Ground every claim in `lt-memory/concepts/<concept>.md` if it exists — don't contradict prior study notes
- Flag anything uncertain rather than fabricating
- Keep flashcard answers concise — one clear fact per card