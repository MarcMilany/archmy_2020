#!/usr/bin/env bash
# Install script zsh_theme
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

ZSH_THEMELANG="russian"  # Installer default language (Язык установки по умолчанию)

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
  echo " Установка дополнительных утилит (пакетов) zsh-theme "
sudo pacman -S --noconfirm --needed mercurial  # (необязательно) – поддержка статуса ветки Mercurial ; Масштабируемый распределенный инструмент SCM ; https://archlinux.org/packages/extra/x86_64/mercurial/ ; https://www.mercurial-scm.org/ ; 2025-08-04 21:46 UTC
# sudo pacman -S --noconfirm --needed tk  # (необязательно) - для графического интерфейса hgk ; Набор инструментов для работы с окнами, используемый с tcl ; Набор инструментов для работы с окнами, используемый с tcl ; http://tcl.sourceforge.net/ ; 2024-12-25 10:40 UTC
yay -S zsh-theme-minimal --noconfirm  # #Минимальная и расширяемая тема Zsh ; https://aur.archlinux.org/packages/zsh-theme-minimal ; https://aur.archlinux.org/zsh-theme-minimal.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/subnixr/minimal ; https://github.com/subnixr/minimal/archive/1.0.4.tar.gz ; 2020-05-05 17:42 (UTC)
########## zsh-theme-minimal ##########
#git clone https://aur.archlinux.org/zsh-theme-minimal.git  # (только для чтения, нажмите, чтобы скопировать)
#cd zsh-theme-minimal
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf zsh-theme-minimal
#rm -Rf zsh-theme-minimal
### Установка zsh-theme-minimal Руководство:
# Получите копию minimal.zsh и источник, например:
# curl -O ~/minimal.zsh https://raw.githubusercontent.com/subnixr/minimal/master/minimal.zsh
# source ~/minimal.zsh
# Minimal по сути представляет собой набор компонентов (функций оболочки) поверх тонкого слоя для облегчения настройки.
########################################
########## zsh-komander ##########
yay -S zsh-komander --noconfirm  # Минималистичная zsh-тема... ; https://aur.archlinux.org/packages/zsh-komander ; https://aur.archlinux.org/zsh-komander.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/stikundra-murtsi/zsh-komander ; https://aur.archlinux.org/cgit/aur.git/tree/zsh-komander.zsh?h=zsh-komander ; https://aur.archlinux.org/cgit/aur.git/tree/ ; komander-tool.sh?h=zsh-komander ; 2025-08-03 09:33 (UTC)
########## zsh-komander ##########
#git clone https://aur.archlinux.org/zsh-komander.git  # (только для чтения, нажмите, чтобы скопировать)
#cd zsh-komander
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf zsh-komander
#rm -Rf zsh-komander
### zsh-komander Это минималистичная zsh тема, она не пихает тебе в лицо всякие `user@pc ~$ _` которы раздражают глаз, вместо этого просто `> _` как в старых терминалах <3
# При этом дает полную защиту от случайного попадания твоего имени пользователя и пк при съемке видео с терминалом, пока ты конечно сам не сделаешь так чтоб оно выводилось.
# А вывод пользователя, пк и дериктории где ты находишься можно с помощью сочитаний клавиш:
# Alt+Z - Показать имя пользователя `user > _`
# Alt+X - Показать имя компьютера `pcname > _`
# Alt+C - Показать дерикторию где ты сейчас находишься `/home/user/ > _`
# v1p1 - Я поправил баг с отображением дериктории нахождения, имени пользователи и компьютера.
# 1.3 - Появился фирменный инструмент `zsh-komander`: `komander`. Или же официально: `komander-tool.sh`.
########################################
########## oh-my-zsh-theme-via ##########
yay -S oh-my-zsh-theme-via --noconfirm  # Историческая тема ZSH, используемая на серверах VIA Centrale Réseaux ; https://aur.archlinux.org/packages/oh-my-zsh-theme-via ; https://aur.archlinux.org/oh-my-zsh-theme-via.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/zsh-users/zsh-autosuggestions ; https://github.com/badouralix/oh-my-via/archive/refs/tags/v1.3.0.tar.gz ; 2023-05-28 01:20 (UTC)
########## oh-my-zsh-theme-via ##########
#git clone https://aur.archlinux.org/oh-my-zsh-theme-via.git  # (только для чтения, нажмите, чтобы скопировать)
#cd oh-my-zsh-theme-via
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf oh-my-zsh-theme-via
#rm -Rf oh-my-zsh-theme-via
#######################################
########## magic-af #############
# https://github.com/jordanhatcher/magic-af.git
# https://github.com/andyfleming/oh-my-zsh/blob/master/themes/af-magic.zsh-theme
#################################
# Шаг 2: Сделайте Zsh оболочкой по умолчанию (перезагрузите систему, чтобы изменения оболочки вступили в силу)
# chsh -l
# chsh -s /usr/bin/zsh
# Шаг 3: Установите тему Powerlevel9k
# sudo git clone https://github.com/jordanhatcher/magic-af.git /usr/share/oh-my-zsh/themes/magic-af
###################################
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