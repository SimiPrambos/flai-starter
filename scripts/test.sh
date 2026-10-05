#!/bin/sh
# Canonical coverage-gated test run. Used by `melos test`, `melos coverage`
# and GitLab CI. Keep COVERAGE_EXCLUDES in sync with .github/workflows/main.yaml.
set -e

COVERAGE_EXCLUDES="**/*.g.dart **/*.freezed.dart lib/core/firebase/** lib/core/theme/** lib/core/storage/secure_storage.dart"

very_good test \
  -j 4 \
  --optimization \
  --coverage \
  --min-coverage 85 \
  --exclude-coverage "$COVERAGE_EXCLUDES" \
  --report-on "lib" \
  --show-uncovered \
  --test-randomize-ordering-seed random
