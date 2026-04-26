#!/bin/bash
# Init hook for the 'dev' distrobox
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

NVIM_VER="0.12.1"

add_vscode_repo
add_dotnet_repo
add_helm_repo
apt-get update
apt-get install -y code helm dotnet-sdk-10.0

install_nvim
install_kubectl
install_minikube