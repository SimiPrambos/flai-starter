#!/usr/bin/env bash
# Stop hook: block claimed-done when `flutter analyze` or `flutter test` fails.
# Only runs verification if there are uncommitted changes under lib/ or test/.
# Skips silently if flutter is not installed (e.g. CI container without SDK).
#
# Exit codes:
#   0 = allow stop
#   2 = block stop (stderr surfaced to the model)
#
# Bypass for genuine emergencies only:
#   GOVERNANCE_BYPASS=1
set -euo pipefail

[[ "${GOVERNANCE_BYPASS:-}" == "1" ]] && exit 0

project_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$project_dir"

# Skip if flutter is not available.
if ! command -v flutter >/dev/null 2>&1; then
  exit 0
fi

# Skip if there are no relevant uncommitted changes (tracked or untracked).
has_changes=0
if git diff --name-only HEAD 2>/dev/null | grep -qE "^(lib|test)/"; then
  has_changes=1
elif git ls-files --others --exclude-standard 2>/dev/null | grep -qE "^(lib|test)/"; then
  has_changes=1
fi
[[ "$has_changes" -eq 0 ]] && exit 0

log_dir="${TMPDIR:-/tmp}"

# 1. flutter analyze
if ! flutter analyze --no-fatal-warnings >"${log_dir}/governance-analyze.log" 2>&1; then
  cat >&2 <<EOF
[governance] BLOCKED — flutter analyze failed

$(tail -30 "${log_dir}/governance-analyze.log")

Fix analyzer errors before claiming the task is done.
Full log: ${log_dir}/governance-analyze.log
Emergency bypass: GOVERNANCE_BYPASS=1
EOF
  exit 2
fi

# 2. flutter test
if ! flutter test >"${log_dir}/governance-test.log" 2>&1; then
  cat >&2 <<EOF
[governance] BLOCKED — flutter test failed

$(tail -50 "${log_dir}/governance-test.log")

Fix failing tests before claiming the task is done.
Full log: ${log_dir}/governance-test.log
Emergency bypass: GOVERNANCE_BYPASS=1
EOF
  exit 2
fi

exit 0
