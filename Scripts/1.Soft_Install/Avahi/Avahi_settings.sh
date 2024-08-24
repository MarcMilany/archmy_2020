#!/bin/bash
# loadkeys ru
# setfont cyr-sun16
# clear
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2024.07.31.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

Avahi_settings_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
  <<< Настройка Avahi - по вашему выбору и желанию >>> ${NC}"
### Примеры конфигураций услуг
echo ""
echo -e "${GREEN}==> ${NC}Добавляем Сервер блока сообщений сервера/общей файловой системы Интернета (SMB/CIFS)"
echo -e "${MAGENTA}:: ${BOLD}Примечание: этот файл службы Avahi понадобится только при использовании версии Samba до v3.3.x, поскольку последующие версии предоставляют ключи конфигурации для управления объявлениями ZeroConf серверов из собственного основного файла конфигурации « smb.conf ». Если демон Avahi запущен как на сервере, так и на клиенте, файловый менеджер на клиенте должен автоматически найти сервер. ${NC}"
echo -e "${CYAN}:: ${NC}Следующая конфигурация объявит сервер Samba (на порту TCP по умолчанию 445). Браузер Kodi ZeroConf отобразит эту запись как Samba на <имя сервера> . При проверке этой записи Kodi отобразит доступные общие ресурсы как содержимое следующего URL:smb://<ip of server>:445."
echo " Создать файл smb.service в /etc/avahi/services/ "
### Теперь анонсируем через него наш сервер
# nano /etc/avahi/services/smb.service
touch /etc/avahi/services/smb.service   # Создать файл /smb.service в /etc
ls -l /etc/avahi/services/smb.service   # ls — выводит список папок и файлов в текущей директории
sleep 1
echo " Пропишем конфигурацию для сервер Samba (на порту TCP по умолчанию 445) в /etc/avahi/services/smb.service "
> /etc/avahi/services/smb.service
cat <<EOF >>/etc/avahi/services/smb.service
<?xml version="1.0" standalone='no'?>
# <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
 <name replace-wildcards="yes">%h</name>
 <service>
   <type>_smb._tcp</type>
   <port>445</port>
 </service>
 <service>
   <type>_device-info._tcp</type>
   <port>0</port>
   <txt-record>model=RackMac</txt-record>
 </service>
</service-group>

EOF
######################

echo ""
echo -e "${GREEN}==> ${NC}Добавляем Сервер сетевой файловой системы (NFS)"
echo -e "${MAGENTA}:: ${BOLD}Примечание: Если у вас настроен общий ресурс NFS , вы можете использовать Avahi для автоматического монтирования его в браузерах с поддержкой Zeroconf (например, Konqueror в KDE и Finder в macOS) или файловых менеджерах, таких как GNOME/Files. ${NC}"
echo " Порт правильный, если в вашем есть insecure в качестве опции /etc/exports; в противном случае его необходимо изменить (обратите внимание, что insecure требуется для клиентов macOS). Путь — это путь к вашему экспорту или его подкаталогу. По какой-то причине функциональность автомонтирования была удалена из Leopard, однако доступен скрипт. "
echo -e "${CYAN}:: ${NC}Следующая конфигурация объявит сервер NFS (работающий на порту NFS по умолчанию 2049) с экспортированным путем /path/to/nfsexport. Браузер Kodi ZeroConf отобразит эту запись как сервер NFS по адресу <имя сервера> . "%h" — это подстановочная переменная, которая заменяется именем хоста устройства, предоставляющего службу. При проверке этой записи Kodi отобразит доступный путь к этой службе в виде следующего URL-адреса:nfs://<ip of server>:2049/path/to/nfsexport/."
echo " Создать файл nfs.service в /etc/avahi/services/ "
### Теперь анонсируем через него наш сервер
# nano /etc/avahi/services/nfs.service
touch /etc/avahi/services/nfs.service   # Создать файл /nfs.service в /etc
ls -l /etc/avahi/services/nfs.service   # ls — выводит список папок и файлов в текущей директории
sleep 1
echo " Пропишем конфигурацию для сервер NFS (работающий на порту NFS по умолчанию 2049) в /etc/avahi/services/nfs.service "
> /etc/avahi/services/nfs.service
cat <<EOF >>/etc/avahi/services/nfs.service
<?xml version= "1.0" standalone="'no'?> 
<!DOCTYPE service-group  SYSTEM  "avahi-service.dtd" > 
< service-group > 
  < name  replace-wildcards = "yes" > NFS-сервер в %h </ name >   
  < service > 
    < type > _nfs._tcp </ type > 
    < port > 2049 </ port > 
    < txt-record > path=/path/to/nfsexport </ txt-record > 
  </ service > 
</ service-group >

EOF
######################

echo ""
echo -e "${GREEN}==> ${NC}Добавляем Веб-сервер распределенной разработки и управления версиями (WebDAV)"
echo -e "${MAGENTA}:: ${BOLD}Примечание: Самые ранние веб-браузеры поддерживали редактирование веб-страниц. Тем не менее, часто требуется совместное редактирование удаленного контента, и поэтому оно появилось в Интернете в нескольких формах. WebDAV (Распределенный веб-авторинг и управление версиями (Web Distributed Authoring и Versioning)) - это один механизм. Веб-сервер, который поддерживает WebDAV, одновременно работает как файловый сервер. Он имеет действительно большую производительность.${NC}"
echo " Протокол WebDAV позволяет веб-серверу вести себя также как файловый сервер, поддерживая совместную разработку веб-контента. Вы можете столкнуться с WebDAV на HTTP-сервере Apache, Microsoft IIS, Box.com, WordPress, Drupal, Microsoft Sharepoint, Subversion, Git, Windows Explorer, macOS Finder, Microsoft Office, Apple iWork, Adobe Photoshop и во многих других местах. "
echo -e "${CYAN}:: ${NC}Следующая конфигурация объявит сервер WebDAV (в данном случае через веб-сервер Apache на порту TCP 80) с доступным путем /webdav/path. Браузер Kodi ZeroConf отобразит эту запись как WebDAV на <имя сервера> . При проверке этой записи Kodi отобразит доступный путь на этой службе в виде следующего URL:dav://<ip of server>:80/webdav/path/."
echo " Создать файл webdav.service в /etc/avahi/services/ "
### Теперь анонсируем через него наш сервер
# nano /etc/avahi/services/webdav.service
touch /etc/avahi/services/webdav.service   # Создать файл /webdav.service в /etc
ls -l /etc/avahi/services/webdav.service   # ls — выводит список папок и файлов в текущей директории
sleep 1
echo " Пропишем конфигурацию для сервер Apache (работающий на порту TCP по умолчанию 80) в /etc/avahi/services/webdav.service "
> /etc/avahi/services/webdav.service
cat <<EOF >>/etc/avahi/services/webdav.service
<?xml version= "1.0" standalone="'no'?> 
<!DOCTYPE service-group  SYSTEM  "avahi-service.dtd" > 
< service-group > 
  < name  replace-wildcards = "yes" > WebDav на %h </ name >   
  < service > 
    < type > _webdav._tcp </ type > 
    < port > 80 </ port > 
    < txt-record > path=/webdav/path </ txt-record >  
  </ service > 
</ service-group >

EOF
######################

echo ""
echo -e "${GREEN}==> ${NC}Добавляем Сервер защищенного протокола передачи файлов (SFTP через SSH)"
echo -e "${MAGENTA}:: ${BOLD}Примечание: Вы можете объявлять службы, используя службу avahi. Объявляем обслуживание, вы должны добавить файл описание сервиса в каталоге /etc/avahi/services. Объявить акцию по SFTP, создать файл sftp.service. ${NC}"
echo " Для FTP вы должны изменить Тип в _ftp._tcp и порт 21, на общем ресурсе NFS, изменение Тип _nfs._tcp и порт 2049. "
echo -e "${CYAN}:: ${NC}Следующая конфигурация объявит сервер SSH с включенным SFTP (на порту TCP по умолчанию 22) с доступным путем /path/to/be/accessed, учетной записью пользователя sshuserи паролем учетной записи sshpass. Браузер Kodi ZeroConf отобразит эту запись как SFTP на <имя сервера> . При проверке этой записи Kodi отобразит доступный путь на этой службе в виде следующего URL-адреса:sftp://sshuser:sshpass@<ip of server>:22/path/to/be/accessed/ "
### Теперь анонсируем через него наш сервер
# nano /etc/avahi/services/sftp.service
touch /etc/avahi/services/sftp.service   # Создать файл /sftp.service в /etc
ls -l /etc/avahi/services/sftp.service   # ls — выводит список папок и файлов в текущей директории
sleep 1
echo " Пропишем конфигурацию для сервер SSH (работающий на порту TCP по умолчанию 22) в /etc/avahi/services/sftp.service "
> /etc/avahi/services/sftp.service
cat <<EOF >>/etc/avahi/services/sftp.service
<?xml version= "1.0" standalone="'no'"?> 
<!DOCTYPE service-group  SYSTEM  "avahi-service.dtd" > 
< service-group > 
  < name  replace-wildcards = "yes" > SFTP на %h </ name > 
  < service > 
    < type > _sftp-ssh._tcp </ type > 
    < port > 22 </ port > 
    < txt-record > path=/path/to/be/accessed </ txt-record > 
    < txt-record > u=sshuser </ txt-record > 
    < txt-record > p=sshpass </ txt-record >   
  </ service > 
</ service-group >

EOF
######################

echo ""
echo -e "${GREEN}==> ${NC}Добавляем Сервер протокола передачи файлов (FTP)"
echo -e "${MAGENTA}:: ${BOLD}Примечание: Вы также можете автоматически обнаружить обычные FTP-серверы, такие как vsftpd . Установите пакет vsftpd и измените настройки vsftpd в соответствии с вашими личными предпочтениями (см. эту ветку на ubuntuforums.org или vsftpd.conf). ${NC}"
echo " FTP-сервер теперь должен быть объявлен Avahi. Теперь вы сможете найти FTP-сервер из файлового менеджера на другом компьютере в вашей сети. Возможно, вам потребуется включить разрешение #Hostname на клиенте. "
echo -e "${CYAN}:: ${NC}Следующая конфигурация объявит FTP-сервер (на TCP-порту по умолчанию 21) с доступным путем /ftppath, учетной записью пользователя ftpuserи паролем учетной записи ftppass. Браузер Kodi ZeroConf отобразит эту запись как FTP на <имя сервера> . При проверке этой записи Kodi отобразит доступный путь на этой службе в виде следующего URL-адреса:ftp:/ftpuser:ftppass@<ip of server>:21/ftppath/ "
### Теперь анонсируем через него наш сервер
# nano /etc/avahi/services/ftp.service
touch /etc/avahi/services/ftp.service   # Создать файл /ftp.service в /etc
ls -l /etc/avahi/services/ftp.service   # ls — выводит список папок и файлов в текущей директории
sleep 1
echo " Пропишем конфигурацию для сервер FTP (работающий на порту TCP по умолчанию 21) в /etc/avahi/services/ftp.service "
> /etc/avahi/services/ftp.service
cat <<EOF >>/etc/avahi/services/ftp.service
<?xml version= "1.0" standalone="'no'?> 
<!DOCTYPE service-group  SYSTEM  "avahi-service.dtd" > 
< service-group > 
  < name  replace-wildcards = "yes" > FTP на %h </ name > 
  < service > 
    < type > _ftp._tcp </ type > 
    < port > 21 </ port > 
    < txt-record > path=/ftppath </ txt-record > 
    < txt-record > u=ftpuser </ txt-record > 
    < txt-record > p=ftppass </ txt-record > 
  </ service > 
</ service-group >

EOF
######################
### Можно также заглянуть в /etc/avahi/avahi-daemon.conf и, например, ограничить вещание одним интерфейсом, но это уже на ваше усмотрение.
echo ""
echo " Перезапустим сервис (avahi-daemon.service)"
systemctl restart avahi-daemon.service
########### Справка ##############
# Услуги, поддерживаемые Kodi:
# Kodi может получать объявления ZeroConf для сервисов, работающих по следующим протоколам:
# Блок сообщений сервера/Общая файловая система Интернета (SMB/CIFS)
# Протокол передачи файлов (FTP)
# Протокол потоковой передачи домашнего телевидения (HTSP)
# Распределенная веб-разработка и управление версиями (WebDAV)
# Сетевая файловая система (NFS)
# Защищенный протокол передачи файлов (SFTP)
# Протокол цифрового аудиодоступа (DAAP)
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