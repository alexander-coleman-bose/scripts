# Download and execute miniconda3 installer script
# Alex Coleman

TMP_DIR=/tmp
INSTALL_DIR=${1:-/usr/local/miniconda3}

# Download the Miniconda3 Installer
curl https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -sSf -o $TMP_DIR/miniconda.sh

# Run the miniconda.sh install script in batch mode
sh $TMP_DIR/miniconda.sh -b -f -p $INSTALL_DIR

# Remove the miniconda.sh script
rm $TMP_DIR/miniconda.sh
