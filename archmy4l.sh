#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

ARCHMY4_LANG="russian"  # Installer default language (Язык установки по умолчанию)

script_path=$(readlink -f ${0%/*})

umask 0022 # Определение окончательных прав доступа
# Для суперпользователя (root) umask по умолчанию равна 0022

##################################################################
##### <<<Arch Linux Fast Install LegasyBIOS (arch2020)>>>    #####
##### Скрипты 'arch_2020' созданы на основе 2-х (скриптов):  #####
#####   'ordanax/arch2018', и 'archlinux-script-install' -   #####
##### (Poruncov,Grub-Legacy - 2020).                         #####
##### Скрипт (сценарий) archmy3 является продолжением первой #####
#### части скриптов (archmy1 и archmy2) из серии 'arch_2020'. ####  
##### Этот скрипт находится в процессе 'Внесение поправок в  #####
##### наводку орудий по результатам наблюдений с наблюдате-  #####
##### льных пунктов'.                                        #####
##### Автор не несёт ответственности за любое нанесение вреда ####
##### при использовании скрипта.                             #####
##### Installation guide - Arch Wiki  (referance):           #####
##### https://wiki.archlinux.org/index.php/Installation_guide ####
##### Проект (project): https://github.com/ordanax/arch2018  #####
##### Лицензия (license): LGPL-3.0                           ##### 
##### (http://opensource.org/licenses/lgpl-3.0.html          #####
##### В разработке принимали участие (author) :              #####
##### Алексей Бойко https://vk.com/ordanax                   #####
##### Степан Скрябин https://vk.com/zurg3                    #####
##### Михаил Сарвилин https://vk.com/michael170707           #####
##### Данил Антошкин https://vk.com/danil.antoshkin          #####
##### Юрий Порунцов https://vk.com/poruncov                  #####
##### Jeremy Pardo (grm34) https://www.archboot.org/         #####
##### Marc Milany - 'Не ищи меня 'Вконтакте',                #####
#####                в 'Одноклассниках'' нас нету, ...       #####
##### Releases ArchLinux:                                    #####
#####    https://www.archlinux.org/releng/releases/          #####
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

### Execute action in chrooted environment (Выполнение действия в хромированной среде)
_chroot() {
    arch-chroot /mnt <<EOF "${1}"
EOF
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

echo -e "${GREEN}
  <<< Начинается установка первоначально необходимого софта (пакетов) и запуск необходимых служб для системы Arch Linux >>>
${NC}"
# Installation of utilities (packages) for the Arch Linux system begins

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

echo ""
echo -e "${MAGENTA}==> ${NC}Давайте проверим наш часовой пояс ... :)"
#echo 'Давайте проверим наш часовой пояс ... :)'
# Let's check our time zone ... :)
timedatectl | grep "Time zone"

echo ""
echo -e "${BLUE}:: ${NC}Если NetworkManager запущен смотрим состояние интерфейсов" 
#echo "Если NetworkManager запущен смотрим состояние интерфейсов"
# If NetworkManager is running look at the state of the interfaces
# Первым делом нужно запустить NetworkManager:
# sudo systemctl start NetworkManager
# Если NetworkManager запущен смотрим состояние интерфейсов (с помощью - nmcli):  
nmcli general status

echo ""
echo -e "${BLUE}:: ${NC}Посмотреть имя хоста"
# View host name
nmcli general hostname 

echo ""
echo -e "${BLUE}:: ${NC}Получаем состояние интерфейсов"
# Getting the state of interfaces
nmcli device status

echo ""
echo -e "${BLUE}:: ${NC}Смотрим список доступных подключений"
# See the list of available connections
nmcli connection show

echo ""
echo -e "${BLUE}:: ${NC}Смотрим состояние wifi подключения"
# Looking at the status of the wifi connection
nmcli radio wifi
# -------------------------------------------
# Посмотреть список доступных сетей wifi:
# nmcli device wifi list
# Теперь включаем:
# nmcli radio wifi on
# Или отключаем:
# nmcli radio wifi off
# Команда для подключения к новой сети wifi выглядит не намного сложнее. Например, давайте подключимся к сети TP-Link с паролем 12345678:
# nmcli device wifi connect "TP-Link" password 12345678 name "TP-Link Wifi"
# Если всё прошло хорошо, то вы получите уже привычное сообщение про создание подключения с именем TP-Link Wifi и это имя в дальнейшем можно использовать для редактирования этого подключения и управления им, как описано выше.
# ------------------------------------------------

echo ""
echo -e "${BLUE}:: ${NC}Посмотрим данные о нашем соединение с помощью IPinfo..." 
#echo " Посмотрим данные о нашем соединение с помощью IPinfo..."
# Let's look at the data about our connection using IP info...
echo -e "${CYAN}=> ${NC}С помощью IPinfo вы можете точно определять местонахождение ваших пользователей, настраивать их взаимодействие, предотвращать мошенничество, обеспечивать соответствие и многое другое."
echo " Надежный источник данных IP-адресов (https://ipinfo.io/) "
wget http://ipinfo.io/ip -qO -
sleep 03

echo ""
echo -e "${BLUE}:: ${NC}Узнаем версию и данные о релизе Arch'a ... :) " 
#echo "Узнаем версию и данные о релизе Arch'a ... :)"
# Find out the version and release data for Arch ... :)
cat /proc/version
cat /etc/lsb-release
sleep 02

echo ""
echo -e "${BLUE}:: ${NC}Проверим корректность загрузки установленных микрокодов " 
#echo " Давайте проверим, правильно ли загружен установленный микрокод "
# Let's check whether the installed microcode is loaded correctly
echo -e "${MAGENTA}=> ${NC}Если таковые (микрокод-ы: amd-ucode; intel-ucode) были установлены!"
echo " Если микрокод был успешно загружен, Вы увидите несколько сообщений об этом "
echo " Будьте внимательны! Вы можете пропустить это действие. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да проверим корректность загрузки,    0 - Нет пропустить: " x_ucode  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_ucode" =~ [^10] ]]
do
    :
done
 if [[ $x_ucode == 0 ]]; then
echo ""
echo " Проверка пропущена " 
elif [[ $x_ucode == 1 ]]; then
echo ""
echo " Выполним проверку корректности загрузки установленных микрокодов "
dmesg | grep microcode
fi
sleep 02

echo ""
echo -e "${BLUE}:: ${NC}Обновим вашу систему (базу данных пакетов)"
#echo "Обновим вашу систему (базу данных пакетов)"
# Update your system (package database)
echo -e "${YELLOW}:: ${NC}Загружаем базу данных пакетов независимо от того, есть ли какие-либо изменения в версиях или нет."
#echo 'Загружаем базу данных пакетов независимо от того, есть ли какие-либо изменения в версиях или нет.'
# Loading the package database regardless of whether there are any changes in the versions or not.
echo ""
sudo pacman -Syyu  --noconfirm  
sleep 01

clear
echo -e "${MAGENTA}
  <<< Установить дополнительных утилит для Синхронизации времени (Если Вы обнаружите, что время сбиваться по различным причинам). >>> ${NC}"

echo ""
echo -e "${GREEN}==> ${NC}Установить TimeSet (bash скрипт - timeset) и GUI интерфейс для управления системной датой и временем (timeset-gui) из AUR"
#echo 'Установить TimeSet (bash скрипт - timeset) и GUI интерфейс для управления системной датой и временем (timeset-gui)
# Install TimeSet and GUI...
echo -e "${BLUE}:: ${BOLD}Посмотрим дату, время, и часовой пояс ... ${NC}"
timedatectl | grep "Time zone"
date
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'     # одновременно отображает дату и часовой пояс
echo ""
echo -e "${YELLOW}=> ${NC}Если при двойной загрузке с Windows или любой другой ОС Вы обнаружите, что время сбиваться, это может быть связано с тем, что они используют разные значения времени для аппаратных часов. Arch (& Manjaro) считает, что аппаратные часы находятся в формате UTC, в то время как Windows и некоторые другие дистрибутивы Linux предполагают, что аппаратные часы находятся в местном времени. Чтобы исправить это, можно настроить Windows на использование аппаратного времени в формате UTC."
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo " 1 - TimeSet (bash скрипт - timeset) - пакет (timeset - Скрипт для управления системной датой и временем) "
echo -e "${CYAN}:: ${NC}Установка TimeSet (timeset) проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/timeset.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux - AUR' (https://aur.archlinux.org/packages/timeset/) - собирается и устанавливается. "
echo " 2 - TimeSet-GUI (python скрипт - timeset-gui) - пакет (timeset-gui - Графический интерфейс для управления системной датой и временем) "
echo -e "${CYAN}:: ${NC}Установка TimeSet-GUI (timeset-gui) проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/timeset-gui.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux - AUR' (https://aur.archlinux.org/packages/timeset-gui/) - собирается и устанавливается. "
echo -e "${YELLOW}==> Внимание! ${NC}Для полноценной установки у Вас должен быть установлен NTP (Network Time Protocol) - (пакет ntp), и Gksu (Графический интерфейс для su) - (пакет gksu), которые являются зависимостями для установки." 
echo -e "${CYAN}:: ${NC}Возможно эти зависимости были установлены вами ранее!"  # NTP Servers (серверы точного времени) - https://www.ntp-servers.net/; Introduction - https://www.ntppool.org/ru/ 
echo " Будьте внимательны! В данной опции выбор всегда остаётся за вами. "
echo -e "${CYAN}==> ${NC}Рекомендую выбрать вариант "1" (Установим СРАЗУ timeset и timeset-gui)" 
echo "" 
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Установить TimeSet и TimeSet-GUI (timeset; timeset-gui),     2 - Установить TimeSet (bash скрипт - timeset) 

    0 - НЕТ - Пропустить установку: " i_timeset  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_timeset" =~ [^120] ]]
do
    :
done
if [[ $i_timeset == 0 ]]; then
echo ""  
echo " Установка пропущена "
elif [[ $i_timeset == 1 ]]; then
  echo ""
  echo " Установка TimeSet и TimeSet-GUI (графический интерфейс для управления системной датой) "
# yay -S timeset --noconfirm  # Скрипт для управления системной датой и временем
# yay -S timeset-gui --noconfirm  # Графический интерфейс для управления системной датой
echo " Установка TimeSet (пакета - timeset) "
##### timeset ######  
git clone https://aur.archlinux.org/timeset.git
cd timeset
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf timeset
rm -Rf timeset   # удаляем директорию сборки
echo " Установка TimeSet-GUI (пакета - timeset-gui) "
##### timeset-gui ######  
git clone https://aur.archlinux.org/timeset-gui.git 
cd timeset-gui
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf timeset-gui
rm -Rf timeset-gui   # удаляем директорию сборки
echo ""
echo " Установка TimeSet и TimeSet-GUI (timeset; timeset-gui) выполнена "
echo " Время точное как на Спасской башне Московского Кремля! "
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'   # одновременно отображает дату и часовой пояс
elif [[ $i_timeset == 2 ]]; then
  echo ""
  echo " Установка TimeSet (скрипт для управления системной датой и временем) "
# yay -S timeset --noconfirm  # Скрипт для управления системной датой и временем
##### timeset ######  
git clone https://aur.archlinux.org/timeset.git
cd timeset
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf timeset
rm -Rf timeset   # удаляем директорию сборки
echo ""
echo " Установка TimeSet (timeset) выполнена "
echo " Время точное как на Спасской башне Московского Кремля! "
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'   # одновременно отображает дату и часовой пояс
fi

clear
echo -e "${MAGENTA}
  <<< Установка Редактора шрифтов и дополнительных шрифтов - по вашему выбору и желанию >>> ${NC}"
# Install font Editor and additional fonts-according to your choice and desire 
echo ""
echo -e "${GREEN}==> ${NC}Установить редактор шрифтов и дополнительные шрифты?"
#echo -e "${BLUE}:: ${NC}Установить редактор шрифтов и дополнительные шрифты?"
#echo 'Установка дополнительных шрифтов'
# Install the font editor and additional fonts?
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (fontforge, gsfonts, ttf-croscore, ttf-ubuntu-font-family, ttf-font-awesome, ttf-hack, ttf-carlito, ttf-caladea, ttf-bitstream-vera, ttf-droid, ttf-linux-libertine, gnu-free-fonts, powerline-fonts, ttf-roboto-mono, ttf-nerd-fonts-symbols, ttf-ionicons, ttf-arphic-ukai, ttf-arphic-uming, ttf-inconsolata, sdl_ttf, ttf-bitstream-vera, font-bh-ttf, xorg-fonts-type1, opendesktop-fonts, ttf-fireflysung, ttf-sazanami, ttf-hanazono, ttf-indic-otf, cantarell-fonts, adobe-source-code-pro-fonts, adobe-source-han-sans-cn-fonts, adobe-source-han-sans-jp-fonts, adobe-source-han-sans-kr-fonts, adobe-source-sans-pro-fonts)." 
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты шрифтов!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_font  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_font" =~ [^10] ]]
do
    :
done
if [[ $i_font == 0 ]]; then
echo ""  
echo " Установка дополнительных шрифтов пропущена "
elif [[ $i_font == 1 ]]; then
echo ""
echo " Установка дополнительных шрифтов "
# sudo pacman -S fontforge gsfonts ttf-croscore ttf-ubuntu-font-family ttf-font-awesome ttf-hack ttf-carlito ttf-caladea ttf-bitstream-vera ttf-droid ttf-linux-libertine gnu-free-fonts powerline-fonts ttf-roboto-mono ttf-nerd-fonts-symbols ttf-ionicons ttf-arphic-ukai ttf-arphic-uming ttf-inconsolata sdl_ttf ttf-bitstream-vera font-bh-ttf xorg-fonts-type1 opendesktop-fonts ttf-fireflysung ttf-sazanami ttf-hanazono ttf-indic-otf cantarell-fonts --noconfirm  # Ставим шрифты:  https://www.archlinux.org/packages/                                                   
#sudo pacman -S adobe-source-code-pro-fonts adobe-source-han-sans-cn-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts adobe-source-sans-pro-fonts --noconfirm  # Ставим шрифты:  https://www.archlinux.org/packages/
# Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты шрифтов!
sudo pacman -S fontforge --noconfirm  # Редактор контурных и растровых шрифтов 
sudo pacman -S gsfonts --noconfirm  # (URW) ++ Базовый набор шрифтов [Уровень 2] (возможно уже установлен)
sudo pacman -S ttf-croscore --noconfirm  # Основные шрифты Chrome OS, они метрически совместимы с MS, и хорошо смотрятся, содержат Arimo, Tinos, Cousine и тп.
sudo pacman -S ttf-ubuntu-font-family --noconfirm  # Семейство шрифтов Ubuntu - красивые, не вырвиглазные шрифты без засечек, использую в DE и текстовых документах.
sudo pacman -S ttf-font-awesome --noconfirm  # Культовый шрифт, разработанный для Bootstrap
sudo pacman -S ttf-hack --noconfirm  # Ухоженный и оптически сбалансированный шрифт на основе Bitstream Vera Mono
sudo pacman -S ttf-carlito --noconfirm  # Шрифт Google Carlito - метрически совместим с MS Calibri
sudo pacman -S ttf-caladea --noconfirm  # Семейство шрифтов с засечками по метрике, совместимое с семейством шрифтов MS Cambria 
sudo pacman -S ttf-bitstream-vera --noconfirm  # Шрифты Bitstream Vera
sudo pacman -S ttf-droid --noconfirm  # Шрифты общего назначения, выпущенные Google как часть Android
sudo pacman -S ttf-linux-libertine --noconfirm  # Шрифты OpenType с засечками (Libertine) и Sans Serif (Biolinum) с большим охватом Unicode
sudo pacman -S gnu-free-fonts --noconfirm  # Бесплатное семейство масштабируемых контурных шрифтов
sudo pacman -S powerline-fonts --noconfirm  # Исправленные шрифты для powerline
sudo pacman -S ttf-roboto-mono --noconfirm  # Моноширинное дополнение к семейству роботов Roboto (возможно уже установлен)
sudo pacman -S ttf-nerd-fonts-symbols --noconfirm  # Большое количество дополнительных глифов из популярных `` культовых шрифтов '' (2048-em)
sudo pacman -S ttf-ionicons --noconfirm  # Шрифт из мобильного фреймворка Ionic
sudo pacman -S ttf-arphic-ukai --noconfirm  # Шрифт CJK Unicode в стиле Kaiti
sudo pacman -S ttf-arphic-uming --noconfirm  # CJK Unicode шрифт в стиле Ming
sudo pacman -S ttf-inconsolata --noconfirm  # Моноширинный шрифт для красивых списков кода и для терминала - шрифт для "коддинга", - Можно не ставить.
sudo pacman -S cantarell-fonts --noconfirm  # Шрифт Humanist sans serif (возможно уже установлен)
sudo pacman -S sdl_ttf --noconfirm  # Библиотека, позволяющая использовать шрифты TrueType в ваших приложениях SDL
sudo pacman -S ttf-bitstream-vera --noconfirm  # Шрифты Bitstream Vera.
sudo pacman -S font-bh-ttf --noconfirm  # Шрифты X.org Luxi Truetype 
sudo pacman -S xorg-fonts-type1 --noconfirm  # Шрифты X.org Type1
# Китайские, Японские, Индийские шрифт
sudo pacman -S opendesktop-fonts --noconfirm  # Китайские шрифты TrueType 
sudo pacman -S ttf-fireflysung --noconfirm  # Китайские иероглифы: - ;
sudo pacman -S ttf-sazanami --noconfirm  # Японские шрифты
sudo pacman -S ttf-hanazono --noconfirm  # Бесплатный японский шрифт кандзи, который содержит около 78 685 символов (и 2 пробела), определенный в стандарте ISO / IEC 10646 / стандарте Unicode.
sudo pacman -S ttf-indic-otf --noconfirm  # Коллекция индийских шрифтов Opentype
sudo pacman -S adobe-source-code-pro-fonts --noconfirm  # Семейство моноширинных шрифтов для пользовательского интерфейса и среды программирования sudo pacman -S cantarell-fonts --noconfirm  # Шрифт Humanist sans serif (возможно уже установлен)
sudo pacman -S adobe-source-han-sans-cn-fonts --noconfirm  # Adobe Source Han Sans Subset OTF - упрощенные китайские шрифты OpenType / CFF
sudo pacman -S adobe-source-han-sans-jp-fonts --noconfirm  # Adobe Source Han Sans Subset OTF - японские шрифты OpenType / CFF
sudo pacman -S adobe-source-han-sans-kr-fonts --noconfirm  # Adobe Source Han Sans Subset OTF - корейские шрифты OpenType / CFF
sudo pacman -S adobe-source-sans-pro-fonts --noconfirm  # Семейство шрифтов без засечек для сред пользовательского интерфейса
# sudo pacman -S  --noconfirm  # 
# sudo pacman -S  --noconfirm  # 
# sudo pacman -S  --noconfirm  # 
echo ""
echo " Обновим информацию о шрифтах "  # Update information about fonts
sudo fc-cache -f -v
echo ""
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установка редактора шрифтов и дополнительных шрифтов из AUR (через - yay)"
#echo -e "${BLUE}:: ${NC}Установка редактора шрифтов и дополнительных шрифтов из AUR (через - yay)"
#echo 'Установка дополнительных шрифтов из AUR'
# The installation of additional fonts from the AUR (through - yay)
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (font-manager, ttf-ms-fonts, ttf-clear-sans, ttf-monaco, montserrat-font-ttf, ttf-paratype, ttf-comfortaa, ttf-cheapskate, ttf-symbola, ttf-nerd-fonts-hack-complete-git, ttf-font-logos, ttf-font-icons)." 
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты шрифтов!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " t_font  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_font" =~ [^10] ]]
do
    :
done
if [[ $t_font == 0 ]]; then
echo ""  
echo " Установка дополнительных шрифтов из AUR пропущена "
elif [[ $t_font == 1 ]]; then
echo ""
echo " Установка дополнительных шрифтов из AUR (через - yay) "
# yay -S font-manager ttf-ms-fonts ttf-clear-sans ttf-monaco montserrat-font-ttf ttf-paratype ttf-comfortaa ttf-cheapskate ttf-symbola ttf-nerd-fonts-hack-complete-git ttf-font-logos ttf-font-icons --noconfirm 
# Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты шрифтов!
yay -S font-manager --noconfirm  # Простое приложение для управления шрифтами для GTK + Desktop Environments   
yay -S ttf-ms-fonts --noconfirm  # Основные шрифты TTF от Microsoft
# yay -S ttf-ms-win8 --noconfirm  # По желанию: (содержит в себе ttf-ms-fonts, ttf-vista-fonts и ttf-win7-fonts, т.е. всё что надо включая Calibri и .т.п.)
yay -S ttf-clear-sans --noconfirm  # Универсальный шрифт OpenType для экрана, печати и Интернета (возможно уже установлен)
yay -S ttf-monaco --noconfirm  # Моноширинный шрифт без засечек Monaco со специальными символами
yay -S montserrat-font-ttf --noconfirm  # Геометрический шрифт с кириллицей и расширенной латиницей от Джульетты Улановской
yay -S ttf-paratype --noconfirm  # Семейство шрифтов ParaType с расширенными наборами символов кириллицы и латиницы
yay -S ttf-comfortaa --noconfirm  # Закругленный геометрический шрифт без засечек от Google, автор - Йохан Аакерлунд
yay -S ttf-cheapskate --noconfirm  # Шрифты TTF от Дастина Норландера
yay -S ttf-symbola --noconfirm  # Шрифт для символьных блоков стандарта Unicode (TTF)
yay -S ttf-nerd-fonts-hack-complete-git --noconfirm  # Шрифт, разработанный для исходного кода. Исправлены иконки Nerd Fonts
yay -S ttf-font-logos --noconfirm  # Значок шрифта с логотипами популярных дистрибутивов Linux
yay -S ttf-font-icons --noconfirm  # Неперекрывающееся сочетание иконических шрифтов Ionicons и Awesome 
# yay -S ttf-wps-fonts --noconfirm  # Если установлен WPS - Символьные шрифты требуются wps-office
# yay -S  --noconfirm  #
# yay -S  --noconfirm  #
# yay -S  --noconfirm  #
pwd  # покажет в какой директории мы находимся
echo ""
echo " Обновим информацию о шрифтах "  # Update information about fonts
sudo fc-cache -f -v
echo ""
fi

clear
echo -e "${MAGENTA}
  <<< Установка дополнительного программного обеспечения (пакетов) для редактирования и разработки в Archlinux >>> ${NC}"
# Installing additional software (packages) for editing and development in Archlinux

echo ""
echo -e "${GREEN}==> ${NC}Установка текстового редактора Vim или gVim (графическая оболочка для редактора Vim)"
#echo -e "${BLUE}:: ${NC}Установка текстового редактора Vim или gVim (графическая оболочка для редактора Vim)" 
#echo 'Установка текстового редактора Vim или gVim'
# Installing the Vim or gVim text editor
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo -e "${MAGENTA}=> ${BOLD}Vim - это свободный текстовый редактор, созданный на основе более старого vi. Ныне это мощный текстовый редактор с полной свободой настройки и автоматизации, возможными благодаря расширениям и надстройкам. Пользовательский интерфейс Vim’а может работать в чистом текстовом режиме. Для поклонников vi - практически стопроцентная совместимость с vi. ${NC}"
echo -e "${CYAN}:: ${NC}Функционал утилиты Vim как при работе с текстовыми файлами, так и цикл разработки (редактирование; компиляция; исправление программ; и т.д.) очень обширен. (https://www.vim.org/)"
echo -e "${CYAN}:: ${NC}Существует и модификация для использования в графическом оконном интерфейсе - GVim."
echo -e "${MAGENTA}=> ${BOLD}gVim - представляет собой версию Vim, скомпилированную с поддержкой графического интерфейса. Обычно редактор Vim используют, запуская его в консоли или эмуляторе терминала. ${NC}"
echo -e "${CYAN}:: ${NC}Однако если вы активно используете GUI, вам может быть полезен gVim. (https://www.vim.org/)"
echo -e "${YELLOW}==> Примечание: ${BOLD}При установке приложение gVim пакета (gvim), само приложение Vim пакет (vim) будет удален (просто заменён на gvim). ${NC}"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Установить редактор Vim,     2 - Установить приложение gVim (GUI),     

    0 - НЕТ - Пропустить установку: " i_gvim  # sends right after the keypress; # отправляет сразу после нажатия клавиши    
    echo ''
    [[ "$i_gvim" =~ [^10] ]]
do
    :
done 
if [[ $i_gvim == 0 ]]; then 
echo ""   
echo " Установка пропущена "
elif [[ $i_gvim == 1 ]]; then
  echo ""    
  echo " Установка редактора Vim "
sudo pacman -S vim --noconfirm  # Vi Improved, улучшенная версия текстового редактора vi с широкими возможностями настройки
echo ""
echo " Установка редактора Vim выполнена "
elif [[ $i_gvim == 2 ]]; then
  echo ""    
  echo " Установка приложение gVim графической оболочки для редактора Vim "
# sudo pacman -Rsn vim  # Удалить пакет с зависимостями (не используемыми другими пакетами) и его конфигурационные файлы
# sudo pacman -Rs vim  # Удалить пакет с зависимостями (не используемыми другими пакетами)
#sudo pacman -R vim  # Удалить пакет vim
sudo pacman -S gvim --noconfirm  # Vi Improved, улучшенная версия текстового редактора vi с широкими возможностями настройки (с расширенными функциями, такими как графический интерфейс)
echo ""
echo " Установка gVim графической оболочки для редактора Vim выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установка дополнительных пакетов для расширения возможностей редактора Vim или gVim"
#echo -e "${BLUE}:: ${NC}Установка дополнительных пакетов для расширения возможностей редактора Vim или gVim" 
#echo 'Установка дополнительных пакетов для расширения возможностей редактора Vim или gVim'
# Installing additional packages to extend the capabilities of the Vim or gVim editor
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (vi, vim-ansible, vim-ale, vim-airline, vim-airline-themes, vim-align, vim-bufexplorer, vim-ctrlp, vim-fugitive, vim-indent-object, vim-jad, vim-jedi, vim-latexsuite, vim-molokai, vim-nerdcommenter, vim-nerdtree, vim-pastie, vim-runtime, vim-seti, vim-spell-ru, vim-supertab, vim-surround, vim-syntastic, vim-tagbar, vim-ultisnips, vim-coverage-highlight, vim-csound, vim-easymotion, vim-editorconfig, vim-gitgutter, vim-grammalecte, vimpager)."
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_vi  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_vi" =~ [^10] ]]
do
    :
done
if [[ $i_vi == 0 ]]; then
echo ""  
echo " Установка дополнительных пакетов для редактора Vim пропущена "
elif [[ $i_vi == 1 ]]; then
echo ""
echo " Установка дополнительных пакетов для редактора Vim "
# sudo pacman -S vi vim-ansible vim-ale vim-airline vim-airline-themes vim-align vim-bufexplorer vim-ctrlp vim-fugitive vim-indent-object vim-jad vim-jedi vim-latexsuite vim-molokai vim-nerdcommenter vim-nerdtree vim-pastie vim-runtime vim-seti vim-spell-ru vim-supertab vim-surround vim-syntastic vim-tagbar vim-ultisnips --noconfirm 
#sudo pacman -S vim-coverage-highlight vim-csound vim-easymotion vim-editorconfig vim-gitgutter vim-grammalecte vimpager --noconfirm  # (https://www.vim.org/)
# Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты шрифтов!
sudo pacman -S vi --noconfirm  # Оригинальный текстовый редактор ex / vi
sudo pacman -S vim-ansible --noconfirm  # Плагин vim для подсветки синтаксиса распространенных типов файлов Ansible
sudo pacman -S vim-ale --noconfirm  # Асинхронный Lint Engine
sudo pacman -S vim-airline --noconfirm  # Строка состояния, написанная в Vimscript
sudo pacman -S vim-airline-themes --noconfirm  # Темы для вим-авиакомпании
sudo pacman -S vim-align --noconfirm  # Позволяет выравнивать строки с помощью регулярных выражений
sudo pacman -S vim-bufexplorer --noconfirm  # Простой список буферов / переключатель для vim
sudo pacman -S vim-ctrlp --noconfirm  # Поиск нечетких файлов, буферов, mru, тегов и т.д.
sudo pacman -S vim-fugitive --noconfirm  # Обертка Git такая классная, она должна быть незаконной
sudo pacman -S vim-indent-object --noconfirm  # Текстовые объекты на основе уровней отступа
sudo pacman -S vim-jad --noconfirm  # Автоматическая декомпиляция файлов классов Java и отображение кода Java
sudo pacman -S vim-jedi --noconfirm  # Плагин Vim для джедаев, отличное автозаполнение Python
sudo pacman -S vim-latexsuite --noconfirm  # Инструменты для просмотра, редактирования и компиляции документов LaTeX в Vim
sudo pacman -S vim-molokai --noconfirm  # Порт цветовой схемы монокаи для TextMate
sudo pacman -S vim-nerdcommenter --noconfirm  # Плагин, позволяющий легко комментировать код для многих типов файлов
sudo pacman -S vim-nerdtree --noconfirm  # Плагин Tree explorer для навигации по файловой системе
sudo pacman -S vim-pastie --noconfirm  # Плагин Vim, который позволяет читать и создавать вставки на http://pastie.org/
sudo pacman -S vim-runtime --noconfirm  # Vi Improved, улучшенная версия текстового редактора vi с широкими возможностями настройки (общая среда выполнения)
sudo pacman -S vim-seti --noconfirm  # Цветовая схема на основе темы Сети Джесси Вида для редактора Atom
sudo pacman -S vim-spell-ru --noconfirm  # Языковые файлы для проверки орфографии в Vim
sudo pacman -S vim-supertab --noconfirm  # Плагин Vim, который позволяет использовать клавишу табуляции для выполнения всех операций вставки
sudo pacman -S vim-surround --noconfirm  # Предоставляет сопоставления для простого удаления, изменения и добавления парного окружения
sudo pacman -S vim-syntastic --noconfirm  # Автоматическая проверка синтаксиса для Vim
sudo pacman -S vim-tagbar --noconfirm  # Плагин для просмотра тегов текущего файла и получения обзора его структуры
sudo pacman -S vim-ultisnips --noconfirm  # Фрагменты для Vim в стиле TextMate
sudo pacman -S vim-coverage-highlight --noconfirm  # Плагин Vim для выделения строк исходного кода Python, которым не хватает тестового покрытия
sudo pacman -S vim-csound --noconfirm  # Инструменты csound для Vim
sudo pacman -S vim-easymotion --noconfirm  # Vim движение по скорости
sudo pacman -S vim-editorconfig --noconfirm  # Плагин EditorConfig для Vim
sudo pacman -S vim-gitgutter --noconfirm  # Плагин Vim, показывающий разницу git в желобе (столбец со знаком)
sudo pacman -S vim-grammalecte --noconfirm  # Интегрирует Grammalecte в Vim
sudo pacman -S vimpager --noconfirm  # Сценарий на основе vim для использования в качестве ПЕЙДЖЕРА
# sudo pacman -S  --noconfirm  #
# sudo pacman -S  --noconfirm  #
# sudo pacman -S  --noconfirm  #
echo ""
echo " Установка дополнительных пакетов для редактора Vim выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установка дополнительных пакетов для расширения возможностей редактора Vim из AUR (через - yay)"
#echo -e "${BLUE}:: ${NC}Установка дополнительных пакетов для расширения возможностей редактора Vim из AUR (через - yay)" 
#echo 'Установка дополнительных пакетов для расширения возможностей редактора Vim из AUR (через - yay)'
# Installing additional packages to extend the capabilities of the Vim editor from AUR (via - yay)
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (vim-colorsamplerpack, vim-doxygentoolkit, vim-guicolorscheme, vim-jellybeans, vim-minibufexpl, vim-omnicppcomplete, vim-project, vim-rails, vim-taglist, vim-vcscommand, vim-workspace)."
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " t_vim  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_vim" =~ [^10] ]]
do
    :
done
if [[ $t_vim == 0 ]]; then
echo ""  
echo " Установка дополнительных пакетов для редактора Vim из AUR (через - yay) пропущена "
elif [[ $t_vim == 1 ]]; then
echo ""
echo " Установка дополнительных пакетов для редактора Vim из AUR (через - yay) "
# yay -S vim-colorsamplerpack vim-doxygentoolkit vim-guicolorscheme vim-jellybeans vim-minibufexpl vim-omnicppcomplete vim-project vim-rails vim-taglist vim-vcscommand vim-workspace --noconfirm  
# Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты шрифтов!
yay -S vim-colorsamplerpack --noconfirm  # Различные цветовые схемы для vim 
yay -S vim-doxygentoolkit --noconfirm  # Этот скрипт упрощает документацию doxygen на C / C ++
yay -S vim-guicolorscheme --noconfirm  # Автоматическое преобразование цветовых схем только для графического интерфейса в схемы цветовых терминалов 88/256
yay -S vim-jellybeans --noconfirm  # Яркая, темная цветовая гамма, вдохновленная ir_black и сумерками
yay -S vim-minibufexpl --noconfirm  # Элегантный обозреватель буферов для vim
yay -S vim-omnicppcomplete --noconfirm  # vim c ++ завершение omnifunc с базой данных ctags
yay -S vim-project --noconfirm  # Организовывать и перемещаться по проектам файлов (например, в проводнике ide / buffer)
yay -S vim-rails --noconfirm  # Плагин ViM для усовершенствованной разработки приложений Ruby on Rails
yay -S vim-taglist --noconfirm  # Плагин браузера с исходным кодом для vim
yay -S vim-vcscommand --noconfirm  # Плагин интеграции системы контроля версий vim
yay -S vim-workspace --noconfirm  # Плагин vim workspace manager для управления группами файлов
# yay -S  --noconfirm  #
# yay -S  --noconfirm  #
# yay -S  --noconfirm  #
pwd  # покажет в какой директории мы находимся
echo ""
echo " Установка дополнительных пакетов для редактора Vim из AUR (через - yay) выполнена "
fi




clear
echo -e "${MAGENTA}
  <<< Установка дополнительного программного обеспечения (пакетов) для обновления личных данных пользователя в Archlinux >>> ${NC}"
# Installing additional software (packages) for updating the user's personal data in Archlinux

echo ""
echo -e "${GREEN}==> ${NC}Установка Mugshot из AUR ()"
#echo -e "${BLUE}:: ${NC}Установка hBlock (повысьте свою безопасность и конфиденциальность, заблокировав рекламу, отслеживание и вредоносные домены)" 
#echo 'Установка hBlock'
# Installing h Block (increase your security and privacy by blocking ads, tracking, and malicious domains)
echo -e "${MAGENTA}=> ${BOLD}Mugshot - это облегченная утилита настройки пользователя для Linux, разработанная для простоты и легкости использования. Быстро обновляйте свой личный профиль и синхронизируйте обновления между приложениями. ${NC}"
echo -e "${MAGENTA}==> Примечание: ${NC}Желательно установить пакет (termite - https://www.archlinux.org/packages/community/x86_64/termite/ - Простой терминал на базе VTE), так как обновление списка доменов в файле hosts - проходит через терминал! hBlock доступен в различных менеджерах пакетов..."
echo -e "${CYAN}:: ${NC}Установка mugshot проходит через сборку из исходников AUR. То есть установка производиться с помощью git clone (https://aur.archlinux.org/mugshot.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/mugshot), собирается и устанавливается."


echo -e "${MAGENTA}==> Примечание: ${NC}Желательно установить пакет (termite - https://www.archlinux.org/packages/community/x86_64/termite/ - Простой терминал на базе VTE), так как обновление списка доменов в файле hosts - проходит через терминал! hBlock доступен в различных менеджерах пакетов..."
echo -e "${YELLOW}==> Применение: ${BOLD}Поведение hBlock по умолчанию можно настроить с помощью нескольких параметров. Воспользуйтесь --help опцией или проверьте полный список в файле hblock.1.md - (при скачивании и установке с сайта https://github.com/hectorm/hblock). ${NC}"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_mugshot  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_mugshot" =~ [^10] ]]
do
    :
done
if [[ $i_mugshot == 0 ]]; then
echo ""  
echo " Установка Mugshot из AUR пропущена "
elif [[ $i_mugshot == 1 ]]; then
##### hblock ######  
  echo ""
  echo " Установка Mugshot из AUR "
# yay -S mugshot --noconfirm  # Программа для обновления личных данных пользователя
git clone https://aur.archlinux.org/mugshot.git   
cd mugshot
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf mugshot
rm -Rf mugshot   # удаляем директорию сборки
echo ""   
echo " Установка утилит (пакетов) выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi










xfce4-whiskermenu-plugin  - # Меню для Xfce4
https://www.archlinux.org/packages/community/x86_64/xfce4-whiskermenu-plugin/







































































































