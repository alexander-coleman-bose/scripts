#!/usr/bin/env bash
# Script to update scripts repos with most recent package config

# If no input
if [ -z ]

# Handle N inputs
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --hyper)
            echo "Updating .hyper.js"
            shift
            ;;
        --vscode)
            echo "Updating VSCode config"
            shift
            ;;
        --matlab)
            echo "Updating Matlab config"
            shift
            ;;
        --bash_aliases)
            echo "Updating .bash_aliases"
            shift
            ;;
        --ssh)
            echo "Updating ssh config"
            shift
            ;;
        --zsh_aliases)
            echo "Updating .zsh_aliases"
            shift
        *)
            echo "Updating $key"
            shift
            ;;
    esac
done

echo "Done updating"
