variable "network_name" {
  type = "string"
  description = "Name of the network this machine should be in" 
}

variable "name" {
  type = "string"
  description = "Name of the virtual machine"
}

variable "cores" {
  type = "string"
  description = "Number of cores"
}

variable "memory" {
  type = "string"
  description = "RAM in Megabytes"
}

variable "address" {
  type = "string"
  description = "IP address"
}

variable "os_disk" {
  type = "string"
  description = "Size of the OS disk in bytes"
}

variable "data_disk" {
  type = "string"
  description = "Size of the data disk in bytes"
}


resource "libvirt_volume" "os_disk" {
  name = "${var.name}_os"
  pool = "vg0"
  size = "${var.os_disk}"
}

resource "libvirt_volume" "data_disk" {
  name = "${var.name}_data"
  pool = "data"
  size = "${var.data_disk}"
  format = "qcow2"

  lifecycle {
    prevent_destroy = true
  }
}

resource "libvirt_domain" "domain" {
  name = "${var.name}"

  running   = false
  autostart = false

  disk {
    file = "/home/tyrant/salt-minion-debian-preseed/images/debian-9.5-amd64-CD-1.iso"
  }

  disk {
    volume_id = "${libvirt_volume.os_disk.id}"
  }

  #disk {
  #  volume_id = "${libvirt_volume.data_disk.id}"
  #}

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  network_interface {
    network_name = "${var.network_name}"
    addresses = ["${var.address}"]
    hostname  = "${var.name}"
  }

  vcpu  = "${var.cores}"
  memory  = "${var.memory}"

  boot_device = {
    dev = ["hd", "cdrom"]
  }
}
