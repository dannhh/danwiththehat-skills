---
name: note
description: |
  Use this skill when the user wants to quickly jot down something they learned
  ("/note", "note lại", "hôm nay tôi học được...", "ghi nhớ cái này") without a full
  guided session. Appends the note to today's Obsidian daily note and merges it into
  the matching concept page. Also use for "what did I learn this week" reviews.
---

# Note

Fast capture: parse → append to daily note → merge into concept page → confirm.

> **Vault:** resolve `<VAULT>` and read `<VAULT>/_CLAUDE.md` first; it is authoritative for folders, naming, frontmatter, and writing rules. See "Vault" in the concept-learner `CLAUDE.md`.

## Phase 0 — Parse

From the user's message, extract:

| What | How |
|------|-----|
| Concept(s) | Match against `<VAULT>/index.md` first; reuse an existing name instead of inventing a near-duplicate |
| Content | The user's own words — keep them, fix only typos |
| Source | URL, book, video, person — if mentioned |

Ask only if the concept is genuinely ambiguous. Do not start a tutoring session — that is `/study`.

## Phase 1 — Append to Daily Note

File: `<VAULT>/wiki/daily/<YYYY-MM-DD>.md` (today, local time). If missing, create it from `<VAULT>/templates/daily.md`, replacing every `{{date:...}}` placeholder with today's date.

Append under `## Learned` (create the heading if the user removed it):

```markdown
- HH:MM [[<concept>]] — <note>. (src: <source>)
```

Daily notes are append only (vault `_CLAUDE.md` Section 5): never reorder, rewrite, or delete lines, and leave sections the user added alone.

## Phase 2 — Merge into Concept Page

- **Concept note exists** (found via `<VAULT>/index.md`): add the insight to `## Key Points` (or `## Notes` if it doesn't fit), skipping anything already there. Bump `updated`. End the bullet with a `[[<YYYY-MM-DD>]]` backlink.
- **Second mention, no note yet**: create `<VAULT>/wiki/concepts/<Concept Title>.md` with the frontmatter and preamble from `study/SKILL.md` Phase 5, fill only `Summary` and `Key Points`, and add it to `<VAULT>/index.md`.
- **First mention**: leave it in the daily note only. The weekly daily ingest (vault `_CLAUDE.md` Section 6) promotes it later.

Append `## [<YYYY-MM-DD>] update | <Concept Title> (note)` to `<VAULT>/log.md` whenever a wiki note changed.

If the note contradicts an existing Key Point, keep both and flag it: `⚠ conflicts with: ...` — let the user resolve.

## Phase 3 — Confirm

Reply in one or two lines: what was saved and where. Offer `/study <concept>` only if the note shows a clear gap.

## Review Mode

Triggered by "/note review", "tuần này học gì", "what did I learn this week":

1. Read `<VAULT>/wiki/daily/` notes for the range (default: last 7 days)
2. Group `## Learned` bullets by concept
3. Output a short recap + concepts not quizzed in > 7 days (check `last_quizzed` in the concept notes) as `/quiz` suggestions

## Rules

- Speed over structure — a note should take one turn
- Never paraphrase the user's insight into something they didn't say
- Never touch `.obsidian/`
