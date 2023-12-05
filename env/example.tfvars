proxmox = {
  target_node    = "megatron"
  target_storage = "cybertron"
  clone_template = "ubuntu-cloudinit-2204"
  ip_address     = "10.13.37.10"
}

instance = {
  cpus = 4
  memory = 8192
  disk_size = "50G"
  hostname = "wazuh"
  network-cidr = "10.20.77.0/24"
  network-vlan = "2077" // Optionally set to your vlan configuration
  network-cidr-start = 10
}