#!/usr/bin/env bash
# Install certbot
# https://certbot.eff.org/lets-encrypt/ubuntubionic-other

sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt update
sudo apt install certbot
