#!/usr/bin/env sh
set -ex

# Variables
code_version=$1
code_architecture=$2

# Function to install 7z using curl
install_7z() {
    # Create a temporary directory
    tmp_dir=$(mktemp -d)
    cd "$tmp_dir"

    # Download precompiled 7z binary (replace with the latest URL)
    curl -L -o 7z.tar.xz https://www.7-zip.org/a/7z2301-linux-x64.tar.xz

    # Validate download
    if [ ! -f 7z.tar.xz ] || [ $(stat -c%s "7z.tar.xz") -lt 1024 ]; then
        echo "Error: Failed to download 7z.tar.xz or file is incomplete." >&2
        exit 1
    fi

    # Extract the binary
    tar -xf 7z.tar.xz || { echo "Error: Failed to extract 7z.tar.xz"; exit 1; }
    mv 7zz /usr/local/bin/7z

    # Clean up
    cd -
    rm -rf "$tmp_dir"
}

# Check if 7z is installed; if not, install it
if ! command -v 7z >/dev/null 2>&1; then
    install_7z
fi

# Download the ZIP file
curl -L -o lambda.zip "https://github.com/spacelift-io/ec2-workerpool-autoscaler/releases/download/${code_version}/ec2-workerpool-autoscaler_linux_${code_architecture}.zip"

# Create the lambda directory and extract the ZIP file
mkdir -p lambda
cd lambda
7z x ../lambda.zip -o./
rm ../lambda.zip
