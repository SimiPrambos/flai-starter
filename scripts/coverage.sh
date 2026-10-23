#!/bin/sh
# Local coverage report: run gated tests, strip excluded files, build HTML.
# Opens the report only on macOS outside CI.
set -e

sh scripts/test.sh

lcov --remove coverage/lcov.info \
  '**/*.g.dart' '**/*.freezed.dart' \
  'lib/core/firebase/**' 'lib/core/theme/**' 'lib/core/storage/secure_storage.dart' \
  --ignore-errors unused,unused \
  -o coverage/lcov.info

genhtml coverage/lcov.info -o coverage/

if [ "$(uname)" = "Darwin" ] && [ "$CI" != "true" ]; then
  open coverage/index.html
else
  echo "📄 Coverage report: coverage/index.html"
fi
