# Automated Libvirt & Salt configuration

## LDAP
Salt module ldap3 is broken in salt-minion 2018.3.2. Apply the following patch to /usr/lib/python2.7/dist-packages/salt/modules/ldap3.py to fix it: https://github.com/saltstack/salt/pull/48258/files
