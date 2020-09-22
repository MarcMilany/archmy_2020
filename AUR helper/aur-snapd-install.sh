#!/usr/bin/env bash
# Install script snapd
# autor: Marc Milany https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url

# wget git.io/aur-snapd.sh && sh aur-snapd.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
sudo pacman -S --noconfirm --needed wget curl git 
echo " Установка поддержки Snap "
git clone https://aur.archlinux.org/snapd.git
cd snapd
# makepkg -si
# makepkg -si --noconfirm   #-не спрашивать каких-либо подтверждений
makepkg -si --skipinteg
cd ..
rm -rf snapd
#rm -Rf snapd
clear
echo " Установка Snapd выполнена "
########## Запускаем поддержку Snap ###############
echo ""
echo -e " Включить модуль systemd, который управляет основным сокетом мгновенной связи " 
sudo systemctl enable --now snapd.socket
# Проверить статус сервиса:
# systemctl status snapd.socket
echo ""
echo -e " Включить поддержку классической привязки, чтобы создать символическую ссылку между /var/lib/snapd/ snap и /snap " 
sudo ln -s /var/lib/snapd/snap /snap
echo ""
echo -e " Поскольку бинарный файл находится в каталоге /snap/bin/, нужно добавить его в переменную $PATH. " 
echo "export PATH=\$PATH:\/snap/bin/" | sudo tee -a /etc/profile
source /etc/profile
echo ""
echo " Snapd теперь готов к использованию "
echo " Вы взаимодействуете с ним с помощью команды snap. "
# Посмотрите страницу помощи команды:
# snap --help
echo ""
echo -e " Протестируем систему, установив hello-world snap и убедимся, что она работает правильно. "
#sudo snap install hello-world
snap install hello-world
hello-world
echo ""
echo -e " Список установленных snaps: "
snap list
echo -e "$ Удалить установленный snap (hello-world) "
sudo snap remove hello-world
echo ""
echo " Snap теперь установлен и готов к работе! "

#
# https://aur.archlinux.org/packages/snapd/
# Сервис и инструменты для управления пакетами snap.
# База пакета: Snapd
# URL восходящего направления:	https://github.com/snapcore/snapd
# Git Clone URL: https://aur.archlinux.org/snapd.git (только для чтения, нажмите, чтобы скопировать)
# Популярность:	4.20
# Первый отправленный:	2018-01-07 17:37
# Последнее обновление:	2020-09-07 11:30
#
# Есть ещё один вариант snapd:
# https://aur.archlinux.org/packages/snapd-git/
# Сервис и инструменты для управления пакетами snap.
# База пакета: snapd-git
# URL восходящего направления:	https://github.com/snapcore/snapd
# Git Clone URL: https://aur.archlinux.org/snapd-git.git  (только для чтения, нажмите, чтобы скопировать)
# Популярность:	0,019456
# Первый отправленный:	2017-11-17 06:47
# Последнее обновление:	2020-05-18 14:24
# - Помечено как устаревшее (2020-07-29)
# <<< Делайте выводы сами! >>>
#
