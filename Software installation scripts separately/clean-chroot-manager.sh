#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! ####
apptitle="Arch Linux Fast Install v2.5 LegasyBIOS - Version: 2027.07.31.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя
###
clean-chroot-managerL_LANG="russian"  # Installer default language (Язык установки по умолчанию)
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
echo -e "${GREEN}==> ${NC}Установить дополнительные базовые утилиты (пакеты) wget, curl, git?"
#echo -e "${BLUE}:: ${NC}Установить дополнительные базовые утилиты (пакеты) wget, curl, git"
#echo "Установить дополнительные базовые утилиты (пакеты) wget, curl, git"
# Install additional basic utilities (packages) wget, curl, fit
echo -e "${YELLOW}==> Примечание: ${BOLD}Вы можете пропустить установку этих утилит (пакетов), если таковые были ранее вами установлены и присутствуют в систему Arch'a. Установка утилит (пакетов) проходит из 'Официальных репозиториев Arch Linux' ${NC}"
echo -e "${MAGENTA}=> ${NC}Описание утилит (пакетов) для установки:"
echo " 1 - GNU Wget (wget) - это бесплатный программный пакет для получения файлов с использованием HTTP , HTTPS, FTP и FTPS (FTPS с версии 1.18). Это неинтерактивный инструмент командной строки, поэтому его можно легко вызвать из скриптов. "
echo " 2 - cURL (curl) - это инструмент командной строки и библиотека для передачи данных с помощью URL-адресов. Команда поддерживает ряд различных протоколов, включая HTTP, HTTPS, FTP, SCP и SFTP. Он также предназначен для работы без взаимодействия с пользователем, как в сценариях. "
echo " 3 - Git (git) - это система контроля версий (VCS), разработанная Линусом Торвальдсом, создателем ядра Linux. Git теперь используется для поддержки пакетов AUR, а также многих других проектов, включая исходные коды ядра Linux. "
echo -e "${CYAN}=> Отрывок (цитирование): ${NC}'Я встречал людей, которые думали, что git - это интерфейс для GitHub. Они ошибались, git - это интерфейс для AUR'. - Линус Т :)"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить действие: " basic_utilities  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$basic_utilities" =~ [^10] ]]
do
    :
done
if [[ $basic_utilities == 0 ]]; then
echo ""
echo " Установка базовых утилит (пакетов) пропущена "
elif [[ $basic_utilities == 1 ]]; then
  echo ""
  echo " Установка базовых утилит (пакетов) wget, curl, git "
# sudo pacman -S --needed base-devel git wget #curl  - пока присутствует в pkglist.x86_64
sudo pacman -S --noconfirm --needed wget curl git
# sudo pacman -S wget git --noconfirm  #curl  - пока присутствует в pkglist.x86_64
# sudo pacman -S wget --noconfirm  # Сетевая утилита для извлечения файлов из Интернета
# sudo pacman -S curl --noconfirm  # Утилита и библиотека для поиска URL
# sudo pacman -S git --noconfirm  # Быстрая распределенная система контроля версий
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########## Справка по pacman: #############
# --needed         не переустанавливать актуальные пакеты
# --noconfirm      не спрашивать каких-либо подтверждений
########## Информация #############
# https://git-scm.com/
# https://archlinux.org/packages/extra/x86_64/git/
# https://www.gnu.org/software/wget/wget.html
# https://archlinux.org/packages/extra/x86_64/wget/
# https://curl.se/
# https://archlinux.org/packages/core/x86_64/curl/
############################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить CCM (clean-chroot-manager) - Оболочка для управления чистыми сборками chroot в Archlinux?"
echo -e "${MAGENTA}:: ${BOLD}CCM (clean-chroot-manager) — это Скрипт-оболочка для управления chroot-окружениями при сборке пакетов под Arch Linux. Ccm обеспечивает ряд преимуществ по сравнению со стандартными скриптами Arch-Build: Автоматически управляет локальным репозиторием, благодаря чему зависимости, которые вы создаете, прозрачно извлекаются из этого локального репозитория. Автоматически настраивает и использует distcc для ускорения компиляции (если включено). Управление локальным репозиторием полезно при сборке пакета с зависимостью, которую также необходимо собрать (т.е. такой, которая недоступна в репозиториях Arch). Ещё одно важное отличие заключается в том, что ccm может собирать пакеты с помощью distcc. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Использование помощника AUR, такого как yay, для сборки пакетов, включая backintime, КРАЙНЕ не рекомендуется. Рекомендуемый метод сборки — использовать чистый chroot. Смотреть (читать): https://wiki.archlinux.org/title/DeveloperWiki : Building_in_a_clean_chroot .. ${NC}"
echo " Домашняя страница: https://github.com/graysky2/clean-chroot-manager ; (https://aur.archlinux.org/packages/clean-chroot-manager) "
echo -e "${MAGENTA}:: ${BOLD}Пример: Предположим, что мы хотим собрать «bar» из AUR. У «Bar» есть зависимость сборки от «foo», которая также есть в AUR. Вместо того, чтобы сначала собрать «foo», затем установить «foo», затем собрать «bar» и, наконец, удалить «foo», локальный репозиторий сохранит копию foo.pkg.tar.xz, которая автоматически проиндексируется. Pacman в chroot-окружении знает о пакете «foo» благодаря локальному репозиторию. Поэтому, когда пользователь попытается собрать «bar», pacman автоматически скачает foo.pkg.tar.xz из локального репозитория, как и любую другую зависимость. ${NC}"
echo -e "${YELLOW}:: ${NC}Настройка: $XDG_CONFIG_HOME/clean-chroot-manager.conf - Будет создан при первом запуске ccm и будет содержать все настройки, управляемые пользователем. Отредактируйте этот файл перед повторным запуском ccm. Убедитесь, что у пользователя, запускающего ccm, есть права sudo для выполнения /usr/bin/clean-chroot-manager или /usr/bin/ccm . Параметры команд будут прописаны в сценарии (скрипта), в справке, но будут закомментированы # . "
echo " Советы: Поскольку ccm требует прав sudo, рассмотрите возможность создания псевдонима для его вызова в файле ~/.bashrc или аналогичном файле. Например: alias ccm='sudo ccm' . Если в вашей локальной сети несколько компьютеров, попросите их помочь вам с компиляцией через distcc, который поддерживается в CCM. $XDG_CONFIG_HOME/clean-chroot-manager.conf - Инструкции по настройке см. здесь (https://github.com/graysky2/clean-chroot-manager). "
echo -e "${YELLOW}==> Примечание! ${NC}Обязательно прочтите - Зачем это использовать? (https://github.com/graysky2/clean-chroot-manager). "
echo -e "${CYAN}:: ${NC}Установка CCM (clean-chroot-manager), проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/clean-chroot-manager.git), (https://aur.archlinux.org/packages/clean-chroot-manager) - собирается и устанавливается. "
echo " Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить CCM (clean-chroot-manager),    0 - НЕТ - Пропустить установку: " in_cleanchroot  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_cleanchroot" =~ [^10] ]]
do
    :
done
if [[ $in_cleanchroot == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_cleanchroot == 1 ]]; then
  echo ""
  echo " Установка CCM (clean-chroot-manager) "
pacman -Syy  # обновление баз пакмэна (pacman)
# pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########## Зависимости ###########
pacman -S --noconfirm --needed bc  # Язык калькулятора произвольной точности ; https://archlinux.org/packages/extra/x86_64/bc/ ; https://www.gnu.org/software/bc/ ; 2025-05-27 01:22 UTC
pacman -S --noconfirm --needed devtools  # Инструменты для сопровождающих пакетов Arch Linux ; https://archlinux.org/packages/extra/any/devtools/ ; https://gitlab.archlinux.org/archlinux/devtools ; 2025-03-05 20:33 UTC
pacman -S --noconfirm --needed libarchive  # Многоформатная библиотека архивации и сжатия ; https://archlinux.org/packages/core/x86_64/libarchive/ ; https://libarchive.org/ ; 2025-06-02 14:16 UTC
pacman -S --noconfirm --needed pacman  # Менеджер пакетов на основе библиотеки с поддержкой зависимостей ; https://archlinux.org/packages/core/x86_64/pacman/ ; https://www.archlinux.org/pacman/ ; Обеспечивает: libalpm.so=15-64 ; 2025-06-06 14:07 UTC
pacman -S --noconfirm --needed rsync  # Быстрый и универсальный инструмент для копирования удаленных и локальных файлов ; https://archlinux.org/packages/extra/x86_64/rsync/ ; https://rsync.samba.org/ ; 2025-02-03 13:57 UTC
### clean-chroot-manager  # Оболочка для управления чистыми сборками chroot с локальным репозиторием
########## clean-chroot-manager ###########
# sudo pamac build clean-chroot-manager  # Установка через пакмэна (pacman)
# Я написал скрипт, который автоматизирует большую часть того, что называется clean-chroot-manager (https://aur.archlinux.org/packages/clean-chroot-manager) , и предлагается здесь, в AUR.
# yay -S clean-chroot-manager --noconfirm  # Оболочка для управления чистыми сборками chroot с локальным репозиторием ; https://aur.archlinux.org/clean-chroot-manager.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/graysky2/clean-chroot-manager ; https://aur.archlinux.org/packages/clean-chroot-manager ; https://github.com/graysky2/clean-chroot-manager/archive/v2.227.tar.gz ; 2025-06-19 19:37 (UTC)
########## clean-chroot-manager ###########
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
  echo ""
  echo " Установка CCM (clean-chroot-manager) завершена "
fi
############## Справка #############
# Параметры и Команды (Command Description):
# a - Добавить пакеты из текущего каталога в локальный репозиторий. (Add packages in current dir to the local repo.)
# c - Создайте chroot. (Create the chroot.)
# cd - Создайте chroot с включенным distcc (если вы не хотите настраивать это в файле конфигурации). (Create the chroot with distcc enabled (if you do not want to set up in the config file)).
# cp - Очистить все файлы в CCACHE_DIR (необязательно при сборке с помощью ccache). (Purge all files in the CCACHE_DIR (optional if building with ccache)).
# d - Удалите все пакеты в локальном репозитории, не уничтожая при этом всю сборку (т. е. пакеты, которые вы собрали на данный момент). (Delete all packages in the local repo without nuking the entire build (i.e. the packages you built to date)).
# l - Перечислите содержимое локального репозитория (т.е. пакеты, которые вы собрали на данный момент). (List the contents of the local repo (i.e. the packages you built to date)).
# N - Удалите chroot и внешний репозиторий (если он определен). (Nuke the chroot and the external repo (if defined)).
# n - Удалите chroot (и все, что под ним находится). (Nuke the chroot (delete it and everything under it)).
# p - Настройки предварительного просмотра. Показывает некоторые сведения о самом chroot. (Preview settings. Show some bits about the chroot itself.)
# R - Переупаковать текущий пакет, если он собран. Эквивалент makepkg -sR в chroot. (Repackage the current package if built. The equivalent of makepkg -sR in the chroot.)
# s - Запустите makepkg в режиме сборки в chroot-окружении. Эквивалент makepkg -s в chroot-окружении. (Run makepkg in build mode under the chroot. The equivalent of makepkg -s in the chroot.)
# S - Запустите makepkg в режиме сборки в chroot-окружении без предварительной очистки. Это полезно для пересборки без загрязнения исходного chroot-окружения или при сборке пакетов с большим количеством одинаковых зависимостей. (Run makepkg in build mode under the chroot without first cleaning it. Useful for rebuilds without dirtying the pristine chroot or when building packages with many of the same deps.)
# t - Включите/выключите [core-testing]/[extra-testing] в chroot и обновите пакеты соответствующим образом (повысьте или понизьте версию). (Toggle [core-testing]/[extra-testing] on/off in the chroot and update packages accordingly (upgrade or downgrade)).
# u - Обновить пакеты внутри chroot. Эквивалент pacman -Syuв chroot. (Update the packages inside the chroot. The equivalent of pacman -Syu in the chroot.)
### Пример использования ()
# Создайте gcchroot по пути, указанному в вышеупомянутом файле конфигурации:
# $ sudo ccm c
# Попытайтесь собрать пакет в gcchroot. В случае успеха пакет будет добавлен в локальный репозиторий и станет доступен для использования в качестве зависимости при сборке других пакетов:
#  $ cd /path/to/PKGBUILD
#  $ sudo ccm s
# Выведите список содержимого локального репозитория chroot, предполагая, что что-то было собрано. Полезно посмотреть, что там есть:
# $ sudo ccm l
# Удаляет все, что находится под верхним уровнем chroot, фактически удаляя его из системы:
# $ sudo ccm n
### Советы:
# Поскольку ccm требует прав sudo, рассмотрите возможность создания псевдонима для его вызова в файле ~/.bashrc или аналогичном файле. Например:
# alias ccm='sudo ccm'
# Если в вашей локальной сети несколько компьютеров, попросите их помочь вам с компиляцией через distcc, который поддерживается в CCM. $XDG_CONFIG_HOME/clean-chroot-manager.confИнструкции по настройке см. здесь.
# Если на вашем компьютере большой объём памяти, рассмотрите возможность размещения chroot-окружения в tmpfs, чтобы избежать использования диска и минимизировать время доступа. Один из способов — просто указать каталог для монтирования как tmpfs, например /etc/fstab:
# tmpfs /scratch tmpfs nodev,size=20G 0 0
# Чтобы CHROOTPATH создать ожидаемый каталог, мы можем использовать системный временный файл (tmpfile) следующим образом:
# /etc/tmpfiles.d/ccm_dirs.conf
# d /scratch/.chroot 0750 foo users -
# *Обратите внимание, что это необходимо только в том случае, если chroot находится в энергозависимой файловой системе, такой как tmpfs. (Note that this is only needed if the location of the chroot are on a volatile filesystem like tmpfs.)
#######################################

clear
echo -e "${GREEN}
  <<< Поздравляем! Установка завершена. Перезагрузите систему. >>>
${NC}"
echo -e "${BLUE}:: ${BOLD}Посмотрим дату и время ... ${NC}"
date
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'    # одновременно отображает дату и часовой пояс
echo -e "${BLUE}:: ${BOLD}Отобразить время работы системы ... ${NC}"
uptime
echo -e "${MAGENTA}==> ${BOLD}После перезагрузки и входа в систему проверьте ваши персональные настройки. ${NC}"
echo -e "${YELLOW}==> ...${NC}"
echo -e "${CYAN}:: ${NC}Скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска служб."
echo -e "${GREEN}
  <<< Желаю Вам удачи во всех начинаниях, верных и точных решений! >>> ${NC}"
echo ""
echo -e "${RED}### ${BLUE}########################################################### ${RED}### ${NC}"
echo -e "${RED}==> ${BOLD}Выходим из установленной системы ${NC}"
echo -e "${BLUE}:: ${BOLD}Теперь вам надо ввести (exit) reboot, чтобы перезагрузиться ${NC}"
sleep 03
#exit
#exit
### end of script