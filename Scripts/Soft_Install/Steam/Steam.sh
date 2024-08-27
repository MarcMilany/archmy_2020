#!/bin/bash
# loadkeys ru
# setfont cyr-sun16
# clear
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v2.4 LegasyBIOS - Version: 2024.07.31.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

STEAM_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
  <<< Установка Steam — превосходная платформа для игроков и разработчиков в Archlinux >>> ${NC}"
echo ""
echo -e "${GREEN}==> ${NC}Установить Steam (steam) - Игровой клиент Steam для Linux?"
# Install Steam (steam) - Steam Game Client for Linux
echo -e "${MAGENTA}=> ${BOLD}Steam — это популярный онлайн-сервис от компании Valve, который позволяет загружать, устанавливать и покупать игры. Он содержит тысячи различных игр. Большинство игр, распространяемых через Steam, платные. Но есть и очень хорошие бесплатные игры. Установка и запуск игр происходит прямо из программы. Помимо этого Steam имеет социальную составляющую, позволяя общаться и «дружить» с другими пользователями. Клиент Steam является кроссплатформенным приложением и доступен для Windows, MacOS и Linux. За последний год произошел целый прорыв в плане поддержки операционной системы Linux. Уже сейчас доступно огромное количество игр, которые работают под Linux через Steam. Если вы покупаете в Steam игру, которая может работать в разных операционных системах, то после покупки вы можете использовать ее в любой системе. Не нужно покупать игры для каждой системы отдельно. ${NC}"
echo -e "${CYAN}:: ${NC}Описание: Мгновенный доступ к играм - Steam предлагает около 30 000 игр на любой вкус, а также эксклюзивные предложения, автоматическое обновление игр и другие замечательные возможности. Заводите знакомства, вступайте в группы, общайтесь и не только! Более 100 миллионов возможных друзей (или врагов) не дадут вам соскучиться. При первом запуске программы необходимо создать учетную запись Steam или использовать существующие данные для входа. Игры, которые покупает пользователь, сохраняются в рамках учетной записи. Количество игр, работающих в Linux, постоянно увеличивается! Приложение переведено на русский язык. "
echo -e "${MAGENTA}==> ${BOLD}Чтобы установились дополнительные библиотеки для Steam Необходимо раскомментировать репозиторий multilib в /etc/pacman.conf . ${NC}"
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (steam)(steam-native-runtime) + (lutris)"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_steam # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_steam" =~ [^10] ]]
do
    :
done
if [[ $i_steam == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_steam == 1 ]]; then
  echo ""
  echo " Установка клиента Steam для Linux "
### sudo pacman -S --noconfirm --needed steam steam-native-runtime lutris lib32-dbus-glib lib32-openal lib32-nss lib32-gtk2 lib32-sdl2 lib32-sdl2_image lib32-libcanberra   
##### Дополнительные пакеты для игр ####
sudo pacman -S --noconfirm --needed lib32-alsa-plugins  # Дополнительные плагины ALSA (32-бит) ; https://www.alsa-project.org/ ; https://archlinux.org/packages/multilib/x86_64/lib32-alsa-plugins/
sudo pacman -S --noconfirm --needed lib32-curl  # Инструмент командной строки и библиотека для передачи данных с помощью URL-адресов (32-бит) ; https://curl.se/ ; https://archlinux.org/packages/multilib/x86_64/lib32-curl/
##### Steam ###
sudo pacman -S --noconfirm --needed steam  # Цифровая система доставки программного обеспечения Valve ; https://steampowered.com/ ; https://archlinux.org/packages/multilib/x86_64/steam/
sudo pacman -S --noconfirm --needed steam-native-runtime  # Нативная замена для среды выполнения Steam с использованием системных библиотек ; https://wiki.archlinux.org/index.php/Steam/Troubleshooting#Native_runtime ; https://archlinux.org/packages/multilib/x86_64/steam-native-runtime/
########### Lutris ###############
sudo pacman -S --noconfirm --needed lutris  # Открытая игровая платформа ; https://lutris.net/ ; https://archlinux.org/packages/extra/any/lutris/ ; Lutris — это платформа для сохранения видеоигр, которая стремится сохранить вашу коллекцию видеоигр в рабочем состоянии на долгие годы. За эти годы видеоигры прошли через множество различных аппаратных и программных платформ. Предлагая лучшее программное обеспечение для запуска ваших игр, Lutris упрощает запуск всех ваших игр, старых и новых.
##### Дополнительные библиотеки для Steam ####
sudo pacman -S --noconfirm --needed lib32-dbus-glib  # Привязки GLib для DBUS ; https://www.freedesktop.org/wiki/Software/DBusBindings ; https://archlinux.org/packages/multilib/x86_64/lib32-dbus-glib/
sudo pacman -S --noconfirm --needed lib32-openal  # Кроссплатформенная 3D аудио библиотека, программная реализация (32-бит) ; https://github.com/kcat/openal-soft ; https://archlinux.org/packages/multilib/x86_64/lib32-openal/
sudo pacman -S --noconfirm --needed lib32-nss  # Службы сетевой безопасности (32-бит) ; https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS ; https://archlinux.org/packages/multilib/x86_64/lib32-nss/
sudo pacman -S --noconfirm --needed lib32-gtk2  # Мультиплатформенный набор инструментов GUI на основе GObject (устаревший) (32-бит) ; https://www.gtk.org/ ; https://archlinux.org/packages/multilib/x86_64/lib32-gtk2/ 
sudo pacman -S --noconfirm --needed lib32-sdl2  # Библиотека для портативного низкоуровневого доступа к видеобуферу кадров, аудиовыходу, мыши и клавиатуре ; https://www.libsdl.org/ ; https://archlinux.org/packages/multilib/x86_64/lib32-sdl2/
sudo pacman -S --noconfirm --needed lib32-sdl2_image  # Простая библиотека для загрузки изображений различных форматов в виде поверхностей SDL ; https://www.libsdl.org/projects/SDL_image/ ; https://archlinux.org/packages/multilib/x86_64/lib32-sdl2_image/
sudo pacman -S --noconfirm --needed lib32-libcanberra  # Небольшая и легкая реализация спецификации звуковых тем XDG (32-бит) ; https://0pointer.net/lennart/projects/libcanberra/ ; https://archlinux.org/packages/multilib/x86_64/lib32-libcanberra/
############ Библиотека совместимости libudev.so.0 #############
sudo pacman -S --noconfirm --needed lib32-libudev0-shim  # Библиотека совместимости libudev.so.0 для систем с более новыми версиями udev (32 бит) ; https://github.com/archlinux/libudev0-shim
########### Шахматы дополнение #############
sudo pacman -S --noconfirm --needed gnome-chess  # Сыграйте в классическую настольную игру в шахматы для двух игроков
# sudo pacman -S --noconfirm --needed 
echo ""
echo " Установка Игровой клиент Steam для Linux выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Portproton — WINE от Valve (Proton) для Linux?"
# Should I install Portproton — WINE from Valve (Proton) for Linux?
echo -e "${MAGENTA}=> ${BOLD}Portproton — WINE от Valve (Proton) — это Проект, который призван упростить запуск Windows-игр в Linux, как для начинающих пользователей, так и для опытных. Проект стремится сделать процесс запуска игр (и другого программного обеспечения) максимально простым, но в то же время предоставляет гибкие настройки для опытных пользователей. ${NC}"
echo -e "${CYAN}:: ${NC}Важно!!! Официальный сайт проекта с сентября 2022 года: https://linux-gaming.ru 5,4 тыс.. Любой другой сайт - фальшивка! Внимание: Перед попыткой установки PortProton проверьте включен ли multilib репозиторий ."
echo -e "${MAGENTA}==> ${BOLD}Proton – слой совместимости на основе Wine, разработка принадлежит Valve и предназначена клиентам Steam. Он позволяет запускать больше половины игр, написанных для Windows. Ознакомиться со списком игр и отзывами игроков можете на сайте ProtonDB. PortProton это отвязанный от Steam слой совместимости Proton с небольшой утилитой для его настройки. Или другими словами proton без steam linux. Помимо оригинального Proton, на выбор имеется модифицированная версия, Proton GE. Она включает десятки патчей, а также дополнительные функции, вроде повышения резкости при низком разрешении (FSR). При желании вы можете добавить Proton GE в нативный клиент Steam. ${NC}"
echo -e "${MAGENTA}=> ${NC}Еще не так давно сложно было поверить, что Linux будет в какой то мере еще и игровой платформой. Нативных игр по-прежнему мало, но с появлением API Vulkan ускорилось развитие слоя совместимости Wine для запуска приложений Windows. Клиент Steam тому яркое доказательство, Proton позволяет запускать более 70% всей библиотеки Steam. Вне Steam также можно встретить большое количество хороших игр. Для их запуска подходят Lutris, CrossOver, но есть третий вариант – PortProton. Он позволяет запускать сторонние игры с использованием Proton. Дальше мы рассмотрим, как установить Proton Linux."
echo -e "${YELLOW}==> Внимание! ${NC}Установка (пакетов) будет проходить через - Yay (Yaourt, помощник AUR), если таковой был вами установлен. Также установка (пакетов) в скрипте будет прописана через сборку из исходников, но в данный момент - Закомментирована (одинарной #), если Вам нужен именно этот способ сборки и установки, то раскомментируйте строки их установки, а строки установки (пакетов) через Yay - закомментируйте." 
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_proton # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_proton" =~ [^10] ]]
do
    :
done
if [[ $i_proton == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_proton == 1 ]]; then
  echo ""
  echo " Установка Portproton — WINE от Valve (Proton) для Linux "
yay -S portproton --noconfirm  # Программное обеспечение для запуска игр и лаунчеров Microsoft Windows ; https://aur.archlinux.org/portproton.git (только для чтения, нажмите, чтобы скопировать) ; https://linux-gaming.ru/ ; https://aur.archlinux.org/packages/portproton ; https://github.com/Castro-Fidel/PortWINE
######### portproton ############
#git clone https://aur.archlinux.org/portproton.git   # (только для чтения, нажмите, чтобы скопировать
#cd portproton
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf portproton
#rm -Rf portproton   # удаляем директорию сборки
echo ""
echo " Установка Portproton — WINE от Valve (Proton) для Linux выполнена "
fi
######################
# echo 'Дополнительные пакеты для игр AUR'
# Additional packages for games AUR
# yay -S lib32-gconf --noconfirm  # Устаревшая система базы данных конфигурации ; https://aur.archlinux.org/lib32-gconf.git (только для чтения, нажмите, чтобы скопировать) ; https://projects-old.gnome.org/gconf/ ; https://aur.archlinux.org/packages/lib32-gconf
# yay -S davfs2 --noconfirm  # Драйвер файловой системы, позволяющий монтировать папку WebDAV ; Раньше присутствовал в community ...; https://aur.archlinux.org/davfs2.git (только для чтения, нажмите, чтобы скопировать) ; https://savannah.nongnu.org/projects/davfs2 ; https://aur.archlinux.org/packages/davfs2
# Manjaro - перенос папки steam на другой диск
# https://www.youtube.com/watch?v=1EsslxVO2hs
########################

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
echo -e "${YELLOW}==> ${CYAN}git clone https://github.com/MarcMilany/archmy_2020.git ${NC}"
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