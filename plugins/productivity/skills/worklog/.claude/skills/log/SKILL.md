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

> **Vault:** resolve `<VAULT>` and read `<VAULT>/_CLAUDE.md` first — see "Vault" in the worklog `CLAUDE.md`.

## Add Mode

### 1. Parse

| Field | Notes |
|-------|-------|
| What | What was done, in the user's words |
| Type | `done` (default), `wip`, `blocked`, `todo` |
| Project | Match an existing note in `<VAULT>/wiki/projects/` (check `<VAULT>/index.md`) before creating one |
| Links | PR / ticket / doc URLs, if given |

If the user says "from git" or gives no content, offer to draft entries from `git log --since=midnight --author="$(git config user.name)"` in the current repo, and confirm before writing.

### 2. Append

Open `<VAULT>/wiki/daily/<YYYY-MM-DD>.md` (create it from `<VAULT>/templates/daily.md` if missing, replacing every `{{date:...}}` placeholder). Append under `## Work log`:

```markdown
- HH:MM ✅ <what> [[<Project>]] ([PR](url))
- HH:MM 🚧 <what> [[<Project>]]
- HH:MM ⛔ blocked: <what> — waiting on [[<Person>]]
```

Todos go under `## Tasks` as Obsidian checkboxes, so they can be ticked on the phone:

```markdown
- [ ] <todo> [[<Project>]]
```

A decision goes under `## Decisions` and is also appended, dated, to the project's `## Key Decisions` (propagation rule).

If a session is big enough to need its own note (several steps, a root cause, commands worth keeping), write `<VAULT>/wiki/logs/<YYYY-MM-DD> - <Description>.md` with `type: devlog`, link it from the daily line, and add it to the project's `## Recent Activity`.

### 3. Confirm

One line: what was logged.

## Recap Mode

Triggered by "standup", "recap", "hôm qua", "tuần này", "this week", "/log review".

| Request | Range | Output |
|---------|-------|--------|
| Standup | last working day + today | **Yesterday** / **Today** (open `wip` + `[ ]` todos) / **Blockers** |
| Day | one date | Grouped by project |
| Week | last 7 days (default) | Per project: done, still open, blockers; plus unchecked todos older than 3 days |

Read the `## Work log`, `## Decisions`, and `## Tasks` sections. Group by `[[Project]]` link; unlinked entries go under "Other".

Print the recap in chat. Save it only if asked: write `<VAULT>/wiki/reviews/<YYYY>-W<ww>.md` with `type: review` frontmatter and the preamble, add it to `<VAULT>/index.md`, and append to `<VAULT>/log.md`.

## Rules

- Only append; never edit or delete existing entries (ticking a todo the user says is done is the one exception)
- Never invent work that isn't in the notes or git history
- Never touch `.obsidian/`
