#!/bin/bash
set -ex
LOGFILE="/tmp/download-debug.log"

{
  echo "Starting at: $(date)"
  echo "Disk space:"
  df -h /tmp

  echo "Downloading file..."
  curl -L --retry 3 --retry-delay 5 -o lambda.zip "https://github.com/spacelift-io/ec2-workerpool-autoscaler/releases/download/v1.0.1/ec2-workerpool-autoscaler_linux_amd64.zip"

  echo "File details:"
  ls -lh lambda.zip
  sha256sum lambda.zip

  echo "Testing ZIP integrity:"
  unzip -t lambda.zip || { echo "ZIP file integrity check failed"; exit 1; }

  echo "Extracting files..."
  mkdir -p lambda
  cd lambda
  unzip -o ../lambda.zip || { echo "Unzip failed"; exit 1; }
} &>> $LOGFILE
