#!/bin/sh
set -e

echo "🔧 Running post-bootstrap setup..."

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
  npm install -g @rtk/cli
else
  echo "✅ RTK already installed"
fi

echo ""
echo "✅ Setup complete. Ready to code!"
