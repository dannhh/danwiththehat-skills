# Worklog

A work journal that lives in your Obsidian vault next to your learning notes, so you can read it on any device.

## Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `log` | `/log` | Add a work entry, or recap a day / week / standup from past entries |

## Storage Location (resolve FIRST)

```bash
echo "${NOTES_DIR:-}"
```

| `NOTES_DIR` | `<JOURNAL>` |
|---|---|
| set | `$NOTES_DIR/journal` |
| empty | `journal` (this skill dir) |

Create missing directories on first write.

## Daily Note Format

One file per day: `<JOURNAL>/<YYYY-MM-DD>.md`. Shared with the `concept-learner` plugin's `/note`, which writes `## Learned`; this skill writes `## Work log`.

```markdown
---
date: <YYYY-MM-DD>
tags: [daily]
---
# <YYYY-MM-DD>

## Learned

## Work log
```

## Obsidian Conventions

- Tag projects as `#project/<name>` (lowercase, hyphenated) so Obsidian's tag pane and Dataview can filter them
- Link people and concepts with `[[wikilinks]]`
- Only append — never rewrite lines the user edited in Obsidian
- Never read or write anything under `.obsidian/`
