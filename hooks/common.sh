#!/bin/bash
# Common setup
set -euo pipefail

add_vscode_repo() {
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
        | gpg --dearmor > /usr/share/keyrings/packages.microsoft.gpg
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main' \
        > /etc/apt/sources.list.d/vscode.list
}

add_dotnet_repo() {
    wget -qO /tmp/packages-microsoft-prod.deb \
        https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb
    dpkg -i /tmp/packages-microsoft-prod.deb
    rm /tmp/packages-microsoft-prod.deb
}

add_helm_repo() {
    sudo apt-get install curl gpg apt-transport-https --yes
    curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
}

install_nvim() {
    # Neovim: apt ships an old version, so pull the prebuilt tarball
    wget -qO /tmp/nvim.tar.gz \
        "https://github.com/neovim/neovim/releases/download/v${NVIM_VER:-0.12.1}/nvim-linux-x86_64.tar.gz"
    tar -C /opt -xzf /tmp/nvim.tar.gz
    rm /tmp/nvim.tar.gz
    ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
}

install_kubectl() {
    # kubectl: apt ships an old version, so pull the binary
    local KUBE_LATEST=$(curl -sSL https://dl.k8s.io/release/stable.txt)
    wget -qO /usr/local/bin/kubectl \
        "https://dl.k8s.io/release/${KUBE_LATEST}/bin/linux/amd64/kubectl"
    chmod +x /usr/local/bin/kubectl
}

install_minikube() {
    curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
    install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
}

install_talosctl() {
    curl -sL https://talos.dev/install | sh
}

install_pulumi() {
    curl -fsSL https://get.pulumi.com | sh
}

install_godot() {
    # Download and install Godot .NET
    wget -qO /tmp/godot.zip \
        "https://github.com/godotengine/godot/releases/download/${GODOT_VER}-stable/Godot_v${GODOT_VER}-stable_mono_linux_x86_64.zip"
    unzip -o /tmp/godot.zip -d /opt/godot
    rm /tmp/godot.zip
    ln -sf "/opt/godot/Godot_v${GODOT_VER}-stable_mono_linux_x86_64/Godot_v${GODOT_VER}-stable_mono_linux.x86_64" \
        /usr/local/bin/godot

    # Icon and desktop entry for export
    wget -qO /usr/share/icons/godot.svg \
        "https://raw.githubusercontent.com/godotengine/godot/${GODOT_VER}-stable/icon.svg"
    cat > /usr/share/applications/godot.desktop <<EOF
[Desktop Entry]
Name=Godot Engine
Comment=Godot Engine ${GODOT_VER} (.NET)
Exec=/usr/local/bin/godot %U
Icon=/usr/share/icons/godot.svg
Type=Application
Categories=Development;IDE;
Terminal=false
EOF
}