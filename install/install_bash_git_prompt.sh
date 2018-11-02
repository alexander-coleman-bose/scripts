#!/usr/bin/env bash
# Installs custom bash git prompt

# Alex Coleman
# 2018/10/15

echo "Installing a custom git prompt (magicmonty/bash-git-prompt)"

# Install (clone) bash-git-prompt
git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1

# Append bash-git-prompt config to .bashrc?
if [ -z "$1" ]; then
    read -p "Apply bash-git-prompt now (append to .bashrc)? (Y/n)" choice
    if [ -z "$choice" ]; then choice=y; fi
elif [ "$1" == "-h" ] || "$1" == "--help" ]
    echo "Usage: install_bash_git_prompt.sh [OPTIONS]"
    echo ""
    echo "This script installs the github.com/magicmonty/bash-git-prompt project."
    echo "  OPTIONS:"
    echo "    -h | --help  Displays this help"
    echo "    -y           Automatically source this project in .bashrc"
    echo ""
else
    choice="$1"
fi

if [ "$choice" == "-y" ] || [ "$choice" == "y" ] || [ "$choice" == "Y" ] || [ "$choice" == "yes" ]; then
    choice=y
fi

if [ "$choice" == "y" ]; then
    echo -e "\n" >> ~/.bashrc
    echo "# Appended by magicmonty/bash-git-prompt" >> ~/.bashrc
    echo "GIT_PROMPT_ONLY_IN_REPO=1" >> ~/.bashrc
    echo "source ~/.bash-git-prompt/gitprompt.sh" >> ~/.bashrc
fi
