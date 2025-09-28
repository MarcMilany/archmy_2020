#!/usr/bin/env bash
# Install script keepass2-plugin-tray-icon
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget 
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 
apptitle="Arch Linux Fast Install v2.4 LegasyBIOS - Version: 2024.07.31.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

keepass2-plugin-tray-icon_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
###############

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

echo ""    
echo " Обновим базы данных пакетов... "
###  sudo pacman -Sy
sudo pacman -Syy  # обновление баз пакмэна (pacman) 
echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Функциональный значок в трее для KeePass2 (keepass2-plugin-tray-icon)?" 
echo -e "${CYAN}:: Предисловие! ${NC}Плагины KeePass 2.x, обеспечивающие интеграцию с Linux Desktop. Они в первую очередь нацелены на Ubuntu (но могут работать и на других дистрибутивах). "
echo -e "${MAGENTA}:: ${BOLD}Плагины KeePass 2.x (keepass2-plugin-tray-icon) - это Функциональная иконка в трее для KeePass2.x ; Щелчок левой кнопкой мыши по значку активирует окно KeePass. Щелчок правой кнопкой мыши по значку отображает меню. ${NC}"
echo -e "${MAGENTA}=> ${NC}KeePass2-Plugins (keepass2-plugin-tray-icon) - устанавливается из пользовательского репозитория 'AUR'-'yay' (https://aur.archlinux.org/keepass2-plugin-tray-icon.git), собираются и устанавливаются. "
echo " KeePass Plugins and Extensions (https://keepass.info/plugins.html). " 
echo -e "${YELLOW}:: Примечание! ${NC}Функции: этот пакет конфликтует с keepass2-plugin-status-notifier (вы не можете установить оба одновременно). Сравните использование, чтобы решить, какой пакет вы хотите установить. Также этот пакет конфликтует с keepass2-plugin-application-indicator (вы не можете установить оба одновременно). Сравните использование, чтобы решить, какой пакет вы хотите установить. "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_keeplugin  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_keeplugin" =~ [^10] ]]
do
    :
done 
if [[ $i_keeplugin == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_keeplugin == 1 ]]; then
  echo ""  
  echo " Установка KeePass2-Plugins (keepass2-plugin-tray-icon) "
######### ==> Недостающие зависимости ############
############ gtk-sharp-2 #############
sudo pacman -S --noconfirm --needed gtk-sharp-2  # привязки gtk2 для C# ; https://www.mono-project.com/docs/gui/gtksharp/ ; https://archlinux.org/packages/extra/x86_64/gtk-sharp-2/
#yay -S gtk-sharp-2-git --noconfirm  # Привязки C# для GTK+ 2 ; https://aur.archlinux.org/gtk-sharp-2-git.git (только для чтения, нажмите, чтобы скопировать) ; https://mono-project.com/GtkSharp ; https://aur.archlinux.org/packages/gtk-sharp-2-git
############ dbus-sharp-glib #############
yay -S dbus-sharp-glib --noconfirm  # Реализация D-Bus на C# GLib ; https://aur.archlinux.org/dbus-sharp-glib.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/mono/dbus-sharp-glib/ ; https://aur.archlinux.org/packages/dbus-sharp-glib
# yay -Rns dbus-sharp-glib  # Удалите dbus-sharp-glibn в Arch с помощью YAY
# git clone https://aur.archlinux.org/dbus-sharp-glib.git ~/dbus-sharp-glib  # Клонировать git dbus-sharp-glib локально
#git clone https://aur.archlinux.org/dbus-sharp-glib.git 
# cd ~/keepass2-plugin-tray-icon  # Перейдите в папку ~/keepass2-plugin-tray-icon и установите его
#cd dbus-sharp-glib
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf dbus-sharp-glib
#rm -Rf dbus-sharp-glib   # удаляем директорию сборки 
########## keepass2-plugin-tray-icon ##########
yay -S keepass2-plugin-tray-icon --noconfirm  # Функциональная иконка в трее для KeePass2 ; https://aur.archlinux.org/keepass2-plugin-tray-icon.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/dlech/Keebuntu ; https://aur.archlinux.org/packages/keepass2-plugin-tray-icon
# yay -Rns keepass2-plugin-tray-icon  # Удалите keepass2-plugin-tray-icon в Arch с помощью YAY
# git clone https://aur.archlinux.org/keepass2-plugin-tray-icon.git ~/keepass2-plugin-tray-icon   # Клонировать git keepass2-plugin-tray-icon локально
#git clone https://aur.archlinux.org/keepass2-plugin-tray-icon.git 
# cd ~/keepass2-plugin-tray-icon  # Перейдите в папку ~/keepass2-plugin-tray-icon и установите его
#cd keepass2-plugin-tray-icon
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf keepass2-plugin-tray-icon
#rm -Rf keepass2-plugin-tray-icon   # удаляем директорию сборки 
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi

sleep 03
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
# <<< Делайте выводы сами! >>>

