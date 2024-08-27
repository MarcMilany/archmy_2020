#!/usr/bin/env bash
# Install script DupeGuru
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

DupeGuru_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
echo -e "${GREEN}==> ${NC}Установить DupeGuru (пакет dupeguru) - для поиска и удаления дубликатов файлов в системе?"
# Install dupeGuru (dupeguru package) - to find and delete duplicate files in the system?
echo -e "${MAGENTA}=> ${BOLD}DupeGuru - это кроссплатформенный (Linux, OS X, Windows) инструмент с графическим интерфейсом для поиска дубликатов файлов в системе. Он написан в основном на Python 3 и имеет особенность использования нескольких наборов инструментов GUI, все из которых используют один и тот же основной код Python. В Linux и Windows он написан на Python и использует Qt5. Он может сканировать как имена файлов, так и их содержимое. Сканирование имен файлов использует алгоритм нечеткого соответствия, который может находить дубликаты имен файлов, даже если они не совсем одинаковы. dupeGuru работает на Mac OS X и Linux. ${NC}"
echo -e "${YELLOW}:: ${NC}Особенности: dupeGuru хорош в музыке. У него есть специальный музыкальный режим, который может сканировать теги и отображать информацию, связанную с музыкой, в окне результатов дубликатов. dupeGuru хорош в работе с картинками. У него есть специальный режим «Изображение», который может сканировать картинки нечетко , позволяя вам находить похожие, но не совсем одинаковые картинки. (😃) "
echo " Функции: Вы можете настроить его движок сопоставления, чтобы найти именно тот тип дубликатов, который вы хотите найти. На странице «Настройки» файла справки перечислены все настройки движка сканирования, которые вы можете изменить. Его движок был специально разработан с учетом безопасности. Его система каталогов ссылок, а также его система группировки не позволяют вам удалять файлы, которые вы не хотели удалять. "
echo -e "${CYAN}:: ${NC}Делайте с вашими дубликатами все, что хотите. Вы можете не только удалять файлы-дубликаты, которые находит dupeGuru, но и перемещать или копировать их в другое место. Существует также несколько способов фильтрации и сортировки результатов, чтобы легко отсеивать ложные дубликаты (для сканирования с низким порогом). Поддерживаемые языки: английский, французский, немецкий, китайский (упрощенный), чешский, итальянский, армянский, русский, украинский, бразильский, вьетнамский."
echo " Лицензия: GPL-3.0 ; Домашняя страница: ( https://dupeguru.voltaicideas.net/). Подробная документация доступна по адресу: (https://aur.archlinux.org/packages/dupeguru ; https://aur.archlinux.org/dupeguru.git)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_dupeguru  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_dupeguru" =~ [^10] ]]
do
    :
done
if [[ $i_dupeguru == 0 ]]; then
echo ""
echo " Установка Dupeguru пропущена "
elif [[ $i_dupeguru == 1 ]]; then
  echo ""
  echo " Установка Dupeguru (удаления дубликатов) "
############## python-polib ############### 
yay -S python-polib --noconfirm  # Библиотека для работы с файлами gettext ; https://aur.archlinux.org/python-polib.git (только для чтения, нажмите, чтобы скопировать) ; https://pypi.python.org/pypi/polib ; https://aur.archlinux.org/packages/python-polib
#git clone https://aur.archlinux.org/python-polib.git
# cd ~/python-polib  # Перейдите в папку ~/python-polib и установите его
#cd python-polib
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf python-polib
#rm -Rf python-polib   # удаляем директорию сборки 
############## dupeguru ###############
yay -S dupeguru --noconfirm   # Найдите дубликаты файлов с различным содержимым, используя Perceptual Diff для изображений ; https://aur.archlinux.org/dupeguru.git (только для чтения, нажмите, чтобы скопировать) ; https://dupeguru.voltaicideas.net/ ; https://aur.archlinux.org/packages/dupeguru ; 
#git clone https://aur.archlinux.org/dupeguru.git
# cd ~/dupeguru  # Перейдите в папку ~/dupeguru и установите его
#cd dupeguru
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf dupeguru
#rm -Rf dupeguru   # удаляем директорию сборки 
###################
echo ""
echo " Установка Dupeguru выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
########## Справка #################
# Конфликты: dupeguru-git, dupeguru-me, dupeguru-pe, dupeguru-se
####################################
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

