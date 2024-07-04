#!/usr/bin/env bash
# Install script freeoffice
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url

# wget git.io/freeoffice-install.sh && sh freeoffice-install.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git
echo " Установка FreeOffice (офисный пакет с текстовым процессором) "
git clone https://aur.archlinux.org/freeoffice.git 
cd freeoffice 
#makepkg -fsri  
makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)  
rm -Rf freeoffice  # удаляем директорию сборки
# rm -rf freeoffice 
echo " Установка FreeOffice завершена "

# -------------------------------------------------

# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps

# ---------------------------------------------------

#
# https://aur.archlinux.org/packages/freeoffice/
# Полный, надежный, молниеносный и совместимый с Microsoft Office офисный пакет с текстовым процессором, электронными таблицами и графическим программным обеспечением для презентаций.
# База пакета: freeoffice
# URL восходящего направления:	http://www.freeoffice.com/
# Git Clone URL: https://aur.archlinux.org/freeoffice.git  (только для чтения, нажмите, чтобы скопировать)
# Популярность:	0,61
# Первый отправленный:	2013-06-12 16:27
# Последнее обновление:	2020-04-04 22:48
#
# SoftMaker FreeOffice - Лучшая бесплатная альтернатива Microsoft Office
# https://www.freeoffice.com/ru/
# <<< Делайте выводы сами! >>>
#
