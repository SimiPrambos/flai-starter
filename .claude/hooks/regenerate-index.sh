#!/usr/bin/env bash
# PostToolUse(Edit|Write): regenerate docs/features/INDEX.md from the YAML
# frontmatter of every docs/features/*/SPEC.md. INDEX.md is the team
# dashboard — never edit it by hand.
#
# Triggered only when the edited file is itself a SPEC.md (cheap no-op otherwise).
# Always exits 0 — never blocks tool execution.
set -euo pipefail

input=$(cat)

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")

project_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
relative_path="${file_path#${project_dir}/}"

# Only regenerate when a SPEC.md was the target.
[[ "$relative_path" =~ ^docs/features/[^/]+/SPEC\.md$ ]] || exit 0

features_dir="${project_dir}/docs/features"
index_file="${features_dir}/INDEX.md"

[[ -d "$features_dir" ]] || exit 0

{
  echo "# Features Index"
  echo ""
  echo "_Auto-generated from \`docs/features/*/SPEC.md\` frontmatter. Do not edit by hand._"
  echo ""
  echo "_Last regenerated: $(date -u +%Y-%m-%dT%H:%M:%SZ)_"
  echo ""
  echo "| Feature | Status | Owner | Branch | Last changed |"
  echo "|---|---|---|---|---|"
} > "$index_file"

shopt -s nullglob
for spec in "${features_dir}"/*/SPEC.md; do
  feature_dir=$(dirname "$spec")
  feature_basename=$(basename "$feature_dir")

  # Extract YAML frontmatter (between first and second --- lines).
  frontmatter=$(awk '/^---$/{c++; if(c==2) exit; next} c==1' "$spec")

  name=$(printf '%s\n' "$frontmatter" | sed -n 's/^name:[[:space:]]*//p' | head -1)
  status=$(printf '%s\n' "$frontmatter" | sed -n 's/^status:[[:space:]]*//p' | head -1)
  owner=$(printf '%s\n' "$frontmatter" | sed -n 's/^owner:[[:space:]]*//p' | head -1)
  branch=$(printf '%s\n' "$frontmatter" | sed -n 's/^branch:[[:space:]]*//p' | head -1)
  last_changed=$(printf '%s\n' "$frontmatter" | sed -n 's/^last_changed:[[:space:]]*//p' | head -1)

  echo "| ${name:-$feature_basename} | ${status:-?} | ${owner:-?} | ${branch:-?} | ${last_changed:-?} |" >> "$index_file"
done

exit 0
