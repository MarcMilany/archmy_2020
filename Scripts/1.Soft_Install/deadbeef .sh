#!/usr/bin/env bash
# Install script debtap
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget 
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v2.4 LegasyBIOS - Version: 2024.07.31.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

DeaDBeeF="russian"  # Installer default language (Язык установки по умолчанию)

script_path=$(readlink -f ${0%/*})

umask 0022 # Определение окончательных прав доступа
# Для суперпользователя (root) umask по умолчанию равна 0022

##################################################################

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
###############

echo ""
echo -e "${BLUE}:: ${NC}Установка и настройка начата в $(date +%T)" 
#echo "Установка и настройка начата в $(date +%T)"
# Installation and configuration started in $(date +%T)
echo ""
echo -e "${GREEN}=> ${NC}Для проверки интернета можно пропинговать какой-либо сервис"
echo -e "${MAGENTA}==> ${BOLD}Если у Вас беспроводное соединение, запустите nmtui (Network Manager Text User Interface) и подключитесь к сети. ${NC}"
#echo 'Для проверки интернета можно пропинговать какой-либо сервис'
# To check the Internet, you can ping a service
ping -c2 archlinux.org  # Утилита ping - это очень простой инструмент для диагностики сети
#ping google.com -W 2 -c 1

echo -e "${CYAN}==> ${NC}Если пинг идёт едем дальше ... :)"
#echo 'Если пинг идёт едем дальше ... :)'
# If the ping goes we go further ... :)
sleep 03

echo ""    
echo " Обновим базы данных пакетов... "
###  sudo pacman -Sy
sudo pacman -Syy  # обновление баз пакмэна (pacman) 
echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git  # Сетевая утилита для извлечения файлов из Интернета, Быстрая распределенная система контроля версий, Инструмент командной строки и библиотека для передачи данных с помощью URL-адресов.

echo""
echo " Установка DeaDBeeF (как и 0xDEADBEEF ) — это модульный кроссплатформенный аудиоплеер, работающий в дистрибутивах GNU/Linux, macOS, Windows, *BSD, OpenSolaris и других UNIX-подобных системах...) "
echo " DeaDBeeF воспроизводит множество аудиоформатов, конвертирует их между собой, позволяет настраивать пользовательский интерфейс практически любым удобным для вас способом и использовать множество дополнительных плагинов , которые могут еще больше его расширить. "
############ Зависимости ################
# sudo pacman -R 
# sudo pacman -R  --noconfirm 
###  --noconfirm   не спрашивать каких-либо подтверждений
### Недостающие зависимости ####
# sudo pacman -S --noconfirm --needed curl  # Инструмент командной строки и библиотека для передачи данных с помощью URL-адресов. https://archlinux.org/packages/core/x86_64/curl/
# sudo pacman -S --noconfirm --needed git  # Быстрая распределенная система контроля версий. https://archlinux.org/packages/extra/x86_64/git/
sudo pacman -S --noconfirm --needed alsa-lib  # Альтернативная реализация поддержки звука в Linux. https://archlinux.org/packages/extra/x86_64/alsa-lib/
sudo pacman -S --noconfirm --needed gtk3  # Мультиплатформенный набор инструментов графического интерфейса на основе GObject. https://archlinux.org/packages/extra/x86_64/gtk3/
sudo pacman -S --noconfirm --needed jansson  # Библиотека C для кодирования, декодирования и управления данными JSON. https://archlinux.org/packages/core/x86_64/jansson/
sudo pacman -S --noconfirm --needed libdispatch  # Комплексная поддержка одновременного выполнения кода на многоядерном оборудовании. https://archlinux.org/packages/extra/x86_64/libdispatch/
sudo pacman -S --noconfirm --needed clang  # Интерфейс семейства языков C для LLVM. (Помечено как устаревшее 07.03.2024) https://archlinux.org/packages/extra/x86_64/clang/
sudo pacman -S --noconfirm --needed faad2  # Бесплатный расширенный аудиодекодер (AAC). https://archlinux.org/packages/extra/x86_64/faad2/
sudo pacman -S --noconfirm --needed ffmpeg  # Комплексное решение для записи, преобразования и потоковой передачи аудио и видео. https://archlinux.org/packages/extra/x86_64/ffmpeg/
sudo pacman -S --noconfirm --needed flac  # Бесплатный аудиокодек без потерь. https://archlinux.org/packages/extra/x86_64/flac/
sudo pacman -S --noconfirm --needed imlib2  # Библиотека, которая выполняет загрузку и сохранение файлов изображений, а также рендеринг, манипулирование и поддержку произвольных многоугольников. https://archlinux.org/packages/extra/x86_64/imlib2/
sudo pacman -S --noconfirm --needed intltool  # Коллекция инструментов интернационализации. https://archlinux.org/packages/extra/any/intltool/
sudo pacman -S --noconfirm --needed libcddb  # Библиотека, реализующая различные протоколы (CDDBP, HTTP, SMTP) для доступа к данным на сервере CDDB (https://gnudb.org). https://archlinux.org/packages/extra/x86_64/libcddb/
sudo pacman -S --noconfirm --needed libcdio  # Библиотека ввода и управления компакт-дисками GNU. https://archlinux.org/packages/extra/x86_64/libcdio/
sudo pacman -S --noconfirm --needed libmad  # Высококачественный аудиодекодер MPEG. https://archlinux.org/packages/extra/x86_64/libmad/
sudo pacman -S --noconfirm --needed libpipewire  # Маршрутизатор и процессор аудио/видео с малой задержкой — клиентская библиотека. https://archlinux.org/packages/extra/x86_64/libpipewire/ https://archlinux.org/packages/extra-testing/x86_64/libpipewire/
sudo pacman -S --noconfirm --needed libpulse  # Многофункциональный универсальный звуковой сервер (клиентская библиотека). https://archlinux.org/packages/extra/x86_64/libpulse/
sudo pacman -S --noconfirm --needed libsamplerate # Библиотека преобразования частоты дискретизации звука. https://archlinux.org/packages/extra/x86_64/libsamplerate/
sudo pacman -S --noconfirm --needed libsndfile  # Библиотека AC для чтения и записи файлов, содержащих сэмплы аудиоданных. https://archlinux.org/packages/extra/x86_64/libsndfile/
sudo pacman -S --noconfirm --needed libvorbis  # Референсная реализация аудиоформата Ogg Vorbis. https://archlinux.org/packages/extra/x86_64/libvorbis/
sudo pacman -S --noconfirm --needed libx11  # Клиентская библиотека X11. https://archlinux.org/packages/extra/x86_64/libx11/
# sudo pacman -S --noconfirm --needed 
# sudo pacman -S --noconfirm --needed
# sudo pacman -S --noconfirm --needed   # 
################ AUR ##############
# yay -S deadbeef --noconfirm  # Интерфейс командной строки Git для GitHub. https://github.com/DeaDBeeF-Player/deadbeef
echo""
echo " Установка DeaDBeeF (Модульный аудиоплеер GTK для GNU/Linux) "
git clone https://aur.archlinux.org/deadbeef.git    # (только для чтения, нажмите, чтобы скопировать) https://aur.archlinux.org/packages/git-hub
cd deadbeef
#makepkg -fsri  
makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)  
rm -Rf deadbeef  # удаляем директорию сборки
# rm -rf deadbeef 
echo " Установка DeaDBeeF завершена "
sleep 01

clear
echo -e "${GREEN}
  <<< Поздравляем! Установка завершена. Перезагрузите систему. >>>
${NC}"
echo -e "${BLUE}:: ${BOLD}Посмотрим дату и время ... ${NC}"
date
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'    # одновременно отображает дату и часовой пояс
echo -e "${BLUE}:: ${BOLD}Отобразить время работы системы ... ${NC}"
uptime
echo -e "${MAGENTA}==> ${BOLD}После перезагрузки и входа в систему проверьте ваши персональные настройки. ${NC}"
echo -e "${CYAN}:: ${NC}Скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска служб."
echo -e "${GREEN}
  <<< Желаю Вам удачи во всех начинаниях, верных и точных решений! >>> ${NC}"
echo ""
echo -e "${RED}### ${BLUE}########################################################### ${RED}### ${NC}"
echo -e "${RED}==> ${BOLD}Выходим из установленной системы ${NC}"
echo -e "${BLUE}:: ${BOLD}Теперь вам надо ввести (exit) reboot, чтобы перезагрузиться ${NC}"
sleep 03
exit
exit

### end of script
# -------------------------------------------------
# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps
# ---------------------------------------------------
# URL-адрес клона Git:	https://aur.archlinux.org/deadbeef.git (только чтение, нажмите, чтобы скопировать)
# https://aur.archlinux.org/packages/deadbeef?all_deps=1#pkgdeps
# База пакета: deadbeef
# URL восходящего направления:	https://deadbeef.sourceforge.io/
# Лицензии:	GPL2, zlib, LGPL2.1
# Последний упаковщик: FabioLolix
# Голоса:	84
# Популярность:	2.95
# Первый отправленный:	2021-05-08 09:08 (UTC)
# Последнее обновление:	2023-11-12 09:06 (UTC)
# https://github.com/DeaDBeeF-Player/deadbeef

# <<< Делайте выводы сами! >>>
#
