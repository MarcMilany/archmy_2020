#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя
#BROWSER="firefox"

DESING_FOR_XFCE_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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

### Execute action in chrooted environment (Выполнение действия в хромированной среде)
_chroot() {
    arch-chroot /mnt <<EOF "${1}"
EOF
}

###################################################################

### Warning (Предупреждение)
_warning_banner() {
    echo -e "${YELLOW}
   ====================== ♥ Предупреждение ======================
${NC}
Цель сценария (скрипта) - это установка (пакетов) (иконки, темы, курсоры, темы-папки) для оформления в Arch Linux. 
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
echo -e "${MAGENTA}
  <<< Установка (пакетов) (иконок, тем, курсоров, темы-папки) из 'Официальных репозиториев Arch Linux' >>> ${NC}"

echo -e "${YELLOW}==> Примечание: ${NC}Сейчас Вы можете установить или пропустить установку (пакетов) оформления, установка будет производится в порядке перечисления (по очереди)." 
echo -e "${YELLOW}==> Внимание! ${NC}Во время установки (пакетов) (возможно) Вас попросят ввести (Пароль пользователя)." 
echo ""
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (arc-gtk-theme, arc-icon-theme, papirus-icon-theme, capitaine-cursors, hicolor-icon-theme-возможно установлена)." 
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic 
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo -e "${YELLOW}==> ${NC}Установка будет производится в порядке перечисления (по очереди)" 
#echo 'Установка будет производится в порядке перечисления (по очереди)'
# Installation will be performed in the order listed (one at a time)
echo ""
echo -e "${BLUE}:: ${NC}Установить Arc Theme (arc-gtk-theme)?" 
echo -e "${MAGENTA}:: ${BOLD}Arc Theme (arc-gtk-theme) - это плоская тема с прозрачными элементами для GTK 3, GTK 2 и различных оболочек рабочего стола, оконных менеджеров и приложений. ${NC}"
echo " Arc хорошо подходит для настольных сред на основе GTK (GNOME, Cinnamon, Xfce, Unity, MATE, Budgie и т.д.). " 
echo " Тема оформления Arc содержит три темы: Arc - светлая тема, Arc-Dark - темная тема, Arc-Darker - светлая тема с темными заголовками окон. (https://github.com/jnsh/arc-theme) "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_arc_theme  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_arc_theme" =~ [^10] ]]
do
    :
done 
if [[ $i_arc_theme == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_arc_theme == 1 ]]; then
  echo ""  
  echo " Установка Arc Theme (arc-gtk-theme) "
sudo pacman -S arc-gtk-theme --noconfirm  # Плоская тема с прозрачными элементами для GTK 3, GTK 2 и Gnome-Shell
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Arc Icon Theme (arc-icon-theme)?" 
echo -e "${YELLOW}==> Примечание: ${NC}Тема значков ещё не закончена! В некоторых случаях это может работать не так, как ожидалось."
echo -e "${MAGENTA}:: ${BOLD}Arc Icon Theme (arc-icon-theme) - это единственный полный официальный набор значков Arc, доступный где-либо, и все они живут в одной теме. (https://github.com/horst3180/arc-icon-theme) ${NC}"
echo " Эти значки и папки Arc были тщательно созданы, чтобы соответствовать всем традиционным схемам тем рабочего стола Arc, но они, безусловно, могут дополнять другие темы рабочего стола. " 
echo -e "${RED}==> Требования: ${NC}Эта тема не предоставляет значки приложений, ей нужна другая тема значков, чтобы наследовать их. По умолчанию эта тема будет искать тему значков Moka (https://aur.archlinux.org/packages/moka-icon-theme-git/ ; https://github.com/moka-project/moka-icon-theme), чтобы получить недостающие значки. "
echo " Если Moka не установлен, он будет использовать тему значков Gnome в качестве запасного варианта. "
echo -e "${CYAN}=> Справка (пояснение): ${NC}Тема значков Moka будет представлена в сценарии (скрипте) далее, пакетом Moka Icon Theme (moka-icon-theme-git)."
echo " Будьте внимательны! В данной опции выбор всегда остаётся за вами. "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_arc_icon  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_arc_icon" =~ [^10] ]]
do
    :
done 
if [[ $i_arc_icon == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_arc_icon == 1 ]]; then
  echo ""  
  echo " Установка Arc Icon Theme (arc-icon-theme) "
sudo pacman -S arc-icon-theme --noconfirm  # Тема значка дуги. Только официальные релизы
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Papirus (papirus-icon-theme)?" 
echo -e "${MAGENTA}:: ${BOLD}Papirus (papirus-icon-theme) - это бесплатная тема значков на основе SVG с открытым исходным кодом для Linux с материальным и плоским стилем. ${NC}"
echo " Все элементы имеют четкое различие и очертания. Также главная особенность - это сочные оттенки тона. " 
echo " Тема значков Papirus доступна в четырех вариантах: Papirus, Papirus Dark, Papirus Light (Лайт), ePapirus (для elementary OS и Pantheon Desktop). (https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_papirus_icon  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_papirus_icon" =~ [^10] ]]
do
    :
done 
if [[ $i_papirus_icon == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_papirus_icon == 1 ]]; then
  echo ""  
  echo " Установка Papirus (papirus-icon-theme) "
sudo pacman -S papirus-icon-theme --noconfirm  # Тема значка Papirus (папируса)
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Capitaine cursors (capitaine-cursors)?" 
echo -e "${MAGENTA}:: ${BOLD}Capitaine cursors (capitaine-cursors) - это тема x-cursor, вдохновленная macOS и основанная на KDE Breeze. Исходные файлы были созданы в Inkscape, а тема была разработана так, чтобы хорошо сочетаться с набором значков La Capitaine. ${NC}"
echo " Этот курсор должен масштабироваться соответствующим образом для любого разрешения экрана. " 
echo " Если Вы сочтёте его слишком маленьким на ваш вкус :), поищите параметры масштабирования курсора в настройках рабочего стола. (https://github.com/keeferrourke/capitaine-cursors) "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_capitaine_cur  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_capitaine_cur" =~ [^10] ]]
do
    :
done 
if [[ $i_capitaine_cur == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_capitaine_cur == 1 ]]; then
  echo ""  
  echo " Установка Capitaine cursors (capitaine-cursors) "
sudo pacman -S capitaine-cursors --noconfirm  # Тема x-cursor, вдохновленная macOS и основанная на KDE Breeze
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo -e "${MAGENTA}
  <<< Установка (пакетов) (иконок, тем, курсоров, темы для утилит) из AUR (Arch User Repository) >>> ${NC}"

echo -e "${YELLOW}==> Примечание: ${NC}Сейчас Вы можете установить или пропустить установку (пакетов) оформления, установка будет производится в порядке перечисления (по очереди)." 
echo -e "${YELLOW}==> Внимание! ${NC}Установка (пакетов) будет проходить через - Yay (Yaourt, помощник AUR), если таковой был вами установлен. Также установка (пакетов) в скрипте будет прописана через сборку из исходников, но в данный момент - Закомментирована (одинарной #), если Вам нужен именно этот способ сборки и установки, то раскомментируйте строки их установки, а строки установки (пакетов) через Yay - закомментируйте." 
echo ""
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (breeze-default-cursor-theme, moka-icon-theme-git, arc-firefox-theme-git, papirus-smplayer-theme-git, papirus-filezilla-themes, papirus-folder, papirus-libreoffice-theme, papirus-libreoffice-theme-git)." 
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic 
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo -e "${YELLOW}==> ${NC}Установка будет производится в порядке перечисления (по очереди)" 
#echo 'Установка будет производится в порядке перечисления (по очереди)'
# Installation will be performed in the order listed (one at a time)
echo ""
echo -e "${BLUE}:: ${NC}Установить Breeze Default Cursor Theme (breeze-default-cursor-theme)?" 
echo -e "${MAGENTA}:: ${BOLD}Breeze Default Cursor Theme (breeze-default-cursor-theme) - это набор элегантных указателей мыши, созданных на основе курсоров из коллекции свободной среды рабочего стола KDE. Указатели окрашены в тёмно-серые тона, наделены светлой рамкой и цветными специальными индикаторами. ${NC}"
echo " Пользоваться ими достаточно удобно как со светлыми, так и с тёмными темами оформления. Своим внешним видом они чем-то похожи на стандартные указатели Windows :) (https://www.gnome-look.org/p/999991) " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_breeze_cur  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_breeze_cur" =~ [^10] ]]
do
    :
done 
if [[ $i_breeze_cur == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_breeze_cur == 1 ]]; then
  echo ""  
  echo " Установка Breeze Default Cursor Theme (breeze-default-cursor-theme) "
yay -S breeze-default-cursor-theme --noconfirm  # Тема курсора по умолчанию Breeze
#### breeze-default-cursor-theme ####
#git clone https://aur.archlinux.org/breeze-default-cursor-theme.git  # Тема курсора по умолчанию Breeze
#cd breeze-default-cursor-theme
### makepkg -fsri
### makepkg -si
### makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е 
### sudo mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
### makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
### rm -rf breeze-default-cursor-theme 
#rm -Rf breeze-default-cursor-theme
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Moka Icon Theme (moka-icon-theme-git) и Faba Icon Theme (faba-icon-theme-git)?" 
echo -e "${MAGENTA}:: ${BOLD}Moka Icon Theme (moka-icon-theme-git) - это стилизованный набор иконок FreeDesktop, созданный для простоты. В нём используется простая геометрия и яркие цвета. (https://snwh.org/moka) ${NC}"
echo " Каждый значок Moka был разработан и оптимизирован для каждого размера, чтобы добиться идеального вида на вашем рабочем столе. (https://github.com/moka-project/moka-icon-theme) " 
echo " Кроме того, один из наиболее полных доступных наборов значков, Moka предоставляет тысячи значков для многих приложений. Независимо от того, какой рабочий стол Linux вы используете, Moka поможет вам. " 
echo -e "${MAGENTA}:: ${BOLD}Faba Icon Theme (faba-icon-theme-git) - это сексуальный и современный набор иконок FreeDesktop с элементами танго и элементарных элементов. (https://snwh.org/moka) (https://snwh.org/) ${NC}"
echo " Faba была разработана с учетом простоты и соответствия стандартам значков. (https://github.com/snwh/faba-icon-theme) " 
echo " Он специально разработан как базовый с минимальным набором значков для темы значков Moka (или других тем). "
echo -e "${CYAN}=> Копирование или повторное использование: ${NC}Этот проект имеет смешанное лицензирование. Вы можете свободно копировать, распространять и / или изменять аспекты этой работы в соответствии с условиями каждой лицензии (если не указано иное). "
echo " Будьте внимательны! В данной опции выбор всегда остаётся за вами. "
# Be careful! In this option, the choice is always yours.
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_moka_icon  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_moka_icon" =~ [^10] ]]
do
    :
done 
if [[ $i_moka_icon == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_moka_icon == 1 ]]; then
  echo ""  
  echo " Установка Moka Icon Theme (moka-icon-theme-git) "
yay -S moka-icon-theme-git --noconfirm  # Тема значков разработана в минималистичном плоском стиле с использованием простой геометрии и цветов
#### moka-icon-theme-git ####
#git clone https://aur.archlinux.org/moka-icon-theme-git.git  # Это иконный проект для FreeDesktop
#cd moka-icon-theme-git
### makepkg -fsri
### makepkg -si
### makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е 
### sudo mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
### makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
### rm -rf moka-icon-theme-git 
#rm -Rf moka-icon-theme-git
  echo ""  
  echo " Установка Faba Icon Theme (faba-icon-theme-git) "
yay -S faba-icon-theme-git --noconfirm  # Это базовый набор иконок для Faba. Он разработан с учетом простоты и соответствия стандартам
#### faba-icon-theme-git ####
#git clone https://aur.archlinux.org/faba-icon-theme-git.git  # Это базовый набор иконок для Faba
#cd faba-icon-theme-git
### makepkg -fsri
### makepkg -si
### makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е 
### sudo mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
### makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
### rm -rf faba-icon-theme-git 
#rm -Rf faba-icon-theme-git
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
#-------------------------
# Могу я предложить добавить Faenza к наследству?
# это решит некоторые проблемы с отсутствующими значками (например, в tidybattery) как для Faba, так и для Moka.
# поэтому в Faba / index.theme в разделе [Иконки] добавьте строку:
# Inherits = Faenza,
#----------------------------

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Arc Firefox Theme (arc-firefox-theme-git)?" 
echo -e "${MAGENTA}:: ${BOLD}Arc Firefox Theme (arc-firefox-theme-git) - это официальная тема Arc Firefox, созданная для браузера Firefox (mozilla.org). ${NC}"
echo -e "${YELLOW}==> Примечание: ${NC}Эта тема предназначена для использования вместе с темой Arc GTK (arc-gtk-theme), не используйте ее с другими темами GTK, иначе она будет выглядеть сломанной. (https://github.com/jnsh/arc-theme)"
echo " Тема доступна в виде коллекции на (addons.mozilla.org). (https://github.com/horst3180/arc-firefox-theme) " 
echo -e "${RED}==> Требования: ${NC}Эта тема совместима с Firefox 40+ и Firefox 38 ESR. "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_arc_firefox  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_arc_firefox" =~ [^10] ]]
do
    :
done 
if [[ $i_arc_firefox == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_arc_firefox == 1 ]]; then
  echo ""  
  echo " Установка Arc Firefox Theme (arc-firefox-theme-git) "
yay -S arc-firefox-theme-git --noconfirm  # Тема Arc Firefox
#### arc-firefox-theme-git ####
#git clone https://aur.archlinux.org/arc-firefox-theme-git.git  # Тема Arc Firefox
#cd arc-firefox-theme-git
### makepkg -fsri
### makepkg -si
### makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е 
### sudo mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
### makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
### rm -rf arc-firefox-theme-git 
#rm -Rf arc-firefox-theme-git
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Papirus theme for SMPlayer (papirus-smplayer-theme-git)?" 
echo -e "${MAGENTA}:: ${BOLD}Papirus theme for SMPlayer (papirus-smplayer-theme-git) - это тема созданная PapirusDevelopmentTeam для медиаплеера со встроенными кодеками SMPlayer (https://www.smplayer.info/). ${NC}"
echo -e "${YELLOW}==> Примечание: ${NC}Начиная с версии SMPlayer 16.6 и выше, в пакет были добавлены темы Papirus и Papirus Dark. Сменить тему можно (нужно) в настройках внешнего вида в самом плеера! (https://github.com/PapirusDevelopmentTeam/papirus-smplayer-theme)"
echo -e "${CYAN}=> Справка (пояснение): ${NC}Если у Вас в системе вместе с пакетом (smplayer) установлен пакет (smplayer-themes), то можете ПРОПУСТИТЬ установку Papirus theme for SMPlayer (papirus-smplayer-theme-git), так как написано выше в пакет уже были добавлены темы Papirus и Papirus Dark. (может возникнуть конфликт пакета papirus-smplayer-theme-git с пакетом smplayer-themes) "
echo " Вы также можете использовать сценарии для установки последней версии прямо из этого репо (независимо от вашего дистрибутива), через GNU Wget (wget). Но в данный момент команда - Закомментирована (двойной ##), если Вам нужен именно этот способ сборки и установки, то раскомментируйте строки установки, а строки установки (пакетов) через Yay - закомментируйте. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_papirus_smpl  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_papirus_smpl" =~ [^10] ]]
do
    :
done 
if [[ $i_papirus_smpl == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_papirus_smpl == 1 ]]; then
  echo ""  
  echo " Установка Papirus theme for SMPlayer (papirus-smplayer-theme-git) "
yay -S papirus-smplayer-theme-git --noconfirm  # Тема Papirus для SMPlayer (версия git)
### * Установить тему: 
## wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-smplayer-theme/master/install.sh | sh
### * Удалить тему для плеера:
### wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-smplayer-theme/master/install.sh | env uninstall=true sh
#### papirus-smplayer-theme-git #### 
#git clone https://aur.archlinux.org/papirus-smplayer-theme-git.git  # Тема Papirus для SMPlayer (версия git) 
#cd papirus-smplayer-theme-git
### makepkg -fsri
### makepkg -si
### makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е 
### sudo mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
### makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
### rm -rf papirus-smplayer-theme-git 
#rm -Rf papirus-smplayer-theme-git
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Papirus theme for FileZilla (papirus-filezilla-themes)?" 
echo -e "${MAGENTA}:: ${BOLD}Papirus theme for FileZilla (papirus-filezilla-themes) - это тема созданная PapirusDevelopmentTeam для FileZilla (быстрый и надежный клиент FTP, FTPS...) (https://filezilla-project.org/). ${NC}"
echo -e "${YELLOW}==> Примечание: ${NC}Запустите FileZilla и выберите тему. (https://github.com/PapirusDevelopmentTeam/papirus-filezilla-themes)"
echo -e "${CYAN}=> Справка: ${NC}Запустите FileZilla и в строке меню выберите Правка → Настройки. В окне настроек слева выберите Интерфейс → Категория Темы. Выберите новую тему из раскрывающегося списка тем. Выберите масштабный коэффициент 1,00 вместо 1,25 (или оставьте как есть - в зависимости от темы). Нажмите кнопку ОК, чтобы установить новую выбранную тему."
echo " Вы также можете использовать сценарии для установки последней версии прямо из этого репо (независимо от вашего дистрибутива), через GNU Wget (wget). Но в данный момент команда - Закомментирована (двойной ##), если Вам нужен именно этот способ сборки и установки, то раскомментируйте строки установки, а строки установки (пакетов) через Yay - закомментируйте. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_papirus_zilla  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_papirus_zilla" =~ [^10] ]]
do
    :
done 
if [[ $i_papirus_zilla == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_papirus_zilla == 1 ]]; then
  echo ""  
  echo " Установка Papirus theme for FileZilla (papirus-filezilla-themes) "
yay -S papirus-filezilla-themes --noconfirm  # Тема значков Papirus для Filezilla
### * Установить тему: 
## wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-filezilla-themes/master/install.sh | sh
### * Удалить тему для клиента FTP:
### wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-filezilla-themes/master/install.sh | env uninstall=true sh
#### papirus-filezilla-themes #### 
#git clone https://aur.archlinux.org/papirus-filezilla-themes.git  # Тема значков Papirus для Filezilla 
#cd papirus-filezilla-themes
### makepkg -fsri
### makepkg -si
### makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е 
### sudo mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
### makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
### rm -rf papirus-filezilla-themes 
#rm -Rf papirus-filezilla-themes
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Papirus Folders (papirus-folder)?" 
echo -e "${MAGENTA}:: ${BOLD}Papirus Folders (papirus-folder) - это сценарий bash, который позволяет изменять цвет папок в теме значков Papirus и её ветвях (основанных на версии 20171007 и новее). ${NC}"
echo -e "${YELLOW}==> Примечание: ${NC}Чтобы изменить цвет отдельной папки, вы можете использовать Folder Color или Dolphin Folder Color. (https://github.com/PapirusDevelopmentTeam/papirus-folders)"
echo -e "${CYAN}=> Использование скрипта: ${NC}Папки Papirus не имеют графического интерфейса, но это полнофункциональное приложение командной строки с дополнениями TAB. Ниже Вы увидите несколько примеров использования."
echo " Вы также можете использовать сценарии для установки последней версии прямо из этого репо (независимо от вашего дистрибутива), через GNU Wget (wget). Но в данный момент команда - Закомментирована (двойной ##), если Вам нужен именно этот способ сборки и установки, то раскомментируйте строки установки, а строки установки (пакетов) через Yay - закомментируйте. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_papirus_folder  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_papirus_folder" =~ [^10] ]]
do
    :
done 
if [[ $i_papirus_folder == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_papirus_folder == 1 ]]; then
  echo ""  
  echo " Установка Papirus Folders (papirus-folder) "
##yay -S papirus-folder --noconfirm  # Изменение цвета папки темы значка Papirus
### * Установить тему: 
wget -qO- https://git.io/papirus-folders-install | sh
papirus-folders -l --theme Papirus-Dark
### * Удалить тему:
### wget -qO- https://git.io/papirus-folders-install | env uninstall=true sh
#### papirus-folder #### 
#git clone https://aur.archlinux.org/papirus-folders.git  # Изменение цвета папки темы значка Papirus 
#cd papirus-folder
### makepkg -fsri
### makepkg -si
### makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е 
### sudo mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
### makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
### rm -rf papirus-folder 
#rm -Rf papirus-folder
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
#---------------------------
# Использование скрипта:
# Выбор нужных нам иконок (выбираем нужный цвет по таблице)
# * Показать текущий цвет и доступные цвета для Papirus-Dark
# papirus-folders -l --theme Papirus-Dark
# * Измените цвет папок на коричневый для Papirus-Dark
# papirus-folders -C brown --theme Papirus-Dark
# * Вернуться к цвету папок по умолчанию для Papirus-Dark
# papirus-folders -D --theme Papirus-Dark
# * Восстановить последний использованный цвет из файла конфигурации
# papirus-folders -Ru
# Последняя команда чрезвычайно полезна для восстановления цвета после обновления темы значка (официальные установщики papirus-icon-theme и некоторых сторонних пакетов делают это автоматически).
#---------------------------

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Papirus theme for LibreOffice (papirus-libreoffice-theme) или (papirus-libreoffice-theme-git)?" 
echo -e "${RED}==> Важно! ${NC}Написано этот проект не поддерживается, LibreOffice 5.3 - последняя поддерживаемая версия, но саму тему МОЖНО установить. "
echo -e "${GREEN} ==> Проверено! РАБОТАЕТ в LibreOffice версии - (libreoffice-still 7.0.5-1) ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Papirus theme for LibreOffice (papirus-libreoffice-theme) и (papirus-libreoffice-theme-git) - это тема созданная PapirusDevelopmentTeam для LibreOffice (https://www.libreoffice.org/). ${NC}"
echo " Тема Papirus для LibreOffice доступна в трех вариантах: ePapirus, Papirus, Papirus Dark. (https://github.com/PapirusDevelopmentTeam/papirus-libreoffice-theme) "
echo -e "${YELLOW}==> Примечание: ${NC}Перейдите в Инструменты → Параметры → LibreOffice → Просмотр, чтобы выбрать тему."
echo " Вы также можете использовать сценарии для установки последней версии прямо из этого репо (независимо от вашего дистрибутива), через GNU Wget (wget). Но в данный момент команда - Закомментирована (двойной ##), если Вам нужен именно этот способ сборки и установки, то раскомментируйте строки установки, а строки установки (пакетов) через Yay - закомментируйте. " 
echo " Будьте внимательны! В данной опции выбор всегда остаётся за вами. "
# Be careful! In this option, the choice is always yours.
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Установить (papirus-libreoffice-theme),   2 - Установить (papirus-libreoffice-theme-git),       

    0 - НЕТ - Пропустить установку: " i_papirus_libre  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_papirus_libre" =~ [^120] ]]
do
    :
done 
if [[ $i_papirus_libre == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_papirus_libre == 1 ]]; then
  echo ""  
  echo " Установка Papirus theme for LibreOffice (papirus-libreoffice-theme) "
yay -S papirus-libreoffice-theme --noconfirm  # Тема Papirus для LibreOffice
### * Установить тему: 
## wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-libreoffice-theme/master/install-papirus-root.sh | sh
### * Удалить тему:
### wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-libreoffice-theme/master/remove-papirus.sh | sh
#### papirus-libreoffice-theme #### 
#git clone https://aur.archlinux.org/papirus-libreoffice-theme.git  # Тема Papirus для LibreOffice
#cd papirus-libreoffice-theme
### makepkg -fsri
### makepkg -si
### makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е 
### sudo mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
### makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
### rm -rf papirus-libreoffice-theme 
#rm -Rf papirus-libreoffice-theme
echo ""   
echo " Установка утилит (пакетов) выполнена "
elif [[ $i_papirus_libre == 2 ]]; then
  echo ""  
  echo " Установка Papirus theme for LibreOffice (papirus-libreoffice-theme-git) "
yay -S papirus-libreoffice-theme-git --noconfirm  # Тема Papirus для LibreOffice
### * Установить тему: 
## wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-libreoffice-theme/master/install-papirus-root.sh | sh
### * Удалить тему:
### wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-libreoffice-theme/master/remove-papirus.sh | sh
#### papirus-libreoffice-theme-git #### 
#git clone https://aur.archlinux.org/papirus-libreoffice-theme-git.git  # Тема Papirus для LibreOffice 
#cd papirus-libreoffice-theme-git
### makepkg -fsri
### makepkg -si
### makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е 
### sudo mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
### makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
### rm -rf papirus-libreoffice-theme-git
#rm -Rf papirus-libreoffice-theme-git
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
###########################################

clear
echo -e "${GREEN}
  <<< Поздравляем! Установка утилит (пакетов) оформления завершена! >>> ${NC}"
# Congratulations! The installation of the design utilities (packages) is complete!.
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
echo -e "${GREEN}
  <<< Желаю Вам удачи во всех начинаниях, верных и точных решений! >>> ${NC}"
echo ""
echo -e "${RED}### ${BLUE}########################################################### ${RED}### ${NC}" 
echo -e "${RED}==> ${BOLD}Выходим из установленной системы ${NC}"

echo -e "${BLUE}:: ${BOLD}Теперь вам надо ввести exit, затем перезагрузить систему ${NC}"
echo ""
# echo " Установка завершена для выхода введите >> exit << "
#exit(0)  # означает чистый выход без каких-либо ошибок (проблем)
#exit(1)  # означает, что была какая-то ошибка (проблема), и именно поэтому программа выходит

############ Design for Xfce ###########
###
### arc-gtk-theme - # Плоская тема с прозрачными элементами для GTK 3, GTK 2 и Gnome-Shell
### https://www.archlinux.org/packages/community/any/arc-gtk-theme/
### https://github.com/jnsh/arc-theme
###
### arc-icon-theme - # Тема значка дуги. Только официальные релизы
### https://www.archlinux.org/packages/community/any/arc-icon-theme/
### https://github.com/horst3180/arc-icon-theme
###
### arc-firefox-theme  AUR  # Официальная тема Arc Firefox (отсутствует)
### https://aur.archlinux.org/packages/arc-firefox-theme/ 
### https://aur.archlinux.org/arc-firefox-theme.git
###
### arc-firefox-theme-git  AUR  # Тема Arc Firefox
### https://aur.archlinux.org/packages/arc-firefox-theme-git/ 
### https://aur.archlinux.org/arc-firefox-theme-git.git
### https://github.com/horst3180/arc-firefox-theme 
###
### papirus-icon-theme - # Тема значка Papirus (папируса)
### https://www.archlinux.org/packages/community/any/papirus-icon-theme/
### https://github.com/PapirusDevelopmentTeam/papirus-icon-theme
###
### capitaine-cursors - # Тема x-cursor, вдохновленная macOS и основанная на KDE Breeze
### https://www.archlinux.org/packages/community/any/capitaine-cursors/
### https://github.com/keeferrourke/capitaine-cursors
###
### hicolor-icon-theme - # Freedesktop.org Hicolor тема значков (возможно уже установлена)
### https://www.archlinux.org/packages/extra/any/hicolor-icon-theme/
### https://www.freedesktop.org/wiki/Software/icon-theme/
###
### breeze-default-cursor-theme  AUR  # Тема курсора по умолчанию Breeze.
### https://aur.archlinux.org/packages/breeze-default-cursor-theme/
### https://aur.archlinux.org/breeze-default-cursor-theme.git 
### https://www.gnome-look.org/p/999991
###
### moka-icon-theme-git  AUR  # Тема значков разработана в минималистичном плоском стиле с использованием простой геометрии и цветов
### https://aur.archlinux.org/packages/moka-icon-theme-git/
### https://aur.archlinux.org/moka-icon-theme-git.git 
### https://github.com/moka-project/moka-icon-theme
### https://snwh.org/moka
###
### faba-icon-theme-git  AUR  # Это базовый набор иконок для Faba. Он разработан с учетом простоты и соответствия стандартам
### https://aur.archlinux.org/packages/faba-icon-theme-git/
### https://aur.archlinux.org/faba-icon-theme-git.git
### https://github.com/snwh/faba-icon-theme
### https://snwh.org/
### Последнее обновление:	2016-02-20 22:39
###
### papirus-smplayer-theme-git  AUR  # Тема Papirus для SMPlayer (версия git)  
### https://aur.archlinux.org/packages/papirus-smplayer-theme-git/ 
### https://aur.archlinux.org/papirus-smplayer-theme-git.git 
### https://github.com/PapirusDevelopmentTeam/papirus-smplayer-theme
###
### papirus-filezilla-themes  AUR  # Тема значков Papirus для Filezilla
### https://aur.archlinux.org/packages/papirus-filezilla-themes/
### https://aur.archlinux.org/papirus-filezilla-themes.git 
### https://github.com/PapirusDevelopmentTeam/papirus-filezilla-themes
###
### papirus-folder  AUR  # Изменение цвета папки темы значка Papirus
### https://aur.archlinux.org/packages/papirus-folders/ 
### https://aur.archlinux.org/papirus-folders.git
### https://github.com/PapirusDevelopmentTeam/papirus-folders
###
### papirus-libreoffice-theme  AUR  # Тема Papirus для LibreOffice (Возможно этот проект не поддерживается)
### https://aur.archlinux.org/packages/papirus-libreoffice-theme/
### https://aur.archlinux.org/papirus-libreoffice-theme.git 
### https://github.com/PapirusDevelopmentTeam/papirus-libreoffice-theme 
### Последнее обновление: 2020-01-14 21:27
###
### papirus-libreoffice-theme-git  AUR  # Тема Papirus для LibreOffice (Возможно этот проект не поддерживается)
### https://aur.archlinux.org/packages/papirus-libreoffice-theme-git/
### https://aur.archlinux.org/papirus-libreoffice-theme-git.git 
### https://github.com/PapirusDevelopmentTeam/papirus-libreoffice-theme
### Последнее обновление: 2020-08-15 14:03
###
################################


































