#!/bin/bash
# loadkeys ru
# setfont cyr-sun16
# clear
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

MULTIMEDIA_PROG_LANG="russian"  # Installer default language (Язык установки по умолчанию)

script_path=$(readlink -f ${0%/*})

umask 0022 # Определение окончательных прав доступа
# Для суперпользователя (root) umask по умолчанию равна 0022

##################################################################

set -e "\n${RED}Error: ${YELLOW}${*}${NC}"  # Эта команда остановит выполнение сценария после сбоя команды и будет отправлен код ошибки
 
###################################################################

### Help and usage (--help or -h) (Справка)
_help() {
    echo -e "${BLUE}
Installation guide - Arch Wiki
${BOLD}For more information, see the wiki: \
${GREY}<https://wiki.archlinux.org/index.php/Installation_guide>${NC}"
}

### SHARED VARIABLES AND FUNCTIONS (ОБЩИЕ ПЕРЕМЕННЫЕ И ФУНКЦИИ)
### Shell color codes (Цветовые коды оболочки)
RED="\e[1;31m"; GREEN="\e[1;32m"; YELLOW="\e[1;33m"; GREY="\e[3;93m"
BLUE="\e[1;34m"; CYAN="\e[1;36m"; BOLD="\e[1;37m"; MAGENTA="\e[1;35m"; NC="\e[0m"

### Automatic error detection (Автоматическое обнаружение ошибок)
_set() {
    set [--abefhkmnptuvxBCHP] [-o option] [arg ...]
}

_set() {
    set -e "\n${RED}Error: ${YELLOW}${*}${NC}"
    _note "${MSG_ERROR}"
    sleep 1; $$
}

### Display install steps (Отображение шагов установки)
_info() {
    echo -e "${YELLOW}\n==> ${CYAN}${1}...${NC}"; sleep 1
}
  
### Download show progress bar only (Скачать показывать только индикатор выполнения)
_wget() {
    wget "${1}" --quiet --show-progress
}

########################################
### Warning (Предупреждение)
_warning_banner() {
    echo -e "${YELLOW}
   ====================== ♥ Предупреждение ======================
${NC}
Цель сценария (скрипта) - это установка необходимого софта (пакетов) и запуск необходимых служб. 
Смысл в том, что все изменения вы делаете предварительно в самом скрипте и получаете возможность быстрой установки утилит (пакетов), которые Вы решили установить (при условии, что Вы его изменили под себя, в противном случае скрипт установит софт (пакеты) прописанный изначально.
В процессе работы сценария (скрипта) Вам будут задаваться вопросы на установку той, или иной утилиты (пакета) - будьте внимательными! Устанавливаемый софт (пакеты), шрифты - скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. Так же присутствует софт (пакеты), шрифты - устанавливаемый из пользовательского репозитория 'AUR'-'yay', собираются и устанавливаются. Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска необходимых служб. В любой ситуации выбор всегда за вами. Вы либо гуляете под дождем, либо просто под ним мокнете.${RED}

  ***************************** ВНИМАНИЕ! ***************************** 
${NC}
Автор не несёт ответственности за любое нанесение вреда при использовании скрипта. 
Вы используйте его на свой страх и риск, или изменяйте под свои личные нужды.
Будьте внимательны! Процесс установки софта (пакетов) устанавливаемого из пользовательского репозитория будет осуществляться через - 'AUR'-'yay' (здесь выбор всегда остаётся за вами - ставить или нет).  
В данный момент сценарий (скрипта) находится в процессе доработки по прописанию устанавливаемого софта (пакетов), и небольшой корректировке (Воен. Внесение поправок в наводку орудий по результатам наблюдений с наблюдательных пунктов).

${BLUE}===> ******************************************************* ${NC}"
}
########################################

### Display banner (Дисплей баннер)
_warning_banner

sleep 9
#echo -e "${MAGENTA}==> ${BOLD}Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети. ${NC}"
#echo 'Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети.'
# If you have a wireless connection, launch nmtui and connect to the network. 

echo ""
echo -e "${BLUE}:: ${NC}Установка и настройка начата в $(date +%T)" 
#echo "Установка и настройка начата в $(date +%T)"
# Installation and configuration started in $(date +%T)

echo ""
echo -e "${GREEN}=> ${NC}Для проверки интернета можно пропинговать какой-либо сервис"
echo -e "${MAGENTA}==> ${BOLD}Если у Вас беспроводное соединение, запустите nmtui (Network Manager Text User Interface) и подключитесь к сети. ${NC}"
#echo 'Для проверки интернета можно пропинговать какой-либо сервис'
# To check the Internet, you can ping a service
ping -c2 archlinux.org  # Утилита ping - это очень простой инструмент для диагностики сети
#ping google.com -W 2 -c 1

echo -e "${CYAN}==> ${NC}Если пинг идёт едем дальше ... :)"
#echo 'Если пинг идёт едем дальше ... :)'
# If the ping goes we go further ... :)
sleep 03

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
###  sudo pacman -Sy
  sudo pacman -Syy  # обновление баз пакмэна (pacman)  
echo ""
echo " Обновление базы данных выполнено "
fi
sleep 01

clear
echo -e "${MAGENTA}
  <<< Установка дополнительных пакетов Python - по вашему выбору и желанию >>> ${NC}"
# Installing Python packages - according to your choice and desire 
echo ""
echo -e "${GREEN}==> ${NC}Установка пакетов Python"
#echo -e "${BLUE}:: ${NC}Установка пакетов Python"
#echo 'Установка дополнительных пакетов Python'
# Installing Python packages
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - Посмотрите перед установкой в скрипте!." 
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют функция пропуска установки уже установленных пакетов (python)! ${NC}"
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " t_pythons  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_pythons" =~ [^10] ]]
do
    :
done
if [[ $t_pythons == 0 ]]; then
echo ""  
echo " Установка дополнительных пакетов - Python пропущена "
elif [[ $t_pythons == 1 ]]; then
# Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты! 
echo ""
echo " Установка дополнительных пакетов - Python "
########## Python ###########
sudo pacman -S --noconfirm --needed python  # Новое поколение языка сценариев высокого уровня Python # возможно присутствует
sudo pacman -S --noconfirm --needed python-anytree  # Мощная и легкая древовидная структура данных Python
sudo pacman -S --noconfirm --needed python-appdirs  # Небольшой модуль Python для определения соответствующих директорий для конкретной платформы, например «директории пользовательских данных».
sudo pacman -S --noconfirm --needed python-arrow  # Лучшие даты и время для Python
sudo pacman -S --noconfirm --needed python-asn1crypto  # Библиотека Python ASN.1 с упором на производительность и pythonic API
sudo pacman -S --noconfirm --needed python-atspi  #  Привязки Python для D-Bus AT-SPI
sudo pacman -S --noconfirm --needed python-attrs  # Атрибуты без шаблона
sudo pacman -S --noconfirm --needed python-bcrypt  # Современное хеширование паролей для вашего программного обеспечения и ваших серверов
sudo pacman -S --noconfirm --needed python-beaker  # Кэширование и сеансы промежуточного программного обеспечения WSGI для использования с веб-приложениями и автономными скриптами и приложениями Python
sudo pacman -S --noconfirm --needed python-beautifulsoup4  # Синтаксический анализатор HTML / XML на Python, предназначенный для быстрых проектов, таких как очистка экрана
sudo pacman -S --noconfirm --needed python-cachecontrol  # httplib2 кеширование запросов
sudo pacman -S --noconfirm --needed python-cffi  # Интерфейс внешних функций для Python, вызывающего код C
sudo pacman -S --noconfirm --needed python-cairo  # Привязки Python для графической библиотеки cairo
sudo pacman -S --noconfirm --needed python-chardet  # Модуль Python3 для автоматического определения кодировки символов
sudo pacman -S --noconfirm --needed python-colorama  # Python API для кроссплатформенного цветного текста терминала
sudo pacman -S --noconfirm --needed python-colour  # Библиотека манипуляций с цветовыми представлениями (RGB, HSL, web, ...)
sudo pacman -S --noconfirm --needed python-configobj  # Простое, но мощное средство чтения и записи конфигурационных файлов для Python
sudo pacman -S --noconfirm --needed python-click  # Простая оболочка вокруг optparse для мощных утилит командной строки
sudo pacman -S --noconfirm --needed python-cryptography  # Пакет, предназначенный для предоставления криптографических рецептов и примитивов разработчикам Python
sudo pacman -S --noconfirm --needed python-cssselect  # Библиотека Python3, которая анализирует селекторы CSS3 и переводит их в XPath 1.0
sudo pacman -S --noconfirm --needed python-dateutil  # Предоставляет мощные расширения для стандартного модуля datetime 
sudo pacman -S --noconfirm --needed python-dbus  # Привязки Python для DBUS
sudo pacman -S --noconfirm --needed python-dbus-common  # Общие файлы dbus-python, общие для python-dbus и python2-dbus
sudo pacman -S --noconfirm --needed python-defusedxml  # Защита от XML-бомбы для модулей Python stdlib
sudo pacman -S --noconfirm --needed python-distlib  # Низкоуровневые компоненты distutils2 / упаковка
sudo pacman -S --noconfirm --needed python-distro  # API информации о платформе ОС Linux
sudo pacman -S --noconfirm --needed python-distutils-extra  # Улучшения в системе сборки Python (Помечено как устаревшее 03.08.2023)
sudo pacman -S --noconfirm --needed python-docopt  # Пифонический парсер аргументов, который заставит вас улыбнуться
sudo pacman -S --noconfirm --needed python-entrypoints  # Обнаружение и загрузка точек входа из установленных пакетов
sudo pacman -S --noconfirm --needed python-future  # Чистая поддержка одного источника для Python 3 и 2
sudo pacman -S --noconfirm --needed python-gevent  # Сетевая библиотека Python, которая использует greenlet и libev для простого и масштабируемого параллелизма
sudo pacman -S --noconfirm --needed python-gevent-websocket  # Библиотека WebSocket для сетевой библиотеки gevent
sudo pacman -S --noconfirm --needed python-greenlet  # Легкое параллельное программирование в процессе
sudo pacman -S --noconfirm --needed python-gobject  # Привязки Python для GLib / GObject / GIO / GTK +
sudo pacman -S --noconfirm --needed python-html5lib  # Парсер / токенизатор HTML Python на основе спецификации WHATWG HTML5
sudo pacman -S --noconfirm --needed python-httplib2  # Обширная клиентская библиотека HTTP, поддерживающая множество функций
sudo pacman -S --noconfirm --needed python-idna  # Интернационализированные доменные имена в приложениях (IDNA)
sudo pacman -S --noconfirm --needed python-isodate  # Синтаксический анализатор даты / времени / продолжительности и форматирование ISO 8601
sudo pacman -S --noconfirm --needed python-isomd5sum  # Привязки Python3 для isomd5sum # возможно присутствует (Помечено как устаревшее 30.06.2024)
sudo pacman -S --noconfirm --needed python-jedi  # Отличное автозаполнение для Python
sudo pacman -S --noconfirm --needed python-jeepney  # Низкоуровневая оболочка протокола Python DBus на чистом уровне
sudo pacman -S --noconfirm --needed python-jinja  # Простой питонический язык шаблонов, написанный на Python
sudo pacman -S --noconfirm --needed python-keyring  # Безопасное хранение и доступ к вашим паролям
sudo pacman -S --noconfirm --needed python-keyutils  # Набор привязок python для keyutils
sudo pacman -S --noconfirm --needed python-libarchive-c  # Интерфейс Python для libarchive
sudo pacman -S --noconfirm --needed python-lxml  # Связывание Python3 для библиотек libxml2 и libxslt (-S python-lxml --force # принудительная установка)
sudo pacman -S --noconfirm --needed python-lxml-docs  # Связывание Python для библиотек libxml2 и libxslt (документы)
sudo pacman -S --noconfirm --needed python-magic  # Привязки Python к волшебной библиотеке
sudo pacman -S --noconfirm --needed python-mako  # Сверхбыстрый язык шаблонов, который заимствует лучшие идеи из существующих языков шаблонов
sudo pacman -S --noconfirm --needed python-markdown  # Реализация Python Markdown Джона Грубера
sudo pacman -S --noconfirm --needed python-markupsafe  # Реализует безопасную строку разметки XML / HTML / XHTML для Python
sudo pacman -S --noconfirm --needed python-maxminddb  # Читатель для формата MaxMind DB
sudo pacman -S --noconfirm --needed python-msgpack  # Реализация сериализатора MessagePack для Python (Помечено как устаревшее 13.10.2023)
sudo pacman -S --noconfirm --needed python-mutagen  # (mutagen) Средство чтения и записи тегов метаданных аудио (библиотека Python)
sudo pacman -S --noconfirm --needed python-nose  # Расширение unittest на основе обнаружения
sudo pacman -S --noconfirm --needed python-numpy  # Научные инструменты для Python
sudo pacman -S --noconfirm --needed python-openid  # Порт Python 3 библиотеки python2-openid
sudo pacman -S --noconfirm --needed python-olefile  # Библиотека Python для анализа, чтения и записи файлов Microsoft OLE2 (ранее OleFileIO_PL)
sudo pacman -S --noconfirm --needed python-ordered-set  # MutableSet, который запоминает свой порядок, так что каждая запись имеет индекс
sudo pacman -S --noconfirm --needed python-packaging  # Основные утилиты для пакетов Python (Помечено как устаревшее 30.06.2024)
sudo pacman -S --noconfirm --needed python-paramiko  # Модуль Python, реализующий протокол SSH2
sudo pacman -S --noconfirm --needed python-parso  # Синтаксический анализатор Python, поддерживающий восстановление ошибок и двусторонний синтаксический анализ для разных версий Python
sudo pacman -S --noconfirm --needed python-patiencediff  # Patiencediff реализации Python и C
sudo pacman -S --noconfirm --needed python-pbr  # Разумность сборки Python
sudo pacman -S --noconfirm --needed python-pillow  # Вилка Python Imaging Library (PIL)
sudo pacman -S --noconfirm --needed python-pip  # Рекомендуемый PyPA инструмент для установки пакетов Python # возможно присутствует (Помечено как устаревшее 2024-06-20)
sudo pacman -S --noconfirm --needed python-pexpect  # Для управления и автоматизации приложений
sudo pacman -S --noconfirm --needed python-ply  # Реализация инструментов парсинга lex и yacc
sudo pacman -S --noconfirm --needed python-powerline  # Библиотека Python для Powerline
sudo pacman -S --noconfirm --needed python-progressbar # python-progress  # Простые в использовании индикаторы выполнения для Python
sudo pacman -S --noconfirm --needed python-psutil  # Кросс-платформенный модуль процессов и системных утилит для Python (Помечено как устаревшее 25.06.2024)
sudo pacman -S --noconfirm --needed python-ptyprocess  # Запустить подпроцесс в псевдотерминале
sudo pacman -S --noconfirm --needed python-pyasn1  # Библиотека ASN.1 для Python 3 (Помечено как устаревшее 27.04.2024)
sudo pacman -S --noconfirm --needed python-pyasn1-modules  # Коллекция модулей протоколов на основе ASN.1 (Помечено как устаревшее 27.03.2024)
sudo pacman -S --noconfirm --needed python-pycountry  # Определения страны, подразделения, языка, валюты и алфавита ИСО и их переводы
sudo pacman -S --noconfirm --needed python-pycparser  # Синтаксический анализатор C и генератор AST, написанные на Python
sudo pacman -S --noconfirm --needed python-pycups  # Привязки Python для libcups
sudo pacman -S --noconfirm --needed python-pycurl  # Интерфейс Python 3.x для libcurl (Помечено как устаревшее 22.03.2024)
sudo pacman -S --noconfirm --needed python-pycryptodome  # Коллекция криптографических алгоритмов и протоколов, реализованных для использования из Python 3
sudo pacman -S --noconfirm --needed python-pyelftools  # Библиотека Python для анализа файлов ELF и отладочной информации DWARF
sudo pacman -S --noconfirm --needed python-pyfiglet  # Реализация FIGlet на чистом питоне
sudo pacman -S --noconfirm --needed python-pygments  # Подсветка синтаксиса Python
sudo pacman -S --noconfirm --needed python-pyicu  # Связывание Python для ICU
sudo pacman -S --noconfirm --needed python-pynacl  # Привязка Python к библиотеке сетей и криптографии (NaCl)
sudo pacman -S --noconfirm --needed python-pyopenssl  # Модуль оболочки Python3 вокруг библиотеки OpenSSL
sudo pacman -S --noconfirm --needed python-pyparsing  # Модуль общего синтаксического анализа для Python
sudo pacman -S --noconfirm --needed python-pyphen  # Модуль Pure Python для переноса текста
sudo pacman -S --noconfirm --needed python-pyqt5  # Набор привязок Python для инструментария Qt5
sudo pacman -S --noconfirm --needed python-pyqt5-sip  # Поддержка модуля sip для PyQt5
sudo pacman -S --noconfirm --needed python-pyquery  # Библиотека для Python, похожая на jquery
sudo pacman -S --noconfirm --needed python-pyparted  # Модуль Python для GNU parted
sudo pacman -S --noconfirm --needed python-pysmbc  # Привязки Python 3 для libsmbclient
sudo pacman -S --noconfirm --needed python-pysocks  # SOCKS4, SOCKS5 или HTTP-прокси (вилка Anorov PySocks заменяет socksipy)
sudo pacman -S --noconfirm --needed python-pysol_cards  # Карты Deal PySol FC
sudo pacman -S --noconfirm --needed python-pyudev  # Привязки Python к libudev
sudo pacman -S --noconfirm --needed python-pywal  # Создавайте и изменяйте цветовые схемы на лету
sudo pacman -S --noconfirm --needed python-pyxdg  # Библиотека Python для доступа к стандартам freedesktop.org
sudo pacman -S --noconfirm --needed python-random2  # Python 3 совместимый порт случайного модуля Python 2
sudo pacman -S --noconfirm --needed python-requests  # Python HTTP для людей
sudo pacman -S --noconfirm --needed python-resolvelib  # Преобразуйте абстрактные зависимости в конкретные
sudo pacman -S --noconfirm --needed python-retrying  # Библиотека перенастройки Python общего назначения
sudo pacman -S --noconfirm --needed python-rsa  # Реализация RSA на чистом Python
sudo pacman -S --noconfirm --needed python-scipy  # SciPy - это программное обеспечение с открытым исходным кодом для математики, естественных наук и инженерии
sudo pacman -S --noconfirm --needed python-secretstorage  # Безопасно храните пароли и другие личные данные с помощью API SecretService DBus
sudo pacman -S --noconfirm --needed python-setproctitle  # Позволяет процессу Python изменять название процесса
sudo pacman -S --noconfirm --needed python-setuptools  # Легко загружайте, собирайте, устанавливайте, обновляйте и удаляйте пакеты Python (Помечено как устаревшее 12.02.2024)
sudo pacman -S --noconfirm --needed python-six  # Утилиты совместимости с Python 2 и 3
sudo pacman -S --noconfirm --needed python-soupsieve  # Реализация селектора CSS4 для Beautiful Soup
sudo pacman -S --noconfirm --needed python-sqlalchemy  # Набор инструментов Python SQL и объектно-реляционное сопоставление
sudo pacman -S --noconfirm --needed python-termcolor  # Форматирование цвета ANSII для вывода в терминал
sudo pacman -S --noconfirm --needed python-tlsh  # Библиотека нечеткого сопоставления, которая генерирует хеш-значение, которое можно использовать для сравнений схожести
sudo pacman -S --noconfirm --needed python-toml  # Библиотека Python для анализа и создания TOML
sudo pacman -S --noconfirm --needed python-ujson  # Сверхбыстрый кодировщик и декодер JSON для Python
sudo pacman -S --noconfirm --needed python-unidecode  # ASCII транслитерации текста Unicode
sudo pacman -S --noconfirm --needed python-urllib3  # Библиотека HTTP с потокобезопасным пулом соединений и поддержкой публикации файлов (Помечено как устаревшее 22.11.2023)
sudo pacman -S --noconfirm --needed python-webencodings  # Это Python-реализация стандарта кодирования WHATWG
sudo pacman -S --noconfirm --needed python-websockets  # Реализация протокола WebSocket на Python (RFC 6455)
sudo pacman -S --noconfirm --needed python-websocket-client  # Клиентская библиотека WebSocket для Python
sudo pacman -S --noconfirm --needed python-xapp  # Библиотека Python Xapp
sudo pacman -S --noconfirm --needed python-yaml  # Привязки Python для YAML с использованием быстрой библиотеки libYAML
sudo pacman -S --noconfirm --needed python-zope-event  # Предоставляет простую систему событий
sudo pacman -S --noconfirm --needed python-zope-interface  # Интерфейсы Zope для Python 3.x
# sudo pacman -S --noconfirm --needed  # 
# sudo pacman -S --noconfirm --needed  # 
# sudo pacman -S --noconfirm --needed  # 
# sudo pacman -S --noconfirm --needed  # 
#############################
echo ""
echo " Установка дополнительных пакетов Python выполнена "
echo " Время точное как на Спасской башне Московского Кремля! "
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'   # одновременно отображает дату и часовой пояс
fi
##########################################

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
echo -e "${BLUE}:: ${NC}Если хотите установить дополнительных пакетов Python, из AUR - через (yay), тогда после перезагрузки и входа в систему выполните команду:"
echo -e "${YELLOW}==> ${CYAN}git clone https://github.com/MarcMilany/archmy_2020.git ${NC}"
echo -e "${CYAN}:: ${NC}Цель скрипта (pyton_aur) - это установка дополнительных pyton (пакетов), находящихся в AUR и которых нет в стандарных репозиториях Arch'a https://archlinux.org/packages/."
echo -e "${CYAN}:: ${NC}Скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска служб."
echo -e "${GREEN}
  <<< Желаю Вам удачи во всех начинаниях, верных и точных решений! >>> ${NC}"
echo ""
echo -e "${RED}### ${BLUE}########################################################### ${RED}### ${NC}"
echo -e "${RED}==> ${BOLD}Выходим из установленной системы ${NC}"
echo -e "${BLUE}:: ${BOLD}Теперь вам надо ввести (exit) reboot, чтобы перезагрузиться ${NC}"
sleep 03
exit
exit

### end of script