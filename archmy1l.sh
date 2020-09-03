#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
iso_label="ARCH_$(date +%Y%m)"
iso_version=$(date +%Y.%m.%d)
gpg_key=
verbose=""
EDITOR=nano
# Выполните команду с правами суперпользователя:
#EDITOR=nano visudo

### Installer default language (Язык установки по умолчанию)
ARCHMY1_LANG="russian"   
#ARCHMY2_LANG="russian"
#ARCHMY3_LANG="russian"
#ARCHMY4_LANG="russian"

script_path=$(readlink -f ${0%/*})

umask 0022

##################################################################
##### <<<Arch Linux Fast Install LegasyBIOS (arch2020)>>>    #####
#### Скрипты 'arch_2020' созданы на основе сценария (скрипта) ####
#### 'ordanax/arch2018'. При выполнении скрипта Вы получаете  ####
#### возможность быстрой установки ArchLinux с вашими личными ####
#### настройками (при условии, что Вы его изменили под себя,  ####
####  в противном случае с моими настройками).               ####       
####  В скрипте прописана установка grub для LegasyBIOS, и   ####
####  с DE - рабочего стола Xfce.                            ####  
##### Этот скрипт находится в процессе 'Внесение поправок в  ####
#### наводку орудий по результатам наблюдений с наблюдате-   ####
#### льных пунктов'.                                         ####
#### Автор не несёт ответственности за любое нанесение вреда ####
#### при использовании скрипта.                              ####
#### Installation guide - Arch Wiki  (referance):            ####
#### https://wiki.archlinux.org/index.php/Installation_guide ####
#### Проект (project): https://github.com/ordanax/arch2018   ####
#### Лицензия (license): LGPL-3.0                            #### 
#### (http://opensource.org/licenses/lgpl-3.0.html           ####
#### В разработке принимали участие (author) :               ####
#### Алексей Бойко https://vk.com/ordanax                    ####
#### Степан Скрябин https://vk.com/zurg3                     ####
#### Михаил Сарвилин https://vk.com/michael170707            ####
#### Данил Антошкин https://vk.com/danil.antoshkin           ####
#### Юрий Порунцов https://vk.com/poruncov                   ####
#### Jeremy Pardo (grm34) https://www.archboot.org/          ####
#### Marc Milany - 'Не ищи меня 'Вконтакте',                 ####
#####                в 'Одноклассниках'' нас нету, ...       ####
#### Releases ArchLinux:                                     ####
####    https://www.archlinux.org/releng/releases/           ####
#################################################################

# ======================================================================
#echo 'Автоматическое обнаружение ошибок.'
# Эта команда остановит выполнение сценария после сбоя команды и будет отправлен код ошибки:
#set -e
#set -e -u
set -e "\n${RED}Error: ${YELLOW}${*}${NC}"
# ---------------------------------------------------
# Если этот параметр '-e' задан, оболочка завершает работу, когда простая команда в списке команд завершается ненулевой (FALSE). Это не делается в ситуациях, когда код выхода уже проверен (if, while, until,||, &&)
# Встроенная команда set:
# https://www.sites.google.com/site/bashhackers/commands/set
# ====================================================
#####################################################
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

### Display error, cleanup and kill (Ошибка отображения, очистка и убийство)
_error() {
    echo -e "\n${RED}Error: ${YELLOW}${*}${NC}"
    _note "${MSG_ERROR}"
    sleep 1; _cleanup; _exit_msg; kill -9 $$
}

### Cleanup on keyboard interrupt (Очистка при прерывании работы клавиатуры)
_trap() {
trap '_error ${MSG_KEYBOARD}' 1 2 3 6
}
#trap "set -$-" RETURN; set +o nounset
# Или
#trap "set -${-//[is]}" RETURN; set +o nounset
#..., устраняя недействительные флаги и действительно решая эту проблему!

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

###################################################################
 
#####   Baner  #######
#_arch_fast_install_banner
set > old_vars.log

APPNAME="arch_fast_install"
VERSION="v1.6 LegasyBIOS Update"
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
Этот скрипт не задумывался, как обычный установочный с большим выбором DE, разметкой диска и т.д..
 Но в последствие! Эта концепция была пересмотрена, и в скрипт был добавлен выбор DE, разметка диска и т.д..
 И он не предназначен для новичков. Он предназначен для тех, кто ставил ArchLinux руками и понимает, что и для чего нужна каждая команда.  
Его цель - это моментальное разворачивание системы со всеми конфигами. Смысл в том, что все изменения Вы делаете предварительно в самом скрипте и получаете возможность быстрой установки ArchLinux с вашими личными настройками (при условии, что Вы его изменили под себя, в противном случае с моими настройками).${RED}

 ***************************** ВНИМАНИЕ! ***************************** 
${NC} 
Автор не несёт ответственности за любое нанесение вреда при использовании скрипта. 
Вы используйте его на свой страх и риск, или изменяйте под свои личные нужды."
}

# 
# *******************************************************************
# Терминальный Мануал Arch Wiki :
# Мы можем просмотреть какие файлы сейчас находятся катологе пользователя root
#ls -la
#less install.txt
# nano install.txt  
# ====================================================================
#
##### Краткая Справка по характеристике подключения к сети интернет ####
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
# Если Вы ведёте установку используя pppoe, то вам необходимо установить пакет: rp-pppoe
# Используйте для настройки программу pppoe-setup, для запуска — pppoe-start

# ====================================================================
#
#####   Подключение к сети (интернет) #######
# Подключиться к сети Ethernet (интернет) - подключите кабель.
# Wi-Fi - аутентификация в беспроводной сети с использованием iwctl.
# Настройте сетевое соединение:
# DHCP : динамический IP-адрес и назначение DNS-сервера (предоставляемые systemd-networkd и systemd-resolved ) должны работать "из коробки" для проводных и беспроводных сетевых интерфейсов.
# Статический IP-адрес: следуйте настройкам сети # Статический IP-адрес.
#
# *******************************************************************
# Команды по установке :
# archiso login: root (automatic login)

##### Важно! #####
# Если возникает ошибка /usr/bin/arch-chroot Argument list too long - (слишком длинный список аргументов /usr/bin/arch-chroot)
# Все это из за того что файлов больше чем допустимый лимит, проверить который можно командой:
echo -e "${RED}=> ${NC}Acceptable limit for the list of arguments..."
#echo -e "${RED}=> ${NC}Допустимый лимит (предел) списка аргументов..."
#echo 'Допустимый лимит (предел) списка аргументов...'
# Acceptable limit for the list of arguments...
getconf ARG_MAX

echo -e "${BLUE}:: ${NC}The determination of the final access rights"
#echo 'The determination of the final access rights'
# Определение окончательных прав доступа
# Для суперпользователя (root) umask по умолчанию равна 0022
umask     #umask 0022      # используется для определения конечных прав доступа

echo -e "${BLUE}:: ${NC}Install the Terminus font"
#echo 'Install the Terminus font'
# Установим шрифт Terminus
pacman -Sy terminus-font --noconfirm
#pacman -Syy terminus-font
# Доступные шрифты сохраняются в /usr/share/kbd/consolefonts/каталоге.
# Шрифты оканчивающиеся на .psfu или .psfu.gz, имеют встроенную карту перевода Unicode.
# Пакет kbd предоставляет инструменты для изменения шрифта виртуальной консоли и сопоставления шрифтов.
#ls /usr/share/kbd/consolefonts/   # посмотреть список консольных шрифтов
# Или так:
#cd /usr/share/kbd/consolefonts
#ls

echo ""
echo -e "${BLUE}:: ${NC}Setting up the Russian language, changing the console font to one that supports Cyrillic for ease of use" 
#echo 'Setting up the Russian language, changing the console font to one that supports Cyrillic for ease of use'
# Настроим русский язык, изменим консольный шрифт на тот, который поддерживает кириллицу для удобства работы
# curl -L ${baseurl}/lng/${sel} | sed '/^#/ d'
# ls /usr/share/kbd/keymaps/**/*.map.gz  # посмотреть список доступных раскладок
loadkeys ru
setfont cyr-sun16
#setfont ter-v16b
# Можно увеличить немного шрифт!
# Просмотреть и отредактировать файл archmy1l:
# Справка: Файл откроется через редактор <nano>, если нужно отредактировать двигаемся стрелочками вниз-вверх, и правим нужную вам строку. После чего Ctrl-O для сохранения жмём Enter, далее Ctrl-X. Или (Ctrl+X и Y и Enter).
#setfont ter-v20b  # Шрифт терминус и русская локаль
#setfont ter-v22b
#setfont ter-v24b
#setfont ter-v32b    # чтобы шрифт стал побольше

# Доступные макеты можно перечислить с помощью:
#ls /usr/share/kbd/keymaps/**/*.map.gz  # посмотреть список доступных раскладок
### ==== Engllish loadkeys =====
#loadkeys us
#setfont ter-v16b #pacman -S terminus-font --noconfirm
# -------------------------------------------------------------------
# Чтобы изменить макет, добавьте соответствующее имя файла в loadkeys , пропустив путь и расширение файла. Например, чтобы установить немецкую раскладку клавиатуры:
# loadkeys de-latin1
# Консольные шрифты находятся внутри /usr/share/kbd/consolefonts/и также могут быть установлены с помощью setfont. 
# ===================================================================
### ==== Engllish loadkeys =====
#loadkeys us
#setfont ter-v16b #pacman -S terminus-font --noconfirm
#pacman -Sy terminus-font
#pacman -Sy terminus-font --noconfirm
#cd /usr/share/kbd/consolefonts
#ls
#setfont sun12x22
#setfont ter-v32b   # чтобы шрифт стал побольше
# -----------------------------------------------------------------

#echo ""
echo -e "${CYAN}==> ${NC}Добавим русскую локаль в систему установки"
#echo 'Добавим русскую локаль в систему установки'
# Adding a Russian locale to the installation system
#cat /etc/locale.gen | grep ""#${locale}""
#sed -i "/#${locale}/s/^#//g" /etc/locale.gen
sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen
#nano /etc/locale.gen
# В файле /etc/locale.gen раскомментируйте (уберите # вначале) строку #ru_RU.UTF-8 UTF-8
echo -e "${BLUE}:: ${NC}Обновим текущую локаль системы"
#echo 'Обновим текущую локаль системы'
# Update the current system locale
locale-gen
# Мы ввели locale-gen для генерации тех самых локалей.

sleep 01
echo -e "${BLUE}:: ${NC}Указываем язык системы"
#echo 'Указываем язык системы'
# Specify the system language
#export LANG=${locale}
#echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf
export LANG=ru_RU.UTF-8
#export LANG=en_US.UTF-8
# --------------------------------------------------------------
# Эта команда сама пропишет в файлике locale.conf нужные нам параметры.
# Ну и конечно, раз это переменные окружения, то мы можем установить их временно в текущей сессии терминала
# При раскомментировании строки '#export ....', - Будьте Внимательными!
# Как назовёшь, так и поплывёшь...
# When you uncomment the string '#export....', Be Careful!
# As you name it, you will swim...
# ===============================================================
echo -e "${BLUE}:: ${NC}Проверяем, что все заявленные локали были созданы:"
#echo 'Проверяем, что все заявленные локали были созданы:'
# Checking that all the declared locales were created:
locale -a

echo ""
echo -e "${GREEN}=> ${NC}Убедитесь, что сетевой интерфейс указан и включен" 
#echo 'Убедитесь, что ваш сетевой интерфейс указан и включен'
#  Make sure that your network interface is specified and enabled
echo " Показать все ip адреса и их интерфейсы "
ip a
# Смотрим какие у нас есть интернет-интерфейсы
#ip link
# Если наш интерфейс wlan0. В скобках видно, что он UP. Исправляем:
#ip link set wlan0 down
# -----------------------------------------------------------------
# После этого можно спокойно вызывать wifi-menu и подключатся.
# (для проводных и беспроводных сетевых интерфейсов должны работать "из коробки")
# Также можно посмотреть командой:
#iw dev
# Для беспроводной связи убедитесь, что беспроводная карта не заблокирована с помощью: 
#rfkill 
# ------------------------------------------------------------------
######  Если нужен этот пункт - 'Раскомментируйте!' ##### 
#echo -e "${GREEN}=> ${NC}Let's look at your DNS servers in the etc/resolv.conf file" 
#echo 'Let's look at your DNS servers in the etc/resolv.conf file'
# Давайте посмотрим на ваши DNS-серверы в etc / resolv.файл conf   
#cat /etc/resolv.conf
########################################################

echo ""
echo -e "${GREEN}=> ${NC}Для проверки интернета можно пропинговать какой-либо сервис" 
#echo 'Для проверки интернета можно пропинговать какой-либо сервис'
# To check the Internet, you can ping a service
ping -c2 archlinux.org
# Например Яндекс или Google: 
#ping -c5 www.google.com
#ping -c5 ya.ru

echo -e "${CYAN}==> ${NC}Если пинг идёт едем дальше ... :)"
#echo 'Если пинг идёт едем дальше ... :)'
# If the ping goes we go further ... :)

#################################################################

### Display banner (Дисплей баннер)
_arch_fast_install_banner

sleep 02
echo ""
### Installing ArchLinux 
echo -e "${GREEN}==> ${NC}Вы готовы приступить к установке Arch Linux? "
#echo 'Вы готовы приступить к установке Arch Linux'
# Are you ready to start installing Arch Linux?
while
echo " Действия ввода, выполняется сразу после нажатия клавиши " 
    read -n1 -p " 
    1 - Да приступить,    0 - Нет отменить: " hello  # sends right after the keypress; # отправляет сразу после нажатия клавиши  
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - Да приступить, 0 - Нет отменить: " hello  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")  
    echo ''
    [[ "$hello" =~ [^10] ]]
do
    :
done
 if [[ $hello == 1 ]]; then
  clear
  echo ""
  echo " Добро пожаловать в установку Arch Linux "
  elif [[ $hello == 0 ]]; then
  echo " Вы отказались от установки Arch Linux" 
   exit   
fi

echo -e "${GREEN}
  <<< Начинается установка минимальной системы Arch Linux >>>
${NC}"
# The installation of the minimum Arch Linux system starts

echo -e "${BLUE}:: ${NC}Установка и настройка начата в $(date +%T)" 
#echo "Установка и настройка начата в $(date +%T)"
# Installation and configuration started in $(date +%T)

echo -e "${BLUE}:: ${NC}Синхронизация системных часов"  
#echo 'Синхронизация системных часов'
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

### Если ли вам нужен этот пункт в скрипте, то раскомментируйте ниже в меню все тройные решётки (###)

###echo ""
###echo -e "${YELLOW}==> ${NC}Обновить и добавить новые ключи?"
#echo 'Обновить и добавить новые ключи?'
# Update and add new keys?
###echo " Данный этап поможет вам избежать проблем с ключами Pacmаn, если Вы используете не свежий образ ArchLinux для установки! "
# This step will help you avoid problems with Pacman keys if you are not using a fresh ArchLinux image for installation!
###echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, можно пропустить запуск обновления ключей. "
# Be careful! If you are in doubt about your actions, you can skip running the key update.
###echo -e "${RED}==> ${BOLD}Примечание: - Иногда при запуске обновления ключей возникает ошибка, не переживайте просто перезапустите работу скрипта (sh -название скрипта-)${NC}"
###echo -e "${RED}==> ${BOLD}Примечание: - Лучше ПРОПУСТИТЕ этот пункт!"
# Note: - Sometimes when you start updating keys, an error occurs, do not worry, just restart the script (sh -script name-)
###echo ""
###while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - Да обновить, 0 - Нет пропустить: " x_key  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
###echo " Действия ввода, выполняется сразу после нажатия клавиши "
###    read -n1 -p " 
###    1 - Да обновить,    0 - Нет пропустить: " x_key  # sends right after the keypress; # отправляет сразу после нажатия клавиши
###    echo ''
###    [[ "$x_key" =~ [^10] ]]
###do
###    :
###done
### if [[ $x_key == 1 ]]; then
###  clear
  #pacman-key --init  #
  #pacman-key --populate archlinux  #
###  pacman-key --refresh-keys 
###  elif [[ $x_key == 0 ]]; then
###   echo " Обновление ключей пропущено "   
###fi
###clear   # Очистка экрана

echo ""
echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов" 
#echo 'Обновим базы данных пакетов'
# Updating the package databases
#echo "Обновление баз данных пакетов..."
pacman -Sy --noconfirm

echo ""
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

### Если ли надо раскомментируйте нужные вам значения
# -----------------------------------------------------
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
# ------------------------------------------------------------
# В наше время большинство блочных устройств Linux подключаются через интерфейс SCSI. Сюда входят жёсткие диски, USB-флешки, даже ATA-диски теперь тоже подключаются к SCSI через специальный переходник. Поэтому в большинстве случаев вы будете иметь дело именно с дисками sd.
# Жёсткие диски имеют особенные названия. В зависимости от интерфейса, через который подключён жёсткий диск, название может начинаться на:
# sd - устройство, подключённое по SCSI;
# hd - устройство ATA;
# vd - виртуальное устройство;
# mmcblk - обозначаются флешки, подключённые через картридер; 
# Самый простой способ увидеть все подключённые диски - это посмотреть содержимое каталога /dev/ и отфильтровать устройства sd:
#ls -l /dev/
# =================================================================

echo ""
echo -e "${BLUE}:: ${NC}Смотрим, какие диски есть в нашем распоряжении"
#echo 'Давайте посмотрим, какие диски у нас есть в нашем распоряжении'
# Let's see what drives we have at our disposal
lsblk -f
# Самый простой способ увидеть все подключённые диски - это посмотреть содержимое каталога /dev/ и отфильтровать устройства sd:
#ls -l /dev/
# =================================================================

echo ""
# Ещё раз проверте правильность разбивки на разделы!
echo -e "${BLUE}:: ${NC}Посмотрим структуру диска созданного установщиком"
#echo 'Посмотрим структуру диска созданного установщиком'
# Let's look at the disk structure created by the installer
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " => Укажите диск (sda/sdb например sda или sdb) : " cfd
sgdisk -p /dev/$cfd #sda sdb sdc sdd
#sgdisk -p /dev/sda #sdb sdc sdd

echo ""
echo -e "${RED}==> ${NC}Удалить (стереть) таблицу разделов на выбранном диске (sdX)?"
#echo 'Удалить (стереть) таблицу разделов на выбранном диске (sdX)?'
# Delete (erase) the partition table on the selected disk (sdX)?
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да удалить таблицу разделов ,    0 - Нет пропустить: " sgdisk  # sends right after the keypress; # отправляет сразу после нажатия клавиши 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - Да удалить таблицу разделов, 0 - Нет пропустить: " sgdisk  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
    echo ''
    [[ "$sgdisk" =~ [^10] ]]
do
    :
done
if [[ $sgdisk == 1 ]]; then
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "    
read -p " => Укажите диск (sda/sdb например sda или sdb) : " cfd
sgdisk --zap-all /dev/$cfd  #sda sdb sdc sdd
  echo " Создание новых записей GPT в памяти. "
  echo " Структуры данных GPT уничтожены! Теперь вы можете разбить диск на разделы с помощью fdisk или других утилит. " 
elif [[ $sgdisk == 0 ]]; then
  echo 'Операция пропущена.'
fi
# ---------------------------------------------------------------------------
# Для получения самой подробной информации обратитесь к справочной странице:
#man sgdisk
# ============================================================================

######  ВНИМАНИЕ! #######
# Скрипт затирает диск dev/sdX (First hard disk) в системе. Примечание для начинющих: 'Пожалуйста, не путайте с приоритетом загрузки устройств, и их последовательного отображения в Bios'. (Пожалуйста, не путайте! - это вчера мне было п#здато, а сегодня мне п#здец!). Поэтому если у Вас есть ценные данные на дисках сохраните их. 
# Если Вам нужна установка рядом с Windows, тогда Вам нужно предварительно изменить скрипт и разметить диски. В противном случае данные и Windows будут затерты.
# Если Вам не подходит автоматическая разметка дисков, тогда предварительно нужно сделать разметку дисков и настроить скрипт под свои нужды (Смотрите пометки в самом скрипте!)
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
# ---------------------------------------------------------
#####   "Справка команд по работе с утилитой fdisk"  ###
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
# ----------------------------------------------------------------
### https://linux-faq.ru/page/komanda-fdisk
### https://www.altlinux.org/Fdisk
# ================================================================

#clear
echo -e "${MAGENTA}
  <<< Вся разметка диска(ов) производится только в cfdisk! >>>
${NC}"
# The whole layout of the disk is made only in cfdisk!

#echo ""
echo -e "${YELLOW}:: ${BOLD}Здесь Вы также можете подготовить разделы для Windows (ntfs/fat32)(С;D;E), и в дальнейшем после разбиения диска(ов), их примонтировать. ${NC}"
# You can also prepare partitions for Windows (ntfs/fat32) (C; D;E), and then mount them after splitting the disk(s).
echo -e "${GREEN}==> ${NC}Создание разделов диска для установки ArchLinux"
#echo 'Создание разделов диска для установки ArchLinux'
# Creating disk partitions for installing ArchLinux
echo -e "${BLUE}:: ${NC}Вам нужна разметка диска?"
#echo 'Вам нужна разметка диска?'
# Do you need disk markup?
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да приступить к разметке,    0 - Нет пропустить разметку: " cfdisk  # файл устройство дискового накопителя;  # sends right after the keypress; # отправляет сразу после нажатия клавиши
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - Да приступить к разметке, 0 - Нет пропустить разметку: " cfdisk  # файл устройство дискового накопителя; # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
    echo ''
    [[ "$cfdisk" =~ [^10] ]]
do
    :
done
if [[ $cfdisk == 1 ]]; then
   clear
   echo ""
 echo -e "${BLUE}:: ${NC}Выбор диска для установки"  
 lsblk -f
  echo ""
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
  read -p " => Укажите диск (sda/sdb например sda или sdb) : " cfd
cfdisk /dev/$cfd
echo ""
clear
elif [[ $cfdisk == 0 ]]; then
  echo ' Разметка пропущена. '      
fi

# Ещё раз проверте правильность разбивки на разделы!
clear 
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
#lsblk -lo 
# ---------------------------------------------------------
# lsblk — выводит список всех блоков хранения информации, среди которых могут быть дисковые разделы и оптические приводы. Отображается такая информация как общий размер раздела/блока, точка монтирования (если таковая есть). Если нет точки монтирования, то это может значить что файловая система не смонтирована, для CD/DVD привода дисков это означает, что в лотке нету диска
#sfdisk -l -uM
# Sfdisk — отображает похожую информацию, так же как и FDISK, однако есть и некоторые особенности, к примеру, отображение размера каждого раздела в мегабайтах.
#parted -l
# parted — ещё одна утилита командной строки, которая умеет отображать список разделов, информацию о них, а так же позволяет вносить изменения в разделы при необходимости
# ================================================================

sleep 02
clear
echo ""
echo -e "${GREEN}==> ${NC}Форматирование разделов диска"
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
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите ROOT раздел (sda/sdb 1.2.3.4 (sda5 например)): " root  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo ""
mkfs.ext4 /dev/$root -L root
mount /dev/$root /mnt
#mount -v /dev/$root /mnt    # -v или --verbose Выводить сообщение о каждой создаваемой директории
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
echo " 2 - Пропустить если BOOT раздела нет на отдельном разделе, и он находится в корневом разделе ROOT "
while
# echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - Да форматировать, 0 - Нет пропустить: " boots  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да форматировать,    2 - Нет пропустить: " boots  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$boots" =~ [^12] ]]
do
    :
done 
if [[ $boots == 1 ]]; then
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "  
  read -p " Укажите BOOT раздел (sda/sdb 1.2.3.4 (sda7 например)): " bootd  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
  #mkfs.fat -F32 /dev/$bootd
  #mkfs.ext2  /dev/$bootd
  mkfs.ext2  /dev/$bootd -L boot
  mkdir /mnt/boot
#  mkdir -v /mnt/boot
  mount /dev/$bootd /mnt/boot
# mount -v /dev/$bootd /mnt/boot   # -v или --verbose Выводить сообщение о каждой создаваемой директории
elif [[ $boots == 2 ]]; then
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
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") " 
# read -p " 1 - Да, 0 - Нет: " swap  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да,    0 - Нет: " swap  # sends right after the keypress; # отправляет сразу после нажатия клавиши  
    echo ''
    [[ "$swap" =~ [^10] ]]
do
    :
done
if [[ $swap == 1 ]]; then
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "  
  read -p " Укажите swap раздел (sda/sdb 1.2.3.4 (sda7 например)): " swaps  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
  mkswap /dev/$swaps -L swap
  swapon /dev/$swaps
# swapon -v /dev/$swaps 
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
while
# echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -n1 -p " 1 - Да добавить Home раздел, 0 - Нет не добавлять: " homes  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да добавить Home раздел,    0 - Нет не добавлять: " homes  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$homes" =~ [^10] ]]
do
    :
done 
if [[ $homes == 0 ]]; then
  echo 'Добавление Home раздела пропущено.'
elif [[ $homes == 1 ]]; then
   echo ' Добавление домашнего раздела (HOME) '   
echo -e "${BLUE}:: ${NC}Форматируем Home раздел?"
#echo 'Форматирование домашнего раздела (HOME)'
# Formatting the home partition
while
# echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") " 
# read -p " 1 - Да форматировать, 0 - Нет не форматировать: " homeF  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да форматировать,    0 - Нет не форматировать: " homeF  # sends right after the keypress; # отправляет сразу после нажатия клавиши 
    echo ''
    [[ "$homeF" =~ [^10] ]]
do
    :
done 
   if [[ $homeF == 1 ]]; then
   echo ""
   lsblk -f
   echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
   read -p " Укажите HOME раздел (sda/sdb 1.2.3.4 (sda6 например)): " home  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
   mkfs.ext4 /dev/$home -L home
   mkdir /mnt/home
#  mkdir -v /mnt/home
   mount /dev/$home /mnt/home
#  mount -v /dev/$home /mnt/home # -v или --verbose Выводить сообщение о каждой создаваемой директории
   elif [[ $homeF == 0 ]]; then
 lsblk -f
 echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
 read -p " Укажите HOME раздел (sda/sdb 1.2.3.4 (sda6 например)): " homeV  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
 mkdir /mnt/home 
#mkdir -v /mnt/home  
 mount /dev/$homeV /mnt/home
#mount -v /dev/$homeV /mnt/home  # -v или --verbose Выводить сообщение о каждой создаваемой директории
fi
fi
sleep 02
# -----------------------------------------------------------------
# Посмотреть что мы намонтировали можно командой:
#mount | grep sda    
# - покажет куда был примонтирован sda
# ===================================================================

clear
echo -e "${CYAN}
  <<< Добавление (монтирование) разделов Windows (ntfs/fat32) >>>
${NC}"
# Adding (mounting) Windows partitions (ntfs/fat32)
echo -e "${GREEN}==> ${NC}Добавим разделы для Windows (ntfs/fat32)?"
#echo 'Добавим разделы для Windows (ntfs/fat32)?'
# Adding partitions for Windows (ntfs/fat32)?
echo -e "${MAGENTA}=> ${BOLD}Если таковые были созданы во время разбиения вашего диска(ов) на разделы cfdisk! ${NC}"
# If any were created while partitioning your disk to cfdisk partitions!
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - Да добавим разделы, , 0 - Нет пропустить этот шаг: " wind  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши " 
    read -n1 -p  "
    1 - Да добавим разделы,    0 - Нет пропустить этот шаг: " wind  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$wind" =~ [^10] ]]
do
    :
done
if [[ $wind == 0 ]]; then
  echo ' Действие пропущено '
  elif [[ $wind == 1 ]]; then    
  echo " ### Приступим к добавлению разделов Windows ### "
############### Disk C ##############
echo ""
echo -e "${BLUE}:: ${NC}Добавим раздел диск "C"(Local Disk) Windows?"
#echo " Добавим раздел диск "C"(Local Disk) Windows? "
# Adding the "C"(Local Disk) Windows partition?
echo " Если таковой был создан при разметке в cfdisk "
#Если он был создан во время разметки в cfdisk'
# If one was created during markup in cfdisk
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - Да добавим раздел, , 0 - Нет пропустить: " diskC  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши " 
    read -n1 -p  "
    1 - Да добавим раздел,    0 - Нет пропустить: " diskC  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$diskC" =~ [^10] ]]
do
    :
done
if [[ $diskC == 0 ]]; then
  echo ' Действие пропущено '
  elif [[ $diskC == 1 ]]; then
   clear
 lsblk -f
  echo ""
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
  read -p " Укажите диск "C" раздел(sda/sdb 1.2.3.4 (sda4 например) ) : " diskCc
  mkdir /mnt/C 
  mount /dev/$diskCc /mnt/C
  fi

############### Disk D ##############
echo ""
echo -e "${BLUE}:: ${NC}Добавим раздел диск "D"(Data Disk) Windows?"
#echo " Добавим раздел диск "D"(Data Disk) Windows? "
# Adding the "D"(Data Disk) Windows partition?
echo " Если таковой был создан при разметке в cfdisk "
#Если он был создан во время разметки в cfdisk'
# If one was created during markup in cfdisk
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - Да добавим раздел, , 0 - Нет пропустить: " diskD  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши " 
    read -n1 -p  "
    1 - Да добавим раздел,    0 - Нет пропустить: " diskD  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$diskD" =~ [^10] ]]
do
    :
done
if [[ $diskD == 0 ]]; then
  echo ' Действие пропущено '
 elif [[ $diskD == 1 ]]; then
   clear
 lsblk -f
  echo ""
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
  read -p " Укажите диск "D" раздел(sda/sdb 1.2.3.4 (sda5 например)) : " diskDd
  mkdir /mnt/D 
  mount /dev/$diskDd /mnt/D
  fi

###### disk E ########
echo ""
echo -e "${BLUE}:: ${NC}Добавим раздел диск "E"(Work Disk) Windows?"
#echo " Добавим раздел диск "E"(Work Disk) Windows? "
# Adding the "E"(Work Disk) Windows partition?
echo " Если таковой был создан при разметке в cfdisk "
#Если он был создан во время разметки в cfdisk'
# If one was created during markup in cfdisk
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - Да добавим раздел, , 0 - Нет пропустить: " diskE  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши " 
    read -n1 -p  "
    1 - Да добавим раздел,    0 - Нет пропустить: " diskE  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$diskE" =~ [^10] ]]
do
    :
done
 if [[ $diskE == 1 ]]; then
   clear
 lsblk -f
  echo ""
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
  read -p " Укажите диск "E" раздел(sda/sdb 1.2.3.4 (sda5 например)) : " diskDe
  mkdir /mnt/E 
  mount /dev/$diskDe /mnt/E
  elif [[ $diskE == 0 ]]; then
  echo ' Действие пропущено '
  fi 
  fi
##### Windows partitions #####

echo ""
echo -e "${BLUE}:: ${NC}Просмотреть подключённые диски с выводом информации о размере и свободном пространстве"
#echo 'Просмотреть подключённые диски с выводом информации о размере и свободном пространстве'
# View attached disks with information about size and free space
df -h
#df -hT
# ------------------------------------------------------------------
# DF — не является утилитой для разметки разделов, скорее больше для просмотра информации. Можно отметить то, что утилита DF способна вывести информацию о файловых системах, которые даже не являются реальными разделами диска.
#pydf
# Pydf — является в неком роде улучшением версии DF, которая написана на Python. Способна выводить информацию о всех разделах жесткого диска в удобном виде. Но есть и минусы, показываются только смонтированные файловые системы.
# ====================================================================

echo ""
echo -e "${BLUE}:: ${NC}Просмотреть все идентификаторы наших разделов"
#echo 'Просмотреть все идентификаторы наших разделов'
# View all IDs of our sections
blkid
# --------------------------------------------------------------------
# BLKID — выводит информацию о разделах файловой системы, среди них такие атрибуты как UUID, а так же тип файловой системы. Однако эта утилита не сообщает о дисковом пространстве на разделах.
# ====================================================================

echo ""
echo -e "${BLUE}:: ${NC}Просмотреть информацию об использовании памяти в системе"
#echo 'Просмотреть информацию об использовании памяти в системе'
# View information about memory usage in the system
free -h
# Команда проверяет объем используемой и свободной оперативной памяти, имеющейся в системе:
#free -m
# -------------------------------------------------------------------
# Команда free в Linux с примерами:
# https://andreyex.ru/operacionnaya-sistema-linux/komanda-free-v-linux-s-primerami/
# ============================================================================
sleep 02

echo ""
echo -e "${BLUE}:: ${NC}Посмотреть содержмое каталога /mnt."
#echo 'Посмотреть содержмое каталога /mnt.'
# View the contents of the /mnt folder.
ls /mnt
#ls -l /mnt

### Замена исходного mirrorlist (зеркал для загрузки) на мой список серверов-зеркал
#echo 'Замена исходного mirrorlist (зеркал для загрузки)'
#Ставим зеркало от Яндекс
# Удалим старый файл /etc/pacman.d/mirrorlist
#rm -rf /etc/pacman.d/mirrorlist
# Загрузка нового файла mirrorlis (список серверов-зеркал)
#pacman -S wget --noconfirm
#wget https://raw.githubusercontent.com/MarcMilany/arch_2020/master/Mirrorlist/mirrorlist
# Переместим нового файла mirrorlist в /etc/pacman.d/mirrorlist
#mv -f ~/mirrorlist /etc/pacman.d/mirrorlist
#echo "Обновление баз данных пакетов..."
#sudo pacman -Sy
# -------------------------------------------------------------

echo ""
echo -e "${BLUE}:: ${NC}Выбор серверов-зеркал для загрузки. Ставим зеркало от Яндекс"
#echo 'Выбор серверов-зеркал для загрузки. Ставим зеркало от Яндекс'
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

# -----------------------------------------------------------------
# Pacman Mirrorlist Generator
# https://www.archlinux.org/mirrorlist/
# Эта страница генерирует самый последний список зеркал, возможный для Arch Linux. Используемые здесь данные поступают непосредственно из внутренней базы данных зеркал разработчиков, используемой для отслеживания доступности и уровня зеркалирования. 
# Есть два основных варианта: получить список зеркал с каждым доступным зеркалом или получить список зеркал, адаптированный к вашей географии.
# Получение и ранжирование свежего списка зеркал
# Воспользуйтесь Pacman Mirrorlist Generator, чтобы получить список актуальных зеркал определённых стран и отсортировать его с помощью rankmirrors. Команда ниже скачивает актуальный список зеркал во Франции и Великобритании, использующих протокол https, после чего удаляет комментарии, ранжирует сервера и выводит 5 наиболее быстрых из них.
#
#curl -s "https://www.archlinux.org/mirrorlist/?country=FR&country=GB&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 -
#
# Команда ниже скачивает актуальный список зеркал в России, использующих протокол https, после чего удаляет комментарии, ранжирует сервера и выводит 5 наиболее быстрых из них.
# 
#curl -s "https://www.archlinux.org/mirrorlist/?country=RU&country&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 -
#
# https://wiki.archlinux.org/index.php/Mirrors_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# ================================================================

echo -e "${BLUE}:: ${NC}Создание (backup) резервного списка зеркал mirrorlist - (mirrorlist.backup)"
#echo 'Создание (backup) резервного списка зеркал mirrorlist - (mirrorlist.backup)'
# Creating a backup list of mirrors mirrorlist - (mirrorlist.backup)
cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

echo -e "${BLUE}:: ${NC}Посмотреть список серверов-зеркал для загрузки в mirrorlist"
#echo 'Посмотреть список серверов-зеркал для загрузки в mirrorlist'
# View the list of mirror servers to upload to mirrorlist
cat /etc/pacman.d/mirrorlist

echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов" 
#echo 'Обновим базы данных пакетов'
# Updating the package databases
sudo pacman -Sy 
# ------------------------------------------------------
# Знакомьтесь, pacman - лучший пакетный менеджер в мире линукса!
#pacman -Syy   - обновление баз пакмэна (как apt-get update в дэбианоподбных)
#pacman -Syyu  - обновление баз плюс обновление пакетов
# ---------------------------------------------------------
### Если возникли проблемы с обновлением, или установкой пакетов ##
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
# ===========================================================

### Install Base System
clear
echo ""
echo -e "${GREEN}==> ${NC}Установка основных пакетов (base base-devel) базовой системы"
#echo 'Установка основных пакетов (base base-devel) базовой системы'
# Installing basic packages (base base-devel)
echo -e "${BLUE}:: ${NC}Arch Linux, Base devel (AUR only)"
#echo 'Arch Linux, Base devel (AUR only)'
echo " Сценарий pacstrap устанавливает (base) базовую систему. Для сборки пакетов из AUR (Arch User Repository) также требуется группа base-devel. "
# The pacstrap script installs the base system. To build packages from AUR (Arch User Repository), the base-devel group is also required.
echo " Т.е., Если нужен AUR, ставь base и base-devel, если нет, то ставь только base. "
# If you need AUR, put base and base-devel, if not, then put only base.
echo " Огласите весь список, пожалуйста! "
# Read out the entire list, please!
echo " 1 - base + base-devel + packages (пакеты небходимые для сетевых настроек, и консольный текстовый редактор: - dhcpcd netctl which inetutils nano vim ) "  #wget
echo " 2 - base + packages (пакеты небходимые для сетевых настроек, и консольный текстовый редактор: - dhcpcd netctl which inetutils nano vim) "   #wget
echo " 3 - base + base-devel (установятся группы, Т.е. base и base-devel, без каких либо дополнительных пакетов) "
echo " 4 - base (установится группа, состоящая из определённого количества пакетов, Т.е. просто base, без каких либо дополнительных пакетов) "
echo " Будьте осторожны! Если Вы сомневаетесь в своих действиях, можно установить (base + packages), а group-(группы) base-devel установить позже. "
# Be careful! If you doubt your actions, you can install (base + packages), group base-devel later.
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления" 
#echo 'Установка производится в порядке перечисления'
# Installation Is performed in the order listed
echo " Чтобы исключить ошибки в работе системы рекомендую пункт "1" "
# To eliminate errors in the system, I recommend "1"
echo ""
while
# echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "    
# read -p " 1 - Base + Base-Devel + packages, 2 - Base + packages, 3 - Base + Base-Devel, 4 - Base: " x_pacstrap  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "    
    1 - Base + Base-Devel + packages,   2 - Base + packages, 

    3 - Base + Base-Devel,              4 - Base: " x_pacstrap  # sends right after the keypress; # отправляет сразу после нажатия клавиши 
    echo ''
    [[ "$x_pacstrap" =~ [^1234] ]]
do
    :
done
 if [[ $x_pacstrap == 1 ]]; then
  clear
  echo ""
  echo " Установка выбранного вами, групп "
  pacstrap /mnt base base-devel nano vim dhcpcd netctl which inetutils  #wget 
#  pacstrap /mnt base            #--noconfirm --noprogressbar --quiet
#  pacstrap /mnt base-devel      #--noconfirm
#  pacstrap /mnt --needed base-devel
#  pacstrap /mnt nano vim dhcpcd netctl which inetutils #wget
elif [[ $x_pacstrap == 2 ]]; then
  clear
  echo ""
  echo " Установка выбранного вами, группы "
  pacstrap /mnt base nano vim dhcpcd netctl which inetutils #wget
#  pacstrap /mnt base
#  pacstrap /mnt nano vim dhcpcd netctl which inetutils #wget
elif [[ $x_pacstrap == 3 ]]; then
  clear
  echo ""
  echo " Установка выбранных вами групп "
  pacstrap /mnt base base base-devel
#  pacstrap /mnt base  
#  pacstrap /mnt base-devel
#  pacstrap /mnt --needed base-devel   
elif [[ $x_pacstrap == 4 ]]; then
  clear
  echo ""
  echo " Установка выбранной вами группы "
  pacstrap /mnt base 
fi 
 clear
echo ""

# ----------------------------------------------------------------
# В официальном wiki от arch https://wiki.archlinux.org/index.php/Installation_guide ,
# написано pacstrap /mnt base, советую тут повторить за мной, ибо если Вам нужен доступ к AUR (Arch User Repository) Вам надо будет base-devel (есть возможность поставить когда угодно).
# Основные элементы уже у Вас на жестком диске, теперь надо сделать чтобы оно всё запускалось и работало.
# ==========================================================

#####        "Справка утилит"   ######
# base - основные программы.
# base-devel - утилиты для разработчиков. Нужны для AUR.
# linux - ядро.
# linux-firmware - файлы прошивок для linux.
# linux-headers-[версия] - заголовочные файлы ядра: linux-headers-$(uname -r).
# linux-image-[версия] – бинарный образ ядра.
# -----------------------------------------------------------
# linux-extra-[версия] – дополнительные внешние модули ядра для расширения функционала.
# nano - простой консольный текстовый редактор. Если умете работать в vim, то можете поставить его вместо nano.
# vim -  - это настраиваемый текстовый редактор.
# ------------------------------------------------------------
# grub - загрузчик операционной системы. Без него даже загрузиться в новую систему не сможем.
# efibootmgr - поможет grub установить себя в загрузку UEFI.
# sudo - позволяет обычным пользователем совершать действия от лица суперпользователя.
# git - приложение для работы с репозиториями Git. Нужен для AUR и много чего ещё.
# networkmanager - сервис для работы интернета. Вместе с собой устанавливает программы для настройки.
# wget linux - утилита выполняет загрузку файлов даже в фоновом режиме - без участия пользователя
# libnewt - Not Erik's Windowing Toolkit - оконный режим в текстовом режиме со сленгом
# ---------------------------------------------------------------
# man-db - просмотрщик man-страниц.
# man-pages - куча man-страниц (руководств).
# ==========================================================

### Install Kernel
#### Kernel (optional) - (Kernel (arbitrary) #####
#clear
#echo ""
echo -e "${GREEN}==> ${NC}Какое ядро (Kernel) Вы бы предпочли установить вместе с системой Arch Linux?"
#echo 'Какое ядро (Kernel) Вы бы предпочли установить вместе с системой Arch Linux?'
# Which kernel) Would you prefer to install with the Arch Linux system?
echo -e "${BLUE}:: ${NC}Kernel (optional), Firmware"
#echo 'Kernel (optional), Firmware'
echo " Дистрибутив Arch Linux основан на ядре Linux. Помимо основной стабильной (stable) версии в Arch Linux можно использовать некоторые альтернативные ядра. "
# The ArchLinux distribution is based on the Linux kernel. In addition to the main stable version, some alternative kernels can be used in Arch Linux.
echo " Т.е. выбрать-то можно, но тут главное не пропустить установку ядра :). "
# You can choose something, but the main thing is not to skip the installation of the core :).
echo " Огласите весь список, пожалуйста! "
# Read out the entire list, please!
echo " 1 - linux (Stable - ядро Linux с модулями и некоторыми патчами, поставляемое вместе с Rolling Release устанавливаемой системы Arch) "
echo " 2 - linux-hardened (Ядро Hardened - ориентированная на безопасность версия с набором патчей, защищающих от эксплойтов ядра и пространства пользователя. Внедрение защитных возможностей в этом ядре происходит быстрее, чем в linux) "
echo " 3 - linux-lts (Версия ядра и модулей с долгосрочной поддержкой - Long Term Support, LTS) "
echo " 4 - linux-zen (Результат коллективных усилий исследователей с целью создать лучшее из возможных ядер Linux для систем общего назначения.) "
echo " Будьте осторожны! Если Вы сомневаетесь в своих действиях, можно установить (linux Stable) ядро поставляемое вместе с Rolling Release. "
# Be careful! If you doubt your actions, you can install (linux Stable) the core supplied with the Rolling Release.
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления" 
#echo 'Установка производится в порядке перечисления'
# Installation Is performed in the order listed
echo ""
while
# echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - LINUX, 2 - LINUX_HARDENED, 3 - LINUX_LTS, 4 - LINUX_ZEN: " x_pacstrap  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - LINUX,           2 - LINUX_HARDENED,

    3 - LINUX_LTS,       4 - LINUX_ZEN: " x_pacstrap  # sends right after the keypress; # отправляет сразу после нажатия клавиши  
    echo ''
    [[ "$x_pacstrap" =~ [^1234] ]]
do
    :
done  
 if [[ $x_pacstrap == 1 ]]; then
  clear
  echo ""
 echo " Установка выбранного вами ядра (Kernel linux) "
 pacstrap /mnt linux linux-firmware # linux-headers
  echo " Ядро (Kernel) операционной системы установленно "
# echo " Настройка системы, генерируем fstab "
#  genfstab -pU /mnt >> /mnt/etc/fstab  
elif [[ $x_pacstrap == 2 ]]; then
  clear
  echo ""
  echo " Установка выбранного вами ядра (Kernel linux-hardened) "
  pacstrap /mnt linux-hardened linux-firmware 
  echo " Ядро (Kernel) операционной системы установленно "
# echo " Настройка системы, генерируем fstab "
#  genfstab -pU /mnt >> /mnt/etc/fstab   
elif [[ $x_pacstrap == 3 ]]; then
  clear
  echo ""
  echo " Установка выбранного вами ядра (Kernel linux-lts) "
  pacstrap /mnt linux-lts linux-firmware 
  echo " Ядро (Kernel) операционной системы установленно "
# echo " Настройка системы, генерируем fstab "
#  genfstab -pU /mnt >> /mnt/etc/fstab  
elif [[ $x_pacstrap == 4 ]]; then
  clear
  echo ""
  echo " Установка выбранного вами ядра (Kernel linux-zen) " 
  pacstrap /mnt linux-zen linux-firmware 
  echo " Ядро (Kernel) операционной системы установленно "
# echo " Настройка системы, генерируем fstab "
#  genfstab -pU /mnt >> /mnt/etc/fstab  
fi
clear
echo ""
# ------------------------------------------------------------------
# Kernel (Русский)
# https://wiki.archlinux.org/index.php/Kernel_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# ------------------------------------------------------------------

### Set Fstab
echo ""
echo -e "${GREEN}==> ${NC}Настройка системы, генерируем fstab" 
#echo 'Настройка системы, генерируем fstab'
# Configuring the system, generating fstab
echo " Файл /etc/fstab используется для настройки параметров монтирования различных блочных устройств, разделов на диске и удаленных файловых систем. "
# The /etc/fstab file is used to configure mounting parameters for various block devices, disk partitions, and remote file systems.
echo " Таким образом, и локальные, и удаленные файловые системы, указанные в /etc/fstab, будут правильно смонтированы без дополнительной настройки. "
# This way, both local and remote file systems specified in /etc/fstab will be correctly mounted without any additional configuration.
echo " Существует четыре различных схемы для постоянного именования: по метке , по uuid , по id и по пути . Для тех, кто использует диски с таблицей разделов GUID (GPT) , могут использоваться две дополнительные схемы : -Partlabel и -Parduuid . Вы также можете использовать статические имена устройств с помощью Udev. "
# There are four different schemes for permanent naming: by label , by uuid, by id, and by path . For those who use disks with a GUID partition table (GPT) , two additional schemes can be used : -part label and-Parduuid . You can also use static device names using Udev.
echo " Огласите весь список, пожалуйста! "
# Read out the entire list, please!
echo " 1 - По-UUID ("UUID" "genfstab -U"). "
echo " 2 - По меткам ("LABEL" "genfstab -L"). "
echo " 3 - По меткам GPT ("PARTLABEL" "genfstab -t PARTLABEL"). "
echo " 4 - По UUID GPT ("PARTUUID" "genfstab -t PARTUUID"). "
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз взгляните на разметку вашего диска, и таблицу разделов (MBR или GPT). "
# Be careful! If you doubt your actions, take another look at your disk layout and partition table (MBR or GPT).
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления" 
#echo 'Установка производится в порядке перечисления'
# Installation Is performed in the order listed
echo " Чтобы исключить ошибки в работе системы рекомендую "1" "
# To eliminate errors in the system, I recommend "1"
echo " Преимущество использования метода UUID состоит в том, что вероятность столкновения имен намного меньше, чем с метками. Далее он генерируется автоматически при создании файловой системы. "
# The advantage of using the UUID method is that the probability of names colliding is much less than with placemarks. It is then generated automatically when the file system is created.
echo ""
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - UUID genfstab -U, 2 - LABEL genfstab -L, 3 - PARTLABEL genfstab -t PARTLABEL, 4 - PARTUUID genfstab -t PARTUUID: " x_fstab  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")            
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "    
    1 - UUID genfstab -U,                 2 - LABEL genfstab -L,
            
    3 - PARTLABEL genfstab -t PARTLABEL,  

    4 - PARTUUID genfstab -t PARTUUID: " x_fstab  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
    echo ''
    [[ "$x_fstab" =~ [^1234] ]]
do
    :
done   
 if [[ $x_fstab == 1 ]]; then
  clear
  echo ""
  echo " Генерируем fstab выбранным вами методом "
  echo " UUID - genfstab -U -p /mnt > /mnt/etc/fstab "
  genfstab -pU /mnt >> /mnt/etc/fstab
#genfstab -U -p /mnt >> /mnt/etc/fstab
#genfstab -U / mnt >> / mnt / etc / fstab
# echo " Просмотреть содержимое файла fstab "
# cat /mnt/etc/fstab
#cat < /mnt/etc/fstab | grep -v "Static information"
echo " Проверьте полученный /mnt/etc/fstab файл и отредактируйте его в случае ошибок. " 
elif [[ $x_fstab == 2 ]]; then
  clear
  echo ""
  echo " Генерируем fstab выбранным вами методом "
  echo " LABEL - genfstab -L -p /mnt > /mnt/etc/fstab "
#genfstab -pL /mnt > /mnt/etc/fstab
#genfstab -L -p /mnt > /mnt/etc/fstab
# echo " Просмотреть содержимое файла fstab "
# cat /mnt/etc/fstab
echo " Проверьте полученный /mnt/etc/fstab файл и отредактируйте его в случае ошибок. "
elif [[ $x_fstab == 3 ]]; then
  clear
  echo ""
  echo " Генерируем fstab выбранным вами методом "
  echo " PARTLABEL - genfstab -t PARTLABEL -p /mnt > /mnt/etc/fstab "
#genfstab -t PARTLABEL -p /mnt > /mnt/etc/fstab
# echo " Просмотреть содержимое файла fstab "
# cat /mnt/etc/fstab
echo " Проверьте полученный /mnt/etc/fstab файл и отредактируйте его в случае ошибок. "   
elif [[ $x_fstab == 4 ]]; then
  clear
  echo ""
  echo " Генерируем fstab выбранным вами методом "
  echo " PARTUUID - genfstab -t PARTUUID -p /mnt > /mnt/etc/fstab "
#genfstab -t PARTUUID -p /mnt > /mnt/etc/fstab
# echo " Просмотреть содержимое файла fstab "
# cat /mnt/etc/fstab
echo " Проверьте полученный /mnt/etc/fstab файл и отредактируйте его в случае ошибок. "
fi 
# clear
#echo ""
# ----------------------------------------------------------------
#(или genfstab -L /mnt >> /mnt/etc/fstab)
#genfstab -p -L /mnt > /mnt/etc/fstab
# -----------------------------------------------------------------
# Нашёл ещё две команды для генерации fstab при установке:
#genfstab -U -p /mnt >> /mnt/etc/fstab
#genfstab /mnt >> /mnt/etc/fstab
# Обе из них генерируют UUID хотя во второй команде этого ключа нет
# Почему это так происходит ?
# С ключом -U генерирует UUID без него раздел будет вида /dev/sda1 или что то в этом роде.
# Учтите, что когда пишется >> то Вы добавляете в файл, а не переписываешь его с нуля.
# То есть, если Вы вбивали два раза команды что написаны выше, то у Вас может в этом файле быть прописано монтирование одного и того же раздела в двух разных вариантах что чревато.
# Команда genfstab -h может сказать многое в том числе для чего нужно -p. Исключает монтирование псевдо файловые системы. Ключик можно не использовать, ибо используется по дефолту.
# Просмотреть все идентификаторы наших разделов можно командой: blkid или lsblk -f
# ------------------------------------------------------------------
# *****************************************************************
# echo " 1 - По-UUID ("UUID" "genfstab -U"). UUID - это механизм, который присваивает каждой файловой системе уникальный идентификатор. Эти идентификаторы генерируются утилитами файловой системы (например mkfs.*), когда устройство отформатировано и спроектированы таким образом, что конфликты маловероятны. Все файловые системы GNU / Linux (включая заголовки swap и LUKS необработанных зашифрованных устройств) поддерживают UUID. Файловые системы FAT, exFAT и NTFS не поддерживают UUID. "
# echo " 2 - По меткам ("LABEL" "genfstab -L"). Большинство файловых систем поддерживают установку метки при создании файловой системы, соответствующей mkfs.*утилиты. Для некоторых файловых систем также возможно изменить метки. "
# echo " 3 - По меткам GPT ("PARTLABEL" "genfstab -t PARTLABEL"). Этот метод относится только к дискам с таблицей разделов GUID (GPT). Метки разделов GPT можно определить в заголовке записи раздела на GPT-дисках. Метод очень похож на метки файловой системы (by-label), за исключением того, что метки раздела не будут затронуты, если файловая система в разделе будет изменена. "
# echo " 4 - По UUID GPT ("PARTUUID" "genfstab -t PARTUUID"). Как и метки разделов GPT , идентификаторы UUID разделов GPT определяются в записи разделов на дисках GPT. MBR не поддерживает UUID разделов, но Linux и программное обеспечение, использующее libblkid способны генерировать псевдо PARTUUID для разделов MBR. В отличие от обычного PARTUUID раздела GPT, псевдо PARTUUID MBR может меняться при изменении номера раздела. "
# ******************************************************************
# -------------------------------------------------------------------
# Installation guide (Русский): fstab (Русский)
# https://wiki.archlinux.org/index.php/Fstab_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# https://wiki.archlinux.org/index.php/Persistent_block_device_naming#by-uuid
# ====================================================================

### Set Fstab
echo ""
echo -e "${BLUE}:: ${NC}Просмотреть содержимое файла fstab"
#echo 'Просмотреть содержимое файла fstab'
# View the contents of the fstab file
cat /mnt/etc/fstab
#cat < /mnt/etc/fstab | grep -v "Static information"
# --------------------------------------------------------------------
# Был создан файл содержащий данные о монтируемых файловых системах.
# Чтобы система знала какие разделы монтировать при старте.
# ====================================================================

sleep 01   # или sleep 02
clear
echo ""
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
# -------------------------------------------------------------------
#
#clear
echo ""
echo -e "${GREEN}==> ${NC}Сменить зеркала для увеличения скорости загрузки пакетов?" 
#echo 'Сменить зеркала для увеличения скорости загрузки пакетов?'
# Change mirrors to increase the download speed of packages?
echo -e "${BLUE}:: ${NC}Загрузка свежего списка зеркал со страницы Mirror Status, и обновление файла mirrorlist."
#echo 'Загрузка свежего списка зеркал со страницы Mirror Status, и обновление файла mirrorlist.'
# Loading a fresh list of mirrors from the Mirror Status page, and updating the mirrorlist file.
# Устанавливаем и запускаем скрипт - Reflector.
# Install and run the reflector script.
echo " Если Вы перед запуском скрипта просмотрели его, то может возникнуть резонный вопрос зачем вновь менять список зеркал и обновлять файл mirrorlist, ведь перед установкой основной системы (base base-devel kernel) эта операция уже была выполнена. Это связано с тем что, начиная с релиза Arch Linux 2020.07.01-x86_64.iso в установочный образ был добавлен reflector. Тем самым во время установки основной системы происходит запуск скрипта - reflector, и обновляется ранее прописанный список зеркал в mirrorlist. Вам будет представлено несколько вариантов смены зеркал для увеличения скорости загрузки пакетов. "
# If you looked at the script before running it, you may have a reasonable question why change the list of mirrors again and update the mirrorlist file, because this operation was already performed before installing the main system (base base-devel kernel). This is because, since the release of Arch Linux 2020.07.01-x86_64.iso a reflector was added to the installation image. Thus, during the installation of the main system, the reflector script is launched, and the previously registered list of mirrors in the mirrorlist is updated. You will be presented with several options for changing mirrors to increase the speed of loading packages.
echo " Огласите весь список, пожалуйста! "
# Read out the entire list, please!
echo " 1 - Команда отфильтрует зеркала для 'Russia' по протоколам (https,http), отсортирует их по скорости загрузки и обновит файл mirrorlist. "
echo " 2 - Команда подробно выведет список 50 наиболее недавно обновленных HTTP-зеркал, отсортирует их по скорости загрузки и обновит файл mirrorlist. "
echo " 3 - То же, что и в предыдущем примере, но будут взяты только зеркала, расположенные в Казахстане (Kazakhstan). "
echo " 4 - Команда отфильтрует зеркала для 'Russia', 'Belarus', 'Ukraine',' и 'Poland' по протоколам (https,http), отсортирует их по скорости загрузки и обновит файл mirrorlist. "
echo " Будьте внимательны! Не переживайте, перед обновлением зеркал будет сделана копия (backup) предыдущего файла mirrorlist, и в последствии будет сделана копия (backup) нового файла mirrorlist. Эти копии (backup) Вы сможете найти в установленной системе в /etc/pacman.d/mirrorlist - (новый список) , и в /etc/pacman.d/mirrorlist.backup (старый список). В любой ситуации выбор всегда остаётся за вами. "
# Be careful! Don't worry, before updating mirrors, a copy (backup) of the previous mirrorlist file will be made, and later a copy (backup) of the new mirrorlist file will be made. These copies (backup) You can find it in the installed system in /etc/pacman.d/mirrorlist - (new list), and in /etc/pacman.d/mirrorlist.backup (the old list). In any situation, the choice is always yours.
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления" 
#echo 'Установка производится в порядке перечисления'
# Installation Is performed in the order listed
echo " Если Вы находитесь в России рекомендую выбрать вариант "1" "
# To eliminate errors in the system, I recommend "1"
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Russia (https,http), 2 - 50 HTTP-зеркал, 3 - Kazakhstan (http), 4 - Russia, Belarus, Ukraine, Poland (https,http), 0 - Пропустить обновление зеркал: " zerkala  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Russia (https,http),     2 - 50 HTTP-зеркал,

    3 - Kazakhstan (http),       4 - Russia, Belarus, Ukraine, Poland (https,http), 

    0 - Пропустить обновление зеркал: " zerkala  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$zerkala" =~ [^12340] ]]
do
    :
done 
 if [[ $zerkala == 1 ]]; then
  echo ""  
  echo " Загрузка свежего списка зеркал со страницы Mirror Status "
pacman -S reflector --noconfirm
#pacman -Sy --noconfirm --noprogressbar --quiet reflector
reflector --verbose --country 'Russia' -l 7 -p https -p http -n 7 --save /etc/pacman.d/mirrorlist --sort rate  
#reflector --verbose --country 'Russia' -l 7 -p https -p http -n 7 --sort rate --save /etc/pacman.d/mirrorlist
elif [[ $zerkala == 2 ]]; then
  echo ""  
  echo " Загрузка свежего списка зеркал со страницы Mirror Status "
pacman -S reflector --noconfirm
#pacman -Sy --noconfirm --noprogressbar --quiet reflector
reflector --verbose -l 50 -p http --sort rate --save /etc/pacman.d/mirrorlist
reflector --verbose -l 15 --sort rate --save /etc/pacman.d/mirrorlist
elif [[ $zerkala == 3 ]]; then
  echo ""  
  echo " Загрузка свежего списка зеркал со страницы Mirror Status "
pacman -S reflector --noconfirm
#pacman -Sy --noconfirm --noprogressbar --quiet reflector  
reflector --verbose --country Kazakhstan -l 20 -p http --sort rate --save /etc/pacman.d/mirrorlist  
# reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist
elif [[ $zerkala == 4 ]]; then
  echo ""  
  echo " Загрузка свежего списка зеркал со страницы Mirror Status "
pacman -S reflector --noconfirm
#pacman -Sy --noconfirm --noprogressbar --quiet reflector  
reflector -c "Russia" -c "Belarus" -c "Ukraine" -c "Poland" -f 20 -l 20 -p https -p http -n 20 --save /etc/pacman.d/mirrorlist --sort rate
#reflector --verbose --country 'Russia' --country 'Belarus' --country 'Ukraine' --country 'Poland' -f 20 -l 20 -p https -p http -n 20 --save /etc/pacman.d/mirrorlist --sort rate
  elif [[ $zerkala == 0 ]]; then
   echo "" 
   echo ' Смена зеркал пропущена. '   
fi
#pacman -Syy
clear
#lsblk -f
# ------------------------------------------------------------
# Важно:
# Обязательно сделайте резервную копию файла /etc/pacman.d/mirrorlist:
# cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
# Чтобы увидеть список всех доступных опций, наберите:
#reflector --help
# Команда отфильтрует 12 зеркал russia, отсортирует по скорости и обновит файл mirrorlist
#sudo reflector -c "Russia" -f 12 -l 12 --verbose --save /etc/pacman.d/mirrorlist
#------------------------------------------------------------------------
# Reflector (Русский) Wiki:
# https://wiki.archlinux.org/index.php/Reflector_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# Reflector — скрипт, который автоматизирует процесс настройки зеркал, включающий в себя загрузку свежего списка зеркал со страницы Mirror Status, фильтрацию из них наиболее обновленных, сортировку по скорости и сохранение в /etc/pacman.d/mirrorlist.
# https://www.linuxsecrets.com/archlinux-wiki/wiki.archlinux.org/index.php/
# Эта страница сообщает о состоянии всех известных, общедоступных и активных зеркал Arch Linux:
# https://www.archlinux.org/mirrors/status/
# =================================================================

echo ""
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

echo ""
echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов" 
#echo 'Обновим базы данных пакетов'
# Updating the package databases
#sudo pacman-key --init
#sudo pacman-key --refresh-keys
sudo pacman -Sy

echo ""
echo -e "${GREEN}==> ${NC}Меняем корень и переходим в нашу недавно скачанную систему" 
#echo 'Меняем корень и переходим в нашу недавно скачанную систему'
# Change the root and go to our recently downloaded system
echo -e "${MAGENTA}=> ${BOLD}Есть три варианта продолжения установки: ${NC}"
  echo " 1 - Если у Вас стабильный трафик интернета (dhcpcd), то выбирайте вариант - "1" "
  echo " 2 - Если у Вас бывают проблемы трафика интернета (wifi), то выбирайте вариант - "2" "
echo -e "${YELLOW}:: ${BOLD}В этих вариантах большого отличия нет, кроме команд выполнения (1вариант curl), (2вариант wget), и ещё во 2-ом варианте вам потребуется ввести команду на запуск скрипта "./archmy2l.sh", а также проверить подключение сети интернет "ping -c2 8.8.8.8" - т.е. пропинговать сеть. ${NC}" 
echo -e "${YELLOW}:: ${BOLD}Есть ещё 3й способ: команда выполнения как, и в 1ом варианте через (curl), и как во 2-ом варианте вам потребуется ввести команду на запуск скрипта "./archmy2l.sh", а также проверить подключение сети интернет "ping -c2 8.8.8.8" - т.е. пропинговать сеть. ${NC}"
echo " 3 - Альтернативный вариант для (dhcpcd, wifi), если у Вас возникнут проблемы с первыми способами продолжения установки, то рекомендую вариант - "3" "  
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами. "
# Be careful! In any situation, the choice is always yours.
echo ""
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - Stable Internet traffic (dhcpcd), 2 - Not Stable Internet traffic (wifi), 3 - Alternative Option (dhcpcd, wifi): " int  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  " 
    1 - Stable Internet traffic (dhcpcd),  

    2 - Not Stable Internet traffic (wifi), 

    3 - Alternative Option (dhcpcd, wifi): " int # sends right after the keypress; # отправляет сразу после нажатия клавиши 
    echo ''
    [[ "$int" =~ [^123] ]]
do
    :
done
if [[ $int == 1 ]]; then
  echo ""
 echo " Первый этап установки Arch'a закончен " 
 echo 'Установка продолжится в ARCH-LINUX chroot' 
 echo ""   
# pacman -S curl --noconfirm --noprogressbar
#arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/archmy2l.sh)"
arch-chroot /mnt sh -c "$(curl -fsSL git.io/archmy2l)"
echo " ############################################### "
echo -e "${BLUE}       ARCH LINUX FAST INSTALL ${RED}1.6 Update${NC}"
echo " ############################################### "
echo " Размонтирование всех смонтированных файловых систем (кроме корневой) "
umount -a
reboot
  elif [[ $int == 2 ]]; then
  echo ""
  pacman -S wget --noconfirm --noprogressbar 
  wget -P /mnt https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/archmy2l.sh
  chmod +x /mnt/archmy2l.sh 
  echo ""
  echo " Первый этап установки Arch'a закончен " 
  echo 'Установка продолжится в ARCH-LINUX chroot'
  echo ""
  echo -e "${YELLOW}:: ${BOLD}Важно! Для удачного продолжения установки выполните эти пунты: ${NC}"
  echo " 1 - Проверьте подключение сети интернет для продолжения установки в arch-chroot - "ping -c2 8.8.8.8" "
  echo " 2 - Вводим команду для продолжения установки "./archmy2l.sh" "  
  echo ""
  arch-chroot /mnt 
echo " ############################################### "
echo -e "${BLUE}       ARCH LINUX FAST INSTALL ${RED}1.6 Update${NC}"
echo " ############################################### "
echo " Размонтирование всех смонтированных файловых систем (кроме корневой) "
umount -a
reboot 
elif [[ $int == 3 ]]; then
echo ""
 #pacman -S curl --noconfirm --noprogressbar
  curl -LO https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/archmy2l.sh
  mv archmy2l.sh /mnt
  chmod +x /mnt/archmy2l.sh
 echo "" 
 echo " Первый этап установки Arch'a закончен " 
 echo 'Установка продолжится в ARCH-LINUX chroot' 
 echo ""
  echo -e "${YELLOW}:: ${BOLD}Важно! Для удачного продолжения установки выполните эти пунты: ${NC}"
  echo " 1 - Проверьте подключение сети интернет для продолжения установки в arch-chroot - "ping -c2 8.8.8.8" "
  echo " 2 - Вводим команду для продолжения установки "./archmy2l.sh" "  
  echo ""
  arch-chroot /mnt 
echo " ############################################### "
echo -e "${BLUE}       ARCH LINUX FAST INSTALL ${RED}1.6 Update${NC}"
echo " ############################################### "
echo " Размонтирование всех смонтированных файловых систем (кроме корневой) "
umount -a
reboot   
fi
##############################################

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

# ========================================================
###########################################################
# ********************************************************** 
