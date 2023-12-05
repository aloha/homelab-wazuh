#!/usr/bin/env bash

# Install libguestfs-tools on Proxmox server.
apt-get install libguestfs-tools

# Fetch the ubuntu cloudimg
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

# Install qemu-guest-agent on Ubuntu image.
virt-customize -a jammy-server-cloudimg-amd64.img --install qemu-guest-agent