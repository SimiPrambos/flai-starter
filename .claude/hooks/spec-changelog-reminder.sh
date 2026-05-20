#!/usr/bin/env bash
# PostToolUse(Edit|Write): when a SPEC.md is modified, emit a reminder to
# update the matching CHANGELOG.md and bump frontmatter `last_changed`.
# Non-blocking — always exits 0.
set -euo pipefail

input=$(cat)

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")

project_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
relative_path="${file_path#${project_dir}/}"

if [[ "$relative_path" =~ ^docs/features/([^/]+)/SPEC\.md$ ]]; then
  feature_name="${BASH_REMATCH[1]}"
  today=$(date +%Y-%m-%d)
  cat >&2 <<EOF
[governance reminder] SPEC.md changed for feature "${feature_name}"

Required follow-ups:
  - Append a block to docs/features/${feature_name}/CHANGELOG.md describing what changed and why
  - If entity / API / UI states moved, bump frontmatter status accordingly (draft → in-progress → review → shipped)
  - Set frontmatter last_changed: ${today}
  - INDEX.md regenerates automatically — do not edit it by hand
EOF
fi

exit 0
