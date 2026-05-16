# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

`danwiththehat-skills` is a personal plugin/skill repository for AI coding assistants (Claude Code, Vercel CLI). Skills are installed by agents directly from Git — there is no build artifact to deploy. The only build step is regenerating the marketplace index manifest.

### Plugins

| Plugin | Skills | Purpose |
|---|---|---|
| `data-analytics` | `da-sql` | SQL analysis, query writing, and dashboarding with persistent lt-memory |
| `engineering` | `improve-codebase-architecture`, `test-driven-development` | Software design and TDD workflows |
| `learning` | `concept-learner` (`/study`, `/quiz`, `/materials`) | Spaced-repetition learning with persistent concept and progress memory |

## Commands

```bash
# After adding/modifying any plugin — regenerates .claude-plugin/marketplace.json and updates plugin versions
python3 scripts/build.py

# End-to-end integration test (requires npx and claude CLI)
bash scripts/test-integration.sh
```

There are no lint or unit test commands — `test-integration.sh` is the only automated test.

## Architecture

### Plugin discovery flow

`build.py` scans `plugins/*/` for `.claude-plugin/plugin.json` files. For each plugin found it:
1. Derives `version` from the last git commit touching that plugin dir (format: `YYYY.mmdd.HHMM`)
2. Writes the updated version back into the plugin's own `plugin.json`
3. Appends an entry to `.claude-plugin/marketplace.json` at the repo root

The root `.claude-plugin/marketplace.json` is what Claude Code reads when a user runs `/plugin marketplace add <url>`. It must be committed — the file is served directly from Git, not a build server.

### Skill layout

```
plugins/
└── <plugin-name>/
    ├── .claude-plugin/
    │   └── plugin.json          ← name, version, description (version auto-updated by build.py)
    └── skills/
        └── <skill-name>/
            └── SKILL.md         ← frontmatter (name, description, metadata.tags) + instructions
```

`SKILL.md` frontmatter `name` **must exactly match** the directory name.

### Two consumers, two discovery paths

| Consumer | Reads | Notes |
|---|---|---|
| Claude Code `/plugin` | `.claude-plugin/marketplace.json` → plugin dirs | Supports nested skills |
| Vercel `npx skills` | Scans Git tree for `SKILL.md` directly | Flattened; skill names must be globally unique |

### Description field rules (critical)

The `description` field in `SKILL.md` frontmatter is how agents decide whether to invoke a skill. Long descriptions (>200 chars) **must use YAML `|` block scalar** — single-line strings that long are silently dropped by the Vercel CLI parser.

## Adding a New Skill

1. Create `plugins/<plugin>/skills/<skill-name>/SKILL.md` — `name` in frontmatter must match directory name.
2. Ensure `plugins/<plugin>/.claude-plugin/plugin.json` exists (create plugin first if needed).
3. Run `python3 scripts/build.py` to regenerate `marketplace.json`.
4. Commit both the new `SKILL.md` and the updated manifests together.

> See `BEST_PRACTICES.md` for skill authoring rules (description format, line limits, tags, progressive disclosure).
