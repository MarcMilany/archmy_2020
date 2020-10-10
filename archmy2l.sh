#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

ARCHMY2_LANG="russian"  # Installer default language (Язык установки по умолчанию)

script_path=$(readlink -f ${0%/*})

umask 0022 # Определение окончательных прав доступа
# Для суперпользователя (root) umask по умолчанию равна 0022

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

### Execute action in chrooted environment (Выполнение действия в хромированной среде)
_chroot() {
    arch-chroot /mnt <<EOF "${1}"
EOF
}

###################################################################

# Information (Информация)
_arch_fast_install_banner_2() {
    echo -e "${YELLOW}
  ***************************** ИНФОРМАЦИЯ! ***************************** 
${NC} 
Продолжается работа скрипта - основанного на сценарии (скриптов): 'Arch Linux Fast Install LegasyBios' - (ordanax/arch2018), и 'archlinux-script-install' - (Poruncov,Grub-Legacy - 2020).
Происходит установка первоначально необходимого софта (пакетов), запуск необходимых служб, запись данных в конфиги (hhh.conf) по настройке системы.
В процессе работы сценария (скрипта) Вам будет предложено выполнить следующие действия:
Ввести имя пользователя (username), ввести имя компьютера (hostname), а также установить пароль для пользователя (username) и администратора (root). 
Настроить состояние аппаратных часов 'UTC или Localtime', но Вы можете отказаться и настроить их уже из системы Arch'a.
Будут заданы вопросы: на установку той, или иной утилиты (пакета), и на какой аппаратной базе будет установлена система (для установки Xorg 'обычно называемый просто X' и драйверов) - Будьте Внимательными! 
 Смысл в том, что все изменения Вы делаете предварительно в самом скрипте и получаете возможность быстрой установки утилит (пакетов), которые Вы решили установить (при условии, что Вы его изменили под себя, в противном случае скрипт установит софт (пакеты) прописанный изначально.
Не переживайте софт (пакеты) скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. В любой ситуации выбор всегда за вами.
${BLUE}
  *********************************************************************** ${NC}"   
} 
###################################################################

### Display banner (Дисплей баннер)
#echo ""
_arch_fast_install_banner_2

sleep 02
echo ""
echo -e "${GREEN}=> ${NC}Для проверки интернета можно пропинговать какой-либо сервис" 
ping -c2 archlinux.org

echo -e "${CYAN}==> ${NC}Если пинг идёт едем дальше ... :)"

### Specified Time
echo ""
echo -e "${BLUE}:: ${NC}Синхронизация системных часов"  
timedatectl set-ntp true

echo -e "${BLUE}:: ${NC}Посмотрим статус службы NTP (NTP service)"
timedatectl status

### Specified Time
echo -e "${BLUE}:: ${NC}Посмотрим текущее состояние аппаратных и программных часов"
timedatectl

echo ""
echo -e "${BLUE}:: ${NC}Обновим вашу систему (базу данных пакетов)"
echo -e "${YELLOW}:: ${NC}Загружаем базу данных пакетов независимо от того, есть ли какие-либо изменения в версиях или нет."
echo ""
pacman -Syyu  --noconfirm  

### Hostname Username ##### 
sleep 01
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

### Set Hostname ###########
echo -e "${BLUE}:: ${NC}Прописываем имя компьютера"
echo $hostname > /etc/hostname

### Clear the HOME FOLDER #####
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

### Set Timezone ########
echo ""
echo -e "${GREEN}==> ${NC}Устанавливаем ваш часовой пояс (localtime)."
echo " Всё завязано на времени, поэтому очень важно, чтобы часы шли правильно... :) "
echo -e "${BLUE}:: ${BOLD}Для начала вот ваши данные по дате, времени и часовому поясу: ${NC}"
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'    # одновременно отображает дату и часовой пояс

echo -e "${MAGENTA}:: ${BOLD}Мир состоит из шести частей света: Азия, Африка, Америка, Европа, Австралия и Океания, Антарктика (Антарктида с прибрежными морями и островами). Иногда Океанию и Арктику выделяют в отдельные части света. ${NC}"
echo -e "${CYAN}:: ${NC}Наиболее популярный и поддерживаемый в большинстве дистрибутивов способ установки часового пояса для всех пользователей с помощью символической ссылки (symbolic link) "/etc/localtime" - на файл нужного часового пояса."
echo -e "${CYAN}:: ${NC}Для создания символической ссылки используется команда "ln -sf" или "ln -svf"."
echo " ln -sf /usr/share/zoneinfo/Частъ Света/Город /etc/localtime "  # (где Region - ваш регион, City - ваш город)
echo " ln -sf /usr/share/zoneinfo/Зона/Субзона /etc/localtime "
echo " ln -sf /usr/share/zoneinfo/Регион/Город /etc/localtime "
echo " ln -svf /usr/share/zoneinfo/Europe/Moscow /etc/localtime - это полный вид команды "
echo -e "${CYAN}:: ${NC}Для нас сейчас нужна малая толика от всей команды это - (Частъ Света/Город)."
echo -e "${GREEN}:: ${NC}Примеры (timezone): Europe/Moscow, Europe/Minsk, Europe/Kiev, Europe/Berlin, Europe/Paris, Asia/Yekaterinburg, Asia/Almaty, Africa/Nairobi, America/Chicago, America/New_York, America/Indiana/Indianapolis, Australia/Sydney, Antarctica/Vostok, Arctic/Longyearbyen, Atlantic/Azores, Indian/Maldives, и так далее..."
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

echo ""
echo -e "${GREEN}=> ${BOLD}Это ваш часовой пояс (timezone) - '$timezone' ${NC}"
echo -e "${BLUE}:: ${BOLD}Ваши данные по дате, времени и часовому поясу: ${NC}"
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'    # одновременно отображает дату и часовой пояс

### Specified Time  #####
echo -e "${BLUE}:: ${NC}Синхронизируем аппаратное время с системным"
echo " Устанавливаются аппаратные часы из системных часов. "
# Эта команда предполагает, что аппаратные часы настроены в формате UTC.
hwclock --systohc
# hwclock --adjust  # Порой значение аппаратного времени может сбиваться - выровняем!

### Specified Time ######
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

### Specified Time #############
echo ""
echo -e "${BLUE}:: ${NC}Посмотрим обновление времени (если настройка не была пропущена)"
timedatectl show
#timedatectl | grep Time
#timedatectl set-timezone Europe/Moscow

### Set Hosts ########
echo ""
echo -e "${BLUE}:: ${NC}Изменяем имя хоста"
echo "127.0.0.1	localhost.(none)" > /etc/hosts
echo "127.0.1.1	$hostname" >> /etc/hosts
echo "::1	localhost ip6-localhost ip6-loopback" >> /etc/hosts
echo "ff02::1 ip6-allnodes" >> /etc/hosts
echo "ff02::2 ip6-allrouters" >> /etc/hosts

### Set Locale #####
echo -e "${BLUE}:: ${NC}Добавляем русскую локаль системы"
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 

### Set Locale #######
echo -e "${BLUE}:: ${NC}Обновим текущую локаль системы"
locale-gen  # Мы ввели locale-gen для генерации тех самых локалей.

### Set Locale ###########
sleep 02
echo -e "${BLUE}:: ${NC}Указываем язык системы"
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf
#echo 'LANG="en_US.UTF-8"' > /etc/locale.conf

### Set Vconsole ##########
echo -e "${BLUE}:: ${NC}Вписываем KEYMAP=ru FONT=cyr-sun16 FONT=ter-v16n FONT=ter-v16b"
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo '#LOCALE=ru_RU.UTF-8' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf
echo '#FONT=ter-v16n' >> /etc/vconsole.conf
echo '#FONT=ter-v16b' >> /etc/vconsole.conf
echo '#FONT=ter-u16b' >> /etc/vconsole.conf
echo 'FONT_MAP=' >> /etc/vconsole.conf
echo '#CONSOLEFONT="cyr-sun16' >> /etc/vconsole.conf
echo 'CONSOLEMAP=' >> /etc/vconsole.conf
echo '#TIMEZONE=Europe/Moscow' >> /etc/vconsole.conf
echo '#HARDWARECLOCK=UTC' >> /etc/vconsole.conf
echo '#USECOLOR=yes' >> /etc/vconsole.conf
echo 'COMPRESSION="lz4"' >> /etc/mkinitcpio.conf

#clear
echo ""
echo -e "${GREEN}==> ${NC}Создадим загрузочный RAM диск (начальный RAM-диск)"
echo -e "${MAGENTA}:: ${BOLD}Arch Linux имеет mkinitcpio - это Bash скрипт используемый для создания начального загрузочного диска системы. ${NC}"
echo -e "${CYAN}:: ${NC}mkinitcpio является модульным инструментом для построения initramfs CPIO образа, предлагая много преимуществ по сравнению с альтернативными методами. Предоставляет много возможностей для настройки из командной строки ядра без необходимости пересборки образа."
echo -e "${YELLOW}:: ${NC}Чтобы избежать ошибки при создании RAM (mkinitcpio -p), вспомните какое именно ядро Вы выбрали ранее."
echo " Будьте внимательными! Здесь варианты создания RAM-диска, с конкретными ядрами. "
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
  mkinitcpio -p linux   # mkinitcpio -P linux
# mkinitcpio -P   
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
#echo 'COMPRESSION="lz4"' >> /etc/mkinitcpio.conf


### Set Root passwd ##########
### Root Password ##########
sleep 01
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

### GRUB BIOS ##################
#clear
echo ""
echo -e "${GREEN}==> ${NC}Установить (bootloader) загрузчик GRUB(legacy)?"
echo -e "${BLUE}:: ${NC}Установка GRUB2 в процессе установки Arch Linux"
echo " 1 - Установка полноценной BIOS-версии загрузчика GRUB(legacy), тогда укажите "1". "
echo " Файлы загрузчика будут установлены в каталог /boot. Код GRUB (boot.img) будет встроен в начальный сектор, а загрузочный образ core.img в просвет перед первым разделом MBR, или BIOS boot partition для GPT. "
echo " 2 - Если нужно установить BIOS-версию загрузчика из-под системы, загруженной в режиме UEFI, тогда укажите "2". " 
echo " В этом варианте требуется принудительно задать программе установки нужную сборку GRUB: 
        Пример - grub-install --target=i386-pc /dev/sdX  #sda sdb sdc sdd. "
echo -e "${YELLOW}:: ${BOLD}В этих вариантах большого отличия нет, кроме команд выполнения. Не зависимо от вашего выбора нужно ввести маркер sdX-диска куда будет установлен GRUB.${NC}"          
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
pacman -Syy
pacman -S grub --noconfirm  # Файлы и утилиты для установки GRUB2 содержатся в пакете grub
#pacman -S grub --noconfirm --noprogressbar --quiet 
uname -rm
lsblk -f
echo ""
echo -e "${YELLOW}:: ${BOLD}Примечание: /dev/sdX - диск (а не раздел ), на котором должен быть установлен GRUB. ${NC}"
echo ""
# Если вы используете LVM для вашего /boot, вы можете установить GRUB на нескольких физических дисках.
 echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
 read -p " => Укажите диск куда установить GRUB (sda/sdb например sda или sdb) : " x_cfd  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
 grub-install /dev/$x_cfd   #sda sdb sdc sdd
#grub-install --recheck /dev/$x_cfd     # Если Вы получили сообщение об ошибке
#grub-install --boot-directory=/mnt/boot /dev/$x_cfd  # установить файлы загрузчика в другой каталог
  echo " Загрузчик GRUB установлен на выбранный вами диск (раздел). " 
#grub-mkconfig -o /boot/grub/grub.cfg
# echo " Обновлён (сгенерирован) grub.cfg (/boot/grub/grub.cfg). "
elif [[ $i_grub == 2 ]]; then
echo ""    
pacman -Syy
# Файлы и утилиты для установки GRUB2 содержатся в пакете grub, и устанавливаются командой:
pacman -S grub --noconfirm
#pacman -S grub --noconfirm --noprogressbar --quiet
uname -rm
lsblk -f
echo ""
echo -e "${YELLOW}=> ${BOLD}Примечание: /dev/sdX - диск (а не раздел ), на котором должен быть установлен GRUB. ${NC}"
echo ""
# Если вы используете LVM для вашего /boot, вы можете установить GRUB на нескольких физических дисках.
 echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
 read -p " => Укажите диск куда установить GRUB (sda/sdb например sda или sdb) : " x_cfd # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
# Если нужно установить BIOS-версию загрузчика из-под системы, загруженной в режиме UEFI
 grub-install --target=i386-pc /dev/$x_cfd   #sda sdb sdc sdd
#grub-install --target=i386-pc --recheck /dev/$x_cfd   # Если Вы получили сообщение об ошибке
  echo " Загрузчик GRUB установлен на выбранный вами диск (раздел). " 
#grub-mkconfig -o /boot/grub/grub.cfg
# echo " Обновлён (сгенерирован) grub.cfg (/boot/grub/grub.cfg). " 
elif [[ $i_grub == 0 ]]; then
  echo ""  
  echo 'Операция пропущена.'
fi

### Install Microcode ###########
#clear
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
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
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
if [[ $prog_cpu == 1 ]]; then
echo ""
echo " Устанавливаем uCode для процессоров - AMD "
pacman -S amd-ucode --noconfirm 
  echo " Установлены обновления стабильности и безопасности для микрокода процессора - AMD "
  #grub-mkconfig -o /boot/grub/grub.cfg
# echo " Обновлён (сгенерирован) grub.cfg (/boot/grub/grub.cfg). "       
elif [[ $prog_cpu == 2 ]]; then
  echo ""  
  echo " Устанавливаем uCode для процессоров - INTEL "
 pacman -S intel-ucode --noconfirm
  echo " Установлены обновления стабильности и безопасности для микрокода процессора - INTEL " 
  #grub-mkconfig -o /boot/grub/grub.cfg
# echo " Обновлён (сгенерирован) grub.cfg (/boot/grub/grub.cfg). "    
elif [[ $prog_cpu == 3 ]]; then
  echo ""  
  echo " Устанавливаем uCode для процессоров - AMD и INTEL "
 pacman -S amd-ucode intel-ucode --noconfirm 
  echo " Установлены обновления стабильности и безопасности для микрокода процессоров - AMD и INTEL "  
  #grub-mkconfig -o /boot/grub/grub.cfg
# echo " Обновлён (сгенерирован) grub.cfg (/boot/grub/grub.cfg). "  
elif [[ $prog_cpu == 0 ]]; then
  echo ""  
  echo 'Установка микрокода процессоров пропущена.'
fi

echo ""
echo -e "${GREEN}==> ${NC}Если на компьютере будут несколько ОС, то это также ставим."
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
pacman -S os-prober mtools fuse --noconfirm  #grub-customizer
echo " Программы (пакеты) установлены "  	
elif [[ $dual_boot  == 0 ]]; then
echo ""    
echo " Установка программ (пакетов) пропущена. "
fi

echo ""
echo -e "${BLUE}:: ${NC}Обновляем grub.cfg (Сгенерируем grub.cfg)"
grub-mkconfig -o /boot/grub/grub.cfg   # создаём конфигурационный файл

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
pacman -S dialog wpa_supplicant iw wireless_tools net-tools --noconfirm 
echo " Программы (пакеты) для Wi-fi установлены "  	
elif [[ $i_wifi  == 0 ]]; then
echo ""    
echo " Установка программ (пакетов) пропущена. "
fi

### Set User ######
sleep 01
clear
echo ""
echo -e "${GREEN}==> ${NC}Добавляем пользователя и прописываем права, (присвоение) групп. "
echo -e "${MAGENTA}=> ${BOLD}В сценарии (скрипта) прописано несколько вариантов! ${NC}"
echo " Давайте рассмотрим варианты (действия), которые будут выполняться. "
echo " 1 - Добавляем пользователя, прописываем права, и добавляем группы : "
echo " (audio,games,lp,disk,network,optical,power,scanner,storage,video,rfkill,sys,wheel), то выбирайте вариант - "1". "
echo " 2 - Добавляем пользователя, прописываем права, и добавляем группы : "
echo " (adm + audio,games,lp,disk,network,optical,power,scanner,storage,video,rfkill,sys,wheel), то выбирайте вариант - "2". "
echo " 3 - Добавляем пользователя, прописываем права, и добавляем пользователя в группу : "
echo " (wheel), то выбирайте вариант - "3". "
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
clear 
echo ""
echo " Пользователь успешно добавлен в группы и права пользователя. "
elif [[ $i_groups  == 2 ]]; then
useradd -m -g users -G adm,audio,games,lp,disk,network,optical,power,scanner,storage,video,rfkill,sys,wheel -s /bin/bash $username
clear 
echo ""
echo " Пользователь успешно добавлен в группы и права пользователя. "
elif [[ $i_groups  == 3 ]]; then
useradd -m -g users -G wheel -s /bin/bash $username
clear 
echo ""
echo " Пользователь успешно добавлен в группы и права пользователя. "
fi

### Set User passwd ##########
### User Password ###########
echo ""
echo -e "${GREEN}==> ${NC}Устанавливаем пароль пользователя (User Password)"
echo " Пароль должен содержать от 6 до 15 символов, включающих цифры (1-0) и знаки (!'':[@]),    
        и латинские буквы разного регистра! "
echo -e "${MAGENTA}=> ${BOLD}По умолчанию, на большинстве систем Linux в консоле не показывается введенный пароль. 
Это сделано из соображений безопасности, чтобы никто не мог увидеть длину вашего пароля.${NC}"
echo " => Введите User Password (Пароль пользователя) - для $username, вводим пароль 2 раза "
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
passwd $username

echo ""
echo -e "${BLUE}:: ${NC}Проверим статус пароля для всех учетных записей пользователей в вашей системе"
passwd -Sa

echo ""
echo -e "${GREEN}==> ${NC}Информация о пользователе (полное имя пользователя и связанная с ним информация)"
echo " Пользователь в Linux может хранить большое количество связанной с ним информации, в том числе номера домашних и офисных телефонов, номер кабинета и многое другое. Мы обычно пропускаем заполнение этой информации (так как всё это необязательно) - при создании пользователя. "
echo -e "${CYAN}:: ${NC}На первом этапе достаточно имени пользователя, и подтверждаем - нажмите кнопку 'Ввод'(Enter). Ввод другой информации (Кабинет, Телефон в кабинете, Домашний телефон) можно пропустить - просто нажмите 'Ввод'(Enter). "
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
#finger $username
elif [[ $i_finger == 0 ]]; then
  echo ""  
  echo ' Настройка пропущена. '
fi 

echo ""
echo -e "${BLUE}:: ${NC}Устанавливаем (пакет) SUDO."
echo -e "${CYAN}=> ${NC}Пакет sudo позволяет системному администратору предоставить определенным пользователям (или группам пользователей) возможность запускать некоторые (или все) команды в роли пользователя root или в роли другого пользователя, указываемого в командах или в аргументах."
pacman -S sudo --noconfirm

echo ""
echo -e "${GREEN}==> ${NC}Настраиваем запрос пароля "Пользователя" при выполнении команды "sudo". "
echo " Чтобы начать использовать sudo как непривилегированный пользователь, его нужно настроить должным образом. "
echo " Огласите весь список, пожалуйста! :) "
echo " 1 - Пользователям (членам) группы wheel доступ к sudo С запросом пароля. "
echo " 2 - Пользователям (членам) группы wheel доступ к sudo (NOPASSWD) БЕЗ запроса пароля. "
echo -e "${RED}==> ${BOLD}Выбрав '2' (раскомментировав) данную опцию, особых требований к безопасности нет, но может есть какие-то очень негативные моменты в этом?... ${NC}"
echo " 3-(0) - Добавление настроек sudo пропущено. "
echo " Все настройки в файле /etc/sudoers пользователь произведёт сам. "
echo " Например: под строкой root ALL=(ALL) ALL  - пропишет -  $username ALL=(ALL) ALL "
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
echo " Добавление настройки sudo пропущено"
elif [[ $i_sudo  == 1 ]]; then
#echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
#cat /mnt/etc/sudoers
clear
echo ""
echo " Sudo с запросом пароля выполнено "
elif [[ $i_sudo  == 2 ]]; then
#echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
#cat /mnt/etc/sudoers
clear
echo ""
echo " Sudo nopassword (БЕЗ запроса пароля) добавлено  "
fi

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
#clear
echo ""
echo " Добавление Multilib репозитория пропущено "
elif [[ $i_multilib  == 1 ]]; then
#echo 'Color = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
sed -i 's/#Color/Color/' /etc/pacman.conf
#sed -i '/#Color/ s/^#//' /etc/pacman.conf
sed -i '/^Co/ aILoveCandy' /etc/pacman.conf
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
#echo '[multilib]' >> /etc/pacman.conf
#echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
#pacman -Syy
#clear
echo ""
echo " Multilib репозиторий добавлен (раскомментирован) "
fi

echo ""
echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов"  
#pacman -Syy
pacman -Sy   #--noconfirm --noprogressbar --quiet
#pacman -Syy --noconfirm --noprogressbar --quiet

#### X.Org Server #########
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
lspci -nn | grep VGA
#lspci | grep VGA        # узнаем ID шины 
# После того как вы узнаете PCI-порт видеокарты, например 1с:00.0, можно получить о ней более подробную информацию:
# sudo lspci -v -s 1с:00.0
echo ""
echo -e "${RED}==> ${NC}Куда Вы устанавливаете Arch Linux на PC, или на Виртуальную машину (VBox;VMWare)?"
echo " Для того, чтобы ускорение видео работало, и часто для того, чтобы разблокировать все режимы, в которых может работать GPU (графический процессор), требуется правильный видеодрайвер. "
echo -e "${MAGENTA}=> ${BOLD}Есть три варианта установки Xorg (иксов): ${NC}"
echo " Давайте проанализируем действия, которые будут выполняться. "
echo " 1 - Если Вы устанавливаете Arch Linux на PC, то выбирайте вариант - "1". "
echo " 2 - Если Вы устанавливаете Arch Linux на Виртуальную машину (VBox;VMWare), то ваш вариант - "2". "
echo " 3(0) - Вы можете пропустить установку Xorg (иксов), если используете VDS (Virtual Dedicated Server), или VPS (Virtual Private Server), тогда выбирайте вариант - "0". "
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
#echo ""
echo " Установка Xorg (иксов) пропущена (используется VDS, или VPS) "  
elif [[ $vm_setting == 1 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit"  #(или на vmware) # --confirm   всегда спрашивать подтверждение
# gui_install="xorg-server xorg-drivers --noconfirm"     # xorg-xinit 
elif [[ $vm_setting == 2 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils"  #(или на vmware) # --confirm   всегда 
# gui_install="xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils --noconfirm" 
fi

echo ""
echo -e "${BLUE}:: ${NC}Ставим иксы и драйвера"
echo " Выберите свой вариант (от 1-...), или по умолчанию нажмите кнопку 'Ввод' ("Enter") "
echo " Далее после своего сделанного выбора, нажмите "Y или n" для подтверждения установки. "
pacman -S $gui_install   # --confirm   всегда спрашивать подтверждение
echo ""
pacman -Syy --noconfirm --noprogressbar --quiet
sleep 01
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
pacman -S  plasma plasma-meta plasma-pa plasma-desktop kde-system-meta kde-utilities-meta kio-extras kwalletmanager latte-dock  konsole  kwalletmanager --noconfirm
clear 
echo ""
echo " DE (Plasma KDE) успешно установлено " 
echo ""
echo -e "${GREEN}==> ${NC}Настройка автовхода без DM (Display manager) менеджера входа в KDE(Plasma)"
echo " Давайте проанализируем действия, которые выполняются. "
echo " 1 - Если вам нужен автовход без DM (Display manager) тогда укажите "1". "
echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" . " 
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
pacman -R konqueror --noconfirm  # Файловый менеджер и веб-браузер KDE
clear
elif [[ $x_de == 2 ]]; then
echo ""    
echo " Установка Xfce + Goodies for Xfce "     
#pacman -S xfce4 xfce4-goodies
pacman -S xfce4 xfce4-goodies --noconfirm
# pacman -S xfce4 xfce4-goodies pavucontrol --noconfirm
#mv /usr/share/xsessions/xfce.desktop ~/
clear
echo ""
echo " DE (среда рабочего стола) Xfce успешно установлено "  

### Log in without DM (Display manager) 
echo ""
echo -e "${GREEN}==> ${NC}Настройка автовхода без DM (Display manager) менеджера входа в Xfce"
echo -e "${MAGENTA}=> ${BOLD}Файл ~/.xinitrc представляет собой шелл-скрипт передаваемый xinit посредством команды startx. ${NC}"
echo -e "${MAGENTA}:: ${NC}Он используется для запуска Среды рабочего стола, Оконного менеджера и других программ запускаемых с X сервером (например запуска демонов, и установки переменных окружений."
echo -e "${CYAN}:: ${NC}Программа xinit запускает Xorg сервер и работает в качестве программы первого клиента на системах не использующих Экранный менеджер."
echo " Давайте проанализируем действия, которые выполняются. "
echo " 1 - Если вам нужен автовход без DM (Display manager) тогда укажите "1". "
echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" . " 
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
# Поскольку реализация автозагрузки окружения реализована через startx, 
# то у Вас должен быть установлен пакет: xorg-xinit    
pacman -S xorg-xinit --noconfirm   # Программа инициализации X.Org
# Если файл .xinitrc не существует, то копируем его из /etc/X11/xinit/xinitrc
# в папку пользователя cp /etc/X11/xinit/xinitrc ~/.xinitrc
cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc # копируем файл .xinitrc в каталог пользователя
chown $username:users /home/$username/.xinitrc  # даем доступ пользователю к файлу
chmod +x /home/$username/.xinitrc   # получаем права на исполнения скрипта
sed -i 52,55d /home/$username/.xinitrc  # редактируем файл -> и прописываем команду на запуск
# # Данные блоки нужны для того, чтобы StartX автоматически запускал нужное окружение, соответственно в секции Window Manager of your choice раскомментируйте нужную сессию
echo "exec startxfce4 " >> /home/$username/.xinitrc  
mkdir /etc/systemd/system/getty@tty1.service.d/  # создаём папку
echo " [Service] " > /etc/systemd/system/getty@tty1.service.d/override.conf
echo " ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo   ExecStart=-/usr/bin/agetty --autologin $username --noclear %I 38400 linux >> /etc/systemd/system/getty@tty1.service.d/override.conf
# Делаем автоматический запуск Иксов в нужной виртуальной консоли после залогинивания нашего пользователя
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
echo " 1 - Если вам нужен автовход без DM (Display manager) тогда укажите "1". "
echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" . " 
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
echo " 1 - Если вам нужен автовход без DM (Display manager) тогда укажите "1". "
echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" . " 
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
echo " 1 - Если вам нужен автовход без DM (Display manager) тогда укажите "1". "
echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" . " 
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
echo " 1 - Если вам нужен автовход без DM (Display manager) тогда укажите "1". "
echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" . " 
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
echo " 1 - Если вам нужен автовход без DM (Display manager) тогда укажите "1". "
echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" . " 
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
echo " 1 - Если вам нужен автовход без DM (Display manager) тогда укажите "1". "
echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" . " 
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
clear 

echo ""
echo -e "${GREEN}==> ${NC}Ставим DM (Display manager) менеджера входа."
echo " DM - Менеджер дисплеев, или Логин менеджер, обычно представляет собой графический пользовательский интерфейс, который отображается в конце процесса загрузки вместо оболочки по умолчанию. "
echo -e "${MAGENTA}:: ${BOLD}Существуют различные реализации дисплейных менеджеров, обычно с определенным количеством настроек и тематических функций, доступных для каждого из них. ${NC}"
echo -e "${MAGENTA}=> ${BOLD}Согласно аннотации ArchWiki рассмотрим список графических менеджеров дисплея, варианты установки DM (Display manager), и их совместимость с различными вариантами DE (средами рабочего стола). ${NC}"
echo " 1 - LightDM - Диспетчер дисплеев между рабочими столами, может использовать различные интерфейсы, написанные на любом наборе инструментов, вариант - "1". "
echo -e "${CYAN}:: ${NC}LightDM - идёт как основной DM в Xfce (окружение рабочего стола), совместим с Deepin, и т.д.. Его ключевые особенности: Кросс-десктоп - поддерживает различные настольные технологии, поддерживает различные технологии отображения (X, Mir, Wayland ...), низкое использование памяти и высокая производительность. Поддерживает гостевые сессии, поддерживает удаленный вход (входящий - XDMCP, VNC, исходящий - XDMCP). "
echo " 2 - LXDM - Диспетчер отображения LXDE, вариант - "2". "
echo -e "${CYAN}:: ${NC}LXDE  - идёт как основной DM в LXDE (окружение рабочего стола), совместим с Xfce, Mate, Deepin, и т.д.. Это легкий диспетчер отображения, пользовательский интерфейс реализован с помощью GTK 2. LXDM не поддерживает протокол XDMCP, альтернатива - LightDM. "
echo " 3 - GDM - Диспетчер отображения GNOME, вариант - "3". "
echo -e "${CYAN}:: ${NC}GNOME Display Manager (GDM) - это программа, которая управляет серверами графического дисплея и обрабатывает логины пользователей в графическом режиме. "
echo " 4 - SDDM - Диспетчер отображения на основе QML и преемник KDM, вариант - "4". "
echo -e "${CYAN}:: ${NC}SDDM - рекомендуется для KDE Plasma Desktop, и LXQt (окружение рабочего стола). Simple Desktop Display Manager (SDDM) - это диспетчер дисплея (графическая программа входа в систему) для оконных систем X11 и Wayland. KDE выбрала SDDM в качестве преемника KDE Display Manager для KDE Plasma 5. "
echo " 5(0) - Если Вам не нужен DM (Display manager), то выбирайте вариант - "0". "
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
 echo ' Установка DM (Display manager) пропущена. '
elif [[ $i_dm == 1 ]]; then
  echo ""  
  echo " Установка LightDM (менеджера входа) "
pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm
echo " Установка DM (менеджера входа) завершена "
echo ""
echo " Подключаем автозагрузку менеджера входа "
#systemctl enable lightdm.service
systemctl enable lightdm.service -f
sleep 1 
clear
echo ""
echo " Менеджера входа LightDM установлен и подключен в автозагрузку "
elif [[ $i_dm == 2 ]]; then
  echo ""  
  echo " Установка LXDM (менеджера входа) "
pacman -S lxdm --noconfirm
echo " Установка DM (менеджера входа) завершена "
echo ""
echo " Подключаем автозагрузку менеджера входа "
#systemctl enable lxdm.service
systemctl enable lxdm.service -f
sleep 1 
clear
echo ""
echo " Менеджера входа LXDM установлен и подключен в автозагрузку "
elif [[ $i_dm == 3 ]]; then
  echo ""  
  echo " Установка GDM (менеджера входа) "
pacman -S gdm --noconfirm
echo " Установка DM (менеджера входа) завершена "
echo ""
echo " Подключаем автозагрузку менеджера входа "
#systemctl enable gdm.service
systemctl enable gdm.service -f
sleep 1
clear
echo ""
echo " Менеджера входа GDM установлен и подключен в автозагрузку "
elif [[ $i_dm == 4 ]]; then
  echo ""  
  echo " Установка SDDM (менеджера входа) "
pacman -S sddm sddm-kcm --noconfirm
echo " Установка DM (менеджера входа) завершена "
echo ""
echo " Подключаем автозагрузку менеджера входа "
#systemctl enable sddm.service
systemctl enable sddm.service -f
sleep 1 
clear
echo ""
echo " Менеджера входа SDDM установлен и подключен в автозагрузку " 
fi

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
pacman -S networkmanager networkmanager-openvpn network-manager-applet ppp --noconfirm
#pacman -Sy networkmanager networkmanager-openvpn network-manager-applet ppp --noconfirm
echo ""
echo -e "${BLUE}:: ${NC}Подключаем Networkmanager в автозагрузку"	
systemctl enable NetworkManager
echo " NetworkManager успешно добавлен в автозагрузку "
 elif [[ $i_network  == 0 ]]; then
echo " Установка NetworkManager пропущена "
fi

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
systemctl enable dhcpcd   # для активации проводных соединений
echo " Dhcpcd успешно добавлен в автозагрузку "  
elif [[ $x_dhcpcd == 0 ]]; then
  echo ' Dhcpcd не включен в автозагрузку, при необходиости это можно будет сделать уже в установленной системе '
fi

echo ""
echo -e "${BLUE}:: ${NC}Ставим шрифты"
# Ставим шрифты:  https://www.archlinux.org/packages/
pacman -S ttf-dejavu --noconfirm  # Семейство шрифтов на основе Bitstream Vera Fonts с более широким набором символов
pacman -S ttf-liberation --noconfirm  # Шрифты Red Hats Liberation
pacman -S ttf-anonymous-pro --noconfirm  # Семейство из четырех шрифтов фиксированной ширины, разработанных специально с учетом кодирования
pacman -S terminus-font --noconfirm  # Моноширинный растровый шрифт (для X11 и консоли)

### Install NTFS support "NTFS file support (Windows Drives)"
echo ""
echo -e "${BLUE}:: ${NC}Монтирование разделов NTFS и создание ссылок"
pacman -S ntfs-3g --noconfirm  # Драйвер и утилиты файловой системы NTFS

echo ""
echo -e "${BLUE}:: ${NC}Установка базовых программ и пакетов"
echo -e " Установка базовых программ (пакетов): wget, curl, git "
pacman -S wget git --noconfirm  #curl  - пока присутствует в pkglist.x86_64

### Creating sysctl #####
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
vm.swappiness=10

EOF

### Creating sysctl ######
echo -e "${BLUE}:: ${NC}Перемещаем и переименовываем исходный файл /etc/sysctl.conf в /etc/sysctl.d/99-sysctl.conf"
cp /etc/sysctl.conf  /etc/sysctl.conf.back  # Для начала сделаем его бэкап
mv /etc/sysctl.conf /etc/sysctl.d/99-sysctl.conf   # Перемещаем и переименовываем исходный файл

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

echo -e "${BLUE}:: ${NC}Создадим файл /etc/lsb-release (информация о релизе)"
> /etc/lsb-release
cat <<EOF >>/etc/lsb-release 
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
pacman -S zsh zsh-syntax-highlighting zsh-autosuggestions grml-zsh-config --noconfirm
pacman -S zsh-completions zsh-history-substring-search  --noconfirm  
echo 'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> /etc/zsh/zshrc
echo 'source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> /etc/zsh/zshrc
echo 'prompt adam2' >> /etc/zsh/zshrc
clear
echo ""
#echo " Сменим командную оболочку пользователя с bash на zsh? "
echo -e "${BLUE}:: ${NC}Сменим командную оболочку пользователя с Bash на ZSH ?"
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
echo " Пользовательская оболочка ИЗМЕНЕНА (сразу будет), с BASH на на ZSH "
fi
fi 
#sleep 2

#clear
echo -e "${MAGENTA}
  <<< Установка AUR (Arch User Repository) >>> ${NC}"

echo -e "${YELLOW}==> Примечание: ${NC}Сейчас Вы можете пропустить установку "AUR", пункт для установки будет продублирован в следующем скрипте (archmy3l). И Вы сможете установить "AUR Helper" уже из установленной системы." 
echo -e "${YELLOW}==> Внимание! ${NC}Во время установки "AUR", Вас попросят ввести (Пароль пользователя) для $username." 

echo ""
echo -e "${GREEN}==> ${NC}Установка AUR Helper (yay) или (pikaur)"
echo -e "${MAGENTA}:: ${NC} AUR - Пользовательский репозиторий, поддерживаемое сообществом хранилище ПО, в который пользователи загружают скрипты для установки программного обеспечения."
echo " В AUR - есть практически всё, что можно установить на Linux. В том числе и программы, которые для других дистробутивов пришлось бы собирать из исходников. "
echo -e "${CYAN}=> ${BOLD}В сценарии скрипта присутствуют следующие варианты: ${NC}"
echo " 1 - Установка 'AUR'-'yay' с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/yay.git), собирается и устанавливается, то выбирайте вариант - "1". "
echo " 2 - Установка 'AUR'-'pikaur' с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/pikaur.git), собирается и устанавливается, то выбирайте вариант - "2". "
echo -e "${YELLOW}==> ${BOLD}Важно! Подчеркну (обратить внимание)! Pikaur - идёт как зависимость для Octopi. ${NC}"
echo " Будьте внимательны! В этом действии выбор остаётся за вами. "
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления" 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - AUR - yay (git clone),     2 - AUR - pikaur (git clone),     

    0 - Пропустить установку AUR Helper: " in_aur_help  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_aur_help" =~ [^120] ]]
do
    :
done 
if [[ $in_aur_help == 0 ]]; then
clear
echo ""    
echo " Установка AUR Helper пропущена "
elif [[ $in_aur_help == 1 ]]; then
pacman -Syu    
#sudo pacman -Syu
#sudo pacman -S git
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
pacman -Syu    
#sudo pacman -Syu
#sudo pacman -S git
echo ""
echo " Установка AUR Helper - (pikaur) "    
cd /home/$username
git clone https://aur.archlinux.org/pikaur.git
chown -R $username:users /home/$username/pikaur   #-R, --recursive - рекурсивная обработка всех подкаталогов;
chown -R $username:users /home/$username/pikaur/PKGBUILD  #-R, --recursive - рекурсивная обработка всех подкаталогов;
cd /home/$username/pikaur   
sudo -u $username  makepkg -si --noconfirm  
rm -Rf /home/$username/pikaur
clear
echo ""
echo " Установка AUR Helper (pikaur) завершена "
fi

echo ""
echo -e "${BLUE}:: ${NC}Обновим всю систему включая AUR пакеты" 
#echo 'Обновим всю систему включая AUR пакеты'
# Update the entire system including AUR packages
echo -e "${YELLOW}==> Примечание: ${NC}Выберите вариант обновления баз данных пакетов, и системы, в зависимости от установленного вами AUR Helper (yay; pikaur), или пропустите обновления - (если AUR НЕ установлен)."
echo -e "${CYAN}=> ${BOLD}В сценарии скрипта присутствуют следующие варианты: ${NC}"
echo " 1 - Обновление баз данных пакетов, и системы через 'AUR'-'yay', то выбирайте вариант - "1". "
echo " 2 - Установка обновлений баз данных пакетов, и системы через 'AUR'-'pikaur', то выбирайте вариант - "2"."
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
pikaur -Syu
fi

sleep 01
clear
echo ""
echo -e "${GREEN}==> ${NC}Установить  менеджер пакетов для Archlinux?"
echo -e "${BLUE}:: ${NC}Установка Pacman gui (pamac-aur), или Pacman gui (octopi) (AUR)(GTK)(QT)" 
echo -e "${YELLOW}:: ${BOLD}Сейчас Вы можете пропустить установку "Графического менеджера пакетов", пункт для установки будет прописан в следующем скрипте (archmy3l). И Вы сможете установить уже из установленной системы. ${NC}"
echo " Давайте проанализируем действия, которые выполняются. "
echo " 1 - Pacman gui (pamac-aur) - Графический менеджер пакетов (интерфейс Gtk3 для libalpm), тогда укажите "1". "
echo " Графический менеджер пакетов для Arch, Manjaro Linux с поддержкой Alpm, AUR, и Snap. "
echo " 2 - Pacman gui (octopi) - Графический менеджер пакетов (мощный интерфейс Pacman с использованием библиотек Qt5), тогда укажите вариант "2". " 
echo -e "${CYAN}=> ${BOLD}Вариант '2' Напрямую привязан к Установке AUR Helper, если ранее БЫЛ выбран AUR - (pikaur). ${NC}"
echo -e "${YELLOW}:: ${NC}Так как - Подчеркну (обратить внимание)! 'Pikaur' - идёт как зависимость для Octopi." 
echo " 3 - Pacman gui (octopi) - Графический менеджер пакетов (мощный интерфейс Pacman с использованием библиотек Qt5), тогда укажите вариант "3". "
echo -e "${CYAN}=> ${BOLD}Вариант '3' - Если ранее при Установке 'AUR Helper' НЕ БЫЛ УСТАНОВЛЕН AUR - (pikaur). ${NC}"
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
##### pamac-aur ###### 
cd /home/$username
 git clone https://aur.archlinux.org/pamac-aur.git
chown -R $username:users /home/$username/pamac-aur
chown -R $username:users /home/$username/pamac-aur/PKGBUILD 
cd /home/$username/pamac-aur
sudo -u $username  makepkg -si --noconfirm  
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

echo ""
echo -e "${GREEN}==> ${NC}Создаём папки в директории пользователя (Downloads, Music, Pictures, Videos, Documents)."
echo -e "${BLUE}:: ${NC}Создание полного набора локализованных пользовательских каталогов по умолчанию (Загрузки, Шаблоны, Общедоступные, Документы, Музыка, Изображения, Видео) в пределах "HOME" каталога."
echo -e "${CYAN}:: ${NC}По умолчанию в системе Arch Linux в каталоге "HOME" НЕ создаются папки (Загрузки, Шаблоны, Общедоступные, Документы, Музыка, Изображения, Видео), кроме папки Рабочий стол (Desktop)."
echo -e "${CYAN}:: ${NC}Согласно философии Arch, вместо удаления ненужных пакетов, папок, пользователю предложена возможность построить систему, начиная с минимальной основы без каких-либо заранее выбранных шаблонов... "
echo " Давайте проанализируем действия, которые выполняются. "
echo " 1 - Создание каталогов по умолчанию с помощью (xdg-user-dirs), тогда укажите вариант "1". "
echo " xdg-user-dirs - это инструмент, помогающий создать и управлять "хорошо известными" пользовательскими каталогами, такими как папка рабочего стола, папка с музыкой и т.д.. Он также выполняет локализацию (то есть перевод) имен файлов. "
echo " Большинство файловых менеджеров обозначают пользовательские каталоги XDG специальными значками. "
echo " 2(0) - Если Вам не нужны папки в директории пользователя, или в дальнейшем уже в установленной системе, Вы сами создадите папки, тогда выбирайте вариант "0". " 
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
 pacman -S xdg-user-dirs --noconfirm
 xdg-user-dirs-update 
 echo "" 
 echo " Создание каталогов успешно выполнено "
fi

clear
echo ""
echo -e "${GREEN}=> ${BOLD}Вы хотите просмотреть и отредактировать файл /etc/fstab (отвечающий за монтирование разделов при запуске системы)? ${NC}"
echo " Данные действия помогут исключить возможные ошибки при первом запуске системы! "
echo " 1 - Просмотреть и отредактировать файл /etc/fstab. "
echo -e "${MAGENTA}=> ${BOLD}Справка: Файл откроется через редактор <nano>, если нужно отредактировать двигаемся стрелочками вниз-вверх, и правим нужную вам строку. После чего Ctrl-O для сохранения жмём Enter, далее Ctrl-X. Или (Ctrl+X и Y и Enter). ${NC}"
echo " 2 - Просмотреть файл /etc/fstab (БЕЗ редактирования). "
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
#cat < /mnt/etc/fstab | grep -v "Static information"
sleep 3
fi

clear
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
# sudo pacman -Rs go
#pacman -Rs go
pacman --noconfirm -Rs go    # --noconfirm  --не спрашивать каких-либо подтверждений
 echo "" 
 echo " Удаление зависимость 'go' выполнено "
fi

### Clean pacman cache (Очистить кэш pacman) ####
echo ""
echo -e "${BLUE}:: ${BOLD}Очистка кэша pacman ${NC}"
echo -e "${CYAN}=> ${NC}Очистка кэша неустановленных пакетов, и репозиториев..."
pacman --noconfirm -Sc  # --noconfirm (не спрашивать каких-либо подтверждений), -S --sync (Синхронизировать пакеты), -c, --cascade (удалить пакеты и все пакеты, которые зависят от них),
pacman -Scc  # Очистка кэша пакетов - удалить вообще все файлы из кэша
#pacman --noconfirm -Scc
echo -e "${CYAN}=> ${NC}Удаление неиспользуемых зависимостей 'pacman -Qdtq'..."
#pacman --noconfirm -Rcsn $(pacman -Qdtq) # --noconfirm (не спрашивать каких-либо подтверждений), -R --remove (Удалить пакет(ы) из системы), -c, --cascade (удалить пакеты и все пакеты, которые зависят от них), -s, --recursive (удалить ненужные зависимости), -n, --nosave (удалить конфигурационные файлы)
# "(Clean orphan)" "pacman -Rns \$(pacman -Qqtd)"
# pacman -Rns $(pacman -Qqtd)
pacman -Rsn $(pacman -Qdtq) && rm -rf ~/.cache/thumbnails/* && rm -rf ~/.build/*
#pacman -Rsn $(pacman -Qdtq) 
#rm -rf ~/.cache/thumbnails/*
#rm -rf ~/.build/*
# fc-cache -vf
#pacman -Scc && sudo pacman -Rsn $(pacman -Qdtq) && rm -rf ~/.cache/thumbnails/* && rm -rf ~/.build/*

clear             
echo -e "${GREEN}
  <<< Поздравляем! Установка завершена. Перезагрузите систему. >>> ${NC}"

echo -e "${BLUE}:: ${BOLD}Посмотрим дату и время ... ${NC}"
date
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'     # одновременно отображает дату и часовой пояс

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

echo -e "${BLUE}:: ${BOLD}Теперь вам надо ввести exit, затем reboot, чтобы перезагрузиться ${NC}"
exit
exit
  


