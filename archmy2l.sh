#!/bin/bash
#
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 
#
apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#
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
#
# ======================================================================
#echo 'Автоматическое обнаружение ошибок.'
# Эта команда остановит выполнение сценария после сбоя команды и будет отправлен код ошибки:
set -e
# ----------------------------------------------------------------------
# Если этот параметр '-e' задан, оболочка завершает работу, когда простая команда в списке команд завершается ненулевой (FALSE). Это не делается в ситуациях, когда код выхода уже проверен (if, while, until,||, &&)
# Встроенная команда set:
# https://www.sites.google.com/site/bashhackers/commands/set
# ======================================================================
#####################################################
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

###################################################################
# =================================================================
# 
#####   Baner  #######
#_arch_fast_install_banner
set > old_vars.log

APPNAME="arch_fast_install"
VERSION="v1.6 LegasyBIOS"
BRANCH="master"
AUTHOR="ordanax"
LICENSE="GNU General Public License 3.0"

# Information (Информация)
_arch_fast_install_banner_2() {
    echo -e "${YELLOW}==> ИНФОРМАЦИЯ! ******************************************** ${NC}  
Продолжается работа скрипта - основанного на сценарии (скрипта)'Arch Linux Fast Install LegasyBios (arch2018)'.
Происходит установка первоначально необходимого софта (пакетов), запуск необходимых служб, запись данных в конфиги (hhh.conf) по настройке системы.
В процессе работы сценария (скрипта) Вам будет предложено выполнить следующие действия:
Ввести имя пользователя (username), ввести имя компьютера (hostname), а также установить пароль для пользователя (username) и администратора (root). 
Настроить состояние аппаратных часов 'UTC или Localtime', но Вы можете отказаться и настроить их уже из системы Arch'a.
Будут заданы вопросы: на установку той, или иной утилиты (пакета), и на какой аппаратной базе будет установлена система (для установки Xorg 'обычно называемый просто X' и драйверов) - Будьте Внимательными! 
 Смысл в том, что все изменения Вы делаете предварительно в самом скрипте и получаете возможность быстрой установки утилит (пакетов), которые Вы решили установить (при условии, что Вы его изменили под себя, в противном случае скрипт установит софт (пакеты) прописанный изначально.
Не переживайте софт (пакеты) скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. В любой ситуации выбор всегда за вами.
${BLUE}===> ******************************************************* ${NC}"   
} 

# 
# *******************************************************************
#
### Display banner (Дисплей баннер)
_arch_fast_install_banner_2
#
sleep 01
echo ""
echo -e "${BLUE}:: ${NC}Обновим вашу систему (базу данных пакетов)"
#echo "Обновим вашу систему (базу данных пакетов)"
# Update your system (package database)
echo -e "${YELLOW}:: ${NC}Загружаем базу данных пакетов независимо от того, есть ли какие-либо изменения в версиях или нет."
#echo 'Загружаем базу данных пакетов независимо от того, есть ли какие-либо изменения в версиях или нет.'
# Loading the package database regardless of whether there are any changes in the versions or not.
pacman -Syyu  --noconfirm  
# ------------------------------------------------------------
# Полный апдейт системы:
#pacman -Syyuu  --noconfirm
# Не рекомендуется использовать sudo pacman -Syyu всё время!
# --------------------------------------------------------------
#pacman -Syy --noconfirm --noprogressbar --quiet
# Синхронизация и обновление пакетов (-yy принудительно обновить даже если обновленные)
# ==============================================================
#
echo -e "${BLUE}:: ${NC}Вводим имя компьютера, и имя пользователя"
#echo 'Вводим имя компьютера, и имя пользователя'
#echo 'Enter the computer name and user name'
# Enter the computer name
# Enter your username
#read -p "Введите имя компьютера: " hostname
#read -p "Введите имя пользователя: " username
echo -e "${GREEN}==> ${NC}" 
read -p " => Введите имя компьютера: " hostname
echo -e "${GREEN}==> ${NC}"
read -p " => Введите имя пользователя: " username
#read -p "Ведите свою таймзону в формате Example/Example: " timezone
#
echo -e "${BLUE}:: ${NC}Прописываем имя компьютера"
#echo 'Прописываем имя компьютера'
# Entering the computer name
echo $hostname > /etc/hostname
#echo "имя_компьютера" > /etc/hostname
#echo HostName > /etc/hostname
# ----------------------------------------------------
# Разберём команду для localhost >>>
# Вместо ArchLinux впишите свое название
# echo "ArchLinux" > /etc/hostname  - Можно написать с Заглавной буквы.
# echo имя_компьютера > /etc/hostname
# =======================================================
#
echo -e "${BLUE}:: ${NC}Устанавливаем ваш часовой пояс"
#echo 'Устанавливаем ваш часовой пояс'
# Setting your time zone
#rm -v /etc/localtime
#ln -s /usr/share/zoneinfo/Europe/Moscow
#ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
#ls /usr/share/zoneinfo
#ls /usr/share/zoneinfo/Europe
echo " ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime "
#ln -svf /usr/share/zoneinfo/$timezone /etc/localtime
ln -svf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
#timedatectl set-ntp true
#ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
#ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
#ln -svf /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime
#ln -svf /usr/share/zoneinfo/Europe/Kiev /etc/localtime
# ============================================================================
# Если Вы живите не в московском временной поясе, то Вам нужно выбрать подходящий ваш часовой пояс. Смотрим доступные пояса:
#ls /usr/share/zoneinfo
#ls /usr/share/zoneinfo/Нужный_Регион

# Разберём команду для localtime >>>
# Выбираем часовой пояс:
#ln -s /usr/share/zoneinfo/Зона/Субзона /etc/localtime
#ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
# Эта команда создает, так называемую символическую ссылку выбранного пояса в папке /etc
# ============================================================================

echo -e "${BLUE}:: ${NC}Синхронизация системных часов"  
#echo '2.3 Синхронизация системных часов'
# Syncing the system clock
#echo 'Синхронизируем наши системные часы, включаем ntp, если надо сменим часовой пояс'
# Sync our system clock, enable ntp, change the time zone if necessary
timedatectl set-ntp true

echo -e "${BLUE}:: ${NC}Проверим аппаратное время"
#echo 'Проверим аппаратное время' 
# Check the hardware time
#hwclock
hwclock --systohc
#echo " hwclock --systohc --utc "
#hwclock --systohc —utc
#echo " hwclock --systohc --localtime "
#hwclock --systohc --local

echo -e "${BLUE}:: ${NC}Посмотрим текущее состояние аппаратных и программных часов"
#echo 'Посмотрим текущее состояние аппаратных и программных часов'
# Let's see the current state of the hardware and software clock
timedatectl

echo ""
echo -e "${BLUE}:: ${NC}Настроим состояние аппаратных и программных часов"
#echo 'Настроим состояние аппаратных и программных часов'
# Setting up the state of the hardware and software clock    
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
# ============================================================================
# Windows и Linux работают по-разному с этими двумя часами. 
# Есть два способа работы:
# UTC - и аппаратные, и программные часы идут по Гринвичу. 
# То есть часы дают универсальное время на нулевом часовом поясе. 
# Например, если у вас часовой пояс GMT+3, Киев, то часы будут отставать на три часа. 
# А уже пользователи локально прибавляют к этому времени поправку на часовой пояс, например, плюс +3. 
# Каждый пользователь добавляет нужную ему поправку. Так делается на серверах, 
# чтобы каждый пользователь мог получить правильное для своего часового пояса время.
# localtime - в этом варианте программные часы тоже идут по Гринвичу, 
# но аппаратные часы идут по времени локального часового пояса. 
# Для пользователя разницы никакой нет, все равно нужно добавлять поправку на свой часовой пояс. 
# Но при загрузке и синхронизации времени Windows вычитает из аппаратного времени 3 часа 
# (или другую поправку на часовой пояс), чтобы программное время было верным.
# Вы можете пропустить этот шаг, если не уверены в правильности выбора.
# ============================================================================
read -p " 1 - UTC, 2 - Localtime, 0 - Пропустить: " prog_set
if [[ $prog_set == 1 ]]; then
hwclock --systohc --utc
  echo " hwclock --systohc --utc "
  echo " UTC - часы дают универсальное время на нулевом часовом поясе " 
elif [[ $prog_set == 2 ]]; then
hwclock --systohc --local
  echo " hwclock --systohc --localtime "
  echo " Localtime - часы идут по времени локального часового пояса " 
elif [[ $prog_set == 0 ]]; then
  echo 'Настройка пропущена.'
fi

# ------------------------------------------------------------------------
#echo -e "${BLUE}:: ${NC}Настроим состояние аппаратных и программных часов"
#echo 'Настроим состояние аппаратных и программных часов'
# Setting up the state of the hardware and software clock 
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'   
#hwclock --systohc --utc
##hwclock --systohc --local
# ---------------------------------------------------------------------------
# Где в Arch жёстко прописать чтоб апаратное время равнялось локальному?
# Я делаю так:
# sudo hwclock --localtime
# sudo timedatectl set-local-rtc 1
#hwclock --systohc --utc
#hwclock --systohc --local
# Команды для исправления уже в установленной системе:
# Исправим ошибку времени, если она есть
#sudo timedatectl set-local-rtc 1 --adjust-system-clock
# Как вернуть обратно -
#sudo timedatectl set-local-rtc 0
# Для понимания сути команд статья с примерами -
# https://losst.ru/sbivaetsya-vremya-v-ubuntu-i-windows
# https://www.ekzorchik.ru/2012/04/hardware-time-settings-hwclock/
# ============================================================================

echo -e "${BLUE}:: ${NC}Посмотрим обновление времени (если настройка не была пропущена)"
#echo 'Посмотрим обновление времени (если настройка не была пропущена)'
# See the time update (if the setting was not skipped)
timedatectl show
#timedatectl | grep Time

echo -e "${BLUE}:: ${NC}Изменяем имя хоста"
#echo 'Изменяем имя хоста'
# Changing the host name
echo "127.0.0.1	localhost.(none)" > /etc/hosts
echo "127.0.1.1	$hostname" >> /etc/hosts
echo "::1	localhost ip6-localhost ip6-loopback" >> /etc/hosts
echo "ff02::1 ip6-allnodes" >> /etc/hosts
echo "ff02::2 ip6-allrouters" >> /etc/hosts
#echo "127.0.1.1 имя_компьютера" >> /etc/hosts
# - Можно написать с Заглавной буквы.
# Это дейсвие не обязательно! Мы можем это сделаем из установленной ситемы, если данные не пропишутся автоматом.

echo -e "${BLUE}:: ${NC}Добавляем русскую локаль системы"
#echo 'Добавляем русскую локаль системы'
# Adding the system's Russian locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 
# Есть ещё команды по добавлению русскую локаль в систему:
#echo -e "en_US.UTF-8 UTF-8\nru_RU.UTF-8 UTF-8" >> /etc/locale.gen
# Можно раскомментирвать нужные локали (и убирать #)
#sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
#sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen

echo -e "${BLUE}:: ${NC}Обновим текущую локаль системы"
#echo 'Обновим текущую локаль системы'
# Update the current system locale
locale-gen
# Мы ввели locale-gen для генерации тех самых локалей.

sleep 02
echo -e "${BLUE}:: ${NC}Указываем язык системы"
#echo 'Указываем язык системы'
# Specify the system language
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf
#echo 'LANG="en_US.UTF-8"' > /etc/locale.conf
#export LANG=ru_RU.UTF-8
#export LANG=en_US.UTF-8
# Эта команда сама пропишет в файлике locale.conf нужные нам параметры.
# Ну и конечно, раз это переменные окружения, то мы можем установить их временно в текущей сессии терминала
# При раскомментировании строки '#export ....', - Будьте Внимательными!
# Как назовёшь, так и поплывёшь...
# When you uncomment the string '#export....', Be Careful!
# As you name it, you will swim...

echo -e "${BLUE}:: ${NC}Вписываем KEYMAP=ru FONT=cyr-sun16"
#echo 'Вписываем KEYMAP=ru FONT=cyr-sun16'
# Enter KEYMAP=ru FONT=cyr-sun16
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf
echo 'FONT_MAP=' >> /etc/vconsole.conf
echo 'CONSOLEMAP' >> /etc/vconsole.conf
echo 'COMPRESSION="lz4"' >> /etc/mkinitcpio.conf
#-----------------------------------------------------------------------------
#echo 'Вписываем KEYMAP=ru FONT=ter-v16n'
#echo 'KEYMAP=us' >> /etc/vconsole.conf
#echo 'FONT=ter-v16n' >> /etc/vconsole.conf
# Можно изменить шрифт:
# pacman -S terminus-font - качаем шрифт терминус
#loadkeys us
#pacman -Syy
#pacman -S terminus-font --noconfirm
#setfont ter-v16b
# nano /etc/vconsole.conf - устанавливаем шрифт и переключение клавиатуры по Ctrl-Shift
# (только в консоли, я не уверен нужно ли это вообще, но помню в убунте надо было писать на русском "да/нет").
# Если есть желание экспериментировать, консольные шрифты находятся в /usr/share/kbd/consolefonts/ смотрим с помощью ls 
# ============================================================================

echo -e "${BLUE}:: ${NC}Создадим загрузочный RAM диск (начальный RAM-диск)"
#echo 'Создадим загрузочный RAM диск (начальный RAM-диск)'
# Creating a bootable RAM disk (initial RAM disk)
mkinitcpio -p linux-lts
#mkinitcpio -p linux
#mkinitcpio -P linux
#mkinitcpio -p linux-zen
#echo 'COMPRESSION="lz4"' >> /etc/mkinitcpio.conf
# ============================================================================
# Команда: mkinitcpio -p linux-lts  - применяется, если Вы устанавливаете
# стабильное ядро (linux-ltc), иначе вай..вай... может быть ошибка!
# Команда: mkinitcpio -p linux-zen  - применяется, если Вы устанавливаете
# стабильное ядро (linux-zen), иначе вай..вай... может быть ошибка!  
# В остальных случаях при установке Arch'a с ядром (linux) идущим вместе   
# с устанавливаемым релизом (rolling release) применяется команда : mkinitcpio -p linux.
# Ошибки при создании RAM mkinitcpio -p linux. Как исправить?
# https://qna.habr.com/q/545694
# ============================================================================
# mkinitcpio это Bash скрипт используемый для создания начального загрузочного диска системы
# Параметр -p (сокращение от preset) указывает на использование preset файла из /etc/mkinitcpio.d (т.е. /etc/mkinitcpio.d/linux.preset для linux). preset файл определяет параметры сборки initramfs образа вместо указания файла конфигурации и выходной файл каждый раз.

# Warning: preset файлы используются для автоматической пересборки initramfs после обновления ядра. Будьте внимательны при их редактировании.
# Варианты создания initcpio:
# Пользователи могут вручную создать образ с помощью альтернативного конфигурационного файла. Например, следующее будет генерировать initramfs образ в соответствии с /etc/mkinitcpio-custom.conf и сохранит его в /boot/linux-custom.img.
# mkinitcpio -c /etc/mkinitcpio-custom.conf -g /boot/linux-custom.img
# Если необходимо создать образ с ядром отличным от загруженного.
# Доступные версии ядер можно посмотреть в /usr/lib/modules.
# ---------------------------------------------------------------------------
# После этого нужно подредактировать хуки keymap.
# Откройте файл /etc/mkinitcpio.conf:  
#nano /etc/mkinitcpio.conf
# Ищём строчку HOOKS и добавляем в конце 3 хука (внутри скобок):
#HOOKS = (... consolefont keymap systemd)

#/etc/mkinitcpio.conf - основной конфигурационный файл mkinitcpio. Кроме того, в каталоге /etc/mkinitcpio.d располагаются preset файлы (e.g. /etc/mkinitcpio.d/linux.preset).
# Ссылка на Wiki :
#https://wiki.archlinux.org/index.php/Mkinitcpio_%28%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9%29
#https://ru.wikipedia.org/wiki/Initrd
# ============================================================================

echo -e "${GREEN}==> ${NC}Создаём root пароль"
#echo 'Создаём root пароль'
# Creating a root password
echo " passwd root "
passwd
# --------------------------------------------------------------------------
# Пример вывода применённой команды >>> $ passwd После чего дважды новый пароль.
# Список пользователей в Linux хранится в файле /etc/passwd, вы можете без труда открыть его и посмотреть, пароли же выделены в отдельный файл - /etc/shadow. 
# Этот файл можно открыть только с правами суперпользователя, и, более того, пароли здесь хранятся в зашифрованном виде, поэтому узнать пароль Linux не получиться, а поменять вручную будет сложно.
# В большинстве случаев смена пароля выполняется с помощью утилиты passwd. Это очень мощная утилита, она позволяет не только менять пароль, но и управлять сроком его жизни.
# Как сменить пароль в Linux :
# https://losst.ru/kak-smenit-parol-v-linux
# ============================================================================

#echo -e "${BLUE}:: ${NC}3.5 Устанавливаем загрузчик GRUB(legacy)"
#echo '3.5 Устанавливаем загрузчик GRUB(legacy)'
# Install the boot loader GRUB(legacy)
#pacman -Syy
#pacman -S grub --noconfirm 
#grub-install /dev/sda
# ------------------------------------------------------------------
# pacman -S grub --noconfirm --noprogressbar --quiet 
# grub-install /dev/sda 
# Если Вы получили сообщение об ошибке, то используйте команду:
# grub-install --recheck /dev/sda
# Также в некоторых случаях может помочь вариант:
# grub-install --recheck --no-floppy /dev/sda
# Записываем загрузчик в MBR (Master Boot Record) нашего внутреннего накопителя.
#grub-install --target=i386-pc --force --recheck /dev/sda 
#grub-install --target=i386-pc /dev/sda   #(для платформ i386-pc) 
#grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
#read -p " => Укажите диск (sda/sdb например sda или sdb) : " cfd
#grub-install /dev/$cfd  #sda sdb sdc sdd
# ============================================================================
echo ""
echo -e "${GREEN}==> ${NC}Установить загрузчик GRUB(legacy)?"
#echo 'Установить загрузчик GRUB(legacy)?'
# Install the boot loader GRUB(legacy)
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если у вас уже имеется BOOT раздел от другой (предыдущей) системы gnu-linux, с установленным на нём GRUB."
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
read -p " 1 - Установить GRUB, 2 - Для платформ i386-pc, 0 - Нет пропустить: " i_grub
if [[ $i_grub == 1 ]]; then
pacman -Syy
pacman -S grub --noconfirm
lsblk -f
 read -p " => Укажите диск куда установить GRUB (sda/sdb например sda или sdb) : " x_cfd
 grub-install /dev/$x_cfd
  echo " Загрузчик GRUB установлен на выбранный вами диск (раздел). " 
#grub-mkconfig -o /boot/grub/grub.cfg
# echo " Обновлён (сгенерирован) grub.cfg (/boot/grub/grub.cfg). "
elif [[ $i_grub == 2 ]]; then
pacman -Syy
pacman -S grub --noconfirm
lsblk -f
 read -p " => Укажите диск куда установить GRUB (sda/sdb например sda или sdb) : " x_cfd
 grub-install --target=i386-pc /dev/$x_cfd
  echo " Загрузчик GRUB установлен на выбранный вами диск (раздел). " 
#grub-mkconfig -o /boot/grub/grub.cfg
# echo " Обновлён (сгенерирован) grub.cfg (/boot/grub/grub.cfg). " 
elif [[ $i_grub == 0 ]]; then
  echo 'Операция пропущена.'
fi

# Установка boot loader'а (загрузчика grub)
# Их существует несколько, но grub, наверное самый популярный в Linux.
# (или grub-install /dev/sdb , или grub-install /dev/sdс в зависимости от маркировки вашего диска, флешки куда будет установлен загрузчик grub (для BIOS))
# Загрузчик - первая программа, которая загружается с диска при старте компьютера, и отвечает за загрузку и передачу управления ядру ОС. 
# Ядро, в свою очередь, запускает остальную часть операционной системы.
# Если вы хотите установить Grub на флешку в MBR, то тут тоже нет проблем просто примонтируйте флешку и выполните такую команду:
#sudo grub-install --root-directory=/mnt/USB/ /dev/sdb
# Здесь /mnt/USB - папка, куда была смотирована ваша флешка, а /seb/sdb - сама флешка. Только здесь есть одна проблема, конфигурационный файл придется делать вручную.
# https://wiki.archlinux.org/index.php/GRUB_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# https://losst.ru/nastrojka-zagruzchika-grub
# ============================================================================

echo ""
echo -e "${GREEN}==> ${NC}Установить Микрокод для процессора INTEL_CPU, AMD_CPU?"
#echo 'Установить Микрокод для процессора INTEL_CPU, AMD_CPU?'
# Install the Microcode for the CPU INTEL_CPU, AMD_CPU?
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
read -p " 1 - INTEL, 2 - AMD, 0 - Нет - пропустить этот шаг: " prog_set
if [[ $prog_set == 1 ]]; then
 pacman -S intel-ucode --noconfirm 
   echo " Установлены обновления стабильности и безопасности для микрокода процессора - INTEL "    
elif [[ $prog_set == 2 ]]; then
 pacman -S amd-ucode --noconfirm 
   echo " Установлены обновления стабильности и безопасности для микрокода процессора - AMD "    
elif [[ $prog_set == 0 ]]; then
  echo 'Установка программ пропущена.'
fi

#-----------------------------------------------------------------------------
#echo -e "${GREEN}==> ${NC}Установить Микрокод для процессора INTEL_CPU, AMD_CPU?"
#echo 'Установить Микрокод для процессора INTEL_CPU, AMD_CPU?'
# Install the Microcode for the CPU INTEL_CPU, AMD_CPU?
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# Если у Вас процессор Intel, то:
#pacman -S intel-ucode
#pacman -S intel-ucode --noconfirm
# Если у Вас процессор AMD, то:
#pacman -S amd-ucode
#pacman -S amd-ucode --noconfirm
# ----------------------------------------------------------------------------
# Микрокод для процессора - Microcode (matching CPU)
#read -p "У вас amd или intel?: " cpu
#export INTEL_CPU="intel-ucode"
#export AMD_CPU="amd-ucode"
#---------------------------------------------------------------------------
# Производители процессоров выпускают обновления стабильности и безопасности для микрокода процессора. Несмотря на то, что микрокод можно обновить с помощью BIOS, ядро Linux также может применять эти обновления во время загрузки. Эти обновления предоставляют исправления ошибок, которые могут быть критичны для стабильности вашей системы. Без этих обновлений вы можете наблюдать ложные падения или неожиданные зависания системы, которые может быть сложно отследить.
# Особенно пользователи процессоров семейства Intel Haswell и Broadwell должны установить эти обновления, чтобы обеспечить стабильность системы. Но, понятное дело, все пользователи должны устанавливать эти обновления.
# Wiki: https://wiki.archlinux.org/index.php/Microcode_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# https://wiki.archlinux.org/index.php/Install_Arch_Linux_on_a_removable_medium
# ============================================================================

echo ""
echo -e "${BLUE}:: ${NC}Обновляем grub.cfg (Сгенерируем grub.cfg)"
#echo 'Обновляем grub.cfg (Сгенерируем grub.cfg)'
# Updating grub.cfg (Generating grub.cfg)
grub-mkconfig -o /boot/grub/grub.cfg
# ----------------------------------------------------------------------------
# Файл /etc/boot/grub/grub.cfg управляет непосредственно работой загрузчика, здесь указаны все его параметры и настройки, а также сформировано меню. 
# Поэтому, изменяя этот файл, мы можем настроить Grub как угодно.
# https://losst.ru/nastrojka-zagruzchika-grub
# Можно (нужно) создать резервную копию (дубликат) файла 'grub.cfg', и это мы сделаем уже в установленной системе.
# Команда для backup (duplicate) of the grub.cfg file :
#sudo cp /boot/grub/grub.cfg grub.cfg.backup
# ============================================================================

echo ""
echo -e "${YELLOW}==> ${NC}Если в системе будут несколько ОС, то это также ставим"
#echo 'Если в системе будут несколько ОС, то это также ставим'
# If the system will have several operating systems, then this is also set
pacman -S os-prober mtools fuse
#pacman -S os-prober mtools fuse --noconfirm
# ---------------------------------------------------------------------------
# Для двойной загрузки Arch Linux с другой системой Linux, установить другой Linux без загрузчика, вам необходимо установить os-prober — утилиту, необходимую для обнаружения других операционных систем. И обновить загрузчик Arch Linux, чтобы иметь возможность загружать новую ОС.
# ============================================================================

echo ""
echo -e "${BLUE}:: ${NC}Ставим программы для Wi-fi"
#echo 'Ставим программу для Wi-fi'
# Install the program for Wi-fi
pacman -S dialog wpa_supplicant iw wireless_tools net-tools --noconfirm 

# -----------------------------------------------------------------
#echo -e "${GREEN}==> ${NC}Установить программы (пакеты) для Wi-fi?"
#echo 'Установить программы (пакеты) для Wi-fi?'
# Install programs (packages) for Wi-fi??
#read -p " 1 - Да, 0 - Нет - пропустить этот шаг: " wifi
#if [[ $wifi == 1 ]]; then
#  echo " Устанавливаем программы для Wi-fi "
# pacman -S dialog wpa_supplicant iw wireless_tools net-tools --noconfirm
#  echo " Программы для Wi-fi установлены "             
#elif [[ $wifi == 0 ]]; then
#  echo 'Установка программ пропущена.'
#fi
# ------------------------------------------------------------------

echo ""
echo -e "${BLUE}:: ${NC}Добавляем пользователя и прописываем права, группы"
#echo 'Добавляем пользователя и прописываем права, группы'
# Adding a user and prescribing rights, groups
#useradd -m -g users -G wheel -s /bin/bash $username
useradd -m -g users -G adm,audio,games,lp,network,optical,power,scanner,storage,video,rfkill,sys,wheel -s /bin/bash $username
# или есть команда с правами 'админа' :
#useradd -m -g users -G adm,audio,games,lp,optical,power,scanner,storage,video,sys,rfkill,wheel -s /bin/bash $username

echo -e "${GREEN}==> ${NC}Устанавливаем пароль пользователя"
#echo 'Устанавливаем пароль пользователя'
# Setting the user password
echo " passwd username "
passwd $username

echo ""
echo -e "${BLUE}:: ${NC}Устанавливаем SUDO"
#echo 'Устанавливаем SUDO'
# Installing SUDO
pacman -S sudo --noconfirm
#echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
#sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
# ============================================================================
# Sudo - это альтернатива su для выполнения команд с правами суперпользователя (root). 
# В отличие от su, который запускает оболочку с правами root и даёт всем дальнейшим командам root права, sudo предоставляет временное повышение привилегий для одной команды.
# Чтобы начать использовать sudo как непривилегированный пользователь, его нужно настроить должным образом. Для этого прочтите раздел о настройке.
# https://wiki.archlinux.org/index.php/Sudo_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# Крайне важно, чтобы файл sudoers был без синтаксических ошибок! 
# Любая ошибка делает sudo неработоспособным.
# ============================================================================

echo -e "${BLUE}:: ${NC}Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе"
#echo 'Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
# Uncomment the multilib repository For running 32-bit applications on a 64-bit system
#echo 'Color = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
#echo '[multilib]' >> /etc/pacman.conf
#echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
#pacman -Syy
echo ' Multilib репозиторий добавлен '

echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов" 
#echo 'Обновим базы данных пакетов'
# Updating the package databases
#sudo pacman-key --init
#sudo pacman-key --refresh-keys
sudo pacman -Sy  
#pacman -Syy
# ============================================================================
# Знакомьтесь, pacman - лучший пакетный менеджер в мире линукса!
#pacman -Syy   - обновление баз пакмэна(как apt-get update в дэбианоподбных)
#pacman -Syyu  - обновление баз плюс обновление пакетов
# ----------------------------------------------------------------------------
#pacman -Syy --noconfirm --noprogressbar --quiet
# Синхронизация и обновление пакетов (-yy принудительно обновить даже если обновленные)

echo ""
echo -e "${RED}==> ${NC}Куда устанавливем Arch Linux на виртуальную машину?"
#echo "Куда устанавливем Arch Linux на виртуальную машину?"
# Where do we install Arch Linux on the VM?
read -p " 1 - Да, 0 - Нет: " vm_setting
if [[ $vm_setting == 0 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit"
elif [[ $vm_setting == 1 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils"
fi

echo -e "${BLUE}:: ${NC}Ставим иксы и драйвера"
#echo 'Ставим иксы и драйвера'
# Put the x's and drivers
pacman -S $gui_install
#pacman -Syy

# --------------------------------------------------------------------------
#echo -e "${BLUE}:: ${NC}Ставим иксы и драйвера"
#echo 'Ставим иксы и драйвера'
# Put the x's and drivers
#pacman -S xorg-server xorg-drivers xorg-xinit   # virtualbox-guest-utils --noconfirm
#pacman -S xorg-server xorg-drivers xorg-apps xorg-xinit mesa xorg-twm xterm xorg-xclock xf86-input-synaptics virtualbox-guest-utils --noconfirm  #linux-headers
#pacman -S xorg-server xorg-drivers xorg-apps xorg-xinit mesa xorg-twm xterm xorg-xclock xf86-input-synaptics virtualbox-guest-utils  #linux-headers
# -------------------------------------------------------------------------
#pacman -S bash-completion xorg-server xorg-apps xorg-xinit mesa xorg-twm xterm xorg-xclock xf86-input-synaptics virtualbox-guest-utils linux-headers --noconfirm
# ============================================================================

#echo -e "${RED}==> ${NC}Куда устанавливем Arch Linux на виртуальную машину?"
#echo "Where do we install Arch Linux on a virtual machine?"
#echo "Куда устанавливем Arch Linux на виртуальную машину?"
#read -p "1 - Yes, 0 - No: " vm_setting
#if [[ $vm_setting == 0 ]]; then
# pacman -S xorg-server xorg-drivers xorg-xinit --noconfirm --noprogressbar --quiet 
#elif [[ $vm_setting == 1 ]]; then
#  (
#   echo 13;
#   echo 2;
#  ) | pacman -S xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils --noconfirm --noprogressbar --quiet 
#fi

#echo "Какая видеокарта?"
#read -p "1 - nvidia, 2 - Amd, 3 - intel: " videocard
#if [[ $videocard == 1 ]]; then
#  pacman -S nvidia lib32-nvidia-utils nvidia-settings --noconfirm
#  nvidia-xconfig
#elif [[ $videocard == 2 ]]; then
#  pacman -S lib32-mesa xf86-video-amdgpu mesa-vdpau lib32-mesa-vdpau vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver --noconfirm
#elif [[ $videocard == 3 ]]; then
#  pacman -S lib32-mesa vulkan-intel libva-intel-driver lib32-libva-intel-driver lib32-vulkan-intel --noconfirm
#fi

#echo 'Ставим драйвера видеокарты intel'
#sudo pacman -S xf86-video-intel vdpauinfo libva-utils libva-intel-driver libva lib32-libva-intel-driver libvdpau libvdpau-va-gl lib32-libvdpau --noconfirm

#-------------------------------------------------------------------------------
# Видео драйверы, без них тоже ничего работать не будет вот список:
# xf86-video-vesa - как я понял, это универсальный драйвер для ксорга (xorg), должен работать при любых обстоятельствах, но вы знаете как, только для того чтобы поставить подходящий.
# xf86-video-ati - свободный ATI
# xf86-video-intel - свободный Intel
# xf86-video-nouveau - свободный Nvidia
# Существуют также проприетарные драйверы, то есть разработаны самой Nvidia или AMD, но они часто не поддерживают новое ядро, или ещё какие-нибудь траблы.
# virtualbox-guest-utils - для виртуалбокса, активируем коммандой:
#systemctl enable vboxservice - вводим дважды пароль
# ============================================================================

#echo -e "${BLUE}:: ${NC}Установка гостевых дополнений vbox"
#echo 'Установка гостевых дополнений vbox'
#Install the Guest Additions vbox
#modprobe -a vboxguest vboxsf vboxvideo
#cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc
#echo -e "\nvboxguest\nvboxsf\nvboxvideo" >> /home/$username/.xinitrc
#sed -i 's/#!\/bin\/sh/#!\/bin\/sh\n\/usr\/bin\/VBoxClient-all/' /home/$username/.xinitrc

# ------------------------------------------------------------------------

echo -e "${BLUE}:: ${NC}Ставим DE (от англ. desktop environment — среда рабочего стола) Xfce"
#echo 'Ставим DE (от англ. desktop environment — среда рабочего стола) Xfce'
# Put DE (from the English desktop environment-desktop environment) Xfce
pacman -S xfce4 xfce4-goodies --noconfirm
#pacman -S xorg-xinit --noconfirm
cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc
chown $username:users /home/$username/.xinitrc
chmod +x /home/$username/.xinitrc
sed -i 52,55d /home/$username/.xinitrc
echo "exec startxfce4 " >> /home/$username/.xinitrc
mkdir /etc/systemd/system/getty@tty1.service.d/
echo " [Service] " > /etc/systemd/system/getty@tty1.service.d/override.conf
echo " ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo   ExecStart=-/usr/bin/agetty --autologin $username --noclear %I 38400 linux >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo ' [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx ' >> /etc/profile
echo " DE (среда рабочего стола) Xfce успешно установлено "

echo -e "${BLUE}:: ${NC}Ставим DM (Display manager) менеджера входа"
#echo 'Ставим DM (Display manager) менеджера входа'
# Install the DM (Display manager) of the login Manager
pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm
echo " Установка DM (менеджера входа) завершена "

echo -e "${BLUE}:: ${NC}Ставим сетевые утилиты Networkmanager"
#echo 'Ставим сетевые утилиты "Networkmanager"'
# Put the network utilities "Networkmanager"
pacman -S networkmanager networkmanager-openvpn network-manager-applet ppp --noconfirm
# networkmanager - сервис для работы интернета. Вместе с собой устанавливает программы для настройки.
# Если вам нужна поддержка OpenVPN в Network Manager, то выполните команду:
#sudo pacman -S networkmanager-openvpn
# https://wiki.archlinux.org/index.php/Networkmanager-openvpn
# https://www.archlinux.org/packages/extra/x86_64/networkmanager-openvpn/

echo -e "${BLUE}:: ${NC}Ставим шрифты"
#echo 'Ставим шрифты'
# Put the fonts
pacman -S ttf-liberation ttf-dejavu opendesktop-fonts ttf-arphic-ukai ttf-arphic-uming ttf-hanazono --noconfirm 
pacman -S ttf-fireflysung ttf-sazanami --noconfirm  #китайские иероглифы

echo -e "${BLUE}:: ${NC}Подключаем автозагрузку менеджера входа и интернет"
#echo 'Подключаем автозагрузку менеджера входа и интернет'
# Enabling auto-upload of the login Manager and the Internet
systemctl enable lightdm.service
#systemctl enable lightdm.service -f
sleep 1 
systemctl enable NetworkManager

echo ""
echo -e "${GREEN}==> ${NC}Добавим службу Dhcpcd в автозагрузку (для проводного интернета)?"
#echo 'Добавим службу Dhcpcd в автозагрузку (для проводного интернета)?'
# Adding the Dhcpcd service to auto-upload (for wired Internet)?
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
read -p " 1 - Включить dhcpcd, 0 - Нет - пропустить этот шаг: " x_dhcpcd
if [[ $x_dhcpcd == 1 ]]; then
systemctl enable dhcpcd
echo " Dhcpcd успешно добавлен в автозагрузку "    
elif [[ $x_dhcpcd == 0 ]]; then
  echo ' Dhcpcd не включен в автозагрузку, при необходиости это можно будет сделать уже в установленной системе '
fi

echo -e "${BLUE}:: ${NC}Монтирование разделов NTFS и создание ссылок"
#echo 'Монтирование разделов NTFS и создание ссылок'
# NTFS support (optional)
sudo pacman -S ntfs-3g --noconfirm

echo -e "${BLUE}:: ${NC}Создаём нужные директории (Downloads,Music,Pictures,Videos,Documents)"
#echo 'Создаём нужные директории (Downloads,Music,Pictures,Videos,Documents)'
# Creating the necessary directories (Downloads,Music,Pictures,Videos,Documents)
sudo pacman -S xdg-user-dirs --noconfirm
xdg-user-dirs-update 
# ============================================================================
# XDG: Пользовательские папки
# xdg-user-dirs – инструмент, который помогает в управлении «всем известными» папками пользователей, такими, как папка Рабочий стол и папка с музыкальными файлами. Также он управляет локализацией (т.е. переводом) имён этих папок.
# https://wiki.archlinux.org/index.php/XDG_user_directories_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# https://wiki.yola.ru/xdg/user-dirs
# ============================================================================

echo -e "${BLUE}:: ${NC}Установка базовых программ и пакетов"
#echo 'Установка базовых программ и пакетов'
# Installing basic programs and packages
sudo pacman -S wget --noconfirm
# ============================================================================
# GNU Wget - это бесплатный программный пакет для извлечения файлов с использованием HTTP, HTTPS, FTP и FTPS (FTPS начиная с версии 1.18) .
# Это неинтерактивный инструмент командной строки, поэтому его легко вызывать из сценариев.
# https://wiki.archlinux.org/index.php/Wget
# Команда wget linux имеет очень простой синтаксис: wget опции аддресс_ссылки
# Можно указать не один URL для загрузки, а сразу несколько. Опции указывать не обязательно, но в большинстве случаев они используются для настройки параметров загрузки.
# Команда wget linux, обычно поставляется по умолчанию в большинстве дистрибутивов, но если нет, её можно очень просто установить.
# https://losst.ru/komanda-wget-linux
# ============================================================================

echo -e "${GREEN}=> ${BOLD}Создадим конфигурационный файл для установки системных переменных /etc/sysctl.conf ${NC}"
#echo 'Создадим конфигурационный файл для установки системных переменных /etc/sysctl.conf'
# Creating a configuration file for setting system variables /etc/sysctl.conf
> /etc/sysctl.conf
cat <<EOF >>/etc/sysctl.conf

#
# /etc/sysctl.conf - Configuration file for setting system variables
# See /etc/sysctl.d/ for additional system variables.
# See sysctl.conf (5) for information.
#

#kernel.domainname = example.com

# Uncomment the following to stop low-level messages on console
#kernel.printk = 3 4 1 3

##############################################################3
# Functions previously found in netbase
#

# Uncomment the next two lines to enable Spoof protection (reverse-path filter)
# Turn on Source Address Verification in all interfaces to
# prevent some spoofing attacks
#net.ipv4.conf.default.rp_filter=1
#net.ipv4.conf.all.rp_filter=1

# Uncomment the next line to enable TCP/IP SYN cookies
# See http://lwn.net/Articles/277146/
# Note: This may impact IPv6 TCP sessions too
net.ipv4.tcp_syncookies=1

# Uncomment the next line to enable packet forwarding for IPv4
net.ipv4.ip_forward=1

# Uncomment the next line to enable packet forwarding for IPv6
#  Enabling this option disables Stateless Address Autoconfiguration
#  based on Router Advertisements for this host
#net.ipv6.conf.all.forwarding=1


###################################################################
# Additional settings - these settings can improve the network
# security of the host and prevent against some network attacks
# including spoofing attacks and man in the middle attacks through
# redirection. Some network environments, however, require that these
# settings are disabled so review and enable them as needed.
#
# Do not accept ICMP redirects (prevent MITM attacks)
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
# _or_
# Accept ICMP redirects only for gateways listed in our default
# gateway list (enabled by default)
# net.ipv4.conf.all.secure_redirects = 1
#
# Do not send ICMP redirects (we are not a router)
#net.ipv4.conf.all.send_redirects = 0
#
# Do not accept IP source route packets (we are not a router)
#net.ipv4.conf.all.accept_source_route = 0
#net.ipv6.conf.all.accept_source_route = 0
#
# Log Martian Packets
#net.ipv4.conf.all.log_martians = 1
#
net.ipv4.tcp_timestamps=0
net.ipv4.conf.all.rp_filter=1
net.ipv4.tcp_max_syn_backlog=1280
kernel.core_uses_pid=1
#
vm.swappiness=10

EOF

# ============================================================================

#read -p "Введите допольнительные пакеты которые вы хотите установить: " packages 
#pacman -S $packages --noconfirm

echo -e "${GREEN}
  <<< Поздравляем! Установка завершена. Перезагрузите систему. >>> ${NC}"
# Congratulations! Installation is complete. Reboot the system.

echo -e "${BLUE}:: ${BOLD}Посмотрим дату и время ... ${NC}"
#echo 'Посмотрим дату и время'
# Let's look at the date and time
date

echo -e "${BLUE}:: ${BOLD}Отобразить время работы системы ... ${NC}"
#echo 'Отобразить время работы системы'
# Display the system's operating time 
uptime
# 12:35:19 – текущее системное время.
# up 8 min – это время, в течение которого система работала.
# 1 user количество зарегистрированных пользователей.
# load average: 0.66, 0.62, 0.35 – средние значения загрузки системы за последние 1, 5 и 15 минут.
# Как использовать команду Uptime:
# https://andreyex.ru/operacionnaya-sistema-linux/komanda-uptime-v-linux/

echo -e "${MAGENTA}==> ${BOLD}После перезагрузки и входа в систему проверьте ваши персональные настройки. ${NC}"
#echo 'После перезагрузки и входа в систему проверьте ваши персональные настройки.'
# After restarting and logging in, check your personal settings.

echo -e "${MAGENTA}==> ${BOLD}Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети. ${NC}"
#echo 'Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети.'
# If you have a wireless connection, launch nmtui and connect to the network.

echo -e "${YELLOW}==> ...${NC}"
echo -e "${BLUE}:: ${NC}Если хотите подключить AUR, установить дополнительный софт (пакеты), установить мои конфиги XFCE, тогда после перезагрузки и входа в систему выполните команду:"
#echo 'Если хотите подключить AUR, установить дополнительный софт (пакеты), установить мои конфиги XFCE, тогда после перезагрузки и входа в систему выполните команду:'
# If you want to connect AUR, install additional software (packages), install my Xfce configs, then after restarting and logging in, run the command:
echo -e "${YELLOW}==> ${CYAN}wget git.io/archmy3 && sh archmy3 ${NC}"

echo -e "${RED}==> ${BOLD}Выходим из установленной системы ${NC}"
#echo 'Выходим из установленной системы'
# Exiting the installed system
echo -e "${BLUE}:: ${BOLD}Теперь вам надо ввести reboot, чтобы перезагрузиться ${NC}"
#echo 'Теперь вам надо ввести reboot, чтобы перезагрузиться'
#'Now you need to enter 'reboot' to reboot"'
exit 
#umount -Rf /mnt

# Разделы (отмонтировать) Partitions (umount) 
#umount -Rfv /mnt
#umount -R /mnt

#echo -e "${BLUE}:: ${NC}Сейчас следует перезагрузить систему"
#echo 'После перезагрузки заходим под пользователем'
#Перезагрузка.После перезагрузки заходим под пользователем
#Reboot.After restarting, go under the user
#read -p "Пауза 3 ceк." -t 3
#reboot






