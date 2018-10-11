#!/bin/bash

systemctl enable serial-getty@ttyS0
systemctl enable autoresizefs
systemctl enable salt-minion
