
# Prerequisites

- Proxmox version 7.4+ 
- Two environment variables set: `PM_USER` & `PM_PASS`
- [Cloud Init template](extras) created, ideally Ubuntu 2204 _(tested)_

# Usage

- Create tfvars file in `env` folder for your configuration
- Set variables according to your environment

__Example__
```hcl
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
```
- Run `terraform init` to install necessary dependencies
- Run `terraform apply --var-file=./env/<your var file>.tfvars` 
- Stdout will have Wazuh default credentials that are generated, don't lose them!
```shell
proxmox_vm_qemu.instance[0] (remote-exec): 05/12/2023 14:54:25 INFO: You can access the web interface https://<wazuh-dashboard-ip>:443
proxmox_vm_qemu.instance[0] (remote-exec):     User: admin
proxmox_vm_qemu.instance[0] (remote-exec):     Password: P5E?4ZTqBoJKoTb.3tECwY83qgZQqL.d     <------ Nice password!
proxmox_vm_qemu.instance[0] (remote-exec): 05/12/2023 14:54:25 INFO: Installation finished.
```

# TODO

- Support `PM_API_TOKEN_ID` & `PM_API_TOKEN_SECRET` instead of USER/PASS