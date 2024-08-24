#!/usr/bin/env bash
# Install script Mugshot
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

MUGSHOT="russian"  # Installer default language (Язык установки по умолчанию)

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
echo -e "${MAGENTA}
  <<< Установка дополнительного программного обеспечения (пакетов) для личных данных пользователя в Archlinux >>> ${NC}"
# Installing additional software (packages) for updating the user's personal data in Archlinux
echo ""
echo -e "${GREEN}==> ${NC}Установка Mugshot из AUR (настройка личных данных пользователя)(😃)"
#echo -e "${BLUE}:: ${NC}Установка Mugshot из AUR (настройка личных данных пользователя)"
#echo 'Установка Mugshot из AUR (настройка личных данных пользователя)'
# Installing Mugshot from AUR (configuring user's personal data)
echo -e "${MAGENTA}=> ${BOLD}Mugshot - это облегченная утилита настройки пользователя для Linux, разработанная для простоты и легкости использования. Быстро обновляйте свой личный профиль и синхронизируйте обновления между приложениями. ${NC}"
echo -e "${MAGENTA}==> Примечание: ${NC}В обновляемую информацию личного профиля входят: - Изображение профиля Linux: ~ / .face и AccountService; Данные пользователя хранятся в / etc / passwd (используется finger и другими настольными приложениями); (Необязательно) Синхронизация изображение своего профиля со значком Pidgin; (Необязательно) Синхронизация данных пользователя с LibreOffice и т.д..."
echo -e "${CYAN}:: ${NC}Установка mugshot проходит через сборку из исходников AUR. То есть установка производиться с помощью git clone (https://aur.archlinux.org/mugshot.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/mugshot), собирается и устанавливается."
echo -e "${YELLOW}==> Примечание: ${BOLD}Если вы используете рабочее окружение Xfce, то желательно установить пакет (xfce4-whiskermenu-plugin - Меню для Xfce4 - https://www.archlinux.org/packages/community/x86_64/xfce4-whiskermenu-plugin/, если таковой не был установлен изначально). ${NC}"
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
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu
##### mugshot ######
  echo ""
  echo " Установка Mugshot из AUR (для настройки личных данных пользователя) "
# sudo pacman -S xfce4-whiskermenu-plugin --noconfirm  # Меню для Xfce4
# yay -S mugshot --noconfirm  # Программа для обновления личных данных пользователя ; https://aur.archlinux.org/mugshot.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/bluesabre/mugshot ; https://aur.archlinux.org/packages/mugshot
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
##################

sleep 2
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

### end of script"

# -------------------------------------------------

# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps

# ---------------------------------------------------
# URL-адрес клона Git:  https://aur.archlinux.org/mugshot.git (только чтение, нажмите, чтобы скопировать)
# База пакета:  mugshot
# Описание: Программа для обновления личных данных пользователя
# Восходящий URL-адрес: https://github.com/bluesabre/mugshot
# Лицензии: GPLv3
# Отправитель:  None
# Сопровождающий: twa022
# Последний упаковщик:  twa022
# Голоса: 101
# Популярность: 0,46
# Впервые отправлено: 2014-10-06 21:37 (UTC)
#Последнее обновление: 2022-09-06 01:38 (UTC)
# --------------------------------------#
# checkrebuild -v
# foreign mugshot
# /usr/lib/python3.11/ is owned by mugshot 0.4.3-3
# ------------------------------------#
# <<< Делайте выводы сами! >>>

