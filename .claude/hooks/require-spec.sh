#!/usr/bin/env bash
# PreToolUse(Edit|Write|NotebookEdit): block edits to lib/features/<name>/ when
# docs/features/<name>/SPEC.md is missing. Forces feature work to follow the
# spec-first contract defined in .claude/skills/feature-spec/SKILL.md.
#
# Exit codes:
#   0 = allow
#   2 = block (stderr surfaced to the model)
#
# Bypass for genuine emergencies only:
#   GOVERNANCE_BYPASS=1
set -euo pipefail

[[ "${GOVERNANCE_BYPASS:-}" == "1" ]] && exit 0

input=$(cat)

# Best-effort parse — if jq is missing or input is not JSON, skip gracefully.
if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")
[[ -z "$file_path" ]] && exit 0

project_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
relative_path="${file_path#${project_dir}/}"

# Only gate writes into lib/features/<name>/...
if [[ "$relative_path" =~ ^lib/features/([^/]+)/ ]]; then
  feature_name="${BASH_REMATCH[1]}"
  spec_path="${project_dir}/docs/features/${feature_name}/SPEC.md"
  if [[ ! -f "$spec_path" ]]; then
    cat >&2 <<EOF
[governance] BLOCKED — no SPEC.md for feature "${feature_name}"

Edit attempted on: ${relative_path}
Missing spec at:   docs/features/${feature_name}/SPEC.md

Required before any code in this feature:
  1. superpowers:brainstorming  → gather intent, user stories, BDD scenarios
  2. feature-spec               → SPEC.md schema (frontmatter + sections)
  3. Write docs/features/${feature_name}/SPEC.md (with YAML frontmatter)
  4. Create docs/features/${feature_name}/CHANGELOG.md

Emergency bypass (audited): GOVERNANCE_BYPASS=1
EOF
    exit 2
  fi
fi

exit 0
