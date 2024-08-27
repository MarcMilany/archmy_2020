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

GIGOLO="russian"  # Installer default language (Язык установки по умолчанию)

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
<<< Установка дополнительного программного обеспечения Gigolo - Подключение к FTP и SFTP в системе Archlinux >>> ${NC}"
echo ""
echo -e "${GREEN}==> ${NC}Установить Gigolo — графический клиент для подключения к удаленным ресурсам по FTP или SFTP (SSH)?"
echo -e "${MAGENTA}=> ${BOLD}Gigolo представляет собой графический интерфейс (фронтенд) для подключения к (S)FTP серверам. Программа использует визуальную файловую систему GVfs (GNOME Virtual file system), которая в свою очередь использует библиотеку GIO (Gnome Input/Output). Поддерживаются следующие протоколы (сервисы): FTP, SFTP (SSH), WebDAV, Secure WebDAV, Windows Share.${NC}"
echo -e "${CYAN}:: ${NC}Все ваши соединения вы можете сохранить в программе в Закладки. Каждая закладка представляет собой отдельные настройки для соединения к какому-либо серверу. Для каждой закладки можно назначить свое название и выбрать цвет. Для каждого соединения можно настроить Порт, Имя пользователя, Директорию, которую открывать при подключении. Также можно включить автоподключение при запуске программы. Программа также добавляет свою иконку в панель уведомлений (трей). При клике правой кнопкой мыши по иконке, открывается контекстное меню. Через него можно получить доступ к закладкам и базовым функциям (открыть окна соединения, настроек и редактирования закладок)."
echo -e "${CYAN}:: ${NC}Gigolo не предоставляет графического интерфейса для просмотра удаленных файлов, но для каждого подключения можно открыть внешний файловый менеджер или терминал. Пользователь может настроить, какой терминал и файловый менеджер использовать."
echo -e "${YELLOW}=> Примечание! ${NC}Программа использует библиотеки GTK2 и является частью проекта XFCE. При этом практически не имеет зависимостей от библиотек XFCE и может использоваться в любом другом дистрибутиве. Программа полностью переведена на русский язык."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_gigolo  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_gigolo" =~ [^10] ]]
do
    :
done
if [[ $i_gigolo == 0 ]]; then
echo ""
echo " Установка Gigolo (пакета - gigolo) пропущена "
elif [[ $i_gigolo == 1 ]]; then
echo ""
echo " Установка Gigolo (графический интерфейс для управления соединениями с удалёнными файловыми системами использующими GIO / GVfs) "
# yay -S gigolo --noconfirm  # Фронтенд для управления подключениями к удаленным файловым системам с помощью GIO / GVFS
echo " Установка Gigolo (пакета - gigolo) "
##### gigolo ######  
git clone https://aur.archlinux.org/gigolo.git
cd gigolo
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gigolo
rm -Rf gigolo   # удаляем директорию сборки
echo ""
echo " Установка Gigolo (gigolo) выполнена "
fi
sleep 02

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

# https://aur.archlinux.org/packages/gigolo/
# Фронтенд для управления подключениями к удаленным файловым системам с помощью GIO / GVFS
# База пакета: gigolo
# URL восходящего направления:	https://www.uvena.de/gigolo
# Git Clone URL: https://aur.archlinux.org/gigolo.git  (только для чтения, нажмите, чтобы скопировать)
# Голоса:	115
# Популярность:	0,41
# Первый отправленный:	2009-02-26 22:39
# Последнее обновление:	2020-10-11 19:01
# Источники:
# https://archive.xfce.org/src/apps/gigolo/0.5/gigolo-0.5.1.tar.bz2
# Зависимости: gvfs ( gvfs-nosystemd , gvfs-git )
# gvfs - Реализация виртуальной файловой системы для GIO ( https://www.archlinux.org/packages/extra/x86_64/gvfs/ )
# gvfs-nosystemd - Реализация виртуальной файловой системы для GIO, версия nosystemd (https://aur.archlinux.org/packages/gvfs-nosystemd/) (https://aur.archlinux.org/gvfs-nosystemd.git)
# gvfs-git - Реализация виртуальной файловой системы для GIO (https://aur.archlinux.org/packages/gvfs-git/) (https://aur.archlinux.org/gvfs-git.git)
#
# <<< Делайте выводы сами! >>>
#





