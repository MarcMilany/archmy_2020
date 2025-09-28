#!/usr/bin/env bash
# Install script pamac-aur-git
# autor: Marc Milany https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url

# wget git.io/pamac-aur-git.sh && sh pamac-aur-git.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git
echo " Установка графического менеджера "Pacman gui" (pamac-aur-git) " 
git clone https://aur.archlinux.org/pamac-aur-git.git  
cd pamac-aur-git
#makepkg -fsri 
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf pamac-aur-git
rm -Rf pamac-aur-git   # удаляем директорию сборки
echo " Графический менеджер Pacman gui (pamac-aur-git) успешно установлен! "

#
# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps

# https://aur.archlinux.org/packages/pamac-aur-git/
# Интерфейс Gtk3 для libalpm - версия для git
# База пакета: pamac-aur-git
# URL восходящего направления:	https://gitlab.manjaro.org/applications/pamac
# Git Clone URL: https://aur.archlinux.org/pamac-aur-git.git (только для чтения, нажмите, чтобы скопировать)
# Популярность:	0,51
# Первый отправленный:	2017-09-09 10:09
# Последнее обновление:	2020-09-13 14:09
# 
# Есть ещё один вариант Pamac-aur:
#
# https://aur.archlinux.org/packages/pamac-aur/
# Интерфейс Gtk3 для libalpm.
# База пакета: pamac-aur
# URL восходящего направления:	https://gitlab.manjaro.org/applications/pamac
# Git Clone URL: https://aur.archlinux.org/pamac-aur.git (только для чтения, нажмите, чтобы скопировать)
# Популярность:	4,64
# Первый отправленный:	2013-12-05 12:57
# Последнее обновление:	2020-09-13 18:59
# <<< Делайте выводы сами! >>>
#
