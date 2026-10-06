# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this repo is

`danwiththehat-skills` is a personal collection of Claude Code skills, grouped into plugins. It is served straight from Git: no build artifact, no deploy. The only build step regenerates the plugin manifests.

| Plugin | Workspace | Commands |
|---|---|---|
| `learning` | `concept-learner` | `/study` `/note` `/quiz` `/materials` |
| `productivity` | `worklog` | `/log` |
| `data-analytics` | `da-sql` | `/deep-analyze` + `da-sql-analyst` agent |
| `engineering` | `engineering` | `/test-driven-development` `/improve-codebase-architecture` `/python-code-standard` `/markdown-style` |

## Commands

```bash
python3 scripts/build.py            # regenerate .claude-plugin/marketplace.json + plugin versions
bash scripts/test-integration.sh    # end-to-end check (needs npx and the claude CLI)
```

No lint and no unit tests. `test-integration.sh` is the only automated check.

## Layout

Each skill folder is a **self-contained workspace**: its own `CLAUDE.md` plus project-scoped skills under `.claude/skills/`. Commands only exist when Claude Code is opened inside that folder.

```text
plugins/<plugin>/
├── .claude-plugin/plugin.json          ← name, description; version is written by build.py
└── skills/<workspace>/
    ├── CLAUDE.md                       ← workspace context, loaded when opened there
    ├── .gitignore
    └── .claude/
        ├── skills/<command>/
        │   ├── SKILL.md                ← frontmatter name == folder name
        │   └── references/…            ← optional, loaded on demand
        └── agents/<agent>.md           ← optional subagents
```

> [!IMPORTANT]
> This nested layout is a deliberate choice; keep it for new skills. Known trade-off: `/plugin install` registers the plugins but loads **zero** skills (verified with `claude --plugin-dir plugins/learning`). Don't "fix" it by flattening unless asked.

### How the manifests are built

`build.py` scans `plugins/*/.claude-plugin/plugin.json` and, for each plugin:

1. sets `version` from the last commit touching that plugin (`YYYY.mmdd.HHMM`)
2. writes it back into the plugin's `plugin.json`
3. adds the plugin to the root `.claude-plugin/marketplace.json`

Every plugin's version is recomputed on every run, so `plugin.json` diffs in untouched plugins are expected. Commit `marketplace.json`; it is read directly from Git.

## User data lives outside the repo

Notes, progress, and logs belong to the user, not to the plugin.

| Variable | Used by | Points to |
|---|---|---|
| `NOTES_DIR` | `learning`, `productivity` | Obsidian vault (`~/notes`), second-brain wiki layout; its own `CLAUDE.md` is the schema |

- New skills that store data must read the location from an env var and stop with setup instructions when it is unset. Never write user data into the repo.
- Vault conventions (folders, frontmatter, naming, AI-first rules) live in `$NOTES_DIR/_CLAUDE.md`, not in the skills. Skills point to it instead of restating it.

## Writing skills

- `description` decides whether a skill fires. State **when** to use it and the trigger phrases (Vietnamese ones too).
- Descriptions over 200 chars must be a YAML block scalar (`|` or `>`). Long single-line strings are silently dropped by the Vercel CLI.
- Keep `SKILL.md` under 500 lines; move heavy material to `references/`.
- Full rules: [BEST_PRACTICES.md](./BEST_PRACTICES.md).

**Adding one:**

1. Create `plugins/<plugin>/skills/<workspace>/.claude/skills/<command>/SKILL.md`
2. New plugin? Add `plugins/<plugin>/.claude-plugin/plugin.json` and a workspace `CLAUDE.md`
3. Run `python3 scripts/build.py`
4. Update the command tables in this file and in `README.md`
5. Commit the skill and the manifests together

## Rules

- **No company or proprietary data.** No internal table names, project IDs, queries, or results. Examples must use generic schemas (`user_id`, `variant`, `<project>.<dataset>.<table>`). This repo was already scrubbed once.
- **Commit messages:** `[type] Short message`, where type is `feat` / `fix` / `chore` / `docs` / `refactor`. No mention of Claude or coding agents, and no `Co-Authored-By` trailer.
- **README voice:** first person, "one person, many hats" theme, minimal emoji (numbered `01`–`04` hats instead of icons). Keep it when editing.
