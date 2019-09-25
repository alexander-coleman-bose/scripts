#!/usr/bin/env bash
# Script to install and configure the noip.com Dynamic Update Client

# https://my.noip.com/#!/dynamic-dns/duc

# Requires make

# Store initial directory and switch to /tmp
ORIG_PWD="$PWD"
cd "/tmp" || exit 1

# Download the tar file
FILENAME=noip-duc-linux.tar.gz
ARCHIVE="tar-$FILENAME"
curl -o "$ARCHIVE" https://www.noip.com/client/linux/"$FILENAME"

# Extract
tar xzf "$ARCHIVE"

# Install (interactive, requires login/password from noip.com)
cd noip* || exit 1
make
sudo make install
sudo chmod 666 /usr/local/etc/no-ip2.conf

# Create/Update the configuration file if necessary
# /usr/local/bin/noip2 -C

# Run noip2
/usr/local/bin/noip2

# Add noip as a systemd service to start on startup
# https://unix.stackexchange.com/questions/47695/how-to-write-startup-script-for-systemd
sudo tee /etc/systemd/system/noip2.service <<EOF
[Unit]
Description=Start noip.com Dynamic Update Client (DUC)

[Service]
Type=oneshot
ExecStart=/usr/local/bin/noip2

[Install]
WantedBy=multi-user.target
EOF
sudo chmod 755 /etc/systemd/system/noip2.service

# Enable the service (may require multiple authentications)
systemctl enable noip2.service

# Cleanup
rm -rf /tmp/noip*
rm -rf /tmp/tar-noip*
rm -rf /tmp/._noip*

# Return to the original directory
cd "$ORIG_PWD" || exit 1
