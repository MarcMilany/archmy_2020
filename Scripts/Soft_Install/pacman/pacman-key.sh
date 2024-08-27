#!/usr/bin/env bash
# Install script debtap
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

PACMAN-KEY="russian"  # Installer default language (Язык установки по умолчанию)

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

clear
echo -e "${CYAN}
  <<< Обновление (добавление) новых ключей для системы Arch Linux >>> ${NC}"
echo ""
echo -e "${GREEN}==> ${NC}Обновить и добавить новые ключи?"
echo " Данный этап поможет вам избежать проблем с ключами Pacmаn, если Вы использовали не свежий образ ArchLinux для установки! "
echo -e "${RED}==> ${YELLOW}Примечание: ${BOLD}- Иногда при запуске обновления ключей по hkp возникает ошибка, не переживайте просто при установке gnupg в линукс в дефолтном конфиге указан следующий сервер: (keyserver hkp://keys.gnupg.net). GnuPG - оснащен универсальной системой управления ключами, а также модулями доступа для всех типов открытых ключей. GnuPG, также известный как GPG, это инструмент командной строки с возможностью легкой интеграции с другими приложениями. Доступен богатый выбор пользовательских приложений и библиотек. ${NC}"
echo -e "${RED}==> ${BOLD}Примечание: - Однако, в ходе чтения различных руководств в интернете было выяснено, что подобный способ обновления и передачи ключей не самый лучший, т.к. эта информация передается открытым способом. И тот, кто наблюдает за траффиком, видит данные обновляемых при gpg -refresh-keys ключей. И поэтому рекомендуется использовать hkps сервера - (keyserver hkps://hkps.pool.sks-keyservers.net)! ${NC}"
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, можно пропустить запуск обновления ключей. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да обновить ключи,    0 - Нет пропустить: " x_key  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_key" =~ [^10] ]]
do
    :
done
 if [[ $x_key == 0 ]]; then
  echo ""
  echo " Обновление ключей пропущено "
  echo ""
  echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов"
  sudo pacman -Sy --noconfirm  # обновить списки пакетов из репозиториев
elif [[ $x_key == 1 ]]; then
clear
echo ""
echo " Иногда у меня возникают проблемы со связкой ключей, поэтому я сначала запускаю следующие команды, которые гарантируют, что связка ключей обновлена! "
echo " Выполним резервное копирование каталога (/etc/pacman.d/gnupg), на всякий случай "
# Файлы конфигурации по умолчанию: ~/.gnupg/gpg.conf и ~/.gnupg/dirmngr.conf.
sudo cp -R /etc/pacman.d/gnupg /etc/pacman.d/gnupg_back
# Я тебе советовал перед созданием нового брелка удалить директории (но /root/.gnupg не удалена)
echo " Выполним резервное копирование каталога (/root/.gnupg), на всякий случай "
sudo cp -R /root/.gnupg /root/.gnupg_back 
echo " Выполним остановку gpg-agent (/root/.gnupg), на всякий случай "
echo " Вам не нужно будет перезапускать его вручную. GPG перезапустит его, когда это потребуется "
# sudo killall gpg-agent
# sudo gpg conf --kill gpg-agent  # В текущей версии GPG, чтобы остановить gpg-agent, вы можете использовать gpg conf --kill
echo " Удалим директорию (/etc/pacman.d/gnupg) "
sudo rm -R /etc/pacman.d/gnupg
# sudo rm -rf /etc/pacman.d/gnupg  
# sudo rm -r /etc/pacman.d/gnupg
# sudo mv /usr/lib/gnupg/scdaemon{,_}  # если демон смарт-карт зависает (это можно обойти с помощью этой команды)
#echo " Удалим директорию (/etc/pacman.d/gnupg) "
#sudo rm -R /root/.gnupg
#echo " Удалим директорию (/var/lib/pacman/sync) "
#sudo rm -R /var/lib/pacman/sync
#sudo rm -rf /var/lib/pacman/sync/*  # Если ошибка с содержанием /var/lib/pacman/sync, и повторите пункт с обновлением ключей.  
# ИЛИ ТАК: 
# sudo rm -rf /etc/pacman.d/gnupg /var/lib/pacman/sync
# sudo rm /var/lib/pacman/db.lck  # Если ошибка с содержанием /var/lib/pacman/db.lck
echo -e "${CYAN}=> ${NC}Обновим списки пакетов из репозиториев и установим Брелок Arch Linux PGP - пакет (archlinux-keyring)"
echo -e "${RED}==> ${BOLD}Примечание: - Данная операция может занять продолжительное время. ${NC}"    
echo " Брелок для ключей Arch Linux PGP (Репозиторий для пакета связки ключей Arch Linux) "
sudo pacman -Sy --noconfirm --needed --noprogressbar --quiet archlinux-keyring  # Брелок для ключей Arch Linux PGP ; https://git.archlinux.org/archlinux-keyring.git/ (для hkps://hkps.pool.sks-keyservers.net)
# sudo pacman -Syy archlinux-keyring --noconfirm  # Брелок Arch Linux PGP ; https://archlinux.org/packages/core/any/archlinux-keyring/
echo " Создаётся генерация мастер-ключа (брелка) pacman "  # gpg –refresh-keys
sudo pacman-key --init  # генерация мастер-ключа (брелка) pacman - (Инициализация)
echo " Далее идёт поиск ключей... "
sudo pacman-key --populate archlinux  # Получить ключи из репозитория (поиск ключей) ; pacman-key --populate
echo ""
echo " Обновление ключей... "
# sudo pacman-key --refresh-keys  # Проверить новые и установленные на актуальность  
# sudo pacman-key --refresh-keys --keyserver keys.gnupg.net  # http://pool.sks-keyservers.net/
# sudo pacman-key --refresh-keys --keyserver hkps://hkps.pool.sks-keyservers.net  # hkps://hkps.pool.sks-keyservers.net
### Если ошибка с содержанием hkps.pool.sks-keyservers.net, не может достучаться до сервера ключей выполните команды ниже. 
# sudo pacman-key --refresh-keys --keyserver hkp://pool.sks-keyservers.net  # hkps://hkp.pool.sks-keyservers.net
# sudo pacman-key --refresh-keys --keyserver hkp://keyserver.ubuntu.com  # hkp://keyserver.ubuntu.com
## Предлагается сделать следующие изменения в конфиге gnupg:
## keyserver hkps://hkps.pool.sks-keyservers.net
## keyserver-options ca-cert-file=/path/to/CA/sks-keyservers.netCA.pem
## где sks-keyservers.netCA.pem – есть сертификат, загружаемый с wwwhttps://sks-keyservers.net/sks-keyservers.netCA.pem
# sudo pacman-key --refresh-keys --keyserver hkps://hkps.pool.sks-keyservers.net
# keyserver-options ca-cert-file=/path/to/CA/sks-keyservers.netCA.pem
echo ""
echo "Обновим базы данных пакетов..."
###  sudo pacman -Sy
#sudo pamac upgrade --force-refresh  # для pamac трюк был в принудительном обновлении
sudo pacman -Syy  # обновление баз пакмэна (pacman) 
# sudo pacman -Syyu  # Обновим вашу систему (базу данных пакетов)
# sudo pacman -Syyu  --noconfirm 
# sudo pacman -Syyu  # Обновим вашу систему (базу данных пакетов)
# sudo pacman -Syyuu --noconfirm 
# sudo pacman -Syyuu 
echo ""
echo " Обновление и добавление новых ключей выполнено "
fi
###############
sleep 2

clear
echo ""
echo -e "${GREEN}==> ${NC}Включить службу-таймер (archlinux-keyring-wkd-sync.timer) длядальнейшего их автоматического обновления?"
echo " Для дальнейшего автоматического обновления ключей нужно включить службу-таймер, которая оптимизирует процесс при помощи команды archlinux-keyring-wkd-sync "
echo " Данный этап поможет вам избежать проблем с ключами Pacmаn, если Вы использовали не свежий образ ArchLinux для установки! "
echo -e "${RED}==> ${YELLOW}Примечание: ${BOLD}- Однако, в ходе чтения различных руководств в интернете было выяснено, что подобный способ обновления и передачи ключей не самый лучший, т.к. эта информация передается открытым способом. И тот, кто наблюдает за траффиком, видит ваши данные. Arch Linux теперь «звонит домой» на свои серверы ПО УМОЛЧАНИЮ. (Также касается Manjaro и других нижестоящих дистрибутивов)! Этот таймер systemd был добавлен и включен по умолчанию с последним выпуском пакета archlinux-keyring. Теперь ваши системы Arch будут выходить в интернет (как root!!) и подключаться к своему серверу ключей для обновления списка ключей упаковщика.  ${NC}"
echo -e "${RED}==> ${BOLD}Примечание: Это проблема как конфиденциальности, так и безопасности, отчасти потому, что они облажались. Он отключается каждый понедельник. Если ваш интернет-провайдер или MITM увидят, что вы подключаетесь к IP-адресу сервера ключей Arch в понедельник, они будут иметь довольно хорошее представление о том, какую ОС вы используете. Сами Arch также могут видеть все IP-адреса подключающихся людей. Это проблема безопасности, потому что это программное обеспечение работает как root и выходит в Интернет. Это большое табу и, честно говоря, стыдно. Им следовало бы сделать какое-то разделение привилегий в этом коде, но Pacman все еще делает все как root, как будто это было написано идиотом в 1990-х. Службу archlinux -keyring-wkd-sync.service включать не следует — она запускается archlinux-keyring-wkd-sync.timer каждые 5 дней. Я имел в виду не пакет archlinux-keyring — он необходим, а -wkd-sync — это расширение, обеспечивающее актуальность ключей pgp.${NC}"
echo -e "${CYAN}=> ${NC}Сделав ВЫВОДЫ в сценарий скрипта было прописано 2 варианта: -1. Включить Службу archlinux -keyring-wkd-sync.service ; -2(ОЙ) Отключить Службу archlinux -keyring-wkd-sync.service (ЧТОБЫ ОТКЛЮЧИТЬ ОТСЛЕЖИВАНИЕ). Причина, по которой он был добавлен, заключается в том, что некоторые идиЁты недостаточно часто обновляют свои пакеты (включая archlinux-keyring), а затем жалуются на ошибки ключей gpg, хотя это их собственная вина. Это изменение было просто навязано сотням тысяч пользователей по всему миру без их разрешения. "
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, можно пропустить запуск обновления ключей. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Включить Службу archlinux -keyring-wkd-sync.service,  2 - ОТКЛЮЧИТЬ Службу archlinux -keyring-wkd-sync.service,  

    0 - Нет пропустить: " x_wkd  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_wkd" =~ [^120] ]]
do
    :
done
 if [[ $x_wkd == 0 ]]; then
  echo ""
  echo " Обновление ключей пропущено "
  echo ""
  echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов"
  sudo pacman -Sy --noconfirm  # обновить списки пакетов из репозиториев
elif [[ $x_wkd == 1 ]]; then
  echo ""
  echo " Включить Службу archlinux -keyring-wkd-sync.service "
  echo " Для дальнейшего их автоматического обновления нужно включить службу-таймер, которая оптимизирует процесс при помощи команды archlinux-keyring-wkd-sync "
  sudo archlinux-keyring-wkd-sync
# sudo systemctl list-timers archlinux-keyring-wkd-sync
  sudo systemctl enable --now archlinux-keyring-wkd-sync.service   
  sudo systemctl enable --now archlinux-keyring-wkd-sync.timer  # Служба будет запущена по таймеру
# systemctl status archlinux-keyring-wkd-sync.service 
# pacman-key -l felixonmars@archlinux.org  # Когда это не удается и удается, запустите и опубликуйте
  echo ""
  echo " Службы archlinux -keyring-wkd-sync.service и archlinux-keyring-wkd-sync.timer включены "
elif [[ $x_wkd == 2 ]]; then
  echo ""
  echo "  ОТКЛЮЧИТЬ Службу archlinux -keyring-wkd-sync.service "
  echo " ЧТОБЫ ОТКЛЮЧИТЬ ОТСЛЕЖИВАНИЕ: "
  sudo systemctl disable --now archlinux-keyring-wkd-sync.service
  sudo systemctl disable --now archlinux-keyring-wkd-sync.timer
  sudo systemctl mask archlinux-keyring-wkd-sync.service
  sudo systemctl mask archlinux-keyring-wkd-sync.timer
  echo ""
  echo " Службы archlinux -keyring-wkd-sync.service и archlinux-keyring-wkd-sync.timer отключены "
fi
######### Справка ##############
### Arch Linux теперь «звонит домой» на свои серверы ПО УМОЛЧАНИЮ. (Также касается Manjaro и других нижестоящих дистрибутивов)
### https://gitlab.archlinux.org/archlinux/archlinux-keyring/-/blob/master/wkd_sync/archlinux-keyring-wkd-sync.timer
# Arch Linux теперь «звонит домой» на свои серверы ПО УМОЛЧАНИЮ.
# (Также касается Manjaro и других нижестоящих дистрибутивов)
# https://iqfy.com/arch-linux-now-phones-home-to-their-servers-by-default-also-affects-manjaro-and-other-downstream-distros-287000-350954/
# https://gitlab.archlinux.org/archlinux/archlinux-keyring/-/blob/master/wkd_sync/archlinux-keyring-wkd-sync.timer
### Этот таймер systemd был добавлен и включен по умолчанию с последним выпуском пакета archlinux-keyring. Теперь ваши системы Arch будут выходить в интернет (как root!!) и подключаться к своему серверу ключей для обновления списка ключей упаковщика.
### Это проблема как конфиденциальности, так и безопасности, отчасти потому, что они облажались. 
### ЧТОБЫ ОТКЛЮЧИТЬ ОТСЛЕЖИВАНИЕ:
# systemctl disable --now archlinux-keyring-wkd-sync.service
# systemctl disable --now archlinux-keyring-wkd-sync.timer
# systemctl mask archlinux-keyring-wkd-sync.service
# systemctl mask archlinux-keyring-wkd-sync.timer
###########################
# Удалить раздел установки из archlinux-keyring-wkd-sync.timer
# https://gitlab.archlinux.org/archlinux/archlinux-keyring/-/blob/master/wkd_sync/archlinux-keyring-wkd-sync.timer
# archlinux-keyring-wkd-sync.timer
# 
# [Unit]
# Description=Refresh existing PGP keys of archlinux-keyring regularly
# [Timer]
# OnCalendar=weekly
# Persistent=true
# RandomizedDelaySec=1week
##################
### Перевод ####
# [Единица измерения]
# Описание=Регулярно обновляйте существующие PGP-ключи в archlinux-связке ключей
# 
#[Таймер]
# В календаре=еженедельно
# Постоянный=true
#Рандомизированная задержка в секундах=1 неделя
#############################
sleep 2 

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

######### Справка ##############
# reflector -a 12 -l 30 -f 30 -p https --sort rate --save /etc/pacman.d/mirrorlist
# pacman-key --init
# pacman-key --populate
####################
# pacman-ключ
# Скрипт-обертка для GnuPG, используемый для управления связкой ключей pacman. Дополнительная информация: https://man.archlinux.org/man/pacman-key .
# Инициализируйте связку ключей pacman:
# sudo pacman-key --init
# Добавьте ключи ArchLinux по умолчанию:
# sudo pacman-key --populate {{archlinux}}
# Список ключей из открытого списка ключей:
# pacman-key --list-keys
# Добавьте указанные ключи:
# sudo pacman-key --add {{path/to/keyfile.gpg}}
# Получите ключ с сервера ключей:
# sudo pacman-key --recv-keys "{{uid|name|email}}"
# Распечатать отпечаток определенного ключа:
# pacman-key --finger "{{uid|name|email}}"
# Подпишите импортированный ключ локально:
# sudo pacman-key --lsign-key "{{uid|name|email}}"
# Удалить определенный ключ:
# sudo pacman-key --delete "{{uid|name|email}}"
# <<< Делайте выводы сами! >>>