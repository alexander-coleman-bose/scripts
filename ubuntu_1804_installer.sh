#!/bin/bash
# Installs Alex's custom Ubuntu setup from standard PREQ5 image

install_git () {
    if [ -z $(which git) ] || [ -z $(which git-lfs) ]; then
        bash install/install_git.sh
    else
        echo "Git and Git LFS are already instaleld."
    fi
}

install_miniconda3 () {
    if [ -z $(which conda) ]; then
        bash install/install_miniconda3.sh
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
    if [ -z $(which docker) ]; then
        bash install/install_docker.sh
    else
        echo "Docker already installed."
    fi
}

install_vscode () {
    if [ -z $(which code) ]; then
        bash install/install_vscode.sh
    else
        echo "VS Code already installed."
    fi
}

# Choose what to install:
echo "Install Git/Git LFS? (Y/n)"
read choice
if [ -z $choice ]; then choice=y; fi
if [ "$choice" == "y" ]; then install_git; fi

echo "Install Miniconda3? (Y/n)"
read choice
if [ -z $choice ]; then choice=y; fi
if [ "$choice" == "y" ]; then install_git; fi

echo "Install Git Bash Prompt? (Y/n)"
read choice
if [ -z $choice ]; then choice=y; fi
if [ "$choice" == "y" ]; then install_git; fi

echo "Install Docker? (Y/n)"
read choice
if [ -z $choice ]; then choice=y; fi
if [ "$choice" == "y" ]; then install_git; fi

echo "Install VS Code? (Y/n)"
read choice
if [ -z $choice ]; then choice=y; fi
if [ "$choice" == "y" ]; then install_git; fi
