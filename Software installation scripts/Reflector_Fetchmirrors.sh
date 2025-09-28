#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! ####

apptitle="Arch Linux Fast Install v2.5 LegasyBIOS - Version: 2025.07.09.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя
###
REFLECTOR_FETCHMIRRORS_LANG="russian"  # Installer default language (Язык установки по умолчанию)
ARCHMY5L_LANG="russian"  # Installer default language (Язык установки по умолчанию)
script_path=$(readlink -f ${0%/*})  # эта опция канонизируется путем рекурсивного следования каждой символической ссылке в каждом компоненте данного имени; все, кроме последнего компонента должны существовать
###
umask 0022 # Определение окончательных прав доступа - Для суперпользователя (root) umask по умолчанию равна 0022
set -e # Эта команда остановит выполнение сценария после сбоя команды и будет отправлен код ошибки
# set -euxo pipefail  # прекращает выполнение скрипта, даже если одна из частей пайпа завершилась ошибкой
# set -e "\n${RED}Error: ${YELLOW}${*}${NC}"  # Эта команда остановит выполнение сценария после сбоя команды и будет отправлен код ошибки
#####################
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
В процессе работы сценария (скрипта) Вам будут задаваться вопросы на установку той, или иной утилиты (пакета) - будьте внимательными! Устанавливаемый софт (пакеты) - скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. Так же присутствует софт (пакеты) - устанавливаемый из пользовательского репозитория 'AUR'-'yay', собираются и устанавливаются. Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска необходимых служб. В любой ситуации выбор всегда за вами. Вы либо гуляете под дождем, либо просто под ним мокнете. ${RED}

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

sleep 10
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
echo -e "${CYAN}:: ${NC}Установка fetchmirrors проходит через сборку из исходников AUR. Установка производиться с помощью git clone (https://aur.archlinux.org/fetchmirrors.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/fetchmirrors/), собирается и устанавливается."
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
########## reflector-simple ##########
# yay -S reflector-simple --noconfirm  # Простая оболочка графического интерфейса для reflector (отражателя)
########## reflector-simple ##########
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
##### fetchmirrors ######
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
########## reflector-simple ##########
# yay -S reflector-simple --noconfirm  # Простая оболочка графического интерфейса для reflector (отражателя)
########## reflector-simple ##########
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
##### fetchmirrors ######
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
############ Справка ##############
# https://github.com/endeavouros-team/PKGBUILDS/tree/master/reflector-simple
# https://github.com/deadhead420/fetchmirrors
# https://dev.maxmind.com/geoip/legacy/downloadable/
# https://github.com/v1cont/yad
# ДЛЯ ПАРАНОИКОВ!!! (FOR THE PARANOID)
# GEOIP - Это публичная база данных соответствий IP-страна. IP-город (city database) там тоже есть, но полная версия - платная ЕМНИП.
# Нужно всяким пакетам типа wireshark, pmacct и т.д. чтобы выводить информацию по IP-адресам
# Эта штука сама по себе ничего отследить не может. Это база соответствий IP-адресов странам. Если провести аналогию с телефонными номерами, то это как справочник, где указано, какой телефонный код относится к какой стране (+7 = Россия, +1 = США и пр.). За деньги можно купить список кодов городов.
# https://www.8host.com/blog/opredelenie-mestopolozheniya-polzovatelya-pri-pomoshhi-geoip-i-elk/
##########################

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
echo -e "${CYAN}:: ${NC}Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов."
echo -e "${GREEN}
  <<< Желаю Вам удачи во всех начинаниях, верных и точных решений! >>> ${NC}"
echo ""
echo -e "${RED}### ${BLUE}########################################################### ${RED}### ${NC}"
echo -e "${RED}==> ${BOLD}Выходим из установленной системы ${NC}"
echo ""
echo -e "${BLUE}:: ${BOLD}Теперь вам надо ввести exit, затем перезагрузить систему ${NC}"
echo ""
### end of script