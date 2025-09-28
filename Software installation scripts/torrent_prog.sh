#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! ####
apptitle="Arch Linux Fast Install v2.5 LegasyBIOS - Version: 2025.07.09.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя
###
TORRENT_PROG_LANG="russian"  # Installer default language (Язык установки по умолчанию)
ARCHMY5L_LANG="russian"  # Installer default language (Язык установки по умолчанию)
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
В процессе работы сценария (скрипта) Вам будут задаваться вопросы на установку той, или иной утилиты (пакета) - будьте внимательными! В скрипте есть утилиты (пакеты), которые устанавливаются из 'AUR' в зависимости от вашего выбора, и т.д.. Остальной софт (пакеты) скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска необходимых служб. В любой ситуации выбор всегда за вами. Вы либо гуляете под дождем, либо просто под ним мокнете. ${RED}

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
# sudo pacman -Sy --noconfirm  # обновить списки пакетов из репозиториев
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
  echo ""
  echo " Обновление базы данных выполнено "
fi
sleep 1
################

clear
echo -e "${MAGENTA}
  <<< Установка утилит (пакетов) BitTorrent-клиентов в Archlinux 🏴‍ 🌱 🌐 📺 >>> ${NC}"
# Installing BitTorrent client utilities (packages) in Archlinux
echo ""
echo -e "${YELLOW}==> Примечание! ${BOLD} *Действительно, для Linux доступно множество торрент-клиентов. Независимо от ваших предпочтений, торрент-клиент должен обладать необходимыми основными функциями и простым в использовании интерфейсом. В Arch Linux доступны несколько BitTorrent-клиентов. Среди них — rTorrent, Transmission, qBittorrent и т.д... В большинстве случаев торрент-приложения не запускаются по умолчанию. Возможно, вы захотите изменить это поведение. Рекомендую вам прочитать, как управлять автозагрузкой приложений в Archlinux, чтобы обеспечить запуск BitTorrent-клиента при загрузке системы. ${NC}"
sleep 05

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Transmission (transmission-gtk transmission-qt) — Бесплатный клиент BitTorrent (GUI)?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Transmission является одной из самых простых в использовании программ для скачивания торрентов. Программа проста в обращении и не вызовет сложностей даже у новичков. Позволяет скачивать и создавать торренты, управлять скоростью приема и передачи, выставлять приоритеты. При скачивании торрентов можно сделать выборочное скачивание, то есть указать какие файлы или папки необходимо загрузить. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Transmission — это BitTorrent клиент для Linux с простым и удобным интерфейсом. *От разработчиков: Transmission разработан для простого и мощного использования. Мы установили значения по умолчанию, чтобы они просто работали, и требуется всего несколько щелчков, чтобы настроить расширенные функции, такие как просмотр каталогов, списки блокировки плохих пиров и веб-интерфейс. Обе версии GUI, transmission-gtk и transmission-qt , могут функционировать автономно без формального внутреннего демона. Версии GUI настроены на работу из коробки, но пользователь может захотеть изменить некоторые настройки. Путь по умолчанию к файлам конфигурации GUI — ~/.config/transmission. Руководство по параметрам конфигурации можно найти на Github (https://github.com/transmission/transmission/blob/main/docs/Editing-Configuration-Files.md). Этот проект Лицензируется под GPL-2.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: http://www.transmissionbt.com/ ; (https://transmissionbt.com/ ; https://archlinux.org/packages/extra/x86_64/transmission-gtk/ ; https://archlinux.org/packages/extra/x86_64/transmission-qt/ ; https://transmissionbt.ru/download.html). "
echo -e "${BLUE}:: ${NC}Функции: В отличие от других клиентов, Transmission уникально поддерживает встроенные системы, такие как NAS, персональные серверы, HTPC и Raspberry Pi. Поддержка плагина Kodi отличает Transmission от остальных существующих клиентов BitTorrent, и поддержка RSS-каналов здесь тоже является преимуществом. Плюсы: Полнофункциональный клиент; Кроссплатформенная совместимость; Чистый интерфейс; Специальное приложение для встроенных устройств. Минусы: Не хватает встроенной поисковой системы; Нет поддержки прокси-сервера."
echo -e "${CYAN}:: ${NC}Настройка Transmission выполняется в едином окне. Так же можно выполнить настройки каждой отдельной раздачи. Transmission может работать в качестве демона в фоновом режиме и запускаться из командной строки. Программа доступна с интерфейсами основанными на GTK (пакет transmission-gtk) и на Qt (пакет transmission-qt). "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить Transmission (GTK+) (transmission-gtk),   2 - Установить Transmission (Qt) (transmission-qt),

    0 - НЕТ - Пропустить установку: " in_transmission  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_transmission" =~ [^120] ]]
do
    :
done
if [[ $in_transmission == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_transmission == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Transmission (GTK+) (transmission-gtk) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed libnotify  # (необязательно) — поддержка уведомлений на рабочем столе ; Библиотека для отправки уведомлений на рабочий стол ; https://archlinux.org/packages/extra/x86_64/libnotify/ ; https://gitlab.gnome.org/GNOME/libnotify ; Обеспечивает: libnotify.so=4-64 ; 2025-03-29 00:39 UTC
sudo pacman -S --noconfirm --needed libtorrent  # Библиотека BitTorrent с упором на высокую производительность ; https://archlinux.org/packages/extra/x86_64/libtorrent/ ; https://rakshasa.github.io/rtorrent/ ; 2025-09-05 14:30 UTC
sudo pacman -S --noconfirm --needed transmission-cli  # (необязательно) — демон и веб-поддержка ; Быстрый, простой и бесплатный клиент BitTorrent (инструменты командной строки, демон и веб-клиент) ; https://archlinux.org/packages/extra/x86_64/transmission-cli/ ; http://www.transmissionbt.com/ ; 2025-06-15 12:33 UTC
############ transmission-gtk #############
sudo pacman -S --noconfirm --needed transmission-gtk  # Быстрый, простой и бесплатный BitTorrent-клиент (GTK+ GUI) ; https://archlinux.org/packages/extra/x86_64/transmission-gtk/ ; http://www.transmissionbt.com/ ; 2025-06-15 12:34 UTC
############ transmission-remote-gtk #############
# sudo pacman -S --noconfirm --needed transmission-cli  # (необязательно) — демон и веб-поддержка ; Быстрый, простой и бесплатный клиент BitTorrent (инструменты командной строки, демон и веб-клиент) ; https://archlinux.org/packages/extra/x86_64/transmission-cli/ ; http://www.transmissionbt.com/ ; 2025-06-15 12:33 UTC
# sudo pacman -S --noconfirm --needed transmission-remote-gtk  # Удаленное управление GTK для клиента Transmission BitTorrent ; графический интерфейс GTK 3 для демона, и демон, с CLI ; https://archlinux.org/packages/extra/x86_64/transmission-remote-gtk/ ; https://github.com/transmission-remote-gtk/transmission-remote-gtk ; 2024-11-20 12:59 UTC
  echo ""
  echo " Посмотрите информацию о версии (transmission) "
sudo pacman -Q transmission-gtk  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_transmission == 2 ]]; then

  echo ""
  echo " Установка утилиты (пакета) Transmission (Qt) (transmission-qt) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed libtorrent  # Библиотека BitTorrent с упором на высокую производительность ; https://archlinux.org/packages/extra/x86_64/libtorrent/ ; https://rakshasa.github.io/rtorrent/ ; 2025-09-05 14:30 UTC
sudo pacman -S --noconfirm --needed transmission-cli  # (необязательно) — демон и веб-поддержка ; Быстрый, простой и бесплатный клиент BitTorrent (инструменты командной строки, демон и веб-клиент) ; https://archlinux.org/packages/extra/x86_64/transmission-cli/ ; http://www.transmissionbt.com/ ; 2025-06-15 12:33 UTC
############ transmission-qt #############
sudo pacman -S --noconfirm --needed transmission-qt  # Быстрый, простой и бесплатный BitTorrent-клиент (Qt GUI) ; Графический интерфейс Qt 6, и демон, с CLI ; https://archlinux.org/packages/extra/x86_64/transmission-qt/ ; http://www.transmissionbt.com/ ; 2025-06-15 12:34 UTC
  echo ""
  echo " Посмотрите информацию о версии (transmission) "
sudo pacman -Q transmission-qt  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# Transmission:
# http://www.transmissionbt.com/
# https://transmissionbt.com/
# https://archlinux.org/packages/extra/x86_64/transmission-gtk/
# https://archlinux.org/packages/extra/x86_64/transmission-qt/
# https://transmissionbt.ru/download.html
# Transmission ArchWiki:
# https://wiki.archlinux.org/title/Transmission
# Add-Ons:
# https://transmissionbt.com/addons
# Руководство по параметрам конфигурации можно найти на Github Transmission:
# https://github.com/transmission/transmission/blob/main/docs/Editing-Configuration-Files.md
# Пояснение:
# Transmission-cli - демон с интерфейсами CLI и веб-клиента ( http: // localhost: 9091 ).
# Transmission-remote-cli - Интерфейс Curses для демона.
# Transmission-gtk - пакет GTK + 4.
# Transmission-qt - пакет Qt5.
# Transmission-remote-gtk - Графический интерфейс GTK 3
####################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить qBittorrent (qbittorrent) — Усовершенствованный клиент BitTorrent (Qt)?"
echo -e "${YELLOW}==> Предисловие! ${BOLD} *С появлением скоростного интернета и различных стриминговых сервисов торренты теряют свою привлекательность, но они все ещё остаются актуальными для загрузки образов операционных систем. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}qBittorrent — это один из самых популярных свободных торрент клиентов с открытым исходным кодом для Linux. Программа поддерживает такие платформы, как Linux, Windows, MacOS и FreeBSD. Написан на С++ с использованием библиотеки QT и потому кроссплатформенный. Интерфейс программы напоминает uTorrent, зато здесь нет рекламы и поддерживаются такие BitTorrent расширения как DHT, peer exchange и полное шифрование. Кроме того, программой можно пользоваться через веб-интерфейс удаленно. Приложение переведено на русский язык. Этот проект Лицензируется под GPL-2.0 или более поздняя версия, GPL-3.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://www.qbittorrent.org/ ; (https://archlinux.org/packages/extra/x86_64/qbittorrent/ ; https://wiki.archlinux.org/title/QBittorrent). "
echo -e "${BLUE}:: ${NC}Функции: Хорошо адаптированный и расширяемый механизм поиска Search Engine; Одновременный поиск на большинстве известных поисковых сайтах системы BitTorrent; Возможность поиска по заданным категориям (e.g. Books(Книги), Music(Музыка), Movies(Фильмы)); Поддержка всех расширений Bittorrent; DHT, Peer Exchange, полное шифрование, Magnet/BitComet URIs, и т.д.; Возможность удаленного управления через веб-интерфейс; Практически идентичный пользовательский интерфейс полностью написанный на Ajax; Продвинутое управление трекерами, peerами и torrent-файлами; Постановка в очередь и установка приоритетов торрентов; Возможность выбора содержимого и установка приоритетов для скачивания; Поддержка перенаправления портов, используя UPnP / NAT-PMP; Доступен на приблизительно 25-ти языках (поддержка Unicode); Создание торрент-файлов; Продвинутая поддержка RSS с учетом фильтров на скачивание (включая регулярные выражения); Планировщик (scheduler) скорости скачивания/раздачи; IP-фильтрация (совместимость с eMule и PeerGuardian); IPv6 поддерживается. Ну и конечно он совершенно бесплатен! А это значит, что в его интерфейсе вы не встретите никакой нервирующей рекламы и все рабочее пространство будет отображать процессы загрузки/раздачи файлов "
echo -e "${CYAN}:: ${NC}Среди явных особенностей qBittorrent хочу отметить его сходство с аналогичными клиентами для ОС Microsoft Windows: µTorrent и BitTorrent. Сходство не случайное, потому что qBittorrent также функционален и быстр как его аналоги. Главное окно программы содержит список торрентов, представленный в виде таблицы. Колонки таблицы можно включать и отключать. Слева расположены категории для фильтрации. При нажатии на какой-либо торрент из списка можно просматривать различную статистику. Сверху расположена горизонтальная панель управления с кнопками и меню программы. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить qBittorrent (Qt) (qbittorrent),  2 - Установить qBittorrent (Qt) (qbittorrent-nox)(без графического интерфейса),

    0 - НЕТ - Пропустить установку: " in_qbittorrent  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_qbittorrent" =~ [^120] ]]
do
    :
done
if [[ $in_qbittorrent == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_qbittorrent == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) qBittorrent (Qt) (qbittorrent) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed libtorrent  # Библиотека BitTorrent с упором на высокую производительность ; https://archlinux.org/packages/extra/x86_64/libtorrent/ ; https://rakshasa.github.io/rtorrent/ ; 2025-09-05 14:30 UTC
sudo pacman -S --noconfirm --needed libtorrent-rasterbar  # Эффективная и полнофункциональная реализация библиотеки C++ BitTorrent ; https://archlinux.org/packages/extra/x86_64/libtorrent-rasterbar/ ; https://www.rasterbar.com/products/libtorrent/ ; 2025-05-02 22:28 UTC
########### qbittorrent ############
sudo pacman -S --noconfirm --needed qbittorrent  # Расширенный клиент BitTorrent, написанный на C++ и основанный на инструментарии Qt и libtorrent-rasterbar ; клиент для обмена файлами в P2P сетях ; https://archlinux.org/packages/extra/x86_64/qbittorrent/  ; https://www.qbittorrent.org/ ; 2025-07-02 14:20 UTC
  echo ""
  echo " Посмотрите информацию о версии (qbittorrent) "
# qbittorrent --version  # Показать версию приложения
sudo pacman -Q qbittorrent  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_qbittorrent == 2 ]]; then
  echo ""
  echo " Установка утилиты (пакета) qBittorrent (Qt) (qbittorrent-nox) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed libtorrent  # Библиотека BitTorrent с упором на высокую производительность ; https://archlinux.org/packages/extra/x86_64/libtorrent/ ; https://rakshasa.github.io/rtorrent/ ; 2025-09-05 14:30 UTC
sudo pacman -S --noconfirm --needed libtorrent-rasterbar  # Эффективная и полнофункциональная реализация библиотеки C++ BitTorrent ; https://archlinux.org/packages/extra/x86_64/libtorrent-rasterbar/ ; https://www.rasterbar.com/products/libtorrent/ ; 2025-05-02 22:28 UTC
############ qbittorrent-nox ###########
sudo pacman -S --noconfirm --needed qbittorrent-nox  # Расширенный клиент BitTorrent, написанный на C++, на основе инструментария Qt и libtorrent-rasterbar, без графического интерфейса ; https://archlinux.org/packages/extra/x86_64/qbittorrent-nox/ ; ; https://www.qbittorrent.org/ ; 2025-07-02 14:20 UTC
  echo ""
  echo " Посмотрите информацию о версии (qbittorrent) "
sudo pacman -Q qbittorrent-nox  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# qBittorrent:
# https://www.qbittorrent.org/
# https://archlinux.org/packages/extra/x86_64/qbittorrent/
# qBittorrent ArchWiki:
# https://wiki.archlinux.org/title/QBittorrent
# Файл конфигурации создается при ~/.config/qBittorrent/qBittorrent.conf первом запуске программы.
# Если вы установите qbittorrent-nox , вы получите шаблон юнита systemd qbittorrent-nox@.service. QBittorrent будет работать от имени определенного пользователя, если вы включите/запустите , см. также [1] . qbittorrent-nox@username.service
# QBittorrent будет запущен от имени пользователя username. Папкой загрузки по умолчанию будет каталог пользователя Downloads, но это можно будет перенастроить позже.
# Если вы запускаете его как доступную службу, создайте пользователя с именем qbittorrent и запустите его под этим именем, а также перезапустите службу при выходе, так как в программе есть кнопка выхода.
# Для изменения настроек (например, порта) можно добавить переменную окружения (для порта это QBT_WEBUI_PORT), используя файл drop-in для его systemd unit. Запустите, qbittorrent-nox --helpчтобы узнать больше о других переменных окружения (эта информация не указана в руководстве).
# По умолчанию qBittorrent будет прослушивать все интерфейсы на порту 8080. Таким образом, он доступен по адресу http://HOST_IP:8080.
# Примечание: HTTPS по умолчанию не включен, поэтому https://HOST_IP:8080недоступен.
# Разрешить доступ без имени пользователя и пароля:
# В домашней среде часто желательно разрешить доступ к веб-интерфейсу без ввода имени пользователя и пароля. Это можно настроить в самом веб-интерфейсе после входа с использованием имени пользователя и пароля по умолчанию.
# Либо, чтобы избежать входа в систему в первый раз, добавьте этот раздел в ~/.config/qBittorrent/qBittorrent.conf:
# [Preferences]
# WebUI\AuthSubnetWhitelist=192.168.1.0/24
# WebUI\AuthSubnetWhitelistEnabled=true
# WebUI\UseUPnP=false
# Вышеуказанные элементы конфигурации будут:
# Разрешить клиентам, входящим в систему с адреса 192.168.1.x, получать доступ к веб-интерфейсу без необходимости ввода имени пользователя и пароля.
# Отключите UPnP для веб-интерфейса, чтобы веб-интерфейс не был доступен из-за пределов сети.
# После этого перезагрузите qbittorrent-nox@username.service.
# Обратитесь к вики qbittorrent : https://github.com/qbittorrent/qBittorrent/wiki/NGINX-Reverse-Proxy-for-Web-UI ; https://wiki.archlinux.org/title/QBittorrent
# Список известных тем qBittorrent: https://github.com/qbittorrent/qBittorrent/wiki/List-of-known-qBittorrent-themes
# Как использовать пользовательские темы пользовательского интерфейса - https://github.com/qbittorrent/qBittorrent/wiki/How-to-use-custom-UI-themes
#####################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Deluge (deluge)(deluge-gtk) — BitTorrent-клиент (GTK)?"
echo -e "${YELLOW}==> Предисловие! ${BOLD} *Deluge — полнофункциональный клиент BitTorrent для Linux, OS X, Unix и Windows. Он использует libtorrent в своем бэкэнде и имеет несколько пользовательских интерфейсов, включая: GTK+, веб и консоль. Он был разработан с использованием клиент-серверной модели с демон-процессом, который обрабатывает всю активность BitTorrent. Демон Deluge может работать на машинах без монитора, а пользовательские интерфейсы могут подключаться удаленно с любой платформы. Deluge — это полнофункциональное приложение BitTorrent, написанное на Python 3. Оно обладает множеством функций, включая, помимо прочего: модель клиент/сервер, поддержку DHT, magnet-ссылки, систему плагинов, поддержку UPnP, полнопотоковое шифрование, поддержку прокси и три различных клиентских приложения. Когда серверный демон запущен, пользователи могут подключаться к нему через консольный клиент, графический интерфейс на основе GTK или веб-интерфейс. Deluge не предназначен для какой-либо одной среды рабочего стола и будет отлично работать в GNOME, KDE, XFCE и других. Deluge является свободным программным обеспечением. Полный список функций можно просмотреть здесь (https://dev.deluge-torrent.org/wiki/About). Этот проект Лицензируется под Только GPL-3.0 с исключением cryptsetup-OpenSSL. ${NC}"
echo " Домашняя страница: https://deluge-torrent.org/ ; (https://github.com/deluge-torrent/deluge ; https://archlinux.org/packages/extra/any/deluge/ ; ). "
echo -e "${BLUE}:: ${NC}Функции: Deluge обладает широким спектром функций, включая: Разделение ядра и пользовательского интерфейса позволяет Deluge работать как демон. Веб-интерфейс: Пользовательский интерфейс консоли; GTK+ пользовательский интерфейс. Шифрование протокола BitTorrent: Основная линия DHT; Локальное обнаружение одноранговых сетей (также известное как LSD); Расширение протокола FAST; Пиринговый обмен µTorrent; UPnP и NAT-PMP; Поддержка прокси; Частные торренты; Глобальные и торрент-лимиты скорости; Настраиваемый планировщик пропускной способности; Защита паролем; RSS (через плагин)... И многое другое! "
echo -e "${CYAN}:: ${NC}Deluge обладает богатой коллекцией плагинов; фактически, большая часть функциональности Deluge доступна в виде плагинов. Deluge был создан с намерением быть легким и ненавязчивым. Мы считаем, что загрузка не должна быть основной задачей на вашем компьютере и, следовательно, не должна монополизировать системные ресурсы. Полный список плагинов можно найти на Deluge Wiki (https://deluge-torrent.org/plugins/ ; https://archlinux.org/packages/extra/any/deluge-gtk/). "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_deluge  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_deluge" =~ [^10] ]]
do
    :
done
if [[ $in_deluge == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_deluge == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Deluge (GTK) (deluge) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed libtorrent  # Библиотека BitTorrent с упором на высокую производительность ; https://archlinux.org/packages/extra/x86_64/libtorrent/ ; https://rakshasa.github.io/rtorrent/ ; 2025-09-05 14:30 UTC
sudo pacman -S --noconfirm --needed libtorrent-rasterbar  # Эффективная и полнофункциональная реализация библиотеки C++ BitTorrent ; https://archlinux.org/packages/extra/x86_64/libtorrent-rasterbar/ ; https://www.rasterbar.com/products/libtorrent/ ; 2025-05-02 22:28 UTC
############ deluge ##############
sudo pacman -S --noconfirm --needed deluge  # Клиент BitTorrent с несколькими пользовательскими интерфейсами в модели клиент/сервер ; https://archlinux.org/packages/extra/any/deluge/ ; https://deluge-torrent.org/ ; https://github.com/deluge-torrent/deluge ; https://wiki.archlinux.org/title/Deluge ; 2025-04-29 23:12 UTC
# sudo pacman -Rcns deluge  # Удалить утилиту
############ Зависимости необязательные для deluge-gtk ##############
### Обязательно ознакомьтесь с дополнительными зависимостями для клиента GTK deluge-gtk и установите их , чтобы включить уведомления рабочего стола и AppIndicator.
sudo pacman -S --noconfirm --needed libappindicator-gtk3  # (необязательно) — уведомления индикатора приложения ; Разрешить приложениям расширять меню с помощью индикаторов Ayatana в Unity, KDE или Systray (библиотека GTK+ 3) ; https://archlinux.org/packages/extra/x86_64/libappindicator-gtk3/ ; https://launchpad.net/libappindicator ; 2024-07-15 09:19 UTC
sudo pacman -S --noconfirm --needed libnotify  # (необязательно) — поддержка уведомлений на рабочем столе ; Библиотека для отправки уведомлений на рабочий стол ; https://archlinux.org/packages/extra/x86_64/libnotify/ ; https://gitlab.gnome.org/GNOME/libnotify ; Обеспечивает: libnotify.so=4-64 ; 2025-03-29 00:39 UTC
sudo pacman -S --noconfirm --needed python-pygame  # (необязательно) — звуковые уведомления ; Библиотека игр Python ; https://archlinux.org/packages/extra/x86_64/python-pygame/ ; http://www.pygame.org/ ; 2024-12-22 13:54 UTC
######### deluge-gtk #########
sudo pacman -S --noconfirm --needed deluge-gtk  # GTK UI для Deluge ; https://archlinux.org/packages/extra/any/deluge-gtk/ ; https://deluge-torrent.org/ ; https://github.com/deluge-torrent/deluge  ; https://wiki.archlinux.org/title/Deluge ; Заменяет: deluge<2.0.4.dev23+g2f1c008a2-2 ; Обязательно прочтите и установите необязательные зависимости для клиента gtk deluge-gtk, чтобы включить уведомления рабочего стола и уведомления appindicator.
# sudo pacman -Rcns deluge-gtk  # Удалить утилиту
  echo ""
  echo " Посмотрите информацию о версии (deluge) "
sudo pacman -Q deluge  #  Показать версию приложения
# deluge --version  # Показать версию приложения ; deluge -v
sleep 03
echo ""
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# Deluge:
# https://deluge-torrent.org/
# https://github.com/deluge-torrent/deluge
# https://github.com/deluge-torrent
# https://archlinux.org/packages/extra/any/deluge/
# https://archlinux.org/packages/extra/any/deluge-gtk/
# Deluge ArchWiki:
# https://wiki.archlinux.org/title/Deluge
# Полный список плагинов можно найти на Deluge Wiki.
# https://deluge-torrent.org/plugins/
# https://deluge-torrent.org/plugins/blocklist/
# Unix URL's of a local file:
# file:///home/username/the%20file.dat.gz
# file://localhost/home/username/the%20file.dat.gz
########################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить KTorrent (ktorrent) — Клиент BitTorrent для KDE (Qt)?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Для Linux доступно множество приложений BitTorrent. Но поиск хорошего приложения с множеством функций может сэкономить вам время. KTorrent от KDE — одно из таких приложений BitTorrent, созданное для Linux. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}KTorrent — это приложение BitTorrent от KDE, которое позволяет загружать файлы с использованием протокола BitTorrent. Оно позволяет запускать несколько торрентов одновременно и поставляется с расширенными функциями, что делает его полнофункциональным клиентом для BitTorrent. Поддерживает все основные возможности по скачиванию торрентов. *Примечание: По умолчанию программа может не загружать торренты с «rutracker». Для решения этой проблемы можно прописать прокси в настройках. Этот проект Лицензируется под GPL-2.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://apps.kde.org/ktorrent/ ; (https://github.com/KDE/ktorrent ; https://archlinux.org/packages/extra/x86_64/ktorrent/ ; https://wiki.archlinux.org/title/Ktorrent). "
echo -e "${BLUE}:: ${NC}Функции: Очередь торрентов; Глобальные и индивидуальные ограничения скорости торрентов; Предварительный просмотр определенных типов файлов, встроенный (видео и аудио); Импорт частично или полностью загруженных файлов; Приоритет файлов для многофайловых торрентов; Выборочная загрузка многофайловых торрентов; Выкидывать/банить пиров с помощью дополнительного диалогового окна IP-фильтра для целей составления списка/редактирования; Поддержка UDP-трекера; Поддержка приватных трекеров и торрентов; Поддержка обмена пиринговыми данными µTorrent; Поддержка шифрования протокола (совместимо с Azureus); Поддержка создания торрентов без трекеров; Поддержка распределенных хеш-таблиц (DHT, основная версия); Поддержка UPnP для автоматической переадресации портов в локальной сети с динамически назначаемыми хостами; Поддержка веб-сидов; Интеграция в системный трей; Поддержка аутентификации трекера; Подключение через прокси; Помимо встроенных функций, для KTorrent доступны некоторые плагины... И многое другое!  "
echo -e "${CYAN}:: ${NC}*Чтобы иметь возможность отображать любую информацию о файлах, сидах, личере и текущих трекерах, установите дополнительную зависимость geoip (https://archlinux.org/packages/extra/x86_64/geoip/). Рекомендуется включить DHT в настройках, чтобы избежать низкой скорости и малого количества сидов. *Важно регулярно обновлять программное обеспечение, чтобы поддерживать KTorrent в актуальном состоянии и оптимальную производительность. В зависимости от используемого метода установки, выполните следующие действия для обновления KTorrent и всех связанных системных пакетов. Для обеспечения полного обновления настоятельно рекомендуется использовать команды терминала, даже если в вашей рабочей среде включено автоматическое обновление. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_ktorrent  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_ktorrent" =~ [^10] ]]
do
    :
done
if [[ $in_ktorrent == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_ktorrent == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) KTorrent (Qt) (ktorrent) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed geoip # Библиотека и утилиты для преобразования IP-адресов стран без DNS на языке C ; https://archlinux.org/packages/extra/x86_64/geoip/ ; https://www.maxmind.com/app/c ; 2024-07-12 15:47 UTC
sudo pacman -S --noconfirm --needed geoip-database  # База данных стран GeoIP (на основе данных GeoLite2, созданных MaxMind) ;  https://archlinux.org/packages/extra/any/geoip-database/ ; https://mailfud.org/geoip-legacy/ ; 2025-01-29 18:17 UTC
sudo pacman -S --noconfirm --needed geoip-database-extra  # (необязательно) — базы данных городов/ASN (не требуются для поиска по странам) ; Базы данных GeoIP legacy city/ASN (на основе данных GeoLite2, созданных MaxMind) ; https://archlinux.org/packages/extra/any/geoip-database-extra/ ; https://mailfud.org/geoip-legacy/ ; 2025-01-29 18:17 UTC
sudo pacman -S --noconfirm --needed geoipupdate  #  (необязательно) — базы данных геолокации IP-адресов ; Обновление двоичных баз данных GeoIP2 и GeoIP Legacy от MaxMind ; https://archlinux.org/packages/extra/x86_64/geoipupdate/ ; https://github.com/maxmind/geoipupdate ; Обеспечивает: geoip2-database ; Заменяет: geoip2-database ; 2025-07-22 18:11 UTC
############ ktorrent ###########
sudo pacman -S --noconfirm --needed libktorrent  # Реализация протокола BitTorrent ; https://archlinux.org/packages/extra/x86_64/libktorrent/ ; https://apps.kde.org/ktorrent/ ; 2025-08-16 11:02 UTC
sudo pacman -S --noconfirm --needed libmaxminddb  # Библиотека базы данных MaxMindDB GeoIP2 ; https://archlinux.org/packages/extra/x86_64/libmaxminddb/ ; https://maxmind.github.io/libmaxminddb/ ; 2025-02-07 19:19 UTC
sudo pacman -S --noconfirm --needed ktorrent  # Мощный клиент BitTorrent для KDE ; https://apps.kde.org/ktorrent/ ; https://archlinux.org/packages/extra/x86_64/ktorrent/ ; https://pingvinus.ru/program/ktorrent ; https://github.com/KDE/ktorrent ; 2025-08-16 11:02 UTC
############# ktorrent-git #############
# yay -S ktorrent-git --noconfirm  # Мощный клиент BitTorrent. (Версия GIT) ; https://aur.archlinux.org/ktorrent-git.git (только для чтения, нажмите, чтобы скопировать) ; https://apps.kde.org/ktorrent ; https://aur.archlinux.org/packages/ktorrent-git ; Конфликты: с ktorrent ; 2025-03-15 19:10 (UTC) ; Требуется [kde-unstable], пока kf6 не попал в [extra]
  echo ""
  echo " Посмотрите информацию о версии (ktorrent) "
sudo pacman -Q ktorrent  #  Показать версию приложения
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
####### Справка ########
# KTorrent — клиент BitTorrent для KDE
# https://apps.kde.org/ktorrent/
# https://archlinux.org/packages/extra/x86_64/ktorrent/
# https://github.com/KDE/ktorrent
# https://github.com/kzahel/ktorrent
# https://github.com/humblenginr/ktorrent
# KTorrent ArchWiki:
# https://wiki.archlinux.org/title/Ktorrent
# Невозможно увидеть некоторые инструменты нижней панели.
# Чтобы иметь возможность отображать любую информацию о файлах, сидах, личере и текущих трекерах, установите дополнительную зависимость geoip . Рекомендуется включить DHT в настройках, чтобы избежать низкой скорости и малого количества сидов.
# Скрипт для управления в командной строке
# Поскольку KTorrent — это приложение только с графическим интерфейсом, к счастью, у него есть интерфейс DBUS, поэтому вы можете использовать скрипты для управления им в командной строке (т. е. из SSH). Подробности см. в следующем ответе на форуме linuxquestions (https://www.linuxquestions.org/questions/linux-software-2/terminal-commands-for-ktorrent-4175441715/#post4851070).
#########################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Fragments (fragments) — BitTorrent-клиент для Linux?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Если вы ищете более удобный пользовательский интерфейс со всеми необходимыми функциями для работы с торрентами, то вам стоит обратить внимание на это приложение. Fragments не стремится интегрировать как можно больше функций и настроек. Для этого существует множество других торрент-клиентов. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Fragments — это простой в использовании BitTorrent-клиент, соответствующий GNOME HIG (графической среды GNOME) и включающий продуманный функционал. Fragments можно использовать для передачи файлов по протоколу пирингового обмена файлами BitTorrent, например видео, музыки или установочных образов дистрибутивов Linux. Оно работает в Ubuntu, Fedora, Debian и других популярных дистрибутивах Linux. Бесплатная и с открытым исходным кодом программа. Язык программирования: GTK, Vala. Этот проект Лицензируется под GPL-3.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://apps.gnome.org/Fragments/ ; (https://github.com/bertob/Fragments ; https://github.com/ed10vi/fragments ; https://archlinux.org/packages/extra/x86_64/fragments/). "
echo -e "${BLUE}:: ${NC}Функции: Обзор всех торрентов, сгруппированных по состоянию. Планирование порядка загрузки с помощью очереди. Автоматическое обнаружение торрента или magnet-ссылок из буфера обмена. Управление и доступ к отдельным файлам торрента. Подключение к удаленным сеансам Fragments или Transmission. Fragments использует под капотом проект Transmission BitTorrent. "
echo -e "${CYAN}:: ${NC}Обзор: Имеет простой пользовательский интерфейс; Добавить торрент-файл можно: нажить Magnet-ссылку на веб-сайте, скопировать Magnet-ссылку в буфер обмена, выбрать торрент-файл в файловом менеджере; Есть возможность выбрать папку загрузки торрент-файлов; Имеется возможность выбрать количество активных загрузок; Поддержка уведомлений: включить/выключить при добавлении нового торрент-файла или его полной загрузки; Поддержка двух тем оформления: светлой и тёмной; Есть возможность выбрать режим шифрования соединения: разрешить шифрование, предпочесть шифрование, принудительное шифрование. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_fragments  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_fragments" =~ [^10] ]]
do
    :
done
if [[ $in_fragments == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_fragments == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Fragments (fragments) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed libtorrent  # Библиотека BitTorrent с упором на высокую производительность ; https://archlinux.org/packages/extra/x86_64/libtorrent/ ; https://rakshasa.github.io/rtorrent/ ; 2025-09-05 14:30 UTC
sudo pacman -S --noconfirm --needed transmission-cli  # (необязательно) — демон и веб-поддержка ; Быстрый, простой и бесплатный клиент BitTorrent (инструменты командной строки, демон и веб-клиент) ; https://archlinux.org/packages/extra/x86_64/transmission-cli/ ; http://www.transmissionbt.com/ ; 2025-06-15 12:33 UTC
########### fragments #############
sudo pacman -S --noconfirm --needed fragments  # BitTorrent-клиент для GNOME ; https://archlinux.org/packages/extra/x86_64/fragments/ ; https://apps.gnome.org/Fragments/ ; https://github.com/bertob/Fragments ; https://github.com/ed10vi/fragments ; Группы: gnome-circle ; 2025-07-24 22:53 UTC
  echo ""
  echo " Посмотрите информацию о версии (fragments) "
# fragments --version  # Показать версию приложения
sudo pacman -Q fragments  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Vuze — Azureus (vuze) — Продвинутый BitTorrent-клиент?"
echo -e "${MAGENTA}:: ${BOLD}Vuze (ранее Azureus) — чрезвычайно мощный и настраиваемый BitTorrent-клиент. Поиск и загрузка торрент-файлов. Воспроизводите, конвертируйте и перекодируйте видео и музыку для воспроизведения на многих устройствах, таких как PSP, Iso, XBox, PS3, iTunes (iPhone, ipad, Apple TV). Vuze свободное кроссплатформенное программное обеспечение для работы с файлообменными сетями по протоколу BitTorrent с поддержкой анонимного обмена данными по протоколам I2P, Tor и Nodezilla. Написан на языке Java. Функции графической оболочки выполняет библиотека SWT. Программа поддерживает все основные функции присущие Torrent-клиентам. Помимо этого поддерживается проигрывание медиа файлов прямо из программы (встроенный медиа-плеер, 1080p), есть встроенный поиск торрентов с различных ресурсов, поддерживаются различные механизмы для ускоренной загрузки торрентов. Обладает множеством разнообразных функций и возможностями по управлению заданиями. Этот проект Лицензируется под GPL. ${NC}"
echo " Домашняя страница: http://www.vuze.com/ ; (http://plugins.vuze.com/ ; https://aur.archlinux.org/packages/vuze). "
echo -e "${BLUE}:: ${NC}Среди возможностей можно отметить: определение скоростных ограничений на закачку, как для одного потока, так и для всех одновременно; продвинутые правила отбора; настройка дискового кэша; использование одного порта для всех потоков; возможность использования прокси для Tracker и Peer коммуникаций; быстрое восстановление прерванной загрузки; поддержка шифрации трафика для обхода защиты провайдеров, которые блокирует всю деятельность P2P сетей; возможность параллельного запуска нескольких копий для полной загрузки канала; удобный, настраиваемый пользовательский интерфейс; IRC плагин для быстрой помощи; мощная система организации доступа к файлам; многочисленные плагины, призванные существенно облегчить индивидуальную настройку программы. Полный перечень возможностей доступен на официальной странице программы (http://www.vuze.com/). Для запуска потребуется установить Java. "
echo -e "${CYAN}:: ${NC}Vuze позволяет перемещать или проигрывать медиа-файлы (посредством видео-потока) на различных устройствах (iPhone, iPod, iPad, Xbox 360, Playstation 3, PSP и TiVo). Достаточно просто перетащить файл мышкой на соответсвующий пункт меню в программе. Также программой можно управлять удаленно с Android устройства. Для этого существует специальное приложение — Vuze Remote. Разработчики считают, что это (цитата) "самое мощное в мире приложение для битторентовых сетей". Программа написана на языке Java и может работать в Linux, Windows и MacOS. "
echo -e "${CYAN}:: ${NC}Установка Vuze — Azureus (vuze), (vuze-plugin-countrylocator) и (vuze-plugin-mldht), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/vuze.git), (https://aur.archlinux.org/vuze-plugin-countrylocator.git), (https://aur.archlinux.org/vuze-plugin-mldht.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_vuze  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_vuze" =~ [^10] ]]
do
    :
done
if [[ $in_vuze == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_vuze == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Vuze — Azureus (vuze) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
######## vuze ###########
### Смотрите Зависимости! Для запуска потребуется установить Java.
yay -S vuze --noconfirm  # Многофункциональный клиент BitTorrent на базе Java (ранее назывался «Azureus») ; https://aur.archlinux.org/vuze.git  (только для чтения, нажмите, чтобы скопировать) ; https://sourceforge.net/projects/azureus/ ; https://aur.archlinux.org/packages/vuze ; 2021-09-26 14:50 (UTC)
######## vuze ###########
#git clone https://aur.archlinux.org/vuze.git   # (только для чтения, нажмите, чтобы скопировать)
#cd vuze
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf vuze
#rm -Rf vuze
######## vuze-extreme-mod ###########
# yay -S vuze-extreme-mod --noconfirm  # Модифицированная версия клиента Vuze BitTorrent с возможностью множественной подмены ; https://aur.archlinux.org/vuze-extreme-mod.git (только для чтения, нажмите, чтобы скопировать) ; http://www.sb-innovation.de/f41/ ; https://aur.archlinux.org/packages/vuze-extreme-mod ; http://downloads.sourceforge.net/azureus/vuze/Vuze_5750/Vuze_5750_linux.tar.bz2 ; http://www.sb-innovation.de/attachments/f41/17559d1488493507-vuze-extreme-mod-sb-innovation-5-7-5-0-vpem_5750-00.zip ; 2018-02-03 15:52 (UTC)
######## vuze-plugin-mldht ###########
yay -S vuze-plugin-mldht --noconfirm  # Плагин для альтернативной реализации распределенной хэш-таблицы (DHT), используемой µTorrent ; https://aur.archlinux.org/vuze-plugin-mldht.git (только для чтения, нажмите, чтобы скопировать) ; http://plugins.vuze.com/details/mlDHT ; https://aur.archlinux.org/packages/vuze-plugin-mldht ; http://plugins.vuze.com/plugins/mlDHT_1.5.9.jar ; 2017-02-04 18:37 (UTC)
######## vuze-plugin-mldht ###########
#git clone https://aur.archlinux.org/vuze-plugin-mldht.git   # (только для чтения, нажмите, чтобы скопировать)
#cd vuze-plugin-mldht
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf vuze-plugin-mldht
#rm -Rf vuze-plugin-mldht
######## vuze-plugin-countrylocator ###########
yay -S vuze-plugin-countrylocator --noconfirm  # Плагин для включения флагов стран на вкладке «Пирсы» ; https://aur.archlinux.org/vuze-plugin-countrylocator.git (только для чтения, нажмите, чтобы скопировать) ; http://plugins.vuze.com/details/CountryLocator ; https://aur.archlinux.org/packages/vuze-plugin-countrylocator ; http://plugins.vuze.com/plugins/CountryLocator_1.8.9.jar ; 2016-07-03 10:56 (UTC)
######## vuze-plugin-countrylocator ###########
#git clone https://aur.archlinux.org/vuze-plugin-countrylocator.git   # (только для чтения, нажмите, чтобы скопировать)
#cd vuze-plugin-countrylocator
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf vuze-plugin-countrylocator
#rm -Rf vuze-plugin-countrylocator
#####################
  echo ""
  echo " Посмотрите информацию о версии (vuze) "
sudo pacman -Q vuze  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############## Справка ###########
# Vuze (Azureus) - http://www.vuze.com/
#  Plugins - http://plugins.vuze.com/
###### Установка из архива ##########
# Для запуска потребуется установить Java.
# Я скачал с официального сайта архив с программой
# https://sourceforge.net/projects/azureus/
# wget https://downloads.sourceforge.net/azureus/vuze/Vuze_5760/Vuze_5760_linux.tar.bz2
# Далее необходимо его распаковать, для этого выполняем команду:
# Vuze_5760_linux.tar  (На момент написания) (можно переименовать в archive.tar)
# tar xvjf archive.tar.bz2
# tar xvjf archive.tar
# Перейти в директорию, в которую был распакован архив
# cd vuze
# И выполнить файл vuze:
# ./vuze
#######################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Tixati (tixati) — Torrent-клиент?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Tixati — торрент-клиент с закрытым исходным кодом для Linux и Windows, недавно выпустивший «совершенно новую и в некоторой степени экспериментальную» версию для устройств Android. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Tixati —  бесплатный torrent-клиент для Linux. Разработчики заявляют, что программа использует ультра-быстрые алгоритмы для загрузки торрентов и сверхэффективный выбор пиров. Поддерживаются необходимые функции для управления загрузками — изменение приоритета закачек, изменение скорости скачивания. Для каждого Torrent’а можно просмотреть множество дополнительной информации: скорость, различные графики, подробный список пиров и так далее. Tixati — это новая и мощная P2P-система. Программа поддерживает Magnet, DHT и PEX ссылки. Программа доступна для Linux и Windows. Также есть Portable версия, которая может запускаться с внешнего носителя (с флешки) без установки. Tixati не переведена на русский язык, но интерфейс не должен вызвать каких-либо сложностей. 100% бесплатная, простая и удобная в использовании Bittorrent-клиент. Этот проект Лицензируется под custom: tixati . ${NC}"
echo " Домашняя страница: http://www.tixati.com/ ; (https://aur.archlinux.org/packages/tixati ; https://github.com/tuskazi/tixati-guide). "
echo -e "${BLUE}:: ${NC}Функции: Tixati намного лучше остальных: Простота и удобство использования. Сверхбыстрые алгоритмы загрузки. Поддержка DHT, PEX и Magnet Link. Простая и быстрая установка — без Java и .net. Сверхэффективный выбор одноранговых узлов и блокировка. Шифрование соединения RC4 для дополнительной безопасности. Подробное управление пропускной способностью и построение графиков. UDP-подключения одноранговых узлов и устранение неполадок в маршрутизаторе NAT. Расширенные функции, такие как RSS, фильтрация IP-адресов, планировщик событий. НЕ СОДЕРЖИТ шпионских программ и рекламы (ОТСУТСТВИЕ ерунды)! Как настроить программу - (на English) https://www.tixati.com/optimize/ . "
echo -e "${CYAN}:: ${NC}*Если вы остались недовольны этим торрент-клиентом, безусловно, существуют более мощные BitTorrent-клиенты с гораздо более широким набором функций, такие как μTorrent или Tribler. Последний, например, предлагает дополнительную функцию анонимизации. Tixati же больше ориентируется на минимальную нагрузку на систему в своей работе. Тем не менее, программа включает в себя всё необходимое для скачивания через BitTorrent. "
echo -e "${CYAN}:: ${NC}Установка Tixati (tixati) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/tixati.git), (https://aur.archlinux.org/packages/tixati) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_tixati # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_tixati" =~ [^10] ]]
do
    :
done
if [[ $in_tixati == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_tixati  == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Tixati (tixati) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed traceroute  # Отслеживает маршрут пакетов по IP-сети ; https://archlinux.org/packages/extra/x86_64/traceroute/ ; http://traceroute.sourceforge.net/ ; 2024-11-30 07:57 UTC
########### gconf ###########
yay -S gconf --noconfirm  # (необязательно) – для интеграции оболочки ; Устаревшая система базы данных конфигурации ; https://aur.archlinux.org/packages/gconf ; https://aur.archlinux.org/gconf.git (только для чтения, нажмите, чтобы скопировать) ; https://gitlab.gnome.org/Archive/gconf ; git+https://gitlab.gnome.org/Archive/gconf.git#commit=0780809731c8ab1c364202b1900d3df106b28626 ; 2025-05-08 18:53 (UTC)
########### gconf ###########
#git clone https://aur.archlinux.org/youtube-dl.git  # (только для чтения, нажмите, чтобы скопировать)
#cd gconf
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gconf
#rm -Rf gconf
########### tixati ###########
yay -S tixati --noconfirm  # Tixati - это программа для однорангового обмена файлами, использующая популярный протокол BitTorrent ; https://aur.archlinux.org/packages/tixati ; https://aur.archlinux.org/tixati.git (только для чтения, нажмите, чтобы скопировать) ; http://www.tixati.com/ ; https://download.tixati.com/tixati-3.37-1.x86_64.manualinstall.tar.gz ; 2025-09-02 20:39 (UTC)
### По вашему запросу добавлена проверка GPG, подробности смотрите по ссылке https://support.tixati.com/Release%20Verification .
########### tixati ###########
#git clone https://aur.archlinux.org/tixati.git  # (только для чтения, нажмите, чтобы скопировать)
#cd tixati
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf tixati
#rm -Rf tixati
#####################
  echo ""
  echo " Посмотрите информацию о версии (tixati) "
sudo pacman -Q tixati  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# Tixati можно легко перевести на другие языки, используя простой языковой файл, который представляет собой текстовый файл, содержащий ключевые фразы и их переведенные эквиваленты.
# Языковой файл можно загрузить, нажав главную кнопку «Справка» и выбрав «Переключить язык» в меню.
# Чтобы найти языковые файлы или разместить свои собственные, посетите форум языков . 🔍 (https://support.tixati.com/language)(https://forum.tixati.com/languages)
# Русский перевод - Вариант "истинно русский" https://forum.tixati.com/languages/4
# Сначала загрузите прикрепленный файл .txt по ссылке выше
# 1) Обновите до последней версии
# 2) В главном окне нажмите на знак вопроса «?» -> Switch Language ( Переключить язык).
# 3) Нажмите на иконку папки и выберите файл Tixati-ru-poehali.txt (это же надо сделать для обновления перевода из изменённого файла)
# 4) Перезапустите Tixati
# Более полное описание перевода и его мотивации можно найти на форуме русскоязычного трекера (начиная с Ru, заканчивая tracker) в теме: «Tixati - продвинутый клиент для Windows и Linux», страница 9 (опубликовано всего несколько минут назад)
# Настраиваем Tixati: Как настроить программу - (на English) https://www.tixati.com/optimize/
#####################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Tribler (tribler-bin) — BitTorrent-клиент с функцией обнаружения P2P для Linux?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Tribler стремится предоставить анонимный доступ к контенту. Мы стремимся сделать конфиденциальность, надёжную криптографию и аутентификацию нормой интернета. С 2004 года мы работаем над тем, чтобы «единственный способ остановить Tribler — это остановить Интернет» (но одна-единственная ошибка в программном обеспечении может положить конец всему). Конфиденциальность с использованием нашей луковой маршрутизации, вдохновленной Tor . ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Tribler — BitTorrent-клиент, с открытым исходным кодом, который может быть использован для создания самодостаточной децентрализованной BitTorrent-сети, использующей p2p-коммуникации для прямого взаимодействия клиентов без применения централизованных звеньев. В частности, Tribler позволяет построить сеть без развертывания отдельных BitTorrent-трекеров и осуществляет поиск, адресацию и загрузки торрентов путём прямого взаимодействия клиентов между собой. Основной целью разработчиков Tribler является реализация надёжной BitTorrent сети, не зависящей от центрального сервера и обеспечения обмена файлами даже в случае отсутствия торрент-трекера. Tribler способен противостоять любому давлению извне, не завися от работоспособности торрент-сайтов, он не может быть отключен, заблокирован или подвергнут цензуре (как и любая P2P сеть). Этот проект Лицензируется под GPL3.0 . ${NC}"
echo " Домашняя страница: http://tribler.org/ ; (https://github.com/Tribler/tribler ; https://aur.archlinux.org/packages/tribler-bin). "
echo -e "${BLUE}:: ${NC}Возможности: Tribler обладает функцией поиска раздач и не требует внешнего веб-сайта или службы индексирования для обнаружения контента (когда пользователь вводит ключевое слово, в поисковом окне Tribler, поиск проводится и результаты выводятся не с централизованного сервера а непосредственно поступают от других пиров). Для удобства навигации существуют тематические контент-каналы. Весь доступный торрент контент для загрузки упорядочивается в так называемые "каналы", рейтинг которых определяется пользователями (функция совместной фильтрации). Для получения впервые списка каналов требуется некоторое время, в поиск следует вписать "CHANEL". Имеющееся у Tribler функция Open2Edit работает по принципу "Википедии", что позволяет пользователям изменять имена и описания для торрент-файлов в публичных каналах. Функция просмотра видео стрим потоком. connection - Работа с протоколами SOCKS (4 и 5) для обхода блокировок. anonymity - Использование от 1 (малая анонимность и большая скорость) до 3 (большая анонимность и меньшая скорость) промежуточных прокси-серверов, в роли которых будут выступают случайные участники сети. В теории некоторые прокси могут быть скомпрометированны, поэтому для большей анонимности следует выставлять большее кол-во прокси. The hidden seeder - сокрытие исходной точки с использованием оконечного шифрования. "
echo -e "${CYAN}:: ${NC}*Предупреждение: Вольный перевод на русский язык с официального сайта: 'Не подвергайте себя опасности. Наша технология анонимности еще не идеальна. Tribler не защищает вас от прослушки и правительственных учреждений. Мы стремимся защитить вас от цензуры и адвокатских исков. С помощью многих добровольцев мы постоянно развиваемся и совершенствуемся'. "
echo -e "${CYAN}:: ${NC}Установка Tribler (tribler-bin) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/tribler-bin.git), (https://aur.archlinux.org/packages/tribler-bin) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_tribler  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_tribler" =~ [^10] ]]
do
    :
done
if [[ $in_tribler == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_tribler == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Tribler (tribler-bin) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed libtorrent  # Библиотека BitTorrent с упором на высокую производительность ; https://archlinux.org/packages/extra/x86_64/libtorrent/ ; https://rakshasa.github.io/rtorrent/ ; 2025-09-05 14:30 UTC
######### tribler-bin ############
yay -S tribler-bin --noconfirm  # Клиент P2P/Bittorrent/YouTube ; https://aur.archlinux.org/packages/tribler-bin ; https://aur.archlinux.org/tribler-bin.git (только для чтения, нажмите, чтобы скопировать) ; http://tribler.org/ ; https://github.com/Tribler/tribler ; https://github.com/Tribler/tribler/releases/download/v8.2.3/Tribler_8.2.3_x64.deb ; Конфликты: tribler ; Обеспечивает: tribler ; 2025-08-07 07:03 (UTC)
######### tribler-bin ############
#git clone https://aur.archlinux.org/tribler-bin.git  # (только для чтения, нажмите, чтобы скопировать)
#cd tribler-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf tribler-bin
#rm -Rf tribler-bin
########################
  echo ""
  echo " Посмотрите информацию о версии (tribler) "
sudo pacman -Q tribler-bin  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# Часто задаваемые вопросы - FAQ
# https://www.tribler.org/faq.html
####################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Frostwire (frostwire) — Облачный загрузчик, BitTorrent-клиент и медиаплеер?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Прошу вас учесть, что зависимостью для этой утилиты Является: OpenJDK Java или OpenJRE Java (jdk-openjdk, jre-openjdk-headless или jdk-openjdk, jre-openjdk-headless), так как она написана на языке Java. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}FrostWire — свободный P2P-клиент для файлообменной сети Gnutella и BitTorrent. Программа написана на языке Java и является кроссплатформенным программным обеспечением, построенная на другом популярном клиенте Gnutella LimeWire. FrostWire является абсолютно бесплатной. Имеется бесплатная версия FrostWire для мобильных устройств на базе ОС Android, где его можно использовать для обмена файлами по Wi-Fi, которая официально называется FrostWire for Android. Мобильный FrostWire работает только в собственной P2P-сети MetaFrost, оптимизированной для функционирования в условиях ограниченных ресурсов и несовместимой с Gnutella и BitTorrent. Создатели позиционируют мобильную версию FrostWire как «первую мобильную P2P-сеть на Земле. Вы можете искать загруженные торренты прямо в приложении и воспроизводить их прямо там. Помимо загруженных файлов, приложение может просматривать локальные медиафайлы и упорядочивать их внутри плеера. То же самое относится и к версии для Android. Frostwire — впечатляющее торрент-приложение с открытым исходным кодом. Это больше, чем просто торрент-клиент, который вам стоит попробовать... Этот проект Лицензируется под GNU General Public License (GPL). ${NC}"
echo " Домашняя страница: http://www.frostwire.com/ ; (https://github.com/frostwire ; https://github.com/frostwire/frostwire/releases ; https://aur.archlinux.org/packages/frostwire). "
echo -e "${BLUE}:: ${NC}Функции: Некоторые особенности FrostWire для Linux: Встроенный поиск по торрентам — результаты отображаются прямо в интерфейсе приложения, разделённые по типу файла (аудио, видео и др.). Интегрированный медиаплеер — поддерживает различные форматы аудио и видео, позволяет воспроизводить загруженный контент без внешних приложений. Система обнаружения и группировки дубликатов — помогает поддерживать организованные загрузки, автоматически выявляя и управляя избыточными файлами. Поддержка magnet-ссылок — позволяет делиться и загружать файлы без необходимости использовать отдельные торрент-файлы. Управление библиотекой медиа — приложение автоматически сканирует указанные каталоги для файлов мультимедиа, создавая каталоги для поиска, организованные по типу файла, исполнителю, альбому или пользовательским категориям. Дополнительной функцией Frostwire является то, что он также предоставляет доступ к музыке исполнителей, распространяемой по лицензии Creative Commons. Вы можете скачать её и прослушать бесплатно. "
echo -e "${CYAN}:: ${NC}Возможности основной версии FrostWire: Полная совместимость и работа на Java-совместимой операционной системе. В отличие от LimeWire, которая распространялась в виде shareware и freeware версиях, FrostWire разрабатывается только как бесплатная альтернатива, которая поддерживается за счёт рекламных баннеров и опциональной панели инструментов для браузера. FrostWire включает в себя большую часть функциональных возможностей бесплатной версии LimeWire, а также некоторые из её платной версии, которые предоставляются разработчиками только за отдельную плату пользователям LimeWire. Вместо XMPP-чата LimeWire, в FrostWire используется онлайн-чат, недостатком которого являются отустствие возможности обмениваться файлами с «друзьями». Также, начиная с версии 4.13.1.7, в чат FrostWire была включена реклама, чтобы оплатить работу серверов. Все соединения зашифровываются с помощью алгоритма TLS для безопасной и надёжной работы. Работа с файлообменными сетями по протоколу BitTorrent с поддержой magnet-ссылок, UPnP, шифрованием обмена данными, поддержкой бестрекерных торрентов посредством DHT благодаря использованию в качестве движка Vuze. Внутренний поиск по легальным торрентам. "
echo -e "${CYAN}:: ${NC}Установка Frostwire (frostwire) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/frostwire.git), (https://aur.archlinux.org/packages/frostwire) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_frostwire  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_frostwire" =~ [^10] ]]
do
    :
done
if [[ $in_frostwire == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_frostwire == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Frostwire (frostwire) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed libtorrent  # Библиотека BitTorrent с упором на высокую производительность ; https://archlinux.org/packages/extra/x86_64/libtorrent/ ; https://rakshasa.github.io/rtorrent/ ; 2025-09-05 14:30 UTC
sudo pacman -S --noconfirm --needed mplayer  # (необязательно) – поддержка воспроизведения мультимедиа ; Медиаплеер для Linux ; https://archlinux.org/packages/extra/x86_64/mplayer/ ; http://www.mplayerhq.hu/ ; 2025-04-24 17:56 UTC
########### frostwire ###########
yay -S frostwire --noconfirm   # Облачный загрузчик, BitTorrent-клиент и медиаплеер ; https://aur.archlinux.org/packages/frostwire ; https://aur.archlinux.org/frostwire.git (только для чтения, нажмите, чтобы скопировать) ; http://www.frostwire.com/ ; https://github.com/frostwire/frostwire/releases/download/frostwire-desktop-6.13.2-build-321/frostwire-6.13.2.amd64.deb ; https://github.com/frostwire ; https://github.com/frostwire/frostwire/releases ; 2024-05-08 13:08 (UTC)
########### frostwire ###########
#git clone https://aur.archlinux.org/frostwire.git  # (только для чтения, нажмите, чтобы скопировать)
#cd frostwire
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf frostwire
#rm -Rf frostwire
###################
  echo ""
  echo " Посмотрите информацию о версии (frostwire) "
sudo pacman -Q frostwire  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Orion (orion-desktop) — Полный торрент-клиент и стример для Linux Desktop?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Это бесплатное приложение, некоторые функции ограничены или частично ограничены после истечения ознакомительного периода (15 дней); приложение полностью пригодно для использования даже после окончания ознакомительного периода. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Orion — мощный, легкий и быстрый BitTorrent-клиент с приятным пользовательским интерфейсом и возможностями самой быстрой потоковой передачи видео и аудио. Для максимального удобства пользователя Orion оснащен встроенным мощным бэкэндом медиаплеера, который очень легко интегрируется с Orion, обеспечивая наилучший пользовательский опыт при потоковой передаче медиафайлов по протоколу BitTorrent. Простой и интуитивно понятный интерфейс: клиент Orion-Torrent — это современный, удобный и простой в использовании интерфейс. Целью рабочего стола является создание аккуратного и хорошо организованного рабочего пространства, позволяющего пользователям сосредоточиться на работе без отвлекающих факторов. Чёткий интерфейс обеспечивает удобную навигацию и беспроблемную работу с торрентами. Лёгкий и эффективный: благодаря лёгкому и эффективному дизайну Orion потребляет меньше системных ресурсов, обеспечивая надёжную и быструю загрузку торрентов. Это гарантирует отсутствие проблем с производительностью или замедлений при загрузке торрентов. Кроссплатформенная совместимость: Orion-Torrent работает на Linux, Windows и macOS, предоставляя пользователям гибкие возможности для использования в различных операционных системах. Возможность использования одного и того же торрент-клиента на разных системах обеспечивает единообразие работы с торрентами. Этот проект Лицензируется под proprietary. ${NC}"
echo " Домашняя страница: https://snapcraft.io/orion-desktop ; (https://github.com/flathub/com.ktechpit.orion ; https://aur.archlinux.org/packages/orion-desktop). "
echo -e "${BLUE}:: ${NC}Основные возможности Orion Torrent Client & Streamer: Простой и удобный в использовании многофункциональный торрент-клиент. Сверхбыстрые алгоритмы загрузки, оптимизированные для бесперебойной потоковой передачи. Смотрите торренты, содержащие видео, аудио и изображения. Регулирование скорости для ограничения скорости загрузки и выгрузки для каждой задачи. Обменивайтесь файлами и папками с пользователями, размещая торрент-сервер (одноранговый обмен файлами/папками). Встроенный медиаплеер для потоковой передачи. Суперэффективный отбор и подавление сверстников. Многопоточный менеджер загрузок. Создает потоковый сервер, к которому можно получить доступ из других сервисов. Обнаружение пиров через серверы Tracker, DHT (распределенная хэш-таблица), локальное обнаружение пиров (LSD), обмен пирами (PEX), сети веб-сидов, протокол веб-торрентов с использованием webRTC. Создайте торрент, поделитесь хешем с другом, чтобы поделиться файлами. Открывает magnet-ссылки, Torrent-файлы и хэши Torrent. Блокировка приложения (никто не сможет получить доступ к приложению без установленного пароля). *Поддерживает плагины: - Torrent Host Server (создание и обмен файлами путем размещения торрента). Плагин поисковой системы Torrent. Плагин браузера фильмов Discover. Плагин проигрывателя и загрузчика YouTube. Плагин Torrent Meta (показывает краткий обзор выбранного торрента). Плагин менеджера истории (сохраняет открытые торренты для будущего использования). Есть еще много всего, что не буду здесь описывать, так как, по-моему, это уже слишком! "
echo -e "${CYAN}:: ${NC}Ключевые особенности: Orion Torrent Client предлагает широкий спектр удобных функций, которые выводят пользовательский опыт на совершенно новый уровень. Давайте рассмотрим некоторые из них: Варианты ввода: Поддерживаются различные способы ввода, такие как magnet-ссылки и торрент-файлы. Вы также можете делиться хэшами торрентов с друзьями для обмена файлами. Блокировка приложения: чтобы защитить ваши файлы и загрузки, вы также можете установить блокировку с помощью кода доступа при попытке открыть приложение. Одновременные загрузки: Orion-Torrent также использует передовые алгоритмы для поддержки сверхбыстрых загрузок и бесперебойной потоковой передачи. Загрузка также многопоточная, что позволяет приложению использовать всю мощь процессора, загружая файлы параллельно на сверхвысоких скоростях. Встроенный медиаплеер: Orion также позволяет вам напрямую просматривать изображения или воспроизводить аудио- и видеофайлы прямо в самом приложении. Регулирование скорости: вы также можете ограничивать и контролировать скорость загрузки и выгрузки для всех загрузок или даже для каждой загрузки отдельно. "
echo -e "${CYAN}:: ${NC}Установка Orion (orion-desktop) и (qt5-webkit), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/orion-desktop.git), (https://aur.archlinux.org/qt5-webkit.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_orion  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_orion" =~ [^10] ]]
do
    :
done
if [[ $in_orion == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_orion == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Orion (orion-desktop) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed mpv  # Бесплатный, открытый и кроссплатформенный медиаплеер ; https://archlinux.org/packages/extra/x86_64/mpv/ ; https://mpv.io/ ; Обеспечивает: libmpv.so=2-64 ; 2025-07-29 22:37 UTC
#sudo pacman -S --noconfirm --needed mpv-mpris  # Плагин MPRIS для MPV ; https://archlinux.org/packages/extra/x86_64/mpv-mpris/ ; https://github.com/hoyon/mpv-mpris ; 2024-11-07 20:02 UTC
#sudo pacman -S --noconfirm --needed mpv-shim-default-shaders  # Предварительно настроенный набор шейдеров MPV и конфигураций для медиа-клиентов MPV Shim ; https://archlinux.org/packages/extra/any/mpv-shim-default-shaders/ ; https://github.com/
sudo pacman -S --noconfirm --needed jq  # JSON-процессор командной строки ; https://archlinux.org/packages/extra/x86_64/jq/ ; https://jqlang.github.io/jq/ ; 2025-07-01 20:06 UTC
sudo pacman -S --noconfirm --needed squashfs-tools  # Инструменты для squashfs, высокосжатой файловой системы только для чтения для Linux ; https://archlinux.org/packages/extra/x86_64/squashfs-tools/ ; https://github.com/plougher/squashfs-tools ; 2025-08-20 21:39 UTC
########### qt5-webkit ###########
yay -S qt5-webkit --noconfirm  # Классы для реализации на базе WebKit2 и нового API QML ; https://aur.archlinux.org/packages/qt5-webkit?all_deps=1#pkgdeps ; https://aur.archlinux.org/qt5-webkit.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/qtwebkit/qtwebkit ; 2025-07-01 21:35 (UTC)
########### qt5-webkit ###########
#git clone https://aur.archlinux.org/qt5-webkit.git  # (только для чтения, нажмите, чтобы скопировать)
#cd qt5-webkit
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf qt5-webkit
#rm -Rf qt5-webkit
########### orion-desktop ###########
yay -S orion-desktop --noconfirm  # Мощный, легкий и быстрый BitTorrent-клиент с приятным пользовательским интерфейсом и возможностями самой быстрой потоковой передачи видео и аудио ; https://aur.archlinux.org/packages/orion-desktop ; https://aur.archlinux.org/orion-desktop.git (только для чтения, нажмите, чтобы скопировать) ; https://snapcraft.io/orion-desktop ; https://github.com/flathub/com.ktechpit.orion ; snap://api.snapcraft.io/v2/snaps/info/orion-desktop ; https://aur.archlinux.org/cgit/aur.git/tree/orion-desktop.desktop?h=orion-desktop ; https://aur.archlinux.org/cgit/aur.git/tree/orion-desktop.sh?h=orion-desktop ; https://aur.archlinux.org/cgit/aur.git/tree/snap-dlagent.sh?h=orion-desktop ; 2023-05-28 15:19 (UTC)
########### orion-desktop ###########
#git clone https://aur.archlinux.org/orion-desktop.git  # (только для чтения, нажмите, чтобы скопировать)
#cd orion-desktop
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf orion-desktop
#rm -Rf orion-desktop
#######################
  echo ""
  echo " Посмотрите информацию о версии (orion) "
sudo pacman -Q orion-desktop  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить rTorrent / ruTorrent (rtorrent) — Консольный BitTorrent клиент?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *BitTorrent (буквально «битовый поток») — сетевой протокол для множественного обмена файлами по одноранговой, децентрализованной сети (такая сеть называется пиринговая, от peer — равный в правах или P2P), файлы передаются частями, каждый torrent-клиент является и torrent-сервером, получая (скачивая) эти части и в то же время отдаёт (закачивает) их другим клиентам, тем самым снижается нагрузка и обеспечивает избыточность данных. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}RTorrent — нетребовательный к системным ресурсам C++ / Ncurses (Curses) консольный BitTorrent клиент, на основе библиотеки libTorrent. Клиент достаточно сложен для использования неподготовленными пользователями, но для него существует большое количество интерфейсов значительо упрощающих использование клиента и позволяющих управлять им локально или удаленно через протокол XML-RPC (на сайте проекта имеется список наиболее популярных). Использует текстовый интерфейс (ncurses). rTorrent отличает высокая производительность. Для управления программой используются горячие клавиши. Настройки программы задаются в файле ~/.rtorrent.rc . Поддерживается работа в режиме демона, без интерфейса. Управление осуществляется через XML-RPC (Extensible Markup Language Remote Procedure Call). Этот проект Лицензируется под GPL-2.0 или более поздняя версия, GPL-3.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://rakshasa.github.io/rtorrent/ ; (https://rakshasa.github.io/rtorrent ; https://github.com/Novik/ruTorrent ; https://archlinux.org/packages/extra/x86_64/rtorrent/ ; https://archlinux.org/packages/extra/x86_64/libtorrent/). "
echo " Домашняя страница: https://github.com/Novik/ruTorrent ; (https://aur.archlinux.org/packages/rutorrent ; https://aur.archlinux.org/packages/rutorrent-git)."
echo -e "${BLUE}:: ${NC}ruTorrent — это PHP- интерфейс/веб-интерфейс для rTorrent (консольного BitTorrent-клиента) расширяемый плагинами. Для взаимодействия с rTorrent он использует встроенный XML-RPC-сервер. Он легкий, с большой функциональностью и внешне похож на uTorrent. Если вы хотите использовать версию, находящуюся в разработке, установите: rutorrent-git . По умолчанию файлы конфигурации имеют символические ссылки на /etc/webapps/rutorrent/conf. После установки ruTorrent полезно сразу же установить несколько плагинов (наиболее востребованные: choose, datadir, erasedata, tracklabels), про плагины хорошо описано в wiki разделе (https://github.com/Novik/ruTorrent/wiki). Основные характеристики: Облегченная серверная часть, поэтому ее можно установить на старых и недорогих серверах и даже на некоторых маршрутизаторах SOHO. Расширяемость — есть несколько плагинов, и каждый может создать свой собственный.Хороший вид :)  "
echo -e "${CYAN}:: ${NC}mkTorrent — простая утилита командной строки для создания метаданных BitTorrent. Она протестирована в Linux, OSX , MinGW, OpenBSD и SunOS, но должна работать и во многих других POSIX- совместимых операционных системах. *Особенности последней версии: Просто и быстро создает файл метаинформации BitTorrent из файла или каталога. Поддерживает несколько трекеров. Можно добавить пользовательский комментарий в файл метаинформации. Можно добавить частный флаг, чтобы запретить DHT и Peer Exchange. Можно добавлять URL-адреса веб-источников. Хеширование может выполняться в многопоточном режиме и поддерживает несколько процессоров. Нет явной поддержки преобразования имён файлов в UTF -8. Считывает и записывает имена файлов и комментарии точно так, как сообщает ОС. "
echo -e "${CYAN}:: ${NC}Установка ruTorrent (rutorrent) и (rutorrent-git), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/rutorrent.git), (https://aur.archlinux.org/rutorrent-git.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_rtorrent  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_rtorrent" =~ [^10] ]]
do
    :
done
if [[ $in_rtorrent == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_rtorrent == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) RTorrent (rtorrent) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
######## rtorrent #########
sudo pacman -S --noconfirm --needed libtorrent  # Библиотека BitTorrent с упором на высокую производительность ; https://archlinux.org/packages/extra/x86_64/libtorrent/ ; https://rakshasa.github.io/rtorrent/ ; https://github.com/rakshasa/rtorrent-archive/raw/master/libtorrent-0.15.7.tar.gz ; 2025-09-05 14:30 UTC
sudo pacman -S --noconfirm --needed rtorrent  # Клиент Ncurses BitTorrent на основе libTorrent ; https://archlinux.org/packages/extra/x86_64/rtorrent/ ; https://rakshasa.github.io/rtorrent/ ; https://github.com/rakshasa/rtorrent-archive/raw/master/rtorrent-0.15.7.tar.gz ;  2025-09-05 14:30 UTC
########## lighttpd #############
sudo pacman -S --noconfirm --needed lighttpd  # Безопасный, быстрый, совместимый и очень гибкий веб-сервер ; https://archlinux.org/packages/extra/x86_64/lighttpd/ ; https://www.lighttpd.net/ ; 2025-08-18 08:49 UTC
sudo pacman -S --noconfirm --needed php  # Универсальный язык сценариев, особенно подходящий для веб-разработки ; https://archlinux.org/packages/extra/x86_64/php/ ; https://www.php.net/ ; Разделенные пакеты: php-apache , php-cgi , php-dblib , php-embed , php-enchant ; Обеспечивает: php-interpreter=8.4, php-intl=8.4.12 ; Заменяет: php-intl ; Конфликты: php-intl ; 2025-08-27 06:31 UTC
sudo pacman -S --noconfirm --needed php-cgi  # CGI и FCGI SAPI для PHP ; https://archlinux.org/packages/extra/x86_64/php-cgi/ ; https://www.php.net/ ; Обеспечивает: php-cgi-interpreter=8.4 ;  2025-08-27 06:31 UTC
sudo pacman -S --noconfirm --needed fcgi  # FASTCgi (fcgi) — это независимое от языка, высокопроизводительное расширение CGI ; https://archlinux.org/packages/extra/x86_64/fcgi/ ; https://github.com/FastCGI-Archives/fcgi2 ; 28.04.2025 14:37 UTC
############## mediainfo ###########
sudo pacman -S --noconfirm --needed mediainfo  # (необязательно) — для просмотра информации о медиафайлах ; Предоставляет техническую и теговую информацию о медиафайлах (интерфейс CLI) ; https://archlinux.org/packages/extra/x86_64/mediainfo/ ; https://mediaarea.net/ ; 2025-07-30 00:29 UTC
sudo pacman -S --noconfirm --needed ffmpeg  # Комплексное решение для записи, преобразования и потоковой передачи аудио и видео ; https://archlinux.org/packages/extra/x86_64/ffmpeg/ ; https://ffmpeg.org/ ; Обеспечивает: libavcodec.so=61-64, libavdevice.so=61-64, libavfilter.so=10-64, libavformat.so=61-64, libavutil.so=59-64 ; 2025-07-17 06:59 UTC
#### Терминальные мультиплексор #########
#sudo pacman -S --noconfirm --needed screen  # Полноэкранный оконный менеджер, который мультиплексирует физический терминал ; https://archlinux.org/packages/extra/x86_64/screen/ ; https://www.gnu.org/software/screen/ ; 29.05.2025 05:00 UTC
sudo pacman -S --noconfirm --needed tmux  # Терминальный мультиплексор ; https://archlinux.org/packages/extra/x86_64/tmux/ ; https://github.com/tmux/tmux/wiki ; 2024-10-06 17:55 UTC
  echo ""
  echo " Посмотрите информацию о версии (rtorrent) "
# rtorrent --version  # Показать версию приложения
sudo pacman -Q rtorrent  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
echo ""
echo -e "${BLUE}:: ${NC}Установить ruTorrent (rutorrent) — Веб-интерфейс для rTorrent?"
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить ruTorrent (rutorrent),   2 - Установить ruTorrent (rutorrent-git),

    0 - НЕТ - Пропустить установку: " in_rutorrent  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_rutorrent" =~ [^120] ]]
do
    :
done
if [[ $in_rutorrent == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_rutorrent == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) ruTorrent (rutorrent) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed coreutils  # Основные утилиты для работы с файлами, оболочками и текстом операционной системы GNU ; https://archlinux.org/packages/core/x86_64/coreutils/ ; https://www.gnu.org/software/coreutils/ ; 2025-04-11 08:30 UTC
######### mod_scgi ##########
#yay -S mod_scgi --noconfirm  # (необязательно) – для протокола SCGI ; Альтернатива простому общему интерфейсу шлюза ; https://aur.archlinux.org/packages/mod_scgi ; https://aur.archlinux.org/mod_scgi.git (только для чтения, нажмите, чтобы скопировать) ; http://python.ca/scgi/ ; http://python.ca/scgi/releases/scgi-2.2.tar.gz ; 2022-07-30 21:35 (UTC)
######### mod_scgi ##########
#git clone https://aur.archlinux.org/mod_scgi.git  # (только для чтения, нажмите, чтобы скопировать)
#cd mod_scgi
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf mod_scgi
#rm -Rf mod_scgi
######### rutorrent ##########
yay -S rutorrent --noconfirm  # Еще один веб-фронтенд для rTorrent ; https://aur.archlinux.org/packages/rutorrent ; https://aur.archlinux.org/rutorrent.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/Novik/ruTorrent ; https://github.com/Novik/ruTorrent/archive/v5.2.10.tar.gz ; Конфликты: rutorrent-plugins ; 2025-06-19 01:55 (UTC)
######### rutorrent ##########
#git clone https://aur.archlinux.org/rutorrent.git  # (только для чтения, нажмите, чтобы скопировать)
#cd rutorrent
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf rutorrent
#rm -Rf rutorrent
####################
  echo ""
  echo " Посмотрите информацию о версии (rutorrent) "
sudo pacman -Q rutorrent  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_rutorrent == 2 ]]; then
  echo ""
  echo " Установка утилиты (пакета) ruTorrent (rutorrent-git) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed mktorrent  # Простая утилита командной строки для создания файлов метаинформации BitTorrent ; https://archlinux.org/packages/extra/x86_64/mktorrent/ ; https://github.com/pobrn/mktorrent ; https://github.com/pobrn/mktorrent/wiki ; 2024-05-01 15:21 UTC
######### rutorrent-git ##########
yay -S rutorrent-git --noconfirm  # Веб-интерфейс для rTorrent на PHP, разработанный по образцу uTorrent ; https://aur.archlinux.org/packages/rutorrent-git ; https://aur.archlinux.org/rutorrent-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/Novik/ruTorrent ; git+https://github.com/Novik/ruTorrent.git ; Конфликты: с rutorrent, rutorrent-plugins ; Обеспечивает: rutorrent, rutorrent-plugins ; 2024-05-31 07:32 (UTC)
######### rutorrent-git ##########
#git clone https://aur.archlinux.org/rutorrent-git.git  # (только для чтения, нажмите, чтобы скопировать)
#cd rutorrent-git
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf rutorrent-git
#rm -Rf rutorrent-git
#######################
  echo ""
  echo " Посмотрите информацию о версии (rutorrent) "
sudo pacman -Q rutorrent-git  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
fi
############# Справка ##############
# RTorrent/RuTorrent - ArchWikiж
# https://wiki.archlinux.org/title/RTorrent/RuTorrent
# Установка и настройка ruTorrent
# https://github.com/Novik/ruTorrent/wiki/Config
# RTorrent (rtorrent):
# https://rakshasa.github.io/rtorrent/
# https://github.com/Novik/ruTorrent
# https://rakshasa.github.io/rtorrent
# https://archlinux.org/packages/extra/x86_64/rtorrent/
# https://archlinux.org/packages/extra/x86_64/libtorrent/
# ruTorrent (rutorrent) веб-фронтенд для rTorrent:
# https://github.com/Novik/ruTorrent
# https://aur.archlinux.org/rutorrent.git
# https://aur.archlinux.org/packages/rutorrent
# https://aur.archlinux.org/packages/rutorrent-git
# https://aur.archlinux.org/rutorrent-git.git
### Вот некоторые полезные привязки клавиш rTorrent и их соответствующее использование:
# CTRL + Q  – Выход из приложения rTorrent.
# CTRL + S  – Запуск загрузки.
# CTRL + D  – Остановка активной загрузки или удаление уже остановленной загрузки.
# CTRL + K – Остановить и закрыть активную загрузку.
# CTRL + R  – Проверка хэша торрента перед началом загрузки/выгрузки.
# CTRL + Q – При двойном выполнении этой комбинации клавиш rTorrent выключается без отправки сигнала остановки.
# <–  – Перенаправление на предыдущий экран.
# –>  – Перенаправление на следующий экран.
####################################









sleep 03

clear
echo -e "${CYAN}
  <<< Обновление информации о шрифтах >>> ${NC}"
# Updating font information and creating a backup of grub.cfg and grub files.

echo ""
echo -e "${BLUE}:: ${NC}Обновим информацию о шрифтах"
#echo 'Обновим информацию о шрифтах'
# Update information about fonts
sudo fc-cache -f -v

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
# sudo rm -rf ~/archmy3l  # Если скрипт не был перемещён в другую директорию
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
echo " Установка завершена для выхода введите >> exit << "
#exit(0)  # означает чистый выход без каких-либо ошибок (проблем)
#exit(1)  # означает, что была какая-то ошибка (проблема), и именно поэтому программа выходит
#exit
#fi
#clear
# Успех
#Success
#echo "Установка завершена! Перезагрузить."
#echo "Installation complete! Reboot."
##### Шпаргалка запуска необходимых служб #####
### sudo systemctl enable NetworkManager
### sudo systemctl enable bluetooth
### sudo systemctl enable cups.service
### sudo systemctl enable sshd
### sudo systemctl enable avahi-daemon
### sudo systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
### sudo systemctl enable reflector.timer
### sudo systemctl enable fstrim.timer
### sudo systemctl enable libvirtd
### sudo systemctl enable firewalld
### sudo systemctl enable acpid
###**************************
### sudo systemctl disable NetworkManager-wait-online.service
### sudo systemctl disable lvm2-monitor.service
### sudo systemctl disable bluetooth.service
### sudo systemctl disable ModemManager.service
### sudo systemctl disable smartmontools.service
### sudo systemctl disable motd-news.service
### sudo systemctl disable vboxautostart-service
###-------------------------------------------------
### end of script