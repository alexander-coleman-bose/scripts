#!/usr/bin/env bash
# Writes an .iso to a disk partition (USB drive)

# Alex Coleman
# 2018/10/16

STATUS_HELP=1
STATUS_ERROR=-1

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "Usage: write_image_to_usb.sh [ISO] [DISK_PARTITION]"
    echo ""
    echo "This script uses 'dd' to copy an ISO file to a disk partition."
    exit $STATUS_HELP
fi

# Handle the ISO input
if [ -z "$1" ]; then
    echo "Specify an ISO file to clone from:"

    read -r ISO

    if [ -z "$ISO" ] || [ ! -r "$ISO" ]; then
        echo "ERROR: You MUST specify a valid ISO file."
        exit $STATUS_ERROR
    fi
elif [ ! -r "$1" ]; then
    echo "ERROR: You MUST specify a valid ISO file."
    exit $STATUS_ERROR
else
    ISO=$1
fi

# Handle the Partition input
if [ -z "$2" ]; then
    echo "Specify a disk partition to clone to:"

    read -r DISK_PARTITION

    if [ -z "$DISK_PARTITION" ] || [ ! -b "$DISK_PARTITION" ]; then
        echo "ERROR: You MUST specify a disk partition."
        exit $STATUS_ERROR
    fi
elif [ ! -b "$2" ]; then
    echo "ERROR: You MUST specify a disk partition."
    exit $STATUS_ERROR
else
    DISK_PARTITION=$2
fi

# Run the 'dd' command with the following options
#   bs      read and write up to BYTES bytes at a time
#   status  WHICH info to suppress outputting to stder
# dd if=$ISO of=$DISK_PARTITION bs=4M status=progress && sync

sudo dd if="$ISO" of="$DISK_PARTITION" bs=4M && sync

echo "Don't forget to set the bootable flag on the disk partition!"
# sudo parted /dev/sdb set 1 boot on
