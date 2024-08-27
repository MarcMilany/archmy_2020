#!/usr/bin/env bash
# Install script pamac-all-git
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url

# wget git.io/pamac-all-git.sh && sh pamac-all-git.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git
echo " Установка графического менеджера "Pacman gui" (pamac-all-git) " 
git clone https://aur.archlinux.org/pamac-all-git.git
cd pamac-all-git
#makepkg -fsri 
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf pamac-all-git
rm -Rf pamac-all-git   # удаляем директорию сборки
echo " Графический менеджер Pacman gui (pamac-all-git) успешно установлен! "

#
# https://aur.archlinux.org/packages/pamac-all-git/
# Интерфейс Gtk3 для libalpm (все в одном пакете - snap, flatpak, appindicator)
# База пакета: pamac-all-git
# URL восходящего направления:	https://gitlab.manjaro.org/applications/pamac
# Git Clone URL: https://aur.archlinux.org/pamac-all-git.git  (только для чтения, нажмите, чтобы скопировать)
# Популярность:	1.57
# Первый отправленный:	2020-08-25 10:21
# Последнее обновление:	2020-09-04 11:43
#
# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps
# 
# Есть ещё один вариант Pamac-all:
# https://aur.archlinux.org/packages/pamac-all/
# Интерфейс Gtk3 для libalpm (все в одном пакете - snap, flatpak, appindicator)
# База пакета: pamac-all
# URL восходящего направления:	https://gitlab.manjaro.org/applications/pamac
# Git Clone URL: https://aur.archlinux.org/pamac-all.git  (только для чтения, нажмите, чтобы скопировать)
# Популярность:	0,86
# Первый отправленный:	2020-08-25 09:51
# Последнее обновление:	2020-09-13 14:19
# <<< Делайте выводы сами! >>>
#

