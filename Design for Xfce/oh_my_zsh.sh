#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 
apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2024.07.31.00.40.38 (GPLv3)"
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
############# Справка по pacman ###################
# --needed         не переустанавливать актуальные пакеты
# --noconfirm      не спрашивать каких-либо подтверждений
#-------------------------------
# https://git-scm.com/
# https://archlinux.org/packages/extra/x86_64/git/
# https://www.gnu.org/software/wget/wget.html
# https://archlinux.org/packages/extra/x86_64/wget/
# https://curl.se/
# https://archlinux.org/packages/core/x86_64/curl/
##########################################

clear
echo -e "${MAGENTA}
  <<< Установка shell (командной оболочки) по умолчанию в Archlinux >>> ${NC}"
echo ""
echo -e "${YELLOW}==> Примечание: ${NC}Сейчас Вы можете установить zsh (такой же, как и в установочном образе Archlinux) или оставить Bash по умолчанию, просто пропустите установку."
echo ""
echo -e "${GREEN}==> ${NC}Установка ZSH (bourne shell) командной оболочки"
echo -e "${CYAN}:: ${NC}Z shell, zsh - является мощной, одной из современных командных оболочек, которая работает как в интерактивном режиме, так и в качестве интерпретатора языка сценариев (скриптовый интерпретатор)."
echo " Он совместим с bash (не по умолчанию, только в режиме emulate sh), но имеет преимущества, такие как улучшенное завершение и подстановка. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo -e "${MAGENTA}=> ${BOLD}Вот какая оболочка (shell) используется в данный момент: ${NC}"
echo ""
echo $SHELL
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить zsh,     0 - НЕТ - Пропустить установку (bash по умолчанию): " x_shell  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_shell" =~ [^10] ]]
do
    :
done
if [[ $x_shell == 0 ]]; then
  clear
  echo ""
  echo " Оболочка (shell) НЕ изменена, по умолчанию остаётся Bash! "
elif [[ $x_shell == 1 ]]; then
  clear
  echo ""
  echo " Установка ZSH (shell) оболочки "
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
  sudo pacman -S --noconfirm --needed zsh zsh-syntax-highlighting zsh-autosuggestions grml-zsh-config  # Очень продвинутый и программируемый интерпретатор команд (оболочка) для UNIX; Рыбная оболочка как подсветка синтаксиса для Zsh; Рыбоподобные самовнушения для zsh (история команд); Настройка zsh в grml
  sudo pacman -S --noconfirm --needed zsh-completions zsh-history-substring-search  # Дополнительные определения завершения для Zsh; ZSH порт поиска рыбной истории (стрелка вверх)
  #pacman -S --noconfirm --needed syntax-highlighting5  # Механизм подсветки синтаксиса для структурированного текста и кода ; https://community.kde.org/Frameworks ; https://archlinux.org/packages/extra/x86_64/syntax-highlighting5/
  sudo echo 'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> /etc/zsh/zshrc
  sudo echo 'source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> /etc/zsh/zshrc
# echo 'prompt adam2' >> /etc/zsh/zshrc
  sudo echo 'prompt fire' >> /etc/zsh/zshrc
  echo ""
  echo " Установка shell (командной оболочки) ZSH Выполнена! "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установим Oh My Zsh - пакет (oh-my-zsh-git) и Powerlevel10k - пакет (zsh-theme-powerlevel10k-git) тема для Zsh, а также несколько плагинов, библиотек и шрифтов из AUR (Arch User Repository)?"
echo " Zsh - одна из современных командных оболочек UNIX, использующаяся непосредственно как интерактивная оболочка, либо как скриптовый интерпретатор. Zsh не использует readline для ввода команд пользователем. Вместо этого используется собственный редактор ZLE (Zsh Line Editor). Oh My Zsh — это восхитительный, открытый исходный код, поддерживаемый сообществом фреймворк для управления конфигурацией Zsh. фреймворк Oh My Zsh, который вы надеюсь установите, далее позволит настраивать ее и кастомизировать с помощью тем и плагинов. "
echo " Powerlevel10k — это тема для ZSH, гибкая и в то же время простая в плане настройки терминальной темы, которая меняет обычные команды оболочки на красочные команды. Чтобы установить powerlevel10k, нужно установить Oh My Zsh. Оба инструмента имеют открытый исходный код на GitHub. Также можно использовать шрифт nerd, чтобы сделать шрифт темы powerlevel10k более красивым. После обновления powerlevel9k до powerlevel10k настроить тему стало легче. "
echo -e "${YELLOW}=> Примечание: ${BOLD}Обратите внимание, что это изменение не мгновенное, и вам нужно будет выйти из системы и снова войти в нее, чтобы оно вступило в силу. После этого снова проверьте переменную окружения SHELL, чтобы подтвердить изменение: echo $SHELL . ${NC}"
echo " Плагины (необязательно, но желательно иметь!) - Будет установлено: zsh-syntax-highlighting - Позволяет подсвечивать команды, пока они вводятся в приглашении zsh в интерактивном терминале. Это помогает просматривать команды перед их запуском, особенно при обнаружении синтаксических ошибок. zsh-autosuggestions — предлагает команды по мере ввода на основе истории и завершений. "
echo -e "${YELLOW}==> ${NC}Будьте внимательны! Если Вы сомневаетесь в своих действиях, просто пропустите этот пункт."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить Oh My Zsh,     0 - НЕТ - Пропустить установку: " i_ohmyzsh  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_ohmyzsh" =~ [^10] ]]
do
    :
done
if [[ $i_ohmyzsh == 0 ]]; then
echo ""
echo " Установка пропущена "
elif [[ $i_ohmyzsh == 1 ]]; then
echo ""
echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# yay -Syy  # обновление баз (Yay)
################# Другой способ установки ####################
### pack=(
### oh-my-zsh-git zsh-autosuggestions
### zsh-fast-syntax-highlighting gitstatus-bin
#### ttf-meslo-nerd-font-powerlevel10k 
### zsh-theme-powerlevel10k-git
### )
### yay -Sy --noconfirm --needed ${pack[@]}
####################
echo ""
echo -e "${BLUE}:: ${NC}Добавим в систему GitStatus - Состояние Git для команд Bash и Zsh "
echo " gitstatus — это в 10 раз более быстрая альтернатива git status и git describe. Его основное применение — включение быстрого приглашения git в интерактивных оболочках. "
##### gitstatus-bin ######
# yay -S gitstatus-bin --noconfirm --needed  # Состояние Git для команд Bash и Zsh ; https://aur.archlinux.org/gitstatus-bin.git (только для чтения, нажмите, чтобы скопировать); https://github.com/romkatv/gitstatus ; https://aur.archlinux.org/packages/gitstatus-bin
### gitstatus — это в 10 раз более быстрая альтернатива git statusи git describe. Его основное применение — включение быстрого приглашения git в интерактивных оболочках.
git clone https://aur.archlinux.org/gitstatus-bin.git
cd gitstatus-bin
makepkg -si --noconfirm
# makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gitstatus-bin
rm -Rf gitstatus-bin
### Для тех, кто хочет использовать gitstatus без темы, есть gitstatus.prompt.zsh . Установите его следующим образом:
# git clone --depth=1 https://github.com/romkatv/gitstatus.git ~/gitstatus
# echo 'source ~/gitstatus/gitstatus.prompt.zsh' >>! ~/.zshrc
echo " gitstatus.git успешно добавлен в установлен "
echo ""
echo " Установка Oh My Zsh! "
##### oh-my-zsh-git ######  
# yay -S oh-my-zsh-git --noconfirm --needed  # Фреймворк, управляемый сообществом, для управления вашей конфигурацией zsh. Включает более 180 дополнительных плагинов и более 120 тем, чтобы оживить ваше утро, а также инструмент автоматического обновления, который позволяет легко быть в курсе последних обновлений от сообщества ; https://aur.archlinux.org/oh-my-zsh-git.git (только для чтения, нажмите, чтобы скопировать); https://github.com/ohmyzsh/ohmyzsh ; https://aur.archlinux.org/packages/oh-my-zsh-git
git clone https://aur.archlinux.org/oh-my-zsh-git.git
cd oh-my-zsh-git
makepkg -si --noconfirm
# makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf oh-my-zsh-git
rm -Rf oh-my-zsh-git
##### zsh-autosuggestions-git ######
# yay -S zsh-autosuggestions-git --noconfirm --needed  # Рыбоподобные автопредложения для zsh (из git) zsh-автопредложения ; https://aur.archlinux.org/zsh-autosuggestions-git.git (только для чтения, нажмите, чтобы скопировать); https://github.com/zsh-users/zsh-autosuggestions ; https://aur.archlinux.org/packages/zsh-autosuggestions-git
# git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
#  cd /home/$username
# git clone https://aur.archlinux.org/zsh-autosuggestions-git.git
# cd zsh-autosuggestions-git
# makepkg -si --noconfirm
#  makepkg -fsri --noconfirm
#  makepkg --noconfirm --needed -sic
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
#  rm -rf zsh-autosuggestions-git
# rm -Rf zsh-autosuggestions-git
##### zsh-fast-syntax-highlighting ######
# yay -S zsh-fast-syntax-highlighting --noconfirm --needed  # Оптимизированная и расширенная подсветка синтаксиса zsh ; https://aur.archlinux.org/zsh-fast-syntax-highlighting.git (только для чтения, нажмите, чтобы скопировать); https://github.com/zdharma-continuum/fast-syntax-highlighting ; https://aur.archlinux.org/packages/zsh-fast-syntax-highlighting
# yay -S zsh-fast-syntax-highlighting-git --noconfirm --needed  # Оптимизированная и расширенная подсветка синтаксиса zsh ; https://aur.archlinux.org/zsh-fast-syntax-highlighting-git.git (только для чтения, нажмите, чтобы скопировать); https://github.com/zdharma-continuum/fast-syntax-highlighting ; https://aur.archlinux.org/packages/zsh-fast-syntax-highlighting-git
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://aur.archlinux.org/zsh-fast-syntax-highlighting.git 
cd zsh-fast-syntax-highlighting
makepkg -si --noconfirm
#  makepkg -fsri --noconfirm
#  makepkg --noconfirm --needed -sic
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
#  rm -rf zsh-fast-syntax-highlighting
rm -Rf zsh-fast-syntax-highlighting
### yay -Rns oh-my-zsh-git  
##### ttf-meslo-nerd-font-powerlevel10k ######
### Что касается шрифта, я нашел один, который является эквивалентом "ttf-meslo-nerd-font-powerlevel10k", то есть ttf-meslo-nerd 
  sudo pacman -S --noconfirm --needed ttf-meslo-nerd  # Исправленный шрифт Meslo LG из библиотеки шрифтов nerd ; https://github.com/ryanoasis/nerd-fonts ; https://archlinux.org/packages/extra/any/ttf-meslo-nerd/
  sudo pacman -S --noconfirm --needed powerline-fonts  # исправленные шрифты для powerline ; https://github.com/powerline/powerline ; https://archlinux.org/packages/extra/x86_64/powerline-fonts/
  sudo pacman -S --noconfirm --needed python-powerline  # библиотека python для powerline ; https://github.com/powerline/powerline ; https://archlinux.org/packages/extra/x86_64/python-powerline/
  sudo pacman -S --noconfirm --needed powerline  # Плагин Statusline для vim, а также предоставляет строки состояния и подсказки для нескольких других приложений, включая zsh, bash, tmux, IPython, Awesome, i3 и Qtile ; https://github.com/powerline/powerline ; https://archlinux.org/packages/extra/x86_64/powerline/
  sudo pacman -S --noconfirm --needed awesome-terminal-fonts  # шрифты/значки для линий электропередач ; https://github.com/gabrielelana/awesome-terminal-fonts ; https://archlinux.org/packages/extra/any/awesome-terminal-fonts/
# yay -S ttf-meslo-nerd-font-powerlevel10k --noconfirm --needed  # Шрифт Meslo Nerd исправлен для Powerlevel10k ; https://aur.archlinux.org/ttf-meslo-nerd-font-powerlevel10k.git (только для чтения, нажмите, чтобы скопировать); https://github.com/romkatv/powerlevel10k-media ; https://aur.archlinux.org/packages/ttf-meslo-nerd-font-powerlevel10k
git clone https://aur.archlinux.org/ttf-meslo-nerd-font-powerlevel10k.git 
cd ttf-meslo-nerd-font-powerlevel10k
makepkg -si --noconfirm
#  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
#  rm -rf ttf-meslo-nerd-font-powerlevel10k
rm -Rf ttf-meslo-nerd-font-powerlevel10k
##### zsh-theme-powerlevel10k-git ######
# yay -S zsh-theme-powerlevel10k-git --noconfirm --needed  # Powerlevel10k — тема для Zsh. Она делает акцент на скорости, гибкости и нестандартном опыте ; https://aur.archlinux.org/zsh-theme-powerlevel10k-git.git (только для чтения, нажмите, чтобы скопировать); https://github.com/romkatv/powerlevel10k ; https://aur.archlinux.org/packages/zsh-theme-powerlevel10k-git
# git clone https://github.com/bhilburn/powerlevel9k.git $ZSH_CUSTOM/themes/powerlevel9k
git clone https://aur.archlinux.org/zsh-theme-powerlevel10k-git.git 
cd zsh-theme-powerlevel10k-git
makepkg -si --noconfirm
#  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
#  rm -rf zsh-theme-powerlevel10k-git
rm -Rf zsh-theme-powerlevel10k-git
fi  
### yay -Rns oh-my-zsh-git  # УДАЛЕНИЕ Oh My Zsh!
########################## 

  clear
  echo ""
  echo -e "${BLUE}:: ${NC}Сменим командную оболочку пользователя с Bash на ZSH ?"
  echo -e "${YELLOW}=> Важно! ${BOLD}Если Вы сменили пользовательскую оболочку, то при первом запуске консоли (терминала) - нажмите 0 (ноль), и пользовательская оболочка (сразу будет) ИЗМЕНЕНА, с BASH на ZSH. ${NC}"
  echo " Будьте внимательны! В данной опции выбор всегда остаётся за вами. "
  echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да сменить оболочку пользователя,     0 - НЕТ - Пока оставить (bash): " t_shell  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_shell" =~ [^10] ]]
do
    :
done
if [[ $t_shell == 0 ]]; then
  clear
  echo ""
  echo " Пользовательская оболочка (shell) НЕ изменена, по умолчанию остаётся BASH "
elif [[ $t_shell == 1 ]]; then
  chsh -s /bin/zsh
  chsh -s /bin/zsh $username
  clear
  echo ""
  echo " Важно! При первом запуске консоли (терминала) - нажмите "0" "
  echo " Пользовательская оболочка ИЗМЕНЕНА (сразу будет), с BASH на ZSH "
fi
############ Справка ####################
# Какая оболочка (shell) используется в данный момент: echo $SHELL
# Чтобы просмотреть список установленных оболочек, используйте команду chsh: chsh -l
# https://aur.archlinux.org/zsh-fast-syntax-highlighting-git.git (только для чтения, нажмите, чтобы скопировать) ; 
# https://github.com/zdharma-continuum/fast-syntax-highlighting ; 
# https://aur.archlinux.org/packages/zsh-fast-syntax-highlighting-git
#########################################
sleep03

  clear
  echo ""
  echo -e "${BLUE}:: ${NC}Пропишем Расширенную конфигурацию alias (псевдоним) в командной оболочке пользователя для ZSH ?"
  echo -e "${YELLOW}=> Важно! ${BOLD}Если Вы сменили пользовательскую оболочку, то при первом запуске консоли (терминала) - нажмите 0 (ноль), и пользовательская оболочка (сразу будет) ИЗМЕНЕНА, с BASH на ZSH. ${NC}"
  echo " Будьте внимательны! В данной опции выбор всегда остаётся за вами. "
  echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да прописать конфигурацию alias,     0 - НЕТ - Пока оставить (по умолчанию): " t_alias  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_alias" =~ [^10] ]]
do
    :
done
if [[ $t_alias == 0 ]]; then
  clear
  echo ""
  echo " Конфигурация для ZSH Останется по умолчанию "
elif [[ $t_alias == 1 ]]; then
echo " Создать файл .alias_zsh в ~/ (home_user) "
touch ~/.alias_zsh   # Создать файл в ~/.alias_zsh
cat > ~/.alias_zsh <<EOF
#!/usr/bin/zsh

# cat molot-tora.mp4 eraz.zip > data.mp4
# unzip date.mp4

# git.io custom url
# curl -i https://git.io -F "url=https://github.com/creio" -F "code=YOUR_CUSTOM_NAME"

alias sz="source $HOME/.zshrc"
alias ez="$EDITOR $HOME/.zshrc"
alias ea="$EDITOR $HOME/.alias_zsh"
alias merge="xrdb -merge $HOME/.Xresources"
alias xcolor="xrdb -query | grep"
alias vga="lspci -k | grep -A 2 -E '(VGA|3D)'"
alias upgrub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias updir="LC_ALL=C xdg-user-dirs-update --force"

alias dmrun="dmenu_run -l 10 -p 'app>' -fn 'ClearSansMedium 9' -nb '#282c37' -nf '#f2f3f4' -sb '#5a74ca' -sf '#fff'"

alias iip="curl --max-time 10 -w '\n' http://ident.me"
alias tb="nc termbin.com 9999"
alias tbc="nc termbin.com 9999 | xsel -b -i"
alias speed="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -"

doiso() {
  rsync -auvCL ~/ctlosiso/out/ cretm@${dev_ctlos_ru}:~/app/dev.ctlos.ru/iso/$1
}

# blur img: blur 4 .wall/wl3.jpg blur.jpg
blur() {
  convert -filter Gaussian -blur 0x$1 $2 $3
}

tbg() {
  urxvt -bg '[0]red' -b 0 -depth 32 +sb -name urxvt_bg &
}

# fzf
zzh() {
  du -a ~/ | awk '{print $2}' | fzf | xargs -r $EDITOR
}
zz() {
  du -a . | awk '{print $2}' | fzf | xargs -r $EDITOR
}
zzd() {
  du -a $1 | awk '{print $2}' | fzf | xargs -r $EDITOR
}
zzb() {
  find -H "/usr/bin" "$HOME/.bin" -executable -print | sed -e 's=.*/==g' | fzf | sh
}

# зависимость source-highlight
hcat () {
  /usr/bin/src-hilite-lesspipe.sh "$1" | less -m -N
}
ccat () {
  cat "$1" | xsel -b -i
}

# share vbox В локальной машине mkdir vboxshare
# в виртуалке uid={имя пользователя} git={группа}
vboxshare () {
  [[ ! -d ~/vboxshare ]] && mkdir -p ~/vboxshare
  sudo mount -t vboxsf -o rw,uid=1000,gid=985 vboxshare vboxshare
  # sudo mount -t vboxsf -o rw,uid=st,gid=users vboxshare vboxshare
}
# share qemu
vmshare () {
  [[ ! -d ~/vmshare ]] && mkdir -p ~/vmshare
  sudo mount -t 9p -o trans=virtio,version=9p2000.L host0 vmshare
}

# aur pkg
amake () {
  git clone https://aur.archlinux.org/"$1".git
  # curl -fO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz
  cd $1
  makepkg -s
  # makepkg -s --sign
  cd ..
}

# aur clean chroot manager
accm () {
  git clone https://aur.archlinux.org/"$2".git
  # curl -fO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz
  # tar -xvf $1.tar.gz
  cd $2
  sudo ccm "$1" &&
  gpg --detach-sign "$2"-*.pkg*
  cd ..
}

# pkg clean chroot manager
lccm () {
  sudo ccm "$1" &&
  gpg --detach-sign *.pkg*
}

aget () {
  git clone https://aur.archlinux.org/"$1".git
  # curl -fO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz
  # tar -xvf $1.tar.gz
  cd $1
}

# build and install pkg from aur
abuild () {
  cd ~/.build
  git clone https://aur.archlinux.org/"$1".git
  # curl -fO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz
  # tar -xvf $1.tar.gz
  cd $1
  makepkg -si --skipinteg
  cd ~
  # rm -rf ~/.build/$1 ~/.build/$1.tar.gz
  rm -rf ~/.build/$1
}


alias neofetch="neofetch --ascii ~/.config/neofetch/ctlos"
alias neoa="neofetch --ascii ~/.config/neofetch/mario"
alias neo="neofetch --w3m ~/.config/neofetch/cnr.png"
# alias neo="neofetch --kitty ~/.config/neofetch/cn.jpg"
# alias neo="neofetch --w3m"

# Погода, не только по городу, но и по месту. Нет привязки к регистру и языку.
# alias wtr="curl 'wttr.in/Москва?M&lang=ru'"
# alias wtr="curl 'wttr.in/Москва?M&lang=ru' | sed -n '1,17p'"
# alias wtr="curl 'wttr.in/?M1npQ&lang=ru'"
wtr () {
  # curl "wttr.in/?M$1npQ&lang=ru"
  curl "wttr.in/Moscow?M$1npQ&lang=ru"
}
wts () {
  curl "wttr.in/$1?M&lang=ru"
}
alias moon="curl 'wttr.in/Moon'"

alias srm="sudo rm -rfv"
alias rm="rm -rfv"
brm () {
  /bin/bash -c "yes | rm -rfv $1"{.\*\,\*}
}
sbrm () {
  sudo /bin/bash -c "yes | rm -rfv $1"{.\*\,\*}
}

alias dir="dir --color=auto"
alias vdir="vdir --color=auto"
alias grep="grep --color=always"
#alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

alias ls="ls --color=auto"
alias la="ls -alFh --color=auto"
alias llp="stat -c '%A %a %n' {*,.*}"
alias ll="ls -a --color=auto"
alias l="ls -CF --color=auto"
alias .l="dirs -v"
alias lss="ls -sh | sort -h"
alias duh="du -d 1 -h | sort -h"

alias mk="mkdir"
mkj () {
  mkdir -p "$1"
  cd "$1"
}

alias /="cd /"
alias ~="cd ~"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias q="exit"
alias gh="cd /media/files/github"
alias dot="cd /media/files/github/creio/dots"

function gc () {
  git clone "$1"
}

function gcj () {
  git clone "$1"
  cd "$2"
  # $EDITOR .
}
alias gi="git init"
alias gs="git status"
alias gl="git log --stat --pretty=oneline --graph --date=short"
# alias gg="gitg &"
alias ga="git add --all"
gac () {
  git add --all
  git commit -am "$1"
}
alias gr="git remote"
alias gf="git fetch"
alias gpl="git pull"
alias gp="git push"
alias gpm="git push origin master"
# yarn global add github-search-repos-cli
# alias gsc="github-search-repos -i"

# tor chromium
alias torc="$BROWSER --proxy-server='socks://127.0.0.1:9050' &"
alias psi="$BROWSER --proxy-server='socks://127.0.0.1:1081' &"

# full screen flags -fs
alias yt="straw-viewer"
ytv () {
  straw-viewer "$1"
}

# youtube-dl --ignore-errors -o '~/Видео/youtube/%(playlist)s/%(title)s.%(ext)s' https://www.youtube.com/playlist?list=PL-UzghgfytJQV-JCEtyuttutudMk7
# Загрузка Видео ~/Videos или ~/Видео
# Пример: dlv https://www.youtube.com/watch?v=gBAfejjUQoA
dlv () {
  youtube-dl --ignore-errors -o '~/Videos/youtube/%(title)s.%(ext)s' "$1"
}
# dlp https://www.youtube.com/playlist?list=PL-UzghgfytJQV-JCEtyuttutudMk7
dlp () {
  youtube-dl --ignore-errors -o '~/Videos/youtube/%(playlist)s/%(title)s.%(ext)s' "$1"
}

# Загрузка аудио ~/Music или ~/Музыка
# Пример: mp3 https://www.youtube.com/watch?v=gBAfejjUQoA
mp3 () {
  youtube-dl --ignore-errors -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o '~/Music/youtube/%(title)s.%(ext)s' "$1"
}
# mp3p https://www.youtube.com/watch?v=-F7A24f6gNc&list=RD-F7A24f6gNc
mp3p () {
  youtube-dl --ignore-errors -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o '~/Music/youtube/%(playlist)s/%(title)s.%(ext)s' "$1"
}

alias porn="mpv 'http://www.pornhub.com/random'"

alias mvis="ncmpcpp -S visualizer"
alias m="ncmpcpp"

pf () {
  peerflix "$1" --mpv
}
alias rss="newsboat"
# download web site
wgetw () {
  wget -rkx "$1"
}
iso () {
  sudo dd bs=4M if="$1" of=/dev/"$2" status=progress && sync
}

alias -s {mp3,m4a,flac,mp4,mkv,webm}="mpv"
alias -s {png,jpg,tiff,bmp,gif}="viewnior"
# alias -s {conf,txt}="nvim"
# alias {aurman,pikaur,trizen,yaourt}="yay"

alias mi="micro"
alias smi="sudo micro"
alias s="subl3"
alias ss="sudo subl3"
alias tm="tmux attach || tmux new -s work"
alias tmd="tmux detach"
alias tmk="tmux kill-server"
alias rr="ranger"
alias srr="sudo ranger"
alias h="htop"
# alias {v,vi,vim}="nvim"

# LANG=C pacman -Sl | awk '/\[installed\]$/ {print $2}' > ~/.pkglist.txt
# LANG=C pacman -Sl | awk '/\[installed\]$/ {print $1 "/" $2 "-" $3}' > ~/.pkglist.txt
# alias mirftu='pacman-mirrors --fasttrack 10 && pacman -Syyu'
alias pkglist="pacman -Qneq > ~/.pkglist.txt"
alias aurlist="pacman -Qmeq > ~/.aurlist.txt"

alias packey="sudo pacman-key --init && sudo pacman-key --populate && sudo pacman-key --refresh-keys --keyserver hkps://keyserver.ubuntu.com && sudo pacman -Syy"
alias y="yay -S"
alias yn="yay -S --noconfirm"
alias yl="yay -S --noconfirm --needed - < ~/.pkglist.txt"
alias ys="yay"
alias ysn="yay --noconfirm"
alias yo="yay -S --overwrite='*'"
alias yU="yay -U"
alias yUo="yay -U --overwrite='*'"
alias yc="yay -Sc"
alias ycc="yay -Scc"
alias yy="yay -Syy"
alias yu="yay -Syyu"
alias yun="yay -Syyu --noconfirm"
alias yr="yay -R"
alias yrs="yay -Rs"
alias yrsn="yay -Rsn"
alias yrn="yay -R --noconfirm"
alias ynskip='yay --noconfirm --mflags "--nocheck --skipchecksums --skippgpcheck"'
alias ygpg='yay --noconfirm --gpgflags "--keyserver keys.gnupg.net"'

# alias pres="sudo pacman -S $(pacman -Qqn)"
# alias yrsnp="yay -Rsn $(pacman -Qdtq)"
# alias yal="yay -S --noconfirm --needed $(cat ~/.aurlist.txt)"
# pacman -Qqo /usr/lib/python3.9/



# распаковать архив не указывая тип распаковщика
function ex {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Использование: ex <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f "$1" ] ; then
        NAME=${1%.*}
        #mkdir $NAME && cd $NAME
        case "$1" in
          *.tar.bz2)   tar xvjf ./"$1"    ;;
          *.tar.gz)    tar xvzf ./"$1"    ;;
          *.tar.xz)    tar xvJf ./"$1"    ;;
          *.lzma)      unlzma ./"$1"      ;;
          *.bz2)       bunzip2 ./"$1"     ;;
          *.rar)       unrar x -ad ./"$1" ;;
          *.gz)        gunzip ./"$1"      ;;
          *.tar)       tar xvf ./"$1"     ;;
          *.tbz2)      tar xvjf ./"$1"    ;;
          *.tgz)       tar xvzf ./"$1"    ;;
          *.zip)       unzip ./"$1"       ;;
          *.Z)         uncompress ./"$1"  ;;
          *.7z)        7z x ./"$1"        ;;
          *.xz)        unxz ./"$1"        ;;
          *.exe)       cabextract ./"$1"  ;;
          *)           echo "ex: '$1' - Не может быть распакован" ;;
        esac
    else
        echo "'$1' - не является допустимым файлом"
    fi
fi
}

# Упаковка в архив командой pk 7z /что/мы/пакуем имя_файла.7z
function pk () {
  if [ $1 ] ; then
    case $1 in
      tbz)       tar cjvf $2.tar.bz2 $2      ;;
      tgz)       tar czvf $2.tar.gz  $2       ;;
      txz)       tar -caf $2.tar.xz  $2       ;;
      tar)       tar cpvf $2.tar  $2       ;;
      bz2)       bzip $2 ;;
      gz)        gzip -c -9 -n $2 > $2.gz ;;
      zip)       zip -r $2.zip $2   ;;
      7z)        7z a $2.7z $2    ;;
      *)         echo "'$1' не может быть упакован с помощью pk()" ;;
    esac
  else
    echo "'$1' не является допустимым файлом"
  fi
}

EOF
#########
echo " Сделайте файл .alias_zsh исполняемым "
sudo chmod a+x ~/.alias_zsh
  clear
  echo ""
  echo " Важно! При первом запуске консоли (терминала) - нажмите "0" "
  echo " Пользовательская оболочка ИЗМЕНЕНА (сразу будет), с BASH на ZSH "
fi

  clear
  echo ""
  echo -e "${BLUE}:: ${NC}Сменим Конфигурация ArchLinux zsh-shell и тема для ZSH ?"
  echo " magic-af — это тема zsh, основанная на теме af-magic, с несколькими пользовательскими изменениями, основанными на теме avit. По сути, изменения просто заставляют тему af-magic лучше сочетаться с цветовой схемой моего терминала и цветами "ls" / tab complete. (https://github.com/jordanhatcher/magic-af) "
  echo -e "${YELLOW}=> Важно! ${BOLD}Если Вы сменили пользовательскую оболочку, то при первом запуске консоли (терминала) - нажмите 0 (ноль), и пользовательская оболочка (сразу будет) ИЗМЕНЕНА, с BASH на ZSH. ${NC}"
  echo " Будьте внимательны! В данной опции выбор всегда остаётся за вами. "
  echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да сменить оболочку пользователя,     0 - НЕТ - Пока оставить (bash): " t_shell  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_shell" =~ [^10] ]]
do
    :
done
if [[ $t_shell == 0 ]]; then
  clear
  echo ""
  echo " Пользовательская оболочка (shell) НЕ изменена "
elif [[ $t_shell == 1 ]]; then
echo " Переименовываем исходный файл ~/.zshrc в ~/.zshrc.original " 
mv ~/.zshrc  ~/.zshrc.original   # Переименовываем исходный файл
echo " Создать файл .zshrc в ~/ (home_user) "
touch ~/.zshrc   # Создать файл в ~/.zshrc
# ln -s -f ~/the/correct/path/zshrc ~/.zshrc
cat > ~/.zshrc <<EOF
#!/usr/bin/sh

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx &> /dev/null

# zmodload zsh/zprof

export PATH=$HOME/.bin:$HOME/.config/rofi/scripts:$HOME/.local/bin:/usr/local/bin:$PATH

export HISTFILE=~/.zhistory
export HISTSIZE=10000
export SAVEHIST=10000

# autoload -Uz compinit
# for dump in ~/.zcompdump(N.mh+24); do
#   compinit
# done
# compinit -C

# ohmyzsh
export ZSH="/usr/share/oh-my-zsh"
ZSH_THEME="af-magic"
DISABLE_AUTO_UPDATE="true"
ZSH_DISABLE_COMPFIX=true
plugins=()
ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
[[ ! -d $ZSH_CACHE_DIR ]] && mkdir -p $ZSH_CACHE_DIR
source $ZSH/oh-my-zsh.sh
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=white"

# fzf & fd
[[ -e "/usr/share/fzf/fzf-extras.zsh" ]] && source /usr/share/fzf/fzf-extras.zsh
export FZF_DEFAULT_COMMAND="fd --type file --color=always --follow --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_DEFAULT_OPTS="--ansi"
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border --preview 'file {}' --preview-window down:1"
export FZF_COMPLETION_TRIGGER="~~"

# tilix set
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi

export TERM="xterm-256color"
export EDITOR="$([[ -n $DISPLAY && $(command -v subl3) ]] && echo 'subl3' || echo 'nano')"
export BROWSER="firefox"
export XDG_CONFIG_HOME="$HOME/.config"
export _JAVA_AWT_WM_NONREPARENTING=1

# export PF_INFO="ascii os kernel wm shell pkgs memory palette"
# export PF_ASCII="arch"

# export MANPAGER="sh -c 'sed -e s/.\\\\x08//g | bat -l man -p'"

[[ -f ~/.alias_zsh ]] && . ~/.alias_zsh

# export PATH=$HOME/.gem/ruby/2.7.0/bin:$PATH
# export PATH="$PATH:`yarn global bin`"

# export GOPATH=$HOME/.go
# export GOBIN=$GOPATH/bin
# export PATH="$PATH:$GOBIN"

# export PATH=$HOME/opt/diode:$PATH

# zprof

EOF
###############
echo " Сделайте файл .zshrc исполняемым "
sudo chmod a+x ~/.zshrc
echo " Для начала сделаем его бэкап  ~/.zshrc "
cp ~/.zshrc  ~/.zshrc.back
 echo " Просмотреть содержимое файла ~/.zshrc "
#ls -l ~/.zshrc   # ls — выводит список папок и файлов в текущей директории
cat ~/.zshrc  # cat читает данные из файла или стандартного ввода и выводит их на экран
#sleep 3
  echo ""
  echo " Важно! При первом запуске консоли (терминала) - нажмите "0" "
  echo " Пользовательская оболочка ИЗМЕНЕНА (сразу будет), с BASH на ZSH "
fi

clear
echo -e "${GREEN}
  <<< Поздравляем! Установка утилит (пакетов) оболочки ZSH завершена! >>> ${NC}"
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
### zsh-theme-powerlevel10k  # Powerlevel10k - это тема для Zsh. Он подчеркивает скорость, гибкость и готовность к работе. (https://github.com/romkatv/powerlevel10k)
### https://archlinux.org/packages/community/x86_64/zsh-theme-powerlevel10k/
### https://github.com/romkatv/powerlevel10k
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
### nerd-fonts-noto-sans-mono  # Стандартные варианты Noto Sans Mono с исправлениями Nerd Fonts.
### https://aur.archlinux.org/packages/nerd-fonts-noto-sans-mono/
### https://aur.archlinux.org/nerd-fonts-noto-sans-mono.git 
### https://github.com/ryanoasis/nerd-fonts
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

### Arch-007 Конфигурация ArchLinux zsh-shell и тема powerlevel9k  ###
# https://russianblogs.com/article/9991842760/

# 1. Установите zsh
# yay -Sy zsh
# 2. Установите oh-my-zsh
# sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# 3. Переключите оболочку по умолчанию на zsh.
# chsh -s /bin/zsh
# 4. Установите подключаемый модуль автозаполнения команд zsh.
# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
# 5. Установите подключаемый модуль для цветного отображения выделения.
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
# 6. Установите тему powerlevel9k
# git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
# 7: установить значок шрифта
# yay -Sy awesome-terminal-fonts
# 8: скопируйте следующий текст в ~ / .zshrc
# Но перед копированием вам необходимо изменить
# export ZSH="/home/archlinux/.oh-my-zsh"
# Archlinux в означает, что имя пользователя изменено на ваше собственное имя пользователя
# Содержимое файла .zshrc выглядит следующим образом
##################
#!/usr/bin/sh

export TERM="xterm-256color"
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/archlinux/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
POWERLEVEL9K_MODE='awesome-fontconfig'
ZSH_THEME="powerlevel9k/powerlevel9k"
#ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)


source $ZSH/oh-my-zsh.sh
source ~/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# ==== Theme Settings ====
# PowerLevel9k
# Следующая переменная представляет содержимое, отображаемое в крайнем левом приглашении.По умолчанию используется `% n @% m`, то есть ваше имя пользователя и имя терминала. 
POWERLEVEL9K_CONTEXT_TEMPLATE="%n@%m"
 # Элементы, отображаемые в левом столбце (по указанным ключевым словам см. Официальный сайт)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon context dir vcs dir_writable)
 # Элементы показаны в правом столбце
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time virtualenv)
 # Новая команда вывода строки старта (рекомендуется! Очень удобно)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
 # Строка состояния справа находится в той же строке, что и команда
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
 # Показать, можете ли вы читать и писать значок разрешения
POWERLEVEL9K_DIR_SHOW_WRITABLE=true
 # Укорочение иерархии каталогов
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
 # Стратегия короткого каталога: скрыть слова в середине верхнего каталога
#POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
 # Добавьте стрелки соединения вверх и вниз для облегчения просмотра
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="↱"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="↳ "
 # Новая команда отделяется от приведенной выше одной строкой
#POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
 # Цветовое обозначение статуса склада Git
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='orange'
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='red'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='yellow'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='black'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='red'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='black'

POWERLEVEL9K_TIME_FOREGROUND='red' 
POWERLEVEL9K_TIME_BACKGROUND='green'


#color{{{
autoload colors
colors

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
eval _$color='%{$terminfo[bold]$fg[${(L)color}]%}'
eval $color='%{$fg[${(L)color}]%}'
(( count = $count + 1 ))
done
FINISH="%{$terminfo[sgr0]%}"
#}}}


 # Подсказка команды
#RPROMPT=$(echo "$RED%D %T$FINISH")
#PROMPT=$(echo "$CYAN%n@$YELLOW%M:$GREEN%/$_YELLOW>$FINISH ")


#PROMPT=$(echo "$BLUE%M$GREEN%/
#$CYAN%n@$BLUE%M:$GREEN%/$_YELLOW>>>$FINISH ")
 # Панель заголовков, стиль панели задач {{{
case $TERM in (*xterm*|*rxvt*|(dt|k|E)term)
precmd () { print -Pn "\e]0;%n@%M//%/\a" }
preexec () { print -Pn "\e]0;%n@%M//%/\ $1\a" }
;;
esac
#}}}

 # О конфигурации исторических записей {{{
 # Номер записи в истории
export HISTSIZE=10000
 # Количество записей в истории, сохраненных после выхода из системы
export SAVEHIST=10000
 # Исторические файлы
export HISTFILE=~/.zhistory
 # Добавить исторические записи
setopt INC_APPEND_HISTORY
 # Если последовательные команды ввода одинаковы, только одна будет сохранена в записи истории
setopt HIST_IGNORE_DUPS
 # Добавляем метку времени к команде в истории
setopt EXTENDED_HISTORY

 # Включить историю команды cd, cd - [TAB], чтобы ввести путь к истории
setopt AUTO_PUSHD
 # Один и тот же исторический путь сохранил только один
setopt PUSHD_IGNORE_DUPS

 # Добавьте пробел перед командой, не добавляйте эту команду в файл записи
#setopt HIST_IGNORE_SPACE
#}}}

 # Completion {{{
 # Меню завершения цвета
eval $(dircolors -b)
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

 # Правильный регистр
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
 #Исправление ошибки
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

 # завершение команды kill
compdef pkill=kill
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'

 # Группа подсказок полного типа
#zstyle ':completion:*:matches' group 'yes'
#zstyle ':completion:*' group-name ''
#zstyle ':completion:*:options' description 'yes'
#zstyle ':completion:*:options' auto-description '%d'
#zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
#zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
#zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
#zstyle ':completion:*:corrections' format $'\e[01;32m -- %d (errors: %e) --\e[0m'

 # cd ~ порядок завершения
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
#}}}


 ## Режим выделения строки редактирования {{{
 # Ctrl + @ Установить маркер, область между маркером и точкой курсора
 zle_highlight = (region: bg = magenta # выбранный регион
 special: жирный # Специальные символы
 isearch: underline) # Ключевые слова, используемые при поиске
#}}}

 ## Пустая строка (курсор находится в начале строки) заполнить "cd" {{{
user-complete(){
case $BUFFER in
 "") # Заполните пустую строку с "cd"
BUFFER="cd "
zle end-of-line
zle expand-or-complete
;;
 "cd -") # "cd -" заменено на "cd +"
BUFFER="cd +"
zle end-of-line
zle expand-or-complete
;;
 "cd + -") # "cd + -" заменяется на "cd -"
BUFFER="cd -"
zle end-of-line
zle expand-or-complete
;;
* )
zle expand-or-complete
;;
esac
}
zle -N user-complete
bindkey "\t" user-complete
#}}}



 #Command alias {{{
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ls='ls -F --color=auto'
alias ll='ls -l --color=auto'
alias grep='grep --color=auto'
alias la='ls -a'
alias pacman='pacman --color=auto'
alias yay='yay --color=auto'
#}}}


 # Красивый и практичный интерфейс выделения команд
setopt extended_glob
TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'do' 'time' 'strace')

#
#recolor-cmd() {
#region_highlight=()
#colorize=true
#start_pos=0
#for arg in ${(z)BUFFER}; do
#((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]## #}}))
#((end_pos=$start_pos+${#arg}))
#if $colorize; then
#colorize=false
#res=$(LC_ALL=C builtin type $arg 2>/dev/null)
#case $res in
#*'reserved word'*)   style="fg=magenta,bold";;
#*'alias for'*)       style="fg=cyan,bold";;
#*'shell builtin'*)   style="fg=yellow,bold";;
#*'shell function'*)  style='fg=green,bold';;
#*"$arg is"*)
#[[ $arg = 'sudo' ]] && style="fg=red,bold" || style="fg=blue,bold";;
#*)                   style='none,bold';;
#esac
#region_highlight+=("$start_pos $end_pos $style")
#fi
#[[ ${${TOKENS_FOLLOWED_BY_COMMANDS[(r)${arg//|/\|}]}:+yes} = 'yes' ]] && colorize=true
#start_pos=$end_pos
#done
#}
#check-cmd-self-insert() { zle .self-insert && recolor-cmd }
#check-cmd-backward-delete-char() { zle .backward-delete-char && recolor-cmd }
#
#zle -N self-insert check-cmd-self-insert
#zle -N backward-delete-char check-cmd-backward-delete-char

export PATH="/opt/nvim-linux64/bin:$PATH"
export PATH="/root/.gem/ruby/2.6.0/bin:$PATH"

#export http_proxy="127.0.0.1:12333"
#export https_proxy="127.0.0.1:12333"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


##############
