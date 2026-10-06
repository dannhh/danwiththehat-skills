---
name: study
description: >
  Guided study session for a new concept. Breaks the concept down into layers,
  explains progressively from fundamentals to nuance, checks understanding at each
  layer, and saves notes to the Obsidian notes vault. Use when the user wants to learn or deep-dive
  into a concept they are unfamiliar with or want to solidify.
---

# Study

Structured guided session: orient → layer → check → save.

> **Vault:** resolve `<VAULT>` and read `<VAULT>/_CLAUDE.md` first; it is authoritative for folders, naming, frontmatter, and writing rules. See "Vault" in the concept-learner `CLAUDE.md`.

## Phase 0 — Orient

Before explaining anything, clarify:

| What | Why |
|------|-----|
| The concept | Exact name and scope |
| User's background | What do they already know? |
| Goal | Broad understanding, practical use, or exam prep? |

Find the concept's note via `<VAULT>/index.md` (`wiki/concepts/` or, for tools and libraries, `wiki/entities/`). If it exists, load it and skip what's already covered.

## Phase 1 — Lay the Foundation

Explain the core idea in plain language. No jargon yet.

- One-paragraph intuition: what is it and why does it exist?
- A concrete real-world analogy
- Check: "Does this make sense so far?"

## Phase 2 — Build the Structure

Go one level deeper: the key components, rules, or mechanics.

- Break into 3–5 sub-concepts
- Explain each with a minimal example
- Highlight what trips people up most
- Check: ask the user to explain one sub-concept back in their own words

## Phase 3 — Apply It

Concrete application: a worked example or mini exercise.

- Walk through a real scenario step by step
- Ask the user to solve a variation themselves
- Correct and explain any misunderstanding

## Phase 4 — Nuance & Edge Cases

What the basics don't cover:

- Common misconceptions
- Edge cases or exceptions
- How this concept connects to related concepts

## Phase 5 — Save to Memory

Write to `<VAULT>/wiki/concepts/<Concept Title>.md` (tools and libraries go to `wiki/entities/` with their entity `type`):

```markdown
---
date: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
type: concept
tags: [concept]
ai-first: true
status: active
confidence: medium
sources: []
last_studied: <YYYY-MM-DD>
---
# <Concept Title>

## For future agent
<2-3 sentences: what this note covers, that it came from a /study session on <date>, any staleness caveat.>

## Summary
<2–3 sentence plain-language summary>

## Key Points
- ...

## User's Prior Knowledge
<what they knew coming in>

## Struggled With
<what needed extra explanation>

## Connected Concepts
- [[Related Concept]] — how it relates
```

If the note already exists, merge into it, bump `updated` and `last_studied`, and never touch `<!-- @user -->` blocks. Create stubs for linked concepts that don't exist yet.

Then propagate (vault `_CLAUDE.md` Section 5):

- `<VAULT>/index.md`: add or refresh the one-line entry
- today's daily note `<VAULT>/wiki/daily/<YYYY-MM-DD>.md`, under `## Learned`: `- HH:MM /study [[<Concept Title>]] — <one-line takeaway>`
- `<VAULT>/log.md`: `## [<YYYY-MM-DD>] study | <Concept Title>`

## Rules

- One phase at a time — confirm understanding before proceeding
- Adapt depth to the user's background
- Never skip Phase 0 — knowing their background changes everything
- Always save notes after the session
