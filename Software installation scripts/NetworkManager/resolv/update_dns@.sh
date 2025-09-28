#!/bin/bash
# loadkeys ru
# setfont cyr-sun16
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 
# Запуск скрипта выполняется командой через [sudo] !!!
# Пример запуска: sudo sh Пропишем службу обновления DNS.sh
apptitle="Arch Linux Fast Install v2.4 LegasyBIOS - Version: 2024.07.31.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

UPDATE_DNS="russian"  # Installer default language (Язык установки по умолчанию)

script_path=$(readlink -f ${0%/*})  # PATH операционная система Linux находит и запускает исполняемые файлы утилит. ; readlink, readlinkat - прочитать значение символической ссылки

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
    echo -e "${RED}
    ***************************** ВНИМАНИЕ! ***************************** 
${NC}
Автор не несёт ответственности за любое нанесение вреда при использовании скрипта. 
Вы используйте его на свой страх и риск, или изменяйте под свои личные нужды.
В данный момент сценарий (скрипта) находится в процессе доработки и небольшой корректировке (Воен. Внесение поправок в наводку орудий по результатам наблюдений с наблюдательных пунктов).

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
########

clear
echo ""
echo -e "${GREEN}==> ${NC}Пропишем службу обновления DNS для использования с systemd"
echo -e "${BLUE}:: ${BOLD}Наша сетевая карта получает все настройки для того, чтобы работала сеть и Интернет. Но названия сайтов переводиться в IP адреса не будут, т.к. наша система не знает, какие серверы DNS следует для этого использовать. Напишем собственную службу для этих целей, которую при загрузке будет запускать systemd. А чтобы узнать что-то новое и не заскучать от однообразия, передадим информацию о названии сетевого устройства в качестве параметра, а список DNS серверов сохраним во внешнем файле. ${NC}"
echo -e "${CYAN}:: ${NC}Нам нужно получать информацию о DNS серверах до того, как система будет уверена, что сеть полностью работает, т.е. до достижения цели network.target."
echo -e "${YELLOW}:: ${NC}Будем считать, что информацию о серверах нам достаточно обновлять один раз во время загрузки. И стандартно скажем, что нашу службу требует цель multi-user.target."
echo -e "${YELLOW}:: ${NC}Создаём файл запуска службы update_dns@.service в каталоге /etc/systemd/system/"
echo -e "${RED}=> ${NC}Универсальность этого метода заключается в том что, если в нашей системе окажется несколько сетевых адаптеров, то для каждого из них мы сможем указать свои собственные DNS серверы. Нужно будет просто подготовить набор файлов со списком серверов для каждого из устройств и запускать службу для каждого адаптера в отдельности указывая его имя после @."
echo " После запуска службу в автозагрузку не забывая указать имя сетевой карты после @. "
echo " Будьте внимательны! Вы можете пропустить это действие. В данной опции выбор всегда остаётся за вами. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да создать,    0 - Нет пропустить: " x_resolvconf  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_resolvconf" =~ [^10] ]]
do
    :
done
 if [[ $x_resolvconf == 0 ]]; then
echo ""
echo " Создание и запуск пропущен " 
elif [[ $x_resolvconf == 1 ]]; then
echo ""
echo " Создаём файл запуска службы в каталоге со следующим содержанием: "
echo " Это позволяет применять (указать) свои собственные DNS серверы "
# echo " Создадим папку /system в директории /etc/systemd/ "
# mkdir /etc/systemd/system
echo " Создадим файл запуска службы update_dns@.service в каталоге /etc/systemd/system/ "
touch /etc/systemd/system/update_dns@.service
echo " Пропишем нужные нам значения в созданном файле update_dns@.service "
> /etc/systemd/system/update_dns@.service
cat <<EOF >>/etc/systemd/system/update_dns@.service
[Unit]
Description=Manual resolvconf update (%i)
Before=network.target

[Service]
Type=oneshot
EnvironmentFile=/etc/default/dns@%i
ExecStart=/usr/bin/sh -c 'echo -e "nameserver ${DNS0}\nnameserver ${DNS1}" | resolvconf -a %i'

[Install]
WantedBy=multi-user.target

EOF
####
echo " Создадим файл dns@eth0 в каталоге /etc/default/ "
touch /etc/default/dns@eth0
echo " Пропишем нужные нам значения в созданном файле dns@eth0 "
> /etc/default/dns@eth0
cat <<EOF >>/etc/default/dns@eth0
#
# Яндекс.DNS IPv4
# Базовый - Быстрый и надежный DNS
#DNS0=77.88.8.8  
#DNS1=77.88.8.1
#
# Яндекс.DNS IPv6
#2a02:6b8::feed:0ff
#2a02:6b8:0:1::feed:0ff 

# Безопасный - Без мошеннических сайтов и вирусов
#DNS0=77.88.8.88
#DNS1=77.88.8.2
#
# Яндекс.DNS IPv6
#2a02:6b8::feed:bad
#2a02:6b8:0:1::feed:bad 

# Семейный - Без сайтов для взрослых
#DNS0=77.88.8.7
#DNS1=77.88.8.3
#
# Яндекс.DNS IPv6
#2a02:6b8::feed:a11 
#2a02:6b8:0:1::feed:a11

# Cloudflare's nameservers, for example
# It is claimed that the "Privacy first" policy is used, so that users can be calm about the content of their requests.
DNS0=1.1.1.1  
DNS1=1.0.0.1

#
# Google Public DNS IPv4
# Общественный - Служба Google DNS (8.8.8.8) получила поддержку протокола безопасности DNS-over-TLS
#DNS0=8.8.8.8  
#DNS1=8.8.4.4
#
# Google Public DNS IPv6
#2001:4860:4860::8888
#2001:4860:4860::8844

#
# OpenDNS DNS Servers (IPv4 DNS Servers)
#DNS0=208.67.222.222  
#DNS1=208.67.220.220

#
# Wired Internet from Beeline (corbina)(tp.internet.beeline.ru)
#DNS0=85.21.192.5  
#DNS1=213.234.192.7

#
# Localhost
# A standard, officially reserved domain name for private IP addresses on computer networks
#DNS0=::1  
#DNS1=127.0.0.1
#DNS1=127.0.1.1

EOF

echo " Теперь добавляем службу в автозагрузку не забывая указать имя сетевой карты после @: "
systemctl enable update_dns@eth0.service
#systemctl status update_dns@eth0.service
fi
sleep 01
########### Справка ###########
# Яндекс.DNS - Безопасный домашний интернет (Высокая скорость; Защита от вирусов и мошенников; Безопасность для детей)
# Скорость работы Яндекс.DNS во всех трёх режимах одинакова. В Базовом режиме не предусмотрена какая-либо фильтрация трафика. В Безопасном режиме обеспечивается защита от заражённых и мошеннических сайтов. Семейный режим включает защиту от опасных сайтов и блокировку сайтов для взрослых.
# Как работает Яндекс.DNS: У Яндекса - более 80 DNS-серверов, расположенных в разных городах и странах. Запросы каждого пользователя обрабатывает ближайший к нему сервер, поэтому с Яндекс.DNS в Базовом режиме сайты открываются быстрее.
# Что такое DNS: DNS - это адресная книга интернета, где указан цифровой адрес каждого сайта. Например, yandex.ru живёт по адресу 213.180.204.11.
# Каждый раз, когда вы заходите на веб-страницу, браузер ищет её адрес в системе DNS. Чем быстрее работает ближайший к вам DNS-сервер, тем быстрее откроется сайт.
# Google Public DNS - бесплатный глобальный сервис системы доменных имен (DNS), используемый в качестве альтернативы DNS вашего интернет-провайдера. Преимущества: повышенная скорость, надежность и безопасность интернет-соединения
# Google Public DNS - альтернативный DNS-сервер, разрабатываемый Google. Сервис обеспечивает ускорение загрузки веб-страниц за счет повышения эффективности кэширования данных, а также улучшенную защиту от атак "IP-спуфинг" и "Отказ в обслуживании (DoS)".
##########################
echo " Добавляем службу systemd-resolved в автозагрузку "
sudo systemctl enable systemd-resolved
#systemctl restart systemd-resolved
# sudo systemctl status systemd-resolved
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