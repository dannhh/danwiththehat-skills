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

> **Vault:** resolve `<VAULT>` and read `<VAULT>/_CLAUDE.md` first; it is authoritative for folders, naming, frontmatter, and writing rules. See "Vault" in the concept-learner `CLAUDE.md`.

## Phase 0 — Clarify

Before generating, ask only what's missing:

| What | Examples |
|------|---------|
| Concept | "gradient descent", "TCP/IP", "options pricing" |
| Format | Notes, summary, flashcards, reference sheet |
| Depth | Beginner overview, intermediate, advanced |

Load the concept's note (via `<VAULT>/index.md`) if available — use it as the source of truth.

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

Save to `<VAULT>/wiki/concepts/<Concept Title> - <Format>.md` (e.g. `vLLM - Flashcards.md`). If it exists, add new cards or sections rather than overwriting.

Frontmatter: `date`, `type: material`, `tags: [material, <format>]`, `ai-first: true`, `sources: ["[[<Concept Title>]]"]`, then the `## For future agent` preamble.

Link it from the concept note, add it to `<VAULT>/index.md`, and append `## [<YYYY-MM-DD>] create | <file name>` to `<VAULT>/log.md`.

## Rules

- Ground every claim in the concept's note if it exists — don't contradict prior study notes
- Flag anything uncertain rather than fabricating
- Keep flashcard answers concise — one clear fact per card