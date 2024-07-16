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
  pacman -Syy  # обновление баз пакмэна (pacman)
  pacman -S --noconfirm --needed zsh zsh-syntax-highlighting zsh-autosuggestions grml-zsh-config  # Очень продвинутый и программируемый интерпретатор команд (оболочка) для UNIX; Рыбная оболочка как подсветка синтаксиса для Zsh; Рыбоподобные самовнушения для zsh (история команд); Настройка zsh в grml
  pacman -S --noconfirm --needed zsh-completions zsh-history-substring-search  # Дополнительные определения завершения для Zsh; ZSH порт поиска рыбной истории (стрелка вверх)
  #pacman -S --noconfirm --needed syntax-highlighting5  # Механизм подсветки синтаксиса для структурированного текста и кода ; https://community.kde.org/Frameworks ; https://archlinux.org/packages/extra/x86_64/syntax-highlighting5/
  echo 'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> /etc/zsh/zshrc
  echo 'source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> /etc/zsh/zshrc
# echo 'prompt adam2' >> /etc/zsh/zshrc
  echo 'prompt fire' >> /etc/zsh/zshrc
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
pacman -Syy  # обновление баз пакмэна (pacman)
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
  cd /home/$username
  git clone https://aur.archlinux.org/gitstatus-bin.git
  chown -R $username:users /home/$username/gitstatus-bin
  chown -R $username:users /home/$username/gitstatus-bin/PKGBUILD
  cd /home/$username/gitstatus-bin
  sudo -u $username  makepkg -si --noconfirm
#  sudo -u $username  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
  rm -Rf /home/$username/gitstatus-bin
### Для тех, кто хочет использовать gitstatus без темы, есть gitstatus.prompt.zsh . Установите его следующим образом:
# git clone --depth=1 https://github.com/romkatv/gitstatus.git ~/gitstatus
# echo 'source ~/gitstatus/gitstatus.prompt.zsh' >>! ~/.zshrc
echo " gitstatus.git успешно добавлен в установлен "
echo ""
echo " Установка Oh My Zsh! "
##### oh-my-zsh-git ######  
# yay -S oh-my-zsh-git --noconfirm --needed  # Фреймворк, управляемый сообществом, для управления вашей конфигурацией zsh. Включает более 180 дополнительных плагинов и более 120 тем, чтобы оживить ваше утро, а также инструмент автоматического обновления, который позволяет легко быть в курсе последних обновлений от сообщества ; https://aur.archlinux.org/oh-my-zsh-git.git (только для чтения, нажмите, чтобы скопировать); https://github.com/ohmyzsh/ohmyzsh ; https://aur.archlinux.org/packages/oh-my-zsh-git
  cd /home/$username
  git clone https://aur.archlinux.org/oh-my-zsh-git.git
  chown -R $username:users /home/$username/oh-my-zsh-git
  chown -R $username:users /home/$username/oh-my-zsh-git/PKGBUILD
  cd /home/$username/oh-my-zsh-git
  sudo -u $username  makepkg -si --noconfirm
#  sudo -u $username  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
  rm -Rf /home/$username/oh-my-zsh-git
##### zsh-autosuggestions-git ######
# yay -S zsh-autosuggestions-git --noconfirm --needed  # Рыбоподобные автопредложения для zsh (из git) zsh-автопредложения ; https://aur.archlinux.org/zsh-autosuggestions-git.git (только для чтения, нажмите, чтобы скопировать); https://github.com/zsh-users/zsh-autosuggestions ; https://aur.archlinux.org/packages/zsh-autosuggestions-git
# git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
#  cd /home/$username
#  git clone https://aur.archlinux.org/zsh-autosuggestions-git.git
#  chown -R $username:users /home/$username/zsh-autosuggestions-git
#  chown -R $username:users /home/$username/zsh-autosuggestions-git/PKGBUILD
#  cd /home/$username/zsh-autosuggestions-git
#  sudo -u $username  makepkg -si --noconfirm
#  sudo -u $username  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
#  rm -Rf /home/$username/zsh-autosuggestions-git
##### zsh-fast-syntax-highlighting ######
# yay -S zsh-fast-syntax-highlighting --noconfirm --needed  # Оптимизированная и расширенная подсветка синтаксиса zsh ; https://aur.archlinux.org/zsh-fast-syntax-highlighting.git (только для чтения, нажмите, чтобы скопировать); https://github.com/zdharma-continuum/fast-syntax-highlighting ; https://aur.archlinux.org/packages/zsh-fast-syntax-highlighting
# yay -S zsh-fast-syntax-highlighting-git --noconfirm --needed  # Оптимизированная и расширенная подсветка синтаксиса zsh ; https://aur.archlinux.org/zsh-fast-syntax-highlighting-git.git (только для чтения, нажмите, чтобы скопировать); https://github.com/zdharma-continuum/fast-syntax-highlighting ; https://aur.archlinux.org/packages/zsh-fast-syntax-highlighting-git
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
  cd /home/$username
  git clone https://aur.archlinux.org/zsh-fast-syntax-highlighting.git 
  chown -R $username:users /home/$username/zsh-fast-syntax-highlighting
  chown -R $username:users /home/$username/zsh-fast-syntax-highlighting/PKGBUILD
  cd /home/$username/zsh-fast-syntax-highlighting
  sudo -u $username  makepkg -si --noconfirm
#  sudo -u $username  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
  rm -Rf /home/$username/zsh-fast-syntax-highlighting
### yay -Rns oh-my-zsh-git  
##### ttf-meslo-nerd-font-powerlevel10k ######
### Что касается шрифта, я нашел один, который является эквивалентом "ttf-meslo-nerd-font-powerlevel10k", то есть ttf-meslo-nerd 
  pacman -S --noconfirm --needed ttf-meslo-nerd  # Исправленный шрифт Meslo LG из библиотеки шрифтов nerd ; https://github.com/ryanoasis/nerd-fonts ; https://archlinux.org/packages/extra/any/ttf-meslo-nerd/
  pacman -S --noconfirm --needed powerline-fonts  # исправленные шрифты для powerline ; https://github.com/powerline/powerline ; https://archlinux.org/packages/extra/x86_64/powerline-fonts/
  pacman -S --noconfirm --needed python-powerline  # библиотека python для powerline ; https://github.com/powerline/powerline ; https://archlinux.org/packages/extra/x86_64/python-powerline/
  pacman -S --noconfirm --needed powerline  # Плагин Statusline для vim, а также предоставляет строки состояния и подсказки для нескольких других приложений, включая zsh, bash, tmux, IPython, Awesome, i3 и Qtile ; https://github.com/powerline/powerline ; https://archlinux.org/packages/extra/x86_64/powerline/
# yay -S ttf-meslo-nerd-font-powerlevel10k --noconfirm --needed  # Шрифт Meslo Nerd исправлен для Powerlevel10k ; https://aur.archlinux.org/ttf-meslo-nerd-font-powerlevel10k.git (только для чтения, нажмите, чтобы скопировать); https://github.com/romkatv/powerlevel10k-media ; https://aur.archlinux.org/packages/ttf-meslo-nerd-font-powerlevel10k
  cd /home/$username
  git clone https://aur.archlinux.org/ttf-meslo-nerd-font-powerlevel10k.git 
  chown -R $username:users /home/$username/ttf-meslo-nerd-font-powerlevel10k
  chown -R $username:users /home/$username/ttf-meslo-nerd-font-powerlevel10k/PKGBUILD
  cd /home/$username/ttf-meslo-nerd-font-powerlevel10k
  sudo -u $username  makepkg -si --noconfirm
#  sudo -u $username  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
  rm -Rf /home/$username/ttf-meslo-nerd-font-powerlevel10k

##### zsh-theme-powerlevel10k-git ######
# yay -S zsh-theme-powerlevel10k-git --noconfirm --needed  # Powerlevel10k — тема для Zsh. Она делает акцент на скорости, гибкости и нестандартном опыте ; https://aur.archlinux.org/zsh-theme-powerlevel10k-git.git (только для чтения, нажмите, чтобы скопировать); https://github.com/romkatv/powerlevel10k ; https://aur.archlinux.org/packages/zsh-theme-powerlevel10k-git
# git clone https://github.com/bhilburn/powerlevel9k.git $ZSH_CUSTOM/themes/powerlevel9k
  cd /home/$username
  git clone https://aur.archlinux.org/zsh-theme-powerlevel10k-git.git 
  chown -R $username:users /home/$username/zsh-theme-powerlevel10k-git
  chown -R $username:users /home/$username/zsh-theme-powerlevel10k-git/PKGBUILD
  cd /home/$username/zsh-theme-powerlevel10k-git
  sudo -u $username  makepkg -si --noconfirm
#  sudo -u $username  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
  rm -Rf /home/$username/zsh-theme-powerlevel10k-git
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

