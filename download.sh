#!/usr/bin/env sh
set -ex

# Download the data.
code_version=$1
code_architecture=$2

curl -L -o lambda.zip "https://github.com/spacelift-io/ec2-workerpool-autoscaler/releases/download/${code_version}/ec2-workerpool-autoscaler_linux_${code_architecture}.zip"

# Install p7zip if not already installed (Amazon Linux)
apt-get update && apt-get install -y p7zip-full

mkdir -p lambda
cd lambda

# Extract the files using 7z
7z x ../lambda.zip -o./
rm ../lambda.zip
