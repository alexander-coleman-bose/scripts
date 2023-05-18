#!/usr/bin/env bash
# Installs grub-customizer

# Alex St. Amour
# 2018/10/15

echo "Installing grub-customizer..."
sudo add-apt-repository -y ppa:danielrichter2007/grub-customizer
sudo apt-get update
sudo apt-get install -y grub-customizer
