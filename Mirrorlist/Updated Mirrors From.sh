#!/bin/bash
########################
######## Mirrorlist ##########
echo ""
echo -e "${BLUE}:: ${NC}Скачаем новый список серверов-зеркал для загрузки (/etc/pacman.d/mirrorlist) с сайта archlinux.org/mirrorlist. Ставим зеркало для России"
echo "$(date -u "+%F %H:%M") : Обновленные Зеркала от: www.archlinux.org/mirrorlist " 
echo " Установка базовых (дополнительных) программ (пакетов): wget, pacman-contrib "
pacman -S --noconfirm --noprogressbar --quiet wget  # Сетевая утилита для извлечения файлов из Интернета
pacman -S --noconfirm --noprogressbar --quiet pacman-contrib  # Предоставленные скрипты и инструменты для систем pacman (https://github.com/kyrias/pacman-contrib) 
pacman -S --noconfirm --needed --noprogressbar --quiet wget pacman-contrib
echo " Создание (backup) резервного списка зеркал mirrorlist - (mirrorlist.bak) "
cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
# cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old
echo " Скачаем новый список серверов-зеркал "
## curl -s "https://www.archlinux.org/mirrorlist/all/" | sed '10,1000d;s/#//' >/etc/pacman.d/mirrorlist.bak
## curl -s "https://archlinux.org/mirrorlist/?country=FR&country=GB&protocol=https" >/etc/pacman.d/mirrorlist.bak
## curl -s "https://archlinux.org/mirrorlist/?country=FR&country=GB&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 -
curl -s "https://archlinux.org/mirrorlist/?country=RU&protocol=https" >/etc/pacman.d/mirrorlist.bak
# sed -i 's/#//' /etc/pacman.d/mirrorlist.bak
sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.bak
rankmirrors -n 6 /etc/pacman.d/mirrorlist.bak > /etc/pacman.d/mirrorlist
sleep 1
### Если ли надо раскомментируйте нужные вам значения ####
## wget -O /etc/pacman.d/mirrorlist archlinux.org/mirrorlist/?country=US 
#wget -O /etc/pacman.d/mirrorlist.old archlinux.org/mirrorlist/?country=RU
#sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.old
#rankmirrors -n 6 /etc/pacman.d/mirrorlist.old > /etc/pacman.d/mirrorlist
## All mirrors: mirror_url="https://www.archlinux.org/mirrorlist/all/"
## All https mirrors: mirror_url="https://www.archlinux.org/mirrorlist/all/https/"
## User selected country: mirror_url="https://www.archlinux.org/mirrorlist/?country=$code"
###
echo -e "${BLUE}:: ${NC}Создание (backup) резервного списка зеркал mirrorlist - (mirrorlist.backup)"
cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
echo -e "${BLUE}:: ${NC}Посмотреть список серверов-зеркал для загрузки в mirrorlist"
cat /etc/pacman.d/mirrorlist  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 1
echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов" 
pacman -Sy --noconfirm  # обновить списки пакетов из репозиториев
sleep 1
################

########################
######## Mirrorlist ##########
echo ""
echo -e "${BLUE}:: ${NC}Изменяем серверов-зеркал для загрузки. Ставим зеркало для России от Яндекс"
> /etc/pacman.d/mirrorlist
cat <<EOF >>/etc/pacman.d/mirrorlist

##
## Arch Linux repository mirrorlist
## Generated on 2021-05-06
## HTTP IPv4 HTTPS
## https://www.archlinux.org/mirrorlist/
## https://www.archlinux.org/mirrorlist/?country=RU&protocol=http&protocol=https&ip_version=4


## Russia
Server = https://mirror.yandex.ru/archlinux/\$repo/os/\$arch
Server = https://mirror.surf/archlinux/\$repo/os/\$arch
Server = https://mirror.rol.ru/archlinux/\$repo/os/\$arch
Server = https://mirror.nw-sys.ru/archlinux/$repo/os/\$arch
Server = https://mirror.truenetwork.ru/archlinux/\$repo/os/\$arch
#Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch
#Server = http://mirror.surf/archlinux/\$repo/os/\$arch
#Server = http://mirror.rol.ru/archlinux/\$repo/os/\$arch
#Server = http://mirror.nw-sys.ru/archlinux/$repo/os/\$arch
#Server = http://mirror.truenetwork.ru/archlinux/\$repo/os/\$arch
#Server = http://mirrors.powernet.com.ru/archlinux/$repo/os/$arch
#Server = http://archlinux.zepto.cloud/\$repo/os/\$arch

##
## Arch Linux repository mirrorlist
## Generated on 2021-05-06
## HTTP IPv6 HTTPS
## https://www.archlinux.org/mirrorlist/
## https://www.archlinux.org/mirrorlist/?country=RU&ip_version=6
##

## Russia
#Server = http://mirror.yandex.ru/archlinux/$repo/os/\$arch
#Server = https://mirror.yandex.ru/archlinux/$repo/os/\$arch
#Server = http://mirror.nw-sys.ru/archlinux/$repo/os/\$arch
#Server = https://mirror.nw-sys.ru/archlinux/$repo/os/\$arch
#Server = http://mirror.surf/archlinux/$repo/os/\$arch
#Server = https://mirror.surf/archlinux/$repo/os/\$arch
#Server = http://mirrors.powernet.com.ru/archlinux/$repo/os/\$arch
#Server = http://archlinux.zepto.cloud/$repo/os/\$arch

EOF
###
echo -e "${BLUE}:: ${NC}Создание (backup) резервного списка зеркал mirrorlist - (mirrorlist.backup)"
cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
echo -e "${BLUE}:: ${NC}Посмотреть список серверов-зеркал для загрузки в mirrorlist"
cat /etc/pacman.d/mirrorlist  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 1
echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов" 
pacman -Sy --noconfirm  # обновить списки пакетов из репозиториев
sleep 1
################



