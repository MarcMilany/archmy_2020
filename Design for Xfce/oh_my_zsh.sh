#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя
#BROWSER="firefox"

OH_MY_ZSH_LANG="russian"  # Installer default language (Язык установки по умолчанию)

script_path=$(readlink -f ${0%/*})

umask 0022 # Определение окончательных прав доступа
# Для суперпользователя (root) umask по умолчанию равна 0022

###############################################################
### oh_my_zsh.sh  (Оболочка по умолчанию)
###
### Copyright (C) 2021 Marc Milany
###
### By: Marc Milany
### Email: 'Don't look for me 'Vkontakte', in 'Odnoklassniki' we are not present, ..
### Webpage: https://www.zsh.org/ ; https://github.com/ohmyzsh/ohmyzsh ; https://github.com/romkatv/powerlevel10k 
### Releases ArchLinux: https://www.archlinux.org/releng/releases/  
###
### Any questions, comments, or bug reports may be sent to above
### email address. Enjoy, and keep on using Arch.
###
### License (Лицензия): LGPL-3.0
###############################################################

set -e "\n${RED}Error: ${YELLOW}${*}${NC}"  # Эта команда остановит выполнение сценария после сбоя команды и будет отправлен код ошибки
 
###############################################################

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

### Execute action in chrooted environment (Выполнение действия в хромированной среде)
_chroot() {
    arch-chroot /mnt <<EOF "${1}"
EOF
}

###################################################################

### Warning (Предупреждение)
_warning_banner() {
    echo -e "${YELLOW}
   ====================== ♥ Предупреждение ======================
${NC}
Цель сценария (скрипта) - это установка (пакетов) (плагинов, тем, шрифтов, интерпретатора команд, и фреймворка) для командной оболочки UNIX в Arch Linux. 
Смысл в том, что все изменения вы делаете предварительно в самом скрипте и получаете возможность быстрой установки (пакетов), которые Вы решили установить (при условии, что Вы его изменили под себя, в противном случае скрипт установит (пакеты) прописанные изначально.
В процессе работы сценария (скрипта) Вам будут задаваться вопросы на установку того, или иного (пакета) (Смотрите пометки (справочки) и доп.иформацию в самом скрипте!) - будьте внимательными! В скрипте есть (пакеты), которые устанавливаются из 'AUR', в зависимости от вашего выбора. Остальные (пакеты) скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска необходимых служб. В любой ситуации выбор всегда за вами. Вы либо гуляете под дождем, либо просто под ним мокнете.${RED}

  ***************************** ВНИМАНИЕ! ***************************** 
${NC}
Автор не несёт ответственности за любое нанесение вреда при использовании скрипта. 
Вы используйте его на свой страх и риск, или изменяйте под свои личные нужды. 
В данный момент сценарий (скрипта) находится в процессе доработки по прописыванию устанавливаемых (пакетов), и небольшой корректировке (Воен. Внесение поправок в наводку орудий по результатам наблюдений с наблюдательных пунктов).

${BLUE}===> ******************************************************* ${NC}"
}
##########################################

### Display banner (Дисплей баннер)
_warning_banner

sleep 15
#echo -e "${MAGENTA}==> ${BOLD}Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети. ${NC}"
#echo 'Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети.'
# If you have a wireless connection, launch nmtui and connect to the network.

echo -e "${GREEN}
  <<< Начинается установка (пакетов) (плагинов, тем, шрифтов, интерпретатора команд, и фреймворка) для командной оболочки UNIX в Arch Linux >>>
${NC}"
# The installation of (packages) (plugins, themes, fonts, command interpreter, and framework) for the UNIX command shell in Arch Linux begins

echo -e "${BLUE}:: ${NC}Установка и настройка начата в $(date +%T)" 
#echo "Установка и настройка начата в $(date +%T)"
# Installation and configuration started in $(date +%T)

echo ""
echo -e "${GREEN}=> ${NC}Для проверки интернета можно пропинговать какой-либо сервис"
#echo 'Для проверки интернета можно пропинговать какой-либо сервис'
# To check the Internet, you can ping a service
ping -c2 archlinux.org

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

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить дополнительные базовые утилиты (пакеты) wget, curl, git?" 
#echo -e "${BLUE}:: ${NC}Установить дополнительные базовые утилиты (пакеты) wget, curl, git"
#echo "Установить дополнительные базовые утилиты (пакеты) wget, curl, git"
# Install additional basic utilities (packages) wget, curl, fit
echo -e "${YELLOW}==> Примечание: ${BOLD}Вы можете пропустить установку этих утилит (пакетов), если таковые были ранее вами установлены и присутствуют в систему Arch'a. Установка утилит (пакетов) проходит из 'Официальных репозиториев Arch Linux' ${NC}"
echo -e "${MAGENTA}=> ${NC}Описание утилит (пакетов) для установки:" 
echo " 1 - GNU Wget (wget) - это бесплатный программный пакет для получения файлов с использованием HTTP , HTTPS, FTP и FTPS (FTPS с версии 1.18). Это неинтерактивный инструмент командной строки, поэтому его можно легко вызвать из скриптов. "
echo " 2 - cURL (curl) - это инструмент командной строки и библиотека для передачи данных с помощью URL-адресов. Команда поддерживает ряд различных протоколов, включая HTTP, HTTPS, FTP, SCP и SFTP. Он также предназначен для работы без взаимодействия с пользователем, как в сценариях. "
echo " 3 - Git (git) - это система контроля версий (VCS), разработанная Линусом Торвальдсом, создателем ядра Linux. Git теперь используется для поддержки пакетов AUR, а также многих других проектов, включая исходные коды ядра Linux. "
echo -e "${CYAN}=> Отрывок (цитирование): ${NC}'Я встречал людей, которые думали, что git - это интерфейс для GitHub. Они ошибались, git - это интерфейс для AUR'. - Линус Т :)"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить действие: " basic_utilities  # sends right after the keypress; # отправляет сразу после нажатия клавиши    
    echo ''
    [[ "$basic_utilities" =~ [^10] ]]
do
    :
done 
if [[ $basic_utilities == 0 ]]; then 
echo ""   
echo " Установка базовых утилит (пакетов) пропущена "
elif [[ $basic_utilities == 1 ]]; then
  echo ""    
  echo " Установка Установка базовых утилит (пакетов) wget, curl, git "
# sudo pacman -S --needed base-devel git wget #curl  - пока присутствует в pkglist.x86_64
sudo pacman -S --noconfirm --needed wget curl git
# sudo pacman -S wget git --noconfirm  #curl  - пока присутствует в pkglist.x86_64
# sudo pacman -S wget --noconfirm  # Сетевая утилита для извлечения файлов из Интернета
# sudo pacman -S curl --noconfirm  # Утилита и библиотека для поиска URL
# sudo pacman -S git --noconfirm  # Быстрая распределенная система контроля версий
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#------------------------
# Справка по pacman:
# --needed         не переустанавливать актуальные пакеты
# --noconfirm      не спрашивать каких-либо подтверждений
#-------------------------------
# https://git-scm.com/
# https://archlinux.org/packages/extra/x86_64/git/
# https://www.gnu.org/software/wget/wget.html
# https://archlinux.org/packages/extra/x86_64/wget/
# https://curl.se/
# https://archlinux.org/packages/core/x86_64/curl/
#--------------------------------

##########################################

clear
echo -e "${MAGENTA}
  <<< Установка утилит (пакетов) для смены (shell) оболочки (BASH на оболочку ZSH) >>> ${NC}"






###########################################

clear
echo -e "${GREEN}
  <<< Поздравляем! Установка утилит (пакетов) оформления завершена! >>> ${NC}"
# Congratulations! The installation of the design utilities (packages) is complete!.
echo ""
echo -e "${YELLOW}==> ${NC}Желательно перезагрузить систему для применения изменений"
#echo 'Желательно перезагрузить систему для применения изменений'
# It is advisable to restart the system to apply the changes
echo -e "${BLUE}:: ${BOLD}Посмотрим дату и время ... для проверки времени ${NC}"
date  # Посмотрим дату и время без характеристик для проверки времени
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'  # одновременно отображает дату и часовой пояс

echo -e "${BLUE}:: ${BOLD}Отобразить время работы системы ... ${NC}"
uptime

echo -e "${YELLOW}==> ...${NC}"
echo -e "${GREEN}
  <<< Желаю Вам удачи во всех начинаниях, верных и точных решений! >>> ${NC}"
echo ""
echo -e "${RED}### ${BLUE}########################################################### ${RED}### ${NC}" 
echo -e "${RED}==> ${BOLD}Выходим из установленной системы ${NC}"

echo -e "${BLUE}:: ${BOLD}Теперь вам надо ввести exit, затем перезагрузить систему ${NC}"
echo ""
# echo " Установка завершена для выхода введите >> exit << "
#exit(0)  # означает чистый выход без каких-либо ошибок (проблем)
#exit(1)  # означает, что была какая-то ошибка (проблема), и именно поэтому программа выходит

############ Default shell ###########
###  Установка Zsh (если он в настоящее время не используется)
###
### zsh  # Очень продвинутый и программируемый интерпретатор команд (оболочка) для UNIX
### https://archlinux.org/packages/extra/x86_64/zsh/
### https://www.zsh.org/
###
### zsh-syntax-highlighting  # Рыбная оболочка как подсветка синтаксиса для Zsh
### https://archlinux.org/packages/community/any/zsh-syntax-highlighting/
### https://github.com/zsh-users/zsh-syntax-highlighting
### 
### zsh-autosuggestions  # Рыбоподобные самовнушения для zsh (история команд)
### https://archlinux.org/packages/community/any/zsh-autosuggestions/
### https://github.com/zsh-users/zsh-autosuggestions
###
### grml-zsh-config  # Настройка zsh в grml
### https://archlinux.org/packages/extra/any/grml-zsh-config/
### https://grml.org/zsh/
###
### zsh-completions  # Дополнительные определения завершения для Zsh
### https://archlinux.org/packages/community/any/zsh-completions/
### https://github.com/zsh-users/zsh-completions
###
### zsh-history-substring-search  # ZSH порт поиска рыбной истории (стрелка вверх)
### https://archlinux.org/packages/community/any/zsh-history-substring-search/
### https://github.com/zsh-users/zsh-history-substring-search
###
###  Установка Oh My Zsh (если он в настоящее время не используется)
###
### oh-my-zsh-git  AUR  # Фреймворк, управляемый сообществом, для управления вашей конфигурацией zsh. 
### Включает 180+ дополнительных плагинов и более 120 тем, чтобы оживить ваше утро, а также инструмент автоматического обновления, чтобы вы могли легко быть в курсе последних обновлений от сообщества
### https://aur.archlinux.org/packages/oh-my-zsh-git/
### https://aur.archlinux.org/oh-my-zsh-git.git
### https://github.com/ohmyzsh/ohmyzsh
###
### zsh-theme-powerlevel9k-git  AUR  # Тема powerlevel9k для zsh
### https://aur.archlinux.org/packages/zsh-theme-powerlevel9k-git/
### https://aur.archlinux.org/zsh-theme-powerlevel9k-git.git 
### https://github.com/bhilburn/powerlevel9k
###
### zsh-theme-powerlevel10k-git  AUR  # Powerlevel10k - это тема для Zsh. Он подчеркивает скорость, гибкость и готовность к работе
### https://aur.archlinux.org/packages/zsh-theme-powerlevel10k-git/
### https://aur.archlinux.org/zsh-theme-powerlevel10k-git.git 
### https://github.com/romkatv/powerlevel10k
###
### nerd-fonts-hack  AUR  # Тема Arc Firefox
### https://aur.archlinux.org/packages/nerd-fonts-hack/ 
### https://aur.archlinux.org/nerd-fonts-hack.git 
### https://github.com/ryanoasis/nerd-fonts 
###
######### Вот несколько крутых плагинов ###############
###
### autojump  AUR # Более быстрый способ навигации по файловой системе (по папкам) из командной строки 
### https://aur.archlinux.org/packages/autojump/
### https://aur.archlinux.org/autojump.git
### https://github.com/wting/autojump
###
### autojump  AUR # Более быстрый способ навигации по файловой системе (по папкам) из командной строки 
### https://aur.archlinux.org/packages/autojump-git/
### https://aur.archlinux.org/autojump-git.git
### http://github.com/wting/autojump
###
### ansiweather  AUR # Сценарий оболочки для отображения текущих погодных условий в вашем терминале с поддержкой цветов ANSI и символов Unicode
### https://aur.archlinux.org/packages/ansiweather/
### https://aur.archlinux.org/ansiweather.git 
### https://github.com/fcambus/ansiweather
###
######### Дополнительно ###############
###
### fast-syntax-highlighting  AUR  # Оптимизированная и расширенная подсветка синтаксиса zsh
### https://aur.archlinux.org/packages/zsh-fast-syntax-highlighting/
### https://aur.archlinux.org/zsh-fast-syntax-highlighting.git
### https://github.com/zdharma/fast-syntax-highlighting
###
### zsh-fast-syntax-highlighting-git  AUR  # Оптимизированная и расширенная подсветка синтаксиса zsh
### https://aur.archlinux.org/packages/zsh-fast-syntax-highlighting-git/
### https://aur.archlinux.org/zsh-fast-syntax-highlighting-git.git
### https://github.com/zdharma/fast-syntax-highlighting
###
### pacaur  AUR  # Помощник AUR, минимизирующий взаимодействие с пользователем 
### https://aur.archlinux.org/packages/pacaur/
### https://aur.archlinux.org/pacaur.git  
### https://github.com/E5ten/pacaur
### Последнее обновление: 2019-04-01 23:16
### 
### pacaur-git  AUR  # Помощник AUR, минимизирующий взаимодействие с пользователем 
### https://aur.archlinux.org/packages/pacaur-git/
### https://aur.archlinux.org/pacaur-git.git  
### https://github.com/E5ten/pacaur
### Последнее обновление: 2019-03-05 04:01
###
################################





#######################

Смена оболочки

echo -e "${MAGENTA}=> ${BOLD}Вот какая оболочка (shell) используется в данный момент: ${NC}"
echo $SHELL
echo "" 

Для смены оболочки на ZSH введите в терминале следующее: chsh -s /bin/zsh.

Для смены оболочки на BASH введите в терминале следующее: chsh -s /bin/bash.

echo ""
echo " Пользовательская оболочка (shell) НЕ изменена, по умолчанию остаётся BASH "
elif [[ $t_shell == 1 ]]; then
chsh -s /bin/zsh
chsh -s /bin/zsh $username
clear
echo ""
echo " Важно! При первом запуске консоли (терминала) - нажмите "0" "
echo " Пользовательская оболочка ИЗМЕНЕНА (сразу будет), с BASH на на ZSH "

################################################



echo " Установка ZSH (shell) оболочки "
pacman -S zsh zsh-syntax-highlighting zsh-autosuggestions grml-zsh-config --noconfirm
pacman -S zsh-completions zsh-history-substring-search  --noconfirm  
echo 'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> /etc/zsh/zshrc
echo 'source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> /etc/zsh/zshrc
echo 'prompt adam2' >> /etc/zsh/zshrc
clear
echo ""
echo -e "${BLUE}:: ${NC}Сменим командную оболочку пользователя с Bash на ZSH ?"
echo " Будьте внимательны! В данной опции выбор всегда остаётся за вами. "

pacman -S zsh --noconfirm  # Очень продвинутый и программируемый интерпретатор команд (оболочка) для UNIX
https://archlinux.org/packages/extra/x86_64/zsh/
https://www.zsh.org/

pacman -S zsh-syntax-highlighting --noconfirm  # Рыбная оболочка как подсветка синтаксиса для Zsh 
https://archlinux.org/packages/community/any/zsh-syntax-highlighting/
https://github.com/zsh-users/zsh-syntax-highlighting

pacman -S zsh-autosuggestions --noconfirm  # Рыбоподобные самовнушения для zsh (история команд)
https://archlinux.org/packages/community/any/zsh-autosuggestions/
https://github.com/zsh-users/zsh-autosuggestions

pacman -S grml-zsh-config --noconfirm  # Настройка zsh в grml
https://archlinux.org/packages/extra/any/grml-zsh-config/
https://grml.org/zsh/

pacman -S zsh-completions --noconfirm  # Дополнительные определения завершения для Zsh
https://archlinux.org/packages/community/any/zsh-completions/
https://github.com/zsh-users/zsh-completions

pacman -S zsh-history-substring-search --noconfirm  # ZSH порт поиска рыбной истории (стрелка вверх)
https://archlinux.org/packages/community/any/zsh-history-substring-search/
https://github.com/zsh-users/zsh-history-substring-search

#######################

yay -S fast-syntax-highlighting --noconfirm  # Оптимизированная и расширенная подсветка синтаксиса zsh
https://aur.archlinux.org/packages/zsh-fast-syntax-highlighting/
https://aur.archlinux.org/zsh-fast-syntax-highlighting.git
https://github.com/zdharma/fast-syntax-highlighting

source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

Переключение шелла на zsh: chsh -s /usr/bin/zsh, обратно на bash(при необходимости): chsh -s /usr/bin/bash.



Так же можно установить плагины от сторонних разработчиков для этого существует директория ~/.oh-my-zsh/custom/plugins. Вот несколько крутых плагинов:

yay -S autojump --noconfirm  # Плагин для быстрой навигации по файловой системе (по папкам) из командной строки
autojump  AUR # Более быстрый способ навигации по файловой системе (по папкам) из командной строки 
https://aur.archlinux.org/packages/autojump/
https://aur.archlinux.org/autojump.git
https://github.com/wting/autojump

или

yay -S autojump-git --noconfirm  # Плагин для быстрой навигации по файловой системе (по папкам) из командной строки
autojump  AUR # Более быстрый способ навигации по файловой системе (по папкам) из командной строки 
https://aur.archlinux.org/packages/autojump-git/
https://aur.archlinux.org/autojump-git.git
http://github.com/wting/autojump

yay -S autojump-git --noconfirm  # Отображает погоду прямо в терминале
ansiweather  AUR # Сценарий оболочки для отображения текущих погодных условий в вашем терминале с поддержкой цветов ANSI и символов Unicode
https://aur.archlinux.org/packages/ansiweather/
https://aur.archlinux.org/ansiweather.git 
https://github.com/fcambus/ansiweather


===================================================

Оболочка по умолчанию Постоянная ссылка
И мой выбор здесь - oh-my-zsh из-за его гибкости, настройки и системы плагинов . Вы можете делать все, что хотите .

Я тоже выбрал тему PowerLevel10k … проверьте окончательный результат:

Полнодисковое шифрование Arch Linuxoh-my-zsh настроен с помощью PowerLevel10k им.

Шаг 1 : Установите Zsh (если он в настоящее время не используется):
$ pacaur -S zsh oh-my-zsh-git
Шаг 2 : Сделайте Zsh оболочкой по умолчанию (перезапустите, чтобы изменения вступили в силу):
$ chsh -l
$ chsh -s /usr/bin/zsh
Шаг 3 : Установите и включите тему Powerlevel10k:
$ yay -S --noconfirm zsh-theme-powerlevel10k-git
$ echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
Шаг 4 : Установите Nerd Fonts Hack:
$ pacaur -S nerd-fonts-hack
Шаг 5. Переход с Bash (пропустите, если вы уже используете его):
Придется переместить часть содержимого из ваших файлов .bash_profile и .bashrc в .zshrc и .zprofile соответственно.

Шаг 6 : Это моя конфигурация темы в файле .zshrc с плагинами (скопируйте и вставьте :)):
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

export DEFAULT_USER="fernando"
export TERM="xterm-256color"
export ZSH=/usr/share/oh-my-zsh
export ZSH_POWER_LEVEL_THEME=/usr/share/zsh-theme-powerlevel10k

source $ZSH_POWER_LEVEL_THEME/powerlevel10k.zsh-theme

plugins=(archlinux 
  bundler 
  docker 
  jsontools 
  vscode web-search 
  k 
  tig 
  gitfast 
  colored-man-pages
  colorize 
  command-not-found 
  cp 
  dirhistory 
  autojump 
  sudo
  zsh-syntax-highlighting
  zsh-autosuggestions) 
# /!\ zsh-syntax-highlighting and then zsh-autosuggestions must be at the end

source $ZSH/oh-my-zsh.sh

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh
Шаг 7 : Вы также можете настроить еще больше, если перейдете к .p10k.zshфайлу, который очень хорошо документирован:
$ vim ~/.p10k.zsh
Шаг 8 : Установите шрифт в GNOME (пропустите, если не являетесь пользователем GNOME):
Установите GNOME Tweaks, если у вас есть GNOME.
Установите системный моноширинный шрифт на «Hack Nerd Font Regular» и размер, текущий + 1.
В настройках шрифта терминала я не устанавливаю флажок « Пользовательский шрифт» , т. Е. Используйте системный шрифт.
Полнодисковое шифрование Arch LinuxМоя цветовая палитра в настройках терминала.



Zsh установка и настройка
11.07.2019
Разбор конфига ~/.zshrc, конечный результат примерно такой. Рекомендую установить и использовать терминал urxvt о настройке которого я писал в прошлом посте.

Zsh

Установка zsh, oh-my-zsh, fast-syntax-highlighting, zsh-autosuggestions.
yay -S zsh oh-my-zsh fast-syntax-highlighting zsh-autosuggestions
oh-my-zsh: надстройка над zsh.
fast-syntax-highlighting: подсветка синтаксиса.
zsh-autosuggestions: автодополнение.
Переключение шелла на zsh: chsh -s /usr/bin/zsh, обратно на bash(при необходимости): chsh -s /usr/bin/bash.

Настройка.
Мой конфиг .zshrc, необходимо сохранить в домашнюю директорию ~/.zshrc, если файл существует замените.

Так как oh-my-zsh установлен через yay, то строка ZSH=/usr/share/oh-my-zsh/ идет от корня, это косается и плагинов.

Тема оформления строки приветствия задается в данной строке ZSH_THEME="af-magic". Сами темы можно выбрать тут.

Плагинов из набора oh-my-zsh полно, но я их не использую, вот тут они прописываются.

plugins=(
)
Использую только то, что установил дополнительно, путем экспорта в файл. Полный путь до .zsh файла. В зависимости от способа установки путь может отличаться, в данном случае такой.

source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
Тут задаем дерикторию кэша и условие проверки.

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
[[ ! -d $ZSH_CACHE_DIR ]] && mkdir $ZSH_CACHE_DIR
Экспорт путей со скриптами и бинарниками.

export PATH=$HOME/.bin:$HOME/.bin/popup:$HOME/.local/bin:/usr/local/bin:$PATH
Экспорт различных переменных.

export TERM="rxvt-unicode"
export EDITOR="$(if [[ -n $DISPLAY ]]; then echo 'subl3'; else echo 'nano'; fi)"
export BROWSER="chromium"
export SSH_KEY_PATH="~/.ssh/dsa_id"
export XDG_CONFIG_HOME="$HOME/.config"
Условие проверки и загрузки файла. Алиасы можно и не выносить в отдельный файл, но так удобнее.

[[ -f ~/.alias_zsh ]] && . ~/.alias_zsh
Данный блок не обязателен, отвечает за fzf поиск.

[[ -e "/usr/share/fzf/fzf-extras.zsh" ]] && source /usr/share/fzf/fzf-extras.zsh
export FZF_DEFAULT_COMMAND="fd --type file --color=always --follow --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_DEFAULT_OPTS="--ansi"
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border --preview 'file {}' --preview-window down:1"
export FZF_COMPLETION_TRIGGER="~~"
В момент набора и появления автодополнения можно перемещаться по словам Ctrl+стрелка вправо, а просто стрелка вправо прыжок в конец подсвеченной строки.

Вот собственно и все, немного пробежался по этой теме.

Видите ошибку? Отредактируйте эту страницу на GitHub.

zsh
Похожие записи:
Psiphon linux, обходим блокировку трафика 10 Aug 2020
Установка Arch Linux на зашифрованный раздел, LVM на LUKS 23 Mar 2020
Ctlos Linux Bspwm v0.1.0 13 Mar 2020
Arch Urxvt, установка и настройка 10 Jul 2019
Pulseaudio и Discord 10 Jul 2019
