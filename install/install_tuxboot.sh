#!/usr/bin/env bash
# Installs tuxboot

# Alex St. Amour
# 2018/10/16

echo "Installing tuxboot..."

sudo add-apt-repository -y ppa:thomas.tsai/ubuntu-tuxboot
sudo apt-get update
sudo apt-get install -y tuxboot
