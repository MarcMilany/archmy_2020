#!/bin/bash
### Смотрите пометки (справочки) и доп.иформацию в самом скрипте!
###########################################################
#### Releases ArchLinux:                               ####
####     https://www.archlinux.org/releng/releases/    ####
#### Installation guide - Arch Wiki  (referance):      ####
# https://wiki.archlinux.org/index.php/Installation_guide #
###########################################################
apptitle="Arch Linux Fast Install v2.5 LegasyBIOS - Version: 2025.09.17.00.40.38 (GPLv3)"
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
AUTHOR="MarcMilany"
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
Arch Linux — это независимо разработанный универсальный дистрибутив GNU / Linux для архитектуры x86-64, который стремится предоставить последние стабильные версии большинства программ, следуя модели непрерывного выпуска.
 Arch Linux определяет простоту как без лишних дополнений или модификаций. Arch включает в себя многие новые функции, доступные пользователям GNU / Linux, включая systemd init system, современные файловые системы , LVM2, программный RAID, поддержку udev и initcpio (с mkinitcpio ), а также последние доступные ядра.
Arch Linux — это дистрибутив общего назначения. После установки предоставляется только среда командной строки: вместо того, чтобы вырывать ненужные и нежелательные пакеты, пользователю предлагается возможность создать собственную систему, выбирая среди тысяч высококачественных пакетов, представленных в официальных репозиториях для x86-64 архитектуры.
 Изначально этот скрипт не задумывался, как обычный установочный (сценарий), с большим выбором DE, разметкой диска и т.д..
Но в последствие! Эта концепция была пересмотрена, и в скрипт был добавлен выбор DE, разметка диска и другие плюшки. И он (скрипт) НЕ предназначен для новичков!
Он предназначен для тех, кто ставил Arch Linux руками и понимает, что и для чего нужна каждая команда.
Его цель — это быстрое разворачивание системы со всеми конфигами. Смысл в том, что все изменения Вы делаете предварительно в самом скрипте и получаете возможность быстрой установки Arch Linux с вашими личными настройками (при условии, что Вы его изменили под себя, в противном случае с моими настройками).${RED}

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
echo -e "${GREEN}=> ${NC}Make sure that your network interface is specified and enabled"
echo " Show all ip addresses and their interfaces "
## Показать все ip адреса и их интерфейсы
### ip [опции] объект команда [параметры] ; https://losst.pro/nastrojka-seti-v-linux
# ip link  # проверить доступность сетевых адаптеров ; link или l - физическое сетевое устройство.
ip a  # Смотрим какие у нас есть интернет-интерфейсы ; -a, -all - применить команду ко всем объектам ; # секунд через 20-40 смотрим, какой IP-адрес назначен интерфейсу
sleep 03
###################
echo ""
echo -e "${GREEN}=> ${NC}To check the Internet, you can ping a service "
# ping google.com -W 2 -c 1
ping -c 2 archlinux.org  # Утилита ping - это очень простой инструмент для диагностики сети
echo -e "${CYAN}==> ${NC}If the ping goes we go further ... :) "  # Если пинг идёт едем дальше ... :)
#####################
echo ""
echo -e "${BLUE}:: ${NC}Update the package databases "
## Обновим базы данных пакетов
pacman -Sy --print-format "%r"  # Указывает похожий на printf формат для контроля вывода операции --print; «% r» для репозитория
#pacman -Sy --noconfirm  # обновить списки пакетов из репозиториев
### С помощью параметра --print-format можно отформатировать список пакетов, которые будут установлены или удалены, различными способами. По умолчанию используется формат "%l"
### pacman (Русский) - ArchWiki: https://wiki.archlinux.org/title/Pacman_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
sleep 1
################
echo ""
echo -e "${BLUE}:: ${NC}Install the Terminus Font "  # Моноширинный растровый шрифт (для X11 и консоли)
pacman -S terminus-font --noconfirm  # Моноширинный растровый шрифт (для X11 и консоли) ; https://archlinux.org/packages/extra/any/terminus-font/ ; http://terminus-font.sourceforge.net/ ; Заменяет: terminus-font-otb ; Конфликты: с terminus-font-otb ; 2025-06-29 23:44 UTC
# pacman -Sy terminus-font --noconfirm  # Моноширинный растровый шрифт (для X11 и консоли)
# pacman -Syy terminus-font  # Моноширинный растровый шрифт (для X11 и консоли)
# man vconsole.conf
echo ""
echo -e "${BLUE}:: ${NC}Install the FIGlet and  "  # Программа для создания больших букв из обычного текста
pacman -S --noconfirm --needed figlet  # Программа для создания больших букв из обычного текста ; https://archlinux.org/packages/extra/x86_64/figlet/ ; http://www.figlet.org/ ; 2024-07-12 14:45 UTC
echo ""
echo -e "${BLUE}:: ${NC}Install the KBD – Linux keyboard tools "  # KBD – Клавиатурные инструменты Linux
pacman -S --noconfirm --needed kbd  # Файлы таблиц клавиш и утилиты клавиатуры ; https://archlinux.org/packages/core/x86_64/kbd/ ; http://www.kbd-project.org/ ; Обеспечивает: vlock ; Заменяет: vlock ; Конфликты: vlock ; 2025-06-02 06:39 UTC
### Проект kbd содержит утилиты для управления консолью Linux (Linux console, виртуальными терминалами, клавиатурой и т.д.) – в основном, они загружают консольные шрифты и раскладки клавиатуры. Для загрузки раскладки клавиатуры утилиты используют интерфейсы ядра.
echo ""
echo -e "${BLUE}:: ${NC}Install the Dialog – A tool for displaying dialog boxes "  # Инструмент для отображения диалоговых окон
pacman -S --noconfirm --needed dialog  # Инструмент для отображения диалоговых окон из скриптов оболочки ; https://archlinux.org/packages/core/x86_64/dialog/ ; https://invisible-island.net/dialog/ ; Обеспечивает: libdialog.so=15-64 ;  2025-02-19 18:57 UTC
# pacman -S --noconfirm --needed xdialog  # Готовая замена программам «dialog» или «cdialog» ; https://archlinux.org/packages/extra/x86_64/xdialog/ ; http://xdialog.dyns.net/ ; http://xdialog.dyns.net/ ; 2023-05-19 17:24 UTC
echo ""
echo -e "${BLUE}:: ${NC}Install the EFI boot Management – An application for changing the EFI Boot Manager "  # Приложение для изменения диспетчера загрузки EFI
pacman -S --noconfirm --needed efibootmgr  # Приложение пользовательского пространства Linux для изменения диспетчера загрузки EFI ; https://archlinux.org/packages/core/x86_64/efibootmgr/ ; https://github.com/rhboot/efibootmgr ; 2024-03-13 16:32 UTC
### efibootmgr — это пользовательское приложение, используемое для модификации диспетчера загрузки UEFI. Это приложение может создавать и удалять загрузочные записи, изменять порядок загрузки, изменять следующий вариант загрузки и многое другое (https://man.archlinux.org/man/efibootmgr.8).
echo ""
echo -e "${BLUE}:: ${NC}Install the Dmidecode – Getting information about hardware "  # Получаем информацию о железе
### DMI (Desktop Management Interface) - интерфейс (API), позволяющий программному обеспечению собирать данные о характеристиках компьютера.
pacman -S --noconfirm --needed dmidecode  # Утилиты, относящиеся к таблице интерфейса управления рабочим столом ; Интерфейс управления рабочим столом, связанный с таблицами утилит ; https://archlinux.org/packages/extra/x86_64/dmidecode/ ; https://www.nongnu.org/dmidecode ; https://man.archlinux.org/man/extra/dmidecode/dmidecode.8.en ; 2024-07-06 20:41 UTC
#echo ""
#echo -e "${BLUE}:: ${NC}Смотрим информацию о BIOS "
#dmidecode -t bios  # BIOS – это предпрограмма (код, вшитый в материнскую плату компьютера)
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
clear
echo ""
echo -e "${BLUE}:: ${NC}Setting up the Russian language, changing the console font to one that supports Cyrillic for ease of use "
loadkeys ru  # Настроим русский язык, изменим консольный шрифт на тот, который поддерживает кириллицу для удобства работы
# loadkeys us
#setfont ter-v12n
#setfont ter-v14b
#setfont cyr-sun16
setfont ter-v16b   ### Установленный setfont
#setfont ter-v20b  # Шрифт терминус и русская локаль # чтобы шрифт стал побольше
### setfont ter-v22b
### setfont ter-v32b  # Для экрана HiDPI можно выбрать один из самых больших доступных шрифтов с русскими буквами
echo -e "${CYAN}==> ${NC}Добавим русскую локаль в систему установки "
pacman -S --noconfirm --needed sed  # Редактор потока GNU ; https://www.gnu.org/software/sed/ ; https://archlinux.org/packages/core/x86_64/sed/ ; 5 марта 2023 г., 20:39 UTC
sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen
#sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
echo -e "${BLUE}:: ${NC}Обновим текущую локаль системы "
locale-gen  # Мы ввели locale-gen для генерации тех самых локалей
# locale-gen >/dev/null 2>&1; RETVAL=$?  # Проверьте, включена ли определенная локаль в bash ; Перенаправление ввода/вывода ; >> /dev/null - перенаправление stdout в /dev/null ; 2>&1 - перенаправление stderr в stdout (который пойдет в /dev/null) ; https://www.opennet.ru/docs/RUS/bash_scripting_guide/c11620.html
sleep 1
echo -e "${BLUE}:: ${NC}Указываем язык системы "
export LANG=ru_RU.UTF-8
#export LANG=en_US.UTF-8
echo ""
echo -e "${BLUE}:: ${NC}Проверяем, что все заявленные локали были созданы: "
locale -a  # Смотрим какте локали были созданы
### man locale сказал бы вам, что locale -a перечислит все доступные локали
### Вместо этого скажите: locale -a | grep -q ^ja_JP || echo "enable any of the japanese locales first"
### Когда локаль сгенерирована, установите её в качестве системной:
# localectl set-locale ru_RU.UTF-8
### Примечание! *Для переключения между русским и английским языком используется сочетание клавиш Ctrl+Shift
sleep 01
### Display banner (Дисплей баннер)
clear
echo ""
                                       figlet -c "Arch Linux FastInstall"
echo ""
sleep 03
clear
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
 echo ""
 echo " Вы отказались от установки Arch Linux "
sleep 03
  exit
fi
###
clear
echo -e "${GREEN}
  <<< Начинается установка минимальной системы Arch Linux >>>
${NC}"
echo -e "${BLUE}:: ${NC}Установка и настройка начата в $(date +%T) "
echo -e "${BLUE}:: ${NC}Синхронизация системных часов "
timedatectl set-ntp true  # Синхронизируем наши системные часы, включаем ntp, если надо сменим часовой пояс
# echo " Для начала устанавливаем время по Москве, чтобы потом не оказалось, что файловые системы созданы в будущем "
# timedatectl set-timezone Europe/Moscow
# timedatectl set-ntp true && timedatectl set-timezone Europe/Moscow
sleep 02
echo ""
echo -e "${BLUE}:: ${NC}Посмотрим статус службы NTP (NTP service)"
echo " Текущие настройки времени и даты "
timedatectl status  # Команда timedatectl status в Linux — это утилита, которая выводит на экран текущие настройки времени и даты операционной системы. Она является частью набора systemd, который представляет собой менеджер систем и сервисов во многих современных дистрибутивах Linux.
echo ""
echo -e "${BLUE}:: ${NC}Посмотрим дату и время без характеристик для проверки времени"
date  # команда date работает с датой и временем (можно извлекать любую дату в разнообразном формате)
# echo -e "${BLUE}:: ${NC}Убедитесь, что «System clock synchronized» имеет статус «yes». А если нет, то установим утилиту chrony"
sleep 03

clear
echo ""
echo -e "${GREEN}==> ${NC}Обновить и добавить новые ключи?"
echo -e "${CYAN} ! ${BOLD}Процесс обновления (поиска ключей) МОЖЕТ быть продолжительным (от 3 до 5... минут) ${NC}"
echo " Данный этап поможет вам избежать проблем с ключами Pacmаn, если Вы используете не свежий образ ArchLinux для установки! "
echo -e "${RED}=> ${YELLOW}Примечание: ${BOLD} - Иногда при запуске обновления ключей по hkp возникает ошибка, не переживайте просто при установке gnupg в линукс в дефолтном конфиге указан следующий сервер: (keyserver hkp://keys.gnupg.net). GnuPG - оснащен универсальной системой управления ключами, а также модулями доступа для всех типов открытых ключей. GnuPG, также известный как GPG, это инструмент командной строки с возможностью легкой интеграции с другими приложениями. ${NC}"
echo -e "${MAGENTA}=> Информация: ${BOLD}Однако, в ходе чтения различных руководств в интернете было выяснено, что подобный способ обновления и передачи ключей не самый лучший, т.к. эта информация передается открытым способом. И тот, кто наблюдает за траффиком, видит данные обновляемых при gpg -refresh-keys ключей. И поэтому рекомендуется использовать hkps сервера - (keyserver hkps://hkps.pool.sks-keyservers.net)! ${NC}"
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Если Вы сомневаетесь в своих действиях, можно пропустить запуск обновления ключей. Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
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
sleep 01
elif [[ $i_key == 0 ]]; then
 echo ""
 echo " Обновление ключей пропущено "
echo ""
echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов "
pacman -Sy --noconfirm  # обновить списки пакетов из репозиториев
 echo ""
 echo " Обновление и добавление новых ключей выполнено "
sleep 1
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установка утилит для работы с файловыми системами "
pacman -Syy  # обновление баз пакмэна (pacman)
# pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
pacman -S --noconfirm --needed arch-install-scripts  # Скрипты для помощи в установке Arch Linux ; https://archlinux.org/packages/extra/any/arch-install-scripts/ ; https://gitlab.archlinux.org/archlinux/arch-install-scripts ; 2024-10-30 21:58 UTC
pacman -S --noconfirm --needed dosfstools  # Утилиты файловой системы DOS ; https://archlinux.org/packages/core/x86_64/dosfstools/ ; https://github.com/dosfstools/dosfstools ; 2024-08-25 13:37 UTC
### Пакет dosfstools состоит из программ mkfs.fat, fsck.fat и fatlabel для создания, проверки и маркировки файловых систем семейства FAT.
pacman -S --noconfirm --needed util-linux-libs  # Библиотеки времени выполнения util-linux ; https://archlinux.org/packages/core/x86_64/util-linux-libs/ ; https://github.com/util-linux/util-linux ; Обеспечивает: libblkid.so=1-64, libfdisk.so=1-64, libmount.so=1-64, libsmartcols.so=1-64, libutil-linux, libuuid.so=1-64 ; Заменяет: libutil-linux ; Конфликты: С libutil-linux ; 2025-06-26 07:15 UTC
pacman -S --noconfirm --needed util-linux  # Различные системные утилиты для Linux ; https://archlinux.org/packages/core/x86_64/util-linux/ ; https://github.com/util-linux/util-linux ; Обеспечивает: hardlink, rfkill ; Конфликты: с hardlink, rfkill; Заменяет: hardlink, rfkill ; 2025-06-26 07:15 UTC
############## Утилиты файловых систем ###############
pacman -S --noconfirm --needed e2fsprogs  #  Утилиты файловой системы Ext2/3/4 ; https://archlinux.org/packages/core/x86_64/e2fsprogs/ ; http://e2fsprogs.sourceforge.net/ ; Обеспечивает: libcom_err.so=2-64, libe2p.so=2-64, libext2fs.so=2-64, libss.so=2-64 ; 2025-07-10 09:11 UTC
pacman -S --noconfirm --needed xfsprogs  # Утилиты файловой системы XFS в пространстве пользователя. Данный пакет содержит средства, необходимые для управления файловой системой XFS ; https://archlinux.org/packages/core/x86_64/xfsprogs/ ; https://xfs.wiki.kernel.org/ ; 2025-09-08 13:35 UTC
pacman -S --noconfirm --needed f2fs-tools  # Инструменты для Flash-дружественной файловой системы (F2FS) ; https://archlinux.org/packages/extra/x86_64/f2fs-tools/ ; https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git/about/ ; Обеспечивает: libf2fs.so=10-64, libf2fs_format.so=9-64 ;  2024-07-24 08:33 UTC
pacman -S --noconfirm --needed btrfs-progs  # Утилиты файловой системы btrfs ; https://archlinux.org/packages/core/x86_64/btrfs-progs/ ; https://btrfs.readthedocs.io/ ; Заменяет: btrfs-progs-unstable ; Конфликты: с btrfs-progs-unstable ; 2025-06-23 17:52 UTC
pacman -S --noconfirm --needed jfsutils  # Утилиты файловой системы JFS ; https://archlinux.org/packages/core/x86_64/jfsutils/ ; http://jfs.sourceforge.net/ ; 2024-03-19 15:03 UTC
pacman -S --noconfirm --needed lvm2  #  Утилиты Logical Volume Manager 2 ; https://archlinux.org/packages/core/x86_64/lvm2/ ; https://sourceware.org/lvm2/ ; Конфликты: с lvm, mkinitcpio<38-1 ; 2025-09-11 08:28 UTC
pacman -S --noconfirm --needed udisks2-lvm2  # Демон, инструменты и библиотеки для доступа и управления дисками, устройствами хранения данных и технологиями - модуль LVM2 ; https://archlinux.org/packages/extra/x86_64/udisks2-lvm2/ ; https://www.freedesktop.org/wiki/Software/udisks/ ; 2025-08-30 08:25 UTC
pacman -S --noconfirm --needed ntfs-3g  # Драйвер и утилиты файловой системы NTFS; "NTFS file support (Windows Drives)" ; https://www.tuxera.com/community/open-source-ntfs-3g/ ; https://archlinux.org/packages/extra/x86_64/ntfs-3g/ ; Обеспечивает: ntfsprogs ; Заменяет: ntfsprogs ; Конфликты: ntfsprogs ; 2025-04-28 23:01 UTC
pacman -S --noconfirm --needed zstd  # поддержка zstd ; Zstandard — быстрый алгоритм сжатия в реальном времени ; https://archlinux.org/packages/core/x86_64/zstd/ ; https://facebook.github.io/zstd/ ; Обеспечивает: libzstd.so=1-64 ; https://man.archlinux.org/man/zstd.1.en ; 2025-02-23 20:59 UTC
########## Инструмент для разметки, создания дисков (разделов) ###############
pacman -S --noconfirm --needed parted  # Программа для создания, уничтожения, изменения размера, проверки и копирования разделов ; https://archlinux.org/packages/extra/x86_64/parted/ ; https://www.gnu.org/software/parted/parted.html ; https://wiki.archlinux.org/title/Parted ; 2024-07-24 08:33 UTC
pacman -S --noconfirm --needed gpart  # Инструмент для спасения / угадывания таблицы разделов ; https://archlinux.org/packages/extra/x86_64/gpart/ ; https://github.com/baruch/gpart ; 2024-03-18 07:30 UTC
pacman -S --noconfirm --needed gptfdisk  # Инструмент для разметки в текстовом режиме, работающий на дисках с таблицей разделов GUID (GPT) ; https://archlinux.org/packages/extra/x86_64/gptfdisk/ ; https://www.rodsbooks.com/gdisk/ ; Обеспечивает: gdisk=1.0.10 ; Заменяет: gdisk ; Конфликты: gdisk ; 2024-02-20 19:22 UTC
########## Дополнительные утилиты для разметки, создания дисков (разделов) ###############
pacman -S --noconfirm --needed udftools  # Инструменты Linux для файловых систем UDF и приводов DVD/CD-R(W) ; https://archlinux.org/packages/extra/x86_64/udftools/ ; https://github.com/pali/udftools ; 2024-03-18 07:30 UTC
pacman -S --noconfirm --needed fatresize  # Утилита для изменения размера файловых систем FAT с помощью libparted ; https://archlinux.org/packages/extra/x86_64/fatresize/ ; https://sourceforge.net/projects/fatresize/ ; 2024-07-01 22:08 UTC
pacman -S --noconfirm --needed lsscsi  # Инструмент, который выводит список устройств, подключенных через SCSI / SATA устройств и его транспорты ; http://sg.danny.cz/scsi/lsscsi.html ; https://archlinux.org/packages/extra/x86_64/lsscsi/ ; 2024-07-12 22:15 UTC
###############
clear
echo ""
echo -e "${BLUE}:: ${NC}Просмотреть объём используемой и свободной оперативной памяти, имеющейся в системе "
free -m  # Свободная / Неиспользуемая память
sleep 03
clear
echo ""
echo -e "${BLUE}:: ${NC}Посмотрим список установленных SCSI-устройств "
echo " Список устройств scsi/sata "
lsscsi  # маленькая консольная утилита выводящая список подключенных SCSI / SATA устройств
sleep 03
echo ""
echo -e "${BLUE}:: ${NC}Смотрим, какие диски есть в нашем распоряжении "
lsblk -f  # Команда lsblk выводит список всех блочных устройств
lsblk -ni
sleep 03
echo ""
echo -e "${BLUE}:: ${NC}Посмотрим структуру диска созданного установщиком "
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " => Укажите диск (sda/sdb например sda или sdb) : " cfd
sgdisk -p /dev/$cfd  #sda; sdb; sdc; sdd - sgdisk - это манипулятор таблицы разделов Unix-подобных систем
sleep 7
clear
echo ""
echo -e "${BLUE}:: ${NC}Удалить (стереть) таблицу разделов на выбранном диске (sdX)?"
echo -e "${RED}=> ${YELLOW} Примечание! ${BOLD}Перед удалением раздела или таблицы разделов сделайте резервную копию своих данных. Все данные автоматически удаляются при удалении. Так как при выполнении данной опции будет деинсталлирован сам системный загрузчик из раздела MBR жесткого диска. ${NC}"
echo -e "${BLUE}:: ${NC}В скрипте установки есть 2 (два)! Варианта Стереть (удалить) таблицу разделов: "
 echo " 1(ый)  — Для (Устаревшая)  MSDOS (MBR) [часто обозначается как BIOS, Legacy BIOS] - главная загрузочная запись - Master Boot Record, редакторы его могут отображать как dos или msdos. "
 echo " 2(ой) — Для (Современная) UEFI (GPT) - GUID Partition Table . "
echo -e "${YELLOW}==> Примечание! ${BOLD} *Вы можете пропустить этот шаг, если не уверены в правильности выбора или вы уже подготовили диск к разметке и установки! ${NC}"
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
 echo ""
 echo " Создание новых записей MBR в памяти "
echo -e "${YELLOW} Структуры данных MSDOS (MBR) уничтожены! ${BOLD} *Теперь вы можете разбить физический диск на разделы с помощью утилиты "cfdisk" или других утилит. ${NC}"
sleep 03
elif [[ $sgdisk == 2 ]]; then
  echo ""
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
  read -p " => Укажите диск (sda/sdb например sda или sdb) : " cfd
  wipefs /dev/$cfd  # Проверьте таблицу разделов
# sgdisk --zap-all /dev/$cfd   #sda; sdb; sdc; sdd - sgdisk — командный манипулятор таблиц разделов GUID (GPT) для Linux и Unix ; sgdisk [параметры] устройство ; -Z, —zap-all (уничтожьте) структуры данных GPT и MBR, а затем выйдите. Этот параметр работает так же, как -z , но, поскольку он стирает как MBR, так и GPT, он более подходит, если вы хотите переразбить диск после использования этого параметра, и совершенно не подходит, если вы уже переразбили диск.
wipefs -a -t gpt -f /dev/$cfd  # Вы можете очистить таблицу разделов GPT
 echo ""
 echo " Создание новых записей GPT в памяти "
echo -e "${YELLOW} Структуры данных UEFI (GPT) уничтожены! ${BOLD} *Теперь вы можете разбить физический диск на разделы с помощью утилиты "cfdisk" или других утилит. ${NC}"
sleep 03
elif [[ $sgdisk == 0 ]]; then
 echo ""
 echo " Операция Удаления (стерания) таблицу разделов пропущена "
sleep 03
fi

clear
echo -e "${MAGENTA}
  <<< Создание разделов диска для установки ArchLinux. Вся разметка диска(ов) производится только утилитой - cfdisk >>>
${NC}"
echo -e "${GREEN}==> ${NC}Cfdisk — это текстовый графический инструмент командной строки, который позволяет вам создавать, удалять и изменять разделы диска в вашей системе. В отличие от других инструментов командной строки, Cfdisk предоставляет интерактивный способ управления разделами для новичков. (https://www.makeuseof.com/how-to-create-resize-and-delete-linux-partitions-with-cfdisk/)"
echo -e "${RED}=> ${YELLOW}Предупреждение! ${BOLD}*Перед созданием раздела(ов) или удалением таблицы разделов сделайте резервную копию своих данных. Повторю ещё раз - если что-то напутаете при разметке дисков, то можете случайно удалить важные для вас данные. Так как при выполнении данной опции (может) будет деинсталлирован сам системный загрузчик из раздела MBR жесткого диска. ${NC}"
echo -e "${RED}=> ${YELLOW}Обратите Внимание! ${BOLD}Что создавать отдельный загрузочный раздел для разметки диска в обычном BIOS НЕ обязательно, достаточно иметь Root раздел (корневой раздел) и все, (ещё МОЖНО создать Swap file или Swap partiton - свап файл и свап раздел), этого вполне достачно для установки системы под обычным BIOS в таблице разделов MBR/DOS. В скрипте установки для файловой системы прописан следующий сценарий: Выбираем нужный диск, теперь запускаем программу для разметки диска (указывая свой Диск). Программа очень простая, Delete - удаляет раздел, New - создает, Write - записывает изменения (прописать yes), Quit - выходит из программы. Управление программой стрелочное: -> <- (вверх, вниз, вправо, влево). Создаем два раздела и запоминаем их имя (метку - sda/sdb 1.2.3.4 и т.д.). ${NC}"
echo -e "${BLUE}:: ${BOLD}Для MBR первичных разделов на диске может быть всего 4, они всегда имеют номера от 1 до 4. Если раздел имеет номер 5, 6, 7 и т.д, то это уже логический раздел, который находится внутри расширенного раздела. Расширенный раздел это первичный раздел, который не содержит собственной файловой системы, а содержит другие логические разделы. Нельзя создать пять или более первичных разделов. Здесь Вы также можете подготовить разделы для Windows (ntfs/fat32)(С;D;E), и в дальнейшем после разбиения диска(ов), их примонтировать. В сценарии (скрипта) прописано форматирование разделов для Windows, но эта функция закомментирована # . ${NC}"
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
echo -e "${BLUE}:: ${NC}Выбор диска для установки "
echo -e "${CYAN}:: ${NC}Посмотрите вывод списка всех блочных устройств "
echo ""
lsblk -f  # Команда lsblk выводит список всех блочных устройств
#fdisk -l  # Посмотрим список доступных (созданных) дисков и разделов
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
 echo ""
 echo " Разметка диска(ов) (разделов) пропропущена "
sleep 01
fi
### cat /proc/partitions  # Чтобы перечислить все разделы диска, используйте следующую команду
clear
echo ""
echo -e "${BLUE}:: ${NC}Ваша разметка диска "
echo -e "${CYAN}:: ${NC}Посмотрите вывод списка всех блочных устройств "
echo ""
fdisk -l  # Посмотрим список доступных (созданных) дисков и разделов
lsblk -f  # Команда lsblk выводит список всех блочных устройств
#lsblk -lo  # Команда lsblk выводит список всех блочных устройств
sleep 5
###########
clear
echo -e "${MAGENTA}
  <<< Предисловие! О файловых системах представленных в сценарии скрипта: >>> ${NC}"
echo ""
echo -e "${BLUE} Ext4 (Fourth Extended Filesystem) ${NC} — журналируемая файловая система, используемая преимущественно в операционных системах с ядром Linux. Представлена в 2008 году как прогрессивная версия файловой системы ext3. Ext4 — это надежная и стабильная файловая система, которая сохраняет наши данные в безопасности в большинстве нежелательных событий, таких как сбой питания. Ext4 — универсальный выбор для простых конфигураций. "
echo -e "${BLUE} Btrfs (B-tree File System) ${NC} — файловая система для Linux, разработанная компанией Oracle в 2007 году. Основана на структурах B-деревьев и работает по принципу «копирование при записи» (Copy-on-Write, CoW). Btrfs — для домашнего использования, где важны гибкость и возможность легко откатывать обновления. Btrfs — для систем, где важны современные функции. "
echo -e "${BLUE} XFS ${NC} — высокопроизводительная 64-битная журналируемая файловая система, разработанная компанией Silicon Graphics для операционной системы IRIX. Поддерживается большинством дистрибутивов Linux. Например, XFS — файловая система по умолчанию в Red Hat Enterprise Linux, Oracle Linux, CentOS. XFS для крупномасштабных баз данных. В файловой системе XFS Нельзя уменьшить размер! "
echo -e "${BLUE} F2FS (Flash-Friendly File System) ${NC} — файловая система, предназначенная для флэш-памяти на базе NAND с поддержкой Flash Translation Layer. В отличие от JFFS или UBIFS, она использует Flash Transition Layer (FTL) для распределения записи. Поддерживается начиная с ядра версии 3.8. FTL присутствует во всех флэш-памяти с интерфейсом SCSI/SATA/PCIe/NVMe , в отличие от голой NAND Flash и SmartMediaCards . "
echo -e "${BLUE} JFS (Journaled File System) ${NC} — это журналируемая файловая система , исходный код которой был открыт компанией IBM в 1999 году, а ее поддержка доступна в ядре Linux с 2002 года. JFS — современная файловая система, поддерживающая множество функций, JFS, как и все файловые системы, со временем теряет производительность из-за фрагментации файлов. JFS использует журнал только для поддержания согласованности метаданных . Таким образом, в случае некорректного завершения работы можно гарантировать согласованность только метаданных (а не фактического содержимого файла). Это также относится к XFS и ReiserFS. Драйвер JFS встроен в качестве модуля в стандартные пакеты ядра Arch. "
echo ""
echo -e "${YELLOW}==> Примечание! ${BOLD}*Для форматирования будет использоваться утилита mkfs.ext4 или mke2fs (mke2fs - это первоначальная утилита командной строки для форматирования в ext*). Это одна и та же утилита. У неё ВОТ такой синтаксис: mkfs.ext4 опции /раздел/диска.  Команда mkfs (make file system) используется для создания файловой системы на блочном устройстве, таком как жесткий диск или флэш-накопитель. Без создания файловой системы устройство не может быть использовано для хранения данных. ${NC}"
### File systems: https://wiki.archlinux.org/title/File_systems
### mkfs [параметры] [-t <тип>] [параметры ФС] <устройство> [<размер>]
sleep 07

clear
echo -e "${MAGENTA}
  <<< Форматирование и монтирование разделов диска(ов) для ArchLinux. Проверка файловой системы на ошибки. Присвоение название разделов, установка флага(ов) монтирования: для root, boot, swap, home раздела(ов) — именно в такой последованности! >>> ${NC}"
########## Root  ########
echo ""
echo -e "${BLUE}:: ${NC}*Ваша разметка диска "
echo -e "${CYAN}:: ${NC}Посмотрите вывод списка всех блочных устройств "
echo ""
lsblk -f  # Команда lsblk выводит список всех блочных устройств
#fdisk -l  # Посмотрим список доступных (созданных) дисков и разделов
sleep 01
echo ""
echo -e "${GREEN}==> ${NC}Форматируем и монтируем ROOT- (Корневой) раздел? "
echo " Если таковой был создан при разметке в cfdisk "
echo " Либо ROOT был создан вами заранее и готов к дальнейшим действиям "
echo " ROOT / — Это ВАШ корневой раздел, он будет отформатирован в ( Ext4 ), ( XFS ), ( F2fs ) или ( JFS ) "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Если вы Хотите (очень) установить файловую систему Btrfs для ROOT- (Корневого) раздела, функция форматирования и монтирования с Btrfs — Будет представлена дальше в сценарии (скрипта), здесь просто пропустите действие Форматирования в этих представленных файловых системах! ${NC}"
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс форматирования был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Форматировать root в Ext4,     2 - Форматировать root в XFS,

    3 - Форматировать root в F2fs,     4 - Форматировать root в JFS,

    0 - НЕ Форматировать (пропустить): " roots  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$roots" =~ [^12340] ]]
do
    :
done
if [[ $roots == 0 ]]; then
 echo ""
 echo " Форматирование и монтирование не требуется "
sleep 01
elif [[ $roots == 1 ]]; then
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите ROOT раздел (sda/sdb 1.2.3.4 (sda5 например)): " root  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
 echo ""
 echo " Создадим файловую систему Ext4 для корневого раздела "
#pacman -S --noconfirm --needed e2fsprogs arch-install-scripts  # Установим утилиты, *Если таковые не были установлены !
### e2fsprogs - Утилиты файловой системы Ext2/3/4 ; https://archlinux.org/packages/core/x86_64/e2fsprogs/ ; http://e2fsprogs.sourceforge.net/ ; Обеспечивает: libcom_err.so=2-64, libe2p.so=2-64, libext2fs.so=2-64, libss.so=2-64 ; 2025-07-10 09:11 UTC
### arch-install-scripts - Скрипты для помощи в установке Arch Linux ; https://archlinux.org/packages/extra/any/arch-install-scripts/ ; https://gitlab.archlinux.org/archlinux/arch-install-scripts ; 2024-10-30 21:58 UTC
# pacman -S --noconfirm --needed lvm2  # (необязательно) - для e2scrub ; Утилиты Logical Volume Manager 2
### lvm2 - Утилиты Logical Volume Manager 2 ; https://archlinux.org/packages/core/x86_64/lvm2/ ; https://sourceware.org/lvm2/ ; Конфликты:  lvm, mkinitcpio<38-1 ; 2025-09-11 08:28 UTC
### Ext4 ArchWiki: https://wiki.archlinux.org/title/Ext4
# mkfs.ext4 /dev/$root -L root  # или - mkfs.ext4 /dev/$root -L archroot
#########
# mkfs -t ext4 /dev/$root -L root  # -t в команде mkfs (make file system) указывает тип создаваемой файловой системы. По умолчанию — ext2. сначала запускает общую [/usr]/sbin/mkfs команду, которая является оболочкой, выбирающей правильный двоичный файл mkfs, специфичный для файловой системы (в данном случае [/usr]/sbin/mkfs.ext4), в соответствии со значением параметра -t, и передает ему остальную часть командной строки. mkfs.ext4 /dev/sdbпросто пропускает оболочку и напрямую вызывает двоичный файл, специфичный для файловой системы.
# mkfs -F ext4 /dev/$root -L root  # «-F» в команде mkfs — это опция, которая позволяет указать тип файловой системы (FSType), которую нужно создать.
# mkfs.ext4 -n /dev/$root -L root  # -n Выполняет пробный прогон без фактического создания файловой системы. (https://hopeness.medium.com/master-the-linux-mkfs-ext4-command-a-comprehensive-guide-a727c9a9e03)
# mkfs.ext4 -E nodiscard /dev/$root -L root  # Вы можете использовать флаг '-E', чтобы передать расширенный параметр mkfs.ext4. Например, чтобы продолжить создание файловой системы даже при обнаружении существующей, используйте параметр 'nodiscard'.
######### Команды от GParted ################
# mkfs.ext4 -F -O ^64bit -L 'root' '/dev/$root'
mkfs.ext4 -F -O ^64bit -L "root" /dev/$root  # «-F» в команде mkfs — это опция, которая позволяет указать тип файловой системы (FSType), которую нужно создать. -O ^64bit — отключает 64-битные функции файловой системы по умолчанию (https://translated.turbopages.org/proxy_u/en-ru.ru.68053a99-68cc97f7-92ee40a2-74722d776562/https/unix.stackexchange.com/questions/388432/what-does-this-mkfs-ext4-operand-mean).
### Итак, я попытался отформатировать флешку с помощью GParted на другом компьютере. Когда всё получилось, я проверил, какую команду использует GParted, и попытался отформатировать флешку этой командой на своём Raspberry Pi. Процесс занял некоторое время (около минуты), но всё получилось.
### При использовании mkfs.ext4 важно помнить, что форматирование раздела приводит к потере всех существующих данных.
# mkfs.ext4 -q -j -O ^64bit -L root /dev/$root   # форматируем раздел будущей целевой системы
### Опция -q указывает на то, что во время выполнения утилиты будет выводиться минимум информации. Опция -j позволяет использовать журнал файловой системы ext3. Опция -O даёт возможность активировать или деактивировать те или иные возможности файловой системы. Некоторые из них: 64bit — файловая система сможет занимать место больше, чем 2 в 32 степени блоков. При размере блока 4 килобайта, это примерно один терабайт. encrypt — включить поддержку шифрования для файловой системы. ext_attr — включить расширенные атрибуты. huge_file — разрешить создавать файлы, размером больше двух терабайт. large_dir — увеличивает количество файлов, которые могут находиться в одной папке. metadata_csum — включает расчёт и проверку контрольных сумм для всех метаданных файловой системы. meta_bg — позволяет изменять размер раздела в реальном времени, когда файловая система смонтирована и используется. mmp — запрещает монтирование файловой системы к нескольким точкам одновременно. quota — включает поддержку квот.
 echo ""
 echo " Проверка файловой системы на ошибки и их автоматическое исправление "
### Fsck (File System Consistency Check) — утилита для Linux и Unix-подобных систем, которая проверяет и (по возможности) чинит файловые системы (ФС). Работает почти со всеми популярными ФС: ext2/3/4, XFS, Btrfs, ReiserFS, JFS и т. д..
### Базовый синтаксис: fsck <options> <filesystem>. В этом примере файловой системой может быть устройство, раздел, точка монтирования и так далее. Некоторые опции: -A — проверить все файловые системы из /etc/fstab; -C — показать прогресс проверки файловой системы; -M — не проверять, если файловая система смонтирована; -N — ничего не выполнять, показать, что проверка завершена успешно.
### Примеры использования: Для работы нужны права суперпользователя (root-доступом).
# fsck -y /dev/$root  # Проверка файловой системы на ошибки и их автоматическое исправление
fsck -n /dev/$root  # Проверка файловой системы на наличие ошибок, которые пока не нужно исправлять
# fsck -t -A ext4  # Проверка раздела с заданной файловой системой ext4
# fsck -AM  # Чтобы выполнить проверку файловой системы только на несмонтированных дисках
sleep 01
 echo ""
 echo " Смонтируем корневой раздел в /mnt "
# mount -o noatime,commit=120 /dev/$root /mnt
### Noatime – по сути, повышает производительность, не записывая время последнего доступа к файлу. commit – время в секундах, необходимое для синхронизации данных с хранилищем, здесь установлено значение 120 секунд, поэтому в случае отключения питания или сбоя любые данные за последние 2 минуты, скорее всего, будут утеряны; вы можете свободно изменить это значение.
mount /dev/$root /mnt  # Монтирование в /mnt ; /mnt - каталог для ручного монтирования файловых систем
# chmod 777 /mnt/$root # Разрешите кому угодно писать в него
#  mkdir /mnt/boot
#  mkdir /mnt/home
mkdir /mnt/{boot,home}  # Создание каталогов
 echo ""
 echo " Узнать тип смонтированной файловой системы "
mount | grep -E ^/dev/$root  # Чтобы узнать тип смонтированной файловой системы
# mount | grep /dev/$root
# mount | grep ^/dev/$root  # Вы также можете проверить, смонтирована ли файловая система
# mount | grep ext4  # отображать только файловые системы Ext4
# mount -l -t ext4  # Просмотреть все смонтированные разделы определенного типа
### Параметр «-l» позволяет получить список дисков и разделов на них в системе. Параметр «-t» указывает тип файловой системы, в данном случае это ext4 .
# df -hT | grep /dev/$root
# df -hT | grep /$  # в Bash найти диск, на котором находится корень Linux (/). Корень может находиться на томе LVM или на неформатированном диске. df -h Команда df -h показывает, какая файловая система смонтирована в какой точке монтирования.
sleep 03
 echo ""
 echo " Форматирование и монтирование выполнено "
sleep 01
elif [[ $roots == 2 ]]; then
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите ROOT раздел (sda/sdb 1.2.3.4 (sda5 например)): " root  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo ""
echo " Создадим файловую систему XFS для корневого раздела "
#pacman -S --noconfirm --needed xfsprogs arch-install-scripts  # Установим утилиты, *Если таковые не были установлены !
### arch-install-scripts - Скрипты для помощи в установке Arch Linux ; https://archlinux.org/packages/extra/any/arch-install-scripts/ ; https://gitlab.archlinux.org/archlinux/arch-install-scripts ; 2024-10-30 21:58 UTC
### xfsprogs - Утилиты файловой системы XFS в пространстве пользователя. Данный пакет содержит средства, необходимые для управления файловой системой XFS ; https://archlinux.org/packages/core/x86_64/xfsprogs/ ; https://xfs.wiki.kernel.org/ ; 2025-09-08 13:35 UTC
# pacman -S --noconfirm --needed lvm2  # (необязательно) - для e2scrub ; Утилиты Logical Volume Manager 2
### lvm2 - Утилиты Logical Volume Manager 2 ; https://archlinux.org/packages/core/x86_64/lvm2/ ; https://sourceware.org/lvm2/ ; Конфликты:  lvm, mkinitcpio<38-1 ; 2025-09-11 08:28 UTC
### XFS ArchWiki: https://wiki.archlinux.org/title/XFS
### Оптимизация производительности XFS — https://wiki.archlinux.org/title/XFS#Performance
# mkfs.xfs /dev/$root -L root  # или - mkfs.xfs /dev/$root -L archroot
### *При использовании mkfs.xfs на блочном устройстве, содержащем существующую файловую систему, добавьте опцию -f для перезаписи этой файловой системы. Эта операция уничтожит все данные, содержащиеся в предыдущей файловой системе.
mkfs.xfs -f /dev/$root -L root  # При использовании mkfs.xfs на блочном устройстве
### В целом, параметры по умолчанию оптимальны для обычного использования: meta-data=/dev/device
# meta-data=/dev/$root
# mkfs.xfs -f /dev/$root  # Принудительное создание файловой системы XFS поверх любой существующей. Это опция команды mkfs.xfs (из пакета xfsprogs). Опция -f (от force) нужна, если на указанном разделе уже существует файловая система другого типа, и нужно её перезаписать.
### *При использовании mkfs.xfs на блочном устройстве, содержащем существующую файловую систему, добавьте опцию -f для перезаписи этой файловой системы. Эта операция уничтожит все данные, содержащиеся в предыдущей файловой системе.
# mkfs.xfs -f /dev/$root -L root  # При использовании mkfs.xfs на блочном устройстве
### В целом, параметры по умолчанию оптимальны для обычного использования: meta-data=/dev/device
# meta-data=/dev/$root
 echo ""
 echo " Проверка файловой системы на ошибки и их автоматическое исправление "
### Fsck (File System Consistency Check) — утилита для Linux и Unix-подобных систем, которая проверяет и (по возможности) чинит файловые системы (ФС). Работает почти со всеми популярными ФС: ext2/3/4, XFS, Btrfs, ReiserFS, JFS и т. д..
### Базовый синтаксис: fsck <options> <filesystem>. В этом примере файловой системой может быть устройство, раздел, точка монтирования и так далее. Некоторые опции: -A — проверить все файловые системы из /etc/fstab; -C — показать прогресс проверки файловой системы; -M — не проверять, если файловая система смонтирована; -N — ничего не выполнять, показать, что проверка завершена успешно.
### Примеры использования: Для работы нужны права суперпользователя (root-доступом).
# fsck -y /dev/$root  # Проверка файловой системы на ошибки и их автоматическое исправление
fsck -n /dev/$root  # Проверка файловой системы на наличие ошибок, которые пока не нужно исправлять
# fsck -t -A xfs  # Проверка раздела с заданной файловой системой xfs
# fsck -AM  # Чтобы выполнить проверку файловой системы только на несмонтированных дисках
sleep 01
 echo ""
 echo " Смонтируем корневой раздел в /mnt "
### Монтирование — команда sudo mount /dev/device /mount/point, где /mount/point — каталог, где будет смонтирована файловая система XFS.
### Автоматическое монтирование — можно обновить файл /etc/fstab, добавив запись для файловой системы XFS.
# mount -o noatime,commit=120 /dev/$root /mnt
### Noatime – по сути, повышает производительность, не записывая время последнего доступа к файлу. commit – время в секундах, необходимое для синхронизации данных с хранилищем, здесь установлено значение 120 секунд, поэтому в случае отключения питания или сбоя любые данные за последние 2 минуты, скорее всего, будут утеряны; вы можете свободно изменить это значение.
mount /dev/$root /mnt  # Монтирование в /mnt ; /mnt - каталог для ручного монтирования файловых систем
#  mkdir /mnt/boot
#  mkdir /mnt/home
mkdir /mnt/{boot,home}  # Создание каталогов
 echo ""
 echo " Узнать тип смонтированной файловой системы "
# mount | grep -E /dev/$root  # Чтобы узнать тип смонтированной файловой системы
mount | grep /dev/$root
# mount | grep xfs  # отображать только файловые системы XFS
sleep 03
 echo ""
 echo " Форматирование и монтирование выполнено "
sleep 01
elif [[ $roots == 3 ]]; then
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите ROOT раздел (sda/sdb 1.2.3.4 (sda5 например)): " root  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo ""
echo " Создадим файловую систему F2fs для корневого раздела "
#pacman -S --noconfirm --needed f2fs-tools arch-install-scripts  # Установим утилиты, *Если таковые не были установлены !
### arch-install-scripts - Скрипты для помощи в установке Arch Linux ; https://archlinux.org/packages/extra/any/arch-install-scripts/ ; https://gitlab.archlinux.org/archlinux/arch-install-scripts ; 2024-10-30 21:58 UTC
### f2fs-tools - Инструменты для Flash-дружественной файловой системы (F2FS) ; https://archlinux.org/packages/extra/x86_64/f2fs-tools/ ; https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git/about/ ; Обеспечивает: libf2fs.so=10-64, libf2fs_format.so=9-64 ;   2024-07-24 08:33 UTC
# pacman -S --noconfirm --needed lvm2  # (необязательно) - для e2scrub ; Утилиты Logical Volume Manager 2
### lvm2 - Утилиты Logical Volume Manager 2 ; https://archlinux.org/packages/core/x86_64/lvm2/ ; https://sourceware.org/lvm2/ ; Конфликты:  lvm, mkinitcpio<38-1 ; 2025-09-11 08:28 UTC
### F2FS ArchWiki: https://wiki.archlinux.org/title/F2FS
### # mkfs.f2fs -l mylabel -O extra_attr,inode_checksum,sb_checksum /dev/sdxY
mkfs.f2fs -f /dev/$root -L root  # или - mkfs.f2fs -f /dev/$root -L archroot
 echo ""
 echo " Проверка файловой системы на ошибки и их автоматическое исправление "
### Fsck (File System Consistency Check) — утилита для Linux и Unix-подобных систем, которая проверяет и (по возможности) чинит файловые системы (ФС). Работает почти со всеми популярными ФС: ext2/3/4, XFS, Btrfs, ReiserFS, JFS и т. д..
### Базовый синтаксис: fsck <options> <filesystem>. В этом примере файловой системой может быть устройство, раздел, точка монтирования и так далее. Некоторые опции: -A — проверить все файловые системы из /etc/fstab; -C — показать прогресс проверки файловой системы; -M — не проверять, если файловая система смонтирована; -N — ничего не выполнять, показать, что проверка завершена успешно.
### Примеры использования: Для работы нужны права суперпользователя (root-доступом).
# fsck -y /dev/$root  # Проверка файловой системы на ошибки и их автоматическое исправление
fsck -n /dev/$root  # Проверка файловой системы на наличие ошибок, которые пока не нужно исправлять
# fsck -t -A f2fs  # Проверка раздела с заданной файловой системой f2fs
# fsck -AM  # Чтобы выполнить проверку файловой системы только на несмонтированных дисках
sleep 01
 echo ""
 echo " Смонтируем корневой раздел в /mnt "
# mount -o noatime,commit=120 /dev/$root /mnt
### Noatime – по сути, повышает производительность, не записывая время последнего доступа к файлу. commit – время в секундах, необходимое для синхронизации данных с хранилищем, здесь установлено значение 120 секунд, поэтому в случае отключения питания или сбоя любые данные за последние 2 минуты, скорее всего, будут утеряны; вы можете свободно изменить это значение.
# mount -t f2fs /dev/$root /mnt  # https://zonedstorage.io/docs/filesystems/f2fs
mount /dev/$root /mnt  # Монтирование в /mnt ; /mnt - каталог для ручного монтирования файловых систем
#  mkdir /mnt/boot
#  mkdir /mnt/home
mkdir /mnt/{boot,home}  # Создание каталогов
 echo ""
 echo " Узнать тип смонтированной файловой системы "
# mount | grep -E /dev/$root  # Чтобы узнать тип смонтированной файловой системы
mount | grep /dev/$root
# mount | grep ext4  # отображать только файловые системы Ext4
sleep 03
 echo ""
 echo " Форматирование и монтирование выполнено "
sleep 01
elif [[ $roots == 4 ]]; then
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите ROOT раздел (sda/sdb 1.2.3.4 (sda5 например)): " root  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo ""
echo " Создадим файловую систему JFS для корневого раздела "
#pacman -S --noconfirm --needed jfsutils arch-install-scripts  # Установим утилиты, *Если таковые не были установлены !
### arch-install-scripts - Скрипты для помощи в установке Arch Linux ; https://archlinux.org/packages/extra/any/arch-install-scripts/ ; https://gitlab.archlinux.org/archlinux/arch-install-scripts ; 2024-10-30 21:58 UTC
### jfsutils - Утилиты файловой системы JFS ; https://archlinux.org/packages/core/x86_64/jfsutils/ ; http://jfs.sourceforge.net/ ; 2024-03-19 15:03 UTC
# pacman -S --noconfirm --needed lvm2  # (необязательно) - для e2scrub ; Утилиты Logical Volume Manager 2
### lvm2 - Утилиты Logical Volume Manager 2 ; https://archlinux.org/packages/core/x86_64/lvm2/ ; https://sourceware.org/lvm2/ ; Конфликты:  lvm, mkinitcpio<38-1 ; 2025-09-11 08:28 UTC
### JFS ArchWiki: https://wiki.archlinux.org/title/JFS
# Файловую систему JFS можно создать с помощью: mkfs.jfs /dev/target_dev или: jfs_mkfs /dev/target_dev
# mkfs.jfs /dev/$root -L root
mkfs.jfs -f /dev/$root -L root  # или - mkfs.jfs -f /dev/$root -L archroot
 echo ""
 echo " Проверка файловой системы на ошибки и их автоматическое исправление "
### Fsck (File System Consistency Check) — утилита для Linux и Unix-подобных систем, которая проверяет и (по возможности) чинит файловые системы (ФС). Работает почти со всеми популярными ФС: ext2/3/4, XFS, Btrfs, ReiserFS, JFS и т. д..
### Базовый синтаксис: fsck <options> <filesystem>. В этом примере файловой системой может быть устройство, раздел, точка монтирования и так далее. Некоторые опции: -A — проверить все файловые системы из /etc/fstab; -C — показать прогресс проверки файловой системы; -M — не проверять, если файловая система смонтирована; -N — ничего не выполнять, показать, что проверка завершена успешно.
### Примеры использования: Для работы нужны права суперпользователя (root-доступом).
# fsck -y /dev/$root  # Проверка файловой системы на ошибки и их автоматическое исправление
fsck -n /dev/$root  # Проверка файловой системы на наличие ошибок, которые пока не нужно исправлять
# fsck -t -A jfs  # Проверка раздела с заданной файловой системой jfs
# fsck -AM  # Чтобы выполнить проверку файловой системы только на несмонтированных дисках
sleep 01
 echo ""
 echo " Смонтируем корневой раздел в /mnt "
# mount -o noatime,commit=120 /dev/$root /mnt
### Noatime – по сути, повышает производительность, не записывая время последнего доступа к файлу. commit – время в секундах, необходимое для синхронизации данных с хранилищем, здесь установлено значение 120 секунд, поэтому в случае отключения питания или сбоя любые данные за последние 2 минуты, скорее всего, будут утеряны; вы можете свободно изменить это значение.
mount /dev/$root /mnt  # Монтирование в /mnt ; /mnt - каталог для ручного монтирования файловых систем
#  mkdir /mnt/boot
#  mkdir /mnt/home
mkdir /mnt/{boot,home}  # Создание каталогов
 echo ""
 echo " Узнать тип смонтированной файловой системы "
# mount | grep -E /dev/$root  # Чтобы узнать тип смонтированной файловой системы
mount | grep /dev/$root
# mount | grep jfs  # отображать только файловые системы JFS
sleep 03
 echo ""
 echo " Форматирование и монтирование выполнено "
sleep 01
fi
############# Справка ##############
### mkfs [опции] [-t тип_фс] [опции_фс] устройство
### mkfs.тип_фс [опции] [опции_фс] устройство
# Опции команды mkfs:
# -t или --type — тип файловой системы, по умолчанию ext2
# -V или --verbose — подробная информация; указание два раза приведет к тестовому запуску
# -V или --version — информация о используемой версии
# -h или --help — краткая справка о команде
####################################

clear
echo -e "${MAGENTA}
  <<< Установка файловой системы Btrfs для ROOT- (корневого раздела) в Archlinux >>> ${NC}"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Если вы ещё НЕ Отформатировали ваш ROOT- (корневой раздел) в другую из предложенных файловых систем, прошу к барьеру... *В случае, Если вами уже, БЫЛА установлена файловая система для ROOT- (корневого раздела) просто пропускайте действие выполнения сценария скрипта Введя на клавиатуре: "0". *Будьте внимательны! ${NC}"
# Installing the Btrfs file system for ROOT (root partition) in Archlinux
#clear
echo ""
echo -e "${GREEN}==> ${NC}Ваш диск SSD или HDD (для Btrfs)? "
echo -e "${YELLOW} Примечание! ${BOLD} *Для дальнейшей установки файловой системы Btrfs, монтирования папок в каталоге /mnt ,
добавления параметров монтирования и последующей записи информации нужно выяснить формат вашего накопителя (диска). ${NC}"
echo -e "${YELLOW}==> Пояснение! ${BOLD} *Эта функция нужна, чтобы прописать опции монтирования файловой системы в файле /etc/fstab , там будет прописано: как файловая система монтируется для чтения и записи, опция монтирования файловой системы BTRFS, алгоритм сжатия zstd для сжатия данных на диске с целью экономии места, опция, которая отключает обновление времени доступа к файлам при каждом их чтении, и позволяет BTRFS , если у вас SSD изменять свое поведение для повышения производительности и т.д... ${NC}"
echo " Файл fstab (https://man.archlinux.org/man/fstab.5) можно использовать для определения того, как разделы диска, различные другие блочные устройства или удаленные файловые системы должны быть монтированы в файловую систему. Каждая файловая система описывается в отдельной строке. Эти определения будут динамически преобразованы в единицы монтирования systemd при загрузке системы и при перезагрузке конфигурации системного менеджера. Настройка по умолчанию автоматически проверяет fsck и монтирует файловые системы перед запуском служб, которым требуется их монтирование. "
echo -e "${BLUE}:: ${NC}Выберите свой вариант накопителя (диска): "
echo -e "${CYAN}:: ${NC}Если у вас SSD (Solid-State Drive), Nvme, m2 или usb_flash -> Выберите: 1 "
echo -e "${CYAN}:: ${NC}Если у вас HDD (Твердотельные накопитель, Жёсткий диск, винчестер) -> Выберите: 2 "
echo -e "${CYAN}:: ${NC}Либо пропустите действие определения -> Выберите: 0 "
echo " Так как вы Возможно! уже СОЗДАЛИ ROOT ( / корневой ) раздел с другой файловой ситемой "
echo -e "${YELLOW} Примечание! ${BOLD} *Эта опции монтирования Нужна только для Btrfs — файловой системы. ${NC}"
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - SSD (Solid-State Drive) - Nvme - m2 - usb_flash,

    2 - HDD (Твердотельные накопитель, Жёсткий диск, винчестер)

    0 - Пропустить действие определения: " subst  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$subst" =~ [^120] ]]
do
    :
done
if [[ $subst == 0 ]]; then
 echo ""
 echo " Действие определения накопителя (диска) пропущено "
sleep 01
elif [[ $subst == 1 ]]; then
 echo ""
 echo " SSD (Solid-State Drive) - Nvme - m2 - usb_flash "
 echo " Добавление параметров монтирования "
#sub='rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,subvol'
sub='rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol' # defaults
case "$sub " in
esac
 echo " Добавление параметров монтирования выполнено "
sleep 01
elif [[ $subst == 2 ]]; then
 echo ""
 echo " HDD (Твердотельные накопитель, Жёсткий диск, винчестер) "
 echo " Добавление параметров монтирования "
sub='rw,relatime,space_cache=v2,autodefrag,nodatacow,subvol'
case "$sub " in
esac
 echo " Добавление параметров монтирования выполнено "
sleep 01
fi
############# Справка ##############
### fstab ArchWiki: https://wiki.archlinux.org/title/Fstab
### Конструкция case: https://metanit.com/os/linux/12.9.php
### Параметры Btrfs:
### Rw и noatime — это опции монтирования файловой системы в файле fstab.
# Rw (read-write) означает, что файловая система монтируется для чтения и записи. Это параметр по умолчанию, который позволяет записывать и читать данные на файловой системе.
# Noatime — опция, которая отключает обновление времени доступа к файлам при каждом их чтении. Noatime – по сути, повышает производительность, не записывая время последнего доступа к файлу.
# Relatime указывает, что время доступа к файлу будет обновляться только в том случае, если предыдущее время обращения меньше времени изменения файла.
# compress=zstd – использует алгоритм сжатия zstd для сжатия данных на диске с целью экономии места и, в некоторых случаях, может даже повысить производительность чтения/записи, выбрал zstd, так как он обеспечивает хороший уровень сжатия и скорость.
# SSD — предполагает, что базовым устройством является SSD, и позволяет BTRFS изменять свое поведение на основе этого предположения для повышения производительности.
# space_cache=v2 – использует версию 2 кэша свободного пространства, которая более эффективна и менее подвержена повреждению.
# Discard=async — опция монтирования файловой системы BTRFS, которая включает поддержку асинхронного сброса. Суть опции: незанятые блоки группируются и освобождаются позже в отдельном потоке, что улучшает задержки при записи на диск и бережнее относится к SSD в плане перезаписи.
# subvol=/ – указывает подтом файловой системы BTRFS для монтирования, в данном случае это подтом верхнего уровня.
# autodefrag - Обнаруживает небольшие случайные записи в файлы и ставит их в очередь для автоматического дефрагментации, поэтому файловая система будет дефрагментировать себя, пока она используется. Не подходит для виртуализации или высоконагруженных баз данных, но хорошо работает для небольших файлов.
# nodatacow - отключает COW для данных. Можно применять к отдельному файлу либо к подтому/директории, в том числе рекурсивно. Он отключает механизм copy on write, благодаря чему Btrfs при обновлении содержимого файла будет всегда работать с фиксированной дисковой областью, записывая данные поверх существующих (на физическом уровне).
# commit – время в секундах, необходимое для синхронизации данных с хранилищем, здесь установлено значение 120 секунд, поэтому в случае отключения питания или сбоя любые данные за последние 2 минуты, скорее всего, будут утеряны; вы можете свободно изменить это значение.
# Mount -o -o просто означает опции при использовании монтирования, и это те опции, которые мы используем. Вы можете просто запустить mount без -o (параметров), но проще применить настройки производительности к fstab во время монтирования сейчас, чтобы не пришлось возвращаться и менять их позже.
# Барьер (Barrier) — вы также можете добавить barrier=0, если хотите, это повысит производительность, однако в случае отключения питания вы можете столкнуться с потерей данных, а то и с повреждением всего раздела. Поэтому я оставил это здесь. Если у вас ноутбук или система бесперебойного питания, возможно, стоит учесть это. Подробнее об этом можно прочитать здесь.
#################################
clear
echo ""
echo -e "${BLUE}:: ${NC}*Ваша разметка диска "
echo -e "${CYAN}:: ${NC}Посмотрите вывод списка всех блочных устройств "
lsblk -f  # Команда lsblk выводит список всех блочных устройств
#fdisk -l  # Посмотрим список доступных (созданных) дисков и разделов
sleep 01
echo ""
echo -e "${BLUE}:: ${NC}Установить файловую систему Btrfs для ROOT- (Корневого) раздела?"
echo " Если таковой был создан при разметке в cfdisk "
echo " Либо ROOT был создан вами заранее и готов к дальнейшим действиям "
echo " ROOT / — Это ВАШ корневой раздел, он будет отформатирован в файловую систему ( BTRFS ) "
echo -e "${YELLOW} Примечание! ${BOLD} *Вы Можете пропустить установку (форматирование, монтирование) файловой системы Btrfs для ROOT- (Корневого) раздела, ЕСЛИ ваш ROOT раздел УЖЕ отформатирован и смонтирован в другой файловой системе (например Ext4). ${NC}"
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс форматирования был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Форматировать root в Btrfs,   0 - НЕ Форматировать (пропустить): " rootsb  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$rootsb" =~ [^10] ]]
do
    :
done
if [[ $rootsb == 0 ]]; then
 echo ""
 echo " Форматирование и монтирование не требуется "
sleep 01
elif [[ $rootsb == 1 ]]; then
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите ROOT раздел (sda/sdb 1.2.3.4 (sda5 например)): " root  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
 echo ""
 echo " Создадим файловую систему Btrfs для корневого раздела "
# pacman -S --noconfirm --needed btrfs-progs arch-install-scripts  # Установим утилиты, *Если таковые не были установлены !
### btrfs-progs - Утилиты файловой системы Btrfs ; https://archlinux.org/packages/core/x86_64/btrfs-progs/ ; https://btrfs.readthedocs.io/ ; Обеспечивает: btrfs-progs-unstable ; Заменяет: btrfs-progs-unstable ; Конфликты: btrfs-progs-unstable ; 2025-09-12 16:30 UTC
### arch-install-scripts - Скрипты для помощи в установке Arch Linux ; https://archlinux.org/packages/extra/any/arch-install-scripts/ ; https://gitlab.archlinux.org/archlinux/arch-install-scripts ; 2024-10-30 21:58 UTC
# pacman -S --noconfirm --needed lvm2  # (необязательно) - для e2scrub ; Утилиты Logical Volume Manager 2
### lvm2 - Утилиты Logical Volume Manager 2 ; https://archlinux.org/packages/core/x86_64/lvm2/ ; https://sourceware.org/lvm2/ ; Конфликты:  lvm, mkinitcpio<38-1 ; 2025-09-11 08:28 UTC
mkfs.btrfs -f /dev/$root -L root  # или - mkfs.btrfs -f /dev/$root - без -L|--label <строка>
# mkfs.btrfs -f -L root /dev/$root  # /dev/sda<цифра>
### mkfs.btrfs ; mkfs.btrfs [опции] <устройство> [<устройство>…] ; https://btrfs.readthedocs.io/en/latest/mkfs.btrfs.html
### -f|--force ; Принудительно перезаписывать блочные устройства при обнаружении существующей файловой системы. По умолчанию mkfs.btrfs использует libblkid для проверки наличия известных файловых систем на устройствах. В качестве альтернативы, для очистки устройств можно использовать утилиту wipefs .
### sudo mkfs.btrfs --label "{{label}}" {{/dev/sda}} [{{/dev/sdN}}] ; Установите метку для файловой системы
### -L|--label <строка> ; Укажите метку файловой системы. Длина строки должна быть меньше 256 байт и не должна содержать символов перевода строки.
# mkfs.btrfs -f --metadata single --data single /dev/$root -L root
# mkfs.btrfs --label "root" /dev/$root
### mkfs.btrfs: Эта команда инициирует создание файловой системы Btrfs на указанных устройствах.
# --metadata single: Этот параметр определяет способ хранения метаданных (вспомогательных данных, описывающих структуры файловой системы). При использовании single метаданные размещаются на устройстве без избыточности, что обеспечивает максимальную эффективность хранения.
# --data single: этот параметр определяет способ хранения блоков данных, single указывая на отсутствие избыточности и эффективное использование пространства на устройстве.
### --label "label": присваивает файловой системе понятную человеку метку, заменяя labelеё фактическим желаемым именем. Эту метку можно использовать для монтирования и управления.
# mkfs.btrfs -f --metadata single --data single --label "root" /dev/$root
### Дефрагментация btrfs: Из-за использования копирования при записи может возникать фрагментация. Чтобы запустить дефрагментацию файловой системы используйте команду: дефрагментация с помощью команды btrfs filesystem defragment <путь>
# sudo btrfs filesystem defrag /mnt
# echo ""
# echo " Проверка файловой системы на ошибки и их автоматическое исправление "
# echo " Проверка файловой системы для Btrfs не требуется "
### При генерации initramfs mkinitcpio будет ругаться на отсутствие fsck.btrfs - это нормальное явление. Уберём этот хук fsck из конфига, т.к. для Btrfs он не требуется.
# nano /etc/mkinitcpio.conf
### Вот данная строка в файле:
# HOOKS="base udev autodetect modconf block filesystems keyboard"
### И пересоздадим initramfs:
# mkinitcpio -p linux  # или linux-lts
sleep 01
 echo ""
 echo " Проверка файловой системы на ошибки и их автоматическое исправление "
### Fsck (File System Consistency Check) — утилита для Linux и Unix-подобных систем, которая проверяет и (по возможности) чинит файловые системы (ФС). Работает почти со всеми популярными ФС: ext2/3/4, XFS, Btrfs, ReiserFS, JFS и т. д..
### Базовый синтаксис: fsck <options> <filesystem>. В этом примере файловой системой может быть устройство, раздел, точка монтирования и так далее. Некоторые опции: -A — проверить все файловые системы из /etc/fstab; -C — показать прогресс проверки файловой системы; -M — не проверять, если файловая система смонтирована; -N — ничего не выполнять, показать, что проверка завершена успешно.
### Примеры использования: Для работы нужны права суперпользователя (root-доступом).
# fsck -y /dev/$root  # Проверка файловой системы на ошибки и их автоматическое исправление
fsck -n /dev/$root  # Проверка файловой системы на наличие ошибок, которые пока не нужно исправлять
# fsck -t -A jfs  # Проверка раздела с заданной файловой системой jfs
# fsck -AM  # Чтобы выполнить проверку файловой системы только на несмонтированных дисках
sleep 01
echo ""
echo -e "${BLUE}:: ${NC} Смонтируем ROOT- (Корневой раздел) в /mnt "
echo -e "${MAGENTA}:: ${BOLD}*Чтобы создать подтома в каталоге /mnt, вам нужно выбрать вариант монтирования: ${NC}"
echo " Монтирование Btrfs с HOME (home) разделом (ЕСЛИ таковой был создан при разметке!) введите: 1 "
echo -e "${YELLOW} Монтирование Btrfs с HOME (home) разделом! ${BOLD} *Что это (как)? Допустим вы уже создали отдельный HOME (раздел) при разметки диска и в последующем хотите отформатировать его в файловую систему Btrfs (которая будет представлена далее в сценарии скрипта установки), или в другую (файловую систему например: Ext4). Либо раздел HOME (домашний) у вас остался от другой вашей операционной системы Unix (любой), и вы в дальнейшем захотите его примонтировать! ${NC}"
echo " Монтирование Btrfs БЕЗ HOME (home) раздела (ЕСЛИ таковой НЕ был создан при разметке!) введите: 2 "
echo -e "${YELLOW} Монтирование Btrfs БЕЗ HOME (home) раздела! ${BOLD} *Что это (как)? Преположим вы НЕ создали отдельный HOME (раздел) при разметки диска и в последующем хотите, ЧТОБЫ раздел HOME (домашний) находился в ROOT- (Корневом разделе) ваше будующей системы. В этом случае сценарий последованности действий для файловой системы Btrfs таков: Сначала просходит монтирование созданного ROOT- (Корневого раздела) в /mnt , Создаются подразделы (Subvolume /@) на смонтированном btrfs разделе в каталоге /mnt (включая пораздел @home — Домашний подтом), затем проходит Монтировать ROOT- (Корневого раздела) как подтома..., далее Создаются несколько папок в каталоге /mnt (boot,home,var,opt,tmp,var/log,var/cache/pacman/pkg,.snapshots), проходит Монтирование папок в каталоге /mnt с заданными опциями монтирования файловой системы для Btrfs, и ВСЁ! ${NC}"
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс монтирования был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. Выберите нужный вам ВАРИАНТ! ${NC}"
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
 echo " Монтирование Btrfs с HOME (home) разделом "
 echo " Монтирование ROOT раздела в /mnt - каталог для ручного монтирования файловых систем "
 mount /dev/$root /mnt  # Монтирование в /mnt ; /mnt - каталог для ручного монтирования файловых систем
# mkdir -p /mnt/{home,boot,var,.snapshots}
# mkdir -p /mnt/{boot/efi,home,var/log,var/cache/pacman/pkg,btrfs}
### Опция -p в команде mkdir (make directory) в Linux приказывает создавать родительские каталоги одновременно с каталогом. Это позволяет: создавать вложенные каталоги без необходимости создавать каждый родительский каталог по отдельности; создавать несколько уровней каталогов за одну команду.
 echo ""
 echo " Узнать тип смонтированной файловой системы "
df -h
mount | grep -E /dev/$root  # Чтобы узнать тип смонтированной файловой системы
# mount | grep /dev/$root
# mount | grep btrfs  # отображать только файловые системы Btrfs
sleep 03
 echo ""
 echo " Создаем подразделы (Subvolume /@) на смонтированном btrfs разделе в каталоге /mnt "
# btrfs subvolume create /mnt/root
# btrfs subvolume set-default /mnt/root
### Команда btrfs subvolume set-default /mnt/root — это команда для файловой системы Btrfs, которая устанавливает сабвольюм (subvolume) по умолчанию для монтирования файловой системы. Это позволяет: Скрыть сабвольюм верхнего уровня (тот, который монтируется с параметром subvol=/ или subvolid=5). Указать сабвольюм — можно указать его по ID или по пути. ID сабвольюма можно получить с помощью команд btrfs subvolume list, btrfs subvolume show или btrfs inspect-internal rootid. Синтаксис: Команда btrfs subvolume set-default [<subvolume>|<id> <path>].
### Важно: при установке дефолтного сабвольюма нужно указать место, где он монтируется (в данном случае — /mnt). Если не указать путь, btrfs прочитает из специальной записи ID сабвольюма, который необходимо монтировать по умолчанию, и не изменит его.
## su = подтом ; cr = создать
### btrfs su cr - псевдоним для btrfs subvolume create. Название подразделов начинаются с @ чтобы не путать их с другими каталогами.
### Я бы предложил по крайней мере один подтом для корня (@) и один для снимков (@snapshots). varlog и tmp созданы для простого отключения копирования при записи на /var/log и /tmp.
######### Или этот Вариант ##########
### Перейдём в каталог /mnt
# cd /mnt
btrfs subvolume create /mnt/@             # @ — Это основной корневой подтом /
btrfs subvolume create /mnt/@home         # @home - Домашний подтом
#btrfs subvolume create /mnt/@root        # @root — Корневой подтом
#btrfs subvolume create /mnt/@var         # @var — Журналы, некоторые временные файлы, кэши и т. д.
btrfs subvolume create /mnt/@log          # @log — Журналы работы утилит, некоторые временные файлы
# btrfs su cr /mnt/@var_log               # @var_log или просто @log — Логи как правило не представляют интереса, но в снапшотах занимают дополнительное место.
#btrfs subvolume create /mnt/@opt         # @opt — Каталог, в котором размещаются стороннее программное обеспечение и пакеты
btrfs subvolume create /mnt/@pkg          # @pkg — Каталог, в который утилита makepkg помещает скомпилированные файлы
#btrfs subvolume create /mnt/@tmp         # @tmp — Основное расположение временных файлов
#btrfs subvolume create /mnt/@cache       # @cache — Это кэш пакетного менеджера (pacman)
btrfs subvolume create /mnt/@.snapshots   # @snapshots – Каталог для хранения снимков.
# btrfs su cr /mnt/@snapshots             # @snapshots — Snapper будет хранить здесь ваши снимки BTRFS. Если Snapper не используется, этот раздел не нужен. Содержит снапшоты корня, которые создает snapper.
### Подтома @machines, @portables, @.snapshots, @home.snapshots и @docker (опционально при использовании docker) нужны чтобы не заморачиваться с переносом вложенных подтомов при замене старого подтома на снапшот. Однако, вся эта плоская структура подтомов скорее нужна на серверах. Чтобы не заморачиваться я советую использовать Btrfs Asssistant.
#btrfs subvolume create /mnt/@home.snapshots      # @home.snapshots — Содержит снапшоты хомяка, которые создает snapper
btrfs subvolume create /mnt/@srv                  # @srv — это SRV-запись (Service Record), которая является типом записи в системе доменных имен (DNS) и указывает на местоположение (имя хоста и номер порта) серверов, предоставляющих определенные службы в сети. Эта запись помогает клиентам находить нужный сервер для конкретной службы, такой как IMAP или SIP, вместо того чтобы запоминать IP-адреса и порты вручную.
## btrfs subvolume create /mnt/@btrfs             # @btrfs - Стандартно это служебный подтом (ID=5)
# btrfs subvolume create /mnt/@machines           # Если не существует, то создаст systemd
# btrfs subvolume create /mnt/@portables          # Если не существует, то создаст systemd
# btrfs subvolume create /mnt/@docker             # Рекомендации самого Docker с их сайта
# btrfs subvolume create /mnt/@docker_btrfs       # Docker создает саьвольюмы по этому пути
#btrfs subvolume create /mnt/@usr                 # @usr — содержит большинство пользовательских утилит и приложений и часто находится в корневом разделе, но может быть отделен для определенных случаев использования.
#btrfs subvolume create /mnt/@local               # @local — служит для локально собираемых программ
# btrfs subvolume create /mnt/@var_lib            # Вместо создания @machines, @portables, @docker можно создать только этот, если в /var/lib не будет храниться чего-то важного (предполагается, что будут делаться снапшоты только корня и/или хомяка)
## btrfs subvolume create /mnt/@swap              # @swap — Хранит файл подкачки. Должен монтироваться с nodatacow
## btrfs subvolume create /mnt/@abs               # @abs — позволяет нам «загружать» все PKGBUILDS из пакетов репозиториев Archlinux
btrfs subvolume create /mnt/@libvirt              # @libvirt — это каталог, в котором хранятся образы жёстких дисков, мгновенные снимки системы и другие данные при использовании гипервизора, например Qemu-KVM.
### Удаление подтома:
# https://btrfs.readthedocs.io/en/latest/btrfs-subvolume.html
# btrfs subvolume delete /mnt/ <Название,наименование>
### Подтом btrfs возвращает нулевой код завершения в случае успешного завершения. В случае неудачи возвращается ненулевое значение.
# https://btrfs.readthedocs.io/en/latest/btrfs-subvolume.html#man-subvolume-set-default
 echo ""
 echo " Проверка создания томов в /mnt "
btrfs subvolume list /mnt  # li = список
# btrfs sub list /mnt
# cat /etc/fstab
sleep 03
#echo ""
#echo " Отключить копирование при записи /var/log и /tmp "
#chattr +C /mnt/@var
#chattr +C /mnt/@log  # (выставляю nocow атрибут "chattr +C")
#chattr +C /mnt/@cache  #  (выставляю nocow атрибут "chattr +C")
# chattr +C /mnt/@varlog
#chattr +C /mnt/@tmp
# chattr +C /mnt/@swap  # (не использую swap файл, на перспективу, также выставляю nocow атрибут "chattr +C")
### Теперь выйдем из каталога mnt и отмонтируем наш массив командой:
# cd ..
 echo ""
 echo " Размонтируем (отмонтируем) корневой раздел смонтированный в каталоге /mnt "
### umount --help  # -h, --help ; отобразите эту справку и выйдите ; https://github.com/dsw0214/linux-commands/blob/master/umount.md
# umount /mnt   # — размонтирует все файловые системы, примонтированные к /mnt
umount -R /mnt  # -R, --recursive ; рекурсивно размонтировать целевой объект со всеми его дочерними элементами
 echo " Размонтирование смонтированного корневого раздела выполнено "
sleep 01
 echo ""
 echo " Смонтировать root раздел как подтома... "
#sub='rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,subvol'  # для SSD (Solid-State Drive) - Nvme - m2 - usb_flash
#sub='defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol'  # для SSD (Solid-State Drive) - Nvme - m2 - usb_flash
#export sub="defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol"
#sub='rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,subvol'  # для SSD (Solid-State Drive) - Nvme - m2 - usb_flash
### mount -o defaults,noatime,compress=zstd,commit=120,subvol=@root /dev/sdX /mnt/root
####### Монтирование @ #######
# mount -o ${sub}=/@ /dev/$root /mnt
#mount -o ${sub}=@ /dev/$root /mnt
# mount -o subvol=/@,defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120 /dev/$root /mnt
mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@ /dev/$root /mnt
 echo ""
 echo " Создания нескольких папок в каталоге /mnt "
 echo " Команда, которая создаёт следующие папки: boot, home, var, var/log, var/cache/pacman/pkg и .snapshots "
mkdir -p /mnt/{boot,home,var,opt,tmp,.snapshots}  # создаёт папки: boot, home, var, var/log, var/cache/pacman/pkg и .snapshots
mkdir -p /mnt/{var/cache,var/cache/pacman/pkg,var/log,var/tmp}
mkdir -p /mnt/{srv,root,usr}
mkdir -p /mnt/usr/local
mkdir -p /mnt/usr/bin
# Создайте /var/lib/machines и /var/lib/portables
# Таким образом, systemd не будет создавать их как вложенные подобъемы
### При наличии виртуальных машин или баз данных рекомендуется отключить копирование при записи (COW).
### CoW - это прочный фундамент, на котором можно строить: Снимки, RAID, Управление томами, Сжатие,Шифрование (возможно, в будущем).
### PostgreSQL — свободная объектно-реляционная система управления базами данных.
### MySQL — реляционная система управления базами данных (СУБД), которая распространяется как свободное программное обеспечение. Разработана шведской компанией MySQL AB, ныне принадлежащей Oracle Corporation.
mkdir -p /mnt/var/lib/{docker,machines,mysql,portables,postgres}
#chattr +C /mnt/var/lib/{docker,machines,mysql,portables,postgres}
# mkdir -p /mnt/var/lib/machines
# mkdir -p /mnt/var/lib/portables
# mkdir -p /mnt/var/lib/postgres
# mkdir -p /mnt/var/lib  # Вместо создания @machines, @portables, @docker можно создать только этот, если в /var/lib не будет храниться чего-то важного (предполагается, что будут делаться снапшоты только корня и/или хомяка)
# mkdir -p /mnt/var/lib/docker
# mkdir -p /mnt/var/lib/docker/btrfs
#chattr +C /var/lib/docker/btrfs
# mkdir -p /mnt/{.swapvol,btrfs}
# mkdir -p /mnt/var/abs
# mkdir -p /mnt/.swapvol
# mkdir -p /mnt/btrfs
### Схематично из archinstall:
# @swap | /swap (не использую swap файл, на перспективу, также выставляю nocow атрибут "chattr +C")
# @log | /var/log (выставляю nocow атрибут "chattr +C")
# @cache | /var/cache (выставляю nocow атрибут "chattr +C")
# @tmp | /var/tmp (выставляю nocow атрибут "chattr +C")
mkdir -p /mnt/var/lib/{libvirt,libvirt/images}
# mkdir -p var/lib/libvirt
# mkdir -p var/lib/libvirt/images
#chattr +C /var/lib/libvirt/images
mkdir -p /mnt/home/.snapshots
ls -la /mnt
sleep 03
 echo ""
 echo " Монтирование папок в каталоге /mnt "
### subvol – Выбор подтома для монтирования
### Монтирование в каталоге /mnt для SSD (Solid-State Drive) - Nvme - m2 - usb_flash #######
#sub='rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,subvol'
#sub='defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol'
#export sub="defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol"
#sub='rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,subvol'
### mount -o defaults,noatime,compress=zstd,commit=120,subvol=@root /dev/sdX /mnt/root
### Монтирование в каталоге /mnt для для HDD (Твердотельные накопитель, Жёсткий диск, винчестер) ####
# mount -o rw,noatime,compress=zstd:2,space_cache=v2,discard=async,subvol=@ /dev/$root /mnt
####### Монтирование @home #######
### Если НЕТ Отдельного раздела HOME (home) - раскомментировать!
### /home – хранит домашние каталоги пользователей, и его разделение может защитить пользовательские данные во время обновлений или переустановок системы.
# mount -o ${sub}=@home /dev/$root /mnt/home
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@home /dev/$root /mnt/home
####### Монтирование @root #######
#mount -o ${sub}=@root /dev/$root /mnt/root
# mount -o subvol=/@root,defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120 /dev/$root /mnt/root
####### Монтирование @srv #######
### /srv – расшифровывается как «service» (сервис). Содержит специфичные для данного сервера данные, предоставляемые через различные сервисы — например, данные и скрипты для веб-серверов, информация, выдаваемая через FTP, и репозитории для систем контроля версий.
mount -o ${sub}=@srv /dev/$root /mnt/srv
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@srv /dev/$root /mnt/srv
####### Монтирование @.snapshots #######
mount -o ${sub}=@.snapshots /dev/$root /mnt/.snapshots
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@.snapshots /dev/$root /mnt/.snapshots
##### ИЛИ Таким спосом для @snapshots ###########
# mount -o ${sub}=/@snapshots /dev/$root /mnt/.snapshots
# mount -o subvol=/@snapshots,defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120 /dev/$root /mnt/.snapshots
######## Дополнительные для @home.snapshots НЕ необязательно Монтировать ##############
# mount -o ${sub}=@home.snapshots /dev/$root  /mnt/home/.snapshots
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@home.snapshots /dev/$root /mnt/home/.snapshots
####### Монтирование @opt #######
### /opt – используется для установки дополнительных пакетов программного обеспечения
#mount -o ${sub}=@opt /dev/$root  /mnt/opt
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@opt /dev/$root /mnt/opt
####### Монтирование @usr #######
### /usr – содержит большинство пользовательских утилит и приложений и часто находится в корневом разделе, но может быть отделен для определенных случаев использования.
#mount -o ${sub}=@usr /dev/$root  /mnt/usr
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@usr /dev/$root /mnt/usr
####### Монтирование @local #######
### /usr/local – каталог для пользовательских программ, установленных из исходников.
#mount -o ${sub}=@local /dev/$root /mnt/usr/local
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@local /dev/$root /mnt/local
####### Монтирование @var #######
### /var – содержит переменные данные, такие как журналы, временные файлы и кэши, которые имеют
#mount -o ${sub}=@var /dev/$root /mnt/var
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@var /dev/$root /mnt/var
####### Монтирование @cache #######
### @cache | /var/cache (выставляю nocow атрибут "chattr +C")
#mount -o ${sub}=@cache /dev/$root /mnt/var/cache
# mount -o subvol=/@cache,defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120 /dev/$root /mnt/var/cache
####### Монтирование @tmp #######
### /tmp – хранит временные файлы, и его изоляция может предотвратить заполнение корневой файловой системы из-за создания временных файлов.
#mount -o ${sub}=@tmp /dev/$root /mnt/var/tmp
# mount -o subvol=/@tmp,defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120 /dev/$root /mnt/var/tmp
####### Монтирование @log #######
### @log | /var/log (выставляю nocow атрибут "chattr +C")
# mount -o ${sub}=/@var_log /dev/$root  /mnt/@var_log
## mount -o ${sub}=/@log /dev/$root  /mnt/log
mount -o ${sub}=@log /dev/$root /mnt/var/log
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@log /dev/$root /mnt/var/log
####### Монтирование @pkg #######
mount -o ${sub}=@pkg /dev/$root /mnt/var/cache/pacman/pkg
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@pkg /dev/$root /mnt/var/cache/pacman/pkg
####### Монтирование @libvirt #######
### /var/lib/libvirt/ — это каталог, в котором хранятся образы жёстких дисков, мгновенные снимки системы и другие данные при использовании гипервизора, например Qemu-KVM.
mount -o ${sub}=@libvirt /dev/$root /mnt/var/lib/libvirt
# mount -o noatime,nodiratime,compress=zstd,commit=120,space_cache,ssd,discard=async,autodefrag,subvol=@libvirt /dev/$root /mnt/var/lib/libvirt
######## НЕ необязательно Монтировать ##############
### Чтобы не заморачиваться я советую использовать Btrfs Asssistant ############
### Подтом @snapshots, @home.snapshots
### Снимки целесообразно "хранить" НЕ внутри того подтома, с которого они были сняты. Так что @ или @home может быть правильным местом для хранения снимков.
####### Монтирование @abs #######
### /abs – ABS (система сборки Arch) Короче говоря, это система порты с чем это считается Архлинукс.
### ABS что позволяет нам «загружать» все PKGBUILDS из пакетов репозиториев Archlinux и изменять их по желанию, например, для добавления или удаления флагов в инструкциях по компиляции, для включения или отключения какой-либо конкретной функции программы. Затем мы собираемся синхронизировать дерево PKGBUILDS официальных репозиториев.
### sudo pacman -S abs  # https://archlinux.org/packages/?sort=&q=abs&maintainer=&flagged=
### mount -o ${sub}=@abs /dev/$root /mnt/mnt/var/abs
### mount -o noatime,nodiratime,compress=zstd,commit=120,space_cache,ssd,discard=async,autodefrag,subvol=@abs /dev/$root /mnt/var/abs
### mount -o subvol=/@abs,defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120 /dev/$root /mnt/var/abs
### mount -o subvol=/@abs,nodev,nosuid,noexec,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120 /dev/$root /mnt/var/abs
###### fstab. Параметры монтирования блочных устройств #########
### https://wiki.nareyko.by/fstab._parametry_montirovanija_blochnyx_ustrojstv
### nodev -  Данная опция предполагает, что на монтируемой файловой системе не будут созданы файлы устройств (/dev). Корневой каталог и целевая директория команды chroot всегда должны монтироваться с опцией dev или defaults.
### nosuid  Запрещает операции с suid и sgid битами.
### noexec - Бинарные файлы не выполняются. Использование опции на корневой системе приведёт к её неработоспособности.
######## Дополнительные НЕ необязательно Монтировать ##############
# mount -o ${sub}=/@machines /dev/$root  /mnt/var/lib/machines
# mount -o ${sub}=/@portables /dev/$root  /mnt/var/lib/portables
# mount -o ${sub}=/@docker /dev/$root  /mnt/var/lib/docker
# mount -o ${sub}=/@docker_btrfs /dev/$root  /mnt/var/lib/docker/btrfs
# mount -o ${sub}=/@var_lib /dev/$root  /mnt/var/lib
####### Монтирование @btrfs #######
# mount -o ${sub}=/@btrfs /dev/$root /mnt/btrfs
# mount -o subvol=/@btrfs,defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvolid=5 /dev/$root /mnt/btrfs
######## Монтировать, если у вас файл swap (@swap) ##############
### @swap | /swap (не использую swap файл, на перспективу, также выставляю nocow атрибут "chattr +C")
# mount -o ${sub}=/@swap /dev/$root  /mnt/swap
# mount -o subvol=/@swap,rw,noatime,ssd,space_cache=v2,discard=async,commit=120 /dev/$root /mnt/swap
##### ИЛИ Таким спосом для @swap ###########
## mount -o ${sub}=@swap /dev/$root  /mnt/var/swap
## mount -o ${sub}=@swap /dev/$root  /mnt/var/lib/swap
### Добавить snap-pac для автоматического резервного копирования до и после установки/удаления/обновления пакетов.
#pacman -S --noconfirm --needed snap-pac  # Хуки Pacman, которые используют Snapper для создания снимков Btrfs до и после, например YaST от OpenSUSE ; https://archlinux.org/packages/extra/any/snap-pac/ ; https://github.com/wesbarnett/snap-pac ; 2024-07-01 08:11 UTC
### Это набор хуков и скрипта Pacman , которые автоматически заставляют Snapper делать снимки состояния до и после транзакций Pacman, аналогично тому, как это делает YaST в OpenSuse. Это обеспечивает простой способ отмены изменений в системе после транзакции Pacman. Более подробную информацию смотрите в документации (https://wesbarnett.github.io/snap-pac/).
### Предотвращение замедления снимков
#echo  ' PRUNENAMES = ".snapshots" '  >> /etc/updatedb.conf
 echo ""
 echo " Монтирование папок (каталогов) в каталоге /mnt завершено "
 echo " Раздел создан и готов к работе "
sleep 01
elif [[ $in_mounts == 2 ]]; then
 echo ""
 echo " Монтирование ROOT- БЕЗ HOME (home) раздела "
 echo " Монтирование ROOT раздела в /mnt - каталог для ручного монтирования файловых систем "
mount /dev/$root /mnt  # Монтирование в /mnt ; /mnt - каталог для ручного монтирования файловых систем
echo ""
 echo " Узнать тип смонтированной файловой системы "
df -h
mount | grep -E /dev/$root  # Чтобы узнать тип смонтированной файловой системы
# mount | grep /dev/$root
# mount | grep btrfs  # отображать только файловые системы Btrfs
sleep 03
 echo ""
 echo " Создаем подразделы (Subvolume /@) на смонтированном btrfs разделе в каталоге /mnt "
# btrfs subvolume create /mnt/root
# btrfs subvolume set-default /mnt/root
### Команда btrfs subvolume set-default /mnt/root — это команда для файловой системы Btrfs, которая устанавливает сабвольюм (subvolume) по умолчанию для монтирования файловой системы. Это позволяет: Скрыть сабвольюм верхнего уровня (тот, который монтируется с параметром subvol=/ или subvolid=5). Указать сабвольюм — можно указать его по ID или по пути. ID сабвольюма можно получить с помощью команд btrfs subvolume list, btrfs subvolume show или btrfs inspect-internal rootid. Синтаксис: Команда btrfs subvolume set-default [<subvolume>|<id> <path>].
### Важно: при установке дефолтного сабвольюма нужно указать место, где он монтируется (в данном случае — /mnt). Если не указать путь, btrfs прочитает из специальной записи ID сабвольюма, который необходимо монтировать по умолчанию, и не изменит его.
## su = подтом ; cr = создать
### btrfs su cr - псевдоним для btrfs subvolume create. Название подразделов начинаются с @ чтобы не путать их с другими каталогами.
### Я бы предложил по крайней мере один подтом для корня (@) и один для снимков (@snapshots). varlog и tmp созданы для простого отключения копирования при записи на /var/log и /tmp.
######### Или этот Вариант ##########
### Перейдём в каталог /mnt
# cd /mnt
btrfs subvolume create /mnt/@             # @ — Это основной корневой подтом /
btrfs subvolume create /mnt/@home         # @home - Домашний подтом
#btrfs subvolume create /mnt/@root        # @root — Корневой подтом
#btrfs subvolume create /mnt/@var         # @var — Журналы, некоторые временные файлы, кэши и т. д.
btrfs subvolume create /mnt/@log          # @log — Журналы работы утилит, некоторые временные файлы
# btrfs su cr /mnt/@var_log               # @var_log или просто @log — Логи как правило не представляют интереса, но в снапшотах занимают дополнительное место.
#btrfs subvolume create /mnt/@opt         # @opt — Каталог, в котором размещаются стороннее программное обеспечение и пакеты
btrfs subvolume create /mnt/@pkg          # @pkg — Каталог, в который утилита makepkg помещает скомпилированные файлы
#btrfs subvolume create /mnt/@tmp         # @tmp — Основное расположение временных файлов
#btrfs subvolume create /mnt/@cache       # @cache — Это кэш пакетного менеджера (pacman)
btrfs subvolume create /mnt/@.snapshots   # @snapshots – Каталог для хранения снимков.
# btrfs su cr /mnt/@snapshots             # @snapshots — Snapper будет хранить здесь ваши снимки BTRFS. Если Snapper не используется, этот раздел не нужен. Содержит снапшоты корня, которые создает snapper.
### Подтома @machines, @portables, @.snapshots, @home.snapshots и @docker (опционально при использовании docker) нужны чтобы не заморачиваться с переносом вложенных подтомов при замене старого подтома на снапшот. Однако, вся эта плоская структура подтомов скорее нужна на серверах. Чтобы не заморачиваться я советую использовать Btrfs Asssistant.
#btrfs subvolume create /mnt/@home.snapshots      # @home.snapshots — Содержит снапшоты хомяка, которые создает snapper
btrfs subvolume create /mnt/@srv                  # @srv — это SRV-запись (Service Record), которая является типом записи в системе доменных имен (DNS) и указывает на местоположение (имя хоста и номер порта) серверов, предоставляющих определенные службы в сети. Эта запись помогает клиентам находить нужный сервер для конкретной службы, такой как IMAP или SIP, вместо того чтобы запоминать IP-адреса и порты вручную.
## btrfs subvolume create /mnt/@btrfs             # @btrfs - Стандартно это служебный подтом (ID=5)
# btrfs subvolume create /mnt/@machines           # Если не существует, то создаст systemd
# btrfs subvolume create /mnt/@portables          # Если не существует, то создаст systemd
# btrfs subvolume create /mnt/@docker             # Рекомендации самого Docker с их сайта
# btrfs subvolume create /mnt/@docker_btrfs       # Docker создает саьвольюмы по этому пути
#btrfs subvolume create /mnt/@usr                 # @usr — содержит большинство пользовательских утилит и приложений и часто находится в корневом разделе, но может быть отделен для определенных случаев использования.
#btrfs subvolume create /mnt/@local               # @local — служит для локально собираемых программ
# btrfs subvolume create /mnt/@var_lib            # Вместо создания @machines, @portables, @docker можно создать только этот, если в /var/lib не будет храниться чего-то важного (предполагается, что будут делаться снапшоты только корня и/или хомяка)
## btrfs subvolume create /mnt/@swap              # @swap — Хранит файл подкачки. Должен монтироваться с nodatacow
## btrfs subvolume create /mnt/@abs               # @abs — позволяет нам «загружать» все PKGBUILDS из пакетов репозиториев Archlinux
btrfs subvolume create /mnt/@libvirt              # @libvirt — это каталог, в котором хранятся образы жёстких дисков, мгновенные снимки системы и другие данные при использовании гипервизора, например Qemu-KVM.
### Удаление подтома:
# https://btrfs.readthedocs.io/en/latest/btrfs-subvolume.html
# btrfs subvolume delete /mnt/ <Название,наименование>
### Подтом btrfs возвращает нулевой код завершения в случае успешного завершения. В случае неудачи возвращается ненулевое значение.
# https://btrfs.readthedocs.io/en/latest/btrfs-subvolume.html#man-subvolume-set-default
 echo ""
 echo " Проверка создания томов в /mnt "
btrfs subvolume list /mnt  # li = список
# btrfs sub list /mnt
# cat /etc/fstab
sleep 03
#echo ""
#echo " Отключить копирование при записи /var/log и /tmp "
#chattr +C /mnt/@var
#chattr +C /mnt/@log  # (выставляю nocow атрибут "chattr +C")
#chattr +C /mnt/@cache  #  (выставляю nocow атрибут "chattr +C")
# chattr +C /mnt/@varlog
#chattr +C /mnt/@tmp
# chattr +C /mnt/@swap  # (не использую swap файл, на перспективу, также выставляю nocow атрибут "chattr +C")
### Теперь выйдем из каталога mnt и отмонтируем наш массив командой:
# cd ..
 echo ""
 echo " Размонтируем (отмонтируем) корневой раздел смонтированный в каталоге /mnt "
### umount --help  # -h, --help ; отобразите эту справку и выйдите ; https://github.com/dsw0214/linux-commands/blob/master/umount.md
# umount /mnt   # — размонтирует все файловые системы, примонтированные к /mnt
umount -R /mnt  # -R, --recursive ; рекурсивно размонтировать целевой объект со всеми его дочерними элементами
 echo " Размонтирование смонтированного корневого раздела выполнено "
sleep 01
#clear
 echo ""
 echo " Смонтировать root раздел как подтома... "
####### Монтирование @ #######
mount -o ${sub}=@ /dev/$root /mnt
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@ /dev/$root /mnt
 echo ""
 echo " Создания нескольких папок в каталоге /mnt "
 echo " Команда, которая создаёт следующие папки: boot, home, var, var/log, var/cache/pacman/pkg и .snapshots "
mkdir -p /mnt/{boot,home,var,opt,tmp,.snapshots}  # создаёт папки: boot, home, var, var/log, var/cache/pacman/pkg и .snapshots
mkdir -p /mnt/{var/cache,var/cache/pacman/pkg,var/log,var/tmp}
mkdir -p /mnt/{srv,root,usr}
mkdir -p /mnt/usr/local
mkdir -p /mnt/usr/bin
# Создайте /var/lib/machines и /var/lib/portables
# Таким образом, systemd не будет создавать их как вложенные подобъемы
### При наличии виртуальных машин или баз данных рекомендуется отключить копирование при записи (COW).
### CoW - это прочный фундамент, на котором можно строить: Снимки, RAID, Управление томами, Сжатие,Шифрование (возможно, в будущем).
### PostgreSQL — свободная объектно-реляционная система управления базами данных.
### MySQL — реляционная система управления базами данных (СУБД), которая распространяется как свободное программное обеспечение. Разработана шведской компанией MySQL AB, ныне принадлежащей Oracle Corporation.
mkdir -p /mnt/var/lib/{docker,machines,mysql,portables,postgres}
#chattr +C /mnt/var/lib/{docker,machines,mysql,portables,postgres}
# mkdir -p /mnt/var/lib/machines
# mkdir -p /mnt/var/lib/portables
# mkdir -p /mnt/var/lib/postgres
# mkdir -p /mnt/var/lib  # Вместо создания @machines, @portables, @docker можно создать только этот, если в /var/lib не будет храниться чего-то важного (предполагается, что будут делаться снапшоты только корня и/или хомяка)
# mkdir -p /mnt/var/lib/docker
# mkdir -p /mnt/var/lib/docker/btrfs
#chattr +C /var/lib/docker/btrfs
# mkdir -p /mnt/{.swapvol,btrfs}
# mkdir -p /mnt/var/abs
# mkdir -p /mnt/.swapvol
# mkdir -p /mnt/btrfs
### Схематично из archinstall:
# @swap | /swap (не использую swap файл, на перспективу, также выставляю nocow атрибут "chattr +C")
# @log | /var/log (выставляю nocow атрибут "chattr +C")
# @cache | /var/cache (выставляю nocow атрибут "chattr +C")
# @tmp | /var/tmp (выставляю nocow атрибут "chattr +C")
mkdir -p /mnt/var/lib/{libvirt,libvirt/images}
# mkdir -p var/lib/libvirt
# mkdir -p var/lib/libvirt/images
#chattr +C /var/lib/libvirt/images
mkdir -p /mnt/home/.snapshots
ls -la /mnt
sleep 03
 echo ""
 echo " Монтирование папок в каталоге /mnt "
### subvol – Выбор подтома для монтирования
### Монтирование в каталоге /mnt для SSD (Solid-State Drive) - Nvme - m2 - usb_flash #######
#sub='rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,subvol'
#sub='defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol'
#export sub="defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol"
#sub='rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,subvol'
### mount -o defaults,noatime,compress=zstd,commit=120,subvol=@root /dev/sdX /mnt/root
### Монтирование в каталоге /mnt для для HDD (Твердотельные накопитель, Жёсткий диск, винчестер) ####
# mount -o rw,noatime,compress=zstd:2,space_cache=v2,discard=async,subvol=@ /dev/$root /mnt
####### Монтирование @home #######
### Если НЕТ Отдельного раздела HOME (home) - раскомментировать!
### /home – хранит домашние каталоги пользователей, и его разделение может защитить пользовательские данные во время обновлений или переустановок системы.
mount -o ${sub}=@home /dev/$root /mnt/home
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@home /dev/$root /mnt/home
####### Монтирование @root #######
#mount -o ${sub}=@root /dev/$root /mnt/root
# mount -o subvol=/@root,defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120 /dev/$root /mnt/root
####### Монтирование @srv #######
### /srv – расшифровывается как «service» (сервис). Содержит специфичные для данного сервера данные, предоставляемые через различные сервисы — например, данные и скрипты для веб-серверов, информация, выдаваемая через FTP, и репозитории для систем контроля версий.
mount -o ${sub}=@srv /dev/$root /mnt/srv
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@srv /dev/$root /mnt/srv
####### Монтирование @.snapshots #######
mount -o ${sub}=@.snapshots /dev/$root /mnt/.snapshots
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@.snapshots /dev/$root /mnt/.snapshots
##### ИЛИ Таким спосом для @snapshots ###########
# mount -o ${sub}=/@snapshots /dev/$root /mnt/.snapshots
# mount -o subvol=/@snapshots,defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120 /dev/$root /mnt/.snapshots
######## Дополнительные для @home.snapshots НЕ необязательно Монтировать ##############
# mount -o ${sub}=@home.snapshots /dev/$root  /mnt/home/.snapshots
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@home.snapshots /dev/$root /mnt/home/.snapshots
####### Монтирование @opt #######
### /opt – используется для установки дополнительных пакетов программного обеспечения
#mount -o ${sub}=@opt /dev/$root  /mnt/opt
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@opt /dev/$root /mnt/opt
####### Монтирование @usr #######
### /usr – содержит большинство пользовательских утилит и приложений и часто находится в корневом разделе, но может быть отделен для определенных случаев использования.
#mount -o ${sub}=@usr /dev/$root  /mnt/usr
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@usr /dev/$root /mnt/usr
####### Монтирование @local #######
### /usr/local – каталог для пользовательских программ, установленных из исходников.
#mount -o ${sub}=@local /dev/$root /mnt/usr/local
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@local /dev/$root /mnt/local
####### Монтирование @var #######
### /var – содержит переменные данные, такие как журналы, временные файлы и кэши, которые имеют
#mount -o ${sub}=@var /dev/$root /mnt/var
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@var /dev/$root /mnt/var
####### Монтирование @cache #######
### @cache | /var/cache (выставляю nocow атрибут "chattr +C")
#mount -o ${sub}=@cache /dev/$root /mnt/var/cache
# mount -o subvol=/@cache,defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120 /dev/$root /mnt/var/cache
####### Монтирование @tmp #######
### /tmp – хранит временные файлы, и его изоляция может предотвратить заполнение корневой файловой системы из-за создания временных файлов.
#mount -o ${sub}=@tmp /dev/$root /mnt/var/tmp
# mount -o subvol=/@tmp,defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120 /dev/$root /mnt/var/tmp
####### Монтирование @log #######
### @log | /var/log (выставляю nocow атрибут "chattr +C")
# mount -o ${sub}=/@var_log /dev/$root  /mnt/@var_log
## mount -o ${sub}=/@log /dev/$root  /mnt/log
mount -o ${sub}=@log /dev/$root /mnt/var/log
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@log /dev/$root /mnt/var/log
####### Монтирование @pkg #######
mount -o ${sub}=@pkg /dev/$root /mnt/var/cache/pacman/pkg
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvol=@pkg /dev/$root /mnt/var/cache/pacman/pkg
####### Монтирование @libvirt #######
### /var/lib/libvirt/ — это каталог, в котором хранятся образы жёстких дисков, мгновенные снимки системы и другие данные при использовании гипервизора, например Qemu-KVM.
mount -o ${sub}=@libvirt /dev/$root /mnt/var/lib/libvirt
# mount -o noatime,nodiratime,compress=zstd,commit=120,space_cache,ssd,discard=async,autodefrag,subvol=@libvirt /dev/$root /mnt/var/lib/libvirt
######## НЕ необязательно Монтировать ##############
### Чтобы не заморачиваться я советую использовать Btrfs Asssistant ############
### Подтом @snapshots, @home.snapshots
### Снимки целесообразно "хранить" НЕ внутри того подтома, с которого они были сняты. Так что @ или @home может быть правильным местом для хранения снимков.
####### Монтирование @abs #######
### /abs – ABS (система сборки Arch) Короче говоря, это система порты с чем это считается Архлинукс.
### ABS что позволяет нам «загружать» все PKGBUILDS из пакетов репозиториев Archlinux и изменять их по желанию, например, для добавления или удаления флагов в инструкциях по компиляции, для включения или отключения какой-либо конкретной функции программы. Затем мы собираемся синхронизировать дерево PKGBUILDS официальных репозиториев.
### sudo pacman -S abs  # https://archlinux.org/packages/?sort=&q=abs&maintainer=&flagged=
### mount -o ${sub}=@abs /dev/$root /mnt/mnt/var/abs
### mount -o noatime,nodiratime,compress=zstd,commit=120,space_cache,ssd,discard=async,autodefrag,subvol=@abs /dev/$root /mnt/var/abs
### mount -o subvol=/@abs,defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120 /dev/$root /mnt/var/abs
### mount -o subvol=/@abs,nodev,nosuid,noexec,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120 /dev/$root /mnt/var/abs
###### fstab. Параметры монтирования блочных устройств #########
### https://wiki.nareyko.by/fstab._parametry_montirovanija_blochnyx_ustrojstv
### nodev -  Данная опция предполагает, что на монтируемой файловой системе не будут созданы файлы устройств (/dev). Корневой каталог и целевая директория команды chroot всегда должны монтироваться с опцией dev или defaults.
### nosuid  Запрещает операции с suid и sgid битами.
### noexec - Бинарные файлы не выполняются. Использование опции на корневой системе приведёт к её неработоспособности.
######## Дополнительные НЕ необязательно Монтировать ##############
# mount -o ${sub}=/@machines /dev/$root  /mnt/var/lib/machines
# mount -o ${sub}=/@portables /dev/$root  /mnt/var/lib/portables
# mount -o ${sub}=/@docker /dev/$root  /mnt/var/lib/docker
# mount -o ${sub}=/@docker_btrfs /dev/$root  /mnt/var/lib/docker/btrfs
# mount -o ${sub}=/@var_lib /dev/$root  /mnt/var/lib
####### Монтирование @btrfs #######
# mount -o ${sub}=/@btrfs /dev/$root /mnt/btrfs
# mount -o subvol=/@btrfs,defaults,rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120,subvolid=5 /dev/$root /mnt/btrfs
######## Монтировать, если у вас файл swap (@swap) ##############
### @swap | /swap (не использую swap файл, на перспективу, также выставляю nocow атрибут "chattr +C")
# mount -o ${sub}=/@swap /dev/$root  /mnt/swap
# mount -o subvol=/@swap,rw,noatime,ssd,space_cache=v2,discard=async,commit=120 /dev/$root /mnt/swap
##### ИЛИ Таким спосом для @swap ###########
## mount -o ${sub}=@swap /dev/$root  /mnt/var/swap
## mount -o ${sub}=@swap /dev/$root  /mnt/var/lib/swap
### Добавить snap-pac для автоматического резервного копирования до и после установки/удаления/обновления пакетов.
# sudo pacman --noconfirm -S snap-pac
#pacman -S --noconfirm --needed snap-pac  # Хуки Pacman, которые используют Snapper для создания снимков Btrfs до и после, например YaST от OpenSUSE ; https://archlinux.org/packages/extra/any/snap-pac/ ; https://github.com/wesbarnett/snap-pac ; 2024-07-01 08:11 UTC
### Это набор хуков и скрипта Pacman , которые автоматически заставляют Snapper делать снимки состояния до и после транзакций Pacman, аналогично тому, как это делает YaST в OpenSuse. Это обеспечивает простой способ отмены изменений в системе после транзакции Pacman. Более подробную информацию смотрите в документации (https://wesbarnett.github.io/snap-pac/).
### Предотвращение замедления снимков
#echo  ' PRUNENAMES = ".snapshots" '  >> /etc/updatedb.conf
 echo ""
 echo " Монтирование папок (каталогов) в каталоге /mnt завершено "
 echo " Раздел создан и готов к работе "
### Ключевые каталоги включают:
# /home — для личных файлов пользователя,
# /etc — для системных настроек,
# /usr/bin — для основных пользовательских команд (исторически — /bin),
# /tmp — для временных файлов.
### Такая организация делает систему Linux аккуратной, безопасной и единообразной на всех компьютерах.
sleep 01
fi
fi
########## Boot  ########
### Install Arch Linux on Legacy BIOS with MBR - https://www.youtube.com/watch?v=smdZdPLHjWc
clear
echo ""
echo -e "${BLUE}:: ${NC}*Ваша разметка диска "
echo -e "${CYAN}:: ${NC}Посмотрите вывод списка всех блочных устройств "
echo ""
lsblk -f  # Команда lsblk выводит список всех блочных устройств
#fdisk -l  # Посмотрим список доступных (созданных) дисков и разделов
echo ""
echo -e "${GREEN}==> ${NC}Форматируем BOOT- (Загрузочный) раздел? "
echo " Если таковой был создан при разметке в cfdisk "
echo " Либо BOOT был создан вами заранее и готов к дальнейшим действиям "
echo " Или ваш BOOT раздел будет находится (расположен) в ROOT ( / корневом ) разделе системы "
echo " BOOT (/boot) — Это ВАШ загрузочный раздел будет отформатирован в ( Ext2 ), ( Ext4 ) или (FAT32)(vfat) "
echo " Выберите файловую систему для вашего загрузочного раздела BOOT "
echo " *В сценарии (скрипта) прописаны следующие варианты: "
echo -e "${YELLOW} Внимание! ${BOLD} *Для установки в раздел DOS/MBR или Bios ${NC}"
echo -e "${CYAN}:: ${NC}Проще говоря — Для обычного Bios форматировать нужно в Ext2 или Ext4 "
echo " Форматировать BOOT- раздел в файловую систему Ext2 , то введите: 1 "
echo " Форматировать BOOT- раздел в файловую систему Ext4 , то введите: 2 "
echo -e "${YELLOW} Внимание! ${BOLD} *Для установки в UEFI (Unified Extensible Firmware Interface) ${NC}"
echo -e "${CYAN}:: ${NC}UEFI заменяет традиционный BIOS на PC (Поддержка GPT) — форматировать нужно в FAT32 (vfat) "
echo " Форматировать BOOT- раздел в файловую систему FAT32 , то введите: 3 "
echo -e "${YELLOW} Внимание! ${BOLD} *Если вы не создавали отдельный BOOT раздел и он будет расположен в / ROOT ${NC}"
echo -e "${YELLOW} Примечание! ${BOLD} *Для установки в один раздел DOS/MBR или рядом с Windows ${NC}"
echo -e "${CYAN}:: ${NC}Просто пропустите действие форматирование и введите: 0 "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс форматирования был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Форматировать boot в Ext2,    2 - Форматировать boot в Ext4,

    3 - Форматировать boot в FAT32,   0 - НЕ Форматировать (пропустить): " boots  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$boots" =~ [^1230] ]]
do
    :
done
if [[ $boots == 0 ]]; then
 echo ""
 echo " Форматирование и монтирование не требуется "
sleep 01
elif [[ $boots == 1 ]]; then
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите BOOT раздел (sda/sdb 1.2.3.4 (sda5 например)): "  bootd  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
 echo ""
 echo " Создадим файловую систему Ext2 для загрузочного раздела "
# mkfs.ext2  /dev/$bootd -L boot   # или - mkfs.ext2  /dev/$bootd -L archboot
mkfs -t ext2 -L boot /dev/$bootd  # Параметр -t (или --type) указывает тип создаваемой файловой системы. Если этот параметр не указан, то по умолчанию принимается тип ext2 . mkfs используется для создания файловой системы на блочном устройстве, таком как жёсткий диск или флэш-накопитель.
 echo ""
 echo " Создания папки boot в каталоге /mnt "
# Используем более закрытые права на каталог
# mkdir -m 700 /mnt/boot  # права доступа (и флаг исполнения для каталога)
# mkdir -m 700 -p /mnt/boot  # права доступа (и флаг исполнения для каталога)
# mkdir /mnt/boot
mkdir -p /mnt/boot  # mkdir -p НЕ выдаст ошибку, если каталог уже существует и его содержимое не изменится.
 echo ""
 echo " Монтирование BOOT- раздела в /mnt/boot "
mount /dev/$bootd /mnt/boot
# mount -o defaults,noatime /mnt/boot
mount -l -t ext2  # Просмотреть все смонтированные разделы определенного типа
sleep 01
 echo ""
 echo " Форматирование и монтирование выполнено "
sleep 01
elif [[ $boots == 2 ]]; then
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите BOOT раздел (sda/sdb 1.2.3.4 (sda5 например)): "  bootd  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
 echo ""
 echo " Создадим файловую систему Ext4 для загрузочного раздела "
# mkfs.ext4 -O \^64bit /dev/$bootd -L boot  # -O - активировать или деактивировать те или иные возможности файловой системы. Сами возможности мы рассмотрим ниже; 64bit - файловая система сможет занимать место больше чем 2 в 32 степени блоков. При размере блока 4 килобайта, это примерно один терабайт;
mkfs.ext4  /dev/$bootd -L boot   # или - mkfs.ext4  /dev/$bootd -L archboot
 echo ""
 echo " Создания папки boot в каталоге /mnt "
# Используем более закрытые права на каталог
# mkdir -m 700 /mnt/boot # права доступа (и флаг исполнения для каталога)
# mkdir /mnt/boot
mkdir -p /mnt/boot  # mkdir -p НЕ выдаст ошибку, если каталог уже существует и его содержимое не изменится.
 echo ""
 echo " Монтирование BOOT- раздела в /mnt/boot "
mount /dev/$bootd /mnt/boot
# mount -o defaults,noatime /mnt/boot
mount -l -t ext4  # Просмотреть все смонтированные разделы определенного типа
sleep 01
 echo ""
 echo " Форматирование и монтирование выполнено "
sleep 01
elif [[ $boots == 3 ]]; then
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите BOOT раздел (sda/sdb 1.2.3.4 (sda5 например)): "  bootd  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
 echo ""
 echo " Создадим файловую систему FAT32 для загрузочного раздела "
mkfs.vfat -F32 /dev/$bootd -L boot   # или - mkfs.vfat -F32 /dev/$bootd -L archboot
# mkfs -t vfat /dev/$bootd -L boot  # Для диска формата файловой системы FAT32
 echo ""
 echo " Создания папки boot в каталоге /mnt "
# Используем более закрытые права на каталог
# mkdir -m 700 /mnt/boot/efi  # права доступа (и флаг исполнения для каталога)
# mkdir /mnt/boot
# mkdir -p /mnt/boot  # mkdir -p НЕ выдаст ошибку, если каталог уже существует и его содержимое не изменится.
mkdir -p  /mnt/boot/efi  # Команда создает каталог и все необходимые родительские каталоги
 echo ""
 echo " Монтирование BOOT- раздела в /mnt/boot "
#  mount /dev/$bootd /mnt/boot
mount /dev/$bootd /mnt/boot/efi
# mount -o defaults,noatime /mnt/boot/efi
mount -l -t vfat  # Просмотреть все смонтированные разделы определенного типа
### Параметр «-l» позволяет получить список дисков и разделов на них в системе. Параметр «-t» указывает тип файловой системы, в данном случае это vfat, что соответствует FAT32 (также обозначается как WIN95).
sleep 01
# mount --mkdir /dev/$bootd /mnt/boot  # Для систем UEFI смонтируйте системный раздел EFI
### Запустите mount (https://man.archlinux.org/man/mount.8) с --mkdir возможностью создания указанной точки монтирования. В качестве альтернативы, создайте её заранее с помощью mkdir (https://man.archlinux.org/man/mkdir.1) .
 echo ""
 echo " Форматирование и монтирование выполнено "
sleep 01
fi
########## Swap  ########
clear
echo ""
echo -e "${BLUE}:: ${NC}*Ваша разметка диска "
echo -e "${CYAN}:: ${NC}Посмотрите вывод списка всех блочных устройств "
echo ""
lsblk -f  # Команда lsblk выводит список всех блочных устройств
#fdisk -l  # Посмотрим список доступных (созданных) дисков и разделов
echo ""
echo -e "${GREEN}==> ${NC}Форматируем Swap- (Подкачка) раздел? "
echo " Если таковой был создан при разметке в cfdisk "
echo " Либо у вас достаточно ОЗУ или вы захотите создать просто файл подкачки "
echo " SWAP (linux-swap) — Это ВАШ раздел подкачки (ЕСЛИ таковой был создан при разметке!) "
echo -e "${YELLOW}==> Примечание! ${BOLD}*Swap — может быть как отдельным разделом диска, так и обычным файлом. Используются исключительно для создания виртуальной памяти. Виртуальная память необходима в случае нехватки основной памяти (ОЗУ), однако скорость работы при использовании такой памяти значительно уменьшается. Swap необходим для компьютеров с малым объемом памяти, в этом случае рекомендуется создать swap-раздел или файл размером в 2-4 раза больше, чем ОЗУ компьютера. Также swap необходим для перехода в режим сна, в этом случае необходимо выделить объем памяти равный ОЗУ компьютера или чуть больше. ${NC}"
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс форматирования был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
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
echo ""
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
 echo ""
 echo " Посмотрим тип файловой системы и точку монтирования "
lsblk --fs /dev/$swaps  # опции --fs: Отображает тип файловой системы (FSTYPE), метку (LABEL), UUID и точку монтирования (если применимо) для каждого блочного устройства. Синтаксис: lsblk [опции] [устройство]. Опция --fs — одна из основных опций команды lsblk, которая выводит список блочных устройств в виде дерева.
sleep 03
# mkswap  # Посмотреть UUID раздела
### mkswap — настройка области подкачки Linux  https://man.archlinux.org/man/mkswap.8
# swapon-summary  # После запуска swapon вы можете проверить, какие области пространства подкачки используются
# sleep 01
elif [[ $swap == 0 ]]; then
 echo ""
 echo " Добавление Swap раздела пропущено "
fi
########## Home  ########
clear
echo ""
echo -e "${BLUE}:: ${NC}*Ваша разметка диска "
echo -e "${CYAN}:: ${NC}Посмотрите вывод списка всех блочных устройств "
echo ""
lsblk -f  # Команда lsblk выводит список всех блочных устройств
#fdisk -l  # Посмотрим список доступных (созданных) дисков и разделов
echo ""
echo -e "${GREEN}==> ${NC}Добавим HOME- (Домашний) раздел? "
echo " Если таковой был создан при разметке в cfdisk "
echo " Либо HOME был создан вами заранее и готов к дальнейшим действиям "
echo " Или ваш HOME раздел будет находится (расположен) в ROOT ( / корневом ) разделе системы? "
echo " HOME (/home) —  Это ВАШ домашний раздел, он будет отформатирован в файловые системы ( Ext4 ), ( XFS ), ( F2fs ) или ( JFS ) по вашему выбору в дальнейшем. "
echo -e "${CYAN}=> ${NC}Можно использовать раздел от предыдущей системы (и его не форматировать)! "
echo -e "${YELLOW}==> Примечание! ${BOLD}*Далее в процессе установки в сценарии будет Пункт, в котором можно будет удалить все скрытые файлы и папки в каталоге пользователя "home/USERNAME" (от предыдущей системы). ${NC}"
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Если вы Хотите (очень) установить файловую систему Btrfs для HOME- (Домашнего) раздела, функция форматирования и монтирования с Btrfs — Будет представлена дальше в сценарии (скрипта), здесь просто пропустите действие Форматирования в этих представленных файловых системах! ${NC}"
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс форматирования был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Форматировать home в Ext4,     2 - Форматировать home в XFS,

    3 - Форматировать home в F2fs,     4 - Форматировать home в JFS,

    0 - НЕ Форматировать (пропустить): " homes  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$homes" =~ [^12340] ]]
do
    :
done
if [[ $homes == 0 ]]; then
 echo ""
 echo " Форматирование и монтирование не требуется "
sleep 01
elif [[ $homes == 1 ]]; then
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите HOME раздел (sda/sdb 1.2.3.4 (sda5 например)): " home  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
 echo ""
 echo " Создадим файловую систему Ext4 для домашнего раздела "

mkfs.ext4 /dev/$home -L home  # или - mkfs.ext4 /dev/$home -L archhome
 echo ""
 echo " Создания папки home в каталоге /mnt "
# mkdir /mnt/boot
# mkdir /mnt/home
mkdir -p /mnt/home  # Команда создает каталог и все необходимые родительские каталоги
# mkdir /mnt/{boot,home}
 echo ""
 echo " Смонтируем home (домашний) раздел в /mnt "
# mount -o noatime,commit=120 /dev/$home /mnt/home
### Noatime – по сути, повышает производительность, не записывая время последнего доступа к файлу. commit – время в секундах, необходимое для синхронизации данных с хранилищем, здесь установлено значение 120 секунд, поэтому в случае отключения питания или сбоя любые данные за последние 2 минуты, скорее всего, будут утеряны; вы можете свободно изменить это значение.
mount /dev/$home /mnt/home  # Монтирование в /mnt ; /mnt - каталог для ручного монтирования файловых систем
 echo ""
 echo " Посмотрим тип файловой системы и точку монтирования "
lsblk --fs /dev/$home  # опции --fs: Отображает тип файловой системы (FSTYPE), метку (LABEL), UUID и точку монтирования (если применимо) для каждого блочного устройства. Синтаксис: lsblk [опции] [устройство]. Опция --fs — одна из основных опций команды lsblk, которая выводит список блочных устройств в виде дерева.
sleep 03
 echo ""
 echo " Форматирование и монтирование выполнено "
sleep 01
elif [[ $homes == 2 ]]; then
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите HOME раздел (sda/sdb 1.2.3.4 (sda5 например)): " home  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo ""
echo " Создадим файловую систему XFS для домашнего раздела "
# mkfs.xfs /dev/$home -L home  # или - mkfs.xfs /dev/$home -L $home -L archhome
# mkfs.xfs -f /dev/$home  # Принудительное создание файловой системы XFS поверх любой существующей. Это опция команды mkfs.xfs (из пакета xfsprogs). Опция -f (от force) нужна, если на указанном разделе уже существует файловая система другого типа, и нужно её перезаписать.
### *При использовании mkfs.xfs на блочном устройстве, содержащем существующую файловую систему, добавьте опцию -f для перезаписи этой файловой системы. Эта операция уничтожит все данные, содержащиеся в предыдущей файловой системе.
mkfs.xfs -f /dev/$home -L home  # При использовании mkfs.xfs на блочном устройстве
# echo 'y' | mkfs.xfs -f /dev/$home -L home  # Форматировать XFS
### В целом, параметры по умолчанию оптимальны для обычного использования: meta-data=/dev/device
# meta-data=/dev/$home
 echo ""
 echo " Создания папки home в каталоге /mnt "
# mkdir /mnt/boot
# mkdir /mnt/home
mkdir -p /mnt/home  # Команда создает каталог и все необходимые родительские каталоги
# mkdir /mnt/{boot,home}
 echo ""
 echo " Смонтируем home (домашний) раздел в /mnt "
mount /dev/$home /mnt/home  # Монтирование в /mnt ; /mnt - каталог для ручного монтирования файловых систем
 echo ""
 echo " Посмотрим тип файловой системы и точку монтирования "
lsblk --fs /dev/$home  # опции --fs: Отображает тип файловой системы (FSTYPE), метку (LABEL), UUID и точку монтирования (если применимо) для каждого блочного устройства. Синтаксис: lsblk [опции] [устройство]. Опция --fs — одна из основных опций команды lsblk, которая выводит список блочных устройств в виде дерева.
sleep 03
 echo ""
 echo " Форматирование и монтирование выполнено "
sleep 01
elif [[ $homes == 3 ]]; then
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите HOME раздел (sda/sdb 1.2.3.4 (sda5 например)): " home  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
 echo ""
 echo " Создадим файловую систему F2fs для домашнего раздела "
### # mkfs.f2fs -l mylabel -O extra_attr,inode_checksum,sb_checksum /dev/sdxY
mkfs.f2fs -f /dev/$home -L home  # или - mkfs.f2fs -f /dev/$home -L archhome
 echo ""
 echo " Создания папки home в каталоге /mnt "
# mkdir /mnt/boot
# mkdir /mnt/home
mkdir -p /mnt/home  # Команда создает каталог и все необходимые родительские каталоги
# mkdir /mnt/{boot,home}
 echo ""
 echo " Смонтируем home (домашний) раздел в /mnt "
mount /dev/$home /mnt/home  # Монтирование в /mnt ; /mnt - каталог для ручного монтирования файловых систем
 echo ""
 echo " Посмотрим тип файловой системы и точку монтирования "
lsblk --fs /dev/$home  # опции --fs: Отображает тип файловой системы (FSTYPE), метку (LABEL), UUID и точку монтирования (если применимо) для каждого блочного устройства. Синтаксис: lsblk [опции] [устройство]. Опция --fs — одна из основных опций команды lsblk, которая выводит список блочных устройств в виде дерева.
sleep 03
 echo ""
 echo " Форматирование и монтирование выполнено "
sleep 01
elif [[ $homes == 4 ]]; then
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите HOME раздел (sda/sdb 1.2.3.4 (sda5 например)): " home  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
 echo ""
 echo " Создадим файловую систему JFS для домашнего раздела "
### Файловую систему JFS можно создать с помощью: mkfs.jfs /dev/target_dev или: jfs_mkfs /dev/target_dev
mkfs.jfs -f /dev/$home -L home  # или - mkfs.jfs -f /dev/$home -L archhome
 echo ""
 echo " Создания папки home в каталоге /mnt "
# mkdir /mnt/boot
# mkdir /mnt/home
mkdir -p /mnt/home  # Команда создает каталог и все необходимые родительские каталоги
# mkdir /mnt/{boot,home}
 echo ""
 echo " Смонтируем home (домашний) раздел в /mnt "
mount /dev/$home /mnt/home  # Монтирование в /mnt ; /mnt - каталог для ручного монтирования файловых систем
 echo ""
 echo " Посмотрим тип файловой системы и точку монтирования "
lsblk --fs /dev/$home  # опции --fs: Отображает тип файловой системы (FSTYPE), метку (LABEL), UUID и точку монтирования (если применимо) для каждого блочного устройства. Синтаксис: lsblk [опции] [устройство]. Опция --fs — одна из основных опций команды lsblk, которая выводит список блочных устройств в виде дерева.
sleep 03
 echo ""
 echo " Форматирование и монтирование выполнено "
sleep 01
fi

clear
echo -e "${MAGENTA}
  <<< Установка файловой системы Btrfs для HOME- (домашнего раздела) в Archlinux >>> ${NC}"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Если вы ещё НЕ Отформатировали ваш HOME- (домашний раздел) в другую из предложенных файловых систем, прошу к барьеру... *В случае, Если вами уже, БЫЛА установлена файловая система для HOME- (домашнего раздела), *Или ваш HOME раздел будет находится (расположен) в ROOT ( / корневом ) разделе системы, *Либо раздел HOME (домашний) у вас остался от другой вашей операционной системы Unix (любой), и вы в дальнейшем захотите его примонтировать! просто пропускайте действие выполнения сценария скрипта Введя на клавиатуре: "0". *Будьте внимательны! ${NC}"
# Installing the Btrfs file system for ROOT (root partition) in Archlinux
#clear
echo ""
echo -e "${BLUE}:: ${NC}*Ваша разметка диска "
echo -e "${CYAN}:: ${NC}Посмотрите вывод списка всех блочных устройств "
lsblk -f  # Команда lsblk выводит список всех блочных устройств
#fdisk -l  # Посмотрим список доступных (созданных) дисков и разделов
sleep 01
echo ""
echo -e "${GREEN}==> ${NC}Установить файловую систему Btrfs для HOME- (домашнего раздела)? "
echo " Если таковой был создан при разметке в cfdisk "
echo " Либо HOME был создан вами заранее и готов к дальнейшим действиям "
echo " Или ваш HOME раздел будет находится (расположен) в ROOT ( / корневом ) разделе системы? "
echo " HOME (/home) —  Это ВАШ домашний раздел, он будет отформатирован в файловую систему ( BTRFS ) "
echo -e "${YELLOW} Примечание! ${BOLD} *Вы Можете пропустить установку (форматирование, монтирование) файловой системы Btrfs для HOME- (Домашнего) раздела, ЕСЛИ ваш HOME раздел УЖЕ отформатирован и смонтирован в другой файловой системе (например Ext4). Либо раздел HOME (домашний) у вас остался от другой вашей операционной системы Unix (любой), и вы в дальнейшем захотите его примонтировать! ${NC}"
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс форматирования был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Форматировать home в Btrfs,   0 - НЕ Форматировать (пропустить): " homesb  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$homesb" =~ [^10] ]]
do
    :
done
if [[ $homesb == 0 ]]; then
 echo ""
 echo " Форматирование и монтирование не требуется "
sleep 01
elif [[ $homesb == 1 ]]; then
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите HOME раздел (sda/sdb 1.2.3.4 (sda5 например)): " home  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
 echo ""
 echo " Создадим файловую систему Btrfs для домашнего раздела "
mkfs.btrfs -f /dev/$home -L home  # или - mkfs.btrfs -f /dev/$home - без -L|--label <строка>
# mkfs.btrfs -f -L home /dev/$home
### Команда, чтобы не вводить 'y'
#  echo 'y' | mkfs.btrfs -f /dev/$home -L home
# echo 'y' | mkfs.btrfs -f /dev/$home  # /dev/sda<цифра>
# echo ""
# echo " Проверка файловой системы на ошибки и их автоматическое исправление "
# echo " Проверка файловой системы для Btrfs не требуется "
### При генерации initramfs mkinitcpio будет ругаться на отсутствие fsck. btrfs - это нормальное явление. Уберём этот хук fsck из конфига, т.к. для Btrfs он не требуется.
# nano /etc/mkinitcpio.conf
### Вот данная строка в файле:
# HOOKS="base udev autodetect modconf block filesystems keyboard"
### И пересоздадим initramfs:
# mkinitcpio -p linux  # или linux-lts
sleep 01
 echo ""
 echo " Проверка файловой системы на ошибки и их автоматическое исправление "
### Fsck (File System Consistency Check) — утилита для Linux и Unix-подобных систем, которая проверяет и (по возможности) чинит файловые системы (ФС). Работает почти со всеми популярными ФС: ext2/3/4, XFS, Btrfs, ReiserFS, JFS и т. д..
### Базовый синтаксис: fsck <options> <filesystem>. В этом примере файловой системой может быть устройство, раздел, точка монтирования и так далее. Некоторые опции: -A — проверить все файловые системы из /etc/fstab; -C — показать прогресс проверки файловой системы; -M — не проверять, если файловая система смонтирована; -N — ничего не выполнять, показать, что проверка завершена успешно.
### Примеры использования: Для работы нужны права суперпользователя (root-доступом).
# fsck -y /dev/$home  # Проверка файловой системы на ошибки и их автоматическое исправление
fsck -n /dev/$home  # Проверка файловой системы на наличие ошибок, которые пока не нужно исправлять
# fsck -t -A btrfs  # Проверка раздела с заданной файловой системой jfs
# fsck -AM  # Чтобы выполнить проверку файловой системы только на несмонтированных дисках
sleep 01
 echo ""
 echo " Смонтировать home раздел в каталоге /mnt "
 echo " Монтирование HOME раздела в /mnt - каталог для ручного монтирования файловых систем "
mount /dev/$home /mnt/home  # /home - defaults,noatime,compress=zstd,commit=120
# mount -o rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,commit=120 /dev/$root /mnt/home
 echo ""
 echo " Узнать тип смонтированной файловой системы "
df -h
mount | grep -E /dev/$home  # Чтобы узнать тип смонтированной файловой системы
# mount | grep /dev/$home
# mount | grep btrfs  # отображать только файловые системы Btrfs
sleep 03
### Добавить snap-pac для автоматического резервного копирования до и после установки/удаления/обновления пакетов.
# sudo pacman --noconfirm -S snap-pac
#pacman -S --noconfirm --needed snap-pac  # Хуки Pacman, которые используют Snapper для создания снимков Btrfs до и после, например YaST от OpenSUSE ; https://archlinux.org/packages/extra/any/snap-pac/ ; https://github.com/wesbarnett/snap-pac ;    2024-07-01 08:11 UTC
### Это набор хуков и скрипта Pacman , которые автоматически заставляют Snapper делать снимки состояния до и после транзакций Pacman, аналогично тому, как это делает YaST в OpenSuse. Это обеспечивает простой способ отмены изменений в системе после транзакции Pacman. Более подробную информацию смотрите в документации (https://wesbarnett.github.io/snap-pac/).
### Предотвращение замедления снимков
#echo  ' PRUNENAMES = ".snapshots" '  >> /etc/updatedb.conf
 echo ""
 echo " Монтирование папок (каталогов) в каталоге /mnt завершено "
 echo " Раздел создан и готов к работе "
sleep 01
fi

clear
echo -e "${MAGENTA}
  <<< Монтирование HOME- (домашнего раздела), если таковой раздел у вас остался от другой вашей операционной системы Unix (любой), и вы захотите его примонтировать в Archlinux >>> ${NC}"
echo ""
echo -e "${BLUE}:: ${NC}Монтирование HOME- (домашнего раздела) — от другой вашей операционной системы?"
echo -e "${CYAN}=> ${NC} *Здесь Можно использовать раздел HOME от предыдущей системы! "
echo -e "${YELLOW}==> Примечание! ${BOLD} *Если вами уже, БЫЛА установлена файловая система для нового HOME- (домашнего раздела), просто пропускайте действие выполнения сценария скрипта Введя на клавиатуре: "0". *Будьте внимательны! ${NC}"
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс монтирования был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да примонтировать раздел HOME (домашний) — от предыдущей системы,

    0 - НЕ МОНТИРОВАТЬ (пропустить): " homeF  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$homeF" =~ [^10] ]]
do
    :
done
if [[ $homeF == 0 ]]; then
 echo ""
 echo " Функция монтирования не требуется "
sleep 01
elif [[ $homeF == 1 ]]; then
echo ""
echo -e "${BLUE}:: ${NC}*Ваша разметка диска "
echo -e "${CYAN}:: ${NC}Посмотрите вывод списка всех блочных устройств "
lsblk -f  # Команда lsblk выводит список всех блочных устройств
#fdisk -l  # Посмотрим список доступных (созданных) дисков и разделов
sleep 01
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите HOME раздел (sda/sdb 1.2.3.4 (sda6 например)): " homeV  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
 echo ""
 echo " Создания папки home в каталоге /mnt "
# mkdir /mnt/home  # Создания папки home в каталоге /mnt
mkdir -p /mnt/home  # mkdir -p НЕ выдаст ошибку, если каталог уже существует и его содержимое не изменится.
 echo ""
 echo " Монтирование HOME- раздела в /mnt/boot "
mount /dev/$homeV /mnt/home  # Смонтируем home (домашний) раздел в /mnt
 echo ""
 echo " Посмотрим тип файловой системы и точку монтирования "
lsblk --fs /dev/$home  # опции --fs: Отображает тип файловой системы (FSTYPE), метку (LABEL), UUID и точку монтирования (если применимо) для каждого блочного устройства. Синтаксис: lsblk [опции] [устройство]. Опция --fs — одна из основных опций команды lsblk, которая выводит список блочных устройств в виде дерева.
sleep 03
 echo ""
 echo " Монтирование home (домашнего) раздела в /mnt выполнено "
sleep 01
fi
##### Windows partitions #####
clear
echo -e "${CYAN}
  <<< Добавление (монтирование, форматирование) разделов для Windows (ntfs/fat32) >>>
${NC}"
echo -e "${GREEN}==> ${NC}Добавим разделы для Windows (ntfs/fat32)?"
echo -e "${MAGENTA}=> ${BOLD}Если таковые были созданы во время разбиения вашего диска(ов) на разделы cfdisk! ${NC}"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Файловая система NTFS (New Technology File System) — файловая система по умолчанию для современных операционных систем Windows. Она предоставляет расширенные функции, включая дескрипторы безопасности, шифрование, дисковые квоты и поддержку расширенных метаданных, что повышает безопасность и эффективность управления данными. Кроме того, NTFS легко интегрируется с общими томами кластера (CSV), обеспечивая высокодоступное хранилище, к которому могут одновременно обращаться несколько узлов отказоустойчивого кластера. Такая интеграция обеспечивает постоянную доступность данных и отказоустойчивость. ${NC}"
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
 echo ""
 echo " Действие пропущено "
sleep 01
elif [[ $wind == 1 ]]; then
echo ""
echo -e "${BLUE}:: ${NC}*Ваша разметка диска "
echo -e "${CYAN}:: ${NC}Посмотрите вывод списка всех блочных устройств "
echo ""
lsblk -f  # Команда lsblk выводит список всех блочных устройств
#fdisk -l  # Посмотрим список доступных (созданных) дисков и разделов
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
 echo ""
 echo " Действие пропущено "
sleep 01
elif [[ $diskC == 1 ]]; then
clear
echo ""
echo -e "${BLUE}:: ${NC}*Ваша разметка диска "
lsblk -f  # Команда lsblk выводит список всех блочных устройств
#fdisk -l  # Посмотрим список доступных (созданных) дисков и разделов
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите диск "C" раздел(sda/sdb 1.2.3.4 (sda4 например) ) : " diskCc
 echo ""
 echo " Создадим файловую систему NTFS для "C"(Local Disk) раздела "
# mkfs.ntfs -Q /dev/$diskCc -L win
mkfs -t ntfs /dev/$diskCc -L win  # mkfs для файловой системы NTFS
### Общие параметры команды:
# -L label позволяет установить метку тома.
# -Q сообщает команде, что не следует выполнять медленное форматирование. Это будет быстрее, но менее безопасно.
# -f принудительно запускает команду, даже если устройство в данный момент смонтировано (не рекомендуется).
 echo ""
 echo " Создания папки в каталоге /mnt "
mkdir /mnt/C  # Команда создает каталог и все необходимые родительские каталоги
# mkdir -p /mnt/mnt/win
 echo ""
 echo " Смонтируем раздел в /mnt "
mount /dev/$diskCc /mnt/C # Затем смонтируйте раздел
# mount -t auto /dev/$diskCc /mnt/C  # Если операция прошла успешно, выходных данных нет
# mount /dev/$diskCc /mnt/mnt/win
 echo ""
 echo " Посмотрим тип файловой системы и точку монтирования "
lsblk --fs /dev/$diskCc  # опции --fs: Отображает тип файловой системы (FSTYPE), метку (LABEL), UUID и точку монтирования (если применимо) для каждого блочного устройства. Синтаксис: lsblk [опции] [устройство]. Опция --fs — одна из основных опций команды lsblk, которая выводит список блочных устройств в виде дерева.
sleep 03
 echo ""
 echo " Форматирование и монтирование выполнено "
sleep 01
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
 echo ""
 echo " Действие пропущено "
sleep 01
elif [[ $diskD == 1 ]]; then
clear
echo ""
echo -e "${BLUE}:: ${NC}*Ваша разметка диска "
echo -e "${CYAN}:: ${NC}Посмотрите вывод списка всех блочных устройств "
echo ""
lsblk -f  # Команда lsblk выводит список всех блочных устройств
#fdisk -l  # Посмотрим список доступных (созданных) дисков и разделов
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите диск "D" раздел(sda/sdb 1.2.3.4 (sda5 например)) : " diskDd
 echo ""
 echo " Создадим файловую систему NTFS для "D"(Data Disk) раздела "
# mkfs.ntfs -Q /dev/$diskDd -L data
mkfs -t ntfs /dev/$diskDd -L data  # mkfs для файловой системы NTFS
 echo ""
 echo " Создания папки в каталоге /mnt "
mkdir /mnt/D
# mkdir -p /mnt/mnt/data
 echo ""
 echo " Смонтируем раздел в /mnt "
mount /dev/$diskDd /mnt/D # Затем смонтируйте раздел
# mount -t auto /dev/$diskDd /mnt/D  # Если операция прошла успешно, выходных данных нет
# mount /dev/$diskDd /mnt/mnt/data
 echo ""
 echo " Посмотрим тип файловой системы и точку монтирования "
lsblk --fs /dev/$diskDd  # опции --fs: Отображает тип файловой системы (FSTYPE), метку (LABEL), UUID и точку монтирования (если применимо) для каждого блочного устройства. Синтаксис: lsblk [опции] [устройство]. Опция --fs — одна из основных опций команды lsblk, которая выводит список блочных устройств в виде дерева.
sleep 03
 echo ""
 echo " Форматирование и монтирование выполнено "
sleep 01
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
echo ""
echo -e "${BLUE}:: ${NC}*Ваша разметка диска "
echo -e "${CYAN}:: ${NC}Посмотрите вывод списка всех блочных устройств "
echo ""
lsblk -f  # Команда lsblk выводит список всех блочных устройств
#fdisk -l  # Посмотрим список доступных (созданных) дисков и разделов
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите диск "E" раздел(sda/sdb 1.2.3.4 (sda5 например)) : " diskDe
 echo ""
 echo " Создадим файловую систему NTFS для "E"(Work Disk) раздела "
# mkfs.ntfs -Q /dev/$diskDd -L work
mkfs -t ntfs /dev/$diskDd -L work  # mkfs для файловой системы NTFS
 echo ""
 echo " Создания папки в каталоге /mnt "
mkdir /mnt/E
# mkdir -p /mnt/mnt/work
 echo ""
 echo " Смонтируем раздел в /mnt "
mount /dev/$diskDe /mnt/E  # Затем смонтируйте раздел
# mount -t auto /dev/$diskDe /mnt/E  # Если операция прошла успешно, выходных данных нет
# mount /dev/$diskDd /mnt/mnt/work
 echo ""
 echo " Посмотрим тип файловой системы и точку монтирования "
lsblk --fs /dev/$diskDe  # опции --fs: Отображает тип файловой системы (FSTYPE), метку (LABEL), UUID и точку монтирования (если применимо) для каждого блочного устройства. Синтаксис: lsblk [опции] [устройство]. Опция --fs — одна из основных опций команды lsblk, которая выводит список блочных устройств в виде дерева.
sleep 03
 echo ""
 echo " Форматирование и монтирование выполнено "
sleep 01
elif [[ $diskE == 0 ]]; then
 echo ""
 echo " Действие пропущено "
sleep 01
fi
fi
#############################
clear
echo ""
echo -e "${BLUE}:: ${NC}Просмотреть подключённые диски с выводом информации о размере и свободном пространстве"
df -h  # Команда df выводит в табличном виде список всех файловых систем и информацию о доступном и занятом дисковом пространстве
echo ""
echo -e "${BLUE}:: ${NC}Просмотреть все идентификаторы наших разделов"
echo ""
blkid -o list  # Команда отображает информацию о блочных устройствах в табличном формате , предоставляя наглядный обзор устройств хранения данных, типов их файловых систем, меток, точек монтирования и UUID. Я обнаружил, что опция форматирования «список» очень полезна. Она также отображает столбец «точка монтирования», что очень удобно.
# blkid  # Для просмотра UUID (или Universal Unique Identifier) - это универсальный уникальный идентификатор определенного устройства компьютера
sleep 01
echo ""
echo -e "${BLUE}:: ${NC}Просмотреть информацию об использовании памяти в системе"
free -h  # Достаточно ли свободной памяти для установки и запуска новых приложений
sleep 01
echo ""
echo -e "${BLUE}:: ${NC}Посмотреть содержмое каталога /mnt."
ls /mnt  # Посмотреть содержимое той или иной папки
sleep 05
######## Mirrorlist ##########
clear
echo ""
echo -e "${GREEN}==> ${NC}Сменить зеркала для увеличения скорости загрузки пакетов?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Reflector — Это незаменимый инструмент для любого пользователя Arch Linux, который хочет держать свою систему в идеальном состоянии. ${NC}"
echo -e "${BLUE}:: ${NC}Загрузка свежего списка зеркал со страницы Mirror Status, и обновление файла mirrorlist ."
echo -e "${MAGENTA}=> ${BOLD}*Если Вы перед запуском скрипта просмотрели его, то может возникнуть резонный вопрос зачем менять список зеркал и обновлять файл mirrorlist, это связано с тем что, начиная с релиза Arch Linux 2020.07.01-x86_64.iso в установочный образ был добавлен reflector. Тем самым во время установки основной системы происходит запуск службы, и обновляется прописанный список зеркал в /etc/pacman.d/mirrorlist . ${NC}"
echo -e "${CYAN}:: ${NC}Вам будет представлено несколько вариантов смены зеркал для увеличения скорости загрузки пакетов. "
echo -e "${MAGENTA}:: ${BOLD} *Огласите весь список, пожалуйста! :) ${NC}"
echo " 1 — Команда отфильтрует зеркала для Russia по протоколам (https, http), отсортирует их по скорости загрузки и обновит файл  в /etc/pacman.d/mirrorlist . "
echo " 2 — Команда подробно выведет список 50 наиболее недавно обновленных HTTP-зеркал, отсортирует их по скорости загрузки, и обновит файл mirrorlist . "
echo " 3 — То же, что и в предыдущем примере, но будут взяты только зеркала, расположенные в Казахстане (Kazakhstan). "
echo " 4 — Команда отфильтрует зеркала для Russia, Belarus, Ukraine, Poland - по протоколам (https, http), отсортирует их по скорости загрузки и обновит файл mirrorlist. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Не переживайте, перед обновлением зеркал будет сделана копия (backup) предыдущего файла mirrorlist, и в последствии будет сделана копия (backup) нового файла mirrorlist. Эти копии (backup) Вы сможете найти в установленной системе в /etc/pacman.d/mirrorlist - (новый список), и в /etc/pacman.d/mirrorlist.backup (старый список). ${NC}"
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс загрузки списка зеркал был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления выбирайте "
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
 echo ""
 echo " Загрузка свежего списка зеркал со страницы Mirror Status "
reflector --verbose --country 'Russia' -l 10 -p https -p http -n 10 --save /etc/pacman.d/mirrorlist --sort rate
### reflector --country <your country code e.g. gb> --ipv4 --protocol "http,https" --sort score --save /etc/pacman.d/mirrorlist
#  reflector --country 'Russia' --ipv4 --protocol "http,https" --sort score --save /etc/pacman.d/mirrorlist
 echo ""
 echo " Разрешить глобальный доступ на чтение (требуется для выполнения некорневого yaourt) "
chmod +r /etc/pacman.d/mirrorlist  # Разрешить глобальный доступ на чтение
 echo ""
 echo " Загрузка свежего списка зеркал выполнена "
sleep 01
elif [[ $zerkala == 2 ]]; then
 echo ""
 echo " Проверим присутствует ли пакет (reflector) "
pacman -S reflector --noconfirm  # Модуль и скрипт Python 3 для получения и фильтрации последнего списка зеркал Pacman
 echo ""
 echo " Резервное копирование исходного списка зеркальных отображений..."
mv -i /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.orig
 echo ""
 echo " Загрузка свежего списка зеркал со страницы Mirror Status "
reflector --verbose -l 50 -p http --sort rate --save /etc/pacman.d/mirrorlist
reflector --verbose -l 15 --sort rate --save /etc/pacman.d/mirrorlist
 echo ""
 echo " Загрузка свежего списка зеркал выполнена "
sleep 01
elif [[ $zerkala == 3 ]]; then
 echo ""
 echo " Проверим присутствует ли пакет (reflector) "
pacman -S reflector --noconfirm  # Модуль и скрипт Python 3 для получения и фильтрации последнего списка зеркал Pacman
 echo ""
 echo " Резервное копирование исходного списка зеркальных отображений..."
mv -i /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.orig
 echo ""
 echo " Загрузка свежего списка зеркал со страницы Mirror Status "
# reflector --verbose --country Kazakhstan -l 20 -p http --sort rate --save /etc/pacman.d/mirrorlist
reflector --verbose --country 'Kazakhstan' -l 5 -p https -p http -n 5 --save /etc/pacman.d/mirrorlist --sort rate
 echo ""
 echo " Разрешить глобальный доступ на чтение (требуется для выполнения некорневого yaourt) "
chmod +r /etc/pacman.d/mirrorlist  # Разрешить глобальный доступ на чтение
 echo ""
 echo " Загрузка свежего списка зеркал выполнена "
sleep 01
elif [[ $zerkala == 4 ]]; then
 echo ""
 echo " Проверим присутствует ли пакет (reflector) "
pacman -S reflector --noconfirm  # Модуль и скрипт Python 3 для получения и фильтрации последнего списка зеркал Pacman
 echo ""
 echo " Резервное копирование исходного списка зеркальных отображений..."
mv -i /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.orig
 echo ""
 echo " Загрузка свежего списка зеркал со страницы Mirror Status "
reflector -c "Russia" -c "Belarus" -c "Ukraine" -c "Poland" -f 20 -l 20 -p https -p http -n 20 --save /etc/pacman.d/mirrorlist --sort rate
 echo ""
 echo " Разрешить глобальный доступ на чтение (требуется для выполнения некорневого yaourt) "
chmod +r /etc/pacman.d/mirrorlist  # Разрешить глобальный доступ на чтение
 echo ""
echo " Загрузка свежего списка зеркал выполнена "
 sleep 01
elif [[ $zerkala == 0 ]]; then
 echo ""
 echo  " Смена списка зеркал пропущена "
sleep 01
fi
###
clear
echo ""
echo -e "${BLUE}:: ${NC}Посмотреть список серверов-зеркал /mnt/etc/pacman.d/mirrorlist"
echo ""
cat /etc/pacman.d/mirrorlist  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 5
echo ""
echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов"
pacman -Sy --noconfirm  # обновить списки пакетов из репозиториев
sleep 01
#########################

clear
echo ""
echo -e "${GREEN}==> ${NC}Установка основных пакетов (base, base-devel) базовой системы Arch Linux "
echo -e "${YELLOW} Примечание! ${BOLD} *Сценарий pacstrap устанавливает (base) базовую систему. Для сборки пакетов из AUR (Arch User Repository) также требуется группа base-devel. ${NC}"
echo -e "${MAGENTA}=> ${BOLD}Т.е., Если нужен AUR, ставь base и base-devel (AUR only), если нет, то ставь только base. ${NC}"
echo -e "${MAGENTA}:: ${BOLD} *Огласите весь список, пожалуйста! :) ${NC}"
echo " 1 — base + base-devel + packages (пакеты небходимые для сетевых настроек, и консольный текстовый редактор: - dhcpcd netctl which inetutils nano) "  #wget vim
echo " 2 — base + packages (пакеты небходимые для сетевых настроек, и консольный текстовый редактор: - dhcpcd netctl which inetutils nano) "   #wget vim
echo " 3 — base + base-devel (установятся группы, Т.е. base и base-devel, без каких либо дополнительных пакетов) "
echo " 4 — base (установится группа, состоящая из определённого количества пакетов, Т.е. просто base, без каких либо дополнительных пакетов) "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Если Вы сомневаетесь в своих действиях, можно установить (base + packages), а group-(группы) base-devel установить позже. ${NC}"
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления "
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
pacstrap /mnt base base-devel nano dhcpcd netctl which inetutils  # wget vim
# pacstrap -i /mnt base base-devel nano dhcpcd netctl which inetutils --noconfirm
clear
 echo ""
 echo " Установка выбранного вами, групп (base + base-devel + packages) выполнена "
sleep 01
elif [[ $t_pacstrap == 2 ]]; then
clear
 echo ""
 echo " Установка выбранного вами, группы "
pacstrap /mnt base nano dhcpcd netctl which inetutils #wget vim
clear
 echo ""
 echo " Установка выбранного вами, групп (base + packages) выполнена "
sleep 01
elif [[ $t_pacstrap == 3 ]]; then
clear
 echo ""
 echo " Установка выбранных вами групп "
pacstrap /mnt base base base-devel
clear
 echo ""
 echo " Установка выбранного вами, групп (base + base-devel) выполнена "
sleep 01
elif [[ $t_pacstrap == 4 ]]; then
clear
 echo ""
 echo " Установка выбранной вами группы "
pacstrap /mnt base
clear
 echo ""
 echo " Установка выбранной вами, группы (base) выполнена "
sleep 01
fi
###
echo ""
echo -e "${GREEN}==> ${NC}Какое ядро (Kernel) Вы бы предпочли установить вместе с системой Arch Linux?"
echo -e "${BLUE}:: ${NC}Kernel (optional), Firmware . Дистрибутив Arch Linux основан на ядре Linux. Помимо основной стабильной (stable) версии в Arch Linux можно использовать некоторые альтернативные ядра. "
echo -e "${MAGENTA}=> ${BOLD}Выбрать-то можно, но тут главное не пропустить установку ядра :) ${NC}"
echo -e "${MAGENTA}:: ${BOLD} *Огласите весь список, пожалуйста! :) ${NC}"
echo " 1 — linux (Stable - ядро Linux с модулями и некоторыми патчами, поставляемое вместе с Rolling Release устанавливаемой системы Arch) "
echo " 2 — linux-hardened (Ядро Hardened - ориентированная на безопасность версия с набором патчей, защищающих от эксплойтов ядра и пространства пользователя. Внедрение защитных возможностей в этом ядре происходит быстрее, чем в linux) "
echo " 3 — linux-lts (Версия ядра и модулей с долгосрочной поддержкой - Long Term Support, LTS) "
echo " 4 — linux-zen (Результат коллективных усилий исследователей с целью создать лучшее из возможных ядер Linux для систем общего назначения) "
echo -e "${YELLOW} Будьте осторожны! ${BOLD} *Если Вы сомневаетесь в своих действиях, можно установить (linux Stable) ядро поставляемое вместе с Rolling Release. ${NC}"
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления "
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
sleep 01
elif [[ $x_pacstrap == 2 ]]; then
clear
 echo ""
 echo " Установка выбранного вами ядра (linux-hardened) "
pacstrap /mnt linux-hardened linux-firmware linux-hardened-headers #linux-hardened-docs
clear
 echo ""
 echo " Ядро (linux-hardened) операционной системы установленно "
sleep 01
elif [[ $x_pacstrap == 3 ]]; then
clear
 echo ""
 echo " Установка выбранного вами ядра (linux-lts) "
pacstrap /mnt linux-lts linux-firmware linux-lts-headers linux-lts-docs
clear
 echo ""
 echo " Ядро (linux-lts) операционной системы установленно "
sleep 01
elif [[ $x_pacstrap == 4 ]]; then
clear
 echo ""
 echo " Установка выбранного вами ядра (linux-zen) "
pacstrap /mnt linux-zen linux-firmware linux-zen-headers #linux-zen-docs
clear
 echo ""
 echo " Ядро (linux-zen) операционной системы установленно "
sleep 01
fi
###
echo ""
echo -e "${GREEN}==> ${NC}Настройка системы, генерируем fstab "
echo -e "${MAGENTA} Справка! ${BOLD}*Файл /etc/fstab используется для настройки параметров монтирования различных блочных устройств, разделов на диске и удаленных файловых систем. Цель команды — создать записи, которые иначе требовали бы ручной конфигурации и были бы подвержены ошибкам. genfstab помогает сохранить иерархию файловых систем, смонтированных вручную, и часто используется во время начальной установки и конфигурации системы. ${NC}"
echo -e "${BLUE}:: ${NC}Таким образом, и локальные, и удаленные файловые системы, указанные в /etc/fstab, будут правильно смонтированы без дополнительной настройки. Важно: перед перезаписью существующего файла fstab рекомендуется создать резервную копию. Также нужно учитывать, где сохраняется файл fstab, например, если нужно создать его для chroot, то не стоит перезаписывать файл на основной установке. "
echo -e "${CYAN}:: ${NC}Существует четыре различных схемы для постоянного именования: по метке, по uuid, по id и по пути. Для тех, кто использует диски с таблицей разделов GUID (GPT), существуют ещё две дополнительные схемы: - "Partlabel" и "Parduuid". Вы также можете использовать статические имена устройств с помощью Udev. "
echo -e "${MAGENTA}:: ${BOLD} *Огласите весь список, пожалуйста! :) ${NC}"
echo " 1 — По-UUID ("UUID" "genfstab -U") "
echo " 2 — По меткам ("LABEL" "genfstab -L") "
echo " 3 — По меткам GPT ("PARTLABEL" "genfstab -t PARTLABEL") "
echo " 4 — По UUID GPT ("PARTUUID" "genfstab -t PARTUUID") "
echo -e "${BLUE}:: ${NC}*Пример использования: команда может быть частью инструкции по установке Arch Linux, где нужно сгенерировать файл fstab на основе метки тома. В выводе команды указывается, что диск с меткой «MyDrive» должен быть смонтирован в /mnt/MyDrive с файловой системой ext4 с настройками по умолчанию при запуске. "
echo -e "${MAGENTA}:: ${NC}Преимущество использования метода UUID состоит в том, что вероятность столкновения имен намного меньше, чем с метками. Далее он генерируется автоматически при создании файловой системы. "
echo -e "${YELLOW} Будьте внимательны! ${BOLD} *Если Вы сомневаетесь в своих действиях, ещё раз взгляните на разметку вашего диска, и таблицу разделов (MBR или GPT). ${NC}"
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления "
echo " Чтобы исключить ошибки в работе системы рекомендую "1" вариант "
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
 echo ""
 echo " Проверьте полученный /mnt/etc/fstab файл и отредактируйте его в случае ошибок. "
sleep 01
elif [[ $x_fstab == 2 ]]; then
clear
 echo ""
 echo " Генерируем fstab выбранным вами методом "
 echo " LABEL - genfstab -L -p /mnt > /mnt/etc/fstab "
genfstab -pL /mnt > /mnt/etc/fstab
### genfstab -L -p -P /mnt >> /mnt/etc/fstab  # -L- LABEL (указывает, что утилита genfstab должна генерировать записи с меткой тома вместо UUID или других идентификаторов. Метки тома легче запоминать и распознавать.); -p - PARTLABEL (по умолчанию исключает печать псевдообозначений) ; -P - (включает печать псевдообозначений.) ; /mnt — базовый каталог, где все файловые системы должны быть смонтированы во время установки. Инструмент читает свойства этого каталога, чтобы сгенерировать записи fstab ; >> /mnt/etc/fstab — оператор >> добавляет сгенерированные записи в существующий файл fstab, расположенный по адресу /mnt/etc/fstab.
 echo ""
 echo " Проверьте полученный /mnt/etc/fstab файл и отредактируйте его в случае ошибок. "
sleep 01
elif [[ $x_fstab == 3 ]]; then
clear
 echo ""
 echo " Генерируем fstab выбранным вами методом "
 echo " PARTLABEL - genfstab -t PARTLABEL -p /mnt > /mnt/etc/fstab "
genfstab -t PARTLABEL -p /mnt > /mnt/etc/fstab
 echo ""
 echo " Проверьте полученный /mnt/etc/fstab файл и отредактируйте его в случае ошибок. "
sleep 01
elif [[ $x_fstab == 4 ]]; then
clear
 echo ""
 echo " Генерируем fstab выбранным вами методом "
 echo " PARTUUID - genfstab -t PARTUUID -p /mnt > /mnt/etc/fstab "
genfstab -t PARTUUID -p /mnt > /mnt/etc/fstab
 echo ""
 echo " Проверьте полученный /mnt/etc/fstab файл и отредактируйте его в случае ошибок. "
sleep 01
fi
###
clear
echo ""
echo -e "${BLUE}:: ${NC}Просмотреть содержимое файла fstab"
cat /mnt/etc/fstab  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 03
clear
echo ""
echo -e "${BLUE}:: ${NC}Взглянем на UUID идентификатор(ы) нашего устройства:"
echo ""
blkid -o list  # Команда отображает информацию о блочных устройствах в табличном формате , предоставляя наглядный обзор устройств хранения данных, типов их файловых систем, меток, точек монтирования и UUID.
# blkid /dev/sd*  # Для просмотра UUID (или Universal Unique Identifier) - это универсальный уникальный идентификатор определенного устройства компьютера
sleep 05
##################
clear
echo ""
echo -e "${GREEN}==> ${NC}Меняем корень и переходим в нашу недавно скачанную систему Chroot (chroot) "
echo -e "${MAGENTA} Примечание! ${BOLD}*Есть три варианта продолжения установки: ${NC}"
  echo " 1 — Если у Вас стабильный трафик интернета (dhcpcd, wifi), и вы скачали первую часть скрипта через
  (wget git.io/archmy1l ), то выбирайте вариант - пункт "1", (команда работает через wget ....) "
  echo " 2 — Альтернативный вариант для (dhcpcd, wifi), если у Вас бывают проблемы трафика интернета (dhcpcd, wifi), и вы скачали первую часть скрипта через (curl -LO git.io/archmy1l ), то выбирайте вариант - пункт "2", (команда работает через curl ....) "
echo -e "${CYAN}:: ${NC}В этих вариантах большого отличия нет, кроме команд выполнения (1-вариант wget), (2-вариант curl),
  и ещё в этих обоих вариантах вам потребуется ввести команду на запуск скрипта " ./archmy2l.sh " затем [enter], НО сначала проверить подключение сети интернет "ping -c2 8.8.8.8" - т.е. пропинговать сеть. "
echo " ########################################################### "
echo -e "${YELLOW}:: ${BOLD}Есть ещё 3(й) способ: команда выполнения как, и во 2-ом варианте через (curl),
        НО *Внимание! В Данный момент (не отрабатывает) КОМАНДА НЕ РАБОТАЕТ!* ${NC}"
  echo " 3 — Если у Вас стабильный трафик интернета (dhcpcd, wifi), и вы скачали первую часть скрипта через
  (wget git.io/archmy1l или curl -LO git.io/archmy1l ), то выбирайте вариант - пункт "3", (команда работает через curl ...) "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - *Stable Internet traffic (dhcpcd, wifi)(команда работает через wget ...),

    2 - Alternative Option Not Stable Internet traffic (dhcpcd, wifi)(команда работает через curl ...),

    3 - Stable Internet traffic (dhcpcd, wifi)(команда работает через curl - *Внимание! КОМАНДА НЕ РАБОТАЕТ!): " int # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$int" =~ [^123] ]]
do
    :
done
if [[ $int == 1 ]]; then
 echo ""
echo " Меняем корень и переходим в нашу недавно скачанную систему "
pacman -Sy wget --noconfirm --noprogressbar  # Сетевая утилита для извлечения файлов из Интернета
wget -P /mnt https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/archmy2l.sh
chmod +x /mnt/archmy2l.sh
clear
echo ""
 echo " Первый этап установки Arch'a закончен "
 echo " Установка продолжится в ARCH-LINUX chroot "
echo ""
echo -e "${YELLOW}=> ${BOLD}Важно! Для удачного продолжения установки выполните эти пунты: ${NC}"
echo " 1 — Проверьте подключение сети интернет для продолжения установки в arch-chroot - "ping -c2 8.8.8.8" "
echo " 2 — Вводим команду для продолжения установки "./archmy2l.sh" "
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
 echo " Установка продолжится в ARCH-LINUX chroot "
echo ""
echo -e "${YELLOW}=> ${BOLD}Важно! Для удачного продолжения установки выполните эти пунты: ${NC}"
echo " 1 — Проверьте подключение сети интернет для продолжения установки в arch-chroot - "ping -c2 8.8.8.8" "
echo " 2 — Вводим команду для продолжения установки "./archmy2l.sh" "
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
 echo " Установка продолжится в ARCH-LINUX chroot "
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