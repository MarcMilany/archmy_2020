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
echo " Чтобы выполнить тест скорости поиска, выберите веб-сайт, который не посещался с момента запуска dnsmasq "
sudo drill archlinux.org | grep "Query time"  # Тест dnsmasq
  echo " Выполним опрос DNS-сервера: '1.1.1.1' (@cервер) с запросом archlinux.org (доменное имя интернет-ресурса) "
sudo dig @1.1.1.1 archlinux.org  # для опроса DNS-серверов
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


reflector -a 12 -l 30 -f 30 -p https --sort rate --save /etc/pacman.d/mirrorlist
pacman-key --init
pacman-key --populate




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
#sudo systemctl start cronie.service
# systemctl status cronie.service
echo ""
echo " Планировщик заданий CRON (cronie) установлен и добавлен в автозагрузку "
fi
# ---------------------------------------
# https://www.linuxboost.com/how-to-set-up-a-cron-job-on-arch-linux/
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
############ Справка ####################
# Настройка синхронизации времени в домене с помощью групповых политик состоит из двух шагов:
# 1) Создание GPO для контроллера домена с ролью PDC
# 2) Создание GPO для клиентов (опционально)
# https://zen.yandex.ru/media/winitpro.ru/ntp-sinhronizaciia-vremeni-v-domene-s-pomosciu-gruppovyh-politik-5b5042923e546700a8ccf633?utm_source=serp
# (https://www.8host.com/blog/ustanovka-i-nastrojka-openntpd-v-freebsd-10-2/)
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
echo -e "${CYAN}:: ${BOLD}Ufw расшифровывается как Uncomplicated Firewall и представляет собой программу для управления межсетевым экраном netfilter. Настройка брандмауэра на Arch Linux — это важный шаг для защиты вашей системы от несанкционированного доступа и киберугроз. ${NC}"
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
############ Справка ####################
### Установка и настройка firewalld в Arch Linux:
# https://www.linuxboost.com/how-to-configure-firewall-on-arch-linux/
# https://www.youtube.com/watch?v=K3IqPgzw4YA
####################################
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
############ Справка ####################
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
sudo ufw status  # проверить статус работы UFW
#sudo ufw status --verbose  #  # -v, --verbose  -быть вербальным
sudo ufw version  # проверить версию брандмауэра ; --version - вывести версию брандмауэра
sleep 01
fi
################ Справка #####################
# Если нужно выключить, то используйте команду: sudo ufw disable
# Чтобы перезагрузить брандмауэр Linux UFW: sudo ufw reload
# Если вы хотите сбросить ufw: sudo ufw reset  -- команда в вернет брандмауэр ufw к настройкам по умолчанию 
# Проверка разрешений приложения через брандмауэр:  sudo ufw app list
# Синтаксис ufw - https://losst.pro/nastrojka-ufw-ubuntu
# Для выполнения действий с утилитой доступны такие команды:
# enable - включить фаерволл и добавить его в автозагрузку;
# disable - отключить фаерволл и удалить его из автозагрузки;
# reload - перезагрузить файервол;
# default - задать политику по умолчанию, доступно allow, deny и reject, а также три вида трафика - incoming, outgoing или routed;
# logging - включить журналирование или изменить уровень подробности;
# reset - сбросить все настройки до состояния по умолчанию;
# status - посмотреть состояние фаервола;
# show - посмотреть один из отчётов о работе;
# allow - добавить разрешающее правило;
# deny - добавить запрещающее правило;
# reject - добавить отбрасывающее правило;
# limit - добавить лимитирующее правило;
# delete - удалить правило;
# insert - вставить правило.
#############################################

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
# sudo systemctl enable ufw.service  # После установки включите
#echo " Проверить - включен сервис UFW (сетевой экран) "
#sudo systemctl is-enabled ufw   # – проверить, включен ли и активен ли сервис UFW
#echo " Проверить - активен сервис UFW (сетевой экран) "
#sudo systemctl is-active ufw
#sudo systemctl start ufw   # Если служба UFW не запускается автоматически после установки ; Ufw также должен быть включен для автоматического запуска между перезагрузками системы.
# sudo systemctl start ufw.service  # запустите службу UFW
# echo " Проверка разрешений приложения через брандмауэр UFW (сетевой экран) "
#sudo ufw app list
echo " UFW (сетевой экран) успешно добавлен в автозагрузку "
sleep 01
fi
############ Справка ####################
### Чтобы остановить службу UFW, просто выполните команду:
# sudo systemctl stop ufw  # остановить службу UFW
#######################################################

clear
echo ""
echo -e "${GREEN}==> ${NC}Задать UFW политики по умолчанию для запрета входящего трафика и разрешения исходящего трафика?"
#echo -e "${BLUE}:: ${NC}Задать UFW политики по умолчанию для запрета входящего трафика и разрешения исходящего трафика?"
#echo 'Задать UFW политики по умолчанию для запрета входящего трафика и разрешения исходящего трафика?'
# Set the default UFW (firewall) policy to prohibit incoming traffic and allow outgoing traffic?
echo -e "${CYAN}=> ${BOLD}Используя UFW, вы можете создавать правила брандмауэра (или политики) для разрешения или запрета определенной службы. С помощью этих политик вы указываете UFW, какие порты, службы, IP-адреса и интерфейсы должны быть разрешены или запрещены. ${NC}"
echo -e "${MAGENTA}=> ${NC}Существуют политики по умолчанию, которые поставляются с ufw. Политика по умолчанию отбрасывает все входящие соединения и разрешает все исходящие соединения. "
echo " ВАЖНО: Если вы настраиваете ufw на удаленном сервере, убедитесь, что вы разрешили порт или службу ssh перед включением брандмауэра ufw. Политика входящих соединений по умолчанию будет запрещать все входящие соединения. Поэтому если вы не настроили правила для разрешения SSH, вы будете заблокированы в удаленной системе и не сможете войти в нее. В качестве альтернативы можно использовать команду ufw allow, чтобы установить политики по умолчанию для входящих и исходящих команд. "
echo " Политики по умолчанию определяются в файле /etc/default/ufw. Получение помощи: Если вы забыли синтаксис или вам нужна справка по определенной функции ufw, эти две команды - (ufw --help) и (man ufw). "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again.
echo ""
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да - Установка правил по умолчанию,     0 - НЕТ - Пропустить установку: " i_default_ufw  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_default_ufw" =~ [^10] ]]
do
    :
done
if [[ $i_default_ufw == 0 ]]; then
echo ""
echo " Установка правил по умолчанию для UFW (сетевой экран) пропущена "
elif [[ $i_default_ufw == 1 ]]; then
  echo ""
  echo " Установка правил по умолчанию для UFW (сетевой экран) "
  echo " Запрет входящего трафика (по умолчанию) "
  sudo ufw default deny incoming   # Запрет входящего трафика (отрицать)
  echo " Разрешения исходящего трафика (по умолчанию) "
  sudo ufw default allow outgoing   # Разрешения исходящего трафика (позволять)
echo ""
echo " Установка правил по умолчанию для UFW (сетевой экран) выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Запустить Логгирование UFW (журналы работы брандмауэра)?"
#echo -e "${BLUE}:: ${NC}Запустить Логгирование UFW (журналы работы брандмауэра)?"
#echo 'Запустить Логгирование UFW (журналы работы брандмауэра)?'
# Should I start Logging UFW (firewall logs)?
echo -e "${CYAN}=> ${BOLD}Чтобы отлаживать работу UFW, могут понадобится журналы работы брандмауэра. Для включения журналирования используется команда: logging . Лог сохраняется в папке /var/log/ufw. ${NC}"
echo -e "${MAGENTA}=> ${NC}По умолчанию журналы UFW хранятся в /var/log/ufw.log. Вы можете контролировать файл журнала с помощью команды: tail . Пример: sudo tail -f /var/log/ufw.log . "
echo " ВАЖНО: Командой (logging) можно изменить уровень логгирования: low - минимальный, только заблокированные пакеты; medium - средний, заблокированные и разрешённые пакеты; high - высокий. По умолчанию заложил в сценарий скрипта medium - средний, заблокированные и разрешённые пакеты. Пример: sudo ufw logging medium . "
echo " Для firewalld ведение журнала включено по умолчанию. Журналы Firewalld хранятся в системном журнале, доступ к которому можно получить с помощью команды: journalctl . Пример: sudo journalctl -u firewalld.service -f . "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again.
echo ""
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да - Установка правил по умолчанию,     0 - НЕТ - Пропустить установку: " i_journal  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_journal" =~ [^10] ]]
do
    :
done
if [[ $i_journal == 0 ]]; then
echo ""
echo " Запуск Логгирование UFW (журналы работы брандмауэра) пропущена "
elif [[ $i_journal == 1 ]]; then
  echo ""
  echo " Запуск Логгирование UFW (журналы работы брандмауэра) "
  sudo ufw logging on   # Запуск Логгирование UFW
  echo " Запуск Логгирование UFW (medium - средний, заблокированные и разрешённые пакеты) "
  sudo ufw logging medium   # Логгирование UFW (medium - средний, заблокированные и разрешённые пакеты)
# sudo journalctl -u firewalld.service -f   # Мониторинг журналов - доступ к системному журналу
echo ""
echo " Запуск Логгирование UFW (журналы работы брандмауэра) выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Добавить разрешающее правило службы SSH и портов 22; 80 для HTTP в UFW?"
# Add a permissive SSH service rule and ports 22; 80 for HTTP in UFW?
echo -e "${MAGENTA}:: ${BOLD}Обычно при предоставлении удаленного доступа к Linux серверам вам предоставляется именно SSH (Secure Shell) доступ. ${NC}"
echo -e "${CYAN}:: ${NC}SSH - это Первоклассный инструмент подключения для удаленного входа по протоколу SSH."
echo " Это великий инструмент управления серверов, с помощью него можно всё что угодно реализовать, веб-платформу, фтп-сервер, VPN или любые другие сервера на базе данной ОС. "
echo -e "${CYAN}=> ${BOLD}SSH-демон по молчанию прослушивает порт 22. UFW знает об именах распространённых служб (ssh, sftp, http, https), поэтому вы можете использовать их вместо номера порта. Если ваш SSH-демон использует другой порт, вам необходимо указать его в явном виде, например: sudo ufw allow 2222 . ${NC}"
echo -e "${MAGENTA}=> ${NC}Добавление правил: В скрипте прописано - профиль OpenSSH, который разрешит все входящие SSH-соединения на стандартном порту SSH (22). Она разрешает любой доступ к порту tcp 22. Поддерживаются оба протокола TCP и UDP. Также прописано разрешение порта (80) для HTTP (веб-сервер). Если вы используете пользовательский SSH-порт (например, порт 2222), вам необходимо открыть этот порт на брандмауэре UFW (правило прописано в скрипте, но закомментировано # ). Блокировка и лимит (Ограничение SSH-соединения) по использованию всех подключения SSH (правило прописано в скрипте, но закомментировано # ). Иногда это может помочь в предотвращении атак DOS. "
echo " ВАЖНО: Добавление политики для определенных IP-адресов, подсетей и портов уже прописано в данном скрипте установки, но Закомментировано # . Список портов - (ssh; ssh/tcp; 22; 22/tcp; 2222/tcp; ftp; http; 80; 80/tcp; https; 443/tcp; 25; 25/tcp; 143; 143/tcp; 993; 993/tcp; 110; 995; 587/tcp; 465/tcp; 5433). Раскомментировано - Список портов (ssh; 22; 22/tcp; 80/tcp). "
echo " Также Вы сможете просмотреть текущие правила и разрешения для брандмауэра UFW. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again.
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да - Разрешить службу SSH и портов 22; 80 для HTTP,     0 - НЕТ - Пропустить установку: " i_ssh_ufw  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_ssh_ufw" =~ [^10] ]]
do
    :
done
if [[ $i_ssh_ufw == 0 ]]; then
echo ""
echo " Добавления разрешающего правила службы SSH и портов 22; 80 для HTTP в UFW пропущена "
elif [[ $i_ssh_ufw == 1 ]]; then
  echo ""
  echo " Добавления разрешающего правила службы SSH и портов 22; 80 для HTTP в UFW (сетевой экран) "
  echo " Разрешить службу SSH (по умолчанию) "
  sudo ufw allow ssh   # Разрешить входящий трафик (SSH)
# sudo ufw limit ssh  # ограничить соединения ssh до 6 в течение 30 секунд
# sudo ufw allow ssh/tcp  
# sudo ufw deny ssh/tcp  # Заблокировать все подключения SSH
  echo " Разрешить определенный порт, например 22; 80 для HTTP (по умолчанию) "
  sudo ufw allow 22  # SSH (Secure Shell): Порт 22
  sudo ufw allow 22/tcp  # (OpenSSH)
# sudo ufw allow 2222/tcp  # пользовательский SSH-порт (например, порт 2222)  
# sudo ufw allow ftp
# sudo ufw allow http  # разрешить все входящие соединения HTTP (порт 80)
  sudo ufw allow 53/tcp
  sudo ufw allow 43/tcp
# sudo ufw allow 80
sudo ufw allow 80/tcp  # Разрешить порт 80 для HTTP (веб-сервер)
# sudo ufw delete allow 80  # не хотите разрешать HTTP-трафик
# sudo ufw allow https  # разрешить все входящие подключения HTTPS (порт 443)
# sudo ufw allow 443/tcp  # HTTPS (защищенный веб-сервер): порт 443 - 80,443/tcp (Apache Full)
# sudo ufw allow proto tcp from any to any port 80,443  # разрешить входящие соединения HTTP и HTTPS 
# sudo ufw allow 25  # разрешить серверу отвечать на все входящие SMTP-соединения ; SMTP (почтовый сервер)
# sudo ufw allow 25/tcp  # разрешить трафик SMTP для отправки электронной почты
# sudo ufw limit 25/tcp  # Ограничение скорости : чтобы снизить вероятность атак методом подбора, особенно на портах SMTP
# sudo ufw deny out 25  # заблокировать исходящую почту SMTP
# sudo ufw allow 143  # разрешить входящие IMAP-соединения ; IMAP (получение почты)
# sudo ufw allow 143/tcp  
# sudo ufw allow 993  # разрешить входящие IMAPS
# sudo ufw allow 993/tcp
# sudo ufw allow 110  # разрешить входящие POP3-соединения ; POP3 (получение почты)
# sudo ufw allow 995  # разрешить входящие POP3S-соединения
# sudo ufw allow 587/tcp  # рекомендуется для отправки по TLS
# sudo ufw limit 587/tcp  # Ограничение скорости : чтобы снизить вероятность атак методом подбора, особенно на портах SMTP
# sudo ufw allow 465/tcp  # для SMTPS (SMTP через SSL) 
# sudo ufw allow 5433  # подключиться к PostgreSQL, работающему на порту 5433
# sudo ufw deny 5433  # для отклонения входящих соединений (трафика) на порту 5433
# sudo ufw allow 
# sudo ufw allow 
  echo " Просмотреть текущие правила для брандмауэра UFW (сетевой экран) "
  sudo ufw status verbose
  echo " Проверка разрешений приложения через брандмауэр UFW (сетевой экран) "
  sudo ufw status numbered
  sudo ufw app list
  sudo ufw reload 
echo ""
echo " Установка правил по умолчанию для UFW (сетевой экран) выполнена "
fi
sleep 03
########## Справка ##############
# Настройка служб и портов в Linux: При настройке брандмауэра важно учитывать, какие службы и порты вам необходимо разрешить. Вот некоторые распространенные службы и соответствующие им порты:
# SSH (Secure Shell): Порт 22
# HTTP (веб-сервер): порт 80
# HTTPS (защищенный веб-сервер): порт 443
# FTP (протокол передачи файлов): порты 20 и 21
# SMTP (почтовый сервер): порт 25
# IMAP (получение почты): порт 143
# POP3 (получение почты): порт 110
# SMTP (порт 25/587/465) : разрешить трафик SMTP для отправки электронной почты
# Более полный список служб и портов можно найти в Реестре имен служб и номеров портов транспортных протоколов IANA (https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml) 
##################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Firewalld - (Межсетевой экран)?"
echo -e "${MAGENTA}:: ${BOLD}Firewalld (Межсетевой экран) - это динамически управляемый брандмауэр с поддержкой зон сети/брандмауэра, которые определяют уровень доверия сетевых подключений или интерфейсов. Он поддерживает настройки брандмауэра IPv4, IPv6, мосты Ethernet и наборы IP. Существует разделение параметров конфигурации времени выполнения и постоянной конфигурации. Он также предоставляет интерфейс для служб или приложений для непосредственного добавления правил брандмауэра. Преимущества использования firewalld: Изменения можно вносить немедленно в среде выполнения. Перезапуск службы или демона не требуется. ${NC}" 
echo -e "${MAGENTA}:: ${BOLD}Описание: Интерфейс firewalld D-Bus позволяет службам, приложениям и пользователям легко адаптировать настройки брандмауэра. Интерфейс является полным и используется для инструментов настройки брандмауэра firewall-cmd, firewall-config и firewall-applet. Разделение конфигурации среды выполнения и постоянной конфигурации позволяет выполнять оценку и тесты во время выполнения. Конфигурация среды выполнения действительна только до следующей перезагрузки и перезапуска службы или до перезагрузки системы. Затем постоянная конфигурация будет загружена снова. С помощью среды выполнения можно использовать среду выполнения для настроек, которые должны быть активны только в течение ограниченного периода времени. Если конфигурация среды выполнения использовалась для оценки, и она является полной и рабочей, то можно сохранить эту конфигурацию в постоянной среде. Функции: Полный API D-Bus; Поддержка IPv4, IPv6, моста и ipset; Поддержка IPv4 и IPv6 NAT. Зоны брандмауэра: Предопределенный список зон, служб и типов ICMP. Простой сервис, порт, протокол, исходный порт, маскировка, переадресация портов, фильтр ICMP, расширенные правила, интерфейс и обработка исходного адреса в зонах. ${NC}"
echo " Простое определение сервиса с портами, протоколами, исходными портами, модулями (помощниками netfilter) и обработкой адресов назначения. Богатый язык для более гибких и сложных правил в зонах. Правила брандмауэра с ограничением по времени в зонах. Простой журнал отклоненных пакетов. Прямой интерфейс. " 
echo "Блокировка: белый список приложений, которые могут изменять брандмауэр. Автоматическая загрузка модулей ядра Linux. Интеграция с Puppet. Клиенты командной строки для онлайн и офлайн настройки. Графический инструмент настройки с использованием gtk3. Апплет с использованием Qt5. Кто им пользуется? Firewalld используется в следующих дистрибутивах Linux в качестве инструмента управления брандмауэром по умолчанию: RHEL 7 и новее; CentOS 7 и новее; Fedora 18 и новее; SUSE 15 и новее; OpenSUSE 15 и новее; Доступно для нескольких других дистрибутивов. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_firewalld  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_firewalld" =~ [^10] ]]
do
    :
done
if [[ $in_firewalld == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_firewalld == 1 ]]; then
  echo ""
  echo " Установка Firewalld - (Межсетевой экран) "
sudo pacman -S --noconfirm --needed firewalld # Демон брандмауэра с интерфейсом D-Bus ; https://firewalld.org/ ; https://archlinux.org/packages/extra/any/firewalld/ ; https://github.com/firewalld/firewalld/issues
echo " Установить зону по умолчанию как «публичную» и включить брандмауэр "
sudo firewall-cmd --set-default-zone=public
echo " Включить и запустить службу firewalld "
sudo systemctl enable firewalld.service
sudo systemctl start firewalld.service
echo " Проверить состояние firewalld и просмотреть текущие правила "
systemctl status firewalld 
sudo firewall-cmd --list-all
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ######################
# Установка и настройка firewalld в Arch Linux: 
# https://xakep.ru/2017/02/15/firewalld/
# https://www.linuxboost.com/how-to-configure-firewall-on-arch-linux/
# Справка: firewall-cmd --help
# Параметры firewall-cmd Смотрим статус:
# systemctl status firewalld 
# firewall-cmd --state
# Чтобы установить зону по умолчанию как «публичную» и включить брандмауэр, выполните:
# sudo firewall-cmd --set-default-zone=public
# Чтобы открыть службу или порт в firewalld, используйте параметры --add-serviceили --add-port. Например, чтобы разрешить SSH, выполните:
# sudo firewall-cmd --zone=public --add-service=ssh --permanent
# Или, чтобы разрешить определенный порт, например порт 80 для HTTP, выполните:
# sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
# firewall-cmd --permanent --add-port=22/tcp
# Разрешим подключение к HTTP:
# firewall-cmd --add-service=http
# Для удаления порта из правил используется параметр --remove-port:
# firewall-cmd --remove-port=22/tcp
# Не забудьте перезагрузить брандмауэр после внесения изменений:
# sudo firewall-cmd --reload
# Чтобы проверить состояние firewalld и просмотреть текущие правила, используйте следующую команду:
# sudo firewall-cmd --list-all
#############################################

clear
echo -e "${MAGENTA}
  <<< Установка первоначально необходимого софта (пакетов) для Archlinux >>> ${NC}"
# Installation of initially required software (packages) for Archlinux.
echo -e "${YELLOW}==> Примечание: ${NC}Сейчас Вы можете установить Arch Wiki: пакет arch-wiki-docs и пакет arch-wiki-lite."

echo ""
echo -e "${GREEN}==> ${NC}Установим поддержку Arch Wiki?"
#echo -e "${BLUE}:: ${NC}Установим поддержку Arch Wiki?"
#echo 'Установим поддержку Arch Wiki?'
# Install ArchWiki support?
echo -e "${CYAN}=> ${BOLD}Установка поддержки Arch Wiki - будет очень актуальна, если Вы начинающий пользователь Arch'a и не только начинающий!!! ${NC}"
echo -e "${MAGENTA}=> ${NC}Этот проект делает Arch Wiki доступным и переносимым. Существующий arch-wiki-docs пакет представляет собой простой неорганизованный дамп html-файлов, хотя и arch-wiki-lite идет на несколько шагов дальше: чрезвычайно быстрая поисковая система (с поддержкой регулярных выражений и ранжированием), просмотрщик консоли (с подсветкой ссылок и совпадений регулярных выражений), фильтрация языков (со сводкой языков по количеству страниц) - 1/9 размера. Пакет arch-wiki-lite разработан для того, чтобы обеспечить максимально удобный интерфейс для бедных людей, не имеющих доступа к Интернету или возможности запустить графический веб-браузер. "
echo " Результаты сортируются по количеству раз, когда поисковый запрос встречался на странице. Если вам действительно нравится локальный поиск, но вы хотите просматривать страницы вики в своем браузере, есть команда wiki-search-html. За исключением того, как отображается страница, она работает точно так же. Содержимое arch-wiki-lite идентично arch-wiki-docs. "
echo " По умолчанию вики-поиск фильтрует страницы на английском языке, но все остальные языки тоже есть: wiki-search --lang "
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_wiki  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_wiki" =~ [^10] ]]
do
    :
done
if [[ $i_wiki == 0 ]]; then
echo ""
echo " Установка поддержки Arch Wiki пропущена "
elif [[ $i_wiki == 1 ]]; then
  echo ""
  echo " Установка пакетов поддержки Arch Wiki "
# sudo pacman -S --noconfirm --needed arch-wiki-docs arch-wiki-lite
  sudo pacman -S --noconfirm --needed arch-wiki-docs  # Страницы Arch Wiki оптимизированы для просмотра в автономном режиме ; https://github.com/lahwaacz/arch-wiki-docs ; https://archlinux.org/packages/extra/any/arch-wiki-docs/
  sudo pacman -S --noconfirm --needed arch-wiki-lite  # Arch Wiki без HTML. 1/9 размера, легко ищется и просматривается на консоли ; https://gitlab.archlinux.org/grawlinson/arch-wiki-lite ; https://archlinux.org/packages/extra/any/arch-wiki-lite/
echo ""
echo " Установка пакетов поддержки Arch Wiki выполнена "
fi
############ Справка ####################
# Вот пример запуска:
#$ wiki-search suspend
# Выберите запись, и она появится в less или $PAGER. Если у вас не установлен dialog, то он вернется к старому интерфейсу консоли:
# $ wiki-search suspend
# По умолчанию вики-поиск фильтрует страницы на английском языке, но все остальные языки тоже есть:
# wiki-search --lang
# $ export wiki_lang="it"
# $ wiki-search xorg
############################# 

clear
echo -e "${MAGENTA}
  <<< Установка первоначально необходимого софта (пакетов) для Archlinux >>> ${NC}"
# Installation of initially required software (packages) for Archlinux.
echo -e "${YELLOW}==> Примечание: ${NC}Сейчас Вы можете установить софт: поддержки Bluetooth, поддержки звука, архиваторы, утилиты для вывода информации о системе и т.д., или пропустите установку."

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
############ Справка ####################
# Bluetooth (Русский)
# https://wiki.archlinux.org/index.php/Bluetooth_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
################################

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
#  echo ""
#  echo " Установка пакетов поддержки Sound support PipeWire (pipewire-alsa, pipewire-jack...) "
  ################ PipeWire #####################
### ошибка: обнаружен неразрешимый конфликт пакетов
### ошибка: не удалось подготовить транзакцию (конфликтующие зависимости)
### :: pipewire-alsa-1:1.2.1-1 and pulseaudio-alsa-1:1.2.12-2 are in conflict
###sudo pacman -S --noconfirm --needed pipewire-alsa  # Аудио/видео маршрутизатор и процессор с малой задержкой — конфигурация ALSA ; https://pipewire.org/ ; https://archlinux.org/packages/extra/x86_64/pipewire-alsa/
###sudo pacman -S --noconfirm --needed pipewire-audio  # Аудио/видео маршрутизатор и процессор с малой задержкой - Поддержка аудио ; https://pipewire.org/ ; https://archlinux.org/packages/extra/x86_64/pipewire-audio/
###sudo pacman -S --noconfirm --needed pipewire-jack  # Аудио/видео маршрутизатор и процессор с малой задержкой - замена JACK ; https://pipewire.org/ ; https://archlinux.org/packages/extra/x86_64/pipewire-jack/
#sudo pacman -S --noconfirm --needed lib32-pipewire-jack  # Аудио/видео маршрутизатор и процессор с малой задержкой - 32 бит - поддержка JACK ; https://pipewire.org/ ; https://archlinux.org/packages/multilib/x86_64/lib32-pipewire-jack/
###sudo pacman -S --noconfirm --needed pipewire-pulse  # Аудио/видео маршрутизатор и процессор с малой задержкой — замена PulseAudio ; https://pipewire.org/ ; https://archlinux.org/packages/extra/x86_64/pipewire-pulse/
### PipeWire — это проект, направленный на значительное улучшение обработ;ки аудио и видео в Linux. Он предоставляет графическую обработку с низкой задержкой поверх аудио- и видеоустройств, которую можно использовать для поддержки вариантов использования, которые в настоящее время обрабатываются как PulseAudio, так и JACK.
############ Библиотека для чтения DVD видеодисков ##############
sudo pacman -S --noconfirm --needed glibc  # Библиотека GNU C ; https://www.gnu.org/software/libc ; https://archlinux.org/packages/core/x86_64/glibc/ 
sudo pacman -S --noconfirm --needed libdvdcss  # Портативная библиотека абстракций для расшифровки DVD ; https://www.videolan.org/developers/libdvdcss.html ; https://archlinux.org/packages/extra/x86_64/libdvdcss/
sudo pacman -S --noconfirm --needed libdvdread  # Библиотека для чтения DVD видеодисков ; https://www.videolan.org/developers/libdvdnav.html ; https://archlinux.org/packages/extra/x86_64/libdvdread/
sudo pacman -S --noconfirm --needed lsdvd  # Консольное приложение, отображающее содержимое DVD ; https://sourceforge.net/projects/lsdvd/ ; https://archlinux.org/packages/extra/x86_64/lsdvd/
#####################
clear
echo ""
echo " Установка пакетов Поддержки звука выполнена "
fi
############ Справка ####################
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
################################

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
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (zip, unzip, unrar, unarchiver, p7zip, zlib, zziplib, lzop)."
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
sudo pacman -S --noconfirm --needed unarchiver  # unar и lsar: инструменты Objective-C для распаковки архивных файлов
# sudo pacman -S --noconfirm --needed 
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
### ARJ (сокращение от Archived by Robert Jung) - формат архивированных файлов с использованием программного обеспечения,
### Формат командной строки ARJ таков:
# Основные команды:
# a - добавить в архив;
# u - добавить в архив, обновляя существующие файлы, если их время изменилось, и добавляя отсутствующие;
# f - то же самое, но отсутствующие файлы не добавляются;
# l - вывести содержимое архива;
# e - распаковать в текущий каталог;
# x - распаковать с путями.
###################

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
# sudo pacman -S --noconfirm --needed xarchiver  # Интерфейс GTK+ для различных архиваторов командной строки
sudo pacman -S --noconfirm --needed xarchiver-gtk2  # легкий настольный независимый менеджер архивов
fi
########################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установим Hwdetect - пакет (hwdetect) - Информация о железе?"
echo " Hwdetect - это скрипт (консольная утилита с огромным количеством опций) обнаружения оборудования, который в основном используется для загрузки или вывода списка модулей ядра (для использования в mkinitcpio.conf), и заканчивая возможностью автоматического изменения rc.conf и mkinitcpio.conf ; (https://wiki.archlinux.org/title/Hwdetect) "
echo -e "${YELLOW}=> Примечание: ${BOLD}Это отличается от многих других инструментов, которые запрашивают только оборудование и показывают необработанную информацию, оставляя пользователю задачу связать эту информацию с необходимыми драйверами. ${NC}"
echo " Сценарий использует информацию, экспортируемую подсистемой sysfs (https://en.wikipedia.org/wiki/Sysfs), используемой ядром Linux. "
echo -e "${YELLOW}==> ${NC}Будьте внимательны! Если Вы сомневаетесь в своих действиях, просто пропустите этот пункт."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить пакет (hwdetect),    0 - Нет пропустить установку: " i_hwdetect  # sends right after the keypress; # отправляет сразу после нажатия клавиши
echo ''
   [[ "$i_hwdetect" =~ [^10] ]]
do
    :
done
if [[ $i_hwdetect == 0 ]]; then
  echo ""
  echo " Установка пакетов пропущена "
elif [[ $i_hwdetect == 1 ]]; then
  echo ""
  echo " Установка пакета (hwdetect) "
  pacman -Syy  # обновление баз пакмэна (pacman)
  pacman -S --noconfirm --needed hwdetect  # Скрипт (консольная утилита) просмотр модулей ядра для устройств, обнаружения оборудования с загрузочными модулями и поддержкой mkinitcpio.conf / rc.conf
# pacman -S hwdetect --noconfirm  # Скрипт (консольная утилита) просмотр модулей ядра для устройств, обнаружения оборудования с загрузочными модулями и поддержкой mkinitcpio.conf / rc.conf
  echo ""
  echo " Установка дополнительных базовых программ (пакетов) выполнена "
fi
sleep 1

clear
echo -e "${MAGENTA}
  <<< Установка дополнительного софта (пакетов) для Archlinux >>> ${NC}"
# Installing additional software (packages) for Archlinux

echo ""
echo -e "${GREEN}==> ${NC}Установка дополнительных базовых программ (пакетов)"
#echo -e "${BLUE}:: ${NC}Установка дополнительных базовых программ (пакетов)"
#echo 'Установка дополнительных базовых программ (пакетов)'
# Installing additional basic programs (packages)
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (accountsservice, acpi, acpid, android-tools, android-udev, anything-sync-daemon, archinstall, arch-install-scripts, aspell-en, aspell-ru, autofs, b43-fwcutter, bash-completion, bc, beep, btrfs-progs, busybox, catfish, ccache, cpio, cpupower, desktop-file-utils, dmraid, dmidecode, dosfstools, efibootmgr, efitools, extra-cmake-modules, f2fs-tools, flex, foremost, fortune-mod, fsarchiver, fwupd, fuse3, glances, gperf, gpm, gptfdisk, gtop, gvfs, gvfs-gphoto2, gvfs-nfs, gvfs-smb, haveged, hddtemp, hdparm, hidapi, hwdetect, hwinfo, hyphen-en, id3lib, iftop, inxi, isomd5sum, jfsutils, kvantum, lib32-curl, lib32-flex, libfm-gtk2, libudev0-shim, libwireplumber, lksctp-tools, logrotate, lm_sensors, lsof, lsb-release, lvm2, man-db, man-pages, mc, memtest86+, mlocate, mtpfs, ncurses, ncdu, nfs-utils, nmon, pacman-contrib, patchutils, pciutils, php, picom_X11, polkit, poppler-data, powertop, pv, pwgen, python-isomd5sum, python-pip, qt5-translations, reiserfsprogs, re2, reflector, ruby, s-nail, sane, screen, scrot, sg3_utils, sdparm, sof-firmware, solid, sox, smartmontools, speedtest-cli, squashfs-tools, strace, syslinux, systemd-ui, termite, termite-terminfo, translate-shell, udiskie, udisks2, unixodbc, usbutils, wimlib, wipe, xclip, xdg-utils, xfsprogs, xsel, xterm, xorg-twm, xorg-xkill, yelp, yt-dlp, screen, tmux, util-linux, httrack...)."
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
sudo pacman -S --noconfirm --needed anything-sync-daemon  # Символические ссылки и синхронизация указанных пользователем каталогов с оперативной памятью
sudo pacman -S --noconfirm --needed archinstall  # Еще один пошаговый/автоматизированный установщик Arch Linux с изюминкой ; https://github.com/archlinux/archinstall ; https://archlinux.org/packages/extra/any/archinstall/ 
sudo pacman -S --noconfirm --needed arch-install-scripts  # Сценарии для помощи в установке Arch Linux
sudo pacman -S --noconfirm --needed aspell-en  # Английский словарь для aspell
sudo pacman -S --noconfirm --needed aspell-ru  # Русский словарь для aspell
# ###sudo pacman -S autofs --noconfirm  # Средство автомонтирования на основе ядра для Linux ; Раньше присутствовал в community 
sudo pacman -S --noconfirm --needed b43-fwcutter  # Экстрактор прошивки для модуля ядра b43 (драйвер)
sudo pacman -S --noconfirm --needed bash-completion  # Программируемое завершение для оболочки bash
sudo pacman -S --noconfirm --needed bc  # Язык калькулятора произвольной точности
sudo pacman -S --noconfirm --needed beep  # Продвинутая программа звукового сигнала динамика ПК
sudo pacman -S --noconfirm --needed btrfs-progs  # Утилиты файловой системы btrfs
sudo pacman -S --noconfirm --needed busybox  # Утилиты для аварийно-спасательных и встраиваемых систем
sudo pacman -S --noconfirm --needed catfish  # Универсальный инструмент для поиска файлов
sudo pacman -S --noconfirm --needed ccache  # Кэш компилятора, который ускоряет перекомпиляцию за счет кеширования предыдущих компиляций
sudo pacman -S --noconfirm --needed cpio  # Инструмент для копирования файлов в или из архива cpio или tar
sudo pacman -S --noconfirm --needed cpupower  # Инструмент ядра Linux для проверки и настройки функций вашего процессора, связанных с энергосбережением
sudo pacman -S --noconfirm --needed cryptsetup  # Инструмент настройки пользовательского пространства для прозрачного шифрования блочных устройств с использованием dm-crypt ; https://gitlab.com/cryptsetup/cryptsetup/ ; https://archlinux.org/packages/core/x86_64/cryptsetup/
sudo pacman -S --noconfirm --needed desktop-file-utils  # Утилиты командной строки для работы с записями рабочего стола
sudo pacman -S --noconfirm --needed dmraid  # Интерфейс RAID устройства сопоставления устройств
sudo pacman -S --noconfirm --needed dmidecode  # Утилиты, относящиеся к таблице интерфейса управления рабочим столом (https://www.nongnu.org/dmidecode)
sudo pacman -S --noconfirm --needed dosfstools  # Утилиты файловой системы DOS
sudo pacman -S --noconfirm --needed efibootmgr  # Приложение пользовательского пространства Linux для изменения диспетчера загрузки EFI
sudo pacman -S --noconfirm --needed efitools  # Инструменты для управления платформами безопасной загрузки UEFI
sudo pacman -S --noconfirm --needed extra-cmake-modules  # Дополнительные модули и скрипты для CMake
sudo pacman -S --noconfirm --needed f2fs-tools  # Инструменты для файловой системы, дружественной к Flash (F2FS)
sudo pacman -S --noconfirm --needed fd  # Программа для поиска записей в вашей файловой системе. Это простая, быстрая и удобная альтернатива find ; https://github.com/sharkdp/fd ; https://archlinux.org/packages/extra/x86_64/fd/ 
sudo pacman -S --noconfirm --needed flex  # Инструмент для создания программ сканирования текста
sudo pacman -S --noconfirm --needed foremost  # Консольная программа для восстановления файлов на основе их верхних и нижних колонтитулов и внутренних структур данных (http://foremost.sourceforge.net/)
sudo pacman -S --noconfirm --needed fortune-mod  # Программа Fortune Cookie от BSD games
sudo pacman -S --noconfirm --needed fsarchiver  # Безопасный и гибкий инструмент для резервного копирования и развертывания файловой системы
sudo pacman -S --noconfirm --needed fuse3  # Библиотека, позволяющая реализовать файловую систему в программе пользовательского пространства
sudo pacman -S --noconfirm --needed fzf  # Командная строка нечеткого поиска ; https://github.com/junegunn/fzf ; https://archlinux.org/packages/extra/x86_64/fzf/
sudo pacman -S --noconfirm --needed fwupd  # Простой демон, позволяющий программному обеспечению сеанса обновлять прошивку (https://github.com/fwupd/fwupd)
sudo pacman -S --noconfirm --needed glances  # Инструмент мониторинга на основе CLI на основе curses
sudo pacman -S --noconfirm --needed glibc-locales  # Предварительно сгенерированные локали для библиотеки GNU C ; https://www.gnu.org/software/libc ; https://archlinux.org/packages/core/x86_64/glibc-locales/ 
sudo pacman -S --noconfirm --needed gperf  # Идеальный генератор хэш-функций
sudo pacman -S --noconfirm --needed gpm  # Сервер мыши для консоли и xterm
sudo pacman -S --noconfirm --needed gptfdisk  # Инструмент для создания разделов в текстовом режиме, который работает с дисками с таблицей разделов GUID (GPT)
# sudo pacman -S --noconfirm --needed grub-btrfs  # Включите снимки btrfs в параметры загрузки GRUB
sudo pacman -S --noconfirm --needed gvfs  # Реализация виртуальной файловой системы для GIO (Разделенные пакеты: gvfs-afc, gvfs-goa, gvfs-google, gvfs-gphoto2, gvfs-mtp, еще…)
# sudo pacman -S --noconfirm --needed gvfs-mtp  # Реализация виртуальной файловой системы для GIO (бэкэнд MTP; Android, медиаплеер)
sudo pacman -S --noconfirm --needed gvfs-afc  # Реализация виртуальной файловой системы для GIO (серверная часть AFC; мобильные устройства Apple)
sudo pacman -S --noconfirm --needed gvfs-goa  # Реализация виртуальной файловой системы для GIO - бэкэнд Gnome Online Accounts (например, OwnCloud) ; https://gitlab.gnome.org/GNOME/gvfs ; https://archlinux.org/packages/extra/x86_64/gvfs-goa/
sudo pacman -S --noconfirm --needed gvfs-google  # Реализация виртуальной файловой системы для GIO — бэкэнд Google Drive (серверная часть Google Диска ; https://gitlab.gnome.org/GNOME/gvfs ; https://archlinux.org/packages/extra/x86_64/gvfs-google/
sudo pacman -S --noconfirm --needed gvfs-gphoto2  # Реализация виртуальной файловой системы для GIO (бэкэнд gphoto2; камера PTP, медиаплеер MTP)
sudo pacman -S --noconfirm --needed gvfs-nfs  # Реализация виртуальной файловой системы для GIO (серверная часть NFS)
sudo pacman -S --noconfirm --needed gvfs-smb  # Реализация виртуальной файловой системы для GIO (серверная часть SMB / CIFS; клиент Windows)
sudo pacman -S --noconfirm --needed haveged  #  Демон сбора энтропии с использованием таймингов процессора (https://github.com/jirka-h/haveged)(запустить haveged -n 0 | pv > /dev/null)
sudo pacman -S --noconfirm --needed hddtemp  # Показывает температуру вашего жесткого диска, читая информацию SMART
sudo pacman -S --noconfirm --needed hdparm  # Утилита оболочки для управления параметрами диска / драйвера Linux IDE (получить / установить параметры диска ATA / SATA под Linux)
sudo pacman -S --noconfirm --needed hidapi  # Простая библиотека для связи с устройствами USB и Bluetooth HID
sudo pacman -S --noconfirm --needed hwdetect # Скрипт (консольная утилита) просмотр модулей ядра для устройств, обнаружения оборудования с загрузочными модулями и поддержкой mkinitcpio.conf / rc.conf
sudo pacman -S --noconfirm --needed hwinfo  # Инструмент обнаружения оборудования от openSUSE
sudo pacman -S --noconfirm --needed hyphen-en  # Правила расстановки переносов в английском
sudo pacman -S --noconfirm --needed id3lib  # Библиотека для чтения, записи и управления тегами ID3v1 и ID3v2
sudo pacman -S --noconfirm --needed iftop  # Отображение использования полосы пропускания на интерфейсе
sudo pacman -S --noconfirm --needed inxi  # Полнофункциональный системный информационный инструмент CLI
#sudo pacman -S --noconfirm --needed iptables-nft  # Инструмент управления пакетами ядра Linux (использующий интерфейс nft); https://www.netfilter.org/projects/iptables/index.html ; https://archlinux.org/packages/core/x86_64/iptables-nft/
sudo pacman -S --noconfirm --needed jq  # Процессор командной строки JSON ; https://jqlang.github.io/jq/ ; https://archlinux.org/packages/extra/x86_64/jq/
sudo pacman -S --noconfirm --needed isomd5sum  # Утилиты для работы с md5sum, имплантированными в ISO-образы
sudo pacman -S --noconfirm --needed jfsutils  # Утилиты файловой системы JFS
sudo pacman -S --noconfirm --needed kvantum  # Механизм тем на основе SVG для Qt6 (включая инструмент настройки и дополнительные темы) https://archlinux.org/packages/extra/x86_64/kvantum/
#sudo pacman -S --noconfirm --needed kvantum-qt5  # Тематический движок на основе SVG для Qt5 ; https://github.com/tsujan/Kvantum ; https://archlinux.org/packages/extra/x86_64/kvantum-qt5/
sudo pacman -S --noconfirm --needed lib32-curl  # Утилита и библиотека для поиска URL (32-разрядная версия)
sudo pacman -S --noconfirm --needed lib32-flex  # Инструмент для создания программ сканирования текста
sudo pacman -S --noconfirm --needed libfm-gtk2  # Библиотека GTK + 2 для управления файлами
sudo pacman -S --noconfirm --needed libudev0-shim  # Библиотека совместимости libudev.so.0 для систем с более новыми версиями udev
sudo pacman -S --noconfirm --needed libunrar  # Библиотека и заголовочный файл для приложений, использующих libunrar 
sudo pacman -S --noconfirm --needed wireplumber  # Реализация менеджера сеансов/политик для PipeWire ; https://pipewire.pages.freedesktop.org/wireplumber/ ; https://archlinux.org/packages/extra/x86_64/wireplumber/
sudo pacman -S --noconfirm --needed libwireplumber  # Реализация менеджера сеансов/политик для PipeWire — клиентская библиотека ; https://pipewire.pages.freedesktop.org/wireplumber/ ; https://archlinux.org/packages/extra/x86_64/libwireplumber/
# sudo pacman -S --noconfirm --needed light-locker  # Простой шкафчик сессий для LightDM   # присутствует
sudo pacman -S --noconfirm --needed lksctp-tools  # Реализация протокола SCTP (http://lksctp.sourceforge.net/)
sudo pacman -S --noconfirm --needed logrotate  # Автоматическая ротация системных журналов
sudo pacman -S --noconfirm --needed lm_sensors  # Коллекция инструментов пользовательского пространства для общего доступа к SMBus и мониторинга оборудования 
sudo pacman -S --noconfirm --needed lsb-release  # Программа запроса версии LSB   # присутствует
sudo pacman -S --noconfirm --needed lsof  # Перечисляет открытые файлы для запуска процессов Unix (https://github.com/lsof-org/lsof)(cat > /tmp/LOG &  ; lsof -p 18083)
sudo pacman -S --noconfirm --needed lvm2  #  Утилиты Logical Volume Manager 2 (https://sourceware.org/lvm2/)
sudo pacman -S --noconfirm --needed mc  # Файловый менеджер, эмулирующий Norton Commander
sudo pacman -S --noconfirm --needed memtest86+  # Усовершенствованный инструмент диагностики памяти
sudo pacman -S --noconfirm --needed memtest86+-efi  # Расширенная версия инструмента диагностики памяти EFI 
sudo pacman -S --noconfirm --needed mlocate  # Слияние реализации locate / updatedb
sudo pacman -S --noconfirm --needed mtpfs  # Файловая система FUSE, поддерживающая чтение и запись с любого устройства MTP
sudo pacman -S --noconfirm --needed ncurses # Библиотека эмуляции проклятий System V Release 4.0
sudo pacman -S --noconfirm --needed ncdu  # Анализатор использования диска с интерфейсом ncurses
sudo pacman -S --noconfirm --needed nfs-utils  # Программы поддержки для сетевых файловых систем
sudo pacman -S --noconfirm --needed nmon  # Инструмент мониторинга производительности AIX и Linux (http://nmon.sourceforge.net/pmwiki.php)
sudo pacman -S --noconfirm --needed libnvme  # Библиотека C для NVM Express на Linux ; https://github.com/linux-nvme/libnvme ; https://archlinux.org/packages/extra/x86_64/libnvme/
sudo pacman -S --noconfirm --needed nvme-cli  # Инструментарий пользовательского пространства NVM-Express для Linux ; https://github.com/linux-nvme/nvme-cli ; https://archlinux.org/packages/extra/x86_64/nvme-cli/
### sudo pacman -S --noconfirm --needed openbsd-netcat  #  Швейцарский армейский нож TCP / IP. Вариант OpenBSD (Важно конфликтует с gnu-netcat - GNU переписывает netcat, приложение для создания сетевых трубопроводов). Простая утилита Unix, которая считывает и записывает данные через сетевые соединения с использованием протоколов TCP или UDP. Этот пакет содержит переписанную версию netcat для OpenBSD, включая поддержку IPv6, прокси-серверов и сокетов Unix.
sudo pacman -S --noconfirm --needed patchutils  # Небольшая коллекция программ, работающих с файлами патчей
sudo pacman -S --noconfirm --needed parallel  # Инструмент оболочки для параллельного выполнения заданий ; https://www.gnu.org/software/parallel/ ; https://archlinux.org/packages/extra/any/parallel/
sudo pacman -S --noconfirm --needed pass  # Безопасное хранение, извлечение, генерация и синхронизация паролей ; https://www.passwordstore.org/ ; https://archlinux.org/packages/extra/any/pass/
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
sudo pacman -S --noconfirm --needed reflector  # Модуль и скрипт Python 3 для получения и фильтрации последнего списка зеркал Pacman
sudo pacman -S --noconfirm --needed reiserfsprogs  # Утилиты Reiserfs (Инструменты для поддержки файловой системы ReiserFS)
sudo pacman -S --noconfirm --needed re2   # Быстрый, безопасный, ориентированный на многопоточность механизм регулярных выражений
sudo pacman -S --noconfirm --needed rng-tools  # Утилиты, связанные с генератором случайных чисел ; https://github.com/nhorman/rng-tools ; Он отслеживает набор источников энтропии и поставляет энтропию из них в механизм /dev/random ядра системы.
sudo pacman -S --noconfirm --needed ruby  # Объектно-ориентированный язык для быстрого и простого программирования
sudo pacman -S --noconfirm --needed s-nail  # Среда для отправки и получения почты
sudo pacman -S --noconfirm --needed sane  # Доступ к сканеру теперь простой
sudo pacman -S --noconfirm --needed xsane  # Интерфейс X11 на базе GTK для SANE и плагин для Gimp ; https://gitlab.com/sane-project/frontend/xsane ; https://archlinux.org/packages/extra/x86_64/xsane/
sudo pacman -S --noconfirm --needed screen  # Полноэкранный оконный менеджер, который мультиплексирует физический терминал
sudo pacman -S --noconfirm --needed sg3_utils  # Универсальные утилиты SCSI
sudo pacman -S --noconfirm --needed sdparm  # Утилита, аналогичная hdparm, но для устройств SCSI (http://sg.danny.cz/sg/sdparm.html)
sudo pacman -S --noconfirm --needed sof-firmware  # Звук открыть прошивку
sudo pacman -S --noconfirm --needed solid  # Аппаратная интеграция и обнаружение
sudo pacman -S --noconfirm --needed sox  # Швейцарский армейский нож инструментов обработки звука
sudo pacman -S --noconfirm --needed smartmontools  # Управление и мониторинг жестких дисков ATA и SCSI с поддержкой SMAR
sudo pacman -S --noconfirm --needed speedtest-cli  # Интерфейс командной строки для тестирования пропускной способности интернета с помощью speedtest.net
sudo pacman -S --noconfirm --needed squashfs-tools  # Инструменты для squashfs, файловой системы Linux с высокой степенью сжатия, доступной только для чтения
sudo pacman -S --noconfirm --needed strace  # Диагностический, отладочный и обучающий трассировщик пользовательского пространства
sudo pacman -S --noconfirm --needed syslinux  # Коллекция загрузчиков, которые загружаются с файловых систем FAT, ext2 / 3/4 и btrfs, с компакт-дисков и через PXE
sudo pacman -S --noconfirm --needed systemd-ui  # Графический интерфейс для systemd
sudo pacman -S --noconfirm --needed translate-shell  # Интерфейс командной строки и интерактивная оболочка для Google Translate
sudo pacman -S --noconfirm --needed udiskie  # Автоматическое монтирование съемных дисков с использованием udisks
sudo pacman -S --noconfirm --needed udisks2  # Служба управления дисками, версия 2 (https://www.freedesktop.org/wiki/Software/udisks/)
sudo pacman -S --noconfirm --needed unixodbc  # ODBC - это открытая спецификация для предоставления разработчикам приложений предсказуемого API для доступа к источникам данных
sudo pacman -S --noconfirm --needed usbutils  # Набор USB-инструментов для запроса подключенных USB-устройств
sudo pacman -S --noconfirm --needed whois  # Интеллектуальный WHOIS-клиент ; https://github.com/rfc1036/whois ; https://archlinux.org/packages/extra/x86_64/whois/
sudo pacman -S --noconfirm --needed wimlib  # Библиотека и программа для извлечения, создания и изменения файлов WIM
sudo pacman -S --noconfirm --needed wipe  # Утилита для безопасной очистки файлов (http://wipe.sourceforge.net/)
sudo pacman -S --noconfirm --needed xclip  # Интерфейс командной строки для буфера обмена X11
sudo pacman -S --noconfirm --needed xdg-utils  # Инструменты командной строки, которые помогают приложениям решать различные задачи интеграции с настольными компьютерами. (https://www.freedesktop.org/wiki/Software/xdg-utils/)
sudo pacman -S --noconfirm --needed xfsprogs  # Утилиты файловой системы XFS
sudo pacman -S --noconfirm --needed xsel  # XSel это программа командной строки для получения и установки содержимого выделения X
sudo pacman -S --noconfirm --needed xterm  # Эмулятор терминала X
# sudo pacman -S --noconfirm --needed xorg-xclock --noconfirm  # X часы
sudo pacman -S --noconfirm --needed xorg-twm  # Вкладка Window Manager для системы X Window
sudo pacman -S --noconfirm --needed xorg-xkill  # Убить клиента его X-ресурсом
sudo pacman -S --noconfirm --needed libgcrypt15  # Универсальная криптографическая библиотека на основе кода GnuPG ; http://www.gnupg.org/ ; https://archlinux.org/packages/extra/x86_64/libgcrypt15/
sudo pacman -S --noconfirm --needed yelp  # Получите помощь с GNOME
sudo pacman -S --noconfirm --needed yt-dlp  # Форк youtube-dl с дополнительными функциями и исправлениями https://archlinux.org/packages/extra/any/yt-dlp/
sudo pacman -S --noconfirm --needed spdlog  # Очень быстрая, только для заголовков / скомпилированная библиотека журналов C ++
# sudo pacman -S --noconfirm --needed httrack  # Простая в использовании офлайн-браузерная утилита (Помечено как устаревшее 12.02.2024); https://www.httrack.com/ ; https://archlinux.org/packages/extra/x86_64/httrack/ ; https://man.archlinux.org/man/httrack.1.en
sudo pacman -S --noconfirm --needed re2  # Быстрый, безопасный, ориентированный на многопоточность механизм регулярных выражений ; https://github.com/google/re2 ; https://archlinux.org/packages/extra/x86_64/re2/
sudo pacman -S --noconfirm --needed electron  # Мета-пакет, предоставляющий последнюю доступную стабильную сборку Electron ; Создавайте кроссплатформенные настольные приложения с помощью веб-технологий ; https://electronjs.org/ ; https://archlinux.org/packages/extra/any/electron/
sudo pacman -S --noconfirm --needed node-gyp  # Инструмент для сборки надстроек Node.js ; https://github.com/nodejs/node-gyp ; https://archlinux.org/packages/extra/any/node-gyp/
sudo pacman -S --noconfirm --needed gperf  # Идеальный генератор хэш-функций. Для заданного списка строк он создает хэш-функцию и хэш-таблицу в виде кода C или C++ для поиска значения в зависимости от входной строки ; https://www.gnu.org/software/gperf/https://archlinux.org/packages/extra/x86_64/gperf/
# sudo pacman -S --noconfirm --needed   # 
#### Терминальные мультиплексор #########
sudo pacman -S --noconfirm --needed screen  # Полноэкранный оконный менеджер, который мультиплексирует физический терминал
sudo pacman -S --noconfirm --needed tmux  # Терминальный мультиплексор
#### Различные системные утилиты для Linux #########
sudo pacman -S --noconfirm --needed util-linux  # Различные системные утилиты для Linux ; https://github.com/util-linux/util-linux ; https://archlinux.org/packages/core/x86_64/util-linux/
sudo pacman -S --noconfirm --needed dpkg  # Инструменты менеджера пакетов Debian ; https://tracker.debian.org/pkg/dpkg ; https://archlinux.org/packages/extra/x86_64/dpkg/
############# Файлы прошивки для Linux ###################
sudo pacman -S --noconfirm --needed linux-firmware-marvell  # Файлы прошивки для Linux - marvell / Прошивки для устройств Marvell ; https://gitlab.com/kernel-firmware/linux-firmware ; https://archlinux.org/packages/core/any/linux-firmware-marvell/
sudo pacman -S --noconfirm --needed mkinitcpio-archiso  # Скрипты Initcpio, используемые archiso ; https://gitlab.archlinux.org/mkinitcpio/mkinitcpio-archiso ; https://archlinux.org/packages/extra/any/mkinitcpio-archiso/
sudo pacman -S --noconfirm --needed mkinitcpio-nfs-utils  # Инструменты ipconfig и nfsmount для поддержки NFS root в mkinitcpio ; http://www.archlinux.org/ ; https://archlinux.org/packages/core/x86_64/mkinitcpio-nfs-utils/
############# Порталы интеграции рабочего стола ##################
sudo pacman -S --noconfirm --needed xdg-desktop-portal  # Порталы интеграции рабочего стола для изолированных приложений ; https://flatpak.github.io/xdg-desktop-portal/ ; https://archlinux.org/packages/extra/x86_64/xdg-desktop-portal/
sudo pacman -S --noconfirm --needed xdg-desktop-portal-gtk  # Реализация бэкэнда для xdg-desktop-portal с использованием GTK ; https://github.com/flatpak/xdg-desktop-portal-gtk ; https://archlinux.org/packages/extra/x86_64/xdg-desktop-portal-gtk/ 
### Исправим отображение миниатюр в файловом менеджере ###
# sudo pacman -S tumbler ffmpegthumbnailer poppler-glib libgsf libopenraw shared-mime-info raw-thumbnailer perl-file-mimeinfo --noconfirm
#sudo pacman -S tumbler --noconfirm  #  Сервис D-Bus для приложений, запрашивающих миниатюры
#sudo pacman -S ffmpegthumbnailer --noconfirm  # Легкий эскиз видеофайлов, который может использоваться файловыми менеджерами
# sudo pacman -S --noconfirm --needed ffmpegthumbs  # Создатель миниатюр для видеофайлов на основе FFmpeg. FFmpeg Thumbnailer — генератор миниатюр видео для файловых менеджеров KDE ; https://apps.kde.org/ffmpegthumbs/ 
#sudo pacman -S poppler-glib --noconfirm  # Наручники Poppler Glib
#sudo pacman -S libgsf --noconfirm  # Расширяемая библиотека абстракции ввода-вывода для работы со структурированными форматами файлов
#sudo pacman -S libopenraw --noconfirm  # Библиотека для декодирования файлов RAW
#sudo pacman -S shared-mime-info --noconfirm  # Общая информация MIME на Freedesktop.org
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
echo -e "${MAGENTA}
  <<< Установка Мультимедиа утилит и кодеков в Archlinux >>> ${NC}"
# Installing Multimedia utilities, and codecs in Archlinux
echo ""
echo -e "${GREEN}==> ${NC}Установка мультимедиа кодеков - GStreamer (multimedia codecs), и утилит"
#echo -e "${BLUE}:: ${NC}Установка мультимедиа кодеков (multimedia codecs), и утилит"
#echo 'Установка Мультимедиа кодеков (multimedia codecs), и утилит'
# Installing Multimedia codecs and utilities
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (a52dec, faac, faad2, flac, jasper, lame, libid3tag, libdca, libdv, libmad, libmpeg2, libtheora, libvorbis, libxv, wavpack, x264, xvidcore, gst-plugins-base, gst-plugins-base-libs, gst-plugins-good, gst-plugins-bad, gst-plugins-ugly, libdvdcss, libdvdread, libdvdnav, dvd+rw-tools, dvdauthor, dvgrab, cdrdao, gst-libav, gpac)."
echo -e "${MAGENTA}=> ${NC}Список GStreamer утилит (пакетов) для установки: - (gstreamer, gstreamer-docs, gstreamer-vaapi, gst-libav, gst-plugins-bad, gst-plugins-base, gst-plugins-base-libs, gst-plugins-good, gst-plugins-ugly, gstreamermm, gstreamermm-docs, libde265, xine-lib)."
echo -e "${MAGENTA}=> ${NC}Список кодеков для графики DEC SIXEL и некоторые программы-конвертеры для установки: - (libsixel, lsix)."
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
  sudo pacman -S --noconfirm --needed libid3tag  # Библиотека манипуляции тегами ID3 
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
  sudo pacman -S --noconfirm --needed mac  # Кодек и декомпрессор APE
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
  sudo pacman -S --noconfirm --needed gst-plugins-good  #  Это GStreamer, мультимедийный фреймворк для потоковой передачи мультимедиа - хорошие плагины ; https://gstreamer.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/gst-plugins-good/
  sudo pacman -S --noconfirm --needed gst-plugins-ugly  # Фреймворк мультимедийного графа - уродливые плагины
  sudo pacman -S --noconfirm --needed gstreamermm  # Интерфейс C ++ для GStreamer (https://github.com/GNOME/gstreamermm; https://gstreamer.freedesktop.org/bindings/cplusplus.html)
  sudo pacman -S --noconfirm --needed gstreamermm-docs  # Интерфейс C ++ для GStreamer (документация) (https://gstreamer.freedesktop.org/bindings/cplusplus.html)
  sudo pacman -S --noconfirm --needed gst-plugin-libcamera  # Мультимедийный граф-фреймворк - плагин libcamera ; https://libcamera.org/ ; https://archlinux.org/packages/extra/x86_64/gst-plugin-libcamera/
  sudo pacman -S --noconfirm --needed gst-plugin-msdk  # Мультимедийный граф-фреймворк - плагин msdk ; https://gstreamer.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/gst-plugin-msdk/
  sudo pacman -S --noconfirm --needed gst-plugin-opencv  # Мультимедийный граф-фреймворк - плагин opencv ; https://gstreamer.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/gst-plugin-opencv/ 
  sudo pacman -S --noconfirm --needed gst-plugin-pipewire  # Мультимедийная графическая структура - плагин pipewire ; https://pipewire.org/ ; https://archlinux.org/packages/extra/x86_64/gst-plugin-pipewire/
  sudo pacman -S --noconfirm --needed gst-plugin-qmlgl  # Мультимедийный граф-фреймворк - плагин qmlgl ; https://gstreamer.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/gst-plugin-qmlgl/
  sudo pacman -S --noconfirm --needed gst-plugin-va  # Мультимедийная графическая структура - плагин va ; https://gstreamer.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/gst-plugin-va/
  sudo pacman -S --noconfirm --needed gst-plugin-wpe  # Мультимедийная графическая структура - плагин wpe ; https://gstreamer.freedesktop.org/ ; https://gstreamer.freedesktop.org/
  sudo pacman -S --noconfirm --needed libde265  # Открытая реализация видеокодека h.265 https://github.com/strukturag/libde265
  sudo pacman -S --noconfirm --needed recordmydesktop  # Создает инкапсулированную в OGG запись Theora/Vorbis вашего рабочего стола
  echo ""
  echo " Устанавливаем Xine - это свободный мультимедиа движок "
  sudo pacman -S --noconfirm --needed xine-lib  # Движок воспроизведения мультимедиа (https://www.xine-project.org)
### Xine - универсальный медиа-плеер написанный как разделяемая библиотека (xine-lib), которая поддерживает многочисленные фронтенды (xine-ui). Xine также может использовать библиотеки из других проектов, включая двоичные кодеки Windows.
  echo ""
  echo " Устанавливаем кодек для графики DEC SIXEL и некоторые программы-конвертеры "
  sudo pacman -S --noconfirm --needed libsixel  # Предоставляет кодек для графики DEC SIXEL и некоторые программы-конвертеры ; https://github.com/libsixel/libsixel ; https://archlinux.org/packages/extra/x86_64/libsixel/
  sudo pacman -S --noconfirm --needed lsix  # Как ls, но для изображений показывает миниатюры в терминале с помощью sixel graphics ; https://github.com/hackerb9/lsix ; https://archlinux.org/packages/extra/any/lsix/
  sudo pacman -S --noconfirm --needed opus-tools  # Коллекция инструментов для аудиокодека Opus ; https://wiki.xiph.org/Opus-tools ; https://archlinux.org/packages/extra/x86_64/opus-tools/
  sudo pacman -S --noconfirm --needed vorbis-tools  # Дополнительные инструменты для Ogg-Vorbis ; https://www.xiph.org/vorbis/ ; https://archlinux.org/packages/extra/x86_64/vorbis-tools/
  sudo pacman -S --noconfirm --needed vorbisgain  # Утилита, вычисляющая значения ReplayGain для файлов Ogg Vorbis ; https://sjeng.org/vorbisgain.html ; https://archlinux.org/packages/extra/x86_64/vorbisgain/
  echo ""
  echo " Установка мультимедиа кодеков и утилит (пакетов) выполнена "
fi
############# 

clear
echo ""
echo -e "${BLUE}:: ${NC}Установим пакет auditd (для просмотра записей в журнале выполните команд) в том числе какой процесс изменяет файл /etc/resolv.conf , а также для получения уведомления об обновлениях безопасности Arch Linux. "
echo -e " Установка базовых программ (пакетов): audit, arch-audit, arch-audit-gtk, python-audit "
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_audit  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_audit" =~ [^10] ]]
do
    :
done
if [[ $i_audit == 0 ]]; then
  clear
  echo ""
  echo " Установка утилит (пакетов) пропущена "
elif [[ $i_audit == 1 ]]; then
  echo ""
  echo " Установка утилит (пакетов) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed audit  # Компоненты пользовательского пространства структуры аудита ; https://people.redhat.com/sgrubb/audit ; https://archlinux.org/packages/core/x86_64/audit/
sudo pacman -S --noconfirm --needed arch-audit  # Утилита типа pkg-audit, основанная на данных Arch Security Team ; https://gitlab.com/ilpianista/arch-audit ; https://archlinux.org/packages/extra/x86_64/arch-audit/
sudo pacman -S --noconfirm --needed arch-audit-gtk  # Уведомления об обновлениях безопасности Arch Linux ; https://github.com/kpcyrd/arch-audit-gtk ; https://archlinux.org/packages/extra/x86_64/arch-audit-gtk/
sudo pacman -S --noconfirm --needed python-audit  # Компоненты пользовательского пространства фреймворка аудита — привязки Python ; https://people.redhat.com/sgrubb/audit ; https://archlinux.org/packages/core/x86_64/python-audit/
########## Справка #############
### Для начала, убедитесь, что это настоящий файл, а не символьная ссылка:
### ls -l /etc/resolv.conf
### Если это символьная ссылка, удалите её:
### sudo rm /etc/resolv.conf
### Как узнать, какой процесс изменяет файл /etc/resolv.conf
# sudo auditctl -w /etc/resolv.conf -p wa
# sudo systemctl start auditd.service
# systemctl stop auditd.service
echo " Запустим auditd.service "
sudo systemctl start auditd.service
### Для просмотра записей в журнале выполните команду:
# sudo ausearch -f /etc/resolv.conf
################################
  echo ""
  echo " Установка утилит (пакетов) выполнена "
fi
##################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Группу пакетов realtime (дополнительные инструменты для изменения политик планирования)?"
echo -e " Управление процессами в реальном времени - Приоритезация в реальном времени включена по умолчанию в Arch Linux. Системная, групповая и пользовательская конфигурация может быть достигнута с помощью PAM и systemd . "
echo " Группа пакетов realtime (реального времени https://archlinux.org/groups/x86_64/realtime/) предоставляет дополнительные инструменты для изменения политик планирования IRQ (https://en.wikipedia.org/wiki/Interrupt_request) и процессов в реальном времени. "
echo " Хотя многие современные процессоры достаточно мощны, чтобы воспроизводить дюжину видео- или аудиопотоков одновременно, все еще возможно, что другой поток захватит процессор на полсекунды, чтобы завершить другую задачу. Это приводит к коротким прерываниям в аудио- или видеопотоках. Также возможно, что видео-/аудиопотоки рассинхронизируются. Хотя это раздражает случайного слушателя музыки, для производителя контента, композитора или видеоредактора эта проблема гораздо серьезнее, поскольку она прерывает их рабочий процесс. "
echo " Простое решение — дать аудио- и видеопроцессам более высокий приоритет. Это защищает обычного пользователя от недостаточной мощности процессов, которые необходимы для системы. Это может быть особенно важно на многопользовательских машинах. (https://wiki.archlinux.org/title/Realtime_process_management) "
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_privileges  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_privileges" =~ [^10] ]]
do
    :
done
if [[ $i_privileges == 0 ]]; then
  clear
  echo ""
  echo " Установка утилит (пакетов) пропущена "
elif [[ $i_privileges == 1 ]]; then
  echo ""
  echo " Установка утилит (пакетов) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed realtime-privileges  # Привилегии в реальном времени для пользователей ; https://wiki.archlinux.org/index.php/Realtime_process_management ; https://archlinux.org/packages/extra/any/realtime-privileges/ ; https://archlinux.org/groups/x86_64/realtime/
echo " Добавление пользователя в realtime группу "
sudo usermod -aG realtime $USER  # realtime group, добавление пользователя в realtime группу
# sudo pacman -Rcns realtime-privileges  # Удалить пакет "realtime-privileges"
  echo ""
  echo " Установка утилит (пакетов) выполнена "
fi
############ Справка ##############
### Настройка PAM
# Файл /etc/security/limits.conf содержит конфигурацию для pam_limitsмодуля PAM, который устанавливает ограничения на системные ресурсы (см. limits.conf(5) ).
# Совет: рекомендуется вынести конфигурацию в pam_limitsотдельные файлы, указанные ниже, /etc/security/limits.d поскольку они имеют приоритет над основным файлом конфигурации. (https://wiki.archlinux.org/title/Realtime_process_management)
##################

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
sudo pacman -S --noconfirm --needed gtop  # Панель мониторинга системы для терминала
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
echo " 3 - Fastfetch — Как Neofetch, но гораздо быстрее, для извлечения системной информации и ее красивого отображения. Он написан в основном на C, с учетом производительности и настраиваемости, то выбирайте вариант - "3" "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В этом действии выбор остаётся за вами. "
# Be careful! The installation process was fully automatic. In this action, the choice is yours.
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления"
#echo 'Установка производится в порядке перечисления'
# Installation Is performed in the order listed
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - ScreenFetch,   2 - Neofetch,   3 - Fastfetch,   4 - ScreenFetch, Neofetch, Fastfetch, 

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
sudo pacman -S --noconfirm --needed screenfetch  # CLI Bash-скрипт для отображения информации о системе/теме на снимках экрана ; https://github.com/KittyKatt/screenFetch ; https://archlinux.org/packages/extra/any/screenfetch/
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $i_information == 2 ]]; then
echo ""
echo " Установка утилиты (пакета) Neofetch "
sudo pacman -S --noconfirm --needed neofetch  # CLI-инструмент системной информации, написанный на BASH и поддерживающий отображение изображений ; https://github.com/dylanaraps/neofetch ; https://archlinux.org/packages/extra/any/neofetch/
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $i_information == 3 ]]; then
echo ""
echo " Установка утилит (пакетов) Fastfetch "
sudo pacman -S --noconfirm --needed fastfetch  # Как Neofetch, но гораздо быстрее, так как написан на C ; https://github.com/fastfetch-cli/fastfetch ; https://archlinux.org/packages/extra/x86_64/fastfetch/
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $i_information == 4 ]]; then
echo ""
echo " Установка утилит (пакетов) ScreenFetch, Neofetch, Fastfetch "
sudo pacman -S --noconfirm --needed screenfetch neofetch fastfetch
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#### hyfetch  # Neofetch с флагами гордости ЛГБТК+! ; https://github.com/hykilpikonna/hyfetch ; https://archlinux.org/packages/extra/any/hyfetch/
######################

clear
echo -e "${MAGENTA}
  <<< Установка рекомендованных программ (пакетов) - по вашему выбору и желанию >>> ${NC}"
# Installation of recommended programs (packages) - according to your choice and desire

echo ""
echo -e "${GREEN}==> ${BOLD}Установить рекомендованные программы (пакеты)? ${NC}"
#echo -e "${BLUE}:: ${NC}Установить рекомендованные программы (пакеты)?"
#echo 'Установить рекомендованные программы?'
# Install the recommended programs
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (gparted, grub-customizer, dconf-editor, conky, conky-manager, filezilla, redshift, bleachbit, doublecmd-gtk2, krusader, keepass, keepassxc, veracrypt, onboard, plank, galculator, galculator-gtk2, gnome-calculator)."
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
echo -e "${BLUE}:: ${NC}Установить Редактор dconf (пакеты dconf и dconf-editor)?"
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
sudo pacman -S --noconfirm --needed dconf  # Конфигурационная система базы данных  # https://wiki.gnome.org/Projects/dconf ; https://archlinux.org/packages/extra/x86_64/dconf/
sudo pacman -S --noconfirm --needed dconf-editor  # редактор dconf ; https://wiki.gnome.org/Apps/DconfEditor ; https://archlinux.org/packages/extra/x86_64/dconf-editor/
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
################

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
###################


caffeine



clear
echo -e "${MAGENTA}
  <<< Установка утилит для тщательной очистки системы Archlinux >>> ${NC}"
# Installing utilities for thorough cleaning of the Archlinux system
echo ""
echo -e "${BLUE}:: ${NC}Установить BleachBit (для тщательной очистки)?"
echo -e "${MAGENTA}:: ${BOLD}BleachBit - это мощное приложение, предназначенное для тщательной очистки компьютера и удаления ненужных файлов, что помогает освободить место на дисках и удалить конфиденциальные данные. ${NC}"
echo " Возможности - Автоматическое удаление ненужных файлов в системе, включая Firefox, Adobe Flash, Google Chrome, Opera и другие. Большой набор «клинеров» (cleaners) — поддержка большого количества приложений, с возможностью удаления ненужных (например, временных) файлов данных приложений. Безвозвратное удаление файлов с защитой от восстановления (shred). Безвозвратное удаление произвольных файлов. Поддержка интерфейса командной строки. Модуль CleanerML для написания поддержки дополнительных «клинеров». "
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
echo -e "${GREEN}==> ${NC}Установить Rmlint ([rm] lint) (пакет rmlint) - Инструмент для удаления дубликатов и прочего мусора и (пакет rmlint-shredder) - Графический пользовательский интерфейс для rmlint?"
# Install Rpmlint([rm] line) (rmlint package) - A tool for removing duplicates and other garbage and (rpmlint-shredder package) - A graphical user interface for rmlint?
echo -e "${MAGENTA}=> ${BOLD}Rmlint ([rm] lint) - это Инструмент для удаления дубликатов и прочего мусора, работающий намного быстрее, чем fdupes - (Программа для выявления или удаления дубликатов файлов, находящихся в указанных каталогах). Rmlint находит неиспользуемое пространство и другие неисправные элементы в вашей файловой системе и предлагает удалить их. ${NC}"
echo -e "${YELLOW}:: ${NC}Особенности: Ключевая особенность: Он может найти: Очень быстро. Гибкие и простые параметры командной строки. Выбор нескольких хэшей для обнаружения дубликатов на основе хэшей. Возможность точного побайтового сравнения (только немного медленнее). Множество вариантов вывода. Возможность сохранения времени последнего запуска; в следующий раз будут сканироваться только новые файлы. Множество вариантов для первоначального выбора/приоритизации. Может обрабатывать очень большие наборы файлов (миллионы файлов). Цветной индикатор выполнения. (😃) "
echo " Функции: Находит: Дублирующиеся файлы и дублирующиеся каталоги. Неразделенные двоичные файлы (т.е. двоичные файлы с отладочными символами). Неработающие символические ссылки. Пустые файлы и каталоги. Файлы с поврежденным идентификатором пользователя или/и группы. "
echo -e "${CYAN}:: ${NC}Отличия от других поисковиков дубликатов: Очень быстро (без преувеличения, обещаем!). Режим паранойи для тех, кто не доверяет хеш-суммам. Множество выходных форматов. Никакой интерактивности. Искать только файлы новее определенного mtime. Множество способов обработки дубликатов. Кэширование и воспроизведение и поддерживается btrfs. "
echo " Лицензия: GNU GPL3; Домашняя страница: (https://github.com/sahib/rmlint). Подробная документация доступна по адресу: (http://rmlint.rtfd.org ; https://rmlint.readthedocs.io/en/latest/tutorial.html)"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_rmlint  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_rmlint" =~ [^10] ]]
do
    :
done
if [[ $i_rmlint == 0 ]]; then
echo ""
echo " Установка Rmlint пропущена "
elif [[ $i_rmlint == 1 ]]; then
  echo ""
  echo " Установка Rmlint (удаления дубликатов и прочего мусора) "
##### rmlint ######
sudo pacman -S --noconfirm --needed rmlint  # Инструмент для удаления дубликатов и прочего мусора, работающий намного быстрее, чем fdupes ; https://github.com/sahib/rmlint ; https://archlinux.org/packages/extra/x86_64/rmlint/ ; http://rmlint.rtfd.org
sudo pacman -S --noconfirm --needed rmlint-shredder  # Графический пользовательский интерфейс для rmlint ; https://github.com/sahib/rmlint ; https://archlinux.org/packages/extra/x86_64/rmlint-shredder/ ; http://rmlint.rtfd.org
echo ""
echo " Установка Rmlint выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
########## Справка #################
### Домашняя страница: (https://github.com/sahib/rmlint). Подробная документация доступна по адресу: (http://rmlint.rtfd.org ; https://rmlint.readthedocs.io/en/latest/tutorial.html)
####################################

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Fdupes (пакет fdupes) - для поиска и удаления дубликатов файлов?"
# Install Rpmlint([rm] line) (rmlint package) - A tool for removing duplicates and other garbage and (rpmlint-shredder package) - A graphical user interface for rmlint?
echo -e "${MAGENTA}=> ${BOLD}Fdupes: инструмент CLI - это утилита Командной строки Linux, написанная Адрианом Лопесом на языке программирования C , выпущенная по лицензии MIT. Приложение способно находить дубликаты файлов в заданном наборе каталогов и подкаталогов. Fdupes распознает дубликаты, сравнивая сигнатуру MD5 файлов с последующим побайтовым сравнением. С помощью Fdupes можно передавать множество параметров для перечисления, удаления и замены файлов жесткими ссылками на дубликаты. ${NC}"
echo -e "${YELLOW}:: ${NC}Особенности: Сравнение начинается в следующем порядке: Сравнение размеров > Частичное сравнение подписей MD5 > Полное сравнение подписей MD5 > Побайтовое сравнение. (😃) "
echo " Функции: Перед началом работы не будет лишним ознакомиться с инструментом, выполнив команду: fdupes --help . "
echo -e "${CYAN}:: ${NC}Это обычное требование для большинства пользователей компьютеров — найти и заменить дубликаты файлов. Поиск и удаление дубликатов файлов — утомительная работа, требующая времени и терпения. Поиск дубликатов файлов может быть очень простым, если ваш компьютер работает на GNU/Linux, благодаря утилите ' fdupes '. "
echo " Лицензия: MIT; Домашняя страница: ( https://github.com/adrianlopezroche/fdupes). Подробная документация доступна по адресу: (https://archlinux.org/packages/extra/x86_64/fdupes/ ; https://man.archlinux.org/man/fdupes.1.en). Контактная информация для Адриана Лопеса (электронная почта: adrianlopezroche@gmail.com)"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_fdupes  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_fdupes" =~ [^10] ]]
do
    :
done
if [[ $i_fdupes == 0 ]]; then
echo ""
echo " Установка Fdupes пропущена "
elif [[ $i_fdupes == 1 ]]; then
  echo ""
  echo " Установка Fdupes (удаления дубликатов) "
##### fdupes ######
sudo pacman -S --noconfirm --needed fdupes  # Программа для выявления или удаления дубликатов файлов, находящихся в указанных каталогах ; https://github.com/adrianlopezroche/fdupes ; https://archlinux.org/packages/extra/x86_64/fdupes/ ; https://man.archlinux.org/man/fdupes.1.en 
echo ""
echo " Установка Fdupes выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
########## Справка #################
### Перед началом работы не будет лишним ознакомиться с инструментом, выполнив команду: fdupes --help
# Использование:
# fdupes -r /home/user/downloads
# ключ -r — заставляет искать в том числе и в подкаталогах, ниже заданного.
# Перенаправление в файл — удобно, если список дубликатов слишком большой:
# fdupes -r /home/user/downloads > /home/user/duplicates.txt
# Поиск файлов повторяющихся более одного раза и сохранение результатов в файл:
# awk 'BEGIN{d=0} NF==0{d=0} NF>0{if(d)print;d=1}' /home/user/duplicates.txt > /home/user/duplicates.to.delete.txt
# Заключение всех строк имен файлов в апострофы (чтобы исключить влияние пробелов в именах для следующей команды rm):
# sed "s/\(.*\)/'\1'/" /home/user/duplicates.to.delete.txt > /home/user/duplicates.to.delete.ok.txt
# Файл должен быть с LF переводом строки.
# Заключение всех строк имен файлов в кавычки (чтобы исключить влияние пробелов в именах для следующей команды rm):
# awk '{print "\"" $0 "\""}' /home/user/duplicates.to.delete.txt  > /home/user/duplicates.to.delete.ok.txt
# или
# sed "s/\(.*\)/\"\1\"/" /home/user/duplicates.to.delete.txt > /home/user/duplicates.to.delete.ok.txt
# Файл должен быть с LF переводом строки.
# Удаление файлов, повторяющихся более одного раза:
# xargs rm < /home/user/duplicates.to.delete.ok.txt
# Этой командой производится поиск и удаление (ключ -d) дубликатов без дополнительных подтверждений на удаление (ключ -N) в текущем каталоге: fdupes -d -N /home/user/download
####################################

















clear
echo -e "${MAGENTA}
  <<< Установка файловых менеджеров в Archlinux >>> ${NC}"
# Installing password storage and encryption utilities in Archlinux
echo ""
echo -e "${BLUE}:: ${NC}Установить Double Commander (Двухпанельный файловый менеджер - Аналог Total Commander)?"
echo -e "${MAGENTA}:: ${BOLD}Double Commander - двухпанельный файловый менеджер с открытым исходным кодом, работающий под Linux (два варианта, с использованием библиотек GTK+ или Qt). Программа доступна в двух версиях: с GTK и Qt интерфейсом. Имеет множество возможностей по управлению файлами и обладает большим числом настроек. Язык интерфейса: русский, английский и другие... Лицензия: GNU GPL. Кроме стандартных возможностей файлового менеджера Double Commander поддерживает монтирование сетевых -шар и локальных дисков, легкое создание символических и жестких ссылок, а также имеет много горячих кнопок. ${NC}"
echo " Домашняя страница: https://doublecmd.sourceforge.io/ ; (https://archlinux.org/packages/extra/x86_64/doublecmd-gtk2/ ; https://archlinux.org/packages/extra/x86_64/doublecmd-qt5/ ; https://archlinux.org/packages/extra/x86_64/doublecmd-qt6/). "  
echo -e "${MAGENTA}:: ${BOLD}Описание: Double Commander поддерживает вкладки, может сравнивать файлы и каталоги, поддерживает множественное переименование. Программа имеет расширенные возможности поиска файлов по шаблону, поиска текста в файлах и замены текста. Имеет встроенный редактор текста с подсветкой синтаксиса. Поддерживается работа с архивами, программа может работать с ними как с каталогами. Double Commander обладает большим числом настроек и позволяет настраивать внешний вид. Программа поддерживает плагины. По своей функциональности и оформлению Double Commander напоминает Total Commander и является ему хорошей бесплатной альтернативой в Linux. ${NC}"
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
echo -e "${MAGENTA}
  <<< Установка утилит для хранения паролей и шифрования в Archlinux >>> ${NC}"
# Installing password storage and encryption utilities in Archlinux
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
echo -e "${BLUE}:: ${NC}Установить Функциональный значок в трее для KeePass2 (keepass2-plugin-tray-icon)?" 
echo -e "${CYAN}:: Предисловие! ${NC}Плагины KeePass 2.x, обеспечивающие интеграцию с Linux Desktop. Они в первую очередь нацелены на Ubuntu (но могут работать и на других дистрибутивах). "
echo -e "${MAGENTA}:: ${BOLD}Плагины KeePass 2.x (keepass2-plugin-tray-icon) - это Функциональная иконка в трее для KeePass2.x ; Щелчок левой кнопкой мыши по значку активирует окно KeePass. Щелчок правой кнопкой мыши по значку отображает меню. ${NC}"
echo -e "${MAGENTA}=> ${NC}KeePass2-Plugins (keepass2-plugin-tray-icon) - устанавливается из пользовательского репозитория 'AUR'-'yay' (https://aur.archlinux.org/keepass2-plugin-tray-icon.git), собираются и устанавливаются. "
echo " KeePass Plugins and Extensions (https://keepass.info/plugins.html). " 
echo -e "${YELLOW}:: Примечание! ${NC}Функции: этот пакет конфликтует с keepass2-plugin-status-notifier (вы не можете установить оба одновременно). Сравните использование, чтобы решить, какой пакет вы хотите установить. Также этот пакет конфликтует с keepass2-plugin-application-indicator (вы не можете установить оба одновременно). Сравните использование, чтобы решить, какой пакет вы хотите установить. "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_keeplugin  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_keeplugin" =~ [^10] ]]
do
    :
done 
if [[ $i_keeplugin == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_keeplugin == 1 ]]; then
  echo ""  
  echo " Установка KeePass2-Plugins (keepass2-plugin-tray-icon) "
########## keepass2-plugin-tray-icon ##########
#yay -S keepass2-plugin-tray-icon --noconfirm  # Функциональная иконка в трее для KeePass2 ; https://aur.archlinux.org/keepass2-plugin-tray-icon.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/dlech/Keebuntu ; https://aur.archlinux.org/packages/keepass2-plugin-tray-icon
# yay -Rns keepass2-plugin-tray-icon  # Удалите keepass2-plugin-tray-icon в Arch с помощью YAY
# git clone https://aur.archlinux.org/keepass2-plugin-tray-icon.git ~/keepass2-plugin-tray-icon   # Клонировать git keepass2-plugin-tray-icon локально
git clone https://aur.archlinux.org/keepass2-plugin-tray-icon.git 
# cd ~/keepass2-plugin-tray-icon  # Перейдите в папку ~/keepass2-plugin-tray-icon и установите его
cd keepass2-plugin-tray-icon
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf keepass2-plugin-tray-icon
rm -Rf keepass2-plugin-tray-icon   # удаляем директорию сборки 
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

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
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (edk2-ovmf gnome-system-monitor, gnome-disk-utility, gnome-multi-writer, gpart, frei0r-plugins, fuseiso, clonezilla, crypto++, ddrescue, psensor, copyq, rsync, grsync, numlockx, modem-manager-gui, ranger, pacmanlogviewer, rofi, gsmartcontrol, testdisk, dmidecode, virt-manager, qemu, qemu-guest-agent, putty, w3m)."
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
  sudo pacman -S --noconfirm --needed ddrescue  # Инструмент восстановления данных GNU 
  sudo pacman -S --noconfirm --needed dmidecode  # Утилиты, относящиеся к таблице интерфейса управления рабочим столом
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
  sudo pacman -S --noconfirm --needed qemu-guest-agent  # Гостевой агент QEMU ; https://www.qemu.org/ ; https://archlinux.org/packages/extra/x86_64/qemu-guest-agent/
  sudo pacman -S --noconfirm --needed virt-manager  # Настольный пользовательский интерфейс для управления виртуальными машинами
  sudo pacman -S --noconfirm --needed w3m  # Текстовый веб-браузер, а также пейджер
  sudo pacman -S --noconfirm --needed putty  # Терминальный интегрированный клиент SSH/Telnet
  sudo pacman -S --noconfirm --needed gtk3  # Мультиплатформенный набор инструментов графического интерфейса на основе GObject
  sudo pacman -S --noconfirm --needed gtk2  # Мультиплатформенный набор инструментов GUI на основе GObject (устаревший)
  # sudo pacman -S --noconfirm --needed   #
  # sudo pacman -S --noconfirm --needed --noprogressbar --quiet  #
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
  echo " Установка Приложение GNOME для управления ключами PGP выполнена "
fi
sleep 1
############ Справка ##################### 
### Или:
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
################################

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
############ Справка ####################
# Ссылки: 
# https://github.com/KDE/kleopatra
# https://zenway.ru/page/kleopatra
# https://habr.com/ru/post/316736/ (Сказание о Клеопатре и о российской криптографии)
# Шифрование с помощью GnuPG для пользователей:
# https://jenyay.net/blog/2012/01/04/shifrovanie-s-pomoshhyu-gnupg-dlya-polzovatelejj/
# https://ru.wikipedia.org/wiki/GnuPG
#########################################

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить GtkHash (для вычисления дайджестов сообщений или контрольных сумм)?" 
echo -e "${CYAN}:: Предисловие! ${NC}Утилита GTK+ для вычисления дайджестов сообщений или контрольных сумм. "
echo -e "${MAGENTA}:: ${BOLD}GtkHash - это настольная утилита для вычисления дайджестов сообщений или контрольных сумм. Поддерживаются большинство известных хеш-функций, включая MD5, SHA1, SHA2 (SHA256/SHA512), SHA3 и BLAKE2. ${NC}"
echo -e "${MAGENTA}=> ${NC}GtkHash - устанавливается из пользовательского репозитория 'AUR'-'yay' (https://aur.archlinux.org/gtkhash.git), собираются и устанавливаются. "
echo " Он разработан как простая в использовании графическая альтернатива инструментам командной строки, таким как md5sum. " 
echo -e "${YELLOW}:: Примечание! ${NC}Функции: Поддержка проверки контрольных сумм файлов с помощью sfv, sha256sum и т. д.. Ключевое хеширование (HMAC); Параллельный/многопоточный расчет хэша; Удаленный доступ к файлам с использованием GIO/GVfs; Интеграция файлового менеджера; Маленький и быстрый. GtkHash является свободным программным обеспечением: вы можете распространять его и/или изменять в соответствии с условиями GNU General Public License, опубликованной Free Software Foundation, либо версии 2 Лицензии, либо (по вашему выбору) любой более поздней версии. "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_gtkhash  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_gtkhash" =~ [^10] ]]
do
    :
done 
if [[ $i_gtkhash == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_gtkhash == 1 ]]; then
  echo ""  
  echo " Установка GtkHash "
# yay -S gtkhash --noconfirm  # Утилита GTK+ для вычисления дайджестов сообщений или контрольных сумм ; https://aur.archlinux.org/gtkhash.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/tristanheaven/gtkhash ; https://aur.archlinux.org/packages/gtkhash 
git clone https://aur.archlinux.org/gtkhash.git   # (только для чтения, нажмите, чтобы скопировать) https://aur.archlinux.org/packages/gtkhash
cd gtkhash
#makepkg -fsri  
makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)  
rm -Rf gtkhash  # удаляем директорию сборки
# rm -rf gtkhash 
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${BOLD}Установить сетевые утилиты, VPN, Proxy , драйверы и тд...? ${NC}"
#echo -e "${BLUE}:: ${NC}Установить дополнительные сетевые утилиты, драйверы?"
#echo 'Установить дополнительные сетевые утилиты, драйверы
# Install additional network utilities, drivers
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (#ebtables, ipset ,iproute2, traceroute, nmap, vulscan, wavemon, dsniff, wvdial, libdnet, nbd, broadcom-wl-dkms, linux-atm)."
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
########### VPN #############    
  pacman -S --noconfirm --needed openvpn  # Простой в использовании, надежный и настраиваемый VPN (виртуальная частная сеть) ; https://openvpn.net/index.php/open-source.html ; https://archlinux.org/packages/extra/x86_64/openvpn/
  pacman -S --noconfirm --needed --noprogressbar --quiet networkmanager-openvpn  # Плагин NetworkManager VPN для OpenVPN ; https://networkmanager.dev/docs/vpn/ ; https://archlinux.org/packages/extra/x86_64/networkmanager-openvpn/
  pacman -S --noconfirm --needed openconnect  # Открытый клиент для Cisco AnyConnect VPN ; https://www.infradead.org/openconnect/ ; https://archlinux.org/packages/extra/x86_64/openconnect/
  pacman -S --noconfirm --needed networkmanager-openconnect  # Плагин NetworkManager VPN для OpenConnect ; https://wiki.gnome.org/Projects/NetworkManager ; https://archlinux.org/packages/extra/x86_64/networkmanager-openconnect/
  pacman -S --noconfirm --needed networkmanager-pptp  # Плагин NetworkManager VPN для PPTP ; https://wiki.gnome.org/Projects/NetworkManager ; https://archlinux.org/packages/extra/x86_64/networkmanager-pptp/
  pacman -S --noconfirm --needed vpnc  # Клиент VPN для концентраторов cisco3000 VPN ; https://github.com/streambinder/vpnc ; https://archlinux.org/packages/extra/x86_64/vpnc/
  pacman -S --noconfirm --needed networkmanager-vpnc  # Плагин NetworkManager VPN для VPNC ; https://wiki.gnome.org/Projects/NetworkManager ; https://archlinux.org/packages/extra/x86_64/networkmanager-vpnc/
############ Proxy ###########
  pacman -S --noconfirm --needed privoxy  #  Веб-прокси с расширенными возможностями фильтрации ; https://www.privoxy.org/ ; https://archlinux.org/packages/extra/x86_64/privoxy/
  pacman -S --noconfirm --needed proxychains-ng  # Предварительный загрузчик ловушки, который позволяет перенаправлять TCP-трафик существующих динамически связанных программ через один или несколько SOCKS или HTTP-прокси ; https://github.com/rofl0r/proxychains-ng ; https://archlinux.org/packages/extra/x86_64/proxychains-ng/
  pacman -S --noconfirm --needed mitmproxy  # HTTP-прокси-сервер типа «man-in-the-middle» с поддержкой SSL (https://mitmproxy.org/) ; https://archlinux.org/packages/extra/any/mitmproxy/
  pacman -S --noconfirm --needed network-manager-sstp  # Поддержка SSTP для NetworkManager ; https://gitlab.gnome.org/GNOME/network-manager-sstp ; https://archlinux.org/packages/extra/x86_64/network-manager-sstp/
  pacman -S --noconfirm --needed networkmanager-strongswan  # Плагин Strongswan NetworkManager ; https://wiki.strongswan.org/projects/strongswan/wiki/NetworkManager ; https://archlinux.org/packages/extra/x86_64/networkmanager-strongswan/
  echo ""
  echo -e "${BLUE}:: ${NC}Ставим дополнительные сетевые утилиты"
  pacman -S --noconfirm --needed --noprogressbar --quiet inetutils  # Сборник общих сетевых программ ; https://www.gnu.org/software/inetutils/ ; https://archlinux.org/packages/core/x86_64/inetutils/
  pacman -S --noconfirm --needed ethtool  # Утилита для управления сетевыми драйверами и оборудованием, в частности, для проводных устройств Ethernet ; https://www.kernel.org/pub/software/network/ethtool/ ; https://archlinux.org/packages/extra/x86_64/ethtool/
  pacman -S --noconfirm --needed gnome-nettool  # Графический интерфейс для различных сетевых инструментов для (различных сетевых командных строк - инструменты, такие как ping, netstat, ifconfig, whois, traceroute, finger) ; https://gitlab.gnome.org/GNOME/gnome-nettool ; https://archlinux.org/packages/extra/x86_64/gnome-nettool/
  pacman -S --noconfirm --needed mobile-broadband-provider-info  # Демон сетевого управления (информация о провайдере мобильного широкополосного доступа) ; Предварительные настройки конфигурации APN для мобильных широкополосных подключений ; https://gitlab.gnome.org/GNOME/mobile-broadband-provider-info ; https://www.archlinux.org/packages/extra/any/mobile-broadband-provider-info/
  pacman -S --noconfirm --needed modemmanager  # Служба управления мобильным широкополосным модемом ; https://www.freedesktop.org/wiki/Software/ModemManager/ ; https://archlinux.org/packages/extra/x86_64/modemmanager/
  pacman -S --noconfirm --needed nss-mdns  # Плагин glibc, обеспечивающий разрешение имени хоста через mDNS ; http://0pointer.de/lennart/projects/nss-mdns/ ; https://archlinux.org/packages/extra/x86_64/nss-mdns/
  pacman -S --noconfirm --needed ntp  # Справочная реализация сетевого протокола времени ; https://www.ntp.org/ ; https://archlinux.org/packages/extra/x86_64/ntp/ 
  pacman -S --noconfirm --needed usb_modeswitch  # Активация переключаемых USB-устройств в Linux ; http://www.draisberghof.de/usb_modeswitch/ ; https://archlinux.org/packages/extra/x86_64/usb_modeswitch/
  pacman -S --noconfirm --needed --noprogressbar --quiet iwd  # Демон беспроводной сети Интернет ; https://git.kernel.org/cgit/network/wireless/iwd.git/ ; https://archlinux.org/packages/extra/x86_64/iwd/ 
  pacman -S --noconfirm --needed crda  # Агент центрального регулирующего домена для беспроводных сетей ; https://wireless.wiki.kernel.org/en/developers/regulatory/wireless-regdb ; https://archlinux.org/packages/core/any/wireless-regdb/
# pacman -S --noconfirm --needed wireless-regdb  # Центральная база данных регулирующих доменов ; https://wireless.wiki.kernel.org/en/developers/regulatory/wireless-regdb ; https://archlinux.org/packages/core/any/wireless-regdb/
  pacman -S --noconfirm --needed ndisc6  # Сборник сетевых утилит IPv6 (https://www.remlab.net/ndisc6/) ; https://archlinux.org/packages/extra/x86_64/ndisc6/
  pacman -S --noconfirm --needed gnu-netcat  # GNU переписывает netcat, приложение для создания сетевых трубопроводов (приложения сетевого конвейера) ; сетевая утилита, которая считывает и записывает данные через сетевые соединения, используя протокол TCP/IP ; http://netcat.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/gnu-netcat/
  pacman -S --noconfirm --needed hydra  # Очень быстрый взломщик входа в сеть, который поддерживает множество различных сервисов ; Введите `./hydra -h`, чтобы увидеть все доступные параметры командной строки ; https://github.com/vanhauser-thc/thc-hydra ; https://archlinux.org/packages/extra/x86_64/hydra/
  echo ""
  echo -e "${BLUE}:: ${NC}Установим сетевую инфраструктуру программ и пакетов"
  pacman -Syy  # обновление баз пакмэна (pacman)
########### DNS-запрос и DHCP-сервер #############
  pacman -S --noconfirm --needed bind  # Полная, переносимая реализация протокола DNS ; https://www.isc.org/software/bind/ ; https://archlinux.org/packages/extra/x86_64/bind/
  pacman -S --noconfirm --needed c-ares   # Библиотека AC для асинхронных DNS-запросов ; это современная библиотека DNS (заглушки) resolver ; https://c-ares.org/ ; https://archlinux.org/packages/extra/x86_64/c-ares/   
  pacman -S --noconfirm --needed bind  # Полная, переносимая реализация протокола DNS ; https://www.isc.org/software/bind/ ; https://archlinux.org/packages/extra/x86_64/bind/
  pacman -S --noconfirm --needed netplan  # Средство визуализации абстракции конфигурации сети ; https://github.com/CanonicalLtd/netplan ; https://archlinux.org/packages/extra/x86_64/netplan/
############ Утилиты фильтрации #################
#  sudo pacman -S --noconfirm --needed ebtables  # Утилиты фильтрации Ethernet-моста (на основе nft). ebtables похоже на iptables, но отличается тем, что работает преимущественно не на третьем (сетевом), а на втором (канальном) уровне сетевого стека.
  #sudo pacman -S ebtables  # Утилиты фильтрации Ethernet-моста (на основе nft). ebtables похоже на iptables, но отличается тем, что работает преимущественно не на третьем (сетевом), а на втором (канальном) уровне сетевого стека.
#  AUR ebtables-git  # Фильтрующий инструмент для межсетевого экрана на базе Linux ; https://aur.archlinux.org/ebtables-git.git (только для чтения, нажмите, чтобы скопировать); https://ebtables.netfilter.org/ ; https://aur.archlinux.org/packages/ebtables-git
 ### Это инструмент фильтрации для брандмауэра-моста на базе Linux. Она обеспечивает прозрачную фильтрацию сетевого трафика, проходящего через мост Linux. Возможности фильтрации ограничены фильтрацией на уровне канала и некоторой базовой фильтрацией на более высоких уровнях сети. Также включены расширенные возможности ведения журнала, MAC DNAT/SNAT и brouter. 
############ Утилиты IP-маршрутизации #################
  #sudo pacman -S --noconfirm --needed ipset  # Инструмент администрирования наборов IP (Помечен как устаревший 5 июня 2024 г.); https://netfilter.org/projects/ipset/ ; https://archlinux.org/packages/extra/x86_64/ipset/
  sudo pacman -S ipset  # Инструмент администрирования наборов IP (Помечен как устаревший 5 июня 2024 г.); https://netfilter.org/projects/ipset/ ; https://archlinux.org/packages/extra/x86_64/ipset/
  sudo pacman -S --noconfirm --needed iproute2  # Утилиты IP-маршрутизации ; https://git.kernel.org/pub/scm/network/iproute2/iproute2.git ; https://archlinux.org/packages/core/x86_64/iproute2/
  sudo pacman -S --noconfirm --needed traceroute  # Отслеживает маршрут пакетов по IP-сети ; (http://traceroute.sourceforge.net/); https://archlinux.org/packages/core/x86_64/traceroute/
### Traceroute отслеживает пакеты маршрута, взятые из IP-сети на пути к заданному хосту. Он использует поле времени жизни (TTL) протокола IP и пытается вызвать ответ ICMP TIME_EXCEEDED от каждого шлюза на пути к хосту.
############ Приложение для мониторинга #################
  sudo pacman -S --noconfirm --needed nmap  # Nmap («Network Mapper») - Утилита для обнаружения сети и аудита безопасности ; https://nmap.org/ ; https://archlinux.org/packages/extra/x86_64/nmap/
### Многие системные и сетевые администраторы также считают ее полезной для таких задач, как инвентаризация сети, управление графиками обновления служб и мониторинг времени безотказной работы хоста или службы. 
  sudo pacman -S --noconfirm --needed vulscan  # Модуль, который превращает nmap в сканер уязвимостей ; https://www.computec.ch/projekte/vulscan/ ; https://archlinux.org/packages/extra/any/vulscan/
### Опция nmap -sV включает определение версии для каждой службы, что используется для определения потенциальных недостатков в соответствии с идентифицированным продуктом. Данные ищутся в автономной версии scip VulDB. 
  sudo pacman -S --noconfirm --needed wavemon  # Приложение для мониторинга беспроводных сетевых устройств на базе Ncurses (https://github.com/uoaerg/wavemon); https://archlinux.org/packages/extra/x86_64/wavemon/
### Wavemon— это приложение для мониторинга беспроводных устройств, позволяющее вам следить за уровнями сигнала и шума, статистикой пакетов, конфигурацией устройства и сетевыми параметрами вашего беспроводного сетевого оборудования.  
  sudo pacman -S --noconfirm --needed dsniff  # Сборник инструментов для сетевого аудита и тестирования на проникновение. dsniff, filesnarf, mailsnarf, msgsnarf, urlsnarf и webspy пассивно отслеживают сеть на предмет интересных данных (паролей, электронной почты, файлов и т. д.). arpspoof, dnsspoof и macof облегчают перехват сетевого трафика, который обычно недоступен злоумышленнику (например, из-за переключения уровня 2). sshmitm и webmitm реализуют активные атаки «обезьяна посередине» против перенаправленных сеансов SSH и HTTPS, используя слабые привязки в ad hoc PKI. (https://www.monkey.org/~dugsong/dsniff/); https://archlinux.org/packages/extra/x86_64/dsniff/  (Помечен как устаревший 24 октября 2023 г.)
  sudo pacman -S --noconfirm --needed wvdial # Программа номеронабирателя для подключения к Интернету (Программа-звонилка для подключения к Интернету); https://web.archive.org/web/20110504183753/http://alumnit.ca:80/wiki/index.php?page=WvDial ; https://archlinux.org/packages/extra/x86_64/wvdial/
  sudo pacman -S --noconfirm --needed libdnet  # Упрощенный, переносимый интерфейс для нескольких низкоуровневых сетевых процедур ; https://github.com/ofalk/libdnet ; https://archlinux.org/packages/extra/x86_64/libdnet/
  sudo pacman -S --noconfirm --needed nbd  # Этот пакет содержит nbd-server и nbd-client, инструменты для сетевых блочных устройств, позволяющие использовать удаленные блочные устройства по протоколу TCP/IP ; https://github.com/NetworkBlockDevice/nbd/ ; https://archlinux.org/packages/extra/x86_64/nbd/
  sudo pacman -S --noconfirm --needed c-ares  #  Библиотека AC для асинхронных DNS-запросов ; https://c-ares.org/ ; https://archlinux.org/packages/extra/x86_64/c-ares/
############ Hacking (взлом) Wi-Fi #####################
  sudo pacman -S --noconfirm --needed reaver  # Атака методом подбора пароля на защищенную настройку Wi-Fi ; https://github.com/t6x/reaver-wps-fork-t6x ; https://archlinux.org/packages/extra/x86_64/reaver/ 
#### Reaver реализует атаку методом подбора PIN-кодов регистратора Wi-Fi Protected Setup (WPS) для восстановления парольных фраз WPA/WPA2 , как описано в статье (http://sviehb.files.wordpress.com/2011/12/viehboeck_wps.pdf).
  sudo pacman -S --noconfirm --needed aircrack-ng  # Взломщик ключей для протоколов 802.11 WEP и WPA-PSK ; https://www.aircrack-ng.org/ ; https://archlinux.org/packages/extra/x86_64/aircrack-ng/
### Aircrack- ng — это полный набор инструментов для оценки безопасности сетей WiFi. Основное внимание уделяется различным областям безопасности Wi-Fi (https://www.aircrack-ng.org/).
############ Драйверы и инструменты #####################
  sudo pacman -S --noconfirm --needed broadcom-wl-dkms  # Драйвер беспроводной сети Broadcom 802.11 Linux STA ; https://www.broadcom.com/site-search?filters[pages][content_type][values][]=Downloads&q=802.11%20linux%20sta%20wireless%20driver ; https://archlinux.org/packages/extra/x86_64/broadcom-wl-dkms/
### Эти пакеты содержат гибридный Linux-драйвер IEEE 802.11a/b/g/n компании Broadcom.. для использования с оборудованием на базе BCM4311-, BCM4312-, BCM4313-, BCM4321-, BCM4322-, BCM43224- и BCM43225-, BCM43227- и BCM43228 компании Broadcom.
  sudo pacman -S --noconfirm --needed linux-atm  # Драйверы и инструменты для поддержки сетей ATM (сети банкоматов) под управлением Linux ; http://linux-atm.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/linux-atm/
### Поддержка ATM для Linux в настоящее время находится на стадии пре-альфа. Существует экспериментальный релиз, который поддерживает сырые соединения ATM (PVC и SVC), IP через ATM, эмуляцию LAN, MPOA, Arequipa и некоторые другие вкусности.  
  # sudo pacman -S --noconfirm --needed   #
  # sudo pacman -S --noconfirm --needed --noprogressbar --quiet  #
  echo ""   
  echo " Установка утилит (пакетов) выполнена "
fi
###########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Сетевые утилиты, Tor (service) Torsocks и тд... для конфиденциальности в сети?"
echo -e "${MAGENTA}=> ${BOLD}Большинство людей очень щепетильно относятся к своей конфиденциальности, и им не нравится, когда их контролируют правительства, народы, организации и т.д.. Группа людей также может проживать в странах, где социальные сети и некоторые веб-сайты заблокированы, и им что-то нужно анонимно искать и скачивать в сети. ${NC}"
echo " Tor, который является аббревиатурой Tearing Onion Routing, является бесплатным программным обеспечением с открытым исходным кодом для анонимности в сети. Tor является мультиплатформенным, поэтому вы можете использовать его на всех Gnu / Linux, Windows и Mac. Есть два случая, в которых вы можете использовать Tor: один - вам нужно установить мост для своей службы Tor, потому что в некоторых странах служба Tor может не быть использована, поэтому нам нужно протестировать некоторые мосты, а в другом случае вам просто нужно запустить этот сервис в Arch Linux. "
echo -e "${CYAN}:: ${NC}Что такое Torsocks? Torsocks позволяет вам безопасно использовать большинство приложений с Tor. Он обеспечивает безопасную обработку DNS-запросов и явно отклоняет любой трафик, отличный от TCP, от используемого вами приложения. Torsocks — это разделяемая библиотека ELF, которая загружается перед всеми остальными. Библиотека переопределяет все необходимые вызовы функций libc для интернет-коммуникаций, такие как connect или gethostbyname."
echo -e "${CYAN}:: ${NC}Этот процесс прозрачен для пользователя, и если torsocks обнаруживает любую связь, которая не может пройти через сеть Tor, например, трафик UDP, соединение отклоняется. Если по какой-либо причине torsocks не может предоставить гарантию анонимности Tor вашему приложению, torsocks заставит приложение выйти и остановить все."
echo " ProxyChains — это программа UNIX, которая перехватывает функции libc, связанные с сетью и перенаправляет соединения через SOCKS4a/5 или HTTP-прокси. Поддерживает только TCP (без UDP/ICMP и т. д.)."
echo " Если вы хотите запустить Tor с мостом obfs3, вам следует отредактировать текстовый файл «Torrc» (/etc/tor/torrc). Чтобы запустите службу Tor: (sudo systemctl start tor.service), далее нужно узнать статус Tor, готов сервис к работе: (sudo systemctl status tor.service). Теперь нужно добавить Tor в службы запуска, которые будут загружены после запуска Systemd, поэтому используйте эту команду и включите службу Tor: (sudo systemctl enable tor.service). По умолчанию Tor работает на порту 9050. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим."
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить службы Tor Torsocks и тд...,     0 - НЕТ - Пропустить установку: " i_torify  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_torify" =~ [^10] ]]
do
    :
done
if [[ $i_torify == 0 ]]; then
  echo ""
  echo " Установка Сетевые утилиты, Tor Torsocks и тд... пропущена "
elif [[ $i_torify == 1 ]]; then
  echo ""
  echo " Установка Сетевые утилиты, Tor Torsocks и тд... "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -S --noconfirm --needed tor nyx torsocks gnu-netcat proxychains-ng
sudo pacman -S --noconfirm --needed tor  # Анонимизирующая оверлейная сеть ; https://www.torproject.org/download/tor/ ; https://archlinux.org/packages/extra/x86_64/tor/
sudo pacman -S --noconfirm --needed nyx  # Монитор состояния командной строки для Tor ; С его помощью вы можете получить подробную информацию в реальном времени о вашем ретрансляторе, такую как использование полосы пропускания, соединения, журналы и многое другое ; https://nyx.torproject.org/ ; https://archlinux.org/packages/extra/any/nyx/
sudo pacman -S --noconfirm --needed torsocks  # Оболочка для безопасной торификации приложений ; https://gitlab.torproject.org/tpo/core/torsocks ; https://archlinux.org/packages/extra/x86_64/torsocks/ ; https://archlinux.org/packages/extra/x86_64/torsocks/files/
sudo pacman -S --noconfirm --needed --noprogressbar --quiet gnu-netcat  # GNU-переписывание netcat, приложения сетевого конвейера ; http://netcat.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/gnu-netcat/
sudo pacman -S --noconfirm --needed --noprogressbar --quiet proxychains-ng  # Предварительный загрузчик, позволяющий перенаправлять TCP-трафик существующих динамически связанных программ через один или несколько SOCKS- или HTTP-прокси ; https://github.com/rofl0r/proxychains-ng ; https://archlinux.org/packages/extra/x86_64/proxychains-ng/
  echo ""
  echo " Установка Сетевые утилиты, Tor Torsocks и тд... выполнена "
fi
sleep 03
############ Справка #####################
# tor-сервис (tor-service)
# Настраиваемая конфигурация Tor и файл службы systemd
# https://github.com/steampug/tor-service
# https://github.com/steampug/tor-service.git
##########################################

clear
echo ""
echo -e "${GREEN}==> ${NC}Добавляем в автозагрузку Tor (tor.service) для для конфиденциальности в сети?"
#echo 'Добавляем в автозагрузку Tor (tor.service) для для конфиденциальности в сети?'
echo -e "${YELLOW}:: ${BOLD}Запускаем сервис (tor.service), если таковой был вами установлен. ${NC}"
echo -e "${CYAN}:: ${NC}Вы сможете выполнить запуск (tor.service) позже, воспользовавшись скриптом как шпаргалкой!"
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
    1 - Да добавляем,     0 - НЕТ - Пропустить действие: " auto_tor  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$auto_tor" =~ [^10] ]]
do
    :
done
if [[ $auto_tor == 0 ]]; then
echo ""
echo " Tor (service) не включен в автозагрузку, при необходиости это можно будет сделать. "
elif [[ $auto_tor == 1 ]]; then
  echo ""
  echo " Добавляем в автозагрузку Tor (tor.service) "
#  sudo systemctl enable --now tor.service # Запустить службу Tor
  sudo systemctl enable tor.service  # Добавляем в автозагрузку (tor.service), которые будут загружены после запуска Systemd
  sudo systemctl start tor.service  # запустите службу Tor
#  sudo systemctl status tor.service
echo " Tor (tor.service) успешно добавлен в автозагрузку "
fi
############ Справка #####################
# Остановка сервиса tor:
# sudo systemctl start tor
# sudo systemctl stop tor
# Использование торсов:
# После установки torsocks просто запустите его следующим образом:
# $ torsocks [application]
# Так, например, вы можете использовать ssh для some.ssh.com, выполнив:
# $ torsocks ssh username@some.ssh.com
# Вы можете использовать библиотеку torsocks без предоставленного скрипта:
# $ LD_PRELOAD=/full/path/to/libtorsocks.so your_app
# Через некоторое время запустите эту команду, чтобы узнать, готов Tor или нет:
# $ sudo systemctl status tor.service
# По умолчанию Tor работает на порту 9050. Проверьте это.
#  $ systemctl status tor.service
#  $ ss -nlt
# Тестовое сетевое соединение Tor
# Проверьте ваш текущий публичный IP-адрес
#  $ wget -qO - https://api.ipify.org; echo
# Торифицируйте команду через torsocks
#  $ torsocks wget -qO - https://api.ipify.org; echo
#  $ ## # # должен показывать другой IP-адрес
# Торифицируйте свою оболочку:
# торифицировать оболочку, выдать
#  $ источник torsocks на
#  $ wget -qO - https://api.ipify.org; echo
#  $ # # необходимо показать IP-адрес узла Tor
# Чтобы включить его torsocks навсегда для всех новых оболочек, добавьте его в.bashrc
#  $ echo ". torsocks on" >> ~/.bashrc
#  $ source torsocks on
# Если вы хотите выключить torsocks, попробуйте
#  $ source torsocks off
# Включить порт управления Tor:
# Добавьте к вашему/etc/tor/torrc
#    ControlPort 9051
# Установить пароль управления Tor
# Преобразуйте свой пароль из обычного текста в хэш:
#  $ set +o history # сбросить историю bash
#  $ tor --hash-password ваш_пароль
#  $ set -o history #  установить историю bash

# Добавьте этот хэш к вашему/etc/tor/torrc
#  HashedControlPassword your_hash  # ваш_хэш
# Перезапуск tor
#  $ sudo systemctl restart tor.service
# Проверьте статус порта 9051
#   $ ss -nlt
# Чтобы проверить ваше tor использование
# $ echo -e 'PROTOCOLINFO\r\n' | nc 127.0.0.1 9051
###   echo -e ' ИНФОРМАЦИЯ О ПРОТОКОЛЕ\r\n '  | nc 127.0.0.1 9051
# Чтобы запросить новый канал (IP-адрес) от Tor, используйте
#  $ set +o history
#  $ echo -e 'AUTHENTICATE "my-tor-password"\r\nsignal NEWNYM\r\nQUIT' | nc 127.0.0.1 9051
###   echo -e ' АУТЕНТИФИКАЦИЯ "my-tor-password"\r\nsignal NEWNYM\r\nВЫЙТИ '  | nc 127.0.0.1 9051
#  $ set -o history
####################################

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Wireshark (Анализатор/сниффер сетевого трафика и протоколов)?" 
echo -e "${CYAN}:: ${NC}Wireshark — анализатор трафика (сниффер) для Linux, поддерживает более сотни сетевых протоколов. Анализ, учет и сбор трафика в режиме реального времени. Он доступен во всех основных настольных операционных системах, таких как Windows, Linux, macOS, BSD и других. "
echo -e "${MAGENTA}:: ${BOLD}Wireshark — это бесплатный анализатор сетевых протоколов с открытым исходным кодом, широко используемый во всем мире. С помощью Wireshark вы можете захватывать входящие и исходящие пакеты сети в режиме реального времени и использовать его для устранения неполадок в сети, анализа пакетов, разработки программного обеспечения и протоколов связи и т.д... ${NC}"
echo -e "${MAGENTA}=> ${NC}Кроме непосредственно анализа трафика в программе есть возможность расшифровки зашифрованных пакетов беспроводных сетей. В отличие от консольной утилиты tcpdump у Wireshark есть очень удобный графический интерфейс."
echo " Основные возможности программы: Поддержка огромного количества сетевых протоколов. Анализ сетевых пакетов с разбором и просмотром полей. Захват пакетов в режиме реального времени с возможностью последующего offline анализа. Фильтрация пакетов по полям с использованием логических выражений. Продвинутый VoIP анализ. Поддержка записи и чтения большого числа форматов: tcpdump (libpcap), Pcap NG, Catapult DCT2000, Cisco Secure IDS iplog и другие. Распаковка gzip файлов в реальном режиме времени. Чтение пакетов в режиме реального времени с интерфейсов Ethernet, IEEE 802.11, PPP/HDLC, ATM, Bluetooth, USB, Token Ring, Frame Relay, FDDI и других. Поддержка дешифровки для многих протоколов. Раскрашивание пакетов в разные цвета в соответствии с правилами. Его можно настроить так, чтобы определенные люди могли использовать его без sudo, gksu, etc. Исходный код: Open Source (открыт). Языки программирования:C. Библиотеки: Qt. Приложение переведено на русский язык. Изначально проект назывался Ethereal - 7 июня 2006 г. был переименован в Wireshark. " 
echo -e "${YELLOW}:: Примечание! ${NC}После завершения установки необходимо добавить текущего пользователя в группу wireshark: sudo usermod -aG wireshark $USER (эта функция уже прописана в скрипте); Чтобы изменения применились надо перезагрузить компьютер или перезайти в систему! "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_wireshark  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_wireshark" =~ [^10] ]]
do
    :
done 
if [[ $i_wireshark == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_wireshark == 1 ]]; then
  echo ""  
  echo " Установка Wireshark "
  sudo pacman -S --noconfirm --needed wireshark-cli  # Анализатор/сниффер сетевого трафика и протоколов — инструменты CLI и файлы данных ; https://www.wireshark.org/ ; https://archlinux.org/packages/extra/x86_64/wireshark-cli/ ; https://www.wireshark.org/download.html
  sudo pacman -S --noconfirm --needed wireshark-qt  # Анализатор/сниффер сетевого трафика и протоколов - Qt GUI ; https://www.wireshark.org/ ; https://archlinux.org/packages/extra/x86_64/wireshark-qt/
  sudo pacman -S --noconfirm --needed termshark  # Пользовательский интерфейс терминала для tshark, вдохновленный Wireshark ; https://github.com/gcla/termshark ; https://archlinux.org/packages/extra/x86_64/termshark/  
  echo " Добавить текущего пользователя в группу wireshark "
### На самом деле вам не нужно запускать WireShark от имени root. Пожалуйста, ознакомьтесь с официальной страницей. Вкратце, что вам нужно сделать!  
# sudo groupadd wireshark  # Добавить группу Wireshark, которая имеет разрешение на захват на интерфейсах без необходимости использования sudo
  sudo usermod -aG wireshark $USER  # Добавить текущего пользователя в группу wireshark, которая имеет разрешение на захват на интерфейсах без необходимости использования sudo ; для захвата пакетов, как это делают обычные пользователи.
# sudo usermod -a -G wireshark $USER  # Добавить текущего пользователя в группу wireshark, которая имеет разрешение на захват на интерфейсах без необходимости использования sudo ; sudo usermod -a -G wireshark jonathon
### Например: sudo usermod -aG wireshark "username" ; sudo usermod -aG sudo ugehan
  echo " Изменить права доступа к файлу «dumcap» "
  sudo chgrp wireshark /usr/bin/dumpcap
  sudo chmod o-rx /usr/bin/dumpcap
# sudo chmod 750 /usr/bin/dumpcap
  sudo setcap 'CAP_NET_RAW+eip CAP_NET_ADMIN+eip' /usr/bin/dumpcap
# sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
  sudo getcap /usr/bin/dumpcap
#  wireshark --version  # Узнать Версию программы, можно и с помощью (терминала) 
#  sudo wireshark  # Запуск программы с помощью (терминала) ; На самом деле вам не нужно запускать WireShark от имени root. Пожалуйста, ознакомьтесь с официальной страницей
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
###############

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить KDE Connect (Обеспечение связи между всеми вашими устройствами)?" 
echo -e "${CYAN}:: ${NC}KDE Connect — Добавляет связь между KDE и вашим смартфоном. "
echo -e "${MAGENTA}:: ${BOLD}KDE Connect — это детище Альберта Васа, которое является частью его проекта на Google Summer of Code 2013. Идея KDE Connect — подключить любое устройство к компьютеру с KDE. Сейчас KDE Connect поддерживает подключение устройств Android по сети Wi-Fi к KDE и Gnome и других. Утилита уже встроена в Plasma по умолчанию, а для Gnome есть расширение Gsconnect, которое реализует такие же возможности. Ещё есть порт KDE Connect Windows... ${NC}"
echo -e "${MAGENTA}=> ${NC}KDE Connect состоит из двух компонентов: программы для компьютера и Андроид-приложения. Чтобы программа работала, нужно чтобы Android устройство и компьютер находились в одной локальной сети (Wi-Fi). Android приложение использует протокол UDP для связи с компьютерной частью по локальной сети. После соединения приложение использует защищённый канал на основе открытого ключа."
echo " Основные возможности программы: KDE Connect позволяет: посмотреть заряд батареи; создать общий буфер обмена между устройством и компьютером; удалённо управлять воспроизведением аудио и видео; просматривать уведомления Android на рабочем столе и наоборот; останавливать музыку во время звонка; отправлять ping-сообщения между Android и рабочим столом; передавать файлы, ссылки или текст между устройством и компьютером; просматривать уведомления о вызовах и СМС на компьютере; настроить общую папку для компьютера и телефона в файловой системе; использовать телефон в качестве сенсорной панели для компьютера;
выполнять на компьютере ранее настроенные команды. " 
echo -e "${YELLOW}:: Примечание! ${NC}Если модуль KDE запущен, то компьютер готов. Теперь вам необходимо установить приложение KDE Connect. Выберите в приложении в меню Устройства -> Подключить новое. Затем выберите ваш компьютер в списке устройств и нажмите на кнопку Запросить сопряжение.Сразу же после этого на компьютере появится запрос на подтверждение сопряжения. Нажмите кнопку Принять. "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_kdeconnect  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_kdeconnect" =~ [^10] ]]
do
    :
done 
if [[ $i_kdeconnect == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_kdeconnect == 1 ]]; then
  echo ""
  echo " Установка KDE Connect (Обеспечение связи между всеми вашими устройствами)"
  sudo pacman -S --noconfirm --needed kdeconnect  # KDE Connect - Добавляет связь между KDE и вашим смартфоном ; https://kdeconnect.kde.org/ ; https://archlinux.org/packages/extra/x86_64/kdeconnect/
  echo ""
  echo " Установка утилит (пакетов) выполнена "
fi
###########

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить DNSmasq сервер пересылки DNS и DHCP-сервер?"
echo " Также добавим dnsmasq в автозагрузку (для проводного интернета, который получает настройки от роутера). "
echo -e "${CYAN}:: ${NC}DNSmasq - DNS-сервер, DHCP-сервер с поддержкой DHCPv6 и PXE и ​​TFTP-сервер. Легкий и имеет небольшой размер, простой в настройке сервер пересылки DNS и DHCP-сервер, подходит для маршрутизаторов и брандмауэров с ограниченными ресурсами. DNSmasq также может быть настроен для кэширования DNS-запросов для улучшения скорости поиска DNS на ранее посещенных сайтах. "
echo -e "${YELLOW}==> ${NC}Будьте внимательны! При запуске сервера dnsmasq - служба Dhcpcd (реализация клиента DHCP и DHCPv6) будет ОСТАНОВЛЕНА И ОТКЛЮЧЕНА!!! Также перед запуском сервера dnsmasq нужно будет отредактировать в /etc/ файлы dnsmasq.conf ; resolv.conf Обязательно защитите его от изменений (перезаписи) как описано (https://wiki.archlinux.org/title/Domain_name_resolution#Overwriting_of_/etc/resolv.conf) ; resolvconf.conf ; dnsmasq-resolv.conf ; NetworkManager.conf ;  создать файл /etc/NetworkManager/dnsmasq.d/cache.conf  и отредактировать его. Использованная литература:(https://wiki.archlinux.org/title/Dnsmasq ; https://wiki.archlinux.org/title/Dnsmasq#Test ; https://eax.me/archlinux-on-desktop/)"
echo " Если вы используете NetworkManager (что, скорее всего, так и есть), то сделайте /etc/resolv.conf его неизменяемым, чтобы избежать перезаписи файла после перезагрузки. (sudo chattr +i /etc/resolv.conf) "
echo " Если необходимо добавить службу DNSmasq в автозагрузку и сделать необходимые настройки (конфиги) это можно сделать уже в установленной системе Arch'a "
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Установить и Включить dnsmasq,    0 - Нет - пропустить этот шаг: " x_dnsmasq   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_dnsmasq" =~ [^10] ]]
do
    :
done
if [[ $x_dnsmasq == 1 ]]; then
  echo ""
sudo pacman -S --noconfirm --needed dnsmasq  # Легкий, простой в настройке сервер пересылки DNS и DHCP-сервер ; http://www.thekelleys.org.uk/dnsmasq/doc.html ; https://archlinux.org/packages/extra/x86_64/dnsmasq/
# Dnsmasq предоставляет сетевую инфраструктуру для небольших сетей: DNS, DHCP, объявление маршрутизатора и сетевая загрузка.
#sudo pacman -Syu --noconfirm --needed dnsmasq
sudo systemctl disable dnsmasq  # Ставим dnsmasq, но убеждаемся, что он выключен
  # systemctl status dnsmasq.service
  echo " Отключения Службы Dhcpcd (реализация клиента DHCP и DHCPv6) "
###### Отключить dhcpcd #######  
sudo systemctl stop dhcpcd
sudo systemctl disable dhcpcd
# systemctl disable dhcpcd && systemctl stop dhcpcd
  echo " Служба Dhcpcd (реализация клиента DHCP и DHCPv6) ОСТАНОВЛЕНА И ОТКЛЮЧЕНА!!! "
  echo ""
  echo " Добавим dnsmasq в автозагрузку (для проводного интернета, DNS, DHCP, объявление маршрутизатора и сетевая загрузка). "
sudo systemctl enable dnsmasq.service  
sudo systemctl start dnsmasq.service   # Then start/enable dnsmasq.service
# sudo systemctl enable dnsmasq && systemctl start dnsmasq
# sudo systemctl status dnsmasq.service
  echo " DNSmasq успешно добавлен в автозагрузку "
elif [[ $x_dnsmasq == 0 ]]; then
fi
  echo " Чтобы выполнить тест скорости поиска, выберите веб-сайт, который не посещался с момента запуска dnsmasq "
sudo drill archlinux.org | grep "Query time"  # Тест dnsmasq
  echo " Выполним опрос DNS-сервера: '1.1.1.1' (@cервер) с запросом archlinux.org (доменное имя интернет-ресурса) "
sudo dig @1.1.1.1 archlinux.org  # для опроса DNS-серверов
######################

echo ""
echo -e "${GREEN}==> ${NC}Настройка DNSmasq сервер пересылки DNS и DHCP-сервер"
echo " Настройка dnsmasq для сокращения времени, затрачиваемого на разрешение DNS. "
echo " Создать файл dnsmasq.conf в /etc "
### Теперь анонсируем через него наш сервер
# nano /etc/dnsmasq.conf
touch /etc/dnsmasq.conf   # Создать файл dnsmasq.conf в /etc
ls -l /etc/dnsmasq.conf   # ls — выводит список папок и файлов в текущей директории
sleep 1
echo " Пропишем конфигурацию для dnsmasq в /etc/dnsmasq.conf "
> /etc/dnsmasq.conf
cat <<EOF >>/etc/dnsmasq.conf
 listen-address=::1,127.0.0.1
 cache-size=1000
 no-resolv
 server=8.8.8.8
 server=8.8.4.4

EOF
######################
echo ""
echo " Для начала сделаем его бэкап /etc/dnsmasq.conf "
cp /etc/dnsmasq.conf  /etc/dnsmasq.conf.back_`date +"%d.%m.%y_%H-%M"`
echo ""
echo " Просмотреть содержимое файла /etc/dnsmasq.conf "
cat /etc/dnsmasq.conf  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 3
###################
echo ""
echo " Редактировать файл resolv.conf в /etc "
echo -e "${YELLOW}==> ${NC}В идеале отключитесь от сети/интернета, затем откройте файл /etc/resolv.conf и измените его по своему усмотрению! Но мы же НЕ ищем лёгких путей и попробуем так! "
echo " Разблокируем файл resolv.conf в /etc (который был заблокирован даже для суперпользователя, чтобы предотвратить перезапись программами /etc/resolv.conf, был установлен атрибут неизменяемости: chattr +i /etc/resolv.conf ) "
### Чтобы разблокировать файл, введите в терминале следующее:
sudo chattr -i /etc/resolv.conf
echo " Пропишем конфигурацию для resolv в /etc/resolv.conf "
> /etc/resolv.conf
cat <<EOF >>/etc/resolv.conf
 nameserver ::1
 nameserver 127.0.0.1
 options trust-ad

EOF
######################
echo ""
echo " Просмотреть содержимое файла resolv.conf "
cat /etc/resolv.conf  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 3
######################
echo ""
echo " Вновь заблокируем содержимое файла resolv.conf "
echo " Это заблокирует файл /etc/resolv.conf, никто не сможет его редактировать. Даже суперпользователь не сможет этого сделать (sudo). (Если, конечно, вы не разблокируете файл) (sudo chattr -i /etc/resolv.conf) "
### отключитесь от сети/интернета, затем откройте файл /etc/resolv.conf и измените его по своему усмотрению!
sudo chattr +i /etc/resolv.conf
######################
echo ""
echo " Далее отредактируйте содержимое файла NetworkManager.conf в /etc/NetworkManager/ "
echo " Раскомментируйте строку #dns=dnsmasq в разделе [main], которая ранее была прописана при установки системы в NetworkManager.conf "
sudo sed -i 's/#dns=dnsmasq/dns=dnsmasq/' /etc/NetworkManager/NetworkManager.conf  # раскомментируем в /etc/NetworkManager/NetworkManager.conf
# sudo sed -i '/#dns=dnsmasq/ s/^#//' /etc/NetworkManager/NetworkManager.conf
######################
echo ""
echo " Увеличим размер кэша (по умолчанию хранится 450 записей) для dnsmasq "
echo " Создать файл cache.conf в /etc/NetworkManager/dnsmasq.d/ "
### Теперь анонсируем через него наш сервер
# nano /etc/NetworkManager/dnsmasq.d/cache.conf
touch /etc/NetworkManager/dnsmasq.d/cache.conf   # Создать файл dnsmasq.conf в /etc
ls -l /etc/NetworkManager/dnsmasq.d   # ls — выводит список папок и файлов в текущей директории
sleep 1
echo " Пропишем конфигурацию для dnsmasq в /etc/NetworkManager/dnsmasq.d/cache.conf "
> /etc/NetworkManager/dnsmasq.d/cache.conf
cat <<EOF >>/etc/NetworkManager/dnsmasq.d/cache.conf
 cache-size=10000

EOF
######################
cat /etc/NetworkManager/dnsmasq.d/cache.conf  # cat читает данные из файла или стандартного ввода и выводит их на экран
echo " Перезапустить dnsmasq "
sudo systemctl restart dnsmasq   # Перезапустить dnsmasq
# sudo systemctl enable dnsmasq && systemctl start dnsmasq
# sudo systemctl status dnsmasq.service
### Остановите dhcpcd , он нам больше не нужен.
# sudo systemctl disable dhcpcd && systemctl stop dhcpcd
sudo systemctl restart NetworkManager
echo " Теперь NetworkManager будет автоматически запускать dnsmasq с нужными параметрами "
### Настройка DNSmasq:
# Настройка dnsmasq для сокращения времени, затрачиваемого на разрешение DNS
# Редактировать/etc/dnsmasq.conf Раскомментируйте и приведённые ниже строки в файле или просто добавьте их к нему
# listen-address=::1,127.0.0.1
# cache-size=1000
# no-resolv
# server=8.8.8.8
# server=8.8.4.4
### Редактировать/etc/resolv.conf
# nameserver ::1
# nameserver 127.0.0.1
# options trust-ad
### Если вы используете NetworkManager (что, скорее всего, так и есть), то сделайте /etc/resolv.confего неизменяемым , чтобы избежать перезаписи файла после перезагрузки
# sudo chattr +i /etc/resolv.conf
### Далее в /etc/NetworkManager/NetworkManager.conf пишем:
# [main]
# dns=dnsmasq
### Чтобы увеличить размер кэша (по умолчанию хранится 450 записей), создайте файл /etc/NetworkManager/dnsmasq.d/cache.conf с таким содержимым:
# cache-size=10000
### Перезапустить dnsmasq
# sudo systemctl restart dnsmasq
### Остановите dhcpcd , он нам больше не нужен.
# sudo systemctl disable dhcpcd && systemctl stop dhcpcd
### Затем говорим:
# sudo systemctl restart NetworkManager
### Теперь NetworkManager будет автоматически запускать dnsmasq с нужными параметрами и прописывать его в /etc/resolv.conf. Для получения информации о текущем статусе dnsmasq можно сказать:
# sudo killall -s USR1 dnsmasq
# … и почитать вывод journalctl -r.
### Использованная литература: dnsmasq  (https://wiki.archlinux.org/title/Dnsmasq)
########################
Судя по страницам руководства systemd, он не предназначен для того, чтобы вручную отключать заглушку DNS-сервера. Интересно, что я заметил только описанную проблему после обновления systemd с 230 до 231.

Отключение systemd-resolved не было для меня опцией, потому что мне нужно было обрабатывать полученные исходящие DNS-серверы через DHCP.

Моим решением было сделать dnsmasq stop systemd-resolved перед запуском и запустить его потом снова.

Я создал дроп-ин конфигурацию в /etc/systemd/system/dnsmasq.service.d/resolved-fix.conf:

[Unit]
After=systemd-resolved.service

[Service]
ExecStartPre=/usr/bin/systemctl stop systemd-resolved.service
ExecStartPost=/usr/bin/systemctl start systemd-resolved.service
Это выглядит довольно хакерским решением, но оно работает.
############################

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Chrony альтернативный клиент и сервер NTP?"
echo " Также добавим dnsmasq в автозагрузку (для проводного интернета, который получает настройки от роутера). "
echo -e "${CYAN}:: ${NC}Chrony - это альтернативный клиент и сервер NTP , поддерживающий роуминг и разработанный специально для систем, которые не всегда подключены к сети. Chrony — это гибкая реализация протокола сетевого времени Network Time Protocol (NTP). Используется для синхронизации системных часов с различных NTP-серверов, эталонных часов или с помощью ручного ввода. "
echo -e "${YELLOW}==> ${NC}Также можно его использовать как сервер NTPv4 для синхронизации времени других серверов в той же сети. Сервис предназначен для безупречной работы в различных условиях, таких как прерывистое сетевое подключение, перегруженные сети, изменение температуры, что может повлиять на отсчет времени в обычных компьютерах. После запуска chrony нужно будет отредактировать в /etc/ файл chrony.conf . Этот файл настраивает демон chronyd . Скомпилированное местоположение - /etc/chrony.conf . Другие местоположения можно указать в командной строке chronyd с помощью опции -f . В нем нужно закомментировать используемый пул и добавить свои NTP сервера. А также можно указать разрешённую сеть для клиентов. "
echo " При установке этого пакета будет создана одноименная служба, которая будет запущена и помещена в автозапуск. А служба systemd-timesyncd будет выключена. Служба этого приложения – chrony. Конфигурационный файл – /etc/chrony/chrony.conf. Серверный процесс – chronyd. Утилита для получения информации – chronyc. Конфигом для службы является файл /etc/chrony/chrony.conf. По умолчанию клиентам не разрешен доступ, т.е. chronyd работает исключительно как клиент NTP. Если используется директива allow , chronyd будет и клиентом своих серверов, и сервером для других клиентов. Сервер времени chrony, также как и другие NTP сервера слушает порт udp 123 . "
echo " Использованная литература:(https://wiki.archlinux.org/title/Chrony ; https://chrony-project.org/ ; https://man.archlinux.org/man/chrony.conf.5 ; https://antons-organization-1.gitbook.io/administrirovanie-linux/servisy-linux/protokol-ntp/nastroika-ntp-servera) "
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Установить Chrony,    0 - Нет - пропустить этот шаг: " x_chrony   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_chrony" =~ [^10] ]]
do
    :
done
if [[ $x_chrony == 1 ]]; then
  echo ""
sudo pacman -S --noconfirm --needed chrony  # Легкий клиент и сервер NTP ; https://chrony-project.org/ ; https://archlinux.org/packages/extra/x86_64/chrony/
  echo ""
  echo " Добавим dnsmasq в автозагрузку (для проводного интернета, DNS, DHCP, объявление маршрутизатора и сетевая загрузка). "
sudo systemctl enable dnsmasq.service  
sudo systemctl start dnsmasq.service   # Then start/enable dnsmasq.service
# sudo systemctl enable dnsmasq && systemctl start dnsmasq
# sudo systemctl status dnsmasq.service
  echo " DNSmasq успешно добавлен в автозагрузку "
elif [[ $x_chrony == 0 ]]; then
fi
  echo " Чтобы выполнить тест скорости поиска, выберите веб-сайт, который не посещался с момента запуска dnsmasq "
sudo drill archlinux.org | grep "Query time"  # Тест dnsmasq
  echo " Выполним опрос DNS-сервера: '1.1.1.1' (@cервер) с запросом archlinux.org (доменное имя интернет-ресурса) "
sudo dig @1.1.1.1 archlinux.org  # для опроса DNS-серверов
######################
### Настройка DNSmasq:

После настройки сервера нужно перезапустить службу:

# systemctl restart chrony

#########################################
### Setup NTP servers
#########################################
sed -i "/^pool.*\$/ s/^/#/" /etc/chrony/chrony.conf
sed -i "/^server.*\$/ s/^/#/" /etc/chrony/chrony.conf

for dc in $DOMAIN_CONTROLLERS;
do
echo "server $dc iburst" | sudo tee -a /etc/chrony/chrony.conf
done

#########################################
server ntp.lab.int iburst
driftfile /var/lib/chrony/drift
makestep 1.0 3
rtcsync
keyfile /etc/chrony.keys
leapsectz right/UTC
logdir /var/log/chrony
[ Download the Manage your Linux environment for success eBook to learn ways to streamline your work. ]

After applying the configuration changes, restart the chronyd service and verify it is up and running. Finally, check the NTP sources and confirm that the system clock is synchronized correctly to the upstream time server:

$ sudo systemctl restart chronyd.service

$ systemctl is-active chronyd.service
active

$ chronyc sources



systemd-timesyncd

Демон systemd timesync предоставляет реализацию NTP, которой легко управлять в контексте systemd. Он устанавливается по умолчанию в Fedora и Ubuntu. Однако запускается он по умолчанию только в Ubuntu. Я не уверен насчёт других дистрибутивов. Вы можете проверить у себя сами:

[root@testvm1 ~]# systemctl status systemd-timesyncd

Конфигурирование systemd-timesyncd

Файл конфигурации для systemd-timesyncd — это /etc/systemd/timesyncd.conf. Это простой файл с меньшим количеством включенных опций, чем в старых сервисах NTP и chronyd. Вот содержимое этого файла (без дополнительных изменений) на моей виртуальной машине с Fedora:

#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.
#
# Entries in this file show the compile time defaults.
# You can change settings by editing this file.
# Defaults can be restored by simply deleting this file.
#
# See timesyncd.conf(5) for details.

[Time]
#NTP=
#FallbackNTP=0.fedora.pool.ntp.org 1.fedora.pool.ntp.org 2.fedora.pool.ntp.org 3.fedora.pool.ntp.org
#RootDistanceMaxSec=5
#PollIntervalMinSec=32
#PollIntervalMaxSec=2048




Единственный раздел, который он содержит, кроме комментариев, это [Time]. Все остальные строки закомментированы. Это значения по умолчанию, их не нужно менять (если у вас нет для этого причин). Если у вас нет сервера времени NTP, определенного в строке NTP =, по умолчанию в Fedora используется резервный сервер времени Fedora. Я обычно добавляю свой сервер времени:

NTP=myntpserver
NTP=server 0.ru.pool.ntp.org


...
# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (http://www.pool.ntp.org/join.html).
#pool 2.fedora.pool.ntp.org iburst
server 0.africa.pool.ntp.org iburst
server 1.africa.pool.ntp.org iburst
server 2.africa.pool.ntp.org iburst
server 3.africa.pool.ntp.org iburst

...

     server 0.europe.pool.ntp.org
     server 1.europe.pool.ntp.org
     server 2.europe.pool.ntp.org
     server 3.europe.pool.ntp.org


Запуск timesync

Запустить и сделать systemd-timesyncd активным можно так:

systemctl enable systemd-timesyncd.service
systemctl start systemd-timesyncd.service
#systemctl status systemd-timesyncd.service
systemctl status systemd-timesyncd
  echo " Установка времени по серверу NTP (Network Time Protocol)(ru.pool.ntp.org) "
  sudo ntpdate 0.ru.pool.ntp.org  # будем использовать NTP сервера из пула ru.pool.ntp.org
# sudo ntpdate 1.ru.pool.ntp.org  # Список общедоступных NTP серверов доступен на сайте http://ntp.org
# sudo ntpdate 2.ru.pool.ntp.org  # Отредактируйте /etc/ntp.conf для добавления/удаления серверов (server)
# sudo ntpdate 3.ru.pool.ntp.org  # После изменений конфигурационного файла вам надо перезапустить ntpd (sudo service ntp

Российская Федерация — ru.pool.ntp.org
Чтобы использовать эту конкретную зону пула, добавьте в файл ntp.conf следующее:

     server 0.ru.pool.ntp.org
     server 1.ru.pool.ntp.org
     server 2.ru.pool.ntp.org
     server 3.ru.pool.ntp.org

В большинстве случаев лучше всего использовать pool.ntp.org для поиска сервера NTP (или 0.pool.ntp.org, 1.pool.ntp.org и т. д., если вам нужно несколько имен серверов). Система попытается найти ближайшие доступные серверы для вас. Если вы распространяете программное обеспечение или оборудование, использующее NTP, ознакомьтесь с нашей информацией для поставщиков .




###########################
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
############ Справка ####################
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
sudo pacman -S --noconfirm --needed exfat-utils fuse-exfat  # Утилиты для файловой системы exFAT; Модуль FUSE - Утилиты для файловой системы exFAT ; https://github.com/relan/exfat ; https://archlinux.org/packages/extra/x86_64/exfat-utils/
# Важно! exfatprogs и exfat-utils (У них конфликтующие зависимости) - Ставим один из пакетов иначе конфликт!
# sudo pacman -S exfatprogs --noconfirm  # Утилиты файловой системы exFAT файловой системы в пространстве пользователя драйвера ядра Linux файловой системы exFAT
fi
############# Справка ####################
# Форматирую флешку (жесткий диск) под ArchLinux:
# mkfs.exfat /dev/sdc
# В Linux все проходит нормально. Носитель открывается, файлы копируются.
# Теоретический максимальный размер раздела FAT32 - 2 Тб, но Майкрософт начиная с WinXP не позволяет создать больше 32 Гб. exFAT, это модифицированная FAT32, которую можно «развернуть» на разделе более чем 32 Гб.
################################

clear
echo -e "${CYAN}
  <<< Установка Сетевых утилит - Avahi, SSH, Samba, Tor ,Torsocks и т.д. для системы Arch Linux >>> ${NC}"
##### SSH (client) ###
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
sudo pacman -S --noconfirm --needed openssh  # Реализация протокола SSH для удаленного входа в систему, выполнения команд и передачи файлов ; https://www.openssh.com/portable.html ; https://archlinux.org/packages/core/x86_64/openssh/ 
sudo pacman -S --noconfirm --needed libssh  # Библиотека для доступа к клиентским службам ssh через библиотеки C ; https://www.libssh.org/ ; https://archlinux.org/packages/extra/x86_64/libssh/ ; https://github.com/vanhauser-thc/thc-hydra
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
#sudo systemctl enable sshd.socket  # чтобы сервер SSH стартовал только после поступления запроса на подключение, а не висел мёртвым грузом в оперативной памяти  
sudo systemctl enable sshd.service
# sudo systemctl start sshd.service
# !На сервере запустить и включить сервис в автостарт
# sudo systemctl start sshd
# sudo systemctl enable sshd
echo " Сервис sshd успешно добавлен в автозагрузку "
echo ""
echo " Если на вашем сервере используется фаервол UFW (надо разрешить удалённое подключение к порту 22)"
#sudo ufw allow ssh   # вам надо разрешить удалённое подключение к порту 22
fi

######## Avahi ##############
clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Avahi на Arch Linux - для анализ локальной сети на предмет выявления различных сервисов?"
#echo -e "${BLUE}:: ${NC}Установить Avahi на Arch Linux - для анализ локальной сети на предмет выявления различных сервисов?"
#echo 'Установить Avahi на Arch Linux - для анализ локальной сети на предмет выявления различных сервисов?'
# Install Avahi on Arch Linux - to analyze the local network to identify various services?
echo -e "${MAGENTA}:: ${BOLD}Avahi —  это свободная Linux-реализация протокола, также известного как ("Rendezvous" или "Bonjour") для дистрибутивов Linux и BSD. Распространяется под лицензией LGPL. Avahi — система, производящая анализ локальной сети на предмет выявления различных сервисов. К примеру, вы можете подключить ноутбук к локальной сети и сразу получить информацию об имеющихся принтерах, разделяемых ресурсах, сервисах обмена сообщениями и прочих услугах. ${NC}"
echo " Давайте разберемся с терминологией: "
echo " Avahi — открытая и свободная реализация протокола zeroconf. Zeroconf — это протокол, разработанный Apple и призванный решать следующие проблемы: выбор сетевого адреса для устройства; выбор сетевого адреса для устройства; обнаружение сервисов, например принтеров. Bonjour — open-source реализация протокола zeroconf от Apple. "
echo -e "${CYAN}:: ${NC}Его цель - позволить устройствам, подключенным к локальной сети, транслировать свой IP-адрес вместе с их функцией. Следовательно, принтер может время от времени передавать: мой IP-адрес - xxx.xxx.xx.xx и я могу распечатать любой документ postscript с ipp prottocol; NAS может сказать: мой IP-адрес - xxx.xxx.xx.xx и я могу транслировать музыку, сохранять ваши резервные копии и действовать как файловый сервер. Если это не то, что вы хотите услышать в своей сети, вы можете остановить / отключить avahi daemon стандартной командой systemctl, но если вы запустите cups-broadcast daemon , он запустит avahi сам. Linux использует вымышленных пользователей обычно из соображений безопасности, чтобы не давать злоумышленнику ни малейшего шанса взломать процесс, принадлежащий root. Таким образом, вы можете видеть postfix или mail, и postgres или mysql пользователей. Демон, принадлежащий такому непривилегированному пользователю, дает меньше шансов злоумышленнику получить права суперпользователя."
echo " Определенно да, avahi daemon прослушивает UDP-порт 5353. Вы можете проверить это с помощью команды netstat -lup или ss -lup от имени суперпользователя. Для назначения IP-адресов устройствам, zeroconf использует RFC 3927. Стандарт описывает назначение, так называемых link-local адресов, из диапазона 169.254.0.0/16. Технология называется IPv4 Link-Local или IPv4LL. Для поиска и обнаружения сервисов используется протокол DNS based Service Discovery или DNS-SD. Для того, чтобы прорекламировать, какие сервисы доступны на устройстве, используются DNS-записи типа SRV, TXT, PTR. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_avahi  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_avahi" =~ [^10] ]]
do
    :
done
if [[ $i_avahi == 0 ]]; then
echo ""
echo " Установка пропущена "
elif [[ $i_avahi == 1 ]]; then
  echo ""
  echo " Установка (avahi) "
sudo pacman -S --noconfirm --needed --noprogressbar --quiet avahi  # Обнаружение служб для Linux с использованием mDNS/DNS-SD (совместимо с Bonjour) ; https://github.com/avahi/avahi ; https://archlinux.org/packages/extra/x86_64/avahi/
sudo pacman -S --noconfirm --needed pacredir  # Перенаправление запросов pacman с помощью обнаружения служб avahi ; https://github.com/eworm-de/pacredir ; https://archlinux.org/packages/extra/x86_64/pacredir/ 
############# Справка ####################
### pacredir - перенаправление запросов pacman с помощью обнаружения сервиса avahi
### По умолчанию каждая установка Arch Linux загружает файлы своих пакетов с онлайн-зеркал, передавая все данные через WAN-соединение.
### Но часто могут быть другие системы Arch, которые уже имеют файлы, доступные на локальном хранилище - просто быстрое LAN-подключение. Это то, что pacredirможет помочь. Он использует Avahi для поиска других экземпляров и получения файлов там, если они доступны.
# Включите службы systemd pacserve, pacredir откройте порт TCP 7078 и добавьте следующую строку в определения репозитория pacman.conf:
# Include = /etc/pacman.d/pacredir
# Чтобы лучше понять, что происходит в фоновом режиме, взгляните на схему потока запросов (https://github.com/eworm-de/pacredir/blob/main/FLOW.md).
echo ""
echo " Avahi установлен "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Добавляем в автозагрузку avahi (avahi-daemon.service) для выбор сетевого адреса для устройства?"
#echo 'Добавляем в автозагрузку avahi (avahi-daemon.service) для выбор сетевого адреса для устройства?'
# Adding avahi (avahi-daemon.service) to the startup to select the network address for the device?
echo -e "${YELLOW}:: ${BOLD}Запускаем сервис (avahi-daemon.service), если таковой был вами установлен. ${NC}"
echo -e "${CYAN}:: ${NC}Вы сможете выполнить запуск (avahi-daemon.service) позже, воспользовавшись скриптом как шпаргалкой!"
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
    1 - Да добавляем,     0 - НЕТ - Пропустить действие: " auto_avahi  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$auto_avahi" =~ [^10] ]]
do
    :
done
if [[ $auto_avahi == 0 ]]; then
echo ""
echo "  Сервис avahi не включен в автозагрузку, при необходиости это можно будет сделать. "
elif [[ $auto_avahi == 1 ]]; then
  echo ""
  echo " Добавляем в автозагрузку (avahi-daemon.service)"
  sudo systemctl enable --now avahi-daemon.service 
# sudo systemctl enable avahi-daemon.service  # Добавляем в автозагрузку (avahi-daemon.service)
  sudo systemctl start avahi-daemon.service
echo " Сервис avahi успешно добавлен в автозагрузку "
fi
###############
### Примеры конфигураций услуг
echo ""
echo -e "${GREEN}==> ${NC}Добавляем Сервер блока сообщений сервера/общей файловой системы Интернета (SMB/CIFS)"
echo -e "${MAGENTA}:: ${BOLD}Примечание: этот файл службы Avahi понадобится только при использовании версии Samba до v3.3.x, поскольку последующие версии предоставляют ключи конфигурации для управления объявлениями ZeroConf серверов из собственного основного файла конфигурации « smb.conf ». Если демон Avahi запущен как на сервере, так и на клиенте, файловый менеджер на клиенте должен автоматически найти сервер. ${NC}"
echo -e "${CYAN}:: ${NC}Следующая конфигурация объявит сервер Samba (на порту TCP по умолчанию 445). Браузер Kodi ZeroConf отобразит эту запись как Samba на <имя сервера> . При проверке этой записи Kodi отобразит доступные общие ресурсы как содержимое следующего URL:smb://<ip of server>:445."
echo " Создать файл smb.service в /etc/avahi/services/ "
### Теперь анонсируем через него наш сервер
# nano /etc/avahi/services/smb.service
touch /etc/avahi/services/smb.service   # Создать файл /smb.service в /etc
ls -l /etc/avahi/services/smb.service   # ls — выводит список папок и файлов в текущей директории
sleep 1
echo " Пропишем конфигурацию для сервер Samba (на порту TCP по умолчанию 445) в /etc/avahi/services/smb.service "
> /etc/avahi/services/smb.service
cat <<EOF >>/etc/avahi/services/smb.service
<?xml version="1.0" standalone='no'?>
# <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
 <name replace-wildcards="yes">%h</name>
 <service>
   <type>_smb._tcp</type>
   <port>445</port>
 </service>
 <service>
   <type>_device-info._tcp</type>
   <port>0</port>
   <txt-record>model=RackMac</txt-record>
 </service>
</service-group>

EOF
######################

echo ""
echo -e "${GREEN}==> ${NC}Добавляем Сервер сетевой файловой системы (NFS)"
echo -e "${MAGENTA}:: ${BOLD}Примечание: Если у вас настроен общий ресурс NFS , вы можете использовать Avahi для автоматического монтирования его в браузерах с поддержкой Zeroconf (например, Konqueror в KDE и Finder в macOS) или файловых менеджерах, таких как GNOME/Files. ${NC}"
echo " Порт правильный, если в вашем есть insecure в качестве опции /etc/exports; в противном случае его необходимо изменить (обратите внимание, что insecure требуется для клиентов macOS). Путь — это путь к вашему экспорту или его подкаталогу. По какой-то причине функциональность автомонтирования была удалена из Leopard, однако доступен скрипт. "
echo -e "${CYAN}:: ${NC}Следующая конфигурация объявит сервер NFS (работающий на порту NFS по умолчанию 2049) с экспортированным путем /path/to/nfsexport. Браузер Kodi ZeroConf отобразит эту запись как сервер NFS по адресу <имя сервера> . "%h" — это подстановочная переменная, которая заменяется именем хоста устройства, предоставляющего службу. При проверке этой записи Kodi отобразит доступный путь к этой службе в виде следующего URL-адреса:nfs://<ip of server>:2049/path/to/nfsexport/."
echo " Создать файл nfs.service в /etc/avahi/services/ "
### Теперь анонсируем через него наш сервер
# nano /etc/avahi/services/nfs.service
touch /etc/avahi/services/nfs.service   # Создать файл /nfs.service в /etc
ls -l /etc/avahi/services/nfs.service   # ls — выводит список папок и файлов в текущей директории
sleep 1
echo " Пропишем конфигурацию для сервер NFS (работающий на порту NFS по умолчанию 2049) в /etc/avahi/services/nfs.service "
> /etc/avahi/services/nfs.service
cat <<EOF >>/etc/avahi/services/nfs.service
<?xml version= "1.0" standalone="'no'?> 
<!DOCTYPE service-group  SYSTEM  "avahi-service.dtd" > 
< service-group > 
  < name  replace-wildcards = "yes" > NFS-сервер в %h </ name >   
  < service > 
    < type > _nfs._tcp </ type > 
    < port > 2049 </ port > 
    < txt-record > path=/path/to/nfsexport </ txt-record > 
  </ service > 
</ service-group >

EOF
######################

echo ""
echo -e "${GREEN}==> ${NC}Добавляем Веб-сервер распределенной разработки и управления версиями (WebDAV)"
echo -e "${MAGENTA}:: ${BOLD}Примечание: Самые ранние веб-браузеры поддерживали редактирование веб-страниц. Тем не менее, часто требуется совместное редактирование удаленного контента, и поэтому оно появилось в Интернете в нескольких формах. WebDAV (Распределенный веб-авторинг и управление версиями (Web Distributed Authoring и Versioning)) - это один механизм. Веб-сервер, который поддерживает WebDAV, одновременно работает как файловый сервер. Он имеет действительно большую производительность.${NC}"
echo " Протокол WebDAV позволяет веб-серверу вести себя также как файловый сервер, поддерживая совместную разработку веб-контента. Вы можете столкнуться с WebDAV на HTTP-сервере Apache, Microsoft IIS, Box.com, WordPress, Drupal, Microsoft Sharepoint, Subversion, Git, Windows Explorer, macOS Finder, Microsoft Office, Apple iWork, Adobe Photoshop и во многих других местах. "
echo -e "${CYAN}:: ${NC}Следующая конфигурация объявит сервер WebDAV (в данном случае через веб-сервер Apache на порту TCP 80) с доступным путем /webdav/path. Браузер Kodi ZeroConf отобразит эту запись как WebDAV на <имя сервера> . При проверке этой записи Kodi отобразит доступный путь на этой службе в виде следующего URL:dav://<ip of server>:80/webdav/path/."
echo " Создать файл webdav.service в /etc/avahi/services/ "
### Теперь анонсируем через него наш сервер
# nano /etc/avahi/services/webdav.service
touch /etc/avahi/services/webdav.service   # Создать файл /webdav.service в /etc
ls -l /etc/avahi/services/webdav.service   # ls — выводит список папок и файлов в текущей директории
sleep 1
echo " Пропишем конфигурацию для сервер Apache (работающий на порту TCP по умолчанию 80) в /etc/avahi/services/webdav.service "
> /etc/avahi/services/webdav.service
cat <<EOF >>/etc/avahi/services/webdav.service
<?xml version= "1.0" standalone="'no'?> 
<!DOCTYPE service-group  SYSTEM  "avahi-service.dtd" > 
< service-group > 
  < name  replace-wildcards = "yes" > WebDav на %h </ name >   
  < service > 
    < type > _webdav._tcp </ type > 
    < port > 80 </ port > 
    < txt-record > path=/webdav/path </ txt-record >  
  </ service > 
</ service-group >

EOF
######################

echo ""
echo -e "${GREEN}==> ${NC}Добавляем Сервер защищенного протокола передачи файлов (SFTP через SSH)"
echo -e "${MAGENTA}:: ${BOLD}Примечание: Вы можете объявлять службы, используя службу avahi. Объявляем обслуживание, вы должны добавить файл описание сервиса в каталоге /etc/avahi/services. Объявить акцию по SFTP, создать файл sftp.service. ${NC}"
echo " Для FTP вы должны изменить Тип в _ftp._tcp и порт 21, на общем ресурсе NFS, изменение Тип _nfs._tcp и порт 2049. "
echo -e "${CYAN}:: ${NC}Следующая конфигурация объявит сервер SSH с включенным SFTP (на порту TCP по умолчанию 22) с доступным путем /path/to/be/accessed, учетной записью пользователя sshuserи паролем учетной записи sshpass. Браузер Kodi ZeroConf отобразит эту запись как SFTP на <имя сервера> . При проверке этой записи Kodi отобразит доступный путь на этой службе в виде следующего URL-адреса:sftp://sshuser:sshpass@<ip of server>:22/path/to/be/accessed/ "
### Теперь анонсируем через него наш сервер
# nano /etc/avahi/services/sftp.service
touch /etc/avahi/services/sftp.service   # Создать файл /sftp.service в /etc
ls -l /etc/avahi/services/sftp.service   # ls — выводит список папок и файлов в текущей директории
sleep 1
echo " Пропишем конфигурацию для сервер SSH (работающий на порту TCP по умолчанию 22) в /etc/avahi/services/sftp.service "
> /etc/avahi/services/sftp.service
cat <<EOF >>/etc/avahi/services/sftp.service
<?xml version= "1.0" standalone="'no'"?> 
<!DOCTYPE service-group  SYSTEM  "avahi-service.dtd" > 
< service-group > 
  < name  replace-wildcards = "yes" > SFTP на %h </ name > 
  < service > 
    < type > _sftp-ssh._tcp </ type > 
    < port > 22 </ port > 
    < txt-record > path=/path/to/be/accessed </ txt-record > 
    < txt-record > u=sshuser </ txt-record > 
    < txt-record > p=sshpass </ txt-record >   
  </ service > 
</ service-group >

EOF
######################

echo ""
echo -e "${GREEN}==> ${NC}Добавляем Сервер протокола передачи файлов (FTP)"
echo -e "${MAGENTA}:: ${BOLD}Примечание: Вы также можете автоматически обнаружить обычные FTP-серверы, такие как vsftpd . Установите пакет vsftpd и измените настройки vsftpd в соответствии с вашими личными предпочтениями (см. эту ветку на ubuntuforums.org или vsftpd.conf). ${NC}"
echo " FTP-сервер теперь должен быть объявлен Avahi. Теперь вы сможете найти FTP-сервер из файлового менеджера на другом компьютере в вашей сети. Возможно, вам потребуется включить разрешение #Hostname на клиенте. "
echo -e "${CYAN}:: ${NC}Следующая конфигурация объявит FTP-сервер (на TCP-порту по умолчанию 21) с доступным путем /ftppath, учетной записью пользователя ftpuserи паролем учетной записи ftppass. Браузер Kodi ZeroConf отобразит эту запись как FTP на <имя сервера> . При проверке этой записи Kodi отобразит доступный путь на этой службе в виде следующего URL-адреса:ftp:/ftpuser:ftppass@<ip of server>:21/ftppath/ "
### Теперь анонсируем через него наш сервер
# nano /etc/avahi/services/ftp.service
touch /etc/avahi/services/ftp.service   # Создать файл /ftp.service в /etc
ls -l /etc/avahi/services/ftp.service   # ls — выводит список папок и файлов в текущей директории
sleep 1
echo " Пропишем конфигурацию для сервер FTP (работающий на порту TCP по умолчанию 21) в /etc/avahi/services/ftp.service "
> /etc/avahi/services/ftp.service
cat <<EOF >>/etc/avahi/services/ftp.service
<?xml version= "1.0" standalone="'no'?> 
<!DOCTYPE service-group  SYSTEM  "avahi-service.dtd" > 
< service-group > 
  < name  replace-wildcards = "yes" > FTP на %h </ name > 
  < service > 
    < type > _ftp._tcp </ type > 
    < port > 21 </ port > 
    < txt-record > path=/ftppath </ txt-record > 
    < txt-record > u=ftpuser </ txt-record > 
    < txt-record > p=ftppass </ txt-record > 
  </ service > 
</ service-group >

EOF
######################
### Можно также заглянуть в /etc/avahi/avahi-daemon.conf и, например, ограничить вещание одним интерфейсом, но это уже на ваше усмотрение.
echo ""
echo " Перезапустим сервис (avahi-daemon.service)"
systemctl restart avahi-daemon.service
########### Справка ##############
# Услуги, поддерживаемые Kodi:
# Kodi может получать объявления ZeroConf для сервисов, работающих по следующим протоколам:
# Блок сообщений сервера/Общая файловая система Интернета (SMB/CIFS)
# Протокол передачи файлов (FTP)
# Протокол потоковой передачи домашнего телевидения (HTSP)
# Распределенная веб-разработка и управление версиями (WebDAV)
# Сетевая файловая система (NFS)
# Защищенный протокол передачи файлов (SFTP)
# Протокол цифрового аудиодоступа (DAAP)
######################

######## Samba #############
clear
echo ""
echo -e "${GREEN}==> ${NC}Установить файловый сервер Samba на Arch Linux - для общего доступа к файлам и принтерам между системами Linux и Windows?"
#echo -e "${BLUE}:: ${NC}Установить файловый сервер Samba на Arch Linux - для общего доступа к файлам и принтерам между системами Linux и Windows?"
#echo 'Установить файловый сервер Samba на Arch Linux - для общего доступа к файлам и принтерам между системами Linux и Windows?'
# Install a Samba file server on Arch Linux - for file and printer sharing between Linux and Windows systems?
echo -e "${MAGENTA}:: ${BOLD}Samba —  это реализация сетевого протокола SMB. Она облегчает организацию общего доступа к файлам и принтерам между системами Linux и Windows и является альтернативой NFS. ${NC}"
echo " Давайте разберемся с терминологией: SMB (сокр. от англ. Server Message Block) — сетевой протокол прикладного уровня для удалённого доступа к файлам, принтерам и другим сетевым ресурсам, а также для межпроцессного взаимодействия. Первая версия протокола, также известная как Common Internet File System (CIFS) (Единая файловая система Интернета). В настоящее время SMB связан главным образом с операционными системами Microsoft Windows, где используется для реализации «Сети Microsoft Windows». Сетевая файловая система (NFS) — это протокол распределенной файловой системы, первоначально разработанный компанией Sun Microsystems в 1984 году, позволяющий пользователю клиентского компьютера получать доступ к файлам по сети аналогично тому, как осуществляется доступ к локальному хранилищу. (https://wiki.archlinux.org/title/Samba_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9). "
echo " Samba позволяет настроить файловое хранилище различных масштабов — от малых офисов для крупных организаций. "
echo -e "${CYAN}:: ${NC}Его цель - Реализовать доступ клиентских терминалов к папкам, принтерам и дискам про протоколу SMB/CIFS."
echo " Также вместе с сервером Samba будет установлена программа Smb4K — это продвинутый браузер сетевого окружения и утилита монтирования общих ресурсов Samba. Он основан на KDE Frameworks 5 и клиентской библиотеке Samba (libsmbclient). Он сканирует сетевое окружение на предмет всех доступных рабочих групп, серверов и общих ресурсов и может монтировать все нужные общие ресурсы в локальную файловую систему. Его цель — предоставить простую в использовании программу с максимально возможным количеством функций (https://apps.kde.org/smb4k/). "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_samba  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_samba" =~ [^10] ]]
do
    :
done
if [[ $i_samba == 0 ]]; then
echo ""
echo " Установка пропущена "
elif [[ $i_samba == 1 ]]; then
  echo ""
  echo " Установка (samba) "
sudo pacman -Syu  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed samba  # Samba — стандартный набор программ для взаимодействия Windows с Linux и Unix ; Файловый сервер SMB и сервер домена AD ; https://www.samba.org/ ; https://archlinux.org/packages/extra/x86_64/samba/
sudo pacman -S --noconfirm --needed smbclient  # Инструменты для доступа к файловому пространству и принтерам сервера через SMB ; https://www.samba.org/ ; https://archlinux.org/packages/extra/x86_64/smbclient/
# smbd --version  # можете проверить версию Samba
sudo pacman -S --noconfirm --needed gvfs  # Реализация виртуальной файловой системы для GIO ; https://gitlab.gnome.org/GNOME/gvfs ; https://archlinux.org/packages/extra/x86_64/gvfs/
sudo pacman -S --noconfirm --needed gvfs-smb  # Реализация виртуальной файловой системы для GIO - бэкэнд SMB/CIFS (общий доступ к файлам Windows) ; https://gitlab.gnome.org/GNOME/gvfs ; https://archlinux.org/packages/extra/x86_64/gvfs-smb/
sudo pacman -S --noconfirm --needed cifs-utils  # Инструменты пользовательского пространства файловой системы CIFS ; https://wiki.samba.org/index.php/LinuxCIFS_utils ; https://archlinux.org/packages/extra/x86_64/cifs-utils/
### Файловая система CIFS в ядре обычно является предпочтительным методом монтирования общих ресурсов SMB/CIFS в Linux.
### Файловая система CIFS в ядре опирается на набор инструментов пользовательского пространства. Этот пакет инструментов называется cifs-utils . Хотя эти инструменты и не являются частью Samba, они изначально были частью пакета Samba. По ряду причин отправка этих инструментов как части Samba была проблематичной, и было решено выделить их в отдельный пакет.
#sudo pacman -S --noconfirm --needed perl-crypt-smbhash  # Модуль Perl/CPAN Crypt::SmbHash: реализация функций хеширования lanman и nt md4 только на Perl для использования в записях smbpasswd в стиле Samba ; https://search.cpan.org/dist/Crypt-SmbHash/SmbHash.pm ; https://archlinux.org/packages/extra/any/perl-crypt-smbhash/ ; https://metacpan.org/dist/Crypt-SmbHash/view/SmbHash.pm
### Этот модуль генерирует хэши паролей в стиле Lanman и NT MD4, используя код perl-only для переносимости. Модуль помогает в администрировании систем в стиле Samba. В дистрибутиве Samba аутентификация относится к частному файлу smbpasswd. Записи имеют формы, похожие на следующие: имя пользователя:unixuid:LM:NT . Где LM и NT — односторонние хэши одного и того же пароля. ntlmgen генерирует хеши, указанные в первом аргументе, и помещает результат во второй и третий аргументы.
#sudo whereis samba  # Проверьте, установилось ли ПО samba -V 
#sudo systemctl status smbd  # проверьте запущена ли программа
  echo " Загрузим модуль ядра cifs "
  echo " Перед попыткой подключения перезагрузите систему или вручную загрузите модуль ядра "
sudo modprobe cifs
#sudo modprobe -a cifs
  echo " Проверьте, загружен ли модуль с помощью lsmod "
#lsmod | grep cifs
  echo " Установка (smb4k) "
sudo pacman -S --noconfirm --needed smb4k  # Программа KDE, просматривающая общие ресурсы samba ; это продвинутый браузер сетевого окружения и утилита монтирования общих ресурсов Samba ; https://smb4k.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/smb4k/  
echo ""
echo " Сервер Samba установлен "
fi
############# Справка ####################
# Настройка Samba Share на Arch Manjaro Garuda Linux
# https://techviewleo.com/configure-samba-share-on-arch-manjaro-garuda/
# https://wiki.archlinux.org/title/Samba_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# https://linuxgenie.net/install-samba-arch-linux/
# https://dzen.ru/a/YHHJq4SitxnXb6Ol
# https://losst.pro/nastrojka-samba-v-ubuntu-15-10
# https://vk.com/@arch4u-nastroika-samba-v-archlinux - Чеклист по настройке Samba для файлового обмена
# https://serverspace.ru/support/help/configuring-samba/?utm_source=yandex.ru&utm_medium=organic&utm_campaign=yandex.ru&utm_referrer=yandex.ru
############# AUR ##############
# yay -S thunar-shares-plugin --noconfirm  # Плагин Thunar для быстрого совместного использования папки с помощью Samba без необходимости root-доступа ; https://aur.archlinux.org/thunar-shares-plugin.git (только для чтения, нажмите, чтобы скопировать) ; http://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin ; https://aur.archlinux.org/packages/thunar-shares-plugin
### или #### 
# yay -S thunar-shares-plugin-git --noconfirm  # Плагин Thunar для быстрого предоставления общего доступа к папке с помощью Samba без необходимости доступа root ; https://aur.archlinux.org/thunar-shares-plugin-git.git (только для чтения, нажмите, чтобы скопировать) ; https://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin ; https://aur.archlinux.org/packages/thunar-shares-plugin-git
#####################################

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Плагин Thunar Shares (thunar-shares-plugin) для быстрого совместного использования папки с помощью Samba из Thunar (файловый менеджер Xfce)?" 
echo -e "${CYAN}:: Предисловие! ${NC}Редактор общего доступа находится в диалоговом окне свойств файла (страница «Поделиться»). "
echo -e "${MAGENTA}:: ${BOLD}Плагин Thunar Shares (thunar-shares-plugin) позволяет быстро предоставить общий доступ к папке с помощью Samba из Thunar (файловый менеджер Xfce) без необходимости получения прав root. ${NC}"
echo -e "${MAGENTA}=> ${NC}Плагин Thunar Shares (thunar-shares-plugin) - устанавливается из пользовательского репозитория 'AUR'-'yay' (https://aur.archlinux.org/thunar-shares-plugin.git), собираются и устанавливаются. "
echo " Плагин Thunar Shares (https://gitlab.xfce.org/thunar-plugins/thunar-shares-plugin/-/tree/master) (http://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin ; https://aur.archlinux.org/packages/thunar-shares-plugin ). " 
echo -e "${YELLOW}:: Примечание! ${NC}Зависимости: (samba; thunar; xfce4-dev-tools). Источники: (https://archive.xfce.org/src/thunar-plugins/thunar-shares-plugin/0.3/thunar-shares-plugin-0.3.2.tar.bz2). "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_shares  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_shares" =~ [^10] ]]
do
    :
done 
if [[ $i_shares == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_shares == 1 ]]; then
  echo ""  
  echo " Установка Плагин Thunar Shares (thunar-shares-plugin) "
########## thunar-shares-plugin ##########
#yay -S thunar-shares-plugin --noconfirm  # Плагин Thunar для быстрого совместного использования папки с помощью Samba без необходимости root-доступа ; https://aur.archlinux.org/thunar-shares-plugin.git (только для чтения, нажмите, чтобы скопировать) ; http://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin ; https://aur.archlinux.org/packages/thunar-shares-plugin ; https://gitlab.xfce.org/thunar-plugins/thunar-shares-plugin/-/tree/master
# yay -S thunar-shares-plugin-git --noconfirm  # Плагин Thunar для быстрого предоставления общего доступа к папке с помощью Samba без необходимости доступа root ; https://aur.archlinux.org/thunar-shares-plugin-git.git (только для чтения, нажмите, чтобы скопировать) ; https://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin ; https://aur.archlinux.org/packages/thunar-shares-plugin-git
# yay -Rns thunar-shares-plugin  # Удалите thunar-shares-plugin в Arch с помощью YAY
# git clone https://aur.archlinux.org/thunar-shares-plugin.git ~/thunar-shares-plugin   # Клонировать git thunar-shares-plugin локально
git clone https://aur.archlinux.org/thunar-shares-plugin.git 
# cd ~/thunar-shares-plugin  # Перейдите в папку ~/thunar-shares-plugin и установите его
cd thunar-shares-plugin
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf thunar-shares-plugin
rm -Rf thunar-shares-plugin   # удаляем директорию сборки 
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
#############










echo ""
echo " Создать каталог (Samba) в директории ~/home/<user>/ , для удобной работы "
### mkdir /home/<user>/Samba
mkdir ~/Samba  # Общая директория, на машине ; Создать каталог (Samba) в ~/home/<user>/
echo " Создать каталог в директории /etc/samba , для работы сервера Samba "
#sudo mkdir /etc/samba
sudo mkdir -p /etc/samba
echo " Создать файл конфигурации (настройки) сервера Samba 'smb.conf' в /etc/samba/ "
#touch /etc/samba/smb.conf   # Создать файл в /etc/samba/smb.conf
sudo touch /etc/samba/smb.conf
#######################
echo " Для начала сделаем бэкап оригинального (созданного) файла /etc/samba/smb.conf "
echo " smb.conf - Это  основной файл настройки samba "
#cp /etc/resolv.conf  /etc/resolv.conf.back
sudo cp -v /etc/samba/smb.conf  /etc/samba/smb.conf.original  # Для начала сделаем его бэкап ; -v или --verbose -Выводить информацию о каждом файле, который обрабатывает команда cp.
#sudo mv /etc/samba/smb.conf  /etc/samba/smb.conf.original_`date +"%d.%m.%y_%H-%M"`
echo " Посмотрим список папок и файлов в созданой директории /etc/samba "
ls -l /etc/samba   # ls — выводит список папок и файлов в текущей директории
sleep 03
######################
clear
echo ""
echo -e "${GREEN}==> ${NC}Внесём (добавим) небольшой сценарий конфигураций в созданный файл /etc/samba/smb.conf для первоначального запуска и работы сервера Samba (smb.service ; nmb.service)! "
echo -e "${MAGENTA}=> ${BOLD}Команда добавляет запись в файлы /etc/samba/smb.conf . Основы (данные конфигурации) для файла 'smb.conf' были взяты из ArchWiki: (https://wiki.archlinux.org/title/Samba) и ещё нескольких источников (http://www.samba.org/samba/docs/Samba-HOWTO-Collection.pdf).${NC}"
echo " Позже вы можете изменить (удалить) или добавить новые данные в 'smb.conf': доверенного домена, группу @group, пользователя (ей) @user, пароль ( ‘@’, ‘+’), папки (FS_Share), запреты "No", разрешение (yes на общем ресурсе), протоколы безопасности (SMB2,SMB3) и т.д... "




echo " Добавим следующие конфигурации в созданный файл /etc/samba/smb.conf "
> /etc/samba/smb.conf
cat <<EOF >>/etc/samba/smb.conf
# This is the main Samba configuration file. You should read the
# smb.conf(5) manual page in order to understand the options listed
# here. Samba has a huge number of configurable options (perhaps too
# many!) most of which are not shown in this example
#
# For a step to step guide on installing, configuring and using samba, 
# read the Samba-HOWTO-Collection. This may be obtained from:
#  http://www.samba.org/samba/docs/Samba-HOWTO-Collection.pdf
#
# Many working examples of smb.conf files can be found in the 
# Samba-Guide which is generated daily and can be downloaded from: 
#  http://www.samba.org/samba/docs/Samba-Guide.pdf
#
# Any line which starts with a ; (semi-colon) or a # (hash) 
# is a comment and is ignored. In this example we will use a #
# for commentry and a ; for parts of the config file that you
# may wish to enable
#
# NOTE: Whenever you modify this file you should run the command "testparm"
# to check that you have not made any basic syntactic errors. 
#
#======================= Global Settings =====================================
[global]

# workgroup = NT-Domain-Name or Workgroup-Name, eg: MIDEARTH
# должна соответствовать домашней группе (workgroup) Windows (по умолчанию: WORKGROUP)
#  workgroup = MYGROUP  # убедитесь, что значение рабочей группы совпадает с параметрами рабочей группы компьютеров Windows
   workgroup = WORKGROUP

# server string is the equivalent of the NT Description field
   server string = Samba Server

# Server role. Defines in which mode Samba will operate. Possible
# values are "standalone server", "member server", "classic primary
# domain controller", "classic backup domain controller", "active
# directory domain controller".
#
# Most people will want "standalone server" or "member server".
# Running as "active directory domain controller" will require first
# running "samba-tool domain provision" to wipe databases and create a
# new domain.
   server role = standalone server

# This option is important for security. It allows you to restrict
# connections to machines which are on your local network. The
# following example restricts access to two C class networks and
# the "loopback" interface. For more examples of the syntax see
# the smb.conf man page
;   hosts allow = 192.168.1. 192.168.2. 127.

# Uncomment this if you want a guest account, you must add this to /etc/passwd
# otherwise the user "nobody" is used
;  guest account = pcguest

# this tells Samba to use a separate log file for each machine
# that connects
#  log file = /usr/local/samba/var/log.%m
   log file = /var/log/samba/%m.log

# Put a capping on the size of the log files (in Kb).
   max log size = 50

# Specifies the Kerberos or Active Directory realm the host is part of
;   realm = MY_REALM

# Backend to store user information in. New installations should 
# use either tdbsam or ldapsam. smbpasswd is available for backwards 
# compatibility. tdbsam requires no further configuration.
;   passdb backend = tdbsam

# Using the following line enables you to customise your configuration
# on a per machine basis. The %m gets replaced with the netbios name
# of the machine that is connecting.
# Note: Consider carefully the location in the configuration file of
#       this line.  The included file is read at that point.
;   include = /usr/local/samba/lib/smb.conf.%m

# Configure Samba to use multiple interfaces
# If you have multiple network interfaces then you must list them
# here. See the man page for details.
;   interfaces = 192.168.12.2/24 192.168.13.2/24 

# Where to store roving profiles (only for Win95 and WinNT)
#        %L substitutes for this servers netbios name, %U is username
#        You must uncomment the [Profiles] share below
;   logon path = \\%L\Profiles\%U

# Windows Internet Name Serving Support Section:
# WINS Support - Tells the NMBD component of Samba to enable it's WINS Server
;   wins support = yes

# WINS Server - Tells the NMBD components of Samba to be a WINS Client
# Note: Samba can be either a WINS Server, or a WINS Client, but NOT both
;   wins server = w.x.y.z

# WINS Proxy - Tells Samba to answer name resolution queries on
# behalf of a non WINS capable client, for this to work there must be
# at least one  WINS Server on the network. The default is NO.
;   wins proxy = yes

# DNS Proxy - tells Samba whether or not to try to resolve NetBIOS names
# via DNS nslookups. The default is NO.
   dns proxy = no 

# These scripts are used on a domain controller or stand-alone 
# machine to add or delete corresponding unix accounts
;  add user script = /usr/sbin/useradd %u
;  add group script = /usr/sbin/groupadd %g
;  add machine script = /usr/sbin/adduser -n -g machines -c Machine -d /dev/null -s /bin/false %u
;  delete user script = /usr/sbin/userdel %u
;  delete user from group script = /usr/sbin/deluser %u %g
;  delete group script = /usr/sbin/groupdel %g

# For compatibility with older clients and/or servers,
# you may need to specify client min protocol = CORE or server min protocol = CORE,
# but keep in mind that this makes you vulnerable to exploits in SMB1, including ransomware attacks
   server min protocol = SMB2_02
   server max protocol = SMB3
# server min protocol = SMB3_00
   client min protocol = SMB2
   client max protocol = SMB2


#============================ Share Definitions ==============================
[homes]
   comment = Home Directories
   browseable = no
   writable = yes

# Un-comment the following and create the netlogon directory for Domain Logons
; [netlogon]
;   comment = Network Logon Service
;   path = /usr/local/samba/lib/netlogon
;   guest ok = yes
;   writable = no
;   share modes = no


# Un-comment the following to provide a specific roving profile share
# the default is to use the user's home directory
;[Profiles]
;    path = /usr/local/samba/profiles
;    browseable = no
;    guest ok = yes


# NOTE: If you have a BSD-style print system there is no need to 
# specifically define each individual printer
;[printers]
;   comment = All Printers
;   path = /usr/spool/samba
;   browseable = no
# Set public = yes to allow user 'guest account' to print
 ;  guest ok = no
 ;  writable = no
 ;  printable = yes


[myfiles]
# User accessing the directory (Пользователь обращается к каталогу)
    comment = smbuser 
# the directory User has permission to access (у Пользователя есть разрешение на доступ к каталогу)           
    path = /srv/myfiles
# nobody else has the permission to access the directory except User         
    public = no            
    only guest = yes
 # User have write access to the directory (Пользователь имеет доступ на запись в каталог)
    writable = yes        

# This one is useful for people to share files
;[tmp]
;   comment = Temporary file space
;   path = /tmp
;   read only = no
;   public = yes

# A publicly accessible directory, but read only, except for people in
# the "staff" group
;[public]
;   comment = Public Stuff
;   path = /home/samba
;   public = yes
;   writable = no
;   printable = no
;   write list = @staff

# Other examples. 
#
# A private printer, usable only by fred. Spool data will be placed in fred's
# home directory. Note that fred must have write access to the spool directory,
# wherever it is.
;[fredsprn]
;   comment = Fred's Printer
;   valid users = fred
;   path = /homes/fred
;   printer = freds_printer
;   public = no
;   writable = no
;   printable = yes

# A private directory, usable only by fred. Note that fred requires write
# access to the directory.
;[fredsdir]
;   comment = Fred's Service
;   path = /usr/somewhere/private
;   valid users = fred
;   public = no
;   writable = yes
;   printable = no

# a service which has a different directory for each machine that connects
# this allows you to tailor configurations to incoming machines. You could
# also use the %U option to tailor it by user name.
# The %m gets replaced with the machine name that is connecting.
;[pchome]
;  comment = PC Directories
;  path = /usr/pc/%m
;  public = no
;  writable = yes

# A publicly accessible directory, read/write to all users. Note that all files
# created in the directory by users will be owned by the default user, so
# any user with access can delete any other user's files. Obviously this
# directory must be writable by the default user. Another user could of course
# be specified, in which case all files would be owned by that user instead.
;[public]
;   path = /usr/somewhere/else/public
;   public = yes
;   only guest = yes
;   writable = yes
;   printable = no

# The following two entries demonstrate how to share a directory so that two
# users can place files there that will be owned by the specific users. In this
# setup, the directory should be writable by both users and should have the
# sticky bit set on it to prevent abuse. Obviously this could be extended to
# as many users as required.
;[myshare]
;   comment = Mary's and Fred's stuff
;   path = /usr/somewhere/shared
;   valid users = mary fred
;   public = no
;   writable = yes
;   printable = no
;   create mask = 0765

EOF
#######################
echo " Для начала сделаем его бэкап /etc/samba/smb.conf "
echo " smb.conf - Это  основной файл настройки samba "
#cp /etc/resolv.conf  /etc/resolv.conf.back
sudo cp -v /etc/samba/smb.conf  /etc/samba/smb.conf.back_`date +"%d.%m.%y_%H-%M"`  # Для начала сделаем его бэкап
# cp -v /etc/samba/smb.conf  /etc/samba/smb.conf.original  # -v или --verbose -Выводить информацию о каждом файле, который обрабатывает команда cp.
#sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.bak_`date +"%d.%m.%y_%H-%M"`
#######################
echo ""
echo " Просмотри внесённые изменения в etc/samba/smb.conf "
cat /etc/samba/smb.conf
sleep 1
#######################
echo " Проверим свою конфигурацию в файле etc/samba/smb.conf на синтаксические ошибоки "
sudo testparm /etc/samba/smb.conf  # для проверки синтаксических ошибок в smb.conf файле
# sudo testparm  # для проверки синтаксических ошибок в smb.conf файле
sleep 3
######################
echo " Перезапускаем Сервер Samba (smb.service ; nmb.service) при любых изменениях в конфиге /etc/samba/smb.conf "
#sudo systemctl restart smb.service
#sudo systemctl restart nmb.service
#######################
echo " Включим Сервер Samba (smb.service ; nmb.service) в автозагрузку и запустим! "
systemctl start smb.service
systemctl enable smb.service
systemctl start nmb.service
systemctl enable nmb.service
#sudo systemctl start smb
#sudo systemctl enable smb
#sudo systemctl start nmb
#sudo systemctl enable nmb
# sudo systemctl start smb nmb
# sudo systemctl enable smb nmb
# sudo systemctl enable --now smb nmb
# sudo systemctl enable --now samba
#######################
echo " Проверим состояние smb и nmb, которые должны быть активны и работают! "
########### smb ############
#sudo systemctl status smb   # Соответственно для просмотра текущего состояния демона smd
########### nmb ############
#sudo systemctl status nmb   # Соответственно для просмотра текущего состояния демона nmd
############################
sleep 01
###############
clear
echo ""
echo " Сервер Samba (smb.service ; nmb.service) добавлен в автозагрузку и запущен! "
echo " Проверить состояние (статус активности) smb и nmb, вы можете Позже! "

echo ""
echo ""
echo -e "${GREEN}==> ${NC}Создадим (добавим) новую группу пользователей для сервера Samba "
echo " Создание групп для Samba Linux необходимо для организации доступа к папкам в соответствии с принятыми правилами "
echo " Гостевой доступ это просто и удобно, но не всегда приемлемо! Существуют ситуации, когда доступ к общему ресурсу должны иметь только определенные пользователи. Группа будет добавлена в файл /etc/group ! "
echo -e "${MAGENTA}=> ${BOLD}Чтобы создать новую группу, воспользуемся командой: groupadd -r , за которой следует имя новой группы. Команда добавляет запись для новой группы в файлы /etc/group и /etc/gshadow . После создания группы вы можете начать добавлять пользователей в группу. Если группа с таким именем уже существует, система напечатает сообщение об ошибке!${NC}"
echo " Позже вы можете изменить (удалить) или добавить новую группу, пользователя и пароль общего доступа (пользователь_samba) "
read -p " => Введите название группы для samba groupname: " group_name
#sudo groupadd -r $group
sudo groupadd -r $group_name  # -r, --system: Эта опция создает системную группу
#sudo groupadd -f $group_name  # -f, --force: эта опция заставляет команду просто завершиться со статусом успешного выполнения, если указанная группа уже существует
# groupadd [опции] имя_группы
#echo ""
echo " Название группы которую вы добавили для сервера 'SAMBA' "
cat /etc/group | grep ${group_name}
# sudo grep ${group_name} /etc/group
#echo ""
echo " Группа успешно добавлена в /etc/group! "
sleep 02
# sudo groupadd -r sambauser  # Создадим (добавим) новую группу пользователей: sambauser - для сервера Samba
# cat /etc/group | grep sambauser  # Теперь вы можете убедится, что группа была добавлена в файл /etc/group
########### Справка #############
### Синтаксис команды `groupadd`:
# Команда имеет простой синтаксис: groupadd
# groupadd [опции] имя_группы
# groupadd [OPTIONS] GROUPNAME
# sudo groupadd -r new_group_name
### Некоторые важные параметры в groupadd:
# -f, --force: эта опция заставляет команду просто завершиться со статусом успешного выполнения, если указанная группа уже существует.
# -g GID, --gid GID: эта опция позволяет указать идентификатор новой группы.
# -K KEY=VALUE: Этот параметр переопределяет /etc/login.defsзначения по умолчанию.
# -o, --non-unique: эта опция позволяет создать группу с неуникальным GID.
# -p, --password PASSWORD: Эта опция устанавливает пароль для группы.
# -r, --system: Эта опция создает системную группу.
### Чтобы создать системную группу, вам придется использовать флаг -rс командой groupadd:
# sudo groupadd -r sysgroup
# Теперь вы можете убедится, что группа была добавлена в файл /etc/group:
# cat /etc/group | grep имя_группы
### Когда вы создаете новую группу, это обычная группа с GID выше 1000. Вы также можете создать системную группу, которая автоматически принимает идентификатор группы между SYS_GID_MIN и SYS_GID_MAX, как определено в /etc/login.defs.
# sudo groupadd -r new_group_name
### Чтобы подавить сообщение об ошибке, если группа существует, и для успешного завершения команды используйте параметр -f ( --force )
# sudo groupadd -f new_group_name
#################################

clear
echo ""
echo -e "${GREEN}==> ${NC}Создадим (добавим) пользователя для сервера Samba "
echo " Для работы Samba требуется какой-нибудь Linux-пользователь — вы можете использовать существующего пользователя, но это не по Фен-шуй (Основная идея состоит в том, что окружающая человека среда оказывает влияние на его благополучие и энергию), или создать нового пользователя, что мы и сделаем! "
# echo " По умолчанию (пользователь_samba) будет прописан 'smbuser'! "
echo " Позже вы можете изменить (удалить) или добавить нового пользователя и пароль общего доступа (пользователь_samba) "
#sudo useradd smbuser
# sudo useradd -s / bin / false smbuser
# sudo useradd -d /home/smbuser -s /sbin/nologin smbuser
echo " Для добавления учетных записей пользователя Linux и SAMBA введите: 
       --- Имя Пользователя и Название его рабочей группы."
echo " Для добавления пользователя в группу, группа должна существовать!!! "
user_name=""
while [ "${user_name}" = "" ]
do
#echo " => Введите имя добавляемого пользователя для samba username: "
echo Введите имя добавляемого пользователя:
read user_name
done
#echo " => Введите название группы groupname, в которую добавить пользователя username: "
echo Введите название группы, в которую добавить пользователя:
read group_name
if [ "`cat /etc/group | grep ${group_name}`" = "" ]
then
Группы с таким именем не существует.
else
echo Добавление учетной записи пользователя ${user_name} в группу ${group_name}...
sudo useradd -m -g ${group_name} ${user_name}
echo Добавление учетной записи пользователя ${user_name} SAMBA...
sudo smbpasswd -a ${user_name}
echo Включение учетной записи SAMBA ${user_name}...
sudo smbpasswd -e ${user_name}
echo " Все действия успешно выполнены! "
fi
################
echo " Вывести список пользователей добавленных в Samba: "
sudo pdbedit -L -v
sudo tail -1 /etc/passwd
###########################




# chmod +x myscript
# sudo myscript

# sudo groupdel sambauser
# sudo getent group | grep sambauser ?
# sudo cat /etc/group

# sudo cat /etc/passwd
# sudo passwd -l smbuser
# sudo userdel -f smbuser
## sudo userdel -r smbuser





echo ""
echo -e "${GREEN}==> ${NC}Создадим (добавим) пользователя для сервера Samba "
echo " Для работы Samba требуется какой-нибудь Linux-пользователь — вы можете использовать существующего пользователя или создать нового "
echo " По умолчанию (пользователь_samba) будет прописан 'smbuser'! "
echo " Позже вы можете изменить (удалить) или добавить нового пользователя и пароль общего доступа (пользователь_samba) "
sudo useradd smbuser
# sudo useradd -s / bin / false smbuser
# sudo useradd -d /home/smbuser -s /sbin/nologin smbuser

echo ""
echo -e "${GREEN}==> ${NC}Устанавливаем пароль пользователя общего доступа Samba в Arch "
echo " Создадим пользователя общего доступа (пользователь_samba) через (smbpasswd -a smbuser) "
echo " Обычно команда smbpasswd работает интерактивно - выводит запросы и ожидает ответы. Однако, при помощи ключа -s (silent) можно подавить вывод запросов и читать ответы со стандартного ввода. Это позволит вызывать smbpasswd из скриптов. "
echo " Хотя имена пользователей Samba общие с системными пользователями, Samba использует для них отдельные пароли "
echo " Позже вы можете изменить или добавить нового пользователя и пароль общего доступа (пользователь_samba) "
echo " Пароль должен содержать от 6 до 15 символов, включающих цифры (1-0) и знаки (!'':[@]),
        и латинские буквы разного регистра! "
echo -e "${MAGENTA}=> ${BOLD}По умолчанию, на большинстве систем Linux в консоле не показывается введенный пароль.
Это сделано из соображений безопасности, чтобы никто не мог увидеть длину вашего пароля.${NC}"
echo " => Введите SMB Password (Пароль пользователя Samba) - для smbuser, вводим пароль 2 раза "
#echo " => Введите SMB Password (Пароль пользователя Samba) - для $USER, вводим пароль 2 раза "
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
sudo smbpasswd -a smbuser
#sudo smbpasswd -a $USER  # если скрипт запускается через sudo, `USER` будет пользователем, доступным в sudo (обычно root)
# sudo smbpasswd -s -a $USER
# sudo smbpasswd -a $username  # `USERNAME` — пользователем, запустившим sudo
# sudo smbpasswd -s -a $username
echo " После добавления учетной записи пользователя (smbuser), ее надо активировать: (sudo smbpasswd -e пользователь_samba)"
sudo smbpasswd -e smbuser
### Удаление существующего пользователя
#sudo smbpasswd -x smbuser
### echo -e "Какой пароль должен быть у юзера ${username}?"
### Сменить пользовательский пароль:
# sudo smbpasswd -s пользователь_samba
##########################
echo " Вывести список пользователей добавленных в Samba: с помощью команды (pdbedit)"
sudo pdbedit -L -v
sleep 1
### Чтобы сменить пароль пользователя, используйте smbpasswd: smbpasswd -a  ['пользователь_samba']
# sudo smbpasswd пользователь_samba
############# Справка ##############
### Чтобы добавить себя в список пользователей Samba, вам просто нужно ввести следующую команду: sudo smbpasswd- a< имя пользователя>. Замените <имя пользователя> на свое имя пользователя. Затем вам будет предложено установить пароль для этой учетной записи Samba. В качестве альтернативы вы также можете создать новую учетную запись пользователя и добавить ее в список пользователей Samba. Чтобы создать учетную запись пользователя, используйте следующую команду: adduser< имя пользователя>.
### Согласно источнику, разница между переменными окружения `USER` и `USERNAME` заключается в следующем:
### В Linux: если скрипт запускается через sudo, `USER` будет пользователем, доступным в sudo (обычно root), а `USERNAME` — пользователем, запустившим sudo. 
#####################################

clear
echo ""
echo " Создадим каталог для пользователей "
echo " Проверить состояние (статус активности) smb и nmb, вы можете Позже! "

#!/usr/bin/env bash
#echo Welcome!
#clear
echo ""
echo -e "${GREEN}==> ${NC}Создадим каталог для пользователей общего доступа Samba в Arch "
  echo " Введите название папки $folder [ENTER]: "   # Введите название папки $folder [ВВОД]
  read foldrer_name
  $(mkdir ~/"$foldrer_name")
#  $(mkdir ~/Public/"$foldrer_name")
  echo " Подготовка папок Samba... "
#  $(mkdir ~/Publicshare/"$foldrer_name")
  $(mkdir ~/"$foldrer_name"/Public)
 $(mkdir ~/"$foldrer_name"/Public/Courses)
 $(mkdir ~/"$foldrer_name"/Public/Courses/Session2)
  echo " Подготовка папок Samba...готово "              
  echo " Папка для общего доступа через сервер Samba успешно создана "  
echo " Все каталоги были созданы "  
#Общедоступные  PUBLICSHARE
#ls -l ~/  # ls — выводит список папок и файлов в текущей директории
ls -l ~/ "$foldrer_name"


Создайте каталог для пользователей:

sudo mkdir /srv/myfiles

Узнаем локальный IP

В Linux

$ ip addr show

[Alex@Terminator ~]$ wget http://ipinfo.io/ip -qO -
95.25.240.56
[Alex@Terminator ~]$ ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 10:bf:48:29:89:2f brd ff:ff:ff:ff:ff:ff
    inet 100.127.181.17/16 brd 100.127.255.255 scope global dynamic noprefixroute enp5s0
       valid_lft 497sec preferred_lft 497sec
    inet6 fe80::ec39:143:d7d1:ad7e/64 scope link 
       valid_lft forever preferred_lft forever
    inet6 fe80::20bb:a2cf:ad69:d2d2/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 3a:44:8e:86:b7:92 brd ff:ff:ff:ff:ff:ff permaddr e0:06:e6:5e:f8:0d

Гостевой доступ это просто и удобно, но не всегда приемлемо. Существуют ситуации, когда доступ к общему ресурсу должны иметь только определенные пользователи. В нашем примере создадим два таких ресурса: для бухгалтерии и для IT-отдела.

Использование
Управление пользователями
В следующем разделе описывается создание локальной (tdbsam) базы данных пользователей Samba. Для аутентификации пользователей и других целей Samba также может быть привязана к домену Active Directory, может сама служить контроллером домена Active Directory или использоваться с сервером LDAP.


В Windows

ipconfig
10) Если установлен UFW, то добавляем локалную сеть в исключения

sudo ufw allow from 15.15.15.0/24
11) В Win в проводнике вбиваем ip адрес машины см. пример

\\192.168.0.0






Нам надо ввести пароль, который мы раньше шифровали, и теперь до конца сеанса наш пользователь находится в группе. Если вы хотите добавить пользователя в группу навсегда, то надо использовать команду usermod:

sudo usermod -aG group7 имя_пользователя


Если вы создали группу неправильно или считаете, что она не нужна, то её можно удалить. Для этого используйте:

sudo groupdel имя_группы


Используйте параметр -r ( --system ), чтобы создать системную группу. 
Например, чтобы создать новую системную группу с именем mysystemgroup вы должны запустить:

groupadd -r mysystemgroup

Чтобы подавить сообщение об ошибке, если группа существует, 
и для успешного завершения команды используйте параметр -f ( --force ):
sudo groupadd -f mygroup

Параметр -p ( --password ), за которым следует пароль, позволяет вам установить пароль для новой группы:

groupadd -p grouppassword mygroup

Следующая команда создает новую группу companyс паролем pa55word.

Баш

$ sudo groupadd компания -p pa55word
ИЛИ

Баш

$ sudo groupadd компания --password pa55word




Проверьте недавно добавленного пользователя:
tail -1 /etc/passwd


Восстановление к начальному состоянию Samba
Необходимо очистить базы и конфигурацию Samba (домен, если он создавался до этого, будет
удалён):
# rm -f /etc/samba/smb.conf
# rm -rf /var/lib/samba
# rm -rf /var/cache/samba
# mkdir -p /var/lib/samba/sysvol


echo " Включение безопасного общего доступа Samba в Arch "

sudo usermod -aG wireshark $USER

sudo gpasswd sambauser -a ['username']
sudo gpasswd sambauser -a $USER  # если скрипт запускается через sudo, `USER` будет пользователем, доступным в sudo (обычно root)
sudo gpasswd sambauser -a $username  # `USERNAME` — пользователем, запустившим sudo

echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " => Введите имя пользователя для samba: " username
# echo -e "Какое имя пользователя вам нужно?"
# read username; clear

Я написал bash-скрипт для добавления учетных записей UNIX и SAMBA:


#Добавляет пользователя в группу, группа должна существовать.
echo "Для добавления учетных записей пользователя Linux и SAMBA введите Имя Пользователя и Название его рабочей группы (группа должна существовать)."
user_name=""
while [ "${user_name}" = "" ]
do
echo Введите имя добавляемого пользователя:
read user_name
done
echo Введите название группы, в которую добавить пользователя:
read group_name
if [ "`cat /etc/group | grep ${group_name}`" = "" ]
then
Группы с таким именем не существует.
else
echo Добавление учетной записи пользователя ${user_name} в группу ${group_name}...
sudo useradd -m -g ${group_name} ${user_name}
echo Добавление учетной записи пользователя ${user_name} SAMBA...
sudo smbpasswd -a ${user_name}
echo Включение учетной записи SAMBA ${user_name}...
sudo smbpasswd -e ${user_name}
fi



for GROUP in $(cut -d $DELIM -f 1,2 --output-delimiter="|" "$LIST")
do

# Выделить из переменной поля разделенные "|"
# Команда tr -d [:cntrl:] позволяет удалить управляющие символы из переменной
# Иногда при экспорте в csv могут попадать управляющие символы и usermod сыплет ошибки
GRP1=`echo ${GROUP,,} | tr -d [:cntrl:] | cut -d "|" -f 1`
USR1=`echo ${GROUP,,} | tr -d [:cntrl:] | cut -d "|" -f 2`

#echo -e "$GRP1 | $USR1"

# Добавить группу и пользователя в группу
groupadd -f $GRP1
usermod --append --groups ${GRP1,,} ${USR1,,}

done






Я написал bash-скрипт для добавления учетных записей UNIX и SAMBA:
Запустить его можно командой:
sudo bash /path/script
где /path/script путь к скрипту.

Просмотр информации о пользователях и группах
Полезно знать как посмотреть информацию о всех учетных записях пользователей существующих в системе.
Информацию об учетной записи пользователя можно получить с помощью команды id:
id user_name
Информация об учетных записях UNIX хранится в файле /etc/passwd, каждая строка файла содержит информацию об одной из учетных записей, посмотреть его можно, например, командой:
cat /etc/passwd
Информация о группах UNIX хранится в файле /etc/group, посмотреть файл можно командой:
cat /etc/passwd
Информация об учетных записях SAMBA, хранящихся в базе данных получается командой:
sudo pdbedit -L

#Добавляет пользователя в группу, группа должна существовать.
echo "Для добавления учетных записей пользователя Linux и SAMBA введите Имя Пользователя и Название его рабочей группы (группа должна существовать)."
user_name=""
while [ "${user_name}" = "" ]
do
echo Введите имя добавляемого пользователя:
read user_name
done
echo Введите название группы, в которую добавить пользователя:
read group_name
if [ "`cat /etc/group | grep ${group_name}`" = "" ]
then
Группы с таким именем не существует.
else
echo Добавление учетной записи пользователя ${user_name} в группу ${group_name}...
sudo useradd -m -g ${group_name} ${user_name}
echo Добавление учетной записи пользователя ${user_name} SAMBA...
sudo smbpasswd -a ${user_name}
echo Включение учетной записи SAMBA ${user_name}...
sudo smbpasswd -e ${user_name}
fi

https://wiki.archlinux.org/title/Samba_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)


Добавьте пользователя user1 в  группу sambauser  : gpasswd - управление /etc/group и /etc/gshadow ;  gpasswd [параметр] группа
https://manpages.ubuntu.com/manpages/xenial/ru/man1/gpasswd.1.html


Вы также можете изменить пароль пользователя user1, выполнив следующую команду:

sudo smbpasswd user1

Перезапуск  smb.service и  nmb.service сервисы:

sudo systemctl restart smb
sudo systemctl restart nmb

Сохраните изменения в файле конфигурации и перезагрузите сервер Samba.

sudo service smbd reload


sudo usermod -aG wireshark $USER  # Добавить текущего пользователя в группу wireshark,
echo " Перемещаем и переименовываем исходный файл /etc/resolv.conf.back в /etc/resolvconf/resolv.conf.d/resolv.conf.original "
mv /etc/resolv.conf.back  /etc/resolvconf/resolv.conf.d/resolv.conf.original   # Перемещаем и переименовываем исходный файл
### echo " Удаление файла /etc/resolv.conf "
### rm /etc/resolv.conf   # rm - Удаление файлов
##################################











Начинаем всё это дело:

sudo systemctl start smb nmb
sudo systemctl enable smb nmb

Еще одна важная вещь — включить службы с помощью enable (заменив start в приведенном выше коде).

Правильные разрешения для публичного каталога

sudo chown -R nobody:nobody /sambapub

sudo chmod -R 777 /sambapub

Также, добавление пользователя:

sudo smbpasswd -a username




[global]
min protocol = SMB2                                                                                 
max protocol = SMB2                                                                                 
client min protocol = SMB2
client max protocol = SMB2


По сути, у меня есть эта конфигурация в файле конфигурации smb в samba (/etc/samba/smb.conf)

Я решил сделать проверку файлов на Mac более крутой, используя более удобную иконку для машины с параметрами, fruit:model = Macintosh и другими…


# general config

min protocol = SMB2
vfs objects = catia fruit streams_xattr
fruit:aapl = yes
fruit:metadata = stream
fruit:model = Macintosh
fruit:posix_rename = yes
fruit:veto_appledouble = no
fruit:wipe_intentionally_left_blank_rfork = yes
fruit:delete_empty_adfiles = yes

#folders private / public

[Private]
comment = private share
path = /home/felipe/private
browseable = yes
guest ok = no
writable = yes
valid users = felipe

[Public]
comment = public share
#path = /home/felipe/pub
path = /opt/sambapub
browseable = yes
writable = yes
guest ok = yes
#valid users = nobody

Начинаем всё это дело:

sudo systemctl start smb nmb
sudo systemctl enable smb nmb

Еще одна важная вещь — включить службы с помощью enable (заменив start в приведенном выше коде).

Правильные разрешения для публичного каталога

sudo chown -R nobody:nobody /sambapub

sudo chmod -R 777 /sambapub


[global]
security = user
workgroup = WORKGROUP
server string = Samba
#Тут пишем ваш ник вместо user
guest account = user
map to guest = Bad User
auth methods = guest, sam_ignoredomain
create mask = 0664
directory mask = 0775
hide dot files = yes

[shared]
comment = Public Folder
#Тут пишем путь до папки для шары
path = /home/public
browseable = Yes
guest ok = Yes
public = yes
writeable = Yes
read only = no
guest ok = yes
create mask = 0666
directory mask = 0775


Настройка межсетевого экрана
9) Узнаем локальный IP

В Linux

$ ip addr show
[Alex@Terminator ~]$ ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 10:bf:48:29:89:2f brd ff:ff:ff:ff:ff:ff
    inet 100.127.90.174/16 brd 100.127.255.255 scope global dynamic noprefixroute enp5s0
       valid_lft 571sec preferred_lft 571sec
    inet6 fe80::20bb:a2cf:ad69:d2d2/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
    inet6 fe80::ec39:143:d7d1:ad7e/64 scope link 
       valid_lft forever preferred_lft forever
3: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether c6:24:c3:d9:a4:3e brd ff:ff:ff:ff:ff:ff permaddr e0:06:e6:5e:f8:0d




В Windows

ipconfig
10) Если установлен UFW, то добавляем локалную сеть в исключения

sudo ufw allow from 15.15.15.0/24


Если вы используете межсетевой экран, не забудьте открыть необходимые порты (как правило, 137-139 + 445). Для получения информации о полном списке портов, смотрите использование портов Samba.

Правило UFW
Профиль Ufw для SMB/CIFS доступен в стандартной установке UFW в ufw-fileserver.

Разрешите Samba, выполнив команду ufw allow CIFS от имени root.

Если вы удалили профиль, создайте или отредактируйте файл /etc/ufw/applications.d/samba, добавив следующее:

[Samba]
title=LanManager-like file and printer server for Unix
description=The Samba software suite is a collection of programs that implements the SMB/CIFS protocol for unix systems, allowing you to serve files and printers to Windows, NT, OS/2 and DOS clients. This protocol is sometimes also referred to as the LanManager or NetBIOS protocol.
ports=137,138/udp|139,445/tcp
Затем загрузите этот профиль в UFW, запустив команду ufw app update Samba как root.

После этого можно разрешить доступ к Samba, запустив ufw allow Samba от имени root.

Служба firewalld
Для настройки firewalld, чтобы разрешить Samba в зоне home, выполните:

# firewall-cmd --permanent --add-service={samba,samba-client,samba-dc} --zone=home
Эти три службы таковы:

samba: для общего доступа к файлам.
samba-client: для просмотра общих ресурсов других устройств по сети.
samba-dc: для контроллера домена Active Directory.
Параметр --permanent сделает изменения постоянными.

Использование
Управление пользователями
В следующем разделе описывается создание локальной (tdbsam) базы данных пользователей Samba. Для аутентификации пользователей и других целей Samba также может быть привязана к домену Active Directory, может сама служить контроллером домена Active Directory или использоваться с сервером LDAP.

Добавление пользователя
Для работы Samba требуется какой-нибудь Linux-пользователь — вы можете использовать существующего пользователя или создать нового.

Примечание: Пользователь и группа nobody изначально существуют в системе, используются как гостевой аккаунт (guest account) по умолчанию и могут быть использованы в ресурсах для общего доступа с опцией guest ok = yes, благодаря чему пользователям не понадобится логиниться для доступа к таким ресурсам.
Хотя имена пользователей Samba общие с системными пользователями, Samba использует для них отдельные пароли. Чтобы добавить нового пользователя Samba, воспользуйтесь следующей, заменив пользователь_samba на имя нужного пользователя:

# smbpasswd -a пользователь_samba
Будет предложено задать пароль для этого пользователя.

В зависимости от роли сервера может понадобиться изменить разрешения и атрибуты файлов для аккаунта Samba.

Если вы хотите разрешить новому пользователю только доступ к Samba-ресурсам и запретить полноценный вход в систему, можно ограничить возможности входа:

отключить командную оболочку - usermod --shell /usr/bin/nologin --lock пользователь_samba
отключить вход по SSH - измените опцию AllowUsers в файле /etc/ssh/sshd_config
См. также рекомендации по повышению защищённости системы.




Пример файла /etc/samba/smb.conf после создания домена с SAMBA_INTERNAL:
 Global parameters
[global]
 dns forwarder = 8.8.8.8
 netbios name = DC1
 realm = TEST.ALT
 server role = active directory domain controller
 workgroup = TEST
 idmap_ldb:use rfc2307 = yes
[sysvol]
 path = /var/lib/samba/sysvol
 read only = No
[netlogon]
 path = /var/lib/samba/sysvol/test.alt/scripts
 read only = No






#######################

clear
echo -e "${MAGENTA}
  <<< Установка Свободных и Проприетарных драйверов для видеокарт (nvidia, amd, intel), а также драйверов для принтера. >>> ${NC}"
# Install Proprietary drivers for video cards (nvidia, amd, intel), as well as printer drivers.
echo -e "${RED}==> Внимание! ${NC}Если у Вас ноутбук, и установлен X.Org Server (иксы), то в большинстве случаев драйвера для видеокарты уже установлены. Возможно! общий драйвер vesa (xf86-video-vesa), который поддерживает большое количество чипсетов (но не включает 2D или 3D ускорение)."
######### Drivers ##############
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
sleep 01

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Timeshift_Autosnap (пакет timeshift-autosnap) для создания моментальных снимков (снапшотов)  перед обновлением системы Archlinux?"
# Install Timeshift_AUTOSNAP (timeshift-autosnap package) to create snapshots before updating the Archlinux system?
echo -e "${MAGENTA}=> ${BOLD}Timeshift_Autosnap (timeshift-autosnap) - это Скрипт автоматического создания моментальных снимков со сдвигом во времени, который запускается перед обновлением пакета с использованием хука Pacman. Этот скрипт создан для Arch и дистрибутивов на его основе. ${NC}"
echo -e "${YELLOW}:: ${NC}Функции: Создает снимки Timeshift с уникальными комментариями. Удаляет старые снимки, созданные с помощью этого скрипта. Автоматически генерирует grub, если установлен пакет grub-btrfs. Можно выполнить вручную, запустив timeshift-autosnap команду с повышенными привилегиями. Autosnaphot можно временно пропустить, установив переменную окружения SKIP_AUTOSNAP (например sudo SKIP_AUTOSNAP= pacman -Syu, )."
echo " Параметры /etc/timeshift-autosnap.conf: skipAutosnap- если установлено значение true , скрипт не будет выполнен. deleteSnapshots- если установлено значение false, старые снимки не будут удалены. maxSnapshots- определяет максимальное количество сохраняемых старых снимков. updateGrub- если установлено значение false, записи grub не будут созданы. snapshotDescription- определяет значение, используемое для различения снимков, созданных с помощью timeshift-autosnap. "
echo -e "${CYAN}:: ${NC}Сама утилита проста в использовании и может работать по вашей настройке в (/etc/timeshift-autosnap.conf). В первую очередь данная утилита может понадобится тем, кто экспериментирует с настройками системы. Да и в общем, всегда приятно иметь работоспособную копию, на всякий пожарный как говорится."
echo " Изменить настройки создания снапшотов при обновлении можно в файле /etc/timeshift-autosnap.conf. Скрипт добавит в GRUB раздел с вариантами загрузки системы из созданного им снапшота. "
echo " Работать Timeshift_Autosnap может в двух режимах, это BTRFS и RSYNC. Первый режим работает благодаря файловой системе BTRFS и создаются снимки системы с использованием встроенных функций самой BTRFS. А второй режим RSYNC создает снимки с использованием функции rsync. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_autosnap  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_autosnap" =~ [^10] ]]
do
    :
done
if [[ $i_autosnap == 0 ]]; then
echo ""
echo " Установка Timeshift_Autosnap пропущена "
elif [[ $i_autosnap == 1 ]]; then
  echo ""
  echo " Установка Timeshift_Autosnap (Утилита создания моментальных снимков) "
##### grub-btrfs ######
# sudo pacman -S --noconfirm --needed snapper  # Инструмент для управления моментальными снимками BTRFS и LVM. Он может создавать, сравнивать и восстанавливать моментальные снимки и обеспечивает автоматическую привязку по времени ; http://snapper.io/ ; https://archlinux.org/packages/extra/x86_64/snapper/  
#sudo pacman -S --noconfirm --needed grub-btrfs  # Включить снимки btrfs в параметры загрузки GRUB ; https://github.com/Antynea/grub-btrfs ; https://archlinux.org/packages/extra/any/grub-btrfs/
####  Описание:
# grub-btrfs улучшает загрузчик grub, добавляя подменю снимков btrfs, позволяющее пользователю загружаться в снимки.
# grub-btrfs поддерживает создание снимков вручную, а также снимков, созданных с помощью snapper, timeshift и yabsnap.
# Предупреждение: загрузка снимков, доступных только для чтения, может оказаться сложной задачей
##### timeshift-autosnap ######
#yay -S timeshift-autosnap --noconfirm  # Скрипт автоматического создания моментальных снимков со сдвигом во времени, который запускается перед обновлением пакета с использованием хука Pacman ; https://aur.archlinux.org/timeshift-autosnap.git (только для чтения, нажмите, чтобы скопировать) ; https://gitlab.com/gobonja/timeshift-autosnap ; https://aur.archlinux.org/packages/timeshift-autosnap
# yay -Rns timeshift-autosnap  # Удалите timeshift-autosnap из Arch с помощью YAY
# git clone https://aur.archlinux.org/timeshift-autosnap.git ~/timeshift-autosnap   # Клонировать git timeshift-autosnap локально
git clone https://aur.archlinux.org/timeshift-autosnap.git 
# cd ~/timeshift-autosnap  # Перейдите в папку ~/timeshift-autosnap и установите его
cd timeshift-autosnap
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf timeshift-autosnap
rm -Rf timeshift-autosnap   # удаляем директорию сборки 
echo ""
echo " Установка Timeshift_Autosnap выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
sleep 01

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
echo -e "${MAGENTA}
  <<< Установка Java JDK средство разработки и среда для создания Java-приложений в Archlinux >>> ${NC}"
# Installing Java JDK is a development tool and environment for creating Java applications in Archlinux
echo ""
echo -e "${GREEN}==> ${NC}Установить Java JDK средство разработки и среда для создания Java-приложений?"
#echo -e "${BLUE}:: ${NC}Установить Java JDK средство разработки и среда для создания Java-приложений?"
#echo 'Установить Java JDK средство разработки и среда для создания Java-приложений?'
# Install the Java JDK development tool and environment for creating Java applications?
echo " Java JDK – это набор инструментов специально для разработчиков. Он содержит элементы для программирования на этом языке, а также позволяет преобразовать код или «собрать» его, а затем выполнить. Каждый Java-программист полагается на JDK для создания программ, виртуальных сред, их запуска и отладки. Без JDK вы все еще можете писать код, но не можете перейти к созданию запускаемой программы. Следовательно, наличие установленного JDK жизненно важно, если вы хотите работать с Java, поскольку по-другому вы не сможете этого сделать. Оригинальная Java Development Kit была создана компанией Oracle. В настоящее время имеется немало дистрибутивов, которые были произведены сторонними разработчиками. "
echo " Интересно то, что Java Runtime Environment может быть и независимым компонентом для простого запуска программ Java, будучи при этом частью JDK. Java Development Kit требует JRE, так как запуск программ Java является частью их разработки. "
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующий вариант: ${NC}"
echo -e "${MAGENTA}:: ${NC}OpenJDK Java 8 - jdk8-openjdk - Комплект разработчика OpenJDK Java 8 ; jre8-openjdk - Полная среда выполнения OpenJDK Java 8 ; jre8-openjdk-headless - OpenJDK Java 8 автономная среда выполнения ; java-runtime-common - Общие файлы для сред выполнения Java ; semver - Парсер семантической версии, используемый npm ; npm - Менеджер пакетов для javascript и пакеты - openjdk8-doc ; openjdk8-src - они закомментированы! "
echo " Также присутствует пакет из AUR - java8-openjfx - Платформа клиентских приложений Java OpenJFX 8 (реализация JavaFX с открытым исходным кодом) - закомментирован #. (https://aur.archlinux.org/java8-openjfx.git) "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить Java JDK 8,      0 - НЕТ - Пропустить установку: " in_jdk  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_jdk" =~ [^10] ]]
do
    :
done
if [[ $in_jdk == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_jdk == 1 ]]; then
  echo ""
  echo " Установка Java JDK средство разработки "
############ Java JDK 8 ################
# sudo pacman -S --noconfirm --needed jdk8-openjdk jre8-openjdk jre8-openjdk-headless
sudo pacman -S --noconfirm --needed jdk8-openjdk  # Комплект разработчика OpenJDK Java 8 ; https://openjdk.java.net/ ; https://archlinux.org/packages/extra/x86_64/jdk8-openjdk/
sudo pacman -S --noconfirm --needed jre8-openjdk  # Полная среда выполнения OpenJDK Java 8 ; https://openjdk.java.net/ ; https://archlinux.org/packages/extra/x86_64/jre8-openjdk/
sudo pacman -S --noconfirm --needed jre8-openjdk-headless  # OpenJDK Java 8 автономная среда выполнения ; https://openjdk.java.net/ ; https://archlinux.org/packages/extra/x86_64/jre8-openjdk-headless/
# sudo pacman -S --noconfirm --needed openjdk8-doc  # 
# sudo pacman -S --noconfirm --needed openjdk8-src  # 
sudo pacman -S --noconfirm --needed java-runtime-common  # Общие файлы для сред выполнения Java ; https://www.archlinux.org/packages/extra/any/java-common/ ; https://archlinux.org/packages/extra/any/java-runtime-common/
sudo pacman -S --noconfirm --needed semver  # Парсер семантической версии, используемый npm
sudo pacman -S --noconfirm --needed npm  # Менеджер пакетов для javascript
# sudo pacman -S --noconfirm --needed 
#echo -e "${BLUE}:: ${NC}Установка Java8 пакета (java8-openjfx) из AUR "
################## java8-openjfx ############## Недостающие зависимости: -> python2
# yay -S java8-openjfx --noconfirm  # Платформа клиентских приложений Java OpenJFX 8 (реализация JavaFX с открытым исходным кодом) ; https://aur.archlinux.org/java8-openjfx.git (только для чтения, нажмите, чтобы скопировать) ; https://wiki.openjdk.org/display/OpenJFX/Main ; https://aur.archlinux.org/packages/java8-openjfx
#git clone https://aur.archlinux.org/java8-openjfx.git   # (только для чтения, нажмите, чтобы скопировать) https://aur.archlinux.org/packages/gtkhash
#cd java8-openjfx
#makepkg -fsri  
#makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)  
#rm -Rf java8-openjfx  # удаляем директорию сборки
# rm -rf java8-openjfx 
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
###############

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Oracle VM VirtualBox (для виртуализации рабочих столов)?"
#echo -e "${BLUE}:: ${NC}Установить Oracle VM VirtualBox (для виртуализации рабочих столов)"
#echo 'Установить Oracle VM VirtualBox (для виртуализации рабочих столов)?'
# Install Oracle VM VirtualBox (for desktop virtualization)?
echo -e "${MAGENTA}:: ${NC}VirtualBox — это средство, позволяющее создавать на ПК виртуальную машину со своей собственной операционной системой. VirtualBox — это мощный продукт виртуализации x86 и AMD64/Intel64 для корпоративного и домашнего использования. VirtualBox — это не только чрезвычайно многофункциональный, высокопроизводительный продукт для корпоративных клиентов, но и единственное профессиональное решение, которое свободно доступно как программное обеспечение с открытым исходным кодом в соответствии с условиями GNU General Public License (GPL) версии 3."
echo " В настоящее время VirtualBox работает на хостах Windows, Linux, macOS и Solaris и поддерживает большое количество гостевых операционных систем, включая, помимо прочего, Windows (NT 4.0, 2000, XP, Server 2003, Vista, 7, 8, Windows 10 и Windows 11), DOS/Windows 3.x, Linux (2.4, 2.6, 3.x, 4.x, 5.x и 6.x), Solaris и OpenSolaris, OS/2, OpenBSD, NetBSD и FreeBSD. "
echo " Всем виртуальным машинам выделяется пространство на физическом диске. Их операционные системы называются гостевыми, а ОС физического ПК — хостовой. "
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующий вариант: ${NC}"
echo -e "${MAGENTA}:: ${NC}VM VirtualBox - virtualbox - Мощная виртуализация x86 как для корпоративного, так и для домашнего использования ; virtualbox-host-dkms - Источники модулей ядра VirtualBox Host ; linux-headers или linux-lts-headers (для ядра lts как у меня) - Заголовки и скрипты для сборки модулей для ядра Linux-LTC, если у вас ядро (linux) - то раскомментируйте пакет (linux-headers)! "
echo " Также присутствует пакет из AUR - virtualbox-ext-oracle - Пакет расширений Oracle VM VirtualBox - НЕ закомментирован # (https://aur.archlinux.org/virtualbox-ext-oracle.git) "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить VM VirtualBox,      0 - НЕТ - Пропустить установку: " in_jdk  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_jdk" =~ [^10] ]]
do
    :
done
if [[ $in_jdk == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_jdk == 1 ]]; then
  echo ""
  echo " Установка Oracle VM VirtualBox "
sudo pacman -Syu  # Обновим вашу систему (базу данных пакетов)
############ Oracle VM VirtualBox ################
sudo pacman -S --noconfirm --needed virtualbox  # Мощная виртуализация x86 как для корпоративного, так и для домашнего использования ; https://www.virtualbox.org/
# sudo pacman -S --noconfirm --needed virtualbox-host-modules-arch  # для ядра linux - Модули ядра хоста Virtualbox для Arch Kernel (ошибка: не удалось подготовить транзакцию (конфликтующие зависимости:  virtualbox-host-modules-arch and virtualbox-host-dkms)
# sudo pacman -Qs virtualbox  # -s — поиск пакета ; Команда для поиска только среди установленных пакетов: pacman -Qs [имя_пакета] ; 
sudo pacman -S --noconfirm --needed virtualbox-host-dkms  # для других ядер - Источники модулей ядра VirtualBox Host
#sudo pacman -S --noconfirm --needed linux-headers  # Заголовки и скрипты для сборки модулей для ядра Linux
sudo pacman -S --noconfirm --needed linux-lts-headers  # Заголовки и скрипты для сборки модулей для ядра Linux-LTC
### Что касается моего подхода к использованию linux-lts ядра, я следовал руководству Arch Linux и установил linux-lts-headers вместо linux-headers.
### !!! Необязательно !!!!
# sudo pacman -S --noconfirm --needed rdesktop  # Клиент с открытым исходным кодом для служб удаленного рабочего стола Windows
### Настройка гостевых дополнений на виртуалке.
#sudo pacman -S --noconfirm --needed virtualbox-guest-utils  # Утилиты пользовательского пространства VirtualBox Guest
#sudo pacman -S --noconfirm --needed linux-headers  # Заголовки и скрипты для сборки модулей для ядра Linux
#sudo pacman -S --noconfirm --needed virtualbox-guest-dkms  # Исходники модулей ядра VirtualBox Guest
sudo pacman -S --noconfirm --needed virtualbox-guest-iso  # Официальный ISO-образ VirtualBox Guest Additions
echo " Установка обязательного модуля ядра (vboxdrv) для VirtualBox, который должен быть загружен перед запуском любой виртуальной машины. "
sudo modprobe vboxdrv  # Загрузка обязательного модуля ядра
#sudo modprobe -a vboxdrv
###sudo service vboxdrv setup
### `Модуль vboxdrv` — это модуль ядра, который обеспечивает поддержку программного обеспечения виртуализации VirtualBox. Он необходим для запуска виртуальных машин в системе Linux. `Модуль vboxdrv` включен в установочный пакет VirtualBox. Однако он не устанавливается автоматически при установке VirtualBox. Вам необходимо вручную установить `модуль vboxdrv`, если вы хотите использовать VirtualBox в своей системе Linux.
# sudo lsmod | grep vboxdrv  # проверить, загружен ли `модуль vboxdrv`
# sudo modprobe -l vboxdrv  # проверить зависимости модулей ядра
# sudo modinfo vboxdrv  # проверить версию модуля ядра
# ls /etc/modprobe.d/  # Это выведет список всех файлов в каталоге `/etc/modprobe.d/`
# ls /etc/modules-load.d/  # Это выведет список всех файлов в каталоге `/etc/modules-load.d/`
#sudo /sbin/lsmod | grep vboxdrv  # Проверьте, включен ли модуль ядра VirtualBox
#sudo /sbin/modprobe -a vboxdrv   # Если модуль `vboxdrv` не включен, то вы можете включить его
#sudo cat /etc/modprobe.d/blacklist.conf  # Проверьте, что модуль ядра VirtualBox не занесен в черный список
#sudo sed -i ‘/vboxdrv/d’ /etc/modprobe.d/blacklist.conf  # Если модуль `vboxdrv` занесен в черный список, то вы можете удалить его из черного списка
#sudo /sbin/lsmod | grep -v vboxdrv  # Проверьте, не конфликтует ли модуль ядра VirtualBox с другим модулем ядра
#sudo /sbin/rcvboxdrv -h  # Выгрузка модулей
#sudo /sbin/rcvboxdrv -h  # вы можете запустить это
echo " Установка модулей ядра (vboxguest); (vboxsf); (vboxvideo) Гостевые дополнения для VirtualBox "
sudo modprobe -a vboxguest vboxsf vboxvideo
# sudo modprobe vboxguest  #
# sudo modprobe vboxsf  #
# sudo modprobe vboxvideo  #
### VirtualBox: modprobe не может найти vboxguest, vboxsf, vboxvideo
### Вы можете использовать uname -r, чтобы найти строку версии вашего ядра.
### 6.6.40-1-lts
### После повторного запуска modprobe все должно заработать
### depmod 6.6.40-1-lts-ARCH
echo " Установка модулей ядра (vboxnetadp) (vboxnetflt) для расширенных конфигурациях VirtualBox "
sudo modprobe -a vboxnetadp vboxnetflt
# sudo modprobe vboxnetadp  # нужен для создания интерфейса хоста в глобальных настройках VirtualBox
# sudo modprobe vboxnetflt  # нужен для запуска виртуальной машины с использованием этого сетевого интерфейса 
# sudo pacman -Ql virtualbox-guest-modules   # чтобы узнать, где находятся модули
# sudo pacman -S --noconfirm --needed 
echo -e "${BLUE}:: ${NC}Установка пакета (virtualbox-ext-oracle) из AUR "
echo " Установка Virtualbox Extension Pack для дополнительных функций, которые недоступны по умолчанию "
################## virtualbox-ext-oracle ##############
# yay -S virtualbox-ext-oracle --noconfirm  # Пакет расширений Oracle VM VirtualBox ; https://aur.archlinux.org/virtualbox-ext-oracle.git (только для чтения, нажмите, чтобы скопировать) ; https://www.virtualbox.org/ ; https://aur.archlinux.org/packages/virtualbox-ext-oracle
## yay -S virtualbox-ext-oracle-dev --noconfirm  # Пакет расширений Oracle VM VirtualBox для версии Virtualbox dev ; https://aur.archlinux.org/virtualbox-ext-oracle-dev.git (только для чтения, нажмите, чтобы скопировать) ; https://www.virtualbox.org/ ; https://aur.archlinux.org/packages/virtualbox-ext-oracle-dev
git clone https://aur.archlinux.org/virtualbox-ext-oracle.git   # (только для чтения, нажмите, чтобы скопировать) https://aur.archlinux.org/packages/gtkhash
cd virtualbox-ext-oracle
#makepkg -fsri  
makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)  
rm -Rf virtualbox-ext-oracle  # удаляем директорию сборки
# rm -rf virtualbox-ext-oracle 
echo " Установим Графический интерфейс пользователя основан на QT "
sudo pacman -S --noconfirm --needed qt5-x11extras  # Предоставляет API-интерфейсы для X11, специфичные для платформы ; https://www.qt.io/ ; https://archlinux.org/packages/extra/x86_64/qt5-x11extras/ (только для пользователей Arch Linux)
echo -e "${BLUE}:: ${NC}Добавим учетную запись пользователя в группу пользователей vbox "
echo " Чтобы предоставить себе разрешения для доступа VirtualBox к общим папкам и USB устройствам "    
### sudo gpasswd -a имя_пользователя vboxusers  (sudo gpasswd -a [имя пользователя] vboxusers) - Не забудьте указать свое имя пользователя вместо username поля.
sudo gpasswd -a $USER vboxusers
#sudo gpasswd -a $username vboxusers
#sudo gpasswd -a alex vboxusers 
echo -e "${BLUE}:: ${NC}Добавим записи о модули ядра (vboxdrv) в файлик virtualbox.conf (/etc/modules-load.d/virtualbox.conf) "
echo " Чтобы загрузить модуль VirtualBox во время загрузки "
### Чтобы загрузить модуль VirtualBox во время загрузки, обратитесь к разделу Kernel_modules#Loading и создайте файл *.conf со строкой:
# sudo sed -i 'vboxdrv' /etc/modules-load.d/virtualbox.conf
echo -e "vboxdrv\nvboxguest\nvboxsf\nvboxvideo\nvboxnetadp\nvboxnetflt" | sudo tee /etc/modules-load.d/virtualbox.conf
# в расположении (in location) /etc/modules-load.d/virtualbox.conf
#sudo su
#touch /etc/modules-load.d/virtualbox.conf
#echo "vboxdrv" > /etc/modules-load.d/virtualbox.conf
#echo "vboxguest" >> /etc/modules-load.d/virtualbox.conf
#echo "vboxsf" >> /etc/modules-load.d/virtualbox.conf
#echo "vboxnetadp" >> /etc/modules-load.d/virtualbox.conf
#echo "vboxnetflt" >> /etc/modules-load.d/virtualbox.conf
echo ""
echo " Просмотри внесённые изменения в virtualbox.conf "
cat /etc/modules-load.d/virtualbox.conf
sleep 1
echo " Создадим общую и дополнительные директории (папки) , для работы на виртуалке "
### mkdir /home/<user>/vboxshare
mkdir ~/vboxshare  # Общая директория, на машине
# mkdir ~/VboxShare
mkdir ~/VirtualBox VMs  # Директория для работы 
mkdir ~/VboxClient   # Директория для сетевых машин
########## Общая директория, на виртуалке ############
### sudo mount -t vboxsf -o uid=1000,gid=1000 sharename /home/<user>/vboxshare  # При соблюдении предварительных условий мы можем подключить эти общие папки вручную
# sudo mount -t vboxsf -o rw,uid=1000,gid=1000 vboxshare vboxshare
### Войдите в виртуальную машину с учетной записью root
### Проверьте, существует ли группа vboxsf
# group vboxsf /etc/group
### Проверьте, нет ли пользователя в группе vboxsf
### id -Имя пользователя
### Автоматическое монтирование с помощью Virtual Box Manager
### В случае, если мы включили автоматическое монтирование при создании общей папки из Virtual Box Manager, эти общие папки будут автоматически смонтированы в гостевой папке с точкой монтирования /media/sf_<имя_папки>. Чтобы получить доступ к этим папкам, пользователи в гостевой системе должны быть членами группы vboxsf.
### Добавьте пользователя Имя пользователя в группу vboxsf
### sudo usermod -Имя пользователя в vboxsf
#sudo usermod -aG vboxsf $USER
### Гостю потребуется перезагрузить компьютер, чтобы добавить новую группу.
### Проверьте еще раз группы пользователей
### id -Имя пользователя
### Перезагрузитесь и войдите в систему под именем пользователя!
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############## Справка #############
### Следующие модули требуются только в расширенных конфигурациях:
# vboxnetadp и vboxnetflt оба нужны, когда вы собираетесь использовать функцию мостовой или только хостовой сети . Точнее, vboxnetadp нужен для создания интерфейса хоста в глобальных настройках VirtualBox и vboxnetflt нужен для запуска виртуальной машины с использованием этого сетевого интерфейса.
# Примечание: Если модули ядра VirtualBox были загружены в ядро ​​во время обновления модулей, вам необходимо перезагрузить их вручную, чтобы использовать новую обновленную версию. Для этого запустите vboxreload как root.
# Arch Wiki Virtualbox 
# https://wiki.archlinux.org/index.php/VirtualBox_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# Подробные инструкции по использованию VirtualBox см. в официальной документации VirtualBox (https://www.virtualbox.org/manual/UserManual.html)
####################################

clear
echo -e "${MAGENTA}
  <<< Установка дополнительного программного обеспечения (пакетов) для личных данных пользователя в Archlinux >>> ${NC}"
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
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu
##### mugshot ######
  echo ""
  echo " Установка Mugshot из AUR (для настройки личных данных пользователя) "
# sudo pacman -S xfce4-whiskermenu-plugin --noconfirm  # Меню для Xfce4
# yay -S mugshot --noconfirm  # Программа для обновления личных данных пользователя ; https://aur.archlinux.org/mugshot.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/bluesabre/mugshot ; https://aur.archlinux.org/packages/mugshot
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
################## 

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Osmo (пакет osmo) - продвинутый персональный органайзер?"
# Install Osmo (osmo package) - advanced personal organizer?
echo -e "${MAGENTA}=> ${BOLD}Osmo - это удобный персональный органайзер, включающий в себя календарь, менеджер задач, адресную книгу и модули заметок. Он был разработан как небольшой, простой в использовании и красивый инструмент PIM для управления личной информацией. В своем текущем состоянии органайзер довольно удобен в использовании — например, пользователь может выполнять почти все операции с помощью клавиатуры. Кроме того, многие параметры можно настраивать в соответствии с предпочтениями пользователя. С технической стороны Osmo — это инструмент на основе GTK+, который использует простую базу данных XML для хранения всех персональных данных. Можно экспортировать все внесенные в Osmo задачи в файл ICS. Для облегчения ввода поддерживается импортирование и экспортирование в CSV-файл. ${NC}"
echo -e "${YELLOW}:: ${NC}Особенности: Модули календаря, задач, контактов и заметок; Резервное копирование зашифрованных личных данных; Калькулятор даты; Настраиваемый макет графического интерфейса (Высоко настраиваемый). "
echo " В настоящее время Osmo имеет следующие возможности: - Календарь: дневные заметки с текстовыми атрибутами (курсив, полужирный, подчеркнутый и т. д.); калькулятор даты; встроенный календарь на весь год; компактный режим; вспомогательные календари на следующий и предыдущий месяц; базовая поддержка iCalendar (импорт/экспорт); интеграция с модулями «Задачи» и «Контакты». "
echo -e "${CYAN}:: ${NC}Задания: расширенное напоминание; Действия по тревоге для каждой задачи (команды, звуки и т. д.); печать списка задач; Быстрый поиск; фильтр категории; изменение даты платежа на лету; базовая поддержка iCalendar (экспорт); раскраска задачи, зависящая от даты. Контакты: надежная функциональность поиска; браузер дней рождения; адреса расположение на карте; базовые фильтры импорта/экспорта (csv, xhtml). Примечания: удобный селектор заметок; фильтр категории; Быстрый поиск; опциональное шифрование с использованием пароля, определяемого пользователем; Атрибуты текста (курсив, полужирный, подчеркнутый и т. д.. Язык интерфейса: русский; Лицензия: GNU GPL; Домашняя страница: (osmo-pim.sourceforge.net). "
echo " Osmo - это очень удобный персональный органайзер, который выполняет поставленные перед ним задачи на отлично. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_osmo  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_osmo" =~ [^10] ]]
do
    :
done
if [[ $i_osmo == 0 ]]; then
echo ""
echo " Установка Osmo пропущена "
elif [[ $i_osmo == 1 ]]; then
  echo ""
  echo " Установка Osmo (персональный органайзер) "
##### osmo ######
sudo pacman -S --noconfirm --needed osmo  # Удобный персональный органайзер ; https://clayo.org/osmo/ ; https://archlinux.org/packages/extra/x86_64/osmo/ ; https://osmo-pim.sourceforge.net/
echo ""
echo " Установка Osmo выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
########## Справка #################
### Есть возможность загрузки в фоновом режим, при этом в "трее" появляется значок быстрого доступа к органайзеру.
# Osmo сигнализирует о надвигающейся задаче звуковым сигналом и окном уведомления, при этом значок в "трее" начинает мигать. Пропустить все эти сигналы достаточно сложно.
# Вся внесенная информация надежно шифруется. Алгоритм шифрования можно выбрать из доступного списка.
# Органайзер Osmo для Linux (https://itmag.pro/unix/common/osmo)
# Можно задать выполнение какой либо команды для напоминания. Например так:
# mail -s "hey, you! You should do one thing! Did you forget?" youremail@example.org
# Несмотря на то, что osmo графическое приложение, есть и парочка полезных опций запуска:
# -c, --calendar Показать только календарь.
# -e, --check Показать окно с задачами при запуске
# -d, --days На сколько назад проверять задачи
# -s, --config=PATH Указать путь к файлу конфигурации osmo.
# -t, --tinygui Сделает минималистичный интерфейс. Удобно когда маленький экран.
### Проблему с синхронизацией между обычным компьютером и нетбуком, я решаю традиционно (для меня), с помощью dropbox и симлинка.
####################################



##########################################################





clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Fdupes (пакет fdupes) - для поиска и удаления дубликатов файлов?"
# Install Rpmlint([rm] line) (rmlint package) - A tool for removing duplicates and other garbage and (rpmlint-shredder package) - A graphical user interface for rmlint?
echo -e "${MAGENTA}=> ${BOLD}Fdupes: инструмент CLI - это утилита Командной строки Linux, написанная Адрианом Лопесом на языке программирования C , выпущенная по лицензии MIT. Приложение способно находить дубликаты файлов в заданном наборе каталогов и подкаталогов. Fdupes распознает дубликаты, сравнивая сигнатуру MD5 файлов с последующим побайтовым сравнением. С помощью Fdupes можно передавать множество параметров для перечисления, удаления и замены файлов жесткими ссылками на дубликаты. ${NC}"
echo -e "${YELLOW}:: ${NC}Особенности: Сравнение начинается в следующем порядке: Сравнение размеров > Частичное сравнение подписей MD5 > Полное сравнение подписей MD5 > Побайтовое сравнение. (😃) "
echo " Функции: Перед началом работы не будет лишним ознакомиться с инструментом, выполнив команду: fdupes --help . "
echo -e "${CYAN}:: ${NC}Это обычное требование для большинства пользователей компьютеров — найти и заменить дубликаты файлов. Поиск и удаление дубликатов файлов — утомительная работа, требующая времени и терпения. Поиск дубликатов файлов может быть очень простым, если ваш компьютер работает на GNU/Linux, благодаря утилите ' fdupes '. "
echo " Лицензия: MIT; Домашняя страница: ( https://github.com/adrianlopezroche/fdupes). Подробная документация доступна по адресу: (https://archlinux.org/packages/extra/x86_64/fdupes/ ; https://man.archlinux.org/man/fdupes.1.en). Контактная информация для Адриана Лопеса (электронная почта: adrianlopezroche@gmail.com)"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_fdupes  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_fdupes" =~ [^10] ]]
do
    :
done
if [[ $i_fdupes == 0 ]]; then
echo ""
echo " Установка Fdupes пропущена "
elif [[ $i_fdupes == 1 ]]; then
  echo ""
  echo " Установка Fdupes (удаления дубликатов) "
##### fdupes ######
sudo pacman -S --noconfirm --needed fdupes  # Программа для выявления или удаления дубликатов файлов, находящихся в указанных каталогах ; https://github.com/adrianlopezroche/fdupes ; https://archlinux.org/packages/extra/x86_64/fdupes/ ; https://man.archlinux.org/man/fdupes.1.en 
echo ""
echo " Установка Fdupes выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
########## Справка #################
### Перед началом работы не будет лишним ознакомиться с инструментом, выполнив команду: fdupes --help
# Использование:
# fdupes -r /home/user/downloads
# ключ -r — заставляет искать в том числе и в подкаталогах, ниже заданного.
# Перенаправление в файл — удобно, если список дубликатов слишком большой:
# fdupes -r /home/user/downloads > /home/user/duplicates.txt
# Поиск файлов повторяющихся более одного раза и сохранение результатов в файл:
# awk 'BEGIN{d=0} NF==0{d=0} NF>0{if(d)print;d=1}' /home/user/duplicates.txt > /home/user/duplicates.to.delete.txt
# Заключение всех строк имен файлов в апострофы (чтобы исключить влияние пробелов в именах для следующей команды rm):
# sed "s/\(.*\)/'\1'/" /home/user/duplicates.to.delete.txt > /home/user/duplicates.to.delete.ok.txt
# Файл должен быть с LF переводом строки.
# Заключение всех строк имен файлов в кавычки (чтобы исключить влияние пробелов в именах для следующей команды rm):
# awk '{print "\"" $0 "\""}' /home/user/duplicates.to.delete.txt  > /home/user/duplicates.to.delete.ok.txt
# или
# sed "s/\(.*\)/\"\1\"/" /home/user/duplicates.to.delete.txt > /home/user/duplicates.to.delete.ok.txt
# Файл должен быть с LF переводом строки.
# Удаление файлов, повторяющихся более одного раза:
# xargs rm < /home/user/duplicates.to.delete.ok.txt
# Этой командой производится поиск и удаление (ключ -d) дубликатов без дополнительных подтверждений на удаление (ключ -N) в текущем каталоге: fdupes -d -N /home/user/download
####################################




clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Плагин Thunar Shares (thunar-shares-plugin) для быстрого совместного использования папки с помощью Samba из Thunar (файловый менеджер Xfce)?" 
echo -e "${CYAN}:: Предисловие! ${NC}Редактор общего доступа находится в диалоговом окне свойств файла (страница «Поделиться»). "
echo -e "${MAGENTA}:: ${BOLD}Плагин Thunar Shares (thunar-shares-plugin) позволяет быстро предоставить общий доступ к папке с помощью Samba из Thunar (файловый менеджер Xfce) без необходимости получения прав root. ${NC}"
echo -e "${MAGENTA}=> ${NC}Плагин Thunar Shares (thunar-shares-plugin) - устанавливается из пользовательского репозитория 'AUR'-'yay' (https://aur.archlinux.org/thunar-shares-plugin.git), собираются и устанавливаются. "
echo " Плагин Thunar Shares (https://gitlab.xfce.org/thunar-plugins/thunar-shares-plugin/-/tree/master) (http://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin ; https://aur.archlinux.org/packages/thunar-shares-plugin ). " 
echo -e "${YELLOW}:: Примечание! ${NC}Зависимости: (samba; thunar; xfce4-dev-tools). Источники: (https://archive.xfce.org/src/thunar-plugins/thunar-shares-plugin/0.3/thunar-shares-plugin-0.3.2.tar.bz2). "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_shares  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_shares" =~ [^10] ]]
do
    :
done 
if [[ $i_shares == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_shares == 1 ]]; then
  echo ""  
  echo " Установка Плагин Thunar Shares (thunar-shares-plugin) "
########## thunar-shares-plugin ##########
#yay -S thunar-shares-plugin --noconfirm  # Плагин Thunar для быстрого совместного использования папки с помощью Samba без необходимости root-доступа ; https://aur.archlinux.org/thunar-shares-plugin.git (только для чтения, нажмите, чтобы скопировать) ; http://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin ; https://aur.archlinux.org/packages/thunar-shares-plugin ; https://gitlab.xfce.org/thunar-plugins/thunar-shares-plugin/-/tree/master
# yay -S thunar-shares-plugin-git --noconfirm  # Плагин Thunar для быстрого предоставления общего доступа к папке с помощью Samba без необходимости доступа root ; https://aur.archlinux.org/thunar-shares-plugin-git.git (только для чтения, нажмите, чтобы скопировать) ; https://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin ; https://aur.archlinux.org/packages/thunar-shares-plugin-git
# yay -Rns thunar-shares-plugin  # Удалите thunar-shares-plugin в Arch с помощью YAY
# git clone https://aur.archlinux.org/thunar-shares-plugin.git ~/thunar-shares-plugin   # Клонировать git thunar-shares-plugin локально
git clone https://aur.archlinux.org/thunar-shares-plugin.git 
# cd ~/thunar-shares-plugin  # Перейдите в папку ~/thunar-shares-plugin и установите его
cd thunar-shares-plugin
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf thunar-shares-plugin
rm -Rf thunar-shares-plugin   # удаляем директорию сборки 
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi



















dupeGuru










clear
echo -e "${MAGENTA}
  <<< Установка Java JDK средство разработки и среда для создания Java-приложений в Archlinux >>> ${NC}"
# Installing Java JDK is a development tool and environment for creating Java applications in Archlinux


echo 'Дополнительные пакеты для игр'
# Additional packages for games
# Необходимо раскомментировать репозиторий multilib в /etc/pacman.conf.
# Steam:
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 

sudo pacman -S steam steam-native-runtime lutris lib32-dbus-glib lib32-openal lib32-nss lib32-gtk2 lib32-sdl2 lib32-sdl2_image lib32-libcanberra --noconfirm   конфигурации
lib32-libnm-glib нет!!!


yay -S portproton --noconfirm  #

sudo pacman -S --noconfirm --needed gnome-chess  # Сыграйте в классическую настольную игру в шахматы для двух игроков





#sudo pacman -S lib32-alsa-plugins lib32-curl --noconfirm

echo 'Дополнительные пакеты для игр AUR'
# Additional packages for games AUR
yay -S lib32-libudev0 --noconfirm  # ( lib32-libudev0-shim-nosystemd ) Библиотека совместимости libudev.so.0 для систем с более новыми версиями udev (32 бит)
yay -S lib32-gconf --noconfirm  # Устаревшая система базы данных
yay -S davfs2 --noconfirm  # Драйвер файловой системы, позволяющий монтировать папку WebDAV ; Раньше присутствовал в community ...





echo 'Установка Дополнительных программ'
# Installing Additional programs
echo -e "${BLUE}
'Список Дополнительных программ к установке:${GREEN}
 osmo synapse variety kleopatra' 
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then

### sudo pacman -S --noconfirm --needed hardinfo  # Системная информация и инструмент тестирования
sudo pacman -S --noconfirm --needed hexchat  # Популярный и простой в использовании графический IRC-клиент (чат)
sudo pacman -S --noconfirm --needed mutt  # Небольшой, но очень мощный текстовый почтовый клиент



synapse --noconfirm  # Средство запуска семантических файлов
sudo pacman -S --noconfirm --needed variety
########################################################













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