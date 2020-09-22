#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
# Выполните команду с правами суперпользователя:
#EDITOR=nano visudo

### Installer default language (Язык установки по умолчанию)
#ARCHMY1_LANG="russian"
ARCHMY2_LANG="russian"
#ARCHMY3_LANG="russian"
#ARCHMY4_LANG="russian"

script_path=$(readlink -f ${0%/*})

umask 0022

##################################################################
##### <<<Arch Linux Fast Install LegasyBIOS (arch2020)>>>    #####
##### Скрипты 'arch_2020' созданы на основе 2-х (скриптов):  #####
#####   'ordanax/arch2018', и 'archlinux-script-install' -   #####
##### (Poruncov,Grub-Legacy - 2020). При выполнении сценария #####
##### (скрипта), Вы получаете возможность быстрой установки  #####
#####  ArchLinux с вашими личными настройками (при условии,  #####
##### что Вы его изменили под себя, в противном случае - с   #####
##### моими настройками).                                    #####       
#####  В скрипте прописана установка grub для LegasyBIOS, с  #####
##### выбором DE/WM, а также DM (Менеджера входа), и т.д..   #####  
##### Этот скрипт находится в процессе 'Внесение поправок в  ####
#### наводку орудий по результатам наблюдений с наблюдате-   ####
#### льных пунктов'.                                         ####
#### Автор не несёт ответственности за любое нанесение вреда ####
#### при использовании скрипта.                              ####
#### Installation guide - Arch Wiki  (referance):            ####
#### https://wiki.archlinux.org/index.php/Installation_guide ####
#### Проект (project): https://github.com/ordanax/arch2018   ####
#### Лицензия (license): LGPL-3.0                            #### 
#### (http://opensource.org/licenses/lgpl-3.0.html           ####
#### В разработке принимали участие (author) :               ####
#### Алексей Бойко https://vk.com/ordanax                    ####
#### Степан Скрябин https://vk.com/zurg3                     ####
#### Михаил Сарвилин https://vk.com/michael170707            ####
#### Данил Антошкин https://vk.com/danil.antoshkin           ####
#### Юрий Порунцов https://vk.com/poruncov                   ####
#### Jeremy Pardo (grm34) https://www.archboot.org/          ####
#### Marc Milany - 'Не ищи меня 'Вконтакте',                 ####
#####                в 'Одноклассниках'' нас нету, ...       ####
#### Releases ArchLinux:                                     ####
####    https://www.archlinux.org/releng/releases/           ####
#################################################################

# ======================================================================
#echo 'Автоматическое обнаружение ошибок.'
# Эта команда остановит выполнение сценария после сбоя команды и будет отправлен код ошибки:
#set -e
#set -e -u
set -e "\n${RED}Error: ${YELLOW}${*}${NC}"
# ----------------------------------------------------------------------
# Если этот параметр '-e' задан, оболочка завершает работу, когда простая команда в списке команд завершается ненулевой (FALSE). Это не делается в ситуациях, когда код выхода уже проверен (if, while, until,||, &&)
# Встроенная команда set:
# https://www.sites.google.com/site/bashhackers/commands/set
# ======================================================================
#####################################################
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

### Display error, cleanup and kill (Ошибка отображения, очистка и убийство)
_error() {
    echo -e "\n${RED}Error: ${YELLOW}${*}${NC}"
    _note "${MSG_ERROR}"
    sleep 1; _cleanup; _exit_msg; kill -9 $$
}

### Cleanup on keyboard interrupt (Очистка при прерывании работы клавиатуры)
_trap() {
trap '_error ${MSG_KEYBOARD}' 1 2 3 6
}
#trap "set -$-" RETURN; set +o nounset
# Или
#trap "set -${-//[is]}" RETURN; set +o nounset
#..., устраняя недействительные флаги и действительно решая эту проблему!

### Reboot with 10s timeout (Перезагрузка с таймаутом 10 секунд)
_reboot() {
    for (( SECOND=10; SECOND>=1; SECOND-- )); do
        echo -ne "\r\033[K${GREEN}${MSG_REBOOT} ${SECOND}s...${NC}"
        sleep 1
    done
    reboot; exit 0
}

### Say goodbye (Распрощаться)
_exit_msg() {
    echo -e "\n${GREEN}<<< ${BLUE}${APPNAME} ${VERSION} ${BOLD}by \
${AUTHOR} ${RED}under ${LICENSE} ${GREEN}>>>${NC}"""
}

###################################################################
# Information (Информация)
_arch_fast_install_banner_2() {
    echo -e "${YELLOW}==> ИНФОРМАЦИЯ! ******************************************** ${NC}  
Продолжается работа скрипта - основанного на сценарии (скрипта)'Arch Linux Fast Install LegasyBios (arch2018)'.
Происходит установка первоначально необходимого софта (пакетов), запуск необходимых служб, запись данных в конфиги (hhh.conf) по настройке системы.
В процессе работы сценария (скрипта) Вам будет предложено выполнить следующие действия:
Ввести имя пользователя (username), ввести имя компьютера (hostname), а также установить пароль для пользователя (username) и администратора (root). 
Настроить состояние аппаратных часов 'UTC или Localtime', но Вы можете отказаться и настроить их уже из системы Arch'a.
Будут заданы вопросы: на установку той, или иной утилиты (пакета), и на какой аппаратной базе будет установлена система (для установки Xorg 'обычно называемый просто X' и драйверов) - Будьте Внимательными! 
 Смысл в том, что все изменения Вы делаете предварительно в самом скрипте и получаете возможность быстрой установки утилит (пакетов), которые Вы решили установить (при условии, что Вы его изменили под себя, в противном случае скрипт установит софт (пакеты) прописанный изначально.
Не переживайте софт (пакеты) скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. В любой ситуации выбор всегда за вами.
${BLUE}===> ******************************************************* ${NC}"   
} 
# *******************************************************************
### Display banner (Дисплей баннер)
_arch_fast_install_banner_2

sleep 02
echo ""
echo -e "${GREEN}=> ${NC}Для проверки интернета можно пропинговать какой-либо сервис" 
#echo 'Для проверки интернета можно пропинговать какой-либо сервис'
# To check the Internet, you can ping a service
ping -c2 archlinux.org
# Например Яндекс или Google: 
#ping -c5 www.google.com
#ping -c5 ya.ru

echo -e "${CYAN}==> ${NC}Если пинг идёт едем дальше ... :)"
#echo 'Если пинг идёт едем дальше ... :)'
# If the ping goes we go further ... :)

### Specified Time
echo ""
echo -e "${BLUE}:: ${NC}Синхронизация системных часов"  
#echo '2.3 Синхронизация системных часов'
# Syncing the system clock
#echo 'Синхронизируем наши системные часы, включаем ntp, если надо сменим часовой пояс'
# Sync our system clock, enable ntp, change the time zone if necessary
timedatectl set-ntp true

echo -e "${BLUE}:: ${NC}Посмотрим статус службы NTP (NTP service)"
#echo 'Посмотрим статус службы NTP (NTP service)'
# Let's see the NTP service status
timedatectl status

### Specified Time
echo -e "${BLUE}:: ${NC}Посмотрим текущее состояние аппаратных и программных часов"
#echo 'Посмотрим текущее состояние аппаратных и программных часов'
# Let's see the current state of the hardware and software clock
timedatectl
#curl https://ipapi.co/timezone  # используем геолокацию (в каком часовом поясе) 
#curl http://ip-api.com/line?fields=timezone 
#timedatectl set-timezone Europe/Moscow     # установка часового пояса
#timedatectl set-timezone $timezone     # установка часового пояса

echo ""
echo -e "${BLUE}:: ${NC}Обновим вашу систему (базу данных пакетов)"
#echo "Обновим вашу систему (базу данных пакетов)"
# Update your system (package database)
echo -e "${YELLOW}:: ${NC}Загружаем базу данных пакетов независимо от того, есть ли какие-либо изменения в версиях или нет."
#echo 'Загружаем базу данных пакетов независимо от того, есть ли какие-либо изменения в версиях или нет.'
# Loading the package database regardless of whether there are any changes in the versions or not.
echo ""
pacman -Syyu  --noconfirm  
# ------------------------------------------------------------
# Полный апдейт системы:
#pacman -Syyuu  --noconfirm
# Не рекомендуется использовать sudo pacman -Syyu всё время!
# --------------------------------------------------------------
#pacman -Syy --noconfirm --noprogressbar --quiet
# Синхронизация и обновление пакетов (-yy принудительно обновить даже если обновленные)
# -------------------------------------------------------------
# Команды управления ARCH Linux:
# sudo pacman -Syu   - Обновление баз данных пакетов и полное обновление системы
# sudo pacman -Sy       - Обновление баз данных пакетов
# sudo pacman -Su       - Полное обновление системы
# pacman -Ss пакет             - Поиск пакетов
# sudo pacman -S пакет       - Установить пакет
# sudo pacman -Sw пакет     - Загрузить пакет, но не устанавливать
# sudo pacman -Rsn пакет      - Удалить пакет с зависимостями (не используемыми другими пакетами) и его конфигурационные файлы
# sudo pacman -Rs пакет       - Удалить пакет с зависимостями (не используемыми другими пакетами)
# sudo pacman -R пакет       - Удалить пакет
# sudo pacman -Qdtq    - Удаление всех пакетов-сирот
# sudo pacman -Qdt      - Список всех пакетов-сирот
# sudo pacman -Sc       - Очистка кэша неустановленных пакетов
# sudo pacman -Scc     - Очистка кэша пакетов
# pacman -Qqe       - Список установленных пакетов в системе
# ==============================================================

### Hostname
### Username
sleep 01
clear
echo ""
echo -e "${GREEN}==> ${NC}Вводим название компьютера (host name), и имя пользователя (user name)"
#echo -e "${BLUE}:: ${NC}Вводим имя компьютера (host name), и имя пользователя (user name)"
#echo 'Вводим имя компьютера (hostname), и имя пользователя (username)'
#echo 'Enter the computer name and user name'
# Enter the computer name
# Enter your username
#read -p "Введите имя компьютера: " hostname
#read -p "Введите имя пользователя: " username
echo -e "${MAGENTA}=> ${BOLD}Используйте в названии (host name) только буквы латинского алфавита (a-zA-Z0-9) (можно с заглавной буквы). Латиница - это английские буквы. Кириллица - русские. ${NC}" 
#echo -e "${MAGENTA}==> ${NC}" 
echo ""
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " => Введите имя компьютера: " hostname
echo ""
echo -e "${MAGENTA}=> ${BOLD}Используйте в имени (user name) только буквы латинского алфавита (в нижнем (маленькие) регистре (a-z)(a-z0-9_-)), и цифры ${NC}"	        
#echo -e "${MAGENTA}==> ${NC}"
echo ""                    
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
read -p " => Введите имя пользователя: " username 

### Set Hostname
echo -e "${BLUE}:: ${NC}Прописываем имя компьютера"
#echo 'Прописываем имя компьютера'
# Entering the computer name
echo $hostname > /etc/hostname
#echo "имя_компьютера" > /etc/hostname
#echo HostName > /etc/hostname
# ----------------------------------------------------
# Разберём команду для localhost >>>
# Вместо ArchLinux впишите свое название
# echo "ArchLinux" > /etc/hostname  - Можно написать с Заглавной буквы.
# echo имя_компьютера > /etc/hostname
# =======================================================

### Clear the HOME FOLDER
echo ""
echo -e "${RED}==> ${NC}Очистить папку конфигурации (настроек), кеш, и скрытые каталоги в /home/$username от старой установленной системы? "
#echo 'Очистить папку конфигурации, кеш, и скрытые каталоги в /home/$username от старой установленной системы?' 
# Clear the config folder, cache, and hidden directories in /home/$username from the old installed system? 
echo -e "${CYAN}:: ${BOLD}Если таковая присутствует, и не была удалена при создании новой разметки диска. ${NC}"
#echo 'Если таковая присутствует, и не была удалена при создании новой разметки диска.' 
# If present, and was not deleted when creating the new disk markup.
echo -e "${YELLOW}==> ${NC}Будьте осторожны! Если Вы сомневаетесь в своих действиях, просто пропустите этот пункт."
#echo 'Будьте осторожны! Если Вы сомневаетесь в своих действиях, просто пропустите этот пункт.'
# Be careful! If you are in doubt about your actions, just skip this point.
echo ""
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") " 
#  read -p  " 1 - Да очистить папки конфигов, 0 - Нет пропустить очистку: " i_rm   # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
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
#echo ""
echo " Очистка пропущена "
elif [[ $i_rm == 1 ]]; then
clear    
rm -rf /home/$username/.*
echo ""
echo " Очистка завершена "
fi 

### Set Timezone
echo ""
echo -e "${GREEN}==> ${NC}Устанавливаем ваш часовой пояс (localtime)."
#echo -e "${BLUE}:: ${NC}Устанавливаем ваш часовой пояс"
#echo 'Устанавливаем ваш часовой пояс'
# Setting your time zone
echo " Всё завязано на времени, поэтому очень важно, чтобы часы шли правильно... :) "
echo -e "${BLUE}:: ${BOLD}Для начала вот ваши данные по дате, времени и часовому поясу: ${NC}"
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'    # одновременно отображает дату и часовой пояс
#rm -v /etc/localtime  # rm  - Удаление файлов и директорий, -v или --verbose - Выводить информацию об удаляемых файлах
#ln -s /usr/share/zoneinfo/Europe/Moscow
#ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
#ls /usr/share/zoneinfo
#ls /usr/share/zoneinfo/Europe
# -------------------------------------------------
echo -e "${MAGENTA}:: ${BOLD}Мир состоит из шести частей света: Азия, Африка, Америка, Европа, Австралия и Океания, Антарктика (Антарктида с прибрежными морями и островами). Иногда Океанию и Арктику выделяют в отдельные части света. ${NC}"
#echo " ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime "
echo -e "${CYAN}:: ${NC}Наиболее популярный и поддерживаемый в большинстве дистрибутивов способ установки часового пояса для всех пользователей с помощью символической ссылки (symbolic link) "/etc/localtime" - на файл нужного часового пояса."
echo -e "${CYAN}:: ${NC}Для создания символической ссылки используется команда "ln -sf" или "ln -svf"."
echo " ln -sf /usr/share/zoneinfo/Частъ Света/Город /etc/localtime "  # (где Region - ваш регион, City - ваш город)
echo " ln -sf /usr/share/zoneinfo/Зона/Субзона /etc/localtime "
echo " ln -sf /usr/share/zoneinfo/Регион/Город /etc/localtime "
#echo " ln -svf /usr/share/zoneinfo/$timezone /etc/localtime "
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
#timedatectl set-timezone $timezone     # установка часового пояса
ls -lh /etc/localtime  # для просмотра символической ссылки, которая указывает на текущий часовой пояс, используемый в системе 
#cat /etc/timezone   # просмотреть файл /etc/timezone
#timedatectl    # команда отображает обзор системы, включая часовой пояс
echo ""
echo -e "${GREEN}=> ${BOLD}Это ваш часовой пояс (timezone) - '$timezone' ${NC}"
#echo -e "${GREEN}=> ${NC}Это ваш часовой пояс (timezone) - '$timezone' "
#echo " => Это ваш часовой пояс (timezone) - '$timezone' "
echo -e "${BLUE}:: ${BOLD}Ваши данные по дате, времени и часовому поясу: ${NC}"
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'    # одновременно отображает дату и часовой пояс

# -------------------------------------------------
# Чтобы изменить часовой пояс, создайте символическую ссылку /etc/localtime на соответствующий часовой пояс в /usr/share/zoneinfo/:
#ln -sf /usr/share/zoneinfo/zoneinfo /etc/localtime
# Флаг -s позволяет создавать символическую ссылку, флаг -f удаляет существующий файл назначения, который в этом случае является старая символьная ссылка /etc/localtime.
# --------------------------------------------------
#ln -svf /usr/share/zoneinfo/'$timezone' /etc/localtime
###ln -svf /usr/share/zoneinfo/Europe/Moscow /etc/localtime  # -эта команда
##ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
#timedatectl set-ntp true
#ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
#ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
#ln -svf /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime
#ln -svf /usr/share/zoneinfo/Europe/Kiev /etc/localtime
# -------------------------------------------------------------
# Если Вы живите не в московском временной поясе, то Вам нужно выбрать подходящий ваш часовой пояс.
# Смотрим доступные пояса: 
#ls /usr/share/zoneinfo
#ls /usr/share/zoneinfo/Нужный_Регион
# Разберём команду для localtime >>>
# Выбираем часовой пояс:
#ln -s /usr/share/zoneinfo/Зона/Субзона /etc/localtime
#ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
# Эта команда создает, так называемую символическую ссылку выбранного пояса в папке /etc
# Континент:
# https://ru.wikipedia.org/wiki/%D0%9A%D0%BE%D0%BD%D1%82%D0%B8%D0%BD%D0%B5%D0%BD%D1%82
# Список часовых поясов базы данных tz:
# https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
# Символические и жесткие ссылки Linux:
# https://losst.ru/simvolicheskie-i-zhestkie-ssylki-linux
# ===============================================================
### Specified Time
echo -e "${BLUE}:: ${NC}Синхронизируем аппаратное время с системным"
echo " Устанавливаются аппаратные часы из системных часов. "
# Кроме того, он обновляет /etc / adjtime или создает его.
#echo 'Синхронизируем аппаратное время с системным' 
# Synchronizing hardware time with system time
# Даже если аппаратное время настроено в режиме времени UTC, команда hwclock по умолчанию отображает местное время
# hwclock
# Чтобы опеределить текущее аппаратное время компьютера
# hwclock -r
# Считывание аппаратных часов
# hwclock --show
# Если системное время отличается от аппаратного, то можно выравнить системное время до значения аппаратного (аппаратное время - это время которое выставлено в BIOS).
# hwclock --hctosys
# Синхронизируем аппаратное время с системным!
# Выполним hwclock, чтобы сгенерировать файл /etc/adjtime, в котором хранятся соответсвующие настройки
# Эта команда предполагает, что аппаратные часы настроены в формате UTC.
hwclock --systohc
# Порой значение аппаратного времени может сбиваться — выровняем!
# hwclock --adjust

### Specified Time
echo ""
echo -e "${GREEN}==> ${NC}Настроим состояние аппаратных и программных часов."
#echo -e "${BLUE}:: ${NC}Настроим состояние аппаратных и программных часов"
#echo 'Настроим состояние аппаратных и программных часов'
# Setting up the state of the hardware and software clock    
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если сейчас ваш часовой пояс настроен правильно, или Вы не уверены в правильности выбора! "
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
# ============================================================================
# Windows и Linux работают по-разному с этими двумя часами. 
# Есть два способа работы:
# UTC - и аппаратные, и программные часы идут по Гринвичу. 
# То есть часы дают универсальное время на нулевом часовом поясе. 
# Например, если у вас часовой пояс GMT+3, Киев, то часы будут отставать на три часа. 
# А уже пользователи локально прибавляют к этому времени поправку на часовой пояс, например, плюс +3. 
# Каждый пользователь добавляет нужную ему поправку. Так делается на серверах, 
# чтобы каждый пользователь мог получить правильное для своего часового пояса время.
# localtime - в этом варианте программные часы тоже идут по Гринвичу, 
# но аппаратные часы идут по времени локального часового пояса. 
# Для пользователя разницы никакой нет, все равно нужно добавлять поправку на свой часовой пояс. 
# Но при загрузке и синхронизации времени Windows вычитает из аппаратного времени 3 часа 
# (или другую поправку на часовой пояс), чтобы программное время было верным.
# Вы можете пропустить этот шаг, если не уверены в правильности выбора.
# ============================================================================
echo ""
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - UTC, 2 - Localtime, 0 - Пропустить настройку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - UTC,    2 - Localtime, 

    0 - Пропустить настройку: " prog_set  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_set" =~ [^120] ]]
do
    :
done
if [[ $prog_set == 1 ]]; then
hwclock --systohc --utc
  echo ""
  echo " Вы выбрали hwclock --systohc --utc "
  echo " UTC - часы дают универсальное время на нулевом часовом поясе " 
elif [[ $prog_set == 2 ]]; then
hwclock --systohc --local
  echo ""
  echo " Вы выбрали hwclock --systohc --localtime "
  echo " Localtime - часы идут по времени локального часового пояса " 
elif [[ $prog_set == 0 ]]; then
  echo ""  
  echo ' Настройка пропущена. '
fi
# ---------------------------------------------------------------------------
# Где в Arch жёстко прописать чтоб апаратное время равнялось локальному?
# Я делаю так:
# sudo hwclock --localtime
# sudo timedatectl set-local-rtc 1
#hwclock --systohc --utc
#hwclock --systohc --local
# Команды для исправления уже в установленной системе:
# Исправим ошибку времени, если она есть
#sudo timedatectl set-local-rtc 1 --adjust-system-clock
# Как вернуть обратно -
#sudo timedatectl set-local-rtc 0
# Для понимания сути команд статья с примерами -
# https://losst.ru/sbivaetsya-vremya-v-ubuntu-i-windows
# https://www.ekzorchik.ru/2012/04/hardware-time-settings-hwclock/
# ============================================================================

### Specified Time
echo ""
echo -e "${BLUE}:: ${NC}Посмотрим обновление времени (если настройка не была пропущена)"
#echo 'Посмотрим обновление времени (если настройка не была пропущена)'
# See the time update (if the setting was not skipped)
timedatectl show
#timedatectl | grep Time
#timedatectl set-timezone Europe/Moscow

### Set Hosts 
echo ""
echo -e "${BLUE}:: ${NC}Изменяем имя хоста"
#echo 'Изменяем имя хоста'
# Changing the host name
echo "127.0.0.1	localhost.(none)" > /etc/hosts
echo "127.0.1.1	$hostname" >> /etc/hosts
echo "::1	localhost ip6-localhost ip6-loopback" >> /etc/hosts
echo "ff02::1 ip6-allnodes" >> /etc/hosts
echo "ff02::2 ip6-allrouters" >> /etc/hosts
# -----------------------------------------------------------
# echo "127.0.1.1 имя_компьютера" >> /etc/hosts
# - Можно написать с Заглавной буквы.
# Это дейсвие не обязательно! Мы можем это сделаем из установленной ситемы, если данные не пропишутся автоматом.
# ============================================================

### Set Locale
echo -e "${BLUE}:: ${NC}Добавляем русскую локаль системы"
#echo 'Добавляем русскую локаль системы'
# Adding the system's Russian locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 
# -----------------------------------------------------------
# Есть ещё команды по добавлению русскую локаль в систему:
#echo -e "en_US.UTF-8 UTF-8\nru_RU.UTF-8 UTF-8" >> /etc/locale.gen
# Можно раскомментирвать нужные локали (и убирать #)
#sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
#sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen
# ===========================================================

### Set Locale
echo -e "${BLUE}:: ${NC}Обновим текущую локаль системы"
#echo 'Обновим текущую локаль системы'
# Update the current system locale
locale-gen
# Мы ввели locale-gen для генерации тех самых локалей.
#
### Set Locale
sleep 02
echo -e "${BLUE}:: ${NC}Указываем язык системы"
#echo 'Указываем язык системы'
# Specify the system language
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf
#echo 'LANG="en_US.UTF-8"' > /etc/locale.conf
#export LANG=ru_RU.UTF-8
#export LANG=en_US.UTF-8
# ---------------------------------------------------------
# Эта команда сама пропишет в файлике locale.conf нужные нам параметры.
# Ну и конечно, раз это переменные окружения, то мы можем установить их временно в текущей сессии терминала
# При раскомментировании строки '#export ....', - Будьте Внимательными!
# Как назовёшь, так и поплывёшь...
# When you uncomment the string '#export....', Be Careful!
# As you name it, you will swim...
# ==========================================================

### Set Vconsole
echo -e "${BLUE}:: ${NC}Вписываем KEYMAP=ru FONT=cyr-sun16"
#echo 'Вписываем KEYMAP=ru FONT=cyr-sun16'
# Enter KEYMAP=ru FONT=cyr-sun16
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf
echo 'FONT_MAP=' >> /etc/vconsole.conf
echo 'CONSOLEMAP' >> /etc/vconsole.conf
echo 'COMPRESSION="lz4"' >> /etc/mkinitcpio.conf
#-----------------------------------------------------------
#echo 'Вписываем KEYMAP=ru FONT=ter-v16n'
#echo 'KEYMAP=us' >> /etc/vconsole.conf
#echo 'FONT=ter-v16n' >> /etc/vconsole.conf
# Можно изменить шрифт:
# pacman -S terminus-font - качаем шрифт терминус
#loadkeys us
#pacman -Syy
#pacman -S terminus-font --noconfirm
#setfont ter-v16b
# nano /etc/vconsole.conf - устанавливаем шрифт и переключение клавиатуры по Ctrl-Shift
# (только в консоли, я не уверен нужно ли это вообще, но помню в убунте надо было писать на русском "да/нет").
# Если есть желание экспериментировать, консольные шрифты находятся в /usr/share/kbd/consolefonts/ смотрим с помощью ls 
# ============================================================

#clear
echo ""
echo -e "${GREEN}==> ${NC}Создадим загрузочный RAM диск (начальный RAM-диск)"
#echo 'Создадим загрузочный RAM диск (начальный RAM-диск)'
# Creating a bootable RAM disk (initial RAM disk)
echo -e "${MAGENTA}:: ${BOLD}Arch Linux имеет mkinitcpio - это Bash скрипт используемый для создания начального загрузочного диска системы. ${NC}"
# Arch Linux has mkinitcpio, a Bash script used to create the system's initial boot disk.
echo -e "${CYAN}:: ${NC}mkinitcpio является модульным инструментом для построения initramfs CPIO образа, предлагая много преимуществ по сравнению с альтернативными методами. Предоставляет много возможностей для настройки из командной строки ядра без необходимости пересборки образа."
# mkinitcpio is a modular tool for building an initramfs CPIO image, offering many advantages over alternative methods.
# Provides many options for configuring the kernel from the command line without having to rebuild the image.
echo -e "${YELLOW}:: ${NC}Чтобы избежать ошибки при создании RAM (mkinitcpio -p), вспомните какое именно ядро Вы выбрали ранее."
# To avoid an error when creating RAM (mkinitcpio -p), remember which core you selected earlier.
echo " Будьте внимательными! Здесь варианты создания RAM-диска, с конкретными ядрами. "
# Be careful! Here are options for creating a RAM disk with specific cores.
#echo -e "${MAGENTA}==> ${BOLD}Давайте поcмотрим, какое ядро сейчас используется в установочном .iso ${NC}"
# Let's see which kernel is currently being used in the installation .iso
#uname -r
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления" 
#echo 'Установка производится в порядке перечисления'
# Installation Is performed in the order listed  
#pacman -S --needed mkinitcpio 
echo ""
while
# echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")  "
# read -p " 1 - для ядра LINUX, 2 - для ядра LINUX_HARDENED, 3 - для ядра LINUX_LTS, 4 - для ядра LINUX_ZEN, 0 - Пропустить создание загрузочного RAM диска: " x_ram  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
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
sleep 01
clear
echo ""
# ----------------------------------------------------------
# Команда: mkinitcpio -p linux-lts  - применяется, если Вы устанавливаете
# стабильное ядро (linux-ltc), иначе вай..вай... может быть ошибка!
# Команда: mkinitcpio -p linux-zen  - применяется, если Вы устанавливаете
# стабильное ядро (linux-zen), иначе вай..вай... может быть ошибка!  
# В остальных случаях при установке Arch'a с ядром (linux) идущим вместе   
# с устанавливаемым релизом (rolling release) применяется команда : mkinitcpio -p linux.
# Ошибки при создании RAM mkinitcpio -p linux. Как исправить?
# https://qna.habr.com/q/545694
# -------------------------------------------------------------
# Традиционно ядро отвечает за обнаружение всего оборудования и выполняет задачи на ранних этапах процесса загрузки до монтирования корневой файловой системы.
# В настоящее время корневая файловая система может быть на широком диапазоне аппаратных средств от SCSI до SATA и USB дисков, управляемых различными контроллерами от разных производителей. Кроме того корневая файловая система может быть зашифрована или сжата, находиться в RAID массиве или группе логических томов. Простой способ справиться с этой сложностью является передача управления в пользовательском пространстве: начальный загрузочный диск.
# Параметр -p (сокращение от preset) указывает на использование preset файла из /etc/mkinitcpio.d (т.е. /etc/mkinitcpio.d/linux.preset для linux). preset файл определяет параметры сборки initramfs образа вместо указания файла конфигурации и выходной файл каждый раз.
# Warning: preset файлы используются для автоматической пересборки initramfs после обновления ядра. Будьте внимательны при их редактировании.
# Варианты создания initcpio:
# Пользователи могут вручную создать образ с помощью альтернативного конфигурационного файла. Например, следующее будет генерировать initramfs образ в соответствии с /etc/mkinitcpio-custom.conf и сохранит его в /boot/linux-custom.img.
# mkinitcpio -c /etc/mkinitcpio-custom.conf -g /boot/linux-custom.img
# Если необходимо создать образ с ядром отличным от загруженного.
# Доступные версии ядер можно посмотреть в /usr/lib/modules.
# -------------------------------------------------------------
# После этого нужно подредактировать хуки keymap.
# Откройте файл /etc/mkinitcpio.conf:  
#nano /etc/mkinitcpio.conf
# Ищём строчку HOOKS и добавляем в конце 3 хука (внутри скобок):
#HOOKS = (... consolefont keymap systemd)
# ----------------------------------------------------------
#/etc/mkinitcpio.conf - основной конфигурационный файл mkinitcpio. Кроме того, в каталоге /etc/mkinitcpio.d располагаются preset файлы (e.g. /etc/mkinitcpio.d/linux.preset).
# Ссылка на Wiki :
#https://wiki.archlinux.org/index.php/Mkinitcpio_%28%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9%29
#https://ru.wikipedia.org/wiki/Initrd
# ==============================================================

### Set Root passwd
### Root Password
echo -e "${GREEN}==> ${NC}Создаём root пароль (Root Password)"
#echo 'Создаём root пароль'
# Creating a root password
echo " Пароль должен содержать от 6 до 15 символов, включающих цифры (1-0) и знаки (!'':[@]),     
        и латинские буквы разного регистра! "
echo -e "${MAGENTA}=> ${BOLD}По умолчанию, на большинстве систем Linux в консоле не показывается введенный пароль. 
Это сделано из соображений безопасности, чтобы никто не мог увидеть длину вашего пароля.${NC}"                 
echo " => Введите Root Password (Пароль суперпользователя), вводим пароль 2 раза "
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
passwd
# --------------------------------------------------------------------------
# Пример вывода применённой команды >>> $ passwd После чего дважды новый пароль.
# Список пользователей в Linux хранится в файле /etc/passwd, вы можете без труда открыть его и посмотреть, пароли же выделены в отдельный файл - /etc/shadow. 
# Этот файл можно открыть только с правами суперпользователя, и, более того, пароли здесь хранятся в зашифрованном виде, поэтому узнать пароль Linux не получиться, а поменять вручную будет сложно.
# В большинстве случаев смена пароля выполняется с помощью утилиты passwd. Это очень мощная утилита, она позволяет не только менять пароль, но и управлять сроком его жизни.
# Как сменить пароль в Linux :
# https://losst.ru/kak-smenit-parol-v-linux
# ============================================================================

### GRUB
#clear
echo ""
echo -e "${GREEN}==> ${NC}Установить (bootloader) загрузчик GRUB(legacy)?"
#echo 'Установить загрузчик GRUB(legacy)?'
# Install the boot loader GRUB(legacy)
echo -e "${BLUE}:: ${NC}Установка GRUB2 в процессе установки Arch Linux"
#echo 'Установка GRUB2 в процессе установки Arch Linux'
# Install GRUB2 during the installation process, Arch Linux
echo " 1 - Установка полноценной BIOS-версии загрузчика GRUB(legacy), тогда укажите "1". "
echo " Файлы загрузчика будут установлены в каталог /boot. Код GRUB (boot.img) будет встроен в начальный сектор, а загрузочный образ core.img в просвет перед первым разделом MBR, или BIOS boot partition для GPT. "
echo " 2 - Если нужно установить BIOS-версию загрузчика из-под системы, загруженной в режиме UEFI, тогда укажите "2". " 
echo " В этом варианте требуется принудительно задать программе установки нужную сборку GRUB: 
        Пример - grub-install --target=i386-pc /dev/sdX  #sda sdb sdc sdd. "
echo -e "${YELLOW}:: ${BOLD}В этих вариантах большого отличия нет, кроме команд выполнения. Не зависимо от вашего выбора нужно ввести маркер sdX-диска куда будет установлен GRUB.${NC}"          
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если у вас уже имеется BOOT раздел от другой (предыдущей) системы gnu-linux, с установленным на нём GRUB."
#echo 'Вы можете пропустить этот шаг, если у вас уже имеется BOOT раздел от другой (предыдущей) системы gnu-linux, с установленным на нём GRUB.'
# You can skip this step if you already have a BOOT partition from another (previous) gnu-linux system with GRUB installed on it.
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами. "
# Be careful! In any situation, the choice is always yours.
echo ""
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - Установить GRUB(legacy), 2 - GRUB --target=i386-pc, 0 - Нет пропустить: " i_grub  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
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
# Файлы и утилиты для установки GRUB2 содержатся в пакете grub, и устанавливаются командой:
pacman -S grub --noconfirm
#pacman -S grub --noconfirm --noprogressbar --quiet 
uname -rm
lsblk -f
echo ""
echo -e "${YELLOW}:: ${BOLD}Примечание: /dev/sdX- диск (а не раздел ), на котором должен быть установлен GRUB. ${NC}"
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
echo -e "${YELLOW}:: ${BOLD}Примечание: /dev/sdX- диск (а не раздел ), на котором должен быть установлен GRUB. ${NC}"
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
# ------------------------------------------------------------------
# Установка boot loader'а (загрузчика grub)
# Их существует несколько, но grub, наверное самый популярный в Linux.
# (или grub-install /dev/sdb , или grub-install /dev/sdс в зависимости от маркировки вашего диска, флешки куда будет установлен загрузчик grub (для BIOS))
# Загрузчик - первая программа, которая загружается с диска при старте компьютера, и отвечает за загрузку и передачу управления ядру ОС. 
# Ядро, в свою очередь, запускает остальную часть операционной системы.
# -----------------------------------------------------------------
# Если Вы получили сообщение об ошибке, то используйте команду:
# grub-install --recheck /dev/sda
# Также в некоторых случаях может помочь вариант:
# grub-install --recheck --no-floppy /dev/sda
# Записываем загрузчик в MBR (Master Boot Record) нашего внутреннего накопителя.
#grub-install --target=i386-pc --force --recheck /dev/sda 
#grub-install --target=i386-pc /dev/sda   #(для платформ i386-pc) 
#grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
#read -p " => Укажите диск (sda/sdb например sda или sdb) : " cfd
#grub-install /dev/$cfd  #sda sdb sdc sdd
# -------------------------------------------------------------------
# Если вы хотите установить Grub на флешку в MBR, то тут тоже нет проблем просто примонтируйте флешку и выполните такую команду:
#sudo grub-install --root-directory=/mnt/USB/ /dev/sdb
# Здесь /mnt/USB - папка, куда была смотирована ваша флешка, а /seb/sdb - сама флешка. Только здесь есть одна проблема, конфигурационный файл придется делать вручную.
# GRUB (Русский)
# https://wiki.archlinux.org/index.php/GRUB_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# https://losst.ru/nastrojka-zagruzchika-grub
# =====================================================================

### Install Microcode
#clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Микрокод для процессора INTEL_CPU, AMD_CPU?"
#echo 'Установить Микрокод для процессора INTEL_CPU, AMD_CPU?'
# Install the Microcode for the CPU INTEL_CPU, AMD_CPU?
echo -e "${BLUE}:: ${BOLD}Обновление Microcode (matching CPU) ${NC}"
#echo 'Обновление Microcode (matching CPU)'
# Microcode update (matching CPU) 
echo " Производители процессоров выпускают обновления стабильности и безопасности 
        для микрокода процессора "
# Processor manufacturers release stability and security updates for the processor microcode.
echo " Огласите весь список, пожалуйста! "
# Read out the entire list, please!
echo " 1 - Для процессоров AMD установите пакет amd-ucode. "
echo " 2 - Для процессоров Intel установите пакет intel-ucode. "
echo " 3 - Если Arch находится на съемном носителе, Вы должны установить микрокод для обоих производителей процессоров. "
echo " Для Arch Linux на съемном носителе добавьте оба файла initrd в настройки загрузчика. "
echo " Их порядок не имеет значения, если они оба указаны до реального образа initramfs. "
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
echo " Будьте внимательны! Без этих обновлений Вы можете наблюдать ложные падения или неожиданные зависания системы, которые может быть сложно отследить. "
# Be careful! Without these updates, you may see false crashes or unexpected system freezes that can be difficult to track.
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления" 
#echo 'Установка производится в порядке перечисления'
# Installation Is performed in the order listed
# Microcode (matching CPU) - У Вас amd или intel?
echo ""
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - AMD, 2 - INTEL, 3 - AMD и INTEL, 0 - Нет Пропустить этот шаг: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Для процессоров AMD,    2 - Для процессоров INTEL, 

    3 - Для процессоров AMD и INTEL, 

    0 - Нет Пропустить этот шаг: " prog_set  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_set" =~ [^1230] ]]
do
    :
done
if [[ $prog_set == 1 ]]; then
  echo " Устанавливаем uCode для процессоров - AMD "
 pacman -S amd-ucode --noconfirm 
  echo " Установлены обновления стабильности и безопасности для микрокода процессора - AMD "
  #grub-mkconfig -o /boot/grub/grub.cfg
# echo " Обновлён (сгенерирован) grub.cfg (/boot/grub/grub.cfg). "       
elif [[ $prog_set == 2 ]]; then
  echo " Устанавливаем uCode для процессоров - INTEL "
 pacman -S intel-ucode --noconfirm
  echo " Установлены обновления стабильности и безопасности для микрокода процессора - INTEL " 
  #grub-mkconfig -o /boot/grub/grub.cfg
# echo " Обновлён (сгенерирован) grub.cfg (/boot/grub/grub.cfg). "    
elif [[ $prog_set == 3 ]]; then
  echo " Устанавливаем uCode для процессоров - AMD и INTEL "
 pacman -S amd-ucode intel-ucode --noconfirm 
  echo " Установлены обновления стабильности и безопасности для микрокода процессоров - AMD и INTEL "  
  #grub-mkconfig -o /boot/grub/grub.cfg
# echo " Обновлён (сгенерирован) grub.cfg (/boot/grub/grub.cfg). "  
elif [[ $prog_set == 0 ]]; then
  echo 'Установка микрокода процессоров пропущена.'
fi
# ----------------------------------------------------------
# Утилита grub-mkconfig автоматически определит обновления микрокода и настроит соответственным образом GRUB. После установки пакета микрокода, перегенерируйте настройки GRUB, чтобы включить обновление микрокода при запуске:
# grub-mkconfig -o /boot/grub/grub.cfg
# -------------------------------------------------------------
# После завершения установки пакета программного обеспечения нужно перезагрузить компьютер.
# После перезагрузки стоит проверить корректность загрузки одного из установленных микрокодов путем ввода следующей команды в окне терминала (используйте функции копирования/вставки для того, чтобы избежать ошибок):
#dmesg | grep microcode
# После окончания ввода команды следует нажать клавишу Enter для ее исполнения. Если микрокод был успешно загружен, вы увидите несколько сообщений об этом.
# -------------------------------------------------------------
# Производители процессоров выпускают обновления стабильности и безопасности для микрокода процессора. Несмотря на то, что микрокод можно обновить с помощью BIOS, ядро Linux также может применять эти обновления во время загрузки. Эти обновления предоставляют исправления ошибок, которые могут быть критичны для стабильности вашей системы. Без этих обновлений вы можете наблюдать ложные падения или неожиданные зависания системы, которые может быть сложно отследить.
# Особенно пользователи процессоров семейства Intel Haswell и Broadwell должны установить эти обновления, чтобы обеспечить стабильность системы. Но, понятное дело, все пользователи должны устанавливать эти обновления.
# Microcode (Русский):
# https://wiki.archlinux.org/index.php/Microcode_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# https://wiki.archlinux.org/index.php/Install_Arch_Linux_on_a_removable_medium
# https://linux-faq.ru/page/ustanovka-noveyshey-versii-mikrokoda-centralnogo-processora
# ===================================================================

echo ""
echo -e "${GREEN}==> ${NC}Если на компьютере будут несколько ОС, то это также ставим."
#echo -e "${BLUE}:: ${NC}Если на компьютере будут несколько OS, то это также ставим."
#echo 'Если на компьютере будут несколько ОС, то это также ставим.'
# # If the system will have several operating systems, then this is also set
echo " Для двойной загрузки Arch Linux с другой системой Linux, Windows, установить другой Linux без загрузчика, вам необходимо установить утилиту os-prober, необходимую для обнаружения других операционных систем. "
echo " И обновить загрузчик Arch Linux, чтобы иметь возможность загружать новую ОС."
# To double boot Arch Linux with another Linux, Windows system, install another Linux without a loader, you need to install the os-prober utility needed to detect other operating systems.
# And update the Arch Linux loader to be able to load the new OS.
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши " 
    read -n1 -p  " 
    1 - Да установить,    0 - Нет пропустить: " prog_set   # sends right after the keypress; # отправляет сразу после нажатия клавиши
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "    
# read -p " 1 - Да установить, 0 - Нет пропустить: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
    echo ''
    [[ "$prog_set" =~ [^10] ]]
do
    :
done
if [[ $prog_set  == 1 ]]; then
 echo " Устанавливаем программы (пакеты) для определения другой-(их) OS "		
pacman -S os-prober mtools fuse --noconfirm  #grub-customizer
 echo " Программы (пакеты) установлены "  	
 elif [[ $prog_set  == 0 ]]; then
echo " Установка программ (пакетов) пропущена. "
 fi
# 
echo ""
echo -e "${BLUE}:: ${NC}Обновляем grub.cfg (Сгенерируем grub.cfg)"
#echo 'Обновляем grub.cfg (Сгенерируем grub.cfg)'
# Updating grub.cfg (Generating grub.cfg)
grub-mkconfig -o /boot/grub/grub.cfg   # создаём конфигурационный файл
# ----------------------------------------------------------------------------
# Файл /etc/boot/grub/grub.cfg управляет непосредственно работой загрузчика, здесь указаны все его параметры и настройки, а также сформировано меню. 
# Поэтому, изменяя этот файл, мы можем настроить Grub как угодно.
# https://losst.ru/nastrojka-zagruzchika-grub
# Можно (нужно) создать резервную копию (дубликат) файла 'grub.cfg', и это мы сделаем уже в установленной системе.
# Команда для backup (duplicate) of the grub.cfg file :
#sudo cp /boot/grub/grub.cfg grub.cfg.backup
# =====================================================================

echo ""
echo -e "${GREEN}==> ${NC}Установить программы (пакеты) для Wi-fi?"
#echo -e "${BLUE}:: ${NC}Установить программы (пакеты) для Wi-fi?"
#echo 'Установить программы (пакеты) для Wi-fi?'
# Install programs (packages) for Wi-fi?
echo " Если у вас есть Wi-fi модуль и Вы сейчас его не используете, но будете использовать в будущем. "
# If you have a Wi-fi module and you are not using it now, but will use It in the future.
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши " 
    read -n1 -p  " 
    1 - Да установить,    0 - Нет пропустить: " i_wifi   # sends right after the keypress; # отправляет сразу после нажатия клавиши
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "    
# read -p " 1 - Да установить, 0 - Нет пропустить: " i_wifi  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")      
    echo ''
    [[ "$i_wifi" =~ [^10] ]]
do
    :
done
if [[ $i_wifi  == 1 ]]; then
 echo " Устанавливаем программы (пакеты) для Wi-fi "		
pacman -S dialog wpa_supplicant iw wireless_tools net-tools --noconfirm 
 echo " Программы (пакеты) для Wi-fi установлены "  	
 elif [[ $i_wifi  == 0 ]]; then
echo " Установка программ (пакетов) пропущена. "
 fi

### Set User
sleep 01
clear
echo ""
echo -e "${GREEN}==> ${NC}Добавляем пользователя и прописываем права, группы. "
#echo -e "${BLUE}:: ${NC}Добавляем пользователя и прописываем права, группы"
#echo 'Добавляем пользователя и прописываем права, группы'
# Adding a user and prescribing rights, groups
echo -e "${MAGENTA}=> ${BOLD}В сценарии скрипта присутствуют следующие варианты: ${NC}"
echo " Давайте рассмотрим варианты, которые будут выполняться: "
# Let's look at the options that will be performed:
echo " 1 - Добавляем пользователя, прописываем права, и добавляем группы : "
echo " (audio,games,lp,network,optical,power,scanner,storage,video,rfkill,sys,wheel), то выбирайте вариант - "1". "
echo " 2 - Добавляем пользователя, прописываем права, и добавляем группы : "
echo " (adm + audio,games,lp,network,optical,power,scanner,storage,video,rfkill,sys,wheel), то выбирайте вариант - "2". "
echo " 3 - Добавляем пользователя, прописываем права, и добавляем пользователя в группу : "
echo " (wheel), то выбирайте вариант - "3". "
echo -e "${CYAN}:: ${BOLD}Далее, уже сам пользователь из установленной системы добавляет себя любимого(ую), в нужную группу /etc/group.${NC}"
echo -e "${YELLOW}:: Вы НЕ можете пропустить этот шаг! ${NC}"
#echo 'Вы НЕ можете пропустить этот шаг!'
# You CAN't skip this step!
echo " Будьте внимательны! В этом действии выбор остаётся за вами."
# Be careful! In this action, the choice is yours.
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке" 
#echo 'Действия выполняются в указанном порядке'
# Actions are performed in the order listed
echo ""
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - Вы выбрали группы (audio,games,lp,network,optical,power,scanner,storage,video,rfkill,sys,wheel), 2 - Вы выбрали группы (adm + audio,games,lp,network,optical,power,scanner,storage,video,rfkill,sys,wheel), 3 - Вы выбрали группу (wheel): " i_groups  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Группы (audio,games,lp,network,optical,power,scanner,storage,video,rfkill,sys,wheel), 

    2 - Группы (adm + audio,games,lp,network,optical,power,scanner,storage,video,rfkill,sys,wheel),    

    3 - Вы выбрали группу (wheel): " i_groups  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_groups" =~ [^123] ]]
do
    :
done
if [[ $i_groups  == 1 ]]; then
useradd -m -g users -G audio,games,lp,network,optical,power,scanner,storage,video,rfkill,sys,wheel -s /bin/bash $username
echo " Пользователь успешно добавлен в группы и права пользователя. "
elif [[ $i_groups  == 2 ]]; then
useradd -m -g users -G adm,audio,games,lp,network,optical,power,scanner,storage,video,rfkill,sys,wheel -s /bin/bash $username
echo " Пользователь успешно добавлен в группы и права пользователя. "
elif [[ $i_groups  == 3 ]]; then
useradd -m -g users -G wheel -s /bin/bash $username
echo " Пользователь успешно добавлен в группы и права пользователя. "
fi

### Set User passwd
### User Password
echo ""
echo -e "${GREEN}==> ${NC}Устанавливаем пароль пользователя (User Password)"
#echo 'Устанавливаем пароль пользователя'
# Setting the user password
echo " Пароль должен содержать от 6 до 15 символов, включающих цифры (1-0) и знаки (!'':[@]),    
        и латинские буквы разного регистра! "
echo -e "${MAGENTA}=> ${BOLD}По умолчанию, на большинстве систем Linux в консоле не показывается введенный пароль. 
Это сделано из соображений безопасности, чтобы никто не мог увидеть длину вашего пароля.${NC}"
echo " => Введите User Password (Пароль пользователя) '$username', вводим пароль 2 раза "
echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
passwd $username
# --------------------------------------------------------------------------
# Пример вывода применённой команды >>> $ passwd После чего дважды новый пароль.
# Список пользователей в Linux хранится в файле /etc/passwd, вы можете без труда открыть его и посмотреть, пароли же выделены в отдельный файл - /etc/shadow. 
# Этот файл можно открыть только с правами суперпользователя, и, более того, пароли здесь хранятся в зашифрованном виде, поэтому узнать пароль Linux не получиться, а поменять вручную будет сложно.
# В большинстве случаев смена пароля выполняется с помощью утилиты passwd. Это очень мощная утилита, она позволяет не только менять пароль, но и управлять сроком его жизни.
# Как сменить пароль в Linux :
# https://losst.ru/kak-smenit-parol-v-linux
# ============================================================================

echo ""
echo -e "${BLUE}:: ${NC}Проверим статус пароля для всех учетных записей пользователей в вашей системе"
#echo 'Проверим статус пароля для всех учетных записей пользователей в вашей системе'
# Check the password status for all user accounts in your system
passwd -Sa
# sudo passwd -Sa

echo ""
echo -e "${GREEN}==> ${NC}Информация о пользователе (полное имя пользователя и связанная с ним информация)"
#echo 'Информация о пользователе (полное имя пользователя и связанная с ним информация)'
# User information (the user's full name and related information)
echo " Пользователь в Linux может хранить большое количество связанной с ним информации, в том числе номера домашних и офисных телефонов, номер кабинета и многое другое. Мы обычно пропускаем заполнение этой информации (так как все это необязательно) при создании пользователя. "
echo -e "${CYAN}:: ${NC}На первом этапе достаточно имени пользователя, и подтверждаем (Enter). Ввод другой информации можно пропустить - просто нажав (Enter). "
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
echo ""
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - Вводим информация о пользователе,  0 - Пропустить этот шаг: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  " 
    1 - Вводим информация о пользователе,    0 - Пропустить этот шаг: " prog_set   # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_set" =~ [^10] ]]
do
    :
done
if [[ $prog_set == 1 ]]; then
  echo " Информация о my username : (достаточно имени) "
chfn $username
#finger $username
elif [[ $prog_set == 0 ]]; then
  echo 'Настройка пропущена.'
fi 
# ---------------------------------------------------------
# Руководство по команде chfn для начинающих:
# http://rus-linux.net/MyLDP/consol/Linux_chfn_command.html
#========================================================== 

echo ""
echo -e "${BLUE}:: ${NC}Устанавливаем SUDO"
#echo 'Устанавливаем SUDO'
# Installing SUDO
pacman -S sudo --noconfirm
# Sudo с запросом пароля:
#echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
#sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
#cat /mnt/etc/sudoers
# Sudo nopassword (БЕЗ запроса пароля):
#echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
#sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
#cat /mnt/etc/sudoers
# ----------------------------------------------------------
# sudo (англ. substitute user do, дословно «подменить пользователя и выполнить») позволяет системному администратору делегировать полномочия, чтобы дать некоторым пользователям (или группе пользователей) возможность запускать некоторые (или все) команды c правами суперпользователя или любого другого пользователя, обеспечивая контроль над командами и их аргументами.
# Sudo - это альтернатива su для выполнения команд с правами суперпользователя (root). 
# В отличие от su, который запускает оболочку с правами root и даёт всем дальнейшим командам root права, sudo предоставляет временное повышение привилегий для одной команды.
# Чтобы начать использовать sudo как непривилегированный пользователь, его нужно настроить должным образом. 
# Для этого прочтите раздел о настройке.
# Sudo (Русский):
# https://wiki.archlinux.org/index.php/Sudo_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# Крайне важно, чтобы файл sudoers был без синтаксических ошибок! 
# Любая ошибка делает sudo неработоспособным.
# ===============================================================

echo ""
echo -e "${GREEN}==> ${NC}Настраиваем запрос пароля "Пользователя" при выполнении команды "sudo". "
#echo -e "${BLUE}:: ${NC}Настраиваем запрос пароля "Пользователя" при выполнении команды "sudo"."
#echo 'Настраиваем запрос пароля "Пользователя" при выполнении команды "sudo".'
# Configuring the "User" password request when executing the "sudo" command"
echo " Чтобы начать использовать sudo как непривилегированный пользователь, его нужно настроить должным образом. "
# To start using sudo as an unprivileged user, you need to configure it properly.
echo " Огласите весь список, пожалуйста! "
# Read out the entire list, please!
echo " 1 - Пользователям (членам) группы wheel доступ к sudo С запросом пароля. "
echo " 2 - Пользователям (членам) группы wheel доступ к sudo (NOPASSWD) БЕЗ запроса пароля. "
echo -e "${RED}==> ${BOLD}Выбрав (раскомментировав) данную опцию, особых требований к безопасности нет, но может есть какие-то очень негативные моменты в этом?... ${NC}"
#echo 'Выбрав (раскомментировав) данную опцию, особых требований к безопасности нет, но может есть какие-то очень негативные моменты в этом?...'
# By selecting (commenting out) this option, there are no special security requirements, but maybe there are some very negative points in this?...
echo " 3-(0) - Добавление настроек sudo пропущено. "
echo " Все настройки в файле /etc/sudoers пользователь произведёт сам. "
echo " Например: под строкой root ALL=(ALL) ALL  ., пропишет 'username' ALL=(ALL) ALL. "
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами."
# Be careful! In any situation, the choice is always yours.
echo -e "${CYAN}:: ${NC}На данном этапе порекомендую вариант "1" (sudo С запросом пароля) "
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке" 
#echo 'Действия выполняются в указанном порядке'
# Actions are performed in the order listed
echo ""
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - С запросом пароля, 2 - БЕЗ запроса пароля, 0 - Пропустить этот шаг: " i_sudo  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
#read -n1 -p " 1 - С запросом пароля, 2 - БЕЗ запроса пароля, 0 - Пропустить этот шаг: " i_sudo  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
echo " Добавление настройки sudo пропущено"
elif [[ $i_sudo  == 1 ]]; then
#echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
#cat /mnt/etc/sudoers
clear
echo " Sudo с запросом пароля выполнено "
elif [[ $i_sudo  == 2 ]]; then
#echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
#cat /mnt/etc/sudoers
clear
echo " Sudo nopassword (БЕЗ запроса пароля) добавлено  "
fi
# --------------------------------------------------------
#Выполните sudo -ll для вывода текущей конфигурации sudo.
#Просмотр текущих настроек:
#nano /etc/sudoers
#cat /mnt/etc/sudoers
# ---------------------------------------------------------
###################################################################
##### <<<  sudo и %wheel ALL=(ALL) NOPASSWD: ALL   >>>        #####
#### Кстати, рекомендую добавить запрет выполнения нескольких  ####
#### команд -                                                  ####
####                                                              #############
#### ##Groups of commands.  Often used to group related commands together. ####
#### Cmnd_Alias SHELLS = /bin/sh,/bin/csh,/usr/local/bin/tcsh     #############
#### Cmnd_Alias SSH = /usr/bin/ssh                             ####       
#### Cmnd_Alias SU = /bin/su                                   ####
#### dreamer ALL = (ALL) NOPASSWD: ALL,!SU,SHELLS,!SSH         ####
####                                                           #### 
#### чтобы не было возможности стать рутом через $sudo su      ####
#### (многи об этой фиче забывают)!                            #### 
#####                                                         #####
###################################################################
# -------------------------------------------------------------
# Чтобы начать использовать sudo как непривилегированный пользователь, его нужно настроить должным образом. 
# Для этого прочтите раздел о настройке.
# Sudo (Русский):
# https://wiki.archlinux.org/index.php/Sudo_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# Крайне важно, чтобы файл sudoers был без синтаксических ошибок! 
# Любая ошибка делает sudo неработоспособным.
# ============================================================

echo ""
echo -e "${GREEN}==> ${NC}Добавим репозиторий Multilib Для работы 32-битных приложений в 64-битной системе?"
echo -e "${BLUE}:: ${NC}Раскомментируем репозиторий multilib"
#echo 'Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
# Uncomment the multilib repository For running 32-bit applications on a 64-bit system
echo " Чтобы исключить в дальнейшем ошибки в работе системы рекомендую вариант "1". "
# To avoid further errors in the system I recommend "1"
echo -e "${YELLOW}:: ${BOLD}Multilib может пригодится позже при установке OpenGL (multilib) для драйверов видеокарт.${NC}"
# The Multilib repository may come in handy later when installing OpenGL (multilib) for video card drivers.
echo ""
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - Да добавить, 0 - Нет пропустить настройку: " i_multilib  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
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
#echo 'Обновим базы данных пакетов'
# Updating the package databases
#sudo pacman-key --init
#sudo pacman-key --refresh-keys
#sudo pacman -Sy  
#pacman -Syy
pacman -Sy   #--noconfirm --noprogressbar --quiet
#pacman -Syy --noconfirm --noprogressbar --quiet
#pacman -Syu --noconfirm --noprogressbar --quiet
# ------------------------------------------------------------
# --noconfirm      не спрашивать каких-либо подтверждений
# --noprogressbar  не показывать статус прогресса при загрузке 
# --quiet          показать меньше информации для запроса и поиска
# -------------------------------------------------------------
# Знакомьтесь, pacman - лучший пакетный менеджер в мире линукса!
#pacman -Syy   - обновление баз пакмэна(как apt-get update в дэбианоподбных)
#pacman -Syyu  - обновление баз плюс обновление пакетов
#pacman -Syy --noconfirm --noprogressbar --quiet
# Синхронизация и обновление пакетов (-yy принудительно обновить даже если обновленные)
# =============================================================

echo ""
echo -e "${GREEN}==> ${NC}Устанавливаем X.Org Server (иксы) и драйвера."
#echo "Устанавливаем Xorg (иксы) и драйвера.
# Installing Xorg (XPS) and drivers
echo -e "${YELLOW}:: ${BOLD}X.Org Foundation Open Source Public Implementation of X11 - это свободная открытая реализация оконной системы X11.${NC}"   
echo " Xorg очень популярен среди пользователей Linux, что привело к тому, что большинство приложений с графическим интерфейсом используют X11, из-за этого Xorg доступен в большинстве дистрибутивов. "
echo -e "${BLUE}:: ${NC}Сперва определим вашу видеокарту!"
#echo "Сперва определим вашу видеокарту"
# First, we will determine your video card!
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
#echo "Куда Вы устанавливаете Arch Linux на PC, или на Виртуальную машину (VBox;VMWare)?"
# Where do you install Arch Linux on a PC, or on a Virtual machine VBox;VMWare)?
echo " Для того, чтобы ускорение видео работало, и часто для того, чтобы разблокировать все режимы, в которых может работать GPU (графический процессор), требуется правильный видеодрайвер. "
# In order for video acceleration to work, and often in order to unlock all the modes in which the GPU can work, the correct video driver is required.
echo -e "${MAGENTA}=> ${BOLD}Есть три варианта установки Xorg (иксов): ${NC}"
echo " Давайте проанализируем действия, которые будут выполняться. "
# Let's analyze the actions that will be performed.
echo " 1 - Если Вы устанавливаете Arch Linux на PC, то выбирайте вариант - "1". "
echo " 2 - Если Вы устанавливаете Arch Linux на Виртуальную машину (VBox;VMWare), то ваш вариант - "2". "
echo " 3(0) - Вы можете пропустить установку Xorg (иксов), если используете VDS (Virtual Dedicated Server), или VPS (Virtual Private Server), тогда выбирайте вариант - "0". "
echo " VPS (Virtual Private Server) обозначает виртуализацию на уровне операционной системы, VDS (Virtual Dedicated Server) - аппаратную виртуализацию. Оба термина появились и развивались параллельно, и обозначают одно и то же: виртуальный выделенный сервер, запущенный на базе физического. "
echo " Будьте внимательны! Процесс установки Xorg (иксов) не был прописан полностью автоматическим, и было принято решение дать возможность пользователю сделать выбор. В любой ситуации выбор всегда остаётся за вами. "
# Be careful! The Xorg installation process was not intended to be fully automatic, and the decision was made to allow the user to make a choice. In any situation, the choice is always yours.
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке" 
#echo 'Действия выполняются в указанном порядке'
# Actions are performed in the order listed
echo ""
# Теперь приступим к установке Xorg.
while
# echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - Устанавливаем на PC или (ноутбук), 2 - Устанавливаем на VirtualBox (VMWare), 0 - Пропустить (используется VDS, или VPS): " vm_setting  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
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
#echo 'Ставим иксы и драйвера'
# Put the x's and drivers
echo " Выберите свой вариант (от 1-...), или по умолчанию нажмите кнопку 'Ввод' ("Enter") "
echo " Далее после своего сделанного выбора, нажмите "Y или n" для подтверждения установки. "
pacman -S $gui_install   # --confirm   всегда спрашивать подтверждение
echo ""
pacman -Syy --noconfirm --noprogressbar --quiet
sleep 01
clear

###### 2 Вариант установки Xorg (иксов).Установка X сервера 

#echo ""
#echo -e "${CYAN}
#  <<< Сейчас Вы можете выбрать DE (среду, окружение рабочего стола), из представленных далее в скрипте. >>>
#  <<< Важно! Перед установкой окружения рабочего стола требуется установка работающего X-сервера (Xorg). >>> ${NC}"
#  <<< Окружение рабочего стола - является реализацией настольной метафоры (набор унификации концепций) из пучка программ, которые имеют общий графический пользовательский интерфейс (GUI). >>>
#  <<< Будьте внимательны! Обдумайте свой выбор перед установкой DE/WM. Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В любой ситуации выбор всегда остаётся за вами! >>>
#  <<< Также, Вы можете пропустить установку DE/WM, если желаете работать без реализации сред рабочего стола! >>> 

echo ""
echo -e "${GREEN}==> ${NC}Ставим DE (графическое окружение) среда рабочего стола."
echo " DE (от англ. desktop environment - среда рабочего стола), это обёртка для ядра Linux, предоставляющая основные функции дистрибутива в удобном для конечного пользователя наглядном виде (окна, кнопочки, стрелочки и пр.). "
echo -e "${MAGENTA}=> ${BOLD}Среда рабочего стола объединяет множество компонентов для предоставления общих элементов графического пользовательского интерфейса, таких как значки, панели инструментов, обои и виджеты рабочего стола. Кроме того, большинство сред рабочего стола включают набор интегрированных приложений и утилит. Что наиболее важно, окружения рабочего стола предоставляют собственный оконный менеджер , который, однако, обычно можно заменить другим совместимым. ${NC}"
#echo -e "${BLUE}:: ${NC}Ставим DE (от англ. desktop environment — среда рабочего стола)"
#echo 'Ставим DE (от англ. desktop environment — среда рабочего стола)'
# Put DE (from the English desktop environment-desktop environment)
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В любой ситуации выбор всегда остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In any situation, the choice is always yours.
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке" 
#echo 'Действия выполняются в указанном порядке'
echo ""
# Теперь приступим к установке DE/WM.
while
# echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - KDE(Plasma), 2 - Xfce, 3 - GNOME, 4 - LXDE, 5 - Deepin, 6 - Mate, 7 - Lxqt, 8 - i3 (  конфиги стандартные, возможна установка с автовходом ), 0 - Пропустить установку: " x_de  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - KDE(Plasma) - Plasma предлагает все инструменты, необходимые для современного настольного компьютера
    
    2 - Xfce - Xfce воплощает традиционную философию UNIX

    3 - GNOME - это привлекательный и интуитивно понятный рабочий стол с современным ( GNOME )
    
    4 - LXDE - облегченная среда рабочего стола X11 - это быстрая и энергосберегающая среда 
    
    5 - Deepin - настольный интерфейс и приложения Deepin имеют интуитивно понятный и элегантный дизайн 

    6 - Mate - предоставляет пользователям Linux интуитивно понятный и привлекательный рабочий стол

    7 - Lxqt - это порт Qt и будущая версия LXDE, облегченной среды рабочего стола
    
    8 - i3 (  конфиги стандартные, возможна установка с автовходом )

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
#echo -e "${BLUE}:: ${NC}Настройка автовхода без DM (Display manager) менеджера входа в KDE(Plasma)"
#echo 'Настройка автовхода без DM (Display manager) менеджера входа в KDE(Plasma)'
# Configuring AutoFill without the DM (Display manager) of the KDE(Plasma) login Manager
echo " Давайте проанализируем действия, которые выполняются. "
# Let's analyze the actions that are being performed.
echo " 1 - Если вам нужен автовход без DM (Display manager) тогда укажите "1". "
echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" . " 
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# Be careful! If you doubt your actions, think again...
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке" 
#echo 'Действия выполняются в указанном порядке'
# Actions are performed in the order listed
echo ""
while
# echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "    
# read -p  " 1 - Да нужен автовход без DM, 0 - Нет буду использовать DM: " i_kde   # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
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
echo " Установка Xfce + Goodies for Xfce "     
#pacman -S xfce4 xfce4-goodies
pacman -S xfce4 xfce4-goodies --noconfirm
# pacman -S xfce4 xfce4-goodies pavucontrol --noconfirm
clear
echo ""
echo " DE (среда рабочего стола) Xfce успешно установлено "  

### Log in without DM (Display manager) 
echo ""
echo -e "${GREEN}==> ${NC}Настройка автовхода без DM (Display manager) менеджера входа в Xfce"
#echo -e "${BLUE}:: ${NC}Настройка автовхода без DM (Display manager) менеджера входа в Xfce"
#echo 'Настройка автовхода без DM (Display manager) менеджера входа в Xfce'
# Configuring AutoFill without the DM (Display manager) of the Xfce login Manager
echo " Файл ~/.xinitrc представляет собой шелл-скрипт передаваемый xinit посредством команды startx.   "
echo " Он используется для запуска Среды рабочего стола, Оконного менеджера и других программ запускаемых с X сервером (например запуска демонов, и установки переменных окружений. "
echo " Программа xinit запускает Xorg сервер и работает в качестве программы первого клиента на системах не использующих Экранный менеджер. "
# The ~/.xinitrc file is a shell script passed to xinit via the startx command. It is used to run the desktop Environment, Window Manager, and other programs that run with the X server (for example, running daemons, and setting environment variables. The xinit program starts the Xorg server and runs as the first client program on systems that do not use the Screen Manager.
echo " Давайте проанализируем действия, которые выполняются. "
# Let's analyze the actions that are being performed.
echo " 1 - Если вам нужен автовход без DM (Display manager) тогда укажите "1". "
echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" . " 
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# Be careful! If you doubt your actions, think again...
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке" 
#echo 'Действия выполняются в указанном порядке'
# Actions are performed in the order listed
echo ""
while
# echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "    
# read -p  " 1 - Да нужен автовход без DM, 0 - Нет буду использовать DM: " i_xfce   # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
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
echo " Буду использовать DM (Display manager) "
elif [[ $i_xfce  == 1 ]]; then
# Поскольку реализация автозагрузки окружения реализована через startx, 
# то у Вас должен быть установлен пакет: xorg-xinit    
pacman -S xorg-xinit --noconfirm
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
#echo -e "${BLUE}:: ${NC}Настройка автовхода без DM (Display manager) менеджера входа в GNOME"
#echo 'Настройка автовхода без DM (Display manager) менеджера входа в GNOME'
# Configuring AutoFill without the DM (Display manager) of the GNOME login Manager
echo " Давайте проанализируем действия, которые выполняются. "
# Let's analyze the actions that are being performed.
echo " 1 - Если вам нужен автовход без DM (Display manager) тогда укажите "1". "
echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" . " 
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# Be careful! If you doubt your actions, think again...
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке" 
#echo 'Действия выполняются в указанном порядке'
# Actions are performed in the order listed
echo ""
while
# echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "    
# read -p  " 1 - Да нужен автовход без DM, 0 - Нет буду использовать DM: " i_gnome   # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
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
# Поскольку реализация автозагрузки окружения реализована через startx, 
# то у Вас должен быть установлен пакет: xorg-xinit    
pacman -S xorg-xinit --noconfirm
# Если файл .xinitrc не существует, то копируем его из /etc/X11/xinit/xinitrc
# в папку пользователя cp /etc/X11/xinit/xinitrc ~/.xinitrc
cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc # копируем файл .xinitrc в каталог пользователя
chown $username:users /home/$username/.xinitrc  # даем доступ пользователю к файлу
chmod +x /home/$username/.xinitrc   # получаем права на исполнения скрипта
sed -i 52,55d /home/$username/.xinitrc  # редактируем файл -> и прописываем команду на запуск
# # Данные блоки нужны для того, чтобы StartX автоматически запускал нужное окружение, соответственно в секции Window Manager of your choice раскомментируйте нужную сессию
echo "exec gnome-session " >> /home/$username/.xinitrc  
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
elif [[ $x_de == 4 ]]; then
echo " Установка LXDE " 
pacman -S lxde --noconfirm
clear
echo ""
echo " DE (среда рабочего стола) LXDE успешно установлено " 
echo ""
echo -e "${GREEN}==> ${NC}Настройка автовхода без DM (Display manager) менеджера входа в LXDE"
#echo -e "${BLUE}:: ${NC}Настройка автовхода без DM (Display manager) менеджера входа в LXDE"
#echo 'Настройка автовхода без DM (Display manager) менеджера входа в LXDE'
# Configuring AutoFill without the DM (Display manager) of the LXDE login Manager
echo " Давайте проанализируем действия, которые выполняются. "
# Let's analyze the actions that are being performed.
echo " 1 - Если вам нужен автовход без DM (Display manager) тогда укажите "1". "
echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" . " 
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# Be careful! If you doubt your actions, think again...
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке" 
#echo 'Действия выполняются в указанном порядке'
# Actions are performed in the order listed
echo ""
while
# echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "    
# read -p  " 1 - Да нужен автовход без DM, 0 - Нет буду использовать DM: " i_lxde   # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
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
#echo -e "${BLUE}:: ${NC}Настройка автовхода без DM (Display manager) менеджера входа в Deepin"
#echo 'Настройка автовхода без DM (Display manager) менеджера входа в Deepin'
# Configuring AutoFill without the DM (Display manager) of the Deepin login Manager
echo " Давайте проанализируем действия, которые выполняются. "
# Let's analyze the actions that are being performed.
echo " 1 - Если вам нужен автовход без DM (Display manager) тогда укажите "1". "
echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" . " 
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# Be careful! If you doubt your actions, think again...
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке" 
#echo 'Действия выполняются в указанном порядке'
# Actions are performed in the order listed
echo ""
while
# echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "    
# read -p  " 1 - Да нужен автовход без DM, 0 - Нет буду использовать DM: " i_deepin   # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
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
#echo -e "${BLUE}:: ${NC}Настройка автовхода без DM (Display manager) менеджера входа в Mate"
#echo 'Настройка автовхода без DM (Display manager) менеджера входа в Mate'
# Configuring AutoFill without the DM (Display manager) of the Mate login Manager
echo " Давайте проанализируем действия, которые выполняются. "
# Let's analyze the actions that are being performed.
echo " 1 - Если вам нужен автовход без DM (Display manager) тогда укажите "1". "
echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" . " 
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# Be careful! If you doubt your actions, think again...
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке" 
#echo 'Действия выполняются в указанном порядке'
# Actions are performed in the order listed
echo ""
while
# echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "    
# read -p  " 1 - Да нужен автовход без DM, 0 - Нет буду использовать DM: " i_mate   # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
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
#echo -e "${BLUE}:: ${NC}Настройка автовхода без DM (Display manager) менеджера входа в Lxqt"
#echo 'Настройка автовхода без DM (Display manager) менеджера входа в Lxqt'
# Configuring AutoFill without the DM (Display manager) of the Lxqt login Manager
echo " Давайте проанализируем действия, которые выполняются. "
# Let's analyze the actions that are being performed.
echo " 1 - Если вам нужен автовход без DM (Display manager) тогда укажите "1". "
echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" . " 
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# Be careful! If you doubt your actions, think again...
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке" 
#echo 'Действия выполняются в указанном порядке'
# Actions are performed in the order listed
echo ""
while
# echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "    
# read -p  " 1 - Да нужен автовход без DM, 0 - Нет буду использовать DM: " i_lxqt   # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
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
#echo -e "${BLUE}:: ${NC}Настройка автовхода без DM (Display manager) менеджера входа в i3"
#echo 'Настройка автовхода без DM (Display manager) менеджера входа в i3'
# Configuring AutoFill without the DM (Display manager) of the i3 login Manager
echo " Давайте проанализируем действия, которые выполняются. "
# Let's analyze the actions that are being performed.
echo " 1 - Если вам нужен автовход без DM (Display manager) тогда укажите "1". "
echo " Вы хотите автологин определенного пользователя, автоматический запуск Иксов, запуск окружения (KDE, XFCE, Gnom и т.д.). "
echo " Всё можно сделать без использования DM (например SDDM, LightDM и т.д.), поскольку реализация автозагрузки окружения реализован через startx. "
echo " 2(0) - Если Вы по прежнему желаете использовать DM (например SDDM, LightDM и т.д.), или в дальнейшем захотите установить, и использовать 2(е) окружение (Т.е. DE - KDE, XFCE, Gnom и т.д.), тогда укажите "0" . " 
echo " Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# Be careful! If you doubt your actions, think again...
echo -e "${YELLOW}==> ${NC}Действия выполняются в указанном порядке" 
#echo 'Действия выполняются в указанном порядке'
# Actions are performed in the order listed
echo ""
while
# echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "    
# read -p  " 1 - Да нужен автовход без DM, 0 - Нет буду использовать DM: " i_i3w   # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
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
# ----------------------------------------------------------------
# Одной из основных функций ~/.xinitrc является указание, какой клиент X Window System будет запущен каждому пользователю при вызове startx или xinit. Существует множество дополнительных настроек и команд, которые также могут быть добавлены в ~/.xinitrc согласно вашей дальнейшей настройке системы.
# ----------------------------------------------------------------
# Отключаем DM (в примере это lxdm, у вас может быть свой DM)
#sudo systemctl disable lxdm
# Перезагружаемся, если все работает, то удаляем DM
#sudo pacman -R lxdm
# ----------------------------------------------------------------
# Автологин и автозагрузка любого окружения без DM:
# https://archlinux.org.ru/forum/topic/16498/
# https://wiki.archlinux.org/index.php/Xinit#Configuration
# https://wiki.archlinux.org/index.php/Xinit_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)#.D0.90.D0.B2.D1.82.D0.BE.D0.B7.D0.B0.D0.BF.D1.83.D1.81.D0.BA_X_.D0.BF.D1.80.D0.B8_.D0.B2.D1.85.D0.BE.D0.B4.D0.B5_.D0.B2_.D1.81.D0.B8.D1.81.D1.82.D0.B5.D0.BC.D1.83
# https://wiki.archlinux.org/index.php/Xinit#Autostart_X_at_login
# https://wiki.archlinux.org/index.php/Xinit#Autostart_X_at_login
# https://vk.com/wall-129498031_20705
# =================================================================
####

echo ""
echo -e "${GREEN}==> ${NC}Ставим DM (Display manager) менеджера входа."
echo " DM - Менеджер дисплеев , или Логин менеджер, обычно представляет собой графический пользовательский интерфейс , который отображается в конце процесса загрузки вместо оболочки по умолчанию. "
#echo -e "${BLUE}:: ${NC}Ставим DM (Display manager) менеджера входа"
#echo 'Ставим DM (Display manager) менеджера входа'
# Install the DM (Display manager) of the login Manager
echo -e "${YELLOW}:: ${BOLD}Существуют различные реализации дисплейных менеджеров, обычно с определенным количеством настроек и тематических функций, доступных для каждого из них. ${NC}"
# There are various implementations of display managers, usually with a certain number of settings and thematic features available for each of them.
echo -e "${MAGENTA}=> ${BOLD}Согласно аннотации ArchWiki рассмотрим список графических менеджеров дисплея, варианты установки DM (Display manager), и их совместимость с различными вариантами DE (средами рабочего стола). ${NC}"
echo " 1 - LightDM - Диспетчер дисплеев между рабочими столами, может использовать различные интерфейсы, написанные на любом наборе инструментов, вариант - "1". "
echo -e "${YELLOW}:: ${NC}LightDM - идёт как основной DM в Xfce (окружение рабочего стола), совместим с Deepin, и т.д.. Его ключевые особенности: Кросс-десктоп - поддерживает различные настольные технологии, поддерживает различные технологии отображения (X, Mir, Wayland ...), низкое использование памяти и высокая производительность. Поддерживает гостевые сессии, поддерживает удаленный вход (входящий - XDMCP , VNC , исходящий - XDMCP). "
echo " 2 - LXDM - Диспетчер отображения LXDE, вариант - "2". "
echo -e "${YELLOW}:: ${NC}LXDE  - идёт как основной DM в LXDE (окружение рабочего стола), совместим с Xfce, Mate, Deepin, и т.д.. Это легкий диспетчер отображения, пользовательский интерфейс реализован с помощью GTK 2. LXDM не поддерживает протокол XDMCP, альтернатива - LightDM. "
echo " 3 - GDM - Диспетчер отображения GNOME, вариант - "3". "
echo -e "${YELLOW}:: ${NC}GNOME Display Manager (GDM) - это программа, которая управляет серверами графического дисплея и обрабатывает логины пользователей в графическом режиме. "
echo " 4 - SDDM - Диспетчер отображения на основе QML и преемник KDM, вариант - "4". "
echo -e "${YELLOW}:: ${NC}SDDM - рекомендуется для KDE Plasma Desktop, и LXQt (окружение рабочего стола). Simple Desktop Display Manager (SDDM) - это диспетчер дисплея (графическая программа входа в систему) для оконных систем X11 и Wayland. KDE выбрала SDDM в качестве преемника KDE Display Manager для KDE Plasma 5. "
echo " 5(0) - Если Вам не нужен DM (Display manager), то выбирайте вариант - "0". "
echo -e "${YELLOW}:: ${BOLD}Примечание! Если Вы при установке i3, сделали выбор без использования DM, то DM не ставим! ${NC}"
#echo " Это далеко не полный список менеджеров дисплея. Помните вам может потребоваться ручная настройка оконного менеджера. "
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами. "
# Be careful! In any situation, the choice is always yours.
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления" 
#echo 'Установка производится в порядке перечисления'
# Installation Is performed in the order listed
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - LightDM, 2 - LXDM, 3 - GDM, 4 - SDDM, 0 - Пропустить установку DM (Display manager): " i_dm  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
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
echo -e "${GREEN}==> ${NC}Установить сетевые утилиты "Networkmanager"?"
#echo -e "${BLUE}:: ${NC}Установить сетевые утилиты "Networkmanager"?"
#echo 'Установить сетевые утилиты "Networkmanager"?'
# Install the "Networkmanager" network utilities"
echo " "Networkmanager" - сервис для работы интернета. Вместе с собой устанавливает программы (пакеты) для настройки. "
echo " Поддержка OpenVPN в Network Manager также внесена в список устанавливаемых программ (пакетов). "
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши " 
    read -n1 -p  " 
    1 - Да установить,    0 - Нет пропустить: " i_network   # sends right after the keypress; # отправляет сразу после нажатия клавиши
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "    
# read -p " 1 - Да установить, 0 - Нет пропустить: " i_network  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")     
    echo ''
    [[ "$i_network" =~ [^10] ]]
do
    :
done
if [[ $i_network  == 1 ]]; then
 echo " Ставим сетевые утилиты Networkmanager "		
pacman -S networkmanager networkmanager-openvpn network-manager-applet ppp --noconfirm
#pacman -Sy networkmanager networkmanager-openvpn network-manager-applet ppp --noconfirm
echo ""
echo -e "${BLUE}:: ${NC}Подключаем Networkmanager в автозагрузку"
# echo " Подключаем Networkmanager в автозагрузку "	
systemctl enable NetworkManager
echo " NetworkManager успешно добавлен в автозагрузку "
 elif [[ $i_network  == 0 ]]; then
echo " Установка NetworkManager пропущена "
 fi
# ----------------------------------------------------------
# https://wiki.archlinux.org/index.php/Networkmanager-openvpn
# https://www.archlinux.org/packages/extra/x86_64/networkmanager-openvpn/ 
# =========================================================== 

echo ""
echo -e "${BLUE}:: ${NC}Ставим шрифты"
#echo 'Ставим шрифты'
# Put the fonts
pacman -S ttf-liberation ttf-dejavu --noconfirm 
pacman -S ttf-arphic-ukai ttf-arphic-uming ttf-hanazono --noconfirm  # opendesktop-fonts 
pacman -S ttf-anonymous-pro --noconfirm  # Семейство из четырех шрифтов фиксированной ширины, разработанных специально с учетом кодирования
pacman -S ttf-fireflysung ttf-sazanami --noconfirm  # -китайские иероглифы

echo ""
echo -e "${GREEN}==> ${NC}Добавим службу Dhcpcd в автозагрузку (для проводного интернета)?"
#echo 'Добавим службу Dhcpcd в автозагрузку (для проводного интернета)?'
# Adding the Dhcpcd service to auto-upload (for wired Internet)?
echo -e "${CYAN}:: ${NC}Dhcpcd - свободная реализация клиента DHCP и DHCPv6. Пакет dhcpcd является частью группы base, поэтому, скорее всего он уже установлен в вашей системе."
echo " Если необходимо добавить службу Dhcpcd в автозагрузку это можно сделать уже в установленной системе Arch'a "
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
#echo 'Вы можете пропустить этот шаг, если не уверены в правильности выбора'
# You can skip this step if you are not sure of the correct choice
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p  " 
    1 - Включить dhcpcd,    0 - Нет - пропустить этот шаг: " x_dhcpcd   # sends right after the keypress; # отправляет сразу после нажатия клавиши
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "   
#  read -p " 1 - Включить dhcpcd, 0 - Нет - пропустить этот шаг: " x_dhcpcd  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
    echo ''
    [[ "$x_dhcpcd" =~ [^10] ]]
do
    :
done
if [[ $x_dhcpcd == 1 ]]; then
systemctl enable dhcpcd   # для активации проводных соединений
echo " Dhcpcd успешно добавлен в автозагрузку "  
elif [[ $x_dhcpcd == 0 ]]; then
  echo ' Dhcpcd не включен в автозагрузку, при необходиости это можно будет сделать уже в установленной системе '
fi

### Install NTFS support "NTFS file support (Windows Drives)"
echo ""
echo -e "${BLUE}:: ${NC}Монтирование разделов NTFS и создание ссылок"
#echo 'Монтирование разделов NTFS и создание ссылок'
# NTFS support (optional)
pacman -S ntfs-3g --noconfirm
#sudo pacman -S ntfs-3g --noconfirm

clear
echo ""
echo -e "${GREEN}==> ${NC}Создаём папки в директории пользователя (Downloads, Music, Pictures, Videos, Documents). ${NC}"
#echo -e "${BLUE}:: ${NC}Создаём папки в директории пользователя (Downloads, Music, Pictures, Videos, Documents)"
#echo 'Создаём папки в директории пользователя (Downloads, Music, Pictures, Videos, Documents)'
# Creating folders in the user's directory (Downloads, Music, Pictures, Videos, Documents)
echo -e "${BLUE}:: ${NC}Создание полного набора локализованных пользовательских каталогов по умолчанию (Загрузки, Шаблоны, Общедоступные, Документы, Музыка, Изображения, Видео) в пределах "HOME" каталога."
echo -e "${CYAN}:: ${NC}По умолчанию в системе Arch Linux в каталоге "HOME" НЕ создаются папки (Загрузки, Шаблоны, Общедоступные, Документы, Музыка, Изображения, Видео), кроме папки Рабочий стол (Desktop)."
echo -e "${CYAN}:: ${NC}Согласно философии Arch, вместо удаления ненужных пакетов, папок, пользователю предложена возможность построить систему, начиная с минимальной основы без каких-либо заранее выбранных шаблонов... "
echo " Давайте проанализируем действия, которые выполняются. "
# Let's analyze the actions that are being performed.
echo " 1 - Создание каталогов по умолчанию с помощью (xdg-user-dirs), тогда укажите вариант "1". "
echo " xdg-user-dirs - это инструмент, помогающий создать и управлять "хорошо известными" пользовательскими каталогами, такими как папка рабочего стола, папка с музыкой и т.д.. Он также выполняет локализацию (то есть перевод) имен файлов. "
echo " Большинство файловых менеджеров обозначают пользовательские каталоги XDG специальными значками. "
echo " 2(0) - Если Вам не нужны папки в директории пользователя, или в дальнейшем уже в установленной системе, Вы сами создадите папки, тогда выбирайте вариант "0". " 
echo -e "${CYAN}:: ${NC}Есть другие способы создания локализованных пользовательских каталогов, но в данном скрипте они не будут представлены. "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
# Be careful! If you doubt your actions, think again...
echo ""
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
# read -p " 1 - Создание каталогов с помощью (xdg-user-dirs), 0 - Пропустить создание каталогов: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Создание каталогов с помощью (xdg-user-dirs), 

    0 - Пропустить создание каталогов: " prog_set  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_set" =~ [^10] ]]
do
    :
done
if [[ $prog_set == 0 ]]; then
  echo ""  
  echo ' Создание каталогов пропущено. '
elif [[ $prog_set == 1 ]]; then
 pacman -S xdg-user-dirs --noconfirm
 xdg-user-dirs-update 
 echo "" 
 echo " Создание каталогов успешно выполнено "
fi
clear
# Совет. Для принудительного создания каталогов с английскими именами LC_ALL=C xdg-user-dirs-update --force можно использовать.
# --------------------------------------------------------------
# https://wiki.archlinux.org/index.php/XDG_user_directories_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# XDG: Пользовательские папки
# https://wiki.yola.ru/xdg/user-dirs
# ==============================================================

echo ""
echo -e "${BLUE}:: ${NC}Установка базовых программ и пакетов"
#echo 'Установка базовых программ и пакетов'
# Installing basic programs and packages
#sudo pacman -S wget --noconfirm
pacman -S wget git --noconfirm  #curl
# ==============================================================
# GNU Wget - это бесплатный программный пакет для извлечения файлов с использованием HTTP, HTTPS, FTP и FTPS (FTPS начиная с версии 1.18) .
# Это неинтерактивный инструмент командной строки, поэтому его легко вызывать из сценариев.
# https://wiki.archlinux.org/index.php/Wget
# Команда wget linux имеет очень простой синтаксис: wget опции аддресс_ссылки
# Можно указать не один URL для загрузки, а сразу несколько. Опции указывать не обязательно, но в большинстве случаев они используются для настройки параметров загрузки.
# Команда wget linux, обычно поставляется по умолчанию в большинстве дистрибутивов, но если нет, её можно очень просто установить.
# https://losst.ru/komanda-wget-linux
# ============================================================================

### Creating sysctl
echo ""
echo -e "${GREEN}=> ${BOLD}Создадим конфигурационный файл для установки системных переменных /etc/sysctl.conf ${NC}"
#echo 'Создадим конфигурационный файл для установки системных переменных /etc/sysctl.conf'
# Creating a configuration file for setting system variables /etc/sysctl.conf
echo " Sysctl - это инструмент для проверки и изменения параметров ядра во время выполнения (пакет procps-ng в официальных репозиториях ). sysctl реализован в procfs , файловой системе виртуального процесса в /proc/. "
# Sysctl is a tool for checking and changing kernel parameters at runtime (the procps-ng package in official repositories). sysctl is implemented in procfs, the file system of a virtual process in /proc/.
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

#-----------------------------------------------------------------

### Creating sysctl
echo -e "${BLUE}:: ${NC}Перемещаем и переименовываем исходный файл /etc/sysctl.conf в /etc/sysctl.d/99-sysctl.conf"
#echo 'Перемещаем и переименовываем исходный файл /etc/sysctl.conf в /etc/sysctl.d/99-sysctl.conf'
# Move and rename the source file /etc/sysctl.conf to /etc/sysctl.d / 99-sysctl.conf
# pacman -Syu
# Для начала сделаем его бэкап следующей командой:
cp /etc/sysctl.conf  /etc/sysctl.conf.back
# Открываем файл для редактирования:
# mcgedit /etc/sysctl.conf
# Чтобы посмотреть возможные параметры выполним:
# sysctl -a  # Список может быть достаточно большим!
# Перемещаем и переименовываем исходный файл
mv /etc/sysctl.conf /etc/sysctl.d/99-sysctl.conf
# mv /etc/sysctl.conf.pacsave /etc/sysctl.d/99-sysctl.conf
#mv /etc/sysctl.conf /etc/sysctl.d/99-sysctl-performance-tweaks.conf
# Если в файл /etc/sysctl.conf не вносилось никаких изменений, то и делать ничего не нужно.
# -----------------------------------------------------------------
# Начиная с версии 207, systemd больше не будет применять настройки из файла /etc/sysctl.conf. Вместо этого будут использоваться файлы /etc/sysctl.d/*. Так-как настройки из нашего /etc/sysctl.conf из пакета procps-ng стали умолчаниями ядра, было решено отказаться от использования этого файла.
# Sysctl файл преднагрузка / конфигурация может быть создан /etc/sysctl.d/99-sysctl.conf. Для Systemd , /etc/sysctl.d/и /usr/lib/sysctl.d/это падение в каталогах для параметров ядра SYSCTL. Именование и исходный каталог определяют порядок обработки, что важно, поскольку последний обработанный параметр может иметь приоритет над более ранними. Например, параметры в a /usr/lib/sysctl.d/50-default.confбудут заменены одинаковыми параметрами в, /etc/sysctl.d/50-default.confа любой файл конфигурации будет обработан позже из обоих каталогов.
# Чтобы загрузить все файлы конфигурации вручную, выполните:
# sysctl --system 
# который также выведет примененную иерархию. Файл с одним параметром также можно загрузить явно с помощью:
# sysctl --load = filename.conf
# Примечание: Если у вас установлена ​​документация ядра ( linux-docs ), вы можете найти подробную информацию о настройках sysctl в /usr/lib/modules/$(uname -r)/build/Documentation/sysctl/. Настоятельно рекомендуется прочитать их перед изменением настроек sysctl.
# Настройки можно изменить с помощью файловых операций или с помощью sysctlутилиты. Например, чтобы временно включить волшебный ключ SysRq :
# sysctl kernel.sysrq = 1
# или:
# echo "1"> / proc / sys / kernel / sysrq
# Смотрите Linux Kernel документации для деталей о kernel.sysrq.
# Чтобы сохранить изменения между перезагрузками, добавьте или измените соответствующие строки /etc/sysctl.d/99-sysctl.conf или другой подходящий файл параметров в /etc/sysctl.d/.
# ==================================================================

echo -e "${BLUE}:: ${NC}Добавим в файл /etc/arch-release ссылку на сведение о release"
#echo 'Добавим в файл /etc/arch-release ссылку на сведение о release'
# Add a link to the release information to the /etc/arch-release file
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

# ==================================================================

echo -e "${BLUE}:: ${NC}Создадим файл /etc/lsb-release (информация о релизе)"
#echo 'Создадим файл /etc/lsb-release (информация о релизе)'
# Create the file /etc/lsb-release (information about release)
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

# ==================================================================

#read -p "Введите допольнительные пакеты которые вы хотите установить: " packages 
#pacman -S $packages --noconfirm

clear
echo -e "${MAGENTA}
  <<< Установка AUR (Arch User Repository) - репозиторий, в который пользователи загружают скрипты для установки программного обеспечения >>> ${NC}"
# Installing an Aur (Arch User Repository) - a repository where users upload scripts to install software.
echo -e "${YELLOW}==> Примечание:${BOLD}Сейчас Вы можете пропустить установку "AUR", пункт для установки "AUR" будет продублирован в следующем скрипте (archmy3l). И Вы сможете установить "AUR Helper" уже из установленной системы.${NC}"


echo -e "${GREEN}==> ${NC}Установка AUR Helper (yay) или (pikaur)"
#echo -e "${BLUE}:: ${NC}Установка AUR Helper (yay) или (pikaur)" 
#echo 'Установка AUR Helper (yay) или (pikaur)'
# Installing AUR Helper (yay) or (pikaur)
echo -e "${YELLOW}==> ${BOLD}Важно! Pikaur - идёт как зависимость для Octopi. ${NC}"
echo -e "${MAGENTA}:: ${NC} В AUR - есть практически всё, что можно установить на Linux. В том числе и программы, которые для других дистробутивов пришлось бы собирать из исходников"
echo -e "${CYAN}=> ${BOLD}В сценарии скрипта присутствуют следующие варианты: ${NC}"
echo " 1 - Установка 'AUR'-'yay' с помощью скрипта созданного (autor): Alex Creio https://cvc.hashbase.io/ - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/yay-git/), собирается и устанавливается, то выбирайте вариант - "1". "
echo " 2 - Установка 'AUR'-'yay' с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/yay.git), собирается и устанавливается, то выбирайте вариант - "2"."
echo " 3 - Установка 'AUR'-'pikaur' с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/pikaur.git), собирается и устанавливается, то выбирайте вариант - "3". "
echo " Подчеркну (обратить внимание)! Pikaur - идёт как зависимость для Octopi."
echo " Будьте внимательны! В этом действии выбор остаётся за вами."
# Be careful! In this action, the choice is yours.
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления" 
#echo 'Установка производится в порядке перечисления'
# Installation Is performed in the order listed
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - AUR - yay (yay-install.sh), 2 - AUR - yay, 3 - AUR - pikaur, 0 - Пропустить установку AUR Helper: " in_aur_help  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - AUR - yay (yay-install.sh),     2 - AUR - yay (git clone),     3 - AUR - pikaur (git clone),

    0 - Пропустить установку AUR Helper: " in_aur_help  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_aur_help" =~ [^1230] ]]
do
    :
done 
if [[ $in_aur_help == 0 ]]; then
clear    
echo " Установка AUR Helper (yay) пропущена "
elif [[ $in_aur_help == 1 ]]; then
sudo pacman -Syu
wget git.io/yay-install.sh && sh yay-install.sh --noconfirm
clear
echo " Установка AUR Helper (yay) завершена "
# ------------------------------------------------------------
# Скрипт yay-install.sh:
#!/usr/bin/env bash
# Install script yay
# autor: Alex Creio https://cvc.hashbase.io/

# wget git.io/yay-install.sh && sh yay-install.sh
#sudo pacman -S --noconfirm --needed wget curl git 
#git clone https://aur.archlinux.org/yay-bin.git
#cd yay-bin
### makepkg -si
#makepkg -si --skipinteg
#cd ..
#rm -rf yay-bin
# ------------------------------------------------------------
elif [[ $in_aur_help == 2 ]]; then
pacman -Syu    
#sudo pacman -Syu
#sudo pacman -S git
cd /home/$username
git clone https://aur.archlinux.org/yay.git
chown -R $username:users /home/$username/yay
chown -R $username:users /home/$username/yay/PKGBUILD 
cd /home/$username/yay  
sudo -u $username  makepkg -si --noconfirm  
rm -Rf /home/$username/yay
clear
echo " Установка AUR Helper (yay) завершена "
elif [[ $in_aur_help == 3 ]]; then
pacman -Syu    
#sudo pacman -Syu
#sudo pacman -S git    
cd /home/$username
git clone https://aur.archlinux.org/pikaur.git
chown -R $username:users /home/$username/pikaur   
chown -R $username:users /home/$username/pikaur/PKGBUILD 
cd /home/$username/pikaur   
sudo -u $username  makepkg -si --noconfirm  
rm -Rf /home/$username/pikaur
clear
echo " Установка AUR Helper (pikaur) завершена "
fi
#--------------------------------------------------------------
# AUR (Arch User Repository) - репозиторий, в который пользователи загружают скрипты для установки программного обеспечения. Там есть практически всё, что можно установить на Linux. В том числе и программы, которые для других дистробутивов пришлось бы собирать из исходников.
# AUR'ом можно пользоваться и просто с помощью Git. Но куда удобнее использовать помощник AUR. Они бывают графические и консольные.
# Загвоздка в том, что все помощники доступны только в самом AUR 😅 Поэтому будем устанавливать через Git, так как по-сути, AUR состоит из git-репозиториев
# git clone https://aur.archlinux.org/yay-bin.git
# Если хотите, чтобы yay собирался из исходников, вместо yay-bin.git впишите yay.git.
# https://aur.archlinux.org/packages/yay-bin/
# https://aur.archlinux.org/packages/
# https://github.com/Jguer/yay
# ============================================================================

echo ""
echo -e "${BLUE}:: ${NC}Обновим всю систему включая AUR пакеты" 
#echo 'Обновим всю систему включая AUR пакеты'
# Update the entire system including AUR packages
yay -Syy
yay -Syu

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Snap на Arch Linux?"
#echo -e "${BLUE}:: ${NC}Установить Snap на Arch Linux?" 
#echo 'Установить Snap на Arch Linux?'
# To install Snap-on Arch Linux?
echo -e "${MAGENTA}:: ${BOLD}Snap - это инструмент для развертывания программного обеспечения и управления пакетами,  которые обновляются автоматически, просты в установке, безопасны, кроссплатформенны и не имеют зависимостей. Изначально разработанный и созданный компанией Canonical, который работает в различных дистрибутивах Linux каждый день. ${NC}"
echo -e "${CYAN}:: ${NC}Для управления пакетами snap, установим snapd (демон), а также snap-confine, который обеспечивает монтирование, изоляцию и запуск snap-пакетов.  "
echo " Установка происходит из 'AUR'- с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/snapd.git)."
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В любой ситуации выбор всегда остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да установить, 0 - НЕТ - Пропустить установку: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " prog_set  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_set" =~ [^10] ]]
do
    :
done 
if [[ $prog_set == 0 ]]; then    
echo " Установка Snap пропущена "
elif [[ $prog_set == 1 ]]; then
  echo " Установка поддержки Snap "
#sudo pacman -S git  
git clone https://aur.archlinux.org/snapd.git 
chown -R $username:users /home/$username/snapd 
chown -R $username:users /home/$username/snapd/PKGBUILD 
cd /home/$username/snapd 
sudo -u $username  makepkg -si --noconfirm  
rm -Rf /home/$username/snapd
clear
echo ""
echo -e "${BLUE}:: ${NC}Включить модуль systemd, который управляет основным сокетом мгновенной связи" 
sudo systemctl enable --now snapd.socket
# Проверить статус сервиса:
# systemctl status snapd.socket
echo ""
echo -e "${BLUE}:: ${NC}Включить поддержку классической привязки, чтобы создать символическую ссылку между /var/lib/snapd/ snap и /snap" 
sudo ln -s /var/lib/snapd/snap /snap
echo ""
echo -e "${BLUE}:: ${NC}Поскольку бинарный файл находится в каталоге /snap/bin/, нужно добавить его в переменную $PATH." 
echo "export PATH=\$PATH:\/snap/bin/" | sudo tee -a /etc/profile
source /etc/profile
echo ""
echo " Snapd теперь готов к использованию "
echo " Вы взаимодействуете с ним с помощью команды snap. "
# Посмотрите страницу помощи команды:
# snap --help
echo ""
echo -e "${BLUE}:: ${NC}Протестируем систему, установив hello-world snap и убедимся, что она работает правильно."
sudo snap install hello-world
hello-world
echo ""
echo -e "${BLUE}:: ${NC}Список установленных snaps:"
snap list
echo -e "${BLUE}:: ${NC}Удалить установленный snap (hello-world)"
sudo snap remove hello-world
echo ""
echo " Snap теперь установлен и готов к работе! "
fi









clear
echo ""
echo -e "${GREEN}=> ${BOLD}Вы хотите просмотреть и отредактировать файл /etc/fstab (отвечающий за монтирование разделов при запуске системы) ${NC}"
#echo 'Вы хотите просмотреть и отредактировать файл /etc/fstab (отвечающий за монтирование разделов при запуске системы)'
# You want to view and edit the /etc/fstab file (responsible for mounting partitions at system startup)
echo " Данные действия помогут исключить возможные ошибки при первом запуске системы! "
echo " 1 - Просмотреть и отредактировать файл /etc/fstab. "
echo -e "${MAGENTA}=> ${BOLD}Справка: Файл откроется через редактор <nano>, если нужно отредактировать двигаемся стрелочками вниз-вверх, и правим нужную вам строку. После чего Ctrl-O для сохранения жмём Enter, далее Ctrl-X. Или (Ctrl+X и Y и Enter). ${NC}"
echo " 2 - Просмотреть файл /etc/fstab (БЕЗ редактирования). "
echo -e "${MAGENTA}=> ${BOLD}Справка: Файл откроется с помощью команды cat (это сокращения от слова catenate). Команда cat очень проста - она читает данные из файла или стандартного ввода и выводит их на экран. ${NC}"
echo " 3-(0) - Действия просмотра и редактирования будут пропущены! "
echo -e "${YELLOW}==> ${NC}Вы можете пропустить этот шаг, если ранее при генерации файла fstab просмотрели его содержимое, или не уверены в своих действиях"
#echo 'Вы можете пропустить этот шаг, если ранее при генерации файла fstab просмотрели его содержимое, или не уверены в своих действиях'
# You can skip this step if you previously viewed the contents of the fstab file when generating it, or if you are not sure what you are doing
echo ""
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "   
#  read -p " 1 - Да редактировать fstab, 2 - Просмотреть файл fstab, 0 - Нет пропустить этот шаг: " vm_fstab  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
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
  echo ' Этап редактирования пропущен ' 
elif [[ $vm_fstab == 1 ]]; then
nano /etc/fstab
elif [[ $vm_fstab == 2 ]]; then
echo ""    
echo ' Просмотреть содержимое файла fstab '
# View the contents of the fstab file
echo ""    
cat /etc/fstab
#cat < /mnt/etc/fstab | grep -v "Static information"
sleep 2
fi
 
### Clean pacman cache (Очистить кэш pacman)
#echo ""
echo -e "${BLUE}:: ${BOLD}Очистка кэша pacman ${NC}"
#echo 'Очистка кэша pacman'
# Clearing the pacman cache
pacman --noconfirm -Sc       # Очистка кэша неустановленных пакетов
# pacman -Sc                 # --noconfirm      не спрашивать каких-либо подтверждений
# pacman --noconfirm -Scc    # Очистка кэша пакетов
# pacman -Scc                # --noconfirm      не спрашивать каких-либо подтверждений
# pacman -Qqe                # Список установленных пакетов в системе
# ==============================================================
#              
echo -e "${GREEN}
  <<< Поздравляем! Установка завершена. Перезагрузите систему. >>> ${NC}"
# Congratulations! Installation is complete. Reboot the system.
#
echo -e "${BLUE}:: ${BOLD}Посмотрим дату и время ... ${NC}"
#echo 'Посмотрим дату и время'
# Let's look at the date and time
date
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'     # одновременно отображает дату и часовой пояс
#
echo -e "${BLUE}:: ${BOLD}Отобразить время работы системы ... ${NC}"
#echo 'Отобразить время работы системы'
# Display the system's operating time 
uptime
# ---------------------------------------------------------
# 12:35:19 – текущее системное время.
# up 8 min – это время, в течение которого система работала.
# 1 user количество зарегистрированных пользователей.
# load average: 0.66, 0.62, 0.35 – средние значения загрузки системы за последние 1, 5 и 15 минут.
# Как использовать команду Uptime:
# https://andreyex.ru/operacionnaya-sistema-linux/komanda-uptime-v-linux/
# ============================================================

echo -e "${MAGENTA}==> ${BOLD}После перезагрузки и входа в систему проверьте ваши персональные настройки. ${NC}"
#echo 'После перезагрузки и входа в систему проверьте ваши персональные настройки.'
# After restarting and logging in, check your personal settings.

echo -e "${MAGENTA}==> ${BOLD}Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети. ${NC}"
#echo 'Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети.'
# If you have a wireless connection, launch nmtui and connect to the network.
# nmcli dev wifi connect имя_точки password пароль - для подключения к вайфаю

echo -e "${YELLOW}==> ...${NC}"
echo -e "${BLUE}:: ${NC}Если хотите подключить AUR, установить дополнительный софт (пакеты), установить мои конфиги XFCE, тогда после перезагрузки и входа в систему выполните команду:"
#echo 'Если хотите подключить AUR, установить дополнительный софт (пакеты), установить мои конфиги XFCE, тогда после перезагрузки и входа в систему выполните команду:'
# If you want to connect AUR, install additional software (packages), install my Xfce configs, then after restarting and logging in, run the command:
echo -e "${YELLOW}==> ${CYAN}wget git.io/archmy3l && sh archmy3l ${NC}"

echo -e "${RED}==> ${BOLD}Выходим из установленной системы ${NC}"
#echo 'Выходим из установленной системы'
# Exiting the installed system

echo -e "${BLUE}:: ${BOLD}Теперь вам надо ввести exit, затем reboot, чтобы перезагрузиться ${NC}"
#echo 'Теперь вам надо ввести exit, затем reboot, чтобы перезагрузитьсься'
#'Now you need to enter 'reboot' to reboot"'
exit
exit
# ========================================================
###########################################################
# **********************************************************  


