# danwiththehat-skills

A personal plugin/skill repository for AI coding assistants (Claude Code, Vercel CLI), following the [Vercel Agent Skills](https://agentskills.io/) specification.

> Read the [Best Practices Guide](./BEST_PRACTICES.md) before adding a new skill.

## Plugins

| Plugin | Skills | Purpose |
|---|---|---|
| `data-analytics` | `da-sql` | SQL analysis, query writing, and dashboarding with persistent lt-memory |
| `engineering` | `improve-codebase-architecture`, `test-driven-development` | Software design and TDD workflows |
| `learning` | `concept-learner` (`/study`, `/note`, `/quiz`, `/materials`) | Spaced-repetition learning; notes stored in an Obsidian vault (`$NOTES_DIR`) |
| `productivity` | `worklog` (`/log`) | Work log, standups and weekly recaps in the same Obsidian daily notes |

## Usage

### Claude Code Marketplace

```bash
# Add this repo to your Claude Code marketplace
/plugin marketplace add https://github.com/dannhh/danwiththehat-skills.git

# Then install a plugin via the UI
/plugin
```

### Vercel `npx skills` CLI

```bash
# Add all skills
npx skills add https://github.com/dannhh/danwiththehat-skills.git

# Add a specific skill
npx skills add https://github.com/dannhh/danwiththehat-skills.git --skill concept-learner
```

### Notes vault (Obsidian)

`learning` and `productivity` write to an Obsidian vault so notes sync across devices (Obsidian Sync, iCloud, or git). Point the skills at it in `~/.claude/settings.json`:

```json
{ "env": { "NOTES_DIR": "/Users/<you>/notes" } }
```

Layout: `learning/` (concepts, progress, materials, `_index.md`) and `journal/YYYY-MM-DD.md` daily notes. Without `NOTES_DIR`, skills fall back to their local `lt-memory/`.

## Development

### Adding a New Skill

1. Create `plugins/<plugin>/skills/<skill-name>/SKILL.md` — `name` in frontmatter must match directory name.
2. Ensure `plugins/<plugin>/.claude-plugin/plugin.json` exists.
3. Run `python3 scripts/build.py` to regenerate `marketplace.json`.
4. Commit both the new `SKILL.md` and the updated manifests together.

### Build & Test

```bash
# Regenerate .claude-plugin/marketplace.json
python3 scripts/build.py

# End-to-end integration test (requires npx and claude CLI)
bash scripts/test-integration.sh
```
