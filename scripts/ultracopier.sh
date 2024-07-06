#!/usr/bin/env bash
# Install script github
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/git-hub.sh && sh git-hub.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git  # Сетевая утилита для извлечения файлов из Интернета, Быстрая распределенная система контроля версий, Инструмент командной строки и библиотека для передачи данных с помощью URL-адресов.

echo""
echo " Установка Ultracopier (Ultracopier — это современное и в то же время простое в использовании портативное приложение, позволяющее пользователям копировать или перемещать файлы и папки несколькими щелчками мыши.) "
echo " Ultracopier — это бесплатное программное обеспечение с открытым исходным кодом, лицензированное под лицензией GPL3, которое заменяет диалоговые окна копирования файлов. Основные функции включают в себя: воспроизведение/пауза, ограничение скорости, возобновление работы при ошибке, управление ошибками/коллизиями. "
############ Зависимости ################
# sudo pacman -R 
# sudo pacman -R  --noconfirm 
###  --noconfirm   не спрашивать каких-либо подтверждений
### Недостающие зависимости ####
# sudo pacman -S --noconfirm --needed curl  # Инструмент командной строки и библиотека для передачи данных с помощью URL-адресов. https://archlinux.org/packages/core/x86_64/curl/
# sudo pacman -S --noconfirm --needed git  # Быстрая распределенная система контроля версий. https://archlinux.org/packages/extra/x86_64/git/
sudo pacman -S --noconfirm --needed qt5-base  # Кроссплатформенное приложение и пользовательский интерфейс. https://archlinux.org/packages/extra/x86_64/qt5-base/
sudo pacman -S --noconfirm --needed qt5-multimedia  # Классы по работе с аудио, видео, радио и камерой. https://archlinux.org/packages/extra/x86_64/qt5-multimedia/
sudo pacman -S --noconfirm --needed qt5-tools  # Кроссплатформенное приложение и инфраструктура пользовательского интерфейса (инструменты разработки, QtHelp). https://archlinux.org/packages/extra/x86_64/qt5-tools/
# sudo pacman -S --noconfirm --needed   # 
################ AUR ##############
# yay -S git-hub --noconfirm  # Интерфейс командной строки Git для GitHub. 
echo""
echo " Установка Ultracopier (копировать или перемещать файлы и папки) "
git clone https://aur.archlinux.org/ultracopier.git   # (только для чтения, нажмите, чтобы скопировать) https://aur.archlinux.org/packages/git-hub
cd ultracopier
#makepkg -fsri  
makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)  
rm -Rf ultracopier  # удаляем директорию сборки
# rm -rf ultracopier 
echo " Установка Ultracopier завершена "

# -------------------------------------------------

# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps

# ---------------------------------------------------
# URL-адрес клона Git:	https://aur.archlinux.org/ultracopier.git (только чтение, нажмите, чтобы скопировать)
# https://aur.archlinux.org/packages/ultracopier
# Ultracopier — это бесплатное программное обеспечение с открытым исходным кодом, лицензированное под лицензией GPL3, которое заменяет диалоговые окна копирования файлов. Основные функции включают в себя: воспроизведение/пауза, ограничение скорости, возобновление работы при ошибке, управление ошибками/коллизиями.
# База пакета: ultracopier
# URL восходящего направления:	https://ultracopier.first-world.info/
# Git Clone URL: https://aur.archlinux.org/ultracopier.git  (только для чтения, нажмите, чтобы скопировать)
# Лицензии:	GPL3
# Последний упаковщик: ahmedmoselhi (M8xtor)
# Голоса:	5
# Популярность:	1.01
# Первый отправленный:	2018-09-18 19:00 (UTC)
# Последнее обновление:	2023-12-02 11:21 (UTC)
# https://aur.archlinux.org/packages/github-desktop/

# <<< Делайте выводы сами! >>>
#
