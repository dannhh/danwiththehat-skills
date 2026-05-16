# danwiththehat-skills

A personal plugin/skill repository for AI coding assistants (Claude Code, Vercel CLI), following the [Vercel Agent Skills](https://agentskills.io/) specification.

> Read the [Best Practices Guide](./BEST_PRACTICES.md) before adding a new skill.

## Plugins

| Plugin | Skills | Purpose |
|---|---|---|
| `data-analytics` | `da-sql` | SQL analysis, query writing, and dashboarding with persistent lt-memory |
| `engineering` | `improve-codebase-architecture`, `test-driven-development` | Software design and TDD workflows |
| `learning` | `concept-learner` (`/study`, `/quiz`, `/materials`) | Spaced-repetition learning with persistent concept and progress memory |

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
