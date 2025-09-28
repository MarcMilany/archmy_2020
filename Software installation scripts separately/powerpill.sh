#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! ####

apptitle="Arch Linux Fast Install v2.5 LegasyBIOS - Version: 2025.07.30.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя
#BROWSER="firefox"

POWERPILL_LANG="russian"  # Installer default language (Язык установки по умолчанию)

script_path=$(readlink -f ${0%/*})

umask 0022 # Определение окончательных прав доступа
# Для суперпользователя (root) umask по умолчанию равна 0022

##############################################################
### design_for_xfce.sh  (Оформление для Xfce)
###
### Copyright (C) 2021 Marc Milany
###
### By: Marc Milany
### Email: 'Don't look for me 'Vkontakte', in 'Odnoklassniki' we are not present, ..
### Webpage: https://www.xfce-look.org/  ; https://www.gnome-look.org/browse/cat/
### Releases ArchLinux: https://www.archlinux.org/releng/releases/
###
### Any questions, comments, or bug reports may be sent to above
### email address. Enjoy, and keep on using Arch.
###
### License (Лицензия): LGPL-3.0
###############################################################

set -e "\n${RED}Error: ${YELLOW}${*}${NC}"  # Эта команда остановит выполнение сценария после сбоя команды и будет отправлен код ошибки

###############################################################

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

###################################################################

### Warning (Предупреждение)
_warning_banner() {
    echo -e "${YELLOW}
   ====================== ♥ Предупреждение ======================
${NC}
Цель сценария (скрипта) - это установка (пакетов) для расширения оболочки Pacman в Arch Linux.
Смысл в том, что все изменения вы делаете предварительно в самом скрипте и получаете возможность быстрой установки (пакетов), которые Вы решили установить (при условии, что Вы его изменили под себя, в противном случае скрипт установит (пакеты) прописанные изначально.
В процессе работы сценария (скрипта) Вам будут задаваться вопросы на установку того, или иного (пакета) оформления (Смотрите пометки (справочки) и доп.иформацию в самом скрипте!) - будьте внимательными! В скрипте есть (пакеты), которые устанавливаются из 'AUR', в зависимости от вашего выбора. Остальные (пакеты) скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов. В любой ситуации выбор всегда за вами. Вы либо гуляете под дождем, либо просто под ним мокнете.${RED}

  ***************************** ВНИМАНИЕ! *****************************
${NC}
Автор не несёт ответственности за любое нанесение вреда при использовании скрипта.
Вы используйте его на свой страх и риск, или изменяйте под свои личные нужды.
В данный момент сценарий (скрипта) находится в процессе доработки по прописыванию устанавливаемого софта (пакетов), и небольшой корректировке (Воен. Внесение поправок в наводку орудий по результатам наблюдений с наблюдательных пунктов).

${BLUE}===> ******************************************************* ${NC}"
}
###################################################################

### Display banner (Дисплей баннер)
_warning_banner

sleep 15
#echo -e "${MAGENTA}==> ${BOLD}Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети. ${NC}"
#echo 'Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети.'
# If you have a wireless connection, launch nmtui and connect to the network.

echo -e "${GREEN}
  <<< Начинается установка (пакетов) (иконки, темы, курсоры, темы-папки) для оформления Xfce в Arch Linux >>>
${NC}"
# The installation (of packages) (icons, themes, cursors, themes-folders) for Xfce design in Arch Linux begins

echo -e "${BLUE}:: ${NC}Установка и настройка начата в $(date +%T)"
#echo "Установка и настройка начата в $(date +%T)"
# Installation and configuration started in $(date +%T)

echo ""
echo -e "${GREEN}=> ${NC}Для проверки интернета можно пропинговать какой-либо сервис"
#echo 'Для проверки интернета можно пропинговать какой-либо сервис'
# To check the Internet, you can ping a service
ping -c2 archlinux.org

echo -e "${CYAN}==> ${NC}Если пинг идёт едем дальше ... :)"
#echo 'Если пинг идёт едем дальше ... :)'
# If the ping goes we go further ... :)
sleep 02

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
#------------------------
# Справка по pacman:
# --needed         не переустанавливать актуальные пакеты
# --noconfirm      не спрашивать каких-либо подтверждений
#-------------------------------
# https://git-scm.com/
# https://archlinux.org/packages/extra/x86_64/git/
# https://www.gnu.org/software/wget/wget.html
# https://archlinux.org/packages/extra/x86_64/wget/
# https://curl.se/
# https://archlinux.org/packages/core/x86_64/curl/
#--------------------------------

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Powerpill (powerpill) - Оболочка Pacman для более быстрой загрузки в Archlinux?"
echo -e "${MAGENTA}:: ${BOLD}Powerpill — это оболочка Pacman, которая использует параллельную и сегментированную загрузку через Aria2 и Reflector для ускорения загрузки Pacman. Powerpill — это скрипт-обёртка, написанный Xyne для pacman, который ускоряет загрузку пакетов, используя aria2c для параллельных/сегментированных загрузок. Он определяет целевые пакеты запрошенной операции синхронизации, а затем использует список зеркал для создания полного металинка. Этот металинк затем перенаправляется в менеджер загрузок aria2 для загрузки пакетов. Значительное сокращение времени загрузки часто возможно благодаря комбинированному эффекту одновременных и сегментированных загрузок. Powerpill также может использовать Rsync для официальных зеркал, которые его поддерживают. Это может быть эффективно для пользователей, которые уже используют всю полосу пропускания при загрузке с одного зеркала. Powerpill возрождается как полноценная, но поверхностная оболочка Pacman. ${NC}"
echo " Домашняя страница: https://xyne.dev/projects/powerpill ; (https://aur.archlinux.org/packages/powerpill) "
echo -e "${MAGENTA}:: ${BOLD}Пример: пользователь хочет обновиться и выполняет команду pacman -Syu, которая возвращает список из 20 пакетов, доступных для обновления, общим объёмом 200 мегабайт. Если пользователь загружает их через pacman, они будут скачиваться по одному. Если пользователь загружает их через powerpill, они будут скачиваться одновременно, во многих случаях в несколько раз быстрее (в зависимости от скорости соединения, наличия пакетов на серверах, скорости сервера/нагрузки и т. д.). Тестирование pacman и powerpill на одной системе выявило 4-кратное увеличение скорости в приведенном выше сценарии, где средняя скорость загрузки pacman составляла 300 кБ/с, а средняя скорость загрузки powerpill — 1,2 МБ/с.  ${NC}"
echo -e "${YELLOW}:: ${NC}Настройка: Конфигурация - Файл конфигурации Powerpill — это обычный JSON-файл. По умолчанию он находится в папке /etc/powerpill/powerpill.json. Основной объект — это словарь, содержащий несколько словарей. Последние считаются разделами файла конфигурации и содержат параметры, относящиеся к различным частям Powerpill. Подробности см. на странице руководства powerpill.json (https://xyne.dev/projects/powerpill/#powerpill.json1). Официальные репозитории Pacman не предоставляют файлы подписей базы данных. Чтобы избежать ошибок загрузки, установите SigLevel для каждого официального репозитория значение PackageRequired, например: [core] SigLevel = PackageRequired .
  Если вы получаете [err] для файлов <repo>.db.sig: Это происходит потому, что нет файлов подписей для этого репозитория, и вы не установили: SigLevel = PackageRequired в /etc/pacman.conf как описано в этом посте из форума Arch (En) (https://bbs.archlinux.org/viewtopic.php?pid=1254940#p1254940). SigLevel = Required DatabaseOptional . "
echo " Разделы - Обратите внимание, что все поля, включая названия разделов, в файле указаны в нижнем регистре. В процессе автоматического преобразования файла Markdown на странице руководства могут отображаться заглавные буквы. Например, первый раздел — «aria2», а не «ARIA2». Варианты настройки Aria2: Список аргументов, передаваемых исполняемому файлу Aria2. Подробности см. на странице руководства Aria2. По умолчанию Aria2 также загружает $HOME/.aria2/aria2.conf. При запуске с sudo это будет ссылка на домашний каталог пользователя root. Чтобы отключить эту функцию, используйте --no-conf параметр . Чтобы использовать конфигурационный файл Aria2, специфичный для Powerpill, используйте --conf-path параметр , например --conf-path=/etc/powerpill/aria2.conf. Путь к исполняемому файлу Aria2 по умолчанию: /usr/bin/aria2c . "
echo -e "${YELLOW}==> Примечание! ${NC}Обязательно прочтите эти статьи - Powerpill (https://wiki.archlinux.org/title/Powerpill) , PowerPill (https://xyne.dev/projects/powerpill/#powerpill.json1) , Настройка Archlinux Powerpill (https://misctechmusings.com/archlinux-powerpill-setup/) , Настройка pacsrv и powerpill в Arch Linux (https://www.ime.usp.br/~albert/posts/post1/). "
echo -e "${CYAN}:: ${NC}Установка Powerpill (powerpill), проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/powerpill), (https://aur.archlinux.org/powerpill.git) - собирается и устанавливается. "
echo " Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить Powerpill (powerpill),    0 - НЕТ - Пропустить установку: " in_powerpill  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_powerpill" =~ [^10] ]]
do
    :
done
if [[ $in_powerpill == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_powerpill == 1 ]]; then
  echo ""
  echo " Установка Powerpill (powerpill) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########### Зависимости ############
########### aria2 ############
sudo pacman -S --noconfirm --needed aria2  # Загрузите утилиту, которая поддерживает HTTP(S), FTP, BitTorrent и Metalink ; https://archlinux.org/packages/extra/x86_64/aria2/ ; https://aria2.github.io/ ; 2025-04-30 17:32 UTC
### aria2 — это лёгкая утилита загрузки с командной строки, работающая с несколькими протоколами и источниками . Она поддерживает HTTP/HTTPS , FTP , SFTP , BitTorrent и Metalink . Управлять aria2 можно через встроенные интерфейсы JSON-RPC и XML-RPC .
#sudo pacman -S --noconfirm --needed persepolis  # Интерфейс Qt для менеджера загрузок aria2 ; https://archlinux.org/packages/extra/any/persepolis/ ; https://persepolisdm.github.io/ ; 2025-06-04 21:15 UTC
# yay -S persepolis-git --noconfirm  # Интерфейс Qt для менеджера загрузок aria2 (версия Github) ; https://aur.archlinux.org/persepolis-git.git (только для чтения, нажмите, чтобы скопировать) ; https://persepolisdm.github.io/ ; https://aur.archlinux.org/packages/persepolis-git
### Persepolis — это менеджер загрузок, написанный на Python. Persepolis — пример свободного программного обеспечения с открытым исходным кодом. Он разработан для дистрибутивов GNU/Linux, BSD, macOS и Microsoft Windows. Функции: Многосегментная загрузка ; Планирование загрузок ; Очередь загрузки ; Поиск и загрузка видео с Youtube, Vimeo, DailyMotion, ...
# Запустить программу можно из главного меню вашего дистрибутива или из командной строки, выполнив: persepolis
# Persepolis Download Manager 4.1.0 : https://www.youtube.com/watch?v=QHdMShFgzhQ
#########################
sudo pacman -S --noconfirm --needed pyalpm  # Привязки Python 3 для libalpm ; https://archlinux.org/packages/extra/x86_64/pyalpm/ ; https://gitlab.archlinux.org/archlinux/pyalpm ; 29.05.2025 10:16 UTC
sudo pacman -S --noconfirm --needed python-setuptools  # Простая загрузка, сборка, установка, обновление и удаление пакетов Python ; https://archlinux.org/packages/extra/any/python-setuptools/ ; https://pypi.org/project/setuptools/ ; Обеспечивает: python-distribute ; Заменяет: python-distribute ; 2025-06-01 02:32 UTC
sudo pacman -S --noconfirm --needed rsync  # Быстрый и универсальный инструмент для копирования удаленных и локальных файлов ; https://archlinux.org/packages/extra/x86_64/rsync/ ; https://rsync.samba.org/ ; 2025-02-03 13:57 UTC
sudo pacman -S --noconfirm --needed reflector  # Модуль и скрипт Python 3 для извлечения и фильтрации последнего списка зеркал Pacman ; https://archlinux.org/packages/extra/any/reflector/ ; https://xyne.dev/projects/reflector ; 2024-12-22 13:05 UTC
sudo pacman -S --noconfirm --needed pacman-contrib  # Добавлены скрипты и инструменты для систем pacman ; https://archlinux.org/packages/extra/x86_64/pacman-contrib/ ; https://gitlab.archlinux.org/pacman/pacman-contrib ; 2025-06-10 01:04 UTC
########### python3-xcgf ##############
yay -S python3-xcgf --noconfirm  # Общие общие функции Xyne для внутреннего использования ; https://aur.archlinux.org/packages/python3-xcgf ; https://aur.archlinux.org/python3-xcgf.git (только для чтения, нажмите, чтобы скопировать) ; https://xyne.dev/projects/python3-xcgf ; 2024-05-17 23:45 (UTC)
########### python3-xcgf ##############
#git clone https://aur.archlinux.org/python3-xcgf.git  # (только для чтения, нажмите, чтобы скопировать)
#cd python3-xcgf
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf python3-xcgf
#rm -Rf python3-xcgf
########### python3-xcpf ##############
yay -S python3-xcpf --noconfirm  # Общие функции Pacman от Xyne для внутреннего использования ; https://aur.archlinux.org/packages/python3-xcpf ; https://aur.archlinux.org/python3-xcpf.git (только для чтения, нажмите, чтобы скопировать) ; https://xyne.dev/projects/python3-xcpf ; https://xyne.dev/projects/python3-xcpf/src/python3-xcpf-2021.12.tar.xz ; https://xyne.dev/projects/python3-xcpf/src/python3-xcpf-2021.12.tar.xz.sig ; 2024-05-17 23:45 (UTC)
########### python3-xcpf ##############
#git clone https://aur.archlinux.org/python3-xcpf.git  # (только для чтения, нажмите, чтобы скопировать)
#cd python3-xcpf
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf python3-xcpf
#rm -Rf python3-xcpf
########### pm2ml ##############
yay -S pm2ml --noconfirm  # Сгенерировать металинки для загрузки пакетов и баз данных Pacman ; https://aur.archlinux.org/packages/pm2ml ; https://aur.archlinux.org/pm2ml.git (только для чтения, нажмите, чтобы скопировать) ; https://xyne.dev/projects/pm2ml ; https://xyne.dev/projects/pm2ml/src/pm2ml-2021.11.20.1.tar.xz ; https://xyne.dev/projects/pm2ml/src/pm2ml-2021.11.20.1.tar.xz.sig ; 2024-05-17 23:43 (UTC)
########### pm2ml ##############
#git clone https://aur.archlinux.org/pm2ml.git  # (только для чтения, нажмите, чтобы скопировать)
#cd pm2ml
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf pm2ml
#rm -Rf pm2ml
########### powerpill #############
yay -S powerpill --noconfirm  # Оболочка Pacman для более быстрой загрузки ; https://aur.archlinux.org/packages/powerpill ; https://aur.archlinux.org/powerpill.git (только для чтения, нажмите, чтобы скопировать) ; https://xyne.dev/projects/powerpill ; 2024-05-17 23:43 (UTC) ; https://www.ime.usp.br/~albert/posts/post1/ ;
########### powerpill #############
#git clone https://aur.archlinux.org/powerpill.git  # (только для чтения, нажмите, чтобы скопировать)
#cd powerpill
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf powerpill
#rm -Rf powerpill
  echo ""
  echo " Обновление системы с помощью Powerpill (powerpill) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
sudo powerpill -Syu  # Чтобы обновить систему (синхронизировать и обновить установленные пакеты) используйте powerpill и опцию -Syu - как вы делаете это с pacman
echo " Установка утилит (пакетов) выполнена "
fi
########
#  echo ""
#  echo " Установка Pacserve (pacserve) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########### Зависимости ############
#sudo pacman -S --noconfirm --needed pyalpm  # Привязки Python 3 для libalpm ; https://archlinux.org/packages/extra/x86_64/pyalpm/ ; https://gitlab.archlinux.org/archlinux/pyalpm ; 29.05.2025 10:16 UTC
### sudo pacman -S --noconfirm --needed python-dbus  # Привязки Python для D-Bus ; https://archlinux.org/packages/extra/x86_64/python-dbus/ ; https://www.freedesktop.org/wiki/Software/dbus/ ; Обеспечивает: dbus-python=1.4.0, python-dbus-common=1.4.0 ; Заменяет: dbus-python, python-dbus-common ; Конфликты: с dbus-python, python-dbus-common ; 24.03.2025 15:32 UTC
### sudo pacman -S --noconfirm --needed python-gobject # Привязки Python для GLib/GObject/GIO/GTK ; https://archlinux.org/packages/extra/x86_64/python-gobject/ ; https://pygobject.gnome.org/ ; Обеспечивает: pygobject-devel=3.52.3 ; Заменяет: pygobject-devel<=3.36.1-1 ; Конфликты: с pygobject-devel ; 2025-03-24 03:58 UTC
########### python3-threaded_servers #############
# yay -S python3-threaded_servers --noconfirm  # Модули потокового сервера (ThreadedHTTPSServer, ThreadedMulticastServer, Quickserve, Pacserve) ; https://aur.archlinux.org/packages/python3-threaded_servers ; https://aur.archlinux.org/python3-threaded_servers.git (только для чтения, нажмите, чтобы скопировать) ; https://xyne.dev/projects/python3-threaded_servers ; 2024-05-17 23:45 (UTC)
########### python3-threaded_servers #############
#git clone https://aur.archlinux.org/python3-threaded_servers.git  # (только для чтения, нажмите, чтобы скопировать)
#cd python3-threaded_servers
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf python3-threaded_servers
#rm -Rf python3-threaded_servers
### ThreadedServers — это коллекция модулей Python 3 для реализации различных потоковых серверов.
# Модули: ThreadedHTTPSServer.py
# Этот модуль выделяет подклассы стандартных HTTP-серверов и обработчиков запросов, http.serverобеспечивая поддержку потоковой передачи, HTTP-дайджест-авторизации и HTTPS (т.е. SSL) для сертификатов сервера и клиента. Обработчики также предоставляют несколько удобных функций для передачи файлов (с multipart/byterangesподдержкой) и контента в кодировке UTF-8 (HTML, JSON, простой текст).
# Модули: ThreadedMulticastServer.py
# Простой многопоточный подкласс socketserver.UDPServerдля запуска сервера многоадресной рассылки. Модуль включает в себя удобную функцию для отправки многоадресных датаграмм и очень простой пример обработчика запросов.
# Модули: Quickserve.py
# Основной внутренний файл quickserve .
# Модули: Pacserve.py
# Основной внутренний файл pacserve .
# * Предостережения! Эти модули предоставляются без каких-либо гарантий. API может неожиданно меняться от версии к версии, даже если он в целом стабилен. Если вы хотите использовать эти модули в своём проекте, вам следует сохранить локальные копии рабочих версий, чтобы избежать проблем с миграцией.
########### pacserve #############
# yay -S pacserve --noconfirm  # Легкий перенос пакетов Pacman между компьютерами. Замена PkgD ; https://aur.archlinux.org/packages/pacserve ; https://aur.archlinux.org/pacserve.git (только для чтения, нажмите, чтобы скопировать) ; https://xyne.dev/projects/pacserve ; Конфликты: с pacredir ; https://xyne.dev/projects/pacserve/src/pacserve-2021.tar.xz ; https://xyne.dev/projects/pacserve/src/pacserve-2021.tar.xz.sig ; 2022-07-15 22:46 (UTC)
########### pacserve #############
#git clone https://aur.archlinux.org/pacserve.git  # (только для чтения, нажмите, чтобы скопировать)
#cd pacserve
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf pacserve
#rm -Rf pacserve
#  echo ""
#  echo " Запуск служб (как главного, так и подчиненного хоста(ов)) "
#  echo " После того как все установлено: "
# Enable opening the ports
#sudo systemctl enable pacserve-ports.service
# Enable pacserve
#sudo systemctl enable pacserve.service
# Start pacserve
#sudo systemctl start pacserve.service
### Для устранения неполадок службы можно запустить вручную. Если у вас возникли проблемы, см. раздел «Устранение неполадок».
#echo " Установка утилит (пакетов) выполнена "
#fi
#########################

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