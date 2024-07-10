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

############### Installing fonts-according ###############
clear
echo -e "${MAGENTA}
  <<< Установка Редактора шрифтов и дополнительных шрифтов - по вашему выбору и желанию >>> ${NC}"
# Install font Editor and additional fonts-according to your choice and desire 

echo ""
echo -e "${GREEN}==> ${NC}Создать папку (.fonts) с локальными шрифтами в директории пользователя?"
#echo -e "${BLUE}:: ${NC}Создать папку (.fonts) с локальными шрифтами в директории пользователя?"
#echo 'Создать папку (.fonts) с локальными шрифтами в директории пользователя'
# Create a folder (.fonts) with local fonts in the user's directory?
echo " Обратите ВНИМАНИЯ - ВОЗМОЖНО такая папка (.fonts) уже существует - тогда откажитесь!!! "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да создать папку (.fonts),     0 - НЕТ - Пропустить создание папки (.fonts): " i_folder  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_folder" =~ [^10] ]]
do
    :
done
if [[ $i_folder == 0 ]]; then
echo ""
echo " Создание папки (.fonts) пропущено "
elif [[ $i_folder == 1 ]]; then
  echo ""
  echo " Создаём папку (.fonts) в директории пользователя "
mkdir ~/.fonts  # Создадим папку с локальными шрифтами
echo ""
echo " Создание папки выполнено "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить редактор шрифтов и дополнительные шрифты?"
#echo -e "${BLUE}:: ${NC}Установить редактор шрифтов и дополнительные шрифты?"
#echo 'Установка дополнительных шрифтов'
# Install the font editor and additional fonts?
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - Посмотрите перед установкой в скрипте!."  
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют функция пропуска установки уже установленных шрифтов! ${NC}"
echo -e "${CYAN}:: ${NC}Также Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты шрифтов!"
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
# sudo pacman -S ttf-roboto noto-fonts noto-fonts-emoji noto-fonts-cjk freetype2 --noconfirm                                                   
#sudo pacman -S adobe-source-code-pro-fonts adobe-source-han-sans-cn-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts adobe-source-sans-pro-fonts --noconfirm  # Ставим шрифты:  https://www.archlinux.org/packages/ 
# Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты шрифтов!
# mkdir ~/.fonts  # Создадим папку с локальными шрифтами
sudo pacman -S --noconfirm --needed font-manager  # Простое приложение для управления шрифтами для сред рабочего стола GTK+  https://archlinux.org/packages/extra/x86_64/font-manager/ ; https://fontmanager.github.io
sudo pacman -S --noconfirm --needed fontforge  # Редактор контурных и растровых шрифтов 
sudo pacman -S --noconfirm --needed gsfonts  # (URW) ++ Базовый набор шрифтов [Уровень 2] (возможно уже установлен)
sudo pacman -S --noconfirm --needed ttf-croscore  # Основные шрифты Chrome OS, они метрически совместимы с MS, и хорошо смотрятся, содержат Arimo, Tinos, Cousine и тп.
sudo pacman -S --noconfirm --needed ttf-ubuntu-font-family  # Семейство шрифтов Ubuntu - красивые, не вырвиглазные шрифты без засечек, использую в DE и текстовых документах. (Помечено как устаревшее 03.08.2023)
sudo pacman -S --noconfirm --needed ttf-font-awesome  # Культовый шрифт, разработанный для Bootstrap
sudo pacman -S --noconfirm --needed ttf-hack  # Ухоженный и оптически сбалансированный шрифт на основе Bitstream Vera Mono
sudo pacman -S --noconfirm --needed ttf-carlito  # Шрифт Google Carlito - метрически совместим с MS Calibri
sudo pacman -S --noconfirm --needed ttf-caladea  # Семейство шрифтов с засечками по метрике, совместимое с семейством шрифтов MS Cambria 
sudo pacman -S --noconfirm --needed ttf-bitstream-vera  # Шрифты Bitstream Vera
sudo pacman -S --noconfirm --needed ttf-droid  # Шрифты общего назначения, выпущенные Google как часть Android
sudo pacman -S --noconfirm --needed ttf-linux-libertine  # Шрифты OpenType с засечками (Libertine) и Sans Serif (Biolinum) с большим охватом Unicode
sudo pacman -S --noconfirm --needed gnu-free-fonts  # Бесплатное семейство масштабируемых контурных шрифтов
sudo pacman -S --noconfirm --needed powerline-fonts  # Исправленные шрифты для powerline
sudo pacman -S --noconfirm --needed ttf-roboto  # Фирменное семейство шрифтов Google (возможно уже установлен)(Помечен как устаревший 24 июня 2023 г.)
sudo pacman -S --noconfirm --needed ttf-roboto-mono  # Моноширинное дополнение к семейству роботов Roboto (возможно уже установлен)
sudo pacman -S --noconfirm --needed ttf-nerd-fonts-symbols  # Большое количество дополнительных глифов из популярных `` культовых шрифтов '' (2048-em)
sudo pacman -S --noconfirm --needed ttf-arphic-ukai  # Шрифт CJK Unicode в стиле Kaiti
sudo pacman -S --noconfirm --needed ttf-arphic-uming  # CJK Unicode шрифт в стиле Ming
sudo pacman -S --noconfirm --needed ttf-inconsolata  # Моноширинный шрифт для красивых списков кода и для терминала - шрифт для "коддинга", - Можно не ставить.
sudo pacman -S --noconfirm --needed cantarell-fonts  # Шрифт Humanist sans serif (возможно уже установлен)
sudo pacman -S --noconfirm --needed sdl_ttf  # Библиотека, позволяющая использовать шрифты TrueType в ваших приложениях SDL
sudo pacman -S --noconfirm --needed ttf-bitstream-vera  # Шрифты Bitstream Vera.
sudo pacman -S --noconfirm --needed xorg-fonts-type1  # Шрифты X.org Type1
# Китайские, Японские, Индийские шрифт
sudo pacman -S --noconfirm --needed opendesktop-fonts  # Китайские шрифты TrueType 
sudo pacman -S --noconfirm --needed ttf-fireflysung  # Китайские иероглифы: - ;
sudo pacman -S --noconfirm --needed ttf-sazanami  # Японские шрифты
sudo pacman -S --noconfirm --needed ttf-hanazono  # Бесплатный японский шрифт кандзи, который содержит около 78 685 символов (и 2 пробела), определенный в стандарте ISO / IEC 10646 / стандарте Unicode.(Помечено как устаревшее 18.05.2024)
sudo pacman -S --noconfirm --needed ttf-indic-otf  # Коллекция индийских шрифтов Opentype
sudo pacman -S --noconfirm --needed adobe-source-code-pro-fonts  # Семейство моноширинных шрифтов для пользовательского интерфейса и среды программирования sudo pacman -S cantarell-fonts --noconfirm  # Шрифт Humanist sans serif (возможно уже установлен)
sudo pacman -S --noconfirm --needed adobe-source-han-sans-cn-fonts  # Adobe Source Han Sans Subset OTF - упрощенные китайские шрифты OpenType / CFF
sudo pacman -S --noconfirm --needed adobe-source-han-sans-jp-fonts  # Adobe Source Han Sans Subset OTF - японские шрифты OpenType / CFF
sudo pacman -S --noconfirm --needed adobe-source-han-sans-kr-fonts  # Adobe Source Han Sans Subset OTF - корейские шрифты OpenType / CFF
sudo pacman -S --noconfirm --needed adobe-source-sans-pro-fonts  # Семейство шрифтов без засечек для сред пользовательского интерфейса
sudo pacman -S --noconfirm --needed noto-fonts  # Шрифты Google Noto TTF
sudo pacman -S --noconfirm --needed noto-fonts-emoji  # Шрифты эмодзи Google Noto
sudo pacman -S --noconfirm --needed noto-fonts-cjk  # Шрифты Google Noto CJK
sudo pacman -S --noconfirm --needed freetype2  # Библиотека растеризации шрифтов 
### Возможно присутствуют #####
sudo pacman -S --noconfirm --needed ttf-dejavu  # Семейство шрифтов на основе Bitstream Vera Fonts с более широким набором символов
sudo pacman -S --noconfirm --needed ttf-liberation # Семейство шрифтов, нацеленное на метрическую совместимость с Arial, Times New Roman и Courier New 
sudo pacman -S --noconfirm --needed ttf-anonymous-pro  # Семейство из четырех шрифтов фиксированной ширины, разработанных специально с учетом кодирования
sudo pacman -S --noconfirm --needed terminus-font  # Моноширинный растровый шрифт (для X11 и консоли)
###############################
sudo pacman -S --noconfirm --needed ttf-freefont  # Бесплатное семейство масштабируемых контурных шрифтов
# ИЛИ это шрифт - они одинаковые
# sudo pacman -S --noconfirm --needed gnu-free-fonts  # Бесплатное семейство масштабируемых контурных шрифтов
sudo pacman -S --noconfirm --needed ttf-jetbrains-mono  # Шрифт для разработчиков от JetBrains ; https://jetbrains.com/lp/mono ; https://archlinux.org/packages/extra/any/ttf-jetbrains-mono/ 
sudo pacman -S --noconfirm --needed ttf-jetbrains-mono-nerd  # Исправленный шрифт JetBrains Mono из библиотеки шрифтов nerd ; https://github.com/ryanoasis/nerd-fonts ; https://archlinux.org/packages/extra/any/ttf-jetbrains-mono-nerd/
sudo pacman -S --noconfirm --needed   #
# sudo pacman -S --noconfirm --needed   #
echo ""
echo " Установка дополнительных шрифтов выполнена "
echo " Время точное как на Спасской башне Московского Кремля! "
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'   # одновременно отображает дату и часовой пояс
echo ""
echo " Обновим информацию о шрифтах "  # Update information about fonts
sudo fc-cache -f -v
echo ""
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
echo -e "${BLUE}:: ${NC}Если хотите установить шрифты, из AUR - через (yay), тогда после перезагрузки и входа в систему выполните команду:"
echo -e "${YELLOW}==> ${CYAN}git clone https://github.com/MarcMilany/archmy_2020.git ${NC}"
echo -e "${CYAN}:: ${NC}Цель скрипта (font_aur) - это установка дополнительных шрифтов (пакетов), находящихся в AUR и которых нет в стандарных репозиториях Arch'a https://archlinux.org/packages/."
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