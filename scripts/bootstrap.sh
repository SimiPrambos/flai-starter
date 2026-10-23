#!/bin/sh
set -e

echo "🔧 Running post-bootstrap setup..."

# On CI skip dev-only tooling: git hooks, GitNexus, RTK.
if [ "$CI" = "true" ]; then
  echo "🤖 CI detected — skipping git hooks, GitNexus and RTK setup."
  echo "✅ Setup complete. Ready to build!"
  exit 0
fi

# Git hooks
git config core.hooksPath .githooks
echo "✅ Git hooks activated"

# GitNexus
if ! npx gitnexus --version > /dev/null 2>&1; then
  echo "📦 Installing GitNexus..."
  npm install -g gitnexus
  npx gitnexus analyze --index-only
else
  echo "✅ GitNexus already installed"
fi

# RTK
if ! rtk --version > /dev/null 2>&1; then
  echo "📦 Installing RTK..."
  curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
else
  echo "✅ RTK already installed"
fi

echo ""
echo "✅ Setup complete. Ready to code!"
