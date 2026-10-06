---
name: markdown-style
description: |
  Use this skill when writing, editing, or reviewing Markdown: READMEs, docs, project
  notes, findings, logs, experiment write-ups, CLAUDE.md files, SKILL.md files.
  Triggers: "write a README", "clean up the notes", "format this doc", "review the
  docs", "markdown style", "viết README", "viết note", "dọn notes", "tổ chức lại notes",
  "viết cho dễ đọc", "format markdown".
  Modes: write (apply the rules) → audit (measure an existing corpus, fix in batches,
  lint with markdownlint).
metadata:
  tags: [markdown, documentation, notes, readme, writing, markdownlint]
---

# Markdown Style

Plain, consistent Markdown that reads well as source and renders well on GitHub and in Obsidian. Readers scan; write for scanning.

Adapted from the Google Markdown style guide (CC BY 3.0), changed for GitHub/Obsidian and for notes that an agent or a hurried human will read.

## When to Use

- Writing or changing any `.md` file → **Write** (apply the rules silently).
- Asked to review, tidy, or reorganize docs or notes → **Audit**.
- A repo or vault with its own written rules (e.g. a vault `_CLAUDE.md`, a project's docs guide): those rules win; this skill fills the gaps.

## The rules (details and examples: references/RULES.md)

### Content

- **Minimum viable docs.** A few fresh, accurate files beat many stale ones. Merge overlapping docs, delete cruft in small batches, keep one index.
- **Bullets over prose.** One fact per bullet, nested bullets for evidence and numbers. Paragraphs only for a 1–3 sentence introduction.
- **Plain, human sentences.** Explanations are full sentences a newcomer understands, not shorthand (`→ targets raw`). Say what was asked and what was learned.
- **Tables only for two-dimensional data**: many parallel items with the same attributes. Few rows, empty cells, or rambling cells → use a list.
- **Evidence next to claims**: numbers, dates (`as of 2026-10-07`) and sources inline.
- **Original capitalization** of names: `PyTorch`, `GitHub`, `uv`, `ruff`.

### Layout

- **One H1** = the title, close to the file name; then a short introduction; then H2+. End with `## See also` for related links when useful.
- **ATX headings** (`## Heading`), a blank line before and after, sentence case, unique and complete names (`### GBDT results`, not a second `### Results`).
- **Long docs get an index**: a short "Contents" list or a table of sections at the top; no `[TOC]` (GitHub and Obsidian ignore it).

### Syntax

 1. **Lists:** `-` for bullets, 2-space nesting (match the corpus if it uses another consistent style). Numbered lists for steps; lazy `1.` numbering for long lists that change.
 2. **Code:** inline backticks for names, paths, commands and fake URLs; fenced blocks with a language (`bash`, `python`, `toml`, `text`), never indented blocks; escape long shell lines with `\`.
 3. **Links:** descriptive text (`[blend formula](validation.md#blend-formula)`), never "here" or a bare URL in prose; relative paths within the repo; reference links for long URLs and in tables, defined at the end of the section of first use.
 4. **No hard wrapping** of prose: one bullet or sentence group per line; GitHub and Obsidian soft-wrap. Keep lines short by writing short bullets. (A repo that already wraps at 80 keeps wrapping.)
 5. **No trailing whitespace**; no HTML unless Markdown cannot do it (GitHub alerts `> [!NOTE]` / `> [!IMPORTANT]` are fine).
 6. **Images** only when showing beats telling, always with alt text.

## Instructions

### Write

- Apply the rules while writing. Before saving, reread as a newcomer: does the first screen say what this is and why it matters?
- Notes language: follow the project (e.g. English notes, chat in another language).

### Audit

1. **Measure.** Run `npx --yes markdownlint-cli2 "**/*.md"` with references/markdownlint-template.jsonc copied to `.markdownlint-cli2.jsonc` at the repo root, and count prose paragraphs, duplicate headings, files that overlap. Report a short table.
2. **Plan the structure** before editing: what to merge, move, delete; one index file. Use `git mv` for moves so history follows; fix every inbound link (grep for the old path).
3. **Fix in batches**: structure (moves/merges) → content (bullets, plain sentences, stale facts updated or marked) → syntax (lint fixes). One commit each.
4. **Never lose information**: when merging or rewriting, check every fact of the old text is still present or deliberately dropped (say which).
5. After any scripted change (unwrapping, lint --fix): compare word counts per file and diff every code block; scripts that track fences break on nested fences (```` around ```).
6. Leave files the user is editing alone and say so.

## Output

- Write: the files changed.
- Audit: findings table, the new structure (tree), commits made, anything dropped.

## References

- references/RULES.md: each rule with bad/good examples.
- references/markdownlint-template.jsonc: lint config matching these rules.
