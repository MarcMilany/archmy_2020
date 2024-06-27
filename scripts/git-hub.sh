#!/usr/bin/env bash
# Install script github
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/git-hub.sh && sh git-hub.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git
echo " Установка Git-Hub (Интерфейс командной строки Git для GitHub) "
git clone https://aur.archlinux.org/git-hub.git 
cd git-hub
#makepkg -fsri  
makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)  
rm -Rf git-hub  # удаляем директорию сборки
# rm -rf git-hub 
echo " Установка Git-Hub завершена "

# -------------------------------------------------

# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps

# ---------------------------------------------------

#
# https://aur.archlinux.org/packages/git-hub/
# Интерфейс командной строки Git для GitHub
# База пакета: github
# URL восходящего направления:	https://github.com/sociantic-tsunami/git-hub
# Git Clone URL: https://aur.archlinux.org/git-hub.git  (только для чтения, нажмите, чтобы скопировать)
# Популярность:	0,000000
# Первый отправленный:	2013-09-20 14:24
# Последнее обновление:	2020-01-15 10:44

# https://aur.archlinux.org/packages/github-desktop/
# Графический интерфейс для управления Git и GitHub.
# База пакета: github-desktop
# URL восходящего направления:	https://desktop.github.com
# Git Clone URL: https://aur.archlinux.org/github-desktop.git  (только для чтения, нажмите, чтобы скопировать)
# Популярность:	1,59
# Первый отправленный:	2017-07-22 21:26
# Последнее обновление:	2020-09-14 00:41

# <<< Делайте выводы сами! >>>
#
