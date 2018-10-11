provider "libvirt" {
  uri = "qemu:///system"
}

variable "image" {
  type = "string"
  description = "Path to the preseeded image"
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
  mac       = "66:D4:98:7F:CE:B1"
  os_disk   = 4096
  data_disk = 1

  network_name = "${libvirt_network.default.name}"
  image        = "${var.image}"
}

module "test_vm" {
  source = "./vm"

  name      = "test"
  cores     = 1
  memory    = 512
  address   = "192.168.100.6"
  mac       = "9A:5F:7E:35:95:CF"
  os_disk   = 4096
  data_disk = 1
  
  network_name = "${libvirt_network.default.name}"
  image        = "${var.image}"
}

module "cloud_vm" {
  source = "./vm"

  name      = "cloud"
  cores     = 2
  memory    = 1024
  address   = "192.168.100.4"
  mac       = "1A:BA:63:F2:50:35"
  os_disk   = 4096
  data_disk = 1

  network_name = "${libvirt_network.default.name}"
  image        = "${var.image}"
}

