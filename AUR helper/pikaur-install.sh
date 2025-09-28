#!/usr/bin/env bash
# Install script pikaur
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/pikaur-install.sh && sh pikaur-install.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git
echo " Установка "AUR Helper" (pikaur) "
echo " Важно (обратить внимание)! Pikaur - идёт как зависимость для Octopi (необязательно). "
# Помощник AUR, который задает все вопросы перед установкой / сборкой. В духе pacaur, yaourt и yay.
git clone https://aur.archlinux.org/pikaur.git
cd pikaur 
#makepkg -fsri  
makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)  
rm -Rf pikaur  # удаляем директорию сборки
# rm -rf pikaur 
echo " Установка AUR Helper (pikaur) завершена "

# ---------------------------------------------------
#  Запускать без установки:
# git clone https://github.com/actionless/pikaur.git
# cd pikaur
# python3 ./pikaur.py -S AUR_PACKAGE_NAME
# Конфигурация:
# ~ / .config / pikaur.conf
# ---------------------------------------------------

# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps

# ---------------------------------------------------

# Зависимость для octopi: pikaur ( pikaur-git ) (необязательно) - для поддержки AUR
# trizen ( trizen-git ) (необязательно) - для поддержки AUR
# yay ( yay-bin , yay-git , yayim ) (необязательно) - для поддержки AUR
# https://aur.archlinux.org/packages/pikaur/
# https://aur.archlinux.org/packages/trizen/
# https://aur.archlinux.org/packages/yay/
# Помощник AUR, который задает все вопросы перед установкой / сборкой. В духе pacaur, yaourt и yay.
# База пакета: pikaur
# URL восходящего направления:	https://github.com/actionless/pikaur
# Git Clone URL: https://aur.archlinux.org/pikaur.git (только для чтения, нажмите, чтобы скопировать)
# Популярность:	5,52
# Первый отправленный:	2018-03-24 23:58
# Последнее обновление:	2020-09-24 17:00
# ------------------------------------------------
#
# https://aur.archlinux.org/packages/yay/
# Йогурт (yogurt). Обертка Pacman и помощник AUR, написанные на языке go.
# База пакета: yay
# URL восходящего направления:	https://github.com/Jguer/yay
# Git Clone URL: https://aur.archlinux.org/yay.git (только для чтения, нажмите, чтобы скопировать)
# Популярность:	72.16
# Первый отправленный:	2016-10-05 17:20
# Последнее обновление:	2020-08-18 17:27

# Есть ещё один вариант yay:
# https://aur.archlinux.org/packages/yay-git/
# Йогурт (yogurt). Обертка Pacman и помощник AUR, написанные на языке go. (версия в разработке)
# База пакета: yay-git
# URL восходящего направления:	https://github.com/Jguer/yay
# Git Clone URL: https://aur.archlinux.org/yay-git.git (только для чтения, нажмите, чтобы скопировать)
# Популярность:	0.67
# Первый отправленный:	2018-01-29 05:52
# Последнее обновление:	2020-08-18 17:28
# --------------------------------------
# <<< Делайте выводы сами! >>>
#
