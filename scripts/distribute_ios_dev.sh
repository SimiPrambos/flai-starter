#!/bin/sh
# Build the development-flavor IPA and upload it to TestFlight. Mirrors the
# `ios-dev` workflow in codemagic.yaml so the flow can be verified locally.
#
# iOS needs App Store Connect API credentials both to create signing files and
# to upload the build.
#
# Prerequisites (one-time):
#   - codemagic-cli-tools:  pip3 install codemagic-cli-tools
#     (provides app-store-connect, keychain and xcode-project)
#   - An App Store Connect API key (.p8). Apple lets you download it once; if
#     it is lost, create a new key in App Store Connect -> Users and Access ->
#     Integrations.
#   - An RSA key for the distribution certificate:
#       ssh-keygen -t rsa -b 2048 -m PEM -f ~/ios_distribution_private_key -q -N ""
#   - .env at the repo root (envied codegen reads it; Codemagic writes it from
#     BASE_URL / API_KEY)
#
# Configuration: export these, or set them in the gitignored
# scripts/.distribute.env (template: scripts/.distribute.env.example).
# Values in scripts/.distribute.env override exported ones.
#   BUNDLE_ID       development bundle id registered in App Store Connect
#                   (same value as <IOS_DEV_BUNDLE_ID> in codemagic.yaml)
#   ASC_KEY_ID      App Store Connect API key id
#   ASC_ISSUER_ID   App Store Connect issuer id (UUID)
#   ASC_P8_PATH     path to the AuthKey_<ASC_KEY_ID>.p8 file
# Optional:
#   BETA_GROUP      TestFlight beta group to distribute to after upload
#   CERT_KEY_PATH   RSA key path (default: ~/ios_distribution_private_key)
#
# Usage:
#   sh scripts/distribute_ios_dev.sh
set -e

echo "[1/7] distribute_ios_dev.sh starting..."

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
for var in BUNDLE_ID ASC_KEY_ID ASC_ISSUER_ID ASC_P8_PATH; do
  eval "value=\${$var:-}"
  [ -n "$value" ] || MISSING="$MISSING $var"
done
if [ -n "$MISSING" ]; then
  echo "ERROR: missing required environment variables:"
  for var in $MISSING; do echo "   $var"; done
  echo "Export them or set them in scripts/.distribute.env (template: scripts/.distribute.env.example)."
  exit 1
fi

CERT_KEY_PATH="${CERT_KEY_PATH:-$HOME/ios_distribution_private_key}"
EXPORT_OPTIONS="$HOME/export_options.plist"

# Sanity checks
command -v app-store-connect >/dev/null 2>&1 || { echo "ERROR: codemagic-cli-tools not found. Install: pip3 install codemagic-cli-tools"; exit 1; }
command -v flutter >/dev/null 2>&1 || { echo "ERROR: flutter not found in PATH."; exit 1; }
[ -f "$ASC_P8_PATH" ] || { echo "ERROR: $ASC_P8_PATH not found (the AuthKey_*.p8)."; exit 1; }
[ -f "$CERT_KEY_PATH" ] || { echo "ERROR: $CERT_KEY_PATH missing. Generate: ssh-keygen -t rsa -b 2048 -m PEM -f $CERT_KEY_PATH -q -N ''"; exit 1; }
[ -f ".env" ] || { echo "ERROR: .env not found at repo root."; exit 1; }

# Credentials picked up automatically by app-store-connect / fetch-signing-files
export APP_STORE_CONNECT_KEY_IDENTIFIER="$ASC_KEY_ID"
export APP_STORE_CONNECT_ISSUER_ID="$ASC_ISSUER_ID"
APP_STORE_CONNECT_PRIVATE_KEY="$(cat "$ASC_P8_PATH")"
export APP_STORE_CONNECT_PRIVATE_KEY
CERTIFICATE_PRIVATE_KEY="$(cat "$CERT_KEY_PATH")"
export CERTIFICATE_PRIVATE_KEY

echo "[2/7] Initialize keychain + fetch/create signing files..."
keychain initialize
app-store-connect fetch-signing-files "$BUNDLE_ID" --type IOS_APP_STORE --create
keychain add-certificates
xcode-project use-profiles --export-options-plist "$EXPORT_OPTIONS"

echo "[3/7] flutter pub get..."
flutter pub get

echo "[4/7] build_runner (envied/freezed/riverpod/retrofit/go_router)..."
dart run build_runner build --delete-conflicting-outputs

echo "[5/7] Building development IPA..."
flutter build ipa --release \
  --flavor development \
  --target lib/main_development.dart \
  --export-options-plist="$EXPORT_OPTIONS"

echo "[6/7] Locating IPA..."
IPA=$(ls build/ios/ipa/*.ipa 2>/dev/null | head -1)
[ -n "$IPA" ] || { echo "ERROR: no .ipa found in build/ios/ipa/"; exit 1; }
echo "IPA: $IPA"

if [ -n "${BETA_GROUP:-}" ]; then
  echo "[7/7] Uploading to TestFlight (beta group: $BETA_GROUP)..."
  app-store-connect publish --path "$IPA" --testflight --beta-group "$BETA_GROUP"
else
  echo "[7/7] Uploading to TestFlight (no beta group)..."
  app-store-connect publish --path "$IPA" --testflight
fi

echo "Done. Check App Store Connect -> TestFlight (processing may take minutes)."
