# ==================================================================
#           Cloudinit Template File (custom)
# ==================================================================
resource "local_file" "cloud_init_local_file_creation" {
  content = templatefile("./templates/user_data_cloud_init_ubuntu.tftpl", {
    public_key = file(var.ssh.public_key)
  })
  filename = "./templates/user_data_cloud_init_ubuntu2004.cfg"
}

# Transfer the file to the Proxmox Host
resource "null_resource" "cloud_init_ubuntu2004" {

  depends_on = [
    local_file.cloud_init_local_file_creation
  ]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.ssh.private_key)
    host        = var.proxmox.ip_address
  }

  provisioner "file" {
    source      = "./templates/user_data_cloud_init_ubuntu2004.cfg"
    destination = "/var/lib/vz/snippets/cloud_init_ubuntu2004.yml"
  }
}