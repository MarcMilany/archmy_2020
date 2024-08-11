#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

ARCHMY4_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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

echo -e "${GREEN}
  <<< Начинается установка первоначально необходимого софта (пакетов) и запуск необходимых служб для системы Arch Linux >>>
${NC}"
# Installation of utilities (packages) for the Arch Linux system begins

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
echo -e "${YELLOW}==> ${NC}Обновить и добавить новые ключи?"
echo " Данный этап поможет вам избежать проблем с ключами Pacmаn, если Вы использовали не свежий образ ArchLinux для установки! "
echo -e "${RED}==> ${BOLD}Примечание: - Иногда при запуске обновления ключей по hkp возникает ошибка, не переживайте просто при установке gnupg в линукс в дефолтном конфиге указан следующий сервер: (keyserver hkp://keys.gnupg.net). GnuPG - оснащен универсальной системой управления ключами, а также модулями доступа для всех типов открытых ключей. GnuPG, также известный как GPG, это инструмент командной строки с возможностью легкой интеграции с другими приложениями. Доступен богатый выбор пользовательских приложений и библиотек. ${NC}"
echo -e "${RED}==> ${BOLD}Примечание: - Однако, в ходе чтения различных руководств в интернете было выяснено, что подобный способ обновления и передачи ключей не самый лучший, т.к. эта информация передается открытым способом. И тот, кто наблюдает за траффиком, видит данные обновляемых при gpg -refresh-keys ключей. И поэтому рекомендуется использовать hkps сервера - (keyserver hkps://hkps.pool.sks-keyservers.net)! ${NC}"
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, можно пропустить запуск обновления ключей. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да обновить,    0 - Нет пропустить: " x_key  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_key" =~ [^10] ]]
do
    :
done
 if [[ $x_key == 0 ]]; then
echo ""
echo " Обновление ключей пропущено " 
elif [[ $x_key == 1 ]]; then
clear
echo ""
echo " Выполним резервное копирование каталога (/etc/pacman.d/gnupg), на всякий случай "
# Файлы конфигурации по умолчанию: ~/.gnupg/gpg.conf и ~/.gnupg/dirmngr.conf.
sudo cp -R /etc/pacman.d/gnupg /etc/pacman.d/gnupg_back
# Я тебе советовал перед созданием нового брелка удалить директории (но /root/.gnupg не удалена)
echo " Удалим директорию (/etc/pacman.d/gnupg) "
sudo rm -R /etc/pacman.d/gnupg
# sudo rm -r /etc/pacman.d/gnupg
# sudo mv /usr/lib/gnupg/scdaemon{,_}  # если демон смарт-карт зависает (это можно обойти с помощью этой команды)
echo " Выполним резервное копирование каталога (/root/.gnupg), на всякий случай "
sudo cp -R /root/.gnupg /root/.gnupg_back        
#echo " Удалим директорию (/etc/pacman.d/gnupg) "
#sudo rm -R /root/.gnupg
echo " Создаётся генерация мастер-ключа (брелка) pacman "  # gpg –refresh-keys
sudo pacman-key --init  # генерация мастер-ключа (брелка) pacman
echo " Далее идёт поиск ключей... "
sudo pacman-key --populate archlinux  # поиск ключей
echo ""
echo " Обновление ключей... "  
sudo pacman-key --refresh-keys --keyserver keys.gnupg.net  # http://pool.sks-keyservers.net/
echo ""
echo "Обновим базы данных пакетов..."
###  sudo pacman -Sy
sudo pacman -Syy  # обновление баз пакмэна (pacman) 
# sudo pacman -Syyu  # Обновим вашу систему (базу данных пакетов)
# sudo pacman -Syyu  --noconfirm  
echo ""
echo " Обновление и добавление новых ключей выполнено "
fi
sleep 01

clear
echo ""
echo -e "${BLUE}:: ${NC}Проверим корректность загрузки установленных микрокодов " 
#echo " Давайте проверим, правильно ли загружен установленный микрокод "
# Let's check whether the installed microcode is loaded correctly
echo -e "${MAGENTA}=> ${NC}Если таковые (микрокод-ы: amd-ucode; intel-ucode) были установлены!"
echo " Если микрокод был успешно загружен, Вы увидите несколько сообщений об этом "
echo " Будьте внимательны! Вы можете пропустить это действие. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да проверим корректность загрузки,    0 - Нет пропустить: " x_ucode  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_ucode" =~ [^10] ]]
do
    :
done
 if [[ $x_ucode == 0 ]]; then
echo ""
echo " Проверка пропущена " 
elif [[ $x_ucode == 1 ]]; then
echo ""
echo " Выполним проверку корректности загрузки установленных микрокодов "
sudo dmesg | grep microcode
#dmesg | grep microcode
fi
sleep 02

clear
echo -e "${MAGENTA}
  <<< Установить дополнительных утилит для Синхронизации времени (Если Вы обнаружите, что время сбиваться по различным причинам). >>> ${NC}"

echo ""
echo -e "${GREEN}==> ${NC}Установить TimeSet (bash скрипт - timeset) и GUI интерфейс для управления системной датой и временем (timeset-gui) из AUR"
#echo 'Установить TimeSet (bash скрипт - timeset) и GUI интерфейс для управления системной датой и временем (timeset-gui)
# Install TimeSet and GUI...
echo -e "${BLUE}:: ${BOLD}Посмотрим дату, время, и часовой пояс ... ${NC}"
timedatectl | grep "Time zone"
date
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'     # одновременно отображает дату и часовой пояс
echo ""
echo -e "${YELLOW}=> ${NC}Если при двойной загрузке с Windows или любой другой ОС Вы обнаружите, что время сбиваться, это может быть связано с тем, что они используют разные значения времени для аппаратных часов. Arch (& Manjaro) считает, что аппаратные часы находятся в формате UTC, в то время как Windows и некоторые другие дистрибутивы Linux предполагают, что аппаратные часы находятся в местном времени. Чтобы исправить это, можно настроить Windows на использование аппаратного времени в формате UTC."
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo " 1 - TimeSet (bash скрипт - timeset) - пакет (timeset - Скрипт для управления системной датой и временем) "
echo -e "${CYAN}:: ${NC}Установка TimeSet (timeset) проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/timeset.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux - AUR' (https://aur.archlinux.org/packages/timeset/) - собирается и устанавливается. "
echo " 2 - TimeSet-GUI (python скрипт - timeset-gui) - пакет (timeset-gui - Графический интерфейс для управления системной датой и временем) "
echo -e "${CYAN}:: ${NC}Установка TimeSet-GUI (timeset-gui) проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/timeset-gui.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux - AUR' (https://aur.archlinux.org/packages/timeset-gui/) - собирается и устанавливается. "
echo -e "${YELLOW}==> Внимание! ${NC}Для полноценной установки у Вас должен быть установлен NTP (Network Time Protocol) - (пакет ntp), и Gksu (Графический интерфейс для su) - (пакет gksu), которые являются зависимостями для установки." 
echo -e "${CYAN}:: ${NC}Возможно эти зависимости были установлены вами ранее!"  # NTP Servers (серверы точного времени) - https://www.ntp-servers.net/; Introduction - https://www.ntppool.org/ru/ 
echo " Будьте внимательны! В данной опции выбор всегда остаётся за вами. "
echo -e "${CYAN}==> ${NC}Рекомендую выбрать вариант "1" (Установим СРАЗУ timeset и timeset-gui)" 
echo "" 
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Установить TimeSet и TimeSet-GUI (timeset; timeset-gui),     2 - Установить TimeSet (bash скрипт - timeset) 

    0 - НЕТ - Пропустить установку: " i_timeset  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_timeset" =~ [^120] ]]
do
    :
done
if [[ $i_timeset == 0 ]]; then
echo ""  
echo " Установка пропущена "
elif [[ $i_timeset == 1 ]]; then
  echo ""
  echo " Установка TimeSet и TimeSet-GUI (графический интерфейс для управления системной датой) "
# yay -S timeset --noconfirm  # Скрипт для управления системной датой и временем
# yay -S timeset-gui --noconfirm  # Графический интерфейс для управления системной датой
echo " Установка TimeSet (пакета - timeset) "
##### timeset ######  
git clone https://aur.archlinux.org/timeset.git
cd timeset
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf timeset
rm -Rf timeset   # удаляем директорию сборки
echo " Установка TimeSet-GUI (пакета - timeset-gui) "
##### timeset-gui ######  
git clone https://aur.archlinux.org/timeset-gui.git 
cd timeset-gui
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf timeset-gui
rm -Rf timeset-gui   # удаляем директорию сборки
echo ""
echo " Установка TimeSet и TimeSet-GUI (timeset; timeset-gui) выполнена "
echo " Время точное как на Спасской башне Московского Кремля! "
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'   # одновременно отображает дату и часовой пояс
elif [[ $i_timeset == 2 ]]; then
  echo ""
  echo " Установка TimeSet (скрипт для управления системной датой и временем) "
# yay -S timeset --noconfirm  # Скрипт для управления системной датой и временем
##### timeset ######  
git clone https://aur.archlinux.org/timeset.git
cd timeset
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf timeset
rm -Rf timeset   # удаляем директорию сборки
echo ""
echo " Установка TimeSet (timeset) выполнена "
echo " Время точное как на Спасской башне Московского Кремля! "
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'   # одновременно отображает дату и часовой пояс
fi

clear
echo -e "${MAGENTA}
  <<< Установка дополнительного программного обеспечения (пакетов) для редактирования и разработки в Archlinux >>> ${NC}"
# Installing additional software (packages) for editing and development in Archlinux

echo ""
echo -e "${GREEN}==> ${NC}Установка текстового редактора Vim или gVim (графическая оболочка для редактора Vim)"
#echo -e "${BLUE}:: ${NC}Установка текстового редактора Vim или gVim (графическая оболочка для редактора Vim)" 
#echo 'Установка текстового редактора Vim или gVim'
# Installing the Vim or gVim text editor
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo -e "${MAGENTA}=> ${BOLD}Vim - это свободный текстовый редактор, созданный на основе более старого vi. Ныне это мощный текстовый редактор с полной свободой настройки и автоматизации, возможными благодаря расширениям и надстройкам. Пользовательский интерфейс Vim’а может работать в чистом текстовом режиме. Для поклонников vi - практически стопроцентная совместимость с vi. ${NC}"
echo -e "${CYAN}:: ${NC}Функционал утилиты Vim как при работе с текстовыми файлами, так и цикл разработки (редактирование; компиляция; исправление программ; и т.д.) очень обширен. (https://www.vim.org/)"
echo -e "${CYAN}:: ${NC}Существует и модификация для использования в графическом оконном интерфейсе - GVim."
echo -e "${MAGENTA}=> ${BOLD}gVim - представляет собой версию Vim, скомпилированную с поддержкой графического интерфейса. Обычно редактор Vim используют, запуская его в консоли или эмуляторе терминала. ${NC}"
echo -e "${CYAN}:: ${NC}Однако если вы активно используете GUI, вам может быть полезен gVim. (https://www.vim.org/)"
echo -e "${YELLOW}==> Примечание: ${BOLD}При установке приложение gVim пакета (gvim), само приложение Vim пакет (vim) будет удален (просто заменён на gvim). ${NC}"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Установить редактор Vim,     2 - Установить приложение gVim (GUI),     

    0 - НЕТ - Пропустить установку: " i_gvim  # sends right after the keypress; # отправляет сразу после нажатия клавиши    
    echo ''
    [[ "$i_gvim" =~ [^120] ]]
do
    :
done 
if [[ $i_gvim == 0 ]]; then 
echo ""   
echo " Установка пропущена "
elif [[ $i_gvim == 1 ]]; then
  echo ""    
  echo " Установка редактора Vim "
sudo pacman -S vim --noconfirm  # Vi Improved, улучшенная версия текстового редактора vi с широкими возможностями настройки
# sudo pacman -S neovim --noconfirm  # Форк Vim с целью улучшить пользовательский интерфейс, плагины и графические интерфейсы
echo ""
echo " Установка редактора Vim выполнена "
elif [[ $i_gvim == 2 ]]; then
  echo ""    
  echo " Установка приложение gVim графической оболочки для редактора Vim "
# sudo pacman -Rsn vim  # Удалить пакет с зависимостями (не используемыми другими пакетами) и его конфигурационные файлы
# sudo pacman -Rs vim  # Удалить пакет с зависимостями (не используемыми другими пакетами)
#sudo pacman -R vim  # Удалить пакет vim
sudo pacman -S gvim --noconfirm  # Vi Improved, улучшенная версия текстового редактора vi с широкими возможностями настройки (с расширенными функциями, такими как графический интерфейс)
echo ""
echo " Установка gVim графической оболочки для редактора Vim выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установка дополнительных пакетов для расширения возможностей редактора Vim или gVim"
#echo -e "${BLUE}:: ${NC}Установка дополнительных пакетов для расширения возможностей редактора Vim или gVim" 
#echo 'Установка дополнительных пакетов для расширения возможностей редактора Vim или gVim'
# Installing additional packages to extend the capabilities of the Vim or gVim editor
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (vi, vim-ansible, vim-ale, vim-airline, vim-airline-themes, vim-align, vim-bufexplorer, vim-ctrlp, vim-fugitive, vim-indent-object, vim-jad, vim-jedi, vim-latexsuite, vim-molokai, vim-nerdcommenter, vim-nerdtree, vim-pastie, vim-runtime, vim-seti, vim-spell-ru, vim-supertab, vim-surround, vim-syntastic, vim-tagbar, vim-ultisnips, vim-coverage-highlight, vim-csound, vim-easymotion, vim-editorconfig, vim-gitgutter, vim-grammalecte, vimpager)."
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_vi  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_vi" =~ [^10] ]]
do
    :
done
if [[ $i_vi == 0 ]]; then
echo ""  
echo " Установка дополнительных пакетов для редактора Vim пропущена "
elif [[ $i_vi == 1 ]]; then
echo ""
echo " Установка дополнительных пакетов для редактора Vim "
# sudo pacman -S vi vim-ansible vim-ale vim-airline vim-airline-themes vim-align vim-bufexplorer vim-ctrlp vim-fugitive vim-indent-object vim-jad vim-jedi vim-latexsuite vim-molokai vim-nerdcommenter vim-nerdtree vim-pastie vim-runtime vim-seti vim-spell-ru vim-supertab vim-surround vim-syntastic vim-tagbar vim-ultisnips --noconfirm 
#sudo pacman -S vim-coverage-highlight vim-csound vim-easymotion vim-editorconfig vim-gitgutter vim-grammalecte vimpager --noconfirm  # (https://www.vim.org/)
# Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты шрифтов!
sudo pacman -S vi --noconfirm  # Оригинальный текстовый редактор ex / vi
sudo pacman -S vim-ansible --noconfirm  # Плагин vim для подсветки синтаксиса распространенных типов файлов Ansible
sudo pacman -S vim-ale --noconfirm  # Асинхронный Lint Engine
sudo pacman -S vim-airline --noconfirm  # Строка состояния, написанная в Vimscript
sudo pacman -S vim-airline-themes --noconfirm  # Темы для вим-авиакомпании
#sudo pacman -S vim-align --noconfirm  # Позволяет выравнивать строки с помощью регулярных выражений
sudo pacman -S vim-bufexplorer --noconfirm  # Простой список буферов / переключатель для vim
sudo pacman -S vim-ctrlp --noconfirm  # Поиск нечетких файлов, буферов, mru, тегов и т.д.
sudo pacman -S vim-fugitive --noconfirm  # Обертка Git такая классная, она должна быть незаконной
sudo pacman -S vim-indent-object --noconfirm  # Текстовые объекты на основе уровней отступа
sudo pacman -S vim-jad --noconfirm  # Автоматическая декомпиляция файлов классов Java и отображение кода Java
sudo pacman -S vim-jedi --noconfirm  # Плагин Vim для джедаев, отличное автозаполнение Python
sudo pacman -S vim-latexsuite --noconfirm  # Инструменты для просмотра, редактирования и компиляции документов LaTeX в Vim
sudo pacman -S vim-molokai --noconfirm  # Порт цветовой схемы монокаи для TextMate
sudo pacman -S vim-nerdcommenter --noconfirm  # Плагин, позволяющий легко комментировать код для многих типов файлов
sudo pacman -S vim-nerdtree --noconfirm  # Плагин Tree explorer для навигации по файловой системе
#sudo pacman -S vim-pastie --noconfirm  # Плагин Vim, который позволяет читать и создавать вставки на http://pastie.org/
sudo pacman -S vim-runtime --noconfirm  # Vi Improved, улучшенная версия текстового редактора vi с широкими возможностями настройки (общая среда выполнения)
sudo pacman -S vim-seti --noconfirm  # Цветовая схема на основе темы Сети Джесси Вида для редактора Atom
sudo pacman -S vim-spell-ru --noconfirm  # Языковые файлы для проверки орфографии в Vim
sudo pacman -S vim-supertab --noconfirm  # Плагин Vim, который позволяет использовать клавишу табуляции для выполнения всех операций вставки
sudo pacman -S vim-surround --noconfirm  # Предоставляет сопоставления для простого удаления, изменения и добавления парного окружения
sudo pacman -S vim-syntastic --noconfirm  # Автоматическая проверка синтаксиса для Vim
sudo pacman -S vim-tagbar --noconfirm  # Плагин для просмотра тегов текущего файла и получения обзора его структуры
sudo pacman -S vim-ultisnips --noconfirm  # Фрагменты для Vim в стиле TextMate
#sudo pacman -S vim-coverage-highlight --noconfirm  # Плагин Vim для выделения строк исходного кода Python, которым не хватает тестового покрытия
sudo pacman -S vim-csound --noconfirm  # Инструменты csound для Vim
sudo pacman -S vim-easymotion --noconfirm  # Vim движение по скорости
#sudo pacman -S vim-editorconfig --noconfirm  # Плагин EditorConfig для Vim
sudo pacman -S vim-gitgutter --noconfirm  # Плагин Vim, показывающий разницу git в желобе (столбец со знаком)
sudo pacman -S vim-grammalecte --noconfirm  # Интегрирует Grammalecte в Vim
sudo pacman -S vimpager --noconfirm  # Сценарий на основе vim для использования в качестве ПЕЙДЖЕРА
# sudo pacman -S  --noconfirm  #
# sudo pacman -S  --noconfirm  #
# sudo pacman -S  --noconfirm  #
echo ""
echo " Установка дополнительных пакетов для редактора Vim выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установка дополнительных пакетов для расширения возможностей редактора Vim из AUR (через - yay)"
#echo -e "${BLUE}:: ${NC}Установка дополнительных пакетов для расширения возможностей редактора Vim из AUR (через - yay)" 
#echo 'Установка дополнительных пакетов для расширения возможностей редактора Vim из AUR (через - yay)'
# Installing additional packages to extend the capabilities of the Vim editor from AUR (via - yay)
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (vim-colorsamplerpack, vim-doxygentoolkit, vim-guicolorscheme, vim-jellybeans, vim-minibufexpl, vim-omnicppcomplete, vim-project, vim-rails, vim-taglist, vim-vcscommand, vim-workspace)."
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " t_vim  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_vim" =~ [^10] ]]
do
    :
done
if [[ $t_vim == 0 ]]; then
echo ""  
echo " Установка дополнительных пакетов для редактора Vim из AUR (через - yay) пропущена "
elif [[ $t_vim == 1 ]]; then
echo ""
echo " Установка дополнительных пакетов для редактора Vim из AUR (через - yay) "
# yay -S vim-colorsamplerpack vim-doxygentoolkit vim-guicolorscheme vim-jellybeans vim-minibufexpl vim-omnicppcomplete vim-project vim-rails vim-taglist vim-vcscommand vim-workspace --noconfirm  
# Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты шрифтов!
yay -S vim-colorsamplerpack --noconfirm  # Различные цветовые схемы для vim 
yay -S vim-doxygentoolkit --noconfirm  # Этот скрипт упрощает документацию doxygen на C / C ++
yay -S vim-guicolorscheme --noconfirm  # Автоматическое преобразование цветовых схем только для графического интерфейса в схемы цветовых терминалов 88/256
yay -S vim-jellybeans --noconfirm  # Яркая, темная цветовая гамма, вдохновленная ir_black и сумерками
yay -S vim-minibufexpl --noconfirm  # Элегантный обозреватель буферов для vim
yay -S vim-omnicppcomplete --noconfirm  # vim c ++ завершение omnifunc с базой данных ctags
yay -S vim-project --noconfirm  # Организовывать и перемещаться по проектам файлов (например, в проводнике ide / buffer)
yay -S vim-rails --noconfirm  # Плагин ViM для усовершенствованной разработки приложений Ruby on Rails
yay -S vim-taglist --noconfirm  # Плагин браузера с исходным кодом для vim
yay -S vim-vcscommand --noconfirm  # Плагин интеграции системы контроля версий vim
yay -S vim-workspace --noconfirm  # Плагин vim workspace manager для управления группами файлов
# yay -S vim-coverage-highlight --noconfirm  #
### yay -S vim-editorconfig --noconfirm  #
# yay -S vim-pastie --noconfirm  #
### yay -S vim-align --noconfirm  # не найдено!!!
# yay -S  --noconfirm  #
pwd  # покажет в какой директории мы находимся
echo ""
echo " Установка дополнительных пакетов для редактора Vim из AUR (через - yay) выполнена "
fi

clear
echo -e "${GREEN}==> ${NC}Установка Sublime Text (Саблайм текст) (редактор кода) "
echo -e "${MAGENTA}:: ${BOLD}Sublime Text - это кроссплатформенный текстовый редактор, разработанный для пользователей, которые ищут эффективный, но минималистский инструмент для редактирования кода. Редактор, конечно же, прост, в котором отсутствуют панели инструментов или диалоговые окна. ${NC}"
echo " Sublime Text на данный момент является одним из самых популярных текстовых редакторов, используемых для веб-разработки. Sublime во многом обязан своей популярностью сообществу, которое создало такое большое количество полезных плагинов. "
echo -e "${YELLOW}==> Примечание! ${NC}В сценарии (скрипте) представлены несколько вариантов установки: " 
echo " Sublime Text (пакет) (sublime-text-3) - стабильная версия, и Sublime Text Dev (пакет) (sublime-text-dev) версия для разработчиков. "
echo -e "${CYAN}:: ${NC}Установка Sublime Text (sublime-text-3), или (sublime-text-dev), проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/sublime-text-3/), (https://aur.archlinux.org/packages/sublime-text-dev/) - собирается и устанавливается. "
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In this option, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...  
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Установить Sublime Text,     2 - Установить Sublime Text Dev,     

    0 - НЕТ - Пропустить установку: " i_sublimetext  # sends right after the keypress; # отправляет сразу после нажатия клавиши    
    echo ''
    [[ "$i_sublimetext" =~ [^120] ]]
do
    :
done 
if [[ $i_sublimetext == 0 ]]; then 
echo ""   
echo " Установка пропущена "
elif [[ $i_sublimetext == 1 ]]; then
  echo ""    
  echo " Установка Sublime Text "
############ sublime-text-3 ##########
# yay -S sublime-text-3 --noconfirm  # Продуманный текстовый редактор для кода, html и прозы - стабильная сборка
git clone https://aur.archlinux.org/sublime-text-3.git  # Продуманный текстовый редактор для кода, html и прозы - стабильная сборка
cd sublime-text-3
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf sublime-text-3 
rm -Rf sublime-text-3
echo ""
echo " Установка Sublime Text выполнена "
elif [[ $i_sublimetext == 2 ]]; then
  echo ""    
  echo " Установка Sublime Text Dev "
############ sublime-text-dev ##########
# yay -S sublime-text-dev --noconfirm  # Сложный текстовый редактор для кода, html и прозы - dev build
git clone https://aur.archlinux.org/sublime-text-dev.git  # Сложный текстовый редактор для кода, html и прозы - dev build
cd sublime-text-dev
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf sublime-text-dev 
rm -Rf sublime-text-dev
echo ""
echo " Установка Sublime Text Dev выполнена "
fi
# ---------------------------------
# Sublime Text для фронтэнд-разработчика
# https://habr.com/ru/post/244681/
# https://www.sublimetext.com/3
# http://www.sublimetext.com/3
# https://sublimetext3.ru/
#-----------------------------

clear
echo ""
echo -e "${MAGENTA}
  <<< Установка дополнительных утилит для восстановления данных с поврежденного жесткого диска (Если Вы обнаружите, что возникли ошибоки чтения диска, и начали сыпаться ошибки на консоль и в лог). >>> ${NC}"
echo ""
echo -e "${GREEN}==> ${NC}Установить GNU Ddrescue (ddrescue) и GUI интерфейс упрощающий использование ddrescue (ddrescue-gui) из AUR?"
# Install GNU ddrescue (ddrescue) and GUI interface to simplify the use of ddrescue (ddrescue-gui) from AUR?
echo -e "${MAGENTA}:: ${BOLD}GNU Ddrescue - это инструмент для восстановления данных. Он копирует данные из одного файла или блочного устройства (жесткого диска, компакт-диска и т.д.). В другой, пытаясь сначала спасти хорошие части в случае ошибок чтения. ${NC}"
echo " Основная операция ddrescue полностью автоматическая. То есть вам не нужно ждать ошибки, останавливать программу, перезапускать ее с новой позиции и т.д.... " 
echo " Ddrescue не записывает нули в выходные данные, когда обнаруживает поврежденные секторы во входных данных, и не обрезает выходной файл, если об этом не просят. Таким образом, каждый раз, когда вы запускаете его в одном и том же выходном файле, он пытается заполнить пробелы, не стирая уже восстановленные данные. "
echo -e "${YELLOW}==> Примечание: ${NC}GNU Ddrescue не является производной от dd и никак не связана с dd, за исключением того, что обе могут использоваться для копирования данных с одного устройства на другое. Разница в том, что ddrescue использует сложный алгоритм для копирования данных с неисправных дисков, что наносит им как можно меньше дополнительного ущерба."
echo -e "${CYAN}:: ${NC}Установка Ddrescue (ddrescue) проходит из 'Официальных репозиториев Arch Linux' - (Не AUR). Кроме Ddrescue GUI пакета (ddrescue-gui), его установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/ddrescue-gui/) - собирается и устанавливается. "
echo -e "${CYAN}==> Важно! ${NC}В сценарии (скрипте) представлены несколько вариантов установки: " 
echo " Установка Ddrescue (консольный вариант) без дополнений GUI, и второй вариант Ddrescue + GUI дополнения (пакет) (ddrescue-gui). "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Установить Ddrescue,     2 - Установить Ddrescue + GUI,     

    0 - НЕТ - Пропустить установку: " i_ddrescue  # sends right after the keypress; # отправляет сразу после нажатия клавиши    
    echo ''
    [[ "$i_ddrescue" =~ [^120] ]]
do
    :
done 
if [[ $i_ddrescue == 0 ]]; then 
echo ""   
echo " Установка пропущена "
elif [[ $i_ddrescue == 1 ]]; then
  echo ""    
  echo " Установка Ddrescue "
############ ddrescue ##########
sudo pacman -S ddrescue --noconfirm  # Инструмент восстановления данных GNU
echo ""
echo " Установка Ddrescue выполнена "
elif [[ $i_ddrescue == 2 ]]; then
  echo ""    
  echo " Установка Ddrescue + GUI "
############ ddrescue ##########
# yay -S ddrescue-gui --noconfirm  # Запатентованный сервис потоковой передачи музыки
sudo pacman -S ddrescue --noconfirm  # Инструмент восстановления данных GNU
############ lshw ##########
sudo pacman -S lshw --noconfirm  # Небольшой инструмент для предоставления подробной информации об аппаратной конфигурации машины 
############ python-beautifulsoup4 ##########
sudo pacman -S python-beautifulsoup4 --noconfirm  # Синтаксический анализатор HTML / XML на Python, предназначенный для быстрого выполнения проектов, таких как очистка экрана
############ python-getdevinfo ##########
git clone https://aur.archlinux.org/python-getdevinfo.git  # Сборщик информации об устройстве для Linux и macOS использование ddrescue (инструмент для восстановления данных из командной строки)
cd python-getdevinfo
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf python-getdevinfo 
rm -Rf python-getdevinfo
############ python-requests ##########
sudo pacman -S python-requests --noconfirm  # Python HTTP для людей
############ python-wxpython ##########
sudo pacman -S python-wxpython --noconfirm  # Кросс-платформенный набор инструментов с графическим интерфейсом
############ ddrescue-gui ##########
git clone https://aur.archlinux.org/ddrescue-gui.git  # Простой интерфейс с графическим интерфейсом, упрощающий использование ddrescue (инструмент для восстановления данных из командной строки)
cd ddrescue-gui
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ddrescue-gui 
rm -Rf ddrescue-gui
echo ""
echo " Установка Ddrescue + GUI выполнена "
echo ""
echo -e "${BLUE}:: ${BOLD}Посмотрим идентификацию накопителей (name, label, size, fstype, model) ... ${NC}"
date
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'     # одновременно отображает дату и часовой пояс
echo ""
# sudo lsblk -f
sudo lsblk -o name,label,size,fstype,model
echo "" 
sudo findmnt -D  # Если вы не сможете определить ваши диски
echo ""
fi
#-------------------------
# Одна из самых сильных сторон ddrescue заключается в том, что она не зависит от интерфейса и поэтому может использоваться для любого типа устройств, поддерживаемых вашим ядром (ATA, SATA, SCSI, старые приводы MFM, гибкие диски или даже карты флэш-памяти, такие как SD).
# https://aur.archlinux.org/packages/ddrescue-gui/
# https://launchpad.net/ddrescue-gu
# https://www.gnu.org/software/ddrescue/
# https://www.gnu.org/software/ddrescue/manual/ddrescue_manual.html
# https://www.gnu.org/graphics/agnuhead.html
# http://rus-linux.net/MyLDP/admin/ddrescue.html
# https://www.k-max.name/linux/ddrescue-hdd-vosstanovlenie-and-examples/
# http://sysadminblog.sagrer.ru/stati-i-gajdy/linux/21-primer-vosstanovleniya-dannykh-s-pomoshchyu-gnu-ddrescue.html
# https://ru.wikipedia.org/wiki/Ddrescue
#---------------------------

clear
echo -e "${MAGENTA}
  <<< Установка графического интерфейса для Reflector (отражателя) в Archlinux >>> ${NC}"
# Installing the program (package) menu Editor in Archlinux

echo ""
echo -e "${GREEN}==> ${NC}Установить графический интерфейс для Reflector и утилиты преобразователя IP-адресов?"
#echo -e "${BLUE}:: ${NC}Установить графический интерфейс для Reflector и утилиты преобразователя IP-адресов"
#echo 'Установить графический интерфейс для Reflector и утилиты преобразователя IP-адресов'
# Install the GUI for Reflector and the IP Address Converter utility?
echo -e "${MAGENTA}:: ${BOLD}Reflector - скрипт, который автоматизирует процесс настройки зеркал, включающий в себя загрузку свежего списка зеркал со страницы Mirror Status, фильтрацию из них наиболее обновленных, сортировку по скорости и сохранение в /etc/pacman.d/mirrorlist. ${NC}"
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo -e "${MAGENTA}:: ${NC}1 - Reflector-Simple - Простая оболочка графического интерфейса для reflector (отражателя)."
echo -e "${CYAN}:: ${NC}Установка reflector-simple проходит через сборку из исходников AUR. То есть установка производиться с помощью git clone (https://aur.archlinux.org/reflector-simple.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/reflector-simple/), собирается и устанавливается."
echo " Вместе с (пакетом) reflector-simple будут установлены утилиты преобразователя IP-адресов : - geoip, geoip-database, zenity, yad. Эти (пакеты) скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. "
echo -e "${MAGENTA}:: ${NC}2 - Fetchmirrors - Утилита обновления зеркального списка Arch Linux pacman."
echo -e "${CYAN}:: ${NC}Установка fetchmirrors проходит через сборку из исходников AUR. То есть установка производиться с помощью git clone (https://aur.archlinux.org/fetchmirrors.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/fetchmirrors/), собирается и устанавливается."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Установить Reflector-Simple,     2 - Установить Fetchmirrors,     

    3 - Установить Reflector-Simple + Fetchmirrors,      0 - НЕТ - Пропустить установку: " i_reflector  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_reflector" =~ [^1230] ]]
do
    :
done 
if [[ $i_reflector == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_reflector == 1 ]]; then
  echo ""  
  echo " Установка Reflector-Simple "
##### reflector-simple ###### 
sudo pacman -S geoip --noconfirm  # Библиотека C и утилиты преобразователя IP-адресов в страну без использования DNS
sudo pacman -S geoip-database --noconfirm  # Устаревшая база данных стран GeoIP (на основе данных GeoLite2, созданных MaxMind)
sudo pacman -S zenity --noconfirm  # Отображение графических диалоговых окон из сценариев оболочки (возможно присутствует)
sudo pacman -S yad --noconfirm  # Вилка zenity - отображение графических диалогов из сценариев оболочки или командной строки
# yay -S reflector-simple --noconfirm  # Простая оболочка графического интерфейса для reflector (отражателя)
git clone https://aur.archlinux.org/reflector-simple.git  # Простая оболочка графического интерфейса для reflector (отражателя)
cd reflector-simple  # переместит пользователя в каталог с исходниками
#makepkg -fsri
# makepkg -si
# makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е на правильные (то есть вместо sha512sums= xxxxxxxxxxxxxxxxxx нужно втавить новые xxxxxxxxxxxxxxxxxxxx и сохранить, а потом пересобрать и установить пакет, это делает команда makepkg -si)
### Новые sha512sums (01.04.2021г)
### sha512sums=('9e2bea3c059ae4b3308427fb41b6565c9bff5930793d3e0ee381b6620a738952c3453673c7d28a1efbff3e8bd6287c642068c43f634917cd6077f026d9982bd3'
###   '2def334909a5bbe3c6f82043f62a0f3f3c6747b7813ad9154f43e70c303301e079f8e81ea41b306f1b6f8a8e37afd535686b2e4642fb6b9357d97a7fad1e0d0a')
# mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf reflector-simple 
rm -Rf reflector-simple
echo ""   
echo " Установка утилит (пакетов) выполнена "
echo " Желательно перезагрузить систему для применения изменений "
elif [[ $i_reflector == 2 ]]; then
  echo ""  
  echo " Установка Fetchmirrors "
##### fetchmirrors ######   
# yay -S fetchmirrors --noconfirm  # Получите новый зеркальный список pacman и оцените лучшее
git clone https://aur.archlinux.org/fetchmirrors.git  # Утилита обновления зеркального списка Arch Linux pacman
cd fetchmirrors
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf fetchmirrors 
rm -Rf fetchmirrors
echo ""   
echo " Установка утилит (пакетов) выполнена "
echo " Желательно перезагрузить систему для применения изменений "
elif [[ $i_reflector == 3 ]]; then
  echo ""  
  echo " Установка Reflector-Simple + Fetchmirrors "
##### reflector-simple ###### 
sudo pacman -S geoip --noconfirm  # Библиотека C и утилиты преобразователя IP-адресов в страну без использования DNS
sudo pacman -S geoip-database --noconfirm  # Устаревшая база данных стран GeoIP (на основе данных GeoLite2, созданных MaxMind)
sudo pacman -S zenity --noconfirm  # Отображение графических диалоговых окон из сценариев оболочки (возможно присутствует)
sudo pacman -S yad --noconfirm  # Вилка zenity - отображение графических диалогов из сценариев оболочки или командной строки
# yay -S reflector-simple --noconfirm  # Простая оболочка графического интерфейса для reflector (отражателя)
git clone https://aur.archlinux.org/reflector-simple.git  # Простая оболочка графического интерфейса для reflector (отражателя)
cd reflector-simple
#makepkg -fsri
# makepkg -si
# makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е на правильные (то есть вместо sha512sums= xxxxxxxxxxxxxxxxxx нужно втавить новые xxxxxxxxxxxxxxxxxxxx и сохранить, а потом пересобрать и установить пакет, это делает команда makepkg -si)
### Новые sha512sums (01.04.2021г)
### sha512sums=('9e2bea3c059ae4b3308427fb41b6565c9bff5930793d3e0ee381b6620a738952c3453673c7d28a1efbff3e8bd6287c642068c43f634917cd6077f026d9982bd3'
###   '2def334909a5bbe3c6f82043f62a0f3f3c6747b7813ad9154f43e70c303301e079f8e81ea41b306f1b6f8a8e37afd535686b2e4642fb6b9357d97a7fad1e0d0a')
# sudo mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf reflector-simple 
rm -Rf reflector-simple
##### fetchmirrors ######   
# yay -S fetchmirrors --noconfirm  # Получите новый зеркальный список pacman и оцените лучшее
git clone https://aur.archlinux.org/fetchmirrors.git  # Утилита обновления зеркального списка Arch Linux pacman
cd fetchmirrors
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf fetchmirrors 
rm -Rf fetchmirrors
echo ""   
echo " Установка утилит (пакетов) выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
#----------------------
# https://github.com/endeavouros-team/PKGBUILDS/tree/master/reflector-simple
# https://github.com/deadhead420/fetchmirrors
# https://dev.maxmind.com/geoip/legacy/downloadable/
# https://github.com/v1cont/yad
# ДЛЯ ПАРАНОИКОВ!!! (FOR THE PARANOID)
# GEOIP - Это публичная база данных соответствий IP-страна. IP-город (city database) там тоже есть, но полная версия - платная ЕМНИП.
# Нужно всяким пакетам типа wireshark, pmacct и т.д. чтобы выводить информацию по IP-адресам
# Эта штука сама по себе ничего отследить не может. Это база соответствий IP-адресов странам. Если провести аналогию с телефонными номерами, то это как справочник, где указано, какой телефонный код относится к какой стране (+7 = Россия, +1 = США и пр.). За деньги можно купить список кодов городов.
# https://www.8host.com/blog/opredelenie-mestopolozheniya-polzovatelya-pri-pomoshhi-geoip-i-elk/
#---------------------
:: mpd-git-0.23.15.r1457.g8e42467bd-1 and mpd-0.23.15-5 are in conflict. Remove mpd? [y/N] 
ошибка: обнаружен неразрешимый конфликт пакетов
ошибка: не удалось подготовить транзакцию (конфликтующие зависимости)
:: mpd-git-0.23.15.r1457.g8e42467bd-1 and mpd-0.23.15-5 are in conflict
 -> error installing: [/home/Alex/.cache/yay/mpd-git/mpd-git-0.23.15.r1457.g8e42467bd-1-x86_64.pkg.tar.zst /home/Alex/.cache/yay/mpd-git/mpd-git-debug-0.23.15.r1457.g8e42467bd-1-x86_64.pkg.tar.zst] - exit status 1
[Alex@Terminator ~]$ 

###### MPD - серверное приложение для воспроизведения музыки ####
sudo pacman -S --noconfirm --needed mpd # Гибкое, мощное серверное приложение для воспроизведения музыки https://archlinux.org/packages/extra/x86_64/mpd/ ; https://github.com/MusicPlayerDaemon/MPD
sudo pacman -S --noconfirm --needed mpc  # Минималистичный интерфейс командной строки для MPD
# Демон для воспроизведения музыки различных форматов. Музыка воспроизводится через аудиоустройство сервера. Демон хранит информацию обо всей доступной музыке, и эту информацию можно легко искать и извлекать. Управление проигрывателем, извлечение информации и управление плейлистами можно осуществлять удаленно.
# MPD выпускается под лицензией GNU General Public License версии 2 и распространяется в файле COPYING.
###### AUR MPD - серверное приложение для воспроизведения музыки ####
yay -S mpd-git --noconfirm  # Гибкое, мощное серверное приложение для воспроизведения музыки (из git) https://aur.archlinux.org/packages/mpd-git ; https://aur.archlinux.org/mpd-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/MusicPlayerDaemon/MPD
yay -S mpdm --noconfirm  #  Гибкое, мощное серверное приложение для воспроизведения музыки
sudo pacman -S --noconfirm --needed mpc  # Минималистичный интерфейс командной строки для MPD
yay -S mpdmenu --noconfirm  # dmenu интерфейс для MPD https://aur.archlinux.org/packages/mpdmenu ; https://aur.archlinux.org/mpdmenu.git (только для чтения, нажмите, чтобы скопировать)
yay -S mpdmenu-git --noconfirm  # Простой интерфейс dmenu для MPD https://aur.archlinux.org/packages/mpdmenu-git ; https://aur.archlinux.org/mpdmenu-git.git (только для чтения, нажмите, чтобы скопировать)
# Music Player Daemon (MPD) — музыкальный проигрыватель с клиент-серверной архитектурой, который воспроизводит музыку из указанного каталога. Воспроизведением управляют при помощи клиента. Управлять сервером (демоном) можно с любой машины из сети, но слушать музыку можно и на своём компьютере, если программу-клиент MPD настроить на подключение к локальному хосту (localhost)[1].
# Такая технология имеет ряд преимуществ. Для работы MPD не нужна X Window System, поэтому перезапуск X или закрытие программы-клиента не влияет на проигрывание (есть и клиенты, которые могут работать в командной строке, например, mpc и ncmpc); на сервере с MPD может даже не быть монитора. Воспроизведением можно управлять с других компьютеров, а также мобильных устройств (есть клиентские приложения для iOS, Android, Symbian и многих других платформ). Управлять воспроизведением музыки можно не только через локальную сеть, но и через Интернет (конфигурационный файл позволяет задать, на каких именно сетевых интерфейсах должен работать сервер).
# Даже если установка клиентского приложения на устройство, с которого необходимо управлять воспроизведением, по каким-то причинам невозможна, то остаётся возможность установить такое клиентское приложение, к которому можно обращаться с других узлов через веб-браузер.
# MPD использует базу данных (как и некоторые другие медиаплееры), чтобы хранить основную информацию о музыкальных файлах (название трека, исполнителя, название альбома и пр.). Как только демон запущен, база данных будет полностью сохранена в оперативной памяти, и нет никакой необходимости обращаться к диску с целью поиска песни и прочтения тегов аудиофайла.
# ------------------------------------------ 
# sudo pacman -S --noconfirm --needed # 
# sudo pacman -S --noconfirm --needed # 
# sudo pacman -S --noconfirm --needed # 
# --------------------------------------------
### yay -S moc --noconfirm  # Консольный аудиоплеер ncurses, разработанный, чтобы быть мощным и простым в использовании
### yay -S mocp --noconfirm  # Консольный аудиоплеер для Linux/Unix, созданный с целью обеспечения мощности и простоты использования. https://github.com/jonsafari/mocp.git ; ! https://help.ubuntu.ru/wiki/mocp -- ! вАЖНО Почитать настройки !!! ; https://moc.daper.net/node/87
yay -S moc-pulse-svn --noconfirm  # Консольный аудиоплеер ncurses с поддержкой PulseAudio (SVN) https://aur.archlinux.org/packages/moc-pulse-svn ; https://aur.archlinux.org/moc-pulse-svn.git (только для чтения, нажмите, чтобы скопировать)
yay -S moc-lyrics-git --noconfirm  # Аудиоплеер для консоли ncurses (с патчем для текстов песен) https://aur.archlinux.org/packages/moc-lyrics-git ; https://aur.archlinux.org/moc-lyrics-git.git (только для чтения, нажмите, чтобы скопировать)
yay -S moc-unstable --noconfirm  # Консольный аудиоплеер ncurses, созданный для того, чтобы быть мощным и простым в использовании. https://aur.archlinux.org/packages/moc-unstable ; https://aur.archlinux.org/moc-unstable.git (только для чтения, нажмите, чтобы скопировать) ; https://moc.daper.net/
yay -S exo-player --noconfirm  # Музыкальный проигрыватель eXo на основе mocp с графикой QT5. (Помечено как устаревшее (2024-06-24)) ; https://aur.archlinux.org/packages/exo-player ; https://aur.archlinux.org/exo-player.git (только для чтения, нажмите, чтобы скопировать)
yay -S mocp-scrobbler --noconfirm  # Скробблер Last.fm для аудиоплеера MOC https://aur.archlinux.org/packages/mocp-scrobbler ; https://aur.archlinux.org/mocp-scrobbler.git (только для чтения, нажмите, чтобы скопировать)
yay -S mocp-themes-git --noconfirm  # Коллекция тем для музыки на консольном плеере https://aur.archlinux.org/packages/mocp-themes-git ; https://aur.archlinux.org/mocp-themes-git.git (только для чтения, нажмите, чтобы скопировать)
yay -S clyrics --noconfirm  # Расширяемый сборщик текстов песен с поддержкой демона для cmus и mocp. https://aur.archlinux.org/packages/clyrics ; https://aur.archlinux.org/clyrics.git (только для чтения, нажмите, чтобы скопировать)
yay -S clyrics-git --noconfirm  # Расширяемый сборщик текстов песен с поддержкой демона для cmus и mocp. https://aur.archlinux.org/packages/clyrics-git ; https://aur.archlinux.org/clyrics-git.git (только для чтения, нажмите, чтобы скопировать)
# -------------------------------
# Music On Console (MOC) — консольный аудиоплеер для UNIX-подобных операционных систем, основанный на библиотеке ncurses.
# Проект был начат Дэмианом Пьетрасом, а в настоящее время разработка поддерживается Джоном Фицджеральдом.
# MOC прост в настройке, поддерживает ALSA, OSS или JACK. Поддерживает команды оболочки, имеет легконастраиваемые цветовые схемы и настройку интерфейса.
# MOC может работать только с одним плей-листом (который поддерживает формат m3u).
# MOC (музыка на консоли) — это консольный аудиоплеер для Linux/Unix, созданный с целью обеспечения мощности и простоты использования.
# Это неофициальное зеркало с несколькими небольшими эстетическими изменениями. Оно синхронизируется с subversion upstream каждые несколько недель. MOC упрощает использование мультимедийных клавиш на вашей клавиатуре, что обсуждается ниже.
# ------------------------------------------
#clear
echo ""   
echo " Установка (пакетов) выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установка мультимедиа утилит из (AUR)"
#echo -e "${BLUE}:: ${NC}Установка Мультимедиа утилит AUR" 
#echo 'Установка Мультимедиа утилит AUR'
# Installing Multimedia utilities AUR
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие утилиты (пакеты): ${NC}"
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - (radiotray-ng, vlc-tunein-radio, vlc-pause-click-plugin, spotify, audiobook-git, cozy-audiobooks, mp3gain, easymp3gain-gtk2, m4baker-git, myrulib-git)."
echo -e "${YELLOW}==> ${NC}Установка будет производится в порядке перечисления (по очереди)"
echo "" 
echo -e "${BLUE}:: ${NC}Установить Интернет-радио плеер RadioTray?" 
echo -e "${MAGENTA}:: ${BOLD}Radio Tray (рус.Радио лоток) - проигрыватель потокового онлайн радио, предназначенный для прослушивания интернет-радиостанций в операционных системах Linux. (https://radiotray.wordpress.com/) ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Radiotray-NG (рус.Радио лоток) - улучшенная версия проигрывателя (radiotray) потокового онлайн радио, предназначенный для прослушивания интернет-радиостанций в операционных системах Linux. (https://github.com/ebruck/radiotray-ng) ${NC}"
echo " Radio Tray не является полнофункциональным музыкальным плеером, уже существует множество отличных музыкальных плееров. Однако было необходимо простое приложение с минимальным интерфейсом только для прослушивания онлайн-радио, не загружая другие плееры типа Amorok или Rhythmbox, а также веб-браузер, тем самым экономя системные ресурсы компьютера и энергопотребление ноутбуков. И это единственная цель Radio Tray. " 
echo " Radio Tray - это бесплатное программное обеспечение, работающее под лицензией GPL. " 
echo -e "${CYAN}:: ${NC}Установка Radio Tray (radiotray), или (radiotray-ng), проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/radiotray/), (https://aur.archlinux.org/packages/radiotray-ng/) - собирается и устанавливается. "
echo " Будьте внимательны! Установка пакета (radiotray) - Закомментирована (двойной ##), если Вам нужен именно этот пакет, то раскомментируйте строки его установки, а строки установки пакета (radiotray-ng) - закомментируйте. В данной опции выбор остаётся за вами. "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_radiotray  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_radiotray" =~ [^10] ]]
do
    :
done 
if [[ $i_radiotray == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_radiotray == 1 ]]; then
  echo ""  
  echo " Установка Интернет-радио плеер Radio Tray "
############ python2-dbus ##########
sudo pacman -S dbus-python --noconfirm  # Привязки Python для DBUS (замена python-dbus , python-dbus-common)  
### sudo pacman -S python-dbus --noconfirm  # Привязки Python для DBUS
### sudo pacman -S python-dbus-common --noconfirm  # Общие файлы dbus-python, общие для python-dbus и python2-dbus
############ python2-gobject ##########
sudo pacman -S python-gobject --noconfirm  # Привязки Python для GLib / GObject / GIO / GTK +
############ python2-lxml ##########
sudo pacman -S python-lxml --noconfirm  # Связывание Python3 для библиотек libxml2 и libxslt (-S python-lxml --force # принудительная установка)
sudo pacman -S python-lxml-docs --noconfirm  # Связывание Python для библиотек libxml2 и libxslt (документы)
############ python2-xdg (python2-pyxdg) ##########
# -> python2-xdg замена на python2-pyxdg
sudo pacman -S python2-pyxdg --noconfirm  # Библиотека Python для доступа к стандартам freedesktop.org
############ python2-notify ##########
yay -S python2-notify --noconfirm # Онлайн-проигрыватель потокового радио, работающий на панели задач Linux 
## git clone https://aur.archlinux.org/python2-notify.git  # Привязки Python для libnotify задач Linux
## cd python2-notify
#makepkg -fsri
# makepkg -si
## makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
## pwd    # покажет в какой директории мы находимся
## cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf python2-notify 
## rm -Rf python2-notify
############ pygtk ##########
yay -S pygtk --noconfirm # Онлайн-проигрыватель потокового радио, работающий на панели задач Linux 
## git clone https://aur.archlinux.org/pygtk.git  # Привязки Python для набора виджетов GTK
## cd pygtk
#makepkg -fsri
# makepkg -si
## makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
## pwd    # покажет в какой директории мы находимся
## cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf pygtk 
## rm -Rf pygtk
############ radiotray ##########  
# yay -S radiotray --noconfirm # Онлайн-проигрыватель потокового радио, работающий на панели задач Linux
yay -S radiotray-ng --noconfirm # Интернет-радио плеер для Linux  
## git clone https://aur.archlinux.org/radiotray.git  # Онлайн-проигрыватель потокового радио, работающий на панели задач Linux
#git clone https://aur.archlinux.org/radiotray-ng.git  # Интернет-радио плеер для Linux
## cd radiotray
#cd radiotray-ng
#makepkg -fsri
# makepkg -si
## makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
## pwd    # покажет в какой директории мы находимся
## cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf radiotray 
# rm -rf radiotray-ng
## rm -Rf radiotray
#rm -Rf radiotray-ng
echo ""
echo " Установка Интернет-радио Radio Tray выполнена "
fi
#-----------------------------
# Домашняя страница:
# http://radiotray.sourceforge.net/
# https://compizomania.blogspot.com/2016/06/radio-tray-ubuntulinux.html
# https://aur.archlinux.org/packages/radiotray/
# https://aur.archlinux.org/packages/radiotray-ng/
# https://github.com/ebruck/radiotray-ng
#-----------------------------

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить дополнения для проигрыватель VLC, если таковой был вами установлен?" 
echo -e "${MAGENTA}:: ${BOLD}В сценарии (скрипте) представлены несколько утилит: ${NC}"
echo " VLC TuneIn Radio (vlc-tunein-radio) - скрипт (сценарий) LUA Service Discovery для VLC 2.x и 3.x, предназначен для прослушивания интернет-радиостанций в операционных системах Linux. " 
echo " VLC Pause Click Plugin (vlc-pause-click-plugin) - плагин для VLC, который приостанавливает / воспроизводит видео по щелчку мыши. Может быть настроена для хорошей работы с двойным щелчком в полноэкранном режиме, включив в настройках параметр - Предотвратить запуск паузы / воспроизведения при двойном щелчке. По умолчанию вместо этого он приостанавливается при каждом щелчке." 
echo -e "${CYAN}:: ${NC}Установка VLC TuneIn Radio (vlc-tunein-radio), и VLC Pause Click Plugin (vlc-pause-click-plugin) проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/vlc-tunein-radio/), (https://aur.archlinux.org/packages/vlc-pause-click-plugin/) - собирается и устанавливается. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " vlc_plugin  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$vlc_plugin" =~ [^10] ]]
do
    :
done
if [[ $vlc_plugin == 0 ]]; then
echo ""  
echo " Установка дополнительных пакетов для проигрыватель VLC пропущена "
elif [[ $vlc_plugin == 1 ]]; then
echo ""
echo " Установка дополнительных пакетов для проигрыватель VLC " 
############ vlc-tunein-radio ##########
# yay -S vlc-tunein-radio --noconfirm  # Скрипт TuneIn Radio LUA для VLC 2.x,3.x
git clone https://aur.archlinux.org/vlc-tunein-radio.git   # Скрипт TuneIn Radio LUA для VLC 2.x,3.x
cd vlc-tunein-radio
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf vlc-tunein-radio 
rm -Rf vlc-tunein-radio
echo ""
echo " Установка VLC TuneIn Radio (vlc-tunein-radio) выполнена "
############ vlc-pause-click-plugin ##########
# yay -S vlc-pause-click-plugin --noconfirm  # Плагин для VLC, который приостанавливает / воспроизводит видео по щелчку мыши
git clone https://aur.archlinux.org/vlc-pause-click-plugin.git  # Плагин для VLC, который приостанавливает / воспроизводит видео по щелчку мыши
cd vlc-pause-click-plugin
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf vlc-pause-click-plugin 
rm -Rf vlc-pause-click-plugin
echo ""
echo " Установка VLC Pause Click Plugin (vlc-pause-click-plugin) выполнена "
fi
#-----------------------------
# https://github.com/diegofn/TuneIn-Radio-VLC
# https://github.com/nurupo/vlc-pause-click-plugin
# Делаем Play и Pause кликом мыши в плеере vlc - Видео
# https://www.youtube.com/watch?v=G05VGD2_jGo&t=1s
#-----------------------------

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Spotify?" 
echo -e "${MAGENTA}:: ${BOLD}Spotify - это популярная на западе платформа для прослушивания музыки и организации плейлистов. ${NC}"
echo " Spotify - это коммерческий музыкальный потоковый сервис, предоставляющий контент с ограниченным управлением цифровыми правами от звукозаписывающих лейблов, включая Sony, EMI, Warner Music Group и Universal. " 
echo " Spotify работает по модели freemium (основные услуги бесплатны, а дополнительные функции предлагаются через платные подписки). Spotify зарабатывает на продаже премиальных потоковых подписок пользователям и размещении рекламы третьим лицам. "
echo -e "${YELLOW}==> Примечание: ${NC}Если Вы хотите воспроизводить локальные файлы, вам необходимо дополнительно установить (пакеты) zenity и ffmpeg-compat-57. Spotify может не открывать ссылки (например, для сброса пароля или входа в систему через Facebook). Чтобы исправить это, установите (пакет) xdg-desktop-portal-gtk." 
echo -e "${CYAN}:: ${NC}Установка Spotify (spotify) проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/spotify/) - собирается и устанавливается. "
echo -e "${CYAN}:: ${NC}Установка дополнительных пакетов для Spotify - (zenity), (xdg-desktop-portal-gtk) проходит из 'Официальных репозиториев Arch Linux' - (Не AUR). Кроме пакета (ffmpeg-compat-57), его установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/ffmpeg-compat-57/) - собирается и устанавливается. "
echo -e "${CYAN}==> Важно! ${NC}В сценарии (скрипте) представлены несколько вариантов установки: " 
echo " Установка Spotify без дополнений и второй вариант Spotify + дополнения (пакеты) (zenity, ffmpeg-compat-57, xdg-desktop-portal-gtk). "
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In this option, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Установить Spotify,     2 - Установить Spotify + дополнения,     

    0 - НЕТ - Пропустить установку: " i_spotify  # sends right after the keypress; # отправляет сразу после нажатия клавиши    
    echo ''
    [[ "$i_spotify" =~ [^120] ]]
do
    :
done 
if [[ $i_spotify == 0 ]]; then 
echo ""   
echo " Установка пропущена "
elif [[ $i_spotify == 1 ]]; then
  echo ""    
  echo " Установка Spotify "
############ spotify ##########
sudo pacman -S --noconfirm --needed playerctl  # Контроллер и библиотека медиаплеера mpris для Spotify, VLC, Audacious, BMP, XMMS2 и других. https://github.com/altdesktop/playerctl ; https://archlinux.org/packages/extra/x86_64/playerctl/
yay -S spotify --noconfirm  # Запатентованный сервис потоковой передачи музыки
## git clone https://aur.archlinux.org/spotify.git  # Запатентованный сервис потоковой передачи музыки
## cd spotify
#makepkg -fsri
# makepkg -si
## makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
## pwd    # покажет в какой директории мы находимся
## cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf spotify 
## rm -Rf spotify
echo ""
echo " Установка Spotify выполнена "
elif [[ $i_spotify == 2 ]]; then
  echo ""    
  echo " Установка Spotify + дополнения "
############ spotify ##########
yay -S spotify --noconfirm  # Запатентованный сервис потоковой передачи музыки
sudo pacman -S zenity --noconfirm  # Отображение графических диалоговых окон из сценариев оболочки (возможно присутствует)
sudo pacman -S xdg-desktop-portal-gtk --noconfirm  # Бэкэнд GTK + для xdg-desktop-portal (возможно присутствует)
## git clone https://aur.archlinux.org/spotify.git  # Запатентованный сервис потоковой передачи музыки
## cd spotify
#makepkg -fsri
# makepkg -si
## makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
## pwd    # покажет в какой директории мы находимся
## cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf spotify 
## rm -Rf spotify
echo ""
echo " Установка Spotify выполнена "
############ openjpeg ##########
# sudo pacman -S openjpeg2 --noconfirm  # Кодек JPEG 2000 с открытым исходным кодом, версия 2.4.0 
yay -S openjpeg --noconfirm  # Кодек JPEG 2000 с открытым исходным кодом
## git clone https://aur.archlinux.org/openjpeg.git  # Кодек JPEG 2000 с открытым исходным кодом
## cd openjpeg
#makepkg -fsri
# makepkg -si
## makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
## pwd    # покажет в какой директории мы находимся
## cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf openjpeg 
## rm -Rf openjpeg
############ ffmpeg-compat-57 ##########
yay -S ffmpeg-compat-57 --noconfirm  # Пакет совместимости для ffmpeg для предоставления 57 версий libavcodec, libavdevice и libavformat, больше не предоставляемых пакетом ffmpeg
## git clone https://aur.archlinux.org/ffmpeg-compat-57.git  # Пакет совместимости для ffmpeg для предоставления 57 версий libavcodec, libavdevice и libavformat, больше не предоставляемых пакетом ffmpeg
## cd ffmpeg-compat-57
#makepkg -fsri
# makepkg -si
## makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
## pwd    # покажет в какой директории мы находимся
## cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ffmpeg-compat-57 
## rm -Rf ffmpeg-compat-57
echo ""
echo " Установка Spotify + дополнения выполнена "
fi
#---------------------------
# https://linuxhint.com/install-spotify-arch-linux/
# https://wiki.archlinux.org/index.php/Spotify 
# https://gitlab.gnome.org/GNOME/zenity
# http://ffmpeg.org/
# https://github.com/flatpak/xdg-desktop-portal-gtk
# https://github.com/uclouvain/openjpeg
# https://www.openjpeg.org
#---------------------------

clear
echo -e "${GREEN}
  <<< Поздравляем! Установка софта (пакетов) завершена! >>> ${NC}"
# Congratulations! Installation is complete.
#echo -e "${GREEN}==> ${NC}Установка завершена!"
#echo 'Установка завершена!'
# The installation is now complete!
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
echo -e "${BLUE}:: ${NC}Если хотите установить дополнительный софт (пакеты), тогда после перезагрузки и входа в систему выполните команду:"
echo -e "${YELLOW}==> ${CYAN}wget git.io/archmy5l && sh archmy5l ${NC}"
# Команды по установке :
# wget git.io/archmy4l 
# sh archmy4l
# wget git.io/archmy4 && sh archmy4l --noconfirm
echo -e "${CYAN}:: ${NC}Цель скрипта (archmy5l) - это установка софта (пакетов), включая установку софта (пакетов) из 'AUR'-'yay', и запуск необходимых служб."
echo -e "${CYAN}:: ${NC}Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов."
echo -e "${GREEN}
  <<< Желаю Вам удачи во всех начинаниях, верных и точных решений! >>> ${NC}"
echo ""
echo -e "${RED}### ${BLUE}########################################################### ${RED}### ${NC}" 
echo -e "${RED}==> ${BOLD}Выходим из установленной системы ${NC}"

echo -e "${BLUE}:: ${BOLD}Теперь вам надо ввести exit, затем перезагрузить систему ${NC}"
echo ""
#echo " Установка завершена для выхода введите >> exit << "
#exit(0)  # означает чистый выход без каких-либо ошибок (проблем)
#exit(1)  # означает, что была какая-то ошибка (проблема), и именно поэтому программа выходит


##### Шпаргалка запуска необходимых служб #####
### systemctl enable NetworkManager
### systemctl enable bluetooth
### systemctl enable cups.service
### systemctl enable sshd
### systemctl enable avahi-daemon
### systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
### systemctl enable reflector.timer
### systemctl enable fstrim.timer
### systemctl enable libvirtd
### systemctl enable firewalld
### systemctl enable acpid

### yay -S qoobar-git --noconfirm  # Qoobar - Аудиотеггер для классической музыки https://aur.archlinux.org/packages/qoobar-git ; https://aur.archlinux.org/packages/qoobar-git ; https://qoobar.sourceforge.io/en/index.htm
# Qoobar - Редактор тегов классической музыки
# Редактор аудио тегов для классической музыки, который может редактировать теги ID3v2.4, Xiph, APE, ASF. Также он позволяет переименовать файлы и заполнить теги, а также работать с группами файлов. Переведен на русский язык.
# Особенности:
# редактирование тегов ID3v2.4, APE, ASF, MP4, комментарии Vorbis;
# редактирование тегов в mp3, ogg, oga, flac, mpc, spx, tta, wv, wma, ape, wav, aif, aiff, opus, m4a, mp4;
# пакетное редактирование тегов файлов - редактирование любых тегов в группе файлов, предоставляя одинаковые значения или отдельные значения;
# легкое копирование и вставка любых тегов между группами файлов;
# редактирование следующих тегов: Композитор, Альбом, Название, Исполнитель, Артист, Дирижер, Оркестр, Подзаголовок, Тональность, Комментарий, Жанр, Год, Номер трека, Всего треков, Исполнитель альбома, Издатель, Удары в минуту (Темп), Оригинальный исполнитель, Авторское право, Номер диска, Всего дисков и многие другие;
# изменение всех тегов, записанных в музыкальных файлах;
# добавление своих собственных тегов;
# создавайте тегов из имен файлов;
# импорт тегов и обложек из Discogs, Musicbraiz, GD3 и freedb;
# переименование / копирование / перемещение файлов согласно их тегам;
# преобразование тегов из локальной кодировки в UTF8;
# редактирование обложек всех поддерживаемых типов файлов;
# отмена любого изменения тегов;
# изменение схемы чтения и записи тегов;
# редактирование тегов при помощи автозаполнения;
# добавление информации ReplayGain в большинство типов файлов;
# Qoobar использует Qt для GUI и Taglib для манипулирования тегами и работает под GNU/Linux, Mac OS X и Windows.
# -------------------------------------------------------------

# ------------------------------------------------------------

# ----------------------------------------------------------


###### MPD - серверное приложение для воспроизведения музыки ####
sudo pacman -S --noconfirm --needed mpd # Гибкое, мощное серверное приложение для воспроизведения музыки https://archlinux.org/packages/extra/x86_64/mpd/ ; https://github.com/MusicPlayerDaemon/MPD
sudo pacman -S --noconfirm --needed mpc  # Минималистичный интерфейс командной строки для MPD
# Демон для воспроизведения музыки различных форматов. Музыка воспроизводится через аудиоустройство сервера. Демон хранит информацию обо всей доступной музыке, и эту информацию можно легко искать и извлекать. Управление проигрывателем, извлечение информации и управление плейлистами можно осуществлять удаленно.
# MPD выпускается под лицензией GNU General Public License версии 2 и распространяется в файле COPYING.

###### AUR MPD - серверное приложение для воспроизведения музыки ####
yay -S mpd-git --noconfirm  # Гибкое, мощное серверное приложение для воспроизведения музыки (из git) https://aur.archlinux.org/packages/mpd-git ; https://aur.archlinux.org/mpd-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/MusicPlayerDaemon/MPD
yay -S mpdm --noconfirm  #  Гибкое, мощное серверное приложение для воспроизведения музыки
sudo pacman -S --noconfirm --needed mpc  # Минималистичный интерфейс командной строки для MPD
yay -S mpdmenu --noconfirm  # dmenu интерфейс для MPD https://aur.archlinux.org/packages/mpdmenu ; https://aur.archlinux.org/mpdmenu.git (только для чтения, нажмите, чтобы скопировать)
yay -S mpdmenu-git --noconfirm  # Простой интерфейс dmenu для MPD https://aur.archlinux.org/packages/mpdmenu-git ; https://aur.archlinux.org/mpdmenu-git.git (только для чтения, нажмите, чтобы скопировать)
# Music Player Daemon (MPD) — музыкальный проигрыватель с клиент-серверной архитектурой, который воспроизводит музыку из указанного каталога. Воспроизведением управляют при помощи клиента. Управлять сервером (демоном) можно с любой машины из сети, но слушать музыку можно и на своём компьютере, если программу-клиент MPD настроить на подключение к локальному хосту (localhost)[1].
# Такая технология имеет ряд преимуществ. Для работы MPD не нужна X Window System, поэтому перезапуск X или закрытие программы-клиента не влияет на проигрывание (есть и клиенты, которые могут работать в командной строке, например, mpc и ncmpc); на сервере с MPD может даже не быть монитора. Воспроизведением можно управлять с других компьютеров, а также мобильных устройств (есть клиентские приложения для iOS, Android, Symbian и многих других платформ). Управлять воспроизведением музыки можно не только через локальную сеть, но и через Интернет (конфигурационный файл позволяет задать, на каких именно сетевых интерфейсах должен работать сервер).
# Даже если установка клиентского приложения на устройство, с которого необходимо управлять воспроизведением, по каким-то причинам невозможна, то остаётся возможность установить такое клиентское приложение, к которому можно обращаться с других узлов через веб-браузер.
# MPD использует базу данных (как и некоторые другие медиаплееры), чтобы хранить основную информацию о музыкальных файлах (название трека, исполнителя, название альбома и пр.). Как только демон запущен, база данных будет полностью сохранена в оперативной памяти, и нет никакой необходимости обращаться к диску с целью поиска песни и прочтения тегов аудиофайла.


### yay -S moc --noconfirm  # Консольный аудиоплеер ncurses, разработанный, чтобы быть мощным и простым в использовании
### yay -S mocp --noconfirm  # Консольный аудиоплеер для Linux/Unix, созданный с целью обеспечения мощности и простоты использования. https://github.com/jonsafari/mocp.git ; ! https://help.ubuntu.ru/wiki/mocp -- ! вАЖНО Почитать настройки !!! ; https://moc.daper.net/node/87
yay -S moc-pulse-svn --noconfirm  # Консольный аудиоплеер ncurses с поддержкой PulseAudio (SVN) https://aur.archlinux.org/packages/moc-pulse-svn ; https://aur.archlinux.org/moc-pulse-svn.git (только для чтения, нажмите, чтобы скопировать)
yay -S moc-lyrics-git --noconfirm  # Аудиоплеер для консоли ncurses (с патчем для текстов песен) https://aur.archlinux.org/packages/moc-lyrics-git ; https://aur.archlinux.org/moc-lyrics-git.git (только для чтения, нажмите, чтобы скопировать)
yay -S moc-unstable --noconfirm  # Консольный аудиоплеер ncurses, созданный для того, чтобы быть мощным и простым в использовании. https://aur.archlinux.org/packages/moc-unstable ; https://aur.archlinux.org/moc-unstable.git (только для чтения, нажмите, чтобы скопировать) ; https://moc.daper.net/
yay -S exo-player --noconfirm  # Музыкальный проигрыватель eXo на основе mocp с графикой QT5. (Помечено как устаревшее (2024-06-24)) ; https://aur.archlinux.org/packages/exo-player ; https://aur.archlinux.org/exo-player.git (только для чтения, нажмите, чтобы скопировать)
yay -S mocp-scrobbler --noconfirm  # Скробблер Last.fm для аудиоплеера MOC https://aur.archlinux.org/packages/mocp-scrobbler ; https://aur.archlinux.org/mocp-scrobbler.git (только для чтения, нажмите, чтобы скопировать)
yay -S mocp-themes-git --noconfirm  # Коллекция тем для музыки на консольном плеере https://aur.archlinux.org/packages/mocp-themes-git ; https://aur.archlinux.org/mocp-themes-git.git (только для чтения, нажмите, чтобы скопировать)
yay -S clyrics --noconfirm  # Расширяемый сборщик текстов песен с поддержкой демона для cmus и mocp. https://aur.archlinux.org/packages/clyrics ; https://aur.archlinux.org/clyrics.git (только для чтения, нажмите, чтобы скопировать)
yay -S clyrics-git --noconfirm  # Расширяемый сборщик текстов песен с поддержкой демона для cmus и mocp. https://aur.archlinux.org/packages/clyrics-git ; https://aur.archlinux.org/clyrics-git.git (только для чтения, нажмите, чтобы скопировать)
# -------------------------------
# Music On Console (MOC) — консольный аудиоплеер для UNIX-подобных операционных систем, основанный на библиотеке ncurses.
# Проект был начат Дэмианом Пьетрасом, а в настоящее время разработка поддерживается Джоном Фицджеральдом.
# MOC прост в настройке, поддерживает ALSA, OSS или JACK. Поддерживает команды оболочки, имеет легконастраиваемые цветовые схемы и настройку интерфейса.
# MOC может работать только с одним плей-листом (который поддерживает формат m3u).
# MOC (музыка на консоли) — это консольный аудиоплеер для Linux/Unix, созданный с целью обеспечения мощности и простоты использования.
# Это неофициальное зеркало с несколькими небольшими эстетическими изменениями. Оно синхронизируется с subversion upstream каждые несколько недель. MOC упрощает использование мультимедийных клавиш на вашей клавиатуре, что обсуждается ниже.
# ------------------------------------------
#############################

# pacman -S zsh-theme-powerlevel10k  --noconfirm  # Powerlevel10k - это тема для Zsh. Он подчеркивает скорость, гибкость и готовность к работе. (https://github.com/romkatv/powerlevel10k)






























































