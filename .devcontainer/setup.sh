#!/bin/bash
set -e

echo "========================================="
echo " Open WebUI - Codespace Setup"
echo "========================================="

# Copy .env.example to .env if .env doesn't exist
if [ ! -f .env ]; then
  echo ">>> Creating .env from .env.example..."
  cp .env.example .env
  echo ">>> Edit .env to add your API keys before starting!"
fi

echo ""
echo "========================================="
echo " Setup complete!"
echo ""
echo " Next steps:"
echo "   1. Edit .env and add your API keys"
echo "   2. Run one of:"
echo "      ./scripts/start-external.sh   (API keys only, no Ollama)"
echo "      ./scripts/start-with-ollama.sh (API keys + local models)"
echo "========================================="
