#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

ARCHMY4_LANG="russian"  # Installer default language (Язык установки по умолчанию)

script_path=$(readlink -f ${0%/*})

umask 0022 # Определение окончательных прав доступа
# Для суперпользователя (root) umask по умолчанию равна 0022
#echo ""
#echo "########################################################################"
#echo "######    <<<Arch Linux Fast Install LegasyBIOS (arch2020)>>>     ######"
#echo "####    Скрипты 'arch_2020' созданы на основе сценария (скрипта)    ####"
#echo "#### 'ordanax/arch2018'. Скрипт (сценарий) archmy4 является         ####"
#echo "#### продолжением скриптов (archmy1,archmy2 и archmy3) из серии     ####"
#echo "#### 'arch_2020'. Для установки системы Arch'a' на PC (LegasyBIOS)  ####"
#echo "#### с DE - рабочего стола Xfce.                                    ####"
#echo "### В сценарии (скрипта) archmy4 прописана установка первоначально  ####" 
#echo "#### необходимого софта (пакетов) и запуск необходимых служб.       ####"      
#echo "#### При выполнении скрипта Вы получаете возможность быстрой        ####" 
#echo "#### установки программ (пакетов) с вашими личными настройками      ####"
#echo "#### (при условии, что Вы его изменили под себя, в противном случае ####"       
#echo "#### с моими настройками).                                   ###########"  
#echo "#### Этот скрипт находится в процессе 'Внесение поправок в   ####"
#echo "#### наводку орудий по результатам наблюдений с наблюдате-   ####"
#echo "#### льных пунктов'.                                         ####"
#echo "#### Автор не несёт ответственности за любое нанесение вреда ####"
#echo "#### при использовании скрипта.                              ####"
#echo "#### Installation guide - Arch Wiki  (referance):            ####"
#echo "#### https://wiki.archlinux.org/index.php/Installation_guide ####"
#echo "#### Проект (project): https://github.com/ordanax/arch2018   ####"
#echo "#### Лицензия (license): LGPL-3.0                            ####" 
#echo "#### (http://opensource.org/licenses/lgpl-3.0.html           ####"
#echo "#### В разработке принимали участие (author) :               ####"
#echo "#### Алексей Бойко https://vk.com/ordanax                    ####"
#echo "#### Степан Скрябин https://vk.com/zurg3                     ####"
#echo "#### Михаил Сарвилин https://vk.com/michael170707            ####"
#echo "#### Данил Антошкин https://vk.com/danil.antoshkin           ####"
#echo "#### Юрий Порунцов https://vk.com/poruncov                   ####"
#echo "#### Jeremy Pardo (grm34) https://www.archboot.org/          ####"
#echo "#### Marc Milany - 'Не ищи меня 'Вконтакте',                 ####"
#echo "####                в 'Одноклассниках'' нас нету, ...        ####"
#echo "#### Releases ArchLinux:                                     ####"
#echo "####    https://www.archlinux.org/releng/releases/           ####"
#echo "#### <<<       Смотрите пометки в самом скрипте!         >>> ####" 
#echo "#################################################################"
#echo ""
#sleep 4
#clear
#echo ""

set -e "\n${RED}Error: ${YELLOW}${*}${NC}"  # Эта команда остановит выполнение сценария после сбоя команды и будет отправлен код ошибки

###################################################################

### Help and usage (--help or -h) (Справка)
_help() {
    echo -e "${BLUE}
Installation guide - Arch Wiki
${BOLD}For more information, see the wiki: \
${GREY}<https://wiki.archlinux.org/index.php/Installation_guide>${NC}"
}

### SHARED VARIABLES AND FUNCTIONS (ОБЩИЕ ПЕРЕМЕННЫЕ И ФУНКЦИИ)
### Shell color codes (Цветовые коды оболочки)
RED="\e[1;31m"; GREEN="\e[1;32m"; YELLOW="\e[1;33m"; GREY="\e[3;93m"
BLUE="\e[1;34m"; CYAN="\e[1;36m"; BOLD="\e[1;37m"; MAGENTA="\e[1;35m"; NC="\e[0m"

### Automatic error detection (Автоматическое обнаружение ошибок)
_set() {
    set [--abefhkmnptuvxBCHP] [-o option] [arg ...]
}

_set() {
    set -e "\n${RED}Error: ${YELLOW}${*}${NC}"
    _note "${MSG_ERROR}"
    sleep 1; $$
}

### Display install steps (Отображение шагов установки)
_info() {
    echo -e "${YELLOW}\n==> ${CYAN}${1}...${NC}"; sleep 1
}
  
### Download show progress bar only (Скачать показывать только индикатор выполнения)
_wget() {
    wget "${1}" --quiet --show-progress
}

### Execute action in chrooted environment (Выполнение действия в хромированной среде)
_chroot() {
    arch-chroot /mnt <<EOF "${1}"
EOF
}

###################################################################
### Warning (Предупреждение)
_warning_banner() {
    echo -e "${YELLOW}
   ====================== ♥ Предупреждение ======================  
${NC}
Цель сценария (скрипта) - это установка необходимого софта (пакетов) и запуск необходимых служб. 
Смысл в том, что все изменения вы делаете предварительно в самом скрипте и получаете возможность быстрой установки утилит (пакетов), которые Вы решили установить (при условии, что Вы его изменили под себя, в противном случае скрипт установит софт (пакеты) прописанный изначально.
В процессе работы сценария (скрипта) Вам будут задаваться вопросы на установку той, или иной утилиты (пакета) - будьте внимательными! Устанавливаемый софт (пакеты), шрифты - скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. Так же присутствует софт (пакеты), шрифты - устанавливаемый из пользовательского репозитория 'AUR'-'yay', собираются и устанавливаются. Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска необходимых служб. В любой ситуации выбор всегда за вами. Вы либо гуляете под дождем, либо просто под ним мокнете.${RED}

  ***************************** ВНИМАНИЕ! ***************************** 
${NC}
Автор не несёт ответственности за любое нанесение вреда при использовании скрипта. 
Вы используйте его на свой страх и риск, или изменяйте под свои личные нужды. 
В данный момент сценарий (скрипта) находится в процессе доработки по прописанию устанавливаемого софта (пакетов), и небольшой корректировке (Воен. Внесение поправок в наводку орудий по результатам наблюдений с наблюдательных пунктов)."

}

# ============================================================================

### Display banner (Дисплей баннер)
_warning_banner

sleep 7
echo -e "${GREEN}
  <<< Начинается установка утилит (пакетов) для системы Arch Linux >>>
${NC}"
# Installation of utilities (packages) for the Arch Linux system begins

echo -e "${BLUE}:: ${NC}Установка и настройка начата в $(date +%T)" 
#echo "Установка и настройка начата в $(date +%T)"
# Installation and configuration started in $(date +%T)

echo -e "${GREEN}=> ${NC}Для проверки интернета можно пропинговать какой-либо сервис"
#echo 'Для проверки интернета можно пропинговать какой-либо сервис'
# To check the Internet, you can ping a service
ping -c2 archlinux.org

#echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов" 
#echo 'Обновим базы данных пакетов'
# Updating the package databases
#sudo pacman-key --init
#sudo pacman-key --refresh-keys
sudo pacman -Sy  

#----------------------------------------------------------------------------
# Знакомьтесь, pacman - лучший пакетный менеджер в мире линукса!
#pacman -Syy   - обновление баз пакмэна(как apt-get update в дэбианоподбных)
#pacman -Syyu  - обновление баз плюс обновление пакетов
#----------------------------------------------------------------------------
# Если возникли проблемы с обновлением, или установкой пакетов 
# Выполните данные рекомендации:
# author:
#echo 'Обновление ключей системы'
# Updating of keys of a system
#{
#echo "Создаётся генерация мастер-ключа (брелка) pacman, введите пароль (не отображается)..."
#sudo pacman-key --init
#echo "Далее идёт поиск ключей..."
#sudo pacman-key --populate archlinux
#echo "Обновление ключей..."
#sudo pacman-key --refresh-keys
#echo "Обновление баз данных пакетов..."
#sudo pacman -Sy
#}
#sleep 1
#
# Или:
#sudo pacman-key --init && sudo pacman-key --populate archlinux && sudo pacman-key --refresh-keys && sudo pacman -Sy
###################################
Получение и обновление новых ключей аутентификации
#Obtain and refresh new Authentication keys.

sudo rm -r /etc/pacman.d/gnupg  
sudo pacman-key --init  
sudo pacman-key --populate archlinux
sudo pacman-key --refresh-keys
#sudo pacman -S archlinux-keyring
###  sudo pacman -S archlinux-keyring  # (обновление пакета ключей подписи)
### sudo pacman -Sy archlinux-keyring
sudo pacman -S seahorse  # Приложение GNOME для управления ключами PGP (управления паролями и ключами шифрования)
sudo pacman -Syyu
# =========================================

echo 'Создадим папку (downloads), и переходим в созданную папку'
# Create a folder (downloads), and go to the created folder
#rm -rf ~/.config/xfce4/*
mkdir ~/downloads
cd ~/downloads

echo 'Установка Мультимедиа утилит AUR'
# 
echo -e "${BLUE}
'Список Мультимедиа утилит AUR:${GREEN}
 spotify vlc-tunein-radio vlc-pause-click-plugin audiobook-git cozy-audiobooks m4baker-git mp3gain easymp3gain-gtk2 myrulib-git'
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
 


yay -S audiobook-git --noconfirm  # Простая программа для чтения аудиокниг. Написано на QT / QML и C ++
yay -S cozy-audiobooks --noconfirm  # Современный проигрыватель аудиокниг для Linux с использованием GTK + 3

yay -S mp3gain --noconfirm  # Нормализатор mp3 без потерь со статистическим анализом
yay -S easymp3gain-gtk2 --noconfirm  # Графический интерфейс пользователя (GUI) GTK2 для MP3Gain, VorbisGain и AACGain

yay -S m4baker-git --noconfirm  # Создавайте полнофункциональные m4b-аудиокниги (Собирается пакет долго!)
yay -S myrulib-git --noconfirm  # Домашняя библиотека с поддержкой сайта lib.rus.ec
yay -S  --noconfirm   
yay -S  --noconfirm
yay -S  --noconfirm
yay -S  --noconfirm
yay -S  --noconfirm


elif [[ $prog_set == 0 ]]; then
  echo 'Установка Мультимедиа утилит AUR пропущена.'
fi



#############################
 echo " Установка дополнительных мультимедиа кодеков и утилит (пакетов) "
#options+=("gst-plugin-libde265" "(AUR)" off)
#options+=("libde265" "(AUR)" off)

sudo pacman -S libde265 --noconfirm  # Открытая реализация видеокодека h.265
https://archlinux.org/packages/extra/x86_64/libde265/
https://github.com/strukturag/libde265

yay -S gst-plugin-libde265 --noconfirm  # Плагин Libde265 (открытая реализация видеокодека h.265) для gstreamer
https://aur.archlinux.org/packages/gst-plugin-libde265/
https://aur.archlinux.org/gst-plugin-libde265.git
https://github.com/strukturag/gstreamer-libde265

yay -S libde265-git --noconfirm  # Открытая реализация видеокодека H.265 (версия git)
https://aur.archlinux.org/packages/libde265-git/
https://aur.archlinux.org/libde265-git.git 
https://github.com/strukturag/libde265/

yay -S lib32-libde265 --noconfirm  # Открытая реализация видеокодека h.265 (32-разрядная версия)
https://aur.archlinux.org/packages/lib32-libde265/
https://aur.archlinux.org/lib32-libde265.git
https://github.com/strukturag/libde265


#yay -S bluez-firmware --noconfirm  # Прошивки для чипов Bluetooth Broadcom BCM203x и STLC2300
#yay -S pulseaudio-ctl --noconfirm  # Управляйте громкостью pulseaudio из оболочки или с помощью сочетаний клавиш

gst-plugin-libde265  -  # Плагин Libde265 (открытая реализация видеокодека h.265) для gstreamer
https://aur.archlinux.org/packages/gst-plugin-libde265/
https://aur.archlinux.org/gst-plugin-libde265.git 
https://github.com/strukturag/gstreamer-libde265

# libde265  -  #  ???
libde265-git  -  # Открытая реализация видеокодека H.265 (версия git)
https://aur.archlinux.org/packages/libde265-git/
https://aur.archlinux.org/libde265-git.git
https://github.com/strukturag/libde265/

lib32-libde265 --noconfirm  # Открытая реализация видеокодека h.265 (32-разрядная версия)
https://aur.archlinux.org/packages/lib32-libde265/
https://aur.archlinux.org/lib32-libde265.git 
https://github.com/strukturag/libde265



##################################
youtube-dl -  # Программа командной строки для загрузки видео с YouTube.com и еще нескольких сайтов
https://archlinux.org/packages/community/any/youtube-dl/
https://ytdl-org.github.io/youtube-dl/

youtube-dl-gui-git -  # Кросс-платформенный интерфейсный интерфейс популярного youtube-dl, написанный на wxPython
https://aur.archlinux.org/packages/youtube-dl-gui-git/
https://aur.archlinux.org/youtube-dl-gui-git.git 
https://github.com/MrS0m30n3/youtube-dl-gui

------------------------------------------

audiobook-git  -  # Простая программа для чтения аудиокниг. Написано на QT / QML и C ++ 
https://aur.archlinux.org/packages/audiobook-git/
https://aur.archlinux.org/audiobook-git.git 
https://github.com/bit-shift-io/audiobook

----------------------------------------------

cozy-audiobooks  -  # Современный проигрыватель аудиокниг для Linux с использованием GTK + 3
https://aur.archlinux.org/packages/cozy-audiobooks/
https://aur.archlinux.org/cozy-audiobooks.git
https://github.com/geigi/cozy

cosy-audiobooks-git  -  # Современный проигрыватель аудиокниг для Linux и macOS с использованием GTK + 3
https://aur.archlinux.org/packages/cozy-audiobooks-git/
https://aur.archlinux.org/cozy-audiobooks-git.git
https://cozy.geigi.de

------------------------------------------------

m4baker-git  -  # Создавайте полнофункциональные m4b-аудиокниги
m4baker-git   - # Сначала (Phonon-qt4 pyqt4-common python2-pyqt4)
https://aur.archlinux.org/packages/m4baker-git/
https://aur.archlinux.org/m4baker-git.git
https://github.com/crabmanX/m4baker

phonon-qt4 -  # Мультимедийный фреймворк для KDE4
https://aur.archlinux.org/packages/phonon-qt4/
https://aur.archlinux.org/phonon-qt4.git 
https://community.kde.org/Phonon

pyqt4-common -  # Общие файлы PyQt, общие для python-pyqt4 и python2-pyqt4
https://aur.archlinux.org/packages/pyqt4-common/
https://aur.archlinux.org/pyqt4.git 
https://riverbankcomputing.com/software/pyqt/intro

qt4 -  # Кроссплатформенное приложение и фреймворк пользовательского интерфейса
https://aur.archlinux.org/packages/qt4/
https://aur.archlinux.org/qt4.git 
https://www.qt.io
==> Установка недостающих зависимостей...
разрешение зависимостей...
проверка конфликтов...

Пакеты (1) unixodbc-2.3.9-1

sudo pacman -S unixodbc --noconfirm  # ODBC - это открытая спецификация для предоставления разработчикам приложений предсказуемого API для доступа к источникам данных

unixodbc  -  # ODBC - это открытая спецификация для предоставления разработчикам приложений предсказуемого API для доступа к источникам данных
https://archlinux.org/packages/core/x86_64/unixodbc/
http://www.unixodbc.org/


python2-pyqt4 -  # Набор привязок Python 2.x для набора инструментов Qt
https://aur.archlinux.org/packages/python2-pyqt4/
https://aur.archlinux.org/pyqt4.git 
https://riverbankcomputing.com/software/pyqt/intro


------------------------------------------------

mp3gain  -  # Нормализатор mp3 без потерь со статистическим анализом
https://aur.archlinux.org/packages/mp3gain/
https://aur.archlinux.org/mp3gain.git 
https://sourceforge.net/projects/mp3gain/

------------------------------------------------

easymp3gain-gtk2  -  # Графический интерфейс пользователя (GUI) GTK2 для MP3Gain, VorbisGain и AACGain
https://aur.archlinux.org/packages/easymp3gain-gtk2/
https://aur.archlinux.org/easymp3gain-gtk2.git
http://easymp3gain.sourceforge.net/

------------------------------------------------

myrulib-git  -  # Домашняя библиотека с поддержкой сайта lib.rus.ec
myrulib-git   - # Сначала (wxgtk2.8 wxsqlite3-2.8 gstreamer0.10  0.10.36-17)
https://aur.archlinux.org/packages/myrulib-git/
https://aur.archlinux.org/myrulib-git.git 
http://www.lintest.ru/wiki/MyRuLib


myrulib-git    wxgtk2.8 wxsqlite3-2.8 gstreamer0.10  0.10.36-17
expat (expat-git)
wxgtk2.8 (wxgtk2.8-light)
wxsqlite3-2.8
git+https://github.com/lintest/myrulib.git

expat -  # Библиотека парсера XML
https://archlinux.org/packages/core/x86_64/expat/
https://libexpat.github.io/

expat (expat-git) -  # Библиотека потокового анализатора XML, написанная на C
https://aur.archlinux.org/packages/expat-git/
https://aur.archlinux.org/expat-git.git 
https://libexpat.github.io/

wxgtk2.8 -  # GTK + реализация wxWidgets API для GUI
https://aur.archlinux.org/packages/wxgtk2.8/
https://aur.archlinux.org/wxgtk2.8.git 
http://wxwidgets.org

wxgtk2.8-light -  # wxWidgets 2.8 с GTK2 Toolkit (GNOME / GStreamer бесплатно!)
https://aur.archlinux.org/packages/wxgtk2.8-light/
https://aur.archlinux.org/wxwidgets2.8-light.git 
http://wxwidgets.org

wxsqlite3 -  # Обертка wxWidgets для SQLite3, сборка для wxWidgets 2.8
https://aur.archlinux.org/packages/wxsqlite3-2.8/
https://aur.archlinux.org/wxsqlite3-2.8.git 
http://wxcode.sourceforge.net/components/wxsqlite3/

gstreamer0.10 -  # Мультимедийный фреймворк GStreamer
https://aur.archlinux.org/packages/gstreamer0.10/
https://aur.archlinux.org/gstreamer0.10.git
https://gstreamer.freedesktop.org


############ gstreamer0.10 ##########
echo "" 
echo " Установим мультимедийный фреймворк GStreamer из AUR "
#yay -S gstreamer0.10 --noconfirm  # Мультимедийный фреймворк GStreamer (Если установлен yay - эта команда)
git clone https://aur.archlinux.org/gstreamer0.10.git 
cd gstreamer0.10
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gstreamer0.10 
rm -Rf gstreamer0.10
#######################

-------------------------------------

yay -S mocicon --noconfirm  # Апплет панели GTK, позволяющий управлять MOC (Music On Console)
https://aur.archlinux.org/packages/mocicon/
https://aur.archlinux.org/mocicon.git
http://mocicon.sourceforge.net

mocicon  -  # Апплет панели GTK, позволяющий управлять MOC (Music On Console)
https://aur.archlinux.org/packages/mocicon/
https://aur.archlinux.org/mocicon.git 
http://mocicon.sourceforge.net

-------------------------------------
Опции makepkg:
-s/--syncdeps перед сборкой автоматически разрешает и устанавливает все зависимости с pacman. Если пакет зависит от других пакетов из AUR, вам нужно сначала установить их вручную.
-i/--install установить пакет если он успешно собран. В качестве альтернативы собранный пакет может быть установлен с pacman -U.
Другие полезные флаги для makepkg:

-r/--rmdeps после завершения сборки, удаляет зависимости, нужные на время сборки, поскольку после этого они не нужны. Тем не менее, эти зависимости могут понадобиться при переустановки или обновлении этого пакета в следующий раз.
-c/--clean очищает временные файлы сборки после окончания сборки, поскольку они больше не нужны. Эти файлы обычно нужны только для отладки процесса сборки.
https://blackarch.ru/?p=794
---------------------------------------

fetchmirrors -  # Утилита обновления зеркального списка Arch Linux pacman (Получение и ранжирование нового зеркального списка pacman)
https://aur.archlinux.org/packages/fetchmirrors/
https://aur.archlinux.org/fetchmirrors.git 
https://github.com/deadhead420/fetchmirrors
https://raw.githubusercontent.com/deadhead420/fetchmirrors/master/fetchmirrors.sh

----------------------------------------
Смена оболочки

echo -e "${MAGENTA}=> ${BOLD}Вот какая оболочка (shell) используется в данный момент: ${NC}"
echo $SHELL
echo "" 

Для смены оболочки на ZSH введите в терминале следующее: chsh -s /bin/zsh.

Для смены оболочки на BASH введите в терминале следующее: chsh -s /bin/bash.

echo ""
echo " Пользовательская оболочка (shell) НЕ изменена, по умолчанию остаётся BASH "
elif [[ $t_shell == 1 ]]; then
chsh -s /bin/zsh
chsh -s /bin/zsh $username
clear
echo ""
echo " Важно! При первом запуске консоли (терминала) - нажмите "0" "
echo " Пользовательская оболочка ИЗМЕНЕНА (сразу будет), с BASH на на ZSH "

################################################


clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Kleopatra (это графический интерфейс для GnuPG)?" 
echo -e "${CYAN}:: Предисловие! ${NC}С появлением библиотеки GCrypt-1.7.0 с поддержкой российской криптографии (ГОСТ 28147-89, ГОСТ Р 34.11-94/2012 и ГОСТ Р 34.10-2001/2012), стало возможным говорить о поддержке российского PKI в таких проектах как Kleopatra и KMail."
echo -e "${MAGENTA}:: ${BOLD}Kleopatra - это многофункциональное C++ / QT / KDE (kcmutils / kmime) графическое приложение позволяющее подписывать и шифровать файлы, а также обеспечивает создание, хранение и управление сертификатами и ключами шифрования. ${NC}"
echo -e "${MAGENTA}=> ${NC}Kleopatra разрабатывается как часть рабочего окружения KDE (KDE Applications / KDE Utilities), поддерживает управление сертификатами X.509 и OpenPGP в ключах шифрования GnuPG (GPG), основные возможности приложения реализованы на криптографической библиотеке libkleo (KDE PIM cryptographic library), использующей функционал GnuPG Made Easy (GPGME)."
echo " GPG / GnuPG (GNU Privacy Guard) - консольная утилита для шифрования информации и создания электронных цифровых подписей с помощью различных алгоритмов (RSA, DSA, AES и др...). Утилита создана как свободная альтернатива проприетарному PGP (Pretty Good Privacy) и полностью совместима с стандартом IETF OpenPGP (может взаимодействовать с PGP и другими OpenPGP-совместимыми системами). " 
echo -e "${YELLOW}:: Примечание! ${NC}Для полноценной работы Kleopatra необходимо наличие хотя бы одной пары ключей, при первом запуске приложением автоматически сканируются каталоги в которых "по умолчанию" находятся ключи GPG (~/.gnupg и пр). Поддерживается импорт сертификатов из файлов множества наиболее распространённых форматов (*.acs, *.cer, *.crt, *.pem, *.pfx и др)."
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_kleopatra  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_kleopatra" =~ [^10] ]]
do
    :
done 
if [[ $i_kleopatra == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_kleopatra == 1 ]]; then
  echo ""  
  echo " Установка Kleopatra "
sudo pacman -S kleopatra --noconfirm  # Диспетчер сертификатов и унифицированный графический интерфейс криптографии  
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
# -----------------------------------
# Ссылки: 
# https://github.com/KDE/kleopatra
# https://zenway.ru/page/kleopatra
# https://habr.com/ru/post/316736/ (Сказание о Клеопатре и о российской криптографии)
# Шифрование с помощью GnuPG для пользователей:
# https://jenyay.net/blog/2012/01/04/shifrovanie-s-pomoshhyu-gnupg-dlya-polzovatelejj/
# https://ru.wikipedia.org/wiki/GnuPG
#------------------------------------

#########################################


echo 'Установка программ для обработки видео и аудио (конвертеры)'
# Installing software for video and audio processing (converters)
sudo pacman -S kdenlive --noconfirm

echo 'Установка программ для обработки видео и аудио (конвертеры) AUR'
# Installing software for video and audio processing (converters) AUR
yay -S  --noconfirm

echo 'Установка программ для рисования и редактирования изображений'
# Installing software for drawing and editing images
sudo pacman -S gimp --noconfirm
sudo pacman -S gimp --noconfirm  # Программа обработки изображений GNU
sudo pacman -S gimp-help-en --noconfirm  # Английские файлы справки для GIMP
sudo pacman -S gimp-help-ru --noconfirm  # Русские файлы справки для GIMP
sudo pacman -S pinta --noconfirm  # Программа для рисования / редактирования по образцу Paint.NET. Его цель - предоставить упрощенную альтернативу GIMP для обычных пользователей
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 


echo 'Установка программ для рисования и редактирования изображений AUR'
# Installing software for drawing and editing images AUR
yay -S  --noconfirm
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 

echo 'Установка программ для просмотра изображений'
sudo pacman -S viewnior --noconfirm  # Простая, быстрая и элегантная программа просмотра изображений
sudo pacman -S feh --noconfirm  # Быстрый и легкий просмотрщик изображений на основе imlib2
sudo pacman -S  --noconfirm  # 
sudo pacman -S eog --noconfirm  # Eye of Gnome: программа для просмотра и каталогизации изображений
sudo pacman -S eog-plugins --noconfirm  # Плагины для Eye of Gnome

echo 'Установка программ для просмотра изображений AUR'
yay -S  --noconfirm
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
yay -S  --noconfirm  #
yay -S  --noconfirm  # 

echo 'Установка Oracle VM VirtualBox'
# Installing Oracle VM VirtualBox 
sudo pacman -S virtualbox --noconfirm  # Мощная виртуализация x86 как для корпоративного, так и для домашнего использования
#sudo pacman -S virtualbox-host-modules-arch --noconfirm  # для ядра linux - Модули ядра хоста Virtualbox для Arch Kernel
sudo pacman -S virtualbox-host-dkms --noconfirm  # для других ядер - Источники модулей ядра VirtualBox Host
#sudo pacman -S linux-headers --noconfirm  # Заголовки и скрипты для сборки модулей для ядра Linux
sudo pacman -S linux-lts-headers --noconfirm  # Заголовки и скрипты для сборки модулей для ядра Linux-LTC

sudo pacman -S  --noconfirm
# Затем загрузите драйвер Vbox с помощью этой команды:
sudo modprobe vboxdrv  # Загрузка модулей
# sudo modprobe -a vboxguest vboxsf vboxvideo
# Чтобы предоставить себе разрешения для доступа virtualbox к общим папкам и USB устройствам используйте эту команду:     
# sudo gpasswd -a имя_пользователя vboxusers
sudo gpasswd -a $USER vboxusers
#sudo gpasswd -a $username vboxusers
#sudo gpasswd -a alex vboxusers
# Чтобы загрузить модуль VirtualBox во время загрузки, обратитесь к разделу Kernel_modules#Loading и создайте файл *.conf со строкой:
sed -i 'vboxdrv' /etc/modules-load.d/virtualbox.conf
#echo "vboxdrv" > /etc/modules-load.d/virtualbox.conf
# в расположении (in location)
# /etc/modules-load.d/virtualbox.conf

# Общая директория, на машине
mkdir ~/vboxshare
# Общая директория, на виртуалке
#mkdir ~/vboxshare
#sudo mount -t vboxsf -o rw,uid=1000,gid=1000 vboxshare vboxshare

# Настройка гостевых дополнений на виртуалке.
#sudo pacman -S virtualbox-guest-utils --noconfirm # Утилиты пользовательского пространства VirtualBox Guest
#sudo pacman -S linux-headers --noconfirm # Заголовки и скрипты для сборки модулей для ядра Linux
#sudo pacman -S virtualbox-guest-dkms --noconfirm # Исходники модулей ядра VirtualBox Guest
#sudo pacman -S virtualbox-guest-iso --noconfirm # Официальный ISO-образ VirtualBox Guest Additions
# -------------------------
# Arch Wiki Virtualbox 
# https://wiki.archlinux.org/index.php/VirtualBox_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# ===============================
virtualbox 6.1.12-4
virtualbox-ext-oracle 6.1.13.140091-1
virtualbox-ext-vnc 6.1.12-4
virtualbox-guest-iso 6.1.12-1
virtualbox-guest-utils 6.1.12-4
virtualbox-host-modules-arch 6.1.12-14

##############################
echo 'Установка Oracle VM VirtualBox AUR'
# Installing Oracle VM VirtualBox AUR
yay -S virtualbox-ext-oracle --noconfirm  # Пакет расширений Oracle VM VirtualBox
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 

virtualbox-ext-oracle  -  # Пакет расширений Oracle VM VirtualBox
https://aur.archlinux.org/packages/virtualbox-ext-oracle/
https://aur.archlinux.org/virtualbox-ext-oracle.git 
https://www.virtualbox.org/

echo 'Установка Java JDK средство разработки и среда для создания Java-приложений'
# Installing Java JDK development tool and environment for creating Java applications
sudo pacman -S jdk8-openjdk jre8-openjdk jre8-openjdk-headless --noconfirm
sudo pacman -S jdk8-openjdk --noconfirm  # Комплект разработчика OpenJDK Java 8
sudo pacman -S jre8-openjdk --noconfirm  # Полная среда выполнения OpenJDK Java 8
sudo pacman -S jre8-openjdk-headless --noconfirm  # 
sudo pacman -S  --noconfirm  # OpenJDK Java 8 автономная среда выполнения
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 

echo 'Установка Java JDK или Java Development Kit AUR'
# Installing Java JDK development tool and environment for creating Java applications AUR
yay -S  --noconfirm

echo 'Сетевые онлайн хранилища'
# Online storage networks
sudo pacman -S --noconfirm
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 

echo 'Сетевые онлайн хранилища AUR'
# Online storage networks AUR
yay -S megasync thunar-megasync yandex-disk yandex-disk-indicator dropbox --noconfirm

echo 'Утилиты для редактирования документов, PDF, DjVus, NFO, DIZ и XPS... , Читалки электронных книг, Словари, Таблицы'
# Utilities for editing documents, PDF, Djvu, NFO, DIZ and XPS..., e-book Readers, Dictionaries, Tables
sudo pacman -S qpdfview --noconfirm  # Просмотрщик PDF с вкладками, использующий библиотеку poppler
sudo pacman -S python-reportlab --noconfirm  # Проверенное надежное решение для создания PDF-файлов
sudo pacman -S evince --noconfirm  # Программа просмотра документов (PDF, Postscript, djvu, tiff, dvi, XPS, поддержка SyncTex с gedit, комиксы (cbr, cbz, cb7 и cbt))
sudo pacman -S antiword --noconfirm  # Community - Бесплатная программа для чтения MS Word для Linux и RISC OS
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 
sudo pacman -S djvulibre --noconfirm  # Пакет для создания, управления и просмотра документов DjVu ('дежавю')
sudo pacman -S calibre --noconfirm  # Приложение для управления электронными книгами
sudo pacman -S catdoc --noconfirm  # Конвертер файлов Microsoft Word, Excel, PowerPoint и RTF в текст
sudo pacman -S unrtf --noconfirm  # Программа командной строки, конвертирующая документы RTF в другие форматы

echo 'Утилиты для редактирования документов, PDF, DjVus, NFO, DIZ и XPS... , Читалки электронных книг, Словари, Таблицы AUR'
# Utilities for editing documents, PDF, Djvu, NFO, DIZ and XPS..., e-book Readers, Dictionaries, Tables AUR
yay -S hunspell-ru masterpdfeditor --noconfirm
yay -S --noconfirm  # 
yay -S hunspell-ru --noconfirm  # Русский словарь hunspell
yay -S masterpdfeditor --noconfirm  # Комплексное решение для просмотра, создания и редактирования файлов PDF
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #

echo 'Утилиты для проектирования, черчения и тд...'
# Utilities for designing, drawing, and so on...
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 

echo 'Утилиты для проектирования, черчения и тд... AUR'
# Utilities for designing, drawing, and so on... AUR
yay -S  --noconfirm
yay -S  --noconfirm
yay -S  --noconfirm

echo 'Офисные пакеты'
# Office suite
sudo pacman -S libreoffice-still --noconfirm  # Филиал обслуживания LibreOffice
sudo pacman -S libreoffice-still-ru --noconfirm  # Пакет русского языка для LibreOffice still
sudo pacman -S libreoffice-extension-writer2latex --noconfirm  # набор расширений LibreOffice для преобразования и работы с LaTeX в LibreOffice
# ИЛИ
sudo pacman -S libreoffice-fresh --noconfirm  # Ветвь LibreOffice, содержащая новые функции и улучшения программы
sudo pacman -S libreoffice-fresh-ru --noconfirm  # Пакет русского языка для LibreOffice Fresh
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 

echo 'Офисные пакеты AUR'
# Office suite AUR
yay -S papirus-libreoffice-theme --noconfirm  # Тема Papirus для LibreOffice
yay -S  --noconfirm
yay -S  --noconfirm
# Wps office
yay -S wps-office --noconfirm  # Kingsoft Office (WPS Office) - офисный пакет для повышения производительности
yay -S ttf-wps-fonts --noconfirm  # Если установлен WPS - Символьные шрифты требуются wps-office
yay -S wps-office-mui-ru-ru --noconfirm  # Пакеты MUI для WPS Office
yay -S wps-office-extension-russian-dictionary --noconfirm  # Русский словарь для WPS Office
# Openoffice
yay -S openoffice --noconfirm  # Apache OpenOffice 
yay -S openoffice-ru-bin --noconfirm  # Пакет русского языка для OpenOffice.org
# Onlyoffice
yay -S onlyoffice-bin --noconfirm  # Офисный пакет, сочетающий в себе редакторы текста, таблиц и презентаций
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #

echo 'Утилиты для работы с CD,DVD, создание ISO образов, запись на флеш-накопители'
# Utilities for working with CD, DVD, creating ISO images, writing to flash drives
# sudo pacman -S woeusb --noconfirm  # Программа Linux для создания установщика USB-накопителя Windows с DVD-диска Windows или образа
sudo pacman -S xfburn --noconfirm  # Простой инструмент для записи CD / DVD на основе библиотек libburnia 
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 

echo 'Утилиты для работы с CD,DVD, создание ISO образов, запись на флеш-накопители AUR'
# Utilities for working with CD, DVD, creating ISO images, writing to flash drives AUR
yay -S mintstick unetbootin --noconfirm 
# yay -S woeusb-git --noconfirm  #
yay -S mintstick --noconfirm  # Графический интерфейс для записи файлов .img или .iso на USB-накопитель. Он также может их форматировать
yay -S unetbootin --noconfirm  # Создание загрузочных USB-накопителей Live
yay -S woeusb-gui --noconfirm  # Программа Linux для создания установщика USB-накопителя Windows с DVD-диска Windows или образа
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #

echo 'Онлайн мессенжеры и Телефония, Управления чатом и группам'
# Online messengers and Telephony, chat and group Management
sudo pacman -S signal-desktop --noconfirm  # Signal Private Messenger для Linux (Отправляйте высококачественные групповые, текстовые, голосовые, видео, документальные и графические сообщения в любую точку мира без платы за SMS или MMS)
sudo pacman -S toxcore --noconfirm  # Безопасная, не требующая настройки серверная часть P2P для замены Skype
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #

echo 'Онлайн мессенжеры и Телефония, Управления чатом и группам AUR'
# Online messengers and Telephony, chat and group Management AUR
yay -S skypeforlinux-stable-bin skype-call-recorder vk-messenger viber pidgin-extprefs --noconfirm 
yay -S teamviewer --noconfirm  # Универсальное программное обеспечение для удаленной поддержки и онлайн-встреч

echo 'Сетевые утилиты, Tor, VPN, SSH, Samba и тд...'
# Network utilities, Tor, VPN, SSH, Samba, etc...
sudo pacman -S tor torsocks --noconfirm
sudo pacman -S tor --noconfirm  # Анонимизирующая оверлейная сеть
sudo pacman -S torsocks --noconfirm  # Оболочка для безопасной торификации приложений
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S proxychains-ng privoxy openvpn --noconfirm
sudo pacman -S privoxy --noconfirm  # Веб-прокси с расширенными возможностями фильтрации
sudo pacman -S proxychains-ng --noconfirm  # Предварительный загрузчик ловушки, который позволяет перенаправлять TCP-трафик существующих динамически связанных программ через один или несколько SOCKS или HTTP-прокси
sudo pacman -S openvpn --noconfirm  # Простой в использовании, надежный и настраиваемый VPN (виртуальная частная сеть)
sudo pacman -S openconnect --noconfirm  # Открытый клиент для Cisco AnyConnect VPN
sudo pacman -S vpnc --noconfirm  # Клиент VPN для концентраторов cisco3000 VPN
sudo pacman -S networkmanager-openconnect --noconfirm  # Плагин NetworkManager VPN для OpenConnect
sudo pacman -S networkmanager-pptp --noconfirm  # Плагин NetworkManager VPN для PPTP
sudo pacman -S networkmanager-vpnc --noconfirm  # Плагин NetworkManager VPN для VPNC
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S samba --noconfirm  # Файловый сервер SMB и сервер домена AD
sudo pacman -S smb4k --noconfirm  # Программа KDE, просматривающая общие ресурсы samba

sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #


 Запуск, остановка сервиса tor:
sudo systemctl start tor
sudo systemctl stop tor

sudo pacman -S --noconfirm

echo 'Сетевые утилиты, Tor, VPN, SSH, Samba и тд... AUR'
# Network utilities, Tor, VPN, SSH, Samba, etc... AUR
yay -S --noconfirm 
yay -S system-config-samba --noconfirm  # Инструмент настройки Samba от Red Hat
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #

echo 'Установить рекомендуемые программы?'
# To install the recommended program?
echo -e "${BLUE}
'Список программ рекомендованных к установке:${GREEN}
simplescreenrecorder peek '
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -S simplescreenrecorder --noconfirm  # Многофункциональный экранный рекордер, поддерживающий X11 и OpenGL
sudo pacman -S lib32-simplescreenrecorder --noconfirm  # Записывайте 32-битные приложения OpenGL с помощью SimpleScreenRecorder
sudo pacman -S peek --noconfirm  # Простой экранный рекордер с простым в использовании интерфейсом
sudo pacman -S gnome-screenshot --noconfirm  # Сфотографируйте свой экран


sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
elif [[ $prog_set == 0 ]]; then
  echo 'Установка программ пропущена.'
fi

echo 'Установить рекомендуемые программы из AUR?'
# To install the recommended program? AUR
echo -e "${BLUE}
'Список программ рекомендованных к установке:${GREEN}
gksu debtap menulibre caffeine-ng inxi xneur fsearch-git timeshift mocicon multiload-ng-indicator-gtk xfce4-multiload-ng-plugin-gtk2 keepass2-plugin-tray-icon gconf-editor gconf-cleaner webtorrent-desktop corectrl mkinitcpio-openswap fetchmirrors gtk3-mushrooms'
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
yay -S gksu debtap menulibre caffeine-ng inxi xneur fsearch-git timeshift mocicon multiload-ng-indicator-gtk xfce4-multiload-ng-plugin-gtk2 keepass2-plugin-tray-icon gconf-editor gconf-cleaner webtorrent-desktop corectrl qt4 xflux flameshot-git mkinitcpio-openswap fetchmirrors gtk3-mushrooms --noconfirm  # xorg-xkill
yay -S timeshift --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #


yay -S gconf --noconfirm  # Устаревшая система базы данных конфигурации
https://aur.archlinux.org/packages/gconf/
https://aur.archlinux.org/gconf.git 
https://projects-old.gnome.org/gconf/

yay -S gconf-editor --noconfirm  # Графический редактор реестра gconf
https://aur.archlinux.org/packages/gconf-editor/
https://aur.archlinux.org/gconf-editor.git 
https://www.gnome.org

yay -S gconf-cleaner --noconfirm  # Инструмент очистки для GConf
https://aur.archlinux.org/packages/gconf-cleaner/
https://aur.archlinux.org/gconf-cleaner.git 
http://code.google.com/p/gconf-cleaner

yay -S fetchmirrors --noconfirm  # Получение и ранжирование нового зеркального списка pacman
https://aur.archlinux.org/packages/fetchmirrors/
https://aur.archlinux.org/fetchmirrors.git 
https://github.com/deadhead420/fetchmirrors

yay -S keepass2-plugin-tray-icon --noconfirm  # Функциональная иконка в трее для KeePass2 (https://aur.archlinux.org/keepass2-plugin-tray-icon.git)
https://aur.archlinux.org/packages/keepass2-plugin-tray-icon/
https://aur.archlinux.org/keepass2-plugin-tray-icon.git 
https://github.com/dlech/Keebuntu

yay -S fsearch-git --noconfirm  # Утилита быстрого поиска файлов. Версия Git
https://aur.archlinux.org/packages/fsearch-git/
https://aur.archlinux.org/fsearch-git.git 
https://cboxdoerfer.github.io/fsearch

yay -S caffeine-ng --noconfirm  # Приложение в строке состояния способно временно блокировать заставку и спящий режим
https://aur.archlinux.org/packages/caffeine-ng/
https://aur.archlinux.org/caffeine-ng.git
https://github.com/caffeine-ng/caffeine-ng

caffeine-ng  -  # Приложение строки состояния способно временно блокировать заставку и спящий режим
https://aur.archlinux.org/packages/caffeine-ng/
https://aur.archlinux.org/caffeine-ng.git
https://github.com/caffeine-ng/caffeine-ng

==> Недостающие зависимости:
  -> python-ewmh
  -> python-setproctitle
  -> python-wheel
  -> python-pulsectl
==> Проверка зависимостей для сборки...
==> Установка недостающих зависимостей...
разрешение зависимостей...
проверка конфликтов...

Пакеты (1) python-setuptools-scm-5.0.2-1

sudo pacman -S python-setuptools-scm --noconfirm  # Управляет версиями пакетов python в метаданных scm

python-setuptools-scm  -  # Управляет версиями пакетов python в метаданных scm
https://archlinux.org/packages/community/any/python-setuptools-scm/
https://github.com/pypa/setuptools_scm
Последнее обновление: 2021-03-04 23:20 UTC


sudo pacman -S python-ewmh --noconfirm  # Реализация Python подсказок расширенного оконного менеджера на основе Xlib

python-ewmh  -  # Реализация Python подсказок расширенного оконного менеджера на основе Xlib
https://archlinux.org/packages/community/any/python-ewmh/
https://github.com/parkouss/pyewmh
Последнее обновление: 2020-12-02 04:40 UTC


sudo pacman -S python-wheel --noconfirm  # Формат встроенного пакета для Python

python-wheel  -  # Формат встроенного пакета для Python
https://archlinux.org/packages/community/any/python-wheel/
https://pypi.python.org/pypi/wheel
Последнее обновление: 2020-12-13 21:57 UTC

yay -S python-pulsectl --noconfirm  # Интерфейс высокого уровня Python и привязки на основе ctypes для PulseAudio (libpulse)

python-pulsectl  AUR  -  # Интерфейс высокого уровня Python и привязки на основе ctypes для PulseAudio (libpulse)
https://aur.archlinux.org/packages/python-pulsectl/
https://aur.archlinux.org/python-pulsectl.git 
https://github.com/mk-fg/python-pulse-control
Последнее обновление: 2021-03-08 15:35

python-pulse-control (модуль pulsectl)
Python (3.x и 2.x) блокирует высокоуровневый интерфейс и привязки на основе ctypes для PulseAudio (libpulse) для использования в простом синхронном коде.

Оболочки в основном предназначены для управления, похожего на микшер, и операций, связанных с интроспекцией, в отличие, например, от отправки звуковых образцов для воспроизведения и клиента, подобного игроку.


caffeine-ng-git  -  # Приложение строки состояния способно временно блокировать заставку и спящий режим
https://aur.archlinux.org/packages/caffeine-ng-git/
https://aur.archlinux.org/caffeine-ng-git.git 
https://github.com/caffeine-ng/caffeine-ng


==> Установка недостающих зависимостей...
разрешение зависимостей...
проверка конфликтов...

Пакеты (1) python-click-7.1.2-4

sudo pacman -S python-click --noconfirm  # Простая оболочка вокруг optparse для мощных утилит командной строки

python-click  -  # Простая оболочка вокруг optparse для мощных утилит командной строки
https://archlinux.org/packages/community/any/python-click/
http://click.pocoo.org/
Последнее обновление: 2021-03-30 14:27 UTC

--------------------------------

yay -S gtk3-mushrooms --noconfirm  # GTK3 исправлен для классических настольных компьютеров, таких как XFCE или MATE. См. README
https://aur.archlinux.org/packages/gtk3-mushrooms/
https://aur.archlinux.org/gtk3-mushrooms.git
https://github.com/krumelmonster/gtk3-mushrooms

yay -S inxi --noconfirm  # Полнофункциональный инструмент системной информации CLI

inxi  -  # Полнофункциональный инструмент системной информации CLI
https://aur.archlinux.org/packages/inxi/
https://aur.archlinux.org/inxi.git 
https://github.com/smxi/inxi

inxi-git  -  # Полнофункциональный инструмент системной информации CLI
https://aur.archlinux.org/packages/inxi-git/
https://aur.archlinux.org/inxi-git.git
https://github.com/smxi/inxi


yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
elif [[ $prog_set == 0 ]]; then
  echo 'Установка программ пропущена.'
fi
# --------------------------------------
Powerpill (Русский)
https://wiki.archlinux.org/index.php/Powerpill_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
Обертка Pacman для более быстрой загрузки
AUR :

yay -S powerpill --noconfirm  # Обертка Pacman для более быстрой загрузки  https://aur.archlinux.org/packages/powerpill/
# Мне нужно было установить python3-memoizedb для его запуска, однако он не указан здесь как зависимость
yay -S python3-memoizedb --noconfirm # Универсальный мемоизатор поиска данных, который использует базу данных sqlite для кэширования данных  https://aur.archlinux.org/packages/python3-memoizedb/
yay -S bauerbill --noconfirm  # # Расширение Powerpill с поддержкой AUR и ABS.  https://aur.archlinux.org/packages/bauerbill/
Не беспокойся. Просто использовал bb -Syu --aur --ignore bauerbill пока ждал пока починят. : P Большое спасибо за исправление!
yay -S pacserve --noconfirm  # # Легко делитесь пакетами Pacman между компьютерами. Замена для PkgD  https://aur.archlinux.org/packages/pacserve/   
https://bugs.mageia.org/show_bug.cgi?id=15425

Обновление системы
Чтобы обновить систему (синхронизировать и обновить установленные пакеты) используйте powerpill и опцию -Syu - как вы делаете это с pacman:

powerpill -Syu

Установка пакетов
Чтобы установить пакет и его зависимости, просто используйте powerpill (вместо pacman) с опцией -S:

powerpill -S package

Вы также можете установить несколько пакетов, как и при работе с pacman:

powerpill -S package1 package2 package3

yay -S  --noconfirm  #
# ===========================================

############################
Иероглифы в русских названиях файлов в ZIP-архивах

yay -S zip-natspec --noconfirm  # Создает PKZIP-совместимые файлы .zip для нелатинских имен файлов с использованием патча libnatspec от AltLinux
yay -S unzip-natspec --noconfirm  # Распаковывает .zip-архивы с нелатинскими именами файлов, используя патч libnatspec от AltLinux
yay -S libnatspec --noconfirm  # Набор функций для запроса различных кодировок и локалей для хост-системы и для другой системы 
# yay -S p7zip-natspec --noconfirm  # Файловый архиватор командной строки с высокой степенью сжатия, основанный на патче libnatspec из ubuntu zip-i18n PPA (https://launchpad.net/~frol/+archive/zip-i18n)
yay -S zip-natspec unzip-natspec libnatspec --noconfirm  #

После установки они заменяют штатные команды zip и unzip , что позволяет использовать их не только в консоли, но и через ГУИшные программы, использующие zip и unzip в качестве бэкэнда для ZIP-архивов.
########################

echo 'Дополнительные пакеты для игр'
# Additional packages for games
# Необходимо раскомментировать репозиторий multilib в /etc/pacman.conf.
# Steam:
sudo pacman -S steam steam-native-runtime lutris lib32-dbus-glib lib32-libnm-glib lib32-openal lib32-nss lib32-gtk2 lib32-sdl2 lib32-sdl2_image lib32-libcanberra --noconfirm   конфигурации
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
#sudo pacman -S lib32-alsa-plugins lib32-curl --noconfirm

echo 'Дополнительные пакеты для игр AUR'
# Additional packages for games AUR
yay -S lib32-libudev0 --noconfirm  # ( lib32-libudev0-shim-nosystemd ) Библиотека совместимости libudev.so.0 для систем с более новыми версиями udev (32 бит)
yay -S lib32-gconf --noconfirm  # Устаревшая система базы данных
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #

echo 'Установка Дополнительных программ'
# Installing Additional programs
echo -e "${BLUE}
'Список Дополнительных программ к установке:${GREEN}
 osmo synapse variety kleopatra' 
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -S catfish --noconfirm  # Универсальный инструмент для поиска файлов
sudo pacman -S gnome-chess --noconfirm  # Сыграйте в классическую настольную игру в шахматы для двух игроков
sudo pacman -S hardinfo --noconfirm  # Системная информация и инструмент тестирования
sudo pacman -S hexchat --noconfirm  # Популярный и простой в использовании графический IRC-клиент (чат)
sudo pacman -S mutt --noconfirm  # Небольшой, но очень мощный текстовый почтовый клиент
sudo pacman -S osmo --noconfirm  # Удобный персональный органайзер
sudo pacman -S rmlint --noconfirm  # Инструмент для удаления дубликатов и прочего ворса, намного быстрее, чем fdupes
sudo pacman -S rmlint-shredder --noconfirm  # Графический пользовательский интерфейс для rmlint
sudo pacman -S synapse --noconfirm  # Средство запуска семантических файлов
sudo pacman -S variety --noconfirm  # Меняет обои с регулярным интервалом, используя указанные пользователем или автоматически загруженные изображения
sudo pacman -S recolla --noconfirm  # Инструмент полнотекстового поиска на базе Xapian backend (recoll)
sudo pacman -S notepadqq --noconfirm  # Notepad ++ - как текстовый редактор для Linux
sudo pacman -S leafpad --noconfirm  # Клон блокнота для GTK + 2.0
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S freemind --noconfirm  #  Ментальный картограф и в то же время простой в использовании иерархический редактор с упором на сворачивание
elif [[ $prog_set == 0 ]]; then
  echo 'Установка программ пропущена.' 
fi


###########################


sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #



yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #





######################

# "freshplayerplugin" "(AUR) Recommended" - PPAPI-host Адаптер NPAPI-plugin
# "freshplayerplugin-git" "(AUR)" - PPAPI-host Адаптер NPAPI-plugin
#  "vivaldi" "(AUR) (GTK)" - Продвинутый браузер, созданный для опытных пользователей
#  "vivaldi-ffmpeg-codecs" "(AUR) Non-free codecs" - дополнительная поддержка проприетарных кодеков для vivaldi
sudo pacman -S pepper-flash --noconfirm  # Adobe Flash Player PPAPI
yay -S freshplayerplugin --noconfirm  # PPAPI-host Адаптер NPAPI-plugin (Recommended)
yay -S freshplayerplugin-git --noconfirm  # PPAPI-host Адаптер NPAPI-plugin

yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #

#################################
# ktorrent (QT) - Мощный клиент BitTorrent для KDE 
# tixati (AUR) (GTK) - Tixati - это программа для однорангового обмена файлами, использующая популярный протокол BitTorrent

sudo pacman -S ktorrent --noconfirm  # Мощный клиент BitTorrent для KDE
yay -S ktorrent-git --noconfirm  # Мощный клиент BitTorrent. (Версия GIT)
yay -S tixati --noconfirm  # Tixati - это программа для однорангового обмена файлами, использующая популярный протокол BitTorrent
yay -S  --noconfirm  #
================================

echo 'Установка Дополнительных программ AUR'
# Installing Additional programs AUR
echo -e "${BLUE}
'Список Дополнительных программ к установке AUR:${GREEN}
сюда вписать список программ'
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
yay -S xfce4-calculator-plugin --noconfirm
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
elif [[ $prog_set == 0 ]]; then
  echo 'Установка программ пропущена.'
fi


###############################


xfce4-places-plugin   AUR  # Плагин меню Places для панели Xfce
https://aur.archlinux.org/packages/xfce4-places-plugin/
https://aur.archlinux.org/xfce4-places-plugin.git
http://goodies.xfce.org/projects/panel-plugins/xfce4-places-plugin
Последнее обновление: 2019-08-12 14:44

Этот плагин, изначально написанный Диего Онгаро , представляет собой меню с быстрым доступом к папкам, документам и съемным носителям. Плагин Places привносит в Xfce большую часть функций меню Places GNOME.

Плагин помещает простую кнопку на панель. При нажатии на эту кнопку открывается меню со следующим:

Системные каталоги (домашняя папка, корзина, рабочий стол, файловая система)
Съемный носитель (с использованием thunar-vfs)
Пользовательские закладки (читает ~/.gtk-bookmarks)
Средство запуска программы поиска (необязательно)
Подменю последних документов (требуется GTK + v2.10 или выше)
использование
Просто добавьте его в панель. Пользовательские закладки можно изменить с помощью файлового менеджера или вручную ~/.gtk-bookmarks. Вы можете настроить плагин, щелкнув правой кнопкой мыши по кнопке и выбрав «Свойства» (см. Снимок экрана ниже).

oh-my-zsh-git  AUR  # Платформа сообщества для управления вашей конфигурацией zsh. Включает 180+ дополнительных плагинов и более 120 тем, чтобы оживить ваше утро, а также инструмент автоматического обновления, чтобы вы могли легко быть в курсе последних обновлений от сообщества
https://aur.archlinux.org/packages/oh-my-zsh-git/
https://aur.archlinux.org/oh-my-zsh-git.git
https://github.com/ohmyzsh/ohmyzsh
Последнее обновление: 2020-04-16 17:58

---------------------------------

skippy-xd-git  AUR  # Полноэкранный переключатель задач для X11, похожий на Apple Expose
https://aur.archlinux.org/packages/skippy-xd-git/
https://github.com/dreamcat4/skippy-xd
Многозадачный вид: skippy-xd (Super + Tab)

multilockscreen-git  AUR  # Простой скрипт блокировки для i3lock-color
https://aur.archlinux.org/packages/multilockscreen-git/
https://aur.archlinux.org/multilockscreen-git.git
https://github.com/jeffmhubbard/multilockscreen
Install
Manual Installation
git clone https://github.com/jeffmhubbard/multilockscreen
cd multilockscreen
sudo install -Dm 755 multilockscreen /usr/local/bin/multilockscreen
Arch Linux (AUR)
git clone https://aur.archlinux.org/multilockscreen-git.git
cd multilockscreen-git
less PKGBUILD
makepkg -si

Требования

i3lock-color  AUR  # Улучшенный блокировщик экрана на основе XCB и PAM с поддержкой цветовой конфигурации
https://aur.archlinux.org/packages/i3lock-color/
https://aur.archlinux.org/i3lock-color.git
ИЛИ 
i3lock-color-git  AUR  # Улучшенный блокировщик экрана на основе XCB и PAM с поддержкой цветовой конфигурации
https://aur.archlinux.org/packages/i3lock-color-git/
https://aur.archlinux.org/i3lock-color-git.git 

imagemagick - # Программа просмотра / обработки изображений
https://www.archlinux.org/packages/extra/x86_64/imagemagick/

xrandr - Показать информацию 
https://aur.archlinux.org/packages/?O=0&SeB=nd&K=xrandr&outdated=&SB=n&SO=a&PP=50&do_Search=Go
libxrandr 1.5.2-3 # Библиотека расширения X11 RandR
https://www.archlinux.org/packages/extra/x86_64/libxrandr/

xdpyinfo - отображение информации и поддержка HiDPI
xorg-xdpyinfo - # Утилита отображения информации для X
https://www.archlinux.org/packages/extra/x86_64/xorg-xdpyinfo/

feh - # Быстрый и легкий просмотрщик изображений на основе imlib2
https://www.archlinux.org/packages/extra/x86_64/feh/

----------------------------------------

hblock  AUR  # Блокировщик рекламы, который создает файл hosts из автоматически загружаемых черных списков
https://aur.archlinux.org/packages/hblock/
https://aur.archlinux.org/hblock.git
https://github.com/hectorm/hblock
Last Updated: 2021-03-08 19:55

Установка
hBlock доступен в различных менеджерах пакетов. Обновленный список можно найти в файле PACKAGES.md .

Последнюю доступную версию также можно установить вручную, выполнив следующие команды:

curl -o /tmp/hblock 'https://raw.githubusercontent.com/hectorm/hblock/v3.2.1/hblock' \
  && echo '698932a84a0cd51ee633c84ca36713e520a0f40c30e2afc59b0fd7016c9c70f8  /tmp/hblock' | shasum -c \
  && sudo mv /tmp/hblock /usr/local/bin/hblock \
  && sudo chown 0:0 /usr/local/bin/hblock \
  && sudo chmod 755 /usr/local/bin/hblock
  
  hBlock - это POSIX-совместимый сценарий оболочки, который получает список доменов, которые обслуживают рекламу, сценарии отслеживания и вредоносные программы из нескольких источников, и создает файл хостов , среди других форматов , который предотвращает подключение вашей системы к ним.


firefox-extension-leechblock  AUR  # LeechBlock - это простой бесплатный инструмент для повышения производительности, предназначенный для блокировки тех сайтов, которые тратят время впустую, которые могут высосать жизнь из вашего рабочего дня.
https://aur.archlinux.org/packages/firefox-extension-leechblock/
https://aur.archlinux.org/firefox-extension-leechblock.git
https://addons.mozilla.org/en-US/firefox/addon/leechblock-ng/
Последнее обновление: 2019-04-09 21:51

LeechBlock NG - это простой инструмент повышения производительности, предназначенный для блокировки тех сайтов, которые тратят время впустую, которые могут высосать жизнь из вашего рабочего дня. Все, что вам нужно сделать, это указать, какие сайты и когда блокировать.

Только с Firefox - установите Firefox прямо сейчас


xfce4-docklike-plugin  AUR  # Современная минималистичная панель задач в стиле док-станции для XFCE
https://aur.archlinux.org/packages/xfce4-docklike-plugin/
https://aur.archlinux.org/xfce4-docklike-plugin.git 
https://github.com/nsz32/docklike-plugin
Last Updated: 2021-03-14 08:28

Пользовательский репозиторий ArchLinux (AUR)
yay -S xfce4-docklike-plugin-git


xfce4-docklike-plugin-git  AUR  # Современная минималистичная панель задач в стиле док-станции для XFCE
https://aur.archlinux.org/packages/xfce4-docklike-plugin-git/
https://aur.archlinux.org/xfce4-docklike-plugin-git.git
https://github.com/nsz32/docklike-plugin
Last Updated: 2020-09-03 23:15


lightdm-slick-greeter  AUR  # Красивое приветствие LightDM
https://aur.archlinux.org/packages/lightdm-slick-greeter/
https://aur.archlinux.org/lightdm-slick-greeter.git
https://github.com/linuxmint/slick-greeter
Последнее обновление: 2021-01-20 18:44

Конфигурация
Конфигурация по умолчанию хранится в dconf под схемой x.dm.slick-greeter.
Дистрибутивы должны устанавливать свои собственные значения по умолчанию, используя переопределение glib.
Пользователи могут создавать и изменять /etc/lightdm/slick-greeter.conf, настройки в этих файлах имеют приоритет и перезаписывают настройки dconf.
Инструмент настройки доступен по адресу https://github.com/linuxmint/lightdm-settings.

Функции
Slick-Greeter является кросс-распространяемым и должен работать практически везде.
Все апплеты панели встроены. Приветствие не запускает и не загружает внешние индикаторы.
Программа приветствия не запускает и не загружает демон настроек.
Это средство приветствия поддерживает HiDPI.
Сессии подтверждены. Если сеанс по умолчанию / выбранный отсутствует в системе, программа приветствия сканирует известные сеансы в / usr / share / xsessions и заменяет неверный выбор сеанса действительным сеансом.
Вы можете сделать снимок экрана, нажав PrintScrn. Снимок экрана сохраняется в /var/lib/lightdm/Screenshot.png.


bluez-utils-compat  AUR  # Утилиты для разработки и отладки стека протоколов Bluetooth. Включает устаревшие инструменты.
https://aur.archlinux.org/packages/bluez-utils-compat/
https://aur.archlinux.org/bluez-utils-compat.git 
http://www.bluez.org/
Последнее обновление: 2021-02-24 18:04


grml-iso  AUR  # добавьте ISO-образ grml в меню загрузки grub2
https://aur.archlinux.org/packages/grml-iso/
https://aur.archlinux.org/grml-iso.git 
http://wiki.grml.org/doku.php?id=rescueboot
Последнее обновление: 2020-07-26 23:59

Предисловие
Система восстановления Grml поддерживает загрузку Grml ISO с жесткого диска. Это обеспечивает достойный способ иметь Grml ISO в / boot / grml / на вашем жестком диске, и пока жесткий диск и его загрузчик GRUB работают, вы можете загрузить систему восстановления Grml без аварийного компакт-диска, USB-ручки или Доступна среда PXE.

Чтобы максимально упростить эту задачу, мы создали grml-rescueboot, который интегрирует загрузку по ISO в GRUB. Пакет grml-rescueboot включает сценарий для update-grub, который ищет образы Grml ISO в / boot / grml и автоматически добавляет запись для каждого образа.

Требования
Grml ISO
Загрузчик GRUB2

ИЛИ 

grml-rescueboot  AUR  # grub2 скрипт для добавления ISO-образов grml в меню загрузки grub2
https://aur.archlinux.org/packages/grml-rescueboot/
https://aur.archlinux.org/grml-rescueboot.git 
http://wiki.grml.org/doku.php?id=rescueboot
Последнее обновление: 2020-12-29 09:11

-----------------------------

Лаунчер: rofi (Alt + d)
Переключатель окон, средство запуска приложений и замена dmenu
https://www.archlinux.org/packages/community/x86_64/rofi/

Композитный менеджер: compton (По умолчанию отключен).

 -############ ОФОРМЛЕНИЕ ###########

arc-gtk-theme - # Плоская тема с прозрачными элементами для GTK 3, GTK 2 и Gnome-Shell
https://www.archlinux.org/packages/community/any/arc-gtk-theme/

arc-icon-theme - # Тема значка дуги. Только официальные релизы
https://www.archlinux.org/packages/community/any/arc-icon-theme/

arc-firefox-theme  AUR  # Официальная тема Arc Firefox
https://aur.archlinux.org/packages/arc-firefox-theme/  # Голоса: 18
https://aur.archlinux.org/arc-firefox-theme.git

arc-firefox-theme-git  AUR  # Тема Arc Firefox
https://aur.archlinux.org/packages/arc-firefox-theme-git/  # Голоса: 32
https://aur.archlinux.org/arc-firefox-theme-git.git

papirus-icon-theme - # Тема значка папируса
https://www.archlinux.org/packages/community/any/papirus-icon-theme/

capitaine-cursors - # Тема x-cursor, вдохновленная macOS и основанная на KDE Breeze
https://www.archlinux.org/packages/community/any/capitaine-cursors/

hicolor-icon-theme - # Freedesktop.org Hicolor тема значков
https://www.archlinux.org/packages/extra/any/hicolor-icon-theme/

echo ' Установка тем AUR '
yay -S osx-arc-shadow papirus-maia-icon-theme-git breeze-default-cursor-theme --noconfirm

osx-arc-shadow  AUR  # ???
https://aur.archlinux.org/packages/?O=0&SeB=nd&K=osx-arc&outdated=&SB=n&SO=a&PP=50&do_Search=Go

osx-arc-white-git  AUR  # OSX-Arc-White Theme для Cinnamon, GNOME, Unity, Xfce и GTK +
https://aur.archlinux.org/packages/osx-arc-white-git/
https://aur.archlinux.org/osx-arc-white-git.git 
osx-arc-plus  AUR  # Тема OSX-Arc-Plus для GTK 3.x 
https://aur.archlinux.org/packages/osx-arc-plus/
https://aur.archlinux.org/osx-arc-plus.git
osx-arc-white  AUR  # OSX-Arc-Белая тема для GTK 3.x
https://aur.archlinux.org/packages/osx-arc-white/
https://aur.archlinux.org/osx-arc-white.git 
osx-arc-aurorae-theme  AUR  # Тема Aurorae, разработанная для дополнения тем gtk OSX-Arc @ LinxGem33
https://aur.archlinux.org/packages/osx-arc-aurorae-theme/
https://aur.archlinux.org/osx-arc-aurorae-theme.git 
osx-arc-aurorae-theme-git  AUR  # Тема Aurorae, разработанная для дополнения тем gtk OSX-Arc @ LinxGem33
https://aur.archlinux.org/packages/osx-arc-aurorae-theme-git/
https://aur.archlinux.org/osx-arc-aurorae-theme-git.git

papirus-maia-icon-theme-git  AUR  # Вариант Manjaro темы значков Papirus (версия git)
https://aur.archlinux.org/packages/papirus-maia-icon-theme-git/
https://aur.archlinux.org/papirus-maia-icon-theme-git.git 

breeze-default-cursor-theme  AUR  # Тема курсора по умолчанию Breeze.
https://aur.archlinux.org/packages/breeze-default-cursor-theme/
https://aur.archlinux.org/breeze-default-cursor-theme.git

---------------------------------------
 
sudo pacman -S systemd systemd-libs systemd-resolvconf systemd-sysvcompat --noconfirm
sudo pacman -S  --noconfirm  
sudo pacman -S  --noconfirm  
sudo pacman -S  --noconfirm  

----------------------------------------
if [[ $i_cpu == 0 ]]; then
clear
echo " Добавление ucode пропущено "
elif [[ $i_cpu  == 1 ]]; then
clear
pacman -S amd-ucode --noconfirm
echo  'initrd /amd-ucode.img ' >> /boot/loader/entries/arch.conf
elif [[ $i_cpu  == 2 ]]; then
clear
pacman -S intel-ucode  --noconfirm
echo ' initrd /intel-ucode.img ' >> /boot/loader/entries/arch.conf
fi
echo "initrd  /initramfs-linux.img" >> /boot/loader/entries/arch.conf
clear
lsblk -f
echo ""
echo " Укажите тот радел который будет после перезагрузки, то есть например "

echo " при установке с флешки ваш hdd может быть sdb, а после перезагрузки sda "

echo " выше видно что sdbX например примонтирован в /mnt, а после перезагрузки systemd будет искать корень на sdaX "

echo " если указать не правильный раздел система не загрузится "

echo " если у вас один hdd/ssd тогда это будет sda 99%"
echo ""
read -p "Укажите ROOT(корневой) раздел для загрузчика (Не пyтать с Boot!!!) (пример  sda6,sdb3 или nvme0n1p2 ): " root
Proot=$(blkid -s PARTUUID /dev/$root | grep -oP '(?<=PARTUUID=").+?(?=")')
echo options root=PARTUUID=$Proot rw >> /boot/loader/entries/arch.conf
#
cd /home/$username 
git clone https://aur.archlinux.org/systemd-boot-pacman-hook.git  # Перехватчик Pacman для обновления systemd-boot после обновления systemd
chown -R $username:users /home/$username/systemd-boot-pacman-hook  # https://aur.archlinux.org/packages/systemd-boot-pacman-hook/ 
chown -R $username:users /home/$username/systemd-boot-pacman-hook/PKGBUILD 
cd /home/$username/systemd-boot-pacman-hook   
sudo -u $username makepkg -si --noconfirm  
rm -Rf /home/$username/systemd-boot-pacman-hook
cd /home/$username 

---------------------------------------------------


sudo pacman -S systemd --noconfirm  # Системный и сервисный менеджер
sudo pacman -S systemd-libs --noconfirm  # Клиентские библиотеки systemd
sudo pacman -S systemd-resolvconf --noconfirm  # Замена systemd resolvconf (для использования с systemd-resolved)
sudo pacman -S systemd-sysvcompat --noconfirm  # sysvinit compat для systemd



sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 

sudo pacman -S python python-anytree python-appdirs python-arrow python-asn1crypto python-cairo python-chardet python-dbus python-dbus-common python-ewmh python-gobject python-idna python-isodate python-lxml python-mutagen python-ordered-set python-packaging python-pexpect python-ply python-ptyprocess python-pycountry python-pycryptodome python-pyparsing python-pyqt5 python-pyqt5-sip python-pysocks python-pyxdg python-requests python-setuptools python-sip python-six python-urllib3 python-websocket-client --noconfirm  # python +

sudo pacman -S python --noconfirm  # Новое поколение языка сценариев высокого уровня Python
sudo pacman -S python-anytree --noconfirm  # Мощная и легкая древовидная структура данных Python
sudo pacman -S python-appdirs --noconfirm  # Небольшой модуль Python для определения соответствующих директорий для конкретной платформы, например «директории пользовательских данных».
sudo pacman -S python-arrow --noconfirm  # Лучшие даты и время для Python
sudo pacman -S python-asn1crypto --noconfirm  # Библиотека Python ASN.1 с упором на производительность и pythonic API
sudo pacman -S python-cairo --noconfirm  # Привязки Python для графической библиотеки cairo
sudo pacman -S python-chardet --noconfirm  # Модуль Python3 для автоматического определения кодировки символов
sudo pacman -S python-dbus --noconfirm  # Привязки Python для DBUS
sudo pacman -S python-dbus-common --noconfirm  # Общие файлы dbus-python, общие для python-dbus и python2-dbus
sudo pacman -S python-ewmh --noconfirm  # Реализация Python подсказок Extended Window Manager на основе Xlib
sudo pacman -S python-gobject --noconfirm  # Привязки Python для GLib / GObject / GIO / GTK +
sudo pacman -S python-idna --noconfirm  # Интернационализированные доменные имена в приложениях (IDNA)
sudo pacman -S python-isodate --noconfirm  # Синтаксический анализатор даты / времени / продолжительности и форматирование ISO 8601
sudo pacman -S python-lxml --noconfirm  # Связывание Python3 для библиотек libxml2 и libxslt (-S python-lxml --force # принудительная установка)
sudo pacman -S python-mutagen --noconfirm  # (mutagen) Средство чтения и записи тегов метаданных аудио (библиотека Python)
sudo pacman -S python-ordered-set --noconfirm  # MutableSet, который запоминает свой порядок, так что каждая запись имеет индекс
sudo pacman -S python-packaging --noconfirm  # Основные утилиты для пакетов Python
sudo pacman -S python-pexpect --noconfirm  # Для управления и автоматизации приложений
sudo pacman -S python-ply --noconfirm  # Реализация инструментов парсинга lex и yacc
sudo pacman -S python-ptyprocess --noconfirm  # Запустить подпроцесс в псевдотерминале
sudo pacman -S python-pycountry --noconfirm  # Определения страны, подразделения, языка, валюты и алфавита ИСО и их переводы
sudo pacman -S python-pycryptodome --noconfirm  # Коллекция криптографических алгоритмов и протоколов, реализованных для использования из Python 3
sudo pacman -S python-pyparsing --noconfirm  # Модуль общего синтаксического анализа для Python
sudo pacman -S python-pyqt5 --noconfirm  # Набор привязок Python для инструментария Qt5
sudo pacman -S python-pyqt5-sip --noconfirm  # Поддержка модуля sip для PyQt5
sudo pacman -S python-pysocks --noconfirm  # SOCKS4, SOCKS5 или HTTP-прокси (вилка Anorov PySocks заменяет socksipy)
sudo pacman -S python-pyxdg --noconfirm  # Библиотека Python для доступа к стандартам freedesktop.org
sudo pacman -S python-requests --noconfirm  # Python HTTP для людей
sudo pacman -S python-setuptools --noconfirm  # Легко загружайте, собирайте, устанавливайте, обновляйте и удаляйте пакеты Python
sudo pacman -S python-sip --noconfirm  # Привязки Python SIP4 для библиотек C и C ++
sudo pacman -S python-six --noconfirm  # Утилиты совместимости с Python 2 и 3
sudo pacman -S python-urllib3 --noconfirm  # Библиотека HTTP с потокобезопасным пулом соединений и поддержкой публикации файлов
sudo pacman -S python-websocket-client --noconfirm  # Клиентская библиотека WebSocket для Python


sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 


sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 



----------------------------------


python-atspi # Привязки Python для D-Bus AT-SPI
python-attrs # Атрибуты без шаблона
python-bcrypt # Современное хеширование паролей для вашего программного обеспечения и ваших серверов
python-beaker # Кэширование и сеансы промежуточного программного обеспечения WSGI для использования с веб-приложениями и автономными скриптами и приложениями Python
python-beautifulsoup4 # Синтаксический анализатор HTML / XML на Python, предназначенный для быстрых проектов, таких как очистка экрана
python-cachecontrol # httplib2 кеширование запросов
python-cffi # Интерфейс внешних функций для Python, вызывающего код C
python-colorama # Python API для кроссплатформенного цветного текста терминала
python-colour # Библиотека манипуляций с цветовыми представлениями (RGB, HSL, web, ...)
python-configobj # Простое, но мощное средство чтения и записи конфигурационных файлов для Python
python-contextlib2 # Обратный перенос модуля contextlib стандартной библиотеки на более ранние версии Python
python-cryptography # Пакет, предназначенный для предоставления криптографических рецептов и примитивов разработчикам Python
python-cssselect # Библиотека Python3, которая анализирует селекторы CSS3 и переводит их в XPath 1.0
python-d2to1 # Библиотека Python, которая позволяет использовать файлы setup.cfg, подобные distutils2, для метаданных пакета с помощью скрипта distribute / setuptools setup.py
python-dateutil # Предоставляет мощные расширения для стандартного модуля datetime
python-defusedxml # Защита от XML-бомбы для модулей Python stdlib
python-distlib # Низкоуровневые компоненты distutils2 / упаковка
python-distro # API информации о платформе ОС Linux
python-distutils-extra # Улучшения в системе сборки Python
python-docopt # Пифонический парсер аргументов, который заставит вас улыбнуться
python-entrypoints # Обнаружение и загрузка точек входа из установленных пакетов
python-eyed3 # Модуль Python и программа для обработки информации о файлах mp3
python-future # Чистая поддержка одного источника для Python 3 и 2
python-gevent # Сетевая библиотека Python, которая использует greenlet и libev для простого и масштабируемого параллелизма
python-gevent-websocket # Библиотека WebSocket для сетевой библиотеки gevent
python-gobject # Привязки Python для GLib / GObject / GIO / GTK +
python-greenlet # Легкое параллельное программирование в процессе
python-html5lib # Парсер / токенизатор HTML Python на основе спецификации WHATWG HTML5
python-httplib2 # Обширная клиентская библиотека HTTP, поддерживающая множество функций
python-jedi # Отличное автозаполнение для Python
python-jeepney # Низкоуровневая оболочка протокола Python DBus на чистом уровне
python-jinja # Простой питонический язык шаблонов, написанный на Python
python-keyring # Безопасное хранение и доступ к вашим паролям
python-keyutils # Набор привязок python для keyutils
python-libarchive-c # Интерфейс Python для libarchive
python-lxml-docs # Связывание Python для библиотек libxml2 и libxslt (документы)
python-magic # Привязки Python к волшебной библиотеке
python-mako # Сверхбыстрый язык шаблонов, который заимствует лучшие идеи из существующих языков шаблонов
python-markdown # Реализация Python Markdown Джона Грубера
python-markupsafe # Реализует безопасную строку разметки XML / HTML / XHTML для Python
python-maxminddb # Читатель для формата MaxMind DB
python-msgpack  # Реализация сериализатора MessagePack для Python
python-mutagen  # Устройство чтения и записи тегов аудиометаданных (библиотека Python)
python-nose  # Расширение unittest на основе обнаружения
python-numpy # Научные инструменты для Python
python-olefile # Библиотека Python для анализа, чтения и записи файлов Microsoft OLE2 (ранее OleFileIO_PL)
python-ordered-set # MutableSet, который запоминает свой порядок, так что каждая запись имеет индекс
python-packaging # Основные утилиты для пакетов Python
python-paramiko # Модуль Python, реализующий протокол SSH2
python-parso # Синтаксический анализатор Python, поддерживающий восстановление ошибок и двусторонний синтаксический анализ для разных версий Python
python-patiencediff # Patiencediff реализации Python и C
python-pbr # Разумность сборки Python
python-pep517 # Оболочки для сборки пакетов Python с использованием хуков PEP 517
python-pexpect # Для управления и автоматизации приложений
python-pillow # Вилка Python Imaging Library (PIL)
python-pip # Рекомендуемый PyPA инструмент для установки пакетов Python
python-ply # Реализация инструментов парсинга lex и yacc
python-powerline # Библиотека Python для Powerline
python-progress # Простые в использовании индикаторы выполнения для Python
python-psutil # Кросс-платформенный модуль процессов и системных утилит для Python
python-ptyprocess # Запустить подпроцесс в псевдотерминале
python-pyasn1 # Библиотека ASN.1 для Python 3
python-pyasn1-modules # Коллекция модулей протоколов на основе ASN.1
python-pycparser # Синтаксический анализатор C и генератор AST, написанные на Python
python-pycups # Привязки Python для libcups
python-pycurl # Интерфейс Python 3.x для libcurl








python-ujson # Сверхбыстрый кодировщик и декодер JSON для Python
python-unidecode # ASCII транслитерации текста Unicode
python-webencodings # Это Python-реализация стандарта кодирования WHATWG
python-websockets # Реализация протокола WebSocket на Python (RFC 6455)
python-xapp # Библиотека Python Xapp
python-yaml # Привязки Python для YAML с использованием быстрой библиотеки libYAML
python-zope-event # Предоставляет простую систему событий
python-zope-interface # Интерфейсы Zope для Python 3.x


----------------------------

########## Биткойн ###########

python-base58   AUR  # Биткойн-совместимая реализация Base58 и Base58Check
https://aur.archlinux.org/packages/python-base58/
https://aur.archlinux.org/python-base58.git 

python-bitcoinlib # Библиотека Python3, обеспечивающая простой интерфейс для структур данных и протокола Биткойн
https://www.archlinux.org/packages/community/any/python-bitcoinlib/

--------------------------------------

python-basiciw    AUR  # Получение информации, такой как ESSID или качество сигнала, с беспроводных карт (модуль Python)
https://aur.archlinux.org/packages/python-basiciw/
https://aur.archlinux.org/python-basiciw.git 

python-bencode.py    AUR  # Простой парсер бенкода (для Python 2, Python 3 и PyPy)
https://aur.archlinux.org/packages/python-bencode.py/
https://aur.archlinux.org/python-bencode.py.git 

pythonqt    AUR  # Динамическая привязка Python для приложений Qt
https://aur.archlinux.org/packages/pythonqt/
https://aur.archlinux.org/pythonqt.git 

python-coincurve   AUR  # Кросс-платформенные привязки Python CFFI для libsecp256k1
https://aur.archlinux.org/packages/python-coincurve/
https://aur.archlinux.org/python-coincurve.git 

python-merkletools   AUR  # Инструменты Python для создания и проверки деревьев Меркла и доказательств
https://aur.archlinux.org/packages/python-merkletools/
https://aur.archlinux.org/python-merkletools.git 
https://github.com/Tierion/pymerkletools

python-pyparted   AUR  # Модуль Python для GNU parted
https://aur.archlinux.org/packages/python-pyparted/
https://aur.archlinux.org/python-pyparted.git
https://github.com/dcantrell/pyparted

python-twitter   AUR  # Набор инструментов API и командной строки для Twitter (twitter.com)
https://aur.archlinux.org/packages/python-twitter/
https://aur.archlinux.org/python-twitter.git 
http://pypi.python.org/pypi/twitter/


python2-imaging  AUR  # PIL. Предоставляет возможности обработки изображений для Python
https://aur.archlinux.org/packages/python2-imaging/
https://aur.archlinux.org/python2-imaging.git 
http://www.pythonware.com/products/pil/index.htm




-------------------------------------------
### ПРОВЕРИТЬ ############


python-pyelftools 0.26-1
python-pyelliptic 2.0.1-2
python-pyfiglet 0.8.post0-3
python-pygments 2.6.1-3
python-pyicu 2.5-1
python-pynacl 1.4.0-1
python-pyopenssl 19.1.0-2
python-pyparsing 2.4.7-1

python-pyphen 0.9.5-3
python-pyqt4 4.12.3-4
python-pyqt5 5.15.0-3
python-pyqt5-sip 12.8.1-1
python-pyquery 1.4.1-3
python-pysmbc 1.0.20-1
python-pysocks 1.7.1-1
python-pysol_cards 0.10.1-1
python-pyudev 0.22-3
python-pywal 3.3.0-2
python-pywapi 0.3.8-7
python-pyxdg 0.26-6
python-random2 1.0.1-4
python-requests 2.24.0-1
python-requests-cache 0.5.2-1
python-resolvelib 0.4.0-1
python-retrying 1.3.3-7
python-rsa 4.6-1
python-scipy 1.5.2-1
python-secretstorage 3.1.2-1
python-setproctitle 1.1.10-5
python-setuptools 1:49.6.0-1
python-shiboken2 5.15.0-2
python-sip 4.19.24-1
python-sip-pyqt4 4.19.22-1
python-soupsieve 2.0.1-1
python-sqlalchemy 1.3.19-1
python-termcolor 1.1.0-8
python-tlsh 3.17.0-2
python-toml 0.10.1-1




-------------------------------------------

python2 2.7.18-1
python2-appdirs 1.4.4-1   # Небольшой модуль Python для определения соответствующих директорий для конкретной платформы, например «директории пользовательских данных»
python2-apsw 3.33.0-1
python2-asn1crypto 1.4.0-1
python2-backports 1.0-3
python2-backports.functools_lru_cache 1.6.1-2
python2-beautifulsoup4 4.9.1-1
python2-cachecontrol 0.12.6-1
python2-cairo 1.18.2-4
python2-cffi 1.14.2-1
python2-chardet 3.0.4-5
python2-colorama 0.4.3-1
python2-configparser 4.0.2-2
python2-contextlib2 0.6.0.post1-1
python2-cryptography 3.1-1
python2-css-parser 1.0.4-3
python2-cssselect 1.1.0-4
python2-cycler 0.10.0-6
python2-dateutil 2.8.1-3
python2-dbus 1.2.16-1
python2-distlib 0.3.1-1
python2-distro 1.5.0-1
python2-dnspython 1.16.0-3
python2-enum34 1.1.9-1
python2-feedparser 5.2.1-6
python2-fuse 1.0.0-2
python2-gevent 20.6.2-1
python2-gobject 3.36.1-1
python2-gobject2 2.28.7-5
python2-greenlet 0.4.16-1
python2-html2text 2019.8.11-4
python2-html5-parser 0.4.9-2
python2-html5lib 1.1-1
python2-httplib2 0.18.1-1
python2-idna 2.10-1
python2-importlib-metadata 1.6.1-1
python2-ipaddress 1.0.23-2
python2-kiwisolver 1.1.0-4
python2-lxml 4.5.2-1
python2-markdown 3.1.1-5
python2-matplotlib 2.2.5-2
python2-mechanize 1:0.4.5-1
python2-msgpack 0.6.2-4
python2-netifaces 0.10.9-3
python2-nose 1.3.7-7
python2-numpy 1.16.6-1
python2-oauth2 1.9.0-1
python2-olefile 0.46-2
python2-opengl 3.1.5-1
python2-ordered-set 3.1.1-3
python2-packaging 20.4-1
python2-pathlib2 2.3.5-1
python2-pep517 0.8.2-1
python2-pillow 6.2.1-2  # Вилка Python Imaging Library (PIL)
python2-pip 20.1.1-1
python2-ply 3.11-5
python2-progress 1.5-3
python2-psutil 5.7.2-1
python2-pyasn1 0.4.8-2
python2-pybluez 0.22-4
python2-pychm 0.8.6-1
python2-pycparser 2.20-1
python2-pycups 1.9.74-1
python2-pygments 2.5.2-2
python2-pyopenssl 19.1.0-2
python2-pyparsing 2.4.7-1
python2-pyphen 0.9.4-1
python2-pyqt4 4.12.3-4
python2-pyqt5 5.15.0-3
python2-pyqtwebengine 5.15.0-2
python2-regex 2020.7.14-1
python2-requests 2.24.0-1
python2-resolvelib 0.4.0-1
python2-retrying 1.3.3-7
python2-rfc6555 0.0.0-2
python2-scandir 1.10.0-3
python2-selectors2 2.0.1-4
python2-setuptools 2:44.1.1-1
python2-simplejson 3.17.2-1
python2-sip-pyqt4 4.19.22-1
python2-sip-pyqt5 4.19.24-1
python2-six 1.15.0-1
python2-soupsieve 1.9.6-2
python2-toml 0.10.1-1
python2-unrardll 0.1.4-2
python2-uritemplate 3.0.1-1
python2-urllib3 1.25.10-1
python2-webencodings 0.5.1-4
python2-zipp 1:1.1.1-1
python2-zope-event 4.4-3
python2-zope-interface 5.1.0-1
python3-memoizedb 2017.3.30-4
python3-xcgf 2017.3-4
python3-xcpf 2019.11-2

python2 2.7.18-1
python2-pyxdg 0.26-6
------------------------------------------


Дополнительно


# AUR - # python-imaging ???
# engrampa  - Манипулятор архивов для MATE
# engrampa-thunar-plugin  - AUR - Манипулятор архивов из MATE без зависимости от Caja (версия GTK3)
# galculator-gtk2 или galculator
# gnome-calculator 

# cups-bjnp AUR  # Серверная часть CUPS для принтеров canon с использованием проприетарного протокола USB over IP BJNP
# cups-xerox 2008.01.23-1  AUR   # Драйверы для различных принтеров Xerox
# cups-xerox-phaser-3600 3.00.27+187-2  AUR   # Драйвер CUPS для серии Xerox Phaser 3600. Также поддерживает fc2218, pe120, pe220, Phaser 3117, 3200, 3250, 3250, 3300, 3435, 3600, 6110, WorkCentre 3210, 3220, 4118
# cups-xerox-phaser-6500 1.0.0-2   AUR   # Драйвер CUPS для серии Xerox Phaser 6500 (N & DN)

###################  #################



#####################################


echo 'Обновим информацию о шрифтах'
# Update information about fonts
sudo fc-cache -f -v

echo 'Список всех пакетов-сирот'
# List of all orphan packages
sudo pacman -Qdt 

sleep 5
echo 'Удаление всех пакетов-сирот?'
# Deleting all orphaned packages?
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -Qdtq
elif [[ $prog_set == 0 ]]; then
  echo 'Удаление пакетов-сирот пропущено.'
fi    

echo 'Очистка кэша неустановленных пакетов'
# Clearing the cache of uninstalled packages
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -Sc 
elif [[ $prog_set == 0 ]]; then
  echo 'Очистка кэша пропущена.'
fi  

echo 'Очистка кэша пакетов'
# Clearing the package cache
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -Scc 
elif [[ $prog_set == 0 ]]; then
  echo 'Очистка кэша пропущена.'
fi 

echo 'Список Установленного софта (пакетов)'
#List of Installed software (packages)
sudo pacman -Qqe

# ============================================================================
#echo 'Установка тем'
#yay -S osx-arc-shadow papirus-maia-icon-theme-git breeze-default-cursor-theme --noconfirm

#echo 'Ставим лого ArchLinux в меню'
#wget git.io/arch_logo.png
#sudo mv -f ~/Downloads/arch_logo.png /usr/share/pixmaps/arch_logo.png

#echo 'Ставим обои на рабочий стол'
#wget git.io/bg.jpg
#sudo rm -rf /usr/share/backgrounds/xfce/* #Удаляем стандартрые обои
#sudo mv -f ~/Downloads/bg.jpg /usr/share/backgrounds/xfce/bg.jpg
# ============================================================================

sleep 5
echo -e "${GREEN}
  Установка софта (пакетов) завершена!
${NC}"
# Installation of software (packages) is complete!
#echo 'Установка завершена!'
# The installation is now complete!

echo 'Желательно перезагрузить систему для применения изменений'
# It is advisable to restart the system to apply the changes
# ============================================================================
time

echo 'Удаление созданной папки (downloads), и скрипта установки программ (arch3my)'
# Deleting the created folder (downloads) and the program installation script (arch3my)
sudo rm -R ~/downloads/
sudo rm -rf ~/arch4my

echo " Установка завершена для выхода введите >> exit << "
exit


##############################
Enable AUR support for Arch Linux
Включите нашу поддержку Arch Linux
Установите его непосредственно из исходного кода. ( рекомендуемый )
Install Yourt Directly from source. ( recommended )

Замените /user своим именем пользователя в приведенных ниже командах.
Replace /user with your user name in the commands below.

sudo pacman -S git

sudo git clone https://aur.archlinux.org/package-query.git
     cd package-query  

sudo chown -R $(whoami) /home/alex/package-query    
sudo chmod 775 /home/alex/package-query
makepkg -si
     cd ..
     

package-query - Запрос ALPM и AUR  https://aur.archlinux.org/packages/package-query/
https://github.com/archlinuxfr/package-query/

package-query-git - Запрос ALPM и AUR # https://aur.archlinux.org/package-query-git.git
https://aur.archlinux.org/packages/package-query-git/
#################################

echo -e "${BLUE}==> ${NC}Выйти из настроек, или перезапустить систему?"
#echo "Выйти из настроек, или перезапустить систему?"
# Exit settings, or restart the system?
echo -e "${GREEN}==> ${NC}y+Enter - выйти, просто Enter - перезапуск"
#echo "y+Enter - выйти, просто Enter - перезапуск"
# y+Enter-exit, just Enter-restart
read doing 
case $doing in
y)
  exit
 ;;
*)
sudo reboot -f
esac #окончание оператора case.
#

#echo ""
#echo -e "${BLUE}:: ${NC}Информацию о видеокарте"
#lshw -c video
# После нового входа в систему, вы можете проверить версию драйвера, на котором работает ваша видеокарта, следующей командой:
#glxinfo | grep OpenGL
Parental Control: Family Friendly Filter
by Media Partners
https://addons.mozilla.org/en-US/firefox/addon/family-friendly-filter/?src=search

Резюмирую:
1. Для контроля времени доступа и общего времени сидения за компом удобно использовать пакет timekpr-next-git из aur.
2. Для убирания рекламных баннеров в mozilla addons.mozilla.org/en-US/firefox/addon/adblock-plus/ (Adblock Plus by Adblock Plus)
3. addons.mozilla.org/en-US/firefox/addon/family-friendly-filter/?src=search (Parental Control: Family Friendly Filterby Media Partners) позволяет защитить ребенка от случайных переходов на сайты для взрослых (при этом прямой поиск в строке яндекса ни каких ограничений не имеет (это для любителей «свободы» ратующих за демонстрацию порно своим детям @Gambit_VKM и @dimonmmk ) и addons.mozilla.org/en-US/firefox/addon/blocksite/?src=search (BlockSite) позволяет ограничить не только доступ к сайтам, но и время нахождения в интернете, защищен паролем от несанкционированных изменений) (что бы вообще защитить firefox от изменения настроек и удаления расширений можно использовать addons.mozilla.org/ru/firefox/addon/public-fox/
4. настройка dns.yandex.ru/ тоже не дает защиты от прямого поиска и просмотра во вкладке видео поиска Яндекс.
5. отличный результат показала настройка duckduckgo.com/settings на все запросы 18+ выдает поиск максимум 16+ ближе к 14+
6. Нативного решения ограничения доступа к установленным приложениям (решения от pantheon из Community и aur switchboard-plug-parental-controls не работают в xfce (наверное многим «технарям» это очевидно). Здесь пока могут помочь только настройки групп доступа через chmod, что приведет к желаемому результату. Другого решения я не нашел

В общем [решено].


Список установленных пакетов в системе. Подробно.

LANG=C pacman -Sl | awk '/\[installed\]$/ {print $1 "/" $2 "-" $3}' > ~/pkglist.txt

LANG=C pacman -Sl | awk '/\[installed\]$/ {print $2}' > ~/.pkglist.txt
Кратко.

pacman -Qqe > ~/pkglist.txt

pacman -Qqm > ~/aurlist.txt

============================
Soft AUR ===================
============================

===============================================



-----------------------------------------------

papirus-libreoffice-theme  -  # Тема Papirus для LibreOffice
https://aur.archlinux.org/packages/papirus-libreoffice-theme/
https://aur.archlinux.org/papirus-libreoffice-theme.git
https://github.com/PapirusDevelopmentTeam/papirus-libreoffice-theme

papirus-libreoffice-theme-git  -  # Тема Papirus для LibreOffice
https://aur.archlinux.org/packages/papirus-libreoffice-theme-git/
https://aur.archlinux.org/papirus-libreoffice-theme-git.git
https://github.com/PapirusDevelopmentTeam/papirus-libreoffice-theme

-----------------------------------------------

wps-office  -  # Kingsoft Office (WPS Office) - офисный пакет для повышения производительности
https://aur.archlinux.org/packages/wps-office/
https://aur.archlinux.org/wps-office.git 
http://wps-community.org/

ttf-wps-fonts  -  # Если установлен WPS - Символьные шрифты требуются wps-office
https://aur.archlinux.org/packages/ttf-wps-fonts/
https://aur.archlinux.org/ttf-wps-fonts.git 
https://github.com/IamDH4/ttf-wps-fonts

wps-office-mui-ru-ru  -  # Пакеты MUI для WPS Office
https://vk.com/topic-24135048_40468416
https://gist.github.com/LEONARDO-DANIEL/be37de41060ea16f98c684702bbefd22


wps-office-fonts  -  # Пакет wps-office-fonts содержит китайские шрифты Founder
https://aur.archlinux.org/packages/wps-office-fonts/
https://aur.archlinux.org/wps-office-fonts.git
http://wps-community.org/

wps-office-extension-russian-dictionary  -  # Русский словарь для WPS Office
https://aur.archlinux.org/packages/wps-office-extension-russian-dictionary
https://aur.archlinux.org/wps-office-extension-russian-dictionary.git
https://github.com/wps-community/wps_community_website/tree/master/root/download/dicts

------------------------------------------

openoffice  -  # Apache OpenOffice 
https://aur.archlinux.org/packages/openoffice/
https://aur.archlinux.org/openoffice.git 
http://www.openoffice.org

openoffice-ru-bin  -  # Пакет русского языка для OpenOffice.org
https://aur.archlinux.org/packages/openoffice-ru-bin/
https://aur.archlinux.org/openoffice-ru-bin.git 
http://www.openoffice.org/

-----------------------------------------

onlyoffice-bin  -  # Офисный пакет, сочетающий в себе редакторы текста, таблиц и презентаций
https://aur.archlinux.org/packages/onlyoffice-bin/
https://aur.archlinux.org/onlyoffice-bin.git 
https://www.onlyoffice.com/

-----------------------------------------

skypeforlinux-stable-bin  -  # Skype для Linux - стабильная / окончательная версия
https://aur.archlinux.org/packages/skypeforlinux-stable-bin/
https://aur.archlinux.org/skypeforlinux-stable-bin.git 
http://www.skype.com

skype-call-recorder  -  # Записывайте звонки Skype в файлы MP3, Ogg Vorbis или WAV  (Skype-Call-Recorder)
https://aur.archlinux.org/packages/skype-call-recorder/
https://aur.archlinux.org/skype-call-recorder.git 
http://atdot.ch/scr/

-----------------------------------------

vk-messenger  -  # VK Messenger для Linux
https://aur.archlinux.org/packages/vk-messenger/
https://aur.archlinux.org/vk-messenger.git 
https://vk.com/messenger

-----------------------------------------

viber  -  # Проприетарное кроссплатформенное программное обеспечение для обмена мгновенными сообщениями и VoIP
https://aur.archlinux.org/packages/viber/
https://aur.archlinux.org/viber.git 
https://www.viber.com

-----------------------------------------

pidgin-extprefs  -  # Плагин добавляет дополнительные настройки для pidgin
https://aur.archlinux.org/packages/pidgin-extprefs/
https://aur.archlinux.org/pidgin-extprefs.git 
http://gaim-extprefs.sourceforge.net/

------------------------------------------

system-config-samba  -  # Инструмент настройки Samba от Red Hat
https://aur.archlinux.org/packages/system-config-samba/
https://aur.archlinux.org/system-config-samba.git 
http://fedoraproject.org/wiki/SystemConfig/samba

------------------------------------------

gksu  -  # Графический интерфейс для su
https://aur.archlinux.org/packages/gksu/
https://aur.archlinux.org/gksu.git 
http://www.nongnu.org/gksu/index.html

libgksu  -  # библиотека авторизации gksu
https://aur.archlinux.org/packages/libgksu/
https://aur.archlinux.org/libgksu.git 
http://www.nongnu.org/gksu/index.html

gconf  -  # Устаревшая система базы данных конфигурации
https://aur.archlinux.org/packages/gconf/
https://aur.archlinux.org/gconf.git
https://projects-old.gnome.org/gconf/

----------------------------------------

debtap  - ------
debugap  -  # Сценарий для преобразования пакетов .deb в пакеты Arch Linux, ориентированный на точность. Не используйте его для преобразования пакетов, которые уже существуют в официальных репозиториях или могут быть собраны из AUR!
https://aur.archlinux.org/packages/debtap/
https://aur.archlinux.org/debtap.git  
https://github.com/helixarch/debtap

----------------------------------------

menulibre  -  # Продвинутый редактор меню, который предоставляет современные функции в чистом, простом в использовании интерфейсе
https://aur.archlinux.org/packages/menulibre/
https://aur.archlinux.org/menulibre.git 
https://github.com/bluesabre/menulibre
Menulibre

-----------------------------------------

xneur  -  # X Neural Switcher определяет язык ввода и при необходимости корректирует раскладку клавиатуры
https://aur.archlinux.org/packages/xneur/
https://aur.archlinux.org/xneur.git
http://www.xneur.ru

gxneur  -  # Интерфейс GTK для XNeur
https://aur.archlinux.org/packages/gxneur/
https://aur.archlinux.org/gxneur.git 
http://www.xneur.ru

------------------------------------------

fsearch-git  -  # Утилита быстрого поиска файлов. Версия Git
https://aur.archlinux.org/packages/fsearch-git/
https://aur.archlinux.org/fsearch-git.git
https://cboxdoerfer.github.io/fsearch

-----------------------------------------

cherrytree  -  # Приложение для создания иерархических заметок
https://aur.archlinux.org/packages/cherrytree/
https://aur.archlinux.org/cherrytree.git
https://www.giuspen.com/cherrytree/

cherrytree-bin  -  # Двоичная версия Cherrytree
https://aur.archlinux.org/packages/cherrytree-bin/
https://aur.archlinux.org/cherrytree-bin.git
https://www.giuspen.com/cherrytree/

cherrytree  -  # Приложение для создания иерархических заметок, версия git
https://aur.archlinux.org/packages/cherrytree-git/
https://aur.archlinux.org/cherrytree-git.git 
https://github.com/giuspen/cherrytree

----------------------------------------

timeshift  -  # Утилита восстановления системы для Linux
https://aur.archlinux.org/packages/timeshift/
https://aur.archlinux.org/timeshift.git 
https://github.com/teejee2008/timeshift

timeshift-autosnap  -  # Скрипт автоматического создания снимков Timeshift, который запускается перед обновлением пакета с помощью перехвата Pacman
https://aur.archlinux.org/packages/timeshift-autosnap/
https://aur.archlinux.org/timeshift-autosnap.git 
https://gitlab.com/gobonja/timeshift-autosnap

autoupgrade  -  # Автоматический снимок с последующим обновлением системы. (В случае сбоя системы запустите `sudo timeshift --restore` и удалите этот пакет, пока проблема не будет решена.)
https://aur.archlinux.org/packages/autoupgrade/
https://aur.archlinux.org/autoupgrade.git 
https://github.com/star2000/autoupgrade

---------------------------------------


---------------------------------------

multiload-ng-indicator-gtk    -  --------
multiload-ng-indicator-gtk2  -  # Современный графический системный монитор, плагин AppIndicator
https://aur.archlinux.org/packages/multiload-ng-indicator-gtk2/
https://aur.archlinux.org/multiload-ng-indicator-gtk2.git
https://udda.github.io/multiload-ng/

multiload-ng-indicator-gtk3  -  # Современный графический системный монитор, плагин AppIndicator
https://aur.archlinux.org/packages/multiload-ng-indicator-gtk3/
https://aur.archlinux.org/multiload-ng-indicator-gtk3.git
https://udda.github.io/multiload-ng/

---------------------------------------

xfce4-multiload-ng-plugin-gtk2  -  # Современный графический системный монитор, плагин панели XFCE4
https://aur.archlinux.org/packages/xfce4-multiload-ng-plugin-gtk2/
https://aur.archlinux.org/xfce4-multiload-ng-plugin-gtk2.git 
https://udda.github.io/multiload-ng/

--------------------------------------

keepass2-plugin-tray-icon  -  # Функциональная иконка в трее для KeePass2
https://aur.archlinux.org/packages/keepass2-plugin-tray-icon/
https://aur.archlinux.org/keepass2-plugin-tray-icon.git 
https://github.com/dlech/Keebuntu

---------------------------------------

gconf-editor  -  # Графический редактор реестра gconf
https://aur.archlinux.org/packages/gconf-editor/
https://aur.archlinux.org/gconf-editor.git
https://www.gnome.org

----------------------------------------

gconf-cleaner  -  # Инструмент очистки для GConf
https://aur.archlinux.org/packages/gconf-cleaner/
https://aur.archlinux.org/gconf-cleaner.git 
http://code.google.com/p/gconf-cleaner

----------------------------------------

webtorrent-desktop  -  # Потоковый торрент-клиент
https://aur.archlinux.org/packages/webtorrent-desktop/
https://aur.archlinux.org/webtorrent-desktop.git 
https://webtorrent.io/desktop

webtorrent-desktop-bin  -  # Потоковый торрент-клиент
https://aur.archlinux.org/packages/webtorrent-desktop-bin/
https://aur.archlinux.org/webtorrent-desktop-bin.git
https://webtorrent.io/desktop

--------------------------------------

teamviewer  -  # Универсальное программное обеспечение для удаленной поддержки и онлайн-встреч
https://aur.archlinux.org/packages/teamviewer/
https://aur.archlinux.org/teamviewer.git 
http://www.teamviewer.com

--------------------------------------

corectrl  -  # Основное приложение управления
https://aur.archlinux.org/packages/corectrl/
https://aur.archlinux.org/corectrl.git 
https://gitlab.com/corectrl/corectrl
https://gitlab.com/corectrl/corectrl/-/archive/v1.1.1/corectrl-v1.1.1.tar.bz2

corectrl-git  -  # Приложение для легкого управления оборудованием с помощью профилей приложений
https://aur.archlinux.org/packages/corectrl-git/
https://aur.archlinux.org/corectrl-git.git
https://gitlab.com/corectrl/corectrl

--------------------------------------

qt4  -  # Кросс-платформенное приложение и UI-фреймворк
https://aur.archlinux.org/packages/qt4/
https://aur.archlinux.org/qt4.git
https://www.qt.io
https://wiki.archlinux.org/index.php/Qt_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
Бинарная версия последней версии (4.8.7-32) с подписью PGP доступна здесь:
https://ftp.desolve.ru/ftp/viktor/binpkg/qt4/

--------------------------------------

xflux  -  # (f.lux для X) Адаптивно изменяет цветовую температуру монитора, чтобы снизить нагрузку на глаза (версия для командной строки)
https://aur.archlinux.org/packages/xflux/
https://aur.archlinux.org/xflux.git
https://justgetflux.com/

xflux-gui-git  -  # Лучшее освещение для Linux. Графический интерфейс с открытым исходным кодом для xflux
https://aur.archlinux.org/packages/xflux-gui-git/
https://aur.archlinux.org/xflux-gui-git.git
https://justgetflux.com/linux.html

---------------------------------------

flameshot-git  -  # Мощное, но простое в использовании программное обеспечение для создания снимков экрана
https://aur.archlinux.org/packages/flameshot-git/
https://aur.archlinux.org/flameshot-git.git 
https://github.com/flameshot-org/flameshot

-----------------------------------------

lib32-simplescreenrecorder  -  # Записывайте 32-разрядные приложения OpenGL с помощью SimpleScreenRecorder. (Версия Git)
https://aur.archlinux.org/packages/lib32-simplescreenrecorder-git/
https://aur.archlinux.org/lib32-simplescreenrecorder-git.git
https://www.maartenbaert.be/simplescreenrecorder/

-------------------------------------

mkinitcpio-openswap  -  # mkinitcpio, чтобы открыть своп во время загрузки
https://aur.archlinux.org/packages/mkinitcpio-openswap/
https://aur.archlinux.org/mkinitcpio-openswap.git 
https://aur.archlinux.org/packages/mkinitcpio-openswap/

--------------------------------------

fetchmirrors  -  # Получите новый зеркальный список pacman и оцените лучшее
https://aur.archlinux.org/packages/fetchmirrors/
https://aur.archlinux.org/fetchmirrors.git 
https://github.com/deadhead420/fetchmirrors

-------------------------------------

gtk3-mushrooms  -  # GTK3 исправлен для классических настольных компьютеров, таких как XFCE или MATE. См. README
https://aur.archlinux.org/packages/gtk3-mushrooms/
https://aur.archlinux.org/gtk3-mushrooms.git
https://github.com/krumelmonster/gtk3-mushrooms

-------------------------------------

lib32-libudev0  -  # 
# ( lib32-libudev0-shim-nosystemd )  -  # Библиотека совместимости libudev.so.0 для систем с более новыми версиями udev (32 бит)
https://aur.archlinux.org/packages/lib32-libudev0-shim-nosystemd/
https://aur.archlinux.org/lib32-libudev0-shim-nosystemd.git
https://github.com/archlinux/libudev0-shim

------------------------------------

xfce4-calculator-plugin  -  # Плагин калькулятора для панели Xfce4
https://aur.archlinux.org/packages/xfce4-calculator-plugin/
https://aur.archlinux.org/xfce4-calculator-plugin.git 
http://goodies.xfce.org/projects/panel-plugins/xfce4-calculator-plugin

---------------------------------------

xfce4-places-plugin  -  # Плагин меню Places для панели Xfce
https://aur.archlinux.org/packages/xfce4-places-plugin/
https://aur.archlinux.org/xfce4-places-plugin.git
http://goodies.xfce.org/projects/panel-plugins/xfce4-places-plugin

-------------------------------------

oh-my-zsh-git  -  # Платформа сообщества для управления вашей конфигурацией zsh. Включает 180+ дополнительных плагинов и более 120 тем, чтобы оживить ваше утро, а также инструмент автоматического обновления, чтобы вы могли легко быть в курсе последних обновлений от сообщества
https://aur.archlinux.org/packages/oh-my-zsh-git/
https://aur.archlinux.org/oh-my-zsh-git.git
https://github.com/ohmyzsh/ohmyzsh

--------------------------------------

zsh-theme-powerlevel10k-git  -  # Powerlevel10k - это тема для Zsh. Он подчеркивает скорость, гибкость и готовность к работе.
https://aur.archlinux.org/packages/zsh-theme-powerlevel10k-git/
https://aur.archlinux.org/zsh-theme-powerlevel10k-git.git 
https://github.com/romkatv/powerlevel10k


-----------------------------------

zsh-fast-syntax-highlighting-git  -  # Оптимизированная и расширенная подсветка синтаксиса zsh
https://aur.archlinux.org/packages/zsh-fast-syntax-highlighting-git/
https://aur.archlinux.org/zsh-fast-syntax-highlighting-git.git
https://github.com/zdharma/fast-syntax-highlighting


-----------------------------------

nohang  AUR - # Сложный обработчик нехватки памяти

https://aur.archlinux.org/packages/nohang/
https://aur.archlinux.org/nohang.git
https://github.com/hakavlad/nohang

Last Updated: 2021-03-18 07:38
Сложный обработчик нехватки памяти


nohang-git  AUR -  # Сложный обработчик нехватки памяти

https://aur.archlinux.org/packages/nohang-git/
https://aur.archlinux.org/nohang-git.git 
https://github.com/hakavlad/nohang

Last Updated: 2020-07-04 12:10
Сложный обработчик нехватки памяти

----------------------------------

ananicy-git  AUR  -  #  Ananicy - еще один автоматический демон с поддержкой правил сообщества
https://aur.archlinux.org/packages/ananicy-git/
https://aur.archlinux.org/ananicy-git.git 
https://github.com/Nefelim4ag/Ananicy.git


ananicy  AUR  -  #  Еще один демон auto nice с поддержкой правил сообщества
https://aur.archlinux.org/packages/ananicy/
https://aur.archlinux.org/ananicy.git 
https://github.com/Nefelim4ag/Ananicy.git

-----------------------------------




=====================================

vim-colorsamplerpack  -  # Различные цветовые схемы для vim
https://aur.archlinux.org/packages/vim-colorsamplerpack/
https://aur.archlinux.org/vim-colorsamplerpack.git
http://www.vim.org/scripts/script.php?script_id=625

vim-doxygentoolkit  -  # Этот скрипт упрощает документацию doxygen на C / C ++
https://aur.archlinux.org/packages/vim-doxygentoolkit/
https://aur.archlinux.org/vim-doxygentoolkit.git 
http://www.vim.org/scripts/script.php?script_id=987


vim-guicolorscheme  -  # Автоматическое преобразование цветовых схем только для графического интерфейса в схемы цветовых терминалов 88/256
https://aur.archlinux.org/packages/vim-guicolorscheme/
https://aur.archlinux.org/vim-guicolorscheme.git
http://www.vim.org/scripts/script.php?script_id=1809

vim-jellybeans  -  # Яркая, темная цветовая гамма, вдохновленная ir_black и сумерками
https://aur.archlinux.org/packages/vim-jellybeans/
https://aur.archlinux.org/vim-jellybeans.git
https://github.com/nanotech/jellybeans.vim
https://aur.archlinux.org/packages/vim-jellybeans-git/
https://aur.archlinux.org/vim-jellybeans-git.git
https://github.com/nanotech/jellybeans.vim

vim-minibufexpl  -  # Элегантный обозреватель буферов для vim
https://aur.archlinux.org/packages/vim-minibufexpl/
https://aur.archlinux.org/vim-minibufexpl.git 
http://fholgado.com/minibufexpl

vim-omnicppcomplete  -  # vim c ++ завершение omnifunc с базой данных ctags
https://aur.archlinux.org/packages/vim-omnicppcomplete/
https://aur.archlinux.org/vim-omnicppcomplete.git 
http://www.vim.org/scripts/script.php?script_id=1520

vim-project  -  # Организовывать и перемещаться по проектам файлов (например, в проводнике ide / buffer)
https://aur.archlinux.org/packages/vim-project/
https://aur.archlinux.org/vim-project.git
http://www.vim.org/scripts/script.php?script_id=69

vim-rails  -  # Плагин ViM для усовершенствованной разработки приложений Ruby on Rails
https://aur.archlinux.org/packages/vim-rails/
https://aur.archlinux.org/vim-rails.git 
http://www.vim.org/scripts/script.php?script_id=1567

vim-taglist  -  # Плагин браузера с исходным кодом для vim
https://aur.archlinux.org/packages/vim-taglist/
https://aur.archlinux.org/vim-taglist.git 
http://vim-taglist.sourceforge.net

vim-vcscommand  -  # Плагин интеграции системы контроля версий vim
https://aur.archlinux.org/packages/vim-vcscommand/
https://aur.archlinux.org/vim-vcscommand.git
http://www.vim.org/scripts/script.php?script_id=90

vim-workspace  -  # Плагин vim workspace manager для управления группами файлов
https://aur.archlinux.org/packages/vim-workspace/
https://aur.archlinux.org/vim-workspace.git 
http://www.vim.org/scripts/script.php?script_id=1410


======================================

zip-natspec  -  # Создает PKZIP-совместимые файлы .zip для нелатинских имен файлов с использованием патча libnatspec от AltLinux
https://aur.archlinux.org/packages/zip-natspec/
https://aur.archlinux.org/zip-natspec.git 
http://www.info-zip.org/pub/infozip/Zip.html
Последнее обновление: 2017-05-24 16:27

unzip-natspec  -  # Распаковывает архивы .zip с нелатинскими именами файлов, используя патч libnatspec от AltLinux
https://aur.archlinux.org/packages/unzip-natspec/
https://aur.archlinux.org/unzip-natspec.git 
http://www.info-zip.org/
Последнее обновление: 2015-11-04 15:12

#p7zip-natspec  -  # Файловый архиватор командной строки с высокой степенью сжатия, основанный на патче libnatspec из ubuntu zip-i18n PPA (https://launchpad.net/~frol/+archive/zip-i18n)
https://aur.archlinux.org/packages/p7zip-natspec/
https://aur.archlinux.org/p7zip-natspec.git
http://p7zip.sourceforge.net/
Последнее обновление: 2020-06-30 21:13

libnatspec  -  # Набор функций для запроса различных кодировок и локалей для хост-системы и для другой системы
https://aur.archlinux.org/packages/libnatspec/
https://aur.archlinux.org/libnatspec.git 
http://sourceforge.net/projects/natspec/
Последнее обновление: 2015-10-15 17:48

====================================

freshplayerplugin  -  # PPAPI-host Адаптер NPAPI-plugin (Recommended)
https://aur.archlinux.org/packages/freshplayerplugin/
https://aur.archlinux.org/freshplayerplugin.git 
https://github.com/i-rinat/freshplayerplugin

freshplayerplugin-git  -  # PPAPI-host Адаптер NPAPI-plugin
https://aur.archlinux.org/packages/freshplayerplugin-git/
https://aur.archlinux.org/freshplayerplugin-git.git 
https://github.com/i-rinat/freshplayerplugin

-----------------------------------------

vivaldi  -  # Продвинутый браузер, созданный для опытных пользователей
https://archlinux.org/packages/community/x86_64/vivaldi/
https://aur.archlinux.org/vivaldi.git
https://vivaldi.com

vivaldi-ffmpeg-codecs  -  # Дополнительная поддержка проприетарных кодеков для vivaldi
https://archlinux.org/packages/community/x86_64/vivaldi-ffmpeg-codecs/
https://aur.archlinux.org/vivaldi-ffmpeg-codecs.git 
https://ffmpeg.org/

passff-host -  # Хост-приложение для обмена сообщениями PassFF для Firefox, Chromium, Chrome, Vivaldi
https://archlinux.org/packages/community/any/passff-host/
https://github.com/passff/passff-host

-------------------------------------

ktorrent-git  -  # Мощный клиент BitTorrent. (Версия GIT)
https://aur.archlinux.org/packages/ktorrent-git/
https://aur.archlinux.org/ktorrent-git.git 
https://kde.org/applications/en/internet/org.kde.ktorrent

libktorrent-git  -  # Реализация протокола BitTorrent. (Версия GIT)
https://aur.archlinux.org/packages/libktorrent-git/
https://aur.archlinux.org/libktorrent-git.git 
https://projects.kde.org/projects/extragear/network/libktorrent

mktorrent-git  -  # Простая утилита командной строки для создания файлов метаинфо BitTorrent
https://aur.archlinux.org/packages/mktorrent-git/
https://aur.archlinux.org/mktorrent-git.git
https://github.com/Rudde/mktorrent

rutorrent-git  -  # Веб-интерфейс для rTorrent на PHP, напоминающий uTorrent
https://aur.archlinux.org/packages/rutorrent-git/
https://aur.archlinux.org/rutorrent-git.git 
https://github.com/Novik/ruTorrent


tixati  -  # Tixati - это программа для однорангового обмена файлами, использующая популярный протокол BitTorrent
https://aur.archlinux.org/packages/tixati/
https://aur.archlinux.org/tixati.git 
http://www.tixati.com/

-------------------------------------



---------------------------------------


AUR 

yay -S artwiz-fonts --noconfirm
 -> Невозможно найти все требуемые пакеты:
  xorg-font-utils (требуется пакету: artwiz-fonts)
yay -S artwiz-fonts --noconfirm  6,89s user 0,45s system 106% cpu 6,912 total


предупреждение: ttf-clear-sans-1.00-3 не устарел -- переустанавливается
разрешение зависимостей...
yay -S powerline-fonts-git --noconfirm
:: Проверка конфликтов...
:: Проверка внутренних конфликтов...
 -> 
Обнаружены конфликты пакетов:
 -> Установка powerline-fonts-git приведёт к удалению: powerline-fonts, ttf-hack
конфликты пакетов не могут быть разрешены опцией noconfirm, прерывание
yay -S powerline-fonts-git --noconfirm  7,06s user 0,47s system 111% cpu 6,734 total
yay -S artwiz-fonts --noconfirm
 -> Невозможно найти все требуемые пакеты:
  xorg-font-utils (требуется пакету: artwiz-fonts)
yay -S artwiz-fonts --noconfirm  7,08s user 0,53s system 106% cpu 7,127 total

yay -S ttf-droid-sans-mono-slashed-powerline-git --noconfirm 
 -> Невозможно найти все требуемые пакеты:
  xorg-font-utils (требуется пакету: ttf-droid-sans-mono-slashed-powerline-git)
yay -S ttf-droid-sans-mono-slashed-powerline-git --noconfirm  7,23s user 0,40s system 100% cpu 7,563 total

yay -S ttf-dejavu-sans-mono-powerline-git --noconfirm 
 -> Невозможно найти все требуемые пакеты:
  xorg-font-utils (требуется пакету: ttf-dejavu-sans-mono-powerline-git)
yay -S ttf-dejavu-sans-mono-powerline-git --noconfirm  7,24s user 0,38s system 101% cpu 7,525 total

==> ОШИБКА: Ошибка при создании рабочей копии репозитория 'material-design-icons' (git)
    Прерывание...
ошибка сборки: ttf-material-icons-git
yay -S ttf-material-icons-git --noconfirm  34,57s user 9,60s system 81% cpu 53,960 total

yay -S nerd-fonts-hack --noconfirm 
:: Проверка конфликтов...
:: Проверка внутренних конфликтов...
[Aur:1]  nerd-fonts-hack-2.1.0-3

ошибка клонирования nerd-fonts-hack: 
yay -S nerd-fonts-hack --noconfirm  

##########################################
есть в системе


mobile-broadband-provider-info - # Демон сетевого управления (информация о провайдере мобильного широкополосного доступа)
https://www.archlinux.org/packages/extra/any/mobile-broadband-provider-info/

gptfdisk - # Инструмент для создания разделов в текстовом режиме, который работает с дисками с таблицей разделов GUID (GPT) 
https://www.archlinux.org/packages/extra/x86_64/gptfdisk/

groff - # Система форматирования текста GNU troff
https://www.archlinux.org/packages/core/x86_64/groff/

fuse2 - # Библиотека, позволяющая реализовать файловую систему в программе пользовательского пространства
https://www.archlinux.org/packages/extra/x86_64/fuse2/

fuse3 - # Библиотека, позволяющая реализовать файловую систему в программе пользовательского пространства
https://www.archlinux.org/packages/extra/x86_64/fuse3/



##############################

sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #

##############################

yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #

#############################

clear
echo -e "${MAGENTA}
<<< Установка дополнительного программного обеспечения для создания, изменения - пакетов, и дальнейшей установке их в  систему Archlinux >>> ${NC}"
# Installing additional software to create, modify, and install packages in the Archlinux system

echo ""
echo -e "${GREEN}==> ${NC}Установить Debtap для элементарной (базовой) конвертации (преобразования) *.deb пакетов в *.pkg.tar.xz(-any.pkg.tar.zst), и дальнейшей установке в Archlinux?"
# Install Deb tar to convert *. deb packages to *.pkg.tar.xz(-any.pkg.tar.zcf), and then install them in the system?
echo -e "${MAGENTA}=> ${BOLD}Debtap - это Скрипт для преобразования пакетов .deb в пакеты Arch Linux, ориентированный на точность. Не используйте его для преобразования пакетов, которые уже существуют в официальных репозиториях (Arch Based Distribution), или могут быть собраны из AUR! (https://github.com/helixarch/debtap) ${NC}"
echo -e "${CYAN}:: ${NC}Он работает аналогично с alien (который конвертирует пакеты .deb в пакеты .rpm и наоборот), но, в отличие от alien, он ориентирован на точность преобразования, пытаясь перевести имена пакетов Debian / Ubuntu в правильные пакеты Arch Linux, и сохранить их в полях зависимостей метаданных .PKGINFO в окончательном пакете..."
echo -e "${CYAN}:: ${NC}Установка debtap проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/debtap.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/debtap), собирается и устанавливается."
echo -e "${YELLOW}=> Важно: ${NC}Перед установкой (преобразованных) пакетов - ВЫПОЛНИТЕ резервное копирование пользовательских данных /пространства (разделов системы)-(возможность повреждения вашей системы)!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_deb  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_deb" =~ [^10] ]]
do
    :
done
if [[ $i_deb == 0 ]]; then
echo ""  
echo " Установка debtap (преобразование пакетов .deb) пропущена "
elif [[ $i_deb == 1 ]]; then
  echo ""
  echo " Установка скрипта debtap (для преобразования пакетов .deb) "
##### debtap ###### 
# yay -S debtap --noconfirm  # Сценарий для преобразования пакетов .deb в пакеты Arch Linux, ориентированный на точность. Не используйте его для преобразования пакетов, которые уже существуют в официальных репозиториях или могут быть собраны из AUR!
git clone https://aur.archlinux.org/debtap.git  
cd debtap
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf debtap
rm -Rf debtap   # удаляем директорию сборки
echo ""
echo " Настройка перед использованием: (Вы делаете это с привилегиями root) "
echo " Выполняется синхронизация репозиториев Arch'a (обновим pkgfile и базу данных debtap), и доустановка недостающих компонентов (деталей) "
sudo debtap -u
# sudo debtap -U  # сделаем первый запуск скрипта
echo ""
echo " Сборка и установка debtap выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
sleep 02
# ---------------------------
# Доступные параметры debtap:
#    -h --help Распечатать справку
#    -u --update Обновить базу данных долгового соглашения
#    -q --quiet Пропустить все вопросы, кроме редактирования файла (ов) метаданных
#    -Q --Quiet Пропустить все вопросы (не рекомендуется)
#    -s - -pseudo Создать псевдо-64-битный пакет из 32-битного пакета .deb
#    -w --wipeout Удалить версии из всех зависимостей, конфликтов и т. д.
#    -p --pkgbuild Дополнительно создать файл PKGBUILD
#    -P --Pkgbuild Создать PKGBUILD только файл
#    -v --version Версия для печати
# -----------------------------
# Команда по работе со скриптом debtap
# Конвертировать .deb пакеты:
# debtap (имя пакета).deb  # debtap package_name.deb
# Утилита задает вопрос о желаемом имени пакета, о его лицензии. Дальше распакует пакет, соберет информацию, сформирует структуру и предложит внести правки в PKGINFO и INSTALL, от чего можно и отказаться. После этого будет сгенерирован пакет для арча, который ставится обычным образом.
# Посмотрим на файлы, что лежат в папке сборки: 
# ls
# Установка программы (пакета):
# sudo pacman -U (имя пакета).pkg.tar.xz  # sudo pacman -U package_name.pkg
# Не рекомендуется (возможно, опасно)
# Этот метод пытается установить пакет, используя формат упаковки debian на Arch, который не рекомендуется из-за возможной опасности повреждения вашей установки!
# --------------------------------

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить утилиту Alien (alien-pkg-convert)?"
# Install the Alien utility (alien-pkg-convert)?
echo -e "${MAGENTA}=> ${BOLD}Alien - это программа, конвертирующая файлы в форматы rpm, dpkg, stampede slp и slackware tgz. Если вы хотите использовать пакет из другого дистрибутива, чем тот, который вы установили в своей системе, вы можете использовать alien, чтобы преобразовать его в предпочтительный формат пакета и потом установить. (https://joeyh.name/code/alien/) ${NC}"
echo -e "${CYAN}:: ${NC}Имейте в виду, что если эти последние типы преобразований выполнены, сгенерированные пакеты могут иметь неверную информацию о зависимости...." 
echo -e "${CYAN}:: ${NC}Установка alien-pkg-convert проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/alien_package_converter.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/alien_package_converter/), собирается и устанавливается."
echo -e "${YELLOW}=> Важно: ${NC}Перед установкой (преобразованных) пакетов - ВЫПОЛНИТЕ резервное копирование пользовательских данных /пространства (разделов системы)-(возможность повреждения вашей системы)!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_alien  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_alien" =~ [^10] ]]
do
    :
done
if [[ $i_alien == 0 ]]; then
echo ""  
echo " Установка alien-pkg-convert пропущена "
elif [[ $i_alien == 1 ]]; then
  echo ""
  echo " Установка alien-pkg-convert "
##### alien-pkg-convert ###### 
# yay -S alien_package_converter --noconfirm  # Программа, которая конвертирует файлы между форматами rpm, dpkg, stampede slp и slackware tgz...
git clone https://aur.archlinux.org/alien_package_converter.git  
cd alien_package_converter
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf alien_package_converter
rm -Rf alien_package_converter   # удаляем директорию сборки
echo ""
echo " Сборка и установка alien-pkg-convert выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
# ------------------------------------
# Последнее обновление: 2020-08-06 00:03
# https://aur.archlinux.org/packages/alien_package_converter/
# https://aur.archlinux.org/alien_package_converter.git
# https://sourceforge.net/projects/alien-pkg-convert/
# https://github.com/mildred/alien
# ------------------------------------

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить утилиту (пакет) dpkg или (пакет) dpkg-git - из AUR ?"
# Install the dpkg utility (package) or dpkg-git (package) from AUR ?
echo -e "${MAGENTA}=> ${BOLD}Dpkg - это инструменты (команда) для обработки пакетов Debian в системе. Если у вас есть .deb-пакеты, именно dpkg позволяет устанавливать или анализировать их содержимое. (https://www.archlinux.org/packages/community/x86_64/dpkg/) ${NC}"
echo -e "${CYAN}:: ${NC}Имейте в виду, что иногда dpkg по той или иной причине не может установить пакет и возвращает ошибку; если пользователь даёт указание проигнорировать эту ошибку, будет выдано лишь предупреждение; для этого существуют различные опции..." 
echo -e "${MAGENTA}=> ${BOLD}Dpkg-git - это инструменты (команда) предоставляет функции для обработки архитектур Debian, подстановочных знаков и отображения триплетов GNU и обратно. Если у вас есть .deb-пакеты, именно dpkg позволяет устанавливать или анализировать их содержимое. (https://aur.archlinux.org/packages/dpkg-git/) ${NC}"
echo -e "${CYAN}:: ${NC}Установка Dpkg-git проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/dpkg-git.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/dpkg-git/), собирается и устанавливается."
echo -e "${YELLOW}=> Важно: ${NC}Перед установкой .deb пакетов - ВЫПОЛНИТЕ резервное копирование пользовательских данных /пространства (разделов системы)-(возможность повреждения вашей системы)!"
echo -e "${YELLOW}=> Важно: ${NC}Пакеты dpkg и dpkg-git - Конфликтуют (установить их одновременно НЕЛЬЗЯ)!"
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Установить Dpkg (community),     2 - Установить Dpkg-git - из AUR,     

    0 - НЕТ - Пропустить действие: " t_deb  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_deb" =~ [^120] ]]
do
    :
done
if [[ $t_deb == 0 ]]; then
echo ""  
echo " Установка утилит (пакетов) пропущена "
elif [[ $t_deb == 1 ]]; then
  echo ""
  echo " Установка пакета Dpkg (community) "
sudo pacman -S dpkg --noconfirm  # Инструменты диспетчера пакетов Debian (Последнее обновление: 2020-10-13)
echo " Установка пакета dpkg выполнена "
elif [[ $t_deb == 2 ]]; then
  echo ""
  echo " Установка Dpkg-git - из AUR "
##### dpkg-git ###### 
# yay -S dpkg-git --noconfirm  # Система управления пакетами Debian (Последнее обновление: 2019-01-30)
git clone https://aur.archlinux.org/dpkg-git.git  
cd dpkg-git  
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf dpkg-git
rm -Rf dpkg-git   # удаляем директорию сборки
echo ""
echo " Сборка и установка dpkg-git выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
# ------------------------------------
# Последнее обновление dpkg: 2020-10-13 16:31 UTC
# https://www.archlinux.org/packages/community/x86_64/dpkg/
# Последнее обновление dpkg-git: 2019-01-30 18:50
# https://aur.archlinux.org/packages/dpkg-git/
# https://aur.archlinux.org/dpkg-git.git
# https://debian-handbook.info/browse/ru-RU/stable/sect.manipulating-packages-with-dpkg.html
# ------------------------------------
## Команда по работе с dpkg
# Установите пакет debian с помощью dpkg:
# dpkg -i package.deb  # какой бы пакет не был  (sudo dpkg -i package_name.deb)
# Не рекомендуется (возможно, опасно)
# Этот метод пытается установить пакет, используя формат упаковки debian на Arch, который не рекомендуется из-за возможной опасности повреждения вашей установки!
# --------------------------------

+++++++++++++========================+++++++++++++++++

sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  #



sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 



sudo pacman -S engrampa --noconfirm  # Манипулятор архивов для MATE
sudo pacman -S galculator-gtk2 --noconfirm  # Научный калькулятор на основе GTK + (версия GTK2)
sudo pacman -S gnome-calculator --noconfirm  # Научный калькулятор GNOME
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 


sudo pacman -S gnome-icon-theme --noconfirm  # Тема значков GNOME
sudo pacman -S xcursor-simpleandsoft --noconfirm  # Простая и мягкая тема курсора X
sudo pacman -S xcursor-vanilla-dmz-aa --noconfirm  # Тема курсора Vanilla DMZ AA
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 

w3m - # Текстовый веб-браузер, а также пейджер
https://www.archlinux.org/packages/extra/x86_64/w3m/

https://zenway.ru/page/w3m
w3m является не только веб-браузером но и может служить приложением для просмотра локальных веб-страниц, HTML и текстовых документов (Pagers - функционально аналогичен more, less или most). У веб-браузера имеется множество дополнительных опций, однако они необязательны, достаточно (в качестве опции) задать адрес веб-сайта, например:

w3m zenway.ru

w3m имеет множество настроек, задать параметры можно правкой конфигурационных файлов (располагаются в каталоге ~/.w3m) и из диалога настройки. Для более удобного использования веб-браузера (запуска без ввода адреса веб-сайта) ему можно задать "Домашнюю страницу", для этого нужно в файле:

~/.bash_aliases
Добавить алиас (встроенную команду):

alias w3m='w3m адрес-сайта.ru'


fwbuilder - Community - Объектно-ориентированный графический интерфейс и набор компиляторов для различных платформ межсетевых экранов
https://www.archlinux.org/packages/community/x86_64/fwbuilder/
     
Модульная утилита для создания образов initramfs

sudo pacman -S mkinitcpio mkinitcpio-archiso mkinitcpio-busybox mkinitcpio-nfs-utils --noconfirm 

sudo pacman -S mkinitcpio --noconfirm # Модульная утилита для создания образов initramfs
sudo pacman -S mkinitcpio-archiso --noconfirm # Хуки и скрипты mkinitcpio для archiso
sudo pacman -S mkinitcpio-busybox --noconfirm # Базовые инструменты initramfs
sudo pacman -S mkinitcpio-nfs-utils --noconfirm # Инструменты ipconfig и nfsmount для поддержки корня NFS в mkinitcpio
sudo pacman -S  --noconfirm # 
sudo pacman -S  --noconfirm #
sudo pacman -S  --noconfirm # 


yay -S mkinitcpio-openswap --noconfirm  # mkinitcpio, чтобы открыть своп во время загрузки
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
########################################


clear
echo -e "${MAGENTA}
  <<< Установка дополнительного программного обеспечения (пакетов) в Archlinux >>> ${NC}"
# Installing additional software (packages) in Archlinux

echo ""
echo -e "${GREEN}==> ${BOLD}Установить дополнительные рекомендованные программы (пакеты)? ${NC}"
#echo -e "${BLUE}:: ${NC}Установить дополнительные рекомендованные программы (пакеты)?"
#echo 'Установить дополнительные рекомендованные программы (пакеты)?'
# Install additional recommended programs (packages)?
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - ()."
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo -e "${YELLOW}==> ${NC}Установка будет производится сразу всех утилит (пакетов) - (без выбора)" 
echo "" 
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " t_package  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_package" =~ [^10] ]]
do
    :
done 
if [[ $t_package == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $t_package == 1 ]]; then
  echo ""  
  echo " Установка дополнительного программного обеспечения (пакетов) "
#sudo pacman -S  --noconfirm  





echo ""   
echo " Установка утилит (пакетов) выполнена "
fi


##############################

sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #

##############################

yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #

#############################


refind-efi-bin  AUR # Вилка REFIt UEFI Boot Manager Рода Смита - предварительно скомпилированный двоичный файл - построенный с использованием библиотек GNU-EFIaur
https://aur.archlinux.org/packages/refind-efi-bin/

=========================
archiso  # Инструменты для создания Arch Linux live и установки образов iso -
##############################

Catfish — удобный инструмент поиска файлов для Linux и UNIX. Программа имеет простой интерфейс на Gtk+3 и может быть настроена из командной строки.(http://www.twotoasts.de/index.php/catfish/)
Catfish — простая программа для поиска файлов по имени и по содержимому.
Возможности
Поиск файлов по имени.
Автоматические поисковые подсказки.
Поиск файлов по содержимому.
Фильтрация результатов по дате, типу файлов и так далее.
Минималистичный и простой интерфейс.
Разработка
Язык программирования: Python 3
Библиотеки: GTK+
Код: OpenSource
Лицензия: GNU GPL v2

clear
echo -e "${MAGENTA}
  <<< Установка дополнительных утилит для восстановления данных с поврежденного жесткого диска (Если Вы обнаружите, что возникли ошибоки чтения диска, и начали сыпаться ошибки на консоль и в лог). >>> ${NC}"
echo ""
echo -e "${GREEN}==> ${NC}Установить GNU Ddrescue (ddrescue) и GUI интерфейс упрощающий использование ddrescue (ddrescue-gui) из AUR?"
# Install GNU ddrescue (ddrescue) and GUI interface to simplify the use of ddrescue (ddrescue-gui) from AUR?
echo -e "${MAGENTA}:: ${BOLD}GNU Ddrescue - это инструмент для восстановления данных. Он копирует данные из одного файла или блочного устройства (жесткого диска, компакт-диска и т.д.). В другой, пытаясь сначала спасти хорошие части в случае ошибок чтения. ${NC}"
echo " Основная операция ddrescue полностью автоматическая. То есть вам не нужно ждать ошибки, останавливать программу, перезапускать ее с новой позиции и т.д.... " 
echo " Ddrescue не записывает нули в выходные данные, когда обнаруживает поврежденные секторы во входных данных, и не обрезает выходной файл, если об этом не просят. Таким образом, каждый раз, когда вы запускаете его в одном и том же выходном файле, он пытается заполнить пробелы, не стирая уже восстановленные данные. "
echo -e "${YELLOW}==> Примечание: ${NC}GNU Ddrescue не является производной от dd и никак не связана с dd, за исключением того, что обе могут использоваться для копирования данных с одного устройства на другое. Разница в том, что ddrescue использует сложный алгоритм для копирования данных с неисправных дисков, что наносит им как можно меньше дополнительного ущерба."
echo -e "${CYAN}:: ${NC}Установка Ddrescue (ddrescue) проходит из 'Официальных репозиториев Arch Linux' - (Не AUR). Кроме Ddrescue GUI пакета (ddrescue-gui), его установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/ddrescue-gui/) - собирается и устанавливается. "
echo -e "${CYAN}==> Важно! ${NC}В сценарии (скрипте) представлены несколько вариантов установки: " 
echo " Установка Ddrescue (консольный вариант) без дополнений GUI, и второй вариант Ddrescue + GUI дополнения (пакет) (ddrescue-gui). "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Установить Ddrescue,     2 - Установить Ddrescue + GUI,     

    0 - НЕТ - Пропустить установку: " i_ddrescue  # sends right after the keypress; # отправляет сразу после нажатия клавиши    
    echo ''
    [[ "$i_ddrescue" =~ [^120] ]]
do
    :
done 
if [[ $i_ddrescue == 0 ]]; then 
echo ""   
echo " Установка пропущена "
elif [[ $i_ddrescue == 1 ]]; then
  echo ""    
  echo " Установка Ddrescue "
############ ddrescue ##########
sudo pacman -S ddrescue --noconfirm  # Инструмент восстановления данных GNU
echo ""
echo " Установка Ddrescue выполнена "
elif [[ $i_spotify == 2 ]]; then
  echo ""    
  echo " Установка Ddrescue + GUI "
############ ddrescue-gui ##########
# yay -S ddrescue-gui --noconfirm  # Запатентованный сервис потоковой передачи музыки
sudo pacman -S ddrescue --noconfirm  # Инструмент восстановления данных GNU
git clone https://aur.archlinux.org/ddrescue-gui.git  # Простой интерфейс с графическим интерфейсом, упрощающий использование ddrescue (инструмент для восстановления данных из командной строки)
cd ddrescue-gui
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ddrescue-gui 
rm -Rf ddrescue-gui
echo ""
echo " Установка Ddrescue + GUI выполнена "
echo ""
echo -e "${BLUE}:: ${BOLD}Посмотрим идентификацию накопителей (name, label, size, fstype, model) ... ${NC}"
date
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'     # одновременно отображает дату и часовой пояс
echo ""
sudo lsblk -f
sudo lsblk -o name, label, size, fstype, model 
sudo findmnt -D  # Если вы не сможете определить ваши диски
echo ""
fi
#-------------------------
# Одна из самых сильных сторон ddrescue заключается в том, что она не зависит от интерфейса и поэтому может использоваться для любого типа устройств, поддерживаемых вашим ядром (ATA, SATA, SCSI, старые приводы MFM, гибкие диски или даже карты флэш-памяти, такие как SD).
# https://aur.archlinux.org/packages/ddrescue-gui/
# https://launchpad.net/ddrescue-gu
# https://www.gnu.org/software/ddrescue/
# https://www.gnu.org/software/ddrescue/manual/ddrescue_manual.html
# https://www.gnu.org/graphics/agnuhead.html
# http://rus-linux.net/MyLDP/admin/ddrescue.html
# https://www.k-max.name/linux/ddrescue-hdd-vosstanovlenie-and-examples/
# http://sysadminblog.sagrer.ru/stati-i-gajdy/linux/21-primer-vosstanovleniya-dannykh-s-pomoshchyu-gnu-ddrescue.html
# https://ru.wikipedia.org/wiki/Ddrescue
#---------------------------














































































