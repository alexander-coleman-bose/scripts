#!/usr/bin/env bash
# Installs Visual Studio Code

# Alex St. Amour
# 2018/10/15

echo "Installing VS Code..."

# Install VS Code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update
sudo apt-get install -y code

# Install extensions and configure
code --install-extension shan.code-settings-sync
