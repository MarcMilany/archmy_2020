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
ARCHMY5_LANG="russian"  # Installer default language (Язык установки по умолчанию)
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
echo -e "${GREEN}==> ${NC}Установка Текстового редактора (micro)"
#echo -e "${BLUE}:: ${NC}Установка Текстового редактора (micro)"
#echo 'Установка Текстового редактора (micro)'
# Installing a text editor (micro)
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
echo ""
echo " Установка текстового редактора (micro) выполнена "
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
  echo " Установка текстового редактора (leafpad) "
sudo pacman -S --noconfirm --needed leafpad  # Клон блокнота для GTK+ 2.0. https://archlinux.org/packages/extra/x86_64/leafpad/
echo ""
echo " Установка текстового редактора (leafpad) выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установка Текстового редактора (xed)"
#echo -e "${BLUE}:: ${NC}Установка Текстового редактора (xed)"
#echo 'Установка Текстового редактора (xed)'
# Installing a text editor (xed)
echo -e "${MAGENTA}=> ${BOLD}Xed - официальный текстовый редактор проекта X-APPS, цель которого — предоставить приложения для рабочих столов Cinnamon, MATE и Xfce. Xed, стремясь к простоте и удобству использования, является мощным текстовым редактором общего назначения. Его можно использовать для создания и редактирования всех видов текстовых файлов.
Оно полностью поддерживает международный текст благодаря использованию кодировки Unicode UTF-8 . Как универсальный текстовый редактор, Xed поддерживает большинство стандартных функций редактора. Его основной набор функций включает подсветку синтаксиса исходного кода, автоматический отступ и поддержку печати с предварительным просмотром. ${NC}"
echo -e "${CYAN}:: ${NC}Описание: Xed поддерживает большинство стандартных функций редактирования, а также несколько функций, которых нет в обычном текстовом редакторе (наиболее примечательными из них являются плагины).
Хотя новые функции постоянно находятся в стадии разработки, в настоящее время xed имеет: Полная поддержка текста в формате UTF-8; Подсветка синтаксиса; Поддержка редактирования удаленных файлов; Поиск и замена; Поддержка печати и предварительного просмотра; Возврат к файлам; Полный интерфейс настроек; Настраиваемая система плагинов с дополнительной поддержкой python.
Некоторые из плагинов, упакованных и установленных с помощью xed, включают в себя, среди прочего: Изменение регистра; Статистика документа; Обозреватель файлов; Строки отступа; Вставка даты/времени; Модели; Сохранение без конечных пробелов; Сортировка; Проверка орфографии; Список тегов; Завершение текста. Xed выпускается под лицензией GNU General Public License (GPL) версии 2."
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

clear
echo ""
echo -e "${GREEN}==> ${NC}Установка Утилиты разработки (geany)"
#echo -e "${BLUE}:: ${NC}Установка Утилиты разработки (geany)"
#echo 'Установка Утилиты разработки (geany)'
# Installing the development utility (geany)
echo -e "${MAGENTA}=> ${BOLD}Geany - это текстовый редактор, который позволяет подключать сторонние библиотеки для создания полноценной среды разработки. ${NC}"
echo " Домашняя страница:  ; (). "
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
echo -e "${BLUE}:: ${NC}Установить Xreader - (для просмотра документов PDF, postscript, djvu, xps, dvi и т.д..)?"
echo -e "${MAGENTA}:: ${BOLD}Xreader - простой просмотрщик многостраничных документов. Он может отображать и печатать файлы PostScript (PS), Encapsulated PostScript (EPS), DJVU, DVI, XPS и Portable Document Format (PDF). Это бесплатное программное обеспечение с открытым исходным кодом. Данное программное обеспечение лицензировано в соответствии с GNU GENERAL PUBLIC LICENSE версии 2 от июня 1991 г. ${NC}"
echo " Домашняя страница: https://github.com/linuxmint/xreader ; (https://archlinux.org/packages/extra/x86_64/xreader/ ; https://man.archlinux.org/man/xreader.1.en ; https://wiki.archlinux.org/title/PDF,_PS_and_DjVu ; https://github.com/linuxmint/xreader/blob/master/help/C/xreader.md). "  
echo -e "${MAGENTA}:: ${BOLD}Xreader является производным от Evince — стандартного документального просмотра в GNOME. Он расширяет возможности своего предшественника, добавляя поддержку файлов EPUB. Xreader не позволяет печатать EPUB-файлы или конвертировать их в другие форматы. В нём отсутствуют продвинутые функции, такие как Calibre или Okular.  ${NC}"
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
sudo pacman -S --noconfirm --needed okular  # Просмотрщик документов ; https://apps.kde.org/okular/ ; 
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
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (obs-studio, telegram-desktop, discord, flameshot, cherrytree, keepass, keepassxc, nomacs, meld, uget, openshot, handbrake)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo -e "${YELLOW}==> ${NC}Установка будет производится в порядке перечисления (по очереди)"
#echo 'Установка будет производится в порядке перечисления (по очереди)'
# Installation will be performed in the order listed (one at a time)

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

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить LibreCAD (для создания 2D-чертежей САПР - геометрическое моделирование)?"
echo -e "${MAGENTA}:: ${BOLD}LibreCAD - это LibreCAD — это многофункциональное и зрелое приложение 2D-CAD, обладающее рядом действительно значительных преимуществ. Пользовательский интерфейс переведен на более чем 30 языков. Язык интерфейса: русский, английский и другие... Лицензия: GNU GPL.${NC}"
echo " Домашняя страница: https://www.librecad.org/ ; (https://github.com/LibreCAD/LibreCAD ; https://archlinux.org/packages/extra/x86_64/librecad/). "  
echo -e "${MAGENTA}:: ${BOLD}Описание: LibreCAD использует кроссплатформенную структуру Qt , что означает, что он работает с большинством операционных систем. LibreCAD - это бесплатное приложение САПР с открытым исходным кодом для Windows, Apple и Linux. Поддержка и документация бесплатны благодаря нашему большому преданному сообществу пользователей, участников и разработчиков.  ${NC}" 
echo " Основные особенности и возможности: LibreCAD можно использовать как конвертер dxf в pdf, png или svg. Например, чтобы преобразовать foo.dxf в foo.pdf, foo.png или foo.svg (librecad dxf2pdf foo.dxf ; librecad dxf2png foo.dxf ; librecad dxf2svg foo.dxf). "
echo " Основная ветвь представляет собой последний предварительный код и теперь требует Qt 6.4.0 или более новую версию. Ветка 2.2.1 требует Qt 5.15.0 или более новую версию. Ветка 2.2 требует Qt 5.2.1 или более новую версию. Ветка 2.1 будет последней, поддерживающей Qt4. Ветка 2.0 будет последней, поддерживающей панель инструментов QCAD. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_librecad  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_librecad" =~ [^10] ]]
do
    :
done
if [[ $in_librecad == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_librecad == 1 ]]; then
  echo ""
  echo " Установка LibreCAD "
sudo pacman -S --noconfirm --needed librecad  # Инструмент для создания 2D-чертежей САПР на основе общедоступной версии QCad ; https://www.librecad.org/ ; https://archlinux.org/packages/extra/x86_64/librecad/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#############

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