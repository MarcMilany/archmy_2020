#!/usr/bin/env bash
# Install script yay
# autor: Marc Milany https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url

# wget git.io/yay-install.sh && sh yay-install.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
sudo pacman -S --noconfirm --needed wget curl git
echo " Установка "AUR Helper" (yay) " 
git clone https://aur.archlinux.org/yay-bin.git
cd yay
# makepkg -si
makepkg -si --noconfirm   #-не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
cd ..
# rm -rf yay
rm -Rf yay-bin
echo " Установка AUR Helper (yay) завершена "

#
# https://aur.archlinux.org/packages/yay-git/
# Йогурт (yogurt). Обертка Pacman и помощник AUR, написанные на языке go. (версия в разработке)
# База пакета: yay-git
# URL восходящего направления:	https://github.com/Jguer/yay
# Git Clone URL: https://aur.archlinux.org/yay-git.git (только для чтения, нажмите, чтобы скопировать)
# Популярность:	0.67
# Первый отправленный:	2018-01-29 05:52
# Последнее обновление:	2020-08-18 17:28
#
# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps
# 
# Есть ещё один вариант snapd:
# https://aur.archlinux.org/packages/yay-git/
# Йогурт (yogurt). Обертка Pacman и помощник AUR, написанные на языке go. (версия в разработке)
# База пакета: yay-git
# URL восходящего направления:	https://github.com/Jguer/yay
# Git Clone URL: https://aur.archlinux.org/yay-git.git (только для чтения, нажмите, чтобы скопировать)
# Популярность:	0.67
# Первый отправленный:	2018-01-29 05:52
# Последнее обновление:	2020-08-18 17:28
# <<< Делайте выводы сами! >>>
#
