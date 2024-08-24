#!/bin/bash
# loadkeys ru
# setfont cyr-sun16
# clear
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v2.4 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

X_ORG="russian"  # Installer default language (Язык установки по умолчанию)

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

########################################
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
Будьте внимательны! Процесс установки софта (пакетов) устанавливаемого из пользовательского репозитория будет осуществляться через - 'AUR'-'yay' (здесь выбор всегда остаётся за вами - ставить или нет).  
В данный момент сценарий (скрипта) находится в процессе доработки по прописанию устанавливаемого софта (пакетов), и небольшой корректировке (Воен. Внесение поправок в наводку орудий по результатам наблюдений с наблюдательных пунктов).

${BLUE}===> ******************************************************* ${NC}"
}
########################################

### Display banner (Дисплей баннер)
_warning_banner

sleep 9
#echo -e "${MAGENTA}==> ${BOLD}Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети. ${NC}"
#echo 'Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети.'
# If you have a wireless connection, launch nmtui and connect to the network. 

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

clear
echo -e "${CYAN}
  <<< Установка обновлений для системы Arch Linux >>> ${NC}"
# Installation of utilities (packages) for the Arch Linux system begins
echo ""
echo -e "${GREEN}==> ${NC}Обновим вашу систему (базу данных пакетов)?" 
#echo -e "${BLUE}:: ${NC}Обновим вашу систему (базу данных пакетов)"
#echo "Обновим вашу систему (базу данных пакетов)"
# Update your system (package database)
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo " 1 - Обновление базы данных пакетов плюс обновление самих пакетов (pacman -Syyu) "
echo -e "${RED}==> Важно! ${NC}Если при обновлении системы прилетели обновления ядра и установились, то Вам нужно желательно остановить исполнения сценария (скрипта), и выполнить команду по обновлению загрузчика 'grub' - sudo grub-mkconfig -o /boot/grub/grub.cfg , затем перезагрузить систему." 
echo -e "${YELLOW}==> Примечание: ${BOLD}Загружаем базу данных пакетов независимо от того, есть ли какие-либо изменения в версиях или нет. ${NC}"
# Loading the package database regardless of whether there are any changes in the versions or not.
echo " 2 - Просто обновить базы данных пакетов пакмэна (pacman -Syy) "
echo -e "${YELLOW}==> Примечание: ${BOLD}Возможно Вас попросят ввести пароль пользователя (user). ${NC}"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Обновить и установить (pacman -Syyu),     2 - Обновить базы данных пакетов (pacman -Syy)     

    0 - НЕТ - Пропустить обновление и установку: " upd_sys  # sends right after the keypress; # отправляет сразу после нажатия клавиши    
    echo ''
    [[ "$upd_sys" =~ [^120] ]]
do
    :
done 
if [[ $upd_sys == 0 ]]; then 
echo ""   
echo " Установка обновлений пропущена "
elif [[ $upd_sys == 1 ]]; then
  echo ""    
  echo " Установка обновлений (базы данных пакетов) "
  sudo pacman -Syyu --noconfirm  # Обновление баз плюс обновление пакетов (--noconfirm - не спрашивать каких-либо подтверждений)
# sudo pacman -Syyu  # Обновим вашу систему (базу данных пакетов)
echo ""
echo " Обновление и установка выполнено "
elif [[ $upd_sys == 2 ]]; then
  echo ""    
  echo " Обновим базы данных пакетов... "
###  sudo pacman -Sy
  sudo pacman -Syy  # обновление баз пакмэна (pacman)  
echo ""
echo " Обновление базы данных выполнено "
fi
sleep 01

############### Installing X.Org ###############
clear
echo -e "${MAGENTA}
  <<< Установка дополнительных Xorg (иксов)(X.Org) - по вашему выбору и желанию >>> ${NC}"
# Installing additional Xorg(icons)(X.Org ) - according to your choice and desire 
echo ""
echo -e "${GREEN}==> ${NC}Установить дополнительные Xorg (иксы)?"
#echo -e "${BLUE}:: ${NC}Установить дополнительные Xorg (иксы)?"
#echo 'Установить дополнительные Xorg (иксы)?'
# Should I install additional Xorgs?
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - Посмотрите перед установкой в скрипте!."  
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют функция пропуска установки уже установленных Xorg (иксов)! ${NC}"
echo -e "${CYAN}:: ${NC}Также Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты Xorg (иксы)!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_xorg  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_xorg" =~ [^10] ]]
do
    :
done
if [[ $i_xorg == 0 ]]; then
echo ""  
echo " Установка Установка дополнительных Xorg (иксов) пропущена "
elif [[ $i_xorg == 1 ]]; then
echo ""
echo " Установка дополнительных Xorg (иксов) "
################ X.Org ##################
sudo pacman -S --noconfirm --needed xf86-video-sisusb   # X.org SiS USB видеодрайвер ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xf86-video-sisusb/
#############
sudo pacman -S --noconfirm --needed xorg-bdftopcf  # Преобразование шрифта X из формата Bitmap Distribution в формат Portable Compiled ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-bdftopcf/
sudo pacman -S --noconfirm --needed xorg-font-util  # Утилиты шрифтов X.Org ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-font-util/
sudo pacman -S --noconfirm --needed xorg-mkfontscale  # Создать индекс файлов масштабируемых шрифтов для X ; https://gitlab.freedesktop.org/xorg/app/mkfontscale ; https://archlinux.org/packages/extra/x86_64/xorg-mkfontscale/
sudo pacman -S --noconfirm --needed xorg-sessreg  # Регистрация сеансов X в системных базах данных utmp/utmpx ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-sessreg/
sudo pacman -S --noconfirm --needed xorg-smproxy  # Позволяет приложениям X, не поддерживающим управление сеансом X11R6, участвовать в сеансе X11R6 ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-smproxy/
sudo pacman -S --noconfirm --needed xorg-x11perf  # Простой бенчмаркер производительности X-сервера ; https://archlinux.org/packages/extra/x86_64/xorg-x11perf/ ; https://xorg.freedesktop.org/
sudo pacman -S --noconfirm --needed xorg-xbacklight  # Приложение для управления подсветкой на базе RandR ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xbacklight/
sudo pacman -S --noconfirm --needed xorg-xcmsdb  # Утилита определения характеристик цвета устройства для системы управления цветом X ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xcmsdb/
sudo pacman -S --noconfirm --needed xorg-xcursorgen  # Создать файл курсора X из изображений PNG ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xcursorgen/
sudo pacman -S --noconfirm --needed xorg-xdpyinfo  # Утилита отображения информации для X ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xdpyinfo/
sudo pacman -S --noconfirm --needed xorg-xdriinfo  # Запросить информацию о конфигурации драйверов DRI ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xdriinfo/
sudo pacman -S --noconfirm --needed xorg-xev  # Распечатать содержимое X событий ; https://gitlab.freedesktop.org/xorg/app/xev ; https://archlinux.org/packages/extra/x86_64/xorg-xev/
sudo pacman -S --noconfirm --needed xorg-xgamma  # Изменить гамма-коррекцию монитора ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xgamma/
sudo pacman -S --noconfirm --needed xorg-xhost  # Программа контроля доступа к серверу для X ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xhost/
sudo pacman -S --noconfirm --needed xorg-xinput  # Небольшой инструмент командной строки для настройки устройств ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xinput/
sudo pacman -S --noconfirm --needed xorg-xkbevd  # Демон событий XKB ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xkbevd/
sudo pacman -S --noconfirm --needed xorg-xkbprint  # Создает PostScript-описание описания клавиатуры XKB ; https://gitlab.freedesktop.org/xorg/app/xkbprint ; https://archlinux.org/packages/extra/x86_64/xorg-xkbprint/
sudo pacman -S --noconfirm --needed xorg-xkbutils  # Демонстрационные версии утилит XKB ; https://gitlab.freedesktop.org/xorg/app/xkbutils ; https://archlinux.org/packages/extra/x86_64/xorg-xkbutils/
sudo pacman -S --noconfirm --needed xorg-xlsatoms  # Список интернированных атомов, определенных на сервере ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xlsatoms/
sudo pacman -S --noconfirm --needed xorg-xlsclients  # Список клиентских приложений, запущенных на дисплее ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xlsclients/
sudo pacman -S --noconfirm --needed xorg-xpr  # Распечатать дамп X-окна из xwd ; https://gitlab.freedesktop.org/xorg/app/xpr ; https://archlinux.org/packages/extra/x86_64/xorg-xpr/
sudo pacman -S --noconfirm --needed xorg-xrandr  # Примитивный интерфейс командной строки для расширения RandR ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xrandr/
sudo pacman -S --noconfirm --needed xorg-xrefresh  # Обновить весь или часть экрана X ; https://gitlab.freedesktop.org/xorg/app/xrefresh ; https://archlinux.org/packages/extra/x86_64/xorg-xrefresh/
sudo pacman -S --noconfirm --needed xorg-xsetroot  # Классическая утилита X для установки фона корневого окна в соответствии с заданным узором или цветом ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xsetroot/
sudo pacman -S --noconfirm --needed xorg-xvinfo  # Выводит на экран возможности всех видеоадаптеров, связанных с дисплеем, которые доступны через расширение X-Video ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xvinfo/
sudo pacman -S --noconfirm --needed xorg-xwd  # Утилита дампа образа X Window System ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xwd/
sudo pacman -S --noconfirm --needed xorg-xwininfo  # Утилита командной строки для печати информации об окнах на X-сервере ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xwininfo/
sudo pacman -S --noconfirm --needed xorg-xwud  # Утилита для снятия дампа с образа X Window System ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xwud/
echo ""
echo "  Установка дополнительных Xorg (иксов) выполнена "
echo " Время точное как на Спасской башне Московского Кремля! "
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'   # одновременно отображает дату и часовой пояс
fi
##########################################

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
echo -e "${YELLOW}==> ...${NC}"
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