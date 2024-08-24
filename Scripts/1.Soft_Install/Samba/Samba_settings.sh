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

SAMBA_settings_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
  <<< Настройка Samba - по вашему выбору и желанию >>> ${NC}"
### Примеры конфигураций услуг (Samba Sitting)
echo ""
echo " Создать каталог (Samba) в директории ~/home/<user>/ , для удобной работы "
### mkdir /home/<user>/Samba
mkdir ~/Samba  # Общая директория, на машине ; Создать каталог (Samba) в ~/home/<user>/
echo " Создать каталог в директории /etc/samba , для работы сервера Samba "
#sudo mkdir /etc/samba
sudo mkdir -p /etc/samba
echo " Создать файл конфигурации (настройки) сервера Samba 'smb.conf' в /etc/samba/ "
#touch /etc/samba/smb.conf   # Создать файл в /etc/samba/smb.conf
sudo touch /etc/samba/smb.conf
#######################
echo " Для начала сделаем бэкап оригинального (созданного) файла /etc/samba/smb.conf "
echo " smb.conf - Это  основной файл настройки samba "
#cp /etc/resolv.conf  /etc/resolv.conf.back
sudo cp -v /etc/samba/smb.conf  /etc/samba/smb.conf.original  # Для начала сделаем его бэкап ; -v или --verbose -Выводить информацию о каждом файле, который обрабатывает команда cp.
#sudo mv /etc/samba/smb.conf  /etc/samba/smb.conf.original_`date +"%d.%m.%y_%H-%M"`
echo " Посмотрим список папок и файлов в созданой директории /etc/samba "
ls -l /etc/samba   # ls — выводит список папок и файлов в текущей директории
sleep 03
######################
clear
echo ""
echo -e "${GREEN}==> ${NC}Внесём (добавим) небольшой сценарий конфигураций в созданный файл /etc/samba/smb.conf для первоначального запуска и работы сервера Samba (smb.service ; nmb.service)! "
echo -e "${MAGENTA}=> ${BOLD}Команда добавляет запись в файлы /etc/samba/smb.conf . Основы (данные конфигурации) для файла 'smb.conf' были взяты из ArchWiki: (https://wiki.archlinux.org/title/Samba) и ещё нескольких источников (http://www.samba.org/samba/docs/Samba-HOWTO-Collection.pdf).${NC}"
echo " Позже вы можете изменить (удалить) или добавить новые данные в 'smb.conf': доверенного домена, группу @group, пользователя (ей) @user, пароль ( ‘@’, ‘+’), папки (FS_Share), запреты "No", разрешение (yes на общем ресурсе), протоколы безопасности (SMB2,SMB3) и т.д... "




echo " Добавим следующие конфигурации в созданный файл /etc/samba/smb.conf "
> /etc/samba/smb.conf
cat <<EOF >>/etc/samba/smb.conf
# This is the main Samba configuration file. You should read the
# smb.conf(5) manual page in order to understand the options listed
# here. Samba has a huge number of configurable options (perhaps too
# many!) most of which are not shown in this example
#
# For a step to step guide on installing, configuring and using samba, 
# read the Samba-HOWTO-Collection. This may be obtained from:
#  http://www.samba.org/samba/docs/Samba-HOWTO-Collection.pdf
#
# Many working examples of smb.conf files can be found in the 
# Samba-Guide which is generated daily and can be downloaded from: 
#  http://www.samba.org/samba/docs/Samba-Guide.pdf
#
# Any line which starts with a ; (semi-colon) or a # (hash) 
# is a comment and is ignored. In this example we will use a #
# for commentry and a ; for parts of the config file that you
# may wish to enable
#
# NOTE: Whenever you modify this file you should run the command "testparm"
# to check that you have not made any basic syntactic errors. 
#
#======================= Global Settings =====================================
[global]

# workgroup = NT-Domain-Name or Workgroup-Name, eg: MIDEARTH
# должна соответствовать домашней группе (workgroup) Windows (по умолчанию: WORKGROUP)
#  workgroup = MYGROUP  # убедитесь, что значение рабочей группы совпадает с параметрами рабочей группы компьютеров Windows
   workgroup = WORKGROUP

# server string is the equivalent of the NT Description field
   server string = Samba Server

# Server role. Defines in which mode Samba will operate. Possible
# values are "standalone server", "member server", "classic primary
# domain controller", "classic backup domain controller", "active
# directory domain controller".
#
# Most people will want "standalone server" or "member server".
# Running as "active directory domain controller" will require first
# running "samba-tool domain provision" to wipe databases and create a
# new domain.
   server role = standalone server

# This option is important for security. It allows you to restrict
# connections to machines which are on your local network. The
# following example restricts access to two C class networks and
# the "loopback" interface. For more examples of the syntax see
# the smb.conf man page
;   hosts allow = 192.168.1. 192.168.2. 127.

# Uncomment this if you want a guest account, you must add this to /etc/passwd
# otherwise the user "nobody" is used
;  guest account = pcguest

# this tells Samba to use a separate log file for each machine
# that connects
#  log file = /usr/local/samba/var/log.%m
   log file = /var/log/samba/%m.log

# Put a capping on the size of the log files (in Kb).
   max log size = 50

# Specifies the Kerberos or Active Directory realm the host is part of
;   realm = MY_REALM

# Backend to store user information in. New installations should 
# use either tdbsam or ldapsam. smbpasswd is available for backwards 
# compatibility. tdbsam requires no further configuration.
;   passdb backend = tdbsam

# Using the following line enables you to customise your configuration
# on a per machine basis. The %m gets replaced with the netbios name
# of the machine that is connecting.
# Note: Consider carefully the location in the configuration file of
#       this line.  The included file is read at that point.
;   include = /usr/local/samba/lib/smb.conf.%m

# Configure Samba to use multiple interfaces
# If you have multiple network interfaces then you must list them
# here. See the man page for details.
;   interfaces = 192.168.12.2/24 192.168.13.2/24 

# Where to store roving profiles (only for Win95 and WinNT)
#        %L substitutes for this servers netbios name, %U is username
#        You must uncomment the [Profiles] share below
;   logon path = \\%L\Profiles\%U

# Windows Internet Name Serving Support Section:
# WINS Support - Tells the NMBD component of Samba to enable it's WINS Server
;   wins support = yes

# WINS Server - Tells the NMBD components of Samba to be a WINS Client
# Note: Samba can be either a WINS Server, or a WINS Client, but NOT both
;   wins server = w.x.y.z

# WINS Proxy - Tells Samba to answer name resolution queries on
# behalf of a non WINS capable client, for this to work there must be
# at least one  WINS Server on the network. The default is NO.
;   wins proxy = yes

# DNS Proxy - tells Samba whether or not to try to resolve NetBIOS names
# via DNS nslookups. The default is NO.
   dns proxy = no 

# These scripts are used on a domain controller or stand-alone 
# machine to add or delete corresponding unix accounts
;  add user script = /usr/sbin/useradd %u
;  add group script = /usr/sbin/groupadd %g
;  add machine script = /usr/sbin/adduser -n -g machines -c Machine -d /dev/null -s /bin/false %u
;  delete user script = /usr/sbin/userdel %u
;  delete user from group script = /usr/sbin/deluser %u %g
;  delete group script = /usr/sbin/groupdel %g

# For compatibility with older clients and/or servers,
# you may need to specify client min protocol = CORE or server min protocol = CORE,
# but keep in mind that this makes you vulnerable to exploits in SMB1, including ransomware attacks
   server min protocol = SMB2_02
   server max protocol = SMB3
# server min protocol = SMB3_00
   client min protocol = SMB2
   client max protocol = SMB2


#============================ Share Definitions ==============================
[homes]
   comment = Home Directories
   browseable = no
   writable = yes

# Un-comment the following and create the netlogon directory for Domain Logons
; [netlogon]
;   comment = Network Logon Service
;   path = /usr/local/samba/lib/netlogon
;   guest ok = yes
;   writable = no
;   share modes = no


# Un-comment the following to provide a specific roving profile share
# the default is to use the user's home directory
;[Profiles]
;    path = /usr/local/samba/profiles
;    browseable = no
;    guest ok = yes


# NOTE: If you have a BSD-style print system there is no need to 
# specifically define each individual printer
;[printers]
;   comment = All Printers
;   path = /usr/spool/samba
;   browseable = no
# Set public = yes to allow user 'guest account' to print
 ;  guest ok = no
 ;  writable = no
 ;  printable = yes


[myfiles]
# User accessing the directory (Пользователь обращается к каталогу)
    comment = smbuser 
# the directory User has permission to access (у Пользователя есть разрешение на доступ к каталогу)           
    path = /srv/myfiles
# nobody else has the permission to access the directory except User         
    public = no            
    only guest = yes
 # User have write access to the directory (Пользователь имеет доступ на запись в каталог)
    writable = yes        

# This one is useful for people to share files
;[tmp]
;   comment = Temporary file space
;   path = /tmp
;   read only = no
;   public = yes

# A publicly accessible directory, but read only, except for people in
# the "staff" group
;[public]
;   comment = Public Stuff
;   path = /home/samba
;   public = yes
;   writable = no
;   printable = no
;   write list = @staff

# Other examples. 
#
# A private printer, usable only by fred. Spool data will be placed in fred's
# home directory. Note that fred must have write access to the spool directory,
# wherever it is.
;[fredsprn]
;   comment = Fred's Printer
;   valid users = fred
;   path = /homes/fred
;   printer = freds_printer
;   public = no
;   writable = no
;   printable = yes

# A private directory, usable only by fred. Note that fred requires write
# access to the directory.
;[fredsdir]
;   comment = Fred's Service
;   path = /usr/somewhere/private
;   valid users = fred
;   public = no
;   writable = yes
;   printable = no

# a service which has a different directory for each machine that connects
# this allows you to tailor configurations to incoming machines. You could
# also use the %U option to tailor it by user name.
# The %m gets replaced with the machine name that is connecting.
;[pchome]
;  comment = PC Directories
;  path = /usr/pc/%m
;  public = no
;  writable = yes

# A publicly accessible directory, read/write to all users. Note that all files
# created in the directory by users will be owned by the default user, so
# any user with access can delete any other user's files. Obviously this
# directory must be writable by the default user. Another user could of course
# be specified, in which case all files would be owned by that user instead.
;[public]
;   path = /usr/somewhere/else/public
;   public = yes
;   only guest = yes
;   writable = yes
;   printable = no

# The following two entries demonstrate how to share a directory so that two
# users can place files there that will be owned by the specific users. In this
# setup, the directory should be writable by both users and should have the
# sticky bit set on it to prevent abuse. Obviously this could be extended to
# as many users as required.
;[myshare]
;   comment = Mary's and Fred's stuff
;   path = /usr/somewhere/shared
;   valid users = mary fred
;   public = no
;   writable = yes
;   printable = no
;   create mask = 0765

EOF
#######################
echo " Для начала сделаем его бэкап /etc/samba/smb.conf "
echo " smb.conf - Это  основной файл настройки samba "
#cp /etc/resolv.conf  /etc/resolv.conf.back
sudo cp -v /etc/samba/smb.conf  /etc/samba/smb.conf.back_`date +"%d.%m.%y_%H-%M"`  # Для начала сделаем его бэкап
# cp -v /etc/samba/smb.conf  /etc/samba/smb.conf.original  # -v или --verbose -Выводить информацию о каждом файле, который обрабатывает команда cp.
#sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.bak_`date +"%d.%m.%y_%H-%M"`
#######################
echo ""
echo " Просмотри внесённые изменения в etc/samba/smb.conf "
cat /etc/samba/smb.conf
sleep 1
#######################
echo " Проверим свою конфигурацию в файле etc/samba/smb.conf на синтаксические ошибоки "
sudo testparm /etc/samba/smb.conf  # для проверки синтаксических ошибок в smb.conf файле
# sudo testparm  # для проверки синтаксических ошибок в smb.conf файле
sleep 3
######################
echo " Перезапускаем Сервер Samba (smb.service ; nmb.service) при любых изменениях в конфиге /etc/samba/smb.conf "
#sudo systemctl restart smb.service
#sudo systemctl restart nmb.service
#######################
echo " Включим Сервер Samba (smb.service ; nmb.service) в автозагрузку и запустим! "
systemctl start smb.service
systemctl enable smb.service
systemctl start nmb.service
systemctl enable nmb.service
#sudo systemctl start smb
#sudo systemctl enable smb
#sudo systemctl start nmb
#sudo systemctl enable nmb
# sudo systemctl start smb nmb
# sudo systemctl enable smb nmb
# sudo systemctl enable --now smb nmb
# sudo systemctl enable --now samba
#######################
echo " Проверим состояние smb и nmb, которые должны быть активны и работают! "
########### smb ############
#sudo systemctl status smb   # Соответственно для просмотра текущего состояния демона smd
########### nmb ############
#sudo systemctl status nmb   # Соответственно для просмотра текущего состояния демона nmd
############################
sleep 01
###############
clear
echo ""
echo " Сервер Samba (smb.service ; nmb.service) добавлен в автозагрузку и запущен! "
echo " Проверить состояние (статус активности) smb и nmb, вы можете Позже! "

echo ""
echo ""
echo -e "${GREEN}==> ${NC}Создадим (добавим) новую группу пользователей для сервера Samba "
echo " Создание групп для Samba Linux необходимо для организации доступа к папкам в соответствии с принятыми правилами "
echo " Гостевой доступ это просто и удобно, но не всегда приемлемо! Существуют ситуации, когда доступ к общему ресурсу должны иметь только определенные пользователи. Группа будет добавлена в файл /etc/group ! "
echo -e "${MAGENTA}=> ${BOLD}Чтобы создать новую группу, воспользуемся командой: groupadd -r , за которой следует имя новой группы. Команда добавляет запись для новой группы в файлы /etc/group и /etc/gshadow . После создания группы вы можете начать добавлять пользователей в группу. Если группа с таким именем уже существует, система напечатает сообщение об ошибке!${NC}"
echo " Позже вы можете изменить (удалить) или добавить новую группу, пользователя и пароль общего доступа (пользователь_samba) "
read -p " => Введите название группы для samba groupname: " group_name
#sudo groupadd -r $group
sudo groupadd -r $group_name  # -r, --system: Эта опция создает системную группу
#sudo groupadd -f $group_name  # -f, --force: эта опция заставляет команду просто завершиться со статусом успешного выполнения, если указанная группа уже существует
# groupadd [опции] имя_группы
#echo ""
echo " Название группы которую вы добавили для сервера 'SAMBA' "
cat /etc/group | grep ${group_name}
# sudo grep ${group_name} /etc/group
#echo ""
echo " Группа успешно добавлена в /etc/group! "
sleep 02
# sudo groupadd -r sambauser  # Создадим (добавим) новую группу пользователей: sambauser - для сервера Samba
# cat /etc/group | grep sambauser  # Теперь вы можете убедится, что группа была добавлена в файл /etc/group
########### Справка #############
### Синтаксис команды `groupadd`:
# Команда имеет простой синтаксис: groupadd
# groupadd [опции] имя_группы
# groupadd [OPTIONS] GROUPNAME
# sudo groupadd -r new_group_name
### Некоторые важные параметры в groupadd:
# -f, --force: эта опция заставляет команду просто завершиться со статусом успешного выполнения, если указанная группа уже существует.
# -g GID, --gid GID: эта опция позволяет указать идентификатор новой группы.
# -K KEY=VALUE: Этот параметр переопределяет /etc/login.defsзначения по умолчанию.
# -o, --non-unique: эта опция позволяет создать группу с неуникальным GID.
# -p, --password PASSWORD: Эта опция устанавливает пароль для группы.
# -r, --system: Эта опция создает системную группу.
### Чтобы создать системную группу, вам придется использовать флаг -rс командой groupadd:
# sudo groupadd -r sysgroup
# Теперь вы можете убедится, что группа была добавлена в файл /etc/group:
# cat /etc/group | grep имя_группы
### Когда вы создаете новую группу, это обычная группа с GID выше 1000. Вы также можете создать системную группу, которая автоматически принимает идентификатор группы между SYS_GID_MIN и SYS_GID_MAX, как определено в /etc/login.defs.
# sudo groupadd -r new_group_name
### Чтобы подавить сообщение об ошибке, если группа существует, и для успешного завершения команды используйте параметр -f ( --force )
# sudo groupadd -f new_group_name
#################################

clear
echo ""
echo -e "${GREEN}==> ${NC}Создадим (добавим) пользователя для сервера Samba "
echo " Для работы Samba требуется какой-нибудь Linux-пользователь — вы можете использовать существующего пользователя, но это не по Фен-шуй (Основная идея состоит в том, что окружающая человека среда оказывает влияние на его благополучие и энергию), или создать нового пользователя, что мы и сделаем! "
# echo " По умолчанию (пользователь_samba) будет прописан 'smbuser'! "
echo " Позже вы можете изменить (удалить) или добавить нового пользователя и пароль общего доступа (пользователь_samba) "
#sudo useradd smbuser
# sudo useradd -s / bin / false smbuser
# sudo useradd -d /home/smbuser -s /sbin/nologin smbuser
echo " Для добавления учетных записей пользователя Linux и SAMBA введите: 
       --- Имя Пользователя и Название его рабочей группы."
echo " Для добавления пользователя в группу, группа должна существовать!!! "
user_name=""
while [ "${user_name}" = "" ]
do
#echo " => Введите имя добавляемого пользователя для samba username: "
echo Введите имя добавляемого пользователя:
read user_name
done
#echo " => Введите название группы groupname, в которую добавить пользователя username: "
echo Введите название группы, в которую добавить пользователя:
read group_name
if [ "`cat /etc/group | grep ${group_name}`" = "" ]
then
Группы с таким именем не существует.
else
echo Добавление учетной записи пользователя ${user_name} в группу ${group_name}...
sudo useradd -m -g ${group_name} ${user_name}
echo Добавление учетной записи пользователя ${user_name} SAMBA...
sudo smbpasswd -a ${user_name}
echo Включение учетной записи SAMBA ${user_name}...
sudo smbpasswd -e ${user_name}
echo " Все действия успешно выполнены! "
fi
################
echo " Вывести список пользователей добавленных в Samba: "
sudo pdbedit -L -v
sudo tail -1 /etc/passwd
###########################




# chmod +x myscript
# sudo myscript

# sudo groupdel sambauser
# sudo getent group | grep sambauser ?
# sudo cat /etc/group

# sudo cat /etc/passwd
# sudo passwd -l smbuser
# sudo userdel -f smbuser
## sudo userdel -r smbuser





echo ""
echo -e "${GREEN}==> ${NC}Создадим (добавим) пользователя для сервера Samba "
echo " Для работы Samba требуется какой-нибудь Linux-пользователь — вы можете использовать существующего пользователя или создать нового "
echo " По умолчанию (пользователь_samba) будет прописан 'smbuser'! "
echo " Позже вы можете изменить (удалить) или добавить нового пользователя и пароль общего доступа (пользователь_samba) "
sudo useradd smbuser
# sudo useradd -s / bin / false smbuser
# sudo useradd -d /home/smbuser -s /sbin/nologin smbuser

echo ""
echo -e "${GREEN}==> ${NC}Устанавливаем пароль пользователя общего доступа Samba в Arch "
echo " Создадим пользователя общего доступа (пользователь_samba) через (smbpasswd -a smbuser) "
echo " Обычно команда smbpasswd работает интерактивно - выводит запросы и ожидает ответы. Однако, при помощи ключа -s (silent) можно подавить вывод запросов и читать ответы со стандартного ввода. Это позволит вызывать smbpasswd из скриптов. "
echo " Хотя имена пользователей Samba общие с системными пользователями, Samba использует для них отдельные пароли "
echo " Позже вы можете изменить или добавить нового пользователя и пароль общего доступа (пользователь_samba) "
echo " Пароль должен содержать от 6 до 15 символов, включающих цифры (1-0) и знаки (!'':[@]),
        и латинские буквы разного регистра! "
echo -e "${MAGENTA}=> ${BOLD}По умолчанию, на большинстве систем Linux в консоле не показывается введенный пароль.
Это сделано из соображений безопасности, чтобы никто не мог увидеть длину вашего пароля.${NC}"
echo " => Введите SMB Password (Пароль пользователя Samba) - для smbuser, вводим пароль 2 раза "
#echo " => Введите SMB Password (Пароль пользователя Samba) - для $USER, вводим пароль 2 раза "
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
sudo smbpasswd -a smbuser
#sudo smbpasswd -a $USER  # если скрипт запускается через sudo, `USER` будет пользователем, доступным в sudo (обычно root)
# sudo smbpasswd -s -a $USER
# sudo smbpasswd -a $username  # `USERNAME` — пользователем, запустившим sudo
# sudo smbpasswd -s -a $username
echo " После добавления учетной записи пользователя (smbuser), ее надо активировать: (sudo smbpasswd -e пользователь_samba)"
sudo smbpasswd -e smbuser
### Удаление существующего пользователя
#sudo smbpasswd -x smbuser
### echo -e "Какой пароль должен быть у юзера ${username}?"
### Сменить пользовательский пароль:
# sudo smbpasswd -s пользователь_samba
##########################
echo " Вывести список пользователей добавленных в Samba: с помощью команды (pdbedit)"
sudo pdbedit -L -v
sleep 1
### Чтобы сменить пароль пользователя, используйте smbpasswd: smbpasswd -a  ['пользователь_samba']
# sudo smbpasswd пользователь_samba
############# Справка ##############
### Чтобы добавить себя в список пользователей Samba, вам просто нужно ввести следующую команду: sudo smbpasswd- a< имя пользователя>. Замените <имя пользователя> на свое имя пользователя. Затем вам будет предложено установить пароль для этой учетной записи Samba. В качестве альтернативы вы также можете создать новую учетную запись пользователя и добавить ее в список пользователей Samba. Чтобы создать учетную запись пользователя, используйте следующую команду: adduser< имя пользователя>.
### Согласно источнику, разница между переменными окружения `USER` и `USERNAME` заключается в следующем:
### В Linux: если скрипт запускается через sudo, `USER` будет пользователем, доступным в sudo (обычно root), а `USERNAME` — пользователем, запустившим sudo. 
#####################################

clear
echo ""
echo " Создадим каталог для пользователей "
echo " Проверить состояние (статус активности) smb и nmb, вы можете Позже! "

#!/usr/bin/env bash
#echo Welcome!
#clear
echo ""
echo -e "${GREEN}==> ${NC}Создадим каталог для пользователей общего доступа Samba в Arch "
  echo " Введите название папки $folder [ENTER]: "   # Введите название папки $folder [ВВОД]
  read foldrer_name
  $(mkdir ~/"$foldrer_name")
#  $(mkdir ~/Public/"$foldrer_name")
  echo " Подготовка папок Samba... "
#  $(mkdir ~/Publicshare/"$foldrer_name")
  $(mkdir ~/"$foldrer_name"/Public)
 $(mkdir ~/"$foldrer_name"/Public/Courses)
 $(mkdir ~/"$foldrer_name"/Public/Courses/Session2)
  echo " Подготовка папок Samba...готово "              
  echo " Папка для общего доступа через сервер Samba успешно создана "  
echo " Все каталоги были созданы "  
#Общедоступные  PUBLICSHARE
#ls -l ~/  # ls — выводит список папок и файлов в текущей директории
ls -l ~/ "$foldrer_name"


Создайте каталог для пользователей:

sudo mkdir /srv/myfiles

Узнаем локальный IP

В Linux

$ ip addr show

[Alex@Terminator ~]$ wget http://ipinfo.io/ip -qO -
95.25.240.56
[Alex@Terminator ~]$ ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 10:bf:48:29:89:2f brd ff:ff:ff:ff:ff:ff
    inet 100.127.181.17/16 brd 100.127.255.255 scope global dynamic noprefixroute enp5s0
       valid_lft 497sec preferred_lft 497sec
    inet6 fe80::ec39:143:d7d1:ad7e/64 scope link 
       valid_lft forever preferred_lft forever
    inet6 fe80::20bb:a2cf:ad69:d2d2/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 3a:44:8e:86:b7:92 brd ff:ff:ff:ff:ff:ff permaddr e0:06:e6:5e:f8:0d

Гостевой доступ это просто и удобно, но не всегда приемлемо. Существуют ситуации, когда доступ к общему ресурсу должны иметь только определенные пользователи. В нашем примере создадим два таких ресурса: для бухгалтерии и для IT-отдела.

Использование
Управление пользователями
В следующем разделе описывается создание локальной (tdbsam) базы данных пользователей Samba. Для аутентификации пользователей и других целей Samba также может быть привязана к домену Active Directory, может сама служить контроллером домена Active Directory или использоваться с сервером LDAP.


В Windows

ipconfig
10) Если установлен UFW, то добавляем локалную сеть в исключения

sudo ufw allow from 15.15.15.0/24
11) В Win в проводнике вбиваем ip адрес машины см. пример

\\192.168.0.0






Нам надо ввести пароль, который мы раньше шифровали, и теперь до конца сеанса наш пользователь находится в группе. Если вы хотите добавить пользователя в группу навсегда, то надо использовать команду usermod:

sudo usermod -aG group7 имя_пользователя


Если вы создали группу неправильно или считаете, что она не нужна, то её можно удалить. Для этого используйте:

sudo groupdel имя_группы


Используйте параметр -r ( --system ), чтобы создать системную группу. 
Например, чтобы создать новую системную группу с именем mysystemgroup вы должны запустить:

groupadd -r mysystemgroup

Чтобы подавить сообщение об ошибке, если группа существует, 
и для успешного завершения команды используйте параметр -f ( --force ):
sudo groupadd -f mygroup

Параметр -p ( --password ), за которым следует пароль, позволяет вам установить пароль для новой группы:

groupadd -p grouppassword mygroup

Следующая команда создает новую группу companyс паролем pa55word.

Баш

$ sudo groupadd компания -p pa55word
ИЛИ

Баш

$ sudo groupadd компания --password pa55word




Проверьте недавно добавленного пользователя:
tail -1 /etc/passwd


Восстановление к начальному состоянию Samba
Необходимо очистить базы и конфигурацию Samba (домен, если он создавался до этого, будет
удалён):
# rm -f /etc/samba/smb.conf
# rm -rf /var/lib/samba
# rm -rf /var/cache/samba
# mkdir -p /var/lib/samba/sysvol


echo " Включение безопасного общего доступа Samba в Arch "

sudo usermod -aG wireshark $USER

sudo gpasswd sambauser -a ['username']
sudo gpasswd sambauser -a $USER  # если скрипт запускается через sudo, `USER` будет пользователем, доступным в sudo (обычно root)
sudo gpasswd sambauser -a $username  # `USERNAME` — пользователем, запустившим sudo

echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " => Введите имя пользователя для samba: " username
# echo -e "Какое имя пользователя вам нужно?"
# read username; clear

Я написал bash-скрипт для добавления учетных записей UNIX и SAMBA:


#Добавляет пользователя в группу, группа должна существовать.
echo "Для добавления учетных записей пользователя Linux и SAMBA введите Имя Пользователя и Название его рабочей группы (группа должна существовать)."
user_name=""
while [ "${user_name}" = "" ]
do
echo Введите имя добавляемого пользователя:
read user_name
done
echo Введите название группы, в которую добавить пользователя:
read group_name
if [ "`cat /etc/group | grep ${group_name}`" = "" ]
then
Группы с таким именем не существует.
else
echo Добавление учетной записи пользователя ${user_name} в группу ${group_name}...
sudo useradd -m -g ${group_name} ${user_name}
echo Добавление учетной записи пользователя ${user_name} SAMBA...
sudo smbpasswd -a ${user_name}
echo Включение учетной записи SAMBA ${user_name}...
sudo smbpasswd -e ${user_name}
fi



for GROUP in $(cut -d $DELIM -f 1,2 --output-delimiter="|" "$LIST")
do

# Выделить из переменной поля разделенные "|"
# Команда tr -d [:cntrl:] позволяет удалить управляющие символы из переменной
# Иногда при экспорте в csv могут попадать управляющие символы и usermod сыплет ошибки
GRP1=`echo ${GROUP,,} | tr -d [:cntrl:] | cut -d "|" -f 1`
USR1=`echo ${GROUP,,} | tr -d [:cntrl:] | cut -d "|" -f 2`

#echo -e "$GRP1 | $USR1"

# Добавить группу и пользователя в группу
groupadd -f $GRP1
usermod --append --groups ${GRP1,,} ${USR1,,}

done






Я написал bash-скрипт для добавления учетных записей UNIX и SAMBA:
Запустить его можно командой:
sudo bash /path/script
где /path/script путь к скрипту.

Просмотр информации о пользователях и группах
Полезно знать как посмотреть информацию о всех учетных записях пользователей существующих в системе.
Информацию об учетной записи пользователя можно получить с помощью команды id:
id user_name
Информация об учетных записях UNIX хранится в файле /etc/passwd, каждая строка файла содержит информацию об одной из учетных записей, посмотреть его можно, например, командой:
cat /etc/passwd
Информация о группах UNIX хранится в файле /etc/group, посмотреть файл можно командой:
cat /etc/passwd
Информация об учетных записях SAMBA, хранящихся в базе данных получается командой:
sudo pdbedit -L

#Добавляет пользователя в группу, группа должна существовать.
echo "Для добавления учетных записей пользователя Linux и SAMBA введите Имя Пользователя и Название его рабочей группы (группа должна существовать)."
user_name=""
while [ "${user_name}" = "" ]
do
echo Введите имя добавляемого пользователя:
read user_name
done
echo Введите название группы, в которую добавить пользователя:
read group_name
if [ "`cat /etc/group | grep ${group_name}`" = "" ]
then
Группы с таким именем не существует.
else
echo Добавление учетной записи пользователя ${user_name} в группу ${group_name}...
sudo useradd -m -g ${group_name} ${user_name}
echo Добавление учетной записи пользователя ${user_name} SAMBA...
sudo smbpasswd -a ${user_name}
echo Включение учетной записи SAMBA ${user_name}...
sudo smbpasswd -e ${user_name}
fi

https://wiki.archlinux.org/title/Samba_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)


Добавьте пользователя user1 в  группу sambauser  : gpasswd - управление /etc/group и /etc/gshadow ;  gpasswd [параметр] группа
https://manpages.ubuntu.com/manpages/xenial/ru/man1/gpasswd.1.html


Вы также можете изменить пароль пользователя user1, выполнив следующую команду:

sudo smbpasswd user1

Перезапуск  smb.service и  nmb.service сервисы:

sudo systemctl restart smb
sudo systemctl restart nmb

Сохраните изменения в файле конфигурации и перезагрузите сервер Samba.

sudo service smbd reload


sudo usermod -aG wireshark $USER  # Добавить текущего пользователя в группу wireshark,
echo " Перемещаем и переименовываем исходный файл /etc/resolv.conf.back в /etc/resolvconf/resolv.conf.d/resolv.conf.original "
mv /etc/resolv.conf.back  /etc/resolvconf/resolv.conf.d/resolv.conf.original   # Перемещаем и переименовываем исходный файл
### echo " Удаление файла /etc/resolv.conf "
### rm /etc/resolv.conf   # rm - Удаление файлов
##################################











Начинаем всё это дело:

sudo systemctl start smb nmb
sudo systemctl enable smb nmb

Еще одна важная вещь — включить службы с помощью enable (заменив start в приведенном выше коде).

Правильные разрешения для публичного каталога

sudo chown -R nobody:nobody /sambapub

sudo chmod -R 777 /sambapub

Также, добавление пользователя:

sudo smbpasswd -a username




[global]
min protocol = SMB2                                                                                 
max protocol = SMB2                                                                                 
client min protocol = SMB2
client max protocol = SMB2


По сути, у меня есть эта конфигурация в файле конфигурации smb в samba (/etc/samba/smb.conf)

Я решил сделать проверку файлов на Mac более крутой, используя более удобную иконку для машины с параметрами, fruit:model = Macintosh и другими…


# general config

min protocol = SMB2
vfs objects = catia fruit streams_xattr
fruit:aapl = yes
fruit:metadata = stream
fruit:model = Macintosh
fruit:posix_rename = yes
fruit:veto_appledouble = no
fruit:wipe_intentionally_left_blank_rfork = yes
fruit:delete_empty_adfiles = yes

#folders private / public

[Private]
comment = private share
path = /home/felipe/private
browseable = yes
guest ok = no
writable = yes
valid users = felipe

[Public]
comment = public share
#path = /home/felipe/pub
path = /opt/sambapub
browseable = yes
writable = yes
guest ok = yes
#valid users = nobody

Начинаем всё это дело:

sudo systemctl start smb nmb
sudo systemctl enable smb nmb

Еще одна важная вещь — включить службы с помощью enable (заменив start в приведенном выше коде).

Правильные разрешения для публичного каталога

sudo chown -R nobody:nobody /sambapub

sudo chmod -R 777 /sambapub


[global]
security = user
workgroup = WORKGROUP
server string = Samba
#Тут пишем ваш ник вместо user
guest account = user
map to guest = Bad User
auth methods = guest, sam_ignoredomain
create mask = 0664
directory mask = 0775
hide dot files = yes

[shared]
comment = Public Folder
#Тут пишем путь до папки для шары
path = /home/public
browseable = Yes
guest ok = Yes
public = yes
writeable = Yes
read only = no
guest ok = yes
create mask = 0666
directory mask = 0775


Настройка межсетевого экрана
9) Узнаем локальный IP

В Linux

$ ip addr show
[Alex@Terminator ~]$ ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 10:bf:48:29:89:2f brd ff:ff:ff:ff:ff:ff
    inet 100.127.90.174/16 brd 100.127.255.255 scope global dynamic noprefixroute enp5s0
       valid_lft 571sec preferred_lft 571sec
    inet6 fe80::20bb:a2cf:ad69:d2d2/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
    inet6 fe80::ec39:143:d7d1:ad7e/64 scope link 
       valid_lft forever preferred_lft forever
3: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether c6:24:c3:d9:a4:3e brd ff:ff:ff:ff:ff:ff permaddr e0:06:e6:5e:f8:0d




В Windows

ipconfig
10) Если установлен UFW, то добавляем локалную сеть в исключения

sudo ufw allow from 15.15.15.0/24


Если вы используете межсетевой экран, не забудьте открыть необходимые порты (как правило, 137-139 + 445). Для получения информации о полном списке портов, смотрите использование портов Samba.

Правило UFW
Профиль Ufw для SMB/CIFS доступен в стандартной установке UFW в ufw-fileserver.

Разрешите Samba, выполнив команду ufw allow CIFS от имени root.

Если вы удалили профиль, создайте или отредактируйте файл /etc/ufw/applications.d/samba, добавив следующее:

[Samba]
title=LanManager-like file and printer server for Unix
description=The Samba software suite is a collection of programs that implements the SMB/CIFS protocol for unix systems, allowing you to serve files and printers to Windows, NT, OS/2 and DOS clients. This protocol is sometimes also referred to as the LanManager or NetBIOS protocol.
ports=137,138/udp|139,445/tcp
Затем загрузите этот профиль в UFW, запустив команду ufw app update Samba как root.

После этого можно разрешить доступ к Samba, запустив ufw allow Samba от имени root.

Служба firewalld
Для настройки firewalld, чтобы разрешить Samba в зоне home, выполните:

# firewall-cmd --permanent --add-service={samba,samba-client,samba-dc} --zone=home
Эти три службы таковы:

samba: для общего доступа к файлам.
samba-client: для просмотра общих ресурсов других устройств по сети.
samba-dc: для контроллера домена Active Directory.
Параметр --permanent сделает изменения постоянными.

Использование
Управление пользователями
В следующем разделе описывается создание локальной (tdbsam) базы данных пользователей Samba. Для аутентификации пользователей и других целей Samba также может быть привязана к домену Active Directory, может сама служить контроллером домена Active Directory или использоваться с сервером LDAP.

Добавление пользователя
Для работы Samba требуется какой-нибудь Linux-пользователь — вы можете использовать существующего пользователя или создать нового.

Примечание: Пользователь и группа nobody изначально существуют в системе, используются как гостевой аккаунт (guest account) по умолчанию и могут быть использованы в ресурсах для общего доступа с опцией guest ok = yes, благодаря чему пользователям не понадобится логиниться для доступа к таким ресурсам.
Хотя имена пользователей Samba общие с системными пользователями, Samba использует для них отдельные пароли. Чтобы добавить нового пользователя Samba, воспользуйтесь следующей, заменив пользователь_samba на имя нужного пользователя:

# smbpasswd -a пользователь_samba
Будет предложено задать пароль для этого пользователя.

В зависимости от роли сервера может понадобиться изменить разрешения и атрибуты файлов для аккаунта Samba.

Если вы хотите разрешить новому пользователю только доступ к Samba-ресурсам и запретить полноценный вход в систему, можно ограничить возможности входа:

отключить командную оболочку - usermod --shell /usr/bin/nologin --lock пользователь_samba
отключить вход по SSH - измените опцию AllowUsers в файле /etc/ssh/sshd_config
См. также рекомендации по повышению защищённости системы.




Пример файла /etc/samba/smb.conf после создания домена с SAMBA_INTERNAL:
 Global parameters
[global]
 dns forwarder = 8.8.8.8
 netbios name = DC1
 realm = TEST.ALT
 server role = active directory domain controller
 workgroup = TEST
 idmap_ldb:use rfc2307 = yes
[sysvol]
 path = /var/lib/samba/sysvol
 read only = No
[netlogon]
 path = /var/lib/samba/sysvol/test.alt/scripts
 read only = No







######################

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