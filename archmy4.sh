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
###################################
Получение и обновление новых ключей аутентификации
#Obtain and refresh new Authentication keys.

sudo rm -r /etc/pacman.d/gnupg  
sudo pacman-key --init  
sudo pacman-key --populate archlinux
sudo pacman-key --refresh-keys
sudo pacman -S archlinux-keyring
sudo pacman -S seahorse  # Приложение GNOME для управления ключами PGP (управления паролями и ключами шифрования)
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

sudo pacman -S adobe-source-code-pro-fonts --noconfirm  # Семейство моноширинных шрифтов для пользовательского интерфейса и среды программирования
sudo pacman -S adobe-source-han-sans-cn-fonts --noconfirm  # Adobe Source Han Sans Subset OTF - упрощенные китайские шрифты OpenType / CFF
sudo pacman -S adobe-source-han-sans-jp-fonts --noconfirm  # Adobe Source Han Sans Subset OTF - японские шрифты OpenType / CFF
sudo pacman -S adobe-source-han-sans-kr-fonts --noconfirm  # Adobe Source Han Sans Subset OTF - корейские шрифты OpenType / CFF
sudo pacman -S adobe-source-sans-pro-fonts --noconfirm  # Семейство шрифтов без засечек для сред пользовательского интерфейса
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  #

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
sudo pacman -S audacity --noconfirm  # Программа, позволяющая манипулировать сигналами цифрового звука
sudo pacman -S deadbeef --noconfirm  # Аудиоплеер GTK + для GNU / Linux
sudo pacman -S easytag --noconfirm  # Простое приложение для просмотра и редактирования тегов в аудиофайлах
sudo pacman -S subdownloader --noconfirm  # Автоматическая загрузка / выгрузка субтитров с использованием быстрого хеширования
sudo pacman -S moc --noconfirm  # Консольный аудиоплеер ncurses, разработанный, чтобы быть мощным и простым в использовании
sudo pacman -S mediainfo --noconfirm  # Предоставляет техническую и теговую информацию о видео или аудио файле (интерфейс командной строки)
sudo pacman -S mediainfo-gui --noconfirm  # Предоставляет техническую и теговую информацию о видео или аудио файле (интерфейс GUI)

sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  #     
sudo pacman -S audacity deadbeef easytag subdownloader moc mediainfo mediainfo-gui --noconfirm
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

 Запуск, остановка сервиса tor:
sudo systemctl start tor
sudo systemctl stop tor

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
simplescreenrecorder desktop-file-utils'
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -S simplescreenrecorder --noconfirm  # desktop-file-utils
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
gksu debtap menulibre caffeine-ng inxi xneur fsearch-git cherrytree timeshift mocicon multiload-ng-indicator-gtk xfce4-multiload-ng-plugin-gtk2 keepass2-plugin-tray-icon gconf-editor gconf-cleaner webtorrent-desktop teamviewer corectrl lib32-simplescreenrecorder mkinitcpio-openswap fetchmirrors gtk3-mushrooms'
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
yay -S gksu debtap menulibre caffeine-ng inxi xneur fsearch-git cherrytree timeshift mocicon multiload-ng-indicator-gtk xfce4-multiload-ng-plugin-gtk2 keepass2-plugin-tray-icon gconf-editor gconf-cleaner webtorrent-desktop teamviewer corectrl qt4 xflux flameshot-git lib32-simplescreenrecorder mkinitcpio-openswap fetchmirrors gtk3-mushrooms --noconfirm  # xorg-xkill
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
yay -S keepass2-plugin-tray-icon --noconfirm  # Функциональная иконка в трее для KeePass2 (https://aur.archlinux.org/keepass2-plugin-tray-icon.git)
yay -S gtk3-mushrooms --noconfirm  # GTK3 исправлен для классических настольных компьютеров, таких как XFCE или MATE. См. README
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


 
###########################
VIM - улучшенная версия текстового редактора vi

sudo pacman -S vi vim vim-ansible vim-ale vim-airline vim-airline-themes vim-align vim-bufexplorer vim-ctrlp vim-fugitive vim-indent-object vim-jad vim-jedi vim-latexsuite vim-molokai vim-nerdcommenter vim-nerdtree vim-pastie vim-runtime vim-seti vim-supertab vim-surround vim-syntastic vim-tagbar vim-ultisnips --noconfirm 

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

yay -S vim-colorsamplerpack vim-doxygentoolkit vim-guicolorscheme vim-jellybeans vim-minibufexpl vim-omnicppcomplete vim-project vim-rails vim-taglist vim-vcscommand vim-workspace --noconfirm  #

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


vi 1:070224-4  # Оригинальный текстовый редактор ex / vi
vim 8.2.1537-1  # Vi Improved, улучшенная версия текстового редактора vi с широкими возможностями настройки
# vim-a 2.18-10  # Асинхронный Lint Engine (vim-ale или vim-ansible)?
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


########################################

xfce4-places-plugin   AUR  # Плагин меню Places для панели Xfce
https://aur.archlinux.org/packages/xfce4-places-plugin/
https://aur.archlinux.org/xfce4-places-plugin.git

oh-my-zsh-git  AUR  # Платформа сообщества для управления вашей конфигурацией zsh. Включает 180+ дополнительных плагинов и более 120 тем, чтобы оживить ваше утро, а также инструмент автоматического обновления, чтобы вы могли легко быть в курсе последних обновлений от сообщества
https://aur.archlinux.org/packages/oh-my-zsh-git/
https://aur.archlinux.org/oh-my-zsh-git.git

skippy-xd-git  AUR  # Полноэкранный переключатель задач для X11, похожий на Apple Expose
https://aur.archlinux.org/packages/skippy-xd-git/
https://github.com/dreamcat4/skippy-xd
Многозадачный вид: skippy-xd (Super + Tab)

multilockscreen-git  AUR  # Простой скрипт блокировки для i3lock-color
https://aur.archlinux.org/packages/multilockscreen-git/
https://aur.archlinux.org/multilockscreen-git.git
https://github.com/jeffmhubbard/multilockscreen
Install
Manual Installation
git clone https://github.com/jeffmhubbard/multilockscreen
cd multilockscreen
sudo install -Dm 755 multilockscreen /usr/local/bin/multilockscreen
Arch Linux (AUR)
git clone https://aur.archlinux.org/multilockscreen-git.git
cd multilockscreen-git
less PKGBUILD
makepkg -si

Требования

i3lock-color  AUR  # Улучшенный блокировщик экрана на основе XCB и PAM с поддержкой цветовой конфигурации
https://aur.archlinux.org/packages/i3lock-color/
https://aur.archlinux.org/i3lock-color.git
ИЛИ 
i3lock-color-git  AUR  # Улучшенный блокировщик экрана на основе XCB и PAM с поддержкой цветовой конфигурации
https://aur.archlinux.org/packages/i3lock-color-git/
https://aur.archlinux.org/i3lock-color-git.git 

imagemagick - # Программа просмотра / обработки изображений
https://www.archlinux.org/packages/extra/x86_64/imagemagick/

xrandr - Показать информацию 
https://aur.archlinux.org/packages/?O=0&SeB=nd&K=xrandr&outdated=&SB=n&SO=a&PP=50&do_Search=Go
libxrandr 1.5.2-3 # Библиотека расширения X11 RandR
https://www.archlinux.org/packages/extra/x86_64/libxrandr/

xdpyinfo - отображение информации и поддержка HiDPI
xorg-xdpyinfo - # Утилита отображения информации для X
https://www.archlinux.org/packages/extra/x86_64/xorg-xdpyinfo/

feh - # Быстрый и легкий просмотрщик изображений на основе imlib2
https://www.archlinux.org/packages/extra/x86_64/feh/

----------------------------------------

hblock  AUR  # Блокировщик рекламы, который создает файл hosts из автоматически загружаемых черных списков
https://aur.archlinux.org/packages/hblock/
https://aur.archlinux.org/hblock.git

firefox-extension-leechblock  AUR  # LeechBlock - это простой бесплатный инструмент для повышения производительности, предназначенный для блокировки тех сайтов, которые тратят время впустую, которые могут высосать жизнь из вашего рабочего дня.
https://aur.archlinux.org/packages/firefox-extension-leechblock/
https://aur.archlinux.org/firefox-extension-leechblock.git

xfce4-docklike-plugin-git  AUR  # Современная минималистичная панель задач в стиле док-станции для XFCE
https://aur.archlinux.org/packages/xfce4-docklike-plugin-git/
https://aur.archlinux.org/xfce4-docklike-plugin-git.git

networkmanager-l2tp  AUR  # Поддержка L2TP для NetworkManager
https://aur.archlinux.org/packages/networkmanager-l2tp/
https://aur.archlinux.org/networkmanager-l2tp.git

lightdm-slick-greeter  AUR  # Красивое приветствие LightDM
https://aur.archlinux.org/packages/lightdm-slick-greeter/
https://aur.archlinux.org/lightdm-slick-greeter.git

python2-imaging  AUR  # PIL. Предоставляет возможности обработки изображений для Python
https://aur.archlinux.org/packages/python2-imaging/
https://aur.archlinux.org/python2-imaging.git  

bluez-utils-compat  AUR  # Утилиты для разработки и отладки стека протоколов Bluetooth. Включает устаревшие инструменты.
https://aur.archlinux.org/packages/bluez-utils-compat/
https://aur.archlinux.org/bluez-utils-compat.git 


grml-iso  AUR  # добавьте ISO-образ grml в меню загрузки grub2
https://aur.archlinux.org/packages/grml-iso/
https://aur.archlinux.org/grml-iso.git 

ИЛИ grml-rescueboot  AUR  # grub2 скрипт для добавления ISO-образов grml в меню загрузки grub2
https://aur.archlinux.org/packages/grml-rescueboot/
https://aur.archlinux.org/grml-rescueboot.git 


-----------------------------

Лаунчер: rofi (Alt + d)
Переключатель окон, средство запуска приложений и замена dmenu
https://www.archlinux.org/packages/community/x86_64/rofi/

Композитный менеджер: compton (По умолчанию отключен).

 -############ ОФОРМЛЕНИЕ ###########

arc-gtk-theme - # Плоская тема с прозрачными элементами для GTK 3, GTK 2 и Gnome-Shell
https://www.archlinux.org/packages/community/any/arc-gtk-theme/

arc-icon-theme - # Тема значка дуги. Только официальные релизы
https://www.archlinux.org/packages/community/any/arc-icon-theme/

arc-firefox-theme  AUR  # Официальная тема Arc Firefox
https://aur.archlinux.org/packages/arc-firefox-theme/  # Голоса: 18
https://aur.archlinux.org/arc-firefox-theme.git

arc-firefox-theme-git  AUR  # Тема Arc Firefox
https://aur.archlinux.org/packages/arc-firefox-theme-git/  # Голоса: 32
https://aur.archlinux.org/arc-firefox-theme-git.git

papirus-icon-theme - # Тема значка папируса
https://www.archlinux.org/packages/community/any/papirus-icon-theme/

capitaine-cursors - # Тема x-cursor, вдохновленная macOS и основанная на KDE Breeze
https://www.archlinux.org/packages/community/any/capitaine-cursors/

echo ' Установка тем AUR '
yay -S osx-arc-shadow papirus-maia-icon-theme-git breeze-default-cursor-theme --noconfirm

osx-arc-shadow  AUR  # ???
https://aur.archlinux.org/packages/?O=0&SeB=nd&K=osx-arc&outdated=&SB=n&SO=a&PP=50&do_Search=Go

osx-arc-white-git  AUR  # OSX-Arc-White Theme для Cinnamon, GNOME, Unity, Xfce и GTK +
https://aur.archlinux.org/packages/osx-arc-white-git/
https://aur.archlinux.org/osx-arc-white-git.git 
osx-arc-plus  AUR  # Тема OSX-Arc-Plus для GTK 3.x 
https://aur.archlinux.org/packages/osx-arc-plus/
https://aur.archlinux.org/osx-arc-plus.git
osx-arc-white  AUR  # OSX-Arc-Белая тема для GTK 3.x
https://aur.archlinux.org/packages/osx-arc-white/
https://aur.archlinux.org/osx-arc-white.git 
osx-arc-aurorae-theme  AUR  # Тема Aurorae, разработанная для дополнения тем gtk OSX-Arc @ LinxGem33
https://aur.archlinux.org/packages/osx-arc-aurorae-theme/
https://aur.archlinux.org/osx-arc-aurorae-theme.git 
osx-arc-aurorae-theme-git  AUR  # Тема Aurorae, разработанная для дополнения тем gtk OSX-Arc @ LinxGem33
https://aur.archlinux.org/packages/osx-arc-aurorae-theme-git/
https://aur.archlinux.org/osx-arc-aurorae-theme-git.git

papirus-maia-icon-theme-git  AUR  # Вариант Manjaro темы значков Papirus (версия git)
https://aur.archlinux.org/packages/papirus-maia-icon-theme-git/
https://aur.archlinux.org/papirus-maia-icon-theme-git.git 

breeze-default-cursor-theme  AUR  # Тема курсора по умолчанию Breeze.
https://aur.archlinux.org/packages/breeze-default-cursor-theme/
https://aur.archlinux.org/breeze-default-cursor-theme.git

---------------------------------------

sudo pacman -S termite termite-terminfo --noconfirm  
sudo pacman -S systemd systemd-libs systemd-resolvconf systemd-sysvcompat --noconfirm
sudo pacman -S syslinux  --noconfirm  
sudo pacman -S  --noconfirm  
sudo pacman -S  --noconfirm  


sudo pacman -S termite --noconfirm  #  Простой терминал на базе VTE
sudo pacman -S termite-terminfo --noconfirm  # Terminfo для Termite, простого терминала на базе VTE

sudo pacman -S systemd --noconfirm  # Системный и сервисный менеджер
sudo pacman -S systemd-libs --noconfirm  # Клиентские библиотеки systemd
sudo pacman -S systemd-resolvconf --noconfirm  # Замена systemd resolvconf (для использования с systemd-resolved)
sudo pacman -S systemd-sysvcompat --noconfirm  # sysvinit compat для systemd

sudo pacman -S syslinux --noconfirm  # Коллекция загрузчиков, которые загружаются с файловых систем FAT, ext2 / 3/4 и btrfs, с компакт-дисков и через PXE

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

sudo pacman -S python python-anytree python-appdirs python-cairo python-chardet python-dbus python-dbus-common python-ewmh python-gobject python-idna python-isodate python-lxml python-mutagen python-ordered-set python-packaging python-pexpect python-ply python-ptyprocess python-pycountry python-pycryptodome python-pyparsing python-pyqt5 python-pyqt5-sip python-pysocks python-pyxdg python-requests python-setuptools python-sip python-six python-urllib3 python-websocket-client --noconfirm  # python +

sudo pacman -S python --noconfirm  # Новое поколение языка сценариев высокого уровня Python
sudo pacman -S python-anytree --noconfirm  # Мощная и легкая древовидная структура данных Python


sudo pacman -S python-appdirs --noconfirm  # Небольшой модуль Python для определения соответствующих директорий для конкретной платформы, например «директории пользовательских данных».
sudo pacman -S python-cairo --noconfirm  # Привязки Python для графической библиотеки cairo
sudo pacman -S python-chardet --noconfirm  # Модуль Python3 для автоматического определения кодировки символов
sudo pacman -S python-dbus --noconfirm  # Привязки Python для DBUS
sudo pacman -S python-dbus-common --noconfirm  # Общие файлы dbus-python, общие для python-dbus и python2-dbus
sudo pacman -S python-ewmh --noconfirm  # Реализация Python подсказок Extended Window Manager на основе Xlib
sudo pacman -S python-gobject --noconfirm  # Привязки Python для GLib / GObject / GIO / GTK +
sudo pacman -S python-idna --noconfirm  # Интернационализированные доменные имена в приложениях (IDNA)
sudo pacman -S python-isodate --noconfirm  # Синтаксический анализатор даты / времени / продолжительности и форматирование ISO 8601
sudo pacman -S python-lxml --noconfirm  # Связывание Python3 для библиотек libxml2 и libxslt (-S python-lxml --force # принудительная установка)
sudo pacman -S python-mutagen --noconfirm  # (mutagen) Средство чтения и записи тегов метаданных аудио (библиотека Python)
sudo pacman -S python-ordered-set --noconfirm  # MutableSet, который запоминает свой порядок, так что каждая запись имеет индекс
sudo pacman -S python-packaging --noconfirm  # Основные утилиты для пакетов Python
sudo pacman -S python-pexpect --noconfirm  # Для управления и автоматизации приложений
sudo pacman -S python-ply --noconfirm  # Реализация инструментов парсинга lex и yacc
sudo pacman -S python-ptyprocess --noconfirm  # Запустить подпроцесс в псевдотерминале
sudo pacman -S python-pycountry --noconfirm  # Определения страны, подразделения, языка, валюты и алфавита ИСО и их переводы
sudo pacman -S python-pycryptodome --noconfirm  # Коллекция криптографических алгоритмов и протоколов, реализованных для использования из Python 3
sudo pacman -S python-pyparsing --noconfirm  # Модуль общего синтаксического анализа для Python
sudo pacman -S python-pyqt5 --noconfirm  # Набор привязок Python для инструментария Qt5
sudo pacman -S python-pyqt5-sip --noconfirm  # Поддержка модуля sip для PyQt5
sudo pacman -S python-pysocks --noconfirm  # SOCKS4, SOCKS5 или HTTP-прокси (вилка Anorov PySocks заменяет socksipy)
sudo pacman -S python-pyxdg --noconfirm  # Библиотека Python для доступа к стандартам freedesktop.org
sudo pacman -S python-requests --noconfirm  # Python HTTP для людей
sudo pacman -S python-setuptools --noconfirm  # Легко загружайте, собирайте, устанавливайте, обновляйте и удаляйте пакеты Python
sudo pacman -S python-sip --noconfirm  # Привязки Python SIP4 для библиотек C и C ++
sudo pacman -S python-six --noconfirm  # Утилиты совместимости с Python 2 и 3
sudo pacman -S python-urllib3 --noconfirm  # Библиотека HTTP с потокобезопасным пулом соединений и поддержкой публикации файлов
sudo pacman -S python-websocket-client --noconfirm  # Клиентская библиотека WebSocket для Python
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

----------------------------------


python-arrow 0.16.0-1
python-asn1crypto 1.4.0-1
python-atspi 2.36.0-1
python-attrs 20.1.0-1
python-base58 2.0.1-1
python-basiciw 0.2.2-1
python-bcrypt 3.2.0-1
python-beaker 1.11.0-4
python-bencode.py 3.0.1-1
python-bitcoinlib 0.11.0-1
python-cachecontrol 0.12.6-1
python-cairo 1.19.1-1
python-cffi 1.14.2-1
python-chardet 3.0.4-5
python-coincurve 13.0.0-1
python-colorama 0.4.3-1
python-colour 0.1.5-6
python-configobj 5.0.6-7
python-contextlib2 0.6.0.post1-1
python-cryptography 3.1-1
python-cssselect 1.1.0-4
python-d2to1 0.2.12.post1-7
python-dateutil 2.8.1-3
python-dbus 1.2.16-1
python-dbus-common 1.2.16-1
python-defusedxml 0.6.0-4
python-distlib 0.3.1-1
python-distro 1.5.0-1
python-distutils-extra 2.39-5
python-docopt 0.6.2-7
python-entrypoints 0.3-3
python-eyed3 1:0.8-5
python-gevent 20.6.2-1
python-gevent-websocket 0.10.1-4
python-gobject 3.36.1-1
python-greenlet 0.4.16-1
python-html5lib 1.1-1
python-idna 2.10-1
python-jedi 0.17.2-1
python-jeepney 0.4.3-1
python-jinja 2.11.2-1
python-keyring 21.4.0-1
python-libarchive-c 2.9-1
python-lxml 4.5.2-1
python-lxml-docs 4.5.2-1
python-magic 5.39-1
python-mako 1.1.3-1
python-markdown 3.2.2-1
python-markupsafe 1.1.1-4
python-maxminddb 2.0.2-1
python-merkletools 1.0.3-3
python-msgpack 1.0.0-1
python-mutagen 1.45.1-1
python-nose 1.3.7-7
python-numpy 1.19.1-1
python-olefile 0.46-2
python-ordered-set 4.0.2-1
python-packaging 20.4-1
python-paramiko 2.7.2-1
python-parso 1:0.7.1-1
python-patiencediff 0.2.0-1
python-pbr 5.5.0-1
python-pep517 0.8.2-1
python-pexpect 4.8.0-1
python-pillow 7.2.0-1
python-pip 20.1.1-1
python-ply 3.11-5
python-powerline 2.8.1-1
python-progress 1.5-3
python-psutil 5.7.2-1
python-ptyprocess 0.6.0-4
python-pyasn1 0.4.8-2
python-pyasn1-modules 0.2.8-1
python-pycparser 2.20-1
python-pycups 2.0.1-1
python-pycurl 7.43.0.6-1
python-pyelftools 0.26-1
python-pyelliptic 2.0.1-2
python-pyfiglet 0.8.post0-3
python-pygments 2.6.1-3
python-pyicu 2.5-1
python-pynacl 1.4.0-1
python-pyopenssl 19.1.0-2
python-pyparsing 2.4.7-1
python-pyphen 0.9.5-3
python-pyqt4 4.12.3-4
python-pyqt5 5.15.0-3
python-pyqt5-sip 12.8.1-1
python-pyquery 1.4.1-3
python-pysmbc 1.0.20-1
python-pysocks 1.7.1-1
python-pysol_cards 0.10.1-1
python-pyudev 0.22-3
python-pywapi 0.3.8-7
python-pyxdg 0.26-6
python-random2 1.0.1-4
python-requests 2.24.0-1
python-requests-cache 0.5.2-1
python-resolvelib 0.4.0-1
python-retrying 1.3.3-7
python-rsa 4.6-1
python-scipy 1.5.2-1
python-secretstorage 3.1.2-1
python-setproctitle 1.1.10-5
python-setuptools 1:49.6.0-1
python-shiboken2 5.15.0-2
python-sip 4.19.24-1
python-sip-pyqt4 4.19.22-1
python-six 1.15.0-1
python-sqlalchemy 1.3.19-1
python-tlsh 3.17.0-2
python-toml 0.10.1-1
python-twitter 1.18.0-2
python-ujson 3.1.0-1
python-unidecode 1.1.1-4
python-urllib3 1.25.10-1
python-webencodings 0.5.1-4
python-websocket-client 0.57.0-1
python-websockets 8.1-1
python-yaml 5.3.1-2
python-zope-event 4.4-3
python-zope-interface 5.1.0-1
python2 2.7.18-1
python2-appdirs 1.4.4-1
python2-apsw 3.33.0-1
python2-asn1crypto 1.4.0-1
python2-backports 1.0-3
python2-backports.functools_lru_cache 1.6.1-2
python2-beautifulsoup4 4.9.1-1
python2-cachecontrol 0.12.6-1
python2-cairo 1.18.2-4
python2-cffi 1.14.2-1
python2-chardet 3.0.4-5
python2-colorama 0.4.3-1
python2-configparser 4.0.2-2
python2-contextlib2 0.6.0.post1-1
python2-cryptography 3.1-1
python2-css-parser 1.0.4-3
python2-cssselect 1.1.0-4
python2-cycler 0.10.0-6
python2-dateutil 2.8.1-3
python2-dbus 1.2.16-1
python2-distlib 0.3.1-1
python2-distro 1.5.0-1
python2-dnspython 1.16.0-3
python2-enum34 1.1.9-1
python2-feedparser 5.2.1-6
python2-fuse 1.0.0-2
python2-gevent 20.6.2-1
python2-gobject 3.36.1-1
python2-gobject2 2.28.7-5
python2-greenlet 0.4.16-1
python2-html2text 2019.8.11-4
python2-html5-parser 0.4.9-2
python2-html5lib 1.1-1
python2-httplib2 0.18.1-1
python2-idna 2.10-1
python2-importlib-metadata 1.6.1-1
python2-ipaddress 1.0.23-2
python2-kiwisolver 1.1.0-4
python2-lxml 4.5.2-1
python2-markdown 3.1.1-5
python2-matplotlib 2.2.5-2
python2-mechanize 1:0.4.5-1
python2-msgpack 0.6.2-4
python2-netifaces 0.10.9-3
python2-nose 1.3.7-7
python2-numpy 1.16.6-1
python2-oauth2 1.9.0-1
python2-olefile 0.46-2
python2-opengl 3.1.5-1
python2-ordered-set 3.1.1-3
python2-packaging 20.4-1
python2-pathlib2 2.3.5-1
python2-pep517 0.8.2-1
python2-pillow 6.2.1-2
python2-pip 20.1.1-1
python2-ply 3.11-5
python2-progress 1.5-3
python2-psutil 5.7.2-1
python2-pyasn1 0.4.8-2
python2-pybluez 0.22-4
python2-pychm 0.8.6-1
python2-pycparser 2.20-1
python2-pycups 1.9.74-1
python2-pygments 2.5.2-2
python2-pyopenssl 19.1.0-2
python2-pyparsing 2.4.7-1
python2-pyphen 0.9.4-1
python2-pyqt4 4.12.3-4
python2-pyqt5 5.15.0-3
python2-pyqtwebengine 5.15.0-2
python2-regex 2020.7.14-1
python2-requests 2.24.0-1
python2-resolvelib 0.4.0-1
python2-retrying 1.3.3-7
python2-rfc6555 0.0.0-2
python2-scandir 1.10.0-3
python2-selectors2 2.0.1-4
python2-setuptools 2:44.1.1-1
python2-simplejson 3.17.2-1
python2-sip-pyqt4 4.19.22-1
python2-sip-pyqt5 4.19.24-1
python2-six 1.15.0-1
python2-soupsieve 1.9.6-2
python2-toml 0.10.1-1
python2-unrardll 0.1.4-2
python2-uritemplate 3.0.1-1
python2-urllib3 1.25.10-1
python2-webencodings 0.5.1-4
python2-zipp 1:1.1.1-1
python2-zope-event 4.4-3
python2-zope-interface 5.1.0-1
python3-memoizedb 2017.3.30-4
python3-xcgf 2017.3-4
python3-xcpf 2019.11-2
pythonqt 3.2-6

python-beautifulsoup4 4.9.1-1
python-cairo 1.19.1-1
python-chardet 3.0.4-5
python-colorama 0.4.3-1
python-configobj 5.0.6-7
python-dbus 1.2.16-1
python-dbus-common 1.2.16-1
python-docopt 0.6.2-7
python-future 0.18.2-3
python-gobject 3.36.1-1
python-httplib2 0.18.1-1
python-idna 2.10-1
python-keyutils 0.6-4

python-numpy 1.19.1-1
python-ordered-set 4.0.2-1
python-packaging 20.4-1
python-pexpect 4.8.0-1
python-pillow 7.2.0-1
python-ply 3.11-5
python-psutil 5.7.2-1
python-ptyprocess 0.6.0-4
python-pycups 2.0.1-1
python-pycurl 7.43.0.6-1
python-pyparsing 2.4.7-1
python-pyparted 3.11.6-1
python-pywal 3.3.0-2
python-pyxdg 0.26-6
python-requests 2.24.0-1
python-setproctitle 1.1.10-5
python-setuptools 1:49.6.0-1
python-six 1.15.0-1
python-soupsieve 2.0.1-1
python-termcolor 1.1.0-8
python-urllib3 1.25.10-1
python-xapp 2.0.0-1
python-yaml 5.3.1-2
python2 2.7.18-1
python2-dbus 1.2.16-1
python2-pyxdg 0.26-6
------------------------------------------

libfm-gtk2 - # Библиотека GTK + 2 для управления файлами
https://www.archlinux.org/packages/community/x86_64/libfm-gtk2/

hardinfo - # Системная информация и инструмент тестирования
https://www.archlinux.org/packages/community/x86_64/hardinfo/

gptfdisk - # Инструмент для создания разделов в текстовом режиме, который работает с дисками с таблицей разделов GUID (GPT) 
https://www.archlinux.org/packages/extra/x86_64/gptfdisk/

autofs - # Средство автомонтирования на основе ядра для Linux
https://www.archlinux.org/packages/community/x86_64/autofs/

fuse2 - # Библиотека, позволяющая реализовать файловую систему в программе пользовательского пространства
https://www.archlinux.org/packages/extra/x86_64/fuse2/

fuse3 - # Библиотека, позволяющая реализовать файловую систему в программе пользовательского пространства
https://www.archlinux.org/packages/extra/x86_64/fuse3/

fuseiso - # Модуль FUSE для монтирования образов файловой системы ISO
https://www.archlinux.org/packages/community/x86_64/fuseiso/


notepadqq - # Notepad ++ - как текстовый редактор для Linux
https://www.archlinux.org/packages/community/x86_64/notepadqq/

feh - # Быстрый и легкий просмотрщик изображений на основе imlib2
https://www.archlinux.org/packages/extra/x86_64/feh/

ranger - # Простой файловый менеджер в стиле vim
https://www.archlinux.org/packages/community/any/ranger/

toxcore  - # Безопасная, не требующая настройки серверная часть P2P для замены Skype
https://www.archlinux.org/packages/community/x86_64/toxcore/

catdoc - # Конвертер файлов Microsoft Word, Excel, PowerPoint и RTF в текст
https://www.archlinux.org/packages/community/x86_64/catdoc/

unrtf - # Программа командной строки, конвертирующая документы RTF в другие форматы
https://www.archlinux.org/packages/community/x86_64/unrtf/

inetutils - # Сборник общих сетевых программ
https://www.archlinux.org/packages/core/x86_64/inetutils/

ncmpcpp - # Практически точный клон ncmpc с некоторыми новыми функциями
https://www.archlinux.org/packages/community/x86_64/ncmpcpp/

w3m - # Текстовый веб-браузер, а также пейджер
https://www.archlinux.org/packages/extra/x86_64/w3m/

mpd - # Гибкое, мощное серверное приложение для воспроизведения музыки
https://www.archlinux.org/packages/extra/x86_64/mpd/

mpc - # Минималистичный интерфейс командной строки для MPD
https://www.archlinux.org/packages/extra/x86_64/mpc/

youtube-viewer - # Утилита командной строки для просмотра видео на YouTube
https://www.archlinux.org/packages/community/any/youtube-viewer/

hidapi - # Простая библиотека для связи с устройствами USB и Bluetooth HID
https://www.archlinux.org/packages/community/x86_64/hidapi/

djvulibre - # Пакет для создания, управления и просмотра документов DjVu ('дежавю')
https://www.archlinux.org/packages/extra/x86_64/djvulibre/

aspell-en - # Английский словарь для aspell
https://www.archlinux.org/packages/extra/x86_64/aspell-en/

calibre - # Community - Приложение для управления электронными книгами
https://www.archlinux.org/packages/community/x86_64/calibre/




media-player-info - # Файлы данных, описывающие возможности медиаплеера для систем post-HAL
https://www.archlinux.org/packages/extra/any/media-player-info/

id3lib - # Библиотека для чтения, записи и управления тегами ID3v1 и ID3v2
https://www.archlinux.org/packages/extra/x86_64/id3lib/

ccache - # Кэш компилятора, который ускоряет перекомпиляцию за счет кеширования предыдущих компиляций
https://www.archlinux.org/packages/community/x86_64/ccache/

flex - # Инструмент для создания программ сканирования текста
https://www.archlinux.org/packages/core/x86_64/flex/

lksctp-tools - # Реализация протокола SCTP (http://lksctp.sourceforge.net/)
https://www.archlinux.org/packages/community/x86_64/lksctp-tools/

mlocate - # Слияние реализации locate / updatedb
https://www.archlinux.org/packages/core/x86_64/mlocate/

dosfstools - # Утилиты файловой системы DOS
https://www.archlinux.org/packages/core/x86_64/dosfstools/

jfsutils - # Утилиты файловой системы JFS
https://www.archlinux.org/packages/core/x86_64/jfsutils/



fwbuilder - Community - Объектно-ориентированный графический интерфейс и набор компиляторов для различных платформ межсетевых экранов
https://www.archlinux.org/packages/community/x86_64/fwbuilder/
     
Дополнительно


# AUR - # python-imaging ???
# engrampa  - Манипулятор архивов для MATE
# engrampa-thunar-plugin  - AUR - Манипулятор архивов из MATE без зависимости от Caja (версия GTK3)
# galculator-gtk2 или galculator
# gnome-calculator 

# cups-bjnp AUR  # Серверная часть CUPS для принтеров canon с использованием проприетарного протокола USB over IP BJNP
# cups-xerox 2008.01.23-1  AUR   # Драйверы для различных принтеров Xerox
# cups-xerox-phaser-3600 3.00.27+187-2  AUR   # Драйвер CUPS для серии Xerox Phaser 3600. Также поддерживает fc2218, pe120, pe220, Phaser 3117, 3200, 3250, 3250, 3300, 3435, 3600, 6110, WorkCentre 3210, 3220, 4118
# cups-xerox-phaser-6500 1.0.0-2   AUR   # Драйвер CUPS для серии Xerox Phaser 6500 (N & DN)

###################  #################

pacman -S eog eog-plugins chromium toxcore qmmp gimp xfburn pinta recoll gnome-screenshot evince mlocate antiword catdoc unrtf djvulibre id3lib mutagen python2-pychm aspell-en git calibre ttf-freefont ttf-linux-libertine --noconfirm

eog  - Staging  - Eye of Gnome: программа для просмотра и каталогизации изображений.
eog-plugins  - Extra  - Плагины для Eye of Gnome

qmmp  - Community - Аудиоплеер на Qt5
gimp - Extra  - Программа обработки изображений GNU
xfburn - Extra  - Простой инструмент для записи CD / DVD на основе библиотек libburnia
pinta - Community - Программа для рисования / редактирования по образцу Paint.NET. Его цель - предоставить упрощенную альтернативу GIMP для обычных пользователей
recolla - Community - Инструмент полнотекстового поиска на базе Xapian backend
recoll
gnome-screenshot - Extra  - Сфотографируйте свой экран
evince - Extra  - Программа просмотра документов (PDF, Postscript, djvu, tiff, dvi, XPS, поддержка SyncTex с gedit, комиксы (cbr, cbz, cb7 и cbt))

antiword - Community - Бесплатная программа для чтения MS Word для Linux и RISC OS

python2-pychm     ---- больше не доступен  https://pkgs.org/download/python2   python2-2.7.18-2-x86_64.pkg.tar.zst
-------------------------------------
Смена оболочки
Для смены оболочки на ZSH введите в терминале следующее: chsh -s /bin/zsh.

Для смены оболочки на BASH введите в терминале следующее: chsh -s /bin/bash.

echo ""
echo " Пользовательская оболочка (shell) НЕ изменена, по умолчанию остаётся BASH "
elif [[ $t_shell == 1 ]]; then
chsh -s /bin/zsh
chsh -s /bin/zsh $username
clear
echo ""
echo " Важно! При первом запуске консоли (терминала) - нажмите "0" "
echo " Пользовательская оболочка ИЗМЕНЕНА (сразу будет), с BASH на на ZSH "
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
Parental Control: Family Friendly Filter
by Media Partners
https://addons.mozilla.org/en-US/firefox/addon/family-friendly-filter/?src=search

Резюмирую:
1. Для контроля времени доступа и общего времени сидения за компом удобно использовать пакет timekpr-next-git из aur.
2. Для убирания рекламных баннеров в mozilla addons.mozilla.org/en-US/firefox/addon/adblock-plus/ (Adblock Plus by Adblock Plus)
3. addons.mozilla.org/en-US/firefox/addon/family-friendly-filter/?src=search (Parental Control: Family Friendly Filterby Media Partners) позволяет защитить ребенка от случайных переходов на сайты для взрослых (при этом прямой поиск в строке яндекса ни каких ограничений не имеет (это для любителей «свободы» ратующих за демонстрацию порно своим детям @Gambit_VKM и @dimonmmk ) и addons.mozilla.org/en-US/firefox/addon/blocksite/?src=search (BlockSite) позволяет ограничить не только доступ к сайтам, но и время нахождения в интернете, защищен паролем от несанкционированных изменений) (что бы вообще защитить firefox от изменения настроек и удаления расширений можно использовать addons.mozilla.org/ru/firefox/addon/public-fox/
4. настройка dns.yandex.ru/ тоже не дает защиты от прямого поиска и просмотра во вкладке видео поиска Яндекс.
5. отличный результат показала настройка duckduckgo.com/settings на все запросы 18+ выдает поиск максимум 16+ ближе к 14+
6. Нативного решения ограничения доступа к установленным приложениям (решения от pantheon из Community и aur switchboard-plug-parental-controls не работают в xfce (наверное многим «технарям» это очевидно). Здесь пока могут помочь только настройки групп доступа через chmod, что приведет к желаемому результату. Другого решения я не нашел

В общем [решено].


Список установленных пакетов в системе. Подробно.

LANG=C pacman -Sl | awk '/\[installed\]$/ {print $1 "/" $2 "-" $3}' > ~/pkglist.txt

LANG=C pacman -Sl | awk '/\[installed\]$/ {print $2}' > ~/.pkglist.txt
Кратко.

pacman -Qqe > ~/pkglist.txt

pacman -Qqm > ~/aurlist.txt



