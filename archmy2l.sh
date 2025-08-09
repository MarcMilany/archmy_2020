
#!/bin/bash
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
ARCHMY2L="russian"  # Installer default language (Язык установки по умолчанию)
script_path=$(readlink -f ${0%/*})  # эта опция канонизируется путем рекурсивного следования каждой символической ссылке в каждом компоненте данного имени; все, кроме последнего компонента должны существовать
###
umask 0022 # Определение окончательных прав доступа - Для суперпользователя (root) umask по умолчанию равна 0022
set -e # Эта команда остановит выполнение сценария после сбоя команды и будет отправлен код ошибки
# set -euxo pipefail  # прекращает выполнение скрипта, даже если одна из частей пайпа завершилась ошибкой
#####################
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
###############################
# Information (Информация)
_arch_fast_install_banner_2() {
    echo -e "${YELLOW}
  ***************************** ИНФОРМАЦИЯ! *****************************
${NC}
Продолжается работа скрипта: - будет проходить установка первоначально необходимого софта (пакетов), запуск необходимых служб, запись данных в конфиги (hhh.conf) по настройке системы.
В процессе работы сценария (скрипта) Вам будет предложено выполнить следующие действия:
Ввести имя пользователя (username), ввести имя компьютера (hostname), а также установить пароль для пользователя (username) и администратора (root).
Настроить состояние аппаратных часов 'UTC или Localtime', но Вы можете отказаться и настроить их уже из системы Arch'a.
Будут заданы вопросы: на установку той, или иной утилиты (пакета), и на какой аппаратной базе будет установлена система (для установки Xorg 'обычно называемый просто X' и драйверов) - Будьте Внимательными!
 Смысл в том, что все изменения Вы делаете предварительно в самом скрипте и получаете возможность быстрой установки утилит (пакетов), которые Вы решили установить (при условии, что Вы его изменили под себя, в противном случае скрипт установит софт (пакеты) прописанный изначально.
Не переживайте софт (пакеты) скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. В любой ситуации выбор всегда за вами.
${BLUE}
  *********************************************************************** ${NC}"
}
###
echo ""
echo " Второй этап установки Arch'a "
### Display banner (Дисплей баннер)
#echo ""
_arch_fast_install_banner_2
###
sleep 07
echo ""
echo -e "${GREEN}=> ${NC}Для проверки интернета можно пропинговать какой-либо сервис"
ping google.com -W 2 -c 1   # Отправить эхо-запрос по протоколу ICMP на имя или IP-адрес целевого узла
#ping -c 2 archlinux.org  # Утилита ping - это очень простой инструмент для диагностики сети
# ping -6 ya.ru  # пинг узла ya.ru с использованием протокола Ipv6
### Формат командной строки: ping [-t] [-a] [-n число] [-l размер] [-f] [-i TTL] [-v TOS] [-r число] [-s число] [[-j списокУзлов] | [-k списокУзлов]] [-w таймаут] конечноеИмя  ; https://ab57.ru/cmdlist/ping.html
echo -e "${CYAN}==> ${NC}Если пинг идёт едем дальше ... :)"
###
echo ""
#echo -e "${BLUE}:: ${NC}Синхронизация системных часов"
#timedatectl set-ntp true
#echo -e "${BLUE}:: ${NC}Посмотрим статус службы NTP (NTP service)"
#timedatectl status
#echo -e "${BLUE}:: ${NC}Посмотрим текущее состояние аппаратных и программных часов"
#timedatectl
###
echo ""
echo -e "${BLUE}:: ${NC}Обновим вашу систему (базу данных пакетов)"
echo -e "${YELLOW}:: ${NC}Загружаем базу данных пакетов независимо от того, есть ли какие-либо изменения в версиях или нет."
echo ""
echo " Брелок для ключей Arch Linux PGP (Репозиторий для пакета связки ключей Arch Linux) "
pacman -Sy --noconfirm --needed --noprogressbar --quiet archlinux-keyring  # Брелок для ключей Arch Linux PGP ; https://git.archlinux.org/archlinux-keyring.git/ (для hkps://hkps.pool.sks-keyservers.net)
pacman -Syyu --noconfirm  # Обновим вашу систему (базу данных пакетов)
sleep 1
#################
clear
echo ""
echo -e "${GREEN}==> ${NC}Вводим название компьютера (host name), и имя пользователя (user name)"
echo -e "${YELLOW}:: ${NC}Hostname (имя компьютера, имя хоста) задается во время установки системы Linux. Hostname определяет название компьютера и используется преимущественно для идентификации компьютера в сети. Нельзя назначать два одинаковых Hostname для компьютеров в одной сети. "
echo -e "${MAGENTA}=> ${BOLD}Используйте в названии (host name) только буквы латинского алфавита (a-zA-Z0-9) (можно с заглавной буквы). Латиница - это английские буквы. Кириллица - русские. ${NC}"
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " => Введите имя компьютера: " hostname
# echo -e "${Yellow}Как бы вы хотели назвать этот компьютер?${NoColor}"
# read hostname; clear  #
echo ""
echo " Проверка текущего имени хоста "
echo " Будет отображено текущее имя хоста и другая полезная информация о системе. Если на вашем компьютере уже задано имя хоста, оно будет указано под Static hostname полем. "
hostnamectl  # Hostnamectl — это утилита для управления именем хоста (hostname) в системах Linux, использующих systemd. Она позволяет получать и изменять настройки имени хоста, а также связанные с ним параметры.
sleep 03
########## Справка Hostnamectl ###########
# Некоторые команды hostnamectl:
# hostnamectl set-hostname hostname  # * перезагрузка не потребуется — новое имя начнет использоваться сразу.
# systemctl restart systemd-hostnamed  # Если, по каким-либо причинам, новое имя не начнет использоваться
# status — показывает текущее имя хоста и связанные с ним настройки;
# set-hostname — устанавливает системное имя хоста;
# set-icon-name — меняет имя иконки для хоста;
# set-chassis — устанавливает тип шасси для хоста;
# set-deployment — устанавливает описание среды развёртывания
# Некоторые примеры использования hostnamectl:
# Проверка текущего имени хоста: hostnamectl без аргументов.
# Временное изменение имени хоста: sudo hostnamectl set-hostname new-hostname.
# Постоянное изменение имени хоста: sudo hostnamectl set-hostname permanent-hostname --static
##################################
echo ""
echo -e "${GREEN}==> ${NC}Вводим имя пользователя (user name)"
echo -e "${YELLOW}:: ${NC}Username (юзернейм) — это уникальное имя пользователя в социальных сетях, мессенджерах и онлайн-платформах. Он выполняет несколько функций: Идентификация - Помогает другим пользователям найти профиль. Персонализация - Отражает личный бренд или тематику аккаунта. SEO и брендинг. Влияет на запоминаемость и продвижение в сети. Также username может означать уникальное имя учётной записи пользователя в компьютерной системе (логин). В качестве логина чаще всего используют имя, адрес электронной почты, номер телефона или другой идентификатор. В связке с паролем логин используется для аутентификации в информационной системе и доступу к персональному аккаунту. "
echo -e "${MAGENTA}=> ${BOLD}Используйте в имени (user name) только буквы латинского алфавита (в нижнем (маленькие) регистре (a-z)(a-z0-9_-)), и цифры ${NC}"
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " => Введите имя пользователя: " username
# echo -e "Какое имя пользователя вам нужно?"
# read username; clear

###
echo -e "${BLUE}:: ${NC}Прописываем имя компьютера"
echo $hostname > /etc/hostname
###
echo ""
echo -e "${RED}==> ${NC}Очистить папку конфигурации (настроек), кеш, и скрытые каталоги в /home/$username от старой установленной системы? "
echo -e "${CYAN}:: ${BOLD}Если таковая присутствует, и не была удалена при создании новой разметки диска. ${NC}"
echo -e "${YELLOW}==> ${NC}Будьте осторожны! Если Вы сомневаетесь в своих действиях, просто пропустите этот пункт."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да очистить папки конфигов,    0 - Нет пропустить очистку: " i_rm  # sends right after the keypress; # отправляет сразу после нажатия клавиши
echo ''
   [[ "$i_rm" =~ [^10] ]]
do
    :
done
if [[ $i_rm == 0 ]]; then
  clear
  echo ""
  echo " Очистка пропущена "
elif [[ $i_rm == 1 ]]; then
  clear
  rm -rf /home/$username/.*
  echo ""
  echo " Очистка завершена "
fi
####################
echo ""
echo -e "${GREEN}==> ${NC}Устанавливаем ваш часовой пояс (localtime)."
echo " Всё завязано на времени, поэтому очень важно, чтобы часы шли правильно... :) "
echo -e "${BLUE}:: ${BOLD}Для начала вот ваши данные по дате, времени и часовому поясу: ${NC}"
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'    # одновременно отображает дату и часовой пояс
echo -e "${MAGENTA}:: ${BOLD}Мир состоит из шести частей света: Азия, Африка, Америка, Европа, Австралия и Океания, Антарктика (Антарктида с прибрежными морями и островами). Иногда Океанию и Арктику выделяют в отдельные части света. ${NC}"
echo -e "${CYAN}:: ${NC}Наиболее популярный и поддерживаемый в большинстве дистрибутивов способ установки часового пояса для всех пользователей с помощью символической ссылки (symbolic link) "/etc/localtime" на файл нужного часового пояса."
echo -e "${CYAN}:: ${NC}Для создания символической ссылки используется команда "ln -sf" или "ln -svf"."
echo " ln -sf /usr/share/zoneinfo/Частъ Света/Город /etc/localtime "  # (где Region - ваш регион, City - ваш город)
echo " ln -sf /usr/share/zoneinfo/Зона/Субзона /etc/localtime "
echo " ln -sf /usr/share/zoneinfo/Регион/Город /etc/localtime "
echo " ln -svf /usr/share/zoneinfo/Europe/Moscow /etc/localtime - это полный вид команды "
echo -e "${CYAN}:: ${NC}Для нас сейчас нужна малая толика от всей команды это - (Частъ Света/Город)."
echo -e "${CYAN} Пример (timezone): ${NC}Europe/Moscow, Europe/Minsk, Europe/Kiev, Europe/Berlin, Europe/Paris, Asia/Yekaterinburg, Asia/Almaty, Africa/Nairobi, America/Chicago, America/New_York, America/Indiana/Indianapolis, Australia/Sydney, Antarctica/Vostok, Arctic/Longyearbyen, Atlantic/Azores, Indian/Maldives, и так далее..."
#echo -e "${BLUE}:: ${NC}Выведем список временных зон только для Европы:"
#timedatectl list-timezones | grep Europe | less  # воспользуемся grep и ограничим область поиска
echo -e "${MAGENTA}=> ${BOLD}Используйте только буквы латинского алфавита (a-zA-Z) (начиная название с заглавной буквы). ${NC}"
echo " (Example) - в переводе это Пример, Наглядный, типичный образец,... "
# Итак создадим ссылку на нужный файл временной зоны:
echo " Укажите вашу (timezone), как это показано выше в примере. "
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " => Введите свою таймзону в формате Example/Example: " timezone
# Создадим ссылку на нужный файл временной зоны:
#ln -sv /usr/share/zoneinfo/UTC /etc/localtime   # UTC - часы дают универсальное время на нулевом часовом поясе
ln -svf /usr/share/zoneinfo/$timezone /etc/localtime
#ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
# Создадим резервную копию текущего часового пояса:
#cp /etc/localtime /etc/localtime.bak
cp /etc/localtime /etc/localtime.backup
# Запишем название часового пояса в /etc/timezone:
echo $timezone > /etc/timezone
# timedatectl set-timezone Europe/Moscow     # установка часового пояса
#timedatectl set-timezone $timezone          # установка часового пояса
ls -lh /etc/localtime  # для просмотра символической ссылки, которая указывает на текущий часовой пояс, используемый в системе
###
echo ""
echo -e "${GREEN}=> ${BOLD}Это ваш часовой пояс (timezone) - '$timezone' ${NC}"
echo -e "${BLUE}:: ${BOLD}Ваши данные по дате, времени и часовому поясу: ${NC}"
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'    # одновременно отображает дату и часовой пояс
# date -s "YYYY-MM-DD HH:MM:SS"  # ММ — это месяц (01-12) ; DD — это день (01-31) ; hh — это час (00-23) ; mm — это минута (00-59) ; YYYY — это год ; ss — это секунды (00-59).
# date MMDDhhmmYYYY.s
###
echo -e "${BLUE}:: ${NC}Синхронизируем аппаратное время с системным"
echo " Получить дату и время из Google "
date -s "$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z"  # https://andreyex.ru/linux/kak-ustanovit-datu-i-vremya-iz-komandnoj-stroki-v-linux/
sleep 01
echo " Устанавливаются аппаратные часы из системных часов. "
hwclock --systohc  # Эта команда предполагает, что аппаратные часы настроены в формате UTC. После установки системной даты и времени вам следует обновить аппаратные часы, чтобы они соответствовали системным часам.
# hwclock --adjust  # Порой значение аппаратного времени может сбиваться - выровняем!
# hwclock -w  # переведёт аппаратные часы
sleep 01
###
echo ""
echo -e "${GREEN}==> ${NC}Настроим состояние аппаратных и программных часов."
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если сейчас ваш часовой пояс настроен правильно, или Вы не уверены в правильности выбора! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - UTC,    2 - Localtime,

    0 - Пропустить настройку: " hw_clock  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$hw_clock" =~ [^120] ]]
do
    :
done
if [[ $hw_clock == 0 ]]; then
  echo ""
  echo " Настройка часов (времени) пропущена "
elif [[ $hw_clock == 1 ]]; then
  hwclock --systohc --utc
# hwclock -w  # Проверьте правильность системного времени
  echo ""
  echo " Вы выбрали hwclock --systohc --utc "
  echo " UTC - часы дают универсальное время на нулевом часовом поясе "
elif [[ $hw_clock == 2 ]]; then
  hwclock --systohc --local
# hwclock -w  # Проверьте правильность системного времени
  echo ""
  echo " Вы выбрали hwclock --systohc --localtime "
  echo " Localtime - часы идут по времени локального часового пояса "
fi
###
echo ""
echo -e "${BLUE}:: ${NC}Посмотрим обновление времени (если настройка не была пропущена)"
#timedatectl show
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'    # одновременно отображает дату и часовой пояс
#echo "$(date -u "+%F %H:%M")"  # Текущая полная дата
## %F - полная дата, то же что и %Y-%m-%d; %H - hour (00..23); %M - minute (00..59)
######################
sleep 01

echo ""
echo -e "${BLUE}:: ${NC}Файл hosts — это текстовый документ, который содержит в себе информацию о домене и IP-адресе, который ему соответствует. Располагается hosts на локальных машинах."
echo " С помощью этого файла вы можете управлять маршрутизацией трафика и разрешением IP-адресов в имена DNS. Приоритет данного файла позволяет обрабатывать сетевые запросы до их передачи публичным или частным DNS-серверам. "
echo ""
echo -e "${BLUE}:: ${NC}Изменяем имя хоста"
echo "127.0.0.1 localhost" > /etc/hosts
echo "# 127.0.0.1	localhost.(none)" >> /etc/hosts
echo "127.0.1.1	$hostname" >> /etc/hosts
echo "127.0.1.1 $hostname.localdomain $hostname" >> /etc/hosts
echo "127.0.0.1 localhost.localdomain" >> /etc/hosts
echo "127.0.0.1 local" >> /etc/hosts
echo "255.255.255.255 broadcasthost" >> /etc/hosts
echo "::1 localhost ip6-localhost ip6-loopback" >> /etc/hosts
echo "fe80::1%lo0 localhost" >> /etc/hosts
echo "ff00::0 ip6-localnet" >> /etc/hosts
echo "ff00::0 ip6-mcastprefix" >> /etc/hosts
echo "ff02::1 ip6-allnodes" >> /etc/hosts
echo "ff02::2 ip6-allrouters" >> /etc/hosts
echo "ff02::3 ip6-allhosts" >> /etc/hosts
echo "0.0.0.0 0.0.0.0" >> /etc/hosts
#######################
echo " Для начала сделаем его бэкап /etc/hosts "
echo " hosts — это текстовый документ, который содержит в себе информацию о домене и IP-адресе "
#cp /etc/hosts  /etc/hosts.back
cp -v /etc/hosts  /etc/hosts.back  # Для начала сделаем его бэкап
# cp -v /etc/hosts  /etc/hosts.original  # -v или --verbose -Выводить информацию о каждом файле, который обрабатывает команда cp.
###
echo -e "${BLUE}:: ${NC}Добавляем русскую локаль системы"
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
###
echo -e "${BLUE}:: ${NC}Обновим текущую локаль системы"
locale-gen  # Мы ввели locale-gen для генерации тех самых локалей
###
sleep 02
echo -e "${BLUE}:: ${NC}Указываем язык системы"
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf
echo "LC_COLLATE=C" >> /etc/locale.conf
echo 'LC_ADDRESS="ru_RU.UTF-8"' >> /etc/locale.conf
echo 'LC_IDENTIFICATION="ru_RU.UTF-8"' >> /etc/locale.conf
echo 'LC_MEASUREMENT="ru_RU.UTF-8"' >> /etc/locale.conf
echo 'LC_MONETARY="ru_RU.UTF-8"' >> /etc/locale.conf
echo 'LC_MESSAGES="ru_RU.UTF-8"' >> /etc/locale.conf
echo 'LC_NAME="ru_RU.UTF-8"' >> /etc/locale.conf
echo '#LC_CTYPE="ru_RU.UTF-8"' >> /etc/locale.conf
echo 'LC_NUMERIC="ru_RU.UTF-8"' >> /etc/locale.conf
echo 'LC_PAPER="ru_RU.UTF-8"' >> /etc/locale.conf
echo 'LC_TELEPHONE="ru_RU.UTF-8"' >> /etc/locale.conf
echo 'LC_TIME="ru_RU.UTF-8"' >> /etc/locale.conf
###
#echo 'LANG="en_US.UTF-8"' > /etc/locale.conf
#echo 'LC_CTYPE="en_US.UTF-8"' > /etc/locale.conf
#echo 'LC_NUMERIC="en_US.UTF-8"' > /etc/locale.conf
#echo 'LC_TIME="en_US.UTF-8"' > /etc/locale.conf
#echo 'LC_COLLATE="en_US.UTF-8"' > /etc/locale.conf
#echo 'LC_MONETARY="en_US.UTF-8"' > /etc/locale.conf
#echo 'LC_PAPER="en_US.UTF-8"' > /etc/locale.conf
#echo 'LC_ADDRESS="en_US.UTF-8"' > /etc/locale.conf
#echo 'LC_TELEPHONE="en_US.UTF-8"' > /etc/locale.conf
#echo 'LC_MEASUREMENT="en_US.UTF-8"' > /etc/locale.conf
#echo 'LC_IDENTIFICATION="en_US.UTF-8"' > /etc/locale.conf
#echo 'LC_ALL=' > /etc/locale.conf
###
echo -e "${BLUE}:: ${NC}Вписываем KEYMAP=ru FONT=cyr-sun16 FONT=ter-v16n FONT=ter-v16b"
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo '#LOCALE=ru_RU.UTF-8' >> /etc/vconsole.conf
## Шрифт с поддержкой кирилицы
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf
echo '#FONT=ter-v16n' >> /etc/vconsole.conf
echo '#FONT=ter-v16b' >> /etc/vconsole.conf
echo '#FONT=ter-u16b' >> /etc/vconsole.conf
echo 'FONT_MAP=' >> /etc/vconsole.conf
echo '#CONSOLEFONT="cyr-sun16' >> /etc/vconsole.conf
echo 'CONSOLEMAP=' >> /etc/vconsole.conf
echo '#TIMEZONE=Europe/Moscow' >> /etc/vconsole.conf
echo '#HARDWARECLOCK=UTC' >> /etc/vconsole.conf
echo '#HARDWARECLOCK=localtime' >> /etc/vconsole.conf
echo '#USECOLOR=yes' >> /etc/vconsole.conf
echo 'COMPRESSION="lz4"' >> /etc/mkinitcpio.conf
#echo 'COMPRESSION="xz"' >> /etc/mkinitcpio.conf
echo 'COMPRESSION_OPTIONS=(-9)' >> /etc/mkinitcpio.conf
echo "vboxdrv" > /etc/modules-load.d/virtualbox.conf
###
## Список всех доступных русских раскладок клавиатуры
# ls /usr/share/kbd/keymaps/i386/qwerty/ru*
## Русская раскладка с переключением по Alt+Shift
#echo 'KEYMAP="ruwin_alt_sh-UTF-8"' > /etc/vconsole.conf
## аналогично вызову
# localectl set-keymap ruwin_alt_sh-UTF-8
#######################
clear
echo ""
echo -e "${BLUE}:: ${NC}Проверим корректность загрузки установленных микрокодов "
echo -e "${MAGENTA}=> ${NC}Если таковые (микрокод-ы: amd-ucode; intel-ucode) были установлены! "
echo " Если микрокод был успешно загружен, Вы увидите несколько сообщений об этом "
echo " Будьте внимательны! Вы можете пропустить это действие. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да проверим корректность загрузки,    0 - Нет пропустить: " x_ucode  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_ucode" =~ [^10] ]]
do
    :
done
 if [[ $x_ucode == 0 ]]; then
echo ""
echo " Проверка пропущена "
elif [[ $x_ucode == 1 ]]; then
echo ""
echo " Выполним проверку корректности загрузки установленных микрокодов "
dmesg | grep microcode
fi
sleep 04
###
echo ""
echo -e "${GREEN}==> ${NC}Установить Микрокод для процессора INTEL_CPU, AMD_CPU?"
echo -e "${BLUE}:: ${BOLD}Обновление Microcode (matching CPU) ${NC}"
echo -e "${BLUE}:: ${BOLD}Процессор — уникальный идентификационный номер каждого процессора, начиная с 0.
название модели — полное название процессора, включая марку процессора. После того, как вы точно узнаете, какой у вас тип ЦП, вы можете проверить в документации по продукту технические характеристики вашего процессора. ${NC}"
echo " Производители процессоров выпускают обновления стабильности и безопасности
        для микрокода процессора "
echo " Огласите весь список, пожалуйста! :) "
echo " 1 - Для процессоров AMD установите пакет amd-ucode . "
echo " 2 - Для процессоров Intel установите пакет intel-ucode . "
echo " 3 - Если Arch находится на съемном носителе, Вы должны установить микрокод для обоих производителей процессоров!!! "
echo -e "${GREEN}==> ${BOLD}Вот ВАШ процессор (название модели — полное название процессора),включая количество процессоров:${NC}"
grep -m 1 'model name' /proc/cpuinfo  # model name
# lscpu | grep -i 'Model name'  # BIOS Model name
# lscpu | grep -i "Model name:" | cut -d':' -f2- -   # model name
grep -c 'model name' /proc/cpuinfo  # распечатать количество процессоров
# lscpu | grep -i "CPU(s)"  # сведения о ЦП, например количество ядер ЦП
echo -e "${BLUE}:: ${BOLD} Для Arch Linux на съемном носителе добавьте оба файла initrd в настройки загрузчика!${NC}"
echo " Их порядок не имеет значения, если они оба указаны до реального образа initramfs. "
echo -e "${MAGENTA}=> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
echo " Будьте внимательны! Без этих обновлений Вы можете наблюдать ложные падения или неожиданные зависания системы, которые может быть сложно отследить. "
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Для процессоров AMD,           2 - Для процессоров INTEL,

    3 - Для процессоров AMD и INTEL,   0 - Нет Пропустить этот шаг: " prog_cpu  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_cpu" =~ [^1230] ]]
do
    :
done
if [[ $prog_cpu == 0 ]]; then
  echo ""
  echo " Установка микрокода процессоров пропущена "
elif [[ $prog_cpu == 1 ]]; then
  echo ""
  echo " Устанавливаем uCode для процессоров - AMD "
  pacman -S amd-ucode --noconfirm  # Образ обновления микрокода для процессоров AMD
  echo " Установлены обновления стабильности и безопасности для микрокода процессора - AMD "
  echo " После завершения установки пакета программного обеспечения нужно перезагрузить компьютер "
elif [[ $prog_cpu == 2 ]]; then
  echo ""
  echo " Устанавливаем uCode для процессоров - INTEL "
  pacman -S intel-ucode --noconfirm  # Образ обновления микрокода для процессоров INTEL
  pacman -S iucode-tool --noconfirm  # Инструмент для управления пакетами микрокода Intel® IA-32 / X86-64
  echo " Установлены обновления стабильности и безопасности для микрокода процессора - INTEL "
  echo " После завершения установки пакета программного обеспечения нужно перезагрузить компьютер "
elif [[ $prog_cpu == 3 ]]; then
  echo ""
  echo " Устанавливаем uCode для процессоров - AMD и INTEL "
  pacman -S amd-ucode intel-ucode --noconfirm  # Образ обновления микрокода для процессоров AMD и INTEL
  pacman -S iucode-tool --noconfirm  # Инструмент для управления пакетами микрокода Intel® IA-32 / X86-64
  echo " Установлены обновления стабильности и безопасности для микрокода процессоров - AMD и INTEL "
  echo " После завершения установки пакета программного обеспечения нужно перезагрузить компьютер "
fi
sleep 1
#####################
clear
echo ""
echo -e "${GREEN}==> ${NC}Создадим загрузочный RAM диск (начальный RAM-диск)"
echo -e "${MAGENTA}:: ${BOLD}Arch Linux имеет mkinitcpio - это Bash скрипт используемый для создания начального загрузочного диска системы. ${NC}"
echo -e "${CYAN}:: ${NC}mkinitcpio является модульным инструментом для построения initramfs CPIO образа, предлагая много преимуществ по сравнению с альтернативными методами. Предоставляет много возможностей для настройки из командной строки ядра без необходимости пересборки образа."
echo -e "${YELLOW}:: ${NC}Чтобы избежать ошибки при создании RAM (mkinitcpio -p), вспомните какое именно ядро Вы выбрали ранее. И загрузочный RAM диск (начальный RAM-диск) будет создан именно с таким же ядром, иначе 'ВАЙ ВАЙ'!"
echo " Будьте внимательными! Здесь представлены варианты создания RAM-диска, с конкретными ядрами. "
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "

    read -n1 -p "
    1 - для ядра LINUX,          2 - для ядра LINUX_HARDENED,

    3 - для ядра LINUX_LTS,      4 - для ядра LINUX_ZEN,

    0 - Пропустить создание загрузочного RAM диска: " x_ram  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_ram" =~ [^12340] ]]
do
    :
done
if [[ $x_ram == 1 ]]; then
  clear
  echo ""
  echo " Создадим загрузочный RAM диск - для ядра (linux) "
  mkinitcpio -p linux   # mkinitcpio -P linux  - при ошибке!
elif [[ $x_ram == 2 ]]; then
  clear
  echo ""
  echo " Создадим загрузочный RAM диск - для ядра (linux-hardened) "
  mkinitcpio -p linux-hardened
elif [[ $x_ram == 3 ]]; then
  clear
  echo ""
  echo " Создадим загрузочный RAM диск - для ядра (linux-lts) "
  mkinitcpio -p linux-lts
elif [[ $x_ram == 4 ]]; then
  clear
  echo ""
  echo " Создадим загрузочный RAM диск - для ядра (linux-zen) "
  mkinitcpio -p linux-zen
elif [[ $x_ram == 0 ]]; then
  echo " Создание загрузочного RAM диска пропущено "
fi
sleep 1
####################
clear
echo ""
echo -e "${GREEN}==> ${NC}Создаём root пароль (Root Password)"
echo " Пароль должен содержать от 6 до 15 символов, включающих цифры (1-0) и знаки (!'':[@]),
        и латинские буквы разного регистра! "
echo " Пароли позволяют следующее: Строчные буквы алфавита (a, b, c и т. д.) ; Заглавные буквы алфавита (A, B, C и т. д.) ;
       Числа (0, 1, 2 и т. д.) ; Специальные символы (@, %, ! и т. д.) для более подробной информации посетите https://help.ubuntu.com/community/StrongPasswords "
echo -e "${MAGENTA}=> ${BOLD}По умолчанию, на большинстве систем Linux в консоле не показывается введенный пароль.
Это сделано из соображений безопасности, чтобы никто не мог увидеть длину вашего пароля.${NC}"
echo " => Введите Root Password (Пароль суперпользователя), вводим пароль 2 раза "
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
passwd
# echo -e "${Yellow}Какой пароль должен быть у учетной записи root (администратора)?${NoColor}"
# read rootpassword; clear
###
clear
echo ""
echo -e "${GREEN}==> ${NC}Установить (bootloader) загрузчик GRUB(legacy)?"
echo -e "${BLUE}:: ${NC}Установка GRUB2 в процессе установки Arch Linux"
echo " 1 - Установка полноценной BIOS-версии загрузчика GRUB(legacy), тогда укажите "1" "
echo " Файлы загрузчика будут установлены в каталог /boot. Код GRUB (boot.img) будет встроен в начальный сектор, а загрузочный образ core.img в просвет перед первым разделом MBR, или BIOS boot partition для GPT. "
echo " 2 - Если нужно установить BIOS-версию загрузчика из-под системы, загруженной в режиме UEFI, тогда укажите "2" "
echo " В этом варианте требуется принудительно задать программе установки нужную сборку GRUB - "
echo -e "${CYAN} Пример: ${NC}grub-install --target=i386-pc /dev/sdX  (sda; sdb; sdc; sdd)"
echo -e "${YELLOW}:: ${BOLD}В этих вариантах большого отличия нет, кроме команд выполнения.
 Не зависимо от вашего выбора нужно ввести маркер sdX-диска куда будет установлен GRUB.${NC}"
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если у вас уже имеется BOOT раздел от другой (предыдущей) системы gnu-linux, с установленным на нём GRUB."
echo " Будьте внимательны! В этом действии выбор остаётся за вами. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить GRUB(legacy),    2 - GRUB --target=i386-pc,

    0 - Нет пропустить: " i_grub  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_grub" =~ [^120] ]]
do
    :
done
if [[ $i_grub == 1 ]]; then
  echo ""
  pacman -Syy  # обновление баз пакмэна (pacman)
  pacman -S grub --noconfirm  # Файлы и утилиты для установки GRUB2 содержатся в пакете grub
# pacman -S --noconfirm --needed grub  # GNU GR и унифицированный загрузчик (2)
  pacman -S libisoburn --noconfirm  # Интерфейс для библиотек libburn и libisofs; https://dev.lovelyhq.com/libburnia
  pacman -S dosfstools --noconfirm  # Утилиты файловой системы DOS; Для поддержки grub-mkrescue FAT FS и EFI; https://github.com/dosfstools/dosfstools
  uname -rm  # для определения архитектуры процессора, имени хоста системы и версии ядра, работающего в системе
  lsblk -f  # Команда lsblk выводит список всех блочных устройств
  echo ""
  echo -e "${YELLOW}=> Примечание: ${BOLD}/dev/sdX - диск (не раздел), на котором должен быть установлен GRUB. ${NC}"
  echo ""
# Если вы используете LVM для вашего /boot, вы можете установить GRUB на нескольких физических дисках.
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
  read -p " => Укажите диск куда установить GRUB (sda/sdb например sda или sdb) : " x_cfd  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
  grub-install /dev/$x_cfd  # Записываем загрузчик в MBR (Master Boot Record) нашего внутреннего накопителя (sda; sdb; sdc; sdd)
# grub-install --recheck /dev/$x_cfd  # Если Вы получили сообщение об ошибке (--recheck - удалить существующую карту устройств)
# grub-install --boot-directory=/mnt/boot /dev/$x_cfd  # установить файлы загрузчика в другой каталог
# echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub
  sed -i 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub
  echo " Загрузчик GRUB установлен на выбранный вами диск (раздел). "
elif [[ $i_grub == 2 ]]; then
  echo ""
  pacman -Syy  # обновление баз пакмэна (pacman)
  pacman -S grub --noconfirm  # Файлы и утилиты для установки GRUB2 содержатся в пакете grub
  uname -rm  # для определения архитектуры процессора, имени хоста системы и версии ядра, работающего в системе
  lsblk -f # Команда lsblk выводит список всех блочных устройств
  echo ""
  echo -e "${YELLOW}=> Примечание: ${BOLD}/dev/sdX - диск (а не раздел ), на котором должен быть установлен GRUB. ${NC}"
  echo ""
# Если вы используете LVM для вашего /boot, вы можете установить GRUB на нескольких физических дисках.
  echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
  read -p " => Укажите диск куда установить GRUB (sda/sdb например sda или sdb) : " x_cfd # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
# Если нужно установить BIOS-версию загрузчика из-под системы, загруженной в режиме UEFI
  grub-install --target=i386-pc /dev/$x_cfd  # Записываем загрузчик в MBR (Master Boot Record) нашего внутреннего накопителя (sda; sdb; sdc; sdd)
# grub-install --target=i386-pc --recheck /dev/$x_cfd   # Если Вы получили сообщение об ошибке
# grub-install --target=i386-pc --force --recheck /dev/$x_cfd
#echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub
# sed -i 's/# GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/sudoers
  sed -i 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/g' /etc/default/grub   # # добавить в загрузчик grub другие os или раскомментить строку GRUB_DISABLE_OS_PROBER  в /etc/default/grub
# sed -i 's/#GRUB_DISABLE_OS_PROBER=false\n/g' /etc/pacman.conf
  echo " Загрузчик GRUB установлен на выбранный вами диск (раздел) "
elif [[ $i_grub == 0 ]]; then
  echo ""
  echo " Операция установки загрузчик GRUB пропущена "
fi
sleep 2
###
clear
echo ""
echo -e "${GREEN}==> ${NC}Если на компьютере будут несколько ОС (dual_boot), то это также ставим."
echo -e "${CYAN}:: ${NC}Это утилиты для обнаружения других ОС на наборе дисков, для доступа к дискам MS-DOS, а также библиотека, позволяющая реализовать файловую систему в программе пользовательского пространства."
echo -e "${YELLOW}=> ${NC}Для двойной загрузки Arch Linux с другой системой Linux, Windows, установить другой Linux без загрузчика, вам необходимо установить утилиту os-prober, необходимую для обнаружения других операционных систем."
echo " И обновить загрузчик Arch Linux, чтобы иметь возможность загружать новую ОС."
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Да установить,    0 - Нет пропустить: " dual_boot   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$dual_boot" =~ [^10] ]]
do
    :
done
if [[ $dual_boot  == 1 ]]; then
  echo ""
  echo " Устанавливаем программы (пакеты) для определения другой-(их) OS "
  pacman -S os-prober mtools fuse --noconfirm  #grub-customizer  # Утилита для обнаружения других ОС на наборе дисков; Сборник утилит для доступа к дискам MS-DOS;
  echo " Программы (пакеты) установлены "
elif [[ $dual_boot  == 0 ]]; then
  echo ""
  echo " Установка программ (пакетов) пропущена. "
fi
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Обновляем grub.cfg (Сгенерируем grub.cfg)"
grub-mkconfig -o /boot/grub/grub.cfg   # создаём конфигурационный файл
sleep 1
###
clear
echo ""
echo -e "${GREEN}==> ${NC}Установить программы (пакеты) для Wi-fi?"
echo -e "${CYAN}:: ${NC}Если у Вас есть Wi-fi модуль и Вы сейчас его не используете, но будете использовать в будущем."
echo " Или Вы подключены через Wi-fi, то эти (пакеты) обязательно установите. "
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Да установить,    0 - Нет пропустить: " i_wifi   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_wifi" =~ [^10] ]]
do
    :
done
if [[ $i_wifi  == 1 ]]; then
  echo ""
  echo " Устанавливаем программы (пакеты) для Wi-fi "
  pacman -S dialog wpa_supplicant iw wireless_tools net-tools --noconfirm  # Инструмент для отображения диалоговых окон из сценариев оболочки; Утилита, обеспечивающая согласование ключей для беспроводных сетей WPA; Утилита настройки интерфейса командной строки на основе nl80211 для беспроводных устройств; Инструменты, позволяющие управлять беспроводными расширениями; Инструменты настройки для сети Linux.
  echo " Программы (пакеты) для Wi-fi установлены "
elif [[ $i_wifi  == 0 ]]; then
  echo ""
  echo " Установка программ (пакетов) пропущена. "
fi
sleep 1
###
clear
echo ""
echo -e "${GREEN}==> ${NC}Добавляем пользователя и прописываем права, (присвоение) групп. "
echo -e "${MAGENTA}=> ${BOLD}В сценарии (скрипта) прописано несколько вариантов! ${NC}"
echo -e "${CYAN}:: ${BOLD}Для создания нового пользователя воспользуемся командой useradd:
# useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,scanner -s /bin/bash newuser ${NC}"
echo " Расшифровка команды: "
echo " # useradd -m -g [основная группа] -G [список дополнительных групп] -s [командный интерпретатор] [имя пользователя] "
echo " -m — создаёт домашний каталог, вида /home/[имя пользователя]. "
echo " -g — имя или номер основной группы пользователя. "
echo " -G — список дополнительных групп, в которые входит пользователь. "
echo " -s — определяет командную оболочку пользователя /bin/bash . "
echo -e "${CYAN}:: ${BOLD}Давайте рассмотрим варианты (действия), которые будут выполняться: ${NC}"
echo " 1 - Добавляем пользователя, прописываем права, и добавляем группы : "
echo " (audio,games,lp,disk,network,optical,power,scanner,storage,video,rfkill,sys,wheel) "
echo " 2 - Добавляем пользователя, прописываем права, и добавляем группы : "
echo " (adm + audio,games,lp,disk,network,optical,power,scanner,storage,video,rfkill,sys,wheel) "
echo " 3 - Добавляем пользователя, прописываем права, и добавляем пользователя в группу : "
echo " (wheel), то выбирайте вариант - "3" "
echo -e "${CYAN}:: ${BOLD}Далее, пользователь из установленной системы добавляет себя любимого(ую), в нужную группу /etc/group.${NC}"
echo -e "${YELLOW}=> Вы НЕ можете пропустить этот шаг (пункт)! ${NC}"
echo " Будьте внимательны! В этом действии выбор остаётся за вами."
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Группы (audio,games,lp,disk,network,optical,power,scanner,storage,video,rfkill,sys,wheel),

    2 - Группы (adm + audio,games,lp,disk,network,optical,power,scanner,storage,video,rfkill,sys,wheel),

    3 - Вы выбрали группу (wheel): " i_groups  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_groups" =~ [^123] ]]
do
    :
done
if [[ $i_groups  == 1 ]]; then
  useradd -m -g users -G audio,games,lp,disk,network,optical,power,scanner,storage,video,rfkill,sys,wheel -s /bin/bash $username
  usermod -a -G audio,games,lp,disk,network,optical,power,scanner,storage,video,rfkill,sys,wheel $username
  userdbctl groups-of-user $username
  clear
  echo ""
  echo " Пользователь успешно добавлен в группы и права пользователя "
elif [[ $i_groups  == 2 ]]; then
  useradd -m -g users -G adm,audio,games,lp,disk,network,optical,power,scanner,storage,video,rfkill,sys,wheel -s /bin/bash $username
  clear
  echo ""
  echo " Пользователь успешно добавлен в группы и права пользователя "
elif [[ $i_groups  == 3 ]]; then
  useradd -m -g users -G wheel -s /bin/bash $username
  clear
  echo ""
  echo " Пользователь успешно добавлен в группы и права пользователя "
fi
######
echo ""
echo -e "${GREEN}==> ${NC}Устанавливаем пароль пользователя (User Password)"
echo " Пароль должен содержать от 6 до 15 символов, включающих цифры (1-0) и знаки (!'':[@]),
        и латинские буквы разного регистра! "
echo -e "${MAGENTA}=> ${BOLD}По умолчанию, на большинстве систем Linux в консоле не показывается введенный пароль.
Это сделано из соображений безопасности, чтобы никто не мог увидеть длину вашего пароля.${NC}"
echo " => Введите User Password (Пароль пользователя) - для $username, вводим пароль 2 раза "
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
passwd $username
# echo -e "Какой пароль должен быть у юзера ${username}?"
# read userpassword; clear
###
echo ""
echo -e "${BLUE}:: ${NC}Проверим статус пароля для всех учетных записей пользователей в вашей системе"
echo -e "${CYAN}:: ${NC}В выведенном списке те записи, которые сопровождены значением (лат.буквой) P - значит на этой учетной записи установлен пароль!"
echo -e "${CYAN} Пример: ${NC}(root P 10/11/2020 -1 -1 -1 -1; или $username P 10/11/2020 0 99999 7 -1)"
passwd -Sa  # -S, --status вывести статус пароля
###
echo ""
echo -e "${GREEN}==> ${NC}Информация о пользователе (полное имя пользователя и связанная с ним информация)"
echo -e "${CYAN}:: ${NC}Пользователь в Linux может хранить большое количество связанной с ним информации, в том числе номера домашних и офисных телефонов, номер кабинета и многое другое."
echo " Мы обычно пропускаем заполнение этой информации (так как всё это необязательно) - при создании пользователя. "
echo -e "${CYAN}:: ${NC}На первом этапе достаточно имени пользователя, и подтверждаем - нажмите кнопку 'Ввод'(Enter)."
echo " Ввод другой информации (Кабинет, Телефон в кабинете, Домашний телефон) можно пропустить - просто нажмите 'Ввод'(Enter). "
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Вводим информация о пользователе,    0 - Пропустить этот шаг: " i_finger   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_finger" =~ [^10] ]]
do
    :
done
if [[ $i_finger == 1 ]]; then
  echo ""
  echo " Информация о my username : (достаточно имени) "
  chfn $username
elif [[ $i_finger == 0 ]]; then
  echo ""
  echo " Настройка пропущена "
fi
###
echo ""
echo -e "${BLUE}:: ${NC}Устанавливаем (пакет) SUDO."
echo -e "${CYAN}=> ${NC}Пакет sudo позволяет системному администратору предоставить определенным пользователям (или группам пользователей) возможность запускать некоторые (или все) команды в роли пользователя root или в роли другого пользователя, указываемого в командах или в аргументах."
pacman -S --noconfirm --needed sudo  # возможность запускать некоторые команды от имени пользователя root
# pacman -S sudo --noconfirm  # - пока присутствует в pkglist.x86_64
###
clear
echo ""
echo -e "${GREEN}==> ${NC}Настраиваем запрос пароля "Пользователя" при выполнении команды "sudo". "
echo " Чтобы начать использовать sudo как непривилегированный пользователь, его нужно настроить должным образом. "
echo " Огласите весь список, пожалуйста! :) "
echo " 1 - Пользователям (членам) группы wheel доступ к sudo С запросом пароля "
echo " 2 - Пользователям (членам) группы wheel доступ к sudo (NOPASSWD) БЕЗ запроса пароля "
echo -e "${RED}==> ${BOLD}Выбрав '2' (раскомментировав) данную опцию, особых требований к безопасности нет, но может есть какие-то очень негативные моменты в этом?... ${NC}"
echo " 3-(0) - Добавление настроек sudo пропущено "
echo " Далее все настройки в файле /etc/sudoers пользователь произведёт сам(а) "
echo " Например: под строкой root ALL=(ALL:ALL) ALL  - пропишет -  $username ALL=(ALL) ALL "
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами."
echo -e "${CYAN}:: ${NC}На данном этапе порекомендую вариант "1" (sudo С запросом пароля) "
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - С запросом пароля,    2 - БЕЗ запроса пароля,

    0 - Пропустить этот шаг: " i_sudo  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_sudo" =~ [^120] ]]
do
    :
done
if [[ $i_sudo  == 0 ]]; then
  clear
  echo ""
  echo " Добавление настройки sudo пропущено "
elif [[ $i_sudo  == 1 ]]; then
  echo ""
  echo " Резервное копирование исходного файла Sudoers..."
  cp -v /etc/sudoers /etc/sudoers.original  # -v или --verbose -Выводить информацию о каждом файле, который обрабатывает команда cp.
echo " Права доступа к файлам Sudoers "
### И владелец, и группа для sudoers файла должны быть равны 0. Права доступа к файлу должны быть установлены на 0440. Эти разрешения установлены по умолчанию, но если вы случайно измените их, их следует немедленно изменить обратно, иначе sudo завершится ошибкой.
# chown -c root:root /etc/sudoers  # Команда chown используется для изменения владельца и группы владельцев файла
# chmod -c 0440 /etc/sudoers  # Права доступа к файлам Sudoers
  chmod 0440 /etc/sudoers  # 0440 даст владельцу (root) и группе права на чтение
# chmod 0700 /etc/sudoers  # 0700 даст владельцу (root) права на чтение, запись и выполнение
# chmod +w /etc/sudoers    # Если запись в файл не разрешена, то надо выставить дополнительное право
  {
    echo ""
    echo '%wheel ALL=(ALL) ALL'
  } >>/etc/sudoers
#  echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
#  sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
#  sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers  # Раскомментируйте, чтобы разрешить членам группы wheel выполнять любую команду
# sed -i 's/# %sudo ALL=(ALL) ALL/%sudo ALL=(ALL) ALL/' /etc/sudoers
#####
# Эта конфигурация особенно полезна для тех, кто использует терминальные мультиплексоры, такие как screen, tmux или rat poison, а также для тех, кто использует sudo из scripts / cronjobs:
# This config is especially helpful for those using terminal multiplexers like screen, tmux, or ratpoison, and those using sudo from scripts/cronjobs:
  {
    echo ""
    echo 'Defaults !requiretty, !tty_tickets, !umask'
    echo 'Defaults visiblepw, path_info, insults, lecture=always'
    echo 'Defaults loglinelen=0, logfile =/var/log/sudo.log, log_year, log_host, syslog=auth'
    echo 'Defaults passwd_tries=3, passwd_timeout=1'
    echo 'Defaults env_reset, always_set_home, set_home, set_logname'
    echo 'Defaults !env_editor, editor="/usr/bin/vim:/usr/bin/vi:/usr/bin/nano"'
    echo 'Defaults timestamp_timeout=15'
    echo 'Defaults passprompt="[sudo] password for %u: "'
    echo 'Defaults lecture=never'
  } >>/etc/sudoers
### <<<  sudo и %wheel ALL=(ALL) NOPASSWD: ALL   >>> ####
### Кстати, рекомендую добавить запрет выполнения нескольких команд -
### чтобы не было возможности стать рутом через $sudo su (многи об этой фиче забывают)!
  {
    echo ""
    echo '## Groups of commands.  Often used to group related commands together.'
    echo '# Cmnd_Alias SHELLS = /bin/sh,/bin/csh,/usr/local/bin/tcsh'
    echo '# Cmnd_Alias SSH = /usr/bin/ssh'
    echo '# Cmnd_Alias SU = /bin/su'
    echo '# dreamer ALL = (ALL) NOPASSWD: ALL,!SU,SHELLS,!SSH'
  } >>/etc/sudoers
###
### Второй способ:  --(Но в этом случае при запросе пароля USER - вводим пароль ROOT)!!!
#   echo -e "${RED}Добавление "${username}" в sudoers.${NC}\n"
#   echo -e "%wheel ALL=(ALL) ALL\nDefaults rootpw" > /etc/sudoers.d/99_wheel
#   echo -e "${RED}"${username}" теперь является частью группы ${WHITE}%wheel.${NC}\n"
  clear
  echo ""
  echo " Sudo с запросом пароля выполнено "
  ###
  echo ""
  echo -e "${BLUE}:: ${NC}Просмотреть содержимое файла Sudoers"
  cat /etc/sudoers  # cat читает данные из файла или стандартного ввода и выводит их на экран
  sleep 02
elif [[ $i_sudo  == 2 ]]; then
  echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
# sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
###
### Второй способ:  --(Но в этом случае запроса пароля USER - НЕ Будет)!!!
#   echo -e "${RED}Добавление "${username}" в sudoers.${NC}\n"
#   echo -e "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/g_wheel
#   echo -e "${RED}"${username}" теперь является частью группы ${WHITE}%wheel.${NC}\n"
  clear
  echo ""
  echo " Sudo nopassword (БЕЗ запроса пароля) добавлено  "
fi
###
echo ""
echo -e "${GREEN}==> ${NC}Добавим репозиторий "Multilib" - Для работы 32-битных приложений в 64-битной системе?"
echo -e "${BLUE}:: ${NC}Раскомментируем репозиторий [multilib]"
echo -e "${CYAN}:: ${BOLD}"Multilib" репозиторий может пригодится позже при установке OpenGL (multilib) для драйверов видеокарт, а также для различных библиотек необходимого вам софта. ${NC}"
echo " Чтобы исключить в дальнейшем ошибки в работе системы, рекомендую вариант "1" (добавить Multilib репозиторий). "
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Да добавить Multilib репозиторий

    0 - Нет пропустить настройку : " i_multilib   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_multilib" =~ [^10] ]]
do
    :
done
if [[ $i_multilib  == 0 ]]; then
# clear
  echo ""
  echo " Добавление Multilib репозитория пропущено "
elif [[ $i_multilib  == 1 ]]; then
  echo ""
  echo " Резервное копирование исходного файла /etc/pacman.conf "
  cp /etc/pacman.conf /etc/pacman.conf.backup  # Всегда, сначала сделайте резервную копию вашего pacman.config файла
# cp -v /etc/pacman.conf /etc/pacman.conf.bkp  # -v или --verbose -Выводить информацию о каждом файле, который обрабатывает команда cp.
  echo " Раскрашивание вывода pacman и pacman easter egg (меняет индикатор выполнения на Pac-Man) "
### Color - Автоматически включать цвета только тогда, когда вывод pacman на tty.
  sed -i 's/#Color/Color/' /etc/pacman.conf  # Чтобы раскрасить вывод pacman, раскомментируем в /etc/pacman.conf строчку Color
# sed -i '/#Color/ s/^#//' /etc/pacman.conf
### ILoveCandy - Потому что Pac-Man любит конфеты.
  sed -i '/^Co/ aILoveCandy' /etc/pacman.conf  # pacman easter egg (меняет индикатор выполнения на Pac-Man)
# sed -i 's/VerbosePkgLists/VerbosePkgLists\nILoveCandy/g' /etc/pacman.conf
### Второй способ:  --(Но)!!!
## sed -i 's/VerbosePkgLists/VerbosePkgLists\nILoveCandy/g' /etc/pacman.conf
## sudo sed -i '/^\#VerbosePkgLists/aILoveCandy' /etc/pacman.conf  # pacman progress indicator
## sed -i 's/#Color/Color/g' /etc/pacman.conf  # pacman colors
### VerbosePkgLists - Отображает имя, версию и размер целевых пакетов в виде таблицы для операций обновления, синхронизации и удаления.
  sed -i 's/#VerbosePkgLists/VerbosePkgLists\n/g' /etc/pacman.conf
### Параллельная загрузка pacman (ParallelDownloads = ...)
### Указывает количество одновременных потоков загрузки. Значение должно быть положительным целым числом. Если этот параметр конфигурации не установлен, то используется только один поток загрузки (т.е. загрузки происходят последовательно).
# ParallelDownloads = 5
  sed -i 's/#ParallelDownloads/ParallelDownloads/g' /etc/pacman.conf
# sed -i s/'#ParallelDownloads = 5'/'ParallelDownloads = 5'/g /etc/pacman.conf
### MultiLib (Include= /path/to/config/file) - Этот файл может включать репозитории или общие параметры конфигурации.
  sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
###  Если вы имеете плохое качество соединения или слабый уровень сигнала, то при загрузке пакетов при помощи pacman вы могли сталкиваться с ошибкой превышания лимитов ожидания (таймаутов)
### Она задает загрузчик, по умолчанию wget, и параметры к нему
  echo '#DisableDownloadTimeout' >> /etc/pacman.conf
  echo '#XferCommand = /usr/bin/wget --timeout=40 --tries=0 --passive-ftp -c -O %o %u' >> /etc/pacman.conf
  echo ""
  echo " Multilib репозиторий добавлен (раскомментирован) "
fi
###
echo -e "${CYAN}:: ${BOLD}Включим подсветку синтаксиса в Nano (/etc/nanorc для общесистемных настроек). ${NC}"
echo " Резервное копирование исходного файла /etc/nanorc "
cp /etc/nanorc /etc/nanorc.backup
# cp -v /etc/nanorc /etc/nanorc.backup  # -v или --verbose -Выводить информацию о каждом файле, который обрабатывает команда cp.
echo " Активируем цветовой режим, предустановленный в файлах "
# cat /usr/share/nano/*.nanorc
  {
    echo ""
    echo 'include "/usr/share/nano/*.nanorc"'
  } >>/etc/nanorc
###
echo ""
echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов"
pacman -Sy   #--noconfirm --noprogressbar --quiet (обновить списки пакетов из репозиториев)
#pacman -Syy --noconfirm --noprogressbar --quiet (обновление баз пакмэна - pacman)
sleep 1
#####################
clear
echo ""
echo -e "${GREEN}==> ${NC}Устанавливаем X.Org Server (иксы) и драйвера."
echo -e "${YELLOW}:: ${BOLD}X.Org Foundation Open Source Public Implementation of X11 - это свободная открытая реализация оконной системы X11.${NC}"
echo " Xorg очень популярен среди пользователей Linux, что привело к тому, что большинство приложений с графическим интерфейсом используют X11, из-за этого Xorg доступен в большинстве дистрибутивов. "
echo -e "${BLUE}:: ${NC}Сперва определим вашу видеокарту!"
echo -e "${MAGENTA}=> ${BOLD}Вот данные по вашей видеокарте (даже, если Вы работаете на VM): ${NC}"
#echo ""
lspci | grep -e VGA -e 3D
#lspci | grep -E "VGA|3D"   # узнаем производителя и название видеокарты
#lspci -v | grep -A 3 VGA
lspci -nn | grep VGA
#lspci | grep VGA        # узнаем ID шины
# После того как вы узнаете PCI-порт видеокарты, например 1с:00.0, можно получить о ней более подробную информацию:
# sudo lspci -v -s 1с:00.0
echo ""
echo -e "${RED}==> ${NC}Куда Вы устанавливаете Arch Linux на PC, или на Виртуальную машину (VBox;VMWare)?"
echo " Для того, чтобы ускорение видео работало, и часто для того, чтобы разблокировать все режимы, в которых может работать GPU (графический процессор), требуется правильный видеодрайвер. "
echo -e "${MAGENTA}=> ${BOLD}Есть три варианта установки Xorg (иксов): ${NC}"
echo " Давайте проанализируем действия, которые будут выполняться. "
echo " 1 - Если Вы устанавливаете Arch Linux на PC, то выбирайте вариант - "1" "
echo " 2 - Если Вы устанавливаете Arch Linux на Виртуальную машину (VBox;VMWare), то ваш вариант - "2" "
echo " 3(0) - Вы можете пропустить установку Xorg (иксов), если используете VDS (Virtual Dedicated Server), или VPS (Virtual Private Server), тогда выбирайте вариант - "0" "
echo " VPS (Virtual Private Server) обозначает виртуализацию на уровне операционной системы, VDS (Virtual Dedicated Server) - аппаратную виртуализацию. Оба термина появились и развивались параллельно, и обозначают одно и то же: виртуальный выделенный сервер, запущенный на базе физического. "
echo " Будьте внимательны! Процесс установки Xorg (иксов) не был прописан полностью автоматическим, и было принято решение дать возможность пользователю сделать выбор. Вас спросят, устанавливать ли все пакеты, я устанавливал все, просто нажмите Enter. В любой ситуации выбор всегда остаётся за вами. "
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Устанавливаем на PC или (ноутбук),    2 - Устанавливаем на VirtualBox(VMWare),

    0 - Пропустить (используется VDS, или VPS): " vm_setting  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$vm_setting" =~ [^120] ]]
do
    :
done
if [[ $vm_setting == 0 ]]; then
# echo ""
  echo " Установка Xorg (иксов) пропущена (используется VDS, или VPS) "
elif [[ $vm_setting == 1 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit"  # xorg-xwayland (или на vmware) # --confirm всегда спрашивать подтверждение;  X-сервер Xorg (https://xorg.freedesktop.org ; https://archlinux.org/packages/extra/x86_64/xorg-server/); Заменяет: glamor-egl, xf86-video-modesetting ; Конфликты: с glamor-egl, nvidia-utils<=331.20, xf86-video-modesetting ; 2025-06-24 18:19 UTC . Группа драйверов ; Group Details - (https://archlinux.org/groups/x86_64/xorg-drivers/). Программа инициализации X.Org (https://xorg.freedesktop.org ; https://archlinux.org/packages/extra/x86_64/xorg-xinit/) ; 2025-03-13 07:25 UTC
# gui_install="xorg-drivers --noconfirm"  #  Group Details - https://archlinux.org/groups/x86_64/xorg-drivers/
# gui_install="xf86-input-libinput --noconfirm"  #  Универсальный драйвер ввода для сервера X.Org на основе libinput (http://xorg.freedesktop.org/)
# gui_install="xf86-input-synaptics --noconfirm"  #  Драйвер Synaptics для сенсорных панелей ноутбуков (http://xorg.freedesktop.org/)
elif [[ $vm_setting == 2 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils"  #(или на vmware) # --confirm всегда спрашивать подтверждение ; Утилиты гостевого пользовательского пространства VirtualBox ; https://archlinux.org/packages/extra/x86_64/virtualbox-guest-utils/ ; https://virtualbox.org/ ; Заменяет: virtualbox-archlinux-additions, virtualbox-guest-additions, virtualbox-guest-dkms ; Конфликты: с virtualbox-archlinux-additions, virtualbox-guest-additions, virtualbox-guest-dkms, virtualbox-guest-utils-nox ; Обратные конфликты: virtualbox-guest-utils-nox ; 2025-06-03 20:11 UTC
# gui_install="xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils --noconfirm"
# gui_install="virtualbox-guest-utils-nox --noconfirm"  # Утилиты гостевого пространства VirtualBox без поддержки X ; https://archlinux.org/packages/extra/x86_64/virtualbox-guest-utils-nox/ ; https://virtualbox.org/ ; Заменяет: virtualbox-guest-dkms ; Конфликты: с virtualbox-guest-dkms, virtualbox-guest-utils ; Обратные конфликты: с virtualbox-guest-utils ; 2025-06-03 20:11 UTC
fi
##
echo ""
echo -e "${BLUE}:: ${NC}Ставим иксы и драйвера"
echo " Выберите свой вариант (от 1-...), или по умолчанию нажмите кнопку 'Ввод' ("Enter") "
echo " Далее после своего сделанного выбора, нажмите "Y или n" для подтверждения установки. "
pacman -S $gui_install   # --confirm   всегда спрашивать подтверждение
echo ""
pacman -Syy --noconfirm --noprogressbar --quiet
sleep 1
######################
clear
echo ""
echo -e "${GREEN}==> ${NC}Ставим DE (графическое окружение) среда рабочего стола."
echo " DE (от англ. desktop environment - среда рабочего стола), это обёртка для ядра Linux, предоставляющая основные функции дистрибутива в удобном для конечного пользователя наглядном виде (окна, кнопочки, стрелочки и пр.). "
echo -e "${MAGENTA}=> ${BOLD}Среда рабочего стола объединяет множество компонентов для предоставления общих элементов графического пользовательского интерфейса, таких как значки, панели инструментов, обои и виджеты рабочего стола. Кроме того, большинство сред рабочего стола включают набор интегрированных приложений и утилит. Что наиболее важно, окружения рабочего стола предоставляют собственный оконный менеджер, который однако, обычно можно заменить другим совместимым. ${NC}"
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В этом действии выбор остаётся за вами. "
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - KDE (Plasma) - Plasma предлагает все инструменты, необходимые для современного настольного компьютера

    2 - Xfce - Xfce воплощает традиционную философию UNIX

    3 - GNOME - это привлекательный и интуитивно понятный рабочий стол с современным (GNOME)

    4 - LXDE - облегченная среда рабочего стола X11 - это быстрая и энергосберегающая среда

    5 - Deepin - настольный интерфейс и приложения Deepin имеют интуитивно понятный и элегантный дизайн

    6 - Mate - предоставляет пользователям Linux интуитивно понятный и привлекательный рабочий стол

    7 - Lxqt - это порт Qt и будущая версия LXDE, облегченной среды рабочего стола

    8 - i3 - (конфиги стандартные, возможна установка с автовходом)

    0 - Пропустить установку: " x_de  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_de" =~ [^123456780] ]]
do
    :
done
if [[ $x_de == 0 ]]; then
  echo ""
  echo " Установка DE (среда рабочего стола) была пропущена "
elif [[ $x_de == 1 ]]; then
  echo " Установка KDE(Plasma) "
  pacman -S plasma plasma-meta plasma-pa plasma-desktop kde-system-meta kde-utilities-meta kio-extras konsole  kwalletmanager kio-admin --noconfirm  # Мета-пакет для установки KDE Plasma; Апплет Plasma для управления громкостью звука с помощью PulseAudio; Рабочий стол KDE Plasma; Мета-пакет для системных приложений KDE; Мета-пакет для служебных приложений KDE; Дополнительные компоненты для увеличения функциональности KIO; Инструмент управления кошельком; Эмулятор терминала KDE.
# pacman -S --noconfirm --needed tellico  # Менеджер коллекций для KDE ; https://tellico-project.org/ ; https://archlinux.org/packages/extra/x86_64/tellico/
# yay -S latte-dock --noconfirm --needed  #  Док на основе Plasma Frameworks ; https://aur.archlinux.org/latte-dock.git (read-only, click to copy) ; https://aur.archlinux.org/latte-dock-git.git (read-only, click to copy) ; https://invent.kde.org/plasma/latte-dock
# Minimal KDE
# pacman -S plasma plasma-meta  # konsole dolphin kmix discover packagekit-qt5
# Install kde application
# pacman -S kde-applications kde-applications-meta
# pacman -S kde-applications --noconfirm  # Мета-пакет для приложений KDE (для различных приложений KDE)
# pacman -S gwenview --noconfirm  # Быстрый и простой в использовании просмотрщик изображений (https://apps.kde.org/gwenview/)
# pacman -S plasma-framework --noconfirm  # Библиотека Plasma и компоненты времени выполнения на основе KF5 и Qt5
## pacman -S kde-applications-meta --noconfirm  # Мета-пакет для приложений KDE
### pacman -S --noconfirm --needed alsa-firmware alsa-utils arj ark bluedevil breeze-gtk ccache cups-pdf cups-pk-helper dolphin-plugins e2fsprogs efibootmgr fdkaac ffmpegthumbs firefox git glibc-locales gst-libav gst-plugin-libcamera gst-plugin-msdk gst-plugin-opencv gst-plugin-pipewire gst-plugin-qmlgl gst-plugin-va gst-plugin-wpe gst-plugins-ugly gstreamer-vaapi htop icoutils ipp-usb irqbalance kamera kamoso kate kcalc kde-gtk-config kdegraphics-mobipocket kdegraphics-thumbnailers kdenetwork-filesharing kdeplasma-addons kdesdk-kio kdesdk-thumbnailers kdialog keditbookmarks kget kimageformats kinit kio-admin kio-gdrive kio-zeroconf kompare konsole kscreen kvantum kwrited libappimage libfido2 libktorrent libmms libnfs libva-utils lirc lrzip lua52-socket lzop mac man-db man-pages mesa-demos mesa-utils mold nano-syntax-highlighting nss-mdns ntfs-3g okular opus-tools p7zip packagekit-qt6 pacman-contrib partitionmanager pbzip2 pdfmixtool pigz pipewire-alsa pipewire-pulse plasma-browser-integration plasma-desktop plasma-disks plasma-firewall plasma-nm plasma-pa plasma-wayland-protocols power-profiles-daemon powerdevil powerline powerline-fonts print-manager python-pyqt6 python-reportlab qbittorrent qt6-imageformats qt6-scxml qt6-virtualkeyboard realtime-privileges reflector rng-tools sddm-kcm skanlite sof-firmware sox spectacle sshfs system-config-printer terminus-font timidity++ ttf-ubuntu-font-family unarchiver unrar unzip usb_modeswitch usbutils vdpauinfo vlc vorbis-tools vorbisgain wget xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-kde zip zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting
# yay -S xsane --noconfirm
### pacman -S --noconfirm --needed exfatprogs
  clear
  echo ""
  echo " DE (Plasma KDE) успешно установлено "
  echo ""
  echo -e "${GREEN}==> ${NC}Настройка автовхода без DM (Display manager) менеджера входа в KDE(Plasma)"
  echo " Давайте проанализируем действия, которые выполняются. "
  echo " 1 - Если вам нужен автовход без DM (Display manager), тогда укажите "1" "
  echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
  echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
  echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" "
  echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
  echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
  echo ""
while
    echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Да нужен автовход без DM (Display manager),

    0 - Нет буду использовать DM (Display manager): " i_kde   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_kde" =~ [^10] ]]
do
    :
done
if [[ $i_kde  == 0 ]]; then
  echo " Буду использовать DM (Display manager) "
elif [[ $i_kde  == 1 ]]; then
  echo ""
  echo " Действия по настройке автовхода без DM (Display manager) "
  echo " Поскольку реализация автозагрузки окружения реализована через startx - (иксы), то если Вы установили X.Org Server возможно пакет (xorg-xinit) - уже установлен "
  pacman -S xorg-xinit --noconfirm
  cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc
  chown $username:users /home/$username/.xinitrc
  chmod +x /home/$username/.xinitrc
  sed -i 52,55d /home/$username/.xinitrc
  echo "exec startplasma-x11 " >> /home/$username/.xinitrc
  mkdir /etc/systemd/system/getty@tty1.service.d/
  echo " [Service] " > /etc/systemd/system/getty@tty1.service.d/override.conf
  echo " ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
  echo   ExecStart=-/usr/bin/agetty --autologin $username --noclear %I 38400 linux >> /etc/systemd/system/getty@tty1.service.d/override.conf
  echo ' [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx ' >> /etc/profile
  echo ""
  echo " Действия по настройке автовхода без DM (Display manager) выполнены "
fi
## Раскомментируйте, если установлен пакет (kde-applications)
### pacman -R konqueror --noconfirm  # Файловый менеджер и веб-браузер KDE # (-R --remove) - Удалить пакет(ы) из системы, но пакет konqueror - ужу отсутствует в системе!
clear
elif [[ $x_de == 2 ]]; then
  echo ""
  echo " Установка Xfce + Goodies for Xfce "
  pacman -S xfce4 xfce4-goodies --noconfirm  # Нетребовательное к ресурсам окружение рабочего стола для UNIX-подобных операционных систем; Проект Xfce Goodies Project включает дополнительное программное обеспечение и изображения, которые связаны с рабочим столом Xfce , но не являются частью официального выпуска.
  pacman -S --noconfirm --needed xfce4-pulseaudio-plugin  # Плагин Pulseaudio для панели Xfce4
  #pacman -S --noconfirm --needed xfce4-notifyd  # Демон уведомлений для рабочего стола Xfce ; https://archlinux.org/packages/extra/x86_64/xfce4-notifyd/
  #pacman -S --noconfirm --needed xfce4-screenshooter  # Приложение для создания снимков экрана ; https://docs.xfce.org/apps/xfce4-screenshooter/start ; https://archlinux.org/packages/extra/x86_64/xfce4-screenshooter/
  #pacman -S --noconfirm --needed thunar-volman  # Автоматическое управление съемными дисками и носителями для Thunar ; https://docs.xfce.org/xfce/thunar/thunar-volman ; https://archlinux.org/packages/extra/x86_64/thunar-volman/
# pacman -S xdg-user-dirs --noconfirm  # Управляйте пользовательскими каталогами, такими как ~ / Desktop и ~ / Music
  #pacman -S --noconfirm --needed xfce4-dict  # Плагин словаря для панели Xfce ; https://docs.xfce.org/apps/xfce4-dict/start ; https://archlinux.org/packages/extra/x86_64/xfce4-dict/ ; xfce4-dict –help ; Ноябрь 19, 2023, 20:46 по всемирному координированному времени
## mv /usr/share/xsessions/xfce.desktop ~/
### Удалить пакет, не удаляя его зависимости: pacman -R название_пакета
### *Важно: эта операция рекурсивна, использовать её с осторожностью — есть риск удалить нужные пакеты.*
### Совет: перед удалением рекомендуется проверять, что именно будет удалено, и, если необходимо, делать резервные копии важных данных.
pacman -R parole --noconfirm  # Современный медиаплеер на базе фреймворка GStreamer ; https://docs.xfce.org/apps/parole/start ; https://archlinux.org/packages/extra/x86_64/parole/ ; 29 января 2024 г., 14:50 UTC
### Если ли надо раскомментируйте нужные вам значения ####
echo ""
echo " Установка пакетов поддержки Sound support (alsa, pulseaudio...) "
 # You can also use pulseaudio to control the volume
#echo " ALSA - это тот самый звук (условно, на самом деле это звуковая подсистема ядра), который идёт напрямую из ядра и является самым быстрым, так как не вынужден проходить множество программных прослоек и микширование. "
#echo " Поэтому, если у вас нет потребности в микшировании каналов, записи аудио через микрофон и вы не слушаете музыку через Bluetooth, то ALSA может вам подойти. "
############# ALSA - Advanced Linux Sound Architecture ###########
pacman -Sy --noconfirm --needed alsa-utils alsa-plugins alsa-firmware alsa-lib alsa-card-profiles  # Расширенная звуковая архитектура Linux — Утилиты ; Дополнительные плагины ALSA ; Бинарные файлы прошивки для программ-загрузчиков в ALSA-tools и загрузчике прошивок hotplug ; Альтернативная реализация поддержки звука в Linux ;  Профили карт ALSA, общие для PulseAudio
#########################
# pacman -Syy  # обновление баз пакмэна (pacman)
# pacman -S --noconfirm --needed alsa-utils  # Расширенная звуковая архитектура Linux — Утилиты ; https://archlinux.org/packages/extra/x86_64/alsa-utils/ ; https://www.alsa-project.org/ ; 2025-04-14 20:27 UTC ; Пакет alsa-utils также содержит консольный Микшер (настройка громкости), который вызывается командой alsamixer.
# pacman -S --noconfirm --needed alsa-plugins  # Дополнительные плагины ALSA ; https://archlinux.org/packages/extra/x86_64/alsa-plugins/ ; https://www.alsa-project.org/ ; 2024-11-07 20:01 UTC
# pacman -S --noconfirm --needed alsa-firmware  # Бинарные файлы прошивки для программ-загрузчиков в ALSA-tools и загрузчике прошивок hotplug ; https://archlinux.org/packages/extra/any/alsa-firmware/ ; https://alsa-project.org/ ; 2024-07-11 22:24 UTC
# pacman -S --noconfirm --needed alsa-lib  # Альтернативная реализация поддержки звука в Linux ; https://archlinux.org/packages/extra/x86_64/alsa-lib/ ; https://www.alsa-project.org/ ; 2025-04-14 20:27 UTC
# pacman -S --noconfirm --needed alsa-card-profiles  # Профили карт ALSA, общие для PulseAudio ; Аудио/видео маршрутизатор и процессор с малой задержкой — профили карт ALSA ; https://archlinux.org/packages/extra/x86_64/alsa-card-profiles/ ; https://pipewire.org/ ; 28 июня 2025 г. 02:23 UTC
echo ""
echo " Установка пакетов для понижения задержек звука в PulseAudio "
echo " Установка графической панели управления звуком - pavucontrol в PulseAudio "
############ PulseAudio Утилиты #################
pacman -S --noconfirm --needed pulseaudio pulseaudio-alsa pavucontrol pulseaudio-bluetooth   # Функциональный звуковой сервер общего назначения ; Конфигурация ALSA для PulseAudio ; Регулятор громкости PulseAudio ; Поддержка Bluetooth для PulseAudio
# pacman -S --noconfirm --needed pulseaudio  # Функциональный звуковой сервер общего назначения ; https://archlinux.org/packages/extra/x86_64/pulseaudio/ ; https://www.freedesktop.org/wiki/Software/PulseAudio/ ; Заменяет: pulseaudio-gconf<=11.1, pulseaudio-xen<=9.0 ; Конфликты: с pipewire-pulse ; Обратные конфликты: с pipewire-pulse ; 2024-12-07 17:14 UTC
# pacman -S --noconfirm --needed pulseaudio-alsa  # Конфигурация ALSA для PulseAudio ; https://archlinux.org/packages/extra/x86_64/pulseaudio-alsa/ ; https://www.alsa-project.org/ ; 2024-11-07 20:02 UTC
# pacman -S --noconfirm --needed pavucontrol  # Регулятор громкости PulseAudio ; https://archlinux.org/packages/extra/x86_64/pavucontrol/ ; https://freedesktop.org/software/pulseaudio/pavucontrol/ ; 2024-08-04 05:28 UTC
# pacman -S --noconfirm --needed pavucontrol-qt  # Микшер Pulseaudio в Qt (порт pavucontrol) ; https://archlinux.org/packages/extra/x86_64/pavucontrol-qt/ ; https://github.com/lxqt/pavucontrol-qt ; 2025-04-22 14:55 UTC
# pacman -S --noconfirm --needed pulseaudio-bluetooth  # Поддержка Bluetooth для PulseAudio ; https://archlinux.org/packages/extra/x86_64/pulseaudio-bluetooth/ ; https://www.freedesktop.org/wiki/Software/PulseAudio/ ; 2024-12-07 17:14 UTC
pacman -S --noconfirm --needed paprefs  # Диалог конфигурации для PulseAudio (PulseAudio Preferences - https://freedesktop.org/software/pulseaudio/paprefs/) ; https://archlinux.org/packages/extra/x86_64/paprefs/ ; https://freedesktop.org/software/pulseaudio/paprefs/ ; 2024-07-14 02:57 UTC
# systemctl enable bluetooth.service
# systemctl --user start pulseaudio
# systemctl --user enable pulseaudio
####################
echo ""
echo " Установка пакетов для поддержки работы с архивами (zip ,unzip, unrar...) "
pacman -Sy --noconfirm --needed zip unzip unrar lha p7zip lrzip  #  Компрессор / архиватор для создания и изменения zip-файлов ; Для извлечения и просмотра файлов в архивах .zip ; Программа распаковки RAR; Бесплатная программа для архивирования LZH / LHA ; Файловый архиватор из командной строки с высокой степенью сжатия ; Многопоточное сжатие с помощью rzip / lzma, lzo и zpaq
pacman -S --noconfirm --needed unace  # Инструмент для извлечения данных из архива формата ACE
pacman -S --noconfirm --needed file-roller  # легковесный архиватор ( для xfce-lxqt-lxde-gnome )
#####
  clear
  echo ""
  echo " DE (среда рабочего стола) Xfce успешно установлено "
  echo ""
  echo -e "${GREEN}==> ${NC}Настройка автовхода без DM (Display manager) менеджера входа в Xfce"
  echo -e "${MAGENTA}=> ${BOLD}Файл ~/.xinitrc представляет собой шелл-скрипт передаваемый xinit посредством команды startx. ${NC}"
  echo -e "${MAGENTA}:: ${NC}Он используется для запуска Среды рабочего стола, Оконного менеджера и других программ запускаемых с X сервером (например запуска демонов, и установки переменных окружений."
  echo -e "${CYAN}:: ${NC}Программа xinit запускает Xorg сервер и работает в качестве программы первого клиента на системах не использующих Экранный менеджер."
  echo " Давайте проанализируем действия, которые выполняются. "
  echo " 1 - Если вам нужен автовход без DM (Display manager), тогда укажите "1" "
  echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
  echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
  echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" "
  echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
  echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
  echo ""
while
    echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Да нужен автовход без DM (Display manager),

    0 - Нет буду использовать DM (Display manager): " i_xfce   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_xfce" =~ [^10] ]]
do
    :
done
if [[ $i_xfce  == 0 ]]; then
  echo ""
  echo " Буду использовать DM (Display manager) "
elif [[ $i_xfce  == 1 ]]; then
  echo ""
  echo " Действия по настройке автовхода без DM (Display manager) "
  echo " Поскольку реализация автозагрузки окружения реализована через startx - (иксы), то если Вы установили X.Org Server возможно пакет (xorg-xinit) - уже установлен "
# pacman -S xorg-xinit --noconfirm   # Программа инициализации X.Org
  pacman -S --noconfirm --needed xorg-xinit  # Программа инициализации X.Org
# pacman -S --noconfirm --needed xorg-xauth  # Программа настройки авторизации X.Org
### Если файл .xinitrc не существует, то копируем его из /etc/X11/xinit/xinitrc
### в папку пользователя cp /etc/X11/xinit/xinitrc ~/.xinitrc
  cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc # копируем файл .xinitrc в каталог пользователя
  chown $username:users /home/$username/.xinitrc  # даем доступ пользователю к файлу
  chmod +x /home/$username/.xinitrc   # получаем права на исполнения скрипта
  sed -i 52,55d /home/$username/.xinitrc  # редактируем файл -> и прописываем команду на запуск
### Данные блоки нужны для того, чтобы StartX автоматически запускал нужное окружение, соответственно в секции Window Manager of your choice раскомментируйте нужную сессию
  echo "exec startxfce4 " >> /home/$username/.xinitrc
  mkdir /etc/systemd/system/getty@tty1.service.d/  # создаём папку
  echo " [Service] " > /etc/systemd/system/getty@tty1.service.d/override.conf
  echo " ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
  echo   ExecStart=-/usr/bin/agetty --autologin $username --noclear %I 38400 linux >> /etc/systemd/system/getty@tty1.service.d/override.conf
### Делаем автоматический запуск Иксов в нужной виртуальной консоли после залогинивания нашего пользователя
  echo ' [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx ' >> /etc/profile
  echo ""
  echo " Действия по настройке автовхода без DM (Display manager) выполнены "
fi
  clear
elif [[ $x_de == 3 ]]; then
  echo " Установка Gnome "
  pacman -S gnome gnome-extra  --noconfirm
  clear
  echo ""
  echo " DE (среда рабочего стола) Gnome успешно установлено "
  echo ""
  echo -e "${GREEN}==> ${NC}Настройка автовхода без DM (Display manager) менеджера входа в GNOME"
  echo " Давайте проанализируем действия, которые выполняются. "
  echo " 1 - Если вам нужен автовход без DM (Display manager), тогда укажите "1" "
  echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
  echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
  echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" "
  echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
  echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
  echo ""
while
    echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Да нужен автовход без DM (Display manager),

    0 - Нет буду использовать DM (Display manager): " i_gnome   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_gnome" =~ [^10] ]]
do
    :
done
if [[ $i_gnome  == 0 ]]; then
  echo " Буду использовать DM (Display manager) "
elif [[ $i_gnome  == 1 ]]; then
  echo ""
  echo " Действия по настройке автовхода без DM (Display manager) "
  echo " Поскольку реализация автозагрузки окружения реализована через startx - (иксы), то если Вы установили X.Org Server возможно пакет (xorg-xinit) - уже установлен "
  pacman -S xorg-xinit --noconfirm
  cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc # копируем файл .xinitrc в каталог пользователя
  chown $username:users /home/$username/.xinitrc  # даем доступ пользователю к файлу
  chmod +x /home/$username/.xinitrc   # получаем права на исполнения скрипта
  sed -i 52,55d /home/$username/.xinitrc  # редактируем файл -> и прописываем команду на запуск
  echo "exec gnome-session " >> /home/$username/.xinitrc
  mkdir /etc/systemd/system/getty@tty1.service.d/  # создаём папку
  echo " [Service] " > /etc/systemd/system/getty@tty1.service.d/override.conf
  echo " ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
  echo   ExecStart=-/usr/bin/agetty --autologin $username --noclear %I 38400 linux >> /etc/systemd/system/getty@tty1.service.d/override.conf
  echo ' [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx ' >> /etc/profile
  echo ""
  echo " Действия по настройке автовхода без DM (Display manager) выполнены "
fi
  clear
elif [[ $x_de == 4 ]]; then
  echo " Установка LXDE "
  pacman -S lxde --noconfirm
  clear
  echo ""
  echo " DE (среда рабочего стола) LXDE успешно установлено "
  echo ""
  echo -e "${GREEN}==> ${NC}Настройка автовхода без DM (Display manager) менеджера входа в LXDE"
  echo " Давайте проанализируем действия, которые выполняются. "
  echo " 1 - Если вам нужен автовход без DM (Display manager), тогда укажите "1" "
  echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
  echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
  echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" "
  echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
  echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
  echo ""
while
    echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Да нужен автовход без DM (Display manager),

    0 - Нет буду использовать DM (Display manager): " i_lxde   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_lxde" =~ [^10] ]]
do
    :
done
if [[ $i_lxde  == 0 ]]; then
  echo " Буду использовать DM (Display manager) "
elif [[ $i_lxde  == 1 ]]; then
  echo ""
  echo " Действия по настройке автовхода без DM (Display manager) "
  echo " Поскольку реализация автозагрузки окружения реализована через startx - (иксы), то если Вы установили X.Org Server возможно пакет (xorg-xinit) - уже установлен "
  pacman -S xorg-xinit --noconfirm
  cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc
  chown $username:users /home/$username/.xinitrc
  chmod +x /home/$username/.xinitrc
  sed -i 52,55d /home/$username/.xinitrc
  echo "exec startlxde " >> /home/$username/.xinitrc
  mkdir /etc/systemd/system/getty@tty1.service.d/
  echo " [Service] " > /etc/systemd/system/getty@tty1.service.d/override.conf
  echo " ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
  echo   ExecStart=-/usr/bin/agetty --autologin $username --noclear %I 38400 linux >> /etc/systemd/system/getty@tty1.service.d/override.conf
  echo ' [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx ' >> /etc/profile
  echo ""
  echo " Действия по настройке автовхода без DM (Display manager) выполнены "
fi
  clear
elif [[ $x_de == 5 ]]; then
  echo " Установка Deepin "
  pacman -S deepin deepin-extra --noconfirm
  clear
  echo ""
  echo " DE (среда рабочего стола) Deepin успешно установлено "
  echo ""
  echo -e "${GREEN}==> ${NC}Настройка автовхода без DM (Display manager) менеджера входа в Deepin"
  echo " Давайте проанализируем действия, которые выполняются. "
  echo " 1 - Если вам нужен автовход без DM (Display manager), тогда укажите "1" "
  echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
  echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
  echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" "
  echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
  echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
  echo ""
while
    echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Да нужен автовход без DM (Display manager),

    0 - Нет буду использовать DM (Display manager): " i_deepin   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_deepin" =~ [^10] ]]
do
    :
done
if [[ $i_deepin  == 0 ]]; then
  echo " Буду использовать DM (Display manager) "
elif [[ $i_deepin  == 1 ]]; then
  echo ""
  echo " Действия по настройке автовхода без DM (Display manager) "
  echo " Поскольку реализация автозагрузки окружения реализована через startx - (иксы), то если Вы установили X.Org Server возможно пакет (xorg-xinit) - уже установлен "
  pacman -S xorg-xinit --noconfirm
  cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc
  chown $username:users /home/$username/.xinitrc
  chmod +x /home/$username/.xinitrc
  sed -i 52,55d /home/$username/.xinitrc
  echo "exec startdde  " >> /home/$username/.xinitrc
  mkdir /etc/systemd/system/getty@tty1.service.d/
  echo " [Service] " > /etc/systemd/system/getty@tty1.service.d/override.conf
  echo " ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
  echo   ExecStart=-/usr/bin/agetty --autologin $username --noclear %I 38400 linux >> /etc/systemd/system/getty@tty1.service.d/override.conf
  echo ' [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx ' >> /etc/profile
  echo ""
  echo " Действия по настройке автовхода без DM (Display manager) выполнены "
fi
  clear
elif [[ $x_de == 6 ]]; then
  echo " Установка Mate "
  pacman -S  mate mate-extra  --noconfirm
  clear
  echo ""
  echo " DE (среда рабочего стола) Mate успешно установлено "
  echo ""
  echo -e "${GREEN}==> ${NC}Настройка автовхода без DM (Display manager) менеджера входа в Mate"
  echo " Давайте проанализируем действия, которые выполняются. "
  echo " 1 - Если вам нужен автовход без DM (Display manager), тогда укажите "1" "
  echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
  echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
  echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" "
  echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
  echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
  echo ""
while
    echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Да нужен автовход без DM (Display manager),

    0 - Нет буду использовать DM (Display manager): " i_mate   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_mate" =~ [^10] ]]
do
    :
done
if [[ $i_mate  == 0 ]]; then
  echo " Буду использовать DM (Display manager) "
elif [[ $i_mate  == 1 ]]; then
  echo ""
  echo " Действия по настройке автовхода без DM (Display manager) "
  echo " Поскольку реализация автозагрузки окружения реализована через startx - (иксы), то если Вы установили X.Org Server возможно пакет (xorg-xinit) - уже установлен "
  pacman -S xorg-xinit --noconfirm
  cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc
  chown $username:users /home/$username/.xinitrc
  chmod +x /home/$username/.xinitrc
  sed -i 52,55d /home/$username/.xinitrc
  echo "exec mate-session  " >> /home/$username/.xinitrc
  mkdir /etc/systemd/system/getty@tty1.service.d/
  echo " [Service] " > /etc/systemd/system/getty@tty1.service.d/override.conf
  echo " ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
  echo   ExecStart=-/usr/bin/agetty --autologin $username --noclear %I 38400 linux >> /etc/systemd/system/getty@tty1.service.d/override.conf
  echo ' [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx ' >> /etc/profile
  echo ""
  echo " Действия по настройке автовхода без DM (Display manager) выполнены "
fi
  clear
elif [[ $x_de == 7 ]]; then
  echo " Установка Lxqt "
  pacman -S lxqt lxqt-qtplugin lxqt-themes oxygen-icons xscreensaver --noconfirm
  clear
  echo ""
  echo " DE (среда рабочего стола) Lxqt успешно установлено "
  echo ""
  echo -e "${GREEN}==> ${NC}Настройка автовхода без DM (Display manager) менеджера входа в Lxqt"
  echo " Давайте проанализируем действия, которые выполняются. "
  echo " 1 - Если вам нужен автовход без DM (Display manager), тогда укажите "1" "
  echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
  echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
  echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" "
  echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
  echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
  echo ""
while
    echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Да нужен автовход без DM (Display manager),

    0 - Нет буду использовать DM (Display manager): " i_lxqt   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_lxqt" =~ [^10] ]]
do
    :
done
if [[ $i_lxqt  == 0 ]]; then
  echo " Буду использовать DM (Display manager) "
elif [[ $i_lxqt  == 1 ]]; then
  echo ""
  echo " Действия по настройке автовхода без DM (Display manager) "
  echo " Поскольку реализация автозагрузки окружения реализована через startx - (иксы), то если Вы установили X.Org Server возможно пакет (xorg-xinit) - уже установлен "
  pacman -S xorg-xinit --noconfirm
  cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc
  chown $username:users /home/$username/.xinitrc
  chmod +x /home/$username/.xinitrc
  sed -i 52,55d /home/$username/.xinitrc
  echo "exec startlxqt " >> /home/$username/.xinitrc
  mkdir /etc/systemd/system/getty@tty1.service.d/
  echo " [Service] " > /etc/systemd/system/getty@tty1.service.d/override.conf
  echo " ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
  echo   ExecStart=-/usr/bin/agetty --autologin $username --noclear %I 38400 linux >> /etc/systemd/system/getty@tty1.service.d/override.conf
  echo ' [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx ' >> /etc/profile
  echo ""
  echo " Действия по настройке автовхода без DM (Display manager) выполнены "
fi
  clear
elif [[ $x_de == 8 ]]; then
  echo " Установка i3 (тайловый оконный менеджер) "
  pacman -S i3 i3-wm i3status dmenu --noconfirm
  clear
  echo ""
  echo " i3 (тайловый оконный менеджер) успешно установлен "
  echo ""
  echo -e "${GREEN}==> ${NC}Настройка автовхода без DM (Display manager) менеджера входа в i3"
  echo " Давайте проанализируем действия, которые выполняются. "
  echo " 1 - Если вам нужен автовход без DM (Display manager), тогда укажите "1" "
  echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
  echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
  echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" "
  echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
  echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
  echo ""
while
    echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Да нужен автовход без DM (Display manager),

    0 - Нет буду использовать DM (Display manager): " i_i3w   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_i3w" =~ [^10] ]]
do
    :
done
if [[ $i_i3w  == 0 ]]; then
  echo " Буду использовать DM (Display manager) "
elif [[ $i_i3w  == 1 ]]; then
  echo ""
  echo " Действия по настройке автовхода без DM (Display manager) "
  echo " Поскольку реализация автозагрузки окружения реализована через startx - (иксы), то если Вы установили X.Org Server возможно пакет (xorg-xinit) - уже установлен "
  pacman -S xorg-xinit --noconfirm
  cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc
  chown $username:users /home/$username/.xinitrc
  chmod +x /home/$username/.xinitrc
  sed -i 52,55d /home/$username/.xinitrc
  echo "exec i3 " >> /home/$username/.xinitrc
  mkdir /etc/systemd/system/getty@tty1.service.d/
  echo " [Service] " > /etc/systemd/system/getty@tty1.service.d/override.conf
  echo " ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
  echo   ExecStart=-/usr/bin/agetty --autologin $username --noclear %I 38400 linux >> /etc/systemd/system/getty@tty1.service.d/override.conf
  echo ' [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx ' >> /etc/profile
  echo ""
  echo " Действия по настройке автовхода без DM (Display manager) выполнены "
fi
fi
###

clear
echo ""
echo -e "${GREEN}==> ${NC}Ставим DM (Display manager) менеджера входа."
echo " DM - Менеджер дисплеев, или Логин менеджер, обычно представляет собой графический пользовательский интерфейс, который отображается в конце процесса загрузки вместо оболочки по умолчанию. "
echo -e "${MAGENTA}:: ${BOLD}Существуют различные реализации дисплейных менеджеров, обычно с определенным количеством настроек и тематических функций, доступных для каждого из них. ${NC}"
echo -e "${MAGENTA}=> ${BOLD}Согласно аннотации ArchWiki рассмотрим список графических менеджеров дисплея, варианты установки DM (Display manager), и их совместимость с различными вариантами DE (средами рабочего стола). ${NC}"
echo " 1 - LightDM - Диспетчер дисплеев между рабочими столами, может использовать различные интерфейсы, написанные на любом наборе инструментов, вариант - "1" "
echo -e "${CYAN}:: ${NC}LightDM - идёт как основной DM в Xfce (окружение рабочего стола), совместим с Deepin, и т.д.. Его ключевые особенности: Кросс-десктоп - поддерживает различные настольные технологии, поддерживает различные технологии отображения (X, Mir, Wayland ...), низкое использование памяти и высокая производительность. Поддерживает гостевые сессии, поддерживает удаленный вход (входящий - XDMCP, VNC, исходящий - XDMCP). "
echo " 2 - LXDM - Диспетчер отображения LXDE, вариант - "2" "
echo -e "${CYAN}:: ${NC}LXDE  - идёт как основной DM в LXDE (окружение рабочего стола), совместим с Xfce, Mate, Deepin, и т.д.. Это легкий диспетчер отображения, пользовательский интерфейс реализован с помощью GTK 2. LXDM не поддерживает протокол XDMCP, альтернатива - LightDM. "
echo " 3 - GDM - Диспетчер отображения GNOME, вариант - "3" "
echo -e "${CYAN}:: ${NC}GNOME Display Manager (GDM) - это программа, которая управляет серверами графического дисплея и обрабатывает логины пользователей в графическом режиме. "
echo " 4 - SDDM - Диспетчер отображения на основе QML и преемник KDM, вариант - "4" "
echo -e "${CYAN}:: ${NC}SDDM - рекомендуется для KDE Plasma Desktop, и LXQt (окружение рабочего стола). Simple Desktop Display Manager (SDDM) - это диспетчер дисплея (графическая программа входа в систему) для оконных систем X11 и Wayland. KDE выбрала SDDM в качестве преемника KDE Display Manager для KDE Plasma 5. "
echo " 5(0) - Если Вам не нужен DM (Display manager), то выбирайте вариант - "0" "
echo -e "${YELLOW}:: ${BOLD}Примечание! Если Вы при установке i3, сделали выбор без использования DM, то DM не ставим! ${NC}"
echo " Будьте внимательны! В этом действии выбор остаётся за вами. Ориентируйтесь на установленное DE. "
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - LightDM,     2 - LXDM,     3 - GDM,     4 - SDDM,

    0 - Пропустить установку DM (Display manager): " i_dm  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_dm" =~ [^12340] ]]
do
    :
done
if [[ $i_dm == 0 ]]; then
  clear
  echo ""
  echo " Установка DM (Display manager) пропущена "
elif [[ $i_dm == 1 ]]; then
  echo ""
  echo " Установка LightDM (менеджера входа) "
  echo " Если всё в порядке, вы увидите графический экран входа "
  echo " Войдите в свою учётную запись, и Xfce должен загрузиться автоматически "
  pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm  # Легкий диспетчер дисплеев; GTK + приветствие для LightDM; Редактор настроек для LightDM GTK + Greeter.
  #pacman -S lightdm-slick-greeter --noconfirm  # Приятный на вид приветственный элемент LightDM ; https://github.com/linuxmint/slick-greeter ; https://archlinux.org/packages/extra/x86_64/lightdm-slick-greeter/
  pacman -S light-locker --noconfirm  # Простой шкафчик сессий для LightDM
  echo " Установка DM (менеджера входа) завершена "
  echo ""
  echo " Подключаем автозагрузку менеджера входа "
# systemctl enable lightdm.service
  systemctl enable lightdm.service -f  # systemctl - специальный инструмент для управления службами в Linux
# systemctl start lightdm.service
  sleep 1
  clear
  echo ""
  echo " Менеджера входа LightDM установлен и подключен в автозагрузку "
elif [[ $i_dm == 2 ]]; then
  echo ""
  echo " Установка LXDM (менеджера входа) "
  pacman -S lxdm --noconfirm  # Легкий диспетчер отображения X11
  echo " Установка DM (менеджера входа) завершена "
  echo ""
  echo " Подключаем автозагрузку менеджера входа "
# systemctl enable lxdm.service
  systemctl enable lxdm.service -f  # systemctl - специальный инструмент для управления службами в Linux
  sleep 1
  clear
  echo ""
  echo " Менеджера входа LXDM установлен и подключен в автозагрузку "
elif [[ $i_dm == 3 ]]; then
  echo ""
  echo " Установка GDM (менеджера входа) "
  pacman -S gdm --noconfirm  # Диспетчер отображения и экран входа в систему
  echo " Установка DM (менеджера входа) завершена "
  echo ""
  echo " Подключаем автозагрузку менеджера входа "
# systemctl enable gdm.service
  systemctl enable gdm.service -f  # systemctl - специальный инструмент для управления службами в Linux
  sleep 1
  clear
  echo ""
  echo " Менеджера входа GDM установлен и подключен в автозагрузку "
elif [[ $i_dm == 4 ]]; then
  echo ""
  echo " Установка SDDM (менеджера входа) "
  pacman -S sddm sddm-kcm --noconfirm  # Диспетчер отображения X11 и Wayland на основе QML; Модуль конфигурации KDE для SDDM
  echo " Установка DM (менеджера входа) завершена "
  echo ""
  echo " Подключаем автозагрузку менеджера входа "
# systemctl enable sddm.service
  systemctl enable sddm.service -f  # systemctl - специальный инструмент для управления службами в Linux
  sleep 1
  clear
  echo ""
  echo " Менеджера входа SDDM установлен и подключен в автозагрузку "
fi
### После завершения установки проверьте текущий менеджер дисплеев, выполнив следующую команду.
## file /etc/systemd/system/display-manager. service
######################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Cronie (cronie) — Планировщик заданий?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Те, кто знаком с системой Unix, также знакомы с приложением cron, которое позволяет планировать и автоматизировать выполнение задач самостоятельно. Однако cron не идеален, так как требует, чтобы ваша система работала 24 часа в сутки. Если у вас есть привычка выключать компьютер ночью, а задание cron запланировано на часы сна, задача не будет выполнена. К счастью, есть несколько альтернатив cron, которые могут работать лучше, чем cron. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Cronie — Еще одна блестящая альтернатива cron, которую вы можете установить , -это Crony. В отличие от предыдущей, Cronie - это небольшой набор программного обеспечения, целью которого является обеспечение полного опыта cron. Для этого Crony по умолчанию включает пакет anacron. Это означает, что crony может обеспечить как синхронное, так и асинхронное планирование заданий из коробки. Cronie содержит стандартный демон Unix Crond, который запускает заданные программы по расписанию, а также сопутствующие инструменты. Исходный код основан на оригинальном vixie-cron и обладает улучшенными возможностями безопасности и настройки, такими как поддержка pam и SELinux. Chronic запускает команду и обеспечивает отображение её стандартного вывода и стандартного потока ошибок только в случае сбоя команды (возвращения к ненулевому значению или аварийного завершения). Если команда выполнена успешно, весь посторонний вывод будет скрыт. Кроме того, установка cronie относительно проста, cronie — форк Vixie cron, доступен в RedHat, Fedora и CentOS. После установки cronie вы можете использовать Crony для управления заданиями cron на вашем компьютере. Подобно anacron и cron, вы можете создать задание cron, запустив crontab -e. Это позволит вам редактировать crontab вашего пользователя. Лицензия(и): custom:BSD, GPL-2.0 license, LGPL-2.1 license. ${NC}"
echo " Домашняя страница: https://github.com/cronie-crond/cronie/ ; (https://archlinux.org/packages/extra/x86_64/cronie/ ; https://github.com/cronie-crond/cronie/releases ; https://wiki.archlinux.org/title/Cron). "
echo -e "${BLUE}:: ${NC}Функции: Запуск задач из пользовательских и системной таблиц. Можно указать расписание: минуту, час, день недели, день месяца, месяц или комбинацию этих значений. Автоматизация задач обслуживания системы или администрирования, например, бэкапа базы данных, обновлений системы, проверки использования дискового пространства. Поддержка PAM и SELinux, работы в кластере, слежения за файлами при помощи inotify и других возможностей. "
echo -e "${CYAN}:: ${NC}Cron — это планировщик заданий, работающий по времени, в операционных системах Unix. Он позволяет автоматизировать задачи, планируя их выполнение с определёнными интервалами. Crontab (сокращение от «cron table») — это файл конфигурации, содержащий расписание заданий cron для пользователя с фиксированным временем или интервалами. Задания Cron определяются с помощью специального синтаксиса, состоящего из пяти полей: времени и даты, за которыми следует команда для выполнения. Поля слева направо представляют минуты (0–59), часы (0–23), дни месяца (1–31), месяцы (1–12) и дни недели (0–7, где 0 и 7 обозначают воскресенье). "
echo -e "${CYAN}:: ${NC}Имеется много реализаций cron, но ни одна из них не установлена по умолчанию: - (cronie, fcron, bcron, dcron, vixie-cron, scron-git), cronie и fcron доступны в стандартном репозитории, а остальные – в AUR."
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_cron  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_cron" =~ [^10] ]]
do
    :
done
if [[ $in_cron == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_cron == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Cronie (cronie) "
pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
pacman -S --noconfirm --needed bash  # Оболочка GNU Bourne Again ; https://archlinux.org/packages/core/x86_64/bash/ ; https://www.gnu.org/software/bash/bash.html ; 2025-08-02 12:29 UTC
pacman -S --noconfirm --needed pam  # Библиотека PAM (подключаемые модули аутентификации) ; https://archlinux.org/packages/core/x86_64/pam/ ; Обеспечивает: libpam.so=0-64, libpam_misc.so=0-64, libpamc.so=0-64 ; 2025-06-20 17:10 UTC
pacman -S --noconfirm --needed run-parts  # Запускать скрипты или программы в каталоге ; https://archlinux.org/packages/extra/x86_64/run-parts/ ; https://packages.qa.debian.org/d/debianutils.html ; 2025-06-30 07:57 UTC
# sudo pacman -S --noconfirm --needed opensmtpd  # Бесплатная реализация серверного протокола SMTP ; https://archlinux.org/packages/extra/x86_64/opensmtpd/ ; https://www.opensmtpd.org/ ; Обеспечивает: smtp-forwarder, smtp-server ; Конфликты: с smtp-forwarder, smtp-server ; 2025-06-26 13:04 UTC
############ cronie ##########
# sudo pacman -S cronie  # Демон, который запускает указанные программы в запланированное время и связанные инструменты ; https://archlinux.org/packages/extra/x86_64/cronie/ ; https://github.com/cronie-crond/cronie/ ; Обеспечивает: cron ; Конфликты: с cron ; 2024-04-09 12:08 UTC
pacman -S --noconfirm --needed cronie  # Демон, который запускает указанные программы в запланированное время и связанные инструменты ; https://archlinux.org/packages/extra/x86_64/cronie/ ; https://github.com/cronie-crond/cronie/ ; Обеспечивает: cron ; Конфликты: с cron ; 2024-04-09 12:08 UTC
echo ""
echo " Добавляем в автозагрузку планировщик заданий (cronie.service) "
systemctl enable cronie.service  # настраивает службу cron (crond) на автоматический запуск при перезагрузке системы
#systemctl enable --now cronie.service  # перезапуск сервиса
### sudo systemctl disable cronie.service  # Удаление из автозагрузки
#systemctl start cronie.service  # запускает сервис в текущей сессии
# sudo systemctl start cronie sudo systemctl enable cronie
# sudo systemctl status cronie.service  # позволяет проверить статус сервиса cronie.service в системе
# EDITOR=nano crontab -e  # Редактируем параметр (редактор по умолчанию в терминале)
#echo "export EDITOR = nano" >> $ HOME / .bashrc export EDITOR = nano
  echo ""
  echo " Посмотрите информацию о версии (cronie) "
anacron -V  # Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########### Справка ##############
# https://www.linuxboost.com/how-to-set-up-a-cron-job-on-arch-linux/
# Теперь осталось добавить само правило.
# Вбиваем в терминале:
# sudo EDITOR=nano crontab -e   # Редактируем параметр
# И добавляем (прописываем):
# 10 10 * * sun /sbin/rm /var/cache/pacman/pkg/*
# Таким образом наша система будет сама себя чистить раз в неделю, в воскресенье в 10:10 ))
# Или
# 15 10 * * sun /sbin/rm /var/cache/pacman/pkg/*
# Таким образом наша система будет сама себя чистить раз в неделю, в воскресенье в 15:10
# -----------------------------------------
# Автоматическая Оптимизация памяти:
# Чтобы автоматизировать процесс и регулярно очищать память, вы можете настроить задание cron для запуска команд через определённые промежутки времени.
# Откройте конфигурацию crontab.
# crontab -e
# Добавьте следующие строки, чтобы ежедневно в полночь очищать кэш, буфер и пространство подкачки:
# 0 0 * * * sudo sync; echo 3 > / proc/sys/vm/drop_caches
# 0 0 * * * sudo echo 1 > / proc/sys/vm/drop_caches
# 0 0 * * * sudo sync; echo 2 > /proc/sys/vm/drop_caches
# 0 0 * * * sudo swapoff -a && sudo swapon -a
# Примечание: sudo может не работать в crontab, если не используется crontab пользователя root или для этих команд не настроено sudo без пароля. Рассмотрите возможность размещения команд в скрипте и планирования его выполнения.
# Т.е. для редактирования списка задач текущего пользователя:
# crontab -e
# Для отображения списка задач текущего пользователя:
# crontab -l
####################################

clear
echo ""
echo -e "${GREEN}==> ${NC}Запустить Systemd-Timesyncd и сделать (systemd-timesyncd.service) активным?"
#echo -e "${BLUE}:: ${NC}Запустить Systemd-Timesyncd и сделать (systemd-timesyncd.service) активным??"
#echo 'Запустить Systemd-Timesyncd и сделать (systemd-timesyncd.service) активным??'
# Start and make Systemd-Timesync active?
echo -e "${MAGENTA}=> ${BOLD}Systemd-Timesyncd – это демон, добавленный для синхронизации системных часов по сети. Он реализует SNTP-клиент. В отличие от реализаций NTP, таких как chrony или NTP-сервер, он реализует только клиентскую часть и не заморачивается со всей сложностью NTP, сосредоточившись только на запросе времени с одного удаленного сервера и синхронизации с ним локальных часов. ${NC}"
echo " Если вы не собираетесь обслуживать NTP для сетевых клиентов или не хотите подключаться к локальным аппаратным часам, этот простой NTP-клиент должен быть более чем подходящим для большинства установок. "
echo -e "${CYAN}:: ${NC}Демон работает с минимальными привилегиями и был подключен к networkd для работы только при наличии сетевого подключения. Демон сохраняет текущие часы на диск каждый раз, когда получается новая синхронизация NTP (и каждые 60 секунд), и использует это для возможной корректировки системных часов на ранней стадии загрузки, чтобы приспособиться к системам, в которых отсутствует RTC, таким как Raspberry Pi и встроенные устройства, и убедиться, что время в этих системах идет монотонно, даже если оно не всегда правильно. Чтобы использовать этот демон, необходимо создать нового системного пользователя и группу «systemd-timesync» при установке systemd. Например, вы можете использовать любые серверы, предоставляемые проектом пула NTP , или использовать серверы Arch по умолчанию (также предоставляемые проектом пула NTP)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор остаётся за вами. "
# Be careful! The installation process was fully automatic. In this option, the choice is yours.
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
# You can skip this step if you are not sure of the correct choice
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да Запустить Systemd-Timesyncd,     0 - НЕТ - Пропустить: " i_timesyncd  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_timesyncd" =~ [^10] ]]
do
    :
done
if [[ $i_timesyncd == 0 ]]; then
echo ""
echo " Запуск Systemd-Timesyncd (systemd-timesyncd.service) пропущен "
elif [[ $i_timesyncd == 1 ]]; then
echo ""
echo " Запуск Systemd-Timesyncd (systemd-timesyncd.service) "
echo " Создать каталог (resolvconf и resolv.conf.d) в /etc "
mkdir /etc/systemd/timesyncd.conf.d  # Создать каталог timesyncd.conf.d в /etc/systemd/
echo " Создать файл local.conf в /etc/systemd/timesyncd.conf.d/ "
touch /etc/systemd/timesyncd.conf.d/local.conf   # Создать файл local.conf в /etc/systemd/timesyncd.conf.d/
echo " Пропишем серверы NTP (Network Time Protocol)(ru.pool.ntp.org) в /etc/systemd/timesyncd.conf.d/local.conf "
echo " Российская Федерация — ru.pool.ntp.org "
> /etc/systemd/timesyncd.conf.d/local.conf
cat <<EOF >>/etc/systemd/timesyncd.conf.d/local.conf
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it under the
#  terms of the GNU Lesser General Public License as published by the Free
#  Software Foundation; either version 2.1 of the License, or (at your option)
#  any later version.
#
# Entries in this file show the compile time defaults. Local configuration
# should be created by either modifying this file (or a copy of it placed in
# /etc/ if the original file is shipped in /usr/), or by creating "drop-ins" in
# the /etc/systemd/timesyncd.conf.d/ directory. The latter is generally
# recommended. Defaults can be restored by simply deleting the main
# configuration file and all drop-ins located in /etc/.
#
# Use 'systemd-analyze cat-config systemd/timesyncd.conf' to display the full config.
#
# See timesyncd.conf(5) for details.

[Time]
NTP=myntpserver
NTP=server 0.ru.pool.ntp.org
#NTP=0.ru.pool.ntp.org 1.ru.pool.ntp.org 2.ru.pool.ntp.org 3.ru.pool.ntp.org
#NTP=0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org
#NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org
#NTP=0.europe.pool.ntp.org 1.europe.pool.ntp.org 2.europe.pool.ntp.org 3.europe.pool.ntp.org
#NTP=0.africa.pool.ntp.org 1.africa.pool.ntp.org 2.africa.pool.ntp.org 3.africa.pool.ntp.org
FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org
#FallbackNTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org
#RootDistanceMaxSec=5
#PollIntervalMinSec=32
#PollIntervalMaxSec=2048
#ConnectionRetrySec=30
#SaveIntervalSec=60

EOF
#######################
echo " Для начала сделаем его бэкап /etc/systemd/timesyncd.conf.d/local.conf "
#cp /etc/systemd/timesyncd.conf.d/local.conf  /etc/systemd/timesyncd.conf.d/local.conf.back
cp -v /etc/systemd/timesyncd.conf.d/local.conf  /etc/systemd/timesyncd.conf.d/local.conf.back  # Для начала сделаем его бэкап
# cp -v /etc/systemd/timesyncd.conf.d/local.conf  /etc/systemd/timesyncd.conf.d/local.conf.original  # -v или --verbose -Выводить информацию о каждом файле, который обрабатывает команда cp.
#ls -l /etc/systemd/timesyncd.conf.d/local.conf  # ls — выводит список папок и файлов в текущей директории
cat /etc/systemd/timesyncd.conf.d/local.conf  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 02
##################################
echo " Создать файл timesyncd.conf в /etc/systemd/ "
touch /etc/systemd/timesyncd.conf   # Создать файл timesyncd.conf в /etc/systemd/
echo " Пропишем серверы NTP (Network Time Protocol)(ru.pool.ntp.org) в /etc/systemd/timesyncd.conf "
echo " Российская Федерация — ru.pool.ntp.org "
> /etc/systemd/timesyncd.conf
cat <<EOF >>/etc/systemd/timesyncd.conf
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it under the
#  terms of the GNU Lesser General Public License as published by the Free
#  Software Foundation; either version 2.1 of the License, or (at your option)
#  any later version.
#
# Entries in this file show the compile time defaults. Local configuration
# should be created by either modifying this file (or a copy of it placed in
# /etc/ if the original file is shipped in /usr/), or by creating "drop-ins" in
# the /etc/systemd/timesyncd.conf.d/ directory. The latter is generally
# recommended. Defaults can be restored by simply deleting the main
# configuration file and all drop-ins located in /etc/.
#
# Use 'systemd-analyze cat-config systemd/timesyncd.conf' to display the full config.
#
# See timesyncd.conf(5) for details.

[Time]
NTP=myntpserver
NTP=server 0.ru.pool.ntp.org
#NTP=0.ru.pool.ntp.org 1.ru.pool.ntp.org 2.ru.pool.ntp.org 3.ru.pool.ntp.org
#NTP=0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org
#NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org
#NTP=0.europe.pool.ntp.org 1.europe.pool.ntp.org 2.europe.pool.ntp.org 3.europe.pool.ntp.org
#NTP=0.africa.pool.ntp.org 1.africa.pool.ntp.org 2.africa.pool.ntp.org 3.africa.pool.ntp.org
FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org
#FallbackNTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org
#RootDistanceMaxSec=5
#PollIntervalMinSec=32
#PollIntervalMaxSec=2048
#ConnectionRetrySec=30
#SaveIntervalSec=60

EOF
#######################
echo " Для начала сделаем его бэкап /etc/systemd/timesyncd.conf "
echo " timesyncd.conf - Это основной файл настройки systemd-timesyncd.service "
#cp /etc/systemd/timesyncd.conf  /etc/systemd/timesyncd.conf.back
cp -v /etc/systemd/timesyncd.conf  /etc/systemd/timesyncd.conf.back  # Для начала сделаем его бэкап
# cp -v /etc/systemd/timesyncd.conf  /etc/systemd/timesyncd.conf.original  # -v или --verbose -Выводить информацию о каждом файле, который обрабатывает команда cp.
#ls -l /etc/systemd/timesyncd.conf  # ls — выводит список папок и файлов в текущей директории
cat /etc/systemd/timesyncd.conf  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 02
##############
echo ""
echo " Запустить и сделать systemd-timesyncd активным "
# timedatectl set-ntp true  # Включаем использование systemd-timesyncd для синхронизации времени
systemctl enable systemd-timesyncd.service
systemctl start systemd-timesyncd.service
#systemctl enable --now systemd-timesyncd.service   # Включаем службу systemd-timesyncd
#systemctl restart systemd-timesyncd.service   # Перезапускаем службу systemd-timesyncd
#systemctl status systemd-timesyncd.service   # Чтобы проверить статус службы systemd-timesyncd.service
# systemctl status systemd-timesyncd   # Чтобы проверить статус службы systemd-timesyncd
# timedatectl timesync-status  # Чтобы просмотреть подробную информацию о сервисе
#timedatectl status   # Процесс синхронизации может быть заметно медленным
#timedatectl show-timesync --all  # Чтобы проверить вашу конфигурацию
echo ""
echo " Запуск Systemd-Timesyncd (systemd-timesyncd.service) выполнен и добавлен в автозагрузку "
echo " Время точное как на Спасской башне Московского Кремля! "
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'   # одновременно отображает дату и часовой пояс
sleep 4
fi
##############
### В большинстве случаев лучше всего использовать pool.ntp.org для поиска сервера NTP (или 0.pool.ntp.org, 1.pool.ntp.org и т. д., если вам нужно несколько имен серверов). Система попытается найти ближайшие доступные серверы для вас.
##############

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить сетевые утилиты Networkmanager?"
echo -e "${BLUE}:: ${NC}'Networkmanager' - сервис для работы интернета."
echo " NetworkManager можно установить с пакетом networkmanager, который содержит демон, интерфейс командной строки (nmcli) и интерфейс на основе curses (nmtui). Вместе с собой устанавливает программы (пакеты) для настройки сети. "
echo -e "${CYAN}=> ${NC}После запуска демона NetworkManager он автоматически подключается к любым доступным системным соединениям, которые уже были настроены. Любые пользовательские подключения или ненастроенные подключения потребуют nmcli или апплета для настройки и подключения. При использовании NetworkManager достаточно просто настроить кэширование DNS-ответов. Эта возможность крайне полезна, если DNS-сервер интернет-провайдера тормозит или ответы от него иногда теряются."
echo -e "${CYAN}=> Примечание: ${NC}Каждый отдельно взятый сетевой интерфейс должен управляться только одним DHCP-клиентом или сетевым менеджером, поэтому скорее всего в системе должен быть запущен только один DHCP-клиент или сетевой менеджер."
echo -e "${CYAN}=> ${NC}Поддержка OpenVPN в Network Manager также внесена в список устанавливаемых программ (пакетов)."
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Да установить,    0 - Нет пропустить: " i_network   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_network" =~ [^10] ]]
do
    :
done
if [[ $i_network  == 1 ]]; then
  echo ""
  echo " Ставим сетевые утилиты Networkmanager "
  pacman -Syy  # обновление баз пакмэна (pacman)
# pacman -Sy networkmanager networkmanager-openvpn network-manager-applet ppp --noconfirm
# pacman -S networkmanager networkmanager-openvpn network-manager-applet ppp --noconfirm  # Диспетчер сетевых подключений и пользовательские приложения; Плагин NetworkManager VPN для OpenVPN; Апплет для управления сетевыми подключениями; Демон, реализующий протокол точка-точка для коммутируемого доступа в сеть.
  pacman -S --noconfirm --needed networkmanager  # Диспетчер сетевых подключений и пользовательские приложения ; https://networkmanager.dev/ ; https://archlinux.org/packages/extra/x86_64/networkmanager/
  pacman -S --noconfirm --needed networkmanager-openvpn  # Плагин NetworkManager VPN для OpenVPN ; https://networkmanager.dev/docs/vpn/ ; https://archlinux.org/packages/extra/x86_64/networkmanager-openvpn/
  pacman -S --noconfirm --needed network-manager-applet  # Апплет для управления сетевыми подключениями ; https://gitlab.gnome.org/GNOME/network-manager-applet ; https://archlinux.org/packages/extra/x86_64/network-manager-applet/
  pacman -S --noconfirm --needed ppp  # Демон, реализующий протокол точка-точка для коммутируемого доступа в сеть ; https://archlinux.org/packages/core/x86_64/ppp/ ; https://www.samba.org/ppp/
  pacman -S --noconfirm --needed nm-connection-editor  #  Редактор подключений и виджеты графического интерфейса NetworkManager (https://wiki.gnome.org/Projects/NetworkManager/) ; https://gitlab.gnome.org/GNOME/network-manager-applet ; https://archlinux.org/packages/extra/x86_64/nm-connection-editor/
  pacman -S --noconfirm --needed dhcpcd  # Клиент DHCP/ IPv4LL/ IPv6RA/ DHCPv6 ; Это также клиент IPv4LL (он же ZeroConf ) ; https://roy.marples.name/projects/dhcpcd/ ; https://archlinux.org/packages/extra/x86_64/dhcpcd/ ; Обеспечивает: dhcp-client ; 2025-06-04 11:08 UTC
  pacman -S --noconfirm --needed dhclient  # Автономный DHCP-клиент из пакета DHCP (Dynamic Host Configuration Protocol) ; https://www.isc.org/dhcp/ ; https://archlinux.org/packages/extra/x86_64/dhclient/ ; Обеспечивает: dhcp-client ; 2025-01-03 19:08 UTC
  pacman -S --noconfirm --needed pptpclient #  Клиент для проприетарного протокола туннелирования точка-точка от Microsoft, PPTP ; http://pptpclient.sourceforge.net/ ; https://archlinux.org/packages/core/x86_64/pptpclient/
  pacman -S --noconfirm --needed rp-pppoe  #  Протокол точка-точка Roaring Penguin через клиент Ethernet ; https://dianne.skoll.ca/projects/rp-pppoe ; https://archlinux.org/packages/extra/x86_64/rp-pppoe/
  pacman -S --noconfirm --needed xl2tpd  # Реализация L2TP с открытым исходным кодом, поддерживаемая Xelerance Corporation ; https://github.com/xelerance/xl2tpd ; https://archlinux.org/packages/extra/x86_64/xl2tpd/
  pacman -S --noconfirm --needed networkmanager-l2tp  # Поддержка L2TP для NetworkManager ; https://archlinux.org/packages/extra/x86_64/networkmanager-l2tp/ ; https://github.com/nm-l2tp/NetworkManager-l2tp
 echo " Установка сетевых утилит (пакетов) завершена "
#sleep 01
################
### pacman -S --noconfirm --needed
### pacman -Qi # pacman {-Q --query} [опции] [пакет(ы)]
################
#echo ""
#echo -e "${BLUE}:: ${NC}Пропишем параметры DNS для Networkmanager"
#echo " Используйте все возможности инструмента управления сетевыми подключениями NetworkManager "
#echo '[main]' >> /etc/NetworkManager/NetworkManager.conf
#echo '#plugins=ifcfg-rh,ibft' >> /etc/NetworkManager/NetworkManager.conf
#echo 'dns=none' >> /etc/NetworkManager/NetworkManager.conf
#echo '#dns=default' >> /etc/NetworkManager/NetworkManager.conf
#echo '#dns=dnsmasq' >> /etc/NetworkManager/NetworkManager.conf
#echo '[logging]' >> /etc/NetworkManager/NetworkManager.conf
#echo '#domains=ALL' >> /etc/NetworkManager/NetworkManager.conf
#echo '[ifubdown]' >> /etc/NetworkManager/NetworkManager.conf
#echo '#managed=false' >> /etc/NetworkManager/NetworkManager.conf
#cat /etc/NetworkManager/NetworkManager.conf
#sleep 3
#echo " Для начала сделаем его бэкап /etc/NetworkManager/NetworkManager.conf "
#echo " NetworkManager.conf - Это основной файл настройки сетевыми подключениями в Linux "
# cp /etc/NetworkManager/NetworkManager.conf  /etc/NetworkManager/NetworkManager.conf.back
#cp -v /etc/NetworkManager/NetworkManager.conf  /etc/NetworkManager/NetworkManager.conf.back  # Для начала сделаем его бэкап
# cp -v /etc/NetworkManager/NetworkManager.conf  /etc/NetworkManager/NetworkManager.conf.original  # -v или --verbose
###########
  clear
  echo ""
  echo -e "${BLUE}:: ${NC}Подключаем Networkmanager в автозагрузку"
# systemctl enable NetworkManager  # systemctl - специальный инструмент для управления службами в Linux
  systemctl enable NetworkManager.service
# systemctl start NetworkManager
# systemctl restart NetworkManager  # Перезапустите NetworkManager
# systemctl status NetworkManager
  systemctl --type=service  # Чтобы NetworkManager не конфликтовал с другими сервисами
  echo " NetworkManager успешно добавлен в автозагрузку "
#  echo " Добавляем в автозагрузку (avahi-daemon.service)"
#  systemctl enable avahi-daemon.service  # Добавляем в автозагрузку (avahi-daemon.service)
#  systemctl restart avahi-daemon.service
  echo ""
  echo " Ускорение загрузки системы (Отключение NetworkManager-wait-online) "
# systemd-analyze blame  # Узнаетть, на сколько задерживается загрузка системы - примерно на ~4 секунды
  systemctl mask NetworkManager-wait-online.service  # В большинстве случаев для настройки интернет подключения вы, скорее всего, будете использовать NetworkManager, т.к. он является в этом деле швейцарским ножом и поставляется по умолчанию. Однако, если вы пропишите команду systemd-analyze blame, то узнаете, что он задерживает загрузку системы примерно на ~4 секунды.
elif [[ $i_network  == 0 ]]; then
  echo " Запуск NetworkManager пропущен "
fi
#### https://wiki.archlinux.org/title/Network_configuration
###
sleep 02
clear
echo ""
echo -e "${GREEN}==> ${NC}Добавим службу Dhcpcd в автозагрузку (для проводного интернета)?"
echo " Добавим dhcpcd в автозагрузку (для проводного интернета, который получает настройки от роутера). "
echo -e "${CYAN}:: ${NC}Dhcpcd - свободная реализация клиента DHCP и DHCPv6. Пакет dhcpcd является частью группы base, поэтому, скорее всего он уже установлен в вашей системе."
echo -e "${CYAN}=> Примечание: ${NC}Каждый отдельно взятый сетевой интерфейс должен управляться только одним DHCP-клиентом или сетевым менеджером, поэтому скорее всего в системе должен быть запущен только один DHCP-клиент или сетевой менеджер."
echo " Если необходимо добавить службу Dhcpcd в автозагрузку это можно сделать уже в установленной системе Arch'a "
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Включить dhcpcd,    0 - Нет - пропустить этот шаг: " x_dhcpcd   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_dhcpcd" =~ [^10] ]]
do
    :
done
if [[ $x_dhcpcd == 1 ]]; then
  echo ""
echo " Будьте внимательны! Пропишем параметр чтобы Dhcpcd не переопределял файл /etc/resolv.conf "
echo 'nohook resolv.conf' >> /etc/dhcpcd.conf  # чтобы он не переопределял файл /etc/resolv.conf
cat /etc/dhcpcd.conf
sleep 1
# systemctl enable dhcpcd   # для активации проводных соединений  # systemctl - инструмент для управления службами
  systemctl enable dhcpcd.service  # Примечание : По умолчанию служба DHCPD не запускается во время загрузки. Чтобы настроить демон на автоматический запуск во время загрузки
# systemctl restart dhcpcd  # Перезапустите службу DHCP
 #systemctl start dhcpcd.service  # Чтобы запустить службу dhcpd
  # systemctl status dhcpcd.service
  # systemctl stop dhcpcd.service  # Чтобы остановить службу dhcpd ; Если необходимо настроить статический IP или использовать другие средства настройки сети
  # systemctl disable dhcpcd.service
  # service dhcpd restart  # Чтобы перезапустить службу dhcpd
  # service dhcpd stop     # Чтобы остановить службу dhcpd
  # service dhcpd start    # Чтобы запустить службу dhcpd
  # chkconfig dhcpd on     # Примечание : По умолчанию служба DHCPD не запускается во время загрузки. Чтобы настроить демон на автоматический запуск во время загрузки
# DHCP (протокол динамической конфигурации хоста) — это протокол, который позволяет отдельным устройствам в IP-сети получать от DHCP-сервера собственную информацию о конфигурации сети (https://wiki.archlinux.org/title/Dhcpd)
# Более старый dhcpd больше не поддерживается!!!
  echo " Dhcpcd успешно добавлен в автозагрузку "
elif [[ $x_dhcpcd == 0 ]]; then
  echo ' Dhcpcd не включен в автозагрузку, при необходиости это можно будет сделать уже в установленной системе '
fi
######################

clear
echo ""
echo -e "${BLUE}:: ${NC}Ставим шрифты"  # https://www.archlinux.org/packages/
pacman -Syy  # обновление баз пакмэна (pacman)
pacman -S --noconfirm --needed ttf-dejavu  # Семейство шрифтов на основе Bitstream Vera Fonts с более широким набором символов
pacman -S --noconfirm --needed ttf-liberation  # Шрифты Red Hats Liberation
pacman -S --noconfirm --needed ttf-anonymous-pro  # Семейство из четырех шрифтов фиксированной ширины, разработанных специально с учетом кодирования
pacman -S --noconfirm --needed noto-fonts-emoji  # Шрифт Google Noto Color Emoji
pacman -S --noconfirm --needed terminus-font  # Моноширинный растровый шрифт (для X11 и консоли)
###
echo ""
echo -e "${BLUE}:: ${NC}Монтирование разделов NTFS и создание ссылок"
pacman -S --noconfirm --needed fuse2  # Библиотека, позволяющая реализовать файловую систему в пользовательской программе ; https://github.com/libfuse/libfuse ; https://archlinux.org/packages/extra/x86_64/fuse2/
pacman -S --noconfirm --needed dosfstools  # Утилиты файловой системы DOS ; https://archlinux.org/packages/core/x86_64/dosfstools/ ; https://github.com/dosfstools/dosfstools ; 2024-08-25 13:37 UTC
### Пакет dosfstools состоит из программ mkfs.fat, fsck.fat и fatlabel для создания, проверки и маркировки файловых систем семейства FAT.
pacman -S --noconfirm --needed util-linux-libs  # Библиотеки времени выполнения util-linux ; https://archlinux.org/packages/core/x86_64/util-linux-libs/ ; https://github.com/util-linux/util-linux ; Обеспечивает: libblkid.so=1-64, libfdisk.so=1-64, libmount.so=1-64, libsmartcols.so=1-64, libutil-linux, libuuid.so=1-64 ; Заменяет: libutil-linux ; Конфликты: С libutil-linux ; 2025-06-26 07:15 UTC
pacman -S --noconfirm --needed util-linux  # Различные системные утилиты для Linux ; https://archlinux.org/packages/core/x86_64/util-linux/ ; https://github.com/util-linux/util-linux ; Обеспечивает: hardlink, rfkill ; Конфликты: с hardlink, rfkill; Заменяет: hardlink, rfkill ; 2025-06-26 07:15 UTC
pacman -S --noconfirm --needed lib32-util-linux  # Различные системные утилиты для Linux (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-util-linux/ ; https://github.com/util-linux/util-linux ; Обеспечивает:  libblkid.so=1-32, libfdisk.so=1-32, libmount.so=1-32, libsmartcols.so=1-32, libuuid.so=1-32 ; 2025-06-26 07:15 UTC
#sudo pacman -S --noconfirm --needed tinyionice  # Миниатюрная версия ionice от util-linux ; https://archlinux.org/packages/extra/x86_64/tinyionice/ ; https://github.com/xyproto/tinyionice ; 2024-07-14 00:28 UTC
pacman -S --noconfirm --needed ntfs-3g  # Драйвер и утилиты файловой системы NTFS; "NTFS file support (Windows Drives)" ; https://www.tuxera.com/community/open-source-ntfs-3g/ ; https://archlinux.org/packages/extra/x86_64/ntfs-3g/
### Зайти в Windows и cmd набрать : powercfg -h off
### Чтобы получить возможность беспроблемно записывать данные на раздел из других операционных систем, убедитесь, что функция "быстрый запуск" отключена. Для этого загрузите Windows и выполните следующую команду в командной строке, запущенной от имени администратора: powercfg /h off
### Предоставление полнофункциональной реализации файловой системы exFAT для Unix-подобных систем #####
pacman -S --noconfirm --needed f2fs-tools  # Инструменты для Flash-дружественной файловой системы (F2FS) ; https://archlinux.org/packages/extra/x86_64/f2fs-tools/ ; https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git/about/ ; Обеспечивает: libf2fs.so=10-64, libf2fs_format.so=9-64 ; 2024-07-24 08:33 UTC
pacman -S --noconfirm --needed fatresize  # Утилита для изменения размера файловых систем FAT с помощью libparted ; https://archlinux.org/packages/extra/x86_64/fatresize/ ; https://sourceforge.net/projects/fatresize/ ; 2024-07-01 22:08 UTC
pacman -S --noconfirm --needed xfsprogs  # Утилиты файловой системы XFS ; https://archlinux.org/packages/core/x86_64/xfsprogs/ ; https://xfs.wiki.kernel.org/ ; 29 июня 2025 г. 14:42 UTC
pacman -S --noconfirm --needed udftools  # Инструменты Linux для файловых систем UDF и приводов DVD/CD-R(W) ; https://archlinux.org/packages/extra/x86_64/udftools/ ; https://github.com/pali/udftools ; 2024-03-18 07:30 UTC
#pacman -S --noconfirm --needed nilfs-utils  # Файловая система со структурой журнала, поддерживающая непрерывное создание снимков (пользовательские утилиты) ; https://archlinux.org/packages/core/x86_64/nilfs-utils/ ; http://nilfs.sourceforge.net/ ; 2024-04-17 18:16 UTC
pacman -S --noconfirm --needed fuse-exfat  # Модуль FUSE - Утилиты для файловой системы exFAT
echo " Инструменты, который выводит список устройств SCSI / SATA "
pacman -S --noconfirm --needed sg3_utils  # Общие утилиты SCSI ; http://sg.danny.cz/sg/sg3_utils.html ; https://archlinux.org/packages/extra/x86_64/sg3_utils/
### Пакет sg3_utils содержит утилиты, которые отправляют команды SCSI на устройства. Помимо устройств на транспортах, традиционно связанных со SCSI (например, Fibre Channel (FCP), Serial Attached SCSI (SAS) и SCSI Parallel Interface (SPI)) многие другие устройства используют наборы команд SCSI. Примерами устройств, использующих наборы команд SCSI, являются приводы CD/DVD ATAPI и диски SATA, подключаемые через уровень трансляции или мостовое устройство.
pacman -S --noconfirm --needed lsscsi  # Инструмент, который выводит список устройств, подключенных через SCSI / SATA устройств и его транспорты ; http://sg.danny.cz/scsi/lsscsi.html ; https://archlinux.org/packages/extra/x86_64/lsscsi/
### Команда lsscsi выводит информацию об устройствах SCSI в Linux. Используя терминологию SCSI, lsscsi выводит список логических устройств SCSI (или целей SCSI , если указана опция '--transport'). Действие по умолчанию — вывести одну строку вывода для каждого устройства SCSI, подключенного в данный момент к системе.
pacman -S --noconfirm --needed polkit  # Набор инструментов для разработки приложений для управления общесистемными привилегиями ; https://archlinux.org/packages/extra/x86_64/polkit/ ; https://github.com/polkit-org/polkit ; Обеспечивает: libpolkit-agent-1.so=0-64, libpolkit-gobject-1.so=0-64 ; 2025-01-15 15:10 UTC
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Установка базовых программ и пакетов"
echo -e " Установка базовых программ (пакетов): wget, curl, git, cmake, nano-syntax-highlighting "
pacman -S --noconfirm --needed wget  # Сетевая утилита для извлечения файлов из Интернета ; https://archlinux.org/packages/extra/x86_64/wget/ ; https://www.gnu.org/software/wget/wget.html ; 2025-03-21 15:18 UTC
pacman -S --noconfirm --needed git  # Быстро распределенная система контроля версий ; https://archlinux.org/packages/extra/x86_64/git/ ; https://git-scm.com/ ; 2025-07-14 10:22 UTC
pacman -S --noconfirm --needed curl  # Инструмент командной строки и библиотека для передачи данных с помощью URL-адресов ; https://archlinux.org/packages/core/x86_64/curl/ ; https://curl.se/ ; Обеспечивает: libcurl.so=4-64 ; Заменяет: wcurl ; Конфликты: с wcurl ; 2025-07-18 07:13 UTC
pacman -S --noconfirm --needed git-lfs  # Расширение Git для управления версиями больших файлов ; https://git-lfs.github.com/ ; https://archlinux.org/packages/extra/x86_64/git-lfs/ ; 13 марта 2024 г., 16:35 UTC ; Git Large File Storage (LFS) заменяет большие файлы, такие как аудиофрагменты, видео, наборы данных и графику, текстовыми указателями внутри Git, сохраняя содержимое файлов на удаленном сервере, например GitHub.com или GitHub Enterprise.
pacman -S --noconfirm --needed haskell-git-lfs  # Реализация протокола git-lfs ; https://hackage.haskell.org/package/git-lfs ; https://archlinux.org/packages/extra/x86_64/haskell-git-lfs/ ; 9 августа 2024 г., 10:47 UTC
pacman -S --noconfirm --needed gnupg  # Полная и бесплатная реализация стандарта OpenPGP ; GnuPG позволяет вам шифровать и подписывать ваши данные и сообщения ; https://archlinux.org/packages/core/x86_64/gnupg/ ; https://www.gnupg.org/ ; 2025-06-23 10:15 UTC
### GnuPG ( https://wiki.archlinux.org/title/GnuPG_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9) )
### Просмотр списка ключей:
# gpg --list-keys  # Вывести список открытых ключей
# gpg --list-secret-keys  # Вывести список закрытых ключей
### Отладка при помощи gpg:
# gpg --homedir /etc/pacman.d/gnupg --list-key  # При отладке доступ к связке ключей pacman можно получить напрямую с помощью gpg
### Экспорт открытого ключа:
# gpg --export --armor --output public-key.asc user-id  # Чтобы сгенерировать ASCII-версию открытого ключа пользователя в файл public-key.asc (например, для отправки по электронной почте)
### Импорт открытого ключа:
# gpg --import public-key.asc  # Чтобы зашифровать сообщения другим людям, а также проверить их подписи, вам нужен их открытый ключ. Чтобы импортировать открытый ключ из файла public-key.asc в свой список открытых ключей
pacman -S --noconfirm --needed rsync  # Быстрый и универсальный инструмент для копирования удаленных и локальных файлов
pacman -S --noconfirm --needed grsync  # GTK + GUI для rsync для синхронизации папок, файлов и создания резервных копий
pacman -S --noconfirm --needed cmake  # Кросс-платформенная система сборки с открытым исходным кодом
pacman -S --noconfirm --needed extra-cmake-modules  # Дополнительные модули и скрипты для CMake
pacman -S --noconfirm --needed glibc  # Библиотека GNU C ; https://www.gnu.org/software/libc ; https://archlinux.org/packages/core/x86_64/glibc/
pacman -S --noconfirm --needed yajl  # Еще одна библиотека JSON ; https://archlinux.org/packages/extra/x86_64/yajl/ ; https://github.com/lloyd/yajl ; Обеспечивает: libyajl.so=2-64 ; 2024-02-21 11:16 UTC
pacman -S --noconfirm --needed ninja  # Небольшая система сборки с упором на скорость
pacman -S --noconfirm --needed perf  # Инструмент аудита производительности ядра Linux
pacman -S --noconfirm --needed perl  # Высокопроизводительный, многофункциональный язык программирования ; https://archlinux.org/packages/core/x86_64/perl/ ; https://www.perl.org/ ; Обеспечивает: perl-archive-tar=3.04, perl-attribute-handlers=1.03, perl-autodie=2.37, perl-autoloader=5.74, perl-autouse=1.11 ; 2025-07-16 18:19 UTC
pacman -S --noconfirm --needed perl-rename  # Переименовывает несколько файлов с использованием регулярных выражений Perl ; https://archlinux.org/packages/extra/any/perl-rename/ ; https://search.cpan.org/~pederst/rename/ ; 2025-07-16 18:22 UTC
### В Arch Linux команда rename (perl-rename) доступна для переименования файлов и каталогов на основе регулярных выражений. Утилита не поставляется в дистрибутив сразу после установки, её нужно установить дополнительно.
pacman -S --noconfirm --needed nano nano-syntax-highlighting  # Улучшения подсветки синтаксиса в редакторе Nano (2020.10.10-2)
pacman -S --noconfirm --needed gpart  # Инструмент для спасения / угадывания таблицы разделов
pacman -S --noconfirm --needed bash  # Оболочка GNU Bourne Again ; https://archlinux.org/packages/core/x86_64/bash/ ; https://www.gnu.org/software/bash/bash.html ; 2025-08-02 12:29 UTC
pacman -S --noconfirm --needed bash-completion  # Программируемое завершение для оболочки bash
pacman -S --noconfirm --needed ccache  # Кэш компилятора, который ускоряет перекомпиляцию за счет кеширования предыдущих
pacman -S --noconfirm --needed squashfs-tools  # Инструменты для squashfs, файловой системы Linux с высокой степенью сжатия, доступной только для чтения
pacman -S --noconfirm --needed archinstall  # Еще один пошаговый/автоматизированный установщик Arch Linux с изюминкой ; https://github.com/archlinux/archinstall ; https://archlinux.org/packages/extra/any/archinstall/
pacman -S --noconfirm --needed arch-install-scripts  # Сценарии для помощи в установке Arch Linux
pacman -S --noconfirm --needed devtools  # Инструменты для сопровождающих Arch Linux пакетов ; https://gitlab.archlinux.org/archlinux/devtools ; https://archlinux.org/packages/extra/any/devtools/ ; Devtools — инструменты разработки для Arch Linux ; Этот репозиторий содержит инструменты для дистрибутива Arch Linux, позволяющие создавать и поддерживать официальные пакеты репозитория.
pacman -S --noconfirm --needed lvm2  #  Утилиты Logical Volume Manager 2 (https://sourceware.org/lvm2/)
pacman -S --noconfirm --needed btrfs-progs  # Утилиты файловой системы btrfs ; https://archlinux.org/packages/core/x86_64/btrfs-progs/ ; https://btrfs.readthedocs.io/ ; Заменяет: btrfs-progs-unstable ; Конфликты: с btrfs-progs-unstable ; 2025-06-23 17:52 UTC
pacman -S --noconfirm --needed hashcat  # Многопоточная расширенная утилита восстановления паролей ; https://hashcat.net/hashcat ; https://archlinux.org/packages/extra/x86_64/hashcat/
############ shfmt ##############
# Отформатируйте программы оболочки с помощью Shfmt в Linux
# https://ru.linux-terminal.com/?p=4922
pacman -S --noconfirm --needed shfmt  # Форматировать программы оболочки ; https://archlinux.org/packages/extra/x86_64/shfmt/ ; https://github.com/mvdan/sh ; 2025-07-08 19:47 UTC
# shfmt --help  # Если вы используете Shfmt впервые, начните с запуска команды help, чтобы получить представление о том, какие параметры поддерживает shfmt
pacman -S --noconfirm --needed desktop-file-utils  # Утилиты командной строки для работы с записями рабочего стола ; https://archlinux.org/packages/extra/x86_64/desktop-file-utils/ ; https://www.freedesktop.org/wiki/Software/desktop-file-utils ; 2024-10-26 13:33 UTC
### desktop-file-utils содержит несколько утилит командной строки для работы с записями рабочего стола :
# desktop-file-validate: проверяет файл рабочего стола и выводит предупреждения/ошибки о нарушениях спецификации записи рабочего стола.
# desktop-file-install: устанавливает файл рабочего стола в каталог приложений, при необходимости немного изменяя его при передаче.
# update-desktop-database: обновляет базу данных, содержащую кэш MIME-типов, обрабатываемых файлами рабочего стола. Для компиляции требуется GLib , поскольку реализация требует утилит Unicode и т.п. Разработка ведётся на Git, в репозитории xdg/desktop-file-utils (https://gitlab.freedesktop.org/xdg/desktop-file-utils).
pacman -S --noconfirm --needed xdg-utils  # Инструменты командной строки, помогающие приложениям решать различные задачи интеграции с рабочим столом ; https://archlinux.org/packages/extra/any/xdg-utils/ ; https://www.freedesktop.org/wiki/Software/xdg-utils/ ; 2024-02-06 13:02 UTC
########### Инструменты диагностики памяти ############
pacman -S --noconfirm --needed memtest86+  # Расширенный инструмент диагностики памяти устаревшей версии BIOS ; https://archlinux.org/packages/extra/any/memtest86+/ ; https://www.memtest.org/ ; Разделенные пакеты: memtest86+-efi , memtest86+-iso ; 2024-12-26 10:08 UTC
pacman -S --noconfirm --needed memtest86+-efi  # Расширенный инструмент диагностики памяти версии EFI ; https://archlinux.org/packages/extra/any/memtest86+-efi/ ; https://www.memtest.org/ ; Базовый пакет: memtest86+ ; 2024-12-26 10:08 UTC
pacman -S --noconfirm --needed memtest86+-iso  # Расширенный инструмент диагностики памяти ISO-образ ; https://archlinux.org/packages/extra/any/memtest86+-iso/ ; https://www.memtest.org/ ; Базовый пакет: memtest86+ ; 2024-12-26 10:08 UTC
echo ""
echo -e "${BLUE}:: ${NC}Утилита ps (procps-ng) "
echo -e "${BLUE}:: ${NC}Самый простой способ посмотреть список процессов, запущенных в текущей командой оболочке "
pacman -S --noconfirm --needed procps-ng  # Утилиты для мониторинга вашей системы и ее процессов ; https://archlinux.org/packages/core/x86_64/procps-ng/ ; https://gitlab.com/procps-ng/procps ; Заменяет:  procps, sysvinit-tools ; Конфликты: с procps, sysvinit-tools ; 2025-03-25 23:27 UTC
pacman -S --noconfirm --needed lib32-procps-ng  # Утилиты для мониторинга вашей системы и ее процессов (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-procps-ng/ ; https://sourceforge.net/projects/procps-ng/ ; Обеспечивает: libproc2.so=1-32 ; 2024-12-22 14:52 UTC
# yay -S procps-ng-git --noconfirm  # Утилиты для мониторинга вашей системы и ее процессов ; https://aur.archlinux.org/packages/procps-ng-git ; https://aur.archlinux.org/procps-ng-git.git (только для чтения, нажмите, чтобы скопировать) ; https://gitlab.com/procps-ng/procps ; Конфликты:  с procps, procps-ng, sysvinit-tools ; Обеспечивает: libproc-2.so, procps, procps-ng, sysvinit-tools ; 2025-03-26 06:41 (UTC)
pacman -S --noconfirm --needed lib32-libprocps  # Библиотеки procps 3.x для мониторинга вашей системы и ее процессов ; https://archlinux.org/packages/multilib/x86_64/lib32-libprocps/ ; https://gitlab.com/procps-ng/procps ; Обеспечивает: libprocps.so=8-32 ; 2024-06-15 09:53 UTC
pacman -S --noconfirm --needed libprocps  # Библиотеки procps 3.x для мониторинга вашей системы и ее процессов ; https://archlinux.org/packages/extra/x86_64/libprocps/ ; https://gitlab.com/procps-ng/procps ; Обеспечивает: libprocps.so=8-64 ; 2024-07-24 08:33 UTC
echo ""
echo -e "${BLUE}:: ${NC}Поддержка реализации протокола DNS "
pacman -S --noconfirm --needed bind  # Полная, портативная реализация протокола DNS ; https://www.isc.org/software/bind/ ; https://archlinux.org/packages/extra/x86_64/bind/
pacman -S --noconfirm --needed bind-tools  #
#dig @1.1.1.1 archlinux.org  # для опроса DNS-серверов
pacman -S --noconfirm --needed ldns  # Библиотека быстрого DNS, поддерживающая последние RFC ; Библиотека быстрого DNS, поддерживающая последние RFC ; https://www.nlnetlabs.nl/projects/ldns/ ; https://archlinux.org/packages/core/x86_64/ldns/
#drill archlinux.org | grep "Query time"
#####################
echo ""
echo -e "${BLUE}:: ${NC}Установка пакетов Реализации виртуальной файловой системы для GIO "
pacman -S --noconfirm --needed gvfs  # Реализация виртуальной файловой системы для GIO (Разделенные пакеты: gvfs-afc, gvfs-goa, gvfs-google, gvfs-gphoto2, gvfs-mtp, еще…)
pacman -S --noconfirm --needed gvfs-mtp  # Реализация виртуальной файловой системы для GIO (бэкэнд MTP; Android, медиаплеер)
pacman -S --noconfirm --needed gvfs-afc  # Реализация виртуальной файловой системы для GIO (серверная часть AFC; мобильные устройства Apple)
pacman -S --noconfirm --needed gvfs-goa  # Реализация виртуальной файловой системы для GIO - бэкэнд Gnome Online Accounts (например, OwnCloud) ; https://gitlab.gnome.org/GNOME/gvfs ; https://archlinux.org/packages/extra/x86_64/gvfs-goa/
pacman -S --noconfirm --needed gvfs-google  # Реализация виртуальной файловой системы для GIO — бэкэнд Google Drive (серверная часть Google Диска ; https://gitlab.gnome.org/GNOME/gvfs ; https://archlinux.org/packages/extra/x86_64/gvfs-google/
pacman -S --noconfirm --needed gvfs-gphoto2  # Реализация виртуальной файловой системы для GIO (бэкэнд gphoto2; камера PTP, медиаплеер MTP)
pacman -S --noconfirm --needed gvfs-nfs  # Реализация виртуальной файловой системы для GIO (серверная часть NFS)
pacman -S --noconfirm --needed gvfs-smb  # Реализация виртуальной файловой системы для GIO (серверная часть SMB / CIFS;
##########Библиотека CAC (Common Access Card) ###########
pacman -S --noconfirm --needed libcacard  # Библиотека CAC (Common Access Card), которая обеспечивает эмуляцию смарт-карт для виртуального считывателя карт, работающего в гостевой виртуальной машине ; https://archlinux.org/packages/extra/x86_64/libcacard/ ; https://gitlab.freedesktop.org/spice/libcacard ; 2024-08-25 00:05 UTC
sleep 1
#####################

echo ""
echo -e "${GREEN}=> ${BOLD}Создадим конфигурационный файл для установки системных переменных /etc/sysctl.conf ${NC}"
echo " Sysctl - это инструмент для проверки и изменения параметров ядра во время выполнения (пакет procps-ng в официальных репозиториях ). sysctl реализован в procfs , файловой системе виртуального процесса в /proc/. "
> /etc/sysctl.conf
cat <<EOF >>/etc/sysctl.conf

#
# /etc/sysctl.conf - Configuration file for setting system variables
# See /etc/sysctl.d/ for additional system variables.
# See sysctl.conf (5) for information.
#
# /etc/sysctl.d/99-sysctl.conf
#

#kernel.domainname = example.com

# Uncomment the following to stop low-level messages on console
#kernel.printk = 3 4 1 3

# To enable user namespaces
# As of April 2021, these steps are no longer required for Arch Linux
# kernel.unprivileged_userns_clone=1

##############################################################3
# Functions previously found in netbase
#

# Uncomment the next two lines to enable Spoof protection (reverse-path filter)
# Turn on Source Address Verification in all interfaces to
# prevent some spoofing attacks
#net.ipv4.conf.default.rp_filter=1
#net.ipv4.conf.all.rp_filter=1

# Uncomment the next line to enable TCP/IP SYN cookies
# See http://lwn.net/Articles/277146/
# Note: This may impact IPv6 TCP sessions too
net.ipv4.tcp_syncookies=1

# Uncomment the next line to enable packet forwarding for IPv4
net.ipv4.ip_forward=1

# Uncomment the next line to enable packet forwarding for IPv6
#  Enabling this option disables Stateless Address Autoconfiguration
#  based on Router Advertisements for this host
#net.ipv6.conf.all.forwarding=1


###################################################################
# Additional settings - these settings can improve the network
# security of the host and prevent against some network attacks
# including spoofing attacks and man in the middle attacks through
# redirection. Some network environments, however, require that these
# settings are disabled so review and enable them as needed.
#
# Do not accept ICMP redirects (prevent MITM attacks)
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
# _or_
# Accept ICMP redirects only for gateways listed in our default
# gateway list (enabled by default)
# net.ipv4.conf.all.secure_redirects = 1
#
# Do not send ICMP redirects (we are not a router)
#net.ipv4.conf.all.send_redirects = 0
#
# Do not accept IP source route packets (we are not a router)
#net.ipv4.conf.all.accept_source_route = 0
#net.ipv6.conf.all.accept_source_route = 0
#
# Log Martian Packets
#net.ipv4.conf.all.log_martians = 1
#
net.ipv4.tcp_timestamps=0
net.ipv4.conf.all.rp_filter=1
net.ipv4.tcp_max_syn_backlog=1280
kernel.core_uses_pid=1
#
# Fixing the indicator when writing files to a flash drive
vm.dirty_bytes = 4194304
vm.dirty_background_bytes = 4194304
#
# Do less swapping
vm.dirty_ratio = 40
# vm.dirty_ratio=50
# vm.dirty_background_ratio=1
vm.dirty_background_ratio = 2
# vm.swappiness = 70
# vm.swappiness = 100
vm.swappiness = 10
# vm.vfs_cache_pressure = 50
vm.vfs_cache_pressure= 500
# vm.vfs_cache_pressure = 1000

EOF
###
echo -e "${BLUE}:: ${NC}Перемещаем и переименовываем исходный файл /etc/sysctl.conf в /etc/sysctl.d/99-sysctl.conf"
cp /etc/sysctl.conf  /etc/sysctl.conf.back  # Для начала сделаем его бэкап
mv /etc/sysctl.conf /etc/sysctl.d/99-sysctl.conf   # Перемещаем и переименовываем исходный файл
#sysctl -p /etc/sysctl.d/99-sysctl.conf  # Подгрузить созданный файл конфигурации
#sysctl -a |grep swappiness  # Посмотреть что параметр действительно поменялся
# Поменять vm.swappiness можно следующим образом
# Файл настроек sysctl может быть создан в /etc/sysctl.d/99-sysctl.conf
# Создать файл /etc/sysctl.d/99-sysctl.conf и добавим в него строчку:
# vm.swappiness=70
# Если вносили изменения в файл /etc/sysctl.d/99-sysctl.conf:
# sysctl -p
# Подгрузить созданный файл конфигурации:
# sudo sysctl -p /etc/sysctl.d/99-sysctl.conf
# Посмотреть что параметр действительно поменялся можно выполнив команду:
# sudo sysctl -a |grep swappiness
# Проверяем — должны остаться только адреса IPv4:
# ip a
#################################
echo ""
echo -e "${BLUE}:: ${NC}IPv6 далеко не всегда может использоваться в системе. Более того, он может вызвать некоторые проблемы при обращении к локальной петле (127.0.0.1) — запросы могут пойти на адрес ::1, что может привести к тому, что некоторые приложения будут работать не корректно. Отключить IPv6 через настройку ядра. Это универсальный способ и он подойдет для многих дистрибутивов на базе Linux."
echo " Создать файл 10-ipv6-privacy.conf в /etc/sysctl.d/ "
touch /etc/sysctl.d/10-ipv6-privacy.conf   # Создать файл 10-ipv6-privacy.conf в /etc/sysctl.d/
echo " Пропишем конфигурации для ipv6 "
> /etc/sysctl.d/10-ipv6-privacy.conf
cat <<EOF >>/etc/sysctl.d/10-ipv6-privacy.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1

EOF
####################
# Если нужно отключить IPv6 только для одного интерфейса, например, для eth0, также открываем настройку ядра.
# * где eth0 наш интерфейс, для которого мы хотим отключить IPv6.
# net.ipv6.conf.eth0.disable_ipv6 = 1
# Применяем настройки:
# sysctl -p
# или
# sysctl -p /etc/sysctl.d/10-ipv6-privacy.conf
# Если вносили изменения в файл /etc/sysctl.d/10-ipv6-privacy.conf
# sysctl -p /etc/sysctl.d/10-ipv6-privacy.conf
### 99-sysctl.conf является основным конфигурационным файлом, а 10-ipv6-privacy.conf в каталоге sysctl.d — дополнительным. Для удобства лучше использовать последний.
#############################
echo ""
echo -e "${BLUE}:: ${NC}Чтобы разрешить запуск ping и разрешить прослушивание любого порта без прав root."
echo " Разрешение прослушивания портов TCP и UDP ниже 1024: Большинство дистрибутивов не позволяют пользователям, не являющимся root, прослушивать порты TCP и UDP ниже 1024. Например, прослушивание порта 80/tcp завершится ошибкой «отказано в доступе», тогда как прослушивание порта 8080/tcp будет успешным. С апреля 2021 года эти шаги больше не требуются для Arch Linux, но сделаем разрешение на всякий случай! "
echo " Создать файл 99-rootless.conf в /etc/sysctl.d/ "
touch /etc/sysctl.d/99-rootless.conf   # Создать файл 99-rootless.conf в /etc/sysctl.d/
echo " Пропишем конфигурации для printk "
> /etc/sysctl.d/99-rootless.conf
cat <<EOF >>/etc/sysctl.d/99-rootless.conf
net.ipv4.ping_group_range = 0 2147483647
net.ipv4.ip_unprivileged_port_start=0

EOF
####################
### Затем выполните следующую команду, чтобы перезагрузить новую конфигурацию sysctl:
# sysctl --system
#################

echo ""
echo -e "${BLUE}:: ${NC}Чтобы скрыть сообщения ядра или простых предупреждений на консоли, добавьте или измените строку kernel.printk в соответствии с ArchWiki"
echo " Выдержка из документации Linux sysctl/kernel.txt - Четыре значения в printk обозначают: console_loglevel, default_message_loglevel, minimum_console_loglevel и default_console_loglevel соответственно. Эти значения влияют на поведение printk() при печати или регистрации сообщений об ошибках. См. 'man 2 syslog' для получения дополнительной информации о различных уровнях журнала. console_loglevel: сообщения с более высоким приоритетом будут выводиться на консоль; default_message_level: сообщения без явного приоритета будут выводиться с этим приоритетом; minimum_console_loglevel: минимальное (максимальное) значение, на которое может быть установлен console_loglevel; default_console_loglevel: значение по умолчанию для console_loglevel . "
echo " Таким образом, используя указанные выше значения для аргументов printk, вы можете заставить ядро ​​замолчать относительно информационных сообщений или простых предупреждений на консоли. "
echo " Создать файл 20-quiet-printk.conf в /etc/sysctl.d/ "
touch /etc/sysctl.d/20-quiet-printk.conf   # Создать файл 20-quiet-printk.conf в /etc/sysctl.d/
# echo "3 3 3 3" > /proc/sys/kernel/printk
echo " Пропишем конфигурации для printk "
> /etc/sysctl.d/20-quiet-printk.conf
cat <<EOF >>/etc/sysctl.d/20-quiet-printk.conf
kernel.printk = 3 3 3 3

EOF
####################

echo ""
echo -e "${BLUE}:: ${NC}Добавим в файл /etc/arch-release ссылку на сведение о release"
> /etc/arch-release
cat <<EOF >>/etc/arch-release
Arch Linux release
#../usr/lib/os-release
#Request for release information (Запрос информации о релизе)
#cat /etc/arch-release
#cat /etc/*-release
#cat /etc/issue
#cat /etc/lsb-release
#cat /etc/lsb-release | cut -c21-90
#cat /proc/version

EOF
###
echo -e "${BLUE}:: ${NC}Создадим файл /etc/lsb-release (информация о релизе)"
> /etc/lsb-release.old
cat <<EOF >>/etc/lsb-release.old
NAME="Arch Linux"
PRETTY_NAME="Arch Linux"
ID=arch
DISTRIB_RELEASE=rolling
DISTRIB_CODENAME="Arch"
DISTRIB_DESCRIPTION="Arch Linux"
ANSI_COLOR="38;2;23;147;209"
HOME_URL="https://www.archlinux.org/"
DOCUMENTATION_URL="https://wiki.archlinux.org/"
SUPPORT_URL="https://bbs.archlinux.org/"
BUG_REPORT_URL="https://bugs.archlinux.org/"
LOGO=archlinux

EOF
###############################
echo " Для начала бэкап /etc/resolv.conf "
echo " resolv.conf - Это основной файл настройки библиотеки распознавателя имен DNS "
#cp /etc/resolv.conf  /etc/resolv.conf.back
cp -v /etc/resolv.conf  /etc/resolv.conf.back  # Для начала сделаем его бэкап
# cp -v /etc/resolv.conf  /etc/resolv.conf.original  # -v или --verbose -Выводить информацию о каждом файле, который обрабатывает команда cp.
########
#echo ""
#echo " Пропишем публичные серверы DNS в /etc/systemd/resolved.conf "
#echo " Сообщить systemd-resolved ip-адреса DNS-серверов, к которым следует обращаться для резолвинга "
#echo 'DNS=1.1.1.1 1.0.0.1' >> /etc/systemd/resolved.conf
#echo 'MulticastDNS=no' >> /etc/systemd/resolved.conf
#echo 'LLMNR=no' >> /etc/systemd/resolved.conf
#echo 'Cache=yes' >> /etc/systemd/resolved.conf
# echo 'DNSStubListener=yes' >> /etc/systemd/resolved.conf
##########
echo ""
echo " Пропишем Проводной адаптер с использованием DHCP в /etc/systemd/network/20-ethernet.network "
echo " systemd-networkd — системный демон для управления сетевыми настройками. Его задачей является обнаружение и настройка сетевых устройств по мере их появления, а также создание виртуальных сетевых устройств. "
touch /etc/systemd/network/20-ethernet.network   # Создать файл в /etc/systemd/network/20-ethernet.network
cat <<EOF >/etc/systemd/network/20-ethernet.network
[Match]
Name=en*
Name=eth*

[Network]
Address=
Gateway=
DHCP=yes

[DHCPv4]
RouteMetric=

[IPv6AcceptRA]
RouteMetric=

EOF
###
echo " Запустим службу systemd-networkd "
systemctl enable systemd-networkd
#systemctl status systemd-networkd
################

echo ""
echo -e "${BLUE}:: ${NC}Автоматическая очистка кэша пакетов "
pacman -S --noconfirm --needed pacman-contrib  # Предоставленные скрипты и инструменты для систем pacman
echo " Создадим файл (скрипт) paccache.timer в /etc/systemd/system/ — система автоматически будет запускать его раз в месяц с помощью таймера systemd . *По сути, файл paccache.timer в /etc/systemd/system/ запустит /usr/lib/systemd/system/paccache.service, который будет запускать paccache ежемесячно и очищать кэш ваших старых и неустановленных пакетов. Просмотр всех опций команды paccache: paccache -h . Справка по paccache: man paccache . Кэш pacman расположен в директории /var/cache/pacman/pkg/ , Узнать размер кэша: du -sh /var/cache/pacman/pkg/ , Для удаления пакетов из кэша необходимо запустить утилиту paccache с ключом -r. Рассмотрим несколько вариантов использования утилиты. Удалить все кэшированные пакеты, кроме трех самых последних для каждого пакета: sudo paccache -r , Удалить все кэшированные пакеты, но указать количество версий, которые нужно оставить — используется ключ -k, за которым указывается количество. Удалим все кэшированные пакеты, но оставим по две последних версии: sudo paccache -rk2 , Удалить все кэшированные пакеты, которых уже нет в системе (уже были удалены из системы, но архивые есть в кэше) — используется ключ -u: sudo paccache -ruk0 . "
echo " Создать файл paccache.timer в /etc/systemd/system/ "
touch /etc/systemd/system/paccache.timer   # Создать файл paccache.timer в /etc/systemd/system/
echo " Пропишем конфигурации для ipv6 "
> /etc/systemd/system/paccache.timer
cat <<EOF >>/etc/systemd/system/paccache.timer
[Unit]
Description=Clean-up old pacman pkg

[Timer]
OnCalendar=monthly
Persistent=true

[Install]
WantedBy=multi-user.target

EOF
###############
echo ""
echo -e "${BLUE}:: ${NC}Добавляем ещё одну *Плюшку для pacman (Бегать paccache за pacman) "
echo " В качестве альтернативы предыдущиму таймеру вы также можете запускать его paccache каждый раз после запуска pacman. Для этого создадим Hook для этого. Просто Создадим файл в /usr/share/libalpm/hooks/paccache.hook. После его создания, если я удалю пакет с помощью pacman, paccache он также будет выполнен. "
echo " Создать файл paccache.hook в /usr/share/libalpm/hooks/ "
touch /usr/share/libalpm/hooks/paccache.hook   # Создать файл в /usr/share/libalpm/hooks/paccache.hook
echo " Пропишем конфигурации для ipv6 "
> /usr/share/libalpm/hooks/paccache.hook
cat <<EOF >>/usr/share/libalpm/hooks/paccache.hook
[Trigger]
Operation = Upgrade
Operation = Install
Operation = Remove
Type = Package
Target = *

[Action]
Description = Cleaning pacman cache with paccache …
When = PostTransaction
Exec = /usr/bin/paccache -r

EOF
############
echo -e "${BLUE}:: ${NC}Подключаем paccache.timer в автозагрузку"
systemctl enable paccache.timer  # добавить в автозапуск
# systemctl start paccache.timer  # запустите службу systemd
# systemctl status paccache.timer  # можете проверить статус услуги
echo " paccache.timer успешно добавлен в автозагрузку "
###

clear
echo ""
echo -e "${BLUE}:: ${NC}Автоматизация обновления зеркал /etc/pacman.d/mirrorlist (запуск Reflector при загрузке), pacman-mirrorlist не обновляется регулярно, вызов рефлектора только потому, что какое-то зеркало в какой-то части земного шара было добавлено или удалено, не имеет значения. Вместо этого используйте автоматизацию на основе таймера. Если вы вообще не хотите mirrorlist.pacnew устанавливаться, используйте NoExtractвpacman.conf."
echo " Reflector поставляется с файлом reflector.service. Служба запустит рефлектор с параметрами, указанными в /etc/xdg/reflector/reflector.conf. Параметры по умолчанию в этом файле должны служить хорошей отправной точкой и примером. "
echo " Чтобы обновить список зеркал досрочно, запустите reflector.service . "
echo " Примечание: reflector.service зависит от службы ожидания сети, которая будет настроена через network-online.target ."
pacman -Sy --noconfirm --needed --noprogressbar --quiet reflector  # Модуль и скрипт Python 3 для получения и фильтрации последнего списка зеркал Pacman ; https://xyne.dev/projects/reflector ; https://archlinux.org/packages/extra/any/reflector/ (reflector --help)
### https://ostechnix.com/retrieve-latest-mirror-list-using-reflector-arch-linux/
pacman -Sy --noconfirm --needed --noprogressbar --quiet pacman-mirrorlist  # отображает версию pacman-mirrors, а затем статус зеркал, которые в данный момент указаны в вашем списке зеркал.
### pacman-mirrors --status  # Получить статус текущих зеркал
### pacman-mirrors --fasttrack  # Команда sudo pacman-mirrors --fasttrack используется для выбора быстрых зеркал для обновлений и установки пакетов. Она измеряет скорость доступа к имеющимся зеркалам и выбирает самые быстрые из них. Создайте список зеркал, используя настройки по умолчанию
### pacman-mirrors --fasttrack 20 && pacman -Syyu
### pacman-mirrors --get-branch  # Отобразить текущую ветку
### sudo pacman-mirrors --api --set-branch {{stable|unstable|testing}}  # Переключиться на другую ветку
### sudo pacman-mirrors --geoip  # Создайте список зеркал, используя только зеркала в вашей стране
#echo " Начинаем с удаления старой резервной копии (если она есть, если нет, то пропустите этот шаг) "
#rm /etc/pacman.d/mirrorlist.old
echo " Сохраняем старый список зеркал в качестве резервной копии "
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old
echo " Обновление списка зеркал (Russia) "
#reflector --verbose --country 'Russia' -l 9 -p https -p http -n 9 --save /etc/pacman.d/mirrorlist
reflector --verbose -c ru -p https,http --sort score --save /etc/pacman.d/mirrorlist
# curl -o /etc/pacman.d/mirrorlist https://archlinux.org/mirrorlist/all/  # Загрузите список зеркал напрямую с сайта ; Раскомментируйте предпочитаемые зеркала ; https://wiki.archlinux.org/title/Mirrors
# sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup  # чтобы раскомментировать все зеркала
# rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist # отсортируйте сервера. В данном случае, -n 6 выводит только 6 наиболее быстрых зеркал
#echo " Переименовываем новый список (mirrorlist) "
#mv /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist
###
echo ""
echo " Создать каталог (hooks) в /etc/pacman.d/ "
mkdir /etc/pacman.d/hooks   # Создать каталог hooks в /etc/pacman.d/
echo " Создать файл mirrorupgrade.hook в /etc/pacman.d/hooks/ "
touch /etc/pacman.d/hooks/mirrorupgrade.hook   # Создать файл mirrorupgrade.hook в /etc/pacman.d/hooks/
echo " Пропишем конфигурации в reflector.service "
cat > /etc/pacman.d/hooks/mirrorupgrade.hook << EOF
[Trigger]
Operation = Upgrade
Type = Package
Target = pacman-mirrorlist

[Action]
Description = Updating pacman-mirrorlist with reflector
When = PostTransaction
Depends = reflector
# Exec = /usr/bin/reflector -c ru,by,ua,pl -p https,http --sort rate -a 12 -l 10 --save /etc/pacman.d/mirrorlist
# Exec = /usr/bin/reflector -c ru -p https,http --sort rate -a 12 -l 10 --save /etc/pacman.d/mirrorlist
Exec = /usr/bin/reflector --verbose --country 'Russia' -l 9 -p https -p http -n 9 --save /etc/pacman.d/mirrorlist

EOF
###########
echo " В большинстве случаев, при принудительном обновлении базы данных pacman, необходимо также принудительно откатить "слишком новые" пакеты, чтобы их версии соответствовали версиям на новом зеркале. Это предотвращает проблемы, приводящие к частичному обновлению системы. "
pacman -Syyuu  # Важно: В большинстве случаев, при принудительном обновлении базы данных pacman, необходимо также принудительно откатить "слишком новые" пакеты, чтобы их версии соответствовали версиям на новом зеркале. Это предотвращает проблемы, приводящие к частичному обновлению системы.
sleep 1
####

clear
echo -e "${MAGENTA}
  <<< Создание полного набора пользовательских каталогов по умолчанию, в пределах "HOME" каталога >>> ${NC}"
echo ""
echo -e "${GREEN}==> ${NC}Создаём папки в директории пользователя (Downloads, Music, Pictures, Videos, Documents)."
echo -e "${BLUE}:: ${NC}Создание полного набора локализованных пользовательских каталогов по умолчанию (Загрузки, Шаблоны, Общедоступные, Документы, Музыка, Изображения, Видео) в пределах "HOME" каталога."
echo -e "${CYAN}:: ${NC}По умолчанию в системе Arch Linux в каталоге "HOME" НЕ создаются папки (Загрузки, Шаблоны, Общедоступные, Документы, Музыка, Изображения, Видео), кроме папки Рабочий стол (Desktop)."
echo -e "${CYAN}:: ${NC}Согласно философии Arch, вместо удаления ненужных пакетов, папок, пользователю предложена возможность построить систему, начиная с минимальной основы без каких-либо заранее выбранных шаблонов... "
echo " Давайте проанализируем действия, которые выполняются. "
echo " 1 - Создание каталогов по умолчанию с помощью (xdg-user-dirs), тогда укажите вариант "1" "
echo " xdg-user-dirs - это инструмент, помогающий создать и управлять "хорошо известными" пользовательскими каталогами, такими как папка рабочего стола, папка с музыкой и т.д.. Он также выполняет локализацию (то есть перевод) имен файлов. "
echo " Большинство файловых менеджеров обозначают пользовательские каталоги XDG специальными значками. "
echo " 2(0) - Если Вам не нужны папки в директории пользователя, или в дальнейшем уже в установленной системе, Вы сами создадите папки, тогда выбирайте вариант "0" "
echo -e "${CYAN}:: ${NC}Есть другие способы создания локализованных пользовательских каталогов, но в данном скрипте они не будут представлены. "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Создание каталогов с помощью (xdg-user-dirs),

    0 - Пропустить создание каталогов: " i_catalog  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_catalog" =~ [^10] ]]
do
    :
done
if [[ $i_catalog == 0 ]]; then
  echo ""
  echo " Создание каталогов пропущено "
elif [[ $i_catalog == 1 ]]; then
  echo ""
  echo " Создание пользовательских каталогов по умолчанию "
  pacman -Syy  # обновление баз пакмэна (pacman)
  pacman -S xdg-user-dirs --noconfirm  # Управляйте пользовательскими каталогами, такими как ~ / Desktop и ~ / Music
  pacman -S xdg-user-dirs-gtk --noconfirm  # Создаёт каталоги пользователей и просит их переместить
  xdg-user-dirs-update
  xdg-user-dirs-gtk-update  # Обновить закладки в thunar (левое меню)
  echo ""
  echo " Создание каталогов успешно выполнено "
fi
###########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить CCM (clean-chroot-manager) - Оболочка для управления чистыми сборками chroot в Archlinux?"
echo -e "${MAGENTA}:: ${BOLD}CCM (clean-chroot-manager) — это Скрипт-оболочка для управления chroot-окружениями при сборке пакетов под Arch Linux. Ccm обеспечивает ряд преимуществ по сравнению со стандартными скриптами Arch-Build: Автоматически управляет локальным репозиторием, благодаря чему зависимости, которые вы создаете, прозрачно извлекаются из этого локального репозитория. Автоматически настраивает и использует distcc для ускорения компиляции (если включено). Управление локальным репозиторием полезно при сборке пакета с зависимостью, которую также необходимо собрать (т.е. такой, которая недоступна в репозиториях Arch). Ещё одно важное отличие заключается в том, что ccm может собирать пакеты с помощью distcc. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Использование помощника AUR, такого как yay, для сборки пакетов, включая backintime, КРАЙНЕ не рекомендуется. Рекомендуемый метод сборки — использовать чистый chroot. Смотреть (читать): https://wiki.archlinux.org/title/DeveloperWiki : Building_in_a_clean_chroot .. ${NC}"
echo " Домашняя страница: https://github.com/graysky2/clean-chroot-manager ; (https://aur.archlinux.org/packages/clean-chroot-manager) "
echo -e "${MAGENTA}:: ${BOLD}Пример: Предположим, что мы хотим собрать «bar» из AUR. У «Bar» есть зависимость сборки от «foo», которая также есть в AUR. Вместо того, чтобы сначала собрать «foo», затем установить «foo», затем собрать «bar» и, наконец, удалить «foo», локальный репозиторий сохранит копию foo.pkg.tar.xz, которая автоматически проиндексируется. Pacman в chroot-окружении знает о пакете «foo» благодаря локальному репозиторию. Поэтому, когда пользователь попытается собрать «bar», pacman автоматически скачает foo.pkg.tar.xz из локального репозитория, как и любую другую зависимость. ${NC}"
echo -e "${YELLOW}:: ${NC}Настройка: $XDG_CONFIG_HOME/clean-chroot-manager.conf - Будет создан при первом запуске ccm и будет содержать все настройки, управляемые пользователем. Отредактируйте этот файл перед повторным запуском ccm. Убедитесь, что у пользователя, запускающего ccm, есть права sudo для выполнения /usr/bin/clean-chroot-manager или /usr/bin/ccm . Параметры команд будут прописаны в сценарии (скрипта), в справке, но будут закомментированы # . "
echo " Советы: Поскольку ccm требует прав sudo, рассмотрите возможность создания псевдонима для его вызова в файле ~/.bashrc или аналогичном файле. Например: alias ccm='sudo ccm' . Если в вашей локальной сети несколько компьютеров, попросите их помочь вам с компиляцией через distcc, который поддерживается в CCM. $XDG_CONFIG_HOME/clean-chroot-manager.conf - Инструкции по настройке см. здесь (https://github.com/graysky2/clean-chroot-manager). "
echo -e "${YELLOW}==> Примечание! ${NC}Обязательно прочтите - Зачем это использовать? (https://github.com/graysky2/clean-chroot-manager). "
echo -e "${CYAN}:: ${NC}Установка CCM (clean-chroot-manager), проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/clean-chroot-manager.git), (https://aur.archlinux.org/packages/clean-chroot-manager) - собирается и устанавливается. "
echo " Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить CCM (clean-chroot-manager),    0 - НЕТ - Пропустить установку: " in_cleanchroot  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_cleanchroot" =~ [^10] ]]
do
    :
done
if [[ $in_cleanchroot == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_cleanchroot == 1 ]]; then
  echo ""
  echo " Установка CCM (clean-chroot-manager) "
pacman -Syy  # обновление баз пакмэна (pacman)
# pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########## Зависимости ###########
pacman -S --noconfirm --needed bc  # Язык калькулятора произвольной точности ; https://archlinux.org/packages/extra/x86_64/bc/ ; https://www.gnu.org/software/bc/ ; 2025-05-27 01:22 UTC
pacman -S --noconfirm --needed devtools  # Инструменты для сопровождающих пакетов Arch Linux ; https://archlinux.org/packages/extra/any/devtools/ ; https://gitlab.archlinux.org/archlinux/devtools ; 2025-03-05 20:33 UTC
pacman -S --noconfirm --needed libarchive  # Многоформатная библиотека архивации и сжатия ; https://archlinux.org/packages/core/x86_64/libarchive/ ; https://libarchive.org/ ; 2025-06-02 14:16 UTC
pacman -S --noconfirm --needed pacman  # Менеджер пакетов на основе библиотеки с поддержкой зависимостей ; https://archlinux.org/packages/core/x86_64/pacman/ ; https://www.archlinux.org/pacman/ ; Обеспечивает: libalpm.so=15-64 ; 2025-06-06 14:07 UTC
pacman -S --noconfirm --needed rsync  # Быстрый и универсальный инструмент для копирования удаленных и локальных файлов ; https://archlinux.org/packages/extra/x86_64/rsync/ ; https://rsync.samba.org/ ; 2025-02-03 13:57 UTC
### clean-chroot-manager  # Оболочка для управления чистыми сборками chroot с локальным репозиторием
############ clean-chroot-manager ##########
  cd /home/$username
  git clone https://aur.archlinux.org/clean-chroot-manager.git
  chown -R $username:users /home/$username/clean-chroot-manager
  chown -R $username:users /home/$username/clean-chroot-manager/PKGBUILD
  cd /home/$username/clean-chroot-manager
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/clean-chroot-manager
#############################
  echo ""
  echo " Установка CCM (clean-chroot-manager) завершена "
fi
############## Справка #############
# Параметры и Команды (Command Description):
# a - Добавить пакеты из текущего каталога в локальный репозиторий. (Add packages in current dir to the local repo.)
# c - Создайте chroot. (Create the chroot.)
# cd - Создайте chroot с включенным distcc (если вы не хотите настраивать это в файле конфигурации). (Create the chroot with distcc enabled (if you do not want to set up in the config file)).
# cp - Очистить все файлы в CCACHE_DIR (необязательно при сборке с помощью ccache). (Purge all files in the CCACHE_DIR (optional if building with ccache)).
# d - Удалите все пакеты в локальном репозитории, не уничтожая при этом всю сборку (т. е. пакеты, которые вы собрали на данный момент). (Delete all packages in the local repo without nuking the entire build (i.e. the packages you built to date)).
# l - Перечислите содержимое локального репозитория (т.е. пакеты, которые вы собрали на данный момент). (List the contents of the local repo (i.e. the packages you built to date)).
# N - Удалите chroot и внешний репозиторий (если он определен). (Nuke the chroot and the external repo (if defined)).
# n - Удалите chroot (и все, что под ним находится). (Nuke the chroot (delete it and everything under it)).
# p - Настройки предварительного просмотра. Показывает некоторые сведения о самом chroot. (Preview settings. Show some bits about the chroot itself.)
# R - Переупаковать текущий пакет, если он собран. Эквивалент makepkg -sR в chroot. (Repackage the current package if built. The equivalent of makepkg -sR in the chroot.)
# s - Запустите makepkg в режиме сборки в chroot-окружении. Эквивалент makepkg -s в chroot-окружении. (Run makepkg in build mode under the chroot. The equivalent of makepkg -s in the chroot.)
# S - Запустите makepkg в режиме сборки в chroot-окружении без предварительной очистки. Это полезно для пересборки без загрязнения исходного chroot-окружения или при сборке пакетов с большим количеством одинаковых зависимостей. (Run makepkg in build mode under the chroot without first cleaning it. Useful for rebuilds without dirtying the pristine chroot or when building packages with many of the same deps.)
# t - Включите/выключите [core-testing]/[extra-testing] в chroot и обновите пакеты соответствующим образом (повысьте или понизьте версию). (Toggle [core-testing]/[extra-testing] on/off in the chroot and update packages accordingly (upgrade or downgrade)).
# u - Обновить пакеты внутри chroot. Эквивалент pacman -Syuв chroot. (Update the packages inside the chroot. The equivalent of pacman -Syu in the chroot.)
### Пример использования ()
# Создайте gcchroot по пути, указанному в вышеупомянутом файле конфигурации:
# $ sudo ccm c
# Попытайтесь собрать пакет в gcchroot. В случае успеха пакет будет добавлен в локальный репозиторий и станет доступен для использования в качестве зависимости при сборке других пакетов:
#  $ cd /path/to/PKGBUILD
#  $ sudo ccm s
# Выведите список содержимого локального репозитория chroot, предполагая, что что-то было собрано. Полезно посмотреть, что там есть:
# $ sudo ccm l
# Удаляет все, что находится под верхним уровнем chroot, фактически удаляя его из системы:
# $ sudo ccm n
### Советы:
# Поскольку ccm требует прав sudo, рассмотрите возможность создания псевдонима для его вызова в файле ~/.bashrc или аналогичном файле. Например:
# alias ccm='sudo ccm'
# Если в вашей локальной сети несколько компьютеров, попросите их помочь вам с компиляцией через distcc, который поддерживается в CCM. $XDG_CONFIG_HOME/clean-chroot-manager.confИнструкции по настройке см. здесь.
# Если на вашем компьютере большой объём памяти, рассмотрите возможность размещения chroot-окружения в tmpfs, чтобы избежать использования диска и минимизировать время доступа. Один из способов — просто указать каталог для монтирования как tmpfs, например /etc/fstab:
# tmpfs /scratch tmpfs nodev,size=20G 0 0
# Чтобы CHROOTPATH создать ожидаемый каталог, мы можем использовать системный временный файл (tmpfile) следующим образом:
# /etc/tmpfiles.d/ccm_dirs.conf
# d /scratch/.chroot 0750 foo users -
# *Обратите внимание, что это необходимо только в том случае, если chroot находится в энергозависимой файловой системе, такой как tmpfs. (Note that this is only needed if the location of the chroot are on a volatile filesystem like tmpfs.)
#######################################

clear
echo -e "${MAGENTA}
  <<< Установка AUR (Arch User Repository) >>> ${NC}"
echo -e "${YELLOW}==> Примечание: ${NC}Сейчас Вы можете пропустить установку "AUR", пункт для установки будет продублирован в следующем скрипте (archmy3l). И Вы сможете установить "AUR Helper" уже из установленной системы."
echo -e "${YELLOW}==> Внимание! ${NC}Во время установки "AUR", Вас попросят ввести (Пароль пользователя) для $username."
echo ""
echo -e "${GREEN}==> ${NC}Установка AUR Helper (yay) или (pikaur)"
echo -e "${MAGENTA}:: ${NC} AUR - Пользовательский репозиторий, поддерживаемое сообществом хранилище ПО, в который пользователи загружают скрипты для установки программного обеспечения."
echo " В AUR - есть практически всё, что можно установить на Linux. В том числе и программы, которые для других дистробутивов пришлось бы собирать из исходников. "
echo -e "${CYAN}=> ${BOLD}В сценарии скрипта присутствуют следующие варианты: ${NC}"
echo " 1 - Установка 'AUR'-'yay' с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/yay.git), собирается и устанавливается, то выбирайте вариант - "1" "
echo " 2 - Установка 'AUR'-'pikaur' с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/pikaur.git), собирается и устанавливается, то выбирайте вариант - "2" "
echo " 3 - Установка 'AUR'-'yay-bin' (версия в разработке) с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/yay-bin.git), собирается и устанавливается, то выбирайте вариант - "3" "
echo -e "${YELLOW}==> ${BOLD}Важно! Подчеркну (обратить внимание)! Pikaur - идёт как зависимость для Octopi. ${NC}"
echo " Будьте внимательны! В этом действии выбор остаётся за вами. "
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - AUR - yay (git clone),     2 - AUR - pikaur (git clone),     3 - *AUR - yay-bin (git clone),

    0 - Пропустить установку AUR Helper: " in_aur_help  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_aur_help" =~ [^1230] ]]
do
    :
done
if [[ $in_aur_help == 0 ]]; then
  clear
  echo ""
  echo " Установка AUR Helper пропущена "
elif [[ $in_aur_help == 1 ]]; then
  pacman -Syu  # Обновим вашу систему (базу данных пакетов)
  pacman -D --asdeps go  # зависимость 'go' - (Основные инструменты компилятора для языка программирования Go)
# Чтобы протестировать любой данный пакет после его установки, сделайте следующее: pacman -D –asdeps  - Это сообщит pacman, что пакет был установлен как зависимость, следовательно, он будет указан как потерянный (что вы можете увидеть с помощью «pacman -Qtd»). Если вы затем решите, что хотите сохранить пакет, вы можете использовать флаг –asexplicit как есть ... --asdeps         пометить пакеты как установленные не явно...
#pacman -S --asdeps go # установить пакет go как зависимость
# pacman -Syu go
# pacman -D --asdeps go
#  pacman -Syu go
# pacman -Syu && -S --asdeps go
  pacman -Qi go | grep Reason  # Причина установки: Установлен как зависимость для другого пакета
  echo ""
  echo " Установка AUR Helper - (yay) "
  cd /home/$username
  git clone https://aur.archlinux.org/yay.git
  chown -R $username:users /home/$username/yay   #-R, --recursive - рекурсивная обработка всех подкаталогов;
  chown -R $username:users /home/$username/yay/PKGBUILD  #-R, --recursive - рекурсивная обработка всех подкаталогов;
  cd /home/$username/yay
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/yay
  clear
  echo ""
  echo " Установка AUR Helper (yay) завершена "
elif [[ $in_aur_help == 2 ]]; then
  pacman -Syu  # Обновим вашу систему (базу данных пакетов)
  echo ""
  echo " Установка AUR Helper - (pikaur) "
  cd /home/$username
  git clone https://aur.archlinux.org/pikaur.git  # https://aur.archlinux.org/packages/pikaur
  chown -R $username:users /home/$username/pikaur   #-R, --recursive - рекурсивная обработка всех подкаталогов;
  chown -R $username:users /home/$username/pikaur/PKGBUILD  #-R, --recursive - рекурсивная обработка всех подкаталогов;
  cd /home/$username/pikaur
  sudo -u $username  makepkg -si --noconfirm
# sudo -u $username  makepkg -fsri --noconfirm
  rm -Rf /home/$username/pikaur
  clear
  echo ""
  echo " Установка AUR Helper (pikaur) завершена "
elif [[ $in_aur_help == 3 ]]; then
  pacman -Syu  # Обновим вашу систему (базу данных пакетов)
  echo ""
  echo " Установка AUR Helper - (yay-bin) "
  cd /home/$username
  git clone https://aur.archlinux.org/yay-bin.git
  chown -R $username:users /home/$username/yay-bin   #-R, --recursive - рекурсивная обработка всех подкаталогов;
  chown -R $username:users /home/$username/yay-bin/PKGBUILD  #-R, --recursive - рекурсивная обработка всех подкаталогов;
  cd /home/$username/yay-bin
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/yay-bin
  clear
  echo ""
  echo " Установка AUR Helper (yay-bin) завершена "
fi
###

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить AUR Helper Paru (paru) или (paru-bin) - Помощник для оболочки Pacman "
echo -e "${MAGENTA}:: ${BOLD}Paru — это стандартный помощник для оболочки Pacman в AUR с множеством функций и минимальным взаимодействием. AUR или пользовательский репозиторий Archlinux. Для работы с ним необходимы так называемые helpers или помощники. До последнего времени в качестве помощника я использовал yay, но в один из дней я решил попробовать другие помощник и первым среди результатов поиска мне попался paru. На протяжении пары недель активно пользовался им, теперь готов поделиться своими впечатлениями и рассказать о том, и помочь установить этот helper. Сразу хочу предупредить об одной особенности использования paru. Перед установкой некоторых пакетов он открывает файл с конфигурацией сборки. Я его обычно не просматриваю, так как доверяю помощнику, потому, чтобы закрыть этот файл нужно нажать клавишу Q. Установка paru: Процесс инсталляции крайне прост и состоит из нескольких последовательно идущих шагов. ${NC}"
echo " Домашняя страница: https://github.com/morganamilo/paru ; (https://aur.archlinux.org/packages/paru). "
echo -e "${MAGENTA}:: ${BOLD}Отличия paru от yay: Во-первых, они написаны на разных языках программирования. Помощник yay написан на GO, тогда как paru написан на Rust. Не хочу вникать в длительные споры и рассуждения о том, что производительнее, просто приведу то, что прочитал на форумах (т. е. мнение других пользователей), где говорят о том, что paru поэтому работает быстрее. Во-вторых, разработчик paru, известный под ником morganamilo, является одним из самых продуктивных и активных участников при разработке pacman. У него больше коммитов, больше степень вклада в разработку этого пакета. В-третьих, yay, скажем так, более древний помощник, paru на его фоне выглядит намного моложе, то есть, его разработка началась после. При этом, некоторые пользователи Archlinux утверждают, что paru является фактически форком (ответвлением) yay, но переведенным на другой язык программирования. ${NC}"
echo " Обзор Paru AUR Helper: Paru предоставляет интуитивно понятный интерфейс командной строки для удобного поиска, загрузки и установки пакетов из AUR. Вот некоторые из ключевых функций и преимуществ paru: Упрощенная установка пакетов AUR с помощью одной команды; Обработка зависимостей пакетов ; Автоматическая загрузка и компиляция файлов сборки ; Синтаксис в стиле Pacman для удобства использования ; Управление официальными пакетами репозитория ; Обновления новостей для пакетов AUR ; Раскрашенный вывод и т.д.. По сравнению с ручным управлением  git пакетами  makepkg AUR, paru делает процесс гораздо более плавным. Опытные пользователи Arch используют paru для эффективного повседневного управления пакетами AUR. "
echo -e "${BLUE}:: ${NC}Теперь что касается моих ощущений в плане различий. Я как-то скептически отношусь ко всем разговорам о производительности и скорости работы различных языков программирования и написанных на них приложений. Много говорят про то, что Python медленный, GO на втором месте, Rust возглавляет эту троицу. Но! Зачастую эта разница исчисляется миллисекундами в запуске программы и ее откликах на действия пользователя. То есть, обычный пользователь вообще не должен заметить разницы. Тем не менее, ощущение (именно ощущение, так как, опять-таки никаких замеров я не производил) такое, что paru действительно работает чутка быстрее, чем yay. Не существенно, но быстрее находит пакеты, собирает их. Для меня это единственное отличие между двумя помощниками. У Paru теперь есть IRC-канал в Libera Chat (https://libera.chat/). Присоединяйтесь к обсуждению и помогите с Paru. "
echo -e "${CYAN}:: ${NC}Установка AUR Helper Paru -'paru' и 'paru-bin' проходит через сборку при помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/paru.git ; https://aur.archlinux.org/paru-bin.git), собирается и устанавливается. "
echo -e "${YELLOW}==> ${NC}* Paru можно настроить через файл конфигурации, расположенный по адресу  ~/.config/paru/paru.conf . Так как, Paru устанавливается вместе с Файловым менеджером (vifm), его можно настроить (прописать) в ~/.config/paru/paru.conf Например так: в разделе [bin] - FileManager = vifm . Подробную информацию о параметрах конфигурации Смотрите в - man paru.conf . "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить AUR Helper Paru (paru),     2 - Установить AUR Helper Paru (paru-bin),

    0 - Пропустить установку AUR Helper: " in_aur_paru  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_aur_paru" =~ [^120] ]]
do
    :
done
if [[ $in_aur_paru == 0 ]]; then
  clear
  echo ""
  echo " Установка AUR Helper пропущена "
elif [[ $in_aur_paru == 1 ]]; then
  pacman -Syu  # Обновим вашу систему (базу данных пакетов)
  pacman -S --noconfirm --needed base-devel  # Базовые инструменты для сборки пакетов Arch Linux ; https://archlinux.org/packages/core/any/base-devel/ ; https://www.archlinux.org/ ; 2024-09-07 07:59 UTC
  echo ""
  echo " Установка AUR Helper Paru (paru) "
  pacman -S --noconfirm --needed bat  # Клон Cat с подсветкой синтаксиса и интеграцией с git ; https://archlinux.org/packages/extra/x86_64/bat/ ; https://github.com/sharkdp/bat ; 2025-01-25 15:34 UTC
### Подсветка синтаксиса PKGBUILD : вы можете установить эту функцию bat, чтобы включить подсветку синтаксиса во время проверки PKGBUILD.
  ######### paru ###########
### paru  # Многофункциональный помощник AUR ; https://aur.archlinux.org/packages/paru ; https://aur.archlinux.org/paru.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/morganamilo/paru ; 2025-07-08 08:52 (UTC)
  cd /home/$username
  git clone https://aur.archlinux.org/paru.git
  chown -R $username:users /home/$username/paru   #-R, --recursive - рекурсивная обработка всех подкаталогов;
  chown -R $username:users /home/$username/paru/PKGBUILD  #-R, --recursive - рекурсивная обработка всех подкаталогов;
  cd /home/$username/paru
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/paru
  echo ""
  echo " Установка Файлового Менеджера Vifm - (vifm) "
  echo " Если вы используете vi, Vifm дает вам полный контроль над файлами с клавиатуры без необходимости изучать новый набор команд  "
  ########### vifm ############
  pacman -S --noconfirm --needed vifm  # Файловый менеджер с интерфейсом curses, предоставляющий среду, похожую на Vi[m] ; https://archlinux.org/packages/extra/x86_64/vifm/ ; https://vifm.info/ ; 2025-06-10 17:06 UTC
# Vifm — это файловый менеджер с интерфейсом curses, который предоставляет среду, похожую на Vim, для управления объектами в файловых системах, расширенную некоторыми полезными идеями из mutt. Если вы используете vi, Vifm дает вам полный контроль над файлами с клавиатуры без необходимости изучать новый набор команд.
  echo ""
  echo " Узнать Версию пакета paru "
  paru --version  # Узнать Версию программы, можно и с помощью (терминала)
sleep 03
  echo ""
  echo " Создание новой группы Contrib "
  echo " По умолчанию информация о группах хранится в файле /etc/group "
  groupadd -f contrib  # Добавить группу Contrib, которая имеет разрешение на захват на интерфейсах без необходимости использования sudo
### Удаление группы: Для удаления группы используется команда: sudo groupdel mygroup
# /etc/shadow  - Безопасное хранение информации о пользователях
# /etc/passwd  - Информация о пользователях
# /etc/gshadow  - Скрытая информация о группах
# /etc/group   - Принадлежность пользователей к группам
# Как создать группу Linux:
# Для создания групп в Linux используется команда groupadd, давайте рассмотрим её синтаксис и опции:
# $ groupadd опции имя_группы
# А теперь разберём опции утилиты:
# -f - если группа уже существует, то утилита возвращает положительный результат операции;
# -g - установить значение идентификатора группы GID вручную;
# -K - изменить параметры по умолчанию автоматической генерации GID;
# -o - разрешить добавление группы с неуникальным GID;
# -p - задаёт пароль для группы;
# -r - указывает, что группа системная;
# -R - позволяет изменить корневой каталог.
  echo ""
  echo " Теперь вы можете убедится, что группа была добавлена в файл /etc/group "
  cat /etc/group | grep contrib
sleep 03
  echo " Проверка групп: Посмотрим к каким группам принадлежит текущий пользователь "
  groups  # Чтобы увидеть, к каким группам принадлежит текущий пользователь
sleep 05
  echo ""
  echo " Добавляет пользователя в группу Contrib "
  echo " Пример: sudo gpasswd -a ИМЯ_ПОЛЬЗОВАТЕЛЯ contrib "
  gpasswd -a $username contrib
# gpasswd -a $USER contrib  # Команда gpasswd -a $USER contrib в Linux добавляет пользователя в группу contrib. Это необходимо, так как только root и пользователи этой группы могут использовать AUR без root/sudo.
  echo " Добавить текущего пользователя в группу contrib "
  echo " Чтобы разрешить установку AUR без root/sudo - Это предоставляет разрешения на установку и управление пакетами AUR "
  usermod -aG contrib $username
#usermod -aG contrib $USER  # Добавить текущего пользователя в группу contrib, которая имеет разрешение на захват на интерфейсах без необходимости использования sudo
# usermod -a -G contrib $USER
# usermod -aG contrib ${USER}
  echo ""
  echo " Теперь вы можете убедится, что пользователь был добавлена в группу /etc/group contrib "
  cat /etc/group | grep contrib
sleep 03
  echo ""
  echo " Обновление баз данных пакетов, и системы через - AUR (Paru) "
  paru -Syy
  paru -Syu  # (sysupgrade)
  echo ""
  echo " Установка AUR Helper Paru (paru) завершена "
elif [[ $in_aur_paru == 2 ]]; then
  pacman -Syu  # Обновим вашу систему (базу данных пакетов)
  pacman -S --noconfirm --needed base-devel  # Базовые инструменты для сборки пакетов Arch Linux ; https://archlinux.org/packages/core/any/base-devel/ ; https://www.archlinux.org/ ; 2024-09-07 07:59 UTC
  echo ""
  echo " Установка AUR Helper Paru - (paru-bin) "
  ########## paru-bin ###########
    pacman -S --noconfirm --needed bat  # Клон Cat с подсветкой синтаксиса и интеграцией с git ; https://archlinux.org/packages/extra/x86_64/bat/ ; https://github.com/sharkdp/bat ; 2025-01-25 15:34 UTC
### Подсветка синтаксиса PKGBUILD : вы можете установить эту функцию bat, чтобы включить подсветку синтаксиса во время проверки PKGBUILD.
   ########## paru-bin ###########
### paru-bin  #  Многофункциональный помощник AUR ; https://aur.archlinux.org/packages/paru-bin ; https://aur.archlinux.org/paru-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/morganamilo/paru ; Конфликты: с paru ; Обеспечивает: paru ; 2025-07-08 08:51 (UTC)
  cd /home/$username
  git clone https://aur.archlinux.org/paru-bin.git
  chown -R $username:users /home/$username/paru-bin   #-R, --recursive - рекурсивная обработка всех подкаталогов;
  chown -R $username:users /home/$username/paru-bin/PKGBUILD  #-R, --recursive - рекурсивная обработка всех подкаталогов;
  cd /home/$username/paru-bin
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/paru-bin
  echo ""
  echo " Установка Файлового Менеджера Vifm - (vifm) "
  echo " Если вы используете vi, Vifm дает вам полный контроль над файлами с клавиатуры без необходимости изучать новый набор команд  "
  ########### vifm ############
  pacman -S --noconfirm --needed vifm  # Файловый менеджер с интерфейсом curses, предоставляющий среду, похожую на Vi[m] ; https://archlinux.org/packages/extra/x86_64/vifm/ ; https://vifm.info/ ; 2025-06-10 17:06 UTC
# Vifm — это файловый менеджер с интерфейсом curses, который предоставляет среду, похожую на Vim, для управления объектами в файловых системах, расширенную некоторыми полезными идеями из mutt. Если вы используете vi, Vifm дает вам полный контроль над файлами с клавиатуры без необходимости изучать новый набор команд.
  echo ""
  echo " Узнать Версию пакета paru "
  paru --version  # Узнать Версию программы, можно и с помощью (терминала)
sleep 03
  echo ""
  echo " Создание новой группы Contrib "
  echo " По умолчанию информация о группах хранится в файле /etc/group "
  groupadd -f contrib  # Добавить группу Contrib, которая имеет разрешение на захват на интерфейсах без необходимости использования sudo
### Удаление группы: Для удаления группы используется команда: sudo groupdel mygroup
# /etc/shadow  - Безопасное хранение информации о пользователях
# /etc/passwd  - Информация о пользователях
# /etc/gshadow  - Скрытая информация о группах
# /etc/group   - Принадлежность пользователей к группам
# Как создать группу Linux:
# Для создания групп в Linux используется команда groupadd, давайте рассмотрим её синтаксис и опции:
# $ groupadd опции имя_группы
# А теперь разберём опции утилиты:
# -f - если группа уже существует, то утилита возвращает положительный результат операции;
# -g - установить значение идентификатора группы GID вручную;
# -K - изменить параметры по умолчанию автоматической генерации GID;
# -o - разрешить добавление группы с неуникальным GID;
# -p - задаёт пароль для группы;
# -r - указывает, что группа системная;
# -R - позволяет изменить корневой каталог.
  echo ""
  echo " Теперь вы можете убедится, что группа была добавлена в файл /etc/group "
  cat /etc/group | grep contrib
sleep 03
  echo " Проверка групп: Посмотрим к каким группам принадлежит текущий пользователь "
  groups  # Чтобы увидеть, к каким группам принадлежит текущий пользователь
sleep 05
  echo ""
  echo " Добавляет пользователя в группу Contrib "
  echo " Пример: sudo gpasswd -a ИМЯ_ПОЛЬЗОВАТЕЛЯ contrib "
  gpasswd -a $username contrib
# gpasswd -a $USER contrib  # Команда gpasswd -a $USER contrib в Linux добавляет пользователя в группу contrib. Это необходимо, так как только root и пользователи этой группы могут использовать AUR без root/sudo.
  echo " Добавить текущего пользователя в группу contrib "
  echo " Чтобы разрешить установку AUR без root/sudo - Это предоставляет разрешения на установку и управление пакетами AUR "
  usermod -aG contrib $username
#usermod -aG contrib $USER  # Добавить текущего пользователя в группу contrib, которая имеет разрешение на захват на интерфейсах без необходимости использования sudo
# usermod -a -G contrib $USER
# usermod -aG contrib ${USER}
  echo ""
  echo " Теперь вы можете убедится, что пользователь был добавлена в группу /etc/group contrib "
  cat /etc/group | grep contrib
sleep 03
  echo ""
  echo " Обновление баз данных пакетов, и системы через - AUR (Paru) "
  paru -Syy
  paru -Syu  # (sysupgrade)
  echo ""
  echo " Установка AUR Helper Paru (paru-bin) завершена "
fi
######### Справка #########
### Команды, необходимые вам для работы с помощником такие же, как и в yay:
# paru -S <имя_пакета> - установка нужного пакета
# paru -Ss <имя_пакета> - поиск необходимого пакета в AUR
# paru -R <имя_пакета> - удаление пакета с сохранением зависимостей и конфигурационных файлов
# paru -Rs <имя_пакета> - удаление пакета вместе с ненужными зависимостями.
# paru -Rn <имя_пакета> - удаление пакета вместе с конфигурационными файлами
# paru -Rns <имя_пакета> - удаление пакета вместе с зависимостями и конфигами
# paru -Syu : полное оновление системы
# paru -Sua : обновляйте только пакеты AUR
# paru -Qua : вывести список доступных обновлений AUR
# paru -Gc <ввод пользователя> : вывести комментарии AUR для <ввода пользователя>
### Переверните порядок поиска:
# Наиболее релевантный пакет в соответствии с вашим поисковым запросом обычно отображается в верхней части результатов поиска. В Paru вы можете изменить порядок поиска, чтобы упростить его.
# Как и в предыдущем примере, откройте файл конфигурации paru:
# sudo nano /etc/paru.conf
# Раскомментируйте термин «BottomUp» и сохраните файл.
# Как видите, порядок обратный, и первая посылка находится внизу.
### Так как Paru устанавливается вместе с Файловым менеджером (vifm), его можно настроить (прописать) в ~/.config/paru/paru.conf Например так:
# Откройте файл конфигурации и раскомментируйте строки, как показано ниже.
# [bin]
# FileManager = vifm
#############################
echo ""
echo " Отключить отладку в AUR "
echo " Если вы установите пакет из aur, вы получите пакет отладки с целевым пакетом, добавьте ‘!’ в строке OPTIONS перед debug в /etc/makepkg.conf. "
# sudo nano /etc/makepkg.conf
# OPTIONS=(strip docs !libtool !staticlibs emptydirs zipman purge !debug lto)
echo " Имеет смысл отключить сборку отладочных пакетов, выключив !debug и !strip "
sed -i.bak '/^OPTIONS=/s/strip/!strip/; /^OPTIONS=/s/debug/!debug/' /etc/makepkg.conf
###
echo ""
echo -e "${BLUE}:: ${NC}Обновим всю систему включая AUR пакеты"
echo -e "${YELLOW}==> Примечание: ${NC}Выберите вариант обновления баз данных пакетов, и системы, в зависимости от установленного вами AUR Helper (yay; pikaur; paru), или пропустите обновления - (если AUR НЕ установлен)."
echo -e "${CYAN}=> ${BOLD}В сценарии скрипта присутствуют следующие варианты: ${NC}"
echo " 1 - Обновление баз данных пакетов, и системы через 'AUR'-'yay', то выбирайте вариант "1" "
echo " 2 - Установка обновлений баз данных пакетов, и системы через 'AUR'-'pikaur', то выбирайте вариант "2" "
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Обновление через - AUR (Yay),   2 - Обновление через - AUR (Pikaur),

    0 - Пропустить обновление баз данных пакетов, и системы: " in_aur_update  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_aur_update" =~ [^120] ]]
do
    :
done
if [[ $in_aur_update == 0 ]]; then
  echo ""
  echo " Обновление баз данных пакетов, и системы пропущено "
elif [[ $in_aur_update == 1 ]]; then
  echo ""
  echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
  yay -Syy
  yay -Syu
elif [[ $in_aur_update == 2 ]]; then
  echo ""
  echo " Обновление баз данных пакетов, и системы через - AUR (Pikaur) "
  pikaur -Syy
  pikaur -Syu  # (sysupgrade)
fi
###
sleep 1
clear
echo ""
echo -e "${GREEN}==> ${NC}Установить менеджер пакетов для Archlinux?"
echo -e "${BLUE}:: ${NC}Установка Pacman gui (pamac-aur), или Pacman gui (octopi) (AUR)(GTK)(QT)"
echo -e "${YELLOW}:: ${BOLD}Сейчас Вы можете пропустить установку "Графического менеджера пакетов", пункт для установки будет прописан в следующем скрипте (archmy3l). И Вы сможете установить уже из установленной системы. ${NC}"
echo " Давайте проанализируем действия, которые выполняются. "
echo " 1 - Pacman gui (pamac-aur) - Графический менеджер пакетов (интерфейс Gtk3 для libalpm), тогда укажите "1" "
echo " Графический менеджер пакетов для Arch, Manjaro Linux с поддержкой Alpm, AUR, и Snap. "
echo " 2 - Pacman gui (octopi) - Графический менеджер пакетов (мощный интерфейс Pacman с использованием библиотек Qt5), укажите вариант "2" "
echo -e "${CYAN}=> ${BOLD}Вариант '2' Напрямую привязан к Установке AUR Helper, если ранее БЫЛ выбран AUR-(pikaur).${NC}"
echo -e "${YELLOW}:: ${NC}Так как - Подчеркну (обратить внимание)! 'Pikaur' - идёт как зависимость для Octopi."
echo " 3 - Pacman gui (octopi) - Графический менеджер пакетов (мощный интерфейс Pacman с использованием библиотек Qt5), укажите вариант "3" "
echo -e "${CYAN}=> ${BOLD}Вариант '3' - Если ранее при Установке 'AUR Helper' НЕ БЫЛ УСТАНОВЛЕН AUR-(pikaur). ${NC}"
echo " Pacman gui "Octopi" - рекомендуется для KDE Plasma Desktop (окружение рабочего стола). "
echo " 4 - Pacman gui (pamac-all) - Графический менеджер пакетов (интерфейс для libalpm), тогда укажите "4" "
echo " Графический интерфейс для libalpm (все в одном пакете — snap, flatpak, appindicator, aur, appstream). "
echo echo -e "${CYAN}:: ${NC}Установка пакета (pamac-all) проходит через сборку из AUR (yay) (https://aur.archlinux.org/packages/pamac-all). Будьте внимательны! Пакет (pamac-all) собирается продолжительное время. "
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Pacman gui - (pamac-aur),     2 - Octopi - ранее БЫЛ выбран AUR - (pikaur),

    3 - Octopi - ранее НЕ БЫЛ УСТАНОВЛЕН AUR - (pikaur), 4 - Pacman gui - (pamac-all),

    0 - Пропустить установку: " graphic_aur  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$graphic_aur" =~ [^12340] ]]
do
    :
done
if [[ $graphic_aur == 0 ]]; then
  clear
  echo ""
  echo " Установка Графического менеджера пакетов пропущена "
elif [[ $graphic_aur == 1 ]]; then
  echo ""
  echo " Установка Графического менеджера Pacman gui (pamac-aur) "
  pacman -Syy  # обновление баз пакмэна (pacman)
##### appstream-glib ######
  pacman -S appstream-glib --noconfirm  # Объекты и методы для чтения и записи метаданных AppStream
##### archlinux-appstream-data ######
  pacman -S archlinux-appstream-data --noconfirm  # База данных приложений Arch Linux для центров программного обеспечения на основе AppStream
##### libhandy ######
  pacman -S libhandy --noconfirm  # Библиотека, полная виджетов GTK+ для мобильных телефонов
##### libpamac-aur ######
  cd /home/$username
  git clone https://aur.archlinux.org/libpamac-aur.git
  chown -R $username:users /home/$username/libpamac-aur
  chown -R $username:users /home/$username/libpamac-aur/PKGBUILD
  cd /home/$username/libpamac-aur
  sudo -u $username  makepkg -si --noconfirm
#  sudo -u $username  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
  rm -Rf /home/$username/libpamac-aur
##### pamac-aur ######
  cd /home/$username
  git clone https://aur.archlinux.org/pamac-aur.git
  chown -R $username:users /home/$username/pamac-aur
  chown -R $username:users /home/$username/pamac-aur/PKGBUILD
  cd /home/$username/pamac-aur
  sudo -u $username  makepkg -si --noconfirm
#  sudo -u $username  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
  rm -Rf /home/$username/pamac-aur
  clear
  echo ""
  echo " Графический менеджер Pamac-aur успешно установлен! "
elif [[ $graphic_aur == 2 ]]; then
  echo ""
  echo " Установка Графического менеджера Octopi "
##### alpm_octopi_utils ######
  cd /home/$username
  git clone https://aur.archlinux.org/alpm_octopi_utils.git
  chown -R $username:users /home/$username/alpm_octopi_utils
  chown -R $username:users /home/$username/alpm_octopi_utils/PKGBUILD
  cd /home/$username/alpm_octopi_utils
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/alpm_octopi_utils
############ gconf ##########
  cd /home/$username
  git clone https://aur.archlinux.org/gconf.git  # Устаревшая система базы данных конфигурации
  chown -R $username:users /home/$username/gconf
  chown -R $username:users /home/$username/gconf/PKGBUILD
  cd /home/$username/gconf
  sudo -u $username  makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
  rm -Rf /home/$username/gconf
############ libgksu ##########
  cd /home/$username
  git clone https://aur.archlinux.org/libgksu.git
  chown -R $username:users /home/$username/libgksu
  chown -R $username:users /home/$username/libgksu/PKGBUILD
  cd /home/$username/libgksu
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/libgksu
############ gksu ##########
  cd /home/$username
  git clone https://aur.archlinux.org/gksu.git
  chown -R $username:users /home/$username/gksu
  chown -R $username:users /home/$username/gksu/PKGBUILD
  cd /home/$username/gksu
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/gksu
######### qtermwidget #######
  pacman -S qtermwidget --noconfirm  # Виджет терминала для Qt, используемый QTerminal
######### octopi #######
  cd /home/$username
  git clone https://aur.archlinux.org/octopi.git
  chown -R $username:users /home/$username/octopi
  chown -R $username:users /home/$username/octopi/PKGBUILD
  cd /home/$username/octopi
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/octopi
  clear
  echo ""
  echo " Графический менеджер Octopi успешно установлен! "
elif [[ $graphic_aur == 3 ]]; then
  echo ""
  echo " Установка Графического менеджера Octopi - (pikaur) "
##### pikaur ######
  cd /home/$username
  git clone https://aur.archlinux.org/pikaur.git
  chown -R $username:users /home/$username/pikaur
  chown -R $username:users /home/$username/pikaur/PKGBUILD
  cd /home/$username/pikaur
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/pikaur
##### alpm_octopi_utils ######
  cd /home/$username
  git clone https://aur.archlinux.org/alpm_octopi_utils.git
  chown -R $username:users /home/$username/alpm_octopi_utils
  chown -R $username:users /home/$username/alpm_octopi_utils/PKGBUILD
  cd /home/$username/alpm_octopi_utils
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/alpm_octopi_utils
######### qtermwidget #######
  pacman -S qtermwidget --noconfirm  # Виджет терминала для Qt, используемый QTerminal
######### octopi #######
  cd /home/$username
  git clone https://aur.archlinux.org/octopi.git
  chown -R $username:users /home/$username/octopi
  chown -R $username:users /home/$username/octopi/PKGBUILD
  cd /home/$username/octopi
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/octopi
############ gconf ##########
  cd /home/$username
  git clone https://aur.archlinux.org/gconf.git
  chown -R $username:users /home/$username/gconf
  chown -R $username:users /home/$username/gconf/PKGBUILD
  cd /home/$username/gconf
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/gconf
############ libgksu ##########
  cd /home/$username
  git clone https://aur.archlinux.org/libgksu.git
  chown -R $username:users /home/$username/libgksu
  chown -R $username:users /home/$username/libgksu/PKGBUILD
  cd /home/$username/libgksu
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/libgksu
############ gksu ##########
  git clone https://aur.archlinux.org/gksu.git
  chown -R $username:users /home/$username/gksu
  chown -R $username:users /home/$username/gksu/PKGBUILD
  cd /home/$username/gksu
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/gksu
  clear
  echo ""
  echo " Графический менеджер Octopi успешно установлен! "
elif [[ $graphic_aur == 4 ]]; then
  echo ""
 echo " Установка Графического менеджера Pacman gui - (pamac-all) "
 pacman -Syy  # обновление баз пакмэна (pacman)
########## Зависимости #############
 pacman -S --noconfirm --needed libadwaita  # Строительные блоки для современных адаптивных приложений GNOME ; https://archlinux.org/packages/extra/x86_64/libadwaita/ ; https://gnome.pages.gitlab.gnome.org/libadwaita/ ; Обеспечивает: libadwaita-1.so=0-64 ; 29 июня 2025 г. 03:10 UTC
 pacman -S --noconfirm --needed libhandy  # Элементы пользовательского интерфейса GTK 3 для мобильных устройств ; https://archlinux.org/packages/extra/x86_64/libhandy/ ; https://gitlab.gnome.org/GNOME/libhandy ; Обеспечивает: libhandy-1.so=0-64 ; 2024-09-13 05:56 UTC
 pacman -S --noconfirm --needed libnotify  # Библиотека для отправки уведомлений на рабочий стол ; https://archlinux.org/packages/extra/x86_64/libnotify/ ; https://gitlab.gnome.org/GNOME/libnotify ; Обеспечивает: libnotify.so=4-64 ; 2025-03-29 00:39 UTC
 pacman -S --noconfirm --needed asciidoc  # Формат текстового документа для коротких документов, статей, книг и страниц руководства UNIX ; https://archlinux.org/packages/extra/any/asciidoc/ ; https://asciidoc-py.github.io/ ; 2024-12-22 13:31 UTC
 pacman -S --noconfirm --needed git  # быстро распределенная система контроля версий ; https://archlinux.org/packages/extra/x86_64/git/ ; https://git-scm.com/ ; 2025-07-14 10:22 UTC
 pacman -S --noconfirm --needed gobject-introspection  # Система интроспекции для библиотек на основе GObject ; https://archlinux.org/packages/extra/x86_64/gobject-introspection/ ; https://wiki.gnome.org/Projects/GObjectIntrospection ; 2025-06-05 23:28 UTC
 pacman -S --noconfirm --needed meson  # Высокопроизводительная система сборки ; https://archlinux.org/packages/extra/any/meson/ ; https://mesonbuild.com/ ; 2025-06-18 15:10 UTC
 pacman -S --noconfirm --needed vala  # Компилятор для системы типов GObject ; https://archlinux.org/packages/extra/x86_64/vala/ ; https://wiki.gnome.org/Projects/Vala ; Обеспечивает: libvala-0.56.so=0-64, libvaladoc-0.56.so=0-64, valadoc ; 2025-06-18 02:31 UTC
########## Зависимости libpamac-full #############
 pacman -S --noconfirm --needed appstream  # Предоставляет стандарт для создания магазинов приложений для разных дистрибутивов ; https://archlinux.org/packages/extra/x86_64/appstream/ ; https://distributions.freedesktop.org/wiki/AppStream ; 2025-04-30 17:32 UTC
 pacman -S --noconfirm --needed archlinux-appstream-data  # База данных приложений Arch Linux для центров программного обеспечения на базе AppStream ; https://archlinux.org/packages/extra/any/archlinux-appstream-data/ ; https://www.archlinux.org/ ; 29.05.2025 15:31 UTC
 pacman -S --noconfirm --needed dbus-glib  # Привязки GLib для D-Bus (устарело) ; https://archlinux.org/packages/extra/x86_64/dbus-glib/ ; https://www.freedesktop.org/wiki/Software/dbus/ ; 2025-03-24 15:22 UTC
 pacman -S --noconfirm --needed flatpak  # Инфраструктура для изоляции и распространения приложений Linux (ранее xdg-app) ; https://archlinux.org/packages/extra/x86_64/flatpak/ ; https://flatpak.org/ ; Обеспечивает: libflatpak.so=0-64 ; 2025-05-14 00:11 UTC
 pacman -S --noconfirm --needed json-glib  # Библиотека JSON, построенная на GLib ; https://archlinux.org/packages/extra/x86_64/json-glib/ ; https://gnome.pages.gitlab.gnome.org/json-glib/ ; Обеспечивает: libjson-glib-1.0.so=0-64 ; 2024-12-10 10:59 UTC
 pacman -S --noconfirm --needed libsoup3  # Библиотека HTTP-клиента/сервера для GNOME ; https://archlinux.org/packages/extra/x86_64/libsoup3/ ; https://wiki.gnome.org/Projects/libsoup ; Обеспечивает: libsoup-3.0.so=0-64 ; 2025-03-22 14:53 UTC
 pacman -S --noconfirm --needed polkit  # Набор инструментов для разработки приложений для управления общесистемными привилегиями ; https://archlinux.org/packages/extra/x86_64/polkit/ ; https://github.com/polkit-org/polkit ; Обеспечивает: libpolkit-agent-1.so=0-64, libpolkit-gobject-1.so=0-64 ; 2025-01-15 15:10 UTC
######## snapd ##########
### yay -S snapd --noconfirm  # Сервис и инструменты для управления snap-пакетами ; https://aur.archlinux.org/packages/snapd ; https://aur.archlinux.org/snapd.git (только для чтения, нажмите, чтобы скопировать) ; Конфликты: с snap-confine ; https://github.com/snapcore/snapd/releases/download/2.70/snapd_2.70.vendor.tar.xz ; 2025-07-10 11:33 (UTC)
  cd /home/$username
  git clone https://aur.archlinux.org/snapd.git
  chown -R $username:users /home/$username/snapd
  chown -R $username:users /home/$username/snapd/PKGBUILD
  cd /home/$username/snapd
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/snapd
######## snapd-glib ##########
### yay -S snapd-glib --noconfirm  # Библиотека, позволяющая приложениям на базе GLib/Qt получать доступ к snapd — демону, управляющему Snaps ; https://aur.archlinux.org/packages/snapd-glib ; https://aur.archlinux.org/snapd-glib.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/snapcore/snapd-glib ; https://github.com/canonical/snapd-glib/archive/refs/tags/1.70.tar.gz ; 2025-06-05 11:14 (UTC)
  cd /home/$username
  git clone https://aur.archlinux.org/snapd-glib.git
  chown -R $username:users /home/$username/snapd-glib
  chown -R $username:users /home/$username/snapd-glib/PKGBUILD
  cd /home/$username/snapd-glib
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/snapd-glib
 ####### libpamac-full ##########
### yay -S libpamac-full --noconfirm  # Библиотека для менеджера пакетов Pamac на основе libalpm — включена поддержка flatpak и snap ; https://aur.archlinux.org/packages/libpamac-full ; https://aur.archlinux.org/libpamac-full.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/manjaro/libpamac ; Конфликты: с libpamac, libpamac-aur, libpamac-flatpak, libpamac-full-dev ; Обеспечивает: libpamac ; git+https://github.com/manjaro/libpamac.git#commit=29b31e251eb9eac3804955489c285851eb2aca97 ; 29 марта 2025 г. 02:54 (UTC)
  cd /home/$username
  git clone https://aur.archlinux.org/libpamac-full.git
  chown -R $username:users /home/$username/libpamac-full
  chown -R $username:users /home/$username/libpamac-full/PKGBUILD
  cd /home/$username/libpamac-full
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/libpamac-full
########## pamac-cli ########
### yay -S pamac-cli --noconfirm  # Интерфейс Pamac cli для libalpm ; https://aur.archlinux.org/packages/pamac-cli ; https://aur.archlinux.org/pamac-cli.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/manjaro/pamac-cli ; git+https://github.com/manjaro/pamac-cli.git#commit=27cc40525a5820177a9d77028d9e481a500d61ee ; 29 марта 2025 г. 02:53 (UTC)
  cd /home/$username
  git clone https://aur.archlinux.org/pamac-cli.git
  chown -R $username:users /home/$username/pamac-cli
  chown -R $username:users /home/$username/pamac-cli/PKGBUILD
  cd /home/$username/pamac-cli
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/pamac-cli
########## pamac-all ##########
### yay -S pamac-all --noconfirm  # Графический интерфейс для libalpm (все в одном пакете — snap, flatpak, appindicator, aur, appstream) ; https://aur.archlinux.org/packages/pamac-all ; https://aur.archlinux.org/pamac-all.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/manjaro/pamac ; Конфликты: с pamac, pamac-aur, pamac-aur-git, pamac-common, pamac-flatpak, pamac-flatpak-gnome, pamac-gtk ; git+https://github.com/manjaro/pamac.git#commit=06c846c0310030ee45870b190359553b1c105f77 ; 2025-05-05 19:30 (UTC)
  cd /home/$username
  git clone https://aur.archlinux.org/pamac-all.git
  chown -R $username:users /home/$username/pamac-all
  chown -R $username:users /home/$username/pamac-all/PKGBUILD
  cd /home/$username/pamac-all
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/pamac-all
  echo ""
  echo " Графический менеджер Pacman gui - (pamac-all) успешно установлен! "
fi
#######################
sleep 03

clear
echo ""
echo -e "${GREEN}=> ${BOLD}Вы хотите Блокировать сайты с рекламой через hosts файл (etc/hosts)? ${NC}"
echo -e "${BLUE}:: ${NC}Это будет Единый файл hosts с базовыми расширениями "
echo -e "${MAGENTA}=> ${BOLD}Справка: Этот репозиторий объединяет несколько hosts файлов с хорошей репутацией и объединяет их в единый файл hosts с удаленными дубликатами. Предоставляется множество адаптированных файлов хостов. (https://github.com/StevenBlack/hosts) ${NC}"
echo -e "${YELLOW}==> Примечание: ${NC}Последнее обновление: 07 июня 2021. Необработанный файл hosts с базовыми расширениями, содержащий 82077 записей."
echo -e "${CYAN}:: ${NC}Унифицированный файл hosts может быть расширен. Расширения используются для включения доменов по категориям. В настоящее время мы предлагаем следующие категории: fakenews, social, gambling, и porn. "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да изменить файл (/etc/hosts),

    0 - Пропустить изменения файла /etc/hosts: " i_hosts  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_hosts" =~ [^10] ]]
do
    :
done
if [[ $i_hosts == 0 ]]; then
  echo ""
  echo " Создание нового hosts файла пропущено "
elif [[ $i_hosts == 1 ]]; then
  echo ""
  echo " Сохраняем копию оригинального файла /etc/hosts "
  echo " hosts — это текстовый документ, который содержит в себе информацию о домене и IP-адресе "
# cp /etc/hosts  /etc/hosts.back
  cp -v /etc/hosts  /etc/hosts.bak  # Для начала сделаем его бэкап
# cp -v /etc/hosts  /etc/hosts.original  # -v или --verbose -Выводить информацию о каждом файле, который обрабатывает команда cp.
# cp /etc/hosts ~/Documents/hosts.bak
echo " Переименовываем исходный файл /etc/hosts.bak в /etc/hosts.original "
mv /etc/hosts.bak  /etc/hosts.original_`date +"%d.%m.%y_%H-%M"`   # Переименовываем исходный файл
### echo " Удаление файла /etc/hosts.bak "
### rm /etc/hosts.bak   # rm - Удаление файлов
##################################
  echo ""
  echo " Загрузка и обновление файла /etc/hosts "
  wget -qO- https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts | sudo tee --append /etc/hosts
  echo ""
  echo " Создание файла /etc/hosts успешно выполнено "
fi
sleep 1
###################

clear
echo -e "${MAGENTA}
  <<< Установка shell (командной оболочки) по умолчанию в Archlinux >>> ${NC}"
echo ""
echo -e "${YELLOW}==> Примечание: ${NC}Сейчас Вы можете установить zsh (такой же, как и в установочном образе Archlinux) или оставить Bash по умолчанию, просто пропустите установку."
echo ""
echo -e "${GREEN}==> ${NC}Установка ZSH (bourne shell) командной оболочки"
echo -e "${CYAN}:: ${NC}Z shell, zsh - является мощной, одной из современных командных оболочек, которая работает как в интерактивном режиме, так и в качестве интерпретатора языка сценариев (скриптовый интерпретатор)."
echo " Он совместим с bash (не по умолчанию, только в режиме emulate sh), но имеет преимущества, такие как улучшенное завершение и подстановка. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo -e "${MAGENTA}=> ${BOLD}Вот какая оболочка (shell) используется в данный момент: ${NC}"
echo ""
echo $SHELL
sleep 03
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить zsh,     0 - НЕТ - Пропустить установку (bash по умолчанию): " x_shell  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_shell" =~ [^10] ]]
do
    :
done
if [[ $x_shell == 0 ]]; then
  clear
  echo ""
  echo " Оболочка (shell) НЕ изменена, по умолчанию остаётся Bash! "
elif [[ $x_shell == 1 ]]; then
  clear
  echo ""
  echo " Установка ZSH (shell) оболочки "
  pacman -Syy  # обновление баз пакмэна (pacman)
  pacman -S --noconfirm --needed zsh zsh-syntax-highlighting zsh-autosuggestions grml-zsh-config  # Очень продвинутый и программируемый интерпретатор команд (оболочка) для UNIX; Рыбная оболочка как подсветка синтаксиса для Zsh; Рыбоподобные самовнушения для zsh (история команд); Настройка zsh в grml
  pacman -S --noconfirm --needed zsh-completions zsh-history-substring-search  # Дополнительные определения завершения для Zsh; ZSH порт поиска рыбной истории (стрелка вверх)
  #pacman -S --noconfirm --needed syntax-highlighting5  # Механизм подсветки синтаксиса для структурированного текста и кода ; https://community.kde.org/Frameworks ; https://archlinux.org/packages/extra/x86_64/syntax-highlighting5/
  echo 'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> /etc/zsh/zshrc
  echo 'source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> /etc/zsh/zshrc
# echo 'prompt adam2' >> /etc/zsh/zshrc
  echo 'prompt fire' >> /etc/zsh/zshrc
  echo ""
  echo " Установка shell (командной оболочки) ZSH Выполнена! "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установим Oh My Zsh - пакет (oh-my-zsh-git) и Powerlevel10k - пакет (zsh-theme-powerlevel10k-git) тема для Zsh, а также несколько плагинов, библиотек и шрифтов из AUR (Arch User Repository)?"
echo " Zsh - одна из современных командных оболочек UNIX, использующаяся непосредственно как интерактивная оболочка, либо как скриптовый интерпретатор. Zsh не использует readline для ввода команд пользователем. Вместо этого используется собственный редактор ZLE (Zsh Line Editor). Oh My Zsh — это восхитительный, открытый исходный код, поддерживаемый сообществом фреймворк для управления конфигурацией Zsh. фреймворк Oh My Zsh, который вы надеюсь установите, далее позволит настраивать ее и кастомизировать с помощью тем и плагинов. "
echo " Powerlevel10k — это тема для ZSH, гибкая и в то же время простая в плане настройки терминальной темы, которая меняет обычные команды оболочки на красочные команды. Чтобы установить powerlevel10k, нужно установить Oh My Zsh. Оба инструмента имеют открытый исходный код на GitHub. Также можно использовать шрифт nerd, чтобы сделать шрифт темы powerlevel10k более красивым. После обновления powerlevel9k до powerlevel10k настроить тему стало легче. "
echo -e "${YELLOW}=> Примечание: ${BOLD}Обратите внимание, что это изменение не мгновенное, и вам нужно будет выйти из системы и снова войти в нее, чтобы оно вступило в силу. После этого снова проверьте переменную окружения SHELL, чтобы подтвердить изменение: echo $SHELL . ${NC}"
echo " Плагины (необязательно, но желательно иметь!) - Будет установлено: zsh-syntax-highlighting - Позволяет подсвечивать команды, пока они вводятся в приглашении zsh в интерактивном терминале. Это помогает просматривать команды перед их запуском, особенно при обнаружении синтаксических ошибок. zsh-autosuggestions — предлагает команды по мере ввода на основе истории и завершений. "
echo -e "${YELLOW}==> ${NC}Будьте внимательны! Если Вы сомневаетесь в своих действиях, просто пропустите этот пункт."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить Oh My Zsh,     0 - НЕТ - Пропустить установку: " i_ohmyzsh  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_ohmyzsh" =~ [^10] ]]
do
    :
done
if [[ $i_ohmyzsh == 0 ]]; then
echo ""
echo " Установка пропущена "
elif [[ $i_ohmyzsh == 1 ]]; then
echo ""
echo " Обновление баз данных пакетов, и системы через - AUR (Yay) "
pacman -Syy  # обновление баз пакмэна (pacman)
# yay -Syy  # обновление баз (Yay)
################# Другой способ установки ####################
### pack=(
### oh-my-zsh-git zsh-autosuggestions
### zsh-fast-syntax-highlighting gitstatus-bin
#### ttf-meslo-nerd-font-powerlevel10k
### zsh-theme-powerlevel10k-git
### )
### yay -Sy --noconfirm --needed ${pack[@]}
####################
echo ""
echo -e "${BLUE}:: ${NC}Добавим в систему GitStatus - Состояние Git для команд Bash и Zsh "
echo " gitstatus — это в 10 раз более быстрая альтернатива git status и git describe. Его основное применение — включение быстрого приглашения git в интерактивных оболочках. "
##### gitstatus-bin ######
# yay -S gitstatus-bin --noconfirm --needed  # Состояние Git для команд Bash и Zsh ; https://aur.archlinux.org/gitstatus-bin.git (только для чтения, нажмите, чтобы скопировать); https://github.com/romkatv/gitstatus ; https://aur.archlinux.org/packages/gitstatus-bin
### gitstatus — это в 10 раз более быстрая альтернатива git statusи git describe. Его основное применение — включение быстрого приглашения git в интерактивных оболочках.
  cd /home/$username
  git clone https://aur.archlinux.org/gitstatus-bin.git
  chown -R $username:users /home/$username/gitstatus-bin
  chown -R $username:users /home/$username/gitstatus-bin/PKGBUILD
  cd /home/$username/gitstatus-bin
  sudo -u $username  makepkg -si --noconfirm
#  sudo -u $username  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
  rm -Rf /home/$username/gitstatus-bin
### Для тех, кто хочет использовать gitstatus без темы, есть gitstatus.prompt.zsh . Установите его следующим образом:
# git clone --depth=1 https://github.com/romkatv/gitstatus.git ~/gitstatus
# echo 'source ~/gitstatus/gitstatus.prompt.zsh' >>! ~/.zshrc
echo " gitstatus.git успешно добавлен в установлен "
echo ""
echo " Установка Oh My Zsh! "
##### oh-my-zsh-git ######
# yay -S oh-my-zsh-git --noconfirm --needed  # Фреймворк, управляемый сообществом, для управления вашей конфигурацией zsh. Включает более 180 дополнительных плагинов и более 120 тем, чтобы оживить ваше утро, а также инструмент автоматического обновления, который позволяет легко быть в курсе последних обновлений от сообщества ; https://aur.archlinux.org/oh-my-zsh-git.git (только для чтения, нажмите, чтобы скопировать); https://github.com/ohmyzsh/ohmyzsh ; https://aur.archlinux.org/packages/oh-my-zsh-git
  cd /home/$username
  git clone https://aur.archlinux.org/oh-my-zsh-git.git
  chown -R $username:users /home/$username/oh-my-zsh-git
  chown -R $username:users /home/$username/oh-my-zsh-git/PKGBUILD
  cd /home/$username/oh-my-zsh-git
  sudo -u $username  makepkg -si --noconfirm
#  sudo -u $username  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
  rm -Rf /home/$username/oh-my-zsh-git
### yay -Rns oh-my-zsh-git  # УДАЛЕНИЕ Oh My Zsh!
##### zsh-autosuggestions-git ######
# yay -S zsh-autosuggestions-git --noconfirm --needed  # Рыбоподобные автопредложения для zsh (из git) zsh-автопредложения ; https://aur.archlinux.org/zsh-autosuggestions-git.git (только для чтения, нажмите, чтобы скопировать); https://github.com/zsh-users/zsh-autosuggestions ; https://aur.archlinux.org/packages/zsh-autosuggestions-git
# git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
#  cd /home/$username
#  git clone https://aur.archlinux.org/zsh-autosuggestions-git.git
#  chown -R $username:users /home/$username/zsh-autosuggestions-git
#  chown -R $username:users /home/$username/zsh-autosuggestions-git/PKGBUILD
#  cd /home/$username/zsh-autosuggestions-git
#  sudo -u $username  makepkg -si --noconfirm
#  sudo -u $username  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
#  rm -Rf /home/$username/zsh-autosuggestions-git
##### zsh-fast-syntax-highlighting ######
# yay -S zsh-fast-syntax-highlighting --noconfirm --needed  # Оптимизированная и расширенная подсветка синтаксиса zsh ; https://aur.archlinux.org/zsh-fast-syntax-highlighting.git (только для чтения, нажмите, чтобы скопировать); https://github.com/zdharma-continuum/fast-syntax-highlighting ; https://aur.archlinux.org/packages/zsh-fast-syntax-highlighting
# yay -S zsh-fast-syntax-highlighting-git --noconfirm --needed  # Оптимизированная и расширенная подсветка синтаксиса zsh ; https://aur.archlinux.org/zsh-fast-syntax-highlighting-git.git (только для чтения, нажмите, чтобы скопировать); https://github.com/zdharma-continuum/fast-syntax-highlighting ; https://aur.archlinux.org/packages/zsh-fast-syntax-highlighting-git
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
  cd /home/$username
  git clone https://aur.archlinux.org/zsh-fast-syntax-highlighting.git
  chown -R $username:users /home/$username/zsh-fast-syntax-highlighting
  chown -R $username:users /home/$username/zsh-fast-syntax-highlighting/PKGBUILD
  cd /home/$username/zsh-fast-syntax-highlighting
  sudo -u $username  makepkg -si --noconfirm
#  sudo -u $username  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
  rm -Rf /home/$username/zsh-fast-syntax-highlighting
### yay -Rns oh-my-zsh-git
##### ttf-meslo-nerd-font-powerlevel10k ######
### Что касается шрифта, я нашел один, который является эквивалентом "ttf-meslo-nerd-font-powerlevel10k", то есть ttf-meslo-nerd
  pacman -S --noconfirm --needed ttf-meslo-nerd  # Исправленный шрифт Meslo LG из библиотеки шрифтов nerd ; https://github.com/ryanoasis/nerd-fonts ; https://archlinux.org/packages/extra/any/ttf-meslo-nerd/
  pacman -S --noconfirm --needed powerline-fonts  # исправленные шрифты для powerline ; https://github.com/powerline/powerline ; https://archlinux.org/packages/extra/x86_64/powerline-fonts/
  pacman -S --noconfirm --needed python-powerline  # библиотека python для powerline ; https://github.com/powerline/powerline ; https://archlinux.org/packages/extra/x86_64/python-powerline/
  pacman -S --noconfirm --needed powerline  # Плагин Statusline для vim, а также предоставляет строки состояния и подсказки для нескольких других приложений, включая zsh, bash, tmux, IPython, Awesome, i3 и Qtile ; https://github.com/powerline/powerline ; https://archlinux.org/packages/extra/x86_64/powerline/
  pacman -S --noconfirm --needed awesome-terminal-fonts  # шрифты/значки для линий электропередач ; https://github.com/gabrielelana/awesome-terminal-fonts ; https://archlinux.org/packages/extra/any/awesome-terminal-fonts/
# yay -S ttf-meslo-nerd-font-powerlevel10k --noconfirm --needed  # Шрифт Meslo Nerd исправлен для Powerlevel10k ; https://aur.archlinux.org/ttf-meslo-nerd-font-powerlevel10k.git (только для чтения, нажмите, чтобы скопировать); https://github.com/romkatv/powerlevel10k-media ; https://aur.archlinux.org/packages/ttf-meslo-nerd-font-powerlevel10k
  cd /home/$username
  git clone https://aur.archlinux.org/ttf-meslo-nerd-font-powerlevel10k.git
  chown -R $username:users /home/$username/ttf-meslo-nerd-font-powerlevel10k
  chown -R $username:users /home/$username/ttf-meslo-nerd-font-powerlevel10k/PKGBUILD
  cd /home/$username/ttf-meslo-nerd-font-powerlevel10k
  sudo -u $username  makepkg -si --noconfirm
#  sudo -u $username  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
  rm -Rf /home/$username/ttf-meslo-nerd-font-powerlevel10k
##### zsh-theme-powerlevel10k-git ######
# yay -S zsh-theme-powerlevel10k-git --noconfirm --needed  # Powerlevel10k — тема для Zsh. Она делает акцент на скорости, гибкости и нестандартном опыте ; https://aur.archlinux.org/zsh-theme-powerlevel10k-git.git (только для чтения, нажмите, чтобы скопировать); https://github.com/romkatv/powerlevel10k ; https://aur.archlinux.org/packages/zsh-theme-powerlevel10k-git
# git clone https://github.com/bhilburn/powerlevel9k.git $ZSH_CUSTOM/themes/powerlevel9k
  cd /home/$username
  git clone https://aur.archlinux.org/zsh-theme-powerlevel10k-git.git
  chown -R $username:users /home/$username/zsh-theme-powerlevel10k-git
  chown -R $username:users /home/$username/zsh-theme-powerlevel10k-git/PKGBUILD
  cd /home/$username/zsh-theme-powerlevel10k-git
  sudo -u $username  makepkg -si --noconfirm
#  sudo -u $username  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
  rm -Rf /home/$username/zsh-theme-powerlevel10k-git
echo ""
echo " Установка Менеджера плагинов нового поколения для zsh "
##### zplug ######
# yay -S zplug --noconfirm --needed  # Менеджер плагинов нового поколения для zsh ; https://aur.archlinux.org/packages/zplug ; https://aur.archlinux.org/zplug.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/zplug/zplug ; Конфликты: с mawk, mawk-git ; 2023-08-27 20:29 (UTC)
  cd /home/$username
  git clone https://aur.archlinux.org/zplug.git
  chown -R $username:users /home/$username/zplug
  chown -R $username:users /home/$username/zplug/PKGBUILD
  cd /home/$username/zplug
  sudo -u $username  makepkg -si --noconfirm
#  sudo -u $username  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
  rm -Rf /home/$username/zplug
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##########################

  clear
  echo ""
  echo -e "${BLUE}:: ${NC}Сменим командную оболочку пользователя с Bash на ZSH ?"
  echo -e "${YELLOW}=> Важно! ${BOLD}Если Вы сменили пользовательскую оболочку, то при первом запуске консоли (терминала) - нажмите 0 (ноль), и пользовательская оболочка (сразу будет) ИЗМЕНЕНА, с BASH на ZSH. ${NC}"
  echo " Будьте внимательны! В данной опции выбор всегда остаётся за вами. "
  echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да сменить оболочку пользователя,     0 - НЕТ - Пока оставить (bash): " t_shell  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_shell" =~ [^10] ]]
do
    :
done
if [[ $t_shell == 0 ]]; then
  clear
  echo ""
  echo " Пользовательская оболочка (shell) НЕ изменена, по умолчанию остаётся BASH "
elif [[ $t_shell == 1 ]]; then
  chsh -s /bin/zsh
  chsh -s /bin/zsh $username
  clear
  echo ""
  echo " Важно! При первом запуске консоли (терминала) - нажмите "0" "
  echo " Пользовательская оболочка ИЗМЕНЕНА (сразу будет), с BASH на ZSH "
fi
############ Справка ####################
# Какая оболочка (shell) используется в данный момент: echo $SHELL
# Чтобы просмотреть список установленных оболочек, используйте команду chsh: chsh -l
#########################################

clear
echo -e "${MAGENTA}
  <<< Установка утилит для оформления терминала XFCE и Grub2-Theme в Archlinux >>> ${NC}"
echo -e "${YELLOW}==> Будьте внимательны! ${NC}ЕСЛИ Вы НЕ устаналивали DE (графическое окружение) среды рабочего стола (Xfce),
 То спокойно пропустите установку пакетов оформления терминала и Grub2-Theme !"
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Nord-Xfce-Terminal пакет (nord-xfce-terminal) - элегантная цветовая тема терминала XFCE?"
echo -e "${MAGENTA}:: ${BOLD}Nord-Xfce-Terminal - Арктическая, северо-голубоватая (цветовая палитра), чистая и элегантная цветовая тема XFCE Terminal (https://docs.xfce.org/apps/terminal/start). Разработан для плавного и понятного рабочего процесса на основе цветовой палитры Nord (https://www.nordtheme.com/). Создан для чистого и лаконичного шаблона проектирования, позволяющего добиться оптимальной фокусировки и читабельности при подсветке синтаксиса кода и компонентов пользовательского интерфейса. ${NC}"
echo " Домашняя страница: https://github.com/arcticicestudio/nord-xfce-terminal ; (https://aur.archlinux.org/packages/nord-xfce-terminal). "
echo -e "${MAGENTA}:: ${BOLD}Xfce Terminal — это легкое и простое в использовании приложение-эмулятор терминала со множеством расширенных функций, включая раскрывающиеся списки, вкладки, неограниченную прокрутку, полноцветную настройку, шрифты, прозрачный фон и многое другое. ${NC}"
echo " Xfce Terminal основан на библиотеке VTE Terminal Widget Library , как и gnome-terminal. Vte, вероятно, не самая быстрая библиотека эмуляции терминала на земле, но она одна из лучших, когда дело касается поддержки Unicode, и не забывайте, что она активно разрабатывается. Тем не менее, производительность по-прежнему является важным вопросом для эмулятора терминала, и Vte с включенным сглаживанием шрифтов может быть очень медленной даже на приличных системах. Поэтому Xfce Terminal предлагает возможность явно отключить сглаживание для шрифта терминала. Если у вас возникли проблемы со скоростью рендеринга терминала, вы можете отключить сглаживание для шрифта терминала. "
echo -e "${CYAN}:: ${NC}Установка Nord-Xfce-Terminal пакет (nord-xfce-terminal) проходит через сборку из AUR. Сборка пакета проходит через - git clone, PKGBUILD, makepkg - эта функция прописана в сценарии скрипта. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_nord  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_nord" =~ [^10] ]]
do
    :
done
if [[ $in_nord == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_nord == 1 ]]; then
  echo ""
  echo " Установка Nord-Xfce-Terminal "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
cd /home/$username
git clone https://aur.archlinux.org/nord-xfce-terminal.git
chown -R $username:users /home/$username/nord-xfce-terminal   #-R, --recursive - рекурсивная обработка всех подкаталогов;
chown -R $username:users /home/$username/nord-xfce-terminal/PKGBUILD  #-R, --recursive - рекурсивная обработка всех подкаталогов;
cd /home/$username/nord-xfce-terminal
sudo -u $username  makepkg -si --noconfirm
rm -Rf /home/$username/nord-xfce-terminal
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo -e "${MAGENTA}
  <<< Установка утилит (пакетов) для оформления дизайна вашего загрузчика GRUB 2 для Archlinux >>> ${NC}"
# Installing utilities (packages) for Creating, monitoring, modifying, and deleting disk partitions in Archlinux
#echo ""
echo -e "${YELLOW}==> Примечание! ${BOLD} *Так как сейчас в загрузчике GRUB 2 нет оформления мы постараемся это легко исправить. Ниже мы рассмотрим наиболее популярные и интересные темы, которые можно найти на сайте gnome-look.org или store.kde.org. Вы можете пропустить установку тем и сделать это уже в установленной системе. ${NC}"
sleep 01
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Grub2-Theme-Vimix (grub2-theme-vimix) - Тема размытия для grub?"
echo -e "${MAGENTA}:: ${BOLD}Grub2-Theme-Vimix - Тема в стиле материальном стиле, созданная как дополнение одноимённой темы для GTK. Укомплектована скриптом install.sh, который во многом упрощает её установку. Запускать скрипт нужно дважды; в первый раз он установит зависимости, а во второй саму тему. *Не беспокойтесь! Перед началом установки пакета оформления в сценарии (скрипте) прописана функция создания резервной копии (backup) файлов конфигурации Grub (/etc/default/grub ; /etc/default/grub.cfg и папка /etc/grub.d), а также в директории пользователя будет создана папка (grub-backup) куда будут скопированы как оригинальные файлы, так и дубликаты файла grub (grub.backup0 ; grub.cfg.backup0). ${NC}"
echo " Домашняя страница: https://github.com/kalax2/grub2-theme-vimix ; (https://www.gnome-look.org/p/1009236 ; https://www.gnome-look.org/browse?cat=135&ord=latest ; https://github.com/downloads/Generator/Grub2-themes/Archlinux-1.0.tar.bz2). "
echo -e "${MAGENTA}:: ${BOLD}Стандартный каталог Grub для тем расположен в директории — /usr/share/grub/themes/ . ${NC}"
echo " Pacman (pacman) проверяет наличие конфликтующих файлов перед установкой, удалите /boot/grub/themes/Archlinux перед обновлением, пока не будет найдено лучшее решение для установки #rm -rf /boot/grub/themes/Archlinux. "
echo -e "${CYAN}:: ${NC}Установка Grub2-Theme-Vimix пакет (grub2-theme-vimix) проходит через сборку из исходника (https://github.com/kalax2/grub2-theme-vimix.git) с сайта GitHub. Сборка пакета проходит через - git clone - эта функция прописана в сценарии скрипта. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_vimix  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_vimix" =~ [^10] ]]
do
    :
done
if [[ $in_vimix == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_vimix == 1 ]]; then
  echo ""
  echo " Установка Grub2-Theme-Vimix (grub2-theme-vimix) "
  echo " Перед началом установки Grub2-Theme-Vimix создадим резервную копию файлов конфигурации Grub "
  echo ""
  echo " Создать резервную копию файлов конфигурации Grub "
  echo " Создать папку для резервного копирования в домашнем каталоге пользователя "
mkdir -p ~/grub-backup
  echo ""
  echo " Создание дубликата файла grub в директории исходника "
cp -vf /etc/default/grub /etc/default/grub.backup0  # -v, --verbose - максимально подробный вывод ; -f, --force - удалить файл назначения перед попыткой записи в него если он существует
echo " Создание backup файла grub выполнено "
  echo ""
  echo " Скопировать файл конфигурации Grub из папки /etc/default/grub в папку grub-backup "
#cp /etc/default/grub ~/grub-backup/
cp -vf /etc/default/grub ~/grub-backup/
cp -vf /etc/default/grub.backup0 ~/grub-backup/
echo " Копирование файла grub выполнено "
  echo ""
  echo " Создание дубликата файла grub.cfg в директории исходника "
cp -vf /boot/grub/grub.cfg /boot/grub/grub.cfg.backup0  # -v, --verbose - максимально подробный вывод ; -f, --force - удалить файл назначения перед попыткой записи в него если он существует
echo " Создание backup файла grub.cfg выполнено "
  echo ""
  echo " Скопировать файл конфигурации Grub из папки /boot/grub/grub.cfg в папку grub-backup "
#cp /boot/grub/grub.cfg ~/grub-backup/
cp -vf /boot/grub/grub.cfg ~/grub-backup/
cp -vf /etc/default/grub.cfg.backup0 ~/grub-backup/
echo " Копирование файла grub.cfg выполнено "
  echo ""
  echo " Скопировать файлы из папки /etc/grub.d (где находятся остальные конфигурации Grub) в папку grub-backup "
cp -a /etc/grub.d ~/grub-backup  # -a - режим резервного копирования, при котором сохраняются все атрибуты, ссылки, а также выполняется резервное копирование папок, аналогично --recursive --preserve=all, --no-dereference;
# cp -a /etc/grub.d /etc/grub.d/grub-backup/grub.d  # создаёт резервную копию файлов конфигурации загрузчика Grub из каталога /etc/grub.d
echo " Копирование папки /etc/grub.d выполнено "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
cd /home/$username
##### Download Themes
## https://github.com/Se7endAY/grub2-theme-vimix
# https://github.com/kalax2/grub2-theme-vimix.git
#git clone https://github.com/Se7endAY/grub2-theme-vimix.git для Fedora 28/29/32
git clone https://github.com/kalax2/grub2-theme-vimix.git
##### Install Themes
cd /home/$username/grub2-theme-vimix
cp -r Vimix /boot/grub/themes/  # -r, --recursive - копировать папку Linux рекурсивно
# cp -r grub2-theme-vimix/{Vimix} /boot/grub/themes/
echo "sed -i -e \"s/GRUB_GFXMODE=auto/GRUB_GFXMODE=1024x768/g\" /etc/default/grub"
sed -i -e "s/GRUB_GFXMODE=auto/GRUB_GFXMODE=1024x768/g" /etc/default/grub
echo "sed -i -e \"s/#GRUB_THEME/GRUB_THEME/g\" /etc/default/grub"
sed -i -e "s/#GRUB_THEME/GRUB_THEME/g" /etc/default/grub
echo "sed -i -e \"s|/path/to/gfxtheme|/boot/grub/themes/Vimix/theme.txt|g\" /etc/default/grub"
sed -i -e "s|/path/to/gfxtheme|/boot/grub/themes/Vimix/theme.txt|g" /etc/default/grub
# rm -rf /grub2-theme-vimix
rm -Rf /home/$username/grub2-theme-vimix
##### Configure Grub
echo " Настраиваем и конфигурируем grub (Обновление grub) "
grub-mkconfig -o /boot/grub/grub.cfg  # создаём конфигурационный файл ; Обновление grub
# grub2-mkconfig -o /etc/grub2-efi.cfg  # Обновите grub для загрузки UEFI
sleep 1
## -e - команды, которые надо выполнить для редактирования;
## -i - сделать резервную копию файла перед редактированием;
######################
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#############
# Installation Arch Linux  https://github.com/kalax2/grub2-theme-vimix
# https://aur.archlinux.org/packages?O=0&SeB=nd&K=grub-theme-vimix&outdated=&SB=p&SO=d&PP=50&submit=Go
# установить пакеты из AUR (install packages form AUR) :
# $ yaourt -S grub2-theme-vimix-git
# Редактировать /etc/default/grub (Edit /etc/default/grub) :
# GRUB_THEME="/boot/grub/themes/Vimix/theme.txt"
# Обновление grub (Update grub) :
# $ grub-mkconfig -o /boot/grub/grub.cfg
# Лучшие темы для Grub: https://losst.pro/luchshie-temy-dlya-grub
###############

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Grub2-Theme-Breeze (grub2-theme-breeze) - Минималистичная тема для grub?"
echo -e "${MAGENTA}:: ${BOLD}Grub2-Theme-Breeze - Тема с иконками и красивой фоновой картинкой. Создана в стандартном для KDE 5 стиле Breeze. Те, кто использует Среда рабочего стола KDE Plasma Нужно попробовать Breeze. Это полностью переписанный загрузочный экран Grub, чтобы он соответствовал стандартному. *Не беспокойтесь! Перед началом установки пакета оформления в сценарии (скрипте) прописана функция создания резервной копии (backup) файлов конфигурации Grub (/etc/default/grub ; /etc/default/grub.cfg и папка /etc/grub.d), а также в директории пользователя будет создана папка (grub-backup) куда будут скопированы как оригинальные файлы, так и дубликаты файла grub (grub.backup0 ; grub.cfg.backup0). ${NC}"
echo " Домашняя страница: https://github.com/gustawho/grub2-theme-breeze?tab=readme-ov-file ; (https://github.com/gustawho/grub2-theme-breeze ; https://store.kde.org/p/1000140/ ; https://www.gnome-look.org/p/1000140 ; https://github.com/gustawho/grub2-theme-breeze.git). "
echo -e "${MAGENTA}:: ${BOLD}Стандартный каталог Grub для тем расположен в директории — /usr/share/grub/themes/ . ${NC}"
echo " Pacman (pacman) проверяет наличие конфликтующих файлов перед установкой, удалите /boot/grub/themes/Archlinux перед обновлением, пока не будет найдено лучшее решение для установки #rm -rf /boot/grub/themes/Archlinux. "
echo -e "${CYAN}:: ${NC}Установка Grub2-Theme-Breeze (grub2-theme-breeze) проходит через сборку из исходника (https://github.com/gustawho/grub2-theme-breeze.git) с сайта GitHub. Сборка пакета проходит через - git clone - эта функция прописана в сценарии скрипта. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_breeze  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_breeze" =~ [^10] ]]
do
    :
done
if [[ $in_breeze == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_breeze == 1 ]]; then
  echo ""
  echo " Установка Grub2-Theme-Breeze (grub2-theme-breeze) "
  echo " Перед началом установки Grub2-Theme-Breeze создадим резервную копию файлов конфигурации Grub "
  echo ""
  echo " Создать резервную копию файлов конфигурации Grub "
  echo " Создать папку для резервного копирования в домашнем каталоге пользователя "
mkdir -p ~/grub-backup
  echo ""
  echo " Создание дубликата файла grub в директории исходника "
cp -vf /etc/default/grub /etc/default/grub.backup0  # -v, --verbose - максимально подробный вывод ; -f, --force - удалить файл назначения перед попыткой записи в него если он существует
echo " Создание backup файла grub выполнено "
  echo ""
  echo " Скопировать файл конфигурации Grub из папки /etc/default/grub в папку grub-backup "
#cp /etc/default/grub ~/grub-backup/
cp -vf /etc/default/grub ~/grub-backup/
cp -vf /etc/default/grub.backup0 ~/grub-backup/
echo " Копирование файла grub выполнено "
  echo ""
  echo " Создание дубликата файла grub.cfg в директории исходника "
cp -vf /boot/grub/grub.cfg /boot/grub/grub.cfg.backup0  # -v, --verbose - максимально подробный вывод ; -f, --force - удалить файл назначения перед попыткой записи в него если он существует
echo " Создание backup файла grub.cfg выполнено "
  echo ""
  echo " Скопировать файл конфигурации Grub из папки /boot/grub/grub.cfg в папку grub-backup "
#cp /boot/grub/grub.cfg ~/grub-backup/
cp -vf /boot/grub/grub.cfg ~/grub-backup/
cp -vf /etc/default/grub.cfg.backup0 ~/grub-backup/
echo " Копирование файла grub.cfg выполнено "
  echo ""
  echo " Скопировать файлы из папки /etc/grub.d (где находятся остальные конфигурации Grub) в папку grub-backup "
cp -a /etc/grub.d ~/grub-backup  # -a - режим резервного копирования, при котором сохраняются все атрибуты, ссылки, а также выполняется резервное копирование папок, аналогично --recursive --preserve=all, --no-dereference;
# cp -a /etc/grub.d /etc/grub.d/grub-backup/grub.d  # создаёт резервную копию файлов конфигурации загрузчика Grub из каталога /etc/grub.d
echo " Копирование папки /etc/grub.d выполнено "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
cd /home/$username
##### Download Themes
## https://github.com/gustawho/grub2-theme-breeze?tab=readme-ov-file
#git clone https://github.com/gustawho/grub2-theme-breeze.git
git clone https://github.com/gustawho/grub2-theme-breeze.git
##### Install Themes
cd /home/$username/grub2-theme-breeze
# mv breeze Breeze
ls /home/$username/grub2-theme-breeze
sleep 02
cp -r breeze /boot/grub/themes/  # -r, --recursive - копировать папку Linux рекурсивно
# cp -r grub2-theme-vimix/{Vimix} /boot/grub/themes/
echo "sed -i -e \"s/GRUB_GFXMODE=auto/GRUB_GFXMODE=1024x768/g\" /etc/default/grub"
sed -i -e "s/GRUB_GFXMODE=auto/GRUB_GFXMODE=1024x768/g" /etc/default/grub
echo "sed -i -e \"s/#GRUB_THEME/GRUB_THEME/g\" /etc/default/grub"
sed -i -e "s/#GRUB_THEME/GRUB_THEME/g" /etc/default/grub
echo "sed -i -e \"s|/path/to/gfxtheme|/boot/grub/themes/breeze/theme.txt|g\" /etc/default/grub"
sed -i -e "s|/path/to/gfxtheme|/boot/grub/themes/breeze/theme.txt|g" /etc/default/grub
# rm -rf /grub2-theme-breeze
rm -Rf /home/$username/grub2-theme-breeze
##### Configure Grub
echo " Настраиваем и конфигурируем grub (Обновление grub) "
grub-mkconfig -o /boot/grub/grub.cfg  # создаём конфигурационный файл ; Обновление grub
# grub2-mkconfig -o /etc/grub2-efi.cfg  # Обновите grub для загрузки UEFI
sleep 1
## -e - команды, которые надо выполнить для редактирования;
## -i - сделать резервную копию файла перед редактированием;
######################
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#############

clear
echo -e "${MAGENTA}
  <<< Включение сброса ATA TRIM для монтирования SSD-накопителей (твердотельных накопителей) >>> ${NC}"
echo ""
echo -e "${GREEN}==> ${NC}Что такое ТРИМ? TRIM — это имя команды, которую операционная система может отправить, чтобы сообщить SSD, какие блоки в файловой системе свободны (о незадействованных блоках). SSD использует эту информацию для внутренней дефрагментации блоков и сохранения свободных страниц для быстрой и эффективной запись. Запись в пустые блоки происходит быстрее, что ускоряет работу системы."
echo -e "${BLUE}:: ${NC}Зачем это нужно? Ну, по мнению Путина В. В., у нас в стране "слишком много бухгалтеров", поэтому вот и сделали еще один ежемесячный отчет."
echo -e "${CYAN}:: ${NC}ЕЩЁ РАЗ! - fstrim используется в смонтированной файловой системе для удаления (или "обрезки") блоков, которые не используются файловой системой. Это полезно для твердотельных накопителей (SSD) и тонко-предусмотренных хранилищ."
echo -e "${CYAN}:: ${NC}Важно! Убедитесь, что ваш SSD поддерживает TRIM, прежде чем пытаться использовать его, иначе возможна потеря данных! Проверить поддержку TRIM можно с помощью команды: lsblk --discard . Проверьте значения столбцов DISC-GRAN (discard granularity) и DISC-MAX (discard max bytes). Ненулевые значения означают поддержку TRIM."
echo " Другой вариант — установить пакет hdparm и выполнить команду: # hdparm -I /dev/sda | grep TRIM - ИЛИ (sdb,sdc и т.д.). Где sda ваш SSD диск. Вывод команды должен содержать строку "TRIM supported". "
echo " Примечание: Спецификация определяет различные типы поддержки TRIM. Следовательно, вывод может отличаться в зависимости от того, что поддерживает диск. Смотрите Wikipedia:Trim (computing)#ATA для более подробной информации.  "
echo " Стоит отдельно сказать про SSD с интерфейсом NVMe — эти диски обладают другим набором команд для работы, но аналог ATA команды TRIM там тоже существует — называется она Deallocate и, соответственно, является идентичной. "
echo -e "${CYAN}:: ${NC}Что касается Linux-систем, то обязательным условием, помимо аппаратной составляющей, является файловая система ext4. Включение TRIM указывается опцией discard в файле fstab. Дополнительными полезными опциями для раздела станут noatime (realtime или nodiratime), которые снизят запись путём отключения обновления времени последнего доступа к файлам и директориям. Сама же команда TRIM запускается при помощи программы fstrim – «fstrim / -v» без кавычек и с правами рута. Создание задания TRIM Cron для вашего SSD (https://itshaman.ru/articles/1435/kak-vklyuchit-trim-dlya-ssd-v-ubuntu)."
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Запустим таймер 'TRIM' (fstrim.timer),     0 - Пропустить запуск (fstrim.service): " i_catalog  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_catalog" =~ [^10] ]]
do
    :
done
if [[ $i_catalog == 0 ]]; then
  echo ""
  echo " Запуск (fstrim.service) пропущен "
elif [[ $i_catalog == 1 ]]; then
  echo ""
  echo " Запустим таймер 'TRIM' (fstrim.timer) по умолчанию "
  lsblk -Df   # Команда df — это утилита, которая отображает информацию об использовании дискового пространства. Команда lsblk предоставляет древовидное представление блочных устройств.
  sleep 1
  pacman -Syy  # обновление баз пакмэна (pacman)
  pacman -S --noconfirm --needed hdparm  # Утилита оболочки для управления параметрами диска/драйвера Linux IDE ; https://sourceforge.net/projects/hdparm/ ; https://archlinux.org/packages/core/x86_64/hdparm/
  pacman -S --noconfirm --needed sdparm  # Утилита, похожая на hdparm, но для устройств SCSI ; http://sg.danny.cz/sg/sdparm.html ; https://archlinux.org/packages/core/x86_64/sdparm/
  pacman -S --noconfirm --needed util-linux  # Различные системные утилиты для Linux ; https://github.com/util-linux/util-linux ; https://archlinux.org/packages/core/x86_64/util-linux/
  echo " Добавляем в автозагрузку (fstrim.timer)"
  systemctl enable fstrim.timer   # # Включаем службу
### Необязательный шаг, если вы хотите запустить fstrim.service
# sudo systemctl start fstrim.service
# sudo systemctl status fstrim.timer
### Включение, старт и вывод статуса сервиса:
# systemctl enable fstrim.service && \
# systemctl start fstrim.service && \
# systemctl status fstrim.service
# journalctl -u fstrim  # Служба fstrim будет записывать в syslog каждый раз, когда она вызывается:
  echo ""
  echo " Запуск таймер 'TRIM' (fstrim.timer) успешно выполнен "
fi
###################
echo ""
echo " Установим задание cron для ОС, чтобы отправлять команду TRIM один раз в день "
# mkdir -p  /etc/cron.daily/
# vim /etc/cron.daily/trim
# nano /etc/cron.daily/trim
# sudo fstrim -v /         # Ручной метод.
# sudo fstrim -va /        # Если первый метод не тримит весь диск.
echo " Создать файл trim в /etc/cron.daily/ "
touch /etc/cron.daily/trim   # Создать файл trim в /etc/cron.daily/
echo " Пропишем следующий код в (etc/cron.daily/trim) "
> /etc/cron.daily/trim
cat <<EOF >>/etc/cron.daily/trim
#!/bin/sh
LOG=/var/log/trim.log
echo "*** $(date -R) ***" >> $LOG
fstrim -v / >> $LOG
fstrim -v /home >> $LOG

EOF
######################
echo " Сделайте задание cron файл trim исполняемым "
#sudo chmod a+x /etc/cron.daily/trim
chmod a+x /etc/cron.daily/trim
echo " Для начала сделаем его бэкап  /etc/cron.daily/trim "
cp /etc/cron.daily/trim  /etc/cron.daily/trim.back
echo " Просмотреть содержимое файла /etc/cron.daily/trim "
#ls -l /etc/cron.daily   # ls — выводит список папок и файлов в текущей директории
cat /etc/cron.daily/trim  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 3
#######################
### ИЛИ ТАК:
# mv /etc/cron.daily/trim /etc/cron.weekly/trim
# sudo mv /etc/cron.daily/trim /etc/cron.weekly/trim
#echo ""
#echo " Установим задание cron для ОС, чтобы отправлять команду TRIM каждую неделю "
# nano /etc/cron.weekly/trim
#echo " Создать файл trim в /etc/cron.weekly/ "
#touch /etc/cron.weekly/trim   # Создать файл trim в /etc/cron.weekly/
#echo " Пропишем следующий код в (etc/cron.weekly/trim) "
#> /etc/cron.weekly/trim
#cat <<EOF >>/etc/cron.weekly/trim
##!/bin/sh
#LOG=/var/log/trim.log
#echo "*** $(date -R) ***" >> $LOG
#fstrim -v / >> $LOG
#fstrim -v /home >> $LOG
#
#EOF
######################
#echo " Сделайте задание cron файл trim исполняемым "
#sudo chmod a+x /etc/cron.weekly/trim
#chmod a+x /etc/cron.weekly/trim
#echo " Для начала сделаем его бэкап  /etc/cron.daily/trim "
#cp /etc/cron.weekly/trim  /etc/cron.weekly/trim.back
#ls -l /etc/cron.weekly   # ls — выводит список папок и файлов в текущей директории
#cat /etc/cron.weekly/trim  # cat читает данные из файла или стандартного ввода и выводит их на экран
#sleep 3
#######################
#echo " Проверьте, работает ли функция TRIM "
# sudo fstrim -v /
#fstrim -v /
#############################
### Можно ли изменить частоту выполнения команды fstrim?
### Да. По умолчанию Linux предоставляет несколько файлов таймеров, которые позволяют точно настроить время использования fstrim. Например, вы можете выполнить команду sudo mv /etc/cron.daily/trim /etc/cron.weekly/trim, чтобы изменить частоту TRIM с каждого дня на каждую неделю.
### По умолчанию служба «fstrim.timer» запускается раз в неделю. Этот интервал обеспечивает баланс между поддержанием производительности SSD и предотвращением чрезмерного использования операции TRIM, которая при чрезмерном использовании может незначительно повлиять на срок службы накопителя.
### Однако, если вы предпочитаете контролировать запуск TRIM, вы можете выполнить его вручную, передав путь к подключенному разделу в качестве последнего параметра. Например:
#sudo fstrim -v /
#sudo fstrim -v /data/
##############################

clear
echo -e "${MAGENTA}
  <<< Настройка точпада для сенсорных панелей (Touchpad Synaptics) и (ALPS) >>> ${NC}"
echo ""
echo -e "${GREEN}==> ${NC}Synaptics Pointing Device Driver — это драйвер (программа-посредник между "железом" и операционкой) тачпада (Pointing Device - указывающее устройство (англ.)), который есть практически в каждом ноутбуке. Synaptics - фирма-производитель тачпада, одна из лидеров в этой области. "
echo -e "${BLUE}:: ${NC}Этот драйвер обеспечивает наиболее полное использование возможностей тачпада (мультитач, управление жестами и т.д.), удалять его не стоит."
echo -e "${CYAN}:: ${NC}Основной способ конфигурации тачпада - через настройку файла сервера Xorg. После установки xf86-input-synaptics, файл с настройками по умолчанию находится в /usr/share/X11/xorg.conf.d/70-synaptics.conf. "
echo -e "${CYAN}:: ${NC}Важно! Пользователь может скопировать этот файл в /etc/X11/xorg.conf.d/ и отредактировать под своё специфичное устройство.(хотя небольшие настройки файла 70-synaptics.conf - уже заложены в сценарий этого скрипта установки) "
echo " Примечание: Для получения списка всех доступных опций, необходимо обратиться к synaptics (https://man.archlinux.org/man/synaptics.4) man-руководства. Специфичные для текущей машины опции можно узнать с помощью #Synclient (https://wiki.archlinux.org/title/Touchpad_Synaptics_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)#Synclient). "
echo " Кроме традиционного, есть еще несколько способов конфигурирования. Драйвер Synaptics поддерживает изменение настроек "на лету". Это предполагает, что пользователи могут выбирать нужные им опции в приложении, которые вступят в силу немедленно, без перезапуска X. Это удобно для тестирование настроек перед прописыванием в файл конфигурации или в скрипт. Имейте в виду, что изменённые "на лету" настройки сбрасываются при перезапуске сервера Xorg. "
echo -e "${CYAN}:: ${NC}Для изменения настроек в XFCE 4: Откройте Диспетчер настроек. Нажмите Мышь и тачпад. Выберите ваш тачпад в списке устройств и измените настройки на вкладке Тачпад. В зависимости от модели вашего тачпада, он может иметь или не иметь некоторые возможности. Можно определить поддерживаемые возможности с помощью xinput(https://man.archlinux.org/man/xinput). Примечание: Если вы внезапно обнаружили, что ваши руки касаются тачпада при печати текста и это вызывает нежелательное нажатие средней клавиши, то измените значение опции TapButton2 на 0, чтобы отключить ее. Смотрите также #Отключение тачпада во время печати (https://wiki.archlinux.org/title/Touchpad_Synaptics)."
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Запустить настройку (Touchpad Synaptics),     0 - Пропустить настройку: " i_synaptics  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_synaptics" =~ [^10] ]]
do
    :
done
if [[ $i_synaptics == 0 ]]; then
  echo ""
  echo " Запуск (Touchpad Synaptics) пропущен "
elif [[ $i_synaptics == 1 ]]; then
  echo ""
  echo " Запуск настройки (Touchpad Synaptics) по умолчанию "
  pacman -Syy  # обновление баз пакмэна (pacman)
  pacman -S --noconfirm --needed xf86-input-synaptics  # Драйвер Synaptics для сенсорных панелей ноутбуков ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xf86-input-synaptics/
  pacman -S --noconfirm --needed libinput  # Библиотека управления устройствами ввода и обработки событий ; https://gitlab.freedesktop.org/libinput/libinput ; https://archlinux.org/packages/extra/x86_64/libinput/
  pacman -S --noconfirm --needed xf86-input-libinput  # Универсальный драйвер ввода для сервера X.Org на основе libinput ; http://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xf86-input-libinput/
  pacman -S --noconfirm --needed xorg-xinput  # Небольшой инструмент командной строки для настройки устройств ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xinput/
  pacman -S --noconfirm --needed evtest  # Монитор событий устройства ввода и инструмент запросов ; https://cgit.freedesktop.org/evtest/ ; https://archlinux.org/packages/extra/x86_64/evtest/
  pacman -S --noconfirm --needed xorg-xev  # Распечатать содержимое X событий ; https://gitlab.freedesktop.org/xorg/app/xev ; https://archlinux.org/packages/extra/x86_64/xorg-xev/
  pacman -S --noconfirm --needed piper  # Приложение GTK для настройки игровых мышей ; https://github.com/libratbag/piper ; https://archlinux.org/packages/extra/any/piper/ ;
  ### Позволяет выполнить более тонкую настройку вашей мышки, в том числе переназначить DPI, настроить подсветку и собственные действия на дополнительные кнопки. Поддерживаются только некоторые из моделей мышек от Logitech/Razer/Steelseries. Полный список поддерживаемых устройств вы можете найти по ссылке: https://github.com/libratbag/libratbag/wiki/Devices
###################
#echo ""
#echo " Создать каталог (xorg.conf.d) в /etc/X11 "
#mkdir /etc/X11/xorg.conf.d   # Создать каталог xorg.conf.d в /etc/X11
echo ""
echo " Создать файл 70-synaptics.conf в /etc/X11/xorg.conf.d/ "
touch /etc/X11/xorg.conf.d/70-synaptics.conf   # Создать файл /resolvconf.conf в /etc
#ls -l /etc/X11/   # ls — выводит список папок и файлов в текущей директории
cat /etc/X11/xorg.conf.d/70-synaptics.conf  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 1
echo ""
echo " Пропишем сценарий в /etc/X11/xorg.conf.d/70-synaptics.conf "
> /etc/X11/xorg.conf.d/70-synaptics.conf
cat <<EOF >>/etc/X11/xorg.conf.d/70-synaptics.conf
Section "InputClass"
    Identifier "touchpad"
    Driver "synaptics"
    MatchIsTouchpad "on"
        Option "TapButton1" "1"
        Option "TapButton2" "3"
        Option "TapButton3" "2"
EndSection

EOF
######################
### Или раскомментируйте:
#echo " Пропишем сценарий в /etc/X11/xorg.conf.d/70-synaptics.conf "
#> /etc/X11/xorg.conf.d/70-synaptics.conf
#cat <<EOF >>/etc/X11/xorg.conf.d/70-synaptics.conf
#Section "InputClass"
#    Identifier "touchpad"
#    Driver "synaptics"
#    MatchIsTouchpad "on"
#        Option "TapButton1" "1"
#        Option "TapButton2" "3"
#        Option "TapButton3" "2"
#        Option "VertEdgeScroll" "on"
#        Option "VertTwoFingerScroll" "on"
#        Option "HorizEdgeScroll" "on"
#        Option "HorizTwoFingerScroll" "on"
#        Option "CircularScrolling" "on"
#        Option "CircScrollTrigger" "2"
#        Option "EmulateTwoFingerMinZ" "40"
#        Option "EmulateTwoFingerMinW" "8"
#        Option "CoastingSpeed" "0"
#        Option "FingerLow" "30"
#        Option "FingerHigh" "50"
#        Option "MaxTapTime" "125"
#        ...
#EndSection
#
#EOF
##############
### Или есть такой вариант:
#echo " Пропишем сценарий в /etc/X11/xorg.conf.d/10-synaptics.conf "
#> /etc/X11/xorg.conf.d/10-synaptics.conf
#cat <<EOF >>/etc/X11/xorg.conf.d/10-synaptics.conf
#Section "InputClass"
#       Identifier "touchpad catchall"
#       Driver "synaptics"
#       MatchIsTouchpad "on"
#       MatchDevicePath "/dev/input/event*"
#           Option "TapButton1" "1"
#           Option "TapButton2" "2"
#          Option "TapButton3" "3"
#EndSection
#
#EOF
##############
  echo " Запуск настройки (Touchpad Synaptics) успешно выполнен "
fi
######################
### https://wiki.archlinux.org/title/Touchpad_Synaptics_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)#Synclient
### https://wiki.archlinux.org/title/Libinput
### Инструмент evtest может отображать давление и размещение на сенсорной панели в режиме реального времени, позволяя дополнительно уточнить настройки Synaptics по умолчанию.
######################

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить SystemdGenie (systemdgenie) (чтобы посмотрить над чем работает systemd)?"
echo -e "${BLUE}:: ${NC}SystemdGenie - инициализация системы (systemdgenie) — это утилита управления systemd, графический конфигуратор systemd, основанная на технологиях KDE. Она предоставляет графический интерфейс для демона systemd, который позволяет просматривать и контролировать юниты systemd, сеансы logind, а также легко изменять файлы конфигурации и юнитов."
echo -e "${CYAN}:: ${NC}Обеспечивает распараллеливание запуска служб в процессе загрузки системы, что позволяет существенно ускорить запуск ОС. Имеется встроенный редактор юнитов. Существуют специальные типы юнитов, которые не несут функциональной нагрузки, но позволяют задействовать дополнительные возможности systemd. Для вызова привилигированных действий запрашивается авторизация. Код инструмента написан на языке С++ и распространяется под лицензией GPLv2. Для запускаемых служб использует сокеты и активацию D-Bus. Доступ к SystemdGenie можно получить через меню приложения или введя команду systemdgenie из терминала."
echo -e "${CYAN}:: ${NC}Важно! Интересно, а насколько оно прибито гвоздями к KDE? Да SystemdGenie (systemdgenie) приложения пришедшее на смену приложению Systemd-kcm в KDE. Звисимости из оболочки KDE оно подтягивает, но на мой взгляд не столь критично! даже, если вы не устанавливали оболочки KDE и Поэтому -.... "
echo " Примечание: И Поэтому в скрипте установки прописано 2 (два)! варианта графического интерфейса для systemd: "
echo " 1. Systemd-UI (systemd-ui) - Этот пакет предоставляет systemadm — графический интерфейс для systemd, написан на GTK. Systemd GUI - так называемые Инструменты управления системным графическим интерфейсом: systemadm - часть пакета systemd-ui, предоставляющая простой интерфейс для управления модулями systemd. Gnome System Monitor - инструмент на основе GNOME, позволяющий пользователям управлять запущенными процессами и службами. Cockpit - веб-интерфейс для управления сервером, включающий функции управления службами systemd. Устанавливается также из репозитория Archlinux (https://archlinux.org/packages/), но уже с небольшим количеством зависимостей! "
echo -e "${CYAN}:: ${NC}2. SystemdGenie (systemdgenie) — это утилита управления systemd, графический конфигуратор systemd, основанная на технологиях KDE. "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить Systemd-UI (systemd-ui),     2 - Установить SystemdGenie (systemdgenie),

    0 - Пропустить : " i_systemadm  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_systemadm" =~ [^120] ]]
do
    :
done
if [[ $i_systemadm == 0 ]]; then
  echo ""
  echo " Установка утилит пропущена "
elif [[ $i_systemadm == 1 ]]; then
  echo ""
  echo " Установим Systemd-UI (systemd-ui) "
  pacman -Syy  # обновление баз пакмэна (pacman)
  pacman -S --noconfirm --needed systemd-ui  # Графический интерфейс для systemd ; https://www.freedesktop.org/wiki/Software/systemd ; https://archlinux.org/packages/extra/x86_64/systemd-ui/ ; https://systemd.io/
  pacman -S --noconfirm --needed python-systemd  # Привязки Python для systemd ; Модуль Python для собственного доступа к средствам systemd ; https://github.com/systemd/python-systemd ; https://archlinux.org/packages/extra/x86_64/python-systemd/
echo " Установка Systemd-UI (systemd-ui) успешно выполнена "
elif [[ $i_systemadm == 2 ]]; then
  echo ""
  echo " Установим SystemdGenie (systemdgenie) "
  pacman -Syy  # обновление баз пакмэна (pacman)
  pacman -S --noconfirm --needed systemdgenie  # Утилита управления Systemd ; https://invent.kde.org/system/systemdgenie ; https://archlinux.org/packages/extra/x86_64/systemdgenie/ ; http://cgit.kde.org/systemdgenie.git
echo " Установка SystemdGenie (systemdgenie) успешно выполнена "
fi

clear
echo -e "${MAGENTA}
  <<< Запустить Man-db.timer (сервис, который ежедневно пересоздаёт базу данных страниц руководства) >>> ${NC}"
echo ""
echo -e "${GREEN}==> ${NC}Man-db.timer — это сервис, который ежедневно пересоздаёт базу данных страниц руководства. Он стартует с 00:00 (OnCalendar=daily) с точностью 12 часов (AccuracySec=12h), то есть может сработать в любой момент между полуночью и полднем, в зависимости от загрузки системы. "
echo -e "${BLUE}:: ${NC}Обычно рекомендуется держать его запущенным. Он периодически обновляет базу данных страницами man─ т. е. отформатированными страницами справки для инструментов командной строки. Так что включение man-db.timer будет правильным решением! "
echo -e "${CYAN}:: ${NC}GNU/Linux и все другие системы UNIX разработаны для работы 24/7 и для выполнения задач обслуживания в фоновом режиме, когда ожидается, что система будет простаивать большую часть времени, например, в полночь или в 04:00 утра. Но если ваша система не работает, когда запланирована определенная задача, то эта задача будет выполнена при следующей загрузке. "
echo -e "${CYAN}:: ${NC}В твоей системе есть пакеты. Пакет в Linux - это набор разного г:вна, в т.ч. man-файлов. Это обычные текстовые файлы, которые разбросаны где ни попадя. Чтобы производить быстрый поиск по этим файлам, их содержимое нужно проиндексировать (засунуть в какую-то базу, где хранятся упорядоченные данные): fd index.db /  - man файлы, кстати, могут быть и к питоновским пакетам. "
echo " Man-db - это полностью бесплатное программное обеспечение командной строки с открытым исходным кодом, которое реализует стандартную систему документации UNIX в операционных системах на базе Linux. "
echo -e "${CYAN}:: ${NC}Доступ к этой системе документации осуществляется пользователями через команду man, которая доступна почти во всех дистрибутивах Linux. "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Запустить сервис Man-db.timer,     0 - Пропустить : " i_mandb  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_mandb" =~ [^10] ]]
do
    :
done
if [[ $i_mandb == 0 ]]; then
  echo ""
  echo " Запуск сервиса Man-db.timer пропущен "
elif [[ $i_mandb == 1 ]]; then
  echo ""
  echo " Запуск сервиса Man-db.timer по умолчанию "
  pacman -Syy  # обновление баз пакмэна (pacman)
  pacman -S --noconfirm --needed man-pages  # Страницы руководства Linux ; https://www.kernel.org/doc/man-pages/ ; https://archlinux.org/packages/core/any/man-pages/
  pacman -S --noconfirm --needed man-db  # Утилита для чтения страниц руководства ; создаёт или обновляет кэши index справочных страниц ; https://gitlab.com/man-db/man-db ; https://archlinux.org/packages/core/x86_64/man-db/ ; https://gitlab.com/man-db/man-db
# sudo systemctl unmask man-db.service && sudo systemctl enable --now man-db.service
  systemctl enable man-db.service
  systemctl enable man-db.timer
# systemctl start man-db.timer
# systemctl status man-db.timer
# Отключаем переодическое увеличение загрузки из-за man-db.service.
# systemctl disable man-db.service
# systemctl disable man-db.timer
  echo " Запуск сервиса Man-db.timer успешно выполнен "
fi
######## Справка ########
# Для проверки устройства можно использовать systemctl и cat подкоманду:
# systemctl cat man-db.timer
##########################

clear
echo -e "${MAGENTA}
  <<< Запустить Pkgfile (pkgfile-update.timer)(синхронизировать базу данных pkgfile) >>> ${NC}"
echo ""
echo -e "${GREEN}==> ${NC}Pkgfile — это инструмент для поиска файлов в пакетах из официальных репозиториев. Он поставляется вместе со службой systemd и таймером для автоматической синхронизации базы данных. Проводник метаданных pacman .files "
echo -e "${BLUE}:: ${NC}Для запуска автоматического обновления включите таймер pkgfile-update.timer. По умолчанию база данных обновляется ежедневно. Чтобы изменить график обновлений, отредактируйте файл юнита. pkgfile отвечает на вопросы «какой пакет владеет этим файлом?» или «каковы файлы содержимого этого пакета?», даже если пакет не установлен. pkgfile предназначен для пользователей Arch Linux и зависит от баз .filesданных, обслуживаемых зеркалами пакетов. "
echo -e "${CYAN}:: ${NC}pkgfile отличается от функциональности pacman -F тем, что он более гибок (предлагает больше способов фильтрации поиска), имеет более удобный вывод для машинного использования и, как правило, работает намного быстрее (обычно на порядок быстрее при чтении из кэша страниц). "
echo -e "${CYAN}:: ${NC}Чтобы синхронизировать базу данных pkgfile, выполните команду: pkgfile -u  "
echo " Пример - Найти пакет, которому принадлежит файл makepkg: pkgfile makepkg . Чтобы вывести список всех файлов, предоставленных archlinux-keyring: pkgfile -l archlinux-keyring . "
echo -e "${CYAN}:: ${NC}По умолчанию pkgfile будет обновляться ежедневно. Чтобы изменить это расписание, отредактируйте файл unit . (https://wiki.archlinux.org/title/Systemd#Editing_provided_units) "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Запустить сервис pkgfile-update.timer,     0 - Пропустить : " i_pkgfile  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_pkgfile" =~ [^10] ]]
do
    :
done
if [[ $i_pkgfile == 0 ]]; then
  echo ""
  echo " Запуск сервиса pkgfile-update.timer пропущен "
elif [[ $i_pkgfile == 1 ]]; then
  echo ""
  echo " Запуск сервиса pkgfile-update.timer по умолчанию "
  pacman -Syy  # обновление баз пакмэна (pacman)
  pacman -S --noconfirm --needed archlinux-keyring  #  Брелок для ключей Arch Linux PGP ; https://git.archlinux.org/archlinux-keyring.git/ (для hkps://hkps.pool.sks-keyservers.net)
  pacman -S --noconfirm --needed pkgfile  # Проводник метаданных pacman .files ; https://github.com/falconindy/pkgfile ; https://archlinux.org/packages/extra/x86_64/pkgfile/
# pkgfile -u
  pkgfile --update  # синхронизировать базу данных pkgfile
  systemctl enable pkgfile-update.timer
# systemctl start pkgfile-update.timer
# systemctl status pkgfile-update.timer
  echo " Запуск сервиса pkgfile-update.timer успешно выполнен "
fi
###############

clear
echo -e "${MAGENTA}
  <<< Установить Ldmtool и запустить (ldmtool.service)(для управления динамическими дисками Microsoft Windows) >>> ${NC}"
echo ""
echo -e "${GREEN}==> ${NC}Ldmtool — это инструмент и библиотека для управления динамическими дисками Microsoft Windows, использующий LDM от Microsoft — Arch manual pages (https://wiki.archlinux.org/title/Dynamic_disks). "
echo -e "${BLUE}:: ${NC}Он может их проверять, а также создавать и удалять блочные устройства device-mapper который можно монтировать. Хотя файловую систему можно монтировать для чтения и записи, а ее содержимое можно изменять, ldmtool не может изменять метаданные LDM. То есть, он не может создавать, удалять или редактировать динамические диски. "
echo -e "${CYAN}:: ${NC}Он также не может монтировать тома RAID5, в которых отсутствует раздел, хотя и может монтировать зеркальные тома с отсутствующим разделом. Однако монтирование тома с отсутствующим раздел не рекомендуется, так как ldmtool никак не обновляет метаданные LDM. Это означает, что Windows не сможет определить, что разделы не синхронизированы, когда впоследствии он был смонтирован, что может привести к коррупции. "
echo -e "${CYAN}:: ${NC}Важно!!! в скрипте установки присутствуют два варианта утилиты: 1. libldm - Инструмент и библиотека для управления динамическими дисками Microsoft Windows; из стандартного репозитория archlinux - (https://archlinux.org/packages/extra/x86_64/libldm/) и 2. ldmtool - Инструмент для управления динамическими дисками Microsoft Windows, которая !(Конфликтует с libldm)! Устанавливается ldmtool из 'AUR'-'yay' - скачивается с сайта (https://aur.archlinux.org/ldmtool.git), собирается и устанавливается. Будьте внимательны! "
echo " Чтобы динамические диски работали как файловые системы, изначально поддерживаемые ядром Linux, включите ldmtool.service . "
echo -e "${CYAN}:: ${NC}После завершения настройки вы можете добавлять записи в /etc/fstab с оответствующие динамические тома диска и монтировать их так же, как и любые другие тома. "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить libldm и запустить (ldmtool.service),     2 - Установить ldmtool и запустить (ldmtool.service),

    0 - Пропустить : " i_ldmtool  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_ldmtool" =~ [^120] ]]
do
    :
done
if [[ $i_ldmtool == 0 ]]; then
  echo ""
  echo " Установка Ldmtool и запуск (ldmtool.service) пропущена "
elif [[ $i_ldmtool == 1 ]]; then
  echo ""
  echo " Установим libldm и запустим (ldmtool.service) "
  pacman -Syy  # обновление баз пакмэна (pacman)
  pacman -S --noconfirm --needed libldm  # Инструмент и библиотека для управления динамическими дисками Microsoft Windows ; https://github.com/mdbooth/libldm ; https://archlinux.org/packages/extra/x86_64/libldm/
###########
echo " Пропишем конфигурации в файл (ldmtool.service) в /etc/systemd/system/ "
cat > /etc/systemd/system/ldmtool.service << EOF
[Unit]
Description=Windows Dynamic Disk Mount
Before=local-fs-pre.target
DefaultDependencies=no
[Service]
Type=simple
User=root
ExecStart=/usr/bin/ldmtool create all
[Install]
WantedBy=local-fs-pre.target

EOF
###########
  echo " Просмотрим файл (ldmtool.service) в /etc/systemd/system/ "
  cat /etc/systemd/system/ldmtool.service  # cat читает данные из файла или стандартного ввода и выводит их на экран
  sleep 1
  echo " Запустим сервис (ldmtool.service) "
  systemctl enable ldmtool.service
# systemctl start ldmtool.service
# systemctl status ldmtool.service
echo " Установка libldm и запуск (ldmtool.service) успешно выполнена "
elif [[ $i_ldmtool == 2 ]]; then
  echo ""
  echo " Установим ldmtool и запустим (ldmtool.service) "
  pacman -Syy  # обновление баз пакмэна (pacman)
################
#yay -S ldmtool --noconfirm  # инструмент для управления динамическими дисками Microsoft Windows (Конфликты с libldm) ; https://aur.archlinux.org/ldmtool.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/mdbooth/libldm ; https://aur.archlinux.org/packages/ldmtool
######## ldmtool ############
  cd /home/$username
  git clone https://aur.archlinux.org/ldmtool.git
  chown -R $username:users /home/$username/ldmtool
  chown -R $username:users /home/$username/ldmtool/PKGBUILD
  cd /home/$username/ldmtool
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/ldmtool
###############################
echo " Пропишем конфигурации в файл (ldmtool.service) в /etc/systemd/system/ "
cat > /etc/systemd/system/ldmtool.service << EOF
[Unit]
Description=Windows Dynamic Disk Mount
Before=local-fs-pre.target
DefaultDependencies=no
[Service]
Type=simple
User=root
ExecStart=/usr/bin/ldmtool create all
[Install]
WantedBy=local-fs-pre.target

EOF
###########
  echo " Просмотрим файл (ldmtool.service) в /etc/systemd/system/ "
  cat /etc/systemd/system/ldmtool.service  # cat читает данные из файла или стандартного ввода и выводит их на экран
  sleep 1
  echo " Запустим сервис (ldmtool.service) "
  systemctl enable ldmtool.service
# systemctl start ldmtool.service
# systemctl status ldmtool.service
echo " Установка Ldmtool и запуск (ldmtool.service) успешно выполнена "
fi

clear
echo -e "${MAGENTA}
  <<< Установить systemd-swap:s и запустить (systemd-swap.conf)(для создания гибридного пространства подкачки из разделов подкачки zram) >>> ${NC}"
echo -e "${YELLOW}==> Будьте внимательны! ${NC}ЕСЛИ Вы при разметке диска Создали Swap partiton (linux-swap) - раздел подкачки, То спокойно пропустите установку systemd-swap ."
echo ""
echo -e "${GREEN}==> ${NC}Swap — это процесс перемещения страниц памяти в назначенную часть жёсткого диска, что позволяет освободить место при необходимости. Swap может использоваться для решения проблем с низкой памятью. "
echo -e "${BLUE}:: ${NC}В системе Linux с systemd можно активировать swap с помощью специализированного файла .swap. Ускоряем старые машинки - systemd-swap . systemd-swap — как написано на github-е это скрипт автоматического создания и подключения: zram swap, swap файлы (через loop) устройств, swap. "
echo -e "${CYAN}:: ${NC}Итак Преамбула: zRam — это модуль ядра Linux который включён в стандартную поставку ядра начиная с версии 3.14. Целью данного модуля служит создание блочного устройства в оперативной памяти, но в отличии от tmpfs, данные записываются на него в сжатом виде. Поэтому одно из основных его полезных применений это возможность создание прессующего раздела подкачки в оперативной памяти. Всё это позволяет, хоть и неявно, увеличить размер ОЗУ среднем в 2-3 раза, за счёт незначительной нагрузки ЦП на компрессию и декомпрессию данных. На данный момент zRam поддерживает два вида компрессии: lzo(по умолчании) и lz4(начиная с версии ядра 3.15) !(обратите внимание, что никогда не следует использовать zram и zswap одновременно)!"
echo -e "${CYAN}:: ${NC}Есть несколько вариантов как всё это запилить: вручную — для этого есть интересная статья на хабре, а также описание на kernel.org. с помощью zramswap из Аура — интересующиеся могут посмотреть тему на форуме Арча где об этом говорится. Но мы Рассмотрим третий вариан с помощью: systemd-swap ."
echo " Единственное что хотелось ещё добавить это то что существует такой параметр ядра vm.swappiness отвечающий за то при каком уровне свободной оперативной памяти нужно использовать своп, по умолчанию он равен 60(40% заполнено а 60% свободно). Поменять vm.swappiness можно следующим образом - Создать файл /etc/sysctl.d/99-sysctl.conf и добавим в него строчку: vm.swappiness=70 , но обычно прописываю значение: vm.swappiness = 10 (Небольшая справка в скрипте # закомментирована - Прочитайте!) "
echo -e "${CYAN}:: ${NC}Внимание! Автор (разработчик) - systemd-swap на (https://github.com/) написал: что (Текущее качество кода и частота исправлений низкие). Пользователям следует перейти на systemd/zram-generator, поскольку zram должно быть достаточно в большинстве систем. zram-generator - Генератор единиц Systemd для устройств zram ; https://github.com/systemd/ . Эта утилита есть в стандартном репозитории (https://archlinux.org/packages/extra/x86_64/zram-generator/) ."
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить и запустить systemd-swap,     0 - Пропустить : " i_swap  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_swap" =~ [^10] ]]
do
    :
done
if [[ $i_swap == 0 ]]; then
  echo ""
  echo " Установка и запуск systemd-swap пропущена "
elif [[ $i_swap == 1 ]]; then
  echo ""
  echo " Установка и запуск systemd-swap по умолчанию "
  pacman -Syy  # обновление баз пакмэна (pacman)
#############
#yay -S systemd-swap --noconfirm  #  Скрипт для создания гибридного пространства подкачки из разделов подкачки zram, файлов подкачки и разделов подкачки ; https://aur.archlinux.org/systemd-swap.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/Nefelim4ag/systemd-swap ; https://aur.archlinux.org/packages/systemd-swap
####### systemd-swap ############
  cd /home/$username
  git clone https://aur.archlinux.org/systemd-swap.git
  chown -R $username:users /home/$username/systemd-swap
  chown -R $username:users /home/$username/systemd-swap/PKGBUILD
  cd /home/$username/systemd-swap
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/systemd-swap
#############################
echo " Создать папку swap.conf.d в /etc/systemd/ "
mkdir -p /var/swap /etc/systemd/swap.conf.d
echo " Создать файл myswap.conf в /etc/systemd/swap.conf.d/ "
touch /etc/systemd/swap.conf.d/myswap.conf   # Создать файл myswap.conf в /etc/systemd/swap.conf.d/
echo " Пропишем следующий код в (etc/systemd/swap.conf.d/myswap.conf) "
echo 'swapfc_enabled=1' > /etc/systemd/swap.conf.d/myswap.conf
echo 'swapfc_path=/var/swap/' >> /etc/systemd/swap.conf.d/myswap.conf
echo " Добавляем в автозагрузку (systemd-swap)"
systemctl enable --now systemd-swap  # Пожалуйста, не забудьте включить и начать
#systemctl enable systemd-swap
systemctl start systemd-swap
# systemctl status systemd-swap
# systemd-analyze blame | grep swap
# systemctl status swap.target
  echo " Запуск сервиса pkgfile-update.timer успешно выполнен "
fi
########### Справка ##############
# https://tipoit.kz/linux-managing-swap-devices
# systemd-swap можно настроить в /etc/systemd/swap.conf.
# Дополнительные условия: SwapFC (File Chunked) — обеспечивает динамическое выделение/освобождение файла подкачки.
# Расположение файла
# /etc/systemd/swap.conf
# /usr/lib/systemd/system/systemd-swap.service
# /usr/bin/systemd-swap
####################
# Если учесть что средний параметр сжатия равен 1 к 3, а также оставить некий запас прочности то можно очень приблизительно определить граничные значения:
# — итоговая память ~ RAM*3: vm.swappiness = 90; ZRAM/RAM = 1/1 (при большой нагрузке возможна нестабильность системы)
# — итоговая память ~ RAM*2: vm.swappiness ~ 70; ZRAM/RAM = 1/2
# — итоговая память ~ RAM*1.5: vm.swappiness = 60; ZRAM/RAM = 1/4 или 1/3
######################
# Поменять vm.swappiness можно следующим образом
# Файл настроек sysctl может быть создан в /etc/sysctl.d/99-sysctl.conf
# Создать файл /etc/sysctl.d/99-sysctl.conf и добавим в него строчку:
# vm.swappiness=70
# Подгрузить созданный файл конфигурации:
# sudo sysctl -p /etc/sysctl.d/99-sysctl.conf
# Посмотреть что параметр действительно поменялся можно выполнив команду:
# sudo sysctl -a |grep swappiness
#################################

clear
echo -e "${MAGENTA}
  <<< Установить zRam-Generator (zram-generator)(для обеспечивания простого и быстрого механизма настройки подкачки на /dev/zram*устройствах) >>> ${NC}"
echo -e "${YELLOW}==> Будьте внимательны! ${NC}ЕСЛИ Вы при разметке диска Создали Swap partiton (linux-swap) - раздел подкачки, То спокойно пропустите установку zram-generator ."
echo ""
echo -e "${GREEN}==> ${NC}zRam-Generator (zram-generator) - это генератор обеспечивает простой и быстрый механизм настройки подкачки на /dev/zram*устройствах. (zram — это сжатый файл подкачки в оперативной памяти ; zswap — это сжатый кэш, который располагается перед обычным файлом подкачки). "
echo -e "${BLUE}:: ${NC}Zram — это технология, которая позволяет создать блочное устройство в оперативной памяти, данные на котором при сохранении сжимаются одним из выбранных алгоритмов. Доступно их несколько, в зависимости от версии операционной системы. Например, в последней версии Proxmox — это lzo, lz4, lz4hc, deflate. По умолчанию используется lzo. Вероятно, т.к. он был добавлен в модуль ядра ранее и сохранён в качестве стандартной настройки в целях совместимости. Наиболее оптимальным на данный момент будет выбор в пользу lz4. Он обладает оптимальным соотношением скорости и коэффициента сжатия и очень быстр в распаковке. Кроме того, lz4 доступен практически во всех актуальных дистрибутивах linux. "
echo -e "${CYAN}:: ${NC}Arch Linux использует zram для выделения подкачки при установке с помощью archinstall скрипта/команды. Эта запись в блоге поможет предоставить ссылку на то, как изменить важные параметры, такие как размер. Это идет вразрез с небольшой производительностью, которая тратится на сжатие и распаковку данных. но ZRAM активен по умолчанию даже на Android, так что нетрудно догадаться, как мало мы платим за то, чтобы иметь больше ОЗУ из ничего. "
echo -e "${CYAN}:: ${NC}Чем может быть полезен swap в оперативной памяти: Если в системе стоят обычные диски (не ssd)? это существенно ускорит сброс памяти в раздел подкачки. Для ssd дисков можно таким образом сократить объём записываемых данных на диск и продлить срок службы ssd. "
echo " Тут стоит отметить, нет смысла создавать раздел zram swap больше чем размер памяти умноженный на 2, т.к. ожидаемый коэффициент сжатия у нас 2:1. На практике, если система станет настолько сильно своппить, что займёт удвоенный размер памяти в zram, то, скорее всего, и работать на ней будет уже не возможно, т.к. процесс отправки и извлечения данных из swap станет непрерывным. Не стоит доводить до такого состояния, лучше добавить памяти. Поэтому, мы не рекомендуем создавать zram раздел больше, чем объём физической памяти. "
echo -e "${CYAN}:: ${NC}Чтобы создать устройство подкачки zram, используя zstd половину всей доступной оперативной памяти, установите zram-generator , а затем создайте его /etc/systemd/zram-generator.conf . Поскольку zram ведет себя иначе, чем подкачка диска, мы можем настроить подкачку системы так, чтобы в полной мере использовать преимущества zram ."
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить zRam-Generator,     0 - Пропустить : " i_zramg  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_zramg" =~ [^10] ]]
do
    :
done
if [[ $i_zramg == 0 ]]; then
  echo ""
  echo " Установка zRam-Generator пропущена "
elif [[ $i_zramg == 1 ]]; then
  echo ""
  echo " Установка zRam-Generator по умолчанию "
  pacman -Syy  # обновление баз пакмэна (pacman)
  pacman -S --noconfirm --needed zram-generator  # Генератор единиц Systemd для устройств zram ; https://github.com/systemd/zram-generator ; https://archlinux.org/packages/extra/x86_64/zram-generator/
######### zram-generator-git ########
# yay -S zram-generator-git --noconfirm  # Генератор единиц Systemd для устройств zram ; https://aur.archlinux.org/zram-generator-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/systemd/zram-generator ; https://aur.archlinux.org/packages/zram-generator-git
echo " Создать файл zram-generator.conf в /etc/systemd/ "
touch /etc/systemd/zram-generator.conf   # Создать файл zram-generator.conf в /etc/systemd/
echo " Пропишем конфигурации в файл (zram-generator.conf) в /etc/systemd/ "
cat > /etc/systemd/zram-generator.conf << EOF
# This file is part of the zram-generator project
# https://github.com/systemd/zram-generator

[zram0]
# This section describes the settings for /dev/zram0.
#
# The maximum amount of memory (in MiB). If the machine has more RAM
# than this, zram device will not be created.
#
# "host-memory-limit = none" may be used to disable this limit. This
# is also the default.
# host-memory-limit = 9048
host-memory-limit = none

# The size of the zram device, as a function of MemTotal, both in MB.
# For example, if the machine has 1 GiB, and zram-size=ram/4,
# then the zram device will have 256 MiB.
# Fractions in the range 0.1–0.5 are recommended.
#
# The default is "min(ram / 2, 4096)".
# zram-size = min(ram / 10, 2048)
zram-size =  ram / 2

# The compression algorithm to use for the zram device,
# or leave unspecified to keep the kernel default.
# compression-algorithm = zst
# compression-algorithm = zstd
compression-algorithm = lzo-rle

# By default, file systems and swap areas are trimmed on-the-go
# by setting "discard".
# Setting this to the empty string clears the option.
#options =

# Write incompressible pages to this device,
# as there's no gain from keeping them in RAM
writeback-device = /dev/zvol/tarta-zoot/swap-writeback

# The following options are deprecated, and override zram-size.
# These values would be equivalent to the zram-size setting above.
zram-fraction = 0.5
max-zram-size = 4000
# zram-fraction = 0.10
# max-zram-size = 2048
# zram-fraction = 1.0
# max-zram-size = 8192

#[zram1]
# This section describes the settings for /dev/zram1.
#
# host-memory-limit is not specified, so this device will always be created.

# Size the device to a tenth of RAM.
# zram-size = ram / 10

# The file system to put on the device. If not specified, ext2 will be used.
# fs-type = ext2

# Where to mount the file system. If a mount point is not specified,
# the device will be initialized, but will not be used for anything.
# mount-point = /run/compressed-mount-point
# mount-point = /var/compressed


EOF
###########
#[zram0]
#zram-size = ram / 2
#compression-algorithm = lzo-rle
###############
#[zram0]
#compression-algorithm = zstd
#zram-fraction = 0.5
#max-zram-size = 8192
################
### !!! Заработало. Итак, если кто-то наткнется на эту тему, то надо создать файл /etc/systemd/zram-generator.conf или любой другой, который читает zram-generator и в него прописать
#[zram0]
#zram-fraction = 1.0
#max-zram-size = 8192
######################
# /etc/systemd/zram-generator.conf
#[zram1]
#mount-point = /var/compressed
#options = X-mount.mode=1777
###################
### Для приведенного выше примера создайте переопределение для systemd-zram-setup@zram1.service
# systemctl edit
# ExecStartPost=/bin/sh -c 'd=$(mktemp -d); mount "$1" "$d"; chmod 1777 "$d"; umount "$d"; rmdir "$d"' _ /dev/%i
#####################
  echo " Просмотрим файл (zram-generator.conf) в /etc/systemd/ "
  cat /etc/systemd/zram-generator.conf  # cat читает данные из файла или стандартного ввода и выводит их на экран
  sleep 1
  echo " Оптимизация подкачки на zram "
  echo " Поскольку zram ведет себя иначе, чем подкачка диска, мы можем настроить подкачку системы так, чтобы в полной мере использовать преимущества zram "
  echo " Создать файл 99-vm-zram-parameters.conf в /etc/sysctl.d/ "
  touch /etc/sysctl.d/99-vm-zram-parameters.conf   # Создать файл 99-vm-zram-parameters.conf в /etc/sysctl.d/
  echo " Пропишем конфигурации в файл (99-vm-zram-parameters.conf) в /etc/sysctl.d/ "
  cat > /etc/sysctl.d/99-vm-zram-parameters.conf << EOF
vm.swappiness = 180
vm.watermark_boost_factor = 0
vm.watermark_scale_factor = 125
vm.page-cluster = 0
EOF
###########
  echo " Просмотрим файл (99-vm-zram-parameters.conf) в /etc/sysctl.d/ "
  cat /etc/sysctl.d/99-vm-zram-parameters.conf  # cat читает данные из файла или стандартного ввода и выводит их на экран
  sleep 1
  echo " Запустим сервис (zram-generator) "
  systemctl daemon-reload
  systemctl start /dev/zram0
# systemctl start systemd-zram-setup@zram0
# systemctl status /dev/zram0
#zramctl
  echo " Запуск zRam-Generator успешно выполнен "
fi
############# Справка ################
### Использованные источники:
# zram - Arch Wiki https://wiki.archlinux.org/title/Zram
# zram-генератор (GitHub) https://github.com/systemd/zram-generator
# Конфигурация
# Файл конфигурации по умолчанию может находиться в /usr. Этот генератор проверяет следующие местоположения:
# /run/systemd/zram-generator.conf
# /etc/systemd/zram-generator.conf
# /usr/local/lib/systemd/zram-generator.conf
# /usr/lib/systemd/zram-generator.conf
#####################
### Далее рассмотрим настройку zram в качестве swap файла в Proxmox VE. Данным пример должен сработать также в свежих версиях Debian (9, 10) и Ubuntu (начиная с 18-й версии). В данном примере 32G нужно заменить на Ваш размер раздела zram.
# modprobe zram
# zramctl -s 32G -a lz4 /dev/zram0
# mkswap /dev/zram0
# swapon /dev/zram0 -p 10
### Настройка автоматического создания zram swap при старте системы
# echo "zram" > /etc/modules-load.d/zram.conf
# echo 'KERNEL=="zram0", ATTR{disksize}="32G" RUN="/sbin/mkswap /dev/zram0", TAG+="systemd"' > /etc/udev/rules.d/99-zram.rules
# echo "/dev/zram0 none swap defaults,pri=10 0 0" >> /etc/fstab
# Посмотреть статистику использования раздела можно при помощи команды zramctl без параметров:
# zramctl
###############

clear
echo ""
echo -e "${GREEN}=> ${BOLD}Вы хотите просмотреть и отредактировать файл /etc/fstab (отвечающий за монтирование разделов при запуске системы)? ${NC}"
echo " Данные действия помогут исключить возможные ошибки при первом запуске системы! "
echo " 1 - Просмотреть и отредактировать файл /etc/fstab "
echo -e "${MAGENTA}=> ${BOLD}Справка: Файл откроется через редактор <nano>, если нужно отредактировать двигаемся стрелочками вниз-вверх, и правим нужную вам строку. После чего Ctrl-O для сохранения жмём Enter, далее Ctrl-X. Или (Ctrl+X и Y и Enter). ${NC}"
echo " 2 - Просмотреть файл /etc/fstab (БЕЗ редактирования) "
echo -e "${MAGENTA}=> ${BOLD}Справка: Файл откроется с помощью команды cat (это сокращения от слова catenate). Команда cat очень проста - она читает данные из файла или стандартного ввода и выводит их на экран. ${NC}"
echo " 3-(0) - Действия просмотра и редактирования будут пропущены! "
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если ранее при генерации файла fstab просмотрели его содержимое, или не уверены в своих действиях"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  "
    1 - Да редактировать fstab,    2 - *Просмотреть файл fstab,

    0 - Нет пропустить этот шаг: " vm_fstab   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$vm_fstab" =~ [^120] ]]
do
    :
done
if [[ $vm_fstab == 0 ]]; then
  echo ""
  echo " Этап редактирования пропущен "
elif [[ $vm_fstab == 1 ]]; then
  nano /etc/fstab
elif [[ $vm_fstab == 2 ]]; then
  echo ""
  echo " Просмотреть содержимое файла fstab "
  echo ""
  cat /etc/fstab
  sleep 3
fi
#######################

clear
echo ""
echo " Disable man-db - Отключаем переодическое увеличение загрузки из-за man-db.service "
# Отключаем переодическое увеличение загрузки из-за man-db.service.
systemctl disable man-db.service
systemctl disable man-db.timer

echo " Журнал systemd - Уменьшение размера журнала логов Systemd "
# sudo nano /etc/systemd/journald.conf
# SystemMaxUse=50M  # Раскомментировать и изменить строку.
#echo 'SystemMaxUse=50M' >> /etc/systemd/journald.conf
sed -i 's/#SystemMaxUse=/SystemMaxUse=50M/' /etc/systemd/journald.conf  # раскомментируем в /etc/systemd/ строчку journald.conf
echo " Перезапустите сервис systemd-journald.service "
systemctl restart systemd-journald.service

echo " Настройка конфигураций Sudoers для настройки «sudo» "
cat > /etc/sudoers.d/10-defaults << EOF
Defaults env_keep += "EDITOR SYSTEMD_EDITOR"
Defaults timestamp_timeout=30
EOF

clear
echo -e "${MAGENTA}
  <<< Настройка раскладки клавиатуры в X.Org для Archlinux >>> ${NC}"
echo ""
echo -e "${BLUE}:: ${NC}Установить (назначить) раскладку клавиатуры в X.Org (Xorg/Keyboard configuration)?"
echo -e "${MAGENTA}:: ${BOLD}Добавить нужную раскладку клавиатуры можно как средствами оконных менеджеров (где есть такая возможность), так и глобально - в Xorg. Второй вариант более универсален и не привязан к конкретному менеджеру. ${NC}"
echo " Домашняя страница: https://wiki.archlinux.org/title/Xorg/Keyboard_configuration . "
echo -e "${MAGENTA}:: ${BOLD}Сервер Xorg использует клавиатурное расширение X (XKB) для определения раскладок клавиатуры. Опционально, xmodmap можно использовать для прямого доступа к внутренней раскладки клавиатуры, хотя это не рекомендуется для сложных задач. Также можно использовать localectl systemd для определения раскладки клавиатуры в сервере Xorg и виртуальной консоли. ${NC}"
echo " Итак в сценарии (скрипта) прописано 2 варианта: 1(ый)- set-x11-keymap раскладка [модель [вариант [опции]]] (set-x11-keymap us,ru pc105 "" grp:alt_shift_toggle) . 2(ой)- set-x11-keymap раскладка [модель [вариант [опции]]] (set-x11-keymap us,ru pc104 "" grp:alt_shift_toggle), если вас не устраивают предложенные Варианты опций - Пропустите Настройку! Прочтите Справку по Вариантам опций - она прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *(set-x11-keymap us,ru pc105 "" grp:alt_shift_toggle),   2 - (set-x11-keymap us,ru pc104 "" grp:alt_shift_toggle),

    0 - НЕТ - Пропустить установку: " in_keymapmodels  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_keymapmodels" =~ [^120] ]]
do
    :
done
if [[ $in_keymapmodels == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_keymapmodels == 1 ]]; then
  echo ""
  echo " Настройка раскладки клавиатуры в X.Org "
echo " Изменяем раскладку клавиатуры в X.Org "
echo " localectl [--no-convert] set-x11-keymap раскладка [модель [вариант [опции]]] "
# localectl --no-convert set-x11-keymap us,ru pc105 "" grp:alt_shift_toggle
# echo " Чтобы изменения вступили в силу, перезагрузите Xorg командой: "
# systemctl restart display-manager
#############
echo " Создать файл 00-keyboard.conf в /etc/X11/xorg.conf.d/ "
touch /etc/X11/xorg.conf.d/00-keyboard.conf   # Создать файл в /etc/X11/xorg.conf.d/00-keyboard.conf
cat > /etc/X11/xorg.conf.d/00-keyboard.conf <<EOF
# Written by systemd-localed(8), read by systemd-localed and Xorg. It's
# probably wise not to edit this file manually. Use localectl(1) to
# instruct systemd-localed to update it.
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "us,ru"
        Option "XkbModel" "pc105"
        Option "XkbOptions" "grp:alt_shift_toggle"
EndSection
EOF
###########
cat /etc/X11/xorg.conf.d/00-keyboard.conf
sleep 3
echo ""
echo " Настройка раскладки клавиатуры в X.Org выполнена "
elif [[ $in_keymapmodels == 2 ]]; then
  echo ""
  echo " Настройка раскладки клавиатуры в X.Org "
echo " Изменяем раскладку клавиатуры в X.Org "
echo " localectl [--no-convert] set-x11-keymap раскладка [модель [вариант [опции]]] "
# localectl --no-convert set-x11-keymap us,ru pc104 "" grp:alt_shift_toggle
# echo " Чтобы изменения вступили в силу, перезагрузите Xorg командой: "
# systemctl restart display-manager
#################
echo " Создать файл 00-keyboard.conf в /etc/X11/xorg.conf.d/ "
touch /etc/X11/xorg.conf.d/00-keyboard.conf   # Создать файл в /etc/X11/xorg.conf.d/00-keyboard.conf
cat > /etc/X11/xorg.conf.d/00-keyboard.conf <<EOF
# Written by systemd-localed(8), read by systemd-localed and Xorg. It's
# probably wise not to edit this file manually. Use localectl(1) to
# instruct systemd-localed to update it.
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "us,ru"
        Option "XkbModel" "pc104"
        Option "XkbOptions" "grp:alt_shift_toggle"
EndSection
EOF
#########
cat /etc/X11/xorg.conf.d/00-keyboard.conf
sleep 3
echo ""
echo " Настройка раскладки клавиатуры в X.Org выполнена "
fi
########## Справка ##############
# localectl  # Вы можете отобразить текущие настройки локали (localectl без параметров)
# localectl status  # В качестве альтернативы вы можете указать status в качестве аргумента, чтобы достичь тех же результатов.
# localectl list-locales  # Перед изменением настроек локали следует перечислить доступные настройки
# localectl list-keymaps  # просмотреть список доступных сопоставлений клавиш
# sudo localectl set-locale LANG=en_US.UTF-8  # Пример настройки локального варианта на американский английский
# sudo localectl set-keymap us  # Пример настройки раскладки клавиатуры на США
# Просмотреть список доступных сочетаний клавиш для смены раскладки можно с помощью команды:
# В новых версиях systemd есть команда
# localectl list-x11-keymap-options
# А еще есть
# localectl list-x11-keymap-models
# localectl list-x11-keymap-layouts
# localectl list-x11-keymap-variants
# EndSection … terminate:ctrl_alt_bksp - комбинация "Ctrl+Alt+Backspace" для останова xorg.
# Варианты опций:
# В приведённых выше примерах показано несколько вариантов опций раскладок\комбинаций\индикаторов. Вообще же опций достаточно много и комбинируя их можно получить нужный результат.
# Комбинации переключения раскладок:
# grp:toggle – правый Alt
# grp:shift_toggle – две клавиши Shift
# grp:ctrl_shift_toggle – Control+Shift
# grp:alt_shift_toggle – Alt+Shift
# grp:ctrl_alt_toggle – Control+Alt
# grp:lwin_toggle – левая клавиша “Win”
# grp:rwin_toggle – правая “Win”
# grp:lctrl_toggle – левая клавиша Control
# grp:rctrl_toggle – правая клавиша Control
# grp:menu_toggle – клавиша “Контекстное меню”
# grp:caps_toggle – CapsLock
# Кнопка временного переключения раскладки:
# grp:switch – правый Alt
# grp:lwin_switch – левая Win
# grp:rwin_switch – правая Win
# grp:win_switch – любая Win
# Индикаторы:
# grp_led:caps – индикатор Caps Lock
# grp_led:num – индикатор Num Lock
# grp_led:scroll – индикатор Scroll Lock
###################

clear
echo -e "${MAGENTA}
  <<< Установка Num-Lock (numlockx)(для автоматического включения Num-Lock при старте иксов) >>> ${NC}"
echo ""
echo -e "${BLUE}:: ${NC}Установить Num-Lock enable on X (будет автоматически включать Num-Lock при старте иксов)?"
echo -e "${MAGENTA}:: ${BOLD}Цифровая клавиатура, также известная как Numeric Keypad (NumPad), содержит специальные цифровые клавиши, расположенные в правой части стандартной клавиатуры. Это удобное устройство, которое позволяет быстро и эффективно вводить числа и выполнить различные математические операции. ${NC}"
echo " Домашняя страница: https://github.com/rg3/numlockx ; (https://archlinux.org/packages/extra/x86_64/numlockx/). "
echo -e "${MAGENTA}:: ${BOLD}Однако для использования цифровой клавиатуры иногда требуется ее активация. Для этого используется клавиша, называемая «Num Lock» или «NumLk». С помощью этой клавиши можно включить или выключить функцию цифровой клавиатуры, в зависимости от ваших потребностей. ${NC}"
echo " Примечание: Для активации или деактивации клавиши «Num Lock» обычно используется сочетание клавиш «Fn + NumLk» на ноутбуках или просто «NumLk» на стационарных компьютерах. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - Нет пропустить этот шаг: " i_numlockx  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_numlockx" =~ [^10] ]]
do
    :
done
if [[ $i_numlockx == 0 ]]; then
  echo ""
  echo " Установка утилит пропущено "
elif [[ $i_numlockx == 1 ]]; then
echo " Установка NumLockx (Включает клавишу numlock в X11) "
pacman -Syy  # обновление баз пакмэна (pacman)
pacman -S --noconfirm --needed numlockx  # Включает клавишу numlock в X11 ; https://github.com/rg3/numlockx ; https://archlinux.org/packages/extra/x86_64/numlockx/
### Добавить строку: numlockx & в ~/.xinitrc
# echo 'numlockx &' > ~/.xinitrc
# vim ~/.xinitrc
# echo numlockx & >> .xinitrc
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить и запустить systemd-numlockontty (активирует цифровую клавиатуру на ttys)?"
echo -e "${MAGENTA}:: ${BOLD}Включите клавишу Num Lock при загрузке - Большинство клавиатур имеют клавишу Num Lock, которая управляет переключением малой клавиатуры. Пользователи могут захотеть включить Num Lock при запуске системы. ${NC}"
echo " Системная служба + скрипт, автоматически активирует цифровую клавиатуру на ttys "
echo " ttyS - последовательные терминальные линии ; ttyS[0-3] — это символьные устройства для последовательных терминальных линий. Уже существуют различные методы автоматического включения NumLockв графических сеансах, но лично мне удобно также автоматически включать его в ttyсеансах, и, возможно, вам тоже. "
echo " Примечание: Если у вас есть journald или другой системный регистратор, напрямую зеркалирующий свой вывод в tty12— что должно быть по умолчанию в настоящее время — то ваш NumLockне будет включен в tty12. В любом случае в этом нет смысла, потому что tty12 это не интерактивная консоль. "
echo -e "${CYAN}:: ${NC} Вам нужен пакет из AUR , называемый systemd-numlockontty. Как и большинство пакетов программного обеспечения, доступных через AUR, этот пакет поставляется только в виде исходного кода, который будет встроен в двоичный код на вашей локальной системе с помощью makepkg и PKGBUILD скрипта! "
echo " Для тех, кто предпочитает другой помощник AUR, чем yay, например trizen или picaur, вы, конечно, можете заменить yay в приведенной выше команде на trizen, picaur, или любой другой помощник AUR, который вы предпочитаете. И если вы используете любой из них, то вы уже знаете это. "
echo " В любом случае, как только пакет будет собран и установлен, вы можете сразу же включить его в работающем экземпляре и запускать его при каждой следующей загрузке, все за один раз, вот так... "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - Нет пропустить этот шаг: " i_numlockontty  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_numlockontty" =~ [^10] ]]
do
    :
done
if [[ $i_numlockontty == 0 ]]; then
  echo ""
  echo " Установка утилит пропущено "
elif [[ $i_numlockontty == 1 ]]; then
echo " Установка и запуск systemd-numlockontty (активирует цифровую клавиатуру на ttys) "
# yay -S systemd-numlockontty --noconfirm # Системная служба + скрипт, автоматически активирует цифровую клавиатуру на ttys ; https://aur.archlinux.org/systemd-numlockontty.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/Ybalrid/systemd-numlockontty ; https://aur.archlinux.org/packages/systemd-numlockontty
# yay -Rns systemd-numlockontty
# git clone https://aur.archlinux.org/systemd-numlockontty.git ~/systemd-numlockontty
####### systemd-numlockontty ############
  cd /home/$username
  git clone https://aur.archlinux.org/systemd-numlockontty.git
  chown -R $username:users /home/$username/systemd-numlockontty
  chown -R $username:users /home/$username/systemd-numlockontty/PKGBUILD
  cd /home/$username/systemd-numlockontty
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/systemd-numlockontty
#############################
echo " Запустить службу numLockOnTty.service "
# systemctl enable numLockOnTty
systemctl enable numLockOnTty.service
#systemctl enable --now systemd-numLockOnTty.service
fi
######################
### numlockOnTty
# #!/bin/bash
#
# for tty in /dev/tty{1..6}
# do
#    /usr/bin/setleds -D +num < "$tty";
# done
### numlockOnTty.service
# [Unit]
# Description=numlock
#
# [Service]
# ExecStart=/usr/bin/numlockOnTty
# StandardInput=tty
# RemainAfterExit=yes
#
# [Install]
# WantedBy=multi-user.target
################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить CKBComp (ckbcomp) - Компилятор раскладки клавиатуры (XKB в раскладку клавиатуры консоли)?"
echo -e "${MAGENTA}:: ${BOLD}Компилятор раскладки клавиатуры ckbcomp преобразует описание раскладки клавиатуры XKB в раскладку клавиатуры консоли, которую можно напрямую прочитать с помощью loadkeys или kbdcontrol . На своем стандартном выходе ckbcomp выводит сгенерированное определение клавиатуры. Самое важное различие между аргументами setxkbmap и аргументами ckbcomp — это дополнительный параметр -charmap , когда требуется не-Unicode-раскладка клавиатуры. ${NC}"
echo " Домашняя страница: https://manpages.org/ckbcomp ; (https://aur.archlinux.org/packages/ckbcomp). "
echo -e "${MAGENTA}:: ${BOLD}ЧТО ЭТО ТАКОЕ? Этот пакет обеспечивает консоль той же конфигурацией клавиатуры. Схема, которая есть у X Window System. В результате нет необходимости дублировать или изменять файлы клавиатуры консоли, чтобы сделать просто настройки, такие как использование мертвых клавиш, функционирование клавиши как AltGr или клавиша Compose, клавиша(и) для переключения между латиницей и нелатиницей раскладки и т.д. Помимо клавиатуры, пакет также настраивает шрифт на консоли. Он включает в себя богатую коллекцию шрифтов и поддерживает несколько языков, которые в противном случае не поддерживались бы на консоли (например, армянский, грузинский, лаосский и тайский). Пакет поддерживает: ПК, Amiga, Atari, старые Macintosh, клавиатуры Sun4 и Sun5 на Linux. Без -charmap ckbcomp сгенерирует клавиатуру Unicode. ${NC}"
echo " Примечание: Кодировка, используемая для выходной раскладки. Должна быть таблица сопоставления символов, определяющая эту кодировку в /usr/share/consoletrans . Предоставляются определения следующих карт символов: ARMSCII-8 , CP1251 , CP1255 , CP1256 , GEORGIAN-ACADEMY , GEORGIAN-PS , IBM1133 , ISIRI-3342 , ISO-8859-1 , ISO-8859-2 , ISO-8859-3 , ISO-8859-4 , ISO-8859-5 , ISO-8859-6 , ISO-8859-7 , ISO-8859-8 , ISO-8859-9 , ISO-8859-10 , ISO-8859-11 , ISO- 8859-13 , ISO-8859-14 , ISO-8859-15 , ISO-8859-16 , KOI8-R , KOI8-U , TIS-620 и VISCII .  "
echo -e "${CYAN}:: ${NC}Вам нужен пакет из AUR , называемый ckbcomp. Как и большинство пакетов программного обеспечения, доступных через AUR, этот пакет поставляется только в виде исходного кода, который будет встроен в двоичный код на вашей локальной системе с помощью makepkg и PKGBUILD скрипта. Настройка консоли https://manpages.org/ckbcomp "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - Нет пропустить этот шаг: " i_ckbcomp  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_ckbcomp" =~ [^10] ]]
do
    :
done
if [[ $i_ckbcomp == 0 ]]; then
  echo ""
  echo " Установка утилит пропущено "
elif [[ $i_ckbcomp == 1 ]]; then
echo " Установка CKBComp (ckbcomp) "
# yay -S ckbcomp --noconfirm  # Скомпилируйте описание клавиатуры XKB в раскладку, подходящую для loadkeys или kbdcontrol ; https://aur.archlinux.org/ckbcomp.git (только для чтения, нажмите, чтобы скопировать) ; http://anonscm.debian.org/cgit/d-i/console-setup.git/ ; https://aur.archlinux.org/packages/ckbcomp ; https://manpages.org/ckbcomp
# yay -Rns ckbcomp
# git clone https://aur.archlinux.org/ckbcomp.git ~/ckbcomp
####### ckbcomp ############
  cd /home/$username
  git clone https://aur.archlinux.org/ckbcomp.git
  chown -R $username:users /home/$username/ckbcomp
  chown -R $username:users /home/$username/ckbcomp/PKGBUILD
  cd /home/$username/ckbcomp
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/ckbcomp
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
################
### Пожалуйста, используйте исходный код Debian Salsa GitLab, т. е.
# https://salsa.debian.org/installer-team/console-setup/-/archive/$pkgver/console-setup-$pkgver.tar.gz
# Просмотр настроек клавиатуры
# Используйте следующую команду, чтобы просмотреть настройки XKB:
# setxkbmap -print -verbose 10
# СИНОПСИС: ckbcomp [ ПАРАМЕТР ...] [ XKBLAYOUT  [ XKBVARIANT  [ XKBOPTIONS ]...]]
# ФАЙЛЫ:
# /usr/share/consoletrans
# /etc/console-setup/ckb
# /usr/share/X11/xkb
# /etc/X11/xkb
###############################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Powerpill (powerpill) - Оболочка Pacman для более быстрой загрузки в Archlinux?"
echo -e "${MAGENTA}:: ${BOLD}Powerpill — это оболочка Pacman, которая использует параллельную и сегментированную загрузку через Aria2 и Reflector для ускорения загрузки Pacman. Powerpill — это скрипт-обёртка, написанный Xyne для pacman, который ускоряет загрузку пакетов, используя aria2c для параллельных/сегментированных загрузок. Он определяет целевые пакеты запрошенной операции синхронизации, а затем использует список зеркал для создания полного металинка. Этот металинк затем перенаправляется в менеджер загрузок aria2 для загрузки пакетов. Значительное сокращение времени загрузки часто возможно благодаря комбинированному эффекту одновременных и сегментированных загрузок. Powerpill также может использовать Rsync для официальных зеркал, которые его поддерживают. Это может быть эффективно для пользователей, которые уже используют всю полосу пропускания при загрузке с одного зеркала. Powerpill возрождается как полноценная, но поверхностная оболочка Pacman. ${NC}"
echo " Домашняя страница: https://xyne.dev/projects/powerpill ; (https://aur.archlinux.org/packages/powerpill) "
echo -e "${MAGENTA}:: ${BOLD}Пример: пользователь хочет обновиться и выполняет команду pacman -Syu, которая возвращает список из 20 пакетов, доступных для обновления, общим объёмом 200 мегабайт. Если пользователь загружает их через pacman, они будут скачиваться по одному. Если пользователь загружает их через powerpill, они будут скачиваться одновременно, во многих случаях в несколько раз быстрее (в зависимости от скорости соединения, наличия пакетов на серверах, скорости сервера/нагрузки и т. д.). Тестирование pacman и powerpill на одной системе выявило 4-кратное увеличение скорости в приведенном выше сценарии, где средняя скорость загрузки pacman составляла 300 кБ/с, а средняя скорость загрузки powerpill — 1,2 МБ/с.  ${NC}"
echo -e "${YELLOW}:: ${NC}Настройка: Конфигурация - Файл конфигурации Powerpill — это обычный JSON-файл. По умолчанию он находится в папке /etc/powerpill/powerpill.json. Основной объект — это словарь, содержащий несколько словарей. Последние считаются разделами файла конфигурации и содержат параметры, относящиеся к различным частям Powerpill. Подробности см. на странице руководства powerpill.json (https://xyne.dev/projects/powerpill/#powerpill.json1). Официальные репозитории Pacman не предоставляют файлы подписей базы данных. Чтобы избежать ошибок загрузки, установите SigLevel для каждого официального репозитория значение PackageRequired, например: [core] SigLevel = PackageRequired .
  Если вы получаете [err] для файлов <repo>.db.sig: Это происходит потому, что нет файлов подписей для этого репозитория, и вы не установили: SigLevel = PackageRequired в /etc/pacman.conf как описано в этом посте из форума Arch (En) (https://bbs.archlinux.org/viewtopic.php?pid=1254940#p1254940). SigLevel = Required DatabaseOptional . "
echo " Разделы - Обратите внимание, что все поля, включая названия разделов, в файле указаны в нижнем регистре. В процессе автоматического преобразования файла Markdown на странице руководства могут отображаться заглавные буквы. Например, первый раздел — «aria2», а не «ARIA2». Варианты настройки Aria2: Список аргументов, передаваемых исполняемому файлу Aria2. Подробности см. на странице руководства Aria2. По умолчанию Aria2 также загружает $HOME/.aria2/aria2.conf. При запуске с sudo это будет ссылка на домашний каталог пользователя root. Чтобы отключить эту функцию, используйте --no-conf параметр . Чтобы использовать конфигурационный файл Aria2, специфичный для Powerpill, используйте --conf-path параметр , например --conf-path=/etc/powerpill/aria2.conf. Путь к исполняемому файлу Aria2 по умолчанию: /usr/bin/aria2c . "
echo -e "${YELLOW}==> Примечание! ${NC}Обязательно прочтите эти статьи - Powerpill (https://wiki.archlinux.org/title/Powerpill) , PowerPill (https://xyne.dev/projects/powerpill/#powerpill.json1) , Настройка Archlinux Powerpill (https://misctechmusings.com/archlinux-powerpill-setup/) , Настройка pacsrv и powerpill в Arch Linux (https://www.ime.usp.br/~albert/posts/post1/). "
echo -e "${CYAN}:: ${NC}Установка Powerpill (powerpill), проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/powerpill), (https://aur.archlinux.org/powerpill.git) - собирается и устанавливается. "
echo " Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить Powerpill (powerpill),    0 - НЕТ - Пропустить установку: " in_powerpill  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_powerpill" =~ [^10] ]]
do
    :
done
if [[ $in_powerpill == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_powerpill == 1 ]]; then
  echo ""
  echo " Установка Powerpill (powerpill) "
pacman -Syy  # обновление баз пакмэна (pacman)
pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########### Зависимости ############
########### aria2 ############
pacman -S --noconfirm --needed aria2  # Загрузите утилиту, которая поддерживает HTTP(S), FTP, BitTorrent и Metalink ; https://archlinux.org/packages/extra/x86_64/aria2/ ; https://aria2.github.io/ ; 2025-04-30 17:32 UTC
### aria2 — это лёгкая утилита загрузки с командной строки, работающая с несколькими протоколами и источниками . Она поддерживает HTTP/HTTPS , FTP , SFTP , BitTorrent и Metalink . Управлять aria2 можно через встроенные интерфейсы JSON-RPC и XML-RPC .
#pacman -S --noconfirm --needed persepolis  # Интерфейс Qt для менеджера загрузок aria2 ; https://archlinux.org/packages/extra/any/persepolis/ ; https://persepolisdm.github.io/ ; 2025-06-04 21:15 UTC
# yay -S persepolis-git --noconfirm  # Интерфейс Qt для менеджера загрузок aria2 (версия Github) ; https://aur.archlinux.org/persepolis-git.git (только для чтения, нажмите, чтобы скопировать) ; https://persepolisdm.github.io/ ; https://aur.archlinux.org/packages/persepolis-git
### Persepolis — это менеджер загрузок, написанный на Python. Persepolis — пример свободного программного обеспечения с открытым исходным кодом. Он разработан для дистрибутивов GNU/Linux, BSD, macOS и Microsoft Windows. Функции: Многосегментная загрузка ; Планирование загрузок ; Очередь загрузки ; Поиск и загрузка видео с Youtube, Vimeo, DailyMotion, ...
# Запустить программу можно из главного меню вашего дистрибутива или из командной строки, выполнив: persepolis
# Persepolis Download Manager 4.1.0 : https://www.youtube.com/watch?v=QHdMShFgzhQ
#########################
pacman -S --noconfirm --needed pyalpm  # Привязки Python 3 для libalpm ; https://archlinux.org/packages/extra/x86_64/pyalpm/ ; https://gitlab.archlinux.org/archlinux/pyalpm ; 29.05.2025 10:16 UTC
pacman -S --noconfirm --needed python-setuptools  # Простая загрузка, сборка, установка, обновление и удаление пакетов Python ; https://archlinux.org/packages/extra/any/python-setuptools/ ; https://pypi.org/project/setuptools/ ; Обеспечивает: python-distribute ; Заменяет: python-distribute ; 2025-06-01 02:32 UTC
pacman -S --noconfirm --needed rsync  # Быстрый и универсальный инструмент для копирования удаленных и локальных файлов ; https://archlinux.org/packages/extra/x86_64/rsync/ ; https://rsync.samba.org/ ; 2025-02-03 13:57 UTC
pacman -S --noconfirm --needed reflector  # Модуль и скрипт Python 3 для извлечения и фильтрации последнего списка зеркал Pacman ; https://archlinux.org/packages/extra/any/reflector/ ; https://xyne.dev/projects/reflector ; 2024-12-22 13:05 UTC
pacman -S --noconfirm --needed pacman-contrib  # Добавлены скрипты и инструменты для систем pacman ; https://archlinux.org/packages/extra/x86_64/pacman-contrib/ ; https://gitlab.archlinux.org/pacman/pacman-contrib ; 2025-06-10 01:04 UTC
########### python3-xcgf ##############
### python3-xcgf  # Общие общие функции Xyne для внутреннего использования ; https://aur.archlinux.org/packages/python3-xcgf ; https://aur.archlinux.org/python3-xcgf.git (только для чтения, нажмите, чтобы скопировать) ; https://xyne.dev/projects/python3-xcgf ; 2024-05-17 23:45 (UTC)
########### python3-xcgf ##############
  cd /home/$username
  git clone https://aur.archlinux.org/python3-xcgf.git
  chown -R $username:users /home/$username/python3-xcgf
  chown -R $username:users /home/$username/python3-xcgf/PKGBUILD
  cd /home/$username/python3-xcgf
  sudo -u $username  makepkg -si   #--noconfirm
  rm -Rf /home/$username/python3-xcgf
########### python3-xcpf ##############
### python3-xcpf  # Общие функции Pacman от Xyne для внутреннего использования ; https://aur.archlinux.org/packages/python3-xcpf ; https://aur.archlinux.org/python3-xcpf.git (только для чтения, нажмите, чтобы скопировать) ; https://xyne.dev/projects/python3-xcpf ; https://xyne.dev/projects/python3-xcpf/src/python3-xcpf-2021.12.tar.xz ; https://xyne.dev/projects/python3-xcpf/src/python3-xcpf-2021.12.tar.xz.sig ; 2024-05-17 23:45 (UTC)
########### python3-xcpf ##############
  cd /home/$username
  git clone https://aur.archlinux.org/python3-xcpf.git
  chown -R $username:users /home/$username/python3-xcpf
  chown -R $username:users /home/$username/python3-xcpf/PKGBUILD
  cd /home/$username/python3-xcpf
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/python3-xcpf
########### pm2ml ##############
### pm2ml  # Сгенерировать металинки для загрузки пакетов и баз данных Pacman ; https://aur.archlinux.org/packages/pm2ml ; https://aur.archlinux.org/pm2ml.git (только для чтения, нажмите, чтобы скопировать) ; https://xyne.dev/projects/pm2ml ; https://xyne.dev/projects/pm2ml/src/pm2ml-2021.11.20.1.tar.xz ; https://xyne.dev/projects/pm2ml/src/pm2ml-2021.11.20.1.tar.xz.sig ; 2024-05-17 23:43 (UTC)
########### pm2ml ##############
  cd /home/$username
  git clone https://aur.archlinux.org/pm2ml.git
  chown -R $username:users /home/$username/pm2ml
  chown -R $username:users /home/$username/pm2ml/PKGBUILD
  cd /home/$username/pm2ml
  sudo -u $username  makepkg -si --noconfirm
  rm -Rf /home/$username/pm2ml
########### powerpill #############
### powerpill  # Оболочка Pacman для более быстрой загрузки ; https://aur.archlinux.org/packages/powerpill ; https://aur.archlinux.org/powerpill.git (только для чтения, нажмите, чтобы скопировать) ; https://xyne.dev/projects/powerpill ; 2024-05-17 23:43 (UTC) ; https://www.ime.usp.br/~albert/posts/post1/ ;
########### powerpill #############
  cd /home/$username
  git clone https://aur.archlinux.org/powerpill.git
  chown -R $username:users /home/$username/powerpill
  chown -R $username:users /home/$username/powerpill/PKGBUILD
  cd /home/$username/powerpill
  sudo -u $username  makepkg -si --noconfirm
#  sudo -u $username  makepkg -sric --noconfirm
  rm -Rf /home/$username/powerpill
#############
  echo ""
  echo " Обновление системы с помощью Powerpill (powerpill) "
pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
powerpill -Syu  # Чтобы обновить систему (синхронизировать и обновить установленные пакеты) используйте powerpill и опцию -Syu - как вы делаете это с pacman
echo " Установка утилит (пакетов) выполнена "
fi
############

clear
echo ""
echo -e "${BLUE}:: ${NC}Создать резервную копию (дубликат) файла grub.cfg?"
#echo 'Создать резервную копию (дубликат) файла grub.cfg'
# Create a backup (duplicate) of the grub.cfg file
#sudo cp /boot/grub/grub.cfg grub.cfg.backup
echo -e "${CYAN}=> ${NC}Создаваемый дубликат файла grub.cfg будет находиться в директории исходника - путь - /boot/grub/grub.cfg.backup"
echo " В дальнейшем Вы можете удалить файл grub.cfg.backup, от имени суперпользователя (root) без последствий! "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Вы можете пропустить это действие..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да создать (резервную копию),     0 - Нет пропустить этот шаг: " t_grub_cfg  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_grub_cfg" =~ [^10] ]]
do
    :
done
if [[ $t_grub_cfg == 0 ]]; then
echo ""
echo " Создание backup файла grub.cfg пропущено "
elif [[ $t_grub_cfg == 1 ]]; then
  echo ""
  echo " Создание дубликата файла grub.cfg в директории исходника "
cp -vf /boot/grub/grub.cfg /boot/grub/grub.cfg.backup
echo " Создание backup файла grub.cfg выполнено "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Создать резервную копию (дубликат) файла etc/default/grub?"
#echo 'Создать резервную копию (дубликат) файла etc/default/grub'
# Create a backup (duplicate) of the etc/default/grub file
#sudo cp /etc/default/grub grub.backup
echo -e "${CYAN}=> ${NC}Создаваемый дубликат файла grub будет находиться в директории исходника - путь - /etc/default/grub.backup"
echo " В дальнейшем Вы можете удалить файл grub.backup, от имени суперпользователя (root) без последствий! "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Вы можете пропустить это действие..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да создать (резервную копию),     0 - Нет пропустить этот шаг: " x_grub  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_grub" =~ [^10] ]]
do
    :
done
if [[ $x_grub == 0 ]]; then
echo ""
echo " Создание backup файла grub пропущено "
elif [[ $x_grub == 1 ]]; then
  echo ""
  echo " Создание дубликата файла grub в директории исходника "
cp -vf /etc/default/grub /etc/default/grub.backup
echo " Создание backup файла grub выполнено "
fi
sleep 01

clear
echo -e "${CYAN}
  <<< Очистка кэша pacman, и Удаление всех пакетов-сирот (неиспользуемых зависимостей) >>>
${NC}"
echo ""
echo -e "${YELLOW}==> Примечание: ${NC}Если! Вы сейчас устанавливали "AUR Helper"-'yay' вместе с ним установилась зависимость 'go' - (Основные инструменты компилятора для языка программирования Go), который весит 559,0 МБ. Так, что если вам не нужна зависимость 'go', для дальнейшей сборки пакетов в установленной системе СОВЕТУЮ удалить её. В случае, если "AUR"-'yay' НЕ БЫЛ установлен, то пропустить этот шаг."
echo ""
echo -e "${BLUE}:: ${BOLD}Удаление зависимости 'go' после установки "AUR Helper"-'yay'. ${NC}"
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да удалить зависимость 'go',     0 - Нет пропустить этот шаг: " rm_tool  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$rm_tool" =~ [^10] ]]
do
    :
done
if [[ $rm_tool == 0 ]]; then
  echo ""
  echo " Удаление зависимости 'go' пропущено "
elif [[ $rm_tool == 1 ]]; then
# pacman -Rs go
  pacman --noconfirm -Rs go    # --noconfirm  --не спрашивать каких-либо подтверждений
  echo ""
  echo " Удаление зависимость 'go' выполнено "
fi
###
sleep 1
clear
echo ""
echo -e "${BLUE}:: ${BOLD}Очистка кэша pacman 'pacman -Sc' ${NC}"
echo -e "${CYAN}=> ${NC}Очистка кэша неустановленных пакетов (оставив последние версии оных), и репозиториев..."
pacman --noconfirm -Sc  # Очистка кэша неустановленных пакетов (оставив последние версии оных)
###
echo ""
echo -e "${CYAN}=> ${NC}Удалить кэш ВСЕХ установленных пакетов 'pacman -Scc' (высвобождая место на диске)?"
echo " Процесс удаления кэша ВСЕХ установленных пакетов - БЫЛ прописан полностью автоматическим! "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да удалить кэш,     0 - Нет пропустить этот шаг: " rm_cache  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$rm_cache" =~ [^10] ]]
do
    :
done
if [[ $rm_cache == 0 ]]; then
  echo ""
  echo " Удаление кэша ВСЕХ установленных пакетов пропущено "
elif [[ $rm_cache == 1 ]]; then
  pacman --noconfirm -Scc  # Удалит кеш всех пакетов (можно раз в неделю вручную запускать команду)
fi
#######################

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
echo -e "${MAGENTA}==> ${BOLD}Если у Вас беспроводное соединение, запустите nmtui (Network Manager Text User Interface) и подключитесь к сети. ${NC}"
echo -e "${YELLOW}==> ...${NC}"
echo -e "${BLUE}:: ${NC}Если хотите подключить AUR, установить дополнительный софт (пакеты), установить мои конфиги для DE/XFCE, тогда после перезагрузки и входа в систему выполните команду:"
echo -e "${YELLOW}==> ${CYAN}wget git.io/archmy3l && sh archmy3l ${NC}"
echo -e "${CYAN}:: ${NC}Цель скрипта (archmy3l) - это установка первоначально необходимого софта (пакетов) и запуск необходимых служб."
echo -e "${CYAN}:: ${NC}Скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска служб."
echo -e "${GREEN}
  <<< Желаю Вам удачи во всех начинаниях, верных и точных решений! >>> ${NC}"
echo ""
echo -e "${RED}### ${BLUE}########################################################### ${RED}### ${NC}"
echo -e "${RED}==> ${BOLD}Выходим из установленной системы! ${NC}"
echo -e "${BLUE}:: ${BOLD}Теперь вам надо ввести команду exit - пройдёт отмонтирование смонтированных (каталогов), затем следует ввести команду reboot, чтобы перезагрузиться и зайти в установленную систему Arch'a. ${NC}"
exit
exit
# git clone https://github.com/MarcMilany/archmy_2020.git  # Загрузка master ветки
### end of script