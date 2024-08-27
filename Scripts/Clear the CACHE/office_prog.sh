#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! ####
apptitle="Arch Linux Fast Install v2.4 LegasyBIOS - Version: 2024.07.31.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя
###
OFFICE_PROG_LANG="russian"  # Installer default language (Язык установки по умолчанию)
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
echo -e "${MAGENTA}
  <<< Установка Текстовых редакторов и утилит разработки в Archlinux >>> ${NC}"
# Installing Text editors and development utilities in Archlinux
echo ""
echo -e "${GREEN}==> ${NC}Установить Gedit (gedit) - Текстовый редактор?"
#echo -e "${BLUE}:: ${NC}Установить Gedit (gedit) - Текстовый редактор?"
#echo 'Установить Gedit (gedit) - Текстовый редактор?'
# Install Gedit (gedit) - A text editor?
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
  echo " Установка Редактора dconf "
sudo pacman -S --noconfirm --needed dconf  # Конфигурационная система базы данных  # https://wiki.gnome.org/Projects/dconf ; https://archlinux.org/packages/extra/x86_64/dconf/
sudo pacman -S --noconfirm --needed dconf-editor  # редактор dconf ; https://wiki.gnome.org/Apps/DconfEditor ; https://archlinux.org/packages/extra/x86_64/dconf-editor/
  echo ""
  echo " Установка текстового редактора (gedit) "
sudo pacman -S --noconfirm --needed gedit gedit-plugins  # Текстовый редактор GNOME ; https://gedit-technology.github.io/apps/gedit/ ; https://archlinux.org/packages/extra/x86_64/gedit/ ; https://gitlab.gnome.org/GNOME/gedit-plugins ; https://archlinux.org/packages/extra/x86_64/gedit-plugins/ ; https://wiki.archlinux.org/title/GNOME/Gedit
sudo pacman -S --noconfirm --needed libgedit-gtksourceview  # Виджет редактирования исходного кода ; https://gedit-technology.github.io/ ; https://archlinux.org/packages/extra/x86_64/libgedit-gtksourceview/
sudo pacman -S --noconfirm --needed gtksourceview4  # Текстовый виджет, добавляющий подсветку синтаксиса и многое другое в GNOME ; https://wiki.gnome.org/Projects/GtkSourceView ; https://archlinux.org/packages/extra/x86_64/gtksourceview4/ ; GtkSourceView — это библиотека GNOME, которая расширяет GtkTextView , стандартный виджет GTK+ для редактирования многострочного текста. GtkSourceView добавляет поддержку подсветки синтаксиса, отмены/повтора, загрузки и сохранения файлов, поиска и замены, системы автодополнения, печати, отображения номеров строк и других функций, типичных для редактора исходного кода.
#echo ""
echo " Устраняем проблему с win кодировкой в текстовом редакторе (gedit) "
gsettings set org.gnome.gedit.preferences.encodings candidate-encodings "['UTF-8', 'WINDOWS-1251', 'KOI8-R', 'CURRENT', 'ISO-8859-15', 'UTF-16']"
echo " Включить подсветку синтаксиса в PKGBUILD "
sudo pacman -S --noconfirm --needed shared-mime-info  # Freedesktop.org Общая информация MIME ; https://www.freedesktop.org/wiki/Specifications/shared-mime-info-spec/ ; https://archlinux.org/packages/extra/x86_64/shared-mime-info/
#yay -S mime-pkgbuild --noconfirm  # Типы MIME для файлов PKGBUILD ; https://aur.archlinux.org/gtksourceview-pkgbuild.git (только для чтения, нажмите, чтобы скопировать) ; https://gitlab.com/rafaelff/gtksourceview-pkgbuild ; https://aur.archlinux.org/packages/mime-pkgbuild
#yay -S gtksourceview4-pkgbuild --noconfirm  # Поддержка подсветки синтаксиса PKGBUILD в редакторах, совместимых с gtksourceview4 ; https://aur.archlinux.org/gtksourceview-pkgbuild.git (только для чтения, нажмите, чтобы скопировать) ; https://gitlab.com/rafaelff/gtksourceview-pkgbuild ; https://aur.archlinux.org/packages/gtksourceview4-pkgbuild
echo ""
echo " Установка текстового редактора (gedit) выполнена "
fi
######################
# GNOME/Gedit  : https://wiki.archlinux.org/title/GNOME/Gedit
# Не заканчивайте файлы новой строкой.
# Если вы хотите убедиться, что gedit не заканчивает файлы новой строкой, выполните следующее:
# $ gsettings set org.gnome.gedit.preferences.editor ensure-trailing-newline false
# Сохраняйте резервные версии отредактированных файлов:
# Чтобы включить это поведение, откройте панель настроек gedit (для пользователей GNOME Shell ее можно найти в глобальном меню gedit). На панели настроек щелкните вкладку Редактор и отметьте опцию Создать резервную копию файлов перед сохранением.
###############################

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Micro (micro) - Текстовый редактор?"
#echo -e "${BLUE}:: ${NC}Установить Micro (micro) - Текстовый редактор?"
#echo 'Установить Micro (micro) - Текстовый редактор?'
# Install Micro (micro) - A text editor?
echo -e "${MAGENTA}=> ${BOLD}Micro - это современный и интуитивно понятный текстовый редактор на базе терминала. ${NC}"
echo -e "${CYAN}:: ${NC}Описание: Главной особенностью Micro является простота установки (это просто статический двоичный файл без зависимостей) и простота использования. Используйте простой формат json для настройки параметров и переназначения ключей по своему вкусу. Если вам нужно больше мощности, вы можете использовать Lua для дальнейшей настройки редактора. Micro поддерживает более 75 языков и имеет 7 цветовых схем по умолчанию на выбор. Micro поддерживает темы 16, 256 и truecolor. Файлы синтаксиса и цветовые схемы также очень просты в создании. Micro поддерживает множественные курсоры в стиле Sublime, что дает вам широкие возможности редактирования непосредственно в терминале. Micro поддерживает полноценную систему плагинов. Плагины написаны на Lua, и есть менеджер плагинов для автоматической загрузки и установки ваших плагинов. Сочетания клавиш Micro — это то, что вы ожидаете от простого в использовании редактора. Вы также можете без проблем перепривязывать любые сочетания в файле bindings.json. Micro имеет полную поддержку мыши. Это означает, что вы можете щелкнуть и перетащить, чтобы выделить текст, дважды щелкнуть, чтобы выделить слово, и трижды щелкнуть, чтобы выделить строку. Запустите настоящую интерактивную оболочку из микро. Вы можете открыть сплит с кодом на одной стороне и bash на другой — все из микро. И многое другое! "
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (micro)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_micro # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_micro" =~ [^10] ]]
do
    :
done
if [[ $i_micro == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_micro == 1 ]]; then
  echo ""
  echo " Установка текстового редактора (micro) "
sudo pacman -S --noconfirm --needed micro  # Современный и интуитивно понятный текстовый редактор на базе терминала ; https://micro-editor.github.io/ ; https://github.com/zyedidia/micro ; https://archlinux.org/packages/extra/x86_64/micro/
### curl https://getmic.ro | bash
echo ""
echo " Установка текстового редактора (micro) выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Alacritty (alacritty) - Эмулятор терминала?"
#echo -e "${BLUE}:: ${NC}Установить Alacritty (alacritty) - Эмулятор терминала?"
#echo 'Установить Alacritty (alacritty) - Эмулятор терминала?'
# Install Alacrity (alacrity) - Terminal Emulator?
echo -e "${MAGENTA}=> ${BOLD}Alacritty - это бесплатный современный эмулятор терминала, с графическим ускорением с открытым исходным кодом, который поставляется с разумными настройками по умолчанию, но допускает обширную настройку. Интегрируясь с другими приложениями, а не переписывая их функциональность, он обеспечивает гибкий набор функций с высокой производительностью. Поддерживаемые платформы в настоящее время включают BSD, Linux, macOS и Windows. ${NC}"
echo -e "${CYAN}:: ${NC}Описание: Он ориентирован на производительность и простоту. Alacritty не поддерживает вкладки или разделения и настраивается путём редактирования текстового файла. Эмулятор написан на Rust и использует OpenGL для повышения производительности. Помимо функциональности Alacritty как эмулятора терминала, в нем есть несколько функций, призванных облегчить жизнь людям, проводящим много времени за своим терминалом. Мульти окно — Улучшите использование ресурсов, используя только один процесс Alacritty. Полный список функций можно найти в документации Alacritty (https://github.com/alacritty/alacritty/blob/master/docs/features.md). "
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (alacritty)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_alacritty # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_alacritty" =~ [^10] ]]
do
    :
done
if [[ $i_alacritty == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_alacritty == 1 ]]; then
  echo ""
  echo " Установка текстового редактора (alacritty) "
sudo pacman -S --noconfirm --needed tmux  # Терминальный мультиплексор ; https://github.com/tmux/tmux/wiki ; https://archlinux.org/packages/extra/x86_64/tmux/
sudo pacman -S --noconfirm --needed libsixel  # Предоставляет кодек для графики DEC SIXEL и некоторые программы-конвертеры ; https://github.com/libsixel/libsixel ; https://archlinux.org/packages/extra/x86_64/libsixel/
sudo pacman -S --noconfirm --needed lsix  # Как ls, но для изображений показывает миниатюры в терминале с помощью sixel graphics ; https://github.com/hackerb9/lsix ; https://archlinux.org/packages/extra/any/lsix/
sudo pacman -S --noconfirm --needed alacritty  # Кроссплатформенный эмулятор терминала с ускорением на GPU ; https://alacritty.org/ ;https://github.com/alacritty/alacritty ; https://github.com/alacritty/alacritty/releases ; https://archlinux.org/packages/extra/x86_64/alacritty/
echo ""
echo " Установка текстового редактора (alacritty) выполнена "
fi
######### Дополнение ##################
# https://habr.com/ru/articles/746730/ - Мой терминал: alacritty, zsh, tmux, nvim
# AUR alacritty-theme  0.0.1-2 # Коллекция цветовых схем Alacritty 
# https://aur.archlinux.org/alacritty-theme.git (только для чтения, нажмите, чтобы скопировать)
# https://github.com/alacritty/alacritty-theme
# https://aur.archlinux.org/packages/alacritty-theme
# AUR alacritty-themes  6.0.2-1  # Утилита для выбора и применения тем терминала Alacritty.
# https://aur.archlinux.org/alacritty-themes.git (только для чтения, нажмите, чтобы скопировать)
# https://github.com/rajasegar/alacritty-themes
# https://aur.archlinux.org/packages/alacritty-themes
# AUR alacritty-theme-switcher  # Легко переключайтесь между цветовыми темами для Alacritty
# https://aur.archlinux.org/alacritty-theme-switcher.git (только для чтения, нажмите, чтобы скопировать)
# https://github.com/spacebird-dev/alacritty-theme-switcher
# https://aur.archlinux.org/packages/alacritty-theme-switcher
# AUR alacritty-theme-git  # Коллекция цветовых схем Alacritty.
# https://aur.archlinux.org/alacritty-theme-git.git (только для чтения, нажмите, чтобы скопировать)
# https://github.com/alacritty/alacritty-theme
# https://aur.archlinux.org/packages/alacritty-theme-git
# В терминале я обычно использую тему onedark (darker), поэтому прописал в конфиге все цвета вручную.
# https://github.com/navarasu/onedark.nvim
# Alacritty - https://wiki.archlinux.org/title/Alacritty
# Alacritty (Русский) - https://wiki.archlinux.org/title/Alacritty_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
###########################################

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Leafpad (leafpad) - Текстовый редактор?"
#echo -e "${BLUE}:: ${NC}Установить Leafpad (leafpad) - Текстовый редактор?"
#echo 'Установить Leafpad (leafpad) - Текстовый редактор?'
# Install Leafpad (leafpad) - A text editor?
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
  echo " Установка текстового редактора (leafpad) "
sudo pacman -S --noconfirm --needed leafpad  # Клон блокнота для GTK+ 2.0. ; http://tarot.freeshell.org/leafpad/ ; https://archlinux.org/packages/extra/x86_64/leafpad/
echo ""
echo " Установка текстового редактора (leafpad) выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Xed (xed) - Текстовый редактор?"
#echo -e "${BLUE}:: ${NC}Установить Xed (xed) - Текстовый редактор?"
#echo 'Установить Xed (xed) - Текстовый редактор?'
# Install Xed (xed) - A text editor?
echo -e "${MAGENTA}=> ${BOLD}Xed - официальный текстовый редактор проекта X-APPS, цель которого — предоставить приложения для рабочих столов Cinnamon, MATE и Xfce. Xed, стремясь к простоте и удобству использования, является мощным текстовым редактором общего назначения. Его можно использовать для создания и редактирования всех видов текстовых файлов. Оно полностью поддерживает международный текст благодаря использованию кодировки Unicode UTF-8 . Как универсальный текстовый редактор, Xed поддерживает большинство стандартных функций редактора. Его основной набор функций включает подсветку синтаксиса исходного кода, автоматический отступ и поддержку печати с предварительным просмотром. ${NC}"
echo -e "${CYAN}:: ${NC}Описание: Xed поддерживает большинство стандартных функций редактирования, а также несколько функций, которых нет в обычном текстовом редакторе (наиболее примечательными из них являются плагины).
Хотя новые функции постоянно находятся в стадии разработки, в настоящее время xed имеет: Полная поддержка текста в формате UTF-8; Подсветка синтаксиса; Поддержка редактирования удаленных файлов; Поиск и замена; Поддержка печати и предварительного просмотра; Возврат к файлам; Полный интерфейс настроек; Настраиваемая система плагинов с дополнительной поддержкой python. Некоторые из плагинов, упакованных и установленных с помощью xed, включают в себя, среди прочего: Изменение регистра; Статистика документа; Обозреватель файлов; Строки отступа; Вставка даты/времени; Модели; Сохранение без конечных пробелов; Сортировка; Проверка орфографии; Список тегов; Завершение текста. Xed выпускается под лицензией GNU General Public License (GPL) версии 2."
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (xed)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_xed # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_xed" =~ [^10] ]]
do
    :
done
if [[ $i_xed == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_xed == 1 ]]; then
  echo ""
  echo " Установка текстового редактора (xed) "
sudo pacman -S --noconfirm --needed xed  # Небольшой и легкий текстовый редактор. Проект X-Apps. https://github.com/linuxmint/xed ; https://archlinux.org/packages/extra/x86_64/xed/ (Помечено как устаревшее 05.07.2024)
echo ""
echo " Установка текстового редактора (xed) выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Notepadqq (notepadqq) - Текстовый редактор?"
#echo -e "${BLUE}:: ${NC}Установить Notepadqq (notepadqq) - Текстовый редактор?"
#echo 'Установить Notepadqq (notepadqq) - Текстовый редактор?'
# Install Notepad (notepad) - A text editor?
echo -e "${MAGENTA}=> ${BOLD}Notepadqq — простой редактор кода для программистов, созданный по мотивам Notepad++. ${NC}"
echo -e "${CYAN}:: ${NC}Описание: Разработчики явно черпали вдохновение от редактора Notepad++, который популярен в Windows среде. Программа похожа внешне на Notepad++. Функциональность также пересекается, хотя и уступает последнему. Основные возможности Notepadqq: Поддержка подсветки синтаксиса для более 100 языков программирования. Сворачивание блоков кода. Выбор цветовых схем. Предустановлено несколько десятков цветовых схем. Выбор кодировки. Продвинутый поиск по текущему файлу, по открытым файлам и по файлам из директории. Поддержка регулярных выражений. Поддержка настраиваемых горячих клавиш. Поддержка вкладок. Разделение окна программы на две части. Одновременный просмотр документов. Запоминание открытых вкладок при перезапуске программы. Настраиваемые панели управления. Автоматическое сохранение документов (backup). Поддержка расширений. И другие... "
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (notepadqq)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_notepadqq # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_notepadqq" =~ [^10] ]]
do
    :
done
if [[ $i_notepadqq == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_notepadqq == 1 ]]; then
  echo ""
  echo " Установка текстового редактора (notepadqq) "
sudo pacman -S --noconfirm --needed notepadqq  # Текстовый редактор Notepad++ для Linux ; https://notepadqq.com/ ; https://archlinux.org/packages/extra/x86_64/notepadqq/
echo ""
echo " Установка текстового редактора (notepadqq) выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Kate (kate) - Многофункциональный Текстовый редактор?"
#echo -e "${BLUE}:: ${NC}Установить Kate (kate) - Многофункциональный Текстовый редактор?"
#echo 'Установить Kate (kate) - Многофункциональный Текстовый редактор?'
# Install Kate (kate) - A multifunctional Text editor?
echo -e "${MAGENTA}=> ${BOLD}Kate Arch относится к KDE Advanced Text Editor , мощному и многофункциональному текстовому редактору, разработанному сообществом KDE. Kate — многодокументный, многовидовой текстовый редактор от KDE. Он включает такие вещи, как сворачивание кода, подсветка синтаксиса, динамический перенос слов, встроенную консоль, обширный интерфейс плагинов и некоторую предварительную поддержку скриптов. ${NC}"
echo -e "${CYAN}:: ${NC}Описание: Kate оснащен функциями, которые облегчат вам просмотр и редактирование всех ваших текстовых файлов. Kate позволяет вам редактировать и просматривать множество файлов одновременно, как во вкладках, так и в разделенных представлениях, и поставляется с большим количеством плагинов, включая встроенный терминал, который позволяет вам запускать консольные команды непосредственно из Kate, мощные плагины поиска и замены, а также плагин предварительного просмотра, который может показать вам, как будут выглядеть ваши MD, HTML и даже SVG. "
echo " Функции: MDI, разделение окон, вкладки окон; Проверка орфографии; Поддержка новой строки CR, CRLF, LF; Поддержка кодировок (utf-8, utf-16, ascii и т. д.); Преобразование кодировки; Поиск и замена на основе регулярных выражений; Мощная подсветка синтаксиса и сопоставление скобок; Сворачивание кода и текста; Поддержка бесконечной отмены/повтора действий; Режим выбора блока; Автоматический отступ; Поддержка автодополнения; Интеграция оболочки; Широкая поддержка протоколов (http, ftp, ssh, webdav и т. д.); Архитектура плагина для компонента приложения и редактора; Настраиваемые сочетания клавиш; Интегрированная командная строка; Возможность написания скриптов с использованием JavaScript и т. д... "
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (kate)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_kate # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_kate" =~ [^10] ]]
do
    :
done
if [[ $i_kate == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_kate == 1 ]]; then
  echo ""
  echo " Установка текстового редактора (kate) "
sudo pacman -S --noconfirm --needed kate  # Расширенный текстовый редактор ; https://apps.kde.org/kate/ ; https://archlinux.org/packages/extra/x86_64/kate/ ; https://kate-editor.org/
# Для Kate Arch версии 19 или более поздней можно установить quick-lint-js, чтобы обеспечить расширенные возможности линтинга JavaScript и анализа кода.
# yay -S quick-lint-js --noconfirm  # Найдите ошибки в программах JavaScript ; https://aur.archlinux.org/quick-lint-js.git (только для чтения, нажмите, чтобы скопировать) ; https://quick-lint-js.com/ ; https://aur.archlinux.org/packages/quick-lint-js ; quick-lint-js дает вам мгновенную обратную связь по мере написания кода. Найдите ошибки в вашем JavaScript, прежде чем ваш палец уйдет с клавиатуры. Выполните линтинг любого файла JavaScript без настройки ; Конфликты: с quick-lint-js
echo ""
echo " Установка текстового редактора (kate) выполнена "
fi
########## Справка ##############
# Настраиваемая подсветка синтаксиса : поддерживает подсветку более 300 языков, что делает ее пригодной для редактирования кода на различных языках программирования.
# Многодокументный интерфейс (MDI) : позволяет редактировать и просматривать несколько файлов одновременно с возможностью использования вкладок и разделения окон.
# Встроенный терминал : позволяет запускать консольные команды непосредственно из Kate, что удобно для разработчиков и системных администраторов.
# Плагины : предлагает широкий спектр плагинов, включая поиск и замену, предварительный просмотр и другие, для расширения функциональности.
# Управление проектами : предоставляет функции для создания и управления проектами, что делает его подходящим для разработчиков и редакторов, работающих со сложными документами.
#####################################

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Geany (geany) - (для редактирования кода)?"
#echo -e "${BLUE}:: ${NC}Установить Geany (geany) - (для редактирования кода)?"
#echo 'Установить Geany (geany) - (для редактирования кода)?'
# Install Geany (geany) - (to edit the code)?
echo -e "${MAGENTA}=> ${BOLD}Geany - это текстовый редактор, который позволяет подключать сторонние библиотеки для создания полноценной среды разработки. Geany — мощный, стабильный и легкий текстовый редактор для программистов, который предоставляет массу полезных функций, не замедляя рабочий процесс. Он работает на Linux, Windows и macOS, переведен на более чем 40 языков и имеет встроенную поддержку более 50 языков программирования. ${NC}"
echo " Домашняя страница: https://www.geany.org/ ; (https://archlinux.org/packages/extra/x86_64/geany/). "
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
sudo pacman -S --noconfirm --needed geany geany-plugins  # Быстрая и легкая IDE ; https://www.geany.org/ ; https://archlinux.org/packages/extra/x86_64/geany/ ; https://plugins.geany.org/ ; https://archlinux.org/packages/extra/x86_64/geany-plugins/
echo ""
echo " Установка утилиты разработки (geany) выполнена "
fi
############

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить BlueFish - (для редактирования кода)?"
# Install BlueFish - (for code editing)?
echo -e "${MAGENTA}:: ${BOLD}Bluefish Editor - это мощный редактор, ориентированный на программистов и веб-разработчиков, с множеством опций для написания веб-сайтов, скриптов и программного кода. Bluefish поддерживает множество языков программирования и разметки. ${NC}"
echo " Домашняя страница: http://bluefish.openoffice.nl/ ; (https://archlinux.org/packages/extra/x86_64/bluefish/ ; https://sourceforge.net/projects/bluefish/). "  
echo -e "${MAGENTA}:: ${BOLD}Имеет панель управления для добавления часто используемых HTML тегов, CSS элементов и некоторых других вставок, с возможностью ввода параметров элементов. ${NC}"
echo " Bluefish — это многоплатформенное приложение, работающее на большинстве настольных операционных систем, включая Linux, Mac OSX, Windows, FreeBSD и OpenBSD. Bluefish — проект разработки с открытым исходным кодом, выпущенный под лицензией GNU GPL. Bluefish полностью переведен на русский язык (Переводы на 17 языков), современный, удобный, функциональный редактор кода. " 
echo " Bluefish Editor поддерживает редактирование файлов на удаленных системах (используется gnome-vfs). Имеет возможности автозавершения ключевых слов и тегов. С полным списком возможностей можно ознакомиться на сайте программы. " 
echo " Bluefish имеет много функций, этот список даст вам обзор наиболее важных или выдающихся функций в Bluefish : Легковесность — Bluefish старается быть максимально простым и понятным, учитывая, что это графический редактор. Скорость — Bluefish запускается очень быстро (даже на нетбуке) и загружает сотни файлов за считанные секунды. Интерфейс с несколькими документами, легко открывает более 500 документов (проверено более 10000 документов одновременно). Многопоточная поддержка удаленных файлов с использованием gvfs, поддержка FTP , SFTP , HTTP , HTTPS , WebDAV , CIFS и других. Очень мощный поиск и замена с поддержкой регулярных выражений, совместимых с Perl, заменой подшаблонов, а также поиском и заменой в файлах на диске. Рекурсивное открытие файлов на основе шаблонов имен файлов и/или шаблонов содержимого. Боковая панель фрагментов — задайте пользовательские диалоговые окна, шаблоны поиска и замены или вставьте шаблоны и привяжите их к сочетанию клавиш по вашему вкусу, чтобы ускорить процесс разработки. Интегрируйте внешние программы, такие как make, lint, weblint, xmllint, tidy, javac, или свою собственную программу или скрипт для выполнения расширенной обработки текста или обнаружения ошибок и т.д.... "
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed bluefish  # Мощный HTML-редактор для опытных веб-дизайнеров и программистов ; http://bluefish.openoffice.nl/ ; https://archlinux.org/packages/extra/x86_64/bluefish/
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Visual Studio Code - (для редактирования кода)?"
# Install Visual Studio Code - (for code editing)?
echo -e "${MAGENTA}:: ${BOLD}Visual Studio Code — функциональный редактор кода от компании Microsoft. VS Code поддерживает почти все основные языки программирования. Visual Studio Code (VS code) имеет встроенную поддержку языков JavaScript, TypeScript, Node.js, а также большое количество дополнительно подключаемых языков, среди которых: C/C++, C#, Java, Python, PHP, Ruby, Rust, Go, Swift, HTML, XML и другие, но расширения для других можно найти в VS Code Marketplace. ${NC}"
echo " Домашняя страница: https://code.visualstudio.com/ ; (https://aur.archlinux.org/packages/visual-studio-code-bin ; ). "  
echo -e "${MAGENTA}:: ${BOLD}Некоторые возможности программы: Подсветка синтаксиса. Сворачивание блоков кода. Автоматическое форматирование кода. Мульти-строковое редактирование кода (редактирование нескольких строк одновременно, вертикальное выделение). Умная система автодополнения кода. Переход к определению функций и переменных. Поиск по файлам. Поддержка регулярных выражений. Автоматическое распознавание проблемных мест в коде (например, вывод warning в случае undefined переменных). Средства рефакторинга. Возможность отладки кода. Breakpoints, выполнение кода по шагам, просмотр состояния переменных, поддержка многопоточности. Встроенная система контроля версий. Поддержка Git. Поддержка других систем контроля версий, используя подлкючаемые модули (расширения). И другие возможности. ${NC}"
echo " Visual Studio Code имеет современный не перегруженный и отзывчивый интерфейс. Вся работа ведется внутри главного окна. Оно разделяется на различные области. Новые окна открываются, как новая область или как всплывающие вспомогательные окна. Поддерживаются вкладки. По умолчанию установлена темная тема оформления. Доступно несколько различных тем, от светлых до темных. Конфликты: с code (Сборка редактора Visual Studio Code (vscode) с открытым исходным кодом ; https://github.com/microsoft/vscode ; https://archlinux.org/packages/extra/x86_64/code/)" 
echo " Для Visual Studio Code существуют различные модули, которые позволяют добавить поддержку других языков программирования, а также повысить функциональность программы. Программа кроссплатформенная, переведена на русский язык. Распространяется бесплатно, имеет открытый исходный код (Open Source). Но готовые сборки являются проприетарными. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_visualstudio  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_visualstudio" =~ [^10] ]]
do
    :
done
if [[ $in_visualstudio == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_visualstudio == 1 ]]; then
  echo ""
  echo " Установка Visual Studio Code "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
yay -S visual-studio-code-bin --noconfirm  # Visual Studio Code (vscode): редактор для создания и отладки современных веб- и облачных приложений (официальная бинарная версия) ; https://aur.archlinux.org/visual-studio-code-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://code.visualstudio.com/ ; https://aur.archlinux.org/packages/visual-studio-code-bin ; Конфликты: с code (Сборка редактора Visual Studio Code (vscode) с открытым исходным кодом ; https://github.com/microsoft/vscode ; https://archlinux.org/packages/extra/x86_64/code/)
######### visual-studio-code-bin ##########
#git clone https://aur.archlinux.org/visual-studio-code-bin.git  # (только для чтения, нажмите, чтобы скопировать)сборка
#cd visual-studio-code-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf visual-studio-code-bin 
#rm -Rf visual-studio-code-bin
# sudo pacman -R visual-studio-code-bin
echo " Установка утилит (пакетов) выполнена "
fi
########

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Sublime Text (Саблайм текст) (редактор кода)?"
# Install Sublime Text (Sublime Text) (code editor)?
echo -e "${MAGENTA}:: ${BOLD}Sublime Text - это кроссплатформенный текстовый редактор, разработанный для пользователей, которые ищут эффективный, но минималистский инструмент для редактирования кода. Редактор, конечно же, прост, в котором отсутствуют панели инструментов или диалоговые окна. ${NC}"
echo " Sublime Text на данный момент является одним из самых популярных текстовых редакторов, используемых для веб-разработки. Sublime во многом обязан своей популярностью сообществу, которое создало такое большое количество полезных плагинов. "
echo -e "${YELLOW}==> Примечание! ${NC}В сценарии (скрипте) представлены несколько вариантов установки: " 
echo " Sublime Text (пакет) (sublime-text-3) - стабильная версия, Sublime Text (пакет) (sublime-text-4) - стабильная версия, и Sublime Text Dev (пакет) (sublime-text-dev) версия для разработчиков. "
echo -e "${CYAN}:: ${NC}Установка Sublime Text (sublime-text-3 ; 4), или (sublime-text-dev), проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/sublime-text-3/), (https://aur.archlinux.org/packages/sublime-text-dev/) - собирается и устанавливается. "
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In this option, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...  
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Установить Sublime Text 3 stable,    2 - Установить Sublime Text Dev,  

    3 - Установить Sublime Text 4 stable,    0 - НЕТ - Пропустить установку: " i_sublimetext  # sends right after the keypress; # отправляет сразу после нажатия клавиши    
    echo ''
    [[ "$i_sublimetext" =~ [^1230] ]]
do
    :
done 
if [[ $i_sublimetext == 0 ]]; then 
echo ""   
echo " Установка пропущена "
elif [[ $i_sublimetext == 1 ]]; then
  echo ""    
  echo " Установка Sublime Text 3 stable "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
############ sublime-text-3 ##########
yay -S sublime-text-3 --noconfirm  # Продуманный текстовый редактор для кода, html и прозы - стабильная сборка ; https://aur.archlinux.org/sublime-text-3.git (только для чтения, нажмите, чтобы скопировать) ; https://www.sublimetext.com/3 ; https://aur.archlinux.org/packages/sublime-text-3
#git clone https://aur.archlinux.org/sublime-text-3.git  # Продуманный текстовый редактор для кода, html и прозы - стабильная сборка
#cd sublime-text-3
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf sublime-text-3 
#rm -Rf sublime-text-3
echo ""
echo " Установка Sublime Text 3 выполнена "
elif [[ $i_sublimetext == 2 ]]; then
  echo ""    
  echo " Установка Sublime Text Dev "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
############ sublime-text-dev ##########
yay -S sublime-text-dev --noconfirm  # Сложный текстовый редактор для кода, html и прозы - dev build ; https://aur.archlinux.org/sublime-text-dev.git (только для чтения, нажмите, чтобы скопировать) ; https://www.sublimetext.com/dev ; https://aur.archlinux.org/packages/sublime-text-dev ; Конфликты: с sublime-text
#git clone https://aur.archlinux.org/sublime-text-dev.git  # Сложный текстовый редактор для кода, html и прозы - dev build
#cd sublime-text-dev
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf sublime-text-dev 
#rm -Rf sublime-text-dev
echo ""
echo " Установка Sublime Text Dev выполнена "
elif [[ $i_sublimetext == 3 ]]; then
  echo ""    
  echo " Установка Sublime Text 4 stable "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
######## sublime-text-4 #############  
yay -S sublime-text-4 --noconfirm  # Сложный текстовый редактор для кода, html и прозы - стабильная сборка ; https://aur.archlinux.org/sublime-text-4.git (только для чтения, нажмите, чтобы скопировать) ; https://www.sublimetext.com/download ; https://aur.archlinux.org/packages/sublime-text-4 ; Конфликты: с sublime-text 
#git clone https://aur.archlinux.org/sublime-text-4.git   # (только для чтения, нажмите, чтобы скопировать)
#cd sublime-text-4
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf sublime-text-4 
#rm -Rf sublime-text-4
echo ""
echo " Установка Sublime Text 4 выполнена "
fi
#################################
# Sublime Text для фронтэнд-разработчика
# https://habr.com/ru/post/244681/
# https://www.sublimetext.com/3
# http://www.sublimetext.com/3
# https://sublimetext3.ru/
##################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Emacs (emacs) - Текстовый редактор?"
echo -e "${MAGENTA}:: ${BOLD}Emacs - расширяемый, настраиваемый, самодокументирующийся редактор отображения в реальном времени. В основе Emacs лежит интерпретатор Emacs Lisp , языка, на котором реализовано большинство встроенных функций и расширений Emacs. GNU Emacs использует GTK в качестве своего инструментария X, хотя он также хорошо работает в среде CLI. Emacs (GNU Emacs) — один из старейших текстовых редакторов. Первая версия была написана 44 года назад Ричардом Столлманом. Строго говоря, Emacs нельзя назвать просто текстовым редактором. ${NC}"
echo " Домашняя страница: https://www.gnu.org/software/emacs/emacs.html ; (https://archlinux.org/packages/extra/x86_64/emacs/) "  
echo -e "${MAGENTA}:: ${BOLD}Emacs часто описывают как «операционную систему, замаскированную под редактор». Это может показаться преувеличением, но как только вы погрузитесь в его обширную экосистему команд, расширений и настроек, вы поймете, почему. Emacs может быть пугающим для новичков из-за его неинтуитивного интерфейса и сочетаний клавиш, но с практикой он становится мощным инструментом для редактирования текста, программирования и многого другого... ${NC}"
echo " Возможности GNU Emacs включают в себя: Режимы редактирования с учетом содержимого, включая подсветку синтаксиса, для многих типов файлов. Полная встроенная документация, включая руководство для новых пользователей. Полная поддержка Unicode практически для всех человеческих письменностей. Широкие возможности настройки с использованием кода Emacs Lisp или графического интерфейса. Широкий спектр функций помимо редактирования текста, включая планировщик проектов, программу чтения почты и новостей, интерфейс отладчика, календарь, IRC-клиент и многое другое. Система пакетов для загрузки и установки расширений. *После того, как Вы успешно установили GNU Emacs на свой компьютер, необходимо создать файл с названием .emacs и уже в нем прописать основные настройки. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_emacs  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_emacs" =~ [^10] ]]
do
    :
done
if [[ $in_emacs == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_emacs == 1 ]]; then
  echo ""
  echo " Установка Emacs (emacs) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed emacs # Расширяемый, настраиваемый, самодокументируемый редактор отображения в реальном времени ; https://www.gnu.org/software/emacs/emacs.html ; https://archlinux.org/packages/extra/x86_64/emacs/ ; https://en.wikipedia.org/wiki/Emacs_Lisp ; https://www.gnu.org/software/emacs/ ; 22 июня 2024 г., 20:45 UTC ; Обратные конфликты: emacs-nativecomp , emacs-nox , emacs-wayland
######### Расширения Emacs ############
# Для расширения Emacs используется диалект языка Lisp — Emacs Lisp
sudo pacman -S --noconfirm --needed emacs-apel  # Библиотека для создания переносимых программ на Emacs Lisp ; https://github.com/wanderlust/apel ; https://archlinux.org/packages/extra/any/emacs-apel/ ; 19 мая 2023 г., 15:38 UTC
sudo pacman -S --noconfirm --needed emacs-slime  # Улучшенный режим взаимодействия с Lisp для Emacs ; https://slime.common-lisp.dev/ ; https://archlinux.org/packages/extra/any/emacs-slime/ ; 31 марта 2024 г., 23:23 UTC
sudo pacman -S --noconfirm --needed cl-swank  # Улучшенный режим взаимодействия с Lisp для Emacs (сервер на стороне Lisp) ; https://slime.common-lisp.dev/ ; https://archlinux.org/packages/extra/any/cl-swank/ ; 31 марта 2024 г., 23:23 UTC
sudo pacman -S --noconfirm --needed emacs-python-mode  # Режим Python для Emacs ; https://launchpad.net/python-mode ; https://archlinux.org/packages/extra/any/emacs-python-mode/ ; 19 мая 2023 г., 15:38 UTC  
sudo pacman -S --noconfirm --needed emacs-muse  # Издательская среда для Emacs ; https://www.gnu.org/software/emacs-muse/index.html ; https://archlinux.org/packages/extra/any/emacs-muse/ ; 12 июля 2024 г., 14:06 UTC    
sudo pacman -S --noconfirm --needed emacs-lua-mode  # Emacs lua-режим ; https://github.com/immerrr/lua-mode ; https://archlinux.org/packages/extra/any/emacs-lua-mode/ ; 12 июля 2024 г., 14:06 UTC
sudo pacman -S --noconfirm --needed emacs-haskell-mode  # Пакет режима Haskell для Emacs ; Это режим Emacs для редактирования, разработки и отладки программ на Haskell ; https://github.com/haskell/haskell-mode ; https://archlinux.org/packages/extra/any/emacs-haskell-mode/ ; 12 июля 2024 г., 13:55 UTC
sudo pacman -S --noconfirm --needed semi  # Библиотека, предоставляющая функцию MIME для GNU Emacs ; https://github.com/wanderlust/semi ; https://archlinux.org/packages/extra/any/semi/ ; 13 июля 2024 г., 21:13 UTC      
sudo pacman -S --noconfirm --needed wanderlust  # Программа для чтения почты/новостей с поддержкой IMAP4rev1 для emacs ; https://github.com/wanderlust/wanderlust/ ; https://archlinux.org/packages/extra/any/wanderlust/ ; 16 апреля 2024 г., 0:59 UTC  
sudo pacman -S --noconfirm --needed mg  # Микро GNU/emacs ; https://github.com/hboetes/mg ; https://archlinux.org/packages/extra/x86_64/mg/ ; 9 июля 2024 г., 17:23 UTC ; 
sudo pacman -S --noconfirm --needed sbcl  # Steel Bank Общий Lisp ; http://www.sbcl.org/ ; https://archlinux.org/packages/extra/x86_64/sbcl/ ; 13 июля 2024 г., 6:46 UTC ; Помечено как устаревшее 29 июля 2024 г.
######### Другие модификации Emacs ############
# sudo pacman -S --noconfirm --needed emacs-wayland  # Расширяемый, настраиваемый, самодокументируемый редактор отображения в реальном времени с собственной компиляцией и поддержкой PGTK ; https://www.gnu.org/software/emacs/emacs.html ;  https://archlinux.org/packages/extra/x86_64/emacs-wayland/ ; Конфликты: с emacs ; 22 июня 2024 г., 20:45 UTC    
# sudo pacman -S --noconfirm --needed emacs-nativecomp  # Расширяемый, настраиваемый, самодокументируемый редактор отображения в реальном времени с возможностью собственной компиляции ; https://www.gnu.org/software/emacs/emacs.html ; https://archlinux.org/packages/extra/x86_64/emacs-nativecomp/ ;  Конфликты: с emacs ; 22 июня 2024 г., 20:45 UTC    
# sudo pacman -S --noconfirm --needed emacs-nox  # Расширяемый, настраиваемый, самодокументируемый редактор отображения в реальном времени без поддержки X11 ; https://www.gnu.org/software/emacs/emacs.html ; https://archlinux.org/packages/extra/x86_64/emacs-nox/ ; Конфликты: с emacs ; 22 июня 2024 г., 20:45 UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############ Справка #############
# https://wiki.archlinux.org/title/Emacs
# https://www.gnu.org/software/emacs/emacs.html
# https://archlinux.org/packages/extra/x86_64/emacs/
# https://www.opennet.ru/docs/RUS/emacs_begin/
# Установите один из следующих пакетов:
# emacs - стабильный релиз,
# emacs-nativecomp - с включенной собственной компиляцией ,
# emacs-nox - без поддержки X11,
# emacs-wayland — с собственной компиляцией и включенным PGTK.
# Можно искать и другие варианты, например, emacs-git AUR предоставляет ветку разработки GNU Emacs.
##########################

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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed cherrytree  # Приложение для создания иерархических заметок ; https://www.giuspen.com/cherrytree/ ; https://archlinux.org/packages/extra/x86_64/cherrytree/
# yay -S cherrytree-bin --no-confirm  #  Двоичная версия Cherrytree ; https://aur.archlinux.org/cherrytree-bin.git ; https://www.giuspen.com/cherrytree/ ; https://aur.archlinux.org/packages/cherrytree-bin/
# yay -S cherrytree-git --no-confirm  # Приложение для создания иерархических заметок, версия git ; https://aur.archlinux.org/cherrytree-git.git ; https://github.com/giuspen/cherrytree ; https://aur.archlinux.org/packages/cherrytree-git/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##################################
# Ссылки:
# https://github.com/giuspen/cherrytree
# https://www.giuspen.com/cherrytree/
# cherrytree-bin - https://aur.archlinux.org/packages/cherrytree-bin/
# cherrytree-git - https://aur.archlinux.org/packages/cherrytree-git/
###################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить GHex - Шестнадцатеричный редактор?"
echo -e "${MAGENTA}:: ${BOLD}GHex — шестнадцатеричный редактор для рабочего стола GNOME. ${NC}"
echo " Домашняя страница: https://gitlab.gnome.org/GNOME/ghex ; (https://archlinux.org/packages/extra/x86_64/ghex/). "  
echo -e "${MAGENTA}:: ${BOLD}GHex может загружать необработанные данные из двоичных файлов и отображать их для редактирования в традиционном представлении шестнадцатеричного редактора. Дисплей разделен на два столбца, с шестнадцатеричными значениями в одном столбце и представлением ASCII в другом. GHex — полезный инструмент для работы с необработанными данными. ${NC}"
echo " GHex является частью семейства приложений GNOME Extra Apps и не является основным приложением GNOME. GHex позволяет пользователю загружать данные из любого файла, просматривать и редактировать их в любомшестнадцатеричный или ASCII. Полезно для отладки проблем с объектным кодом или кодировками. Также используется детьми, которые мошенничают в компьютерных играх, добавляя очки или жизни в сохраненные игры. Первоначальный автор GHex — Яка Мокник. С тех пор в него внесли свой вклад различные участники. Он выпущен под лицензией GNU General Public License. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_ghex  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_ghex" =~ [^10] ]]
do
    :
done
if [[ $in_ghex == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_ghex == 1 ]]; then
  echo ""
  echo " Установка GHex "
sudo pacman -S --noconfirm --needed libadwaita # Строительные блоки для современных адаптивных приложений GNOME ; https://gnome.pages.gitlab.gnome.org/libadwaita/ ; https://archlinux.org/packages/extra/x86_64/libadwaita/
sudo pacman -S --noconfirm --needed ghex  # Простой двоичный редактор для рабочего стола Gnome ; https://wiki.gnome.org/Apps/Ghex ; https://archlinux.org/packages/extra/x86_64/ghex/ ; https://gitlab.gnome.org/GNOME/ghex
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##############

clear
echo -e "${MAGENTA}
  <<< Установка утилит (пакетов) управления электронной почтой в Archlinux >>> ${NC}"
# Installing Email management utilities (packages) in Archlinux
echo ""
echo -e "${GREEN}==> ${NC}Установить Mozilla Thunderbird - управления электронной почтой и новостными лентами?"
#echo -e "${BLUE}:: ${NC}Управления электронной почтой, новостными лентами, чатом и группам"
#echo 'Управления электронной почтой, новостными лентами, чатом и группам'
# Install Thunderbird - Email and news feed management?
echo -e "${MAGENTA}:: ${BOLD}Mozilla Thunderbird - Автономная, бесплатная кроссплатформенная свободно распространяемая программа для работы с электронной почтой и группами новостей, а при установке расширения Lightning, и с календарём. Программа обладает всеми необходимыми функциями для управления электронной почтой. Является составной частью проекта Mozilla (mozilla.org) ${NC}"
echo -e "${CYAN}:: ${NC}Основные возможности: Поддержка протоколов: SMTP, POP3, IMAP, NNTP, RSS. Создание нескольких учетных записей. Автоматические настройки при создании учетных записей. Мастер начальной настройки. Фильтрация сообщений. Панель быстрого фильтра. Поиск сообщений. Для быстрого поиска все письма индексируются. Архивация сообщений. Умные папки. Встроенный обучаемый спам-фильтр. Поддержка дополнений. Менеджер дополнений встроен в программу. Поддержка вкладок. Открытие писем в отдельных вкладках. Автоматическое напоминание о забытом вложении. Программа анализирует текст письма и если в нем встречаются слова, связанные, например, с файлами (пример: "см. вложение"), то предложит пользователю прикрепить вложение, если он этого не сделал. Добавлен встроенный децентрализованный Чат Matrix."
echo " Язык программирования: C/C++ ; Также используется: JavaScript, CSS, Rust, XUL, XBL ; Библиотека интерфейса: GTK+ ; Программа полностью переведена на русский язык. "
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
  echo " Установка Установка утилит (пакетов) Thunderbird "
sudo pacman -S --noconfirm --needed thunderbird  # Программа для чтения почты и новостей от mozilla.org ;  ; https://www.thunderbird.net/  ; https://archlinux.org/packages/extra/x86_64/thunderbird/
sudo pacman -S --noconfirm --needed thunderbird-i18n-ru  # Русский языковой пакет для Thunderbird ; https://www.thunderbird.net/ ; https://archlinux.org/packages/extra/x86_64/thunderbird-i18n-ru/
#sudo pacman -S --noconfirm --needed thunderbird-i18n-en-us  # Английский (США) языковой пакет для Thunderbird ; https://www.thunderbird.net/ 
sudo pacman -S --noconfirm --needed thunderbird-dark-reader  # Инвертирует яркость веб-страниц и снижает нагрузку на глаза при просмотре веб-страниц ; https://darkreader.org/ ; https://archlinux.org/packages/extra/any/thunderbird-dark-reader/
sudo pacman -S --noconfirm --needed systray-x-common  # Расширение системного трея для Thunderbird 68+ (для X) — общая версия ; https://github.com/Ximi1970/systray-x ; https://archlinux.org/packages/extra/x86_64/systray-x-common/ - Это дополнение и сопутствующее приложение НЕ будут работать с flatpaks или snaps Thunderbird. 
sudo pacman -S --noconfirm --needed libnotify  # Библиотека для отправки уведомлений на рабочий стол ; https://gitlab.gnome.org/GNOME/libnotify ; https://archlinux.org/packages/extra/x86_64/libnotify/
sudo pacman -S --noconfirm --needed ttf-ubuntu-font-family  # Семейство шрифтов Ubuntu ; https://design.ubuntu.com/font/ ; https://archlinux.org/packages/extra/any/ttf-ubuntu-font-family/ ; Помечено как устаревшее 3 августа 2023 г.
  echo " Установка утилит (пакетов) для Проверка орфографии в Thunderbird "
sudo pacman -S --noconfirm --needed hunspell  # Библиотека и программа для проверки орфографии и морфологического анализатора ; https://github.com/hunspell/hunspell ; https://archlinux.org/packages/extra/x86_64/hunspell/
sudo pacman -S --noconfirm --needed hunspell-ru  # Русский словарь для Hunspell ; https://cgit.freedesktop.org/libreoffice/dictionaries/tree/ru_RU ; https://archlinux.org/packages/extra/any/hunspell-ru/
echo ""
echo " Установка утилит (пакетов) Thunderbird выполнена "
fi
############ Справка и Дополнения ##########
# Thunderbird - https://wiki.archlinux.org/title/Thunderbird
# Thunderbird (Русский) - https://wiki.archlinux.org/title/Thunderbird_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# Установка Thunderbird на Linux - https://support.mozilla.org/ru/kb/ustanovka-thunderbird-na-linux
#################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Geary (geary) - Почтовый клиент?"
# Install Geary (geary) - Mail client?
echo -e "${MAGENTA}:: ${BOLD}Geary — это простой почтовый клиент, созданное для общения в среде GNOME - для Linux. Приложение с приятным, «легким» и современным интерфейсом, который работает так, как вам нужно. Обладает базовым набором функций для работы с почтой. Программа Geary обладает всем базовым функционалом, который может понадобиться при работе с почтой. Программу отличает простой интерфейс, удобство работы, очень хороший функционал и малое потребление системных ресурсов. ${NC}"
echo " Домашняя страница: https://wiki.gnome.org/Apps/Geary ; (https://archlinux.org/packages/extra/x86_64/geary/). "  
echo -e "${MAGENTA}:: ${BOLD}Geary собирает связанные сообщения в беседы, что упрощает поиск и отслеживание обсуждений. Быстрый поиск Geary по всему тексту и ключевым словам позволяет легко найти нужное вам письмо. Полнофункциональный компоновщик Geary позволяет отправлять насыщенный, стилизованный текст с изображениями, ссылками и списками, а также отправлять легкие, легко читаемые текстовые сообщения. Geary автоматически подхватывает ваши существующие учетные записи GNOME Online, и добавлять новые очень просто. Изначально разработкой программы занималась организация Yorba Foundation, которая создала менеджер фотографий Shotwell. Затем разработкой занялось сообщество GNOME. Исходный код: Open Source (открыт); Языки программирования: Vala; Библиотеки: GTK; Лицензия: GNU GPL; Приложение переведено на русский язык. ${NC}"
echo " Основные возможности программы: Просмотр цепочек писем. Группировка сообщений по обсуждениям. Быстрое создание почтовых учетных записей. Уведомления о новых письмах на рабочем столе. Создание писем в формате HTML и в текстовом формате. Вставка изображений в текст письма. Быстрый поиск писем по ключевым словам. Возможность ставить пометки-флаги на сообщения. Возможность подключения различных словарей для проверки правописания. Поиск с использованием анкоров - from:pingvinus, is:read, is:unread, is:starred. Поддержка горячих клавиш. Поддержка работы без подключения к интернет. Архивирование почты. Автоматические настройки для GMail, Yahoo Mail, Outlook и другие. Поддержка шифрования SSL и STARTTLS. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_geary  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_geary" =~ [^10] ]]
do
    :
done
if [[ $in_geary == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_geary == 1 ]]; then
  echo ""
  echo " Установка Geary (geary) "
sudo pacman -S --noconfirm --needed geary  # Легкий почтовый клиент для рабочего стола GNOME ; https://wiki.gnome.org/Apps/Geary ; https://archlinux.org/packages/extra/x86_64/geary/ ; https://gitlab.gnome.org/GNOME/geary
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить KMail (kmail) - Почтовый клиент от KDE?"
# Install KMail (kmail) - An email client from KDE?
echo -e "${MAGENTA}:: ${BOLD}KMail — почтовый клиент, разрабатываемый проектом KDE. KMail — это современный почтовый клиент, который хорошо интегрируется с широко используемыми поставщиками электронной почты, такими как GMail. Он предоставляет множество инструментов и функций для максимизации вашей производительности и делает работу с большими учетными записями электронной почты простой и быстрой. KMail поддерживает множество протоколов электронной почты — POP3, IMAP, Microsoft Exchange (EWS) и другие. Исходный код: Open Source (открыт); Языки программирования: C++; Библиотеки: Qt; Лицензия: GNU GPL; Приложение переведено на русский язык. ${NC}"
echo " Домашняя страница: https://apps.kde.org/kmail2/ ; (https://archlinux.org/packages/extra/x86_64/kmail/). "  
echo -e "${MAGENTA}:: ${BOLD}Функции: Безопасность — KMail имеет безопасные настройки по умолчанию для защиты вашей конфиденциальности, отличную поддержку сквозного шифрования и функцию обнаружения спама. Мощный — функции включают в себя поддержку автономного режима, множественные идентификаторы отправителя, многоязыковую поддержку, мощные функции фильтрации, поиска и тегирования, управление списками рассылки и очень гибкую настройку. Интеграция — приглашения на встречи можно легко добавлять как события в KOrganizer, автозаполнение адреса, аватары и настройки криптовалюты загружаются из KAddressBook. Соответствие стандартам — поддерживает стандартные почтовые протоколы, push-рассылку электронной почты, фильтрацию на стороне сервера и встроенные OpenPGP, PGP/MIME и S/MIME. ${NC}"
echo " Возможности: Поддержка IMAP, POP3 и SMTP. Поддержка HTML и простых писем (plain text). В KMail можно создавать несколько Профилей (Identities) для отправки сообщений. Профили можно связать с различными учетными записями. Профиль определяет настройки и правила для создаваемых сообщений. Возможность работать в Offline-режиме. Гибкая система шаблонов писем. Встроенная система перевода сообщений. Проверка орфографии. Проверка орфографии для каждого параграфа отдельно — для писем, написанных на нескольких языках. Подсказки и дополнительные возможности при создании писем: предупреждение о забытых вложениях, встроенное сжатие вложений, изменение размера вложенных изображений. Создание фильтров. Поиск сообщений. Поиск в папках IMAP. Встроенная поддержка OpenPGP, PGP/MIME, S/MIME, SSL/TLS. Изоляция HTML содержимого. KMail гарантирует, что никакие внешние ссылки не могут быть скрыты внутри сообщений. Возможности интегрировать различные спам-трекеры, для анализа сообщений и фильтрации спама. Большое количество настроек. Распознавание сообщений, которые содержат бронирования авиабилетов или отелей (только для некоторых сервисов бронирования). Интеграция с KOrganizer, KAddressBook, KWallet. И другие возможности... " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_kmail  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_kmail" =~ [^10] ]]
do
    :
done
if [[ $in_kmail == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_kmail == 1 ]]; then
  echo ""
  echo " Установка KMail (kmail) "
sudo pacman -S --noconfirm --needed kmail  # Почтовый клиент KDE ; https://apps.kde.org/kmail2/ ; https://archlinux.org/packages/extra/x86_64/kmail/ ; https://docs.kde.org/?application=kmail2 ; https://kontact.kde.org/components/kmail/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
###############
# Первоначальная настройка KMail
# https://docs.kde.org/stable5/en/kmail/kmail2/manual-configuration-quickstart.html
# https://docs.altlinux.org/ru-RU/archive/7.0.5/html/kdesktop/ch30.html
# http://www.old.open-suse.ru/modules/smartsection/item.php?itemid=86
#####################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Claws Mail (claws-mail) - Почтовый клиент?"
echo -e "${MAGENTA}:: ${BOLD}Claws Mail — это клиент электронной почты (и программа для чтения новостей), основанный на GTK+ . Поддерживает поиск писем, шаблоны писем, плагины и многое другое. Внешний вид и интерфейс разработаны так, чтобы быть знакомыми как новым пользователям, перешедшим из других популярных почтовых клиентов, так и опытным пользователям. Почти все команды доступны с клавиатуры. Сообщения управляются в стандартном формате MH, который обеспечивает быстрый доступ и безопасность данных. Вы сможете импортировать свои письма практически из любого другого почтового клиента и экспортировать их так же легко. Поддерживаются основные почтовые протоколы и шифрование. Дополнительные плагины предоставляют множество дополнительных функций, таких как RSS-агрегатор, календарь или управление светодиодами ноутбука. ${NC}"
echo " Домашняя страница: https://www.claws-mail.org/ ; (https://archlinux.org/packages/extra/x86_64/claws-mail/). "  
echo -e "${MAGENTA}:: ${BOLD}Основные возможности и особенности программы: Стандартный, простой интерфейс. Поддержка нескольких учетных записей. Создание фильтров для писем. Мощный поиск сообщений. Шаблоны писем. Встроенный просмотрщик изображений. SSL для POP3, SMTP, IMAP4rev1 и NNTP. Поддержка GnuPG (GPGME). Поддержка большого количества горячих клавиш для выполнения любых действий в программе. Адресная книга. Печать сообщений. Поддержка плагинов (RSS, календарь, SpamAssassin и многие другие). Поддержка тем оформления. И другое... ${NC}"
echo " Claws Mail имеет массу настроек. Можно настроить внешний вид программы, обработку почты, составление сообщений и многое другое. В программе отсутствует автоматический менеджер настройки почтовых аккаунтов, как, например, это сделано в почтовом клиенте Thunderbird, который содержит базу настроек для популярных почтовых сервисов. Исходный код: Open Source (открыт); Языки программирования: C++; Библиотеки: GTK; Claws Mail распространяется по лицензии GPL. Приложение переведено на русский язык. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_claws  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_claws" =~ [^10] ]]
do
    :
done
if [[ $in_claws == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_claws == 1 ]]; then
  echo ""
  echo " Установка Claws Mail (claws-mail) "
sudo pacman -S --noconfirm --needed claws-mail  # Клиент электронной почты на базе GTK+ ; https://www.claws-mail.org/ ; https://archlinux.org/packages/extra/x86_64/claws-mail/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Mailspring (mailspring) - Почтовый клиент?"
echo -e "${MAGENTA}:: ${BOLD}Mailspring — кроссплатформенный почтовый клиент. Обладает всеми базовыми возможностями для работы с электронной почтой. Имеет современный интерфейс. Также Mailspring доступна в виде snap-пакета. ${NC}"
echo " Домашняя страница: https://getmailspring.com/ ; (https://aur.archlinux.org/packages/mailspring). "  
echo -e "${MAGENTA}:: ${BOLD}Основные возможности программы Mailspring: Поиск писем с использованием языка запросов (in, has:attachment, subject, from, to и так далее). Просмотр доступных сведений об отправителе — профили в социальных сетях, история сообщений и другое. Отслеживание открытия и прочтения отправленных писем. Отправка писем в заданное время. Создание правил обработки почты. Настраиваемые подписи. Создание шаблонов писем. Snoozing — возможность задать для сообщения определенное время, через которое оно должно о себе напомнить. Это удобно, когда у вас нет возможности отреагировать на письмо прямо сейчас и вы не хотите его видеть во входящих. Письмо как бы будет доставлено вам повторно позже в определенное вами время. Поддержка горячих клавиш. Можно выбрать профиль (как в Outlook, Gmail). Поддержка тем оформления. Поддерживается автоматический импорт настроек для следующих почтовых сервисов: Gmail; G Suite; Яндекс; Yahoo; iCloud; GMX; Office 365; Outlook.com (Hotmail); FastMail и др. ${NC}"
echo " Интерфейс Mailspring выполнен в современном легковесном стиле. В верхней части окна программы расположено меню и панель инструментов, включая строку поиска. Главная рабочая область разбита на колонки: папки для каталогизации и выборки писем, список писем, просмотр писем, информация об отправителей. Интерфейс отзывчивый, есть всплывающие подсказки. Поддерживается перетаскивание писем мышкой, сворачивание, группировка писем в рамках одного разговора (темы). " 
echo " При первом запуске программы открывается Визард, через который можно выполнить первичные настройки и ввести данные об учетной записи почты. На первом шаге вам будет предложено создать учетную запись Mailspring ID. Учетная запись нужна, чтобы работали некоторые расширенные функции, а также для синхронизации данных при использовании программы на разных компьютерах. Пароли от ящиков никогда не отправляются в облако. К сожалению, пропустить этот шаг нельзя. Это однозначно недостаток программы. "
echo -e "${CYAN}:: ${NC}Установка Mailspring (mailspring) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_mailspring  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_mailspring" =~ [^10] ]]
do
    :
done
if [[ $in_mailspring == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_mailspring == 1 ]]; then
  echo ""
  echo " Установка Mailspring (mailspring) "
######### mailspring ##############  
yay -S mailspring --no-confirm  # Красивый, быстрый и поддерживаемый форк Nylas Mail от одного из оригинальных авторов ; https://aur.archlinux.org/mailspring.git (только для чтения, нажмите, чтобы скопировать) ; https://getmailspring.com/ ; https://aur.archlinux.org/packages/mailspring ; Смотреть Зависимости !!!
######### mailspring ##############
#git clone https://aur.archlinux.org/mailspring.git   # (только для чтения, нажмите, чтобы скопировать)
#cd mailspring
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf mailspring 
#rm -Rf mailspring
######### mailspring-bin ##############
# yay -S mailspring-bin --no-confirm  # Красивый, быстрый и полностью открытый почтовый клиент ; https://aur.archlinux.org/mailspring-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://getmailspring.com/ ; https://aur.archlinux.org/packages/mailspring-bin ; Конфликты: с mailspring ; Смотреть Зависимости !!!
######### mailspring-git ##############
# yay -S mailspring-git --no-confirm  # Красивый, быстрый и полностью открытый почтовый клиент ; https://aur.archlinux.org/mailspring-git.git (только для чтения, нажмите, чтобы скопировать) ; https://getmailspring.com/ ; https://aur.archlinux.org/packages/mailspring-git ; Конфликты: с mailspring ; Смотреть Зависимости !!!
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
###################
# По какой-то причине переключение на mailspring-binпакет и добавление --password-store=gnome-libsecret исправляет проблему. Я все еще получаю ту же ошибку с --password-store=gnome-libsecret этим пакетом.
# Для тех, у кого возникли проблемы после обновления KDE 6, самое простое решение — добавить аргумент --password-store=kwallet5. Другого разумного решения нет, пока не будет выпущено исправление в upstream, и его нельзя добавить в пакет, потому что тогда он не будет работать в других DE.
###############################

clear
echo -e "${MAGENTA}
  <<< Установка утилит (пакетов) Офисных программ в Archlinux (👉👈) >>> ${NC}"
# Installing Office Software utilities (packages) in Archlinux
echo ""
echo -e "${GREEN}==> ${NC}Установить LibreOffice (libreOffice-still, или libreOffice-fresh) - Офисный пакет?"
# Install LibreOffice (LibreOffice-still, or LibreOffice-fresh) - Office Suite?
echo -e "${MAGENTA}:: ${BOLD}LibreOffice — бесплатный и мощный офисный пакет, преемник OpenOffice.org (широко известного как OpenOffice). Обладает всеми необходимыми функциями для создания и редактирования простых и сложных текстовых документов. Функциональность программы сравнима с редактором Microsoft Office и претендующий на роль бесплатной альтернативы пакету офисных приложений Microsoft Office. (😃) ${NC}"
echo " Домашняя страница: https://www.libreoffice.org/ ; (https://archlinux.org/packages/extra/x86_64/libreoffice-still/). " 
echo -e "${MAGENTA}:: ${BOLD}В состав программы входят текстовый редактор Writer, табличный процессор Calc, мастер презентаций Impress, векторный графический редактор Draw, редактор формул Math и модуль управления базами данных Base. Все компоненты хорошо сочетаются и дополняют друг друга, предоставляя пользователю всё необходимое для ежедневной работы с документами, ввода, систематизации и анализа данных, маркетинга, проведения презентаций и обучения. ${NC}"
echo " В чём заключаются особенности LibreOffice? Как следует из названия, LibreOffice — один из крупнейших свободных офисных продуктов. Свобода проявляется в: Отсутствии каких-либо лицензионных отчислений за приобретение и использование продукта. Отсутствии языкового барьера. Если поддержка вашего языка ещё не включена в LibreOffice, то, несомненно, это скоро изменится. Открытом доступе к исходному коду по лицензионному соглашению OSI. Процесс создания LibreOffice полностью открыт. "
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: 1 - LibreOffice-still - это мощный, официально поддерживаемый офисный пакет, имеется стабильная ветвь обновлений. 2 - LibreOffice-fresh - это офисный пакет, новые функции, улучшения программы появляются сначала здесь, часто обновляется. ${NC}"
echo -e "${YELLOW}==> ${NC}Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. Вы можете пропустить этот шаг, если не уверены в правильности выбора."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить LibreOffice (libreOffice-still),     2 - Установить LibreOffice (libreOffice-fresh),

    0 - Пропустить установку: " t_office  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_office" =~ [^120] ]]
do
    :
done
if [[ $t_office == 0 ]]; then
#clear
echo ""
echo " Установка утилит пропущена "
elif [[ $t_office == 1 ]]; then
echo ""
echo " Установка LibreOffice (libreOffice-still) "
sudo pacman -Syyu  # Обновите и модернизируйте свою систему
######### Проверка орфографии (английская и русская) ###########
sudo pacman -S --noconfirm --needed aspell  # Проверка орфографии, призванная в конечном итоге заменить Ispell ; http://aspell.net/ ; https://archlinux.org/packages/extra/x86_64/aspell/
sudo pacman -S --noconfirm --needed aspell-en  # Английский словарь для aspell ; http://aspell.net/ ; https://archlinux.org/packages/extra/x86_64/aspell-en/
sudo pacman -S --noconfirm --needed aspell-ru  # Русский словарь для aspell ; http://aspell.net/ ; https://archlinux.org/packages/extra/x86_64/aspell-ru/
sudo pacman -S --noconfirm --needed hunspell  # Библиотека и программа для проверки орфографии и морфологического анализатора ; https://github.com/hunspell/hunspell ; https://archlinux.org/packages/extra/x86_64/hunspell/
sudo pacman -S --noconfirm --needed hyphen  # Библиотека для качественной расстановки переносов и выравнивания ; https://hunspell.sf.net/ ; https://archlinux.org/packages/extra/x86_64/hyphen/
sudo pacman -S --noconfirm --needed mythes  # libmythes  Простой тезаурус (Словарь понятий или терминов). В нем можно найти слова синонимы или антонимы к интересующему понятию (слову, термину) ; https://github.com/hunspell/mythes ; https://archlinux.org/packages/extra/x86_64/libmythes/
#sudo pacman -S --noconfirm --needed libmythes  # простой тезаурус ; https://github.com/hunspell/mythes ; https://archlinux.org/packages/extra/x86_64/libmythes/ ; это простой тезаурус, использующий структурированную текстовый файл данных и индексный файл с бинарным поиском для поиска слов и фраз и возврата информации о части речи, значениях и синонимах
####### libreoffice-still ############
# sudo pacman -S libreoffice-still libreoffice-still-ru --noconfirm
sudo pacman -S --noconfirm --needed libreoffice-still  # Филиал обслуживания LibreOffice ; https://www.libreoffice.org/ ; https://archlinux.org/packages/extra/x86_64/libreoffice-still/
sudo pacman -S --noconfirm --needed libreoffice-still-ru  # Пакет русского языка для LibreOffice still ; https://www.documentfoundation.org/ ; https://archlinux.org/packages/extra/any/libreoffice-still-ru/
########## Дополнительные расширения ####################
sudo pacman -S --noconfirm --needed libreoffice-extension-texmaths  # Редактор формул LaTeX для LibreOffice ; http://roland65.free.fr/texmaths/ ; https://archlinux.org/packages/extra/any/libreoffice-extension-texmaths/
sudo pacman -S --noconfirm --needed libreoffice-extension-writer2latex  # Java-программа и набор расширений LibreOffice для преобразования и работы с LaTeX в LibreOffice ; https://writer2latex.sourceforge.net/ ; https://archlinux.org/packages/extra/any/libreoffice-extension-writer2latex/
sudo pacman -S --noconfirm --needed unoconv  # Конвертер документов на основе Libreoffice ; http://dag.wiee.rs/home-made/unoconv ; https://archlinux.org/packages/extra/any/unoconv/
########## Средство проверки стиля и грамматики ############
# yay -S libreoffice-extension-languagetool --noconfirm  # Средство проверки стиля и грамматики с открытым исходным кодом (более 30 языков) ; https://aur.archlinux.org/libreoffice-extension-languagetool.git (только для чтения, нажмите, чтобы скопировать) ; https://languagetool.org/ ; https://aur.archlinux.org/packages/libreoffice-extension-languagetool
########## libreoffice-extension-languagetool ##############
# git clone https://aur.archlinux.org/libreoffice-extension-languagetool.git  # (только для чтения, нажмите, чтобы скопировать)
# cd libreoffice-extension-languagetool
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf libreoffice-extension-languagetool 
# rm -Rf libreoffice-extension-languagetool
libreoffice --version   # Проверьте установку
sleep 2
#######################
#clear
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $t_office == 2 ]]; then
echo ""
echo " Установка LibreOffice (libreOffice-fresh) "
sudo pacman -Syyu  # Обновите и модернизируйте свою систему
# sudo pacman -S --noconfirm --needed libreoffice-fresh libreoffice-fresh-ru
sudo pacman -S --noconfirm --needed libreoffice-fresh  # Ветвь LibreOffice, содержащая новые функции и улучшения программы
sudo pacman -S --noconfirm --needed libreoffice-fresh-ru  # Пакет русского языка для LibreOffice Fresh
libreoffice --version   # Проверьте установку
sleep 2
#clear
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##############################
# LibreOffice - https://www.libreoffice.org/ ; https://www.documentfoundation.org
# Поддержка языков в LibreOffice реализуется отдельными пакетами.
# Смотреть список пакетов:
# $ pacman -Ss libreoffice | grep \\-ru
# extra/libreoffice-fresh-ru 5.3.0-1
# extra/libreoffice-still-ru 5.2.5-1
# После чего установите LibreOffice необходимой версии с русской локализацией.
# -----------------------------------------
# https://www.libreoffice.org/ ; https://www.documentfoundation.org
# LibreOffice-still  - Филиал обслуживания LibreOffice
# https://www.archlinux.org/packages/extra/x86_64/libreoffice-still/
# Libreoffice-still-ru  -  Пакет русского языка для LibreOffice still
# https://www.archlinux.org/packages/extra/any/libreoffice-still-ru/
# https://www.documentfoundation.org
# LibreOffice-fresh  -  Ветвь LibreOffice, содержащая новые функции и улучшения программы
# https://www.archlinux.org/packages/extra/x86_64/libreoffice-fresh/
# Libreoffice-fresh-ru  -  Пакет русского языка для LibreOffice Fresh
# https://www.archlinux.org/packages/extra/any/libreoffice-fresh-ru/
#####################################

clear
echo ""
echo -e "${GREEN}==> ${NC}Установим Офисный пакет - ONLYOFFICE: (onlyoffice-bin)?"
# Will we install the Office suite - OnlyOffice: (onlyoffice-bin)?
echo -e "${MAGENTA}:: ${BOLD}OnlyOffice Desktop — это офисный пакет, который отличается хорошей поддержкой форматов Microsoft Office (внешне похожий на Microsoft Office), чем становится интуитивно понятным для большинства пользователей. Включает текстовый процессор, табличный процессор, презентации. ${NC}"
echo " Домашняя страница: https://www.onlyoffice.com/ ; (https://aur.archlinux.org/packages/onlyoffice-bin). " 
echo -e "${CYAN}=> ${BOLD}Состав OnlyOffice: Текстовый процессор ; Табличный процессор ; Программа для создания презентаций. Поддерживаемые форматы: DOCX ; ODT ; XLSX ; ODS ; CSV ; PPTX ; ODP И другие. ${NC}"
echo " В состав документа входят: Документ (аналог Word); Таблица (аналог Excel); Презентация (аналог PowerPoint); Возможность хранения и редактирования документов в облаке. Наряду с обычными офисными документами вы можете создавать локально профессионально оформленные заполняемые формы и совместно редактировать их в режиме онлайн, разрешать другим пользователям заполнять их и сохранять формы в виде файлов PDF. "
echo " Кроме редакторов, в пакет программ входит средство для управления проектами, почтовый клиент. Программа разрабатывается в Российской компании ЗАО «Новые коммуникационные технологии». По функциональности OnlyOffice сопоставим с Microsoft Office Online и Google Docs и её ещё можно расширить с помощью различных плагинов. Используйте сторонние плагины — YouTube, Photo Editor, Translator, Thesaurus. Чтобы изменить язык на русский, откройте пункт Settings, затем в поле Language, выберите русский язык. (😃) "
echo -e "${CYAN}:: ${NC}Установка OnlyOffice (onlyoffice-bin) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo " Другой способ установки ONLYOFFICE Desktop Editors — через Flatpak . (Конфликты: с onlyoffice) "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. Вы можете пропустить этот шаг, если не уверены в правильности выбора. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " prog_onlyoffice  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_onlyoffice" =~ [^10] ]]
do
    :
done
if [[ $prog_onlyoffice == 0 ]]; then
echo ""
echo " Установка утилит пропущена "
elif [[ $prog_onlyoffice == 1 ]]; then
  echo ""
  echo " Установка OnlyOffice (onlyoffice-bin) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
######### Проверка орфографии (английская и русская) ###########
sudo pacman -S --noconfirm --needed aspell  # Проверка орфографии, призванная в конечном итоге заменить Ispell ; http://aspell.net/ ; https://archlinux.org/packages/extra/x86_64/aspell/
sudo pacman -S --noconfirm --needed aspell-en  # Английский словарь для aspell ; http://aspell.net/ ; https://archlinux.org/packages/extra/x86_64/aspell-en/
sudo pacman -S --noconfirm --needed aspell-ru  # Русский словарь для aspell ; http://aspell.net/ ; https://archlinux.org/packages/extra/x86_64/aspell-ru/
sudo pacman -S --noconfirm --needed hunspell  # Библиотека и программа для проверки орфографии и морфологического анализатора ; https://github.com/hunspell/hunspell ; https://archlinux.org/packages/extra/x86_64/hunspell/
sudo pacman -S --noconfirm --needed hyphen  # Библиотека для качественной расстановки переносов и выравнивания ; https://hunspell.sf.net/ ; https://archlinux.org/packages/extra/x86_64/hyphen/
sudo pacman -S --noconfirm --needed mythes  # libmythes  Простой тезаурус (Словарь понятий или терминов). В нем можно найти слова синонимы или антонимы к интересующему понятию (слову, термину) ; https://github.com/hunspell/mythes ; https://archlinux.org/packages/extra/x86_64/libmythes/
#sudo pacman -S --noconfirm --needed libmythes  # простой тезаурус ; https://github.com/hunspell/mythes ; https://archlinux.org/packages/extra/x86_64/libmythes/ ; это простой тезаурус, использующий структурированную текстовый файл данных и индексный файл с бинарным поиском для поиска слов и фраз и возврата информации о части речи, значениях и синонимах
############ Основной шрифт с дополнительными значками ##############
sudo pacman -S --noconfirm --needed ttf-hack-nerd  # Исправленный хак шрифта из библиотеки шрифтов для ботаников ; https://github.com/ryanoasis/nerd-fonts ; https://archlinux.org/packages/extra/any/ttf-hack-nerd/
###### Шрифт для отображения иероглифического письма ################
sudo pacman -S --noconfirm --needed noto-fonts-cjk  # Шрифты Google Noto CJK ; https://www.google.com/get/noto/ ; https://archlinux.org/packages/extra/any/noto-fonts-cjk/
sudo pacman -S --noconfirm --needed ttf-dejavu  # Семейство шрифтов на основе шрифтов Bitstream Vera с более широким набором символов ; https://dejavu-fonts.github.io/ ; https://archlinux.org/packages/extra/any/ttf-dejavu/
sudo pacman -S --noconfirm --needed ttf-liberation  # Семейство шрифтов, нацеленное на метрическую совместимость с Arial, Times New Roman и Courier New ; https://github.com/liberationfonts/liberation-fonts ; https://archlinux.org/packages/extra/any/ttf-liberation/  
############# Takao Fonts ###############
yay -S otf-takao --noconfirm --needed  # Японские контурные шрифты на основе шрифтов IPA (otf-ipafont) ; https://aur.archlinux.org/otf-takao.git (только для чтения, нажмите, чтобы скопировать) ; https://launchpad.net/takao-fonts ; https://aur.archlinux.org/packages/otf-takao
# git clone https://aur.archlinux.org/otf-takao.git  # (только для чтения, нажмите, чтобы скопировать)
# cd  otf-takao
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf  otf-takao 
# rm -Rf  otf-takao
############### Microsoft fonts ###############
######### ttf-ms-fonts ################
yay -S ttf-ms-fonts --noconfirm --needed  # Основные шрифты TTF от Microsoft ; https://aur.archlinux.org/packages/ttf-ms-fonts ; https://aur.archlinux.org/ttf-ms-fonts.git (только для чтения, нажмите, чтобы скопировать) ; http://corefonts.sourceforge.net
# git clone https://aur.archlinux.org/ttf-ms-fonts.git  # (только для чтения, нажмите, чтобы скопировать)
# cd ttf-ms-fonts
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ttf-ms-fonts 
# rm -Rf ttf-ms-fonts
######### onlyoffice-bin ###############
yay -S onlyoffice-bin --noconfirm  # Офисный пакет, сочетающий в себе редакторы текста, таблиц и презентаций ; https://aur.archlinux.org/onlyoffice-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://www.onlyoffice.com/ru/download-desktop.aspx ; https://www.onlyoffice.com/ ; https://aur.archlinux.org/packages/onlyoffice-bin ; https://wiki.archlinux.org/title/Onlyoffice_Documentserver
######### onlyoffice-bin ###############
# git clone https://aur.archlinux.org/onlyoffice-bin.git  # (только для чтения, нажмите, чтобы скопировать)
# cd onlyoffice-bin
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf onlyoffice-bin 
# rm -Rf onlyoffice-bin
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##########

clear
echo ""
echo -e "${GREEN}==> ${NC}Установим Офисный пакет - WPS Office: (wps-office)?"
# Will we install the Office suite - WPS Office: (wps-office)?
echo -e "${MAGENTA}:: ${BOLD}Kingsoft Office (WPS Office) — это офисный пакет, включающий в себя текстовый процессор, табличный процессор и программу для создания презентаций. Имеет отличную совместимость с документами Microsoft Office. WPS Office разрабатывается компанией KINGSOFT Office Software Corporation (дочернее предприятие публично торгуемой компании Kingsoft Corp). Сам офисный пакет WPS Office раньше так и назывался — Kingsoft Office, но 6 июня 2014 года был переименован в WPS Office. Существуют как платные, так и бесплатные версии WPS Office. Под Linux программа полностью бесплатна. ${NC}"
echo -e "${CYAN}=> ${BOLD}Состав WPS Office: WPS Office сотоит из трех программ: Writer — текстовый процессор; Spreadsheets — табличный процессор; Presentation — программа для создания презентаций . ${NC}"
echo " WPS Office Writer — текстовый процессор. Обладает всей необходимой функциональностью для создания полноценных текстовых документов. Заявлена полная совместимость с документами Microsoft Word (документы .doc и .docx). "
echo " WPS Office Spreadsheets — табличный процессор — электронные таблицы. Поддерживается большое количество формул и функций (финансовые, статистические, инженерные и другие), построение графиков, диаграмм, вставка изображений. Заявлена полная совместимость с Microsoft Excel (документы .xls и .xlsx). "
echo " WPS Office Presentation — программа для создания презентаций. Позволяет создавать презентации различной степени сложности. Поддерживается вставка медиа (фотографии, видео, анимация), создание таблиц, графиков и диаграмм. Заявлена полная совместимость с Microsoft PowerPoint (документы .ppt). "
echo " Отличительной особенностью WPS Office, по сравнению с другими офисными пакетам, работающими под ОС Linux, является очень хорошая совместимость с документами Microsoft Office (по крайней мере, так заявлено разработчиком). Интерфейс WPS Office практически повторяет интерфейс Microsoft Office. Есть несколько тем оформления: светлые и темные темы в стиле Microsoft Office 2010 («ленточный интерфейс»), а также классическая тема, которая аналогична Microsoft Office 2003 (простые горизонтальные панели с иконками). Если вы выберете тему Arc вместо Arc-Dark, всплывающее окно для сохранения и открытия документов будет полностью белым. Конфликты: с kingsoft-office "
echo -e "${CYAN}:: ${NC}Установка WPS Office (wps-office) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. Вы можете пропустить этот шаг, если не уверены в правильности выбора. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " prog_wpsoffice  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_wpsoffice" =~ [^10] ]]
do
    :
done
if [[ $prog_wpsoffice == 0 ]]; then
echo ""
echo " Установка утилит пропущена "
elif [[ $prog_wpsoffice == 1 ]]; then
  echo ""
  echo " Установка WPS Office (wps-office) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
######### Проверка орфографии (английская и русская) ###########
sudo pacman -S --noconfirm --needed aspell  # Проверка орфографии, призванная в конечном итоге заменить Ispell ; http://aspell.net/ ; https://archlinux.org/packages/extra/x86_64/aspell/
sudo pacman -S --noconfirm --needed aspell-en  # Английский словарь для aspell ; http://aspell.net/ ; https://archlinux.org/packages/extra/x86_64/aspell-en/
sudo pacman -S --noconfirm --needed aspell-ru  # Русский словарь для aspell ; http://aspell.net/ ; https://archlinux.org/packages/extra/x86_64/aspell-ru/
sudo pacman -S --noconfirm --needed hunspell  # Библиотека и программа для проверки орфографии и морфологического анализатора ; https://github.com/hunspell/hunspell ; https://archlinux.org/packages/extra/x86_64/hunspell/
sudo pacman -S --noconfirm --needed hyphen  # Библиотека для качественной расстановки переносов и выравнивания ; https://hunspell.sf.net/ ; https://archlinux.org/packages/extra/x86_64/hyphen/
sudo pacman -S --noconfirm --needed mythes  # libmythes  Простой тезаурус (Словарь понятий или терминов). В нем можно найти слова синонимы или антонимы к интересующему понятию (слову, термину) ; https://github.com/hunspell/mythes ; https://archlinux.org/packages/extra/x86_64/libmythes/
#sudo pacman -S --noconfirm --needed libmythes  # простой тезаурус ; https://github.com/hunspell/mythes ; https://archlinux.org/packages/extra/x86_64/libmythes/ ; это простой тезаурус, использующий структурированную текстовый файл данных и индексный файл с бинарным поиском для поиска слов и фраз и возврата информации о части речи, значениях и синонимах
############### Microsoft fonts ###############
######### ttf-ms-fonts ################
yay -S ttf-ms-fonts --noconfirm --needed  # Основные шрифты TTF от Microsoft ; https://aur.archlinux.org/packages/ttf-ms-fonts ; https://aur.archlinux.org/ttf-ms-fonts.git (только для чтения, нажмите, чтобы скопировать) ; http://corefonts.sourceforge.net
# git clone https://aur.archlinux.org/ttf-ms-fonts.git  # (только для чтения, нажмите, чтобы скопировать)
# cd ttf-ms-fonts
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ttf-ms-fonts 
# rm -Rf ttf-ms-fonts
########## ttf-wps-fonts ###############
yay -S ttf-wps-fonts --noconfirm  # Если установлен WPS - Символьные шрифты требуются wps-office ; https://aur.archlinux.org/ttf-wps-fonts.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/ferion11/ttf-wps-fonts ; https://aur.archlinux.org/packages/ttf-wps-fonts
# git clone https://aur.archlinux.org/ttf-wps-fonts.git  # (только для чтения, нажмите, чтобы скопировать)
# cd ttf-wps-fonts
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ttf-wps-fonts
# rm -Rf ttf-wps-fonts
############ wps-office-fonts ##############
yay -S wps-office-fonts --noconfirm  # Пакет wps-office-fonts содержит шрифты Founder Chinese ; https://aur.archlinux.org/wps-office-fonts.git (только для чтения, нажмите, чтобы скопировать) ; http://wps-community.org/ ; https://aur.archlinux.org/packages/wps-office-fonts
# git clone https://aur.archlinux.org/wps-office-fonts.git  # (только для чтения, нажмите, чтобы скопировать)
# cd wps-office-fonts
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf wps-office-fonts
# rm -Rf wps-office-fonts
######### ttf-wps-win10 ############  Конфликты: с ttf-wps-fonts  !!!
# yay -S ttf-wps-win10 --noconfirm  # Шрифты символов, требуемые wps-office из Microsoft Windows 10 ; https://aur.archlinux.org/ttf-wps-win10.git (только для чтения, нажмите, чтобы скопировать) ; http://www.microsoft.com/typography/fonts/product.aspx?PID=164 ; https://aur.archlinux.org/packages/ttf-wps-win10
# git clone https://aur.archlinux.org/ttf-wps-win10.git  # (только для чтения, нажмите, чтобы скопировать)
# cd ttf-wps-win10
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ttf-wps-win10
# rm -Rf ttf-wps-win10
########### Dependencies   ################
sudo pacman -S --noconfirm --needed freetype2  # Библиотека растеризации шрифтов ; https://www.freetype.org/ ; https://archlinux.org/packages/extra/x86_64/freetype2/
yay -S libtiff5 --noconfirm  # Библиотека для работы с изображениями TIFF ; https://aur.archlinux.org/libtiff5.git (только для чтения, нажмите, чтобы скопировать) ; http://www.simplesystems.org/libtiff ; https://aur.archlinux.org/packages/libtiff5 
#yay -S wps-office-mime --noconfirm  # Файлы MIME, предоставленные Kingsoft Office (WPS Office) ; https://aur.archlinux.org/wps-office.git (только для чтения, нажмите, чтобы скопировать) ; http://wps-community.org/ ; https://aur.archlinux.org/packages/wps-office-mime
######### Kingsoft Office (WPS Office) ###############  https://wiki.archlinux.org/title/WPS_Office
yay -S wps-office --noconfirm  # Kingsoft Office (WPS Office) - офисный пакет для повышения производительности ; https://aur.archlinux.org/wps-office.git (только для чтения, нажмите, чтобы скопировать) ; http://wps-community.org/ ; https://aur.archlinux.org/packages/wps-office
######### wps-office ###############
# git clone https://aur.archlinux.org/wps-office.git  # (только для чтения, нажмите, чтобы скопировать)
# cd wps-office
#makepkg -fsri
# makepkg -si
# makepkg -sri
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf wps-office 
# rm -Rf wps-office
############################
yay -S wps-office-mui-ru --noconfirm  # Русский mui перевод для WPS Office (Пакеты MUI для WPS Office) ; https://aur.archlinux.org/wps-office-mui-ru.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/wachin/wps-office-all-mui-win-language ; https://aur.archlinux.org/packages/wps-office-mui-ru
yay -S wps-office-all-dicts-win-languages --noconfirm  # Все языки правописания версии Windows WPS Office Многоязычный пользовательский интерфейс (MUI) для использования в Linux ; https://aur.archlinux.org/wps-office-all-dicts-win-languages.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/wachin/wps-office-all-mui-win-language ; https://aur.archlinux.org/packages/wps-office-all-dicts-win-languages
# sudo pacman -R wps-office
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########## Справка #####################
# Файл Microsoft Office в KDE Plasma распознается как Zip
# После установки WPS Office файлы Microsoft Office будут распознаваться как zip и не смогут открываться с помощью WPS. Вы можете изменить этот тип распознавания, удалив файл mime в /usr/share/packages/:
# rm /usr/share/mime/packages/wps-office-*.xml
# обновление-mime-базы данных /usr/share/mime
# rm /usr/share/mime/packages/wps-office-*.xml
# update-mime-database /usr/share/mime
# Чего только не делал, никак у меня WPS Office "по-русски не понимать". Папку ru_RU куда нужно закидывал...
# /opt/kingsoft/wps-office/office6/dicts
######################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Apache OpenOffice (openoffice-bin) - Офисный пакет?"
echo -e "${MAGENTA}:: ${BOLD}Apache OpenOffice — ведущий пакет офисного программного обеспечения с открытым исходным кодом для обработки текстов, электронных таблиц, презентаций, графики, баз данных и многого другого. Он доступен на многих языках и работает на всех распространенных компьютерах. Он хранит все ваши данные в международном формате открытого стандарта, а также может читать и записывать файлы из других распространенных пакетов офисного программного обеспечения. Его можно загрузить и использовать совершенно бесплатно для любых целей. Apache OpenOffice https://wiki.archlinux.org/title/Apache_OpenOffice ${NC}"
echo " Домашняя страница: https://www.openoffice.org/ ; (https://aur.archlinux.org/packages/openoffice-bin). "  
echo -e "${MAGENTA}:: ${BOLD}Состав пакета: Writer - Текстовый процессор и визуальный редактор HTML, похожие приложения: Microsoft Word, LibreOffice Writer, Pages, AbiWord, KWord. Calc - Редактор электронных таблиц, похожие приложения: Microsoft Excel, LibreOffice Calc, Numbers, Gnumeric, KCells. Impress - Программа подготовки презентаций, похожие приложения: Microsoft PowerPoint, Keynote, KPresenter. Base - Механизм подключения к внешним СУБД и встроенная СУБД HSQLDB, похожие приложения: Microsoft Access, Kexi. Draw - Векторный графический редактор, похожие приложения: Microsoft Visio, Adobe Illustrator, CorelDRAW, Calligra Flow, Dia. Math - Редактор формул, похожие приложения: MathType, KFormula. ${NC}"
echo " Для проверки орфографии вам понадобится hunspell и словарь для hunspell (например, hunspell-en_us , hunspell-de и т. д.), для правил переноса вам понадобится дефис ( hyphen-en , hyphen-de и т. д.), а для тезауруса — libmythes . Рекомендуется также установить Java (https://wiki.archlinux.org/title/Java). "
echo -e "${CYAN}:: ${NC}Установка Apache OpenOffice (openoffice-bin) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! (Конфликты: с openoffice-base-bin-unstable) "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_gscan2pdf  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_gscan2pdf" =~ [^10] ]]
do
    :
done
if [[ $in_gscan2pdf == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_gscan2pdf == 1 ]]; then
  echo ""
  echo " Установка Apache OpenOffice (openoffice-bin) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
######### Проверка орфографии (английская и русская) ###########
sudo pacman -S --noconfirm --needed aspell  # Проверка орфографии, призванная в конечном итоге заменить Ispell ; http://aspell.net/ ; https://archlinux.org/packages/extra/x86_64/aspell/
sudo pacman -S --noconfirm --needed aspell-en  # Английский словарь для aspell ; http://aspell.net/ ; https://archlinux.org/packages/extra/x86_64/aspell-en/
sudo pacman -S --noconfirm --needed aspell-ru  # Русский словарь для aspell ; http://aspell.net/ ; https://archlinux.org/packages/extra/x86_64/aspell-ru/
sudo pacman -S --noconfirm --needed hunspell  # Библиотека и программа для проверки орфографии и морфологического анализатора ; https://github.com/hunspell/hunspell ; https://archlinux.org/packages/extra/x86_64/hunspell/
sudo pacman -S --noconfirm --needed hyphen  # Библиотека для качественной расстановки переносов и выравнивания ; https://hunspell.sf.net/ ; https://archlinux.org/packages/extra/x86_64/hyphen/
sudo pacman -S --noconfirm --needed mythes  # libmythes  Простой тезаурус (Словарь понятий или терминов). В нем можно найти слова синонимы или антонимы к интересующему понятию (слову, термину) ; https://github.com/hunspell/mythes ; https://archlinux.org/packages/extra/x86_64/libmythes/
# sudo pacman -S --noconfirm --needed libmythes  # простой тезаурус ; https://github.com/hunspell/mythes ; https://archlinux.org/packages/extra/x86_64/libmythes/ ; это простой тезаурус, использующий структурированную текстовый файл данных и индексный файл с бинарным поиском для поиска слов и фраз и возврата информации о части речи, значениях и синонимах
############ openoffice-bin ###############
#yay -S openoffice --noconfirm
yay -S openoffice-bin --noconfirm  # Бесплатный и открытый пакет программ для повышения производительности (Apache OpenOffice) ; https://aur.archlinux.org/openoffice-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://www.openoffice.org/ ; https://aur.archlinux.org/packages/openoffice-bin (Конфликты: с openoffice-base-bin-unstable)
yay -S openoffice-ru-bin --noconfirm  # Пакет русского языка для OpenOffice.org ; https://aur.archlinux.org/openoffice-ru-bin.git (только для чтения, нажмите, чтобы скопировать) ; http://www.openoffice.org/ ; https://aur.archlinux.org/packages/openoffice-ru-bin 
yay -S openoffice-extension-languagetool --noconfirm  # Средство проверки стиля и грамматики с открытым исходным кодом (более 30 языков) ; https://aur.archlinux.org/openoffice-extension-languagetool.git (только для чтения, нажмите, чтобы скопировать) ; https://languagetool.org/ ; https://aur.archlinux.org/packages/openoffice-extension-languagetool
# Чтобы получить современный внешний вид (а не тот ужасный интерфейс Windows 98), вам следует добавить пакет «gdk-pixbuf-xlib» в поле «depends=».
# GdkPixbuf-Xlib
# GdkPixbuf-Xlib содержит устаревший API для интеграции GdkPixbuf с типами данных Xlib.
# Первоначально эта библиотека была предоставлена ​​[GdkPixbuf][gdk-pixbuf] и с тех пор была перемещена из исходного репозитория.
# Ни один вновь написанный код не должен использовать эту библиотеку.
# Если ваш существующий код зависит от gdk-pixbuf-xlib, то вам настоятельно рекомендуется отказаться от него.
sudo pacman -S --noconfirm --needed gdk-pixbuf-xlib  # Устаревшая интеграция Xlib для GdkPixbuf ; https://gitlab.gnome.org/Archive/gdk-pixbuf-xlib ; https://archlinux.org/packages/extra/x86_64/gdk-pixbuf-xlib/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Дополнение ###############
# Apache OpenOffice https://wiki.archlinux.org/title/Apache_OpenOffice
# Установка макросов
# В большинстве дистрибутивов Linux путь по умолчанию для макросов следующий:
# ~/.openoffice.org/3/user/Scripts/
# Путь к этому каталогу в Arch Linux следующий:
# ~/.config/.openoffice.org/3/user/Scripts/
# Макросы не гарантированно будут работать как в OpenOffice, так и в LibreOffice, но можно выбрать для них общий каталог. Выберите путь в Tools > Options > LibreOffice/OpenOffice > Paths Путь по умолчанию для макросов LibreOffice в Arch Linux:
# ~/.config/libreoffice/4/user/Scripts/
# Сглаживание
# Выполнять:
# $ echo "Xft.lcdfilter: lcddefault" | xrdb -merge
# Чтобы сделать изменение постоянным, добавьте Xft.lcdfilter: lcddefault в свой ~/.Xresources файл 
# Если это не сработает, убедитесь, что вы запускаете $ xrdb -merge ~/.Xresources каждый раз при запуске Xorg . Если у вас нет этого файла, вам придется его создать.
#########################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить SoftMaker FreeOffice (freeoffice) - Бесплатный офис?"
echo -e "${MAGENTA}:: ${BOLD}FreeOffice TextMaker — бесплатный проприетарный текстовый редактор. Поддерживаются все базовые возможности офисного текстового процессора. Программа имеет хорошую поддержку документов Microsoft Office Word. Программа проприетарная, с закрытым кодом. Многие подумают зачем тогда она тут вообще нужна? У неё есть большое преимущество, которое, на мой взгляд, более чем компенсирует закрытость кода. Это преимущество — отличная работа с документами в формате Microsoft Word. Его очень любят различные организации — как государственные, так и частные, как российские, так и заграничные. ${NC}"
echo " Домашняя страница: http://www.freeoffice.com/ ; (https://www.freeoffice.com/ru/ ; https://aur.archlinux.org/packages/freeoffice). "  
echo -e "${MAGENTA}:: ${BOLD}В остальном TextMaker — обычный редактор текстовых документов. Возможно, в нём есть какие-то особенности, но расширенные средства редактирования я не рассматривал, поскольку лично мне они не нужны. С обычными задачами (набор текста разными шрифтами, печать, таблицы, вставка изображений — это и подобные базовые возможности вполне поддерживаются, а большее я не могу описать в этом обзоре. Несмотря на то, что сайт программы англоязычный, в интерфейсе полностью поддерживается русский язык. Программа кроссплатформенная работает как на различных дистрибутивах Linux, Windows... ${NC}"
echo " Из отмеченных недостатков могу только упомянуть грубоватый внешний вид. Впрочем, внешний вид — это вопрос вкуса, работать он нисколько не мешает. При первом запуске требуется указание лицензионного ключа, который также можно получить бесплатно. Пакет FreeOffice бесплатен для персонального и коммерческого использования! В составе пакета FreeOffice также идёт парочка других утилит — для работы с презентациями и чем-то ещё, но я с ними не работал и поэтому ничего о них сказать не могу. " 
echo -e "${CYAN}:: ${NC}Установка SoftMaker FreeOffice (freeoffice) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_freeoffice  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_freeoffice" =~ [^10] ]]
do
    :
done
if [[ $in_freeoffice == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_freeoffice == 1 ]]; then
  echo ""
  echo " Установка FreeOffice (freeoffice) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
######### Проверка орфографии (английская и русская) ###########
sudo pacman -S --noconfirm --needed aspell  # Проверка орфографии, призванная в конечном итоге заменить Ispell ; http://aspell.net/ ; https://archlinux.org/packages/extra/x86_64/aspell/
sudo pacman -S --noconfirm --needed aspell-en  # Английский словарь для aspell ; http://aspell.net/ ; https://archlinux.org/packages/extra/x86_64/aspell-en/
sudo pacman -S --noconfirm --needed aspell-ru  # Русский словарь для aspell ; http://aspell.net/ ; https://archlinux.org/packages/extra/x86_64/aspell-ru/
sudo pacman -S --noconfirm --needed hunspell  # Библиотека и программа для проверки орфографии и морфологического анализатора ; https://github.com/hunspell/hunspell ; https://archlinux.org/packages/extra/x86_64/hunspell/
sudo pacman -S --noconfirm --needed hyphen  # Библиотека для качественной расстановки переносов и выравнивания ; https://hunspell.sf.net/ ; https://archlinux.org/packages/extra/x86_64/hyphen/
sudo pacman -S --noconfirm --needed mythes  # libmythes  Простой тезаурус (Словарь понятий или терминов). В нем можно найти слова синонимы или антонимы к интересующему понятию (слову, термину) ; https://github.com/hunspell/mythes ; https://archlinux.org/packages/extra/x86_64/libmythes/
#sudo pacman -S --noconfirm --needed libmythes  # простой тезаурус ; https://github.com/hunspell/mythes ; https://archlinux.org/packages/extra/x86_64/libmythes/ ; это простой тезаурус, использующий структурированную текстовый файл данных и индексный файл с бинарным поиском для поиска слов и фраз и возврата информации о части речи, значениях и синонимах  
###### freeoffice ########### 
yay -S freeoffice --noconfirm  # Полный, надежный, молниеносно быстрый и совместимый с Microsoft Office офисный пакет с текстовым процессором, электронными таблицами и программным обеспечением для создания презентаций ; https://aur.archlinux.org/freeoffice.git (только для чтения, нажмите, чтобы скопировать) ; http://www.freeoffice.com/ ; https://aur.archlinux.org/packages/freeoffice ; http://www.softmaker.net/down/softmaker-freeoffice-2024-1216-amd64.tgz
#git clone https://aur.archlinux.org/freeoffice.git   # (только для чтения, нажмите, чтобы скопировать)
#cd freeoffice
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf freeoffice 
#rm -Rf freeoffice
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############ Справка и Дополнения ##########
# SoftMaker FreeOffice  - http://www.freeoffice.com/ ; https://www.freeoffice.com/ru/ ; https://sharewareonsale.com/s/softmaker-office-giveaway-coupon-sale
# Получение лицензии:
# 1) Перейдите на сайт разработчиков - https://www.freeoffice.com/ru/download#
# 2) Заполните необходимые формы и выберите редакцию которая вам нужна (для Windows, для Mac, для Linux)
# 3) Скачайте и установите пакет программ
# 4) При регистрации вы указывали почту, туда пришло письмо с ключом, введите его при запуске любого приложения
# При первом запуске приложения введите следующий ключ продукта: 476674971158
########## Состав пакета FreeOffice: ############
# 1) TextMaker - Интуитивно понятный продукт который имеет функционал Word, никаких проблем с освоением нет. Возможность сохранять и открывать документы созданные в Word и наоборот, полная совместимость
# 2) PlanMaker - Если вы привыкли к Excel то проблем не будет и с PlanMaker все функции и формулы работают так же. Так же полная совместимость с Excel поэтому вы свободно можете переносить документы созданные в PlanMaker на любой Excel
# 3) Presentations - Замена PowerPoint, так же полная свобода в выборе шаблонов и стиля оформление презентации. И полная совместимость с PowerPoint поэтому не стоит волноваться что в ответственный момент вы не сможете представить презентацию
### Метод 2: Установка FreeOffice на Manjaro | Arch Linux вручную ############
# Для ручного метода установки скачайте архив файлов:
# cd ~/Downloads
# wget https://www.softmaker.net/down/softmaker-freeoffice-2024-1216-amd64.tgz  (на момент написания)
# Извлеките загруженный файл:
# $ tar xvf softmaker-freeoffice-2024-1216-amd64.tgz
# freeoffice2018.tar.lzma
# installfreeoffice
# Запустите скрипт установщика.
# sudo ./installfreeoffice
###########################

clear
echo -e "${CYAN}
  <<< Установка программ Текстовые процессоры для системы Arch Linux >>> ${NC}"
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Scribus (scribus) - Верстка документов (настольное издательское приложение)?"
echo -e "${MAGENTA}:: ${BOLD}Scribus — мощная бесплатная программа, предназначенная для профессиональной верстки документов. Обладает множеством возможностей и позволяет верстать простые и сложные документы, включая печатные издания и полиграфическую продукцию — газеты, книги, журналы, и другие. Сохранение и экспорт документов: Scribus сохраняет документы в свой собственный формат *.sla. Поддерживается экспорт в PDF и в графические форматы (svg, eps, png, jpg, bmp и другие). ${NC}"
echo " Домашняя страница: https://www.scribus.net/ ; (https://archlinux.org/packages/extra/x86_64/scribus/). "  
echo -e "${MAGENTA}:: ${BOLD}Возможности программы: Программа позволяет проводить разметку документа, добавлять различные блоки, фигуры, линии, изображения, текстовые блоки, таблицы. Также есть элементы «Кривая Безье», «Линия от руки» для свободного рисования. Все элементы можно настраивать — вращать, наклонять, изменять положение, размеры и так далее. Изображения можно редактировать прямо в программе — добавлять различные эффекты и фильтры, масштабировать. Для работы с текстом Scribus имеет множество настроек — изменение шрифта, стиля текста, различные отступы, поля и смещения. ${NC}"
echo " Интерфейс программы довольно удобен и в нем просто разобраться. Всю основную часть экрана занимает рабочая область, сверху строка меню и панель инструментов, снизу дополнительные элементы и строка состояния. Свойства элементов изменяются через отдельное окошко. Scribus написана на языке программирования C++ с использованием библиотек Qt4. Программа полностью переведена на русский язык. Программа Scribus кроссплатформенная и доступна для Linux, Windows, Mac OS X, Unix, OS2, *BSD. " 
echo " Большинство фирменных программ DTP хранят данные в двоичных форматах файлов, которые не могут быть прочитаны большинством людей. Некоторые даже шифруют свои файлы, чтобы быть уверенными, что вы можете получить доступ к своей работе только с помощью их закрытого программного обеспечения. Если такой файл был поврежден, восстановить его практически невозможно. Scribus использует радикально иной подход, поскольку его формат файла основан на XML, т. е. его можно читать и анализировать с помощью простого текстового редактора. Это не только означает, что вы можете довольно легко восстановить поврежденные файлы; вы даже можете создавать свои собственные файлы Scribus без доступа к Scribus! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_scribus  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_scribus" =~ [^10] ]]
do
    :
done
if [[ $in_scribus == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_scribus == 1 ]]; then
  echo ""
  echo " Установка Scribus (scribus) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed scribus  # Программное обеспечение для настольных издательских систем ; https://www.scribus.net/ ; https://archlinux.org/packages/extra/x86_64/scribus/ ; Scribus - Верстка документов
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить AbiWord (abiword) - Текстовый редактор?"
echo -e "${MAGENTA}:: ${BOLD}AbiWord — легковесный, быстрый текстовый процессор для Linux. AbiWord отличается тем, что занимает очень мало места и может работать на слабых компьютерах. Поддерживаются все основные функции работы с текстами. AbiWord подойдет для создания большинства текстовых документов с не очень сложным форматированием, хотя и уступает в функциональности OpenOffice.org Writer или Microsoft Word. Он может импортировать файлы многих форматов, включая Word 97/2000, RTF, Palm, Psion, DocBook и XHTML-документы, и экспортировать в форматы RTF, Palm, Psion, XHTML, Text и LaTeX. Этот вариант собран с использованием gnome-libs. Поддерживается чтение и редактирование форматов OpenOffice, RTF, Microsoft Word и других. Возможности AbiWord можно расширить с помощью плагинов. ${NC}"
echo " Домашняя страница: https://www.abisource.com/ ; (https://archlinux.org/packages/extra/any/gscan2pdf/). "  
echo -e "${MAGENTA}:: ${BOLD}AbiWord - альтернатива популярного текстового редактора Word из пакета Microsoft Office. Программа позволяет набирать и форматировать тексты, рисовать таблицы, вставлять изображения, распечатывать документы и т.д.
Присутствуют весьма полезные возможности - импорт/экспорт файлов MS Word (*.DOC), RTF, HTML и многих других форматов. Встроенные средства проверки орфографии, возможность верстки символов и использования "стилевых" файлов. ${NC}"
echo " Потенциальные пользователи: все, кто не нуждается в монстроидальности интегрированных пакетов типа OpenOffice.org или KOffice. Существует портабл версия — AbiWord Portable для запуска AbiWord с флешки или с любого носителя без установки на компьютер. Исходный код: Open Source (открыт); Языки программирования: C++; Лицензия: GNU GPL v2.0; С 2021 г. программа не развивается (особо), но обновляется. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_abiword  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_abiword" =~ [^10] ]]
do
    :
done
if [[ $in_abiword == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_abiword == 1 ]]; then
  echo ""
  echo " Установка AbiWord (abiword) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed libabw  # Библиотека, анализирующая формат файлов документов AbiWord ; https://wiki.documentfoundation.org/DLP/Libraries/libabw ; https://archlinux.org/packages/extra/x86_64/libabw/
sudo pacman -S --noconfirm --needed abiword  # Полнофункциональный текстовый процессор ; https://gitlab.gnome.org/World/AbiWord ; https://archlinux.org/packages/extra/x86_64/abiword/ ; http://www.abisource.com/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Gnumeric - Табличный процессор...?"
echo -e "${MAGENTA}:: ${BOLD}Gnumeric — быстрый бесплатный табличный процессор для Linux. Gnumeric окажется полезным тому, кому нужен быстрый, занимающий мало места на диске, функциональный табличный процессор. ${NC}"
echo " Домашняя страница: http://www.gnumeric.org/ ; (https://archlinux.org/packages/extra/x86_64/gnumeric/). "  
echo -e "${MAGENTA}:: ${BOLD}Программа поддерживает работу с формулами, которые совместимы с формулами MS Excel. Также, в Gnumeric реализовано более 150 уникальных функций. Gnumeric работает действительно быстро, может открывать очень большие файлы и без задержек рендерить графики и диаграммы. Gnumeric позволяет проводить точные расчеты и анализ данных. Засчет поддержки дополнительных модулей функциональность Gnumeric можно расширять под свои нужды. Gnumeric и его исходный код доступны бесплатно и лицензированы в соответствии с условиями GNU General Public License версии 2 или версии 3 . ${NC}"
echo " Gnumeric позволяет сохранять и читать файлы в нескольких форматах, среди которых MS Excel, HTML, OpenDocument (OpenOffice sxc), CSV. Для своих файлов Gnumeric использует собственный формат (Gnumeric XML — .gnumeric). Для большинства задач Gnumeric вполне может заменить Open Office Calc. " 
echo " Электронные таблицы Gnumeric могут работать под Linux, Windows, Mac OS X и в некоторых других операционных системах. Скорость: Gnumeric быстро запускается и обрабатывает большие электронные таблицы, оставаясь при этом отзывчивым. Точность: Электронная таблица должна вычислять правильный ответ. Встроенные функции и инструменты Gnumeric точны , как обнаружили несколько исследователей. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_gnumeric  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_gnumeric" =~ [^10] ]]
do
    :
done
if [[ $in_gnumeric == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_gnumeric == 1 ]]; then
  echo ""
  echo " Установка Gnumeric "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed gnumeric  # Программа для работы с электронными таблицами GNOME ; http://www.gnumeric.org/ ; https://archlinux.org/packages/extra/x86_64/gnumeric/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##########

clear
echo -e "${MAGENTA}
  <<< Установка утилит для редактирования документов, PDF, DjVus, NFO, DIZ и XPS... , Читалки электронных книг, Словари, Таблицы в Archlinux >>> ${NC}"
# Installation of utilities for editing documents, PDF, Djvu, NFO, DIZ and XPS... , e-book readers, Dictionaries, Tables in Archlinux
echo ""
echo -e "${BLUE}:: ${NC}Установить Xreader - (для просмотра документов PDF, postscript, djvu, xps, dvi и т.д..)?"
echo -e "${MAGENTA}:: ${BOLD}Xreader - простой просмотрщик многостраничных документов. Он может отображать и печатать файлы PostScript (PS), Encapsulated PostScript (EPS), DJVU, DVI, XPS и Portable Document Format (PDF). Это бесплатное программное обеспечение с открытым исходным кодом. Данное программное обеспечение лицензировано в соответствии с GNU GENERAL PUBLIC LICENSE версии 2 от июня 1991 г. ${NC}"
echo " Домашняя страница: https://github.com/linuxmint/xreader ; (https://archlinux.org/packages/extra/x86_64/xreader/ ; https://man.archlinux.org/man/xreader.1.en ; https://wiki.archlinux.org/title/PDF,_PS_and_DjVu ; https://github.com/linuxmint/xreader/blob/master/help/C/xreader.md). "  
echo -e "${MAGENTA}:: ${BOLD}Xreader является производным от Evince — стандартного документального просмотра в GNOME. Он расширяет возможности своего предшественника, добавляя поддержку файлов EPUB. Xreader не позволяет печатать EPUB-файлы или конвертировать их в другие форматы. В нём отсутствуют продвинутые функции, такие как Calibre или Okular. ${NC}"
echo " В число особенностей входят: Закладки; Миниатюры; Полноэкранный режим; Режим презентации; Режим предварительного просмотра. Кроме того, вы можете запустить xreader из командной строки с помощью команды: xreader. " 
echo " Интерфейс Xreader создан для удобства использования и имеет понятный, интуитивно понятный и минималистичный дизайн. Окно Xreader содержит следующие элементы: Строка меню на строке меню содержат все команды, необходимые для работы с документами в приложении. Панель инструментов содержит подмножество команд, к которым можно получить доступ из строки меню. В области отображения отображается документ. В xreader одно и то же действие можно выполнить несколькими способами. Например, открыть документ можно следующими способами: Действие компонента пользовательского интерфейса. Окно — перетащите файл в окно приложения из другого приложения, например файлового менеджера. Разработчик: Клемент Лефевр, Сандер Свирс, Стефано Карапетсас и другие участники. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_xreader  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_xreader" =~ [^10] ]]
do
    :
done
if [[ $in_xreader == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_xreader == 1 ]]; then
  echo ""
  echo " Установка Xreader "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed xreader  # Просмотрщик документов для файлов PDF и Postscript. Проект X-Apps ; https://github.com/linuxmint/xreader ; https://archlinux.org/packages/extra/x86_64/xreader/ ; https://man.archlinux.org/man/xreader.1.en ; https://wiki.archlinux.org/title/PDF,_PS_and_DjVu ; https://github.com/linuxmint/xreader/blob/master/help/C/xreader.md
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed evince  #  Программа просмотра документов (PDF, Postscript, djvu, tiff, dvi, XPS, поддержка SyncTex с gedit, комиксы (cbr, cbz, cb7 и cbt)) ; https://archlinux.org/packages/extra/x86_64/evince/ ; https://apps.gnome.org/ru/Evince/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Okular - (для просмотра документов PDF, postscript, djvu, tiff, dvi и т.д..)?"
echo -e "${MAGENTA}:: ${BOLD}Okular - это универсальный просмотрщик документов, разработанный KDE. Okular работает на нескольких платформах, включая, но не ограничиваясь Linux, Windows, Mac OS X, *BSD и т. д... ${NC}"
echo " Домашняя страница: https://apps.kde.org/okular/ ; (https://archlinux.org/packages/extra/x86_64/okular/). "  
echo -e "${MAGENTA}:: ${BOLD}Возможности: Поддерживается большое число форматов: PDF, PS, Tiff, CHM, DjVu, изображения, DVI (TeX), XPS, художественная книга, комикс, Plucker, EPub, факс, а также (HTML, OpenDocument (ODF), FictionBook, ComicBook, JPEG, PNG, GIF и ряд других растровых форматов). Просмотр документов в формате Markdown. Поддержка добавления аннотаций с форматированием текста аннотации. Комментирование, выделение текста цветом. Предпросмотр миниатюр страниц документа. Добавление закладок. Просмотр информации о цифровой подписи документа. Поиск по документу. Поворот страниц. Поддержка аннотаций. ${NC}"
echo " Режимы просмотра: Одна страница, Разворот, Непрерывный, Обзор. " 
echo " По умолчанию официальная версия Okular подчиняется ограничением DRM, которые могут запрещать копирование, печать или конвертацию некоторых PDF-файлов. Однако, это можно отключить, сняв в настройках флаг - Подчиняться ограничениям DRM." 
echo " Разработку Okular начал Пётр Шиманский (Piotr Szymanski) на Google Summer of Code в 2005 году. Okular с открытым исходным кодом. Лицензия:GNU GPL. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_okular  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_okular" =~ [^10] ]]
do
    :
done
if [[ $in_okular == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_okular == 1 ]]; then
  echo ""
  echo " Установка Okular "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed okular  # Просмотрщик документов ; https://apps.kde.org/okular/ ; https://archlinux.org/packages/extra/x86_64/okular/
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed xpdf  # Средство просмотра файлов формата портативных документов (PDF) ; Xpdf (XpdfReader) — высокопроизводительный просмотрщик PDF-файлов, легко справляющийся даже с огромными PDF-документами. https://archlinux.org/packages/extra/x86_64/xpdf/ ; https://www.xpdfreader.com/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить MuPDF - (для просмотра документов PDF, XPS и EPUB)?"
echo -e "${MAGENTA}:: ${BOLD}MuPDF - это быстрое и мощное решение для управления PDF-файлами и другими форматами документов.${NC}"
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed mupdf  # Легкий просмотрщик PDF и XPS ; https://mupdf.com/ ; https://archlinux.org/packages/extra/x86_64/mupdf/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Master PDF Editor (masterpdfeditor) - Редактирование PDF-документов?"
echo -e "${MAGENTA}:: ${BOLD}Master PDF Editor - это фирменное приложение для редактирования PDF-документов в Linux, Windows и Mac OS. Оно может создавать, редактировать (вставлять текст или изображения), комментировать, просматривать, шифровать и подписывать PDF-документы. В версии 5 Master PDF Editor удалил некоторые функции из своей бесплатной версии, такие как редактирование или добавление текста, вставка изображений и многое другое - при использовании таких инструментов приложение добавляет большой водяной знак к PDF-документу, если пользователи не купят полную версию (около 83 долларов). Мастер PDF Editor не программное обеспечение с открытым исходным кодом. Версия Linux является бесплатной для некоммерческого использования в то время как версия для Windows требует лицензии после 30 дней. ${NC}"
echo " Домашняя страница: https://code-industry.net/free-pdf-editor/ ; (https://aur.archlinux.org/packages/masterpdfeditor). "  
echo -e "${MAGENTA}:: ${BOLD}Мастер PDF Editor является мультиплатформенным приложением написанным в Qt, что позволяет создавать, редактировать и шифровать PDF и XPS файлы. Этот инструмент может быть использован для изменения или добавить текст, вставлять изображения, разделять, объединять или удалять страницы из PDF файлов, а также для аннотирования PDF-файлов, добавления заметок и многое другое. ${NC}"
echo " Особенности Мастер PDF Editor: Изменить каждый элемент в файл PDF; Создание новых PDF и XPS файлы или редактировать существующие; Добавить и / или редактировать закладки в PDF файлов; Шифрование и / или защитить PDF файлы, используя 128-битное шифрование; Преобразование XPS-файлов в PDF; Добавление элементов управления пользовательского интерфейса, такие как кнопки, флажки, списки и т.д., к PDF-файлов; Выделите текст, добавить заметки; Импорт / экспорт PDF-страниц в общих графических форматов, включая BMP, JPG, PNG,, и TIFF; Разделит или объединит PDF файлы; Перемещение страницы и т.д.. " 
echo -e "${CYAN}:: ${NC}Установка Master PDF Editor (masterpdfeditor) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,      0 - НЕТ - Пропустить установку: " in_masterpdfeditor  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_masterpdfeditor" =~ [^10] ]]
do
    :
done
if [[ $in_masterpdfeditor == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_masterpdfeditor == 1 ]]; then
  echo ""
  echo " Установка Master PDF Editor (masterpdfeditor) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed hunspell  # Библиотека и программа для проверки орфографии и морфологического анализатора ; https://github.com/hunspell/hunspell ; https://archlinux.org/packages/extra/x86_64/hunspell/ ; July 2, 2024, 7:40 p.m. UTC
sudo pacman -S --noconfirm --needed hunspell-ru  # Русский словарь для Hunspell ; https://cgit.freedesktop.org/libreoffice/dictionaries/tree/ru_RU ; https://archlinux.org/packages/extra/any/hunspell-ru/ ; 15 июля 2023 г., 8:04 UTC
######## masterpdfeditor ##########
yay -S masterpdfeditor --noconfirm  # Комплексное решение для просмотра, создания и редактирования файлов PDF ; https://aur.archlinux.org/masterpdfeditor.git (только для чтения, нажмите, чтобы скопировать) ; https://code-industry.net/free-pdf-editor/ ; https://aur.archlinux.org/packages/masterpdfeditor ; https://code-industry.net/public/master-pdf-editor-5.9.85-qt5.x86_64-qt_include.tar.gz ; 2024-08-12 14:02 (UTC) ; Ссылка для скачивания изменилась: старая: https://code-industry.net/public/master-pdf-editor-5.9.85.x86_64-qt5_include.tar.gz новая: https://code-industry.net/public/master-pdf-editor-5.9.85-qt5.x86_64-qt_include.tar.gz
#git clone https://aur.archlinux.org/masterpdfeditor.git   # (только для чтения, нажмите, чтобы скопировать)
#cd masterpdfeditor
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf masterpdfeditor 
#rm -Rf masterpdfeditor
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить PDFArranger - (для выполнения различных действий с PDF документами)?"
echo -e "${MAGENTA}:: ${BOLD}PDFArranger - это простая программа для выполнения различных действий с PDF документами (перемещение, удаление, обрезка, поворот страниц в документе, объединение PDF файлов и так далее). ${NC}"
echo " Домашняя страница: https://github.com/pdfarranger/pdfarranger ; (https://archlinux.org/packages/extra/any/pdfarranger/)"  
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed python-pikepdf  # Чтение и запись PDF-файлов с помощью Python на базе qpdf. https://github.com/pikepdf/pikepdf ; https://archlinux.org/packages/extra/x86_64/python-pikepdf/  
sudo pacman -S --noconfirm --needed pdfarranger  # Помогает объединять или разделять PDF-документы, а также вращать, обрезать и переставлять страницы. https://github.com/pdfarranger/pdfarranger ; https://archlinux.org/packages/extra/any/pdfarranger/ 
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить PDF Mix Tool - (для выполнения различных операций редактирования PDF-файлов)?"
echo -e "${MAGENTA}:: ${BOLD}PDF Mix Tool - это простое и легкое приложение, позволяющее выполнять распространенные операции редактирования PDF-файлов. ${NC}"
echo " Домашняя страница: https://scarpetta.eu/pdfmixtool/  ; (https://archlinux.org/packages/extra/x86_64/pdfmixtool/) "  
echo -e "${MAGENTA}:: ${BOLD}PDF Mix Tool (pdfmixtool) - относится ко второй категории. Редакторы PDF-файлов, позволяющие редактировать содержимое (аннотировать, выделять, изменять текст, добавлять/удалять изображения и т. д.). PDF Mix Tool доступен в виде пакетов Snap и Flatpak . Это означает, что вы можете найти его в менеджере программного обеспечения вашего дистрибутива, если он поддерживает любой из этих пакетов. ${NC}"
echo " Основные операции, которые он может выполнять, следующие: Объединить два или более файлов, указав набор страниц для каждого из них; Повернуть страницы; Объединить несколько страниц в одну (N-up), добавлять пустые страницы, удалять страницы и извлекать страницы из файлов PDF. Комбинации всего вышеперечисленного... " 
echo " Кроме того, он также может смешивать файлы, чередуя их страницы, создавать буклеты, добавлять пустые страницы в PDF-файл, удалять страницы из PDF-файла, извлекать страницы из PDF-файла, редактировать информацию PDF-документа. "
echo " Он написан на C++ и зависит только от Qt (версии 5 или 6) и qpdf. PDF Mix Tool — это бесплатное программное обеспечение, распространяемое на условиях лицензии GNU GPLv3. Дополнительную информацию о PDF Mix Tool можно найти на странице проекта GitLab (https://gitlab.com/scarpetta/pdfmixtool) . "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_pdfmixtool  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_pdfmixtool" =~ [^10] ]]
do
    :
done
if [[ $in_pdfmixtool == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_pdfmixtool == 1 ]]; then
  echo ""
  echo " Установка PDF Mix Tool "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed pdfmixtool  # Приложение для разделения, объединения, поворота и смешивания PDF-файлов ; https://scarpetta.eu/pdfmixtool/ ; https://archlinux.org/packages/extra/x86_64/pdfmixtool/
echo " Установка утилит (пакетов) выполнена "
fi
###########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить DiffPDF - (для сравнения двух PDF-файлов)?"
echo -e "${MAGENTA}:: ${BOLD}DiffPDF - это простое и легкое приложение, позволяющее выполнять распространенные операции редактирования PDF-файлов. DiffPDF - это игра слов "разница" и "PDF". Это простая утилита, которая проверяет изменения и различия между двумя файлами PDF. Самое приятное, что DiffPDF имеет небольшой вес. Он требует меньше места для хранения, чем другие инструменты повышения производительности. Более того, DiffPDF является 100% бесплатным. Поэтому вам не придется выкладывать деньги за его использование. ${NC}"
echo " Домашняя страница: http://www.qtrac.eu/diffpdf.html ; (https://pdf.wondershare.com.ru/pdf-knowledge/pdf-diff-linux.html)"  
echo -e "${MAGENTA}:: ${BOLD}Возможно, на вашем компьютере сохранены два очень похожих PDF файла. Разница может быть намеренной. Возможно, один файл предназначен для ваших коллег, а другой - для менеджера или начальника. Проблема в том, что вы не можете запомнить, какая версия какая. Вам может помочь программа для сравнения PDF файлов. Такой программой является DiffPDF. Это позволяет вам сравнивать PDF файлы в Linux. ${NC}"
echo " Основные операции, которые он может выполнять, следующие: Как сравнить PDF на Linux Ubuntu с помощью DiffPDF - Шаг1 Запустите программу DiffPDF. Шаг 2 Импортируйте два PDF файла, которые необходимо сравнить. Они появятся рядом на экране, обозначенные как "Файл 1" и "Файл 2" (https://images.wondershare.com/pdfelement/tips/diffpdf-linux.jpg). Шаг 3 Вы можете сравнивать PDF файлы с помощью слов, символов или графики. Настройте параметры на правой панели в соответствии с вашими предпочтениями. " 
echo " Чтобы сравнить с помощью слов, выберите Текст по адресу Режим сравнения. Это вариант по умолчанию. Чтобы сравнить графики (изображения, графики и т.д.), выберите Внешность по адресу Режим сравнения. Вы также можете использовать Персонаж как Режим сравнения если вы хотите сравнить PDF файлы по символам. Шаг 4 Нажмите Сравнить. "
echo " Преимущества: DiffPDF является бесплатным и не требует регистрации. Он прост в использовании. Сравните два PDF файла всего несколькими щелчками мыши. Предлагает варианты сравнения PDF файлов по словам, внешнему виду или символам. Схема сравнения "бок о бок" позволяет легко увидеть различия между двумя PDF файлами. Недостатки: Он не может сделать ничего, кроме как выделить различия между двумя PDF файлами. Для их редактирования все равно нужен другой инструмент. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_diffpdf  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_diffpdf" =~ [^10] ]]
do
    :
done
if [[ $in_diffpdf == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_diffpdf == 1 ]]; then
  echo ""
  echo " Установка DiffPDF "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed poppler-qt5  # Привязки Poppler Qt5 ; https://poppler.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/poppler-qt5/
sudo pacman -S --noconfirm --needed diffpdf  # Визуальное или текстовое различие файлов PDF ; https://gitlab.com/eang/diffpdf ; https://archlinux.org/packages/extra/x86_64/diffpdf/ ; http://www.qtrac.eu/diffpdf.html ; https://github.com/yuw/diffpdf ; https://pdf.wondershare.com.ru/pdf-knowledge/pdf-diff-linux.html
echo " Установка утилит (пакетов) выполнена "
fi
########### Домашняя страница #################
# Домашняя страница: http://www.qtrac.eu/diffpdf.html
# (Если вам нужен инструмент командной строки для сравнения PDF-файлов, см.
# http://www.qtrac.eu/comparepdf.html.)
# Для сравнения двух или нескольких файлов в Linux есть команда diff. Она может сравнивать как отдельные файлы, так и каталоги. Рассмотрим синтаксис, опции команды diff и несколько примеров использования (https://pingvinus.ru/note/compare-files-diff-in-linux)
# Команда diff имеет следующий синтаксис:
# diff [опции] файлы-или-директории
# Примеры использования команды diff
# Для простого сравнения двух текстовых файлов с именами myfile1 и myfile2 выполним в терминале команду:
# diff myfile1 myfile2
# diff myfile1 myfile2 > changes.diff
# Дополнительную информацию по использованию команды diff в вашей системе Linux вы можете получить, выполнив команду:
# man diff
#############################################

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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed djvulibre  # Библиотека и утилиты для создания, обработки и просмотра документов DjVu (déjà vu) ('дежавю') ; https://archlinux.org/packages/extra/x86_64/djview/ ; https://archlinux.org/packages/extra/x86_64/djvulibre/ ; https://djvu.sourceforge.net/
sudo pacman -S --noconfirm --needed djview  # Просмотрщик документов DjVu ; https://djvu.sourceforge.net/djview4.html ; https://archlinux.org/packages/extra/x86_64/djview/ ; https://archlinux.org/packages/extra/x86_64/djvulibre/ ; https://djvu.sourceforge.net/
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Calibre - (для управления электронными книгами)?"
echo -e "${MAGENTA}:: ${BOLD}Calibre - это менеджер электронных книг — удобное средство для управления электронными книгами.${NC}"
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed fbreader  # Электронная книга для Linux ; https://fbreader.org/ ; https://archlinux.org/packages/extra/x86_64/fbreader/
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Foliate (foliate) - Чтение электронных книг?"
echo -e "${MAGENTA}:: ${BOLD}Foliate — программа для чтения электронных книг. Удобный интерфейс, настраиваемый внешний вид, создание (выделение) аннотаций и закладок. Откройте для себя новую главу в чтении с Foliate, современной программой для чтения электронных книг, разработанной для GNOME. Погрузитесь в интерфейс без отвлекающих факторов с функциями настройки, разработанными в соответствии с вашими уникальными предпочтениями. ${NC}"
echo " Домашняя страница: https://johnfactotum.github.io/foliate/ ; (https://archlinux.org/packages/extra/any/foliate/). "  
echo -e "${MAGENTA}:: ${BOLD}Читайте в постраничном или прокручиваемом режиме. Настройте шрифт, интервалы, поля и цветовую схему. Элементы управления окнами автоматически скрываются, чтобы минимизировать отвлекающие факторы. Переворачивайте страницу с помощью сенсорной панели 1:1 и жестов сенсорного экрана. Просматривайте оглавление или используйте функцию поиска в книге на боковой панели. Находите свой путь в книге с помощью ползунка хода чтения и истории навигации. Ход чтения, закладки и аннотации хранятся в простых файлах JSON, поэтому вы можете легко экспортировать или синхронизировать их с любым инструментом или службой хранения. Ищите слова в Викисловаре и Википедии. Переводите отрывки с помощью Google Translate. Читайте текст вслух с помощью Speech Dispatcher. Foliate поддерживает текст справа налево, вертикальное письмо и книги с фиксированной компоновкой. Наслаждайтесь такими функциями, как автоматическая расстановка переносов, всплывающие сноски и наложения медиа. ${NC}"
echo " Foliate поддерживает следующие форматы электронных книг: .epub; .mobi; .azw; .azw3; .fb2, .fb2.zip; .cbr, .cbz, .cbt, .cb7; .pdf; .txt и т.д.. Книгу во время чтения можно представить в виде: Двухстраничной; Одностраничной; Прокрутка (Scrolled). Доступные темы оформления: Светлая — темный текст на белом фоне. Сепия — пастельный фон и текст коричневого оттенка. Темная — светлый текст на сером фоне. Инвертированная (Invert) — белый текст на черном фоне. Поддерживается выделение аннотаций с возможностью задать цвет выделения, а также добавление произвольной текстовой заметки к каждой аннотации. Все аннотации можно просмотреть в едином списке и перейти к нужной аннотации. Поддерживается экспорт аннотаций в следующие форматы: HTML; JSON; Простой текст. Поддерживается управление горячими клавишами. Все горячие клавиши представлены в отдельном окне. Поддерживается поиск слов в Википедии, словаре и перевод через Google Translate. Также поддерживается: Изменение шрифта и размера шрифта. Изменение междустрочного интервала. Изменение отступов по бокам. Регулировка яркости. Поиск по тексту книги: по всей книге, только по текущей главе. Создание Закладок. Просмотр метаданных книги. Просмотр глав (отдельная панель). Использует: GJS и Epub.js. Интерфейс: GTK. Лицензия: GPLv3. Аннотации и закладки программы сохраняются в директории (формат JSON): ~/.local/share/com.github.johnfactotum.Foliate — для обычной версии. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_foliate  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_foliate" =~ [^10] ]]
do
    :
done
if [[ $in_foliate == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_foliate == 1 ]]; then
  echo ""
  echo " Установка Foliate (foliate) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed foliate  # Простая и современная GTK-читалка электронных книг ; https://johnfactotum.github.io/foliate/ ; https://archlinux.org/packages/extra/any/foliate/ ; 4 апреля 2024 г., 8:11 UTC
echo ""
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
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
echo " При желании catdoc может преобразовывать некоторые символы, не входящие в ASCII, в соответствующие управляющие последовательности TeX и преобразовывать наборы символов из кодовой страницы Windows ANSI в локальную кодовую страницу целевой машины. (Поскольку catdoc — русская программа, по умолчанию она преобразует cp1251 в koi8-r при работе под UNIX и в cp866 при работе под DOS. Catdoc даже не пытается сохранить форматирование символов MS-Word. Его цель — извлечь простой текст и позволить вам его прочитать и, возможно, переформатировать с помощью TeX, согласно правилам TeXnical, о которых большинство пользователей Word даже не слышали. " 
echo -e "${MAGENTA}:: ${BOLD}UnRTF - это программа командной строки, написанная на языке C, которая преобразует документы в формате Rich Text Format (.rtf) в HTML, LaTeX, макросы troff и сам RTF. Преобразуя в HTML, он поддерживает ряд функций Rich Text Format. ${NC}"
echo " Домашняя страница: https://www.gnu.org/software/unrtf/unrtf.html ; (https://archlinux.org/packages/extra/x86_64/unrtf/) "  
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed catdoc  # Конвертер файлов Microsoft Word, Excel, PowerPoint и RTF в текст ; https://www.wagner.pp.ru/~vitus/software/catdoc/ ; https://archlinux.org/packages/extra/x86_64/catdoc/
sudo pacman -S --noconfirm --needed unrtf  # Программа командной строки, конвертирующая документы RTF в другие форматы ; https://www.gnu.org/software/unrtf/unrtf.html ; https://archlinux.org/packages/extra/x86_64/unrtf/
echo " Установка утилит (пакетов) выполнена "
fi
################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Kchmviewer - Просмотрщик файлов .chm (формат файла справки MS HTML)?"
echo -e "${MAGENTA}:: ${BOLD}Kchmviewer — это бесплатный просмотрщик CHM (также известный как MS HTML help) и EPUB с открытым исходным кодом, написанный на C++ для систем Unix, Mac и Windows. В отличие от большинства существующих просмотрщиков CHM для Unix, он использует библиотеку виджетов Trolltech Qt и может быть дополнительно скомпилирован для лучшей интеграции с KDE. Он не требует KDE, но может быть скомпилирован с поддержкой виджетов KDE. Начиная с версии 5.0 он использует API Webkit для отображения содержимого. ${NC}"
echo " Домашняя страница: http://kchmviewer.sourceforge.net/ ; (https://archlinux.org/packages/extra/x86_64/kchmviewer/). "  
echo -e "${MAGENTA}:: ${BOLD}Главное преимущество kchmviewer — лучшая поддержка неанглоязычных языков. В отличие от других просмотрщиков, kchmviewer в большинстве случаев умеет правильно определять кодировку chm-файла и показывать ее. Он корректно показывает индекс и таблицу контекста в файлах справки на русском, испанском, румынском, корейском, китайском и арабском языках, а с новой поисковой системой умеет искать в любом chm-файле, на каком бы языке он ни был написан. ${NC}"
echo " Kchmviewer написан Георгием Юнаевым и распространяется по лицензии GNU General Public License версии 3. Он использует chmlib для обработки CHM-файлов и некоторые идеи из xchm. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_kchmviewer  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_kchmviewer" =~ [^10] ]]
do
    :
done
if [[ $in_kchmviewer == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_kchmviewer == 1 ]]; then
  echo ""
  echo " Установка Kchmviewer "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed chmlib  # Библиотека для работы с файлами формата Microsoft ITSS/CHM ; http://www.jedrea.com/chmlib/ ; https://archlinux.org/packages/extra/x86_64/chmlib/
sudo pacman -S --noconfirm --needed libzip  # Библиотека C для чтения, создания и изменения zip-архивов ; https://libzip.org/ ; https://archlinux.org/packages/extra/x86_64/libzip/
sudo pacman -S --noconfirm --needed qt5-webengine  # Обеспечивает поддержку веб-приложений с использованием проекта браузера Chromium ; https://www.qt.io/ ; https://archlinux.org/packages/extra/x86_64/qt5-webengine/ 
sudo pacman -S --noconfirm --needed kchmviewer  #  Просмотрщик файлов .chm (формат файла справки MS HTML) ; http://kchmviewer.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/kchmviewer/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить HTMLDOC - (для преобразования HTML)?"
echo -e "${MAGENTA}:: ${BOLD}HTMLDOC - преобразует исходные файлы HTML и Markdown или веб-страницы в файлы EPUB, PostScript или PDF с дополнительным оглавлением. Хотя в настоящее время он не поддерживает многие вещи в «современном вебе», такие как каскадные таблицы стилей (CSS), формы, полный Unicode и символы Emoji, он все еще полезен для преобразования HTML-документации, счетов-фактур и отчетов. ${NC}"
echo " Домашняя страница: https://www.msweet.org/htmldoc/ ; (https://archlinux.org/packages/extra/x86_64/htmldoc/). "  
echo -e "${MAGENTA}:: ${BOLD}Он предоставляет удобный графический интерфейс и может быть интегрирован со многими решениями непрерывной интеграции и веб-сервера. ${NC}"
echo " Бинарные файлы предоставлены для Linux® в магазине snapcraft, macOS® (11.0 и выше) на странице загрузки Github и Microsoft Windows® (10 и выше) на странице загрузки Github. Большинство дистрибутивов Linux также предоставляют собственные пакеты. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_kchmviewer  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_kchmviewer" =~ [^10] ]]
do
    :
done
if [[ $in_kchmviewer == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_kchmviewer == 1 ]]; then
  echo ""
  echo " Установка HTMLDOC "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed fltk  # Набор инструментов графического пользовательского интерфейса для X ; https://www.fltk.org/ ; https://archlinux.org/packages/extra/x86_64/fltk/
sudo pacman -S --noconfirm --needed libcups  # OpenPrinting CUPS — клиентские библиотеки и заголовки ; https://openprinting.github.io/cups/ ; https://archlinux.org/packages/extra/x86_64/libcups/
sudo pacman -S --noconfirm --needed libjpeg-turbo  # Кодек изображений JPEG с ускоренным базовым сжатием и декомпрессией ; https://libjpeg-turbo.org/ ; https://archlinux.org/packages/extra/x86_64/libjpeg-turbo/
sudo pacman -S --noconfirm --needed libpng  # Коллекция процедур, используемых для создания графических файлов формата PNG ; http://www.libpng.org/pub/png/libpng.html ; https://archlinux.org/packages/extra/x86_64/libpng/
sudo pacman -S --noconfirm --needed libxpm  # Библиотека растровых изображений X11 ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/libxpm/
sudo pacman -S --noconfirm --needed zlib  # Библиотека сжатия, реализующая метод сжатия deflate, найденный в gzip и PKZIP ; https://www.zlib.net/ ; https://archlinux.org/packages/core/x86_64/zlib/
sudo pacman -S --noconfirm --needed htmldoc  # Программное обеспечение для преобразования HTML ; https://www.msweet.org/htmldoc/ ; https://archlinux.org/packages/extra/x86_64/htmldoc/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo -e "${CYAN}
  <<< Установка программ Распознавание текста для системы Arch Linux >>> ${NC}"
# Installing Text Recognition software for the Arch Linux system
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить gImageReader - (программа для распознавания текста)?"
echo -e "${MAGENTA}:: ${BOLD}gImageReader - программа, предназначенная для распознавания текста (GUI Tesseract). ${NC}"
echo " Домашняя страница: https://github.com/manisandro/gImageReader ; (https://archlinux.org/packages/extra/x86_64/gimagereader-gtk/ ; https://archlinux.org/packages/extra/x86_64/gimagereader-qt/). "  
echo -e "${MAGENTA}:: ${BOLD}gImageReader поддерживает автоматическое определение макета страницы, при этом пользователь может вручную определить и настроить регионы распознавания. Приложение позволяет импортировать изображения с диска, сканирующих устройств, буфера обмена и скриншотов. GImageReader — кроссплатформенный графический интерфейс для системы оптического распознавания символов Tesseract. Программа использует графические библиотеки GTK и написана на языке программирования Python. Лицензия: GNU GPL. Автор: Sandro Mani. ${NC}"
echo " Особенности gImageReader: Поддерживаемые форматы изображений: jpeg, png, tiff, gif, pnm, pcx, bmp. Поддержка формата электронных документов PDF. Возможность выбрать отдельные страницы и диапазон страниц для распознавания. Выделение области с текстом для распознавания. Получение изображения напрямую со сканера. Настройка разрешения, сохранение в формат png. Проверка орфографии. " 
echo " Функции: Импорт PDF-документов и изображений с диска, сканирующих устройств, буфера обмена и снимков экрана; Обрабатывайте несколько изображений и документов за один раз; Ручное или автоматическое определение области распознавания; Распознавание в обычный текст или в документы hOCR; Распознанный текст отображается непосредственно рядом с изображением; Постобработка распознанного текста, включая проверку орфографии; Создание PDF-документов из документов hOCR; Международная языковая поддержка: Weblate (https://hosted.weblate.org/projects/gimagereader/) , Desktop entry (https://github.com/manisandro/gImageReader/blob/master/data/gimagereader.appdata.xml.in). " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить gImageReader (Gtk),   2 - Установить gImageReader (Qt),   0 - НЕТ - Пропустить установку: " in_gimagereader  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_gimagereader" =~ [^120] ]]
do
    :
done
if [[ $in_gimagereader == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_gimagereader == 1 ]]; then
  echo ""
  echo " Установка gImageReader (Gtk) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed gimagereader-common  # Общие файлы для gImageReader ; https://github.com/manisandro/gImageReader ; https://archlinux.org/packages/extra/x86_64/gimagereader-common/
sudo pacman -S --noconfirm --needed gimagereader-gtk  # Интерфейс Gtk для tesseract-ocr ; https://github.com/manisandro/gImageReader ; https://archlinux.org/packages/extra/x86_64/gimagereader-gtk/
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_gimagereader == 2 ]]; then
  echo ""
  echo " Установка gImageReader (Qt) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed gimagereader-common  # Общие файлы для gImageReader ; https://github.com/manisandro/gImageReader ; https://archlinux.org/packages/extra/x86_64/gimagereader-common/
sudo pacman -S --noconfirm --needed gimagereader-qt  # Интерфейс Qt для tesseract-ocr ; https://github.com/manisandro/gImageReader ; https://archlinux.org/packages/extra/x86_64/gimagereader-qt/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##########

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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed ocrfeeder  # Приложение для анализа макета документа GTK и оптического распознавания символов ; https://wiki.gnome.org/Apps/OCRFeeder ; https://archlinux.org/packages/extra/any/ocrfeeder/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Gscan2pdf - (программа для сканирования и обработки документов...)?"
echo -e "${MAGENTA}:: ${BOLD}Gscan2pdf – программа для создания файлов в формате PDF или DjVu из отсканированных документов, которая позволяет выполнять простые операции, такие как обрезка, поворот и удаление страниц. Gscan2pdf может сканировать несколько страниц одновременно. GScan2Pdf работает со сканерами, используя подсистему SANE. Возможности программы: Установка gscan2pdf; Параметры сканирования документа; Работа с отксанированными объектами; Распознавание текстов на сканах; Общие параметры настроек gscan2pdf. ${NC}"
echo " Домашняя страница: http://gscan2pdf.sourceforge.net/ ; (https://archlinux.org/packages/extra/any/gscan2pdf/). "  
echo -e "${MAGENTA}:: ${BOLD}Основные возможности программы:Сканирование и сохранение документов в форматы: pdf, gif, jpeg, png, pnm, ps, tiff, hOCR; Сохранение отдельно выделенных страниц; Импорт файлов следующих форматов: jpg, png, pnm, ppm, pbm, gif, tif, tiff, pdf, djvu, ps, gs2p; Инструменты для минимальной обработки изображений при сканировании: повороты, установка порога, очистка документа, негатив и кадрирование; Встроенная функция распознавания отсканированного документа (OCR - англ. optical character recognition). Для использования OCR необходимо настроить tesseract или Cuneiform. ${NC}"
echo " GScan2Pdf включает в себя минимальный набор инструментов для первоначальной обработки изображений. Но этого будет, как правило, недостаточно, чтобы подготовить к распознаванию картинку документа с текстом, сделанную не сканером, а фотокамерой. Редактор Gimp тоже желательно иметь под рукой при работе с GScan2Pdf. В принципе можно обойтись и без GScan2Pdf, используя для создания цифровых копий бумажных документов программы по отдельности: Xsane, GIMP, Tesseract, Cuneiform, Scan Tailor и другие самостоятельные инструменты. Но в GScan2Pdf эта работа будет более комфортна. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_gscan2pdf  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_gscan2pdf" =~ [^10] ]]
do
    :
done
if [[ $in_gscan2pdf == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_gscan2pdf == 1 ]]; then
  echo ""
  echo " Установка Gscan2pdf "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed imagemagick  # Программа для просмотра и обработки изображений ; Его можно использовать для создания, редактирования, компоновки или преобразования растровых изображений, и он поддерживает широкий спектр форматов файлов , включая JPEG, PNG, GIF, TIFF и Ultra HDR. ; https://www.imagemagick.org/ ; https://archlinux.org/packages/extra/x86_64/imagemagick/  
sudo pacman -S --noconfirm --needed gscan2pdf  # Графический интерфейс с возможностью распознавания текста (OCR) для создания файлов PDF или DjVus из отсканированных документов ; http://gscan2pdf.sourceforge.net/ ; https://archlinux.org/packages/extra/any/gscan2pdf/ ; https://www.printfriendly.com/p/g/TRxVH6
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить GPRename - Массовое переименование файлов...?"
echo -e "${MAGENTA}:: ${BOLD}GPRename — программа для Linux, предназначенная для массового (пакетного) переименования файлов и директорий. Поддерживается вставка, замена, изменение регистра символов, нумерация имен файлов и так далее... ${NC}"
echo " Домашняя страница: https://gprename.sourceforge.net/ ; (https://archlinux.org/packages/extra/any/gprename/ ). "  
echo -e "${MAGENTA}:: ${BOLD}GPRename — это полноценный пакетный переименователь файлов и каталогов, лицензированный в соответствии с условиями GNU General Public License версии 3. ${NC}"
echo " Интерфейс программы довольно простой и разобраться в нем не составит труда. В верхней части располагаются две панели. В левой представлено дерево каталогов, а в правой таблица с двумя колонками. В первой колонке исходное имя файла, а в правой новое имя, которое будет после переименования. Это удобно, так как позволяет до переименования проверить имена файлов. Снизу расположены настройки переименования. Можно задать изменение регистра отдельных букв или всего названия, можно вставлять и удалять символы, есть функция замены одних символов на другие, а также нумерация имен файлов. К сожалению, программа GPRename пока не переведена на русский язык. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_gprename  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_gprename" =~ [^10] ]]
do
    :
done
if [[ $in_gprename == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_gprename == 1 ]]; then
  echo ""
  echo " Установка GPRename "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed pango-perl  # Привязки Perl для Pango ; http://gtk2-perl.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/pango-perl/
sudo pacman -S --noconfirm --needed perl-gtk3  # Интерфейс Perl к серии 3.x инструментария GTK+ ; https://metacpan.org/release/Gtk3 ; https://archlinux.org/packages/extra/any/perl-gtk3/
sudo pacman -S --noconfirm --needed perl-libintl-perl  #Модуль Perl: поддержка локализации ; https://search.cpan.org/dist/libintl-perl ; https://archlinux.org/packages/extra/x86_64/perl-libintl-perl/
sudo pacman -S --noconfirm --needed perl-locale-gettext  # Разрешает доступ из Perl к семейству функций gettext() ; https://search.cpan.org/dist/Locale-gettext/ ; https://archlinux.org/packages/extra/x86_64/perl-locale-gettext/
sudo pacman -S --noconfirm --needed gprename  # Пакетное переименование файлов и каталогов GTK ; https://gprename.sourceforge.net/ ; https://archlinux.org/packages/extra/any/gprename/ 
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#################

clear
echo -e "${MAGENTA}
  <<< Установка программ (пакетов) - для Сравнения файлов Linux с помощью GUI >>> ${NC}"
# Installing programs (packages) - to compare Linux files using the GUI
echo ""
echo -e "${GREEN}==> ${BOLD}Иногда возникает необходимость сравнить несколько файлов между собой. Это может понадобиться при анализе разницы между несколькими версиями конфигурационного файла или просто для сравнения различных файлов. В Linux для этого есть несколько утилит, как для работы через терминал, так и в графическом интерфейсе. Существует несколько отличных инструментов для сравнения файлов в linux в графическом интерфейсе. Вы без труда разберетесь как их использовать. Давайте рассмотрим несколько из них: ${NC}"
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Meld (для сравнения файлов)?"
echo -e "${MAGENTA}:: ${BOLD}Meld - программа для сравнения содержимого текстовых файлов или каталогов. ${NC}"
echo " Сравнение двух-трёх файлов или каталогов. Создание файлов правки (англ. patch file) с описанием различий между файлами. Работа с системами управления версиями Git, Subversion, Mercurial, Bazaar и CVS. Meld поддерживает вкладки и позволяет в одном окне работать сразу с несколькими файлами. "
echo " Это что-то вроде утилиты diff, но в графическом виде с возможностью «сливать» изменения, удалять и восстанавливать файлы. Можно сравнивать как два, так и три файла или каталога одновременно. При сравнении каталогов программа отображает в каких файлах были сделаны изменения, какие файлы были удалены или добавлены, а какие остались без изменений. А если сравнить файлы, тогда слева отобразится один файл, а справа другой, с подсветкой изменений и возможностью быстрого внесения изменений в файлы. "
echo " Это легкий инструмент для сравнения и объединения файлов. Он позволяет сравнивать файлы, каталоги, а также выполнять функции системы контроля версий. Программа создана для разработчиков и позволяет сравнивать до трёх файлов. Можно сравнивать каталоги и автоматически объединять сравниваемые файлы. Кроме того поддерживаются такие системы контроля версий, как Git. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_meld  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_meld" =~ [^10] ]]
do
    :
done
if [[ $in_meld == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_meld == 1 ]]; then
  echo ""
  echo " Установка Meld (сравнение файлов) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed meld  # Сравнение файлов, каталогов и рабочих копий ; https://meldmerge.org/ ; https://archlinux.org/packages/extra/any/meld/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Kompare - (для проверки различий файлов)?"
echo -e "${MAGENTA}:: ${BOLD}Kompare — это программа с графическим интерфейсом, которая позволяет просматривать и объединять различия между исходными файлами. Ее можно использовать для сравнения различий в файлах или содержимом папок, она поддерживает различные форматы diff и предоставляет множество опций для настройки отображаемого уровня информации. ${NC}"
echo " Домашняя страница: https://apps.kde.org/kompare/ ; (https://archlinux.org/packages/extra/x86_64/kompare/). "  
echo -e "${MAGENTA}:: ${BOLD}Kompare - это графическая утилита для работы с diff, которая позволяет находить отличия в файлах, а также объединять их. Написана на Qt и рассчитана в первую очередь на KDE. Кроме сравнения файлов утилита поддерживает сравнение каталогов и позволяет создавать и применять патчи к файлам. ${NC}"
echo " Функции: Рекурсивное сравнение различий в файлах или содержимом папок. Поддерживает различные форматы различий и предоставляет множество возможностей для настройки уровня отображаемой информации. Создание и применение патчей. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_kompare  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_kompare" =~ [^10] ]]
do
    :
done
if [[ $in_kompare == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_kompare == 1 ]]; then
  echo ""
  echo " Установка Kompare "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed libkomparediff2  # Библиотека для сравнения файлов и строк ; https://www.kde.org/ ; https://archlinux.org/packages/extra/x86_64/libkomparediff2/
sudo pacman -S --noconfirm --needed kompare  # Графический инструмент для проверки различий файлов ; https://apps.kde.org/kompare/ ; https://archlinux.org/packages/extra/x86_64/kompare/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Recoll - Полнотекстовый поиск на вашем рабочем столе?"
echo -e "${MAGENTA}:: ${BOLD}Recoll - находит документы по их содержимому , а также по именам файлов. Он может искать в большинстве форматов документов . Вам могут понадобиться внешние приложения для извлечения текста. Он может достичь любого места хранения: файлов, членов архива, вложений электронной почты, прозрачно выполняя распаковку. Одним щелчком мыши можно открыть документ в собственном редакторе или отобразить еще более быстрый предварительный просмотр текста. Веб -интерфейс с функциями предварительного просмотра и загрузки может заменить или дополнить графический интерфейс для удаленного использования. Recoll основан на мощной библиотеке поисковой системы Xapian (http://www.xapian.org/), для которой он предоставляет мощный уровень извлечения текста и полный, но простой в использовании графический интерфейс Qt. Xapian — это библиотека поисковой системы с открытым исходным кодом, выпущенная под лицензией GPL v2+ . Она написана на C++ с привязками , позволяющими использовать Perl Python 2 , Python 3 , PHP , Java , Tcl , C# , Ruby , Lua , Erlang , Node.js и R (пока!). Xapian — это высокоадаптируемый набор инструментов, который позволяет разработчикам легко добавлять расширенные возможности индексации и поиска в свои собственные приложения. Он имеет встроенную поддержку нескольких семейств моделей взвешивания, а также поддерживает богатый набор булевых операторов запросов. ${NC}"
echo " Домашняя страница: https://www.recoll.org/ ; (https://archlinux.org/packages/extra/x86_64/recoll/). "  
echo -e "${MAGENTA}:: ${BOLD}Recoll проиндексирует документ MS-Word , сохраненный как вложение к сообщению электронной почты внутри папки Thunderbird , заархивированной в Zip-файл (и многое другое…). Он также поможет вам найти его с помощью удобного и мощного интерфейса и позволит вам открыть копию PDF на нужной странице двумя щелчками. Мало что останется скрытым на вашем диске. ${NC}"
echo " Доступны версии для Linux , MS Windows и MacOS . Программное обеспечение бесплатно для Linux, имеет открытый исходный код и распространяется по лицензии GPL. Подробные характеристики и требования к приложениям для поддерживаемых типов документов (https://www.recoll.org/pages/features.html). Recoll имеет обширную документацию (https://www.recoll.org/pages/documentation.html). " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_recoll  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_recoll" =~ [^10] ]]
do
    :
done
if [[ $in_recoll == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_recoll == 1 ]]; then
  echo ""
  echo " Установка Recoll "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed aspell  # Проверка орфографии, призванная в конечном итоге заменить Ispell ; http://aspell.net/ ; https://archlinux.org/packages/extra/x86_64/aspell/
sudo pacman -S --noconfirm --needed chmlib  # Библиотека для работы с файлами формата Microsoft ITSS/CHM ; http://www.jedrea.com/chmlib/ ; https://archlinux.org/packages/extra/x86_64/chmlib/
sudo pacman -S --noconfirm --needed openssl  # Набор инструментов с открытым исходным кодом для Secure Sockets Layer и Transport Layer Security ; https://www.openssl.org/ ; https://archlinux.org/packages/core/x86_64/openssl/
sudo pacman -S --noconfirm --needed recoll  # Инструмент полнотекстового поиска на основе бэкэнда Xapian ; https://www.recoll.org/ ; https://archlinux.org/packages/extra/x86_64/recoll/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#####################

clear
echo -e "${MAGENTA}
  <<< Установка программ Наука и образование / Электронные словари в Archlinux >>> ${NC}"
# Installing Science and Education programs / Electronic dictionaries in Archlinux
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Dialect (dialect) - Приложение-переводчик для GNOME?"
echo -e "${MAGENTA}:: ${BOLD}Dialect — это приложение для перевода между языками, созданное для настольных компьютеров Linux. Оно написано на GTK4/libadwaita и использует ряд различных онлайн-сервисов перевода, но по умолчанию использует вездесущий, но хорошо зарекомендовавший себя сервис перевода Google Translate из коробки. Таким образом, Dialect способен переводить текст на более чем 100 языков и обратно прямо с рабочего стола. Для работы приложения необходимо активное подключение к Интернету. Если вы не поклонник Google, вы можете переключиться на API LibreTranslate , с приложением, позволяющим вам использовать любой публичный экземпляр. Он также поддерживает перевод на основе открытого исходного кода Lingva Translate, опять же с любым экземпляром, который вы предпочитаете. ${NC}"
echo " Домашняя страница: https://apps.gnome.org/Dialect ; (https://aur.archlinux.org/packages/dialect). "  
echo -e "${MAGENTA}:: ${BOLD}Dialect включает в себя удобный «переключатель», позволяющий делать обратные переводы без копирования/вставки, и имеет внушительную память, позволяющую перелистывать сделанные вами переводы назад/вперед. Завершают его полезность кнопки «копировать» в обоих текстовых модулях, которые позволяют мгновенно копировать содержимое в буфер обмена, готовый к вставке в другом месте. Этот интерфейс позволяет вам переводить между языками. Поскольку это современное приложение GTK4, использующее libadwaita, оно прекрасно масштабируется между альбомной и портретной ориентацией, автоматически подстраиваясь под любую доступную ширину экрана. ${NC}"
echo " Функции: Перевод на основе Google Translate. Перевод на основе API LibreTranslate, позволяющий использовать любой публичный экземпляр. Перевод на основе API Lingva Translate. Перевод на основе Bing. Перевод на основе Яндекс. Доступен прямой перевод, хотя программа предупреждает, что ваш IP-адрес может быть заблокирован за злоупотребление API. Преобразование текста в речь. История переводов. Автоматическое определение языка. Кнопки буфера обмена. Это бесплатное программное обеспечение с открытым исходным кодом. Разработчик: The Dialect Авторская; лицензия: GNU General Public License v3.0 " 
echo -e "${CYAN}:: ${NC}Установка Dialect (dialect) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_dialect  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_dialect" =~ [^10] ]]
do
    :
done
if [[ $in_dialect == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_dialect == 1 ]]; then
  echo ""
  echo " Установка Dialect (dialect) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
######### dialect ########
yay -S dialect --noconfirm  # Приложение-переводчик для GNOME ; https://aur.archlinux.org/dialect.git (только для чтения, нажмите, чтобы скопировать) ; https://apps.gnome.org/Dialect ; https://aur.archlinux.org/packages/dialect ; git+https://github.com/dialect-app/po.git ; 2024-07-29 16:06 (UTC)
#git clone https://aur.archlinux.org/dialect.git   # (только для чтения, нажмите, чтобы скопировать)
#cd dialect
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf dialect
#rm -Rf dialect
######### dialect-git ########
# yay -S dialect-git --noconfirm  # Приложение-переводчик для GNOME ; https://aur.archlinux.org/dialect-git.git (только для чтения, нажмите, чтобы скопировать) ; https://apps.gnome.org/Dialect ; https://aur.archlinux.org/packages/dialect-git ; 2024-05-14 22:18 (UTC) ; Конфликты: с dialect ; Смотрите Зависимости !
#git clone https://aur.archlinux.org/dialect-git.git   # (только для чтения, нажмите, чтобы скопировать)
#cd dialect-git
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf dialect-git
#rm -Rf dialect-git
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Crow Translate (crow-translate) - Легковесный переводчик от KDE?"
echo -e "${MAGENTA}:: ${BOLD}Crow Translate – это инструмент языка и перевода, разработанный для предоставления наиболее точных переводов с помощью Google, Яндекс и Bing переводят API. Этот легкий инструмент с открытым исходным кодом написан на C++/Qt и позволяет переводить и даже произносить текст 😃. ${NC}"
echo " Домашняя страница: https://github.com/crow-translate/crow-translate ; (https://invent.kde.org/office/crow-translate ; https://aur.archlinux.org/packages/crow-translate). "  
echo -e "${MAGENTA}:: ${BOLD}Он предлагает простой и минималистичный пользовательский интерфейс, который разделен на две панели: на левой панели вы будете размещать исходный текст, а на правой панели будет отображается перевод. Функции: Множество движков перевода, предоставляемых Mozhi (в некоторых случаях могут быть отключены определенные движки). Переводите и озвучивайте текст с экрана или выделенного фрагмента. Гибко настраиваемые сочетания клавиш. Интерфейс командной строки с богатыми возможностями. API D-Bus. Кроссплатформенный. Приложение, написанное на C++ / Qt , которое позволяет переводить и озвучивать текст с помощью Mozhi. ⚠ *Хотя Mozhi действует как прокси-сервер для защиты вашей конфиденциальности, используемые им сторонние сервисы могут хранить и анализировать отправляемый вами текст. ${NC}"
echo " Его особенности: программа потребляет всего ~20 МБ ОЗУ; лицензирована под лицензией GPL v3, а значит вы можете использовать и модифицировать ее абсолютно бесплатно; благодаря Google, Yandex и Bing вы можете переводить на 117 различных языков; вы можете переводить текст как в графической среде, так и прямо в терминале (консоли); переводите и озвучивайте текст с экрана или выделенного фрагмента; доступна для Linux и Windows. " 
echo -e "${CYAN}:: ${NC}Установка Crow Translate (crow-translate) и (crow-translate-git) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! 📦 "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить Crow Translate (crow-translate),   2 - Установить Crow Translate (crow-translate-git), 

    0 - НЕТ - Пропустить установку: " in_crowtranslate  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_crowtranslate" =~ [^120] ]]
do
    :
done
if [[ $in_crowtranslate == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_crowtranslate == 1 ]]; then
  echo ""
  echo " Установка Crow Translate (crow-translate) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed qt5ct  # Утилита настройки Qt 5 ; https://qt5ct.sourceforge.io/ ; https://archlinux.org/packages/extra/x86_64/qt5ct/ ; Эта программа позволяет пользователям настраивать параметры Qt5 (тему, шрифт, значки и т. д.) под DE/WM без интеграции Qt ; 12 июля 2024 г., 14:44 UTC
sudo pacman -S --noconfirm --needed qt6ct  # Утилита настройки Qt 6 ; https://github.com/trialuser02/qt6ct ; https://archlinux.org/packages/extra/x86_64/qt6ct/ ; Эта программа позволяет пользователям настраивать параметры Qt6 (тему, шрифт, значки и т. д.) под DE/WM без интеграции Qt.
#yay -S adwaita-qt5 --noconfirm  # Стиль, позволяющий приложениям Qt5 выглядеть так, будто они принадлежат оболочке GNOME ; https://aur.archlinux.org/adwaita-qt.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/FedoraQt/adwaita-qt ; https://aur.archlinux.org/packages/adwaita-qt5 ; 2024-07-14 10:54 (UTC) ; Заменяет: adwaita-qt
#yay -S adwaita-qt6 --noconfirm  # Стиль, позволяющий приложениям Qt6 выглядеть так, будто они принадлежат оболочке GNOME ; https://aur.archlinux.org/adwaita-qt.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/FedoraQt/adwaita-qt ; https://aur.archlinux.org/packages/adwaita-qt6 ; 2024-07-14 10:54 (UTC)
# sudo pamac build crow-translate  # Crow Translate доступен в репозитории AUR. Для этого достаточно выполнить команду
######## crow-translate ########
yay -S crow-translate --noconfirm  # Простой и легкий переводчик, позволяющий переводить и озвучивать текст с помощью Google, Yandex, Bing, LibreTranslate и Lingva ; https://aur.archlinux.org/crow-translate.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/crow-translate/crow-translate ; https://aur.archlinux.org/packages/crow-translate ; https://invent.kde.org/office/crow-translate ; 2024-01-16 13:16 (UTC) ; https://github.com/crow-translate/crow-translate/releases/download/2.11.1/crow-translate-2.11.1-source.tar.gz
#git clone https://aur.archlinux.org/crow-translate.git  # (только для чтения, нажмите, чтобы скопировать)
#cd crow-translate
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf crow-translate 
#rm -Rf crow-translate
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_crowtranslate == 2 ]]; then
  echo ""
  echo " Установка Crow Translate (crow-translate-git) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed qt5ct  # Утилита настройки Qt 5 ; https://qt5ct.sourceforge.io/ ; https://archlinux.org/packages/extra/x86_64/qt5ct/ ; Эта программа позволяет пользователям настраивать параметры Qt5 (тему, шрифт, значки и т. д.) под DE/WM без интеграции Qt ; 12 июля 2024 г., 14:44 UTC
sudo pacman -S --noconfirm --needed qt6ct  # Утилита настройки Qt 6 ; https://github.com/trialuser02/qt6ct ; https://archlinux.org/packages/extra/x86_64/qt6ct/ ; Эта программа позволяет пользователям настраивать параметры Qt6 (тему, шрифт, значки и т. д.) под DE/WM без интеграции Qt.
#yay -S adwaita-qt5 --noconfirm  # Стиль, позволяющий приложениям Qt5 выглядеть так, будто они принадлежат оболочке GNOME ; https://aur.archlinux.org/adwaita-qt.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/FedoraQt/adwaita-qt ; https://aur.archlinux.org/packages/adwaita-qt5 ; 2024-07-14 10:54 (UTC) ; Заменяет: adwaita-qt
#yay -S adwaita-qt6 --noconfirm  # Стиль, позволяющий приложениям Qt6 выглядеть так, будто они принадлежат оболочке GNOME ; https://aur.archlinux.org/adwaita-qt.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/FedoraQt/adwaita-qt ; https://aur.archlinux.org/packages/adwaita-qt6 ; 2024-07-14 10:54 (UTC)
######## crow-translate-git ########
yay -S crow-translate-git --noconfirm  # Простой и легкий переводчик, позволяющий переводить и озвучивать текст с помощью Google, Yandex, Bing, LibreTranslate и Lingva ; https://aur.archlinux.org/crow-translate-git.git (только для чтения, нажмите, чтобы скопировать) ; https://invent.kde.org/office/crow-translate ; https://aur.archlinux.org/packages/crow-translate-git ;   2024-07-04 22:48 (UTC) ; Конфликты: с crow-translate
#git https://aur.archlinux.org/crow-translate-git.git  # (только для чтения, нажмите, чтобы скопировать)
#cd crow-translate-git
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf crow-translate-git 
#rm -Rf crow-translate-git
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########## Дополнение ###########
# Чтобы приложение выглядело нативно и без отсутствующих значков в окружении рабочего стола, отличного от KDE, вам необходимо настроить стили приложений Qt. Это можно сделать с помощью qt5ct или adwaita-qt5 или qtstyleplugins. Пожалуйста, проверьте соответствующее руководство по установке для вашего дистрибутива.
# sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -S --noconfirm --needed qt5ct  # Утилита настройки Qt 5 ; https://qt5ct.sourceforge.io/ ; https://archlinux.org/packages/extra/x86_64/qt5ct/ ; Эта программа позволяет пользователям настраивать параметры Qt5 (тему, шрифт, значки и т. д.) под DE/WM без интеграции Qt ; 12 июля 2024 г., 14:44 UTC
# sudo pacman -S --noconfirm --needed qt6ct  # Утилита настройки Qt 6 ; https://github.com/trialuser02/qt6ct ; https://archlinux.org/packages/extra/x86_64/qt6ct/ ; Эта программа позволяет пользователям настраивать параметры Qt6 (тему, шрифт, значки и т. д.) под DE/WM без интеграции Qt.
# yay -S adwaita-qt5 --noconfirm  # Стиль, позволяющий приложениям Qt5 выглядеть так, будто они принадлежат оболочке GNOME ; https://aur.archlinux.org/adwaita-qt.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/FedoraQt/adwaita-qt ; https://aur.archlinux.org/packages/adwaita-qt5 ; 2024-07-14 10:54 (UTC) ; Заменяет: adwaita-qt
# yay -S adwaita-qt6 --noconfirm  # Стиль, позволяющий приложениям Qt6 выглядеть так, будто они принадлежат оболочке GNOME ; https://aur.archlinux.org/adwaita-qt.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/FedoraQt/adwaita-qt ; https://aur.archlinux.org/packages/adwaita-qt6 ; 2024-07-14 10:54 (UTC)
###########################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Gtranslator (GNOME Translation Editor) (gtranslator) - Редактор переводов?"
echo -e "${MAGENTA}:: ${BOLD}GNOME Translation Editor (Ранее известный как Gtranslator) — это улучшенный редактор po-файлов gettext для среды рабочего стола GNOME. Он обрабатывает все формы po-файлов gettext и включает в себя очень полезные функции, такие как Find/Replace, Translation Memory, различные профили переводчиков, таблицу сообщений (для обзора переводов/сообщений в po-файле), простую навигацию и редактирование сообщений перевода и комментариев к переводу, если они точны. ${NC}"
echo " Домашняя страница: https://wiki.gnome.org/Apps/Gtranslator ; (https://archlinux.org/packages/extra/x86_64/gtranslator/)."  
echo -e "${MAGENTA}:: ${BOLD}Это программное обеспечение для редактирования переводов произвело революцию в моем подходе к работе над проектами локализации. Оно эффективно, просто в использовании и предлагает все функции, необходимые мне для выполнения работы! Пользовательский интерфейс чистый и интуитивно понятный, что делает его простым в навигации и использовании. Программное обеспечение также предлагает широкий спектр функций, которые необходимы для любого проекта перевода. Очевидно, что много мыслей и усилий было вложено в разработку этого инструмента, и это, безусловно, видно. Да, это программное обеспечение универсально и может работать с проектами любого размера. Да, это программное обеспечение поддерживает широкий спектр языков, что делает его пригодным для разнообразных проектов локализации. Да, это программное обеспечение предлагает инструменты для совместной работы, которые упрощают работу с другими переводчиками над одним проектом. ${NC}"
echo " Функции: Откройте несколько файлов PO во вкладках; Поддержка форм множественного числа; Автоматическое обновление заголовков; Редактирование комментариев; Управление различными профилями переводчиков; Переводы воспоминаний; Помощник по настройке начального профиля и ТМ; Диалог поиска и быстрая навигация по сообщениям; Выделение пробелов и синтаксиса сообщений. Он поддерживает использование памяти переводов, подсветку синтаксиса, проверку орфографии, отмену вставок и удалений, а также общую интеграцию с рабочим столом GNOME. Основные характеристики: Интуитивно понятный пользовательский интерфейс; Широкий спектр возможностей; Простая навигация; Эффективный процесс перевода; Отлично подходит для проектов локализации. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_gtranslator  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_gtranslator" =~ [^10] ]]
do
    :
done
if [[ $in_gtranslator == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_gtranslator == 1 ]]; then
  echo ""
  echo " Установка GNOME Translation Editor (gtranslator) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed gettext  # Библиотека интернационализации GNU ; https://www.gnu.org/software/gettext/ ; https://archlinux.org/packages/core/x86_64/gettext/ ; https://www.gnu.org/software/gettext/manual/index.html ; https://www.gnu.org/software/gettext/libasprintf/manual/index.html ; https://www.gnu.org/software/gettext/libtextstyle/manual/index.html ; May 16, 2024, 3:45 p.m. UTC
sudo pacman -S --noconfirm --needed gtranslator  # Расширенный редактор po-файлов gettext для среды рабочего стола GNOME ; https://wiki.gnome.org/Apps/Gtranslator ; https://archlinux.org/packages/extra/x86_64/gtranslator/  ; https://gitlab.gnome.org/GNOME/gtranslator.git ; 22 апреля 2024 г., 23:22 UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
###############

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить GoldenDict (goldendict) - Оболочка для электронных словарей?"
echo -e "${MAGENTA}:: ${BOLD}GoldenDict — оболочка для электронных словарей. Поддерживает популярные форматы словарей ABBYY Lingvo, StarDict, Википедии и другие. Целью проекта является создание многофункциональной программы поиска в словаре. Программа GoldenDict доступна для Linux и Windows. ${NC}"
echo " Домашняя страница: https://github.com/goldendict/goldendict ; (https://aur.archlinux.org/packages/goldendict?all_deps=1#pkgdeps ; https://aur.archlinux.org/packages/goldendict-ng). "  
echo -e "${MAGENTA}:: ${BOLD}Она поддерживает несколько форматов словарей, рендеринг статей с сохранением полной разметки, иллюстраций и другого контента, а также позволяет вводить слова без акцентов или правильного регистра. ${NC}"
echo " Программа имеет следующие возможности: Использование WebKit для точного представления статей со всем форматированием, цветами, изображениями и ссылками. Поддержка нескольких форматов файлов словарей, а именно: Файлы Babylon .BGL, содержащие изображения и ресурсы; Словари StarDict .ifo/.dict./.idx/.syn; Файлы словаря Dictd .index/.dict(.dz); Исходные файлы ABBYY Lingvo .dsl вместе с сокращениями. Файлы могут быть опционально сжаты с помощью dictzip. Ресурсы словаря могут быть упакованы вместе в файл .zip. Аудиоархивы ABBYY Lingvo .lsa/.dat. Их можно индексировать отдельно или ссылаться на них из файлов .dsl. Поддержка Википедии, Викисловаря и любых других сайтов на базе MediaWiki для выполнения поиска. Возможность использования произвольных веб-сайтов в качестве словарей с помощью шаблонных URL-адресов. Возможность запуска произвольных внешних программ для воспроизведения звука или генерации контента (преобразование текста в речь, страницы руководства и т. д.) (используйте для этого последнюю версию Git). Поддержка поиска и прослушивания произношений с forvo.com . Система морфологии на основе Hunspell, используемая для поиска корней слов и рекомендаций по написанию. Возможность индексировать произвольные каталоги с аудиофайлами для поиска произношения. Полный регистр Unicode, диакритические знаки, пунктуация и сворачивание пробелов. Это означает возможность вводить слова без ударений, правильного регистра, пунктуации или пробелов (например, ввод «Grussen» даст «grüßen» в немецких словарях). Функция сканирования всплывающих окон. Появляется небольшое окно с переводом слова, выбранного из другого приложения. Поддержка глобальных горячих клавиш. Вы можете вызвать окно программы в любой момент или напрямую перевести слово из буфера обмена. Вкладки в современном интерфейсе Qt 4. Кроссплатформенность: Linux/X11 и Windows + переносимость на другие платформы. Бесплатное программное обеспечение: лицензия GNU GPLv3+ . " 
echo -e "${CYAN}:: ${NC}Установка GoldenDict (goldendict) и (goldendict-ng) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить GoldenDict (goldendict),    2 - Установить GoldenDict (goldendict-ng),   

    0 - НЕТ - Пропустить установку: " in_goldendict  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_goldendict" =~ [^120] ]]
do
    :
done
if [[ $in_goldendict == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_goldendict == 1 ]]; then
  echo ""
  echo " Установка GoldenDict (goldendict) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
####### Зависимости ############
sudo pacman -S --noconfirm --needed ffmpeg  # Комплексное решение для записи, конвертации и потоковой передачи аудио и видео ; https://ffmpeg.org/ ; https://archlinux.org/packages/extra/x86_64/ffmpeg/ ; 19 августа 2024 г., 21:29 UTC
sudo pacman -S --noconfirm --needed hunspell  # Библиотека и программа для проверки орфографии и морфологического анализатора ; https://github.com/hunspell/hunspell ; https://archlinux.org/packages/extra/x86_64/hunspell/ ; July 2, 2024, 7:40 p.m. UTC
sudo pacman -S --noconfirm --needed hunspell-ru  # Русский словарь для Hunspell ; https://cgit.freedesktop.org/libreoffice/dictionaries/tree/ru_RU ; https://archlinux.org/packages/extra/any/hunspell-ru/ ; 15 июля 2023 г., 8:04 UTC
####### libeb ############
yay -S libeb --noconfirm  # Библиотека C для доступа к книгам на CD-ROM. Поддерживает форматы EB, EBG, EBXA, EBXA-C, S-EBXA и EPWING ; Этот пакет теперь заменяет eb-library, поскольку он был удален ; https://aur.archlinux.org/libeb.git (только для чтения, нажмите, чтобы скопировать) ; http://www.mistys-internet.website/eb/index-en.html ; https://aur.archlinux.org/packages/libeb ; 2024-05-23 11:01 (UTC) ; Конфликты: с eb-library
######### qt5-webkit ########
yay -S qt5-webkit --noconfirm  # Классы для реализации на базе WebKit2 и нового API QML ; https://aur.archlinux.org/qt5-webkit.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/qtwebkit/qtwebkit ; https://aur.archlinux.org/packages/qt5-webkit ; 2024-05-28 16:39 (UTC)
######## goldendict ##########
yay -S goldendict --noconfirm  # Многофункциональная программа поиска в словаре, поддерживающая несколько форматов словарей ; https://aur.archlinux.org/goldendict.git (только для чтения, нажмите, чтобы скопировать) ; https://aur.archlinux.org/packages/goldendict?all_deps=1#pkgdeps ; https://github.com/goldendict/goldendict ; 2024-06-28 10:55 (UTC) ; Смотрите Зависимости !
#git clone https://aur.archlinux.org/goldendict.git   # (только для чтения, нажмите, чтобы скопировать)
#cd goldendict
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf goldendict 
#rm -Rf goldendict
##### gd-tools-git ##########
#yay -S gd-tools-git --noconfirm  # Набор полезных программ для улучшения goldendict для обучения методом погружения ; https://aur.archlinux.org/gd-tools-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/Ajatt-Tools/gd-tools ; https://aur.archlinux.org/packages/gd-tools-git ; 2024-03-18 20:46 (UTC) ; Конфликты: с gd-tools
######## stardict ###########
# sudo pacman -S --noconfirm --needed stardict  # gtk3 Международное словарное программное обеспечение ; http://stardict-4.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/stardict/ ; 4 апреля 2024 г., 1:49 UTC
sudo pacman -S --noconfirm --needed sdcv  # Консольная версия StarDict ; https://dushistov.github.io/sdcv/ ; https://archlinux.org/packages/extra/x86_64/sdcv/ ; 13 июля 2024 г., 21:02 UTC
sudo pacman -S --noconfirm --needed qstardict  # Qt5-клон StarDict с полной поддержкой словарей StarDict ; http://qstardict.ylsoftware.com/index.php ; https://archlinux.org/packages/extra/x86_64/qstardict/ ; 24 декабря 2023 г., 23:57 UTC
sudo pacman -S --noconfirm --needed dictd  # Клиент и сервер онлайн-словаря ; https://sourceforge.net/projects/dict/ ; https://archlinux.org/packages/extra/x86_64/dictd/ ; 23 сентября 2023 г., 16:17 UTC
yay -S qtrans --noconfirm  # QTrans — переводчик слов для Qt5/KF5. Использует словари Babylon (*.dic) и переводит многие языки ; https://aur.archlinux.org/qtrans.git (только для чтения, нажмите, чтобы скопировать) ; https://www.linux-apps.com/p/1127419/ ; https://aur.archlinux.org/packages/qtrans ; https://sourceforge.net/projects/qtrans0/files/kf5/0.3.3/qtrans-0.3.3.tar.gz ; 2024-03-16 16:11 (UTC) ; Как перевести текст, смотрите на сайте (скриншоты) https://sourceforge.net/projects/qtrans0/
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_goldendict == 2 ]]; then
  echo ""
  echo " Установка GoldenDict (goldendict-ng) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
####### Зависимости ############
sudo pacman -S --noconfirm --needed ffmpeg  # Комплексное решение для записи, конвертации и потоковой передачи аудио и видео ; https://ffmpeg.org/ ; https://archlinux.org/packages/extra/x86_64/ffmpeg/ ; 19 августа 2024 г., 21:29 UTC
sudo pacman -S --noconfirm --needed hunspell  # Библиотека и программа для проверки орфографии и морфологического анализатора ; https://github.com/hunspell/hunspell ; https://archlinux.org/packages/extra/x86_64/hunspell/ ; July 2, 2024, 7:40 p.m. UTC
sudo pacman -S --noconfirm --needed hunspell-ru  # Русский словарь для Hunspell ; https://cgit.freedesktop.org/libreoffice/dictionaries/tree/ru_RU ; https://archlinux.org/packages/extra/any/hunspell-ru/ ; 15 июля 2023 г., 8:04 UTC
####### libeb ############
yay -S libeb --noconfirm  # Библиотека C для доступа к книгам на CD-ROM. Поддерживает форматы EB, EBG, EBXA, EBXA-C, S-EBXA и EPWING ; Этот пакет теперь заменяет eb-library, поскольку он был удален ; https://aur.archlinux.org/libeb.git (только для чтения, нажмите, чтобы скопировать) ; http://www.mistys-internet.website/eb/index-en.html ; https://aur.archlinux.org/packages/libeb ; 2024-05-23 11:01 (UTC) ; Конфликты: с eb-library
######## goldendict-ng ##########
yay -S goldendict-ng --noconfirm  # GoldenDict нового поколения (поддерживает Qt WebEngine и Qt6) ; https://aur.archlinux.org/goldendict-ng.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/xiaoyifang/goldendict-ng ; https://aur.archlinux.org/packages/goldendict-ng ; 2024-06-28 19:34 (UTC) ; Конфликты: с goldendict, goldendict-git, goldendict-git-opt, goldendict-ng-git, goldendict-svn
#git clone https://aur.archlinux.org/goldendict-ng.git   # (только для чтения, нажмите, чтобы скопировать)
#cd goldendict-ng
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf goldendict-ng 
#rm -Rf goldendict-ng
##### gd-tools-git ##########
#yay -S gd-tools-git --noconfirm  # Набор полезных программ для улучшения goldendict для обучения методом погружения ; https://aur.archlinux.org/gd-tools-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/Ajatt-Tools/gd-tools ; https://aur.archlinux.org/packages/gd-tools-git ; 2024-03-18 20:46 (UTC) ; Конфликты: с gd-tools
######## stardict ###########
sudo pacman -S --noconfirm --needed stardict  # gtk3 Международное словарное программное обеспечение ; http://stardict-4.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/stardict/ ; 4 апреля 2024 г., 1:49 UTC
sudo pacman -S --noconfirm --needed sdcv  # Консольная версия StarDict ; https://dushistov.github.io/sdcv/ ; https://archlinux.org/packages/extra/x86_64/sdcv/ ; 13 июля 2024 г., 21:02 UTC
#sudo pacman -S --noconfirm --needed qstardict  # Qt5-клон StarDict с полной поддержкой словарей StarDict ; http://qstardict.ylsoftware.com/index.php ; https://archlinux.org/packages/extra/x86_64/qstardict/ ; 24 декабря 2023 г., 23:57 UTC
sudo pacman -S --noconfirm --needed dictd  # Клиент и сервер онлайн-словаря ; https://sourceforge.net/projects/dict/ ; https://archlinux.org/packages/extra/x86_64/dictd/ ; 23 сентября 2023 г., 16:17 UTC
#yay -S qtrans --noconfirm  # QTrans — переводчик слов для Qt5/KF5. Использует словари Babylon (*.dic) и переводит многие языки ; https://aur.archlinux.org/qtrans.git (только для чтения, нажмите, чтобы скопировать) ; https://www.linux-apps.com/p/1127419/ ; https://aur.archlinux.org/packages/qtrans ; https://sourceforge.net/projects/qtrans0/files/kf5/0.3.3/qtrans-0.3.3.tar.gz ; 2024-03-16 16:11 (UTC) ; Как перевести текст, смотрите на сайте (скриншоты) https://sourceforge.net/projects/qtrans0/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##############
# GoldenDict - https://wiki.archlinux.org/title/GoldenDict  ; http://goldendict.org/
# Лично я подключил свободные словари StarDict. Скачать их можно с сайта http://xdxf.revdanica.com/down/index.php
# (From: например English; To: например Russian; Download format: StarDict).
# Метод установки словарей: скачанные словари (например English-Russian full dictionary и Russian-English full dictionary) распаковываем в любую папку, затем Правка-Словари-Добавить... , указываем пути к словарям, затем жмем «Пересканировать».
# Все, программа готова к работе!
############################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить StarDict (stardict) - Словарь?"
echo -e "${MAGENTA}:: ${BOLD}StarDict — свободная оболочка для электронных словарей с открытым исходным кодом, способная, кроме собственно вывода статей, осуществлять перевод, озвучивать слова, использовать нечёткие запросы и шаблоны, поиск в онлайновых словарях. Разрабатывается на языке C++, с использованием графической библиотеки GTK и кодировки UTF-8. Он обладает мощными функциями, такими как «сопоставление с образцом в стиле Glob», «сканирование выделенного слова», «нечеткий запрос»... ${NC}"
echo " Домашняя страница: http://stardict-4.sourceforge.net/ ; (https://archlinux.org/packages/extra/x86_64/stardict/) ; http://qstardict.ylsoftware.com/index.php ; (https://archlinux.org/packages/extra/x86_64/qstardict/) "  
echo -e "${MAGENTA}:: ${BOLD}QStarDict — бесплатная программа-словарь, написанная с использованием Qt. Пользовательский интерфейс похож на StarDict. Основные характеристики: Полная поддержка словарей StarDict 2.x; Работа в системном трее; Сканирование выделения мышью и отображение всплывающего окна с переводами выделенных слов; Переводы переформатирование; Поддержка плагинов; Интерфейс D-Bus. Платформа: Программа разработана и протестирована на GNU/Linux. ${NC}"
echo " Словари для StarDict (https://aur.archlinux.org/packages?K=stardict- ; http://forum.ru-board.com/topic.cgi?forum=5&topic=16486 ; http://clubrus.kulichki.net/cgi-bin/yabb/YaBB.cgi?board=antiv;action=display;num=1273023980). Словари помести в /usr/share/stardict/dic, по крайней мере, у меня для версии StarDict 2.4.8 всё работает, и не каждый в отдельную папку, а, что называется, скопом :) " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить StarDict (stardict)(GTK3),   2 - Установить QStarDict (qstardict)(Qt-клон StarDict),   

    0 - НЕТ - Пропустить установку: " in_stardict  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_stardict" =~ [^120] ]]
do
    :
done
if [[ $in_stardict == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_stardict == 1 ]]; then
  echo ""
  echo " Установка StarDict (stardict) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed stardict  # Международное словарное программное обеспечение (GTK3) ;  http://stardict-4.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/stardict/ ; https://aur.archlinux.org/packages?K=stardict- ; 4 апреля 2024 г., 1:49 UTC 
sudo pacman -S --noconfirm --needed sdcv  # Консольная версия StarDict ; https://dushistov.github.io/sdcv/ ; https://archlinux.org/packages/extra/x86_64/sdcv/ ; 13 июля 2024 г., 21:02 UTC
echo ""
echo " Установка Словарей Stardict "
########## stardict-en-ru-bars ########
yay -S stardict-en-ru-bars --noconfirm  # Большой англо-русский словарь для Stardict ; http://stardict.sourceforge.net/ ; https://aur.archlinux.org/packages/stardict-en-ru-bars ; https://ftp.tw.freebsd.org/distfiles/stardict/stardict-en-ru-bars-2.4.2.tar.bz2 ; 2024-01-18 10:40 (UTC)
########### stardict-computer-ru ##########
yay -S stardict-computer-ru --noconfirm  # Англо-русский словарь компьютерных терминов для StarDict ; https://aur.archlinux.org/stardict-computer-ru.git (только для чтения, нажмите, чтобы скопировать) ; http://stardict.sourceforge.net/ ; https://aur.archlinux.org/packages/stardict-computer-ru ; https://downloads.sourceforge.net/xdxf/stardict-comn_sdict05_eng_rus_comp-2.4.2.tar.bz2 ; 2021-09-08 19:31 (UTC)
########## stardict-slang-eng-rus ###########
yay -S stardict-slang-eng-rus --noconfirm  # Англо-русский сленговый словарь ; https://aur.archlinux.org/stardict-slang-eng-rus.git (только для чтения, нажмите, чтобы скопировать) ; http://stardict.sourceforge.net/ ; https://aur.archlinux.org/packages/stardict-slang-eng-rus ; https://downloads.sourceforge.net/xdxf/stardict-comn_sdict_axm05_eng_rus_slang-2.4.2.tar.bz2 ; 2021-09-08 19:26 (UTC)
########## stardict-wordnet ###########
yay -S stardict-wordnet --noconfirm  # Словарь WordNet для StarDict ; https://aur.archlinux.org/stardict-wordnet.git (только для чтения, нажмите, чтобы скопировать) ; http://stardict.sourceforge.net/ ; https://src.fedoraproject.org/repo/pkgs/stardict-dic/stardict-dictd_www.dict.org_wn-2.4.2.tar.bz2/f164dcb24b1084e1cfa2b1cb63d590e6/stardict-dictd_www.dict.org_wn-2.4.2.tar.bz2 ; 2018-02-22 02:03 (UTC) 
########## stardict-urban ###########
yay -S stardict-urban --noconfirm  # Словарь Urban Dictionary (английский) для StarDict ; https://aur.archlinux.org/stardict-urban.git (только для чтения, нажмите, чтобы скопировать) ; http://download.huzheng.org/ ; https://aur.archlinux.org/packages/stardict-urban ; https://web.archive.org/web/20230602022440/http://download.huzheng.org/bigdict/stardict-Urban_Dictionary_P1-2.4.2.tar.bz2 ; https://web.archive.org/web/20230602022440/http://download.huzheng.org/bigdict/stardict-Urban_Dictionary_P2-2.4.2.tar.bz2 ; 2024-07-11 19:03 (UTC)
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_stardict == 2 ]]; then
  echo ""
  echo " Установка QStarDict (qstardict) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed qstardict  # Qt-клон StarDict с полной поддержкой словарей StarDict ; http://qstardict.ylsoftware.com/index.php ; https://archlinux.org/packages/extra/x86_64/qstardict/ ; http://qstardict.ylsoftware.com/dictionaries.php ; 24 декабря 2023 г., 23:57 UTC
sudo pacman -S --noconfirm --needed sdcv  # Консольная версия StarDict ; https://dushistov.github.io/sdcv/ ; https://archlinux.org/packages/extra/x86_64/sdcv/ ; 13 июля 2024 г., 21:02 UTC
echo ""
echo " Установка Словарей Stardict "
########## stardict-en-ru-bars ########
yay -S stardict-en-ru-bars --noconfirm  # Большой англо-русский словарь для Stardict ; http://stardict.sourceforge.net/ ; https://aur.archlinux.org/packages/stardict-en-ru-bars ; https://ftp.tw.freebsd.org/distfiles/stardict/stardict-en-ru-bars-2.4.2.tar.bz2 ; 2024-01-18 10:40 (UTC)
########### stardict-computer-ru ##########
yay -S stardict-computer-ru --noconfirm  # Англо-русский словарь компьютерных терминов для StarDict ; https://aur.archlinux.org/stardict-computer-ru.git (только для чтения, нажмите, чтобы скопировать) ; http://stardict.sourceforge.net/ ; https://aur.archlinux.org/packages/stardict-computer-ru ; https://downloads.sourceforge.net/xdxf/stardict-comn_sdict05_eng_rus_comp-2.4.2.tar.bz2 ; 2021-09-08 19:31 (UTC)
########## stardict-slang-eng-rus ###########
yay -S stardict-slang-eng-rus --noconfirm  # Англо-русский сленговый словарь ; https://aur.archlinux.org/stardict-slang-eng-rus.git (только для чтения, нажмите, чтобы скопировать) ; http://stardict.sourceforge.net/ ; https://aur.archlinux.org/packages/stardict-slang-eng-rus ; https://downloads.sourceforge.net/xdxf/stardict-comn_sdict_axm05_eng_rus_slang-2.4.2.tar.bz2 ; 2021-09-08 19:26 (UTC)
########## stardict-wordnet ###########
yay -S stardict-wordnet --noconfirm  # Словарь WordNet для StarDict ; https://aur.archlinux.org/stardict-wordnet.git (только для чтения, нажмите, чтобы скопировать) ; http://stardict.sourceforge.net/ ; https://src.fedoraproject.org/repo/pkgs/stardict-dic/stardict-dictd_www.dict.org_wn-2.4.2.tar.bz2/f164dcb24b1084e1cfa2b1cb63d590e6/stardict-dictd_www.dict.org_wn-2.4.2.tar.bz2 ; 2018-02-22 02:03 (UTC) 
########## stardict-urban ###########
yay -S stardict-urban --noconfirm  # Словарь Urban Dictionary (английский) для StarDict ; https://aur.archlinux.org/stardict-urban.git (только для чтения, нажмите, чтобы скопировать) ; http://download.huzheng.org/ ; https://aur.archlinux.org/packages/stardict-urban ; https://web.archive.org/web/20230602022440/http://download.huzheng.org/bigdict/stardict-Urban_Dictionary_P1-2.4.2.tar.bz2 ; https://web.archive.org/web/20230602022440/http://download.huzheng.org/bigdict/stardict-Urban_Dictionary_P2-2.4.2.tar.bz2 ; 2024-07-11 19:03 (UTC)
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Xournal++ (xournalpp) — Заметки?"
echo -e "${MAGENTA}:: ${BOLD}Xournal — программа-блокнот для ведения многостраничных заметок (блокнотов) или пометок в PDF файлах посредством стилуса или мыши и клавиатуры. Поддерживает форматирование текста, рисование, рукописный ввод. Позволяет открывать PDF файлы и делать в них пометки. Заметки можно сохранять в формате xoj (похож на XML) или экспортировать в PDF. ${NC}"
echo " Домашняя страница: https://github.com/xournalpp/xournalpp ; (https://archlinux.org/packages/extra/x86_64/xournalpp/). "  
echo -e "${MAGENTA}:: ${BOLD}Xournal имеет простой и удобный интерфейс. В верхней части окна программы размещаются две панели. Первая содержит кнопки сохранения, масштабирования, копирования-вставки. Вторая панель содержит набор инструментов для ввода и обработки текста и рисования: карандаш, текст, фигуры, линейку, ластик, выбор толщины пера, таблицу цветов, выбор шрифта. Дополнительные функции доступны в меню. Основную часть экрана занимает непосредственно лист вашего блокнота (заметки). ${NC}"
echo " Возможности Xournal++ : Поддерживает чувствительные к нажатию стилусы и цифровые планшеты (например, планшеты Wacom, Huion, XP Pen и т. д.). Бумажные фоны для заметок, черновиков или маркерной доски. Аннотировать поверх PDF-файлов. Выделите текст из фонового PDF-файла, скопируйте, выделите, подчеркните или зачеркните его. Следуйте ссылкам из фонового PDF-файла. Экспорт в различные форматы, включая SVG, PNG и PDF, как из графического интерфейса, так и из командной строки. Различные инструменты рисования (например, ручка, маркер) и стили штрихов (например, сплошной, пунктирный). Рисование фигуры (линия, стрелка, круг, прямоугольник, сплайн). Используйте угольник и циркуль для измерений или в качестве ориентира для черчения прямых линий, дуг окружности и радиусов. Функциональность заполнения формы. Изменение размера и поворот фигуры. Вращение и привязка к сетке для точного выравнивания объектов. Стабилизация входного сигнала для более плавного письма/рисования. Текстовый инструмент для добавления текста разных шрифтов, цветов и размеров. Улучшенная поддержка вставки изображений. Ластик с несколькими конфигурациями. Поддержка LaTeX (требуется работающая установка LaTeX) с настраиваемым шаблоном и редактором с изменяемым размером и подсветкой синтаксиса. Боковая панель, содержащая предварительный просмотр страниц с расширенной сортировкой страниц, закладки PDF и слои (могут быть индивидуально скрыты/редактированы). Позволяет назначать различные инструменты/цвета и т. д. кнопкам стилуса/мыши. Настраиваемая панель инструментов с несколькими конфигурациями, например, для оптимизации панели инструментов для портретной/альбомной ориентации. Поддержка пользовательских цветовых палитр с использованием формата .gpl Определения шаблонов страниц. Инструменты для создания отчетов об ошибках, автоматического сохранения и резервного копирования. Аудиозапись и воспроизведение вместе с рукописными заметками. Поддержка нескольких языков (поддерживается более 20 языков). Плагины, использующие скрипты Lua. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить Xournal++ (xournalpp),    0 - НЕТ - Пропустить установку: " in_xournal  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_xournal" =~ [^120] ]]
do
    :
done
if [[ $in_xournal == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_xournal == 1 ]]; then
  echo ""
  echo " Установка Xournal++ (xournalpp) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed xournalpp # Xournal++ ; Программное обеспечение для создания рукописных заметок с поддержкой аннотаций  PDF ; https://github.com/xournalpp/xournalpp ; https://archlinux.org/packages/extra/x86_64/xournalpp/ ; Заменяет: xournal ; 25 мая 2024 г., 20:34 UTC ; https://wiki.archlinux.org/title/Xournal%2B%2B
######### xournalpp-git ###########
# yay -S xournalpp-git --noconfirm  # Xournal++ — это программное обеспечение для рукописного ввода заметок с поддержкой аннотаций PDF. Поддерживает ввод с помощью пера, как на планшетах Wacom ; https://github.com/xournalpp/xournalpp ; https://aur.archlinux.org/xournalpp-git.git (только для чтения, нажмите, чтобы скопировать) ; https://aur.archlinux.org/packages/xournalpp-git ; Конфликты: с xournalpp ; 2024-08-07 17:34 (UTC)
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить GeoGebra (geogebra) - Математическая программа?"
echo -e "${MAGENTA}:: ${BOLD}GeoGebra — бесплатная математическая программа, обладающая множеством возможностей в области геометрии, алгебры, различных вычислений. Позволяет строить графики, чертежи, кривые, выполнять действия с матрицами, комплексными числами, работать с таблицами и многое другое. Широкая функциональность GeoGebra позволяет применять ее учащимися (школьный курс и ВУЗ), а также учителями. ${NC}"
echo " Домашняя страница: https://www.geogebra.org/ ; (https://archlinux.org/packages/extra/any/geogebra/). "  
echo -e "${MAGENTA}:: ${BOLD}Работать с программой очень удобно. Графики строятся с помощью мыши простым перемещением указателя или расстановкой необходимых точек. Все опорные точки добавляются в список в левой части окна программы. Любую точку можно отредактировать как с клавиатуры, так и перемещая ее мышью. Каждый объект можно настроить по своему желанию. Изменить цвета, метку, толщину, задать условия отображения, задать действия при клике на объект. ${NC}"
echo " Программа написана на Java и является кроссплатформенной. Доступна для Linux, Windows, Mac OS X, iOS, Android. Также существуют Portable версии, работающие без установки. Отдельно стоит отметить Web-версию программы (GeoGebra Web Application), работающей прямо в браузере: http://web.geogebra.org/chromeapp/ . ⚠ *Русификация GeoGebra: GeoGebra переведена на русский язык. Изначально программа запускается на английском языке. Для выбора русского — выберите в меню пункт Optionts->Language->R-Z->Russian, язык интерфейса сменится сразу же, без перезагрузки программы. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_geogebra  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_geogebra" =~ [^10] ]]
do
    :
done
if [[ $in_geogebra == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_geogebra == 1 ]]; then
  echo ""
  echo " Установка GeoGebra (geogebra) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed geogebra  # Программное обеспечение для динамической математики с интерактивной графикой, алгеброй и электронными таблицами ; https://www.geogebra.org/ ; https://archlinux.org/packages/extra/any/geogebra/ ; 15 августа 2024 г., 10:12 UTC
sudo pacman -S --noconfirm --needed geogram  # Geogram — это библиотека программирования с геометрическими алгоритмами. Имеет функции обработки геометрии ; https://github.com/BrunoLevy/geogram ; https://archlinux.org/packages/extra/x86_64/geogram/ ; June 26, 2024, 5:58 a.m. UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi    

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить KRuler - Экранная линейка?"
echo -e "${MAGENTA}:: ${BOLD}KRuler — простая экранная линейка. Измерение расстояния в пикселях между точками экрана. Поместите 0 в начальную точку и измерьте точное расстояние в пикселях между начальной точкой и курсором. ${NC}"
echo " Домашняя страница: https://apps.kde.org/kruler/ ; (https://archlinux.org/packages/extra/x86_64/kruler/). "  
echo -e "${MAGENTA}:: ${BOLD}Утилита может применяться веб-мастерами, разработчиками пользовательского интерфейса, пользователями, работающими с графикой. ${NC}"
echo " Возможности и особенности: Измерение расстояния в пикселях. Вертикальный и горизонтальный режимы. Возможность изменить цвет фона линейки. Возможность изменить шрифт. Шкала в процентах. Ориентация шкалы: слева направо, справа налево, от центра, со смещением. Разрабатывается в рамках проекта: KDE. Исходный код: Open Source (открыт). Языки программирования: C++ . Библиотеки: Qt. Лицензия: GNU GPL. Приложение переведено на русский язык. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_kruler  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_kruler" =~ [^10] ]]
do
    :
done
if [[ $in_kruler == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_kruler == 1 ]]; then
  echo ""
  echo " Установка KRuler "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed kruler  # Линейка экрана ; https://apps.kde.org/kruler/ ; https://archlinux.org/packages/extra/x86_64/kruler/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##############

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