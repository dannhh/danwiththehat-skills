# Skills Best Practices

Guidelines for writing high-quality, effective skills for AI coding agents.

---

## 1. Naming

- Skill directory name **must match** the `name` field in `SKILL.md` frontmatter.
- Use lowercase with hyphens only: `gerrit-cherry-pick`, not `GerritCherryPick`.
- Be specific: `react-component-patterns` is better than `react`.

---

## 2. `description` — The Most Critical Field

The `description` is what the AI reads first to decide if a skill is relevant. Write it from the agent's perspective.

**Good (short — single line):**
```yaml
description: Use this skill when the user asks to cherry-pick a Gerrit patchset by URL or Change ID.
```

**Good (long — use `|` block scalar, preferred for multiline):**
```yaml
description: |
  Tạo Noti Campaign end-to-end cho REDACTED Agentic Marketing Platform.
  Dùng khi user muốn tạo mới noti campaign: "tạo campaign",
  "tạo noti", "muốn gửi thông báo", "launch campaign", hoặc paste brief.
  Flow: intent → prefetch MCP → draft content → re-confirm → push test → submit.
```

**Bad:**
```yaml
description: Gerrit stuff
```

Rules:
- Start with **"Use this skill when..."** or **"Teaches the agent to..."**
- Be specific about **triggers** and **inputs**
- Keep it under 2 sentences (or use `|` block scalar for longer descriptions)
- Avoid vague words like "helps", "handles", "general"
- **Long descriptions (>200 chars) must use YAML `|` (preferred) or `>` block scalar** — single-line strings that long get silently dropped by the Vercel CLI parser, causing the skill to be undiscoverable

---

## 3. SKILL.md Structure

Keep the main `SKILL.md` under **500 lines**. Use this structure:

```markdown
---
name: skill-name
description: Use this skill when...
---

# Skill Title

One-line summary of what this skill does.

## When to Use
Explicit conditions that should trigger this skill.

## Instructions
Numbered, actionable steps for the agent to follow.

## Examples (optional)
Concrete input/output examples.
```

---

## 4. Progressive Disclosure

Load heavy context only when needed. Avoid embedding large blocks of data directly in `SKILL.md`.

| Content Type | Where to Put It |
|---|---|
| Core agent instructions | `SKILL.md` |
| Reference tables, schemas | `references/REFERENCE.md` |
| Helper scripts | `scripts/my-script.sh` |
| Lookup data, fixtures | `assets/data.json` |

Reference them in `SKILL.md` with relative paths:
```markdown
See [reference guide](references/REFERENCE.md) for the full list.
Run the helper: `scripts/run.sh`
```

---

## 5. Project Structure

See [CLAUDE.md](CLAUDE.md) for the canonical layout and plugin creation steps.

`build.py` scans `plugins/*/.claude-plugin/plugin.json` to discover plugins — `SKILL.md` files are scanned independently by the Vercel/Claude CLI, not by `build.py`.

---

## 6. Tags (metadata)

Use `metadata.tags` for discoverability. Tags should reflect:
- **Technology**: `git`, `go`, `react`, `kafka`
- **Domain**: `backend`, `frontend`, `devops`
- **Context**: `gerrit`, `jira`, `k8s`

```yaml
---
name: my-skill
description: Use this skill when...
metadata:
  tags: [git, gerrit, workflow]
---
```

---

## 7. Checklist Before Committing a New Skill

- [ ] Directory name matches `name` in frontmatter
- [ ] `description` clearly states when the agent should use it
- [ ] Long descriptions (>200 chars) use YAML `|` (preferred) or `>` block scalar
- [ ] `metadata.tags` are set
- [ ] `SKILL.md` is under 500 lines
- [ ] Heavy reference material is moved to `references/` or `assets/`
- [ ] Placed in the correct plugin under `plugins/<name>/skills/`
- [ ] `plugins/<name>/.claude-plugin/plugin.json` exists for the plugin to be indexed
- [ ] Optional: verify locally with `python3 scripts/build.py && bash scripts/test-integration.sh`

