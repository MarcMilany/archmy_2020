#!/usr/bin/env bash
# Install script thunar-shares-plugin
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

thunar-shares-plugin_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
echo -e "${BLUE}:: ${NC}Установить Плагин Thunar Shares (thunar-shares-plugin) для быстрого совместного использования папки с помощью Samba из Thunar (файловый менеджер Xfce)?" 
echo -e "${CYAN}:: Предисловие! ${NC}Редактор общего доступа находится в диалоговом окне свойств файла (страница «Поделиться»). "
echo -e "${MAGENTA}:: ${BOLD}Плагин Thunar Shares (thunar-shares-plugin) позволяет быстро предоставить общий доступ к папке с помощью Samba из Thunar (файловый менеджер Xfce) без необходимости получения прав root. ${NC}"
echo -e "${MAGENTA}=> ${NC}Плагин Thunar Shares (thunar-shares-plugin) - устанавливается из пользовательского репозитория 'AUR'-'yay' (https://aur.archlinux.org/thunar-shares-plugin.git), собираются и устанавливаются. "
echo " Плагин Thunar Shares (https://gitlab.xfce.org/thunar-plugins/thunar-shares-plugin/-/tree/master) (http://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin ; https://aur.archlinux.org/packages/thunar-shares-plugin ). " 
echo -e "${YELLOW}:: Примечание! ${NC}Зависимости: (samba; thunar; xfce4-dev-tools). Источники: (https://archive.xfce.org/src/thunar-plugins/thunar-shares-plugin/0.3/thunar-shares-plugin-0.3.2.tar.bz2). "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_shares  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_shares" =~ [^10] ]]
do
    :
done 
if [[ $i_shares == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_shares == 1 ]]; then
  echo ""  
  echo " Установка Плагин Thunar Shares (thunar-shares-plugin) "
########## thunar-shares-plugin ##########
sudo pacman -S --noconfirm --needed xfce4-dev-tools  # Инструменты разработчика Xfce ; https://www.xfce.org/ ; https://archlinux.org/packages/extra/x86_64/xfce4-dev-tools/
yay -S thunar-shares-plugin --noconfirm  # Плагин Thunar для быстрого совместного использования папки с помощью Samba без необходимости root-доступа ; https://aur.archlinux.org/thunar-shares-plugin.git (только для чтения, нажмите, чтобы скопировать) ; http://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin ; https://aur.archlinux.org/packages/thunar-shares-plugin ; https://gitlab.xfce.org/thunar-plugins/thunar-shares-plugin/-/tree/master
# yay -S thunar-shares-plugin-git --noconfirm  # Плагин Thunar для быстрого предоставления общего доступа к папке с помощью Samba без необходимости доступа root ; https://aur.archlinux.org/thunar-shares-plugin-git.git (только для чтения, нажмите, чтобы скопировать) ; https://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin ; https://aur.archlinux.org/packages/thunar-shares-plugin-git
# yay -Rns thunar-shares-plugin  # Удалите thunar-shares-plugin в Arch с помощью YAY
# git clone https://aur.archlinux.org/thunar-shares-plugin.git ~/thunar-shares-plugin   # Клонировать git thunar-shares-plugin локально
#git clone https://aur.archlinux.org/thunar-shares-plugin.git 
# cd ~/thunar-shares-plugin  # Перейдите в папку ~/thunar-shares-plugin и установите его
#cd thunar-shares-plugin
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf thunar-shares-plugin
#rm -Rf thunar-shares-plugin   # удаляем директорию сборки 
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
#############
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

