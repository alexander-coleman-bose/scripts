#!/bin/bash
# Script to migrate GitLab repos to GitHub Enterprise.
#
# USAGE: ./migrate-gitlab-ghe.sh REPO_URL_FROM REPO_URL_TO

# https://help.github.com/en/enterprise/2.17/admin/installation/migrating-to-a-different-git-large-file-storage-server

# Alex St. Amour

# Get the original directory
ORIG_PWD="$PWD"

# Some defaults
TEMP_REPO="temp_repo"

# Get the two locations. First argument is the repo to clone FROM, and the
#   second argument is the repo to clone TO.
clone_from="$1"
clone_to="$2"
echo "Migrating..."
echo "    From: $clone_from"
echo "    To:   $clone_to"
echo ""

# Define a cleanup function
cleanup_and_exit () {
    if [ -z "$1" ]; then
        exit_code=0
    else
        exit_code=$1
    fi

    echo -n "CLEANING UP..."
    cd "$ORIG_PWD" || exit 1
    rm -rf "$TEMP_REPO" || exit 1
    echo "DONE"

    exit "$exit_code"
}

# Clone the repository
echo -n "Cloning repository from $clone_from..."
if git clone -q "$clone_from" "$TEMP_REPO"; then
    echo "DONE"
    cd "$TEMP_REPO" || cleanup_and_exit 1
else
    echo "FAILED"
    cleanup_and_exit 1
fi
echo ""

# Checkout all tags and branches from the original repo.
echo "Checking out all branches..."
for ref in $(git branch -r | grep -v '\->'); do
    branch_name=${ref#"origin/"}
    echo -n "    "
    git branch --track "$branch_name" "$ref"
done
echo "DONE"
echo ""

# Pull all of the LFS objects
if ! git lfs fetch origin --all; then
    echo >&2 "git lfs fetch origin --all -> FAILED"
    cleanup_and_exit 1
fi
echo "DONE"
echo ""

# Change the remote over
if git remote rm origin; then
    if git remote add origin "$clone_to"; then
        echo "Changed the origin remote to $clone_to"
    else
        echo >&2 "git remote add origin $clone_to -> FAILED"
        cleanup_and_exit 1
    fi
else
    echo >&2 "git remote rm origin -> FAILED"
    cleanup_and_exit 1
fi
echo ""

# Push all of the LFS objects
echo "Pushing any LFS objects..."
if ! git lfs push origin --all; then
    echo >&2 "git lfs push origin --all -> FAILED"
    cleanup_and_exit 1
fi
echo "DONE"
echo ""

# Push all branches
echo "Pushing all branches to the new repo..."
if ! git push -u --all origin; then
    echo >&2 "git push -u --all origin -> FAILED"
    cleanup_and_exit 1
fi
echo "DONE"
echo ""

# Push all tags
echo "Pushing all tags to the new repo..."
if ! git push --tags origin; then
    echo >&2 "git push -u --all origin -> FAILED"
    cleanup_and_exit 1
fi
echo "DONE"
echo ""

# Cleanup at the end
cleanup_and_exit 0
