#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

ARCHMY3_LANG="russian"  # Installer default language (Язык установки по умолчанию)

script_path=$(readlink -f ${0%/*})

umask 0022 # Определение окончательных прав доступа
# Для суперпользователя (root) umask по умолчанию равна 0022

##################################################################
##### <<<Arch Linux Fast Install LegasyBIOS (arch2020)>>>    #####
##### Скрипты 'arch_2020' созданы на основе 2-х (скриптов):  #####
#####   'ordanax/arch2018', и 'archlinux-script-install' -   #####
##### (Poruncov,Grub-Legacy - 2020).                         #####
##### Скрипт (сценарий) archmy3 является продолжением первой #####
#### части скриптов (archmy1 и archmy2) из серии 'arch_2020'. ####  
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
Цель сценария (скрипта) - это установка первоначально необходимого софта (пакетов) и запуск необходимых служб. 
Смысл в том, что все изменения вы делаете предварительно в самом скрипте и получаете возможность быстрой установки утилит (пакетов), которые Вы решили установить (при условии, что Вы его изменили под себя, в противном случае скрипт установит софт (пакеты) прописанный изначально.
В процессе работы сценария (скрипта) Вам будут задаваться вопросы на установку той, или иной утилиты (пакета) - будьте внимательными! В скрипте есть утилиты (пакеты), которые устанавливаются из 'AUR'. Это 'Pacman gui' или 'Octopi', в зависимости от вашего выбора, и т.д.. Сам же 'AUR'-'yay' или 'pikaur' - скачивается с сайта 'Arch Linux', собирается и устанавливается. Остальной софт (пакеты) скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска необходимых служб. В любой ситуации выбор всегда за вами. Вы либо гуляете под дождем, либо просто под ним мокнете.${RED}

  ***************************** ВНИМАНИЕ! ***************************** 
${NC}
Автор не несёт ответственности за любое нанесение вреда при использовании скрипта. 
Вы используйте его на свой страх и риск, или изменяйте под свои личные нужды. 
В данный момент сценарий (скрипта) находится в процессе доработки по прописыванию устанавливаемого софта (пакетов), и небольшой корректировке (Воен. Внесение поправок в наводку орудий по результатам наблюдений с наблюдательных пунктов).

${BLUE}===> ******************************************************* ${NC}"
}
###################################################################

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
echo -e "${BLUE}:: ${NC}Если NetworkManager запущен смотрим состояние интерфейсов" 
#echo "Если NetworkManager запущен смотрим состояние интерфейсов"
# If NetworkManager is running look at the state of the interfaces
# Первым делом нужно запустить NetworkManager:
# sudo systemctl start NetworkManager
# Если NetworkManager запущен смотрим состояние интерфейсов (с помощью - nmcli):  
nmcli general status

echo ""
echo -e "${BLUE}:: ${NC}Посмотреть имя хоста"
# View host name
nmcli general hostname 

echo ""
echo -e "${BLUE}:: ${NC}Получаем состояние интерфейсов"
# Getting the state of interfaces
nmcli device status

echo ""
echo -e "${BLUE}:: ${NC}Смотрим список доступных подключений"
# See the list of available connections
nmcli connection show

echo ""
echo -e "${BLUE}:: ${NC}Смотрим состояние wifi подключения"
# Looking at the status of the wifi connection
nmcli radio wifi

# -------------------------------------------
# Посмотреть список доступных сетей wifi:
# nmcli device wifi list
# Теперь включаем:
# nmcli radio wifi on
# Или отключаем:
# nmcli radio wifi off
# Команда для подключения к новой сети wifi выглядит не намного сложнее. Например, давайте подключимся к сети TP-Link с паролем 12345678:
# nmcli device wifi connect "TP-Link" password 12345678 name "TP-Link Wifi"
# Если всё прошло хорошо, то вы получите уже привычное сообщение про создание подключения с именем TP-Link Wifi и это имя в дальнейшем можно использовать для редактирования этого подключения и управления им, как описано выше.
# ------------------------------------------------

echo ""
echo -e "${BLUE}:: ${NC}Посмотрим данные о нашем соединение с помощью IPinfo..." 
#echo " Посмотрим данные о нашем соединение с помощью IPinfo..."
# Let's look at the data about our connection using IP info...
echo -e "${CYAN}=> ${NC}С помощью IPinfo вы можете точно определять местонахождение ваших пользователей, настраивать их взаимодействие, предотвращать мошенничество, обеспечивать соответствие и многое другое."
echo " Надежный источник данных IP-адресов (https://ipinfo.io/) "
wget http://ipinfo.io/ip -qO -
sleep 03

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

############ Mirrorlist ###################
### Если ли вам нужен этот пункт в скрипте, то раскомментируйте 

# Замена исходного mirrorlist (зеркал для загрузки) на мой список серверов-зеркал

# echo -e "${BLUE}:: ${NC}Замена исходного mirrorlist (зеркал для загрузки)"
#echo 'Замена исходного mirrorlist (зеркал для загрузки)'
#Ставим зеркало от Яндекс
# Удалим старый файл /etc/pacman.d/mirrorlist
#rm -rf /etc/pacman.d/mirrorlist
# Загрузка нового файла mirrorlis (список серверов-зеркал)
#wget https://raw.githubusercontent.com/MarcMilany/arch_2020/master/Mirrorlist/mirrorlist
# Переместим нового файла mirrorlist в /etc/pacman.d/mirrorlist
#mv -f ~/mirrorlist /etc/pacman.d/mirrorlist
#echo "Обновление баз данных пакетов..."
#sudo pacman -Sy
# =============================================

clear
echo -e "${MAGENTA}
  <<< Смена, обновление зеркал для увеличения скорости загрузки утилит (пакетов). >>> ${NC}"
# Changing or updating mirrors to increase the download speed of utilities (packages).

echo ""
echo -e "${GREEN}==> ${NC}Сменить зеркала для увеличения скорости загрузки пакетов?" 
echo -e "${BLUE}:: ${NC}Загрузка свежего списка зеркал со страницы Mirror Status, и Pacman Mirrorlist Generator Russia."
echo -e "${YELLOW}==> Примечание: ${BOLD}Смена или обновление зеркал - предоставлена только для 'Russia'. ${NC}"
echo " Вам будет представлено несколько вариантов для увеличения скорости загрузки пакетов. "
echo " Огласите весь список, пожалуйста! :) "
echo " 1 - Установка свежего списка зеркал со страницы Pacman Mirrorlist Generator Russia от (2020-10-03). "
echo " В файл etc/pacman.d/mirrorlist будут внесены, отсортиртированные по скорости загрузки, зеркала для 'Russia' по протоколам (https, http - ipv4, ipv6), отсортирует их по скорости загрузки и обновит файл mirrorlist. "
echo " 2 - Загрузка свежего списка зеркал со страницы Mirror Status, обновление файла mirrorlist, с помощью (reflector). "
echo " Команда отфильтрует зеркала для 'Russia' по протоколам (https, http - ipv4), отсортирует их по скорости загрузки и обновит файл mirrorlist. "
echo " Будьте внимательны! Не переживайте, перед обновлением зеркал будет сделана копия (backup) предыдущего файла mirrorlist, и в последствии будет сделана копия (backup) нового файла mirrorlist. Эти копии (backup) Вы сможете найти в установленной системе в /etc/pacman.d/mirrorlist. В данной опции выбор всегда остаётся за вами. "
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления" 
echo " Если Вы находитесь в России рекомендую выбрать вариант "1" "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Установка свежего списка от (2020-10-03),     2 - Обновление зеркал с помощью (reflector) 

    0 - Пропустить Смену (установку) и обновление зеркал: " up_zerkala  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$up_zerkala" =~ [^120] ]]
do
    :
done
if [[ $up_zerkala == 0 ]]; then
echo ""  
echo " Смена (установка) и обновление зеркал пропущено "
elif [[ $up_zerkala == 1 ]]; then
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
# ===================================================
echo ""
echo -e "${BLUE}:: ${NC}Посмотреть список серверов-зеркал для загрузки в mirrorlist"
#echo 'Посмотреть список серверов-зеркал для загрузки в mirrorlist'
# View the list of mirror servers to upload to mirrorlist
cat /etc/pacman.d/mirrorlist
sleep 01
# --------------------------------------------------
# Pacman Mirrorlist Generator
# https://www.archlinux.org/mirrorlist/
# Эта страница генерирует самый последний список зеркал, возможный для Arch Linux. Используемые здесь данные поступают непосредственно из внутренней базы данных зеркал разработчиков, используемой для отслеживания доступности и уровня зеркалирования. 
# Есть два основных варианта: получить список зеркал с каждым доступным зеркалом или получить список зеркал, адаптированный к вашей географии.
# ======================================================
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
echo -e "${CYAN}:: ${NC}Уведомление о загрузке и обновлении свежего списка зеркал"
# Собственные уведомления (notify):
notify-send "mirrorlist обновлен" -i gtk-info

#echo 'Выбор серверов-зеркал для загрузки.'
#echo 'The choice of mirrors to download.'
#pacman -Sy --noconfirm --noprogressbar --quiet reflector
#reflector -c "Russia" -c "Belarus" -c "Ukraine" -c "Poland" -f 5 -l 5 -p https -p http -n 5 --save /etc/pacman.d/mirrorlist --sort rate
#reflector --verbose --country Kazakhstan --country Russia --sort rate --save /etc/pacman.d/mirrorlist

#Команда отфильтрует 12 зеркал russia, отсортирует по скорости и обновит файл mirrorlist
#sudo reflector -c "Russia" -f 12 -l 12 --verbose --save /etc/pacman.d/mirrorlist
#---------------------------------------------------
# Reflector — скрипт, который автоматизирует процесс настройки зеркал, включающий в себя загрузку свежего списка зеркал со страницы Mirror Status.
# https://www.linuxsecrets.com/archlinux-wiki/wiki.archlinux.org/index.php/Reflector_(%D0%A0%D1%2583%D1%2581%D1%2581%D0%BA%D0%B8%D0%B9).html
# Эта страница сообщает о состоянии всех известных, общедоступных и активных зеркал Arch Linux:
# https://www.archlinux.org/mirrors/status/
# ==================================================
echo ""
echo -e "${BLUE}:: ${NC}Создание резервной копии нового файла /etc/pacman.d/mirrorlist"
#echo 'Создадим резервную копию файла /etc/pacman.d/mirrorlist'
# Creating a backup copy of the file /etc/pacman.d/mirrorlist
#sudo cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
#sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sudo cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.pacnew
# Сохраняем старый список зеркал в качестве резервной копии:
#sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old
# Переименовываем новый список:
#mv /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist
#mv -f ~/mirrorlist /etc/pacman.d/mirrorlist
# ====================================================
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
# =========================================================
echo ""
echo -e "${BLUE}:: ${NC}Переименуем новый список серверов-зеркал mirrorlist.pacnew в mirrorlist"
#echo 'Переименуем новый список серверов-зеркал mirrorlist.pacnew в mirrorlist'
# Rename the new list of mirror servers mirrorlist. pacnew to mirrorlist
#mv /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist
# Переименовываем новый список:
#sudo mv /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist
sudo mv /etc/pacman.d/mirrorlist.backup /etc/pacman.d/mirrorlist
# ========================================================
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
# ======================================================== 
echo ""
echo -e "${BLUE}:: ${NC}Посмотреть список серверов-зеркал для загрузки в mirrorlist"
#echo 'Посмотреть список серверов-зеркал для загрузки в mirrorlist'
# View the list of mirror servers to upload to mirrorlist
echo ""
cat /etc/pacman.d/mirrorlist
sleep 02
# ============================================
echo ""
echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов" 
#echo 'Обновим базы данных пакетов'
# Updating the package databases
#sudo pacman-key --init
#sudo pacman-key --refresh-keys
sudo pacman -Sy  
#----------------------------------------------------
# Знакомьтесь, pacman - лучший пакетный менеджер в мире линукса!
#pacman -Syy   - обновление баз пакмэна(как apt-get update в дэбианоподбных)
#pacman -Syyu  - обновление баз плюс обновление пакетов
#---------------------------------------------------
elif [[ $up_zerkala == 2 ]]; then
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
# ===================================
echo ""
echo -e "${BLUE}:: ${NC}Посмотреть список серверов-зеркал для загрузки в mirrorlist"
#echo 'Посмотреть список серверов-зеркал для загрузки в mirrorlist'
# View the list of mirror servers to upload to mirrorlist
echo ""
cat /etc/pacman.d/mirrorlist
sleep 01
# ---------------------------------------------
# Pacman Mirrorlist Generator
# https://www.archlinux.org/mirrorlist/
# Эта страница генерирует самый последний список зеркал, возможный для Arch Linux. Используемые здесь данные поступают непосредственно из внутренней базы данных зеркал разработчиков, используемой для отслеживания доступности и уровня зеркалирования. 
# Есть два основных варианта: получить список зеркал с каждым доступным зеркалом или получить список зеркал, адаптированный к вашей географии.
# ===========================================
echo ""
echo -e "${BLUE}:: ${NC}Загрузка свежего списка зеркал со страницы Mirror Status, и обновляем mirrorlist"
#echo 'Загрузка свежего списка зеркал со страницы Mirror Status, и обновляем mirrorlist'
# Loading a fresh list of mirrors from the Mirror Status page, and updating the mirrorlist
# Чтобы увидеть список всех доступных опций, наберите:
#reflector --help
# Команда отфильтрует пять зеркал, отсортирует их по скорости и обновит файл mirrorlist:
sudo pacman -Sy --noconfirm --noprogressbar --quiet reflector
sudo reflector --verbose --country 'Russia' -l 7 -p https -p http -n 7 --save /etc/pacman.d/mirrorlist --sort rate 
#sudo reflector --verbose --country 'Russia' -l 7 -p https -p http -n 7 --save /etc/pacman.d/mirrorlist.pacnew --sort rate  
#reflector --verbose --country 'Russia' -l 5 -p https -p http -n 5 --sort rate --save /etc/pacman.d/mirrorlist
echo -e "${CYAN}:: ${NC}Уведомление о загрузке и обновлении свежего списка зеркал"
# Собственные уведомления (notify):
notify-send "mirrorlist обновлен" -i gtk-info

#echo 'Выбор серверов-зеркал для загрузки.'
#echo 'The choice of mirrors to download.'
#pacman -Sy --noconfirm --noprogressbar --quiet reflector
#reflector -c "Russia" -c "Belarus" -c "Ukraine" -c "Poland" -f 5 -l 5 -p https -p http -n 5 --save /etc/pacman.d/mirrorlist --sort rate
#reflector --verbose --country Kazakhstan --country Russia --sort rate --save /etc/pacman.d/mirrorlist

#Команда отфильтрует 12 зеркал russia, отсортирует по скорости и обновит файл mirrorlist
#sudo reflector -c "Russia" -f 12 -l 12 --verbose --save /etc/pacman.d/mirrorlist

#-------------------------------------------------
# Reflector — скрипт, который автоматизирует процесс настройки зеркал, включающий в себя загрузку свежего списка зеркал со страницы Mirror Status.
# https://www.linuxsecrets.com/archlinux-wiki/wiki.archlinux.org/index.php/Reflector_(%D0%A0%D1%2583%D1%2581%D1%2581%D0%BA%D0%B8%D0%B9).html
# Эта страница сообщает о состоянии всех известных, общедоступных и активных зеркал Arch Linux:
# https://www.archlinux.org/mirrors/status/
# ==============================================
echo ""
echo -e "${BLUE}:: ${NC}Создание резервной копии нового файла /etc/pacman.d/mirrorlist"
#echo 'Создадим резервную копию файла /etc/pacman.d/mirrorlist'
# Creating a backup copy of the file /etc/pacman.d/mirrorlist
#sudo cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
#sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sudo cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.pacnew
# Сохраняем старый список зеркал в качестве резервной копии:
#sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old
# Переименовываем новый список:
#mv /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist
#mv -f ~/mirrorlist /etc/pacman.d/mirrorlist
# ====================================================
echo ""
echo -e "${BLUE}:: ${NC}Посмотреть список серверов-зеркал для загрузки в mirrorlist"
#echo 'Посмотреть список серверов-зеркал для загрузки в mirrorlist'
# View the list of mirror servers to upload to mirrorlist
cat /etc/pacman.d/mirrorlist
sleep 02
# ==============================================
echo ""
echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов" 
#echo 'Обновим базы данных пакетов'
# Updating the package databases
#sudo pacman-key --init
#sudo pacman-key --refresh-keys
sudo pacman -Sy  
#----------------------------------------------------------------
# Знакомьтесь, pacman - лучший пакетный менеджер в мире линукса!
#pacman -Syy   - обновление баз пакмэна(как apt-get update в дэбианоподбных)
#pacman -Syyu  - обновление баз плюс обновление пакетов
#---------------------------------------------------------------- 
fi

# --------------------------------------
### Если возникли проблемы с обновлением, или установкой пакетов 
### Если ли вам нужен этот пункт в скрипте, то раскомментируйте ниже в меню все тройные решётки (###)

###clear
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
  #echo " Создаётся генерация мастер-ключа (брелка) pacman, введите пароль (не отображается)... "
  #sudo pacman-key --init  #
  #echo " Далее идёт поиск ключей... "
  #sudo pacman-key --populate archlinux  #
###  echo " Обновление ключей... "  
###  sudo pacman-key --refresh-keys 
###  echo "Обновление баз данных пакетов..."
###  sudo pacman -Sy
###  elif [[ $x_key == 0 ]]; then
###  echo " Обновление ключей пропущено "   
###fi
###sleep 1

# Или:
#sudo pacman-key --init && sudo pacman-key --populate archlinux && sudo pacman-key --refresh-keys && sudo pacman -Sy
# ----------------------------
# Ошибки про archlinux-keyring
# Если вы получаете ошибки, связанные с ключами (например, ключ A634567E8t6574 не может быть найден удаленно) при попытке обновить вашу систему, вы должны выполнить следующие четыре команды от имени пользователя root:
# rm -R /etc/pacman.d/gnupg/
# rm -R / root / .gnupg /
# gpg –refresh-keys
# pacman-key –init && pacman-key –populate archlinux
# pacman-key –refresh-keys
# ==================================

clear
echo -e "${MAGENTA}
  <<< Синхронизации времени (Время от времени часы на компьютере могут сбиваться по различным причинам). >>> ${NC}"

echo ""
echo -e "${GREEN}==> ${NC}Если у Вас Сбиваются настройки времени (или параллельно установлена Windows...)"
#echo 'Если у Вас Сбиваются настройки времени (или параллельно установлена Windows...)
# If you have Lost the time settings (or Windows is installed in parallel...)
echo -e "${BLUE}:: ${BOLD}Посмотрим дату, время, и часовой пояс ... ${NC}"
timedatectl | grep "Time zone"
date
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'     # одновременно отображает дату и часовой пояс
echo ""
echo -e "${MAGENTA}:: ${NC}Для ИСПРАВЛЕНИЯ (синхронизации времени) предложено несколько вариантов (ntp и openntpd)."
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo " 1 - Установка NTP Servers (серверы точного времени) - пакет (ntp - Эталонная реализация сетевого протокола времени). Список общедоступных NTP серверов доступен на сайте http://ntp.org. "
echo -e "${CYAN}:: ${NC}На сегодняшний день существует множество технологий синхронизации часов, из которых наиболее широкую популярность получила NTP. Что такое NTP? NTP (Network Time Protocol) - стандартизированный протокол, который работает поверх UDP и используется для синхронизации локальных часов с часами на сервере точного времени (на различных операционных системах)."  # NTP Servers (серверы точного времени) - https://www.ntp-servers.net/
echo " 2 - Установка OpenNTPD - пакет (openntpd - Бесплатная и простая в использовании реализация протокола сетевого времени). По умолчанию OpenNTPd использует серверы pool.ntp.org (это огромный кластер серверов точного времени) и работает только как клиент."  # Introduction - https://www.ntppool.org/ru/ 
echo -e "${CYAN}:: ${NC}OpenNTPD - это свободная и простая в использовании реализация протокола NTP, первоначально разработанная в рамках проекта OpenBSD. OpenNTPd дает возможность синхронизировать локальные часы с удаленными серверами NTP."
echo " Будьте внимательны! В данной опции выбор всегда остаётся за вами. "
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления" 
echo " Если Вы находитесь в России рекомендую выбрать вариант "1" "
echo "" 
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Установка NTP (Network Time Protocol),     2 - Установка OpenNTPD 

    0 - НЕТ - Пропустить установку: " i_localtime  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_localtime" =~ [^120] ]]
do
    :
done
if [[ $i_localtime == 0 ]]; then
echo ""  
echo " Установка и настройка пропущена "
elif [[ $i_localtime == 1 ]]; then
echo ""
echo " Установка NTP (Network Time Protocol) "
sudo pacman -S ntp --noconfirm  # Эталонная реализация сетевого протокола времени
echo ""
echo " Установка времени по серверу NTP (Network Time Protocol)(ru.pool.ntp.org) "
sudo ntpdate 0.ru.pool.ntp.org  # будем использовать NTP сервера из пула ru.pool.ntp.org
#sudo ntpdate 1.ru.pool.ntp.org  # Список общедоступных NTP серверов доступен на сайте http://ntp.org
#sudo ntpdate 2.ru.pool.ntp.org  # Отредактируйте /etc/ntp.conf для добавления/удаления серверов (server)
#sudo ntpdate 3.ru.pool.ntp.org  # После изменений конфигурационного файла вам надо перезапустить ntpd (sudo service ntp restart) - Просмотр статуса: (sudo ntpq -p)
echo " Синхронизации с часами BIOS "  # Синхронизируем аппаратное время с системным
echo " Устанавливаются аппаратные часы из системных часов. "
sudo hwclock --systohc  # Эта команда предполагает, что аппаратные часы настроены в формате UTC. 
# sudo hwclock --adjust  # Порой значение аппаратного времени может сбиваться - выровняем!

echo ""
echo " Установка NTP (Network Time Protocol) выполнена "
echo " Время точное как на Спасской башне Московского Кремля! "
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'   # одновременно отображает дату и часовой пояс
elif [[ $i_localtime == 2 ]]; then
echo ""
echo " Установка OpenNTPD"
sudo pacman -S openntpd --noconfirm  # Бесплатная и простая в использовании реализация протокола сетевого времени
echo " Добавим в автозагрузку OpenNTPD (openntpd.service) "
systemctl enable openntpd.service
echo " Установка OpenNTPD и запуск (openntpd.service) выполнен "
fi
# -------------------------------------
# Настройка синхронизации времени в домене с помощью групповых политик состоит из двух шагов:
# 1) Создание GPO для контроллера домена с ролью PDC
# 2) Создание GPO для клиентов (опционально)
# https://zen.yandex.ru/media/winitpro.ru/ntp-sinhronizaciia-vremeni-v-domene-s-pomosciu-gruppovyh-politik-5b5042923e546700a8ccf633?utm_source=serp
# (https://www.8host.com/blog/ustanovka-i-nastrojka-openntpd-v-freebsd-10-2/)
# ====================================

clear
echo -e "${MAGENTA}
  <<< Создание полного набора пользовательских каталогов по умолчанию, в пределах "HOME" каталога. >>> ${NC}"
echo -e "${YELLOW}==> Примечание: ${NC}Сейчас Вы можете создать, если пропустили это действие в предыдущем скрипте (при установке основной системы), или пропустить установку." 

echo ""
echo -e "${GREEN}==> ${NC}Создаём папки в директории пользователя (Downloads, Music, Pictures, Videos, Documents)."
echo -e "${CYAN}:: ${NC}По умолчанию в системе Arch Linux в каталоге "HOME" НЕ создаются папки (Загрузки, Шаблоны, Общедоступные, Документы, Музыка, Изображения, Видео), кроме папки Рабочий стол (Desktop)."
echo -e "${CYAN}:: ${NC}Согласно философии Arch, вместо удаления ненужных пакетов, папок, пользователю предложена возможность построить систему, начиная с минимальной основы без каких-либо заранее выбранных шаблонов... "
echo " Давайте проанализируем действия, которые выполняются. "
echo " 1 - Создание каталогов по умолчанию с помощью (xdg-user-dirs), тогда укажите вариант "1". "
echo " xdg-user-dirs - это инструмент, помогающий создать и управлять "хорошо известными" пользовательскими каталогами, такими как папка рабочего стола, папка с музыкой и т.д.. Он также выполняет локализацию (то есть перевод) имен файлов. "
echo " Большинство файловых менеджеров обозначают пользовательские каталоги XDG специальными значками. "
echo " 2(0) - Если Вам не нужны папки в директории пользователя, или Вы уже создали папки, тогда выбирайте вариант "0". " 
echo -e "${CYAN}:: ${NC}Есть другие способы создания локализованных пользовательских каталогов, но в данном скрипте они не будут представлены. "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Создание каталогов с помощью (xdg-user-dirs), 

    0 - Пропустить создание каталогов: " i_catalog  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_catalog" =~ [^10] ]]
do
    :
done
if [[ $i_catalog == 0 ]]; then
echo ""  
echo " Создание каталогов пропущено "
elif [[ $i_catalog == 1 ]]; then
echo ""  
echo " Создание пользовательских каталогов по умолчанию "    
sudo pacman -S xdg-user-dirs --noconfirm
xdg-user-dirs-update 
echo "" 
echo " Создание каталогов успешно выполнено "
fi

echo ""
echo -e "${YELLOW}==> ${NC}Создадим папку (downloads), и переходим в созданную папку"
#echo 'Создадим папку (downloads), и переходим в созданную папку'
# Create a folder (downloads), and go to the created folder
#rm -rf ~/.config/xfce4/*
mkdir ~/downloads
cd ~/downloads

clear
echo -e "${MAGENTA}
  <<< Установка AUR (Arch User Repository) >>> ${NC}"
# Installing an Aur (Arch User Repository).
echo -e "${YELLOW}==> Примечание: ${NC}Сейчас Вы можете установить "AUR Helper", если пропустили это действие в предыдущем скрипте (при установке основной системы), или пропустить установку." 
echo -e "${YELLOW}==> Внимание! ${NC}Во время установки "AUR", Вас попросят ввести (Пароль пользователя)."

echo ""
echo -e "${GREEN}==> ${NC}Установка AUR Helper (yay) или (pikaur)"
#echo -e "${BLUE}:: ${NC}Установка AUR Helper (yay) или (pikaur)" 
#echo 'Установка AUR Helper (yay) или (pikaur)'
# Installing AUR Helper (yay) or (pikaur)
echo -e "${MAGENTA}:: ${NC} AUR - Пользовательский репозиторий, поддерживаемое сообществом хранилище ПО, в который пользователи загружают скрипты для установки программного обеспечения."
echo " В AUR - есть практически всё, что можно установить на Linux. В том числе и программы, которые для других дистробутивов пришлось бы собирать из исходников. "
echo -e "${CYAN}=> ${BOLD}В сценарии скрипта присутствуют следующие варианты: ${NC}"
echo " 1 - Установка 'AUR'-'yay-bin' с помощью скрипта созданного (autor): Alex Creio https://cvc.hashbase.io/ - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/yay-bin/), собирается и устанавливается, то выбирайте вариант - "1". "
echo -e "${YELLOW}:: ${NC}Обертка Pacman и помощник AUR, написанные на языке go. (версия в разработке)"
echo " 2 - Установка 'AUR'-'yay' с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/yay.git), собирается и устанавливается, то выбирайте вариант - "2". "
echo " 3 - Установка 'AUR'-'pikaur' с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/pikaur.git), собирается и устанавливается, то выбирайте вариант - "3". "
echo " Подчеркну (обратить внимание)! Pikaur - идёт как зависимость для Octopi. "
echo " Будьте внимательны! В этом действии выбор остаётся за вами. "
# Be careful! In this action, the choice is yours.
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления" 
#echo 'Установка производится в порядке перечисления'
# Installation Is performed in the order listed
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - AUR - yay-bin (git clone), 2 - AUR - yay, 3 - AUR - pikaur, 0 - Пропустить установку AUR Helper: " in_aur_help  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - AUR - yay-bin (git clone),     2 - AUR - yay (git clone),     3 - AUR - pikaur (git clone),

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
echo ""     
sudo pacman -Syu
#wget git.io/yay-install.sh && sh yay-install.sh --noconfirm
#echo " Установка базовых программ и пакетов wget, curl, git "
#sudo pacman -S --noconfirm --needed wget curl git
echo " Установка AUR Helper (yay-bin) "
git clone https://aur.archlinux.org/yay-bin.git 
cd yay-bin
# makepkg -si
#makepkg -si --noconfirm   #-не спрашивать каких-либо подтверждений
makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
rm -rf yay-bin    # удаляем директорию сборки
# rm -Rf yay-bin
clear
echo ""
echo " Установка AUR Helper (yay-bin) завершена "
elif [[ $in_aur_help == 2 ]]; then
echo ""    
sudo pacman -Syu
#echo " Установка базовых программ и пакетов wget, curl, git "
#sudo pacman -S --noconfirm --needed wget curl git
echo " Установка AUR Helper (yay) "
git clone https://aur.archlinux.org/yay.git
cd yay 
makepkg -si --noconfirm
pwd 
# makepkg -si
#makepkg -si --skipinteg 
cd ..
rm -Rf yay
clear
echo ""
echo " Установка AUR Helper (yay) завершена "
elif [[ $in_aur_help == 3 ]]; then
echo ""    
sudo pacman -Syu
#echo " Установка базовых программ и пакетов wget, curl, git "
#sudo pacman -S --noconfirm --needed wget curl git
echo " Установка AUR Helper (pikaur) "
git clone https://aur.archlinux.org/pikaur.git 
cd pikaur   
makepkg -si --noconfirm
pwd 
# makepkg -si
#makepkg -si --skipinteg  
cd ..
rm -Rf pikaur
clear
echo ""
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
# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps
# --------------------------------------------------------------
#
# https://aur.archlinux.org/packages/yay-bin/
# Йогурт (yogurt). Обертка Pacman и помощник AUR, написанные на языке go. (версия в разработке)
# База пакета: yay-bin
# URL восходящего направления:  https://github.com/Jguer/yay
# Git Clone URL: https://aur.archlinux.org/yay-bin.git (только для чтения, нажмите, чтобы скопировать)
# Популярность: 5,37
# Первый отправленный:  2016-12-03 15:06
# Последнее обновление: 2020-08-18 17:26
# 
# Есть ещё один вариант yay:
# https://aur.archlinux.org/packages/yay/
# Йогурт (yogurt). Обертка Pacman и помощник AUR, написанные на языке go.
# База пакета: yay
# URL восходящего направления:  https://github.com/Jguer/yay
# Git Clone URL: https://aur.archlinux.org/yay.git (только для чтения, нажмите, чтобы скопировать)
# Популярность: 72.16
# Первый отправленный:  2016-10-05 17:20
# Последнее обновление: 2020-08-18 17:27
#
# Вот ещё один вариант yay:
# https://aur.archlinux.org/packages/yay-git/
# Еще один йогурт. Обертка Pacman и помощник AUR, написанные на языке go. (версия в разработке)
# База пакета: yay-git
# URL восходящего направления:  https://github.com/Jguer/yay
# Git Clone URL: https://aur.archlinux.org/yay-git.git (только для чтения, нажмите, чтобы скопировать)
# Популярность: 0.67
# Первый отправленный:  2018-01-29 05:52
# Последнее обновление: 2020-08-18 17:28
#
#### <<< Делайте выводы сами! >>> #######
# =============================================================

echo ""
echo -e "${BLUE}:: ${NC}Обновим всю систему включая AUR пакеты" 
#echo 'Обновим всю систему включая AUR пакеты'
# Update the entire system including AUR packages
echo -e "${YELLOW}==> Примечание: ${NC}Выберите вариант обновления баз данных пакетов, и системы, в зависимости от установленного вами AUR Helper (yay; pikaur), или пропустите обновления - (если AUR НЕ установлен)."
echo -e "${CYAN}=> ${BOLD}В сценарии скрипта присутствуют следующие варианты: ${NC}"
echo " 1 - Обновление баз данных пакетов, и системы через 'AUR'-'yay', то выбирайте вариант - "1". "
echo " 2 - Установка обновлений баз данных пакетов, и системы через 'AUR'-'pikaur', выбирайте вариант - "2". "
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке" 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Обновление через - AUR (Yay),     2 - Обновление через - AUR (Pikaur), 

    0 - Пропустить обновление баз данных пакетов, и системы: " upd_aur  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$upd_aur" =~ [^120] ]]
do
    :
done 
if [[ $upd_aur == 0 ]]; then
echo ""    
echo " Обновление баз данных пакетов, и системы пропущено "
elif [[ $upd_aur == 1 ]]; then
echo ""    
echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
yay -Syy
yay -Syu
elif [[ $upd_aur == 2 ]]; then
echo ""    
echo " Обновление баз данных пакетов, и системы через - AUR (Pikaur) "
pikaur -Syy
pikaur -Syu
fi

sleep 02
clear
echo -e "${MAGENTA}
  <<< Установка сетевого экрана (брандмауэр UFW) и антивируса (ClamAV) для Archlinux >>> ${NC}"
# Installing firewall (UFW firewall) and antivirus (ClamAV) for Archlinux
echo -e "${CYAN}:: ${NC}Если Вы "Дока", то настройте под свои нужды утилиту 'Iptables'(firewall)"
echo -e "${YELLOW}==> Примечание: ${NC}Вы можете установить предложенный софт (пакеты), или пропустите установку."
 
echo ""
echo -e "${GREEN}==> ${NC}Установить UFW (Несложный Брандмауэр) (ufw, gufw) (GUI)(GTK)?"
#echo -e "${BLUE}:: ${NC}Установить UFW (Несложный Брандмауэр) (ufw, gufw) (GUI)(GTK)?"
#echo 'Установить UFW (Несложный Брандмауэр) (ufw, gufw) (GUI)(GTK)?'
# Install UFW (simple firewall) (ufw, gufw) (GUI)(GTK)?
echo -e "${CYAN}:: ${BOLD}Ufw расшифровывается как Uncomplicated Firewall и представляет собой программу для управления межсетевым экраном netfilter. ${NC}"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_firewall  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_firewall" =~ [^10] ]]
do
    :
done 
if [[ $i_firewall == 0 ]]; then 
echo ""   
echo " Установка Брандмауэра UFW пропущена "
elif [[ $i_firewall == 1 ]]; then
  echo ""    
  echo " Установка UFW (Несложный Брандмауэр) "
sudo pacman -S ufw gufw --noconfirm
echo " Установка Брандмауэра UFW завершена "
fi

echo ""
echo -e "${GREEN}==> ${NC}Установить Clam AntiVirus (clamav, clamtk) (GUI)(GTK)?"
#echo -e "${BLUE}:: ${NC}Установить Clam AntiVirus (clamav, clamtk) (GUI)(GTK)?" 
#echo 'Установить Clam AntiVirus (clamav, clamtk) (GUI)(GTK)?'
# Install Clam AntiVirus (clamav, clamtk) (GUI)(GTK)?
echo -e "${CYAN}:: ${BOLD}ClamAV - это антивирусный движок с открытым исходным кодом для обнаружения троянов, вирусов, вредоносных программ и других вредоносных угроз. ${NC}"
echo " ClamAV включает в себя демон многопоточного сканера, утилиты для сканирования файлов по запросу, почтовых шлюзов с открытым исходным кодом и автоматическим обновлением сигнатур. "
echo " Поддерживает несколько форматов файлов, распаковку файлов и архивов, а также несколько языков подписи. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_antivirus  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_antivirus" =~ [^10] ]]
do
    :
done 
if [[ $i_antivirus == 0 ]]; then
echo ""    
echo " Установка Антивирусного пакета ClamAV пропущена "
elif [[ $i_antivirus == 1 ]]; then
  echo ""  
  echo " Установка Clam AntiVirus "
sudo pacman -S clamav clamtk --noconfirm
echo " Установка Clam AntiVirus завершена "
fi
# --------------------------------------------------
# Uncomplicated Firewall
# https://wiki.archlinux.org/index.php/Uncomplicated_Firewall
# ufw home:
# https://launchpad.net/ufw
# Категория: Межсетевые экраны
# https://wiki.archlinux.org/index.php/Category:Firewalls
# Руководство по iptables (Iptables Tutorial 1.1.19):
# https://www.opennet.ru/docs/RUS/iptables/
# Антивирусный инструментарий для Unix:
# https://www.archlinux.org/packages/extra/x86_64/clamav/
# Руководство (домашняя страница):
# https://www.clamav.net/
# ----------------------------------------------------------

sleep 02
clear
echo -e "${MAGENTA}
  <<< Установка первоначально необходимого софта (пакетов) для Archlinux >>> ${NC}"
# Installation of initially required software (packages) for Archlinux.
echo -e "${YELLOW}==> Примечание: ${NC}Сейчас Вы можете установить софт: поддержки Bluetooth, поддержки звука, архиваторы, утилиты для вывода информации о системе, мультимедиа, текстовые редакторы, утилиты разработки, браузеры, управления электронной почтой, торрент-клиент, офисные утилиты и т.д., или пропустите установку."  

echo ""
echo -e "${GREEN}==> ${NC}Установим поддержку Bluetooth?"
#echo -e "${BLUE}:: ${NC}Установим поддержку Bluetooth?" 
#echo 'Установим поддержку Bluetooth?'
# Install Bluetooth support?
echo -e "${CYAN}=> ${BOLD}Установка поддержки Bluetooth и Sound support (звука) - будет очень актуальна, если Вы установили DE (среда рабочего стола) XFCE. ${NC}"
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (bluez, bluez-libs, bluez-cups, bluez-utils)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_bluetooth  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_bluetooth" =~ [^10] ]]
do
    :
done 
if [[ $i_bluetooth == 0 ]]; then  
echo ""  
echo " Установка поддержки Bluetooth пропущена "
elif [[ $i_bluetooth == 1 ]]; then
  echo ""    
  echo " Установка пакетов поддержки Bluetooth "
sudo pacman -S bluez bluez-libs bluez-cups bluez-utils --noconfirm  # Демоны для стека протоколов Bluetooth; Устаревшие библиотеки для стека протоколов Bluetooth; Серверная часть CUPS для принтеров Bluetooth; Утилиты разработки и отладки для стека протоколов bluetooth.
#sudo pacman -S bluez-hid2hci --noconfirm  # Перевести HID проксирование bluetooth HCI в режим HCI; 
#sudo pacman -S bluez-plugins --noconfirm  # Плагины bluez (контроллер PS3 Sixaxis) 
#sudo pacman -S blueman --noconfirm  # blueman --диспетчер bluetooth устройств (полезно для i3)
#sudo systemctl enable bluetooth.service 
echo ""   
echo " Установка пакетов поддержки Bluetooth выполнена "
fi
# -----------------------------------------
# Bluetooth (Русский)
# https://wiki.archlinux.org/index.php/Bluetooth_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# ==========================================

clear
echo ""
echo -e "${GREEN}==> ${NC}Ставим пакеты Поддержки звука (alsa, pulseaudio...)?"
#echo -e "${BLUE}:: ${NC}Ставим пакеты Поддержки звука (alsa, pulseaudio...)?" 
#echo 'Ставим пакеты Поддержки звука (alsa, pulseaudio...)?'
# Installing sound support packages (alsa, pulseaudio...)?
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (alsa-utils, alsa-plugins, alsa-firmware, alsa-lib, alsa-utils, pulseaudio, pulseaudio-alsa, pavucontrol, pulseaudio-zeroconf, pulseaudio-bluetooth и xfce4-pulseaudio-plugin)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_sound  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_sound" =~ [^10] ]]
do
    :
done 
if [[ $i_sound == 0 ]]; then 
clear
echo ""   
echo " Установка поддержки Sound support пропущена "
elif [[ $i_sound == 1 ]]; then
  echo ""  
  echo " Установка пакетов поддержки Sound support (alsa, pulseaudio...) "
sudo pacman -S alsa-utils alsa-plugins alsa-firmware alsa-lib --noconfirm  # Расширенная звуковая архитектура Linux - Утилиты; Дополнительные плагины ALSA; Бинарные файлы прошивки для программ загрузки в alsa-tools и загрузчик прошивок hotplug; Альтернативная реализация поддержки звука Linux
sudo pacman -S lib32-alsa-plugins --noconfirm  # Дополнительные плагины ALSA (32-бит)
sudo pacman -S alsa-oss lib32-alsa-oss --noconfirm  # Библиотека совместимости OSS; Библиотека совместимости OSS (32 бит)
#sudo pacman -S alsa-tools --noconfirm  # Расширенные инструменты для определенных звуковых карт
sudo pacman -S alsa-topology-conf alsa-ucm-conf --noconfirm  # Файлы конфигурации топологии ALSA; Конфигурация (и топологии) ALSA Use Case Manager
sudo pacman -S pulseaudio pulseaudio-alsa pavucontrol pulseaudio-bluetooth pulseaudio-equalizer-ladspa --noconfirm
#sudo pacman -S pulseaudio --noconfirm  # Функциональный звуковой сервер общего назначения
#sudo pacman -S pulseaudio-alsa --noconfirm  # Конфигурация ALSA для PulseAudio 
#sudo pacman -S pavucontrol --noconfirm  # Регулятор громкости PulseAudio
#sudo pacman -S pulseaudio-bluetooth --noconfirm  # Поддержка Bluetooth для PulseAudio
#sudo pacman -S pulseaudio-equalizer-ladspa --noconfirm  # 15-полосный эквалайзер для PulseAudio
### sudo pacman -S pulseaudio-equalizer --noconfirm  # Графический эквалайзер для PulseAudio
sudo pacman -S pulseaudio-zeroconf --noconfirm  # Поддержка Zeroconf для PulseAudio
#sudo pacman -S pulseaudio-lirc --noconfirm  # Поддержка IR (lirc) для PulseAudio
#sudo pacman -S pulseaudio-jack --noconfirm  # Поддержка разъема для PulseAudio
#sudo pacman -S pasystray --noconfirm  # Системный трей PulseAudio (замена # padevchooser)  
sudo pacman -S xfce4-pulseaudio-plugin --noconfirm  # Плагин Pulseaudio для панели Xfce4 
#sudo pacman -Sy pavucontrol pulseaudio-bluetooth alsa-utils pulseaudio-equalizer-ladspa --noconfirm
clear
echo ""   
echo " Установка пакетов Поддержки звука выполнена "
fi
# -----------------------------------------------
# Pulseaudio zeroconf звук по сети:
# У меня есть сервер, к которому подключены колонки 5.1, и есть ноутбук, с которого нужно передавать звук на 5.1.
# На обоих тачках стоит гента. Поставил pulseaudio и там и там.
# На сервере дописал следующие строчки в конфиг:
# load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1;192.168.0.0/24 auth-anonymous=1
# load-module module-zeroconf-publish
# load-module module-rtp-recv
# На ноутбуке:
# load-module module-zeroconf-discover
# Теперь если я в файле /etc/pulse/client.conf укажу строчку
# default-server = tcp:192.168.0.3:4713
# То все работает замечательно!
# Либо если я запущу mplayer следующей командой:
# mplayer -ao pulse:192.168.0.3 -channels 6 Фильм.avi
# То все так-же хорошо.
# Но на днях я нашел программу pasystray (замена padevchooser). Она позволяет перенаправлять звук у каждой программы туда, куда надо (находя другие серверы по zeroconf). Учитывая, что это ноутбук, данный функционал я счел очень полезным, но с ним возникла проблема.
# При смене sink на pulseaudio сервера, звук передается на сервер, но видео начинает тупить и зависает. Попытка поставить самую последнюю версию pulseaudio и на сервере и на ноутбуке ни к чему не привела.
# =============================================

echo ""
echo -e "${GREEN}==> ${NC}Установить Blueman - диспетчер bluetooth устройств?"
#echo -e "${BLUE}:: ${NC}Установить Blueman - диспетчер bluetooth устройств?" 
#echo 'Установить Blueman - диспетчер bluetooth устройств?'
# Install Blueman-bluetooth device Manager?
echo -e "${CYAN}:: ${BOLD}Blueman - это полнофункциональный менеджер Bluetooth, написанный на GTK. ${NC}"
echo -e "${YELLOW}=> ${NC}Обязательно включите демон Bluetooth и запустите Blueman с blueman-applet. Графическую панель настроек можно запустить с помощью blueman-manager."
echo " Чтобы получать файлы, не забудьте щелкнуть правой кнопкой мыши значок Blueman на панели задач> Локальные службы> Передача> Получение файлов (Object Push) и установить флажок 'Принимать файлы с доверенных устройств'. "
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In this option, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_blueman  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_blueman" =~ [^10] ]]
do
    :
done 
if [[ $i_blueman == 0 ]]; then 
echo ""  
echo " Установка Blueman пропущена "
elif [[ $i_blueman == 1 ]]; then 
  echo ""
  echo " Установка Blueman (менеджер Bluetooth) "
sudo pacman -S blueman --noconfirm  # blueman --диспетчер bluetooth устройств (полезно для i3)
echo "" 
echo " Установка Blueman (менеджер Bluetooth) завершена "
fi
# -------------------------------------------------------------------
# Blueman:
# https://wiki.archlinux.org/index.php/Blueman
# --------------------------------------------------------------------

clear  
echo -e "${MAGENTA}
  <<< Установка Архиваторов (консольных), дополнений для архиваторов, менеджеров архивов (графический интерфейс) >>> ${NC}"
# Install Archivers (console), add-ons to archivers, archive managers (graphical interface)
echo ""
echo -e "${GREEN}==> ${NC}Ставим Архиваторы (консольные) - компрессионные инструменты"
#echo -e "${BLUE}:: ${NC}Ставим Архиваторы (консольные) - компрессионные инструменты" 
#echo 'Ставим Архиваторы - "Компрессионные Инструменты" и дополнения'
# Installing Archivers-Compression Tools and add-ons
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (zip, unzip, unrar, p7zip, zlib, zziplib)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_zip  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_zip" =~ [^10] ]]
do
    :
done 
if [[ $i_zip == 0 ]]; then 
echo ""  
echo " Установка консольных архиваторов пропущена "
elif [[ $i_zip == 1 ]]; then
  echo ""
  echo " Установка компрессионных инструментов "
sudo pacman -S zip unzip unrar p7zip zlib zziplib --noconfirm  # Компрессор / архиватор для создания и изменения zip-файлов; Для извлечения и просмотра файлов в архивах .zip; Программа распаковки RAR; Файловый архиватор из командной строки с высокой степенью сжатия; Библиотека сжатия, реализующая метод сжатия deflate, найденный в gzip и PKZIP; Легкая библиотека, которая предлагает возможность легко извлекать данные из файлов, заархивированных в один zip-файл.  
echo "" 
echo " Установка (консольных) архиваторов завершена "
fi

clear
echo "" 
echo -e "${GREEN}==> ${NC}Ставим дополнения (утилиты) для работы с архивами"
#echo -e "${BLUE}:: ${NC}Ставим дополнения (утилиты) для работы с архивами" 
#echo 'Ставим дополнения к Архиваторам'
# Adding extensions to Archivers
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (lha unace lrzip sharutils uudeview arj cabextract)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " prog_zip  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_zip" =~ [^10] ]]
do
    :
done 
if [[ $prog_zip == 0 ]]; then 
echo ""  
echo " Установка дополнительных утилит для работы с архивами пропущена "
elif [[ $prog_zip == 1 ]]; then 
  echo ""
  echo " Установка дополнительных утилит для работы с архивами "
sudo pacman -S lha unace lrzip sharutils arj cabextract --noconfirm # Бесплатная программа для архивирования LZH / LHA; Инструмент для извлечения проприетарного формата архива ace; Многопоточное сжатие с помощью rzip / lzma, lzo и zpaq; Делает так называемые архивы оболочки из множества файлов; Бесплатный и портативный клон архиватора ARJ; Программа для извлечения файлов Microsoft CAB (.CAB).
sudo pacman -S uudeview --noconfirm  # UUDeview помогает передавать и получать двоичные файлы с помощью почты или групп новостей. Включает файлы библиотеки - (мощный декодер бинарных файлов) http://www.fpx.de/fp/Software/UUDeview/
sudo pacman -S snappy --noconfirm  # Библиотека быстрого сжатия и распаковки (на порядок быстрее других) https://github.com/google/snappy
echo "" 
echo " Установка дополнительных утилит (пакетов) для работы с архивами выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Ставим Менеджер архивов (графический интерфейс)"
#echo -e "${BLUE}:: ${NC}Ставим Менеджер архивов (графический интерфейс)" 
#echo 'Ставим Менеджер архивов (графический интерфейс)'
# Setting the archive Manager (graphical interface)
echo -e "${MAGENTA}:: ${NC}Выберите графический интерфейс для установленных (пакетов) архиваторов - (консольных), если установлены соответствующие. "
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo " 1 - File Roller - Легковесный менеджер архивов для среды рабочего стола GNOME, можно использовать и для другого DE (XFCE, LXDE, Lxqt...), то выбирайте вариант - "1". "
echo " File Roller поддерживает множество типов архивов, включая gzip (tar.gz, tar.xz, tgz), bzip (tar.bz, tbz), bzip2 (tar.bz2, tbz2), Z (tar.Z, taz), lzop ( tar.lzo, tzo), zip, jar (jar, ear, war), lha, lzh, rar, ace, 7z, alz, ar и arj. "
echo " Кроме того, он поддерживает типы архивов cab, cpio, deb, iso, cbr, rpm, bin, sit, tar.7z, cbz и zoo, а также отдельные файлы, сжатые с помощью xz, gzip, bzip, bzip2. , lzop, lzip, z или rzip алгоритмы сжатия. "
echo " 2 - Ark (в переводе Ковчег) - Менеджер архивов для среды рабочего стола KDE(Plasma), можно использовать и для другого DE, то выбирайте вариант - "2". "
echo " Ark поддерживает работу со всеми основными форматами архивов: - (tar, gzip, bzip, bzip2, zip, xpi, lha, zoo, ar, rar) и некоторые другие. Поддерживаются и двойные архивы (например, tar.gz, tzr.bz2 и прочие). "
echo " 3 - Xarchiver (GTK+2) - Легковесный настольный независимый менеджер архивов, созданный с помощью набора инструментов (GTK+2), можно использовать с любой средой рабочего стола, то выбирайте вариант - "3". "
echo " Xarchiver поддерживает работу со всеми основными форматами архивов: - (7-zip, arj, bzip2, gzip, rar, lha, lzma, lzop, deb, rpm, tar, zip) и некоторые другие. Поддерживаются и двойные архивы (например, zip, 7-zip, rar и прочие). "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке" 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - File Roller,     2 - Ark,     3 - Xarchiver (GTK+2), 

    0 - Пропустить установку: " gui_archiver  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$gui_archiver" =~ [^1230] ]]
do
    :
done 
if [[ $gui_archiver == 0 ]]; then 
echo ""   
echo " Установка Менеджера архивов (графического интерфейса) пропущено "
elif [[ $gui_archiver == 1 ]]; then
echo ""    
echo " Установка Менеджера архивов (file-roller) "
sudo pacman -S file-roller --noconfirm  # легковесный архиватор ( для xfce-lxqt-lxde-gnome ) 
elif [[ $gui_archiver == 2 ]]; then
echo ""    
echo " Установка Менеджера архивов (ark) "
sudo pacman -S ark --noconfirm  # архиватор для ( Plasma(kde)- так же можно использовать, и для другого de )
elif [[ $gui_archiver == 3 ]]; then
echo ""    
echo " Установка Менеджера архивов (xarchiver-gtk2) "    
sudo pacman -S xarchiver-gtk2 --noconfirm  # легкий настольный независимый менеджер архивов  
fi

clear
echo -e "${MAGENTA}
  <<< Установка дополнительного софта (пакетов) для Archlinux >>> ${NC}"
# Installing additional software (packages) for Archlinux

echo ""
echo -e "${GREEN}==> ${NC}Установка дополнительных базовых программ (пакетов)"
#echo -e "${BLUE}:: ${NC}Установка дополнительных базовых программ (пакетов)" 
#echo 'Установка дополнительных базовых программ (пакетов)'
# Installing additional basic programs (packages)
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (aspell-ru, arch-install-scripts, bash-completion, cmake, dosfstools, f2fs-tools, sane, gvfs, gnu-netcat, iftop, nmap, ncdu, hydra, isomd5sum, python-isomd5sum, translate-shell, mc, pv, sox, youtube-dl, speedtest-cli, python-pip, pwgen, scrot, xsel, powertop, smartmontools, ethtool, glances, xterm, desktop-file-utils, gtop, lib32-curl, gpm, hddtemp, memtest86+, xorg-xkill)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_soft  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_soft" =~ [^10] ]]
do
    :
done 
if [[ $in_soft == 0 ]]; then 
clear
echo ""   
echo " Установка дополнительных базовых программ (пакетов) пропущена "
elif [[ $in_soft == 1 ]]; then
  echo ""  
  echo " Установка дополнительных базовых программ (пакетов) "
sudo pacman -S aspell-ru arch-install-scripts bash-completion cmake dosfstools f2fs-tools sane gvfs gnu-netcat iftop nmap ncdu hydra isomd5sum python-isomd5sum translate-shell mc pv sox youtube-dl speedtest-cli python-pip pwgen scrot xsel powertop smartmontools ethtool glances xterm desktop-file-utils gtop lib32-curl gpm hddtemp memtest86+ xorg-xkill --noconfirm  # reflector git curl  - пока присутствует в pkglist.x86_64   
clear
echo ""   
echo " Установка дополнительных базовых программ (пакетов) выполнена "
fi

echo ""
echo -e "${GREEN}==> ${NC}Установка Интерактивного просмотрщика процессов (системы) Htop"
#echo -e "${BLUE}:: ${NC}Установка Интерактивного просмотрщика процессов (системы)" 
#echo 'Установка Интерактивного просмотрщика процессов (системы)'
# Installing The interactive process viewer (system)
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (htop - интерактивный просмотрщик запущенных процессов, iotop - просмотр процессов ввода-вывода по использованию жесткого диска)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_htop  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_htop" =~ [^10] ]]
do
    :
done 
if [[ $i_htop == 0 ]]; then
clear
echo "" 
echo " Установка просмотрщика процессов (системы) пропущена "
elif [[ $i_htop == 1 ]]; then
  echo ""    
  echo " Установка утилиты (пакетов) "   
sudo pacman -S htop iotop --noconfirm
#sudo pacman -S atop --noconfirm  # сбор статистики и наблюдение за системой в реальном времени
clear
echo ""   
echo " Установка htop, iotop (пакетов) выполнена "
fi

echo ""
echo -e "${GREEN}==> ${NC}Установка терминальных утилит (пакетов) для вывода информации о системе (с лого в консоли)"
#echo -e "${BLUE}:: ${NC}Установка терминальных утилит для вывода информации о системе" 
#echo 'Установка терминальных утилит для вывода информации о системе'
# Installing terminal utilities for displaying system information
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo " 1 - ScreenFetch - Скрипт CLI Bash для отображения информации о системе, то выбирайте вариант - "1". "
echo -e "${MAGENTA}:: ${NC}Простая терминальная утилита для вывода информации о системе, драйвере и ОЗУ в Linux."
echo " 2 - Neofetch - Инструмент системной информации CLI, написанный на BASH, который поддерживает отображение изображений, то выбирайте вариант - "2". "
echo " 3 - Archey3 - это простой скрипт Python, который печатает основную системную информацию и ASCII-изображение логотипа Arch Linux, то выбирайте вариант - "3". "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В этом действии выбор остаётся за вами. "
# Be careful! The installation process was fully automatic. In this action, the choice is yours.
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления" 
#echo 'Установка производится в порядке перечисления'
# Installation Is performed in the order listed
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - ScreenFetch,     2 - Neofetch,     3 - Archey3,     4 - ScreenFetch, Neofetch, Archey3,

    0 - Пропустить установку: " i_information  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_information" =~ [^12340] ]]
do
    :
done 
if [[ $i_information == 0 ]]; then 
echo ""    
echo " Установка утилит (пакетов) для вывода информации о системе пропущена "
elif [[ $i_information == 1 ]]; then
echo ""    
echo " Установка утилиты (пакета) ScreenFetch "  
sudo pacman -S screenfetch --noconfirm 
elif [[ $i_information == 2 ]]; then
echo ""    
echo " Установка утилиты (пакета) Neofetch "     
sudo pacman -S neofetch --noconfirm
elif [[ $i_information == 3 ]]; then
echo ""    
echo " Установка утилиты (пакета) Archey3 " 
sudo pacman -S archey3 --noconfirm
elif [[ $i_information == 4 ]]; then
echo ""    
echo " Установка утилит (пакетов) ScreenFetch, Neofetch, Archey3 " 
sudo pacman -S screenfetch neofetch archey3 --noconfirm 
fi

clear
echo -e "${MAGENTA}
  <<< Установка Мультимедиа аудиоплееров, видео-проигрывателей, утилит и кодеков в Archlinux >>> ${NC}"
# Installing Multimedia audio players, video players, utilities, and codecs in Archlinux

echo ""
echo -e "${GREEN}==> ${NC}Установка мультимедиа кодеков (multimedia codecs), и утилит"
#echo -e "${BLUE}:: ${NC}Установка мультимедиа кодеков (multimedia codecs), и утилит" 
#echo 'Установка Мультимедиа кодеков (multimedia codecs), и утилит'
# Installing Multimedia codecs and utilities
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (a52dec, faac, faad2, flac, jasper, lame, libdca, libdv, libmad, libmpeg2, libtheora, libvorbis, libxv, wavpack, x264, xvidcore, gst-plugins-base, gst-plugins-base-libs, gst-plugins-good, gst-plugins-bad, gst-plugins-ugly, libdvdcss, libdvdread, libdvdnav, dvd+rw-tools, dvdauthor, dvgrab, cdrdao, gst-libav, gst-libav, gpac)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_multimedia  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_multimedia" =~ [^10] ]]
do
    :
done 
if [[ $i_multimedia == 0 ]]; then 
clear
echo ""   
echo " Установка мультимедиа кодеков и утилит (пакетов) пропущена "
elif [[ $i_multimedia == 1 ]]; then
  echo ""   
  echo " Установка мультимедиа кодеков и утилит (пакетов) "
sudo pacman -S a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore libdvdcss libdvdread libdvdnav dvd+rw-tools dvdauthor dvgrab cdrdao gpac --noconfirm 
# Устанавливаем кодеки  
sudo pacman -S gstreamer gstreamer-vaapi gst-libav gst-plugins-bad gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-ugly --noconfirm   # https://gstreamer.freedesktop.org/
clear
echo ""   
echo " Установка мультимедиа кодеков и утилит (пакетов) выполнена "
fi

echo ""
echo -e "${GREEN}==> ${NC}Установка Мультимедиа аудиоплеера и видео-проигрывателей"
#echo -e "${BLUE}:: ${NC}Установка Мультимедиа плееров и утилит (пакетов)" 
#echo 'Установка Мультимедиа утилит'
# Installing Multimedia utilities
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo " 1 - Audacious - Легкий, продвинутый аудиоплеер, ориентированный на качество звука. "
echo " 2 - Smplayer - Медиаплеер со встроенными кодеками, который может воспроизводить практически все видео и аудио форматы. "
echo " 3 - VLC - Многоплатформенный проигрыватель MPEG, VCD / DVD и DivX. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В этом действии выбор остаётся за вами. "
# Be careful! The installation process was fully automatic. In this action, the choice is yours.
echo -e "${YELLOW}==> ${NC}Установка будет производится в порядке перечисления (по очереди)" 
#echo 'Установка будет производится в порядке перечисления (по очереди)'
# Installation will be performed in the order listed (one at a time)
echo "" 
echo -e "${BLUE}:: ${NC}Установить аудиоплеер Audacious?" 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_audacious  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_audacious" =~ [^10] ]]
do
    :
done 
if [[ $i_audacious == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_audacious == 1 ]]; then
  echo ""  
  echo " Установка аудиоплеер Audacious "
sudo pacman -S audacious audacious-plugins --noconfirm
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить медиаплеер Smplayer?" 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_smplayer  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_smplayer" =~ [^10] ]]
do
    :
done 
if [[ $i_smplayer == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_smplayer == 1 ]]; then
  echo ""  
  echo " Установка медиаплеер Smplayer "
sudo pacman -S smplayer smplayer-skins smplayer-themes smtube --noconfirm
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить многоплатформенный проигрыватель VLC ?" 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_vlc  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_vlc" =~ [^10] ]]
do
    :
done 
if [[ $i_vlc == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_vlc == 1 ]]; then
  echo ""  
  echo " Установка многоплатформенного проигрывателя VLC "
sudo pacman -S vlc --noconfirm
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo -e "${MAGENTA}
  <<< Установка Текстового редактора и утилиты разработки в Archlinux >>> ${NC}"
# Installing a Text editor and development utility in Archlinux

echo ""
echo -e "${GREEN}==> ${NC}Установка Текстового редактора (gedit)"
#echo -e "${BLUE}:: ${NC}Установка Текстового редактора (gedit)" 
#echo 'Установка Текстового редактора (gedit)'
# Installing a text editor (gedit)
echo -e "${MAGENTA}=> ${BOLD}Gedit - свободный текстовый редактор рабочей среды GNOME с поддержкой Юникода. ${NC}"
echo -e "${CYAN}:: ${NC}Описание: Поддержка вкладок; поддержка различных кодировок; подсветка синтаксиса для ряда языков программирования и разметки; есть возможность изменить шрифт и цвет фона; имеются функции поиска и замены текста; есть возможность включить нумерацию строк; поддержка проверки правописания; поддержка полноэкранного режима; есть возможность вставить дату; имеется возможность вывести статистику документа: кол-во строк, слов, символов; поддержка плагинов."
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (gedit, gedit-plugins)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_gedit # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_gedit" =~ [^10] ]]
do
    :
done 
if [[ $i_gedit == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_gedit == 1 ]]; then
  echo ""  
  echo " Установка текстового редактора (gedit) "
sudo pacman -S gedit gedit-plugins --noconfirm  # Текстовый редактор GNOME
echo ""   
echo " Установка текстового редактора (gedit) выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установка Утилиты разработки (geany)"
#echo -e "${BLUE}:: ${NC}Установка Утилиты разработки (geany)" 
#echo 'Установка Утилиты разработки (geany)'
# Installing the development utility (geany)
echo -e "${MAGENTA}=> ${BOLD}Geany - это текстовый редактор, который позволяет подключать сторонние библиотеки для создания полноценной среды разработки. ${NC}"
echo -e "${CYAN}:: ${NC}Основные функции Geany: Выделение синтаксиса; свертывание блоков кода (Code folding); автозавершение имен, слов; работа со сниппетами (фрагментами кода); автоматическое закрытие тегов XML и HTML; поддержка языков C, Java, PHP, HTML, Python, Perl, Pascal и других; навигация по коду; сборка - система для компиляции и исполнения кода; простое управление проектом; интерфейс для модулей; советы, списки имен."
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (geany, geany-plugins)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_geany  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_geany" =~ [^10] ]]
do
    :
done 
if [[ $i_geany == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_geany == 1 ]]; then
  echo ""  
  echo " Установка утилиты разработки (geany) "
sudo pacman -S geany geany-plugins --noconfirm  # Быстрая и легкая IDE
echo ""   
echo " Установка утилиты разработки (geany) выполнена "
fi

clear
echo -e "${MAGENTA}
  <<< Установка утилит (пакетов) управления электронной почтой, новостными лентами, чатом и группам >>> ${NC}"
# Installing utilities (packages) for managing email, news feeds, chat, and groups

echo ""
echo -e "${GREEN}==> ${NC}Ставим Thunderbird - управления электронной почтой и новостными лентами"
#echo -e "${BLUE}:: ${NC}Управления электронной почтой, новостными лентами, чатом и группам" 
#echo 'Управления электронной почтой, новостными лентами, чатом и группам'
# Manage email, news feeds, chat, and groups
echo -e "${MAGENTA}:: ${BOLD}Thunderbird - Автономная, бесплатная кроссплатформенная свободно распространяемая программа для работы с электронной почтой и группами новостей, а при установке расширения Lightning, и с календарём. ${NC}"
echo -e "${CYAN}:: ${NC}Является составной частью проекта Mozilla (mozilla.org). Поддерживает протоколы: SMTP, POP3, IMAP, NNTP, RSS."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " prog_mail  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_mail" =~ [^10] ]]
do
    :
done 
if [[ $prog_mail == 0 ]]; then 
echo ""   
echo " Установка утилиты для управления электронной почтой и новостными лентами пропущена "
elif [[ $prog_mail == 1 ]]; then
  echo ""  
  echo " Установка утилиты (пакета) Thunderbird "
sudo pacman -S thunderbird thunderbird-i18n-ru --noconfirm  # программа для чтения почты и новостей от mozilla.org
echo ""   
echo " Установка утилиты (пакета) Thunderbird выполнена "
fi

clear 
echo ""
echo -e "${GREEN}==> ${NC}Ставим Pidgin (Мессенджер) - управления чатом и группам"
#echo -e "${BLUE}:: ${NC}Управления электронной почтой, новостными лентами, чатом и группам" 
#echo 'Управления электронной почтой, новостными лентами, чатом и группам'
# Manage email, news feeds, chat, and groups
echo -e "${MAGENTA}:: ${BOLD}Pidgin (Мессенджер) - Многопротокольный клиент обмена мгновенными сообщениями. ${NC}"
echo -e "${CYAN}:: ${NC}Pidgin - это чат-программа, которая позволяет вам одновременно входить в учетные записи в нескольких чат-сетях. Это означает, что Вы можете общаться с друзьями на XMPP и сидеть в IRC-канале одновременно."
echo " Модульный клиент мгновенного обмена сообщениями на основе библиотеки libpurple. Поддерживает наиболее популярные протоколы. Распространяется на условиях GNU General Public License. Позволяет сохранять комментарии к пользователям из контакт‐листа. Может объединять несколько контактов в один метаконтакт. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " prog_chat  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_chat" =~ [^10] ]]
do
    :
done 
if [[ $prog_chat == 0 ]]; then 
echo ""   
echo " Установка утилиты для управления чатом и группам пропущена "
elif [[ $prog_chat == 1 ]]; then
  echo ""  
  echo " Установка утилиты (пакета) Pidgin (Мессенджер) "
sudo pacman -S pidgin pidgin-hotkeys --noconfirm  # клиент обмена мгновенными сообщениями
echo ""   
echo " Установка утилиты (пакета) Pidgin выполнена "
fi
# ------------------------
# Mozilla Thunderbird 
# https://www.thunderbird.net/ru/
# Pidgin (Мессенджер)
# https://www.pidgin.im/
# =============================

clear
echo ""
echo -e "${GREEN}==> ${NC}Установка Браузеров и медиа-плагинов"
#echo -e "${BLUE}:: ${NC}Установка Браузеров и медиа-плагинов" 
#echo 'Установка Браузеров и медиа-плагинов'
# Installing Browsers and media plugins
echo -e "${MAGENTA}:: ${BOLD}Веб-браузер Google Ghrome, и Vivaldi будут представлены для установки в следующем скрипте, так как устанавливаются из 'AUR', или установите их сами. ${NC}"
echo -e "${CYAN}:: ${NC}Другие предложенные веб-браузеры Вы можете установить, либо пропустите установку."
echo " В установку включены поддерживаемые плагины: flashplugin - Adobe Flash Player (NPAPI-версия), и pepper-flash - Adobe Flash Player (PPAPI-версия). "
echo " 1 - Firefox - Популярный, графический, автономный веб-браузер, с открытым исходным кодом, разрабатываемый Mozilla(mozilla.org), то выбирайте вариант - "1". "
echo " Единственный поддерживаемый Firefox плагин - flashplugin - Adobe Flash Player (NPAPI-версия). "
echo " 2 - Chromium - Графический веб-браузер, с открытым исходным кодом, основанный на движке Blink, созданный для скорости, простоты и безопасности, разрабатываемый Google совместно с сообществом (и другими корпорациями), то выбирайте вариант - "2". "
echo " Поддерживаемый плагин - pepper-flash - Adobe Flash Player (PPAPI-версия): эти плагины работают в Chromium (и Chrome), Opera и Vivaldi. "
echo " 3 - Opera - Графический веб-браузер, с открытым исходным кодом, основанный на движке Blink, быстрый, безопасный и простой в использовании браузер, теперь со встроенным блокировщиком рекламы, функцией экономии заряда батареи и бесплатным VPN, то выбирайте вариант - "3". "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке" 
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Firefox (+ flashplugin),     2 - Chromium (+ pepper-flash),     3 - Opera (+ pepper-flash),    

    4 - Установить все веб-браузеры,     0 - Пропустить установку: " in_browser  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_browser" =~ [^12340] ]]
do
    :
done 
if [[ $in_browser == 0 ]]; then 
clear
echo ""    
echo " Установка веб-браузера(ов) пропущена "
elif [[ $in_browser == 1 ]]; then
echo ""   
echo " Установка веб-браузера Firefox (+ flashplugin) "
#sudo pacman -S firefox firefox-i18n-ru firefox-spell-ru flashplugin --noconfirm
sudo pacman -S firefox --noconfirm  # Автономный веб-браузер от mozilla.org
sudo pacman -S firefox-i18n-ru --noconfirm  # Русский языковой пакет для Firefox
sudo pacman -S firefox-spell-ru --noconfirm  # Русский словарь проверки орфографии для Firefox
sudo pacman -S flashplugin --noconfirm  # Adobe Flash Player NPAPI
#sudo pacman -S firefox-developer-edition firefox-developer-edition-i18n-ru firefox-spell-ru flashplugin --noconfirm  # Версия для разработчиков
clear
echo ""    
echo " Установка веб-браузера Firefox (+ flashplugin) выполнена "
elif [[ $in_browser == 2 ]]; then    
echo "" 
echo " Установка веб-браузера Chromium (+ pepper-flash) " 
#sudo pacman -S chromium pepper-flash --noconfirm   
sudo pacman -S chromium --noconfirm  # Веб-браузер, созданный для скорости, простоты и безопасности
sudo pacman -S pepper-flash --noconfirm  # Adobe Flash Player PPAPI
clear
echo ""    
echo " Установка веб-браузера Chromium (+ pepper-flash) выполнена "
elif [[ $in_browser == 3 ]]; then
echo "" 
echo " Установка веб-браузера Opera (+ pepper-flash) "
#sudo pacman -S opera opera-ffmpeg-codecs pepper-flash --noconfirm  
sudo pacman -S opera --noconfirm  # Быстрый и безопасный веб-браузер
sudo pacman -S opera-ffmpeg-codecs --noconfirm  # дополнительная поддержка проприетарных кодеков для оперы
sudo pacman -S pepper-flash --noconfirm  # Adobe Flash Player PPAPI
clear
echo ""    
echo " Установка веб-браузера Opera (+ pepper-flash) выполнена "
elif [[ $in_browser == 4 ]]; then
echo "" 
echo " Установка веб-браузеров Chromium Opera Firefox "    
sudo pacman -S chromium opera pepper-flash opera-ffmpeg-codecs firefox firefox-i18n-ru firefox-spell-ru flashplugin --noconfirm 
clear
echo ""    
echo " Установка веб-браузеров выполнена "
fi

echo ""
echo -e "${GREEN}==> ${NC}Установка BitTorrent-клиентов - Transmission, qBittorrent, Deluge (GTK)(Qt)(GTK+)"
#echo -e "${BLUE}:: ${NC}Установка Torrent клиентов - Transmission, qBittorrent, Deluge (GTK)(Qt)(GTK+)" 
#echo 'Установка Torrent клиентов - Transmission, qBittorrent, Deluge (GTK)(Qt)(GTK+)'
# Installing Torrent clients - Transmission, qBittorrent, Deluge (GTK) (Qt) (GTK+)
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo " 1 - Transmission - это легкий, быстрый, простой, бесплатный и кроссплатформенный BitTorrent-клиент (GTK + GUI). "
echo " 2 - qBittorrent - Усовершенствованный клиент BitTorrent, написанный на C ++, основанный на инструментарии Qt и libtorrent-rasterbar. "
echo " 3 - Deluge - BitTorrent-клиент написанное на Python 3, с несколькими пользовательскими интерфейсами в модели клиент / сервер, то выбирайте вариант - "3". "
echo " Оно имеет множество функций, поддержку DHT, магнитные ссылки, систему плагинов, поддержку UPnP, полнопотоковое шифрование, поддержка прокси и три различных клиентских приложения. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке" 
echo "" 
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Transmission (GTK+) или (Qt),     2 - qBittorrent (Qt),     3 - Deluge (GTK),    

    0 - Пропустить установку: " in_torrent  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_torrent" =~ [^1230] ]]
do
    :
done 
if [[ $in_torrent == 0 ]]; then 
clear
echo ""    
echo " Установка BitTorrent-клиентов пропущена "
elif [[ $in_torrent == 1 ]]; then
  echo "" 
  echo " Установка BitTorrent-клиента Transmission (GTK+) "   
sudo pacman -S transmission-gtk transmission-cli --noconfirm  # графический интерфейс GTK 3, и демон, с CLI 
#sudo pacman -S transmission-qt transmission-cli --noconfirm  # графический интерфейс Qt 5, и демон, с CLI 
#sudo pacman -S transmission-remote-gtk transmission-cli --noconfirm  # графический интерфейс GTK 3 для демона, и демон, с CLI
clear
echo ""    
echo " Установка BitTorrent-клиента Transmission выполнена "
elif [[ $in_torrent == 2 ]]; then
  echo "" 
  echo " Установка BitTorrent-клиента qBittorrent (Qt) "   
sudo pacman -S qbittorrent --noconfirm
clear
echo ""    
echo " Установка BitTorrent-клиента qBittorrent выполнена "
elif [[ $in_torrent == 3 ]]; then
  echo "" 
  echo " Установка BitTorrent-клиента Deluge (GTK) "    
sudo pacman -S deluge --noconfirm
clear
echo ""    
echo " Установка BitTorrent-клиента Deluge выполнена "
fi
# ------------------------------------
# Transmission-cli - демон с интерфейсами CLI и веб-клиента ( http: // localhost: 9091 ).
# Transmission-remote-cli - Интерфейс Curses для демона.
# Transmission-gtk - пакет GTK + 3.
# Transmission-qt - пакет Qt5.
# Transmission-remote-gtk - Графический интерфейс GTK 3 
####################################

echo ""
echo -e "${GREEN}==> ${NC}Установим Офисный пакет - LibreOffice: (libreOffice-still, или libreOffice-fresh)"
#echo -e "${BLUE}:: ${NC}Установка Офиса (LibreOffice-still, или LibreOffice-fresh)" 
#echo 'Установка Офиса (LibreOffice-still, или LibreOffice-fresh)'
# Office installation (LibreOffice-still, or LibreOffice-fresh)
echo -e "${MAGENTA}:: ${BOLD}Офисные пакеты - FreeOffice, WPS Office, Apache OpenOffice - будут представлены для установки в следующем скрипте, так как устанавливаются из 'AUR', или установите (пакеты) сами. ${NC}"
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo " 1 - LibreOffice-still - это мощный, официально поддерживаемый офисный пакет, имеется стабильная ветвь обновлений, то выбирайте вариант - "1". "
echo " 2 - LibreOffice-fresh - это офисный пакет, новые функции, улучшения программы появляются сначала здесь, часто обновляется, то выбирайте вариант - "2". "
echo " Убедитесь, что у Вас установлены шрифты: - ttf-dejavu, artwiz-fonts (AUR), в противном случае Вы увидите прямоугольники вместо букв. Пакет artwiz-fonts (AUR) - Это набор (улучшенных) шрифтов artwiz, его можно установить позже. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. Вы можете пропустить этот шаг, если не уверены в правильности выбора. "
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке" 
echo "" 
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - LibreOffice-still,     2 - LibreOffice-fresh,    

    0 - Пропустить установку: " t_office  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_office" =~ [^120] ]]
do
    :
done 
if [[ $t_office == 0 ]]; then 
#clear
echo ""    
echo " Установка пакета LibreOffice пропущена "
elif [[ $t_office == 1 ]]; then
echo ""    
echo " Установка LibreOffice-still "
# sudo pacman -S libreoffice-still libreoffice-still-ru --noconfirm
sudo pacman -S libreoffice-still --noconfirm  # Филиал обслуживания LibreOffice
sudo pacman -S libreoffice-still-ru --noconfirm  # Пакет русского языка для LibreOffice still
sudo pacman -S libreoffice-extension-writer2latex --noconfirm  # набор расширений LibreOffice для преобразования и работы с LaTeX в LibreOffice
sudo pacman -S hunspell --noconfirm  # Библиотека и программа для проверки орфографии и морфологического анализатора
sudo pacman -S hyphen --noconfirm  # Библиотека для качественной расстановки переносов и выравнивания
sudo pacman -S mythes --noconfirm  # libmythes  Простой тезаурус (Словарь понятий или терминов). В нем можно найти слова синонимы или антонимы к интересующему понятию (слову, термину).
#clear
echo ""    
echo " Установка LibreOffice-still выполнена "
elif [[ $t_office == 2 ]]; then
echo "" 
echo " Установка LibreOffice-fresh "   
# sudo pacman -S libreoffice-fresh libreoffice-fresh-ru --noconfirm
sudo pacman -S libreoffice-fresh --noconfirm  # Ветвь LibreOffice, содержащая новые функции и улучшения программы
sudo pacman -S libreoffice-fresh-ru --noconfirm  # Пакет русского языка для LibreOffice Fresh
#clear
echo ""    
echo " Установка LibreOffice-fresh выполнена "
fi
# ------------------------------------
# Поддержка языков в LibreOffice реализуется отдельными пакетами.
# Смотреть список пакетов:
# $ pacman -Ss libreoffice | grep \\-ru
# extra/libreoffice-fresh-ru 5.3.0-1
# extra/libreoffice-still-ru 5.2.5-1
# После чего установите LibreOffice необходимой версии с русской локализацией.
# -----------------------------------------
# https://www.libreoffice.org/
# LibreOffice-still  - Филиал обслуживания LibreOffice 
# https://www.archlinux.org/packages/extra/x86_64/libreoffice-still/
# Libreoffice-still-ru  -  Пакет русского языка для LibreOffice still
# https://www.archlinux.org/packages/extra/any/libreoffice-still-ru/
# https://www.documentfoundation.org
# LibreOffice-fresh  -  Ветвь LibreOffice, содержащая новые функции и улучшения программы
# https://www.archlinux.org/packages/extra/x86_64/libreoffice-fresh/
# Libreoffice-fresh-ru  -  Пакет русского языка для LibreOffice Fresh
# https://www.archlinux.org/packages/extra/any/libreoffice-fresh-ru/
# https://www.documentfoundation.org
# ========================================

clear
echo -e "${MAGENTA}
  <<< Установка рекомендованных программ (пакетов) - по вашему выбору и желанию >>> ${NC}"
# Installation of recommended programs (packages) - according to your choice and desire 

echo ""
echo -e "${GREEN}==> ${BOLD}Установить рекомендованные программы (пакеты)? ${NC}"
#echo -e "${BLUE}:: ${NC}Установить рекомендованные программы (пакеты)?"
#echo 'Установить рекомендованные программы?'
# Install the recommended programs
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (gparted, grub-customizer, dconf-editor, conky, conky-manager, obs-studio, filezilla, telegram-desktop, flameshot, redshift, bleachbit, doublecmd-gtk2, keepass, veracrypt, nomacs, onboard, meld, uget, plank, openshot, galculator-gtk2, gnome-calculator)." 
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo -e "${YELLOW}==> ${NC}Установка будет производится в порядке перечисления (по очереди)" 
#echo 'Установка будет производится в порядке перечисления (по очереди)'
# Installation will be performed in the order listed (one at a time)
echo ""
echo -e "${BLUE}:: ${NC}Установить Gparted?" 
echo -e "${MAGENTA}:: ${BOLD}GParted (Gnome Partition Editor) - это программа для создания, изменения и удаления дисковых разделов. ${NC}"
echo " GParted - Клон Partition Magic, интерфейс для GNU Parted. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_gparted  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_gparted" =~ [^10] ]]
do
    :
done 
if [[ $i_gparted == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_gparted == 1 ]]; then
  echo ""  
  echo " Установка Gparted "
sudo pacman -S gparted --noconfirm  # (создавать, удалять, перемещать, копировать, изменять размер и др.) без потери данных.
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Grub Customizer?" 
echo -e "${MAGENTA}:: ${BOLD}Grub Customizer - это новый менеджер настроек для GRUB2 на гуях. ${NC}"
echo " На данный момент он позволяет: переименовывать, переупорядочивать, удалять, добавлять и скрывать элементы меню выбора загрузчика. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_customizer  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_customizer" =~ [^10] ]]
do
    :
done 
if [[ $in_customizer == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_customizer == 1 ]]; then
  echo ""  
  echo " Установка Grub Customizer "
sudo pacman -S grub-customizer --noconfirm  # Графический менеджер настроек grub2
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Редактор dconf (пакет dconf-editor)?" 
echo -e "${MAGENTA}:: ${BOLD}Редактор dconf - общий инструмент для настройки GNOME 3, Unity, MATE и Cinnamon. ${NC}"
echo " Файл dconf, также называют системным реестром Linux. Этот файл двоичный, создается в момент создания профиля нового пользователя. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_dconf  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_dconf" =~ [^10] ]]
do
    :
done 
if [[ $i_dconf == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_dconf == 1 ]]; then
  echo ""  
  echo " Установка Редактора dconf "
sudo pacman -S dconf-editor --noconfirm  # редактор dconf
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Conky и Conky-Manager (пакеты conky conky-manager)?" 
echo -e "${MAGENTA}:: ${BOLD}Conky - мощный и легко настраиваемый системный монитор. ${NC}"
echo -e "${CYAN}:: ${BOLD}Conky Manager - это графический интерфейс для управления файлами конфигурации Conky.${NC}"
echo " Он предоставляет опции для запуска и остановки, просмотра и редактирования тем Conky, установленных в системе. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_conky  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_conky" =~ [^10] ]]
do
    :
done 
if [[ $in_conky == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_conky == 1 ]]; then
  echo ""  
  echo " Установка утилит (пакетов) Conky и Conky-Manager "
sudo pacman -S conky conky-manager --noconfirm  # Легкий системный монитор для X; Графический интерфейс для управления конфигурационными файлами Conky с возможностью просмотра и редактирования тем
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Open Broadcaster Software®️ (OBS)?" 
echo -e "${MAGENTA}:: ${BOLD}OBS Studio - это бесплатное программное обеспечение с открытым исходным кодом для прямой трансляции и записи. ${NC}"
echo " Программа на русском языке для записи видео и стримов на Twitch, YouTube, GoodGame, SC2TV, Hitbox.TV и любые другие RTMP-серверы трансляций. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_obs  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_obs" =~ [^10] ]]
do
    :
done 
if [[ $in_obs == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_obs == 1 ]]; then
  echo ""  
  echo " Установка OBS Studio "
sudo pacman -S obs-studio --noconfirm  # для записи видео и потокового вещания
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить FileZilla (клиент FTP)?" 
echo -e "${MAGENTA}:: ${BOLD}FileZilla - это быстрый и надежный клиент FTP, FTPS и SFTP. ${NC}"
echo " С помощью специальных данных для доступа, выводит пользователю файловую систему определенного сайта. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_filezilla  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_filezilla" =~ [^10] ]]
do
    :
done 
if [[ $i_filezilla == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_filezilla == 1 ]]; then
  echo ""  
  echo " Установка FileZilla "
sudo pacman -S filezilla --noconfirm  # графический клиент для работы с FTP/SFTP
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Telegram Desktop (мессенджер)?" 
echo -e "${MAGENTA}:: ${BOLD}Telegram Desktop - это официальное приложение Telegram для настольных операционных систем. ${NC}"
echo " 'Telegram Desktop' - является прямой реализацией веб-сайта Telegram. Бесплатный (никаких платных подписок) мессенджер от компании Павла Дурова. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_telegram  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_telegram" =~ [^10] ]]
do
    :
done 
if [[ $i_telegram == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_telegram == 1 ]]; then
  echo ""  
  echo " Установка Telegram Desktop "
sudo pacman -S telegram-desktop --noconfirm  # Официальный клиент Telegram Desktop
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Flameshot (создания скриншотов)?" 
echo -e "${MAGENTA}:: ${BOLD}Flameshot - инструмент для создания и редактирования скриншотов в Linux. ${NC}"
echo " Что подкупило в Flameshot, так это то, что во время создания снимка имеется возможность редактирования, без необходимости предварительного сохранения снимка, т.е. создание и редактирование в одном окне или на лету. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_screen  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_screen" =~ [^10] ]]
do
    :
done 
if [[ $in_screen == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_screen == 1 ]]; then
  echo ""  
  echo " Установка Flameshot "
sudo pacman -S flameshot --noconfirm  # для создания снимков экрана
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Redshift (оберегает Ваше зрение)?" 
echo -e "${MAGENTA}:: ${BOLD}Redshift - регулирует цветовую температуру экрана в соответствии с окружающей обстановкой (временем суток). ${NC}"
echo " Делает работу за компьютером более комфортной и оберегая Ваше зрение. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_redshift  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_redshift" =~ [^10] ]]
do
    :
done 
if [[ $i_redshift == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_redshift == 1 ]]; then
  echo ""  
  echo " Установка Redshift "
sudo pacman -S redshift --noconfirm  
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить BleachBit (для тщательной очистки)?" 
echo -e "${MAGENTA}:: ${BOLD}BleachBit - это мощное приложение, предназначенное для тщательной очистки компьютера и удаления ненужных файлов, что помогает освободить место на дисках и удалить конфиденциальные данные. ${NC}"
echo " Это особенно полезно, когда Вы делитесь компьютером с другими людьми, и любой может найти вашу личную информацию. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_bleachbit  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_bleachbit" =~ [^10] ]]
do
    :
done 
if [[ $i_bleachbit == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_bleachbit == 1 ]]; then
  echo ""  
  echo " Установка BleachBit "
sudo pacman -S bleachbit --noconfirm  
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Double Commander (файловый менеджер)?" 
echo -e "${MAGENTA}:: ${BOLD}Double Commander - двухпанельный файловый менеджер с открытым исходным кодом, работающий под Linux (два варианта, с использованием библиотек GTK+ или Qt). ${NC}"
echo " Кроме стандартных возожностей файлового менеджера Double Commander поддерживает монтирование сетевых шар и локальных дисков, легкое создание символических и жестких ссылок, а также имеет очень много горячих кнопок. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_doublecmd  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_doublecmd" =~ [^10] ]]
do
    :
done 
if [[ $i_doublecmd == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_doublecmd == 1 ]]; then
  echo ""  
  echo " Установка Double Commander "
sudo pacman -S doublecmd-gtk2 --noconfirm  # двухпанельный файловый менеджер (GTK2)
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить KeePass (для хранения паролей)?" 
echo -e "${MAGENTA}:: ${BOLD}KeePass - простой в использовании менеджер паролей для Windows, Linux, Mac OS X и мобильных устройств. ${NC}"
echo " KeePass очень удобна и мобильна, ее можно переносить на любой диск компьютера, флешку и любое другое устройство. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_keepass  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_keepass" =~ [^10] ]]
do
    :
done 
if [[ $i_keepass == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_keepass == 1 ]]; then
  echo ""  
  echo " Установка KeePass "
sudo pacman -S keepass --noconfirm  # менеджер паролей
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить VeraCrypt (ПО для шифрования)?" 
echo -e "${MAGENTA}:: ${BOLD}VeraCrypt - шифрование диска с надежной защитой на основе TrueCrypt. ${NC}"
echo " Это - мощная программа с большим количеством функций. Программа предназначена для шифрования файлов, папок или целых дисков. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_encryption  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_encryption" =~ [^10] ]]
do
    :
done 
if [[ $in_encryption == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_encryption == 1 ]]; then
  echo ""  
  echo " Установка VeraCrypt "
sudo pacman -S veracrypt --noconfirm  
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Nomacs (для просмотра изображений)?" 
echo -e "${MAGENTA}:: ${BOLD}Nomacs - это бесплатная программа для просмотра изображений, Вы можете использовать его для просмотра всех распространенных форматов изображений, включая изображения RAW и psd. ${NC}"
echo " Nomacs предлагает полупрозрачные виджеты, которые отображают дополнительную информацию, такую ​​как эскизы, метаданные или гистограмму. Он может просматривать изображения в файлах ZIP или MS Office, которые можно извлечь в каталог. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_images  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_images" =~ [^10] ]]
do
    :
done 
if [[ $in_images == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_images == 1 ]]; then
  echo ""  
  echo " Установка Nomacs "
sudo pacman -S nomacs --noconfirm  # для просмотра изображений Qt
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Onboard (экранная клавиатура)?" 
echo -e "${MAGENTA}:: ${BOLD}Onboard - это экранная клавиатура полезна на планшетных ПК или для пользователей с ограниченными физическими возможностями. ${NC}"
echo " Экранные клавиатуры - это альтернативный метод ввода который может заменить физическую клавиатуру. Виртуальная клавиатура может понадобиться в различных ситуациях. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_keyboard  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_keyboard" =~ [^10] ]]
do
    :
done 
if [[ $i_keyboard == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_keyboard == 1 ]]; then
  echo ""  
  echo " Установка Onboard (экранной клавиатуры) "
sudo pacman -S onboard --noconfirm  # Экранная клавиатура
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Meld (для сравнения файлов)?" 
echo -e "${MAGENTA}:: ${BOLD}Meld - программа для сравнения содержимого текстовых файлов или каталогов. ${NC}"
echo " Сравнение двух-трёх файлов или каталогов. Создание файлов правки (англ. patch file) с описанием различий между файлами. Работа с системами управления версиями Git, Subversion, Mercurial, Bazaar и CVS. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_comparisons  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_comparisons" =~ [^10] ]]
do
    :
done 
if [[ $in_comparisons == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_comparisons == 1 ]]; then
  echo ""  
  echo " Установка Meld (сравнение файлов) "
sudo pacman -S meld --noconfirm  # для сравнения файлов, каталогов и рабочих копий
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Plank (док-панель)?" 
echo -e "${MAGENTA}:: ${BOLD}Plank - самая элегантная, простая док-панель в мире для linux. ${NC}"
echo " Эта панель минималистична во всем, начиная со своего размера и заканчивая основными функциями. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_panel  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_panel" =~ [^10] ]]
do
    :
done 
if [[ $in_panel == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_panel == 1 ]]; then
  echo ""  
  echo " Установка Plank (док-панель) "
sudo pacman -S plank --noconfirm  # док-панель
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить uGet (менеджер загрузок)?" 
echo -e "${MAGENTA}:: ${BOLD}uGet - это универсальный менеджер закачек, который поддерживает докачку файлов, сортировку по группам, закачку через торренты и мета-ссылки (с помощью плагина aria2). ${NC}"
echo " Это отличный менеджер загрузок с большим количеством функций. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_loading  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_loading" =~ [^10] ]]
do
    :
done 
if [[ $in_loading == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_loading == 1 ]]; then
  echo ""  
  echo " Установка uGet (менеджер загрузок) "
sudo pacman -S uget --noconfirm  # менеджер загрузок
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить OpenShot (нелинейный видеоредактор)?" 
echo -e "${MAGENTA}:: ${BOLD}OpenShot - это свободный нелинейный видеоредактор, отмеченный наградами с открытым исходным кодом. Он конечно уступает Davinci resolve, но, для того что бы сделать видеомонтаж например для ютуб, его вполне хватит. ${NC}"
echo " OpenShot был разработан с помощью Python, GTK и MLT Framework. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_openshot  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_openshot" =~ [^10] ]]
do
    :
done 
if [[ $i_openshot == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_openshot == 1 ]]; then
  echo ""  
  echo " Установка OpenShot (нелинейный видеоредактор) "
sudo pacman -S openshot --noconfirm  # Бесплатный видеоредактор
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Galculator (калькулятор)(на основе GTK+)(версия GTK2)?" 
echo -e "${MAGENTA}:: ${BOLD}Galculator - научный калькулятор для Linux. Galculator имеет три режима работы: (простой, научный и paper mode, в котором вычисления можно проводить путем ввода выражения в текстовое окно). ${NC}"
echo " Поддерживает десятичную, шестнадцатеричную, восьмеричную и двоичную системы счисления. Также поддерживаются разные угловые меры - градусы, радианы, грады. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_galculator  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_galculator" =~ [^10] ]]
do
    :
done 
if [[ $i_galculator == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_galculator == 1 ]]; then
  echo ""  
  echo " Установка Galculator (калькулятор) (на основе GTK+)(версия GTK2) "
sudo pacman -S galculator-gtk2 --noconfirm  # Научный калькулятор на основе GTK + (версия GTK2)
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить GNOME Calculator (калькулятор)?" 
echo -e "${MAGENTA}:: ${BOLD}GNOME Calculator - ранее известная как gcalctool(Calctool), является программным обеспечение калькулятор интегрирован с настольной GNOME среды. ${NC}"
echo " Научный калькулятор - он запрограммирован в C и Val и часть приложений GNOME Key. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_calculator  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_calculator" =~ [^10] ]]
do
    :
done 
if [[ $i_calculator == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_calculator == 1 ]]; then
  echo ""  
  echo " Установка GNOME Calculator (калькулятор) "
sudo pacman -S gnome-calculator --noconfirm  # Научный калькулятор GNOME
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${BOLD}Установить рекомендованные программы (пакеты)? ${NC}"
#echo -e "${BLUE}:: ${NC}Установить рекомендованные программы (пакеты)?"
#echo 'Установить рекомендованные программы?'
# Install the recommended programs
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (gnome-system-monitor, gnome-disk-utility, frei0r-plugins, clonezilla, psensor, copyq, grsync, numlockx, modem-manager-gui, rofi, gsmartcontrol, testdisk, lsof, dmidecode)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo -e "${YELLOW}==> ${NC}Установка будет производится сразу всех утилит (пакетов) - (без выбора)" 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_collection  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_collection" =~ [^10] ]]
do
    :
done 
if [[ $i_collection == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_collection == 1 ]]; then
  echo ""   
  echo " Установка рекомендованных утилит (пакетов) "
sudo pacman -S gnome-system-monitor gnome-disk-utility frei0r-plugins clonezilla psensor copyq grsync numlockx modem-manager-gui rofi gsmartcontrol testdisk lsof dmidecode --noconfirm  
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установим TLP - Для увеличения продолжительности времени работы от батареи"
#echo -e "${BLUE}:: ${NC}Установим TLP - Для увеличения продолжительности времени работы от батареи" 
#echo 'Установим TLP - Для увеличения продолжительности времени работы от батареи'
# Set TLP - to increase the duration Of battery life
echo -e "${MAGENTA}:: ${BOLD}TLP - это продвинутая, консольная утилита для управления питанием, которая автоматически применяет нужные настройки для конкретного аппаратного оборудования. ${NC}"
echo -e "${CYAN}:: ${NC}TLP применяет настройки автоматически при запуске и каждый раз при смене источника питания. Грубо говоря (мягко выражаясь), стоит только установить TLP и многое будет работать искаропки."
echo " Утилита TLP - будет очень актуальна, если Вы пользуетесь 'Ноутбуком'! "
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (tlp - расширенное управление питанием в Linux, tlp-rdw - Linux Advanced Power Management - Мастер радиоустройств)."
echo -e "${YELLOW}==> ${NC}Если у вас ThinkPad (ноутбук), или Интел платформа Sandy Bridge, то нужно установить следующие пакеты: - (раскомментируйте команду установки) "
echo " tp_smapi - необходим для пороговых значений заряда батареи ThinkPad, повторной калибровки и вывода специального статуса tlp-stat "
echo " acpi_call - необходим для пороговых значений заряда аккумулятора и повторной калибровки на Sandy Bridge и более новых моделях (X220 / T420, X230 / T430 и др.). "
echo " Используйте acpi_call-dkms, если ядра не из официальных репозиториев - (раскомментируйте команду установки). "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " prog_battery  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_battery" =~ [^10] ]]
do
    :
done 
if [[ $prog_battery == 0 ]]; then 
echo ""   
echo " Установка (пакетов) для управления питанием пропущена "
elif [[ $prog_battery == 1 ]]; then
  echo ""  
  echo " Установка (пакетов) для управления питанием "
sudo pacman -S tlp tlp-rdw --noconfirm 
#sudo pacman -S tp_smapi acpi_call --noconfirm  # Для ThinkPad (ноутбуков), или Интел платформ Sandy Bridge
#sudo pacman -S acpi_call-dkms --noconfirm  # если ядра не из официальных репозиториев
echo ""
echo " Установка утилит (пакетов) завершена " 
fi
# --------------------------------
# Управление питанием с помощью tlp (настройка производительности)
# https://manjaro.ru/how-to/upravlenie-pitaniem-s-pomoschyu-tlp-nastroyka-proizvoditelnosti.html
# https://wiki.archlinux.org/index.php/TLP
# https://linrunner.de/tlp/settings/
# https://linrunner.de/tlp/
# https://linrunner.de/tlp/settings/disks.html
# ===============================

clear
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_fat  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_fat" =~ [^10] ]]
do
    :
done 
if [[ $in_fat == 0 ]]; then
echo ""    
echo " Установка поддержки системой exFAT пропущена "
elif [[ $in_fat == 1 ]]; then
  echo ""  
  echo " Установка поддержки системой exFAT в Linux "
sudo pacman -S exfat-utils fuse-exfat --noconfirm  # Утилиты для файловой системы exFAT; Утилиты для файловой системы exFAT
# Важно! exfatprogs и exfat-utils (У них конфликтующие зависимости) - Ставим один из пакетов иначе конфликт!
# sudo pacman -S exfatprogs --noconfirm  # Утилиты файловой системы exFAT файловой системы в пространстве пользователя драйвера ядра Linux файловой системы exFAT 
fi
# --------------------------------------------------------
# Форматирую флешку (жесткий диск) под ArchLinux:
# mkfs.exfat /dev/sdc
# В Linux все проходит нормально. Носитель открывается, файлы копируются.
# Теоретический максимальный размер раздела FAT32 - 2 Тб, но Майкрософт начиная с WinXP не позволяет создать больше 32 Гб. exFAT, это модифицированная FAT32, которую можно «развернуть» на разделе более чем 32 Гб.
# --------------------------------------------------------

##### SSH (client) ###
clear
echo ""
echo -e "${GREEN}==> ${NC}Установить ssh(server) на Arch Linux - для удаленного доступа?"
#echo -e "${BLUE}:: ${NC}Установить ssh(server) на Arch Linux - для удаленного доступа?" 
#echo 'Установить ssh(клиент) для удаленного доступа?'
# Install ssh (client) for remote access?
echo -e "${MAGENTA}:: ${BOLD}Обычно при предоставлении удаленного доступа к Linux серверам вам предоставляется именно SSH (Secure Shell) доступ. ${NC}"
echo -e "${CYAN}:: ${NC}SSH - это Первоклассный инструмент подключения для удаленного входа по протоколу SSH."
echo " Это великий инструмент управления серверов, с помощью него можно всё что угодно реализовать, веб-платформу, фтп-сервер, VPN или любые другие сервера на базе данной ОС. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo "" 
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_ssh  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_ssh" =~ [^10] ]]
do
    :
done 
if [[ $i_ssh == 0 ]]; then  
echo ""  
echo " Установка пропущена "
elif [[ $i_ssh == 1 ]]; then 
  echo ""  
  echo " Установка (openssh) "  
sudo pacman -S openssh --noconfirm
echo "" 
echo " SSH (клиент) установлен "
fi

###### Flatpak ##############
clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Flatpak (инструмент для управления приложениями) на Arch Linux?"
#echo -e "${BLUE}:: ${NC}Установить Snap на Arch Linux?" 
#echo 'Установить Snap на Arch Linux?'
# To install Snap-on Arch Linux?
echo -e "${MAGENTA}:: ${BOLD}Flatpak - это система для создания, распространения и запуска изолированных настольных приложений в Linux. ${NC}"
echo -e "${CYAN}:: ${NC}Flatpak - это инструмент для управления приложениями и средами выполнения, которые они используют. В модели Flatpak приложения можно создавать и распространять независимо от хост-системы, в которой они используются, и они в некоторой степени изолированы от хост-системы («изолированы») во время выполнения.
Flatpak использует OSTree для распространения и развертывания данных."
echo -e "${CYAN}:: ${NC}Репозитории, которые он использует, являются репозиториями OSTree, и ими можно управлять с помощью утилиты ostree. Установленные среды выполнения и приложения являются проверками OSTree."
echo -e "${YELLOW}==> Примечание: ${NC}Если вы хотите создавать пакеты с плоскими пакетами, flatpak-builderвам необходимо установить дополнительные зависимости elfutils и patch."
echo " Приложение Flaptpak создается и запускается в изолированной среде, известной как 'песочница'. "
echo " Один из способов управления вашими Флэтпаками-это приложение Discover из проекта KDE. Вы можете установить пакет discover с помощью вашего менеджера пакетов. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В любой ситуации выбор всегда остаётся за вами. "
# Be careful! The installation process was fully automatic. In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_sandbox  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_sandbox" =~ [^10] ]]
do
    :
done 
if [[ $i_sandbox == 0 ]]; then 
echo ""   
echo " Установка инструмента Flatpak пропущена "
elif [[ $i_sandbox == 1 ]]; then
  echo ""    
  echo " Установка Flatpak (инструмента для управления приложениями и средами выполнения) "
sudo pacman -S flatpak --noconfirm  # Среда изолированной программной среды и распространения приложений Linux (ранее xdg-app)
sudo pacman -S elfutils patch --noconfirm  # Утилиты для обработки объектных файлов ELF и отладочной информации DWARF, и Утилита для применения патчей к оригинальным источникам
clear
echo ""
echo " Установка приложение Flatpak выполнена "
echo ""
echo -e "${BLUE}:: ${NC}Установить приложение Discover (из проекта KDE) для управления вашими Flatpaks (флэтпаками)?"
echo " Discover - Один из способов управления вашими Флэтпаками, есть ещё Gnome Software из проекта 'Gnome Project'. "
echo " Gnome Software - ПОДТЯГИВАЕТ МНОГО ЗАВИСИМОСТЕЙ! "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_discover  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_discover" =~ [^10] ]]
do
    :
done 
if [[ $i_discover == 0 ]]; then 
echo ""   
echo " Установка приложение Discover пропущена "
elif [[ $i_discover == 1 ]]; then
  echo ""    
  echo " Установка Discover (для управления вашими Flatpaks) "
sudo pacman -S discover --noconfirm  # Графический интерфейс управления ресурсами KDE и Plasma
### sudo pacman -S gnome-software  # Программные инструменты GNOME - ПОДТЯГИВАЕТ МНОГО ЗАВИСИМОСТЕЙ!
echo ""
echo " Установка приложение Discover (из проекта KDE) выполнена "
fi
fi
# -------------------------------------
# Отобразить список всех плоских пакетов и сред выполнения, установленных в данный момент:
# flatpak list
# Обновление вашей коллекции Flatpak:
# flatpak upgrade
# Если вы не хотите устанавливать приложения в масштабе системы, вы также можете устанавливать приложения flatpak для каждого пользователя отдельно, как показано ниже.
# flatpak install --user <имя_приложения>
# В данном случае все установленные приложения будут храниться в $HOME/.var/app/location.
# ls $HOME/.var/app/ 
# com.spotify.Client
# Запуск приложений Flatpak
# Вы можете запускать установленное приложение в любое время из панели запуска приложений. Из командной строки вы можете запустить его, например Spotify, используя команду:
# flatpak run com.spotify.Client
# Найдем приложения Flatpak. Для поиска приложения:
# flatpak search gimp
# Чтобы вывести список всех настроенных удаленных репозиториев, запустите:
# flatpak remotes
# -------------------------------------
# Flatpak:
# https://wiki.archlinux.org/index.php/Flatpak
# Flatpak Manjaro:
# https://wiki.manjaro.org/index.php?title=Flatpak
# =====================================

###### SNAP ##############
clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Snap на Arch Linux?"
#echo -e "${BLUE}:: ${NC}Установить Snap на Arch Linux?" 
#echo 'Установить Snap на Arch Linux?'
# To install Snap-on Arch Linux?
echo -e "${MAGENTA}:: ${BOLD}Snap - это инструмент для развертывания программного обеспечения и управления пакетами,  которые обновляются автоматически, просты в установке, безопасны, кроссплатформенны и не имеют зависимостей. Изначально разработанный и созданный компанией Canonical, который работает в различных дистрибутивах Linux каждый день. ${NC}"
echo -e "${CYAN}:: ${NC}Для управления пакетами snap, установим snapd (демон), а также snap-confine, который обеспечивает монтирование, изоляцию и запуск snap-пакетов."
echo " Установка происходит из 'AUR'- с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/snapd.git)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В любой ситуации выбор всегда остаётся за вами. "
# Be careful! The installation process was fully automatic. In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_snap  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_snap" =~ [^10] ]]
do
    :
done 
if [[ $i_snap == 0 ]]; then 
echo ""   
echo " Установка Snap пропущена "
elif [[ $i_snap == 1 ]]; then
echo ""    
echo -e " Установка базовых программ и пакетов wget, curl, git "
#sudo pacman -S --noconfirm --needed wget curl git 
echo " Установка поддержки Snap "
git clone https://aur.archlinux.org/snapd.git
cd snapd
# makepkg -si
makepkg -si --skipinteg
#makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
cd ..  
rm -Rf snapd
clear
echo ""
echo " Установка Snapd выполнена "
#fi
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
fi
sleep 03

######## Pacman gui ###############
clear
echo -e "${MAGENTA}
  <<< Установка графического менеджера пакетов для Archlinux (Pacman gui) >>> ${NC}"
# Installing the graphical package Manager for Archlinux (Pacman gui).
echo -e "${YELLOW}==> Примечание: ${NC}Сейчас Вы можете установить "Pacman gui", если пропустили это действие в предыдущем скрипте (при установке основной системы), или пропустите установку." 

echo ""
echo -e "${GREEN}==> ${NC}Установка Pacman gui (pamac-aur), или Pacman gui (octopi) (AUR)(GTK)(QT)" 
#echo -e "${BLUE}:: ${NC}Установка Pacman gui (pamac-aur), или Pacman gui (octopi) (AUR)(GTK)(QT)" 
echo -e "${CYAN}:: ${NC}В этом варианте представлена установка Pacman gui (pamac-aur), и (octopi), проходит через сборку из исходников. То есть установка (pamac-aur), или (octopi) производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/pamac-aur/), (https://aur.archlinux.org/packages/octopi/), собирается и устанавливается. "
echo " Давайте проанализируем действия, которые выполняются. "
echo " 1 - Pacman gui (pamac-aur) - Графический менеджер пакетов (интерфейс Gtk3 для libalpm), тогда укажите "1". "
echo " Графический менеджер пакетов для Arch, Manjaro Linux с поддержкой Alpm, AUR, и Snap. "
echo " 2 - Pacman gui (octopi) - Графический менеджер пакетов (мощный интерфейс Pacman с использованием библиотек Qt5), тогда укажите вариант "2". " 
echo -e "${CYAN}=> ${BOLD}Вариант '2' Напрямую привязан к Установке AUR Helper, если ранее БЫЛ выбран AUR - (pikaur). ${NC}"
echo -e "${YELLOW}:: ${NC}Так как - Подчеркну (обратить внимание)! 'Pikaur' - идёт как зависимость для Octopi." 
echo " 3 - Pacman gui (octopi) - Графический менеджер пакетов (мощный интерфейс Pacman с использованием библиотек Qt5), тогда укажите вариант "3". "
echo -e "${CYAN}=> ${BOLD}Вариант '3' - Если ранее при Установке 'AUR Helper' НЕ БЫЛ УСТАНОВЛЕН AUR - (pikaur). ${NC}"
echo " Pacman gui "Octopi" - рекомендуется для KDE Plasma Desktop (окружение рабочего стола). " 
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"        
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Pacman gui - (pamac-aur),     2 - Octopi - ранее БЫЛ выбран AUR - (pikaur), 

    3 - Octopi - ранее НЕ БЫЛ УСТАНОВЛЕН AUR - (pikaur), 

    0 - Пропустить установку: " graphic_aur  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$graphic_aur" =~ [^1230] ]]
do
    :
done 
if [[ $graphic_aur == 0 ]]; then 
clear 
echo ""  
echo " Установка Графического менеджера пакетов пропущена "
elif [[ $graphic_aur == 1 ]]; then
  echo ""  
  echo " Установка Графического менеджера Pacman gui (pamac-aur) "
##### pamac-aur ######  
git clone https://aur.archlinux.org/pamac-aur.git 
cd pamac-aur
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf pamac-aur
rm -Rf pamac-aur   # удаляем директорию сборки
clear
echo ""
echo " Графический менеджер Pamac-aur успешно установлен! "
elif [[ $graphic_aur == 2 ]]; then
echo ""    
echo " Установка Графического менеджера Octopi "    
##### alpm_octopi_utils ######    
git clone https://aur.archlinux.org/alpm_octopi_utils.git
cd alpm_octopi_utils
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf alpm_octopi_utils  
rm -Rf alpm_octopi_utils
############ gconf ##########   
git clone https://aur.archlinux.org/gconf.git  # Устаревшая система базы данных конфигурации
cd gconf
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gconf 
rm -Rf gconf
############ libgksu ##########
git clone https://aur.archlinux.org/libgksu.git
cd libgksu
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf libgksu 
rm -Rf libgksu
############ gksu ##########
git clone https://aur.archlinux.org/gksu.git
cd gksu
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gksu  
rm -Rf gksu
######### octopi #######
git clone https://aur.archlinux.org/octopi.git
cd octopi
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf octopi  
rm -Rf octopi
clear
echo ""
echo " Графический менеджер Octopi успешно установлен! "
elif [[ $graphic_aur == 3 ]]; then
echo ""    
echo " Установка Графического менеджера Octopi - (pikaur) "    
##### pikaur ###### 
git clone https://aur.archlinux.org/pikaur.git 
cd pikaur
# makepkg -si   
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd 
# makepkg -si
#makepkg -si --skipinteg  
cd ..
# rm -rf pikaur
rm -Rf pikaur
##### alpm_octopi_utils ######
git clone https://aur.archlinux.org/alpm_octopi_utils.git
cd alpm_octopi_utils
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf alpm_octopi_utils  
rm -Rf alpm_octopi_utils
######### octopi #######
git clone https://aur.archlinux.org/octopi.git
cd octopi
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf octopi  
rm -Rf octopi
############ gconf ##########   
git clone https://aur.archlinux.org/gconf.git  # Устаревшая система базы данных конфигурации
cd gconf
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gconf 
rm -Rf gconf
############ libgksu ##########
git clone https://aur.archlinux.org/libgksu.git
cd libgksu
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf libgksu 
rm -Rf libgksu
############ gksu ##########
git clone https://aur.archlinux.org/gksu.git
cd gksu
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gksu  
rm -Rf gksu
clear
echo ""
echo " Графический менеджер Octopi успешно установлен! "
fi 

######### Gksu ###############
echo -e "${RED}
 ==> Внимание! ${BOLD}Если Вы установили Графический менеджер пакетов (octopi), то СОВЕТУЮ пропустить установку Gksu. Так как в сценарии установки Pacman gui (octopi), уже прописана установка пакетов (gksu) и (libgksu). ${NC}"
echo -e "${YELLOW}==> Примечание: ${NC}Сейчас Вы можете установить "Gksu", если пропустили это действие в предыдущем скрипте (при установке основной системы), или пропустите установку."

echo ""
echo -e "${GREEN}==> ${NC}Установить Gksu - Графический интерфейс для su"
#echo -e "${BLUE}:: ${NC}Установить Gksu - Графический интерфейс для su" 
#echo 'Установить Gksu - Графический интерфейс для su'
# To install Gksu - Graphical UI for subversion
echo " Ставим пакет (gksu) - графический интерфейс для su, и пакет (libgksu) - библиотека авторизации gksu "
echo -e "${MAGENTA}:: ${BOLD}Для запуска графических приложений от имени суперпользователя существуют специальные утилиты. Они сохраняют все необходимые переменные окружения и полномочия. В KDE это команда kdesu, а в Gnome,Xfce,... - команда gksu (gksu nautilus). ${NC}"
echo " Программа запросит пароль, уже в графическом окне, а потом откроется файловый менеджер. "
echo " Теперь программы, требующие дополнительных привилегий в системе, не вызовут у вас проблем. "
echo -e "${CYAN}:: ${NC}Установка Gksu (gksu), и (libgksu), проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/gksu/), (https://aur.archlinux.org/packages/libgksu/), (https://aur.archlinux.org/packages/gconf.git/)-(это зависимость для libgksu)- собирается и устанавливается. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор остаётся за вами. "
# Be careful! The installation process was fully automatic. In this option, the choice is yours.
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
echo ""
echo " Установка графического интерфейса для su (gksu) пропущена "
elif [[ $prog_set == 1 ]]; then
  echo ""   
  echo " Установка gconf - зависимость для libgksu "    
git clone https://aur.archlinux.org/gconf.git  # Устаревшая система базы данных конфигурации
cd gconf
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gconf 
rm -Rf gconf
############ libgksu ##########
echo ""   
echo " Установка libgksu - библиотека авторизации gksu "
git clone https://aur.archlinux.org/libgksu.git
cd libgksu
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf libgksu 
rm -Rf libgksu
############ gksu ##########
echo ""
echo " Установка gksu - Графический интерфейс для su "
git clone https://aur.archlinux.org/gksu.git
cd gksu
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gksu  
rm -Rf gksu
clear
echo ""
echo " Графический интерфейс для su (gksu) успешно установлен! "
fi
# ----------------------------------------------------
# Права суперпользователя Linux
# https://losst.ru/prava-superpolzovatelya-linux
# Gksu и libgksu:
# https://aur.archlinux.org/packages/libgksu/
# https://aur.archlinux.org/packages/gksu/
# ==================================================

######### Drivers ##############
echo -e "${MAGENTA}
  <<< Установка Свободных и Проприетарных драйверов для видеокарт (nvidia, amd, intel), а также драйверов для принтера. >>> ${NC}"
# Install Proprietary drivers for video cards (nvidia, amd, intel), as well as printer drivers. 
echo -e "${RED}==> Внимание! ${NC}Если у Вас ноутбук, и установлен X.Org Server (иксы), то в большинстве случаев драйвера для видеокарты уже установлены. Возможно! общий драйвер vesa (xf86-video-vesa), который поддерживает большое количество чипсетов (но не включает 2D или 3D ускорение)."

echo ""
echo -e "${GREEN}==> ${NC}Устанавливаем видео драйверы для чипов Intel, AMD/(ATI) и NVIDIA"
echo -e "${BLUE}:: ${NC}Сперва определим вашу видеокарту!"
#echo "Сперва определим вашу видеокарту"
# First, we will determine your video card!
echo -e "${MAGENTA}=> ${BOLD}Вот данные по вашей видеокарте (даже, если Вы работаете на VM): ${NC}"
#echo ""
lspci | grep -e VGA -e 3D
#lspci | grep -E "VGA|3D"   # узнаем производителя и название видеокарты
lspci -nn | grep VGA
#lspci | grep VGA        # узнаем ID шины 
# После того как вы узнаете PCI-порт видеокарты, например 1с:00.0, можно получить о ней более подробную информацию:
# sudo lspci -v -s 1с:00.0
# Она покажет, какая видеокарта используется:
#grep -Eiwo -m1 'nvidia|amd|ati|intel' /var/log/Xorg.0.log
echo -e "${YELLOW}==> Примечание: ${NC}Для установки библиотек (некоторых) драйверов видеокарт, нужен репозиторий [multilib], надеюсь Вы добавили репозиторий "Multilib" (при установке основной системы)."
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo " 1 - NVIDIA - Если видео карта от Nvidia ставим драйвер (проприетарный по желанию), то выбирайте вариант - "1". "
echo " 2 - AMD/(ATI) - Если видео карта от Amd ставим драйвер (свободный по желанию), то выбирайте вариант - "2"."
echo " 3 - Intel - Если видео карта от Intel ставим драйвер (свободный по желанию), то выбирайте вариант - "3"."
echo " 4 - Intel, AMD/(ATI), NVIDIA и дополнительные инструменты - Если у Вас система Archlinux установлена на внешний накопитель, или USB(флешку), то ЖЕЛАТЕЛЬНО установить все предложенные (свободные и проприетарные) драйвера для видеокарт, выбирайте вариант - "4"."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор остаётся за вами. "
# Be careful! The installation process was fully automatic. In this option, the choice is yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - драйвера для NVIDIA,     2 - драйвера для AMD/(ATI),     3 - драйвера для Intel,

    4 - драйверов для Intel, AMD/(ATI), NVIDIA и дополнительные инструменты - (flash drive) 

    0 - Пропустить установку: " videocard  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$videocard" =~ [^12340] ]]
do
    :
done 
if [[ $videocard == 0 ]]; then 
clear 
echo ""  
echo " Установка драйверов для видеокарт (nvidia, amd, intel) пропущена "
elif [[ $videocard == 1 ]]; then
  echo ""  
  echo " Установка Проприетарных драйверов для NVIDIA "
sudo pacman -S nvidia nvidia-utils lib32-nvidia-utils nvidia-settings --noconfirm  # Драйверы NVIDIA для linux
sudo pacman -S libvdpau lib32-libvdpau --noconfirm   # Библиотека Nvidia VDPAU
sudo pacman -S xf86-video-nouveau --noconfirm  # - свободный Nvidia (Драйвер 3D-ускорения с открытым исходным кодом) - ВОЗМОЖНО уже установлен с (X.org)
# nvidia-xconfig     # сгенерировать конфиг nvidia-xconfig (для настройки xorg.conf)
clear
echo ""  
echo " Установка драйверов для видеокарт (nvidia) выполнена "
elif [[ $videocard == 2 ]]; then
  echo ""    
  echo " Установка Свободных драйверов для AMD/(ATI) "
sudo pacman -S lib32-mesa mesa-vdpau lib32-mesa-vdpau libva-mesa-driver lib32-libva-mesa-driver --noconfirm  # Драйверы Mesa
sudo pacman -S vulkan-radeon lib32-vulkan-radeon --noconfirm  # Драйвер Radeon Vulkan mesa; Драйвер Radeon Vulkan mesa (32-разрядный)
sudo pacman -S libvdpau-va-gl --noconfirm  # Драйвер VDPAU с бэкэндом OpenGL / VAAPI
sudo pacman -S xf86-video-amdgpu --noconfirm  # Видеодрайвер X.org amdgpu - ВОЗМОЖНО уже установлен с (X.org)
sudo pacman -S xf86-video-ati --noconfirm  # Видеодрайвер X.org ati - ВОЗМОЖНО уже установлен с (X.org)
# libva-xvba-driver - не найден и lib32-ati-dri - не найден в репозитории
clear 
echo "" 
echo " Установка драйверов для видеокарт (amd/ati) выполнена "
elif [[ $videocard == 3 ]]; then
  echo ""    
  echo " Установка Свободных драйверов для Intel "
sudo pacman -S vdpauinfo libva-utils libva libvdpau libvdpau-va-gl lib32-libvdpau --noconfirm  
sudo pacman -S lib32-mesa vulkan-intel libva-intel-driver lib32-libva-intel-driver lib32-vulkan-intel --noconfirm
sudo pacman -S xf86-video-intel --noconfirm  # X.org Intel i810 / i830 / i915 / 945G / G965 + видеодрайверы - ВОЗМОЖНО уже установлен с (X.org)
# lib32-intel-dri - не найден
clear 
echo "" 
echo " Установка драйверов для видеокарт (intel) выполнена "
elif [[ $videocard == 4 ]]; then
  clear  
  echo ""  
  echo " Установка Проприетарных драйверов для NVIDIA "
sudo pacman -S nvidia nvidia-utils lib32-nvidia-utils nvidia-settings --noconfirm  # Драйверы NVIDIA для linux
sudo pacman -S libvdpau lib32-libvdpau --noconfirm   # Библиотека Nvidia VDPAU
sudo pacman -S xf86-video-nouveau --noconfirm  # - свободный Nvidia (Драйвер 3D-ускорения с открытым исходным кодом) - ВОЗМОЖНО уже установлен с (X.org)
# nvidia-xconfig     # сгенерировать конфиг nvidia-xconfig (для настройки xorg.conf)  
echo " Установка драйверов для видеокарт (nvidia) выполнена "
echo ""    
echo " Установка Свободных драйверов для AMD/(ATI) "
sudo pacman -S mesa-vdpau lib32-mesa-vdpau libva-mesa-driver lib32-libva-mesa-driver --noconfirm  #lib32-mesa # Драйверы Mesa
sudo pacman -S vulkan-radeon lib32-vulkan-radeon --noconfirm  # Драйвер Radeon Vulkan mesa; Драйвер Radeon Vulkan mesa (32-разрядный)
sudo pacman -S libvdpau-va-gl --noconfirm  # Драйвер VDPAU с бэкэндом OpenGL / VAAPI
sudo pacman -S xf86-video-amdgpu --noconfirm  # Видеодрайвер X.org amdgpu - ВОЗМОЖНО уже установлен с (X.org)
sudo pacman -S xf86-video-ati --noconfirm  # Видеодрайвер X.org ati - ВОЗМОЖНО уже установлен с (X.org) 
echo " Установка драйверов для видеокарт (amd/ati) выполнена "
echo ""    
echo " Установка Свободных драйверов для Intel "
sudo pacman -S vdpauinfo libva-utils libva libvdpau libvdpau-va-gl lib32-libvdpau --noconfirm  
sudo pacman -S vulkan-intel libva-intel-driver lib32-libva-intel-driver lib32-vulkan-intel --noconfirm #lib32-mesa
sudo pacman -S xf86-video-intel --noconfirm  # X.org Intel i810 / i830 / i915 / 945G / G965 + видеодрайверы - ВОЗМОЖНО уже установлен с (X.org)
echo " Установка драйверов для видеокарт (intel) выполнена "
echo ""    
echo " Установка дополнительных инструментов и драйверов "
sudo pacman -S lib32-mesa --noconfirm   # Реализация спецификации OpenGL с открытым исходным кодом (32-разрядная версия)
sudo pacman -S lib32-libva-vdpau-driver --noconfirm  # Серверная часть VDPAU для VA API (32-разрядная версия) https://freedesktop.org/wiki/Software/vaapi/ 
sudo pacman -S lib32-mesa-demos --noconfirm  # Демонстрации и инструменты Mesa (32-разрядная версия)
sudo pacman -S libva-vdpau-driver --noconfirm  # Серверная часть VDPAU для VA API   https://freedesktop.org/wiki/Software/vaapi/
sudo pacman -S mesa-demos --noconfirm  # Демоверсии Mesa и инструменты, включая glxinfo + glxgears
sudo pacman -S xf86-input-elographics --noconfirm  # Драйвер ввода X.org Elographics TouchScreen
sudo pacman -S xorg-twm --noconfirm  # Вкладка Window Manager для системы X Window
clear 
echo "" 
echo " Установка драйверов для видеокарт Intel, AMD/(ATI), NVIDIA и дополнительных инструментов выполнена "
fi
# -----------------------------------------
#Если вы устанавливаете систему на виртуальную машину:
#sudo pacman -S xf86-video-vesa
# virtualbox-guest-utils - для виртуалбокса, активируем коммандой:
#systemctl enable vboxservice - вводим дважды пароль
# Видео драйверы, без них тоже ничего работать не будет вот список:
# xf86-video-ati - свободный ATI
# xf86-video-intel - свободный Intel
# xf86-video-nouveau - свободный Nvidia
# Существуют также проприетарные драйверы, то есть разработаны самой Nvidia или AMD, но они часто не поддерживают новое ядро, или ещё какие-нибудь траблы.
###########################################

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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " prog_print  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_print" =~ [^10] ]]
do
    :
done 
if [[ $prog_print == 0 ]]; then  
echo ""  
echo " Установка поддержки Драйвера принтера (Поддержка печати) пропущена "
elif [[ $prog_print == 1 ]]; then
  echo ""  
  echo " Установка поддержки Драйвера принтера (Поддержка печати) CUPS "
sudo pacman -S cups cups-filters cups-pdf cups-pk-helper --noconfirm  # Система печати CUPS - пакет демона; Фильтры OpenPrinting CUPS; PDF-принтер для чашек; Помощник, который заставляет system-config-printer использовать PolicyKit
sudo pacman -S system-config-printer ghostscript --noconfirm  # Инструмент настройки принтера CUPS и апплет состояния; Интерпретатор для языка PostScript
sudo pacman -S libcups simple-scan --noconfirm  # Система печати CUPS - клиентские библиотеки и заголовки; Простая утилита сканирования
sudo pacman -S gsfonts gutenprint --noconfirm  # (URW) ++ Базовый набор шрифтов [Уровень 2]; Драйверы принтера высшего качества для систем POSIX ;  # python-imaging ???
# Драйверы для HP DeskJet, OfficeJet, Photosmart, Business Inkjet и некоторых LaserJet 
sudo pacman -S hplip --noconfirm  # Драйверы для HP DeskJet, OfficeJet, Photosmart, Business Inkjet и некоторых LaserJet   
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

clear
echo ""
echo -e "${GREEN}==> ${NC}Будете ли Вы подключать Android или Iphone к ПК через USB?"
#echo -e "${BLUE}:: ${NC}Будете ли Вы подключать Android или Iphone к ПК через USB?" 
#echo 'Будете ли Вы подключать Android или Iphone к ПК через USB?'
# Will you connect your Android or Iphone to your PC via USB?
echo -e "${MAGENTA}=> ${NC}Установка поддержки для устройств на (базе) Android или Iphone к ПК через USB. "
# Installing support for Android or Iphone devices to a PC via USB
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In this option, the choice is yours. 
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Android,     2 - Iphone,     3 - Оба Варианта (для устройств Android и Iphone)     

    0 - НЕТ - Пропустить установку: " i_telephone  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_telephone" =~ [^1230] ]]
do
    :
done 
if [[ $i_telephone == 0 ]]; then
echo ""    
echo " Установка утилит (пакетов) поддержки для устройств пропущена. "
elif [[ $i_telephone == 1 ]]; then
  echo ""  
  echo " Установка утилит (пакетов) поддержки устройств на (базе) Android "
sudo pacman -S gvfs-mtp --noconfirm  # Реализация виртуальной файловой системы для GIO (бэкэнд MTP; Android, медиаплеер)
echo " Установка поддержки устройств на (базе) Android завершена " 
elif [[ $i_telephone == 2 ]]; then
  echo ""  
  echo " Установка утилит (пакетов) для поддержки устройств Iphone "
sudo pacman -S gvfs-afc --noconfirm  # Реализация виртуальной файловой системы для GIO (бэкэнд AFC; мобильные устройства Apple)
echo " Установка поддержки устройств Iphone завершена " 
elif [[ $i_telephone == 3 ]]; then
  echo ""  
  echo " Установка утилит (пакетов) для поддержки устройств на (базе) Android и Iphone "  
sudo pacman -S gvfs-afc gvfs-mtp --noconfirm
echo " Установка поддержки устройств на Android и Iphone завершена "
fi
# -------------------------------------------------------
# Пример:
# Подключаю по USB телефон LG Optinus G
# lsusb
# Он монтируется как mtp устройство.
# Виден через наутилус как mtp://[usb:002,007]/
# ============================================================================

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить планировщик заданий CRON (cronie) - ЗАПУСК ПРОГРАММ ПО РАСПИСАНИЮ ?"
#echo -e "${BLUE}:: ${NC}Установить планировщик заданий CRON (cronie) - ЗАПУСК ПРОГРАММ ПО РАСПИСАНИЮ ?" 
#echo 'Установить планировщик заданий CRON (cronie) - ЗАПУСК ПРОГРАММ ПО РАСПИСАНИЮ ?'
# Install the CRON task scheduler (cron) - RUN programs on a schedule ??
echo -e "${MAGENTA}=> ${BOLD}Cron – это планировщик заданий на основе времени на Unix-подобных операционных системах. Cron даёт возможность пользователям настроить работы по расписанию (команды или шелл-скрипты) для периодичного запуска в определённое время или даты... ${NC}"
echo " Обычно это используется для автоматизации обслуживания системы или администрирования. "
echo -e "${CYAN}:: ${NC}Имеется много реализаций cron, но ни одна из них не установлена по умолчанию: - (cronie, fcron, bcron, dcron, vixie-cron, scron-git), cronie и fcron доступны в стандартном репозитории, а остальные – в AUR."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор остаётся за вами. "
# Be careful! The installation process was fully automatic. In this option, the choice is yours. 
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
echo "" 
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_cron  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_cron" =~ [^10] ]]
do
    :
done 
if [[ $i_cron == 0 ]]; then  
echo ""  
echo " Установка планировщика заданий CRON (cronie) пропущена "
elif [[ $i_cron == 1 ]]; then
  echo ""  
  echo " Установка планировщика заданий CRON (cronie) "
#sudo pacman -S cronie  
sudo pacman -S cronie --noconfirm  # Демон, который запускает указанные программы в запланированное время и связанные инструменты
echo ""  
echo " Добавляем в автозагрузку планировщик заданий (cronie.service) "
sudo systemctl enable cronie.service
echo ""  
echo " Планировщик заданий CRON (cronie) установлен и добавлен в автозагрузку "
fi
# ---------------------------------------
# Теперь осталось добавить само правило.
# Вбиваем в терминале:
# sudo EDITOR=nano crontab -e
# И добавляем:
# 10 10 * * sun /sbin/rm /var/cache/pacman/pkg/*
# Таким образом наша система будет сама себя чистить раз в неделю, в воскресенье в 10:10 ))
# -----------------------------------------
# Т.е. для редактирования списка задач текущего пользователя:
# crontab -e
# Для отображения списка задач текущего пользователя:
# crontab -l
# ===========================================

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
    1 - Да включить UFW,     0 - НЕТ - Пропустить действие: " set_firewall  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$set_firewall" =~ [^10] ]]
do
    :
done 
if [[ $set_firewall == 0 ]]; then
echo ""    
echo "  Запуск UFW (сетевой экран) пропущено "
elif [[ $set_firewall == 1 ]]; then
  echo ""  
  echo " Запускаем UFW (сетевой экран) "
sudo ufw enable
fi

echo ""
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
    1 - Да добавляем в автозагрузку UFW,     0 - НЕТ - Пропустить действие: " auto_firewall  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$auto_firewall" =~ [^10] ]]
do
    :
done 
if [[ $auto_firewall == 0 ]]; then
echo ""    
echo " UFW (сетевой экран) не был добавлен в автозагрузку. "
elif [[ $auto_firewall == 1 ]]; then
  echo ""  
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

clear
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
    1 - Да добавляем,     0 - НЕТ - Пропустить действие: " auto_bluetooth  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$auto_bluetooth" =~ [^10] ]]
do
    :
done 
if [[ $auto_bluetooth == 0 ]]; then
echo ""    
echo "  Bluetooth.service не включен в автозагрузку, при необходиости это можно будет сделать. "
elif [[ $auto_bluetooth == 1 ]]; then
  echo ""
  echo " Запускаем (bluetooth.service) "
# Загрузите универсальный драйвер bluetooth, если это еще не сделано:
sudo modprobe btusb  
sudo systemctl start bluetooth.service  
#sudo systemctl start dbus  
echo " Добавляем в автозагрузку (bluetooth.service) "
sudo systemctl enable bluetooth.service 
echo " Bluetooth успешно добавлен в автозагрузку " 
fi

clear
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
    1 - Да добавляем,     0 - НЕТ - Пропустить действие: " auto_ssh  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$auto_ssh" =~ [^10] ]]
do
    :
done 
if [[ $auto_ssh == 0 ]]; then
echo ""    
echo "  Сервис sshd не включен в автозагрузку, при необходиости это можно будет сделать. "
elif [[ $auto_ssh == 1 ]]; then
  echo ""  
  echo " Добавляем в автозагрузку (sshd.service)"
sudo systemctl enable sshd.service
echo " Сервис sshd успешно добавлен в автозагрузку " 
fi

clear
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
    1 - Да запускаем и добавляем,     0 - НЕТ - Пропустить действие: " set_cups  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$set_cups" =~ [^10] ]]
do
    :
done 
if [[ $set_cups == 0 ]]; then
echo ""    
echo "  Запуск и добавление в автозапуск (cupsd.service) пропущено "
elif [[ $set_cups == 1 ]]; then
  echo ""  
  echo " Запускаем Драйвера принтера CUPS (cupsd.service) "
sudo systemctl start org.cups.cupsd.service 
#sudo systemctl start cups-browsed.service 
echo " Добавляем в автозапуск Драйвера принтера CUPS (cupsd.service) " 
sudo systemctl enable org.cups.cupsd.service 
#sudo systemctl enable cups-browsed.service
# Проверяем - переходим на страницу http://localhost:631:
fi
# --------------------- Важно! --------------------------------
# Чтобы исправить ошибки сервера CUPS:
# sudo pacman -Rdd foomatic-db foomatic-db-nonfree
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

######### Сделать и настроить #######
clear
echo ""
echo -e "${BLUE}:: ${NC}Настроить автозапуск сервисов TLP (управления питанием)?"
echo -e "${GREEN}==> ${NC}Включить TLP (управления питанием)?"
# Enable TLP (power management)
echo -e "${YELLOW}:: ${BOLD}Запускаем TLP (управления питанием), если таковой был вами установлен. ${NC}"
echo -e "${CYAN}:: ${NC}Вы сможете включить TLP (управления питанием) позже, воспользовавшись скриптом как шпаргалкой!"
echo -e "${MAGENTA}=> ${NC}Так же Вам необходимо будет настроить конфигурационный файл tlp - под свои параметры." 
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами. "
# Be careful! In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да включить TLP (управления питанием), 0 - НЕТ - Пропустить действие: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да включить TLP (управления питанием),     0 - НЕТ - Пропустить действие: " set_tlp  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$set_tlp" =~ [^10] ]]
do
    :
done 
if [[ $set_tlp == 0 ]]; then
echo ""    
echo "  Запуск TLP (управления питанием) пропущено "
elif [[ $set_tlp == 1 ]]; then
  echo ""  
  echo " Запускаем сервис TLP (управления питанием) "
# При использовании Мастера радиоустройств ( tlp-rdw ) необходимо использовать NetworkManager и включить NetworkManager-dispatcher.service 
# выполнив следующие команды по очереди:
sudo systemctl disable systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket systemd-rfkill.service
sudo systemctl enable tlp.service
#sudo systemctl enable tlp-sleep.service
# Далее необходимо настроить конфигурационный файл tlp:
# sudo nano /etc/default/tlp
# Вы должны настроить, какие параметры вы хотите использовать, а также какой регулятор, в режиме зарядки(AC) и работе от батареи(BAT).
# Доступные CPU регуляторы, вы можете узнать, введя команду
# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
echo ""
echo " Запускаем TLP (управления питанием), не перезагружаясь "
#echo -e "${BLUE}:: ${NC}Также вы можете запустить TLP (управления питанием), не перезагружаясь" 
#echo 'Применяем настройки TLP (управления питанием) в зависимости от источника питания (батарея или от сети)'
# Apply TLP (power management) settings depending on the power source (battery or mains)
sudo tlp start
#echo ""
#echo -e "${BLUE}:: ${NC}Проверяем работу TLP (управления питанием)" 
#echo " Вы увидите планировщик который вы указали при питании от сети, в моем случае - performance, либо же powersave при работе от батареи "
#cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
#echo ""
#echo -e "${BLUE}:: ${NC}Получение подробного вывода TLP (управления питанием)"
#sudo tlp-stat
fi

echo ""
echo -e "${BLUE}:: ${NC}Обновим информацию о шрифтах" 
#echo 'Обновим информацию о шрифтах'
# Update information about fonts
sudo fc-cache -f -v

echo ""
echo -e "${BLUE}:: ${NC}Создать резервную копию (дубликат) файла grub.cfg" 
#echo 'Создать резервную копию (дубликат) файла grub.cfg'
# Create a backup (duplicate) of the grub.cfg file
#sudo cp /boot/grub/grub.cfg grub.cfg.backup
sudo cp -vf /boot/grub/grub.cfg /boot/grub/grub.cfg.backup 

echo ""
echo -e "${BLUE}:: ${NC}Создать резервную копию (дубликат) файла etc/default/grub"
#echo 'Создать резервную копию (дубликат) файла etc/default/grub'
# Create a backup (duplicate) of the etc/default/grub file
#sudo cp /etc/default/grub grub.backup
sudo cp -vf /etc/default/grub /etc/default/grub.backup

echo ""
echo -e "${YELLOW}==> ${NC}Загрузим архив (ветку мастер MarcMilany/archmy_2020)"
#echo 'Загрузим архив (ветку мастер MarcMilany/arch_2020)'
# Upload the archive (branch master MarcMilany/arch_2020)
#wget https://github.com/MarcMilany/arch_2020.git/archive/master.zip
#wget github.com/MarcMilany/arch_2020.git/archive/arch_2020-master.zip
#sudo mv -f ~/Downloads/master.zip
#sudo mv -f ~/Downloads/arch_2020-master.zip
#sudo tar -xzf master.zip -C ~/ 
#sudo tar -xzf arch_2020-master.zip -C ~/
#git clone https://github.com/MarcMilany/arch_2020.git
git clone https://github.com/MarcMilany/archmy_2020.git

clear
echo ""
echo -e "${BLUE}:: ${NC}Исправим отображение миниатюр в файловом менеджере Thunar?"
# Fix Thumbnails in file manager
echo -e "${MAGENTA}=> ${BOLD}Thunar - обычно автоматически создает миниатюрные изображения всех изображений в просматриваемой директории. Но бывает, что в Arch Linux Thunar иногда не показывает некоторые миниатюры. Все файлы изображений получают один и тот же общий значок изображения. ${NC}"
echo -e "${YELLOW}:: Файловый менеджер thunar идет по умолчанию в графической оболочке xfce. Сам по себе thunar не содержит в себе лишних функций, которые могут запутать не опытного пользователя. Да и не всем нужен излишний функционал. Кастомизируется thunar очень легко, по этому у вас не должно возникнуть с этим проблем."
echo -e "${CYAN}:: ${NC}Нам - Потребуется доустановить дополнительные пакеты, и надо включить показ миниатюр в настройках Thunar'а (или, может, в настройках Xfce)."
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами. "
# Be careful! In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да исправьте миниатюры в файловом менеджере,     0 - НЕТ - Пропустить действие: " set_fix  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$set_fix" =~ [^10] ]]
do
    :
done 
if [[ $set_fix == 0 ]]; then
echo ""    
echo " Действие исправления миниатюр в файловом менеджере пропущено "
elif [[ $set_fix == 1 ]]; then
  echo "" 
  echo " Установка необходимого софта (пакетов) в систему "
#sudo pacman -S tumbler ffmpegthumbnailer poppler-glib libgsf libopenraw --noconfirm
sudo pacman -S tumbler --noconfirm  #  Сервис D-Bus для приложений, запрашивающих миниатюры
sudo pacman -S ffmpegthumbnailer --noconfirm  # Легкий эскиз видеофайлов, который может использоваться файловыми менеджерами
sudo pacman -S poppler-glib --noconfirm  # Наручники Poppler Glib
sudo pacman -S libgsf --noconfirm  # Расширяемая библиотека абстракции ввода-вывода для работы со структурированными форматами файлов
sudo pacman -S libopenraw --noconfirm  # Библиотека для декодирования файлов RAW
#yay -S gstreamer0.10 --noconfirm  # Мультимедийный фреймворк GStreamer
echo "" 
echo " Удалим миниатюры фото, которые накапились в системе "
killall thunar  # завершим работу менеджера thunar 
sudo rm -rf ~/.thumbnails/  # удаляет миниатюры фото, которые накапливаются в системе
#sudo rm -rf ~/.cache/thumbnails/*
echo " Создадим backup папки /.config/Thunar "
mv ~/.config/Thunar ~/.config/Thunar.bak
echo " Резервное копирование каталога /usr/share/mime, на всякий случай "
cp -R /usr/share/mime /usr/share/mime_back
#echo " Удалить все файлы .xml на /usr/share/mime, затем запустим команду обновления "
#find  /usr/share/mime -name *.xml -exec rm -rfv {} + 
echo " Обновление общего кэша информации mime в соответствии с системой "
sudo update-mime-database /usr/share/mime
echo " Желательно ПОСЛЕ этих действий выйдите из системы и снова войдите в систему, или перезагрузитесь "  # Then logout and back in or Reboot
echo " Но, мы просто перезапустим файловый менеджер Thunar "
thunar -q
# Почистить cache:
# /home/user/.thumbnails
# /home/user/.cache/Thunar
fi
# ---------------------------------
# update-mime-database  # программа для построения кэша Shared MIME-Info базы данных
# Это программа, которая отвечает за обновление общего кэша информации mime в соответствии с системой, описанной в спецификации Shared MIME-Info Database от X Desktop Group
#/usr/share/mime  # файл конфигурации MIME-типов
# https://wiki.archlinux.org/index.php/Thunar_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# https://www.opennet.ru/man.shtml?topic=update-mime-database&category=1&russian=2
# ==================================

clear
echo -e "${CYAN}
  <<< Очистка кэша pacman, и Удаление всех пакетов-сирот (неиспользуемых зависимостей) . >>> 
${NC}"
# Clearing the pacman cache, and Removing unused dependencies.
echo "" 
echo -e "${YELLOW}==> Примечание: ${NC}Если! Вы сейчас устанавливали "AUR Helper"-'yay' (не yay-bin), а также Snap (пакет snapd) вместе с ними установилась зависимость 'go' - (Основные инструменты компилятора для языка программирования Go), который весит 559,0 МБ. Так, что если вам не нужна зависимость 'go', для дальнейшей сборки пакетов в установленной системе СОВЕТУЮ удалить её. В случае, если "AUR"-'yay' НЕ БЫЛ установлен, или зависимость 'go' была удалена ранее, то пропустить этот шаг."

echo ""
echo -e "${BLUE}:: ${BOLD}Удаление зависимости 'go' после установки "AUR Helper"-'yay'. ${NC}"
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да удалить зависимость 'go',     0 - Нет пропустить этот шаг: " rm_tool  # sends right after the keypress; # отправляет сразу после нажатия клавиши     
    echo ''
    [[ "$rm_tool" =~ [^10] ]]
do
    :
done
if [[ $rm_tool == 0 ]]; then
  echo ""
echo " Удаление зависимости 'go' пропущено "      
elif [[ $rm_tool == 1 ]]; then
echo ""    
# sudo pacman -Rs go
#pacman -Rs go
sudo pacman --noconfirm -Rs go    # --noconfirm  --не спрашивать каких-либо подтверждений
 echo "" 
 echo " Удаление зависимость 'go' выполнено "
fi

### Clean pacman cache (Очистить кэш pacman) ####
clear
echo ""
echo -e "${BLUE}:: ${BOLD}Очистка кэша pacman ${NC}"
echo -e "${CYAN}=> ${NC}Очистка кэша неустановленных пакетов (оставив последние версии оных), и репозиториев..."
sudo pacman --noconfirm -Sc  # Очистка кэша неустановленных пакетов (оставив последние версии оных) # --noconfirm  -не спрашивать каких-либо подтверждений

echo "" 
echo -e "${CYAN}=> ${NC}Удалить кэш ВСЕХ установленных пакетов (высвобождая место на диске)?"
echo " Процесс удаления кэша ВСЕХ установленных пакетов - НЕ был прописан полностью автоматическим, и было принято решение дать возможность пользователю сделать выбор. "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да удалить кэш,     0 - Нет пропустить этот шаг: " rm_cache  # sends right after the keypress; # отправляет сразу после нажатия клавиши     
    echo ''
    [[ "$rm_cache" =~ [^10] ]]
do
    :
done
if [[ $rm_cache == 0 ]]; then
echo ""
echo " Удаление кэша ВСЕХ установленных пакетов пропущено "      
elif [[ $rm_cache == 1 ]]; then   
sudo pacman -Scc  # Удалит кеш всех пакетов (можно раз в неделю вручную запускать команду)
#sudo pacman --noconfirm -Scc  # --noconfirm  --не спрашивать каких-либо подтверждений
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Посмотрим список всех пакетов-сирот (которые не используются ни одной программой)"
#echo " Посмотрим список всех пакетов-сирот "
# echo 'Список всех пакетов-сирот'
# List of all orphan packages
sudo pacman -Qdt  # Посмотреть, какие пакеты не используются ничем в системе
#sudo pacman -Qdtq  # Посмотреть, какие пакеты не используются ничем в системе(показать меньше информации для запроса и поиска)
# -----------------------------------
# -Q --query  # Запрос к базе данных
# -d, --deps  # список пакетов, установленных как зависимости
# -t, --unrequired  # список пакетов не (опционально) требуемых
# какими-либо пакетами (-tt для игнорирования optdepends)
# -q, --quiet  # показать меньше информации для запроса и поиска
# ------------------------------------
sleep 3

echo ""  
echo -e "${CYAN}=> ${NC}Удаление всех пакетов-сирот (неиспользуемых зависимостей) 'pacman -Qdtq'..."
echo " Процесс удаления всех пакетов-сирот (неиспользуемых зависимостей) - НЕ был прописан полностью автоматическим, и было принято решение дать возможность пользователю сделать выбор. "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да удалить все пакеты-сироты,     0 - Нет пропустить этот шаг: " rm_orphans  # sends right after the keypress; # отправляет сразу после нажатия клавиши     
    echo ''
    [[ "$rm_orphans" =~ [^10] ]]
do
    :
done
if [[ $rm_orphans == 0 ]]; then
echo ""
echo " Удаление всех пакетов-сирот (неиспользуемых зависимостей) пропущено "      
elif [[ $rm_orphans == 1 ]]; then
echo "" 
#echo " Удаление всех пакетов-сирот (неиспользуемых зависимостей) "    
#sudo pacman --noconfirm -Rcsn $(pacman -Qdtq)  # --noconfirm (не спрашивать каких-либо подтверждений), -R --remove (Удалить пакет(ы) из системы), -c, --cascade (удалить пакеты и все пакеты, которые зависят от них), -s, --recursive (удалить ненужные зависимости), -n, --nosave (удалить конфигурационные файлы)
sudo pacman -Rsn $(pacman -Qdtq) && rm -rf ~/.cache/thumbnails/* && rm -rf ~/.build/*
#sudo pacman -Rsn $(pacman -Qqtd)  # удаляет пакеты-сироты (которые не используются ни одной программой)
#sudo rm -rf ~/.cache/thumbnails/*  # удаляет миниатюры фото, которые накапливаются в системе
#sudo rm -rf ~/.build/*  # 
# или эта команда:
# sudo pacman -Rsn $(pacman -Qdtq)
### fc-cache -vf
# sudo pacman -Scc && sudo pacman -Rsn $(pacman -Qdtq) && rm -rf ~/.cache/thumbnails/* && rm -rf ~/.build/*
echo "" 
echo " Удаление всех пакетов-сирот (неиспользуемых зависимостей) выполнено "
fi

echo ""
echo -e "${BLUE}:: ${NC}Удаление созданной папки (downloads), и скрипта установки программ (archmy3l)"
#echo " Удаление созданной папки (downloads), и скрипта установки программ (archmy3l) "
#echo ' Удаление созданной папки (downloads), и скрипта установки программ (archmy3l) '
# Deleting the created folder (downloads) and the program installation script (archmy3l)
sudo rm -R ~/downloads/
sudo rm -rf ~/archmy3l

clear
echo ""
echo -e "${BLUE}:: ${NC}Посмотрим список Установленного софта (пакетов)"
#echo " Посмотрим список Установленного софта (пакетов) "
# echo 'Список Установленного софта (пакетов)'
# List of Installed software (packages)
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Вы можете пропустить это действие..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да вывести список,     0 - Нет пропустить этот шаг: " t_list  # sends right after the keypress; # отправляет сразу после нажатия клавиши     
    echo ''
    [[ "$t_list" =~ [^10] ]]
do
    :
done
if [[ $t_list == 0 ]]; then
echo ""
echo " Вывод списка установленного софта (пакетов) пропущен "      
elif [[ $t_list == 1 ]]; then
echo ""
echo " Список установленного софта (пакетов) "
echo ""
sudo pacman -Qqe  # -Q --query  # Запрос к базе данных; -q, --quiet  # показать меньше информации для запроса и поиска; -e, --explicit  # список явно установленных пакетов (фильтр)
echo ""
sleep 60 
fi
###########################################
clear
echo -e "${GREEN}
  <<< Поздравляем! Установка софта (пакетов) завершена! >>> ${NC}"
# Congratulations! Installation is complete.
#echo -e "${GREEN}==> ${NC}Установка завершена!"
#echo 'Установка завершена!'
# The installation is now complete!
echo ""
echo -e "${YELLOW}==> ${NC}Желательно перезагрузить систему для применения изменений"
#echo 'Желательно перезагрузить систему для применения изменений'
# It is advisable to restart the system to apply the changes
echo -e "${BLUE}:: ${BOLD}Посмотрим дату и время ... для проверки времени ${NC}"
date  # Посмотрим дату и время без характеристик для проверки времени
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'  # одновременно отображает дату и часовой пояс

echo -e "${BLUE}:: ${BOLD}Отобразить время работы системы ... ${NC}"
uptime

echo -e "${YELLOW}==> ...${NC}"
echo -e "${BLUE}:: ${NC}Если хотите установить дополнительный софт (пакеты), тогда после перезагрузки и входа в систему выполните команду:"
echo -e "${YELLOW}==> ${CYAN}wget git.io/archmy4 && sh archmy4l ${NC}"
# Команды по установке :
# wget git.io/archmy4l 
# sh archmy4l
# wget git.io/archmy4 && sh archmy4l --noconfirm
echo -e "${CYAN}:: ${NC}Цель скрипта (archmy4l) - это установка софта (пакетов), включая установку софта (пакетов) из 'AUR'-'yay', и запуск необходимых служб."
echo -e "${CYAN}:: ${NC}Скриптом ЛУЧШЕ пользоваться как ШПАРГАЛКОЙ, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуску нужных служб."
echo -e "${GREEN}
  <<< Желаю Вам удачи во всех начинаниях, верных и точных решений! >>> ${NC}"
echo ""
echo -e "${GREEN}
  <<< ♥ Либо ты идешь вперед... либо в зад. >>> ${NC}"
#echo '♥ Либо ты идешь вперед... либо в зад.' 
# ♥ Either you go forward... or you go up your ass.
# ===============================================
echo -e "${RED}### ${BLUE}########################################################### ${RED}### ${NC}" 
echo -e "${RED}==> ${BOLD}Выходим из установленной системы ${NC}"

echo -e "${BLUE}:: ${BOLD}Теперь вам надо ввести exit, затем перезагрузить систему ${NC}"
#echo " Установка завершена для выхода введите >> exit << "
#exit(0)  # означает чистый выход без каких-либо ошибок (проблем)
#exit(1)  # означает, что была какая-то ошибка (проблема), и именно поэтому программа выходит
