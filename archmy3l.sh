#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
# Выполните команду с правами суперпользователя:
#EDITOR=nano visudo

### Installer default language (Язык установки по умолчанию)
#ARCHMY1_LANG="russian"
#ARCHMY2_LANG="russian"
ARCHMY3_LANG="russian"
#ARCHMY4_LANG="russian"

script_path=$(readlink -f ${0%/*})

umask 0022

##################################################################
##### <<<Arch Linux Fast Install LegasyBIOS (arch2020)>>>    #####
##### Скрипты 'arch_2020' созданы на основе 2-х (скриптов):  #####
#####   'ordanax/arch2018', и 'archlinux-script-install' -   #####
##### (Poruncov,Grub-Legacy - 2020).                         #####
##### Скрипт (сценарий) archmy3 является продолжением первой #####
#### части скриптов (archmy1 и archmy2) из серии 'arch_2020'. ####  
#### Этот скрипт находится в процессе 'Внесение поправок в   ####
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

### Warning (Предупреждение)
_warning_banner() {
    echo -e "${YELLOW}
   ====================== ♥ Предупреждение ======================
${NC}
Цель сценария (скрипта) - это установка первоначально необходимого софта (пакетов) и запуск необходимых служб. 
Смысл в том, что все изменения вы делаете предварительно в самом скрипте и получаете возможность быстрой установки утилит (пакетов), которые Вы решили установить (при условии, что Вы его изменили под себя, в противном случае скрипт установит софт (пакеты) прописанный изначально.
В процессе работы сценария (скрипта) Вам будут задаваться вопросы на установку той, или иной утилиты (пакета) - будьте внимательными! В скрипте есть утилиты (пакеты), которые устанавливаются из 'AUR'. Это 'Pacman gui' или 'Octopi', в зависимости от вашего выбора, и т.д.. Сам же 'AUR'-'yay' с помощью скрипта созданного (autor): Alex Creio https://cvc.hashbase.io/ - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/yay-git/), собирается и устанавливается. Остальной софт (пакеты) скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска необходимых служб. В любой ситуации выбор всегда за вами. Вы либо гуляете под дождем, либо просто под ним мокнете.${RED}

  ***************************** ВНИМАНИЕ! ***************************** 
${NC}
Автор не несёт ответственности за любое нанесение вреда при использовании скрипта. 
Вы используйте его на свой страх и риск, или изменяйте под свои личные нужды. 
В данный момент сценарий (скрипта) находится в процессе доработки по прописыванию устанавливаемого софта (пакетов), и небольшой корректировке (Воен. Внесение поправок в наводку орудий по результатам наблюдений с наблюдательных пунктов).
${BLUE}===> ******************************************************* ${NC}"
}

# ============================================================================

### Display banner (Дисплей баннер)
_warning_banner

sleep 7
#echo -e "${MAGENTA}==> ${BOLD}Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети. ${NC}"
#echo 'Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети.'
# If you have a wireless connection, launch nmtui and connect to the network.

echo -e "${GREEN}
  <<< Начинается установка первоначально необходимого софта (пакетов) и запуск необходимых служб для системы Arch Linux >>>
${NC}"
# Installation of utilities (packages) for the Arch Linux system begins

echo -e "${BLUE}:: ${NC}Установка и настройка начата в $(date +%T)" 
#echo "Установка и настройка начата в $(date +%T)"
# Installation and configuration started in $(date +%T)

echo ""
echo -e "${GREEN}=> ${NC}Для проверки интернета можно пропинговать какой-либо сервис"
#echo 'Для проверки интернета можно пропинговать какой-либо сервис'
# To check the Internet, you can ping a service
ping -c2 archlinux.org

echo -e "${CYAN}==> ${NC}Если пинг идёт едем дальше ... :)"
#echo 'Если пинг идёт едем дальше ... :)'
# If the ping goes we go further ... :)

echo ""
echo -e "${MAGENTA}==> ${NC}Давайте проверим наш часовой пояс ... :)"
#echo 'Давайте проверим наш часовой пояс ... :)'
# Let's check our time zone ... :)
timedatectl | grep "Time zone"

echo ""
echo -e "${BLUE}:: ${NC}Узнаем версию и данные о релизе Arch'a ... :) " 
#echo "Узнаем версию и данные о релизе Arch'a ... :)"
# Find out the version and release data for Arch ... :)
cat /proc/version
cat /etc/lsb-release
sleep 02

echo ""
echo -e "${BLUE}:: ${NC}Обновим вашу систему (базу данных пакетов)"
#echo "Обновим вашу систему (базу данных пакетов)"
# Update your system (package database)
echo -e "${YELLOW}:: ${NC}Загружаем базу данных пакетов независимо от того, есть ли какие-либо изменения в версиях или нет."
#echo 'Загружаем базу данных пакетов независимо от того, есть ли какие-либо изменения в версиях или нет.'
# Loading the package database regardless of whether there are any changes in the versions or not.
echo ""
sudo pacman -Syyu  --noconfirm  

# ============================================================

# Замена исходного mirrorlist (зеркал для загрузки) на мой список серверов-зеркал

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

# ============================================================================

echo ""
echo -e "${BLUE}:: ${NC}Создание резервной копии файла /etc/pacman.d/mirrorlist"
#echo 'Создадим резервную копию файла /etc/pacman.d/mirrorlist'
# Creating a backup copy of the file /etc/pacman.d/mirrorlist
#sudo cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
#sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sudo cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old 
# Сохраняем старый список зеркал в качестве резервной копии:
#sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old
# Переименовываем новый список:
#mv /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist
#mv -f ~/mirrorlist /etc/pacman.d/mirrorlist

# ============================================================================

echo ""
echo -e "${BLUE}:: ${NC}Посмотреть список серверов-зеркал для загрузки в mirrorlist"
#echo 'Посмотреть список серверов-зеркал для загрузки в mirrorlist'
# View the list of mirror servers to upload to mirrorlist
cat /etc/pacman.d/mirrorlist
sleep 01

# Pacman Mirrorlist Generator
# https://www.archlinux.org/mirrorlist/
# Эта страница генерирует самый последний список зеркал, возможный для Arch Linux. Используемые здесь данные поступают непосредственно из внутренней базы данных зеркал разработчиков, используемой для отслеживания доступности и уровня зеркалирования. 
# Есть два основных варианта: получить список зеркал с каждым доступным зеркалом или получить список зеркал, адаптированный к вашей географии.

# ============================================================================

echo ""
echo -e "${BLUE}:: ${NC}Загрузка свежего списка зеркал со страницы Mirror Status, и обновляем mirrorlist"
#echo 'Загрузка свежего списка зеркал со страницы Mirror Status, и обновляем mirrorlist'
# Loading a fresh list of mirrors from the Mirror Status page, and updating the mirrorlist
# Чтобы увидеть список всех доступных опций, наберите:
#reflector --help
# Команда отфильтрует пять зеркал, отсортирует их по скорости и обновит файл mirrorlist:
sudo pacman -Sy --noconfirm --noprogressbar --quiet reflector
sudo reflector --verbose --country 'Russia' -l 7 -p https -p http -n 7 --save /etc/pacman.d/mirrorlist.pacnew --sort rate  
#reflector --verbose --country 'Russia' -l 5 -p https -p http -n 5 --sort rate --save /etc/pacman.d/mirrorlist
# Собственные уведомления (notify):
notify-send "mirrorlist обновлен" -i gtk-info

#echo 'Выбор серверов-зеркал для загрузки.'
#echo 'The choice of mirrors to download.'
#pacman -Sy --noconfirm --noprogressbar --quiet reflector
#reflector -c "Russia" -c "Belarus" -c "Ukraine" -c "Poland" -f 5 -l 5 -p https -p http -n 5 --save /etc/pacman.d/mirrorlist --sort rate
#reflector --verbose --country Kazakhstan --country Russia --sort rate --save /etc/pacman.d/mirrorlist

#Команда отфильтрует 12 зеркал russia, отсортирует по скорости и обновит файл mirrorlist
#sudo reflector -c "Russia" -f 12 -l 12 --verbose --save /etc/pacman.d/mirrorlist

#------------------------------------------------------------------------------

# Reflector — скрипт, который автоматизирует процесс настройки зеркал, включающий в себя загрузку свежего списка зеркал со страницы Mirror Status.
# https://www.linuxsecrets.com/archlinux-wiki/wiki.archlinux.org/index.php/Reflector_(%D0%A0%D1%2583%D1%2581%D1%2581%D0%BA%D0%B8%D0%B9).html
# Эта страница сообщает о состоянии всех известных, общедоступных и активных зеркал Arch Linux:
# https://www.archlinux.org/mirrors/status/

# ============================================================================

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

# ============================================================================

echo ""
echo -e "${BLUE}:: ${NC}Удалим старый файл /etc/pacman.d/mirrorlist"
#echo 'Удалим старый файл /etc/pacman.d/mirrorlist'
# Delete the old file /etc/pacman.d/mirrorlist
#rm -rf /etc/pacman.d/mirrorlist
sudo rm -rf /etc/pacman.d/mirrorlist
# Удаления старой резервной копии (если она есть, если нет, то пропустите этот шаг):
#rm /etc/pacman.d/mirrorlist.old
# Удалим mirrorlist из /mnt/etc/pacman.d/mirrorlist
#rm /mnt/etc/pacman.d/mirrorlist 

#echo -e "${BLUE}:: ${NC}Удалите файл /etc/pacman.d/mirrorlist"
#echo 'Удалите файл /etc/pacman.d/mirrorlist'
# Delete files /etc/pacman.d/mirrorlist
#rm -rf /etc/pacman.d/mirrorlist

# ============================================================================

echo ""
echo -e "${BLUE}:: ${NC}Переименуем новый список серверов-зеркал mirrorlist.pacnew в mirrorlist"
#echo 'Переименуем новый список серверов-зеркал mirrorlist.pacnew в mirrorlist'
# Rename the new list of mirror servers mirrorlist. pacnew to mirrorlist
#mv /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist
# Переименовываем новый список:
#sudo mv /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist
sudo mv /etc/pacman.d/mirrorlist.backup /etc/pacman.d/mirrorlist

# ============================================================================

echo ""
echo -e "${BLUE}:: ${NC}Создание резервной копии файла /etc/pacman.d/mirrorlist"
#echo 'Создадим резервную копию файла /etc/pacman.d/mirrorlist'
# Creating a backup copy of the file /etc/pacman.d/mirrorlist
#sudo cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
#sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sudo cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
# Сохраняем старый список зеркал в качестве резервной копии:
#sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old
# Переименовываем новый список:
#mv /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist
#mv -f ~/mirrorlist /etc/pacman.d/mirrorlist

# ============================================================================

echo ""
echo -e "${BLUE}:: ${NC}Посмотреть список серверов-зеркал для загрузки в mirrorlist"
#echo 'Посмотреть список серверов-зеркал для загрузки в mirrorlist'
# View the list of mirror servers to upload to mirrorlist
cat /etc/pacman.d/mirrorlist
sleep 02
# ============================================================================

echo ""
echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов" 
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
# ============================================================================
echo ""
echo -e "${YELLOW}==> ${NC}Создадим папку (downloads), и переходим в созданную папку"
#echo 'Создадим папку (downloads), и переходим в созданную папку'
# Create a folder (downloads), and go to the created folder
#rm -rf ~/.config/xfce4/*
mkdir ~/downloads
cd ~/downloads
clear

echo -e "${MAGENTA}
  <<< Установка AUR (Arch User Repository) - репозиторий, в который пользователи загружают скрипты для установки программного обеспечения >>> 
${NC}"
# Installing an Aur (Arch User Repository) - a repository where users upload scripts to install software.

echo -e "${GREEN}==> ${NC}Установка AUR Helper (yay) или (pikaur)"
#echo -e "${BLUE}:: ${NC}Установка AUR Helper (yay) или (pikaur)" 
#echo 'Установка AUR Helper (yay) или (pikaur)'
# Installing AUR Helper (yay) or (pikaur)
echo -e "${YELLOW}==> ${BOLD}Важно! Pikaur - идёт как зависимость для Octopi. ${NC}"
echo -e "${MAGENTA}:: ${NC} В AUR - есть практически всё, что можно установить на Linux. В том числе и программы, которые для других дистробутивов пришлось бы собирать из исходников"
echo -e "${CYAN}=> ${BOLD}В сценарии скрипта присутствуют следующие варианты: ${NC}"
echo " 1 - Установка 'AUR'-'yay' с помощью скрипта созданного (autor): Alex Creio https://cvc.hashbase.io/ - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/yay-git/), собирается и устанавливается, то выбирайте вариант - "1". "
echo " 2 - Установка 'AUR'-'yay' с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/yay.git), собирается и устанавливается, то выбирайте вариант - "2"."
echo " 3 - Установка 'AUR'-'pikaur' с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/pikaur.git), собирается и устанавливается, то выбирайте вариант - "3". "
echo " Подчеркну (обратить внимание)! Pikaur - идёт как зависимость для Octopi."
echo " Будьте внимательны! В этом действии выбор остаётся за вами."
# Be careful! In this action, the choice is yours.
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления" 
#echo 'Установка производится в порядке перечисления'
# Installation Is performed in the order listed
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - AUR - yay (yay-install.sh), 2 - AUR - yay, 3 - AUR - pikaur, 0 - Пропустить установку AUR Helper: " in_aur_help  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - AUR - yay (yay-install.sh),     2 - AUR - yay (git clone),     3 - AUR - pikaur (git clone),

    0 - Пропустить установку AUR Helper: " in_aur_help  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_aur_help" =~ [^1230] ]]
do
    :
done 
if [[ $in_aur_help == 0 ]]; then
clear    
echo " Установка AUR Helper (yay) пропущена "
elif [[ $in_aur_help == 1 ]]; then
sudo pacman -Syu
wget git.io/yay-install.sh && sh yay-install.sh --noconfirm
clear
echo " Установка AUR Helper (yay) завершена "
# ------------------------------------------------------------
# Скрипт yay-install.sh:
#!/usr/bin/env bash
# Install script yay
# autor: Alex Creio https://cvc.hashbase.io/

# wget git.io/yay-install.sh && sh yay-install.sh
#sudo pacman -S --noconfirm --needed wget curl git 
#git clone https://aur.archlinux.org/yay-bin.git
#cd yay-bin
### makepkg -si
#makepkg -si --skipinteg
#cd ..
#rm -rf yay-bin
# ------------------------------------------------------------
elif [[ $in_aur_help == 2 ]]; then
sudo pacman -Syu
#sudo pacman -S --noconfirm --needed wget curl git
git clone https://aur.archlinux.org/yay.git
cd yay 
makepkg -si --noconfirm 
# makepkg -si
#makepkg -si --skipinteg 
rm -Rf yay
clear
echo " Установка AUR Helper (yay) завершена "
elif [[ $in_aur_help == 3 ]]; then
sudo pacman -Syu
#sudo pacman -S git    
cd /home/$username
git clone https://aur.archlinux.org/pikaur.git
chown -R $username:users /home/$username/pikaur   
chown -R $username:users /home/$username/pikaur/PKGBUILD 
cd /home/$username/pikaur   
sudo -u $username  makepkg -si --noconfirm  
rm -Rf /home/$username/pikaur
clear
echo " Установка AUR Helper (pikaur) завершена "
fi
#--------------------------------------------------------------
# AUR (Arch User Repository) - репозиторий, в который пользователи загружают скрипты для установки программного обеспечения. Там есть практически всё, что можно установить на Linux. В том числе и программы, которые для других дистробутивов пришлось бы собирать из исходников.
# AUR'ом можно пользоваться и просто с помощью Git. Но куда удобнее использовать помощник AUR. Они бывают графические и консольные.
# Загвоздка в том, что все помощники доступны только в самом AUR 😅 Поэтому будем устанавливать через Git, так как по-сути, AUR состоит из git-репозиториев
# git clone https://aur.archlinux.org/yay-bin.git
# Если хотите, чтобы yay собирался из исходников, вместо yay-bin.git впишите yay.git.
# https://aur.archlinux.org/packages/yay-bin/
# https://aur.archlinux.org/packages/
# https://github.com/Jguer/yay
# ============================================================================

echo ""
echo -e "${BLUE}:: ${NC}Обновим всю систему включая AUR пакеты" 
#echo 'Обновим всю систему включая AUR пакеты'
# Update the entire system including AUR packages
yay -Syy
yay -Syu

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Snap на Arch Linux?"
#echo -e "${BLUE}:: ${NC}Установить Snap на Arch Linux?" 
#echo 'Установить Snap на Arch Linux?'
# To install Snap-on Arch Linux?
echo -e "${MAGENTA}:: ${BOLD}Snap - это инструмент для развертывания программного обеспечения и управления пакетами,  которые обновляются автоматически, просты в установке, безопасны, кроссплатформенны и не имеют зависимостей. Изначально разработанный и созданный компанией Canonical, который работает в различных дистрибутивах Linux каждый день. ${NC}"
echo -e "${CYAN}:: ${NC}Для управления пакетами snap, установим snapd (демон), а также snap-confine, который обеспечивает монтирование, изоляцию и запуск snap-пакетов.  "
echo " Установка происходит из 'AUR'- с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/snapd.git)."
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В любой ситуации выбор всегда остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " prog_set  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_set" =~ [^10] ]]
do
    :
done 
if [[ $prog_set == 0 ]]; then    
echo " Установка Snap пропущена "
elif [[ $prog_set == 1 ]]; then
echo -e " Установка базовых программ и пакетов wget, curl, git "
#sudo pacman -S --noconfirm --needed wget curl git 
echo " Установка поддержки Snap "
git clone https://aur.archlinux.org/snapd.git
cd snapd
# makepkg -si
makepkg -si --skipinteg
#makepkg -si --noconfirm
cd ..  
rm -Rf snapd
clear
echo " Установка Snapd выполнена "
fi
########## Запускаем поддержку Snap ###############
echo ""
echo -e "${BLUE}:: ${NC}Включить модуль systemd, который управляет основным сокетом мгновенной связи" 
sudo systemctl enable --now snapd.socket
# Проверить статус сервиса:
# systemctl status snapd.socket
echo ""
echo -e "${BLUE}:: ${NC}Включить поддержку классической привязки, чтобы создать символическую ссылку между /var/lib/snapd/ snap и /snap" 
sudo ln -s /var/lib/snapd/snap /snap
echo ""
echo -e "${BLUE}:: ${NC}Поскольку бинарный файл находится в каталоге /snap/bin/, нужно добавить его в переменную $PATH." 
echo "export PATH=\$PATH:\/snap/bin/" | sudo tee -a /etc/profile
source /etc/profile
echo ""
echo " Snapd теперь готов к использованию "
echo " Вы взаимодействуете с ним с помощью команды snap. "
# Посмотрите страницу помощи команды:
# snap --help
echo ""
echo -e "${BLUE}:: ${NC}Протестируем систему, установив hello-world snap и убедимся, что она работает правильно."
#sudo snap install hello-world
snap install hello-world
hello-world
echo ""
echo -e "${BLUE}:: ${NC}Список установленных snaps:"
snap list
echo -e "${BLUE}:: ${NC}Удалить установленный snap (hello-world)"
sudo snap remove hello-world
echo ""
echo " Snap теперь установлен и готов к работе! "

#clear
echo ""
echo -e "${GREEN}==> ${NC}Ставим Bluetooth и Поддержка звука"
#echo -e "${BLUE}:: ${NC}Ставим Bluetooth и Поддержка звука" 
#echo 'Ставим Bluetooth и Поддержка звука'
# Setting Bluetooth and Sound support
echo -e "${CYAN}=> ${BOLD}Установка поддержки Bluetooth и Sound support (звука) - будет очень актуальна, если Вы установили DE (среда рабочего стола) XFCE. ${NC}"
echo -e "${BLUE} 'Список программ (пакетов) для установки:${GREEN}
bluez bluez-libs bluez-cups bluez-utils alsa-utils alsa-plugins alsa-firmware alsa-lib alsa-utils pulseaudio pulseaudio-alsa pavucontrol pulseaudio-zeroconf pulseaudio-bluetooth xfce4-pulseaudio-plugin' ${NC}"
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В любой ситуации выбор всегда остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " prog_set  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_set" =~ [^10] ]]
do
    :
done 
if [[ $prog_set == 0 ]]; then    
echo " Установка поддержки Bluetooth и Sound support (звука) пропущена "
elif [[ $prog_set == 1 ]]; then
  echo " Установка поддержки Bluetooth и Sound support (звука) "
sudo pacman -S bluez bluez-libs bluez-cups bluez-utils --noconfirm
#sudo pacman -S blueman --noconfirm  # blueman --диспетчер bluetooth устройств (полезно для i3)
sudo pacman -S alsa-utils alsa-plugins alsa-firmware alsa-lib alsa-utils --noconfirm 
sudo pacman -S pulseaudio pulseaudio-alsa pavucontrol pulseaudio-zeroconf pulseaudio-bluetooth xfce4-pulseaudio-plugin --noconfirm #pulseaudio-equalizer-ladspa 
#sudo pacman -Sy pulseaudio-bluetooth alsa-utils pulseaudio-equalizer-ladspa   --noconfirm
#sudo systemctl enable bluetooth.service 
fi

#clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Blueman - диспетчер bluetooth устройств?"
#echo -e "${BLUE}:: ${NC}Установить Blueman - диспетчер bluetooth устройств?" 
#echo 'Установить Blueman - диспетчер bluetooth устройств?'
# Install Blueman-bluetooth device Manager?
echo -e "${CYAN}:: ${BOLD}Blueman - это полнофункциональный менеджер Bluetooth, написанный на GTK. "
echo -e "${YELLOW}:: ${NC}Обязательно включите демон Bluetooth и запустите Blueman с blueman-applet. Графическую панель настроек можно запустить с помощью blueman-manager."
echo " Чтобы получать файлы, не забудьте щелкнуть правой кнопкой мыши значок Blueman на панели задач> Локальные службы> Передача> Получение файлов (Object Push) и установить флажок « Принимать файлы с доверенных устройств». "
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В любой ситуации выбор всегда остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " prog_set  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_set" =~ [^10] ]]
do
    :
done 
if [[ $prog_set == 0 ]]; then 
clear   
echo " Установка Blueman пропущена "
elif [[ $prog_set == 1 ]]; then  
  echo " Установка Blueman (менеджер Bluetooth) "
sudo pacman -S blueman --noconfirm  # blueman --диспетчер bluetooth устройств (полезно для i3)
clear
echo " Установка Blueman (менеджер Bluetooth) завершена "
fi
# -------------------------------------------------------------------
# Blueman:
# https://wiki.archlinux.org/index.php/Blueman
# --------------------------------------------------------------------

echo ""
echo -e "${GREEN}==> ${NC}Ставим Архиваторы - Компрессионные Инструменты и дополнения"
#echo -e "${BLUE}:: ${NC}Ставим Архиваторы - Компрессионные Инструменты и дополнения" 
#echo 'Ставим Архиваторы - "Компрессионные Инструменты" и дополнения'
# Installing Archivers-Compression Tools and add-ons
sudo pacman -S zip unzip unrar p7zip zlib zziplib --noconfirm 

echo "" 
echo -e "${BLUE}:: ${NC}Ставим дополнения к Архиваторам" 
#echo 'Ставим дополнения к Архиваторам'
# Adding extensions to Archivers
sudo pacman -S lha unace lrzip sharutils uudeview arj cabextract file-roller --noconfirm  #file-roller #ark
#file-roller легковесный архиватор ( для xfce-lxqt-lxde-gnome ) 
#ark - архиватор для ( Plasma(kde)- так же можно использовать, и для другого de )

echo ""
echo -e "${GREEN}==> ${NC}Ставим Драйвера принтера (Поддержка печати) CUPS, HP"
#echo -e "${BLUE}:: ${NC}Ставим Драйвера принтера (Поддержка печати) CUPS, HP" 
#echo 'Ставим Драйвера принтера (Поддержка печати) CUPS, HP'
# Putting the printer Drivers (Print support) CUPS, HP
echo -e "${MAGENTA}:: ${BOLD}CUPS- это стандартная система печати с открытым исходным кодом, разработанная Apple Inc. для MacOS® и других UNIX® - подобных операционных систем. Драйверы принтеров CUPS состоят из одного или нескольких фильтров, упакованных в формате PPD (PostScript Printer Description). ${NC}"
echo -e "${CYAN}:: ${NC}Все принтеры в CUPS (даже не поддерживающие PostScript) должны иметь файл PPD с описанием принтеров, специфических команд и фильтров."
echo " В комплект поставки CUPS входят универсальные файлы PPD для сотен моделей принтеров."
echo -e "${CYAN}:: ${NC}HP - Драйверы для DeskJet, OfficeJet, Photosmart, Business Inkjet и некоторых лазерных принтеров."
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В любой ситуации выбор всегда остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " prog_set  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_set" =~ [^10] ]]
do
    :
done 
if [[ $prog_set == 0 ]]; then    
echo " Установка поддержки Драйвера принтера (Поддержка печати) пропущена "
elif [[ $prog_set == 1 ]]; then
  echo " Установка поддержки Драйвера принтера (Поддержка печати) CUPS "
sudo pacman -S cups ghostscript cups-pdf --noconfirm   
sudo pacman -S gsfonts gutenprint hplip --noconfirm   # python-imaging 
fi
# ---------------------------------------------------------------------
# List of applications:
# https://wiki.archlinux.org/index.php/List_of_applications
# CUPS (Русский)-
# https://wiki.archlinux.org/index.php/CUPS_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# CUPS (Русский)/Printer-specific problems (Русский)
# https://wiki.archlinux.org/index.php/CUPS_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)/Printer-specific_problems_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# Arch Linux: cups и hplip - подключение принтера
# https://rtfm.co.ua/arch-linux-cups-i-hplip-podklyuchenie-printera/
# ------------------------------------------------------------------------

echo ""
echo -e "${BLUE}:: ${NC}Установка базовых программ и пакетов" 
#echo 'Установка базовых программ и пакетов'
# Installing basic programs and packages
sudo pacman -S aspell-ru arch-install-scripts bash-completion dosfstools f2fs-tools sane gvfs gnu-netcat htop iftop iotop nmap ntfs-3g ntp ncdu hydra isomd5sum python-isomd5sum translate-shell mc pv reflector sox youtube-dl speedtest-cli python-pip pwgen scrot curl xsel --noconfirm  #git

echo ""
echo -e "${BLUE}:: ${NC}Установка терминальных утилит для вывода информации о системе" 
#echo 'Установка терминальных утилит для вывода информации о системе'
# Installing terminal utilities for displaying system information
sudo pacman -S screenfetch archey3 neofetch --noconfirm  

echo ""
echo -e "${BLUE}:: ${NC}Установка Мультимедиа кодеков (multimedia codecs), и утилит" 
#echo 'Установка Мультимедиа кодеков (multimedia codecs), и утилит'
# Installing Multimedia codecs and utilities
sudo pacman -S a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-bad gst-plugins-ugly libdvdcss libdvdread libdvdnav dvd+rw-tools dvdauthor dvgrab cdrdao gst-libav gst-libav gpac --noconfirm

echo ""
echo -e "${BLUE}:: ${NC}Установка Мультимедиа утилит" 
#echo 'Установка Мультимедиа утилит'
# Installing Multimedia utilities
sudo pacman -S audacity audacious audacious-plugins smplayer smplayer-skins smplayer-themes smtube deadbeef easytag subdownloader mediainfo-gui vlc --noconfirm

echo ""
echo -e "${BLUE}:: ${NC}Установка Текстовые редакторы и утилиты разработки" 
#echo 'Установка Текстовые редакторы и утилиты разработки'
# Installation Text editors and development tools
sudo pacman -S gedit gedit-plugins geany geany-plugins --noconfirm

echo ""
echo -e "${BLUE}:: ${NC}Управления электронной почтой, новостными лентами, чатом и группам" 
#echo 'Управления электронной почтой, новостными лентами, чатом и группам'
# Manage email, news feeds, chat, and groups
sudo pacman -S thunderbird thunderbird-i18n-ru pidgin pidgin-hotkeys --noconfirm

echo ""
echo -e "${BLUE}:: ${NC}Установка Браузеров и медиа-плагинов" 
#echo 'Установка Браузеров и медиа-плагинов'
# Installing Browsers and media plugins
sudo pacman -S firefox firefox-i18n-ru firefox-spell-ru flashplugin pepper-flash --noconfirm

#clear
echo ""
echo -e "${GREEN}==> ${NC}Установка Брандмауэра UFW и Антивирусного пакета ClamAV (GUI)(GTK+)"
#echo -e "${BLUE}:: ${NC}Установка Брандмауэра UFW и Антивирусного пакета ClamAV (GUI)(GTK+)" 
#echo 'Установка Брандмауэра UFW и Антивирусного пакета ClamAV (GUI)(GTK+)'
# Installing the UFW Firewall and clamav Antivirus package (GUI) (GTK+)
# Ufw расшифровывается как Uncomplicated Firewall и представляет собой программу для управления межсетевым экраном netfilter. Он предоставляет интерфейс командной строки и стремится быть несложным и простым в использовании.
echo -e "${BLUE}:: ${NC}Установка производится в порядке перечисления" 
#echo 'Установка производится в порядке перечисления'
# Installation Is performed in the order listed
echo -e "${GREEN}==> ${NC}Установить UFW (Несложный Брандмауэр) (GTK)?"
#echo 'Установить UFW (Несложный Брандмауэр) (GTK)?'
# Install UFW (Uncomplicated Firewall) (GTK)?
read -p " 1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -S ufw gufw --noconfirm
echo " Установка Брандмауэра UFW завершена "
elif [[ $prog_set == 0 ]]; then
  echo ' Установка программ пропущена. '
fi

echo ""
echo -e "${GREEN}==> ${NC}Установить Clam AntiVirus (GTK)?"
#echo 'Установить Clam AntiVirus (GTK)?'
# Install Clam AntiVirus (GTK)?
read -p " 1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -S clamav clamtk --noconfirm
echo " Установка Clam AntiVirus завершена "
elif [[ $prog_set == 0 ]]; then
  echo ' Установка программ пропущена. '
fi
# --------------------------------------------------
# Uncomplicated Firewall
# https://wiki.archlinux.org/index.php/Uncomplicated_Firewall
# ufw home:
# https://launchpad.net/ufw
# Категория: Межсетевые экраны
# https://wiki.archlinux.org/index.php/Category:Firewalls
# ----------------------------------------------------------

echo ""
echo -e "${BLUE}:: ${NC}Установка Torrent клиентов - Transmission, qBittorrent, Deluge (GTK)(Qt)(GTK+)" 
#echo 'Установка Torrent клиентов - Transmission, qBittorrent, Deluge (GTK)(Qt)(GTK+)'
# Installing Torrent clients - Transmission, qBittorrent, Deluge (GTK) (Qt) (GTK+)
echo -e "${BLUE}:: ${NC}Установка производится в порядке перечисления" 
#echo 'Установка производится в порядке перечисления'
# Installation Is performed in the order listed
echo -e "${GREEN}==> ${NC}Установить Transmission, qBittorrent, Deluge?"
#echo 'Установить Transmission, qBittorrent, Deluge?'
# Install Transmission, qBittorrent, Deluge?
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
read -p " 1 - Transmission, 2 - qBittorrent, 3 - Deluge, 0 - Нет пропустить этот шаг: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -S transmission-gtk transmission-cli --noconfirm
echo " Установка Transmission завершена "
elif [[ $prog_set == 2 ]]; then
sudo pacman -S qbittorrent --noconfirm
echo " Установка qBittorrent завершена "
elif [[ $prog_set == 3 ]]; then
sudo pacman -S deluge --noconfirm
echo " Установка Deluge завершена "
elif [[ $prog_set == 0 ]]; then
  echo ' Установка программ пропущена. '
fi

echo ""
echo -e "${BLUE}:: ${NC}Установка Офиса (LibreOffice-still, или LibreOffice-fresh)" 
#echo 'Установка Офиса (LibreOffice-still, или LibreOffice-fresh)'
# Office installation (LibreOffice-still, or LibreOffice-fresh)
echo -e "${BLUE}:: ${NC}Установка производится в порядке перечисления" 
#echo 'Установка производится в порядке перечисления'
# Installation Is performed in the order listed
echo -e "${GREEN}==> ${NC}Установить LibreOffice-still, LibreOffice-fresh?"
#echo 'Установить LibreOffice-still, LibreOffice-fresh?'
# Install the LibreOffice-still and LibreOffice-fresh?
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
read -p " 1 - LibreOffice-still, 2 - LibreOffice-fresh, 0 - Нет пропустить этот шаг: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -S libreoffice-still libreoffice-still-ru --noconfirm
echo " Установка LibreOffice-still завершена "
elif [[ $prog_set == 2 ]]; then
sudo pacman -S libreoffice libreoffice-fresh-ru --noconfirm
echo " Установка LibreOffice-fresh завершена "
elif [[ $prog_set == 0 ]]; then
  echo ' Установка программ LibreOffice пропущена. '
fi

echo ""
echo -e "${GREEN}==> ${BOLD}Установить рекомендованные программы? ${NC}"
#echo 'Установить рекомендованные программы?'
# Install the recommended programs
echo -e "${BLUE}
'Список программ рекомендованных к установке:${GREEN}
bleachbit gparted grub-customizer conky conky-manager dconf-editor doublecmd-gtk2 gnome-system-monitor obs-studio openshot flameshot frei0r-plugins redshift veracrypt onboard clonezilla moc filezilla gnome-calculator nomacs osmo synapse telegram-desktop plank psensor keepass copyq variety grsync numlockx modem-manager-gui uget xarchiver-gtk2 rofi gsmartcontrol testdisk glances tlp tlp-rdw meld cmake xterm lsof dmidecode' 
${NC}" #xarchiver-gtk2
read -p " 1 - Да установить, 0 - Нет пропустить: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -S bleachbit gparted grub-customizer conky conky-manager dconf-editor doublecmd-gtk2 gnome-system-monitor obs-studio openshot flameshot frei0r-plugins redshift veracrypt onboard clonezilla moc filezilla gnome-calculator nomacs osmo synapse telegram-desktop plank psensor keepass copyq variety grsync numlockx modem-manager-gui uget rofi gsmartcontrol testdisk glances tlp tlp-rdw meld cmake xterm lsof dmidecode --noconfirm  #xarchiver-gtk2
echo " Установка утилит (пакетов) завершена " 
elif [[ $prog_set == 0 ]]; then
  echo ' Установка программ пропущена. '
fi

echo ""
echo -e "${GREEN}==> ${NC}Утилиты для форматирования флэш-накопителя с файловой системой exFAT в Linux"
#echo -e "${BLUE}:: ${NC}Утилиты для форматирования флэш-накопителя с файловой системой exFAT в Linux" 
#echo 'Утилиты для форматирования флэш-накопителя с файловой системой exFAT в Linux'
# Utilities for formatting a flash drive with the exFAT file system in Linux
echo -e "${MAGENTA}:: ${BOLD}Файловая система exFAT разработана Microsoft и предназначена для портативных устрйств, например USB флешки. ${NC}"
echo -e "${CYAN}:: ${NC}Пользователям Windows не стоит переживать о поддержки ее в системе, и они получают поддержку уже сразу после установки "Оффтопика"."
echo " Нам же, пользователям Linux, нужно чуток поработать и тогда будет наш любимый Linux иметь поддержку чтения exFAT."
echo -e "${CYAN}:: ${NC}Для работы exFAT в Linux, нам небоходимо установить пару дополнительных программ."
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В любой ситуации выбор всегда остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " prog_set  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_set" =~ [^10] ]]
do
    :
done 
if [[ $prog_set == 0 ]]; then    
echo " Установка поддержки системой exFAT пропущена "
elif [[ $prog_set == 1 ]]; then
  echo " Установка поддержки системой exFAT в Linux "
sudo pacman -S exfat-utils fuse-exfat --noconfirm  #exfatprogs
fi
# --------------------------------------------------------
# exfat-utils - Утилиты для файловой системы exFAT  - Помечен как устаревший на 2020-04-09
# fuse-exfat - Утилиты для файловой системы exFAT
# exfatprogs - Утилиты файловой системы exFAT файловой системы в пространстве пользователя драйвера ядра Linux файловой системы exFAT
# Форматирую флешку (жесткий диск) под ArchLinux:
# mkfs.exfat /dev/sdc
# В Linux все проходит нормально. Носитель открывается, файлы копируются.
# Теоретический максимальный размер раздела FAT32 - 2 Тб, но Майкрософт начиная с WinXP не позволяет создать больше 32 Гб. exFAT, это модифицированная FAT32, которую можно «развернуть» на разделе более чем 32 Гб.
# --------------------------------------------------------

echo ""
echo -e "${YELLOW}==> ${NC}Установить ssh(server) для удаленного доступа?"
#echo 'Установить ssh(клиент) для удаленного доступа?'
# Install ssh (client) for remote access?
read -p " 1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -S openssh --noconfirm
echo " SSH (клиент) установлен " 
elif [[ $prog_set == 0 ]]; then
  echo ' Установка пропущена. '
fi

echo ""
echo -e "${BLUE}:: ${NC}Установка Pacman gui,Octopi (AUR)(GTK)(QT)" 
#echo 'Установка "Pacman gui","Octopi" (AUR)(GTK)(QT)'
# Installing "Pacman gui", "Octopi" (AUR)(GTK)(QT)
echo -e "${BLUE}:: ${NC}Установка производится в порядке перечисления" 
#echo 'Установка производится в порядке перечисления'
# Installation Is performed in the order listed
echo -e "${GREEN}==> ${NC}Установить pamac-aur, octopi?"
#echo 'Установить "pamac-aur", "octopi"?'
# Install "pacman-aur", "octopi"?
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
read -p " 1 - Pacmac-aur, 2 - Octopi, 0 - Нет пропустить этот шаг: " prog_set
if [[ $prog_set == 1 ]]; then
yay -S pamac-aur --noconfirm
echo " Установка Pacmac-aur завершена "
elif [[ $prog_set == 2 ]]; then
yay -S octopi --noconfirm
echo " Установка Octopi завершена "
elif [[ $prog_set == 0 ]]; then
  echo ' Установка программ пропущена. '
fi

echo ""
echo -e "${BLUE}:: ${NC}Будете ли Вы подключать Android или Iphone к ПК через USB?" 
#echo 'Будете ли Вы подключать Android или Iphone к ПК через USB?'
# Will you connect your Android or Iphone to your PC via USB?
echo ' Установка поддержки устройств на Android или Iphone к ПК через USB '
# Installing support for Android or Iphone devices to a PC via USB
echo -e "${BLUE}:: ${NC}Установка производится в порядке перечисления" 
#echo 'Установка производится в порядке перечисления'
# Installation Is performed in the order listed
echo -e "${GREEN}==> ${NC}Установить утилиты (пакеты) поддержки устройств?"
#echo 'Установить утилиты (пакеты) поддержки устройств?'
# To install the utilities (package) support devices?
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
read -p " 1 - Android, 2 - Iphone, 3 - Оба Варианта, 0 - Пропустить: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -S gvfs-mtp --noconfirm
echo " Установка поддержки устройств на Android завершена "
elif [[ $prog_set == 2 ]]; then
sudo pacman -S gvfs-afc --noconfirm
echo " Установка поддержки устройств на Iphone завершена "
elif [[ $prog_set == 3 ]]; then
sudo pacman -S gvfs-afc gvfs-mtp --noconfirm
echo " Установка поддержки устройств на Android и Iphone завершена "
elif [[ $prog_set == 0 ]]; then
  echo ' Установка утилит (пакетов) пропущена. '
fi
# -------------------------------------------------------
# Пример:
# Подключаю по USB телефон LG Optinus G
# lsusb
# Он монтируется как mtp устройство.
# Виден через наутилус как mtp://[usb:002,007]/
# ============================================================================

clear
echo -e "${CYAN}
  <<< Запуск и добавление установленных программ (пакетов), сервисов и служб в автозапуск. >>> 
${NC}"
# Launch and add installed programs (packages), services, and services to autorun.

#echo ""
echo -e "${BLUE}:: ${NC}Запускаем и добавляем в автозапуск Uncomplicated Firewall UFW (сетевой экран)"
echo -e "${GREEN}==> ${NC}Включить Firewall UFW (сетевой экран)?"
#echo -e "{BLUE}:: ${NC}Включить Firewall UFW (сетевой экран)?"
#echo 'Включить Firewall UFW (сетевой экран)?'
# Enable firewall UFW (firewall)?
echo -e "${YELLOW}:: ${BOLD}Запускаем UFW (сетевой экран), если таковой был вами установлен. ${NC}"
echo -e "${CYAN}:: ${NC}Вы сможете включить UFW (сетевой экран) позже, воспользовавшись скриптом как шпаргалкой!"
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами. "
# Be careful! In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да включить UFW, 0 - НЕТ - Пропустить действие: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да включить UFW,     0 - НЕТ - Пропустить действие: " prog_set  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_set" =~ [^10] ]]
do
    :
done 
if [[ $prog_set == 0 ]]; then    
echo "  Запуск UFW (сетевой экран) пропущено "
elif [[ $prog_set == 1 ]]; then
  echo " Запускаем UFW (сетевой экран) "
sudo ufw enable
fi

echo -e "${GREEN}==> ${NC}Добавляем в автозагрузку Firewall UFW (сетевой экран)?"
#echo -e "{BLUE}:: ${NC}Добавляем в автозагрузку Firewall UFW (сетевой экран)?"
#echo 'Добавляем в автозагрузку Firewall UFW (сетевой экран)?'
# Adding Firewall UFW (firewall) to startup?
echo -e "${YELLOW}:: ${BOLD}Добавляем в автозагрузку UFW (сетевой экран), если таковой был вами установлен. ${NC}"
echo -e "${CYAN}:: ${NC}Вы сможете добавить в автозагрузку UFW (сетевой экран) позже, воспользовавшись скриптом как шпаргалкой!"
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами. "
# Be careful! In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да добавляем в автозагрузку UFW, 0 - НЕТ - Пропустить действие: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да добавляем в автозагрузку UFW,     0 - НЕТ - Пропустить действие: " prog_set  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_set" =~ [^10] ]]
do
    :
done 
if [[ $prog_set == 0 ]]; then    
echo " UFW (сетевой экран) не был добавлен в автозагрузку. "
elif [[ $prog_set == 1 ]]; then
  echo " Добавляем в автозагрузку UFW (сетевой экран) "
sudo systemctl enable ufw
echo " UFW (сетевой экран) успешно добавлен в автозагрузку " 
fi

sleep 01
echo ""
echo -e "${BLUE}:: ${NC}Проверим статус запуска Firewall UFW (сетевой экран)" 
#echo 'Проверим статус запуска Firewall UFW (сетевой экран)'
# Check the startup status of Firewall UFW (network screen)
echo -e "${CYAN}:: ${NC}Если нужно ВЫКлючить UFW (сетевой экран), то используйте команду: sudo ufw disable."
sudo ufw status
#sudo ufw status --verbose
# ----------------------------------------------------------
# Вы можете проверить статус работы UFW следующей командой:
# sudo ufw status verbose  # -v, --verbose  -быть вербальным
# Если нужно выключить, то используйте команду:
# sudo ufw disable
# ------------------------------------------------------------

echo ""
echo -e "${GREEN}==> ${NC}Добавляем в автозагрузку Bluetooth.service?"
#echo 'Добавляем в автозагрузку Bluetooth.service?'
# Adding Bluetooth.service to startup?
echo -e "${YELLOW}:: ${BOLD}Запускаем сервис (bluetooth.service), если таковой был вами установлен. ${NC}"
echo -e "${CYAN}:: ${NC}Вы сможете выполнить запуск (bluetooth.service) позже, воспользовавшись скриптом как шпаргалкой!"
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами. "
# Be careful! In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да добавляем, 0 - НЕТ - Пропустить действие: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да добавляем,     0 - НЕТ - Пропустить действие: " prog_set  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_set" =~ [^10] ]]
do
    :
done 
if [[ $prog_set == 0 ]]; then    
echo "  Bluetooth.service не включен в автозагрузку, при необходиости это можно будет сделать. "
elif [[ $prog_set == 1 ]]; then
  echo " Добавляем в автозагрузку (bluetooth.service) "
sudo systemctl enable bluetooth.service 
echo " Bluetooth успешно добавлен в автозагрузку " 
fi

echo ""
echo -e "${GREEN}==> ${NC}Добавляем в автозагрузку ssh(server) для удаленного доступа к этому ПК?"
#echo 'Добавляем в автозагрузку ssh(server) для удаленного доступа к этому ПК?'
# Adding ssh(server) to the startup for remote access to this PC?
echo -e "${YELLOW}:: ${BOLD}Запускаем сервис (sshd.service), если таковой был вами установлен. ${NC}"
echo -e "${CYAN}:: ${NC}Вы сможете выполнить запуск (sshd.service) позже, воспользовавшись скриптом как шпаргалкой!"
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами. "
# Be careful! In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да добавляем, 0 - НЕТ - Пропустить действие: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да добавляем,     0 - НЕТ - Пропустить действие: " prog_set  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_set" =~ [^10] ]]
do
    :
done 
if [[ $prog_set == 0 ]]; then    
echo "  Сервис sshd не включен в автозагрузку, при необходиости это можно будет сделать. "
elif [[ $prog_set == 1 ]]; then
  echo " Добавляем в автозагрузку (sshd.service)"
sudo systemctl enable sshd.service
echo " Сервис sshd успешно добавлен в автозагрузку " 
fi

echo ""
echo -e "${GREEN}==> ${NC}Запускаем и добавляем в автозапуск Драйвера принтера CUPS (cupsd.service)"
#echo -e "${BLUE}:: ${NC}Запускаем и добавляем в автозапуск Драйвера принтера CUPS (cupsd.service)"
#echo 'Запускаем и добавляем в автозапуск Драйвера принтера CUPS (cupsd.service)'
# Launch and add the CUPS printer Driver to autorun (cupsd. service)
echo -e "${YELLOW}:: ${BOLD}Запускаем сервис обслуживания драйверов принтера CUPS (cupsd.service), если драйвера принтера были вами установлены. ${NC}"
echo -e "${CYAN}:: ${NC}Вы сможете выполнить запуск (cupsd.service) позже, когда подключите принтер, воспользовавшись скриптом как шпаргалкой!"
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами. "
# Be careful! In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да запускаем и добавляем, 0 - НЕТ - Пропустить действие: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да запускаем и добавляем,     0 - НЕТ - Пропустить действие: " prog_set  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_set" =~ [^10] ]]
do
    :
done 
if [[ $prog_set == 0 ]]; then    
echo "  Запуск и добавление в автозапуск (cupsd.service) пропущено "
elif [[ $prog_set == 1 ]]; then
  echo " Запускаем Драйвера принтера CUPS (cupsd.service) "
sudo systemctl start org.cups.cupsd.service  
echo " Добавляем в автозапуск Драйвера принтера CUPS (cupsd.service) " 
sudo systemctl enable org.cups.cupsd.service 
# Проверяем - переходим на страницу http://localhost:631:
fi
# --------------------- Важно! --------------------------------
# Добавляем группу:
# sudo groupadd printadmin
# Добавляем Пользователя в неё:
# sudo usermod -a -G printadmin $USER
# Обновляем /etc/cups/cups-files.conf, меняем группу sys на printadmin:
# 1 ...
# 2 # Administrator user group, used to match @SYSTEM in cupsd.conf policy rules...
# 3 # This cannot contain the Group value for security reasons...
# 4 SystemGroup printadmin root
# Перезапускаем сервис:
# systemctl restart org.cups.cupsd
# Доступные в cups бекенды для подключения принтера:
# ls -1 /usr/lib/cups/backend/
# Arch Linux: cups и hplip - подключение принтера
# https://rtfm.co.ua/arch-linux-cups-i-hplip-podklyuchenie-printera/
# ------------------------------------------------------------------------

echo ""
echo -e "${BLUE}:: ${NC}Обновим информацию о шрифтах" 
#echo 'Обновим информацию о шрифтах'
# Update information about fonts
sudo fc-cache -f -v

echo ""
echo -e "${BLUE}:: ${NC}Применяем настройки TLP (управления питанием) в зависимости от источника питания (батарея или от сети)" 
#echo 'Применяем настройки TLP (управления питанием) в зависимости от источника питания (батарея или от сети)'
# Apply TLP (power management) settings depending on the power source (battery or mains)
sudo tlp start

echo ""
echo -e "${BLUE}:: ${NC}Создать резервную копию (дубликат) файла grub.cfg" 
#echo 'Создать резервную копию (дубликат) файла grub.cfg'
# Create a backup (duplicate) of the grub.cfg file
#sudo cp /boot/grub/grub.cfg grub.cfg.backup
sudo cp -vf /boot/grub/grub.cfg /boot/grub/grub.cfg.backup 

###         "Дополнительные Настройки"
# ============================================================================
# Часы:
#Europe/Moscow
#%a, %d %b, %H:%M
# ----------------------------------------------------------------------------
# Conky Start Stop:
#Conky Start Stop
#Включить и выключить Conky
#bash -c 'if [[ `pidof conky` ]]; then killall conky; else bash ~/.scripts/conky-startup.sh; fi'
#Эмблемы: emblem-generic
# ----------------------------------------------------------------------------
# Клавиатура:
#xfce4-terminal   Ctrl+Alt+T
#xfce4-terminal --drop-down  F12
#light-locker-command -l   Ctrl+Alt+L
#xkill   Ctrl+Alt+X
#xfce4-taskmanager  Ctrl+Alt+M 
#xflock4   Ctrl+Alt+Delete
# ---------------------------------------------------------------------------
# Redshift:
#Redshift
#Инструмент регулирования цветовой температуры
#sh -c "sleep 30 && redshift-gtk -l 54.5293:36.27542 -t 6400:4500 -b 1.0:0.8"
#on login
# ============================================================================
# echo 'Добавить оскорбительное выражение после неверного ввода пароля в терминале'
# Откройте на редактирование файл sudoers следующей командой в терминале:
# sudo nano /etc/sudoers
# Когда откроется файл sudoers на редактирование, переместитесь до строки:
#   # Defaults env_keep += "QTDIR KDEDIR"
# и ниже скопипастите следующую стоку:
#     Defaults  badpass_message="Ты не администратор, придурок."
#
# Настраиваем sudo:
# Редактируем файл sudoers с помощью команды visudo. По умолчанию будет попытка открыть vi, но у нас он даже не установлен. Поэтому укажем, что редактор у нас nano:
#EDITOR=nano visudo
# Находим строчку:
# %wheel ALL=(ALL) ALL
# И убираем % в начале строки. Сохраняем и выходим.
# ---------------------------------------------------------
#
###################################################################
##### <<<  sudo и %wheel ALL=(ALL) NOPASSWD: ALL   >>>        #####
#### Кстати, рекомендую добавить запрет выполнения нескольких  ####
#### команд -                                                  ####
####                                                              #############
#### ##Groups of commands.  Often used to group related commands together. ####
#### Cmnd_Alias SHELLS = /bin/sh,/bin/csh,/usr/local/bin/tcsh     #############
#### Cmnd_Alias SSH = /usr/bin/ssh                             ####       
#### Cmnd_Alias SU = /bin/su                                   ####
#### dreamer ALL = (ALL) NOPASSWD: ALL,!SU,SHELLS,!SSH         ####
####                                                           #### 
#### чтобы не было возможности стать рутом через $sudo su      ####
#### (многи об этой фиче забывают)!                            #### 
#####                                                         #####
###################################################################
# 
# ============================================================================
# Добавить (прописать) в /etc/fstab , в самый низ файла:
# с отступом от последней записи (запись оставить закомментированной)
#  #/swapfile1 swap swap defaults 0 0
# ============================================================================
# Пропишем тему для Color в pacman.conf" 
# Write the theme for Color in pacman.conf
# ILoveCandy >> /etc/pacman.conf
# sudo pacman -Syy
# Синхронизация и обновление пакетов (-yy принудительно обновить даже если обновленные)
# ============================================================================
# Прозрачность панели XFCE:
# Выберите цвет панели /bn/ - #4072BF
# Регулируйте прозрачность не панели, а
# внешний вид → стиль → выбрать сплошной цвет → в выборе цвета задайте прозрачность (ползунок снизу)
# ============================================================================
# После этого нужно подредактировать хуки keymap.
# Откройте файл /etc/mkinitcpio.conf:  
#nano /etc/mkinitcpio.conf
# Ищём строчку HOOKS и добавляем в конце 3 хука (внутри скобок):
#HOOKS = (... consolefont keymap systemd)
# ============================================================================
#Основное
#Имя:  Thunar Root
#Описание:  Thunar Root
#Открыть папку с привилегиями root
#Команда:  pkexec thunar %f
#Сочетание клавиш: 
#Значёк:  folder-blue
#Условия появления 
#Шаблоны имени файла:  *.txt;*.doc;*
#Каталоги  Текстовые файлы
# ----------------------------------------------------------------------------
# Дописать в файлик по адресу home/.config/Thunar/uca.xml
# uca.xml :
#<?xml encoding="UTF-8" version="1.0"?>
#<actions>
#<action>
#    <icon>Terminal</icon>
#    <name>Terminal</name>
#    <unique-id>1367866030392833-1</unique-id>
#    <command>exo-open --working-directory %f --launch TerminalEmulator</command>
#    <description></description>
#    <patterns>*</patterns>
#    <directories/>
#</action>
#<action>
#    <icon>stock_folder</icon>
#    <name>Thunar Root</name>
#    <unique-id>1367866030392883-2</unique-id>
#    <command>pkexec thunar %f</command>
#    <description>Thunar Root</description>
#    <patterns>*</patterns>
#    <directories/>
#</action>
#<action>
#    <icon>system-search</icon>
#    <name>Search</name>
#    <unique-id>1367866030392913-3</unique-id>
#    <command>catfish %f</command>
#    <description>find files and folders</description>
#    <patterns>*</patterns>
#    <directories/>
#</action>
#</actions>
#
#  Или
#<?xml encoding="UTF-8" version="1.0"?>
#<actions>
#<action>
#    <icon>utilities-terminal</icon>
#    <name>_Terminal</name>
#    <unique-id>1476165034892557-17</unique-id>
#    <command>exo-open --working-directory %f --launch TerminalEmulator</command>
#    <description>Example for a custom action</description>
#    <patterns>*</patterns>
#    <startup-notify/>
#    <directories/>
#</action>
#<action>
#    <icon>folder_color_red</icon>
#    <name>Root T_hunar</name>
#    <unique-id>1476164980531587-13</unique-id>
#    <command>pkexec thunar %f</command>
#    <description></description>
#    <patterns>*</patterns>
#    <directories/>
#</action>
#<action>
#    <icon>text-editor</icon>
#    <name>Edit as Root</name>
#    <unique-id>1476164983371929-14</unique-id>
#    <command>pkexec xed %f</command>
#    <description>Edit as root</description>
#    <patterns>*</patterns>
#    <other-files/>
#    <text-files/>
#</action>
#</actions>
#
# И установить - catfish, xorg-xkill
# ============================================================================

#echo 'Запуск звуковой системы PulseAudio'
# Starting the PulseAudio sound system
#sudo start-pulseaudio-x11
# Выполнить эту команду только после установки утилит 'Поддержка звука' и перезагрузки системы, если сервис 'Запуск системы PulseAudio (Запуск звуковой системы PulseAudio)'не включился, и не появился в автозапуске. Это можно посмотреть через, диспетчер настроек, в пункте меню 'Сеансы и автозапуск'.

# ----------------------------------------------------------------------------

# Проверка вводимых символов
#cat /etc/arch-release
#grep -V
#echo 'aAsSdDfFgGhH'|egrep -q '^[a-z_-]+$'; echo $?

# ============================================================================

# Исправьте миниатюры в файловом менеджере
# Fix Thumbnails in file manager
#sudo pacman -S tumbler ffmpegthumbnailer poppler-glib libgsf libopenraw
# Удаление папки .thumbnails
#(Папка предназначена для хранения миниатюрных эскизов всех ранее просмотренных вами изображений)
#sudo rm -rf ~/.thumbnails/
# Переименовываем новый список:
#sudo mv ~/.config/Thunar ~/.config/Thunar.bak
# Обновим каталоги MIME, и update-mime-database 
#sudo update-mime-database /usr/share/mime

#Then logout and back in or Reboot. 

# ============================================================================
clear
echo -e "${GREEN}
  <<< Поздравляем! Установка завершена. >>> ${NC}"
# Congratulations! Installation is complete.
#echo -e "${GREEN}==> ${NC}Установка завершена!"
#echo 'Установка завершена!'
# The installation is now complete!

echo -e "${YELLOW}==> ${NC}Желательно перезагрузить систему для применения изменений"
#echo 'Желательно перезагрузить систему для применения изменений'
# It is advisable to restart the system to apply the changes

echo -e "${BLUE}==> ${NC}Скачать и произвести запуск скрипта (archmy4)?"
#echo 'Скачать и произвести запуск скрипта (archmy4)?'
# Download and run the script (archmy4)?
# echo 'wget git.io/archmy4 && sh archmy4'
echo -e "${YELLOW}==>  wget git.io/archmy4 ${NC}"
# Команды по установке :
# wget git.io/archmy4 
# sh archmy4
# wget git.io/archmy4 && sh archmy4 --noconfirm
echo -e "${GREEN}
  <<< ♥ Либо ты идешь вперед... либо в зад. >>> ${NC}"
#echo '♥ Либо ты идешь вперед... либо в зад.' 
# ♥ Either you go forward... or you go up your ass.
# ============================================================================

#echo -e "${YELLOW}==> ${NC}Загрузим архив (ветку мастер MarcMilany/arch_2020)"
#echo 'Загрузим архив (ветку мастер MarcMilany/arch_2020)'
# Upload the archive (branch master MarcMilany/arch_2020)
#wget https://github.com/MarcMilany/arch_2020.git/archive/master.zip
#wget github.com/MarcMilany/arch_2020.git/archive/arch_2020-master.zip
#sudo mv -f ~/Downloads/master.zip
#sudo mv -f ~/Downloads/arch_2020-master.zip
#sudo tar -xzf master.zip -C ~/ 
#sudo tar -xzf arch_2020-master.zip -C ~/
#git clone https://github.com/MarcMilany/arch_2020.git

echo -e "${BLUE}:: ${NC}Посмотрим дату и время без характеристик для проверки времени"
#echo 'Посмотрим дату и время без характеристик для проверки времени'
# Let's look at the date and time without characteristics to check the time
date
time

echo 'Удаление созданной папки (downloads), и скрипта установки программ (archmy3)'
# Deleting the created folder (downloads) and the program installation script (archmy3)
sudo rm -R ~/downloads/
sudo rm -rf ~/archmy3

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