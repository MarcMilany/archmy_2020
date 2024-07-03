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
#######################################

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
#######################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Обновить базы данных пакетов включая AUR пакеты, которые установлены в Arch, если таковые есть?"
echo -e "${YELLOW}==> Примечание: ${NC}Выберите вариант обновления баз данных пакетов, и утилит, в зависимости от установленного вами AUR Helper (yay), или пропустите обновления - (если AUR НЕ установлен)."
echo -e "${CYAN}=> ${BOLD}В сценарии скрипта присутствуют следующие варианты: ${NC}"
echo " 1 - Обновление баз данных пакетов через 'AUR'-'yay', то выбирайте вариант "1" "
echo " 2 - Установка обновлений баз данных пакетов, и утилит через 'AUR'-'yay', то выбирайте вариант "2" "
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Обновление через - AUR (Yay) (-Syy),     2 - Обновить и установить через - AUR (Yay) (-Syu),

    0 - Пропустить обновление баз данных пакетов, и утилит: " in_aur_update  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_aur_update" =~ [^120] ]]
do
    :
done
if [[ $in_aur_update == 0 ]]; then
  echo ""
  echo " Обновление баз данных пакетов, и утилит пропущено "
elif [[ $in_aur_update == 1 ]]; then
  echo ""
  echo " Обновление баз данных пакетов через - AUR (Yay) "
  yay -Syy
  echo ""
echo " Обновление базы данных выполнено "
elif [[ $in_aur_update == 2 ]]; then
  echo ""
  echo " Обновление баз данных пакетов, и утилит через - AUR (Yay) "
  yay -Syu
  echo ""
echo " Обновление баз данных пакетов, и утилит выполнено " 
fi
#######################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Создадим папку (downloads), и перейдём в созданную папку "
#echo " Создадим папку (downloads), и переходим в созданную папку "
# Create a folder (downloads), and go to the created folder
echo -e "${MAGENTA}=> ${NC}Почти весь процесс: по загрузке, сборке софта (пакетов) устанавливаемых из AUR - будет проходить в созданной папке (downloads)."
echo -e "${CYAN}:: ${NC}Если Вы захотите сохранить софт (пакеты) устанавливаемых из AUR, и в последствии создать свой маленький (пользовательский репозиторий Arch), тогда перед удалением папки (downloads) в заключении работы скрипта, скопируйте нужные вам пакеты из папки (downloads) в другую директорию."
echo -e "${YELLOW}==> Примечание: ${NC}Вы можете пропустить создание папки (downloads), тогда сборка софта (пакетов) устанавливаемых из AUR - будет проходить в папке указанной (для сборки) Pacman gui (в его настройках, если таковой был установлен), или по умолчанию в одной из системных папок (tmp;.cache;...)."
echo " В заключении работы сценария (скрипта) созданная папка (downloads) - Будет полностью удалена из домашней (home) директории! "
echo " Будьте внимательны! Вы можете пропустить это действие. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да создать папку (downloads),     0 - НЕТ - Пропустить действие: " i_folder  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_folder" =~ [^10] ]]
do
    :
done
if [[ $i_folder == 0 ]]; then
  echo ""
  echo " Создание папки (downloads) пропущено "
elif [[ $i_folder == 1 ]]; then
  echo ""
  echo " Создаём и переходим в созданную папку (downloads) "
  mkdir ~/downloads  # создание папки (downloads)
  cd ~/downloads  # перейдём в созданную папку
  echo " Посмотрим в какой директории мы находимся "
  pwd  # покажет в какой директории мы находимся
fi
sleep 01
#######################################

clear
echo ""
echo -e "${GREEN}==> ${NC}Установка редактора шрифтов и дополнительных шрифтов из AUR (через - yay)"
#echo -e "${BLUE}:: ${NC}Установка редактора шрифтов и дополнительных шрифтов из AUR (через - yay)"
#echo 'Установка дополнительных шрифтов из AUR'
# The installation of additional fonts from the AUR (through - yay)
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (font-manager, ttf-ms-fonts, ttf-clear-sans, ttf-monaco, montserrat-font-ttf, ttf-paratype, ttf-comfortaa, ttf-cheapskate, ttf-symbola, ttf-nerd-fonts-hack-complete-git, ttf-font-logos, ttf-tahoma, ttf-font-icons)." 
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
echo -e " Установка базовых программ и пакетов wget, curl, git "
sudo pacman -S --noconfirm --needed wget curl git  # Сетевая утилита для извлечения файлов из Интернета, Быстрая распределенная система контроля версий, Инструмент командной строки и библиотека для передачи данных с помощью URL-адресов.
echo ""
echo " Установка дополнительных шрифтов из AUR (через - yay) "
# yay -S font-manager ttf-ms-fonts ttf-clear-sans ttf-monaco montserrat-font-ttf ttf-paratype ttf-comfortaa ttf-cheapskate ttf-symbola ttf-nerd-fonts-hack-complete-git ttf-font-logos ttf-font-icons --noconfirm 
# Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты шрифтов! 
######### font-manager-git ################
# yay -S font-manager-git --noconfirm  # Простое приложение для управления шрифтами для GTK + Desktop Environments https://aur.archlinux.org/packages/font-manager-git ; https://aur.archlinux.org/font-manager-git.git (только для чтения, нажмите, чтобы скопировать) ; https://fontmanager.github.io
# git clone https://aur.archlinux.org/font-manager-git.git  # (только для чтения, нажмите, чтобы скопировать)
# cd font-manager-git
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf font-manager-git 
# rm -Rf font-manager-git
######### ttf-ms-fonts ################
yay -S ttf-ms-fonts --noconfirm  # Основные шрифты TTF от Microsoft ; https://aur.archlinux.org/packages/ttf-ms-fonts ; https://aur.archlinux.org/ttf-ms-fonts.git (только для чтения, нажмите, чтобы скопировать) ; http://corefonts.sourceforge.net
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
######### ttf-ms-win8 ################
### По желанию: (содержит в себе ttf-ms-fonts, ttf-vista-fonts и ttf-win7-fonts, т.е. всё что надо включая Calibri и .т.п.)
# yay -S ttf-ms-win8 --noconfirm  # Шрифты Microsoft Windows 8.1 Latin и International TrueType ; https://aur.archlinux.org/packages/ttf-ms-win8 ; http://www.microsoft.com/typography/fonts/product.aspx?PID=161
######### ttf-clear-sans ################
yay -S ttf-clear-sans --noconfirm  # Универсальный шрифт OpenType для экрана, печати и Интернета (возможно уже установлен) ; https://aur.archlinux.org/packages/ttf-clear-sans ; https://aur.archlinux.org/ttf-clear-sans.git (только для чтения, нажмите, чтобы скопировать) ; https://01.org/clear-sans
# git clone https://aur.archlinux.org/ttf-clear-sans.git  # (только для чтения, нажмите, чтобы скопировать)
# cd ttf-clear-sans
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ttf-clear-sans 
# rm -Rf ttf-clear-sans
######### ttf-ionicons ################
yay -S ttf-ionicons --noconfirm  # Шрифт из мобильного фреймворка Ionic ; https://aur.archlinux.org/packages/ttf-ionicons ; https://aur.archlinux.org/ttf-ionicons.git (только для чтения, нажмите, чтобы скопировать) ; https://ionicons.com/
# git clone https://aur.archlinux.org/ttf-ionicons.git  # (только для чтения, нажмите, чтобы скопировать)
# cd ttf-ionicons
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ttf-ionicons 
# rm -Rf ttf-ionicons
######### ttf-monaco ################
yay -S ttf-monaco --noconfirm  # Моноширинный шрифт без засечек Monaco со специальными символами ; https://aur.archlinux.org/packages/ttf-monaco ; https://aur.archlinux.org/ttf-monaco.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/taodongl/monaco.ttf
# git clone https://aur.archlinux.org/ttf-monaco.git  # (только для чтения, нажмите, чтобы скопировать)
# cd ttf-monaco
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ttf-monaco 
# rm -Rf ttf-monaco
######### ttf-monaco-nerd-font-git ################
yay -S ttf-monaco-nerd-font-git --noconfirm  # Шрифт Monaco исправлен с помощью nerd patcher от ryanoasis ; https://aur.archlinux.org/packages/ttf-monaco-nerd-font-git ; https://github.com/Karmenzind/monaco-nerd-fonts
# git clone https://aur.archlinux.org/ttf-monaco-nerd-font-git.git  # (только для чтения, нажмите, чтобы скопировать)
# cd ttf-monaco-nerd-font-git
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ttf-monaco-nerd-font-git 
# rm -Rf ttf-monaco-nerd-font-git
######### ttf-paratype ################
yay -S ttf-paratype --noconfirm  # Семейство шрифтов ParaType с расширенными наборами символов кириллицы и латиницы ; https://aur.archlinux.org/packages/ttf-paratype ; https://aur.archlinux.org/ttf-paratype.git (только для чтения, нажмите, чтобы скопировать) ; https://www.paratype.com 
# git clone https://aur.archlinux.org/ttf-paratype.git  # (только для чтения, нажмите, чтобы скопировать)
# cd ttf-paratype
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ttf-paratype 
# rm -Rf ttf-paratype
######### ttf-comfortaa ################
yay -S ttf-comfortaa --noconfirm  # Закругленный геометрический шрифт без засечек от Google, автор - Йохан Аакерлунд ; https://aur.archlinux.org/packages/ttf-comfortaa ; https://aur.archlinux.org/ttf-comfortaa.git (только для чтения, нажмите, чтобы скопировать) ; https://fonts.google.com/specimen/Comfortaa
# git clone https://aur.archlinux.org/ttf-comfortaa.git  # (только для чтения, нажмите, чтобы скопировать)
# cd ttf-comfortaa
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ttf-comfortaa
# rm -Rf ttf-comfortaa
######### ttf-cheapskate ################
### yay -S ttf-cheapskate --noconfirm  # Шрифты TTF от Дастина Норландера ; https://aur.archlinux.org/packages/ttf-cheapskate ; https://aur.archlinux.org/ttf-cheapskate.git (только для чтения, нажмите, чтобы скопировать) ; https://www.1001fonts.com/users/dustinn
# PSA: Как и для всех PKGBUILD, которые я (совместно) поддерживаю, я размещаю готовые пакеты x86_64s для этого пакета в моем пользовательском репозитории (https://wiki.archlinux.org/title/Unofficial_user_repositories#alerque) для тех, кто хочет установить его, pacmanне возясь со сборкой из AUR (https://wiki.archlinux.org/title/Arch_User_Repository#Installing_and_upgrading_packages).
# git clone https://aur.archlinux.org/ttf-cheapskate.git  # (только для чтения, нажмите, чтобы скопировать)
# cd ttf-comfortaa
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ttf-comfortaa
# rm -Rf ttf-comfortaa
######### ttf-symbola ################ 
yay -S ttf-symbola --noconfirm  # Шрифт для символьных блоков стандарта Unicode (TTF) ; https://aur.archlinux.org/packages/ttf-symbola ; https://aur.archlinux.org/font-symbola.git (только для чтения, нажмите, чтобы скопировать) ; https://dn-works.com/ufas/
# git clone https://aur.archlinux.org/font-symbola.git  # (только для чтения, нажмите, чтобы скопировать)
# cd ttf-symbola
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ttf-symbola
# rm -Rf ttf-symbola
######### ttf-symbola-free ################
# yay -S ttf-symbola-free --noconfirm  # Шрифт с серыми эмодзи, старая бесплатная версия ; https://aur.archlinux.org/packages/ttf-symbola-free ; https://aur.archlinux.org/ttf-symbola-free.git (только для чтения, нажмите, чтобы скопировать) ; https://fontlibrary.org/en/font/symbola
######### ttf-nerd-fonts-hack-complete-git ################
yay -S ttf-nerd-fonts-hack-complete-git --noconfirm  # Шрифт, разработанный для исходного кода. Исправлены иконки Nerd Fonts (Помечено как устаревшее (2023-11-13)) ; https://aur.archlinux.org/packages/ttf-nerd-fonts-hack-complete-git ; https://aur.archlinux.org/ttf-nerd-fonts-hack-complete-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/ryanoasis/nerd-fonts
# git clone https://aur.archlinux.org/ttf-nerd-fonts-hack-complete-git.git  # (только для чтения, нажмите, чтобы скопировать)
# cd ttf-nerd-fonts-hack-complete-git
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ttf-nerd-fonts-hack-complete-git
# rm -Rf ttf-nerd-fonts-hack-complete-git
######### ttf-tahoma ################
yay -S ttf-tahoma --noconfirm  # Шрифты Tahoma и Tahoma Bold из проекта Wine (https://www.winehq.org/) ; https://aur.archlinux.org/packages/ttf-tahoma ; https://aur.archlinux.org/ttf-tahoma.git (только для чтения, нажмите, чтобы скопировать)
# git clone https://aur.archlinux.org/ttf-tahoma.git  # (только для чтения, нажмите, чтобы скопировать)
# cd ttf-tahoma
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ttf-tahoma
# rm -Rf ttf-tahoma
######### ttf-font-logos ################
yay -S ttf-font-logos --noconfirm  # Значок шрифта с логотипами популярных дистрибутивов Linux ; https://aur.archlinux.org/packages/ttf-font-logos ; https://aur.archlinux.org/ttf-font-logos.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/lukas-w/font-logos
# git clone https://aur.archlinux.org/ttf-font-logos.git  # (только для чтения, нажмите, чтобы скопировать)
# cd ttf-font-logos
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ttf-font-logos
# rm -Rf ttf-font-logos
######### ttf-font-icons ################
yay -S ttf-font-icons --noconfirm  # Неперекрывающееся сочетание иконических шрифтов Ionicons и Awesome ; https://aur.archlinux.org/packages/ttf-font-icons ; https://aur.archlinux.org/ttf-font-icons.git (только для чтения, нажмите, чтобы скопировать) ; http://kageurufu.net/icons.pdf
# git clone https://aur.archlinux.org/ttf-font-icons.git  # (только для чтения, нажмите, чтобы скопировать)
# cd ttf-font-logos
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ttf-font-logos
# rm -Rf ttf-font-logos
######### ttf-wps-fonts ################
# Требуются wps-office
# yay -S ttf-wps-fonts --noconfirm  # Если установлен WPS - Символьные шрифты требуются wps-office ; https://aur.archlinux.org/packages/ttf-wps-fonts ; https://aur.archlinux.org/ttf-wps-fonts.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/ferion11/ttf-wps-fonts
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
######### font-bh-ttf ################
yay -S font-bh-ttf --noconfirm  # Шрифты X.org Luxi Truetype ; https://aur.archlinux.org/packages/font-bh-ttf ; https://aur.archlinux.org/font-bh-ttf.git (только для чтения, нажмите, чтобы скопировать) ; https://xorg.freedesktop.org/releases/individual/font/
# git clone https://aur.archlinux.org/font-bh-ttf.git  # (только для чтения, нажмите, чтобы скопировать)
# cd font-bh-ttf
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf font-bh-ttf
# rm -Rf font-bh-ttf
#######################################
# yay -S  --noconfirm  #
# yay -S  --noconfirm  #
# yay -S  --noconfirm  #
pwd  # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
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
echo ""
echo -e "${BLUE}:: ${NC}Удаление созданной папки (downloads)"
#echo " Удаление созданной папки (downloads), и скрипта установки программ (font_aur) "
#echo ' Удаление созданной папки (downloads), и скрипта установки программ (font_aur) '
# Deleting the created folder (downloads) and the program installation script (font_aur)
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
# sudo rm -rf ~/font_aur  # Если скрипт не был перемещён в другую директорию
echo " Удаление выполнено "
fi

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