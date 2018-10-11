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

module "auth_vm" {
  source = "./vm"

  name      = "auth"
  cores     = 1
  memory    = 512
  address   = "192.168.100.5"
  os_disk   = 4096
  data_disk = 1

  network_name = "${libvirt_network.default.name}"
}

module "test_vm" {
  source = "./vm"

  name      = "test"
  cores     = 1
  memory    = 512
  address   = "192.168.100.6"
  os_disk   = 4096
  data_disk = 1
  
  network_name = "${libvirt_network.default.name}"
}

module "cloud_vm" {
  source = "./vm"

  name      = "cloud"
  cores     = 2
  memory    = 1024
  address   = "192.168.100.4"
  os_disk   = 4096
  data_disk = 1

  network_name = "${libvirt_network.default.name}"
}

