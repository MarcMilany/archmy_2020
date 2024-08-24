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

KEA_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
  <<< Установка DHCP-сервера - по вашему выбору и желанию >>> ${NC}"
echo ""
echo -e "${GREEN}==> ${NC}Установить Kea (kea) Отказоустойчивый DHCP-сервер Internet Systems Consortium (ISC)?"
echo " Более старый DHCPD (dhcpd) больше не поддерживается!!! ISC – это те же ребята, которые разрабатывают наши любимые bind и dhcpd. Kea – разработана на базе BIND 10. Kea DHCP – поддерживает хранение базы выданных адресов в локальном CSV-файле(memfile) или в одной из трёх СУБД – MySQL, PostgreSQL и Cassandra."
echo -e "${CYAN}:: ${NC}Kea — это новейший DHCP-сервер Internet Systems Consortium (ISC).Файлы конфигурации находятся в /etc/kea. Содержимое файлов конфигурации использует структуры JSON. Для специальных конфигураций, которые еще не включены в следующие примеры, обратитесь к документации Kea (https://kea.readthedocs.io/ ; https://wiki.archlinux.org/title/Kea ; https://habr.com/ru/articles/458180/). "
echo -e "${YELLOW}==> ${NC}Kea — это система программного обеспечения с открытым исходным кодом, включающая серверы DHCPv4, DHCPv6, динамический DNS-демон, интерфейс REST API, базы данных MySQL и PostgreSQL, интерфейсы RADIUS и NETCONF, а также соответствующие утилиты. Kea предлагает широкую поддержку основных стандартов DHCPv4 и DHCPv6, включая как прямое назначение адресов, так и делегирование префиксов DHCPv6, а также динамические и статические адреса. Kea был разработан для легкого расширения путем добавления дополнительных библиотек "hooks". ISC публикует некоторые из них в открытом исходном коде, а другие предлагает как премиум-программное обеспечение. Используя hooks, можно контролировать назначение опций и даже адресов из вашей собственной системы предоставления. Использованная литература:(https://kea.isc.org/ ; https://wiki.archlinux.org/title/Kea)"
echo " Добавляйте и изменяйте подсети и пулы без перезапуска Kea. Сохраняйте аренду и резервирование хостов в базе данных MySQL или PostgreSQL или локальном текстовом файле. Замените всю конфигурацию Kea или управляйте арендой, подсетями и резервированием хостов по отдельности через REST API. Если вы используете службу DHCPD (что, скорее всего), то следует отключить dhcpd (больше не поддерживается)! systemctl stop dhcpcd.service  # Чтобы остановить службу dhcpd ; systemctl disable dhcpcd.service "
echo " Если необходимо добавить службу Kea в автозагрузку и сделать необходимые настройки (конфиги) это можно сделать уже в установленной системе Arch'a "
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_kea  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_kea" =~ [^10] ]]
do
    :
done 
if [[ $i_kea == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_kea == 1 ]]; then
  echo ""
  echo " Установка Kea (kea) DHCP-сервера "
  sudo pacman -S --noconfirm --needed kea  # Высокопроизводительный, расширяемый серверный движок DHCP от ISC, поддерживающий как DHCPv4, так и DHCPv6 ; https://kea.isc.org/ ; https://archlinux.org/packages/extra/x86_64/kea/ ; https://wiki.archlinux.org/title/Kea
  sudo pacman -S --noconfirm --needed kea-docs  # Высокопроизводительный, расширяемый серверный движок DHCP от ISC, поддерживающий DHCPv4 и DHCPv6 (документация пользователя и разработчика) ; https://kea.isc.org/ ; https://archlinux.org/packages/extra/x86_64/kea-docs/ ; https://wiki.archlinux.org/title/Kea
# kea-dhcp4 -t /etc/kea/kea-dhcp4.conf  # Файл конфигурации можно проверить на наличие ошибок
# systemctl enable kea-dhcp4 --now  # Если все в порядке, включите и запустите Kea
# journalctl -u kea-dhcp4.service  # Проверьте вывод журнала Kea
  echo " Отключения Службы Dhcpcd (реализация клиента DHCP и DHCPv6) "
###### Отключить dhcpcd #######  
  sudo systemctl stop dhcpcd
  sudo systemctl disable dhcpcd
# systemctl disable dhcpcd && systemctl stop dhcpcd
  echo " Служба Dhcpcd (реализация клиента DHCP и DHCPv6) ОСТАНОВЛЕНА И ОТКЛЮЧЕНА!!! "
  echo ""
  echo " Чтобы использовать DHCP для IPv4, необходимо адаптировать файл конфигурации , а также активировать и запустить /etc/kea/kea-dhcp4.conf службу .kea-dhcp4.service "
echo " Проверить файл конфигурации /etc/kea/kea-dhcp4.conf на наличие ошибок "
kea-dhcp4 -t /etc/kea/kea-dhcp4.conf
  echo " Добавим Kea (kea) DHCP-сервер в автозагрузку (для проводного интернета, DNS, DHCP, объявление маршрутизатора и сетевая загрузка). "
############# DHCP для IPv4 #############  
sudo systemctl enable kea-dhcp4.service  # Чтобы использовать DHCP для IPv4
sudo systemctl start kea-dhcp4.service   # Then start/enable kea-dhcp4.service
# sudo systemctl status kea-dhcp4.service
############ DHCP для IPv6 ##############
#sudo systemctl enable kea-dhcp6.service  # Чтобы использовать DHCP для IPv6
#sudo systemctl start kea-dhcp6.service
# sudo systemctl status kea-dhcp6.service
############ Демон обновления DNS ##############
sudo systemctl enable kea-dhcp-ddns.service  # Чтобы обновить DNS
sudo systemctl start  kea-dhcp-ddns.service
# sudo systemctl status kea-dhcp-ddns.service
############ Интерфейс для управления серверами Kea ##############
#sudo systemctl enable kea-ctrl-agent.service  # Предоставление REST- интерфейса для управления серверами Kea
#sudo systemctl start kea-ctrl-agent.service   # Then start/enable kea-ctrl-agent.service
# sudo systemctl status kea-ctrl-agent.service
  echo " Kea (kea) DHCP-сервер успешно добавлен в автозагрузку "
  echo ""
  echo " Установка утилит (пакетов) выполнена "
fi
###########
# Логи по умолчанию хранятся — /usr/local/var/log/
# Тут у каждого из компонентов отдельный файл:
# kea-dhcp4.log
# kea-dhcp6.log
# kea-ctrl-agent.log
# CSV-база: Локальная база хранится тут — /usr/local/var/kea/kea-leases4.csv
##############

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