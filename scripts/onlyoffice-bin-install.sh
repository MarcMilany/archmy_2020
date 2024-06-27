#!/usr/bin/env bash
# Install script onlyoffice-bin
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url

# wget git.io/onlyoffice-bin-install.sh && sh onlyoffice-bin-install.sh
# https://aur.archlinux.org/packages/onlyoffice-bin
echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git
echo " Установка OnlyOffice (офисный пакет, объединяющий редакторы текста, электронных таблиц и презентаций) "
git clone https://aur.archlinux.org/onlyoffice-bin.git 
cd onlyoffice-bin 
#makepkg -fsri  
makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)  
rm -Rf onlyoffice-bin  # удаляем директорию сборки
# rm -rf freeoffice 
echo " Установка FreeOffice завершена "

# -------------------------------------------------

# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps

# ---------------------------------------------------

#
# Детали пакета: onlyoffice-bin 8.1.0-1
# Просмотр PKGBUILD / Просмотр изменений
# URL-адрес клона Git:	https://aur.archlinux.org/onlyoffice-bin.git (только для чтения, нажмите, чтобы скопировать)
# База пакета:	onlyoffice-bin
# Описание:	Офисный пакет, объединяющий редакторы текста, электронных таблиц и презентаций.
# Восходящий URL-адрес:	https://www.onlyoffice.com/
# Лицензии:	Только AGPL-3.0
# Отправитель:	mikalair
# Сопровождающий:	dbermond (Antiz)
# Последний упаковщик: Antiz
# Голоса:	212
# Популярность:	6,98
# Впервые отправлено:	2016-11-17 12:33 (UTC)
# Последнее обновление:	20.06.2024 15:37 (UTC)
# <<< Делайте выводы сами! >>>
#
