#!/bin/bash
[ ! -d ~/Bluetooth ] && mkdir ~/Bluetooth
fusermount -u ~/Bluetooth
obexfs -b $1 ~/Bluetooth
thunar ~/Bluetooth