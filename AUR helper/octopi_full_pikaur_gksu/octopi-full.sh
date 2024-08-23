#!/usr/bin/env bash
# Install script octopi
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/octopi-full.sh && sh octopi-full.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git
echo " Установка Графического менеджера Octopi "
echo " Установка Утилиты alpm для Octopi "
##### alpm_octopi_utils ######
git clone https://aur.archlinux.org/alpm_octopi_utils.git
cd alpm_octopi_utils
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf alpm_octopi_utils  
rm -Rf alpm_octopi_utils
echo " Установка Octopi - Мощный интерфейс Pacman с использованием библиотек Qt5"
######### octopi #######
git clone https://aur.archlinux.org/octopi.git
cd octopi
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf octopi  
rm -Rf octopi
echo ""
echo " Графический менеджер Octopi успешно установлен! "

# ---------------------------------------------------
#  Запускать без установки:
# git clone https://github.com/actionless/pikaur.git
# cd pikaur
# python3 ./pikaur.py -S AUR_PACKAGE_NAME
# Конфигурация:
# ~ / .config / pikaur.conf
# ---------------------------------------------------
#
# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps
#
# --------------------------------------------------
# https://aur.archlinux.org/packages/octopi/
# Мощный интерфейс Pacman с использованием библиотек Qt5
# База пакета: octopi
# URL восходящего направления:	https://tintaescura.com/projects/octopi/
# Git Clone URL: https://aur.archlinux.org/octopi.git (только для чтения, нажмите, чтобы скопировать)
# Популярность:	41,46
# Первый отправленный:	2013-09-03 23:42
# Последнее обновление:	2020-08-11 20:10
 
# Зависимость для octopi:
# https://aur.archlinux.org/packages/alpm_octopi_utils/
# Утилиты alpm для Octopi
# База пакета: alpm_octopi_utils
# URL восходящего направления:	https://tintaescura.com/projects/octopi/
# Git Clone URL: https://aur.archlinux.org/alpm_octopi_utils.git (только для чтения, нажмите, чтобы скопировать)
# Популярность:	36,69
# Первый отправленный:	2016-10-21 15:33
# Последнее обновление:	2020-07-23 23:36

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

# https://aur.archlinux.org/packages/gksu/
# Графический интерфейс для su
# База пакета: gksu
# URL восходящего направления:	http://www.nongnu.org/gksu/index.html
# Git Clone URL: https://aur.archlinux.org/gksu.git (только для чтения, нажмите, чтобы скопировать)
# Популярность:	1,67
# Первый отправленный:	2018-04-23 09:43
# Последнее обновление:	2018-04-23 09:43
 
# Зависимость для gksu:
# https://aur.archlinux.org/packages/libgksu/
# библиотека авторизации libgksu
# База пакета: libgksu
# URL восходящего направления:	http://www.nongnu.org/gksu/index.html
# Git Clone URL: https://aur.archlinux.org/libgksu.git (только для чтения, нажмите, чтобы скопировать)
# Популярность:	1,22
# Первый отправленный:	2018-04-23 09:44
# Последнее обновление:	2018-04-23 09:44

# -------------------------------------------

# https://aur.archlinux.org/packages/yay/
# Йогурт (yogurt). Обертка Pacman и помощник AUR, написанные на языке go.
# База пакета: yay
# URL восходящего направления:	https://github.com/Jguer/yay
# Git Clone URL: https://aur.archlinux.org/yay.git (только для чтения, нажмите, чтобы скопировать)
# Популярность:	72.16
# Первый отправленный:	2016-10-05 17:20
# Последнее обновление:	2020-08-18 17:27

# ------------------------------------------------
# <<< Делайте выводы сами! >>>
#
