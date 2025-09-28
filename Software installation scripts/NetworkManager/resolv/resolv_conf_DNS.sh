#!/bin/bash
# loadkeys ru
# setfont cyr-sun16
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 
# Запуск скрипта выполняется командой через [sudo] !!!
# Пример запуска: sudo sh resolv_conf _DNS.sh
apptitle="Arch Linux Fast Install v2.4 LegasyBIOS - Version: 2024.07.31.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

RESOLV_CONF_DNS="russian"  # Installer default language (Язык установки по умолчанию)

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
echo -e "${CYAN}
  <<< Пропишем обновления DNS для использования с systemd в системе Arch Linux >>> ${NC}"
echo ""
echo -e "${GREEN}==> ${NC}Обновим DNS системы в (/etc/resolv.conf)?" 
echo -e "${CYAN}=> ${BOLD}Файл /etc/resolv.conf это файл конфигурации для процедур сервера имен. Файл конфигурации содержит информацию, которая читается процедурами разрешения имен при первом их вызове процессом. Процедуры обеспечивают доступ к системе доменных имен. Служба доменных имен (DNS): - Файл host.conf ; - Файл /etc/resolv.conf ; - Организация собственного сервера имен: демон named. Каждый компьютер, подключенный к сети, работающей по протоколу TCP/IP (например, к Internet), идентифицируется своим IP-адресом. IP-aдрес представляет собой комбинацию четырех чисел, определяющих конкретную сеть и конкретный хост-компьютер в этой сети. IP-адреса очень трудно запоминать, поэтому для идентификации хост-компьютера вместо его IP-адрреса можно пользоваться доменным именем. Доменное имя состоит из двух частей - хост-имени и имени домена. Хост-имя - это собственно имя компьютера, а домен обозначает сеть, частью которой этот компьютер является. Домены, используемые в США, обычно имеют расширения, обозначающие тип сети. В фале resolv.conf содержатся адреса серверов имен, к которым имеет доступ данная система. В этом файле можно создавать три типа записей, каждая из которых предваряется одним из трех ключевых слов: domain, nameserver, search. В записи domain вводится доменное имя локальной системы. В записи search приводится список доменов на тот случай, если задается только хост-имя. Если к какой-либо системе пользователь обращается часто, он может ввести имя ее домена в запись search, а затем использовать в качестве адреса только хост-имя. ${NC}"
echo -e "${RED}==> Важно! ${NC}Каждый раз, когда вы подключаетесь к Интернету, файл /etc/resolv.conf изменяется."
echo " Поэтому любые изменения, которые вы могли внести в /etc/resolv.conf, будут отменены, и файл будет перезаписан, вероятно, с чем-то вроде «nameserver 192.168.1.1» или любым другим IP-адресом вашего маршрутизатора (интернет-провайдера)..." 
echo -e "${YELLOW}==> Примечание: ${BOLD}Если вы используете NetworkManager (что, скорее всего, так и есть), то сделайте /etc/resolv.conf его неизменяемым, чтобы избежать перезаписи файла после перезагрузки. ${NC}"
echo -e "${YELLOW}==> Примечание: ${BOLD}Чтобы предотвратить перезапись программами /etc/resolv.conf, сначала пропишем новые серверы DNS , затем установим атрибут неизменяемости: это заблокирует файл /etc/resolv.conf, никто не сможет его редактировать. Даже суперпользователь не сможет этого сделать (sudo). Если, конечно, вы не разблокируете файл командой (sudochattr -i /etc/resolv.conf). Если вам понадобится отредактировать этот файл. ${NC}"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Обновить публичные серверы DNS в /etc/resolv.conf,     0 - НЕТ - Пропустить обновление: " upd_resolv  # sends right after the keypress; # отправляет сразу после нажатия клавиши    
    echo ''
    [[ "$upd_resolv" =~ [^120] ]]
do
    :
done 
if [[ $upd_resolv == 0 ]]; then 
echo ""   
echo " Установка обновлений пропущена "
elif [[ $upd_resolv == 1 ]]; then
  echo ""
  echo " Для начала сделаем его бэкап  /etc/resolv.conf "
  echo " resolv.conf - Это основной файл настройки библиотеки распознавателя имен DNS "
sudo cp /etc/resolv.conf  /etc/resolv.conf.original
### cp -v /etc/resolv.conf  /etc/resolv.conf.original  # -v или --verbose -Выводить информацию о каждом файле, который обрабатывает команда cp.    
  echo " Пропишем публичные серверы DNS в /etc/resolv.conf "
> /etc/resolv.conf
cat <<EOF >>/etc/resolv.conf
# Resolver configuration file.
# See resolv.conf(5) for details.
# Generated by resolvconf.
domain localdomain
search localdomain
# nameserver ::1
# nameserver 127.0.0.1
# nameserver 127.0.1.1
# Cloudflare's nameservers, for example
# It is claimed that the "Privacy first" policy is used, so that users can be calm about the content of their requests.
nameserver 1.1.1.1
nameserver 1.0.0.1
# Yandex's nameservers, for example
# nameserver 77.88.8.8
# nameserver 77.88.8.1
# Google's nameservers, for example
# nameserver 8.8.8.8
# nameserver 8.8.4.4
# OpenDNS DNS Servers (IPv4 DNS Servers)
# nameserver 208.67.222.222
# nameserver 208.67.220.220
# Wired Internet from Beeline (corbina)(tp.internet.beeline.ru)
# nameserver 85.21.192.5
# nameserver 213.234.192.7
# Use the local name server
options trust-ad 
# options edns0 trust-ad

EOF
### ИЛИ ТАК #############
# DNS от Cloudflare
#cat > /etc/resolv.conf << EOF
#nameserver 1.1.1.1
#nameserver 1.0.0.1
# # nameserver 127.0.0.53
#options edns0 trust-ad
#search
#
#EOF
############# 
#echo " Пропишем публичные серверы DNS - Yandex (базовый) и BeeLine (внешние)"
#echo '# Resolver configuration file.' > /etc/resolv.conf
#echo '# See resolv.conf(5) for details.' >> /etc/resolv.conf
#echo '# Generated by resolvconf.' >> /etc/resolv.conf
#echo 'domain localdomain' >> /etc/resolv.conf
#echo 'search localdomain' >> /etc/resolv.conf
#echo '# nameserver ::1' >> /etc/resolv.conf
#echo '# nameserver 127.0.0.1' >> /etc/resolv.conf
#echo '# nameserver 127.0.1.1' >> /etc/resolv.conf
#echo '# Cloudflare nameservers, for example' >> /etc/resolv.conf
#echo '# It is claimed that the "Privacy" first policy is used, so that users can be calm about the content of their requests.' >> /etc/resolv.conf
#echo '# nameserver 1.1.1.1' >> /etc/resolv.conf
#echo '# nameserver 1.0.0.1' >> /etc/resolv.conf
#echo '# Yandex nameservers, for example' >> /etc/resolv.conf
#echo 'nameserver 77.88.8.8' >> /etc/resolv.conf
#echo 'nameserver 77.88.8.1' >> /etc/resolv.conf
#echo '# Google nameservers, for example' >> /etc/resolv.conf
#echo '# nameserver 8.8.8.8' >> /etc/resolv.conf
#echo '# nameserver 8.8.4.4' >> /etc/resolv.conf
#echo '# OpenDNS DNS Servers (IPv4 DNS Servers)' >> /etc/resolv.conf
#echo '# nameserver 208.67.222.222' >> /etc/resolv.conf
#echo '# nameserver 208.67.220.220' >> /etc/resolv.conf
#echo '# Wired Internet from Beeline (corbina)(tp.internet.beeline.ru)' >> /etc/resolv.conf
#echo 'nameserver 85.21.192.5' >> /etc/resolv.conf
#echo 'nameserver 213.234.192.7' >> /etc/resolv.conf
#echo '# Use the local name server' >> /etc/resolv.conf
#echo 'options trust-ad' >> /etc/resolv.conf
#echo '# options edns0 trust-ad' >> /etc/resolv.conf
#######################
echo ""
echo " Обновление публичных DNS серверов выполнено "
sleep 1
echo ""
echo -e "${BLUE}:: ${NC}Каждый раз, когда вы подключаетесь к Интернету, файл /etc/resolv.conf изменяется."
echo " Поэтому любые изменения, которые вы могли внести в /etc/resolv.conf, будут отменены, и файл будет перезаписан, вероятно, с чем-то вроде «nameserver 192.168.1.1» или любым другим IP-адресом вашего маршрутизатора (интернет-провайдера)... "
echo " Если вы используете NetworkManager (что, скорее всего, так и есть), то сделайте /etc/resolv.conf его неизменяемым, чтобы избежать перезаписи файла после перезагрузки "
echo " Чтобы предотвратить перезапись программами /etc/resolv.conf, установим атрибут неизменяемости: это заблокирует файл /etc/resolv.conf, никто не сможет его редактировать. Даже суперпользователь не сможет этого сделать (sudo). Если, конечно, вы не разблокируете файл командой (sudo chattr -i /etc/resolv.conf). Если вам понадобится отредактировать этот файл. "
### отключитесь от сети/интернета, затем откройте файл /etc/resolv.conf и измените его по своему усмотрению!
sudo chattr +i /etc/resolv.conf
### Это заблокирует файл /etc/resolv.conf, никто не сможет его редактировать. Даже суперпользователь не сможет этого сделать (sudo). (Если, конечно, вы не разблокируете файл). Чтобы разблокировать файл, введите в терминале следующее:
# sudo chattr -i /etc/resolv.conf
echo " Теперь проверьте права доступа и владельца с помощью ls -la команды "
ls -la /etc/resolv.conf
sleep 3
echo ""
echo " Просмотреть содержимое файла resolv.conf "
cat /etc/resolv.conf  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 5
#echo ""
#echo " Перезапустим (systemd-resolved) "
#systemctl restart systemd-resolved.service
#systemctl enable systemd-resolved
# systemctl status systemd-resolved
fi
############## Справка ###################
### Ваш файл /etc/resolv.conf, вероятно, является символической ссылкой. Помотрим объяснение для получения дополнительной информации. Вы могли бы попробовать:
# sudo chattr +i "$(realpath /etc/resolv.conf)"
### Поддерживает ли корневая точка монтирования списки управления доступом (acl) или расширенные атрибуты?
# Проверьте это с помощью:
# sudo findmnt -fn / | grep -E "acl|user_xattr" || echo "acl or user_xattr mount option not set for mountpoint /"
### Является ли ваш корневой раздел типом "VFAT"? Я полагаю, что "VFAT" не поддерживает списки управления доступом.
# Проверьте это с помощью:
# sudo findmnt -fn / | grep vfat
### Или, может быть, ваша целевая директория с символической ссылкой - это tmpfs? В tmpfs потеряны списки управления доступом
# Проверьте это:
# sudo findmnt -fn $(dirname $(realpath /etc/resolv.conf)) | grep tmpfs && echo $(dirname $(realpath /etc/resolv.conf)) is tmpfs
### Если опция trust-ad  - активна, заглушка-резолвер устанавливает бит AD в исходящих DNS-запросах (чтобы включить Поддержка бита AD и сохраняет бит AD в ответах. (https://manpages.ubuntu.com/manpages/oracular/man5/resolv.conf.5.html)
# resolv.conf необходим параметр trust-ad, чтобы glibc доверял ему
##########################################

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