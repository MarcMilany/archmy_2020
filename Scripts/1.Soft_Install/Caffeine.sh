#!/usr/bin/env bash
# Install script Caffeine
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

Caffeine_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
echo -e "${GREEN}==> ${NC}Установить Caffeine (пакет caffeine-ng) - не дает заставке появляться или системе переходить в спящий режим при просмотре видео (фильмов) или (youtube)?"
# Install Caffeine (caffeine-ng package) - does not allow the screensaver to appear or the system to go into sleep mode when watching videos (movies) or (youtube)?
echo -e "${MAGENTA}=> ${BOLD}Caffeine (caffeine-ng) - это маленький демон, который сидит в вашем системном трее и не дает заставке появляться или системе переходить в спящий режим. Он делает это, когда приложение разворачивается на весь экран (например, youtube) или когда вы нажимаете на значок в системном трее (что вы можете сделать, например, когда читаете). ${NC}"
echo -e "${YELLOW}:: ${NC}Особенности: у Caffeine имеется также пользовательский интерфейс - Caffeine indicator, после активации которого из меню приложений, в системном трее отображается значок программы, с возможностью активациии/деактивации утилиты вручную. (😃) "
echo " Функции: Ручное управление Caffeine необходимо в том случае, когда вы хотите отключить срабатывание экранной заставки в обычном режиме системы, т.е. не обязательно при просмотре видео. "
echo -e "${CYAN}:: ${NC}Caffeing-ng (с 2014 года) начинался как ответвление [Caffeine 2.4], поскольку в оригинальной версии отказались от поддержки значка в системном трее в пользу автоматического определения только полноэкранных приложений, что оказалось довольно спорным решением. Цель этого форка — развиваться самостоятельно, не только исправляя проблемы, но и реализуя отсутствующие функции, когда это необходимо. Конфликты: caffeine, caffeine-bzr, caffeine-oneclick, caffeine-systray ."
echo " Лицензия: GNU GPL3; Домашняя страница: (https://codeberg.org/WhyNotHugo/caffeine-ng). Подробная документация доступна по адресу: (https://aur.archlinux.org/packages/caffeine-ng ; https://aur.archlinux.org/caffeine-ng.git)"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_caffeine  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_caffeine" =~ [^10] ]]
do
    :
done
if [[ $i_caffeine == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_caffeine == 1 ]]; then
  echo ""
  echo " Установка Caffeine (caffeine-ng) "
########### python-ewmh ###############
yay -S python-ewmh --noconfirm  # Реализация EWMH (Расширенные подсказки оконного менеджера) на Python ; https://aur.archlinux.org/python-ewmh.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/parkouss/pyewmh/ ; https://aur.archlinux.org/packages/python-ewmh 
#git clone https://aur.archlinux.org/python-ewmh.git
#cd python-ewmh
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf python-ewmh
#rm -Rf python-ewmh   # удаляем директорию сборки
########### python-pulsectl ###############
yay -S python-pulsectl --noconfirm  # Интерфейс высокого уровня Python и привязки на основе ctypes для PulseAudio (libpulse) ; https://aur.archlinux.org/python-pulsectl.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/mk-fg/python-pulse-control ; https://aur.archlinux.org/packages/python-pulsectl
#git clone https://aur.archlinux.org/python-pulsectl.git
#cd python-pulsectl
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf python-pulsectl
#rm -Rf python-pulsectl   # удаляем директорию сборки
########### caffeine-ng ###############
yay -S caffeine-ng --noconfirm  # Приложение строки состояния способно временно блокировать заставку и спящий режим ; https://aur.archlinux.org/caffeine-ng.git (только для чтения, нажмите, чтобы скопировать) ; https://codeberg.org/WhyNotHugo/caffeine-ng ; https://aur.archlinux.org/packages/caffeine-ng
#git clone https://aur.archlinux.org/caffeine-ng.git
#cd caffeine-ng
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf caffeine-ng
#rm -Rf caffeine-ng   # удаляем директорию сборки
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
###################
# sudo pacman -S --noconfirm --needed gnome-shell-extension-caffeine  # Расширение для GNOME Shell для отключения заставки и автоматического перехода в режим ожидания ; https://github.com/eonpatapon/gnome-shell-extension-caffeine ; https://archlinux.org/packages/extra/any/gnome-shell-extension-caffeine/
# Страница руководства в настоящее время находится в usr/share/man/man1/caffeine/caffeine.1.gz. Правильное местоположение должно быть в usr/share/man/man1/caffeine.1.gz.
# При использовании man-dbпакета возвращается сообщение «Нет ручного ввода для кофеина» при man caffeineвыполнении.
###################
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

