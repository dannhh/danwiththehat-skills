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

> **Paths:** resolve `<MEM>` and `<JOURNAL>` from `NOTES_DIR` first — see "Storage Location" in the concept-learner `CLAUDE.md`.

## Phase 0 — Clarify

Before generating, ask only what's missing:

| What | Examples |
|------|---------|
| Concept | "gradient descent", "TCP/IP", "options pricing" |
| Format | Notes, summary, flashcards, reference sheet |
| Depth | Beginner overview, intermediate, advanced |

Load `<MEM>/concepts/<concept>.md` if available — use existing notes as the source of truth.

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

Format (Obsidian Spaced Repetition plugin — reviewable on phone):
```
#flashcards/<concept>

<question>
?
<answer>
```
Separate cards with a blank line. Use `<question>::<answer>` for one-line cards.

### Reference Sheet
Quick-lookup format:
- Formulas, syntax, or rules
- Decision trees or when-to-use guides
- Side-by-side comparisons

## Output

Save to `<MEM>/materials/<concept>/<format>-<YYYY-MM-DD>.md`.

Start the file with frontmatter `tags: [materials]` and a link back: `Source: [[<concept>]]`.

Update `<MEM>/_index.md` with a pointer to the generated file (as a `[[wikilink]]`).

## Rules

- Ground every claim in `<MEM>/concepts/<concept>.md` if it exists — don't contradict prior study notes
- Flag anything uncertain rather than fabricating
- Keep flashcard answers concise — one clear fact per card