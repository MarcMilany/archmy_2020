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

sleep 15
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
cat /etc/lsb-release.old
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
echo -e "${YELLOW}==> Примечание: ${BOLD}Загружаем базу данных пакетов независимо от того, есть ли какие-либо изменения в версиях или нет. ${NC}"
# Loading the package database regardless of whether there are any changes in the versions or not.
echo -e "${RED}==> Важно! ${NC}Если при обновлении системы прилетели обновления ядра и установились, то Вам нужно желательно остановить исполнения сценария (скрипта), и выполнить команду по обновлению загрузчика 'grub' - sudo grub-mkconfig -o /boot/grub/grub.cfg , затем перезагрузить систему." 
echo -e "${CYAN}:: ${NC}После перезагрузки вновь запустить скрипт и в пункте 'Обновим вашу систему' - просто выбрать вариант пропустить (нажав 0)(если этот вариант не был выбран ранее)."
echo -e "${CYAN}:: ${NC}Эти действия необходимы, чтобы почти в завершении работы сценария (скрипта), в пункте запуска служб и добавление в автозапуск (например: Firewall UFW - сетевой экран), НЕ вылезла ошибка в исполнении сценария (скрипта), и ВАЙ-ВАЙ :( пришлось ЗАПУСКАТЬ скрипт снова. Пропустить выполненные ранее пункты (нажимая в них - 0)!"
echo -e "${YELLOW}==> Примечание: ${BOLD}Возможно Вас попросят ввести пароль пользователя (user). ${NC}"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Обновить и установить,     0 - НЕТ - Пропустить обновление и установку: " upd_sys  # sends right after the keypress; # отправляет сразу после нажатия клавиши    
    echo ''
    [[ "$upd_sys" =~ [^10] ]]
do
    :
done 
if [[ $upd_sys == 0 ]]; then 
echo ""   
echo " Установка обновлений пропущена "
elif [[ $upd_sys == 1 ]]; then
  echo ""    
  echo " Установка обновлений (базы данных пакетов) "
sudo pacman -Syyu  --noconfirm  # Обновление баз плюс обновление пакетов (--noconfirm - не спрашивать каких-либо подтверждений)
# sudo pacman -Syyu  # Обновим вашу систему (базу данных пакетов)
echo ""
echo " Обновление выполнено "
fi

clear
echo ""
echo -e "${YELLOW}=> ${NC}Загрузим архив (ветку мастер MarcMilany/archmy_2020)?"
#echo 'Загрузим архив (ветку мастер MarcMilany/arch_2020)'
# Upload the archive (branch master MarcMilany/arch_2020)
echo -e "${CYAN}:: ${NC}Эти действия необходимы, если Вы при установке основной системы пропустили какой-либо пункт меню сценария (скрипта), и хотите выполнить эти действия сейчас. (на всякий пожарный)"
echo -e "${MAGENTA}:: ${NC}Папка 'archmy_2020' - будет находить в домашней (home) директории пользователя, Вы можете переместить её в удобное для Вас место (папку; директорию) и пользоваться скриптами как шпаргалкой."
echo " Будьте внимательны! Процесс загрузки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да загрузить,     0 - НЕТ - Пропустить действие: " i_master  # sends right after the keypress; # отправляет сразу после нажатия клавиши    
    echo ''
    [[ "$i_master" =~ [^10] ]]
do
    :
done 
if [[ $i_master == 0 ]]; then 
echo ""   
echo " Загрузка master ветки пропущена "
elif [[ $i_master == 1 ]]; then
  echo ""    
  echo " Загрузка master ветки "
# wget https://github.com/MarcMilany/arch_2020.git/archive/master.zip
# wget github.com/MarcMilany/arch_2020.git/archive/arch_2020-master.zip
# sudo mv -f ~/Downloads/master.zip
# sudo mv -f ~/Downloads/arch_2020-master.zip
# sudo tar -xzf master.zip -C ~/ 
# sudo tar -xzf arch_2020-master.zip -C ~/
# git clone https://github.com/MarcMilany/arch_2020.git
git clone https://github.com/MarcMilany/archmy_2020.git
echo ""
echo " Загрузка master ветки выполнена "
fi

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
#-----------------------------------------------
# Знакомьтесь, pacman - лучший пакетный менеджер в мире линукса!
#pacman -Syy   - обновление баз пакмэна(как apt-get update в дэбианоподбных)
#pacman -Syyu  - обновление баз плюс обновление пакетов
#--------------------------------------------- 
fi
# --------------------------------------
### Если возникли проблемы с обновлением, или установкой пакетов 
### Если ли вам нужен этот пункт в скрипте, то раскомментируйте ниже в меню все тройные решётки (###)

clear
echo ""
echo -e "${YELLOW}==> ${NC}Обновить и добавить новые ключи?"
echo " Данный этап поможет вам избежать проблем с ключами Pacmаn, если Вы использовали не свежий образ ArchLinux для установки! "
echo -e "${RED}==> ${BOLD}Примечание: - Иногда при запуске обновления ключей по hkp возникает ошибка, не переживайте просто при установке gnupg в линукс в дефолтном конфиге указан следующий сервер: (keyserver hkp://keys.gnupg.net). GnuPG - оснащен универсальной системой управления ключами, а также модулями доступа для всех типов открытых ключей. GnuPG, также известный как GPG, это инструмент командной строки с возможностью легкой интеграции с другими приложениями. Доступен богатый выбор пользовательских приложений и библиотек. ${NC}"
echo -e "${RED}==> ${BOLD}Примечание: - Однако, в ходе чтения различных руководств в интернете было выяснено, что подобный способ обновления и передачи ключей не самый лучший, т.к. эта информация передается открытым способом. И тот, кто наблюдает за траффиком, видит данные обновляемых при gpg -refresh-keys ключей. И поэтому рекомендуется использовать hkps сервера - (keyserver hkps://hkps.pool.sks-keyservers.net)! ${NC}"
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, можно пропустить запуск обновления ключей. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да обновить,    0 - Нет пропустить: " x_key  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_key" =~ [^10] ]]
do
    :
done
 if [[ $x_key == 0 ]]; then
echo ""
echo " Обновление ключей пропущено " 
elif [[ $x_key == 1 ]]; then
clear
echo ""
echo " Выполним резервное копирование каталога (/etc/pacman.d/gnupg), на всякий случай "
# Файлы конфигурации по умолчанию: ~/.gnupg/gpg.conf и ~/.gnupg/dirmngr.conf.
sudo cp -R /etc/pacman.d/gnupg /etc/pacman.d/gnupg_back
# Я тебе советовал перед созданием нового брелка удалить директории (но /root/.gnupg не удалена)
echo " Удалим директорию (/etc/pacman.d/gnupg) "
sudo rm -R /etc/pacman.d/gnupg
# sudo rm -r /etc/pacman.d/gnupg
# sudo mv /usr/lib/gnupg/scdaemon{,_}  # если демон смарт-карт зависает (это можно обойти с помощью этой команды)
echo " Выполним резервное копирование каталога (/root/.gnupg), на всякий случай "
sudo cp -R /root/.gnupg /root/.gnupg_back        
#echo " Удалим директорию (/etc/pacman.d/gnupg) "
#sudo rm -R /root/.gnupg
echo " Создаётся генерация мастер-ключа (брелка) pacman "  # gpg –refresh-keys
sudo pacman-key --init  # генерация мастер-ключа (брелка) pacman
echo " Далее идёт поиск ключей... "
sudo pacman-key --populate archlinux  # поиск ключей
echo ""
echo " Обновление ключей... "  
sudo pacman-key --refresh-keys --keyserver keys.gnupg.net  # http://pool.sks-keyservers.net/
echo ""
echo "Обновим базы данных пакетов..."
###  sudo pacman -Sy
sudo pacman -Syy  # обновление баз пакмэна (pacman) 
# sudo pacman -Syyu  # Обновим вашу систему (базу данных пакетов)
# sudo pacman -Syyu  --noconfirm  
clear
echo ""
echo " Обновление и добавление новых ключей выполнено "
echo ""
echo -e "${BLUE}:: ${NC}Установить приложение Seahorse для управления вашими паролями и ключами шифрования?"
echo -e "${MAGENTA}=> ${BOLD}Seahorse - специализированное Vala / GTK / Gnome (GCR/GCK) графическое приложение для создания и централизованного хранения ключей шифрования и паролей. ${NC}"
echo " Основным назначением Seahorse является предоставление простого в использовании инструмента для управления ключами шифрования и паролями, а также операций шифрования. Приложение является графическим интерфейсом (GUI) к консольным утилитам GnuPG (GPG) и SSH (Secure Shell). "
echo -e "${CYAN}:: ${NC}GPG / GnuPG (GNU Privacy Guard) - консольная утилита для шифрования информации и создания электронных цифровых подписей с помощью различных алгоритмов (RSA, DSA, AES и др...). Утилита создана как свободная альтернатива проприетарному PGP (Pretty Good Privacy) и полностью совместима с стандартом IETF OpenPGP (может взаимодействовать с PGP и другими OpenPGP-совместимыми системами)."
echo -e "${CYAN}:: ${NC}SSH (Secure Shell - Безопасная Оболочка) — сетевой протокол прикладного уровня, позволяющий проводить удалённое управление операционной системой и туннелирование TCP-соединений (например для передачи файлов). Весь трафик шифруется, включая и передаваемые пароли, предоставляя возможность выбора используемых алгоритмов шифрования."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Установить приложение Seahorse,     0 - НЕТ - Пропустить установку: " i_seahorse  # sends right after the keypress; # отправляет сразу после нажатия клавиши    
    echo ''
    [[ "$i_seahorse" =~ [^10] ]]
do
    :
done 
if [[ $i_seahorse == 0 ]]; then 
echo ""   
echo " Установка приложения для управления паролями и ключами шифрования пропущена "
elif [[ $i_seahorse == 1 ]]; then
  echo ""    
  echo " Установка приложение Seahorse для управления ключами PGP "
sudo pacman -S seahorse --noconfirm  # Приложение GNOME для управления ключами PGP (управления паролями и ключами шифрования)
echo ""
echo " Установка Приложение GNOME для управления ключами PGP "
fi
fi
sleep 1
# ----------------------------------
# Или:
#sudo pacman-key --init && sudo pacman-key --populate archlinux && sudo pacman-key --refresh-keys && sudo pacman -Sy
# Если возникли проблемы с обновлением, или установкой пакетов выполните данные рекомендации.
# sudo pacman-key --init && sudo pacman-key --populate && sudo pacman-key --refresh-keys && sudo pacman -Syy
# Если ошибка с содержанием hkps.pool.sks-keyservers.net, не может достучаться до сервера ключей выполните команды ниже. Указываем другой сервер ключей.
# sudo pacman-key --init && sudo pacman-key --populate
# sudo pacman-key --refresh-keys --keyserver keys.gnupg.net && sudo pacman -Syy
# --------------------------------
# Вопросы относительно передачи ключей по hkps
# При установке gnupg в линукс в дефолтном конфиге указан следующий сервер:
# keyserver hkp://keys.gnupg.net
# Однако, в ходе чтения различных руководств в интернете было выяснено, что подобный способ обновления и передачи ключей не самый лучший, т.к. эта информация передается открытым способом. И тот, кто наблюдает за траффиком, видит данные обновляемых при gpg —refresh-keys ключей. И поэтому рекомендуется использовать hkps сервера.
# А именно предлагается сделать следующие изменения в конфиге gnupg:
# keyserver hkps://hkps.pool.sks-keyservers.net
# keyserver-options ca-cert-file=/path/to/CA/sks-keyservers.netCA.pem
# где sks-keyservers.netCA.pem – есть сертификат, загружаемый с
# wwwhttps://sks-keyservers.net/sks-keyservers.netCA.pem
# Вопросы относительно передачи ключей по hkps
# https://www.pgpru.com/%D4%EE%F0%F3%EC/%D0%E0%E1%EE%F2%E0%D1GnuPG/%C2%EE%EF%F0%EE%F1%FB%CE%F2%ED%EE%F1%E8%F2%E5%EB%FC%ED%EE%CF%E5%F0%E5%E4%E0%F7%E8%CA%EB%FE%F7%E5%E9%CF%EEHkps
# GnuPG (Русский)
# https://wiki.archlinux.org/index.php/GnuPG_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# OpenPGP
# https://www.openpgp.org/about/
# https://tools.ietf.org/html/rfc4880
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
# sudo hwclock -w  # переведёт аппаратные часы
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
echo ""
echo -e "${BLUE}:: ${NC}Проверим корректность загрузки установленных микрокодов " 
#echo " Давайте проверим, правильно ли загружен установленный микрокод "
# Let's check whether the installed microcode is loaded correctly
echo -e "${MAGENTA}=> ${NC}Если таковые (микрокод-ы: amd-ucode; intel-ucode) были установлены! "
echo " Если микрокод был успешно загружен, Вы увидите несколько сообщений об этом "
echo " Будьте внимательны! Вы можете пропустить это действие. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да проверим корректность загрузки,    0 - Нет пропустить: " x_ucode  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_ucode" =~ [^10] ]]
do
    :
done
 if [[ $x_ucode == 0 ]]; then
echo ""
echo " Проверка пропущена " 
elif [[ $x_ucode == 1 ]]; then
echo ""
echo " Выполним проверку корректности загрузки установленных микрокодов "
sudo dmesg | grep microcode
#dmesg | grep microcode
fi
sleep 04

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Микрокод для процессора INTEL_CPU, AMD_CPU?"
echo -e "${BLUE}:: ${BOLD}Обновление Microcode (matching CPU) ${NC}"
echo " Производители процессоров выпускают обновления стабильности и безопасности 
        для микрокода процессора "
echo " Огласите весь список, пожалуйста! :) "
echo " 1 - Для процессоров AMD установите пакет amd-ucode. "
echo " 2 - Для процессоров Intel установите пакет intel-ucode. "
echo " 3 - Если Arch находится на съемном носителе, Вы должны установить микрокод для обоих производителей процессоров. "
echo " Для Arch Linux на съемном носителе добавьте оба файла initrd в настройки загрузчика. "
echo " Их порядок не имеет значения, если они оба указаны до реального образа initramfs. "
echo -e "${MAGENTA}=> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
echo " Будьте внимательны! Без этих обновлений Вы можете наблюдать ложные падения или неожиданные зависания системы, которые может быть сложно отследить. "
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления" 
echo ""
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Для процессоров AMD,    2 - Для процессоров INTEL, 

    3 - Для процессоров AMD и INTEL, 

    0 - Нет Пропустить этот шаг: " prog_cpu  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_cpu" =~ [^1230] ]]
do
    :
done
if [[ $prog_cpu == 0 ]]; then
echo ""
echo " Установка микрокода процессоров пропущена "
elif [[ $prog_cpu == 1 ]]; then
  echo ""
  echo " Устанавливаем uCode для процессоров - AMD "
sudo pacman -S amd-ucode --noconfirm  # Образ обновления микрокода для процессоров AMD
echo " Установлены обновления стабильности и безопасности для микрокода процессора - AMD "
echo " После завершения установки пакета программного обеспечения нужно перезагрузить компьютер "
echo ""
echo -e "${BLUE}:: ${NC}Обновляем grub.cfg (Сгенерируем grub.cfg)"
sudo grub-mkconfig -o /boot/grub/grub.cfg   # создаём конфигурационный файл     
elif [[ $prog_cpu == 2 ]]; then
  echo ""  
  echo " Устанавливаем uCode для процессоров - INTEL "
sudo pacman -S intel-ucode --noconfirm  # Образ обновления микрокода для процессоров INTEL
sudo pacman -S iucode-tool --noconfirm  # Инструмент для управления пакетами микрокода Intel® IA-32 / X86-64
echo " Установлены обновления стабильности и безопасности для микрокода процессора - INTEL "
echo " После завершения установки пакета программного обеспечения нужно перезагрузить компьютер " 
echo ""
echo -e "${BLUE}:: ${NC}Обновляем grub.cfg (Сгенерируем grub.cfg)"
sudo grub-mkconfig -o /boot/grub/grub.cfg   # создаём конфигурационный файл    
elif [[ $prog_cpu == 3 ]]; then
  echo ""  
  echo " Устанавливаем uCode для процессоров - AMD и INTEL "
sudo pacman -S amd-ucode intel-ucode --noconfirm  # Образ обновления микрокода для процессоров AMD и INTEL
sudo pacman -S iucode-tool --noconfirm  # Инструмент для управления пакетами микрокода Intel® IA-32 / X86-64
echo " Установлены обновления стабильности и безопасности для микрокода процессоров - AMD и INTEL "
echo " После завершения установки пакета программного обеспечения нужно перезагрузить компьютер "
echo ""
echo -e "${BLUE}:: ${NC}Обновляем grub.cfg (Сгенерируем grub.cfg)"
sudo grub-mkconfig -o /boot/grub/grub.cfg   # создаём конфигурационный файл     
fi

clear
echo -e "${MAGENTA}
  <<< Создание полного набора пользовательских каталогов по умолчанию, в пределах "HOME" каталога. >>> ${NC}"
echo -e "${YELLOW}==> Примечание: ${NC}Сейчас Вы можете создать, если пропустили это действие в предыдущем скрипте (при установке основной системы), или пропустить создание (установку)." 

echo ""
echo -e "${GREEN}==> ${NC}Создаём папки в директории пользователя (Downloads, Music, Pictures, Videos, Documents)."
echo -e "${CYAN}:: ${NC}По умолчанию в системе Arch Linux в каталоге "HOME" НЕ создаются папки (Загрузки, Шаблоны, Общедоступные, Документы, Музыка, Изображения, Видео), кроме папки Рабочий стол (Desktop)."
echo -e "${CYAN}:: ${NC}Согласно философии Arch, вместо удаления ненужных пакетов, папок, пользователю предложена возможность построить систему, начиная с минимальной основы без каких-либо заранее выбранных шаблонов... "
echo " Давайте проанализируем действия, которые выполняются. "
echo " 1 - Создание каталогов по умолчанию с помощью (xdg-user-dirs), тогда укажите вариант "1" "
echo " xdg-user-dirs - это инструмент, помогающий создать и управлять "хорошо известными" пользовательскими каталогами, такими как папка рабочего стола, папка с музыкой и т.д.. Он также выполняет локализацию (то есть перевод) имен файлов. "
echo " Большинство файловых менеджеров обозначают пользовательские каталоги XDG специальными значками. "
echo " 2(0) - Если Вам не нужны папки в директории пользователя, или Вы уже создали папки, тогда выбирайте вариант "0" " 
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

clear
echo ""
echo -e "${BLUE}:: ${NC}Создадим папку (downloads), и перейдём в созданную папку " 
#echo " Создадим папку (downloads), и переходим в созданную папку "
# Create a folder (downloads), and go to the created folder
echo -e "${MAGENTA}=> ${NC}Почти весь процесс: по загрузке, сборке софта (пакетов) устанавливаемых из AUR - будет проходить в папке (downloads)."
echo -e "${CYAN}:: ${NC}Если Вы захотите сохранить софт (пакеты) устанавливаемых из AUR, и в последствии создать свой маленький (пользовательский репозиторий Arch), тогда перед удалением папки (downloads) в заключении работы скрипта, скопируйте нужные вам пакеты из папки (downloads) в другую директорию."
echo -e "${YELLOW}==> Примечание: ${NC}Вы можете пропустить создание папки (downloads), тогда сборка софта (пакетов) устанавливаемых из AUR - будет проходить в папке указанной (для сборки) Pacman gui (в его настройках, если таковой был установлен), или по умолчанию в одной из системных папок (tmp;...;...)." 
echo " В заключении работы сценария (скрипта) созданная папка (downloads) - Будет полностью удалена из домашней (home) директории! "
echo " Будьте внимательны! Вы можете пропустить это действие. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да создать папку (downloads),     0 - НЕТ - Пропустить действие: " i_folder  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_folder" =~ [^10] ]]
do
    :
done
if [[ $i_folder == 0 ]]; then
echo ""  
echo " Создание папки (downloads) пропущено "
elif [[ $i_folder == 1 ]]; then
echo ""
echo " Создаём и переходим в созданную папку (downloads) "
mkdir ~/downloads  # создание папки (downloads)
cd ~/downloads  # перейдём в созданную папку
echo " Посмотрим в какой директории мы находимся "
pwd  # покажет в какой директории мы находимся
fi

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
echo " 1 - 'AUR'-'yay-bin' скрипт созданный (autor): Alex Creio https://cvc.hashbase.io/ - Обертка Pacman и помощник AUR, написанные на языке go. (версия в разработке), то выбирайте вариант - "1" "
echo -e "${CYAN}:: ${NC}Установка 'AUR'-'yay-bin' проходит через сборку из исходников AUR. То есть установка производиться с помощью git clone (https://aur.archlinux.org/yay-bin.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/yay-bin/), собирается и устанавливается."
echo " 2 - 'AUR'-'yay' Йогурт (yogurt). Обертка Pacman и помощник AUR, написанные на языке go, то вариант - "2" "
echo -e "${CYAN}:: ${NC}Установка 'AUR'-'yay' производиться с помощью git clone (https://aur.archlinux.org/yay.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/yay/), собирается и устанавливается."
echo " 3 - 'AUR'-'pikaur' Помощник AUR, который задает все вопросы перед установкой / сборкой. В духе pacaur, yaourt и yay, то выбирайте вариант - "3" "
echo -e "${CYAN}:: ${NC}Установка 'AUR'-'pikaur' производиться с помощью git clone (https://aur.archlinux.org/pikaur.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/pikaur/), собирается и устанавливается."
echo -e "${YELLOW} Подчеркну (обратить внимание)! ${NC}Pikaur - идёт как зависимость для Octopi."
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
echo " 1 - Обновление баз данных пакетов, и системы через 'AUR'-'yay', то выбирайте вариант - "1" "
echo " 2 - Установка обновлений баз данных пакетов, и системы через 'AUR'-'pikaur', выбирайте вариант - "2" "
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
echo " 1 - Pacman gui (pamac-aur) - Графический менеджер пакетов (интерфейс Gtk3 для libalpm), тогда укажите "1" "
echo " Графический менеджер пакетов для Arch, Manjaro Linux с поддержкой Alpm, AUR, и Snap. "
echo " 2 - Pacman gui (octopi) - Графический менеджер пакетов (мощный интерфейс Pacman с использованием библиотек Qt5), тогда укажите вариант "2" " 
echo -e "${CYAN}=> ${BOLD}Вариант '2' Напрямую привязан к Установке AUR Helper, если ранее БЫЛ выбран AUR-(pikaur). ${NC}"
echo -e "${YELLOW}:: ${NC}Так как - Подчеркну (обратить внимание)! 'Pikaur' - идёт как зависимость для Octopi." 
echo " 3 - Pacman gui (octopi) - Графический менеджер пакетов (мощный интерфейс Pacman с использованием библиотек Qt5), тогда укажите вариант "3" "
echo -e "${CYAN}=> ${BOLD}Вариант '3' - Если ранее при Установке 'AUR Helper' НЕ БЫЛ УСТАНОВЛЕН AUR-(pikaur). ${NC}"
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
echo -e "${YELLOW}==> Примечание: ${NC}Сейчас Вы можете установить "Gksu", или пропустите установку."

echo ""
echo -e "${GREEN}==> ${NC}Установить Gksu - Графический интерфейс для su"
#echo -e "${BLUE}:: ${NC}Установить Gksu - Графический интерфейс для su" 
#echo 'Установить Gksu - Графический интерфейс для su'
# To install Gksu - Graphical UI for subversion
echo " Ставим пакет (gksu) - графический интерфейс для su, и пакет (libgksu) - библиотека авторизации gksu "
echo -e "${MAGENTA}:: ${BOLD}Для запуска графических приложений от имени суперпользователя существуют специальные утилиты. Они сохраняют все необходимые переменные окружения и полномочия. В KDE это команда kdesu, а в Gnome,Xfce,... - команда gksu (gksu nautilus). ${NC}"
echo " Программа запросит пароль, уже в графическом окне, а потом откроется файловый менеджер. "
echo " Теперь программы, требующие дополнительных привилегий в системе, не вызовут у вас проблем. "
echo -e "${CYAN}:: ${NC}Установка Gksu (gksu), и (libgksu), проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/gksu/), (https://aur.archlinux.org/packages/libgksu/), (https://aur.archlinux.org/packages/gconf.git/)-(это зависимость для libgksu) - собирается и устанавливается. "
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
#clear
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
#clear
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

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Downgrading packages"
#echo -e "${BLUE}:: ${NC}Установить Downgrading packages " 
#echo 'Установить Downgrading packages '
# To install Downgrading packages 
echo " Ставим пакет (downgrade) - Bash-скрипт для понижения версии одного или нескольких пакетов до версии в вашем кэше или ALA. "
echo -e "${YELLOW}==> Примечание: ${NC}Откат версии пакета НЕ рекомендуется и применяется в том случае, когда в текущем пакете обнаружена ошибка."  
echo -e "${MAGENTA}:: ${NC}Прежде чем откатить пакет, подумайте, нужно ли это делать. Если необходимость отката вызвана ошибками, пожалуйста, помогите сообществу Arch и разработчикам этого ПО, потратьте несколько минут на составление отчета об ошибке и отправке его в трекер ошибок Arch или на сайт самого проекта. В связи с безрелизной моделью развития Arch при продолжительном его использовании, Вы, возможно, периодически будете сталкиваться с ошибками в новых пакетах. Наше сообщество и разработчики ПО будут признательны Вам за приложенные усилия. Дополнительная информация может не только спасти нас от часов тестирования и отладки, но также позволит повысить стабильность программного обеспечения. "
echo -e "${CYAN}:: ${NC}Установка Downgrading (downgrade) проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/downgrade/) - собирается и устанавливается. "
# https://wiki.archlinux.org/index.php/Downgrading_packages_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор остаётся за вами. "
# Be careful! The installation process was fully automatic. In this option, the choice is yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " downgrade_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " downgrade_set  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$downgrade_set" =~ [^10] ]]
do
    :
done 
if [[ $downgrade_set == 0 ]]; then
#clear
echo ""
echo " Bash-скрипт для понижения версии одного или нескольких пакетов (downgrade) пропущена "
elif [[ $downgrade_set == 1 ]]; then
  echo ""   
  echo " Установка downgrade - Bash-скрипт для понижения версии пакетов"    
git clone https://aur.archlinux.org/downgrade.git  # Bash-скрипт для понижения версии пакетов
cd downgrade
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf downgrade
rm -Rf downgrade
#clear
echo ""
echo " Bash-скрипт (downgrade) успешно установлен! "
fi

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
sudo pacman -S ufw gufw --noconfirm  # Несложный и простой в использовании инструмент командной строки для управления межсетевым экраном netfilter; GUI - для управления брандмауэром Linux
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
#sudo pacman -S bluez-tools --noconfirm  # Набор инструментов для управления устройствами Bluetooth для Linux
#sudo pacman -S blueberry --noconfirm  # Инструмент настройки Bluetooth
#sudo pacman -S bluedevil --noconfirm  # Интегрируйте технологию Bluetooth в рабочее пространство и приложения KDE
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
sudo pacman -S alsa-card-profiles --noconfirm  # Профили карт ALSA, общие для PulseAudio
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
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (lha, unace, lrzip, sharutils, uudeview, arj, cabextract, uudeview, snappy, minizip, quazip, brotli, pbzip2)."
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
sudo pacman -S minizip --noconfirm  # Mini zip и unzip на основе zlib
sudo pacman -S quazip --noconfirm  # Оболочка C ++ для пакета C ZIP / UNZIP Жиля Воллана
sudo pacman -S brotli --noconfirm  # Универсальный алгоритм сжатия без потерь, который сжимает данные с использованием комбинации современного варианта алгоритма LZ77, кодирования Хаффмана и контекстного моделирования 2-го порядка со степенью сжатия, сопоставимой с лучшими доступными в настоящее время универсальными методами сжатия.
sudo pacman -S pbzip2 --noconfirm  #  Параллельная реализация компрессора файлов с сортировкой блоков bzip2
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
echo " 1 - File Roller - Легковесный менеджер архивов для среды рабочего стола GNOME, можно использовать и для другого DE (XFCE, LXDE, Lxqt...), то выбирайте вариант - "1" "
echo " File Roller поддерживает множество типов архивов, включая gzip (tar.gz, tar.xz, tgz), bzip (tar.bz, tbz), bzip2 (tar.bz2, tbz2), Z (tar.Z, taz), lzop ( tar.lzo, tzo), zip, jar (jar, ear, war), lha, lzh, rar, ace, 7z, alz, ar и arj. "
echo " Кроме того, он поддерживает типы архивов cab, cpio, deb, iso, cbr, rpm, bin, sit, tar.7z, cbz и zoo, а также отдельные файлы, сжатые с помощью xz, gzip, bzip, bzip2. , lzop, lzip, z или rzip алгоритмы сжатия. "
echo " 2 - Ark (в переводе Ковчег) - Менеджер архивов для среды рабочего стола KDE(Plasma), можно использовать и для другого DE, то выбирайте вариант - "2" "
echo " Ark поддерживает работу со всеми основными форматами архивов: - (tar, gzip, bzip, bzip2, zip, xpi, lha, zoo, ar, rar) и некоторые другие. Поддерживаются и двойные архивы (например, tar.gz, tzr.bz2 и прочие). "
echo " 3 - Xarchiver (GTK+2) - Легковесный настольный независимый менеджер архивов, созданный с помощью набора инструментов (GTK+2), можно использовать с любой средой рабочего стола, то выбирайте вариант - "3" "
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
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (accountsservice, acpi, acpid, android-tools, android-udev, arch-install-scripts, aspell-en, aspell-ru, autofs, b43-fwcutter, bash-completion, beep, bind, btrfs-progs, busybox, ccache, cmake, cpio, cpupower, crda, davfs2, desktop-file-utils, dhclient, dnsmasq, dosfstools, efibootmgr, efitools, ethtool, f2fs-tools, flex, fortune-mod, fsarchiver, fuse3, glances, gnome-nettool, gnu-netcat, gpm, gptfdisk, gtop, gvfs, gvfs-gphoto2, gvfs-nfs, gvfs-smb, haveged, hddtemp, hidapi, hwinfo, hydra, hyphen-en, id3lib, iftop, inetutils, isomd5sum, jfsutils, lib32-curl, lib32-flex, libfm-gtk2, lksctp-tools, logrotate, lsof, lsb-release, man-db, man-pages, mc, memtest86+, mlocate, mtpfs, ncdu, nfs-utils, nss-mdns, pacman-contrib, patchutils, pciutils, php, poppler-data, powertop, pv, pwgen, python-isomd5sum, python-pip, qt5-translations, reiserfsprogs, ruby, s-nail, sane, scrot, sg3_utils, sdparm, solid, sox, smartmontools, speedtest-cli, squashfs-tools, syslinux, systemd-ui, termite, termite-terminfo, translate-shell, udiskie, usb_modeswitch, wimlib, xsel, xterm, xorg-twm, xorg-xkill, yelp, youtube-dl)."
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
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
# sudo pacman -S accountsservice acpi acpid android-tools android-udev arch-install-scripts aspell-en aspell-ru autofs b43-fwcutter bash-completion beep bind btrfs-progs busybox ccache cmake cpio cpupower crda davfs2 desktop-file-utils dhclient dnsmasq dosfstools efibootmgr efitools ethtool f2fs-tools flex fortune-mod fsarchiver fuse3 glances gnome-nettool gnu-netcat gpm gptfdisk gtop gvfs gvfs-gphoto2 gvfs-nfs gvfs-smb haveged hddtemp hidapi hwinfo hydra hyphen-en id3lib iftop inetutils isomd5sum jfsutils lib32-curl lib32-flex libfm-gtk2 lksctp-tools logrotate lsof man-db man-pages mc memtest86+ mlocate mtpfs ncdu nfs-utils nss-mdns patchutils pciutils php poppler-data powertop pv pwgen python-isomd5sum python-pip qt5-translations reiserfsprogs ruby s-nail sane scrot sg3_utils sdparm solid sox smartmontools speedtest-cli squashfs-tools syslinux systemd-ui termite termite-terminfo translate-shell udiskie usb_modeswitch wimlib xsel xterm xorg-twm xorg-xkill yelp youtube-dl --noconfirm  # light-locker lsb-release python python2 - присутствует  
# reflector git curl  - пока присутствует в pkglist.x86_64 
sudo pacman -S accountsservice --noconfirm  # Интерфейс D-Bus для запроса учетных записей пользователей и управления ими
sudo pacman -S acpi --noconfirm  # Клиент для показаний батареи, мощности и температуры
sudo pacman -S acpid --noconfirm  # Демон для доставки событий управления питанием ACPI с поддержкой netlink
sudo pacman -S android-tools --noconfirm  # Инструменты платформы Android
sudo pacman -S android-udev --noconfirm  # Правила Udev для подключения устройств Android к вашему Linux-серверу
sudo pacman -S arch-install-scripts --noconfirm  # Сценарии для помощи в установке Arch Linux
sudo pacman -S aspell-en --noconfirm  # Английский словарь для aspell
sudo pacman -S aspell-ru --noconfirm  # Русский словарь для aspell
sudo pacman -S autofs --noconfirm  # Средство автомонтирования на основе ядра для Linux
sudo pacman -S b43-fwcutter --noconfirm  # Экстрактор прошивки для модуля ядра b43 (драйвер) 
sudo pacman -S bash-completion --noconfirm  # Программируемое завершение для оболочки bash
sudo pacman -S beep --noconfirm  # Продвинутая программа звукового сигнала динамика ПК
sudo pacman -S bind --noconfirm  # Полная, переносимая реализация протокола DNS
sudo pacman -S btrfs-progs --noconfirm  # Утилиты файловой системы btrfs
sudo pacman -S busybox --noconfirm  # Утилиты для аварийно-спасательных и встраиваемых систем
sudo pacman -S ccache --noconfirm  # Кэш компилятора, который ускоряет перекомпиляцию за счет кеширования предыдущих компиляций
sudo pacman -S cmake --noconfirm  # Кросс-платформенная система сборки с открытым исходным кодом
sudo pacman -S cpio --noconfirm  # Инструмент для копирования файлов в или из архива cpio или tar
sudo pacman -S cpupower --noconfirm  # Инструмент ядра Linux для проверки и настройки функций вашего процессора, связанных с энергосбережением
sudo pacman -S crda --noconfirm  # Агент центрального регулирующего домена для беспроводных сетей
sudo pacman -S davfs2 --noconfirm  # Драйвер файловой системы, позволяющий монтировать папку WebDAV
sudo pacman -S desktop-file-utils --noconfirm  # Утилиты командной строки для работы с записями рабочего стола
sudo pacman -S dhclient --noconfirm  # Автономный DHCP-клиент из пакета dhcp
sudo pacman -S dnsmasq --noconfirm  # Легкий, простой в настройке сервер пересылки DNS и DHCP-сервер
sudo pacman -S dosfstools --noconfirm  # Утилиты файловой системы DOS
sudo pacman -S efibootmgr --noconfirm  # Приложение пользовательского пространства Linux для изменения диспетчера загрузки EFI
sudo pacman -S efitools --noconfirm  # Инструменты для управления платформами безопасной загрузки UEFI
sudo pacman -S ethtool --noconfirm  # Утилита для управления сетевыми драйверами и оборудованием
sudo pacman -S f2fs-tools --noconfirm  # Инструменты для файловой системы, дружественной к Flash (F2FS)
sudo pacman -S flex --noconfirm  # Инструмент для создания программ сканирования текста
sudo pacman -S fortune-mod --noconfirm  # Программа Fortune Cookie от BSD games
sudo pacman -S fsarchiver --noconfirm  # Безопасный и гибкий инструмент для резервного копирования и развертывания файловой системы
sudo pacman -S fuse3 --noconfirm  # Библиотека, позволяющая реализовать файловую систему в программе пользовательского пространства
sudo pacman -S glances --noconfirm  # Инструмент мониторинга на основе CLI на основе curses
sudo pacman -S gnome-nettool --noconfirm  # Графический интерфейс для различных сетевых инструментов
sudo pacman -S gnu-netcat --noconfirm  # GNU переписывает netcat, приложение для создания сетевых трубопроводов
sudo pacman -S gpm --noconfirm  # Сервер мыши для консоли и xterm
sudo pacman -S gptfdisk --noconfirm  # Инструмент для создания разделов в текстовом режиме, который работает с дисками с таблицей разделов GUID (GPT)
sudo pacman -S gtop --noconfirm  # Панель мониторинга системы для терминала
sudo pacman -S gvfs --noconfirm  # Реализация виртуальной файловой системы для GIO (Разделенные пакеты: gvfs-afc, gvfs-goa, gvfs-google, gvfs-gphoto2, gvfs-mtp, еще…)
# sudo pacman -S gvfs-mtp --noconfirm  # Реализация виртуальной файловой системы для GIO (бэкэнд MTP; Android, медиаплеер)
# sudo pacman -S gvfs-afc --noconfirm  # Реализация виртуальной файловой системы для GIO (серверная часть AFC; мобильные устройства Apple)
# sudo pacman -S gvfs-goa --noconfirm  # Реализация виртуальной файловой системы для GIO (серверная часть Gnome Online Accounts; облачное хранилище) 
# sudo pacman -S gvfs-google --noconfirm  # Реализация виртуальной файловой системы для GIO (серверная часть Google Диска)
sudo pacman -S gvfs-gphoto2 --noconfirm  # Реализация виртуальной файловой системы для GIO (бэкэнд gphoto2; камера PTP, медиаплеер MTP)
sudo pacman -S gvfs-nfs --noconfirm  # Реализация виртуальной файловой системы для GIO (серверная часть NFS)
sudo pacman -S gvfs-smb --noconfirm  # Реализация виртуальной файловой системы для GIO (серверная часть SMB / CIFS; клиент Windows)
sudo pacman -S haveged --noconfirm  # Демон сбора энтропии с использованием таймингов процессора
sudo pacman -S hddtemp --noconfirm  # Показывает температуру вашего жесткого диска, читая информацию SMART
sudo pacman -S hidapi --noconfirm  # Простая библиотека для связи с устройствами USB и Bluetooth HID
sudo pacman -S hwinfo --noconfirm  # Инструмент обнаружения оборудования от openSUSE
sudo pacman -S hydra --noconfirm  # Очень быстрый взломщик входа в сеть, который поддерживает множество различных сервисов
sudo pacman -S hyphen-en --noconfirm  # Правила расстановки переносов в английском
sudo pacman -S id3lib --noconfirm  # Библиотека для чтения, записи и управления тегами ID3v1 и ID3v2
sudo pacman -S iftop --noconfirm  # Отображение использования полосы пропускания на интерфейсе
# sudo pacman -S inetutils --noconfirm  # Сборник общих сетевых программ   # присутствует
sudo pacman -S isomd5sum --noconfirm  # Утилиты для работы с md5sum, имплантированными в ISO-образы
sudo pacman -S jfsutils --noconfirm  # Утилиты файловой системы JFS
sudo pacman -S lib32-curl --noconfirm  # Утилита и библиотека для поиска URL (32-разрядная версия)
sudo pacman -S lib32-flex --noconfirm  # Инструмент для создания программ сканирования текста
sudo pacman -S libfm-gtk2 --noconfirm  # Библиотека GTK + 2 для управления файлами
# sudo pacman -S light-locker --noconfirm  # Простой шкафчик сессий для LightDM   # присутствует
sudo pacman -S lksctp-tools --noconfirm  # Реализация протокола SCTP (http://lksctp.sourceforge.net/)
sudo pacman -S logrotate --noconfirm  # Автоматическая ротация системных журналов
sudo pacman -S lsb-release --noconfirm  # Программа запроса версии LSB   # присутствует
sudo pacman -S lsof --noconfirm  # Перечисляет открытые файлы для запуска процессов Unix
sudo pacman -S man-db --noconfirm  # Утилита для чтения страниц руководства
sudo pacman -S man-pages --noconfirm  # Страницы руководства Linux
sudo pacman -S mc --noconfirm  # Файловый менеджер, эмулирующий Norton Commander
sudo pacman -S memtest86+ --noconfirm  # Усовершенствованный инструмент диагностики памяти
sudo pacman -S mlocate --noconfirm  # Слияние реализации locate / updatedb
sudo pacman -S mtpfs --noconfirm  # Файловая система FUSE, поддерживающая чтение и запись с любого устройства MTP
sudo pacman -S ncdu --noconfirm  # Анализатор использования диска с интерфейсом ncurses
sudo pacman -S nfs-utils --noconfirm  # Программы поддержки для сетевых файловых систем
sudo pacman -S nss-mdns --noconfirm  # Плагин glibc, обеспечивающий разрешение имени хоста через mDNS
#sudo pacman -S pacman-contrib --noconfirm  # Предоставленные скрипты и инструменты для систем pacman  # присутствует
sudo pacman -S patchutils --noconfirm  # Небольшая коллекция программ, работающих с файлами патчей
sudo pacman -S pciutils --noconfirm  # Библиотека и инструменты доступа к пространству конфигурации шины PCI
sudo pacman -S php --noconfirm  # Язык сценариев общего назначения, особенно подходящий для веб-разработки
sudo pacman -S poppler-data --noconfirm  # Кодирование данных для библиотеки рендеринга PDF Poppler
sudo pacman -S powertop --noconfirm  # Инструмент для диагностики проблем с энергопотреблением и управлением питанием
sudo pacman -S pv --noconfirm  # Инструмент на основе терминала для мониторинга прохождения данных по конвейеру
sudo pacman -S pwgen --noconfirm  # Генератор паролей для создания легко запоминающихся паролей
# sudo pacman -S python --noconfirm  # Новое поколение языка сценариев высокого уровня Python  # присутствует
# sudo pacman -S python2 --noconfirm  # Язык сценариев высокого уровня Python (Конфликты: python <3) # возможно присутствует
sudo pacman -S python-isomd5sum --noconfirm  # Привязки Python3 для isomd5sum
sudo pacman -S python-pip --noconfirm  # Рекомендуемый PyPA инструмент для установки пакетов Python
sudo pacman -S qt5-translations --noconfirm  # кросс-платформенное приложение и UI-фреймворк (переводы)
sudo pacman -S reiserfsprogs --noconfirm  # Утилиты Reiserfs
sudo pacman -S ruby --noconfirm  # Объектно-ориентированный язык для быстрого и простого программирования
sudo pacman -S s-nail --noconfirm  # Среда для отправки и получения почты
sudo pacman -S sane --noconfirm  # Доступ к сканеру теперь простой
sudo pacman -S scrot --noconfirm  # Простая утилита для создания снимков экрана из командной строки для X
sudo pacman -S sg3_utils --noconfirm  # Универсальные утилиты SCSI
sudo pacman -S sdparm --noconfirm  # Утилита, аналогичная hdparm, но для устройств SCSI
sudo pacman -S solid --noconfirm  # Аппаратная интеграция и обнаружение
sudo pacman -S sox --noconfirm  # Швейцарский армейский нож инструментов обработки звука
sudo pacman -S smartmontools --noconfirm  # Управление и мониторинг жестких дисков ATA и SCSI с поддержкой SMAR
sudo pacman -S speedtest-cli --noconfirm  # Интерфейс командной строки для тестирования пропускной способности интернета с помощью speedtest.net
sudo pacman -S squashfs-tools --noconfirm  # Инструменты для squashfs, файловой системы Linux с высокой степенью сжатия, доступной только для чтения 
sudo pacman -S syslinux --noconfirm  # Коллекция загрузчиков, которые загружаются с файловых систем FAT, ext2 / 3/4 и btrfs, с компакт-дисков и через PXE
sudo pacman -S systemd-ui --noconfirm  # Графический интерфейс для systemd
sudo pacman -S termite --noconfirm  #  Простой терминал на базе VTE
sudo pacman -S termite-terminfo --noconfirm  # Terminfo для Termite, простого терминала на базе VTE
sudo pacman -S translate-shell --noconfirm  # Интерфейс командной строки и интерактивная оболочка для Google Translate
sudo pacman -S udiskie --noconfirm  # Автоматическое монтирование съемных дисков с использованием udisks
sudo pacman -S usb_modeswitch --noconfirm  # Активация переключаемых USB-устройств в Linux
sudo pacman -S wimlib --noconfirm  # Библиотека и программа для извлечения, создания и изменения файлов WIM
sudo pacman -S xsel --noconfirm  # XSel - это программа командной строки для получения и установки содержимого выделения X
sudo pacman -S xterm --noconfirm  # Эмулятор терминала X
# sudo pacman -S xorg-xclock --noconfirm  # X часы
sudo pacman -S xorg-twm --noconfirm  # Вкладка Window Manager для системы X Window
sudo pacman -S xorg-xkill --noconfirm  # Убить клиента его X-ресурсом
sudo pacman -S yelp --noconfirm  # Получите помощь с GNOME
sudo pacman -S youtube-dl --noconfirm  # Программа командной строки для загрузки видео с YouTube.com и еще нескольких сайтов
# sudo pacman -S  --noconfirm  #
# sudo pacman -S  --noconfirm  # 
# sudo pacman -S  --noconfirm  # 
### Исправим отображение миниатюр в файловом менеджере ###
# sudo pacman -S tumbler ffmpegthumbnailer poppler-glib libgsf libopenraw shared-mime-info raw-thumbnailer perl-file-mimeinfo --noconfirm 
#sudo pacman -S tumbler --noconfirm  #  Сервис D-Bus для приложений, запрашивающих миниатюры
#sudo pacman -S ffmpegthumbnailer --noconfirm  # Легкий эскиз видеофайлов, который может использоваться файловыми менеджерами
#sudo pacman -S poppler-glib --noconfirm  # Наручники Poppler Glib
#sudo pacman -S libgsf --noconfirm  # Расширяемая библиотека абстракции ввода-вывода для работы со структурированными форматами файлов
#sudo pacman -S libopenraw --noconfirm  # Библиотека для декодирования файлов RAW
#sudo pacman -S shared-mime-info --noconfirm  # Общая информация MIME на Freedesktop.org
#sudo pacman -S raw-thumbnailer --noconfirm  # Легкий и быстрый инструмент для создания необработанных изображений raw, который необходим для отображения миниатюр raw.
#sudo pacman -S perl-file-mimeinfo --noconfirm  # Определить тип файла, включая mimeopen и mimetype
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
echo " 1 - ScreenFetch - Скрипт CLI Bash для отображения информации о системе, то выбирайте вариант - "1" "
echo -e "${MAGENTA}:: ${NC}Простая терминальная утилита для вывода информации о системе, драйвере и ОЗУ в Linux."
echo " 2 - Neofetch - Инструмент системной информации CLI, написанный на BASH, который поддерживает отображение изображений, то выбирайте вариант - "2" "
echo " 3 - Archey3 - это простой скрипт Python, который печатает основную системную информацию и ASCII-изображение логотипа Arch Linux, то выбирайте вариант - "3" "
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
echo -e "${MAGENTA}:: ${NC}Другие аудиоплееры и видео-проигрыватели будут представлены в следующем скрипте."
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
#echo ""   
echo " Устраняем проблему с win кодировкой в текстовом редакторе (gedit) "
gsettings set org.gnome.gedit.preferences.encodings candidate-encodings "['UTF-8', 'WINDOWS-1251', 'KOI8-R', 'CURRENT', 'ISO-8859-15', 'UTF-16']"
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
#sudo pacman -S thunderbird-i18n-en-us --noconfirm  # Английский (США) языковой пакет для Thunderbird
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
echo ""
echo -e "${GREEN}==> ${NC}Flash плееры - (flashplugin) или (pepper-flash)"
echo -e "${CYAN}=> ${BOLD}В установку НЕ включены больше НЕ поддерживаемые плагины: flashplugin - Adobe Flash Player (NPAPI-версия), и pepper-flash - Adobe Flash Player (PPAPI-версия). ${NC}"
echo -e "${YELLOW}==> ${BOLD}Важно! Предупреждение (обратить внимание)! Поддержка Adobe Flash Player закончилась 31 декабря 2020 года. В результате плагины NPAPI и PPAPI больше не поддерживаются ни в одном браузере. Кроме того, проект больше не будет получать исправления ошибок или обновления безопасности. ${NC}"
echo -e "${MAGENTA}:: ${NC} Более старую автономную версию можно установить с помощью автономного пакета AUR от flashplayer . Этот пакет предшествует жестко запрограммированным часам истечения срока службы, вставленным в Flash Player, и поэтому продолжает работать."
echo " 1 - Firefox - Популярный, графический, автономный веб-браузер, с открытым исходным кодом, разрабатываемый Mozilla (mozilla.org), то выбирайте вариант - "1" "
# echo " Единственный поддерживаемый Firefox плагин - flashplugin - Adobe Flash Player (NPAPI-версия). "
echo " 2 - Chromium - Графический веб-браузер, с открытым исходным кодом, основанный на движке Blink, созданный для скорости, простоты и безопасности, разрабатываемый Google совместно с сообществом (и другими корпорациями), то выбирайте вариант - "2" "
# echo " Поддерживаемый плагин - pepper-flash - Adobe Flash Player (PPAPI-версия): эти плагины работают в Chromium (и Chrome), Opera и Vivaldi. "
echo " 3 - Opera - Графический веб-браузер, с открытым исходным кодом, основанный на движке Blink, быстрый, безопасный и простой в использовании браузер, теперь со встроенным блокировщиком рекламы, функцией экономии заряда батареи и бесплатным VPN, то выбирайте вариант - "3" "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке" 
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Firefox (без flashplugin),     2 - Chromium (без pepper-flash),     3 - Opera (без pepper-flash),    

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
echo " Установка веб-браузера Firefox (без - flashplugin) "
#sudo pacman -S firefox firefox-i18n-ru firefox-spell-ru --noconfirm
sudo pacman -S firefox --noconfirm  # Автономный веб-браузер от mozilla.org
sudo pacman -S firefox-i18n-ru --noconfirm  # Русский языковой пакет для Firefox
sudo pacman -S firefox-spell-ru --noconfirm  # Русский словарь проверки орфографии для Firefox
#sudo pacman -S firefox-i18n-en-us --noconfirm  # Английский (США) языковой пакет для Firefox
### yay -S flashplugin # Adobe Flash Player NPAPI
#sudo pacman -S firefox-developer-edition firefox-developer-edition-i18n-ru firefox-spell-ru --noconfirm  # Версия для разработчиков
clear
echo ""    
echo " Установка веб-браузера Firefox выполнена "
elif [[ $in_browser == 2 ]]; then    
echo "" 
echo " Установка веб-браузера Chromium (без - pepper-flash) "   
sudo pacman -S chromium --noconfirm  # Веб-браузер, созданный для скорости, простоты и безопасности
### yay -S pepper-flash # Adobe Flash Player PPAPI
clear
echo ""    
echo " Установка веб-браузера Chromium выполнена "
elif [[ $in_browser == 3 ]]; then
echo "" 
echo " Установка веб-браузера Opera (без - pepper-flash) "
#sudo pacman -S opera opera-ffmpeg-codecs --noconfirm  
sudo pacman -S opera --noconfirm  # Быстрый и безопасный веб-браузер
sudo pacman -S opera-ffmpeg-codecs --noconfirm  # дополнительная поддержка проприетарных кодеков для оперы
### yay -S pepper-flash # Adobe Flash Player PPAPI
clear
echo ""    
echo " Установка веб-браузера Opera выполнена "
elif [[ $in_browser == 4 ]]; then
echo "" 
echo " Установка веб-браузеров Chromium Opera Firefox "    
sudo pacman -S chromium opera opera-ffmpeg-codecs firefox firefox-i18n-ru firefox-spell-ru --noconfirm 
### yay -S pepper-flash
### yay -S flashplugin 
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
echo " 1 - Transmission - это легкий, быстрый, простой, бесплатный и кроссплатформенный BitTorrent-клиент (GTK + GUI) "
echo " 2 - qBittorrent - Усовершенствованный клиент BitTorrent, написанный на C ++, основанный на инструментарии Qt и libtorrent-rasterbar, вариант - "2" "
echo " 3 - Deluge - BitTorrent-клиент написанное на Python 3, с несколькими пользовательскими интерфейсами в модели клиент / сервер, то выбирайте вариант - "3" "
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
echo " 1 - LibreOffice-still - это мощный, официально поддерживаемый офисный пакет, имеется стабильная ветвь обновлений, то выбирайте вариант - "1" "
echo " 2 - LibreOffice-fresh - это офисный пакет, новые функции, улучшения программы появляются сначала здесь, часто обновляется, то выбирайте вариант - "2" "
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
sudo pacman -S unoconv --noconfirm  # Конвертер документов на основе Libreoffice
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
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (gparted, grub-customizer, dconf-editor, conky, conky-manager, obs-studio, filezilla, telegram-desktop, discord, flameshot, redshift, bleachbit, cherrytree, doublecmd-gtk2, keepass, keepassxc, veracrypt, kleopatra, nomacs, onboard, meld, uget, plank, openshot, galculator, galculator-gtk2, gnome-calculator)." 
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
echo -e "${MAGENTA}=> ${NC}Telegram - это мессенджер и облачный сервис, для обмена сообщениями и различными медиа файлами. В первую очередь известен благодаря шифрованию и защите личных данных пользователей."
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
echo -e "${BLUE}:: ${NC}Установить Discord (голосовой и текстовый чат)?" 
echo -e "${MAGENTA}:: ${BOLD}Discord - это проприетарное кроссплатформенное универсальное приложение для голосового и текстового чата. ${NC}"
echo " 'Discord' - специально разработан для геймеров; однако у многих сообществ с открытым исходным кодом также есть официальные серверы Discord. https://discord.com/open-source " 
echo -e "${MAGENTA}=> ${NC}Discord можно использовать через веб-браузер или настольное приложение, созданное с помощью Electron. https://github.com/electron/electron"
echo -e "${YELLOW}:: Примечание!${NC}Вы можете самостоятельно установить discord на arch linux. Загрузите файл discard с расширением .tar.gz с официального сайта (https://discord.com/download). Затем извлеките его с помощью tar-xvzf filename. Далее измените свой каталог на вновь извлеченный каталог и сделайте имя файла Discord исполняемым с помощью команды chmod +x Discord. Наконец, выполните команду ./Discord, чтобы запустить discord."
echo " Ссылка на видео: - https://www.youtube.com/watch?v=bbVbFWVsbWQ&t=0s (Install discord on manjaro or arch linux) "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_discord  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_discord" =~ [^10] ]]
do
    :
done 
if [[ $i_discord == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_discord == 1 ]]; then
  echo ""  
  echo " Установка Discord "
sudo pacman -S discord --noconfirm  # Единый голосовой и текстовый чат для геймеров
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
echo -e "${BLUE}:: ${NC}Установить CherryTree (создания иерархических заметок)?" 
echo -e "${MAGENTA}:: ${BOLD}CherryTree - это удобное и очень быстрое приложение для записи коротких заметок, позволяющее иерархически структурировать всю нужную информацию в наглядном виде. ${NC}"
echo -e "${MAGENTA}=> ${NC}CherryTree может выступать в качестве текстового редактора, позволяя вставлять в текст таблицы, изображения, ссылки и другие элементы. Поддерживает подсветку синтаксиса."
echo " Интерфейс CherryTree очень простой, красивый и удобный, что сразу же располагает пользователя, после установки. Многоуровневая структура, поддержка ссылок, тегов и другое ..." 
echo -e "${YELLOW}:: Примечание!${NC}Вы можете самостоятельно установить (пакет) cherrytree-bin (https://aur.archlinux.org/packages/cherrytree-bin/), или (пакет) cherrytree-git (https://aur.archlinux.org/packages/cherrytree-bin/), если Вам нужна версия из исходников. Так же эти версии (пакетов) будут представлены в следующем скрипте (archmy4l)."
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_cherrytree  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_cherrytree" =~ [^10] ]]
do
    :
done 
if [[ $i_cherrytree == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_cherrytree == 1 ]]; then
  echo ""  
  echo " Установка CherryTree "
sudo pacman -S cherrytree --noconfirm  # Приложение для создания иерархических заметок  
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
# -----------------------------------
# Ссылки: 
# https://github.com/giuspen/cherrytree
# https://www.giuspen.com/cherrytree/
# cherrytree-bin - https://aur.archlinux.org/packages/cherrytree-bin/
# cherrytree-git - https://aur.archlinux.org/packages/cherrytree-git/
#------------------------------------

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
echo -e "${BLUE}:: ${NC}Установить KeePassXC (для хранения паролей)?" 
echo -e "${MAGENTA}:: ${BOLD}KeePassXC - простой в использовании менеджер паролей для Windows, Linux, Mac OS X и мобильных устройств. ${NC}"
echo " KeePassXC - является форком еще одного менеджера паролей KeePassX, преимущество KeePassXC заключается в его развитии, а точней в его разработке. " 
echo " На сегодняшний день, осмелюсь предположить, это лучший менеджер паролей, надежный и что не мало важно, с открытым исходным кодом. Поддерживает алгоритмы шифрования – AES, Twofish или ChaCha20, имеет совместимость с другими менеджерами паролей – KeePass2, KeePassX, KeeWeb. Имеет интеграцию с браузерами Google Chrome, Chromium, Mozilla Firefox. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_keepassxc  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_keepassxc" =~ [^10] ]]
do
    :
done 
if [[ $i_keepassxc == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_keepassxc == 1 ]]; then
  echo ""  
  echo " Установка KeePass "
sudo pacman -S keepassxc --noconfirm  # менеджер паролей
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
echo -e "${BLUE}:: ${NC}Установить Kleopatra (это графический интерфейс для GnuPG)?" 
echo -e "${CYAN}:: Предисловие!${NC}.С появлением библиотеки GCrypt-1.7.0 с поддержкой российской криптографии (ГОСТ 28147-89, ГОСТ Р 34.11-94/2012 и ГОСТ Р 34.10-2001/2012), стало возможным говорить о поддержке российского PKI в таких проектах как Kleopatra и KMail."
echo -e "${MAGENTA}:: ${BOLD}Kleopatra - это многофункциональное C++ / QT / KDE (kcmutils / kmime) графическое приложение позволяющее подписывать и шифровать файлы, а также обеспечивает создание, хранение и управление сертификатами и ключами шифрования. ${NC}"
echo -e "${MAGENTA}=> ${NC}Kleopatra разрабатывается как часть рабочего окружения KDE (KDE Applications / KDE Utilities), поддерживает управление сертификатами X.509 и OpenPGP в ключах шифрования GnuPG (GPG), основные возможности приложения реализованы на криптографической библиотеке libkleo (KDE PIM cryptographic library), использующей функционал GnuPG Made Easy (GPGME)."
echo " GPG / GnuPG (GNU Privacy Guard) - консольная утилита для шифрования информации и создания электронных цифровых подписей с помощью различных алгоритмов (RSA, DSA, AES и др...). Утилита создана как свободная альтернатива проприетарному PGP (Pretty Good Privacy) и полностью совместима с стандартом IETF OpenPGP (может взаимодействовать с PGP и другими OpenPGP-совместимыми системами). " 
echo -e "${YELLOW}:: Примечание!${NC}Для полноценной работы Kleopatra необходимо наличие хотя бы одной пары ключей, при первом запуске приложением автоматически сканируются каталоги в которых "по умолчанию" находятся ключи GPG (~/.gnupg и пр). Поддерживается импорт сертификатов из файлов множества наиболее распространённых форматов (*.acs, *.cer, *.crt, *.pem, *.pfx и др)."
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_kleopatra  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_kleopatra" =~ [^10] ]]
do
    :
done 
if [[ $i_kleopatra == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_kleopatra == 1 ]]; then
  echo ""  
  echo " Установка Kleopatra "
sudo pacman -S kleopatra --noconfirm  # Диспетчер сертификатов и унифицированный графический интерфейс криптографии  
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
# -----------------------------------
# Ссылки: 
# https://github.com/KDE/kleopatra
# https://zenway.ru/page/kleopatra
# https://habr.com/ru/post/316736/ (Сказание о Клеопатре и о российской криптографии)
# Шифрование с помощью GnuPG для пользователей:
# https://jenyay.net/blog/2012/01/04/shifrovanie-s-pomoshhyu-gnupg-dlya-polzovatelejj/
# https://ru.wikipedia.org/wiki/GnuPG
#------------------------------------

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
echo -e "${BLUE}:: ${NC}Установить Galculator (калькулятор)(на основе GTK+)(версия GTK2)(версия GTK3)?" 
echo -e "${MAGENTA}:: ${BOLD}Galculator - научный калькулятор для Linux. Galculator имеет три режима работы: (простой, научный и paper mode, в котором вычисления можно проводить путем ввода выражения в текстовое окно). ${NC}"
echo " Поддерживает десятичную, шестнадцатеричную, восьмеричную и двоичную системы счисления. Также поддерживаются разные угловые меры - градусы, радианы, грады. " 
echo -e "${CYAN}:: ${NC}В сценарии присутствуют две версии Galculator (калькулятора): galculator-gtk2 -- # Научный калькулятор на основе GTK + (версия GTK2), и galculator -- # Научный калькулятор на основе GTK + (версия GTK3) (Обратные конфликты: galculator-gtk2)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - galculator-gtk2 - на основе GTK + (версия GTK2),     2 - galculator - на основе GTK + (версия GTK3)     

    0 - НЕТ - Пропустить установку: " i_galculator  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_galculator" =~ [^120] ]]
do
    :
done 
if [[ $i_galculator == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_galculator == 1 ]]; then
  echo ""  
  echo " Установка Galculator-GTK2 (калькулятор) (на основе GTK+)(версия GTK2) " 
sudo pacman -S galculator-gtk2 --noconfirm  # Научный калькулятор на основе GTK + (версия GTK2)
echo ""   
echo " Установка утилит (пакетов) выполнена "
elif [[ $i_galculator == 2 ]]; then
  echo ""  
  echo " Установка Galculator (калькулятор) (на основе GTK+)(версия GTK3) " 
sudo pacman -S galculator --noconfirm  # Научный калькулятор на основе GTK + (версия GTK3) (Обратные конфликты: galculator-gtk2)
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
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (gnome-system-monitor, gnome-disk-utility, gnome-multi-writer, gpart, frei0r-plugins, fuseiso, clonezilla, crypto++, ddrescue, psensor, copyq, rsync, grsync, numlockx, modem-manager-gui, ranger, pacmanlogviewer, rofi, gsmartcontrol, testdisk, dmidecode, qemu, w3m)."
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
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
# sudo pacman -S gnome-system-monitor gnome-disk-utility gnome-multi-writer gpart frei0r-plugins clonezilla crypto++ ddrescue psensor copyq rsync grsync numlockx modem-manager-gui rofi gsmartcontrol ranger testdisk lsof dmidecode qemu w3m --noconfirm  
sudo pacman -S gnome-system-monitor --noconfirm  # Просмотр текущих процессов и мониторинг состояния системы
sudo pacman -S gnome-disk-utility --noconfirm  # Утилита управления дисками для GNOME
sudo pacman -S gnome-multi-writer --noconfirm  # Записать файл ISO на несколько USB-устройств одновременно
sudo pacman -S gpart --noconfirm  # Инструмент для спасения / угадывания таблицы разделов
sudo pacman -S frei0r-plugins --noconfirm  # Минималистичный плагин API для видеоэффектов
sudo pacman -S fuseiso --noconfirm  # Модуль FUSE для монтирования образов файловой системы ISO
sudo pacman -S clonezilla --noconfirm  # Раздел ncurses и программа для создания образов / клонирования дисков
sudo pacman -S crypto++ --noconfirm  # Бесплатная библиотека классов C ++ криптографических схем
sudo pacman -S ddrescue --noconfirm  # Инструмент восстановления данных GNU
sudo pacman -S psensor --noconfirm  # Графический аппаратный монитор температуры для Linux
sudo pacman -S copyq --noconfirm  # Менеджер буфера обмена с возможностью поиска и редактирования истории
sudo pacman -S rsync --noconfirm  # Быстрый и универсальный инструмент для копирования удаленных и локальных файлов
sudo pacman -S grsync --noconfirm  # GTK + GUI для rsync для синхронизации папок, файлов и создания резервных копий
sudo pacman -S numlockx --noconfirm  # Включает клавишу numlock в X11
sudo pacman -S modem-manager-gui --noconfirm  # Интерфейс для демона ModemManager, способного управлять определенными функциями модема
sudo pacman -S pacmanlogviewer --noconfirm  # Проверьте файлы журнала pacman
sudo pacman -S rofi --noconfirm  # Переключатель окон, средство запуска приложений и замена dmenu
sudo pacman -S gsmartcontrol --noconfirm  # Графический пользовательский интерфейс для инструмента проверки состояния жесткого диска smartctl
sudo pacman -S ranger --noconfirm  # Простой файловый менеджер в стиле vim
sudo pacman -S testdisk --noconfirm  # Проверяет и восстанавливает разделы + PhotoRec, инструмент восстановления на основе сигнатур
sudo pacman -S dmidecode --noconfirm  # Утилиты, относящиеся к таблице интерфейса управления рабочим столом
sudo pacman -S qemu --noconfirm  # Универсальный компьютерный эмулятор и виртуализатор с открытым исходным кодом
sudo pacman -S w3m --noconfirm  # Текстовый веб-браузер, а также пейджер
# sudo pacman -S  --noconfirm  # 
# sudo pacman -S  --noconfirm  #
# sudo pacman -S  --noconfirm  #
# sudo pacman -S  --noconfirm  #
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${BOLD}Установить дополнительные сетевые утилиты, драйверы? ${NC}"
#echo -e "${BLUE}:: ${NC}Установить дополнительные сетевые утилиты, драйверы?"
#echo 'Установить дополнительные сетевые утилиты, драйверы
# Install additional network utilities, drivers
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (broadcom-wl-dkms, iwd, linux-atm, ndisc6, networkmanager-l2tp, pptpclient, rp-pppoe, wvdial, xl2tpd)."
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo -e "${YELLOW}==> ${NC}Установка будет производится сразу всех утилит (пакетов) - (без выбора)" 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " net_utilities  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$net_utilities" =~ [^10] ]]
do
    :
done 
if [[ $net_utilities == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $net_utilities == 1 ]]; then
  echo ""   
  echo " Установка рекомендованных утилит (пакетов) "
# sudo pacman -S broadcom-wl-dkms iwd linux-atm ndisc6 networkmanager-l2tp pptpclient rp-pppoe wvdial xl2tpd --noconfirm  
sudo pacman -S broadcom-wl-dkms --noconfirm  # Драйвер беспроводной сети Broadcom 802.11 Linux STA
sudo pacman -S iwd --noconfirm  # Демон беспроводной сети Интернет
sudo pacman -S linux-atm --noconfirm  # Драйверы и инструменты для поддержки сети банкоматов под Linux
sudo pacman -S ndisc6 --noconfirm  # Сборник сетевых утилит IPv6
sudo pacman -S xl2tpd --noconfirm  # Реализация L2TP с открытым исходным кодом, поддерживаемая Xelerance Corporation
sudo pacman -S networkmanager-l2tp --noconfirm  # Поддержка L2TP для NetworkManager
sudo pacman -S pptpclient --noconfirm  # Клиент для проприетарного протокола туннелирования точка-точка от Microsoft, PPTP
sudo pacman -S rp-pppoe --noconfirm  # Протокол точка-точка Roaring Penguin через клиент Ethernet
sudo pacman -S wvdial --noconfirm  # Программа номеронабирателя для подключения к Интернету
# sudo pacman -S  --noconfirm  # 
# sudo pacman -S  --noconfirm  # 
# sudo pacman -S  --noconfirm  #
# sudo pacman -S  --noconfirm  #
# sudo pacman -S  --noconfirm  #
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
echo -e "${MAGENTA}:: ${BOLD}Flatpak - это система для создания, распространения и запуска изолированных настольных приложений в Linux. Основной репозиторий flatpak flathub.org/apps. ${NC}"
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
#echo ""   
#echo " Добавление репозитория flathub "
#flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# Удаление репозитория на примере flathub:
# flatpak remote-delete flathub
# flatpak update  # Обновление flatpak
clear
echo ""
echo " Установка приложение Flatpak выполнена "
echo ""
echo -e "${BLUE}:: ${NC}Установить приложение для управления вашими Flatpaks (флэтпаками)?"
echo " Discover - Один из способов управления вашими Флэтпаками, есть ещё Gnome Software из проекта 'Gnome Project'. "
echo " Меннеджер пакетов Gnome Software, хорошо использовать в связке с flatpak. "
echo " Gnome Software - ПОДТЯГИВАЕТ МНОГО ЗАВИСИМОСТЕЙ! "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Установить Discover (из проекта KDE),     2 - Установить Gnome Software (из Gnome Project),      

    0 - НЕТ - Пропустить установку: " i_discover  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_discover" =~ [^120] ]]
do
    :
done 
if [[ $i_discover == 0 ]]; then 
echo ""   
echo " Установка приложения для управления вашими Flatpaks пропущена "
elif [[ $i_discover == 1 ]]; then
  echo ""    
  echo " Установка Discover (для управления вашими Flatpaks) "
sudo pacman -S discover --noconfirm  # Графический интерфейс управления ресурсами KDE и Plasma
echo ""
echo " Установка приложение Discover (из проекта KDE) выполнена "
elif [[ $i_discover == 2 ]]; then
  echo ""    
  echo " Установка Gnome Software (для управления вашими Flatpaks) "
sudo pacman -S gnome-software --noconfirm  # Программные инструменты GNOME - ПОДТЯГИВАЕТ МНОГО ЗАВИСИМОСТЕЙ!
sudo pacman -S gnome-software-packagekit-plugin --noconfirm  # Плагин поддержки PackageKit для программного обеспечения GNOME 
echo ""
echo " Установка приложение Gnome Software (из Gnome Project) выполнена "
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
# --------------------------------------
# Основной репозиторий flatpak flathub.org/apps.
# Добавление репозитория на примере flathub:
# flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# Удаление репозитория на примере flathub:
#flatpak remote-delete flathub
# Обновление flatpak:
# flatpak update
# Поиск:
# flatpak search libreoffice
# Список пакетов в репозитории flathub:
# flatpak remote-ls flathub
# Установка пакета в домашнюю дерикторию.
# flatpak install flathub com.valvesoftware.Steam
# Запуск:
# flatpak run com.valvesoftware.Steam
# Список установленых пакетов:
# flatpak list
# Обновление пакета:
# flatpak update com.valvesoftware.Steam
# Обновление пакетов:
# flatpak update
# Удаление пакета:
# flatpak uninstall com.valvesoftware.Steam
# После удаления приложения могут оставаться неиспользуемые рантаймы, очистим и их.
# flatpak uninstall --unused
# Дополнительный репозиторий Winepak (игры, WoT и др.).
# https://winepak.org.
# https://github.com/winepak/applications.
# ------------------------------
# Показанные инструкции могут не работать:
# flatpak remote-add flathub https://flathub.org/repo/flathub.flatpakrepo
# flatpak --user install flathub org.gnome.Recipes
# если выдает ошибку "удаленный flathub не найден"
# вместо этого вам нужно либо установить пульт с --user, либо установить приложение flatpak без --user
#Просто:
# flatpak install flathub org.gnome.Recipes
# запустите flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepoв терминале, и все должно работать, что позволит вам установить fltpaks из flathub
# Вы можете сделать это вручную с помощью:
# remote-add --user
# sudo flatpak удаленно удалить flathub
# sudo flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# https://www.flathub.org/home
# =============================

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
#echo -e " Установка базовых программ и пакетов wget, curl, git "
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

######### Drivers ##############
clear
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
#lspci -k | grep -A 2 -E "(VGA|3D)"  # Узнать информацию о видео карте
lspci -nn | grep VGA
#lspci | grep VGA        # узнаем ID шины 
# После того как вы узнаете PCI-порт видеокарты, например 1с:00.0, можно получить о ней более подробную информацию:
# sudo lspci -v -s 1с:00.0
# Она покажет, какая видеокарта используется:
#grep -Eiwo -m1 'nvidia|amd|ati|intel' /var/log/Xorg.0.log
echo -e "${YELLOW}==> Примечание: ${NC}Для установки библиотек (некоторых) драйверов видеокарт, нужен репозиторий [multilib], надеюсь Вы добавили репозиторий "Multilib" (при установке основной системы)."
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo " 1 - NVIDIA - Если видео карта от Nvidia ставим драйвер (проприетарный по желанию), то выбирайте вариант - "1" "
echo " 2 - AMD/(ATI) - Если видео карта от Amd ставим драйвер (свободный по желанию), то выбирайте вариант - "2" "
echo " 3 - Intel - Если видео карта от Intel ставим драйвер (свободный по желанию), то выбирайте вариант - "3" "
echo " 4 - Intel, AMD/(ATI), NVIDIA и дополнительные инструменты - Если у Вас система Archlinux установлена на внешний накопитель, или USB(флешку), то ЖЕЛАТЕЛЬНО установить все предложенные (свободные и проприетарные) драйвера для видеокарт, выбирайте вариант - "4" "
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
sudo pacman -S nvidia nvidia-settings nvidia-utils lib32-nvidia-utils --noconfirm  # Драйверы NVIDIA для linux
sudo pacman -S libvdpau lib32-libvdpau --noconfirm   # Библиотека Nvidia VDPAU
sudo pacman -S opencl-nvidia opencl-headers lib32-opencl-nvidia --noconfirm  # Реализация OpenCL для NVIDIA; Файлы заголовков OpenCL (Open Computing Language); Реализация OpenCL для NVIDIA (32-бит) 
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
sudo pacman -S nvidia nvidia-settings nvidia-utils lib32-nvidia-utils --noconfirm  # Драйверы NVIDIA для linux
sudo pacman -S libvdpau lib32-libvdpau --noconfirm   # Библиотека Nvidia VDPAU
sudo pacman -S opencl-nvidia opencl-headers lib32-opencl-nvidia --noconfirm  # Реализация OpenCL для NVIDIA; Файлы заголовков OpenCL (Open Computing Language); Реализация OpenCL для NVIDIA (32-бит) 
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
sudo pacman -S ipw2100-fw --noconfirm  # Микропрограмма драйверов Intel Centrino для IPW2100
sudo pacman -S ipw2200-fw --noconfirm  # Прошивка для Intel PRO / Wireless 2200BG
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
sudo pacman -S splix --noconfirm  # Драйверы CUPS для принтеров SPL (Samsung Printer Language)
sudo pacman -S hplip --noconfirm  # Драйверы для HP DeskJet, OfficeJet, Photosmart, Business Inkjet и некоторых LaserJet  
# Рабочая группа Foomatic в OpenPrinting в Linux Foundation предоставляет PPD для многих драйверов принтеров
sudo pacman -S foomatic-db --noconfirm  # Foomatic - собранная информация о принтерах, драйверах и параметрах драйверов в файлах XML, используемая foomatic-db-engine для создания файлов PPD.
sudo pacman -S foomatic-db-engine --noconfirm  # Foomatic - движок базы данных Foomatic генерирует файлы PPD из данных в базе данных Foomatic XML. Он также содержит сценарии для непосредственного создания очередей печати и обработки заданий.
sudo pacman -S foomatic-db-ppds --noconfirm  # Foomatic - PPD от производителей принтеров
sudo pacman -S foomatic-db-nonfree --noconfirm  # Foomatic - расширение базы данных, состоящее из предоставленных производителем файлов PPD, выпущенных по несвободным лицензиям
sudo pacman -S foomatic-db-nonfree-ppds --noconfirm  # Foomatic - бесплатные PPD от производителей принтеров
sudo pacman -S foomatic-db-gutenprint-ppds --noconfirm  # Упрощенные готовые файлы PPD 
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
echo -e "${MAGENTA}
<<< Установка утилиты для создания backup - (резервное копирование) системы Archlinux >>> ${NC}"
# Installing the utility for creating a backup - (backup) Archlinux system

echo ""
echo -e "${GREEN}==> ${NC}Установить Timeshift (пакет timeshift) для резервного копирования Archlinux?"
# Install Timeshift (timeshift package) for Archlinux backup?
echo -e "${MAGENTA}=> ${BOLD}Timeshift - это утилита для создавать резервные копии вашей системы, с возможностью инкрементного резервного копирования. ${NC}"
echo -e "${YELLOW}:: ${NC}Инкрементное копирование - это метод копирования, при котором к исходной копии набора данных шаг за шагом приписываются дополнения, отражающие изменения в данных (эти пошаговые изменения в наборе данных и называются инкрементами)."
echo " Это означает что первый снимок делается 'долго' - так как копируется все файлы, но вот последующие бэкапы делаются уже какие-то секунды из-за того что программа сравнивает предыдущий бэкап и записывает только изменения. Хотя по сути она копирует старый снимок и записывает новый с изменениями это делается 'моментально'. "
echo -e "${CYAN}:: ${NC}Сама утилита проста в использовании и может работать по расписанию. В первую очередь данная утилита может понадобится тем, кто экспериментирует с настройками системы. Да и в общем, всегда приятно иметь работоспособную копию, на всякий пожарный как говорится."
echo " Работать Timeshift может в двух режимах, это BTRFS и RSYNC. Первый режим работает благодаря файловой системе BTRFS и создаются снимки системы с использованием встроенных функций самой BTRFS. А второй режим RSYNC создает снимки с использованием функции rsync. "
echo -e "${CYAN}:: ${NC}Установка timeshift проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/timeshift.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/timeshift/), собирается и устанавливается."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_timeshift  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_timeshift" =~ [^10] ]]
do
    :
done
if [[ $i_timeshift == 0 ]]; then
echo ""  
echo " Установка Timeshift пропущена "
elif [[ $i_timeshift == 1 ]]; then
  echo ""
  echo " Установка Timeshift (Утилита восстановления системы для Linux) "
##### timeshift ###### 
# yay -S timeshift --noconfirm  # Утилита восстановления системы для Linux
git clone https://aur.archlinux.org/timeshift.git  
cd timeshift
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf timeshift
rm -Rf timeshift   # удаляем директорию сборки
echo ""
echo " Сборка и установка Timeshift выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
sleep 02

clear
echo -e "${MAGENTA}
  <<< Установка дополнительного программного обеспечения (пакетов) для повышения безопасности и конфиденциальности в Archlinux >>> ${NC}"
# Installing additional software (packages) to improve security and privacy in Archlinux

echo ""
echo -e "${GREEN}==> ${NC}Установка hBlock из AUR (повысьте свою безопасность и конфиденциальность, заблокировав рекламу, отслеживание и вредоносные домены)"
#echo -e "${BLUE}:: ${NC}Установка hBlock (повысьте свою безопасность и конфиденциальность, заблокировав рекламу, отслеживание и вредоносные домены)" 
#echo 'Установка hBlock'
# Installing h Block (increase your security and privacy by blocking ads, tracking, and malicious domains)
echo -e "${MAGENTA}=> ${BOLD}hBlock - это POSIX-совместимый сценарий оболочки, который получает список доменов, которые обслуживают рекламу, сценарии отслеживания и вредоносное ПО из нескольких источников, и создает файл hosts, среди других форматов, который предотвращает подключение вашей системы к ним. ${NC}"
echo -e "${CYAN}:: ${NC}Установка hblock проходит через сборку из исходников AUR. То есть установка производиться с помощью git clone (https://aur.archlinux.org/hblock.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/hblock/), собирается и устанавливается."
echo -e "${MAGENTA}==> Примечание: ${NC}Желательно установить пакет (termite - https://www.archlinux.org/packages/community/x86_64/termite/ - Простой терминал на базе VTE), так как обновление списка доменов в файле hosts - проходит через терминал! hBlock доступен в различных менеджерах пакетов..."
echo -e "${YELLOW}==> Применение: ${BOLD}Поведение hBlock по умолчанию можно настроить с помощью нескольких параметров. Воспользуйтесь --help опцией или проверьте полный список в файле hblock.1.md - (при скачивании и установке с сайта https://github.com/hectorm/hblock). ${NC}"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_hblock  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_hblock" =~ [^10] ]]
do
    :
done
if [[ $i_hblock == 0 ]]; then
echo ""  
echo " Установка hBlock из AUR пропущена "
elif [[ $i_hblock == 1 ]]; then
##### hblock ######  
  echo ""
  echo " Создание backup файла /etc/hosts в директории исходника "
  echo " В дальнейшем Вы можете удалить файл hosts_orig.backup, от имени суперпользователя (root) без последствий! "
sudo cp -vf /etc/hosts /etc/hosts_orig.backup
echo " Установка hBlock из AUR "
# yay -S hblock --noconfirm  # Блокировщик рекламы, который создает файл hosts из автоматически загружаемых черных списков
git clone https://aur.archlinux.org/hblock.git   
cd hblock
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf hblock
rm -Rf hblock   # удаляем директорию сборки
echo ""   
echo " Установка утилит (пакетов) выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
# ------------------------------
# Отключаем IPv6
# Для этого создадим новый файл /etc/sysctl.d/10-ipv6.conf с содержимым:
# net.ipv6.conf.all.disable_ipv6 = 1
# ===============================

clear
echo -e "${MAGENTA}
  <<< Установка дополнительного программного обеспечения (пакетов) для обновления личных данных пользователя в Archlinux >>> ${NC}"
# Installing additional software (packages) for updating the user's personal data in Archlinux

echo ""
echo -e "${GREEN}==> ${NC}Установка Mugshot из AUR (настройка личных данных пользователя)"
#echo -e "${BLUE}:: ${NC}Установка Mugshot из AUR (настройка личных данных пользователя)" 
#echo 'Установка Mugshot из AUR (настройка личных данных пользователя)'
# Installing Mugshot from AUR (configuring user's personal data)
echo -e "${MAGENTA}=> ${BOLD}Mugshot - это облегченная утилита настройки пользователя для Linux, разработанная для простоты и легкости использования. Быстро обновляйте свой личный профиль и синхронизируйте обновления между приложениями. ${NC}"
echo -e "${MAGENTA}==> Примечание: ${NC}В обновляемую информацию личного профиля входят: - Изображение профиля Linux: ~ / .face и AccountService; Данные пользователя хранятся в / etc / passwd (используется finger и другими настольными приложениями); (Необязательно) Синхронизация изображение своего профиля со значком Pidgin; (Необязательно) Синхронизация данных пользователя с LibreOffice и т.д..."
echo -e "${CYAN}:: ${NC}Установка mugshot проходит через сборку из исходников AUR. То есть установка производиться с помощью git clone (https://aur.archlinux.org/mugshot.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/mugshot), собирается и устанавливается."
echo -e "${YELLOW}==> Примечание: ${BOLD}Если вы используете рабочее окружение Xfce, то желательно установить пакет (xfce4-whiskermenu-plugin - Меню для Xfce4 - https://www.archlinux.org/packages/community/x86_64/xfce4-whiskermenu-plugin/, если таковой не был установлен изначально). ${NC}"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_mugshot  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_mugshot" =~ [^10] ]]
do
    :
done
if [[ $i_mugshot == 0 ]]; then
echo ""  
echo " Установка Mugshot из AUR пропущена "
elif [[ $i_mugshot == 1 ]]; then
##### mugshot ######  
  echo ""
  echo " Установка Mugshot из AUR (для настройки личных данных пользователя) "
# sudo pacman -S xfce4-whiskermenu-plugin --noconfirm  # Меню для Xfce4
# yay -S mugshot --noconfirm  # Программа для обновления личных данных пользователя
git clone https://aur.archlinux.org/mugshot.git   
cd mugshot
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf mugshot
rm -Rf mugshot   # удаляем директорию сборки
echo ""   
echo " Установка утилит (пакетов) выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi

clear
echo -e "${MAGENTA}
<<< Установка дополнительного программного обеспечения для создания, изменения - пакетов, и дальнейшей установке их в  систему Archlinux >>> ${NC}"
# Installing additional software to create, modify, and install packages in the Archlinux system

echo ""
echo -e "${GREEN}==> ${NC}Установить Debtap для элементарной (базовой) конвертации (преобразования) *.deb пакетов в *.pkg.tar.xz(-any.pkg.tar.zst), и дальнейшей установке в Archlinux?"
# Install Deb tar to convert *. deb packages to *.pkg.tar.xz(-any.pkg.tar.zcf), and then install them in the system?
echo -e "${MAGENTA}=> ${BOLD}Debtap - это Скрипт для преобразования пакетов .deb в пакеты Arch Linux, ориентированный на точность. Не используйте его для преобразования пакетов, которые уже существуют в официальных репозиториях (Arch Based Distribution), или могут быть собраны из AUR! (https://github.com/helixarch/debtap) ${NC}"
echo -e "${CYAN}:: ${NC}Он работает аналогично с alien (который конвертирует пакеты .deb в пакеты .rpm и наоборот), но, в отличие от alien, он ориентирован на точность преобразования, пытаясь перевести имена пакетов Debian / Ubuntu в правильные пакеты Arch Linux, и сохранить их в полях зависимостей метаданных .PKGINFO в окончательном пакете..."
echo -e "${CYAN}:: ${NC}Установка debtap проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/debtap.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/debtap), собирается и устанавливается."
echo -e "${YELLOW}=> Важно: ${NC}Перед установкой (преобразованных) пакетов - ВЫПОЛНИТЕ резервное копирование пользовательских данных /пространства (разделов системы)-(возможность повреждения вашей системы)!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_deb  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_deb" =~ [^10] ]]
do
    :
done
if [[ $i_deb == 0 ]]; then
echo ""  
echo " Установка debtap (преобразование пакетов .deb) пропущена "
elif [[ $i_deb == 1 ]]; then
  echo ""
  echo " Установка скрипта debtap (для преобразования пакетов .deb) "
##### debtap ###### 
# yay -S debtap --noconfirm  # Сценарий для преобразования пакетов .deb в пакеты Arch Linux, ориентированный на точность. Не используйте его для преобразования пакетов, которые уже существуют в официальных репозиториях или могут быть собраны из AUR!
git clone https://aur.archlinux.org/debtap.git  
cd debtap
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf debtap
rm -Rf debtap   # удаляем директорию сборки
echo ""
echo -e "${CYAN} Настройка перед использованием: ${NC}(Вы делаете это с привилегиями root)"
# echo " Настройка перед использованием: (Вы делаете это с привилегиями root) "
echo " Выполняется синхронизация репозиториев Arch'a (обновим pkgfile и базу данных debtap), и доустановка недостающих компонентов (деталей) "
sudo debtap -u
# sudo debtap -U  # сделаем первый запуск скрипта
echo ""
echo " Сборка и установка debtap выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
sleep 02
# ---------------------------
# Доступные параметры debtap:
#    -h --help Распечатать справку
#    -u --update Обновить базу данных долгового соглашения
#    -q --quiet Пропустить все вопросы, кроме редактирования файла (ов) метаданных
#    -Q --Quiet Пропустить все вопросы (не рекомендуется)
#    -s - -pseudo Создать псевдо-64-битный пакет из 32-битного пакета .deb
#    -w --wipeout Удалить версии из всех зависимостей, конфликтов и т. д.
#    -p --pkgbuild Дополнительно создать файл PKGBUILD
#    -P --Pkgbuild Создать PKGBUILD только файл
#    -v --version Версия для печати
# -----------------------------
# Команда по работе со скриптом debtap
# Конвертировать .deb пакеты:
# debtap (имя пакета).deb  # debtap package_name.deb
# Утилита задает вопрос о желаемом имени пакета, о его лицензии. Дальше распакует пакет, соберет информацию, сформирует структуру и предложит внести правки в PKGINFO и INSTALL, от чего можно и отказаться. После этого будет сгенерирован пакет для арча, который ставится обычным образом.
# Посмотрим на файлы, что лежат в папке сборки: 
# ls
# Установка программы (пакета):
# sudo pacman -U (имя пакета).pkg.tar.xz  # sudo pacman -U package_name.pkg
# Не рекомендуется (возможно, опасно)
# Этот метод пытается установить пакет, используя формат упаковки debian на Arch, который не рекомендуется из-за возможной опасности повреждения вашей установки!
# --------------------------------

clear
echo -e "${MAGENTA}
<<< Установка дополнительного программного обеспечения для исправления отображения миниатюр в файловом менеджере системы Archlinux >>> ${NC}"
# Installing additional software to fix thumbnail display in the Archlinux file Manager

echo ""
echo -e "${BLUE}:: ${NC}Исправим отображение миниатюр в файловом менеджере Thunar?"
# Fix Thumbnails in file manager
echo -e "${MAGENTA}=> ${BOLD}Thunar - обычно автоматически создает миниатюрные изображения всех изображений в просматриваемой директории. Но бывает, что в Arch Linux - Thunar иногда не показывает некоторые миниатюры. Все файлы изображений получают один и тот же общий значок изображения. ${NC}"
echo -e "${YELLOW}:: ${NC}Файловый менеджер thunar идет по умолчанию в графической оболочке xfce. Сам по себе thunar не содержит в себе лишних функций, которые могут запутать не опытного пользователя. Да и не всем нужен излишний функционал. Кастомизируется thunar очень легко, по этому у вас не должно возникнуть с этим проблем."
echo -e "${CYAN}:: ${NC}Нам - Потребуется доустановить дополнительные пакеты, и возможно надо включить показ миниатюр в настройках Thunar'а (или, может, в настройках Xfce)."
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
sudo pacman -S shared-mime-info --noconfirm  # Общая информация MIME на Freedesktop.org
sudo pacman -S raw-thumbnailer --noconfirm  # Легкий и быстрый инструмент для создания необработанных изображений raw, который необходим для отображения миниатюр raw.
sudo pacman -S perl-file-mimeinfo --noconfirm  # Определить тип файла, включая mimeopen и mimetype
############ gstreamer0.10 ##########
echo "" 
echo " Установим мультимедийный фреймворк GStreamer из AUR "
#yay -S gstreamer0.10 --noconfirm  # Мультимедийный фреймворк GStreamer (Если установлен yay - эта команда)
git clone https://aur.archlinux.org/gstreamer0.10.git 
cd gstreamer0.10
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gstreamer0.10 
rm -Rf gstreamer0.10
#######################
echo "" 
echo " Установим Панель задач Docklike для XFCE из AUR "
echo " Современная, похожая на док-станцию, минималистская панель задач для XFCE "
#yay -S xfce4-docklike-plugin-git --noconfirm  # Панель задач Docklike (Если установлен yay - эта команда)
git clone https://aur.archlinux.org/xfce4-docklike-plugin-git.git  
cd xfce4-docklike-plugin-git
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf xfce4-docklike-plugin-git 
rm -Rf xfce4-docklike-plugin-git
#######################
echo ""
#mv ~/.cache/thumbnails ~/.cache/thumbnails.bak
# cp -R ~/.cache/thumbnails ~/.cache/thumbnails.bak 
#echo " Удалим миниатюры фото, которые накапились в системе "
### thunar -q  # запустим менеджер thunar
### killall thunar  # завершим работу менеджера thunar 
#sudo rm -rf ~/.cache/thumbnails/  # удаляет миниатюры фото, которые накапливаются в системе
#sudo rm -rf ~/.cache/thumbnails/*
echo " Создадим backup папки /.config/Thunar "
sudo mv ~/.config/Thunar ~/.config/Thunar.bak
# mv ~/.config/Thunar ~/.config/Thunar.bak
echo " Выполним резервное копирование каталога /usr/share/mime, на всякий случай "
sudo cp -R /usr/share/mime /usr/share/mime_back
#cp -R /usr/share/mime /usr/share/mime_back
#echo " Удалить все файлы .xml на /usr/share/mime, затем запустим команду обновления "
#find  /usr/share/mime -name *.xml -exec rm -rfv {} +  # 
echo " Обновление общего кэша информации mime в соответствии с системой "
sudo update-mime-database /usr/share/mime
echo " Желательно ПОСЛЕ этих действий выйдите из системы и снова войдите в систему, или перезагрузитесь "  # Then logout and back in or Reboot
echo " Но, мы просто перезапустим файловый менеджер Thunar "
thunar -q # запустим менеджер thunar
echo ""
echo " Проверяем дефолтные настройки миниатюр (xdg-mime query default) "
xdg-mime query default inode/directory
echo " Переопределяем на файловый менеджер Thunar "
xdg-mime default thunar.desktop inode/directory
# Чтобы открыть каталог и выбрать подкаталог / файл в thunar:
# thunar --select path/to/file/or/directory
### xdg-mime default org.gnome.Nautilus.desktop inode/directory  # или Nautilus
# Чтобы открыть каталог и выбрать подкаталог / файл в наутилусе:
### nautilus --select path/to/file/or/directory
echo " Расширяем контекстное меню Thunar (Добавляем дополнительные пункты для создания файлов) "
XDG_TEMPLATES_DIR=$(xdg-user-dir TEMPLATES)
cd "$XDG_TEMPLATES_DIR"
touch 'New Text File.txt' && touch 'New Word File.doc' && touch 'New Excel Spreadsheet.xls'
touch 'New HTML File.html' && touch 'New XML File.xml' && touch 'New PHP Source File.php'
touch 'New File Block Diagram.odg' && touch 'New Casscading Style Sheet.css' && touch 'New Java Source File.java'
touch 'New ODB DataBase.odb' && touch 'New ODT File.odt' && touch 'New Table ODS.ods' && touch 'New File Excel.et'
touch 'New File DPS Presentation.dps' && touch 'New File ODP Presentation.odp' && touch 'New File PowerPoint Presentation.ppt' 
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
fi
# ---------------------------------
# Затем, выставить в настройках Thunar галочку, предписывающую показывать миниатюры, если это возможно!
# Почистить cache:
# /home/user/.thumbnails
# /home/user/.cache/Thunar
# update-mime-database  # программа для построения кэша Shared MIME-Info базы данных
# Это программа, которая отвечает за обновление общего кэша информации mime в соответствии с системой, описанной в спецификации Shared MIME-Info Database от X Desktop Group
#/usr/share/mime  # файл конфигурации MIME-типов
# ----------------------------
# https://wiki.archlinux.org/index.php/Thunar_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# https://www.opennet.ru/man.shtml?topic=update-mime-database&category=1&russian=2
# https://unix.stackexchange.com/questions/364997/open-a-directory-in-the-default-file-manager-and-select-a-file
# https://specifications.freedesktop.org/mime-apps-spec/mime-apps-spec-1.0.1.html
# ----------------------------------
# Запросы
# xdg-mime query filetype <filename> позволяет узнать mime-тип файла.
# xdg-mime query default <mime-type> – узнать приложение по умолчанию для открытия данного mime-типа.
# Установка умолчаний
# xdg-mime default <desktop-file-name> <mime-type>... позволяет установить приложение <desktop-file-name> по умолчанию для открытия одного или нескольких mime-типов. <desktop-file-name> – это название desktop-файла, который будет использован (без пути, с расширением)
# Например:
# xdg-mime default okular.desktop image/jpeg image/png
# В случае, если возможно установить окружение рабочего стола, для этого будут использованы средства окружения. Иначе, будут добавлены записи в файл mimeapps.list (первый найденный) в секцию Default Applications.
# РЕКОМЕНДАЦИИ
# Всегда устанавливайте переменную BROWSER. Если она не установлена, можно ждать неожиданностей. Можно указывать список, разделённый двоеточием :.
# Используйте xdg-mime default для установки приложений по умолчанию. Если требуется посмотреть список умолчаний, можно посмотреть в файл mimeapps.list, однако редактировать его напрямую в общем случае не рекомендуется.
# https://wiki.archlinux.org/index.php/Default_applications_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# Общая база данных MIME-информации
# https://specifications.freedesktop.org/shared-mime-info-spec/shared-mime-info-spec-0.11.html#idm139839923550176
# Небольшая заметка про xdg-open
# https://livid.pp.ru/posts/2016-03-08-xdg-open.html
# ----------------------------
# Ассоциации файлов
# Это нужно, если у вас открывается файл, или каталог не в той программе. Например, директория в музыкальном проигрывателе.
# Распознаем файл:
### xdg-mime query filetype wallpaper.jpg  # определение типа MIME файла
### xdg-mime query filetype photo.jpeg  # определение типа MIME файла
# Определение приложения по умолчанию для типа MIME:
### xdg-mime query default image/jpeg
# Изменение приложения по умолчанию для типа MIME
### xdg-mime default feh.desktop image/jpeg
# Открытие файла со своим стандартным приложением:
### xdg-open photo.jpeg
# Ярлык для открытия всех веб типов MIME с помощью одного приложения
### xdg-settings set default-web-browser firefox.desktop
# Ярлык для установки приложения по умолчанию для схемы URL
### xdg-settings set default-url-scheme-handler irc xchat.desktop
# Еще пример:
### xdg-mime default vlc.desktop video/mp4
# Нестандартная ассоциация:
# Приложения могут игнорировать или частично реализовывать стандарт XDG. Проверьте использование устаревших файлов, таких как ~/.local/share/applications/mimeapps.list и ~/.local/share/applications/defaults.list. Если вы пытаетесь открыть файл из другого приложения (например, веб-браузера или файлового менеджера), проверьте, имеет ли это приложение собственный способ выбора приложений по умолчанию.
# База данных MIME
# Система поддерживает базу данных распознанных типов MIME: Общая база данных MIME. База данных построена из файлов XML, установленных пакетами в /usr/share/mime/packages, используя инструменты из shared-mime-info.
# Файлы в /usr/share/mime/ не должны редактироваться напрямую, однако их можно сохранить в отдельную базу данных для каждого пользователя в ~/.local/share/mime/.
# Default applications (Русский)
# https://wiki.archlinux.org/index.php/Default_applications_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# ----------------------------------

clear
echo -e "${MAGENTA}
  <<< Установка Редактора меню программ (пакетов) в Archlinux >>> ${NC}"
# Installing the program (package) menu Editor in Archlinux

echo ""
echo -e "${GREEN}==> ${NC}Установить редактор главного меню программ (пакетов)?"
#echo -e "${BLUE}:: ${NC}Установить редактор меню программ (пакетов)?"
#echo 'Установить редактор меню программ (пакетов)?'
# Install the program (package) menu editor?
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo -e "${MAGENTA}:: ${NC}1 - MenuLibre - удобный инструмент, Python / GTK графическая утилита для редактирования меню приложений в графических рабочих окружениях Gnome, LXDE, XFCE и Unity, предоставляя несколько дополнительных возможностей не имеющихся в стандартных для окружений "Редакторах меню" (те которые их имеют и сторонних)."
echo " MenuLibre в удобном и интуитивно понятном пользовательском интерфейсе создавать/изменять/удалять пункты меню, изменять категории приложений, просматривать/изменять команды запуска, менять описание и др... "
echo -e "${CYAN}:: ${NC}Установка menulibre проходит через сборку из исходников AUR. То есть установка производиться с помощью git clone (https://aur.archlinux.org/menulibre.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/menulibre/), собирается и устанавливается."
echo -e "${MAGENTA}:: ${NC}2 - Alacarte - (https://www.archlinux.org/packages/extra/any/alacarte/) простой в использовании редактор меню, написанный на основе технологии GNOME, позволяющий добавлять новые и изменять существующие подменю и их элементы."
echo " Он создан в соответствии со спецификацией freedesktop.org и должен работать в любой графической среде, поддерживающей эту спецификацию. (https://gitlab.gnome.org/GNOME/alacarte) "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Установить редактора меню - MenuLibre,     2 - Установить редактора меню - Alacarte,     

    0 - НЕТ - Пропустить установку: " in_menu  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_menu" =~ [^120] ]]
do
    :
done 
if [[ $in_menu == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_menu == 1 ]]; then
  echo ""  
  echo " Установка Редактора меню - MenuLibre "
##### menulibre ######   
# yay -S menulibre --noconfirm  # Расширенный редактор меню, который предоставляет современные функции в чистом, простом в использовании интерфейсе
git clone https://aur.archlinux.org/menulibre.git   
cd menulibre
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf menulibre
rm -Rf menulibre   # удаляем директорию сборки
echo ""   
echo " Установка утилит (пакетов) выполнена "
echo " Желательно перезагрузить систему для применения изменений "
elif [[ $in_menu == 2 ]]; then
  echo ""  
  echo " Установка Редактора меню - Alacarte "
sudo pacman -S alacarte --noconfirm  # Редактор меню для gnome
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

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
#sudo systemctl start ufw
echo " UFW (сетевой экран) успешно добавлен в автозагрузку "


fi

sleep 01
echo ""
echo -e "${BLUE}:: ${NC}Проверим статус запуска Firewall UFW (сетевой экран)" 
#echo 'Проверим статус запуска Firewall UFW (сетевой экран)'
# Check the startup status of Firewall UFW (network screen)
echo -e "${MAGENTA}:: ${BOLD}Если нужно ВЫКлючить UFW (сетевой экран), то используйте команду: sudo ufw disable. ${NC}"
echo -e "${CYAN}:: ${NC}Проверим статус UFW (сетевой экран), если таковой был вами установлен и запущен."
echo " Будьте внимательны! В данной опции выбор остаётся за вами. "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да проверить,     0 - НЕТ - Пропустить проверку: " i_status  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_status" =~ [^10] ]]
do
    :
done 
if [[ $i_status == 0 ]]; then 
echo ""   
echo " Проверка статуса UFW пропущена "
elif [[ $i_status == 1 ]]; then
  echo ""  
  echo " Проверим статус UFW (сетевой экран) "
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
# На сервере запустить и включить сервис в автостарт
# sudo systemctl start sshd
# sudo systemctl enable sshd
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

clear
echo -e "${CYAN}
  <<< Обновление информации о шрифтах и создание backup (резервной копии) файлов grub.cfg и grub >>> ${NC}"
# Updating font information and creating a backup of grub.cfg and grub files.

echo ""
echo -e "${BLUE}:: ${NC}Обновим информацию о шрифтах" 
#echo 'Обновим информацию о шрифтах'
# Update information about fonts
sudo fc-cache -f -v

clear
echo ""
echo -e "${BLUE}:: ${NC}Создать резервную копию (дубликат) файла grub.cfg?" 
#echo 'Создать резервную копию (дубликат) файла grub.cfg'
# Create a backup (duplicate) of the grub.cfg file
#sudo cp /boot/grub/grub.cfg grub.cfg.backup
echo -e "${CYAN}=> ${NC}Создаваемый дубликат файла grub.cfg будет находиться в директории исходника - путь - /boot/grub/grub.cfg.backup"
echo " В дальнейшем Вы можете удалить файл grub.cfg.backup, от имени суперпользователя (root) без последствий! "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Вы можете пропустить это действие..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да создать (резервную копию),     0 - Нет пропустить этот шаг: " t_grub_cfg  # sends right after the keypress; # отправляет сразу после нажатия клавиши     
    echo ''
    [[ "$t_grub_cfg" =~ [^10] ]]
do
    :
done
if [[ $t_grub_cfg == 0 ]]; then
echo ""
echo " Создание backup файла grub.cfg пропущено "      
elif [[ $t_grub_cfg == 1 ]]; then
  echo ""
  echo " Создание дубликата файла grub.cfg в директории исходника "
sudo cp -vf /boot/grub/grub.cfg /boot/grub/grub.cfg.backup
echo " Создание backup файла grub.cfg выполнено "
fi

echo ""
echo -e "${BLUE}:: ${NC}Создать резервную копию (дубликат) файла etc/default/grub?"
#echo 'Создать резервную копию (дубликат) файла etc/default/grub'
# Create a backup (duplicate) of the etc/default/grub file
#sudo cp /etc/default/grub grub.backup
echo -e "${CYAN}=> ${NC}Создаваемый дубликат файла grub будет находиться в директории исходника - путь - /etc/default/grub.backup"
echo " В дальнейшем Вы можете удалить файл grub.backup, от имени суперпользователя (root) без последствий! "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Вы можете пропустить это действие..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да создать (резервную копию),     0 - Нет пропустить этот шаг: " x_grub  # sends right after the keypress; # отправляет сразу после нажатия клавиши     
    echo ''
    [[ "$x_grub" =~ [^10] ]]
do
    :
done
if [[ $x_grub == 0 ]]; then
echo ""
echo " Создание backup файла grub пропущено "      
elif [[ $x_grub == 1 ]]; then
  echo ""
  echo " Создание дубликата файла grub в директории исходника "
sudo cp -vf /etc/default/grub /etc/default/grub.backup
echo " Создание backup файла grub выполнено "
fi

clear
echo -e "${CYAN}
  <<< Очистка кэша pacman, и Удаление всех пакетов-сирот (неиспользуемых зависимостей) >>> 
${NC}"
# Clearing the pacman cache, and Removing unused dependencies.
echo "" 
echo -e "${YELLOW}==> Примечание: ${NC}Если! Вы сейчас устанавливали "AUR Helper"-'yay' (не yay-bin), а также Snap (пакет snapd) вместе с ними установилась зависимость 'go' - (Основные инструменты компилятора для языка программирования Go), который весит 559,0 МБ. Так, что если вам не нужна зависимость 'go', для дальнейшей сборки пакетов в установленной системе СОВЕТУЮ удалить её. В случае, если "AUR"-'yay', Snap (пакет snapd) НЕ БЫЛИ установлены, или зависимость 'go' была удалена ранее, то пропустите этот шаг."
echo ""
echo -e "${BLUE}:: ${BOLD}Удаление зависимости 'go' после установки "AUR Helper"-'yay', Snap (пакет snapd). ${NC}"
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
echo -e "${BLUE}:: ${BOLD}Очистка кэша pacman 'pacman -Sc' ${NC}"
echo -e "${CYAN}=> ${NC}Очистка кэша неустановленных пакетов (оставив последние версии оных), и репозиториев..."
sudo pacman --noconfirm -Sc  # Очистка кэша неустановленных пакетов (оставив последние версии оных) # --noconfirm  -не спрашивать каких-либо подтверждений

echo "" 
echo -e "${CYAN}=> ${NC}Удалить кэш ВСЕХ установленных пакетов 'pacman -Scc' (высвобождая место на диске)?"
echo " Процесс удаления кэша ВСЕХ установленных пакетов - НЕ был прописан полностью автоматическим, и было принято решение дать возможность пользователю сделать выбор! "
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
echo " Удаление всех пакетов-сирот (неиспользуемых зависимостей) "    
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
echo -e "${YELLOW}==> Примечание: ${NC}Если таковая (папка) была создана изначально!"
# If it was created initially!
echo " Будьте внимательны! Процесс удаления, был прописан полностью автоматическим. " 
# Be careful! Removal process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да удалить папку (downloads),     0 - Нет пропустить этот шаг: " rm_down  # sends right after the keypress; # отправляет сразу после нажатия клавиши     
    echo ''
    [[ "$rm_down" =~ [^10] ]]
do
    :
done
if [[ $rm_down == 0 ]]; then
echo ""
echo " Удаление пропущено "      
elif [[ $rm_down == 1 ]]; then
echo "" 
echo " Удаление папки (downloads), и скрипта установки программ (archmy3l) " 
sudo rm -R ~/downloads/  # Если таковая (папка) была создана изначально
sudo rm -rf ~/archmy3l  # Если скрипт не был перемещён в другую директорию
echo " Удаление выполнено "
fi

clear
echo -e "${CYAN}
  <<< Посмотрим и Сохраним список установленного софта (пакетов) >>> 
${NC}"
# Let's see and Save the list of installed software (packages).

echo ""
echo -e "${BLUE}:: ${NC}Посмотрим список установленного софта (пакетов)?"
#echo " Посмотрим список Установленного софта (пакетов) "
# echo 'Список Установленного софта (пакетов)'
# List of Installed software (packages)
echo " Список пакетов для просмотра - будет доступен (по времени) в течении 1-ой минуты! "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Вы можете пропустить это действие..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да вывести список софта (пакетов),     0 - Нет пропустить этот шаг: " t_list  # sends right after the keypress; # отправляет сразу после нажатия клавиши       
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

clear
echo ""
echo -e "${BLUE}:: ${NC}Сохранить список Установленного софта (пакетов)?"
#echo " Сохранить список Установленного софта (пакетов)? "
# Save a list of Installed software (packages)?
echo -e "${CYAN}=> ${NC}В домашней директории пользователя будет создана папка (pkglist), в которой будут созданы и сохранены .txt списки установленного софта (пакетов)..."
echo " Список пакетов будет создан как в подробном, так и в кратком виде - (подробно: pkglist_full.txt; .pkglist.txt; кратко: pkglist.txt; aurlist.txt) "
echo " В дальнейшем Вы можете удалить папку (pkglist), без последствий! "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Вы можете пропустить это действие..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да сохранить список софта (пакетов),     0 - Нет пропустить этот шаг: " set_pkglist  # sends right after the keypress; # отправляет сразу после нажатия клавиши     
    echo ''
    [[ "$set_pkglist" =~ [^10] ]]
do
    :
done
if [[ $set_pkglist == 0 ]]; then
echo ""
echo " Сохранение списка установленного софта (пакетов) пропущено "      
elif [[ $set_pkglist == 1 ]]; then
echo ""
echo " Создадим папку (pkglist) в домашней директории "
mkdir ~/pkglist
echo " Сохранение списка установленного софта (пакетов). Подробно "
LANG=C pacman -Sl | awk '/\[installed\]$/ {print $1 "/" $2 "-" $3}' > ~/pkglist/pkglist_full.txt
LANG=C pacman -Sl | awk '/\[installed\]$/ {print $2}' > ~/pkglist/.pkglist.txt
echo " Сохранение списка установленного софта (пакетов). Кратко "
sudo pacman -Qqe > ~/pkglist/pkglist.txt
sudo pacman -Qqm > ~/pkglist/aurlist.txt
echo " Сохранение списка установленного софта (пакетов) выполнено "
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
echo -e "${YELLOW}==> ${CYAN}wget git.io/archmy4l && sh archmy4l ${NC}"
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
