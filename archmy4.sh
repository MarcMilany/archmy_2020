#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v1.6 LegasyBIOS - Version: 2020.07.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

ARCHMY4_LANG="russian"  # Installer default language (Язык установки по умолчанию)

script_path=$(readlink -f ${0%/*})

umask 0022 # Определение окончательных прав доступа
# Для суперпользователя (root) umask по умолчанию равна 0022
#echo ""
#echo "########################################################################"
#echo "######    <<<Arch Linux Fast Install LegasyBIOS (arch2020)>>>     ######"
#echo "####    Скрипты 'arch_2020' созданы на основе сценария (скрипта)    ####"
#echo "#### 'ordanax/arch2018'. Скрипт (сценарий) archmy4 является         ####"
#echo "#### продолжением скриптов (archmy1,archmy2 и archmy3) из серии     ####"
#echo "#### 'arch_2020'. Для установки системы Arch'a' на PC (LegasyBIOS)  ####"
#echo "#### с DE - рабочего стола Xfce.                                    ####"
#echo "### В сценарии (скрипта) archmy4 прописана установка первоначально  ####" 
#echo "#### необходимого софта (пакетов) и запуск необходимых служб.       ####"      
#echo "#### При выполнении скрипта Вы получаете возможность быстрой        ####" 
#echo "#### установки программ (пакетов) с вашими личными настройками      ####"
#echo "#### (при условии, что Вы его изменили под себя, в противном случае ####"       
#echo "#### с моими настройками).                                   ###########"  
#echo "#### Этот скрипт находится в процессе 'Внесение поправок в   ####"
#echo "#### наводку орудий по результатам наблюдений с наблюдате-   ####"
#echo "#### льных пунктов'.                                         ####"
#echo "#### Автор не несёт ответственности за любое нанесение вреда ####"
#echo "#### при использовании скрипта.                              ####"
#echo "#### Installation guide - Arch Wiki  (referance):            ####"
#echo "#### https://wiki.archlinux.org/index.php/Installation_guide ####"
#echo "#### Проект (project): https://github.com/ordanax/arch2018   ####"
#echo "#### Лицензия (license): LGPL-3.0                            ####" 
#echo "#### (http://opensource.org/licenses/lgpl-3.0.html           ####"
#echo "#### В разработке принимали участие (author) :               ####"
#echo "#### Алексей Бойко https://vk.com/ordanax                    ####"
#echo "#### Степан Скрябин https://vk.com/zurg3                     ####"
#echo "#### Михаил Сарвилин https://vk.com/michael170707            ####"
#echo "#### Данил Антошкин https://vk.com/danil.antoshkin           ####"
#echo "#### Юрий Порунцов https://vk.com/poruncov                   ####"
#echo "#### Jeremy Pardo (grm34) https://www.archboot.org/          ####"
#echo "#### Marc Milany - 'Не ищи меня 'Вконтакте',                 ####"
#echo "####                в 'Одноклассниках'' нас нету, ...        ####"
#echo "#### Releases ArchLinux:                                     ####"
#echo "####    https://www.archlinux.org/releng/releases/           ####"
#echo "#### <<<       Смотрите пометки в самом скрипте!         >>> ####" 
#echo "#################################################################"
#echo ""
#sleep 4
#clear
#echo ""

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
### Warning (Предупреждение)
_warning_banner() {
    echo -e "${YELLOW}
   ====================== ♥ Предупреждение ======================  
${NC}
Цель сценария (скрипта) - это установка необходимого софта (пакетов) и запуск необходимых служб. 
Смысл в том, что все изменения вы делаете предварительно в самом скрипте и получаете возможность быстрой установки утилит (пакетов), которые Вы решили установить (при условии, что Вы его изменили под себя, в противном случае скрипт установит софт (пакеты) прописанный изначально.
В процессе работы сценария (скрипта) Вам будут задаваться вопросы на установку той, или иной утилиты (пакета) - будьте внимательными! Устанавливаемый софт (пакеты), шрифты - скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. Так же присутствует софт (пакеты), шрифты - устанавливаемый из пользовательского репозитория 'AUR'-'yay', собираются и устанавливаются. Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска необходимых служб. В любой ситуации выбор всегда за вами. Вы либо гуляете под дождем, либо просто под ним мокнете.${RED}

  ***************************** ВНИМАНИЕ! ***************************** 
${NC}
Автор не несёт ответственности за любое нанесение вреда при использовании скрипта. 
Вы используйте его на свой страх и риск, или изменяйте под свои личные нужды. 
В данный момент сценарий (скрипта) находится в процессе доработки по прописанию устанавливаемого софта (пакетов), и небольшой корректировке (Воен. Внесение поправок в наводку орудий по результатам наблюдений с наблюдательных пунктов)."

}

# ============================================================================

### Display banner (Дисплей баннер)
_warning_banner

sleep 7
echo -e "${GREEN}
  <<< Начинается установка утилит (пакетов) для системы Arch Linux >>>
${NC}"
# Installation of utilities (packages) for the Arch Linux system begins

echo -e "${BLUE}:: ${NC}Установка и настройка начата в $(date +%T)" 
#echo "Установка и настройка начата в $(date +%T)"
# Installation and configuration started in $(date +%T)

echo -e "${GREEN}=> ${NC}Для проверки интернета можно пропинговать какой-либо сервис"
#echo 'Для проверки интернета можно пропинговать какой-либо сервис'
# To check the Internet, you can ping a service
ping -c2 archlinux.org

#echo -e "${BLUE}:: ${NC}Обновим базы данных пакетов" 
#echo 'Обновим базы данных пакетов'
# Updating the package databases
#sudo pacman-key --init
#sudo pacman-key --refresh-keys
sudo pacman -Sy  

#----------------------------------------------------------------------------
# Знакомьтесь, pacman - лучший пакетный менеджер в мире линукса!
#pacman -Syy   - обновление баз пакмэна(как apt-get update в дэбианоподбных)
#pacman -Syyu  - обновление баз плюс обновление пакетов
#----------------------------------------------------------------------------
# Если возникли проблемы с обновлением, или установкой пакетов 
# Выполните данные рекомендации:
# author:
#echo 'Обновление ключей системы'
# Updating of keys of a system
#{
#echo "Создаётся генерация мастер-ключа (брелка) pacman, введите пароль (не отображается)..."
#sudo pacman-key --init
#echo "Далее идёт поиск ключей..."
#sudo pacman-key --populate archlinux
#echo "Обновление ключей..."
#sudo pacman-key --refresh-keys
#echo "Обновление баз данных пакетов..."
#sudo pacman -Sy
#}
#sleep 1
#
# Или:
#sudo pacman-key --init && sudo pacman-key --populate archlinux && sudo pacman-key --refresh-keys && sudo pacman -Sy

Получение и обновление новых ключей аутентификации
#Obtain and refresh new Authentication keys.

sudo rm -r /etc/pacman.d/gnupg  
sudo pacman-key --init  
sudo pacman-key --populate archlinux
sudo pacman-key --refresh-keys
sudo pacman -S archlinux-keyring
sudo pacman -S seahorse
sudo pacman -Syyu
# ============================================================================

echo 'Создадим папку (downloads), и переходим в созданную папку'
# Create a folder (downloads), and go to the created folder
#rm -rf ~/.config/xfce4/*
mkdir ~/downloads
cd ~/downloads

echo 'Установка дополнительных шрифтов'
# The installation of additional fonts
echo -e "${BLUE}
'Список дополнительных шрифтов:${GREEN}
ttf-bitstream-vera freemind '
${NC}"
read -p "1 - Да, 0 - Нет: " i_font
if [[ $i_font == 1 ]]; then
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  #
elif [[ $i_font == 0 ]]; then
  echo 'Установка дополнительных шрифтов пропущена.'
fi

echo ""
echo -e "${BLUE}:: ${NC}Ставим шрифты"
# Ставим шрифты:  https://www.archlinux.org/packages/
sudo pacman -S fontforge --noconfirm  # Редактор контурных и растровых шрифтов
sudo pacman -S gsfonts --noconfirm  # (URW) ++ Базовый набор шрифтов [Уровень 2]
sudo pacman -S ttf-croscore --noconfirm  # Основные шрифты Chrome OS, они метрически совместимы с MS, и хорошо смотрятся, содержат Arimo, Tinos, Cousine и тп.
sudo pacman -S ttf-ubuntu-font-family --noconfirm  # Семейство шрифтов Ubuntu - красивые, не вырвиглазные шрифты без засечек, использую в DE и текстовых документах.
sudo pacman -S ttf-font-awesome --noconfirm  # Культовый шрифт, разработанный для Bootstrap
sudo pacman -S ttf-hack --noconfirm  # Ухоженный и оптически сбалансированный шрифт на основе Bitstream Vera Mono
sudo pacman -S ttf-carlito --noconfirm  # Шрифт Google Carlito - метрически совместим с MS Calibri
sudo pacman -S ttf-caladea --noconfirm  # Семейство шрифтов с засечками по метрике, совместимое с семейством шрифтов MS Cambria 
sudo pacman -S ttf-bitstream-vera --noconfirm  # Шрифты Bitstream Vera
sudo pacman -S ttf-droid --noconfirm  # Шрифты общего назначения, выпущенные Google как часть Android
sudo pacman -S ttf-linux-libertine --noconfirm  # Шрифты OpenType с засечками (Libertine) и Sans Serif (Biolinum) с большим охватом Unicode
sudo pacman -S gnu-free-fonts --noconfirm  # Бесплатное семейство масштабируемых контурных шрифтов
sudo pacman -S ttf-roboto-mono --noconfirm  # Моноширинное дополнение к семейству роботов Roboto
sudo pacman -S ttf-nerd-fonts-symbols --noconfirm  # Большое количество дополнительных глифов из популярных `` культовых шрифтов '' (2048-em)
sudo pacman -S ttf-ionicons --noconfirm  # Шрифт из мобильного фреймворка Ionic
sudo pacman -S ttf-arphic-ukai --noconfirm  # Шрифт CJK Unicode в стиле Kaiti
sudo pacman -S ttf-arphic-uming --noconfirm  # CJK Unicode шрифт в стиле Ming
sudo pacman -S ttf-inconsolata --noconfirm  # Моноширинный шрифт для красивых списков кода и для терминала - шрифт для "коддинга", - Можно не ставить.
sudo pacman -S sdl_ttf --noconfirm  # Библиотека, позволяющая использовать шрифты TrueType в ваших приложениях SDL
sudo pacman -S ttf-bitstream-vera --noconfirm  # Шрифты Bitstream Vera.
sudo pacman -S font-bh-ttf --noconfirm  # Шрифты X.org Luxi Truetype 
sudo pacman -S xorg-fonts-type1 --noconfirm  # Шрифты X.org Type1
# Китайские, Японские, Индийские шрифт
sudo pacman -S opendesktop-fonts --noconfirm  # Китайские шрифты TrueType 
sudo pacman -S ttf-fireflysung --noconfirm  # Китайские иероглифы: - ;
sudo pacman -S ttf-sazanami --noconfirm  # Японские шрифты
sudo pacman -S ttf-hanazono --noconfirm  # Бесплатный японский шрифт кандзи, который содержит около 78 685 символов (и 2 пробела), определенный в стандарте ISO / IEC 10646 / стандарте Unicode.
sudo pacman -S ttf-indic-otf --noconfirm  # Коллекция индийских шрифтов Opentype
# ---------------------------------
# Узнать стоя или нет? 

font-bitstream-speedo --noconfirm  # https://github.com/freedesktop/xorg-font-bitstream-speedo
# ----------------------------------

sudo pacman -S cantarell-fonts --noconfirm  # Шрифт Humanist sans serif

echo 'Обновим информацию о шрифтах'
# Update information about fonts
sudo fc-cache -f -v

echo 'Установка дополнительных шрифтов AUR'
# The installation of additional fonts AUR
echo -e "${BLUE}
'Список дополнительных шрифтов AUR:${GREEN}
ttf-ms-fonts font-manager'
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
yay -S font-manager --noconfirm  # Простое приложение для управления шрифтами для GTK + Desktop Environments   
yay -S ttf-ms-fonts --noconfirm  # Основные шрифты TTF от Microsoft
yay -S ttf-ms-win8 --noconfirm  # По желанию: (содержит в себе ttf-ms-fonts, ttf-vista-fonts и ttf-win7-fonts, т.е. всё что надо включая Calibri и .т.п.)
yay -S artwiz-fonts --noconfirm  # Для пакета LibreOffice
yay -S ttf-clear-sans --noconfirm  # Универсальный шрифт OpenType для экрана, печати и Интернета
yay -S ttf-monaco --noconfirm  # Моноширинный шрифт без засечек Monaco со специальными символами
yay -S montserrat-font-ttf --noconfirm  # Геометрический шрифт с кириллицей и расширенной латиницей от Джульетты Улановской
yay -S ttf-paratype --noconfirm  # Семейство шрифтов ParaType с расширенными наборами символов кириллицы и латиницы
yay -S ttf-comfortaa --noconfirm  # Закругленный геометрический шрифт без засечек от Google, автор - Йохан Аакерлунд
yay -S artwiz-fonts --noconfirm  # Это набор (улучшенных) шрифтов artwiz
yay -S ttf-cheapskate --noconfirm  # Шрифты TTF от Дастина Норландера
yay -S ttf-symbola --noconfirm  # Шрифт для символьных блоков стандарта Unicode (TTF)
yay -S ttf-nerd-fonts-hack-complete-git --noconfirm  # Шрифт, разработанный для исходного кода. Исправлены иконки Nerd Fonts
yay -S ttf-font-logos --noconfirm  # Значок шрифта с логотипами популярных дистрибутивов Linux
yay -S ttf-font-icons --noconfirm  # Неперекрывающееся сочетание иконических шрифтов Ionicons и Awesome 
yay -S ttf-droid-sans-mono-slashed-powerline-git --noconfirm  # Droid Sans Mono для Powerline (Slashed Zero) - шрифт с "треугольником" для powerline, использую в ZSH prompt
yay -S ttf-dejavu-sans-mono-powerline-git --noconfirm  # DejaVu Sans Mono для Powerline
yay -S ttf-material-icons-git --noconfirm  # Шрифт значка Google Material Design
# yay -S ttf-wps-fonts --noconfirm  # Если установлен WPS - Символьные шрифты требуются wps-office

yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #

elif [[ $prog_set == 0 ]]; then
  echo 'Установка дополнительных шрифтов AUR пропущена.'
fi

echo 'Обновим информацию о шрифтах'
# Update information about fonts
sudo fc-cache -f -v

echo 'Установка Мультимедиа утилит'
# Installing Multimedia utilities
echo -e "${BLUE}
'Список Мультимедиа утилит:${GREEN}
сюда вписать список программ'
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -S audacity --noconfirm  # 
sudo pacman -S deadbeef --noconfirm  # 
sudo pacman -S easytag --noconfirm  # 
sudo pacman -S subdownloader --noconfirm  # 
sudo pacman -S moc --noconfirm  # 
sudo pacman -S mediainfo-gui --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  #     
sudo pacman -S audacity deadbeef easytag subdownloader moc mediainfo-gui --noconfirm
elif [[ $prog_set == 0 ]]; then
  echo 'Установка Мультимедиа утилит пропущена.'
fi
 
echo 'Установка Мультимедиа утилит AUR'
# Installing Multimedia utilities AUR
echo -e "${BLUE}
'Список Мультимедиа утилит AUR:${GREEN}
radiotray spotify vlc-tunein-radio vlc-pause-click-plugin audiobook-git cozy-audiobooks m4baker-git mp3gain easymp3gain-gtk2 myrulib-git'
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
yay -S radiotray --noconfirm 
yay -S spotify --noconfirm
yay -S vlc-tunein-radio --noconfirm
yay -S vlc-pause-click-plugin --noconfirm  # Плагин для VLC, который приостанавливает / воспроизводит видео по щелчку мыши
yay -S audiobook-git --noconfirm
yay -S cozy-audiobooks --noconfirm
yay -S m4baker-git --noconfirm
yay -S mp3gain --noconfirm
yay -S easymp3gain-gtk2 --noconfirm
yay -S myrulib-git --noconfirm
yay -S  --noconfirm
yay -S  --noconfirm
yay -S  --noconfirm
yay -S  --noconfirm
yay -S  --noconfirm
#yay -S bluez-firmware --noconfirm  # Прошивки для чипов Bluetooth Broadcom BCM203x и STLC2300
#yay -S pulseaudio-ctl --noconfirm  # Управляйте громкостью pulseaudio из оболочки или с помощью сочетаний клавиш

elif [[ $prog_set == 0 ]]; then
  echo 'Установка Мультимедиа утилит AUR пропущена.'
fi

echo 'Установка программ для обработки видео и аудио (конвертеры)'
# Installing software for video and audio processing (converters)
sudo pacman -S kdenlive --noconfirm

echo 'Установка программ для обработки видео и аудио (конвертеры) AUR'
# Installing software for video and audio processing (converters) AUR
yay -S  --noconfirm

echo 'Установка программ для рисования и редактирования изображений'
# Installing software for drawing and editing images
sudo pacman -S gimp --noconfirm

echo 'Установка программ для рисования и редактирования изображений AUR'
# Installing software for drawing and editing images AUR
yay -S  --noconfirm

echo 'Установка Oracle VM VirtualBox'
# Installing Oracle VM VirtualBox 
sudo pacman -S virtualbox --noconfirm  # Мощная виртуализация x86 как для корпоративного, так и для домашнего использования
#sudo pacman -S virtualbox-host-modules-arch --noconfirm  # для ядра linux - Модули ядра хоста Virtualbox для Arch Kernel
sudo pacman -S virtualbox-host-dkms --noconfirm  # для других ядер - Источники модулей ядра VirtualBox Host
#sudo pacman -S linux-headers --noconfirm  # Заголовки и скрипты для сборки модулей для ядра Linux
sudo pacman -S linux-lts-headers --noconfirm  # Заголовки и скрипты для сборки модулей для ядра Linux-LTC

sudo pacman -S  --noconfirm
# Затем загрузите драйвер Vbox с помощью этой команды:
sudo modprobe vboxdrv  # Загрузка модулей
# sudo modprobe -a vboxguest vboxsf vboxvideo
# Чтобы предоставить себе разрешения для доступа virtualbox к общим папкам и USB устройствам используйте эту команду:     
# sudo gpasswd -a имя_пользователя vboxusers
sudo gpasswd -a $USER vboxusers
#sudo gpasswd -a $username vboxusers
#sudo gpasswd -a alex vboxusers
# Чтобы загрузить модуль VirtualBox во время загрузки, обратитесь к разделу Kernel_modules#Loading и создайте файл *.conf со строкой:
sed -i 'vboxdrv' /etc/modules-load.d/virtualbox.conf
#echo "vboxdrv" > /etc/modules-load.d/virtualbox.conf
# в расположении (in location)
# /etc/modules-load.d/virtualbox.conf

# Общая директория, на машине
mkdir ~/vboxshare
# Общая директория, на виртуалке
#mkdir ~/vboxshare
#sudo mount -t vboxsf -o rw,uid=1000,gid=1000 vboxshare vboxshare

# Настройка гостевых дополнений на виртуалке.
#sudo pacman -S virtualbox-guest-utils --noconfirm # Утилиты пользовательского пространства VirtualBox Guest
#sudo pacman -S linux-headers --noconfirm # Заголовки и скрипты для сборки модулей для ядра Linux
#sudo pacman -S virtualbox-guest-dkms --noconfirm # Исходники модулей ядра VirtualBox Guest
#sudo pacman -S virtualbox-guest-iso --noconfirm # Официальный ISO-образ VirtualBox Guest Additions
# -------------------------
# Arch Wiki Virtualbox 
# https://wiki.archlinux.org/index.php/VirtualBox_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# ===============================
virtualbox 6.1.12-4
virtualbox-ext-oracle 6.1.13.140091-1
virtualbox-ext-vnc 6.1.12-4
virtualbox-guest-iso 6.1.12-1
virtualbox-guest-utils 6.1.12-4
virtualbox-host-modules-arch 6.1.12-14

##############################
echo 'Установка Oracle VM VirtualBox AUR'
# Installing Oracle VM VirtualBox AUR
yay -S virtualbox-ext-oracle --noconfirm  # Пакет расширений Oracle VM VirtualBox
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 

echo 'Установка Java JDK средство разработки и среда для создания Java-приложений'
# Installing Java JDK development tool and environment for creating Java applications
sudo pacman -S jdk8-openjdk jre8-openjdk jre8-openjdk-headless --noconfirm
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 

echo 'Установка Java JDK или Java Development Kit AUR'
# Installing Java JDK development tool and environment for creating Java applications AUR
yay -S  --noconfirm

echo 'Сетевые онлайн хранилища'
# Online storage networks
sudo pacman -S --noconfirm
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 

echo 'Сетевые онлайн хранилища AUR'
# Online storage networks AUR
yay -S megasync thunar-megasync yandex-disk yandex-disk-indicator dropbox --noconfirm

echo 'Утилиты для редактирования документов, PDF, DjVus, NFO, DIZ и XPS... , Читалки электронных книг, Словари, Таблицы'
# Utilities for editing documents, PDF, Djvu, NFO, DIZ and XPS..., e-book Readers, Dictionaries, Tables
sudo pacman -S  --noconfirm
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 

echo 'Утилиты для редактирования документов, PDF, DjVus, NFO, DIZ и XPS... , Читалки электронных книг, Словари, Таблицы AUR'
# Utilities for editing documents, PDF, Djvu, NFO, DIZ and XPS..., e-book Readers, Dictionaries, Tables AUR
yay -S sublime-text-dev unoconv hunspell-ru  masterpdfeditor --noconfirm
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #

echo 'Утилиты для проектирования, черчения и тд...'
# Utilities for designing, drawing, and so on...
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 

echo 'Утилиты для проектирования, черчения и тд... AUR'
# Utilities for designing, drawing, and so on... AUR
yay -S  --noconfirm
yay -S  --noconfirm
yay -S  --noconfirm

echo 'Офисные пакеты'
# Office suite
sudo pacman -S libreoffice-still --noconfirm  # Филиал обслуживания LibreOffice
sudo pacman -S libreoffice-still-ru --noconfirm  # Пакет русского языка для LibreOffice still
sudo pacman -S libreoffice-extension-writer2latex --noconfirm  # набор расширений LibreOffice для преобразования и работы с LaTeX в LibreOffice
# ИЛИ
sudo pacman -S libreoffice-fresh --noconfirm  # Ветвь LibreOffice, содержащая новые функции и улучшения программы
sudo pacman -S libreoffice-fresh-ru --noconfirm  # Пакет русского языка для LibreOffice Fresh
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 

echo 'Офисные пакеты AUR'
# Office suite AUR
yay -S papirus-libreoffice-theme --noconfirm  # Тема Papirus для LibreOffice
yay -S  --noconfirm
yay -S  --noconfirm
# Wps office
yay -S wps-office --noconfirm  # Kingsoft Office (WPS Office) - офисный пакет для повышения производительности
yay -S ttf-wps-fonts --noconfirm  # Если установлен WPS - Символьные шрифты требуются wps-office
yay -S wps-office-mui-ru-ru --noconfirm  # Пакеты MUI для WPS Office
yay -S wps-office-extension-russian-dictionary --noconfirm  # Русский словарь для WPS Office
# Openoffice
yay -S openoffice --noconfirm  # Apache OpenOffice 
yay -S openoffice-ru-bin --noconfirm  # Пакет русского языка для OpenOffice.org
# Onlyoffice
yay -S onlyoffice-bin --noconfirm  # Офисный пакет, сочетающий в себе редакторы текста, таблиц и презентаций
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #

echo 'Утилиты для работы с CD,DVD, создание ISO образов, запись на флеш-накопители'
# Utilities for working with CD, DVD, creating ISO images, writing to flash drives
sudo pacman -S  --noconfirm

echo 'Утилиты для работы с CD,DVD, создание ISO образов, запись на флеш-накопители AUR'
# Utilities for working with CD, DVD, creating ISO images, writing to flash drives AUR
yay -S woeusb-git mintstick unetbootin --noconfirm
yay -S woeusb-git --noconfirm  #
yay -S mintstick --noconfirm  #
yay -S unetbootin --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #

echo 'Онлайн мессенжеры и Телефония, Управления чатом и группам'
# Online messengers and Telephony, chat and group Management
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #

echo 'Онлайн мессенжеры и Телефония, Управления чатом и группам AUR'
# Online messengers and Telephony, chat and group Management AUR
yay -S skypeforlinux-stable-bin skype-call-recorder vk-messenger viber pidgin-extprefs --noconfirm 

echo 'Сетевые утилиты, Tor, VPN, SSH, Samba и тд...'
# Network utilities, Tor, VPN, SSH, Samba, etc...
sudo pacman -S tor torsocks --noconfirm
sudo pacman -S proxychains-ng privoxy openvpn --noconfirm
sudo pacman -S samba --noconfirm  # Файловый сервер SMB и сервер домена AD
sudo pacman -S networkmanager-openconnect --noconfirm  # Плагин NetworkManager VPN для OpenConnect
sudo pacman -S networkmanager-pptp --noconfirm  # Плагин NetworkManager VPN для PPTP
sudo pacman -S networkmanager-vpnc --noconfirm  # Плагин NetworkManager VPN для VPNC
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S nfs-utils --noconfirm  # Программы поддержки для сетевых файловых систем

# Запуск, остановка сервиса tor:
#sudo systemctl start tor
#sudo systemctl stop tor

sudo pacman -S --noconfirm

echo 'Сетевые утилиты, Tor, VPN, SSH, Samba и тд... AUR'
# Network utilities, Tor, VPN, SSH, Samba, etc... AUR
yay -S --noconfirm 
yay -S system-config-samba --noconfirm  # Инструмент настройки Samba от Red Hat
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #

echo 'Установить рекомендуемые программы?'
# To install the recommended program?
echo -e "${BLUE}
'Список программ рекомендованных к установке:${GREEN}
keepass2-plugin-tray-icon simplescreenrecorder desktop-file-utils'
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -S keepass2-plugin-tray-icon simplescreenrecorder --noconfirm  # desktop-file-utils
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
elif [[ $prog_set == 0 ]]; then
  echo 'Установка программ пропущена.'
fi

echo 'Установить рекомендуемые программы из AUR?'
# To install the recommended program? AUR
echo -e "${BLUE}
'Список программ рекомендованных к установке:${GREEN}
gksu debtap menulibre caffeine-ng inxi xneur fsearch-git cherrytree timeshift mocicon multiload-ng-indicator-gtk xfce4-multiload-ng-plugin-gtk2 keepass2-plugin-tray-icon gconf-editor gconf-cleaner webtorrent-desktop teamviewer corectrl lib32-simplescreenrecorder mkinitcpio-openswap fetchmirrors'
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
yay -S gksu debtap menulibre caffeine-ng inxi xneur fsearch-git cherrytree timeshift mocicon multiload-ng-indicator-gtk xfce4-multiload-ng-plugin-gtk2 keepass2-plugin-tray-icon gconf-editor gconf-cleaner webtorrent-desktop teamviewer corectrl qt4 xflux flameshot-git lib32-simplescreenrecorder mkinitcpio-openswap fetchmirrors --noconfirm  # xorg-xkill
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
elif [[ $prog_set == 0 ]]; then
  echo 'Установка программ пропущена.'
fi
# --------------------------------------
Powerpill (Русский)
https://wiki.archlinux.org/index.php/Powerpill_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
Обертка Pacman для более быстрой загрузки
AUR :

yay -S powerpill --noconfirm  # Обертка Pacman для более быстрой загрузки  https://aur.archlinux.org/packages/powerpill/
# Мне нужно было установить python3-memoizedb для его запуска, однако он не указан здесь как зависимость
yay -S python3-memoizedb --noconfirm # Универсальный мемоизатор поиска данных, который использует базу данных sqlite для кэширования данных  https://aur.archlinux.org/packages/python3-memoizedb/
yay -S bauerbill --noconfirm  # # Расширение Powerpill с поддержкой AUR и ABS.  https://aur.archlinux.org/packages/bauerbill/
Не беспокойся. Просто использовал bb -Syu --aur --ignore bauerbill пока ждал пока починят. : P Большое спасибо за исправление!
yay -S pacserve --noconfirm  # # Легко делитесь пакетами Pacman между компьютерами. Замена для PkgD  https://aur.archlinux.org/packages/pacserve/   
https://bugs.mageia.org/show_bug.cgi?id=15425

Обновление системы
Чтобы обновить систему (синхронизировать и обновить установленные пакеты) используйте powerpill и опцию -Syu - как вы делаете это с pacman:

powerpill -Syu

Установка пакетов
Чтобы установить пакет и его зависимости, просто используйте powerpill (вместо pacman) с опцией -S:

powerpill -S package

Вы также можете установить несколько пакетов, как и при работе с pacman:

powerpill -S package1 package2 package3

yay -S  --noconfirm  #
# ===========================================

############################
Иероглифы в русских названиях файлов в ZIP-архивах

yay -S zip-natspec --noconfirm  # Создает PKZIP-совместимые файлы .zip для нелатинских имен файлов с использованием патча libnatspec от AltLinux
yay -S unzip-natspec --noconfirm  # Распаковывает .zip-архивы с нелатинскими именами файлов, используя патч libnatspec от AltLinux
yay -S libnatspec --noconfirm  # Набор функций для запроса различных кодировок и локалей для хост-системы и для другой системы 
# yay -S p7zip-natspec --noconfirm  # Файловый архиватор командной строки с высокой степенью сжатия, основанный на патче libnatspec из ubuntu zip-i18n PPA (https://launchpad.net/~frol/+archive/zip-i18n)
yay -S zip-natspec unzip-natspec libnatspec --noconfirm  #

После установки они заменяют штатные команды zip и unzip , что позволяет использовать их не только в консоли, но и через ГУИшные программы, использующие zip и unzip в качестве бэкэнда для ZIP-архивов.
########################

echo 'Дополнительные пакеты для игр'
# Additional packages for games
# Необходимо раскомментировать репозиторий multilib в /etc/pacman.conf.
# Steam:
sudo pacman -S steam steam-native-runtime lutris lib32-dbus-glib lib32-libnm-glib lib32-openal lib32-nss lib32-gtk2 lib32-sdl2 lib32-sdl2_image lib32-libcanberra --noconfirm   конфигурации
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
#sudo pacman -S lib32-alsa-plugins lib32-curl --noconfirm

echo 'Дополнительные пакеты для игр AUR'
# Additional packages for games AUR
yay -S lib32-libudev0 --noconfirm  # ( lib32-libudev0-shim-nosystemd ) Библиотека совместимости libudev.so.0 для систем с более новыми версиями udev (32 бит)
yay -S lib32-gconf --noconfirm  # Устаревшая система базы данных
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #

echo 'Установка Дополнительных программ'
# Installing Additional programs
echo -e "${BLUE}
'Список Дополнительных программ к установке:${GREEN}
qemu osmo synapse variety kleopatra' 
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -S qemu --noconfirm  # Универсальный компьютерный эмулятор и виртуализатор с открытым исходным кодом
sudo pacman -S osmo --noconfirm  # Удобный персональный органайзер
sudo pacman -S synapse --noconfirm  # Средство запуска семантических файлов
sudo pacman -S variety --noconfirm  # Меняет обои с регулярным интервалом, используя указанные пользователем или автоматически загруженные изображения
sudo pacman -S kleopatra --noconfirm  # Диспетчер сертификатов и унифицированный графический интерфейс криптографии
sudo pacman -S catfish --noconfirm  # Универсальный инструмент для поиска файлов
sudo pacman -S hexchat --noconfirm  # Популярный и простой в использовании графический IRC-клиент (чат)
sudo pacman -S mutt --noconfirm  # Небольшой, но очень мощный текстовый почтовый клиент
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S freemind --noconfirm  #  Ментальный картограф и в то же время простой в использовании иерархический редактор с упором на сворачивание
elif [[ $prog_set == 0 ]]; then
  echo 'Установка программ пропущена.' 
fi

       

# Дополнительно
# arc-gtk-theme  # Плоская тема с прозрачными элементами для GTK 3, GTK 2 и Gnome-Shell
# libfm-gtk2  # Библиотека GTK + 2 для управления файлами
# hardinfo  # Системная информация и инструмент тестирования
# termite  # Простой терминал на базе VTE
# terminus-font  # Моноширинный растровый шрифт (для X11 и консоли)
# hblock  AUR  # Блокировщик рекламы, который создает файл hosts из автоматически загружаемых черных списков
# grml-iso  AUR  # добавьте ISO-образ grml в меню загрузки grub2
# ИЛИ grml-rescueboot  AUR  # grub2 скрипт для добавления ISO-образов grml в меню загрузки grub2
# feh  # Быстрый и легкий просмотрщик изображений на основе imlib2
# notepadqq  - Notepad ++ - как текстовый редактор для Linux

# flex  - Инструмент для создания программ сканирования текста
# lksctp-tools  - Реализация протокола SCTP (http://lksctp.sourceforge.net/)
# syslinux  - Коллекция загрузчиков, которые загружаются с файловых систем FAT, ext2 / 3/4 и btrfs, с компакт-дисков и через PXE
# toxcore  - Безопасная, не требующая настройки серверная часть P2P для замены Skype
# catdoc - Конвертер файлов Microsoft Word, Excel, PowerPoint и RTF в текст
# inetutils - Сборник общих сетевых программ
# hplip  - Драйверы для HP DeskJet, OfficeJet, Photosmart, Business Inkjet и некоторых LaserJet
# unrtf  - Программа командной строки, конвертирующая документы RTF в другие форматы
# id3lib  - Библиотека для чтения, записи и управления тегами ID3v1 и ID3v2
# mlocate  - Слияние реализации locate / updatedb
# dosfstools  - Утилиты файловой системы DOS
# jfsutils  - Утилиты файловой системы JFS
# python2-imaging  - PIL. Предоставляет возможности обработки изображений для Python
# bluez-utils-compat  - Утилиты для разработки и отладки стека протоколов Bluetooth. Включает устаревшие инструменты.
# gptfdisk - Инструмент для создания разделов в текстовом режиме, который работает с дисками с таблицей разделов GUID (GPT)
# autofs - Средство автомонтирования на основе ядра для Linux
# fuse2 - Библиотека, позволяющая реализовать файловую систему в программе пользовательского пространства
# fuse3 - Библиотека, позволяющая реализовать файловую систему в программе пользовательского пространства
# fuseiso - Модуль FUSE для монтирования образов файловой системы ISO

# AUR - # python-imaging ???
# engrampa  - Манипулятор архивов для MATE
# engrampa-thunar-plugin  - AUR - Манипулятор архивов из MATE без зависимости от Caja (версия GTK3)
# galculator-gtk2 или galculator
# gnome-calculator 

# cups-bjnp AUR  # Серверная часть CUPS для принтеров canon с использованием проприетарного протокола USB over IP BJNP
# cups-xerox 2008.01.23-1  AUR   # Драйверы для различных принтеров Xerox
# cups-xerox-phaser-3600 3.00.27+187-2  AUR   # Драйвер CUPS для серии Xerox Phaser 3600. Также поддерживает fc2218, pe120, pe220, Phaser 3117, 3200, 3250, 3250, 3300, 3435, 3600, 6110, WorkCentre 3210, 3220, 4118
# cups-xerox-phaser-6500 1.0.0-2   AUR   # Драйвер CUPS для серии Xerox Phaser 6500 (N & DN)
 
###########################
VIM - улучшенная версия текстового редактора vi

sudo pacman -S vi vim vim-ansible vim-ale vim-airline vim-airline-themes vim-align vim-bufexplorer vim-ctrlp vim-fugitive vim-indent-object vim-jad vim-jedi vim-latexsuite vim-molokai vim-nerdcommenter vim-nerdtree vim-pastie vim-runtime vim-seti vim-supertab vim-surround vim-syntastic vim-tagbar vim-ultisnips --noconfirm 

yay -S vim-colorsamplerpack vim-doxygentoolkit vim-guicolorscheme vim-jellybeans vim-minibufexpl vim-omnicppcomplete vim-project vim-rails vim-taglist vim-vcscommand vim-workspace --noconfirm  #

vi 1:070224-4  # Оригинальный текстовый редактор ex / vi
vim 8.2.1537-1  # Vi Improved, улучшенная версия текстового редактора vi с широкими возможностями настройки
vim-a 2.18-10  # Асинхронный Lint Engine (vim-ale или vim-ansible)?
vim-ale  # Асинхронный Lint Engine
vim-ansible  # Плагин vim для подсветки синтаксиса распространенных типов файлов Ansible
vim-airline 0.11-1  # Строка состояния, написанная в Vimscript
vim-airline-themes r1386.63b66df-1  # Темы для вим-авиакомпании
vim-align 37.43-5  # Позволяет выравнивать строки с помощью регулярных выражений
vim-bufexplorer 7.4.19-2  # Простой список буферов / переключатель для vim
vim-colorsamplerpack 2012.10.28-6  AUR  # Различные цветовые схемы для vim 
vim-ctrlp 1.80-3  # Поиск нечетких файлов, буферов, mru, тегов и т. Д
vim-doxygentoolkit 0.2.13-5  AUR  # Этот скрипт упрощает документацию doxygen на C / C ++
vim-fugitive 3.2-1  # Обертка Git такая классная, она должна быть незаконной
vim-guicolorscheme 1.2-7  AUR  # Автоматическое преобразование цветовых схем только для графического интерфейса в схемы цветовых терминалов 88/256
vim-indent-object 1.1.2-7  # Текстовые объекты на основе уровней отступа
vim-jad 1.3_1329-4  # Автоматическая декомпиляция файлов классов Java и отображение кода Java
vim-jedi 0.10.0-3  # Плагин Vim для джедаев, отличное автозаполнение Python
vim-jellybeans 1.7-1   AUR  # Яркая, темная цветовая гамма, вдохновленная ir_black и сумерками
vim-latexsuite 1:1.10.0-3  # Инструменты для просмотра, редактирования и компиляции документов LaTeX в Vim
vim-minibufexpl 6.5.2-3  AUR  # Элегантный обозреватель буферов для vim
vim-molokai 1.1-7  # Порт цветовой схемы монокаи для TextMate
vim-nerdcommenter 2.5.2-2  # Плагин, позволяющий легко комментировать код для многих типов файлов
vim-nerdtree 6.9.6-1  # Плагин Tree explorer для навигации по файловой системе
vim-omnicppcomplete 0.4.1-10  AUR  # vim c ++ завершение omnifunc с базой данных ctags
vim-pastie 2.0-10  # Плагин Vim, который позволяет читать и создавать вставки на http://pastie.org/
vim-project 1.4.1-10  AUR  # Организовывать и перемещаться по проектам файлов (например, в проводнике ide / buffer)
vim-rails 5.4_25852-2  AUR  # Плагин ViM для усовершенствованной разработки приложений Ruby on Rails
vim-runtime 8.2.1537-1  # Vi Improved, улучшенная версия текстового редактора vi с широкими возможностями настройки (общая среда выполнения)
vim-seti 1.0-4  # Цветовая схема на основе темы Сети Джесси Вида для редактора Atom
vim-supertab 2.1-4  # Плагин Vim, который позволяет использовать клавишу табуляции для выполнения всех операций вставки
vim-surround 2.1-4  # Предоставляет сопоставления для простого удаления, изменения и добавления парного окружения
vim-syntastic 3.10.0-1  # Автоматическая проверка синтаксиса для Vim
vim-tagbar 2.7-3  # Плагин для просмотра тегов текущего файла и получения обзора его структуры
vim-taglist 1:4.6-1  AUR  # Плагин браузера с исходным кодом для vim# 
vim-ultisnips 3.2-3  # Фрагменты для Vim в стиле TextMate
vim-vcscommand 1.99.47-4  AUR  # Плагин интеграции системы контроля версий vim
vim-workspace 1.0b1-10  AUR  # Плагин vim workspace manager для управления группами файлов


######################

# "freshplayerplugin" "(AUR) Recommended" - PPAPI-host Адаптер NPAPI-plugin
# "freshplayerplugin-git" "(AUR)" - PPAPI-host Адаптер NPAPI-plugin
#  "vivaldi" "(AUR) (GTK)" - Продвинутый браузер, созданный для опытных пользователей
#  "vivaldi-ffmpeg-codecs" "(AUR) Non-free codecs" - дополнительная поддержка проприетарных кодеков для vivaldi
sudo pacman -S pepper-flash --noconfirm  # Adobe Flash Player PPAPI
yay -S freshplayerplugin --noconfirm  # PPAPI-host Адаптер NPAPI-plugin (Recommended)
yay -S freshplayerplugin-git --noconfirm  # PPAPI-host Адаптер NPAPI-plugin
yay -S vivaldi --noconfirm  # Продвинутый браузер, созданный для опытных пользователей
yay -S vivaldi-ffmpeg-codecs --noconfirm  # дополнительная поддержка проприетарных кодеков для vivaldi
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #

#################################
# ktorrent (QT) - Мощный клиент BitTorrent для KDE 
# tixati (AUR) (GTK) - Tixati - это программа для однорангового обмена файлами, использующая популярный протокол BitTorrent

sudo pacman -S ktorrent --noconfirm  # Мощный клиент BitTorrent для KDE
yay -S ktorrent-git --noconfirm  # Мощный клиент BitTorrent. (Версия GIT)
yay -S tixati --noconfirm  # Tixati - это программа для однорангового обмена файлами, использующая популярный протокол BitTorrent
yay -S  --noconfirm  #


 #############################
 echo " Установка мультимедиа кодеков и утилит (пакетов) "
#options+=("gst-plugin-libde265" "(AUR)" off)
#options+=("libde265" "(AUR)" off)
yay -S gst-plugin-libde265 --noconfirm  # Плагин Libde265 (открытая реализация видеокодека h.265) для gstreamer
yay -S libde265 --noconfirm  # ???
yay -S libde265-git --noconfirm  # Открытая реализация видеокодека H.265 (версия git)
yay -S lib32-libde265 --noconfirm  # Открытая реализация видеокодека h.265 (32-разрядная версия)

##################################

echo 'Установка Дополнительных программ AUR'
# Installing Additional programs AUR
echo -e "${BLUE}
'Список Дополнительных программ к установке AUR:${GREEN}
сюда вписать список программ'
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
yay -S xfce4-calculator-plugin --noconfirm
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
elif [[ $prog_set == 0 ]]; then
  echo 'Установка программ пропущена.'
fi


###############################
Исправьте миниатюры в файловом менеджере
# Fix Thumbnails in file manager

#sudo pacman -S tumbler ffmpegthumbnailer poppler-glib libgsf libopenraw --noconfirm
sudo pacman -S tumbler --noconfirm  #  Сервис D-Bus для приложений, запрашивающих миниатюры
sudo pacman -S ffmpegthumbnailer --noconfirm  # Легкий эскиз видеофайлов, который может использоваться файловыми менеджерами
sudo pacman -S poppler-glib --noconfirm  # Наручники Poppler Glib
sudo pacman -S libgsf --noconfirm  # Расширяемая библиотека абстракции ввода-вывода для работы со структурированными форматами файлов
sudo pacman -S libopenraw --noconfirm  # Библиотека для декодирования файлов RAW
#sudo pacman -S  --noconfirm  #

sudo rm -rf ~/.thumbnails/
mv ~/.config/Thunar ~/.config/Thunar.bak
sudo update-mime-database /usr/share/mime

Затем выйдите из системы и снова войдите в систему или перезагрузитесь.
# Then logout and back in or Reboot. 
#####################################

echo 'Обновим информацию о шрифтах'
# Update information about fonts
sudo fc-cache -f -v

echo 'Список всех пакетов-сирот'
# List of all orphan packages
sudo pacman -Qdt 

sleep 5
echo 'Удаление всех пакетов-сирот?'
# Deleting all orphaned packages?
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -Qdtq
elif [[ $prog_set == 0 ]]; then
  echo 'Удаление пакетов-сирот пропущено.'
fi    

echo 'Очистка кэша неустановленных пакетов'
# Clearing the cache of uninstalled packages
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -Sc 
elif [[ $prog_set == 0 ]]; then
  echo 'Очистка кэша пропущена.'
fi  

echo 'Очистка кэша пакетов'
# Clearing the package cache
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -Scc 
elif [[ $prog_set == 0 ]]; then
  echo 'Очистка кэша пропущена.'
fi 

echo 'Список Установленного софта (пакетов)'
#List of Installed software (packages)
sudo pacman -Qqe

# ============================================================================
#echo 'Установка тем'
#yay -S osx-arc-shadow papirus-maia-icon-theme-git breeze-default-cursor-theme --noconfirm

#echo 'Ставим лого ArchLinux в меню'
#wget git.io/arch_logo.png
#sudo mv -f ~/Downloads/arch_logo.png /usr/share/pixmaps/arch_logo.png

#echo 'Ставим обои на рабочий стол'
#wget git.io/bg.jpg
#sudo rm -rf /usr/share/backgrounds/xfce/* #Удаляем стандартрые обои
#sudo mv -f ~/Downloads/bg.jpg /usr/share/backgrounds/xfce/bg.jpg
# ============================================================================

sleep 5
echo -e "${GREEN}
  Установка софта (пакетов) завершена!
${NC}"
# Installation of software (packages) is complete!
#echo 'Установка завершена!'
# The installation is now complete!

echo 'Желательно перезагрузить систему для применения изменений'
# It is advisable to restart the system to apply the changes
# ============================================================================
time

echo 'Удаление созданной папки (downloads), и скрипта установки программ (arch3my)'
# Deleting the created folder (downloads) and the program installation script (arch3my)
sudo rm -R ~/downloads/
sudo rm -rf ~/arch4my

echo " Установка завершена для выхода введите >> exit << "
exit


##############################
Enable AUR support for Arch Linux
Включите нашу поддержку Arch Linux
Установите его непосредственно из исходного кода. ( рекомендуемый )
Install Yourt Directly from source. ( recommended )

Замените /user своим именем пользователя в приведенных ниже командах.
Replace /user with your user name in the commands below.

sudo pacman -S git

sudo git clone https://aur.archlinux.org/package-query.git
     cd package-query  

sudo chown -R $(whoami) /home/alex/package-query    
sudo chmod 775 /home/alex/package-query
makepkg -si
     cd ..
     

package-query - Запрос ALPM и AUR  https://aur.archlinux.org/packages/package-query/
https://github.com/archlinuxfr/package-query/

package-query-git - Запрос ALPM и AUR # https://aur.archlinux.org/package-query-git.git
https://aur.archlinux.org/packages/package-query-git/
#################################

echo -e "${BLUE}==> ${NC}Выйти из настроек, или перезапустить систему?"
#echo "Выйти из настроек, или перезапустить систему?"
# Exit settings, or restart the system?
echo -e "${GREEN}==> ${NC}y+Enter - выйти, просто Enter - перезапуск"
#echo "y+Enter - выйти, просто Enter - перезапуск"
# y+Enter-exit, just Enter-restart
read doing 
case $doing in
y)
  exit
 ;;
*)
sudo reboot -f
esac #окончание оператора case.
#

#echo ""
#echo -e "${BLUE}:: ${NC}Информацию о видеокарте"
#lshw -c video
# После нового входа в систему, вы можете проверить версию драйвера, на котором работает ваша видеокарта, следующей командой:
#glxinfo | grep OpenGL

