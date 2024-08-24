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
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (arc-gtk-theme, arc-solid-gtk-theme, arc-icon-theme, papirus-icon-theme, capitaine-cursors, hicolor-icon-theme-возможно установлена)." 
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
sudo pacman -S --noconfirm --needed arc-gtk-theme  # Плоская тема с прозрачными элементами для GTK 3, GTK 2 и Gnome-Shell ; https://github.com/jnsh/arc-theme ; https://archlinux.org/packages/extra/any/arc-gtk-theme/
sudo pacman -S --noconfirm --needed arc-solid-gtk-theme  # Плоская тема для GTK 3, GTK 2 и Gnome-Shell (без прозрачности) https://github.com/jnsh/arc-theme ; https://archlinux.org/packages/extra/any/arc-solid-gtk-theme/
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
sudo pacman -S --noconfirm --needed arc-icon-theme  # Тема значка дуги. Только официальные релизы
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
sudo pacman -S --noconfirm --needed papirus-icon-theme  # Тема значка Papirus (папируса)
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Material Design (materia-gtk-theme)?" 
echo -e "${MAGENTA}:: ${BOLD}Material (materia-gtk-theme) - это бесплатная тема значков для сред рабочего стола на базе GNOME/GTK. ${NC}"
echo " Поддерживает GTK 2, GTK 3, GTK 4, GNOME Shell, Budgie, Cinnamon, MATE, Unity, Xfce, LightDM, GDM, тему Chrome и т. д. " 
echo " Для правильного отображения темы используйте шрифт средней насыщенности (например, Roboto или M+ ). Установите размер шрифта 9.75(= 13 пикселей при 96 точках на дюйм) или 10.5(= 14 пикселей при 96 точках на дюйм). Чтобы улучшить внешний вид Chrome, вы можете установить наши расширения Chrome следующим образом: Откройте /usr/share/themes/Materia<-variant>/chrome папку в файловом менеджере. Перетащите .crx файлы на страницу расширений Chrome ( chrome://extensions). Вы можете изменить тему GDM (экран блокировки/входа в систему), заменив стандартную тему GNOME Shell. Подробности см .INSTALL_GDM_THEME.md (https://github.com/nana-4/materia-theme). "
echo " Materia можно настраивать с помощью графического пользовательского интерфейса, конструктора тем oomox (https://github.com/themix-project/themix-gui). Materia также позволяет вам относительно легко менять цветовую схему другими способами. HACKING.md Подробности см. "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_materia  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_materia" =~ [^10] ]]
do
    :
done 
if [[ $i_materia == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_materia == 1 ]]; then
  echo ""  
  echo " Установка Material (materia-gtk-theme) "
sudo pacman -S --noconfirm --needed materia-gtk-theme  # Тема Material Design для сред рабочего стола на базе GNOME/GTK+ ; https://github.com/nana-4/materia-theme ; https://archlinux.org/packages/extra/any/materia-gtk-theme/
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Adapta (adapta-gtk-theme)?" 
echo -e "${MAGENTA}:: ${BOLD}Adapta (adapta-gtk-theme) - это Адаптивная тема Gtk+, основанная на рекомендациях по материальному дизайну. ${NC}"
echo " Adapta сильно зависит от ресурсов Material Design, особенно от шрифтов . " 
echo " Для правильного отображения темы используйте шрифт Очень известен как шрифт TrueType по умолчанию в Android (английская версия). Многоязычная поддержка не очень хороша. Вес, используемый в Adapta: 300, 400, 500, 700 . Шрифт Noto (NO TOfu) без засечек TrueType/OpenType, поддерживающий множество языков. Разработано Monotype и Adobe. Вес, используемый в Adapta: 400, (500), 700 . (https://github.com/adapta-project/adapta-gtk-theme). "
echo " Если были установлены/существовали предыдущие версии темы, сначала удалите их. (Adapta,Adapta-Eta,Adapta-Nokto,Adapta-Nokto-Eta) "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_adapta  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_adapta" =~ [^10] ]]
do
    :
done 
if [[ $i_adapta == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_adapta == 1 ]]; then
  echo ""  
  echo " Установка Adapta (adapta-gtk-theme) "
sudo pacman -S --noconfirm --needed adapta-gtk-theme  # Адаптивная тема Gtk+, основанная на Material Design Guidelines ; https://github.com/adapta-project/adapta-gtk-theme ; https://archlinux.org/packages/extra/any/adapta-gtk-theme/
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
########################
### Если были установлены/существовали предыдущие версии, сначала удалите их.
# sudo rm -rf /usr/share/themes/{Adapta,Adapta-Eta,Adapta-Nokto,Adapta-Nokto-Eta}
# rm -rf ~/.local/share/themes/{Adapta,Adapta-Eta,Adapta-Nokto,Adapta-Nokto-Eta}
# rm -rf ~/.themes/{Adapta,Adapta-Eta,Adapta-Nokto,Adapta-Nokto-Eta}
##########################

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
sudo pacman -S --noconfirm --needed capitaine-cursors  # Тема x-cursor, вдохновленная macOS и основанная на KDE Breeze
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
sleep 5

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Arc Theme (arc-gtk-theme-git)?" 
echo -e "${MAGENTA}:: ${BOLD}Arc Theme (arc-gtk-theme-git) - это плоская тема с прозрачными элементами для GTK 3, GTK 2 и различных оболочек рабочего стола, оконных менеджеров и приложений. Она хорошо подходит для сред рабочего стола на основе GTK, таких как GNOME, Cinnamon, Xfce, Unity, MATE, Budgie и т. д.. ${NC}"
echo " Тема «Арка» Arc доступен в четырех вариантах. Цель этого форка — обновлять тему новыми версиями инструментария и среды рабочего стола, решать существующие проблемы, а также улучшать и совершенствовать тему, сохраняя при этом оригинальный визуальный дизайн. " 
echo " Первоначально тема была разработана и разработана horst3180 , но проект не поддерживается с мая 2017 года. (https://aur.archlinux.org/packages/arc-gtk-theme-git) "
echo -e "${YELLOW}==> Внимание! ${NC}Установка (пакетов) будет проходить через - Yay (Yaourt, помощник AUR), если таковой был вами установлен. Также установка (пакетов) в скрипте будет прописана через сборку из исходников, но в данный момент - Закомментирована (одинарной #), если Вам нужен именно этот способ сборки и установки, то раскомментируйте строки их установки, а строки установки (пакетов) через Yay - закомментируйте." 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_arc_git  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_arc_git" =~ [^10] ]]
do
    :
done 
if [[ $i_arc_git == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_arc_git == 1 ]]; then
  echo ""  
  echo " Установка Arc Theme (arc-gtk-theme-git) "
yay -S arc-gtk-theme-git --noconfirm   # Плоский тематический комплект с прозрачными элементами ; https://aur.archlinux.org/arc-gtk-theme-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/jnsh/arc-theme ; https://aur.archlinux.org/packages/arc-gtk-theme-git
#### arc-gtk-theme-git ####
#git clone https://aur.archlinux.org/arc-gtk-theme-git.git   # (только для чтения, нажмите, чтобы скопировать)
#cd arc-gtk-theme-git
### makepkg -fsri
### makepkg -si
### makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е 
### sudo mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
### makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
### rm -rf arc-gtk-theme-git 
#rm -Rf arc-gtk-theme-git
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
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
echo -e "${BLUE}:: ${NC}Установить Qogir-icon-theme (qogir-icon-theme)?" 
echo -e "${MAGENTA}:: ${BOLD}Qogir-icon-theme (qogir-icon-theme) - это тема Тема иконок Qogir. Плоская красочная тема иконок для рабочих столов Linux (https://www.pling.com/p/1296407). ${NC}"
echo -e "${CYAN}=> Справка: ${NC}Будьте внимательны! В данной опции выбор всегда остаётся за вами. "
echo " Вы также можете использовать сценарии для установки последней версии прямо из этого репо (независимо от вашего дистрибутива), через GNU Wget (wget). Но в данный момент команда - Закомментирована (двойной ##), если Вам нужен именно этот способ сборки и установки, то раскомментируйте строки установки, а строки установки (пакетов) через Yay - закомментируйте. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_qogir  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_qogir" =~ [^10] ]]
do
    :
done 
if [[ $i_qogir == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_qogir == 1 ]]; then
  echo ""  
  echo " Установка Qogir-icon-theme (qogir-icon-theme) "
yay -S qogir-icon-theme --noconfirm  # Красочная тема иконок для рабочего стола Linux
### https://aur.archlinux.org/qogir-icon-theme.git (только для чтения, нажмите, чтобы скопировать) ; https://www.pling.com/p/1296407 ; https://aur.archlinux.org/packages/qogir-icon-theme
# yay -S qogir-icon-theme-git --noconfirm  # Красочная тема иконок для рабочего стола Linux
### https://aur.archlinux.org/qogir-icon-theme-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/vinceliuice/Qogir-icon-theme ; https://aur.archlinux.org/packages/qogir-icon-theme-git
#### qogir-icon-theme #### 
#git clone https://aur.archlinux.org/qogir-icon-theme.git  # Красочная тема иконок для рабочего стола Linux 
#cd qogir-icon-theme
### makepkg -fsri
### makepkg -si
### makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е 
### sudo mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
### makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
### rm -rf qogir-icon-theme 
#rm -Rf qogir-icon-theme
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Numix (numix-icon-theme-git)?" 
echo -e "${MAGENTA}:: ${BOLD}Numix (numix-icon-theme-git) - это официальная тема иконок от проекта Numix . Она во многом вдохновлена и основана на частях тем иконок Elementary, Humanity и Gnome. Numix разработана для использования вместе с темой иконок приложений, например Numix Circle или Numix Square . Этот файл readme содержит информацию об установке и запросах иконок . (https://github.com/numixproject/numix-icon-theme). Numix —  Лицензируется по лицензии GPL-3.0+ . ${NC}"
echo -e "${CYAN}=> Справка: ${NC}Будьте внимательны! Для работы с жестко запрограммированными значками состояния Numix рекомендует использовать скрипт Hardcode Tray https://github.com/bilelmoussaoui/Hardcode-Tray (https://github.com/bilelmoussaoui/Hardcode-Tray.git). "
echo " Вы также можете использовать сценарии для установки последней версии прямо из этого репо (независимо от вашего дистрибутива), через GNU Wget (wget). Но в данный момент команда - Закомментирована (двойной ##), если Вам нужен именно этот способ сборки и установки, то раскомментируйте строки установки, а строки установки (пакетов) через Yay - закомментируйте. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_numix  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_numix" =~ [^10] ]]
do
    :
done 
if [[ $i_numix == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_numix == 1 ]]; then
  echo ""  
  echo " Установка Numix (numix-icon-theme-git) "
yay -S numix-icon-theme-git --noconfirm  # Базовая тема иконок из проекта Numix ; https://aur.archlinux.org/numix-icon-theme-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/numixproject/numix-icon-theme ; https://aur.archlinux.org/packages/numix-icon-theme-git
#### numix-icon-theme-git #### 
#git clone https://aur.archlinux.org/numix-icon-theme-git.git   # (только для чтения, нажмите, чтобы скопировать) 
#cd numix-icon-theme-git
### makepkg -fsri
### makepkg -si
### makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е 
### sudo mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
### makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
### rm -rf numix-icon-theme-git 
#rm -Rf numix-icon-theme-git
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Numix Circle (numix-circle-icon-theme-git)?" 
echo -e "${MAGENTA}:: ${BOLD}Numix Circle (numix-circle-icon-theme-git) - это тема значков приложений для Linux из проекта Numix , предназначенная для использования поверх нашей базовой темы значков . Этот readme содержит информацию об установке , запросах значков и жестко закодированных значках. . Этот файл readme содержит информацию об установке и запросах иконок . (https://github.com/numixproject/numix-icon-theme-circle/). Numix Circle —  Лицензируется по лицензии GPL-3.0+ . ${NC}"
echo -e "${CYAN}=> Справка: ${NC}Будьте внимательны! Для работы с жестко закодированными иконками приложений Numix использует скрипт hardcode-fixer (https://github.com/Foggalong/hardcode-fixer). Список поддерживаемых скриптом приложений можно найти здесь (https://github.com/Foggalong/hardcode-fixer/wiki/App-Support) . Иконки Steam для рабочего процесса : Чтобы исправить иконки запущенных игр Steam, вы можете воспользоваться скриптом Steam Icons Fixer (https://github.com/BlueManCZ/SIF), который свяжет все доступные иконки из нашей темы иконок с вашими установленными играми. Конфликты: с numix-circle-icon-theme, numix-circle-light-icon-theme . "
echo " Вы также можете использовать сценарии для установки последней версии прямо из этого репо (независимо от вашего дистрибутива), через GNU Wget (wget). Но в данный момент команда - Закомментирована (двойной ##), если Вам нужен именно этот способ сборки и установки, то раскомментируйте строки установки, а строки установки (пакетов) через Yay - закомментируйте. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_numix_circle  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_numix_circle" =~ [^10] ]]
do
    :
done 
if [[ $i_numix_circle == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_numix_circle == 1 ]]; then
  echo ""  
  echo " Установка Numix Circle (numix-circle-icon-theme-git) "
yay -S numix-circle-icon-theme-git --noconfirm  # Тема круглых иконок из проекта Numix ; https://aur.archlinux.org/numix-circle-icon-theme-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/numixproject/numix-icon-theme-circle/ ; https://aur.archlinux.org/packages/numix-circle-icon-theme-git
#### numix-circle-icon-theme-git #### 
#git clone https://aur.archlinux.org/numix-circle-icon-theme-git.git   # (только для чтения, нажмите, чтобы скопировать)
#cd numix-circle-icon-theme-git
### makepkg -fsri
### makepkg -si
### makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е 
### sudo mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
### makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
### rm -rf numix-circle-icon-theme-git 
#rm -Rf numix-circle-icon-theme-git
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Paper — проект иконок для FreeDesktop (paper-gtk-theme-git) (paper-icon-theme-git)?" 
echo -e "${MAGENTA}:: ${BOLD}Paper (paper-gtk-theme-git) (paper-icon-theme-git) - это проект иконок для FreeDesktop. Как и принципы Material Design, которые его вдохновляют, Paper также базируется на использовании смелых цветов и простых геометрических форм. Каждая иконка была тщательно разработана для идеального просмотра в пикселях при любом размере. Дополнением к теме иконок является тема курсора Paper. Она имеет геометрически простой стиль, разработанный для дополнения иконок Paper. ${NC}"
echo " Paper — это современная тема иконок freedesktop, дизайн которой основан на использовании смелых цветов и простых геометрических форм для составления иконок. Каждая иконка была тщательно разработана для просмотра с точностью до пикселя. Хотя в дизайне определенно прослеживается влияние иконок в Material Design от Google, некоторые аспекты были скорректированы для лучшего соответствия среде рабочего стола. "
echo -e "${CYAN}=> Справка: ${NC}Будьте внимательны! Вместе с темой устанавливается пакет (gtk-update-icon-cache)  # Обновление кэша иконок GTK . Разработчики по всему миру используют GTK в качестве платформы для создания приложений, решающих проблемы, с которыми сталкиваются конечные пользователи. "
echo " Вы также можете использовать сценарии для установки последней версии прямо из этого репо (независимо от вашего дистрибутива), через GNU Wget (wget). Но в данный момент команда - Закомментирована (двойной ##), если Вам нужен именно этот способ сборки и установки, то раскомментируйте строки установки, а строки установки (пакетов) через Yay - закомментируйте. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_numix_circle  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_numix_circle" =~ [^10] ]]
do
    :
done 
if [[ $i_numix_circle == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_numix_circle == 1 ]]; then
  echo ""  
  echo " Установка Paper (paper-gtk-theme-git) (paper-icon-theme-git) "
yay -S paper-gtk-theme-git --noconfirm  # Современный набор тем для рабочего стола. Его дизайн в основном плоский с минимальным использованием теней для глубины ; https://aur.archlinux.org/paper-gtk-theme-git.git (только для чтения, нажмите, чтобы скопировать) ; https://snwh.org/paper ; https://aur.archlinux.org/packages/paper-gtk-theme-git
#### paper-gtk-theme-git #### 
#git clone https://aur.archlinux.org/paper-gtk-theme-git.git (только для чтения, нажмите, чтобы скопировать)
#cd paper-gtk-theme-git
### makepkg -fsri
### makepkg -si
### makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е 
### sudo mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
### makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
### rm -rf paper-gtk-theme-git
#rm -Rf paper-gtk-theme-git
####### gtk-update-icon-cache ##########
sudo pacman -S --noconfirm --needed gtk-update-icon-cache  # Обновление кэша иконок GTK ; https://www.gtk.org/ ; https://archlinux.org/packages/extra/x86_64/gtk-update-icon-cache/
############################
yay -S paper-icon-theme-git --noconfirm  # Paper — это тема иконок для рабочих столов на базе GTK, которая идеально подходит для paper-gtk-theme ; https://aur.archlinux.org/paper-icon-theme-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/snwh/paper-icon-theme ; https://aur.archlinux.org/packages/paper-icon-theme-git
#### paper-icon-theme-git #### 
#git clone https://aur.archlinux.org/paper-icon-theme-git.git   # (только для чтения, нажмите, чтобы скопировать)
#cd paper-icon-theme-git
### makepkg -fsri
### makepkg -si
### makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е 
### sudo mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
### makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
### rm -rf paper-icon-theme-git 
#rm -Rf paper-icon-theme-git
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Variety (для смены обоев)?" 
echo -e "${MAGENTA}:: ${BOLD}Variety (variety) - это это программа для смены обоев с открытым исходным кодом для Linux. (https://peterlevi.com/variety/). ${NC}"
echo -e "${YELLOW}==> Примечание: ${NC}Variety наполнен великолепными функциями, но при этом тонкий и простой в использовании. Он может использовать локальные изображения или автоматически загружать обои из Unsplash и других онлайн-источников, позволяет вам вращать их с регулярным интервалом и предоставляет простые способы отделить отличные изображения от мусора. Variety также может отображать мудрые и забавные цитаты или красивые цифровые часы на рабочем столе."
echo -e "${CYAN}=> Справка (пояснение): ${NC}Variety имеет опциональное приложение-компаньон для слайдшоу/скринсейвера Variety Slideshow. Его можно установить отдельно, но он прекрасно интегрируется с Variety. "
echo " Variety разработан Питером Леви, разработчиком программного обеспечения из Болгарии. Переводы предоставлены различными энтузиастами, вы можете присоединиться к этой работе здесь (https://translations.launchpad.net/variety). " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_variety  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_variety" =~ [^10] ]]
do
    :
done 
if [[ $i_variety == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_variety == 1 ]]; then
  echo ""  
  echo " Установка Variety (для смены обоев) "
sudo pacman -S --noconfirm --needed variety  # Меняет обои через равные промежутки времени, используя указанные пользователем или автоматически загруженные изображения ; https://peterlevi.com/variety/ ; https://archlinux.org/packages/extra/any/variety/
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

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
  echo " Установка Arc Firefox Theme (arc-firefox-theme) "
#### arc-firefox-theme ####
git clone https://github.com/horst3180/arc-firefox-theme.git  # Тема Arc Firefox
cd arc-firefox-theme
### makepkg -fsri
### makepkg -si
### makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е 
### sudo mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
### makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
### rm -rf arc-firefox-theme
rm -Rf arc-firefox-theme
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
#########################
# https://addons.mozilla.org/en-US/firefox/feedback/collection/11850356/a/
### Создайте файлы .xpi (перетащите их в окно Firefox)
# ./autogen.sh --prefix=/usr
# make mkxpi
# В качестве альтернативы тему можно установить глобально, без использования файлов .xpi.
# ./autogen.sh --prefix=/usr
# sudo make install
##########################

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
    1 - Установить (papirus-libreoffice-theme),       

    0 - НЕТ - Пропустить установку: " i_papirus_libre  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_papirus_libre" =~ [^10] ]]
do
    :
done 
if [[ $i_papirus_libre == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_papirus_libre == 1 ]]; then
  echo ""  
  echo " Установка Papirus theme for LibreOffice (papirus-libreoffice-theme) "
########### Тема Papirus для LibreOffice ###############
### * Установить тему: 
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-libreoffice-theme/master/install-papirus-root.sh | sh
### * Удалить тему:
### wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-libreoffice-theme/master/remove-papirus.sh | sh
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
###########################################

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Docklike Plugin для XFCE?"
echo -e "${MAGENTA}:: ${BOLD}Docklike Plugin - это современная минималистичная панель задач в стиле док-станции для Xfce. Используя его на рабочем столе Xfce, Вы получите "панель задач - только значки" с поддержкой прикрепления приложений и группировкой окон. ${NC}"
echo " Этот плагин панели Xfce является отличной альтернативой DockBarX, с меньшим количеством функций и настроек. "
echo -e "${YELLOW}==> Примечание! ${NC}Помимо того, что плагин позволяет запустить/закрыть окно приложения, минимизировать в один клик на панели, он также может управлять параметрами открытых окон из значка. Используйте Ctrl, чтобы изменить порядок приложений или получить доступ к панели настроек (щелкнув правой кнопкой мыши)."
echo " Как отмечалось в начале, плагин обладает небольшим количеством функций и настроек. "
echo -e "${CYAN}:: ${NC}Установка Docklike Plugin (xfce4-docklike-plugin-git) ; (xfce4-docklike-plugin) проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/xfce4-docklike-plugin-git/) ; (https://aur.archlinux.org/packages/xfce4-docklike-plugin/)- собирается и устанавливается. "
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In this option, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_docklike  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_docklike" =~ [^10] ]]
do
    :
done
if [[ $i_docklike == 0 ]]; then
echo ""
echo " Установка Docklike Plugin пропущена "
elif [[ $i_docklike == 1 ]]; then
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu
  echo ""
  echo " Установка Docklike Plugin (xfce4-docklike-plugin) "  
#### xfce4-docklike-plugin #######
#yay -S xfce4-docklike-plugin --noconfirm  # Современная минималистичная панель задач в стиле док-станции для XFCE
#yay -S xfce4-docklike-plugin-git --noconfirm  # Панель задач Docklike (Если установлен yay - эта команда)
git clone https://aur.archlinux.org/xfce4-docklike-plugin.git
# git clone https://aur.archlinux.org/xfce4-docklike-plugin-git.git
cd xfce4-docklike-plugin
# cd xfce4-docklike-plugin-git
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf xfce4-docklike-plugin
rm -Rf xfce4-docklike-plugin
# rm -Rf xfce4-docklike-plugin-git
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#-------------------------
# Важно!!!
# Нужно удерживать ctrl, чтобы изменить порядок закрепленных приложений.
# (Я подумал, что было бы неплохо упомянуть эту информацию. Я нашел это в проекте README как раз перед тем, как собирался открепить все и переставить их с нуля.)
# https://aur.archlinux.org/packages/xfce4-docklike-plugin-git/
# https://aur.archlinux.org/packages/xfce4-docklike-plugin/
# https://github.com/nsz32/docklike-plugin
# https://github.com/topics/xfce4-panel-plugin
# https://compizomania.blogspot.com/2020/12/docklike-plugin-xfce.html
#------------------------------

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Xfce4-Windowck-плагин для XFCE?"
echo -e "${MAGENTA}:: ${BOLD}Xfce4-Windowck-plugin - Плагин Windowsck - это набор из трех плагинов, позволяющий размещать на панели кнопки, заголовок и меню активных или развернутых окон. ${NC}"
echo " Плагин панели Xfce, позволяющий размещать кнопки, заголовок и меню активных или развернутых окон на панели. Этот код взят из Window Applets Андрея Бельцияна (http://gnome-look.org/content/show.php?content=103732). Домашняя страница: https://docs.xfce.org/panel-plugins/xfce4-windowck-plugin/start "
echo -e "${YELLOW}==> Примечание! ${NC}Добавьте на панель нужные плагины заголовков окон. Вы можете задать поведение и внешний вид в диалоговом окне свойств (управляемые окна, кнопки отображения/скрытия, тема, параметры форматирования заголовка…). "
echo " Функции: Отображать заголовок, кнопки и меню развернутых окон на панели. Разрешить действия с окнами при нажатии кнопок и заголовков (активировать, (раз)развернуть, закрыть). Разрешить меню действий окна при нажатии левой кнопки мыши. Параметры форматирования заголовка. Поддержка тем Xfwm4/Unity для кнопок. "
echo -e "${CYAN}:: ${NC}Установка Xfce4-Windowck-plugin (xfce4-windowck-plugin-git) проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/xfce4-windowck-plugin-git.git) ; (https://gitlab.xfce.org/panel-plugins/xfce4-windowck-plugin/)- собирается и устанавливается. "
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In this option, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_windowck  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_windowck" =~ [^10] ]]
do
    :
done
if [[ $i_windowck == 0 ]]; then
echo ""
echo " Установка Docklike Plugin пропущена "
elif [[ $i_windowck == 1 ]]; then
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu
  echo ""
  echo " Установка Xfce4-Windowck-plugin (xfce4-windowck-plugin-git) "  
#### xfce4-windowck-plugin-git #######
#yay -S xfce4-windowck-plugin-git --noconfirm  # Плагин панели Xfce для отображения заголовка окна и кнопок
# https://aur.archlinux.org/xfce4-windowck-plugin-git.git (только для чтения, нажмите, чтобы скопировать) ; 
# https://gitlab.xfce.org/panel-plugins/xfce4-windowck-plugin/ ; https://aur.archlinux.org/packages/xfce4-windowck-plugin-git ; https://docs.xfce.org/panel-plugins/xfce4-windowck-plugin/start
git clone https://aur.archlinux.org/xfce4-windowck-plugin-git.git
cd xfce4-windowck-plugin-git
# cd xfce4-windowck-plugin-git
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf xfce4-windowck-plugin-git
rm -Rf xfce4-windowck-plugin-git
# rm -Rf xxfce4-windowck-plugin-git
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить i3lock — блокировщик экрана (i3lock-color)?"
echo " Самый популярный в мире нестандартный экран блокировки компьютера. Современная версия i3lock с функцией цветного экрана и другими функциями. " 
echo -e "${MAGENTA}:: ${BOLD}i3lock — это простой блокировщик экрана, как slock. После запуска вы увидите белый экран (можно настроить цвет/изображение). Вернуться на экран можно, введя пароль (https://github.com/). ${NC}"
echo -e "${CYAN}=> Справка: ${NC}Со временем в i3lock было внесено множество небольших улучшений: i3lock разветвляется, поэтому вы можете объединить его с псевдонимом для перехода в режим ожидания с сохранением в ОЗУ (запустите «i3lock && echo mem > /sys/power/state», чтобы получить заблокированный экран после выхода компьютера из режима ожидания с сохранением в ОЗУ) (Смотреть справку). Вы можете указать либо цвет фона, либо изображение (JPG или PNG), которое будет отображаться, пока ваш экран заблокирован. Обратите внимание, что i3lock не является программой для обработки изображений. Если вам нужно изменить размер изображения, чтобы заполнить экран, вы можете использовать что-то вроде ImageMagick в сочетании с xdpyinfo. Вы также можете указать дополнительные параметры, как подробно описано на странице руководства. "
echo " Вы также можете использовать сценарии для установки последней версии прямо из этого репо (независимо от вашего дистрибутива), через GNU Wget (wget). Но в данный момент команда - Закомментирована (двойной ##), если Вам нужен именно этот способ сборки и установки, то раскомментируйте строки установки, а строки установки (пакетов) через Yay - закомментируйте. " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_i3lock  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_i3lock" =~ [^10] ]]
do
    :
done 
if [[ $i_i3lock == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_i3lock == 1 ]]; then
  echo ""  
  echo " Установка i3lock — блокировщик экрана (i3lock-color) "
yay -S i3lock-color --noconfirm  # Самый популярный в мире нестандартный экран блокировки компьютера.
### https://aur.archlinux.org/i3lock-color.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/Raymo111/i3lock-color ; https://aur.archlinux.org/packages/i3lock-color
#### i3lock-color #### 
#git clone https://aur.archlinux.org/i3lock-color.git  # Самый популярный в мире нестандартный экран блокировки компьютера.
#cd i3lock-color
### makepkg -fsri
### makepkg -si
### makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е 
### sudo mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
### makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
### rm -rf i3lock-color 
#rm -Rf i3lock-color
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
################## Справка ###################
# Со временем в i3lock было внесено множество небольших улучшений: i3lock разветвляется, поэтому вы можете объединить его с псевдонимом для перехода в режим ожидания с сохранением в ОЗУ (запустите «i3lock && echo mem > /sys/power/state», чтобы получить заблокированный экран после выхода компьютера из режима ожидания с сохранением в ОЗУ)
# Вы можете указать либо цвет фона, либо изображение (JPG или PNG), которое будет отображаться, пока ваш экран заблокирован. Обратите внимание, что i3lock не является программой для обработки изображений. Если вам нужно изменить размер изображения, чтобы заполнить экран, вы можете использовать что-то вроде ImageMagick в сочетании с xdpyinfo:
# convert image.jpg -resize $(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/') RGB:- | i3lock --raw $(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/'):rgb --image /dev/stdin
# Вы можете указать, должен ли i3lock подавать звуковой сигнал при вводе неверного пароля.
# i3lock использует PAM и поэтому совместим с LDAP и т. д. В OpenBSD i3lock использует фреймворк bsd_auth(3).
# Дополнительные функции в i3lock-color:
# Вы также можете указать дополнительные параметры, как подробно описано на странице руководства. Это включает в себя, но не ограничивается:
# Варианты цвета для:
# Кольцо проверки
# Цвет внутреннего кольца
# Цвет внутренней линии кольца
# Цвет подсветки клавиш
# Цвет выделения Backspace
# Цвета текста для большинства/всех строк
# Цвета контура
# Изменение всего вышеперечисленного в зависимости от статуса аутентификации PAM
# Размытие текущего экрана и использование его в качестве фона блокировки
# Отображение часов на индикаторе
# Обновление по таймеру, а не при каждом нажатии клавиши
# Размещение различных элементов пользовательского интерфейса
# Изменение радиуса и толщины кольца, а также размера текста
# Варианты для беспарольной аутентификации, удаление индикатора modkey
# Прохождение через медиа-ключи
# Новый барный индикатор, который заменяет кольцевой индикатор со своим собственным набором опций
# Экспериментальный поток для управления тиками перерисовки, чтобы такие вещи, как панель/часы, продолжали обновляться, когда PAM блокируется
# Любая другая функция, которую вы хотите (добавьте ее самостоятельно через PR или создайте запрос на функцию!)
######################################

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