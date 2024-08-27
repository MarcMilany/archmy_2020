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

DEBTAP="russian"  # Installer default language (Язык установки по умолчанию)

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

echo -e "${MAGENTA}
<<< Установка дополнительного программного обеспечения для создания, изменения - пакетов, и дальнейшей установке их в систему Archlinux >>> ${NC}"
# Installing additional software to create, modify, and install packages in the Archlinux system

echo ""
echo -e "${GREEN}==> ${NC}Установить Debtap для элементарной (базовой) конвертации (преобразования) *.deb пакетов в *.pkg.tar.xz(-any.pkg.tar.zst), и дальнейшей установке в Archlinux?"
# Install Deb tar to convert *. deb packages to *.pkg.tar.xz(-any.pkg.tar.zcf), and then install them in the system?
echo -e "${MAGENTA}=> ${BOLD}Debtap - это Скрипт для преобразования пакетов .deb в пакеты Arch Linux, ориентированный на точность. Не используйте его для преобразования пакетов, которые уже существуют в официальных репозиториях (Arch Based Distribution), или могут быть собраны из AUR! (https://github.com/helixarch/debtap) ${NC}"
echo -e "${CYAN}:: ${NC}Он работает аналогично с alien (который конвертирует пакеты .deb в пакеты .rpm и наоборот), но, в отличие от alien, он ориентирован на точность преобразования, пытаясь перевести имена пакетов Debian / Ubuntu в правильные пакеты Arch Linux, и сохранить их в полях зависимостей метаданных .PKGINFO в окончательном пакете..."
echo -e "${CYAN}:: ${NC}Установка debtap проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/debtap.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/debtap), собирается и устанавливается."
echo -e "${YELLOW}=> Важно: ${NC}Перед установкой (преобразованных) пакетов - ВЫПОЛНИТЕ резервное копирование пользовательских данных /пространства (разделов системы)-(возможность повреждения вашей системы)!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_deb  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_deb" =~ [^10] ]]
do
    :
done
if [[ $i_deb == 0 ]]; then
echo ""
echo " Установка debtap (преобразование пакетов .deb) пропущена "
elif [[ $i_deb == 1 ]]; then
  #echo ""
  #echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  #yay -Syy
  #yay -Syu
  echo ""
  echo " Установка скрипта debtap (для преобразования пакетов .deb) "
##### debtap ######
# yay -S debtap --noconfirm  # Сценарий для преобразования пакетов .deb в пакеты Arch Linux, ориентированный на точность. Не используйте его для преобразования пакетов, которые уже существуют в официальных репозиториях или могут быть собраны из AUR!
git clone https://aur.archlinux.org/debtap.git
cd debtap
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf debtap
rm -Rf debtap   # удаляем директорию сборки
echo ""
echo -e "${CYAN} Настройка перед использованием: ${NC}(Вы делаете это с привилегиями root)"
# echo " Настройка перед использованием: (Вы делаете это с привилегиями root) "
echo " Выполняется синхронизация репозиториев Arch'a (обновим pkgfile и базу данных debtap), и доустановка недостающих компонентов (деталей) "
sudo debtap -u
# sudo debtap -U  # сделаем первый запуск скрипта
echo ""
echo " Сборка и установка debtap выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
sleep 02
# ---------------------------
# Доступные параметры debtap:
#    -h --help Распечатать справку
#    -u --update Обновить базу данных долгового соглашения
#    -q --quiet Пропустить все вопросы, кроме редактирования файла (ов) метаданных
#    -Q --Quiet Пропустить все вопросы (не рекомендуется)
#    -s - -pseudo Создать псевдо-64-битный пакет из 32-битного пакета .deb
#    -w --wipeout Удалить версии из всех зависимостей, конфликтов и т. д.
#    -p --pkgbuild Дополнительно создать файл PKGBUILD
#    -P --Pkgbuild Создать PKGBUILD только файл
#    -v --version Версия для печати
# -----------------------------
# Команда по работе со скриптом debtap
# Конвертировать .deb пакеты:
# debtap (имя пакета).deb  # debtap package_name.deb
# Утилита задает вопрос о желаемом имени пакета, о его лицензии. Дальше распакует пакет, соберет информацию, сформирует структуру и предложит внести правки в PKGINFO и INSTALL, от чего можно и отказаться. После этого будет сгенерирован пакет для арча, который ставится обычным образом.
# Посмотрим на файлы, что лежат в папке сборки:
# ls
# Установка программы (пакета):
# sudo pacman -U (имя пакета).pkg.tar.xz  # sudo pacman -U package_name.pkg
# Не рекомендуется (возможно, опасно)
# Этот метод пытается установить пакет, используя формат упаковки debian на Arch, который не рекомендуется из-за возможной опасности повреждения вашей установки!
# --------------------------------

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
# URL-адрес клона Git:  https://aur.archlinux.org/debtap-mod.git (только чтение, нажмите, чтобы скопировать)
# https://aur.archlinux.org/packages/debtap-mod
# База пакета:  debtap
# Описание: Скрипт для преобразования пакетов .deb в пакеты Arch Linux, ориентированный на точность. Не используйте его для преобразования пакетов, которые уже существуют в официальных репозиториях или могут быть собраны из AUR!
# Восходящий URL-адрес: https://github.com/helixarch/debtap
# Лицензии: GPL2
# Конфликты:  xfce4-docklike-plugin-git, xfce4-docklike-plugin-ng-git
# Отправитель:  helix
# Сопровождающий: helix
# Последний упаковщик:  helix
# Голоса: 297
# Популярность: 3.59
# Впервые отправлено: 2014-09-26 15:32 (UTC)
# Последнее обновление: 2022-04-25 07:52 (UTC)

# <<< Делайте выводы сами! >>>

