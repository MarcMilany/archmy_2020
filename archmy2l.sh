
#!/bin/bash
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
ARCHMY2_LANG="russian"  # Installer default language (Язык установки по умолчанию)
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
ping google.com -W 2 -c 1
#ping -c 2 archlinux.org  # Утилита ping - это очень простой инструмент для диагностики сети
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
echo ""
echo -e "${MAGENTA}=> ${BOLD}Используйте в имени (user name) только буквы латинского алфавита (в нижнем (маленькие) регистре (a-z)(a-z0-9_-)), и цифры ${NC}"
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " => Введите имя пользователя: " username
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
timedatectl show
######################
echo ""
echo -e "${BLUE}:: ${NC}Изменяем имя хоста"
echo "127.0.0.1	localhost.(none)" > /etc/hosts
echo "127.0.1.1	$hostname" >> /etc/hosts
echo "::1	localhost ip6-localhost ip6-loopback" >> /etc/hosts
echo "ff02::1 ip6-allnodes" >> /etc/hosts
echo "ff02::2 ip6-allrouters" >> /etc/hosts
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
echo " Производители процессоров выпускают обновления стабильности и безопасности
        для микрокода процессора "
echo " Огласите весь список, пожалуйста! :) "
echo " 1 - Для процессоров AMD установите пакет amd-ucode. "
echo " 2 - Для процессоров Intel установите пакет intel-ucode. "
echo " 3 - Если Arch находится на съемном носителе, Вы должны установить микрокод для обоих производителей процессоров. "
echo " Для Arch Linux на съемном носителе добавьте оба файла initrd в настройки загрузчика. "
echo " Их порядок не имеет значения, если они оба указаны до реального образа initramfs. "
echo -e "${MAGENTA}=> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
echo " Будьте внимательны! Без этих обновлений Вы можете наблюдать ложные падения или неожиданные зависания системы, которые может быть сложно отследить. "
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Для процессоров AMD,    2 - Для процессоров INTEL,

    3 - Для процессоров AMD и INTEL,

    0 - Нет Пропустить этот шаг: " prog_cpu  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
  echo " Загрузчик GRUB установлен на выбранный вами диск (раздел) "
elif [[ $i_grub == 0 ]]; then
  echo ""
  echo " Операция установки загрузчик GRUB пропущена "
fi
###
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
###
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
    1 - Xfce - Xfce воплощает традиционную философию UNIX

    0 - Пропустить установку: " x_de  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_de" =~ [^10] ]]
do
    :
done
if [[ $x_de == 0 ]]; then
  echo ""
  echo " Установка DE (среда рабочего стола) была пропущена "
elif [[ $x_de == 1 ]]; then
  echo ""
  echo " Установка Xfce + Goodies for Xfce "
  pacman -S xfce4 xfce4-goodies --noconfirm  # Нетребовательное к ресурсам окружение рабочего стола для UNIX-подобных операционных систем; Проект Xfce Goodies Project включает дополнительное программное обеспечение и изображения, которые связаны с рабочим столом Xfce , но не являются частью официального выпуска.
  pacman -S xfce4-notifyd --noconfirm  # Демон уведомлений для рабочего стола Xfce ; https://archlinux.org/packages/extra/x86_64/xfce4-notifyd/
# pacman -S xdg-user-dirs --noconfirm  # Управляйте пользовательскими каталогами, такими как ~ / Desktop и ~ / Music
## mv /usr/share/xsessions/xfce.desktop ~/
### Если ли надо раскомментируйте нужные вам значения ####
# echo ""
# echo " Установка пакетов поддержки Sound support (alsa, pulseaudio...) "
# pacman -S alsa-utils alsa-plugins alsa-firmware alsa-lib --noconfirm  # Расширенная звуковая архитектура Linux - Утилиты; Дополнительные плагины ALSA; Бинарные файлы прошивки для программ загрузки в alsa-tools и загрузчик прошивок hotplug; Альтернативная реализация поддержки звука Linux
# pacman -S pulseaudio --noconfirm  # Функциональный звуковой сервер общего назначения
# pacman -S pulseaudio-alsa --noconfirm  # Конфигурация ALSA для PulseAudio
# pacman -S pavucontrol --noconfirm  # Регулятор громкости PulseAudio
# pacman -S pulseaudio-bluetooth --noconfirm  # Поддержка Bluetooth для PulseAudio
# pacman -S pulseaudio-equalizer-ladspa --noconfirm  # 15-полосный эквалайзер для PulseAudio
# pacman -S xfce4-pulseaudio-plugin --noconfirm  # Плагин Pulseaudio для панели Xfce4
# pacman -S paprefs --noconfirm  # Диалог конфигурации для PulseAudio (PulseAudio Preferences - https://freedesktop.org/software/pulseaudio/paprefs/)
# echo ""
# echo " Установка пакетов Поддержки звука выполнена "
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
#clear
echo ""
echo -e "${GREEN}==> ${NC}Ставим пакеты Поддержки звука (alsa, pulseaudio...)?"
#echo -e "${BLUE}:: ${NC}Ставим пакеты Поддержки звука (alsa, pulseaudio...)?"
#echo 'Ставим пакеты Поддержки звука (alsa, pulseaudio...)?'
# Installing sound support packages (alsa, pulseaudio...)?
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (alsa-utils, alsa-plugins, alsa-firmware, alsa-lib, alsa-utils, pulseaudio, pulseaudio-alsa, pavucontrol, pulseaudio-zeroconf, pulseaudio-bluetooth, xfce4-pulseaudio-plugin, projectm-pulseaudio и paprefs)"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_sound  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_sound" =~ [^10] ]]
do
    :
done
if [[ $i_sound == 0 ]]; then
clear
echo ""
echo " Установка поддержки Sound support пропущена "
elif [[ $i_sound == 1 ]]; then
  echo ""
  echo " Установка пакетов поддержки Sound support (alsa, pulseaudio...) "
  pacman -S alsa-utils alsa-plugins alsa-firmware alsa-lib --noconfirm  # Расширенная звуковая архитектура Linux - Утилиты; Дополнительные плагины ALSA; Бинарные файлы прошивки для программ загрузки в alsa-tools и загрузчик прошивок hotplug; Альтернативная реализация поддержки звука Linux
  pacman -S lib32-alsa-plugins --noconfirm  # Дополнительные плагины ALSA (32-бит)
  pacman -S alsa-oss lib32-alsa-oss --noconfirm  # Библиотека совместимости OSS; Библиотека совместимости OSS (32 бит)
#sudo pacman -S alsa-tools --noconfirm  # Расширенные инструменты для определенных звуковых карт
  pacman -S alsa-topology-conf alsa-ucm-conf --noconfirm  # Файлы конфигурации топологии ALSA; Конфигурация (и топологии) ALSA Use Case Manager
  pacman -S alsa-card-profiles --noconfirm  # Профили карт ALSA, общие для PulseAudio
  pacman -S pulseaudio pulseaudio-alsa pavucontrol pulseaudio-bluetooth pulseaudio-equalizer-ladspa --noconfirm
#sudo pacman -S pulseaudio --noconfirm  # Функциональный звуковой сервер общего назначения
#sudo pacman -S pulseaudio-alsa --noconfirm  # Конфигурация ALSA для PulseAudio
#sudo pacman -S pavucontrol --noconfirm  # Регулятор громкости PulseAudio
#sudo pacman -S pulseaudio-bluetooth --noconfirm  # Поддержка Bluetooth для PulseAudio
#sudo pacman -S pulseaudio-equalizer-ladspa --noconfirm  # 15-полосный эквалайзер для PulseAudio (https://github.com/pulseaudio-equalizer-ladspa/equalizer)
### sudo pacman -S pulseaudio-equalizer --noconfirm  # Графический эквалайзер для PulseAudio
  pacman -S pulseaudio-zeroconf --noconfirm  # Поддержка Zeroconf для PulseAudio
#sudo pacman -S pulseaudio-lirc --noconfirm  # Поддержка IR (lirc) для PulseAudio
#sudo pacman -S pulseaudio-jack --noconfirm  # Поддержка разъема для PulseAudio
#sudo pacman -S pasystray --noconfirm  # Системный трей PulseAudio (замена # padevchooser)
  pacman -S xfce4-pulseaudio-plugin --noconfirm  # Плагин Pulseaudio для панели Xfce4
#sudo pacman -Sy pavucontrol pulseaudio-bluetooth alsa-utils pulseaudio-equalizer-ladspa --noconfirm
  pacman -S paprefs --noconfirm  # Диалог конфигурации для PulseAudio (PulseAudio Preferences - https://freedesktop.org/software/pulseaudio/paprefs/)
  pacman -S projectm-pulseaudio --noconfirm  # Музыкальный визуализатор (projectM PulseAudio Visualization), использующий ускоренный трехмерный рендеринг на основе итеративного изображения (pulseaudio) https://github.com/projectM-visualizer/projectm
echo ""
echo " Установка пакетов Поддержки звука выполнена "
fi
sleep 1
######################
clear
echo ""
echo -e "${GREEN}==> ${NC}Установим поддержку Bluetooth?"
#echo -e "${BLUE}:: ${NC}Установим поддержку Bluetooth?"
#echo 'Установим поддержку Bluetooth?'
# Install Bluetooth support?
echo -e "${CYAN}=> ${BOLD}Установка поддержки Bluetooth и Sound support (звука) - будет очень актуальна, если Вы установили DE (среда рабочего стола) XFCE. ${NC}"
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (bluez, bluez-libs, bluez-cups, bluez-utils)."
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_bluetooth  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_bluetooth" =~ [^10] ]]
do
    :
done
if [[ $i_bluetooth == 0 ]]; then
echo ""
echo " Установка поддержки Bluetooth пропущена "
elif [[ $i_bluetooth == 1 ]]; then
  echo ""
  echo " Установка пакетов поддержки Bluetooth "
  pacman -S bluez bluez-libs bluez-cups bluez-utils --noconfirm  # Демоны для стека протоколов Bluetooth; Устаревшие библиотеки для стека протоколов Bluetooth; Серверная часть CUPS для принтеров Bluetooth; Утилиты разработки и отладки для стека протоколов bluetooth.
#sudo pacman -S bluez-hid2hci --noconfirm  # Перевести HID проксирование bluetooth HCI в режим HCI;
#sudo pacman -S bluez-plugins --noconfirm  # Плагины bluez (контроллер PS3 Sixaxis)
#sudo pacman -S blueman --noconfirm  # blueman --диспетчер bluetooth устройств (полезно для i3)
#sudo pacman -S bluez-tools --noconfirm  # Набор инструментов для управления устройствами Bluetooth для Linux
#sudo pacman -S blueberry --noconfirm  # Инструмент настройки Bluetooth
#sudo pacman -S bluedevil --noconfirm  # Интегрируйте технологию Bluetooth в рабочее пространство и приложения KDE
#sudo systemctl enable bluetooth.service
echo ""
echo " Установка пакетов поддержки Bluetooth выполнена "
fi
# -----------------------------------------
# Bluetooth (Русский)
# https://wiki.archlinux.org/index.php/Bluetooth_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# ==========================================
clear
echo ""
echo -e "${GREEN}==> ${NC}Установить сетевые утилиты Networkmanager?"
echo -e "${BLUE}:: ${NC}'Networkmanager' - сервис для работы интернета."
echo " NetworkManager можно установить с пакетом networkmanager, который содержит демон, интерфейс командной строки (nmcli) и интерфейс на основе curses (nmtui). Вместе с собой устанавливает программы (пакеты) для настройки сети. "
echo -e "${CYAN}=> ${NC}После запуска демона NetworkManager он автоматически подключается к любым доступным системным соединениям, которые уже были настроены. Любые пользовательские подключения или ненастроенные подключения потребуют nmcli или апплета для настройки и подключения."
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
  pacman -S networkmanager networkmanager-openvpn network-manager-applet ppp --noconfirm  # Диспетчер сетевых подключений и пользовательские приложения; Плагин NetworkManager VPN для OpenVPN; Апплет для управления сетевыми подключениями; Демон, реализующий протокол точка-точка для коммутируемого доступа в сеть.
  pacman -S nm-connection-editor --noconfirm  # Редактор и виджеты графического интерфейса NetworkManager (https://wiki.gnome.org/Projects/NetworkManager/)
# pacman -Sy networkmanager networkmanager-openvpn network-manager-applet ppp --noconfirm
  echo ""
  echo -e "${BLUE}:: ${NC}Ставим дополнительные сетевые утилиты"
  pacman -S pptpclient --noconfirm  # Клиент для проприетарного протокола туннелирования точка-точка от Microsoft, PPTP
  pacman -S rp-pppoe --noconfirm  # Протокол точка-точка Roaring Penguin через клиент Ethernet
  pacman -S xl2tpd --noconfirm  # Реализация L2TP с открытым исходным кодом, поддерживаемая Xelerance Corporation
  pacman -S networkmanager-l2tp --noconfirm  # Поддержка L2TP для NetworkManager
  echo ""
  echo -e "${BLUE}:: ${NC}Подключаем Networkmanager в автозагрузку"
# systemctl enable NetworkManager  # systemctl - специальный инструмент для управления службами в Linux
  systemctl enable NetworkManager.service
  echo " NetworkManager успешно добавлен в автозагрузку "
elif [[ $i_network  == 0 ]]; then
  echo " Установка NetworkManager пропущена "
fi
###
sleep 02
clear
echo ""
echo -e "${GREEN}==> ${NC}Добавим службу Dhcpcd в автозагрузку (для проводного интернета)?"
echo " Добавим dhcpcd в автозагрузку (для проводного интернета, который получает настройки от роутера). "
echo -e "${CYAN}:: ${NC}Dhcpcd - свободная реализация клиента DHCP и DHCPv6. Пакет dhcpcd является частью группы base, поэтому, скорее всего он уже установлен в вашей системе."
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
# systemctl enable dhcpcd   # для активации проводных соединений  # systemctl - инструмент для управления службами
  systemctl enable dhcpcd.service
  systemctl start dhcpcd.service
  systemctl status dhcpcd.service
  echo " Dhcpcd успешно добавлен в автозагрузку "
elif [[ $x_dhcpcd == 0 ]]; then
  echo ' Dhcpcd не включен в автозагрузку, при необходиости это можно будет сделать уже в установленной системе '
fi
######################
echo ""
echo -e "${BLUE}:: ${NC}Ставим шрифты"  # https://www.archlinux.org/packages/
pacman -S ttf-dejavu --noconfirm  # Семейство шрифтов на основе Bitstream Vera Fonts с более широким набором символов
pacman -S ttf-liberation --noconfirm  # Шрифты Red Hats Liberation
pacman -S ttf-anonymous-pro --noconfirm  # Семейство из четырех шрифтов фиксированной ширины, разработанных специально с учетом кодирования
pacman -S terminus-font --noconfirm  # Моноширинный растровый шрифт (для X11 и консоли)
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Монтирование разделов NTFS и создание ссылок"
pacman -S ntfs-3g --noconfirm  # Драйвер и утилиты файловой системы NTFS; "NTFS file support (Windows Drives)"
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Установка базовых программ и пакетов"
echo -e " Установка базовых программ (пакетов): wget, curl, git, cmake "
pacman -S wget git --noconfirm  #curl  - пока присутствует в pkglist.x86_64  # Сетевая утилита для извлечения файлов из Интернета; Быстрая распределенная система контроля версий.
pacman -S cmake --noconfirm  # Кросс-платформенная система сборки с открытым исходным кодом
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
vm.swappiness=10

EOF
###
echo -e "${BLUE}:: ${NC}Перемещаем и переименовываем исходный файл /etc/sysctl.conf в /etc/sysctl.d/99-sysctl.conf"
cp /etc/sysctl.conf  /etc/sysctl.conf.back  # Для начала сделаем его бэкап
mv /etc/sysctl.conf /etc/sysctl.d/99-sysctl.conf   # Перемещаем и переименовываем исходный файл
###
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
###
echo -e "${BLUE}:: ${NC}Создадим файл /etc/resolv.conf (изменим DNS)"
echo " Пропишем публичные серверы DNS - Yandex (базовый) и BeeLine (внешние)"
echo '[main]' >> /etc/NetworkManager/NetworkManager.conf
echo 'dns=none' >> /etc/NetworkManager/NetworkManager.conf
#cp /etc/resolv.conf  /etc/resolv.conf.back  # Для начала сделаем его бэкап
# cp -v /etc/resolv.conf /etc/resolv.conf.original  # -v или --verbose -Выводить информацию о каждом файле, который обрабатывает команда cp.
#cat > /etc/resolv.conf << EOF
> /etc/resolv.conf
# Resolver configuration file.
# See resolv.conf(5) for details.
cp /etc/resolv.conf  /etc/resolv.conf.back
cat <<EOF >>/etc/resolv.conf
# Generated by resolvconf
domain localdomain
nameserver 77.88.8.8
nameserver 77.88.8.1
nameserver 85.21.192.5
nameserver 213.234.192.7

EOF
###
echo -e "${BLUE}:: ${NC}Автоматизация обновления зеркал /etc/pacman.d/mirrorlist (запуск Reflector при загрузке), pacman-mirrorlist не обновляется регулярно, вызов рефлектора только потому, что какое-то зеркало в какой-то части земного шара было добавлено или удалено, не имеет значения. Вместо этого используйте автоматизацию на основе таймера. Если вы вообще не хотите mirrorlist.pacnew устанавливаться, используйте NoExtractвpacman.conf."
echo " Reflector поставляется с файлом reflector.service. Служба запустит рефлектор с параметрами, указанными в /etc/xdg/reflector/reflector.conf. Параметры по умолчанию в этом файле должны служить хорошей отправной точкой и примером. "
echo " Чтобы обновить список зеркал досрочно, запустите reflector.service . "
echo " Примечание: reflector.service зависит от службы ожидания сети, которая будет настроена через network-online.target ."
cat > /usr/lib/systemd/system/reflector.service << EOF
[Unit]
Description=Pacman mirrorlist update
Requires=network.target
After=network.target
[Service]
Type=oneshot
### ExecStart=/usr/bin/reflector --protocol https --latest 30 --number 20 --sort rate --save /etc/pacman.d/mirrorlist
### ExecStart=/usr/bin/reflector -c ru,by,ua,pl -p https,http --sort rate -a 12 -l 10 --save /etc/pacman.d/mirrorlist
ExecStart=/usr/bin/reflector --verbose --country 'Russia' -l 9 -p https -p http -n 9 --save /etc/pacman.d/mirrorlist
[Install]
RequiredBy=network.target

EOF
###
echo -e "${BLUE}:: ${NC}Reflector предоставляет таймер systemd ( reflector.timer), который еженедельно запускает службу #systemd reflector.service . Расписание можно изменить, отредактировав reflector.timer ."
echo " Сначала отредактируйте файл конфигурации, как описано в разделе #systemd service ."
echo " После обновления файла конфигурации запустите и включите reflector.timer ."
cat > /usr/lib/systemd/system/reflector.timer << EOF
[Unit]
Description=Run reflector weekly
[Timer]
OnCalendar=weekly
AccuracySec=12h
Persistent=true
[Install]
WantedBy=timers.target

EOF
###
# echo ""
# echo -e "${BLUE}:: ${NC}Подключаем reflector.service в автозагрузку"
# systemctl enable reflector.service
# echo " reflector.service успешно добавлен в автозагрузку "
# echo ""
# echo -e "${BLUE}:: ${NC}Запускаем reflector.service "
# systemctl start reflector.service
# echo " reflector.service успешно запущен "
###
echo ""
echo -e "${BLUE}:: ${NC}Подключаем reflector.timer в автозагрузку"
systemctl enable reflector.timer
echo " reflector.timer успешно добавлен в автозагрузку "
####################
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
  pacman -S xdg-user-dirs --noconfirm  # Управляйте пользовательскими каталогами, такими как ~ / Desktop и ~ / Music
# pacman -S xdg-user-dirs-gtk --noconfirm  # Создаёт каталоги пользователей и просит их переместить
  xdg-user-dirs-update
# xdg-user-dirs-gtk-update  # Обновить закладки в thunar (левое меню)
  echo ""
  echo " Создание каталогов успешно выполнено "
fi
#####################
sleep 1
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
  pacman -S zsh zsh-syntax-highlighting zsh-autosuggestions grml-zsh-config --noconfirm  # Очень продвинутый и программируемый интерпретатор команд (оболочка) для UNIX; Рыбная оболочка как подсветка синтаксиса для Zsh; Рыбоподобные самовнушения для zsh (история команд); Настройка zsh в grml
  pacman -S zsh-completions zsh-history-substring-search  --noconfirm  # Дополнительные определения завершения для Zsh; ZSH порт поиска рыбной истории (стрелка вверх)
# pacman -S zsh-theme-powerlevel10k  --noconfirm  # Powerlevel10k - это тема для Zsh. Он подчеркивает скорость, гибкость и готовность к работе. (https://github.com/romkatv/powerlevel10k)
  echo 'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> /etc/zsh/zshrc
  echo 'source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> /etc/zsh/zshrc
# echo 'prompt adam2' >> /etc/zsh/zshrc
  echo 'prompt fire' >> /etc/zsh/zshrc
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
fi
#####################
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
# Чтобы протестировать любой данный пакет после его установки, сделайте следующее: pacman -D –asdeps  - Это сообщит pacman, что пакет был установлен как зависимость, следовательно, он будет указан как потерянный (что вы можете увидеть с помощью «pacman -Qtd»). Если вы затем решите, что хотите сохранить пакет, вы можете использовать флаг –asexplicit как есть ...
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
  cp /etc/hosts /etc/hosts.bak
# cp /etc/hosts ~/Documents/hosts.bak
  echo ""
  echo " Загрузка и обновление файла /etc/hosts "
  wget -qO- https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts | sudo tee --append /etc/hosts
  echo ""
  echo " Создание файла /etc/hosts успешно выполнено "
fi
sleep 1
###################
clear
echo ""
echo -e "${BLUE}:: ${NC}Установим дополнения (плюшки) для Pacman - пакет (pacman-contrib)?"
echo " Этот репозиторий содержит скрипты, предоставленные pacman (различных дополнений и приятных мелочей для более комфортной работы сполна) "
echo -e "${YELLOW}=> Примечание: ${BOLD}Раньше это было частью pacman.git, но было перемещено, чтобы упростить обслуживание pacman. Также, вместе с пакетом (pacman-contrib) будет установлен пакет (pcurses) - инструмент управления пакетами curses с использованием libalpm. ${NC}"
echo " Скрипты, доступные в этом репозитории: checkupdates, paccache, pacdiff, paclist, paclog-pkglist, pacscripts, pacsearch, rankmirrors, updpkgsums;... "
echo " checkupdates - распечатать список ожидающих обновлений, не касаясь баз данных синхронизации системы (для безопасности при скользящих выпусках). "
echo " paccache - гибкая утилита очистки кэша пакетов, которая позволяет лучше контролировать, какие пакеты удаляются. "
echo " pacdiff - простая программа обновления pacnew / pacsave для / etc /. "
echo " paclist - список всех пакетов, установленных из данного репозитория. Полезно, например, для просмотра того, какие пакеты вы могли установить из тестового репозитория. "
echo " paclog-pkglist - выводит список установленных пакетов на основе журнала pacman. "
echo " pacscripts - пытается распечатать сценарии {pre, post} _ {install, remove, upgrade} для данного пакета. "
echo " pacscripts - пытается распечатать сценарии {pre, post} _ {install, remove, upgrade} для данного пакета. "
echo " pacsearch - цветной поиск, объединяющий вывод -Ss и -Qs. Установленные пакеты легко идентифицировать с помощью [installed] значка, и также перечислены только локальные пакеты. "
echo " rankmirrors - ранжирует зеркала pacman по скорости подключения и скорости открытия. "
echo " updpkgsums - выполняет обновление контрольных сумм в PKGBUILD на месте. "
echo -e "${YELLOW}==> ${NC}Будьте внимательны! Если Вы сомневаетесь в своих действиях, просто пропустите этот пункт."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить пакет (pacman-contrib),    0 - Нет пропустить установку: " i_contrib  # sends right after the keypress; # отправляет сразу после нажатия клавиши
echo ''
   [[ "$i_contrib" =~ [^10] ]]
do
    :
done
if [[ $i_contrib == 0 ]]; then
  echo ""
  echo " Установка пакетов пропущена "
elif [[ $i_contrib == 1 ]]; then
  echo ""
  echo " Установка пакетов (pacman-contrib), (pcurses) "
  pacman -S --noconfirm --needed pacman-contrib  # Предоставленные скрипты и инструменты для систем pacman (https://github.com/kyrias/pacman-contrib)
### pacman -S --noconfirm --needed pcurses  # Инструмент управления пакетами curses с использованием libalpm ; pcurses позволяет просматривать пакеты и управлять ими во внешнем интерфейсе curses, написанном на C++ ; https://github.com/schuay/pcurses ; Раньше присутствовал в community ...
##### pcurses ######
  cd /home/$username
  git clone https://aur.archlinux.org/pcurses.git
  chown -R $username:users /home/$username/pcurses
  chown -R $username:users /home/$username/pcurses/PKGBUILD
  cd /home/$username/pcurses
  sudo -u $username  makepkg -si --noconfirm
#  sudo -u $username  makepkg -fsri --noconfirm
# makepkg --noconfirm --needed -sic
  rm -Rf /home/$username/pcurses
  echo ""
  echo " Установка программ (пакетов) выполнена "
fi
sleep 1
#################
clear
echo ""
echo -e "${BLUE}:: ${NC}Установим Hwdetect - пакет (hwdetect) - Информация о железе?"
echo " Hwdetect - это скрипт (консольная утилита с огромным количеством опций) обнаружения оборудования, который в основном используется для загрузки или вывода списка модулей ядра (для использования в mkinitcpio.conf), и заканчивая возможностью автоматического изменения rc.conf и mkinitcpio.conf ; (https://wiki.archlinux.org/title/Hwdetect) "
echo -e "${YELLOW}=> Примечание: ${BOLD}Это отличается от многих других инструментов, которые запрашивают только оборудование и показывают необработанную информацию, оставляя пользователю задачу связать эту информацию с необходимыми драйверами. ${NC}"
echo " Сценарий использует информацию, экспортируемую подсистемой sysfs (https://en.wikipedia.org/wiki/Sysfs), используемой ядром Linux. "
echo -e "${YELLOW}==> ${NC}Будьте внимательны! Если Вы сомневаетесь в своих действиях, просто пропустите этот пункт."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить пакет (hwdetect),    0 - Нет пропустить установку: " i_hwdetect  # sends right after the keypress; # отправляет сразу после нажатия клавиши
echo ''
   [[ "$i_hwdetect" =~ [^10] ]]
do
    :
done
if [[ $i_hwdetect == 0 ]]; then
  echo ""
  echo " Установка пакетов пропущена "
elif [[ $i_hwdetect == 1 ]]; then
  echo ""
  echo " Установка пакета (hwdetect) "
  pacman -S --noconfirm --needed hwdetect  # Скрипт (консольная утилита) просмотр модулей ядра для устройств, обнаружения оборудования с загрузочными модулями и поддержкой mkinitcpio.conf / rc.conf
# pacman -S hwdetect --noconfirm  # Скрипт (консольная утилита) просмотр модулей ядра для устройств, обнаружения оборудования с загрузочными модулями и поддержкой mkinitcpio.conf / rc.conf
  echo ""
  echo " Установка дополнительных базовых программ (пакетов) выполнена "
fi
sleep 1
###################
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
echo -e "${RED}==> ${BOLD}Выходим из установленной системы ${NC}"
echo -e "${BLUE}:: ${BOLD}Теперь вам надо ввести (exit) reboot, чтобы перезагрузиться ${NC}"
exit
exit


### end of script

