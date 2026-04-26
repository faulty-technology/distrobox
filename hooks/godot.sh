#!/bin/bash
# Init hook for the 'godot' distrobox
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

GODOT_VER="4.6.2"

# Add repos and install everything in one pass
add_vscode_repo
add_dotnet_repo
apt-get update
apt-get install -y code dotnet-sdk-10.0

install_godot
