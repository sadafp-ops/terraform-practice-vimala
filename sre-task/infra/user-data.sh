#!/bin/bash
set -e

# Basic packages
apt-get update -y
apt-get install -y curl

# Install k3s (single-node server)
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode=644" sh -

# Small marker so we know cloud-init finished
echo "k3s installed on $(date)" > /var/log/k3s-installed