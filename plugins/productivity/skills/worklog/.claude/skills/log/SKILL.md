---
name: log
description: |
  Use this skill when the user wants to record or review what they worked on:
  "/log", "log lại", "hôm nay tôi đã làm...", "blocked by...", "standup",
  "hôm qua làm gì", "recap this week". Appends entries to the Work log section of
  today's Obsidian daily note, or summarizes past entries into a standup or weekly recap.
---

# Log

Two modes: **add** (default) → append an entry. **recap** → summarize past entries.

> **Paths:** resolve `<JOURNAL>` from `NOTES_DIR` first — see "Storage Location" in the worklog `CLAUDE.md`.

## Add Mode

### 1. Parse

| Field | Notes |
|-------|-------|
| What | What was done, in the user's words |
| Type | `done` (default), `wip`, `blocked`, `todo` |
| Project | Reuse an existing `#project/<name>` — grep `<JOURNAL>/` for tags before inventing one |
| Links | PR / ticket / doc URLs, if given |

If the user says "from git" or gives no content, offer to draft entries from `git log --since=midnight --author="$(git config user.name)"` in the current repo, and confirm before writing.

### 2. Append

Open `<JOURNAL>/<YYYY-MM-DD>.md` (create with the template in `CLAUDE.md` if missing). Append under `## Work log`:

```markdown
- HH:MM ✅ <what> #project/<name> ([PR](url))
- HH:MM 🚧 <what> #project/<name>
- HH:MM ⛔ blocked: <what> — waiting on [[<person>]]
- [ ] <todo> #project/<name>
```

Todos use Obsidian checkboxes so they can be ticked on the phone.

### 3. Confirm

One line: what was logged.

## Recap Mode

Triggered by "standup", "recap", "hôm qua", "tuần này", "this week", "/log review".

| Request | Range | Output |
|---------|-------|--------|
| Standup | last working day + today | **Yesterday** / **Today** (open `wip` + `[ ]` todos) / **Blockers** |
| Day | one date | Grouped by project |
| Week | last 7 days (default) | Per project: done, still open, blockers; plus unchecked todos older than 3 days |

Read only the `## Work log` sections. Group by `#project/` tag; untagged entries go under "Other".

Print the recap in chat. Save it only if asked — then write to `<JOURNAL>/recaps/<YYYY>-W<ww>.md` with frontmatter `tags: [recap]`.

## Rules

- Only append; never edit or delete existing entries (ticking a todo the user says is done is the one exception)
- Never invent work that isn't in the notes or git history
- Never touch `.obsidian/`
