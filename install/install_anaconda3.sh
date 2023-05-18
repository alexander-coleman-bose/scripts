#!/usr/bin/env bash
# Installs Anaconda3 5.2.0

# Alex St. Amour
# 2018/10/15

echo "Installing Anaconda3..."

curl -O https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh
bash Anaconda3-5.2.0-Linux-x86_64.sh
rm Anaconda3-5.2.0-Linux-x86_64.sh
