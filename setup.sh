#!/bin/bash
# Reproducible distrobox setup for Kinoite
# Usage: ./setup.sh [--replace]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INI_FILE="$SCRIPT_DIR/distrobox.ini"
export DISTROBOX_HOOKS_DIR="$SCRIPT_DIR/hooks"

assemble() {
    distrobox assemble "$1" --file "$INI_FILE"
}

if [[ "${1:-}" == "--replace" ]]; then
    echo "Removing existing containers..."
    assemble rm
    echo ""
fi

echo "Creating distroboxes..."
assemble create

echo ""
distrobox list

echo ""
echo "Exporting apps to host..."
distrobox enter dev -- distrobox-export --app code --export-label Dev
distrobox enter godot -- distrobox-export --app code --export-label Godot
distrobox enter godot -- distrobox-export --app godot --export-label Godot
