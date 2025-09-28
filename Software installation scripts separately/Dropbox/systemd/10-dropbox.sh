#!/bin/sh
# /etc/NetworkManager/dispatcher.d/10-dropbox.sh

USER=''your_user''
status=$2

case $status in
       up)
		systemctl start dropbox@$USER.service
       ;;
       down)
       		systemctl stop dropbox@$USER.service
       ;;
esac