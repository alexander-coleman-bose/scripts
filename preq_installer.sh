#!/bin/bash
# Installs Alex's custom PREQ setup from standard PREQ5 image

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
    echo "Updating git and installing Git LFS..."

    sudo add-apt-repository -y ppa:git-core/ppa
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
    sudo apt-get install -y --only-upgrade git
    sudo apt-get install -y git-lfs
    git lfs install
fi

# Git config options & aliases
# git config --global submodule.recurse true
# git config --global core.editor 'code --wait'
git config --global --replace-all alias.aa 'add -A .'
git config --global --replace-all alias.br 'branch'
git config --global --replace-all alias.bra 'branch -a'
git config --global --replace-all alias.brd 'branch -d'
git config --global --replace-all alias.brD 'branch -D'
git config --global --replace-all alias.brm 'branch --merged'
git config --global --replace-all alias.cam 'commit -am'
git config --global --replace-all alias.cloneall 'clone --recurse-submodules'
git config --global --replace-all alias.cm 'commit -m'
git config --global --replace-all alias.co 'checkout'
git config --global --replace-all alias.cob 'checkout -b'
git config --global --replace-all alias.coo '!git fetch && git checkout'
git config --global --replace-all alias.dev '!git checkout dev && git pull origin dev'
git config --global --replace-all alias.staging '!git checkout staging && pull origin staging'
git config --global --replace-all alias.master '!git checkout master && git pull origin master'
git config --global --replace-all alias.find '!git ls-files | grep -i'
git config --global --replace-all alias.grep 'grep -Ii'
git config --global --replace-all alias.la '!git config -l | grep alias | cut -c 7-'
git config --global --replace-all alias.ls 'log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate'
git config --global --replace-all alias.ll 'log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'
git config --global --replace-all alias.po 'push origin'
git config --global --replace-all alias.pod 'push origin dev'
git config --global --replace-all alias.pos 'push origin staging'
git config --global --replace-all alias.pom 'push origin master'
git config --global --replace-all alias.poh 'push origin HEAD'
git config --global --replace-all alias.plo 'pull origin'
git config --global --replace-all alias.plod 'pull origin dev'
git config --global --replace-all alias.plos 'pull origin staging'
git config --global --replace-all alias.plom 'pull origin master'
git config --global --replace-all alias.ploh 'pull origin HEAD'
git config --global --replace-all alias.sur 'submodule update --init --recursive'
git config --global --replace-all alias.st 'status'
git config --global --replace-all alias.tree 'log --graph --decorate --pretty=format:"%C(yellow)%h %Cred%cr %Cblue(%an)%C(cyan)%d%Creset %s" --abbrev-commit --all'
git config --global --replace-all alias.unstage 'reset --soft HEAD^'

# Anaconda3
ANACONDA_DIR=~/anaconda3
if [ "$FORCE_FLAG" = "false" ] && [ -d $ANACONDA_DIR ]
then
    echo "Anaconda3 is already installed"
    echo "anaconda version: $(anaconda --version)"
    echo "conda version: $(conda --version)"
    echo "Current python3: $(which python3)"
else
    echo "Installing anaconda3..."

    curl -O https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh
    bash Anaconda3-5.2.0-Linux-x86_64.sh
fi

# Visual Studio Code
if [ "$FORCE_FLAG" = "false" ] && code --version > /dev/null
then
    echo "VS Code is already installed: $(code --version)"
else
    echo "Installing VS Code..."

    # Install VS Code
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get update
    sudo apt-get install -y code

    # Install extensions and configure
    code --install-extension shan.code-settings-sync
fi

# Grub customizer
if [ "$FORCE_FLAG" = "false" ] && which grub-customizer > /dev/null
then
    echo "grub-customizer already installed: $(which grub-customizer)"
else
    echo "Installing grub-customizer..."
    sudo add-apt-repository -y ppa:danielrichter2007/grub-customizer
    sudo apt-get update
    sudo apt-get install -y grub-customizer
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
    echo "Installing a custom git prompt (magicmonty/bash-git-prompt)"
    cd ~
    git clone https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt --depth=1
    echo -e "\n" >> .bashrc
    echo "# Appended by preq_installer.sh" >> .bashrc
    echo "GIT_PROMPT_ONLY_IN_REPO=1" >> .bashrc
    echo "source ~/.bash-git-prompt/gitprompt.sh" >> .bashrc
fi

# Return to the original directory
cd $cwd