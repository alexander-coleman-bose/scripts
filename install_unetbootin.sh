#!/usr/bin/env bash
# Installs unetbootin

# Alex Coleman
# 2018/10/16

echo "Installing unetbootin..."

sudo add-apt-repository -y ppa:gezakovacs/ppa
sudo apt-get update
sudo apt-get install -y install unetbootin
