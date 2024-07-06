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
##############
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
sudo pacman -S --noconfirm --needed cronie  # Демон, который запускает указанные программы в запланированное время и связанные инструменты
echo ""
echo " Добавляем в автозагрузку планировщик заданий (cronie.service) "
sudo systemctl enable cronie.service
echo ""
echo " Планировщик заданий CRON (cronie) установлен и добавлен в автозагрузку "
fi
# ---------------------------------------
# Теперь осталось добавить само правило.
# Вбиваем в терминале:
# sudo EDITOR=nano crontab -e   # Редактируем параметр
# И добавляем (прописываем):
# 10 10 * * sun /sbin/rm /var/cache/pacman/pkg/*
# Таким образом наша система будет сама себя чистить раз в неделю, в воскресенье в 10:10 ))
# Или
# 15 10 * * sun /sbin/rm /var/cache/pacman/pkg/*
# Таким образом наша система будет сама себя чистить раз в неделю, в воскресенье в 15:10
# -----------------------------------------
# Т.е. для редактирования списка задач текущего пользователя:
# crontab -e
# Для отображения списка задач текущего пользователя:
# crontab -l
# ===========================================

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
  sudo pacman -S --noconfirm --needed ntp  # Эталонная реализация сетевого протокола времени
  echo ""
  echo " Установка времени по серверу NTP (Network Time Protocol)(ru.pool.ntp.org) "
  sudo ntpdate 0.ru.pool.ntp.org  # будем использовать NTP сервера из пула ru.pool.ntp.org
# sudo ntpdate 1.ru.pool.ntp.org  # Список общедоступных NTP серверов доступен на сайте http://ntp.org
# sudo ntpdate 2.ru.pool.ntp.org  # Отредактируйте /etc/ntp.conf для добавления/удаления серверов (server)
# sudo ntpdate 3.ru.pool.ntp.org  # После изменений конфигурационного файла вам надо перезапустить ntpd (sudo service ntp restart) - Просмотр статуса: (sudo ntpq -p)
  echo " Синхронизации с часами BIOS "  # Синхронизируем аппаратное время с системным
  echo " Устанавливаются аппаратные часы из системных часов. "
  sudo hwclock --systohc  # Эта команда предполагает, что аппаратные часы настроены в формате UTC.
# sudo hwclock -w  # переведёт аппаратные часы
# sudo hwclock --adjust  # Порой значение аппаратного времени может сбиваться - выровняем!
  echo ""
  echo " Добавим в автозагрузку NTPD (openntpd.service) "
  sudo systemctl enable ntpd.service
  sudo systemctl start ntpd.service
  echo ""
  echo " Установка NTP (Network Time Protocol) выполнена "
  echo " Время точное как на Спасской башне Московского Кремля! "
  date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'   # одновременно отображает дату и часовой пояс
elif [[ $i_localtime == 2 ]]; then
  echo ""
  echo " Установка OpenNTPD"
  sudo pacman -S --noconfirm --needed openntpd  # Бесплатная и простая в использовании реализация протокола сетевого времени
  echo " Добавим в автозагрузку OpenNTPD (openntpd.service) "
  sudo systemctl enable openntpd.service
  echo " Установка OpenNTPD и запуск (openntpd.service) выполнен "
fi
# -------------------------------------
# Настройка синхронизации времени в домене с помощью групповых политик состоит из двух шагов:
# 1) Создание GPO для контроллера домена с ролью PDC
# 2) Создание GPO для клиентов (опционально)
# https://zen.yandex.ru/media/winitpro.ru/ntp-sinhronizaciia-vremeni-v-domene-s-pomosciu-gruppovyh-politik-5b5042923e546700a8ccf633?utm_source=serp
# (https://www.8host.com/blog/ustanovka-i-nastrojka-openntpd-v-freebsd-10-2/)
# ====================================
#################
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
sudo pacman -S --noconfirm --needed ufw gufw  # Несложный и простой в использовании инструмент командной строки для управления межсетевым экраном netfilter; GUI - для управления брандмауэром Linux
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
sudo pacman -S --noconfirm --needed clamav clamtk  # Антивирусный инструментарий для Unix; Простой в использовании, легкий сканер вирусов по запросу для систем Linux
echo " Установка Clam AntiVirus завершена "
fi
sleep 02
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
#################
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
sleep 01
echo ""
echo -e "${BLUE}:: ${NC}Проверим статус запуска Firewall UFW (сетевой экран)"
echo -e "${MAGENTA}:: ${BOLD}Если нужно ВЫКлючить UFW (сетевой экран), то используйте команду: sudo ufw disable. ${NC}"
echo -e "${CYAN}:: ${NC}Проверим статус UFW (сетевой экран), если таковой был вами установлен и запущен."
echo ""
sudo ufw status
#sudo ufw status --verbose
sleep 01
fi
# -----------------------------------
# Вы можете проверить статус работы UFW следующей командой:
# sudo ufw status verbose  # -v, --verbose  -быть вербальным
# Если нужно выключить, то используйте команду:
# sudo ufw disable
# -------------------------------------

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
sleep 01
fi
#################
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
sudo pacman -S --noconfirm --needed bluez bluez-libs bluez-cups bluez-utils  # Демоны для стека протоколов Bluetooth; Устаревшие библиотеки для стека протоколов Bluetooth; Серверная часть CUPS для принтеров Bluetooth; Утилиты разработки и отладки для стека протоколов bluetooth.
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
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (alsa-utils, alsa-plugins, alsa-firmware, alsa-lib, alsa-utils, pulseaudio, pulseaudio-alsa, pavucontrol, pulseaudio-zeroconf, pulseaudio-bluetooth, xfce4-pulseaudio-plugin, projectm-pulseaudio и paprefs)"
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
sudo pacman -S --noconfirm --needed alsa-plugins alsa-firmware alsa-lib  # Расширенная звуковая архитектура Linux - Утилиты; Дополнительные плагины ALSA; Бинарные файлы прошивки для программ загрузки в alsa-tools и загрузчик прошивок hotplug; Альтернативная реализация поддержки звука Linux
sudo pacman -S --noconfirm --needed lib32-alsa-plugins  # Дополнительные плагины ALSA (32-бит)
sudo pacman -S --noconfirm --needed alsa-oss lib32-alsa-oss  # Библиотека совместимости OSS; Библиотека совместимости OSS (32 бит)
#sudo pacman -S alsa-tools --noconfirm  # Расширенные инструменты для определенных звуковых карт
sudo pacman -S --noconfirm --needed alsa-topology-conf alsa-ucm-conf  # Файлы конфигурации топологии ALSA; Конфигурация (и топологии) ALSA Use Case Manager
sudo pacman -S --noconfirm --needed alsa-card-profiles  # Профили карт ALSA, общие для PulseAudio
sudo pacman -S --noconfirm --needed pulseaudio pulseaudio-alsa pavucontrol pulseaudio-bluetooth pulseaudio-equalizer-ladspa
#sudo pacman -S pulseaudio --noconfirm  # Функциональный звуковой сервер общего назначения
#sudo pacman -S pulseaudio-alsa --noconfirm  # Конфигурация ALSA для PulseAudio
#sudo pacman -S pavucontrol --noconfirm  # Регулятор громкости PulseAudio
#sudo pacman -S pulseaudio-bluetooth --noconfirm  # Поддержка Bluetooth для PulseAudio
#sudo pacman -S pulseaudio-equalizer-ladspa --noconfirm  # 15-полосный эквалайзер для PulseAudio (https://github.com/pulseaudio-equalizer-ladspa/equalizer)
### sudo pacman -S pulseaudio-equalizer --noconfirm  # Графический эквалайзер для PulseAudio
sudo pacman -S --noconfirm --needed pulseaudio-zeroconf  # Поддержка Zeroconf для PulseAudio
#sudo pacman -S pulseaudio-lirc --noconfirm  # Поддержка IR (lirc) для PulseAudio
#sudo pacman -S pulseaudio-jack --noconfirm  # Поддержка разъема для PulseAudio
#sudo pacman -S pasystray --noconfirm  # Системный трей PulseAudio (замена # padevchooser)
sudo pacman -S --noconfirm --needed xfce4-pulseaudio-plugin  # Плагин Pulseaudio для панели Xfce4
#sudo pacman -Sy pavucontrol pulseaudio-bluetooth alsa-utils pulseaudio-equalizer-ladspa --noconfirm
sudo pacman -S --noconfirm --needed paprefs  # Диалог конфигурации для PulseAudio (PulseAudio Preferences - https://freedesktop.org/software/pulseaudio/paprefs/)
sudo pacman -S --noconfirm --needed projectm-pulseaudio  # Музыкальный визуализатор (projectM PulseAudio Visualization), использующий ускоренный трехмерный рендеринг на основе итеративного изображения (pulseaudio) https://github.com/projectM-visualizer/projectm
clear
echo ""
echo " Установка пакетов Поддержки звука выполнена "
fi
# ----------------------------------------
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
sudo pacman -S --noconfirm --needed blueman  # blueman --диспетчер bluetooth устройств (полезно для i3)
echo ""
echo " Установка Blueman (менеджер Bluetooth) завершена "
fi
# -------------------------------------------------------------------
# Blueman:
# https://wiki.archlinux.org/index.php/Blueman
# --------------------------------------------------------------------
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
#########################
clear
echo -e "${MAGENTA}
  <<< Установка Архиваторов (консольных), дополнений для архиваторов, менеджеров архивов (графический интерфейс) >>> ${NC}"
# Install Archivers (console), add-ons to archivers, archive managers (graphical interface)
echo ""
echo -e "${GREEN}==> ${NC}Ставим Архиваторы (консольные) - компрессионные инструменты"
#echo -e "${BLUE}:: ${NC}Ставим Архиваторы (консольные) - компрессионные инструменты"
#echo 'Ставим Архиваторы - "Компрессионные Инструменты" и дополнения'
# Installing Archivers-Compression Tools and add-ons
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (zip, unzip, unrar, p7zip, zlib, zziplib, lzop)."
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
sudo pacman -S --noconfirm --needed zip unzip unrar p7zip  # Компрессор / архиватор для создания и изменения zip-файлов; Для извлечения и просмотра файлов в архивах .zip; Программа распаковки RAR; Файловый архиватор из командной строки с высокой степенью сжатия.
sudo pacman -S --noconfirm --needed lzop  # Компрессор файлов с использованием lzo lib
sudo pacman -S --noconfirm --needed zlib zziplib  # Библиотека сжатия, реализующая метод сжатия deflate, найденный в gzip и PKZIP; Легкая библиотека, которая предлагает возможность легко извлекать данные из файлов, заархивированных в один zip-файл.
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
sudo pacman -S --noconfirm --needed lha unace lrzip sharutils arj cabextract # Бесплатная программа для архивирования LZH / LHA; Инструмент для извлечения проприетарного формата архива ace; Многопоточное сжатие с помощью rzip / lzma, lzo и zpaq; Делает так называемые архивы оболочки из множества файлов; Бесплатный и портативный клон архиватора ARJ; Программа для извлечения файлов Microsoft CAB (.CAB).
sudo pacman -S --noconfirm --needed uudeview  # UUDeview помогает передавать и получать двоичные файлы с помощью почты или групп новостей. Включает файлы библиотеки - (мощный декодер бинарных файлов) http://www.fpx.de/fp/Software/UUDeview/
sudo pacman -S --noconfirm --needed snappy  # Библиотека быстрого сжатия и распаковки (на порядок быстрее других) https://github.com/google/snappy
sudo pacman -S --noconfirm --needed minizip  # Mini zip и unzip на основе zlib
sudo pacman -S --noconfirm --needed quazip  # Оболочка C ++ для пакета C ZIP / UNZIP Жиля Воллана
sudo pacman -S --noconfirm --needed brotli  # Универсальный алгоритм сжатия без потерь, который сжимает данные с использованием комбинации современного варианта алгоритма LZ77, кодирования Хаффмана и контекстного моделирования 2-го порядка со степенью сжатия, сопоставимой с лучшими доступными в настоящее время универсальными методами сжатия.
sudo pacman -S --noconfirm --needed pbzip2  #  Параллельная реализация компрессора файлов с сортировкой блоков bzip2
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
echo " 1 - File Roller - Легковесный менеджер архивов для среды рабочего стола GNOME, можно использовать и для другого DE (XFCE, LXDE, Lxqt...) "
echo " File Roller поддерживает множество типов архивов, включая gzip (tar.gz, tar.xz, tgz), bzip (tar.bz, tbz), bzip2 (tar.bz2, tbz2), Z (tar.Z, taz), lzop ( tar.lzo, tzo), zip, jar (jar, ear, war), lha, lzh, rar, ace, 7z, alz, ar и arj. "
echo " Кроме того, он поддерживает типы архивов cab, cpio, deb, iso, cbr, rpm, bin, sit, tar.7z, cbz и zoo, а также отдельные файлы, сжатые с помощью xz, gzip, bzip, bzip2. , lzop, lzip, z или rzip алгоритмы сжатия. "
echo " 2 - Ark (в переводе Ковчег) - Менеджер архивов для среды рабочего стола KDE(Plasma), можно использовать и для другого DE "
echo " Ark поддерживает работу со всеми основными форматами архивов: - (tar, gzip, bzip, bzip2, zip, xpi, lha, zoo, ar, rar) и некоторые другие. Поддерживаются и двойные архивы (например, tar.gz, tzr.bz2 и прочие). "
echo " 3 - Xarchiver (GTK+2) - Легковесный настольный независимый менеджер архивов, созданный с помощью набора инструментов (GTK+2), можно использовать с любой средой рабочего стола "
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
sudo pacman -S --noconfirm --needed file-roller  # легковесный архиватор ( для xfce-lxqt-lxde-gnome )
elif [[ $gui_archiver == 2 ]]; then
echo ""
echo " Установка Менеджера архивов (ark) "
sudo pacman -S --noconfirm --needed ark  # архиватор для ( Plasma(kde)- так же можно использовать, и для другого de )
elif [[ $gui_archiver == 3 ]]; then
echo ""
echo " Установка Менеджера архивов (xarchiver-gtk2) "
sudo pacman -S --noconfirm --needed xarchiver-gtk2  # легкий настольный независимый менеджер архивов
fi
########################
clear
echo -e "${MAGENTA}
  <<< Установка дополнительного софта (пакетов) для Archlinux >>> ${NC}"
# Installing additional software (packages) for Archlinux

echo ""
echo -e "${GREEN}==> ${NC}Установка дополнительных базовых программ (пакетов)"
#echo -e "${BLUE}:: ${NC}Установка дополнительных базовых программ (пакетов)"
#echo 'Установка дополнительных базовых программ (пакетов)'
# Installing additional basic programs (packages)
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (accountsservice, acpi, acpid, android-tools, android-udev, arch-install-scripts, aspell-en, aspell-ru, autofs, b43-fwcutter, bash-completion, beep, bind, btrfs-progs, busybox, c-ares, catfish, ccache, cpio, cpupower, crda, desktop-file-utils, dhclient, dmraid, dmidecode, dnsmasq, dosfstools, efibootmgr, efitools, ethtool, extra-cmake-modules, f2fs-tools, flex, foremost, fortune-mod, fsarchiver, fwupd, fuse3, glances, gnome-nettool, gnu-netcat, gperf, gpm, gptfdisk, gtop, gvfs, gvfs-gphoto2, gvfs-nfs, gvfs-smb, haveged, hddtemp, hdparm, hidapi, hwdetect, hwinfo, hydra, hyphen-en, id3lib, iftop, inxi, inetutils, isomd5sum, jfsutils, kvantum, lib32-curl, lib32-flex, libfm-gtk2, libudev0-shim, lksctp-tools, logrotate, lsof, lsb-release, lvm2, man-db, man-pages, mc, memtest86+, mlocate, mtpfs, ncdu, nfs-utils, nmon, nss-mdns, pacman-contrib, patchutils, pciutils, php, picom_X11, polkit, poppler-data, powertop, pv, pwgen, python-isomd5sum, python-pip, qt5-translations, reiserfsprogs, re2, ruby, s-nail, sane, scrot, sg3_utils, sdparm, sof-firmware, solid, sox, smartmontools, speedtest-cli, squashfs-tools, syslinux, systemd-ui, termite, termite-terminfo, translate-shell, udiskie, udisks2, unixodbc, usbutils, usb_modeswitch, wimlib, wipe, xdg-utils, xfsprogs, xsel, xterm, xorg-twm, xorg-xkill, yelp, yt-dlp,...)."
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
# sudo pacman -S --noconfirm --needed light-locker lsb-release python  # - присутствует
# sudo pacman -S --noconfirm --needed reflector git curl  # - пока присутствует в pkglist.x86_64
sudo pacman -S --noconfirm --needed pacman-contrib  # Предоставленные скрипты и инструменты для систем pacman
sudo pacman -S --noconfirm --needed accountsservice  # Интерфейс D-Bus для запроса учетных записей пользователей и управления ими
sudo pacman -S --noconfirm --needed acpi  # Клиент для показаний батареи, мощности и температуры
sudo pacman -S --noconfirm --needed acpid  # Демон для доставки событий управления питанием ACPI с поддержкой netlink
sudo pacman -S --noconfirm --needed android-tools  # Инструменты платформы Android
sudo pacman -S --noconfirm --needed android-udev  # Правила Udev для подключения устройств Android к вашему Linux-серверу
sudo pacman -S --noconfirm --needed arch-install-scripts  # Сценарии для помощи в установке Arch Linux
sudo pacman -S --noconfirm --needed aspell-en  # Английский словарь для aspell
sudo pacman -S --noconfirm --needed aspell-ru  # Русский словарь для aspell
# ###sudo pacman -S autofs --noconfirm  # Средство автомонтирования на основе ядра для Linux ; Раньше присутствовал в community ...
sudo pacman -S --noconfirm --needed b43-fwcutter  # Экстрактор прошивки для модуля ядра b43 (драйвер)
sudo pacman -S --noconfirm --needed bash-completion  # Программируемое завершение для оболочки bash
sudo pacman -S --noconfirm --needed beep  # Продвинутая программа звукового сигнала динамика ПК
sudo pacman -S --noconfirm --needed bind  # Полная, переносимая реализация протокола DNS
sudo pacman -S --noconfirm --needed btrfs-progs  # Утилиты файловой системы btrfs
sudo pacman -S --noconfirm --needed busybox  # Утилиты для аварийно-спасательных и встраиваемых систем
sudo pacman -S --noconfirm --needed c-ares   # Библиотека AC для асинхронных DNS-запросов
sudo pacman -S --noconfirm --needed catfish  # Универсальный инструмент для поиска файлов
sudo pacman -S --noconfirm --needed ccache  # Кэш компилятора, который ускоряет перекомпиляцию за счет кеширования предыдущих компиляций
sudo pacman -S --noconfirm --needed cpio  # Инструмент для копирования файлов в или из архива cpio или tar
sudo pacman -S --noconfirm --needed cpupower  # Инструмент ядра Linux для проверки и настройки функций вашего процессора, связанных с энергосбережением
sudo pacman -S --noconfirm --needed crda  # Агент центрального регулирующего домена для беспроводных сетей
sudo pacman -S --noconfirm --needed desktop-file-utils  # Утилиты командной строки для работы с записями рабочего стола
sudo pacman -S --noconfirm --needed dhclient  # Автономный DHCP-клиент из пакета dhcp
sudo pacman -S --noconfirm --needed dmraid  # Интерфейс RAID устройства сопоставления устройств
sudo pacman -S --noconfirm --needed dmidecode  # Утилиты, относящиеся к таблице интерфейса управления рабочим столом (https://www.nongnu.org/dmidecode)
sudo pacman -S --noconfirm --needed dnsmasq  # Легкий, простой в настройке сервер пересылки DNS и DHCP-сервер
sudo pacman -S --noconfirm --needed dosfstools  # Утилиты файловой системы DOS
sudo pacman -S --noconfirm --needed efibootmgr  # Приложение пользовательского пространства Linux для изменения диспетчера загрузки EFI
sudo pacman -S --noconfirm --needed efitools  # Инструменты для управления платформами безопасной загрузки UEFI
sudo pacman -S --noconfirm --needed ethtool  # Утилита для управления сетевыми драйверами и оборудованием
sudo pacman -S --noconfirm --needed extra-cmake-modules  # Дополнительные модули и скрипты для CMake
sudo pacman -S --noconfirm --needed f2fs-tools  # Инструменты для файловой системы, дружественной к Flash (F2FS)
sudo pacman -S --noconfirm --needed flex  # Инструмент для создания программ сканирования текста
sudo pacman -S --noconfirm --needed foremost  # Консольная программа для восстановления файлов на основе их верхних и нижних колонтитулов и внутренних структур данных (http://foremost.sourceforge.net/)
sudo pacman -S --noconfirm --needed fortune-mod  # Программа Fortune Cookie от BSD games
sudo pacman -S --noconfirm --needed fsarchiver  # Безопасный и гибкий инструмент для резервного копирования и развертывания файловой системы
sudo pacman -S --noconfirm --needed fuse3  # Библиотека, позволяющая реализовать файловую систему в программе пользовательского пространства
sudo pacman -S --noconfirm --needed fwupd  # Простой демон, позволяющий программному обеспечению сеанса обновлять прошивку (https://github.com/fwupd/fwupd)
sudo pacman -S --noconfirm --needed glances  # Инструмент мониторинга на основе CLI на основе curses
sudo pacman -S --noconfirm --needed gnome-nettool  # Графический интерфейс для различных сетевых инструментов
sudo pacman -S --noconfirm --needed gnu-netcat  # GNU переписывает netcat, приложение для создания сетевых трубопроводов
sudo pacman -S --noconfirm --needed gperf  # Идеальный генератор хэш-функций
sudo pacman -S --noconfirm --needed gpm  # Сервер мыши для консоли и xterm
sudo pacman -S --noconfirm --needed gptfdisk  # Инструмент для создания разделов в текстовом режиме, который работает с дисками с таблицей разделов GUID (GPT)
# sudo pacman -S --noconfirm --needed grub-btrfs  # Включите снимки btrfs в параметры загрузки GRUB
sudo pacman -S --noconfirm --needed gtop  # Панель мониторинга системы для терминала
sudo pacman -S --noconfirm --needed gvfs  # Реализация виртуальной файловой системы для GIO (Разделенные пакеты: gvfs-afc, gvfs-goa, gvfs-google, gvfs-gphoto2, gvfs-mtp, еще…)
# sudo pacman -S --noconfirm --needed gvfs-mtp  # Реализация виртуальной файловой системы для GIO (бэкэнд MTP; Android, медиаплеер)
sudo pacman -S --noconfirm --needed gvfs-afc  # Реализация виртуальной файловой системы для GIO (серверная часть AFC; мобильные устройства Apple)
# sudo pacman -S --noconfirm --needed gvfs-goa  # Реализация виртуальной файловой системы для GIO (серверная часть Gnome Online Accounts; облачное хранилище)
# sudo pacman -S --noconfirm --needed gvfs-google  # Реализация виртуальной файловой системы для GIO (серверная часть Google Диска)
sudo pacman -S --noconfirm --needed gvfs-gphoto2  # Реализация виртуальной файловой системы для GIO (бэкэнд gphoto2; камера PTP, медиаплеер MTP)
sudo pacman -S --noconfirm --needed gvfs-nfs  # Реализация виртуальной файловой системы для GIO (серверная часть NFS)
sudo pacman -S --noconfirm --needed gvfs-smb  # Реализация виртуальной файловой системы для GIO (серверная часть SMB / CIFS; клиент Windows)
sudo pacman -S --noconfirm --needed haveged  #  Демон сбора энтропии с использованием таймингов процессора (https://github.com/jirka-h/haveged)(запустить haveged -n 0 | pv > /dev/null)
sudo pacman -S --noconfirm --needed hddtemp  # Показывает температуру вашего жесткого диска, читая информацию SMART
sudo pacman -S --noconfirm --needed hdparm  # Утилита оболочки для управления параметрами диска / драйвера Linux IDE (получить / установить параметры диска ATA / SATA под Linux)
sudo pacman -S --noconfirm --needed hidapi  # Простая библиотека для связи с устройствами USB и Bluetooth HID
sudo pacman -S --noconfirm --needed hwdetect # Скрипт (консольная утилита) просмотр модулей ядра для устройств, обнаружения оборудования с загрузочными модулями и поддержкой mkinitcpio.conf / rc.conf
sudo pacman -S --noconfirm --needed hwinfo  # Инструмент обнаружения оборудования от openSUSE
sudo pacman -S --noconfirm --needed hydra  # Очень быстрый взломщик входа в сеть, который поддерживает множество различных сервисов
sudo pacman -S --noconfirm --needed hyphen-en  # Правила расстановки переносов в английском
sudo pacman -S --noconfirm --needed id3lib  # Библиотека для чтения, записи и управления тегами ID3v1 и ID3v2
sudo pacman -S --noconfirm --needed iftop  # Отображение использования полосы пропускания на интерфейсе
sudo pacman -S --noconfirm --needed inxi  # Полнофункциональный системный информационный инструмент CLI
sudo pacman -S --noconfirm --needed inetutils  # Сборник общих сетевых программ   # присутствует
sudo pacman -S --noconfirm --needed isomd5sum  # Утилиты для работы с md5sum, имплантированными в ISO-образы
sudo pacman -S --noconfirm --needed jfsutils  # Утилиты файловой системы JFS
sudo pacman -S --noconfirm --needed kvantum  # Механизм тем на основе SVG для Qt6 (включая инструмент настройки и дополнительные темы) https://archlinux.org/packages/extra/x86_64/kvantum/
sudo pacman -S --noconfirm --needed lib32-curl  # Утилита и библиотека для поиска URL (32-разрядная версия)
sudo pacman -S --noconfirm --needed lib32-flex  # Инструмент для создания программ сканирования текста
sudo pacman -S --noconfirm --needed libfm-gtk2  # Библиотека GTK + 2 для управления файлами
sudo pacman -S --noconfirm --needed libudev0-shim  # Библиотека совместимости libudev.so.0 для систем с более новыми версиями udev
# sudo pacman -S --noconfirm --needed light-locker  # Простой шкафчик сессий для LightDM   # присутствует
sudo pacman -S --noconfirm --needed lksctp-tools  # Реализация протокола SCTP (http://lksctp.sourceforge.net/)
sudo pacman -S --noconfirm --needed logrotate  # Автоматическая ротация системных журналов
sudo pacman -S --noconfirm --needed lsb-release  # Программа запроса версии LSB   # присутствует
sudo pacman -S --noconfirm --needed lsof  # Перечисляет открытые файлы для запуска процессов Unix (https://github.com/lsof-org/lsof)(cat > /tmp/LOG &  ; lsof -p 18083)
sudo pacman -S --noconfirm --needed lvm2  #  Утилиты Logical Volume Manager 2 (https://sourceware.org/lvm2/)
sudo pacman -S --noconfirm --needed man-db  # Утилита для чтения страниц руководства
sudo pacman -S --noconfirm --needed man-pages  # Страницы руководства Linux
sudo pacman -S --noconfirm --needed mc  # Файловый менеджер, эмулирующий Norton Commander
sudo pacman -S --noconfirm --needed memtest86+  # Усовершенствованный инструмент диагностики памяти
sudo pacman -S --noconfirm --needed mlocate  # Слияние реализации locate / updatedb
sudo pacman -S --noconfirm --needed mtpfs  # Файловая система FUSE, поддерживающая чтение и запись с любого устройства MTP
sudo pacman -S --noconfirm --needed ncdu  # Анализатор использования диска с интерфейсом ncurses
sudo pacman -S --noconfirm --needed nfs-utils  # Программы поддержки для сетевых файловых систем
sudo pacman -S --noconfirm --needed nmon  # Инструмент мониторинга производительности AIX и Linux (http://nmon.sourceforge.net/pmwiki.php)
sudo pacman -S --noconfirm --needed nss-mdns  # Плагин glibc, обеспечивающий разрешение имени хоста через mDNS
### sudo pacman -S --noconfirm --needed openbsd-netcat  #  Швейцарский армейский нож TCP / IP. Вариант OpenBSD (Важно конфликтует с gnu-netcat - GNU переписывает netcat, приложение для создания сетевых трубопроводов). Простая утилита Unix, которая считывает и записывает данные через сетевые соединения с использованием протоколов TCP или UDP. Этот пакет содержит переписанную версию netcat для OpenBSD, включая поддержку IPv6, прокси-серверов и сокетов Unix.
sudo pacman -S --noconfirm --needed pacman-contrib  # Предоставленные скрипты и инструменты для систем pacman  # присутствует
sudo pacman -S --noconfirm --needed patchutils  # Небольшая коллекция программ, работающих с файлами патчей
sudo pacman -S --noconfirm --needed pciutils  # Библиотека и инструменты доступа к пространству конфигурации шины PCI
sudo pacman -S --noconfirm --needed php  # Язык сценариев общего назначения, особенно подходящий для веб-разработки
sudo pacman -S --noconfirm --needed picom  # Легкий композитор для X11 https://archlinux.org/packages/extra/x86_64/picom/
sudo pacman -S --noconfirm --needed polkit  # Набор инструментов для разработки приложений для управления общесистемными привилегиями
sudo pacman -S --noconfirm --needed poppler-data  # Кодирование данных для библиотеки рендеринга PDF Poppler
sudo pacman -S --noconfirm --needed powertop  # Инструмент для диагностики проблем с энергопотреблением и управлением питанием
sudo pacman -S --noconfirm --needed pv  # Инструмент на основе терминала для мониторинга прохождения данных по конвейеру
sudo pacman -S --noconfirm --needed pwgen  # Генератор паролей для создания легко запоминающихся паролей
sudo pacman -S --noconfirm --needed python  # Новое поколение языка сценариев высокого уровня Python  # присутствует
sudo pacman -S --noconfirm --needed python-isomd5sum  # Привязки Python3 для isomd5sum
sudo pacman -S --noconfirm --needed python-pip  # Рекомендуемый PyPA инструмент для установки пакетов Python
sudo pacman -S --noconfirm --needed qt5-translations  # кросс-платформенное приложение и UI-фреймворк (переводы)
sudo pacman -S --noconfirm --needed reiserfsprogs  # Утилиты Reiserfs (Инструменты для поддержки файловой системы ReiserFS)
sudo pacman -S --noconfirm --needed re2   # Быстрый, безопасный, ориентированный на многопоточность механизм регулярных выражений
sudo pacman -S --noconfirm --needed ruby  # Объектно-ориентированный язык для быстрого и простого программирования
sudo pacman -S --noconfirm --needed s-nail  # Среда для отправки и получения почты
sudo pacman -S --noconfirm --needed sane  # Доступ к сканеру теперь простой
sudo pacman -S --noconfirm --needed sg3_utils  # Универсальные утилиты SCSI
sudo pacman -S --noconfirm --needed sdparm  # Утилита, аналогичная hdparm, но для устройств SCSI (http://sg.danny.cz/sg/sdparm.html)
sudo pacman -S --noconfirm --needed sof-firmware  # Звук открыть прошивку
sudo pacman -S --noconfirm --needed solid  # Аппаратная интеграция и обнаружение
sudo pacman -S --noconfirm --needed sox  # Швейцарский армейский нож инструментов обработки звука
sudo pacman -S --noconfirm --needed smartmontools  # Управление и мониторинг жестких дисков ATA и SCSI с поддержкой SMAR
sudo pacman -S --noconfirm --needed speedtest-cli  # Интерфейс командной строки для тестирования пропускной способности интернета с помощью speedtest.net
sudo pacman -S --noconfirm --needed squashfs-tools  # Инструменты для squashfs, файловой системы Linux с высокой степенью сжатия, доступной только для чтения
sudo pacman -S --noconfirm --needed syslinux  # Коллекция загрузчиков, которые загружаются с файловых систем FAT, ext2 / 3/4 и btrfs, с компакт-дисков и через PXE
sudo pacman -S --noconfirm --needed systemd-ui  # Графический интерфейс для systemd
sudo pacman -S --noconfirm --needed translate-shell  # Интерфейс командной строки и интерактивная оболочка для Google Translate
sudo pacman -S --noconfirm --needed udiskie  # Автоматическое монтирование съемных дисков с использованием udisks
sudo pacman -S --noconfirm --needed udisks2  # Служба управления дисками, версия 2 (https://www.freedesktop.org/wiki/Software/udisks/)
sudo pacman -S --noconfirm --needed unixodbc  # ODBC - это открытая спецификация для предоставления разработчикам приложений предсказуемого API для доступа к источникам данных
sudo pacman -S --noconfirm --needed usbutils  # Набор USB-инструментов для запроса подключенных USB-устройств
sudo pacman -S --noconfirm --needed usb_modeswitch  # Активация переключаемых USB-устройств в Linux
sudo pacman -S --noconfirm --needed wimlib  # Библиотека и программа для извлечения, создания и изменения файлов WIM
sudo pacman -S --noconfirm --needed wipe  # Утилита для безопасной очистки файлов (http://wipe.sourceforge.net/)
sudo pacman -S --noconfirm --needed xdg-utils  # Инструменты командной строки, которые помогают приложениям решать различные задачи интеграции с настольными компьютерами. (https://www.freedesktop.org/wiki/Software/xdg-utils/)
sudo pacman -S --noconfirm --needed xfsprogs  # Утилиты файловой системы XFS
sudo pacman -S --noconfirm --needed xsel  # XSel - это программа командной строки для получения и установки содержимого выделения X
sudo pacman -S --noconfirm --needed xterm  # Эмулятор терминала X
# sudo pacman -S --noconfirm --needed xorg-xclock --noconfirm  # X часы
sudo pacman -S --noconfirm --needed xorg-twm  # Вкладка Window Manager для системы X Window
sudo pacman -S --noconfirm --needed xorg-xkill  # Убить клиента его X-ресурсом
sudo pacman -S --noconfirm --needed yelp  # Получите помощь с GNOME
###sudo pacman -S youtube-dl --noconfirm  # Программа командной строки для загрузки видео с YouTube.com и еще нескольких сайтов
sudo pacman -S --noconfirm --needed yt-dlp  # Форк youtube-dl с дополнительными функциями и исправлениями https://archlinux.org/packages/extra/any/yt-dlp/
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
###########
# -----------Systemd --------------------- #
# sudo pacman -S --noconfirm --needed systemd  # Системный и сервисный менеджер
# sudo pacman -S --noconfirm --needed systemd-libs --noconfirm  # Клиентские библиотеки systemd
# sudo pacman -S --noconfirm --needed systemd-resolvconf --noconfirm  # Замена systemd resolvconf (для использования с systemd-resolved)
# sudo pacman -S --noconfirm --needed systemd-sysvcompat --noconfirm  # sysvinit compat для systemd
echo ""
echo " Установка утилит (пакетов) завершена " 
fi
#####
clear
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
sudo pacman -S --noconfirm --needed htop iotop  # интерактивный просмотрщик запущенных процессов; просмотр процессов ввода-вывода по использованию жесткого диска
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
    1 - ScreenFetch,     2 - Neofetch,     3 - ScreenFetch, Neofetch, 

    0 - Пропустить установку: " i_information  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_information" =~ [^1230] ]]
do
    :
done
if [[ $i_information == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) для вывода информации о системе пропущена "
elif [[ $i_information == 1 ]]; then
echo ""
echo " Установка утилиты (пакета) ScreenFetch "
sudo pacman -S --noconfirm --needed screenfetch  # CLI Bash-скрипт для отображения информации о системе/теме на снимках экрана ; https://github.com/KittyKatt/screenFetch ; https://archlinux.org/packages/extra/any/screenfetch/
elif [[ $i_information == 2 ]]; then
echo ""
echo " Установка утилиты (пакета) Neofetch "
sudo pacman -S --noconfirm --needed neofetch  # CLI-инструмент системной информации, написанный на BASH и поддерживающий отображение изображений ; https://github.com/dylanaraps/neofetch ; https://archlinux.org/packages/extra/any/neofetch/
elif [[ $i_information == 3 ]]; then
echo ""
echo " Установка утилит (пакетов) ScreenFetch, Neofetch "
sudo pacman -S --noconfirm --needed screenfetch neofetch
fi
##############
clear
echo -e "${MAGENTA}
  <<< Установка Мультимедиа аудиоплееров, видео-проигрывателей, утилит и кодеков в Archlinux >>> ${NC}"
# Installing Multimedia audio players, video players, utilities, and codecs in Archlinux
echo ""
echo -e "${GREEN}==> ${NC}Установка мультимедиа кодеков - GStreamer (multimedia codecs), и утилит"
#echo -e "${BLUE}:: ${NC}Установка мультимедиа кодеков (multimedia codecs), и утилит"
#echo 'Установка Мультимедиа кодеков (multimedia codecs), и утилит'
# Installing Multimedia codecs and utilities
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (a52dec, faac, faad2, flac, jasper, lame, libdca, libdv, libmad, libmpeg2, libtheora, libvorbis, libxv, wavpack, x264, xvidcore, gst-plugins-base, gst-plugins-base-libs, gst-plugins-good, gst-plugins-bad, gst-plugins-ugly, libdvdcss, libdvdread, libdvdnav, dvd+rw-tools, dvdauthor, dvgrab, cdrdao, gst-libav, gst-libav, gpac)."
echo -e "${MAGENTA}=> ${NC}Список GStreamer утилит (пакетов) для установки: - (gstreamer, gstreamer-docs, gstreamer-vaapi, gst-libav, gst-plugins-bad, gst-plugins-base, gst-plugins-base-libs, gst-plugins-good, gst-plugins-ugly, gstreamermm, gstreamermm-docs, libde265, xine-lib)."
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
### Устанавливаем утилиты и кодеки
# sudo pacman -S --noconfirm --needed a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore libdvdcss libdvdread libdvdnav dvd+rw-tools dvdauthor dvgrab cdrdao gpac
  sudo pacman -S --noconfirm --needed a52dec  # Бесплатная библиотека для декодирования потоков ATSC A / 52
  sudo pacman -S --noconfirm --needed cdrdao  # Записывает аудио / данные CD-R в режиме disk-at-once (DAO)
  sudo pacman -S --noconfirm --needed dvdauthor  # Инструменты для создания DVD
  sudo pacman -S --noconfirm --needed dvd+rw-tools  # Инструменты записи dvd
  sudo pacman -S --noconfirm --needed dvgrab  # Сохраняет аудио и видео данные из цифрового источника IEEE (FireWire)
  sudo pacman -S --noconfirm --needed faac  # Бесплатная программа Advanced Audio Coder
  sudo pacman -S --noconfirm --needed faad2  # Аудиодекодер ISO AAC
  sudo pacman -S --noconfirm --needed flac  # Бесплатный аудиокодек без потерь
  sudo pacman -S --noconfirm --needed gpac  # Мультимедийный фреймворк на основе стандарта MPEG-4 Systems (https://github.com/gpac/gpac)
  sudo pacman -S --noconfirm --needed jasper  # Программная реализация кодека, указанного в появляющемся стандарте JPEG-2000 Part-1
  sudo pacman -S --noconfirm --needed lame  # Высококачественный кодировщик MPEG Audio Layer III (MP3)
  sudo pacman -S --noconfirm --needed libdca  # Бесплатная библиотека для декодирования потоков DTS Coherent Acoustics

  sudo pacman -S --noconfirm --needed libdv  # Кодек Quasar DV (libdv) - программный кодек для DV-видео
  sudo pacman -S --noconfirm --needed libdvdcss  # Переносимая библиотека абстракций для дешифрования DVD
  sudo pacman -S --noconfirm --needed libdvdnav  # Библиотека для плагина xine-dvdnav
  sudo pacman -S --noconfirm --needed libdvdread  # Обеспечивает простую основу для чтения DVD-видеодисков
  sudo pacman -S --noconfirm --needed libmad  # Высококачественный аудиодекодер MPEG
  sudo pacman -S --noconfirm --needed libmpeg2  # Библиотека для декодирования видеопотоков MPEG-1 и MPEG-2
  sudo pacman -S --noconfirm --needed libtheora  # Открытый видеокодек, разработанный Xiph.org
  sudo pacman -S --noconfirm --needed libvorbis  # Эталонная реализация аудиоформата Ogg Vorbis
  sudo pacman -S --noconfirm --needed libxv  # Библиотека расширений видео X11
  sudo pacman -S --noconfirm --needed wavpack  # Формат сжатия звука с режимами сжатия без потерь, с потерями и гибридным сжатием
  sudo pacman -S --noconfirm --needed x264  # Кодировщик видео H264 / AVC с открытым исходным кодом
  sudo pacman -S --noconfirm --needed xvidcore  # XviD - видеокодек MPEG-4 с открытым исходным кодом
  echo ""
  echo " Устанавливаем GStreamer - Фреймворк (кодеки) "
# sudo pacman -S gstreamer gstreamer-docs gstreamer-vaapi gst-libav gst-plugins-bad gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-ugly gstreamermm gstreamermm-docs xine-lib --noconfirm  # https://gstreamer.freedesktop.org/
  sudo pacman -S --noconfirm --needed gstreamer  # Фреймворк мультимедийного графа - ядро (https://gstreamer.freedesktop.org/)
  sudo pacman -S --noconfirm --needed gstreamer-docs  # Фреймворк мультимедийных графов - документация (https://gstreamer.freedesktop.org/)
  sudo pacman -S --noconfirm --needed gstreamer-vaapi  # Фреймворк мультимедийного графа - плагин vaapi
  sudo pacman -S --noconfirm --needed gst-libav  # Фреймворк мультимедийного графа - плагин для libav
  sudo pacman -S --noconfirm --needed gst-plugins-bad  # Фреймворк мультимедийного графа - плохие плагины
  sudo pacman -S --noconfirm --needed gst-plugins-base  # Фреймворк мультимедийного графа - базовые плагины
  sudo pacman -S --noconfirm --needed gst-plugins-base-libs  # Фреймворк мультимедийного графа - основа
  sudo pacman -S --noconfirm --needed gst-plugins-good  # Фреймворк мультимедийного графа - хорошие плагины
  sudo pacman -S --noconfirm --needed gst-plugins-ugly  # Фреймворк мультимедийного графа - уродливые плагины
  sudo pacman -S --noconfirm --needed gstreamermm  # Интерфейс C ++ для GStreamer (https://github.com/GNOME/gstreamermm; https://gstreamer.freedesktop.org/bindings/cplusplus.html)
  sudo pacman -S --noconfirm --needed gstreamermm-docs  # Интерфейс C ++ для GStreamer (документация) (https://gstreamer.freedesktop.org/bindings/cplusplus.html)
  sudo pacman -S --noconfirm --needed libde265  # Открытая реализация видеокодека h.265 https://github.com/strukturag/libde265
  echo ""
  echo " Устанавливаем Xine - это свободный мультимедиа движок "
  sudo pacman -S --noconfirm --needed xine-lib  # Движок воспроизведения мультимедиа (https://www.xine-project.org)
### Xine - универсальный медиа-плеер написанный как разделяемая библиотека (xine-lib), которая поддерживает многочисленные фронтенды (xine-ui). Xine также может использовать библиотеки из других проектов, включая двоичные кодеки Windows.
  echo ""
  echo " Установка мультимедиа кодеков и утилит (пакетов) выполнена "
fi
#############
clear
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
#sudo pacman -S --noconfirm --needed audacious audacious-plugins  # Легкий, продвинутый аудиоплеер, ориентированный на качество звука; Плагины для Audacious ; https://audacious-media-player.org/ ; https://archlinux.org/packages/extra/x86_64/audacious/ ; https://archlinux.org/packages/extra/x86_64/audacious-plugins/ ; 
sudo pacman -S --noconfirm --needed audacious  # Легкий, продвинутый аудиоплеер, ориентированный на качество звука ; https://audacious-media-player.org/ ; https://archlinux.org/packages/extra/x86_64/audacious/
sudo pacman -S --noconfirm --needed audacious-plugins  # Плагины для Audacious ; https://audacious-media-player.org/ ; https://archlinux.org/packages/extra/x86_64/audacious/ ; https://archlinux.org/packages/extra/x86_64/audacious-plugins/ 
sudo pacman -S --noconfirm --needed playerctl  # Контроллер и библиотека медиаплеера mpris для Spotify, VLC, Audacious, BMP, XMMS2 и других. https://github.com/altdesktop/playerctl ; https://archlinux.org/packages/extra/x86_64/playerctl/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
################# Справка ##############
# Playerctl — это утилита командной строки и библиотека для управления медиаплеерами, реализующими спецификацию интерфейса MPRIS D-Bus. Playerctl упрощает привязку действий плеера, таких как воспроизведение и пауза, к клавишам мультимедиа. Вы также можете получить метаданные о воспроизводимой дорожке, такие как исполнитель и название, для интеграции в генераторы statusline или другие инструменты командной строки.
# Playerctl также поставляется с демоном, который позволяет ему работать с текущим активным медиаплеером, называемым playerctld.
#########################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить медиаплеер Smplayer?"
echo " SMPlayer — мультимедиа плеер для Linux с простым интерфейсом. Поддерживаются практически все видео и аудио форматы файлов. "
echo " SMPlayer поддерживает множество функций. Например, можно повернуть видео на 90 градусов прямо во время просмотра, можно изменить скорость просмотра видео, уменьшить или увеличить размер, изменить соотношение сторон видео, применить различные эффекты, настроить звук, субтитры, сделать скриншот из видео и многое другое. Интерфейс у SMPlayer простой и удобный. Главное окно содержит две панели управления — сверху и снизу и главное меню в верхней части окна. Отдельно можно включить показ списка воспроизведения. Он может размещаться внизу внутри главного окна, а также как отдельное окно на экране. Поддерживаются скины (темы оформления) и темы иконок. "
echo " Одной из интересных функций программы является то, что для каждого файла она запоминает позицию, на которой вы закончили его просмотр. То есть, если, например, вы закрыли видео-файл, а на следующий день снова его открыли, то SMPlayer начнет проигрывание с той позиции, на которой вы закрыли файл в прошлый раз. При установке SMPlayer сразу устанавливаются все необходимые кодеки. "
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
# sudo pacman -S --noconfirm --needed smplayer smplayer-skins smplayer-themes  # Медиаплеер со встроенными кодеками, который может воспроизводить практически все видео и аудио форматы; Скины для SMPlayer; Темы для SMPlayer; *** Приложение, позволяющее просматривать, искать и воспроизводить видео на YouTube - отсутствует.
sudo pacman -S --noconfirm --needed smplayer  #  Медиаплеер со встроенными кодеками, который может воспроизводить практически все видео и аудио форматы ; https://www.smplayer.info/ ; https://archlinux.org/packages/extra/x86_64/smplayer/
sudo pacman -S --noconfirm --needed smplayer-skins  # Скины для SMPlayer ; https://smplayer.info/ ; https://archlinux.org/packages/extra/any/smplayer-skins/
sudo pacman -S --noconfirm --needed smplayer-themes  # Темы для SMPlayer ; https://www.smplayer.info/ ; https://archlinux.org/packages/extra/any/smplayer-themes/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
###
clear
echo ""
echo -e "${BLUE}:: ${NC}Установить многоплатформенный проигрыватель VLC ?"
echo " VLC media player — VLC — бесплатный и свободный кросс-платформенный медиаплеер и медиаплатформа с открытым исходным кодом. VLC воспроизводит множество мультимедийных файлов, а также DVD, Audio CD, VCD и сетевые трансляции. "
echo " Возможности: Поддержка аппаратного декодирования. Поддержка практически всех видео и аудио форматов. Применение видео и аудио фильтров и эффектов. Поддержка субтитров. Изменение скорости воспроизведения. Выбор аудиорожки. Синхронизация субтитров. Синхронизация дорожек. Выбор режима стерео. Устранение чересстрочности (деинтерлейсинг). Создание снимков (скриншотов) видео. Поддержка расширений (модулей). Настройка интерфейса (изменение элементов панели инструментов). Проигрывание поврежденных файлов. И другие. "
echo " Количество Поддерживаемых форматов, а также видеокодеков, аудио-кодеков и Специальные форматов очень велико. Изначально программа называлась VideоLAN, но была переименована. Полное название: VLC media player. "

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
sudo pacman -S --noconfirm --needed vlc  # Многоплатформенный проигрыватель MPEG, VCD / DVD и DivX
# sudo pacman -S --noconfirm --needed playerctl  # Контроллер и библиотека медиаплеера mpris для Spotify, VLC, Audacious, BMP, XMMS2 и других. https://github.com/altdesktop/playerctl ; https://archlinux.org/packages/extra/x86_64/playerctl/ ; https://www.videolan.org/
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
sudo pacman -S --noconfirm --needed dconf-editor  # редактор dconf ; https://wiki.gnome.org/Apps/DconfEditor ; https://archlinux.org/packages/extra/x86_64/dconf-editor/
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
sudo pacman -S --noconfirm --needed gedit gedit-plugins  # Текстовый редактор GNOME
#echo ""
echo " Устраняем проблему с win кодировкой в текстовом редакторе (gedit) "
gsettings set org.gnome.gedit.preferences.encodings candidate-encodings "['UTF-8', 'WINDOWS-1251', 'KOI8-R', 'CURRENT', 'ISO-8859-15', 'UTF-16']"
echo ""
echo " Установка текстового редактора (gedit) выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установка Текстового редактора (leafpad)"
#echo -e "${BLUE}:: ${NC}Установка Текстового редактора (leafpad)"
#echo 'Установка Текстового редактора (leafpad)'
# Installing a text editor (leafpad)
echo -e "${MAGENTA}=> ${BOLD}Leafpad - это простой текстовый редактор GTK+ , подчеркивающий простоту. ${NC}"
echo -e "${CYAN}:: ${NC}Описание: Интерфейс Leafpad схож с интерфейсом стандартного текстового редактора Windows, поэтому при его использовании не возникнет особых сложностей даже у новичка. Поскольку при разработке основное внимание уделяется минимизации веса, в редакторе реализованы только самые важные функции. Leafpad прост в использовании, легко компилируется, требует небольшого количества библиотек и быстро запускается. На данный момент Leafpad имеет следующие возможности: Вариант кодировки (некоторые зарегистрированные OpenI18N); Автоматическое определение кодировки (UTF-8 и некоторые кодировки); Неограниченное количество операций отмены/повтора; Автоматический/многострочный отступ; Отображать номера строк; Перетащите; Печать..."
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (leafpad)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_leafpad # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_leafpad" =~ [^10] ]]
do
    :
done
if [[ $i_leafpad == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_leafpad == 1 ]]; then
  echo ""
  echo " Установка текстового редактора (gedit) "
sudo pacman -S --noconfirm --needed leafpad  # Клон блокнота для GTK+ 2.0. https://archlinux.org/packages/extra/x86_64/leafpad/
echo ""
echo " Установка текстового редактора (leafpad) выполнена "
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
sudo pacman -S --noconfirm --needed geany geany-plugins  # Быстрая и легкая IDE
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
sudo pacman -S --noconfirm --needed thunderbird  # Программа для чтения почты и новостей от mozilla.org ;  ; https://www.thunderbird.net/  ; https://archlinux.org/packages/extra/x86_64/thunderbird/
sudo pacman -S --noconfirm --needed thunderbird-i18n-ru  # Русский языковой пакет для Thunderbird ; https://www.thunderbird.net/ ; https://archlinux.org/packages/extra/x86_64/thunderbird-i18n-ru/
#sudo pacman -S --noconfirm --needed thunderbird-i18n-en-us  # Английский (США) языковой пакет для Thunderbird ; https://www.thunderbird.net/ 
sudo pacman -S --noconfirm --needed thunderbird-dark-reader  # Инвертирует яркость веб-страниц и снижает нагрузку на глаза при просмотре веб-страниц ; https://darkreader.org/ ; https://archlinux.org/packages/extra/any/thunderbird-dark-reader/
sudo pacman -S --noconfirm --needed systray-x-common  # Расширение системного трея для Thunderbird 68+ (для X) — общая версия ; https://github.com/Ximi1970/systray-x ; https://archlinux.org/packages/extra/x86_64/systray-x-common/ - Это дополнение и сопутствующее приложение НЕ будут работать с flatpaks или snaps Thunderbird. 
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
# sudo pacman -S --noconfirm --needed pidgin pidgin-hotkeys pidgin-otr # Клиент обмена мгновенными сообщениями ; 
sudo pacman -S --noconfirm --needed pidgin  # Клиент обмена мгновенными сообщениями ; https://www.pidgin.im/ ; https://pidgin.im/ ; https://archlinux.org/packages/extra/x86_64/pidgin/
sudo pacman -S --noconfirm --needed pidgin-hotkeys  # Плагин Pidgin, позволяющий определять глобальные горячие клавиши ; http://pidgin-hotkeys.sourceforge.net ; https://archlinux.org/packages/extra/x86_64/pidgin-hotkeys/
######### Плагины ############
sudo pacman -S --noconfirm --needed pidgin-otr  # Плагин для обмена сообщениями Off-the-Record для Pidgin ; https://www.cypherpunks.ca/otr/ ; https://archlinux.org/packages/extra/x86_64/pidgin-otr/
sudo pacman -S --noconfirm --needed libpurple  # Библиотека IM, извлеченная из Pidgin ; https://pidgin.im/ ; https://archlinux.org/packages/extra/x86_64/libpurple/
sudo pacman -S --noconfirm --needed libpurple-lurch  # Плагин для libpurple (Pidgin, Adium и т.д.), реализующий OMEMO (используя axolotl) ; https://github.com/gkdr/lurch ; https://archlinux.org/packages/extra/x86_64/libpurple-lurch/
sudo pacman -S --noconfirm --needed pidgin-talkfilters  # Реализует GNU talkfilters в чатах pidgin ; https://keep.imfreedom.org/pidgin/purple-plugin-pack/ ; https://archlinux.org/packages/extra/x86_64/pidgin-talkfilters/
sudo pacman -S --noconfirm --needed pidgin-kwallet  # Плагин KWallet для Pidgin ; https://www.linux-apps.com/content/show.php/Pidgin+KWallet+Plugin?content=127136 ; https://archlinux.org/packages/extra/x86_64/pidgin-kwallet/
sudo pacman -S --noconfirm --needed pidgin-xmpp-receipts  # Этот плагин pidgin реализует уведомления о доставке сообщений XMPP (XEP-0184) ; https://devel.kondorgulasch.de/pidgin-xmpp-receipts/ ; https://archlinux.org/packages/extra/x86_64/pidgin-xmpp-receipts/
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
echo -e "${MAGENTA}:: ${BOLD}Веб-браузер Google Ghrome, и Vivaldi будут представлены для установки в следующем скрипте, или установите их сами. ${NC}"
echo -e "${CYAN}:: ${NC}Другие предложенные веб-браузеры Вы можете установить, либо пропустите установку."
echo ""
echo -e "${GREEN}==> ${NC}Flash плееры - (flashplugin) или (pepper-flash)"
echo -e "${CYAN}=> ${BOLD}В установку НЕ включены больше НЕ поддерживаемые плагины: flashplugin - Adobe Flash Player (NPAPI-версия), и pepper-flash - Adobe Flash Player (PPAPI-версия). ${NC}"
echo -e "${YELLOW}==> ${BOLD}Важно! Предупреждение (обратить внимание)! Поддержка Adobe Flash Player закончилась 31 декабря 2020 года. В результате плагины NPAPI и PPAPI больше не поддерживаются ни в одном браузере. Кроме того, проект больше не будет получать исправления ошибок или обновления безопасности. ${NC}"
echo -e "${MAGENTA}:: ${NC} Более старую автономную версию можно установить с помощью автономного пакета AUR от flashplayer . Этот пакет предшествует жестко запрограммированным часам истечения срока службы, вставленным в Flash Player, и поэтому продолжает работать."
echo " 1 - Firefox - Популярный, графический, автономный веб-браузер, с открытым исходным кодом, разрабатываемый Mozilla (mozilla.org) "
# echo " Единственный поддерживаемый Firefox плагин - flashplugin - Adobe Flash Player (NPAPI-версия). "
echo " 2 - Chromium - Графический веб-браузер, с открытым исходным кодом, основанный на движке Blink, созданный для скорости, простоты и безопасности, разрабатываемый Google совместно с сообществом (и другими корпорациями) "
# echo " Поддерживаемый плагин - pepper-flash - Adobe Flash Player (PPAPI-версия): эти плагины работают в Chromium (и Chrome), Opera и Vivaldi. "
echo " 3 - Opera - Графический веб-браузер, с открытым исходным кодом, основанный на движке Blink, быстрый, безопасный и простой в использовании браузер, теперь со встроенным блокировщиком рекламы, функцией экономии заряда батареи и бесплатным VPN "
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
sudo pacman -S --noconfirm --needed firefox  # Автономный веб-браузер от mozilla.org ; https://www.mozilla.org/firefox/ ; https://archlinux.org/packages/extra/x86_64/firefox/
sudo pacman -S --noconfirm --needed firefox-i18n-ru  # Русский языковой пакет для Firefox ; https://www.mozilla.org/firefox/ ; https://archlinux.org/packages/extra/any/firefox-i18n-ru/
sudo pacman -S --noconfirm --needed firefox-spell-ru  # Русский словарь проверки орфографии для Firefox ; https://addons.mozilla.org/firefox/dictionaries/ ; https://archlinux.org/packages/extra-testing/any/firefox-spell-ru/
sudo pacman -S --noconfirm --needed firefox-ublock-origin  # Надстройка эффективного блокировщика для различных браузеров. Быстрый, мощный и компактный ; https://github.com/gorhill/uBlock ; https://archlinux.org/packages/extra/any/firefox-ublock-origin/
#sudo pacman -S --noconfirm --needed firefox-adblock-plus  # Расширение для Firefox, которое блокирует рекламу и баннеры ; https://adblockplus.org/ ; https://archlinux.org/packages/extra/any/firefox-adblock-plus/
sudo pacman -S --noconfirm --needed firefox-dark-reader # Инвертирует яркость веб-страниц и снижает нагрузку на глаза при просмотре веб-страниц ; https://darkreader.org/ ; https://archlinux.org/packages/extra/any/firefox-dark-reader/
#sudo pacman -S firefox-i18n-en-us --noconfirm  # Английский (США) языковой пакет для Firefox
### yay -S flashplugin # Adobe Flash Player NPAPI
#sudo pacman -S firefox-developer-edition firefox-developer-edition-i18n-ru firefox-spell-ru --noconfirm  # Версия для разработчиков
clear
echo ""
echo " Установка веб-браузера Firefox выполнена "
elif [[ $in_browser == 2 ]]; then
echo ""
echo " Установка веб-браузера Chromium (без - pepper-flash) "
sudo pacman -S --noconfirm --needed chromium  # Веб-браузер, созданный для скорости, простоты и безопасности
### yay -S pepper-flash # Adobe Flash Player PPAPI
clear
echo ""
echo " Установка веб-браузера Chromium выполнена "
elif [[ $in_browser == 3 ]]; then
echo ""
echo " Установка веб-браузера Opera (без - pepper-flash) "
#sudo pacman -S opera opera-ffmpeg-codecs --noconfirm
sudo pacman -S --noconfirm --needed opera  # Быстрый и безопасный веб-браузер
sudo pacman -S --noconfirm --needed opera-ffmpeg-codecs  # дополнительная поддержка проприетарных кодеков для оперы
### yay -S pepper-flash # Adobe Flash Player PPAPI
clear
echo ""
echo " Установка веб-браузера Opera выполнена "
elif [[ $in_browser == 4 ]]; then
echo ""
echo " Установка веб-браузеров Chromium Opera Firefox "
sudo pacman -S --noconfirm --needed chromium opera opera-ffmpeg-codecs firefox firefox-i18n-ru firefox-spell-ru
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
echo " 2 - qBittorrent - Усовершенствованный клиент BitTorrent, написанный на C++, основанный на инструментарии Qt и libtorrent-rasterbar "
echo " 3 - Deluge - BitTorrent-клиент написанное на Python 3, с несколькими пользовательскими интерфейсами в модели клиент / сервер "
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
sudo pacman -S --noconfirm --needed transmission-gtk transmission-cli  # Быстрый, простой и бесплатный клиент BitTorrent (GTK+ GUI), Быстрый, простой и бесплатный клиент BitTorrent (инструменты CLI, демон и веб-клиент); http://www.transmissionbt.com/ ; https://archlinux.org/packages/extra/x86_64/transmission-gtk/ ; https://archlinux.org/packages/extra/x86_64/transmission-cli/
#sudo pacman -S --noconfirm --needed transmission-qt transmission-cli  # графический интерфейс Qt 5, и демон, с CLI
#sudo pacman -S --noconfirm --needed transmission-remote-gtk transmission-cli  # графический интерфейс GTK 3 для демона, и демон, с CLI
clear
echo ""
echo " Установка BitTorrent-клиента Transmission выполнена "
elif [[ $in_torrent == 2 ]]; then
  echo ""
  echo " Установка BitTorrent-клиента qBittorrent (Qt) "
sudo pacman -S --noconfirm --needed qbittorrent  # Расширенный клиент BitTorrent, написанный на C++, на основе инструментария Qt и libtorrent-rasterbar ; https://www.qbittorrent.org/ ; https://archlinux.org/packages/extra/x86_64/qbittorrent/
#sudo pacman -S --noconfirm --needed qbittorrent-nox  # Расширенный клиент BitTorrent, написанный на C++, на основе инструментария Qt и libtorrent-rasterbar, без графического интерфейса ; https://www.qbittorrent.org/ ; https://archlinux.org/packages/extra/x86_64/qbittorrent-nox/
clear
echo ""
echo " Установка BitTorrent-клиента qBittorrent выполнена "
elif [[ $in_torrent == 3 ]]; then
  echo ""
  echo " Установка BitTorrent-клиента Deluge (GTK) "
sudo pacman -S --noconfirm --needed deluge  # Клиент BitTorrent с несколькими пользовательскими интерфейсами в модели клиент/сервер
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
echo " 1 - LibreOffice-still - это мощный, официально поддерживаемый офисный пакет, имеется стабильная ветвь обновлений "
echo " 2 - LibreOffice-fresh - это офисный пакет, новые функции, улучшения программы появляются сначала здесь, часто обновляется "
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
sudo pacman -S --noconfirm --needed libreoffice-still  # Филиал обслуживания LibreOffice
sudo pacman -S --noconfirm --needed libreoffice-still-ru  # Пакет русского языка для LibreOffice still
sudo pacman -S --noconfirm --needed libreoffice-extension-writer2latex  # набор расширений LibreOffice для преобразования и работы с LaTeX в LibreOffice
sudo pacman -S --noconfirm --needed hunspell  # Библиотека и программа для проверки орфографии и морфологического анализатора
sudo pacman -S --noconfirm --needed hyphen  # Библиотека для качественной расстановки переносов и выравнивания
sudo pacman -S --noconfirm --needed mythes  # libmythes  Простой тезаурус (Словарь понятий или терминов). В нем можно найти слова синонимы или антонимы к интересующему понятию (слову, термину).
sudo pacman -S --noconfirm --needed unoconv  # Конвертер документов на основе Libreoffice
#clear
echo ""
echo " Установка LibreOffice-still выполнена "
elif [[ $t_office == 2 ]]; then
echo ""
echo " Установка LibreOffice-fresh "
# sudo pacman -S --noconfirm --needed libreoffice-fresh libreoffice-fresh-ru
sudo pacman -S --noconfirm --needed libreoffice-fresh  # Ветвь LibreOffice, содержащая новые функции и улучшения программы
sudo pacman -S --noconfirm --needed libreoffice-fresh-ru  # Пакет русского языка для LibreOffice Fresh
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
  <<< Установка утилит для редактирования документов, PDF, DjVus, NFO, DIZ и XPS... , Читалки электронных книг, Словари, Таблицы в Archlinux >>> ${NC}"
# Installation of utilities for editing documents, PDF, Djvu, NFO, DIZ and XPS... , e-book readers, Dictionaries, Tables in Archlinux
echo ""
echo -e "${BLUE}:: ${NC}Установить Evince - (для просмотра документов PDF, postscript, djvu, tiff, dvi и т.д..)?"
echo -e "${MAGENTA}:: ${BOLD}Evince (также известный как Document Viewer) - это PDF-просмотрщик по умолчанию для среды рабочего стола GNOME. Если вы используете GNOME, то это приложение должно быть установлено в вашей системе. Оно часто устанавливается по умолчанию и на других рабочих столах. ${NC}"
echo " Evince — это просмотрщик документов для нескольких форматов документов. Цель evince — заменить несколько просмотрщиков документов, которые существуют на рабочем столе GNOME, одним простым приложением. Сайты: http://projects.gnome.org/evince/ ; Домашняя страница: https://wiki.gnome.org/Apps/Evince ; (https://archlinux.org/packages/extra/x86_64/evince/ ; https://apps.gnome.org/ru/Evince/). "  
echo -e "${MAGENTA}:: ${BOLD}Evince — просмотрщик документов в форматах pdf, postscript, djvu, tiff, dvi и т.д.. ${NC}"
echo " Основные возможности Evince: Поиск по содержимому документа с подсветкой результатов ; Вывод содержания документа ; Печать документа ; Открытие зашифрованных документов ; Поддержка работы с большими документами (несколько сотен страниц) ; Просмотр страниц в непрерывном режиме ; Постраничный просмотр ; Вывод миниатюр страниц ; Поворот страниц ; Ночной режим (белый текст на темном фоне) ; Просмотр свойств документа (информация о файле и используемые шрифты) ; Добавление заметок (annotations) в документ. Выделение сохраняется внутри файла (копии файла) ; Подсветка (выделение) текста в документе. Выделение сохраняется внутри файла (копии файла) и т.д... " 
echo " Поддерживаемые форматы файлов: PDF ; PS (PostScript) ; Multi-Page TIFF ; DVI (с SyncTeX) ; DjVu ; Comic Book Archive (CBR, CBT, CBZ, CB7) ; Adobe Illustrator Artwork ; OpenDocument Presentation (если сборка осуществлялась с опцией --enable-impress). "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_evince  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_evince" =~ [^10] ]]
do
    :
done
if [[ $in_evince == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_evince == 1 ]]; then
  echo ""
  echo " Установка Evince (Document Viewer) "
sudo pacman -S --noconfirm --needed evince  #  Программа просмотра документов (PDF, Postscript, djvu, tiff, dvi, XPS, поддержка SyncTex с gedit, комиксы (cbr, cbz, cb7 и cbt)) ; https://archlinux.org/packages/extra/x86_64/evince/ ; https://apps.gnome.org/ru/Evince/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Xpdf - (для просмотра документов PDF)?"
echo -e "${MAGENTA}:: ${BOLD}Xpdf (XpdfReader) - это высокопроизводительный просмотрщик PDF-файлов, легко справляющийся даже с огромными PDF-документами. ${NC}"
echo " Домашняя страница: http://www.xpdfreader.com/ ; (https://archlinux.org/packages/extra/x86_64/xpdf/). "  
echo -e "${MAGENTA}:: ${BOLD}В состав Xpdf входит целый набор утилит: xpdf/XpdfReader — основная программа для просмотра PDF-файлов ; pdftotext — утилита для конвертации PDF в обычный текст ; pdftops — утилита для конвертации PDF в PostScript ; pdftoppm — утилита для конвертации PDF страниц в файлы изображений PPM/PGM/PBM ; pdftopng — утилита для конвертации PDF страниц в PNG ; pdftohtml — утилита для конвертации PDF в HTML-формат ; pdfinfo — утилита для выборки мета-данных ; pdfimages — утилита для извлечения изображений из PDF файлов ; pdffonts — выводит список шрифтов, используемых в PDF файле ; pdfdetach — извлекает прикрепленные файлы из PDF файлов. ${NC}"
echo " Программа написана на языке C/C++. Графическая версия xpdf / XpdfReader использует библиотеку Qt. " 
echo " Первый релиз программы состоялся в 1995 году. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_xpdf  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_xpdf" =~ [^10] ]]
do
    :
done
if [[ $in_xpdf == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_xpdf == 1 ]]; then
  echo ""
  echo " Установка Xpdf (XpdfReader) "
sudo pacman -S --noconfirm --needed xpdf  # Средство просмотра файлов формата портативных документов (PDF) ; Xpdf (XpdfReader) — высокопроизводительный просмотрщик PDF-файлов, легко справляющийся даже с огромными PDF-документами. https://archlinux.org/packages/extra/x86_64/xpdf/ ; https://www.xpdfreader.com/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить MuPDF - (для просмотра документов PDF, XPS и EPUB)?"
echo -e "${MAGENTA}:: ${BOLD}MuPDF - это быстрое и мощное решение для управления PDF-файлами и другими форматами документов. ${NC}"
echo " Домашняя страница: https://mupdf.com/ ; (https://archlinux.org/packages/extra/x86_64/mupdf/). "  
echo -e "${MAGENTA}:: ${BOLD}MuPDF — Легковесный, обеспечивает высокую скорость работы, качественный рендеринг. Начиная с версии 1.2, MuPDF имеет опциональную поддержку интерактивных функций, таких как заполнение форм, JavaScript и переходы. ${NC}"
echo " Ряд бесплатных программных приложений используют MuPDF для рендеринга PDF-документов, наиболее известным из которых является Sumatra PDF . MuPDF также доступен в виде пакета для большинства дистрибутивов Unix-подобных операционных систем. MuPDF доступен для Linux, Windows, iOS, Android. Также есть порты программы на другие устройства. " 
echo " Лучшая библиотека для управления PDF-документами. Библиотека поставляется с элементарным просмотрщиком X11 и Windows, а также набором инструментов командной строки для пакетного рендеринга (mutool draw), проверки структуры файла (mutool show) и перезаписи файлов (mutool clean). Более поздние версии также имеют интерпретатор JavaScript (mutool run), который позволяет запускать скрипты для создания и редактирования PDF-файлов."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_mupdf  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_mupdf" =~ [^10] ]]
do
    :
done
if [[ $in_mupdf == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_mupdf == 1 ]]; then
  echo ""
  echo " Установка MuPDF "
sudo pacman -S --noconfirm --needed mupdf  # Легкий просмотрщик PDF и XPS ; https://mupdf.com/ ; https://archlinux.org/packages/extra/x86_64/mupdf/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить OCRFeeder - (для анализа макета документа и система распознавания оптических символов)?"
echo -e "${MAGENTA}:: ${BOLD}OCRFeeder - это анализ макета документа и система распознавания оптических символов. Благодаря изображениям он автоматически определяет его содержимое, различает графику и текст и выполняет OCR над последним. Лучший аналог Abbyy Fine reader - хотя тупит местами! ${NC}"
echo " Домашняя страница: https://wiki.gnome.org/Apps/OCRFeeder ; (https://archlinux.org/packages/extra/any/ocrfeeder/). "  
echo -e "${MAGENTA}:: ${BOLD}Учитывая изображения, он автоматически выделит их содержимое, отличит графику от текста и выполнит OCR для последнего. Он генерирует несколько форматов, основным из которых является ODT. ${NC}"
echo " Он оснащен полноценным графическим пользовательским интерфейсом GTK, который позволяет пользователям исправлять любые нераспознанные символы, определять или исправлять ограничивающие рамки, устанавливать стили абзацев, очищать входные изображения, импортировать PDF-файлы, сохранять и загружать проект, экспортировать все в несколько форматов и т. д. OCRFeeder был разработан как проект магистерской диссертации по информатике Жоакима Рочи. " 
echo " Возможности: Автоматическое определение установленных OCR-программ: Cuneiform, GOCR, Ocrad, Tesseract; Есть импорт изображений со сканера; Есть проверка орфографии в распознанном тексте. "
echo " Поддерживаемы форматы ввода: PNG, JPEG, BMP, TIFF, GIF, Portable anymap (PNM, PGM, PBM, PPM) , PDF. Поддерживаемые форматы вывода: текстовый файл, ODT, HTML, PDF. "
echo " Возможна обработка изображений для улучшения качества распознавания — фильтры шумов, чёрного цвета и оттенков серого; и другие виды обработок, доступных для Unpaper; Возможно выделение «полезных» областей страницы; Распознавание нескольких изображений по порядку за один проход (пакетное распознавание); Имеется возможность коррекции не распознанных символов. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_ocrfeeder  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_ocrfeeder" =~ [^10] ]]
do
    :
done
if [[ $in_ocrfeeder == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_ocrfeeder == 1 ]]; then
  echo ""
  echo " Установка OCRFeeder "
sudo pacman -S --noconfirm --needed ocrfeeder  # Приложение для анализа макета документа GTK и оптического распознавания символов ; https://wiki.gnome.org/Apps/OCRFeeder ; https://archlinux.org/packages/extra/any/ocrfeeder/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить PDFArranger - (для выполнения различных действий с PDF документами)?"
echo -e "${MAGENTA}:: ${BOLD}PDFArranger - это простая программа для выполнения различных действий с PDF документами (перемещение, удаление, обрезка, поворот страниц в документе, объединение PDF файлов и так далее). ${NC}"
echo " Домашняя страница: https://github.com/pdfarranger/pdfarranger ; (https://archlinux.org/packages/extra/any/pdfarranger/). "  
echo -e "${MAGENTA}:: ${BOLD}PDFArranger отличается своей простотой и удобством работы. Программа поддерживает базовую функциональность для работы со страницами PDF файлов и не перегружена различными функциями. Это интерфейс для pikepdf - (https://github.com/pikepdf/pikepdf). PikePDF — это библиотека Python для чтения и записи PDF-файлов. ${NC}"
echo " PDF Arranger — это ответвление PDF-Shuffler Константиноса Пулиоса (см. Savannah - https://savannah.nongnu.org/projects/pdfshuffler или Sourceforge - https://sourceforge.net/projects/pdfshuffler/ ). Это скромная попытка сделать проект немного более активным. " 
echo " Возможности PDFArranger: Перемещение страниц PDF-документа с помощью мыши (Drag&Drop) ; Удаление страниц ; Поворот страниц влево или вправо на 90 градусов ; Перестановка выделенных страниц в обратном порядке ; Обрезка страниц. Пользователь задает области слева, справа, сверху, снизу страницы в процентах, которые требуется обрезать ; Объединение PDF файлов ; Экспорт выделенных страниц в отдельный PDF-документ. "
echo " Программа написана на Python с использованием библиотек GTK - (python-gtk). Программа является форком утилиты PDFShuffler, которая уже давно не развивается (https://savannah.nongnu.org/projects/pdfshuffler). "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_pdfarranger  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_pdfarranger" =~ [^10] ]]
do
    :
done
if [[ $in_pdfarranger == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_pdfarranger == 1 ]]; then
  echo ""
  echo " Установка PDFArranger "
sudo pacman -S --noconfirm --needed python-pikepdf  # Чтение и запись PDF-файлов с помощью Python на базе qpdf. https://github.com/pikepdf/pikepdf ; https://archlinux.org/packages/extra/x86_64/python-pikepdf/  
sudo pacman -S --noconfirm --needed pdfarranger  # Помогает объединять или разделять PDF-документы, а также вращать, обрезать и переставлять страницы. https://github.com/pdfarranger/pdfarranger ; https://archlinux.org/packages/extra/any/pdfarranger/ 
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить DjView - (для просмотра DjVu-файлов)?"
echo -e "${MAGENTA}:: ${BOLD}DjView (DjView4) - это полноценная программа для просмотра файлов в формате DjVu на основе библиотеки DjVuLibre. DjVuLibre — это реализация DjVu с открытым исходным кодом (GPL), включающая в себя просмотрщики, плагины для браузеров, декодеры, простые кодировщики и утилиты. ${NC}"
echo " Домашняя страница: https://djvu.sourceforge.net/djview4.html ; https://djvu.sourceforge.net/ ; (https://archlinux.org/packages/extra/x86_64/djview/ ; https://archlinux.org/packages/extra/x86_64/djvulibre/). "  
echo -e "${MAGENTA}:: ${BOLD}DjView4 Возможности: Просмотр страниц электронных книг непрерывным полотном. Для перелистывания используйте скролл или кнопки на панели сверху ; Открытие djvu файлов по ссылке из интернета, копирование url адреса текущей страницы ; Подгон масштаба по ширине страницы или экрана монитора ; Навигация по встроенному оглавлению ; Поиск слов на странице с учетом регистра, простой поиск и по регулярному выражению ; Копирование текста со страницы в буфер обмена или сохранение сразу в TXT файл ; Поворот содержимого книги на 90, 180 и 270 градусов ; Увеличение текста на экране с помощью инструмента «Лупа». Нажмите CTRL+SHIFT, чтобы активировать ее. DjView поддерживает экспорт (конвертацию) из формата DjVu в другие: PDF, TIFF, PostScript, BMP, ICO, JPG, PNG, PPM ; Загрузка DjVu-файлов с жёсткого диска или из сети Интернет, введя URL и т.д.. Лицензия: GPL2. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_djvu  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_djvu" =~ [^10] ]]
do
    :
done
if [[ $in_djvu == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_djvu == 1 ]]; then
  echo ""
  echo " Установка DjView (DjView4) "
sudo pacman -S --noconfirm --needed djvulibre  # Библиотека и утилиты для создания, обработки и просмотра документов DjVu (déjà vu) ('дежавю') ; https://archlinux.org/packages/extra/x86_64/djview/ ; https://archlinux.org/packages/extra/x86_64/djvulibre/ ; https://djvu.sourceforge.net/
sudo pacman -S --noconfirm --needed djview  # Просмотрщик документов DjVu ; https://djvu.sourceforge.net/djview4.html ; https://archlinux.org/packages/extra/x86_64/djview/ ; https://archlinux.org/packages/extra/x86_64/djvulibre/ ; https://djvu.sourceforge.net/
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Calibre - (для управления электронными книгами)?"
echo -e "${MAGENTA}:: ${BOLD}Calibre - это менеджер электронных книг — удобное средство для управления электронными книгами. ${NC}"
echo " Домашняя страница: https://calibre-ebook.com/ ; (https://archlinux.org/packages/extra/x86_64/calibre/). "  
echo -e "${MAGENTA}:: ${BOLD}Программа позволяет создать базу электронных книг. Для каждой книги можно добавлять различную информацию. ${NC}"
echo " Основные возможности программы: Составление базы данных книг ; Различные поля для описания книг ; Тегирование ; Поддержка большого числа форматов ; Конвертация между форматами электронных книг ; Скачивание метаданных о книгах из интернета ; Синхронизация с различными устройствами чтения электронных книг ; Автоматическая загрузка новостей с популярных новостных ресурсов ; Поддержка плагинов ; Встроенный просмотрщик (читалка) для чтения книг ; Редактор метаданных электронных книг ; Встроенный сервер, позволяющий получить доступ к базе через браузер. " 
echo " Calibre — отличное решение для тех, кто любит читать. Это свободное программное обеспечение с открытым исходным кодом (Лицензия: GNU GPL v3), реализованное на языках C и Python с использованием библиотек Qt4. Приложение переведено на русский язык. " 
echo " Поддерживается чтение (и, что хорошо — конвертирование) множества форматов, среди которых есть популярные *.chm, *.epub, *.fb2, *.html. *.odt, *.pdf, *.txt, а также архивы *.rar и *zip. "
echo " Также, вместе с Calibre, будет установлена программа-просмотрщик текстов «E-book viewer». Однако «E-book viewer» поддерживает просмотр не всех форматов, поддерживаемых Calibre. В таких случаях используются системные ассоциации форматов. К примеру, книги формата *.txt открываются у меня в редакторе текста, установленном по-умолчанию. Для удобства я конвертировал их в *.fb2. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_calibre  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_calibre" =~ [^10] ]]
do
    :
done
if [[ $in_calibre == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_calibre == 1 ]]; then
  echo ""
  echo " Установка Calibre "
sudo pacman -S --noconfirm --needed calibre  # Приложение для управления электронными книгами ;  https://calibre-ebook.com/ ; https://archlinux.org/packages/extra/x86_64/calibre/
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить CoolReader - (для чтения электронных книг)?"
echo -e "${MAGENTA}:: ${BOLD}CoolReader (CoolReader3) - это кроссплатформенная компьютерная программа для чтения электронных книг в различных форматах на основе XML/CSS. ${NC}"
echo " Домашняя страница: https://github.com/buggins/coolreader ; (https://archlinux.org/packages/extra/x86_64/coolreader/). "  
echo -e "${MAGENTA}:: ${BOLD}Программа работает на платформах Win32, Linux, Android, Tizen, macOS. Портирована на некоторые устройства на основе EInk и является программным обеспечением с открытым исходным кодом. Последние версии CoolReader выпускаются для платформы Android. ${NC}"
echo " Эта программа является свободным программным обеспечением; вы можете распространять ее и/или изменять в соответствии с условиями GNU General Public License (GNU GPL), опубликованными Free Software Foundation; либо версии 2 Лицензии, либо (по вашему выбору) любой более поздней версии. " 
echo " Особенности программы - поддержка форматов: FB2, EPUB (без-DRM), MOBI (без-DRM), DOC, RTF, HTML, CHM, TXT, TCR, PDB, PRC, PML (PalmDOC, eReader) ; гибкая настройка стилей с помощью файлов CSS ; поддержка закладок ; поиск по тексту ; выделение текста ; перекрестные ссылки и гиперссылки ; отображение сносок внизу страницы ; поворот страницы на 90, 180 и 270 градусов ; автоматическая расстановка переносов (алгоритмическая или словарная) ; чтение книг напрямую из ZIP. " 
echo " Приложение переведено на русский язык. Библиотеки: GTK ; Qt. "
echo " Репозиторий Sourceforge может использоваться как зеркало: git clone https://github.com/buggins/coolreader.git. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_coolreader  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_coolreader" =~ [^10] ]]
do
    :
done
if [[ $in_coolreader == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_coolreader == 1 ]]; then
  echo ""
  echo " Установка CoolReader (CoolReader3) "
sudo pacman -S --noconfirm --needed coolreader  # Быстрая и небольшая программа для чтения электронных книг на основе XML/CSS ; https://github.com/buggins/coolreader ; https://archlinux.org/packages/extra/x86_64/coolreader/
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить FBReader - (для чтения электронных книг)?"
echo -e "${MAGENTA}:: ${BOLD}FBReader - это программа для чтения электронных книг. FBReader поддерживает большинство популярных форматов электронных книг: fb2, txt, chm, RTF, ePub, mobi, HTML и другие. Основные форматы – fb2 и ePub. ${NC}"
echo " Домашняя страница: https://fbreader.org/ ; (https://archlinux.org/packages/extra/x86_64/fbreader/). "  
echo -e "${MAGENTA}:: ${BOLD}FBReader позволяет открывать файлы прямо из файлов архивов tar, zip, gzip и bzip2. Помимо этого программе можно указать каталог, в котором находятся книги и она автоматически проскандирует его и составит библиотеку на основе найденных файлов. FBReader обладает большим числом настроек, что позволяет настроить программу «под себя» для комфортного чтения. ${NC}"
echo " FBReader – популярная (более 30 миллионов установок) программа для чтения книг. Работает на iOS, Android, Windows, Mac OS, Linux и Chrome OS. FBReader использует свой собственный движок для разбора и отрисовки страниц. Движок очень лёгкий, быстрый и настраиваемый. " 
echo " С 2015 года исходный код программы был закрыт. Новая версия FBReader 2.0 стала использовать проприетарную модель, а для разработки дополнений предлагается использовать Fbreader SDK - библиотека для создания читалок на нашем движке. " 
echo " Программа полностью переведена на русский язык. Для Linux существует две версии программы, одна с графической оболочкой основанной на GTK, другая на QT. "
echo " Где хранить книги? Книжная сеть FBReader – облачное хранилище для вашей библиотеки. Файлы хранятся на вашем собственном Google Drive™. Книги можно объединять по авторам, сериям, и т.п. . Синхронизация набора книг, позиций чтения и закладок между устройствами. Возможность управления коллекцией с компьютера. Простой доступ из браузера или прямо из FBReader. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_fbreader  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_fbreader" =~ [^10] ]]
do
    :
done
if [[ $in_fbreader == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_fbreader == 1 ]]; then
  echo ""
  echo " Установка FBReader "
sudo pacman -S --noconfirm --needed fbreader  # Электронная книга для Linux ; https://fbreader.org/ ; https://archlinux.org/packages/extra/x86_64/fbreader/
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Antiword - (для чтения и конвертации документов MS Word)?"
echo -e "${MAGENTA}:: ${BOLD}Antiword - это бесплатное программное обеспечение для чтения документов Microsoft Word. Она преобразует двоичные файлы из MS Word 2, 6, 7, 97, 2000 и 2003 в текст, Postscript, PDF и XML/DocBook (экспериментальная версия). Обратите внимание, что она не поддерживает форматы на основе XML, которые новые версии MS Word создают по умолчанию (.docx). ${NC}"
echo " Домашняя страница: https://github.com/grobian/antiword ; (https://web.archive.org/web/20221207132720/http://www.winfield.demon.nl ; https://archlinux.org/packages/extra/x86_64/antiword/). "  
echo -e "${MAGENTA}:: ${BOLD}Antiword: чтение документов MS Word в вашем терминале [Linux]. Документы Microsoft Word, почти вездесущие в деловых условиях, можно считать необходимым злом для пользователей Linux. Конечно, вы можете открывать файлы Word в LibreOffice, но ждать, пока тяжелое графическое приложение загрузит ваш документ, — это больно. Antiword — это решение, которое работает в вашем терминале — идеально для людей с медленными компьютерами или системами без графической среды. ${NC}"
echo " Прежде чем вы слишком воодушевитесь, я должен упомянуть, что Antiword последний раз обновлялся в 2005 году и несовместим с новыми документами DOCX. Вы также не можете использовать его для редактирования ваших документов. " 
echo " Antiword поддерживает следующие форматы бумаги: - 10×14 ; a3 ; a4 ;a5 ; b4 ; b5 ; executive ; folio ; legal ; letter ; note ; quarto ; statement ; tabloid. Чтобы узнать, что еще вы можете сделать с помощью Antiword, включая восстановление текста, который был изменен в MS Word, загляните на страницу руководства. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_antiword  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_antiword" =~ [^10] ]]
do
    :
done
if [[ $in_antiword == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_antiword == 1 ]]; then
  echo ""
  echo " Установка Antiword "
sudo pacman -S --noconfirm --needed antiword  # Бесплатная программа для чтения MS Word для Linux и RISC OS ; https://web.archive.org/web/20221207132720/http://www.winfield.demon.nl ; https://archlinux.org/packages/extra/x86_64/antiword/ ; https://github.com/grobian/antiword
echo " Установка утилит (пакетов) выполнена "
fi
######## Справка ##########
# Самый простой способ использования antiword — просто отобразить документ
# antiword resume.doc
# Чтобы отобразить информацию о форматировании, используйте флаг “-f” в вашей команде:
# antiword -f resume.doc
# Чтобы преобразовать документ Word в PDF-файл, необходимо указать формат бумаги, используя флажок “-a”. 
# Antiword поддерживает следующие форматы бумаги: 10×14;a3;a4;a5;b4;b5;executive;folio;legal;letter;note;quarto;statement;tabloid
# В этом примере документ преобразуется в PDF-файл формата таблоида
# antiword -a tabloid resume.doc > resume-tabloid.pdf
# Неплохо! Пунктирное подчеркивание и гиперссылка на адрес электронной почты исчезли, но в целом преобразование прошло успешно.
#Если вы конвертируете в Postscript, вы также можете использовать “-L” для печати в альбомном режиме.
# В этом примере документ будет преобразован в формат DocBook:
# antiword -x db resume.doc > resume-docbook.docbook
# Преобразование также сохранит метаданные, включая имя автора и дату создания документа. Вот как выглядит исходный XML-файл:
# Вы можете видеть, что он выглядит иначе, чем исходный документ Word, но структура в основном сохранена. Преобразование в DocBook с помощью Antiword, вероятно, будет лучше работать с документами Word, которые были созданы с учетом преобразования в XML.
################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Catdoc и UnRTF - (программа командной строки для чтения и конвертации документов Rich Text Format (.rtf) в HTML, LaTeX, макросы troff и сам RTF)?"
echo -e "${MAGENTA}:: ${BOLD}Catdoc - это программа, которая читает один или несколько файлов Microsoft Word и выводит текст, содержащийся в них, на стандартный вывод. Поэтому она выполняет ту же работу для файлов .doc, что и команда unix cat для простых файлов ASCII. ${NC}"
echo " Домашняя страница: https://www.wagner.pp.ru/~vitus/software/catdoc/ ; (https://archlinux.org/packages/extra/x86_64/catdoc/). "  
echo -e "${MAGENTA}:: ${BOLD}Теперь к нему прилагаются xls2csv — программа, которая преобразует электронную таблицу Excel в файл со значениями, разделенными запятыми, и catppt — утилита для извлечения текстовой информации из файлов PowerPoint. ${NC}"
echo " При желании catdoc может преобразовывать некоторые символы, не входящие в ASCII, в соответствующие управляющие последовательности TeX и преобразовывать наборы символов из кодовой страницы Windows ANSI в локальную кодовую страницу целевой машины. (Поскольку catdoc — русская программа, по умолчанию она преобразует cp1251 в koi8-r при работе под UNIX и в cp866 при работе под DOS. " 
echo " Catdoc даже не пытается сохранить форматирование символов MS-Word. Его цель — извлечь простой текст и позволить вам его прочитать и, возможно, переформатировать с помощью TeX, согласно правилам TeXnical, о которых большинство пользователей Word даже не слышали. "
echo -e "${MAGENTA}:: ${BOLD}UnRTF - это программа командной строки, написанная на языке C, которая преобразует документы в формате Rich Text Format (.rtf) в HTML, LaTeX, макросы troff и сам RTF. Преобразуя в HTML, он поддерживает ряд функций Rich Text Format. ${NC}"
echo " Домашняя страница: https://www.gnu.org/software/unrtf/unrtf.html ; (https://archlinux.org/packages/extra/x86_64/unrtf/). "  
echo -e "${MAGENTA}:: ${BOLD}Rich Text Format: Изменения шрифта, размера, толщины (жирный) и наклона (курсив) текста ; Подчеркивания и зачеркивания ; Частичная поддержка затенения текста, контурирования, тиснения или гравировки ; Капитализации ; Надстрочные и подстрочные индексы ; Расширенный и сжатый текст ; Изменения в цветах переднего плана и фона ; Преобразование специальных символов в HTML-сущности. ${NC}" 
echo " Недавние разработки были сосредоточены на преобразовании в HTML, поскольку он в свою очередь может быть преобразован в другие форматы. Поддержка функций при преобразовании в другие форматы файлов с использованием unrtf варьируется. Начиная с версии 0.21.0 все преобразования кодовых страниц выполняются через iconv, а все управление выводом осуществляется через файлы конфигурации времени выполнения, включая определенные кодировки шрифтов. Таким образом, вывод unrtf можно легко настроить для новых форматов, а вывод для существующих форматов можно настроить. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_unrtf  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_unrtf" =~ [^10] ]]
do
    :
done
if [[ $in_unrtf == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_unrtf == 1 ]]; then
  echo ""
  echo " Установка Catdoc и UnRTF "
sudo pacman -S --noconfirm --needed catdoc  # Конвертер файлов Microsoft Word, Excel, PowerPoint и RTF в текст ; https://www.wagner.pp.ru/~vitus/software/catdoc/ ; https://archlinux.org/packages/extra/x86_64/catdoc/
sudo pacman -S --noconfirm --needed unrtf  # Программа командной строки, конвертирующая документы RTF в другие форматы ; https://www.gnu.org/software/unrtf/unrtf.html ; https://archlinux.org/packages/extra/x86_64/unrtf/
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить BlueFish - (для редактирования кода)?"
echo -e "${MAGENTA}:: ${BOLD}Bluefish Editor - это Bluefish — мощный редактор, ориентированный на программистов и веб-разработчиков, с множеством опций для написания веб-сайтов, скриптов и программного кода. Bluefish поддерживает множество языков программирования и разметки. ${NC}"
echo " Домашняя страница: http://bluefish.openoffice.nl/ ; (https://archlinux.org/packages/extra/x86_64/bluefish/ ; https://sourceforge.net/projects/bluefish/). "  
echo -e "${MAGENTA}:: ${BOLD}Имеет панель управления для добавления часто используемых HTML тегов, CSS элементов и некоторых других вставок, с возможностью ввода параметров элементов. ${NC}"
echo " Bluefish — это многоплатформенное приложение, работающее на большинстве настольных операционных систем, включая Linux, Mac OSX, Windows, FreeBSD и OpenBSD. Bluefish — проект разработки с открытым исходным кодом, выпущенный под лицензией GNU GPL. Bluefish полностью переведен на русский язык (Переводы на 17 языков), современный, удобный, функциональный редактор кода. " 
echo " Bluefish Editor поддерживает редактирование файлов на удаленных системах (используется gnome-vfs). Имеет возможности автозавершения ключевых слов и тегов. С полным списком возможностей можно ознакомиться на сайте программы. " 
echo " Bluefish имеет много функций, этот список даст вам обзор наиболее важных или выдающихся функций в Bluefish : Легковесность — Bluefish старается быть максимально простым и понятным, учитывая, что это графический редактор. Скорость — Bluefish запускается очень быстро (даже на нетбуке) и загружает сотни файлов за считанные секунды.
Интерфейс с несколькими документами, легко открывает более 500 документов (проверено более 10000 документов одновременно). Многопоточная поддержка удаленных файлов с использованием gvfs, поддержка FTP , SFTP , HTTP , HTTPS , WebDAV , CIFS и других. Очень мощный поиск и замена с поддержкой регулярных выражений, совместимых с Perl, заменой подшаблонов, а также поиском и заменой в файлах на диске.
Рекурсивное открытие файлов на основе шаблонов имен файлов и/или шаблонов содержимого. Боковая панель фрагментов — задайте пользовательские диалоговые окна, шаблоны поиска и замены или вставьте шаблоны и привяжите их к сочетанию клавиш по вашему вкусу, чтобы ускорить процесс разработки. Интегрируйте внешние программы, такие как make, lint, weblint, xmllint, tidy, javac, или свою собственную программу или скрипт для выполнения расширенной обработки текста или обнаружения ошибок и т.д.... "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_bluefish  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_bluefish" =~ [^10] ]]
do
    :
done
if [[ $in_bluefish == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_bluefish == 1 ]]; then
  echo ""
  echo " Установка Bluefish Editor "
sudo pacman -S --noconfirm --needed bluefish  # Мощный HTML-редактор для опытных веб-дизайнеров и программистов ; http://bluefish.openoffice.nl/ ; 
echo " Установка утилит (пакетов) выполнена "
fi
################

clear
echo -e "${MAGENTA}
  <<< Установка рекомендованных программ (пакетов) - по вашему выбору и желанию >>> ${NC}"
# Installation of recommended programs (packages) - according to your choice and desire

echo ""
echo -e "${GREEN}==> ${BOLD}Установить рекомендованные программы (пакеты)? ${NC}"
#echo -e "${BLUE}:: ${NC}Установить рекомендованные программы (пакеты)?"
#echo 'Установить рекомендованные программы?'
# Install the recommended programs
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (gparted, grub-customizer, dconf-editor, conky, conky-manager, obs-studio, filezilla, telegram-desktop, discord, flameshot, redshift, bleachbit, cherrytree, doublecmd-gtk2, keepass, keepassxc, veracrypt, nomacs, onboard, meld, uget, plank, openshot, handbrake, galculator, galculator-gtk2, gnome-calculator)."
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
sudo pacman -S --noconfirm --needed gparted  # (создавать, удалять, перемещать, копировать, изменять размер и др.) без потери данных.
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Grub Customizer?"
echo -e "${MAGENTA}:: ${BOLD}Grub Customizer - это новый менеджер настроек для GRUB2 на гуях. ${NC}"
echo " На данный момент он позволяет: переименовывать, переупорядочивать, удалять, добавлять и скрывать элементы меню выбора загрузчика. "
echo " Программа позволяет отредактировать (переименовать, удалить, скрыть) пункты меню загрузчика, цвета пунктов меню, фоновое изображение загрузчика GRUB и многое другое. Также можно установить таймаут (время ожидания запуска ОС), разрешение экрана, прописать дополнительные параметры для ядра. Программа поддерживает загрузчики GRUB 2 и Burg. "
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
sudo pacman -S --noconfirm --needed grub-customizer  # Графический менеджер настроек grub2 ; https://launchpad.net/grub-customizer ; https://archlinux.org/packages/extra/x86_64/grub-customizer/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Conky и Conky-Manager (пакеты conky conky-manager)?"
echo -e "${MAGENTA}:: ${BOLD}Для тех кто не знает, то Conky - это мощный и легко настраиваемый системный монитор, который может отображать любую информацию на рабочем столе. ${NC}"
echo " В сети полно готовых конфигураций conky, можно взять любой понравившийся и скопировать в файл .conkyrc, который нужно создать в домашней папке (директории). Или в /etc/conky/conky.conf, так поступил и я. "
echo -e "${CYAN}:: ${BOLD}Conky Manager - это графический интерфейс для управления файлами конфигурации Conky.${NC}"
echo " Он предоставляет опции для запуска и остановки, просмотра и редактирования тем Conky, установленных в системе. Запуск нескольких экземпляров Conky с разными конфигурациями. Открытие внешнего текстового редактора для редактирования файла конфигурации. Импорт архивов с темами оформления. "
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
#sudo pacman -S --noconfirm --needed conky conky-manager  # Легкий системный монитор для X; Графический интерфейс для управления конфигурационными файлами Conky с возможностью просмотра и редактирования тем
sudo pacman -S --noconfirm --needed conky  # Легкий системный монитор для X ; https://github.com/brndnmtthws/conky ; https://archlinux.org/packages/extra/x86_64/conky/ ; (Помечено как устаревшее 05.07.2024)
sudo pacman -S --noconfirm --needed conky-manager  # Графический интерфейс для управления конфигурационными файлами Conky с возможностью просмотра и редактирования тем ; https://launchpad.net/conky-manager ; https://archlinux.org/packages/extra/x86_64/conky-manager/
# https://pingvinus.ru/note/conky-config-installation (Установка и настройка Conky)
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Open Broadcaster Software®️ (OBS)?"
echo -e "${MAGENTA}:: ${BOLD}OBS Studio - это бесплатное программное обеспечение с открытым исходным кодом для прямой трансляции и записи (Потоковое вещание и запись скринкастов). ${NC}"
echo " OBS Studio (Open Broadcaster Software) позволяет создавать стримы и записывать видео с различных источников. Программа поддерживает создание сцен, которые могут включать различные источники видео и аудио, а также иметь различные настройки записи видео. Во время трансляции можно переключаться между сценами. Для стриминга программа использует распространенный протокол RTMP. "
echo " Программа на русском языке для записи видео и стримов на Twitch, YouTube, GoodGame, SC2TV, Hitbox.TV и любые другие RTMP-серверы трансляций. Можно добавлять свои сервисы. "
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
sudo pacman -S --noconfirm --needed obs-studio  # Бесплатное программное обеспечение с открытым исходным кодом для прямой трансляции и записи ; https://obsproject.com/ ; https://archlinux.org/packages/extra/x86_64/obs-studio/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить FileZilla (клиент FTP)?"
echo -e "${MAGENTA}:: ${BOLD}FileZilla - это быстрый и надежный клиент FTP, FTPS и SFTP. ${NC}"
echo " FileZilla — популярный бесплатный FTP клиент для Linux. Поддерживает протоколы FTP, FTP over SSL/TLS (FTPS), SFTP. В FileZilla можно настроить закладки для различных FTP соединений. Закладки позволяют перемещаться по директориям синхронно с удаленным FTP соединением. Главное окно программы может отображать несколько областей. Первая - это две панели содержащих локальные и удаленные файлы. Также можно показать окно с отображением статуса передачи файлов и вывода ошибок, окно с очередью передачи файлов. "
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
sudo pacman -S --noconfirm --needed filezilla  # Быстрый и надежный FTP, FTPS и SFTP-клиент (графический клиент) ; https://filezilla-project.org/ ; https://archlinux.org/packages/extra/x86_64/filezilla/ 
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Telegram Desktop (мессенджер)?"
echo -e "${MAGENTA}:: ${BOLD}Telegram Desktop - это официальное приложение Telegram для настольных операционных систем. ${NC}"
echo " 'Telegram Desktop' - является прямой реализацией веб-сайта Telegram. Бесплатный (никаких платных подписок) мессенджер от компании Павла Дурова. "
echo -e "${MAGENTA}=> ${NC}Telegram - это мессенджер и облачный сервис, для обмена сообщениями и различными медиа файлами. В первую очередь известен благодаря шифрованию и защите личных данных пользователей."
echo " Напомним, что недавно в России разблокировали Telegram. Хотя почти никто и не прекращал им пользоваться, разблокировка принесла несколько хороших побочных эффектов. Один из которых — множество интернет-сайтов, которые были недоступны в следствии некорректной блокировки IP-адресов Telegram, стали доступны. В частности, популярный в Linux среде ресурс www.gnome-look.org теперь работает свободно. "
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
sudo pacman -S --noconfirm --needed telegram-desktop  # Официальный клиент Telegram Desktop ; https://desktop.telegram.org/ ; https://archlinux.org/packages/extra/x86_64/telegram-desktop/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Discord (голосовой и текстовый чат)?"
echo -e "${MAGENTA}:: ${BOLD}Discord - это проприетарное кроссплатформенное универсальное приложение для голосового и текстового чата. ${NC}"
echo " 'Discord' - специально разработан для геймеров; однако у многих сообществ с открытым исходным кодом также есть официальные серверы Discord. https://discord.com/open-source "
echo -e "${MAGENTA}=> ${NC}Discord можно использовать через веб-браузер или настольное приложение, созданное с помощью Electron. https://github.com/electron/electron"
echo -e "${YELLOW}:: Примечание! ${NC}Вы можете самостоятельно установить discord на arch linux. Загрузите файл discard с расширением .tar.gz с официального сайта (https://discord.com/download). Затем извлеките его с помощью tar-xvzf filename. Далее измените свой каталог на вновь извлеченный каталог и сделайте имя файла Discord исполняемым с помощью команды chmod +x Discord. Наконец, выполните команду ./Discord, чтобы запустить discord."
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
sudo pacman -S --noconfirm --needed discord  # Единый голосовой и текстовый чат для геймеров ; https://discord.com/ ; https://archlinux.org/packages/extra/x86_64/discord/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
################

clear
echo -e "${MAGENTA}
  <<< Установка программ для просмотра изображений в Archlinux >>> ${NC}"
# Installing image viewer programs in Archlinux
echo ""
echo -e "${BLUE}:: ${NC}Установить Flameshot (создания скриншотов)?"
echo -e "${MAGENTA}:: ${BOLD}Flameshot - инструмент для создания и редактирования скриншотов в Linux. ${NC}"
echo " Что подкупило в Flameshot, так это то, что во время создания снимка имеется возможность редактирования, без необходимости предварительного сохранения снимка, т.е. создание и редактирование в одном окне или на лету. "
echo " Возможности программы Flameshot: Создание скриншота рабочего стола. Создание скриншота выбранной области. Создание скриншота активного окна программы. Редактирование скриншота: Добавление графических примитивов: стрелок, прямоугольников, окружностей, линий. Выделение маркером (полупрозрачное выделение). Размытие выделенной области. "
echo " Возможность прикрепить скриншот на рабочий стол (в плавающем окне). Копирование снимков в буфер обмена. Открытие снимка во внешней программе. Загрузка снимка на сервис Imgur. Изменение цвета интерфейса программы. Задание шаблона для имен файлов. Доступны предустановленные элементы для шаблона имени файла: год, день недели, месяц, время, час, минута, секунда, название месяца и другие. Всплывающие уведомления на рабочем столе. Поддержка командной строки. "
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
sudo pacman -S --noconfirm --needed flameshot  # Мощное, но простое в использовании программное обеспечение для создания снимков экрана ; https://github.com/flameshot-org/flameshot ; https://archlinux.org/packages/extra/x86_64/flameshot/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить digiKam (для управления цифровыми фотографиями)?"
echo -e "${MAGENTA}:: ${BOLD}digiKam - это это органайзер изображений на базе KDE со встроенными функциями редактирования с помощью архитектуры плагинов. Программа DigiKam органично интегрирована в среду рабочего стола KDE. Для корректного отображения значков (без пропущенных значков), когда вы не используете среду рабочего стола KDE, необходимо установить тему значков KDE (breeze-icons) и активировать ее в настройках Digikam. После установки вам следует настроить Digikam на использование значков: Перейдите в Настройки > Настроить digiKam > Разное, затем в меню Внешний вид выберите (Breeze) или (Breeze Dark) в качестве темы значка. Значки Breeze для других рабочих столов: Совместимо с KDE, GNOME, Xfce, Cinnamon, MATE, LXQt. Язык интерфейса: русский, английский и другие... Лицензия: GNU GPL. Интерфейс: Qt. ${NC}"
echo " Домашняя страница: https://www.digikam.org/ ; (https://sourceforge.net/software/product/digiKam/ ; https://archlinux.org/packages/extra/x86_64/digikam/ ; https://wiki.archlinux.org/title/Digikam). "  
echo -e "${MAGENTA}:: ${BOLD}Описание: Программа поддерживает импорт фотографий, RAW-файлов и видео напрямую с фотоаппарата, внешних устройств (SD карт, USB носителей и так далее). Позволяет настраивать и выполнять автоматическую каталогизацию во время импорта файлов. Например распределять файлы по альбомам, используя дату снимка. digiKam размещает файлы по альбомам. ${NC}"
echo " Есть возможность добавлять теги, выставлять оценки и добавлять пометки к каждому файлу. Поддерживается поиск и выборка файлов по различным критериям. Можно искать файлы по тегам, рейтингу, локации, названию, по EXIF, IPTC и XMP метаданным. Поддерживается работа с RAW-файлами. Программа имеет возможность просмотра альбомов на карте, используя гео-информацию в метаданных. " 
echo " Программа включает целый набор инструментов для редактирования фотографий: баланс цвета, коррекция яркости, контрастности, гаммы, кадрирование, изменение размера, изменение резкости, настройка кривых, формирование панорамы, смешение каналов, инструменты улучшения снимков, добавление текста, добавление водяного знака, преобразование в другие форматы и другие.  "
echo " Программа digiKam имеет очень гибкий интерфейс, который можно настраивать в широких пределах. При первом запуске программы открывается Визард, в котором нужно выполнить некоторые первичные настройки. Вам будет предложено выбрать директорию, в которой хранятся ваши фотографии. Позднее можно добавлять дополнительные директории через настройки программы. Также при первом запуске нужно указать директорию, в которой будут хранится данные самой программы (база данных программы). "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_digikam  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_digikam" =~ [^10] ]]
do
    :
done
if [[ $in_digikam == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_digikam == 1 ]]; then
  echo ""
  echo " Установка digiKam "
sudo pacman -S --noconfirm --needed digikam  # Расширенное приложение для управления цифровыми фотографиями ; https://www.digikam.org/ ; https://sourceforge.net/software/product/digiKam/ ; https://archlinux.org/packages/extra/x86_64/digikam/ ; https://wiki.archlinux.org/title/Digikam
############## Breeze-icons ##########
sudo pacman -S --noconfirm --needed breeze-icons  # Тема иконок Breeze ; https://community.kde.org/Frameworks ; https://archlinux.org/packages/extra/x86_64/breeze-icons/ ; https://github.com/KDE/breeze-icons
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
######################## Справка ###################
### digikam-plugins-demo - https://github.com/cgilles/digikam-plugins-demo ; https://github.com/cgilles/digikam-plugins-demo.git
### Этот репозиторий содержит несколько демонстрационных кодов для написания новых внешних плагинов digiKam (Digikam::DPlugin). Он предоставляет 4 плагина: Универсальный инструмент ; Инструмент «Редактор изображений» ; Инструмент диспетчера пакетной очереди ; Raw Import for Image Editor. Этот плагин открывает RAW-файл в редакторе с помощью простого вызова командной строки с помощью инструмента dcraw.
### Плагины не зависят от фреймворка KDE. Плагины можно скомпилировать с помощью Qt5 или Qt6. 
### Breeze-icons — тема иконок, совместимая с freedesktop.org. Она разработана сообществом KDE как часть KDE Frameworks 5 и используется по умолчанию в KDE Plasma 5 и KDE Applications. Инструкции по использованию значков Breeze описаны на сайте develop.kde.org/hig .
### Значки Breeze для других рабочих столов: Совместимо с KDE, GNOME, Xfce, Cinnamon, MATE, LXQt.
########################################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Eog (Eye of GNOME) (для просмотра изображений)?"
echo -e "${MAGENTA}:: ${BOLD}Eog (Eye of GNOME) - это простая программа для просмотра графики для рабочего стола GNOME, которая использует библиотеку gdk-pixbuf. Она может работать с большими изображениями, масштабировать и прокручивать их при постоянном использовании памяти. Ее целью является простота и соответствие стандартам. Eye of GNOME также отображает EXIF-метаданные об изображении. ${NC}"
echo " В отличие от других программ просмотра, Eye of GNOME предоставляет только базовые возможности работы с изображениями такие как: масштабирование изображения, полноэкранный режим просмотра и интерполирование при увеличении изображения. (https://archlinux.org/packages/extra/x86_64/eog/ ; https://github.com/GNOME/eog ; Домашняя страница: http://projects.gnome.org/eog . "  
echo -e "${MAGENTA}:: ${BOLD}Описание Eog (Eye of GNOME) - Сильные стороны Eog: Поддерживаемые графические форматы: ANI, BMP, GIF, ICO, JPEG, PCX, PNG, PNM, RAS, SVG, TGA, TIFF, WBMP, XBM, XPM ; Перелистывание изображений - Space/Backspace и стрелка Вправо/стрелка Влево, масштаб - колесо мыши ; При отображении изображения применяется сглаживание ; Есть полноэкранный режим и режим слайд-шоу ; Можно развернуть изображение по часовой и против часовой стрелки, а так же отразить горизонтально и вертикально и т.д.. ${NC}"
echo " Слабые стороны Eog: Eye of GNOME работает заметно медленнее, чем другие приложения такого рода ; Панель предпросмотра можно разместить только снизу, при этом нельзя изменить её размер ; Отсутствуют инструменты редактирования изображений ; Не поддерживается GIF-анимация. " 
echo " Язык интерфейса: русский, английский ; Лицензия: GNU GPL вер.2. "
echo " В 2023 году разработчики GNOME осуществили релиз Loupe, который стал заменой Eye of GNOME ; (https://archlinux.org/packages/extra/x86_64/loupe/) (https://gitlab.gnome.org/GNOME/loupe). "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_eog  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_eog" =~ [^10] ]]
do
    :
done
if [[ $in_eog == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_eog == 1 ]]; then
  echo ""
  echo " Установка Eog (Eye of GNOME) "
sudo pacman -S --noconfirm --needed eog  #  Eye of Gnome: программа для просмотра и каталогизации изображений ; https://archlinux.org/packages/extra/x86_64/eog/ ; https://github.com/GNOME/eog
sudo pacman -S --noconfirm --needed eog-plugins  # Плагины для Eye of Gnome
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Loupe (для просмотра изображений)?"
echo -e "${MAGENTA}:: ${BOLD}Loupe - это новое приложение для просмотра изображений в GNOME. Оно написано на безопасном для памяти языке программирования Rust и предлагает ряд функций, таких как: кнопки на экране для переключения между различными фотографиями, увеличения и уменьшения масштаба, перехода в полноэкранный режим и другие ; встроенный в интерфейс инструмент просмотра метаданных, который показывает такие данные, как местоположение, размер, разрешение, дата создания и т. д. ; поддержка клавиатурных и трекпада сочетаний клавиш ; опции копирования в буфер обмена, перемещения в корзину и печати изображения. ${NC}"
echo " Loupe может заменить существующий Eye of GNOME (eog) Image Viewer ; Домашняя страница: https://github.com/GNOME/loupe ; (https://gitlab.gnome.org/GNOME/loupe ; https://archlinux.org/packages/extra/x86_64/loupe/). "  
echo -e "${MAGENTA}:: ${BOLD}Image Viewer использует glycin для загрузки изображений. Вы можете проверить README glycin для получения более подробной информации о форматах, поддерживаемых загрузчиками по умолчанию. Однако glycin поддерживает добавление загрузчиков для дополнительных форматов. Поэтому поддерживаемые форматы в вашей системе могут различаться и могут быть изменены путем установки или удаления загрузчиков glycin. ${NC}"
echo " Если вы вручную собираете Loupe в своей системе с помощью Builder, убедитесь, что вы также установили ночную версию для работы всех функций. В противном случае версия для разработки не будет иметь требуемых разрешений Flatpak. " 
echo " В 2023 году разработчики GNOME осуществили релиз Loupe, который стал заменой Eye of GNOME. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_loupe  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_loupe" =~ [^10] ]]
do
    :
done
if [[ $in_loupe == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_loupe == 1 ]]; then
  echo ""
  echo " Установка Loupe (of GNOME) "
sudo pacman -S --noconfirm --needed loupe  # Простой просмотрщик изображений для GNOME (лупа); https://archlinux.org/packages/extra/x86_64/loupe/ ; https://gitlab.gnome.org/GNOME/loupe
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Viewnior (для просмотра изображений)?"
echo -e "${MAGENTA}:: ${BOLD}Viewnior - это элегантный и минималистичный просмотрщик изображений для систем Linux. Он поддерживает различные функции, такие как полноэкранный режим, слайд-шоу, поворот, переворот, обрезка и другие операции с изображениями. Он также имеет настраиваемое действие мыши и простой интерфейс. ${NC}"
echo " Просмотрщик изображений Viewnior использует модифицированную пользователем библиотеку GtkImageView. Эта библиотека обеспечивает быстрый и плавный просмотр изображений. "  
echo -e "${MAGENTA}:: ${BOLD}Viewnior может просматривать только выбранные изображения. Таким образом, вы можете отфильтровать нежелательные файлы. ${NC}"
echo " Также может автоматически определять среду рабочего стола и устанавливать соответствующее изображение в качестве обоев ; отображать метаданные EXIF ​​и IPTC. Оба содержат настройки камеры, местоположения и информацию о дате. " 
echo " Кроме того, вы можете открыть изображение с помощью Viewnior, непосредственно из файлового менеджера (viewnior ~/Downloads/test_image.jpg).  "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_viewnior  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_viewnior" =~ [^10] ]]
do
    :
done
if [[ $in_viewnior == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_viewnior == 1 ]]; then
  echo ""
  echo " Установка Viewer "
sudo pacman -S --noconfirm --needed viewnior  #  Простая, быстрая и элегантная программа просмотра изображений ; https://siyanpanayotov.com/project/viewnior ; https://archlinux.org/packages/extra/x86_64/viewnior/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
###################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Redshift (оберегает Ваше зрение)?"
echo -e "${MAGENTA}:: ${BOLD}Redshift - регулирует цветовую температуру экрана в соответствии с окружающей обстановкой (временем суток). ${NC}"
echo " Делает работу за компьютером более комфортной и оберегая Ваше зрение. "
echo " Redshift как минимум понадобится ваше местоположение для запуска (если -Oоно не используется), то есть широта и долгота вашего местоположения. Redshift использует несколько процедур для получения вашего местоположения. Если ни одна из них не работает (например, не установлена ​​ни одна из используемых вспомогательных программ), вам нужно ввести свое местоположение вручную. "
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
sudo pacman -S --noconfirm --needed redshift  # Регулирует цветовую температуру экрана в соответствии с окружающей обстановкой ; http://jonls.dk/redshift/ ; https://archlinux.org/packages/extra/x86_64/redshift/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить BleachBit (для тщательной очистки)?"
echo -e "${MAGENTA}:: ${BOLD}BleachBit - это мощное приложение, предназначенное для тщательной очистки компьютера и удаления ненужных файлов, что помогает освободить место на дисках и удалить конфиденциальные данные. ${NC}"
echo " Возможности - Автоматическое удаление ненужных файлов в системе. Большой набор «клинеров» (cleaners) — поддержка большого количества приложений, с возможностью удаления ненужных (например, временных) файлов данных приложений. Безвозвратное удаление файлов с защитой от восстановления (shred). Безвозвратное удаление произвольных файлов. Поддержка интерфейса командной строки. Модуль CleanerML для написания поддержки дополнительных «клинеров». "
echo " Интерфейс - Окно программы разделено на две части. Слева отображается древовидный список того, что можно очистить. При клике на любой из пунктов справа отображается информация о том, что именно будет удалено. После выбора пунктов для удаления можно нажать кнопку Предпросмотр (Preview) и посмотреть какие файлы будут удалены, сколько файлов и их размер. Чтобы начать процесс удаления нужно нажать кнопку Очистка (Clean). "
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
sudo pacman -S --noconfirm --needed bleachbit  # Удаляет ненужные файлы, чтобы освободить место на диске и сохранить конфиденциальность ; https://www.bleachbit.org/ ; https://archlinux.org/packages/extra/any/bleachbit/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить CherryTree (создания иерархических заметок)?"
echo -e "${MAGENTA}:: ${BOLD}CherryTree - это удобное и очень быстрое приложение для записи коротких заметок, позволяющее иерархически структурировать всю нужную информацию в наглядном виде. ${NC}"
echo -e "${MAGENTA}=> ${NC}CherryTree может выступать в качестве текстового редактора, позволяя вставлять в текст таблицы, изображения, ссылки и другие элементы. Поддерживает подсветку синтаксиса."
echo " Интерфейс CherryTree очень простой, красивый и удобный, что сразу же располагает пользователя, после установки. Многоуровневая структура, поддержка ссылок, тегов и другое ..."
echo -e "${YELLOW}:: Примечание! ${NC}Вы можете самостоятельно установить (пакет) cherrytree-bin (https://aur.archlinux.org/packages/cherrytree-bin/), или (пакет) cherrytree-git (https://aur.archlinux.org/packages/cherrytree-bin/), если Вам нужна версия из исходников. Так же эти версии (пакетов) будут представлены в следующем скрипте (archmy4l)."
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
sudo pacman -S --noconfirm --needed cherrytree  # Приложение для создания иерархических заметок ; https://www.giuspen.com/cherrytree/ ; https://archlinux.org/packages/extra/x86_64/cherrytree/
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
echo -e "${BLUE}:: ${NC}Установить Double Commander (Двухпанельный файловый менеджер - Аналог Total Commander)?"
echo -e "${MAGENTA}:: ${BOLD}Double Commander - двухпанельный файловый менеджер с открытым исходным кодом, работающий под Linux (два варианта, с использованием библиотек GTK+ или Qt). Программа доступна в двух версиях: с GTK и Qt интерфейсом. Имеет множество возможностей по управлению файлами и обладает большим числом настроек. Язык интерфейса: русский, английский и другие... Лицензия: GNU GPL. ${NC}"
echo " Кроме стандартных возможностей файлового менеджера Double Commander поддерживает монтирование сетевых -шар и локальных дисков, легкое создание символических и жестких ссылок, а также имеет очень много горячих кнопок. "
echo " Домашняя страница: https://doublecmd.sourceforge.io/ ; (https://archlinux.org/packages/extra/x86_64/doublecmd-gtk2/ ; https://archlinux.org/packages/extra/x86_64/doublecmd-qt5/ ; https://archlinux.org/packages/extra/x86_64/doublecmd-qt6/). "  
echo -e "${MAGENTA}:: ${BOLD}Описание: Double Commander поддерживает вкладки, может сравнивать файлы и каталоги, поддерживает множественное переименование. Программа имеет расширенные возможности поиска файлов по шаблону, поиска текста в файлах и замены текста. Имеет встроенный редактор текста с подсветкой синтаксиса. Поддерживается работа с архивами, программа может работать с ними как с каталогами. ${NC}"
echo " Double Commander обладает большим числом настроек и позволяет настраивать внешний вид. Программа поддерживает плагины. По своей функциональности и оформлению Double Commander напоминает Total Commander и является ему хорошей бесплатной альтернативой в Linux. "
echo -e "${YELLOW}:: Примечание! ${NC}В сценарии (скрипте) присутствуют три варианта (версии) установки: Double Commander (GTK2)(пакет doublecmd-gtk2) - раскомментирован! И устанавливается (по умолчанию); Double Commander (Qt5)(пакет doublecmd-qt5) - закомментирован ; и Double Commander (Qt6)(пакет doublecmd-qt6) - закомментирован. "
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют функция пропуска установки уже установленных пакетов! ${NC}"
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить Double Commander (GTK2),     0 - НЕТ - Пропустить установку: " i_doublecmd  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
  echo " Установка Double Commander (GTK2) "
sudo pacman -S --noconfirm --needed doublecmd-gtk2  # двухпанельный файловый менеджер (GTK2) ; https://doublecmd.sourceforge.io/ ; https://archlinux.org/packages/extra/x86_64/doublecmd-gtk2/
#sudo pacman -S --noconfirm --needed doublecmd-qt5  #  двухпанельный (в стиле Commander) файловый менеджер (Qt5) ; http://doublecmd.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/doublecmd-qt5/
#sudo pacman -S --noconfirm --needed doublecmd-qt6  # двухпанельный (в стиле Commander) файловый менеджер (Qt6) ; http://doublecmd.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/doublecmd-qt6/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Krusader (Двухпанельный файловый менеджер)?"
echo -e "${MAGENTA}:: ${BOLD}Krusader - это продвинутый двухпанельный (в стиле Commander) файловый менеджер для KDE Plasma и других рабочих столов в мире *nix - (это чистый функциональный пакетный менеджер и система развёртывания для POSIX-совместимых ОС), похожий на Midnight (https://midnight-commander.org/) или Total Commander (https://www.ghisler.com/download.htm). Он предоставляет все функции управления файлами, которые вам могут понадобиться. Язык интерфейса: русский, английский и другие... Лицензия: GNU GPL. ${NC}"
echo " Домашняя страница: https://krusader.org/ ; (https://archlinux.org/packages/extra/x86_64/krusader/). "  
echo -e "${MAGENTA}:: ${BOLD}Описание: Интерфейс программы выполнен в классическом для двухпанельных файловых менеджеров стиле. Сверху расположено меню и панель управления с кнопками. В нижней части расположена панель с функциональными кнопками (F1, F2, ...). Содержимое панелей с файлами можно просматривать в виде таблицы, древовидной структуры. Есть поддержка (root) прав. ${NC}" 
echo " Основные особенности и возможности: Поддержка примонтированных файловых систем. Работа с архивами. Поддержка FTP и SFTP. Поиск файлов. Встроенный просмотрщик и редактор файлов. Функция синхронизации директорий. Сравнение содержимого файлов и директорий. Пакетное переименование файлов. Поддержка вкладок. Закладки. Статистика использования диска. Менеджер монтирования. Пользовательские профили. Встроенный теримнал. Настраиваемые горячие клавиши. Настраиваемые панели инструментов. Хорошая интеграция с KDE. И другие возможности. "
echo " Он поддерживает широкий спектр форматов архивов и может работать с другими KIO-ведомыми, такими как smb или fish. Он (почти) полностью настраиваемый, очень удобный для пользователя, быстрый и отлично смотрится на вашем рабочем столе! Вам стоит попробовать. "
echo " Разработка Krusader началась в 2000 году программистами Ши Эрлихом (Shie Erlich) и Рафи Янаи (Rafi Yanai). Первоначальная цель была создать аналог файлового менеджера Total Commander для Linux. Первый релиз Krusader появился в июле 2000 года и работал в KDE2. Это программное обеспечение разработано Krusader Krew и опубликовано в соответствии с лицензией GNU General Public License 2 или (по вашему выбору) любой более поздней версии. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_krusader  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_krusader" =~ [^10] ]]
do
    :
done
if [[ $in_krusader == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_krusader == 1 ]]; then
  echo ""
  echo " Установка Krusader "
sudo pacman -S --noconfirm --needed krusader  # Расширенный файловый менеджер с двумя панелями (в стиле Commander) ; https://krusader.org/ ; https://archlinux.org/packages/extra/x86_64/krusader/ ; 
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
###########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить KeePass (для хранения паролей)?"
echo -e "${MAGENTA}:: ${BOLD}KeePass - простой в использовании менеджер паролей для Windows, Linux, Mac OS X и мобильных устройств. ${NC}"
echo " Домашняя страница: https://keepass.info/ ; (https://archlinux.org/packages/extra/any/keepass/). "  
echo -e "${MAGENTA}:: ${BOLD}Описание: KeePass — это бесплатный менеджер паролей с открытым исходным кодом, который помогает вам безопасно управлять вашими паролями. Вы можете хранить все свои пароли в одной базе данных, которая заблокирована мастер-ключом. Таким образом, вам нужно запомнить только один мастер-ключ, чтобы разблокировать всю базу данных. Файлы базы данных шифруются с использованием лучших и самых безопасных алгоритмов шифрования, известных в настоящее время (AES-256, ChaCha20 и Twofish). ${NC}" 
echo " Программа переведена более чем на 40 языков, включая русский. KeePass имеет портативную версию программы, устанавливать которую не обязательно. Экспорт в форматы TXT, HTML, XML и CSV, а также импорт из множества различных форматов. "
echo " KeePass очень удобна и мобильна, ее можно переносить на любой диск компьютера, флешку и любое другое устройство. "
echo " Почему KeePass? Сегодня вам нужно помнить много паролей. Вам нужен пароль для многих веб-сайтов, вашей учетной записи электронной почты, вашего веб-сервера, сетевых логинов и т. д. Список бесконечен. Кроме того, вам следует использовать разные пароли для каждой учетной записи, потому что если вы будете использовать только один пароль везде и кто-то получит этот пароль, у вас возникнет проблема: вор получит доступ ко всем вашим учетным записям. "
echo " Как русифицировать KeePass2? Заходим на страничку - (https://keepass.info/translations.html)(https://keepass.info/plugins.html), скачиваем нужный вам языковой пакет (архив) в зависимости от вашей установленной версии. (Далее см. справку в скрипте). "
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
sudo pacman -S --noconfirm --needed keepass  # Простой в использовании менеджер паролей для Windows, Linux, Mac OS X и мобильных устройств ; https://keepass.info/ ; https://archlinux.org/packages/extra/any/keepass/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########## Справка ##############
# Щелкните левой кнопкой мыши ссылку загрузки выбранного вами языка (для KeePass 1.x щелкните ссылку «[1.x+]»; для KeePass 2.x щелкните ссылку «[2.x+]»). Распакуйте загруженный ZIP-файл (в текущий каталог).
# В KeePass нажмите «Вид» → «Изменить язык» → кнопка «Открыть папку»; KeePass теперь открывает папку с именем «Языки». Переместите распакованные файлы в папку «Языки».
# Переключитесь на KeePass, нажмите «Вид» → «Изменить язык» и выберите свой язык. Перезапустите KeePass.
# Если вы используете старую версию, посмотрите архивы переводов 1.x / 2.x.
# ИЛИ (https://pingvinus.ru/forum/discussion/1135/kak-rusificirovat-keepass2-v-linux-mint/p1) - Как русифицировать KeePass2?
# wget `curl -s https://keepass.info/translations.html | grep -o -E 'https://downloads.sourceforge.net/keepass/KeePass[0-9.-]+Russian.zip' | tail -n 1`
# unzip KeePass-*-Russian.zip
# rm KeePass-*-Russian.zip
# sudo mkdir /usr/lib/keepass2/Languages
# sudo mv Russian.lngx /usr/lib/keepass2/Languages
# keepass2
######################################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить KeePassXC (для хранения паролей)?"
echo -e "${MAGENTA}:: ${BOLD}KeePassXC - простой в использовании менеджер паролей для Windows, Linux, Mac OS X и мобильных устройств. Все пароли хранятся в одном зашифрованном файле. Пароли можно объединять в группы. Есть встроенный генератор паролей. ${NC}"
echo " KeePassXC - является форком еще одного менеджера паролей KeePassX, преимущество KeePassXC заключается в его развитии, а точней в его разработке. "
echo " Домашняя страница: https://keepassxc.org/ ; (https://archlinux.org/packages/extra/x86_64/keepassxc/). "  
echo " На сегодняшний день, осмелюсь предположить, это лучший менеджер паролей, надежный и что не мало важно, с открытым исходным кодом. Поддерживает алгоритмы шифрования – AES, Twofish или ChaCha20, имеет совместимость с другими менеджерами паролей – KeePass2, KeePassX, KeeWeb. Имеет интеграцию с браузерами Google Chrome, Chromium, Mozilla Firefox. "
echo " Для каждой записи (для каждого пароля) можно задать название, login (имя), сам пароль, указать web-ссылку, написать комментарий, задать срок годности пароля, прикрепить файл, выбрать графическую иконку. Все пароли можно сохранять в группы. Для группы можно задать имя и иконку. По всем полям можно выполнять поиск. При первом запуске программы вы должны сначала создать новую базу, в которой будут храниться пароли, и задать для нее один общий пароль. Его, конечно, лучше делать посложнее. Дополнительно можно создать файл-ключ. Каждая база хранится в одном зашифрованном файле. Баз можно создавать сколько угодно и открывать их в программе, вводя пароль от базы (и указывая файл-ключ, если вы его создавали). "  
echo "  "
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
sudo pacman -S --noconfirm --needed keepassxc  # Кроссплатформенный порт менеджера паролей Keepass, созданный сообществом ; https://keepassxc.org/ ; https://archlinux.org/packages/extra/x86_64/keepassxc/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить VeraCrypt (ПО для шифрования)?"
echo -e "${MAGENTA}:: ${BOLD}VeraCrypt - шифрование диска с надежной защитой на основе TrueCrypt. ${NC}"
echo " VeraCrypt — это бесплатное программное обеспечение с открытым исходным кодом для шифрования дисков для Windows, Mac OSX и Linux. "
echo " Это - мощная программа с большим количеством функций. Программа предназначена для шифрования файлов, папок или целых дисков. "
echo " Домашняя страница: https://www.veracrypt.fr/ ; (https://archlinux.org/packages/extra/x86_64/veracrypt/ ; https://veracrypt.eu/en/Downloads.html ; https://veracrypt.eu/en/Home.html). "  
echo -e "${MAGENTA}:: ${BOLD}Описание: Что вам дает VeraCrypt? VeraCrypt добавляет улучшенную безопасность алгоритмам, используемым для шифрования системы и разделов, делая их неуязвимыми для новых разработок в атаках методом подбора. Эта улучшенная безопасность добавляет некоторую задержку только к открытию зашифрованных разделов без какого-либо влияния на производительность фазы использования приложения. Это приемлемо для законного владельца, но это значительно затрудняет злоумышленнику получение доступа к зашифрованным данным. ${NC}" 
echo " Основные особенности и возможности: Создает виртуальный зашифрованный диск внутри файла и монтирует его как реальный диск. Шифрует целый раздел или устройство хранения данных , например USB-флеш-накопитель или жесткий диск. Шифрует раздел или диск, на котором установлена ​​Windows (предзагрузочная аутентификация). Шифрование происходит автоматически , в режиме реального времени (на лету) и прозрачно. Распараллеливание и конвейеризация позволяют считывать и записывать данные так же быстро, как если бы диск не был зашифрован. На современных процессорах шифрование может быть ускорено аппаратно. Обеспечивает правдоподобное отрицание в случае, если злоумышленник заставит вас раскрыть пароль: скрытый том (стеганография) и скрытая операционная система. "
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
sudo pacman -S --noconfirm --needed veracrypt  # Шифрование диска с надежной защитой на основе TrueCrypt ; https://www.veracrypt.fr/ ; https://archlinux.org/packages/extra/x86_64/veracrypt/ ; https://veracrypt.eu/en/Downloads.html ; https://veracrypt.eu/en/Home.html
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo -e "${MAGENTA}
  <<< Установка программ для рисования и редактирования изображений в Archlinux >>> ${NC}"
# Installing programs for drawing and editing images in Archlinux
echo ""
echo -e "${BLUE}:: ${NC}Установить GIMP (для обработки изображений GNU)?"
echo -e "${MAGENTA}:: ${BOLD}GIMP - это растровый графический редактор для Linux. Программа предназначена для создания и обработки растровой графики и частичной поддержкой работы с векторной графикой. ${NC}"
echo " GIMP является почти полноценной альтернативой такой известной программы, как Adobe Photoshop. (https://www.gimp.org/downloads/ ; https://wiki.archlinux.org/title/GIMP ; https://docs.gimp.org/en/gimp-scripting.html) "
echo -e "${YELLOW}==> ${NC}Примечание: плагин Python-Fu недоступен в версии GIMP, распространяемой через официальные репозитории, поскольку для него требуется python2 из AUR (https://aur.archlinux.org/packages/python2), поддержка которого прекращена в 2020 году. Для восстановления функциональности можно использовать python2-gimp из AUR (https://aur.archlinux.org/packages/python2-gimp) (https://aur.archlinux.org/packages?K=gimp-plugin). "
echo " В частности, тема GimpPs направлена ​​на то, чтобы сделать GIMP более похожим на Photoshop, который можно установить поверх GIMP.. (https://github.com/doctormo/GimpPs ; https://github.com/doctormo/GimpPs.git). "
echo " Если же вам нужны только сочетания клавиш, соответствующие строки включены в файл темы menurc, который вы затем можете добавить в свой локальный ~/.config/GIMP/2.10/menurc. "
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют функция пропуска установки уже установленных пакетов! ${NC}"
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_gimp  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_gimp" =~ [^10] ]]
do
    :
done
if [[ $in_gimp == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_gimp == 1 ]]; then
  echo ""
  echo " Установка GIMP "
sudo pacman -S --noconfirm --needed gimp  # Программа обработки изображений GNU ; https://wiki.archlinux.org/title/GIMP
sudo pacman -S --noconfirm --needed gimp-help-en --noconfirm  # Английские файлы справки для GIMP 
sudo pacman -S --noconfirm --needed gimp-help-ru --noconfirm  # Русские файлы справки для GIMP
sudo pacman -S --noconfirm --needed gimp-plugin-gmic --noconfirm  # Плагин Gimp для фреймворка обработки изображений G'MIC ; https://archlinux.org/packages/extra/x86_64/gimp-plugin-gmic/ ; https://docs.gimp.org/en/gimp-scripting.html
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Pinta (для рисования / редактирования по образцу Paint.NET)?"
echo -e "${MAGENTA}:: ${BOLD}Pinta - это бесплатная программа с открытым исходным кодом для рисования и редактирования изображений. ${NC}"
echo " Его цель — предоставить пользователям простой, но мощный способ рисования и обработки изображений на Linux, Mac, Windows и *BSD (https://www.pinta-project.com/ ; https://github.com/PintaProject/Pinta). "
echo " Pinta — это GTK-клон Paint.Net 3.0. Оригинальный код Pinta лицензирован по лицензии MIT: см. license-mit.txtлицензию MIT. Код Paint.Net 3.36 используется по лицензии MIT и сохраняет оригинальные заголовки в исходных файлах. "
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют функция пропуска установки уже установленных пакетов! ${NC}"
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_pinta  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_pinta" =~ [^10] ]]
do
    :
done
if [[ $in_pinta == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_pinta == 1 ]]; then
  echo ""
  echo " Установка Pinta "
sudo pacman -S --noconfirm --needed pinta  # Программа для рисования / редактирования по образцу Paint.NET. Его цель - предоставить упрощенную альтернативу GIMP для обычных пользователей ; https://www.pinta-project.com/ ; https://github.com/PintaProject/Pinta
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Krita (Продвинутый графический редактор)?"
echo -e "${MAGENTA}:: ${BOLD}Krita - это бесплатный растровый графический редактор с массой возможностей. Широкая функциональность редактора позволяет использовать его как для обработки фотографий, так и для рисования. ${NC}"
echo " Интуитивно понятный пользовательский интерфейс, который не мешает. Докеры и панели можно перемещать и настраивать под ваш рабочий процесс. После настройки вы можете сохранить ее как свое рабочее пространство. Вы также можете создавать собственные ярлыки для часто используемых инструментов. Настраиваемый макет. Более 30 докеров для дополнительной функциональности. Темные и светлые цветовые темы. "
echo " Домашняя страница: https://krita.org/ ; (https://krita.org/en/features/ ; https://archlinux.org/packages/extra/x86_64/krita/). " 
echo " Krita — Некоторые возможности программы: Поддержка цветовых пространств RGB, CMYK, Lab и Grayscale. Поддержка слоев, масок, каналов. Множество фильтров с просмотром результата в реальном времени. Множество кистей для художников (с настройкой параметров). Импорт новых кистей. Стабилизация при рисовании кистью (если дрожат руки). Создание текстур (размножение объектов на холсте). Псевдо-бесконечный холст, который не имеет размеров. Настраиваемое всплывающее меню быстрого доступа. Настраиваемые горячие клавиши. Открытие и сохранение файлов в формате PSD. И многое другое... "
echo " Программа очень отзывчивая, многие операции выполняются моментально, задержки сведены к минимуму. Для некоторых ресурсозатратных операций используется OpenGL. Внешний вид редактора напомнил мне Photoshop и это явный плюс. Интерфейс выполнен очень аккуратно, все диалоги и элементы находятся на своих местах, компактно и продуманно. Если сравнить его с GIMP, то Krita мне понравился больше (Лучший аналог фотошопа). "
echo -e "${MAGENTA}:: ${BOLD}Изначально Krita был частью офисного пакета Calligra Suite (ранее KOffice), который входил в проект KDE. В 2015 году Krita отделился от Calligra и стал развиваться независимо, это дало сильный толчок в развитии программы. ${NC}"
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют функция пропуска установки уже установленных пакетов! ${NC}"
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_krita  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_krita" =~ [^10] ]]
do
    :
done
if [[ $in_krita == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_krita == 1 ]]; then
  echo ""
  echo " Установка Krita "
sudo pacman -S --noconfirm --needed krita  # Редактировать и раскрашивать изображения ; https://krita.org/ ; https://archlinux.org/packages/extra/x86_64/krita/
############ Плагины ##############
sudo pacman -S --noconfirm --needed krita-plugin-gmic  # Плагин GMic для Krita ; https://github.com/amyspark/gmic ; https://archlinux.org/packages/extra/x86_64/krita-plugin-gmic/ 
sudo pacman -S --noconfirm --needed kseexpr  # Встраиваемый механизм оценки выражений (ответвление Krita) ; https://krita.org/ ; https://archlinux.org/packages/extra/x86_64/kseexpr/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Inkscape (редактор векторной графики)?"
echo -e "${MAGENTA}:: ${BOLD}Inkscape - это бесплатный векторный графический редактор с открытым исходным кодом для GNU/Linux, Windows и macOS. Он предлагает богатый набор функций и широко используется как для художественных, так и для технических иллюстраций, таких как мультфильмы, клипарты, логотипы, типографика, диаграммы и блок-схемы. Он использует векторную графику для обеспечения четких распечаток и визуализаций с неограниченным разрешением и не привязан к фиксированному количеству пикселей, как растровая графика. Inkscape использует стандартизированный формат файла SVG в качестве основного формата, который поддерживается многими другими приложениями, включая веб-браузеры. Язык интерфейса: русский, английский и другие... Лицензия: GNU GPL v2. ${NC}"
echo " Домашняя страница: https://inkscape.org/ ; (https://archlinux.org/packages/extra/x86_64/inkscape/). "  
echo -e "${MAGENTA}:: ${BOLD}Описание: Он может импортировать и экспортировать различные форматы файлов, включая SVG, AI, EPS, PDF, PS и PNG. Он имеет полный набор функций, простой интерфейс, многоязычную поддержку и разработан с возможностью расширения; пользователи могут настраивать функциональность Inkscape с помощью дополнений. ${NC}" 
echo " Основные особенности и возможности: Позволяет создавать векторную графику различной степени сложности. Поддержка всех основных векторных примитивов. Большие возможности по редактированию векторной графики. Поддержка древовидных слоев. Работа с кривыми. Полная поддержка SVG. Использование SVG в качестве основного формата. "
echo " Поддержка экспорта в форматы: PNG, OpenDocument Drawing, DXF, sk1, PDF, EPS, PostScript. Поддержка опций командной строки для экспорта и конвертации. И многое другое... "
echo " Кто создает Inkscape? Inkscape имеет много авторов, каждый автор сохраняет свои собственные авторские права, и авторы также участвуют в определении технических и проектных целей Inkscape. Есть также много других некодирующих участников, которые считаются важными частями проекта Inkscape. "
echo " Независимо от того, являетесь ли вы иллюстратором, дизайнером, веб-дизайнером или просто тем, кому нужно создавать векторные изображения, Inkscape — это то, что вам нужно! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_inkscape  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_inkscape" =~ [^10] ]]
do
    :
done
if [[ $in_inkscape == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_inkscape == 1 ]]; then
  echo ""
  echo " Установка Inkscape "
sudo pacman -S --noconfirm --needed inkscape  # Профессиональный векторный графический редактор ; https://inkscape.org/ ; https://archlinux.org/packages/extra/x86_64/inkscape/ ; 
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
######################## Справка ###################
### Inkscape является членом Software Freedom Conservancy , некоммерческой организации US 501(c)(3). Взносы в Inkscape подлежат налоговому вычету в Соединенных Штатах.
##############################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить FreeCAD (САПР, 3D геометрическое моделирование)?"
echo -e "${MAGENTA}:: ${BOLD}FreeCAD - это бесплатная САПР, программа для трехмерного геометрического моделирования. Предназначена для создания параметрических объемных объектов различной сложности. Параметрическое моделирование позволяет вам легко изменять свой дизайн, возвращаясь к истории модели и изменяя ее параметры. Язык интерфейса: русский, английский и другие... Лицензия: GNU GPL. ${NC}"
echo " Домашняя страница: https://www.freecad.org/ ; (https://archlinux.org/packages/extra/x86_64/freecad/). "  
echo -e "${MAGENTA}:: ${BOLD}Описание: FreeCAD позволяет создавать параметрические 3D объекты реального мира. Программу можно применять для моделирования в таких областях, как архитектура, машиностроение, промышленный дизайн и других. "
echo " FreeCAD позволяет вам делать наброски геометрически ограниченных 2D-форм и использовать их в качестве основы для построения других объектов. Он содержит множество компонентов для корректировки размеров или извлечения деталей дизайна из 3D-моделей для создания высококачественных готовых к производству чертежей. ${NC}" 
echo " Основные особенности и возможности: Разработка 3D моделей различной степени сложности. Параметрическое 3D моделирование. Архитектурное моделирование. Создание двумерных эскизов. Создание двухмерных эскизов из трехмерных моделей. Получение высококачественных чертежей, готовых для производства. Большой набор инструментов для создания объектов. Большой набор готовых примитивов. Применение графических фильтров. Расстановка размеров объектов. Инструменты для выполнения моделирования и симуляции. Моделирование роботов. Поддержка большого числа форматов. Импорт и экспорт: STEP, IGES, STL, SVG, DXF, OBJ, IFC, DAE и другие. Настраиваемый интерфейс программы, поддерживающий концепцию профилей. Поддержка скриптов. Модульная архитектура программы. И многое другое. "
echo " FreeCAD обладает огромным количеством возможностей. Входной порог относительно низкий, программой смогут пользоваться не только профессионалы, но и менее опытные пользователи, например, студенты и преподаватели. К тому же, в интернете доступно множество руководств и видео-уроков по FreeCAD. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_freecad  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_freecad" =~ [^10] ]]
do
    :
done
if [[ $in_freecad == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_freecad == 1 ]]; then
  echo ""
  echo " Установка FreeCAD "
sudo pacman -S --noconfirm --needed freecad  # Параметрический 3D CAD-моделировщик на основе функций ; https://www.freecad.org/ ; (https://archlinux.org/packages/extra/x86_64/freecad/)
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#############

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Onboard (экранная клавиатура)?"
echo -e "${MAGENTA}:: ${BOLD}Onboard - это экранная клавиатура полезна на планшетных ПК или для пользователей с ограниченными физическими возможностями. ${NC}"
echo " Экранные клавиатуры - это альтернативный метод ввода который может заменить физическую клавиатуру. Виртуальная клавиатура может понадобиться в различных ситуациях. Например ваша физическая клавиатура сломалась или у вас недостаточно клавиатур для дополнительных машин, в вашем компьютере нет свободного разъема для подключения клавиатуры или вы человек с ограниченными возможностями и не можете использовать клавиатуру, или вы счастливый обладатель устройства с сенсорным экраном. "
echo " Также экранная клавиатура защищает вас от кейлогеров которые могут записывать ваши нажатия на клавиши чтобы получить секретную информацию например ваши пароли. Некоторые онлайновые банковые сервисы заставляют пользователей использовать виртуальную клавиатуру для защиты данных. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_onboard  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_onboard" =~ [^10] ]]
do
    :
done
if [[ $i_onboard == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_onboard == 1 ]]; then
  echo ""
  echo " Установка Onboard (экранной клавиатуры) "
sudo pacman -S --noconfirm --needed onboard  # Экранная клавиатура ; https://launchpad.net/onboard ; https://archlinux.org/packages/extra/x86_64/onboard/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Meld (для сравнения файлов)?"
echo -e "${MAGENTA}:: ${BOLD}Meld - программа для сравнения содержимого текстовых файлов или каталогов. ${NC}"
echo " Сравнение двух-трёх файлов или каталогов. Создание файлов правки (англ. patch file) с описанием различий между файлами. Работа с системами управления версиями Git, Subversion, Mercurial, Bazaar и CVS. Meld поддерживает вкладки и позволяет в одном окне работать сразу с несколькими файлами. "
echo " Это что-то вроде утилиты diff, но в графическом виде с возможностью «сливать» изменения, удалять и восстанавливать файлы. Можно сравнивать как два, так и три файла или каталога одновременно. При сравнении каталогов программа отображает в каких файлах были сделаны изменения, какие файлы были удалены или добавлены, а какие остались без изменений. А если сравнить файлы, тогда слева отобразится один файл, а справа другой, с подсветкой изменений и возможностью быстрого внесения изменений в файлы. "
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
sudo pacman -S --noconfirm --needed meld  # Сравнение файлов, каталогов и рабочих копий ; https://meldmerge.org/ ; https://archlinux.org/packages/extra/any/meld/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Plank (док-панель)?"
echo -e "${MAGENTA}:: ${BOLD}Plank - самая элегантная, простая док-панель в мире для linux. ${NC}"
echo " Эта панель минималистична во всем, начиная со своего размера и заканчивая основными функциями. "
echo " Plank создан для тех, кому нужен простой док без каких-либо дополнительных функций. Он основан на доке Docky, но использует только его базовый функционал. "
echo " Plank работает очень быстро, выглядит стильно и обладает приятными графическими эффектами. Док имеет возможность автоматического скрытия, если перекрывается окном открытой программы. Иконка каждой открытой программы появляется в доке. При клике правой кнопкой мыши по любой иконке открывается контекстное меню для данной программы. Каждую иконку можно закрепить. Присутствует простая анимация, при клике по иконке она подпрыгивает (аналогия с MacOS). Иконки можно перетаскивать мышкой. "
echo " К сожалению, пока нет графического интерфейса для настройки программы (хотя может и есть!!!). Все необходимые настройки хранятся в текстовом файле ~/.config/plank/dock1/settings. Для изменения настроек необходимо отредактировать данный файл. "
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
sudo pacman -S --noconfirm --needed plank  # Элегантный, простой, чистый док (док-панель) ; https://launchpad.net/plank ; https://archlinux.org/packages/extra/x86_64/plank/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить uGet (менеджер загрузок)?"
echo -e "${MAGENTA}:: ${BOLD}uGet - это универсальный менеджер закачек, который поддерживает докачку файлов, сортировку по группам, закачку через торренты и мета-ссылки (с помощью плагина aria2). Это отличный менеджер загрузок с большим количеством функций. ${NC}"
echo " Отмечу возможность создавать категории для закачек, чтобы было удобнее разбираться в загруженных файлах. Каждую категорию можно настроить определенным образом. В uGet есть простой планировщик, который позволяет установить часы и дни, в которые программа может скачивать файлы. Это удобно, если у вас почасовая тарификация трафика или, например, вы хотите запускать все закачки ночью. Иконка программы добавляется в область задач (трей). При клике на нее всплывает вспомогательное меню. uGet полностью переведен на русский язык и доступен для Linux и Windows (есть portable версия программы). "
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
sudo pacman -S --noconfirm --needed uget  # Менеджер загрузок GTK с классификацией загрузок и импортом HTML ; https://ugetdm.com/ ; https://archlinux.org/packages/extra/x86_64/uget/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
###############

clear
echo -e "${MAGENTA}
  <<< Установка программ для обработки видео и аудио в Archlinux >>> ${NC}"
# Installing video and audio processing software in Archlinux
echo ""
echo -e "${BLUE}:: ${NC}Установить OpenShot (нелинейный видеоредактор)?"
echo -e "${MAGENTA}:: ${BOLD}OpenShot - это свободный нелинейный видеоредактор, отмеченный наградами с открытым исходным кодом. Он конечно уступает Davinci resolve, но, для того что бы сделать видеомонтаж например для ютуб, его вполне хватит. ${NC}"
echo " OpenShot был разработан с помощью Python, GTK и MLT Framework. "
echo " Основные возможности программы: Программа использует библиотеку FFmpeg и поддерживает большое количество мультимедиа-форматов. Анимация по ключевым кадрам (Keyframe анимация). Интеграция с рабочим столом. Возможность перетаскивать файлы в окно программы из внешнего файлового менеджера. Неограниченное количество видео-дорожек (слоев). Поддержка операций масштабирования, обрезки, вращения и других. Поддержка ускорения, замедления видео. Более 400 эффектов переходов. Более 40 шаблонов для создания надписей (заголовков). Трехмерные анимированные заголовки. Видео-эффекты. Яркость, насыщенность, хромакей и много других. Возможность покадровой навигации по видео. Поддержка и редактирование аудио. Отоборажение формы аудио-дорожки (waveform, форма волны). Возможность отсоединить аудио-дорожку от видео. "
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
  sudo pacman -S --noconfirm --needed openshot  # Бесплатный видеоредактор с открытым исходным кодом, удостоенный наград ; https://www.openshot.org/ ; https://archlinux.org/packages/extra/any/openshot/
  echo ""
  echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить HandBrake (Многопоточный видео транскодер)?"
echo -e "${MAGENTA}:: ${BOLD}HandBrake — это инструмент с открытым исходным кодом, созданный добровольцами для конвертации видео практически из любого формата в ряд современных, широко поддерживаемых кодеков. ${NC}"
echo " Причины, по которым вам понравится HandBrake: Конвертируйте видео практически из любого формата; Бесплатно и с открытым исходным кодом; Мультиплатформенность (Windows, Mac и Linux)... "
echo " Начните работу с HandBrake за считанные секунды, выбрав профиль, оптимизированный для вашего устройства, или выберите универсальный профиль для стандартных или высококачественных преобразований... "
echo " HandBrake — программа, предназначенная для конвертирования файлов из большинства видео форматов в MP4 (M4V), MKV и WebM. Поддерживает применение фильтров, работу с файлами субтитров, редактирование тегов. Работа с программой HandBrake строится следующим образом. Пользователь выбирает файл источник (Source), указывает параметры конвертирования видео (видео, аудио, субтитры) и запускает процесс конвертации. Файлы можно поместить в очередь (Queue). В программе доступны предустановленные настройки для iPod, iPhone, iPad и других устройств. "
echo " Возможности: Готовые пресеты для конвертации видео в различные форматы и под различные устройства. Поддержка различных источников видео: обычные мультимедиа файлы, DVD- и BluRay-образы (без защиты от копирования). Выходные форматы: MP4 (.M4V), MKV, WebM. Кодировщики видео: AV1, H.265, H.264, MPEG-4, MPEG-2, VP8, VP9. Поддержка аппаратного ускорения. Кодировщики аудио: AAC / HE-AAC, MP3, FLAC, AC3, E-AC3, Opus, Vorbis. Audio Pass-Through: AC-3, E-AC3, FLAC, DTS, DTS-HD, TrueHD, AAC, Opus, MP3, MP2. Поддержка работы с файлами субтитров (VobSub, Closed Captions CEA-608, SSA, SRT). Применение фильтров к видео. Поддержка VFR (Variable Frame Rate) и CFR (Constant Frame Rate). Live-превью видео. Пакетная обработка и поддержка очереди файлов. Поддержка работы без графического интерфейса (через командную строку). И многое другое. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_handbrake  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_handbrake" =~ [^10] ]]
do
    :
done
if [[ $i_handbrake == 0 ]]; then
  echo ""
  echo " Установка утилит (пакетов) пропущена "
elif [[ $i_handbrake == 1 ]]; then
  echo ""
  echo " Установка HandBrake (Многопоточный видео транскодер) "
  sudo pacman -S --noconfirm --needed handbrake  # Многопоточный видео транскодер ; https://handbrake.fr/ ; https://archlinux.org/packages/extra/x86_64/handbrake/
  echo ""
  echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Kdenlive (для редактирования видео)?"
echo -e "${MAGENTA}:: ${BOLD}Kdenlive - это приложение для редактирования видео с поддержкой множества аудио- и видеоформатов. Оно предлагает расширенные функции редактирования, множество эффектов и переходов, цветокоррекцию, инструменты для постобработки аудио и субтитров. Кроме того, оно обеспечивает гибкость для рендеринга практически в любой формат по вашему выбору. ${NC}"
echo " Функции: Вложенные последовательности ; Настраиваемый интерфейс и сочетания клавиш ; Индикаторы: гистограмма, вектороскоп, RGB-парад, осциллограф и аудиометр ; Редактирование прокси ; Бесплатные онлайн-ресурсы и шаблоны ; Отслеживание движения ; Инструменты на базе искусственного интеллекта (https://apps.kde.org/ru/kdenlive/ ; https://github.com/KDE/kdenlive). "
echo " Kdenlive — с открытым исходным кодом, основанное на MLT Framework и KDE Frameworks 6. Оно распространяется в соответствии с лицензией GNU General Public License версии 3 или любой более поздней версии, принятой проектом KDE. "
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют функция пропуска установки уже установленных пакетов! ${NC}"
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_kdenlive  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_kdenlive" =~ [^10] ]]
do
    :
done
if [[ $i_kdenlive == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_kdenlive == 1 ]]; then
  echo ""
  echo " Установка Kdenlive "
sudo pacman -S --noconfirm --needed kdenlive  # Нелинейный видеоредактор для Linux, использующий видеофреймворк MLT
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить SoundConverter - (для конвертирования звуковых-аудио файлов)?"
echo -e "${MAGENTA}:: ${BOLD}SoundConverter - Аудио конвертер - это простая и удобная программа для конвертирования звуковых-аудио файлов из одного формата в другой. В качестве исходных файлов, могут быть как аудио, так и видео файлы различных форматов ogg, aac, mp3, flac, wav, avi, mpeg, mov, m4a, ac3, dts, alac, mpc и т.д. Преобразовывать аудио файлы можно в следующие форматы mp3, wav, ogg, m4a, flac. ${NC}"
echo " Домашняя страница: https://soundconverter.org/ ; (https://archlinux.org/packages/extra/any/soundconverter/). "  
echo -e "${MAGENTA}:: ${BOLD}Интерфейс программы лаконичный и понятный. Пользоваться программой очень просто. Сначала нужно указать параметры конвертирования в меню Edit(Редактирование)->Параметры. Здесь же можно задать формат выходного файла, качество, скорость (cbr, abr, vbr), результирующую папку и формат имени файла. Затем в программе нажать Добавить файл или Добавить папку и нажать кнопку Преобразовать. Начнется преобразование файлов из одного формата в другой. ${NC}"
echo " Быстрое, многопоточное преобразование - обрабатывает огромное количество файлов в рекордное время. Наконец-то используйте все эти ядра для ускорения конвертации. Он также может извлекать аудио из видео. " 
echo " Мощное автоматизированное переименование имён файлов и создать папки в соответствии с тегами. Зачем делать скучные задачи, когда можно просто нажать кнопку? SoundConverter — ведущий конвертер аудиофайлов для рабочего стола GNOME. Он читает все, что может прочитать GStreamer (Ogg Vorbis, AAC, MP3, FLAC, WAV, AVI, MPEG, MOV, M4A, AC3, DTS, ALAC, MPC, Shorten, APE, SID, MOD, XM, S3M и т. д.), и записывает в файлы Opus, Ogg Vorbis, FLAC, WAV, AAC и MP3 или использует любой аудиопрофиль GNOME."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_soundconv  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_soundconv" =~ [^10] ]]
do
    :
done
if [[ $in_soundconv == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_soundconv == 1 ]]; then
  echo ""
  echo " Установка SoundConverter "
sudo pacman -S --noconfirm --needed soundconverter  # Простое приложение-конвертер звука для GNOME ;https://soundconverter.org/ ; https://archlinux.org/packages/extra/any/soundconverter/
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить EasyTAG - (для просмотра и редактирования тегов в аудиофайлах)?"
echo -e "${MAGENTA}:: ${BOLD}EasyTAG - это бесплатная и с открытым исходным кодом, мультиплатформенная программа для просмотра и редактирования тегов аудиофайлов - MP3, MP4/AAC, FLAC, Ogg и других. ${NC}"
echo " Домашняя страница: https://wiki.gnome.org/Apps/EasyTAG ; (https://archlinux.org/packages/extra/x86_64/easytag/). "  
echo -e "${MAGENTA}:: ${BOLD}Описание: Просмотр, редактирование, запись тегов MP3, файлов MP2 (тег ID3 с изображениями), файлов FLAC (тег FLAC Vorbis), файлов Ogg Opus (тег Ogg Vorbis), Ogg Speex (тег Ogg Vorbis), файлов Ogg Vorbis (тег Ogg Vorbis) ), MP4 / AAC (тег MP4 / AAC), MusePack, аудиофайлы Monkey’s Audio и файлы WavPack (тег APE); Можно редактировать дополнительные поля тегов: название, исполнитель, альбом, номер диска, год, номер дорожки, комментарий, композитор, оригинальный исполнитель / исполнитель, авторское право, URL, имя кодировщика и прикрепленное изображение; Автоматическая маркировка: имя файла и каталог для автоматического заполнения полей (маски); Возможность переименовывать файлы и каталоги из тега (используя маски) или путем загрузки текстового файла; Обрабатывать выбранные файлы выбранного каталога; Возможность просмотра подкаталогов; Рекурсия для пометки, удаления, переименования, сохранения…; Можно установить поле (исполнитель, название, …) для всех других файлов; Чтение и отображение информации заголовка файла (битрейт, время,…); Автоматическое завершение даты, если введена частичная; Отменить и повторить последние изменения; Возможность обрабатывать поля тега и имени файла (конвертировать буквы в верхний, нижний регистр,…; Возможность открыть каталог или файл с помощью внешней программы; Поддержка CDDB с использованием серверов Freedb.org и Gnudb.org (ручной и автоматический поиск); Древовидный браузер или просмотр по исполнителю и альбому; Список для выбора файлов; Окно генератора списка воспроизведения; Окно поиска файла; Простой и понятный интерфейс с поддержкой русского языка. ${NC}"
echo " Программа имеет автоматический режим для пакетной обработки файлов. EasyTag может использоваться для перекодирование тегов в другие кодировки (например, в UTF-8). Для настройки EasyTAG - смотрите справку в скрипте установки!... " 
echo " "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_easytag  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_easytag" =~ [^10] ]]
do
    :
done
if [[ $in_easytag == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_easytag == 1 ]]; then
  echo ""
  echo " Установка EasyTAG "
sudo pacman -S --noconfirm --needed easytag  # Простое приложение для просмотра и редактирования тегов в аудиофайлах ; https://wiki.gnome.org/Apps/EasyTAG ; https://archlinux.org/packages/extra/x86_64/easytag/
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ######################
### Для настройки EasyTAG выполните следующие действия: 
### Во вкладке «Настройки тегов ID3» установите следующие значения:
### в подразделе «ID3v2 tags» поставьте галочку «Записывать тег ID3v2» и в «Charset» выберите значение «UTF8»;
### в подразделе «ID3v1 tags» поставьте галочку «Записывать тег ID3v1.х» и в «Charset» выберите значение «Кириллица (Windows 1251)»;
### в подразделе «Character Set for reading ID3t tags» поставьте галочку и выберите в выпадающем меню «Кириллица (Windows 1251)».
### В левом части экрана «Дерево» выберите директорию с музыкой. Начнётся сканирование, подождите его окончание.
### Нажмите 2 кнопки: выделите все файлы и сохраните их.
### После этого останется только обновить базу музыкальных файлов в аудиопроигрывателе.
### Скрипты предназначены для запуска через терминал, для их выполнения необходимо открыть терминал Ctrl+Alt+T, перейти в каталог с музыкой:
### cd ~/Музыка
### и выполните одну из приведенных ниже команд:
### find -iname '*.mp3' -print0 | xargs -0 mid3iconv -eCP1251 --remove-v1
### (https://help.ubuntu.ru/wiki/%D0%BA%D0%BE%D0%B4%D0%B8%D1%80%D0%BE%D0%B2%D0%BA%D0%B0_%D1%82%D0%B5%D0%B3%D0%BE%D0%B2_%D0%B0%D1%83%D0%B4%D0%B8%D0%BE%D1%84%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2)
### https://translated.turbopages.org/proxy_u/en-ru.ru.110c15a9-6689c9d7-2f815890-74722d776562/https/www.tutorialspoint.com/easytag-a-tool-for-viewing-and-editing-tags-in-audio-and-video-files
############################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Kid3 - (для просмотра и редактирования тегов в аудиофайлах)?"
echo -e "${MAGENTA}:: ${BOLD}Kid3 - это бесплатная с открытым исходным кодом, программа для массового (пакетного и ручного) редактирования тегов у аудио-файлов в автоматическом режиме. Kid3 поддерживает множество аудио-форматов (MP3, Ogg, FLAC, WMA, WAV и другие). ${NC}"
echo " Домашняя страница: https://kid3.kde.org/ ; (https://archlinux.org/packages/extra/x86_64/kid3/ ; https://archlinux.org/packages/extra/x86_64/kid3-common/ ; https://archlinux.org/packages/extra/x86_64/kid3-qt/). "  
echo -e "${MAGENTA}:: ${BOLD}Описание: Редактирование тегов ID3v1.1; Отредактируйте все кадры ID3v2.3 и ID3v2.4; Преобразование между тегами ID3v1.1, ID3v2.3 и ID3v2.4; Есть возможность редактирования тегов в форматах: MP3, Ogg/Vorbis, DSF, FLAC, MPC, MP4 / AAC, MP2, Opus, Speex, TrueAudio, WavPack, WMA, WAV, AIFF и модулях трекера (MOD, S3M, IT, XM); Имеется возможность массового редактирования тегов, например: художник, альбом, год и жанр всех файлов альбома, как правило, имеют одинаковые значения и могут быть установлены вместе; Есть возможность создания: тегов из имён файлов, тегов из содержимого полей тегов, имён файлов из тегов; Переименование и создание каталогов из тегов; Создание плейлистов (списков воспроизведения); Автоматическое преобразование верхнего и нижнего регистра и замена строк; Импорт информации об альбоме из gnudb.org, TrackType.org, MusicBrainz, Discogs, Amazon и других источников; Экспорт тегов в CSV, HTML, плейлисты, Kover XML и в другие форматы; Редактирование синхронизированных текстов песен и кодов синхронизации событий, импорт и экспорт файлов LRC; Автоматизация задач с помощью QML/JavaScript, D-Bus или интерфейса командной строки. Простой и понятный интерфейс с поддержкой русского языка. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить Kid3 (KDE),   2 - Да установить Kid3 (Qt) (без KDE зависимостей),  

    3 - Да установить Kid3 (CLI) (без графического интерфейса),   0 - НЕТ - Пропустить установку: " in_kid3  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_kid3" =~ [^1230] ]]
do
    :
done
if [[ $in_kid3 == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_kid3 == 1 ]]; then
  echo ""
  echo " Установка Kid3 (KDE) "
sudo pacman -S --noconfirm --needed kid3  # Редактор тегов MP3, Ogg/Vorbis и FLAC, версия KDE ; https://kid3.kde.org/ ; https://archlinux.org/packages/extra/x86_64/kid3/
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_kid3 == 2 ]]; then
  echo ""
  echo " Установка Kid3 (Qt) (без KDE зависимостей) "
sudo pacman -S --noconfirm --needed kid3-qt  # Редактор тегов MP3, Ogg/Vorbis и FLAC, версия Qt ; https://kid3.kde.org/ ; https://archlinux.org/packages/extra/x86_64/kid3-qt/
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_kid3 == 3 ]]; then
  echo ""
  echo " Установка Kid3 (CLI) (без графического интерфейса) "
sudo pacman -S --noconfirm --needed kid3-common  # Редактор тегов MP3, Ogg/Vorbis и FLAC, CLI-версия и общие файлы ; https://kid3.kde.org/ ; https://archlinux.org/packages/extra/x86_64/kid3-common/ (без графического интерфейса, работающую из командной строки)
echo " Установка утилит (пакетов) выполнена "
fi
#############

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
  sudo pacman -S --noconfirm --needed galculator-gtk2  # Научный калькулятор на основе GTK + (версия GTK2)
  echo ""
  echo " Установка утилит (пакетов) выполнена "
elif [[ $i_galculator == 2 ]]; then
  echo ""
  echo " Установка Galculator (калькулятор) (на основе GTK+)(версия GTK3) "
  sudo pacman -S --noconfirm --needed galculator  # Научный калькулятор на основе GTK + (версия GTK3) (Обратные конфликты: galculator-gtk2)
  echo ""
  echo " Установка утилит (пакетов) выполнена "
fi
#################
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
  sudo pacman -S --noconfirm --needed gnome-calculator  # Научный калькулятор GNOME
  echo ""
  echo " Установка утилит (пакетов) выполнена "
fi
###############
clear
echo ""
echo -e "${GREEN}==> ${BOLD}Установить рекомендованные программы (пакеты)? ${NC}"
#echo -e "${BLUE}:: ${NC}Установить рекомендованные программы (пакеты)?"
#echo 'Установить рекомендованные программы?'
# Install the recommended programs
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (edk2-ovmf gnome-system-monitor, gnome-disk-utility, gnome-multi-writer, gpart, frei0r-plugins, fuseiso, clonezilla, crypto++, psensor, copyq, rsync, grsync, numlockx, modem-manager-gui, ranger, pacmanlogviewer, rofi, gsmartcontrol, testdisk, dmidecode, virt-manager, qemu, putty, w3m)."
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
# sudo pacman -S gnome-system-monitor gnome-disk-utility gnome-multi-writer gpart frei0r-plugins clonezilla crypto++ psensor copyq rsync grsync numlockx modem-manager-gui rofi gsmartcontrol ranger testdisk lsof dmidecode qemu qemu-arch-extra virt-manager edk2-ovmf w3m --noconfirm
  sudo pacman -S --noconfirm --needed edk2-ovmf  # Прошивки для виртуальных машин (x86_64, i686)
  sudo pacman -S --noconfirm --needed gnome-system-monitor  # Просмотр текущих процессов и мониторинг состояния системы
  sudo pacman -S --noconfirm --needed gnome-disk-utility  # Утилита управления дисками для GNOME
  sudo pacman -S --noconfirm --needed gnome-multi-writer  # Записать файл ISO на несколько USB-устройств одновременно
  sudo pacman -S --noconfirm --needed gpart  # Инструмент для спасения / угадывания таблицы разделов
  sudo pacman -S --noconfirm --needed frei0r-plugins  # Минималистичный плагин API для видеоэффектов
  sudo pacman -S --noconfirm --needed fuseiso  # Модуль FUSE для монтирования образов файловой системы ISO
  sudo pacman -S --noconfirm --needed clonezilla  # Раздел ncurses и программа для создания образов / клонирования дисков
  sudo pacman -S --noconfirm --needed crypto++  # Бесплатная библиотека классов C ++ криптографических схем
  sudo pacman -S --noconfirm --needed psensor  # Графический аппаратный монитор температуры для Linux
  sudo pacman -S --noconfirm --needed copyq  # Менеджер буфера обмена с возможностью поиска и редактирования истории
  sudo pacman -S --noconfirm --needed rsync  # Быстрый и универсальный инструмент для копирования удаленных и локальных файлов
  sudo pacman -S --noconfirm --needed grsync  # GTK + GUI для rsync для синхронизации папок, файлов и создания резервных копий
  sudo pacman -S --noconfirm --needed numlockx  # Включает клавишу numlock в X11
  sudo pacman -S --noconfirm --needed modem-manager-gui  # Интерфейс для демона ModemManager, способного управлять определенными функциями модема
  sudo pacman -S --noconfirm --needed pacmanlogviewer  # Проверьте файлы журнала pacman
  sudo pacman -S --noconfirm --needed rofi  # Переключатель окон, средство запуска приложений и замена dmenu
  sudo pacman -S --noconfirm --needed gsmartcontrol  # Графический пользовательский интерфейс для инструмента проверки состояния жесткого диска smartctl
  sudo pacman -S --noconfirm --needed ranger  # Простой файловый менеджер в стиле vim
  sudo pacman -S --noconfirm --needed testdisk  # Проверяет и восстанавливает разделы + PhotoRec, инструмент восстановления на основе сигнатур
  sudo pacman -S --noconfirm --needed dmidecode  # Утилиты, относящиеся к таблице интерфейса управления рабочим столом
  sudo pacman -S --noconfirm --needed qemu # Универсальный компьютерный эмулятор и виртуализатор с открытым исходным кодом
  ###yay -S qemu-arch-extra-git --noconfirm  # QEMU для зарубежных архитектур AUR
  sudo pacman -S --noconfirm --needed virt-manager  # Настольный пользовательский интерфейс для управления виртуальными машинами
  sudo pacman -S --noconfirm --needed w3m  # Текстовый веб-браузер, а также пейджер
  sudo pacman -S --noconfirm --needed putty  # Терминальный интегрированный клиент SSH/Telnet
  # sudo pacman -S --noconfirm --needed  #
  # sudo pacman -S --noconfirm --needed  # 
  # sudo pacman -S --noconfirm --needed  #
  echo ""
  echo " Установка утилит (пакетов) выполнена "
fi
#############
clear
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
  sudo pacman -S --noconfirm --needed seahorse  # Приложение GNOME для управления ключами PGP (управления паролями и ключами шифрования)
  echo ""
  echo " Установка Приложение GNOME для управления ключами PGP "
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

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Kleopatra (это графический интерфейс для GnuPG)?" 
echo -e "${CYAN}:: Предисловие! ${NC}С появлением библиотеки GCrypt-1.7.0 с поддержкой российской криптографии (ГОСТ 28147-89, ГОСТ Р 34.11-94/2012 и ГОСТ Р 34.10-2001/2012), стало возможным говорить о поддержке российского PKI в таких проектах как Kleopatra и KMail."
echo -e "${MAGENTA}:: ${BOLD}Kleopatra - это многофункциональное C++ / QT / KDE (kcmutils / kmime) графическое приложение позволяющее подписывать и шифровать файлы, а также обеспечивает создание, хранение и управление сертификатами и ключами шифрования. ${NC}"
echo -e "${MAGENTA}=> ${NC}Kleopatra разрабатывается как часть рабочего окружения KDE (KDE Applications / KDE Utilities), поддерживает управление сертификатами X.509 и OpenPGP в ключах шифрования GnuPG (GPG), основные возможности приложения реализованы на криптографической библиотеке libkleo (KDE PIM cryptographic library), использующей функционал GnuPG Made Easy (GPGME)."
echo " GPG / GnuPG (GNU Privacy Guard) - консольная утилита для шифрования информации и создания электронных цифровых подписей с помощью различных алгоритмов (RSA, DSA, AES и др...). Утилита создана как свободная альтернатива проприетарному PGP (Pretty Good Privacy) и полностью совместима с стандартом IETF OpenPGP (может взаимодействовать с PGP и другими OpenPGP-совместимыми системами). " 
echo -e "${YELLOW}:: Примечание! ${NC}Для полноценной работы Kleopatra необходимо наличие хотя бы одной пары ключей, при первом запуске приложением автоматически сканируются каталоги в которых "по умолчанию" находятся ключи GPG (~/.gnupg и пр). Поддерживается импорт сертификатов из файлов множества наиболее распространённых форматов (*.acs, *.cer, *.crt, *.pem, *.pfx и др)."
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
sudo pacman -S --noconfirm --needed kleopatra  # Диспетчер сертификатов и унифицированный графический интерфейс криптографии  
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
#########################################
clear
echo ""
echo -e "${GREEN}==> ${BOLD}Установить дополнительные сетевые утилиты, драйверы? ${NC}"
#echo -e "${BLUE}:: ${NC}Установить дополнительные сетевые утилиты, драйверы?"
#echo 'Установить дополнительные сетевые утилиты, драйверы
# Install additional network utilities, drivers
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (broadcom-wl-dkms, ebtables, ipset, iwd, linux-atm, ndisc6, networkmanager-l2tp, pptpclient, rp-pppoe, wvdial, xl2tpd, traceroute, wavemon, dsniff)."
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
# sudo pacman -S broadcom-wl-dkms ebtables ipset iwd linux-atm ndisc6 networkmanager-l2tp pptpclient rp-pppoe wvdial xl2tpd
  sudo pacman -S --noconfirm --needed broadcom-wl-dkms  # Драйвер беспроводной сети Broadcom 802.11 Linux STA
  sudo pacman -S ebtables  # Утилиты фильтрации Ethernet-моста
  #sudo pacman -S --noconfirm --needed ebtables  # Утилиты фильтрации Ethernet-моста
  #sudo pacman -S --noconfirm --needed ipset  # Инструмент администрирования наборов IP (Помечен как устаревший 5 июня 2024 г.)
  sudo pacman -S ipset  # Инструмент администрирования наборов IP (Помечен как устаревший 5 июня 2024 г.)
  sudo pacman -S --noconfirm --needed iwd  # Демон беспроводной сети Интернет
  sudo pacman -S --noconfirm --needed linux-atm  # Драйверы и инструменты для поддержки сети банкоматов под Linux
  sudo pacman -S --noconfirm --needed ndisc6  # Сборник сетевых утилит IPv6 (https://www.remlab.net/ndisc6/)
  sudo pacman -S --noconfirm --needed --noprogressbar --quiet xl2tpd  # Реализация L2TP с открытым исходным кодом, поддерживаемая Xelerance Corporation
  sudo pacman -S --noconfirm --needed --noprogressbar --quiet networkmanager-l2tp # Поддержка L2TP для NetworkManager
  sudo pacman -S --noconfirm --needed --noprogressbar --quiet pptpclient # Клиент для проприетарного протокола туннелирования точка-точка от Microsoft, PPTP
  sudo pacman -S --noconfirm --needed --noprogressbar --quiet rp-pppoe  # Протокол точка-точка Roaring Penguin через клиент Ethernet
  sudo pacman -S --noconfirm --needed wvdial # Программа номеронабирателя для подключения к Интернету
  sudo pacman -S --noconfirm --needed traceroute  # Отслеживает маршрут пакетов по IP-сети (http://traceroute.sourceforge.net/)
  sudo pacman -S --noconfirm --needed wavemon  # Приложение для мониторинга беспроводных сетевых устройств на базе ncurses (https://github.com/uoaerg/wavemon)
  sudo pacman -S --noconfirm --needed dsniff  # Сборник инструментов для сетевого аудита и тестирования на проникновение (https://www.monkey.org/~dugsong/dsniff/) Помечен как устаревший 24 октября 2023 г.
  # sudo pacman -S --noconfirm --needed   #
  echo ""
  echo " Установка утилит (пакетов) выполнена "
fi
###########
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
  sudo pacman -S --noconfirm --needed tlp tlp-rdw
# sudo pacman -S tp_smapi acpi_call --noconfirm  # Для ThinkPad (ноутбуков), или Интел платформ Sandy Bridge
# sudo pacman -S acpi_call-dkms --noconfirm  # если ядра не из официальных репозиториев
# sudo pacman -S acpi_call --noconfirm  # Модуль ядра Linux, который позволяет вызывать методы ACPI через / proc / acpi / call
# systemctl enable acpid
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
# https://archlinux.org/packages/community/x86_64/acpi_call/
# https://github.com/mkottman/acpi_call
# Хотите использовать acpi_call через графический интерфейс?
# https://github.com/marcoDallas/acpi_call_GUI_systemd
# ===============================
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
################
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
sudo pacman -S --noconfirm --needed exfat-utils fuse-exfat  # Утилиты для файловой системы exFAT; Утилиты для файловой системы exFAT
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
sudo pacman -S --noconfirm --needed openssh
echo ""
echo " SSH (клиент) установлен "
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
sudo pacman -S --noconfirm --needed nvidia nvidia-settings nvidia-utils lib32-nvidia-utils  # Драйверы NVIDIA для linux
sudo pacman -S --noconfirm --needed libvdpau lib32-libvdpau   # Библиотека Nvidia VDPAU
sudo pacman -S --noconfirm --needed opencl-nvidia opencl-headers lib32-opencl-nvidia  # Реализация OpenCL для NVIDIA; Файлы заголовков OpenCL (Open Computing Language); Реализация OpenCL для NVIDIA (32-бит)
sudo pacman -S --noconfirm --needed xf86-video-nouveau  # - свободный Nvidia (Драйвер 3D-ускорения с открытым исходным кодом) - ВОЗМОЖНО уже установлен с (X.org)
# nvidia-xconfig     # сгенерировать конфиг nvidia-xconfig (для настройки xorg.conf)
clear
echo ""
echo " Установка драйверов для видеокарт (nvidia) выполнена "
elif [[ $videocard == 2 ]]; then
  echo ""
  echo " Установка Свободных драйверов для AMD/(ATI) "
sudo pacman -S --noconfirm --needed lib32-mesa mesa-vdpau lib32-mesa-vdpau libva-mesa-driver lib32-libva-mesa-driver  # Драйверы Mesa
sudo pacman -S --noconfirm --needed vulkan-radeon lib32-vulkan-radeon  # Драйвер Radeon Vulkan mesa; Драйвер Radeon Vulkan mesa (32-разрядный)
sudo pacman -S --noconfirm --needed vulkan-icd-loader  # Загрузчик устанавливаемого клиентского драйвера (ICD) Vulkan
sudo pacman -S --noconfirm --needed lib32-vulkan-icd-loader  # Загрузчик устанавливаемого клиентского драйвера (ICD) Vulkan (32-разрядный)
sudo pacman -S --noconfirm --needed libvdpau-va-gl  # Драйвер VDPAU с бэкэндом OpenGL / VAAPI
sudo pacman -S --noconfirm --needed xf86-video-amdgpu  # Видеодрайвер X.org amdgpu - ВОЗМОЖНО уже установлен с (X.org)
sudo pacman -S --noconfirm --needed xf86-video-ati  # Видеодрайвер X.org ati - ВОЗМОЖНО уже установлен с (X.org)
# libva-xvba-driver - не найден и lib32-ati-dri - не найден в репозитории
clear
echo ""
echo " Установка драйверов для видеокарт (amd/ati) выполнена "
elif [[ $videocard == 3 ]]; then
  echo ""
  echo " Установка Свободных драйверов для Intel "
sudo pacman -S --noconfirm --needed vdpauinfo libva-utils libva libvdpau libvdpau-va-gl lib32-libvdpau
sudo pacman -S --noconfirm --needed lib32-mesa vulkan-intel libva-intel-driver lib32-libva-intel-driver lib32-vulkan-intel
sudo pacman -S --noconfirm --needed xf86-video-intel  # X.org Intel i810 / i830 / i915 / 945G / G965 + видеодрайверы - ВОЗМОЖНО уже установлен с (X.org)
sudo pacman -S --noconfirm --needed vulkan-icd-loader  # Загрузчик устанавливаемого клиентского драйвера (ICD) Vulkan
sudo pacman -S --noconfirm --needed lib32-vulkan-icd-loader  # Загрузчик устанавливаемого клиентского драйвера (ICD) Vulkan (32-разрядный)
# lib32-intel-dri - не найден
clear
echo ""
echo " Установка драйверов для видеокарт (intel) выполнена "
elif [[ $videocard == 4 ]]; then
  clear
  echo ""
  echo " Установка Проприетарных драйверов для NVIDIA "
sudo pacman -S --noconfirm --needed nvidia nvidia-settings nvidia-utils lib32-nvidia-utils  # Драйверы NVIDIA для linux
sudo pacman -S --noconfirm --needed libvdpau lib32-libvdpau  # Библиотека Nvidia VDPAU
sudo pacman -S --noconfirm --needed opencl-nvidia opencl-headers lib32-opencl-nvidia  # Реализация OpenCL для NVIDIA; Файлы заголовков OpenCL (Open Computing Language); Реализация OpenCL для NVIDIA (32-бит)
sudo pacman -S --noconfirm --needed xf86-video-nouveau  # - свободный Nvidia (Драйвер 3D-ускорения с открытым исходным кодом) - ВОЗМОЖНО уже установлен с (X.org)
# nvidia-xconfig     # сгенерировать конфиг nvidia-xconfig (для настройки xorg.conf)
echo " Установка драйверов для видеокарт (nvidia) выполнена "
echo ""
echo " Установка Свободных драйверов для AMD/(ATI) "
sudo pacman -S --noconfirm --needed mesa-vdpau lib32-mesa-vdpau libva-mesa-driver lib32-libva-mesa-driver  #lib32-mesa # Драйверы Mesa
sudo pacman -S --noconfirm --needed vulkan-radeon lib32-vulkan-radeon  # Драйвер Radeon Vulkan mesa; Драйвер Radeon Vulkan mesa (32-разрядный)
sudo pacman -S --noconfirm --needed libvdpau-va-gl  # Драйвер VDPAU с бэкэндом OpenGL / VAAPI
sudo pacman -S --noconfirm --needed xf86-video-amdgpu  # Видеодрайвер X.org amdgpu - ВОЗМОЖНО уже установлен с (X.org)
sudo pacman -S --noconfirm --needed xf86-video-ati  # Видеодрайвер X.org ati - ВОЗМОЖНО уже установлен с (X.org)
sudo pacman -S --noconfirm --needed vulkan-icd-loader  # Загрузчик устанавливаемого клиентского драйвера (ICD) Vulkan
sudo pacman -S --noconfirm --needed lib32-vulkan-icd-loader  # Загрузчик устанавливаемого клиентского драйвера (ICD) Vulkan (32-разрядный)
echo " Установка драйверов для видеокарт (amd/ati) выполнена "
echo ""
echo " Установка Свободных драйверов для Intel "
sudo pacman -S --noconfirm --needed vdpauinfo libva-utils libva libvdpau libvdpau-va-gl lib32-libvdpau
sudo pacman -S --noconfirm --needed vulkan-intel libva-intel-driver lib32-libva-intel-driver lib32-vulkan-intel  #lib32-mesa
sudo pacman -S --noconfirm --needed xf86-video-intel  # X.org Intel i810 / i830 / i915 / 945G / G965 + видеодрайверы - ВОЗМОЖНО уже установлен с (X.org)
echo " Установка драйверов для видеокарт (intel) выполнена "
echo ""
echo " Установка дополнительных инструментов и драйверов "
sudo pacman -S --noconfirm --needed lib32-mesa  # Реализация спецификации OpenGL с открытым исходным кодом (32-разрядная версия)
sudo pacman -S --noconfirm --needed lib32-libva-vdpau-driver  # Серверная часть VDPAU для VA API (32-разрядная версия) https://freedesktop.org/wiki/Software/vaapi/
sudo pacman -S --noconfirm --needed lib32-mesa-demos  # Демонстрации и инструменты Mesa (32-разрядная версия)
sudo pacman -S --noconfirm --needed libva-vdpau-driver  # Серверная часть VDPAU для VA API   https://freedesktop.org/wiki/Software/vaapi/
sudo pacman -S --noconfirm --needed mesa-demos  # Демоверсии Mesa и инструменты, включая glxinfo + glxgears
sudo pacman -S --noconfirm --needed xf86-input-elographics  # Драйвер ввода X.org Elographics TouchScreen
sudo pacman -S --noconfirm --needed xorg-twm  # Вкладка Window Manager для системы X Window
### ------------ Эти драйвера отсутствуют, Но! Есть замена !!! В AUR ----------- ####
###sudo pacman -S ipw2100-fw --noconfirm  # Микропрограмма драйверов Intel Centrino для IPW2100
##sudo pacman -S ipw2200-fw --noconfirm  # Прошивка для Intel PRO / Wireless 2200BG
## Package Details: ipw2x00-firmware 1.3-1
## https://aur.archlinux.org/ipw2x00-firmware.git 
## Firmware for ipw2100 and ipw2200 drivers
## Прошивка драйверов ipw2100 и ipw2200
## https://aur.archlinux.org/packages/ipw2x00-firmware
# yay -S ipw2x00-firmware --noconfirm  # Прошивка для драйверов ipw2100 и ipw2200
# git clone https://aur.archlinux.org/ipw2x00-firmware.git   # Прошивка для драйверов ipw2100 и ipw2200
# cd ipw2x00-firmware
##makepkg -fsri
## makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
## makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
## rm -rf ipw2x00-firmware 
# rm -Rf ipw2x00-firmware
# -----------------------------------------#
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

clear
echo ""
echo -e "${GREEN}==> ${NC}Ставим Драйвера принтера (Поддержка печати) CUPS, HP"
#echo -e "${BLUE}:: ${NC}Ставим Драйвера принтера (Поддержка печати) CUPS, HP"
#echo 'Ставим Драйвера принтера (Поддержка печати) CUPS, HP'
# Putting the printer Drivers (Print support) CUPS, HP
echo -e "${MAGENTA}:: ${BOLD}CUPS- это стандартная система печати с открытым исходным кодом, разработанная Apple Inc. для MacOS® и других UNIX® - подобных операционных систем. Драйверы принтеров CUPS состоят из одного или нескольких фильтров, упакованных в формате PPD (PostScript Printer Description). ${NC}"
echo -e "${CYAN}:: ${NC}Все принтеры в CUPS (даже не поддерживающие PostScript) должны иметь файл PPD с описанием принтеров, специфических команд и фильтров. Фильтры, занимающие центральное место в CUPS, преобразуют задания печати в формат, понятный принтеру (PDF, HP-PCL, растровый формат и т. п.), а также передают команды для выполнения таких операций, как выбор страницы и сортировка."
echo " Файлы PPD являются текстовыми и хранятся в каталоге /usr/share/cups/model. Файлы PPD установленных принтеров хранятся в каталоге /etc/cups/ppd. "
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
sudo pacman -S --noconfirm --needed cups cups-filters cups-pdf cups-pk-helper  # Система печати CUPS - пакет демона; Фильтры OpenPrinting CUPS; PDF-принтер для чашек; Помощник, который заставляет system-config-printer использовать PolicyKit
sudo pacman -S --noconfirm --needed system-config-printer ghostscript  # Инструмент настройки принтера CUPS и апплет состояния; Интерпретатор для языка PostScript ; https://github.com/OpenPrinting/system-config-printer ; https://archlinux.org/packages/extra/x86_64/system-config-printer
sudo pacman -S --noconfirm --needed libcups simple-scan  # Система печати CUPS - клиентские библиотеки и заголовки; Простая утилита сканирования
sudo pacman -S --noconfirm --needed gsfonts gutenprint  # (URW) ++ Базовый набор шрифтов [Уровень 2]; Драйверы принтера высшего качества для систем POSIX ;  # python-imaging ???
# Драйверы для HP DeskJet, OfficeJet, Photosmart, Business Inkjet и некоторых LaserJet
sudo pacman -S --noconfirm --needed splix  # Драйверы CUPS для принтеров SPL (Samsung Printer Language)
sudo pacman -S --noconfirm --needed hplip  # Драйверы для HP DeskJet, OfficeJet, Photosmart, Business Inkjet и некоторых LaserJet
# Рабочая группа Foomatic в OpenPrinting в Linux Foundation предоставляет PPD для многих драйверов принтеров
sudo pacman -S --noconfirm --needed foomatic-db  # Foomatic - собранная информация о принтерах, драйверах и параметрах драйверов в файлах XML, используемая foomatic-db-engine для создания файлов PPD.
sudo pacman -S --noconfirm --needed foomatic-db-engine  # Foomatic - движок базы данных Foomatic генерирует файлы PPD из данных в базе данных Foomatic XML. Он также содержит сценарии для непосредственного создания очередей печати и обработки заданий.
sudo pacman -S --noconfirm --needed foomatic-db-ppds  # Foomatic - PPD от производителей принтеров
sudo pacman -S --noconfirm --needed foomatic-db-nonfree  # Foomatic - расширение базы данных, состоящее из предоставленных производителем файлов PPD, выпущенных по несвободным лицензиям
sudo pacman -S --noconfirm --needed foomatic-db-nonfree-ppds  # Foomatic - бесплатные PPD от производителей принтеров
sudo pacman -S --noconfirm --needed foomatic-db-gutenprint-ppds  # Упрощенные готовые файлы PPD
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
sudo systemctl start cups.service
#sudo systemctl start org.cups.cupsd.service
#sudo systemctl start cups-browsed.service
#sudo systemctl start cupsd.service
echo " Добавляем в автозапуск Драйвера принтера CUPS (cupsd.service) "
sudo systemctl enable cups.service
#sudo systemctl enable org.cups.cupsd.service
#sudo systemctl enable cups-browsed.service
# Проверяем - переходим на страницу http://localhost:631:
# вики уже поправили,смотрите
# https://wiki.archlinux.org/index.php/CUPS#Socket_activation
#echo ""
#echo " Проверить статус CUPS (cupsd.service) "
#sudo systemctl status cups  # Проверить статус...
###############
# https://archlinux.org.ru/forum/topic/20355/
# И проверьте pacnew, может еще конфиги подправить надо
# find /etc -regextype posix-extended -regex ".+\.pacnew" 2> /dev/null
#/etc/locale.gen.pacnew
#/etc/shadow.pacnew
#/etc/pacman.d/mirrorlist.pacnew
#/etc/sudoers.pacnew
#/etc/profile.pacnew
# а там точно надо что-то править?
# Смотреть надо что изменилось, скорее всего эти и не надо, хотя /etc/profile я бы сверил
# https://wiki.archlinux.org/index.php/Pacman/Pacnew_and_Pacsave
# Файлы .pacnew и .pacsave лучше всего обрабатывать вручную сразу после обновлений или удаления пакетов. 
# Наличие в системе неправильных файлов настроек может привести к ошибкам в работе программ или даже к полной невозможности их запуска.
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
sudo pacman -S --noconfirm --needed gvfs-mtp  # Реализация виртуальной файловой системы для GIO (бэкэнд MTP; Android, медиаплеер)
echo " Установка поддержки устройств на (базе) Android завершена "
elif [[ $i_telephone == 2 ]]; then
  echo ""
  echo " Установка утилит (пакетов) для поддержки устройств Iphone "
sudo pacman -S --noconfirm --needed gvfs-afc  # Реализация виртуальной файловой системы для GIO (бэкэнд AFC; мобильные устройства Apple)
echo " Установка поддержки устройств Iphone завершена "
elif [[ $i_telephone == 3 ]]; then
  echo ""
  echo " Установка утилит (пакетов) для поддержки устройств на (базе) Android и Iphone "
sudo pacman -S --noconfirm --needed gvfs-afc gvfs-mtp
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
sudo pacman -S --noconfirm --needed timeshift  # Утилита восстановления системы для Linux. https://archlinux.org/packages/extra/x86_64/timeshift/
echo ""
echo " Установка Timeshift выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
sleep 02

clear
echo -e "${MAGENTA}
  <<< Установка Редактора меню программ (пакетов) в Archlinux >>> ${NC}"
# Installing the program (package) menu Editor in Archlinux

echo ""
echo -e "${GREEN}==> ${NC}Установить редактор главного меню программ (пакетов)?"
#echo -e "${BLUE}:: ${NC}Установить редактор меню программ (пакетов)?"
#echo 'Установить редактор меню программ (пакетов)?'
# Install the program (package) menu editor?
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующий вариант: ${NC}"
echo -e "${MAGENTA}:: ${NC}Alacarte - (https://www.archlinux.org/packages/extra/any/alacarte/) простой в использовании редактор меню, написанный на основе технологии GNOME, позволяющий добавлять новые и изменять существующие подменю и их элементы."
echo " Он создан в соответствии со спецификацией freedesktop.org и должен работать в любой графической среде, поддерживающей эту спецификацию. (https://gitlab.gnome.org/GNOME/alacarte) "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить редактора меню - Alacarte,

    0 - НЕТ - Пропустить установку: " in_menu  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_menu" =~ [^10] ]]
do
    :
done
if [[ $in_menu == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_menu == 1 ]]; then
  echo ""
  echo " Установка Редактора меню - Alacarte "
sudo pacman -S --noconfirm --needed alacarte  # Редактор меню для gnome
echo ""
echo " Установка утилит (пакетов) выполнена "
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
### systemctl enable NetworkManager
### systemctl enable bluetooth
### systemctl enable cups.service
### systemctl enable sshd
### systemctl enable avahi-daemon
### systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
### systemctl enable reflector.timer
### systemctl enable fstrim.timer
### systemctl enable libvirtd
### systemctl enable firewalld
### systemctl enable acpid