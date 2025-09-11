#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="$HOME/nixos-config"
TARGET="/etc/nixos"

# Figure out host: use arg if provided, else use system hostname
if [ $# -gt 0 ]; then
  HOSTNAME="$1"
else
  HOSTNAME=$(hostname)
  if [ "$HOSTNAME" = "nixos" ]; then
    echo "⚠️  Hostname is still 'nixos'."
    echo "👉 Please run: $0 <hostname>  (on first setup)"
    exit 1
  fi
fi

sudo rm -rf "$TARGET"
sudo ln -s "$CONFIG_DIR" "$TARGET"

echo "✅ Symlinked $CONFIG_DIR -> $TARGET"
echo "🔧 Building system for host: $HOSTNAME"

sudo nixos-rebuild switch --flake "$CONFIG_DIR#$HOSTNAME"

