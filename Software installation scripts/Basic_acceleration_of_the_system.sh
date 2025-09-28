#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! ####
apptitle="Arch Linux Fast Install v2.5 LegasyBIOS - Version: 2025.07.30.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя
### Basic_acceleration_of_the_system
BASIC_ACCELERATION_OF_THE_SYSTEM_LANG="russian"  # Installer default language (Язык установки по умолчанию)
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

       ____        __  _    ___              __
      / __ \____  / /_(_)  /   |  __________/ /_
     / / / / __ \/ __/ /  / /| | / ___/ ___/ __ \
    / /_/ / /_/ / /_/ /  / ___ |/ /  / /__/ / / /
    \____/ .___/\__/_/  /_/  |_/_/   \___/_/ /_/
        /_/
   >>>   A tool for fast optimization of Arch
${NC}
Цель сценария (скрипта) - это установка первоначально необходимого софта (пакетов) и запуск необходимых служб.
Смысл в том, что все изменения вы делаете предварительно в самом скрипте и получаете возможность быстрой установки утилит (пакетов), которые Вы решили установить (при условии, что Вы его изменили под себя, в противном случае скрипт установит софт (пакеты) прописанный изначально.
В процессе работы сценария (скрипта) Вам будут задаваться вопросы на установку той, или иной утилиты (пакета) - будьте внимательными! В скрипте есть утилиты (пакеты), которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора, и т.д.. Остальной софт (пакеты) скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска необходимых служб. В любой ситуации выбор всегда за вами. Вы либо гуляете под дождем, либо просто под ним мокнете. ${RED}

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
sleep 17
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
  <<< Установка утилит (пакетов) для Базового ускорения работы в Archlinux >>> ${NC}"
# Installing utilities (packages) for Basic acceleration in Archlinux
echo -e "${BLUE}:: ${BOLD}Переходя к базовой оптимизации системы мне стоит напомнить, что чистый Arch Linux - это фундамент, и требуется уйма надстроек для нормальной работы системы. Установить компоненты, которые будут отвечать за электропитание, чистку, оптимизацию и тому подобные вещи, что и представленно в данном сценарии скрипта. ${NC}"
#clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Ccache (ccache) - Быстрый кэш компилятора C/C++?"
# echo -e "${BLUE}:: ${NC}Установить Ccache (ccache) - Быстрый кэш компилятора C/C++?"
echo -e "${YELLOW}==> Внимание! ${BOLD} *Ccache может ломать сборку некоторых программ, поэтому будьте внимательны с его применением. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Ccache (от англ. compiler cache) - это кэш для компиляторов C/C++ для Linux и других Unix-подобных систем, в частности совместимый с компиляторами GCC/Clang, цель которого состоит в ускорении повторного процесса компиляции (сборку) одно и того же кода (пакетов или проектов). Это значит, что если при повторной пересборке программы новой версии, будут замечены полностью идентичные блоки исходного кода в сравнении с его старой версией, то компиляция этих исходных текстов производиться не будет. Вместо этого, уже готовый, скомпилированный код старой версии будет вынут из кэша ccache. За счёт этого и достигается многократное ускорение процесса компиляции. В Linux системах есть не так много программ, сборка которых может занять больше двух часов, но они все таки есть. Потому, было бы неплохо ускорить повторную компиляцию таких программ как Wine/Proton-GE и т.д.. ${NC}"
echo " Домашняя страница: https://ccache.dev/ ; (https://ccache.dev/download.html ; github.com/ccache/ccache ; https://archlinux.org/packages/extra/x86_64/ccache/). "
echo -e "${BLUE}:: ${NC}Принцип работы: При компилировании какого-либо файла вычисляется его хеш. Если такой файл уже присутствует в реестре скомпилированных файлов, то он не будет компилироваться заново, а будет использоваться старый бинарный файл. Особенности: Учитываются разные версии компилятора и опции сборки. Например, если однажды собран проект с оптимизацией -О2, то при сборке с оптимизацией -О3 файл будет компилироваться заново, при этом в реестре ccache старый файл сохранится, но добавится и новый. Если какой-либо файл единожды скомпилирован неправильно, то при повторном компилировании без изменений параметров он не будет исправлен — этого можно избежать, удалив файлы из кэша. "
echo -e "${CYAN}:: ${NC}Некоторые возможности настройки: Указать размер кэша — по умолчанию ccache использует 5 ГБ, но можно настроить это на основе потребностей. Например, команда: ccache -M 10G. Указать каталог кэша — если нужно, можно указать другой каталог: export CCACHE_DIR="/path/to/your/cache". Настроить систему сборки — например, если используется make, можно установить компилятор на использование ccache: export CC="ccache gcc" export CXX="ccache g++". "
echo " Тестирование: После настройки можно проверить, правильно ли работает ccache, с помощью команды ccache -s. Она отображает хиты кэша, промахи и другие полезные статистики. В большинстве дистрибутивов Linux ccache устанавливается с помощью менеджера пакетов. "
echo -e "${YELLOW}==> Внимание! ${BOLD} *Глобальное использование ccache не рекомендуется, так как это приведёт к переполнению кэша и снижению количества обращений к нему! Вместо этого включите его для отдельных пакетов. Ccache может ломать сборку некоторых программ, поэтому будьте внимательны с его применением. Важно: ccache эффективен только при компиляции точно идентичных источников (точнее, предварительно обработанных). ${NC}"
echo -e "${YELLOW} Примечание! ${BOLD} *Включение ccache: После установки его ещё нужно задействовать в нашей конфигурации makepkg. Для этого отредактируем конфигурационный файл: в /etc/makepkg.conf (данные конфигурации makepkg - будут закомментированы # в Справке под выполнением этого сенария скрипта). ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_ccache  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_ccache" =~ [^10] ]]
do
    :
done
if [[ $in_ccache == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_ccache == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Ccache (ccache) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
sudo pacman -S --noconfirm --needed ccache  # Кэш компилятора, который ускоряет перекомпиляцию за счет кэширования предыдущих компиляций ; https://archlinux.org/packages/extra/x86_64/ccache/ ; https://ccache.dev/ ; https://ccache.dev/download.html ; github.com/ccache/ccache ; 2025-06-07 12:59 UTC
########## Оболочка компилятора ############
sudo pacman -S --noconfirm --needed colorgcc  # Оболочка Perl для раскрашивания выходных данных компиляторов с предупреждениями/сообщениями об ошибках, соответствующими формату выходных данных gcc ; https://archlinux.org/packages/extra/any/colorgcc/ ; https://github.com/colorgcc/colorgcc ; 2024-07-12 03:08 UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########### Справка по настройке makepkg.conf #############
# ArchWiki - https://wiki.archlinux.org/title/Ccache
# GentooWiki - https://wiki.gentoo.org/wiki/Ccache
### После установки его ещё нужно задействовать в нашей конфигурации makepkg. Для этого отредактируем конфигурационный файл:
# sudo nano /etc/makepkg.conf
# sudo mousepad /etc/makepkg.conf
### Найдите данную строку в собственных настройках, затем уберите восклицательный знак перед *"ccache"*
# BUILDENV=(!distcc color ccache check !sign)
# После этого повторная пересборка желаемых программ и их обновление должны значительно ускориться.
### Начальная настройка:
# Просто включите поддержку ccache в make.conf :
# /etc/portage/make.conf
#FEATURES="ccache"
# Portage defaults to ${PORTAGE_TMPDIR}/ccache unless CCACHE_DIR is
# set in make.conf or in /etc/portage/env (or similar).
#CCACHE_DIR="/var/cache/ccache"
# If using a directory that Portage doesn't control, e.g. /var/cache/ccache,
# this may be needed in some cases, but has some security implications.
# See https://bugs.gentoo.org/492910.
#CCACHE_UMASK="0002"
# Готово! С этого момента все сборки будут пытаться повторно использовать объектные файлы из кэша.
### Включение ccache для определенных пакетов
# См. /etc/portage/package.env  - https://wiki.gentoo.org/wiki//etc/portage/package.env
# ccache.conf
# ccache будет искать свой конфигурационный файл в /etc/ccache.conf , а также в ${CCACHE_DIR}/ccache.conf .
# Пример конфигурации: /etc/ccache.conf
# Maximum cache size to maintain
#max_size = 50.0G
# Allow others to run 'ebuild' and share the cache.
#umask = 002
# Don't include the current directory when calculating
# hashes for the cache. This allows re-use of the cache
# across different package versions, at the cost of
# slightly incorrect paths in debugging info.
# https://ccache.dev/manual/4.4.html#_performance
#hash_dir = false
# Preserve cache across GCC rebuilds and
# introspect GCC changes through GCC wrapper.
#
# We use -dumpversion here instead of -v,
# see https://bugs.gentoo.org/872971.
#compiler_check = %compiler% -dumpversion
# Logging setup is optional
# Portage runs various phases as different users
# so beware of setting a log_file path here: the file
# should already exist and be writable by at least
# root and portage. If a log_file path is set, don't
# forget to set up log rotation!
# log_file = /var/log/ccache.log
# Alternatively, log to syslog
# log_file = syslog
### Сжатие: ccache может сжимать своё содержимое. Чтобы включить и настроить уровень сжатия zstd , отредактируйте ccache.conf : /etc/ccache.conf
#compression = true
#compression_level = 1
### Страница руководства для dev-util/ccache(см. man ccache ) — отличный источник различных настроек, позволяющих сделать кэширование более надежным и агрессивным.
### ccache также можно включить для текущего пользователя и повторно использовать тот же каталог кэша:
# ~/.bashrc
#export PATH="/usr/lib/ccache/bin${PATH:+:}${PATH}"
#export CCACHE_DIR="/var/tmp/ccache"
### Некоторые переменные:
# Переменная CCACHE_DIR указывает на корневой каталог кэша.
# Переменная CCACHE_RECACHE позволяет заменять старые записи кэша новыми
### Чтобы удалить все кэши:
#CCACHE_DIR=/var/tmp/ccache/ ccache -C
# Дополнительные команды смотрите в man ccache .
### Установить максимальный размер кэша
# Значение по умолчанию — 5 гигабайт, однако можно использовать меньшее или даже большее значение:
# ccache --set-config=max_size=2.0G
### Включить с помощью colorgcc
# Поскольку colorgcc также является оболочкой компилятора, необходимо соблюдать осторожность, чтобы гарантировать, что каждая оболочка вызывается в правильной последовательности.
# export PATH="/usr/lib/colorgcc/bin/:$PATH" # Как и при обычной установке colorgcc, оставьте без изменений (не добавляйте ccache )
# export CCACHE_PATH="/usr/bin" # Указывает ccache использовать здесь только компиляторы
### Затем нужно указать colorgcc вызывать ccache вместо настоящего компилятора. Отредактируйте /etc/colorgcc/colorgccrcи измените /usr/binпути ко /usr/lib/ccache/binвсем компиляторам в /usr/lib/ccache/bin:
# /etc/colorgcc/colorgccrc
# g++: /usr/lib/cache/bin/g++
# gcc: /usr/lib/ccache/bin/gcc
# c++: /usr/lib/cache/bin/g++
# c: /usr/lib/cache/bin/cc
# g77:/usr/bin/g77
# f77:/usr/bin/g77
# gcj:/usr/bin/gcj
# В новых версиях ccache поддержка цвета для GCC всегда включена, если GCC_COLORSустановлено значение . Для Clang поддержка цвета включена по умолчанию. Если вывод не является TTY, ccache попросит компилятор сгенерировать цвет, сохраняя его в кэше, но удаляя из вывода. Остаётся проблема с унификацией -fdiagnostics-color (https://github.com/ccache/ccache/issues/224).
###########################################################

clear
echo -e "${MAGENTA}
  <<< Установка утилит (пакетов), запуск полезных служб и демонов в Archlinux >>> ${NC}"
# Installing utilities (packages), launching useful services and daemons in Archlinux
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Nohang (nohang) и (nohang-git) - Предотвращает переполнение оперативной памяти (OOM) в Linux?"
echo -e "${YELLOW}==> Внимание! ${BOLD} *Условия OOM могут приводить к зависаниям , динамическим блокировкам , сбросу кэшей и завершению процессов (с помощью SIGKILL ) вместо попытки их корректного завершения (с помощью SIGTERM или других корректирующих действий). Некоторые приложения могут аварийно завершаться, если невозможно выделить память. В борьбе с явлением OOM нам поможет Nohang — демон для GNU/Linux, предотвращающий наступление явления переполнения оперативной памяти устройства путём принудительного завершения «прожорливого» процесса. Данный проект лицензирован в соответствии с условиями лицензии MIT (https://github.com/hakavlad/nohang/blob/master/LICENSE). ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Nohang — это демон повышающий производительность путём обработки и слежки за потреблением памяти. Настраиваемый демон для Linux, который способен корректно предотвращать нехватку памяти (OOM) и поддерживать отзывчивость системы в условиях нехватки памяти. Принцип работы: Nohang в виде демона постоянно находится в оперативной памяти устройства (потребляет ~10 Мб ОЗУ) и следит за свободным количеством оперативной памяти и своп-раздела. Как только наступает условие явной нехватки ОЗУ и свопа (эти параметры указываются в конфигурационном файле приложения) Nohang принудительно завершает «жирное» приложение, вызвавшее нехватку оперативной памяти устройства. Все параметры Nohang настраиваются в конфигурационном файле: /etc/nohang/nohang.conf . В принципе, всё можно оставить как есть, параметры по-умолчанию там оптимальны для любой конфигурации железа. ${NC}"
echo " Домашняя страница: https://github.com/hakavlad/nohang ; (https://aur.archlinux.org/packages/nohang ; https://aur.archlinux.org/packages/nohang-git). Документацию от автора можно посмотреть тут: GitHub - https://github.com/hakavlad/nohang "
echo -e "${BLUE}:: ${NC}Пакет так же включает в себя oom-sort, psi2log, psi-top . Сортировка по OOM: oom-sort— это дополнительный инструмент диагностики, который будет установлен вместе с nohang пакетом. Он сортирует процессы в порядке убывания их значений oom_score, а также отображает oom_score_adj, Uid, Pid, Name, и, при необходимости VmRSS, . Для получения дополнительной информации выполните команду . Страница руководства: oom-sort.manpage.md (https://github.com/hakavlad/nohang/blob/master/docs/oom-sort.manpage.md). VmSwapcmdlineoom-sort --help . Использование: oom-sort - Пример вывода: Kthreads, zombies и Pid 1 отображаться не будут. psi-top — это скрипт, который выводит значения метрик PSI для каждой контрольной группы. Требуется Linuxверсия 4.20 и выше CONFIG_PSI=y. Страница руководства: psi-top.manpage.md (https://github.com/hakavlad/nohang/blob/master/docs/psi-top.manpage.md). Использование: psi-top - Пример вывода: cgroup2 mountpoint: /sys/fs/cgroup ...... psi2log — это инструмент командной строки, который может проверять и регистрировать показатели PSI для указанного целевого объекта. Требуется Linuxверсия 4.20 и выше CONFIG_PSI=y. Страница руководства: psi2log.manpage.md (https://github.com/hakavlad/nohang/blob/master/docs/psi2log.manpage.md). Использование: psi2log - Пример вывода: Starting psi2log ; target: SYSTEM_WIDE ; period: 2 .......  "
echo -e "${YELLOW}==> Предупреждения! ${BOLD} *Демон работает с привилегиями суперпользователя и имеет полный доступ ко всей частной памяти всех процессов и конфиденциальным данным пользователя ; демон не запрещает вам выстрелить себе в ногу: при некоторых настройках могут происходить нежелательные убийства процессов ; Демон не является панацеей: не существует универсальных настроек, надежно защищающих от всех типов угроз. ${NC}"
echo -e "${CYAN}:: ${NC}Установка Nohang (nohang) и (nohang-git), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/nohang.git), (https://aur.archlinux.org/nohang-git.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo " Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить Nohang (nohang),     2 - *Да установить Nohang (nohang-git),

    0 - НЕТ - Пропустить установку: " in_nohang  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_nohang" =~ [^120] ]]
do
    :
done
if [[ $in_nohang == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "


elif [[ $in_nohang == 1 ]]; then
  echo ""
  echo " Установка Nohang (nohang) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
############### Зависимости ###############
sudo pacman -S --noconfirm --needed python  # Язык программирования Python ; https://archlinux.org/packages/core/x86_64/python/ ; https://www.python.org/ ; Обеспечивает: python-externally-managed, python3 ; Заменяет: python-externally-managed, python3 ; 2025-06-23 18:22 UTC
sudo pacman -S --noconfirm --needed systemd  # Системный и сервисный менеджер ; https://archlinux.org/packages/core/x86_64/systemd/ ; https://www.github.com/systemd/systemd ; Обеспечивает: nss-myhostname, systemd-tools=257.7, udev=257.7 ; Заменяет: nss-myhostname, systemd-tools, udev ; Конфликты: с nss-myhostname, systemd-tools, udev ; 29 июля 2025 г. 17:21 UTC
sudo pacman -S --noconfirm --needed git  # Быстро распределенная система контроля версий ; https://archlinux.org/packages/extra/x86_64/git/ ; https://git-scm.com/ ; 2025-07-14 10:22 UTC
sudo pacman -S --noconfirm --needed libnotify  # Библиотека для отправки уведомлений на рабочий стол ; https://archlinux.org/packages/extra/x86_64/libnotify/ ; https://gitlab.gnome.org/GNOME/libnotify ; Обеспечивает: libnotify.so=4-64 ; 2025-03-29 00:39 UTC
sudo pacman -S --noconfirm --needed logrotate  # Автоматически ротирует системные журналы ; https://archlinux.org/packages/core/x86_64/logrotate/ ; https://github.com/logrotate/logrotate ; 2024-07-19 07:12 UTC
sudo pacman -S --noconfirm --needed sudo  # Предоставить определенным пользователям возможность запускать некоторые команды от имени root ; https://archlinux.org/packages/core/x86_64/sudo/ ; https://www.sudo.ws/sudo/ ; 2025-06-30 22:05 UTC
# sudo pacman -S --noconfirm --needed
######### nohang ###########
yay -S nohang --noconfirm  # Сложный обработчик нехватки памяти ; https://aur.archlinux.org/packages/nohang ; https://aur.archlinux.org/nohang.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/hakavlad/nohang ; 2022-07-25 02:59 (UTC)
######### nohang ###########
#git clone https://aur.archlinux.org/nohang.git    # (только для чтения, нажмите, чтобы скопировать) # Скачивание исходников.
#cd nohang                                      # Переход в nohang-git
# makepkg -sric                                       # Сборка и установка.
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf nohang
#rm -Rf nohang
  echo ""
  echo " Включаем службу Nohang (nohang-desktop) "
sudo systemctl enable --now nohang-desktop   # Включаем службу.
#  echo ""
#  echo " Проверяем состояние демона Nohang (статуса запуска nohang.service) "
# sudo systemctl status nohang.service   # Проверка статуса запуска nohang.service ; Статус работы должен быть указан зелёным цветом
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_nohang == 2 ]]; then
  echo ""
  echo " Установка Nohang (nohang-git) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
############### Зависимости ###############
sudo pacman -S --noconfirm --needed python  # Язык программирования Python ; https://archlinux.org/packages/core/x86_64/python/ ; https://www.python.org/ ; Обеспечивает: python-externally-managed, python3 ; Заменяет: python-externally-managed, python3 ; 2025-06-23 18:22 UTC
sudo pacman -S --noconfirm --needed systemd  # Системный и сервисный менеджер ; https://archlinux.org/packages/core/x86_64/systemd/ ; https://www.github.com/systemd/systemd ; Обеспечивает: nss-myhostname, systemd-tools=257.7, udev=257.7 ; Заменяет: nss-myhostname, systemd-tools, udev ; Конфликты: с nss-myhostname, systemd-tools, udev ; 29 июля 2025 г. 17:21 UTC
sudo pacman -S --noconfirm --needed git  # Быстро распределенная система контроля версий ; https://archlinux.org/packages/extra/x86_64/git/ ; https://git-scm.com/ ; 2025-07-14 10:22 UTC
sudo pacman -S --noconfirm --needed libnotify  # Библиотека для отправки уведомлений на рабочий стол ; https://archlinux.org/packages/extra/x86_64/libnotify/ ; https://gitlab.gnome.org/GNOME/libnotify ; Обеспечивает: libnotify.so=4-64 ; 2025-03-29 00:39 UTC
sudo pacman -S --noconfirm --needed logrotate  # Автоматически ротирует системные журналы ; https://archlinux.org/packages/core/x86_64/logrotate/ ; https://github.com/logrotate/logrotate ; 2024-07-19 07:12 UTC
sudo pacman -S --noconfirm --needed sudo  # Предоставить определенным пользователям возможность запускать некоторые команды от имени root ; https://archlinux.org/packages/core/x86_64/sudo/ ; https://www.sudo.ws/sudo/ ; 2025-06-30 22:05 UTC
# sudo pacman -S --noconfirm --needed
######### nohang-git ###########
yay -S nohang-git --noconfirm  # Сложный обработчик нехватки памяти ; https://aur.archlinux.org/packages/nohang-git ; https://aur.archlinux.org/nohang-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/hakavlad/nohang ; Конфликты: с nohang ; Обеспечивает: nohang ; пожалуйста, используйте sudo pacdiffдля миграции конфигурации ; 2021-06-12 04:35 (UTC)
######### nohang-git ###########
#git clone https://aur.archlinux.org/nohang-git.git    # (только для чтения, нажмите, чтобы скопировать) # Скачивание исходников.
#cd nohang-git                                       # Переход в nohang-git
# makepkg -sric                                       # Сборка и установка.
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf nohang-git
#rm -Rf nohang-git
  echo ""
  echo " Включаем службу Nohang (nohang-desktop) "
sudo systemctl enable --now nohang-desktop   # Включаем службу.
#  echo ""
#  echo " Проверяем состояние демона Nohang (статуса запуска nohang.service) "
# sudo systemctl status nohang.service   # Проверка статуса запуска nohang.service ; Статус работы должен быть указан зелёным цветом
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########### Справка по настройке ###############
# Настройка:
# Все параметры Nohang настраиваются в конфигурационном файле: /etc/nohang/nohang.conf
# В принципе, всё можно оставить как есть, параметры по-умолчанию там оптимальны для любой конфигурации железа.
# Включение оповещений на рабочем столе:
# Чтобы включить всплывающие оповещения о нехватке ОЗУ и завершении приложений Nohang, нужно в конфигурационном файле: /etc/nohang/nohang.conf изменить следующие параметры на значение «True» чтобы получилось вот так:
# post_action_gui_notifications = True
# low_memory_warnings_enabled = True
# После чего сохранить изменения в конфигурационном файле и перезапустить Nohang для применения новой конфигурации:
# sudo systemctl restart nohang.service
# Проверяем состояние демона Nohang:
# sudo systemctl status nohang.service
# Статус работы должен быть указан зелёным цветом:
# Active: active (running)
# Если так — Nohang запущен и работает нормально, можно приступать к экспериментам.
# Сохраняем все несохранённые данные во всех приложениях, делаем резервные копии важных данных!
# Как проверить nohang:
# Самый безопасный способ — запустить nohang --memload. Это приводит к увеличению потребления памяти, и процесс завершится до возникновения OOM.
# Самый безопасный способ — запустить: nohang --memload
# Другой способ — запустить tail /dev/zero.
# Это я на всякий случай 😏 Что ж, инициируем процесс накачки оперативной памяти пустыми данными:
# tail /dev/zero
# Это приводит к быстрому потреблению памяти и появлению OOM в конце.
# Если тестирование происходит во время nohang работы, эти процессы следует завершить до возникновения OOM.
# И смотрим что из этого получится. По идее, вы можете почувтвовать непродолжительный дискомфорт, проявляющийся в зависании системы на несколько секунд, после чего Nohang должен отработать по tail и управление системы вернётся в ваши руки. А точнее, скорее всего так и произойдёт, что можно будет считать успешным достижением поставленной цели.
# Ведение журнала:
# Чтобы просмотреть последние записи в журнале (для пользователей systemd):
# sudo journalctl -eu nohang.service
#### or
# sudo journalctl -eu nohang-desktop.service
# Вы также можете включить separate_log в конфигурации возможность входа в систему /var/log/nohang/nohang.log.
# Состояние задач:
# Запустите sudo nohang -c/--config CONFIG --tasks, чтобы увидеть таблицу процессов с их значениями плохости, oom_scores, именами, UID и т. д.
##################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Earlyoom (earlyoom) - Быстрый кэш компилятора C/C++?"
echo -e "${YELLOW}==> Внимание! ${BOLD} *У OOM-киллера, как правило, дурная репутация среди пользователей Linux. Иногда приходится сидеть перед зависшей системой, слушая скрежет диска, несколько минут, а потом нажимать кнопку сброса, чтобы быстро вернуться к работе, когда терпение истощится. Если вы работаете с «тяжелыми» приложениями в условиях нехватки оперативной памяти, вам знакома такая ситуация, как OOM — Out Of Memory, это когда запущенным программам нужно больше оперативной памяти, чем имеется в системе. В такой ситуации система обычно начинает свапиться на диск и при этом тормозить, что неприятно для пользователя. Так вот Earlyoom делает всё то же самое, ну кроме отображения уведомлений, но в то же время менее требовательна к конфигурации компьютера. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Earlyoom (Early OOM Daemon) - это работающая в фоновом режиме CНИОКР консольная утилита позволяющая настроить экстренное завершение процесса, потребляющего больше всего памяти в системе. Утилита разработана как работающая в пространстве пользователя альтернатива Linux Out-of-Memory Killer (OOM Killer). earlyoom стремится быть простым и надёжным. Он написан на чистом C без зависимостей. Обширный набор тестов (модульные и интеграционные) написан на Go. ${NC}"
echo " Домашняя страница: https://github.com/rfjakob/earlyoom ; (https://archlinux.org/packages/extra/x86_64/earlyoom/). "
echo -e "${BLUE}:: ${NC}Принцип работы: Earlyoom автоматически завершает программу, если она приводит к исчерпыванию всей свободной ОЗУ в системе, предотвращая ситуацию нехватки оперативной памяти — OOM. Условия срабатывания такие: sending SIGTERM when mem <= 10.00% and swap <= 10.00%, SIGKILL when mem <=  5.00% and swap <=  5.00%  . Earlyoom проверяет объём доступной памяти и свободного пространства подкачки до 10 раз в секунду (реже, если свободной памяти много). Если и память , и пространство подкачки (если есть) меньше 10%, он завершает самый большой процесс (с наибольшим значением oom_score ). Процентные значения настраиваются с помощью аргументов командной строки. Если при попытке завершить процесс происходит сбой, earlyoom переходит в спящий режим на 1 секунду, чтобы ограничить количество сообщений в журнале, содержащих повторяющиеся ошибки. "
echo -e "${CYAN}:: ${NC}В приведенном free -m ниже выводе доступная память составляет 2170 МБ, а свободный раздел подкачки — 231 МБ. Почему проверяется «доступная» память, а не «свободная»? В исправной системе Linux «свободная» память должна быть близка к нулю, поскольку Linux использует всю доступную физическую память для кэширования доступа к диску. Эти кэши можно удалить в любой момент, когда память понадобится для чего-то другого. «Доступная» память учитывает это. Она суммирует всю память, которая не используется или может быть немедленно освобождена. Обратите внимание, что для отображения столбца «доступно» требуется последняя версия freeи ядро Linux версии 3.14+. Если у вас последнее ядро, но старая версия free, вы можете получить значение из grep MemAvailable /proc/meminfo. Когда объем доступной памяти и свободного пространства подкачки опускается ниже 10% от общего объема памяти, доступной процессам пользовательского пространства (=total-shared), будет отправлен SIGTERM сигнал процессу, который, по мнению ядра, использует больше всего памяти ( /proc/*/oom_score). "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_earlyoom  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_earlyoom" =~ [^10] ]]
do
    :
done
if [[ $in_earlyoom == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_earlyoom == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Earlyoom (earlyoom) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
sudo pacman -S --noconfirm --needed systembus-notify  # (необязательно) — уведомления на рабочем столе ; Демон уведомлений системной шины ; https://archlinux.org/packages/extra/x86_64/systembus-notify/ ; https://github.com/rfjakob/systembus-notify ; 2023-10-06 17:16 UTC
### Миниатюрный демон, который прослушивает сигналы на системнойnet.nuetzlich.SystemNotifications.Notify шине D-Bus и отображает их в виде уведомлений на рабочем столе, используя пользовательскую шину. Работает в Linux с Gnome, Cinnamon, KDE, LXQT и т. д.
######### earlyoom ########
sudo pacman -S --noconfirm --needed earlyoom  # Ранний демон OOM для Linux ; https://archlinux.org/packages/extra/x86_64/earlyoom/ ; https://github.com/rfjakob/earlyoom ; https://man.archlinux.org/man/earlyoom.1.en ; 2024-05-13 18:03 UTC
  echo ""
  echo " Включаем Earlyoom (earlyoom) "
sudo systemctl enable --now earlyoom   # Включаем службу.
#sudo systemctl enable earlyoom.service
#sudo systemctl start earlyoom.service
#  echo ""
#  echo " Проверяем состояние демона Earlyoom (статуса запуска earlyoom) "
# sudo systemctl status earlyoom   # Проверка статуса запуска earlyoom ; Если earlyoom запущен как служба systemd, вы можете просмотреть последние 10 строк
# sudo systemctl status earlyoom.service  # Узнать статус процесса Earlyoom
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#############

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить CPUPower (cpupower) - Утилита для управления настройками управления питанием процессора (CPU)?"
echo -e "${YELLOW}==> Внимание! ${BOLD} *Все мы знаем, что на Windows есть режимы использования батареи - сбалансированный или максимальный. На линуксе такого из коробки нету, но можно установить CPUPower. По умолчанию ваш процессор динамически меняет свою частоту, что в принципе правильно и дает баланс между энергосбережением и производительностью. Но если вы все таки хотите выжать все соки, то вы можете закрепить применение режима максимальной производительности для вашего процессора. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}CPUPower - это утилита для управления настройками управления питанием процессора (CPU) в системах Linux. Она является частью подсистемы CPUFreq ядра Linux. Основные функции: Контроль частоты процессора. Утилита позволяет менять политику управления частотой (CPU Governor) и другие параметры, связанные с питанием. Отображение информации о текущей частоте, доступных частотах и текущем режиме управления. Настройка минимальных и максимальных ограничений частоты для процессора.  Информация о доступных драйверах CPUFreq и поддерживаемых функциях оборудования. ${NC}"
echo " Домашняя страница: https://www.kernel.org/ ; (https://github.com/deinstapel/cpupower ; https://archlinux.org/packages/extra/x86_64/cpupower/). "
echo -e "${BLUE}:: ${NC}Управление частотой в Linux: Для управления частотой в операционной системе Linux используются политики CPU Governor. Они определяют как быстро будет изменятся частота при изменении нагрузки. Существует четыре политики: powersave - процессор работает на минимальной частоте ; performance - процессор работает на максимальной частоте ; ondemand - динамическое изменение частоты, при появлении нагрузки резко устанавливается самая высокая частота, а при снижении нагрузки частота медленно снижается ; conservative - аналогично ondemand, только частота меняется более плавно ; userspace - использовать частоту заданную пользователем ; schedutil - изменение частоты на основе планировщика. Самый выгодный в данном случае режим - это ondemand, частота повышается при необходимости и опускается если она не нужна.  "
echo -e "${CYAN}:: ${NC}Некоторые примеры команд с cpupower: Проверка текущих настроек частоты: cpupower frequency-info . Установка политики powersave для всех процессоров: sudo cpupower --cpu all frequency-set --governor powersave . Вывод частоты процессора 4 с оборудования в человекочитаемом формате: sudo cpupower --cpu 4 frequency-info --hwfreq --human . "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_cpupower  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_cpupower" =~ [^10] ]]
do
    :
done
if [[ $in_cpupower == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_cpupower == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) CPUPower (cpupower) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
sudo pacman -S --noconfirm --needed cpupower  # Инструмент ядра Linux для проверки и настройки функций энергосбережения вашего процессора (менеджер управления частотой процессора) ; https://archlinux.org/packages/extra/x86_64/cpupower/ ; https://www.kernel.org/ ; https://github.com/deinstapel/cpupower ; Заменяет: cpufrequtils ; Конфликты: с cpufrequtils ; 29 июля 2025 г. 06:49 UTC
  echo ""
  echo " Ппосмотрите информацию о версии CPUPower (cpupower) "
cpupower --version
sleep 03
  echo ""
  echo " Выставляем параметры управления частотой производительностью (частотой работы процессора) до перезагрузки системы "
  echo " Для управления частотой в операционной системе Linux используются политики CPU Governor "
  echo " Они определяют как быстро будет изменятся частота при изменении нагрузки "
  echo " Самый выгодный в данном случае режим - это ondemand, частота повышается при необходимости и опускается если она не нужна "
  echo " После в файле /etc/default/cpupower строку governor= исправьте на governor=performance "
# sudo cpupower frequency-set -g powersave  # процессор работает на минимальной частоте
sudo cpupower frequency-set -g performance  # процессор работает на максимальной частоте
#sudo cpupower frequency-set -g ondemand  # динамическое изменение частоты, при появлении нагрузки резко устанавливается самая высокая частота, а при снижении нагрузки частота медленно снижается
#sudo cpupower frequency-set -g conservative  # аналогично ondemand, только частота меняется более плавно
# sudo cpupower frequency-set -g userspace  # использовать частоту заданную пользователем
# sudo cpupower frequency-set -g schedutil  # изменение частоты на основе планировщика
  echo ""
  echo " Ппосмотрите информацию о процессоре "
  echo " Эта команда отображает текущую частоту процессора, параметры регулятора и другую информацию. Если регулятор установлен в положение 'powersave' или 'ondemand', то процессор находится в режиме энергосбережения. "
cpupower frequency-info  # посмотрите информацию о процессоре
cpupower frequency-info | grep driver  # Это будет выглядеть примерно так: driver: intel_pstate ;
cpupower -c 0 frequency-info
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor  # Проверьте режим работы процессора вручную - Эта команда отображает текущую частоту процессора для каждого ядра
sleep 07
  echo ""
  echo " Включаем CPUPower (cpupower) сервис в автозапуск "
sudo systemctl enable cpupower  # Включаем службу.
sudo systemctl enable cpupower.service
sudo systemctl start cpupower
#  echo ""
#  echo " Проверяем состояние демона Earlyoom (статуса запуска earlyoom) "
# sudo systemctl status cpupower   # Проверка статуса запуска cpupower
# sudo systemctl status cpupower.service  # Узнать статус процесса Earlyoom
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# Проверка текущих настроек:
# cpupower frequency-info
# Эта команда отображает текущую частоту процессора, параметры регулятора и другую информацию. Если регулятор установлен в положение 'powersave' или 'ondemand', то процессор находится в режиме энергосбережения.
# Отключение режима энергосбережения:
# Если необходимо отключить режим энергосбережения, можно установить регулятор в положение performance. Это заставит процессор работать на максимальной частоте.
# cpupower frequency-set -g performance
# Эта настройка будет потеряна после перезагрузки. Если вы хотите сделать ее постоянной, то можете добавить приведенную выше команду в /etc/rc.local файл, чтобы он выполнялся при каждой загрузке.
# Проверьте режим работы процессора вручную
# cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
# Эта команда отображает текущую частоту процессора для каждого ядра.
# Информация о текущей частоте процессора доступна в разделе /proc/cpuinfo файл
########################








cpupower-gui

cpupower-gui-git AUR — это графическая утилита, предназначенная для масштабирования частоты процессора. Графический интерфейс основан на GTK и предоставляет те же возможности, что и cpupower . cpupower-gui может включать и отключать ядра, а также изменять максимальную/минимальную частоту процессора и регулятор частоты для каждого ядра. Приложение управляет предоставлением привилегий через polkit и позволяет любому вошедшему в систему пользователю изwheel группы изменять частоту и регулятор частоты. Подробнее о модулях systemd cpupower-gui.service и cpupower-gui-user.service.
https://github.com/vagnum08/cpupower-gui?tab=readme-ov-file#systemd-units






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
sleep 03
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
# Mousepad имеет клиентские декорации с версии 0.5.5. Эту "функцию" можно отключить с помощью dconf, просто откройте терминал и введите (или скопируйте/вставьте):
# dconf write /org/xfce/mousepad/preferences/window/client-side-decorations false
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