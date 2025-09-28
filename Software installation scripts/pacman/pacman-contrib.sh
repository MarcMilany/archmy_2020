#!/usr/bin/env bash
# Install script debtap
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

PCURSES="russian"  # Installer default language (Язык установки по умолчанию)

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
echo -e "${BLUE}:: ${NC}Установим дополнения (плюшки) для Pacman - пакет (pacman-contrib)?"
echo " Этот репозиторий содержит скрипты, предоставленные pacman (различных дополнений и приятных мелочей для более комфортной работы сполна) "
echo -e "${YELLOW}=> Примечание: ${BOLD}Раньше это было частью pacman.git, но было перемещено, чтобы упростить обслуживание pacman. Также, вместе с пакетом (pacman-contrib) будет установлен пакет (pcurses) - инструмент управления пакетами curses с использованием libalpm. ${NC}"
echo " Скрипты, доступные в этом репозитории: checkupdates, paccache, pacdiff, paclist, paclog-pkglist, pacscripts, pacsearch, rankmirrors, updpkgsums;... "
echo " checkupdates - распечатать список ожидающих обновлений, не касаясь баз данных синхронизации системы (для безопасности при скользящих выпусках). "
echo " paccache - гибкая утилита очистки кэша пакетов, которая позволяет лучше контролировать, какие пакеты удаляются. "
echo " pacdiff - простая программа обновления pacnew / pacsave для / etc /. "
echo " paclist - список всех пакетов, установленных из данного репозитория. Полезно, например, для просмотра того, какие пакеты вы могли установить из тестового репозитория. "
echo " paclog-pkglist - выводит список установленных пакетов на основе журнала pacman. "
echo " pacscripts - пытается распечатать сценарии {pre, post} _ {install, remove, upgrade} для данного пакета. "
echo " pacscripts - пытается распечатать сценарии {pre, post} _ {install, remove, upgrade} для данного пакета. "
echo " pacsearch - цветной поиск, объединяющий вывод -Ss и -Qs. Установленные пакеты легко идентифицировать с помощью [installed] значка, и также перечислены только локальные пакеты. "
echo " rankmirrors - ранжирует зеркала pacman по скорости подключения и скорости открытия. "
echo " updpkgsums - выполняет обновление контрольных сумм в PKGBUILD на месте. "
echo -e "${YELLOW}==> ${NC}Будьте внимательны! Если Вы сомневаетесь в своих действиях, просто пропустите этот пункт."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить пакет (pacman-contrib),    0 - Нет пропустить установку: " i_contrib  # sends right after the keypress; # отправляет сразу после нажатия клавиши
echo ''
   [[ "$i_contrib" =~ [^10] ]]
do
    :
done
if [[ $i_contrib == 0 ]]; then
  echo ""
  echo " Установка пакетов пропущена "
elif [[ $i_contrib == 1 ]]; then
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu
  echo ""
  echo " Установка пакетов (pacman-contrib), (pcurses) "
  sudo pacman -S --noconfirm --needed pacman-contrib  # Предоставленные скрипты и инструменты для систем pacman (https://github.com/kyrias/pacman-contrib)
### pacman -S --noconfirm --needed pcurses  # Инструмент управления пакетами curses с использованием libalpm ; pcurses позволяет просматривать пакеты и управлять ими во внешнем интерфейсе curses, написанном на C++ ; https://github.com/schuay/pcurses ; Раньше присутствовал в community ...
##### pcurses ######
### Зависимости ####
  sudo pacman -S --noconfirm --needed ncurses  # Библиотека эмуляции проклятий System V Release 4.0 :https://archlinux.org/packages/core/x86_64/ncurses/
  sudo pacman -S --noconfirm --needed pacman  # Менеджер пакетов на основе библиотеки с поддержкой зависимостей. https://archlinux.org/packages/core/x86_64/pacman/
  sudo pacman -S --noconfirm --needed boost  # Бесплатные рецензируемые портативные исходные библиотеки C++ (заголовки для разработки). https://archlinux.org/packages/extra/x86_64/boost/ --! Помечен как устаревший 14 декабря 2023 г.
  sudo pacman -S --noconfirm --needed cmake  # Кроссплатформенная система make с открытым исходным кодом. https://archlinux.org/packages/extra/x86_64/cmake/
  ##### pcurses ######
#yay -S pcurses --noconfirm  # Интерфейс curses для libalpm ; Инструмент управления пакетами curses с использованием libalpm ; https://aur.archlinux.org/pcurses.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/schuay/pcurses ; https://aur.archlinux.org/packages/pcurses  
git clone https://aur.archlinux.org/pcurses.git 
cd pcurses
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# makepkg --noconfirm --needed -sic
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf mugshot
rm -Rf pcurses   # удаляем директорию сборки
echo ""
echo " Установка утилит (пакетов) выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
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

### end of script
# -------------------------------------------------

# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps

# ---------------------------------------------------
# URL-адрес клона Git:  https://aur.archlinux.org/pcurses.git (только чтение, нажмите, чтобы скопировать)
# База пакета:  pcurses
# Описание: Инструмент управления пакетами проклятий с использованием libalpm.
# Восходящий URL-адрес: https://github.com/schuay/pcurses
# Лицензии: GPL2
# Отправитель:  arojas
# Сопровождающий: ralphptorres
# Последний упаковщик:  arojas
# Голоса: 8
# Популярность: 0,006875
# Впервые отправлено: 01.04.2022 18:11 (UTC)
# Последнее обновление: 01.04.2022 18:11 (UTC)

# ФУНКЦИИ:
# Просмотр пакетов в интерфейсе curses, включая:
# * фильтрация регулярных выражений и поиск любого свойства пакета
# * настраиваемая цветовая кодировка
# * настраиваемая сортировка
# * выполнение внешней команды с заменой строк списка пакетов
# * определяемые пользователем макросы и горячие клавиши

# <<< Делайте выводы сами! >>>

