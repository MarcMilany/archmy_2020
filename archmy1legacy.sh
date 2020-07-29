#!/bin/bash
#
apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/arch_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
#
# ============================================================================
# Автоматическое обнаружение ошибок
# Эта команда остановит выполнение сценария после сбоя команды и будет отправлен код ошибки
set -e
# Если этот параметр '-e' задан, оболочка завершает работу, когда простая команда в списке команд завершается ненулевой (FALSE). Это не делается в ситуациях, когда код выхода уже проверен (if, while, until,||, &&)
# Встроенная команда set:
# https://www.sites.google.com/site/bashhackers/commands/set
# ============================================================================
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 
#echo ""
#echo "##################################################################"
#echo "##### <<<Arch Linux Fast Install LegasyBIOS (arch2020)>>>    #####"
#echo "#### Скрипты 'arch_2020' созданы на основе сценария (скрипта) ####"
#echo "#### 'ordanax/arch2018'. При выполнении скрипта Вы получаете  ####"
#echo "#### возможность быстрой установки ArchLinux с вашими личными ####"
#echo "#### настройками (при условии, что Вы его изменили под себя,  ####"
#echo "####  в противном случае с моими настройками).               ####"       
#echo "####  В скрипте прописана установка grub для LegasyBIOS, и   ####" 
#echo "####  с DE - рабочего стола Xfce.                            ####"  
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
#echo "#################################################################"
#echo ""
#sleep 4
#clear
#echo ""
# ============================================================================

#_arch_fast_install_banner
set > old_vars.log

APPNAME="arch_fast_install"
VERSION="v1.6 LegasyBIOS"
BRANCH="master"
AUTHOR="ordanax"
LICENSE="GNU General Public License 3.0"

### Description (Описание)
_arch_fast_install_banner() {
    echo -e "${BLUE}
┌─┐┬─┐┌─┐┬ ┬  ┬  ┬ ┬ ┬┬ ┬┌┌┐  ┬─┐┌─┐┌─┐┌┬┐  ┬ ┬ ┬┌─┐┌┬┐┌─┐┬  ┬  
├─┤├┬┘│  ├─┤  │  │ │\││ │ │   │─ ├─┤└─┐ │   │ │\│└─┐ │ ├─┤│  │  
┴ ┴┴└─└─┘┴ ┴  └─┘┴ ┴ ┴└─┘└└┘  ┴  ┴ ┴└─┘ ┴   ┴ ┴ ┴└─┘ ┴ ┴ ┴┴─┘┴─┘${RED}
 Arch Linux Install ${VERSION} - ${LICENSE} 
${NC}
Arch Linux - это независимо разработанный универсальный дистрибутив GNU / Linux для архитектуры x86-64, который стремится предоставить последние стабильные версии большинства программ, следуя модели непрерывного выпуска.
 Arch Linux определяет простоту как без лишних дополнений или модификаций. Arch включает в себя многие новые функции, доступные пользователям GNU / Linux, включая systemd init system, современные файловые системы , LVM2, программный RAID, поддержку udev и initcpio (с mkinitcpio ),а также последние доступные ядра.  
Arch Linux - это дистрибутив общего назначения. После установки предоставляется только среда командной строки: вместо того, чтобы вырывать ненужные и нежелательные пакеты, пользователю предлагается возможность создать собственную систему, выбирая среди тысяч высококачественных пакетов, представленных в официальных репозиториях для x86-64 архитектуры.
Этот скрипт не задумывался, как обычный установочный с большим выбором DE, разметкой диска и т.д.
 И он не предназначен для новичков. Он предназначен для тех, кто ставил ArchLinux руками и понимает, что и для чего нужна каждая команда.  
Его цель - это моментальное разворачивание системы со всеми конфигами. Смысл в том, что все изменения Вы делаете предварительно в самом скрипте и получаете возможность быстрой установки ArchLinux с вашими личными настройками (при условии, что Вы его изменили под себя, в противном случае с моими настройками).${RED}

 ***************************** ВНИМАНИЕ! ***************************** 
${NC} 
Автор не несёт ответственности за любое нанесение вреда при использовании скрипта. 
Вы используйте его на свой страх и риск, или изменяйте под свои личные нужды."
}

# ============================================================================

### Help and usage (--help or -h) (Справка)
_help() {
    echo -e "${BLUE}
Installation guide - Arch Wiki

    ${BOLD}Options${NC}
        -h, --help          show this help message
        -l, --lang          set installer language
        -k, --keyboard      set keyboard layout

    ${BOLD}Language${NC}
        -l, --lang          english
                            russian

    ${BOLD}Keyboard${NC}
        -k, --keyboard      keyboard layout
                            (run loadkeys on start)
                            (e.q., --keyboard fr)

${BOLD}For more information, see the wiki: \
${GREY}<https://wiki.archlinux.org/index.php/Installation_guide>${NC}"
}

### Installer default language (Язык установки по умолчанию)
#ARCHMY1_LANG="russian"

### SHARED VARIABLES AND FUNCTIONS (ОБЩИЕ ПЕРЕМЕННЫЕ И ФУНКЦИИ)
### Shell color codes (Цветовые коды оболочки)
RED="\e[1;31m"; GREEN="\e[1;32m"; YELLOW="\e[1;33m"; GREY="\e[3;93m"
BLUE="\e[1;34m"; CYAN="\e[1;36m"; BOLD="\e[1;37m"; MAGENTA="\e[1;35m"; NC="\e[0m"

# Вот список цветов, которые можно применять для подсветки синтаксиса в bash:
# BLACK='\e[0;30m' GREEN='\e[0;32m' BLUE='\e[0;34m'    CYAN='\e[0;36m'
# RED='\e[0;31m'   BROWN='\e[0;33m' MAGENTA='\e[0;35m' GRAY='\e[0;37m'
# DEF='\e[0;39m'   'LRED='\e[1;31m    YELLOW='\e[1;33m' LMAGENTA='\e[1;35m' WHITE='\e[1;37m'
# DGRAY='\e[1;30m'  LGREEN='\e[1;32m' LBLUE='\e[1;34m'  LCYAN='\e[1;36m'    NC='\e[0m' # No Color
# Индивидуальные настройки подсветки синтаксиса для каждого пользователя можно настраивать в конфигурационном файле /home/$USER/.bashrc

#-------------------------------------------------------------------------------------

# Checking personal setting (Проверяйте ваши персональные настройки)
### Display user entries (Отображение пользовательских записей ) 
#USER_ENTRIES=(USER_LANG TIMEZONE HOST_NAME USER_NAME LINUX_FW KERNEL \
#DESKTOP DISPLAY_MAN GREETER AUR_HELPER POWER GPU_DRIVER HARD_VIDEO)

### Automatic error detection (Автоматическое обнаружение ошибок)
_set() {
    set [--abefhkmnptuvxBCHP] [-o option] [arg ...]
}

_set() {
    set -e "\n${RED}Error: ${YELLOW}${*}${NC}"
    _note "${MSG_ERROR}"
    sleep 1; $$
}
  
### Display some notes (Дисплей некоторые заметки)
_note() {
    echo -e "${RED}\nNote: ${BLUE}${1}${NC}"
}

### Display install steps (Отображение шагов установки)
_info() {
    echo -e "${YELLOW}\n==> ${CYAN}${1}...${NC}"; sleep 1
}

### Ask some information (Спросите немного информации)
_prompt() {
    LENTH=${*}; COUNT=${#LENTH}
    echo -ne "\n${YELLOW}==> ${GREEN}${1} ${RED}${2}"
    echo -ne "${YELLOW}\n==> "
    for (( CHAR=1; CHAR<=COUNT; CHAR++ )); do echo -ne "-"; done
    echo -ne "\n==> ${NC}"
}

### Ask confirmation (Yes/No) (Запросите подтверждение (да / нет))
_confirm() {
    unset CONFIRM; COUNT=$(( ${#1} + 6 ))
    until [[ ${CONFIRM} =~ ^(y|n|Y|N|yes|no|Yes|No|YES|NO)$ ]]; do
        echo -ne "${YELLOW}\n==> ${GREEN}${1} ${RED}[y/n]${YELLOW}\n==> "
        for (( CHAR=1; CHAR<=COUNT; CHAR++ )); do echo -ne "-"; done
        echo -ne "\n==> ${NC}"
        read -r CONFIRM
    done
}

### Select an option (Выбрать параметр)
_select() {
    COUNT=0
    echo -ne "${YELLOW}\n==> "
    for ENTRY in "${@}"; do
        echo -ne "${RED}[$(( ++COUNT ))] ${GREEN}${ENTRY} ${NC}"
    done
    LENTH=${*}; NUMBER=$(( ${#*} * 4 ))
    COUNT=$(( ${#LENTH} + NUMBER + 1 ))
    echo -ne "${YELLOW}\n==> "
    for (( CHAR=1; CHAR<=COUNT; CHAR++ )); do echo -ne "-"; done
    echo -ne "\n==> ${NC}"
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

### Check command status and exit on error (Проверьте состояние команды и завершите работу с ошибкой)
_check() {
    "${@}"
    local STATUS=$?
    if [[ ${STATUS} -ne 0 ]]; then _error "${@}"; fi
    return "${STATUS}"
}

### Display error, cleanup and kill (Ошибка отображения, очистка и убийство)
_error() {
    echo -e "\n${RED}Error: ${YELLOW}${*}${NC}"
    _note "${MSG_ERROR}"
    sleep 1; _cleanup; _exit_msg; kill -9 $$
}

### Cleanup on keyboard interrupt (Очистка при прерывании работы клавиатуры)
trap '_error ${MSG_KEYBOARD}' 1 2 3 6
#trap "set -$-" RETURN; set +o nounset
# Или
#trap "set -${-//[is]}" RETURN; set +o nounset
#..., устраняя недействительные флаги и действительно решая эту проблему!

### Delete sources and umount partitions (Удаление источников и размонтирование разделов)
_cleanup() {
    _info "${MSG_CLEANUP}"
    SRC=(base bootloader desktop display firmware gpu_driver mirrorlist \
mounting partitioning user desktop_apps display_apps gpu_apps system_apps \
00-keyboard.conf language loader.conf timezone xinitrc xprofile \
background.png Grub2-themes archboot* *.log english french german)   

    # Sources (rm) (Источники (rm))
    for SOURCE in "${SRC[@]}"; do
        if [[ -f "${SOURCE}" ]]; then rm -rfv "${SOURCE}"; fi
    done

    # Swap (swapoff) Своп (swapoff)
    CHECK_SWAP=$( swapon -s ); if [[ ${CHECK_SWAP} ]]; then swapoff -av; fi

    # Partitions (umount) Разделы (umount)
    if mount | grep /mnt; then umount -Rfv /mnt; fi
}

### Reboot with 10s timeout (Перезагрузка с таймаутом 10 секунд)
_reboot() {
    for (( SECOND=10; SECOND>=1; SECOND-- )); do
        echo -ne "\r\033[K${GREEN}${MSG_REBOOT} ${SECOND}s...${NC}"
        sleep 1
    done
    reboot; exit 0
}

### Say goodbye (Распрощаться)
_exit_msg() {
    echo -e "\n${GREEN}<<< ${BLUE}${APPNAME} ${VERSION} ${BOLD}by \
${AUTHOR} ${RED}under ${LICENSE} ${GREEN}>>>${NC}"""
}

# ============================================================================
# Терминальный Мануал Arch Wiki :
# Мы можем просмотреть какие файлы сейчас находятся катологе пользователя root
#ls -la
#less install.txt
# ============================================================================
###  Краткая Справка по характеристике подключения к сети интернет  ###
# При установке системы наличие подключения к интернету обязательно.
# Служба DHCP уже запущена при загрузке для найденных Ethernet-адаптеров. 
# Для беспроводных сетевых адаптеров запустите wifi-menu.
# Если выпадает ошибка с номером 213 или др., то выполните следующие команды:
# kill 213 или др., и вновь запускаем dhcpcd
# Запуск и проверка работы службы DHCP через RJ45 : dhcpcd
# Подключение по wifi: wifi-menu
# Если необходимо настроить статический IP или использовать другие средства настройки сети, 
# остановите службу DHCP командой :
# systemctl stop dhcpcd.service и используйте netctl.
# Подключение через PPPoE: 
# используйте для настройки программу pppoe-setup, для запуска — pppoe-start
# ============================================================================

# Команды по установке :
# archiso login: root (automatic login)

# -------------------------------------------------------------------------
# Подключиться к сети (интернет):
# Ethernet - подключите кабель.
# Wi-Fi - аутентификация в беспроводной сети с использованием iwctl.
# Настройте сетевое соединение:
# DHCP : динамический IP-адрес и назначение DNS-сервера (предоставляемые systemd-networkd и systemd-resolved ) должны работать "из коробки" для проводных и беспроводных сетевых интерфейсов.
# Статический IP-адрес: следуйте настройкам сети # Статический IP-адрес.
# Чтобы настроить сетевое соединение, выполните следующие действия:

echo -e "${GREEN}=> ${NC}Make sure that your network interface is specified and enabled" 
#echo 'Make sure that your network interface is specified and enabled'
# Убедитесь, что ваш сетевой интерфейс указан и включен
# Показать все ip адреса и их интерфейсы
ip a
# Смотрим какие у нас есть интернет-интерфейсы
#ip link
# Если наш интерфейс wlan0. В скобках видно, что он UP. Исправляем:
#ip link set wlan0 down
# После этого можно спокойно вызывать wifi-menu и подключатся.
# (для проводных и беспроводных сетевых интерфейсов должны работать "из коробки")
# Также можно посмотреть командой:
#iw dev

# Для беспроводной связи убедитесь, что беспроводная карта не заблокирована с помощью: 
#rfkill 

echo -e "${GREEN}=> ${NC}To check the Internet, you can ping a service" 
#echo 'To check the Internet, you can ping a service'
# Для проверки интернета можно пропинговать какой-либо сервис
ping -c2 archlinux.org
# Например Яндекс или Google: 
#ping -c5 www.google.com
#ping -c5 ya.ru

echo -e "${CYAN}==> ${NC}If the ping goes we go further ..."
#echo 'If the ping goes we go further ...' 
# Если пинг идёт едем дальше ...)

echo -e "${BLUE}:: ${NC}Setting up the Russian language, changing the console font to one that supports Cyrillic for ease of use" 
#echo 'Setting up the Russian language, changing the console font to one that supports Cyrillic for ease of use'
 # Настроим русский язык, изменим консольный шрифт на тот, который поддерживает кириллицу для удобства работы
loadkeys ru
#loadkeys us
setfont cyr-sun16
#setfont ter-v16b #pacman -S terminus-font --noconfirm
# ============================================================================
# Чтобы изменить макет, добавьте соответствующее имя файла в loadkeys , пропустив путь и расширение файла. Например, чтобы установить немецкую раскладку клавиатуры:
# loadkeys de-latin1
# Консольные шрифты находятся внутри /usr/share/kbd/consolefonts/и также могут быть установлены с помощью setfont. 
# ============================================================================

echo -e "${CYAN}==> ${NC}Добавим русскую локаль в систему установки"
#echo 'Добавим русскую локаль в систему установки'
# Adding a Russian locale to the installation system
sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen
#nano /etc/locale.gen
# В файле /etc/locale.gen раскомментируйте (уберите # вначале) строку #ru_RU.UTF-8 UTF-8
echo -e "${BLUE}:: ${NC}Обновим текущую локаль системы"
#echo 'Обновим текущую локаль системы'
# Update the current system locale
locale-gen
# Мы ввели locale-gen для генерации тех самых локалей.

#sleep 01
echo -e "${BLUE}:: ${NC}Указываем язык системы"
#echo 'Указываем язык системы'
# Specify the system language
#echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf
export LANG=ru_RU.UTF-8
#export LANG=en_US.UTF-8
# Эта команда сама пропишет в файлике locale.conf нужные нам параметры.
# Ну и конечно, раз это переменные окружения, то мы можем установить их временно в текущей сессии терминала
# При раскомментировании строки '#export ....', - Будьте Внимательными!
# Как назовёшь, так и поплывёшь...
# When you uncomment the string '#export....', Be Careful!
# As you name it, you will swim...
# ============================================================================

### Display banner (Дисплей баннер)
_arch_fast_install_banner

sleep 02
echo -e "${GREEN}
  <<< Начинается установка минимальной системы Arch Linux >>>
${NC}"
# The installation of the minimum Arch Linux system starts

echo -e "${BLUE}:: ${NC}Установка и настройка начата в $(date +%T)" 
#echo "Установка и настройка начата в $(date +%T)"
# Installation and configuration started in $(date +%T)

echo -e "${BLUE}:: ${NC}2.3 Синхронизация системных часов"  
#echo '2.3 Синхронизация системных часов'
# Syncing the system clock
#echo 'Синхронизируем наши системные часы, включаем ntp, если надо сменим часовой пояс'
# Sync our system clock, enable ntp, change the time zone if necessary
# Активации ntp, и проверка статуса
timedatectl set-ntp true
#timedatectl status

echo -e "${BLUE}:: ${NC}Посмотрим статус службы NTP (NTP service)"
#echo 'Посмотрим статус службы NTP (NTP service)'
# Let's see the NTP service status
timedatectl status

echo -e "${BLUE}:: ${NC}Посмотрим дату и время без характеристик для проверки времени"
#echo 'Посмотрим дату и время без характеристик для проверки времени'
# Let's look at the date and time without characteristics to check the time
date

echo -e "${YELLOW}==> ${NC}Обновить и добавить новые ключи?"
#echo 'Обновить и добавить новые ключи?'
# Update and add new keys?
echo " Данный этап поможет вам избежать проблем с ключами Pacmаn, если Вы используете не свежий образ ArchLinux для установки! "
# This step will help you avoid problems with Pacman keys if you are not using a fresh ArchLinux image for installation!
read -p " 1 - Да обновить , 0 - Нет пропустить: " x_key
if [[ $x_key == 1 ]]; then      
pacman-key --refresh-keys 
elif [[ $x_key == 0 ]]; then
  echo 'Обновление ключей пропущено.'
fi

echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов" 
#echo 'Обновим базы данных пакетов'
# Updating the package databases
#echo "Обновление баз данных пакетов..."
pacman -Sy --noconfirm

echo -e "${BLUE}:: ${NC}Dmidecode. Получаем информацию о железе"
#echo 'Dmidecode. Получаем информацию о железе'
# View information about the motherboard
echo " DMI (Desktop Management Interface) - интерфейс (API), позволяющий программному обеспечению собирать данные о характеристиках компьютера. "
pacman -S dmidecode --noconfirm 
# ------------------------------------------------------------------------------
# DMI (Desktop Management Interface) - интерфейс (API), позволяющий программному обеспечению собирать данные о характеристиках компьютера.
# Dmidecode - программа для linux, позволяющая работать с DMI. Можно получить информацию о:
# (bios, system, baseboard, chassis, processor, memory, cache, connector, slot,...)
# http://linux-bash.ru/menusistem/106-dmidecode.html
# ============================================================================

echo ""
echo -e "${BLUE}:: ${NC}Смотрим информацию о BIOS"
#echo 'Смотрим информацию о BIOS'
# View information about the BIOS
dmidecode -t bios
#dmidecode --type BIOS
# BIOS – это предпрограмма (код, вшитый в материнскую плату компьютера). 
#------------------------------------------------------------------

#echo -e "${BLUE}:: ${NC}Смотрим информацию о материнской плате"
#echo 'Смотрим информацию о материнской плате'
# View information about the motherboard
#echo " Информация о материнской плате "
#dmidecode -t baseboard
#dmidecode --type baseboard

#echo -e "${BLUE}:: ${NC}Смотрим информацию о разьемах на материнской плате"
#echo 'Смотрим информацию о разьемах на материнской плате'
# See information about the connectors on the motherboard
#dmidecode -t connector
#dmidecode --type connector

#echo -e "${BLUE}:: ${NC}Информация о установленных модулях памяти и колличестве слотов под нее"
#echo " Смотрим информацию об аппаратном обеспечении " 
#echo 'Вывод подробной информации об аппаратном обеспечении'
# View information about hardware
#echo " Информация об оперативной памяти "
#dmidecode -t memory
#dmidecode --type memory

#echo -e "${BLUE}:: ${NC}Смотрим информацию об аппаратном обеспечении"
#echo 'Вывод подробной информации об аппаратном обеспечении'
# View information about hardware
#echo " Информация о переключателях системной платы "
#dmidecode -t system
#dmidecode --type system

#echo -e "${BLUE}:: ${NC}Смотрим информацию о центральном процессоре"
#echo 'Смотрим информацию о центральном процессоре'
# Looking at information about the CPU
#dmidecode -t processor
#dmidecode --type processor
# ---------------------------------------------------------------
#sleep 01
echo -e "${BLUE}:: ${NC}Просмотреть объём используемой и свободной оперативной памяти, имеющейся в системе"
#echo 'Просмотреть объём используемой и свободной оперативной памяти, имеющейся в системе'
# View the amount of used and free RAM available in the system
free -m
#echo 'Просмотреть информацию об использовании памяти в системе'
# View information about memory usage in the system
#free -h
echo ""

echo -e "${BLUE}:: ${NC}Посмотрим список установленных SCSI-устройств"
#echo 'Посмотрим список установленных SCSI-устройств'
# See the list of installed SCSI devices
echo " Список устройств scsi/sata "
lsscsi
# В наше время большинство блочных устройств Linux подключаются через интерфейс SCSI. Сюда входят жёсткие диски, USB-флешки, даже ATA-диски теперь тоже подключаются к SCSI через специальный переходник. Поэтому в большинстве случаев вы будете иметь дело именно с дисками sd.
# Жёсткие диски имеют особенные названия. В зависимости от интерфейса, через который подключён жёсткий диск, название может начинаться на:
# sd - устройство, подключённое по SCSI;
# hd - устройство ATA;
# vd - виртуальное устройство;
# mmcblk - обозначаются флешки, подключённые через картридер; 
# Самый простой способ увидеть все подключённые диски - это посмотреть содержимое каталога /dev/ и отфильтровать устройства sd:
#ls -l /dev/

# ============================================================================
# ВНИМАНИЕ!
# Скрипт затирает диск dev/sda (First hard disk) в системе. Примечание для начинющих: 'Пожалуйста, не путайте с приоритетом загрузки устройств, и их последовательного отображения в Bios'. (Пожалуйста, не путайте! - это вчера мне было п#здато, а сегодня мне п#здец!). Поэтому если у Вас есть ценные данные на дисках сохраните их. 
# Если Вам нужна установка рядом с Windows, тогда Вам нужно предварительно изменить скрипт и разметить диски. В противном случае данные и Windows будут затерты.
# Если Вам не подходит автоматическая разметка дисков, тогда предварительно нужно сделать разметку дисков и настроить скрипт под свои нужды (программы, XFCE config и т.д.)
# Смотрите пометки в самом скрипте!
# ---------------------------------------------------------------------------
# Разбиваем диски (есть два способа разбивки дисков: 1)fdisk - чисто консольный; 2)cfdisk - псевдографический).
# Разбиваем диски (для ручной разметки используем fdisk, для псевдографической разбивки можно использовать команду cfdisk).
# <<< Лично я советую пользоваться cfdisk,т.к. присутствует интерфейсная оболочка. >>>
# Если раздел больше 2Тб то fdisk не справится (идёт лесом)!
# Вам можно будет воспользоваться утилитой parted:
#parted -a optimal /dev/sda -s mklabel gpt mkpart primary 0% 100%
#parted -a optimal /dev/sda -s mklabel dos mkpart primary 0% 100%
# И т.д. https://wiki.archlinux.org/index.php/Parted
# 8 Parted команд Linux для создания, изменения размера и восстановления разделов диска:
# http://blog.sedicomm.com/2017/11/15/8-parted-komand-linux-dlya-sozdaniya-izmeneniya-razmera-i-vosstanovleniya-razdelov-diska/
# ============================================================================
echo ""
echo -e "${BLUE}:: ${NC}Смотрим, какие диски есть в нашем распоряжении"
#echo 'Давайте посмотрим, какие диски у нас есть в нашем распоряжении'
# Let's see what drives we have at our disposal
lsblk -f
# ------------------------------------------------------------
# Самый простой способ увидеть все подключённые диски - это посмотреть содержимое каталога /dev/ и отфильтровать устройства sd:
#ls -l /dev/

echo ""
# Ещё раз проверте правильность разбивки на разделы!
echo -e "${BLUE}:: ${NC}Посмотрим структуру диска созданного установщиком"
#echo 'Посмотрим структуру диска созданного установщиком'
# Let's look at the disk structure created by the installer
read -p " => Укажите диск (sda/sdb например sda или sdb) : " cfd
sgdisk -p /dev/$cfd #sda sdb sdc sdd
#sgdisk -p /dev/sda #sdb sdc sdd

#echo -e "${BLUE}:: ${NC}Стираем таблицу разделов на выбранном диске (sdX):"
#echo 'Стираем таблицу разделов на выбранном диске (sdX):'
# Erasing the partition table on the selected disk (sdX)
#read -p " => Укажите диск (sda/sdb например sda или sdb) : " cfd
#sgdisk --zap-all /dev/$cfd  #sda sdb sdc sdd
#sgdisk --zap-all /dev/sda  #sdb sdc sdd
# Вывод:
# Creating new GPT entries in memory.
# GPT data structures destroyed! You may now partition the disk using fdisk or other utilities.
# Создание новых записей GPT в памяти.
# Структуры данных GPT уничтожены! Теперь вы можете разбить диск на разделы с помощью fdisk или других утилит.

echo -e "${GREEN}==> ${NC}Удалить (стереть) таблицу разделов на выбранном диске (sdX)?"
#echo 'Удалить (стереть) таблицу разделов на выбранном диске (sdX)?'
# Delete (erase) the partition table on the selected disk (sdX)?
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
read -p " 1 - Да удалить таблицу разделов, 0 - Нет пропустить: " sgdisk
if [[ $sgdisk == 1 ]]; then
read -p " => Укажите диск (sda/sdb например sda или sdb) : " cfd
sgdisk --zap-all /dev/$cfd  #sda sdb sdc sdd
  echo " Создание новых записей GPT в памяти. "
  echo " Структуры данных GPT уничтожены! Теперь вы можете разбить диск на разделы с помощью fdisk или других утилит. " 
elif [[ $sgdisk == 0 ]]; then
  echo 'Операция пропущена.'
fi

#echo -e "${BLUE}:: ${NC}Стираем таблицу разделов на втором и третьем диске (sdb, sdc):"
#echo 'Стираем таблицу разделов на втором и третьем диске (sdb, sdc):'
# Erasing the partition table on the second and third disk (sdb, sdc)
#sgdisk --zap-all /dev/sdb
#sgdisk --zap-all /dev/sdc
# ---------------------------------------------------------------------------
# Для получения самой подробной информации обратитесь к справочной странице:
#man sgdisk
# ============================================================================

echo ""
echo -e "${GREEN}==> ${NC}Создание разделов диска для ArchLinux"
#echo 'Создание разделов диска для ArchLinux'
# Creating disk partitions for ArchLinux
echo -e "${BLUE}:: ${NC}Вам нужна разметка диска?"
#echo 'Вам нужна разметка диска?'
# Do you need disk markup?
read -p " 1 - Да приступить к разметке, 0 - Нет пропустить разметку: " cfdisk  # файл устройство дискового накопителя;
if [[ $cfdisk == 1 ]]; then
   clear
   echo ""
 lsblk -f
  echo ""
  read -p " Укажите диск (sda/sdb например sda или sdb) : " cfd
cfdisk /dev/$cfd
echo ""
clear
elif [[ $cfdisk == 0 ]]; then
   echo ""
   clear
   echo 'Разметка пропущена.'   
fi

# ------------------------------------------------------------------------
# cfdisk — является редактором разделов Linux с интерактивным пользовательским интерфейсом Ncurses. Команда может быть использована для отображения списка существующих разделов, а так же внесения каких либо изменений.
# Разделы можно менять местами, можно сделать сначала root /, потом home, потом swap - или наоборот ...
# Один из основных постулатов Unix/Linux - «всё есть файл», и жесткие диски - не исключение.
# Каждый найденный ядром диск, отображается в виде файла в специальном каталоге устройств «/dev»
# Например: cfdisk /dev/sdb
# /dev/sda, /dev/sdb, /dev/sdc и т.д.
# Разделы могут быть:
# основными, которых на диске может быть не более 4-х;
# расширенными (Extended) - логические разделы (обычно только один) с которыми нельзя работать, контейнер для дополнительных разделов;
# дополнительными - их номера всегда >=5.
# Кроме номера и размера, каждый раздел имеет свой тип, который обозначен одним байтом:
# 0b Win95 FAT32
# 0f Win95 Ext'd (LBA)
# 07 HPFS/NTFS
# 82 Linux swap
# 83 Linux
# fd linux RAID autodetect
# Разделами манипулируют следующие программы: fdisk, cfdisk, sfdisk, parted, …
# ===========================================================================

###         "Справка команд по работе с утилитой fdisk"
# ============================================================================
# Команда (m для справки): m
# Справка:

#  Работа с разбиением диска в стиле DOS (MBR)
#   a   переключение флага загрузки
#   b   редактирование вложенной метки диска BSD
#   c   переключение флага dos-совместимости 

#  Общие
#   d   удалить раздел
#   F   показать свободное неразмеченное пространство
#   l   список известных типов разделов
#   n   добавление нового раздела
#   p   вывести таблицу разделов
#   t   изменение метки типа раздела
#   v   проверка таблицы разделов
#   i   вывести информацию о разделе

#  Разное
#   m   вывод этого меню
#   u   изменение единиц измерения экрана/содержимого
#   x   дополнительная функциональность (только для экспертов)

#  Сценарий
#   I   загрузить разметку из файла сценария sfdisk
#   O   записать разметку в файл сценария sfdisk

#  Записать и выйти
#   w   запись таблицы разделов на диск и выход
#   q   выход без сохранения изменений

#  Создать новую метку
#   g   создание новой пустой таблицы разделов GPT
#   G   создание новой пустой таблицы разделов SGI (IRIX)
#   o   создание новой пустой таблицы разделов DOS
#   s   создание новой пустой таблицы разделов Sun
# ---------------------------------------------------------------------------
### https://linux-faq.ru/page/komanda-fdisk
### https://www.altlinux.org/Fdisk
# ============================================================================

echo "" 
echo -e "${BLUE}:: ${NC}Ваша разметка диска" 
#echo 'Ваша разметка диска'
# Your disk markup
# Команда fdisk –l выведет список существующих разделов, если таковые существуют
fdisk -l
# FDISK — является часто используемой командой для проверки разделов на диске. Она может отобразить список разделов, а так же дополнительную информацию.
# Для просмотра разделов одного выбранного диска используйте такой вариант этой же команды:
#fdisk -l /dev/sda
lsblk -f
# lsblk — выводит список всех блоков хранения информации, среди которых могут быть дисковые разделы и оптические приводы. Отображается такая информация как общий размер раздела/блока, точка монтирования (если таковая есть). Если нет точки монтирования, то это может значить что файловая система не смонтирована, для CD/DVD привода дисков это означает, что в лотке нету диска
#sfdisk -l -uM
# Sfdisk — отображает похожую информацию, так же как и FDISK, однако есть и некоторые особенности, к примеру, отображение размера каждого раздела в мегабайтах.
#parted -l
# parted — ещё одна утилита командной строки, которая умеет отображать список разделов, информацию о них, а так же позволяет вносить изменения в разделы при необходимости

sleep 01
clear
echo ""
echo -e "${BLUE}:: ${NC}Форматирование разделов диска"
#echo 'Форматирование разделов диска'
# Formatting disk partitions
echo -e "${BLUE}:: ${NC}Установка название флага boot,root,swap,home"
#echo 'Установка название флага boot,root,swap,home'
# Setting the flag name boot, root,swap, home
echo -e "${BLUE}:: ${NC}Монтирование разделов диска"
#echo 'Монтирование разделов диска'
# Mounting disk partitions
########## Root  ########
#clear
lsblk -f
echo ""
echo -e "${BLUE}:: ${NC}Форматируем и монтируем ROOT раздел?"
#echo 'Форматирование и монтирование корневого раздела (ROOT)'
# Formatting and mounting a partition (ROOT)
read -p " Укажите ROOT раздел (sda/sdb 1.2.3.4 (sda5 например)): " root
echo ""
mkfs.ext4 /dev/$root -L root
mount /dev/$root /mnt
echo ""
########## Boot  ########
clear
echo ""
lsblk -f
echo ""
echo -e "${BLUE}:: ${NC}Форматируем BOOT раздел?"
#echo 'Форматирование загрузочного раздела (BOOT)'
# Formatting the BOOT partition
echo " Если таковой был создан при разметке в cfdisk "
#Если он был создан во время разметки в cfdisk'
# If one was created during markup in cfdisk
echo " 1 - Форматировать и монтировать на отдельный раздел "
echo " 0 - Пропустить если BOOT раздела нет на отдельном разделе, и он находится в корневом разделе ROOT "
read -p " 1 - Да форматировать, 0 - Нет пропустить: " boots  # sends right after the keypress; # отправляет сразу после нажатия клавиши
if [[ $boots == 1 ]]; then
  read -p " Укажите BOOT раздел (sda/sdb 1.2.3.4 (sda7 например)): " bootd
  #mkfs.fat -F32 /dev/$bootd
  #mkfs.ext2  /dev/$bootd
  mkfs.ext2  /dev/$bootd -L boot
  mkdir /mnt/boot
  mount /dev/$bootd /mnt/boot
elif [[ $boots == 0 ]]; then
 echo " Форматирование и монтирование не требуется " 
fi
########## Swap  ########
clear
echo ""
lsblk -f
echo ""
echo -e "${BLUE}:: ${NC}Форматируем Swap раздел?"
#echo 'Форматирование раздела подкачки (SWAP)'
# Format the Swap section
echo " Если таковой был создан при разметке в cfdisk "
#Если он был создан во время разметки в cfdisk'
# If one was created during markup in cfdisk
read -p " 1 - Да, 0 - Нет: " swap  # sends right after the keypress; # отправляет сразу после нажатия клавиши
if [[ $swap == 1 ]]; then
  read -p " Укажите swap раздел (sda/sdb 1.2.3.4 (sda7 например)): " swaps
  mkswap /dev/$swaps -L swap
  swapon /dev/$swaps
elif [[ $swap == 0 ]]; then
   echo ' Добавление Swap раздела пропущено. '   
fi
########## Home  ########
clear
echo ""
echo -e "${BLUE}:: ${NC}Добавим HOME раздел?"
#echo 'Добавление домашнего раздела (HOME)'
# Adding a HOME section?
echo " Если таковой был создан при разметке в cfdisk "
#Если он был создан во время разметки в cfdisk'
# If one was created during markup in cfdisk
echo " Можно использовать раздел от предыдущей системы (и его не форматировать),  
далее в процессе установки можно будет удалить все скрытые файлы и папки в каталоге 
пользователя. "
read -p " 1 - Да, 0 - Нет: " homes  # sends right after the keypress; # отправляет сразу после нажатия клавиши
if [[ $homes == 0 ]]; then
  echo 'Добавление Home раздела пропущено.'
elif [[ $homes == 1 ]]; then
   echo ' Добавление домашнего раздела (HOME) '   
echo -e "${BLUE}:: ${NC}Форматируем Home раздел?"
#echo 'Форматирование домашнего раздела (HOME)'
# Formatting the home partition
read -p " 1 - Да, 0 - Нет: " homeF  # sends right after the keypress; # отправляет сразу после
   if [[ $homeF == 1 ]]; then
   echo ""
   lsblk -f
   read -p " Укажите HOME раздел (sda/sdb 1.2.3.4 (sda6 например)): " home
   mkfs.ext4 /dev/$home -L home
   mkdir /mnt/home 
   mount /dev/$home /mnt/home
   elif [[ $homeF == 0 ]]; then
 lsblk -f
 read -p " Укажите HOME раздел (sda/sdb 1.2.3.4 (sda6 например)): " homeV
 mkdir /mnt/home 
 mount /dev/$homeV /mnt/home
fi
fi

# -----------------------------------------------------------------------
# Посмотреть что мы намонтировали можно командой:
#mount | grep sda    
# - покажет куда был примонтирован sda
echo -e "${BLUE}:: ${NC}Просмотреть подключённые диски с выводом информации о размере и свободном пространстве"
#echo 'Просмотреть подключённые диски с выводом информации о размере и свободном пространстве'
# View attached disks with information about size and free space
df -h
# DF — не является утилитой для разметки разделов, скорее больше для просмотра информации. Можно отметить то, что утилита DF способна вывести информацию о файловых системах, которые даже не являются реальными разделами диска.
#pydf
# Pydf — является в неком роде улучшением версии DF, которая написана на Python. Способна выводить информацию о всех разделах жесткого диска в удобном виде. Но есть и минусы, показываются только смонтированные файловые системы.

echo -e "${BLUE}:: ${NC}Просмотреть все идентификаторы наших разделов"
#echo 'Просмотреть все идентификаторы наших разделов'
# View all IDs of our sections
blkid
# BLKID — выводит информацию о разделах файловой системы, среди них такие атрибуты как UUID, а так же тип файловой системы. Однако эта утилита не сообщает о дисковом пространстве на разделах.

echo -e "${BLUE}:: ${NC}Просмотреть информацию об использовании памяти в системе"
#echo 'Просмотреть информацию об использовании памяти в системе'
# View information about memory usage in the system
free -h
# Команда проверяет объем используемой и свободной оперативной памяти, имеющейся в системе:
#free -m
echo ""
# -------------------------------------------------------------------
# Команда free в Linux с примерами:
# https://andreyex.ru/operacionnaya-sistema-linux/komanda-free-v-linux-s-primerami/
# ============================================================================

### Замена исходного mirrorlist (зеркал для загрузки) на мой список серверов-зеркал
#echo '3.1 Замена исходного mirrorlist (зеркал для загрузки)'
#Ставим зеркало от Яндекс
# Удалим старый файл /etc/pacman.d/mirrorlist
#rm -rf /etc/pacman.d/mirrorlist
# Загрузка нового файла mirrorlis (список серверов-зеркал)
#wget https://raw.githubusercontent.com/MarcMilany/arch_2020/master/Mirrorlist/mirrorlist
# Переместим нового файла mirrorlist в /etc/pacman.d/mirrorlist
#mv -f ~/mirrorlist /etc/pacman.d/mirrorlist
#echo "Обновление баз данных пакетов..."
#sudo pacman -Sy

# -----------------------------------------------------------------------------

echo -e "${BLUE}:: ${NC}3.1 Выбор серверов-зеркал для загрузки. Ставим зеркало от Яндекс"
#echo '3.1 Выбор серверов-зеркал для загрузки. Ставим зеркало от Яндекс'
# The choice of mirror sites to download. Putting a mirror from Yandex
#echo "Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
> /etc/pacman.d/mirrorlist
cat <<EOF >>/etc/pacman.d/mirrorlist

##
## Arch Linux repository mirrorlist
## Generated on 2020-07-03
## HTTP IPv4 HTTPS
##

## Russia
Server = https://mirror.rol.ru/archlinux/\$repo/os/\$arch
Server = https://mirror.yandex.ru/archlinux/\$repo/os/\$arch
#Server = http://mirror.rol.ru/archlinux/\$repo/os/\$arch
#Server = http://mirror.truenetwork.ru/archlinux/\$repo/os/\$arch
#Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch
#Server = http://archlinux.zepto.cloud/\$repo/os/\$arch

##
## Arch Linux repository mirrorlist
## Generated on 2020-07-03
## HTTP IPv6 HTTPS
##

## Russia
#Server = http://mirror.yandex.ru/archlinux/$repo/os/\$arch
#Server = https://mirror.yandex.ru/archlinux/$repo/os/\$arch
#Server = http://archlinux.zepto.cloud/$repo/os/\$arch

EOF

# ============================================================================

echo -e "${BLUE}:: ${NC}Создание (backup) резервного списка зеркал mirrorlist - (mirrorlist.backup)"
#echo 'Создание (backup) резервного списка зеркал mirrorlist - (mirrorlist.backup)'
# Creating a backup list of mirrors mirrorlist - (mirrorlist.backup)
cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
# ============================================================================
# Получение и ранжирование свежего списка зеркал
# Воспользуйтесь Pacman Mirrorlist Generator, чтобы получить список актуальных зеркал определённых стран и отсортировать его с помощью rankmirrors. Команда ниже скачивает актуальный список зеркал во Франции и Великобритании, использующих протокол https, после чего удаляет комментарии, ранжирует сервера и выводит 5 наиболее быстрых из них.

#curl -s "https://www.archlinux.org/mirrorlist/?country=FR&country=GB&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 -

#curl -s "https://www.archlinux.org/mirrorlist/?country=RU&country&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 -

# https://wiki.archlinux.org/index.php/Mirrors_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# ============================================================================
echo -e "${BLUE}:: ${NC}Посмотреть список серверов-зеркал для загрузки в mirrorlist"
#echo 'Посмотреть список серверов-зеркал для загрузки в mirrorlist'
# View the list of mirror servers to upload to mirrorlist
cat /etc/pacman.d/mirrorlist

# Pacman Mirrorlist Generator
# https://www.archlinux.org/mirrorlist/
# Эта страница генерирует самый последний список зеркал, возможный для Arch Linux. Используемые здесь данные поступают непосредственно из внутренней базы данных зеркал разработчиков, используемой для отслеживания доступности и уровня зеркалирования. 
# Есть два основных варианта: получить список зеркал с каждым доступным зеркалом или получить список зеркал, адаптированный к вашей географии.

# ============================================================================
#echo -e "${BLUE}:: ${NC}Загрузка свежего списка зеркал со страницы Mirror Status, и обновим файл mirrorlist"
#echo 'Загрузка свежего списка зеркал со страницы Mirror Status, и обновим файл mirrorlist'
# Loading a fresh list of mirrors from the Mirror Status page, and updating the mirrorlist file
# Чтобы увидеть список всех доступных опций, наберите:
#reflector --help
# Команда отфильтрует пять зеркал, отсортирует их по скорости и обновит файл mirrorlist:
#sudo pacman -Sy --noconfirm --noprogressbar --quiet reflector
#reflector --verbose --country 'Russia' -l 5 -p https -p http -n 5 --save /etc/pacman.d/mirrorlist --sort rate
#reflector --verbose --country 'Russia' -l 5 -p https -p http -n 5 --sort rate --save /etc/pacman.d/mirrorlist
#reflector -c "Russia" -c "Belarus" -c "Ukraine" -c "Poland" -f 5 -l 5 -p https -p http -n 5 --save /etc/pacman.d/mirrorlist --sort rate

#echo 'Выбор серверов-зеркал для загрузки.'
#echo 'The choice of mirrors to download.'
#pacman -Sy --noconfirm --noprogressbar --quiet reflector
#reflector --verbose --country Kazakhstan --country Russia --sort rate --save /etc/pacman.d/mirrorlist
#reflector -c "Russia" -c "Belarus" -c "Ukraine" -c "Poland" -f 20 -l 20 -p https -p http -n 20 --save /etc/pacman.d/mirrorlist --sort rate
#Команда отфильтрует 12 зеркал russia, отсортирует по скорости и обновит файл mirrorlist
#sudo reflector -c "Russia" -f 12 -l 12 --verbose --save /etc/pacman.d/mirrorlist
#------------------------------------------------------------------------------
# Reflector — скрипт, который автоматизирует процесс настройки зеркал, включающий в себя загрузку свежего списка зеркал со страницы Mirror Status.
# https://www.linuxsecrets.com/archlinux-wiki/wiki.archlinux.org/index.php/Reflector_(%D0%A0%D1%2583%D1%2581%D1%2581%D0%BA%D0%B8%D0%B9).html
# Эта страница сообщает о состоянии всех известных, общедоступных и активных зеркал Arch Linux:
# https://www.archlinux.org/mirrors/status/
# ============================================================================

echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов" 
#echo 'Обновим базы данных пакетов'
# Updating the package databases
#sudo pacman-key --init
#sudo pacman-key --refresh-keys
sudo pacman -Sy  

# ============================================================================
# Знакомьтесь, pacman - лучший пакетный менеджер в мире линукса!
#pacman -Syy   - обновление баз пакмэна(как apt-get update в дэбианоподбных)
#pacman -Syyu  - обновление баз плюс обновление пакетов
# ----------------------------------------------------------------------------
# Если возникли проблемы с обновлением, или установкой пакетов 
# Выполните данные рекомендации:
#echo 'Обновление ключей системы'
# Updating of keys of a system
#echo "Создаётся генерация мастер-ключа (брелка) pacman, введите пароль (не отображается)..."
#sudo pacman-key --init
#echo "Далее идёт поиск ключей..."
#sudo pacman-key --populate archlinux
#echo "Обновление ключей..."
#sudo pacman-key --refresh-keys
#echo "Обновление баз данных пакетов..."
#sudo pacman -Sy
# Или:
#sudo pacman-key --init && sudo pacman-key --populate archlinux && sudo pacman-key --refresh-keys && sudo pacman -Sy
# ============================================================================

echo -e "${BLUE}:: ${NC}3.2 Установка основных пакетов (base base-devel)"
#echo '3.2 Установка основных пакетов (base base-devel)'
# Installing basic packages (base base-devel)
echo 'Arch Linux, Base devel (AUR only), Kernel (optional), Firmware'
# Arch Linux, Base devel (AUR only), Kernel (optional), Firmware
#pacstrap /mnt base base-devel linux-lts linux-firmware nano dhcpcd netctl vim which inetutils # parted
pacstrap /mnt base base-devel
pacstrap /mnt linux-lts linux-firmware # linux-headers
pacstrap /mnt nano vim dhcpcd netctl which inetutils 
# ---------------------------------------------------------------------------
# Важно! Если Вы ведёте установку используя pppoe, то вам необходимо установить пакет rp-pppoe:
# pacstrap -i /mnt rp-pppoe
#pacstrap /mnt base base-devel linux-lts linux-firmware nano dhcpcd netctl vim --noconfirm  # parted
#pacstrap /mnt base base-devel linux-lts linux-firmware nano dhcpcd netctl vim --noconfirm --noprogressbar --quiet
#pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl vim
#pacstrap /mnt base base-devel linux-hardened linux-firmware nano dhcpcd netctl vim
#pacstrap /mnt base base-devel linux-zen linux-firmware nano dhcpcd netctl vim
# ----------------------------------------------------------------------------
#pacstrap /mnt base base-devel linux-zen linux-firmware nano dhcpcd netctl zsh zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting git ccache btrfs-progs wget terminus-font
# ----------------------------------------------------------------------------
#pacstrap -i /mnt base base-devel linux linux-firmware nano dhcpcd netctl vim --noconfirm
# Параметр-I обеспечивает побуждение перед установкой пакета
# The -i switch ensures prompting before package installation
#pacstrap /mnt linux base nano dhcpcd netctl sudo wget --noconfirm --noprogressbar --quiet
#pacstrap /mnt base base-devel linux linux-headers linux-firmware lvm2 nano networkmanager bash-completion reflector htop openssh curl wget git rsync unzip unrar p7zip gnu-netcat pv
# ----------------------------------------------------------------------------
# base - основные программы.
# base-devel - утилиты для разработчиков. Нужны для AUR.
# linux - ядро.
# linux-firmware - файлы прошивок для linux.
# linux-headers-[версия] - заголовочные файлы ядра: linux-headers-$(uname -r).
# linux-image-[версия] – бинарный образ ядра.
# linux-extra-[версия] – дополнительные внешние модули ядра для расширения функционала.
# nano - простой консольный текстовый редактор. Если умете работать в vim, то можете поставить его вместо nano.
# vim -  - это настраиваемый текстовый редактор.
###########################
# grub - загрузчик операционной системы. Без него даже загрузиться в новую систему не сможем.
# efibootmgr - поможет grub установить себя в загрузку UEFI.
# sudo - позволяет обычным пользователем совершать действия от лица суперпользователя.
# git - приложение для работы с репозиториями Git. Нужен для AUR и много чего ещё.
# networkmanager - сервис для работы интернета. Вместе с собой устанавливает программы для настройки.
#########################
# man-db - просмотрщик man-страниц.
# man-pages - куча man-страниц (руководств).
# ============================================================================
# В официальном wiki от arch https://wiki.archlinux.org/index.php/Installation_guide ,
# написано pacstrap /mnt base, советую тут повторить за мной, ибо если Вам нужен доступ к AUR (Arch User Repository) Вам надо будет base-devel (есть возможность поставить когда угодно).
# Основные элементы уже у Вас на жестком диске, теперь надо сделать чтобы оно всё запускалось и работало.
# ============================================================================

echo -e "${BLUE}:: ${NC}3.3 Настройка системы, генерируем fstab" 
#echo '3.3 Настройка системы, генерируем fstab'
# Configuring the system, generating fstab
genfstab -pU /mnt >> /mnt/etc/fstab
#(или genfstab -L /mnt >> /mnt/etc/fstab)
#genfstab -p -L /mnt > /mnt/etc/fstab
# Нашёл ещё две команды для генерации fstab при установке:
#genfstab -U -p /mnt >> /mnt/etc/fstab
#genfstab /mnt >> /mnt/etc/fstab
# ---------------------------------------------------------------------------
# Обе из них генерируют UUID хотя во второй команде этого ключа нет
# Почему это так происходит ?
# С ключом -U генерирует UUID без него раздел будет вида /dev/sda1 или что то в этом роде.
# Учтите, что когда пишется >> то ты добавляешь в файл, а не переписываешь его с нуля.
# То есть, если Вы вбивали два раза команды что написаны выше, то у Вас может в этом файле быть прописано монтирование одного и того же раздела в двух разных вариантах что чревато.
# Команда genfstab -h может сказать многое в том числе для чего нужно -p. Исключает монтирование псевдо файловые системы. Ключик можно не использовать, ибо используется по дефолту.
# Installation guide (Русский): fstab (Русский)
# https://wiki.archlinux.org/index.php/Fstab_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# ============================================================================
echo -e "${BLUE}:: ${NC}Просмотреть содержимое файла fstab"
#echo 'Просмотреть содержимое файла fstab'
# View the contents of the fstab file
cat /mnt/etc/fstab
# ============================================================================
# Был создан файл содержащий данные о монтируемых файловых системах.
# Чтобы система знала какие разделы монтировать при старте.
# ============================================================================

echo -e "${BLUE}:: ${NC}Удалим старый файл mirrorlist из /mnt/etc/pacman.d/mirrorlist"
#echo 'Удалим старый файл mirrorlist из /mnt/etc/pacman.d/mirrorlist'
# Delete files /etc/pacman.d/mirrorlist
# Удалим mirrorlist из /mnt/etc/pacman.d/mirrorlist
rm /mnt/etc/pacman.d/mirrorlist 
#rm -rf /mnt/etc/pacman.d/mirrorlist
#Удалите файл /etc/pacman.d/mirrorlist
#rm -rf /etc/pacman.d/mirrorlist
# Удаления старой резервной копии (если она есть, если нет, то пропустите этот шаг):
#rm /etc/pacman.d/mirrorlist.old

echo -e "${BLUE}:: ${NC}Загрузка свежего списка зеркал со страницы Mirror Status, и обновляем mirrorlist"
#echo 'Загрузка свежего списка зеркал со страницы Mirror Status, и обновляем mirrorlist'
# Loading a fresh list of mirrors from the Mirror Status page, and updating the mirrorlist
# Чтобы увидеть список всех доступных опций, наберите:
#reflector --help
# Команда отфильтрует пять зеркал, отсортирует их по скорости и обновит файл mirrorlist:
#sudo pacman -Sy --noconfirm --noprogressbar --quiet reflector
reflector --verbose --country 'Russia' -l 7 -p https -p http -n 7 --save /etc/pacman.d/mirrorlist --sort rate  
#reflector --verbose --country 'Russia' -l 5 -p https -p http -n 5 --sort rate --save /etc/pacman.d/mirrorlist

echo -e "${BLUE}:: ${NC}Копируем созданный список зеркал (mirrorlist) в /mnt"
#echo 'Копируем созданный список зеркал (mirrorlist) в /mnt'
# Copying the created list of mirrors (mirrorlist) to /mnt
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
 
echo -e "${BLUE}:: ${NC}Копируем резервного списка зеркал (mirrorlist.backup) в /mnt"
#echo 'Копируем резервного списка зеркал (mirrorlist.backup) в /mnt'
# Copying the backup list of mirrors (mirrorlist.backup) in /mnt
cp /etc/pacman.d/mirrorlist.backup /mnt/etc/pacman.d/mirrorlist.backup

echo -e "${BLUE}:: ${NC}Посмотреть список серверов-зеркал /mnt/etc/pacman.d/mirrorlist"
#echo 'Посмотреть список серверов-зеркал /mnt/etc/pacman.d/mirrorlist'
# View the list of mirror servers /mnt/etc/pacman.d/mirrorlist
cat /mnt/etc/pacman.d/mirrorlist

echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов" 
#echo 'Обновим базы данных пакетов'
# Updating the package databases
#sudo pacman-key --init
#sudo pacman-key --refresh-keys
sudo pacman -Sy  

# ============================================================================
# Знакомьтесь, pacman - лучший пакетный менеджер в мире линукса!
#pacman -Syy   - обновление баз пакмэна(как apt-get update в дэбианоподбных)
#pacman -Syyu  - обновление баз плюс обновление пакетов
# ----------------------------------------------------------------------------

echo -e "${GREEN}==> ${NC}Меняем корень и переходим в нашу недавно скачанную систему" 
#echo 'Меняем корень и переходим в нашу недавно скачанную систему'
# Change the root and go to our recently downloaded system
echo " Первый этап установки Arch'a закончен " 
echo 'Установка продолжится в ARCH-LINUX chroot' 
arch-chroot /mnt sh -c "$(curl -fsSL git.io/archmy2)"

# -----------------------------------------------------------------------------
# Change root. Здесь мы просто переходим в нашу недавно скачанную систему, теперь можно устанавливать те утилиты (пакеты), которые Вы решили установить, этот софт останется у Вас в системе. (что угодно, кроме утилит (пакетов) из 'Arch User Repository, AUR', так как репозиторий ещё не установлен.
# Chroot на практике - полезные статьи :
# https://wiki.archlinux.org/index.php/Chroot_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# http://www.unix-lab.org/posts/chroot/
# ============================================================================
##curl -fsSL
#-f — не выводить сообщения об ошибках;
#-s — максимальное количество перенаправлений с помощью Location;
#-S — выводить сообщения об ошибках;
#-L — принимать и обрабатывать перенаправления;
# 
# -------------------------------------------------------------------------------
### ЧТО ТАКОЕ CURL?
# На самом деле, curl - это больше чем просто утилита командной строки для Linux или Windows. Это набор библиотек, в которых реализуются базовые возможности работы с URL страницами и передачи файлов. Библиотека поддерживает работу с протоколами: FTP, FTPS, HTTP, HTTPS, TFTP, SCP, SFTP, Telnet, DICT, LDAP, а также POP3, IMAP и SMTP. Она отлично подходит для имитации действий пользователя на страницах и других операций с URL адресами.
# Поддержка библиотеки curl была добавлена в множество различных языков программирования и платформ. Утилита curl - это независимая обвертка для этой библиотеки. Именно на этой утилите мы и остановимся в этой статье.
# Синтаксис утилиты curl linux:
#$ curl опции ссылка
#$ curl --version
# Теперь рассмотрим основные опции:
# -# - отображать простой прогресс-бар во время загрузки;
# -0 - использовать протокол http 1.0;
# -1 - использовать протокол шифрования tlsv1;
# -2 - использовать sslv2;
# -3 - использовать sslv3;
# -4 - использовать ipv4;
# -6 - использовать ipv6;
# -A - указать свой USER_AGENT;
# -b - сохранить Cookie в файл;
# -c - отправить Cookie на сервер из файла;
# -C - продолжить загрузку файла с места разрыва или указанного смещения;
# -m - максимальное время ожидания ответа от сервера;
# -d - отправить данные методом POST;
# -D - сохранить заголовки, возвращенные сервером в файл;
# -e - задать поле Referer-uri, указывает с какого сайта пришел пользователь;
# -E - использовать внешний сертификат SSL;
# -f - не выводить сообщения об ошибках;
# -F - отправить данные в виде формы;
# -G - если эта опция включена, то все данные, указанные в опции -d будут передаваться методом GET;
# -H - передать заголовки на сервер;
# -I - получать только HTTP заголовок, а все содержимое страницы игнорировать;
# -j - прочитать и отправить cookie из файла;
# -J - удалить заголовок из запроса;
# -L - принимать и обрабатывать перенаправления;
# -s - максимальное количество перенаправлений с помощью Location;
# -o - выводить контент страницы в файл;
# -O - сохранять контент в файл с именем страницы или файла на сервере;
# -p - использовать прокси;
# --proto - указать протокол, который нужно использовать;
# -R -  сохранять время последнего изменения удаленного файла;
# -s - выводить минимум информации об ошибках;
# -S - выводить сообщения об ошибках;
# -T - загрузить файл на сервер;
# -v - максимально подробный вывод;
# -y - минимальная скорость загрузки;
# -Y - максимальная скорость загрузки;
# -z - скачать файл, только если он был модифицирован позже указанного времени;
# -V - вывести версию.
# Это далеко не все параметры curl linux, но здесь перечислено все основное, что вам придется использовать.
# https://itproffi.ru/komanda-curl-sintaksis-primery-ispolzovaniya/
# https://losst.ru/kak-polzovatsya-curl
# ********************************************************** 

