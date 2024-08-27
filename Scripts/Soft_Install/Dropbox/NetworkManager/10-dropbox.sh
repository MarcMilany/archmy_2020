#!/bin/sh
# /etc/NetworkManager/dispatcher.d/10-dropbox.sh

USER=''your_user''
status=$2
case $status in
       up)
		su -c 'DISPLAY=:0 /usr/bin/dropbox & ' $USER
       ;;
       down)
       		killall dropbox
       ;;
esac