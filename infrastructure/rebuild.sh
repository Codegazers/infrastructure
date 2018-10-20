#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $(basename $0) <vm>"
  exit 1
fi

VM=$1

terraform taint -module "${VM}_vm" libvirt_domain.domain
terraform taint -module "${VM}_vm" libvirt_volume.os_disk
./build.sh "$(realpath ../image/images/debian-9.5-amd64-CD-1.iso)"
