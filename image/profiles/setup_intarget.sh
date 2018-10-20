#!/bin/bash

systemctl enable serial-getty@ttyS0
systemctl enable salt-minion

systemctl enable autoresizefs
systemctl enable preparedatadisk
