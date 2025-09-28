Dropbox
https://wiki.archlinux.org/title/Dropbox


Использование NetworkManager
Для NetworkManager используйте его функцию диспетчера .

Создайте следующий файл:

/etc/NetworkManager/dispatcher.d/10-dropbox.sh

#!/bin/sh
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

######################

для альтернативы systemd:

/etc/NetworkManager/dispatcher.d/10-dropbox.sh

#!/bin/sh
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