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

DNSmasq_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
echo -e "${GREEN}==> ${NC}Установить DNSmasq сервер пересылки DNS и DHCP-сервер?"
echo " Также добавим dnsmasq в автозагрузку (для проводного интернета, который получает настройки от роутера). "
echo -e "${CYAN}:: ${NC}DNSmasq - DNS-сервер, DHCP-сервер с поддержкой DHCPv6 и PXE и ​​TFTP-сервер. Легкий и имеет небольшой размер, простой в настройке сервер пересылки DNS и DHCP-сервер, подходит для маршрутизаторов и брандмауэров с ограниченными ресурсами. DNSmasq также может быть настроен для кэширования DNS-запросов для улучшения скорости поиска DNS на ранее посещенных сайтах. "
echo -e "${YELLOW}==> ${NC}Будьте внимательны! При запуске сервера dnsmasq - служба Dhcpcd (реализация клиента DHCP и DHCPv6) будет ОСТАНОВЛЕНА И ОТКЛЮЧЕНА!!! Также перед запуском сервера dnsmasq нужно будет отредактировать в /etc/ файлы dnsmasq.conf ; resolv.conf Обязательно защитите его от изменений (перезаписи) как описано (https://wiki.archlinux.org/title/Domain_name_resolution#Overwriting_of_/etc/resolv.conf) ; resolvconf.conf ; dnsmasq-resolv.conf ; NetworkManager.conf ;  создать файл /etc/NetworkManager/dnsmasq.d/cache.conf  и отредактировать его. Использованная литература:(https://wiki.archlinux.org/title/Dnsmasq ; https://wiki.archlinux.org/title/Dnsmasq#Test ; https://eax.me/archlinux-on-desktop/)"
echo " Если вы используете NetworkManager (что, скорее всего, так и есть), то сделайте /etc/resolv.conf его неизменяемым, чтобы избежать перезаписи файла после перезагрузки. (sudo chattr +i /etc/resolv.conf) "
echo " Если необходимо добавить службу DNSmasq в автозагрузку и сделать необходимые настройки (конфиги) это можно сделать уже в установленной системе Arch'a "
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Установить и Включить dnsmasq,    0 - Нет - пропустить этот шаг: " x_dnsmasq   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_dnsmasq" =~ [^10] ]]
do
    :
done
if [[ $x_dnsmasq == 0 ]]; then
 echo ""   
 echo " Установка утилит (пакетов) пропущена " 
elif [[ $x_dnsmasq == 1 ]]; then
  echo ""
  echo " Установка DNSmasq сервера " 
sudo pacman -S --noconfirm --needed dnsmasq  # Легкий, простой в настройке сервер пересылки DNS и DHCP-сервер ; http://www.thekelleys.org.uk/dnsmasq/doc.html ; https://archlinux.org/packages/extra/x86_64/dnsmasq/
# Dnsmasq предоставляет сетевую инфраструктуру для небольших сетей: DNS, DHCP, объявление маршрутизатора и сетевая загрузка.
#sudo pacman -Syu --noconfirm --needed dnsmasq
sudo systemctl disable dnsmasq  # Ставим dnsmasq, но убеждаемся, что он выключен
  # systemctl status dnsmasq.service
  echo " Отключения Службы Dhcpcd (реализация клиента DHCP и DHCPv6) "
###### Отключить dhcpcd #######  
sudo systemctl stop dhcpcd
sudo systemctl disable dhcpcd
# systemctl disable dhcpcd && systemctl stop dhcpcd
  echo " Служба Dhcpcd (реализация клиента DHCP и DHCPv6) ОСТАНОВЛЕНА И ОТКЛЮЧЕНА!!! "
  echo ""
  echo " Добавим dnsmasq в автозагрузку (для проводного интернета, DNS, DHCP, объявление маршрутизатора и сетевая загрузка). "
sudo systemctl enable dnsmasq.service  
sudo systemctl start dnsmasq.service   # Then start/enable dnsmasq.service
# sudo systemctl enable dnsmasq && systemctl start dnsmasq
# sudo systemctl status dnsmasq.service
  echo " DNSmasq успешно добавлен в автозагрузку "
fi
  echo " Чтобы выполнить тест скорости поиска, выберите веб-сайт, который не посещался с момента запуска dnsmasq "
sudo drill archlinux.org | grep "Query time"  # Тест dnsmasq
  echo " Выполним опрос DNS-сервера: '1.1.1.1' (@cервер) с запросом archlinux.org (доменное имя интернет-ресурса) "
sudo dig @1.1.1.1 archlinux.org  # для опроса DNS-серверов
######################
sleep 3

clear
echo ""
echo -e "${GREEN}==> ${NC}Настройка DNSmasq сервер пересылки DNS и DHCP-сервер"
echo " Настройка dnsmasq для сокращения времени, затрачиваемого на разрешение DNS. "
echo " Если вы используете NetworkManager (что, скорее всего, так и есть), то сделайте /etc/resolv.conf его неизменяемым, чтобы избежать перезаписи файла после перезагрузки. (sudo chattr +i /etc/resolv.conf) "
echo " Если необходимо добавить службу DNSmasq в автозагрузку и сделать необходимые настройки (конфиги) это можно сделать уже в установленной системе Arch'a "
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Настроить dnsmasq,    0 - Нет - пропустить этот шаг: " x_dnsmasqс   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_dnsmasqс" =~ [^10] ]]
do
    :
done
if [[ $x_dnsmasqс == 0 ]]; then
 echo ""   
 echo " Настройка DNSmasq сервера пропущена " 
elif [[ $x_dnsmasqс == 1 ]]; then
  echo ""
  echo " Настройка DNSmasq сервера " 
echo " Создать файл dnsmasq.conf в /etc "
### Теперь анонсируем через него наш сервер
# nano /etc/dnsmasq.conf
touch /etc/dnsmasq.conf   # Создать файл dnsmasq.conf в /etc
ls -l /etc/dnsmasq.conf   # ls — выводит список папок и файлов в текущей директории
sleep 1
echo " Пропишем конфигурацию для dnsmasq в /etc/dnsmasq.conf "
> /etc/dnsmasq.conf
cat <<EOF >>/etc/dnsmasq.conf
 listen-address=::1,127.0.0.1
 cache-size=1000
 no-resolv
 server=8.8.8.8
 server=8.8.4.4

EOF
######################
echo ""
echo " Для начала сделаем его бэкап /etc/dnsmasq.conf "
cp /etc/dnsmasq.conf  /etc/dnsmasq.conf.back_`date +"%d.%m.%y_%H-%M"`
echo ""
echo " Просмотреть содержимое файла /etc/dnsmasq.conf "
cat /etc/dnsmasq.conf  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 3
###################
echo ""
echo " Редактировать файл resolv.conf в /etc "
echo -e "${YELLOW}==> ${NC}В идеале отключитесь от сети/интернета, затем откройте файл /etc/resolv.conf и измените его по своему усмотрению! Но мы же НЕ ищем лёгких путей и попробуем так! "
echo " Разблокируем файл resolv.conf в /etc (который был заблокирован даже для суперпользователя, чтобы предотвратить перезапись программами /etc/resolv.conf, был установлен атрибут неизменяемости: chattr +i /etc/resolv.conf ) "
### Чтобы разблокировать файл, введите в терминале следующее:
sudo chattr -i /etc/resolv.conf
echo " Пропишем конфигурацию для resolv в /etc/resolv.conf "
> /etc/resolv.conf
cat <<EOF >>/etc/resolv.conf
 nameserver ::1
 nameserver 127.0.0.1
 options trust-ad

EOF
######################
echo ""
echo " Просмотреть содержимое файла resolv.conf "
cat /etc/resolv.conf  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 3
######################
echo ""
echo " Вновь заблокируем содержимое файла resolv.conf "
echo " Это заблокирует файл /etc/resolv.conf, никто не сможет его редактировать. Даже суперпользователь не сможет этого сделать (sudo). (Если, конечно, вы не разблокируете файл) (sudo chattr -i /etc/resolv.conf) "
### отключитесь от сети/интернета, затем откройте файл /etc/resolv.conf и измените его по своему усмотрению!
sudo chattr +i /etc/resolv.conf
######################
echo ""
echo " Далее отредактируйте содержимое файла NetworkManager.conf в /etc/NetworkManager/ "
echo " Раскомментируйте строку #dns=dnsmasq в разделе [main], которая ранее была прописана при установки системы в NetworkManager.conf "
sudo sed -i 's/#dns=dnsmasq/dns=dnsmasq/' /etc/NetworkManager/NetworkManager.conf  # раскомментируем в /etc/NetworkManager/NetworkManager.conf
# sudo sed -i '/#dns=dnsmasq/ s/^#//' /etc/NetworkManager/NetworkManager.conf
######################
echo ""
echo " Увеличим размер кэша (по умолчанию хранится 450 записей) для dnsmasq "
echo " Создать файл cache.conf в /etc/NetworkManager/dnsmasq.d/ "
### Теперь анонсируем через него наш сервер
# nano /etc/NetworkManager/dnsmasq.d/cache.conf
touch /etc/NetworkManager/dnsmasq.d/cache.conf   # Создать файл dnsmasq.conf в /etc
ls -l /etc/NetworkManager/dnsmasq.d   # ls — выводит список папок и файлов в текущей директории
sleep 1
echo " Пропишем конфигурацию для dnsmasq в /etc/NetworkManager/dnsmasq.d/cache.conf "
> /etc/NetworkManager/dnsmasq.d/cache.conf
cat <<EOF >>/etc/NetworkManager/dnsmasq.d/cache.conf
 cache-size=10000

EOF
######################
cat /etc/NetworkManager/dnsmasq.d/cache.conf  # cat читает данные из файла или стандартного ввода и выводит их на экран
###################
echo ""
echo " Отключение systemd-resolved не было для меня опцией, потому что мне нужно было обрабатывать полученные исходящие DNS-серверы через DHCP "
echo " Моим решением было сделать dnsmasq stop systemd-resolved перед запуском и запустить его потом снова "
echo " Создать дроп-ин конфигурацию в /etc/systemd/system/dnsmasq.service.d/resolved-fix.conf "
echo " Создать файл resolved-fix.conf в /etc/systemd/system/dnsmasq.service.d/ "
### Теперь анонсируем через него наш сервер
# nano /etc/NetworkManager/dnsmasq.d/cache.conf
touch /etc/systemd/system/dnsmasq.service.d/resolved-fix.conf   # Создать файл resolved-fix.conf в /etc/systemd/system/dnsmasq.service.d/
ls -l /etc/systemd/system/dnsmasq.service.d   # ls — выводит список папок и файлов в текущей директории
sleep 1
echo " Пропишем конфигурацию для dnsmasq в /etc/NetworkManager/dnsmasq.d/cache.conf "
echo " Это выглядит довольно хакерским решением, но оно работает "
> /etc/systemd/system/dnsmasq.service.d/resolved-fix.conf
cat <<EOF >>/etc/systemd/system/dnsmasq.service.d/resolved-fix.conf
[Unit]
After=systemd-resolved.service

[Service]
ExecStartPre=/usr/bin/systemctl stop systemd-resolved.service
ExecStartPost=/usr/bin/systemctl start systemd-resolved.service

EOF
######################
echo ""
echo " Просмотреть содержимое файла resolv.conf "
cat /etc/systemd/system/dnsmasq.service.d/resolved-fix.conf  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 3
############
echo " Перезапустить dnsmasq "
sudo systemctl restart dnsmasq   # Перезапустить dnsmasq
# sudo systemctl enable dnsmasq && systemctl start dnsmasq
# sudo systemctl status dnsmasq.service
### Остановите dhcpcd , он нам больше не нужен.
# sudo systemctl disable dhcpcd && systemctl stop dhcpcd
sudo systemctl restart NetworkManager
echo " Теперь NetworkManager будет автоматически запускать dnsmasq с нужными параметрами "
fi
### Настройка DNSmasq:
# Настройка dnsmasq для сокращения времени, затрачиваемого на разрешение DNS
# Редактировать/etc/dnsmasq.conf Раскомментируйте и приведённые ниже строки в файле или просто добавьте их к нему
# listen-address=::1,127.0.0.1
# cache-size=1000
# no-resolv
# server=8.8.8.8
# server=8.8.4.4
### Редактировать/etc/resolv.conf
# nameserver ::1
# nameserver 127.0.0.1
# options trust-ad
### Если вы используете NetworkManager (что, скорее всего, так и есть), то сделайте /etc/resolv.confего неизменяемым , чтобы избежать перезаписи файла после перезагрузки
# sudo chattr +i /etc/resolv.conf
### Далее в /etc/NetworkManager/NetworkManager.conf пишем:
# [main]
# dns=dnsmasq
### Чтобы увеличить размер кэша (по умолчанию хранится 450 записей), создайте файл /etc/NetworkManager/dnsmasq.d/cache.conf с таким содержимым:
# cache-size=10000
### Перезапустить dnsmasq
# sudo systemctl restart dnsmasq
### Остановите dhcpcd , он нам больше не нужен.
# sudo systemctl disable dhcpcd && systemctl stop dhcpcd
### Затем говорим:
# sudo systemctl restart NetworkManager
### Теперь NetworkManager будет автоматически запускать dnsmasq с нужными параметрами и прописывать его в /etc/resolv.conf. Для получения информации о текущем статусе dnsmasq можно сказать:
# sudo killall -s USR1 dnsmasq
# … и почитать вывод journalctl -r.
### Использованная литература: dnsmasq  (https://wiki.archlinux.org/title/Dnsmasq)
########################

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