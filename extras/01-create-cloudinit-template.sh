#!/usr/bin/env bash

IMAGE=jammy-server-cloudimg-amd64.img
STORAGE=cybertron # Make sure to update this to match your proxmox storage node
VMID=9022
NAME=ubuntu-cloudinit-2204

# Create the instance
qm create $VMID -name $NAME -memory 1024 -net0 virtio,bridge=vmbr0 -cores 1 -sockets 1
# Import the OpenStack disk image to Proxmox storage
qm importdisk $VMID $IMAGE $STORAGE
# Attach the disk to the virtual machine
qm set $VMID -scsihw virtio-scsi-pci -virtio0 $STORAGE:vm-$VMID-disk-0
# Add a serial output
qm set $VMID -serial0 socket
# Set the bootdisk to the imported Openstack disk
qm set $VMID -boot c -bootdisk virtio0
# Enable the Qemu agent
qm set $VMID -agent 1,fstrim_cloned_disks=1
# Allow hotplugging of network, USB and disks
qm set $VMID -hotplug disk,network,usb
# Add a single vCPU (for now)
qm set $VMID -vcpus 1
# Add a video output
qm set $VMID -vga qxl
# Set a second hard drive, using the inbuilt cloudinit drive
qm set $VMID -ide2 $STORAGE:cloudinit
# Resize the primary boot disk (otherwise it will be around 2G by default)
qm resize $VMID virtio0 +2G
# Convert the VM to the template
qm template $VMID