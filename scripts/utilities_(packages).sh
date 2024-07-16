#!/bin/bash
# loadkeys ru
# setfont cyr-sun16
# clear
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

MULTIMEDIA_PROG_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
sudo pacman -S --noconfirm --needed cloud-init  # Инициализация облачного экземпляра ; https://cloud-init.io/ ; https://archlinux.org/packages/extra/any/cloud-init/
sudo pacman -S --noconfirm --needed lsscsi  # Инструмент, который выводит список устройств, подключенных через SCSI, и его транспорты ; http://sg.danny.cz/scsi/lsscsi.html ; https://archlinux.org/packages/extra/x86_64/lsscsi/
sudo pacman -S --noconfirm --needed autorandr  # Автоматическое определение подключенного оборудования дисплея и загрузка соответствующих настроек X11 с помощью xrandr ; https://github.com/phillipberndt/autorandr ; https://archlinux.org/packages/extra/any/autorandr/
sudo pacman -S --noconfirm --needed bcachefs-tools  # Утилиты файловой системы BCacheF ; https://bcachefs.org/ ; https://archlinux.org/packages/extra/x86_64/bcachefs-tools/
sudo pacman -S --noconfirm --needed bolt  # Диспетчер устройств Thunderbolt 3 ; https://gitlab.freedesktop.org/bolt/bolt ; https://archlinux.org/packages/extra/x86_64/bolt/
sudo pacman -S --noconfirm --needed botan  # Криптобиблиотека, написанная на C++ ; https://botan.randombit.net/ ; https://archlinux.org/packages/extra/x86_64/botan/
sudo pacman -S --noconfirm --needed brltty  # Драйвер дисплея Брайля для Linux/Unix ; https://brltty.app/ ; https://archlinux.org/packages/extra/x86_64/brltty/
sudo pacman -S --noconfirm --needed chrpath  # Измените или удалите rpath или runpath в файлах ELF ; https://codeberg.org/pere/chrpath ; https://archlinux.org/packages/extra/x86_64/chrpath/
sudo pacman -S --noconfirm --needed doxygen  # Система документации для C++, C, Java, IDL и PHP ; http://www.doxygen.nl/ ; https://archlinux.org/packages/extra/x86_64/doxygen/
sudo pacman -S --noconfirm --needed edk2-shell  # Оболочка UEFI EDK2 ; Современная, многофункциональная, кроссплатформенная среда разработки прошивки для спецификаций UEFI и PI от www.uefi.org ; https://github.com/tianocore/edk2 ; https://archlinux.org/packages/extra/any/edk2-shell/
sudo pacman -S --noconfirm --needed exfatprogs  # Утилиты пользовательского пространства файловой системы exFAT для драйвера exfat ядра Linux ; https://github.com/exfatprogs/exfatprogs ; https://archlinux.org/packages/extra/x86_64/exfatprogs/
sudo pacman -S --noconfirm --needed expac  # утилита извлечения данных alpm (база данных pacman) ; https://github.com/falconindy/expac ; https://archlinux.org/packages/extra/x86_64/expac/
sudo pacman -S --noconfirm --needed fatresize  # Утилита для изменения размера файловых систем FAT с помощью libparted ; https://sourceforge.net/projects/fatresize/ ; https://archlinux.org/packages/extra/x86_64/fatresize/
sudo pacman -S --noconfirm --needed geoip  # Библиотека и утилиты для преобразования IP-адресов стран без DNS на языке C ; https://www.maxmind.com/app/c ; https://archlinux.org/packages/extra/x86_64/geoip/
sudo pacman -S --noconfirm --needed geoip-database  # База данных стран GeoIP (на основе данных GeoLite2, созданных MaxMind) ; https://mailfud.org/geoip-legacy/ ; https://archlinux.org/packages/extra/any/geoip-database/
sudo pacman -S --noconfirm --needed hyperv  # Инструменты Hyper-V ; https://www.kernel.org/ ; https://archlinux.org/packages/extra/x86_64/hyperv/
sudo pacman -S --noconfirm --needed kauth  # Абстракция к системной политике и функциям аутентификации ; https://community.kde.org/Frameworks ; https://archlinux.org/packages/extra/x86_64/kauth/
sudo pacman -S --noconfirm --needed kparts  # Система плагинов, ориентированная на документы ; https://community.kde.org/Frameworks ; https://archlinux.org/packages/extra/x86_64/kparts/
sudo pacman -S --noconfirm --needed kpmcore  # Библиотека для управления разделами ; https://apps.kde.org/partitionmanager/ ; https://archlinux.org/packages/extra/x86_64/kpmcore/
sudo pacman -S --noconfirm --needed ldns  # Библиотека Fast DNS с поддержкой последних RFC ; https://www.nlnetlabs.nl/projects/ldns/
sudo pacman -S --noconfirm --needed ncmpcpp  # Почти точный клон ncmpc с некоторыми новыми функциями ; https://ncmpcpp.rybczak.net/ ; https://archlinux.org/packages/extra/x86_64/ncmpcpp/
sudo pacman -S --noconfirm --needed newsboat  # RSS/Atom-ридер для текстовых терминалов ; https://newsboat.org/ ; https://archlinux.org/packages/extra/x86_64/newsboat/
sudo pacman -S --noconfirm --needed nvme-cli  # Инструментарий пользовательского пространства NVM-Express для Linux ; https://github.com/linux-nvme/nvme-cli ; https://archlinux.org/packages/extra/x86_64/nvme-cli/
sudo pacman -S --noconfirm --needed scrot  # Простая утилита для создания скриншотов в командной строке для X ; https://github.com/resurrecting-open-source-projects/scrot ; https://archlinux.org/packages/extra/x86_64/scrot/  
sudo pacman -S --noconfirm --needed slop  # Утилита для запроса у пользователя выбора и вывода региона на стандартный вывод ; https://github.com/naelstrof/slop ; https://archlinux.org/packages/extra/x86_64/slop/
sudo pacman -S --noconfirm --needed spice-vdagent  # Специи для гостей Linux ; https://www.spice-space.org/ ; https://archlinux.org/packages/extra/x86_64/spice-vdagent/
sudo pacman -S --noconfirm --needed stfl  # Библиотека, реализующая набор виджетов на основе curses для текстовых терминалов ; http://clifford.at/stfl/ ; https://archlinux.org/packages/extra/x86_64/stfl/
### STFL — это библиотека, реализующая  набор виджетов на основе curses  для текстовых терминалов. API STFL можно использовать из  C, SPL, Python, Perl и Ruby . Поскольку API состоит всего из 14 простых вызовов функций и уже существуют общие привязки SWIG, очень легко портировать STFL на дополнительные языки сценариев.
sudo pacman -S --noconfirm --needed sysfsutils  # Системные утилиты на основе Sysfs ; http://linux-diag.sourceforge.net/Sysfsutils.html ; https://archlinux.org/packages/extra/x86_64/sysfsutils/
sudo pacman -S --noconfirm --needed tldr  # Клиент командной строки для tldr, коллекции упрощенных страниц руководства ; Клиент командной строки Python для страниц TLDR ; https://github.com/tldr-pages/tldr-python-client ; https://archlinux.org/packages/extra/any/tldr/
sudo pacman -S --noconfirm --needed udftools  # Инструменты Linux для файловых систем UDF и приводов DVD/CD-R(W) ; https://github.com/pali/udftools ; https://archlinux.org/packages/extra/x86_64/udftools/
sudo pacman -S --noconfirm --needed ueberzug  # Утилита командной строки, которая позволяет отображать изображения в сочетании с X11 ; https://github.com/ueber-devel/ueberzug https://archlinux.org/packages/extra/x86_64/ueberzug/ 
sudo pacman -S --noconfirm --needed unclutter  # Небольшая программа для скрытия курсора мыши ; https://github.com/Airblader/unclutter-xfixes ; https://archlinux.org/packages/extra/x86_64/unclutter/
sudo pacman -S --noconfirm --needed uriparser  # uriparser — это библиотека анализа URI, строго соответствующая RFC 3986. uriparser — кроссплатформенная, быстрая, поддерживает Unicode ; https://github.com/uriparser/uriparser ; https://archlinux.org/packages/extra/x86_64/uriparser/
sudo pacman -S --noconfirm --needed wmctrl  # Управляйте своим оконным менеджером, совместимым с EWMH, из командной строки ; http://tripie.sweb.cz/utils/wmctrl/ ; https://archlinux.org/packages/extra/x86_64/wmctrl/
sudo pacman -S --noconfirm --needed xdotool  # Инструмент автоматизации командной строки X11 ; https://www.semicomplete.com/projects/xdotool/ ; https://archlinux.org/packages/extra/x86_64/xdotool/
sudo pacman -S --noconfirm --needed rofi  # Переключатель окон, средство запуска приложений и замена dmenu ; Rofi , как и dmenu, предоставит пользователю текстовый список опций, где можно выбрать одну или несколько. Это может быть запуск приложения, выбор окна или опции, предоставляемые внешним скриптом ; https://github.com/DaveDavenport/rofi ; https://archlinux.org/packages/extra/x86_64/rofi/
sudo pacman -S --noconfirm --needed eza  # Современная замена ls (форк сообщества exa); https://github.com/eza-community/eza ; https://archlinux.org/packages/extra/x86_64/eza/ ; https://github.com/eza-community/eza/blob/main/INSTALL.md
sudo pacman -S --noconfirm --needed unixodbc  # ODBC - это открытая спецификация для предоставления разработчикам приложений предсказуемого API для доступа к источникам данных ; https://archlinux.org/packages/core/x86_64/unixodbc/ ; http://www.unixodbc.org/
sudo pacman -S --noconfirm --needed expat  # Библиотека парсера XML ; https://archlinux.org/packages/core/x86_64/expat/ ; https://libexpat.github.io/
sudo pacman -S --noconfirm --needed open-vm-tools  # Open Virtual Machine Tools (open-vm-tools) — это реализация VMware Tools с открытым исходным кодом ; https://github.com/vmware/open-vm-tools https://archlinux.org/packages/extra/x86_64/open-vm-tools/
# sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed yad  # Форк zenity — отображение графических диалогов из скриптов оболочки или командной строки ; https://github.com/v1cont/yad ; https://archlinux.org/packages/extra/x86_64/yad/
echo -e "${BLUE}:: ${NC}Добавим в систему iSNS сервер! "
############### iSNS сервер ##################
sudo pacman -S --noconfirm --needed open-iscsi  # инструменты пользовательского пространства iSCSI ; https://www.open-iscsi.com/ ; https://archlinux.org/packages/extra/x86_64/open-iscsi/
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
sudo pacman -S --noconfirm --needed qt6ct  # Утилита настройки Qt 6 ; https://github.com/trialuser02/qt6ct ; https://archlinux.org/packages/extra/x86_64/qt6ct/ ; Эта программа позволяет пользователям настраивать параметры Qt6 (тему, шрифт, значки и т. д.) под DE/WM без интеграции Qt.
############################
# sudo pacman -S --noconfirm --needed
# sudo pacman -S --noconfirm --needed
# sudo pacman -S --noconfirm --needed
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
echo -e "${BLUE}:: ${NC}Если хотите установить шрифты, из AUR - через (yay), тогда после перезагрузки и входа в систему выполните команду:"
echo -e "${YELLOW}==> ${CYAN}git clone https://github.com/MarcMilany/archmy_2020.git ${NC}"
echo -e "${CYAN}:: ${NC}Цель скрипта (font_aur) - это установка дополнительных шрифтов (пакетов), находящихся в AUR и которых нет в стандарных репозиториях Arch'a https://archlinux.org/packages/."
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