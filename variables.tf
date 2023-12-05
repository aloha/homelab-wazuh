variable "proxmox" {
  type = map(string)
  default = {
    target_storage = "local"
    target_node    = "pve"
    clone_template = "ubuntu-cloudinit-2204"
    ip_address = "10.13.37.10"
  }
}

variable "instance" {
  type = any
  default = {
    cpus = 4
    memory = 8192
    disk_size = "50G"
    hostname = "compute"
    network-cidr = "10.20.77.0/24"
    network-vlan = "" // Optionally set to your vlan configuration
    network-cidr-start = 10 // Will make the last octet in a /24 = .10
  }
}

variable "ssh" {
  type = any
  default = {
    private_key = "~/.ssh/id_ed25519"
    public_key = "~/.ssh/id_ed25519.pub"
    ssh_user = "ubuntu"
  }
}