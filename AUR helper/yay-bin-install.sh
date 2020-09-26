#!/usr/bin/env bash
# Install script yay-bin
# autor: Alex Creio https://cvc.hashbase.io/

# wget git.io/yay-bin-install.sh && sh yay-bin-install.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
sudo pacman -S --noconfirm --needed wget curl git 
echo " Установка "AUR Helper" (yay-bin) "
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
# makepkg -si
# makepkg -si --noconfirm   #-не спрашивать каких-либо подтверждений
makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
rm -rf yay-bin    # удаляем директорию сборки
# rm -Rf yay-bin
echo " Установка AUR Helper (yay-bin) завершена "

echo " Если Вам не нужна зависимость go, то удалите её "
#sudo pacman -Rs go

#
# https://aur.archlinux.org/packages/yay-bin/
# Йогурт (yogurt). Обертка Pacman и помощник AUR, написанные на языке go. (версия в разработке)
# База пакета: yay-bin
# URL восходящего направления:	https://github.com/Jguer/yay
# Git Clone URL: https://aur.archlinux.org/yay-bin.git (только для чтения, нажмите, чтобы скопировать)
# Популярность:	5,37
# Первый отправленный:	2016-12-03 15:06
# Последнее обновление:	2020-08-18 17:26
#
# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps
# 
# Есть ещё один вариант yay:
# https://aur.archlinux.org/packages/yay/
# Йогурт (yogurt). Обертка Pacman и помощник AUR, написанные на языке go.
# База пакета: yay
# URL восходящего направления:	https://github.com/Jguer/yay
# Git Clone URL: https://aur.archlinux.org/yay.git (только для чтения, нажмите, чтобы скопировать)
# Популярность:	72.16
# Первый отправленный:	2016-10-05 17:20
# Последнее обновление:	2020-08-18 17:27
#
# Вот ещё один вариант yay:
# https://aur.archlinux.org/packages/yay-git/
# Еще один йогурт. Обертка Pacman и помощник AUR, написанные на языке go. (версия в разработке)
# База пакета: yay-git
# URL восходящего направления:	https://github.com/Jguer/yay
# Git Clone URL: https://aur.archlinux.org/yay-git.git (только для чтения, нажмите, чтобы скопировать)
# Популярность:	0.67
# Первый отправленный:	2018-01-29 05:52
# Последнее обновление:	2020-08-18 17:28
#
#### <<< Делайте выводы сами! >>> #######
#
