#!/usr/bin/env bash
set -e

PLASMOID_DIR="$HOME/.local/share/plasma/plasmoids/org.deepseek.status"
BIN_DIR="$HOME/.local/bin"

echo "==> Installing DeepSeek Status Plasmoid..."
mkdir -p "$PLASMOID_DIR"
cp -r org.deepseek.status/* "$PLASMOID_DIR/"

echo "==> Installing Python script to $BIN_DIR..."
mkdir -p "$BIN_DIR"
cp bin/deepseek_status.py "$BIN_DIR/"
chmod +x "$BIN_DIR/deepseek_status.py"

echo "==> Reloading Plasma cache..."
rm -rf "$HOME/.cache/plasma*" 2>/dev/null || true

echo "Done! Add 'DeepSeek Status' to your panel via Add Widgets."
