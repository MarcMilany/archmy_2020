#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! ####
apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя
###
ARCHMY3_LANG="russian"  # Installer default language (Язык установки по умолчанию)
script_path=$(readlink -f ${0%/*})  # эта опция канонизируется путем рекурсивного следования каждой символической ссылке в каждом компоненте данного имени; все, кроме последнего компонента должны существовать
###
umask 0022 # Определение окончательных прав доступа - Для суперпользователя (root) umask по умолчанию равна 0022
set -e # Эта команда остановит выполнение сценария после сбоя команды и будет отправлен код ошибки
# set -euxo pipefail  # прекращает выполнение скрипта, даже если одна из частей пайпа завершилась ошибкой
#####################
### Help and usage (--help or -h) (Справка)
_help() {
    echo -e "${BLUE}
Installation guide - Arch Wiki
${BOLD}For more information, see the wiki: \
${GREY}<https://wiki.archlinux.org/index.php/Installation_guide>${NC}"
}
###
### SHARED VARIABLES AND FUNCTIONS (ОБЩИЕ ПЕРЕМЕННЫЕ И ФУНКЦИИ)
### Shell color codes (Цветовые коды оболочки)
RED="\e[1;31m"; GREEN="\e[1;32m"; YELLOW="\e[1;33m"; GREY="\e[3;93m"
BLUE="\e[1;34m"; CYAN="\e[1;36m"; BOLD="\e[1;37m"; MAGENTA="\e[1;35m"; NC="\e[0m"
###
### Automatic error detection (Автоматическое обнаружение ошибок)
_set() {
    set [--abefhkmnptuvxBCHP] [-o option] [arg ...]
}
###
_set() {
    set -e "\n${RED}Error: ${YELLOW}${*}${NC}"
    _note "${MSG_ERROR}"
    sleep 1; $$
}
###
###############################
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
###
### Display banner (Дисплей баннер)
_warning_banner
###
sleep 15
#echo ""
#echo -e "${MAGENTA}==> ${BOLD}Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети. ${NC}"
#echo 'Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети.'
# If you have a wireless connection, launch nmtui and connect to the network.
##################
clear
echo -e "${GREEN}
  <<< Начинается установка первоначально необходимого софта (пакетов) и запуск необходимых служб для системы Arch Linux >>>
${NC}"
# Installation of utilities (packages) for the Arch Linux system begins
echo -e "${BLUE}:: ${NC}Установка и настройка начата в $(date +%T)"
#echo "Установка и настройка начата в $(date +%T)"
# Installation and configuration started in $(date +%T)
###
echo ""
echo -e "${GREEN}=> ${NC}Для проверки интернета можно пропинговать какой-либо сервис"
#echo 'Для проверки интернета можно пропинговать какой-либо сервис'
# To check the Internet, you can ping a service
ping -c 2 archlinux.org  # Утилита ping - это очень простой инструмент для диагностики сети
# ping google.com -W 2 -c 1
## ping -l 3 ya.ru
###
echo -e "${CYAN}==> ${NC}Если пинг идёт едем дальше ... :)"
#echo 'Если пинг идёт едем дальше ... :)'
# If the ping goes we go further ... :)
sleep 1
###
echo ""
echo -e "${MAGENTA}==> ${NC}Давайте проверим наш часовой пояс ... :)"
#echo 'Давайте проверим наш часовой пояс ... :)'
# Let's check our time zone ... :)
timedatectl | grep "Time zone"
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Если NetworkManager запущен смотрим состояние интерфейсов"
#echo "Если NetworkManager запущен смотрим состояние интерфейсов"
# If NetworkManager is running look at the state of the interfaces
# Первым делом нужно запустить NetworkManager:
# sudo systemctl start NetworkManager
# Если NetworkManager запущен смотрим состояние интерфейсов (с помощью - nmcli):
nmcli general status
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Посмотреть имя хоста"
# View host name
nmcli general hostname
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Получаем состояние интерфейсов"
# Getting the state of interfaces
nmcli device status
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Смотрим список доступных подключений"
# See the list of available connections
nmcli connection show
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Смотрим состояние wifi подключения"
# Looking at the status of the wifi connection
nmcli radio wifi
sleep 1
## ---------------------------------------
## Посмотреть список доступных сетей wifi:
# nmcli device wifi list
## Теперь включаем:
# nmcli radio wifi on
## Или отключаем:
# nmcli radio wifi off
## Команда для подключения к новой сети wifi выглядит не намного сложнее. Например, давайте подключимся к сети TP-Link с паролем 12345678:
## nmcli device wifi connect "TP-Link" password 12345678 name "TP-Link Wifi"
## Если всё прошло хорошо, то вы получите уже привычное сообщение про создание подключения с именем TP-Link Wifi и это имя в дальнейшем можно использовать для редактирования этого подключения и управления им, как описано выше.
## ---------------------------------------
###
echo ""
echo -e "${BLUE}:: ${NC}Посмотрим данные о нашем соединение с помощью IPinfo..."
#echo " Посмотрим данные о нашем соединение с помощью IPinfo..."
# Let's look at the data about our connection using IP info...
echo -e "${CYAN}=> ${NC}С помощью IPinfo вы можете точно определять местонахождение ваших пользователей, настраивать их взаимодействие, предотвращать мошенничество, обеспечивать соответствие и многое другое."
echo " Надежный источник данных IP-адресов (https://ipinfo.io/) "
wget http://ipinfo.io/ip -qO -
sleep 03
###
echo ""
echo -e "${BLUE}:: ${NC}Узнаем версию и данные о релизе Arch'a ... :) "
#echo "Узнаем версию и данные о релизе Arch'a ... :)"
# Find out the version and release data for Arch ... :)
cat /proc/version
cat /etc/lsb-release.old
sleep 02
####################
clear

#########
############ Mirrorlist ###################
### Если ли вам нужен этот пункт в скрипте, то раскомментируйте
## Замена исходного mirrorlist (зеркал для загрузки) на мой список серверов-зеркал
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
## ===================================
clear
echo -e "${MAGENTA}
  <<< Смена, обновление зеркал для увеличения скорости загрузки утилит (пакетов). >>> ${NC}"
# Changing or updating mirrors to increase the download speed of utilities (packages).
echo ""
echo -e "${GREEN}==> ${NC}Сменить зеркала для увеличения скорости загрузки пакетов?"
echo -e "${BLUE}:: ${NC}Загрузка свежего списка зеркал со страницы Mirror Status, и Pacman Mirrorlist Generator Russia."
echo -e "${YELLOW}==> Примечание: ${BOLD}Смена или обновление зеркал - предоставлена только для Russia ${NC}"
echo " Вам будет представлено несколько вариантов для увеличения скорости загрузки пакетов. "
echo " Огласите весь список, пожалуйста! :) "
echo " 1 - Установка свежего списка зеркал со страницы Pacman Mirrorlist Generator Russia от (2021-04-03). "
echo " В файл etc/pacman.d/mirrorlist будут внесены, отсортиртированные по скорости загрузки, зеркала для Russia по протоколам (https, http - ipv4, ipv6), отсортирует их по скорости загрузки и обновит файл mirrorlist. "
echo " 2 - Загрузка свежего списка зеркал со страницы Mirror Status, обновление файла mirrorlist, с помощью (reflector). "
echo " Команда отфильтрует зеркала для Russia по протоколам (https, http - ipv4), отсортирует их по скорости загрузки и обновит файл mirrorlist. "
echo " Будьте внимательны! Не переживайте, перед обновлением зеркал будет сделана копия (backup) предыдущего файла mirrorlist, и в последствии будет сделана копия (backup) нового файла mirrorlist. Эти копии (backup) Вы сможете найти в установленной системе в /etc/pacman.d/mirrorlist. В данной опции выбор всегда остаётся за вами. "
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления"
echo " Если Вы находитесь в России рекомендую выбрать вариант "1" "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установка свежего списка от (2021-04-03),     2 - Обновление зеркал с помощью (reflector)

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
# sudo cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
# sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
  sudo cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old
## Сохраняем старый список зеркал в качестве резервной копии:
# sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old
## Переименовываем новый список:
# mv /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist
# mv -f ~/mirrorlist /etc/pacman.d/mirrorlist
## =============================
  echo ""
  echo -e "${BLUE}:: ${NC}Посмотреть список серверов-зеркал для загрузки в mirrorlist"
#echo 'Посмотреть список серверов-зеркал для загрузки в mirrorlist'
# View the list of mirror servers to upload to mirrorlist
  cat /etc/pacman.d/mirrorlist
  sleep 02
# ----------------------------
# Pacman Mirrorlist Generator
# https://www.archlinux.org/mirrorlist/
# Эта страница генерирует самый последний список зеркал, возможный для Arch Linux. Используемые здесь данные поступают непосредственно из внутренней базы данных зеркал разработчиков, используемой для отслеживания доступности и уровня зеркалирования.
# Есть два основных варианта: получить список зеркал с каждым доступным зеркалом или получить список зеркал, адаптированный к вашей географии.
## ==============================
  echo ""
  echo -e "${BLUE}:: ${NC}Загрузка свежего списка зеркал со страницы Mirror Status, и обновляем mirrorlist"
#echo 'Загрузка свежего списка зеркал со страницы Mirror Status, и обновляем mirrorlist'
# Loading a fresh list of mirrors from the Mirror Status page, and updating the mirrorlist
# Чтобы увидеть список всех доступных опций, наберите:
#reflector --help
# Команда отфильтрует пять зеркал, отсортирует их по скорости и обновит файл mirrorlist:
  sudo pacman -Sy --noconfirm --noprogressbar --quiet reflector
  sudo reflector --verbose --country 'Russia' -l 9 -p https -p http -n 9 --save /etc/pacman.d/mirrorlist.pacnew --sort rate
#reflector --verbose --country 'Russia' -l 5 -p https -p http -n 5 --sort rate --save /etc/pacman.d/mirrorlist
  echo -e "${CYAN}:: ${NC}Уведомление о загрузке и обновлении свежего списка зеркал"
# Собственные уведомления (notify):
notify-send "mirrorlist обновлен" -i gtk-info
###
#echo 'Выбор серверов-зеркал для загрузки.'
#echo 'The choice of mirrors to download.'
#pacman -Sy --noconfirm --noprogressbar --quiet reflector
#reflector -c "Russia" -c "Belarus" -c "Ukraine" -c "Poland" -f 5 -l 5 -p https -p http -n 5 --save /etc/pacman.d/mirrorlist --sort rate
#reflector --verbose --country Kazakhstan --country Russia --sort rate --save /etc/pacman.d/mirrorlist
###
#Команда отфильтрует 12 зеркал russia, отсортирует по скорости и обновит файл mirrorlist
#sudo reflector -c "Russia" -f 12 -l 12 --verbose --save /etc/pacman.d/mirrorlist
## ----------------------------------------
# Reflector — скрипт, который автоматизирует процесс настройки зеркал, включающий в себя загрузку свежего списка зеркал со страницы Mirror Status.
# https://www.linuxsecrets.com/archlinux-wiki/wiki.archlinux.org/index.php/Reflector_(%D0%A0%D1%2583%D1%2581%D1%2581%D0%BA%D0%B8%D0%B9).html
# Эта страница сообщает о состоянии всех известных, общедоступных и активных зеркал Arch Linux:
# https://www.archlinux.org/mirrors/status/
## ======================================
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
## ====================================================
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
## ====================================
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
## =======================================
  echo ""
  echo -e "${BLUE}:: ${NC}Посмотреть список серверов-зеркал для загрузки в mirrorlist"
#echo 'Посмотреть список серверов-зеркал для загрузки в mirrorlist'
# View the list of mirror servers to upload to mirrorlist
  echo ""
  cat /etc/pacman.d/mirrorlist
  sleep 02
## =======================================
  echo ""
  echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов"
#echo 'Обновим базы данных пакетов'
# Updating the package databases
#sudo pacman-key --init
#sudo pacman-key --refresh-keys
  sudo pacman -Sy
##---------------------------------
# Знакомьтесь, pacman - лучший пакетный менеджер в мире линукса!
#pacman -Syy   - обновление баз пакмэна(как apt-get update в дэбианоподбных)
#pacman -Syyu  - обновление баз плюс обновление пакетов
##-----------------------------------
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
  sudo reflector --verbose --country 'Russia' -l 9 -p https -p http -n 9 --save /etc/pacman.d/mirrorlist --sort rate
#sudo reflector --verbose --country 'Russia' -l 7 -p https -p http -n 7 --save /etc/pacman.d/mirrorlist.pacnew --sort rate
#reflector --verbose --country 'Russia' -l 5 -p https -p http -n 5 --sort rate --save /etc/pacman.d/mirrorlist
  echo -e "${CYAN}:: ${NC}Уведомление о загрузке и обновлении свежего списка зеркал"
# Собственные уведомления (notify):
  notify-send "mirrorlist обновлен" -i gtk-info
###
#echo 'Выбор серверов-зеркал для загрузки.'
#echo 'The choice of mirrors to download.'
#pacman -Sy --noconfirm --noprogressbar --quiet reflector
#reflector -c "Russia" -c "Belarus" -c "Ukraine" -c "Poland" -f 5 -l 5 -p https -p http -n 5 --save /etc/pacman.d/mirrorlist --sort rate
#reflector --verbose --country Kazakhstan --country Russia --sort rate --save /etc/pacman.d/mirrorlist
###
#Команда отфильтрует 12 зеркал russia, отсортирует по скорости и обновит файл mirrorlist
#sudo reflector -c "Russia" -f 12 -l 12 --verbose --save /etc/pacman.d/mirrorlist
###
## ----------------------------------
# Reflector — скрипт, который автоматизирует процесс настройки зеркал, включающий в себя загрузку свежего списка зеркал со страницы Mirror Status.
# https://www.linuxsecrets.com/archlinux-wiki/wiki.archlinux.org/index.php/Reflector_(%D0%A0%D1%2583%D1%2581%D1%2581%D0%BA%D0%B8%D0%B9).html
# Эта страница сообщает о состоянии всех известных, общедоступных и активных зеркал Arch Linux:
# https://www.archlinux.org/mirrors/status/
## ==================================
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
  sudo pacman -Sy --noconfirm  # обновить списки пакетов из репозиториев
#-----------------------------------------------
## Знакомьтесь, pacman - лучший пакетный менеджер в мире линукса!
#pacman -Syy   - обновление баз пакмэна(как apt-get update в дэбианоподбных)
#pacman -Syyu  - обновление баз плюс обновление пакетов
##----------------------------------
fi
## ---------------------------------
### Если возникли проблемы с обновлением, или установкой пакетов
### Если ли вам нужен этот пункт в скрипте, то раскомментируйте ниже в меню все тройные решётки (###)
############
clear
echo ""
echo -e "${YELLOW}==> ${NC}Обновить и добавить новые ключи?"
echo " Данный этап поможет вам избежать проблем с ключами Pacmаn, если Вы использовали не свежий образ ArchLinux для установки! "
echo -e "${RED}==> ${YELLOW}Примечание: ${BOLD}- Иногда при запуске обновления ключей по hkp возникает ошибка, не переживайте просто при установке gnupg в линукс в дефолтном конфиге указан следующий сервер: (keyserver hkp://keys.gnupg.net). GnuPG - оснащен универсальной системой управления ключами, а также модулями доступа для всех типов открытых ключей. GnuPG, также известный как GPG, это инструмент командной строки с возможностью легкой интеграции с другими приложениями. Доступен богатый выбор пользовательских приложений и библиотек. ${NC}"
echo -e "${RED}==> ${BOLD}Примечание: - Однако, в ходе чтения различных руководств в интернете было выяснено, что подобный способ обновления и передачи ключей не самый лучший, т.к. эта информация передается открытым способом. И тот, кто наблюдает за траффиком, видит данные обновляемых при gpg -refresh-keys ключей. И поэтому рекомендуется использовать hkps сервера - (keyserver hkps://hkps.pool.sks-keyservers.net)! ${NC}"
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, можно пропустить запуск обновления ключей. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да обновить ключи,    0 - Нет пропустить: " x_key  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_key" =~ [^10] ]]
do
    :
done
 if [[ $x_key == 0 ]]; then
  echo ""
  echo " Обновление ключей пропущено "
  echo ""
  echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов"
  sudo pacman -Sy --noconfirm  # обновить списки пакетов из репозиториев
elif [[ $x_key == 1 ]]; then
  clear
  echo ""
  echo " Обновим списки пакетов из репозиториев и установим Брелок Arch Linux PGP - пакет (archlinux-keyring) "
  sudo pacman -Syy archlinux-keyring --noconfirm  # Брелок Arch Linux PGP ; https://archlinux.org/packages/core/any/archlinux-keyring/
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
# echo " Удалим директорию (/etc/pacman.d/gnupg) "
# sudo rm -R /root/.gnupg
  echo " Создаётся генерация мастер-ключа (брелка) pacman "  # gpg –refresh-keys
  sudo pacman-key --init  # генерация мастер-ключа (брелка) pacman
  echo " Далее идёт поиск ключей... "
  sudo pacman-key --populate archlinux  # поиск ключей
# sudo pacman-key --populate
  echo " Брелок для ключей Arch Linux PGP (Репозиторий для пакета связки ключей Arch Linux) "
  sudo pacman -Sy --noconfirm --needed --noprogressbar --quiet archlinux-keyring  # Брелок для ключей Arch Linux PGP https://git.archlinux.org/archlinux-keyring.git/ (для hkps://hkps.pool.sks-keyservers.net)
  echo ""
  echo " Обновление ключей... "
  sudo pacman-key --refresh-keys
#  sudo pacman-key --refresh-keys --keyserver keys.gnupg.net  # http://pool.sks-keyservers.net/
# sudo pacman-key --refresh-keys --keyserver hkp://pool.sks-keyservers.net  # hkps://hkps.pool.sks-keyservers.net
## Предлагается сделать следующие изменения в конфиге gnupg:
## keyserver hkps://hkps.pool.sks-keyservers.net
## keyserver-options ca-cert-file=/path/to/CA/sks-keyservers.netCA.pem
## где sks-keyservers.netCA.pem – есть сертификат, загружаемый с wwwhttps://sks-keyservers.net/sks-keyservers.netCA.pem
# sudo pacman-key --refresh-keys --keyserver hkps://hkps.pool.sks-keyservers.net
# sudo keyserver-options ca-cert-file=/path/to/CA/sks-keyservers.netCA.pem
  echo ""
  echo "Обновим базы данных пакетов..."
###  sudo pacman -Sy  # обновить списки пакетов из репозиториев
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
  sudo pacman -S --noconfirm --needed gnome-keyring  # Хранит пароли и ключи шифрования (https://wiki.gnome.org/Projects/GnomeKeyring
  sudo pacman -S seahorse --noconfirm  # Приложение GNOME для управления ключами PGP (управления паролями и ключами шифрования)
  echo ""
  echo " Установка Приложение GNOME для управления ключами PGP "
 fi
fi
sleep 1
## ------------------------------
# Или:
#sudo pacman-key --init && sudo pacman-key --populate archlinux && sudo pacman-key --refresh-keys && sudo pacman -Sy
# Если возникли проблемы с обновлением, или установкой пакетов выполните данные рекомендации.
# sudo pacman-key --init && sudo pacman-key --populate && sudo pacman-key --refresh-keys && sudo pacman -Syy
# Если ошибка с содержанием hkps.pool.sks-keyservers.net, не может достучаться до сервера ключей выполните команды ниже. Указываем другой сервер ключей.
# sudo pacman-key --init && sudo pacman-key --populate
# sudo pacman-key --refresh-keys --keyserver keys.gnupg.net && sudo pacman -Syy
## --------------------------------
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
## ----------------------------
# Ошибки про archlinux-keyring
# Если вы получаете ошибки, связанные с ключами (например, ключ A634567E8t6574 не может быть найден удаленно) при попытке обновить вашу систему, вы должны выполнить следующие четыре команды от имени пользователя root:
# rm -R /etc/pacman.d/gnupg/
# rm -R / root / .gnupg /
# gpg –refresh-keys
# pacman-key –init && pacman-key –populate archlinux
# pacman-key –refresh-keys
## =============================
##############

#################
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
# dmesg | grep microcode
fi
sleep 04
###
#clear
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
  echo ""
  echo -e "${BLUE}:: ${NC}Воссоздайте загрузочный RAM диск (initramfs)"
  sudo update-initramfs -u
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
  echo ""
  echo -e "${BLUE}:: ${NC}Воссоздайте загрузочный RAM диск (initramfs)"
  sudo update-initramfs -u
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
  echo ""
  echo -e "${BLUE}:: ${NC}Воссоздайте загрузочный RAM диск (initramfs)"
fi
#############
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
##############
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
###############
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
  sudo pacman -Syu  # Обновим вашу систему (базу данных пакетов)
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
  sudo pacman -Syu  # Обновим вашу систему (базу данных пакетов)
#echo " Установка базовых программ и пакетов wget, curl, git "
#sudo pacman -S --noconfirm --needed wget curl git
  sudo pacman -D --asdeps go  # зависимость 'go' - (Основные инструменты компилятора для языка программирования Go)
# Чтобы протестировать любой данный пакет после его установки, сделайте следующее: pacman -D –asdeps  - Это сообщит pacman, что пакет был установлен как зависимость, следовательно, он будет указан как потерянный (что вы можете увидеть с помощью «pacman -Qtd»). Если вы затем решите, что хотите сохранить пакет, вы можете использовать флаг –asexplicit как есть ...
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
  sudo pacman -Syu  # Обновим вашу систему (базу данных пакетов)
#echo " Установка базовых программ и пакетов wget, curl, git "
#sudo pacman -S --noconfirm --needed wget curl git
  echo " Установка AUR Helper (pikaur) "
  git clone https://aur.archlinux.org/pikaur.git
  cd pikaur
  makepkg -si --noconfirm
  pwd
# makepkg -si
# makepkg -fsri --noconfirm
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
# --------------------------------------------
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
# ==========================================
###
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
###
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
echo " 2 - Pacman gui (octopi) - Графический менеджер пакетов (мощный интерфейс Pacman с использованием библиотек Qt5), укажите вариант "2" "
echo -e "${CYAN}=> ${BOLD}Вариант '2' Напрямую привязан к Установке AUR Helper, если ранее БЫЛ выбран AUR-(pikaur). ${NC}"
echo -e "${YELLOW}:: ${NC}Так как - Подчеркну (обратить внимание)! 'Pikaur' - идёт как зависимость для Octopi."
echo " 3 - Pacman gui (octopi) - Графический менеджер пакетов (мощный интерфейс Pacman с использованием библиотек Qt5), укажите вариант "3" "
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
##### appstream-glib ######
sudo pacman -S appstream-glib --noconfirm  # Объекты и методы для чтения и записи метаданных AppStream
##### archlinux-appstream-data ######
sudo pacman -S archlinux-appstream-data --noconfirm  # База данных приложений Arch Linux для центров программного обеспечения на основе AppStream
##### libhandy ######
sudo pacman -S libhandy --noconfirm  # Библиотека, полная виджетов GTK+ для мобильных телефонов
##### libpamac-aur ######
git clone https://aur.archlinux.org/libpamac-aur.git
cd libpamac-aur
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
#  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
rm -Rf libpamac-aur
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
######### qtermwidget #######
sudo pacman -S qtermwidget --noconfirm  # Виджет терминала для Qt, используемый QTerminal
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
######### qtermwidget #######
sudo pacman -S qtermwidget --noconfirm  # Виджет терминала для Qt, используемый QTerminal
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
###
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
# clear
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
# clear
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
##############
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
# clear
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
# clear
  echo ""
  echo " Bash-скрипт (downgrade) успешно установлен! "
fi
####################

clear
echo -e "${MAGENTA}
  <<< Установка первоначально необходимого софта (пакетов) для Archlinux >>> ${NC}"
# Installation of initially required software (packages) for Archlinux.
echo -e "${YELLOW}==> Примечание: ${NC}Сейчас Вы можете установить софт: поддержки Bluetooth, поддержки звука, архиваторы, утилиты для вывода информации о системе, мультимедиа, текстовые редакторы, утилиты разработки, браузеры, управления электронной почтой, торрент-клиент, офисные утилиты и т.д., или пропустите установку."

echo ""
echo -e "${MAGENTA}:: ${NC}Установка дополнительных базовых программ (пакетов) - которые раньше присутствовали в (community), но были перенесены в репозиторий AUR .... "
########### autofs #############
# sudo pacman -S autofs --noconfirm  # Средство автомонтирования на основе ядра для Linux
  echo ""
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syu
#echo " Установка базовых программ и пакетов wget, curl, git "
#sudo pacman -S --noconfirm --needed wget curl git
  echo ""
  echo " Установка Средства автомонтирования на основе ядра для Linux (autofs) "
  git clone https://aur.archlinux.org/autofs.git
  cd autofs
  makepkg -si --noconfirm
  pwd
# makepkg -si
#makepkg -si --skipinteg
  cd ..
  rm -Rf autofs
  echo ""
  echo " Установка пакета (autofs) завершена "
########## davfs2 ############
# sudo pacman -S davfs2 --noconfirm  # Драйвер файловой системы, позволяющий монтировать папку WebDAV
  echo ""
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
  echo ""
  echo " Установка Драйвера файловой системы (davfs2) "
  git clone https://aur.archlinux.org/davfs2.git
  cd davfs2
  makepkg -si --noconfirm
  pwd
# makepkg -si
#makepkg -si --skipinteg
  cd ..
  rm -Rf davfs2
  echo ""
  echo " Установка пакета (davfs2) завершена "
####### termite #######
# sudo pacman -S termite --noconfirm  #  Простой терминал на базе VTE
# sudo pacman -S termite-terminfo --noconfirm  # Terminfo для Termite, простого терминала на базе VTE
  echo ""
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
  echo ""
  echo " Установка терминал на базе VTE (termite) "
  git clone https://aur.archlinux.org/termite.git
  cd termite
  makepkg -si --noconfirm
  pwd
# makepkg -si
#makepkg -si --skipinteg
  cd ..
  rm -Rf termite
  echo ""
  echo " Установка пакета (termite) завершена "
########
clear
echo ""
echo " Установка дополнительных базовых программ (пакетов) выполнена "
echo ""
echo " Запускаем обслуживания gpm сервера мыши для консоли и xterm "
sudo systemctl start gpm
echo ""
echo " Добавляем службу gpm в автозагрузку "
sudo systemctl enable gpm
fi
#####
################


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

####################################



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
echo " Создание пользовательских каталогов по умолчанию "
sudo pacman -S xdg-user-dirs-gtk --noconfirm  # Создаёт каталоги пользователей и просит их переместить
xdg-user-dirs-gtk-update  # Обновить закладки в thunar (левое меню)
echo ""
echo " Создание каталогов успешно выполнено "
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
echo " Создание шаблонов файлов в ~/Templaytes (чтобы в контекстном меню отображался пункт New Document) "
XDG_TEMPLATES_DIR=$(xdg-user-dir TEMPLATES)
cd "$XDG_TEMPLATES_DIR"
touch 'New Text File.txt' && touch 'New Word File.doc' && touch 'New Excel Spreadsheet.xls'
touch 'New HTML File.html' && touch 'New XML File.xml' && touch 'New PHP Source File.php'
touch 'New File Block Diagram.odg' && touch 'New Casscading Style Sheet.css' && touch 'New Java Source File.java'
touch 'New ODB DataBase.odb' && touch 'New ODT File.odt' && touch 'New Table ODS.ods' && touch 'New File Excel.et'
touch 'New File DPS Presentation.dps' && touch 'New File ODP Presentation.odp' && touch 'New File PowerPoint Presentation.ppt'
touch 'New File README.md' && touch 'New Pyfile.py'
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
fi
# touch ~/Templates/{Empty\ Document,Text\ Document.txt,README.md,pyfile.py}
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
echo ""
echo -e "${GREEN}==> ${NC}Установить Docklike Plugin для XFCE?"
echo -e "${MAGENTA}:: ${BOLD}Docklike Plugin - это современная минималистичная панель задач в стиле док-станции для Xfce. Используя его на рабочем столе Xfce, Вы получите "панель задач - только значки" с поддержкой прикрепления приложений и группировкой окон. ${NC}"
echo " Этот плагин панели Xfce является отличной альтернативой DockBarX, с меньшим количеством функций и настроек. "
echo -e "${YELLOW}==> Примечание! ${NC}Помимо того, что плагин позволяет запустить/закрыть окно приложения, минимизировать в один клик на панели, он также может управлять параметрами открытых окон из значка. Используйте Ctrl, чтобы изменить порядок приложений или получить доступ к панели настроек (щелкнув правой кнопкой мыши)."
echo " Как отмечалось в начале, плагин обладает небольшим количеством функций и настроек. "
echo -e "${CYAN}:: ${NC}Установка Docklike Plugin (xfce4-docklike-plugin-git) ; (xfce4-docklike-plugin) проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/xfce4-docklike-plugin-git/) ; (https://aur.archlinux.org/packages/xfce4-docklike-plugin/)- собирается и устанавливается. "
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In this option, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_docklike  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_docklike" =~ [^10] ]]
do
    :
done
if [[ $i_docklike == 0 ]]; then
echo ""
echo " Установка Docklike Plugin пропущена "
elif [[ $i_docklike == 1 ]]; then
  echo ""
  echo " Установка Docklike Plugin (xfce4-docklike-plugin) "
#### xfce4-docklike-plugin #######
#yay -S xfce4-docklike-plugin --noconfirm  # Современная минималистичная панель задач в стиле док-станции для XFCE
#yay -S xfce4-docklike-plugin-git --noconfirm  # Панель задач Docklike (Если установлен yay - эта команда)
git clone https://aur.archlinux.org/xfce4-docklike-plugin.git
# git clone https://aur.archlinux.org/xfce4-docklike-plugin-git.git
cd xfce4-docklike-plugin
# cd xfce4-docklike-plugin-git
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf xfce4-docklike-plugin
rm -Rf xfce4-docklike-plugin
# rm -Rf xfce4-docklike-plugin-git
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#-------------------------
# Важно!!!
# Нужно удерживать ctrl, чтобы изменить порядок закрепленных приложений.
# (Я подумал, что было бы неплохо упомянуть эту информацию. Я нашел это в проекте README как раз перед тем, как собирался открепить все и переставить их с нуля.)
# https://aur.archlinux.org/packages/xfce4-docklike-plugin-git/
# https://aur.archlinux.org/packages/xfce4-docklike-plugin/
# https://github.com/nsz32/docklike-plugin
# https://github.com/topics/xfce4-panel-plugin
# https://compizomania.blogspot.com/2020/12/docklike-plugin-xfce.html
#------------------------------

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
echo -e "${MAGENTA}
  <<< Установить дополнительных утилит для Синхронизации времени (Если Вы обнаружите, что время сбиваться по различным причинам). >>> ${NC}"

echo ""
echo -e "${GREEN}==> ${NC}Установить TimeSet (bash скрипт - timeset) и GUI интерфейс для управления системной датой и временем (timeset-gui) из AUR"
#echo 'Установить TimeSet (bash скрипт - timeset) и GUI интерфейс для управления системной датой и временем (timeset-gui)
# Install TimeSet and GUI...
echo -e "${BLUE}:: ${BOLD}Посмотрим дату, время, и часовой пояс ... ${NC}"
timedatectl | grep "Time zone"
date
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'     # одновременно отображает дату и часовой пояс
echo ""
echo -e "${YELLOW}=> ${NC}Если при двойной загрузке с Windows или любой другой ОС Вы обнаружите, что время сбиваться, это может быть связано с тем, что они используют разные значения времени для аппаратных часов. Arch (& Manjaro) считает, что аппаратные часы находятся в формате UTC, в то время как Windows и некоторые другие дистрибутивы Linux предполагают, что аппаратные часы находятся в местном времени. Чтобы исправить это, можно настроить Windows на использование аппаратного времени в формате UTC."
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo " 1 - TimeSet (bash скрипт - timeset) - пакет (timeset - Скрипт для управления системной датой и временем) "
echo -e "${CYAN}:: ${NC}Установка TimeSet (timeset) проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/timeset.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux - AUR' (https://aur.archlinux.org/packages/timeset/) - собирается и устанавливается. "
echo " 2 - TimeSet-GUI (python скрипт - timeset-gui) - пакет (timeset-gui - Графический интерфейс для управления системной датой и временем) "
echo -e "${CYAN}:: ${NC}Установка TimeSet-GUI (timeset-gui) проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/timeset-gui.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux - AUR' (https://aur.archlinux.org/packages/timeset-gui/) - собирается и устанавливается. "
echo -e "${YELLOW}==> Внимание! ${NC}Для полноценной установки у Вас должен быть установлен NTP (Network Time Protocol) - (пакет ntp), и Gksu (Графический интерфейс для su) - (пакет gksu), которые являются зависимостями для установки."
echo -e "${CYAN}:: ${NC}Возможно эти зависимости были установлены вами ранее!"  # NTP Servers (серверы точного времени) - https://www.ntp-servers.net/; Introduction - https://www.ntppool.org/ru/
echo " Будьте внимательны! В данной опции выбор всегда остаётся за вами. "
echo -e "${CYAN}==> ${NC}Рекомендую выбрать вариант "1" (Установим СРАЗУ timeset и timeset-gui)"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить TimeSet и TimeSet-GUI (timeset; timeset-gui),     2 - Установить TimeSet (bash скрипт - timeset)

    0 - НЕТ - Пропустить установку: " i_timeset  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_timeset" =~ [^120] ]]
do
    :
done
if [[ $i_timeset == 0 ]]; then
echo ""
echo " Установка пропущена "
elif [[ $i_timeset == 1 ]]; then
  echo ""
  echo " Установка TimeSet и TimeSet-GUI (графический интерфейс для управления системной датой) "
# yay -S timeset --noconfirm  # Скрипт для управления системной датой и временем
# yay -S timeset-gui --noconfirm  # Графический интерфейс для управления системной датой
echo " Установка TimeSet (пакета - timeset) "
##### timeset ######
git clone https://aur.archlinux.org/timeset.git
cd timeset
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf timeset
rm -Rf timeset   # удаляем директорию сборки
echo " Установка TimeSet-GUI (пакета - timeset-gui) "
##### timeset-gui ######
git clone https://aur.archlinux.org/timeset-gui.git
cd timeset-gui
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf timeset-gui
rm -Rf timeset-gui   # удаляем директорию сборки
echo ""
echo " Установка TimeSet и TimeSet-GUI (timeset; timeset-gui) выполнена "
echo " Время точное как на Спасской башне Московского Кремля! "
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'   # одновременно отображает дату и часовой пояс
elif [[ $i_timeset == 2 ]]; then
  echo ""
  echo " Установка TimeSet (скрипт для управления системной датой и временем) "
# yay -S timeset --noconfirm  # Скрипт для управления системной датой и временем
##### timeset ######
git clone https://aur.archlinux.org/timeset.git
cd timeset
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf timeset
rm -Rf timeset   # удаляем директорию сборки
echo ""
echo " Установка TimeSet (timeset) выполнена "
echo " Время точное как на Спасской башне Московского Кремля! "
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'   # одновременно отображает дату и часовой пояс
fi

clear
echo -e "${CYAN}
  <<< Запуск и добавление установленных программ (пакетов), сервисов и служб в автозапуск. >>>
${NC}"
# Launch and add installed programs (packages), services, and services to autorun.






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
#######################
echo ""
echo " Настройка раскладки клавиатуры в X.Org "
echo " localectl [--no-convert] set-x11-keymap раскладка [модель [вариант [опции]]] "
sudo localectl --no-convert set-x11-keymap us,ru pc105 "" grp:alt_shift_toggle
# localectl --no-convert set-x11-keymap us,ru pc105 "" grp:alt_shift_toggle
echo " Чтобы изменения вступили в силу, перезагрузите Xorg командой: "
sudo systemctl restart display-manager
########################
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
echo -e "${CYAN}:: ${NC}Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов."
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
echo ""
#echo " Установка завершена для выхода введите >> exit << "
#exit(0)  # означает чистый выход без каких-либо ошибок (проблем)
#exit(1)  # означает, что была какая-то ошибка (проблема), и именно поэтому программа выходит
