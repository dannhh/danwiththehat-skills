#!/usr/bin/env bash
# Integration test for the Agent Skills discovery index

set -e

PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
MARKETPLACE_JSON="${PROJECT_ROOT}/.claude-plugin/marketplace.json"
MARKETPLACE_NAME="danwiththehat-skills"
TEST_MARKETPLACE_NAME="danwiththehat-skills-test"

echo "🔨 Building the agent skills index..."
python3 "${PROJECT_ROOT}/scripts/build.py"

echo -e "\n🧪 Testing Vercel CLI natively against local repository..."
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

OUTPUT=$(npx --yes skills@latest add "${PROJECT_ROOT}" -l 2>&1) || true
echo "--- Vercel CLI output ---"
echo "$OUTPUT"
echo "---"

FOUND_COUNT=$(echo "$OUTPUT" | grep -oE "(Found [0-9]+ skills|Found [0-9]+ plugins|Found [0-9]+ plugin)" | grep -oE "[0-9]+" | head -1)
if [ -n "$FOUND_COUNT" ]; then
    echo "Found $FOUND_COUNT skill(s)/plugin(s)"
fi

EXPECTED_MIN=2
if echo "$OUTPUT" | grep -qE "(Found [0-9]+ skills|Found [0-9]+ plugin)" && echo "$OUTPUT" | grep -oE "(Found [0-9]+ skills|Found [0-9]+ plugin)" | grep -oE "[0-9]+" | awk "{exit \$1 >= $EXPECTED_MIN ? 0 : 1}"; then
    echo "✅ Vercel integration test PASSED! CLI discovered skills over local Git tree."
elif echo "$OUTPUT" | grep -q -E "(Available Skills|Available Plugins)"; then
    echo "✅ Vercel integration test PASSED! CLI found skills listing."
else
    echo "❌ Vercel integration test FAILED! CLI did not find expected skills."
    echo "Output: $OUTPUT"
    exit 1
fi
cd "${PROJECT_ROOT}"
rm -rf "$TMP_DIR"

echo -e "\n🧪 Testing Claude Code marketplace CLI natively against local repository..."

# Rename marketplace to avoid colliding with the installed production marketplace
# perl -pi works the same on macOS (BSD) and Linux (GNU), unlike sed -i
perl -pi -e "s/\"name\": \"${MARKETPLACE_NAME}\"/\"name\": \"${TEST_MARKETPLACE_NAME}\"/" "${MARKETPLACE_JSON}"
trap "perl -pi -e 's/\"name\": \"${TEST_MARKETPLACE_NAME}\"/\"name\": \"${MARKETPLACE_NAME}\"/' '${MARKETPLACE_JSON}'" EXIT

echo "Adding marketplace natively..."
claude plugins marketplace add "${PROJECT_ROOT}"

echo "Verifying installation in Claude list output..."
if claude plugins marketplace list | grep -q "${TEST_MARKETPLACE_NAME}"; then
    echo "✅ Claude plugins marketplace successfully installed and listed!"
else
    echo "❌ Claude plugins marketplace failed to list '${TEST_MARKETPLACE_NAME}'"
    exit 1
fi

echo "🧪 Testing Claude individual plugin installation (data-analytics)..."
if claude plugins install data-analytics@${TEST_MARKETPLACE_NAME}; then
    echo "✅ Claude successfully installed the plugin 'data-analytics'!"
else
    echo "❌ Claude failed to install the plugin!"
    exit 1
fi

echo "🧪 Removing test plugin..."
claude plugins remove data-analytics > /dev/null 2>&1 || true

echo "🧪 Removing marketplace from Claude..."
claude plugins marketplace remove ${TEST_MARKETPLACE_NAME}

echo -e "\nAll tests successful!"
exit 0
