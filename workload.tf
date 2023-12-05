# ==================================================================
#           Instance Definition
# ==================================================================

# Proxmox Instance Block
resource "proxmox_vm_qemu" "instance" {

  # Lay down cloudinit script first inside proxmox
  depends_on = [
    null_resource.cloud_init_ubuntu2004,
  ]

  count = 1

  #cloud-init
  cicustom = "user=local:snippets/cloud_init_ubuntu2004.yml"
  sshkeys      = file(var.ssh.public_key)
  ciuser       = "ubuntu"

  #static specs
  name        = var.instance.hostname
  os_type     = "cloud-init"
  qemu_os     = "l26"
  target_node = var.proxmox.target_node
  clone       = var.proxmox.clone_template
  full_clone  = false
  agent       = 1
  sockets     = 1

  #dynamic specs
  cores       = var.instance.cpus
  vcpus       = var.instance.cpus
  memory      = var.instance.memory

  # networking
  ipconfig0 = "ip=${cidrhost(var.instance.network-cidr, var.instance.network-cidr-start)}/24,gw=${cidrhost(var.instance.network-cidr, 1)}"

  disk {
    type    = "virtio"
    size    = var.instance.disk_size
    storage = var.proxmox.target_storage
  }

  # two networking devices, one for management, both with no vlan settings
  network {
    model   = "virtio"
    bridge  = "vmbr0"
    tag     = var.instance.network-vlan
  }

  connection {
    type     = "ssh"
    user     = var.ssh.ssh_user
    private_key = file(var.ssh.private_key)
    host     = cidrhost(var.instance.network-cidr, var.instance.network-cidr-start)
  }

  provisioner "file" {
    source      = "userdata.sh"
    destination = "/tmp/userdata.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/userdata.sh",
      "/tmp/userdata.sh"
    ]
  }

  lifecycle {
    ignore_changes = [
      network,
      vcpus
    ]
  }
}
