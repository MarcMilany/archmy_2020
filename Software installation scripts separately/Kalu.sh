#!/usr/bin/env bash
# Install script Kalu
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

Kalu_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
echo -e "${BLUE}:: ${NC}Установить Kalu (Keep Arch Linux Up-to-date )(kalu) - Менеджер обновлений для Arch Linux?"
echo -e "${MAGENTA}:: ${BOLD}Kalu — полноценный и функциональный менеджер обновлений для Arch Linux. kalu (что может означать «Keeping Arch Linux Up-to-date») — это небольшое приложение, которое добавит иконку в системный трей и будет там сидеть, регулярно проверяя, есть ли что-то новое для обновления. Как только оно что-то найдет, оно покажет уведомление, чтобы вы знали об этом. Поддержание системы в актуальном состоянии — это то, что следует делать независимо от системы. Это не то, что это более верно для Arch Linux, просто обновления (вероятно, будут) более частыми из-за его природы скользящего релиза. Arch Linux благодаря pacman позволяет нам очень легко обновлять нашу систему благодаря команде pacman -Syu. Однако многим пользователям нравится использовать графический инструмент для обновления своей операционной системы, поэтому родился проект Kalu — Keeping Arch Linux Up-to-date, инструмент для легкого обновления нашего дистрибутива. Kalu — это функциональный менеджер обновлений для Arch Linux, обладающий множеством функций. Если вы работаете в сеансе X, использование уведомителя об обновлении может показаться очень логичным решением. ${NC}"
echo " Домашняя страница: https://github.com/Thulinma/kalu ; (https://aur.archlinux.org/packages/kalu ; https://aur.archlinux.org/packages/kalu-kde). "  
echo -e "${MAGENTA}:: ${BOLD}Что он проверяет? kalu может проверить несколько вещей: Новости Arch Linux. Чтобы не пропустить важное объявление с официального сайта Arch Linux. Доступные обновления для неустановленных пакетов . Вы можете определить список «отслеживаемых пакетов», то есть пакетов, для которых вы хотели бы получать уведомления о выходе обновлений, даже если они не установлены. (Например, пакеты, которые вы перепаковываете для себя, чтобы применить исправление или что-то в этом роде). Доступные обновления для пакетов AUR . Все иностранные пакеты (т.е. не найденные ни в одном репозитории, т.е. -Qm) можно проверить на наличие обновлений, доступных в AUR. Доступные обновления для отслеживаемых пакетов AUR . Как и в случае с «обычными» пакетами, вы можете иметь список пакетов в AUR, для которых вы хотели бы получать уведомления о доступных обновлениях, даже если они не установлены. ${NC}"
echo " Вот как это работает: сам kalu содержит только GUI , а та часть, которая взаимодействует с libalpm (чтобы фактически обновить вашу систему), находится во вторичном двоичном файле ( kalu-dbus). Этот двоичный файл потребует только привилегий root и будет полагаться на PolicyKit, чтобы убедиться, что вы авторизованы, прежде чем что-либо делать. Вы также можете определить один или несколько процессов, которые будут запущены после завершения обновления системы (например, запустить localepurge (https://aur.archlinux.org/packages.php?ID=11975) и/или PkgClip (http://mywaytoarch.tumblr.com/post/16005116198/pkgclip-does-your-pacman-cache-need-a-trim)), и kalu будет запускать их после каждого успешного обновления системы (и необязательного подтверждения, которое для нескольких процессов будет содержать полный список, чтобы вы могли указать, какие из них (если таковые имеются) следует запустить). Обратите внимание: если вас это не интересует, вы можете удалить это, указав --disable-updaterв configure командной строке. " 
echo -e "${CYAN}:: ${NC}Установка Kalu (kalu) и (kalu-kde) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить Kalu (kalu),    2 - Да установить Kalu (kalu-kde),   0 - НЕТ - Пропустить установку: " in_kalu  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_kalu" =~ [^120] ]]
do
    :
done
if [[ $in_kalu == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_kalu == 1 ]]; then
  echo ""
  echo " Установка Kalu (kalu) "
sudo pacman -Syy  # обновление баз пакмэна (pacman) 
##### kalu ########
yay -S kalu --noconfirm  # Обновление уведомлений с поддержкой AUR, просмотренные (AUR) пакеты, новости ; https://aur.archlinux.org/kalu.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/Thulinma/kalu ; https://aur.archlinux.org/packages/kalu ; https://github.com/Thulinma/kalu/archive/refs/tags/4.5.2.tar.gz ; 2024-04-01 07:40 (UTC)
#git clone https://aur.archlinux.org/kalu.git   # (только для чтения, нажмите, чтобы скопировать)
#cd kalu
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf kalu 
#rm -Rf kalu
# yay -Rns kalu  # * (Необязательно) Удалите эту штуку в Arch с помощью YAY
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_kalu == 2 ]]; then
  echo ""
  echo " Установка Kalu (kalu-kde) "
sudo pacman -Syy  # обновление баз пакмэна (pacman) 
##### kalu-kde  ########
yay -S kalu-kde --noconfirm  # Обновление уведомлений с поддержкой AUR, отслеживаемых пакетов (AUR), новостей; поддержка автоматического скрытия на панели KDE Plasma ; https://aur.archlinux.org/kalu-kde.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/Thulinma/kalu ; https://aur.archlinux.org/packages/kalu-kde ; https://github.com/Thulinma/kalu/archive/refs/tags/4.5.2.tar.gz ; 2024-04-01 08:30 (UTC) ; Конфликты: с kalu; Смотрите Зависимости !
#git clone https://aur.archlinux.org/kalu-kde.git   # (только для чтения, нажмите, чтобы скопировать)
#cd kalu-kde
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf sublime-text-4 
#rm -Rf kalu-kde
# yay -Rns kalu-kde  # * (Необязательно) Удалите эту штуку в Arch с помощью YAY
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

