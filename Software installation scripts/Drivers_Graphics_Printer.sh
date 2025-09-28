#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! ####
apptitle="Arch Linux Fast Install v2.5 LegasyBIOS - Version: 2025.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя
###
DRIVERS_GRAPHICS_PRINTER_LANG="russian"  # Installer default language (Язык установки по умолчанию)
ARCHMY3L_LANG="russian"  # Installer default language (Язык установки по умолчанию)
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
### Warning (Предупреждение)
_warning_banner() {
    echo -e "${YELLOW}
   ====================== ♥ Предупреждение ======================
${NC}
 Цель сценария (скрипта) - это установить и настроить Драйверы графических процессоров 🔹 AMD/(ATI), Intel, NVIDIA, а также установка и настройка Драйверы принтера (Поддержка печати) CUPS, HP и Установка дополнительных Xorg (иксов)(X.Org) в установленную систему Arch Linux.
 Arch Linux славится своей простотой, моделью непрерывных выпусков и широкими возможностями управления со стороны пользователя. Одна из ключевых областей, где этот контроль становится особенно полезным (хотя и немного пугающим), — это управление драйверами оборудования, особенно для графических процессоров.
 Если у вас видеокарта AMD/(ATI), Intel, NVIDIA и вы настраиваете Arch Linux, этот сценарий (скрипта) поможет вам установить и настроить правильные драйверы для вашего графического процессора(ов): от идентификации вашего оборудования до установки соответствующих пакетов, распространенных инструментов, утилит для настройки и устранения распространённых проблем. Для графических процессоров AMD/(ATI), Intel, NVIDIA предоставляет драйверы с открытым исходным кодом. Независимо от того, настраиваете ли вы игровую машину, медиацентр или рабочую станцию разработки, поддержка открытого исходного кода гарантирует вам надежную и эффективную работу с графикой в Linux.
 Драйвер с открытым исходным кодом в сочетании с поддержкой Mesa и Vulkan обеспечивает отличную производительность даже в играх и при высоких нагрузках. С правильными пакетами и несколькими этапами проверки вы можете быть уверены, что ваш графический процессор работает на полную мощность в вашей системе Arch Linux. Как всегда в Arch, документация — ваш лучший друг: регулярно пользуйтесь Arch Wiki и не стесняйтесь обращаться к форумам или man - страницам сообщества при изучении расширенных конфигураций.
Смысл в том, что все изменения вы делаете предварительно в самом скрипте и получаете возможность быстрой установки утилит (пакетов), которые Вы решили установить (при условии, что Вы его изменили под себя, в противном случае скрипт установит софт (пакеты) и пропишет тот сценарий, который был прописан в скрипте изначально.
В процессе работы сценария (скрипта) Вам будут задаваться вопросы на установку той, или иной утилиты (пакета) - будьте внимательными!  Прописанный софт (пакеты) скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и выполнения необходимых действий. В любой ситуации выбор всегда за вами. Вы либо гуляете под дождем, либо просто под ним мокнете. 👉👈 ${RED}

  ***************************** ВНИМАНИЕ! *****************************
${NC}
Автор не несёт ответственности за любое нанесение вреда при использовании скрипта.
Вы используйте его на свой страх и риск, или изменяйте под свои личные нужды.
В данный момент сценарий (скрипта) находится в процессе доработки по прописыванию устанавливаемого софта (пакетов),
и небольшой корректировке (Воен. Внесение поправок в наводку орудий по результатам наблюдений с наблюдательных пунктов).

${BLUE}===> ******************************************************* ${NC}"
}
###
### Display banner (Дисплей баннер)
_warning_banner
###
sleep 20
#echo ""
#echo -e "${MAGENTA}==> ${BOLD}Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети. ${NC}"
#echo 'Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети.'
# If you have a wireless connection, launch nmtui and connect to the network.
##################
clear
echo -e "${GREEN}
  <<< Начинается установка первоначально необходимого софта (пакетов) и запуск необходимых служб для системы Arch Linux >>>
${NC}"
# Installation of utilities (packages) for the Arch Linux system begins
echo -e "${BLUE}:: ${NC}Установка и настройка начата в $(date +%T)"
#echo "Установка и настройка начата в $(date +%T)"
# Installation and configuration started in $(date +%T)
###
echo ""
echo -e "${GREEN}=> ${NC}Для проверки интернета можно пропинговать какой-либо сервис"
#echo 'Для проверки интернета можно пропинговать какой-либо сервис'
# To check the Internet, you can ping a service
ping -c 2 archlinux.org  # Утилита ping - это очень простой инструмент для диагностики сети
# ping google.com -W 2 -c 1
## ping -l 3 ya.ru
###
echo -e "${CYAN}==> ${NC}Если пинг идёт едем дальше ... :)"
#echo 'Если пинг идёт едем дальше ... :)'
# If the ping goes we go further ... :)
sleep 1
echo " Чтобы выполнить тест скорости поиска, выберите веб-сайт, который не посещался с момента запуска dnsmasq "
drill archlinux.org | grep "Query time"  # Тест dnsmasq
echo " Выполним опрос DNS-сервера: '1.1.1.1' (@cервер) с запросом archlinux.org (доменное имя интернет-ресурса) "
dig @1.1.1.1 archlinux.org  # для опроса DNS-серверов
###
echo ""
echo -e "${MAGENTA}==> ${NC}Давайте проверим наш часовой пояс ... :)"
#echo 'Давайте проверим наш часовой пояс ... :)'
# Let's check our time zone ... :)
timedatectl | grep "Time zone"
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Если NetworkManager запущен смотрим состояние интерфейсов"
#echo "Если NetworkManager запущен смотрим состояние интерфейсов"
# If NetworkManager is running look at the state of the interfaces
# Первым делом нужно запустить NetworkManager:
# sudo systemctl start NetworkManager
# Если NetworkManager запущен смотрим состояние интерфейсов (с помощью - nmcli):
nmcli general status
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Посмотреть имя хоста"
# View host name
nmcli general hostname
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Получаем состояние интерфейсов"
# Getting the state of interfaces
nmcli device status
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Смотрим список доступных подключений"
# See the list of available connections
nmcli connection show
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Смотрим состояние wifi подключения"
# Looking at the status of the wifi connection
nmcli radio wifi
sleep 1
## ---------------------------------------
## Посмотреть список доступных сетей wifi:
# nmcli device wifi list
## Теперь включаем:
# nmcli radio wifi on
## Или отключаем:
# nmcli radio wifi off
## Команда для подключения к новой сети wifi выглядит не намного сложнее. Например, давайте подключимся к сети TP-Link с паролем 12345678:
## nmcli device wifi connect "TP-Link" password 12345678 name "TP-Link Wifi"
## Если всё прошло хорошо, то вы получите уже привычное сообщение про создание подключения с именем TP-Link Wifi и это имя в дальнейшем можно использовать для редактирования этого подключения и управления им, как описано выше.
## ---------------------------------------
###
echo ""
echo -e "${BLUE}:: ${NC}Посмотрим данные о нашем соединение с помощью IPinfo..."
#echo " Посмотрим данные о нашем соединение с помощью IPinfo..."
# Let's look at the data about our connection using IP info...
echo -e "${CYAN}=> ${NC}С помощью IPinfo вы можете точно определять местонахождение ваших пользователей, настраивать их взаимодействие, предотвращать мошенничество, обеспечивать соответствие и многое другое."
echo " Надежный источник данных IP-адресов (https://ipinfo.io/) "
wget http://ipinfo.io/ip -qO -
sleep 03
###
echo ""
echo -e "${BLUE}:: ${NC}Узнаем версию и данные о релизе Arch'a ... :) "
#echo "Узнаем версию и данные о релизе Arch'a ... :)"
# Find out the version and release data for Arch ... :)
cat /proc/version
cat /etc/lsb-release.old
sleep 02
####################

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
# sudo pacman -Sy --noconfirm  # обновить списки пакетов из репозиториев
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
  echo ""
  echo " Обновление базы данных выполнено "
fi
sleep 1
################

clear
echo -e "${MAGENTA}
  <<< Установка Свободных и Проприетарных драйверов для видеокарт (nvidia, amd, intel), а также драйверов для принтера. >>> ${NC}"
# Install Proprietary drivers for video cards (nvidia, amd, intel), as well as printer drivers.
echo -e "${RED}==> Внимание! ${NC}Если у Вас ноутбук, и установлен X.Org Server (иксы), то в большинстве случаев драйвера для видеокарты уже установлены. Возможно! общий драйвер vesa (xf86-video-vesa), который поддерживает большое количество чипсетов (но не включает 2D или 3D ускорение). (😃)"
######### Drivers ##############
echo ""
echo -e "${GREEN}==> ${NC}Устанавливаем видео драйверы для чипов Intel, AMD/(ATI) и NVIDIA"
echo -e "${BLUE}:: ${NC}Сперва определим вашу видеокарту!"
# First, we will determine your video card!
echo -e "${MAGENTA}=> ${BOLD}Вот данные по вашей видеокарте (даже, если Вы работаете на VM): ${NC}"
#echo ""
lspci | grep -e VGA -e 3D
#lspci | grep -E "VGA|3D"   # узнаем производителя и название видеокарты
#lspci -k | grep -A 2 -E "(VGA|3D)"  # Узнать информацию о видео карте
lspci -nn | grep VGA
#lspci | grep VGA        # узнаем ID шины
lspci -k| grep -EA2 'VGA|3D'  # Чтобы увидеть все карты
#inxi -Gx  # показывает что есть встроенная карта
# После того как вы узнаете PCI-порт видеокарты, например 1с:00.0, можно получить о ней более подробную информацию:
# sudo lspci -v -s 1с:00.0
# Она покажет, какая видеокарта используется:
#grep -Eiwo -m1 'nvidia|amd|ati|intel' /var/log/Xorg.0.log
sleep 5
echo -e "${YELLOW}==> Примечание: ${NC}Для установки библиотек (некоторых) драйверов видеокарт, нужен репозиторий [multilib], надеюсь Вы добавили репозиторий "Multilib" (при установке основной системы)."
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo " 1 - NVIDIA - Если видео карта от Nvidia ставим драйвер (проприетарный по желанию), то выбирайте вариант - "1" "
echo " Узнав модель своего графического процессора, сравните ее с официальным списком драйверов NVIDIA: (https://www.nvidia.com/Download/index.aspx). В Arch есть три основных драйвера NVIDIA: nvidia - Для самых последних графических процессоров. nvidia-dkms - Поддержка динамических модулей ядра. nvidia-390xx - Для старых карт (старше 2014 года). "
echo " 2 - AMD/(ATI) - Если видео карта от Amd ставим драйвер (свободный по желанию), то выбирайте вариант - "2" "
echo " Прежде чем приступить к установке, важно понять различные типы драйверов графических процессоров AMD. AMDGPU - Драйвер по умолчанию для большинства современных графических процессоров AMD (GCN 1.2 и новее, т. е. Radeon Rx 2xx/3xx и выше). Radeon - Старый драйвер, используемый в основном для устаревших графических процессоров (до GCN 1.2). Считается стабильным, но менее производительным и с меньшим количеством функций. Используется автоматически, если графический процессор несовместим с AMDGPU. "
echo " 3 - Intel - Если видео карта от Intel ставим драйвер (свободный по желанию), то выбирайте вариант - "3" "
echo " Arch Linux использует драйвер xf86-video-intel для старых видеокарт Intel. Для нового оборудования часто рекомендуется использовать драйвер настройки режима, встроенный в Xorg (драйвера по умолчанию xorg-server). "
echo " 4 - Intel, AMD/(ATI), NVIDIA и дополнительные инструменты - Если у Вас система Archlinux установлена на внешний накопитель, или USB(флешку), то ЖЕЛАТЕЛЬНО установить все предложенные (свободные и проприетарные) драйвера для видеокарт, выбирайте вариант - "4" "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. В данной опции выбор остаётся за вами. "
# Be careful! The installation process was fully automatic. In this option, the choice is yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - драйвера для NVIDIA,     2 - драйвера для AMD/(ATI),     3 - драйвера для Intel,

    4 - драйверов для Intel, AMD/(ATI), NVIDIA и дополнительные инструменты - (flash drive)

    0 - Пропустить установку: " videocard  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$videocard" =~ [^12340] ]]
do
    :
done
if [[ $videocard == 0 ]]; then
clear
echo ""
echo " Установка драйверов для видеокарт (nvidia, amd, intel) пропущена "
elif [[ $videocard == 1 ]]; then
  echo ""
  echo " Установка Проприетарных драйверов для NVIDIA "
echo " Установка Драйверов Mesa (требуется для игр и Wine/Proton) для графических процессоров AMD "
########## Драйвера Mesa (требуется для игр и Wine/Proton) ############
sudo pacman -S --noconfirm --needed mesa  # Драйверы OpenGL с открытым исходным кодом ; https://archlinux.org/packages/extra/x86_64/mesa/ ; https://www.mesa3d.org/ ; Обеспечивает: libva-driver, libva-mesa-driver=1:25.1.5-1, mesa-libgl=1:25.1.5-1, mesa-vdpau=1:25.1.5-1, opengl-driver, vdpau-driver ; Заменяет: libva-mesa-driver<1:24.2.7-1, mesa-libgl<17.0.1-2, mesa-vdpau<1:24.2.7-1 ; Конфликты: с libva-mesa-driver<1:24.2.7-1, mesa-libgl<17.0.1-2, mesa-vdpau<1:24.2.7-1 ; 2025-07-04 15:59 UTC
sudo pacman -S --noconfirm --needed lib32-mesa  # Реализация спецификации OpenGL с открытым исходным кодом (32-разрядная версия) ; https://archlinux.org/packages/multilib/x86_64/lib32-mesa/ ; https://www.mesa3d.org/ ; Обеспечивает: lib32-libva-driver, lib32-libva-mesa-driver=1:25.1.5-1, lib32-mesa-libgl=1:25.1.5-1, lib32-mesa-vdpau=1:25.1.5-1, lib32-opengl-driver, lib32-vdpau-driver ; Заменяет: lib32-libva-mesa-driver<1:24.2.7-1, lib32-mesa-libgl<17.0.1-2, lib32-mesa-vdpau<1:24.2.7-1 ; Конфликты: с lib32-libva-mesa-driver<1:24.2.7-1, lib32-mesa-libgl<17.0.1-2, lib32-mesa-vdpau<1:24.2.7-1 ; 2025-07-04 15:58 UTC
#########  Модули ядра NVIDIA ############
sudo pacman -S --noconfirm --needed nvidia nvidia-settings  # Модули ядра NVIDIA ; https://archlinux.org/packages/extra/x86_64/nvidia/ ; https://www.nvidia.com/ ; 2025-07-06 17:59 UTC . Инструмент для настройки графического драйвера NVIDIA ; https://archlinux.org/packages/extra/x86_64/nvidia-settings/ ; https://github.com/NVIDIA/nvidia-settings ; 2025-06-19 14:46 UTC
sudo pacman -S --noconfirm --needed nvidia-utils  # Утилиты драйверов NVIDIA ; https://archlinux.org/packages/extra/x86_64/nvidia-utils/ ; http://www.nvidia.com/ ; 2025-07-02 14:28 UTC
sudo pacman -S --noconfirm --needed lib32-nvidia-utils  # Утилиты драйверов NVIDIA (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-nvidia-utils/ ; http://www.nvidia.com/ ; Обеспечивает: ib32-nvidia-libgl, lib32-opengl-driver, lib32-vulkan-driver ; Заменяет: lib32-nvidia-libgl ; Конфликты: с lib32-nvidia-libgl ; 2025-07-02 14:29 UTC
sudo pacman -S --noconfirm --needed libvdpau  # Библиотека Nvidia VDPAU ; https://archlinux.org/packages/extra/x86_64/libvdpau/ ; https://www.freedesktop.org/wiki/Software/VDPAU/ ; Обеспечивает: libvdpau.so=1-64 ; 2024-07-06 15:55 UTC
sudo pacman -S --noconfirm --needed lib32-libvdpau  # Библиотека Nvidia VDPAU ; https://archlinux.org/packages/multilib/x86_64/lib32-libvdpau/ ; https://www.freedesktop.org/wiki/Software/VDPAU/ ; Обеспечивает: libvdpau.so=1-32 ; 2024-09-07 10:21 UTC
sudo pacman -S --noconfirm --needed libvdpau-va-gl # Драйвер VDPAU с бэкэндом OpenGL/VAAPI ; https://archlinux.org/packages/extra/x86_64/libvdpau-va-gl/ ; https://github.com/i-rinat/libvdpau-va-gl ; 2024-07-12 21:34 UTC
####### Реализация OpenCL для NVIDIA ###########
sudo pacman -S --noconfirm --needed opencl-nvidia  # Реализация OpenCL для NVIDIA ; https://archlinux.org/packages/extra/x86_64/opencl-nvidia/ ; http://www.nvidia.com/ ; Обеспечивает: opencl-driver ; 2025-07-02 14:28 UTC
sudo pacman -S --noconfirm --needed lib32-opencl-nvidia  # Реализация OpenCL для NVIDIA (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-opencl-nvidia/ ; http://www.nvidia.com/ ; Обеспечивает: lib32-opencl-driver ; 2025-07-02 14:29 UTC
sudo pacman -S --noconfirm --needed opencl-headers  # Заголовочные файлы OpenCL (открытый язык вычислений) ; https://archlinux.org/packages/extra/any/opencl-headers/ ; https://www.khronos.org/registry/cl/ ; 2024-12-10 05:23 UTC
######### Драйвер 3D-ускорения Nouveau (Только для старых видеокарт) ###########
sudo pacman -S --noconfirm --needed xf86-video-nouveau  # - Драйвер 3D-ускорения с открытым исходным кодом для карт nVidia ; https://archlinux.org/packages/extra/x86_64/xf86-video-nouveau/ ; https://nouveau.freedesktop.org/ ; Конфликты:  X-ABI-VIDEODRV_VERSION<25, X-ABI-VIDEODRV_VERSION>=26, xorg-server<21.1.1 ; 2024-11-12 21:25 UTC - ВОЗМОЖНО уже установлен с (X.org)
#########################
  echo ""
  echo " Если вы используете пользовательское ядро (например linux-zen, или linux-lts), используйте nvidia-dkms вариант "
  echo " Также установите заголовочные файлы ядра, соответствующие вашему ядру "
  echo " sudo pacman -S --noconfirm --needed linux-zen-headers   # if using zen kernel "
  echo " Перед установкой рекомендуется отключить "Secure Boot" в UEFI, ибо из-за этого модули драйвера могут не загрузиться "
  echo " Установим драйвер версии DKMS, который сам подстроится под нужное ядро и не позволит убить систему при обновлении (не касается свободных драйверов Mesa) "
########## Драйвера для NVIDIA версии DKMS ############
#sudo pacman -S --noconfirm --needed nvidia-dkms  # Модули ядра NVIDIA — исходные коды модулей ; https://archlinux.org/packages/extra/x86_64/nvidia-dkms/ ; http://www.nvidia.com/ ; Обеспечивает: NVIDIA-MODULE, nvidia ; Конфликты: с NVIDIA-MODULE, nvidia ; 2025-07-02 14:28 UTC
#sudo pacman -S --noconfirm --needed nvidia-utils  # Утилиты драйверов NVIDIA ; https://archlinux.org/packages/extra/x86_64/nvidia-utils/ ; http://www.nvidia.com/ ; 2025-07-02 14:28 UTC
#sudo pacman -S --noconfirm --needed lib32-nvidia-utils  # Утилиты драйверов NVIDIA (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-nvidia-utils/ ; http://www.nvidia.com/ ; Обеспечивает: ib32-nvidia-libgl, lib32-opengl-driver, lib32-vulkan-driver ; Заменяет: lib32-nvidia-libgl ; Конфликты: с lib32-nvidia-libgl ; 2025-07-02 14:29 UTC
#sudo pacman -S --noconfirm --needed nvidia-settings  # Инструмент для настройки графического драйвера NVIDIA ; https://archlinux.org/packages/extra/x86_64/nvidia-settings/ ; https://github.com/NVIDIA/nvidia-settings ; 2025-06-19 14:46 UTC
########## Расширение NVIDIA NV-CONTROL X ###########
#sudo pacman -S --noconfirm --needed libxext  # Библиотека различных расширений X11 ; https://archlinux.org/packages/extra/x86_64/libxext/ ; https://gitlab.freedesktop.org/xorg/lib/libxext ; 2024-02-05 06:32 UTC
#sudo pacman -S --noconfirm --needed libxnvctrl  # Расширение NVIDIA NV-CONTROL X ; https://archlinux.org/packages/extra/x86_64/libxnvctrl/ ; https://github.com/NVIDIA/nvidia-settings ; Обеспечивает: libXNVCtrl.so=0-64 ; 2025-06-19 14:46 UTC
### sudo pacman -S --noconfirm --needed linux-zen-headers  # Заголовки и скрипты для сборки модулей для ядра Linux ZEN ; https://archlinux.org/packages/extra/x86_64/linux-zen-headers/ ; https://github.com/zen-kernel/zen-kernel ; https://www.kernel.org/doc/html/latest/ ; 2025-07-10 23:55 UTC
#echo " Установка Драйверов Vulkan для графических процессоров AMD "
############## Драйвера Vulkan ###################
######### Загрузчик устанавливаемого клиентского драйвера Vulkan (ICD) ##########
#sudo pacman -S --noconfirm --needed vulkan-icd-loader  # Загрузчик устанавливаемого клиентского драйвера Vulkan (ICD) ; https://archlinux.org/packages/extra/x86_64/vulkan-icd-loader/ ; https://www.vulkan.org/ ; Обеспечивает: libvulkan.so=1-64 ; 2025-05-10 14:47 UTC
#sudo pacman -S --noconfirm --needed lib32-vulkan-icd-loader  # Загрузчик устанавливаемого клиентского драйвера Vulkan (ICD) (32-разрядный) ; https://archlinux.org/packages/multilib/x86_64/lib32-vulkan-icd-loader/ ; https://www.vulkan.org/ ; Обеспечивает: libvulkan.so=1-32 ;
######### Создайте или отредактируйте файл конфигурации X ################
#sudo nvidia-xconfig  # Создание xorg файла etc/X11/xorg.conf (сгенерировать конфиг nvidia-xconfig (для настройки xorg.conf))
# nvidia-xconfig     # сгенерировать конфиг nvidia-xconfig (для настройки xorg.conf)
### 1. Находит файл конфигурации X и читает его в память. Если файла нет, nvidia-xconfig генерирует его с настройками по умолчанию, записывая конфигурацию в файл xorg.conf.
### 2. Модифицирует конфигурацию в памяти, чтобы она поддерживала драйвер NVIDIA: меняет драйвер дисплея на «nvidia», удаляет команды для загрузки модулей «GLcore» и «dri».
################ Проверка активен ли драйвер ##########
# nvidia-smi  # проверьте, активен ли драйвер ; Вы должны увидеть свой графический процессор, версию драйвера и статистику использования. Пример вывода: NVIDIA-SMI 550.54       Driver Version: 550.54       CUDA Version: 12.3    |
# Если nvidia-smiне удалось, проверьте логи:
# dmesg | grep -i nvidia
# Или просмотрите журнал Xorg:
# cat /var/log/Xorg.0.log | grep -i nvidia
# nvidia_driver="mhwd -a pci nonfree 0300"
echo " Обновляем образы ядра "
sudo mkinitcpio -P # Обновляем образы ядра ; Чтобы (повторно) сгенерировать все существующие предустановки, используйте параметр -P/--allpresets. Обычно это используется для регенерации всех образов initramfs после изменения глобальных настроек: https://wiki.archlinux.org/title/Mkinitcpio_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
##########
clear
echo ""
echo " Установка драйверов для видеокарт (nvidia) выполнена "
elif [[ $videocard == 2 ]]; then
echo ""
echo " Установка Свободных драйверов для AMD/(ATI) "
echo " Установка Драйверов Mesa (требуется для игр и Wine/Proton) для графических процессоров AMD "
########## Драйвера Mesa (требуется для игр и Wine/Proton) ############
sudo pacman -S --noconfirm --needed mesa  # Драйверы OpenGL с открытым исходным кодом ; https://archlinux.org/packages/extra/x86_64/mesa/ ; https://www.mesa3d.org/ ; Обеспечивает: libva-driver, libva-mesa-driver=1:25.1.5-1, mesa-libgl=1:25.1.5-1, mesa-vdpau=1:25.1.5-1, opengl-driver, vdpau-driver ; Заменяет: libva-mesa-driver<1:24.2.7-1, mesa-libgl<17.0.1-2, mesa-vdpau<1:24.2.7-1 ; Конфликты: с libva-mesa-driver<1:24.2.7-1, mesa-libgl<17.0.1-2, mesa-vdpau<1:24.2.7-1 ; 2025-07-04 15:59 UTC
sudo pacman -S --noconfirm --needed lib32-mesa  # Реализация спецификации OpenGL с открытым исходным кодом (32-разрядная версия) ; https://archlinux.org/packages/multilib/x86_64/lib32-mesa/ ; https://www.mesa3d.org/ ; Обеспечивает: lib32-libva-driver, lib32-libva-mesa-driver=1:25.1.5-1, lib32-mesa-libgl=1:25.1.5-1, lib32-mesa-vdpau=1:25.1.5-1, lib32-opengl-driver, lib32-vdpau-driver ; Заменяет: lib32-libva-mesa-driver<1:24.2.7-1, lib32-mesa-libgl<17.0.1-2, lib32-mesa-vdpau<1:24.2.7-1 ; Конфликты: с lib32-libva-mesa-driver<1:24.2.7-1, lib32-mesa-libgl<17.0.1-2, lib32-mesa-vdpau<1:24.2.7-1 ; 2025-07-04 15:58 UTC
sudo pacman -S --noconfirm --needed mesa-demos  # Демоверсии Mesa и инструменты, включая glxinfo + glxgears ; https://archlinux.org/packages/extra/x86_64/mesa-demos/ ; https://www.mesa3d.org/ ; 2025-06-13 23:38 UTC
sudo pacman -S --noconfirm --needed lib32-mesa-demos  # Демонстрации и инструменты Mesa (32-разрядная версия) ; https://archlinux.org/packages/multilib/x86_64/lib32-mesa-demos/ ; http://mesa3d.sourceforge.net/ ; 2025-06-14 00:08 UTC
########################
sudo pacman -S --noconfirm --needed mesa-vdpau  # mesa # Драйверы Mesa
sudo pacman -S --noconfirm --needed lib32-mesa-vdpau  # lib32-mesa # Драйверы Mesa
echo " Включение аппаратного ускорения (необязательно) "
echo " Для более плавного воспроизведения видео вы можете включить VA-API (Video Acceleration API) "
sudo pacman -S --noconfirm --needed libva-mesa-driver # mesa # Драйверы Mesa
sudo pacman -S --noconfirm --needed lib32-libva-mesa-driver  # lib32-mesa # Драйверы Mesa
echo " Тест VA-API - В случае успеха вы увидите подробную информацию о поддерживаемых кодеках "
echo " Для видеоплееров, таких как mpv или vlc , можно включить аппаратное ускорение VA-API для более эффективного воспроизведения "
vainfo
sleep 03
echo " Установка Основных утилит Mesa "
echo " Инструменты для управления питанием и переключения графических процессоров "
sudo pacman -S --noconfirm --needed mesa-utils  # Основные коммунальные услуги Месы ; https://www.mesa3d.org/ ; https://archlinux.org/packages/extra/x86_64/mesa-utils/
sudo pacman -S --noconfirm --needed lib32-mesa-utils  # Основные утилиты Mesa (32-бит) ; http://mesa3d.sourceforge.net/ ; https://archlinux.org/packages/multilib/x86_64/lib32-mesa-utils/
#echo " Установка дополнительных драйверов для виртуальной машины "
#sudo pacman -S --noconfirm --needed mesa-amber  # Классические драйверы OpenGL (не Gallium3D) ; https://archlinux.org/packages/extra/x86_64/mesa-amber/ ; https://www.mesa3d.org/ ; Обеспечивает: mesa=21.3.9, opengl-driver ; Конфликты: с mesa ; 2024-01-01 01:06 UTC ; Если лагает на старых GPU
#sudo pacman -S --noconfirm --needed lib32-mesa-amber  # Классические драйверы OpenGL (не Gallium3D) (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-mesa-amber/ ; https://www.mesa3d.org/ ; Обеспечивает: lib32-mesa=21.3.9, lib32-opengl-драйвер ; Конфликты: с lib32-mesa ; 2024-01-01 01:06 UTC
echo " Установка Драйверов Vulkan для графических процессоров AMD "
############## Драйвера Vulkan ###################
sudo pacman -S --noconfirm --needed vulkan-radeon  # Драйвер Vulkan с открытым исходным кодом для графических процессоров AMD ; Драйвер Radeon Vulkan mesa ; https://archlinux.org/packages/extra/x86_64/vulkan-radeon/ ; https://www.mesa3d.org/ ; Обеспечивает: vulkan-driver ; 2025-07-04 15:59 UTC
sudo pacman -S --noconfirm --needed lib32-vulkan-radeon  # Драйвер Vulkan с открытым исходным кодом для графических процессоров AMD — 32-бит ; Драйвер Radeon Vulkan mesa (32-разрядный) ; https://archlinux.org/packages/multilib/x86_64/lib32-vulkan-radeon/ ; https://www.mesa3d.org/ ; Обеспечивает: lib32-vulcan-driver ; 2025-07-04 15:58 UTC
######### Слои Vulkan от Mesa ###########
sudo pacman -S --noconfirm --needed vulkan-mesa-layers  # Вулканические слои Месы ; https://archlinux.org/packages/extra/x86_64/vulkan-mesa-layers/ ; https://www.mesa3d.org/ ; Заменяет: vulkan-mesa-layer ; Конфликты: с vulkan-mesa-layer ; 2025-07-04 15:59 UTC
sudo pacman -S --noconfirm --needed lib32-vulkan-mesa-layers  # Слои Vulkan от Mesa — 32 бита ; https://archlinux.org/packages/multilib/x86_64/lib32-vulkan-mesa-layers/ ; https://www.mesa3d.org/ ; Заменяет: lib32-vulkan-mesa-layer ; Конфликты: lib32-vulkan-mesa-layer ; 2025-07-04 15:58 UTC
######### Дополнительные уровни отладки, полезные для разработки или устранения неполадок ##########
sudo pacman -S --noconfirm --needed vulkan-validation-layers  # Слои проверки Vulkan ; https://archlinux.org/packages/extra/x86_64/vulkan-validation-layers/ ; https://www.vulkan.org/ ; 2025-05-10 14:47 UTC
sudo pacman -S --noconfirm --needed lib32-vulkan-validation-layers  # Слои проверки Vulkan (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-vulkan-validation-layers/ ; https://www.vulkan.org/ ; 2025-05-10 14:47 UTC
######### Загрузчик устанавливаемого клиентского драйвера Vulkan (ICD) ##########
sudo pacman -S --noconfirm --needed vulkan-icd-loader  # Загрузчик устанавливаемого клиентского драйвера Vulkan (ICD) ; https://archlinux.org/packages/extra/x86_64/vulkan-icd-loader/ ; https://www.vulkan.org/ ; Обеспечивает: libvulkan.so=1-64 ; 2025-05-10 14:47 UTC
sudo pacman -S --noconfirm --needed lib32-vulkan-icd-loader  # Загрузчик устанавливаемого клиентского драйвера Vulkan (ICD) (32-разрядный) ; https://archlinux.org/packages/multilib/x86_64/lib32-vulkan-icd-loader/ ; https://www.vulkan.org/ ; Обеспечивает: libvulkan.so=1-32 ; 2025-05-10 14:47 UTC
######### Автономный драйвер Vulkan от AMD ###############
sudo pacman -S --noconfirm --needed amdvlk   # Автономный драйвер Vulkan от AMD ; https://archlinux.org/packages/extra/x86_64/amdvlk/ ; https://github.com/GPUOpen-Drivers ; Обеспечивает: vulkan-driver ; 2025-05-04 05:46 UTC
sudo pacman -S --noconfirm --needed lib32-amdvlk  # Автономный драйвер Vulkan от AMD ; https://archlinux.org/packages/multilib/x86_64/lib32-amdvlk/ ; https://github.com/GPUOpen-Drivers ; Обеспечивает: lib32-vulcan-driver ; 2025-05-04 05:46 UTC
echo " Инструменты и утилиты Vulkan (настройка поддержки Vulkan) "
sudo pacman -S --noconfirm --needed vulkan-tools # Инструменты и утилиты Vulkan ; https://archlinux.org/packages/extra/x86_64/vulkan-tools/ ; https://www.vulkan.org/ ; 2025-05-10 14:47 UTC ; Включает в себя инструменты командной строки, такие как vulkaninfo и cube .
echo " Распространенные инструменты и утилиты Vulkan "
####### RenderDoc : популярный графический отладчик Vulkan/OpenGL ######
sudo pacman -S --noconfirm --needed renderdoc  # Инструмент отладки OpenGL и Vulkan ; https://archlinux.org/packages/extra/x86_64/renderdoc/ ; https://github.com/baldurk/renderdoc ; 2025-06-09 16:21 UTC
### RenderDoc — графический отладчик, основанный на захвате кадров, в настоящее время доступный для разработки с использованием Vulkan, D3D11, D3D12, OpenGL и OpenGL ES на Windows, Linux, Android и Nintendo Switch™. Он полностью открыт и распространяется по лицензии MIT. RenderDoc предназначен исключительно для отладки ваших собственных программ. Любое обсуждение захвата программ, созданных не вами, запрещено в официальных публичных настройках RenderDoc, включая систему отслеживания ошибок, Discord или электронную почту. Например, это касается захвата коммерческих игр, созданных не вами, а также захвата Google Карт или Google Планета Земля.
####### VKmark : инструмент для тестирования Vulkan (доступен в AUR) ######
### После установки вы можете запустить vkmark с помощью: vkmark [options...]
sudo pacman -S --noconfirm --needed vkmark  # Бенчмарк Vulkan (vkmark — расширяемый набор инструментов для бенчмаркинга Vulkan с целевыми настраиваемыми сценами) ; https://archlinux.org/packages/extra/x86_64/vkmark/ ; https://github.com/vkmark/vkmark ; 2025-07-01 20:59 UTC
############ DXVK : транслирует вызовы Direct3D 9/10/11 в Vulkan. Используется Wine/Proton ########
####### dxvk-bin ###########
yay -S dxvk-bin --noconfirm  # Совместимый слой на базе Vulkan для Direct3D 9/10/11, позволяющий запускать 3D-приложения в Linux с использованием Wine (двоичные файлы Windows DLL) ; https://aur.archlinux.org/packages/dxvk-bin ; https://aur.archlinux.org/dxvk-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/doitsujin/dxvk ; Обеспечивает: d9vk, dxvk ; Конфликты: с d9vk, dxvk ; https://github.com/doitsujin/dxvk/releases/download/v2.7/dxvk-2.7.tar.gz ; https://aur.archlinux.org/cgit/aur.git/tree/setup_dxvk.sh?h=dxvk-bin ; 2025-07-07 13:30 (UTC)
####### dxvk-bin ###########
#git clone https://aur.archlinux.org/dxvk-bin.git  # (только для чтения, нажмите, чтобы скопировать)
#cd dxvk-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf dxvk-bin
#rm -Rf dxvk-bin
################
echo " Проверить поддержку Vulkan "
vulkaninfo | less
sleep 03
#echo " Вы также можете протестировать: "
#echo " Откроется вращающийся 3D-куб. Если вы его видите, значит, ваш Vulkan работает "
# vkcube  #
### Vulkan — это кроссплатформенный API для 3D-графики и вычислений с низкими накладными расходами, разработанный Khronos Group. Он обеспечивает высокоэффективный и производительный доступ к современным графическим процессорам, что делает его предпочтительным выбором для игр, 3D-рендеринга и научных вычислений. В Arch Linux, благодаря циклу обновлений и современному репозиторию, Vulkan поддерживается стабильно и регулярно обновляется. Vulkan часто рассматривается как преемник OpenGL, предлагающий более высокую производительность и более прямой контроль над операциями графического процессора. Хотя OpenGL проще в использовании для новичков, детальный API Vulkan позволяет разработчикам добиться большей производительности, особенно в многопоточных приложениях.
echo " Установка Свободных драйверов для AMDGPU (amdgpu) (для пользователей X11) "
echo " Драйвер по умолчанию для большинства современных графических процессоров AMD (GCN 1.2 и новее, т. е. Radeon Rx 2xx/3xx и выше). "
echo " Активно разрабатывается AMD и сообществом разработчиков ПО с открытым исходным кодом. "
echo " Поддерживается непосредственно в ядре Linux и пакетах Mesa. "
########## Драйвера X.org для AMDGPU (для пользователей X11) ##########
sudo pacman -S --noconfirm --needed xf86-video-amdgpu  # Видеодрайвер X.org amdgpu ; https://archlinux.org/packages/extra/x86_64/xf86-video-amdgpu/ ; https://xorg.freedesktop.org/ ; Конфликты: с X-ABI-VIDEODRV_VERSION<25, X-ABI-VIDEODRV_VERSION>=26, xorg-server<1.20.0 ; Последнее обновление:  2024-03-31 20:19 UTC - ВОЗМОЖНО уже установлен с (X.org)
sudo pacman -S --noconfirm --needed linux-firmware-amdgpu  # Файлы прошивки для Linux — Прошивка для графических процессоров AMD Radeon ; https://archlinux.org/packages/core/any/linux-firmware-amdgpu/ ; https://gitlab.com/kernel-firmware/linux-firmware ; 2025-07-10 23:55 UTC
echo " Установка Свободных драйверов для AMD (ATI)(Radeon) (Для старых графических процессоров) "
echo " Если ваш графический процессор слишком старый для использования amdgpu "
echo " Старый драйвер, используемый в основном для устаревших графических процессоров (до GCN 1.2). "
echo " Считается стабильным, но менее производительным и с меньшим количеством функций. "
echo " Используется автоматически, если графический процессор несовместим с AMDGPU "
######### Для старых графических процессоров ##########
### Если ваш графический процессор слишком старый для использования amdgpu, установите:
sudo pacman -S --noconfirm --needed xf86-video-ati  # Видеодрайвер X.org ati - ВОЗМОЖНО уже установлен с (X.org)
### При необходимости вы также можете добавить драйвер в черный список amdgpu, хотя большинство систем автоматически определяют нужный драйвер на основе ядра.
############# Драйвер VDPAU ############
sudo pacman -S --noconfirm --needed libvdpau-va-gl # Драйвер VDPAU с бэкэндом OpenGL/VAAPI ; https://archlinux.org/packages/extra/x86_64/libvdpau-va-gl/ ; https://github.com/i-rinat/libvdpau-va-gl ; 2024-07-12 21:34 UTC
echo " Обновляем образы ядра "
sudo mkinitcpio -P # Обновляем образы ядра ; Чтобы (повторно) сгенерировать все существующие предустановки, используйте параметр -P/--allpresets. Обычно это используется для регенерации всех образов initramfs после изменения глобальных настроек: https://wiki.archlinux.org/title/Mkinitcpio_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
echo " Установка драйверов для видеокарт (amd/ati) выполнена "
############
clear
echo ""
echo " Установка драйверов для видеокарт (amd/ati) выполнена "
elif [[ $videocard == 3 ]]; then
  echo ""
  echo " Установка Свободных драйверов для Intel "
echo " Установка вспомогательных пакетов для правильного рендеринга и ускорения "
echo " Установка Драйверов Mesa (требуется для игр и Wine/Proton) для графических процессоров Intel "
########## Драйвера Mesa (требуется для игр и Wine/Proton) ############
sudo pacman -S --noconfirm --needed mesa  # Драйверы OpenGL с открытым исходным кодом ; https://archlinux.org/packages/extra/x86_64/mesa/ ; https://www.mesa3d.org/ ; Обеспечивает: libva-driver, libva-mesa-driver=1:25.1.5-1, mesa-libgl=1:25.1.5-1, mesa-vdpau=1:25.1.5-1, opengl-driver, vdpau-driver ; Заменяет: libva-mesa-driver<1:24.2.7-1, mesa-libgl<17.0.1-2, mesa-vdpau<1:24.2.7-1 ; Конфликты: с libva-mesa-driver<1:24.2.7-1, mesa-libgl<17.0.1-2, mesa-vdpau<1:24.2.7-1 ; 2025-07-04 15:59 UTC
sudo pacman -S --noconfirm --needed lib32-mesa  # Реализация спецификации OpenGL с открытым исходным кодом (32-разрядная версия) ; https://archlinux.org/packages/multilib/x86_64/lib32-mesa/ ; https://www.mesa3d.org/ ; Обеспечивает: lib32-libva-driver, lib32-libva-mesa-driver=1:25.1.5-1, lib32-mesa-libgl=1:25.1.5-1, lib32-mesa-vdpau=1:25.1.5-1, lib32-opengl-driver, lib32-vdpau-driver ; Заменяет: lib32-libva-mesa-driver<1:24.2.7-1, lib32-mesa-libgl<17.0.1-2, lib32-mesa-vdpau<1:24.2.7-1 ; Конфликты: с lib32-libva-mesa-driver<1:24.2.7-1, lib32-mesa-libgl<17.0.1-2, lib32-mesa-vdpau<1:24.2.7-1 ; 2025-07-04 15:58 UTC
echo " Установка Драйверов Vulkan для графических процессоров Intel "
############## Драйвера Vulkan ###################
sudo pacman -S --noconfirm --needed vulkan-intel  # Драйвер Vulkan с открытым исходным кодом для графических процессоров Intel ; https://archlinux.org/packages/extra/x86_64/vulkan-intel/ ; https://www.mesa3d.org/ ; Обеспечивает: vulkan-driver ; 2025-07-04 15:59 UTC
sudo pacman -S --noconfirm --needed lib32-vulkan-intel  # Драйвер Vulkan с открытым исходным кодом для графических процессоров Intel — 32-бит ; https://archlinux.org/packages/multilib/x86_64/lib32-vulkan-intel/ ; https://www.mesa3d.org/ ; Обеспечивает: lib32-vulkan-driver ; 2025-07-04 15:58 UTC
######### Загрузчик устанавливаемого клиентского драйвера Vulkan (ICD) ##########
sudo pacman -S --noconfirm --needed vulkan-icd-loader  # Загрузчик устанавливаемого клиентского драйвера Vulkan (ICD) ; https://archlinux.org/packages/extra/x86_64/vulkan-icd-loader/ ; https://www.vulkan.org/ ; Обеспечивает: libvulkan.so=1-64 ; 2025-05-10 14:47 UTC
sudo pacman -S --noconfirm --needed lib32-vulkan-icd-loader  # Загрузчик устанавливаемого клиентского драйвера Vulkan (ICD) (32-разрядный) ; https://archlinux.org/packages/multilib/x86_64/lib32-vulkan-icd-loader/ ; https://www.vulkan.org/ ; Обеспечивает: libvulkan.so=1-32 ; 2025-05-10 14:47 UTC
echo " Установка Свободных драйвера(ов) Intel DDX (xf86-video-intel) для старых видеокарт Intel "
echo " Примечание: Драйвер xf86-video-intel необязателен. Известно, что он вызывает проблемы на новых чипсетах, поэтому его использование обычно не рекомендуется, если только вам не нужны такие функции, как TearFree, или у вас старый процессор (до Haswell). Для большинства систем, начиная с Haswell (Intel 4-го поколения), предпочтительным является режим настройки , не требующий установки дополнительных драйверов, кроме драйвера по умолчанию xorg-server. "
echo " Модуль xf86-video-intel — это драйвер 2D-графики с открытым исходным кодом для X Window System, реализованная X.org. Она поддерживает множество Графических чипсетов Intel, включая: i810/i810e/i810-dc100,i815, i830M,845G,852GM,855GM,865G, 915G/GM, 945G/GM/GME, 946GZG/GM/GME/Q965, G/Q33,G/Q35,G41,G/Q43,G/GM/Q45, PineView-M (Atom N400 series), PineView-D (Atom D400/D500 series), Intel(R) HD Graphics, Intel(R) Iris(TM) Graphics, Intel(R) Iris(TM) Pro Graphics. "
sudo pacman -S --noconfirm --needed xf86-video-intel  # Видеодрайверы X.org Intel i810/i830/i915/945G/G965+ ; https://archlinux.org/packages/extra/x86_64/xf86-video-intel/ ; https://gitlab.freedesktop.org/xorg/driver/xf86-video-intel ; Обеспечивает: xf86-видео-intel-sna, xf86-видео-intel-uxa ; Заменяет:  xf86-видео-intel-sna, xf86-видео-intel-uxa ; Конфликты: с X-ABI-VIDEODRV_VERSION<25, X-ABI-VIDEODRV_VERSION>=26, xf86-video-i810, xf86-video-intel-legacy, xf86-video-intel-sna ; 2025-03-23 16:06 UTC ; - ВОЗМОЖНО уже установлен с (X.org)
#################
echo " Реализация VA-API для семейства Intel G45 и HD Graphics "
echo " VA-API — это библиотека с открытым исходным кодом и спецификация API, предоставляющая доступ к возможностям аппаратного ускорения графики для обработки видео. Она состоит из основной библиотеки и специфичных для драйверов бэкендов ускорения для каждого поддерживаемого производителя оборудования. "
########### API видеоускорения (VA) для Linux ############
sudo pacman -S --noconfirm --needed libva  # API видеоускорения (VA) для Linux ; https://archlinux.org/packages/extra/x86_64/libva/ ; https://01.org/linuxmedia/vaapi ; Обеспечивает: libva-drm.so=2-64, libva-glx.so=2-64, libva-wayland.so=2-64, libva-x11.so=2-64, libva.so=2-64 ; 28 июля 2024 г. 14:17 UTC
sudo pacman -S --noconfirm --needed lib32-libva  # API видеоускорения (VA) для Linux (32-разрядный) ; https://archlinux.org/packages/multilib/x86_64/lib32-libva/ ; https://01.org/linuxmedia/vaapi ; Обеспечивает: libva-drm.so=2-32, libva-glx.so=2-32, libva-wayland.so=2-32, libva-x11.so=2-32, libva.so=2-32 ; 2024-08-06 22:44 UTC
sudo pacman -S --noconfirm --needed libva-utils  # Приложения и скрипты Intel VA-API Media для libva ; https://archlinux.org/packages/extra/x86_64/libva-utils/ ; https://github.com/intel/libva-utils ; 2024-06-24 20:52 UTC

############# Реализация VA-API для семейства Intel G45 и HD Graphics ############
sudo pacman -S --noconfirm --needed libva-intel-driver # Реализация VA-API для семейства Intel G45 и HD Graphics ; https://archlinux.org/packages/extra/x86_64/libva-intel-driver/ ; https://01.org/linuxmedia/vaapi ; Заменяет: libva-intel-driver ; 2025-04-21 13:57 UTC
### Примечание: libva-intel-driver используется для старых графических процессоров Intel.
sudo pacman -S --noconfirm --needed lib32-libva-intel-driver # Реализация VA-API для семейства Intel G45 и HD Graphics (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-libva-intel-driver/ ; https://freedesktop.org/wiki/Software/vaapi ; 2024-09-07 10:21 UTC
sudo pacman -S --noconfirm --needed vdpauinfo  # Утилита командной строки для запроса возможностей устройства VDPAU ; https://archlinux.org/packages/extra/x86_64/vdpauinfo/ ; https://gitlab.freedesktop.org/vdpau/vdpauinfo ; 2024-07-14 01:23 UTC
echo " Установка драйвера Intel(R) Media Driver для новых графических процессоров Intel (Gen8+, Gen12 / Xe) "
echo " Расширенная поддержка VA-API для нового оборудования Intel "
echo " Media Driver - Является современной заменой libva-intel-driver "
########## Аппаратное ускорение видео ##############
sudo pacman -S --noconfirm --needed intel-media-driver  # Драйвер Intel Media для VAAPI — Broadwell+ iGPU ; https://archlinux.org/packages/extra/x86_64/intel-media-driver/ ; https://github.com/intel/media-driver/ ; 2025-06-25 20:24 UTC
### Intel(R) Media Driver для VAAPI — это новый драйвер пользовательского режима VA-API (Video Acceleration API), поддерживающий аппаратное ускорение декодирования, кодирования и постобработки видео для графического оборудования на базе GEN.
sudo pacman -S --noconfirm --needed libvdpau-va-gl # Драйвер VDPAU с бэкэндом OpenGL/VAAPI ; https://archlinux.org/packages/extra/x86_64/libvdpau-va-gl/ ; https://github.com/i-rinat/libvdpau-va-gl ; 2024-07-12 21:34 UTC
echo " Обновляем образы ядра "
sudo mkinitcpio -P # Обновляем образы ядра ; Чтобы (повторно) сгенерировать все существующие предустановки, используйте параметр -P/--allpresets. Обычно это используется для регенерации всех образов initramfs после изменения глобальных настроек: https://wiki.archlinux.org/title/Mkinitcpio_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
echo ""
echo " Установка драйверов для видеокарт (intel) выполнена "
elif [[ $videocard == 4 ]]; then
  clear
  echo ""
  echo " Установка Проприетарных драйверов для NVIDIA "
#########  Модули ядра NVIDIA ############
sudo pacman -S --noconfirm --needed nvidia nvidia-settings  # Модули ядра NVIDIA ; https://archlinux.org/packages/extra/x86_64/nvidia/ ; https://www.nvidia.com/ ; 2025-07-06 17:59 UTC . Инструмент для настройки графического драйвера NVIDIA ; https://archlinux.org/packages/extra/x86_64/nvidia-settings/ ; https://github.com/NVIDIA/nvidia-settings ; 2025-06-19 14:46 UTC
sudo pacman -S --noconfirm --needed nvidia-utils  # Утилиты драйверов NVIDIA ; https://archlinux.org/packages/extra/x86_64/nvidia-utils/ ; http://www.nvidia.com/ ; 2025-07-02 14:28 UTC
sudo pacman -S --noconfirm --needed lib32-nvidia-utils  # Утилиты драйверов NVIDIA (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-nvidia-utils/ ; http://www.nvidia.com/ ; Обеспечивает: ib32-nvidia-libgl, lib32-opengl-driver, lib32-vulkan-driver ; Заменяет: lib32-nvidia-libgl ; Конфликты: с lib32-nvidia-libgl ; 2025-07-02 14:29 UTC
sudo pacman -S --noconfirm --needed libvdpau  # Библиотека Nvidia VDPAU ; https://archlinux.org/packages/extra/x86_64/libvdpau/ ; https://www.freedesktop.org/wiki/Software/VDPAU/ ; Обеспечивает: libvdpau.so=1-64 ; 2024-07-06 15:55 UTC
sudo pacman -S --noconfirm --needed lib32-libvdpau  # Библиотека Nvidia VDPAU ; https://archlinux.org/packages/multilib/x86_64/lib32-libvdpau/ ; https://www.freedesktop.org/wiki/Software/VDPAU/ ; Обеспечивает: libvdpau.so=1-32 ; 2024-09-07 10:21 UTC
sudo pacman -S --noconfirm --needed libvdpau-va-gl # Драйвер VDPAU с бэкэндом OpenGL/VAAPI ; https://archlinux.org/packages/extra/x86_64/libvdpau-va-gl/ ; https://github.com/i-rinat/libvdpau-va-gl ; 2024-07-12 21:34 UTC
####### Реализация OpenCL для NVIDIA ###########
sudo pacman -S --noconfirm --needed opencl-nvidia  # Реализация OpenCL для NVIDIA ; https://archlinux.org/packages/extra/x86_64/opencl-nvidia/ ; http://www.nvidia.com/ ; Обеспечивает: opencl-driver ; 2025-07-02 14:28 UTC
sudo pacman -S --noconfirm --needed lib32-opencl-nvidia  # Реализация OpenCL для NVIDIA (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-opencl-nvidia/ ; http://www.nvidia.com/ ; Обеспечивает: lib32-opencl-driver ; 2025-07-02 14:29 UTC
sudo pacman -S --noconfirm --needed opencl-headers  # Заголовочные файлы OpenCL (открытый язык вычислений) ; https://archlinux.org/packages/extra/any/opencl-headers/ ; https://www.khronos.org/registry/cl/ ; 2024-12-10 05:23 UTC
######### Драйвер 3D-ускорения ###########
sudo pacman -S --noconfirm --needed xf86-video-nouveau  # - Драйвер 3D-ускорения с открытым исходным кодом для карт nVidia ; https://archlinux.org/packages/extra/x86_64/xf86-video-nouveau/ ; https://nouveau.freedesktop.org/ ; Конфликты:  X-ABI-VIDEODRV_VERSION<25, X-ABI-VIDEODRV_VERSION>=26, xorg-server<21.1.1 ; 2024-11-12 21:25 UTC - ВОЗМОЖНО уже установлен с (X.org)
#########################
  echo ""
  echo " Если вы используете пользовательское ядро (например linux-zen, или linux-lts), используйте nvidia-dkms вариант "
  echo " Также установите заголовочные файлы ядра, соответствующие вашему ядру "
  echo " sudo pacman -S --noconfirm --needed linux-zen-headers   # if using zen kernel "
#sudo pacman -S --noconfirm --needed nvidia-dkms  # Модули ядра NVIDIA — исходные коды модулей ; https://archlinux.org/packages/extra/x86_64/nvidia-dkms/ ; http://www.nvidia.com/ ; Обеспечивает: NVIDIA-MODULE, nvidia ; Конфликты: с NVIDIA-MODULE, nvidia ; 2025-07-02 14:28 UTC
#sudo pacman -S --noconfirm --needed nvidia-utils  # Утилиты драйверов NVIDIA ; https://archlinux.org/packages/extra/x86_64/nvidia-utils/ ; http://www.nvidia.com/ ; 2025-07-02 14:28 UTC
#sudo pacman -S --noconfirm --needed lib32-nvidia-utils  # Утилиты драйверов NVIDIA (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-nvidia-utils/ ; http://www.nvidia.com/ ; Обеспечивает: ib32-nvidia-libgl, lib32-opengl-driver, lib32-vulkan-driver ; Заменяет: lib32-nvidia-libgl ; Конфликты: с lib32-nvidia-libgl ; 2025-07-02 14:29 UTC
#sudo pacman -S --noconfirm --needed nvidia-settings  # Инструмент для настройки графического драйвера NVIDIA ; https://archlinux.org/packages/extra/x86_64/nvidia-settings/ ; https://github.com/NVIDIA/nvidia-settings ; 2025-06-19 14:46 UTC
### sudo pacman -S --noconfirm --needed linux-zen-headers  # Заголовки и скрипты для сборки модулей для ядра Linux ZEN ; https://archlinux.org/packages/extra/x86_64/linux-zen-headers/ ; https://github.com/zen-kernel/zen-kernel ; https://www.kernel.org/doc/html/latest/ ; 2025-07-10 23:55 UTC
######### Создайте или отредактируйте файл конфигурации X ################
#sudo nvidia-xconfig  # Создание xorg файла etc/X11/xorg.conf (сгенерировать конфиг nvidia-xconfig (для настройки xorg.conf))
# nvidia-xconfig     # сгенерировать конфиг nvidia-xconfig (для настройки xorg.conf)
### 1. Находит файл конфигурации X и читает его в память. Если файла нет, nvidia-xconfig генерирует его с настройками по умолчанию, записывая конфигурацию в файл xorg.conf.
### 2. Модифицирует конфигурацию в памяти, чтобы она поддерживала драйвер NVIDIA: меняет драйвер дисплея на «nvidia», удаляет команды для загрузки модулей «GLcore» и «dri».
################ Проверка активен ли драйвер ##########
# nvidia-smi  # проверьте, активен ли драйвер ; Вы должны увидеть свой графический процессор, версию драйвера и статистику использования. Пример вывода: NVIDIA-SMI 550.54       Driver Version: 550.54       CUDA Version: 12.3    |
# Если nvidia-smiне удалось, проверьте логи:
# dmesg | grep -i nvidia
# Или просмотрите журнал Xorg:
# cat /var/log/Xorg.0.log | grep -i nvidia
# nvidia_driver="mhwd -a pci nonfree 0300"
echo " Установка драйверов для видеокарт (nvidia) выполнена "
echo ""
echo " Установка Свободных драйверов для AMD/(ATI) "
echo " Установка Драйверов Mesa (требуется для игр и Wine/Proton) для графических процессоров AMD "
########## Драйвера Mesa (требуется для игр и Wine/Proton) ############
sudo pacman -S --noconfirm --needed mesa  # Драйверы OpenGL с открытым исходным кодом ; https://archlinux.org/packages/extra/x86_64/mesa/ ; https://www.mesa3d.org/ ; Обеспечивает: libva-driver, libva-mesa-driver=1:25.1.5-1, mesa-libgl=1:25.1.5-1, mesa-vdpau=1:25.1.5-1, opengl-driver, vdpau-driver ; Заменяет: libva-mesa-driver<1:24.2.7-1, mesa-libgl<17.0.1-2, mesa-vdpau<1:24.2.7-1 ; Конфликты: с libva-mesa-driver<1:24.2.7-1, mesa-libgl<17.0.1-2, mesa-vdpau<1:24.2.7-1 ; 2025-07-04 15:59 UTC
sudo pacman -S --noconfirm --needed lib32-mesa  # Реализация спецификации OpenGL с открытым исходным кодом (32-разрядная версия) ; https://archlinux.org/packages/multilib/x86_64/lib32-mesa/ ; https://www.mesa3d.org/ ; Обеспечивает: lib32-libva-driver, lib32-libva-mesa-driver=1:25.1.5-1, lib32-mesa-libgl=1:25.1.5-1, lib32-mesa-vdpau=1:25.1.5-1, lib32-opengl-driver, lib32-vdpau-driver ; Заменяет: lib32-libva-mesa-driver<1:24.2.7-1, lib32-mesa-libgl<17.0.1-2, lib32-mesa-vdpau<1:24.2.7-1 ; Конфликты: с lib32-libva-mesa-driver<1:24.2.7-1, lib32-mesa-libgl<17.0.1-2, lib32-mesa-vdpau<1:24.2.7-1 ; 2025-07-04 15:58 UTC
sudo pacman -S --noconfirm --needed mesa-demos  # Демоверсии Mesa и инструменты, включая glxinfo + glxgears ; https://archlinux.org/packages/extra/x86_64/mesa-demos/ ; https://www.mesa3d.org/ ; 2025-06-13 23:38 UTC
sudo pacman -S --noconfirm --needed lib32-mesa-demos  # Демонстрации и инструменты Mesa (32-разрядная версия) ; https://archlinux.org/packages/multilib/x86_64/lib32-mesa-demos/ ; http://mesa3d.sourceforge.net/ ; 2025-06-14 00:08 UTC
########################
sudo pacman -S --noconfirm --needed mesa-vdpau  # mesa # Драйверы Mesa
sudo pacman -S --noconfirm --needed lib32-mesa-vdpau  # lib32-mesa # Драйверы Mesa
echo " Включение аппаратного ускорения (необязательно) "
echo " Для более плавного воспроизведения видео вы можете включить VA-API (Video Acceleration API) "
sudo pacman -S --noconfirm --needed libva-mesa-driver # mesa # Драйверы Mesa
sudo pacman -S --noconfirm --needed lib32-libva-mesa-driver  # lib32-mesa # Драйверы Mesa
# echo " Тест VA-API - В случае успеха вы увидите подробную информацию о поддерживаемых кодеках "
# echo " Для видеоплееров, таких как mpv или vlc , можно включить аппаратное ускорение VA-API для более эффективного воспроизведения "
# vainfo
# sleep 03
echo " Установка Основных утилит Mesa "
echo " Инструменты для управления питанием и переключения графических процессоров "
sudo pacman -S --noconfirm --needed mesa-utils  # Основные коммунальные услуги Месы ; https://www.mesa3d.org/ ; https://archlinux.org/packages/extra/x86_64/mesa-utils/
sudo pacman -S --noconfirm --needed lib32-mesa-utils  # Основные утилиты Mesa (32-бит) ; http://mesa3d.sourceforge.net/ ; https://archlinux.org/packages/multilib/x86_64/lib32-mesa-utils/
#echo " Установка дополнительных драйверов для виртуальной машины "
#sudo pacman -S --noconfirm --needed mesa-amber  # Классические драйверы OpenGL (не Gallium3D) ; https://archlinux.org/packages/extra/x86_64/mesa-amber/ ; https://www.mesa3d.org/ ; Обеспечивает: mesa=21.3.9, opengl-driver ; Конфликты: с mesa ; 2024-01-01 01:06 UTC ; Если лагает на старых GPU
#sudo pacman -S --noconfirm --needed lib32-mesa-amber  # Классические драйверы OpenGL (не Gallium3D) (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-mesa-amber/ ; https://www.mesa3d.org/ ; Обеспечивает: lib32-mesa=21.3.9, lib32-opengl-драйвер ; Конфликты: с lib32-mesa ; 2024-01-01 01:06 UTC
echo " Установка Драйверов Vulkan для графических процессоров AMD "
############## Драйвера Vulkan ###################
sudo pacman -S --noconfirm --needed vulkan-radeon  # Драйвер Vulkan с открытым исходным кодом для графических процессоров AMD ; Драйвер Radeon Vulkan mesa ; https://archlinux.org/packages/extra/x86_64/vulkan-radeon/ ; https://www.mesa3d.org/ ; Обеспечивает: vulkan-driver ; 2025-07-04 15:59 UTC
sudo pacman -S --noconfirm --needed lib32-vulkan-radeon  # Драйвер Vulkan с открытым исходным кодом для графических процессоров AMD — 32-бит ; Драйвер Radeon Vulkan mesa (32-разрядный) ; https://archlinux.org/packages/multilib/x86_64/lib32-vulkan-radeon/ ; https://www.mesa3d.org/ ; Обеспечивает: lib32-vulcan-driver ; 2025-07-04 15:58 UTC
######### Слои Vulkan от Mesa ###########
sudo pacman -S --noconfirm --needed vulkan-mesa-layers  # Вулканические слои Месы ; https://archlinux.org/packages/extra/x86_64/vulkan-mesa-layers/ ; https://www.mesa3d.org/ ; Заменяет: vulkan-mesa-layer ; Конфликты: с vulkan-mesa-layer ; 2025-07-04 15:59 UTC
sudo pacman -S --noconfirm --needed lib32-vulkan-mesa-layers  # Слои Vulkan от Mesa — 32 бита ; https://archlinux.org/packages/multilib/x86_64/lib32-vulkan-mesa-layers/ ; https://www.mesa3d.org/ ; Заменяет: lib32-vulkan-mesa-layer ; Конфликты: lib32-vulkan-mesa-layer ; 2025-07-04 15:58 UTC
######### Дополнительные уровни отладки, полезные для разработки или устранения неполадок ##########
sudo pacman -S --noconfirm --needed vulkan-validation-layers  # Слои проверки Vulkan ; https://archlinux.org/packages/extra/x86_64/vulkan-validation-layers/ ; https://www.vulkan.org/ ; 2025-05-10 14:47 UTC
sudo pacman -S --noconfirm --needed lib32-vulkan-validation-layers  # Слои проверки Vulkan (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-vulkan-validation-layers/ ; https://www.vulkan.org/ ; 2025-05-10 14:47 UTC
######### Загрузчик устанавливаемого клиентского драйвера Vulkan (ICD) ##########
sudo pacman -S --noconfirm --needed vulkan-icd-loader  # Загрузчик устанавливаемого клиентского драйвера Vulkan (ICD) ; https://archlinux.org/packages/extra/x86_64/vulkan-icd-loader/ ; https://www.vulkan.org/ ; Обеспечивает: libvulkan.so=1-64 ; 2025-05-10 14:47 UTC
sudo pacman -S --noconfirm --needed lib32-vulkan-icd-loader  # Загрузчик устанавливаемого клиентского драйвера Vulkan (ICD) (32-разрядный) ; https://archlinux.org/packages/multilib/x86_64/lib32-vulkan-icd-loader/ ; https://www.vulkan.org/ ; Обеспечивает: libvulkan.so=1-32 ; 2025-05-10 14:47 UTC
######### Автономный драйвер Vulkan от AMD ###############
sudo pacman -S --noconfirm --needed amdvlk   # Автономный драйвер Vulkan от AMD ; https://archlinux.org/packages/extra/x86_64/amdvlk/ ; https://github.com/GPUOpen-Drivers ; Обеспечивает: vulkan-driver ; 2025-05-04 05:46 UTC
sudo pacman -S --noconfirm --needed lib32-amdvlk  # Автономный драйвер Vulkan от AMD ; https://archlinux.org/packages/multilib/x86_64/lib32-amdvlk/ ; https://github.com/GPUOpen-Drivers ; Обеспечивает: lib32-vulcan-driver ; 2025-05-04 05:46 UTC
echo " Инструменты и утилиты Vulkan (настройка поддержки Vulkan) "
sudo pacman -S --noconfirm --needed vulkan-tools # Инструменты и утилиты Vulkan ; https://archlinux.org/packages/extra/x86_64/vulkan-tools/ ; https://www.vulkan.org/ ; 2025-05-10 14:47 UTC ; Включает в себя инструменты командной строки, такие как vulkaninfo и cube .
echo " Распространенные инструменты и утилиты Vulkan "
####### RenderDoc : популярный графический отладчик Vulkan/OpenGL ######
sudo pacman -S --noconfirm --needed renderdoc  # Инструмент отладки OpenGL и Vulkan ; https://archlinux.org/packages/extra/x86_64/renderdoc/ ; https://github.com/baldurk/renderdoc ; 2025-06-09 16:21 UTC
### RenderDoc — графический отладчик, основанный на захвате кадров, в настоящее время доступный для разработки с использованием Vulkan, D3D11, D3D12, OpenGL и OpenGL ES на Windows, Linux, Android и Nintendo Switch™. Он полностью открыт и распространяется по лицензии MIT. RenderDoc предназначен исключительно для отладки ваших собственных программ. Любое обсуждение захвата программ, созданных не вами, запрещено в официальных публичных настройках RenderDoc, включая систему отслеживания ошибок, Discord или электронную почту. Например, это касается захвата коммерческих игр, созданных не вами, а также захвата Google Карт или Google Планета Земля.
####### VKmark : инструмент для тестирования Vulkan (доступен в AUR) ######
### После установки вы можете запустить vkmark с помощью: vkmark [options...]
sudo pacman -S --noconfirm --needed vkmark  # Бенчмарк Vulkan (vkmark — расширяемый набор инструментов для бенчмаркинга Vulkan с целевыми настраиваемыми сценами) ; https://archlinux.org/packages/extra/x86_64/vkmark/ ; https://github.com/vkmark/vkmark ; 2025-07-01 20:59 UTC
############ DXVK : транслирует вызовы Direct3D 9/10/11 в Vulkan. Используется Wine/Proton ########
####### dxvk-bin ###########
yay -S dxvk-bin --noconfirm  # Совместимый слой на базе Vulkan для Direct3D 9/10/11, позволяющий запускать 3D-приложения в Linux с использованием Wine (двоичные файлы Windows DLL) ; https://aur.archlinux.org/packages/dxvk-bin ; https://aur.archlinux.org/dxvk-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/doitsujin/dxvk ; Обеспечивает: d9vk, dxvk ; Конфликты: с d9vk, dxvk ; https://github.com/doitsujin/dxvk/releases/download/v2.7/dxvk-2.7.tar.gz ; https://aur.archlinux.org/cgit/aur.git/tree/setup_dxvk.sh?h=dxvk-bin ; 2025-07-07 13:30 (UTC)
####### dxvk-bin ###########
#git clone https://aur.archlinux.org/dxvk-bin.git  # (только для чтения, нажмите, чтобы скопировать)
#cd dxvk-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf dxvk-bin
#rm -Rf dxvk-bin
################
# echo " Проверить поддержку Vulkan "
# vulkaninfo | less
# sleep 03
#echo " Вы также можете протестировать: "
#echo " Откроется вращающийся 3D-куб. Если вы его видите, значит, ваш Vulkan работает "
# vkcube  #
### Vulkan — это кроссплатформенный API для 3D-графики и вычислений с низкими накладными расходами, разработанный Khronos Group. Он обеспечивает высокоэффективный и производительный доступ к современным графическим процессорам, что делает его предпочтительным выбором для игр, 3D-рендеринга и научных вычислений. В Arch Linux, благодаря циклу обновлений и современному репозиторию, Vulkan поддерживается стабильно и регулярно обновляется. Vulkan часто рассматривается как преемник OpenGL, предлагающий более высокую производительность и более прямой контроль над операциями графического процессора. Хотя OpenGL проще в использовании для новичков, детальный API Vulkan позволяет разработчикам добиться большей производительности, особенно в многопоточных приложениях.
echo " Установка Свободных драйверов для AMDGPU (amdgpu) (для пользователей X11) "
########## Драйвера X.org для AMDGPU (для пользователей X11) ##########
sudo pacman -S --noconfirm --needed xf86-video-amdgpu  # Видеодрайвер X.org amdgpu ; https://archlinux.org/packages/extra/x86_64/xf86-video-amdgpu/ ; https://xorg.freedesktop.org/ ; Конфликты: с X-ABI-VIDEODRV_VERSION<25, X-ABI-VIDEODRV_VERSION>=26, xorg-server<1.20.0 ; Последнее обновление:  2024-03-31 20:19 UTC - ВОЗМОЖНО уже установлен с (X.org)
sudo pacman -S --noconfirm --needed linux-firmware-amdgpu  # Файлы прошивки для Linux — Прошивка для графических процессоров AMD Radeon ; https://archlinux.org/packages/core/any/linux-firmware-amdgpu/ ; https://gitlab.com/kernel-firmware/linux-firmware ; 2025-07-10 23:55 UTC
echo " Установка Свободных драйверов для AMD (ATI) (Для старых графических процессоров) "
echo " Если ваш графический процессор слишком старый для использования amdgpu "
######### Для старых графических процессоров ##########
### Если ваш графический процессор слишком старый для использования amdgpu, установите:
sudo pacman -S --noconfirm --needed xf86-video-ati  # Видеодрайвер X.org ati - ВОЗМОЖНО уже установлен с (X.org)
### При необходимости вы также можете добавить драйвер в черный список amdgpu, хотя большинство систем автоматически определяют нужный драйвер на основе ядра.
############# Драйвер VDPAU ############
sudo pacman -S --noconfirm --needed libvdpau-va-gl # Драйвер VDPAU с бэкэндом OpenGL/VAAPI ; https://archlinux.org/packages/extra/x86_64/libvdpau-va-gl/ ; https://github.com/i-rinat/libvdpau-va-gl ; 2024-07-12 21:34 UTC
echo " Установка драйверов для видеокарт (amd/ati) выполнена "
echo ""
echo " Установка Свободных драйверов для Intel "
echo " Установка Свободных драйвера(ов) Intel DDX (xf86-video-intel) для старых видеокарт Intel "
echo " Примечание: Драйвер xf86-video-intel необязателен. Известно, что он вызывает проблемы на новых чипсетах, поэтому его использование обычно не рекомендуется, если только вам не нужны такие функции, как TearFree, или у вас старый процессор (до Haswell). Для большинства систем, начиная с Haswell (Intel 4-го поколения), предпочтительным является режим настройки , не требующий установки дополнительных драйверов, кроме драйвера по умолчанию xorg-server. "
echo " Модуль xf86-video-intel — это драйвер 2D-графики с открытым исходным кодом для X Window System, реализованная X.org. Она поддерживает множество Графических чипсетов Intel, включая: i810/i810e/i810-dc100,i815, i830M,845G,852GM,855GM,865G, 915G/GM, 945G/GM/GME, 946GZG/GM/GME/Q965, G/Q33,G/Q35,G41,G/Q43,G/GM/Q45, PineView-M (Atom N400 series), PineView-D (Atom D400/D500 series), Intel(R) HD Graphics, Intel(R) Iris(TM) Graphics, Intel(R) Iris(TM) Pro Graphics. "
sudo pacman -S --noconfirm --needed xf86-video-intel  # Видеодрайверы X.org Intel i810/i830/i915/945G/G965+ ; https://archlinux.org/packages/extra/x86_64/xf86-video-intel/ ; https://gitlab.freedesktop.org/xorg/driver/xf86-video-intel ; Обеспечивает: xf86-видео-intel-sna, xf86-видео-intel-uxa ; Заменяет:  xf86-видео-intel-sna, xf86-видео-intel-uxa ; Конфликты: с X-ABI-VIDEODRV_VERSION<25, X-ABI-VIDEODRV_VERSION>=26, xf86-video-i810, xf86-video-intel-legacy, xf86-video-intel-sna ; 2025-03-23 16:06 UTC ; - ВОЗМОЖНО уже установлен с (X.org)
#################
echo " Установка вспомогательных пакетов для правильного рендеринга и ускорения "
echo " Установка Драйверов Vulkan для графических процессоров Intel "
############## Драйвера Vulkan ###################
sudo pacman -S --noconfirm --needed vulkan-intel  # Драйвер Vulkan с открытым исходным кодом для графических процессоров Intel ; https://archlinux.org/packages/extra/x86_64/vulkan-intel/ ; https://www.mesa3d.org/ ; Обеспечивает: vulkan-driver ; 2025-07-04 15:59 UTC
sudo pacman -S --noconfirm --needed lib32-vulkan-intel  # Драйвер Vulkan с открытым исходным кодом для графических процессоров Intel — 32-бит ; https://archlinux.org/packages/multilib/x86_64/lib32-vulkan-intel/ ; https://www.mesa3d.org/ ; Обеспечивает: lib32-vulkan-driver ; 2025-07-04 15:58 UTC
echo " Реализация VA-API для семейства Intel G45 и HD Graphics "
echo " VA-API — это библиотека с открытым исходным кодом и спецификация API, предоставляющая доступ к возможностям аппаратного ускорения графики для обработки видео. Она состоит из основной библиотеки и специфичных для драйверов бэкендов ускорения для каждого поддерживаемого производителя оборудования. "
########### API видеоускорения (VA) для Linux ############
sudo pacman -S --noconfirm --needed libva  # API видеоускорения (VA) для Linux ; https://archlinux.org/packages/extra/x86_64/libva/ ; https://01.org/linuxmedia/vaapi ; Обеспечивает: libva-drm.so=2-64, libva-glx.so=2-64, libva-wayland.so=2-64, libva-x11.so=2-64, libva.so=2-64 ; 28 июля 2024 г. 14:17 UTC
sudo pacman -S --noconfirm --needed lib32-libva  # API видеоускорения (VA) для Linux (32-разрядный) ; https://archlinux.org/packages/multilib/x86_64/lib32-libva/ ; https://01.org/linuxmedia/vaapi ; Обеспечивает: libva-drm.so=2-32, libva-glx.so=2-32, libva-wayland.so=2-32, libva-x11.so=2-32, libva.so=2-32 ; 2024-08-06 22:44 UTC
sudo pacman -S --noconfirm --needed libva-utils  # Приложения и скрипты Intel VA-API Media для libva ; https://archlinux.org/packages/extra/x86_64/libva-utils/ ; https://github.com/intel/libva-utils ; 2024-06-24 20:52 UTC

############# Реализация VA-API для семейства Intel G45 и HD Graphics ############
sudo pacman -S --noconfirm --needed libva-intel-driver # Реализация VA-API для семейства Intel G45 и HD Graphics ; https://archlinux.org/packages/extra/x86_64/libva-intel-driver/ ; https://01.org/linuxmedia/vaapi ; Заменяет: libva-intel-driver ; 2025-04-21 13:57 UTC
### Примечание: libva-intel-driver используется для старых графических процессоров Intel.
sudo pacman -S --noconfirm --needed lib32-libva-intel-driver # Реализация VA-API для семейства Intel G45 и HD Graphics (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-libva-intel-driver/ ; https://freedesktop.org/wiki/Software/vaapi ; 2024-09-07 10:21 UTC
sudo pacman -S --noconfirm --needed vdpauinfo  # Утилита командной строки для запроса возможностей устройства VDPAU ; https://archlinux.org/packages/extra/x86_64/vdpauinfo/ ; https://gitlab.freedesktop.org/vdpau/vdpauinfo ; 2024-07-14 01:23 UTC
echo " Установка драйвера Intel(R) Media Driver для новых графических процессоров Intel (Gen8+, Gen12 / Xe) "
echo " Расширенная поддержка VA-API для нового оборудования Intel "
echo " Media Driver - Является современной заменой libva-intel-driver "
########## Аппаратное ускорение видео ##############
sudo pacman -S --noconfirm --needed intel-media-driver  # Драйвер Intel Media для VAAPI — Broadwell+ iGPU ; https://archlinux.org/packages/extra/x86_64/intel-media-driver/ ; https://github.com/intel/media-driver/ ; 2025-06-25 20:24 UTC
### Intel(R) Media Driver для VAAPI — это новый драйвер пользовательского режима VA-API (Video Acceleration API), поддерживающий аппаратное ускорение декодирования, кодирования и постобработки видео для графического оборудования на базе GEN.
echo " Установка драйверов для видеокарт (intel) выполнена "
echo ""
echo " Установка дополнительных инструментов и драйверов "
sudo pacman -S --noconfirm --needed xf86-video-sisusb   # X.org SiS USB видеодрайвер ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xf86-video-sisusb/ ; 2024-03-23 10:37 UTC ; Конфликты: с X-ABI-VIDEODRV_VERSION<25, X-ABI-VIDEODRV_VERSION>=26, xorg-server<21.1.1
sudo pacman -S --noconfirm --needed xf86-input-elographics  # Драйвер ввода X.org Elographics TouchScreen ; https://archlinux.org/packages/extra/x86_64/xf86-input-elographics/ ; https://gitlab.freedesktop.org/xorg/driver/xf86-input-elographics ; Конфликты:  X-ABI-XINPUT_VERSION<24, X-ABI-XINPUT_VERSION>=25, xorg-server<21.1.1
# sudo pacman -S --noconfirm --needed xf86-input-libinput --noconfirm  #  Универсальный драйвер ввода для сервера X.Org на основе libinput ; https://archlinux.org/packages/extra/x86_64/xf86-input-libinput/ ; http://xorg.freedesktop.org/ ; Конфликты: с X-ABI-XINPUT_VERSION<24, X-ABI-XINPUT_VERSION>=25, xorg-server<1.19.0 ; 2024-10-15 12:49 UTC
# sudo pacman -S --noconfirm --needed xf86-input-synaptics --noconfirm  #  Драйвер Synaptics для сенсорных панелей ноутбуков ; https://archlinux.org/packages/extra/x86_64/xf86-input-synaptics/ ; https://xorg.freedesktop.org/ ; Обеспечивает: synaptics ; Заменяет: synaptics ; Конфликты: с synaptics ; 2025-01-07 14:44 UTC
#sudo pacman -S --noconfirm --needed xf86-video-vesa  # X.org vesa видео драйвер
echo " Установка дополнительных драйверов и утилит для NVIDIA "
echo " Для систем, использующих гибридную графику (например, ноутбуки с Intel и NVIDIA), рассмотрите возможность установки nvidia-prime или optimus-manager "
echo " Установка Optimus Manager "
sudo pacman -S --noconfirm --needed nvidia-prime  # Конфигурация и утилиты NVIDIA Prime Render Offload ; https://archlinux.org/packages/extra/any/nvidia-prime/ ; https://www.archlinux.org/packages/extra/any/nvidia-prime/ ; 2024-07-13 00:41 UTC
#echo " Установка Optimus Manager "
#echo " Используйте optimus-manager --switch nvidia для переключения в режим NVIDIA "
######### Обновим списки пакетов из репозиториев #############
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
######### Установка optimus-manager-git ################
### yay -S optimus-manager  # Позволяет использовать графику Nvidia Optimus для ноутбуков
#yay -S optimus-manager-git --needed  # Позволяет использовать графику Nvidia Optimus для ноутбуков использующих гибридную графику (например, ноутбуки с Intel и NVIDIA) ; https://aur.archlinux.org/packages/optimus-manager-git ; https://aur.archlinux.org/optimus-manager-git.git (только для чтения, нажмите, чтобы скопировать) ; Конфликты: с bumblebee, envycontrol, nvidia-exec, nvidia-switch, nvidia-xrun, optimus-manager, switcheroo-control ; Обеспечивает: optimus-manager ; git+https://github.com/Askannz/optimus-manager.git ; 2025-05-14 04:33 (UTC)
######### optimus-manager-git ################
#git clone https://aur.archlinux.org/optimus-manager-git.git  # (только для чтения, нажмите, чтобы скопировать)
#cd optimus-manager-git
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf optimus-manager-git
#rm -Rf optimus-manager-git
#echo " Включить автозапуск службы optimus-manager.service "
#sudo systemctl enable optimus-manager.service  # Включить автозапуск службы optimus-manager.service
#######################
echo " Тест VA-API - В случае успеха вы увидите подробную информацию о поддерживаемых кодеках "
echo " Для видеоплееров, таких как mpv или vlc , можно включить аппаратное ускорение VA-API для более эффективного воспроизведения "
vainfo
sleep 03
# ---------------------------------------------------------------------------------- #
### ------------ Эти драйвера отсутствуют, Но! Есть замена !!! В AUR ----------- ####
###sudo pacman -S ipw2100-fw --noconfirm  # Микропрограмма драйверов Intel Centrino для IPW2100
##sudo pacman -S ipw2200-fw --noconfirm  # Прошивка для Intel PRO / Wireless 2200BG
## Package Details: ipw2x00-firmware 1.3-1
## https://aur.archlinux.org/ipw2x00-firmware.git
## Firmware for ipw2100 and ipw2200 drivers
## Прошивка драйверов ipw2100 и ipw2200
## https://aur.archlinux.org/packages/ipw2x00-firmware
# yay -S ipw2x00-firmware --noconfirm  # Прошивка для драйверов ipw2100 и ipw2200
# git clone https://aur.archlinux.org/ipw2x00-firmware.git   # Прошивка для драйверов ipw2100 и ipw2200
# cd ipw2x00-firmware
##makepkg -fsri
## makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
## makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
## rm -rf ipw2x00-firmware
# rm -Rf ipw2x00-firmware
# -----------------------------------------#
sudo pacman -S --noconfirm --needed libvdpau-va-gl # Драйвер VDPAU с бэкэндом OpenGL/VAAPI ; https://archlinux.org/packages/extra/x86_64/libvdpau-va-gl/ ; https://github.com/i-rinat/libvdpau-va-gl ; 2024-07-12 21:34 UTC
echo " Обновляем образы ядра "
sudo mkinitcpio -P # Обновляем образы ядра ; Чтобы (повторно) сгенерировать все существующие предустановки, используйте параметр -P/--allpresets. Обычно это используется для регенерации всех образов initramfs после изменения глобальных настроек: https://wiki.archlinux.org/title/Mkinitcpio_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
clear
echo ""
echo " Установка драйверов для видеокарт Intel, AMD/(ATI), NVIDIA и дополнительных инструментов выполнена "
fi
# -----------------------------------------
#Если вы устанавливаете систему на виртуальную машину:
#sudo pacman -S xf86-video-vesa  # Для виртуальной машины
# virtualbox-guest-utils - для виртуалбокса, активируем коммандой:
#systemctl enable vboxservice - вводим дважды пароль
# Видео драйверы, без них тоже ничего работать не будет вот список:
# xf86-video-ati - свободный ATI
# xf86-video-intel - свободный Intel
# xf86-video-nouveau - свободный Nvidia
# Существуют также проприетарные драйверы, то есть разработаны самой Nvidia или AMD, но они часто не поддерживают новое ядро, или ещё какие-нибудь траблы.
###########################################

clear
echo ""
echo -e "${GREEN}==> ${NC}Ставим Драйвера принтера (Поддержка печати) CUPS, HP"
#echo -e "${BLUE}:: ${NC}Ставим Драйвера принтера (Поддержка печати) CUPS, HP"
#echo 'Ставим Драйвера принтера (Поддержка печати) CUPS, HP'
# Putting the printer Drivers (Print support) CUPS, HP
echo -e "${MAGENTA}:: ${BOLD}CUPS- это стандартная система печати с открытым исходным кодом, разработанная Apple Inc. для MacOS® и других UNIX® - подобных операционных систем. Драйверы принтеров CUPS состоят из одного или нескольких фильтров, упакованных в формате PPD (PostScript Printer Description). (😃) ${NC}"
echo -e "${CYAN}:: ${NC}Все принтеры в CUPS (даже не поддерживающие PostScript) должны иметь файл PPD с описанием принтеров, специфических команд и фильтров. Фильтры, занимающие центральное место в CUPS, преобразуют задания печати в формат, понятный принтеру (PDF, HP-PCL, растровый формат и т. п.), а также передают команды для выполнения таких операций, как выбор страницы и сортировка."
echo " Файлы PPD являются текстовыми и хранятся в каталоге /usr/share/cups/model. Файлы PPD установленных принтеров хранятся в каталоге /etc/cups/ppd. "
echo " В комплект поставки CUPS входят универсальные файлы PPD для сотен моделей принтеров."
echo -e "${CYAN}:: ${NC}HP - Драйверы для DeskJet, OfficeJet, Photosmart, Business Inkjet и некоторых лазерных принтеров."
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " prog_print  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_print" =~ [^10] ]]
do
    :
done
if [[ $prog_print == 0 ]]; then
echo ""
echo " Установка поддержки Драйвера принтера (Поддержка печати) пропущена "
elif [[ $prog_print == 1 ]]; then
  echo ""
  echo " Установка поддержки Драйвера принтера (Поддержка печати) CUPS "
sudo pacman -S --noconfirm --needed cups cups-filters cups-pdf cups-pk-helper  # Система печати CUPS - пакет демона; Фильтры OpenPrinting CUPS; PDF-принтер для чашек; Помощник, который заставляет system-config-printer использовать PolicyKit
sudo pacman -S --noconfirm --needed system-config-printer ghostscript  # Инструмент настройки принтера CUPS и апплет состояния; Интерпретатор для языка PostScript ; https://github.com/OpenPrinting/system-config-printer ; https://archlinux.org/packages/extra/x86_64/system-config-printer
sudo pacman -S --noconfirm --needed libcups simple-scan  # Система печати CUPS - клиентские библиотеки и заголовки; Простая утилита сканирования
sudo pacman -S --noconfirm --needed gsfonts gutenprint  # (URW) ++ Базовый набор шрифтов [Уровень 2]; Драйверы принтера высшего качества для систем POSIX ;  # python-imaging ???
# Драйверы для HP DeskJet, OfficeJet, Photosmart, Business Inkjet и некоторых LaserJet
sudo pacman -S --noconfirm --needed splix  # Драйверы CUPS для принтеров SPL (Samsung Printer Language)
sudo pacman -S --noconfirm --needed hplip  # Драйверы для HP DeskJet, OfficeJet, Photosmart, Business Inkjet и некоторых LaserJet
# Рабочая группа Foomatic в OpenPrinting в Linux Foundation предоставляет PPD для многих драйверов принтеров
sudo pacman -S --noconfirm --needed foomatic-db  # Foomatic - собранная информация о принтерах, драйверах и параметрах драйверов в файлах XML, используемая foomatic-db-engine для создания файлов PPD.
sudo pacman -S --noconfirm --needed foomatic-db-engine  # Foomatic - движок базы данных Foomatic генерирует файлы PPD из данных в базе данных Foomatic XML. Он также содержит сценарии для непосредственного создания очередей печати и обработки заданий.
sudo pacman -S --noconfirm --needed foomatic-db-ppds  # Foomatic - PPD от производителей принтеров
sudo pacman -S --noconfirm --needed foomatic-db-nonfree  # Foomatic - расширение базы данных, состоящее из предоставленных производителем файлов PPD, выпущенных по несвободным лицензиям
sudo pacman -S --noconfirm --needed foomatic-db-nonfree-ppds  # Foomatic - бесплатные PPD от производителей принтеров
sudo pacman -S --noconfirm --needed foomatic-db-gutenprint-ppds  # Упрощенные готовые файлы PPD
fi
# ---------------------------------------------------------------------
# List of applications:
# https://wiki.archlinux.org/index.php/List_of_applications
# CUPS (Русский)-
# https://wiki.archlinux.org/index.php/CUPS_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# CUPS (Русский)/Printer-specific problems (Русский)
# https://wiki.archlinux.org/index.php/CUPS_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)/Printer-specific_problems_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# Arch Linux: cups и hplip - подключение принтера
# https://rtfm.co.ua/arch-linux-cups-i-hplip-podklyuchenie-printera/
# ------------------------------------------------------------------------

clear
echo ""
echo -e "${GREEN}==> ${NC}Запускаем и добавляем в автозапуск Драйвера принтера CUPS (cupsd.service)"
#echo -e "${BLUE}:: ${NC}Запускаем и добавляем в автозапуск Драйвера принтера CUPS (cupsd.service)"
#echo 'Запускаем и добавляем в автозапуск Драйвера принтера CUPS (cupsd.service)'
# Launch and add the CUPS printer Driver to autorun (cupsd. service)
echo -e "${YELLOW}:: ${BOLD}Запускаем сервис обслуживания драйверов принтера CUPS (cupsd.service), если драйвера принтера были вами установлены. ${NC}"
echo -e "${CYAN}:: ${NC}Вы сможете выполнить запуск (cupsd.service) позже, когда подключите принтер, воспользовавшись скриптом как шпаргалкой! (😃)"
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами. "
# Be careful! In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да запускаем и добавляем, 0 - НЕТ - Пропустить действие: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да запускаем и добавляем,     0 - НЕТ - Пропустить действие: " set_cups  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$set_cups" =~ [^10] ]]
do
    :
done
if [[ $set_cups == 0 ]]; then
echo ""
echo "  Запуск и добавление в автозапуск (cupsd.service) пропущено "
elif [[ $set_cups == 1 ]]; then
  echo ""
  echo " Запускаем Драйвера принтера CUPS (cupsd.service) "
sudo systemctl start cups.service
#sudo systemctl start org.cups.cupsd.service
#sudo systemctl start cups-browsed.service
#sudo systemctl start cupsd.service
echo " Добавляем в автозапуск Драйвера принтера CUPS (cupsd.service) "
sudo systemctl enable cups.service
#sudo systemctl enable org.cups.cupsd.service
#sudo systemctl enable cups-browsed.service

# Проверяем - переходим на страницу http://localhost:631:
# вики уже поправили,смотрите
# https://wiki.archlinux.org/index.php/CUPS#Socket_activation
#echo ""
#echo " Проверить статус CUPS (cupsd.service) "
#sudo systemctl status cups  # Проверить статус...
###############
# https://archlinux.org.ru/forum/topic/20355/
# И проверьте pacnew, может еще конфиги подправить надо
# find /etc -regextype posix-extended -regex ".+\.pacnew" 2> /dev/null
#/etc/locale.gen.pacnew
#/etc/shadow.pacnew
#/etc/pacman.d/mirrorlist.pacnew
#/etc/sudoers.pacnew
#/etc/profile.pacnew
# а там точно надо что-то править?
# Смотреть надо что изменилось, скорее всего эти и не надо, хотя /etc/profile я бы сверил
# https://wiki.archlinux.org/index.php/Pacman/Pacnew_and_Pacsave
# Файлы .pacnew и .pacsave лучше всего обрабатывать вручную сразу после обновлений или удаления пакетов.
# Наличие в системе неправильных файлов настроек может привести к ошибкам в работе программ или даже к полной невозможности их запуска.
fi
# --------------------- Важно! --------------------------------
# Чтобы исправить ошибки сервера CUPS:
# sudo pacman -Rdd foomatic-db foomatic-db-nonfree
# Добавляем группу:
# sudo groupadd printadmin
# Добавляем Пользователя в неё:
# sudo usermod -a -G printadmin $USER
# Обновляем /etc/cups/cups-files.conf, меняем группу sys на printadmin:
# 1 ...
# 2 # Administrator user group, used to match @SYSTEM in cupsd.conf policy rules...
# 3 # This cannot contain the Group value for security reasons...
# 4 SystemGroup printadmin root
# Перезапускаем сервис:
# systemctl restart org.cups.cupsd
# Доступные в cups бекенды для подключения принтера:
# ls -1 /usr/lib/cups/backend/
# Arch Linux: cups и hplip - подключение принтера
# https://rtfm.co.ua/arch-linux-cups-i-hplip-podklyuchenie-printera/
# ------------------------------------------------------------------------
##############

############### Installing X.Org ###############
clear
echo -e "${MAGENTA}
  <<< Установка дополнительных Xorg (иксов)(X.Org) - по вашему выбору и желанию >>> ${NC}"
# Installing additional Xorg(icons)(X.Org ) - according to your choice and desire
echo ""
echo -e "${GREEN}==> ${NC}Установить дополнительные Xorg (иксы)?"
#echo -e "${BLUE}:: ${NC}Установить дополнительные Xorg (иксы)?"
#echo 'Установить дополнительные Xorg (иксы)?'
# Should I install additional Xorgs?
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - Посмотрите перед установкой в скрипте!."
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют функция пропуска установки уже установленных Xorg (иксов)! ${NC}"
echo -e "${CYAN}:: ${NC}Также Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты Xorg (иксы)!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_xorg  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_xorg" =~ [^10] ]]
do
    :
done
if [[ $i_xorg == 0 ]]; then
echo ""
echo " Установка Установка дополнительных Xorg (иксов) пропущена "
elif [[ $i_xorg == 1 ]]; then
echo ""
echo " Установка дополнительных Xorg (иксов) "
################ X.Org ##################
sudo pacman -S --noconfirm --needed xf86-video-sisusb   # X.org SiS USB видеодрайвер ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xf86-video-sisusb/
#############
sudo pacman -S --noconfirm --needed xorg-bdftopcf  # Преобразование шрифта X из формата Bitmap Distribution в формат Portable Compiled ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-bdftopcf/
sudo pacman -S --noconfirm --needed xorg-font-util  # Утилиты шрифтов X.Org ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-font-util/
sudo pacman -S --noconfirm --needed xorg-fonts-encodings  # Файлы кодировки шрифтов X.org ; https://archlinux.org/packages/extra/any/xorg-fonts-encodings/ ; https://gitlab.freedesktop.org/xorg/font/encodings ; Группы: xorg, xorg-fonts ; 2024-03-03 12:28 UTC
sudo pacman -S --noconfirm --needed xorg-mkfontscale  # Создать индекс файлов масштабируемых шрифтов для X ; https://gitlab.freedesktop.org/xorg/app/mkfontscale ; https://archlinux.org/packages/extra/x86_64/xorg-mkfontscale/
sudo pacman -S --noconfirm --needed xorg-sessreg  # Регистрация сеансов X в системных базах данных utmp/utmpx ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-sessreg/
sudo pacman -S --noconfirm --needed xorg-smproxy  # Позволяет приложениям X, не поддерживающим управление сеансом X11R6, участвовать в сеансе X11R6 ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-smproxy/
sudo pacman -S --noconfirm --needed xorg-x11perf  # Простой бенчмаркер производительности X-сервера ; https://archlinux.org/packages/extra/x86_64/xorg-x11perf/ ; https://xorg.freedesktop.org/
sudo pacman -S --noconfirm --needed xorg-xbacklight  # Приложение для управления подсветкой на базе RandR ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xbacklight/
sudo pacman -S --noconfirm --needed xorg-xcmsdb  # Утилита определения характеристик цвета устройства для системы управления цветом X ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xcmsdb/
sudo pacman -S --noconfirm --needed xorg-xcursorgen  # Создать файл курсора X из изображений PNG ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xcursorgen/
sudo pacman -S --noconfirm --needed xorg-xdpyinfo  # Утилита отображения информации для X ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xdpyinfo/
sudo pacman -S --noconfirm --needed xorg-xdriinfo  # Запросить информацию о конфигурации драйверов DRI ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xdriinfo/
sudo pacman -S --noconfirm --needed xorg-xev  # Распечатать содержимое X событий ; https://gitlab.freedesktop.org/xorg/app/xev ; https://archlinux.org/packages/extra/x86_64/xorg-xev/
sudo pacman -S --noconfirm --needed xorg-xgamma  # Изменить гамма-коррекцию монитора ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xgamma/
sudo pacman -S --noconfirm --needed xorg-xhost  # Программа контроля доступа к серверу для X ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xhost/
sudo pacman -S --noconfirm --needed xorg-xinput  # Небольшой инструмент командной строки для настройки устройств ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xinput/
sudo pacman -S --noconfirm --needed xorg-xkill  # Убить клиента с помощью его ресурса X ; https://archlinux.org/packages/extra/x86_64/xorg-xkill/ ; https://xorg.freedesktop.org/ ; 2024-07-14 03:53 UTC
sudo pacman -S --noconfirm --needed xorg-xkbevd  # Демон событий XKB ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xkbevd/
sudo pacman -S --noconfirm --needed xorg-xkbprint  # Создает PostScript-описание описания клавиатуры XKB ; https://gitlab.freedesktop.org/xorg/app/xkbprint ; https://archlinux.org/packages/extra/x86_64/xorg-xkbprint/
sudo pacman -S --noconfirm --needed xorg-xkbutils  # Демонстрационные версии утилит XKB ; https://gitlab.freedesktop.org/xorg/app/xkbutils ; https://archlinux.org/packages/extra/x86_64/xorg-xkbutils/
sudo pacman -S --noconfirm --needed xorg-xlsatoms  # Список интернированных атомов, определенных на сервере ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xlsatoms/
sudo pacman -S --noconfirm --needed xorg-xlsclients  # Список клиентских приложений, запущенных на дисплее ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xlsclients/
sudo pacman -S --noconfirm --needed xorg-xpr  # Распечатать дамп X-окна из xwd ; https://gitlab.freedesktop.org/xorg/app/xpr ; https://archlinux.org/packages/extra/x86_64/xorg-xpr/
sudo pacman -S --noconfirm --needed xorg-xrandr  # Примитивный интерфейс командной строки для расширения RandR ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xrandr/
sudo pacman -S --noconfirm --needed xorg-xrefresh  # Обновить весь или часть экрана X ; https://gitlab.freedesktop.org/xorg/app/xrefresh ; https://archlinux.org/packages/extra/x86_64/xorg-xrefresh/
sudo pacman -S --noconfirm --needed xorg-xsetroot  # Классическая утилита X для установки фона корневого окна в соответствии с заданным узором или цветом ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xsetroot/
sudo pacman -S --noconfirm --needed xorg-xvinfo  # Выводит на экран возможности всех видеоадаптеров, связанных с дисплеем, которые доступны через расширение X-Video ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xvinfo/
sudo pacman -S --noconfirm --needed xorg-xwd  # Утилита дампа образа X Window System ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xwd/
sudo pacman -S --noconfirm --needed xorg-xwininfo  # Утилита командной строки для печати информации об окнах на X-сервере ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xwininfo/
sudo pacman -S --noconfirm --needed xorg-xwud  # Утилита для снятия дампа с образа X Window System ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/xorg-xwud/
echo ""
echo "  Установка дополнительных Xorg (иксов) выполнена "
echo " Время точное как на Спасской башне Московского Кремля! "
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'   # одновременно отображает дату и часовой пояс
fi
##########################################

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
echo -e "${CYAN}:: ${NC}Скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска служб."
echo -e "${GREEN}
  <<< Желаю Вам удачи во всех начинаниях, верных и точных решений! >>> ${NC}"
echo ""
echo -e "${RED}### ${BLUE}########################################################### ${RED}### ${NC}"
echo -e "${RED}==> ${BOLD}Выходим из установленной системы ${NC}"
echo -e "${BLUE}:: ${BOLD}Теперь вам надо ввести (exit) reboot, чтобы перезагрузиться ${NC}"
sleep 03
#exit
#exit
### end of script