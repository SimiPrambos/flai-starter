#!/bin/sh
# Build the development-flavor release APK and upload it to Firebase App
# Distribution. Mirrors the `android-dev` workflow in codemagic.yaml so the
# flow can be verified locally before relying on CI.
#
# Prerequisites (one-time):
#   - Firebase CLI:  npm install -g firebase-tools
#   - A Firebase service-account JSON with the "Firebase App Distribution
#     Admin" role, kept outside git
#   - Release signing via ANDROID_KEYSTORE_PATH / _ALIAS / _PASSWORD /
#     _PRIVATE_KEY_PASSWORD (read by android/app/build.gradle.kts; Codemagic
#     maps its CM_KEYSTORE_* variables to these)
#   - .env at the repo root (envied codegen reads it; Codemagic writes it from
#     BASE_URL / API_KEY)
#
# Configuration: export these, or set them in the gitignored
# scripts/.distribute.env (template: scripts/.distribute.env.example).
# Values in scripts/.distribute.env override exported ones.
#   FIREBASE_APP_ID                Firebase Android app id of the development flavor
#   FIREBASE_SERVICE_ACCOUNT_PATH  path to the service-account JSON
#   TESTER_GROUPS                  comma-separated App Distribution group aliases
#
# Usage:
#   sh scripts/distribute_android_dev.sh
set -e

echo "[1/5] distribute_android_dev.sh starting..."

# Always run from the repo root, regardless of where the script is invoked.
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
cd "$REPO_ROOT"
echo "Working dir: $REPO_ROOT"

if [ -f "$SCRIPT_DIR/.distribute.env" ]; then
  echo "Loading scripts/.distribute.env"
  set -a
  # shellcheck disable=SC1091
  . "$SCRIPT_DIR/.distribute.env"
  set +a
fi

# Required configuration — no defaults.
MISSING=""
for var in FIREBASE_APP_ID FIREBASE_SERVICE_ACCOUNT_PATH TESTER_GROUPS; do
  eval "value=\${$var:-}"
  [ -n "$value" ] || MISSING="$MISSING $var"
done
if [ -n "$MISSING" ]; then
  echo "ERROR: missing required environment variables:"
  for var in $MISSING; do echo "   $var"; done
  echo "Export them or set them in scripts/.distribute.env (template: scripts/.distribute.env.example)."
  exit 1
fi

APK_PATH="build/app/outputs/flutter-apk/app-development-release.apk"
RELEASE_NOTES="Local dev build $(date '+%Y-%m-%d %H:%M')"

# Sanity checks
command -v firebase >/dev/null 2>&1 || { echo "ERROR: Firebase CLI not found. Install: npm install -g firebase-tools"; exit 1; }
command -v flutter >/dev/null 2>&1 || { echo "ERROR: flutter not found in PATH."; exit 1; }
[ -f "$FIREBASE_SERVICE_ACCOUNT_PATH" ] || { echo "ERROR: $FIREBASE_SERVICE_ACCOUNT_PATH not found."; exit 1; }
[ -f ".env" ] || { echo "ERROR: .env not found at repo root (needed for envied codegen)."; exit 1; }

echo "[2/5] flutter pub get..."
flutter pub get

echo "[3/5] build_runner (envied/freezed/riverpod/retrofit/go_router)..."
dart run build_runner build --delete-conflicting-outputs

echo "[4/5] Building development release APK..."
flutter build apk --release --flavor development --target lib/main_development.dart
[ -f "$APK_PATH" ] || { echo "ERROR: APK not found at $APK_PATH"; exit 1; }

echo "[5/5] Uploading to Firebase App Distribution (groups: $TESTER_GROUPS)..."
export GOOGLE_APPLICATION_CREDENTIALS="$FIREBASE_SERVICE_ACCOUNT_PATH"
firebase appdistribution:distribute "$APK_PATH" \
  --app "$FIREBASE_APP_ID" \
  --groups "$TESTER_GROUPS" \
  --release-notes "$RELEASE_NOTES"

echo "Done. Check Firebase Console -> App Distribution -> Releases."
