#!/bin/sh

cp /cdrom/simple-cdd/autoresizefs /target/usr/local/bin/
cp /cdrom/simple-cdd/autoresizefs.service /target/etc/systemd/system/
chmod +x /target/usr/local/bin/autoresizefs

cp /cdrom/simple-cdd/preparedatadisk /target/usr/local/bin/
cp /cdrom/simple-cdd/preparedatadisk.service /target/etc/systemd/system/
chmod +x /target/usr/local/bin/preparedatadisk
