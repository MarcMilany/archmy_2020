#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! ####
apptitle="Arch Linux Fast Install v2.5 LegasyBIOS - Version: 2025.06.17.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя
###
USB_DVD_PROG_LANG="russian"  # Installer default language (Язык установки по умолчанию)
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
  <<< Установка утилит (пакетов) для Создание загрузочных Live USB-накопителей в Archlinux 🔌💾 📀 >>> ${NC}"
# Installing utilities (packages) for Creating Bootable Live USB drives in Archlinux
########
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Impression (impression) — Создание загрузочных дисков?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Linux предлагает гамму небольших утилит с открытым исходным кодом, которые выполняют функции от обыденных до замечательных. По нашему мнению, именно широта этих инструментов помогает сделать Linux привлекательной операционной системой. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Impression — это приложение для создания загрузочных дисков (записи образов) на Linux. Позволяет загружать ISO-образы операционных систем и записывать их на USB-накопители. Impression — минималистичная программа для создания загрузочных носителей. Он позволяет с лёгкостью записать образ на диск. Нет никаких дополнительных или лишних функций. Только возможность загрузки образа дистрибутива Linux из списка из сети для последующей записи на накопитель. С легкостью записывайте образы на свои диски. Выберите образ, вставьте диск, и все готово! Impression — полезный инструмент как для заядлых любителей дистрибутивов, так и для обычных пользователей компьютеров. ${NC}"
echo " Домашняя страница: https://apps.gnome.org/Impression/ ; (https://archlinux.org/packages/extra/x86_64/impression/). "
echo -e "${BLUE}:: ${NC}Impression — это бесплатное программное обеспечение с открытым исходным кодом. Информация о программе: Язык интерфейса: Русский ; Разработчик: Khaleel Al-Adhami ; Лицензия: GPL v3 ; Сайт программы: apps.gnome.org/ru/Impression . "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_impression  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_impression" =~ [^10] ]]
do
    :
done
if [[ $in_impression == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_impression == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Impression (impression) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########## impression ###########
sudo pacman -S --noconfirm --needed impression  # Приложение для создания загрузочных дисков из образов дисков ; https://apps.gnome.org/Impression/ ; https://archlinux.org/packages/extra/x86_64/impression/ ; 2025-09-02 09:29 UTC
  echo ""
  echo " Посмотрите информацию о версии (impression) "
sudo pacman -Q impression  # Показать версию приложения
sleep 03

echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Gnome Multi-Writer (gnome-multi-writer) — Записать файл ISO на несколько USB-устройств?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Заставить инструмент MultiWriter работать на Linux очень просто, независимо от того, какой дистрибутив Linux вы используете, поскольку он считается частью проекта Gnome. Чтобы установить приложение, откройте терминал и следуйте инструкциям, соответствующим вашей операционной системе. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Gnome Multi-Writer — простой инструмент, позволяющий пользователям записывать один ISO-образ на несколько съемных USB-устройств одновременно. Вам нужно записать несколько USB-устройств одновременно? Встречайте GNOME-multi-writer — эффективный инструмент, который может успешно записывать несколько USB-флешек одновременно. Нет предела тому, сколько дисков он может обработать. Единственное ограничение — размер файла — от 1 ГБ до 32 ГБ, не больше. Небольшое замечание: убедитесь, что ваши USB-накопители достаточно большие для правильного размещения данных. Gnome Multi-Writer является частью проекта Gnome, поэтому программное обеспечение должно быть легко установить даже на самых малоизвестных дистрибутивах Linux. Тем не менее, если вы не можете его найти, проект имеет свой код, легко доступный в Интернете. ${NC}"
echo " Домашняя страница: https://wiki.gnome.org/Apps/MultiWriter ; (https://archlinux.org/packages/extra/x86_64/gnome-multi-writer/). "
echo -e "${BLUE}:: ${NC}Как записывать на несколько USB-накопителей одновременно в Linux с помощью Gnome MultiWriter: Перед записью чего-либо с помощью Gnome MultiWriter вам понадобится образ ОС. Загрузите образ ОС по вашему выбору на свой ПК с Linux и откройте приложение Gnome MultiWriter. Внутри Gnome MultiWriter щелкните значок меню в верхней левой части окна. Найдите опцию «Импорт ISO» и выберите ее. Выбор опции «Импорт ISO» откроет окно просмотра файлов и позволит пользователю выбрать образ ОС для использования в процессе записи. Используйте окно браузера файлов для поиска вашего образа ISO и нажмите кнопку «Импорт», чтобы загрузить его. Импортировав образ ISO в Gnome MultiWriter, можно безопасно подключать все USB-устройства. Когда все USB-устройства подключены и готовы, нажмите кнопку «Начать копирование», чтобы начать процесс записи. "
echo -e "${CYAN}:: ${NC}Запись файлов IMG: Вы можете захотеть записать файл образа ОС (IMG) на USB-устройство. Изначально это невозможно сделать с помощью Gnome MultiWriter, поскольку он поддерживает только файлы ISO. Тем не менее, если вам абсолютно необходимо записать файл IMG, есть простой способ: конвертировать IMG в ISO. В настоящее время лучшим способом конвертации файла IMG в ISO в Linux является использование программы CCD2ISO. К сожалению, приложение CCD2ISO не предустановлено ни в одном дистрибутиве Linux, поэтому вам придется установить его. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_multiwriter  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_multiwriter" =~ [^10] ]]
do
    :
done
if [[ $in_multiwriter == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_multiwriter == 1 ]]; then
echo ""
echo " Установка утилиты (пакета) Gnome Multi-Writer (gnome-multi-writer) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########### gnome-multi-writer ############
sudo pacman -S --noconfirm --needed gnome-multi-writer  # Записать файл ISO на несколько USB-устройств одновременно ; https://archlinux.org/packages/extra/x86_64/gnome-multi-writer/ ; https://wiki.gnome.org/Apps/MultiWriter ; 2025-07-21 08:08 UTC
######### Запись файлов IMG ##########
sudo pacman -S --noconfirm --needed ccd2iso  # Конвертирует образы CCD/IMG CloneCD в формат ISO ; https://archlinux.org/packages/extra/x86_64/ccd2iso/ ; https://sourceforge.net/projects/ccd2iso ; 2024-07-06 20:12 UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############## Справка ##############
# Чтобы выбрать свой ISO, перейдите в меню >> Импорт файла ISO.
# После выбора вы увидите имя ISO в верхней строке.
# Теперь просто подключите все свои флеш-накопители к ПК.
# После того, как все подключено, просто нажмите «Начать копирование». Обратите внимание, что все имеющиеся данные на ваших USB-накопителях будут потеряны, поэтому убедитесь, что там нет важных файлов.
# Вуаля! На всех ваших USB-накопителях одинаковые данные.
# ---------------------------------------------------------
# Generic Linux:
# Нужен CCD2ISO и на менее известном дистрибутиве Linux? Не волнуйтесь, у разработчика есть загружаемый архив Tar приложения на SourceForge. Чтобы получить его, (https://sourceforge.net/projects/ccd2iso/files/OldFiles/ccd2iso.tar.gz/download) перейдите на эту страницу и загрузите архив Tar. Затем откройте терминал и извлеките архив.
# cd ~/Загрузки
# tar -zxvf ccd2iso.tar.gz
# cd ~/Downloads
# tar -zxvf ccd2iso.tar.gz
# Конвертировать IMG в ISO:
# Установив приложение CCD2ISO на свой ПК с Linux, откройте терминал и введите следующую команду:
# ccd2iso ~/location/of/img.img имя-нового-iso-файла.iso
# ccd2iso ~/location/of/img.img name-of-new-iso-file.iso
# Конвертация необработанного файла IMG в файл ISO занимает время, поэтому будьте терпеливы. Когда процесс завершится, смонтируйте файл ISO. Эта часть процесса конвертации не является обязательной, но ее выполнение позволит вам подтвердить, что процесс конвертации прошел успешно и что файлы доступны.
# Чтобы смонтировать ISO, выполните следующие действия:
# mkdir ~/Desktop/iso-mount
# mount -o loop имя-нового-iso-файла.iso ~/Desktop/iso-mount
# mkdir ~/Desktop/iso-mount
# mount -o loop name-of-new-iso-file.iso ~/Desktop/iso-mount
# Убедитесь, что содержимое ISO-образа доступно для просмотра в Linux, переместив терминал в папку iso-mount .
# cd ~/Рабочий стол/iso-mount
# cd ~/Desktop/iso-mount
# Просмотрите содержимое ISO с помощью ls .
# ls
# Если все в порядке, отмонтируйте ISO-файл и удалите папку монтирования.
# umount ~/Desktop/iso-mount
# rmdir ~/Desktop/iso-mount
# Завершите процесс, открыв Gnome MultiWriter и записав ISO-образ на USB-накопитель.
# -----------------------------------------------------------
# Использование GNOME-multi-writer
# Этот инструмент может записывать только файлы ISO. Это значит, что этот инструмент также отлично подходит для записи ISO системы, например, установочного образа дистрибутивов Linux.
# Если у вас есть файл образа IMG – raw, вам нужно сначала преобразовать его в ISO. Используйте «ccd2iso» для его преобразования. Командная строка будет выглядеть так –
# ccd2iso /путь/к/имя_файла.img/назначение/путь/имя_файла.iso
# Если хотите, можете даже сделать ISO вашей важной папки! Выполните следующую команду –
# mkisofs -o <имя_iso_файла>.iso /home/<имя_пользователя>/папка
# После того, как вы готовы с вашим ISO-файлом, пришло время записать образ. Запустите инструмент –
# sudo gnome-multi-writer
###########################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить balenaEtcher (Etcher) (balena-etcher) — Устройство записи на USB и SD-карты?"
echo -e "${MAGENTA}:: ${BOLD}Etcher — это относительно новый кроссплатформенный инструмент для записи образов с открытым исходным кодом от Balena, разработанный с использованием JS, HTML, node.js и фреймворка GitHub Electron. Он поддерживает запись образов IMG и ISO на карты SD и USB. Приложение в основном используется для создания загрузочных USB-накопителей или SD-карт, а его удобный интерфейс упрощает процесс и делает его доступным даже для людей с ограниченными техническими знаниями. Этот проект Лицензируется под Apache-2.0. ${NC}"
echo " Домашняя страница: https://etcher.io/ ; (https://balena.io/etcher ; https://aur.archlinux.org/packages/balena-etcher). "
echo -e "${BLUE}:: ${NC}Основные возможности Etcher: Проверка целостности носителя. Больше никаких записей образов на поврежденных картах памяти и гаданий, почему устройство не загружается. Удобный интерфейс для выбора носителя. Обеспечивает наглядность выбора носителя для записи, чтобы избежать стирание всего жесткого диска. Открытый исходный код. Приложение сделано на JS, HTML, node.js и Electron. Преимущества Etcher. Скорость записи до 50%, одновременная запись на несколько дисков. Разработчик: Balena (Международная команда). Лицензия: Бесплатно (Apache License 2.0). Интерфейс: английский. Категория: Загрузка и установка ОС. Размер: зависит от платформы. "
echo -e "${CYAN}:: ${NC}Создание установочного носителя для выбранной операционной системы должно быть быстрой и простой задачей, особенно если вы записываете образ на загрузочный флеш-диск или SD карту. balenaEtcher (Etcher) – это кроссплатформенное приложение, которое позволяет записывать образы ОС на SD карты и съемные USB-носители как можно более непосредственно и, следовательно, помогает вам избежать сложных процедур. Приложение Etcher – простое для конечных пользователей, расширяемое для разработчиков и работающее на любой платформе: Windows, MacOS и Linux. "
echo -e "${CYAN}:: ${NC}Установка balenaEtcher (balena-etcher) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/balena-etcher.git), (https://aur.archlinux.org/packages/balena-etcher) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить balenaEtcher (Etcher) (balena-etcher),   0 - НЕТ - Пропустить установку: " in_etcher # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_etcher" =~ [^10] ]]
do
    :
done
if [[ $in_etcher == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_etcher == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) balenaEtcher (Etcher) (balena-etcher) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
############### Зависимости ###############
#sudo pacman -S --noconfirm --needed nodejs-lts-jod  # Событийный ввод-вывод для V8 javascript (выпуск «Active LTS»: Jod) ; https://archlinux.org/packages/extra/x86_64/nodejs-lts-jod/ ; https://nodejs.org/ ; Конфликты: с nodejs ; 2025-05-24 14:38 UTC
sudo pacman -S --noconfirm --needed moreutils  # Растущая коллекция инструментов Unix, которые никто не догадался написать тридцать лет назад ; https://archlinux.org/packages/extra/x86_64/moreutils/ ; https://joeyh.name/code/moreutils/ ; Заменяет: moreutils-svn ; 2024-12-11 19:01 UTC
sudo pacman -S --noconfirm --needed libnotify  # Библиотека для отправки уведомлений на рабочий стол ; https://archlinux.org/packages/extra/x86_64/libnotify/ ; https://gitlab.gnome.org/GNOME/libnotify ; Обеспечивает:  libnotify.so=4-64 ; 2025-03-29 00:39 UTC
yay -S balena-etcher --noconfirm   # Безопасное и простое копирование образов ОС на SD-карты и USB-накопители ; https://balena.io/etcher ; https://aur.archlinux.org/packages/balena-etcher ; https://aur.archlinux.org/balena-etcher.git ; https://github.com/balena-io/etcher/archive/refs/tags/v2.1.2.tar.gz ; Конфликты: с etcher, etcher-bin, etcher-git ; 2025-08-10 07:12 (UTC)
######## balena-etcher ############
#git clone https://aur.archlinux.org/balena-etcher.git  # (только для чтения, нажмите, чтобы скопировать)
#cd balena-etcher
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf balena-etcher
#rm -Rf balena-etcher
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#########################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить UNetbootin (unetbootin) — Создание загрузочного образа Live USB?"
echo -e "${MAGENTA}:: ${BOLD}UNetbootin — полезный инструмент, который позволяет устанавливать различные дистрибутивы Linux / BSD и создавать загрузочные USB-устройства флеш-памяти с минимальными усилиями. Unetbootin существует дольше, чем GNOME Multiwriter и Etcher ; это широко используемый и признанный инструмент для создания загрузочных Live USB-накопителей на Linux , который также является кроссплатформенным и поддерживает широкий спектр образов ISO, включая Windows и macOS. ${NC}"
echo " Домашняя страница: https://unetbootin.github.io/ ; (https://aur.archlinux.org/packages/unetbootin  ; https://aur.archlinux.org/unetbootin.git). "
echo -e "${BLUE}:: ${NC}Приложение поддерживают установку 40 самых популярных дистрибутивов. Для каждого дистрибутива доступно несколько версий. Выберите одну из предлагаемых систем или укажите свой ISO-образ. Вы можете загрузить желаемую операционную систему или предоставить собственный файл ISO-образа Linux, который будет использоваться при создании загрузочного устройства. UNetbootin дает вам возможность установить желаемый дистрибутив Linux на USB-накопителе, независимо от того, подключены ли вы к Интернету или нет. Кроме того, вы можете установить предпочтительный дистрибутив Linux, даже если его нет в списке программы. Для каждого дистрибутива UNetbootin показывает домашнюю страницу, описание и приводит заметки по установке. Режим «Frugal install» : Кроме создания загрузочного USB-накопителя Linux, UNetbootin также поддерживает установку нужного дистрибутива в режиме «Frugal install» прямо на вашем жестком диске. «Frugal install» означает, что все файлы образа ISO будут скопированы на ваш жесткий диск и загружены с вашего жесткого диска так же, как они были бы загружены с вашего USB-накопителя или компакт-диска. После выбора нужного дистрибутива Linux вам просто нужно выбрать USB-диск или раздел жесткого диска, на который вы хотите установить систему и запустить процесс. "
echo -e "${CYAN}:: ${NC}Использование UNetbootin: Выберите ISO файл или дистрибутив для загрузки, выберите целевое устройство (флешка или USB диск), затем перезапустите ПК после завершения процесса. Если Ваше USB устройство не определяется, отформатируйте его в FAT32. Поддерживаемые дистрибутивы: Ubuntu; Kubuntu; Xubuntu; Lubuntu; Debian; openSUSE; Arch Linux; Damn Small Linux; SliTaz; Linux Mint; Zenwalk; Slax; Elive; CentOS; FreeBSD; NetBSD; 3CX; Fedora; PCLinuxOS; Sabayon Linux; Gentoo; MEPIS; LinuxConsole; Frugalware Linux; xPUD; Puppy Linux. UNetbootin может использоваться для загрузки разных системных утилит, в том числе: Parted Magic; SystemRescueCD; Super Grub Disk; Dr.Web Antivirus; F-Secure Rescue CD; Kaspersky Rescue Disk; Backtrack; Ophcrack; NTPasswd; Gujin; Smart Boot Manager; FreeDOS. "
echo -e "${MAGENTA}:: ${NC}Установка других дистрибутивов с использованием UNetbootin: Загрузите и запустите UNetbootin, затем выберите опцию "образ диска" в формате "ISO" (Образ диска). UNetbootin не использует специфичные для дистрибутива правила для создания вашего активного USB-накопителя, поэтому большинство ISO-файлов Linux должны загружаться корректно при использовании этой опции. Однако не все дистрибутивы поддерживают загрузку с USB, а некоторые другие требуют дополнительных параметров загрузки или других модификаций, прежде чем они смогут загружаться с USB-накопителей, поэтому эти ISO-файлы не будут работать как есть. Кроме того, ISO-файлы для операционных систем, отличных от Linux, имеют другой механизм загрузки, поэтому не ожидайте, что они тоже будут работать. Приложение имеет открытый исходный код и также позволяет загружать изображения непосредственно из источника для записи на USB-накопитель. "
echo -e "${CYAN}:: ${NC}Установка UNetbootin (unetbootin) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/unetbootin.git), (https://aur.archlinux.org/unetbootin) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить UNetbootin (unetbootin),   0 - НЕТ - Пропустить установку: " in_unetbootin  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_unetbootin" =~ [^10] ]]
do
    :
done
if [[ $in_unetbootin == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_unetbootin == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) UNetbootin (unetbootin) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
############### Зависимости ###############
sudo pacman -S --noconfirm --needed mtools  # Коллекция утилит для доступа к дискам MS-DOS ; https://archlinux.org/packages/extra/x86_64/mtools/ ; https://www.gnu.org/software/mtools/ ; 2025-06-16 11:09 UTC
sudo pacman -S --noconfirm --needed syslinux  # Коллекция загрузчиков, загружающихся с файловых систем FAT, ext2/3/4 и btrfs, с компакт-дисков и через PXE ; https://archlinux.org/packages/core/x86_64/syslinux/ ; https://www.syslinux.org/ ; 2024-10-10 07:14 UTC
sudo pacman -S --noconfirm --needed setconf  # Утилита для простого изменения настроек в файлах конфигурации ; https://archlinux.org/packages/extra/any/setconf/ ; https://setconf.roboticoverlords.org/ ; 2024-07-13 21:21 UTC
########## unetbootin #############
yay -S unetbootin --noconfirm   # Создание загрузочных Live USB-накопителей ; https://aur.archlinux.org/packages/unetbootin ; https://aur.archlinux.org/unetbootin.git ; https://unetbootin.github.io/ ; 2023-08-14 15:10 (UTC)
######## unetbootin ############
#git clone https://aur.archlinux.org/unetbootin.git  # (только для чтения, нажмите, чтобы скопировать)
#cd unetbootin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf unetbootin
#rm -Rf unetbootin
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############## Справка ##############
# Разработчик: Geza Kovacs (Венгрия) (http://unetbootin.github.io/). Лицензия: Бесплатно (GNU GPL 2 и выше). Системы: Windows / MacOS / Linux. Интерфейс: русский / английский. Категория: Загрузка и установка ОС. Размер:  зависит от платформы.
##########################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Ventoy GUI (ventoy) — Несколько образов на одной флешке?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Ventoy — программа для создания загрузочных USB-носителей (флешек) с несколькими ISO образами. Образы достаточно просто скопировать на флешку. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Ventoy — это инструмент с открытым исходным кодом для создания загрузочного USB-накопителя для файлов ISO/WIM/IMG/VHD(x)/EFI. С помощью ventoy вам не нужно форматировать диск снова и снова, вам просто нужно скопировать файлы ISO/WIM/IMG/VHD(x)/EFI на USB-накопитель и загрузить их напрямую. Этот проект Лицензируется под GPL-3.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: http://www.ventoy.net/ ; (https://aur.archlinux.org/packages/ventoy ; https://aur.archlinux.org/packages/ventoy-bin). "
echo -e "${BLUE}:: ${NC}Возможности: Принцип работы Ventoy отличается от других программ для создания загрузочных носителей. Ventoy позволяет создавать загрузочные носители просто копируя на флешку необходимые файлы, например, ISO образ. При загрузке с такой флешки отображается меню со списком доступных для загрузки образов. Вы можете копировать много файлов одновременно, и ventoy предоставит вам загрузочное меню для их выбора. "
echo -e "${CYAN}:: ${NC}Поддерживается большинство типов ОС (Windows/WinPE/Linux/ChromeOS/Unix/VMware/Xen...), протестировано более 1200 файлов образов (список - https://www.ventoy.net/en/isolist.html), поддерживается более 90% дистрибутивов на distrowatch.com (подробности - https://www.ventoy.net/en/distrowatch.html). Поддерживаемые форматы: ISO; WIM; IMG; VHD(x); EFI; Поддержка BIOS и UEFI. Поддержка UEFI Secure Boot. Поддержка режима «Persistence». Используется для Live-систем, которые могут сохранять данные. Поддержка MBR и GPT. Поддержка ISO файлов размером более 4GB. Поддерживается не только live-загрузка систем, но и их установка. Поддержка плагинов. Поддерживается большинство операционных систем: Linux; Windows; WinPE; Unix; Vmware; Xen; И другие. Установка: Для запуска Ventoy необходимо скачать архив с программой, распаковать и запустить файл Ventoy2Disk.sh. "
echo -e "${CYAN}:: ${NC}Установка Ventoy (ventoy) и (ventoy-bin), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/ventoy.git), (https://aur.archlinux.org/ventoy-bin.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить Ventoy (ventoy-bin),   2 - Установить Ventoy (ventoy),

    0 - НЕТ - Пропустить установку: " in_ventoy  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_ventoy" =~ [^120] ]]
do
    :
done
if [[ $in_ventoy == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_ventoy == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Ventoy (ventoy-bin) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
############### Зависимости ###############
sudo pacman -S --noconfirm --needed dosfstools  # Утилиты файловой системы DOS ; https://archlinux.org/packages/core/x86_64/dosfstools/ ; https://github.com/dosfstools/dosfstools ; 2024-08-25 13:37 UTC
sudo pacman -S --noconfirm --needed util-linux  # Различные системные утилиты для Linux ; https://archlinux.org/packages/core/x86_64/util-linux/ ; https://github.com/util-linux/util-linux ; Конфликты: с hardlink, rfkill ; 2025-03-31 10:01 UTC
sudo pacman -S --noconfirm --needed polkit  # Набор инструментов для разработки приложений для управления общесистемными привилегиями ; https://archlinux.org/packages/extra/x86_64/polkit/ ; https://github.com/polkit-org/polkit ; Обеспечивает: libpolkit-agent-1.so=0-64, libpolkit-gobject-1.so=0-64 ; 2025-01-15 15:10 UTC
yay -S ventoy-bin --noconfirm  # Новое загрузочное USB-решение ; http://www.ventoy.net/ ; https://aur.archlinux.org/packages/ventoy-bin ; https://aur.archlinux.org/ventoy-bin.git ; https://github.com/ventoy/Ventoy/releases/download/v1.1.05/ventoy-1.1.05-linux.tar.gz ; Конфликты: с ventoy ; 2025-08-18 16:37 (UTC)
######## ventoy-bin ############
#git clone https://aur.archlinux.org/ventoy-bin.git  # (только для чтения, нажмите, чтобы скопировать)
#cd ventoy-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ventoy-bin
#rm -Rf ventoy-bin
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_ventoy == 2 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Ventoy (ventoy) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
yay -S ventoy --noconfirm  # Новое загрузочное USB-решение ; https://www.ventoy.net/ ; https://aur.archlinux.org/packages/ventoy ; https://aur.archlinux.org/ventoy.git ; Конфликты: с ventoy-bin ; 2025-08-21 03:13 (UTC)
######## ventoy ############
#git clone https://aur.archlinux.org/ventoy.git  # (только для чтения, нажмите, чтобы скопировать)
#cd ventoy
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ventoy
#rm -Rf ventoy
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############## Справка ##############
# yochananmarqos прокомментировал 2025-05-23 16:25 (UTC)
# @Integral: Это не имеет значения. Если вы запускаете Ventoy2Disk.qt5 исполняемый файл, проблема StartupWMClass в файле рабочего стола
# Ventoy2Disk.gtk3. Скопируйте файл рабочего стола в пользовательское пространство и измените StartupWMClassна Ventoy2Disk.qt5:
# cp /usr/share/applications/ventoy.desktop ~/.local/share/applications/
# ed -i 's/Ventoy2Disk.gtk3/Ventoy2Disk.qt5/g' ~/.local/share/applications/ventoy.desktop
# URL dietlib не работает. Вот тот, который нужно использовать: https://github.com/ventoy/vtoytoolchain/releases/download/1.0/dietlibc -"$_diet_ver".tar.xz
#########################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Popsicle (popsicle) — Многофункциональный USB-флешер для Linux?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Создать загрузочный USB (флешку) на Linux легко! Мы можем создавать загрузочные USB-устройства, используя терминальную команду dd, программы: Etcher, Bootiso, MultiCD, Mkusb и пр. Например Etcher может одновременно подключать несколько USB-устройств для загрузки. Popsicle - утилита Linux для параллельной записи образов на нескольких USB-устройствах. Popsicle - это официальная утилита для записи USB в Pop! _OS. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Popsicle (Multiple USB File Flasher) — это универсальный инструмент (утилита), разработанный для систем Linux, который позволяет пользователям одновременно прошивать несколько USB-устройств (на несколько USB-устройств одновременно). Popsicle идеально подходит для ситуаций, когда требуется массовое дублирование данных на нескольких USB-накопителях, оптимизирует процесс, обеспечивая эффективность и согласованность. Бесплатная и с открытым исходным кодом программа. Благодаря удобному интерфейсу пользователи могут легко выбрать файл образа, например .iso или .img , а затем выбрать целевые USB-накопители. После запуска Popsicle берет на себя процесс прошивки, предоставляя обновления в режиме реального времени для каждого устройства. Независимо от того, настраиваете ли вы несколько загрузочных дисков для семинара, класса или мероприятия, Popsicle предлагает надежное решение для быстрого выполнения работы. Этот проект Лицензируется под MIT. ${NC}"
echo " Домашняя страница: https://github.com/pop-os/popsicle ; (https://aur.archlinux.org/packages/popsicle ; https://aur.archlinux.org/packages/popsicle-bin). "
echo -e "${BLUE}:: ${NC}Характеристики Popsicle: Popsicle поддерживает устройства USB 2.0 и USB 3.0 . Поддерживает параллельную запись, поэтому мы можем записать несколько USB-устройств за пару минут. Мы можем проверить ISO образы с помощью SHA256 или MD5 chekcsum. Мы можем просматривать ход записи, скорость и завершение каждого устройства. Можно записать типы изображений ISO или IMG. Доступны как командная строка, так и графические интерфейсы. Работает под официальными версиями Pop! _OS, Ubuntu и производными, а также Manjaro. "
echo -e "${CYAN}:: ${NC}Запись на USB-устройства с помощью Popsicle: Подключите USB-устройства (флешки) и выберите изображение (.iso или .img), которое вы хотите записать на USB-устройство/устройства. Выберите устройства USB для записи из списка и нажмите «Next» (Далее). Список устройств USB будет автоматически обновляться при добавлении или удалении новых устройств. Далее начнется операция записи образа на выбранные USB-накопители. Это займет несколько минут. При успешном завершении вы увидите следующее сообщение. Теперь безопасно извлеките USB-накопители и используйте только что созданные загрузочные USB-устройства для установки ОС или тестирования. "
echo -e "${CYAN}:: ${NC}Установка Popsicle (popsicle) и (popsicle-bin), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/popsicle.git), (https://aur.archlinux.org/popsicle-bin.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить Popsicle (popsicle),  2 - Установить Popsicle (popsicle-bin),

    0 - НЕТ - Пропустить установку: " in_popsicle  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_popsicle" =~ [^120] ]]
do
    :
done
if [[ $in_popsicle == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_popsicle == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Popsicle (popsicle) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed fuse2  # Интерфейс для программ пользовательского пространства для экспорта файловой системы в ядро Linux ; https://archlinux.org/packages/extra/x86_64/fuse2/ ; https://github.com/libfuse/libfuse ; Конфликты: с fuse ; 2024-07-12 15:36 UTC
sudo pacman -S --noconfirm --needed help2man  # Инструмент конвертации для создания man-файлов ; https://archlinux.org/packages/extra/x86_64/help2man/ ; https://www.gnu.org/software/help2man/ ; 2024-07-03 20:53 UTC
############# popsicle ############
yay -S popsicle --noconfirm  # Утилита Linux для параллельной прошивки нескольких USB-устройств, написанная на Rust ; https://aur.archlinux.org/packages/popsicle ; https://aur.archlinux.org/popsicle.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/pop-os/popsicle ; git+https://github.com/pop-os/popsicle.git#tag=1.3.3 ; 2025-07-04 22:06 (UTC)
############# popsicle-git ############
# yay -S popsicle-git --noconfirm  # Утилита Linux для параллельной прошивки нескольких USB-устройств, написанная на Rust ; https://aur.archlinux.org/packages/popsicle-git ; https://aur.archlinux.org/popsicle-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/pop-os/popsicle ; Конфликты: popsicle ; Обеспечивает: popsicle ; git+https://github.com/pop-os/popsicle.git ; 2025-07-04 22:07 (UTC)
############# popsicle ############
#git clone https://aur.archlinux.org/popsicle.git  # (только для чтения, нажмите, чтобы скопировать)
#cd popsicle
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf popsicle
#rm -Rf popsicle
######################
  echo ""
  echo " Посмотрите информацию о версии (popsicle) "
# popsicle --version  # Показать версию приложения
sudo pacman -Q popsicle  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_popsicle == 2 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Popsicle (popsicle-bin) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed fuse2  # Интерфейс для программ пользовательского пространства для экспорта файловой системы в ядро Linux ; https://archlinux.org/packages/extra/x86_64/fuse2/ ; https://github.com/libfuse/libfuse ; Конфликты: с fuse ; 2024-07-12 15:36 UTC
sudo pacman -S --noconfirm --needed help2man  # Инструмент конвертации для создания man-файлов ; https://archlinux.org/packages/extra/x86_64/help2man/ ; https://www.gnu.org/software/help2man/ ; 2024-07-03 20:53 UTC
############# popsicle-bin ############
yay -S popsicle-bin --noconfirm  # Утилита Linux для параллельной прошивки нескольких USB-устройств, написанная на Rust ; https://aur.archlinux.org/packages/popsicle-bin ; https://aur.archlinux.org/popsicle-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/pop-os/popsicle ; https://github.com/pop-os/popsicle/releases/download/1.3.3/Popsicle_USB_Flasher-1.3.3-x86_64.AppImage ; Конфликты: с popsicle ; Обеспечивает:  popsicle ; 2024-08-20 06:23 (UTC)
############# popsicle-bin ############
#git clone https://aur.archlinux.org/popsicle-bin.git  # (только для чтения, нажмите, чтобы скопировать)
#cd popsicle-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf popsicle-bin
#rm -Rf popsicle-bin
######################
  echo ""
  echo " Посмотрите информацию о версии (popsicle) "
# popsicle --version  # Показать версию приложения
sudo pacman -Q popsicle-bin  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#######

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Mintstick (mintstick) — Форматирование или запись образов на USB-накопители (инструмент Linux Mint)?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *В Linux Mint, в отличие от других систем, есть два отдельных приложения для работы с USB-накопителями: одно предназначено только для форматирования, а другое — для записи файлов образов на USB-накопитель. Это альтернатива программе usb creator от Mint. Это графическое приложение для записи файлов .img и .iso на USB-накопители. Оно также может форматировать USB-накопитель из контекстного меню на рабочих столах Cinammon и KDE. Его можно использовать в других системах Linux. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Mintstick — специализированные Python / GTK графические утилиты разработанные для проекта Linux Mint (модификация Ubuntu Linux). Утилиты Mintstick предназначены для записи образов диска на USB-накопитель (флешку), создания загрузочных USB-носителей (Live-USB) и форматирования USB-накопителей. Mintstick требует прав администратора (root), после запуска "процесса" его можно отменить, но делать этого не рекомендуется, так как существует вероятность порчи носителя. Для форматирования USB-флеш-накопителя Mintstick позволяет выбрать файловую систему FAT32, NTFS или EXT4 и задать метку файловой системы (накопитель должен быть примонтирован). Для создания загрузочного USB-носителя достаточно выбрать образ диска и задать предназначенный для копирования образа флеш-накопитель. Поддерживается запуск из командной строки. Носитель Mintstick отмонтирует и форматирует автоматически, по окончании процесса выводится соответствующее уведомление (при неудачном копировании будет сообщено о ошибке). Этот проект Лицензируется под GPL. ${NC}"
echo " Домашняя страница: https://github.com/linuxmint/mintstick ; (https://aur.archlinux.org/packages/mintstick). "
echo -e "${BLUE}:: ${NC}Итак, /usr/bin/mintstick — программа для записи образов *.img и *.iso на USB-флешки. Точнее, вообще на любые твердотельные носители, например, SD-карты. Запускается через CLI приведённой командой или из меню (для Cinnamon’а и MATE): Стандартные -> Создание загрузочного USB-носителя. После чего предстаёт перед глазами применителя. "
echo -e "${CYAN}:: ${NC}Дальнейшие действия очевидны: надо выбрать записываемый образ и указать, куда он должен быть записан (воткнутая флешка или SD-карта предлагается по умолчанию). После этого потребуется ввести пароль и подождать завершения процесса, о чем будет сообщено дополнительно. В поле Подробности будут указаны имена файла образа и целевого устройства. Всё. Можно либо повторить процедуру для другого образа или устройства, либо закрыть программу. Хотелось бы ещё проще? А вот фиг вам с маслом: проще уже некуда. "
echo -e "${CYAN}:: ${NC}Установка Mintstick (mintstick) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/mintstick.git), (https://aur.archlinux.org/packages/mintstick) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_mintstick  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_mintstick" =~ [^10] ]]
do
    :
done
if [[ $in_mintstick == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_mintstick == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Mintstick (mintstick) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########### mintstick #############
yay -S mintstick --noconfirm  # Графический инструмент, позволяющий форматировать USB-накопители и создавать загрузочные USB-накопители ; https://aur.archlinux.org/packages/mintstick ; https://aur.archlinux.org/mintstick.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/linuxmint/mintstick ; Конфликты: с mintstick-git ; http://packages.linuxmint.com/pool/main/m/mintstick/mintstick_1.6.3.tar.xz ; 2025-01-10 02:57 (UTC)
########### mintstick-git #############
# yay -S mintstick-git --noconfirm  # Форматирование или запись образов на USB-накопители (инструмент Linux Mint) ; https://aur.archlinux.org/packages/mintstick-git ; https://aur.archlinux.org/mintstick-git.git (только для чтения, нажмите, чтобы скопировать) ; git+https://github.com/linuxmint/mintstick.git ; https://github.com/linuxmint/mintstick ; Конфликты: mintstick ; Обеспечивает: mintstick ; 2024-01-22 18:31 (UTC)
########### mintstick #############
#git clone https://aur.archlinux.org/mintstick.git  # (только для чтения, нажмите, чтобы скопировать)
#cd mintstick
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf mintstick
#rm -Rf mintstick
  echo ""
  echo " Посмотрите информацию о версии (mintstick) "
sudo pacman -Q mintstick  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить WoeUSB / WoeUSB-ng (woeusb)(woeusb-ng) — Создание загрузочных USB-накопителей с Windows в Linux?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Иногда нам нужно создать загрузочную флешку, и для этого мы используем такие приложения, как Startup Disk Creator, Etcher или Gnome Multiwriter . Но эти инструменты работают только с образами ISO Linux и не могут записать образ Windows на флешку. Для этого нам понадобится другая утилита под названием WoeUSB , которая позволяет сделать флешку загрузочной для Windows в Linux. WoeUSB — это простой и мощный инструмент, позволяющий создавать загрузочные USB-накопители Windows из ISO-образа или физического диска. Он особенно полезен для пользователей Linux, которым необходимо установить или восстановить Windows на своих компьютерах, но у которых нет доступа к среде Windows для создания USB-накопителя. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}WoeUSB — утилита для Linux систем, позволяющая создавать загрузочные версии USB-носителей с установочными версиями операционных систем Windows. Утилита поддерживает запись загрузочных образов на USB устройства из iso-файлов или DVD дисков. Благодаря своей популярности, новый разработчик взялся возродить проект из мёртвых. Так родился WoeUSB-ng. «ng» здесь означает «новое поколение». Другими словами, WoeUSB-ng — это WoeUSB нового поколения. Но поскольку оригинальный инструмент больше не существует, я буду называть WoeUSB-ng просто WoeUSB. Оригинальный WoeUSB — это скрипт оболочки. Этот же WoeUSB, переписанный на Python как WoeUSB-ng, может быть установлен в вашей системе и предоставляет как командную строку, так и графический интерфейс. Утилита имеет две версии - графическая и консольная. Версия с графическим интерфейсом (woeusb-ng), будет удобна для обычных пользователей, которые предпочитают работу с интуитивно понятным интерфейсом. Утилита командной строки (woeusb) предназначена для опытных пользователей операционной системы Linux, которым удобно работать в терминале с помощью текстовых команд. Этот проект Лицензируется под GPL-3.0 . ${NC}"
echo " Домашняя страница: https://github.com/WoeUSB/WoeUSB ; (https://github.com/WoeUSB/WoeUSB-ng ; https://aur.archlinux.org/packages/woeusb ; https://aur.archlinux.org/packages/woeusb-ng). "
echo -e "${BLUE}:: ${NC}Функции: Поддержка загрузки Legacy PC/UEFI. Поддержка файловых систем FAT32 и NTFS. Поддержка использования физического установочного диска или образа диска в качестве источника. Его можно использовать в Windows Vista и более поздних версиях с любым языком и вариантами редакции. Режим загрузки Legacy/MBR-style/совместимый с IBM PC. Собственная загрузка UEFI поддерживается для образов Windows 7 и более поздних версий (ограничена файловой системой FAT в качестве целевой). "
echo -e "${CYAN}:: ${NC}*Как в Linux записать загрузочную USB-флешку с установочной версией Windows с помощью утилиты WoeUSB: Скачайте утилиту WoeUSB и запустите её с помощью ярлыка в меню программ или с рабочего стола. В разделе 'Sourse' выберите источник дистрибутива операционной системы Windows. Отметьте пункт 'From a disk image (iso)' и укажите путь к iso файлу. Или отметьте пункт 'From a CD/DVD drive' и выберите привод компакт дисков с вставленным установочным DVD диском. В разделе 'File System' укажите файловую систему, в которую будет отформатирован ваш USB-носитель. В последнем разделе 'Target device' выберите USB устройство, на которое будет записана установочная версия Windows. Нажмите Install и при необходимости подтвердите выполнение операции. *Поддерживаются загрузочные образы: Windows Vista, Windows 7, Window 8.x, Windows 10 и Windows PE всех языков и редакций. Поддерживаются режимы загрузки Legacy / MBR / IBM PC, а также UEFI для образов Windows 7 и выше. "
echo -e "${CYAN}:: ${NC}Установка WoeUSB (woeusb) и WoeUSB-ng (woeusb-ng), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/woeusb.git), (https://aur.archlinux.org/woeusb-ng.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить WoeUSB (woeusb),  2 - *Установить WoeUSB-ng (woeusb-ng),

    0 - НЕТ - Пропустить установку: " in_woeusb  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_woeusb" =~ [^120] ]]
do
    :
done
if [[ $in_woeusb == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_woeusb == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) WoeUSB (woeusb) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed 7zip  #  Архиватор файлов для сверхвысокой степени сжатия ; https://archlinux.org/packages/extra/x86_64/7zip/ ; https://www.7-zip.org/ ; Обеспечивает: p7zip ; Заменяет: p7zip ; Конфликты: с p7zip ; 2024-12-25 15:57 UTC
sudo pacman -S --noconfirm --needed python-pip  # Рекомендуемый PyPA инструмент для установки пакетов Python ; https://archlinux.org/packages/extra/any/python-pip/ ; https://pip.pypa.io/ ; 2025-08-05 07:48 UTC
sudo pacman -S --noconfirm --needed python-wxpython  # Кроссплатформенный набор инструментов графического интерфейса ; https://archlinux.org/packages/extra/x86_64/python-wxpython/ ; https://www.wxpython.org/ ; 2025-06-14 18:41 UTC
sudo pacman -S --noconfirm --needed parted  # Программа для создания, уничтожения, изменения размера, проверки и копирования разделов ; https://archlinux.org/packages/extra/x86_64/parted/ ; https://www.gnu.org/software/parted/parted.html ; 2024-07-24 08:33 UTC
############# woeusb ##############
yay -S --noconfirm woeusb  # Программа Linux для создания установщика USB-накопителя Windows из DVD-диска Windows или образа ; https://aur.archlinux.org/packages/woeusb ; https://aur.archlinux.org/woeusb.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/WoeUSB/WoeUSB ; https://github.com/WoeUSB/WoeUSB/releases/download/v5.2.4/woeusb-5.2.4.bash ; Обеспечивает: woeusb ; 2023-05-14 21:41 (UTC)
############# woeusbgui ##############
# yay -S --noconfirm woeusbgui  # НЕПОДДЕРЖИВАЕМАЯ старая версия графического интерфейса ; https://aur.archlinux.org/packages/woeusbgui ; https://aur.archlinux.org/woeusbgui.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/slacka/WoeUSB ; https://github.com/slacka/WoeUSB/archive/v3.3.1/woeusb-3.3.1.tar.gz ; Конфликты: woeusb ; 2023-03-24 13:13 (UTC)
############# woeusb ##############
#git clone https://aur.archlinux.org/woeusb.git  # (только для чтения, нажмите, чтобы скопировать)
#cd woeusb
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf woeusb
#rm -Rf woeusb
######################
  echo ""
  echo " Посмотрите информацию о версии (woeusb) "
# woeusb --version  # Показать версию приложения
sudo pacman -Q woeusb  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_woeusb == 2 ]]; then
  echo ""
  echo " Установка утилиты (пакета) WoeUSB-ng (woeusb-ng) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed 7zip  #  Архиватор файлов для сверхвысокой степени сжатия ; https://archlinux.org/packages/extra/x86_64/7zip/ ; https://www.7-zip.org/ ; Обеспечивает: p7zip ; Заменяет: p7zip ; Конфликты: с p7zip ; 2024-12-25 15:57 UTC
sudo pacman -S --noconfirm --needed python-pip  # Рекомендуемый PyPA инструмент для установки пакетов Python ; https://archlinux.org/packages/extra/any/python-pip/ ; https://pip.pypa.io/ ; 2025-08-05 07:48 UTC
sudo pacman -S --noconfirm --needed python-wxpython  # Кроссплатформенный набор инструментов графического интерфейса ; https://archlinux.org/packages/extra/x86_64/python-wxpython/ ; https://www.wxpython.org/ ; 2025-06-14 18:41 UTC
sudo pacman -S --noconfirm --needed parted  # Программа для создания, уничтожения, изменения размера, проверки и копирования разделов ; https://archlinux.org/packages/extra/x86_64/parted/ ; https://www.gnu.org/software/parted/parted.html ; 2024-07-24 08:33 UTC
############# woeusb-ng ##############
yay -S --noconfirm woeusb-ng  # Простой инструмент, позволяющий создать собственную USB-флешку с установщиком Windows ; https://aur.archlinux.org/packages/woeusb-ng ; https://aur.archlinux.org/woeusb-ng.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/WoeUSB/WoeUSB-ng ; https://github.com/WoeUSB/WoeUSB-ng/archive/v0.2.12.tar.gz ; https://github.com/WoeUSB/WoeUSB-ng/archive/v0.2.12.tar.gz ; https://aur.archlinux.org/cgit/aur.git/tree/pr79.patch?h=woeusb-ng ; Обеспечивает: woeusb ; Конфликты: с woeusb, woeusb-git ; 2023-06-10 12:07 (UTC)
############# woeusb-ng ##############
#git clone https://aur.archlinux.org/woeusb-ng.git  # (только для чтения, нажмите, чтобы скопировать)
#cd woeusb-ng
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf woeusb-ng
#rm -Rf woeusb-ng
######################
  echo ""
  echo " Посмотрите информацию о версии (woeusb) "
# woeusb --version  # Показать версию приложения
sudo pacman -Q woeusb-ng  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ############
# Эй, ярлык на рабочем столе нужно обновить.
# #!/usr/bin/env xdg-open
# [Desktop Entry]
# Version=2.2
# Type=Application
# Name=WoeUSB-ng
# Comment=Create your own usb stick windows installer from an iso image or a real DVD.
# Icon=/usr/share/icons/WoeUSB-ng/icon.ico
# Exec=woeusbgui
# Actions=
# #Categories=Application;Utility;
# Categories=Utility;
# #StartupNotify=true
# #StartupWMClass=Woeusbgui
# Terminal=false
###################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить KDE ISO Image Writer (isoimagewriter) — Программа для записи гибридных ISO-файлов на USB-диски?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Целью программного обеспечения является обеспечение простого и удобного интерфейса, что упрощает процесс создания загрузочных USB-накопителей. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}ISO Image Writer — лёгкая и простая Qt графическая утилита для создания Live USB (флешки). ISO Image Writer основан на наработках ROSA ImageWriter (графический интерфейс к DD), расширяя функциональные возможности приложения, автором проекта является Джонатан Риддел (Jonathan Riddell), один из разработчиков KDE Neon (бывший лидер проекта Kubuntu). ISO Image Writer — это инструмент на базе KDE, специально разработанный для записи файлов ISO на USB-накопители. Как часть пакета приложений KDE, он легко интегрируется с рабочей средой KDE Plasma. Этот проект Лицензируется под GPL-3.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://apps.kde.org/isoimagewriter/ ; (https://archlinux.org/packages/extra/x86_64/isoimagewriter/). "
echo -e "${BLUE}:: ${NC}Цель данного проекта — модернизация пользовательского интерфейса утилиты в соответствии с оформлением KDE. Также планируется подготовить пакеты для различных дистрибутивов Linux, универсальные пакеты Snap и Flatpak, опубликовать сборки для Windows и macOS. Инструкция на странице загрузки KDE Neon будет обновлена. "
echo -e "${CYAN}:: ${NC}ISO Image Writer позволяет в пару кликов мыши записать на USB-накопитель или SD-карту образов дисков (ISO и IMG) и/или быстро удалить данные с носителя, поддерживается автоматическая проверка подлинности (проверка контрольных сумм, цифровых подписей), для запуска требуются права администратора (root). Утилита KDE ISO Image Writer, являющаяся частью проекта KDE Neon, представляет собой инструмент для записи образов ISO на USB-накопители. Она основана на ROSA Image Writer и расширена с использованием KDE Frameworks. В настоящее время на сайте KDE Neon рекомендуется использовать ROSA Image Writer, поскольку KDE ISO Image Writer всё ещё находится в стадии разработки. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_isoimagewriter  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_isoimagewriter" =~ [^10] ]]
do
    :
done
if [[ $in_isoimagewriter == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_isoimagewriter == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) KDE ISO Image Writer (isoimagewriter) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
############ isoimagewriter ##############
sudo pacman -S --noconfirm --needed isoimagewriter  # Программа для записи гибридных ISO-файлов на USB-диски ; https://archlinux.org/packages/extra/x86_64/isoimagewriter/ ; https://apps.kde.org/isoimagewriter/ ; 2025-08-16 11:01 UTC
  echo ""
  echo " Посмотрите информацию о версии (isoimagewriter) "
# isoimagewriter --version  # Показать версию приложения
sudo pacman -Q isoimagewriter  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить DC3dd (dc3dd) — Патч к программе GNU dd?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *DC3DD разработан отделом Defense Cyber Crime Center. DC3DD — это форк популярного инструмента Data Dump (DD). ${NC}"
echo -e "${MAGENTA}:: ${BOLD}DC3dd — модифицированная версия консольной утилиты преобразования и копирования файлов на байтовом уровне dd (dataset definition). dd (dataset definition) — утилита в UNIX, предназначенная для копирования и конвертации файлов. Название унаследовано от оператора DD (Data Definition) из языка JCL. Этот проект Лицензируется под GPL3. ${NC}"
echo " Домашняя страница: https://sourceforge.net/projects/dc3dd/ ; (https://aur.archlinux.org/packages/dc3dd). "
echo -e "${BLUE}:: ${NC}Функции: dc3dd поддерживает все базовые возможности и принимает большинство параметров оригинальной "dd" (GNU dd), утилита может быть использована для создания точных копий исследуемых носителей. Утилита относится к классу приложений "судебного анализа данных", сбор данных для судебной экспертизы. DC3dd GUI — графический QT пользовательский интерфейс (GUI), дающий доступ к большинству функциональных возможностей консольной версии dc3dd. dc3dd при копировании диска (раздела диска) в файл поддерживает хеширование (hashing) файлов "на лету" (используя алгоритмы хеширования MD5, SHA-1, SHA-256 и SHA-512), для последующей проверки целостности данных (аутентификации), ошибки чтения записываются в файл, можно разделить образ на файлы заданного размера, отображается прогресс выполнения (отображается количество записанного), все выполняемые действия заносятся в лог-файл и многое другое... "
echo -e "${CYAN}:: ${NC}*Использование DC3DD в компьютерной криминалистике: Для начала рассмотрим возможности DC3DD: Получение и клонирование диска в битовом (необработанном) виде. Создание копии разделов диска. Копирование папок и файлов. Проверка жесткого диска на ошибки. Безопасное уничижение данных на жестких дисках. Хеширование «на лету» с использованием большего количества алгоритмов (MD5, SHA-1, SHA-256 и SHA-512). Запись ошибок в файл. Разделение выходных файлов. Проверка файлов. *Некоторые возможности dd: Копирование регионов из файлов «сырых» устройств. Например, сделать резервную копию загрузочного сектора жёсткого диска. Чтение фиксированных блоков данных из специальных файлов, таких как /dev/zero или /dev/random. Преобразования данных, например, игнорирование ошибок чтения (опция conv=noerror). Пропуск блоков во входном или выходном файле (параметры skip= и seek=). "
echo -e "${CYAN}:: ${NC}Установка dc3dd (dc3dd) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/dc3dd.git), (https://aur.archlinux.org/packages/dc3dd) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_dc3dd  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_dc3dd" =~ [^10] ]]
do
    :
done
if [[ $in_dc3dd == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_dc3dd == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) DC3dd (dc3dd) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed autoconf  # Инструмент GNU для автоматической настройки исходного кода ; https://archlinux.org/packages/core/any/autoconf/ ; https://www.gnu.org/software/autoconf ; 2024-01-05 07:55 UTC
sudo pacman -S --noconfirm --needed perl-locale-gettext  # Позволяет получить доступ из Perl к семейству функций gettext() ; https://archlinux.org/packages/extra/x86_64/perl-locale-gettext/ ; https://search.cpan.org/dist/Locale-gettext/ ; 2025-07-16 18:23 UTC
########## dc3dd ############
yay -S dc3dd --noconfirm  # представляет собой патч к программе GNU dd, эта версия имеет несколько функций, предназначенных для криминалистического извлечения данных ; https://aur.archlinux.org/packages/dc3dd ; https://aur.archlinux.org/dc3dd.git (только для чтения, нажмите, чтобы скопировать) ; http://sourceforge.net/projects/dc3dd/ ; https://downloads.sourceforge.net/project/dc3dd/dc3dd/7.3.1/dc3dd-7.3.1.zip ; 2025-02-08 16:06 (UTC)
########## dc3dd ############
#git clone https://aur.archlinux.org/dc3dd.git  # (только для чтения, нажмите, чтобы скопировать)
#cd dc3dd
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf dc3dd
#rm -Rf dc3dd
  echo ""
  echo " Посмотрите информацию о версии (dc3dd) "
# dc3dd --version  # Показать версию приложения
sudo pacman -Q dc3dd  #  Показать версию приложения
dc3dd
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#############

clear
echo -e "${MAGENTA}
  <<< Установка утилит (пакетов) для записи ISO и управления образами CD/DVD в Archlinux 💿 📀 💽 💾 >>> ${NC}"
# Installing utilities (packages) for burning ISO and managing CD/DVD images in Archlinux
echo ""
echo -e "${YELLOW}==> Примечание! ${BOLD}*Качество оптических приводов и самих дисков очень сильно варьируется. Главным образом, для получения надёжной записи рекомендуется производить ее на низкой скорости. Если появляются странные проблемы с записанными вами компакт-дисками, попробуйте производить запись на самой низкой скорости, которую поддерживает ваш привод. Процесс прожига (записи данных на диск) состоит из получения файла образа и последующей его записи на оптический носитель. В принципе, образом может быть любой файл данных. Если вы хотите смонтировать записанный диск, то, как правило, следует указывать файловую систему ISO 9660. Audio CD и мультимедийные CD обычно прожигаются из файла .bin с использованием файла .toc или .cue, который содержит информацию о расположении треков. *Честно говоря, не помню, когда в последний раз пользовался компьютером с CD/DVD- приводом. Это благодаря постоянно развивающейся индустрии технологий, где оптические диски вытесняются USB- накопителями и другими компактными носителями, предлагающими больше места для хранения данных, такими как SD-карты. Однако это не означает, что CD и DVD больше не используются. Небольшой процент пользователей всё ещё использует старые компьютеры, поддерживающие DVD/DC-приводы. Некоторые из них по-прежнему считают целесообразным записывать файлы на CD или DVD по своим личным причинам. ${NC}"
sleep 08

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Xfburn (xfburn) — Простой инструмент для записи CD/DVD дисков?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Xfburn — все еще новая программа, и она пока не может выполнять все распространенные задачи, связанные с записью. Подойдет как для начинающих, так и для продвинутых пользователей. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Xfburn — простая и компактное GTK графическое приложение для записи CD/DVD/Blu-ray дисков. Поддерживает запись ISO образов, создание аудио-дисков, дисков с данными, очистку и форматирование дисков. Xfburn предназначена для использования в лёгком настольном окружении Xfce (официальное приложение для работы с дисками в этой среде рабочего стола), разработчик David Mohr (squisher at xfce.org). Xfburn имеет минимум настроек и только минимально требуемый набор функциональных возможностей для работы с CD/DVD дисками. Xfburn может записать ISO образ CD/DVD диска, создать диск с данными (произвольным набором данных), произвести очистку (форматирование) CD/DVD(-RW), а так же создать Audio CD диск. Xfburn при добавлении файлов поддерживает функцию Drag & Drop (перетащи и брось), для работы с дисками используется библиотека libburnia (проект из двух библиотек предназначенных для чтения и записи оптических дисков). Программа бесплатная, интерфейс полностью русифицирован. Этот проект Лицензируется под GPL-2.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://docs.xfce.org/apps/xfburn/start ; (https://github.com/xfce-mirror/xfburn ; https://archlinux.org/packages/extra/x86_64/xfburn/ ; https://archlinux.org/groups/x86_64/xfce4-goodies/ ; SYNOPSIS: https://man.archlinux.org/man/xfburn.1.en). "
echo -e "${BLUE}:: ${NC}Функции: В настоящее время реализовано: Создание композиций данных. Запись на CD, DVD или BluRay (BD). Создание образов ISO. Записать образы ISO. Создание и запись аудио-CD. Пустые диски. Форматирование и деформатирование дисков DVD-RW. В настоящее время поддержка многосессионных сеансов отсутствует. *Примечание: функция потоковой записи отключает управление ошибками только для BD, что увеличивает скорость записи. Использование этого варианта представляется наиболее оптимальным, поскольку диски с ошибками часто выходят из строя даже при отключенной потоковой записи. "
echo -e "${CYAN}:: ${NC}Подробности поддержки аудио-CD: В комплект входят два транскодера: базовый, который просто пропускает несжатые wav-данные, и gst (gstreamer), который может декодировать любой аудиофайл, для которого присутствует плагин gstreamer. *Базовый транскодер: В аудиокомпиляцию можно добавлять только несжатые (PCM) файлы формата WAV с качеством CD. Используйте ваш любимый аудиоплеер с режимом вывода/плагина для записи дисков, чтобы распаковать существующие аудиофайлы. При добавлении в компиляцию файлов .wav их заголовки проверяются на соответствие формату. Обратите внимание, что эта проверка не очень хорошо протестирована (в частности, она вряд ли будет работать на компьютерах с обратным порядком байтов, таких как PowerPC). Для неё не требуются внешние библиотеки. *Транскодер GST: Основанный на библиотеке gstreamer, он может декодировать практически любой аудиоконтент, если установлены соответствующие плагины. Обратите внимание, что по умолчанию большинство дистрибутивов не устанавливают эти плагины. Но простой поиск плагинов gstreamer в вашем менеджере пакетов должен быстро помочь вам установить их. *При запуске вы можете переключаться между транскодерами, более подробную информацию см. в справке командной строки. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_xfburn  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_xfburn" =~ [^10] ]]
do
    :
done
if [[ $in_xfburn == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_xfburn == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Xfburn (xfburn) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) библиотек "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed libburn  # Библиотека для чтения, мастеринга и записи оптических дисков ; https://archlinux.org/packages/extra/x86_64/libburn/ ; https://dev.lovelyhq.com/libburnia ;   2023-06-08 17:53 UTC
sudo pacman -S --noconfirm --needed libgudev  # Привязки GObject для libudev ; https://archlinux.org/packages/extra/x86_64/libgudev/ ; https://gitlab.gnome.org/GNOME/libgudev ; Обеспечивает: libgudev-1.0.so=0-64 ; 2025-05-14 13:21 UTC
sudo pacman -S --noconfirm --needed libisofs  # Библиотека для упаковки файлов и каталогов жесткого диска в образ диска ISO 9660 ; https://archlinux.org/packages/extra/x86_64/libisofs/ ; https://dev.lovelyhq.com/libburnia ; 2023-06-08 17:35 UTC
sudo pacman -S --noconfirm --needed libisoburn  # (необязательно) — iso9660 extfs ; Фронтенд для библиотек libburn и libisofs ; https://archlinux.org/packages/extra/x86_64/libisoburn/ ; https://dev.lovelyhq.com/libburnia ; Обеспечивает: xorriso, xorriso-tcltk ; 2023-06-08 17:59 UTC
#sudo pacman -S --noconfirm --needed libxfce4ui  # Библиотека виджетов для среды рабочего стола Xfce ; https://archlinux.org/packages/extra/x86_64/libxfce4ui/ ; https://docs.xfce.org/xfce/libxfce4ui/start ; 2025-08-16 10:01 UTC
############ xfburn ###############
sudo pacman -S --noconfirm --needed xfburn  # Простой инструмент для записи CD/DVD на основе библиотек libburnia ; https://archlinux.org/packages/extra/x86_64/xfburn/ ; https://docs.xfce.org/apps/xfburn/start ; https://archlinux.org/groups/x86_64/xfce4-goodies/ ; https://github.com/xfce-mirror/xfburn ; Группы: xfce4-goodies ; 2025-06-20 20:18 UTC
  echo ""
  echo " Посмотрите информацию о версии (xfburn) "
# xfburn --version  # Показать версию приложения
sudo pacman -Q xfburn  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# Оптический привод:
# https://wiki.archlinux.org/title/Optical_disc_drive
# https://github.com/greg-js/arch-wiki-md-repo/blob/master/wiki/_content/russian/Optical%20disc%20drive%20(russian).md
####################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Brasero (brasero) — Инструмент для мастеринга CD/DVD?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *В Linux есть несколько приложений для записи файлов на CD или DVD. Но, безусловно, лучшим приложением для записи файлов является Brasero CD/DVD Burner. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Brasero — официально включенное в состав Gnome (2.26 и старше), C (си) / GTK+ графическое приложение для записи CD-R/W и DVD-R/W. Он обладает рядом уникальных функций, позволяющих пользователям легко и быстро создавать свои диски. Brasero представляет собой графический интерфейс для нескольких консольных утилит. Для записи на оптические диски используется комплекс консольных утилит cdrtools и библиотека libburn (чтение и запись оптических дисков), а для работы с DVD и Blu-ray дисками используется набор утилит dvd+rw-tools, поддержку аудио/видео форматов обеспечивает Gstreamer (мультимедийный фреймворк, ядро мультимедийных приложений). Brasero модульное приложение, имеющее простой, интуитивно понятный пользовательский интерфейс и предоставляет все необходимые инструменты для записи оптических дисков, интегрируется в область уведомлений (при запущенных действиях) и показывает всплывающие уведомления. Этот проект Лицензируется под GPL. ${NC}"
echo " Домашняя страница: https://wiki.gnome.org/Apps/Brasero ; (https://github.com/GNOME/brasero ; https://archlinux.org/packages/extra/x86_64/brasero/). "
echo -e "${BLUE}:: ${NC}Функции: Поддерживает несколько бэкэндов: cdrtools , growisofs и libburn (опционально). *CD/DVD с данными: Редактирование содержимого дисков (удаление/перемещение/переименование файлов внутри каталогов). Запись данных на CD/DVD «на лету». Автоматическая фильтрация нежелательных файлов (скрытых файлов, неработающих/рекурсивных символических ссылок, файлов, не соответствующих стандарту joliet). Поддержка мультисессий. Поддержка расширений Joliet. Запись образа на жесткий диск. Проверка целостности файла на диске. *Аудио CD: Запись информации CD-TEXT (автоматически найдена благодаря gstreamer). Поддерживает редактирование информации CD-TEXT. Запись аудио CD на лету. Использовать все аудиофайлы, обрабатываемые локальной установкой Gstreamer (ogg, flac, mp3, ...). Поиск аудиофайлов внутри перемещенных папок. Полное издание пауз между треками. *Копия CD/DVD: Скопируйте CD/DVD на жесткий диск. Копируйте CD и DVD на лету. Поддержка односессионных DVD-дисков с данными. Все виды поддержки CD. *Другие Функции: Стереть CD/DVD. Сохранение и загрузка проекта. Запись образов CD/DVD и CUE-файлов. Предварительный просмотр песен, изображений и видео. Обнаружение устройства. Уведомление об изменении файла. Настраиваемый графический интерфейс (при использовании с GDL). Поддерживает перетаскивание/вырезание и вставку из файлов. Использовать файлы в сети, если протокол поддерживается gnome-vfs. Поиск файлов благодаря Beagle (поиск основан на ключевых словах или типе файла). Может отображать плейлист и его содержимое (обратите внимание, что плейлисты автоматически ищутся через Beagle). Все операции ввода-вывода на диске выполняются асинхронно, чтобы предотвратить блокировку приложения. Сохранение проектов — возможность сохранять конфигурации записи для будущего использования. "
echo -e "${CYAN}:: ${NC}*Запустить Brasero можно разными способами: Из терминала: открыть терминал, ввести команду brasero, нажать Enter. Из меню приложений: нажать на кнопку «Activities» в левом верхнем углу рабочего стола, ввести «Show Applications» в строке поиска и нажать соответствующий значок, затем выбрать «Brasero» из списка приложений. *Настройка: Brasero предлагает различные варианты настройки для оптимизации производительности и поведения. Например: idroot.us . В меню «Plugins» можно включить или отключить конкретные плагины, чтобы расширить функциональность программы или улучшить её совместимость с определёнными типами оптических носителей. В меню «Preferences» можно изменять настройки, связанные с пользовательским интерфейсом, скоростью записи и расположением временных файлов. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_brasero  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_brasero" =~ [^10] ]]
do
    :
done
if [[ $in_brasero == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_brasero == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Brasero (brasero) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########### brasero ###########
sudo pacman -S --noconfirm --needed brasero  # Инструмент для мастеринга CD/DVD ; https://archlinux.org/packages/extra/x86_64/brasero/ ; https://wiki.gnome.org/Apps/Brasero ; https://github.com/GNOME/brasero ; 2025-04-30 17:32 UTC
  echo ""
  echo " Посмотрите информацию о версии (brasero) "
# brasero --version  # Показать версию приложения
sudo pacman -Q brasero  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить K3b (k3b) — Приложение для записи CD-R/W, DVD-R/W и Blu-ray дисков?"
echo -e "${MAGENTA}:: ${BOLD}K3b — модульное C++ / KDE (kdelibs) графическое приложение для записи CD-R/W, DVD-R/W и Blu-ray. K3b является удобным графическим интерфейсом для нескольких консольных утилит, таких как: cdrecord (консольная утилита для записи данных на оптические диски), growisofs (ядро набора консольных утилит dvd+rw-tools предназначенных для работы с DVD и Blu-ray дисками), cdrdao (запись AudioCD или CD с данными в режиме disk-at-once (DAO) основываясь на текстовом описании содержимого CD) и некоторых других... Так как K3b модульное приложение, то и большинство функциональных возможностей в нём реализовано с помощью подключаемых модулей и наличие тех или иных функций определяется самим пользователем. Целью проекта K3b является предоставление пользователю надёжного и многофункционального инструмента, с простым и понятным пользовательским интерфейсом, для выполнения всего спектра задач связанных с записью дисков. По словам разработчиков приложение "Оптимизировано для работы в KDE", однако не входит не в один из компонентов окружения и без проблем может быть использовано в других средах рабочего стола (Gnome, Xfce и.т.д...). Разработка K3b начата в 2001 году, а в марте 2007 года вышел полноценный релиз K3b 1.0. K3b поддерживает все форматы носителей, который поддерживаются имеющимся приводом CD/DVD. Для опытных пользователей предоставляется возможность полностью контролировать весь процесс записи, а для начинающих предоставляются рамные стандартные параметры для автоматического решения практически любых задач. Этот проект Лицензируется под GPL-2.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://apps.kde.org/k3b/ ; (https://github.com/KDE/k3b ; https://archlinux.org/packages/extra/x86_64/k3b/). "
echo -e "${BLUE}:: ${NC}Функции: С помощью K3b можно записать данные на CD-R/W и DVD-R/W, делать копии CD или DVD (сделать копию содержимого диска на пустой диск или в файл образ). K3b позволяет создать файл образ или записать CD-R/W или DVD-R/W из существующего файла образа диска. Перед запуском процесса копирования можно изменить множество параметров копирования и записи (сразу включена поддержка файлов образов iso, cue и cdrdao images).С помощью подключенных модулей K3b может записать звуковые компакт-диски, используя звуковые файлы форматов ogg, flac и mp3 (есть возможность перед записью переименовать аудиофайлы в проекте). Можно создавать видео DVD или SVCD из файлов с расширением .mpg, .mpeg, .avi и других... Созданные и записанные на диск DVD, SVCD или VCD видеофайлы можно воспроизводить на любом обычном проигрывателе DVD. Поддерживается CD и DVD Ripping/burning (Audio CDs в wav, ogg, flac, mp3 и др...), кодировка DVD в mpeg4, получение данных о CD из CDDB и многое другое. K3b позволяет очистить CD-R/W и DVD-R/W (стирание или очистка CD или DVD удаляет все данные, содержащиеся на CD или DVD), стирать CD-RW, DVD-RW (с одинарным или двойным слоем), а так же DVD+RW (с одинарным или двойным слоем). K3b может делать проверку целостности данных. Проверка целостности "MD5", CD или DVD позволяет убедиться в том что файлы, записанные на диск не были повреждены при записи (особенно важно при записи образов дисков). K3b имеет модуль интеграции с Amarok (многофункциональный проигрыватель аудиофайлов для KDE) позволяющий записывать Audio CD из окна плеера используя базу тегов (метаданных). K3b может быть использовано и для прямой записи из Konqueror (файловый менеджер и веб-браузер/компонент среды KDE) или Dolphin (KDE файловый менеджер использующийся "по умолчанию" с KDE). "
echo -e "${CYAN}:: ${NC}Интерфейс у K3b многопанельный и полностью настраиваемый (как и у большинства KDE приложений), есть поддержка тем оформления. В основном окне можно оставить кнопки запуска только часто используемых функций (все остальные функции будут доступны из контекстного меню), в проект файлы можно добавлять как из файлового менеджера (в окне приложения), так и перетаскиванием (функция Drag & Drop/Перетащи и брось). "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_k3b  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_k3b" =~ [^10] ]]
do
    :
done
if [[ $in_k3b == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_k3b == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) K3b (k3b) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed cdparanoia  # (необязательно) — для поддержки копирования CD ; Инструмент для извлечения цифрового аудио с компакт-дисков ; https://archlinux.org/packages/extra/x86_64/cdparanoia/ ; https://www.xiph.org/paranoia/ ; 2023-12-22 21:08 UTC
sudo pacman -S --noconfirm --needed cdrdao  # (необязательно) — для поддержки режима disk-at-once (DAO) ; Записывает аудио / данные CD-R в режиме disk-at-once (DAO) ; http://cdrdao.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/cdrdao/ ; https://cdrdao.sourceforge.net/gcdmaster/ ; 12 июля 2024 г., 2:07 UTC
sudo pacman -S --noconfirm --needed cdrtools  # cdrtools (опционально) — для записи CD с помощью cdrecord ; Портативное программное обеспечение для командной строки для записи CD/DVD/BluRay ; https://archlinux.org/packages/extra/x86_64/cdrtools/ ; https://sourceforge.net/projects/cdrtools/ ; Обеспечивает: cdrkit ; Заменяет: cdrkit ; Конфликты: с cdrkit ; 2024-07-27 11:48 UTC ; cdrtools — коллекция консольных утилит для записи данных на оптические диски. cdrtools включает в себя средства создания образов файловых систем используемых на CD/DVD дисках, прожига образов дисков на носитель, имеются инструменты считывания записанного диска в образ, преобразования аудиодорожек в файлы формата wav, инструментов для проведения различных проверок.
sudo pacman -S --noconfirm --needed dvd+rw-tools  # (опционально) — для поддержки записи DVD ; Инструменты записи dvd ; Инструменты для мастеринга DVD-носителей ; https://archlinux.org/packages/extra/x86_64/dvd+rw-tools/ ; https://fy.chalmers.se/~appro/linux/DVD+RW ; 2025-08-04 17:25 UTC
sudo pacman -S --noconfirm --needed emovix  # (опционально) — для поддержки загрузочных мультимедийных CD/DVD ; Инструменты для создания Movix-CD ; https://archlinux.org/packages/extra/any/emovix/ ; http://movix.sourceforge.net/ ; 2024-07-01 22:04 UTC
sudo pacman -S --noconfirm --needed vcdimager  # (опционально) — для поддержки записи VCD ; Полнофункциональный набор для мастеринга, создания, дизассемблирования и анализа Video CD и Super Video CD ; https://archlinux.org/packages/extra/x86_64/vcdimager/ ; https://www.gnu.org/software/vcdimager/ ; 2025-04-30 17:36 UTC
########## k3b ##########
sudo pacman -S --noconfirm --needed k3b  # Многофункциональное и простое в использовании приложение для записи компакт-дисков ; https://archlinux.org/packages/extra/x86_64/k3b/ ; https://apps.kde.org/k3b/ ; https://github.com/KDE/k3b ; Группы: kde-applications, kde-multimedia ; 2025-08-16 11:01 UTC
  echo ""
  echo " Посмотрите информацию о версии (k3b) "
# k3b --version  # Показать версию приложения
sudo pacman -Q k3b  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#######

clear
echo -e "${MAGENTA}
  <<< Установка утилит (пакетов) для монтирования (работы) и управления образами CD/DVD в Archlinux 💿 📀 💽 💾 >>> ${NC}"
# Installing utilities (packages) for mounting (working) and managing CD/DVD images in Archlinux
echo ""
echo -e "${YELLOW}==> Примечание! ${BOLD}*В ArchLinux для монтирования устройств CD/DVD и управления образами CD/DVD доступны специальные пакеты. По умолчанию в дистрибутиве не предусмотрена функция автомонтирования устройств, но можно установить пакеты, которые позволяют настроить этот функционал. ${NC}"
sleep 07
clear
echo ""
echo -e "${BLUE}:: ${NC}Установить CDEmu (cdemu-daemon)(cdemu-client) — Простая утилита для создания виртуальных CD/DVD-приводов?"
echo -e "${YELLOW}==> Примечание! ${BOLD}*CDemu можно установить с помощью пакета cdemu-client. Этот пакет использует в качестве зависимости cdemu-daemon (cdemu-daemon.service) — который предоставляет службу, которую можно включить и запустить. Обратите внимание, что это пользовательская служба. Если вы используете собственное ядро, вместо стандартного vhba пакета модулей ядра (vhba-module) необходимо использовать DKMS -вариант пакета: vhba-module-dkms . ${NC}"
echo -e "${MAGENTA}:: ${BOLD}CDEmu — это программный пакет, предназначенный для эмуляции оптического привода и диска (включая CD-ROM и DVD-ROM). Он позволяет использовать другие форматы образов дисков, содержащие не только стандартную файловую систему ISO-9660, например, образы .bin/.cue, .nrg или .ccd . CDemu mount может напрямую работать только с образами дисков .iso (содержащими одну файловую систему), но многие образы содержат несколько сессий, смешанные дорожки данных и звука… Короче говоря, cdemu позволяет легко монтировать практически любые файлы образов. Этот проект Лицензируется под GPL-2.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://cdemu.sourceforge.io/ ; (https://archlinux.org/packages/extra/any/cdemu-client/ ; https://archlinux.org/packages/extra/x86_64/cdemu-daemon/). "
echo -e "${BLUE}:: ${NC}Демон CDEmu (cdemu-daemon) — это демон пользовательского пространства, входящий в состав пакета cdemu. Он получает команды SCSI от модуля ядра и обрабатывает их, передавая запрошенные данные обратно ядру. Демон реализует виртуальное устройство; по одному экземпляру на каждое устройство, зарегистрированное модулем ядра. Для доступа к образам (например, для чтения секторов) он использует библиотеку libMirage, входящую в состав пакета cdemu. Демон управляется методами, доступными через D-BUS. Он написан на языке C и основан на GLib (и, следовательно, GObjects), но, управляясь через D-BUS, допускает использование разных клиентов, написанных на разных языках. *Функции: Написано на C, основано на GLib и GObjects. Интерфейс D-BUS для связи с клиентами. Реализует набор пакетных команд, указанных в MMC-3 , тем самым эмулируя реальное оптическое устройство. Может регистрироваться как на сеансовой, так и на системной шине. Отладка; оперативное изменение детализации отладочных трассировок. "
echo -e "${CYAN}:: ${NC}CDEmu client (cdemu-client) — это простой клиент командной строки для управления демоном CDEmu. Он позволяет выполнять ключевые задачи, связанные с управлением демоном CDEmu, такие как загрузка и выгрузка устройств, отображение состояния устройств и извлечение/установка отладочных масок устройств. *Функции: CLI-клиент. Отображение состояния устройства, загрузка и выгрузка устройства. Поддержка перечисления поддерживаемых масок отладки, а также получения/установки масок отладки. Поддержка перечисления поддерживаемых парсеров изображений и типов фрагментов. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_cdemu  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_cdemu" =~ [^10] ]]
do
    :
done
if [[ $in_cdemu == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_cdemu == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) CDEmu (cdemu-daemon)(cdemu-client) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed libao  # Кроссплатформенная библиотека аудиовывода и плагины ; https://archlinux.org/packages/extra/x86_64/libao/ ; https://xiph.org/ao/ ; Обеспечивает: libao.so=4-64 ; 2025-07-19 23:14 UTC
sudo pacman -S --noconfirm --needed libmirage  # Образ CD-ROM (B6T/C2D/CCD/CDI/CIF/CUE/ISO/MDS/MDX/NRG/TOC) доступ к библиотеке ; https://archlinux.org/packages/extra/x86_64/libmirage/ ; https://cdemu.sourceforge.io/ ; 2025-03-31 03:13 UTC
sudo pacman -S --noconfirm --needed vhba-module  # Модуль ядра, эмулирующий устройства SCSI ; https://archlinux.org/packages/extra/x86_64/vhba-module/ ; https://cdemu.sourceforge.io/ ; Обеспечивает: VHBA-MODULE ; Обратные конфликты: с vhba-module-dkms ; 2025-08-29 10:17 UTC
###  Если вы используете собственное ядро, вместо стандартного vhba пакета модулей ядра ( vhba-module ) необходимо использовать DKMS -вариант пакета: vhba-module-dkms .
# sudo pacman -S --noconfirm --needed vhba-module-dkms  # Модуль ядра, эмулирующий устройства SCSI ; https://archlinux.org/packages/extra/x86_64/vhba-module-dkms/ ; https://cdemu.sourceforge.io/ ; Обеспечивает: VHBA-MODULE ; Обратные конфликты: с vhba-module ; 2025-08-29 10:17 UTC
############ cdemu-client ##############
sudo pacman -S --noconfirm --needed cdemu-daemon  # Демон эмулятора устройства CD/DVD-ROM ; https://archlinux.org/packages/extra/x86_64/ ;  cdemu-daemon/ ; https://cdemu.sourceforge.io/ ; 2024-07-08 22:25 UTC
sudo pacman -S --noconfirm --needed cdemu-client  # Простой клиент командной строки для управления cdemu-daemon ; https://archlinux.org/packages/extra/any/cdemu-client/ ; Конфликты: cdemu ; 2024-07-08 22:27 UTC
  echo ""
  echo " Загрузка драйверов (модуль адаптера виртуального хоста) для CD/DVD-приводов, если это еще не сделано "
# Поскольку systemd не загружает драйверы (модуль адаптера виртуального хоста) для CD/DVD-приводов автоматически, вам придется сделать это вручную:
sudo modprobe -a sg sr_mod vhba  # Загрузите драйверы для CD/DVD-приводов, если это еще не сделано
#sudo modprobe sg sr_mod vhba  # Загрузите драйверы для CD/DVD-приводов, если это еще не сделано
#sudo modprobe vhba  # добавить модуль адаптера виртуального хоста
  echo ""
  echo " Проверить наличие модуля CD/DVD-приводов "
  echo " Убедитесь, что модуль ядра vhba загружен "
sudo lsmod | grep -E vhba  # Убедитесь, что модуль ядра vhba загружен
# sudo lsmod | grep vhba  # Убедитесь, что модуль ядра vhba загружен
# sudo lsmod | grep vhba  # проверьте, добавлен ли модуль
sleep 03
####### ЗАПУСК И ВКЛЮЧЕНИЕ СЛУЖБЫ cdemu-daemon.service ##########
# systemctl enable cdemu-daemon.service
# systemctl start cdemu-daemon.service
# systemctl status cdemu-daemon.service
# cdemu status  # Отображение статуса устройства
  echo ""
  echo " Посмотрите информацию о версии (cdemu) "
# cdemu --version  # Показать версию приложения
# cdemu version  # Отображение версии демона и библиотеки
sudo pacman -Q cdemu-client  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# Мне удалось установить cdemu и запустить игру, требующую CD.
# Вот пошаговое руководство:
# sudo steamos-readonly disable  # отключить режим только для чтения в операционной системе
# cdemu load 0 <path/to/your/iso_file.sio>  # наконец, загрузите свой iso-файл
# sudo steamos-readonly enable  # включить режим только для чтения для операционной системы обратно
### Примеры:
# Загрузка одного изображения на первое устройство:
# $ cdemu load 0 ~/image.mds
# Загрузка многофайлового изображения на первое устройство:
# $ cdemu load 0 ~/session1.toc ~/session2.toc ~/session3.toc
# Загрузка текстового изображения в кодировке, отличной от ASCII/Unicode:
# $ cdemu load 0 ~/image.cue --encoding=windows-1250
# Загрузка зашифрованного изображения с паролем, указанным в качестве аргумента:
# $ cdemu load 0 ~/image.always --password=seeinplain
# Выгрузка первого устройства:
# $ cdemu выгрузить 0
# Отображение статуса устройства:
# $ cdemu статус
# Отображение информации о сопоставлении устройств:
# $ cdemu сопоставление устройств
# Настройка маски отладки демона для первого устройства:
# $ cdemu daemon-debug-mask 0 0x01
# Получение маски отладки библиотеки для первого устройства:
# $ cdemu library-debug-mask 0
# Отключение эмуляции DPM на всех устройствах:
# $ cdemu dpm-эмуляция все 0
# Включение эмуляции скорости передачи данных на первом устройстве:
# $ cdemu tr-эмуляция 0 1
# Изменение идентификатора первого устройства:
# $ cdemu device-id 0 "MyVendor" "MyProduct" "1.0.0" "Тестовый идентификатор устройства"
# Перечисление поддерживаемых парсеров:
# $ cdemu enum-supported-parsers
# Перечисление поддерживаемых фрагментов:
# $ cdemu enum-supported-fragments
# Перечисление поддерживаемых масок отладки демона:
# $ cdemu enum-daemon-debug-masks
# Перечисление поддерживаемых масок отладки библиотеки:
# $ cdemu enum-library-debug-masks
# Отображение версии демона и библиотеки:
# $ cdemu версия
# Включение поддержки шифрования CSS на диске 0 (для случаев прерывистого воспроизведения DVD-видео)
# $ cdemu dvd-report-css 0 1
####################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить gCDEmu (gcdemu) GTK/Gnome или KDE CDEmu Manager (kde-cdemu-manager) — Графический интерфейс для CDEmu?"
echo -e "${YELLOW}==> Примечание! ${BOLD}*Доступно несколько графических интерфейсов: GTK/Gnome и KDE. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}gCDEmu (GTK/Gnome) — официальная версия GTK, которая также предоставляет апплет панели GNOME. *KDE CDEmu Manager — это простой интерфейс для CDEmu. Эквивалент KDE, который также интегрируется с меню действий Dolphin при щелчке правой кнопкой мыши по файлу изображения. Этот проект Лицензируется под GPL2, GPL-3.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: http://cdemu.sourceforge.net/ ; (https://github.com/marcelh83/kde-cdemu-manager ; https://aur.archlinux.org/packages/gcdemu ; https://aur.archlinux.org/packages/kde-cdemu-manager). "
echo -e "${BLUE}:: ${NC}gCDEmu предоставляет графический интерфейс, позволяющий выполнять ключевые задачи, связанные с управлением демоном CDEmu, такие как загрузка и выгрузка устройств, отображение состояния устройств и извлечение/установка отладочных масок устройств. Кроме того, приложение прослушивает сигналы, испускаемые демоном CDEmu, и отправляет уведомления через libnotify (при условии, что установлены привязки Python). *Функции: Приложение GTK. Поддерживает связь через сеансовую или системную шину. Отображение состояния устройства, загрузка и выгрузка устройства. Поддержка получения/установки отладочных масок устройства. Уведомление об изменении состояния демона и устройства через libnotify. "
echo -e "${CYAN}:: ${NC}KDE CDEmu Manager предоставляет небольшое окно менеджера, которое дает вам обзор ваших виртуальных дисков и позволяет монтировать и отключать образы. Также имеется сервисное меню для монтирования изображений непосредственно из Dolphin/Konqueror. Изображения можно отмонтировать, как и любые другие носители, через Dolphin или средство уведомления устройства. "
echo -e "${CYAN}:: ${NC}Установка GCDEmu (gcdemu) и KDE CDEmu Manager (kde-cdemu-manager), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/gcdemu.git), (https://aur.archlinux.org/kde-cdemu-manager.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить gCDEmu (gcdemu) GTK/Gnome,   2- Установить KDE CDEmu Manager (kde-cdemu-manager),

    0 - НЕТ - Пропустить установку: " in_gcdemu  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_gcdemu" =~ [^120] ]]
do
    :
done
if [[ $in_gcdemu == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_gcdemu == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) gCDEmu (gcdemu) GTK/Gnome "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed libappindicator-gtk3  # (необязательно) ; Разрешить приложениям расширять меню с помощью индикаторов Ayatana в Unity, KDE или Systray (библиотека GTK+ 3) ; https://archlinux.org/packages/extra/x86_64/libappindicator-gtk3/ ; https://launchpad.net/libappindicator ; 2024-07-15 09:19 UTC
sudo pacman -S --noconfirm --needed lib32-libappindicator-gtk3  # Разрешить приложениям расширять меню с помощью индикаторов Ayatana в Unity, KDE или Systray (32-бит) (библиотека GTK+ 3) ; https://archlinux.org/packages/multilib/x86_64/lib32-libappindicator-gtk3/ ; https://launchpad.net/libappindicator ; 2024-05-11 13:57 UTC
sudo pacman -S --noconfirm --needed libnotify  # (необязательно) ; Библиотека для отправки уведомлений на рабочий стол ; https://archlinux.org/packages/extra/x86_64/libnotify/ ; https://gitlab.gnome.org/GNOME/libnotify ; Обеспечивает: libnotify.so=4-64 ; 2025-03-29 00:39 UTC
######### gcdemu ###########
yay -S gcdemu --noconfirm  # Апплет панели GNOME, управляющий cdemu-daemon ; https://aur.archlinux.org/packages/gcdemu ; https://aur.archlinux.org/gcdemu.git (только для чтения, нажмите, чтобы скопировать) ; http://cdemu.sourceforge.net/ ; https://downloads.sourceforge.net/cdemu/gcdemu-3.2.6.tar.xz ; 2021-10-25 13:46 (UTC)
######### gcdemu ###########
#git clone https://aur.archlinux.org/gcdemu.git  # (только для чтения, нажмите, чтобы скопировать)
#cd gcdemu
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gcdemu
#rm -Rf gcdemu
  echo ""
  echo " Посмотрите информацию о версии (gcdemu) "
sudo pacman -Q gcdemu  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_gcdemu == 2 ]]; then
  echo ""
  echo " Установка утилиты (пакета) KDE CDEmu Manager (kde-cdemu-manager) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
######### kde-cdemu-manager ###########
yay -S kde-cdemu-manager --noconfirm  # KDE CDEmu Manager — это простой интерфейс для CDEmu ; https://aur.archlinux.org/packages/kde-cdemu-manager ; https://aur.archlinux.org/kde-cdemu-manager.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/marcelh83/kde-cdemu-manager ; https://github.com/marcelh83/kde-cdemu-manager/archive/refs/tags/v0.9.tar.gz ; Конфликты: kde-cdemu-manager ; Обеспечивает: kde-cdemu-manager ; 2024-04-21 09:10 (UTC)
######### kde-cdemu-manager ###########
#git clone https://aur.archlinux.org/kde-cdemu-manager.git  # (только для чтения, нажмите, чтобы скопировать)
#cd kde-cdemu-manager
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf kde-cdemu-manager
#rm -Rf kde-cdemu-manager
  echo ""
  echo " Посмотрите информацию о версии (kde-cdemu-manager) "
sudo pacman -Q kde-cdemu-manager  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить AcetoneISO (acetoneiso2) — Управление образами CD/DVD?"
echo -e "${YELLOW}==> Примечание! ${BOLD}*Целью разработчиков было создать простую, интуитивно понятную, стабильную программу для работы с образами CD/DVD-дисков. *Ограничения: Не может эмулировать защиту от копирования. Невозможно примонтировать мульти-секторные образы. Отображается только первая дорожка. Конвертирование мульти-трековых образов в ISO может привести к потере данных. Конвертируется только первая дорожка. Конвертирование образов в ISO возможна только на архитектуре x86 и x86-64 из-за ограничений PowerISO. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}AcetoneISO — многофункциональное графическое приложение с открытым исходным кодом, предназначенное для монтирования и управления образами CD/DVD в Linux. Программа написана на Qt 5, что означает, что он хорошо интегрируется в среды рабочего стола на базе Qt, такие как KDE, LXQt или Razor-qt и предназначена для тех, кому нужен DAEMON Tools или Alcohol 120% под Linux, но с новыми возможностями. Тем не менее, AcetoneISO не эмулирует диски с любыми способами защиты от копирования при монтировании. AcetoneISO также поддерживает образы формата Direct Access Archive (.DAA), так как использует PowerISO как бэк-энд для конвертирования образов в ISO. Утилита открывает графический файловый менеджер для монтирования форматов образов, включая фирменные форматы образов, такие как ISO, BIN, NRG, MDF, IMG и т. д., а также позволяет выполнять ряд действий. AcetoneISO имеет приятный внешний вид, прост в настройке и использовании. AcetoneISO легко интегрируется в любую рабочую среду. При старте вам нужно будет выбрать набор предпочитаемых приложений. Этот проект Лицензируется под GNU General Public License v3.0 . ${NC}"
echo " Домашняя страница: https://sourceforge.net/projects/acetoneiso ; (https://github.com/BigLinuxAur/acetoneiso2 ; https://aur.archlinux.org/packages/acetoneiso2). "
echo -e "${BLUE}:: ${NC}Функции: Некоторые возможности AcetoneISO: быстрое монтирование ISO, монтирование образов в папку (*.iso *.mdf *.nrg). База Данных образов, экстракт данных из образов (*.iso *.bin *.daa *.mdf *.nrg *.img),  проигрывание образов DVD-видео, конвертация форматов *.mdf *.img *.bin *.nrg *.cdi *.b5i *.bwi *.xbx *.pdi *.daa в *.iso , создание *.iso образа из папки/устройства, сжатие образа в архив 7zip, запись CD/DVD образов (*.iso *.cue *.toc)на диск, запись ISO, CUE, TOC через вызов K3b, форматирование RW болванок, создание и проверка MD5 сумм, разбивка образов на куски для переноса на носителях меньшего размера. Шифрование и дешифрование ISO образов. Возможность рипать PSX-CD в BIN/TOC образ. Генерация CUE файла для IMG/BIN образа. Возможность создания образов дисков Sony PlayStation *.bin для использования с эмуляторами. Конвертация Mac OS *.dmg в монтируемый образ. Поддержка El-Toritoдля создания образа загрузочного CD. Extract the Boot Image of a CD/DVD or ISO. Резервная копия CD-Audio в образ *.bin . Интеграция с Konqueror/Nautilus (на уровне меню). "
echo -e "${CYAN}:: ${NC}Особенности включают в себя: Монтируйте большинство распространенных образов Windows в понятном и простом графическом интерфейсе. Конвертируйте все известные образы в ISO или извлеките содержимое в папку. Шифруйте, сжимайте, разделяйте любые типы изображений. Конвертируйте DVD-видео в xvid avi и любое обычное видео в xvid avi. Извлечь аудио из видео. Извлеките содержимое изображений в папку: bin mdf nrg img daa dmg cdi b5i bwi pdi. Воспроизведите образ фильма на DVD с помощью Kaffeine / VLC / SMplayer с автоматической загрузкой обложки с Amazon. Создайте ISO-образ из папки или CD/DVD. Проверьте MD5-файл изображения и/или сгенерируйте его в текстовый файл. Рассчитайте ShaSums изображений в 128, 256 и 384 бит. Зашифровать/расшифровать изображение. Разделить/Объединить изображение размером X мегабайт. Сжатие изображения в формате 7z с высокой степенью сжатия. Скопируйте PSX CD в *.bin, чтобы он работал с эмуляторами ePSXe/pSX. Восстановить утерянный CUE-файл *.bin *.img. Конвертировать Mac OS *.dmg в монтируемый образ. Смонтировать образ в указанной пользователем папке. Создайте базу данных изображений для управления большими коллекциями. Извлеките файл загрузочного образа с CD/DVD или ISO. Резервное копирование CD-Audio в образ *.bin. Быстрая и простая утилита для копирования DVD в Xvid AVI. Быстрая и простая утилита для конвертации обычного видео (avi, mpeg, mov, wmv, asf) в Xvid AVI. Быстрая и простая утилита для конвертации FLV-видео в AVI. Утилита для загрузки видео с YouTube и Metacafe. Извлечь аудио из видеофайла. Извлеките архив *.rar, защищенный паролем. Утилита для конвертации любого видео для Sony PSP PlayStation Portable. Поддержка интернационализации – английский, итальянский, польский, испанский, румынский, венгерский, немецкий, чешский и русский. "
echo -e "${CYAN}:: ${NC}Установка AcetoneISO (acetoneiso2), (phonon-qt5) и (qt5-webkit), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/acetoneiso2.git), (https://aur.archlinux.org/phonon-qt5.git), (https://aur.archlinux.org/qt5-webkit.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_acetoneiso  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_acetoneiso" =~ [^10] ]]
do
    :
done
if [[ $in_acetoneiso == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_acetoneiso == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) AcetoneISO (acetoneiso2) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
########### phonon-qt5 #########
yay -S phonon-qt5 --noconfirm  # Мультимедийная среда от KDE ; https://aur.archlinux.org/packages/phonon-qt5 ; https://aur.archlinux.org/phonon-qt5.git (только для чтения, нажмите, чтобы скопировать) ; https://community.kde.org/Phonon ; https://download.kde.org/stable/phonon/4.12.0/phonon-4.12.0.tar.xz ; https://download.kde.org/stable/phonon/4.12.0/phonon-4.12.0.tar.xz.sig ; 2025-07-22 07:05 (UTC)
########### phonon-qt5 #########
#git clone https://aur.archlinux.org/phonon-qt5.git  # (только для чтения, нажмите, чтобы скопировать)
#cd phonon-qt5
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf phonon-qt5
#rm -Rf phonon-qt5
########### qt5-webkit #########
yay -S qt5-webkit --noconfirm  # Классы для реализации на базе WebKit2 и нового API QML ; https://aur.archlinux.org/packages/qt5-webkit?all_deps=1#pkgdeps ; https://aur.archlinux.org/qt5-webkit.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/qtwebkit/qtwebkit ; https://github.com/qtwebkit/qtwebkit/releases/download/qtwebkit-5.212.0-alpha4/qtwebkit-5.212.0-alpha4.tar.xz ; 2025-07-01 21:35 (UTC)
########### qt5-webkit #########
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
########### acetoneiso2 #########
yay -S acetoneiso2 --noconfirm  # Универсальный инструмент ISO (bin mdf nrg img daa dmg cdi b5i bwi pdi iso) ; https://aur.archlinux.org/packages/acetoneiso2 ; https://aur.archlinux.org/acetoneiso2.git (только для чтения, нажмите, чтобы скопировать) ; https://sourceforge.net/projects/acetoneiso ; https://github.com/BigLinuxAur/acetoneiso2 ; http://deb.debian.org/debian/pool/main/a/acetoneiso/acetoneiso_2.4.orig.tar.gz ; Конфликты: с acetoneiso ; 2023-01-29 22:33 (UTC)
########### acetoneiso2 #########
#git clone https://aur.archlinux.org/acetoneiso2.git  # (только для чтения, нажмите, чтобы скопировать)
#cd acetoneiso2
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf acetoneiso2
#rm -Rf acetoneiso2
############################
  echo ""
  echo " Посмотрите информацию о версии (acetoneiso) "
sudo pacman -Q acetoneiso2  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#############

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
echo -e "${BLUE}:: ${NC}Если хотите установить дополнительный софт (пакеты), тогда после перезагрузки и входа в систему выполните команду:"
echo -e "${YELLOW}==> ${CYAN}wget git.io/archmy5l && sh archmy5l ${NC}"
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