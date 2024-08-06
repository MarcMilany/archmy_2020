
#!/bin/bash
apptitle="Arch Linux Fast Install v2.4 LegasyBIOS - Version: 2024.07.31.00.40.38 (GPLv3)"
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
sleep 05
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
echo -e "${MAGENTA}=> ${BOLD}Используйте в названии (host name) только буквы латинского алфавита (a-zA-Z0-9) (можно с заглавной буквы). Латиница - это английские буквы. Кириллица - русские. ${NC}"
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " => Введите имя компьютера: " hostname
# echo -e "${Yellow}Как бы вы хотели назвать этот компьютер?${NoColor}"
# read hostname; clear  # 
echo ""
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
###
echo -e "${BLUE}:: ${NC}Синхронизируем аппаратное время с системным"
echo " Устанавливаются аппаратные часы из системных часов. "
hwclock --systohc  # Эта команда предполагает, что аппаратные часы настроены в формате UTC.
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
  echo ""
  echo " Вы выбрали hwclock --systohc --utc "
  echo " UTC - часы дают универсальное время на нулевом часовом поясе "
elif [[ $hw_clock == 2 ]]; then
  hwclock --systohc --local
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
echo "# 127.0.1.1 $hostname.localdomain $hostname" >> /etc/hosts
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
#echo 'LANG="en_US.UTF-8"' > /etc/locale.conf
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
###
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
echo " Будьте внимательны! Процесс установки Xorg (иксов) не был прописан полностью автоматическим, и было принято решение дать возможность пользователю сделать выбор. В любой ситуации выбор всегда остаётся за вами. "
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
  gui_install="xorg-server xorg-drivers xorg-xinit"  #(или на vmware) # --confirm   всегда спрашивать подтверждение;  X-сервер Xorg (https://xorg.freedesktop.org); Группа драйверов; Программа инициализации X.Org (https://xorg.freedesktop.org)
# gui_install="xorg-drivers --noconfirm"  #  Group Details - https://archlinux.org/groups/x86_64/xorg-drivers/
# gui_install="xf86-input-libinput --noconfirm"  #  Универсальный драйвер ввода для сервера X.Org на основе libinput (http://xorg.freedesktop.org/)
# gui_install="xf86-input-synaptics --noconfirm"  #  Драйвер Synaptics для сенсорных панелей ноутбуков (http://xorg.freedesktop.org/)
elif [[ $vm_setting == 2 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils"  #(или на vmware) # --confirm   всегда
# gui_install="xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils --noconfirm"
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
  pacman -S plasma plasma-meta plasma-pa plasma-desktop kde-system-meta kde-utilities-meta kio-extras kwalletmanager konsole  kwalletmanager --noconfirm  # Мета-пакет для установки KDE Plasma; Апплет Plasma для управления громкостью звука с помощью PulseAudio; Рабочий стол KDE Plasma; Мета-пакет для системных приложений KDE; Мета-пакет для служебных приложений KDE; Дополнительные компоненты для увеличения функциональности KIO; Инструмент управления кошельком; Эмулятор терминала KDE.
# yay -S latte-dock --noconfirm --needed  #  Док на основе Plasma Frameworks ; https://aur.archlinux.org/latte-dock.git (read-only, click to copy) ; https://aur.archlinux.org/latte-dock-git.git (read-only, click to copy) ; https://invent.kde.org/plasma/latte-dock 
# pacman -S kde-applications --noconfirm  # Мета-пакет для приложений KDE (для различных приложений KDE)
# pacman -S gwenview --noconfirm  # Быстрый и простой в использовании просмотрщик изображений (https://apps.kde.org/gwenview/)
# pacman -S plasma-framework --noconfirm  # Библиотека Plasma и компоненты времени выполнения на основе KF5 и Qt5
## pacman -S kde-applications-meta --noconfirm  # Мета-пакет для приложений KDE
### pacman -S --noconfirm --needed alsa-firmware alsa-utils arj ark bluedevil breeze-gtk ccache cups-pdf cups-pk-helper dolphin-plugins e2fsprogs efibootmgr fdkaac ffmpegthumbs firefox git glibc-locales gst-libav gst-plugin-libcamera gst-plugin-msdk gst-plugin-opencv gst-plugin-pipewire gst-plugin-qmlgl gst-plugin-va gst-plugin-wpe gst-plugins-ugly gstreamer-vaapi htop icoutils ipp-usb irqbalance kamera kamoso kate kcalc kde-gtk-config kdegraphics-mobipocket kdegraphics-thumbnailers kdenetwork-filesharing kdeplasma-addons kdesdk-kio kdesdk-thumbnailers kdialog keditbookmarks kget kimageformats kinit kio-admin kio-gdrive kio-zeroconf kompare konsole kscreen kvantum kwrited libappimage libfido2 libktorrent libmms libnfs libva-utils lirc lrzip lua52-socket lzop mac man-db man-pages mesa-demos mesa-utils mold nano-syntax-highlighting nss-mdns ntfs-3g okular opus-tools p7zip packagekit-qt6 pacman-contrib partitionmanager pbzip2 pdfmixtool pigz pipewire-alsa pipewire-pulse plasma-browser-integration plasma-desktop plasma-disks plasma-firewall plasma-nm plasma-pa plasma-wayland-protocols power-profiles-daemon powerdevil powerline powerline-fonts print-manager python-pyqt6 python-reportlab qbittorrent qt6-imageformats qt6-scxml qt6-virtualkeyboard realtime-privileges reflector rng-tools sddm-kcm skanlite sof-firmware sox spectacle sshfs system-config-printer terminus-font timidity++ ttf-ubuntu-font-family unarchiver unrar unzip usb_modeswitch usbutils vdpauinfo vlc vorbis-tools vorbisgain wget xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-kde xsane zip zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting
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
  pacman -S --noconfirm --needed xfce4-notifyd  # Демон уведомлений для рабочего стола Xfce ; https://archlinux.org/packages/extra/x86_64/xfce4-notifyd/
  pacman -S --noconfirm --needed xfce4-screenshooter  # Приложение для создания снимков экрана ; https://docs.xfce.org/apps/xfce4-screenshooter/start ; https://archlinux.org/packages/extra/x86_64/xfce4-screenshooter/
  pacman -S --noconfirm --needed thunar-volman  # Автоматическое управление съемными дисками и носителями для Thunar ; https://docs.xfce.org/xfce/thunar/thunar-volman ; https://archlinux.org/packages/extra/x86_64/thunar-volman/
# pacman -S xdg-user-dirs --noconfirm  # Управляйте пользовательскими каталогами, такими как ~ / Desktop и ~ / Music
## mv /usr/share/xsessions/xfce.desktop ~/
### Если ли надо раскомментируйте нужные вам значения ####
  echo ""
  echo " Установка пакетов поддержки Sound support (alsa, pulseaudio...) "
  pacman -S alsa-utils alsa-plugins alsa-firmware alsa-lib --noconfirm  # Расширенная звуковая архитектура Linux - Утилиты; Дополнительные плагины ALSA; Бинарные файлы прошивки для программ загрузки в alsa-tools и загрузчик прошивок hotplug; Альтернативная реализация поддержки звука Linux
# pacman -S pulseaudio --noconfirm  # Функциональный звуковой сервер общего назначения
# pacman -S pulseaudio-alsa --noconfirm  # Конфигурация ALSA для PulseAudio
  pacman -S pavucontrol --noconfirm  # Регулятор громкости PulseAudio
  pacman -S pulseaudio-bluetooth --noconfirm  # Поддержка Bluetooth для PulseAudio
  pacman -S pulseaudio-equalizer-ladspa --noconfirm  # 15-полосный эквалайзер для PulseAudio
# pacman -S xfce4-pulseaudio-plugin --noconfirm  # Плагин Pulseaudio для панели Xfce4
# pacman -S paprefs --noconfirm  # Диалог конфигурации для PulseAudio (PulseAudio Preferences - https://freedesktop.org/software/pulseaudio/paprefs/)
# systemctl enable bluetooth.service
  echo ""
  echo " Установка пакетов для поддержки работы с архивами (zip ,unzip, unrar...) "
  pacman -Sy --noconfirm --needed zip unzip unrar lha p7zip lrzip  #  Компрессор / архиватор для создания и изменения zip-файлов; Для извлечения и просмотра файлов в архивах .zip; Программа распаковки RAR; Бесплатная программа для архивирования LZH / LHA; Файловый архиватор из командной строки с высокой степенью сжатия; Многопоточное сжатие с помощью rzip / lzma, lzo и zpaq
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
  pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm  # Легкий диспетчер дисплеев; GTK + приветствие для LightDM; Редактор настроек для LightDM GTK + Greeter.
  #pacman -S lightdm-slick-greeter --noconfirm  # Приятный на вид приветственный элемент LightDM ; https://github.com/linuxmint/slick-greeter ; https://archlinux.org/packages/extra/x86_64/lightdm-slick-greeter/
  pacman -S light-locker --noconfirm  # Простой шкафчик сессий для LightDM
  echo " Установка DM (менеджера входа) завершена "
  echo ""
  echo " Подключаем автозагрузку менеджера входа "
# systemctl enable lightdm.service
  systemctl enable lightdm.service -f  # systemctl - специальный инструмент для управления службами в Linux
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
echo -e "${GREEN}==> ${NC}Установить планировщик заданий CRON (cronie) - ЗАПУСК ПРОГРАММ ПО РАСПИСАНИЮ ?"
#echo -e "${BLUE}:: ${NC}Установить планировщик заданий CRON (cronie) - ЗАПУСК ПРОГРАММ ПО РАСПИСАНИЮ ?"
#echo 'Установить планировщик заданий CRON (cronie) - ЗАПУСК ПРОГРАММ ПО РАСПИСАНИЮ ?'
# Install the CRON task scheduler (cron) - RUN programs on a schedule ?
echo -e "${MAGENTA}=> ${BOLD}Cron – это планировщик заданий на основе времени на Unix-подобных операционных системах. Cron даёт возможность пользователям настроить работы по расписанию (команды или шелл-скрипты) для периодичного запуска в определённое время или даты... ${NC}"
echo " Обычно это используется для автоматизации обслуживания системы или администрирования. "
echo -e "${CYAN}:: ${NC}Имеется много реализаций cron, но ни одна из них не установлена по умолчанию: - (cronie, fcron, bcron, dcron, vixie-cron, scron-git), cronie и fcron доступны в стандартном репозитории, а остальные – в AUR."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор остаётся за вами. "
# Be careful! The installation process was fully automatic. In this option, the choice is yours.
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_cron  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_cron" =~ [^10] ]]
do
    :
done
if [[ $i_cron == 0 ]]; then
echo ""
echo " Установка планировщика заданий CRON (cronie) пропущена "
elif [[ $i_cron == 1 ]]; then
  echo ""
  echo " Установка планировщика заданий CRON (cronie) "
#pacman -S cronie --noconfirm
pacman -S --noconfirm --needed cronie  # Демон, который запускает указанные программы в запланированное время и связанные инструменты
echo ""
echo " Добавляем в автозагрузку планировщик заданий (cronie.service) "
systemctl enable cronie.service
#systemctl start cronie.service
# systemctl status cronie.service
echo ""
echo " Планировщик заданий CRON (cronie) установлен и добавлен в автозагрузку "
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
    1 - Да Запустить Systemd-Timesyncd,     0 - НЕТ - Пропустить: " i_timesyncd  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
sleep 3
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
sleep 3
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
  pacman -S --noconfirm --needed dhcpcd  # Клиент DHCP/ IPv4LL/ IPv6RA/ DHCPv6 ; Это также клиент IPv4LL (он же ZeroConf ) ; https://roy.marples.name/projects/dhcpcd/ ; https://archlinux.org/packages/extra/x86_64/dhcpcd/
  pacman -S --noconfirm --needed dhclient  # Автономный DHCP-клиент из пакета DHCP (Dynamic Host Configuration Protocol) ; https://www.isc.org/dhcp/ ; https://archlinux.org/packages/extra/x86_64/dhclient/
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

echo ""
echo -e "${BLUE}:: ${NC}Ставим шрифты"  # https://www.archlinux.org/packages/
pacman -Syy  # обновление баз пакмэна (pacman)
pacman -S --noconfirm --needed ttf-dejavu  # Семейство шрифтов на основе Bitstream Vera Fonts с более широким набором символов
pacman -S --noconfirm --needed ttf-liberation  # Шрифты Red Hats Liberation
pacman -S --noconfirm --needed ttf-anonymous-pro  # Семейство из четырех шрифтов фиксированной ширины, разработанных специально с учетом кодирования
pacman -S --noconfirm --needed terminus-font  # Моноширинный растровый шрифт (для X11 и консоли)
###
echo ""
echo -e "${BLUE}:: ${NC}Автоматическая очистка кэша пакетов "
pacman -S --noconfirm --needed pacman-contrib  # Предоставленные скрипты и инструменты для систем pacman
echo -e "${BLUE}:: ${NC}Подключаем paccache.timer в автозагрузку"
systemctl enable paccache.timer
echo " paccache.timer успешно добавлен в автозагрузку "
###
echo ""
echo -e "${BLUE}:: ${NC}Монтирование разделов NTFS и создание ссылок"
pacman -S --noconfirm --needed fuse2  # Библиотека, позволяющая реализовать файловую систему в пользовательской программе ; https://github.com/libfuse/libfuse ; https://archlinux.org/packages/extra/x86_64/fuse2/
pacman -S --noconfirm --needed dosfstools  # Утилиты файловой системы DOS
pacman -S --noconfirm --needed util-linux  # Различные системные утилиты для Linux ; https://github.com/util-linux/util-linux ; https://archlinux.org/packages/core/x86_64/util-linux/
pacman -S --noconfirm --needed ntfs-3g  # Драйвер и утилиты файловой системы NTFS; "NTFS file support (Windows Drives)" ; https://www.tuxera.com/community/open-source-ntfs-3g/ ; https://archlinux.org/packages/extra/x86_64/ntfs-3g/
### Зайти в Windows и cmd набрать : powercfg -h off
### Чтобы получить возможность беспроблемно записывать данные на раздел из других операционных систем, убедитесь, что функция "быстрый запуск" отключена. Для этого загрузите Windows и выполните следующую команду в командной строке, запущенной от имени администратора: powercfg /h off
### Предоставление полнофункциональной реализации файловой системы exFAT для Unix-подобных систем #####
pacman -S --noconfirm --needed exfat-utils  # Утилиты для файловой системы exFAT ; https://github.com/relan/exfat ; https://archlinux.org/packages/extra/x86_64/exfat-utils/
pacman -S --noconfirm --needed fuse-exfat  # Модуль FUSE - Утилиты для файловой системы exFAT 
echo " Инструменты, который выводит список устройств SCSI / SATA "
pacman -S --noconfirm --needed sg3_utils  # Общие утилиты SCSI ; http://sg.danny.cz/sg/sg3_utils.html ; https://archlinux.org/packages/extra/x86_64/sg3_utils/
### Пакет sg3_utils содержит утилиты, которые отправляют команды SCSI на устройства. Помимо устройств на транспортах, традиционно связанных со SCSI (например, Fibre Channel (FCP), Serial Attached SCSI (SAS) и SCSI Parallel Interface (SPI)) многие другие устройства используют наборы команд SCSI. Примерами устройств, использующих наборы команд SCSI, являются приводы CD/DVD ATAPI и диски SATA, подключаемые через уровень трансляции или мостовое устройство.
pacman -S --noconfirm --needed lsscsi  # Инструмент, который выводит список устройств, подключенных через SCSI / SATA устройств и его транспорты ; http://sg.danny.cz/scsi/lsscsi.html ; https://archlinux.org/packages/extra/x86_64/lsscsi/
### Команда lsscsi выводит информацию об устройствах SCSI в Linux. Используя терминологию SCSI, lsscsi выводит список логических устройств SCSI (или целей SCSI , если указана опция '--transport'). Действие по умолчанию — вывести одну строку вывода для каждого устройства SCSI, подключенного в данный момент к системе.
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Установка базовых программ и пакетов"
echo -e " Установка базовых программ (пакетов): wget, curl, git, cmake, nano-syntax-highlighting "
pacman -S --noconfirm --needed wget git curl  # Сетевая утилита для извлечения файлов из Интернета; Быстрая распределенная система контроля версий.
pacman -S --noconfirm --needed gnupg  # Полная и бесплатная реализация стандарта OpenPGP ; GnuPG позволяет вам шифровать и подписывать ваши данные и сообщения
pacman -S --noconfirm --needed rsync  # Быстрый и универсальный инструмент для копирования удаленных и локальных файлов
pacman -S --noconfirm --needed grsync  # GTK + GUI для rsync для синхронизации папок, файлов и создания резервных копий
pacman -S --noconfirm --needed cmake  # Кросс-платформенная система сборки с открытым исходным кодом
pacman -S --noconfirm --needed extra-cmake-modules  # Дополнительные модули и скрипты для CMake
pacman -S --noconfirm --needed ninja  # Небольшая система сборки с упором на скорость
pacman -S --noconfirm --needed nano nano-syntax-highlighting  # Улучшения подсветки синтаксиса в редакторе Nano (2020.10.10-2)
pacman -S --noconfirm --needed gpart  # Инструмент для спасения / угадывания таблицы разделов
pacman -S --noconfirm --needed bash-completion  # Программируемое завершение для оболочки bash
pacman -S --noconfirm --needed ccache  # Кэш компилятора, который ускоряет перекомпиляцию за счет кеширования предыдущих 
pacman -S --noconfirm --needed squashfs-tools  # Инструменты для squashfs, файловой системы Linux с высокой степенью сжатия, доступной только для чтения
pacman -S --noconfirm --needed hashcat  # Многопоточная расширенная утилита восстановления паролей ; https://hashcat.net/hashcat ; https://archlinux.org/packages/extra/x86_64/hashcat/
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
    1 - AUR - yay (git clone),     2 - AUR - pikaur (git clone),     3 - AUR - yay-bin (git clone),

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
echo -e "${YELLOW}==> Примечание: ${NC}Выберите вариант обновления баз данных пакетов, и системы, в зависимости от установленного вами AUR Helper (yay; pikaur), или пропустите обновления - (если AUR НЕ установлен)."
echo -e "${CYAN}=> ${BOLD}В сценарии скрипта присутствуют следующие варианты: ${NC}"
echo " 1 - Обновление баз данных пакетов, и системы через 'AUR'-'yay', то выбирайте вариант "1" "
echo " 2 - Установка обновлений баз данных пакетов, и системы через 'AUR'-'pikaur', то выбирайте вариант "2" "
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Обновление через - AUR (Yay),     2 - Обновление через - AUR (Pikaur),

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
echo -e "${GREEN}==> ${NC}Установить  менеджер пакетов для Archlinux?"
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
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Pacman gui - (pamac-aur),     2 - Octopi - ранее БЫЛ выбран AUR - (pikaur),

    3 - Octopi - ранее НЕ БЫЛ УСТАНОВЛЕН AUR - (pikaur),

    0 - Пропустить установку: " graphic_aur  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$graphic_aur" =~ [^1230] ]]
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
fi
#######################
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
fi  
### yay -Rns oh-my-zsh-git  # УДАЛЕНИЕ Oh My Zsh!
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
    1 - Создание каталогов с помощью (xdg-user-dirs),

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
###################

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
  echo ""
  echo " Запуск таймер 'TRIM' (fstrim.timer) успешно выполнен "
fi
###################
echo ""
echo " Установим задание cron для ОС, чтобы отправлять команду TRIM один раз в день "
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
    1 - Установить Systemd-UI (systemd-ui),     2 - Установить SystemdGenie (systemdgenie),     

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
###############

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
    1 - Да редактировать fstab,    2 - Просмотреть файл fstab,

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

echo ""
echo " Настройка раскладки клавиатуры в X.Org "
echo " Изменяем раскладку клавиатуры в X.Org "
echo " localectl [--no-convert] set-x11-keymap раскладка [модель [вариант [опции]]] "
# localectl --no-convert set-x11-keymap us,ru pc105 "" grp:alt_shift_toggle
# localectl --no-convert set-x11-keymap us,ru pc104 "" grp:alt_shift_toggle
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
        Option "XkbModel" "pc105+inet"
        Option "XkbOptions" "grp:alt_shift_toggle"
EndSection
EOF
# ИЛИ
# touch /etc/X11/xorg.conf.d/00-keyboard.conf   # Создать файл в /etc/X11/xorg.conf.d/00-keyboard.conf
# cat > /etc/X11/xorg.conf.d/00-keyboard.conf <<EOF
# Section "InputClass"
#        Identifier "system-keyboard"
#        MatchIsKeyboard "on"
#        Option "XkbLayout" "us,ru"
#        Option "XkbModel" "pc104"
#        Option "XkbOptions" "grp:alt_shift_toggle"
# EndSection
# EOF
#############
# localectl  # Вы можете отобразить текущие настройки локали (localectl без параметров)
# localectl status  # В качестве альтернативы вы можете указать status в качестве аргумента, чтобы достичь тех же результатов.
# localectl list-locales  # Перед изменением настроек локали следует перечислить доступные настройки
# localectl list-keymaps  # просмотреть список доступных сопоставлений клавиш
# sudo localectl set-locale LANG=en_US.UTF-8  # Пример настройки локального варианта на американский английский
# sudo localectl set-keymap us  # Пример настройки раскладки клавиатуры на США
cat /etc/X11/xorg.conf.d/00-keyboard.conf
sleep 3

echo " Создать файл .alias_zsh в ~/ (home_user) "
touch $username:users .alias_zsh
# touch ~/.alias_zsh   # Создать файл в ~/.alias_zsh
cat > $username:users .alias_zsh <<EOF
#!/usr/bin/zsh

# cat molot-tora.mp4 eraz.zip > data.mp4
# unzip date.mp4

# git.io custom url
# curl -i https://git.io -F "url=https://github.com/creio" -F "code=YOUR_CUSTOM_NAME"

alias sz="source $HOME/.zshrc"
alias ez="$EDITOR $HOME/.zshrc"
alias ea="$EDITOR $HOME/.alias_zsh"
alias merge="xrdb -merge $HOME/.Xresources"
alias xcolor="xrdb -query | grep"
alias vga="lspci -k | grep -A 2 -E '(VGA|3D)'"
alias upgrub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias updir="LC_ALL=C xdg-user-dirs-update --force"

alias dmrun="dmenu_run -l 10 -p 'app>' -fn 'ClearSansMedium 9' -nb '#282c37' -nf '#f2f3f4' -sb '#5a74ca' -sf '#fff'"

alias iip="curl --max-time 10 -w '\n' http://ident.me"
alias tb="nc termbin.com 9999"
alias tbc="nc termbin.com 9999 | xsel -b -i"
alias speed="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -"

doiso() {
  rsync -auvCL ~/ctlosiso/out/ cretm@${dev_ctlos_ru}:~/app/dev.ctlos.ru/iso/$1
}

# blur img: blur 4 .wall/wl3.jpg blur.jpg
blur() {
  convert -filter Gaussian -blur 0x$1 $2 $3
}

tbg() {
  urxvt -bg '[0]red' -b 0 -depth 32 +sb -name urxvt_bg &
}

# fzf
zzh() {
  du -a ~/ | awk '{print $2}' | fzf | xargs -r $EDITOR
}
zz() {
  du -a . | awk '{print $2}' | fzf | xargs -r $EDITOR
}
zzd() {
  du -a $1 | awk '{print $2}' | fzf | xargs -r $EDITOR
}
zzb() {
  find -H "/usr/bin" "$HOME/.bin" -executable -print | sed -e 's=.*/==g' | fzf | sh
}

# зависимость source-highlight
hcat () {
  /usr/bin/src-hilite-lesspipe.sh "$1" | less -m -N
}
ccat () {
  cat "$1" | xsel -b -i
}

# share vbox В локальной машине mkdir vboxshare
# в виртуалке uid={имя пользователя} git={группа}
vboxshare () {
  [[ ! -d ~/vboxshare ]] && mkdir -p ~/vboxshare
  sudo mount -t vboxsf -o rw,uid=1000,gid=985 vboxshare vboxshare
  # sudo mount -t vboxsf -o rw,uid=st,gid=users vboxshare vboxshare
}
# share qemu
vmshare () {
  [[ ! -d ~/vmshare ]] && mkdir -p ~/vmshare
  sudo mount -t 9p -o trans=virtio,version=9p2000.L host0 vmshare
}

# aur pkg
amake () {
  git clone https://aur.archlinux.org/"$1".git
  # curl -fO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz
  cd $1
  makepkg -s
  # makepkg -s --sign
  cd ..
}

# aur clean chroot manager
accm () {
  git clone https://aur.archlinux.org/"$2".git
  # curl -fO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz
  # tar -xvf $1.tar.gz
  cd $2
  sudo ccm "$1" &&
  gpg --detach-sign "$2"-*.pkg*
  cd ..
}

# pkg clean chroot manager
lccm () {
  sudo ccm "$1" &&
  gpg --detach-sign *.pkg*
}

aget () {
  git clone https://aur.archlinux.org/"$1".git
  # curl -fO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz
  # tar -xvf $1.tar.gz
  cd $1
}

# build and install pkg from aur
abuild () {
  cd ~/.build
  git clone https://aur.archlinux.org/"$1".git
  # curl -fO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz
  # tar -xvf $1.tar.gz
  cd $1
  makepkg -si --skipinteg
  cd ~
  # rm -rf ~/.build/$1 ~/.build/$1.tar.gz
  rm -rf ~/.build/$1
}


alias neofetch="neofetch --ascii ~/.config/neofetch/ctlos"
alias neoa="neofetch --ascii ~/.config/neofetch/mario"
alias neo="neofetch --w3m ~/.config/neofetch/cnr.png"
# alias neo="neofetch --kitty ~/.config/neofetch/cn.jpg"
# alias neo="neofetch --w3m"

# Погода, не только по городу, но и по месту. Нет привязки к регистру и языку.
# alias wtr="curl 'wttr.in/Москва?M&lang=ru'"
# alias wtr="curl 'wttr.in/Москва?M&lang=ru' | sed -n '1,17p'"
# alias wtr="curl 'wttr.in/?M1npQ&lang=ru'"
wtr () {
  # curl "wttr.in/?M$1npQ&lang=ru"
  curl "wttr.in/Moscow?M$1npQ&lang=ru"
}
wts () {
  curl "wttr.in/$1?M&lang=ru"
}
alias moon="curl 'wttr.in/Moon'"

alias srm="sudo rm -rfv"
alias rm="rm -rfv"
brm () {
  /bin/bash -c "yes | rm -rfv $1"{.\*\,\*}
}
sbrm () {
  sudo /bin/bash -c "yes | rm -rfv $1"{.\*\,\*}
}

alias dir="dir --color=auto"
alias vdir="vdir --color=auto"
alias grep="grep --color=always"
#alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

alias ls="ls --color=auto"
alias la="ls -alFh --color=auto"
alias llp="stat -c '%A %a %n' {*,.*}"
alias ll="ls -a --color=auto"
alias l="ls -CF --color=auto"
alias .l="dirs -v"
alias lss="ls -sh | sort -h"
alias duh="du -d 1 -h | sort -h"

alias mk="mkdir"
mkj () {
  mkdir -p "$1"
  cd "$1"
}

alias /="cd /"
alias ~="cd ~"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias q="exit"
alias gh="cd /media/files/github"
alias dot="cd /media/files/github/creio/dots"

function gc () {
  git clone "$1"
}

function gcj () {
  git clone "$1"
  cd "$2"
  # $EDITOR .
}
alias gi="git init"
alias gs="git status"
alias gl="git log --stat --pretty=oneline --graph --date=short"
# alias gg="gitg &"
alias ga="git add --all"
gac () {
  git add --all
  git commit -am "$1"
}
alias gr="git remote"
alias gf="git fetch"
alias gpl="git pull"
alias gp="git push"
alias gpm="git push origin master"
# yarn global add github-search-repos-cli
# alias gsc="github-search-repos -i"

# tor chromium
alias torc="$BROWSER --proxy-server='socks://127.0.0.1:9050' &"
alias psi="$BROWSER --proxy-server='socks://127.0.0.1:1081' &"

# full screen flags -fs
alias yt="straw-viewer"
ytv () {
  straw-viewer "$1"
}

# youtube-dl --ignore-errors -o '~/Видео/youtube/%(playlist)s/%(title)s.%(ext)s' https://www.youtube.com/playlist?list=PL-UzghgfytJQV-JCEtyuttutudMk7
# Загрузка Видео ~/Videos или ~/Видео
# Пример: dlv https://www.youtube.com/watch?v=gBAfejjUQoA
dlv () {
  youtube-dl --ignore-errors -o '~/Videos/youtube/%(title)s.%(ext)s' "$1"
}
# dlp https://www.youtube.com/playlist?list=PL-UzghgfytJQV-JCEtyuttutudMk7
dlp () {
  youtube-dl --ignore-errors -o '~/Videos/youtube/%(playlist)s/%(title)s.%(ext)s' "$1"
}

# Загрузка аудио ~/Music или ~/Музыка
# Пример: mp3 https://www.youtube.com/watch?v=gBAfejjUQoA
mp3 () {
  youtube-dl --ignore-errors -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o '~/Music/youtube/%(title)s.%(ext)s' "$1"
}
# mp3p https://www.youtube.com/watch?v=-F7A24f6gNc&list=RD-F7A24f6gNc
mp3p () {
  youtube-dl --ignore-errors -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o '~/Music/youtube/%(playlist)s/%(title)s.%(ext)s' "$1"
}

alias porn="mpv 'http://www.pornhub.com/random'"

alias mvis="ncmpcpp -S visualizer"
alias m="ncmpcpp"

pf () {
  peerflix "$1" --mpv
}
alias rss="newsboat"
# download web site
wgetw () {
  wget -rkx "$1"
}
iso () {
  sudo dd bs=4M if="$1" of=/dev/"$2" status=progress && sync
}

alias -s {mp3,m4a,flac,mp4,mkv,webm}="mpv"
alias -s {png,jpg,tiff,bmp,gif}="viewnior"
# alias -s {conf,txt}="nvim"
# alias {aurman,pikaur,trizen,yaourt}="yay"

alias mi="micro"
alias smi="sudo micro"
alias s="subl3"
alias ss="sudo subl3"
alias tm="tmux attach || tmux new -s work"
alias tmd="tmux detach"
alias tmk="tmux kill-server"
alias rr="ranger"
alias srr="sudo ranger"
alias h="htop"
# alias {v,vi,vim}="nvim"

# LANG=C pacman -Sl | awk '/\[installed\]$/ {print $2}' > ~/.pkglist.txt
# LANG=C pacman -Sl | awk '/\[installed\]$/ {print $1 "/" $2 "-" $3}' > ~/.pkglist.txt
# alias mirftu='pacman-mirrors --fasttrack 10 && pacman -Syyu'
alias pkglist="pacman -Qneq > ~/.pkglist.txt"
alias aurlist="pacman -Qmeq > ~/.aurlist.txt"

alias packey="sudo pacman-key --init && sudo pacman-key --populate && sudo pacman-key --refresh-keys --keyserver hkps://keyserver.ubuntu.com && sudo pacman -Syy"
alias y="yay -S"
alias yn="yay -S --noconfirm"
alias yl="yay -S --noconfirm --needed - < ~/.pkglist.txt"
alias ys="yay"
alias ysn="yay --noconfirm"
alias yo="yay -S --overwrite='*'"
alias yU="yay -U"
alias yUo="yay -U --overwrite='*'"
alias yc="yay -Sc"
alias ycc="yay -Scc"
alias yy="yay -Syy"
alias yu="yay -Syyu"
alias yun="yay -Syyu --noconfirm"
alias yr="yay -R"
alias yrs="yay -Rs"
alias yrsn="yay -Rsn"
alias yrn="yay -R --noconfirm"
alias ynskip='yay --noconfirm --mflags "--nocheck --skipchecksums --skippgpcheck"'
alias ygpg='yay --noconfirm --gpgflags "--keyserver keys.gnupg.net"'

# alias pres="sudo pacman -S $(pacman -Qqn)"
# alias yrsnp="yay -Rsn $(pacman -Qdtq)"
# alias yal="yay -S --noconfirm --needed $(cat ~/.aurlist.txt)"
# pacman -Qqo /usr/lib/python3.9/



# распаковать архив не указывая тип распаковщика
function ex {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Использование: ex <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f "$1" ] ; then
        NAME=${1%.*}
        #mkdir $NAME && cd $NAME
        case "$1" in
          *.tar.bz2)   tar xvjf ./"$1"    ;;
          *.tar.gz)    tar xvzf ./"$1"    ;;
          *.tar.xz)    tar xvJf ./"$1"    ;;
          *.lzma)      unlzma ./"$1"      ;;
          *.bz2)       bunzip2 ./"$1"     ;;
          *.rar)       unrar x -ad ./"$1" ;;
          *.gz)        gunzip ./"$1"      ;;
          *.tar)       tar xvf ./"$1"     ;;
          *.tbz2)      tar xvjf ./"$1"    ;;
          *.tgz)       tar xvzf ./"$1"    ;;
          *.zip)       unzip ./"$1"       ;;
          *.Z)         uncompress ./"$1"  ;;
          *.7z)        7z x ./"$1"        ;;
          *.xz)        unxz ./"$1"        ;;
          *.exe)       cabextract ./"$1"  ;;
          *)           echo "ex: '$1' - Не может быть распакован" ;;
        esac
    else
        echo "'$1' - не является допустимым файлом"
    fi
fi
}

# Упаковка в архив командой pk 7z /что/мы/пакуем имя_файла.7z
function pk () {
  if [ $1 ] ; then
    case $1 in
      tbz)       tar cjvf $2.tar.bz2 $2      ;;
      tgz)       tar czvf $2.tar.gz  $2       ;;
      txz)       tar -caf $2.tar.xz  $2       ;;
      tar)       tar cpvf $2.tar  $2       ;;
      bz2)       bzip $2 ;;
      gz)        gzip -c -9 -n $2 > $2.gz ;;
      zip)       zip -r $2.zip $2   ;;
      7z)        7z a $2.7z $2    ;;
      *)         echo "'$1' не может быть упакован с помощью pk()" ;;
    esac
  else
    echo "'$1' не является допустимым файлом"
  fi
}

EOF
#########
echo " Сделайте файл .alias_zsh исполняемым "
# sudo chmod a+x ~/.alias_zsh
chmod a+x $username:users .alias_zsh


echo " Переименовываем исходный файл ~/.zshrc в ~/.zshrc.original "
mv $username:users .zshrc  $username:users .zshrc.original 
# mv ~/.zshrc  ~/.zshrc.original   # Переименовываем исходный файл
echo " Создать файл .zshrc в ~/ (home_user) "
touch $username:users .zshrc
# touch ~/.zshrc   # Создать файл в ~/.zshrc
# ln -s -f ~/the/correct/path/zshrc ~/.zshrc
cat > $username:users .zshrc <<EOF
#!/usr/bin/sh

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx &> /dev/null

# zmodload zsh/zprof

export PATH=$HOME/.bin:$HOME/.config/rofi/scripts:$HOME/.local/bin:/usr/local/bin:$PATH

export HISTFILE=~/.zhistory
export HISTSIZE=10000
export SAVEHIST=10000

# autoload -Uz compinit
# for dump in ~/.zcompdump(N.mh+24); do
#   compinit
# done
# compinit -C

# ohmyzsh
export ZSH="/usr/share/oh-my-zsh"
ZSH_THEME="af-magic"
DISABLE_AUTO_UPDATE="true"
ZSH_DISABLE_COMPFIX=true
plugins=()
ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
[[ ! -d $ZSH_CACHE_DIR ]] && mkdir -p $ZSH_CACHE_DIR
source $ZSH/oh-my-zsh.sh
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=white"

# fzf & fd
[[ -e "/usr/share/fzf/fzf-extras.zsh" ]] && source /usr/share/fzf/fzf-extras.zsh
export FZF_DEFAULT_COMMAND="fd --type file --color=always --follow --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_DEFAULT_OPTS="--ansi"
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border --preview 'file {}' --preview-window down:1"
export FZF_COMPLETION_TRIGGER="~~"

# tilix set
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi

export TERM="xterm-256color"
export EDITOR="$([[ -n $DISPLAY && $(command -v subl3) ]] && echo 'subl3' || echo 'nano')"
export BROWSER="firefox"
export XDG_CONFIG_HOME="$HOME/.config"
export _JAVA_AWT_WM_NONREPARENTING=1

# export PF_INFO="ascii os kernel wm shell pkgs memory palette"
# export PF_ASCII="arch"

# export MANPAGER="sh -c 'sed -e s/.\\\\x08//g | bat -l man -p'"

[[ -f ~/.alias_zsh ]] && . ~/.alias_zsh

# export PATH=$HOME/.gem/ruby/2.7.0/bin:$PATH
# export PATH="$PATH:`yarn global bin`"

# export GOPATH=$HOME/.go
# export GOBIN=$GOPATH/bin
# export PATH="$PATH:$GOBIN"

# export PATH=$HOME/opt/diode:$PATH

# zprof

EOF
###############
echo " Сделайте файл .zshrc исполняемым "
# sudo chmod a+x ~/.zshrc
chmod a+x $username:users .zshrc
echo " Для начала сделаем его бэкап  ~/.zshrc "
# cp ~/.zshrc  ~/.zshrc.back
cp $username:users .zshrc  $username:users .zshrc.back 
# echo " Просмотреть содержимое файла ~/.zshrc "
#ls -l ~/.zshrc   # ls — выводит список папок и файлов в текущей директории
#cat ~/.zshrc  # cat читает данные из файла или стандартного ввода и выводит их на экран
#sleep 3
##############
echo " Создать файл .Xresources в ~/ (home_user) "
touch $username:users .Xresources
# touch ~/.Xresources   # Создать файл в ~/.Xresources
cat > $username:users .Xresources <<EOF
Xft.dpi: 96
Xft.antialias: true
Xft.hinting: true
Xft.rgba: rgb
Xft.autohint: false
Xft.hintstyle: hintslight
Xft.lcdfilter: lcddefault

#include ".colors/dui"

!URxvt.font: xft:CozetteVector:size=9
!URxvt.font: xft:Hack Nerd Font Mono:size=9

!!! xlsfonts | grep ttyp0    &&    fc-list : family style
URxvt.font: xft:UW Ttyp0:size=10,xft:Hack Nerd Font Mono:size=9
URxvt.boldFont: xft:UW Ttyp0:size=10,xft:Hack Nerd Font Mono:size=9

!URxvt.termname: xterm-256color
URxvt.iconFile: /usr/share/icons/Papirus/48x48/apps/urxvt.svg
URxvt.geometry: 84x22
URxvt.internalBorder: 15
URxvt.letterSpace: 0
URxvt.antialias: true
URxvt.pointerBlank: true
URxvt.saveLines:    7000
URxvt.scrollBar:    false
URxvt.cursorBlink:  true
URxvt.urgentOnBell: true
URxvt.scrollTtyOutput: true
URxvt.scrollWithBuffer: true
URxvt.scrollTtyKeypress: true
URxvt.transparent:false
URxvt.depth: 32
URxvt.iso14755:        false
URxvt.iso14755_52:     false

URxvt.perl-ext-common: default,matcher,clipboard,keyboard-select,url-select
URxvt.url-launcher: /usr/bin/xdg-open
URxvt.url-select.underline: true
URxvt.matcher.button: 1
URxvt.keysym.C-u: perl:url-select:select_next

URxvt.keysym.C-Escape: perl:keyboard-select:activate
URxvt.keysym.C-/: perl:keyboard-select:search

URxvt.clipboard.autocopy: true
URxvt.keysym.Shift-Control-V: eval:paste_clipboard
URxvt.keysym.Shift-Control-C: eval:selection_to_clipboard

! ctrl + arrows
URxvt.keysym.Control-Up:    \033[1;5A
URxvt.keysym.Control-Down:  \033[1;5B
URxvt.keysym.Control-Left:  \033[1;5D
URxvt.keysym.Control-Right: \033[1;5C

EOF
###############
echo " Сделайте файл .Xresources исполняемым "
# sudo chmod a+x ~/.Xresources
chmod a+x $username:users .Xresources
############

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

### end of script