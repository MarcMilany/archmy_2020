#!/usr/bin/env bash
# Install script GtkHash
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

GtkHash_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
echo -e "${BLUE}:: ${NC}Установить GtkHash (для вычисления дайджестов сообщений или контрольных сумм)?" 
echo -e "${CYAN}:: Предисловие! ${NC}Утилита GTK+ для вычисления дайджестов сообщений или контрольных сумм. "
echo -e "${MAGENTA}:: ${BOLD}GtkHash - это настольная утилита для вычисления дайджестов сообщений или контрольных сумм. Поддерживаются большинство известных хеш-функций, включая MD5, SHA1, SHA2 (SHA256/SHA512), SHA3 и BLAKE2. ${NC}"
echo -e "${MAGENTA}=> ${NC}GtkHash - устанавливается из пользовательского репозитория 'AUR'-'yay' (https://aur.archlinux.org/gtkhash.git), собираются и устанавливаются. (😃) "
echo " Он разработан как простая в использовании графическая альтернатива инструментам командной строки, таким как md5sum. " 
echo -e "${YELLOW}:: Примечание! ${NC}Функции: Поддержка проверки контрольных сумм файлов с помощью sfv, sha256sum и т. д.. Ключевое хеширование (HMAC); Параллельный/многопоточный расчет хэша; Удаленный доступ к файлам с использованием GIO/GVfs; Интеграция файлового менеджера; Маленький и быстрый. GtkHash является свободным программным обеспечением: вы можете распространять его и/или изменять в соответствии с условиями GNU General Public License, опубликованной Free Software Foundation, либо версии 2 Лицензии, либо (по вашему выбору) любой более поздней версии. "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить GtkHash,     2 - Да установить GtkHash-Thunar,    0 - НЕТ - Пропустить установку: " i_gtkhash  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_gtkhash" =~ [^120] ]]
do
    :
done 
if [[ $i_gtkhash == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_gtkhash == 1 ]]; then
  echo ""  
  echo " Установка GtkHash "
####### gtkhash ##########  
yay -S gtkhash --noconfirm  # Утилита GTK+ для вычисления дайджестов сообщений или контрольных сумм ; https://aur.archlinux.org/gtkhash.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/tristanheaven/gtkhash ; https://aur.archlinux.org/packages/gtkhash 
#git clone https://aur.archlinux.org/gtkhash.git   # (только для чтения, нажмите, чтобы скопировать) https://aur.archlinux.org/packages/gtkhash
#cd gtkhash
#makepkg -fsri  
#makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)  
#rm -Rf gtkhash  # удаляем директорию сборки
# rm -rf gtkhash
echo ""   
echo " Установка утилит (пакетов) выполнена "
elif [[ $i_gtkhash == 1 ]]; then
  echo ""  
  echo " Установка GtkHash-Thunar "
  echo " Конфликты: с gtkhash, gtkhash-caja, gtkhash-nautilus, gtkhash-nemo "
####### gtkhash-thunar ########## 
yay -S gtkhash-thunar --noconfirm  # Утилита GTK+ для вычисления дайджестов сообщений или контрольных сумм (Gtkhash с плагином файлового менеджера Thunar) ; https://aur.archlinux.org/gtkhash-thunar.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/tristanheaven/gtkhash ; https://aur.archlinux.org/packages/gtkhash-thunar ; Конфликты: с gtkhash, gtkhash-caja, gtkhash-nautilus, gtkhash-nemo
#git clone https://aur.archlinux.org/gtkhash-thunar.git   # (только для чтения, нажмите, чтобы скопировать) https://aur.archlinux.org/packages/gtkhash
#cd gtkhash-thunar
#makepkg -fsri  
#makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)  
#rm -Rf gtkhash-thunar  # удаляем директорию сборки
# rm -rf gtkhash-thunar
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
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

