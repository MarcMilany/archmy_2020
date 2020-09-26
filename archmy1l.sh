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
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

ARCHMY1_LANG="russian"  # Installer default language (Язык установки по умолчанию)

script_path=$(readlink -f ${0%/*})

umask 0022 # Определение окончательных прав доступа
# Для суперпользователя (root) umask по умолчанию равна 0022

##################################################################
##### <<<Arch Linux Fast Install LegasyBIOS (arch2020)>>>    #####
##### Скрипты 'arch_2020' созданы на основе 2-х (скриптов):  #####
#####   'ordanax/arch2018', и 'archlinux-script-install' -   #####
##### (Poruncov,Grub-Legacy - 2020). При выполнении сценария #####
##### (скрипта), Вы получаете возможность быстрой установки  #####
#####  ArchLinux с вашими личными настройками (при условии,  #####
##### что Вы его изменили под себя, в противном случае - с   #####
##### моими настройками).                                    #####       
#####  В скрипте прописана установка grub для LegasyBIOS, с  #####
##### выбором DE/WM, а также DM (Менеджера входа), и т.д..   #####  
##### Этот скрипт находится в процессе 'Внесение поправок в  #####
##### наводку орудий по результатам наблюдений с наблюдате-  #####
##### льных пунктов'.                                        #####
##### Автор не несёт ответственности за любое нанесение вреда ####
##### при использовании скрипта.                             #####
##### Installation guide - Arch Wiki  (referance):           #####
##### https://wiki.archlinux.org/index.php/Installation_guide ####
##### Проект (project): https://github.com/ordanax/arch2018  #####
##### Лицензия (license): LGPL-3.0                           ##### 
##### (http://opensource.org/licenses/lgpl-3.0.html          #####
##### В разработке принимали участие (author) :              #####
##### Алексей Бойко https://vk.com/ordanax                   #####
##### Степан Скрябин https://vk.com/zurg3                    #####
##### Михаил Сарвилин https://vk.com/michael170707           #####
##### Данил Антошкин https://vk.com/danil.antoshkin          #####
##### Юрий Порунцов https://vk.com/poruncov                  #####
##### Jeremy Pardo (grm34) https://www.archboot.org/         #####
##### Marc Milany - 'Не ищи меня 'Вконтакте',                #####
#####                в 'Одноклассниках'' нас нету, ...       #####
##### Releases ArchLinux:                                    #####
#####    https://www.archlinux.org/releng/releases/          #####
##################################################################


set -e "\n${RED}Error: ${YELLOW}${*}${NC}"  # Эта команда остановит выполнение сценария после сбоя команды и будет отправлен код ошибки

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
AUTHOR="ordanax_and_poruncov"
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
 Arch Linux определяет простоту как без лишних дополнений или модификаций. Arch включает в себя многие новые функции, доступные пользователям GNU / Linux, включая systemd init system, современные файловые системы , LVM2, программный RAID, поддержку udev и initcpio (с mkinitcpio ), а также последние доступные ядра.  
Arch Linux - это дистрибутив общего назначения. После установки предоставляется только среда командной строки: вместо того, чтобы вырывать ненужные и нежелательные пакеты, пользователю предлагается возможность создать собственную систему, выбирая среди тысяч высококачественных пакетов, представленных в официальных репозиториях для x86-64 архитектуры.
 Изначально этот скрипт не задумывался, как обычный установочный (сценарий), с большим выбором DE, разметкой диска и т.д..
Но в последствие! Эта концепция была пересмотрена, и в скрипт был добавлен выбор DE, разметка диска и другие плюшки. И он (скрипт) НЕ предназначен для новичков! 
Он предназначен для тех, кто ставил Arch Linux руками и понимает, что и для чего нужна каждая команда.  
Его цель - это быстрое разворачивание системы со всеми конфигами. Смысл в том, что все изменения Вы делаете предварительно в самом скрипте и получаете возможность быстрой установки Arch Linux с вашими личными настройками (при условии, что Вы его изменили под себя, в противном случае с моими настройками).${RED}

 ***************************** ВНИМАНИЕ! ***************************** 
${NC} 
Автор не несёт ответственности за любое нанесение вреда при использовании скрипта. 
Вы используйте его на свой страх и риск, или изменяйте под свои личные нужды."
}

# Команды по установке :
# archiso login: root (automatic login)

echo -e "${RED}=> ${NC}Acceptable limit for the list of arguments..."
# Допустимый лимит (предел) списка аргументов...'
getconf ARG_MAX

echo -e "${BLUE}:: ${NC}The determination of the final access rights"
# Определение окончательных прав доступа
# Для суперпользователя (root) umask по умолчанию равна 0022
umask     

echo -e "${BLUE}:: ${NC}Install the Terminus font"
# Установим шрифт Terminus
pacman -Sy terminus-font --noconfirm
#pacman -Syy terminus-font

echo ""
echo -e "${BLUE}:: ${NC}Setting up the Russian language, changing the console font to one that supports Cyrillic for ease of use" 
# Настроим русский язык, изменим консольный шрифт на тот, который поддерживает кириллицу для удобства работы
loadkeys ru
setfont cyr-sun16
#setfont ter-v16b
#setfont ter-v20b  # Шрифт терминус и русская локаль # чтобы шрифт стал побольше
### setfont ter-v22b

#echo ""
echo -e "${CYAN}==> ${NC}Добавим русскую локаль в систему установки"
# Adding a Russian locale to the installation system
sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen

echo -e "${BLUE}:: ${NC}Обновим текущую локаль системы"
# Update the current system locale
locale-gen  # Мы ввели locale-gen для генерации тех самых локалей.

sleep 01
echo -e "${BLUE}:: ${NC}Указываем язык системы"
export LANG=ru_RU.UTF-8
#export LANG=en_US.UTF-8

echo -e "${BLUE}:: ${NC}Проверяем, что все заявленные локали были созданы:"
locale -a

echo ""
echo -e "${GREEN}=> ${NC}Убедитесь, что сетевой интерфейс указан и включен" 
echo " Показать все ip адреса и их интерфейсы "
ip a  # Смотрим какие у нас есть интернет-интерфейсы
 
echo ""
echo -e "${GREEN}=> ${NC}Для проверки интернета можно пропинговать какой-либо сервис" 
ping -c2 archlinux.org

echo -e "${CYAN}==> ${NC}Если пинг идёт едем дальше ... :)"

#################################################################

### Display banner (Дисплей баннер)
_arch_fast_install_banner

sleep 02
echo ""
### Installing ArchLinux 
echo -e "${GREEN}==> ${NC}Вы готовы приступить к установке Arch Linux? "
while
echo " Действия ввода, выполняется сразу после нажатия клавиши " 
    read -n1 -p " 
    1 - Да приступить,    0 - Нет отменить: " hello  # sends right after the keypress; # отправляет сразу после нажатия клавиши  
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

echo -e "${BLUE}:: ${NC}Установка и настройка начата в $(date +%T)" 

echo -e "${BLUE}:: ${NC}Синхронизация системных часов"  
timedatectl set-ntp true  # Синхронизируем наши системные часы, включаем ntp, если надо сменим часовой пояс

echo -e "${BLUE}:: ${NC}Посмотрим статус службы NTP (NTP service)"
timedatectl status 

echo -e "${BLUE}:: ${NC}Посмотрим дату и время без характеристик для проверки времени"
date

### Если ли вам нужен этот пункт в скрипте, то раскомментируйте ниже в меню все тройные решётки (###)

###echo ""
###echo -e "${YELLOW}==> ${NC}Обновить и добавить новые ключи?"
###echo " Данный этап поможет вам избежать проблем с ключами Pacmаn, если Вы используете не свежий образ ArchLinux для установки! "
###echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, можно пропустить запуск обновления ключей. "
###echo -e "${RED}==> ${BOLD}Примечание: - Иногда при запуске обновления ключей возникает ошибка, не переживайте просто перезапустите работу скрипта (sh -название скрипта-)${NC}"
###echo -e "${RED}==> ${BOLD}Примечание: - Лучше ПРОПУСТИТЕ этот пункт!"
###echo ""
###while
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
pacman -Sy --noconfirm

echo ""
echo -e "${BLUE}:: ${NC}Dmidecode. Получаем информацию о железе"
echo " DMI (Desktop Management Interface) - интерфейс (API), позволяющий программному обеспечению собирать данные о характеристиках компьютера. "
pacman -S dmidecode --noconfirm 

echo ""
echo -e "${BLUE}:: ${NC}Смотрим информацию о BIOS"
dmidecode -t bios  # BIOS – это предпрограмма (код, вшитый в материнскую плату компьютера)
#dmidecode --type BIOS


##### Если ли надо раскомментируйте нужные вам значения #####

#echo -e "${BLUE}:: ${NC}Смотрим информацию о материнской плате"
#dmidecode -t baseboard
#dmidecode --type baseboard

#echo -e "${BLUE}:: ${NC}Смотрим информацию о разьемах на материнской плате"
#dmidecode -t connector
#dmidecode --type connector

#echo -e "${BLUE}:: ${NC}Информация о установленных модулях памяти и колличестве слотов под нее"
#echo " Информация об оперативной памяти "
#dmidecode -t memory
#dmidecode --type memory

#echo -e "${BLUE}:: ${NC}Смотрим информацию об аппаратном обеспечении"
#echo " Информация о переключателях системной платы "
#dmidecode -t system
#dmidecode --type system

#echo -e "${BLUE}:: ${NC}Смотрим информацию о центральном процессоре (CPU)"
#dmidecode -t processor
#dmidecode --type processor
##############################################################

#sleep 01
echo -e "${BLUE}:: ${NC}Просмотреть объём используемой и свободной оперативной памяти, имеющейся в системе"
free -m

echo ""
echo -e "${BLUE}:: ${NC}Посмотрим список установленных SCSI-устройств"
echo " Список устройств scsi/sata "
lsscsi

echo ""
echo -e "${BLUE}:: ${NC}Смотрим, какие диски есть в нашем распоряжении"
lsblk -f

echo ""
echo -e "${BLUE}:: ${NC}Посмотрим структуру диска созданного установщиком"
# Let's look at the disk structure created by the installer
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " => Укажите диск (sda/sdb например sda или sdb) : " cfd
sgdisk -p /dev/$cfd  #sda sdb sdc sdd

echo ""
echo -e "${RED}==> ${NC}Удалить (стереть) таблицу разделов на выбранном диске (sdX)?"
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да удалить таблицу разделов ,    0 - Нет пропустить: " sgdisk  # sends right after the keypress; # отправляет сразу после нажатия клавиши 
    echo ''
    [[ "$sgdisk" =~ [^10] ]]
do
    :
done
if [[ $sgdisk == 1 ]]; then
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "    
read -p " => Укажите диск (sda/sdb например sda или sdb) : " cfd
sgdisk --zap-all /dev/$cfd   #sda sdb sdc sdd
  echo " Создание новых записей GPT в памяти. "
  echo " Структуры данных GPT уничтожены! Теперь вы можете разбить диск на разделы с помощью fdisk или других утилит. " 
elif [[ $sgdisk == 0 ]]; then
  echo 'Операция пропущена.'
fi

#clear
echo -e "${MAGENTA}
  <<< Вся разметка диска(ов) производится только в cfdisk! >>>
${NC}"

echo -e "${YELLOW}:: ${BOLD}Здесь Вы также можете подготовить разделы для Windows (ntfs/fat32)(С;D;E), и в дальнейшем после разбиения диска(ов), их примонтировать. ${NC}"
echo -e "${GREEN}==> ${NC}Создание разделов диска для установки ArchLinux"
echo -e "${BLUE}:: ${NC}Вам нужна разметка диска?"
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да приступить к разметке,    0 - Нет пропустить разметку: " cfdisk  # файл устройство дискового накопителя;  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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

##### Ещё раз проверте правильность разбивки на разделы! #####
clear 
echo "" 
echo -e "${BLUE}:: ${NC}Ваша разметка диска" 
fdisk -l
lsblk -f
#lsblk -lo 

sleep 02
clear
echo ""
echo -e "${GREEN}==> ${NC}Форматирование разделов диска"
echo -e "${BLUE}:: ${NC}Установка название флага boot,root,swap,home"
echo -e "${BLUE}:: ${NC}Монтирование разделов диска"
########## Root  ########
#clear
lsblk -f
echo ""
echo -e "${BLUE}:: ${NC}Форматируем и монтируем ROOT раздел?"
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
echo " Если таковой был создан при разметке в cfdisk "
echo " 1 - Форматировать и монтировать на отдельный раздел "
echo " 2 - Пропустить если BOOT раздела нет на отдельном разделе, и он находится в корневом разделе ROOT "
while
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
echo " Если таковой был создан при разметке в cfdisk "
while
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
echo " Если таковой был создан при разметке в cfdisk "
echo -e "${CYAN}=> ${NC}Можно использовать раздел от предыдущей системы (и его не форматировать)! "
echo -e "${MAGENTA}:: ${BOLD}Далее в процессе установки в сценарии будет Пункт, в котором можно будет удалить все скрытые файлы и папки в каталоге пользователя "home/USERNAME" (от предыдущей системы). ${NC}" 
while
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
while
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

clear
echo -e "${CYAN}
  <<< Добавление (монтирование) разделов Windows (ntfs/fat32) >>>
${NC}"
##### Windows partitions #####
echo -e "${GREEN}==> ${NC}Добавим разделы для Windows (ntfs/fat32)?"
echo -e "${MAGENTA}=> ${BOLD}Если таковые были созданы во время разбиения вашего диска(ов) на разделы cfdisk! ${NC}"
while
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
echo " Если таковой был создан при разметке в cfdisk "
while 
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
echo " Если таковой был создан при разметке в cfdisk "
while 
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
echo " Если таковой был создан при разметке в cfdisk "
while
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
###################################

echo ""
echo -e "${BLUE}:: ${NC}Просмотреть подключённые диски с выводом информации о размере и свободном пространстве"
df -h
#df -hT

echo ""
echo -e "${BLUE}:: ${NC}Просмотреть все идентификаторы наших разделов"
blkid

echo ""
echo -e "${BLUE}:: ${NC}Просмотреть информацию об использовании памяти в системе"
free -h
sleep 02

echo ""
echo -e "${BLUE}:: ${NC}Посмотреть содержмое каталога /mnt."
ls /mnt
#ls -l /mnt

echo ""
echo -e "${BLUE}:: ${NC}Выбор серверов-зеркал для загрузки. Ставим зеркало от Яндекс"
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

echo -e "${BLUE}:: ${NC}Создание (backup) резервного списка зеркал mirrorlist - (mirrorlist.backup)"
cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

echo -e "${BLUE}:: ${NC}Посмотреть список серверов-зеркал для загрузки в mirrorlist"
cat /etc/pacman.d/mirrorlist

echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов" 
sudo pacman -Sy 

###### Install Base System  #############
clear
echo ""
echo -e "${GREEN}==> ${NC}Установка основных пакетов (base, base-devel) базовой системы"
echo -e "${BLUE}:: ${NC}Arch Linux, Base devel (AUR only)"
echo " Сценарий pacstrap устанавливает (base) базовую систему. Для сборки пакетов из AUR (Arch User Repository) также требуется группа base-devel. "
echo -e "${MAGENTA}=> ${BOLD}Т.е., Если нужен AUR, ставь base и base-devel, если нет, то ставь только base. ${NC}"
echo " Огласите весь список, пожалуйста! :) "
echo " 1 - base + base-devel + packages (пакеты небходимые для сетевых настроек, и консольный текстовый редактор: - dhcpcd netctl which inetutils nano vim ), то выбирайте вариант - "1". "  #wget
echo " 2 - base + packages (пакеты небходимые для сетевых настроек, и консольный текстовый редактор: - dhcpcd netctl which inetutils nano vim), то выбирайте вариант - "2". "   #wget
echo " 3 - base + base-devel (установятся группы, Т.е. base и base-devel, без каких либо дополнительных пакетов), то выбирайте вариант - "3". "
echo " 4 - base (установится группа, состоящая из определённого количества пакетов, Т.е. просто base, без каких либо дополнительных пакетов), то выбирайте вариант - "4". "
echo " Будьте осторожны! Если Вы сомневаетесь в своих действиях, можно установить (base + packages), а group-(группы) base-devel установить позже. "
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления" 
echo " Чтобы исключить ошибки в работе системы рекомендую вариант - "1" "
echo ""
while
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
clear
  echo ""
  echo " Установка выбранного вами, групп (base + base-devel + packages) выполнена "
elif [[ $x_pacstrap == 2 ]]; then
  clear
  echo ""
  echo " Установка выбранного вами, группы "
  pacstrap /mnt base nano vim dhcpcd netctl which inetutils #wget
#  pacstrap /mnt base
#  pacstrap /mnt nano vim dhcpcd netctl which inetutils #wget
clear
  echo ""
  echo " Установка выбранного вами, групп (base + packages) выполнена "
elif [[ $x_pacstrap == 3 ]]; then
  clear
  echo ""
  echo " Установка выбранных вами групп "
  pacstrap /mnt base base base-devel
#  pacstrap /mnt base  
#  pacstrap /mnt base-devel
#  pacstrap /mnt --needed base-devel 
clear
  echo ""
  echo " Установка выбранного вами, групп (base + base-devel) выполнена "  
elif [[ $x_pacstrap == 4 ]]; then
  clear
  echo ""
  echo " Установка выбранной вами группы "
  pacstrap /mnt base 
  clear
  echo ""
  echo " Установка выбранной вами, группы (base) выполнена "
fi 

### Install Kernel
#### Kernel (optional) - (Kernel (arbitrary) #####
#clear
echo ""
echo -e "${GREEN}==> ${NC}Какое ядро (Kernel) Вы бы предпочли установить вместе с системой Arch Linux?"
#echo 'Какое ядро (Kernel) Вы бы предпочли установить вместе с системой Arch Linux?'
# Which kernel) Would you prefer to install with the Arch Linux system?
echo -e "${BLUE}:: ${NC}Kernel (optional), Firmware"
#echo 'Kernel (optional), Firmware'
echo " Дистрибутив Arch Linux основан на ядре Linux. Помимо основной стабильной (stable) версии в Arch Linux можно использовать некоторые альтернативные ядра. "
# The ArchLinux distribution is based on the Linux kernel. In addition to the main stable version, some alternative kernels can be used in Arch Linux.
echo -e "${MAGENTA}=> ${BOLD}Выбрать-то можно, но тут главное не пропустить установку ядра :) ${NC}"
# You can choose something, but the main thing is not to skip the installation of the core :)
echo " Огласите весь список, пожалуйста! :) "
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
 echo " Установка выбранного вами ядра (linux) "
 pacstrap /mnt linux linux-firmware # linux-headers
 clear
 echo ""
echo " Ядро (linux) операционной системы установленно "
# echo " Настройка системы, генерируем fstab "
#  genfstab -pU /mnt >> /mnt/etc/fstab  
elif [[ $x_pacstrap == 2 ]]; then
  clear
  echo ""
  echo " Установка выбранного вами ядра (linux-hardened) "
  pacstrap /mnt linux-hardened linux-firmware 
  clear
  echo ""
echo " Ядро (linux-hardened) операционной системы установленно "
# echo " Настройка системы, генерируем fstab "
#  genfstab -pU /mnt >> /mnt/etc/fstab   
elif [[ $x_pacstrap == 3 ]]; then
  clear
  echo ""
  echo " Установка выбранного вами ядра (linux-lts) "
  pacstrap /mnt linux-lts linux-firmware 
  clear
  echo ""
echo " Ядро (linux-lts) операционной системы установленно "
# echo " Настройка системы, генерируем fstab "
#  genfstab -pU /mnt >> /mnt/etc/fstab  
elif [[ $x_pacstrap == 4 ]]; then
  clear
  echo ""
  echo " Установка выбранного вами ядра (linux-zen) " 
  pacstrap /mnt linux-zen linux-firmware 
  clear
  echo ""
echo " Ядро (linux-zen) операционной системы установленно "
# echo " Настройка системы, генерируем fstab "
#  genfstab -pU /mnt >> /mnt/etc/fstab  
fi
# ------------------------------------------------------------------
# Kernel (Русский)
# https://wiki.archlinux.org/index.php/Kernel_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# ------------------------------------------------------------------

### Set Fstab
echo ""
echo -e "${GREEN}==> ${NC}Настройка системы, генерируем fstab" 
#echo 'Настройка системы, генерируем fstab'
# Configuring the system, generating fstab
echo -e "${MAGENTA}=> ${BOLD}Файл /etc/fstab используется для настройки параметров монтирования различных блочных устройств, разделов на диске и удаленных файловых систем. ${NC}"
# The /etc/fstab file is used to configure mounting parameters for various block devices, disk partitions, and remote file systems.
echo " Таким образом, и локальные, и удаленные файловые системы, указанные в /etc/fstab, будут правильно смонтированы без дополнительной настройки. "
echo -e "${CYAN}:: ${NC}Существует четыре различных схемы для постоянного именования: по метке, по uuid, по id и по пути. Для тех, кто использует диски с таблицей разделов GUID (GPT), существуют ещё две дополнительные схемы: - "Partlabel" и "Parduuid". Вы также можете использовать статические имена устройств с помощью Udev."
echo " Огласите весь список, пожалуйста! :) "
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
echo " Чтобы исключить ошибки в работе системы рекомендую "1" вариант "
# To eliminate errors in the system, I recommend "1" option
echo -e "${MAGENTA}:: ${NC}Преимущество использования метода UUID состоит в том, что вероятность столкновения имен намного меньше, чем с метками. Далее он генерируется автоматически при создании файловой системы."
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
echo -e "${MAGENTA}=> ${BOLD}Если Вы перед запуском скрипта просмотрели его, то может возникнуть резонный вопрос зачем вновь менять список зеркал и обновлять файл mirrorlist, ведь перед установкой основной системы (base base-devel kernel) эта операция уже была выполнена. Это связано с тем что, начиная с релиза Arch Linux 2020.07.01-x86_64.iso в установочный образ был добавлен reflector. Тем самым во время установки основной системы происходит запуск скрипта - reflector, и обновляется ранее прописанный список зеркал в mirrorlist. ${NC}"
# If you looked at the script before running it, you may have a reasonable question why change the list of mirrors again and update the mirrorlist file, because this operation was already performed before installing the main system (base base-devel kernel). This is because, since the release of Arch Linux 2020.07.01-x86_64.iso a reflector was added to the installation image. Thus, during the installation of the main system, the reflector script is launched, and the previously registered list of mirrors in the mirrorlist is updated. You will be presented with several options for changing mirrors to increase the speed of loading packages.
echo " Вам будет представлено несколько вариантов смены зеркал для увеличения скорости загрузки пакетов. "
echo " Огласите весь список, пожалуйста! :) "
# Read out the entire list, please!
echo " 1 - Команда отфильтрует зеркала для 'Russia' по протоколам (https, http), отсортирует их по скорости загрузки и обновит файл mirrorlist. "
echo " 2 - Команда подробно выведет список 50 наиболее недавно обновленных HTTP-зеркал, отсортирует их по скорости загрузки и обновит файл mirrorlist. "
echo " 3 - То же, что и в предыдущем примере, но будут взяты только зеркала, расположенные в Казахстане (Kazakhstan). "
echo " 4 - Команда отфильтрует зеркала для 'Russia', 'Belarus', 'Ukraine', и 'Poland' по протоколам (https, http), отсортирует их по скорости загрузки и обновит файл mirrorlist. "
echo " Будьте внимательны! Не переживайте, перед обновлением зеркал будет сделана копия (backup) предыдущего файла mirrorlist, и в последствии будет сделана копия (backup) нового файла mirrorlist. Эти копии (backup) Вы сможете найти в установленной системе в /etc/pacman.d/mirrorlist - (новый список), и в /etc/pacman.d/mirrorlist.backup (старый список). В данной опции выбор всегда остаётся за вами. "
# Be careful! Don't worry, before updating mirrors, a copy (backup) of the previous mirrorlist file will be made, and later a copy (backup) of the new mirrorlist file will be made. These copies (backup) You can find it in the installed system in /etc/pacman.d/mirrorlist - (new list), and in /etc/pacman.d/mirrorlist.backup (the old list). In this option, the choice is always yours.
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
    1 - Russia (https, http),     2 - 50 HTTP-зеркал,

    3 - Kazakhstan (http),       4 - Russia, Belarus, Ukraine, Poland (https, http), 

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

clear
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
echo -e "${GREEN}==> ${NC}Меняем корень и переходим в нашу недавно скачанную систему (chroot)" 
#echo 'Меняем корень и переходим в нашу недавно скачанную систему (chroot)'
# Change the root and go to our recently downloaded system (chroot)
echo -e "${MAGENTA}=> ${BOLD}Есть три варианта продолжения установки: ${NC}"
  echo " 1 - Если у Вас стабильный трафик интернета (dhcpcd), то выбирайте вариант - "1" "
  echo " 2 - Если у Вас бывают проблемы трафика интернета (wifi), то выбирайте вариант - "2" "
echo -e "${CYAN}:: ${NC}В этих вариантах большого отличия нет, кроме команд выполнения (1вариант curl), (2вариант wget), и ещё во 2-ом варианте вам потребуется ввести команду на запуск скрипта "./archmy2l.sh", а также проверить подключение сети интернет "ping -c2 8.8.8.8" - т.е. пропинговать сеть. " 
echo -e "${YELLOW}:: ${BOLD}Есть ещё 3й способ: команда выполнения как, и в 1ом варианте через (curl), и как во 2-ом варианте вам потребуется ввести команду на запуск скрипта "./archmy2l.sh", а также проверить подключение сети интернет "ping -c2 8.8.8.8" - т.е. пропинговать сеть. ${NC}"
echo " 3 - Альтернативный вариант для (dhcpcd, wifi), если у Вас возникнут проблемы с первыми способами продолжения установки, то рекомендую вариант - "3" "  
echo " Будьте внимательны! В данной опции выбор всегда остаётся за вами. "
# Be careful! In this option, the choice is always yours.
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
  echo -e "${YELLOW}=> ${BOLD}Важно! Для удачного продолжения установки выполните эти пунты: ${NC}"
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
  echo -e "${YELLOW}=> ${BOLD}Важно! Для удачного продолжения установки выполните эти пунты: ${NC}"
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
