#!/usr/bin/env bash

# Alex St. Amour
# 2021/02/26

echo "Setting Git aliases..."
set -x

# Git config options & aliases
# git config --global submodule.recurse true
# git config --global core.editor 'code --wait'

# git add
git config --global --replace-all alias.aa 'add -A .'

# git branch
git config --global --replace-all alias.br 'branch'
git config --global --replace-all alias.bra 'branch -a'
git config --global --replace-all alias.brd 'branch -d'
git config --global --replace-all alias.brm 'branch --merged'

# git checkout
git config --global --replace-all alias.co 'checkout'
git config --global --replace-all alias.cob 'checkout -b'
git config --global --replace-all alias.coo '!git fetch && git checkout'
git config --global --replace-all alias.dev '!git checkout dev && git pull origin dev'
git config --global --replace-all alias.main '!git checkout main && git pull origin main'
git config --global --replace-all alias.master '!git checkout master && git pull origin master'

# git commit
git config --global --replace-all alias.cam 'commit -am'
git config --global --replace-all alias.cm 'commit -m'

# git clone
git config --global --replace-all alias.cloneall 'clone --recurse-submodules'

# git log
git config --global --replace-all alias.ll 'log --pretty=format:"%C(yellow)%h %Cred%cr %Cblue(%an)%C(cyan)%d%Creset %s" --decorate --stat'
git config --global --replace-all alias.ls 'log --pretty=format:"%C(yellow)%h %Cred%cr %Cblue(%an)%C(cyan)%d%Creset %s" --decorate'
git config --global --replace-all alias.tree 'log --pretty=format:"%C(yellow)%h %Cred%cr %Cblue[%an]%C(cyan)%d %Creset%s" --decorate --graph --abbrev-commit --all'
git config --global --replace-all alias.treev 'log --pretty=format:"%C(yellow)%h %Cred%cr %Cblue[%an]%C(cyan)%d%n%Creset%s" --decorate --graph --abbrev-commit --all'

# git pull
git config --global --replace-all alias.plo 'pull origin'

# git push
git config --global --replace-all alias.po 'push origin'
git config --global --replace-all alias.puo 'push -u origin'
git config --global --replace-all alias.pushf 'push --force-with-lease'

# git rebase
git config --global --replace-all alias.rim 'rebase -i main'
git config --global --replace-all alias.rimm 'rebase -i master'

# git remote
git config --global --replace-all alias.rpo 'remote prune origin'

# git reset
git config --global --replace-all alias.uncommit 'reset --soft HEAD~'

# git status
git config --global --replace-all alias.st 'status'

# git submodule
git config --global --replace-all alias.sur 'submodule update --init --recursive'

# misc
git config --global --replace-all alias.chmodx '!git update-index --chmod=+x'
git config --global --replace-all alias.find '!git ls-files | grep -i'
git config --global --replace-all alias.grep 'grep -Ii'
git config --global --replace-all alias.la '!git config -l | grep alias | cut -c 7-'
