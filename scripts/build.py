#!/usr/bin/env python3
"""
Build script for Claude Code Marketplace Index.

Scans the plugins/ directory for .claude-plugin/plugin.json files,
updates their versions based on git history, and generates the local
`.claude-plugin/marketplace.json` index file.

This replaces the old `dist/` Vercel web payload since the repository is now
served directly from Git.
"""

import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

PLUGINS_DIR = "plugins"


def get_plugin_version(source_dir: Path, project_root: Path) -> str:
    """Return YYYY.mmdd.HHMM from last commit touching this plugin dir. Fall back to current time if no history."""
    try:
        result = subprocess.run(
            ["git", "log", "-1", "--format=%at", "--", str(source_dir)],
            capture_output=True, text=True, check=True, cwd=project_root
        )
        timestamp = int(result.stdout.strip())
        dt = datetime.fromtimestamp(timestamp, tz=timezone.utc).astimezone()
        return dt.strftime("%Y.%m%d.%H%M")
    except (subprocess.CalledProcessError, ValueError):
        return datetime.now().strftime("%Y.%m%d.%H%M")


def find_plugins(root: Path) -> list[tuple[Path, Path, dict]]:
    """Find all plugins with .claude-plugin/plugin.json under the root directory.

    Returns a list of tuples: (plugin_dir, manifest_path, manifest_data)
    """
    plugins = []
    for plugin_dir in sorted(root.iterdir()):
        if not plugin_dir.is_dir():
            continue
        manifest_path = plugin_dir / ".claude-plugin" / "plugin.json"
        if manifest_path.exists():
            data = json.loads(manifest_path.read_text(encoding="utf-8"))
            plugins.append((plugin_dir, manifest_path, data))
    return plugins


def main():
    project_root = Path(__file__).resolve().parent.parent
    plugins_root = project_root / PLUGINS_DIR

    if not plugins_root.is_dir():
        print(f"ERROR: Plugins directory not found: {plugins_root}", file=sys.stderr)
        sys.exit(1)

    plugins = find_plugins(plugins_root)
    if not plugins:
        print("ERROR: No plugins found", file=sys.stderr)
        sys.exit(1)

    print(f"Found {len(plugins)} plugin(s)")

    claude_plugins = []

    for plugin_dir, manifest_path, data in plugins:
        name = data.get("name", plugin_dir.name)
        version = get_plugin_version(plugin_dir, project_root)
        data["version"] = version
        manifest_path.write_text(
            json.dumps(data, indent=2, ensure_ascii=False) + "\n",
            encoding="utf-8"
        )
        relative_source = f"./{plugin_dir.relative_to(project_root).as_posix()}"
        claude_plugins.append({"name": name, "source": relative_source})
        print(f"  ✓ {name}")

    # Write Claude Code plugins marketplace.json
    claude_plugin_dir = project_root / ".claude-plugin"
    claude_plugin_dir.mkdir(parents=True, exist_ok=True)
    marketplace_path = claude_plugin_dir / "marketplace.json"

    marketplace = {
        "name": "danwiththehat-skills",
        "owner": {"name": "Hong-Dan Nguyen"},
        "plugins": claude_plugins
    }
    marketplace_path.write_text(json.dumps(marketplace, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    print(f"Generated {marketplace_path.relative_to(project_root)}")
    print(f"  {len(claude_plugins)} plugin(s) indexed")


if __name__ == "__main__":
    main()
