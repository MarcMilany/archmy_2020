#!/usr/bin/env bash
# Install script github-desktop
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/github-desktop.sh && sh github-desktop.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git  # Сетевая утилита для извлечения файлов из Интернета, Быстрая распределенная система контроля версий, Инструмент командной строки и библиотека для передачи данных с помощью URL-адресов.

echo""
echo " Установка GitHub Desktop (Графического интерфейса для управления Git и GitHub) "
############ Зависимости ################
### ошибка: не удалось подготовить транзакцию (конфликтующие зависимости)
### :: nodejs-lts-iron-20.15.0-1 and nodejs-22.3.0-1 are in conflict
sudo pacman -R nodejs  # Событийный ввод-вывод для JavaScript V8. https://archlinux.org/packages/extra/x86_64/nodejs/
# sudo pacman -R nodejs --noconfirm 
###  --noconfirm   не спрашивать каких-либо подтверждений
### Недостающие зависимости ####
# sudo pacman -S --noconfirm --needed curl  # Инструмент командной строки и библиотека для передачи данных с помощью URL-адресов. https://archlinux.org/packages/core/x86_64/curl/
# sudo pacman -S --noconfirm --needed git  # Быстрая распределенная система контроля версий. https://archlinux.org/packages/extra/x86_64/git/
sudo pacman -S --noconfirm --needed libsecret  # Библиотека для хранения и извлечения паролей и других секретов. https://archlinux.org/packages/core/x86_64/libsecret/
sudo pacman -S --noconfirm --needed libxss  # Библиотека расширений X11 Screen Saver. https://archlinux.org/packages/extra/x86_64/libxss/
sudo pacman -S --noconfirm --needed nspr  # Портативная среда выполнения Netscape. https://archlinux.org/packages/core/x86_64/nspr/
sudo pacman -S --noconfirm --needed nss  # Службы сетевой безопасности. https://archlinux.org/packages/core/x86_64/nss/
sudo pacman -S --noconfirm --needed keepassxc  # Кроссплатформенный порт менеджера паролей Keepass, управляемый сообществом. https://archlinux.org/packages/extra/x86_64/keepassxc/
sudo pacman -S --noconfirm --needed unzip  # Для извлечения и просмотра файлов в архивах .zip . https://archlinux.org/packages/extra/x86_64/unzip/
sudo pacman -S --noconfirm --needed nodejs-lts-iron  # Событийный ввод-вывод для V8 javascript (выпуск LTS: Iron). https://archlinux.org/packages/extra/x86_64/nodejs-lts-iron/
sudo pacman -S --noconfirm --needed npm  # Менеджер пакетов для JavaScript. https://archlinux.org/packages/extra/any/npm/
sudo pacman -S --noconfirm --needed xorg-server-xvfb  # X-сервер виртуального фреймбуфера. https://archlinux.org/packages/extra/x86_64/xorg-server-xvfb/
sudo pacman -S --noconfirm --needed yarn  # Быстрое, надежное и безопасное управление зависимостями. https://archlinux.org/packages/extra/any/yarn/
sudo pacman -S --noconfirm --needed github-cli  # Интерфейс командной строки GitHub. https://archlinux.org/packages/extra/x86_64/github-cli/
sudo pacman -S --noconfirm --needed hub  # cli-интерфейс для Github. https://archlinux.org/packages/extra/x86_64/hub/
################ AUR ##############
# yay -S keepassxc-allow-aur-extension-origin --noconfirm  # Кроссплатформенный порт менеджера паролей Keepass, управляемый сообществом. https://aur.archlinux.org/packages/keepassxc-allow-aur-extension-origin
######### keepassxc-allow-aur-extension-origin  ###############
git clone https://aur.archlinux.org/keepassxc-allow-aur-extension-origin.git  # (только для чтения, нажмите, чтобы скопировать)
cd keepassxc-allow-aur-extension-origin 
#makepkg -fsri  
makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)  
rm -Rf keepassxc-allow-aur-extension-origin  # удаляем директорию сборки
# rm -rf keepassxc-allow-aur-extension-origin 
############# GitHub Desktop ################
git clone https://aur.archlinux.org/github-desktop.git  # (только для чтения, нажмите, чтобы скопировать) 
cd github-desktop 
#makepkg -fsri  
makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)  
rm -Rf github-desktop  # удаляем директорию сборки
# rm -rf github-desktop 
echo " Установка GitHub Desktop завершена "

# -------------------------------------------------

# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps

# ---------------------------------------------------

#
# https://aur.archlinux.org/packages/github-desktop/
# Графический интерфейс для управления Git и GitHub.
# База пакета: github-desktop
# URL восходящего направления:	https://desktop.github.com
# Git Clone URL: https://aur.archlinux.org/github-desktop.git  (только для чтения, нажмите, чтобы скопировать)
# Популярность:	1,59
# Первый отправленный:	2017-07-22 21:26
# Последнее обновление:	2020-09-14 00:41

# https://aur.archlinux.org/packages/git-hub/
# Интерфейс командной строки Git для GitHub
# База пакета: github
# URL восходящего направления:	https://github.com/sociantic-tsunami/git-hub
# Git Clone URL: https://aur.archlinux.org/git-hub.git  (только для чтения, нажмите, чтобы скопировать)
# Популярность:	0,000000
# Первый отправленный:	2013-09-20 14:24
# Последнее обновление:	2020-01-15 10:44

# <<< Делайте выводы сами! >>>
#
