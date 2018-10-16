#!/bin/bash
# Installs Alex's custom PREQ setup from standard PREQ5 image

# Alex Coleman
# 2018/10/16

# Check for argument to force the installation
ARG1=$1
if [ "$ARG1" = "-f" ] || [ "$ARG1" = "--force" ]
then
    FORCE_FLAG=true
else
    FORCE_FLAG=false
fi

# Store the original directory to return to later
cwd=$(pwd)
cd /tmp

# GIT LFS & Git upgrade
if [ "$FORCE_FLAG" = "false" ] && git-lfs --version > /dev/null
then
    echo "git-lfs is already installed: $(git-lfs --version)"
else
    bash install_git.sh
fi

# Git config options & aliases
bash git_aliases.sh

# Anaconda3
ANACONDA_DIR=~/anaconda3
if [ "$FORCE_FLAG" = "false" ] && [ -d $ANACONDA_DIR ]
then
    echo "Anaconda3 is already installed"
    echo "anaconda version: $(anaconda --version)"
    echo "conda version: $(conda --version)"
    echo "Current python3: $(which python3)"
else
    bash install_anaconda3.sh
fi

# Visual Studio Code
if [ "$FORCE_FLAG" = "false" ] && code --version > /dev/null
then
    echo "VS Code is already installed: $(code --version)"
else
    bash install_vscode.sh
fi

# Add Intel/Realtek sound cards to devices
if [ "$FORCE_FLAG" = "false" ] && cat /etc/modules | grep snd-hda-intel
then
    echo "snd-hda-intel was already added to the /etc/modules list"
else
    echo "Adding snd-hda-intel to the module list"
    sudo sh -c 'echo "snd-hda-intel" >> /etc/modules'
fi

# Install magicmonty/bash-git-prompt
if [ "$FORCE_FLAG" = "false" ] && [ -d ~/.bash-git-prompt ]
then
    echo "magicmonty/bash-git-prompt already installed"
else
    bash install_bash_git_prompt.sh
fi

# Return to the original directory
cd $cwd
