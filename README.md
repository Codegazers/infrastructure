# Automated Libvirt & Salt configuration

## LDAP
Salt module ldap3 is broken in salt-minion 2018.3.2. Apply the following patch to /usr/lib/python2.7/dist-packages/salt/modules/ldap3.py to fix it: https://github.com/saltstack/salt/pull/48258/files

## Allow local minion traffic with ufw
`ufw allow proto tcp from 192.168.100.0/24 to 192.168.100.1 port 4505,4506`
