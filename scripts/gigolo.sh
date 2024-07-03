#!/usr/bin/env bash
# Install script gigolo
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/gigolo.sh && sh gigolo.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git
echo ""
echo " Установка Gigolo (графический интерфейс для управления соединениями с удалёнными файловыми системами использующими GIO / GVfs) "
# yay -S gigolo --noconfirm  # Фронтенд для управления подключениями к удаленным файловым системам с помощью GIO / GVFS
echo " Установка Gigolo (пакета - ) "
##### gigolo ######  
git clone https://aur.archlinux.org/gigolo.git
cd gigolo
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gigolo
rm -Rf gigolo   # удаляем директорию сборки
echo ""
echo " Установка Gigolo (gigolo) выполнена "

# -------------------------------------------------

# https://aur.archlinux.org/packages/gigolo/
# Фронтенд для управления подключениями к удаленным файловым системам с помощью GIO / GVFS
# База пакета: gigolo
# URL восходящего направления:	https://www.uvena.de/gigolo
# Git Clone URL: https://aur.archlinux.org/gigolo.git  (только для чтения, нажмите, чтобы скопировать)
# Голоса:	115
# Популярность:	0,41
# Первый отправленный:	2009-02-26 22:39
# Последнее обновление:	2020-10-11 19:01
# Источники:
# https://archive.xfce.org/src/apps/gigolo/0.5/gigolo-0.5.1.tar.bz2
# Зависимости: gvfs ( gvfs-nosystemd , gvfs-git )
# gvfs - Реализация виртуальной файловой системы для GIO ( https://www.archlinux.org/packages/extra/x86_64/gvfs/ )
# gvfs-nosystemd - Реализация виртуальной файловой системы для GIO, версия nosystemd (https://aur.archlinux.org/packages/gvfs-nosystemd/) (https://aur.archlinux.org/gvfs-nosystemd.git)
# gvfs-git - Реализация виртуальной файловой системы для GIO (https://aur.archlinux.org/packages/gvfs-git/) (https://aur.archlinux.org/gvfs-git.git)
#
# <<< Делайте выводы сами! >>>
#





