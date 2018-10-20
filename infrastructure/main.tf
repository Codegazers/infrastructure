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
  dns {
    local_only = true
  }
  dhcp {
    enabled = true
  }
}

module "cloud_vm" {
  source = "./vm"

  name      = "cloud"
  cores     = 1
  memory    = 1024
  address   = "192.168.100.4"
  mac       = "1A:BA:63:F2:50:35"
  os_disk   = "${10 * 1024}"
  data_disk = "${200 * 1024}"

  network_name = "${libvirt_network.default.name}"
  image        = "${var.image}"
}

module "auth_vm" {
  source = "./vm"

  name      = "auth"
  cores     = 1
  memory    = 512
  address   = "192.168.100.5"
  mac       = "66:D4:98:7F:CE:B1"
  os_disk   = 4096

  # This VM doesn't actually need a data disk, but due to limitations in
  # Terraform, the libvirt provider and this setup, we have to add one.
  # TODO Fix this once terraform v12 lands
  data_disk = 16 # Data disks must not be smaller than this for LVM to work

  network_name = "${libvirt_network.default.name}"
  image        = "${var.image}"
}

module "web_vm" {
  source = "./vm"

  name      = "web"
  cores     = 2
  memory    = 4096
  address   = "192.168.100.7"
  mac       = "86:38:60:96:C4:C3"
  os_disk   = "${10 * 1024}"
  data_disk = "${5 * 1024}"

  network_name = "${libvirt_network.default.name}"
  image        = "${var.image}"
}

module "git_vm" {
  source = "./vm"

  name      = "git"
  cores     = 1
  memory    = 2048
  address   = "192.168.100.8"
  mac       = "86:A5:DB:1C:78:71"
  os_disk   = "${10 * 1024}"
  data_disk = "${200 * 1024}"

  network_name = "${libvirt_network.default.name}"
  image        = "${var.image}"
}

module "mail_vm" {
  source = "./vm"

  name      = "mail"
  cores     = 1
  memory    = 1024
  address   = "192.168.100.9"
  mac       = "86:6A:9A:00:1A:6B"
  os_disk   = "${10 * 1024}"
  data_disk = "${200 * 1024}"

  network_name = "${libvirt_network.default.name}"
  image        = "${var.image}"
}

module "database_vm" {
  source = "./vm"

  name      = "database"
  cores     = 2
  memory    = 2048
  address   = "192.168.100.10"
  mac       = "86:63:2D:10:86:0A"
  os_disk   = "${10 * 1024}"
  data_disk = "${100 * 1024}"

  network_name = "${libvirt_network.default.name}"
  image        = "${var.image}"
}
