#!/bin/bash
# loadkeys ru
# setfont cyr-sun16
# clear
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

MULTIMEDIA_PROG_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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

########################################
### Warning (Предупреждение)
_warning_banner() {
    echo -e "${YELLOW}
   ====================== ♥ Предупреждение ======================
${NC}
Цель сценария (скрипта) - это установка необходимого софта (пакетов) и запуск необходимых служб. 
Смысл в том, что все изменения вы делаете предварительно в самом скрипте и получаете возможность быстрой установки утилит (пакетов), которые Вы решили установить (при условии, что Вы его изменили под себя, в противном случае скрипт установит софт (пакеты) прописанный изначально.
В процессе работы сценария (скрипта) Вам будут задаваться вопросы на установку той, или иной утилиты (пакета) - будьте внимательными! Устанавливаемый софт (пакеты), шрифты - скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. Так же присутствует софт (пакеты), шрифты - устанавливаемый из пользовательского репозитория 'AUR'-'yay', собираются и устанавливаются. Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска необходимых служб. В любой ситуации выбор всегда за вами. Вы либо гуляете под дождем, либо просто под ним мокнете.${RED}

  ***************************** ВНИМАНИЕ! ***************************** 
${NC}
Автор не несёт ответственности за любое нанесение вреда при использовании скрипта. 
Вы используйте его на свой страх и риск, или изменяйте под свои личные нужды.
Будьте внимательны! Процесс установки софта (пакетов) устанавливаемого из пользовательского репозитория будет осуществляться через - 'AUR'-'yay' (здесь выбор всегда остаётся за вами - ставить или нет).  
В данный момент сценарий (скрипта) находится в процессе доработки по прописанию устанавливаемого софта (пакетов), и небольшой корректировке (Воен. Внесение поправок в наводку орудий по результатам наблюдений с наблюдательных пунктов).

${BLUE}===> ******************************************************* ${NC}"
}
########################################

### Display banner (Дисплей баннер)
_warning_banner

sleep 9
#echo -e "${MAGENTA}==> ${BOLD}Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети. ${NC}"
#echo 'Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети.'
# If you have a wireless connection, launch nmtui and connect to the network. 

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
#######################################

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
#######################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Обновить базы данных пакетов включая AUR пакеты, которые установлены в Arch, если таковые есть?"
echo -e "${YELLOW}==> Примечание: ${NC}Выберите вариант обновления баз данных пакетов, и утилит, в зависимости от установленного вами AUR Helper (yay), или пропустите обновления - (если AUR НЕ установлен)."
echo -e "${CYAN}=> ${BOLD}В сценарии скрипта присутствуют следующие варианты: ${NC}"
echo " 1 - Обновление баз данных пакетов через 'AUR'-'yay', то выбирайте вариант "1" "
echo " 2 - Установка обновлений баз данных пакетов, и утилит через 'AUR'-'yay', то выбирайте вариант "2" "
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Обновление через - AUR (Yay) (-Syy),     2 - Обновить и установить через - AUR (Yay) (-Syu),

    0 - Пропустить обновление баз данных пакетов, и утилит: " in_aur_update  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_aur_update" =~ [^120] ]]
do
    :
done
if [[ $in_aur_update == 0 ]]; then
  echo ""
  echo " Обновление баз данных пакетов, и утилит пропущено "
elif [[ $in_aur_update == 1 ]]; then
  echo ""
  echo " Обновление баз данных пакетов через - AUR (Yay) "
  yay -Syy
  echo ""
echo " Обновление базы данных выполнено "
elif [[ $in_aur_update == 2 ]]; then
  echo ""
  echo " Обновление баз данных пакетов, и утилит через - AUR (Yay) "
  yay -Syu
  echo ""
echo " Обновление баз данных пакетов, и утилит выполнено " 
fi
#######################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Создадим папку (downloads), и перейдём в созданную папку "
#echo " Создадим папку (downloads), и переходим в созданную папку "
# Create a folder (downloads), and go to the created folder
echo -e "${MAGENTA}=> ${NC}Почти весь процесс: по загрузке, сборке софта (пакетов) устанавливаемых из AUR - будет проходить в созданной папке (downloads)."
echo -e "${CYAN}:: ${NC}Если Вы захотите сохранить софт (пакеты) устанавливаемых из AUR, и в последствии создать свой маленький (пользовательский репозиторий Arch), тогда перед удалением папки (downloads) в заключении работы скрипта, скопируйте нужные вам пакеты из папки (downloads) в другую директорию."
echo -e "${YELLOW}==> Примечание: ${NC}Вы можете пропустить создание папки (downloads), тогда сборка софта (пакетов) устанавливаемых из AUR - будет проходить в папке указанной (для сборки) Pacman gui (в его настройках, если таковой был установлен), или по умолчанию в одной из системных папок (tmp;.cache;...)."
echo " В заключении работы сценария (скрипта) созданная папка (downloads) - Будет полностью удалена из домашней (home) директории! "
echo " Будьте внимательны! Вы можете пропустить это действие. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да создать папку (downloads),     0 - НЕТ - Пропустить действие: " i_folder  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_folder" =~ [^10] ]]
do
    :
done
if [[ $i_folder == 0 ]]; then
  echo ""
  echo " Создание папки (downloads) пропущено "
elif [[ $i_folder == 1 ]]; then
  echo ""
  echo " Создаём и переходим в созданную папку (downloads) "
  mkdir ~/downloads  # создание папки (downloads)
  cd ~/downloads  # перейдём в созданную папку
  echo " Посмотрим в какой директории мы находимся "
  pwd  # покажет в какой директории мы находимся
fi
sleep 01
#######################################

clear
echo ""
echo -e "${GREEN}==> ${NC}Установка пакетов Python из AUR (через - yay)"
#echo -e "${BLUE}:: ${NC}Установка пакетов Python из AUR (через - yay)"
#echo 'Установка дополнительных пакетов Python из AUR'
# Installing Python packages from AUR (through - yay)
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - Посмотрите перед установкой в скрипте!." 
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " t_pythons  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_pythons" =~ [^10] ]]
do
    :
done
if [[ $t_pythons == 0 ]]; then
echo ""  
echo " Установка пакетов Python из AUR (-yay) пропущена "
elif [[ $t_pythons == 1 ]]; then
  echo ""
echo -e " Установка базовых программ и пакетов wget, curl, git "
sudo pacman -S --noconfirm --needed wget curl git  # Сетевая утилита для извлечения файлов из Интернета, Быстрая распределенная система контроля версий, Инструмент командной строки и библиотека для передачи данных с помощью URL-адресов.
echo ""
echo " Установка дополнительных пакетов Python из AUR (через - yay) "
# Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты! 
########## Python AUR ###########
######### python2 ################ - Собирается ДОЛГО!!!
yay -S python2 --noconfirm  # Язык сценариев высокого уровня ; https://aur.archlinux.org/packages/python2 ; https://aur.archlinux.org/python2.git (только чтение, нажмите, чтобы скопировать) ; https://www.python.org/ 
######### Пример установки ################ 
######### python-basiciw ################
yay -S python-basiciw --noconfirm  # Получение информации, такой как ESSID или качество сигнала, с беспроводных карт (модуль Python) https://fontmanager.github.io https://aur.archlinux.org/packages/python-basiciw ; https://aur.archlinux.org/python-basiciw.git 
# git clone https://aur.archlinux.org/python-basiciw.git  # (только для чтения, нажмите, чтобы скопировать)
# cd python-basiciw
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf python-basiciw 
# rm -Rf python-basiciw
######### python-bencode.py ################
yay -S python-bencode.py --noconfirm  # Простой парсер бенкода (для Python 2, Python 3 и PyPy)
######### python-coincurve ################ Ошибка в build
###yay -S python-coincurve --noconfirm  # Кросс-платформенные привязки Python CFFI для libsecp256k1
######### python-d2to1 ################
yay -S python-d2to1 --noconfirm  # Библиотека Python, которая позволяет использовать файлы setup.cfg, подобные distutils2, для метаданных пакета с помощью скрипта distribute / setuptools setup.py
######### python-ewmh ################
yay -S python-ewmh --noconfirm  # Реализация EWMH (Расширенные подсказки оконного менеджера) на Python на основе Xlib
######### python-eyed3 ################
yay -S python-eyed3 --noconfirm  # Модуль Python и программа для обработки информации о файлах mp3
######### pythonqt ################
yay -S pythonqt --noconfirm  # Динамическая привязка Python для приложений Qt
######### python-merkletools ################ - СОБИРАЕТСЯ ПРИЛИЧНО ДОЛГО!!!
yay -S python-merkletools --noconfirm  # Инструменты Python для создания и проверки деревьев Меркла и доказательств 
######### python-pyelliptic ################
yay -S python-pyelliptic --noconfirm  # Оболочка Python OpenSSL для ECC (ECDSA, ECIES), AES, HMAC, Blowfish, ...
######### python-pyqt4 ################
yay -S python-pyqt4 --noconfirm  # Набор привязок Python 3.x для набора инструментов Qt
######### python-pywapi ################
yay -S python-pywapi --noconfirm  # Обертка Python вокруг Yahoo! Погода, Weather.com и API NOAA
######### python-requests-cache ################
yay -S python-requests-cache --noconfirm  # Прозрачный постоянный кеш для библиотеки
######### python-shiboken2 ################
yay -S python-shiboken2 --noconfirm  # Создает привязки для библиотек C ++ с использованием исходного кода CPython
######### python-sip ################
yay -S python-sip --noconfirm  # Привязки Python SIP4 для библиотек C и C ++ (python-sip4) 
## ИЛИ 
# yay -S python-sip4 --noconfirm  # Привязки Python SIP4 для библиотек C и C ++ (python-sip4)
######### python-sip-pyqt4 ################
yay -S python-sip-pyqt4 --noconfirm  # Привязки Python 3.x SIP для библиотек C и C ++ (версия PyQt4)
######### python-pep517 ################
yay -S python-pep517 --noconfirm  # Оболочки для сборки пакетов Python с использованием хуков PEP 517
######### python-twitter ################
yay -S python-twitter --noconfirm  # Набор инструментов API и командной строки для Twitter (twitter.com)
######### python-pulsectl ################
yay -S python-pulsectl --noconfirm  # Интерфейс высокого уровня Python и привязки на основе ctypes для PulseAudio (libpulse)
######### python3-memoizedb ################
yay -S python3-memoizedb --noconfirm  # Универсальный мемоайзер для извлечения данных, использующий базу данных SQLite для кэширования данных










########## Python2 AUR ###########
# Отсутствует!!! yay -S python2-imaging --noconfirm  # PIL. Предоставляет возможности обработки изображений для Python https://github.com/OpenMandrivaAssociation/python2-imaging
# yay -S  --noconfirm  #
# yay -S  --noconfirm  #
# yay -S  --noconfirm  #
# yay -S  --noconfirm --needed  #
########## Python AUR (Биткойн) ###########
# yay -S python-base58 --noconfirm  # Биткойн-совместимая реализация Base58 и Base58Check
# yay -S python-bitcoinlib --noconfirm  # Библиотека Python3, обеспечивающая простой интерфейс для структур данных и протокола Биткойн
# yay -S  --noconfirm  #
#######################################
pwd  # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
echo ""
echo " Установка дополнительных пакетов Python из AUR выполнена "
echo " Время точное как на Спасской башне Московского Кремля! "
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'   # одновременно отображает дату и часовой пояс
fi
##########################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Удаление созданной папки (downloads)"
#echo " Удаление созданной папки (downloads), и скрипта установки программ (font_aur) "
#echo ' Удаление созданной папки (downloads), и скрипта установки программ (font_aur) '
# Deleting the created folder (downloads) and the program installation script (font_aur)
echo -e "${YELLOW}==> Примечание: ${NC}Если таковая (папка) была создана изначально!"
# If it was created initially!
echo " Будьте внимательны! Процесс удаления, был прописан полностью автоматическим. "
# Be careful! Removal process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да удалить папку (downloads),     0 - Нет пропустить этот шаг: " rm_down  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$rm_down" =~ [^10] ]]
do
    :
done
if [[ $rm_down == 0 ]]; then
echo ""
echo " Удаление пропущено "
elif [[ $rm_down == 1 ]]; then
echo ""
echo " Удаление папки (downloads), и скрипта установки программ (archmy3l) "
sudo rm -R ~/downloads/  # Если таковая (папка) была создана изначально
# sudo rm -rf ~/font_aur  # Если скрипт не был перемещён в другую директорию
echo " Удаление выполнено "
fi

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
echo -e "${YELLOW}==> ...${NC}"
echo -e "${BLUE}:: ${NC}Если хотите установить дополнительных пакетов Python, из AUR - через (yay), тогда после перезагрузки и входа в систему выполните команду:"
echo -e "${YELLOW}==> ${CYAN}git clone https://github.com/MarcMilany/archmy_2020.git ${NC}"
echo -e "${CYAN}:: ${NC}Цель скрипта (pyton_aur) - это установка дополнительных pyton (пакетов), находящихся в AUR и которых нет в стандарных репозиториях Arch'a https://archlinux.org/packages/."
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

########## Python AUR ###########
###
### python-basiciw    AUR  # Получение информации, такой как ESSID или качество сигнала, с беспроводных карт (модуль Python)
### https://aur.archlinux.org/packages/python-basiciw/
### https://aur.archlinux.org/python-basiciw.git
### https://github.com/enkore/basiciw/
###
### python-bencode.py    AUR  # Простой парсер бенкода (для Python 2, Python 3 и PyPy)
### https://aur.archlinux.org/packages/python-bencode.py/
### https://aur.archlinux.org/python-bencode.py.git 
### https://github.com/fuzeman/bencode.py
###
### pythonqt    AUR  # Динамическая привязка Python для приложений Qt
### https://aur.archlinux.org/packages/pythonqt/
### https://aur.archlinux.org/pythonqt.git
### http://pythonqt.sourceforge.net/
###
### python-coincurve   AUR  # Кросс-платформенные привязки Python CFFI для libsecp256k1
### https://aur.archlinux.org/packages/python-coincurve/
### https://aur.archlinux.org/python-coincurve.git
### https://github.com/ofek/coincurve
###
### python-merkletools   AUR  # Инструменты Python для создания и проверки деревьев Меркла и доказательств
### https://aur.archlinux.org/packages/python-merkletools/
### https://aur.archlinux.org/python-merkletools.git 
### https://github.com/Tierion/pymerkletools
###
### python-pyparted   AUR  # Модуль Python для GNU parted
### https://aur.archlinux.org/packages/python-pyparted/
### https://aur.archlinux.org/python-pyparted.git
### https://github.com/dcantrell/pyparted
###
### python-twitter   AUR  # Набор инструментов API и командной строки для Twitter (twitter.com)
### https://aur.archlinux.org/packages/python-twitter/
### https://aur.archlinux.org/python-twitter.git 
### http://pypi.python.org/pypi/twitter/
###
### python2-imaging  AUR  # PIL. Предоставляет возможности обработки изображений для Python
### https://aur.archlinux.org/packages/python2-imaging/
### https://aur.archlinux.org/python2-imaging.git 
### http://www.pythonware.com/products/pil/index.htm
###
### python-pyelliptic  AUR  # Оболочка Python OpenSSL для ECC (ECDSA, ECIES), AES, HMAC, Blowfish, ...
### https://aur.archlinux.org/packages/python-pyelliptic/
### https://aur.archlinux.org/python-pyelliptic.git
### https://github.com/radfish/pyelliptic
###
### python-pyqt4  AUR  # Набор привязок Python 3.x для набора инструментов Qt
### https://aur.archlinux.org/packages/python-pyqt4/
### https://aur.archlinux.org/pyqt4.git
### https://riverbankcomputing.com/software/pyqt/intro
###
### python-pywapi  AUR  # Обертка Python вокруг Yahoo! Погода, Weather.com и API NOAA
### https://aur.archlinux.org/packages/python-pywapi/
### https://aur.archlinux.org/python-pywapi.git
### https://launchpad.net/python-weather-api
###
### python-requests-cache  AUR  # Прозрачный постоянный кеш для библиотеки http://python-requests.org/ 
### https://aur.archlinux.org/packages/python-requests-cache/
### https://aur.archlinux.org/python-requests-cache.git
### https://github.com/reclosedev/requests-cache
###
### python-sip-pyqt4  AUR  # Привязки Python 3.x SIP для библиотек C и C ++ (версия PyQt4)
### https://aur.archlinux.org/packages/python-sip-pyqt4/
### https://aur.archlinux.org/python-sip-pyqt4.git
### https://www.riverbankcomputing.com/software/sip/intro
###
########## Биткойн ###########
###
### python-base58   AUR  # Биткойн-совместимая реализация Base58 и Base58Check
### https://aur.archlinux.org/packages/python-base58/
### https://aur.archlinux.org/python-base58.git 
### https://github.com/keis/base58
###
### python-bitcoinlib # Библиотека Python3, обеспечивающая простой интерфейс для структур данных и протокола Биткойн
### https://www.archlinux.org/packages/community/any/python-bitcoinlib/
### https://github.com/petertodd/python-bitcoinlib
###
###############################
### end of script