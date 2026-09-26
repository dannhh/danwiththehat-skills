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

> **Paths:** resolve `<MEM>` and `<JOURNAL>` from `NOTES_DIR` first — see "Storage Location" in the concept-learner `CLAUDE.md`.

## Phase 0 — Orient

Before explaining anything, clarify:

| What | Why |
|------|-----|
| The concept | Exact name and scope |
| User's background | What do they already know? |
| Goal | Broad understanding, practical use, or exam prep? |

Load `<MEM>/concepts/<concept>.md` if it exists — skip what's already covered.

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

Write to `<MEM>/concepts/<concept>.md`:

```markdown
---
tags: [concept]
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
---
# <Concept>

## Summary
<2–3 sentence plain-language summary>

## Key Points
- ...

## User's Prior Knowledge
<what they knew coming in>

## Struggled With
<what needed extra explanation>

## Connected Concepts
- [[related-concept]] — how it relates
```

If the file already exists, merge into it (keep the user's own edits) and bump `updated`.

Update `<MEM>/_index.md` with the concept entry.

Append one line under `## Learned` in today's daily note (`<JOURNAL>/<YYYY-MM-DD>.md`, format in `note/SKILL.md`):
`- HH:MM /study [[<concept>]] — <one-line takeaway>`

## Rules

- One phase at a time — confirm understanding before proceeding
- Adapt depth to the user's background
- Never skip Phase 0 — knowing their background changes everything
- Always save notes after the session