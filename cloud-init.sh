#!/bin/bash
# This script creates an Ubuntu VM on Linode and configures it via cloud‑init
# to install Python, pip, and a list of specific Python packages.

# Define variables – adjust these as needed
LINODE_TYPE="g6-nanode-1"         # Instance type; adjust if you need more resources
REGION="us-east"                  # Choose your desired region
IMAGE="linode/ubuntu20.04"        # Ubuntu 20.04 image (you can use a different Ubuntu version if needed)
LABEL="ubuntu-dev-vm"
ROOT_PASS="YourSecureRootPassword"  # Replace with a secure password
SSH_KEY="$(cat ~/.ssh/id_rsa.pub)"    # Your public SSH key for access

# Create a temporary cloud‑init file that updates packages, installs Python and pip,
# and then uses pip to install the specified Python packages.
cat <<'EOF' > cloud-init.yaml
#cloud-config
package_update: true
packages:
  - python3
  - python3-pip
runcmd:
  - pip3 install opencv-python==4.9.0.80 diffusers==0.31.0 transformers==4.46.3 tokenizers==0.20.3 accelerate==1.1.1 pandas==2.0.3 numpy==1.24.4 einops==0.7.0 tqdm==4.66.2 loguru==0.7.2 imageio==2.34.0 imageio-ffmpeg==0.5.1 safetensors==0.4.3 gradio==5.0.0
EOF

# Create the Linode instance using the Linode CLI.
# The --userdata flag passes the cloud‑init file so that it runs on first boot.
linode-cli linodes create \
  --type "$LINODE_TYPE" \
  --region "$REGION" \
  --image "$IMAGE" \
  --root_pass "$ROOT_PASS" \
  --label "$LABEL" \
  --authorized_keys "$SSH_KEY" \
  --userdata "$(cat cloud-init.yaml)" \
  --booted true

# Cleanup temporary file (optional)
# rm cloud-init.yaml
