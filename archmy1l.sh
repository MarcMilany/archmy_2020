#!/bin/bash
### Смотрите пометки (справочки) и доп.иформацию в самом скрипте!
###########################################################
#######  <<< Скрипт для установки Arch Linux >>>    #######
#### Этот скрипт находится в процессе 'Внесение попра- ####
#### вок в наводку орудий по результатам наблюдений с  ####
#### наблюдательных пунктов'.                          ####
#### Внимание! Автор не несёт ответственности за любое ####
#### нанесение вреда при использовании скрипта.        ####
#### Лицензия (license): LGPL-3.0                      ####
#### (http://opensource.org/licenses/lgpl-3.0.html     ####
#### В разработке принимали участие (author) :         ####
#### Алексей Бойко https://vk.com/ordanax              ####
#### Степан Скрябин https://vk.com/zurg3               ####
#### Михаил Сарвилин https://vk.com/michael170707      ####
#### Данил Антошкин https://vk.com/danil.antoshkin     ####
#### Юрий Порунцов https://vk.com/poruncov             ####
#### Анфиса Липко https://vc.ru/u/596418-anfisa-lipko  ####
#### Alex Creio https://vk.com/creio                   ####
#### Jeremy Pardo (grm34) https://www.archboot.org/    ####
#### Marc Milany - 'Не ищи меня 'Вконтакте',           ####
####                в 'Одноклассниках'' нас нету, ...  ####
#### Releases ArchLinux:                               ####
####     https://www.archlinux.org/releng/releases/    ####
#### Installation guide - Arch Wiki  (referance):      ####
# https://wiki.archlinux.org/index.php/Installation_guide #
###########################################################
apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
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
VERSION="v1.6 LegasyBIOS Update"
BRANCH="master"
AUTHOR="ordanax_and_poruncov"
LICENSE="GNU General Public License 3.0"
###
ARCHMY1_LANG="russian"  # Installer default language (Язык установки по умолчанию)
### Start of the script
script_path=$(readlink -f ${0%/*})  # эта опция канонизируется путем рекурсивного следования каждой символической ссылке в каждом компоненте данного имени; все, кроме последнего компонента должны существовать
# SCRIPT_PATH=$(realpath $0)
# ...
# echo $SCRIPT_PATH
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
echo "$(date -u "+%F %H:%M")"
## %F - полная дата, то же что и %Y-%m-%d; %H - hour (00..23); %M - minute (00..59)
################
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
### setfont ter-v32b
echo -e "${CYAN}==> ${NC}Добавим русскую локаль в систему установки"
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
  echo " Добро пожаловать в установку Arch Linux "
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
# timedatectl set-ntp true  # Синхронизируем наши системные часы, включаем ntp, если надо сменим часовой пояс
# timedatectl set-timezone Europe/Moscow
echo " Для начала устанавливаем время по Москве, чтобы потом не оказалось, что файловые системы созданы в будущем "
timedatectl set-ntp true && timedatectl set-timezone Europe/Moscow
sleep 02
echo -e "${BLUE}:: ${NC}Посмотрим статус службы NTP (NTP service)"
timedatectl status
echo -e "${BLUE}:: ${NC}Посмотрим дату и время без характеристик для проверки времени"
date  # команда date работает с датой и временем (можно извлекать любую дату в разнообразном формате)
sleep 03
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
  echo " Создаётся генерация мастер-ключа (брелка) pacman "  # gpg –refresh-keys
  pacman-key --init  # генерация мастер-ключа (брелка) pacman
  echo " Далее идёт поиск ключей... "
  pacman-key --populate archlinux  # поиск ключей
# pacman-key --populate
# echo " Брелок для ключей Arch Linux PGP (Репозиторий для пакета связки ключей Arch Linux) "
# pacman -Sy --noconfirm --needed --noprogressbar --quiet archlinux-keyring  # Брелок для ключей Arch Linux PGP https://git.archlinux.org/archlinux-keyring.git/ (для hkps://hkps.pool.sks-keyservers.net)
  echo ""
  echo " Обновление ключей... "
  pacman-key --refresh-keys --keyserver keys.gnupg.net  # http://pool.sks-keyservers.net/
# pacman-key --refresh-keys --keyserver hkp://pool.sks-keyservers.net  # hkps://hkps.pool.sks-keyservers.net
# pacman-key --refresh-keys --keyserver hkps://hkps.pool.sks-keyservers.net  # hkps://hkps.pool.sks-keyservers.net
## Предлагается сделать следующие изменения в конфиге gnupg:
## keyserver hkps://hkps.pool.sks-keyservers.net
## keyserver-options ca-cert-file=/path/to/CA/sks-keyservers.netCA.pem
## где sks-keyservers.netCA.pem – есть сертификат, загружаемый с wwwhttps://sks-keyservers.net/sks-keyservers.netCA.pem
# pacman-key --refresh-keys --keyserver hkps://hkps.pool.sks-keyservers.net
# keyserver-options ca-cert-file=/path/to/CA/sks-keyservers.netCA.pem
  echo ""
  echo " Обновим базы данных пакетов... "
### pacman -Sy  # обновить списки пакетов из репозиториев
  pacman -Syy  # обновление баз пакмэна (pacman)
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
echo ""
echo -e "${BLUE}:: ${NC}Удалить (стереть) таблицу разделов на выбранном диске (sdX)?"
echo -e "${RED}=> ${YELLOW}Примечание: ${BOLD}Перед удалением раздела или таблицы разделов сделайте резервную копию своих данных. Все данные автоматически удаляются при удалении. Так как при выполнении данной опции будет деинсталлирован сам системный загрузчик из раздела MBR жесткого диска. ${NC}"
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
echo -e "${MAGENTA}=> ${BOLD}Вот данные какие диски есть в вашем распоряжении (даже, если Вы работаете на VM): ${NC}"
echo ""
lsblk -f  # Команда lsblk выводит список всех блочных устройств
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да удалить таблицу разделов ,    0 - Нет пропустить: " sgdisk  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$sgdisk" =~ [^10] ]]
do
    :
done
if [[ $sgdisk == 1 ]]; then
  echo ""
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
  read -p " => Укажите диск (sda/sdb например sda или sdb) : " cfd
  sgdisk --zap-all /dev/$cfd   #sda; sdb; sdc; sdd - sgdisk - это манипулятор таблицы разделов Unix-подобных систем
# wipefs -a /dev/$cfd  # Стереть подпись с дискового устройства с помощью команды wipefs
# wipefs -af /dev/$cfd  # Используйте -f опцию (принудительно)
## umount /dev/sd*  # Если проблема с затиранием
  echo " Создание новых записей GPT в памяти. "
  echo " Структуры данных GPT уничтожены! Теперь вы можете разбить диск на разделы с помощью fdisk или других утилит. "
elif [[ $sgdisk == 0 ]]; then
  echo " Операция  Удаления (стерания) таблицу разделов пропущена "
fi
###
clear
echo -e "${MAGENTA}
  <<< Вся разметка диска(ов) производится только утилитой - cfdisk - (для управления разделами жёсткого диска) >>>
${NC}"
echo -e "${RED}=> ${YELLOW}Предупреждение: ${BOLD}Перед созданием раздела(ов) или удалением таблицы разделов сделайте резервную копию своих данных. Повторю ещё раз - если что-то напутаете при разметке дисков, то можете случайно удалить важные для вас данные. Так как при выполнении данной опции (может) будет деинсталлирован сам системный загрузчик из раздела MBR жесткого диска. ${NC}"
echo ""
echo -e "${GREEN}==> ${NC}Создание разделов диска для установки ArchLinux"
echo -e "${YELLOW}:: ${BOLD}Здесь Вы также можете подготовить разделы для Windows (ntfs/fat32)(С;D;E), и в дальнейшем после разбиения диска(ов), их примонтировать. ${NC}"
echo -e "${BLUE}:: ${NC}Вам нужна разметка диска?"
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да приступить к разметке,    0 - Нет пропустить разметку: " cfdisk  # файл устройство дискового накопителя;  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$cfdisk" =~ [^10] ]]
do
    :
done
if [[ $cfdisk == 1 ]]; then
  clear
  echo ""
  echo -e "${BLUE}:: ${NC}Выбор диска для установки"
  lsblk -f  # Команда lsblk выводит список всех блочных устройств
  echo ""
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
  read -p " => Укажите диск (sda/sdb например sda или sdb) : " cfd
  cfdisk /dev/$cfd  # Утилита cfdisk используется для работы с дисковым пространством в операционных системах Linux
  echo ""
  clear
elif [[ $cfdisk == 0 ]]; then
  echo " Разметка диска(ов) (разделов) пропропущена "
fi
###
clear
echo ""
echo -e "${BLUE}:: ${NC}Ваша разметка диска"
fdisk -l  # Посмотрим список доступных (созданных) дисков и разделов
lsblk -f  # Команда lsblk выводит список всех блочных устройств
#lsblk -lo  # Команда lsblk выводит список всех блочных устройств
sleep 3
###
clear
echo ""
echo -e "${GREEN}==> ${NC}Форматирование разделов диска"
echo -e "${BLUE}:: ${NC}Установка название флага boot,root,swap,home"
echo -e "${BLUE}:: ${NC}Монтирование разделов диска"
########## Root  ########
lsblk -f  # Команда lsblk выводит список всех блочных устройств
echo ""
echo -e "${BLUE}:: ${NC}Форматируем и монтируем ROOT раздел?"
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " Укажите ROOT раздел (sda/sdb 1.2.3.4 (sda5 например)): " root  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo ""
mkfs.ext4 /dev/$root -L root
mount /dev/$root /mnt
echo ""
########## Boot  ########
clear
echo ""
lsblk -f  # Команда lsblk выводит список всех блочных устройств
echo ""
echo -e "${BLUE}:: ${NC}Форматируем BOOT раздел?"
echo " Если таковой был создан при разметке в cfdisk "
echo " 1 - Форматировать и монтировать на отдельный раздел "
echo " 2 - Пропустить если BOOT раздела нет на отдельном разделе, и он находится в корневом разделе ROOT "
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да форматировать,    2 - Нет пропустить: " boots  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$boots" =~ [^12] ]]
do
    :
done
if [[ $boots == 1 ]]; then
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
  read -p " Укажите BOOT раздел (sda/sdb 1.2.3.4 (sda7 например)): " bootd  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
# mkfs.ext4 -O \^64bit /dev/$bootd -L boot  # -O - активировать или деактивировать те или иные возможности файловой системы. Сами возможности мы рассмотрим ниже; 64bit - файловая система сможет занимать место больше чем 2 в 32 степени блоков. При размере блока 4 килобайта, это примерно один терабайт;
  mkfs.ext2  /dev/$bootd -L boot
  mkdir /mnt/boot
  mount /dev/$bootd /mnt/boot
elif [[ $boots == 2 ]]; then
 echo " Форматирование и монтирование не требуется "
fi
########## Swap  ########
clear
echo ""
lsblk -f  # Команда lsblk выводит список всех блочных устройств
echo ""
echo -e "${BLUE}:: ${NC}Форматируем Swap раздел?"
echo " Если таковой был создан при разметке в cfdisk "
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да,    0 - Нет: " swap  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$swap" =~ [^10] ]]
do
    :
done
if [[ $swap == 1 ]]; then
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
  read -p " Укажите swap раздел (sda/sdb 1.2.3.4 (sda7 например)): " swaps  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
  mkswap /dev/$swaps -L swap
  swapon /dev/$swaps
elif [[ $swap == 0 ]]; then
  echo " Добавление Swap раздела пропущено. "
fi
########## Home  ########
clear
echo ""
echo -e "${BLUE}:: ${NC}Добавим HOME раздел?"
echo " Если таковой был создан при разметке в cfdisk "
echo -e "${CYAN}=> ${NC}Можно использовать раздел от предыдущей системы (и его не форматировать)! "
echo -e "${MAGENTA}:: ${BOLD}Далее в процессе установки в сценарии будет Пункт, в котором можно будет удалить все скрытые файлы и папки в каталоге пользователя "home/USERNAME" (от предыдущей системы). ${NC}"
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да добавить Home раздел,    0 - Нет не добавлять: " homes  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$homes" =~ [^10] ]]
do
    :
done
if [[ $homes == 0 ]]; then
  echo " Добавление Home раздела пропущено. "
elif [[ $homes == 1 ]]; then
  echo " Добавление домашнего раздела (HOME) "
echo -e "${BLUE}:: ${NC}Форматируем Home раздел?"
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да форматировать,    0 - Нет не форматировать: " homeF  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$homeF" =~ [^10] ]]
do
    :
done
   if [[ $homeF == 1 ]]; then
     echo ""
     lsblk -f  # Команда lsblk выводит список всех блочных устройств
     echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
     read -p " Укажите HOME раздел (sda/sdb 1.2.3.4 (sda6 например)): " home  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
     mkfs.ext4 /dev/$home -L home
     mkdir /mnt/home
     mount /dev/$home /mnt/home
   elif [[ $homeF == 0 ]]; then
     lsblk -f  # Команда lsblk выводит список всех блочных устройств
     echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
     read -p " Укажите HOME раздел (sda/sdb 1.2.3.4 (sda6 например)): " homeV  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
     mkdir /mnt/home
     mount /dev/$homeV /mnt/home
   fi
fi
sleep 02
###
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
  mkdir /mnt/C
  mount /dev/$diskCc /mnt/C
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
  mkdir /mnt/D
  mount /dev/$diskDd /mnt/D
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
  mkdir /mnt/E
  mount /dev/$diskDe /mnt/E
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
    1 - Russia (https, http),     2 - 50 HTTP-зеркал,

    3 - Kazakhstan (http),       4 - Russia, Belarus, Ukraine, Poland (https, http),

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
  pacman -S --noconfirm --needed --noprogressbar --quiet reflector
# Создайте резервную копию и замените текущий файл зеркального списка
  echo ""
  echo " Резервное копирование исходного списка зеркальных отображений..."
  mv -i /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.orig
  echo " Загрузка свежего списка зеркал со страницы Mirror Status "
  reflector --verbose --country 'Russia' -l 9 -p https -p http -n 9 --save /etc/pacman.d/mirrorlist --sort rate
## reflector --country <your country code e.g. gb> --ipv4 --protocol "http,https" --sort score --save /etc/pacman.d/mirrorlist
# reflector --verbose --country 'Russia' --ipv4 --protocol -l 9 -p https -p http -n 9 --save /etc/pacman.d/mirrorlist --sort rate
# reflector --country 'Russia' --ipv4 --protocol "http,https" --sort score --save /etc/pacman.d/mirrorlist
# Разрешить глобальный доступ на чтение (требуется для выполнения некорневого yaourt)
  chmod +r /etc/pacman.d/mirrorlist
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
sleep 1
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
echo -e "${MAGENTA}=> ${BOLD}Файл /etc/fstab используется для настройки параметров монтирования различных блочных устройств, разделов на диске и удаленных файловых систем. ${NC}"
echo " Таким образом, и локальные, и удаленные файловые системы, указанные в /etc/fstab, будут правильно смонтированы без дополнительной настройки. "
echo -e "${CYAN}:: ${NC}Существует четыре различных схемы для постоянного именования: по метке, по uuid, по id и по пути. Для тех, кто использует диски с таблицей разделов GUID (GPT), существуют ещё две дополнительные схемы: - "Partlabel" и "Parduuid". Вы также можете использовать статические имена устройств с помощью Udev."
echo " Огласите весь список, пожалуйста! :) "
echo " 1 - По-UUID ("UUID" "genfstab -U") "
echo " 2 - По меткам ("LABEL" "genfstab -L") "
echo " 3 - По меткам GPT ("PARTLABEL" "genfstab -t PARTLABEL") "
echo " 4 - По UUID GPT ("PARTUUID" "genfstab -t PARTUUID") "
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз взгляните на разметку вашего диска, и таблицу разделов (MBR или GPT). "
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления"
echo " Чтобы исключить ошибки в работе системы рекомендую "1" вариант "
echo -e "${MAGENTA}:: ${NC}Преимущество использования метода UUID состоит в том, что вероятность столкновения имен намного меньше, чем с метками. Далее он генерируется автоматически при создании файловой системы."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - UUID genfstab -U,                 2 - LABEL genfstab -L,

    3 - PARTLABEL genfstab -t PARTLABEL,

    4 - PARTUUID genfstab -t PARTUUID: " x_fstab  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
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
sleep 01
##################
clear
echo ""
echo -e "${GREEN}==> ${NC}Меняем корень и переходим в нашу недавно скачанную систему (chroot)"
echo -e "${MAGENTA}=> ${BOLD}Есть три варианта продолжения установки: ${NC}"
  echo " 1 - Если у Вас стабильный трафик интернета (dhcpcd, wifi), то выбирайте вариант - "1" "
  echo " 2 - Если у Вас бывают проблемы трафика интернета (dhcpcd, wifi), то выбирайте вариант - "2" "
echo -e "${CYAN}:: ${NC}В этих вариантах большого отличия нет, кроме команд выполнения (1вариант curl), (2вариант wget), и ещё во 2-ом варианте вам потребуется ввести команду на запуск скрипта "./archmy2l.sh", а также проверить подключение сети интернет "ping -c2 8.8.8.8" - т.е. пропинговать сеть. "
echo -e "${YELLOW}:: ${BOLD}Есть ещё 3й способ: команда выполнения как, и в 1ом варианте через (curl), и как во 2-ом варианте вам потребуется ввести команду на запуск скрипта "./archmy2l.sh", а также проверить подключение сети интернет "ping -c2 8.8.8.8" - т.е. пропинговать сеть. ${NC}"
echo " 3 - Альтернативный вариант для (dhcpcd, wifi), если у Вас возникнут проблемы с первыми способами продолжения установки, то рекомендую вариант - "3" "
echo " Будьте внимательны! В данной опции выбор всегда остаётся за вами. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Stable Internet traffic (dhcpcd, wifi),

    2 - Not Stable Internet traffic (dhcpcd, wifi),

    3 - Alternative Option (dhcpcd, wifi): " int # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$int" =~ [^123] ]]
do
    :
done
if [[ $int == 1 ]]; then
  echo ""
  echo " Первый этап установки Arch'a закончен "
  echo 'Установка продолжится в ARCH-LINUX chroot'
  echo ""
# pacman -S --noconfirm --needed --noprogressbar --quiet curl # Утилита и библиотека для поиска URL
#  arch-chroot /mnt /bin/bash sh -c "$(curl -fsSL git.io/archmy2l)"  # Проверить команду ...
#  arch-chroot /mnt "sh -c \"$(curl -fsSL git.io/archmy2l)\""  # Проверить команду ...
  arch-chroot /mnt sh -c "$(curl -fsSL git.io/archmy2l)"  # sh вызывает программу sh как интерпретатор и флаг -c означает выполнение следующей команды, интерпретируемой этой программой (выполнить команду специально с этой оболочкой вместо bash)
###  curl -s "http://get.sdkman.io" | bash
### \ curl -sSL https://get.rvm.io | bash --debug
### curl -sSL https://get.rvm.io | bash -s stable --rails  # Проблема устранена командой
  echo " ############################################### "
  echo -e "${BLUE}       ARCH LINUX FAST INSTALL ${RED}1.6 Update${NC}"
  echo " ############################################### "
  echo " Размонтирование всех смонтированных файловых систем (кроме корневой) "
  umount -a  # файловые системы, упомянутые в fstab (cоответсвующего типа/параметров) должны быть размонтированы и остановлены (кроме тех, для которых указана опция noauto)
  reboot
elif [[ $int == 2 ]]; then
  echo ""
  pacman -S wget --noconfirm --noprogressbar  # Сетевая утилита для извлечения файлов из Интернета
  wget -P /mnt https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/archmy2l.sh
  chmod +x /mnt/archmy2l.sh
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
  echo -e "${BLUE}       ARCH LINUX FAST INSTALL ${RED}1.6 Update${NC}"
  echo " ############################################### "
  echo " Размонтирование всех смонтированных файловых систем (кроме корневой) "
  umount -a
  reboot
elif [[ $int == 3 ]]; then
  echo ""
# pacman -S --noconfirm --needed --noprogressbar --quiet curl # Утилита и библиотека для поиска URL
  curl -LO https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/archmy2l.sh
  mv archmy2l.sh /mnt
  chmod +x /mnt/archmy2l.sh
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
  echo -e "${BLUE}       ARCH LINUX FAST INSTALL ${RED}1.6 Update${NC}"
  echo " ############################################### "
  echo " Размонтирование всех смонтированных файловых систем (кроме корневой) "
  umount -a
  reboot
fi
#########################
































































































