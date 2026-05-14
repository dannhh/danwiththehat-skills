# 🛠 REDACTED AI Skills

A centralized, multi-agent skill repository for managing AI coding assistant skills, now following the [Vercel Agent Skills](https://agentskills.io/) specification.

> 📖 Read the [Best Practices Guide](./BEST_PRACTICES.md) before adding a new skill.

## ✨ Features

## 🚀 Usage

### Using Vercel `agent-skills` CLI (Recommended)

You can install `REDACTED` directly using the Vercel `skills` CLI by pointing it natively to this Git repository (it automatically evaluates the source tree).

```bash
# Add the entire suite of skills natively
npx skills add https://skills.mservice.io/.git
```

**Advanced Installation Examples:**
```bash
# Add specific skills explicitly by their names (e.g., the 'gerrit-workflow' skill)
npx skills add https://skills.mservice.io/.git --skill gerrit-workflow

# Install globally applied to a specific agent (e.g., Claude Code)
npx skills add https://skills.mservice.io/.git -g --agent claude-code
```

### Using Claude Code Marketplace (Native GUI)

You can install plugins interactively directly inside the Claude Code terminal layout.

To add this repository to your Claude Code marketplace list using the standard internal HTTP domain, **you must append `.git` to the URL** so Claude natively recognizes it as a Git repository and clones the physics files successfully:

```bash
# Add the remote repository with .git explicitly
/plugin marketplace add https://skills.mservice.io/.git
```

Once linked, you can use the graphical UI directly within Claude Code:
```bash
/plugin
```

Or you can install a specific skill or **Bundle Pack** explicitly:
```bash
# Install an entire bundle pack (groups all skills together)
/plugin install git-pack@REDACTED
```

---

## 🗂 Organization

Skills are organized into **Groups** within the `skills/` directory:

- **Generic Groups**: Single noun for general technology (e.g., `git`, `workflow`).
- **Team Groups**: Prefix `team-` followed by the team name (e.g., `team-payment`).

### Structure Example
The `skills` CLI and Claude Code both support deep-scanning for nested subgroups:

```
skills/
  ├── git/                     # Generic group
  │   └── gerrit/              # Subgroup
  │       ├── gerrit-cherry-pick/
  │       └── gerrit-checkout-branch/
  └── team-payment/            # Team group
      └── internal-api/        # Subgroup
          └── reconciliation-rules/
```

---

## 🛠 Development

### Adding a New Skill
1. Create a directory: `skills/<group>/[<subgroup>/]my-new-skill/`.
2. Author your `SKILL.md` following the [Best Practices Guide](./BEST_PRACTICES.md).
3. Ensure the `name` in frontmatter matches the directory name exactly.

### Building & Testing Locally
Because this repository is served exactly as it rests in Git, you **must build and commit the `.claude-plugin/marketplace.json` manifest locally** whenever you add a new skill!

Run the build script before opening a pull request:

```bash
# Refreshes `.claude-plugin/marketplace.json` and writes `.claude-plugin/plugin.json` for each skill and existing pack
python3 scripts/build.py
```

To verify your new skills natively on your local machine before pushing:

```bash
# Run the automated end-to-end integration test
./scripts/test-integration.sh
```



## 📄 License
Internal use only. © REDACTED Developer Team
