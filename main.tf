provider "libvirt" {
  uri = "qemu:///system"
}

# Default VM Network
resource "libvirt_network" "default" {
  name = "default"
  addresses = ["192.168.100.0/24"]
  domain = "vm"
  bridge = "virbr0"
  autostart = true
  dhcp {
    enabled = true
  }
}

module "cloud_vm" {
  source = "./vm"

  name      = "cloud"
  cores     = 2
  memory    = 1024
  address   = "192.168.100.4"
  os_disk   = 4294967296 # 4 GB
  data_disk = 1024
  
  network_name = "${libvirt_network.default.name}"
}

