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

# Handle content input
if [ -z "$1" ]; then
    echo >&2 "$this: You must specifiy content to load into the target file."
    exit 1
elif [ -r "$1" ]; then
    content=$(cat "$1")
else
    content="$1"
fi

# Handle target input
if [ -z "$2" ]; then
    target="$HOME/.bashrc"
else
    target="$2"
fi
if [ ! -w "$target" ]; then
    echo >&2 "ERROR:$this: $target was not writable."
    exit 1
fi

# Generate a time-stamped header line
header="# Appended on $(date)"

# Remove any hash-bangs and any empty lines, but add one trailing newline
# shellcheck disable=SC1003
echo "$content" | sed -e '/^ *$/d' -e '/^#!/d;' | sed -e "1s/^/\n$header\n/" | sed -e '$a\' > /tmp/content

# Append the CONTENT
cat /tmp/content >> "$target"
rm /tmp/content
