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

> **Paths:** resolve `<MEM>` and `<JOURNAL>` from `NOTES_DIR` first — see "Storage Location" in the concept-learner `CLAUDE.md`.

## Phase 0 — Parse

From the user's message, extract:

| What | How |
|------|-----|
| Concept(s) | Match against `<MEM>/_index.md` first; reuse an existing name instead of inventing a near-duplicate |
| Content | The user's own words — keep them, fix only typos |
| Source | URL, book, video, person — if mentioned |

Ask only if the concept is genuinely ambiguous. Do not start a tutoring session — that is `/study`.

## Phase 1 — Append to Daily Note

File: `<JOURNAL>/<YYYY-MM-DD>.md` (today, local time). If missing, create it:

```markdown
---
date: <YYYY-MM-DD>
tags: [daily]
---
# <YYYY-MM-DD>

## Learned

## Work log
```

Append under `## Learned` (create the heading if the user removed it):

```markdown
- HH:MM [[<concept>]] — <note>. (src: <source>)
```

Rules for the daily note (shared with the `log` skill):
- Only append — never reorder, rewrite, or delete lines the user wrote in Obsidian
- Keep both headings in this order; other sections the user adds are left alone

## Phase 2 — Merge into Concept Page

- **Concept exists** (`<MEM>/concepts/<concept>.md`): add the insight to `## Key Points` (or a `## Notes` section if it doesn't fit), skipping anything already there. Bump `updated` in frontmatter. Add a `[[<YYYY-MM-DD>]]` backlink at the end of the bullet.
- **New concept**: create the file with the frontmatter and headings from `study/SKILL.md` Phase 5, fill only `Summary` and `Key Points` from the note, and add the entry to `<MEM>/_index.md`.

If the note contradicts an existing Key Point, keep both and flag it: `⚠ conflicts with: ...` — let the user resolve.

## Phase 3 — Confirm

Reply in one or two lines: what was saved and where. Offer `/study <concept>` only if the note shows a clear gap.

## Review Mode

Triggered by "/note review", "tuần này học gì", "what did I learn this week":

1. Read `<JOURNAL>/` files for the range (default: last 7 days)
2. Group `## Learned` bullets by concept
3. Output a short recap + concepts not quizzed in > 7 days (check `<MEM>/_index.md`) as `/quiz` suggestions

## Rules

- Speed over structure — a note should take one turn
- Never paraphrase the user's insight into something they didn't say
- Never touch `.obsidian/`
