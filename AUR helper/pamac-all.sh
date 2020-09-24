#!/usr/bin/env bash
# Install script pamac-aur
# autor: Marc Milany https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url

# wget git.io/pamac-all.sh && sh pamac-all.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
sudo pacman -S --noconfirm --needed wget curl git
echo " Установка графического менеджера "Pacman gui" (pamac-aur) " 
git clone https://aur.archlinux.org/pamac-all.git
cd pamac-all
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf pamac-all
rm -Rf pamac-all   # удаляем директорию сборки
echo " Графический менеджер Pamac-aur успешно установлен! "

#
# https://aur.archlinux.org/packages/pamac-all/
# Интерфейс Gtk3 для libalpm (все в одном пакете - snap, flatpak, appindicator)
# База пакета: pamac-all
# URL восходящего направления:	https://gitlab.manjaro.org/applications/pamac
# Git Clone URL: https://aur.archlinux.org/pamac-all.git  (только для чтения, нажмите, чтобы скопировать)
# Популярность:	0,86
# Первый отправленный:	2020-08-25 09:51
# Последнее обновление:	2020-09-13 14:19
#
# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps
# 
# Есть ещё один вариант Pamac-all:
# https://aur.archlinux.org/packages/pamac-all-git/
# База пакета: pamac-all-git
# URL восходящего направления:	https://gitlab.manjaro.org/applications/pamac
# Git Clone URL: https://aur.archlinux.org/pamac-all-git.git  (только для чтения, нажмите, чтобы скопировать)
# Популярность:	1.57
# Первый отправленный:	2020-08-25 10:21
# Последнее обновление:	2020-09-04 11:43
# <<< Делайте выводы сами! >>>
#