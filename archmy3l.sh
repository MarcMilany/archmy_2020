#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! ####
apptitle="Arch Linux Fast Install v2.5 LegasyBIOS - Version: 2025.06.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя
###
ARCHMY3L_LANG="russian"  # Installer default language (Язык установки по умолчанию)
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
drill archlinux.org | grep "Query time"  # Тест dnsmasq
echo " Выполним опрос DNS-сервера: '1.1.1.1' (@cервер) с запросом archlinux.org (доменное имя интернет-ресурса) "
dig @1.1.1.1 archlinux.org  # для опроса DNS-серверов
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
echo -e "${CYAN}:: ${NC}Эти действия необходимы, если Вы при установке основной системы пропустили какой-либо пункт меню сценария (скрипта), и хотите выполнить эти действия сейчас. (на всякий пожарный) (😃) "
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
echo " Обычно это используется для автоматизации обслуживания системы или администрирования. (😃) "
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
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " i_cron  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
echo -e "${BLUE}:: ${BOLD}Посмотрим дату, время, и часовой пояс ... (😃) ${NC}"
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
  echo " Добавим в автозагрузку NTPD (ntpd.service) "
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
echo -e "${CYAN}:: ${BOLD}Ufw расшифровывается как Uncomplicated Firewall и представляет собой программу для управления межсетевым экраном netfilter. Настройка брандмауэра на Arch Linux — это важный шаг для защиты вашей системы от несанкционированного доступа и киберугроз. (😃) ${NC}"
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed ufw gufw  # Несложный и простой в использовании инструмент командной строки для управления межсетевым экраном netfilter; GUI - для управления брандмауэром Linux
echo " Установка Брандмауэра UFW завершена "
fi
############ Справка ####################
### Установка и настройка firewalld в Arch Linux:
# https://www.linuxboost.com/how-to-configure-firewall-on-arch-linux/
# https://www.youtube.com/watch?v=K3IqPgzw4YA
####################################

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
echo -e "${YELLOW}:: ${BOLD}Запускаем UFW (сетевой экран), если таковой был вами установлен. (😃) ${NC}"
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
echo -e "${YELLOW}:: ${BOLD}Добавляем в автозагрузку UFW (сетевой экран), если таковой был вами установлен. (😃) ${NC}"
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
echo -e "${CYAN}=> ${BOLD}Используя UFW, вы можете создавать правила брандмауэра (или политики) для разрешения или запрета определенной службы. С помощью этих политик вы указываете UFW, какие порты, службы, IP-адреса и интерфейсы должны быть разрешены или запрещены. (😃) ${NC}"
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
echo -e "${MAGENTA}=> ${NC}По умолчанию журналы UFW хранятся в /var/log/ufw.log. Вы можете контролировать файл журнала с помощью команды: tail . Пример: sudo tail -f /var/log/ufw.log . (😃) "
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
echo -e "${MAGENTA}:: ${BOLD}Обычно при предоставлении удаленного доступа к Linux серверам вам предоставляется именно SSH (Secure Shell) доступ. (😃) ${NC}"
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
  sudo ufw allow 9050
# sudo ufw allow 2222/tcp  # пользовательский SSH-порт (например, порт 2222)
# sudo ufw allow ftp
# sudo ufw allow http  # разрешить все входящие соединения HTTP (порт 80)
  sudo ufw allow 53/tcp
  sudo ufw allow 43/tcp
# sudo ufw allow 80
sudo ufw allow 80/tcp  # Разрешить порт 80 для HTTP (веб-сервер)
# sudo ufw allow 64738/tcp  # (Mumble)
# sudo ufw allow 64738/udp  # пользовательский Mumble-порт (например, порт 64738)
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
echo -e "${GREEN}==> ${NC}Установить Clam AntiVirus (clamav, clamtk) (GUI)(GTK)?"
#echo -e "${BLUE}:: ${NC}Установить Clam AntiVirus (clamav, clamtk) (GUI)(GTK)?"
#echo 'Установить Clam AntiVirus (clamav, clamtk) (GUI)(GTK)?'
# Install Clam AntiVirus (clamav, clamtk) (GUI)(GTK)?
echo -e "${CYAN}:: ${BOLD}ClamAV - это антивирусный движок с открытым исходным кодом для обнаружения троянов, вирусов, вредоносных программ и других вредоносных угроз. (😃) ${NC}"
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)
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
echo ""
echo -e "${GREEN}==> ${NC}Обновить антивирусные базы Clam AntiVirus (clamav, clamtk) (GUI)(GTK)?"
echo -e "${CYAN}:: ${BOLD}ClamAV - С 2022 года проект ограничил подключения из России к своим серверам для обновления антивирусных баз ClamAV. Рассказываем как обновить ClamAV из России. После того, как ClamAV закрыл доступ, при попытке соединения с https://database.clamav.net поступает HTTP-ошибка 403 – доступ запрещён! С российских IP запрещён доступ не только к обновлениям, но ко всему домену clamav.net . ${NC}"
echo " Как обновить ClamAV в этом случае? Вариант 1 - Остановите сервис ClamAV и Скачайте антивирусные базы через Tor или VPN файлы, потом Поместить их в директорию /var/lib/clamav/ и Перезапустить сервис ClamAV (хотя не обязательно). Вариант 2 - Обновление баз ClamAV, российское зеркало TENDENCE . К сожалению, известное российское зеркало ClamAV теперь требует купить подписку на обновления. После оплаты Вы получите ссылки на обновления. Тогда можно будет проделать следующие шаги. Либо скачать последние обновления антивирусных баз можно с российского зеркала (ClamAV mirror) и положить их в /var/lib/clamav/ . Вариант 3 - Рабочее зеркало обновления на UNLIX.ru через bash скрипт. И Добавим задание в cron для еженедельного обновления антивирусных баз ClamAV ."
echo " Мы воспользуемся Вариантом №3 . И Ваш ClamAV будет обновляться даже с российских IP совершенно бесплатно. Убедительная просьба не устанавливать частоту обновления чаще, чем раз в неделю!!! (😃) "
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
    1 - Да Обновить антивирусные базы ClamAV,     0 - НЕТ - Пропустить установку: " i_antivirus  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_antivirus" =~ [^10] ]]
do
    :
done
if [[ $i_antivirus == 0 ]]; then
echo ""
echo " Установка антивирусных баз ClamAV пропущена "
elif [[ $i_antivirus == 1 ]]; then
echo ""
echo " Установка антивирусных баз Clam AntiVirus "
sudo systemctl stop clamav-freshclam
sudo wget https://unlix.ru/clamav/main.cvd -O /var/lib/clamav/main.cvd
sudo wget https://unlix.ru/clamav/daily.cvd -O /var/lib/clamav/daily.cvd
sudo wget https://unlix.ru/clamav/bytecode.cvd -O /var/lib/clamav/bytecode.cvd
################
echo ""
echo " Перезапустить сервис ClamAV (хотя не обязательно) "
sudo systemctl start clamav-freshclam
echo " Установка антивирусных баз ClamAV завершена "
echo " Теперь Ваш ClamAV будет обновляться даже с российских IP совершенно бесплатно "
fi
sleep 02
################

clear
echo ""
echo -e "${BLUE}:: ${NC}Firewalld (firewalld) - Межсетевой экран?"
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed firewalld # Демон брандмауэра с интерфейсом D-Bus ; https://firewalld.org/ ; https://archlinux.org/packages/extra/any/firewalld/ ; https://github.com/firewalld/firewalld/issues
echo " Установить зону по умолчанию как «публичную» и включить брандмауэр "
sudo firewall-cmd --set-default-zone=public
echo " Включить и запустить службу firewalld "
sudo systemctl enable firewalld.service
sudo systemctl start firewalld.service
echo " Проверить состояние firewalld и просмотреть текущие правила "
# sudo systemctl status firewalld
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
echo ""
echo -e "${BLUE}:: ${NC}OpenSnitch (opensnitch) - Обязательный брандмауэр приложений для GNU/Linux?"
echo -e "${MAGENTA}:: ${BOLD}OpenSnitch — это брандмауэр приложений с открытым исходным кодом для Linux, созданный по образцу популярного Little Snitch для macOS. Он отслеживает исходящие сетевые подключения и предупреждает вас всякий раз, когда программа пытается подключиться к интернету. Затем вы можете решить, разрешить или заблокировать подключение. Независимо от того, являетесь ли вы сторонником конфиденциальности или просто хотите обеспечить безопасность своей системы, OpenSnitch предоставляет вам необходимую прозрачность и контроль. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Когда дело доходит до защиты вашей системы Linux от нежелательных сетевых подключений, необходим хороший брандмауэр. Хотя большинство пользователей Linux полагаются на традиционные брандмауэры, такие как iptables, firewalls или ufw, они обычно работают на сетевом уровне и не обеспечивают детальный контроль над тем, какие приложения могут подключаться к интернету. Здесь на помощь приходит OpenSnitch — брандмауэр приложений GNU/Linux, который позволяет контролировать исходящие соединения для каждого приложения по отдельности. ${NC}"
echo " Ключевые особенности: Интерактивная фильтрация исходящих соединений. Блокируйте рекламу, трекеры и вредоносные домены (https://github.com/evilsocket/opensnitch/wiki/block-lists) по всей системе. Возможность настройки системного брандмауэра (https://github.com/evilsocket/opensnitch/wiki/System-rules) из графического интерфейса (nftables). Настройте политику ввода, разрешите входящие услуги и т. д. Управляйте несколькими узлами (https://github.com/evilsocket/opensnitch/wiki/Nodes) с помощью централизованного графического интерфейса. Интеграция SIEM (https://github.com/evilsocket/opensnitch/wiki/SIEM-integration).  "
echo " Зачем использовать OpenSnitch? Управляйте исходящими сетевыми запросами для каждого отдельного приложения.
Посмотрите, какие приложения подключаются к каким серверам, IP-адресам и доменам. Полностью бесплатный, с кодом, доступным на GitHub.
Поставляется с графическим интерфейсом для удобного управления правилами. Блокирует отправку данных подозрительными приложениями без вашего ведома. В отличие от традиционных брандмауэров, которые ориентированы на входящий трафик или общие правила, OpenSnitch ориентирован на исходящие соединения и приложения, которые их генерируют, что делает его идеальным решением для пользователей, которым нужен более строгий контроль над тем, что покидает их систему. OpenSnitch официально доступен в виде пакета для многих дистрибутивов Linux, таких как Ubuntu, Debian, Fedora, Arch Linux и других. "
echo " Как работает OpenSnitch: После установки и запуска OpenSnitch отслеживает каждое исходящее соединение, создаваемое вашими приложениями. При первой попытке нового приложения подключиться к интернету OpenSnitch выдаст всплывающее окно с вопросом, что делать. Вы увидите: Имя приложения и путь к нему. IP-адрес или домен, к которому он пытается подключиться. Используемый порт. Тогда вы можете выбрать: Разрешить один раз; Заблокируйте один раз; Всегда позволяйте; Всегда блокируйте. "
echo " Управление правилами: Правила создаются каждый раз, когда вы подтверждаете или отклоняете подключение. Вы можете легко управлять ими в графическом интерфейсе: Просмотрите существующие правила. Отредактируйте или удалите их. Упорядочить по приложениям или доменам. Временно отключите правила или брандмауэр полностью. OpenSnitch сохраняет эти правила в обычных текстовых файлах, поэтому при необходимости вы даже можете редактировать их вручную (обычно они находятся в /etc/opensnitch/rules/). "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_opensnitch  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_opensnitch" =~ [^10] ]]
do
    :
done
if [[ $in_opensnitch == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_opensnitch == 1 ]]; then
  echo ""
  echo " Установка OpenSnitch (opensnitch) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed opensnitch # Брандмауэр приложений GNU/Linux ; https://archlinux.org/packages/extra/x86_64/opensnitch/ ; https://github.com/evilsocket/opensnitch ; Заменяет: opensnitch-ebpf-module ; 2025-04-02 08:23 UTC
sudo pacman -S --noconfirm --needed nftables  # Таблицы Netfilter, инструменты пользовательского пространства ; https://archlinux.org/packages/extra/x86_64/nftables/ ; https://netfilter.org/projects/nftables/ ; 2025-04-23 18:47 UTC
echo " Проверить установленную версию OpenSnitch "
opensnitchd --version  # Проверить установленную версию OpenSnitch
echo " Включить и запустить демон брандмауэра и включите его запуск при загрузке "
### Обратите внимание, что для выполнения команды необходимы привилегированные права sudo.
# sudo systemctl enable --now opensnitch  # Эта команда делает сразу два действия: запускает сервис и активирует его автозапуск при старте системы
# Затем запустите systemctl daemon-reload (от имени root/с помощью sudo), чтобы перезагрузить systemd и запустить (и включить) службу:
sudo systemctl enable --now opensnitchd.service
sudo systemctl enable --now opensnitchd
sudo systemctl start opensnitchd
# sudo systemctl start opensnitch
#echo "Проверить статус OpenSnitch "
#systemctl status opensnitchd  # Проверить статус можно такой командой
# systemctl status opensnitch
echo " Проверить состояние opensnitchd и просмотреть текущие правила "
# systemctl status opensnitch  # Проверить статус можно такой командой
sudo opensnitchd --list-all
# Автостарт же графического интерфейса (свернутого в трей) обеспечивается с помощью системного .desktop файла в директории /etc/xdg/autostart:
# cat /etc/xdg/autostart/opensnitch_ui.desktop
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка пример ######################
# Пример использования: Firefox
# Предположим, вы открываете Firefox, и он пытается подключиться к Интернету.
# OpenSnitch выдаст подсказку типа:
# Приложение: /usr/lib/firefox/firefox
# Пункт назначения: 93.184.216.34 (example.com)
# Порт: 443 (HTTPS)
# Вы можете выбрать «Всегда разрешать», чтобы Firefox мог получать доступ к интернету без дополнительных запросов. Если вы не уверены в приложении или пункте назначения, вы можете выбрать «Заблокировать один раз» или «Всегда блокировать».
# OpenSnitch Предупреждает Вас о новом доступе приложения к Интернету.
####################

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
echo -e "${CYAN}=> ${BOLD}Установка поддержки Arch Wiki - будет очень актуальна, если Вы начинающий пользователь Arch'a и не только начинающий!!! (😃) ${NC}"
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
echo -e "${GREEN}==> ${NC}Установить поддержку Bluetooth?"
#echo -e "${BLUE}:: ${NC}Установим поддержку Bluetooth?"
#echo 'Установим поддержку Bluetooth?'
# Install Bluetooth support?
echo -e "${CYAN}=> ${BOLD}Установка поддержки Bluetooth и Sound support (звука) - будет очень актуальна, если Вы установили DE (среда рабочего стола) XFCE. (😃) ${NC}"
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
echo -e "${MAGENTA}
  <<< Установка Поддержки звука Клиенты ALSA или PipeWire для Archlinux >>> ${NC}"
#clear
echo ""
echo -e "${GREEN}==> ${NC}Установить пакеты Поддержки звука (ALSA или PipeWire...)?"
# Install Audio Support packages (ALSA or PipeWire...)
echo -e "${MAGENTA}:: ${BOLD}ALSA (Advanced Linux Sound Architecture) — предоставляет драйверы звуковой карты, управляемые ядром. Она заменяет оригинальную Open Sound System (OSS). Помимо драйверов звуковых устройств, ALSA также включает в себя библиотеку пользовательского пространства для разработчиков приложений. Затем они могут использовать эти драйверы ALSA для разработки API высокого уровня. Это обеспечивает прямое (ядро) взаимодействие со звуковыми устройствами через библиотеки ALSA. ALSA имеет следующие важные особенности: Эффективная поддержка всех типов аудиоинтерфейсов: от бытовых звуковых карт до профессиональных многоканальных аудиоинтерфейсов. Полностью модульные звуковые драйверы. SMP и потокобезопасная конструкция. Библиотека пользовательского пространства (alsa-lib) для упрощения программирования приложений и обеспечения более высокого уровня функциональности. Поддержка старого API Open Sound System (OSS), обеспечивающая двоичную совместимость для большинства программ OSS. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}PipeWire — это проект, направленный на значительное улучшение обработки аудио и видео в Linux. Он предоставляет графическую обработку с низкой задержкой поверх аудио- и видеоустройств, которую можно использовать для поддержки вариантов использования, которые в настоящее время обрабатываются как PulseAudio, так и JACK. PipeWire был разработан с мощной моделью безопасности, которая упрощает взаимодействие с аудио- и видеоустройствами из контейнерных приложений, при этом поддержка приложений Flatpak является основной целью. Наряду с Wayland и Flatpak мы ожидаем, что PipeWire предоставит основной строительный блок для будущего разработки приложений Linux. ${NC}"
echo " Возможности: Захват и воспроизведение аудио и видео с минимальной задержкой. Обработка мультимедиа в реальном времени аудио и видео. Многопроцессорная архитектура, позволяющая приложениям обмениваться мультимедийным контентом. Полная поддержка приложений PulseAudio, JACK, ALSA и GStreamer. Поддержка изолированных приложений. Подробнее см. Flatpak. "
echo " Домашняя страница: https://www.alsa-project.org/wiki/Main_Page ; (https://www.pipewire.org/ ; https://wiki.archlinux.org/title/PipeWire). "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# Be careful! The installation process was fully automatic. If you doubt your actions, think again...
echo ""
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить Клиенты ALSA,   2 - Установить Клиент PipeWire,    0 - НЕТ - Пропустить установку: " in_sound  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_sound" =~ [^120] ]]
do
    :
done
if [[ $in_sound == 0 ]]; then
clear
echo ""
echo " Установка поддержки Sound support пропущена "
elif [[ $in_sound == 1 ]]; then
  echo ""
  echo " Установка пакетов поддержки Sound support (alsa, pulseaudio...) "
  echo " ALSA - это тот самый звук (условно, на самом деле это звуковая подсистема ядра), который идёт напрямую из ядра и является самым быстрым, так как не вынужден проходить множество программных прослоек и микширование. "
  echo " Поэтому, если у вас нет потребности в микшировании каналов, записи аудио через микрофон и вы не слушаете музыку через Bluetooth, то ALSA может вам подойти. "
############# ALSA - Advanced Linux Sound Architecture ###########
sudo pacman -Sy --noconfirm --needed alsa-utils alsa-plugins lib32-alsa-plugins alsa-firmware alsa-lib lib32-alsa-lib alsa-card-profiles  # Расширенная звуковая архитектура Linux — Утилиты ; Дополнительные плагины ALSA ; Дополнительные плагины ALSA (32-бит) ; Бинарные файлы прошивки для программ-загрузчиков в ALSA-tools и загрузчике прошивок hotplug ; Альтернативная реализация поддержки звука в Linux ;  Профили карт ALSA, общие для PulseAudio
#########################
# sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -S --noconfirm --needed alsa-utils  # Расширенная звуковая архитектура Linux — Утилиты ; https://archlinux.org/packages/extra/x86_64/alsa-utils/ ; https://www.alsa-project.org/ ; 2025-04-14 20:27 UTC ; Пакет alsa-utils также содержит консольный Микшер (настройка громкости), который вызывается командой alsamixer.
# sudo pacman -S --noconfirm --needed alsa-plugins  # Дополнительные плагины ALSA ; https://archlinux.org/packages/extra/x86_64/alsa-plugins/ ; https://www.alsa-project.org/ ; 2024-11-07 20:01 UTC
# sudo pacman -S --noconfirm --needed lib32-alsa-plugins  # Дополнительные плагины ALSA (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-alsa-plugins/ ; https://www.alsa-project.org/ ; 2024-06-14 19:09 UTC
# sudo pacman -S --noconfirm --needed alsa-firmware  # Бинарные файлы прошивки для программ-загрузчиков в ALSA-tools и загрузчике прошивок hotplug ; https://archlinux.org/packages/extra/any/alsa-firmware/ ; https://alsa-project.org/ ; 2024-07-11 22:24 UTC
# sudo pacman -S --noconfirm --needed alsa-lib  # Альтернативная реализация поддержки звука в Linux ; https://archlinux.org/packages/extra/x86_64/alsa-lib/ ; https://www.alsa-project.org/ ; 2025-04-14 20:27 UTC
# sudo pacman -S --noconfirm --needed lib32-alsa-lib  # Альтернативная реализация поддержки звука в Linux (32 бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-alsa-lib/ ; https://www.alsa-project.org/ ; Обеспечивает: libasound.so=2-32, libatopology.so=2-32 ; 2025-04-14 20:32 UTC
# sudo pacman -S --noconfirm --needed alsa-card-profiles  # Профили карт ALSA, общие для PulseAudio ; Аудио/видео маршрутизатор и процессор с малой задержкой — профили карт ALSA ; https://archlinux.org/packages/extra/x86_64/alsa-card-profiles/ ; https://pipewire.org/ ; 28 июня 2025 г. 02:23 UTC
### sudo pacman -S alsa-tools --noconfirm  # Расширенные инструменты для определенных звуковых карт
########## Библиотека совместимости OSS ###############
sudo pacman -S --noconfirm --needed alsa-oss lib32-alsa-oss  # Библиотека совместимости OSS ; Библиотека совместимости OSS (32 бит)
sudo pacman -S --noconfirm --needed alsa-oss  # Библиотека совместимости OSS ; https://archlinux.org/packages/extra/x86_64/alsa-oss/ ; https://www.alsa-project.org/ ; Обеспечивает: libalsatoss.so=0-64, libaoss.so=0-64 ; 2024-07-11 22:24 UTC
sudo pacman -S --noconfirm --needed lib32-alsa-oss  # Библиотека совместимости OSS (32 бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-alsa-oss/ ; https://www.alsa-project.org/ ; Обеспечивает: libalsatoss.so=0-32, libaoss.so=0-32 ; 2024-09-07 09:43 UTC
########## Файлы конфигурации топологии ALSA ##########
sudo pacman -S --noconfirm --needed alsa-topology-conf alsa-ucm-conf  # Файлы конфигурации топологии ALSA ; Конфигурация (и топологии) ALSA Use Case Manager
# sudo pacman -S --noconfirm --needed alsa-topology-conf  # Файлы конфигурации топологии ALSA ; https://archlinux.org/packages/extra/any/alsa-topology-conf/ ; https://alsa-project.org/ ; 2024-07-11 22:24 UTC
# sudo pacman -S --noconfirm --needed alsa-ucm-conf  # Конфигурация (и топологии) ALSA Use Case Manager ; https://archlinux.org/packages/extra/any/alsa-ucm-conf/ ; https://alsa-project.org/ ; 2025-05-01 17:21 UTC
########## Аудиодрайвер QEMU ALSA ###############
sudo pacman -S --noconfirm --needed qemu-audio-alsa  # Аудиодрайвер QEMU ALSA ; https://archlinux.org/packages/extra/x86_64/qemu-audio-alsa/ ; https://www.qemu.org/ ; 2025-07-08 20:27 UTC
########## Многоплатформенный проигрыватель MPEG, VCD/DVD и DivX — плагины ALSA ###############
sudo pacman -S --noconfirm --needed vlc-plugin-alsa  # Многоплатформенный проигрыватель MPEG, VCD/DVD и DivX — плагины ALSA ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-alsa/ ; https://www.videolan.org/vlc/ ; 2025-07-08 20:26 UTC
  echo ""
  echo " Установка пакетов для понижения задержек звука в PulseAudio "
  echo " Установка графической панели управления звуком - pavucontrol в PulseAudio "
############ PulseAudio Утилиты #################
sudo pacman -S --noconfirm --needed pulseaudio pulseaudio-alsa pavucontrol pulseaudio-bluetooth   # Функциональный звуковой сервер общего назначения ; Конфигурация ALSA для PulseAudio ; Регулятор громкости PulseAudio ; Поддержка Bluetooth для PulseAudio
# sudo pacman -S --noconfirm --needed pulseaudio  # Функциональный звуковой сервер общего назначения ; https://archlinux.org/packages/extra/x86_64/pulseaudio/ ; https://www.freedesktop.org/wiki/Software/PulseAudio/ ; Заменяет: pulseaudio-gconf<=11.1, pulseaudio-xen<=9.0 ; Конфликты: с pipewire-pulse ; Обратные конфликты: с pipewire-pulse ; 2024-12-07 17:14 UTC
# sudo pacman -S --noconfirm --needed pulseaudio-alsa  # Конфигурация ALSA для PulseAudio ; https://archlinux.org/packages/extra/x86_64/pulseaudio-alsa/ ; https://www.alsa-project.org/ ; 2024-11-07 20:02 UTC
# sudo pacman -S --noconfirm --needed pavucontrol  # Регулятор громкости PulseAudio ; https://archlinux.org/packages/extra/x86_64/pavucontrol/ ; https://freedesktop.org/software/pulseaudio/pavucontrol/ ; 2024-08-04 05:28 UTC
# sudo pacman -S --noconfirm --needed pavucontrol-qt  # Микшер Pulseaudio в Qt (порт pavucontrol) ; https://archlinux.org/packages/extra/x86_64/pavucontrol-qt/ ; https://github.com/lxqt/pavucontrol-qt ; 2025-04-22 14:55 UTC
# sudo pacman -S --noconfirm --needed pulseaudio-bluetooth  # Поддержка Bluetooth для PulseAudio ; https://archlinux.org/packages/extra/x86_64/pulseaudio-bluetooth/ ; https://www.freedesktop.org/wiki/Software/PulseAudio/ ; 2024-12-07 17:14 UTC
sudo pacman -S --noconfirm --needed paprefs  # Диалог конфигурации для PulseAudio (PulseAudio Preferences - https://freedesktop.org/software/pulseaudio/paprefs/) ; https://archlinux.org/packages/extra/x86_64/paprefs/ ; https://freedesktop.org/software/pulseaudio/paprefs/ ; 2024-07-14 02:57 UTC
sudo pacman -S --noconfirm --needed pasystray  # Системный лоток PulseAudio (замена padevchooser) ; https://archlinux.org/packages/extra/x86_64/pasystray/ ; https://github.com/christophgysin/pasystray ; 2024-07-01 12:50 UTC
############## Разделенные пакеты ##########
# sudo pacman -S --noconfirm --needed libpulse  # Функциональный универсальный звуковой сервер (клиентская библиотека) ; https://archlinux.org/packages/extra/x86_64/libpulse/ ; https://www.freedesktop.org/wiki/Software/PulseAudio/ ; Обеспечивает:  libpulse-mainloop-glib.so=0-64, libpulse-simple.so=0-64, libpulse.so=0-64 ; 2024-12-07 17:14 UTC
### sudo pacman -S --noconfirm --needed pulseaudio-equalizer  # Графический эквалайзер для PulseAudio ; https://archlinux.org/packages/extra/x86_64/pulseaudio-equalizer/ ; https://www.freedesktop.org/wiki/Software/PulseAudio/ ; 2024-12-07 17:14 UTC
sudo pacman -S --noconfirm --needed pulseaudio-equalizer-ladspa  # !!! Добавляет ardour ; 15-полосный эквалайзер для PulseAudio ; https://archlinux.org/packages/extra/any/pulseaudio-equalizer-ladspa/ ; https://github.com/pulseaudio-equalizer-ladspa/equalizer ; 2024-12-22 13:19 UTC ; Многополосный эквалайзер на основе LADSPA для улучшения звучания Pulseaudio. Этот эквалайзер явно мощнее (устаревшего?) опционального эквалайзера от Pulseaudio.
######### Аудиосервер JACK с низкой задержкой ###############
sudo pacman -S --noconfirm --needed jack2 lib32-jack2 jack2-dbus jack2-docs  # Аудиосервер JACK с низкой задержкой ; Аудиосервер JACK с низкой задержкой (32 бита) ; Аудиосервер JACK с малой задержкой (интеграция с dbus) ; Аудиосервер JACK с малой задержкой (документация)
# sudo pacman -S --noconfirm --needed jack2  # Аудиосервер JACK с низкой задержкой ; https://archlinux.org/packages/extra/x86_64/jack2/ ; https://github.com/jackaudio/jack2 ; Обеспечивает: jack, libjack.so=0-64, libjacknet.so=0-64, libjackserver.so=0-64 ; Конфликты: с jack ; Обратные конфликты: pipewire-jack ; 2023-02-14 18:34 UTC
# sudo pacman -S --noconfirm --needed lib32-jack2  # Аудиосервер JACK с низкой задержкой (32 бита) ; https://archlinux.org/packages/multilib/x86_64/lib32-jack2/ ; https://github.com/jackaudio/jack2 ; Обеспечивает: lib32-jack, libjack.so=0-32, libjacknet.so=0-32, libjackserver.so=0-32 ; Конфликты: с lib32-jack ; Обратные конфликты: с lib32-pipewire-jack ;
# sudo pacman -S --noconfirm --needed jack2-dbus  # Аудиосервер JACK с малой задержкой (интеграция с dbus) ; https://archlinux.org/packages/extra/x86_64/jack2-dbus/ ; https://github.com/jackaudio/jack2 ; 2023-02-14 18:34 UTC
# sudo pacman -S --noconfirm --needed jack2-docs  # Аудиосервер JACK с малой задержкой (документация) ; https://archlinux.org/packages/extra/x86_64/jack2-docs/ ; https://github.com/jackaudio/jack2 ; 2023-02-14 18:34 UTC
######### Поддержка разъема для PulseAudio ###############
# sudo pacman -S --noconfirm --needed pulseaudio-jack  # Поддержка разъема для PulseAudio ; https://archlinux.org/packages/extra/x86_64/pulseaudio-jack/ ; https://www.freedesktop.org/wiki/Software/PulseAudio/ ; 2024-12-07 17:14 UTC
# sudo pacman -S --noconfirm --needed pulseaudio-lirc  # Поддержка IR (lirc) для PulseAudio ; https://archlinux.org/packages/extra/x86_64/pulseaudio-lirc/ ; https://www.freedesktop.org/wiki/Software/PulseAudio/ ; https://archlinux.org/packages/extra/x86_64/pulseaudio-lirc/
# sudo pacman -S --noconfirm --needed pulseaudio-rtp  # Поддержка RTP и RAOP для PulseAudio ; https://archlinux.org/packages/extra/x86_64/pulseaudio-rtp/ ; https://www.freedesktop.org/wiki/Software/PulseAudio/ ; 2024-12-07 17:14 UTC
sudo pacman -S --noconfirm --needed pulseaudio-zeroconf  # Поддержка Zeroconf для PulseAudio ; https://archlinux.org/packages/extra/x86_64/pulseaudio-zeroconf/ ; https://www.freedesktop.org/wiki/Software/PulseAudio/ ; 2024-12-07 17:14 UTC
### Внимание! Пакет realtime-privileges - лучше не устанавливать, он может вызвать небольшие задержки всей системы из-за усиленного воздействия на CPU, но без него звук хуже.
### !sudo pacman -S --noconfirm --needed realtime-privileges #
########### Музыкальный визуализатор ##############
sudo pacman -S --noconfirm --needed projectm-pulseaudio  # Музыкальный визуализатор, использующий ускоренный итеративный 3D-рендеринг изображений (pulseaudio) ; https://archlinux.org/packages/extra/x86_64/projectm-pulseaudio/ ; https://github.com/projectM-visualizer/projectm ; 2024-07-13 17:10 UTC
########### Микшер командной строки Pulseaudio ###########
sudo pacman -S --noconfirm --needed pamixer  # микшер командной строки Pulseaudio, как amixer ; pamixer похож на amixer, но для pulseaudio. Он может управлять уровнями громкости приемников ; Также этот проект может предоставить вам небольшую библиотеку C++ для управления PulseAudio ; https://github.com/cdemoulins/pamixer ; https://archlinux.org/packages/extra/x86_64/pamixer/
############ Справка Pamixer ############
# Использование:
#  pamixer [ВАРИАНТ...]
#  -h, --help справочное сообщение
#  -v, --version вывести информацию о версии
#      --sink arg выбрать приемник, отличный от используемого по умолчанию
#      --source arg выбрать источник, отличный от источника по умолчанию
#      --default-source выбрать источник по умолчанию
#      --get-volume получить текущий уровень громкости
#     --get-volume-human получить текущий процент громкости или строку
#                          "приглушенный"
#      --set-volume arg установить громкость
#  -i, --increase arg увеличить громкость
#  -d, --decrease arg уменьшить громкость
#  -t, --toggle-mute переключать режимы отключения и включения звука
#  -m, --mute установить беззвучный режим
#      --allow-boost разрешить громкость выше 100%
#      --set-limit arg установить ограничение на громкость
#      --gamma arg увеличить/уменьшить с помощью гамма-коррекции, например 2.2
#                          (по умолчанию: 1.0)
#  -u, --unmute отключить звук
#      --get-mute вывести true, если звук отключен, false
#                          в противном случае
#      --list-sinks вывести список приемников
#      --list-sources вывести список источников
#      --get-default-sink вывести приемник по умолчанию
############ Справка по Pulseaudio ############
# pulseaudio --check  # Проверьте, запущен ли какой-либо экземпляр pulseaudio ; Обычно он не выводит никаких выходных данных, только код выхода. 0 - Это означает, что процесс запущен.
# pulseaudio -k  # Если какой-либо экземпляр запущен, завершите его
# pulseaudio -D  # Наконец, запустите pulseaudio снова как демон
# sudo systemctl --user start pulseaudio
# sudo systemctl --user enable pulseaudio
###############
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_sound == 2 ]]; then
echo ""
echo " Установка пакетов поддержки Sound support PipeWire (pipewire-alsa, pipewire-jack...) "
echo -e " Установка PipeWire — это новый низкоуровневый мультимедийный фреймворк "
#######################
### ошибка: обнаружен неразрешимый конфликт пакетов
### ошибка: не удалось подготовить транзакцию (конфликтующие зависимости)
### :: pipewire-alsa-1:1.2.1-1 and pulseaudio-alsa-1:1.2.12-2 are in conflict
############ PipeWire ###########
sudo pacman -S --noconfirm --needed pipewire  # Аудио/видео маршрутизатор и процессор с малой задержкой ; https://pipewire.org/ ; https://archlinux.org/packages/extra/x86_64/pipewire/ ; 24 августа 2024 г., 13:15 UTC
sudo pacman -S --noconfirm --needed lib32-pipewire  # Аудио/видео маршрутизатор и процессор с малой задержкой - 32 бита ; https://pipewire.org/ ; https://archlinux.org/packages/multilib/x86_64/lib32-pipewire/ ; 24 августа 2024 г., 13:15 UTC
echo -e " Установка PipeWire-Docs — для просмотра документации "
sudo pacman -S --noconfirm --needed pipewire-docs  # Аудио/видео маршрутизатор и процессор с малой задержкой - документация ; https://pipewire.org/ ; https://archlinux.org/packages/extra/x86_64/pipewire-docs/ ; 24 августа 2024 г., 13:15 UTC
echo -e " Установка Поддержки аудио для PipeWire "
############# Клиенты ALSA #########
sudo pacman -S --noconfirm --needed pipewire-alsa  # Аудио/видео маршрутизатор и процессор с малой задержкой — конфигурация ALSA ; https://pipewire.org/ ; https://archlinux.org/packages/extra/x86_64/pipewire-alsa/ ; 24 августа 2024 г., 13:15 UTC
# Установите pipewire-pulse . Он заменит pulseaudio и pulseaudio-bluetooth . Перезагрузите, повторно войдите в систему или остановите pulseaudio.service и запустите пользовательский pipewire-pulse.service модуль , чтобы увидеть эффект.
# !!! info ‘Забавный факт’ Если у нас установлен pipewire-alsa – bluetooth должен запускаться автомататически. C pulseaudio это было не так, там звук через bluetooth добавлялся модулем из отдельного пакета.
############# Клиенты PulseAudio #########
sudo pacman -S --noconfirm --needed pipewire-pulse  # Аудио/видео маршрутизатор и процессор с малой задержкой — замена PulseAudio ; https://pipewire.org/ ; https://archlinux.org/packages/extra/x86_64/pipewire-pulse/ ; 24 августа 2024 г., 13:15 UTC ; Конфликты: с pulseaudio ; Смотрите Зависимости !
############ Клиенты Bluetooth-устройства #########
sudo pacman -S --noconfirm --needed pipewire-audio  # Аудио/видео маршрутизатор и процессор с малой задержкой - Поддержка аудио ; https://pipewire.org/ ; https://archlinux.org/packages/extra/x86_64/pipewire-audio/ ; 24 августа 2024 г., 13:15 UTC
# Этот пакет заменит установленные pulseaudio и pulseaudio-bluetooth. Необходимо перезагрузиться или запустить пользовательский юнит pipewire-pulse.service для работы.
# pactl info  # Для проверки работоспособности
echo -e " Установка PipeWire-JACK — это замена JACK "
########## клиенты ДЖЕК ############
sudo pacman -S --noconfirm --needed pipewire-jack  # Аудио/видео маршрутизатор и процессор с малой задержкой - замена JACK ; https://pipewire.org/ ; https://archlinux.org/packages/extra/x86_64/pipewire-jack/ ; 24 августа 2024 г., 13:15 UTC ; Конфликты: с jack, jack2, pipewire-jack-client ; Смотрите Зависимости !
#sudo pacman -S --noconfirm --needed lib32-pipewire-jack  # Аудио/видео маршрутизатор и процессор с малой задержкой - 32 бит - поддержка JACK ; https://pipewire.org/ ; https://archlinux.org/packages/multilib/x86_64/lib32-pipewire-jack/ ; 24 августа 2024 г., 13:15 UTC ; Конфликты: с ib32-jack, lib32-jack2 ; Смотрите Зависимости !
######## PipeWire-JACK-Client ###########
# sudo pacman -S --noconfirm --needed pipewire-jack-client  # Аудио/видео маршрутизатор и процессор с малой задержкой - PipeWire как клиент JACK ; https://pipewire.org/ ; https://archlinux.org/packages/extra/x86_64/pipewire-jack-client/ ; 24 августа 2024 г., 13:15 UTC ; Конфликты: с pipewire-jack ; Смотрите Зависимости !
# Его можно загрузить вручную как модуль PulseAudio: pactl load-module module-jackdbus-detect перед запуском jack.
echo -e " Установка WirePlumber — рекомендуемый менеджер сеансов "
######### WirePlumber — рекомендуемый менеджер сеансов ##########
sudo pacman -S --noconfirm --needed wireplumber  # Реализация менеджера сеансов/политик для PipeWire ; https://pipewire.pages.freedesktop.org/wireplumber/ ; https://archlinux.org/packages/extra/x86_64/wireplumber/ ; 29 июня 2024 г., 10:28 UTC ; Конфликты: с pipewire-media-session ; Смотрите Зависимости !
########### PipeWire Media Session устарел и больше не рекомендуется! ###########
### sudo pacman -S --noconfirm --needed pipewire-media-session  # PipeWire Media Session устарел и больше не рекомендуется! Устаревший менеджер сеансов для PipeWire (устарел) ; https://gitlab.freedesktop.org/pipewire/media-session ; https://archlinux.org/packages/extra/x86_64/pipewire-media-session/ ; 13 июля 2024 г., 16:18 UTC ; Конфликты: с wireplumber ; Смотрите Зависимости !
echo -e " Установка Helvum — коммутационная панель (графический интерфейс) GUI на базе GTK для PipeWire "
######### Helvum — коммутационная панель на базе GTK для PipeWire
sudo pacman -S --noconfirm --needed helvum  # Коммутационная панель GTK для PipeWire ; https://gitlab.freedesktop.org/pipewire/helvum ; https://archlinux.org/packages/extra/x86_64/helvum/ ; 30 сентября 2023 г., 15:27 UTC
######## Qpwgraph — коммутационная панель на базе Qt PipeWire Graph ###########
#sudo pacman -S --noconfirm --needed qpwgraph  # Графический интерфейс Qt PipeWire Graph ; https://gitlab.freedesktop.org/rncbc/qpwgraph ; https://archlinux.org/packages/extra/x86_64/qpwgraph/ ; 21 августа 2024 г., 19:47 UTC
######## Pwvucontrol - Регулятор громкости Pipewire
#yay -S pwvucontrol --noconfirm  # Регулятор громкости Pipewire. Альтернатива pavucontrol ; Регулятор громкости Pipewire для GNOME ; https://github.com/saivert/pwvucontrol ; https://aur.archlinux.org/pwvucontrol.git (только для чтения, нажмите, чтобы скопировать) ; https://aur.archlinux.org/packages/pwvucontrol ; 2024-08-05 21:06 (UTC)
######### Pavucontrol - Регулятор громкости PulseAudio ##########
#sudo pacman -S --noconfirm --needed pavucontrol  # Регулятор громкости PulseAudio ; https://freedesktop.org/software/pulseaudio/pavucontrol/ ; https://archlinux.org/packages/extra/x86_64/pavucontrol/ ; 4 августа 2024 г., 5:28 UTC
######## PipeWire GStreamer ###########
sudo pacman -S --noconfirm --needed gst-plugin-pipewire  # Мультимедийная графическая структура - плагин pipewire ; https://pipewire.org/ ; https://archlinux.org/packages/extra/x86_64/gst-plugin-pipewire/ ; 24 августа 2024 г., 13:15 UTC
######### EasyEffects (ранее PulseEffects) ##########
sudo pacman -S --noconfirm --needed easyeffects  # Аудиоэффекты для приложений Pipewire ; Заменяет: pulseeffects ; https://github.com/wwmm/easyeffects ; https://archlinux.org/packages/extra/x86_64/easyeffects/ ; Aug. 18, 2024, 3:09 p.m. UTC
###### Подавление шума для голоса ############
sudo pacman -S --noconfirm --needed noise-suppression-for-voice  # Плагин для подавления шума в реальном времени для голоса ; https://github.com/werman/noise-suppression-for-voice ; https://archlinux.org/packages/extra/x86_64/noise-suppression-for-voice/ ; 19 мая 2024 г., 16:58 UTC
sudo pacman -S --noconfirm --needed alsa-utils  # Расширенная звуковая архитектура Linux - Утилиты ; https://www.alsa-project.org/ ; https://archlinux.org/packages/extra/x86_64/alsa-utils/ ; 14 июня 2024 г., 19:09 UTC
  echo ""
  echo " Запускаем (pipewire-pulse.service) "
systemctl --user start pipewire-pulse.service
#sudo systemctl start dbus
echo " Добавляем в автозагрузку (pipewire-pulse.service) "
sudo systemctl --user enable pipewire-pulse.service
echo " Для проверки работоспособности сего действия "
pactl info  # Для проверки работоспособности
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
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
#--------------------
# PipeWire - https://wiki.archlinux.org/title/PipeWire
# Если после перехода на PipeWire у вас возникли задержки звука и искажения, необходимо открыть файл
# vim /etc/pipewire/pipewire.conf
# и привести параметры:
# default.clock.quantum = 64
# default.clock.min-quantum = 32
# default.clock.max-quantum = 512
# к указанным выше значениям. Если не поможет, можно ещё уменьшить, при этом желательно указываться числа, кратные 8.
# Кстати, разработчики PipeWire починили корректную работу переключения профилей для Bluetooth. И добавили возможность выбора кодека при выборе профиля для Bluetooth-гарнитуры, что очень круто. Лично у меня переключение профиля не работало на PulseAudio уже очень давно, даже с установленными дополнительными сервисами, вроде oFono.
################################

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Blueman - диспетчер bluetooth устройств?"
#echo -e "${BLUE}:: ${NC}Установить Blueman - диспетчер bluetooth устройств?"
#echo 'Установить Blueman - диспетчер bluetooth устройств?'
# Install Blueman-bluetooth device Manager?
echo -e "${CYAN}:: ${BOLD}Blueman - это полнофункциональный менеджер Bluetooth, написанный на GTK. ${NC}"
echo -e "${YELLOW}=> ${NC}Обязательно включите демон Bluetooth и запустите Blueman с blueman-applet. Графическую панель настроек можно запустить с помощью blueman-manager.(😃)"
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
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами. (😃)"
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
  <<< Установка Мультимедиа утилит и кодеков в Archlinux >>> ${NC}"
# Installing Multimedia utilities, and codecs in Archlinux
echo ""
echo -e "${GREEN}==> ${NC}Установка мультимедиа кодеков - GStreamer (multimedia codecs), и утилит (😃)"
#echo -e "${BLUE}:: ${NC}Установка мультимедиа кодеков (multimedia codecs), и утилит"
#echo 'Установка Мультимедиа кодеков (multimedia codecs), и утилит'
# Installing Multimedia codecs and utilities
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (a52dec, faac, faad2, flac, jasper, lame, libid3tag, libdca, libdv, libmad, libmpeg2, libtheora, libvorbis, libxv, wavpack, x264, xvidcore, gst-plugins-base, gst-plugins-base-libs, gst-plugins-good, gst-plugins-bad, gst-plugins-ugly, libdvdcss, libdvdread, libdvdnav, dvd+rw-tools, dvdauthor, dvgrab, gst-libav, gpac)."
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
  sudo pacman -S --noconfirm --needed glibc  # Библиотека GNU C ; https://www.gnu.org/software/libc ; https://archlinux.org/packages/core/x86_64/glibc/
  sudo pacman -S --noconfirm --needed dvdauthor  # Инструменты для создания DVD
  sudo pacman -S --noconfirm --needed dvd+rw-tools  # Инструменты записи dvd
  sudo pacman -S --noconfirm --needed dvgrab  # Сохраняет аудио и видео данные из цифрового источника IEEE (FireWire)
  sudo pacman -S --noconfirm --needed faac  # Бесплатная программа Advanced Audio Coder
  sudo pacman -S --noconfirm --needed faad2  # Аудиодекодер ISO AAC
  sudo pacman -S --noconfirm --needed flac  # Бесплатный аудиокодек без потерь
  sudo pacman -S --noconfirm --needed gpac  # Мультимедийный фреймворк на основе стандарта MPEG-4 Systems (https://github.com/gpac/gpac)
  sudo pacman -S --noconfirm --needed jasper  # Программная реализация кодека, указанного в появляющемся стандарте JPEG-2000 Part-1
  echo ""
  echo " Устанавливаем Библиотеки для чтения DVD видеодисков "
############ Библиотека для чтения DVD видеодисков ##############
sudo pacman -S --noconfirm --needed libdvdcss  # Портативная библиотека абстракций для расшифровки DVD ; https://www.videolan.org/developers/libdvdcss.html ; https://archlinux.org/packages/extra/x86_64/libdvdcss/
sudo pacman -S --noconfirm --needed libdvdread  # Библиотека для чтения DVD видеодисков ; https://www.videolan.org/developers/libdvdnav.html ; https://archlinux.org/packages/extra/x86_64/libdvdread/
sudo pacman -S --noconfirm --needed libdv  # Кодек Quasar DV (libdv) - программный кодек для DV-видео
sudo pacman -S --noconfirm --needed lsdvd  # Консольное приложение, отображающее содержимое DVD ; https://sourceforge.net/projects/lsdvd/ ; https://archlinux.org/packages/extra/x86_64/lsdvd/
sudo pacman -S --noconfirm --needed libdvdnav  # Библиотека для плагина xine-dvdnav
###################
  sudo pacman -S --noconfirm --needed lame  # Высококачественный кодировщик MPEG Audio Layer III (MP3)
  sudo pacman -S --noconfirm --needed libid3tag  # Библиотека манипуляции тегами ID3
  sudo pacman -S --noconfirm --needed libdca  # Бесплатная библиотека для декодирования потоков DTS Coherent Acoustics
  sudo pacman -S --noconfirm --needed libmad  # Высококачественный аудиодекодер MPEG
  sudo pacman -S --noconfirm --needed libmpeg2  # Библиотека для декодирования видеопотоков MPEG-1 и MPEG-2
  sudo pacman -S --noconfirm --needed libtheora  # Открытый видеокодек, разработанный Xiph.org
  sudo pacman -S --noconfirm --needed libvorbis  # Эталонная реализация аудиоформата Ogg Vorbis
  sudo pacman -S --noconfirm --needed libxv  # Библиотека расширений видео X11
  sudo pacman -S --noconfirm --needed mac  # Кодек и декомпрессор APE
  sudo pacman -S --noconfirm --needed wavpack  # Формат сжатия звука с режимами сжатия без потерь, с потерями и гибридным сжатием
  sudo pacman -S --noconfirm --needed x264  # Кодировщик видео H264 / AVC с открытым исходным кодом
  sudo pacman -S --noconfirm --needed xvidcore  # XviD - видеокодек MPEG-4 с открытым исходным кодом
  sudo pacman -S --noconfirm --needed openjpeg2  # Кодек JPEG 2000 с открытым исходным кодом, версия 2.4.0 ; https://github.com/uclouvain/openjpeg ; https://archlinux.org/packages/extra/x86_64/openjpeg2/
  sudo pacman -S --noconfirm --needed libmp4v2  # Библиотека AC/C++ для создания, изменения и чтения файлов MP4 ; https://mp4v2.org/ ; https://archlinux.org/packages/extra/x86_64/libmp4v2/
  sudo pacman -S --noconfirm --needed ffmpeg  # Комплексное решение для записи, конвертации и потоковой передачи аудио и видео ; https://ffmpeg.org/ ; https://archlinux.org/packages/extra/x86_64/ffmpeg/ ; 19 августа 2024 г., 21:29 UTC
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
  sudo pacman -S --noconfirm --needed ffmpegthumbnailer  # Легкий эскиз видеофайлов, который может использоваться файловыми менеджерами # возможно присутствует https://archlinux.org/packages/extra/x86_64/ffmpegthumbnailer/
  echo ""
  echo " Устанавливаем кодек для оптимизации и сжатия файлов JPEG/JFIF; JPG и PNG "
  sudo pacman -S --noconfirm --needed libjpeg-turbo  # Кодек изображений JPEG с ускоренным базовым сжатием и декомпрессией ; https://libjpeg-turbo.org/ ; https://archlinux.org/packages/extra/x86_64/libjpeg-turbo/ ; 22 мая 2024 г., 10:18 UTC
  sudo pacman -S --noconfirm --needed jpegoptim  # Утилита оптимизации JPEG ; https://github.com/tjko/jpegoptim ; https://archlinux.org/packages/extra/x86_64/jpegoptim/ ; 3 июля 2024 г., 19:49 UTC
  # jpegoptim — это утилита командной строки для оптимизации и сжатия файлов JPEG/JFIF и JPG. Эта утилита поддерживает оптимизацию без потерь, которая основана на оптимизации таблиц Хаффмана. jpegoptim gfg.jpeg ; ls -l gfg.jpg ; jpegoptim -n gfg.jpg ; jpegoptim --size=200k gfg.jpg ; jpegoptim *.jpg ; jpegoptim gfg_1.jpg gfg_2.jpg gfg_3.jpg ; https://www.geeksforgeeks.org/optimize-and-compress-jpeg-or-png-images-in-linux-command-line/
  sudo pacman -S --noconfirm --needed optipng  # Сжимает PNG-файлы до меньшего размера без потери информации ; http://optipng.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/optipng/ ;  7 января 2024 г., 10:23 UTC
# OptiPNG — это инструмент командной строки, который сжимает файлы портативной сетевой графики (PNG) без потери семантической информации. Синтаксис использования OptiPng очень прост: нам нужно просто указать имя png-файла после команды optipng: optipng gfg.png ; ls -l gfg.png ; optipng gfg.png ; optipng *.png ; https://www.geeksforgeeks.org/optimize-and-compress-jpeg-or-png-images-in-linux-command-line/
  sudo pacman -S --noconfirm --needed  mjpegtools  # Видеозахват, редактирование, воспроизведение и сжатие видео в формат MPEG или MJPEG ; https://mjpeg.sourceforge.io/ ; https://archlinux.org/packages/extra/x86_64/mjpegtools/ ; 2 июня 2023 г., 18:02 UTC
  # Программы mjpeg представляют собой набор инструментов, которые позволяют записывать и воспроизводить видео, выполнять простое редактирование методом вырезания и вставки, а также сжатие аудио и видео в формате MPEG в Linux. Основной целью разработки инструментов является взаимодействие с другими видеоинструментами: инструменты можно использовать для редактирования, воспроизведения и сжатия движущихся JPEG (MJPEG) AVI-файлов, захваченных с помощью пакета xawtv .
  echo ""
  echo " Установка мультимедиа кодеков и утилит (пакетов) выполнена "
fi
#############

clear
echo -e "${MAGENTA}
  <<< Установка Архиваторов (консольных), дополнений для архиваторов, менеджеров архивов (графический интерфейс) >>> ${NC}"
# Install Archivers (console), add-ons to archivers, archive managers (graphical interface)
echo ""
echo -e "${GREEN}==> ${NC}Ставим Архиваторы (консольные) - компрессионные инструменты (😃)"
#echo -e "${BLUE}:: ${NC}Ставим Архиваторы (консольные) - компрессионные инструменты"
#echo 'Ставим Архиваторы - "Компрессионные Инструменты" и дополнения'
# Installing Archivers-Compression Tools and add-ons
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: (zip, unzip, unrar, unarchiver, p7zip, zlib, zziplib, lzop)."
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
sudo pacman -S --noconfirm --needed pigz  # Параллельная реализация компрессора файлов gzip
sudo pacman -S --noconfirm --needed lzlib  # Библиотека, предоставляющая функции сжатия и распаковки LZMA в памяти
sudo pacman -S --noconfirm --needed unarj # Утилита для извлечения, тестирования и просмотра содержимого архивов, созданных с помощью архиватора ARJ
sudo pacman -S --noconfirm --needed upx  # Расширяемый, высокопроизводительный упаковщик исполняемых файлов для нескольких форматов исполняемых файлов
echo ""
echo " Установка дополнительных утилит (пакетов) из AUR "
####### Установка из AUR ############
########## pxz-git ###########
yay -S pxz-git --noconfirm  # Утилита сжатия LZMA различных частей входного файла на нескольких ядрах и процессорах одновременно ; https://aur.archlinux.org/packages/pxz-git ; https://aur.archlinux.org/pxz-git.git (только для чтения, нажмите, чтобы скопировать) ; http://jnovy.fedorapeople.org/pxz/ ; Конфликты: с pxz ; git+https://github.com/jnovy/pxz.git ; 2021-01-03 10:25 (UTC)
########### pxz-git ############
#git clone https://aur.archlinux.org/pxz-git.git  # (только для чтения, нажмите, чтобы скопировать)
#cd pxz-git
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf pxz-git
#rm -Rf pxz-git
########## plzip #############
########## Импортируйте ключ ###########
curl 'https://aur.archlinux.org/cgit/aur.git/plain/keys/pgp/1D41C14B272A2219A739FA4F8FE99503132D7742.asc?h=plzip' | gpg --import
yay -S plzip --noconfirm  # Массово-параллельный компрессор данных без потерь на основе библиотеки сжатия lzlib ; https://aur.archlinux.org/packages/plzip ; https://aur.archlinux.org/plzip.git (только для чтения, нажмите, чтобы скопировать) ; https://www.nongnu.org/lzip/plzip.html ; https://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.12.tar.gz ; https://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.12.tar.gz.sig ; 2025-01-17 02:17 (UTC)
########## plzip #############
#git clone https://aur.archlinux.org/plzip.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plzip
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plzip
#rm -Rf plzip
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
echo -e "${MAGENTA}:: ${NC}Выберите графический интерфейс для установленных (пакетов) архиваторов - (консольных), если установлены соответствующие. (😃)"
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo " 1 - File Roller - Легковесный менеджер архивов для среды рабочего стола GNOME, можно использовать и для другого DE (XFCE, LXDE, Lxqt...) "
echo " File Roller поддерживает множество типов архивов, включая gzip (tar.gz, tar.xz, tgz), bzip (tar.bz, tbz), bzip2 (tar.bz2, tbz2), Z (tar.Z, taz), lzop ( tar.lzo, tzo), zip, jar (jar, ear, war), lha, lzh, rar, ace, 7z, alz, ar и arj. "
echo " Кроме того, он поддерживает типы архивов cab, cpio, deb, iso, cbr, rpm, bin, sit, tar.7z, cbz и zoo, а также отдельные файлы, сжатые с помощью xz, gzip, bzip, bzip2. , lzop, lzip, z или rzip алгоритмы сжатия. "
echo " 2 - Ark (в переводе Ковчег) - Менеджер архивов для среды рабочего стола KDE(Plasma), можно использовать и для другого DE "
echo " Ark поддерживает работу со всеми основными форматами архивов: - (tar, gzip, bzip, bzip2, zip, xpi, lha, zoo, ar, rar) и некоторые другие. Поддерживаются и двойные архивы (например, tar.gz, tzr.bz2 и прочие). "
echo " 3 - Xarchiver (GTK+2) - Легковесный настольный независимый менеджер архивов, созданный с помощью набора инструментов (GTK+2), можно использовать с любой средой рабочего стола "
echo " Xarchiver поддерживает работу со всеми основными форматами архивов: - (7-zip, arj, bzip2, gzip, rar, lha, lzma, lzop, deb, rpm, tar, zip) и некоторые другие. Поддерживаются и двойные архивы (например, zip, 7-zip, rar и прочие). "
echo " 4 - Engrampa - бесплатный, свободно распространяемый менеджер архивов, используемый в среде рабочего стола MATE. Engrampa поддерживает наиболее распространенные операции, такие как создание, изменение и извлечение файлов из архива. Вы также можете просматривать содержимое архива и открывать файлы, содержащиеся в нём. "
echo " Engrampa — это форк File Roller. Engrampa имеет следующие возможности: создание нового архива; просмотр содержимого существующего архива; просмотр файла, содержащегося в архиве; изменение существующих архивов; извлечение файлов из архива. Синтаксис: $ engrampa [ПАРАМЕТР…] - создать или изменить архив . "
echo " Engrampa поддерживает работу со всеми основными форматами архивов: - (7-zip, arj, bzip2, gzip, rar, lha, lzma, lzop, deb, rpm, tar, zip) и некоторые другие. Поддерживаются и двойные архивы (например, zip, 7-zip, rar и прочие). "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - File Roller,    2 - Ark,    3 - Xarchiver (GTK+2),    4 - Engrampa,

    0 - Пропустить установку: " gui_archiver  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$gui_archiver" =~ [^12340] ]]
do
    :
done
if [[ $gui_archiver == 0 ]]; then
echo ""
echo " Установка Менеджера архивов (графического интерфейса) пропущено "
elif [[ $gui_archiver == 1 ]]; then
echo ""
echo " Установка Менеджера архивов File Roller (file-roller) "
sudo pacman -S --noconfirm --needed file-roller  # легковесный архиватор ( для xfce-lxqt-lxde-gnome )
elif [[ $gui_archiver == 2 ]]; then
echo ""
echo " Установка Менеджера архивов Ark (ark) "
sudo pacman -S --noconfirm --needed ark  # архиватор для ( Plasma(kde)- так же можно использовать, и для другого de )
elif [[ $gui_archiver == 3 ]]; then
echo ""
echo " Установка Менеджера архивов Xarchiver (xarchiver-gtk2) "
# sudo pacman -S --noconfirm --needed xarchiver  # Интерфейс GTK+ для различных архиваторов командной строки
sudo pacman -S --noconfirm --needed xarchiver-gtk2  # легкий настольный независимый менеджер архивов
elif [[ $gui_archiver == 4 ]]; then
echo ""
echo " Установка Менеджера архивов Engrampa (engrampa) "
sudo pacman -S --noconfirm --needed engrampa  # Архиватор файлов для MATE ; https://mate-desktop.org/ ; https://archlinux.org/packages/extra/x86_64/engrampa/ ; https://github.com/mate-desktop/engrampa ; Заменяет: engrampa-gtk3 ; Конфликты: с engrampa-gtk3 ; 2024-09-11 08:04 UTC
fi
########################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить PeaZip - пакет (peazip) - Архиватор (менеджер архивов)?"
echo -e "${MAGENTA}:: ${BOLD}PeaZip — это бесплатная утилита для архивации файлов и извлечения rar-файлов для BSD, Linux, macOS и Windows, которая работает более чем с 200 типами и вариантами архивов (7z, ace, arc, bz2, cab, gz, iso, paq, pea, rar, tar, wim, zip, zipx...), обрабатывает составные архивы (001, r01, z01...), поддерживает несколько стандартов шифрования архивов, хеширование файлов, экспортирует задачи в виде консольных скриптов. PeaZip предлагает альтернативу LGPLv3 фирменному программному обеспечению (WinZip, WinRar и т. д.), PeaZip имеет простой графический интерфейс и предназначена для работы с архивами. В программу встроен файловый менеджер с возможностью просмотра содержимого архивов. В верхней части окна программы расположено главное меню и панель управления. Остальная часть выполнена в виде файлового менеджера. PeaZip распространяется свободно, имеет открытый исходный код. ${NC}"
echo " Домашняя страница: https://github.com/peazip/PeaZip/ ; (https://aur.archlinux.org/packages/peazip ; https://aur.archlinux.org/packages/peazip-gtk2-bin ; https://aur.archlinux.org/packages/peazip-qt-bin). "
echo -e "${MAGENTA}:: ${BOLD}Основные возможности и особенности программы: Простой и удобный интерфейс в стиле файлового менеджера.
Поддержка более 180 форматов файлов (см. списки ниже). Поиск файлов. Поиск дубликатов файлов. Создание закладок. Просмотр эскизов. Вычисление контрольных сумм. Добавление и редактирование файлов внутри архивов. Конвертирование файлов архивов. Встроенный менеджер паролей. ${NC}"
echo " Поддерживаемые форматы: (Информация с официального сайта программы) - Полная поддержка (просмотр/распаковка/создание): 7z, FreeArc’s arc/wrc, sfx (7z and arc), Brotli br, bz2, gz, paq/lpaq/zpaq, pea, quad/balz/bcm, split, tar, upx, wim, zip, Zstandard zst. "
echo " Чтение (просмотр/распаковка/test): tbz, Facebook’s Zstandard zst and tzst, gz, gzip, tgz, tpz, tar, zip, zipx, z01, smzip, arj, cab, chm, chi, chq, chw, hxs, hxi, hxr, hxq, hxw, lit, cpio, deb, lzh, lha, rar (and most recent rar 5 revision), r01, 00, rpm, z, taz, tz, iso, Java (jar, ear, war), pet, pup, pak, pk3, pk4, slp, [Content], xpi, wim, u3p, lzma86, lzma, udf, xar, Apple’s dmg, hfs, part1, split, swm, tpz, kmz, xz, txz, vhd, mslz, apm, mbr, fat, ntfs, exe, dll, sys, msi, msp, Open Office / Libre Office (ods, ots, odm, oth, oxt, odb, odf, odg, otg, odp, otp, odt, ott), gnm, Microsoft Office (doc, dot, xls, xlt, ppt, pps, pot, docx, dotx, xlsx, xltx), Flash (swf, flv), quad, balz, bcm, zpaq, paq8f, paq8jd, paq8l, paq8o, lpaq1, lpaq5, lpaq8, ace через плагин unace (закрытый исходный код), arc, wrc, 001, pea, cbz, cbr, cba, cb7, cbt и другие. "
echo " Поддерживаемые форматы с шифрованием: 7Z, ZIP, ARC, PEA . Поддержка восстановления архивов: FreeArc (arc/wrc) . "
echo " Исходный код: Open Source (открыт) ; Языки программирования: Pascal ; Библиотеки: GTK, Qt ; Лицензия: LGPLv3 ; Приложение переведено на русский язык. Безопасность на первом месте: надежное шифрование, двухфакторная аутентификация, зашифрованный менеджер паролей и безопасное удаление. Мощное сжатие: использует технологии с открытым исходным кодом из проектов 7-Zip/p7zip, FreeArc, PAQ/ZPAQ, PEA, UPX, Brotli и Zstd. "
echo -e "${CYAN}:: ${NC}Установка PeaZip пакетов (peazip), (peazip-gtk2-bin) (peazip-qt-bin) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo -e "${YELLOW}==> ${NC}Будьте внимательны! Если Вы сомневаетесь в своих действиях, просто пропустите этот пункт."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить PeaZip (peazip),          2 - *Установить PeaZip (peazip-gtk2-bin),

    3 - *Установить PeaZip (peazip-qt-bin),   0 - Нет пропустить установку: " i_peazip  # sends right after the keypress; # отправляет сразу после нажатия клавиши
echo ''
   [[ "$i_peazip" =~ [^1230] ]]
do
    :
done
if [[ $i_peazip == 0 ]]; then
  echo ""
  echo " Установка пакетов пропущена "
elif [[ $i_peazip == 1 ]]; then
  echo ""
  echo " Установка PeaZip (peazip) "
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########### Зависимости #########
  sudo pacman -S --noconfirm --needed 7zip  # Архиватор файлов для сверхвысокой степени сжатия ; https://archlinux.org/packages/extra/x86_64/7zip/ ; https://www.7-zip.org/ ; Обеспечивает: p7zip ; Заменяет: p7zip ; Конфликты: с p7zip ; 2024-12-25 15:57 UTC
  sudo pacman -S --noconfirm --needed brotli  # Универсальный алгоритм сжатия без потерь ; https://archlinux.org/packages/core/x86_64/brotli/ ; https://github.com/google/brotli ; Обеспечивает: libbrotlicommon.so=1-64, libbrotlidec.so=1-64, libbrotlienc.so=1-64 ; 2024-12-22 12:38 UTC
  sudo pacman -S --noconfirm --needed hicolor-icon-theme  # Freedesktop.org Тема иконок Hicolor ; https://archlinux.org/packages/extra/any/hicolor-icon-theme/ ; https://gitlab.freedesktop.org/xdg/default-icon-theme ; 2024-05-24 01:53 UTC
  sudo pacman -S --noconfirm --needed qt6pas  # Бесплатная библиотека привязки Pascal Qt6 обновлена Lazarus IDE ; https://archlinux.org/packages/extra/x86_64/qt6pas/ ; https://gitlab.com/freepascal.org/lazarus/lazarus/-/tree/main/lcl/interfaces/qt6/cbindings ; 2025-04-23 13:43 UTC
  sudo pacman -S --noconfirm --needed zstd  # Zstandard — быстрый алгоритм сжатия в реальном времени ; https://archlinux.org/packages/core/x86_64/zstd/ ; https://facebook.github.io/zstd/ ; Обеспечивает: libzstd.so=1-64 ; 2025-02-23 20:59 UTC
  sudo pacman -S --noconfirm --needed lazarus  # Delphi-подобная IDE для общих файлов FreePascal ; https://archlinux.org/packages/extra/x86_64/lazarus/ ; http://www.lazarus.freepascal.org/ ; 2025-06-14 13:47 UTC
  sudo pacman -S --noconfirm --needed xmlstarlet  # Набор инструментов для преобразования, запроса, проверки и редактирования XML-документов ; https://archlinux.org/packages/extra/x86_64/xmlstarlet/ ; http://xmlstar.sourceforge.net/ ; 2025-04-30 17:37 UTC
########## peazip ###########
yay -S peazip --noconfirm  # Кроссплатформенный файловый и архивный менеджер (Qt6) ; https://aur.archlinux.org/packages/peazip ; https://aur.archlinux.org/peazip.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/peazip/PeaZip ; https://github.com/peazip/PeaZip/archive/e5d94ad716ead526364512efb7b9e9e2de9a68a7.tar.gz ; 2025-06-15 20:49 (UTC)
########## peazip ###########
#git clone https://aur.archlinux.org/peazip.git  # (только для чтения, нажмите, чтобы скопировать)
#cd peazip
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf peazip
#rm -Rf peazip
  echo ""
  echo " Установка программ (пакетов) выполнена "
elif [[ $i_peazip == 2 ]]; then
  echo ""
  echo " Установка PeaZip (peazip-gtk2-bin) "
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########### Зависимости #########
  sudo pacman -S --noconfirm --needed 7zip  # Архиватор файлов для сверхвысокой степени сжатия ; https://archlinux.org/packages/extra/x86_64/7zip/ ; https://www.7-zip.org/ ; Обеспечивает: p7zip ; Заменяет: p7zip ; Конфликты: с p7zip ; 2024-12-25 15:57 UTC
  sudo pacman -S --noconfirm --needed brotli  # Универсальный алгоритм сжатия без потерь ; https://archlinux.org/packages/core/x86_64/brotli/ ; https://github.com/google/brotli ; Обеспечивает: libbrotlicommon.so=1-64, libbrotlidec.so=1-64, libbrotlienc.so=1-64 ; 2024-12-22 12:38 UTC
  sudo pacman -S --noconfirm --needed gtk2  # Мультиплатформенный набор инструментов GUI на основе GObject (устаревший) ; https://archlinux.org/packages/extra/x86_64/gtk2/ ; https://www.gtk.org/ ; Обеспечивает: libgailutil.so=18-64, libgdk-x11-2.0.so=0-64, libgtk-x11-2.0.so=0-64 ; 2024-09-09 21:32 UTC
  sudo pacman -S --noconfirm --needed zstd  # Zstandard — быстрый алгоритм сжатия в реальном времени ; https://archlinux.org/packages/core/x86_64/zstd/ ; https://facebook.github.io/zstd/ ; Обеспечивает: libzstd.so=1-64 ; 2025-02-23 20:59 UTC
  sudo pacman -S --noconfirm --needed patchelf  # Небольшая утилита для изменения динамического компоновщика и RPATH исполняемых файлов ELF ; https://archlinux.org/packages/extra/x86_64/patchelf/ ; https://nixos.org/patchelf.html ; 2024-05-01 15:38 UTC
  ######### arc ##########
  yay -S arc --noconfirm  # Архиватор и компрессор файлов Arc. Давно заменен zip/unzip, но полезен, если есть старые файлы .arc, которые нужно распаковать ; https://aur.archlinux.org/packages/arc ; https://aur.archlinux.org/arc.git (только для чтения, нажмите, чтобы скопировать) ; http://sourceforge.net/projects/arc ; https://github.com/ani6al/arc/archive/refs/tags/5.21q.tar.gz ; 2022-09-11 04:43 (UTC)
######### arc ##########
#git clone https://aur.archlinux.org/arc.git  # (только для чтения, нажмите, чтобы скопировать)
#cd arc
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf arc
#rm -Rf arc
############## peazip-gtk2-bin ###########
yay -S peazip-gtk2-bin --noconfirm  # Кроссплатформенный файловый и архивный менеджер (GTK2) ; https://aur.archlinux.org/packages/peazip-gtk2-bin ; https://aur.archlinux.org/peazip-gtk2-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://cyfuture.dl.sourceforge.net/project/peazip/Resources/PeaZip%20Additional%20Formats%20Plugin/peazip-additional-formats-plugin.6.LINUX.tar ; https://github.com/peazip/PeaZip/releases/download/10.5.0/peazip-10.5.0.LINUX.GTK2-1.x86_64.rpm ; Конфликты: с peazip, peazip-gtk2-bin-debug ; 2025-06-15 20:45 (UTC)
############## peazip-gtk2-bin ###########
#git clone https://aur.archlinux.org/peazip-gtk2-bin.git  # (только для чтения, нажмите, чтобы скопировать)
#cd peazip-gtk2-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf peazip-gtk2-bin
#rm -Rf peazip-gtk2-bin
  echo ""
  echo " Установка программ (пакетов) выполнена "
elif [[ $i_peazip == 3 ]]; then
  echo ""
  echo " Установка PeaZip (peazip-qt-bin) "
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########### Зависимости #########
  sudo pacman -S --noconfirm --needed 7zip  # Архиватор файлов для сверхвысокой степени сжатия ; https://archlinux.org/packages/extra/x86_64/7zip/ ; https://www.7-zip.org/ ; Обеспечивает: p7zip ; Заменяет: p7zip ; Конфликты: с p7zip ; 2024-12-25 15:57 UTC
  sudo pacman -S --noconfirm --needed brotli  # Универсальный алгоритм сжатия без потерь ; https://archlinux.org/packages/core/x86_64/brotli/ ; https://github.com/google/brotli ; Обеспечивает: libbrotlicommon.so=1-64, libbrotlidec.so=1-64, libbrotlienc.so=1-64 ; 2024-12-22 12:38 UTC
  sudo pacman -S --noconfirm --needed hicolor-icon-theme  # Freedesktop.org Тема иконок Hicolor ; https://archlinux.org/packages/extra/any/hicolor-icon-theme/ ; https://gitlab.freedesktop.org/xdg/default-icon-theme ; 2024-05-24 01:53 UTC
  sudo pacman -S --noconfirm --needed libx11  # Клиентская библиотека X11 ; https://archlinux.org/packages/extra/x86_64/libx11/ ; https://gitlab.freedesktop.org/xorg/lib/libx11 ; 2025-03-10 13:48 UTC
  sudo pacman -S --noconfirm --needed qt6pas  # Бесплатная библиотека привязки Pascal Qt6 обновлена Lazarus IDE ; https://archlinux.org/packages/extra/x86_64/qt6pas/ ; https://gitlab.com/freepascal.org/lazarus/lazarus/-/tree/main/lcl/interfaces/qt6/cbindings ; 2025-04-23 13:43 UTC
  sudo pacman -S --noconfirm --needed upx  # Расширяемый, высокопроизводительный упаковщик исполняемых файлов для нескольких форматов исполняемых файлов ; https://archlinux.org/packages/extra/x86_64/upx/ ; https://github.com/upx/upx ; 2025-05-09 07:53 UTC
  sudo pacman -S --noconfirm --needed zstd  # Zstandard — быстрый алгоритм сжатия в реальном времени ; https://archlinux.org/packages/core/x86_64/zstd/ ; https://facebook.github.io/zstd/ ; Обеспечивает: libzstd.so=1-64 ; 2025-02-23 20:59 UTC
############## peazip-qt-bin ###########
yay -S peazip-qt-bin --noconfirm  # Файловый менеджер и архиватор PeaZip (бинарная версия) ; https://aur.archlinux.org/packages/peazip-qt-bin ; https://aur.archlinux.org/peazip-qt-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/peazip/PeaZip ; Конфликты: с peazip ; Обеспечивает: peazip ; https://github.com/peazip/PeaZip/releases/download/10.5.0/peazip-10.5.0.LINUX.Qt6-1.x86_64.rpm ; 2025-06-19 11:28 (UTC)
############## peazip-qt-bin ###########
#git clone https://aur.archlinux.org/peazip-qt-bin.git  # (только для чтения, нажмите, чтобы скопировать)
#cd peazip-qt-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf peazip-qt-bin
#rm -Rf peazip-qt-bin
  echo ""
  echo " Установка программ (пакетов) выполнена "
fi
########## Справка и дополнения #############
# Бесплатная утилита-архиватор файлов PeaZip:
# https://peazip.github.io/
# Загрузите и установите плагин PeaZip:
# https://peazip.github.io/peazip-add-ons.html
# Загрузите и установите PeaZip Темы, предоставленные пользователями:
# https://peazip.github.io/peazip-themes.html
# Blue Green Sea Foam (Александр)
# https://sourceforge.net/projects/peazip/files/Resources/Themes/Themes%20v4/Blue-green_sea-foam.theme.7z/download
# Eleven (Ijmm) | Тема + Иконки (Ijmm)
# https://sourceforge.net/projects/peazip/files/Resources/Themes/Themes%20v3/Eleven.theme.7z/download
# https://sourceforge.net/projects/peazip/files/Resources/Themes/Themes%20v3/Eleven%20Theme%20by%20Ijmm.zip/download
# KDE Breeze (Андрейн)
# https://sourceforge.net/projects/peazip/files/Resources/Themes/Themes%20v3/KDE%20Breeze.theme.7z/download
# Oxygen (Андрейн)
# https://sourceforge.net/projects/peazip/files/Resources/Themes/Themes%20v3/Oxygen.theme.7z/download
# Репозитории тем:
# Репозиторий тем v6, работает с текущими версиями PeaZip (10.4+).
# Устаревшие темы
# Устаревшие репозитории тем.
# Текущие выпуски (PeaZip 10.4+) могут использовать темы v6, v5, v4 и v3.
# Themes v1 работает с PeaZip < 7.0, Themes v2 работает с PeaZip < 8.2, Themes v3 работает с PeaZip < 9.1, Themes v4 работает с PeaZip < 9.9.1, Themes v5 работает с PeaZip < 10.4.0.
# Настройте внешний вид приложения с помощью тем:
# PeaZip T hemes настраивает внешний вид, цвета и значки графического интерфейса менеджера архивов / файлового менеджера основной программы .
# Наряду с предустановленными темами, пользовательские (и созданные пользователем) темы могут быть применены из Option > Theme, выбрав "Custom" в раскрывающемся меню Theme и выбрав пакет пользовательской темы, например xyz.theme.7z.
# Внешний вид файлового менеджера / архивного менеджера и других аспектов приложения можно дополнительно настроить на странице Settings > Theme, изменив:
# акцентный цвет приложения и акцентный цвет текста с предустановками, применяющими акцентные цвета, обычно используемые в Windows, Mac, BeOS, Linux Mint и Ubuntu...
# фоновый цвет приложения, на котором определяются цвета кнопок, вкладок и других элементов, чтобы сделать приложение темнее или светлее, чем системные цвета по умолчанию, или применить оттенки, такие как графит, мокко, слива, сенапе или даже полностью пользовательские цвета
# изменить цветовую температуру для цвета фона приложения
# уменьшить или увеличить интервал между элементами, изменить цвета и вид вкладок, адресной строки браузера файлов и панели инструментов
# установить уровень прозрачности приложения
# масштабировать графический интерфейс приложения больше или меньше, чем системные настройки по умолчанию
# пользовательские темы для peazip
# PeaZip с темой Tux-dark в современном стиле (из меню стилей "...")
#############################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установим Hwdetect - пакет (hwdetect) - Информация о железе?"
echo " Hwdetect - это скрипт (консольная утилита с огромным количеством опций) обнаружения оборудования, который в основном используется для загрузки или вывода списка модулей ядра (для использования в mkinitcpio.conf), и заканчивая возможностью автоматического изменения rc.conf и mkinitcpio.conf ; (https://wiki.archlinux.org/title/Hwdetect) (😃)"
echo -e "${YELLOW}=> Примечание: ${BOLD}Это отличается от многих других инструментов, которые запрашивают только оборудование и показывают необработанную информацию, оставляя пользователю задачу связать эту информацию с необходимыми драйверами. ${NC}"
echo " Сценарий использует информацию, экспортируемую подсистемой sysfs (https://en.wikipedia.org/wiki/Sysfs), используемой ядром Linux. "
echo -e "${YELLOW}==> ${NC}Будьте внимательны! Если Вы сомневаетесь в своих действиях, просто пропустите этот пункт."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить пакет (hwdetect),    0 - Нет пропустить установку: " i_hwdetect  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
  sudo pacman -S --noconfirm --needed hwdetect  # Скрипт (консольная утилита) просмотр модулей ядра для устройств, обнаружения оборудования с загрузочными модулями и поддержкой mkinitcpio.conf / rc.conf
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
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (accountsservice, acpi, acpid, android-tools, android-udev, anything-sync-daemon, archinstall, arch-install-scripts, aspell-en, aspell-ru, autofs, b43-fwcutter, bash-completion, bc, beep, btrfs-progs, busybox, ccache, cpio, cpupower, desktop-file-utils, dmraid, dmidecode, efibootmgr, efitools, extra-cmake-modules, f2fs-tools, flex, foremost, fortune-mod, fsarchiver, fwupd, fuse3, glances, gperf, gpm, gptfdisk, gtop, gvfs, gvfs-gphoto2, gvfs-nfs, gvfs-smb, haveged, hddtemp, hdparm, hidapi, hwdetect, hwinfo, hyphen-en, id3lib, iftop, inxi, isomd5sum, jfsutils, kvantum, lib32-curl, lib32-flex, libfm-gtk2, libudev0-shim, libwireplumber, lksctp-tools, logrotate, lm_sensors, lsof, lsb-release, lvm2, man-db, man-pages, mc, memtest86+, mlocate, mtpfs, ncurses, ncdu, nfs-utils, nmon, pacman-contrib, patchutils, pciutils, php, picom_X11, polkit, poppler-data, powertop, pv, pwgen, python-isomd5sum, python-pip, qt5-translations, re2, reflector, ruby, s-nail, sane, screen, scrot, sg3_utils, sdparm, sof-firmware, solid, sox, smartmontools, speedtest-cli, squashfs-tools, strace, syslinux, systemd-ui, termite, termite-terminfo, translate-shell, udiskie, udisks2, unixodbc, usbutils, wimlib, wipe, xclip, xdg-utils, xfsprogs, xsel, xterm, xorg-twm, xorg-xkill, yelp, yt-dlp, screen, tmux, util-linux, httrack...)."
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты! (😃)"
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)
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
sudo pacman -S --noconfirm --needed ccache  # Кэш компилятора, который ускоряет перекомпиляцию за счет кеширования предыдущих компиляций
sudo pacman -S --noconfirm --needed compsize  # Рассчитать степень сжатия набора файлов на Btrfs ; Для выполнения проверки на эффективность необходимо использовать команду: sudo compsize /path  # (Где path - путь к разделу, папке или файлу)
### Пояснения:
# Первый столбец:
# Строка TOTAL - итоговые данные, которые учитывают все сжатые и не сжатые файлы и разные алгоритмы (если такие имеются).
# Строка none - данные, которые не были сжаты.
# Далее отображаются все использованные алгоритмы (в данном случае - zstd).
# Второй столбец показывает данные в процентах.
# Третий столбец отображает фактически использованное место на диске/разделе.
# Четвертый столбец показывает данные без сжатия.
# Пятый - видимый размер файла, тот, который зачастую отображается в системе.
#########################
sudo pacman -S --noconfirm --needed cpio  # Инструмент для копирования файлов в или из архива cpio или tar
sudo pacman -S --noconfirm --needed cpupower  # Инструмент ядра Linux для проверки и настройки функций вашего процессора, связанных с энергосбережением
sudo pacman -S --noconfirm --needed cryptsetup  # Инструмент настройки пользовательского пространства для прозрачного шифрования блочных устройств с использованием dm-crypt ; https://gitlab.com/cryptsetup/cryptsetup/ ; https://archlinux.org/packages/core/x86_64/cryptsetup/
sudo pacman -S --noconfirm --needed desktop-file-utils  # Утилиты командной строки для работы с записями рабочего стола
sudo pacman -S --noconfirm --needed dmraid  # Интерфейс RAID устройства сопоставления устройств
sudo pacman -S --noconfirm --needed dmidecode  # Утилиты, относящиеся к таблице интерфейса управления рабочим столом (https://www.nongnu.org/dmidecode)
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
sudo pacman -S --noconfirm --needed progpick  # Брутфорс с потоком перестановок определенного шаблона ; Bruteforce с потоком перестановок определенного шаблона. Также выводит полосу прогресса и вычисляет ETA. На случай, если вы часто забываете свой пароль LUKS ; https://github.com/kpcyrd/progpick ; https://archlinux.org/packages/extra/x86_64/progpick/
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
# sudo pacman -S --noconfirm --needed hwdetect # Скрипт (консольная утилита) просмотр модулей ядра для устройств, обнаружения оборудования с загрузочными модулями и поддержкой mkinitcpio.conf / rc.conf
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
sudo pacman -S --noconfirm --needed lua-stdlib  # Библиотека модулей для решения общих задач программирования ; https://github.com/lua-stdlib/lua-stdlib ; https://archlinux.org/packages/extra/any/lua-stdlib/ ; help lua-stdlib
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
sudo pacman -S --noconfirm --needed meson  # Высокопроизводительная система сборки ; https://mesonbuild.com/ ; https://archlinux.org/packages/extra/any/meson/ ; 27 июля 2024 г., 16:47 UTC
sudo pacman -S --noconfirm --needed meson-python  # Meson PEP 517 Python бэкэнд сборки ; https://github.com/mesonbuild/meson-python ; https://archlinux.org/packages/extra/any/meson-python/ ; 29 апреля 2024 г., 22:37 UTC
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
sudo pacman -S --noconfirm --needed pass  # Безопасное хранение, извлечение, генерация и синхронизация паролей ; https://www.passwordstore.org/ ; https://archlinux.org/packages/extra/any/pass/ ; консольный вариант PASS — простой bash-скрипт для любителей терминала. https://www.passwordstore.org/
sudo pacman -S --noconfirm --needed pciutils  # Библиотека и инструменты доступа к пространству конфигурации шины PCI
sudo pacman -S --noconfirm --needed php  # Язык сценариев общего назначения, особенно подходящий для веб-разработки
sudo pacman -S --noconfirm --needed picom  # Легкий композитор для X11 https://archlinux.org/packages/extra/x86_64/picom/
sudo pacman -S --noconfirm --needed polkit  # Набор инструментов для разработки приложений для управления общесистемными привилегиями
sudo pacman -S --noconfirm --needed poppler-data  # Кодирование данных для библиотеки рендеринга PDF Poppler
sudo pacman -S --noconfirm --needed powertop  # Инструмент для диагностики проблем с энергопотреблением и управлением питанием
sudo pacman -S --noconfirm --needed pv  # Инструмент на основе терминала для мониторинга прохождения данных по конвейеру
sudo pacman -S --noconfirm --needed jq  # Утилита для работы с JSON ; Процессор командной строки JSON ; https://jqlang.github.io/jq/ ; https://archlinux.org/packages/extra/x86_64/jq/
sudo pacman -S --noconfirm --needed httpie  # Удобный для пользователя CLI HTTP-клиент для эпохи API ; лучшая замена curl с подсветкой вывода ; https://github.com/httpie/cli ; https://archlinux.org/packages/extra/any/httpie/ ; это HTTP-клиент командной строки. Его цель — сделать взаимодействие CLI с веб-сервисами максимально удобным для человека. HTTPie предназначен для тестирования, отладки и общего взаимодействия с API и HTTP-серверами.
sudo pacman -S --noconfirm --needed curlie  # Мощь curl, простота использования httpie ; https://curlie.io/ ; https://archlinux.org/packages/extra/x86_64/curlie/
sudo pacman -S --noconfirm --needed pwgen  # Генератор паролей для создания легко запоминающихся паролей ; Справка по ключам работы: pwgen --help
sudo pacman -S --noconfirm --needed python  # Новое поколение языка сценариев высокого уровня Python  # присутствует
sudo pacman -S --noconfirm --needed python-isomd5sum  # Привязки Python3 для isomd5sum
sudo pacman -S --noconfirm --needed python-pip  # Рекомендуемый PyPA инструмент для установки пакетов Python
sudo pacman -S --noconfirm --needed qt5-translations  # кросс-платформенное приложение и UI-фреймворк (переводы)
sudo pacman -S --noconfirm --needed reflector  # Модуль и скрипт Python 3 для получения и фильтрации последнего списка зеркал Pacman
sudo pacman -S --noconfirm --needed re2   # Быстрый, безопасный, ориентированный на многопоточность механизм регулярных выражений
sudo pacman -S --noconfirm --needed rng-tools  # Утилиты, связанные с генератором случайных чисел ; https://github.com/nhorman/rng-tools ; Он отслеживает набор источников энтропии и поставляет энтропию из них в механизм /dev/random ядра системы.
sudo pacman -S --noconfirm --needed ruby  # Объектно-ориентированный язык для быстрого и простого программирования
sudo pacman -S --noconfirm --needed s-nail  # Среда для отправки и получения почты
#sudo pacman -S --noconfirm --needed sane  # Доступ к сканеру теперь простой
#sudo pacman -S --noconfirm --needed screen  # Полноэкранный оконный менеджер, который мультиплексирует физический терминал
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
sudo pacman -S --noconfirm --needed tuned  # Демон, осуществляющий мониторинг и адаптивную настройку устройств в системе ; https://archlinux.org/packages/extra/any/tuned/ ; https://github.com/redhat-performance/tuned ; 2025-02-04 08:08 UTC
sudo pacman -S --noconfirm --needed udiskie  # Автоматическое монтирование съемных дисков с использованием udisks
sudo pacman -S --noconfirm --needed udisks2  # Служба управления дисками, версия 2 (https://www.freedesktop.org/wiki/Software/udisks/)
sudo pacman -S --noconfirm --needed unixodbc  # ODBC - это открытая спецификация для предоставления разработчикам приложений предсказуемого API для доступа к источникам данных
sudo pacman -S --noconfirm --needed usbutils  # Набор USB-инструментов для запроса подключенных USB-устройств
sudo pacman -S --noconfirm --needed whois  # Интеллектуальный WHOIS-клиент ; https://github.com/rfc1036/whois ; https://archlinux.org/packages/extra/x86_64/whois/
sudo pacman -S --noconfirm --needed wimlib  # Библиотека и программа для извлечения, создания и изменения файлов WIM
sudo pacman -S --noconfirm --needed wipe  # Утилита для безопасной очистки файлов (http://wipe.sourceforge.net/)
sudo pacman -S --noconfirm --needed xclip  # Интерфейс командной строки для буфера обмена X11
sudo pacman -S --noconfirm --needed xdialog  # Удобная замена программам «dialog» или «cdialog» ; http://xdialog.dyns.net/ ; https://archlinux.org/packages/extra/x86_64/xdialog/ ; 19 мая 2023 г., 17:24 UTC ; Смотрите Зависимости !
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
sudo pacman -S --noconfirm --needed yajl  # Еще одна библиотека JSON ; https://github.com/lloyd/yajl ; https://archlinux.org/packages/extra/x86_64/yajl/
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
sudo pacman -S --noconfirm --needed devtools  # Инструменты для сопровождающих Arch Linux пакетов ; https://gitlab.archlinux.org/archlinux/devtools ; https://archlinux.org/packages/extra/any/devtools/ ; Devtools — инструменты разработки для Arch Linux ; Этот репозиторий содержит инструменты для дистрибутива Arch Linux, позволяющие создавать и поддерживать официальные пакеты репозитория.
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
echo ""
echo -e "${BLUE}:: ${NC}Установим пакет auditd (для просмотра записей в журнале выполните команд) в том числе какой процесс изменяет файл /etc/resolv.conf , а также для получения уведомления об обновлениях безопасности Arch Linux. (😃)"
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
sudo pacman -S --noconfirm --needed perf  # Инструмент аудита производительности ядра Linux ; https://archlinux.org/packages/extra/x86_64/perf/ ; https://www.kernel.org/ ; 2025-07-16 18:23 UTC
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
echo -e " Управление процессами в реальном времени - Приоритезация в реальном времени включена по умолчанию в Arch Linux. Системная, групповая и пользовательская конфигурация может быть достигнута с помощью PAM и systemd . (😃)"
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
echo -e "${GREEN}==> ${NC}Установка Интерактивного просмотрщика процессов (системы) Htop (😃)"
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
sudo pacman -S --noconfirm --needed htop iotop  # интерактивный просмотрщик запущенных процессов; просмотр процессов ввода-вывода по использованию жесткого диска;
#sudo pacman -S atop --noconfirm  # сбор статистики и наблюдение за системой в реальном времени ; Atop — это полноэкранный монитор производительности ASCII для Linux, способный сообщать об активности всех процессов (даже если процессы завершились в течение интервала), ежедневно регистрировать активность системы и процессов для долгосрочного анализа, выделять перегруженные системные ресурсы с помощью цветов и т. д.; https://www.atoptool.nl/ ; https://archlinux.org/packages/extra/x86_64/atop/
sudo pacman -S --noconfirm --needed gtop  # Панель мониторинга системы для терминала ; https://github.com/aksakalli/gtop ; https://archlinux.org/packages/extra/any/gtop/
sudo pacman -S --noconfirm --needed libgtop  # Библиотека для сбора данных мониторинга системы ; https://gitlab.gnome.org/GNOME/libgtop ; https://archlinux.org/packages/extra/x86_64/libgtop/
#sudo pacman -S --noconfirm --needed nvtop  # Мониторинг процессов графических процессоров AMD, Intel и NVIDIA ; https://github.com/Syllo/nvtop ; https://archlinux.org/packages/extra/x86_64/nvtop/
clear
echo ""
echo " Установка htop, iotop (пакетов) выполнена "
fi

echo ""
echo -e "${GREEN}==> ${NC}Установка терминальных утилит (пакетов) для вывода информации о системе (с лого в консоли)"
#echo -e "${BLUE}:: ${NC}Установка терминальных утилит для вывода информации о системе"
#echo 'Установка терминальных утилит для вывода информации о системе'
# Installing terminal utilities for displaying system information
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: (😃) ${NC}"
echo " 1 - ScreenFetch - Скрипт CLI Bash для отображения информации о системе, то выбирайте вариант - "1" "
echo -e "${MAGENTA}:: ${NC}Простая терминальная утилита для вывода информации о системе, драйвере и ОЗУ в Linux."
echo " 2 - Neofetch - Инструмент системной информации CLI, написанный на BASH, который поддерживает отображение изображений, то выбирайте вариант - "2" "
echo -e "${CYAN}:: ${NC}Установка Neofetch (neofetch) проходит через сборку из AUR (yay)(https://aur.archlinux.org/neofetch.git). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syu  # Обновите и модернизируйте свою работающую систему
yay -S neofetch --noconfirm  #  CLI-инструмент системной информации, написанный на BASH и поддерживающий отображение изображений ; https://aur.archlinux.org/neofetch.git ; https://github.com/dylanaraps/neofetch ; https://aur.archlinux.org/packages/neofetch ; 2025-05-17 20:23 (UTC)
####### neofetch ############
#git clone https://aur.archlinux.org/neofetch.git  # (только для чтения, нажмите, чтобы скопировать)
#cd neofetch
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf neofetch
#rm -Rf neofetch
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed screenfetch fastfetch
yay -S neofetch --noconfirm
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
echo " GParted - Клон Partition Magic, интерфейс для GNU Parted. (😃) "
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
echo -e "${MAGENTA}:: ${BOLD}Grub Customizer - это новый менеджер настроек для GRUB2 на гуях. (😃) ${NC}"
echo " На данный момент он позволяет: переименовывать, переупорядочивать, удалять, добавлять и скрывать элементы меню выбора загрузчика. "
echo " Домашняя страница: https://launchpad.net/grub-customizer ; (https://aur.archlinux.org/packages/grub-customizer). "
echo " Программа позволяет отредактировать (переименовать, удалить, скрыть) пункты меню загрузчика, цвета пунктов меню, фоновое изображение загрузчика GRUB и многое другое. Также можно установить таймаут (время ожидания запуска ОС), разрешение экрана, прописать дополнительные параметры для ядра. Программа поддерживает загрузчики GRUB 2 и Burg. "
echo -e "${CYAN}:: ${NC}Установка Grub Customizer (grub-customizer) проходит через сборку из AUR (yay)(https://aur.archlinux.org/grub-customizer.git). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syu  # Обновите и модернизируйте свою работающую систему
yay -S grub-customizer --noconfirm  # Графический менеджер настроек grub2 ; https://launchpad.net/grub-customizer ; https://aur.archlinux.org/packages/grub-customizer ; https://launchpad.net/grub-customizer/5.2/5.2.5/+download/grub-customizer_5.2.5.tar.gz ; 2025-05-14 18:19 (UTC)
####### grub-customizer ############
#git clone https://aur.archlinux.org/grub-customizer.git  # (только для чтения, нажмите, чтобы скопировать)
#cd grub-customizer
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf grub-customizer
#rm -Rf grub-customizer
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Редактор dconf (пакеты dconf и dconf-editor)?"
echo -e "${MAGENTA}:: ${BOLD}Редактор dconf - общий инструмент для настройки GNOME 3, Unity, MATE и Cinnamon.${NC}"
echo " Файл dconf, также называют системным реестром Linux. Этот файл двоичный, создается в момент создания профиля нового пользователя. (😃) "
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
echo -e "${MAGENTA}:: ${BOLD}Для тех кто не знает, то Conky - это мощный и легко настраиваемый системный монитор, который может отображать любую информацию на рабочем столе. (😃) ${NC}"
echo " В сети полно готовых конфигураций conky, можно взять любой понравившийся и скопировать в файл .conkyrc, который нужно создать в домашней папке (директории). Или в /etc/conky/conky.conf, так поступил и я. "
echo -e "${CYAN}:: ${BOLD}Conky Manager - это графический интерфейс для управления файлами конфигурации Conky.${NC}"
echo " Он предоставляет опции для запуска и остановки, просмотра и редактирования тем Conky, установленных в системе. Запуск нескольких экземпляров Conky с разными конфигурациями. Открытие внешнего текстового редактора для редактирования файла конфигурации. Импорт архивов с темами оформления. "
echo -e "${CYAN}:: ${BOLD}Вскрипте установки 2 (два) варианта установки: 1 - Conky (conky) + Conky Manager (conky-manager).
2 (ой) - Conky-lua-nv (conky-lua-nv)(с включенными lua и nvidia) + Conky Manager (conky-manager). Conky-lua-nv устанавливаются из из пользовательского репозитория 'AUR'-'yay', собираются и устанавливаются. Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов.${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить Conky,   2 - Да установить Conky-lua-nv (с включенными lua и nvidia),

    0 - НЕТ - Пропустить установку: " in_conky  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_conky" =~ [^120] ]]
do
    :
done
if [[ $in_conky == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_conky == 1 ]]; then
  echo ""
  echo " Установка утилит (пакетов) Conky и Conky-Manager "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
#sudo pacman -S --noconfirm --needed conky conky-manager  # Легкий системный монитор для X; Графический интерфейс для управления конфигурационными файлами Conky с возможностью просмотра и редактирования тем
sudo pacman -S --noconfirm --needed conky  # Легкий системный монитор для X ; https://github.com/brndnmtthws/conky ; https://archlinux.org/packages/extra/x86_64/conky/ ; (Помечено как устаревшее 05.07.2024)
sudo pacman -S --noconfirm --needed conky-manager  # Графический интерфейс для управления конфигурационными файлами Conky с возможностью просмотра и редактирования тем ; https://launchpad.net/conky-manager ; https://archlinux.org/packages/extra/x86_64/conky-manager/
# https://pingvinus.ru/note/conky-config-installation (Установка и настройка Conky)
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_conky == 2 ]]; then
  echo ""
  echo " Установка утилит (пакетов) Conky-lua-nv (с включенными lua и nvidia) и Conky-Manager "
####################
########## conky-cli ###############
# yay -S conky-cli --noconfirm  # Легкий системный монитор для X, без зависимостей X11 ; https://aur.archlinux.org/conky-cli.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/brndnmtthws/conky ; https://aur.archlinux.org/packages/conky-cli
############ conky-lua-nv ##################
sudo pacman -Syy  # обновление баз пакмэна (pacman)
yay -S conky-lua-nv --noconfirm  # Легкий системный монитор для X с включенными lua и nvidia ; https://aur.archlinux.org/conky-lua-nv.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/brndnmtthws/conky ; https://aur.archlinux.org/packages/conky-lua-nv
########### conky-bargile ################
# yay -S conky-bargile --noconfirm  # Еще одна тема conky-lua, в эту входит какой-то движок - пожалуйста, используйте conky с поддержкой cairo и lua ; https://aur.archlinux.org/conky-bargile.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/Noeljunior/conky-bargile ; https://aur.archlinux.org/packages/conky-bargile
########################
sudo pacman -S --noconfirm --needed conky-manager  # Графический интерфейс для управления конфигурационными файлами Conky с возможностью просмотра и редактирования тем ; https://launchpad.net/conky-manager ; https://archlinux.org/packages/extra/x86_64/conky-manager/
# https://pingvinus.ru/note/conky-config-installation (Установка и настройка Conky)
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Redshift (оберегает Ваше зрение)?"
echo -e "${MAGENTA}:: ${BOLD}Redshift - регулирует цветовую температуру экрана в соответствии с окружающей обстановкой (временем суток). (😃) ${NC}"
echo " Делает работу за компьютером более комфортной и оберегая Ваше зрение. "
echo " Redshift как минимум понадобится ваше местоположение для запуска (если - Oно не используется), то есть широта и долгота вашего местоположения. Redshift использует несколько процедур для получения вашего местоположения. Если ни одна из них не работает (например, не установлена ​​ни одна из используемых вспомогательных программ), вам нужно ввести свое местоположение вручную. "
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
# ------------------------------------------------
# Дописать после установки в разделе автозапуск
# Redshift:
# Redshift
# Инструмент регулирования цветовой температуры
# sh -c "sleep 30 && redshift-gtk -l 54.5293:36.27542 -t 6400:4500 -b 1.0:0.8"
# on login
###################

clear
echo -e "${MAGENTA}
  <<< Установка утилит (пакетов) FTP клиенты для Linux. Программы для доступа к файлам по FTP и SFTP в Archlinux >>> ${NC}"
# Installing utilities (packages) FTP clients for Linux. Programs for accessing files via FTP and SFTP in Archlinux
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить FileZilla (filezilla) - Бесплатный FTP клиент?"
echo -e "${MAGENTA}:: ${BOLD}FileZilla - это быстрый и надежный клиент FTP, FTPS и SFTP. (😃) ${NC}"
echo " Домашняя страница: http://gscan2pdf.sourceforge.net/ ; (https://archlinux.org/packages/extra/any/gscan2pdf/). "
echo -e "${MAGENTA}:: ${BOLD}FileZilla — популярный бесплатный FTP клиент для Linux, поможет загрузить и скачать нужные вам файлы с FTP-сервера. Можно отметить хороший функционал программы, она проста в настройки и пользовании. Поддерживает протоколы FTP, FTP over SSL/TLS (FTPS), SFTP. В FileZilla можно настроить закладки для различных FTP соединений. Закладки позволяют перемещаться по директориям синхронно с удаленным FTP соединением. Главное окно программы может отображать несколько областей. Первая - это две панели содержащих локальные и удаленные файлы. Также можно показать окно с отображением статуса передачи файлов и вывода ошибок, окно с очередью передачи файлов. ${NC}"
echo " В отличие от многих других FTP-менеджеров, FileZilla предоставляет возможность редактирования файлов или их атрибутов прямо на сервере, не скачивая на компьютер. Приложение FileZilla имеет в своем арсенале удобный менеджер сайтов. В него заносятся данные о серверах, с которыми FileZilla чаще всего взаимодействует. Это обеспечивает более удобный доступ к ним, и исключает потребность каждый раз вводить учетные данные. Но, в то же время в программе имеется возможность быстрого соединения с хостингом, путем ввода данных вручную, без надобности заходить в Менеджер сайтов. "
echo " С помощью специальных данных для доступа, выводит пользователю файловую систему определенного сайта. Программа имеет русский интерфейс и также поддерживается на Mac OS и Windows. Исходный код: Open Source (открыт); Языки программирования: C; C++; Библиотеки: wxWidgets; Лицензия: GNU GPL; Приложение переведено на русский язык. Недостатки: Не поддерживает кириллицу; Отсутствие возможности отключения от сервера без выключения программы. Обладая очень широким функционалом, и показывая высокий уровень стабильности работы с удаленными серверами, FileZilla заслуженно является самым популярным приложением среди – FTP-менеджеров. Лучше этого FTP-клиента, я еще ничего не нашел."
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
  echo " Установка FileZilla (filezilla) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed libfilezilla  # Небольшая и современная библиотека C++, предлагающая некоторые базовые функции для создания высокопроизводительных, платформенно-независимых программ ; https://lib.filezilla-project.org/ ; https://archlinux.org/packages/extra/x86_64/libfilezilla/
sudo pacman -S --noconfirm --needed filezilla  # Быстрый и надежный FTP, FTPS и SFTP-клиент (графический клиент) ; https://filezilla-project.org/ ; https://archlinux.org/packages/extra/x86_64/filezilla/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
################
# Как настроить и пользоваться FTP-клиентом FileZilla? Пошаговая инструкция для новичков
# Источник: https://iklife.ru/sozdanie-sajta/blog/filezilla-nastrojka-i-kak-polzovatsya
# https://blog-bridge.ru/soft-i-servisyi/filezilla-kak-polzovatsya.html
######################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Gigolo (gigolo) - Подключение к FTP и SFTP?"
echo -e "${MAGENTA}:: ${BOLD}Gigolo — графический клиент для подключения к удаленным ресурсам по FTP или SFTP (SSH). Gigolo представляет собой графический интерфейс (фронтенд) для подключения к (S)FTP серверам. Программа использует визуальную файловую систему GVfs (GNOME Virtual file system), которая в свою очередь использует библиотеку GIO (Gnome Input/Output).
Поддерживаются следующие протоколы (сервисы): FTP, SFTP (SSH), WebDAV, Secure WebDAV, Windows Share. Все ваши соединения вы можете сохранить в программе в Закладки. Каждая закладка представляет собой отдельные настройки для соединения к какому-либо серверу. Для каждой закладки можно назначить свое название и выбрать цвет. Для каждого соединения можно настроить Порт, Имя пользователя, Директорию, которую открывать при подключении. Также можно включить автоподключение при запуске программы. ${NC}"
echo " Домашняя страница: https://git.xfce.org/apps/gigolo ; (https://aur.archlinux.org/packages/gigolo). "
echo -e "${MAGENTA}:: ${BOLD}Главное окно программы в верхней части содержит меню и управляющие кнопки. Первым делом рекомендую выбрать пункт меню Вид->Боковая панель, чтобы отобразить боковую панель, через которую удобно просматривать закладки и удаленные соединения. Программа также добавляет свою иконку в панель уведомлений (трей). При клике правой кнопкой мыши по иконке, открывается контекстное меню. Через него можно получить доступ к закладкам и базовым функциям (открыть окна соединения, настроек и редактирования закладок). ${NC}"
echo " Gigolo не предоставляет графического интерфейса для просмотра удаленных файлов, но для каждого подключения можно открыть внешний файловый менеджер или терминал. Пользователь может настроить, какой терминал и файловый менеджер использовать. Программа использует библиотеки GTK2 и является частью проекта XFCE. При этом практически не имеет зависимостей от библиотек XFCE и может использоваться в любом другом дистрибутиве. Программа полностью переведена на русский язык. "
echo -e "${CYAN}:: ${NC}Установка Gigolo (gigolo) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_gigolo  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_gigolo" =~ [^10] ]]
do
    :
done
if [[ $in_gigolo == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_gigolo == 1 ]]; then
  echo ""
  echo " Установка Gigolo (gigolo) "
  echo " Gigolo (графический интерфейс для управления соединениями с удалёнными файловыми системами использующими GIO / GVfs) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
######## gigolo ############
sudo pacman -S --noconfirm --needed gvfs  # Реализация виртуальной файловой системы для GIO ; https://gitlab.gnome.org/GNOME/gvfs ; https://archlinux.org/packages/extra/x86_64/gvfs/
sudo pacman -S --noconfirm --needed intltool  # Коллекция инструментов интернационализации ; https://launchpad.net/intltool ; https://archlinux.org/packages/extra/any/intltool/
yay -S gigolo --noconfirm  # Фронтенд для управления подключениями к удаленным файловым системам с использованием GIO/GVFS ; https://aur.archlinux.org/gigolo.git (только для чтения, нажмите, чтобы скопировать) ; https://www.uvena.de/gigolo ; https://aur.archlinux.org/packages/gigolo
#git clone https://aur.archlinux.org/gigolo.git    # (только для чтения, нажмите, чтобы скопировать)
#cd gigolo
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gigolo
#rm -Rf gigolo   # удаляем директорию сборки
######## gigolo-git ############
# yay -S gigolo-git --noconfirm  # Фронтенд для управления подключениями к удаленным файловым системам с использованием GIO/GVFS ; https://aur.archlinux.org/gigolo-git.git (только для чтения, нажмите, чтобы скопировать) ; http://goodies.xfce.org/projects/applications/gigolo ; https://aur.archlinux.org/packages/gigolo-git ; Конфликты: с gigolo
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить LFTP (lftp) - Усовершенствованный FTP-клиент на основе командной строки?"
echo -e "${MAGENTA}:: ${BOLD}LFTP — это сложная программа передачи файлов с интерфейсом командной строки для UNIX и UNIX-подобных операционных систем. Программа поддерживает также протоколы FTPS, HTTP, HTTPS, HFTP, FISH и SFTP, используемый протокол автоматически определяется из URL-ссылки. Для ввода используется библиотека GNU Readline. ${NC}"
echo " Домашняя страница: https://lftp.yar.ru/ ; (https://archlinux.org/packages/extra/x86_64/lftp/). "
echo -e "${MAGENTA}:: ${BOLD}Основные функции: Рекурсивное зеркальное копирование дерева каталогов. Автоматическое возобновление прервавшейся загрузки. Выставление закладок для файлов и каталогов. Загрузка файлов в назначенное время, ограничение скорости загрузки, очереди загрузки. Контроль процесса загрузки в UNIX-подобной командной оболочке или автоматизация процесса скриптами. Поддержка протокола FXP для передачи данных между двумя FTP-серверами без участия компьютера клиента. Встроенный BitTorrent-клиент (запускается с помощью команды torrent). Протокол BitTorrent поддерживается как встроенная команда "torrent". ${NC}"
echo " Каждая операция в lftp надежна, то есть любая нефатальная ошибка обрабатывается, и операция автоматически повторяется. Таким образом, если загрузка прерывается, она будет автоматически перезапущена с точки. Даже если ftp-сервер не поддерживает команду REST, lftp попытается извлечь файл с самого начала, пока файл не будет передан полностью. Это полезно для машин с динамическим IP, которые довольно часто меняют свои IP-адреса, и для сайтов с очень плохим подключением к Интернету. Если вы выйдете из lftp, когда некоторые задания еще не завершены, lftp перейдет в режим nohup в фоновом режиме. То же самое происходит, когда у вас реально зависает модем или когда вы закрываете xterm. Более подробную информацию смотрите на странице руководства lftp (https://lftp.yar.ru/desc.html) "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_lftp  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_lftp" =~ [^10] ]]
do
    :
done
if [[ $in_lftp == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_lftp == 1 ]]; then
  echo ""
  echo " Установка FTP-клиента LFTP (lftp) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed lftp  # Усовершенствованный FTP-клиент на основе командной строки ; https://lftp.yar.ru/ ; https://archlinux.org/packages/extra/x86_64/lftp/ ; https://tokmakov.msk.ru/blog/item/729 ; https://lftp.yar.ru/desc.html ; https://ru.linux-console.net/?p=10318 ; 2024-11-15 10:11 UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Warpinator (warpinator) - Отправка и получение файлов по локальной сети?"
echo -e "${MAGENTA}:: ${BOLD}Warpinator — Отправитель файлов по локальной сети, отправка и получение файлов по сети.
Существует вероятность, что отправитель может манипулировать входящими файлами таким образом, что это может нанести вред вашей системе, используя символические ссылки (файлы, которые указывают на другие файлы или папки). Warpinator пытается обнаружить и предотвратить это, но также может использовать другие инструменты для обеспечения большей защиты. ${NC}"
echo " Домашняя страница: https://github.com/linuxmint/warpinator ; (https://archlinux.org/packages/extra/any/warpinator/). "
echo -e "${MAGENTA}:: ${BOLD}Соображения безопасности: Безопасный режим; Групповые коды. Групповой код — это общий ключ, который позволяет доверенным устройствам в локальной сети видеть друг друга в Warpinator. Любые устройства, к которым вы хотите подключиться, должны использовать тот же групповой код. По умолчанию этот код установлен на «Warpinator». Включение безопасного режима: Безопасный режим можно включить, просто изменив групповой код на что-то уникальное. Настоятельно рекомендуется сделать это как можно скорее, так как любой другой, кто попадет в вашу сеть, сможет подключиться к вам без особых усилий. ${NC}"
echo " До включения безопасного режима действуют определенные ограничения: Автоматический запуск при входе в систему отключен. Все входящие переводы должны быть одобрены пользователем. Warpinator выйдет через шестьдесят минут. Дополнительная информация: Рекомендуется, чтобы код состоял только из стандартных буквенно-цифровых символов. Код должен содержать от 8 до 32 символов. Если вы решите использовать не-ASCII символы, максимальная длина может оказаться короче. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_warpinator  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_warpinator" =~ [^10] ]]
do
    :
done
if [[ $in_warpinator == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_warpinator == 1 ]]; then
  echo ""
  echo " Установка Warpinator (warpinator) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed warpinator  # Отправитель файлов по локальной сети, отправка и получение файлов по сети ; https://github.com/linuxmint/warpinator ; https://archlinux.org/packages/extra/any/warpinator/ ; 24 июня 2024 г., 21:13 UTC ; Помечено как устаревшее 21 июля 2024 г.
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##########

clear
echo -e "${MAGENTA}
  <<< Установка утилит для тщательной очистки системы Archlinux >>> ${NC}"
# Installing utilities for thorough cleaning of the Archlinux system
echo ""
echo -e "${BLUE}:: ${NC}Установить BleachBit (для тщательной очистки)?"
echo -e "${MAGENTA}:: ${BOLD}BleachBit - это мощное приложение, предназначенное для тщательной очистки компьютера и удаления ненужных файлов, что помогает освободить место на дисках и удалить конфиденциальные данные. (😃) ${NC}"
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed bleachbit  # Удаляет ненужные файлы, чтобы освободить место на диске и сохранить конфиденциальность ; https://www.bleachbit.org/ ; https://archlinux.org/packages/extra/any/bleachbit/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Sweeper (sweeper) - Очиститель системы?"
echo -e "${MAGENTA}:: ${BOLD}Sweeper — это утилита, которая помогает очистить систему от нежелательных следов пользователя. Она может удалить cookies и очистить кэши. Sweeper - отличный инструмент для очистки, но, к сожалению, он не предустановлен ни в одной из операционных систем Linux (за исключением некоторых, основанных на KDE). ${NC}"
echo " Домашняя страница: https://apps.kde.org/sweeper/ ; (https://archlinux.org/packages/extra/x86_64/sweeper/). "
echo -e "${MAGENTA}:: ${BOLD}Вам нужно удалить ненужные файлы, такие как недавние документы, историю команд, файлы cookie и т. Д., С вашего ПК с Linux? Зацени, Sweeper (Уборщик). Это аккуратный небольшой инструмент, который может сканировать ваш компьютер с Linux на предмет нежелательных файлов и очищать его. ${NC}"
echo " Как очистить компьютер с Linux с помощью Sweeper? Если вы хотите удалить ненужные файлы из вашей операционной системы Linux с помощью Sweeper, сделайте следующее. Сначала найдите в приложении раздел «Просмотр веб-страниц» и снимите все флажки. После снятия всех флажков под разделом «Просмотр веб-страниц» в Sweeper вы сможете удалять ненужные файлы ОС Linux с помощью Sweeper. Для очистки нажмите кнопку «Очистить». Когда вы нажимаете кнопку «Очистить» в Sweeper, появляется текстовое поле. В этом текстовом поле написано: «Вы удаляете данные, которые могут быть для вас потенциально ценными. Уверены ли вы? Нажмите кнопку «Продолжить», чтобы подтвердить свой выбор. Sweeper очистит вашу систему от мусора. Когда процесс будет завершен, в текстовой подсказке Sweeper появится сообщение «Очистка завершена». "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_sweeper  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_sweeper" =~ [^10] ]]
do
    :
done
if [[ $in_sweeper == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_sweeper == 1 ]]; then
  echo ""
  echo " Установка Sweeper (sweeper) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed sweeper  # Очиститель системы ; https://apps.kde.org/sweeper/ ; https://archlinux.org/packages/extra/x86_64/sweeper/ ; 26 августа 2024 г., 7:49 UTC
# sudo pacman -Rcns sweeper  # Чтобы удалить Sweeper в Arch Linux
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Metadata Cleaner (metadata-cleaner) - Просмотр и очистка метаданных?"
echo -e "${MAGENTA}:: ${BOLD}Metadata Cleaner — это утилита для просмотра и удаления метаданных у графических, музыкальных и видео файлов. Позволяет быстро просматривать и удалять скрытые данные, включая EXIF, ID3-теги и так далее. ${NC}"
echo " Домашняя страница: https://apps.gnome.org/ru/ ; (https://archlinux.org/packages/extra/any/metadata-cleaner/). "
echo -e "${MAGENTA}:: ${BOLD}Metadata Cleaner имеет простой графический интерфейс на GTK в стилистике GNOME. В основном окне в левой колонке выводится список файлов, в правой колонке таблица с метаданными. Поддерживается импорт отдельных файлов и папок с файлами. Добавляйте файлы по отдельности или папку целиком, перетаскивайте курсором, есть горячие клавиши. Работает с картинками, видео- и аудиофайлами. Для применения в консоли справка по “mat2 -h”. Я ставил из репозиториев, доступно через Flathub. Ссылка на страницу проекта есть на gitlab, но она не рабочая. ${NC}"
echo " Метаданные в файле могут многое рассказать о вас. Камеры записывают данные о том, когда и где была сделана фотография и какая камера использовалась. Офисные приложения автоматически добавляют информацию об авторе и компании в документы и электронные таблицы. Это конфиденциальная информация, и вы, возможно, не захотите ее раскрывать. Этот инструмент позволяет просматривать метаданные в ваших файлах и по возможности избавляться от них. Под капотом он использует mat2 (https://0xacab.org/jvoisin/mat2) для анализа и удаления метаданных. mat2 сочетает в себе обе функции: и покажет скрытую информацию, и позволяет её удалить. Очистка скрытой информации о файле позволяет ещё и уменьшить вес файла. Исходный код: Open Source (открыт) ; Языки программирования: Python; Библиотеки: GTK; Лицензия: GNU GPL . "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_metadata  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_metadata" =~ [^10] ]]
do
    :
done
if [[ $in_metadata == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_metadata == 1 ]]; then
  echo ""
  echo " Установка Metadata Cleaner (metadata-cleaner) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed mat2  # Инструмент удаления метаданных, поддерживающий широкий спектр распространенных форматов файлов ; https://archlinux.org/packages/extra/any/mat2/ ; https://0xacab.org/jvoisin/mat2 ; https://github.com/tpet/mat2 ; 2025-01-11 14:38 UTC
sudo pacman -S --noconfirm --needed metadata-cleaner  # Приложение Python GTK для просмотра и очистки метаданных в файлах с использованием mat2 ; https://archlinux.org/packages/extra/any/metadata-cleaner/ ; https://apps.gnome.org/MetadataCleaner/ ; https://gitlab.com/rmnvgr/metadata-cleaner/ ; https://0xacab.org/jvoisin/mat2 ; 2024-12-22 13:52 UTC
# sudo pacman -Rcns metadata-cleaner  # Чтобы удалить Metadata Cleaner в Arch Linux
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
######### Справка ############
# Metadata Cleaner доступен в виде Flatpak на Flathub:
# Установка:
# flatpak install flathub fr.romainvigier.MetadataCleaner
# Запуск:
# flatpak run fr.romainvigier.MetadataCleaner
# Metadata Cleaner на GitHub
# https://gitlab.com/rmnvgr/metadata-cleaner/
# https://0xacab.org/jvoisin/mat2
# https://github.com/tpet/mat2
# Метаданные и конфиденциальность
# Метаданные состоят из информации, которая характеризует данные. Метаданные используются для предоставления документации для продуктов данных. По сути, метаданные отвечают на вопросы кто, что, когда, где, почему и как о каждом аспекте данных, которые документируются.
# Метаданные в файле могут многое рассказать о вас. Камеры записывают данные о том, когда была сделана фотография и какая камера использовалась. Документы Office, такие как PDF или Office, автоматически добавляют информацию об авторе и компании в документы и электронные таблицы. Возможно, вы не хотите раскрывать эту информацию.
# Именно в этом и заключается задача MAT2: избавиться, насколько это возможно, от метаданных.
# MAT2 предоставляет как инструмент командной строки, так и графический пользовательский интерфейс через расширение для Nautilus, файлового менеджера по умолчанию в GNOME.
#######################################

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Rmlint ([rm] lint) (пакет rmlint) - Инструмент для удаления дубликатов и прочего мусора и (пакет rmlint-shredder) - Графический пользовательский интерфейс для rmlint?"
# Install Rpmlint([rm] line) (rmlint package) - A tool for removing duplicates and other garbage and (rpmlint-shredder package) - A graphical user interface for rmlint?
echo -e "${MAGENTA}=> ${BOLD}Rmlint ([rm] lint) - это Инструмент для удаления дубликатов и прочего мусора, работающий намного быстрее, чем fdupes - (Программа для выявления или удаления дубликатов файлов, находящихся в указанных каталогах). Rmlint находит неиспользуемое пространство и другие неисправные элементы в вашей файловой системе и предлагает удалить их. ${NC}"
echo -e "${YELLOW}:: ${NC}Особенности: Ключевая особенность: Он может найти: Очень быстро. Гибкие и простые параметры командной строки. Выбор нескольких хэшей для обнаружения дубликатов на основе хэшей. Возможность точного побайтового сравнения (только немного медленнее). Множество вариантов вывода. Возможность сохранения времени последнего запуска; в следующий раз будут сканироваться только новые файлы. Множество вариантов для первоначального выбора/приоритизации. Может обрабатывать очень большие наборы файлов (миллионы файлов). Цветной индикатор выполнения. (😃) "
echo " Функции: Находит: Дублирующиеся файлы и дублирующиеся каталоги. Неразделенные двоичные файлы (т.е. двоичные файлы с отладочными символами). Неработающие символические ссылки. Пустые файлы и каталоги. Файлы с поврежденным идентификатором пользователя или/и группы. "
echo -e "${CYAN}:: ${NC}Отличия от других поисковиков дубликатов: Очень быстро (без преувеличения, обещаем!). Режим паранойи для тех, кто не доверяет хеш-суммам. Множество выходных форматов. Никакой интерактивности. Искать только файлы новее определенного mtime. Множество способов обработки дубликатов. Кэширование и воспроизведение и поддерживается btrfs. "
echo " Лицензия: GNU GPL3; Домашняя страница: (https://github.com/sahib/rmlint). Подробная документация доступна по адресу: (http://rmlint.rtfd.org ; https://rmlint.readthedocs.io/en/latest/tutorial.html)"
echo -e "${CYAN}:: ${NC}Установка Rmlint ([rm] lint) проходит через сборку из AUR (yay)(https://aur.archlinux.org/rmlint.git). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syu  # Обновите и модернизируйте свою работающую систему
yay -S rmlint --noconfirm  # Инструмент для удаления дубликатов и прочего мусора, работающий намного быстрее, чем fdupes ; https://github.com/sahib/rmlint ; https://aur.archlinux.org/packages/rmlint ; http://rmlint.rtfd.org
####### rmlint ############
#git clone https://aur.archlinux.org/rmlint.git  # (только для чтения, нажмите, чтобы скопировать)
#cd rmlint
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf rmlint
#rm -Rf rmlint
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
  <<< Установка Файловых менеджеров в Archlinux >>> ${NC}"
# Installing File Managers in Archlinux
echo ""
echo -e "${BLUE}:: ${NC}Установить Double Commander (Двухпанельный файловый менеджер - Аналог Total Commander)?"
echo -e "${MAGENTA}:: ${BOLD}Double Commander - двухпанельный файловый менеджер с открытым исходным кодом, работающий под Linux (два варианта, с использованием библиотек GTK+ или Qt). Программа доступна в двух версиях: с GTK и Qt интерфейсом. Имеет множество возможностей по управлению файлами и обладает большим числом настроек. Язык интерфейса: русский, английский и другие... Лицензия: GNU GPL. Кроме стандартных возможностей файлового менеджера Double Commander поддерживает монтирование сетевых -шар и локальных дисков, легкое создание символических и жестких ссылок, а также имеет много горячих кнопок. ${NC}"
echo " Домашняя страница: https://doublecmd.sourceforge.io/ ; (https://archlinux.org/packages/extra/x86_64/doublecmd-gtk2/ ; https://archlinux.org/packages/extra/x86_64/doublecmd-qt5/ ; https://archlinux.org/packages/extra/x86_64/doublecmd-qt6/). "
echo -e "${MAGENTA}:: ${BOLD}Описание: Double Commander поддерживает вкладки, может сравнивать файлы и каталоги, поддерживает множественное переименование. Программа имеет расширенные возможности поиска файлов по шаблону, поиска текста в файлах и замены текста. Имеет встроенный редактор текста с подсветкой синтаксиса. Поддерживается работа с архивами, программа может работать с ними как с каталогами. Double Commander обладает большим числом настроек и позволяет настраивать внешний вид. Программа поддерживает плагины. По своей функциональности и оформлению Double Commander напоминает Total Commander и является ему хорошей бесплатной альтернативой в Linux. (😃) ${NC}"
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
    1 - Да установить Double Commander (Qt5),     0 - НЕТ - Пропустить установку: " i_doublecmd  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
# sudo pacman -S --noconfirm --needed doublecmd-gtk2  # двухпанельный файловый менеджер (GTK2) ; https://doublecmd.sourceforge.io/ ; https://archlinux.org/packages/extra/x86_64/doublecmd-gtk2/
  sudo pacman -S --noconfirm --needed doublecmd-qt5  #  двухпанельный (в стиле Commander) файловый менеджер (Qt5) ; http://doublecmd.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/doublecmd-qt5/
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
echo -e "${MAGENTA}:: ${BOLD}KeePass - простой в использовании менеджер паролей для Windows, Linux, Mac OS X и мобильных устройств. (😃) ${NC}"
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)
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
  echo " Установка KeePassXC "
sudo pacman -S --noconfirm --needed keepassxc  # Кроссплатформенный порт менеджера паролей Keepass, созданный сообществом ; https://keepassxc.org/ ; https://archlinux.org/packages/extra/x86_64/keepassxc/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########### Дополнение ##############
# ДЛЯ Mozilla - firefox
# KeePassXC-Browser (от KeePassXC Team); https://addons.mozilla.org/ru/firefox/addon/keepassxc-browser/
# ДЛЯ Google-chrome & Chromium
# KeePassXC-Browser (Официальный плагин браузера для менеджера паролей KeePassXC https://keepassxc.org) ; https://chromewebstore.google.com/detail/keepassxc-browser/oboonakemofpalcgghocfoadofidjkkk
# Лучше всего компьютеры умеют хранить информацию. Не тратьте время на запоминание и ввод паролей. KeePassXC может безопасно хранить ваши пароли и автоматически вводить их на ваших повседневных веб-сайтах и ​​в приложениях. Политика конфиденциальности: https://keepassxc.org/privacy/#privacy-keepassxc
###########################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить BitWarden (для хранения паролей)?"
echo -e "${MAGENTA}:: ${BOLD}BitWarden - Безопасный и бесплатный менеджер паролей для всех ваших устройств. Bitwarden для Arch — это интегрированное кроссплатформенное решение с открытым исходным кодом для управления паролями для отдельных лиц, групп и коммерческих организаций. Приложение Bitwarden для ПК написано с использованием Electron и Angular. Приложение устанавливается на дистрибутивы Windows, macOS и Linux. Особенно актуально: Bitwarden бесплатен для личного использования с подпиской на Премиум-план. Лицензия GPL-3.0 ${NC}"
echo " Программа сравнима с обычным клиентом для социальных сетей или почты, которая позволяет получить доступ к базе в интернете, не дёргая браузер, похожа на тот же KeePassXC, с той лишь разницей, что база «не под рукой». При авторизации всё также попросит пройти капчу, подключить можно несколько учётных записей, есть 2FA. Внешний вид сравним со страницей на сайте. Заявлено про интеграцию с браузером, но она не поддерживается в Linux. "
echo " Домашняя страница: https://bitwarden.com/ ; (https://archlinux.org/packages/extra/x86_64/bitwarden/). "
echo " Функции: просмотр всего хранилища, копирование логинов/паролей; создание/редактирование новых/прежних записей (логинов, карт, личной информации, защищённых заметок); распределение по категориям, сортировка по папкам; есть поиск по хранилищу; ссылки на мобильные приложения (AppStore, GooglePlay), на социальные платформы, на официальный сайт; функция масштабирования (Ctrl+=, Ctrl+-, у кого слабое зрение или разрешение монитора большое); экспорт хранилища в разные форматы и т.д.. "
echo " Настраивается приложение в категориях "Безопасность" (очистка буфера обмена, блокировка хранилища по истечении времени), "Внешнего вида" (тема, язык, сворачивание в трэй) и прочее по мелочи. Есть кнопка для синхронизации с сервером, что намекает на возможность работы оффлайн с возможностью бэкапа в «облако». Формально у BitWarden есть возможность развёртывания собственного сервера, вместо использования мощностей компании по этой инструкции (https://bitwarden.com/help/install-on-premise-linux/). "
echo " Минусом считаю, что часть функций доступна только после авторизации, даже банальный генератор этих паролей не доступен — логично, но не удобно, пригодится он может и вне программы. У KeePassXC он доступен при заблокированной базе. Bitwarden требует доступ к password-manager-service безопасному хранилищу. Включите его через разрешения или запустив sudo snap connect bitwarden:password-manager-service. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_bitwarden  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_bitwarden" =~ [^10] ]]
do
    :
done
if [[ $i_bitwarden == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_bitwarden == 1 ]]; then
  echo ""
  echo " Установка BitWarden "
sudo pacman -S --noconfirm --needed bitwarden  # Безопасный и бесплатный менеджер паролей для всех ваших устройств ; https://github.com/bitwarden/clients/tree/master/apps/desktop ; https://archlinux.org/packages/extra/x86_64/bitwarden/ ; https://bitwarden.com/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить VeraCrypt (ПО для шифрования)?"
echo -e "${MAGENTA}:: ${BOLD}VeraCrypt - шифрование диска с надежной защитой на основе TrueCrypt. ${NC}"
echo " VeraCrypt — это бесплатное программное обеспечение с открытым исходным кодом для шифрования дисков для Windows, Mac OSX и Linux. (😃) "
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
echo -e "${MAGENTA}:: ${BOLD}Onboard - это экранная клавиатура полезна на планшетных ПК или для пользователей с ограниченными физическими возможностями. (😃) ${NC}"
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
echo " Plank создан для тех, кому нужен простой док без каких-либо дополнительных функций. Он основан на доке Docky, но использует только его базовый функционал. (😃) "
echo " Plank работает очень быстро, выглядит стильно и обладает приятными графическими эффектами. Док имеет возможность автоматического скрытия, если перекрывается окном открытой программы. Иконка каждой открытой программы появляется в доке. При клике правой кнопкой мыши по любой иконке открывается контекстное меню для данной программы. Каждую иконку можно закрепить. Присутствует простая анимация, при клике по иконке она подпрыгивает (аналогия с MacOS). Иконки можно перетаскивать мышкой. "
echo " К сожалению, пока нет графического интерфейса для настройки программы (хотя может и есть!!!). Все необходимые настройки хранятся в текстовом файле ~/.config/plank/dock1/settings. Для изменения настроек необходимо отредактировать данный файл. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_panel  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
echo -e "${MAGENTA}:: ${BOLD}Galculator - научный калькулятор для Linux. Galculator имеет три режима работы: (простой, научный и paper mode, в котором вычисления можно проводить путем ввода выражения в текстовое окно). (😃) ${NC}"
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
    1 - galculator-gtk2 - на основе GTK + (версия GTK2),     2 - *galculator - на основе GTK + (версия GTK3)

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
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (edk2-ovmf gnome-system-monitor, gnome-disk-utility, gpart, frei0r-plugins, fuseiso, clonezilla, crypto++, ddrescue, psensor, copyq, rsync, grsync, numlockx, modem-manager-gui, ranger, pacmanlogviewer, rofi, gsmartcontrol, testdisk, dmidecode, qemu, qemu-guest-agent, putty, w3m)."
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты! (😃)"
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
  #sudo pacman -S --noconfirm --needed numlockx  # Включает клавишу numlock в X11
  sudo pacman -S --noconfirm --needed modem-manager-gui  # Интерфейс для демона ModemManager, способного управлять определенными функциями модема
  sudo pacman -S --noconfirm --needed pacmanlogviewer  # Проверьте файлы журнала pacman
  sudo pacman -S --noconfirm --needed rofi  # Переключатель окон, средство запуска приложений и замена dmenu
  sudo pacman -S --noconfirm --needed gsmartcontrol  # Графический пользовательский интерфейс для инструмента проверки состояния жесткого диска smartctl
  sudo pacman -S --noconfirm --needed ranger  # Простой файловый менеджер в стиле vim
  sudo pacman -S --noconfirm --needed testdisk  # Проверяет и восстанавливает разделы + PhotoRec, инструмент восстановления на основе сигнатур
  sudo pacman -S --noconfirm --needed dmidecode  # Утилиты, относящиеся к таблице интерфейса управления рабочим столом
  sudo pacman -S --noconfirm --needed w3m  # Текстовый веб-браузер, а также пейджер
  sudo pacman -S --noconfirm --needed putty  # Терминальный интегрированный клиент SSH/Telnet
  sudo pacman -S --noconfirm --needed gtk3  # Мультиплатформенный набор инструментов графического интерфейса на основе GObject
  sudo pacman -S --noconfirm --needed gtk4  # Мультиплатформенный набор инструментов графического интерфейса на основе GObject
  sudo pacman -S --noconfirm --needed gtk2  # Мультиплатформенный набор инструментов GUI на основе GObject (устаревший)
  # sudo pacman -S --noconfirm --needed   #
  # sudo pacman -S --noconfirm --needed --noprogressbar --quiet  #
  echo ""
  echo " Установка утилит (пакетов) выполнена "
fi
#############

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить USBView (usbview) - Отображает топографию устройств, подключенных к шине USB?"
echo -e "${MAGENTA}:: ${BOLD}USBView — это программа GTK, которая отображает топографию устройств, подключенных к шине USB на машине Linux. Она также отображает информацию о каждом из устройств. Это может быть полезно для определения того, работает ли устройство должным образом или нет. Обратите внимание, что usbview не поддерживает никаких параметров командной строки. ${NC}"
echo " Домашняя страница: http://www.kroah.com/linux/usb/ ; (https://github.com/gregkh/usbview/ ; https://archlinux.org/packages/extra/x86_64/usbview/). "
echo -e "${MAGENTA}:: ${BOLD}USBView использует GTK+ 3.x и требует, чтобы поддержка USB была скомпилирована в вашем ядре. Она успешно работает на разрабатываемых версиях ядра выше 2.3.18 и стабильном ядре 2.2.18. Домашняя страница Linux -USB (http://www.linux-usb.org/) может (https://github.com/gregkh/usbview/) помочь вам запустить USB на Linux. ${NC}"
echo " Немного дополнительной информации: USBView был написан Грегом Кроа-Хартманом и распространяется под лицензией GNU General Public License версии 2. Приложение разработано как простой и понятный в использовании инструмент для понимания иерархии USB-устройств в вашей системе. Стоит отметить, что usbview - это небольшое и легкое приложение, и оно должно работать в большинстве систем Linux, не требуя каких-либо дополнительных зависимостей или конфигураций. Запустите USBView, введя «sudo ./usbview», и графическое отображение подключенных USB-устройств. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_usbview  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_usbview" =~ [^10] ]]
do
    :
done
if [[ $in_usbview == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_usbview == 1 ]]; then
  echo ""
  echo " Установка USBView (usbview) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed usbview  # Отображение топологии устройств на шине USB ; http://www.kroah.com/linux/usb/ ; https://github.com/gregkh/usbview/ ; https://archlinux.org/packages/extra/x86_64/usbview/ ; 14 июля 2024 г., 1:23 UTC ; Помечено как устаревшее 22 октября 2023 г.
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

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
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
  sudo pacman -S --noconfirm --needed gnome-keyring  # Хранит пароли и ключи шифрования (https://wiki.gnome.org/Projects/GnomeKeyring
  sudo pacman -S --noconfirm --needed seahorse  # Приложение GNOME для управления ключами PGP (управления паролями и ключами шифрования)
  sudo pacman -S --noconfirm --needed libsecret  # Библиотека для хранения и извлечения паролей и других секретов ; https://gnome.pages.gitlab.gnome.org/libsecret/ ; https://archlinux.org/packages/core/x86_64/libsecret/
  sudo pacman -S --noconfirm --needed libsecret-docs  # Библиотека для хранения и извлечения паролей и других секретов (документация) ; https://gnome.pages.gitlab.gnome.org/libsecret/ ; https://archlinux.org/packages/core/x86_64/libsecret-docs/
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
echo -e "${CYAN}:: Предисловие! ${NC}С появлением библиотеки GCrypt-1.7.0 с поддержкой российской криптографии (ГОСТ 28147-89, ГОСТ Р 34.11-94/2012 и ГОСТ Р 34.10-2001/2012), стало возможным говорить о поддержке российского PKI в таких проектах как Kleopatra и KMail. (😃)"
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
echo -e "${BLUE}:: ${NC}Установить Software Token (генерирует одноразовые пароли, совместимые с токенами RSA SecurID 128-бит (AES)?"
echo -e "${CYAN}:: Предисловие! ${NC}SToken — это Программный токен для криптографической аутентификации (http://stoken.sf.net/) "
echo -e "${MAGENTA}:: ${BOLD}Software Token — это программный токен, который генерирует одноразовые пароли, совместимые с токенами RSA SecurID 128-бит (AES). Токены SecurID обычно используются для аутентификации конечных пользователей в защищенных сетевых ресурсах и VPN, поскольку  OTP одноразовые пароли обеспечивают большую устойчивость ко многим атакам, связанным со статическими паролями. stoken стремится предоставить Linux-дружественную, бесплатную программную альтернативу фирменным программным аутентификаторам RSA SecurID. Этот пакет содержит автономные программы командной строки и GTK+ GUI, которые позволяют импортировать начальные значения токенов, генерировать коды токенов и различные служебные/тестовые функции. ${NC}"
echo -e "${MAGENTA}=> ${NC}Целью stoken является предоставление бесплатной программной альтернативы
фирменным программным аутентификаторам RSA SecurID, совместимой с Linux. (😃)"
echo " Этот пакет содержит автономные программы командной строки и GTK+ GUI, которые
позволяют импортировать начальные значения токенов, генерировать коды токенов и различные служебные/тестовые функции. "
echo -e "${YELLOW}:: Примечание! ${NC}Функции: Проект включает в себя несколько компонентов: Software Token (stoken-gui) - RSA SecurID-compatible software token ; Software Token (stoken-gui --small) - RSA SecurID-compatible software token . Простой интерфейс командной строки (CLI), используемый для управления и манипулирования токенами. Графический интерфейс GTK+ с функцией копирования и вставки. Общая библиотека, позволяющая другому программному обеспечению генерировать токен-коды по требованию. Также позволяет слепым и другим людям с ограниченными возможностями преодолевать эти препятствия или системы. Используйте импорт stoken для декодирования строки токена и записи ее в ~/.stokenrc . Это может вызвать для идентификатора устройства и/или пароля, в зависимости от того, какие параметры использовал ваш администратор создать токен. Строка токена может быть предоставлена ​​в командной строке или прочитана изтекстовый файл."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_stoken  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_stoken" =~ [^10] ]]
do
    :
done
if [[ $i_stoken == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_stoken == 1 ]]; then
  echo ""
  echo " Установка Software Token (программный токен) "
sudo pacman -S --noconfirm --needed stoken  # Совместимый с RSA SecurID программный токен для систем Linux/UNIX ; https://github.com/cernekee/stoken ; https://archlinux.org/packages/extra/x86_64/stoken/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#####

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Baobab (для мониторинга использования дисков)?"
echo -e "${CYAN}:: Предисловие! ${NC}Baobab — это анализатор использования диска GNOME. Disk Usage Analyzer (также известный как baobab ) сканирует папки, устройства или удаленные расположения и сообщает о дисковом пространстве, потребляемом каждым элементом. Он предоставляет как древовидное, так и графическое представление. (😃) "
echo -e "${MAGENTA}:: ${BOLD}Baobab — это простое приложение, которое может сканировать либо определенные папки (локальные или удаленные), либо тома и давать графическое представление, включая размер каждого каталога или процент в ветви. Оно также автоматически обнаруживает любое смонтированное/не смонтированное устройство. ${NC}"
echo -e "${MAGENTA}=> ${NC}Disk Usage Analyzer — Просканируйте все ваши личные файлы на компьютере ; Сканирование локальной папки, включая все её подпапки ; Удалённое сканирование папки с вашего компьютера ; Сканируйте внутренние устройства хранения данных. "
echo " Распространенные проблемы и вопросы - Ошибка при сканировании: При сканировании появляется сообщение об ошибке « Не удалось отсканировать /… или некоторые из содержащихся в нем папок» . Как удалить папку? - Переместите ненужные папки в Корзину. Как открыть папку? - Откройте папку в файловом браузере, например Файлы. Сканирование идет медленно - Сканирование папки или удаленного местоположения выполняется медленно. Время, необходимое для сканирования папки или удаленного местоположения, зависит от скорости сканируемого носителя. Например, механический жесткий диск будет медленнее, чем SSD, а сканирование удаленного каталога через Интернет, как правило, займет больше времени, чем сканирование папки по локальной сети. Скорость также зависит от глубины структуры каталогов и количества хранимых файлов. "
echo -e "${YELLOW}:: Примечание! ${NC}Функции: Различные виды диаграмм ; Отображение результата в виде круговой диаграммы или дерева. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_baobab  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_baobab" =~ [^10] ]]
do
    :
done
if [[ $i_baobab == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_baobab == 1 ]]; then
  echo ""
  echo " Установка Disk Usage Analyzer (также известный как baobab) "
sudo pacman -S --noconfirm --needed baobab  # Приложения для мониторинга дисков - Графический анализатор дерева каталогов ; https://wiki.gnome.org/Apps/DiskUsageAnalyzer ; https://archlinux.org/packages/extra/x86_64/baobab/ ; https://gitlab.gnome.org/GNOME/baobab/ ; https://help.gnome.org/users/baobab/stable/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#####

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить CoreCtrl (corectrl) - Управлять оборудованием вашего компьютера?"
echo -e "${MAGENTA}:: ${BOLD}CoreCtrl позволяет вам перевести ваш графический процессор и центральный процессор AMD в режим высокой производительности во время игр, приложение для 3D-моделирования и т.д. . *Обратите внимание: управление графическим процессором не работает на оборудовании Nvidia. CoreCtrl — это приложение Linux, позволяющее с легкостью управлять оборудованием компьютера с помощью профилей приложений. Оно стремится быть гибким, удобным и доступным для обычных пользователей. ${NC}"
echo " Домашняя страница: https://gitlab.com/corectrl/corectrl ; (https://gitlab.com/corectrl/corectrl/-/wikis/home ; https://archlinux.org/packages/extra/x86_64/corectrl/). "
echo -e "${MAGENTA}:: ${BOLD}Настройки по умолчанию определяются в глобальном профиле. Вы также можете создать столько пользовательских профилей, сколько захотите, каждый из которых будет определять свои собственные настройки. Каждый пользовательский профиль может быть связан с одним исполняемым файлом программы. При запуске связанной программы настройки профиля будут применены автоматически. Позже, когда программа завершится, предыдущие настройки будут восстановлены. Профили, не связанные ни с одним исполняемым файлом программы, можно переключать вручную. Вы можете выбрать, какие элементы системы будут контролироваться профилем, даже для глобального профиля. Таким образом, некоторые части системы останутся нетронутыми при применении профиля. Это позволит вам контролировать эти части с помощью других приложений или определять глобальное поведение для части, одновременно управляя другими частями с помощью пользовательских профилей. Подробнее об этой теме см. в разделе Как работают профили (https://gitlab.com/corectrl/corectrl/-/wikis/How-profiles-works). ${NC}"
echo " Раскрытая функциональность зависит от версии ядра и доступного оборудования. В настоящее время CoreCtrl поддерживает: AMD GPUs . Хорошая поддержка как старого, так и нового оборудования. Имеет элементы управления вентилятором, частотой и питанием, несколько датчиков и отображает информацию об оборудовании и программном обеспечении для каждого GPU. CPU: Базовая поддержка. Имеет управление регулятором масштабирования частоты, датчик максимальной частоты пакета и отображает информацию об оборудовании для каждого пакета CPU. *ПРИМЕЧАНИЕ: Вам не обязательно иметь все вышеперечисленное оборудование в вашей системе, чтобы использовать CoreCtrl. Например, у вас может не быть поддерживаемого графического процессора, но вы все равно можете захотеть использовать его для управления вашим процессором с помощью профилей приложений."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_corectrl  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_corectrl" =~ [^10] ]]
do
    :
done
if [[ $in_corectrl == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_corectrl == 1 ]]; then
  echo ""
  echo " Установка CoreCtrl (corectrl) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed corectrl  # Основное приложение управления ; https://gitlab.com/corectrl/corectrl ; https://archlinux.org/packages/extra/x86_64/corectrl/ ; https://gitlab.com/corectrl/corectrl/-/wikis/home ; https://gitlab.com/corectrl/corectrl/-/wikis/Setup ; https://gitlab.com/corectrl/corectrl/-/wikis/AMD-GPUs ; 8 июля 2024 г., 16:32 UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########## Справка ###########
# Индекс Вики CoreCtrl (corectrl):
# Установка (https://gitlab.com/corectrl/corectrl/-/wikis/Installation) . Как установить эту программу.
# Настройка (https://gitlab.com/corectrl/corectrl/-/wikis/Setup) . Инструкции по настройке CoreCtrl в вашей операционной системе и некоторые другие настройки.
# Графические процессоры AMD (https://gitlab.com/corectrl/corectrl/-/wikis/AMD-GPUs) . Как использовать особые функции графических процессоров AMD.
# FAQ (https://gitlab.com/corectrl/corectrl/-/wikis/FAQ) . Часто задаваемые вопросы.
# Известные проблемы (https://gitlab.com/corectrl/corectrl/-/wikis/Known-issues) . Распространенные проблемы и решения.
# Как работают профили (https://gitlab.com/corectrl/corectrl/-/wikis/How-profiles-works) . Информация о профилях.
# Отказ от ответственности: Неправильное использование этой программы может повредить ваше оборудование. Используйте ее на свой страх и риск!
################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить KDiskMark (kdiskmark) - Бенчмарк HDD, SSD (Тестирование производительности накопителей)?"
echo -e "${MAGENTA}:: ${BOLD}KDiskMark — утилита для тестирования производительности HDD и SSD. KDiskMark — это мощный инструмент с открытым исходным кодом для сравнительного тестирования устройств хранения данных в Linux. Он предоставляет удобный интерфейс и отображает комплексные результаты для различных тестов чтения и записи. Независимо от того, используете ли вы Debian, Ubuntu, Fedora или Arch Linux, KDiskMark можно легко установить и использовать, чтобы убедиться, что ваш SSD или HDD работает на заявленной скорости. ${NC}"
echo " Домашняя страница: https://github.com/JonMagon/KDiskMark ; (https://archlinux.org/packages/extra/x86_64/kdiskmark/). "
echo -e "${MAGENTA}:: ${BOLD}Пользователи систем Windows знают программы CrystalDiskMark и CrystalDiskInfo, которые позволяют оценить производительность и «здоровье» дисков и накопителей. Встретился инструмент для оценки скоростных показателей в различных сценариях, подойдёт для сравнения. Программа имеет довольно много опций: позволяет выбрать диски для тестирования (заблокированы системные разделы), количество прогонов от 1 до 9, размер файла для тестирования от 16 МиБ до 64 ГиБ, единицы измерения, различные профили тестирования, время между прогонами, очереди и потоки, циклы тестирования. Всякий раз, когда вы покупаете новый SSD или HDD, крайне важно проверить его скорость на соответствие заявленным характеристикам. В экосистеме Windows CrystalDiskMark является популярным инструментом для этой цели. Однако у него нет порта Linux. Итак, как вы можете протестировать свой новый диск в системе Linux? Ответ — KDiskMark, надежная альтернатива, разработанная сообществом KDE. Она использует Flexible I/O tester в фоновом режиме для сбора информации, связанной с вашей системой, а затем берет ее вывод и отображает его в удобном, понятном интерфейсе для пользователя. ${NC}"
echo " Основные возможности и особенности программы KDiskMark: Простой и понятный интерфейс. Отображение результирующей скорости записи и скорости чтения. Настройки тестов: размер блока; длина очереди; количество потоков для каждого теста; пауза между тестами. Предустановленные профили тестов. Генерация отчетов. Автор программы из России, так что можно написать ему на почту с пожеланиями и отзывами, адрес есть в «О программе». Исходный код: Open Source (открыт); Языки программирования: C++; Библиотеки: Qt; Лицензия: GNU GPL; Приложение переведено на русский язык. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_kdiskmark  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_kdiskmark" =~ [^10] ]]
do
    :
done
if [[ $in_kdiskmark == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_kdiskmark == 1 ]]; then
  echo ""
  echo " Установка KDiskMark (kdiskmark) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed kdiskmark  # Инструмент для тестирования HDD и SSD с очень удобным графическим интерфейсом пользователя ; https://github.com/JonMagon/KDiskMark ; https://archlinux.org/packages/extra/x86_64/kdiskmark/ ; 1 октября 2023 г., 6:42 UTC
# sudo pacman -Rcns kdiskmark  #  удалить kdiskmark в Arch Linux
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
###########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить OCCT (occt) - Для диагностики, тестирования  и мониторинга?"
echo -e "${MAGENTA}:: ${BOLD}OCCT (OverClock Checking Tool) — программа для тестирования и мониторинга аппаратных компонентов компьютера. Она помогает выявить сбои и ошибки в работе процессора, видеокарты, оперативной памяти и других элементов системы. Программа для проведения синтетических тестов на стабильность работы компьютера. OCCT Perestroika позволяет проводить парное тестирование: процессор - память и отдельную проверку стабильной работы центрального процессора и оперативной памяти. Результаты проверки выводятся в виде информативных графиков. Программа поддерживает работу с современными многоядерными процессорами и совместима с последними версиями Windows. В ходе тестов утилита выводит рабочие параметры компонентов системы, используя сторонние программы мониторинга (SpeedFan, AIDA64 и т.п.). ${NC}"
echo " Домашняя страница: https://www.ocbase.com/ ; (https://archlinux.org/packages/extra/x86_64/occt/). "
echo -e "${MAGENTA}:: ${BOLD}**Перед началом теста убедитесь в наличии чистоты в системе охлаждения!!! Основные возможности по тестированию видеокарты: Стресс тест графического процессора, создающий близкую к предельной нагрузку; Режим автоматического обнаружения ошибок изображения, вызванных нестабильностью GPU, в рендеринге тестовой сцены; мониторинг температуры графического процессора в ходе теста;
Возможность автоматической и ручной настройки сложности тестирующего шейдерного кода; Поддержка конфигураций SLI; Тест надежности видеопамяти, построенный на API универсальных вычислений CUDA. ${NC}"
echo " Программа OCCT включает пять тестов с возможностью изменить их параметры и длительность. OCCT включает тесты с собственными алгоритмами проверки, которые позволяют выявлять проблемы в работе компьютера. С помощью программы OCCT вы сможете определить, связаны ли сбои или проблемы в работе системы с неисправными процессором, видеокартой или блоком питания. Помимо выполнения тестов, программа отображает общую информацию о компонентах компьютера и позволяет мониторить температуру, напряжения питания, скорость вентиляторов и частоту процессора, а также визуально отслеживать их изменения на удобных графиках. Приложение переведено на русский язык. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_occt  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_occt" =~ [^10] ]]
do
    :
done
if [[ $in_occt == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_occt == 1 ]]; then
  echo ""
  echo " Установка OCCT (OverClock Checking Tool) (occt) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed occt  # Инструмент проверки разгона — стресс-тестирование и мониторинг ЦП/ГП ; https://www.ocbase.com/ ; https://archlinux.org/packages/extra/x86_64/occt/ ; 2025-06-10 16:33 UTC
# sudo pacman -Rcns occt  #  удалить occt в Arch Linux
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
###########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить ⏰ Alarm Clock (alarm-clock-applet) - Будильник для области уведомлений?"
echo -e "${MAGENTA}:: ${BOLD}Alarm Clock (Будильник) — это полнофункциональный будильник для использования с реализацией AppIndicator. Он прост в использовании, но при этом мощный, с поддержкой нескольких повторяющихся будильников, а также отсрочки и гибкой системы уведомлений. Будильник — это мощное приложение, поддерживающее несколько будильников, а также автоматически повторяющиеся будильники. Это приложение не принимает никаких параметров командной строки. ${NC}"
echo " Домашняя страница: https://alarm-clock-applet.github.io/ ; (https://aur.archlinux.org/packages/alarm-clock-applet). "
echo -e "${MAGENTA}:: ${BOLD}Функции: Легко использовать. Будильник прост в использовании - нажатие на значок панели вызовет список будильников. Оттуда вы можете добавлять, редактировать и удалять будильники, а также запускать, останавливать и откладывать их. Будильник поддерживает два типа будильников: Часы и Таймер. Часы сработают в определенное время суток, а таймер зазвонит через указанный промежуток времени. ${NC}"
echo " Уведомления: Будильник оповестит вас о будильнике, либо проиграв звук , либо запустив ваш любимый музыкальный проигрыватель! Конечно, вы можете указать, какой звук вы хотели бы использовать и должен ли он повторяться или нет. Также можно указать пользовательскую команду для запуска вместо предопределенных медиаплееров. Вздремнуть: Как будильники, так и таймеры можно отложить — для этого достаточно выбрать будильник и нажать «Отложить». Для удобства контекстное меню значка панели обеспечивает быстрый доступ к функциям откладывания и остановки любых звуковых сигналов будильника. Установка: Инструкции по установке можно найти на сайте проекта (https://alarm-clock-applet.github.io/#install). Будильник-апплет был написан Йоханнесом Х. Йенсеном < joh@pseudoberries.com > и является лицензировано в соответствии с GNU General Public License, версии 2 или любой более поздней версии, опубликованной Фонд свободного программного обеспечения. "
echo -e "${CYAN}:: ${NC}Установка Alarm Clock (alarm-clock-applet) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_alarm  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_alarm" =~ [^10] ]]
do
    :
done
if [[ $in_alarm == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_alarm == 1 ]]; then
  echo ""
  echo " Установка Alarm Clock (alarm-clock-applet) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
######## alarm-clock-applet ##########
yay -S alarm-clock-applet --noconfirm  # Полнофункциональный будильник для использования с реализацией AppIndicator ; https://aur.archlinux.org/alarm-clock-applet.git (только для чтения, нажмите, чтобы скопировать) ; https://alarm-clock-applet.github.io/ ; https://aur.archlinux.org/packages/alarm-clock-applet ; https://github.com/alarm-clock-applet/alarm-clock/archive/refs/tags/0.4.1.tar.gz ; 2024-08-29 21:38 (UTC) ; Конфликты: с alarm-clock-applet-git; Смотрите Зависимости !
#git clone https://aur.archlinux.org/alarm-clock-applet.git   # (только для чтения, нажмите, чтобы скопировать)
#cd alarm-clock-applet
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf alarm-clock-applet
#rm -Rf alarm-clock-applet
# yay -Rns alarm-clock-applet  # * (Необязательно) Удалите alarm-clock-applet на Arch с помощью YAY
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Kronometer (kronometer) - Секундомер?"
echo -e "${MAGENTA}:: ${BOLD}Kronometer — это приложение-секундомер. Kronometer — это бесплатное программное обеспечение, выпущенное под лицензией GPLv2 . Kronometer является частью сообщества KDE. Если вы хотите внести свой вклад в разработку Kronometer , вам предлагается присоединиться к миру KDE. Посетите эту страницу (https://community.kde.org/Get_Involved). Репозиторий git находится здесь (https://commits.kde.org/kronometer). ${NC}"
echo " Домашняя страница: https://userbase.kde.org/Kronometer ; (https://archlinux.org/packages/extra/x86_64/kronometer/). "
echo -e "${MAGENTA}:: ${BOLD}Документация: Kronometer предоставляет документацию, совместимую с KDE, которая доступна в установленном приложении, если щелкнуть Kronometer Handbook в меню Help . Документация также доступна онлайн на серверах KDE: Справочник хронометра ( HTML https://docs.kde.org/stable5/en/extragear-utils/kronometer/index.html). Справочник хронометра ( PDF https://docs.kde.org/stable5/en/extragear-utils/kronometer/kronometer.pdf). ${NC}"
echo " Основные особенности Kronometer: Запустить/приостановить/возобновить работу виджета секундомера. Запись кругов: вы можете зафиксировать время секундомера, когда захотите, и добавить к нему заметку. Сортировка времени круга: вы можете легко найти самое короткое или самое длинное время круга. Сброс виджета секундомера и времени круга. Настройки формата времени: можно выбрать детализацию секундомера. Сохранение и возобновление времени: вы можете сохранить состояние секундомера и возобновить его позже. Настройка шрифта: вы можете выбрать шрифт для каждой цифры секундомера. Настройка цвета: вы можете выбрать цвет цифр секундомера и фона секундомера. Экспорт времени круга: вы можете экспортировать время круга в файл, используя формат JSON или CSV. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_kronometer  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_kronometer" =~ [^10] ]]
do
    :
done
if [[ $in_kronometer == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_kronometer == 1 ]]; then
  echo ""
  echo " Установка Kronometer (kronometer) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed kronometer  # Простое приложение хронометра ; https://userbase.kde.org/Kronometer ; https://archlinux.org/packages/extra/x86_64/kronometer/ ; 30 сентября 2023 г.
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo -e "${MAGENTA}
  <<< Установка утилит (пакетов) для поиска файлов и запуска приложений в Archlinux >>> ${NC}"
# Installing utilities (packages) to search for files and launch applications in Archlinux
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Catfish (catfish) (утилита для поиска файлов)?"
echo -e "${MAGENTA}:: ${BOLD}Catfish - это простая и быстрая программа, предназначенная для поиска файлов и каталогов на вашем жестком диске. Она умеет искать по названию и по содержимому (https://launchpad.net/catfish-search). Catfish — поисковая утилита GTK+, написанная на Python. Ее поиск основан на find и locate, а поисковые подсказки предоставлены Zeitgeist. ${NC}"
echo -e "${MAGENTA}=> ${NC}Пользоваться Catfish очень просто. Введя в строку поиска «.jpg» (без кавычек), вы найдете все изображения этого типа, а всего несколько известных букв из имени файла помогут найти все файлы и каталоги, содержащие в названии то же сочетание букв. Перед началом поиска можно выбрать тип файла, например «Изображения» или «Видео», задать предполагаемый временной промежуток, указать более точное местонахождение, а так же — надо ли отображать результаты для скрытых файлов и каталогов. Все это может существенно ускорить поиск. (😃)"
echo " Если программа запущена в первый раз, по возможности обновите поисковый индекс. Catfish и так работает достаточно шустро, но это поможет ей находить потерянные файлы еще быстрее. Найденное можно удалить прямо из окна результатов (обратите внимание: минуя «Корзину», то есть навсегда!), открыть с помощью программы по-умолчанию для этого типа файла, показать в файловом менеджере, скопировать в другое место, либо скопировать в буфер обмена полный адрес местонахождения файла для последующих операций. Catfish бесплатна и распространяется на условиях лицензии GPL2. "
echo -e "${YELLOW}:: Примечание! ${NC}К недостаткам программы можно отнести невозможность копировать несколько файлов сразу (и простым перетаскиванием из окна результатов поиска), а так же, по сути, бесполезную опцию «Показать в файловом менеджере», так как среди сотен или даже тысяч ваших файлов искомое выделено не будет."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_catfish  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_catfish" =~ [^10] ]]
do
    :
done
if [[ $i_catfish == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_catfish == 1 ]]; then
  echo ""
  echo " Установка Catfish (catfish) "
sudo pacman -S --noconfirm --needed catfish  # Универсальный инструмент для поиска файлов ; https://docs.xfce.org/apps/catfish/start ; https://archlinux.org/packages/extra/any/catfish/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Synapse Лаунчер (synapse) (утилита запуска семантических файлов)?"
echo -e "${CYAN}:: Предисловие! ${NC}Семантический лаунчер, написанный на языке Vala, который можно использовать для запуска приложений, а также для поиска и доступа к соответствующим документам и файлам с помощью движка Zeitgeist. "
echo -e "${MAGENTA}:: ${BOLD}Synapse - это простой быстрый лаунчер для Linux. Позволяет искать и запускать приложения, открывать документы и файлы, а также выполнять другие полезные действия (https://launchpad.net/synapse-project). ${NC}"
echo -e "${MAGENTA}=> ${NC}Программа Synapse представляет собой строку поиска, которую можно вызвать в любое время, нажав сочетание Ctrl+Пробел. В строку поиска вы можете вводить название или часть названия программ, файлов, различных команд. Клавишами Влево, Вправо можно выбрать категорию поиска. Если нажать клавишу Вниз, то раскроется список с дополнительными результатами поиска. Полный список горячих клавиш можно посмотреть в настройках программы."
echo " Synapse действительно работает очень быстро. Поиск происходит мгновенно без каких-либо задержек. Качество самого поиска мне очень понравильнось. "
echo -e "${YELLOW}:: Примечание! ${NC}Программа поддерживает темы оформления. Можно изменить настройки горячих клавиш. Поддерживаются плагины, которые добавляют различную функциональность и расширяют возможности строки поиска. Например, плагин калькулятора позволяет выполнять вычисления прямо в строке поиска."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_synapse  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_synapse" =~ [^10] ]]
do
    :
done
if [[ $i_synapse == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_synapse == 1 ]]; then
  echo ""
  echo " Установка Synapse (synapse) "
sudo pacman -S --noconfirm --needed synapse  # Средство запуска семантических файлов ; https://launchpad.net/synapse-project ; https://archlinux.org/packages/extra/x86_64/synapse/ ; Synapse переведен Elementary со структурированными разрешениями.
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#########

clear
echo ""
echo -e "${GREEN}==> ${BOLD}Установить сетевые утилиты, VPN, Proxy , драйверы и тд...? ${NC}"
#echo -e "${BLUE}:: ${NC}Установить дополнительные сетевые утилиты, драйверы?"
#echo 'Установить дополнительные сетевые утилиты, драйверы
# Install additional network utilities, drivers
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (#ebtables, ipset ,iproute2, traceroute, nmap, vulscan, wavemon, dsniff, wvdial, libdnet, nbd, broadcom-wl-dkms, linux-atm)."
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты! (😃)"
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
  sudo pacman -S --noconfirm --needed openvpn  # Простой в использовании, надежный и настраиваемый VPN (виртуальная частная сеть) ; https://openvpn.net/index.php/open-source.html ; https://archlinux.org/packages/extra/x86_64/openvpn/
  sudo pacman -S --noconfirm --needed --noprogressbar --quiet networkmanager-openvpn  # Плагин NetworkManager VPN для OpenVPN ; https://networkmanager.dev/docs/vpn/ ; https://archlinux.org/packages/extra/x86_64/networkmanager-openvpn/
  sudo pacman -S --noconfirm --needed openconnect  # Открытый клиент для Cisco AnyConnect VPN ; https://www.infradead.org/openconnect/ ; https://archlinux.org/packages/extra/x86_64/openconnect/
  sudo pacman -S --noconfirm --needed networkmanager-openconnect  # Плагин NetworkManager VPN для OpenConnect ; https://wiki.gnome.org/Projects/NetworkManager ; https://archlinux.org/packages/extra/x86_64/networkmanager-openconnect/
  sudo pacman -S --noconfirm --needed networkmanager-pptp  # Плагин NetworkManager VPN для PPTP ; https://wiki.gnome.org/Projects/NetworkManager ; https://archlinux.org/packages/extra/x86_64/networkmanager-pptp/
  sudo pacman -S --noconfirm --needed vpnc  # Клиент VPN для концентраторов cisco3000 VPN ; https://github.com/streambinder/vpnc ; https://archlinux.org/packages/extra/x86_64/vpnc/
  sudo pacman -S --noconfirm --needed networkmanager-vpnc  # Плагин NetworkManager VPN для VPNC ; https://wiki.gnome.org/Projects/NetworkManager ; https://archlinux.org/packages/extra/x86_64/networkmanager-vpnc/
############ Proxy ###########
  sudo pacman -S --noconfirm --needed privoxy  #  Веб-прокси с расширенными возможностями фильтрации ; https://www.privoxy.org/ ; https://archlinux.org/packages/extra/x86_64/privoxy/
  sudo pacman -S --noconfirm --needed proxychains-ng  # Предварительный загрузчик ловушки, который позволяет перенаправлять TCP-трафик существующих динамически связанных программ через один или несколько SOCKS или HTTP-прокси ; https://github.com/rofl0r/proxychains-ng ; https://archlinux.org/packages/extra/x86_64/proxychains-ng/
  sudo pacman -S --noconfirm --needed mitmproxy  # HTTP-прокси-сервер типа «man-in-the-middle» с поддержкой SSL (https://mitmproxy.org/) ; https://archlinux.org/packages/extra/any/mitmproxy/
  sudo pacman -S --noconfirm --needed network-manager-sstp  # Поддержка SSTP для NetworkManager ; https://gitlab.gnome.org/GNOME/network-manager-sstp ; https://archlinux.org/packages/extra/x86_64/network-manager-sstp/
  sudo pacman -S --noconfirm --needed networkmanager-strongswan  # Плагин Strongswan NetworkManager ; https://wiki.strongswan.org/projects/strongswan/wiki/NetworkManager ; https://archlinux.org/packages/extra/x86_64/networkmanager-strongswan/
  sudo pacman -S --noconfirm --needed i2pd  # Полнофункциональная реализация маршрутизатора I2P на языке C++ ; https://archlinux.org/packages/extra/x86_64/i2pd/ ; https://i2pd.website/ ; Обеспечивает: i2p-router ; 2025-06-15 12:33 UTC
  echo ""
  echo -e "${BLUE}:: ${NC}Ставим дополнительные сетевые утилиты"
  sudo pacman -S --noconfirm --needed --noprogressbar --quiet inetutils  # Сборник общих сетевых программ ; https://www.gnu.org/software/inetutils/ ; https://archlinux.org/packages/core/x86_64/inetutils/
  sudo pacman -S --noconfirm --needed ethtool  # Утилита для управления сетевыми драйверами и оборудованием, в частности, для проводных устройств Ethernet ; https://www.kernel.org/pub/software/network/ethtool/ ; https://archlinux.org/packages/extra/x86_64/ethtool/
  sudo pacman -S --noconfirm --needed gnome-nettool  # Графический интерфейс для различных сетевых инструментов для (различных сетевых командных строк - инструменты, такие как ping, netstat, ifconfig, whois, traceroute, finger) ; https://gitlab.gnome.org/GNOME/gnome-nettool ; https://archlinux.org/packages/extra/x86_64/gnome-nettool/
  sudo pacman -S --noconfirm --needed mobile-broadband-provider-info  # Демон сетевого управления (информация о провайдере мобильного широкополосного доступа) ; Предварительные настройки конфигурации APN для мобильных широкополосных подключений ; https://gitlab.gnome.org/GNOME/mobile-broadband-provider-info ; https://www.archlinux.org/packages/extra/any/mobile-broadband-provider-info/
  sudo pacman -S --noconfirm --needed modemmanager  # Служба управления мобильным широкополосным модемом ; https://www.freedesktop.org/wiki/Software/ModemManager/ ; https://archlinux.org/packages/extra/x86_64/modemmanager/
  sudo pacman -S --noconfirm --needed nss-mdns  # Плагин glibc, обеспечивающий разрешение имени хоста через mDNS ; http://0pointer.de/lennart/projects/nss-mdns/ ; https://archlinux.org/packages/extra/x86_64/nss-mdns/
  sudo pacman -S --noconfirm --needed ntp  # Справочная реализация сетевого протокола времени ; https://www.ntp.org/ ; https://archlinux.org/packages/extra/x86_64/ntp/
  sudo pacman -S --noconfirm --needed nftables  # Таблицы Netfilter, инструменты пользовательского пространства ; https://archlinux.org/packages/extra/x86_64/nftables/ ; https://netfilter.org/projects/nftables/ ; 2025-04-23 18:47 UTC
  sudo pacman -S --noconfirm --needed traceroute  # Отслеживает маршрут пакетов по IP-сети ; http://traceroute.sourceforge.net/ ; https://archlinux.org/packages/core/x86_64/traceroute/ ; 7 января 2024 г., 18:38 UTC
  sudo pacman -S --noconfirm --needed usb_modeswitch  # Активация переключаемых USB-устройств в Linux ; http://www.draisberghof.de/usb_modeswitch/ ; https://archlinux.org/packages/extra/x86_64/usb_modeswitch/
  sudo pacman -S --noconfirm --needed --noprogressbar --quiet iwd  # Демон беспроводной сети Интернет ; https://git.kernel.org/cgit/network/wireless/iwd.git/ ; https://archlinux.org/packages/extra/x86_64/iwd/
  sudo pacman -S --noconfirm --needed crda  # Агент центрального регулирующего домена для беспроводных сетей ; https://wireless.wiki.kernel.org/en/developers/regulatory/wireless-regdb ; https://archlinux.org/packages/core/any/wireless-regdb/
# pacman -S --noconfirm --needed wireless-regdb  # Центральная база данных регулирующих доменов ; https://wireless.wiki.kernel.org/en/developers/regulatory/wireless-regdb ; https://archlinux.org/packages/core/any/wireless-regdb/
  sudo pacman -S --noconfirm --needed ndisc6  # Сборник сетевых утилит IPv6 (https://www.remlab.net/ndisc6/) ; https://archlinux.org/packages/extra/x86_64/ndisc6/
  sudo pacman -S --noconfirm --needed gnu-netcat  # GNU переписывает netcat, приложение для создания сетевых трубопроводов (приложения сетевого конвейера) ; сетевая утилита, которая считывает и записывает данные через сетевые соединения, используя протокол TCP/IP ; http://netcat.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/gnu-netcat/
# sudo pacman -S --noconfirm --needed openbsd-netcat  # Швейцарский армейский нож TCP/IP. Вариант OpenBSD ; https://archlinux.org/packages/extra/x86_64/openbsd-netcat/ ; https://salsa.debian.org/debian/netcat-openbsd ; 2025-07-17 12:41 UTC . Вариант OpenBSD (Важно конфликтует с gnu-netcat - GNU переписывает netcat, приложение для создания сетевых трубопроводов). Простая утилита Unix, которая считывает и записывает данные через сетевые соединения с использованием протоколов TCP или UDP. Этот пакет содержит переписанную версию netcat для OpenBSD, включая поддержку IPv6, прокси-серверов и сокетов Unix.
 sudo pacman -S --noconfirm --needed bridge-utils  # Утилиты для настройки Ethernet-моста Linux ; https://archlinux.org/packages/extra/x86_64/bridge-utils/ ; https://wiki.linuxfoundation.org/networking/bridge ; 2024-03-05 15:32 UTC
  sudo pacman -S --noconfirm --needed hydra  # Очень быстрый взломщик входа в сеть, который поддерживает множество различных сервисов ; Введите `./hydra -h`, чтобы увидеть все доступные параметры командной строки ; https://github.com/vanhauser-thc/thc-hydra ; https://archlinux.org/packages/extra/x86_64/hydra/
  echo ""
  echo -e "${BLUE}:: ${NC}Установим сетевую инфраструктуру программ и пакетов"
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
########### DNS-запрос и DHCP-сервер #############
  sudo pacman -S --noconfirm --needed bind  # Полная, переносимая реализация протокола DNS ; https://www.isc.org/software/bind/ ; https://archlinux.org/packages/extra/x86_64/bind/
  sudo pacman -S --noconfirm --needed c-ares   # Библиотека AC для асинхронных DNS-запросов ; это современная библиотека DNS (заглушки) resolver ; https://c-ares.org/ ; https://archlinux.org/packages/extra/x86_64/c-ares/
  sudo pacman -S --noconfirm --needed bind  # Полная, переносимая реализация протокола DNS ; https://www.isc.org/software/bind/ ; https://archlinux.org/packages/extra/x86_64/bind/
  sudo pacman -S --noconfirm --needed netplan  # Средство визуализации абстракции конфигурации сети ; https://github.com/CanonicalLtd/netplan ; https://archlinux.org/packages/extra/x86_64/netplan/
############ Утилиты фильтрации #################
#  sudo pacman -S --noconfirm --needed ebtables  # Утилиты фильтрации Ethernet-моста (на основе nft). ebtables похоже на iptables, но отличается тем, что работает преимущественно не на третьем (сетевом), а на втором (канальном) уровне сетевого стека.
  #sudo pacman -S ebtables  # Утилиты фильтрации Ethernet-моста (на основе nft). ebtables похоже на iptables, но отличается тем, что работает преимущественно не на третьем (сетевом), а на втором (канальном) уровне сетевого стека.
#  AUR ebtables-git  # Фильтрующий инструмент для межсетевого экрана на базе Linux ; https://aur.archlinux.org/ebtables-git.git (только для чтения, нажмите, чтобы скопировать); https://ebtables.netfilter.org/ ; https://aur.archlinux.org/packages/ebtables-git
 ### Это инструмент фильтрации для брандмауэра-моста на базе Linux. Она обеспечивает прозрачную фильтрацию сетевого трафика, проходящего через мост Linux. Возможности фильтрации ограничены фильтрацией на уровне канала и некоторой базовой фильтрацией на более высоких уровнях сети. Также включены расширенные возможности ведения журнала, MAC DNAT/SNAT и brouter.
############ Утилиты IP-маршрутизации #################
  #sudo pacman -S --noconfirm --needed ipset  # Инструмент администрирования наборов IP (Помечен как устаревший 5 июня 2024 г.); https://netfilter.org/projects/ipset/ ; https://archlinux.org/packages/extra/x86_64/ipset/
  sudo pacman -S --noconfirm --needed ipset  # Инструмент администрирования наборов IP (Помечен как устаревший 5 июня 2024 г.); https://netfilter.org/projects/ipset/ ; https://archlinux.org/packages/extra/x86_64/ipset/
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
  sudo pacman -S --noconfirm --needed iptraf-ng  # Консольная утилита мониторинга сети ; https://github.com/iptraf-ng/iptraf-ng ; https://archlinux.org/packages/extra/x86_64/iptraf-ng/ ; 12 июля 2024 г., 19:39 UTC
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
echo -e "${MAGENTA}=> ${BOLD}Большинство людей очень щепетильно относятся к своей конфиденциальности, и им не нравится, когда их контролируют правительства, народы, организации и т.д.. Группа людей также может проживать в странах, где социальные сети и некоторые веб-сайты заблокированы, и им что-то нужно анонимно искать и скачивать в сети. (😃) ${NC}"
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
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... (😃) "
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
# sudo systemctl status tor.service  # статус сервиса tor
# sudo journalctl -xeu tor  # лог сервиса tor
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
echo -e "${CYAN}:: ${NC}Wireshark — анализатор трафика (сниффер) для Linux, поддерживает более сотни сетевых протоколов. Анализ, учет и сбор трафика в режиме реального времени. Он доступен во всех основных настольных операционных системах, таких как Windows, Linux, macOS, BSD и других. (😃)"
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
  sudo pacman -S --noconfirm --needed wireshark-cli  # Анализатор/сниффер сетевого трафика и протоколов — инструменты CLI и файлы данных ; https://www.wireshark.org/ ; https://archlinux.org/packages/extra/x86_64/wireshark-cli/ ; https://www.wireshark.org/download.html ; только для интерфейса командной строки tshark
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
echo -e "${MAGENTA}:: ${BOLD}KDE Connect — это детище Альберта Васа, которое является частью его проекта на Google Summer of Code 2013. Идея KDE Connect — подключить любое устройство к компьютеру с KDE. Сейчас KDE Connect поддерживает подключение устройств Android по сети Wi-Fi к KDE и Gnome и других. Утилита уже встроена в Plasma по умолчанию, а для Gnome есть расширение Gsconnect, которое реализует такие же возможности. Ещё есть порт KDE Connect Windows... (😃)${NC}"
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
echo -e "${GREEN}==> ${NC}Установим TLP - Для увеличения продолжительности времени работы от батареи"
#echo -e "${BLUE}:: ${NC}Установим TLP - Для увеличения продолжительности времени работы от батареи"
#echo 'Установим TLP - Для увеличения продолжительности времени работы от батареи'
# Set TLP - to increase the duration Of battery life
echo -e "${MAGENTA}:: ${BOLD}TLP - это продвинутая, консольная утилита для управления питанием, которая автоматически применяет нужные настройки для конкретного аппаратного оборудования. (😃)${NC}"
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
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
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
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами. (😃) "
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
echo " Вот некоторые разумные настройки по умолчанию для TLP "
cat << EOF > /etc/tlp.conf
SATA_LINKPWR_ON_AC="max_performance"
SATA_LINKPWR_ON_BAT="med_power_with_dipm"
RADEON_POWER_PROFILE_ON_AC="high"
RADEON_POWER_PROFILE_ON_BAT="low"
RESTORE_DEVICE_STATE_ON_STARTUP="1"
EOF
############
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
echo -e "${MAGENTA}:: ${BOLD}Файловая система exFAT разработана Microsoft и предназначена для портативных устрйств, например USB флешки. (😃) ${NC}"
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
echo -e "${MAGENTA}:: ${BOLD}Обычно при предоставлении удаленного доступа к Linux серверам вам предоставляется именно SSH (Secure Shell) доступ. (😃) ${NC}"
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
echo -e "${MAGENTA}:: ${BOLD}Avahi (😃) —  это свободная Linux-реализация протокола, также известного как ("Rendezvous" или "Bonjour") для дистрибутивов Linux и BSD. Распространяется под лицензией LGPL. Avahi — система, производящая анализ локальной сети на предмет выявления различных сервисов. К примеру, вы можете подключить ноутбук к локальной сети и сразу получить информацию об имеющихся принтерах, разделяемых ресурсах, сервисах обмена сообщениями и прочих услугах. ${NC}"
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
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Добавляем в автозагрузку avahi (avahi-daemon.service) для выбор сетевого адреса для устройства?"
#echo 'Добавляем в автозагрузку avahi (avahi-daemon.service) для выбор сетевого адреса для устройства?'
# Adding avahi (avahi-daemon.service) to the startup to select the network address for the device?
echo -e "${YELLOW}:: ${BOLD}Запускаем сервис (avahi-daemon.service), если таковой был вами установлен. ${NC}"
echo -e "${CYAN}:: ${NC}Вы сможете выполнить запуск (avahi-daemon.service) позже, воспользовавшись скриптом как шпаргалкой!"
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами. (😃) "
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

######## Samba #############
clear
echo ""
echo -e "${GREEN}==> ${NC}Установить файловый сервер Samba на Arch Linux - для общего доступа к файлам и принтерам между системами Linux и Windows?"
#echo -e "${BLUE}:: ${NC}Установить файловый сервер Samba на Arch Linux - для общего доступа к файлам и принтерам между системами Linux и Windows?"
#echo 'Установить файловый сервер Samba на Arch Linux - для общего доступа к файлам и принтерам между системами Linux и Windows?'
# Install a Samba file server on Arch Linux - for file and printer sharing between Linux and Windows systems?
echo -e "${MAGENTA}:: ${BOLD}Samba —  это реализация сетевого протокола SMB. Она облегчает организацию общего доступа к файлам и принтерам между системами Linux и Windows и является альтернативой NFS. (😃) ${NC}"
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
echo -e "${GREEN}==> ${NC}Будете ли Вы подключать Android или Iphone к ПК через USB?"
#echo -e "${BLUE}:: ${NC}Будете ли Вы подключать Android или Iphone к ПК через USB?"
#echo 'Будете ли Вы подключать Android или Iphone к ПК через USB?'
# Will you connect your Android or Iphone to your PC via USB?
echo -e "${MAGENTA}=> ${NC}Установка поддержки для устройств на (базе) Android или Iphone к ПК через USB. "
# Installing support for Android or Iphone devices to a PC via USB
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор остаётся за вами. (😃) "
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
echo -e "${MAGENTA}=> ${BOLD}Timeshift - это утилита для создавать резервные копии вашей системы, с возможностью инкрементного резервного копирования. (😃) ${NC}"
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)
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
echo ""
echo -e "${BLUE}:: ${NC}Установить Déjà Dup (deja-dup) - Резервное копирование?"
echo -e "${MAGENTA}:: ${BOLD}Déjà Dup — это простое средство резервного копирования. Оно скрывает сложность правильного создания резервных копий (использование шифрования, хранение отдельно от компьютера, регулярность копирования) и использует duplicity в качестве внутреннего интерфейса. ${NC}"
echo " Домашняя страница: https://apps.gnome.org/DejaDup/ ; (https://archlinux.org/packages/extra/x86_64/deja-dup/). "
echo -e "${MAGENTA}:: ${BOLD}Déjà Dup сфокусирована на простоте использования восстановления персональных данных, в случае их потери. Если вам требуется полноценное резервное копирование системы или программа архивации, рассмотрите другие варианты программ резервного копирования. DejaDup умеет отправлять копии на локальные диски, ваши личные серверы в локальной сети, а также в облака Google и Nextcloud. Планировщик тут тоже в наличии, хотя настройки довольно скудные. Приложение может делать копии каждый день или неделю и — при необходимости — удалять старые данные (раз в полгода или год). ${NC}"
echo " Функции: Поддержка локальных, дистанционных или облачных расположений резервных копий, таких как Google Drive. Надежно шифрует и сжимает данные. Поэтапное резервное копирование, позволяет вам выполнять восстановление из определённых резервных копий. Планирование регулярного резервного копирования. Интегрируется на должном уровне с рабочим столом GNOME. Déjà Dup(day-ja-doop) поддерживает Webdav. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_dejadup  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_dejadup" =~ [^10] ]]
do
    :
done
if [[ $in_dejadup == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_dejadup == 1 ]]; then
  echo ""
  echo " Установка DejaDup (deja-dup) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed deja-dup  # Простой инструмент резервного копирования, GTK-интерфейс для дублирования ; https://apps.gnome.org/DejaDup/ ; https://archlinux.org/packages/extra/x86_64/deja-dup/ ; 29 июля 2024 г., 1:23 UTC
deja-dup --version
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить LuckyBackup (luckybackup) - Инструмент резервного копирования и синхронизации?"
echo -e "${MAGENTA}:: ${BOLD}luckyBackup - это бесплатное приложение для резервного копирования и синхронизации данных, работающее на базе инструмента rsync в ОС семейства Linux. Он предоставляет графический интерфейс, основанный на кроссплатформенной структуре Qt. Это мощный, надежный и быстрый инструмент для осуществления резервного копирования и синхронизации данных. Эта программа нравится пользователям и экспертам тем, что старается сберечь время и пространство. Lucky Backup делает первоначальный бэкап, после чего отслеживает состояние источника и сохраняет только произошедшие изменения, то есть добавляет файлы к имеющимся архиву, а не «перезаливает» каждый раз весь бэкап целиком. ${NC}"
echo " Домашняя страница: https://luckybackup.sourceforge.net/ ; (https://aur.archlinux.org/packages/luckybackup). "
echo -e "${MAGENTA}:: ${BOLD}У Lucky Backup есть возможности копировать не только информацию, но также ее атрибуты. Так, например, программа может зафиксировать владельца, группу, время получения или создания, а также разрешения файлов. Lucky Backup имеет два режима работы — простой и для продвинутых юзеров. Первый подойдет для большинства пользователей, второй же предлагает разнообразие опций вроде создания профилей, составления индивидуального расписания для резервного копирования данных, запуска моделирования, оповещения по электронной почте и даже добавление выбранных юзером команд, которые Lucky Backup будет выполнять до или после создания бэкапа. Он прост в использовании, быстр (переносит только внесенные изменения, а не все данные), безопасен (сохраняет ваши данные в безопасности, проверяя все заявленные каталоги, прежде чем приступить к любым манипуляциям с данными), надежен и полностью настраивается. Программа имеет удобный интерфейс, который сделает любого пользователя счастливым. Оно предоставляет графический интерфейс на основе кроссплатформенного фреймворка Qt и не является по сути консольным или веб-ориентированным, как многие клиенты из списка программного обеспечения для резервного копирования. Графический интерфейс переведен на многие языки и доступен в репозиториях всех основных дистрибутивов Linux. Последняя версия была выпущена в ноябре 2018 года, и хотя разработка «практически заморожена», программа все еще поддерживается. ${NC}"
echo " Функции: Создавайте полные резервные копии. Создавайте резервные копии моментальных снимков. Синхронизировать каталоги данных. Проверка данных для гарантии того, что ничего не удалено. Простые и расширенные возможности. Включить/исключить файлы. Локальное или удаленное резервное копирование. Плановое резервное копирование. Резервное моделирование. Ведение журнала. Параметр командной строки. Профили. *После установки запускаем LuckyBackup (суперпользователь)! "
echo -e "${CYAN}:: ${NC}Установка luckyBackup (luckybackup) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_luckybackup  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_luckybackup" =~ [^10] ]]
do
    :
done
if [[ $in_luckybackup == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_luckybackup == 1 ]]; then
  echo ""
  echo " Установка luckyBackup (luckybackup) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pamac build luckybackup  # Установка через пакмэна (pacman)
########## luckybackup #############
yay -S luckybackup --noconfirm  # Инструмент резервного копирования и синхронизации с использованием Rsync и Qt5 ; http://luckybackup.sourceforge.net/ ; https://aur.archlinux.org/luckybackup.git (только для чтения, нажмите, чтобы скопировать) ; https://aur.archlinux.org/packages/luckybackup ; http://downloads.sourceforge.net/project/luckybackup/0.5.0/source/luckybackup-0.5.0.tar.gz ; 2018-11-05 22:22 (UTC) ; Конфликты: с luckybackup-git
#git clone https://aur.archlinux.org/luckybackup.git   # (только для чтения, нажмите, чтобы скопировать)
#cd luckybackup
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf luckybackup
#rm -Rf luckybackup
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
######### Справка ##########
# Резервное копирование LuckyBackup
# https://entnet.ru/client/soft/rezervnoe-kopirovanie-luckybackup.html
##############################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Vorta (vorta) - Настольный клиент для Borg Backup?"
echo -e "${MAGENTA}:: ${BOLD}Vorta — клиент резервного копирования для macOS и Linux. Он интегрирует мощный инструмент резервного копирования Borg Backup с вашей любимой рабочей средой, защищая ваши данные от сбоев диска, атак программ-вымогателей и кражи. Vorta должна работать на всех платформах, поддерживающих Qt и Borg. Это включает macOS, Ubuntu, Debian, Fedora, Arch Linux и многие другие. Vorta имеет открытый исходный код и распространяется по лицензии Gnu GPL. ${NC}"
echo " Домашняя страница: https://vorta.borgbase.com/ ; (https://github.com/borgbase/vorta.git ; https://www.borgbackup.org/ ; https://borgbackup.github.io/ ; https://borgbackup.readthedocs.io/en/stable/). "
echo -e "${MAGENTA}:: ${BOLD} ${NC}"
echo " Функции: Зашифрованные, дедуплицированные и сжатые резервные копии, использующие Borg в качестве бэкенда; Vorta позволяет создавать резервные копии на: локальные диски, ваш собственный сервер или BorgBase, хостинг-сервис для резервного копирования Borg; Есть возможность создавать гибкие профили для группирования исходных папок (выбор папок и файлов, а также их исключения из резервной копии), мест назначения резервных копий и расписаний; Просмотр архивов резервных копий с отметками времени, из которых можно извлекать, монтировать, проверять, удалять или обрезать резервные копии; Есть возможность настроить удаление старых резервных копий через определенный период; Имеется встроенная генерация SSH-ключей; Есть возможность настроить отображение уведомлений при сбое резервного копирования и/или успешном выполнении; Включить/выключить автоматический запуск Vorta при входе в систему и т.д. . Открытый исходный код — можно свободно использовать, изменять, улучшать и проверять. "
echo " Информация о программе: Язык интерфейса: Английский ; Разработчик: Manuel Riel and Vorta contributors ; Язык программирования: Python, Qt ; Лицензия: GPL v3 ; Документация Borg - (https://borgbackup.readthedocs.io/en/stable/). "
echo -e "${CYAN}:: ${NC}Использование: Узнайте, как настроить резервное копирование на удалённый (или локальный ) носитель. И, что самое главное, как восстановить файлы позже (https://vorta.borgbase.com/; https://www.borgbase.com ; https://www.borgbase.com/login?redirect=/repositories ; https://borgbackup.readthedocs.io/en/stable/). Доступные пакеты и инструкции по установке смотрите здесь (https://vorta.borgbase.com/install/). Ещё маленький совет - зарегистрируйтесь на BorgBase (https://www.borgbase.com/) и вы получете 10 Gb бесплатно для резервных копий с шифрованием, также есть платные функции. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_vorta  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_vorta" =~ [^10] ]]
do
    :
done
if [[ $in_vorta == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_vorta == 1 ]]; then
  echo ""
  echo " Установка  Vorta (vorta) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########## vorta #############
sudo pacman -S --noconfirm --needed borg  # Программа резервного копирования с дедупликацией и сжатием и аутентифицированным шифрованием ; https://archlinux.org/packages/extra/x86_64/borg/ ; https://borgbackup.github.io/ ; https://www.borgbackup.org/ ; https://borgbackup.readthedocs.io/en/stable/ ; Обеспечивает: borgbackup ; Заменяет: borgbackup ; 2025-04-21 22:03 UTC
sudo pacman -S --noconfirm --needed vorta  # Настольный клиент для Borg Backup ; https://archlinux.org/packages/extra/any/vorta/ ; https://vorta.borgbase.com/ ; https://github.com/borgbase/vorta.git ; 2024-12-26 23:08 UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Cronopete (cronopete) - Утилита резервного копирования?"
echo -e "${MAGENTA}:: ${BOLD}Cronopete — это Linux-клон Time Machine, утилиты резервного копирования для Mac от Apple. Он стремится максимально точно ее имитировать. Создатель Cronopete прямо заявляет на своём сайте, что при разработке своего приложения вдохновлялся Time Machine на Mac. А потому настроек тут минимум. *Важно отметить, что Cronopete НЕ предназначен для резервного копирования всей операционной системы; только личных файлов. Никогда не пытайтесь сделать резервную копию корневой папки или системных папок, таких как "/etc". Название происходит от слова anacronopete («тот, кто летит сквозь время»), которое обозначает машину времени, описанную в романе Энрике Гаспара-и-Рембо, опубликованном в 1887 году (на восемь лет раньше « Машины времени » Герберта Уэллса). ${NC}"
echo " Домашняя страница: https://rastersoft.com/programas/cronopete.html ; (https://aur.archlinux.org/packages/cronopete). "
echo -e "${MAGENTA}:: ${BOLD}Как утилита резервного копирования, она периодически делает копию всех пользовательских файлов на отдельном жестком диске, что позволяет восстановить их в случае случайного удаления файла или повреждения основного жесткого диска. Каждая копия хранится отдельно (одна копия в час сохраняется в течение последних 24 часов, одна ежедневная копия в течение последних 15 дней и одна еженедельная копия в остальное время), что означает, что пользователь может выбрать, какую копию восстанавливать. Файлы, которые не изменяются между резервными копиями, хранятся как жесткие ссылки, и, таким образом, каждая новая копия занимает гораздо меньше места на диске, чем настоящая полная копия. Внутри она использует RSync для выполнения всей работы по резервному копированию. ${NC}"
echo " При первом запуске Chronopete спросит вас, где хранить копии — в какой‑то папке или на внешнем жёстком диске, — и предложит выбрать файлы, которые следует копировать. После этого приложение поселится в вашем трее и будет периодически делать бэкапы. А ещё Chronopete станет автоматически удалять старые файлы, когда ваш диск начнёт переполняться. "
echo -e "${CYAN}:: ${NC}Установка Cronopete (cronopete) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_cronopete  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_cronopete" =~ [^10] ]]
do
    :
done
if [[ $in_cronopete == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_cronopete == 1 ]]; then
  echo ""
  echo " Установка Cronopete (cronopete) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pamac build cronopete  # Установка через пакмэна (pacman)
########## cronopete #############
yay -S cronopete --noconfirm  # Графическая утилита резервного копирования, основанная на идее Apple Time Machine ; http://www.rastersoft.com/programas/cronopete.html ; https://aur.archlinux.org/cronopete.git (только для чтения, нажмите, чтобы скопировать) ; https://aur.archlinux.org/packages/cronopete ; https://gitlab.com/rastersoft/cronopete/-/archive/4.16.0/cronopete-4.16.0.tar.gz ; 2024-02-08 19:03 (UTC) ; Смотрите Зависимости !
#git clone https://aur.archlinux.org/cronopete.git   # (только для чтения, нажмите, чтобы скопировать)
#cd cronopete
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf cronopete
#rm -Rf cronopete
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Back in Time (backintime) - Резервное копирования файлов и папок?"
echo -e "${MAGENTA}:: ${BOLD}Back In Time — это простой в использовании инструмент для резервного копирования файлов и папок. Он работает на GNU/Linux (не на Windows или OS X/macOS) и предоставляет инструмент командной строки backintime и графический интерфейс backintime-qt, написанные на Python3. Он используется rsyncдля создания ручных или запланированных снимков и сохраняет их локально или удаленно через SSH. Каждый снимок находится в своей собственной папке с копиями исходных файлов, но неизмененные файлы жестко связаны между снимками для экономии места на диске. Он был вдохновлен FlyBack (https://en.wikipedia.org/wiki/FlyBack). Проект находится в активной разработке с тех пор, как летом 2022 года к нему присоединилась новая команда . Разработка ведется в свободное время, поэтому нужно расставить приоритеты. Оставайтесь с нами, мы все♥️ Назад во времени . 😁 ${NC}"
echo " Домашняя страница: https://github.com/bit-team/backintime ; (https://aur.archlinux.org/packages/backintime). "
echo -e "${MAGENTA}:: ${BOLD}Продвинутое приложение с достаточно разнообразными настройками. При первом запуске оно предложит вам создать профиль и выбрать, где размещать резервные копии, какие файлы и папки сохранять, а какие нет, как часто выполнять бэкапы и когда удалять старые, залежавшиеся данные, чтобы освободить место на диске. Поначалу может показаться, что настроек у Back in Time слишком много. Но, в принципе, разобраться в нём не так сложно. ${NC}"
echo " Отдельная приятная особенность Back in Time в том, что оно умеет создавать резервные копии не только по расписанию, но и каждый раз, когда подключается подходящий внешний носитель. Вы подсоединяете жёсткий диск, и через несколько минут на нём появляется резервная копия. Использование помощника AUR, такого как yay, для сборки пакетов, включая backintime, КРАЙНЕ не рекомендуется. Рекомендуемый метод сборки — использовать чистый chroot. См.: https://wiki.archlinux.org/title/DeveloperWiki:Building_in_a_clean_chroot .  "
echo -e "${CYAN}:: ${NC}Установка Back in Time (backintime) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_backintime  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_backintime" =~ [^10] ]]
do
    :
done
if [[ $in_backintime == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_backintime == 1 ]]; then
  echo ""
  echo " Установка Back in Time (backintime) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
########## Зависимости ###########
# sudo pamac build clean-chroot-manager  # Установка через пакмэна (pacman)
# Я написал скрипт, который автоматизирует большую часть того, что называется clean-chroot-manager (https://aur.archlinux.org/packages/clean-chroot-manager) , и предлагается здесь, в AUR.
# yay -S clean-chroot-manager --noconfirm  # Оболочка для управления чистыми сборками chroot с локальным репозиторием ; https://aur.archlinux.org/clean-chroot-manager.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/graysky2/clean-chroot-manager ; https://aur.archlinux.org/packages/clean-chroot-manager ; https://github.com/graysky2/clean-chroot-manager/archive/v2.227.tar.gz ; 2024-05-16 16:47 (UTC)
git clone https://aur.archlinux.org/clean-chroot-manager.git   # (только для чтения, нажмите, чтобы скопировать)
cd clean-chroot-manager
# makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf clean-chroot-manager
rm -Rf clean-chroot-manager
########## Зависимости ###########
# sudo pamac build backintime-cli  # Установка через пакмэна (pacman)
# yay -S backintime-cli --noconfirm  # Простая система резервного копирования, вдохновленная Flyback Project и TimeVault. CLI-версия ; https://github.com/bit-team/backintime ; https://aur.archlinux.org/backintime.git (только для чтения, нажмите, чтобы скопировать) ; https://aur.archlinux.org/packages/backintime-cli ; https://github.com/bit-team/backintime/archive/refs/tags/v1.5.2.tar.gz ; 2024-08-07 19:55 (UTC) ; Смотрите Зависимости !
#git clone https://aur.archlinux.org/backintime.git   # (только для чтения, нажмите, чтобы скопировать)
#cd backintime-cli
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf backintime-cli
#rm -Rf backintime-cli
########## backintime #############
# sudo pamac build backintime  # Установка через пакмэна (pacman)
# yay -S backintime --noconfirm  # Простая система резервного копирования, вдохновленная проектом Flyback и TimeVault. Версия Qt5 GUI ; https://github.com/bit-team/backintime ; https://aur.archlinux.org/backintime.git (только для чтения, нажмите, чтобы скопировать) ; https://aur.archlinux.org/packages/backintime ; https://github.com/bit-team/backintime/archive/refs/tags/v1.5.2.tar.gz ; 2024-08-07 19:55 (UTC) ; Смотрите Зависимости !
git clone https://aur.archlinux.org/backintime.git   # (только для чтения, нажмите, чтобы скопировать)
cd backintime
# makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf backintime
rm -Rf backintime
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить ZBackup (zbackup) - Инструмент резервного копирования с дедупликацией?"
echo -e "${MAGENTA}:: ${BOLD}ZBackup — это инструмент для глобального дедуплицирования резервного копирования, основанный на идеях, найденных в rsync.tar . Подайте в него большой файл , и он сохранит дублированные области только один раз, затем сожмет и, при необходимости, зашифрует результат. Подайте другой .tarфайл, и он также повторно использует любые данные, найденные в предыдущих резервных копиях. Таким образом, сохраняются только новые изменения, и пока файлы не сильно отличаются, требуемый объем хранилища очень мал. Любой из ранее сохраненных файлов резервных копий можно прочитать полностью в любое время. Программа не зависит от формата, поэтому вы можете подавать в нее практически любые файлы (любые типы архивов, фирменные форматы, даже необработанные образы дисков — но см. Предостережения http://zbackup.org/). ${NC}"
echo " Домашняя страница: http://zbackup.org/ ; (https://aur.archlinux.org/packages/zbackup). "
echo -e "${MAGENTA}:: ${BOLD}Это достигается путем скольжения окна с скользящим хешем по входу с гранулярностью байта и проверки того, встречался ли уже блок в фокусе. Если скользящий хеш совпадает, вычисляется дополнительный полный криптографический хеш, чтобы убедиться, что блок действительно тот же. Затем происходит дедупликация. ${NC}"
echo " Программа имеет следующие возможности: Параллельное сжатие LZMA или LZO хранимых данных. Встроенное AES-шифрование хранимых данных. Возможность удаления старых резервных данных. Использование 64-битного скользящего хэша, сводящее количество мягких коллизий к нулю. Репозиторий состоит из неизменяемых файлов. Никакие существующие файлы никогда не изменяются. Репозиторий состоит из неизменяемых файлов. Никакие существующие файлы никогда не изменяются. Написано только на C++ с небольшими библиотечными зависимостями. Безопасно для использования в производстве (см. http://zbackup.org/). Возможность обмена данными между репозиториями без пересжатия. "
echo -e "${CYAN}:: ${NC}Установка ZBackup (zbackup) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_zbackup  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_zbackup" =~ [^10] ]]
do
    :
done
if [[ $in_zbackup == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_zbackup == 1 ]]; then
  echo ""
  echo " Установка ZBackup (zbackup) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
######### zbackup ##########
# sudo pamac build zbackup
yay -S zbackup --noconfirm  # Универсальный дедуплицирующий инструмент резервного копирования ; https://aur.archlinux.org/zbackup.git (только для чтения, нажмите, чтобы скопировать) ; http://zbackup.org/ ; https://aur.archlinux.org/packages/zbackup ; 2024-01-02 06:59 (UTC) ; https://github.com/zbackup/zbackup
#git clone https://aur.archlinux.org/zbackup.git   # (только для чтения, нажмите, чтобы скопировать)
#cd zbackup
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf zbackup
#rm -Rf zbackup
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########## Справка ##############
# ZBackup - http://zbackup.org/
# Для использования:
# zbackup init --незашифрованный /my/backup/repo
# tar c /my/precious/data | zbackup резервная копия /my/backup/repo/backups/backup- ` дата ' +%Y-%m-%d ' `
# zbackup восстановление /my/backup/repo/backups/backup- ` дата ' +%Y-%m-%d ' `  > /my/precious/backup-restored.tar
# Если у вас много свободной оперативной памяти, вы можете использовать ее для ускорения процесса восстановления — использовать еще 512 МБ, пропустите --cache-size 512mbпри восстановлении.
# Если требуется шифрование, создайте файл с вашим паролем:
# безопаснее использовать редактор
# echo mypassword >  ~ /.my_backup_password
# chmod 600 ~ /.my_backup_password
# Затем инициализируйте репозиторий следующим образом:
# zbackup init --password-file ~ /.my_backup_password /my/backup/repo
# И всегда потом передайте один и тот же аргумент:
# tar c /my/precious/data | zbackup --password-file ~ /.my_backup_password резервная копия /my/backup/repo/backups/backup- ` дата ' +%Y-%m-%d ' `
# zbackup --password-file ~ /.my_backup_password восстановление /my/backup/repo/backups/backup- ` дата ' +%Y-%m-%d ' `  > /my/precious/backup-restored.tar
###############################

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
echo " Он создан в соответствии со спецификацией freedesktop.org и должен работать в любой графической среде, поддерживающей эту спецификацию. (https://gitlab.gnome.org/GNOME/alacarte) (😃) "
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
echo " Java JDK – это набор инструментов специально для разработчиков. Он содержит элементы для программирования на этом языке, а также позволяет преобразовать код или «собрать» его, а затем выполнить. Каждый Java-программист полагается на JDK для создания программ, виртуальных сред, их запуска и отладки. Без JDK вы все еще можете писать код, но не можете перейти к созданию запускаемой программы. Следовательно, наличие установленного JDK жизненно важно, если вы хотите работать с Java, поскольку по-другому вы не сможете этого сделать. Оригинальная Java Development Kit была создана компанией Oracle. В настоящее время имеется немало дистрибутивов, которые были произведены сторонними разработчиками. (😃) "
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)
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
echo -e "${MAGENTA}
  <<< Установка дополнительного программного обеспечения (пакетов) для личных данных пользователя в Archlinux >>> ${NC}"
# Installing additional software (packages) for updating the user's personal data in Archlinux
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

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Calcurse (calcurse) - Текстовый персональный органайзер?"
echo -e "${MAGENTA}:: ${BOLD}Calcurse — это простой, но мощный текстовый календарь и органайзер, который можно использовать и в Linux, особенно если вы проводите много времени в командной строке. ${NC}"
echo " Домашняя страница: https://calcurse.org/ ; (https://archlinux.org/packages/extra/x86_64/calcurse/). "
echo -e "${MAGENTA}:: ${BOLD}Calcurse — это календарь и приложение для планирования в командной строке. Оно помогает отслеживать события, встречи и повседневные задачи. Настраиваемая система уведомлений напоминает пользователю о приближающихся сроках, интерфейс на основе curses можно настроить в соответствии с потребностями пользователя, а очень мощный набор параметров командной строки можно использовать для фильтрации и форматирования встреч, что делает его пригодным для использования в скриптах. ${NC}"
echo " Он предлагает ряд замечательных функций, в том числе: Настраиваемая система уведомлений для напоминания о будущих событиях, с возможностью отправки электронных писем  или что-либо еще, что может напомнить вам о предстоящих встречах). Гибко настраиваемый интерфейс на основе curses, отвечающий потребностям пользователя. Поддерживает многочисленные виды встреч и задач, включая мероприятия на весь день и повторяющиеся встречи. Гибко настраиваемые сочетания клавиш. Поддержка импорта файлов формата iCalender. Поддержка экспорта в несколько форматов, включая iCalender и pcal. Предлагает впечатляющую неинтерактивную командную строку, поддерживающую скрипты. Хуки – запуск скриптов при загрузке/сохранении данных, например, для помещения данных календаря под контроль версий и многое другое. Экспериментальная поддержка CalDAV — синхронизируйте calcurse с вашими мобильными устройствами! Поддержка UTF-8. Возможность прикреплять заметки к каждому элементу календаря и редактировать их с помощью вашего любимого текстового редактора. Поддержка интернационализации с переводом текстов на английский, французский, немецкий, голландский, испанский и итальянский языки. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_calcurse  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_calcurse" =~ [^10] ]]
do
    :
done
if [[ $in_calcurse == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_calcurse == 1 ]]; then
  echo ""
  echo " Установка Calcurse (calcurse) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed calcurse  # Текстовый персональный органайзер ; https://calcurse.org/ ; https://archlinux.org/packages/extra/x86_64/calcurse/ ; 12 июля 2024 г., 2:07 UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########

clear
echo -e "${CYAN}
  <<< Обновление информации о шрифтах и создание backup (резервной копии) файлов grub.cfg и grub >>> ${NC}"
# Updating font information and creating a backup of grub.cfg and grub files.

echo ""
echo -e "${BLUE}:: ${NC}Обновим информацию о шрифтах"
#echo 'Обновим информацию о шрифтах'
# Update information about fonts
sudo fc-cache -f -v
# sudo fc-list | grep "<name-of-font>"  # Чтобы проверить установлен ли шрифт

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
sleep 1

clear
echo ""
echo -e "${YELLOW}=> ${NC}Если у вас параллельно установлен Windows или другая ОС и Вы обнаружите, что в меню boot Grub эта ОС не определилась в списке, давайте обновим конфигурации grub (загрузчик)"
echo ""
echo " Обновить конфигурации grub чтобы видеть другие Системы (если такие присутствуют) например Windows? "
echo " После обновления конфигурации grub обязательно перезагрузить систему Archlinux! "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Вы можете пропустить это действие..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да Обновить конфигурации grub,     0 - Нет пропустить этот шаг: " u_grub  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$u_grub" =~ [^10] ]]
do
    :
done
if [[ $u_grub == 0 ]]; then
echo ""
echo " Обновление конфигурации grub пропущено "
elif [[ $u_grub == 1 ]]; then
  echo ""
  echo " Обновить конфигурации grub в директории исходника "
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo " Обновление конфигурации grub выполнено "
echo " Обязательно перезагрузить систему Archlinux! "
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