#!/usr/bin/env bash
# Installs git and git-lfs

# Alex St. Amour
# 2018/10/15

echo "Updating git and installing Git LFS..."

sudo add-apt-repository -y ppa:git-core/ppa
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash

sudo apt-get install -y git git-lfs

git lfs install
