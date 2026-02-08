#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.." || exit 1

echo "=== Running score visualizer ==="

# Check prerequisites
if [ ! -d "score_visualizer" ]; then
    echo "[ERROR] score_visualizer directory not found."
    echo "Run: bash scripts/setup.sh" >&2
    exit 1
fi

if [ ! -f "config/config.toml" ]; then
    echo "[ERROR] config/config.toml not found."
    echo "Run: bash scripts/setup.sh" >&2
    exit 1
fi

if [ ! -d "tools" ] || [ -z "$(ls -A tools 2>/dev/null || true)" ]; then
    echo "[INFO] tools directory not found. Running prepare_tools.sh..."
    bash scripts/prepare_tools.sh
fi

echo "[INFO] Building score_visualizer..."
cargo build --release --manifest-path score_visualizer/Cargo.toml

echo "[INFO] Running visualizer..."
./score_visualizer/target/release/score_visualizer --config config/config.toml
