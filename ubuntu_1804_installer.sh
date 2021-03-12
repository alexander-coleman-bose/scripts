#!/bin/bash
# Installs Alex's custom Ubuntu setup for Ubuntu 18.04

# Handle -y input
if [ "$1" == "-y" ]; then
    YES=true
fi

upgrade_packages () {
    sudo apt update
    sudo apt upgrade -y
}

PACKAGES="net-utils ssh curl gparted cifs-utils nmap nfs-common htop npm"
install_packages () {
    sudo apt update
    sudo apt install -y "$PACKAGES"
}

install_git () {
    if [ -z "$(which git)" ] || [ -z "$(which git-lfs)" ]; then
        bash install/install_git.sh
    else
        echo "Git and Git LFS are already installed."
    fi
}

install_miniconda3 () {
    if [ -z "$(which conda)" ]; then
        sudo bash install/install_miniconda3.sh
    else
        echo "Anaconda/Miniconda is already installed."
    fi
}

install_bash_git_prompt () {
    if [ ! -d ~/.bash-git-prompt ]; then
        bash install/install_bash_git_prompt.sh
    else
        echo "Bash Git Prompt is already installed."
    fi
}

install_docker () {
    if [ -z "$(which docker)" ]; then
        bash install/install_docker.sh
    else
        echo "Docker already installed."
    fi
}

install_vscode () {
    if [ -z "$(which code)" ]; then
        bash install/install_vscode.sh
    else
        echo "VS Code already installed."
    fi
}

install_wireshark () {
    if [ -z "$(which wireshark)" ]; then
        sudo apt update
        sudo apt install -y wireshark
        sudo dpkg-reconfigure wireshark-common
    else
        echo "wireshark already installed."
    fi
}

# Choose what to install:
if [ "$YES" != "true" ]; then
    echo "Upgrade all packages? (Y/n)"
    read -r choice
    if [ -z "$choice" ]; then choice=y; fi
else
    choice="y"
fi
if [ "$choice" == "y" ]; then upgrade_packages; fi

if [ "$YES" != "true" ]; then
    echo "Install recommended packages? (Y/n)"
    echo "($PACKAGES)"
    read -r choice
    if [ -z "$choice" ]; then choice=y; fi
else
    choice="y"
fi
if [ "$choice" == "y" ]; then install_packages; fi

if [ "$YES" != "true" ]; then
    echo "Install Git/Git LFS? (Y/n)"
    read -r choice
    if [ -z "$choice" ]; then choice=y; fi
else
    choice="y"
fi
if [ "$choice" == "y" ]; then install_git; fi

if [ "$YES" != "true" ]; then
    echo "Add extra Git aliases? (Y/n)"
    read -r choice
    if [ -z "$choice" ]; then choice=y; fi
else
    choice="y"
fi
if [ "$choice" == "y" ]; then bash git_aliases.sh; fi

if [ "$YES" != "true" ]; then
    echo "Install Miniconda3? (Y/n)"
    read -r choice
    if [ -z "$choice" ]; then choice=y; fi
else
    choice="y"
fi
if [ "$choice" == "y" ]; then install_miniconda3; fi

if [ "$YES" != "true" ]; then
    echo "Install Bash Git Prompt? (Y/n)"
    read -r choice
    if [ -z "$choice" ]; then choice=y; fi
else
    choice="y"
fi
if [ "$choice" == "y" ]; then install_bash_git_prompt; fi

if [ "$YES" != "true" ]; then
    echo "Install Docker? (Y/n)"
    read -r choice
    if [ -z "$choice" ]; then choice=y; fi
else
    choice="y"
fi
if [ "$choice" == "y" ]; then install_docker; fi

if [ "$YES" != "true" ]; then
    echo "Install VS Code? (Y/n)"
    read -r choice
    if [ -z "$choice" ]; then choice=y; fi
else
    choice="y"
fi
if [ "$choice" == "y" ]; then install_vscode; fi

if [ "$YES" != "true" ]; then
    echo "Install Wireshark? (Y/n)"
    read -r choice
    if [ -z "$choice" ]; then choice=y; fi
else
    choice="y"
fi
if [ "$choice" == "y" ]; then install_wireshark; fi
