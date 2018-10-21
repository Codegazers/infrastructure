#!/usr/bin/env python3

import sys
import configparser
import subprocess

HEADER="""
*mangle
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]

# Fix bad DHCP checksums (Is this still needed?)
-A POSTROUTING -o virbr0 -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill

COMMIT

*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
%CHAINS%

-A POSTROUTING -s 192.168.100.0/24 -d 224.0.0.0/24 -o eth0 -j RETURN
-A POSTROUTING -s 192.168.100.0/24 -d 255.255.255.255/32 -o eth0 -j RETURN

-A POSTROUTING -s 192.168.100.0/24 ! -d 192.168.100.0/24 -o eth0 -p tcp -j MASQUERADE --to-ports 1024-65535
-A POSTROUTING -s 192.168.100.0/24 ! -d 192.168.100.0/24 -o eth0 -p udp -j MASQUERADE --to-ports 1024-65535
-A POSTROUTING -s 192.168.100.0/24 ! -d 192.168.100.0/24 -o eth0 -j MASQUERADE

%RULES%

COMMIT
"""

vms = []
vm_rules = []

parser = configparser.ConfigParser()
parser.read(sys.argv[1])

for vm in parser:
    if vm == "DEFAULT":
        continue

    vms.append(vm)
    vm_data = parser[vm]
    vm_ip = subprocess.check_output(["/usr/bin/virsh", "domifaddr", vm]).decode('utf-8').split('\n')[2].split()[3][:-3]

    rules = """
# Rules for {0}
-A PREROUTING -d 176.9.48.29/32 -j DNAT-{0}
-A OUTPUT -d 176.9.48.29/32 -j DNAT-{0}
-A POSTROUTING -s {1}/32 -d {1}/32 -j SNAT-{0}""".format(vm, vm_ip)

    for src_port in vm_data:
        dest_port = vm_data[src_port]

        protocol = 'tcp'
        if src_port.startswith('u'):
            protocol = 'udp'
            src_port = src_port[1:]

        rules += "-A DNAT-{0} -d 176.9.48.29/32 -p {4} -m {4} --dport {1} -j DNAT --to-destination {2}:{3}\n".format(
                    vm,
                    src_port,
                    vm_ip,
                    dest_port,
                    protocol)
        rules += "-A SNAT-{0} -s {1}/32 -d {1}/32 -p {3} -m {3} --dport {2} -j MASQUERADE".format(
                    vm,
                    vm_ip,
                    dest_port,
                    protocol)


    vm_rules.append(rules)


vm_chains = [
    ":DNAT-{0} - [0:0]\n:SNAT-{0} - [0:0]".format(vm) for vm in vms
]

out = HEADER.replace('%CHAINS%', '\n'.join(vm_chains)).replace('%RULES%', '\n'.join(vm_rules))
print(out)

