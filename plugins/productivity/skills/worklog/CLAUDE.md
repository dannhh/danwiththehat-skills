# Worklog

A work journal that lives in your Obsidian vault next to your learning notes, so you can read it on any device.

## Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `log` | `/log` | Add a work entry, or recap a day / week / standup from past entries |

## Vault (resolve FIRST)

```bash
echo "${NOTES_DIR:-}"
```

If it is empty, stop: ask the user to set `NOTES_DIR` to their vault path in `~/.claude/settings.json` (`{ "env": { "NOTES_DIR": "/Users/<you>/notes" } }`) and restart Claude Code. Never write notes into this skill folder.

`<VAULT>` = `$NOTES_DIR`.

Then read `<VAULT>/_CLAUDE.md`. **It is authoritative** for folders, naming, frontmatter, and the propagation rule. If anything below disagrees with it, the vault wins.

| What | Where |
|---|---|
| Daily note | `<VAULT>/wiki/daily/<YYYY-MM-DD>.md`, section `## Work log` (created from `<VAULT>/templates/daily.md`) |
| Projects | `<VAULT>/wiki/projects/<Project>.md` |
| Longer work sessions | `<VAULT>/wiki/logs/<YYYY-MM-DD> - <Description>.md` |
| Saved recaps | `<VAULT>/wiki/reviews/<YYYY>-W<ww>.md` |
| Operation log | `<VAULT>/log.md` |

The daily note is shared with the `concept-learner` plugin, which writes `## Learned`.

## Conventions

- Link projects and people as `[[wikilinks]]`, never bare names. Create a project stub from `<VAULT>/templates/project.md` if it doesn't exist
- Tasks, blockers, and statuses stay in the daily note; they are never promoted to the wiki
- Daily notes are append only
- Never write internal table names, credentials, customer data, or metrics
- Never read or write anything under `.obsidian/`
