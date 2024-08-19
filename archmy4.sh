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
   ====================== ♥ Предупреждение ======================  (😃) 
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
#sudo pacman -S archlinux-keyring
###  sudo pacman -S archlinux-keyring  # (обновление пакета ключей подписи)
### sudo pacman -Sy archlinux-keyring
sudo pacman -S seahorse  # Приложение GNOME для управления ключами PGP (управления паролями и ключами шифрования)
sudo pacman -Syyu
# =========================================

echo 'Создадим папку (downloads), и переходим в созданную папку'
# Create a folder (downloads), and go to the created folder
#rm -rf ~/.config/xfce4/*
mkdir ~/downloads
cd ~/downloads


Для примера:

echo arch > /etc/hostname
###
cat <<EOF | tee /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   arch.localdomain arch
EOF


mumble


yay -S libuser --noconfirm  # Стандартизированный интерфейс для управления и администрирования учетных записей пользователей и групп ; https://aur.archlinux.org/libuser.git (только для чтения, нажмите, чтобы скопировать) ; https://pagure.io/libuser/ ; https://aur.archlinux.org/packages/libuser ; https://github.com/pld-linux/libuser ; https://losst.pro/spisok-polzovatelej-gruppy-v-linux

👉👈

👉👈

👉👈




Это основной и очень удобный способ управления полномочиями пользователей и процессов в этой операционной системе. Список групп, мы знаем, как посмотреть, а что, если нужно узнать, какие пользователи имеют доступ к ресурсам одной из групп?

Посмотреть список пользователей группы в Linux достаточно просто, для этого существует несколько способов.

=====
Библиотека libuser реализует стандартизированный интерфейс для манипулирования и
администрирование учетных записей пользователей и групп. Библиотека использует подключаемые бэкэнды для
интерфейс к своим источникам данных.

Примеры приложений, смоделированные по образцу тех, что включены в набор теневых паролей
включены.

sudo apt install members

Для других дистрибутивов будут отличаться только пакетные менеджеры, пакет утилиты называется так же. Для работы утилите надо передать только имя группы:

$ members опции имя_группы

В качестве пользователей можно передать:

--all - все пользователи группы;
--primary - только те пользователи, для которых эта группа является основной;
--secondary - только те пользователи, для которых эта группа является дополнительной;
two-lines - отобразить пользователей, для которых данная группа является основной и тех для кого она установлена в качестве дополнительной.
Например, посмотрим пользователей группы adm:

members adm



Или посмотрим пользователей, которые выбрали группу adm в качестве основной:

members --primary adm

Как видите, таких пользователей нет, а те, которых мы видели раньше, используют эту группу в качестве дополнительной:

members --secondary adm


3. Команда lid
Команда lid тоже может отображать информацию о группах. Но перед тем, как вы сможете её использовать, её надо установить. Утилита входит в пакет libuser. В Ubuntu команда выглядит так:

sudo apt install libuser

Чтобы посмотреть пользователей группы, достаточно, как и в предыдущем варианте, передать утилите имя:

sudo libuser-lid -g adm


Опция -g обязательна. Если её не передать, утилита покажет список групп текущего пользователя. Если не передать имя группы, то утилита покажет список пользователей основной группы текущего пользователя.







ananicy — управление приоритетом процессов,
nohang — не даст выжрать память, пока ни разу не отработал,
preload, prelink — кешеры

acestream-launcher  # Acestream Launcher позволяет открывать ссылки Acestream с помощью медиаплеера по вашему выбору.
https://aur.archlinux.org/packages/acestream-launcher/
https://aur.archlinux.org/acestream-launcher.git
https://github.com/jonian/acestream-launcher

acestream-engine  # Движок ACE Stream
https://aur.archlinux.org/packages/acestream-engine/
https://aur.archlinux.org/acestream-engine.git 
http://acestream.org


echo 'Установка Мультимедиа утилит AUR'
# 
echo -e "${BLUE}
'Список Мультимедиа утилит AUR:${GREEN}
 spotify vlc-tunein-radio vlc-pause-click-plugin audiobook-git cozy-audiobooks m4baker-git mp3gain easymp3gain-gtk2 myrulib-git'
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
 
###################

yay -S audiobook-git --noconfirm  # Простая программа для чтения аудиокниг. Написано на QT / QML и C ++

#######################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Cozy (cozy-audiobooks) - Проигрыватель аудиокниг?"
echo -e "${MAGENTA}:: ${BOLD}Cozy — современный проигрыватель аудиокниг для Linux. Программа Cozy, с современным пользовательским интерфейсом, разработана специально для прослушивания аудиокниг. Переходите на Matrix (https://matrix.to/#/#cozy:gnome.org), чтобы присоединиться к обсуждению. Matrix — открытая сеть для безопасной, децентрализованной связи. ${NC}"
echo " Домашняя страница: https://github.com/geigi/cozy ; (https://cozy.sh/ ; https://aur.archlinux.org/packages/cozy-audiobooks). "  
echo -e "${MAGENTA}:: ${BOLD}Основные функции Cozy: Импортируйте все ваши аудиокниги в Cozy для удобного просмотра; Сортируйте ваши аудиокниги по автору, читателю и названию; Помнит вашу позицию воспроизведения; Таймер сна; Контроль скорости воспроизведения (Управление скоростью воспроизведения для каждой книги индивидуально); Поиск в вашей библиотеке. Автономный режим! Это позволяет хранить аудиокнигу на внутреннем хранилище, если аудиокниги хранятся на внешнем или сетевом диске. Идеально для прослушивания на ходу! Добавить несколько мест хранения; Drag & Drop для импорта новых аудиокниг. Поддержка DRM бесплатно mp3, m4b, m4a (aac, ALAC,…), flac, ogg, wav файлы без DRM-защиты. Интеграция с Mpris (медиа-клавиши и информация о воспроизведении для среды рабочего стола). ${NC}"
echo -e "${CYAN}:: ${NC}Установка Cozy (cozy-audiobooks) проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/cozy-audiobooks.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux - AUR' (https://aur.archlinux.org/packages/cozy-audiobooks) - собирается и устанавливается. "
echo " Cozy доступен для установки как пакет Flatpak. По окончании установки, вы найдёте Cozy поиском в системном меню приложений. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_cozy  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_cozy" =~ [^10] ]]
do
    :
done
if [[ $in_cozy == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_cozy == 1 ]]; then
  echo ""
  echo " Установка Cozy (cozy-audiobooks) "
  mkdir ~/Cozy  # Директория для работы с аудиокнигами  
######## Зависимости ############
sudo pacman -S --noconfirm --needed appstream-glib  # Объекты и методы для чтения и записи метаданных AppStream ; https://people.freedesktop.org/~hughsient/appstream-glib/ ; https://archlinux.org/packages/extra/x86_64/appstream-glib/
sudo pacman -S --noconfirm --needed desktop-file-utils  # Утилиты командной строки для работы с записями рабочего стола ; https://www.freedesktop.org/wiki/Software/desktop-file-utils ; https://archlinux.org/packages/extra/x86_64/desktop-file-utils/
sudo pacman -S --noconfirm --needed gst-plugins-good  # Мультимедийный граф-фреймворк - хорошие плагины ; https://gstreamer.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/gst-plugins-good/
sudo pacman -S --noconfirm --needed gst-python  # Мультимедийный граф-фреймворк - плагин Python ; https://gstreamer.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/gst-python/
sudo pacman -S --noconfirm --needed gstreamer  # Мультимедийная графическая структура - ядро ; https://gstreamer.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/gstreamer/
sudo pacman -S --noconfirm --needed gtk4  # Мультиплатформенный набор инструментов графического интерфейса на основе GObject ; https://www.gtk.org/ ; https://archlinux.org/packages/extra/x86_64/gtk4/
sudo pacman -S --noconfirm --needed libadwaita  # Строительные блоки для современных адаптивных приложений GNOME ; https://gnome.pages.gitlab.gnome.org/libadwaita/ ; https://archlinux.org/packages/extra/x86_64/libadwaita/
sudo pacman -S --noconfirm --needed libdazzle  # Библиотека, которая порадует ваших пользователей интересными функциями ; https://gitlab.gnome.org/GNOME/libdazzle ; https://archlinux.org/packages/extra/x86_64/libdazzle/
sudo pacman -S --noconfirm --needed libhandy  # Библиотека виджетов GTK+ для мобильных телефонов ; https://gitlab.gnome.org/GNOME/libhandy ; https://archlinux.org/packages/extra/x86_64/libhandy/
sudo pacman -S --noconfirm --needed python-apsw  # Обертка Python для SQLite ; https://github.com/rogerbinns/apsw ; https://archlinux.org/packages/extra/x86_64/python-apsw/ 
sudo pacman -S --noconfirm --needed python-cairo  # Привязки Python для графической библиотеки cairo ; https://pycairo.readthedocs.io/en/latest/ ; https://archlinux.org/packages/extra/x86_64/python-cairo/
sudo pacman -S --noconfirm --needed python-distro  # API информации о платформе ОС Linux ; https://github.com/python-distro/distro ; https://archlinux.org/packages/extra/any/python-distro/
sudo pacman -S --noconfirm --needed python-gobject  # Привязки Python для GLib/GObject/GIO/GTK ; https://pygobject.gnome.org/ ; https://archlinux.org/packages/extra/x86_64/python-gobject/
sudo pacman -S --noconfirm --needed python-mutagen  # (mutagen) Средство чтения и записи тегов метаданных аудио (библиотека Python) ; https://github.com/quodlibet/mutagen ; https://archlinux.org/packages/extra/any/python-mutagen/
sudo pacman -S --noconfirm --needed python-peewee  # Peewee — это простой и небольшой ORM. Он имеет немного (но выразительных) концепций, что делает его простым в изучении и интуитивно понятным в использовании ; https://github.com/coleifer/peewee/ ; https://archlinux.org/packages/extra/x86_64/python-peewee/
sudo pacman -S --noconfirm --needed python-pytz  # Кроссплатформенная библиотека часовых поясов для Python ; https://pypi.python.org/pypi/pytz ; https://archlinux.org/packages/extra/any/python-pytz/
sudo pacman -S --noconfirm --needed python-requests  # Python HTTP для людей ; https://requests.readthedocs.io/ ; https://archlinux.org/packages/extra/any/python-requests/
sudo pacman -S --noconfirm --needed meson  # Высокопроизводительная система сборки ; https://mesonbuild.com/ ; https://archlinux.org/packages/extra/any/meson/ 
sudo pacman -S --noconfirm --needed ninja  # Небольшая система сборки с упором на скорость ; https://ninja-build.org/ ; https://archlinux.org/packages/extra/x86_64/ninja/
############ cozy-audiobooks ############ 
yay -S cozy-audiobooks --noconfirm  # Современный проигрыватель аудиокниг для Linux с использованием GTK + 3 ; https://aur.archlinux.org/cozy-audiobooks.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/geigi/cozy ; https://aur.archlinux.org/packages/cozy-audiobooks ; https://cozy.sh/
# yay -S cozy-audiobooks-git --noconfirm  # Современный проигрыватель аудиокниг для Linux с использованием GTK + 3 ; https://aur.archlinux.org/cozy-audiobooks-git.git (только для чтения, нажмите, чтобы скопировать) ; https://cozy.geigi.de/ ; https://aur.archlinux.org/packages/cozy-audiobooks-git
# git clone https://aur.archlinux.org/cozy-audiobooks.git  # (только для чтения, нажмите, чтобы скопировать)
# cd cozy-audiobooks
# makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf cozy-audiobooks 
# rm -Rf cozy-audiobooks
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#############

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить MP3Gain (mp3gain) - Утилита для выравнивания громкости аудиофайлов?"
echo -e "${BLUE}:: ${NC}Установить Графический интерфейс пользователя (GUI) для MP3Gain (easymp3gain-gtk2) - (позволяет изменять уровень громкости файлов mp3, ogg, mp4)?"
echo -e "${MAGENTA}:: ${BOLD}MP3Gain - это программа, которая поможет вам выровнять уровень громкости MP3 или M3U файлов. Ей очень легко пользоваться, независимо от опыта. Первая версия появилась 29 марта 2002 года. Графический интерфейс пользователя (GUI) для MP3Gain, VorbisGain и AACGain (позволяет изменять уровень громкости файлов mp3, ogg, mp4). Лицензия GPL-2.0 ${NC}"
echo " Домашняя страница: https://sourceforge.net/projects/mp3gain/ ; (https://aur.archlinux.org/packages/mp3gain). "  
echo -e "${MAGENTA}:: ${BOLD}Программа состоит из двух частей: базовой части (бэк-энда), которая непосредственно осуществляет действия с MP3-файлами, является общей для всех вариантов использования и работает в режиме командной строки, а также из опциональной GUI-надстройки к ней, написанной на Visual Basic и привычной большинству пользователей под Windows. Программой легко пользоваться, плюс она переведена на множество языков, включая русский. Справка по работе с программой # закомментирована в сценарии (скрипта) установки - Ознакомтесь! ${NC}"
echo " Достоинства: Возможность пакетного анализа и обработки файлов. Нормализация происходит по алгоритму Lossless Gain Adjustment без перекодировки файла, а значит без потери качества. Можно нормализовывать один и тот же файл множество раз без риска его испортить. Возможность применения нормализации только к выделенному в окне треку. Программа записывает изменения громкости в файл в виде APEv2-тегов, благодаря чему сохраняется возможность отмены последних сделанных изменений. Также есть возможность изменять файл напрямую, но в этом случае отменить действия автоматически будет уже невозможно. Сохранение даты создания файла. Сохранение ID3-тегов, в том числе и обложек альбомов. Возможность сохранить результаты предыдущего анализа, а затем применить их для последующей нормализации. Ведение лог-файлов. Многоязычный интерфейс, поддержка 28 языков (Russian - https://mp3gain.sourceforge.net/help/mp3gain-russian.zip). Полностью локализованное справочное руководство, которое можно скачать на официальном сайте (https://mp3gain.sourceforge.net/). "
echo -e "${CYAN}:: ${NC}Установка MP3Gain (mp3gain)(easymp3gain-gtk2) проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/mp3gain.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux - AUR' (https://aur.archlinux.org/packages/mp3gain) - собирается и устанавливается. "
echo "  " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_mp3gain  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_mp3gain" =~ [^10] ]]
do
    :
done
if [[ $in_mp3gain == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_mp3gain == 1 ]]; then
  echo ""
  echo " Установка MP3Gain (mp3gain) "
######## Зависимости ############
sudo pacman -S --noconfirm --needed mpg123  # Консольный проигрыватель MPEG Audio Player в реальном времени для уровней 1, 2 и 3 ; https://mpg123.de/ ; https://archlinux.org/packages/extra/x86_64/mpg123/
sudo pacman -S --noconfirm --needed lib32-mpg123  # Консольный проигрыватель MPEG Audio Player в реальном времени для уровней 1, 2 и 3 (32-битный) ; https://mpg123.de/ ; https://archlinux.org/packages/multilib/x86_64/lib32-mpg123/
######## mp3gain ############
yay -S mp3gain --noconfirm  # Нормализатор mp3 без потерь со статистическим анализом ; https://aur.archlinux.org/mp3gain.git (только для чтения, нажмите, чтобы скопировать) ; https://sourceforge.net/projects/mp3gain/ ; https://aur.archlinux.org/packages/mp3gain
# git clone https://aur.archlinux.org/mp3gain.git  # (только для чтения, нажмите, чтобы скопировать)
# cd mp3gain
# makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf mp3gain 
# rm -Rf mp3gain
  echo ""
  echo " Установка Графического интерфейса для MP3Gain (easymp3gain-gtk2) "
######## Зависимости ############
sudo pacman -S --noconfirm --needed gtk2  # Мультиплатформенный набор инструментов GUI на основе GObject (устаревший) ; https://www.gtk.org/ ; https://archlinux.org/packages/extra/x86_64/gtk2/
sudo pacman -S --noconfirm --needed lazarus  # Delphi-подобная IDE для общих файлов FreePascal ; http://www.lazarus.freepascal.org/ ; https://archlinux.org/packages/extra/x86_64/lazarus/
sudo pacman -S --noconfirm --needed vorbisgain  # Утилита, вычисляющая значения ReplayGain для файлов Ogg Vorbis ; https://sjeng.org/vorbisgain.html ; https://archlinux.org/packages/extra/x86_64/vorbisgain/
######## easymp3gain-gtk2 ############
yay -S easymp3gain-gtk2 --noconfirm  # Графический интерфейс пользователя (GUI) GTK2 для MP3Gain, VorbisGain и AACGain ; https://aur.archlinux.org/easymp3gain-gtk2.git (только для чтения, нажмите, чтобы скопировать); http://easymp3gain.sourceforge.net/ ; https://aur.archlinux.org/packages/easymp3gain-gtk2
# git clone https://aur.archlinux.org/easymp3gain-gtk2.git  # (только для чтения, нажмите, чтобы скопировать)
# cd easymp3gain-gtk2
# makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf easymp3gain-gtk2 
# rm -Rf easymp3gain-gtk2
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка #############
# Программа работает в трёх режимах:
# режим Трек — коррекция громкости выполняется до выбранного уровня для нескольких треков. MP3Gain приводит уровень громкости каждого трека в соответствие с требуемым уровнем.
# режим Альбом — коррекция громкости выполняется для собрания песен, вместе составляющих CD или альбом (программа считает альбомом треки, расположенные в одной папке). Применив Тип Альбом, пользователь как бы только однажды регулирует громкость для всего СD, загруженного в CD-плеер. Общая громкость альбома будет отрегулирована в соответствии с требуемым уровнем, но разница в громкости между треками в альбоме будет сохранена. Например, имеется 3 песни с уровнем громкости 86, 91 и 89 дБ, общая громкость этого альбома будет около 89 дБ. Если требуемый уровень установлен 92 дБ, и применён Тип Альбом, MP3Gain увеличит громкость каждой из этих песен на 3 дБ.
# режим Константа — этот режим похож на режим Альбом. В нём громкость всех треков просто увеличиваются или уменьшается на заданное количество децибел без какой-либо нормализации относительно друг друга.
# Также в программе присутствует функция максимизации громкости (пиковой нормализации), т. е. максимально возможного увеличения громкости для каждого трека без появления клиппинга. Тот же эффект достигается, если в настройках поставить галочку Изменение уровня без клиппинга. Однако это не лучший способ нормализации треков, так как если в файле будет несколько больших пиков, то его средний уровень окажется мал. В итоге разница в громкости может не только не измениться, но и увеличиться. При включении функций максимизации программа выдаёт соответствующее предупреждение. Максимизацию можно применить как для отдельных треков, так и для целого альбома.
# Добавить файлы в программу можно через файловый браузер. Добавлять их можно поштучно или целыми папками (или альбомами). Когда все нужные файлы добавлены, нажимаем "Track Analysis" чтобы программа выполнила их анализ. После этого она составит отчет о текущем уровне громкости треков. Его стоит сохранить на случай, если понадобится восстановить изначальный уровень громкости.
# Когда MP3Gain завершит анализ, можно ввести желаемый уровень громкости, который будет применен к проанализированным трекам после нажатия кнопки "Track Gain". Если новый уровень громкости не устраивает, всю операцию можно проделать снова.
# В добавок, эта программа может анализировать треки и выравнивать уровень громкости по альбомам. Для этого нужно просто выбрать соответствующую команду.
# Чтобы шумов было как можно меньше, не рекомендуется выставлять громкость слишком высокую или слишком низкую. Оптимальным значением для параметра «Норма громкости» является примерно 85-95 децибел.
# Недостатки: Если в настройках выставить слишком большую «норму» громкости, то велика вероятность появления искажений в звуке. Чтобы полностью исключить срезы, необходимо нормализовывать по значению, предлагаемому автором (89 дБ), однако для некоторых современных слушателей оно может показаться слишком тихим. В программе не учитывается динамический диапазон звука, из-за чего некоторые песни могут звучать не одинаково громко даже если программа показывает одинаковые значения громкости. Программа может подстраивать громкость только с шагом в 1,5 дБ из-за технических ограничений формата MP3, но сама эта погрешность никак не влияет на качество нормализации. Программа работает только с MP3-файлами. Существует модификация для формата AAC. Иногда MP3Gain ошибочно распознаёт MP3, как MP1 или MP2. В настройках проверку этих расширений можно отключить, но если у пользователя действительно имеются такие файлы с ошибочным расширением MP3, то при нормализации они могут быть повреждены.
# При большом количестве файлов анализ может затянуться на несколько часов. Сам процесс нормализации с применением заранее сохранённых результатов анализа проходит гораздо быстрее. Разработка программы прекращена в 2010 году.
################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Интернет-радио плеер RadioTray?" 
echo -e "${MAGENTA}:: ${BOLD}Radio Tray (рус.Радио лоток) - проигрыватель потокового онлайн радио, предназначенный для прослушивания интернет-радиостанций в операционных системах Linux. (https://radiotray.wordpress.com/) ${NC}"
echo " Radio Tray не является полнофункциональным музыкальным плеером, уже существует множество отличных музыкальных плееров. Однако было необходимо простое приложение с минимальным интерфейсом только для прослушивания онлайн-радио, не загружая другие плееры типа Amorok или Rhythmbox, а также веб-браузер, тем самым экономя системные ресурсы компьютера и энергопотребление ноутбуков. И это единственная цель Radio Tray. Radio Tray это бесплатное программное обеспечение, работающее под лицензией GPL" 
echo " Функции: воспроизводит большинство медиаформатов (на основе библиотек gstreamer); поддержка перетаскивания закладок; легко использовать; поддерживает формат плейлиста PLS (Shoutcast/Icecast); поддерживает формат плейлиста M3U; поддерживает форматы плейлистов ASX, WAX и WVX... расширяемый плагинами. "
echo -e "${MAGENTA}:: ${BOLD}Radiotray-NG (рус.Радио лоток) - улучшенная версия проигрывателя (radiotray) потокового онлайн радио, предназначенный для прослушивания интернет-радиостанций в операционных системах Linux. (https://github.com/ebruck/radiotray-ng) ${NC}"
echo " Предисловие от автора Radiotray-NG: Как один из первых участников проекта RadioTray, я понял, что он не получает должного внимания и, вероятно, мертв. Многие из используемых технологий перешли в новые версии, и ошибки начали накапливаться. Я делал все возможное, чтобы помочь пользователям, но требовалось начать все заново. Представленная здесь версия — это то, чего «я» хотел от RadioTray. "
echo " Целями Radiotray-NG были: Улучшенная обработка ошибок и восстановление gstreamer. Исправление некорректного формата закладок RadioTray. Встроил единственный плагин RadioTray, который, как я чувствовал, мне был нужен — это таймер выключения. Поддержка значков уведомлений для каждой станции/группы. Лучший анализ метаданных потока и опциональное отображение большего количества информации о потоке. Немного больше внимания к деталям и форматированию уведомлений. "
echo -e "${CYAN}:: ${NC}Установка RadioTray (radiotray), или (radiotray-ng), проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/radiotray/), (https://aur.archlinux.org/packages/radiotray-ng/) - собирается и устанавливается. "
echo " Будьте внимательны! В данной опции выбор остаётся за вами. "
# Установка пакета (radiotray) - Закомментирована (двойной ##), если Вам нужен именно этот пакет, то раскомментируйте строки его установки, а строки установки пакета (radiotray-ng) - закомментируйте.
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить RadioTray,    2 - Да установить Radiotray-NG,    0 - НЕТ - Пропустить установку: " i_radiotray  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_radiotray" =~ [^120] ]]
do
    :
done 
if [[ $i_radiotray == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_radiotray == 1 ]]; then
  echo ""  
  echo " Установка Интернет-радио RadioTray "
######## Зависимости ############
sudo pacman -S --noconfirm --needed python-pydbus  # Pythonic библиотека D-Bus ; https://github.com/LEW21/pydbus ; https://archlinux.org/packages/extra/any/python-pydbus/
sudo pacman -S --noconfirm --needed gst-plugins-base  # Мультимедийная графическая структура - базовые плагины ; https://gstreamer.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/gst-plugins-base/
sudo pacman -S --noconfirm --needed gst-plugins-good  # Мультимедийный граф-фреймворк - хорошие плагины ; https://gstreamer.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/gst-plugins-good/
sudo pacman -S --noconfirm --needed gstreamer  # Мультимедийная графическая структура - ядро ; https://gstreamer.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/gstreamer/
sudo pacman -S --noconfirm --needed python-gobject  # Привязки Python для GLib / GObject / GIO / GTK + ; https://pygobject.gnome.org/ ; https://archlinux.org/packages/extra/x86_64/python-gobject/
sudo pacman -S --noconfirm --needed python-lxml  # Привязка Python3 к библиотекам libxml2 и libxslt ; https://lxml.de/ ; https://archlinux.org/packages/extra/x86_64/python-lxml/
sudo pacman -S --noconfirm --needed python-notify2  # Интерфейс Python для уведомлений DBus ; https://bitbucket.org/takluyver/pynotify2 ; https://archlinux.org/packages/extra/any/python-notify2/
sudo pacman -S --noconfirm --needed python-pyxdg  # Библиотека Python для доступа к стандартам freedesktop.org ; http://freedesktop.org/Software/pyxdg ; http://freedesktop.org/Software/pyxdg ; https://archlinux.org/packages/extra/any/python-pyxdg/
sudo pacman -S --noconfirm --needed gst-libav  # Мультимедийная графическая структура - плагин libav ; https://gstreamer.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/gst-libav/
sudo pacman -S --noconfirm --needed gst-plugins-bad  # Мультимедийный граф-фреймворк - плохие плагины ; https://gstreamer.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/gst-plugins-bad/
sudo pacman -S --noconfirm --needed gst-plugins-ugly  # Мультимедийный граф-фреймворк - уродливые плагины ; https://gstreamer.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/gst-plugins-ugly/
sudo pacman -S --noconfirm --needed libappindicator-gtk3  # Разрешить приложениям расширять меню с помощью индикаторов Ayatana в Unity, KDE или Systray (библиотека GTK+ 3) ; https://launchpad.net/libappindicator ; https://archlinux.org/packages/extra/x86_64/libappindicator-gtk3/ 
############ radiotray ########## 
yay -S radiotray --noconfirm # Онлайн-проигрыватель потокового радио, работающий на панели задач Linux ; https://aur.archlinux.org/radiotray.git (только для чтения, нажмите, чтобы скопировать) ; https://radiotray.wordpress.com/ ; https://aur.archlinux.org/packages/radiotray
## git clone https://aur.archlinux.org/radiotray.git  # Онлайн-проигрыватель потокового радио, работающий на панели задач Linux
## cd radiotray
#makepkg -fsri
# makepkg -si
## makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
## pwd    # покажет в какой директории мы находимся
## cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf radiotray 
## rm -Rf radiotray
echo ""
echo " Установка Интернет-радио RadioTray выполнена "
elif [[ $i_radiotray == 2 ]]; then
  echo ""  
  echo " Установка Интернет-радио Radiotray-NG "
######## Зависимости ############
sudo pacman -S --noconfirm --needed boost-libs  # Бесплатные рецензируемые переносимые исходные библиотеки C++ (библиотеки времени выполнения) ; https://www.boost.org/ ; https://archlinux.org/packages/extra/x86_64/boost-libs/
sudo pacman -S --noconfirm --needed glibmm  # Привязки C++ для GLib ; https://www.gtkmm.org/ ; https://archlinux.org/packages/extra/x86_64/glibmm/
sudo pacman -S --noconfirm --needed gst-plugins-good  # Мультимедийный граф-фреймворк - хорошие плагины ; https://gstreamer.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/gst-plugins-good/
sudo pacman -S --noconfirm --needed jsoncpp  # Библиотека C++ для взаимодействия с JSON ; https://github.com/open-source-parsers/jsoncpp ; https://archlinux.org/packages/extra/x86_64/jsoncpp/
sudo pacman -S --noconfirm --needed libappindicator-gtk3  # Разрешить приложениям расширять меню с помощью индикаторов Ayatana в Unity, KDE или Systray (библиотека GTK+ 3) ; https://launchpad.net/libappindicator ; https://archlinux.org/packages/extra/x86_64/libappindicator-gtk3/
sudo pacman -S --noconfirm --needed libbsd  # Предоставляет полезные функции, обычно встречающиеся в системах BSD, такие как strlcpy() ; https://libbsd.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/libbsd/
sudo pacman -S --noconfirm --needed libnotify  # Библиотека для отправки уведомлений на рабочий стол ; https://gitlab.gnome.org/GNOME/libnotify ; https://archlinux.org/packages/extra/x86_64/libnotify/
sudo pacman -S --noconfirm --needed libxdg-basedir  # Реализация спецификации XDG Base Directory ; https://github.com/devnev/libxdg-basedir ; https://archlinux.org/packages/extra/x86_64/libxdg-basedir/
sudo pacman -S --noconfirm --needed wxwidgets-gtk3  # Реализация API wxWidgets для GUI на GTK+3 ; https://wxwidgets.org/ ; https://archlinux.org/packages/extra/x86_64/wxwidgets-gtk3/
sudo pacman -S --noconfirm --needed boost  # Бесплатные рецензируемые переносимые исходные библиотеки C++ (заголовочные файлы для разработки) ; https://www.boost.org/ ; https://archlinux.org/packages/extra/x86_64/boost/
sudo pacman -S --noconfirm --needed python-lxml  # Привязка Python3 к библиотекам libxml2 и libxslt ; https://lxml.de/ ; https://archlinux.org/packages/extra/x86_64/python-lxml/
############# radiotray-ng ##############
### yay -S radiotray-ng-git --noconfirm # Интернет-радио плеер для Linux ; https://aur.archlinux.org/radiotray-ng-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/ebruck/radiotray-ng ; https://aur.archlinux.org/packages/radiotray-ng-git ; Конфликты: с radiotray-ng  !!!
yay -S radiotray-ng --noconfirm # Интернет-радио плеер для Linux ; https://aur.archlinux.org/radiotray-ng.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/ebruck/radiotray-ng ; https://aur.archlinux.org/packages/radiotray-ng 
#git clone https://aur.archlinux.org/radiotray-ng.git  # Интернет-радио плеер для Linux
#cd radiotray-ng
#makepkg -fsri
# makepkg -si
## makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
## pwd    # покажет в какой директории мы находимся
## cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf radiotray-ng
#rm -Rf radiotray-ng
  echo ""  
  echo " Установка поддержки MPRIS Media Player "
############# radiotray-ng-mpris ##############
sudo pacman -S --noconfirm --needed python  # Язык программирования Python ; https://www.python.org/ ; https://archlinux.org/packages/core-testing/x86_64/python/
sudo pacman -S --noconfirm --needed python-emoji  # Эмодзи для Python ; https://github.com/carpedm20/emoji ; https://archlinux.org/packages/extra/any/python-emoji/
sudo pacman -S --noconfirm --needed python-gobject  # Привязки Python для GLib / GObject / GIO / GTK + ; https://pygobject.gnome.org/ ; https://archlinux.org/packages/extra/x86_64/python-gobject/
sudo pacman -S --noconfirm --needed python-pydbus  # Pythonic библиотека D-Bus ; https://github.com/LEW21/pydbus ; https://archlinux.org/packages/extra/any/python-pydbus/
sudo pacman -S --noconfirm --needed python-unidecode  # ASCII-транслитерации текста Unicode ; https://github.com/avian2/unidecode ; https://archlinux.org/packages/extra/any/python-unidecode/
sudo pacman -S --noconfirm --needed python-build  # Простой и правильный интерфейс сборки Python ; https://github.com/pypa/build ; https://archlinux.org/packages/extra/any/python-build/
sudo pacman -S --noconfirm --needed python-installer  # Низкоуровневая библиотека для установки пакета Python из дистрибутива wheel ; https://github.com/pypa/installer ; https://archlinux.org/packages/extra/any/python-installer/
sudo pacman -S --noconfirm --needed python-setuptools  # Простая загрузка, сборка, установка, обновление и удаление пакетов Python ; https://pypi.org/project/setuptools/ ; https://archlinux.org/packages/extra/any/python-setuptools/
sudo pacman -S --noconfirm --needed python-wheel  # Встроенный формат пакета для Python ; https://pypi.python.org/pypi/wheel ; https://archlinux.org/packages/extra/any/python-wheel/
yay -S python-strenum --noconfirm # Перечисление Python, которое наследуется от str ; https://aur.archlinux.org/python-strenum.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/irgeek/StrEnum ; https://aur.archlinux.org/packages/python-strenum
yay -S radiotray-ng-mpris --noconfirm # Скрипт-оболочка для Radiotray-NG, предоставляющий интерфейс MPRIS2 ; https://aur.archlinux.org/radiotray-ng-mpris.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/IngoMeyer441/radiotray-ng-mpris ; https://aur.archlinux.org/packages/radiotray-ng-mpris ; Radiotray-NG MPRIS — это оболочка для Radiotray-NG, позволяющая добавить интерфейс MPRIS2 , который хорошо интегрируется со средами рабочего стола (например, GNOME , KDE или XFCE ) или независимыми от рабочего стола инструментами управления музыкальными проигрывателями, такими как playerctl .
yay -S python-mpris_server --noconfirm # Интегрируйте поддержку MPRIS Media Player в свое приложение ; https://aur.archlinux.org/python-mpris_server.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/alexdelorenzo/mpris_server ; https://github.com/alexdelorenzo/mpris_server
echo ""
echo " Установка Интернет-радио Radiotray-NG выполнена "
fi
#-----------------------------
# Домашняя страница:
# http://radiotray.sourceforge.net/
# https://compizomania.blogspot.com/2016/06/radio-tray-ubuntulinux.html
# https://aur.archlinux.org/packages/radiotray/
# https://aur.archlinux.org/packages/radiotray-ng/
# https://github.com/ebruck/radiotray-ng
# Некоторые станции предоставляют метаданные о проигрываемых треках или передачах. Radiotray-NG отображает всплывающее оповещение с этими деталями при начале воспроизведения новой песни. Также вы можете узнать, что воспроизводится, кликнув на иконку индикатора в трее.
# Radiotray-NG всё-таки пока не идеален. Чтобы добавить станции, вам необходимо отредактировать JSON-файл в текстовом редакторе. То же касается управления или редактирования существующих станций. Вы можете найти соответствующий JSON-файл в директории ~/.confg/radotray-ng/.
# Похожим образом придётся поступить для управления настройками приложения (отображать ли оповещения, уровень громкости по умолчанию и так далее) вам нужно будет отредактировать конфигурационный JSON-файл в каталоге ~/.confg/radotray-ng/.
# Расширение Advanced Radio Player
# Для среды рабочего стола KDE (Plasma), как добавить радио в эту DE независимо от дистрибутива.
# Открываем меню расширений и ищем в библиотеке Advanced Radio Player, а после того, как нашли устанавливаем.
#####################################

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Spotify — музыкальный стриминговый сервис?" 
echo -e "${MAGENTA}:: ${BOLD}Spotify - это шведский музыкальный сервис для прослушивания музыки и организации плейлистов. Сервис доступен почти в 120 странах, включая Россию, Украину, Белоруссию. ${NC}"
echo " Spotify - это коммерческий музыкальный потоковый сервис, предоставляющий контент с ограниченным управлением цифровыми правами от звукозаписывающих лейблов, включая Sony, EMI, Warner Music Group и Universal. " 
echo " Spotify работает по модели freemium (основные услуги бесплатны, а дополнительные функции предлагаются через платные подписки). Spotify зарабатывает на продаже премиальных потоковых подписок пользователям и размещении рекламы третьим лицам. Библиотека сервиса состоит из более чем 50 млн песен, и 4 миллиарда плейлистов с треками русских и международных исполнителей и каждый день их количество растёт. Найти нужный трек можно по названию, исполнителю, альбому, плейлисту или лейблу. Рекомендации и умные плейлисты — одна из киллер фич, из-за которой все так возбуждаются на этот сервис. Каждый пользователь может создать свой плейлист, и поделиться им с миром. Плейлисты можно редактировать совместно. Лимит плейлиста — 10 000 песен. Сервисом можно пользоваться в вебе, на десктопах, мобильных устройствах, игровых консолях, телевизорах и стереосистемах. "
echo -e "${CYAN}:: ${NC}Почему Spotify так популярен? Spotify предлагает легальную возможность слушать онлайн треки из огромного музыкального каталога, в котором есть масса альбомов, недоступных на других платформах. Однако пользователи любят сервис не только за это.. Spotify - (https://wiki.archlinux.org/title/Spotify)"
echo -e "${CYAN}==> Важно! ${NC}В сценарии (скрипте) представлены несколько вариантов установки: 1 - Spotify (spotify-launcher): установка проходит из 'Официальных репозиториев Arch Linux'. Этот пакет управляет установкой для каждого пользователя в вашем домашнем каталоге, позволяя Spotify обновляться независимо от pacman (аналогично тому, как Spotify обновляется самостоятельно в других операционных системах). 2 - Spotify (spotify) из (AUR-yay). Также присутствует Справка по работе с программой и установке дополнений она # закомментирована в сценарии (скрипта) установки - Ознакомтесь! "
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
# Be careful! The installation process, after the option you selected, was registered fully automatic. In this option, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Установить Spotify (spotify-launcher),   2 - Установить Spotify (spotify) из (AUR-yay),  

    0 - НЕТ - Пропустить установку: " i_spotify  # sends right after the keypress; # отправляет сразу после нажатия клавиши    
    echo ''
    [[ "$i_spotify" =~ [^120] ]]
do
    :
done 
if [[ $i_spotify == 0 ]]; then 
echo ""   
echo " Установка пропущена "
elif [[ $i_spotify == 1 ]]; then
echo ""   
echo " Установка Spotify (spotify-launcher) "
echo " Этот пакет управляет установкой для каждого пользователя в вашем домашнем каталоге, позволяя Spotify обновляться независимо от pacman (аналогично тому, как Spotify обновляется самостоятельно в других операционных системах) "
echo " Spotify (spotify-launcher) имеет бесплатный клиент для Linux, но запрещает его повторное распространение, поэтому это свободно распространяемая программа с открытым исходным кодом, которая управляет установкой Spotify в вашей домашней папке с официального сервера релизов Spotify."
echo " После установки запустите приложение из меню приложений "
# sudo pacman -S --help
sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
#sudo pacman -Syyu --noconfirm  # Обновление баз плюс обновление пакетов (--noconfirm - не спрашивать каких-либо подтверждений)
# sudo pacman -Syyu  # Обновим вашу систему (базу данных пакетов)
sudo pacman -S --noconfirm --needed devtools  # Инструменты для сопровождающих Arch Linux пакетов ; https://gitlab.archlinux.org/archlinux/devtools ; https://archlinux.org/packages/extra/any/devtools/ ; Devtools — инструменты разработки для Arch Linux ; Этот репозиторий содержит инструменты для дистрибутива Arch Linux, позволяющие создавать и поддерживать официальные пакеты репозитория.
######## Зависимости ############
sudo pacman -S --noconfirm --needed desktop-file-utils  # Утилиты командной строки для работы с записями рабочего стола ; https://www.freedesktop.org/wiki/Software/desktop-file-utils ; https://archlinux.org/packages/extra/x86_64/desktop-file-utils/
sudo pacman -S --noconfirm --needed nss  # Службы сетевой безопасности ; https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS ; https://archlinux.org/packages/core/x86_64/nss/
sudo pacman -S --noconfirm --needed openssl  # Набор инструментов с открытым исходным кодом для Secure Sockets Layer и Transport Layer Security ; https://www.openssl.org/ ; https://archlinux.org/packages/core/x86_64/openssl/
sudo pacman -S --noconfirm --needed sequoia-sqv  # Простая программа проверки подписи OpenPGP ; https://sequoia-pgp.org/ ; https://archlinux.org/packages/extra/x86_64/sequoia-sqv/
sudo pacman -S --noconfirm --needed zenity  # Отображение графических диалоговых окон из сценариев оболочки (возможно присутствует) ; https://gitlab.gnome.org/GNOME/zenity ; https://archlinux.org/packages/extra/x86_64/zenity/
sudo pacman -S --noconfirm --needed playerctl  # Контроллер и библиотека медиаплеера mpris для Spotify, VLC, Audacious, BMP, XMMS2 и других. https://github.com/altdesktop/playerctl ; https://archlinux.org/packages/extra/x86_64/playerctl/
######## spotify-launcher ############
sudo pacman -S --noconfirm --needed spotify-launcher  # Клиент для apt-репозитория Spotify в Rust для Arch Linux ; https://github.com/kpcyrd/spotify-launcher ; https://archlinux.org/packages/extra/x86_64/spotify-launcher/; После установки запустите приложение из меню приложений и войдите в систему, чтобы начать прослушивание ; Этот пакет управляет установкой для каждого пользователя в вашем домашнем каталоге, позволяя Spotify обновляться независимо от pacman (аналогично тому, как Spotify обновляется самостоятельно в других операционных системах).
# sudo pacman -Rns spotify-launcher  # Чтобы удалить Spotify вместе с его зависимостями и файлами конфигурации
# sudo pacman -S --noconfirm --needed spotifyd  # Легкий демон потоковой передачи Spotify с поддержкой Spotify Connect ; https://github.com/Spotifyd/spotifyd ; https://archlinux.org/packages/extra/x86_64/spotifyd/ ; Spotifyd транслирует музыку так же, как официальный клиент, но он более легкий и поддерживает больше платформ. Spotifyd также поддерживает протокол Spotify Connect, что позволяет ему отображаться как устройство, которым можно управлять из официальных клиентов. Примечание: для использования Spotifyd требуется учетная запись Spotify Premium. Spotifyd не будет работать без Spotify Premium
#############################
echo ""
echo " Установка Spotify (spotify-launcher) выполнена "
elif [[ $i_spotify == 2 ]]; then
  echo ""    
  echo " Установка Установка Spotify (spotify) + дополнения "
# sudo pacman -S --help
sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов 
#sudo pacman -Syyu --noconfirm  # Обновление баз плюс обновление пакетов (--noconfirm - не спрашивать каких-либо подтверждений)
# sudo pacman -Syyu  # Обновим вашу систему (базу данных пакетов) 
sudo pacman -S --noconfirm --needed devtools  # Инструменты для сопровождающих Arch Linux пакетов ; https://gitlab.archlinux.org/archlinux/devtools ; https://archlinux.org/packages/extra/any/devtools/ ; Devtools — инструменты разработки для Arch Linux ; Этот репозиторий содержит инструменты для дистрибутива Arch Linux, позволяющие создавать и поддерживать официальные пакеты репозитория.
######## Зависимости ############
sudo pacman -S --noconfirm --needed desktop-file-utils  # Утилиты командной строки для работы с записями рабочего стола ; https://www.freedesktop.org/wiki/Software/desktop-file-utils ; https://archlinux.org/packages/extra/x86_64/desktop-file-utils/
sudo pacman -S --noconfirm --needed libayatana-appindicator  # Общая библиотека индикаторов приложений Ayatana ; https://github.com/AyatanaIndicators/libayatana-appindicator ; https://archlinux.org/packages/extra/x86_64/libayatana-appindicator/
sudo pacman -S --noconfirm --needed libcurl-gnutls  # инструмент командной строки и библиотека для передачи данных с помощью URL-адресов (без версионных символов, связано с gnutls) ; https://curl.se/ ; https://archlinux.org/packages/core/x86_64/libcurl-gnutls/
sudo pacman -S --noconfirm --needed libsm  # Библиотека управления сеансами X11 ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/libsm/
sudo pacman -S --noconfirm --needed libxss  # Библиотека расширений X11 Screen Saver ; https://gitlab.freedesktop.org/xorg/lib/libxscrnsaver ; https://archlinux.org/packages/extra/x86_64/libxss/
sudo pacman -S --noconfirm --needed nss  # Службы сетевой безопасности ; https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS ; https://archlinux.org/packages/core/x86_64/nss/
sudo pacman -S --noconfirm --needed openssl  # Набор инструментов с открытым исходным кодом для Secure Sockets Layer и Transport Layer Security ; https://www.openssl.org/ ; https://archlinux.org/packages/core/x86_64/openssl/
sudo pacman -S --noconfirm --needed libnotify  # Библиотека для отправки уведомлений на рабочий стол ; https://gitlab.gnome.org/GNOME/libnotify ; https://archlinux.org/packages/extra/x86_64/libnotify/
  echo " Если вам нужно добавлять и воспроизводить локальные файлы, вам нужно дополнительно установить zenity и ffmpeg4.4 "
sudo pacman -S --noconfirm --needed ffmpeg4.4  # Комплексное решение для записи, конвертации и потоковой передачи аудио и видео ; https://ffmpeg.org/ ; https://archlinux.org/packages/extra/x86_64/ffmpeg4.4/
sudo pacman -S --noconfirm --needed zenity  # Отображение графических диалоговых окон из сценариев оболочки (возможно присутствует) ; https://gitlab.gnome.org/GNOME/zenity ; https://archlinux.org/packages/extra/x86_64/zenity/
sudo pacman -S --noconfirm --needed playerctl  # Контроллер и библиотека медиаплеера mpris для Spotify, VLC, Audacious, BMP, XMMS2 и других. https://github.com/altdesktop/playerctl ; https://archlinux.org/packages/extra/x86_64/playerctl/
sudo pacman -S --noconfirm --needed dunst  # Настраиваемый и легкий демон уведомлений ; https://dunst-project.org/ ; https://archlinux.org/packages/extra/x86_64/dunst/
sudo pacman -S --noconfirm --needed python-gobject  # Привязки Python для GLib / GObject / GIO / GTK + ; https://pygobject.gnome.org/ ; https://archlinux.org/packages/extra/x86_64/python-gobject/
######### spotify ################
echo " Сначала обязательно импортируйте правильный ключ GPG: "
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg  | gpg --import -  #Сначала обязательно импортируйте правильный ключ GPG:
# yay -S spotify-dev --noconfirm  # Собственный сервис потоковой передачи музыки ; https://aur.archlinux.org/spotify-dev.git (только для чтения, нажмите, чтобы скопировать) ; https://www.spotify.com/ ; https://aur.archlinux.org/packages/spotify-dev ; Конфликты: с spotify !!!
yay -S spotify --noconfirm  # Запатентованный сервис потоковой передачи музыки ; https://aur.archlinux.org/spotify.git (только для чтения, нажмите, чтобы скопировать) ; https://www.spotify.com/ ; https://aur.archlinux.org/packages/spotify ; https://www.spotify.com/int/why-not-available/ ; Если вы предпочитаете управлять обновлениями Spotify с помощью pacman , используйте вместо этого spotify AUR , который переупаковывает Spotify для Linux .
## git clone https://aur.archlinux.org/spotify.git  # Запатентованный сервис потоковой передачи музыки
## cd spotify
#makepkg -fsri
# makepkg -si
## makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
## pwd    # покажет в какой директории мы находимся
## cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf spotify 
## rm -Rf spotify
#-------------------------------------------------
# yay -S spotify_dl --noconfirm  # Загружает песни из вашего плейлиста Spotify ; https://aur.archlinux.org/spotify_dl.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/SathyaBhat/spotify-dl ; https://aur.archlinux.org/packages/spotify_dl
echo ""
echo " Установка Spotify выполнена "
fi
########## Справка ###############
# Spotify - https://wiki.archlinux.org/title/Spotify
##################################



Как установить DaVinci
https://wiki.archlinux.org/title/DaVinci_Resolve
DaVinci Resolve Checker
Вы можете запустить скрипт davinci-resolve-checker , который сообщит вам, подходит ли ваша конфигурация для запуска DR (не работает для Intel iGPU - говорит, что драйвер OpenCL не поддерживается, хотя вы можете заставить его работать). В хороших конфигурациях он должен вывести:
Кажется, все хорошо. Вы должны успешно запустить DaVinci Resolve. 



yay -S  --noconfirm


############ openjpeg ##########

yay -S openjpeg --noconfirm  # Кодек JPEG 2000 с открытым исходным кодом
## git clone https://aur.archlinux.org/openjpeg.git  # Кодек JPEG 2000 с открытым исходным кодом ; 
## cd openjpeg
#makepkg -fsri
# makepkg -si
## makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
## pwd    # покажет в какой директории мы находимся
## cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf openjpeg 
## rm -Rf openjpeg
############ ffmpeg-compat-57 ##########
yay -S ffmpeg-compat-57 --noconfirm  # Пакет совместимости для ffmpeg для предоставления 57 версий libavcodec, libavdevice и libavformat, больше не предоставляемых пакетом ffmpeg
## git clone https://aur.archlinux.org/ffmpeg-compat-57.git  # Пакет совместимости для ffmpeg для предоставления 57 версий libavcodec, libavdevice и libavformat, больше не предоставляемых пакетом ffmpeg
## cd ffmpeg-compat-57
#makepkg -fsri
# makepkg -si
## makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
## pwd    # покажет в какой директории мы находимся
## cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ffmpeg-compat-57 
## rm -Rf ffmpeg-compat-57




sudo pacman -S --noconfirm --needed
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 
sudo pacman -S --noconfirm --needed 

####################################



Обновление ключей необходимо во избежание дальнейших проблем с установкой пакетов:

sudo pacman-key --init               # Инициализация
sudo pacman-key --populate archlinux # Получить ключи из репозитория
sudo pacman-key --refresh-keys       # Проверить текущие ключи на актуальность
sudo pacman -Sy                      # Обновить ключи для всей системы




?yay -S m4baker-git --noconfirm  # Создавайте полнофункциональные m4b-аудиокниги (Собирается пакет долго!)
git clone https://github.com/crabmanX/m4baker
cd m4baker
python setup.py install --optimize=1

?yay -S myrulib-git --noconfirm  # Домашняя библиотека с поддержкой сайта lib.rus.ec
yay -S  --noconfirm 

ripit AUR — полноценный DAE с возможностью создания индексов глав с--bookопцией.  
yay -S ripit --noconfirm  # Инструмент командной строки для копирования треков с аудио-CD и их кодирования ; https://aur.archlinux.org/ripit.git (только для чтения, нажмите, чтобы скопировать) ; https://www.ripit.pl/ ; https://aur.archlinux.org/packages/ripit



sudo pacman -S --noconfirm --needed lib32-gcc-libs  # 32-битные библиотеки времени выполнения, поставляемые GCC ; https://gcc.gnu.org/ ; https://archlinux.org/packages/core/x86_64/lib32-gcc-libs/
yay -S neroaacenc-bin --noconfirm  # Аудиокодек Nero AAC эталонного качества MPEG-4 и 3GPP. Кодировщик ; https://aur.archlinux.org/neroaac-bin.git (только для чтения, нажмите, чтобы скопировать) ; http://www.nero.com/ ; https://aur.archlinux.org/packages/neroaacenc-bin ; Конфликты: с neroaac, neroaacenc
yay -S neroaacdec-bin --noconfirm  # Аудиокодек Nero AAC эталонного качества MPEG-4 и 3GPP. Декодер ; https://aur.archlinux.org/neroaac-bin.git (только для чтения, нажмите, чтобы скопировать) ; http://www.nero.com/ ; https://aur.archlinux.org/packages/neroaacdec-bin ; Конфликты: с neroaac, neroaacdec 
yay -S neroaactag-bin --noconfirm  # Nero AAC эталонного качества MPEG-4 и аудиокодек 3GPP. Редактор тегов ; https://aur.archlinux.org/neroaac-bin.git (только для чтения, нажмите, чтобы скопировать) ; http://www.nero.com/ ; https://aur.archlinux.org/packages/neroaactag-bin ; Конфликты: с neroaac, neroaactag



elif [[ $prog_set == 0 ]]; then
  echo 'Установка Мультимедиа утилит AUR пропущена.'
fi



#############################
 echo " Установка дополнительных мультимедиа кодеков и утилит (пакетов) "
#options+=("gst-plugin-libde265" "(AUR)" off)
#options+=("libde265" "(AUR)" off)

sudo pacman -S libde265 --noconfirm  # Открытая реализация видеокодека h.265
https://archlinux.org/packages/extra/x86_64/libde265/
https://github.com/strukturag/libde265

yay -S gst-plugin-libde265 --noconfirm  # Плагин Libde265 (открытая реализация видеокодека h.265) для gstreamer
https://aur.archlinux.org/packages/gst-plugin-libde265/
https://aur.archlinux.org/gst-plugin-libde265.git
https://github.com/strukturag/gstreamer-libde265

yay -S libde265-git --noconfirm  # Открытая реализация видеокодека H.265 (версия git)
https://aur.archlinux.org/packages/libde265-git/
https://aur.archlinux.org/libde265-git.git 
https://github.com/strukturag/libde265/

yay -S lib32-libde265 --noconfirm  # Открытая реализация видеокодека h.265 (32-разрядная версия)
https://aur.archlinux.org/packages/lib32-libde265/
https://aur.archlinux.org/lib32-libde265.git
https://github.com/strukturag/libde265


#yay -S bluez-firmware --noconfirm  # Прошивки для чипов Bluetooth Broadcom BCM203x и STLC2300
#yay -S pulseaudio-ctl --noconfirm  # Управляйте громкостью pulseaudio из оболочки или с помощью сочетаний клавиш

gst-plugin-libde265  -  # Плагин Libde265 (открытая реализация видеокодека h.265) для gstreamer
https://aur.archlinux.org/packages/gst-plugin-libde265/
https://aur.archlinux.org/gst-plugin-libde265.git 
https://github.com/strukturag/gstreamer-libde265

# libde265  -  #  ???
libde265-git  -  # Открытая реализация видеокодека H.265 (версия git)
https://aur.archlinux.org/packages/libde265-git/
https://aur.archlinux.org/libde265-git.git
https://github.com/strukturag/libde265/

lib32-libde265 --noconfirm  # Открытая реализация видеокодека h.265 (32-разрядная версия)
https://aur.archlinux.org/packages/lib32-libde265/
https://aur.archlinux.org/lib32-libde265.git 
https://github.com/strukturag/libde265

------------------------------------------

audiobook-git  -  # Простая программа для чтения аудиокниг. Написано на QT / QML и C ++ 
https://aur.archlinux.org/packages/audiobook-git/
https://aur.archlinux.org/audiobook-git.git 
https://github.com/bit-shift-io/audiobook

----------------------------------------------

cozy-audiobooks  -  # Современный проигрыватель аудиокниг для Linux с использованием GTK + 3
https://aur.archlinux.org/packages/cozy-audiobooks/
https://aur.archlinux.org/cozy-audiobooks.git
https://github.com/geigi/cozy

cosy-audiobooks-git  -  # Современный проигрыватель аудиокниг для Linux и macOS с использованием GTK + 3
https://aur.archlinux.org/packages/cozy-audiobooks-git/
https://aur.archlinux.org/cozy-audiobooks-git.git
https://cozy.geigi.de

------------------------------------------------

m4baker-git  -  # Создавайте полнофункциональные m4b-аудиокниги
m4baker-git   - # Сначала (Phonon-qt4 pyqt4-common python2-pyqt4)
https://aur.archlinux.org/packages/m4baker-git/
https://aur.archlinux.org/m4baker-git.git
https://github.com/crabmanX/m4baker

phonon-qt4 -  # Мультимедийный фреймворк для KDE4
https://aur.archlinux.org/packages/phonon-qt4/
https://aur.archlinux.org/phonon-qt4.git 
https://community.kde.org/Phonon

pyqt4-common -  # Общие файлы PyQt, общие для python-pyqt4 и python2-pyqt4
https://aur.archlinux.org/packages/pyqt4-common/
https://aur.archlinux.org/pyqt4.git 
https://riverbankcomputing.com/software/pyqt/intro

qt4 -  # Кроссплатформенное приложение и фреймворк пользовательского интерфейса
https://aur.archlinux.org/packages/qt4/
https://aur.archlinux.org/qt4.git 
https://www.qt.io
==> Установка недостающих зависимостей...
разрешение зависимостей...
проверка конфликтов...

Пакеты (1) unixodbc-2.3.9-1



unixodbc  -  # ODBC - это открытая спецификация для предоставления разработчикам приложений предсказуемого API для доступа к источникам данных
https://archlinux.org/packages/core/x86_64/unixodbc/
http://www.unixodbc.org/


python2-pyqt4 -  # Набор привязок Python 2.x для набора инструментов Qt
https://aur.archlinux.org/packages/python2-pyqt4/
https://aur.archlinux.org/pyqt4.git 
https://riverbankcomputing.com/software/pyqt/intro


------------------------------------------------


myrulib-git  -  # Домашняя библиотека с поддержкой сайта lib.rus.ec
myrulib-git   - # Сначала (wxgtk2.8 wxsqlite3-2.8 gstreamer0.10  0.10.36-17)
https://aur.archlinux.org/packages/myrulib-git/
https://aur.archlinux.org/myrulib-git.git 
http://www.lintest.ru/wiki/MyRuLib


myrulib-git    wxgtk2.8 wxsqlite3-2.8 gstreamer0.10  0.10.36-17
expat (expat-git)
wxgtk2.8 (wxgtk2.8-light)
wxsqlite3-2.8
git+https://github.com/lintest/myrulib.git

expat -  # Библиотека парсера XML
https://archlinux.org/packages/core/x86_64/expat/
https://libexpat.github.io/

expat (expat-git) -  # Библиотека потокового анализатора XML, написанная на C
https://aur.archlinux.org/packages/expat-git/
https://aur.archlinux.org/expat-git.git 
https://libexpat.github.io/

wxgtk2.8 -  # GTK + реализация wxWidgets API для GUI
https://aur.archlinux.org/packages/wxgtk2.8/
https://aur.archlinux.org/wxgtk2.8.git 
http://wxwidgets.org

wxgtk2.8-light -  # wxWidgets 2.8 с GTK2 Toolkit (GNOME / GStreamer бесплатно!)
https://aur.archlinux.org/packages/wxgtk2.8-light/
https://aur.archlinux.org/wxwidgets2.8-light.git 
http://wxwidgets.org

wxsqlite3 -  # Обертка wxWidgets для SQLite3, сборка для wxWidgets 2.8
https://aur.archlinux.org/packages/wxsqlite3-2.8/
https://aur.archlinux.org/wxsqlite3-2.8.git 
http://wxcode.sourceforge.net/components/wxsqlite3/

gstreamer0.10 -  # Мультимедийный фреймворк GStreamer
https://aur.archlinux.org/packages/gstreamer0.10/
https://aur.archlinux.org/gstreamer0.10.git
https://gstreamer.freedesktop.org


############ gstreamer0.10 ##########
echo "" 
echo " Установим мультимедийный фреймворк GStreamer из AUR "
#yay -S gstreamer0.10 --noconfirm  # Мультимедийный фреймворк GStreamer (Если установлен yay - эта команда)
git clone https://aur.archlinux.org/gstreamer0.10.git 
cd gstreamer0.10
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gstreamer0.10 
rm -Rf gstreamer0.10
#######################

-------------------------------------

yay -S mocicon --noconfirm  # Апплет панели GTK, позволяющий управлять MOC (Music On Console)
https://aur.archlinux.org/packages/mocicon/
https://aur.archlinux.org/mocicon.git
http://mocicon.sourceforge.net

mocicon  -  # Апплет панели GTK, позволяющий управлять MOC (Music On Console)
https://aur.archlinux.org/packages/mocicon/
https://aur.archlinux.org/mocicon.git 
http://mocicon.sourceforge.net

-------------------------------------
Опции makepkg:
-s/--syncdeps перед сборкой автоматически разрешает и устанавливает все зависимости с pacman. Если пакет зависит от других пакетов из AUR, вам нужно сначала установить их вручную.
-i/--install установить пакет если он успешно собран. В качестве альтернативы собранный пакет может быть установлен с pacman -U.
Другие полезные флаги для makepkg:

-r/--rmdeps после завершения сборки, удаляет зависимости, нужные на время сборки, поскольку после этого они не нужны. Тем не менее, эти зависимости могут понадобиться при переустановки или обновлении этого пакета в следующий раз.
-c/--clean очищает временные файлы сборки после окончания сборки, поскольку они больше не нужны. Эти файлы обычно нужны только для отладки процесса сборки.
https://blackarch.ru/?p=794
---------------------------------------

fetchmirrors -  # Утилита обновления зеркального списка Arch Linux pacman (Получение и ранжирование нового зеркального списка pacman)
https://aur.archlinux.org/packages/fetchmirrors/
https://aur.archlinux.org/fetchmirrors.git 
https://github.com/deadhead420/fetchmirrors
https://raw.githubusercontent.com/deadhead420/fetchmirrors/master/fetchmirrors.sh

----------------------------------------
Смена оболочки

echo -e "${MAGENTA}=> ${BOLD}Вот какая оболочка (shell) используется в данный момент: ${NC}"
echo $SHELL
echo "" 

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

################################################

echo -e "${YELLOW}==> ${NC}Примечание: плагин Python-Fu недоступен в версии GIMP, распространяемой через официальные репозитории, поскольку для него требуется python2 из AUR (https://aur.archlinux.org/packages/python2), поддержка которого прекращена в 2020 году. Для восстановления функциональности можно использовать python2-gimp из AUR (https://aur.archlinux.org/packages/python2-gimp) (https://aur.archlinux.org/packages?K=gimp-plugin). "

Стандартизированный интерфейс для управления и администрирования учетных записей пользователей и групп.
libuser # Стандартизированный интерфейс для управления и администрирования учетных записей пользователей и групп.
https://aur.archlinux.org/libuser.git (только для чтения, нажмите, чтобы скопировать)
https://pagure.io/libuser/
https://aur.archlinux.org/packages/libuser


echo 'Установка программ для обработки видео и аудио (конвертеры) AUR'
# Installing software for video and audio processing (converters) AUR
yay -S  --noconfirm


sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 





echo 'Установка программ для просмотра изображений'

sudo pacman -S feh --noconfirm  # Быстрый и легкий просмотрщик изображений на основе imlib2


echo 'Установка программ для рисования и редактирования изображений AUR'
# Installing software for drawing and editing images AUR
Viewnior также доступен в репозитории AUR, для его загрузки и установки вы можете использовать помощник Yay AUR:

yay -S viewnior-git


Кроме того, вы также можете напрямую загрузить и собрать пакет AUR с помощью команды git clone:

git-клон https://aur.archlinux.org/viewnior-git.git

cd viewnior-git

makepkg -si




XnViewMP https://aur.archlinux.org/packages/xnviewmp  ; https://aur.archlinux.org/xnviewmp.git  ; https://www.xnview.com/en/xnviewmp/
XnViewMP — это бесплатный кроссплатформенный медиабраузер и просмотрщик. Это мощное программное обеспечение для организации, конвертации, редактирования и изменения размера изображений. Поддерживает анимированные и многостраничные форматы. Среди всех этих функций также есть поддержка модуля пакетного преобразования, медиабиблиотеки и инструмента водяных знаков. XnViewMP — это улучшенная и многоплатформенная версия XnView.

XnViewMP предлагает следующие уникальные функции:

Гистограмма как отдельная панель.
Панель сводной информации метаданных.
Включает в себя инструмент редактирования EXIF.
Поддерживает более 500 форматов изображений.
Диалоговое окно «Плагины/Дополнения».
Экспортирует изображения в более чем 70 форматов.
Как и Mirage image viewer, XnViewMP также недоступен в репозитории Arch по умолчанию. Но вы можете получить его с помощью пакета AUR. Для этого, как упоминалось ранее, вы можете либо попробовать Yay AUR helper, либо напрямую клонировать репозиторий из Git.

Чтобы установить XnViewMP с помощью помощника AUR, выполните:
ура -S xnviewmp

После установки откройте тестовый файл образа с помощью этой команды:

xnviewmp ~/Загрузки/тестовое_изображение.jpg


В противном случае попробуйте воспользоваться графическим интерфейсом, используя опцию «Открыть с помощью» .

Вы также можете клонировать git-репозиторий просмотрщика изображений XnViewMP:

git-клон https://aur.archlinux.org/xnviewmp.git

компакт-диск xnviewmp

makepkg -si

10 лучших просмотрщиков изображений Arch Linux
ККашиф Джавед. Опубликовано 31/01/2024 .
Просмотрщик изображений — это программное обеспечение, с помощью которого вы можете просматривать, редактировать и управлять изображениями в вашей системе Arch. Просмотрщики изображений служат для разных целей. Вы можете просматривать галерею изображений или находить любимые фотографии. Некоторые просмотрщики изображений также позволяют просматривать онлайн-галерею изображений. Существует довольно много просмотрщиков изображений, которые позволяют редактировать изображения для создания слайд-шоу, обрезать, изменять размер и улучшать изображения для лучшего просмотра.

Если вы установили среду рабочего стола с Arch, то, скорее всего, вы также получите просмотрщик изображений по умолчанию. Если вам надоел просмотрщик изображений по умолчанию и вы хотите попробовать какой-то новый просмотрщик изображений, то эта статья кратко даст вам некоторые из лучших просмотрщиков изображений, доступных в Arch Linux.

Содержание:
Лучшие просмотрщики изображений Arch Linux

XIV
Мираж
Гики
XnViewMP
Видниор
Номаки
Фотоxx
Заем
Шотвелл
Глаз ГНОМА
Заключение

Лучшие просмотрщики изображений Arch Linux
Если ваш просмотрщик изображений по умолчанию работает нормально, вам не нужно его менять. Но если есть потребность в некоторых расширенных функциях, вы можете изучить другие варианты. Существует множество просмотрщиков изображений для Arch Linux, от простых до продвинутых. Давайте рассмотрим некоторые из лучших доступных просмотрщиков изображений для вашей машины Arch.

Примечание: Эти просмотрщики изображений не ранжируются от лучшего к худшему. Этот список содержит просмотрщики изображений, которые являются наиболее популярными среди пользователей Arch Linux на основе онлайн-источников.

1. XIV
Sxiv — это простой просмотрщик изображений для Arch Linux. Он написан на языке C. Sxiv имеет два режима: режим изображения и режим миниатюр. В режиме изображения он показывает только текущее изображение. С другой стороны, в режиме миниатюр он отображает сетку предпросмотров всех изображений в каталоге.

Некоторые из его уникальных особенностей:

Он поддерживает внешние события клавиш, которые позволяют настраивать сочетания клавиш клавиатуры и мыши.
Вы можете задать пользовательские сочетания клавиш для различных действий, таких как копирование, поворот и установка обоев изображения.
Вы можете определить свой скрипт обработчика клавиш в ~/.config/sxiv/exec/key-handler .
Sxiv может перезагружать и обновлять текущее изображение, если в нем произошли определенные изменения.
Поддержка загрузки кадров GIF-файлов. Также может открывать GIF-анимации.
Его можно встраивать в другие окна X с помощью параметра -e, что полезно для таких приложений, как вкладки.
Он легкий и поддерживает скрипты, с минимальными зависимостями.
Чтобы установить просмотрщик изображений Sxiv в Arch Linux, вы можете использовать менеджер пакетов Pacman:

sudo pacman -S sxiv


После установки Sxiv вы можете запустить его непосредственно из терминала, указав местоположение образа, или воспользоваться методом графического интерфейса.

Чтобы открыть каталог изображений из терминала с помощью средства просмотра изображений Sxiv, выполните команду со следующим синтаксисом:

sxiv ~/Загрузки/тестовое_изображение.jpg


Аналогично, для метода GUI щелкните правой кнопкой мыши по значку изображения и выберите опцию Открыть с помощью . В открывшемся окне выберите просмотрщик изображений Sxiv и нажмите Открыть . Вы увидите новое окно с просмотрщиком изображений Sxiv.



2. Мираж
Mirage — еще один быстрый и простой просмотрщик изображений GTK+. Он зависит только от PyGTK. Mirage может открывать различные форматы изображений, такие как PNG, JPG, GIF, XPM и другие. Он предоставляет базовые функции обработки изображений. Вы можете вращать, масштабировать и обрезать изображение по своему выбору.

Некоторые из его уникальных особенностей:

Предварительная загрузка и циклический просмотр различных изображений.
Используйте миниатюры для перехода к любому нужному изображению.
Слайд-шоу и полноэкранный просмотр.
Поддержка редактирования изображений, включая поворот, масштабирование, переворачивание и изменение насыщенности.
Сохраняйте, удаляйте, переименовывайте изображения или выполняйте с ними специальные действия.
Доступ к нему можно получить с консоли.
Поддержка настройки интерфейса.
Поддержка нескольких языков.
Mirage недоступен в репозитории Pacman по умолчанию для Arch Linux. Однако мы можем получить его с помощью пакета AUR. Чтобы получить пакет AUR, вы можете либо использовать любой помощник AUR, либо напрямую клонировать каталог git Mirage и скомпилировать его пакет.

Если вы новичок в Arch Linux, вам может быть проще использовать помощник AUR. Он автоматически загрузит пакет AUR и скомпилирует его для вас. Некоторые популярные помощники AUR включают yay, aurman и Pamac.

Чтобы установить программу просмотра изображений Mirage с помощью помощника AUR (Ура), выполните следующую команду:

sudo yay -S мираж
Скриншот компьютера Описание создано автоматически

Это установит последнюю версию Mirage, доступную в репозитории AUR.

После установки вы можете использовать эту команду для открытия файла изображения с помощью Mirage:

мираж ~/Downloads/test_image.jpg
Скриншот компьютера Описание создано автоматически

Вы также можете напрямую открыть изображение из файлового менеджера, используя опцию «Открыть с помощью» .

Скриншот компьютера Описание создано автоматически

Если у вас не установлен помощник AUR, вы все равно можете получить просмотрщик изображений Mirage, клонировав его напрямую из git. Для этого сначала установите необходимые инструменты, такие как base-devel и git . После этого вы можете клонировать Mirage из git. Затем выполните команду makepkg , перейдя в каталог, в который клонирован файл пакета. Эта команда скомпилирует пакет AUR.

Чтобы установить пакет Mirage Image Viewer AUR в Arch Linux, вы можете выполнить следующие действия:

git-клон https://aur.archlinux.org/mirage.git

кд мираж

makepkg -si


3. Гики
Geeqie — это просмотрщик изображений с открытым исходным кодом для систем Linux. Он предлагает множество функций, которые повышают скорость предварительного просмотра и организации изображений. Он был ответвлен от GQview в 007.

У Geeqie есть несколько уникальных функций, которые могут вам понравиться:

Он поддерживает предварительный просмотр необработанных изображений и легкое управление цветами.
Он поддерживает сравнение до четырех изображений, расположенных рядом.
Поддерживает прямое управление файлами и каталогами.
Он может настраивать файлы для работы с другим программным обеспечением.
Вы можете добавлять теги и комментарии, а также редактировать данные EXIF.
Geeqie поддерживает форматы метаданных EXIF, IPTC и XMP.
Вы также можете управлять своими коллекциями и распечатывать их.
Для установки Geeqie на Arch Linux используйте менеджер пакетов Pacman. Чтобы получить Geeqie, выполните эту команду:

sudo pacman -S гик


Чтобы открыть изображение с помощью Geeqie, вы можете выполнить эту команду:

гик ~/Downloads/test_image.jpg


Аналогично вы можете попробовать метод с графическим интерфейсом.



Чтобы получить пакет AUR Geeqie с помощью помощника AUR, выполните следующую команду:

ура -S гик


Если у вас нет помощника AUR, вы также можете клонировать Geeqie из git:

git-клон https://aur.archlinux.org/geeqie-git.git

cd geeqie-git

makepkg -si


4. XnViewMP
XnViewMP — это бесплатный кроссплатформенный медиабраузер и просмотрщик. Это мощное программное обеспечение для организации, конвертации, редактирования и изменения размера изображений. Поддерживает анимированные и многостраничные форматы. Среди всех этих функций также есть поддержка модуля пакетного преобразования, медиабиблиотеки и инструмента водяных знаков. XnViewMP — это улучшенная и многоплатформенная версия XnView.

XnViewMP предлагает следующие уникальные функции:

Гистограмма как отдельная панель.
Панель сводной информации метаданных.
Включает в себя инструмент редактирования EXIF.
Поддерживает более 500 форматов изображений.
Диалоговое окно «Плагины/Дополнения».
Экспортирует изображения в более чем 70 форматов.
Как и Mirage image viewer, XnViewMP также недоступен в репозитории Arch по умолчанию. Но вы можете получить его с помощью пакета AUR. Для этого, как упоминалось ранее, вы можете либо попробовать Yay AUR helper, либо напрямую клонировать репозиторий из Git.

Чтобы установить XnViewMP с помощью помощника AUR, выполните:

ура -S xnviewmp


После установки откройте тестовый файл образа с помощью этой команды:

xnviewmp ~/Загрузки/тестовое_изображение.jpg


В противном случае попробуйте воспользоваться графическим интерфейсом, используя опцию «Открыть с помощью» .

Скриншот компьютера Описание создано автоматически

Вы также можете клонировать git-репозиторий просмотрщика изображений XnViewMP:

git-клон https://aur.archlinux.org/xnviewmp.git

компакт-диск xnviewmp

makepkg -si


7. Фотоxx
Fotoxx — это просмотрщик изображений для систем Linux, который поддерживает редактирование изображений и управление коллекциями изображений. Он предоставляет некоторые расширенные функции, такие как удаление эффекта красных глаз, HDR, сшивание панорам и пакетная обработка. Наряду с этим вы также получаете некоторые предварительные базовые функции, такие как поворот, обрезка и масштабирование изображений.

Fotoxx предлагает следующие уникальные возможности:

Поддерживает просмотр изображений в стиле проводника. Предоставляет миниатюры и автоматическое обнаружение новых фотографий на вашем ПК.
Выделите любую часть изображения, сопоставив цвета, следуя краям или нарисовав от руки.
Вы можете добавлять к изображениям полезную информацию, такую ​​как теги, геотеги, даты и рейтинги.
Обрабатывайте несколько изображений одновременно, например, переименовывайте, изменяйте размер, копируйте, перемещайте, изменяйте формат или редактируйте информацию.
Создавайте альбомы и слайд-шоу, не делая копий изображений.
Склеивайте фотографии, чтобы создавать панорамы на 360 градусов.
Вы можете редактировать изображения, добавлять эффекты, обрезать, поворачивать, удалять эффект красных глаз и пылевые пятна с изображений.
Для установки Fotoxx на Arch Linux вы можете использовать помощник Yay AUR:

ура -S fotoxx


После установки откройте изображение с помощью Fotoxx в вашей системе Arch:

fotoxx ~/Загрузки/test_image.jpg
Луна в небе Описание создано автоматически

Или попробуйте просмотрщик изображений Fotoxx из файлового менеджера.

Скриншот компьютера Описание создано автоматически

Вы также можете вручную загрузить и скомпилировать пакет AUR Fotoxx, используя следующие команды:

git-клон https://aur.archlinux.org/fotoxx.git

cd fotoxx

makepkg -si


8. Кредит
Pqiv — это инструмент для просмотра изображений на основе GTK 3. Он поставляется с минимальным пользовательским интерфейсом и обладает высокой степенью настройки. Он может полностью контролироваться скриптами. Он поддерживает различные форматы файлов, включая PDF, Postscript и видеофайлы.

Некоторые уникальные особенности Pqiv:

Pqiv поддерживает анимацию и слайд-шоу.
В программе есть режим монтажа, позволяющий открывать несколько изображений одновременно.
В Pqiv также есть режим отрицания (инверсии цвета) (–negate).
В Pqiv действует система оценок, похожая на sxiv.
Имеет переключатель режима фонового рисунка (–background-pattern).
Для установки Pqiv на Arch Linux вы можете использовать менеджер пакетов Pacman:

sudo pacman -S pqiv


После установки выполните указанную команду, чтобы открыть образ:

pqiv ~/Загрузки/тестовое_изображение.jpg


Вы также можете проверить его с помощью файлового менеджера.

Скриншот компьютера Описание создано автоматически

9. Шотвелл
Shotwell — это просмотрщик изображений с инструментами управления фотографиями. Shotwell — это просмотрщик изображений по умолчанию для нескольких дистрибутивов Linux на базе GNOME. Он предоставляет базовые инструменты просмотра изображений, такие как поворот, масштабирование и обрезка.

Shotwell имеет следующие особенности:

Shotwell может напрямую импортировать ваши фотографии с камеры.
Он может группировать фотографии по дате и поддерживает теги.
В Shotwell предусмотрены такие функции редактирования изображений, как обрезка, устранение эффекта красных глаз и настройка уровней цвета.
Также имеется опция автоматического улучшения.
Shotwell может загружать изображения на Flickr и Piwigo.
С помощью Shotwell вы можете установить обои рабочего стола.
Для установки Shotwell на Arch Linux вы можете использовать менеджер пакетов Pacman:

sudo pacman -S shotwell


После завершения установки откройте тестовый образ с помощью этой команды:

шотвелл ~/Загрузки/test_image.jpg


Или попробуйте открыть изображение с помощью Shotwell через файловый менеджер.

Скриншот компьютера Описание создано автоматически



Заключение
Графический просмотрщик изображений — это программа, которая отображает изображения в графическом пользовательском интерфейсе (GUI). Он обеспечивает более интерактивный и визуально привлекательный способ просмотра изображений. В этой статье мы рассмотрели 10 различных просмотрщиков изображений, которые вы можете установить на свой компьютер Arch Linux. Каждый из этих просмотрщиков изображений предоставляет инструменты оптимизации и управления изображениями от базового до продвинутого уровня. Всеми этими просмотрщиками изображений можно управлять как с терминала, так и с помощью файлового менеджера. Если вам нужен упрощенный просмотрщик изображений, вы можете использовать EOG, а если вам нужен немного более продвинутый просмотрщик изображений с большим количеством инструментов редактирования, вы можете продолжить с Nomacs.



 AUR perl-xls2csv # Сскрипт, который перекодирует кодировку электронной таблицы и сохраняет ее в формате CSV ; https://aur.archlinux.org/perl-xls2csv.git ; http://search.cpan.org/~ken/xls2csv/script/xls2csv ; https://aur.archlinux.org/packages/perl-xls2csv
Зависимости (5)
perl ( perl-git AUR )
perl-libintl-perl
perl-электронная таблица-parseexcel AUR
perl-text-csv-xs AUR
perl-unicode-map AUR


profile-sync-daemon  # Символические ссылки и синхронизация каталогов профилей браузера с оперативной памятью ; https://github.com/graysky2/profile-sync-daemon ; https://archlinux.org/packages/extra/any/profile-sync-daemon/
Profile-sync-daemon (psd) — это крошечный псевдодемон, предназначенный для управления профилем вашего браузера в tmpfs и периодической синхронизации его с вашим физическим диском (HDD/SSD).


yay -S  --noconfirm
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 

echo 'Установка программ для просмотра изображений'


echo 'Установка программ для просмотра изображений AUR'
yay -S  --noconfirm
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
yay -S  --noconfirm  #
yay -S  --noconfirm  # 





sudo pacman -S kooha --noconfirm  # Элегантно записывайте свой экран 
yay -S kooha-git --noconfirm  #  Элегантно записывайте свой экран

yay -S qemu-arch-extra-git --noconfirm  # QEMU для зарубежных архитектур AUR



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
yay -S megasync --noconfirm  #
yay -S thunar-megasync-bin --noconfirm  # 
yay -S yandex-disk --noconfirm  # 
yay -S yandex-disk-indicator --noconfirm  # 
yay -S dropbox --noconfirm  # Бесплатный сервис, позволяющий переносить фотографии, документы и видео куда угодно и легко ими делиться. 
yay -S thunar-dropbox --noconfirm  # Плагин для Thunar, добавляющий элементы контекстного меню для Dropbox.
yay -S thunar-dropbox-git --noconfirm  # Плагин для Thunar, добавляющий элементы контекстного меню для Dropbox.
yay -S dropbox-light-icons-git --noconfirm  # Светлые значки Dropbox для темных панелей 
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
yay -S  --noconfirm  # 
####- sudo pacman -S deadbeef --noconfirm  # Аудиоплеер GTK + для GNU / Linux. AUR
###- sudo pacman -S you-get --noconfirm  # Загрузчик видео с YouTube / Youku / Niconico, написанный на Python 3. AUR
###- sudo pacman -S youtube-viewer --noconfirm  # Утилита командной строки для просмотра видео на YouTube. AUR

echo 'Утилиты для редактирования документов, PDF, DjVus, NFO, DIZ и XPS... , Читалки электронных книг, Словари, Таблицы'
# Utilities for editing documents, PDF, Djvu, NFO, DIZ and XPS..., e-book Readers, Dictionaries, Tables
### sudo pacman -S qpdfview --noconfirm  # Просмотрщик PDF с вкладками, использующий библиотеку poppler



echo 'Утилиты для редактирования документов, PDF, DjVus, NFO, DIZ и XPS... , Читалки электронных книг, Словари, Таблицы AUR'
# Utilities for editing documents, PDF, Djvu, NFO, DIZ and XPS..., e-book Readers, Dictionaries, Tables AUR
yay -S hunspell-ru masterpdfeditor --noconfirm
yay -S --noconfirm  # 
yay -S hunspell-ru --noconfirm  # Русский словарь hunspell
yay -S masterpdfeditor --noconfirm  # Комплексное решение для просмотра, создания и редактирования файлов PDF
yay -S qpdfview --noconfirm  #  Просмотрщик PDF с вкладками, использующий библиотеку poppler
yay -S epdfview-git --noconfirm  # Легкий просмотрщик PDF-документов 
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


echo 'Офисные пакеты AUR'
# Office suite AUR
yay -S papirus-libreoffice-theme --noconfirm  # Тема Papirus для LibreOffice
yay -S  --noconfirm
yay -S  --noconfirm
# Wps office
yay -S wps-office --noconfirm  # Kingsoft Office (WPS Office) - офисный пакет для повышения производительности
yay -S ttf-wps-fonts --noconfirm  # Если установлен WPS - Символьные шрифты требуются wps-office
yay -S ttf-wps-win10 --noconfirm
yay -S wps-office-mui-ru --noconfirm  # Пакеты MUI для WPS Office
###yay -S wps-office-extension-russian-dictionary --noconfirm  # Русский словарь для WPS Office
yay -S wps-office-all-dicts-win-languages --noconfirm
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
# sudo pacman -S woeusb --noconfirm  # Программа Linux для создания установщика USB-накопителя Windows с DVD-диска Windows или образа
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 
sudo pacman -S --noconfirm  # 

echo 'Утилиты для работы с CD,DVD, создание ISO образов, запись на флеш-накопители AUR'
# Utilities for working with CD, DVD, creating ISO images, writing to flash drives AUR
yay -S mintstick unetbootin --noconfirm 
# yay -S woeusb-git --noconfirm  #
yay -S mintstick --noconfirm  # Графический интерфейс для записи файлов .img или .iso на USB-накопитель. Он также может их форматировать
yay -S unetbootin --noconfirm  # Создание загрузочных USB-накопителей Live
yay -S woeusb-gui --noconfirm  # Программа Linux для создания установщика USB-накопителя Windows с DVD-диска Windows или образа
yay -S kazam --noconfirm  #
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


sudo pacman -S twp ?--noconfirm  # https://addons.mozilla.org/ru/firefox/addon/traduzir-paginas-web/

https://github.com/FilipePS/Traduzir-paginas-web
Установить
Fire Fox

    Пользователи настольных компьютеров: загрузите их с Mozilla Addons .https://addons.mozilla.org/firefox/addon/traduzir-paginas-web/
    Пользователи Android
        Установите последнюю версию Firefox (v120+) .
        Откройте менеджер расширений.
        Прокрутите вниз и нажмите « Найти другие дополнения» .
        На сайте дополнений найдите TWP .
        Установите расширение TWP — Translate For Mobile .

Вивальди, Опера, Макстон, Хром и Яндекс

    Загрузите этот CRX-файл TWP_Chromium.crx.
    Откройте менеджер расширений вашего браузера, его можно найти по этой ссылке: chrome://extensions
    Активировать режим разработчика
    Перезагрузите страницу менеджера расширений, чтобы избежать ошибок.
    Перетащите файл TWP_Chromium.crx в диспетчер расширений.
    Примечание 1. В Opera, Maxthon и Яндексе режим разработчика включать не нужно.
    Примечание 2: В Яндексе нужно повторно активировать расширение каждый раз при открытии браузера.

Chrome, Edge и Brave (с папкой без автоматического обновления)

    Загрузите и распакуйте этот ZIP-файл TWP_Chromium.zip.
    Откройте менеджер расширений вашего браузера, его можно найти по этой ссылке: chrome://extensions
    Активировать режим разработчика
    Перезагрузите страницу менеджера расширений, чтобы избежать ошибок.
    Перетащите папку TWP_Chromium в диспетчер расширений.

Chrome, Edge и Brave (с CRX и автоматическим обновлением)

    По умолчанию эти браузеры блокируют установку расширений за пределами официального магазина расширений, однако, изменив реестр Windows, можно отменить это, разрешив установку определенных расширений. Если вы хотите сделать это, следуйте инструкциям ниже:

    Загрузите это и запустите файл twp-registry-install.reg . Он редактирует необходимые реестры Windows.
    Закройте браузер и откройте его снова
    Загрузите этот CRX-файл TWP_Chromium.crx.
    Откройте менеджер расширений вашего браузера, его можно найти по этой ссылке: chrome://extensions
    Активировать режим разработчика
    Перезагрузите страницу менеджера расширений, чтобы избежать ошибок.
    Перетащите файл TWP_Chromium.crx в диспетчер расширений.
    Примечание. Если вы хотите отменить изменения в реестре, загрузите и запустите этот файл twp-registry-uninstall-self.reg . Если вы хотите более глубокое удаление, загрузите и запустите другой файл twp-registry-uninstall-all.reg.


sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #





echo 'Сетевые утилиты, Tor, VPN, SSH, Samba и тд...'
# Network utilities, Tor, VPN, SSH, Samba, etc...
sudo pacman -S tor torsocks --noconfirm
sudo pacman -S tor --noconfirm  # Анонимизирующая оверлейная сеть
sudo pacman -S torsocks --noconfirm  # Оболочка для безопасной торификации приложений
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S proxychains-ng privoxy openvpn --noconfirm
sudo pacman -S privoxy --noconfirm  # Веб-прокси с расширенными возможностями фильтрации
sudo pacman -S proxychains-ng --noconfirm  # Предварительный загрузчик ловушки, который позволяет перенаправлять TCP-трафик существующих динамически связанных программ через один или несколько SOCKS или HTTP-прокси
sudo pacman -S openvpn --noconfirm  # Простой в использовании, надежный и настраиваемый VPN (виртуальная частная сеть)
sudo pacman -S openconnect --noconfirm  # Открытый клиент для Cisco AnyConnect VPN
sudo pacman -S vpnc --noconfirm  # Клиент VPN для концентраторов cisco3000 VPN
sudo pacman -S networkmanager-openconnect --noconfirm  # Плагин NetworkManager VPN для OpenConnect
sudo pacman -S networkmanager-pptp --noconfirm  # Плагин NetworkManager VPN для PPTP
sudo pacman -S networkmanager-vpnc --noconfirm  # Плагин NetworkManager VPN для VPNC
sudo pacman -S mitmproxy --noconfirm  # HTTP-прокси с поддержкой SSL (https://mitmproxy.org/)
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #



sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #


 Запуск, остановка сервиса tor:
sudo systemctl start tor
sudo systemctl stop tor

sudo pacman -S --noconfirm

echo 'Сетевые утилиты, Tor, VPN, SSH, Samba и тд... AUR'
# Network utilities, Tor, VPN, SSH, Samba, etc... AUR
sudo pacman -S samba --noconfirm  # Файловый сервер SMB и сервер домена AD
 
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
simplescreenrecorder peek '
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
sudo pacman -S simplescreenrecorder --noconfirm  # Многофункциональный экранный рекордер, поддерживающий X11 и OpenGL
sudo pacman -S lib32-simplescreenrecorder --noconfirm  # Записывайте 32-битные приложения OpenGL с помощью SimpleScreenRecorder
sudo pacman -S peek --noconfirm  # Простой экранный рекордер с простым в использовании интерфейсом
sudo pacman -S gnome-screenshot --noconfirm  # Сфотографируйте свой экран



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
gksu debtap menulibre caffeine-ng inxi xneur fsearch-git timeshift mocicon multiload-ng-indicator-gtk xfce4-multiload-ng-plugin-gtk2 keepass2-plugin-tray-icon gconf-editor gconf-cleaner webtorrent-desktop corectrl mkinitcpio-openswap fetchmirrors gtk3-mushrooms'
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
yay -S gksu debtap menulibre caffeine-ng inxi xneur fsearch-git timeshift mocicon multiload-ng-indicator-gtk xfce4-multiload-ng-plugin-gtk2 keepass2-plugin-tray-icon gconf-editor gconf-cleaner  corectrl qt4 xflux flameshot-git mkinitcpio-openswap fetchmirrors gtk3-mushrooms --noconfirm  # xorg-xkill
yay -S keepass2-plugin-tray-icon --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #

yay -S fsearch-git --noconfirm  #

yay -S webtorrent-desktop --noconfirm  #
https://aur.archlinux.org/packages?O=0&K=webtorrent-desktop

yay -S woeusb --noconfirm  # Программа Linux для создания установщика USB-накопителя Windows с DVD-диска Windows или образа. 
yay -S woeusbgui --noconfirm  # НЕОБХОДИМАЯ старая версия графического интерфейса 


yay -S gconf --noconfirm  # Устаревшая система базы данных конфигурации
https://aur.archlinux.org/packages/gconf/
https://aur.archlinux.org/gconf.git 
https://projects-old.gnome.org/gconf/

yay -S gconf-editor --noconfirm  # Графический редактор реестра gconf
https://aur.archlinux.org/packages/gconf-editor/
https://aur.archlinux.org/gconf-editor.git 
https://www.gnome.org

yay -S gconf-cleaner --noconfirm  # Инструмент очистки для GConf
https://aur.archlinux.org/packages/gconf-cleaner/
https://aur.archlinux.org/gconf-cleaner.git 
http://code.google.com/p/gconf-cleaner

yay -S fetchmirrors --noconfirm  # Получение и ранжирование нового зеркального списка pacman
https://aur.archlinux.org/packages/fetchmirrors/
https://aur.archlinux.org/fetchmirrors.git 
https://github.com/deadhead420/fetchmirrors





--------------------------------

yay -S gtk3-mushrooms --noconfirm  # GTK3 исправлен для классических настольных компьютеров, таких как XFCE или MATE. См. README
https://aur.archlinux.org/packages/gtk3-mushrooms/
https://aur.archlinux.org/gtk3-mushrooms.git
https://github.com/krumelmonster/gtk3-mushrooms


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
https://aur.archlinux.org/packages/powerpill
Вы также можете установить несколько пакетов, как и при работе с pacman:

powerpill -S package1 package2 package3

yay -S  --noconfirm  #
# ===========================================

############################
Иероглифы в русских названиях файлов в ZIP-архивах

#yay -S zip-natspec --noconfirm  # Создает PKZIP-совместимые файлы .zip для нелатинских имен файлов с использованием патча libnatspec от AltLinux
#yay -S unzip-natspec --noconfirm  # Распаковывает .zip-архивы с нелатинскими именами файлов, используя патч libnatspec от AltLinux
yay -S libnatspec --noconfirm  # Набор функций для запроса различных кодировок и локалей для хост-системы и для другой системы 
# yay -S p7zip-natspec --noconfirm  # Файловый архиватор командной строки с высокой степенью сжатия, основанный на патче libnatspec из ubuntu zip-i18n PPA (https://launchpad.net/~frol/+archive/zip-i18n)
yay -S zip-natspec unzip-natspec libnatspec --noconfirm  #

После установки они заменяют штатные команды zip и unzip , что позволяет использовать их не только в консоли, но и через ГУИшные программы, использующие zip и unzip в качестве бэкэнда для ZIP-архивов.
########################


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
yay -S davfs2 --noconfirm  # Драйвер файловой системы, позволяющий монтировать папку WebDAV ; Раньше присутствовал в community ...
yay -S pcurses --noconfirm  # Инструмент управления пакетами curses с использованием libalpm (pacman) (https://github.com/schuay/pcurses) ; Раньше присутствовал в community ...
yay -S termite --noconfirm  # Простой терминал на базе VTE ; Раньше присутствовал в community ...
yay -S foot-terminfo-git --noconfirm  # Альтернативные файлы terminfo для эмулятора ножного терминала с дополнительными нестандартными возможностями.
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
# ###sudo pacman -S --noconfirm --needed pcurses  #


confirm  # Меняет обои с регулярным интервалом, используя указанные пользователем или автоматически загруженные изображения
### sudo pacman -S recolla --noconfirm  # Инструмент полнотекстового поиска на базе Xapian backend (recoll)

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
### sudo pacman -S freemind --noconfirm  #  Ментальный картограф и в то же время простой в использовании иерархический редактор с упором на сворачивание
elif [[ $prog_set == 0 ]]; then
  echo 'Установка программ пропущена.' 
fi


###########################


sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #
sudo pacman -S  --noconfirm  #




yay -S  --noconfirm  #
yay -S  --noconfirm  #






######################

# "freshplayerplugin" "(AUR) Recommended" - PPAPI-host Адаптер NPAPI-plugin
# "freshplayerplugin-git" "(AUR)" - PPAPI-host Адаптер NPAPI-plugin
#  "vivaldi" "(AUR) (GTK)" - Продвинутый браузер, созданный для опытных пользователей
#  "vivaldi-ffmpeg-codecs" "(AUR) Non-free codecs" - дополнительная поддержка проприетарных кодеков для vivaldi
sudo pacman -S pepper-flash --noconfirm  # Adobe Flash Player PPAPI
yay -S freshplayerplugin --noconfirm  # PPAPI-host Адаптер NPAPI-plugin (Recommended)
yay -S freshplayerplugin-git --noconfirm  # PPAPI-host Адаптер NPAPI-plugin

yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #

#################################
# ktorrent (QT) - Мощный клиент BitTorrent для KDE 
# tixati (AUR) (GTK) - Tixati - это программа для однорангового обмена файлами, использующая популярный протокол BitTorrent

sudo pacman -S ktorrent --noconfirm  # Мощный клиент BitTorrent для KDE ; https://pingvinus.ru/program/ktorrent
yay -S ktorrent-git --noconfirm  # Мощный клиент BitTorrent. (Версия GIT)
yay -S tixati --noconfirm  # Tixati - это программа для однорангового обмена файлами, использующая популярный протокол BitTorrent
yay -S  --noconfirm  #
================================

echo 'Установка Дополнительных программ AUR'
# Installing Additional programs AUR
echo -e "${BLUE}
'Список Дополнительных программ к установке AUR:${GREEN}
сюда вписать список программ'
${NC}"
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
yay -S xfce4-calculator-plugin --noconfirm  # Простой калькулятор на основе командной строки для панели Xfce
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


xfce4-places-plugin   AUR  # Плагин меню Places для панели Xfce
https://aur.archlinux.org/packages/xfce4-places-plugin/
https://aur.archlinux.org/xfce4-places-plugin.git
http://goodies.xfce.org/projects/panel-plugins/xfce4-places-plugin
Последнее обновление: 2019-08-12 14:44

Этот плагин, изначально написанный Диего Онгаро , представляет собой меню с быстрым доступом к папкам, документам и съемным носителям. Плагин Places привносит в Xfce большую часть функций меню Places GNOME.

Плагин помещает простую кнопку на панель. При нажатии на эту кнопку открывается меню со следующим:

Системные каталоги (домашняя папка, корзина, рабочий стол, файловая система)
Съемный носитель (с использованием thunar-vfs)
Пользовательские закладки (читает ~/.gtk-bookmarks)
Средство запуска программы поиска (необязательно)
Подменю последних документов (требуется GTK + v2.10 или выше)
использование
Просто добавьте его в панель. Пользовательские закладки можно изменить с помощью файлового менеджера или вручную ~/.gtk-bookmarks. Вы можете настроить плагин, щелкнув правой кнопкой мыши по кнопке и выбрав «Свойства» (см. Снимок экрана ниже).

oh-my-zsh-git  AUR  # Платформа сообщества для управления вашей конфигурацией zsh. Включает 180+ дополнительных плагинов и более 120 тем, чтобы оживить ваше утро, а также инструмент автоматического обновления, чтобы вы могли легко быть в курсе последних обновлений от сообщества
https://aur.archlinux.org/packages/oh-my-zsh-git/
https://aur.archlinux.org/oh-my-zsh-git.git
https://github.com/ohmyzsh/ohmyzsh
Последнее обновление: 2020-04-16 17:58

---------------------------------

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
https://github.com/hectorm/hblock
Last Updated: 2021-03-08 19:55

Установка
hBlock доступен в различных менеджерах пакетов. Обновленный список можно найти в файле PACKAGES.md .

Последнюю доступную версию также можно установить вручную, выполнив следующие команды:

curl -o /tmp/hblock 'https://raw.githubusercontent.com/hectorm/hblock/v3.2.1/hblock' \
  && echo '698932a84a0cd51ee633c84ca36713e520a0f40c30e2afc59b0fd7016c9c70f8  /tmp/hblock' | shasum -c \
  && sudo mv /tmp/hblock /usr/local/bin/hblock \
  && sudo chown 0:0 /usr/local/bin/hblock \
  && sudo chmod 755 /usr/local/bin/hblock
  
  hBlock - это POSIX-совместимый сценарий оболочки, который получает список доменов, которые обслуживают рекламу, сценарии отслеживания и вредоносные программы из нескольких источников, и создает файл хостов , среди других форматов , который предотвращает подключение вашей системы к ним.


firefox-extension-leechblock  AUR  # LeechBlock - это простой бесплатный инструмент для повышения производительности, предназначенный для блокировки тех сайтов, которые тратят время впустую, которые могут высосать жизнь из вашего рабочего дня.
https://aur.archlinux.org/packages/firefox-extension-leechblock/
https://aur.archlinux.org/firefox-extension-leechblock.git
https://addons.mozilla.org/en-US/firefox/addon/leechblock-ng/
Последнее обновление: 2019-04-09 21:51

LeechBlock NG - это простой инструмент повышения производительности, предназначенный для блокировки тех сайтов, которые тратят время впустую, которые могут высосать жизнь из вашего рабочего дня. Все, что вам нужно сделать, это указать, какие сайты и когда блокировать.

Только с Firefox - установите Firefox прямо сейчас


xfce4-docklike-plugin  AUR  # Современная минималистичная панель задач в стиле док-станции для XFCE
https://aur.archlinux.org/packages/xfce4-docklike-plugin/
https://aur.archlinux.org/xfce4-docklike-plugin.git 
https://github.com/nsz32/docklike-plugin
Last Updated: 2021-03-14 08:28

Пользовательский репозиторий ArchLinux (AUR)
yay -S xfce4-docklike-plugin-git


xfce4-docklike-plugin-git  AUR  # Современная минималистичная панель задач в стиле док-станции для XFCE
https://aur.archlinux.org/packages/xfce4-docklike-plugin-git/
https://aur.archlinux.org/xfce4-docklike-plugin-git.git
https://github.com/nsz32/docklike-plugin
Last Updated: 2020-09-03 23:15


lightdm-slick-greeter  AUR  # Красивое приветствие LightDM
https://aur.archlinux.org/packages/lightdm-slick-greeter/
https://aur.archlinux.org/lightdm-slick-greeter.git
https://github.com/linuxmint/slick-greeter
Последнее обновление: 2021-01-20 18:44

Конфигурация
Конфигурация по умолчанию хранится в dconf под схемой x.dm.slick-greeter.
Дистрибутивы должны устанавливать свои собственные значения по умолчанию, используя переопределение glib.
Пользователи могут создавать и изменять /etc/lightdm/slick-greeter.conf, настройки в этих файлах имеют приоритет и перезаписывают настройки dconf.
Инструмент настройки доступен по адресу https://github.com/linuxmint/lightdm-settings.

Функции
Slick-Greeter является кросс-распространяемым и должен работать практически везде.
Все апплеты панели встроены. Приветствие не запускает и не загружает внешние индикаторы.
Программа приветствия не запускает и не загружает демон настроек.
Это средство приветствия поддерживает HiDPI.
Сессии подтверждены. Если сеанс по умолчанию / выбранный отсутствует в системе, программа приветствия сканирует известные сеансы в / usr / share / xsessions и заменяет неверный выбор сеанса действительным сеансом.
Вы можете сделать снимок экрана, нажав PrintScrn. Снимок экрана сохраняется в /var/lib/lightdm/Screenshot.png.


bluez-utils-compat  AUR  # Утилиты для разработки и отладки стека протоколов Bluetooth. Включает устаревшие инструменты.
https://aur.archlinux.org/packages/bluez-utils-compat/
https://aur.archlinux.org/bluez-utils-compat.git 
http://www.bluez.org/
Последнее обновление: 2021-02-24 18:04


grml-iso  AUR  # добавьте ISO-образ grml в меню загрузки grub2
https://aur.archlinux.org/packages/grml-iso/
https://aur.archlinux.org/grml-iso.git 
http://wiki.grml.org/doku.php?id=rescueboot
Последнее обновление: 2020-07-26 23:59

Предисловие
Система восстановления Grml поддерживает загрузку Grml ISO с жесткого диска. Это обеспечивает достойный способ иметь Grml ISO в / boot / grml / на вашем жестком диске, и пока жесткий диск и его загрузчик GRUB работают, вы можете загрузить систему восстановления Grml без аварийного компакт-диска, USB-ручки или Доступна среда PXE.

Чтобы максимально упростить эту задачу, мы создали grml-rescueboot, который интегрирует загрузку по ISO в GRUB. Пакет grml-rescueboot включает сценарий для update-grub, который ищет образы Grml ISO в / boot / grml и автоматически добавляет запись для каждого образа.

Требования
Grml ISO
Загрузчик GRUB2

ИЛИ 

grml-rescueboot  AUR  # grub2 скрипт для добавления ISO-образов grml в меню загрузки grub2
https://aur.archlinux.org/packages/grml-rescueboot/
https://aur.archlinux.org/grml-rescueboot.git 
http://wiki.grml.org/doku.php?id=rescueboot
Последнее обновление: 2020-12-29 09:11

-----------------------------

Лаунчер: rofi (Alt + d)
Переключатель окон, средство запуска приложений и замена dmenu
https://www.archlinux.org/packages/community/x86_64/rofi/

Композитный менеджер: compton (По умолчанию отключен).



Установить:
Находясь в каталоге клонов, выполните эту команду:

cp -r OSX-Arc* ~/.local/share/aurorae/themes/
Arch Linux (AUR)
Если у вас есть тризен (или любой другой помощник AUR):

<Insert AUR Helper Here> -S osx-arc-aurorae-theme 
Если ты не:

git clone https://aur.archlinux.org/osx-arc-aurorae-theme.git && cd osx-arc-aurorae-theme && makepkg -si

osx-arc-aurorae-theme-git  AUR  # Тема Aurorae, разработанная для дополнения тем gtk OSX-Arc @ LinxGem33
https://aur.archlinux.org/packages/osx-arc-aurorae-theme-git/
https://aur.archlinux.org/osx-arc-aurorae-theme-git.git
https://github.com/iboyperson/OSX-Arc-Aurorae
Last Updated: 2018-10-27 23:21
Установить:
Находясь в каталоге клонов, выполните эту команду:

cp -r OSX-Arc* ~/.local/share/aurorae/themes/
Arch Linux (AUR)
Если у вас есть тризен (или любой другой помощник AUR):

<Insert AUR Helper Here> -S osx-arc-aurorae-theme 
Если ты не:

git clone https://aur.archlinux.org/osx-arc-aurorae-theme.git && cd osx-arc-aurorae-theme && makepkg -si

-------------------------------------



papirus-maia-icon-theme-git  AUR  # Вариант Manjaro темы значков Papirus (версия git)
https://aur.archlinux.org/packages/papirus-maia-icon-theme-git/
https://aur.archlinux.org/papirus-maia-icon-theme-git.git 

breeze-default-cursor-theme  AUR  # Тема курсора по умолчанию Breeze.
https://aur.archlinux.org/packages/breeze-default-cursor-theme/
https://aur.archlinux.org/breeze-default-cursor-theme.git

---------------------------------------
 
sudo pacman -S systemd systemd-libs systemd-resolvconf systemd-sysvcompat --noconfirm
sudo pacman -S  --noconfirm  
sudo pacman -S  --noconfirm  
sudo pacman -S  --noconfirm  

----------------------------------------
if [[ $i_cpu == 0 ]]; then
clear
echo " Добавление ucode пропущено "
elif [[ $i_cpu  == 1 ]]; then
clear
pacman -S amd-ucode --noconfirm
echo  'initrd /amd-ucode.img ' >> /boot/loader/entries/arch.conf
elif [[ $i_cpu  == 2 ]]; then
clear
pacman -S intel-ucode  --noconfirm
echo ' initrd /intel-ucode.img ' >> /boot/loader/entries/arch.conf
fi
echo "initrd  /initramfs-linux.img" >> /boot/loader/entries/arch.conf
clear
lsblk -f
echo ""
echo " Укажите тот радел который будет после перезагрузки, то есть например "

echo " при установке с флешки ваш hdd может быть sdb, а после перезагрузки sda "

echo " выше видно что sdbX например примонтирован в /mnt, а после перезагрузки systemd будет искать корень на sdaX "

echo " если указать не правильный раздел система не загрузится "

echo " если у вас один hdd/ssd тогда это будет sda 99%"
echo ""
read -p "Укажите ROOT(корневой) раздел для загрузчика (Не пyтать с Boot!!!) (пример  sda6,sdb3 или nvme0n1p2 ): " root
Proot=$(blkid -s PARTUUID /dev/$root | grep -oP '(?<=PARTUUID=").+?(?=")')
echo options root=PARTUUID=$Proot rw >> /boot/loader/entries/arch.conf
#
cd /home/$username 
git clone https://aur.archlinux.org/systemd-boot-pacman-hook.git  # Перехватчик Pacman для обновления systemd-boot после обновления systemd
chown -R $username:users /home/$username/systemd-boot-pacman-hook  # https://aur.archlinux.org/packages/systemd-boot-pacman-hook/ 
chown -R $username:users /home/$username/systemd-boot-pacman-hook/PKGBUILD 
cd /home/$username/systemd-boot-pacman-hook   
sudo -u $username makepkg -si --noconfirm  
rm -Rf /home/$username/systemd-boot-pacman-hook
cd /home/$username 



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

============================
Soft AUR ===================
============================

===============================================



-----------------------------------------------

papirus-libreoffice-theme  -  # Тема Papirus для LibreOffice
https://aur.archlinux.org/packages/papirus-libreoffice-theme/
https://aur.archlinux.org/papirus-libreoffice-theme.git
https://github.com/PapirusDevelopmentTeam/papirus-libreoffice-theme

papirus-libreoffice-theme-git  -  # Тема Papirus для LibreOffice
https://aur.archlinux.org/packages/papirus-libreoffice-theme-git/
https://aur.archlinux.org/papirus-libreoffice-theme-git.git
https://github.com/PapirusDevelopmentTeam/papirus-libreoffice-theme


==> Установка недостающих зависимостей...
разрешение зависимостей...
проверка конфликтов...

Пакеты (1) unixodbc-2.3.9-1

sudo pacman -S unixodbc --noconfirm  # ODBC - это открытая спецификация для предоставления разработчикам приложений предсказуемого API для доступа к источникам данных

unixodbc  -  # ODBC - это открытая спецификация для предоставления разработчикам приложений предсказуемого API для доступа к источникам данных
https://archlinux.org/packages/core/x86_64/unixodbc/
http://www.unixodbc.org/



-----------------------------------------


------------------------------------------

system-config-samba  -  # Инструмент настройки Samba от Red Hat
https://aur.archlinux.org/packages/system-config-samba/
https://aur.archlinux.org/system-config-samba.git 
http://fedoraproject.org/wiki/SystemConfig/samba

system-config-samba  -  # Инструмент настройки Samba от Red Hat
https://aur.archlinux.org/packages/system-config-samba/
https://aur.archlinux.org/system-config-samba.git 
http://fedoraproject.org/wiki/SystemConfig/samba

==> Установка недостающих зависимостей...
[sudo] пароль для alex: 
ошибка: не найдена цель: libuser
==> ОШИБКА: pacman: не удалось установить недостающие зависимости.
==> Недостающие зависимости:
  -> samba
  -> libuser
==> Проверка зависимостей для сборки...
==> ОШИБКА: Не удалось разрешить все зависимости.


sudo pacman -S samba --noconfirm  # Файловый сервер SMB и сервер домена AD
yay -S libuser --noconfirm  # Стандартизированный интерфейс для управления и администрирования учетных записей пользователей и групп

  echo ""  
  echo " Установка LibUser "
##### libuser ###### 
# yay -S libuser --noconfirm  # Стандартизированный интерфейс для управления и администрирования учетных записей пользователей и групп
git clone https://aur.archlinux.org/libuser.git # Стандартизированный интерфейс для управления и администрирования учетных записей пользователей и групп
cd libuser  # переместит пользователя в каталог с исходниками
#makepkg -fsri
# makepkg -si
# makepkg -g  # посчитает контрольные суммы пакетов, далее нужно просто эти контрольные суммы заменить в PKGBUILD`е на правильные (
# mousepad PKGBUILD  # открыть PKGBUILD в редакторе текста
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf libuser
rm -Rf libuser
echo ""   
echo " Установка утилит (пакетов) выполнена "
echo " Желательно перезагрузить систему для применения изменений "


sudo pacman -S samba --noconfirm  # Файловый сервер SMB и сервер домена AD

samba  -  # Файловый сервер SMB и сервер домена AD
https://archlinux.org/packages/extra/x86_64/samba/
https://www.samba.org
Last Updated: 2021-03-25 18:49 UTC

О самбе
Samba - это стандартный набор программ для взаимодействия с Windows для Linux и Unix.

Samba - это бесплатное программное обеспечение под лицензией GNU General Public License , проект Samba является членом Software Freedom Conservancy .

С 1992 года Samba предоставляет безопасные, стабильные и быстрые службы файлов и печати для всех клиентов, использующих протокол SMB / CIFS, таких как все версии DOS и Windows, OS / 2, Linux и многие другие.

Samba - важный компонент для беспрепятственной интеграции серверов и рабочих столов Linux / Unix в среды Active Directory. Он может функционировать как контроллер домена или как обычный член домена.

----------
yay -S libuser --noconfirm  # Стандартизированный интерфейс для управления и администрирования учетных записей пользователей и групп

libuser  - AUR  # Стандартизированный интерфейс для управления и администрирования учетных записей пользователей и групп
https://aur.archlinux.org/packages/libuser/
https://aur.archlinux.org/libuser.git
https://pagure.io/libuser/
Last Updated: 2018-01-07 12:44

Библиотека libuser реализует стандартизированный интерфейс для управления и
администрирование учетных записей пользователей и групп. Библиотека использует подключаемые серверные части для
интерфейс со своими источниками данных.

Примеры приложений, смоделированных по образцу приложений, включенных в набор теневых паролей
включены.

Новые выпуски будут доступны по адресу https://pagure.io/libuser.

Ошибки
====
Пожалуйста, подумайте о том, чтобы сообщить об ошибке в систему отслеживания ошибок вашего дистрибутива.

В противном случае сообщайте об ошибках на https://pagure.io/libuser. Запросы на вытягивание
особенно приветствую.

------------------------------------------

gksu  -  # Графический интерфейс для su
https://aur.archlinux.org/packages/gksu/
https://aur.archlinux.org/gksu.git 
http://www.nongnu.org/gksu/index.html

libgksu  -  # библиотека авторизации gksu
https://aur.archlinux.org/packages/libgksu/
https://aur.archlinux.org/libgksu.git 
http://www.nongnu.org/gksu/index.html

gconf  -  # Устаревшая система базы данных конфигурации
https://aur.archlinux.org/packages/gconf/
https://aur.archlinux.org/gconf.git
https://projects-old.gnome.org/gconf/

----------------------------------------

debtap  - ------
debugap  -  # Сценарий для преобразования пакетов .deb в пакеты Arch Linux, ориентированный на точность. Не используйте его для преобразования пакетов, которые уже существуют в официальных репозиториях или могут быть собраны из AUR!
https://aur.archlinux.org/packages/debtap/
https://aur.archlinux.org/debtap.git  
https://github.com/helixarch/debtap

----------------------------------------

menulibre  -  # Продвинутый редактор меню, который предоставляет современные функции в чистом, простом в использовании интерфейсе
https://aur.archlinux.org/packages/menulibre/
https://aur.archlinux.org/menulibre.git 
https://github.com/bluesabre/menulibre
Menulibre

-----------------------------------------

xneur  -  # X Neural Switcher определяет язык ввода и при необходимости корректирует раскладку клавиатуры
https://aur.archlinux.org/packages/xneur/
https://aur.archlinux.org/xneur.git
http://www.xneur.ru

==> ОШИБКА: Произошел сбой в build().
    Прерывание...
makepkg -s  5,14s user 1,33s system 96% cpu 6,735 total

ИЛИ
autonumlock  # Автоматически включает Numlock для внешней клавиатуры. Также может выполнять пользовательские команды, например 'xmodmap'.

xneur-devel-git  - AUR  # X Neural Switcher определяет язык ввода и корректирует раскладку клавиатуры. Версия Git
https://aur.archlinux.org/packages/xneur-devel-git/
https://aur.archlinux.org/xneur-devel-git.git
https://github.com/AndrewCrewKuznetsov/xneur-devel
Последнее обновление: 2019-12-15 12:50

Зависимости:
enchant1  -  AUR  # Библиотека-оболочка для общей проверки орфографии
https://aur.archlinux.org/packages/enchant1.6/
https://aur.archlinux.org/enchant1.6.git 
https://abiword.github.io/enchant/
Last Updated: 2018-02-25 16:33

==> Проверка зависимостей для запуска...
==> Установка недостающих зависимостей...
разрешение зависимостей...
проверка конфликтов...

Пакеты (2) hspell-1.4-3  libvoikko-4.3.1-1

Будет загружено:  0,78 MiB
Будет установлено:  1,19 MiB


You have to check if enchant1.6 is installed
And /usr/include/enchant is a symlink to /usr/include/enchant1.6
ln -s /usr/include/enchant1.6 /usr/include/enchant
makepkg -s  6,11s user 2,06s system 58% cpu 14,062 total

sudo ln -s /usr/include/enchant1.6 /usr/include/enchant #

sudo pacman -S hspell --noconfirm  # Проверка орфографии на иврите 

sudo pacman -S libvoikko --noconfirm  # Средство проверки орфографии и грамматики, расстановка переносов и сбор связанных лингвистических данных для финского языка 

hspell  -  # Проверка орфографии на иврите
https://archlinux.org/packages/extra/x86_64/hspell/
http://www.ivrix.org.il/projects/spell-checker/
Последнее обновление: 2020-05-21 00:24 UTC


libvoikko  -  # Средство проверки орфографии и грамматики, расстановка переносов и сбор связанных лингвистических данных для финского языка
https://archlinux.org/packages/extra/x86_64/libvoikko/
http://voikko.sourceforge.net
Последнее обновление: 2021-03-13 09:05 UTC


Enchant - это библиотека (и программа командной строки), которая объединяет ряд различных библиотек и программ проверки орфографии с единым интерфейсом. Используя Enchant, вы можете использовать широкий спектр библиотек проверки правописания, в том числе некоторые специализированные для определенных языков, без необходимости программировать интерфейс каждой библиотеки. Если вызывать библиотеку C неудобно, вы можете получить доступ к большей части функций Enchant через программу enchant, которая обменивается данными по каналу, например ispell, и действительно совместима с ispell.


gxneur  -  # Интерфейс GTK для XNeur
https://aur.archlinux.org/packages/gxneur/
https://aur.archlinux.org/gxneur.git 
http://www.xneur.ru

==> Установка недостающих зависимостей...
[sudo] пароль для alex: 
ошибка: не найдена цель: xneur>=0.20.0
==> ОШИБКА: pacman: не удалось установить недостающие зависимости.
==> Недостающие зависимости:
  -> xneur>=0.20.0
==> Проверка зависимостей для сборки...
==> ОШИБКА: Не удалось разрешить все зависимости.


Package requirements (xnconfig = 0.20.0) were not met:

Package dependency requirement 'xnconfig = 0.20.0' could not be satisfied.
Package 'xnconfig' has version '0.21.0', required version is '= 0.20.0'

Consider adjusting the PKG_CONFIG_PATH environment variable if you
installed software in a non-standard prefix.

Alternatively, you may set the environment variables XNEURCONF_CFLAGS
and XNEURCONF_LIBS to avoid the need to call pkg-config.
See the pkg-config man page for more details.

==> ОШИБКА: Произошел сбой в build().
    Прерывание...
makepkg -s  4,82s user 1,17s system 94% cpu 6,369 total

Замена gxneur

gxneur-devel-git  - AUR  # Интерфейс GTK для XNeur (XNeur GTK frontend. Git version)
https://aur.archlinux.org/packages/gxneur-devel-git/
https://aur.archlinux.org/gxneur-devel-git.git
https://github.com/AndrewCrewKuznetsov/xneur-devel
Last Updated:   2019-12-15 12:53

Dependencies (5) - Зависимости

    gconf (gconf-gtk2)
    libglade
    xorg-xprop
    xneur-devel-git>=0.21.0
    git (git-git) (make)
    
  ==> ОШИБКА: Переменная 'depends' не должна быть пустой.  

 GNU nano 5.6.1                        PKGBUILD                                  
 1 # Packager: push_sla <push2001sla@gmail.com>
 2 # Developer: andrewcrew@rambler.ru
 3
 4 pkgname=gxneur-devel-git
 5 pkgver=0.21.0
 6 pkgrel=30
 7 epoch=
 8 pkgdesc="XNeur GTK frontend. Git version"
 9 arch=('any')
10 url="https://github.com/AndrewCrewKuznetsov/xneur-devel"
11 license=('GPL')
12 groups=()
13 depends=('libglade' "xneur-devel-git=$pkgver" 'gconf' 'xorg-xprop' '')
14 makedepends=('git')
15 checkdepends=()
16 optdepends=()
17 provides=("gxneur=$pkgver")
18 conflicts=('gxneur')
19 replaces=('gxneur')
20 backup=()
21 options=()
22 install=

:: Проверка целостности gxneur-devel-git...
==> ОШИБКА: Переменная 'depends' не должна быть пустой.
:: Preparing gxneur-devel-git...
==> ОШИБКА: Переменная 'depends' не должна быть пустой.
:: failed to verify integrity or prepare gxneur-devel-git package
:: failed to verify integrity or prepare gxneur-devel-git package
pacaur -S gxneur-devel-git  5,06s user 0,80s system 2% cpu 3:25,07 total


Исправить PKGBUILD 

❯ mousepad PKGBUILD

убрать пустые скобки '' Переменная 'depends' не должна быть пустой.

depends=('libglade' "xneur-devel-git=$pkgver" 'gconf' 'xorg-xprop' '')

Результат:

depends=('libglade' "xneur-devel-git=$pkgver" 'gconf' 'xorg-xprop')

Запускаем сборку пакета

❯ makepkg -s

-- Configuring incomplete, errors occurred!
See also "/home/alex/gxneur-devel-git/src/xneur-devel/gxneur/build/CMakeFiles/CMakeOutput.log".
==> ОШИБКА: Произошел сбой в build().
    Прерывание...
makepkg -s  23,83s user 5,55s system 7% cpu 6:24,49 total

------------------------------------------

fsearch-git  -  # Утилита быстрого поиска файлов. Версия Git
https://aur.archlinux.org/packages/fsearch-git/
https://aur.archlinux.org/fsearch-git.git
https://cboxdoerfer.github.io/fsearch

-----------------------------------------



autoupgrade  -  # Автоматический снимок с последующим обновлением системы. (В случае сбоя системы запустите `sudo timeshift --restore` и удалите этот пакет, пока проблема не будет решена.)
https://aur.archlinux.org/packages/autoupgrade/
https://aur.archlinux.org/autoupgrade.git 
https://github.com/star2000/autoupgrade

---------------------------------------


---------------------------------------

multiload-ng-indicator-gtk    -  --------
multiload-ng-indicator-gtk2  -  # Современный графический системный монитор, плагин AppIndicator
https://aur.archlinux.org/packages/multiload-ng-indicator-gtk2/
https://aur.archlinux.org/multiload-ng-indicator-gtk2.git
https://udda.github.io/multiload-ng/

multiload-ng-indicator-gtk3  -  # Современный графический системный монитор, плагин AppIndicator
https://aur.archlinux.org/packages/multiload-ng-indicator-gtk3/
https://aur.archlinux.org/multiload-ng-indicator-gtk3.git
https://udda.github.io/multiload-ng/

---------------------------------------

xfce4-multiload-ng-plugin-gtk2  -  # Современный графический системный монитор, плагин панели XFCE4
https://aur.archlinux.org/packages/xfce4-multiload-ng-plugin-gtk2/
https://aur.archlinux.org/xfce4-multiload-ng-plugin-gtk2.git 
https://udda.github.io/multiload-ng/

--------------------------------------

keepass2-plugin-tray-icon  -  # Функциональная иконка в трее для KeePass2
https://aur.archlinux.org/packages/keepass2-plugin-tray-icon/
https://aur.archlinux.org/keepass2-plugin-tray-icon.git 
https://github.com/dlech/Keebuntu

---------------------------------------

gconf-editor  -  # Графический редактор реестра gconf
https://aur.archlinux.org/packages/gconf-editor/
https://aur.archlinux.org/gconf-editor.git
https://www.gnome.org

----------------------------------------

gconf-cleaner  -  # Инструмент очистки для GConf
https://aur.archlinux.org/packages/gconf-cleaner/
https://aur.archlinux.org/gconf-cleaner.git 
http://code.google.com/p/gconf-cleaner

----------------------------------------

webtorrent-desktop  -  # Потоковый торрент-клиент
https://aur.archlinux.org/packages/webtorrent-desktop/
https://aur.archlinux.org/webtorrent-desktop.git 
https://webtorrent.io/desktop

webtorrent-desktop  -  # Потоковый торрент-клиент
https://aur.archlinux.org/packages/webtorrent-desktop/
https://aur.archlinux.org/webtorrent-desktop.git 
https://webtorrent.io/desktop

==> Проверка зависимостей для запуска...
==> Установка недостающих зависимостей...
[sudo] пароль для alex: 
разрешение зависимостей...
проверка конфликтов...

Пакеты (3) c-ares-1.17.1-1  re2-1:20210401-1  electron-12.0.2-1

Будет загружено:   49,20 MiB
Будет установлено:  165,20 MiB

==> Проверка зависимостей для сборки...
==> Установка недостающих зависимостей...
разрешение зависимостей...
проверка конфликтов...

Пакеты (3) node-gyp-7.1.2-1  semver-7.3.5-2  npm-7.8.0-1

Будет загружено:   3,42 MiB
Будет установлено:  16,62 MiB



webtorrent-desktop-bin  -  # Потоковый торрент-клиент
https://aur.archlinux.org/packages/webtorrent-desktop-bin/
https://aur.archlinux.org/webtorrent-desktop-bin.git
https://webtorrent.io/desktop


c-ares  -  # Библиотека AC для асинхронных DNS-запросов
https://archlinux.org/packages/extra/x86_64/c-ares/
https://c-ares.haxx.se/
Last Updated: 2020-11-19 20:45 UTC


re2  -  # Быстрый, безопасный, ориентированный на многопоточность механизм регулярных выражений
https://archlinux.org/packages/extra/x86_64/re2/
https://github.com/google/re2
Последнее обновление: 2021-04-01 02:59 UTC

electron  -  # Создавайте кроссплатформенные настольные приложения с помощью веб-технологий
https://archlinux.org/packages/community/x86_64/electron/
https://electronjs.org/
Последнее обновление: 2021-04-01 14:57 UTC

node-gyp  -  # Инструмент для сборки надстроек Node.js
https://archlinux.org/packages/community/any/node-gyp/
https://github.com/nodejs/node-gyp
Последнее обновление: 2021-01-22 17:59 UTC

semver  -  # Парсер семантической версии, используемый npm
https://archlinux.org/packages/community/any/semver/
https://github.com/npm/node-semver
Последнее обновление: 2021-03-23 ​​16:07 UTC

npm  -  # Менеджер пакетов для javascript
https://archlinux.org/packages/community/any/npm/
https://www.npmjs.com/
Последнее обновление: 2021-04-02 19:18 UTC

--------------------------------------

teamviewer  -  # Универсальное программное обеспечение для удаленной поддержки и онлайн-встреч
https://aur.archlinux.org/packages/teamviewer/
https://aur.archlinux.org/teamviewer.git 
http://www.teamviewer.com

--------------------------------------

corectrl  -  # Основное приложение управления
https://aur.archlinux.org/packages/corectrl/
https://aur.archlinux.org/corectrl.git 
https://gitlab.com/corectrl/corectrl
https://gitlab.com/corectrl/corectrl/-/archive/v1.1.1/corectrl-v1.1.1.tar.bz2

corectrl-git  -  # Приложение для легкого управления оборудованием с помощью профилей приложений
https://aur.archlinux.org/packages/corectrl-git/
https://aur.archlinux.org/corectrl-git.git
https://gitlab.com/corectrl/corectrl

--------------------------------------

qt4  -  # Кросс-платформенное приложение и UI-фреймворк
https://aur.archlinux.org/packages/qt4/
https://aur.archlinux.org/qt4.git
https://www.qt.io
https://wiki.archlinux.org/index.php/Qt_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
Бинарная версия последней версии (4.8.7-32) с подписью PGP доступна здесь:
https://ftp.desolve.ru/ftp/viktor/binpkg/qt4/

--------------------------------------

xflux  -  # (f.lux для X) Адаптивно изменяет цветовую температуру монитора, чтобы снизить нагрузку на глаза (версия для командной строки)
https://aur.archlinux.org/packages/xflux/
https://aur.archlinux.org/xflux.git
https://justgetflux.com/

xflux-gui-git  -  # Лучшее освещение для Linux. Графический интерфейс с открытым исходным кодом для xflux
https://aur.archlinux.org/packages/xflux-gui-git/
https://aur.archlinux.org/xflux-gui-git.git
https://justgetflux.com/linux.html

==> Установка недостающих зависимостей...
[sudo] пароль для alex: 
ошибка: не найдена цель: xflux
==> ОШИБКА: pacman: не удалось установить недостающие зависимости.
==> Недостающие зависимости:
  -> xflux
  -> libindicator-gtk2
==> Проверка зависимостей для сборки...
==> ОШИБКА: Не удалось разрешить все зависимости.



sudo pacman -S libindicator-gtk2 --noconfirm  # Набор символов и удобных функций для индикаторов Ayatana (библиотека GTK+ 2)

libindicator-gtk2  # Набор символов и удобных функций для индикаторов Ayatana (библиотека GTK+ 2)
https://archlinux.org/packages/community/x86_64/libindicator-gtk2/
https://launchpad.net/libindicator
Last Updated:   2020-03-16 08:37 UTC
---------------------------------------

flameshot-git  -  # Мощное, но простое в использовании программное обеспечение для создания снимков экрана
https://aur.archlinux.org/packages/flameshot-git/
https://aur.archlinux.org/flameshot-git.git 
https://github.com/flameshot-org/flameshot

-----------------------------------------

lib32-simplescreenrecorder  -  # Записывайте 32-разрядные приложения OpenGL с помощью SimpleScreenRecorder. (Версия Git)
https://aur.archlinux.org/packages/lib32-simplescreenrecorder-git/
https://aur.archlinux.org/lib32-simplescreenrecorder-git.git
https://www.maartenbaert.be/simplescreenrecorder/

-------------------------------------

mkinitcpio-openswap  -  # mkinitcpio, чтобы открыть своп во время загрузки
https://aur.archlinux.org/packages/mkinitcpio-openswap/
https://aur.archlinux.org/mkinitcpio-openswap.git 
https://aur.archlinux.org/packages/mkinitcpio-openswap/

--------------------------------------

fetchmirrors  -  # Получите новый зеркальный список pacman и оцените лучшее
https://aur.archlinux.org/packages/fetchmirrors/
https://aur.archlinux.org/fetchmirrors.git 
https://github.com/deadhead420/fetchmirrors

-------------------------------------

gtk3-mushrooms  -  # GTK3 исправлен для классических настольных компьютеров, таких как XFCE или MATE. См. README
https://aur.archlinux.org/packages/gtk3-mushrooms/
https://aur.archlinux.org/gtk3-mushrooms.git
https://github.com/krumelmonster/gtk3-mushrooms

==> Установка недостающих зависимостей...
разрешение зависимостей...
проверка конфликтов...

Пакеты (2) libsass-3.6.4-1  sassc-3.6.1-2

Будет загружено:  0,74 MiB
Будет установлено:  2,71 MiB

sudo pacman -S libsass --noconfirm  # C реализация препроцессора Sass CSS (библиотека)
sudo pacman -S sassc --noconfirm  # C реализация препроцессора Sass CSS

libsass  -  # C реализация препроцессора Sass CSS (библиотека)
https://archlinux.org/packages/community/x86_64/libsass/
http://libsass.org/
Последнее обновление: 2020-05-01 17:44 UTC

sassc  -  # C реализация препроцессора Sass CSS
https://archlinux.org/packages/community/x86_64/sassc/
http://libsass.org/
Последнее обновление: 2020-07-09 18:08 UTC

------- ------------------------------

==> Недостающие зависимости:
  -> libeudev
==> Проверка зависимостей для сборки...
==> ОШИБКА: Не удалось разрешить все зависимости.

lib32-libudev0  -  # 
# ( lib32-libudev0-shim-nosystemd )  -  # Библиотека совместимости libudev.so.0 для систем с более новыми версиями udev (32 бит)
https://aur.archlinux.org/packages/lib32-libudev0-shim-nosystemd/
https://aur.archlinux.org/lib32-libudev0-shim-nosystemd.git
https://github.com/archlinux/libudev0-shim

==> ОШИБКА: pacman: не удалось установить недостающие зависимости.
==> Недостающие зависимости:
  -> libeudev
  -> lib32-eudev
  -> libudev0-shim
==> Проверка зависимостей для сборки...
==> ОШИБКА: Не удалось разрешить все зависимости.

yay -S libeudev --noconfirm  # Клиентские библиотеки eudev

Обнаружены конфликты пакетов:
 -> Установка libeudev приведёт к удалению: systemd-libs (libudev.so)
конфликты пакетов не могут быть разрешены опцией noconfirm, прерывание

yay -S lib32-eudev --noconfirm  # Инструменты разработки пользовательского пространства (udev), разветвленные Gentoo (32-разрядные)

sudo pacman -S libudev0-shim --noconfirm  # Библиотека совместимости libudev.so.0 для систем с более новыми версиями udev

libeudev  AUR  # Клиентские библиотеки eudev
https://aur.archlinux.org/packages/libeudev/
https://aur.archlinux.org/eudev.git 
https://github.com/gentoo/eudev
Last Updated:   2021-03-16 21:09

==> Установка недостающих зависимостей...
[sudo] пароль для alex: 
разрешение зависимостей...
проверка конфликтов...

Пакеты (1) gperf-3.1-3

Будет загружено:  0,10 MiB
Будет установлено:  0,23 MiB



gperf  -  # Идеальный генератор хэш-функций
https://archlinux.org/packages/extra/x86_64/gperf/
https://www.gnu.org/software/gperf/
Last Updated:   2020-05-19 01:35 UTC

ИЛИ

libeudev-git  AUR  # Клиентские библиотеки eudev
https://aur.archlinux.org/packages/libeudev-git/
https://aur.archlinux.org/eudev-git.git 
https://github.com/gentoo/eudev
Last Updated:   2020-12-13 01:36




❯ yay -S libeudev-git --noconfirm 
:: Проверка конфликтов...
:: Проверка внутренних конфликтов...
 -> 
Обнаружены конфликты пакетов:
 -> Установка libeudev-git приведёт к удалению: lib32-eudev (libudev.so), systemd-libs (libudev.so)
конфликты пакетов не могут быть разрешены опцией noconfirm, прерывание



lib32-eudev  AUR  # Инструменты разработки пользовательского пространства (udev), разветвленные Gentoo (32-разрядные)
https://aur.archlinux.org/packages/lib32-eudev/
https://aur.archlinux.org/lib32-eudev.git
https://dev.gentoo.org/~blueness/eudev
Last Updated:   2021-03-16 21:10

==> Установка недостающих зависимостей...
[sudo] пароль для alex: 
разрешение зависимостей...
проверка конфликтов...

Пакеты (2) lib32-pcre-8.44-1  lib32-glib2-2.68.0-5

Будет загружено:  1,52 MiB
Будет установлено:  5,04 MiB

sudo pacman -S lib32-pcre --noconfirm  # Библиотека, реализующая регулярные выражения в стиле Perl 5 (32-разрядные)

sudo pacman -S lib32-glib2 --noconfirm  # Низкоуровневая базовая библиотека (32-битная)

lib32-pcre  -  # Библиотека, реализующая регулярные выражения в стиле Perl 5 (32-разрядные)
https://archlinux.org/packages/multilib/x86_64/lib32-pcre/
https://www.pcre.org
Last Updated:   2020-03-15 23:34 UTC

lib32-glib2  -  #Низкоуровневая базовая библиотека (32-битная)
https://archlinux.org/packages/multilib/x86_64/lib32-glib2/
https://wiki.gnome.org/Projects/GLib
Last Updated:   2021-03-27 00:03 UTC


==> Установка недостающих зависимостей...
[sudo] пароль для alex: 
ошибка: не найдена цель: lib32-kmod
==> ОШИБКА: pacman: не удалось установить недостающие зависимости.
==> Недостающие зависимости:
  -> lib32-kmod
==> ОШИБКА: Не удалось разрешить все зависимости.


yay -S lib32-kmod-minimal-git --noconfirm  # Обработка модулей ядра Linux

lib32-kmod-minimal-git  AUR  # Обработка модулей ядра Linux
https://aur.archlinux.org/packages/lib32-kmod-minimal-git/
https://aur.archlinux.org/lib32-kmod-minimal-git.git
https://www.kernel.org/pub/linux/utils/kernel/kmod
Last Updated:   2021-01-12 01:16

==> Завершена сборка пакета lib32-kmod-minimal-git v28+16+g8742be0-1 (Чт 08 апр 2021 00:40:04)

ИЛИ

yay -S lib32-kmod --noconfirm  # Обработка модулей ядра Linux


lib32-kmod  AUR  # Обработка модулей ядра Linux
https://aur.archlinux.org/packages/lib32-kmod/
https://aur.archlinux.org/lib32-kmod.git
http://git.kernel.org/?p=utils/kernel/kmod/kmod.git;a=summary
Last Updated:   2018-03-06 22:05

==> Проверка файлов source с использованием md5sums...
    kmod-25.tar.xz ... Готово
    kmod-25.tar.sign ... Пропущено
==> Проверка подписей исходных файлов с помощью 'gpg'...
    kmod-25.tar ... СБОЙ (неизвестный открытый ключ 9BA2A5A630CBEA53)
==> ОШИБКА: Одна или больше PGP-подписей не могут быть проверены!
------------

ИЛИ 

lib32-eudev-git   AUR  # Инструменты разработки пользовательского пространства (udev), разветвленные Gentoo (32-разрядные)
https://aur.archlinux.org/packages/lib32-eudev-git/
https://aur.archlinux.org/lib32-eudev-git.git 
https://dev.gentoo.org/~blueness/eudev
Last Updated:   2020-09-18 22:26

sudo pacman -S lib32-pcre --noconfirm  # Библиотека, реализующая регулярные выражения в стиле Perl 5 (32-разрядные)

sudo pacman -S lib32-glib2 --noconfirm  # Низкоуровневая базовая библиотека (32-битная)

lib32-pcre  -  # Библиотека, реализующая регулярные выражения в стиле Perl 5 (32-разрядные)
https://archlinux.org/packages/multilib/x86_64/lib32-pcre/
https://www.pcre.org
Last Updated:   2020-03-15 23:34 UTC

lib32-glib2  -  #Низкоуровневая базовая библиотека (32-битная)
https://archlinux.org/packages/multilib/x86_64/lib32-glib2/
https://wiki.gnome.org/Projects/GLib
Last Updated:   2021-03-27 00:03 UTC


libudev0-shim  -  # Библиотека совместимости libudev.so.0 для систем с более новыми версиями udev
https://archlinux.org/packages/community/x86_64/libudev0-shim/
https://github.com/archlinux/libudev0-shim
Last Updated:   2020-07-09 18:08 UTC

ИЛИ

libudev0-shim-nosystemd  AUR  # Библиотека совместимости libudev.so.0 для систем с более новыми версиями udev
https://aur.archlinux.org/packages/libudev0-shim-nosystemd/
https://aur.archlinux.org/libudev0-shim-nosystemd.git 
https://github.com/archlinux/libudev0-shim 
Last Updated:   2021-02-10 01:35

!!! ПАКЕТ lib32-eudev НЕ БЫЛ СОБРАН!


------------------------------------

xfce4-calculator-plugin  -  # Плагин калькулятора для панели Xfce4
https://aur.archlinux.org/packages/xfce4-calculator-plugin/
https://aur.archlinux.org/xfce4-calculator-plugin.git 
http://goodies.xfce.org/projects/panel-plugins/xfce4-calculator-plugin

---------------------------------------

xfce4-places-plugin  -  # Плагин меню Places для панели Xfce
https://aur.archlinux.org/packages/xfce4-places-plugin/
https://aur.archlinux.org/xfce4-places-plugin.git
http://goodies.xfce.org/projects/panel-plugins/xfce4-places-plugin

-------------------------------------

oh-my-zsh-git  -  # Платформа сообщества для управления вашей конфигурацией zsh. Включает 180+ дополнительных плагинов и более 120 тем, чтобы оживить ваше утро, а также инструмент автоматического обновления, чтобы вы могли легко быть в курсе последних обновлений от сообщества
https://aur.archlinux.org/packages/oh-my-zsh-git/
https://aur.archlinux.org/oh-my-zsh-git.git
https://github.com/ohmyzsh/ohmyzsh

--------------------------------------

zsh-theme-powerlevel10k-git  -  # Powerlevel10k - это тема для Zsh. Он подчеркивает скорость, гибкость и готовность к работе.
https://aur.archlinux.org/packages/zsh-theme-powerlevel10k-git/
https://aur.archlinux.org/zsh-theme-powerlevel10k-git.git 
https://github.com/romkatv/powerlevel10k


-----------------------------------

zsh-fast-syntax-highlighting-git  -  # Оптимизированная и расширенная подсветка синтаксиса zsh
https://aur.archlinux.org/packages/zsh-fast-syntax-highlighting-git/
https://aur.archlinux.org/zsh-fast-syntax-highlighting-git.git
https://github.com/zdharma/fast-syntax-highlighting


-----------------------------------

nohang  AUR - # Сложный обработчик нехватки памяти

https://aur.archlinux.org/packages/nohang/
https://aur.archlinux.org/nohang.git
https://github.com/hakavlad/nohang

Last Updated: 2021-03-18 07:38
Сложный обработчик нехватки памяти


nohang-git  AUR -  # Сложный обработчик нехватки памяти

https://aur.archlinux.org/packages/nohang-git/
https://aur.archlinux.org/nohang-git.git 
https://github.com/hakavlad/nohang

Last Updated: 2020-07-04 12:10
Сложный обработчик нехватки памяти

----------------------------------

ananicy-git  AUR  -  #  Ananicy - еще один автоматический демон с поддержкой правил сообщества
https://aur.archlinux.org/packages/ananicy-git/
https://aur.archlinux.org/ananicy-git.git 
https://github.com/Nefelim4ag/Ananicy.git


ananicy  AUR  -  #  Еще один демон auto nice с поддержкой правил сообщества
https://aur.archlinux.org/packages/ananicy/
https://aur.archlinux.org/ananicy.git 
https://github.com/Nefelim4ag/Ananicy.git

-----------------------------------

https://aur.archlinux.org/packages/?O=0&SeB=nd&K=gtkhash-&outdated=&SB=n&SO=a&PP=50&do_Search=Go


gtkhash  AUR  # Утилита GTK+ для вычисления дайджестов сообщений или контрольных сумм (A GTK+ utility for computing message digests or checksums)
https://aur.archlinux.org/packages/gtkhash/
https://aur.archlinux.org/gtkhash.git
https://github.com/tristanheaven/gtkhash
Last Updated:   2020-11-13 18:55


gtkhash-thunar  AUR  # Утилита GTK+ для вычисления дайджестов сообщений или контрольных сумм (плагин Thunar filemanager) 
https://aur.archlinux.org/packages/gtkhash-thunar/
https://aur.archlinux.org/gtkhash.git 
https://github.com/tristanheaven/gtkhash
Last Updated:   2020-11-13 18:55

gtkhash-thunar-git  AUR  # Утилита GTK+ для вычисления дайджестов сообщений или контрольных сумм (версия разработки). - Плагин Thunar filemanager
gtkhash-git
https://aur.archlinux.org/packages/gtkhash-thunar-git/
https://aur.archlinux.org/gtkhash-git.git
http://gtkhash.sourceforge.net/
Last Updated:   2015-07-08 03:24

==> Проверка зависимостей для сборки...
==> Установка недостающих зависимостей...
[sudo] пароль для alex: 
разрешение зависимостей...
проверка конфликтов...

Пакеты (2) cinnamon-desktop-4.8.1-1  nemo-4.8.5-1

Будет загружено:  1,39 MiB
Будет установлено:  6,67 MiB

==> ОШИБКА: Произошел сбой в build().
    Прерывание...
makepkg -s  44,63s user 3,79s system 77% cpu 1:02,59 total


GtkHash — простая графическая утилита для расчета различных контрольных сумм (хэш-функций) для файлов.

GtkHash-это настольная утилита для вычисления дайджестов сообщений или контрольных сумм. Поддерживаются самые известные хэш-функции, включая MD5, SHA1, SHA2 (SHA256/SHA512), SHA3 и BLAKE 2.

Он разработан как простая в использовании графическая альтернатива инструментам командной строки, таким как md5sum.

Особенности:

Поддержка проверки файлов контрольной суммы из sfv, sha256sum и т. Д.
Ключевое хеширование (HMAC)
Параллельное/многопоточное вычисление хэша
Удаленный доступ к файлам с помощью GIO/GVfs
Интеграция с файловым менеджером
Маленький и быстрый

GtkHash-это свободное программное обеспечение: вы можете распространять его и/или изменять в соответствии с условиями GNU General Public License, опубликованной Фондом свободного программного обеспечения, либо версией 2 Лицензии, либо (по вашему выбору) любой более поздней версией.

-----------------------------------

=====================================

vim-colorsamplerpack  -  # Различные цветовые схемы для vim
https://aur.archlinux.org/packages/vim-colorsamplerpack/
https://aur.archlinux.org/vim-colorsamplerpack.git
http://www.vim.org/scripts/script.php?script_id=625

vim-doxygentoolkit  -  # Этот скрипт упрощает документацию doxygen на C / C ++
https://aur.archlinux.org/packages/vim-doxygentoolkit/
https://aur.archlinux.org/vim-doxygentoolkit.git 
http://www.vim.org/scripts/script.php?script_id=987


vim-guicolorscheme  -  # Автоматическое преобразование цветовых схем только для графического интерфейса в схемы цветовых терминалов 88/256
https://aur.archlinux.org/packages/vim-guicolorscheme/
https://aur.archlinux.org/vim-guicolorscheme.git
http://www.vim.org/scripts/script.php?script_id=1809

vim-jellybeans  -  # Яркая, темная цветовая гамма, вдохновленная ir_black и сумерками
https://aur.archlinux.org/packages/vim-jellybeans/
https://aur.archlinux.org/vim-jellybeans.git
https://github.com/nanotech/jellybeans.vim
https://aur.archlinux.org/packages/vim-jellybeans-git/
https://aur.archlinux.org/vim-jellybeans-git.git
https://github.com/nanotech/jellybeans.vim

vim-minibufexpl  -  # Элегантный обозреватель буферов для vim
https://aur.archlinux.org/packages/vim-minibufexpl/
https://aur.archlinux.org/vim-minibufexpl.git 
http://fholgado.com/minibufexpl

vim-omnicppcomplete  -  # vim c ++ завершение omnifunc с базой данных ctags
https://aur.archlinux.org/packages/vim-omnicppcomplete/
https://aur.archlinux.org/vim-omnicppcomplete.git 
http://www.vim.org/scripts/script.php?script_id=1520

vim-project  -  # Организовывать и перемещаться по проектам файлов (например, в проводнике ide / buffer)
https://aur.archlinux.org/packages/vim-project/
https://aur.archlinux.org/vim-project.git
http://www.vim.org/scripts/script.php?script_id=69

vim-rails  -  # Плагин ViM для усовершенствованной разработки приложений Ruby on Rails
https://aur.archlinux.org/packages/vim-rails/
https://aur.archlinux.org/vim-rails.git 
http://www.vim.org/scripts/script.php?script_id=1567

vim-taglist  -  # Плагин браузера с исходным кодом для vim
https://aur.archlinux.org/packages/vim-taglist/
https://aur.archlinux.org/vim-taglist.git 
http://vim-taglist.sourceforge.net

vim-vcscommand  -  # Плагин интеграции системы контроля версий vim
https://aur.archlinux.org/packages/vim-vcscommand/
https://aur.archlinux.org/vim-vcscommand.git
http://www.vim.org/scripts/script.php?script_id=90

vim-workspace  -  # Плагин vim workspace manager для управления группами файлов
https://aur.archlinux.org/packages/vim-workspace/
https://aur.archlinux.org/vim-workspace.git 
http://www.vim.org/scripts/script.php?script_id=1410


======================================

zip-natspec  -  # Создает PKZIP-совместимые файлы .zip для нелатинских имен файлов с использованием патча libnatspec от AltLinux
https://aur.archlinux.org/packages/zip-natspec/
https://aur.archlinux.org/zip-natspec.git 
http://www.info-zip.org/pub/infozip/Zip.html
Последнее обновление: 2017-05-24 16:27

unzip-natspec  -  # Распаковывает архивы .zip с нелатинскими именами файлов, используя патч libnatspec от AltLinux
https://aur.archlinux.org/packages/unzip-natspec/
https://aur.archlinux.org/unzip-natspec.git 
http://www.info-zip.org/
Последнее обновление: 2015-11-04 15:12

#p7zip-natspec  -  # Файловый архиватор командной строки с высокой степенью сжатия, основанный на патче libnatspec из ubuntu zip-i18n PPA (https://launchpad.net/~frol/+archive/zip-i18n)
https://aur.archlinux.org/packages/p7zip-natspec/
https://aur.archlinux.org/p7zip-natspec.git
http://p7zip.sourceforge.net/
Последнее обновление: 2020-06-30 21:13

libnatspec  -  # Набор функций для запроса различных кодировок и локалей для хост-системы и для другой системы
https://aur.archlinux.org/packages/libnatspec/
https://aur.archlinux.org/libnatspec.git 
http://sourceforge.net/projects/natspec/
Последнее обновление: 2015-10-15 17:48

====================================

freshplayerplugin  -  # PPAPI-host Адаптер NPAPI-plugin (Recommended)
https://aur.archlinux.org/packages/freshplayerplugin/
https://aur.archlinux.org/freshplayerplugin.git 
https://github.com/i-rinat/freshplayerplugin

=> Установка недостающих зависимостей...
[sudo] пароль для alex: 
ошибка: не найдена цель: pepper-flash
==> ОШИБКА: pacman: не удалось установить недостающие зависимости.
==> Недостающие зависимости:
  -> pepper-flash
==> Проверка зависимостей для сборки...
==> Установка недостающих зависимостей...
разрешение зависимостей...
проверка конфликтов...

Пакеты (1) ragel-6.10-3

Будет загружено:  0,56 MiB
Будет установлено:  2,18 MiB

sudo pacman -S ragel --noconfirm  # Компилирует конечные автоматы из обычных языков в исполняемый код C, C ++, Objective-C или D

ragel  -  # Компилирует конечные автоматы из обычных языков в исполняемый код C, C ++, Objective-C или D
https://archlinux.org/packages/community/x86_64/ragel/
http://www.complang.org/ragel/
Последнее обновление: 2020-05-25 15:33 UTC

yay -S pepper-flash --noconfirm  # Adobe Flash Player PPAPI

pepper-flash  AUR  # Adobe Flash Player PPAPI
https://aur.archlinux.org/packages/pepper-flash/
https://aur.archlinux.org/flashplugin.git
https://get.adobe.com/flashplayer/
Last Updated: 2021-03-07 00:02


freshplayerplugin-git  -  # PPAPI-host Адаптер NPAPI-plugin
https://aur.archlinux.org/packages/freshplayerplugin-git/
https://aur.archlinux.org/freshplayerplugin-git.git 
https://github.com/i-rinat/freshplayerplugin

==> Недостающие зависимости:
  -> pepper-flash
==> Проверка зависимостей для сборки...
==> ОШИБКА: Не удалось разрешить все зависимости.


PPAPI-host Адаптер NPAPI-plugin.

Как вы знаете, Adobe приостановила дальнейшую разработку плагина Flash player для GNU / Linux. Последняя доступная в виде подключаемого модуля NPAPI версии 11.2 будет получать обновления безопасности в течение пяти лет (с момента его выпуска 4 мая 2012 г.), но дальнейшая разработка прекращена. К счастью или нет, новые версии для Linux все еще доступны как часть браузера Chrome, где Flash поставляется в виде подключаемого модуля PPAPI. PPAPI или Pepper Plugin API - это интерфейс, продвигаемый командой Chromium / Chrome для плагинов браузера. Это вдохновленный NPAPI, но существенно отличающийся API, в котором есть все мыслимые функциональные плагины, которые могут понадобиться. Двумерная графика, OpenGL ES, рендеринг шрифтов, доступ к сети, аудио и так далее. Он огромен, есть 111 групп функций, называемых интерфейсами, которые сегодня браузер Chromium предлагает плагинам. Хотя спецификации еще не окончательные, появляются новые версии интерфейса, некоторые старые удаляются; Темпы изменений значительно замедлились.

По разным причинам разработчики Firefox сейчас не заинтересованы во внедрении PPAPI в Firefox. Однако это не означает, что это невозможно.

Основная цель этого проекта - заставить PPAPI (Pepper) Flash player работать в Firefox. Это можно сделать двумя способами. Первый - реализовать полный интерфейс PPAPI в самом Firefox. Другой - реализовать оболочку, своего рода адаптер, который будет выглядеть как плагин браузера для PPAPI и выглядеть как плагин NPAPI для браузера.

Первый подход требует глубоких знаний внутреннего устройства Firefox и, более того, дополнительных усилий, чтобы сделать код популярным. Поддержание набора исправлений не выглядит хорошей идеей. Второй подход позволяет сосредоточиться только на двух API. Да, один из них большой, но все же понятный. Для проекта будет использован второй способ. Это принесет пользу и другим браузерам, а не только Firefox.

-----------------------------------------




AUR 

yay -S artwiz-fonts --noconfirm
 -> Невозможно найти все требуемые пакеты:
  xorg-font-utils (требуется пакету: artwiz-fonts)
yay -S artwiz-fonts --noconfirm  6,89s user 0,45s system 106% cpu 6,912 total


предупреждение: ttf-clear-sans-1.00-3 не устарел -- переустанавливается
разрешение зависимостей...
yay -S powerline-fonts-git --noconfirm
:: Проверка конфликтов...
:: Проверка внутренних конфликтов...
 -> 
Обнаружены конфликты пакетов:
 -> Установка powerline-fonts-git приведёт к удалению: powerline-fonts, ttf-hack
конфликты пакетов не могут быть разрешены опцией noconfirm, прерывание
yay -S powerline-fonts-git --noconfirm  7,06s user 0,47s system 111% cpu 6,734 total
yay -S artwiz-fonts --noconfirm
 -> Невозможно найти все требуемые пакеты:
  xorg-font-utils (требуется пакету: artwiz-fonts)
yay -S artwiz-fonts --noconfirm  7,08s user 0,53s system 106% cpu 7,127 total

yay -S ttf-droid-sans-mono-slashed-powerline-git --noconfirm 
 -> Невозможно найти все требуемые пакеты:
  xorg-font-utils (требуется пакету: ttf-droid-sans-mono-slashed-powerline-git)
yay -S ttf-droid-sans-mono-slashed-powerline-git --noconfirm  7,23s user 0,40s system 100% cpu 7,563 total

yay -S ttf-dejavu-sans-mono-powerline-git --noconfirm 
 -> Невозможно найти все требуемые пакеты:
  xorg-font-utils (требуется пакету: ttf-dejavu-sans-mono-powerline-git)
yay -S ttf-dejavu-sans-mono-powerline-git --noconfirm  7,24s user 0,38s system 101% cpu 7,525 total

==> ОШИБКА: Ошибка при создании рабочей копии репозитория 'material-design-icons' (git)
    Прерывание...
ошибка сборки: ttf-material-icons-git
yay -S ttf-material-icons-git --noconfirm  34,57s user 9,60s system 81% cpu 53,960 total

yay -S nerd-fonts-hack --noconfirm 
:: Проверка конфликтов...
:: Проверка внутренних конфликтов...
[Aur:1]  nerd-fonts-hack-2.1.0-3

ошибка клонирования nerd-fonts-hack: 
yay -S nerd-fonts-hack --noconfirm  

##########################################
есть в системе


mobile-broadband-provider-info - # Демон сетевого управления (информация о провайдере мобильного широкополосного доступа)
https://www.archlinux.org/packages/extra/any/mobile-broadband-provider-info/

gptfdisk - # Инструмент для создания разделов в текстовом режиме, который работает с дисками с таблицей разделов GUID (GPT) 
https://www.archlinux.org/packages/extra/x86_64/gptfdisk/

groff - # Система форматирования текста GNU troff
https://www.archlinux.org/packages/core/x86_64/groff/

fuse2 - # Библиотека, позволяющая реализовать файловую систему в программе пользовательского пространства
https://www.archlinux.org/packages/extra/x86_64/fuse2/

fuse3 - # Библиотека, позволяющая реализовать файловую систему в программе пользовательского пространства
https://www.archlinux.org/packages/extra/x86_64/fuse3/



##############################

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

##############################

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

#############################

clear
echo -e "${MAGENTA}
<<< Установка дополнительного программного обеспечения для создания, изменения - пакетов, и дальнейшей установке их в  систему Archlinux >>> ${NC}"
# Installing additional software to create, modify, and install packages in the Archlinux system

echo ""
echo -e "${GREEN}==> ${NC}Установить Debtap для элементарной (базовой) конвертации (преобразования) *.deb пакетов в *.pkg.tar.xz(-any.pkg.tar.zst), и дальнейшей установке в Archlinux?"
# Install Deb tar to convert *. deb packages to *.pkg.tar.xz(-any.pkg.tar.zcf), and then install them in the system?
echo -e "${MAGENTA}=> ${BOLD}Debtap - это Скрипт для преобразования пакетов .deb в пакеты Arch Linux, ориентированный на точность. Не используйте его для преобразования пакетов, которые уже существуют в официальных репозиториях (Arch Based Distribution), или могут быть собраны из AUR! (https://github.com/helixarch/debtap) ${NC}"
echo -e "${CYAN}:: ${NC}Он работает аналогично с alien (который конвертирует пакеты .deb в пакеты .rpm и наоборот), но, в отличие от alien, он ориентирован на точность преобразования, пытаясь перевести имена пакетов Debian / Ubuntu в правильные пакеты Arch Linux, и сохранить их в полях зависимостей метаданных .PKGINFO в окончательном пакете..."
echo -e "${CYAN}:: ${NC}Установка debtap проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/debtap.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/debtap), собирается и устанавливается."
echo -e "${YELLOW}=> Важно: ${NC}Перед установкой (преобразованных) пакетов - ВЫПОЛНИТЕ резервное копирование пользовательских данных /пространства (разделов системы)-(возможность повреждения вашей системы)!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_deb  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_deb" =~ [^10] ]]
do
    :
done
if [[ $i_deb == 0 ]]; then
echo ""  
echo " Установка debtap (преобразование пакетов .deb) пропущена "
elif [[ $i_deb == 1 ]]; then
  echo ""
  echo " Установка скрипта debtap (для преобразования пакетов .deb) "
##### debtap ###### 
# yay -S debtap --noconfirm  # Сценарий для преобразования пакетов .deb в пакеты Arch Linux, ориентированный на точность. Не используйте его для преобразования пакетов, которые уже существуют в официальных репозиториях или могут быть собраны из AUR!
git clone https://aur.archlinux.org/debtap.git  
cd debtap
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf debtap
rm -Rf debtap   # удаляем директорию сборки
echo ""
echo " Настройка перед использованием: (Вы делаете это с привилегиями root) "
echo " Выполняется синхронизация репозиториев Arch'a (обновим pkgfile и базу данных debtap), и доустановка недостающих компонентов (деталей) "
sudo debtap -u
# sudo debtap -U  # сделаем первый запуск скрипта
echo ""
echo " Сборка и установка debtap выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
sleep 02
# ---------------------------
# Доступные параметры debtap:
#    -h --help Распечатать справку
#    -u --update Обновить базу данных долгового соглашения
#    -q --quiet Пропустить все вопросы, кроме редактирования файла (ов) метаданных
#    -Q --Quiet Пропустить все вопросы (не рекомендуется)
#    -s - -pseudo Создать псевдо-64-битный пакет из 32-битного пакета .deb
#    -w --wipeout Удалить версии из всех зависимостей, конфликтов и т. д.
#    -p --pkgbuild Дополнительно создать файл PKGBUILD
#    -P --Pkgbuild Создать PKGBUILD только файл
#    -v --version Версия для печати
# -----------------------------
# Команда по работе со скриптом debtap
# Конвертировать .deb пакеты:
# debtap (имя пакета).deb  # debtap package_name.deb
# Утилита задает вопрос о желаемом имени пакета, о его лицензии. Дальше распакует пакет, соберет информацию, сформирует структуру и предложит внести правки в PKGINFO и INSTALL, от чего можно и отказаться. После этого будет сгенерирован пакет для арча, который ставится обычным образом.
# Посмотрим на файлы, что лежат в папке сборки: 
# ls
# Установка программы (пакета):
# sudo pacman -U (имя пакета).pkg.tar.xz  # sudo pacman -U package_name.pkg
# Не рекомендуется (возможно, опасно)
# Этот метод пытается установить пакет, используя формат упаковки debian на Arch, который не рекомендуется из-за возможной опасности повреждения вашей установки!
# --------------------------------

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить утилиту Alien (alien-pkg-convert)?"
# Install the Alien utility (alien-pkg-convert)?
echo -e "${MAGENTA}=> ${BOLD}Alien - это программа, конвертирующая файлы в форматы rpm, dpkg, stampede slp и slackware tgz. Если вы хотите использовать пакет из другого дистрибутива, чем тот, который вы установили в своей системе, вы можете использовать alien, чтобы преобразовать его в предпочтительный формат пакета и потом установить. (https://joeyh.name/code/alien/) ${NC}"
echo -e "${CYAN}:: ${NC}Имейте в виду, что если эти последние типы преобразований выполнены, сгенерированные пакеты могут иметь неверную информацию о зависимости...." 
echo -e "${CYAN}:: ${NC}Установка alien-pkg-convert проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/alien_package_converter.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/alien_package_converter/), собирается и устанавливается."
echo -e "${YELLOW}=> Важно: ${NC}Перед установкой (преобразованных) пакетов - ВЫПОЛНИТЕ резервное копирование пользовательских данных /пространства (разделов системы)-(возможность повреждения вашей системы)!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_alien  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_alien" =~ [^10] ]]
do
    :
done
if [[ $i_alien == 0 ]]; then
echo ""  
echo " Установка alien-pkg-convert пропущена "
elif [[ $i_alien == 1 ]]; then
  echo ""
  echo " Установка alien-pkg-convert "
##### alien-pkg-convert ###### 
debhelper  # https://aur.archlinux.org/debhelper.git
# yay -S alien_package_converter --noconfirm  # Программа, которая конвертирует файлы между форматами rpm, dpkg, stampede slp и slackware tgz...
git clone https://aur.archlinux.org/alien_package_converter.git  
cd alien_package_converter
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf alien_package_converter
rm -Rf alien_package_converter   # удаляем директорию сборки
echo ""
echo " Сборка и установка alien-pkg-convert выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
# ------------------------------------
# Последнее обновление: 2020-08-06 00:03
# https://aur.archlinux.org/packages/alien_package_converter/
# https://aur.archlinux.org/alien_package_converter.git
# https://sourceforge.net/projects/alien-pkg-convert/
# https://github.com/mildred/alien
# ------------------------------------

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить утилиту (пакет) dpkg или (пакет) dpkg-git - из AUR ?"
# Install the dpkg utility (package) or dpkg-git (package) from AUR ?
echo -e "${MAGENTA}=> ${BOLD}Dpkg - это инструменты (команда) для обработки пакетов Debian в системе. Если у вас есть .deb-пакеты, именно dpkg позволяет устанавливать или анализировать их содержимое. (https://www.archlinux.org/packages/community/x86_64/dpkg/) ${NC}"
echo -e "${CYAN}:: ${NC}Имейте в виду, что иногда dpkg по той или иной причине не может установить пакет и возвращает ошибку; если пользователь даёт указание проигнорировать эту ошибку, будет выдано лишь предупреждение; для этого существуют различные опции..." 
echo -e "${MAGENTA}=> ${BOLD}Dpkg-git - это инструменты (команда) предоставляет функции для обработки архитектур Debian, подстановочных знаков и отображения триплетов GNU и обратно. Если у вас есть .deb-пакеты, именно dpkg позволяет устанавливать или анализировать их содержимое. (https://aur.archlinux.org/packages/dpkg-git/) ${NC}"
echo -e "${CYAN}:: ${NC}Установка Dpkg-git проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/dpkg-git.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/dpkg-git/), собирается и устанавливается."
echo -e "${YELLOW}=> Важно: ${NC}Перед установкой .deb пакетов - ВЫПОЛНИТЕ резервное копирование пользовательских данных /пространства (разделов системы)-(возможность повреждения вашей системы)!"
echo -e "${YELLOW}=> Важно: ${NC}Пакеты dpkg и dpkg-git - Конфликтуют (установить их одновременно НЕЛЬЗЯ)!"
echo " Будьте внимательны! Процесс установки, после выбранного вами варианта был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Установить Dpkg (community),     2 - Установить Dpkg-git - из AUR,     

    0 - НЕТ - Пропустить действие: " t_deb  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_deb" =~ [^120] ]]
do
    :
done
if [[ $t_deb == 0 ]]; then
echo ""  
echo " Установка утилит (пакетов) пропущена "
elif [[ $t_deb == 1 ]]; then
  echo ""
  echo " Установка пакета Dpkg (community) "
sudo pacman -S dpkg --noconfirm  # Инструменты диспетчера пакетов Debian (Последнее обновление: 2020-10-13)
echo " Установка пакета dpkg выполнена "
elif [[ $t_deb == 2 ]]; then
  echo ""
  echo " Установка Dpkg-git - из AUR "
##### dpkg-git ###### 
# yay -S dpkg-git --noconfirm  # Система управления пакетами Debian (Последнее обновление: 2019-01-30)
git clone https://aur.archlinux.org/dpkg-git.git  
cd dpkg-git  
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf dpkg-git
rm -Rf dpkg-git   # удаляем директорию сборки
echo ""
echo " Сборка и установка dpkg-git выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
# ------------------------------------
# Последнее обновление dpkg: 2020-10-13 16:31 UTC
# https://www.archlinux.org/packages/community/x86_64/dpkg/
# Последнее обновление dpkg-git: 2019-01-30 18:50
# https://aur.archlinux.org/packages/dpkg-git/
# https://aur.archlinux.org/dpkg-git.git
# https://debian-handbook.info/browse/ru-RU/stable/sect.manipulating-packages-with-dpkg.html
# ------------------------------------
## Команда по работе с dpkg
# Установите пакет debian с помощью dpkg:
# dpkg -i package.deb  # какой бы пакет не был  (sudo dpkg -i package_name.deb)
# Не рекомендуется (возможно, опасно)
# Этот метод пытается установить пакет, используя формат упаковки debian на Arch, который не рекомендуется из-за возможной опасности повреждения вашей установки!
# --------------------------------

+++++++++++++========================+++++++++++++++++

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



sudo pacman -S engrampa --noconfirm  # Манипулятор архивов для MATE
sudo pacman -S galculator-gtk2 --noconfirm  # Научный калькулятор на основе GTK + (версия GTK2)
sudo pacman -S gnome-calculator --noconfirm  # Научный калькулятор GNOME
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 
sudo pacman -S  --noconfirm  # 


sudo pacman -S gnome-icon-theme --noconfirm  # Тема значков GNOME
sudo pacman -S xcursor-simpleandsoft --noconfirm  # Простая и мягкая тема курсора X
sudo pacman -S xcursor-vanilla-dmz-aa --noconfirm  # Тема курсора Vanilla DMZ AA
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




fwbuilder - Community - Объектно-ориентированный графический интерфейс и набор компиляторов для различных платформ межсетевых экранов
https://www.archlinux.org/packages/community/x86_64/fwbuilder/
     
Модульная утилита для создания образов initramfs

sudo pacman -S mkinitcpio mkinitcpio-archiso mkinitcpio-busybox mkinitcpio-nfs-utils --noconfirm 

sudo pacman -S mkinitcpio --noconfirm # Модульная утилита для создания образов initramfs
sudo pacman -S mkinitcpio-archiso --noconfirm # Хуки и скрипты mkinitcpio для archiso
sudo pacman -S mkinitcpio-busybox --noconfirm # Базовые инструменты initramfs
sudo pacman -S mkinitcpio-nfs-utils --noconfirm # Инструменты ipconfig и nfsmount для поддержки корня NFS в mkinitcpio
sudo pacman -S  --noconfirm # 
sudo pacman -S  --noconfirm #
sudo pacman -S  --noconfirm # 


yay -S mkinitcpio-openswap --noconfirm  # mkinitcpio, чтобы открыть своп во время загрузки
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
yay -S  --noconfirm  #
########################################


clear
echo -e "${MAGENTA}
  <<< Установка дополнительного программного обеспечения (пакетов) в Archlinux >>> ${NC}"
# Installing additional software (packages) in Archlinux

echo ""
echo -e "${GREEN}==> ${BOLD}Установить дополнительные рекомендованные программы (пакеты)? ${NC}"
#echo -e "${BLUE}:: ${NC}Установить дополнительные рекомендованные программы (пакеты)?"
#echo 'Установить дополнительные рекомендованные программы (пакеты)?'
# Install additional recommended programs (packages)?
echo -e "${MAGENTA}=> ${NC}Список утилит (пакетов) для установки: - ()."
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo -e "${YELLOW}==> ${NC}Установка будет производится сразу всех утилит (пакетов) - (без выбора)" 
echo "" 
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " t_package  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_package" =~ [^10] ]]
do
    :
done 
if [[ $t_package == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $t_package == 1 ]]; then
  echo ""  
  echo " Установка дополнительного программного обеспечения (пакетов) "
#sudo pacman -S  --noconfirm  





echo ""   
echo " Установка утилит (пакетов) выполнена "
fi


##############################

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

##############################

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

#############################


refind-efi-bin  AUR # Вилка REFIt UEFI Boot Manager Рода Смита - предварительно скомпилированный двоичный файл - построенный с использованием библиотек GNU-EFIaur
https://aur.archlinux.org/packages/refind-efi-bin/
https://aur.archlinux.org/refind-efi-bin.git 
http://www.rodsbooks.com/refind/index.html
Last Updated: 2021-03-21 09:43

=========================
archiso  # Инструменты для создания Arch Linux live и установки образов iso -
##############################



clear
echo -e "${MAGENTA}
  <<< Установка дополнительных утилит для восстановления данных с поврежденного жесткого диска (Если Вы обнаружите, что возникли ошибоки чтения диска, и начали сыпаться ошибки на консоль и в лог). >>> ${NC}"
echo ""
echo -e "${GREEN}==> ${NC}Установить GNU Ddrescue (ddrescue) и GUI интерфейс упрощающий использование ddrescue (ddrescue-gui) из AUR?"
# Install GNU ddrescue (ddrescue) and GUI interface to simplify the use of ddrescue (ddrescue-gui) from AUR?
echo -e "${MAGENTA}:: ${BOLD}GNU Ddrescue - это инструмент для восстановления данных. Он копирует данные из одного файла или блочного устройства (жесткого диска, компакт-диска и т.д.). В другой, пытаясь сначала спасти хорошие части в случае ошибок чтения. ${NC}"
echo " Основная операция ddrescue полностью автоматическая. То есть вам не нужно ждать ошибки, останавливать программу, перезапускать ее с новой позиции и т.д.... " 
echo " Ddrescue не записывает нули в выходные данные, когда обнаруживает поврежденные секторы во входных данных, и не обрезает выходной файл, если об этом не просят. Таким образом, каждый раз, когда вы запускаете его в одном и том же выходном файле, он пытается заполнить пробелы, не стирая уже восстановленные данные. "
echo -e "${YELLOW}==> Примечание: ${NC}GNU Ddrescue не является производной от dd и никак не связана с dd, за исключением того, что обе могут использоваться для копирования данных с одного устройства на другое. Разница в том, что ddrescue использует сложный алгоритм для копирования данных с неисправных дисков, что наносит им как можно меньше дополнительного ущерба."
echo -e "${CYAN}:: ${NC}Установка Ddrescue (ddrescue) проходит из 'Официальных репозиториев Arch Linux' - (Не AUR). Кроме Ddrescue GUI пакета (ddrescue-gui), его установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/ddrescue-gui/) - собирается и устанавливается. "
echo -e "${CYAN}==> Важно! ${NC}В сценарии (скрипте) представлены несколько вариантов установки: " 
echo " Установка Ddrescue (консольный вариант) без дополнений GUI, и второй вариант Ddrescue + GUI дополнения (пакет) (ddrescue-gui). "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Установить Ddrescue,     2 - Установить Ddrescue + GUI,     

    0 - НЕТ - Пропустить установку: " i_ddrescue  # sends right after the keypress; # отправляет сразу после нажатия клавиши    
    echo ''
    [[ "$i_ddrescue" =~ [^120] ]]
do
    :
done 
if [[ $i_ddrescue == 0 ]]; then 
echo ""   
echo " Установка пропущена "
elif [[ $i_ddrescue == 1 ]]; then
  echo ""    
  echo " Установка Ddrescue "
############ ddrescue ##########
sudo pacman -S ddrescue --noconfirm  # Инструмент восстановления данных GNU
echo ""
echo " Установка Ddrescue выполнена "
elif [[ $i_spotify == 2 ]]; then
  echo ""    
  echo " Установка Ddrescue + GUI "
############ ddrescue-gui ##########
# yay -S ddrescue-gui --noconfirm  # Запатентованный сервис потоковой передачи музыки
sudo pacman -S ddrescue --noconfirm  # Инструмент восстановления данных GNU
git clone https://aur.archlinux.org/ddrescue-gui.git  # Простой интерфейс с графическим интерфейсом, упрощающий использование ddrescue (инструмент для восстановления данных из командной строки)
cd ddrescue-gui
#makepkg -fsri
# makepkg -si
makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ddrescue-gui 
rm -Rf ddrescue-gui
echo ""
echo " Установка Ddrescue + GUI выполнена "
echo ""
echo -e "${BLUE}:: ${BOLD}Посмотрим идентификацию накопителей (name, label, size, fstype, model) ... ${NC}"
date
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'     # одновременно отображает дату и часовой пояс
echo ""
sudo lsblk -f
sudo lsblk -o name, label, size, fstype, model 
sudo findmnt -D  # Если вы не сможете определить ваши диски
echo ""
fi
#-------------------------
# Одна из самых сильных сторон ddrescue заключается в том, что она не зависит от интерфейса и поэтому может использоваться для любого типа устройств, поддерживаемых вашим ядром (ATA, SATA, SCSI, старые приводы MFM, гибкие диски или даже карты флэш-памяти, такие как SD).
# https://aur.archlinux.org/packages/ddrescue-gui/
# https://launchpad.net/ddrescue-gu
# https://www.gnu.org/software/ddrescue/
# https://www.gnu.org/software/ddrescue/manual/ddrescue_manual.html
# https://www.gnu.org/graphics/agnuhead.html
# http://rus-linux.net/MyLDP/admin/ddrescue.html
# https://www.k-max.name/linux/ddrescue-hdd-vosstanovlenie-and-examples/
# http://sysadminblog.sagrer.ru/stati-i-gajdy/linux/21-primer-vosstanovleniya-dannykh-s-pomoshchyu-gnu-ddrescue.html
# https://ru.wikipedia.org/wiki/Ddrescue
#---------------------------

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"


########## Python ###########
# sudo pacman -S python python2 python-anytree python-appdirs python-arrow python-asn1crypto python-atspi python-attrs python-bcrypt python-beaker python-beautifulsoup4 python-cachecontrol python-cffi python-cairo python-chardet python-colorama python-colour python-configobj python-contextlib2 python-cryptography python-cssselect python-d2to1 python-dateutil python-dbus python-dbus-common python-defusedxml python-distlib python-distro python-distutils-extra python-docopt python-entrypoints python-ewmh python-eyed3 python-future python-gevent python-gevent-websocket python-greenlet python-gobject python-html5lib python-httplib2 python-idna python-isodate python-isomd5sum python-jedi python-jeepney python-jinja python-keyring python-keyutils python-libarchive-c python-lxml python-lxml-docs python-magic python-mako python-markdown python-markupsafe python-maxminddb python-msgpack python-mutagen python-nose python-numpy python-olefile python-ordered-set python-packaging python-paramiko python-parso python-patiencediff python-pbr python-pep517 python-pillow python-pip python-pexpect python-ply python-powerline python-progress python-psutil python-ptyprocess python-pyasn1 python-pyasn1-modules python-pycountry python-pycparser python-pycups python-pycurl python-pycryptodome python-pyelftools python-pyfiglet python-pygments python-pyicu python-pynacl python-pyopenssl python-pyparsing python-pyphen python-pyqt5 python-pyqt5-sip python-pyquery python-pysmbc python-pysocks python-pysol_cards python-pyudev python-pywal python-pyxdg python-random2 python-requests python-resolvelib python-retrying python-rsa python-scipy python-secretstorage python-setproctitle python-setuptools python-shiboken2 python-sip python-six python-soupsieve python-sqlalchemy python-termcolor python-tlsh python-toml python-ujson python-unidecode python-urllib3 python-webencodings python-websockets websocket-client python-xapp python-yaml python-zope-event python-zope-interface --noconfirm  # python ; python2 ; python-pip (возможно присутствует)
# sudo pacman -S --noconfirm --needed python python2 python-anytree python-appdirs python-arrow python-asn1crypto python-atspi python-attrs python-bcrypt python-beaker python-beautifulsoup4 python-cachecontrol python-cffi python-cairo python-chardet python-colorama python-colour python-configobj python-contextlib2 python-cryptography python-cssselect python-d2to1 python-dateutil python-dbus python-dbus-common python-defusedxml python-distlib python-distro python-distutils-extra python-docopt python-entrypoints python-ewmh python-eyed3 python-future python-gevent python-gevent-websocket python-greenlet python-gobject python-html5lib python-httplib2 python-idna python-isodate python-isomd5sum python-jedi python-jeepney python-jinja python-keyring python-keyutils python-libarchive-c python-lxml python-lxml-docs python-magic python-mako python-markdown python-markupsafe python-maxminddb python-msgpack python-mutagen python-nose python-numpy python-olefile python-ordered-set python-packaging python-paramiko python-parso python-patiencediff python-pbr python-pep517 python-pillow python-pip python-pexpect python-ply python-powerline python-progress python-psutil python-ptyprocess python-pyasn1 python-pyasn1-modules python-pycountry python-pycparser python-pycups python-pycurl python-pycryptodome python-pyelftools python-pyfiglet python-pygments python-pyicu python-pynacl python-pyopenssl python-pyparsing python-pyphen python-pyqt5 python-pyqt5-sip python-pyquery python-pysmbc python-pysocks python-pysol_cards python-pyudev python-pywal python-pyxdg python-random2 python-requests python-resolvelib python-retrying python-rsa python-scipy python-secretstorage python-setproctitle python-setuptools python-shiboken2 python-sip python-six python-soupsieve python-sqlalchemy python-termcolor python-tlsh python-toml python-ujson python-unidecode python-urllib3 python-webencodings python-websockets websocket-client python-xapp python-yaml python-zope-event python-zope-interface
#####################
sudo pacman -S --noconfirm --needed python  # Новое поколение языка сценариев высокого уровня Python # возможно присутствует
# sudo pacman -S python --noconfirm  # Новое поколение языка сценариев высокого уровня Python
sudo pacman -S --noconfirm --needed python2  # Язык сценариев высокого уровня Python (Конфликты: python <3) # возможно присутствует
sudo pacman -S python-anytree --noconfirm  # Мощная и легкая древовидная структура данных Python
sudo pacman -S python-appdirs --noconfirm  # Небольшой модуль Python для определения соответствующих директорий для конкретной платформы, например «директории пользовательских данных».
sudo pacman -S python-arrow --noconfirm  # Лучшие даты и время для Python
sudo pacman -S python-asn1crypto --noconfirm  # Библиотека Python ASN.1 с упором на производительность и pythonic API
sudo pacman -S python-atspi --noconfirm  #  Привязки Python для D-Bus AT-SPI
sudo pacman -S python-attrs --noconfirm  # Атрибуты без шаблона
sudo pacman -S python-bcrypt --noconfirm  # Современное хеширование паролей для вашего программного обеспечения и ваших серверов
sudo pacman -S python-beaker --noconfirm  # Кэширование и сеансы промежуточного программного обеспечения WSGI для использования с веб-приложениями и автономными скриптами и приложениями Python
sudo pacman -S python-beautifulsoup4 --noconfirm  # Синтаксический анализатор HTML / XML на Python, предназначенный для быстрых проектов, таких как очистка экрана
sudo pacman -S python-cachecontrol --noconfirm  # httplib2 кеширование запросов
sudo pacman -S python-cffi --noconfirm  # Интерфейс внешних функций для Python, вызывающего код C
sudo pacman -S python-cairo --noconfirm  # Привязки Python для графической библиотеки cairo
sudo pacman -S python-chardet --noconfirm  # Модуль Python3 для автоматического определения кодировки символов
sudo pacman -S python-colorama --noconfirm  # Python API для кроссплатформенного цветного текста терминала
sudo pacman -S python-colour --noconfirm  # Библиотека манипуляций с цветовыми представлениями (RGB, HSL, web, ...)
sudo pacman -S python-configobj --noconfirm  # Простое, но мощное средство чтения и записи конфигурационных файлов для Python
sudo pacman -S python-contextlib2 --noconfirm  # Обратный перенос модуля contextlib стандартной библиотеки на более ранние версии Python
sudo pacman -S python-cryptography --noconfirm  # Пакет, предназначенный для предоставления криптографических рецептов и примитивов разработчикам Python
sudo pacman -S python-cssselect --noconfirm  # Библиотека Python3, которая анализирует селекторы CSS3 и переводит их в XPath 1.0
sudo pacman -S python-d2to1 --noconfirm  # Библиотека Python, которая позволяет использовать файлы setup.cfg, подобные distutils2, для метаданных пакета с помощью скрипта distribute / setuptools setup.py
sudo pacman -S python-dateutil --noconfirm  # Предоставляет мощные расширения для стандартного модуля datetime 
sudo pacman -S python-dbus --noconfirm  # Привязки Python для DBUS
sudo pacman -S python-dbus-common --noconfirm  # Общие файлы dbus-python, общие для python-dbus и python2-dbus
sudo pacman -S python-defusedxml --noconfirm  # Защита от XML-бомбы для модулей Python stdlib
sudo pacman -S python-distlib --noconfirm  # Низкоуровневые компоненты distutils2 / упаковка
sudo pacman -S python-distro --noconfirm  # API информации о платформе ОС Linux
sudo pacman -S python-distutils-extra --noconfirm  # Улучшения в системе сборки Python
sudo pacman -S python-docopt --noconfirm  # Пифонический парсер аргументов, который заставит вас улыбнуться
sudo pacman -S python-entrypoints --noconfirm  # Обнаружение и загрузка точек входа из установленных пакетов
sudo pacman -S python-ewmh --noconfirm  # Реализация Python подсказок Extended Window Manager на основе Xlib
sudo pacman -S python-eyed3 --noconfirm  # Модуль Python и программа для обработки информации о файлах mp3
sudo pacman -S python-future --noconfirm  # Чистая поддержка одного источника для Python 3 и 2
sudo pacman -S python-gevent --noconfirm  # Сетевая библиотека Python, которая использует greenlet и libev для простого и масштабируемого параллелизма
sudo pacman -S python-gevent-websocket --noconfirm  # Библиотека WebSocket для сетевой библиотеки gevent
sudo pacman -S python-greenlet --noconfirm  # Легкое параллельное программирование в процессе
sudo pacman -S python-gobject --noconfirm  # Привязки Python для GLib / GObject / GIO / GTK +
sudo pacman -S python-html5lib --noconfirm  # Парсер / токенизатор HTML Python на основе спецификации WHATWG HTML5
sudo pacman -S python-httplib2 --noconfirm  # Обширная клиентская библиотека HTTP, поддерживающая множество функций
sudo pacman -S python-idna --noconfirm  # Интернационализированные доменные имена в приложениях (IDNA)
sudo pacman -S python-isodate --noconfirm  # Синтаксический анализатор даты / времени / продолжительности и форматирование ISO 8601
sudo pacman -S --noconfirm --needed python-isomd5sum  # Привязки Python3 для isomd5sum # возможно присутствует
sudo pacman -S python-jedi --noconfirm  # Отличное автозаполнение для Python
sudo pacman -S python-jeepney --noconfirm  # Низкоуровневая оболочка протокола Python DBus на чистом уровне
sudo pacman -S python-jinja --noconfirm  # Простой питонический язык шаблонов, написанный на Python
sudo pacman -S python-keyring --noconfirm  # Безопасное хранение и доступ к вашим паролям
sudo pacman -S python-keyutils --noconfirm  # Набор привязок python для keyutils
sudo pacman -S python-libarchive-c --noconfirm  # Интерфейс Python для libarchive
sudo pacman -S python-lxml --noconfirm  # Связывание Python3 для библиотек libxml2 и libxslt (-S python-lxml --force # принудительная установка)
sudo pacman -S python-lxml-docs --noconfirm  # Связывание Python для библиотек libxml2 и libxslt (документы)
sudo pacman -S python-magic --noconfirm  # Привязки Python к волшебной библиотеке
sudo pacman -S python-mako --noconfirm  # Сверхбыстрый язык шаблонов, который заимствует лучшие идеи из существующих языков шаблонов
sudo pacman -S python-markdown --noconfirm  # Реализация Python Markdown Джона Грубера
sudo pacman -S python-markupsafe --noconfirm  # Реализует безопасную строку разметки XML / HTML / XHTML для Python
sudo pacman -S python-maxminddb --noconfirm  # Читатель для формата MaxMind DB
sudo pacman -S python-msgpack --noconfirm  # Реализация сериализатора MessagePack для Python
sudo pacman -S python-mutagen --noconfirm  # (mutagen) Средство чтения и записи тегов метаданных аудио (библиотека Python)
sudo pacman -S python-nose --noconfirm  # Расширение unittest на основе обнаружения
sudo pacman -S python-numpy --noconfirm  # Научные инструменты для Python
sudo pacman -S python-olefile --noconfirm  # Библиотека Python для анализа, чтения и записи файлов Microsoft OLE2 (ранее OleFileIO_PL)
sudo pacman -S python-ordered-set --noconfirm  # MutableSet, который запоминает свой порядок, так что каждая запись имеет индекс
sudo pacman -S python-packaging --noconfirm  # Основные утилиты для пакетов Python
sudo pacman -S python-paramiko --noconfirm  # Модуль Python, реализующий протокол SSH2
sudo pacman -S python-parso --noconfirm  # Синтаксический анализатор Python, поддерживающий восстановление ошибок и двусторонний синтаксический анализ для разных версий Python
sudo pacman -S python-patiencediff --noconfirm  # Patiencediff реализации Python и C
sudo pacman -S python-pbr --noconfirm  # Разумность сборки Python
sudo pacman -S python-pep517 --noconfirm  # Оболочки для сборки пакетов Python с использованием хуков PEP 517
sudo pacman -S python-pillow --noconfirm  # Вилка Python Imaging Library (PIL)
sudo pacman -S --noconfirm --needed python-pip  # Рекомендуемый PyPA инструмент для установки пакетов Python # возможно присутствует
sudo pacman -S python-pexpect --noconfirm  # Для управления и автоматизации приложений
sudo pacman -S python-ply --noconfirm  # Реализация инструментов парсинга lex и yacc
sudo pacman -S python-powerline --noconfirm  # Библиотека Python для Powerline
sudo pacman -S python-progress --noconfirm  # Простые в использовании индикаторы выполнения для Python
sudo pacman -S python-psutil --noconfirm  # Кросс-платформенный модуль процессов и системных утилит для Python
sudo pacman -S python-ptyprocess --noconfirm  # Запустить подпроцесс в псевдотерминале
sudo pacman -S python-pyasn1 --noconfirm  # Библиотека ASN.1 для Python 3
sudo pacman -S python-pyasn1-modules --noconfirm  # Коллекция модулей протоколов на основе ASN.1
sudo pacman -S python-pycountry --noconfirm  # Определения страны, подразделения, языка, валюты и алфавита ИСО и их переводы
sudo pacman -S python-pycparser --noconfirm  # Синтаксический анализатор C и генератор AST, написанные на Python
sudo pacman -S python-pycups --noconfirm  # Привязки Python для libcups
sudo pacman -S python-pycurl --noconfirm  # Интерфейс Python 3.x для libcurl
sudo pacman -S python-pycryptodome --noconfirm  # Коллекция криптографических алгоритмов и протоколов, реализованных для использования из Python 3
sudo pacman -S python-pyelftools --noconfirm  # Библиотека Python для анализа файлов ELF и отладочной информации DWARF
sudo pacman -S python-pyfiglet --noconfirm  # Реализация FIGlet на чистом питоне
sudo pacman -S python-pygments --noconfirm  # Подсветка синтаксиса Python
sudo pacman -S python-pyicu --noconfirm  # Связывание Python для ICU
sudo pacman -S python-pynacl --noconfirm  # Привязка Python к библиотеке сетей и криптографии (NaCl)
sudo pacman -S python-pyopenssl --noconfirm  # Модуль оболочки Python3 вокруг библиотеки OpenSSL
sudo pacman -S python-pyparsing --noconfirm  # Модуль общего синтаксического анализа для Python
sudo pacman -S python-pyphen --noconfirm  # Модуль Pure Python для переноса текста
sudo pacman -S python-pyqt5 --noconfirm  # Набор привязок Python для инструментария Qt5
sudo pacman -S python-pyqt5-sip --noconfirm  # Поддержка модуля sip для PyQt5
sudo pacman -S python-pyquery --noconfirm  # Библиотека для Python, похожая на jquery
sudo pacman -S python-pysmbc --noconfirm  # Привязки Python 3 для libsmbclient
sudo pacman -S python-pysocks --noconfirm  # SOCKS4, SOCKS5 или HTTP-прокси (вилка Anorov PySocks заменяет socksipy)
sudo pacman -S python-pysol_cards --noconfirm  # Карты Deal PySol FC
sudo pacman -S python-pyudev --noconfirm  # Привязки Python к libudev
sudo pacman -S python-pywal --noconfirm  # Создавайте и изменяйте цветовые схемы на лету
sudo pacman -S python-pyxdg --noconfirm  # Библиотека Python для доступа к стандартам freedesktop.org
sudo pacman -S python-random2 --noconfirm  # Python 3 совместимый порт случайного модуля Python 2
sudo pacman -S python-requests --noconfirm  # Python HTTP для людей
sudo pacman -S python-resolvelib --noconfirm  # Преобразуйте абстрактные зависимости в конкретные
sudo pacman -S python-retrying --noconfirm  # Библиотека перенастройки Python общего назначения
sudo pacman -S python-rsa --noconfirm  # Реализация RSA на чистом Python
sudo pacman -S python-scipy --noconfirm  # SciPy - это программное обеспечение с открытым исходным кодом для математики, естественных наук и инженерии
sudo pacman -S python-secretstorage --noconfirm  # Безопасно храните пароли и другие личные данные с помощью API SecretService DBus
sudo pacman -S python-setproctitle --noconfirm  # Позволяет процессу Python изменять название процесса
sudo pacman -S python-setuptools --noconfirm  # Легко загружайте, собирайте, устанавливайте, обновляйте и удаляйте пакеты Python
sudo pacman -S python-shiboken2 --noconfirm  # Создает привязки для библиотек C ++ с использованием исходного кода CPython
sudo pacman -S python-sip --noconfirm  # Привязки Python SIP4 для библиотек C и C ++ (python-sip4)
sudo pacman -S python-six --noconfirm  # Утилиты совместимости с Python 2 и 3
sudo pacman -S python-soupsieve --noconfirm  # Реализация селектора CSS4 для Beautiful Soup
sudo pacman -S python-sqlalchemy --noconfirm  # Набор инструментов Python SQL и объектно-реляционное сопоставление
sudo pacman -S python-termcolor --noconfirm  # Форматирование цвета ANSII для вывода в терминал
sudo pacman -S python-tlsh --noconfirm  # Библиотека нечеткого сопоставления, которая генерирует хеш-значение, которое можно использовать для сравнений схожести
sudo pacman -S python-toml --noconfirm  # Библиотека Python для анализа и создания TOML
sudo pacman -S python-ujson --noconfirm  # Сверхбыстрый кодировщик и декодер JSON для Python
sudo pacman -S python-unidecode --noconfirm  # ASCII транслитерации текста Unicode
sudo pacman -S python-urllib3 --noconfirm  # Библиотека HTTP с потокобезопасным пулом соединений и поддержкой публикации файлов
sudo pacman -S python-webencodings --noconfirm  # Это Python-реализация стандарта кодирования WHATWG
sudo pacman -S python-websockets --noconfirm  # Реализация протокола WebSocket на Python (RFC 6455)
sudo pacman -S python-websocket-client --noconfirm  # Клиентская библиотека WebSocket для Python
sudo pacman -S python-xapp --noconfirm  # Библиотека Python Xapp
sudo pacman -S python-yaml --noconfirm  # Привязки Python для YAML с использованием быстрой библиотеки libYAML
sudo pacman -S python-zope-event --noconfirm  # Предоставляет простую систему событий
sudo pacman -S python-zope-interface --noconfirm  # Интерфейсы Zope для Python 3.x
# sudo pacman -S  --noconfirm  # 
# sudo pacman -S  --noconfirm  # 
# sudo pacman -S  --noconfirm  # 
# sudo pacman -S --noconfirm --needed   # 
#############################


########## Python AUR ###########
yay -S python-basiciw --noconfirm  # Получение информации, такой как ESSID или качество сигнала, с беспроводных карт (модуль Python)
yay -S python-bencode.py --noconfirm  # Простой парсер бенкода (для Python 2, Python 3 и PyPy)
yay -S pythonqt --noconfirm  # Динамическая привязка Python для приложений Qt
yay -S python-coincurve --noconfirm  # Кросс-платформенные привязки Python CFFI для libsecp256k1
yay -S python-merkletools --noconfirm  # Инструменты Python для создания и проверки деревьев Меркла и доказательств
yay -S python-pyelliptic --noconfirm  # Оболочка Python OpenSSL для ECC (ECDSA, ECIES), AES, HMAC, Blowfish, ...
yay -S python-pyparted --noconfirm  # Модуль Python для GNU parted
yay -S python-pyqt4 --noconfirm  # Набор привязок Python 3.x для набора инструментов Qt
yay -S python-pywapi --noconfirm  # Обертка Python вокруг Yahoo! Погода, Weather.com и API NOAA
yay -S python-requests-cache --noconfirm  # Прозрачный постоянный кеш для библиотеки
yay -S python-sip-pyqt4 --noconfirm  # Привязки Python 3.x SIP для библиотек C и C ++ (версия PyQt4)
yay -S python-twitter --noconfirm  # Набор инструментов API и командной строки для Twitter (twitter.com)
########## Python2 AUR ###########
yay -S python2-imaging --noconfirm  # PIL. Предоставляет возможности обработки изображений для Python
# yay -S  --noconfirm  #
# yay -S  --noconfirm  #
# yay -S  --noconfirm  #
# yay -S  --noconfirm --needed  #
########## Python AUR (Биткойн) ###########
# yay -S python-base58 --noconfirm  # Биткойн-совместимая реализация Base58 и Base58Check
# yay -S python-bitcoinlib --noconfirm  # Библиотека Python3, обеспечивающая простой интерфейс для структур данных и протокола Биткойн
# yay -S  --noconfirm  #
###########################



###################################
###
########## Python AUR ###########
###
### python-basiciw    AUR  # Получение информации, такой как ESSID или качество сигнала, с беспроводных карт (модуль Python)
### https://aur.archlinux.org/packages/python-basiciw/
### https://aur.archlinux.org/python-basiciw.git
### https://github.com/enkore/basiciw/
###
### python-bencode.py    AUR  # Простой парсер бенкода (для Python 2, Python 3 и PyPy)
### https://aur.archlinux.org/packages/python-bencode.py/
### https://aur.archlinux.org/python-bencode.py.git 
### https://github.com/fuzeman/bencode.py
###
### pythonqt    AUR  # Динамическая привязка Python для приложений Qt
### https://aur.archlinux.org/packages/pythonqt/
### https://aur.archlinux.org/pythonqt.git
### http://pythonqt.sourceforge.net/
###
### python-coincurve   AUR  # Кросс-платформенные привязки Python CFFI для libsecp256k1
### https://aur.archlinux.org/packages/python-coincurve/
### https://aur.archlinux.org/python-coincurve.git
### https://github.com/ofek/coincurve
###
### python-merkletools   AUR  # Инструменты Python для создания и проверки деревьев Меркла и доказательств
### https://aur.archlinux.org/packages/python-merkletools/
### https://aur.archlinux.org/python-merkletools.git 
### https://github.com/Tierion/pymerkletools
###
### python-pyparted   AUR  # Модуль Python для GNU parted
### https://aur.archlinux.org/packages/python-pyparted/
### https://aur.archlinux.org/python-pyparted.git
### https://github.com/dcantrell/pyparted
###
### python-twitter   AUR  # Набор инструментов API и командной строки для Twitter (twitter.com)
### https://aur.archlinux.org/packages/python-twitter/
### https://aur.archlinux.org/python-twitter.git 
### http://pypi.python.org/pypi/twitter/
###
### python2-imaging  AUR  # PIL. Предоставляет возможности обработки изображений для Python
### https://aur.archlinux.org/packages/python2-imaging/
### https://aur.archlinux.org/python2-imaging.git 
### http://www.pythonware.com/products/pil/index.htm
###
### python-pyelliptic  AUR  # Оболочка Python OpenSSL для ECC (ECDSA, ECIES), AES, HMAC, Blowfish, ...
### https://aur.archlinux.org/packages/python-pyelliptic/
### https://aur.archlinux.org/python-pyelliptic.git
### https://github.com/radfish/pyelliptic
###
### python-pyqt4  AUR  # Набор привязок Python 3.x для набора инструментов Qt
### https://aur.archlinux.org/packages/python-pyqt4/
### https://aur.archlinux.org/pyqt4.git
### https://riverbankcomputing.com/software/pyqt/intro
###
### python-pywapi  AUR  # Обертка Python вокруг Yahoo! Погода, Weather.com и API NOAA
### https://aur.archlinux.org/packages/python-pywapi/
### https://aur.archlinux.org/python-pywapi.git
### https://launchpad.net/python-weather-api
###
### python-requests-cache  AUR  # Прозрачный постоянный кеш для библиотеки http://python-requests.org/ 
### https://aur.archlinux.org/packages/python-requests-cache/
### https://aur.archlinux.org/python-requests-cache.git
### https://github.com/reclosedev/requests-cache
###
### python-sip-pyqt4  AUR  # Привязки Python 3.x SIP для библиотек C и C ++ (версия PyQt4)
### https://aur.archlinux.org/packages/python-sip-pyqt4/
### https://aur.archlinux.org/python-sip-pyqt4.git
### https://www.riverbankcomputing.com/software/sip/intro
###
########## Биткойн ###########
###
### python-base58   AUR  # Биткойн-совместимая реализация Base58 и Base58Check
### https://aur.archlinux.org/packages/python-base58/
### https://aur.archlinux.org/python-base58.git 
### https://github.com/keis/base58
###
### python-bitcoinlib # Библиотека Python3, обеспечивающая простой интерфейс для структур данных и протокола Биткойн
### https://www.archlinux.org/packages/community/any/python-bitcoinlib/
### https://github.com/petertodd/python-bitcoinlib
###
###############################






### ПРОВЕРИТЬ ############


python2 2.7.18-1
python2-appdirs 1.4.4-1   # Небольшой модуль Python для определения соответствующих директорий для конкретной платформы, например «директории пользовательских данных»
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
python2-pillow 6.2.1-2  # Вилка Python Imaging Library (PIL)
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

python2 2.7.18-1
python2-pyxdg 0.26-6





































































