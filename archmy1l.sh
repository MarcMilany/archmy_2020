#!/bin/bash
### Смотрите пометки (справочки) и доп.иформацию в самом скрипте!
###########################################################
#### Releases ArchLinux:                               ####
####     https://www.archlinux.org/releng/releases/    ####
#### Installation guide - Arch Wiki  (referance):      ####
# https://wiki.archlinux.org/index.php/Installation_guide #
###########################################################
apptitle="Arch Linux Fast Install v2.5 LegasyBIOS - Version: 2025.06.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
iso_label="ARCH_$(date +%Y%m)"
iso_version=$(date +%Y.%m.%d)
gpg_key=
verbose=""
EDITOR=nano
###
#_arch_fast_install_banner
set > old_vars.log
APPNAME="arch_fast_install"
VERSION="v2.5 LegasyBIOS Update"
BRANCH="master"
AUTHOR="ordanax_and_poruncov"
LICENSE="GNU General Public License 3.0"
###
ARCHMY1L_LANG="russian"  # Installer default language (Язык установки по умолчанию)
### Start of the script
script_path=$(readlink -f ${0%/*})  # эта опция канонизируется путем рекурсивного следования каждой символической ссылке в каждом компоненте данного имени; все, кроме последнего компонента должны существовать
# SCRIPT_PATH=$(realpath $0)
# ...
# echo $SCRIPT_PATH
# wget https://github.com/MarcMilany/archmy_2020/blob/master/archmy1l.sh
###
umask 0022 # Определение окончательных прав доступа - Для суперпользователя (root) umask по умолчанию равна 0022
set -e # Эта команда остановит выполнение сценария после сбоя команды и будет отправлен код ошибки
# set -euxo pipefail  # прекращает выполнение скрипта, даже если одна из частей пайпа завершилась ошибкой
###
### Help and usage (--help or -h) (Справка)
_help() {
    echo -e "${BLUE}
Installation guide - Arch Wiki
${BOLD}For more information, see the wiki: \
${GREY}<https://wiki.archlinux.org/index.php/Installation_guide>${NC}"
}
###
### SHARED VARIABLES AND FUNCTIONS (ОБЩИЕ ПЕРЕМЕННЫЕ И ФУНКЦИИ)
### Shell color codes (Цветовые коды оболочки)
RED="\e[1;31m"; GREEN="\e[1;32m"; YELLOW="\e[1;33m"; GREY="\e[3;93m"
BLUE="\e[1;34m"; CYAN="\e[1;36m"; BOLD="\e[1;37m"; MAGENTA="\e[1;35m"; NC="\e[0m"
###
### Automatic error detection (Автоматическое обнаружение ошибок)
_set() {
    set [--abefhkmnptuvxBCHP] [-o option] [arg ...]
}
###
_set() {
    set -e "\n${RED}Error: ${YELLOW}${*}${NC}"
    _note "${MSG_ERROR}"
    sleep 1; $$
}
###
####### Baner ##############
### Description (Описание)
_arch_fast_install_banner() {
    echo -e "${BLUE}
┌─┐┬─┐┌─┐┬ ┬  ┬  ┬ ┬ ┬┬ ┬┌┌┐  ┬─┐┌─┐┌─┐┌┬┐  ┬ ┬ ┬┌─┐┌┬┐┌─┐┬  ┬
├─┤├┬┘│  ├─┤  │  │ │\││ │ │   │─ ├─┤└─┐ │   │ │\│└─┐ │ ├─┤│  │
┴ ┴┴└─└─┘┴ ┴  └─┘┴ ┴ ┴└─┘└└┘  ┴  ┴ ┴└─┘ ┴   ┴ ┴ ┴└─┘ ┴ ┴ ┴┴─┘┴─┘${RED}
 Arch Linux Install ${VERSION} - ${LICENSE}
${NC}
Arch Linux - это независимо разработанный универсальный дистрибутив GNU / Linux для архитектуры x86-64, который стремится предоставить последние стабильные версии большинства программ, следуя модели непрерывного выпуска.
 Arch Linux определяет простоту как без лишних дополнений или модификаций. Arch включает в себя многие новые функции, доступные пользователям GNU / Linux, включая systemd init system, современные файловые системы , LVM2, программный RAID, поддержку udev и initcpio (с mkinitcpio ), а также последние доступные ядра.
Arch Linux - это дистрибутив общего назначения. После установки предоставляется только среда командной строки: вместо того, чтобы вырывать ненужные и нежелательные пакеты, пользователю предлагается возможность создать собственную систему, выбирая среди тысяч высококачественных пакетов, представленных в официальных репозиториях для x86-64 архитектуры.
 Изначально этот скрипт не задумывался, как обычный установочный (сценарий), с большим выбором DE, разметкой диска и т.д..
Но в последствие! Эта концепция была пересмотрена, и в скрипт был добавлен выбор DE, разметка диска и другие плюшки. И он (скрипт) НЕ предназначен для новичков!
Он предназначен для тех, кто ставил Arch Linux руками и понимает, что и для чего нужна каждая команда.
Его цель - это быстрое разворачивание системы со всеми конфигами. Смысл в том, что все изменения Вы делаете предварительно в самом скрипте и получаете возможность быстрой установки Arch Linux с вашими личными настройками (при условии, что Вы его изменили под себя, в противном случае с моими настройками).${RED}

 ***************************** ВНИМАНИЕ! *****************************
${NC}
Автор не несёт ответственности за любое нанесение вреда при использовании скрипта.
Вы используйте его на свой страх и риск, или изменяйте под свои личные нужды."
}
################
echo ""
echo -e "${GREEN}:: ${NC}Installation Commands :=) "
echo -e "${CYAN}=> ${NC}Acceptable limit for the list of arguments..."
getconf ARG_MAX  # Допустимый лимит (предел) списка аргументов...'
echo -e "${BLUE}:: ${NC}The determination of the final access rights"
umask  # Определение окончательных прав доступа - Для суперпользователя (root) umask по умолчанию равна 0022
echo -e "${BLUE}:: ${NC}Current full date"
echo "$(date -u "+%F %H:%M:%S")"
## %F - полная дата, то же что и %Y-%m-%d; %H - hour (00..23); %M - minute (00..59)
sleep 03
################
#echo ""
#echo -e "${GREEN}:: ${NC}Restart the DHCP service :=) "
#echo -e "${CYAN}=> ${NC}DHCP (Dynamic Host Configuration Protocol) is a protocol that allows individual devices on an IP network to receive their own network configuration information from a DHCP server..."
# DHCP (протокол динамической конфигурации хоста) — это протокол, который позволяет отдельным устройствам в IP-сети получать от DHCP-сервера собственную информацию о конфигурации сети
#systemctl restart dhcpcd  # Перезапустите службу DHCP
#dhcpcd
# systemctl status dhcpcd
# systemctl stop dhcpd.service  # Чтобы остановить службу dhcpd
# systemctl start dhcpd.service  # Чтобы запустить службу dhcpd
# systemctl enable dhcpd.service  # Примечание : По умолчанию служба DHCPD не запускается во время загрузки. Чтобы настроить демон на автоматический запуск во время загрузки
###################
echo ""
echo -e "${GREEN}=> ${NC}To check the Internet, you can ping a service"
# ping google.com -W 2 -c 1
ping -c 2 archlinux.org  # Утилита ping - это очень простой инструмент для диагностики сети
echo -e "${CYAN}==> ${NC}If the ping goes we go further ... :)"  # Если пинг идёт едем дальше ... :)
###
echo ""
echo -e "${GREEN}=> ${NC}Make sure that your network interface is specified and enabled"
echo " Show all ip addresses and their interfaces "
## Показать все ip адреса и их интерфейсы
ip a  # Смотрим какие у нас есть интернет-интерфейсы
sleep 1
#####################
echo ""
echo -e "${BLUE}:: ${NC}Update the package databases"
## Обновим базы данных пакетов
pacman -Sy --print-format "%r"  # Указывает похожий на printf формат для контроля вывода операции --print; «% r» для репозитория
#pacman -Sy --noconfirm  # обновить списки пакетов из репозиториев
sleep 1
################
echo ""
echo -e "${BLUE}:: ${NC}Install the Terminus font"  # Установим шрифт Terminus
pacman -S terminus-font --noconfirm  # Моноширинный растровый шрифт (для X11 и консоли)
# pacman -Sy terminus-font --noconfirm  # Моноширинный растровый шрифт (для X11 и консоли)
# pacman -Syy terminus-font  # Моноширинный растровый шрифт (для X11 и консоли)
# man vconsole.conf
echo ""
echo -e "${BLUE}:: ${NC}Setting up the Russian language, changing the console font to one that supports Cyrillic for ease of use"
loadkeys ru  # Настроим русский язык, изменим консольный шрифт на тот, который поддерживает кириллицу для удобства работы
# loadkeys us
#setfont ter-v12n
#setfont ter-v14b
#setfont cyr-sun16
setfont ter-v16b ### Установленный setfont
#setfont ter-v20b  # Шрифт терминус и русская локаль # чтобы шрифт стал побольше
### setfont ter-v22b
### setfont ter-v32b  # Для экрана HiDPI можно выбрать один из самых больших доступных шрифтов с русскими буквами
echo -e "${CYAN}==> ${NC}Добавим русскую локаль в систему установки"
pacman -S --noconfirm --needed sed  # Редактор потока GNU ; https://www.gnu.org/software/sed/ ; https://archlinux.org/packages/core/x86_64/sed/ ; 5 марта 2023 г., 20:39 UTC
sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen
echo -e "${BLUE}:: ${NC}Обновим текущую локаль системы"
locale-gen  # Мы ввели locale-gen для генерации тех самых локалей
sleep 1
echo -e "${BLUE}:: ${NC}Указываем язык системы"
export LANG=ru_RU.UTF-8
#export LANG=en_US.UTF-8
echo -e "${BLUE}:: ${NC}Проверяем, что все заявленные локали были созданы:"
locale -a  # Смотрим какте локали были созданы
sleep 1
clear
######################
### Display banner (Дисплей баннер)
_arch_fast_install_banner
sleep 1
###
echo ""
echo -e "${GREEN}==> ${NC}Вы готовы приступить к установке Arch Linux? "  # (Installing ArchLinux)
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да приступить,    0 - Нет отменить: " hello  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$hello" =~ [^10] ]]
do
    :
done
if [[ $hello == 1 ]]; then
  clear
  echo ""
  echo " Добро пожаловать в установку Arch Linux ! "
elif [[ $hello == 0 ]]; then
  echo " Вы отказались от установки Arch Linux "
  exit
fi
###
clear
echo -e "${GREEN}
  <<< Начинается установка минимальной системы Arch Linux >>>
${NC}"
echo -e "${BLUE}:: ${NC}Установка и настройка начата в $(date +%T)"
echo -e "${BLUE}:: ${NC}Синхронизация системных часов"
timedatectl set-ntp true  # Синхронизируем наши системные часы, включаем ntp, если надо сменим часовой пояс
# echo " Для начала устанавливаем время по Москве, чтобы потом не оказалось, что файловые системы созданы в будущем "
# timedatectl set-timezone Europe/Moscow
# timedatectl set-ntp true && timedatectl set-timezone Europe/Moscow
sleep 02
echo -e "${BLUE}:: ${NC}Посмотрим статус службы NTP (NTP service)"
timedatectl status
echo -e "${BLUE}:: ${NC}Посмотрим дату и время без характеристик для проверки времени"
date  # команда date работает с датой и временем (можно извлекать любую дату в разнообразном формате)
echo -e "${BLUE}:: ${NC}Убедитесь, что «System clock synchronized» имеет статус «yes». А если нет, то установим утилиту chrony"
sleep 03
#pacman -S --noconfirm --needed chrony  # Легкий NTP-клиент и сервер ; https://archlinux.org/packages/extra/x86_64/chrony/ ; https://chrony-project.org/ ; 2024-11-05 19:29 UTC ;
# Настройка сервера и клиента chrony: https://redos.red-soft.ru/base/redos-8_0/8_0-administation/8_0-timedate/8_0-chrony-in-local-network/
# echo -e "${BLUE}:: ${NC}Запуск сервера и клиента chrony"
#systemctl start chronyd  # Запуск сервера и клиента chrony
# systemctl enable chronyd --now  # Разрешаем автозапуск и стартуем сервис
#systemctl status chronyd  # Убедимся, что chrony установлен и настроен в качестве службы времени по умолчанию
#echo -e "${BLUE}:: ${NC}Перепроверь статус синхронизации времени"
#timedatectl  # Команда в Linux, которая позволяет просмотреть или изменить настройки даты и времени операционной системы
#timedatectl status
# timedatectl show  # Вы можете отобразить полученную информацию в формате переменная=значение
#sleep 03
###
clear
echo ""
echo -e "${GREEN}==> ${NC}Обновить и добавить новые ключи?"
echo -e "${CYAN} ! ${BOLD}Процесс обновления (поиска ключей) МОЖЕТ быть продолжительным (от 3 до 5... минут) ${NC}"
echo " Данный этап поможет вам избежать проблем с ключами Pacmаn, если Вы используете не свежий образ ArchLinux для установки! "
echo -e "${RED}=> ${YELLOW}Примечание: ${BOLD} - Иногда при запуске обновления ключей по hkp возникает ошибка, не переживайте просто при установке gnupg в линукс в дефолтном конфиге указан следующий сервер: (keyserver hkp://keys.gnupg.net). GnuPG - оснащен универсальной системой управления ключами, а также модулями доступа для всех типов открытых ключей. GnuPG, также известный как GPG, это инструмент командной строки с возможностью легкой интеграции с другими приложениями. Доступен богатый выбор пользовательских приложений и библиотек. ${NC}"
echo -e "${MAGENTA}=> Информация: ${BOLD}Однако, в ходе чтения различных руководств в интернете было выяснено, что подобный способ обновления и передачи ключей не самый лучший, т.к. эта информация передается открытым способом. И тот, кто наблюдает за траффиком, видит данные обновляемых при gpg -refresh-keys ключей. И поэтому рекомендуется использовать hkps сервера - (keyserver hkps://hkps.pool.sks-keyservers.net)! ${NC}"
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, можно пропустить запуск обновления ключей. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да обновить ключи,    0 - Нет пропустить: " i_key  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_key" =~ [^10] ]]
do
    :
done
if [[ $i_key == 1 ]]; then
  clear
  echo ""
  echo " Обновим списки пакетов из репозиториев и установим Брелок Arch Linux PGP - пакет (archlinux-keyring) "
  echo " Брелок для ключей Arch Linux PGP (Репозиторий для пакета связки ключей Arch Linux) "
  pacman -Sy --noconfirm --needed --noprogressbar --quiet archlinux-keyring  # Брелок для ключей Arch Linux PGP ; https://git.archlinux.org/archlinux-keyring.git/ (для hkps://hkps.pool.sks-keyservers.net)
# pacman -Syy archlinux-keyring --noconfirm  # Брелок Arch Linux PGP ; https://archlinux.org/packages/core/any/archlinux-keyring/
  echo ""
  echo " Создаётся генерация мастер-ключа (брелка) pacman "  # gpg –refresh-keys
  pacman-key --init  # генерация мастер-ключа (брелка) pacman - (Инициализация)
  echo " Далее идёт поиск ключей... "
  pacman-key --populate archlinux  #  Получить ключи из репозитория (поиск ключей) ; pacman-key --populate
  echo ""
  echo " Обновление ключей... "
#pacman-key --refresh-keys  # Проверить новые и установленные на актуальность
#pacman-key --refresh-keys --keyserver keys.gnupg.net  # http://pool.sks-keyservers.net/
#pacman-key --refresh-keys --keyserver hkp://keyserver.ubuntu.com
# pacman-key --refresh-keys --keyserver hkp://pool.sks-keyservers.net  # hkps://hkps.pool.sks-keyservers.net
# pacman-key --refresh-keys --keyserver hkps://hkps.pool.sks-keyservers.net  # hkps://hkps.pool.sks-keyservers.net
## Предлагается сделать следующие изменения в конфиге gnupg:
## keyserver hkps://hkps.pool.sks-keyservers.net
## keyserver-options ca-cert-file=/path/to/CA/sks-keyservers.netCA.pem
## где sks-keyservers.netCA.pem – есть сертификат, загружаемый с wwwhttps://sks-keyservers.net/sks-keyservers.netCA.pem
# pacman-key --refresh-keys --keyserver hkps://hkps.pool.sks-keyservers.net
# keyserver-options ca-cert-file=/path/to/CA/sks-keyservers.netCA.pem
### Включил отладку в dirmngr
# pkill dirmngr
# pkill dirmngr; dirmngr --debug-all --daemon --standard-resolver
  echo ""
  echo " Обновим базы данных пакетов... "
### pacman -Sy  # обновить списки пакетов из репозиториев
  pacman -Syy  # обновление баз пакмэна (pacman)
# pacman -Syy --noconfirm
# pacman -Syyu  # Обновим вашу систему (базу данных пакетов)
# pacman -Syyu  --noconfirm
  echo ""
  echo " Обновление и добавление новых ключей выполнено "
elif [[ $i_key == 0 ]]; then
  echo ""
  echo " Обновление ключей пропущено "
  echo ""
  echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов"
  pacman -Sy --noconfirm  # обновить списки пакетов из репозиториев
fi
sleep 1
######################
clear
echo ""
echo -e "${BLUE}:: ${NC}Dmidecode. Получаем информацию о железе"
echo " DMI (Desktop Management Interface) - интерфейс (API), позволяющий программному обеспечению собирать данные о характеристиках компьютера. "
pacman -S dmidecode --noconfirm  # Утилиты, относящиеся к таблице интерфейса управления рабочим столом
echo ""
echo -e "${BLUE}:: ${NC}Смотрим информацию о BIOS"
dmidecode -t bios  # BIOS – это предпрограмма (код, вшитый в материнскую плату компьютера)
# dmidecode --type BIOS
#echo ""
#echo -e "${BLUE}:: ${NC}Смотрим информацию о материнской плате"
#dmidecode -t baseboard
# dmidecode --type baseboard
#echo ""
#echo -e "${BLUE}:: ${NC}Смотрим информацию о разьемах на материнской плате"
#dmidecode -t connector
# dmidecode --type connector
#echo ""
#echo -e "${BLUE}:: ${NC}Информация о установленных модулях памяти и колличестве слотов под нее"
#echo " Информация об оперативной памяти "
#dmidecode -t memory
# dmidecode --type memory
#echo ""
#echo -e "${BLUE}:: ${NC}Смотрим информацию об аппаратном обеспечении"
#echo " Информация о переключателях системной платы "
#dmidecode -t system
# dmidecode --type system
#echo ""
#echo -e "${BLUE}:: ${NC}Смотрим информацию о центральном процессоре (CPU)"
#dmidecode -t processor
# dmidecode --type processor
######################
sleep 1
clear
echo ""
echo -e "${BLUE}:: ${NC}Просмотреть объём используемой и свободной оперативной памяти, имеющейся в системе"
free -m  # Свободная / Неиспользуемая память
sleep 2
clear
echo ""
echo -e "${BLUE}:: ${NC}Посмотрим список установленных SCSI-устройств"
echo " Список устройств scsi/sata "
lsscsi  # маленькая консольная утилита выводящая список подключенных SCSI / SATA устройств
echo ""
echo -e "${BLUE}:: ${NC}Смотрим, какие диски есть в нашем распоряжении"
lsblk -f  # Команда lsblk выводит список всех блочных устройств
lsblk -ni
echo ""
echo -e "${BLUE}:: ${NC}Посмотрим структуру диска созданного установщиком"
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " => Укажите диск (sda/sdb например sda или sdb) : " cfd
sgdisk -p /dev/$cfd  #sda; sdb; sdc; sdd - sgdisk - это манипулятор таблицы разделов Unix-подобных систем
sleep 7
clear
echo ""
echo -e "${BLUE}:: ${NC}Удалить (стереть) таблицу разделов на выбранном диске (sdX)?"
echo -e "${RED}=> ${YELLOW}Примечание: ${BOLD}Перед удалением раздела или таблицы разделов сделайте резервную копию своих данных. Все данные автоматически удаляются при удалении. Так как при выполнении данной опции будет деинсталлирован сам системный загрузчик из раздела MBR жесткого диска. ${NC}"
echo -e "${BLUE}:: ${NC}В срипте установки есть 2 (два)! Варианта Стереть (удалить) таблицу разделов: 1(ый) - Для (Устаревшая)  MSDOS (MBR) [часто обозначается как BIOS, Legacy BIOS] - главная загрузочная запись - Master Boot Record, редакторы его могут отображать как dos или msdos. 2(ой) - Для (Современная) UEFI (GPT) - GUID Partition Table "
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора или вы уже подготовили диск к разметке и установки!"
echo -e "${MAGENTA}=> ${BOLD}Вот данные какие диски есть в вашем распоряжении (даже, если Вы работаете на VM): ${NC}"
echo ""
lsblk -f  # Команда lsblk выводит список всех блочных устройств
# df -h  # Перечислит тома на диске, подробно с точками монтирования и удобным размером
#fdisk -l  # Подробная информация о всех дисках
# cat /proc/partitions  # Перечислит диски, тома и размер дисков
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да удалить таблицу разделов MSDOS (MBR),    2 - Да удалить таблицу разделов UEFI (GPT),

    0 - Нет пропустить: " sgdisk  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$sgdisk" =~ [^120] ]]
do
    :
done
if [[ $sgdisk == 1 ]]; then
  echo ""
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
  read -p " => Укажите диск (sda/sdb например sda или sdb) : " cfd
  wipefs /dev/$cfd  # Проверьте таблицу разделов
  wipefs -a -t dos -f /dev/$cfd  # Вы можете очистить таблицу разделов " dos "
# cfdisk --zero /dev/$cfd  # cfdisk: Запускает редактор разделов с пользовательским интерфейсом curses ; --zero: флаг, который предписывает cfdiskочистить любую существующую таблицу разделов на данном устройстве, фактически «обнуляя» предыдущую настройку. Это эквивалентно сбросу структуры разделов. /dev/sdX: блочное устройство, выбранное для создания таблицы разделов. Пользователи должны убедиться, что указали правильное устройство, чтобы предотвратить потерю данных с непреднамеренных дисков. (https://man.archlinux.org/man/cfdisk.8)
# wipefs -a /dev/$cfd  # Стереть подпись с дискового устройства с помощью команды wipefs ; wipefs -a ${disk}
# wipefs -af /dev/$cfd  # Используйте -f опцию (принудительно)
# wipefs -a -f /dev/$cfd  # Чтобы очистить все таблицы разделов
# wipefs -o 0x1fe /dev/$cfd   # Вы также можете удалить таблицу разделов, используя значение смещения
# wipefs --all /dev/$cfd  # Очишение и форматирование  выбранного диска
# dd if=/dev/zero of=/dev/$cfd bs=512 count=1  # Вы можете просто записать несколько нулей в первый сектор соответствующего диска
# dd if=/dev/zero of=/dev/$cfd bs=512 count=1 conv=notrunc # Если при чтении исходного кода возникают ошибки чтения, conv=sync, noerror необходим, чтобы предотвратить остановку dd при ошибке и выполнение дампа. conv=sync в значительной степени бессмысленна без noerror.
## umount /dev/sd*  # Если проблема с затиранием
  echo " Создание новых записей MBR в памяти. "
  echo " Структуры данных MSDOS (MBR) уничтожены! Теперь вы можете разбить диск на разделы с помощью cfdisk или других утилит. "
elif [[ $sgdisk == 2 ]]; then
  echo ""
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
  read -p " => Укажите диск (sda/sdb например sda или sdb) : " cfd
  wipefs /dev/$cfd  # Проверьте таблицу разделов
# sgdisk --zap-all /dev/$cfd   #sda; sdb; sdc; sdd - sgdisk — командный манипулятор таблиц разделов GUID (GPT) для Linux и Unix ; sgdisk [параметры] устройство ; -Z, —zap-all (уничтожьте) структуры данных GPT и MBR, а затем выйдите. Этот параметр работает так же, как -z , но, поскольку он стирает как MBR, так и GPT, он более подходит, если вы хотите переразбить диск после использования этого параметра, и совершенно не подходит, если вы уже переразбили диск.
  wipefs -a -t gpt -f /dev/$cfd  # Вы можете очистить таблицу разделов GPT
  echo " Создание новых записей GPT в памяти. "
  echo " Структуры данных UEFI (GPT) уничтожены! Теперь вы можете разбить диск на разделы с помощью cfdisk или других утилит. "
elif [[ $sgdisk == 0 ]]; then
  echo " Операция Удаления (стерания) таблицу разделов пропущена "
fi
###
clear
echo -e "${MAGENTA}
  <<< Создание разделов диска для установки ArchLinux. Вся разметка диска(ов) производится только утилитой - cfdisk - (для управления разделами жёсткого диска) >>>
${NC}"
echo -e "${GREEN}==> ${NC}Cfdisk — это текстовый графический инструмент командной строки, который позволяет вам создавать, удалять и изменять разделы диска в вашей системе. В отличие от других инструментов командной строки, Cfdisk предоставляет интерактивный способ управления разделами для новичков. (https://www.makeuseof.com/how-to-create-resize-and-delete-linux-partitions-with-cfdisk/)"
echo -e "${RED}=> ${YELLOW}Предупреждение: ${BOLD}Перед созданием раздела(ов) или удалением таблицы разделов сделайте резервную копию своих данных. Повторю ещё раз - если что-то напутаете при разметке дисков, то можете случайно удалить важные для вас данные. Так как при выполнении данной опции (может) будет деинсталлирован сам системный загрузчик из раздела MBR жесткого диска. ${NC}"
echo -e "${RED}=> ${YELLOW}Обратите Внимание! ${BOLD}Что создавать отдельный загрузочный раздел для разметки диска в обычном BIOS НЕ обязательно, достаточно иметь Root раздел (корневой раздел) и все, (ещё МОЖНО создать Swap file или Swap partiton - свап файл и свап раздел), этого вполне достачно для установки системы под обычным BIOS в таблице разделов MBR/DOS.
  В скрипте установки для файловой системы прописан следующий сценарий: Выбираем нужный диск, теперь запускаем программу для разметки диска (указывая свой Диск). Программа очень простая, Delete - удаляет раздел, New - создает, Write - записывает изменения (прописать yes), Quit - выходит из программы. Создаем два раздела и запоминаем их имя (метку - sda/sdb 1.2.3.4 и т.д.). Для обычного BIOS Ext4 или Ext2 .
    ROOT / - Это ВАШ корневой раздел, он будет отформатирован в ( Ext4 ), ( Btrfs ) или ( XFS ) ;
    BOOT (boot) - Это ВАШ загрузочный раздел (ЕСЛИ таковой был создан при разметке!) будет отформатирован в ( Ext2 )или ( Ext4 ) ;
    SWAP (linux-swap) - Это ВАШ раздел подкачки (ЕСЛИ таковой был создан при разметке!) ;
    HOME (home) -  Это ВАШ домашний раздел (ЕСЛИ таковой был создан при разметке!), он будет отформатирован:
    в файловые системы ( Ext4 ), ( Btrfs ) или ( XFS ) по вашему выбору в дальнейшем.
    Для форматирования будем использовать утилиту mkfs.ext4 или mke2fs (mke2fs - это первоначальная утилита командной строки для форматирования в ext*). Это одна и та же утилита. У неё ВОТ такой синтаксис: mkfs.ext4 опции /раздел/диска ${NC}"
echo -e "$${BLUE}:: ${BOLD}Для MBR первичных разделов на диске может быть всего 4, они всегда имеют номера от 1 до 4. Если раздел имеет номер 5, 6, 7 и т.д, то это уже логический раздел, который находится внутри расширенного раздела. Расширенный раздел это первичный раздел, который не содержит собственной файловой системы, а содержит другие логические разделы. Нельзя создать пять или более первичных разделов. Здесь Вы также можете подготовить разделы для Windows (ntfs/fat32)(С;D;E), и в дальнейшем после разбиения диска(ов), их примонтировать. В сценарии (скрипта) прописано форматирование разделов для Windows, но эта функция закомментирована # . ${NC}"
echo ""
echo -e "${BLUE}:: ${NC}Вам нужна разметка диска?"
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да приступить к разметке,    0 - Нет пропустить разметку: " i_cfdisk  # файл устройство дискового накопителя;  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_cfdisk" =~ [^10] ]]
do
    :
done
if [[ $i_cfdisk == 1 ]]; then
  clear
  echo ""
  echo -e "${BLUE}:: ${NC}Выбор диска для установки"
  lsblk -f  # Команда lsblk выводит список всех блочных устройств
  #lsblk -Df
  echo ""
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
  read -p " => Укажите диск (sda/sdb например sdX, vdX, nvme*nX) : " namedisk
  # cfdisk -V   # -V, –version: Отображение сведений о версии Cfdisk.
  # cfdisk -h   # -h, –help: Отображение справки по использованию Cfdisk.
  #cfdisk -L /dev/$namedisk   # -L, --color: Раскрасить выводимые на экран данные.
  cfdisk --color /dev/$namedisk  # Раскрасить вывод ; Этот параметр используется для выделения цветом выходных данных для лучшей читаемости
  #cfdisk /dev/$cfd  # Утилита cfdisk используется для работы с дисковым пространством в операционных системах Linux
  #cfdisk --zero /dev/$namedisk   # -z, --zero: Это позволяет создать новую таблицу разделов с нуля. Предыдущая таблица разделов не считывается приложением.
  echo ""
  clear
elif [[ $i_cfdisk == 0 ]]; then
  echo " Разметка диска(ов) (разделов) пропропущена "
fi
### cat /proc/partitions  # Чтобы перечислить все разделы диска, используйте следующую команду
clear
echo ""
echo -e "${BLUE}:: ${NC}Ваша разметка диска"
fdisk -l  # Посмотрим список доступных (созданных) дисков и разделов
lsblk -f  # Команда lsblk выводит список всех блочных устройств
#lsblk -lo  # Команда lsblk выводит список всех блочных устройств
sleep 5
###

clear
echo ""
echo -e "${GREEN}==> ${NC}Форматирование разделов диска"
echo -e "${BLUE}:: ${NC}Установка название флага boot, root, swap, home"
echo -e "${BLUE}:: ${NC}Монтирование разделов диска"
echo -e "${YELLOW}==> Примечание! ${BOLD}*Команда mkfs (make file system) используется для создания файловой системы на блочном устройстве, таком как жесткий диск или флэш-накопитель. Без создания файловой системы устройство не может быть использовано для хранения данных. ${NC}"
echo -e "${YELLOW}==> Предисловие! ${BOLD} О файловых системах: ${NC}"
echo " Ext4 (Fourth Extended Filesystem) — журналируемая файловая система, используемая преимущественно в операционных системах с ядром Linux. Представлена в 2008 году как прогрессивная версия файловой системы ext3. Ext4 — это надежная и стабильная файловая система, которая сохраняет наши данные в безопасности в большинстве нежелательных событий, таких как сбой питания. Ext4 — универсальный выбор для простых конфигураций. "
echo " Btrfs (B-tree File System) — файловая система для Linux, разработанная компанией Oracle в 2007 году. Основана на структурах B-деревьев и работает по принципу «копирование при записи» (Copy-on-Write, CoW). Btrfs — для домашнего использования, где важны гибкость и возможность легко откатывать обновления. Btrfs — для систем, где важны современные функции. "
echo " XFS — высокопроизводительная 64-битная журналируемая файловая система, разработанная компанией Silicon Graphics для операционной системы IRIX. Поддерживается большинством дистрибутивов Linux. Например, XFS — файловая система по умолчанию в Red Hat Enterprise Linux, Oracle Linux, CentOS. XFS для крупномасштабных баз данных. В файловой системе XFS Нельзя уменьшить размер! "
### File systems: https://wiki.archlinux.org/title/File_systems
### mkfs [параметры] [-t <тип>] [параметры ФС] <устройство> [<размер>]
sleep 05
########## Root  ########
lsblk -f  # Команда lsblk выводит список всех блочных устройств
sleep 01
echo ""
echo -e "${BLUE}:: ${NC}Форматируем и монтируем ROOT- (Корневой) раздел?"
echo " Если таковой был создан при разметке в cfdisk "
echo " Либо ROOT был создан вами заранее и готов к дальнейшим действиям "
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите ROOT раздел (sda/sdb 1.2.3.4 (sda5 например)): " root  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Форматировать root в Ext4,   2 - Форматировать root в Btrfs,

    3 - Форматировать root в XFS: " roots  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$roots" =~ [^123] ]]
do
    :
done
if [[ $roots == 1 ]]; then
 echo ""
 echo " Создадим файловую систему Ext4 для корневого раздела "
  pacman -S --noconfirm --needed e2fsprogs arch-install-scripts  # Установим утилиты, *Если таковые не были установлены !
### e2fsprogs - Утилиты файловой системы Ext2/3/4 ; https://archlinux.org/packages/core/x86_64/e2fsprogs/ ; http://e2fsprogs.sourceforge.net/ ; Обеспечивает: libcom_err.so=2-64, libe2p.so=2-64, libext2fs.so=2-64, libss.so=2-64 ; 2025-07-10 09:11 UTC
### arch-install-scripts - Скрипты для помощи в установке Arch Linux ; https://archlinux.org/packages/extra/any/arch-install-scripts/ ; https://gitlab.archlinux.org/archlinux/arch-install-scripts ; 2024-10-30 21:58 UTC
# pacman -S --noconfirm --needed lvm2  # (необязательно) - для e2scrub ; Утилиты Logical Volume Manager 2
### lvm2 - Утилиты Logical Volume Manager 2 ; https://archlinux.org/packages/core/x86_64/lvm2/ ; https://sourceware.org/lvm2/ ; Конфликты:  lvm, mkinitcpio<38-1 ; 2025-09-11 08:28 UTC
# mkfs.ext4 /dev/$root -L root  # или - mkfs.ext4 /dev/$root -L archroot
### Команда, чтобы не вводить 'y'
  echo 'y' | mkfs.ext4 /dev/$root -L root  # Форматировать Ext4
 echo ""
 echo " Проверка файловой системы на ошибки и их автоматическое исправление "
### Fsck (File System Consistency Check) — утилита для Linux и Unix-подобных систем, которая проверяет и (по возможности) чинит файловые системы (ФС). Работает почти со всеми популярными ФС: ext2/3/4, XFS, Btrfs, ReiserFS, JFS и т. д..
### Базовый синтаксис: fsck <options> <filesystem>. В этом примере файловой системой может быть устройство, раздел, точка монтирования и так далее. Некоторые опции: -A — проверить все файловые системы из /etc/fstab; -C — показать прогресс проверки файловой системы; -M — не проверять, если файловая система смонтирована; -N — ничего не выполнять, показать, что проверка завершена успешно.
### Примеры использования: Для работы нужны права суперпользователя (root-доступом).
# fsck -y /dev/$root  # Проверка файловой системы на ошибки и их автоматическое исправление
  fsck -n /dev/$root  # Проверка файловой системы на наличие ошибок, которые пока не нужно исправлять
# fsck -t -A ext4  # Проверка раздела с заданной файловой системой ext4
# fsck -AM  # Чтобы выполнить проверку файловой системы только на несмонтированных дисках
 echo ""
 echo " Смонтируем корневой раздел в /mnt "
  mount /dev/$root /mnt  # Монтирование в /mnt ; /mnt - каталог для ручного монтирования файловых систем
#  mkdir /mnt/boot
#  mkdir /mnt/home
# mkdir /mnt/{boot,home}
 echo ""
 echo " Узнать тип смонтированной файловой системы "
# mount | grep -E /dev/$root  # Чтобы узнать тип смонтированной файловой системы
 mount | grep /dev/$root
# mount | grep ext4  # отображать только файловые системы Ext4
sleep 03
 echo ""
 echo " Форматирование и монтирование выполнено "
if [[ $roots == 2 ]]; then
 echo ""
 echo " Создадим файловую систему Btrfs для корневого раздела "
  pacman -S --noconfirm --needed btrfs-progs arch-install-scripts  # Установим утилиты, *Если таковые не были установлены !
### btrfs-progs - Утилиты файловой системы Btrfs ; https://archlinux.org/packages/core/x86_64/btrfs-progs/ ; https://btrfs.readthedocs.io/ ; Обеспечивает: btrfs-progs-unstable ; Заменяет: btrfs-progs-unstable ; Конфликты: btrfs-progs-unstable ; 2025-09-12 16:30 UTC
### arch-install-scripts - Скрипты для помощи в установке Arch Linux ; https://archlinux.org/packages/extra/any/arch-install-scripts/ ; https://gitlab.archlinux.org/archlinux/arch-install-scripts ; 2024-10-30 21:58 UTC
# pacman -S --noconfirm --needed lvm2  # (необязательно) - для e2scrub ; Утилиты Logical Volume Manager 2
### lvm2 - Утилиты Logical Volume Manager 2 ; https://archlinux.org/packages/core/x86_64/lvm2/ ; https://sourceware.org/lvm2/ ; Конфликты:  lvm, mkinitcpio<38-1 ; 2025-09-11 08:28 UTC
# mkfs.btrfs -f /dev/$root -L root  # или - mkfs.btrfs -f /dev/$root - без -L|--label <строка>
# mkfs.btrfs -f -L root /dev/$root
### Команда, чтобы не вводить 'y'
  echo 'y' | mkfs.btrfs -f /dev/$root -L root
# echo 'y' | mkfs.btrfs -f /dev/$root  # /dev/sda<цифра>
### mkfs.btrfs ; mkfs.btrfs [опции] <устройство> [<устройство>…] ; https://btrfs.readthedocs.io/en/latest/mkfs.btrfs.html
### -f|--force ; Принудительно перезаписывать блочные устройства при обнаружении существующей файловой системы. По умолчанию mkfs.btrfs использует libblkid для проверки наличия известных файловых систем на устройствах. В качестве альтернативы, для очистки устройств можно использовать утилиту wipefs .
### sudo mkfs.btrfs --label "{{label}}" {{/dev/sda}} [{{/dev/sdN}}] ; Установите метку для файловой системы
### -L|--label <строка> ; Укажите метку файловой системы. Длина строки должна быть меньше 256 байт и не должна содержать символов перевода строки.
 echo ""
 echo " Проверка файловой системы на ошибки и их автоматическое исправление "
 echo " Проверка файловой системы для Btrfs не требуется "
### При генерации initramfs mkinitcpio будет ругаться на отсутствие fsck.btrfs - это нормальное явление. Уберём этот хук fsck из конфига, т.к. для Btrfs он не требуется.
# nano /etc/mkinitcpio.conf
### Вот данная строка в файле:
# HOOKS="base udev autodetect modconf block filesystems keyboard"
### И пересоздадим initramfs:
# mkinitcpio -p linux  # или linux-lts
sleep 01
echo ""
echo -e "${BLUE}:: ${NC} Смонтируем ROOT- (Корневой раздел) в /mnt "
echo " Чтобы создать подтома в каталоге /mnt, вам нужно выбрать вариант монтирования: "
echo " Монтирование Btrfs с HOME (home) разделом (ЕСЛИ таковой был создан при разметке!) введите: 1 "
echo " Монтирование Btrfs БЕЗ HOME (home) раздела (ЕСЛИ таковой НЕ был создан при разметке!) введите: 2 "
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Монтирование Btrfs с HOME (home) разделом,  2 - Монтирование Btrfs БЕЗ HOME (home) раздела: " in_mounts  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_mounts" =~ [^12] ]]
do
    :
done
if [[ $in_mounts == 1 ]]; then
  echo ""
  echo " Монтирование ROOT- с HOME (home) разделом "
mount /dev/$root /mnt  # Монтирование в /mnt ; /mnt - каталог для ручного монтирования файловых систем
# mkdir -p /mnt/{home,boot,var,.snapshots}
# mkdir -p /mnt/{boot/efi,home,var/log,var/cache/pacman/pkg,btrfs}
### Опция -p в команде mkdir (make directory) в Linux приказывает создавать родительские каталоги одновременно с каталогом. Это позволяет: создавать вложенные каталоги без необходимости создавать каждый родительский каталог по отдельности; создавать несколько уровней каталогов за одну команду.
 echo ""
 echo " Узнать тип смонтированной файловой системы "
# mount | grep -E /dev/$root  # Чтобы узнать тип смонтированной файловой системы
mount | grep /dev/$root
# mount | grep btrfs  # отображать только файловые системы Btrfs
  echo ""
  echo " Размонтируем (отмонтируем) корневой раздел смонтированный в каталоге /mnt "
# umount /mnt
 umount -R /mnt
elif [[ $in_mounts == 2 ]]; then
  echo ""
  echo " Монтирование ROOT- БЕЗ HOME (home) раздела "
 mount /dev/$root /mnt  # Монтирование в /mnt ; /mnt - каталог для ручного монтирования файловых систем
  echo ""
  echo " Создаем подразделы (Subvolume /@) на смонтированном btrfs разделе в каталоге /mnt "
### btrfs su cr - псевдоним для btrfs subvolume create. Название подразделов начинаются с @ чтобы не путать их с другими каталогами.
### Я бы предложил по крайней мере один подтом для корня (@) и один для снимков (@snapshots). varlog и tmp созданы для простого отключения копирования при записи на /var/log и /tmp.
btrfs su cr /mnt/@             # @ - Корневой подтом
btrfs su cr /mnt/@home         # @home - Домашний подтом
btrfs su cr /mnt/@snapshots    # @snapshots - Snapper будет хранить здесь ваши снимки BTRFS. Если Snapper не используется, этот раздел не нужен.
#btrfs su cr /mnt/@.snapshots
btrfs su cr /mnt/@var          # @var - Журналы, некоторые временные файлы, кэши и т. д.
btrfs su cr /mnt/@log          # @log - Журналы работы утилит, некоторые временные файлы
# btrfs su cr /mnt/@varlog
btrfs su cr /mnt/@opt          # @opt - Каталог, в котором размещаются стороннее программное обеспечение и пакеты
btrfs su cr /mnt/@pkg          # @pkg - Каталог, в который утилита makepkg помещает скомпилированные файлы
btrfs su cr /mnt/@tmp          # @tmp - Основное расположение временных файлов
btrfs sub cr /mnt/@cache       # @cache - Это кэш пакетного менеджера (pacman)
#btrfs sub cr /mnt/@swap        # @swap - Хранит файл подкачки. Должен монтироваться с nodatacow
  echo ""
  echo " Проверка создания томов в /mnt "
btrfs subvolume list /mnt
# btrfs sub list /mnt
# cat /etc/fstab
sleep 03
#  echo ""
#  echo " Отключить копирование при записи /var/log и /tmp "
#chattr +C /mnt/@var
#chattr +C /mnt/@log
# chattr +C /mnt/@varlog
#chattr +C /mnt/@tmp
  echo ""
  echo " Размонтируем (отмонтируем) корневой раздел смонтированный в каталоге /mnt "
# umount /mnt
umount -R /mnt
  echo " Размонтирование смонтированного корневого раздела выполнено "
  sleep 01
#clear
echo ""
echo -e "${GREEN}==> ${NC}Ваш диск SSD или HDD? "
echo -e "${YELLOW} Примечание! ${BOLD} *Для дальнейшего монтирования папок в каталоге /mnt ,
добавления параметров монтирования и последующей записи информации нужно выяснить формат вашего накопителя (диска). ${NC}"
echo -e "${BLUE}:: ${NC}Выберите свой вариант накопителя (диска): "
echo -e "${CYAN}:: ${NC}Если у вас SSD (Solid-State Drive), Nvme, m2 или usb_flash -> Выберите: 1 "
echo -e "${CYAN}:: ${NC}Если у вас HDD (Твердотельные накопитель, Жёсткий диск, винчестер) -> Выберите: 2 "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - SSD (Solid-State Drive) - Nvme - m2 - usb_flash,     2 - HDD (Твердотельные накопитель, Жёсткий диск, винчестер): " subst  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$subst" =~ [^12] ]]
do
    :
done
if [[ $subst == 1 ]]; then
echo ""
echo " SSD (Solid-State Drive) - Nvme - m2 - usb_flash "
echo " Добавление параметров монтирования "
sub='rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,subvol'
case "$sub " in
esac
echo " Добавление параметров монтирования выполнено "
sleep 01
### Rw и noatime — это опции монтирования файловой системы в файле fstab.
# Rw (read-write) означает, что файловая система монтируется для чтения и записи. Это параметр по умолчанию, который позволяет записывать и читать данные на файловой системе.
# Noatime — опция, которая отключает обновление времени доступа к файлам при каждом их чтении.
# compress=zstd – использует алгоритм сжатия zstd для сжатия данных на диске с целью экономии места и, в некоторых случаях, может даже повысить производительность чтения/записи.
# SSD — предполагает, что базовым устройством является SSD, и позволяет BTRFS изменять свое поведение на основе этого предположения для повышения производительности.
# space_cache=v2 – использует версию 2 кэша свободного пространства, которая более эффективна и менее подвержена повреждению.
# Discard=async — опция монтирования файловой системы BTRFS, которая включает поддержку асинхронного сброса. Суть опции: незанятые блоки группируются и освобождаются позже в отдельном потоке, что улучшает задержки при записи на диск и бережнее относится к SSD в плане перезаписи.
# subvol=/ – указывает подтом файловой системы BTRFS для монтирования, в данном случае это подтом верхнего уровня.
elif [[ $subst == 2 ]]; then
echo ""
echo " HDD (Твердотельные накопитель, Жёсткий диск, винчестер) "
echo " Добавление параметров монтирования "
sub='rw,relatime,space_cache=v2,autodefrag,nodatacow,subvol'
case "$sub " in
esac
echo " Добавление параметров монтирования выполнено "
sleep 01
### Конструкция case: https://metanit.com/os/linux/12.9.php
# Rw (read-write) означает, что файловая система монтируется для чтения и записи. Это параметр по умолчанию, который позволяет записывать и читать данные на файловой системе
# Relatime указывает, что время доступа к файлу будет обновляться только в том случае, если предыдущее время обращения меньше времени изменения файла.
# space_cache=v2 – использует версию 2 кэша свободного пространства, которая более эффективна и менее подвержена повреждению.
# autodefrag - Обнаруживает небольшие случайные записи в файлы и ставит их в очередь для автоматического дефрагментации, поэтому файловая система будет дефрагментировать себя, пока она используется. Не подходит для виртуализации или высоконагруженных баз данных, но хорошо работает для небольших файлов.
# nodatacow - отключает COW для данных. Можно применять к отдельному файлу либо к подтому/директории, в том числе рекурсивно. Он отключает механизм copy on write, благодаря чему Btrfs при обновлении содержимого файла будет всегда работать с фиксированной дисковой областью, записывая данные поверх существующих (на физическом уровне).
# subvol=/ – указывает подтом файловой системы BTRFS для монтирования, в данном случае это подтом верхнего уровня.
  echo ""
  echo " Смонтировать раздел как подтома... "
mount -o ${sub}=@ /dev/$root /mnt
  echo ""
  echo " Создания нескольких папок в каталоге /mnt "
  echo " Команда, которая создаёт следующие папки: boot, home, var, var/log, var/cache/pacman/pkg и .snapshots "
mkdir -p /mnt/{boot,home,var,opt,tmp,var/log,var/cache/pacman/pkg,.snapshots}  # создаёт папки: boot, home, var, var/log, var/cache/pacman/pkg и .snapshots
  echo ""
  echo " Монтирование папок в каталоге /mnt "
mount -o ${sub}=@home /dev/$root /mnt/home
mount -o ${sub}=@var /dev/$root /mnt/var
mount -o ${sub}=@log /dev/$root /mnt/var/log
mount -o ${sub}=@pkg /dev/$root /mnt/var/cache/pacman/pkg
mount -o ${sub}=@.snapshots /dev/$root /mnt/.snapshots
mount -o ${sub}=@tmp /dev/$root /mnt/tmp
mount -o ${sub}=@opt /dev/$root /mnt/opt
  echo ""
  echo " Монтирование папок (каталогов) в каталоге /mnt завершено "
if [[ $roots == 3 ]]; then
echo ""
echo " Создадим файловую систему XFS для корневого раздела "
pacman -S --noconfirm --needed xfsprogs arch-install-scripts  # Установим утилиты, *Если таковые не были установлены !
### arch-install-scripts - Скрипты для помощи в установке Arch Linux ; https://archlinux.org/packages/extra/any/arch-install-scripts/ ; https://gitlab.archlinux.org/archlinux/arch-install-scripts ; 2024-10-30 21:58 UTC
### xfsprogs - Утилиты файловой системы XFS в пространстве пользователя. Данный пакет содержит средства, необходимые для управления файловой системой XFS ; https://archlinux.org/packages/core/x86_64/xfsprogs/ ; https://xfs.wiki.kernel.org/ ; 2025-09-08 13:35 UTC
### XFS ArchWiki: https://wiki.archlinux.org/title/XFS
# pacman -S --noconfirm --needed lvm2  # (необязательно) - для e2scrub ; Утилиты Logical Volume Manager 2
### lvm2 - Утилиты Logical Volume Manager 2 ; https://archlinux.org/packages/core/x86_64/lvm2/ ; https://sourceware.org/lvm2/ ; Конфликты:  lvm, mkinitcpio<38-1 ; 2025-09-11 08:28 UTC
# mkfs.xfs /dev/$root -L root  # или - mkfs.xfs /dev/$root -L archroot
# mkfs.xfs -f /dev/$root  # Принудительное создание файловой системы XFS поверх любой существующей. Это опция команды mkfs.xfs (из пакета xfsprogs). Опция -f (от force) нужна, если на указанном разделе уже существует файловая система другого типа, и нужно её перезаписать.
### Команда, чтобы не вводить 'y'
  echo 'y' | mkfs.xfs /dev/$root -L root  # Форматировать в XFS
# echo 'y' | mkfs.xfs -f /dev/$root -L root  # Форматировать в XFS Принудительно!
### *При использовании mkfs.xfs на блочном устройстве, содержащем существующую файловую систему, добавьте опцию -f для перезаписи этой файловой системы. Эта операция уничтожит все данные, содержащиеся в предыдущей файловой системе.
# mkfs.xfs -f /dev/$root -L root  # При использовании mkfs.xfs на блочном устройстве
# echo 'y' | mkfs.xfs -f /dev/$root -L root  # Форматировать XFS
### В целом, параметры по умолчанию оптимальны для обычного использования: meta-data=/dev/device
# meta-data=/dev/$root
 echo ""
 echo " Проверка файловой системы на ошибки и их автоматическое исправление "
### Fsck (File System Consistency Check) — утилита для Linux и Unix-подобных систем, которая проверяет и (по возможности) чинит файловые системы (ФС). Работает почти со всеми популярными ФС: ext2/3/4, XFS, Btrfs, ReiserFS, JFS и т. д..
### Базовый синтаксис: fsck <options> <filesystem>. В этом примере файловой системой может быть устройство, раздел, точка монтирования и так далее. Некоторые опции: -A — проверить все файловые системы из /etc/fstab; -C — показать прогресс проверки файловой системы; -M — не проверять, если файловая система смонтирована; -N — ничего не выполнять, показать, что проверка завершена успешно.
### Примеры использования: Для работы нужны права суперпользователя (root-доступом).
# fsck -y /dev/$root  # Проверка файловой системы на ошибки и их автоматическое исправление
 fsck -n /dev/$root  # Проверка файловой системы на наличие ошибок, которые пока не нужно исправлять
# fsck -t -A ext4  # Проверка раздела с заданной файловой системой ext4
# fsck -AM  # Чтобы выполнить проверку файловой системы только на несмонтированных дисках
 echo ""
 echo " Смонтируем корневой раздел в /mnt "
### Монтирование — команда sudo mount /dev/device /mount/point, где /mount/point — каталог, где будет смонтирована файловая система XFS.
### Автоматическое монтирование — можно обновить файл /etc/fstab, добавив запись для файловой системы XFS.
  mount /dev/$root /mnt  # Монтирование в /mnt ; /mnt - каталог для ручного монтирования файловых систем
#  mkdir /mnt/boot
#  mkdir /mnt/home
# mkdir /mnt/{boot,home}
 echo ""
 echo " Узнать тип смонтированной файловой системы "
# mount | grep -E /dev/$root  # Чтобы узнать тип смонтированной файловой системы
  mount | grep /dev/$root
# mount | grep xfs  # отображать только файловые системы XFS
sleep 03
 echo ""
 echo " Форматирование и монтирование выполнено "
#fi
  fi
fi
########## Boot  ########
### Install Arch Linux on Legacy BIOS with MBR - https://www.youtube.com/watch?v=smdZdPLHjWc
clear
echo ""
lsblk -f  # Команда lsblk выводит список всех блочных устройств
echo ""
echo -e "${BLUE}:: ${NC}Форматируем BOOT- (Загрузочный) раздел?"
echo " Если таковой был создан при разметке в cfdisk "
echo " Либо BOOT был создан вами заранее и готов к дальнейшим действиям "
echo " Выберите файловую систему для вашего загрузочного раздела BOOT "
echo " *В сценарии (скрипта) прописаны следующие варианты: "
echo -e "${YELLOW} Внимание! ${BOLD} *Для установки в раздел DOS/MBR или Bios ${NC}"
echo -e "${CYAN}:: ${NC}Проще говоря — Для обычного Bios форматировать нужно в Ext2 или Ext4 "
echo " Форматировать BOOT- раздел в файловую систему Ext2 , то введите: 1 "
echo " Форматировать BOOT- раздел в файловую систему Ext4 , то введите: 2 "
echo -e "${YELLOW} Внимание! ${BOLD} *Для установки в UEFI (Unified Extensible Firmware Interface) ${NC}"
echo -e "${CYAN}:: ${NC}UEFI заменяет традиционный BIOS на PC (Поддержка GPT) — форматировать нужно в FAT32 "
echo " Форматировать BOOT- раздел в файловую систему FAT32 , то введите: 3 "
echo -e "${YELLOW} Внимание! ${BOLD} *Если вы не создавали отдельный BOOT раздел и он будет расположен в / ROOT ${NC}"
echo -e "${YELLOW} Примечание! ${BOLD} *Для установки в один раздел DOS/MBR или рядом с Windows ${NC}"
echo -e "${CYAN}:: ${NC}Просто пропустите действие форматирование и введите: 0 "
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите BOOT раздел (sda/sdb 1.2.3.4 (sda5 например)): "  bootd  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Форматировать boot в Ext2,   2 - Форматировать boot в Ext4,

    3 - Форматировать boot в FAT32,   0 - НЕ Форматировать (пропустить): " boots  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$boots" =~ [^1230] ]]
do
    :
done
if [[ $boots == 1 ]]; then
 echo ""
 echo " Создадим файловую систему Ext2 для загрузочного раздела "
### mkfs [опции] [-t тип_фс] [опции_фс] устройство
### mkfs.тип_фс [опции] [опции_фс] устройство
# Опции команды mkfs:
# -t или --type — тип файловой системы, по умолчанию ext2
# -V или --verbose — подробная информация; указание два раза приведет к тестовому запуску
# -V или --version — информация о используемой версии
# -h или --help — краткая справка о команде
# mkfs.ext2  /dev/$bootd -L boot   # или - mkfs.ext2  /dev/$bootd -L archboot
# mkfs -t ext2 -L boot /dev/$bootd  # Параметр -t (или --type) указывает тип создаваемой файловой системы. Если этот параметр не указан, то по умолчанию принимается тип ext2 . mkfs используется для создания файловой системы на блочном устройстве, таком как жёсткий диск или флэш-накопитель.
### Команда, чтобы не вводить 'y'
 echo 'y' | mkfs.ext2 /dev/$bootd -L boot
  echo ""
  echo " Создания папки boot в каталоге /mnt "
# mkdir /mnt/boot
  mkdir -p /mnt/boot  # mkdir -p НЕ выдаст ошибку, если каталог уже существует и его содержимое не изменится.
  echo ""
  echo " Монтирование BOOT- раздел в /mnt/boot "
  mount /dev/$bootd /mnt/boot
 echo ""
 echo " Форматирование и монтирование выполнено "
 sleep 01
if [[ $boots == 2 ]]; then
 echo ""
 echo " Создадим файловую систему Ext4 для загрузочного раздела "
# mkfs.ext4 -O \^64bit /dev/$bootd -L boot  # -O - активировать или деактивировать те или иные возможности файловой системы. Сами возможности мы рассмотрим ниже; 64bit - файловая система сможет занимать место больше чем 2 в 32 степени блоков. При размере блока 4 килобайта, это примерно один терабайт;
# mkfs.ext4  /dev/$bootd -L boot   # или - mkfs.ext4  /dev/$bootd -L archboot
### Команда, чтобы не вводить 'y'
 echo 'y' | mkfs.ext4 /dev/$bootd -L boot
  echo ""
  echo " Создания папки boot в каталоге /mnt "
# mkdir /mnt/boot
  mkdir -p /mnt/boot  # mkdir -p НЕ выдаст ошибку, если каталог уже существует и его содержимое не изменится.
  echo ""
  echo " Монтирование BOOT- раздел в /mnt/boot "
  mount /dev/$bootd /mnt/boot
 echo ""
 echo " Форматирование и монтирование выполнено "
 sleep 01
 if [[ $boots == 3 ]]; then
 echo ""
 echo " Создадим файловую систему FAT32 для загрузочного раздела "
# mkfs.vfat -F32 /dev/$bootd -L boot   # или - mkfs.vfat -F32 /dev/$bootd -L archboot
### Команда, чтобы не вводить 'y'
 echo 'y' | mkfs.vfat -F32 /dev/$bootd -L boot
  echo ""
  echo " Создания папки boot в каталоге /mnt "
# mkdir /mnt/boot
# mkdir -p /mnt/boot  # mkdir -p НЕ выдаст ошибку, если каталог уже существует и его содержимое не изменится.
  mkdir -p  /mnt/boot/efi
  echo ""
  echo " Монтирование BOOT- раздел в /mnt/boot "
#  mount /dev/$bootd /mnt/boot
mount /dev/$bootd /mnt/boot/efi
# mount --mkdir /dev/$bootd /mnt/boot  # Для систем UEFI смонтируйте системный раздел EFI
### Запустите mount(https://man.archlinux.org/man/mount.8) с --mkdir возможностью создания указанной точки монтирования. В качестве альтернативы, создайте её заранее с помощью mkdir(https://man.archlinux.org/man/mkdir.1) .
 echo ""
 echo " Форматирование и монтирование выполнено "
 sleep 01
elif [[ $boots == 0 ]]; then
 echo ""
 echo " Форматирование и монтирование не требуется "
 sleep 01
fi
########## Swap  ########
clear
echo ""
lsblk -f  # Команда lsblk выводит список всех блочных устройств
echo ""
echo -e "${BLUE}:: ${NC}Форматируем Swap- (Подкачка) раздел?"
echo " Если таковой был создан при разметке в cfdisk "
echo " Либо у вас достаточно ОЗУ или вы захотите создать просто файл подкачки "
echo -e "${YELLOW}==> Примечание! ${BOLD}*Swap — может быть как отдельным разделом диска, так и обычным файлом. Используются исключительно для создания виртуальной памяти. Виртуальная память необходима в случае нехватки основной памяти (ОЗУ), однако скорость работы при использовании такой памяти значительно уменьшается. Swap необходим для компьютеров с малым объемом памяти, в этом случае рекомендуется создать swap-раздел или файл размером в 2-4 раза больше, чем ОЗУ компьютера. Также swap необходим для перехода в режим сна, в этом случае необходимо выделить объем памяти равный ОЗУ компьютера или чуть больше. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да форматировать и монтировать,  0 - Нет пропустить действие: " swap  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$swap" =~ [^10] ]]
do
    :
done
if [[ $swap == 1 ]]; then
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
  read -p " Укажите swap раздел (sda/sdb 1.2.3.4 (sda7 например)): " swaps  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
  echo ""
  echo " Форматирование и подключение Swap раздела "
  mkswap /dev/$swaps -L swap   # или - mkswap /dev/$swaps -L archswap ; создать раздел подкачки
  swapon /dev/$swaps  # включить подкачку на этом разделе, перезагрузка системы не потребуется
# swapoff /dev/$swaps  # Для деактивации раздела подкачки
# sudo free  # Под временной активацией понимается что вы активируете SWAP только для активной ОС, т.е. если ваш компьютер перезагружается созданный вами SWAP снова становится неактивным (по аналогии с mount). Если есть желание проверить что активация действительно временная можно перезагрузить компьютер и снова выполнить free (показывает информации по виртуальной памяти).
# sudo systemctl daemon-reload  # Перезапуск службы
# sudo swapon -a  # Команда сделает активацию всех записей в /etc/fstab с меткой swap. UUID раздела нам вывела команда mkswap
# sudo lsblk --fs /dev/$swaps  # если вы её потеряли не беда выполняем команду
  lsblk --fs /dev/$swaps
  sleep 03
# mkswap  # Посмотреть UUID раздела
### mkswap — настройка области подкачки Linux  https://man.archlinux.org/man/mkswap.8
# swapon-summary  # После запуска swapon вы можете проверить, какие области пространства подкачки используются
 sleep 01
elif [[ $swap == 0 ]]; then
  echo ""
  echo " Добавление Swap раздела пропущено "
fi
########## Home  ########
clear
echo ""
echo -e "${BLUE}:: ${NC}Добавим HOME- (Домашний) раздел?"
echo " Если таковой был создан при разметке в cfdisk "
echo " Либо HOME был создан вами заранее и готов к дальнейшим действиям "
echo -e "${CYAN}=> ${NC}Можно использовать раздел от предыдущей системы (и его не форматировать)! "
echo -e "${YELLOW}==> Примечание! ${BOLD}*Далее в процессе установки в сценарии будет Пункт, в котором можно будет удалить все скрытые файлы и папки в каталоге пользователя "home/USERNAME" (от предыдущей системы). ${NC}"
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да добавить Home раздел,    0 - Нет не добавлять (пропустить): " homes  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$homes" =~ [^10] ]]
do
    :
done
if [[ $homes == 0 ]]; then
  echo ""
  echo " Добавление Home раздела пропущено. "
elif [[ $homes == 1 ]]; then
  echo " Добавление HOME (домашнего) раздела "
echo ""
echo -e "${BLUE}:: ${NC}Форматируем и монтируем HOME- (Домашний) раздел?"
echo " Либо HOME был отформатирован вами заранее и готов к дальнейшим действиям "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo -e "${CYAN}:: ${NC}Посмотрите вывод списка всех блочных устройств "
echo ""
lsblk -f  # Команда lsblk выводит список всех блочных устройств
sleep 03
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите HOME раздел (sda/sdb 1.2.3.4 (sda6 например)): " home  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Форматировать home в Ext4,  2 - Форматировать home в Btrfs,

    3 - Форматировать home в XFS,   0 - Нет не форматировать: " homeF  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$homeF" =~ [^1230] ]]
do
    :
done
   if [[ $homeF == 1 ]]; then
 echo ""
 echo " Создадим файловую систему Ext4 для домашнего раздела "
# mkfs.ext4 /dev/$home -L home  # или - mkfs.ext4 /dev/$home -L archhome
### Команда, чтобы не вводить 'y'
  echo 'y' | mkfs.ext4 /dev/$home -L home  # Форматировать Ext4
 echo ""
 echo " Проверка файловой системы на ошибки и их автоматическое исправление "
# fsck -y /dev/$home  # Проверка файловой системы на ошибки и их автоматическое исправление
  fsck -n /dev/$home  # Проверка файловой системы на наличие ошибок, которые пока не нужно исправлять
# fsck -t -A ext4  # Проверка раздела с заданной файловой системой ext4
# fsck -AM  # Чтобы выполнить проверку файловой системы только на несмонтированных дисках
  echo ""
  echo " Создания папки home в каталоге /mnt "
# mkdir /mnt/boot
# mkdir /mnt/home
  mkdir -p /mnt/home
# mkdir /mnt/{boot,home}
 echo ""
 echo " Смонтируем home (домашний) раздел в /mnt "
  mount /dev/$home /mnt/home  # Монтирование в /mnt ; /mnt - каталог для ручного монтирования файловых систем
 echo ""
 echo " Узнать тип смонтированной файловой системы "
# mount | grep -E /dev/$home  # Чтобы узнать тип смонтированной файловой системы
 mount | grep /dev/$home
# mount | grep ext4  # отображать только файловые системы Ext4
sleep 03
 echo ""
 echo " Форматирование и монтирование выполнено "
if [[ $homeF == 2 ]]; then
 echo ""
 echo " Создадим файловую систему Btrfs для домашнего раздела "
# mkfs.btrfs -f /dev/$home -L home  # или - mkfs.btrfs -f /dev/$home - без -L|--label <строка>
# mkfs.btrfs -f -L home /dev/$home
### Команда, чтобы не вводить 'y'
  echo 'y' | mkfs.btrfs -f /dev/$home -L root
# echo 'y' | mkfs.btrfs -f /dev/$home  # /dev/sda<цифра>
 echo ""
 echo " Проверка файловой системы на ошибки и их автоматическое исправление "
 echo " Проверка файловой системы для Btrfs не требуется "
### При генерации initramfs mkinitcpio будет ругаться на отсутствие fsck.btrfs - это нормальное явление. Уберём этот хук fsck из конфига, т.к. для Btrfs он не требуется.
# nano /etc/mkinitcpio.conf
### Вот данная строка в файле:
# HOOKS="base udev autodetect modconf block filesystems keyboard"
### И пересоздадим initramfs:
# mkinitcpio -p linux  # или linux-lts
 echo ""
 echo " Монтирование Btrfs с HOME (home) разделом "
 mount /dev/$root /mnt  # Монтирование в /mnt ; /mnt - каталог для ручного монтирования файловых систем
  echo ""
  echo " Создаем подразделы (Subvolume /@) на смонтированном btrfs разделе в каталоге /mnt "
### btrfs su cr - псевдоним для btrfs subvolume create. Название подразделов начинаются с @ чтобы не путать их с другими каталогами.
### Я бы предложил по крайней мере один подтом для корня (@) и один для снимков (@snapshots). varlog и tmp созданы для простого отключения копирования при записи на /var/log и /tmp.
btrfs su cr /mnt/@             # @ - Корневой подтом
btrfs su cr /mnt/@home         # @home - Домашний подтом
btrfs su cr /mnt/@snapshots    # @snapshots - Snapper будет хранить здесь ваши снимки BTRFS. Если Snapper не используется, этот раздел не нужен.
#btrfs su cr /mnt/@.snapshots
btrfs su cr /mnt/@var          # @var - Журналы, некоторые временные файлы, кэши и т. д.
btrfs su cr /mnt/@log          # @log - Журналы работы утилит, некоторые временные файлы
# btrfs su cr /mnt/@varlog
btrfs su cr /mnt/@opt          # @opt - Каталог, в котором размещаются стороннее программное обеспечение и пакеты
btrfs su cr /mnt/@pkg          # @pkg - Каталог, в который утилита makepkg помещает скомпилированные файлы
btrfs su cr /mnt/@tmp          # @tmp - Основное расположение временных файлов
btrfs sub cr /mnt/@cache       # @cache - Это кэш пакетного менеджера (pacman)
#btrfs sub cr /mnt/@swap        # @swap - Хранит файл подкачки. Должен монтироваться с nodatacow
  echo ""
  echo " Проверка создания томов в /mnt "
btrfs subvolume list /mnt
# btrfs sub list /mnt
# cat /etc/fstab
sleep 03
#  echo ""
#  echo " Отключить копирование при записи /var/log и /tmp "
#chattr +C /mnt/@var
#chattr +C /mnt/@log
# chattr +C /mnt/@varlog
#chattr +C /mnt/@tmp
  echo ""
  echo " Размонтируем (отмонтируем) корневой раздел смонтированный в каталоге /mnt "
# umount /mnt
umount -R /mnt
  echo " Размонтирование смонтированного корневого раздела выполнено "
  sleep 01
  echo ""
  echo " Смонтировать root раздел как подтома... "
mount -o ${sub}=@ /dev/$root /mnt
  echo ""
  echo " Создания нескольких папок в каталоге /mnt "
  echo " Команда, которая создаёт следующие папки: boot, home, var, var/log, var/cache/pacman/pkg и .snapshots "
mkdir -p /mnt/{boot,home,var,opt,tmp,var/log,var/cache/pacman/pkg,.snapshots}  # создаёт папки: boot, home, var, var/log, var/cache/pacman/pkg и .snapshots
  echo ""
  echo " Смонтировать home раздел в каталоге /mnt "
mount /dev/$home /mnt/home
  echo ""
  echo " Монтирование папок в каталоге /mnt "
# mount -o ${sub}=@home /dev/$root /mnt/home
mount -o ${sub}=@var /dev/$root /mnt/var
mount -o ${sub}=@log /dev/$root /mnt/var/log
mount -o ${sub}=@pkg /dev/$root /mnt/var/cache/pacman/pkg
mount -o ${sub}=@.snapshots /dev/$root /mnt/.snapshots
# mount -o ${sub}=@tmp /dev/$root /mnt/tmp
# mount -o ${sub}=@opt /dev/$root /mnt/opt
  echo ""
  echo " Монтирование папок (каталогов) в каталоге /mnt завершено "
if [[ $homeF == 3 ]]; then
echo ""
echo " Создадим файловую систему XFS для домашнего раздела "
# mkfs.xfs /dev/$home -L home  # или - mkfs.xfs /dev/$home -L $home -L archhome
# mkfs.xfs -f /dev/$home  # Принудительное создание файловой системы XFS поверх любой существующей. Это опция команды mkfs.xfs (из пакета xfsprogs). Опция -f (от force) нужна, если на указанном разделе уже существует файловая система другого типа, и нужно её перезаписать.
### Команда, чтобы не вводить 'y'
  echo 'y' | mkfs.xfs /dev/$home -L home  # Форматировать в XFS
# echo 'y' | mkfs.xfs -f /dev/$home -L home  # Форматировать в XFS Принудительно!
### *При использовании mkfs.xfs на блочном устройстве, содержащем существующую файловую систему, добавьте опцию -f для перезаписи этой файловой системы. Эта операция уничтожит все данные, содержащиеся в предыдущей файловой системе.
# mkfs.xfs -f /dev/$home -L home  # При использовании mkfs.xfs на блочном устройстве
# echo 'y' | mkfs.xfs -f /dev/$home -L home  # Форматировать XFS
### В целом, параметры по умолчанию оптимальны для обычного использования: meta-data=/dev/device
# meta-data=/dev/$home
 echo ""
 echo " Проверка файловой системы на ошибки и их автоматическое исправление "
### Примеры использования: Для работы нужны права суперпользователя (root-доступом).
# fsck -y /dev/$home  # Проверка файловой системы на ошибки и их автоматическое исправление
  fsck -n /dev/$home  # Проверка файловой системы на наличие ошибок, которые пока не нужно исправлять
# fsck -t -A ext4  # Проверка раздела с заданной файловой системой ext4
# fsck -AM  # Чтобы выполнить проверку файловой системы только на несмонтированных дисках
  echo ""
  echo " Создания папки home в каталоге /mnt "
# mkdir /mnt/boot
# mkdir /mnt/home
  mkdir -p /mnt/home
# mkdir /mnt/{boot,home}
 echo ""
 echo " Смонтируем home (домашний) раздел в /mnt "
  mount /dev/$home /mnt/home  # Монтирование в /mnt ; /mnt - каталог для ручного монтирования файловых систем
 echo ""
 echo " Узнать тип смонтированной файловой системы "
# mount | grep -E /dev/$home  # Чтобы узнать тип смонтированной файловой системы
 mount | grep /dev/$home
# mount | grep xfs  # отображать только файловые системы XFS
sleep 03
 echo ""
 echo " Форматирование и монтирование выполнено "
elif [[ $homeF == 0 ]]; then
     lsblk -f  # Команда lsblk выводит список всех блочных устройств
     echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
     read -p " Укажите HOME раздел (sda/sdb 1.2.3.4 (sda6 например)): " homeV  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
     mkdir /mnt/home  # Создания папки home в каталоге /mnt
     mount /dev/$homeV /mnt/home  # Смонтируем home (домашний) раздел в /mnt
 echo ""
 echo " Монтирование выполнено "
fi
fi
sleep 02
##### Windows partitions #####
clear
echo -e "${CYAN}
  <<< Добавление (монтирование) разделов Windows (ntfs/fat32) >>>
${NC}"
echo -e "${GREEN}==> ${NC}Добавим разделы для Windows (ntfs/fat32)?"
echo -e "${MAGENTA}=> ${BOLD}Если таковые были созданы во время разбиения вашего диска(ов) на разделы cfdisk! ${NC}"
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Да добавим разделы,    0 - Нет пропустить этот шаг: " wind  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$wind" =~ [^10] ]]
do
    :
done
if [[ $wind == 0 ]]; then
  echo " Действие пропущено "
elif [[ $wind == 1 ]]; then
  echo " ### Приступим к добавлению разделов Windows ### "
############### Disk C ##############
echo ""
echo -e "${BLUE}:: ${NC}Добавим раздел диск "C"(Local Disk) Windows?"
echo " Если таковой был создан при разметке в cfdisk "
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Да добавим раздел,    0 - Нет пропустить: " diskC  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$diskC" =~ [^10] ]]
do
    :
done
if [[ $diskC == 0 ]]; then
  echo " Действие пропущено "
elif [[ $diskC == 1 ]]; then
  clear
  lsblk -f  # Команда lsblk выводит список всех блочных устройств
  echo ""
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
  read -p " Укажите диск "C" раздел(sda/sdb 1.2.3.4 (sda4 например) ) : " diskCc
### Команда, чтобы не вводить 'y'
# echo 'y' | mkfs.ntfs -Q /dev/$diskCc -L win
  mkdir /mnt/C
# mkdir -p /mnt/mnt/win
  mount /dev/$diskCc /mnt/C
# mount /dev/$diskCc /mnt/mnt/win
fi
############### Disk D #############
echo ""
echo -e "${BLUE}:: ${NC}Добавим раздел диск "D"(Data Disk) Windows?"
echo " Если таковой был создан при разметке в cfdisk "
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Да добавим раздел,    0 - Нет пропустить: " diskD  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$diskD" =~ [^10] ]]
do
    :
done
if [[ $diskD == 0 ]]; then
  echo " Действие пропущено "
elif [[ $diskD == 1 ]]; then
  clear
  lsblk -f  # Команда lsblk выводит список всех блочных устройств
  echo ""
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
  read -p " Укажите диск "D" раздел(sda/sdb 1.2.3.4 (sda5 например)) : " diskDd
### Команда, чтобы не вводить 'y'
# echo 'y' | mkfs.ntfs -Q /dev/$diskDd -L data
  mkdir /mnt/D
# mkdir -p /mnt/mnt/data
  mount /dev/$diskDd /mnt/D
# mount /dev/$diskDd /mnt/mnt/data
fi
###### disk E ########
echo ""
echo -e "${BLUE}:: ${NC}Добавим раздел диск "E"(Work Disk) Windows?"
echo " Если таковой был создан при разметке в cfdisk "
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Да добавим раздел,    0 - Нет пропустить: " diskE  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$diskE" =~ [^10] ]]
do
    :
done
if [[ $diskE == 1 ]]; then
  clear
  lsblk -f  # Команда lsblk выводит список всех блочных устройств
  echo ""
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
  read -p " Укажите диск "E" раздел(sda/sdb 1.2.3.4 (sda5 например)) : " diskDe
### Команда, чтобы не вводить 'y'
# echo 'y' | mkfs.ntfs -Q /dev/$diskDd -L work
  mkdir /mnt/E
# mkdir -p /mnt/mnt/work
  mount /dev/$diskDe /mnt/E
# mount /dev/$diskDd /mnt/mnt/work
elif [[ $diskE == 0 ]]; then
  echo " Действие пропущено "
fi
fi
#############################
echo ""
echo -e "${BLUE}:: ${NC}Просмотреть подключённые диски с выводом информации о размере и свободном пространстве"
df -h  # Команда df выводит в табличном виде список всех файловых систем и информацию о доступном и занятом дисковом пространстве
echo ""
echo -e "${BLUE}:: ${NC}Просмотреть все идентификаторы наших разделов"
echo ""
blkid  # Для просмотра UUID (или Universal Unique Identifier) - это универсальный уникальный идентификатор определенного устройства компьютера
echo ""
echo -e "${BLUE}:: ${NC}Просмотреть информацию об использовании памяти в системе"
free -h  # Достаточно ли свободной памяти для установки и запуска новых приложений
sleep 02
echo ""
echo -e "${BLUE}:: ${NC}Посмотреть содержмое каталога /mnt."
ls /mnt  # Посмотреть содержимое той или иной папки
sleep 1
######## Mirrorlist ##########
clear
echo ""
echo -e "${GREEN}==> ${NC}Сменить зеркала для увеличения скорости загрузки пакетов?"
echo -e "${BLUE}:: ${NC}Загрузка свежего списка зеркал со страницы Mirror Status, и обновление файла mirrorlist."
echo -e "${MAGENTA}=> ${BOLD}Если Вы перед запуском скрипта просмотрели его, то может возникнуть резонный вопрос зачем менять список зеркал и обновлять файл mirrorlist, это связано с тем что, начиная с релиза Arch Linux 2020.07.01-x86_64.iso в установочный образ был добавлен reflector. Тем самым во время установки основной системы происходит запуск службы, и обновляется прописанный список зеркал в mirrorlist. ${NC}"
echo -e "${CYAN}:: ${NC}Вам будет представлено несколько вариантов смены зеркал для увеличения скорости загрузки пакетов."
echo " Огласите весь список, пожалуйста! :) "
echo " 1 - Команда отфильтрует зеркала для Russia по протоколам (https, http), отсортирует их по скорости загрузки и обновит файл mirrorlist "
echo " 2 - Команда подробно выведет список 50 наиболее недавно обновленных HTTP-зеркал, отсортирует их по скорости загрузки и обновит файл mirrorlist "
echo " 3 - То же, что и в предыдущем примере, но будут взяты только зеркала, расположенные в Казахстане (Kazakhstan) "
echo " 4 - Команда отфильтрует зеркала для Russia, Belarus, Ukraine, Poland - по протоколам (https, http), отсортирует их по скорости загрузки и обновит файл mirrorlist "
echo " Будьте внимательны! Не переживайте, перед обновлением зеркал будет сделана копия (backup) предыдущего файла mirrorlist, и в последствии будет сделана копия (backup) нового файла mirrorlist. Эти копии (backup) Вы сможете найти в установленной системе в /etc/pacman.d/mirrorlist - (новый список), и в /etc/pacman.d/mirrorlist.backup (старый список). В данной опции выбор всегда остаётся за вами. "
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления"
echo " Если Вы находитесь в России рекомендую выбрать вариант "1" "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Russia (https, http),     2 - 50 HTTP-зеркал,     3 - Kazakhstan (http),

    4 - Russia, Belarus, Ukraine, Poland (https, http),

    0 - Пропустить обновление зеркал: " zerkala  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$zerkala" =~ [^12340] ]]
do
    :
done
if [[ $zerkala == 1 ]]; then
  echo ""
  echo " Проверим присутствует ли пакет (reflector) "
  pacman -Sy --noconfirm --noprogressbar --quiet reflector  # Модуль и скрипт Python 3 для получения и фильтрации последнего списка зеркал Pacman  - пока присутствует в pkglist.x86_64
  pacman -S --noconfirm --needed --noprogressbar --quiet reflector  # pacman -S --noconfirm --needed reflector
# Создайте резервную копию и замените текущий файл зеркального списка /etc/pacman.d/mirrorlist (https://archlinux.org/mirrorlist/ ; https://archlinux.org/mirrorlist/?country=RU&protocol=http&protocol=https&ip_version=4 ; https://archlinux.org/mirrorlist/?country=RU&protocol=http&protocol=https&ip_version=4&use_mirror_status=on)
  echo ""
  echo " Резервное копирование исходного списка зеркальных отображений..."
  mv -i /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.orig
  echo " Загрузка свежего списка зеркал со страницы Mirror Status "
  reflector --verbose --country 'Russia' -l 10 -p https -p http -n 10 --save /etc/pacman.d/mirrorlist --sort rate
### reflector --country <your country code e.g. gb> --ipv4 --protocol "http,https" --sort score --save /etc/pacman.d/mirrorlist
#  reflector --country 'Russia' --ipv4 --protocol "http,https" --sort score --save /etc/pacman.d/mirrorlist
  echo " Разрешить глобальный доступ на чтение (требуется для выполнения некорневого yaourt) "
  chmod +r /etc/pacman.d/mirrorlist  # Разрешить глобальный доступ на чтение
elif [[ $zerkala == 2 ]]; then
  echo ""
  echo " Загрузка свежего списка зеркал со страницы Mirror Status "
  pacman -S reflector --noconfirm  # Модуль и скрипт Python 3 для получения и фильтрации последнего списка зеркал Pacman
  reflector --verbose -l 50 -p http --sort rate --save /etc/pacman.d/mirrorlist
  reflector --verbose -l 15 --sort rate --save /etc/pacman.d/mirrorlist
elif [[ $zerkala == 3 ]]; then
  echo ""
  echo " Загрузка свежего списка зеркал со страницы Mirror Status "
  pacman -S reflector --noconfirm  # Модуль и скрипт Python 3 для получения и фильтрации последнего списка зеркал Pacman
# reflector --verbose --country Kazakhstan -l 20 -p http --sort rate --save /etc/pacman.d/mirrorlist
  reflector --verbose --country 'Kazakhstan' -l 5 -p https -p http -n 5 --save /etc/pacman.d/mirrorlist --sort rate
elif [[ $zerkala == 4 ]]; then
  echo ""
  echo " Загрузка свежего списка зеркал со страницы Mirror Status "
  pacman -S reflector --noconfirm  # Модуль и скрипт Python 3 для получения и фильтрации последнего списка зеркал Pacman
  reflector -c "Russia" -c "Belarus" -c "Ukraine" -c "Poland" -f 20 -l 20 -p https -p http -n 20 --save /etc/pacman.d/mirrorlist --sort rate
elif [[ $zerkala == 0 ]]; then
  echo ""
  echo  " Смена зеркал пропущена "
fi
###
clear
echo ""
echo -e "${BLUE}:: ${NC}Посмотреть список серверов-зеркал /mnt/etc/pacman.d/mirrorlist"
echo ""
cat /etc/pacman.d/mirrorlist  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 2
echo ""
echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов"
pacman -Sy --noconfirm  # обновить списки пакетов из репозиториев
sleep 1
##########################

clear
echo ""
echo -e "${GREEN}==> ${NC}Установка основных пакетов (base, base-devel) базовой системы"
echo -e "${BLUE}:: ${NC}Arch Linux, Base devel (AUR only)"
echo " Сценарий pacstrap устанавливает (base) базовую систему. Для сборки пакетов из AUR (Arch User Repository) также требуется группа base-devel. "
echo -e "${MAGENTA}=> ${BOLD}Т.е., Если нужен AUR, ставь base и base-devel, если нет, то ставь только base. ${NC}"
echo " Огласите весь список, пожалуйста! :) "
echo " 1 - base + base-devel + packages (пакеты небходимые для сетевых настроек, и консольный текстовый редактор: - dhcpcd netctl which inetutils nano) "  #wget vim
echo " 2 - base + packages (пакеты небходимые для сетевых настроек, и консольный текстовый редактор: - dhcpcd netctl which inetutils nano) "   #wget vim
echo " 3 - base + base-devel (установятся группы, Т.е. base и base-devel, без каких либо дополнительных пакетов) "
echo " 4 - base (установится группа, состоящая из определённого количества пакетов, Т.е. просто base, без каких либо дополнительных пакетов) "
echo " Будьте осторожны! Если Вы сомневаетесь в своих действиях, можно установить (base + packages), а group-(группы) base-devel установить позже. "
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления"
echo " Чтобы исключить ошибки в работе системы рекомендую вариант - "1" "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Base + Base-Devel + packages,   2 - Base + packages,

    3 - Base + Base-Devel,              4 - Base: " t_pacstrap  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_pacstrap" =~ [^1234] ]]
do
    :
done
if [[ $t_pacstrap == 1 ]]; then
  clear
  echo ""
  echo " Установка выбранного вами, групп "
  pacstrap /mnt base base-devel nano dhcpcd netctl which inetutils  #wget vim
# pacstrap -i /mnt base base-devel nano dhcpcd netctl which inetutils --noconfirm
  clear
  echo ""
  echo " Установка выбранного вами, групп (base + base-devel + packages) выполнена "
elif [[ $t_pacstrap == 2 ]]; then
  clear
  echo ""
  echo " Установка выбранного вами, группы "
  pacstrap /mnt base nano dhcpcd netctl which inetutils #wget vim
  clear
  echo ""
  echo " Установка выбранного вами, групп (base + packages) выполнена "
elif [[ $t_pacstrap == 3 ]]; then
  clear
  echo ""
  echo " Установка выбранных вами групп "
  pacstrap /mnt base base base-devel
  clear
  echo ""
  echo " Установка выбранного вами, групп (base + base-devel) выполнена "
elif [[ $t_pacstrap == 4 ]]; then
  clear
  echo ""
  echo " Установка выбранной вами группы "
  pacstrap /mnt base
  clear
  echo ""
  echo " Установка выбранной вами, группы (base) выполнена "
fi
###
echo ""
echo -e "${GREEN}==> ${NC}Какое ядро (Kernel) Вы бы предпочли установить вместе с системой Arch Linux?"
echo -e "${BLUE}:: ${NC}Kernel (optional), Firmware"
echo " Дистрибутив Arch Linux основан на ядре Linux. Помимо основной стабильной (stable) версии в Arch Linux можно использовать некоторые альтернативные ядра. "
echo -e "${MAGENTA}=> ${BOLD}Выбрать-то можно, но тут главное не пропустить установку ядра :) ${NC}"
echo " Огласите весь список, пожалуйста! :) "
echo " 1 - linux (Stable - ядро Linux с модулями и некоторыми патчами, поставляемое вместе с Rolling Release устанавливаемой системы Arch) "
echo " 2 - linux-hardened (Ядро Hardened - ориентированная на безопасность версия с набором патчей, защищающих от эксплойтов ядра и пространства пользователя. Внедрение защитных возможностей в этом ядре происходит быстрее, чем в linux) "
echo " 3 - linux-lts (Версия ядра и модулей с долгосрочной поддержкой - Long Term Support, LTS) "
echo " 4 - linux-zen (Результат коллективных усилий исследователей с целью создать лучшее из возможных ядер Linux для систем общего назначения) "
echo " Будьте осторожны! Если Вы сомневаетесь в своих действиях, можно установить (linux Stable) ядро поставляемое вместе с Rolling Release. "
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - LINUX (Kernel),           2 - LINUX_HARDENED (Kernel),

    3 - LINUX_LTS (Kernel),       4 - LINUX_ZEN (Kernel): " x_pacstrap  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_pacstrap" =~ [^1234] ]]
do
    :
done
if [[ $x_pacstrap == 1 ]]; then
  clear
  echo ""
  echo " Установка выбранного вами ядра (linux) "
  pacstrap /mnt linux linux-firmware linux-headers #linux-docs
  clear
  echo ""
  echo " Ядро (linux) операционной системы установленно "
elif [[ $x_pacstrap == 2 ]]; then
  clear
  echo ""
  echo " Установка выбранного вами ядра (linux-hardened) "
  pacstrap /mnt linux-hardened linux-firmware linux-hardened-headers #linux-hardened-docs
  clear
  echo ""
  echo " Ядро (linux-hardened) операционной системы установленно "
elif [[ $x_pacstrap == 3 ]]; then
  clear
  echo ""
  echo " Установка выбранного вами ядра (linux-lts) "
  pacstrap /mnt linux-lts linux-firmware linux-lts-headers linux-lts-docs
  clear
  echo ""
  echo " Ядро (linux-lts) операционной системы установленно "
elif [[ $x_pacstrap == 4 ]]; then
  clear
  echo ""
  echo " Установка выбранного вами ядра (linux-zen) "
  pacstrap /mnt linux-zen linux-firmware linux-zen-headers #linux-zen-docs
  clear
  echo ""
  echo " Ядро (linux-zen) операционной системы установленно "
fi
###
echo ""
echo -e "${GREEN}==> ${NC}Настройка системы, генерируем fstab"
echo -e "${MAGENTA}=> ${BOLD}Файл /etc/fstab используется для настройки параметров монтирования различных блочных устройств, разделов на диске и удаленных файловых систем. Цель команды — создать записи, которые иначе требовали бы ручной конфигурации и были бы подвержены ошибкам. genfstab помогает сохранить иерархию файловых систем, смонтированных вручную, и часто используется во время начальной установки и конфигурации системы. ${NC}"
echo " Таким образом, и локальные, и удаленные файловые системы, указанные в /etc/fstab, будут правильно смонтированы без дополнительной настройки. Важно: перед перезаписью существующего файла fstab рекомендуется создать резервную копию. Также нужно учитывать, где сохраняется файл fstab, например, если нужно создать его для chroot, то не стоит перезаписывать файл на основной установке. "
echo -e "${CYAN}:: ${NC}Существует четыре различных схемы для постоянного именования: по метке, по uuid, по id и по пути. Для тех, кто использует диски с таблицей разделов GUID (GPT), существуют ещё две дополнительные схемы: - "Partlabel" и "Parduuid". Вы также можете использовать статические имена устройств с помощью Udev. "
echo " Огласите весь список, пожалуйста! :) "
echo " 1 - По-UUID ("UUID" "genfstab -U") "
echo " 2 - По меткам ("LABEL" "genfstab -L") "
echo " 3 - По меткам GPT ("PARTLABEL" "genfstab -t PARTLABEL") "
echo " 4 - По UUID GPT ("PARTUUID" "genfstab -t PARTUUID") "
echo " Пример использования: команда может быть частью инструкции по установке Arch Linux, где нужно сгенерировать файл fstab на основе метки тома. В выводе команды указывается, что диск с меткой «MyDrive» должен быть смонтирован в /mnt/MyDrive с файловой системой ext4 с настройками по умолчанию при запуске. "
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз взгляните на разметку вашего диска, и таблицу разделов (MBR или GPT). "
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления"
echo " Чтобы исключить ошибки в работе системы рекомендую "1" вариант "
echo -e "${MAGENTA}:: ${NC}Преимущество использования метода UUID состоит в том, что вероятность столкновения имен намного меньше, чем с метками. Далее он генерируется автоматически при создании файловой системы."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - UUID genfstab -U,                    2 - LABEL genfstab -L,

    3 - PARTLABEL genfstab -t PARTLABEL,     4 - PARTUUID genfstab -t PARTUUID: " x_fstab  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
    echo ''
    [[ "$x_fstab" =~ [^1234] ]]
do
    :
done
if [[ $x_fstab == 1 ]]; then
  clear
  echo ""
  echo " Генерируем fstab выбранным вами методом "
  echo " UUID - genfstab -U -p /mnt > /mnt/etc/fstab "
# genfstab -pU /mnt >> /mnt/etc/fstab  # Учтите, что когда пишется >> то Вы добавляете в файл, а не переписываешь его с нуля.
  genfstab -U -p /mnt > /mnt/etc/fstab  # С ключом -U генерирует UUID без него раздел будет вида /dev/sda1 или что то в этом роде.
  echo " Проверьте полученный /mnt/etc/fstab файл и отредактируйте его в случае ошибок. "
elif [[ $x_fstab == 2 ]]; then
  clear
  echo ""
  echo " Генерируем fstab выбранным вами методом "
  echo " LABEL - genfstab -L -p /mnt > /mnt/etc/fstab "
  genfstab -pL /mnt > /mnt/etc/fstab
# genfstab -L -p -P /mnt >> /mnt/etc/fstab  # -L- LABEL (указывает, что утилита genfstab должна генерировать записи с меткой тома вместо UUID или других идентификаторов. Метки тома легче запоминать и распознавать.); -p - PARTLABEL (по умолчанию исключает печать псевдообозначений) ; -P - (включает печать псевдообозначений.) ; /mnt — базовый каталог, где все файловые системы должны быть смонтированы во время установки. Инструмент читает свойства этого каталога, чтобы сгенерировать записи fstab ; >> /mnt/etc/fstab — оператор >> добавляет сгенерированные записи в существующий файл fstab, расположенный по адресу /mnt/etc/fstab.
  echo " Проверьте полученный /mnt/etc/fstab файл и отредактируйте его в случае ошибок. "
elif [[ $x_fstab == 3 ]]; then
  clear
  echo ""
  echo " Генерируем fstab выбранным вами методом "
  echo " PARTLABEL - genfstab -t PARTLABEL -p /mnt > /mnt/etc/fstab "
  genfstab -t PARTLABEL -p /mnt > /mnt/etc/fstab
  echo " Проверьте полученный /mnt/etc/fstab файл и отредактируйте его в случае ошибок. "
elif [[ $x_fstab == 4 ]]; then
  clear
  echo ""
  echo " Генерируем fstab выбранным вами методом "
  echo " PARTUUID - genfstab -t PARTUUID -p /mnt > /mnt/etc/fstab "
  genfstab -t PARTUUID -p /mnt > /mnt/etc/fstab
  echo " Проверьте полученный /mnt/etc/fstab файл и отредактируйте его в случае ошибок. "
fi
###
echo ""
echo -e "${BLUE}:: ${NC}Просмотреть содержимое файла fstab"
cat /mnt/etc/fstab  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 02
echo -e "${BLUE}:: ${NC}Взглянем на UUID идентификатор(ы) нашего устройства:"
echo ""
blkid
# blkid /dev/sd*  # Для просмотра UUID (или Universal Unique Identifier) - это универсальный уникальный идентификатор определенного устройства компьютера
sleep 02
##################
clear
echo ""
echo -e "${GREEN}==> ${NC}Меняем корень и переходим в нашу недавно скачанную систему (chroot)"
echo -e "${MAGENTA}=> ${BOLD}Есть три варианта продолжения установки: ${NC}"
  echo " 1 - Если у Вас стабильный трафик интернета (dhcpcd, wifi), и вы скачали первую часть скрипта через
  (wget git.io/archmy1l ), то выбирайте вариант - пункт "1", (команда работает через wget ....) "
  echo " 2 - Альтернативный вариант для (dhcpcd, wifi), если у Вас бывают проблемы трафика интернета (dhcpcd, wifi), и вы скачали первую часть скрипта через (curl -LO git.io/archmy1l ), то выбирайте вариант - пункт "2", (команда работает через curl ....) "
echo -e "${CYAN}:: ${NC}В этих вариантах большого отличия нет, кроме команд выполнения (1-вариант wget), (2-вариант curl),
  и ещё в этих обоих вариантах вам потребуется ввести команду на запуск скрипта " ./archmy2l.sh " затем [enter], НО сначала проверить подключение сети интернет "ping -c2 8.8.8.8" - т.е. пропинговать сеть. "
echo " ########################################################### "
echo -e "${YELLOW}:: ${BOLD}Есть ещё 3(й) способ: команда выполнения как, и во 2-ом варианте через (curl),
        НО *Внимание! В Данный момент (не отрабатывает) КОМАНДА НЕ РАБОТАЕТ!* ${NC}"
  echo " 3 - Если у Вас стабильный трафик интернета (dhcpcd, wifi), и вы скачали первую часть скрипта через
  (wget git.io/archmy1l или curl -LO git.io/archmy1l ), то выбирайте вариант - пункт "3", (команда работает через curl ...) "
echo " Будьте внимательны! В данной опции выбор всегда остаётся за вами. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Stable Internet traffic (dhcpcd, wifi)(команда работает через wget ...),

    2 - Alternative Option Not Stable Internet traffic (dhcpcd, wifi)(команда работает через curl ...),

    3 - Stable Internet traffic (dhcpcd, wifi)(команда работает через curl - *Внимание! КОМАНДА НЕ РАБОТАЕТ!): " int # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$int" =~ [^123] ]]
do
    :
done
if [[ $int == 1 ]]; then
  echo ""
  pacman -Sy wget --noconfirm --noprogressbar  # Сетевая утилита для извлечения файлов из Интернета
  wget -P /mnt https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/archmy2l.sh
  chmod +x /mnt/archmy2l.sh
  clear
  echo ""
  echo " Первый этап установки Arch'a закончен "
  echo 'Установка продолжится в ARCH-LINUX chroot'
  echo ""
  echo -e "${YELLOW}=> ${BOLD}Важно! Для удачного продолжения установки выполните эти пунты: ${NC}"
  echo " 1 - Проверьте подключение сети интернет для продолжения установки в arch-chroot - "ping -c2 8.8.8.8" "
  echo " 2 - Вводим команду для продолжения установки "./archmy2l.sh" "
  echo ""
  arch-chroot /mnt
  echo " ############################################### "
  echo -e "${BLUE}       ARCH LINUX FAST INSTALL ${RED}2.5 Update${NC}"
  echo " ############################################### "
  echo " Размонтирование всех смонтированных файловых систем (кроме корневой) "
  umount -a
  reboot
elif [[ $int == 2 ]]; then
  echo ""
  pacman -Sy --noconfirm --needed --noprogressbar --quiet curl # Утилита и библиотека для поиска URL
  curl -LO https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/archmy2l.sh
  mv archmy2l.sh /mnt
  chmod +x /mnt/archmy2l.sh
  clear
  echo ""
  echo " Первый этап установки Arch'a закончен "
  echo 'Установка продолжится в ARCH-LINUX chroot'
  echo ""
  echo -e "${YELLOW}=> ${BOLD}Важно! Для удачного продолжения установки выполните эти пунты: ${NC}"
  echo " 1 - Проверьте подключение сети интернет для продолжения установки в arch-chroot - "ping -c2 8.8.8.8" "
  echo " 2 - Вводим команду для продолжения установки "./archmy2l.sh" "
  echo ""
  arch-chroot /mnt
  echo " ############################################### "
  echo -e "${BLUE}       ARCH LINUX FAST INSTALL ${RED}2.5 Update${NC}"
  echo " ############################################### "
  echo " Размонтирование всех смонтированных файловых систем (кроме корневой) "
  umount -a
  reboot
elif [[ $int == 3 ]]; then
  echo ""
  echo " Первый этап установки Arch'a закончен "
  echo 'Установка продолжится в ARCH-LINUX chroot'
  echo ""
  pacman -S --noconfirm --needed --noprogressbar --quiet curl # Утилита и библиотека для поиска URL
#  arch-chroot /mnt /bin/bash sh -c "$(curl -fsSL git.io/archmy2l)"  # Проверить команду ...
#  arch-chroot /mnt "sh -c \"$(curl -fsSL git.io/archmy2l)\""  # Проверить команду ...
  arch-chroot /mnt sh -c "$(curl -fsSL git.io/archmy2l)"  # sh вызывает программу sh как интерпретатор и флаг -c означает выполнение следующей команды, интерпретируемой этой программой (выполнить команду специально с этой оболочкой вместо bash)
#  arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/archmy2l)"  # Проверить команду ...
#  arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/archmy2l.sh)"
# chmod +x /mnt/archmy2l.sh
###  curl -s "http://get.sdkman.io" | bash
### \ curl -sSL https://get.rvm.io | bash --debug
### curl -sSL https://get.rvm.io | bash -s stable --rails  # Проблема устранена командой
  echo " ############################################### "
  echo -e "${BLUE}       ARCH LINUX FAST INSTALL ${RED}2.5 Update${NC}"
  echo " ############################################### "
  echo " Размонтирование всех смонтированных файловых систем (кроме корневой) "
  umount -a  # файловые системы, упомянутые в fstab (cоответсвующего типа/параметров) должны быть размонтированы и остановлены (кроме тех, для которых указана опция noauto)
  reboot
fi
#########################
