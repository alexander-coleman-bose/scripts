#!/usr/bin/env bash
# Installs custom bash git prompt

# Alex Coleman
# 2018/10/15

echo "Installing a custom git prompt (magicmonty/bash-git-prompt)"

git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1
echo -e "\n" >> ~/.bashrc
echo "# Appended by preq_installer.sh" >> ~/.bashrc
echo "GIT_PROMPT_ONLY_IN_REPO=1" >> ~/.bashrc
echo "source ~/.bash-git-prompt/gitprompt.sh" >> ~/.bashrc