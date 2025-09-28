#!/bin/bash
# loadkeys ru
# setfont cyr-sun16
# clear
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v2.4 LegasyBIOS - Version: 2024.07.31.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

UTILITIES_PACKAGES="russian"  # Installer default language (Язык установки по умолчанию)

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

clear
echo -e "${MAGENTA}
  <<< Установка дополнительных утилит (пакетов) - по вашему выбору и желанию >>> ${NC}"
# Installation of additional utilities (packages) - according to your choice and desire
echo ""
echo -e "${GREEN}==> ${NC}Установить дополнительные утилиты (пакеты)?"
#echo -e "${BLUE}:: ${NC}Установить дополнительные утилиты (пакеты)"
#echo 'Установить дополнительные утилиты (пакеты)'
# Install additional utilities (packages)
echo -e "${BLUE}:: ${NC}Добавим в систему несколько плюшек! "
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
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_packages  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_packages" =~ [^10] ]]
do
    :
done
if [[ $i_packages == 0 ]]; then
echo ""  
echo " Установка Установка дополнительных утилит (пакетов) пропущена "
elif [[ $i_packages == 1 ]]; then
echo ""
echo " Установка дополнительных утилит (пакетов) "
sudo pacman -S cloud-init  #  --noconfirm --needed # Инициализация облачного экземпляра ; https://cloud-init.io/ ; https://archlinux.org/packages/extra/any/cloud-init/
sudo pacman -S --noconfirm --needed open-vm-tools  # Open Virtual Machine Tools (open-vm-tools) — это реализация VMware Tools с открытым исходным кодом ; https://github.com/vmware/open-vm-tools https://archlinux.org/packages/extra/x86_64/open-vm-tools/
# sudo pacman -S --noconfirm --needed 
echo -e "${BLUE}:: ${NC}Добавим в систему iSNS сервер! "
############### iSNS сервер ##################
sudo pacman -S --noconfirm --needed open-iscsi  # Инструменты пользовательского пространства iSCSI ; https://www.open-iscsi.com/ ; https://archlinux.org/packages/extra/x86_64/open-iscsi/
sudo pacman -S --noconfirm --needed open-isns  # iSNS сервер и клиент для Linux ; https://github.com/gonzoleeman/open-isns ; https://archlinux.org/packages/extra/x86_64/open-isns/ 
echo -e "${BLUE}:: ${NC}Добавим в систему несколько плюшек GTK+ 2! "
################# GTK+ 2 #####################
sudo pacman -S --noconfirm --needed xsettingsd  # Предоставляет настройки для приложений X11 через спецификацию XSETTINGS ; https://github.com/derat/xsettingsd ; https://archlinux.org/packages/extra/x86_64/xsettingsd/ 
sudo pacman -S --noconfirm --needed xdg-desktop-portal-gtk  # Реализация бэкэнда для xdg-desktop-portal с использованием GTK ; https://github.com/flatpak/xdg-desktop-portal-gtk ; https://archlinux.org/packages/extra/x86_64/xdg-desktop-portal-gtk/
sudo pacman -S --noconfirm --needed gtk-engine-murrine  # Движок GTK2 сделает ваш рабочий стол похожим на «муррину» — итальянское слово, означающее художественные изделия из стекла, выполненные венецианскими стеклодувами ; http://cimitan.com/murrine/project/murrine ; https://archlinux.org/packages/extra/x86_64/gtk-engine-murrine/
sudo pacman -S --noconfirm --needed gtk-engines  # Тематические движки для GTK+ 2 ; http://live.gnome.org/GnomeArt ; https://archlinux.org/packages/extra-testing/x86_64/gtk-engines/
sudo pacman -S --noconfirm --needed gtk2-perl # Привязки Perl для GTK+ 2.x ; http://gtk2-perl.sourceforge.net/ ; https://archlinux.org/packages/extra-testing/x86_64/gtk2-perl/
####################################
echo -e "${BLUE}:: ${NC}Добавим в систему Qt5 дополнение! "
################ Qt5 дополнение #################
sudo pacman -S --noconfirm --needed qt5-graphicaleffects  # Графические эффекты для использования с Qt Quick 2 ; https://www.qt.io/ ; https://archlinux.org/packages/extra/x86_64/qt5-graphicaleffects/
sudo pacman -S --noconfirm --needed qt5-imageformats  # Плагины для дополнительных форматов изображений: TIFF, MNG, TGA, WBMP ; https://www.qt.io/ ; https://archlinux.org/packages/extra/x86_64/qt5-imageformats/
sudo pacman -S --noconfirm --needed qt5-quickcontrols2  # Элементы управления пользовательского интерфейса нового поколения на основе Qt Quick ; https://www.qt.io/; https://archlinux.org/packages/extra/x86_64/qt5-quickcontrols2/
sudo pacman -S --noconfirm --needed qt5ct  # Утилита настройки Qt 5 ; https://qt5ct.sourceforge.io/ ; https://archlinux.org/packages/extra/x86_64/qt5ct/ ; Эта программа позволяет пользователям настраивать параметры Qt5 (тему, шрифт, значки и т. д.) под DE/WM без интеграции Qt.
sudo pacman -S --noconfirm --needed qt5-translations  # Кросс-платформенное приложение и UI-фреймворк (переводы) ; Кроссплатформенное приложение и пользовательский интерфейс (Переводы) ;
sudo pacman -S --noconfirm --needed qt6ct  # Утилита настройки Qt 6 ; https://github.com/trialuser02/qt6ct ; https://archlinux.org/packages/extra/x86_64/qt6ct/ ; Эта программа позволяет пользователям настраивать параметры Qt6 (тему, шрифт, значки и т. д.) под DE/WM без интеграции Qt.
############################
# sudo pacman -S --noconfirm --needed
# sudo pacman -S --noconfirm --needed
# sudo pacman -S --noconfirm --needed
# yay -S autofs --noconfirm  # Средство автомонтирования на основе ядра для Linux ; Раньше присутствовал в community
echo ""
echo "  Установка дополнительных утилит (пакетов) выполнена "
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
#################
# xsettingsd — это демон, реализующий спецификацию XSETTINGS .
# Пример настройки рендеринга шрифтов:
# ~/.config/xsettingsd/xsettingsd.conf
# Xft/Hinting 1
# Xft/HintStyle "hintslight"
# Xft/Antialias 1
# Xft/RGBA "rgb"
################################
# ~/.xsettingsd
# This config wiln be executed by xsettingsd
# Make sure you have instalned it
# Add don't forget to add it to your startup

# Xft/Hinting 1
# Xft/RGBA "rgb"
# Xft/HintStyle "hintslight"
# Xft/Antialias 1

# Net/IconThemeName "ln-ico"
# Net/ThemeName "ln"
####################################