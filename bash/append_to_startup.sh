#!/usr/bin/env bash
# append_to_startup.sh
# Author: Alex Coleman

# Appends content from a file to your ~/.bashrc, ~/.profile, or any file. This
# function ensures that exactly one empty line exists between the last non-empty
# line of the file and the first line of the imported content. A comment line is
# added to mark the date of the import, and an empty line is also added at the
# end of the content if it doesn't have it already.

# Usage:
#   append_to_startup.sh CONTENT_FILE TARGET_FILE

this="append_to_startup.sh"

# Handle input
if [ -z "$2" ]; then
    TARGET="~/.bashrc"
else
    TARGET="$2"
fi
if [ -z "$1" ]; then
    echo >&2 "$this: You must specifiy content to load into the target file."
elif [ -r "$1" ]; then
    CONTENT=$(cat "$1")
else
    CONTENT="$1"
fi

# Write CONTENT to a file so that we can sed it

# If the first and/or last lines of the content are empty, remove them

# Prepend date string to the CONTENT

# If the last line of TARGET is not empty, append an empty line

# Append the CONTENT

# Append an empty line to TARGET
