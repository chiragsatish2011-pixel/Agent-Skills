#!/usr/bin/env bash
# Antigravity & Claude Code Portable Skill Pack Installer (Linux / macOS / WSL)
set -e

SCOPE="${1:-global}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================================="
echo " 🚀 Antigravity & AI Agent Skills - Portable Installer    "
echo "=========================================================="

if [ "$SCOPE" = "global" ]; then
    DEST_DIR="$HOME/.gemini/config/skills"
    PLUGIN_DIR="$HOME/.gemini/config/plugins"
else
    DEST_DIR="$(pwd)/.agents/skills"
    PLUGIN_DIR="$(pwd)/.agents/plugins"
fi

echo "Target Installation Path: $DEST_DIR"
mkdir -p "$DEST_DIR"

CATEGORIES=(
    "01-Productivity-and-Planning"
    "02-Memory-and-Knowledge"
    "03-Code-Quality-and-Review"
    "04-Design-and-Frontend"
    "05-Developer-Tools-and-Infra"
    "06-Fullstack-and-Replica"
    "07-Stitch-and-Creative"
)

TOTAL=0

for cat in "${CATEGORIES[@]}"; do
    CAT_PATH="$SCRIPT_DIR/$cat"
    if [ -d "$CAT_PATH" ]; then
        echo -e "\n📦 Installing Category: $cat"
        for skill in "$CAT_PATH"/*; do
            if [ -d "$skill" ]; then
                sname="$(basename "$skill")"
                rm -rf "$DEST_DIR/$sname"
                cp -R "$skill" "$DEST_DIR/"
                echo "  ✔ $sname"
                TOTAL=$((TOTAL + 1))
            fi
        done
    fi
done

if [ "$SCOPE" = "global" ] && [ -d "$SCRIPT_DIR/08-Plugins-and-Bundles" ]; then
    echo -e "\n🔌 Installing Plugins into $PLUGIN_DIR..."
    mkdir -p "$PLUGIN_DIR"
    for plug in "$SCRIPT_DIR/08-Plugins-and-Bundles"/*; do
        if [ -d "$plug" ]; then
            pname="$(basename "$plug")"
            rm -rf "$PLUGIN_DIR/$pname"
            cp -R "$plug" "$PLUGIN_DIR/"
            echo "  ✔ Plugin: $pname"
        fi
    done
fi

echo "=========================================================="
echo " ✨ Installation Complete! $TOTAL Skills Installed."
echo "=========================================================="
