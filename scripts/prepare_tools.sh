#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.. " || exit 1

echo "=== Preparing tools ==="

# Check if config exists
if [ ! -f "config/config.toml" ]; then
    if [ -f "config/config.toml.example" ]; then
        echo "[INFO] config/config.toml not found. Copying from example..."
        cp config/config.toml.example config/config.toml
        echo "[ERROR] Please edit config/config.toml with your tools.zip URL and run the script again."
        exit 1
    else
        echo "[ERROR] config/config.toml not found" >&2
        exit 1
    fi
fi

# Read tools_zip_url from config using grep
TOOLS_ZIP_URL=$(grep '^tools_zip_url\s*=' config/config.toml | head -1 | cut -d'=' -f2 | xargs)

if [ -z "$TOOLS_ZIP_URL" ] || [ "$TOOLS_ZIP_URL" = "https://example.com/tools.zip" ]; then
    echo "[ERROR] tools_zip_url not set or still using example URL in config/config.toml" >&2
    exit 1
fi

# Download and extract
echo "[INFO] Downloading tools from: $TOOLS_ZIP_URL"
wget -q --show-progress -O /tmp/tools.zip "$TOOLS_ZIP_URL"
echo "[INFO] Extracting tools..."
unzip -q -o /tmp/tools.zip
rm /tmp/tools.zip

echo "[INFO] ✓ Tools prepared successfully"
