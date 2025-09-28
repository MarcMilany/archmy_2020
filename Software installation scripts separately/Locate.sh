#!/bin/bash
# loadkeys ru
# setfont cyr-sun16
# clear
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v2.4 LegasyBIOS - Version: 2024.07.31.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

STEAM_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
echo -e "${MAGENTA}
  <<< Установка утилит (пакетов) для поиска файлов и запуска приложений в Archlinux >>> ${NC}"
# Installing utilities (packages) to search for files and launch applications in Archlinux
echo "" 
echo -e "${BLUE}:: ${NC}Установить инструменты Unix Locate (findutils ; mlocate ; plocate) (утилита для поиска файлов)?" 
echo -e "${MAGENTA}:: ${BOLD}Locate — это распространенный инструмент Unix для быстрого поиска файлов по имени. Он обеспечивает повышение скорости по сравнению с инструментом поиска , выполняя поиск в предварительно созданном файле базы данных, а не в файловой системе напрямую. Недостатком этого подхода является то, что изменения, внесенные с момента создания файла базы данных, не могут быть обнаружены locate. Эту проблему можно минимизировать с помощью запланированных обновлений базы данных (https://wiki.archlinux.org/title/Locate). ${NC}"
echo -e "${MAGENTA}=> ${NC}findutils (GNU findutils) — Утилиты GNU для поиска файлов (также включает реализацию locate , пакет findutils Arch ее не включает). Эти программы обычно используются в сочетании с другими программами для предоставления модульных и мощных возможностей поиска каталогов и поиска файлов для других команд. (find - поиск файлов в иерархии каталогов; locate - вывести список файлов в базах данных, соответствующих шаблону; updatedb - обновить базу данных имен файлов; xargs — создание и выполнение командных строк из стандартного ввода)(https://www.gnu.org/software/findutils/). "
echo " mlocate (Merging Locate) — более безопасная версия утилиты locate , которая показывает только доступные пользователю файлы. mlocate - это объединяющий пакет locate и базы данных. "Объединение" означает, что updatedb повторно использует существующую базу данных, чтобы избежать повторного чтения большей части файловой системы. Это ускоряет обновление базы данных и не увеличивает нагрузку на системный кэш. located может индексировать несколько файловых систем, включая сетевые файловые системы для общих сетевых ресурсов. mlocate — это реализация locate/updatedb. Буква «m» означает «merging» (слияние): updatedb повторно использует существующую базу данных, чтобы избежать повторного чтения большей части файла система, которая делает updatedb быстрее и не засоряет системные кэши. Обратные конфликты: plocate (Posting Locate). Новые релизы будут доступны по адресу https://pagure.io/mlocate ." 
echo " plocate (Posting Locate) — это поиск, основанный на списках постов , который заранее использует базу данных mlocate и создает на ее основе гораздо более быстрый (и меньший) индекс."
echo -e "${YELLOW}:: Примечание! ${NC}plocate ДЕЙСТВИТЕЛЬНО быстрый. Поиск в базе данных размером 100 МБ . Помните, что plocate также требует запуска и включения таймера updatedb ."
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Установить plocate (Posting Locate),     2 - Установить mlocate (Merging Locate),  

    3 - Установить findutils (GNU findutils),    0 - НЕТ - Пропустить установку: " i_locate  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_locate" =~ [^1230] ]]
do
    :
done 
if [[ $i_locate == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_locate == 1 ]]; then
  echo ""  
  echo " Установка plocate (Posting Locate) "
sudo pacman -S --noconfirm --needed plocate  # Альтернатива locate, более быстрая и совместимая с базой данных mlocate ; https://plocate.sesse.net/ ; https://archlinux.org/packages/extra/x86_64/plocate/
  echo ""  
  echo " Запуска и включения таймера updatedb (plocate-updatedb.timer) "
  echo " При необходимости в графическом интерфейсе пользователя должен появиться запрос на root-доступ "
sudo updatedb  # мы можем вручную обновить updatedb от имени пользователя root или с помощью sudo.    
sudo systemctl enable plocate-updatedb.timer
sudo systemctl start plocate-updatedb.timer
# Этого должно быть достаточно (при необходимости в графическом интерфейсе пользователя должен появиться запрос на root-доступ)
# sudo systemctl enable --now plocate-updatedb.timer
# sudo systemctl status plocate-updatedb.timer
sudo systemctl list-unit-files | grep 'updatedb\|locate'  # Помимо проверки списка файлов пакета, проверку наличия службы
echo ""   
echo " Установка утилит (пакетов) выполнена "
elif [[ $i_locate == 2 ]]; then
  echo ""  
  echo " Создать группу mlocate (Merging Locate) "
  echo " Перед установкой необходимо создать группу под названием «mlocate», чтобы разрешить скрытие содержимого базы данных от пользователей. "
  echo " Когда updatedb запускается от имени root, база данных содержит имена файлов всех пользователи, но только члены группы "mlocate" могут получить к нему доступ. "locate" - это установлен set-GID "mlocate", никакие другие программы не должны запускаться с этим GID. "  
sudo groupadd mlocate  
sudo usermod -aG mlocate $USER  # Чтобы добавить пользователя "username" в группу "newgroup"
  echo ""  
  echo " Установка mlocate (Merging Locate) "
sudo pacman -S --noconfirm --needed mlocate  # Объединение реализации locate/updatedb ; https://pagure.io/mlocate ; https://archlinux.org/packages/core/x86_64/mlocate/ ; https://github.com/mlocate/mlocate
sudo updatedb  # мы можем вручную обновить updatedb от имени пользователя root или с помощью sudo.
# sudo pacman -Rcns mlocate 
  echo ""  
  echo " Запуска и включения таймера updatedb (mlocate-updatedb.timer) "
  echo " Таймер для updatedb называется mlocate-updatedb.timer "  
  echo " mlocate-updatedb.timer — обновляет базу данных mlocate каждый день "  
  echo " В моем случае мне пришлось добавить путь к моим снимкам rsync PRUNEPATHS в /etc/updatedb.conf " 
# sudo systemctl status updatedb.service
# sudo systemctl status updatedb updatedb.service
# sudo systemctl status updatedb 
# sudo systemctl start updatedb.service
sudo systemctl enable mlocate-updatedb.timer
sudo systemctl list-unit-files | grep 'updatedb\|locate'  # Помимо проверки списка файлов пакета, проверку наличия службы
# Мне кажется, что это, systemctl start mlocate-updatedb.service вероятно, самый правильный способ запустить его один раз, но запуск updatedb, вероятно, будет работать так же хорошо, поскольку конфигурация, похоже, полностью находится в /etc/updatedb.conf
# sudo systemctl start mlocate-updatedb.service  # чтобы запустить updatedb один раз
# Этого должно быть достаточно (при необходимости в графическом интерфейсе пользователя должен появиться запрос на root-доступ)
# sudo systemctl enable --now mlocate-updatedb.timer
# sudo systemctl status mlocate-updatedb.timer
#systemctl disable mlocate-updatedb.timer  # отключить его на данный момент
### sudo systemctl list-timers *timer  #  таймер не указан
# sudo pacman -Ql mlocate  # Проверьте установлен у вас mlocate
# sudo pacman -Fl mlocate  # Команда -Fl похожа на -Ql, но запрашивает базу данных репозитория, а не вашу базу данных локально установленных пакетов.
echo ""   
echo " Установка утилит (пакетов) выполнена "
elif [[ $i_locate == 3 ]]; then
  echo ""  
  echo " Установка findutils (GNU findutils) "
sudo pacman -S --noconfirm --needed findutils  # Утилиты GNU для поиска файлов ; https://www.gnu.org/software/findutils/ ; https://archlinux.org/packages/core/x86_64/findutils/
find --version  # Проверить правильность установки команды find и определить ее версию 
sudo updatedb  # Чтобы обновить базу данных, используемую командой «locate», можно использовать команду «updatedb»
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
########
# Если я протестирую locate, то, похоже, он сработает, поскольку сможет найти файл, созданный после отключения mlocate-updatedb:
# locate jdk-8u
# Но когда я перечисляю статистику базы данных:
# locate -S
# Размер mlocate базы данных довольно большой:
# ls -lh /var/lib/mlocate/mlocate.db
# по сравнению с рабочей станцией:
# locate -S
# Но таймеры все равно странные:
# systemctl list-timers --all
# Утилита locate полностью совместима с slocate. 
# Она также пытается быть совместимым с GNU locate, когда это не конфликтует с совместимость с slocate.
#################################### 

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
echo -e "${YELLOW}==> ${CYAN}git clone https://github.com/MarcMilany/archmy_2020.git ${NC}"
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