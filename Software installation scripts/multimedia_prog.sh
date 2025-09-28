#!/bin/bash
# loadkeys ru
# setfont cyr-sun16
# clear
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! ####

apptitle="Arch Linux Fast Install v2.5 LegasyBIOS - Version: 2025.06.16.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

MULTIMEDIA_PROG_LANG="russian"  # Installer default language (Язык установки по умолчанию)
ARCHMY4_LANG="russian"  # Installer default language (Язык установки по умолчанию)
script_path=$(readlink -f ${0%/*})

umask 0022 # Определение окончательных прав доступа
# Для суперпользователя (root) umask по умолчанию равна 0022

##################################################################

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

########################################
### Warning (Предупреждение)
_warning_banner() {
    echo -e "${YELLOW}
   ====================== ♥ Предупреждение ======================
${NC}
Цель сценария (скрипта) - это установка необходимого софта (пакетов) и запуск необходимых служб.
Смысл в том, что все изменения вы делаете предварительно в самом скрипте и получаете возможность быстрой установки утилит (пакетов), которые Вы решили установить (при условии, что Вы его изменили под себя, в противном случае скрипт установит софт (пакеты) прописанный изначально.
В процессе работы сценария (скрипта) Вам будут задаваться вопросы на установку той, или иной утилиты (пакета) - будьте внимательными! Устанавливаемый софт (пакеты) - скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. Так же присутствует софт (пакеты),  - устанавливаемый из пользовательского репозитория 'AUR'-'yay', собираются и устанавливаются. Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска необходимых служб. В любой ситуации выбор всегда за вами. Вы либо гуляете под дождем, либо просто под ним мокнете. ${RED}

  ***************************** ВНИМАНИЕ! *****************************
${NC}
Автор не несёт ответственности за любое нанесение вреда при использовании скрипта.
Вы используйте его на свой страх и риск, или изменяйте под свои личные нужды.
Будьте внимательны! Процесс установки софта (пакетов) устанавливаемого из пользовательского репозитория будет осуществляться через - 'AUR'-'yay' (здесь выбор всегда остаётся за вами - ставить или нет).
В данный момент сценарий (скрипта) находится в процессе доработки по прописанию устанавливаемого софта (пакетов), и небольшой корректировке (Воен. Внесение поправок в наводку орудий по результатам наблюдений с наблюдательных пунктов).

${BLUE}===> ******************************************************* ${NC}"
}
########################################

### Display banner (Дисплей баннер)
_warning_banner

sleep 9
#echo -e "${MAGENTA}==> ${BOLD}Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети. ${NC}"
#echo 'Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети.'
# If you have a wireless connection, launch nmtui and connect to the network.

echo ""
echo -e "${BLUE}:: ${NC}Установка и настройка начата в $(date +%T)"
#echo "Установка и настройка начата в $(date +%T)"
# Installation and configuration started in $(date +%T)

echo ""
echo -e "${GREEN}=> ${NC}Для проверки интернета можно пропинговать какой-либо сервис"
echo -e "${MAGENTA}==> ${BOLD}Если у Вас беспроводное соединение, запустите nmtui (Network Manager Text User Interface) и подключитесь к сети. ${NC}"
#echo 'Для проверки интернета можно пропинговать какой-либо сервис'
# To check the Internet, you can ping a service
ping -c2 archlinux.org  # Утилита ping - это очень простой инструмент для диагностики сети
#ping google.com -W 2 -c 1

echo -e "${CYAN}==> ${NC}Если пинг идёт едем дальше ... :)"
#echo 'Если пинг идёт едем дальше ... :)'
# If the ping goes we go further ... :)
sleep 03

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
###  sudo pacman -Sy
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
echo ""
echo " Обновление базы данных выполнено "
fi
sleep 01

clear
echo -e "${MAGENTA}
  <<< Установка Мультимедиа аудиоплееров, видео-проигрывателей, утилит для редактирования медиафайлов в Archlinux >>> ${NC}"
# Installation of Multimedia audio players, video players, utilities for editing media files in Archlinux
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить QMMP (qmmp) — Аудиоплеер?"
echo -e "${MAGENTA}:: ${BOLD}QMMP — простой аудиоплеер со стандартным набором возможностей. Поддерживает работу с плейлистами, эквалайзер, программная/системная регулировка громкости, поддержка модулей, обложек. Qmmp — бесплатный аудиоплеер с простым и удобным интерфейсом, где основные функции реализованы в модульной структуре, а внешне напоминает популярнейший проигрыватель Winamp или xmms. Каждый модуль программы доступен для управления, тем самым плеер полностью настраивается под себя, а при необходимости можно добавить и свои собственные модули. Также доступен альтернативный интерфейс (http://qmmp.ylsoftware.com/screenshots.php). Полное название программы — Qt-based Multimedia Player. Qmmp — написан с использованием библиотеки Qt (Qt5-Qt6). ${NC}"
echo " Домашняя страница: http://qmmp.ylsoftware.com/ ; (https://archlinux.org/packages/extra/x86_64/qmmp/). "
echo -e "${MAGENTA}:: ${BOLD}Основные возможности и особенности программы QMMP: Интерфейс программы аналогичен таким проигрывателям как WinAMP и XMMS. Альтернативный пользовательский интерфейс. Стандартное оформление. Поддержка большого количества аудио-форматов. Поддержка аудио-эффектов. Визуальные эффекты. Поддержка различных систем вывода звука (ALSA, JACK, QtMultimedia, OSS4 и другие). Эквалайзер. Эквалайзер. Чтение файлов архивов. Возможность запуска внешних команд при смене трека. Поддержка плагинов. И другие... ${NC}"
echo " Форматы: MPEG1 layer 2/3; Ogg Vorbis; Ogg Opus; Native FLAC/Ogg FLAC; Musepack; WavePack; Трекерные форматы: (mod, s3m, it, xm и т.д.). Форматы звука игровых консолей: (AY, GBS, GYM, HES, KSS, NSF, NSFE, SAP, SPC, VGM, VGZ, VTX). Системы вывода звука: OSS4 (FreeBSD) ; ALSA (Linux); PulseAudio; PipeWire; JACK; QtMultimedia; Icecast; WaveOut (Win32); DirectSound (Win32); WASAPI (Win32) "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_qmmp  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_qmmp" =~ [^10] ]]
do
    :
done
if [[ $i_qmmp == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_qmmp == 1 ]]; then
  echo ""
  echo " Установка QMMP (qmmp) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed qmmp  # Аудиоплеер на Qt5-6 ; https://archlinux.org/packages/extra/x86_64/qmmp/ ; http://qmmp.ylsoftware.com/ ; June 21, 2024, 7:51 p.m. UTC
  echo ""
  echo " Установка Пакета плагинов QMMP (qmmp-plugin-pack) "
########### qmmp-plugin-pack #############
yay -S qmmp-plugin-pack --noconfirm  # Пакет плагинов Qmmp ; https://aur.archlinux.org/packages/qmmp-plugin-pack ; https://aur.archlinux.org/qmmp-plugin-pack.git (только для чтения, нажмите, чтобы скопировать) ; http://qmmp.ylsoftware.com/ ; 2025-03-31 04:28 (UTC) ; http://qmmp.ylsoftware.com/links.php
########### qmmp-plugin-pack #############
#git clone https://aur.archlinux.org/qmmp-plugin-pack.git  # (только для чтения, нажмите, чтобы скопировать)
#cd qmmp-plugin-pack
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf qmmp-plugin-pack
#rm -Rf qmmp-plugin-pack
########### qmmp-plugin-pack-svn #############
### yay -S qmmp-plugin-pack-svn --noconfirm  # Пакет плагинов Qmmp (версия SVN) ; https://aur.archlinux.org/packages/qmmp-plugin-pack-svn ; https://aur.archlinux.org/qmmp-plugin-pack-svn.git (только для чтения, нажмите, чтобы скопировать) ; http://qmmp.ylsoftware.com/ ; Конфликты: с qmmp-plugin-pack ; Обеспечивает: qmmp-plugin-pack ; 24 сентября 2023 г. 12:37 (UTC)
# ~/.qmmp/skins
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Audacious (audacious) - Музыкальный проигрыватель?"
echo -e "${MAGENTA}:: ${BOLD}Audacious — это аудиоплеер с открытым исходным кодом . Потомок XMMS , Audacious воспроизводит вашу музыку так, как вы хотите, не отнимая ресурсы вашего компьютера у других задач. Перетаскивайте папки и отдельные файлы песен, ищите исполнителей и альбомы во всей вашей музыкальной библиотеке или создавайте и редактируйте собственные плейлисты. Слушайте компакт-диски или транслируйте музыку из Интернета. Настраивайте звук с помощью графического эквалайзера или изменяйте динамический диапазон с помощью аудиоэффектов. Наслаждайтесь современным интерфейсом на тему Qt или меняйте все с помощью скинов Winamp Classic. Используйте плагины, включенные в Audacious, для получения текстов песен для вашей музыки, отображения индикатора уровня громкости и многого другого. Работает быстро, поддерживает скины, плагины, эквалайзер. Поддерживает проигрывание большого числа аудио форматов. Легко расширяется с помощью сторонних плагинов. ${NC}"
echo " Домашняя страница: https://audacious-media-player.org/ ; (https://archlinux.org/packages/extra/x86_64/audacious/ ; https://wiki.archlinux.org/title/Audacious). "
echo -e "${MAGENTA}:: ${BOLD}Основные возможности и особенности программы Audacious: FOSS – Audacious — бесплатный и имеющий открытый исходный код. Audacious работает на Linux, производных BSD, macOS и Windows. Легковесность – Audacious также не требователен к ресурсам вашего компьютера. Настраиваемый графический интерфейс — придайте Audacious желаемый вид, используя любую из нескольких тем GTK и бесплатных расширений. Поддержка перетаскивания — легко добавляйте файлы и папки в свою музыкальную библиотеку с единообразной информацией. Поиск и теги — выполняйте поиск по всей своей музыкальной библиотеке, чтобы находить теги даже после их переименования. Плейлисты — создавайте и редактируйте смарт-плейлисты. Аудио-CD — вы можете прослушивать аудио-CD и даже копировать их аудио без потери качества звука. Потоковая передача музыки – слушайте разнообразные музыкальные жанры онлайн, транслируя музыку с других веб-сервисов. Графический эквалайзер — управляйте звуковыми каналами и свободно добавляйте интересные эффекты с помощью эффектов LADSPA. Поддержка плагинов — добавьте несколько бесплатных расширений, разработанных сообществом, для выполнения таких задач, как получение текстов песен и установка будильников на дневное время. ${NC}"
echo " Как и Clementine и Amarok, Audacious является прекрасной альтернативой таким известным музыкальным проигрывателям, как Rythmbox, Tomahawk и Banshee. Если вы ищете мощный музыкальный проигрыватель для Linux с небольшими требованиями к ресурсам вашего ПК, выбирайте Audacious! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_audacious  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_audacious" =~ [^10] ]]
do
    :
done
if [[ $in_audacious == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_audacious == 1 ]]; then
  echo ""
  echo " Установка Audacious (audacious) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed audacious audacious-plugins  # Легкий, продвинутый аудиоплеер, ориентированный на качество звука; Плагины для Audacious ; https://audacious-media-player.org/ ; https://archlinux.org/packages/extra/x86_64/audacious/ ; https://archlinux.org/packages/extra/x86_64/audacious-plugins/ ;
#sudo pacman -S --noconfirm --needed audacious  # Легкий, продвинутый аудиоплеер, ориентированный на качество звука ; https://audacious-media-player.org/ ; https://archlinux.org/packages/extra/x86_64/audacious/ ; June 22, 2024, 3:47 a.m. UTC
#sudo pacman -S --noconfirm --needed audacious-plugins  # Плагины для Audacious ; https://audacious-media-player.org/ ; https://archlinux.org/packages/extra/x86_64/audacious/ ; https://archlinux.org/packages/extra/x86_64/audacious-plugins/ ; June 22, 2024, 3:47 a.m. UTC
######## Для воспроизведения MIDI и RMI файлов ########
sudo pacman -S --noconfirm --needed fluidsynth  # Программный синтезатор реального времени, основанный на спецификациях SoundFont 2 ; https://www.fluidsynth.org/ ; https://archlinux.org/packages/extra/x86_64/fluidsynth/ ; 4 августа 2024 г., 00:09 UTC
# Сам FluidSynth не имеет графического пользовательского интерфейса, но благодаря своему мощному API его используют несколько приложений, и он даже нашел свое применение во встроенных системах и некоторых мобильных приложениях.
# Настройка fluidsynth не требуется, но для дополнительной функциональности смотрите инструкции в статье FluidSynth (https://wiki.archlinux.org/title/FluidSynth)
# После этого плагин будет включен, но нужно ещё подключить к нему файлы звуковых шрифтов. Откройте настройки плагина (Файл → Настройки ... → Модули → Ввод → Плагин AMIDI (проигрыватель MIDI) → нажмите иконку с шестерёнкой) и добавьте файлы шрифтов (расширение .sf2). Они располагаются в каталоге /usr/share/soundfonts/.
########### файлы звуковых шрифтов (банков инструментов) ############
sudo pacman -S --noconfirm --needed freepats-general-midi  # Бесплатный и открытый набор общих звуков MIDI ; https://freepats.zenvoid.org/SoundSets/general-midi.html ; https://archlinux.org/packages/extra/any/freepats-general-midi/ ; 4 июля 2024 г., 1:43 UTC ; Заменяет: timidity-freepats
sudo pacman -S --noconfirm --needed soundfont-fluid  # Звуковой шрифт FluidR3 ; https://tracker.debian.org/pkg/fluid-soundfont ; https://archlinux.org/packages/extra/any/soundfont-fluid/ ; 6 июля 2024 г., 12:51 UTC
########### Проблемы с MP3 ###########
sudo pacman -S --noconfirm --needed mpg123  # Консольный проигрыватель MPEG Audio Player в реальном времени для уровней 1, 2 и 3 ; https://mpg123.de/ ; https://archlinux.org/packages/extra/x86_64/mpg123/ ; 8 августа 2024 г., 20:57 UTC
# mpg123 - Быстрый консольный MPEG Audio Player и библиотека декодера.
######## Playerctl #############
sudo pacman -S --noconfirm --needed playerctl  # Контроллер и библиотека медиаплеера mpris для Spotify, VLC, Audacious, BMP, XMMS2 и других. https://github.com/altdesktop/playerctl ; https://archlinux.org/packages/extra/x86_64/playerctl/ ; 2024-08-15 17:16 UTC
############ libaudclient #############
#yay -S libaudclient --noconfirm  # Устаревшая клиентская библиотека D-Bus для Audacious ; https://aur.archlinux.org/packages/libaudclient ; https://aur.archlinux.org/libaudclient.git (только для чтения, нажмите, чтобы скопировать) ; https://audacious-media-player.org/ ; https://distfiles.audacious-media-player.org/libaudclient-3.5-rc2.tar.bz2 ; 2025-02-27 14:21 (UTC)
#git clone https://aur.archlinux.org/libaudclient.git  # (только для чтения, нажмите, чтобы скопировать)
#cd libaudclient
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf libaudclient
#rm -Rf libaudclient
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
################# Справка ##############
# Playerctl — это утилита командной строки и библиотека для управления медиаплеерами, реализующими спецификацию интерфейса MPRIS D-Bus. Playerctl упрощает привязку действий плеера, таких как воспроизведение и пауза, к клавишам мультимедиа. Вы также можете получить метаданные о воспроизводимой дорожке, такие как исполнитель и название, для интеграции в генераторы statusline или другие инструменты командной строки. Playerctl также поставляется с демоном, который позволяет ему работать с текущим активным медиаплеером, называемым playerctld.
# Audtool:
# Audacious имеет мощный инструмент управления Audtool, с помощью которого можно получить информацию из плеера или управлять им.
# Например, чтобы получить текущее название песни или исполнителя, введите следующую команду:
# $ audtool current-song
# $ audtool current-song-tuple-data artist
# Есть также функции для управления воспроизведением, эквалайзером, списком воспроизведения и главным окном программы. Весь список возможностей смотрите в audtool(https://man.archlinux.org/man/audtool.1).
# Чтобы добавить классический скин Winamp в Audacious, просто скопируйте его в каталог ~/.local/share/audacious/Skins/ (только для вашего пользователя) или в /usr/share/audacious/Skins/ (для всех пользователей), после чего выберите «Интерфейс классического Winamp» в настройках внешнего вида и выберите нужный скин в выпадающем списке «Скин» ниже.
#########################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Rhythmbox (rhythmbox) — Управление музыкой?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Rhythmbox, вдохновлённый приложением iTunes от Apple, позволяет импортировать аудио-CD в форматы MP3 или Ogg Vorbis и воспроизводить эти и другие музыкальные файлы. Слушайте музыку с помощью различных плагинов визуализации и записывайте новые аудио-CD из своих музыкальных файлов. Это универсальное приложение для всех ваших музыкальных потребностей. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Rhythmbox — это музыкальный проигрыватель для управления музыкальными файлами в Linux, разработанное для работы в среде GNOME. Поддерживает каталогизацию музыки, импорт/экспорт на устройства, интернет-радио и прочее. Помимо музыки, хранящейся на вашем компьютере, оно поддерживает сетевые папки, подкасты, радиопотоки, портативные музыкальные устройства (включая телефоны) и музыкальные интернет-сервисы, такие как Last.fm и Magnatune. Rhythmbox позволяет составить библиотеку ваших музыкальных файлов, составлять списки воспроизведения, читать и записывать звуковые диски прямо в программе, читать и записывать музыку на iPod и на другие устройства, проигрывать интернет-радио и подкасты. Rhythmbox — бесплатное программное обеспечение, основанное на GTK+ и GStreamer, расширяемое с помощью плагинов, написанных на Python или C. Разрабатывается в рамках проекта: GNOME; Исходный код: Open Source (открыт);Библиотеки: GTK; Приложение переведено на русский язык. Разрабатывается в рамках проекта: GNOME; Исходный код: Open Source (открыт);Библиотеки: GTK; Приложение переведено на русский язык. Этот проект Лицензируется под GPL-2.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://github.com/GNOME/rhythmbox ; (https://gitlab.gnome.org/GNOME/rhythmbox ; https://archlinux.org/packages/extra/x86_64/rhythmbox/ ; https://wiki.gnome.org/Apps/Rhythmbox ; https://github.com/wangd/rhythmbox ; http://luqmana.github.io/rhythmbox-plugins/). "
echo -e "${BLUE}:: ${NC}Текущие функции включают в себя: Воспроизводите музыкальные файлы mp3 или ogg из вашей организованной библиотеки ID3. Отображение информации о песнях посредством чтения метаданных. Отображение песен в организованном виде. Создавайте группы (плейлисты) путем перетаскивания из представления «Библиотека». Планируемые функции включают в себя: Интернет-радио. Визуальные эффекты. Поддержка аудио CD. Копирование и запись CD. Поддерживается установка дополнений. "
echo -e "${CYAN}:: ${NC}Rhythmbox имеет расширяемую систему плагинов, основанную на libpeas. Rhythmbox использует GTK+3 в качестве инструментария, но многие плагины не были обновлены для работы как с новым API плагинов, так и со стеком GNOME3. К сожалению, многие плагины являются «разовыми», то есть автор просто написал плагин и с тех пор не обновлял его. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_rhythmbox  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_rhythmbox" =~ [^10] ]]
do
    :
done
if [[ $in_rhythmbox == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_rhythmbox == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Rhythmbox (rhythmbox) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) плагины "
############ Зависимости ##############
#sudo pacman -S --noconfirm --needed brasero  # (опционально) — плагин для записи аудио-CD ; Инструмент для мастеринга CD/DVD ; https://archlinux.org/packages/extra/x86_64/brasero/ ; https://wiki.gnome.org/Apps/Brasero ; 2025-04-30 17:32 UTC
sudo pacman -S --noconfirm --needed grilo  # Фреймворк, обеспечивающий доступ к различным источникам мультимедийного контента ; https://archlinux.org/packages/extra/x86_64/grilo/ ; https://wiki.gnome.org/Projects/Grilo ; Обеспечивает: libgrilo-0.3.so=0-64, libgrlnet-0.3.so=0-64, libgrlpls-0.3.so=0-64 ; 2025-06-13 22:55 UTC
sudo pacman -S --noconfirm --needed grilo-plugins  # (необязательно) — плагин Grilo для медиа-браузера ; Коллекция плагинов для фреймворка Grilo ; https://archlinux.org/packages/extra/x86_64/grilo-plugins/ ; https://gitlab.gnome.org/GNOME/grilo-plugins ; 2025-06-25 09:26 UTC
sudo pacman -S --noconfirm --needed gst-libav  # (необязательно) — дополнительные медиакодеки ; Фреймворк мультимедийных графов — плагин libav ; https://archlinux.org/packages/extra/x86_64/gst-libav/ ; https://gstreamer.freedesktop.org/ ; Обеспечивает: gst-ffmpeg=1.26.5-1 ; 2025-08-08 06:45 UTC
sudo pacman -S --noconfirm --needed gst-plugins-bad  # (необязательно) — Дополнительные медиакодеки ; Мультимедийный граф-фреймворк — плохие плагины ; https://archlinux.org/packages/extra/x86_64/gst-plugins-bad/ ; https://gstreamer.freedesktop.org/ ; 2025-08-08 06:45 UTC
sudo pacman -S --noconfirm --needed gst-plugins-ugly  # (необязательно) — Дополнительные медиакодеки ; Фреймворк мультимедийных графов — уродливые плагины ; https://archlinux.org/packages/extra/x86_64/gst-plugins-ugly/ ; https://gstreamer.freedesktop.org/ ; 2025-08-08 06:45 UTC
sudo pacman -S --noconfirm --needed libdmapsharing  # (необязательно) — плагин DAAP Music Sharing ; Библиотека, реализующая семейство протоколов DMAP ; https://archlinux.org/packages/extra/x86_64/libdmapsharing/ ; https://www.flyn.org/projects/libdmapsharing/index.html ; Обеспечивает: libdmapsharing-4.0.so=3-64 ; 2023-07-30 01:24 UTC
sudo pacman -S --noconfirm --needed libgpod  # (необязательно) — Портативные плееры — плагин для iPod ; Общая библиотека для доступа к содержимому iPod ; https://archlinux.org/packages/extra/x86_64/libgpod/ ; http://www.gtkpod.org/libgpod/ ; Обеспечивает: libgpod.so=4-64 ; 2025-04-30 17:34 UTC
sudo pacman -S --noconfirm --needed lirc  # (необязательно) — плагин LIRC ; Утилиты инфракрасного дистанционного управления Linux ; https://archlinux.org/packages/extra/x86_64/lirc/ ; https://www.lirc.org/ ; Обеспечивает: lirc-utils ; Заменяет: lirc-utils ; Конфликты: с lirc-utils ; 2024-12-22 13:54 UTC
sudo pacman -S --noconfirm --needed zeitgeist  # (необязательно) — плагин для ведения журнала Zeitgeist ; Служба регистрации действий и событий пользователей ; https://archlinux.org/packages/extra/x86_64/zeitgeist/ ; https://launchpad.net/zeitgeist/ ; Обеспечивает: zeitgeist-datahub ; Заменяет: zeitgeist-datahub ; Конфликты: с zeitgeist-datahub ; 2024-12-22 12:59 UTC
sudo pacman -S --noconfirm --needed dleyna  # Службы и API D-Bus для доступа к медиаустройствам UPnP и DLNA ; https://archlinux.org/packages/extra/x86_64/dleyna/ ; https://gitlab.gnome.org/World/dLeyna ; Обеспечивает: dleyna-connector-dbus, dleyna-core, dleyna-renderer, dleyna-server, libdleyna-core-1.0.so=6-64 ; Заменяет: dleyna-connector-dbus<=0.4.1-1, dleyna-core<=0.7.0-3, dleyna-renderer<=0.7.2-1, dleyna-server<=0.7.2-1 ; Конфликты: с dleyna-connector-dbus<=0.4.1-1, dleyna-core<=0.7.0-3, dleyna-renderer<=0.7.2-1, dleyna-server<=0.7.2-1 ; 2025-04-30 17:32 UTC
sudo pacman -S --noconfirm --needed gvfs-mtp  # Реализация виртуальной файловой системы для GIO - бэкэнд MTP (Android, медиаплеер) ; https://archlinux.org/packages/extra/x86_64/gvfs-mtp/ ; https://gitlab.gnome.org/GNOME/gvfs ; 2025-06-14 16:09 UTC
######### rhythmbox ###########
sudo pacman -S --noconfirm --needed rhythmbox  # Приложение для воспроизведения и управления музыкой ; https://archlinux.org/packages/extra/x86_64/rhythmbox/ ; https://gitlab.gnome.org/GNOME/rhythmbox ; https://github.com/GNOME/rhythmbox ; https://github.com/wangd/rhythmbox ; http://luqmana.github.io/rhythmbox-plugins/ ; 2025-07-31 18:24 UTC
############# Интеграция Яндекс.Музыки для Rhythmbox ###############
############## python-yandex-music-api ##########
#yay -S python-yandex-music-api --noconfirm  # Неофициальная библиотека Python для API Яндекс.Музыки ; https://aur.archlinux.org/packages/python-yandex-music-api ; https://aur.archlinux.org/python-yandex-music-api.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/MarshalX/yandex-music-api ; 2023-08-17 09:01 (UTC)
############## python-yandex-music-api ##########
#git clone https://aur.archlinux.org/python-yandex-music-api.git  # (только для чтения, нажмите, чтобы скопировать)
#cd python-yandex-music-api
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf python-yandex-music-api
#rm -Rf python-yandex-music-api
########### rhythmbox-plugin-yandex-music ############
#yay -S rhythmbox-plugin-yandex-music --noconfirm  # Интеграция Яндекс.Музыки для Rhythmbox ; https://aur.archlinux.org/packages/rhythmbox-plugin-yandex-music ; https://aur.archlinux.org/rhythmbox-plugin-yandex-music.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/feschukov/rhythmbox-plugin-yandex-music ; Конфликты: с rhythmbox-plugin-yandex-music-git ; 2023-02-25 17:00 (UTC)
########### rhythmbox-plugin-yandex-music ############
#git clone https://aur.archlinux.org/rhythmbox-plugin-yandex-music.git  # (только для чтения, нажмите, чтобы скопировать)
#cd rhythmbox-plugin-yandex-music
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf rhythmbox-plugin-yandex-music
#rm -Rf rhythmbox-plugin-yandex-music
########## Минималистичный интерфейс для Rhythmbox ############
############ rhythmbox-plugin-alternative-toolbar #############
#yay -S rhythmbox-plugin-alternative-toolbar --noconfirm  # Современный, минималистичный и ориентированный на музыку интерфейс для Rhythmbox ; https://aur.archlinux.org/packages/rhythmbox-plugin-alternative-toolbar ; https://aur.archlinux.org/rhythmbox-plugin-alternative-toolbar.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/fossfreedom/alternative-toolbar ; Конфликты: с rhythmbox-plugin-alternative-toolbar-git ; 2025-07-15 15:59 (UTC)
############ rhythmbox-plugin-alternative-toolbar #############
#git clone https://aur.archlinux.org/rhythmbox-plugin-alternative-toolbar.git  # (только для чтения, нажмите, чтобы скопировать)
#cd rhythmbox-plugin-alternative-toolbar
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf rhythmbox-plugin-alternative-toolbar
#rm -Rf rhythmbox-plugin-alternative-toolbar
  echo ""
  echo " Посмотрите информацию о версии (rhythmbox) "
#sudo rhythmbox --version  # Показать версию приложения
sudo pacman -Q rhythmbox  #  Показать версию приложения ; Альтернативный метод — проверить версию установленного пакета NTP через менеджер пакетов системы.
# sudo pacman -Qs имя_пакета  # Используйте команду pacman с -Qs опцией поиска только среди установленных пакетов в системе. Она ищет указанный текст только в названиях и описаниях установленных пакетов.
# sudo pacman -Qi имя_пакета  # Эта -Qi опция отображает подробную информацию об указанном пакете. Она также показывает метаданные пакета, такие как зависимости, конфликты, дата установки, дата сборки, размер и т. д.
# sudo pacman -Si имя_пакета  # Эта -Si опция позволяет просматривать подробную информацию о любых пакетах Arch Linux. Необходимо указать точное название пакета.
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# Rhythmbox - ArchWiki: https://wiki.archlinux.org/title/Rhythmbox
# https://archlinux.org/packages/extra/x86_64/rhythmbox/
# https://gitlab.gnome.org/GNOME/rhythmbox
# https://wiki.gnome.org/Apps/Rhythmbox
# https://github.com/GNOME/rhythmbox
# https://github.com/wangd/rhythmbox
# http://luqmana.github.io/rhythmbox-plugins/
# https://wiki.archlinux.org/title/Rhythmbox
# Управляем 'Rhythmbox'ом по ssh:
# https://habr.com/en/articles/74544/
# Rhythmbox Plugins:
# http://luqmana.github.io/rhythmbox-plugins/
# https://wiki.gnome.org/Apps(2f)Rhythmbox(2f)Plugins.html
################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Elisa (elisa) — Музыкальный проигрыватель?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *В конце 2014 года было объявлено, что KDE намерен создать преемника музыкального плеера Amarok. На форуме KDE VDG (Visual Design Group) Эндрю Лейком (Andrew Lake) был анонсирован дизайн аудиоплеера. 4 апреля 2017 года, это начинание наконец обрело реальные черты — следуя рекомендациям по дизайну от VDG, разработчик Матьё Галльен (Matthieu Gallien) создал аудиоплеер, который назвал Elisa. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Elisa — простой музыкальный проигрыватель разработан сообществом KDE и стремится быть простым и приятным в использовании. С помощью Elisa вы можете просматривать локальную музыкальную коллекцию по жанру, исполнителю, альбому или треку, слушать онлайн-радио, создавать и управлять плейлистами, отображать тексты песен и многое другое. Elisa поддерживает полную цветовую схему KDE при использовании на рабочем столе Plasma или стандартные светлый и темный режимы. Расслабьтесь с режимом вечеринки, в котором обложки ваших музыкальных альбомов выводятся на первый план. Первое, что вам нужно сделать при запуске Elisa, — это настроить папки с музыкой. Подробную информацию о приложении можно найти по адресу https://apps.kde.org/elisa/ . Этот проект Лицензируется под LGPL (Lesser GPL), LGPL-2.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://apps.kde.org/elisa/ ; (https://github.com/KDE/elisa ; https://archlinux.org/packages/extra/x86_64/elisa/). "
echo -e "${BLUE}:: ${NC}Возможности и особенности: Плеер имеет простой и элегантный дизайн. Elisa не перегружена функциями и обладает базовыми возможностями для проигрывания файлов. Программа автоматически индексирует музыкальные файлы в системе. Позволяет делать выборки музыки по Альбомам, Исполнителям, Дорожкам, Жанрам. Возможность задать директории для поиска файлов. Отображение обложек альбомов. Отображение статуса в панели задач. Сворачивание в системный лоток при закрытии окна программы. Сохранение и открытие списков воспроизведения. Поддержка широкого спектра аудиоформатов (MP3, Ogg Vorbis, FLAC, AAC и др.) Разрабатывается в рамках проекта: KDE ; Исходный код: Open Source (открыт) ; Языки программирования:  C++ ; Библиотеки: KDE Frameworks, Qt ; Приложение переведено на русский язык. *Некоторые недостатки, упомянутые пользователями: нет поддержки синхронизации с портативными устройствами; нет некоторых продвинутых опций воспроизведения. "
echo -e "${CYAN}:: ${NC}Elisa всё ещё находится на стадии интенсивной разработки и стремится реализовать следующие цели: Простота настройки (в идеале — отсутствие необходимости в ней перед использованием); Полноценная работа в офлайн-режиме (или в приватном режиме); Открытость для использования онлайн-сервисов, но не делать это приоритетом разработки (удобство использования не должно ухудшаться в офлайн-режиме); Ориентация на удовлетворение целей пользователей; Ориентация на воспроизведении музыки (управление музыкальной коллекцией не является приоритетом разработки); Отсутствие ошибок (стабильность имеет более высокий приоритет, чем функциональность); Целевые платформы: KDE Plasma, другие окружения рабочего стола Linux, Android и Windows; Возможность использования UPnP DLNA. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_elisa  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_elisa" =~ [^10] ]]
do
    :
done
if [[ $in_elisa == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_elisa == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Elisa (elisa) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
############ elisa ##############
sudo pacman -S --noconfirm --needed elisa  # Простой музыкальный проигрыватель, призванный обеспечить пользователям приятный опыт использования ; https://archlinux.org/packages/extra/x86_64/elisa/ ; https://apps.kde.org/elisa/ ; https://github.com/KDE/elisa ; Группы: kde-applications, kde-multimedia ; Требуется для kde-multimedia-meta ; 2025-07-09 17:04 UTC
# sudo pacman -Rs elisa  # В случае возникновения ошибок при установке пакета
  echo ""
  echo " Посмотрите информацию о версии (elisa) "
# sudo elisa --version  # Показать версию приложения
sudo pacman -Q elisa  #  Показать версию приложения ; Альтернативный метод — проверить версию установленного пакета NTP через менеджер пакетов системы.
# sudo pacman -Qs имя_пакета  # Используйте команду pacman с -Qs опцией поиска только среди установленных пакетов в системе. Она ищет указанный текст только в названиях и описаниях установленных пакетов.
# sudo pacman -Qi имя_пакета  # Эта -Qi опция отображает подробную информацию об указанном пакете. Она также показывает метаданные пакета, такие как зависимости, конфликты, дата установки, дата сборки, размер и т. д.
# sudo pacman -Si имя_пакета  # Эта -Si опция позволяет просматривать подробную информацию о любых пакетах Arch Linux. Необходимо указать точное название пакета.
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
### Подробную информацию о приложении можно найти по адресу:
# https://apps.kde.org/elisa/ .
#####################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Amarok (amarok) — Музыкальный проигрыватель?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Если вы меломан и ищете мощный и многофункциональный аудиоплеер, Amarok может стать идеальным решением. Этот легендарный музыкальный проигрыватель на базе KDE триумфально вернулся после долгих лет затишья, сохранив все любимые функции, сделавшие его фаворитом среди пользователей Linux. Независимо от того, используете ли вы стандартную версию GNOME или KDE, Amarok без проблем интегрируется в вашу рабочую среду. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Amarok — полнофункциональный, бесплатный музыкальный проигрыватель с открытым исходным кодом для Linux , macOS , Windows и других Unix-подобных операционных систем. Amarok является частью проекта KDE , но выпускается независимо от основного цикла выпуска KDE Software Compilation. Amarok — универсальный, мощный и многофункциональный музыкальный проигрыватель и приложение для управления музыкой (менеджер коллекций) на базе KDE, пожалуй, одно из лучших приложений для воспроизведения музыки в Linux. Этот аудиоплеер, впервые выпущенный в 2003 году, имеет характерный логотип с изображением синего волка и слоган «Откройте для себя музыку заново». Amarok отличается от других музыкальных проигрывателей уникальным подходом к управлению музыкой и её воспроизведению. Изначально приложение входило в состав KDE 4 и служило официальным проигрывателем в дистрибутивах Kubuntu и Mandriva. Почему стоит выбрать Amarok среди других музыкальных плееров? Amarok предлагает ряд преимуществ для опытных пользователей. Одна только функция аудиозакладок делает его незаменимым для изучающих языки, исследователей и всех, кому нужно отмечать определённые моменты в аудиофайлах. Кроме того, мощные инструменты управления коллекциями и широкие возможности настройки обеспечивают уровень контроля, который сложно найти где-либо ещё. Этот проект Лицензируется под GPL-2.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://amarok.kde.org/ ; (https://apps.kde.org/amarok/ ; https://archlinux.org/packages/extra/x86_64/amarok/). "
echo -e "${BLUE}:: ${NC}Обзор: Различные списки источников музыки: локальные (на компьютере), интернет (сетевые источники: Cool Streams, Free Music Charts, Jamendo, Last.fm, Librivox, Magnatune.com, MP3 Music Store), различные типы списков воспроизведения (динамические, сохранённые и генератор списков), файлы и подкасты; Есть экспорт списка воспроизведения; Может воспроизводить потоковое аудио; Есть возможность просмотра и редактирования информации о воспроизводимом аудио файле, также можно загрузить текст песни, добавить метки, осуществить поиск в музыкальном магазине и выставить оценку; Отображение информации из Википедии (на выбранном языке) об исполнителе песни или альбоме; Автоматическая загрузка текстов песен из разных источников с возможностью добавления своих сценариев поиска; Имеется возможность сортировки музыки: альбом, исполнитель альбома, исполнитель, битрейт, ударов в минуту, комментарий, композитор, каталог, номер диска, имя файла, жанр, последнее воспроизведение, длительность, кол-во воспроизведений, оценка, частота дискретизации, рейтинг, источник, заголовок, номер дорожки, тип, год, в случайном порядке; Есть настройки каким образом воспроизводить файлы: по порядку, только очередь, повторять дорожку, повторять альбом, повторять список воспроизведения, случайные дорожки, случайные альбомы, избранные (с наивысшим рейтингом, с наивысшей оценкой, воспроизведённые недавно); Имеется возможность варьировать апплетами: добавлять и убирать; Имеется эквалайзер; Поддержка плагинов; Настройка уведомлений: продолжительность, полупрозрачность, масштаб шрифта, использование системных уведомлений; Настройка горячих клавиш; Отображение иконки в трее с управлением: переключение дорожек, остановки и проигрывания; Интеграция с iPod, iRiver, iFP, njb и USB-устройствами; Поддержка статистики. "
echo -e "${CYAN}:: ${NC}Amarok оснащен функциями, которых вы не найдете в большинстве других аудиоплееров: Аудиозакладки : уникальная функция, позволяющая размещать визуальные метки (синие треугольники) на определенных временных метках внутри треков для удобства навигации. Динамические плейлисты : автоматическое обновление плейлистов, соответствующих различным критериям. Интеграция с Википедией : просматривайте информацию об исполнителе, названии и альбоме прямо в плеере. Интеграция с Last.fm : социальные музыкальные функции и скробблинг. Отображение текстов песен : встроенная функция загрузки и отображения текстов песен. Система рейтингов : организуйте свою музыку с помощью индивидуальных рейтингов. Поддержка нескольких баз данных : выбирайте из различных баз данных, включая MySQL. Интерфейс с возможностью написания скриптов : расширение функциональности с помощью скриптов, разработанных сообществом. Поддержка тем : настройте внешний вид в соответствии со своими предпочтениями. Amarok предъявляет скромные требования к оборудованию: ОЗУ : минимум 512 МБ (для больших библиотек рекомендуется 1 ГБ). Память : не менее 100 МБ для приложения и место для вашей музыкальной коллекции. Процессор : любой современный процессор последнего десятилетия должен без проблем справиться с Amarok. Аудио : Стандартное аудиооборудование с поддержкой ALSA или PulseAudio. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_amarok  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_amarok" =~ [^10] ]]
do
    :
done
if [[ $in_amarok == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_amarok == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Amarok (amarok) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed ffmpeg  # Комплексное решение для записи, преобразования и потоковой передачи аудио и видео ; https://archlinux.org/packages/extra/x86_64/ffmpeg/ ; https://ffmpeg.org/ ; Обеспечивает: libavcodec.so=61-64, libavdevice.so=61-64, libavfilter.so=10-64, libavformat.so=61-64, libavutil.so=59-64, Подробнее… (https://archlinux.org/packages/extra/x86_64/ffmpeg/#); 2025-07-17 06:59 UTC
########## amarok ############
sudo pacman -S --noconfirm --needed amarok  # Мощный музыкальный проигрыватель, который позволит вам заново открыть для себя любимую музыку ; https://archlinux.org/packages/extra/x86_64/amarok/ ; https://apps.kde.org/amarok/ ; https://amarok.kde.org/ ; 2025-07-08 20:52 UTC
############ Панель настроения ########
### Панель настроения — это функция, которая превращает ваш стандартный ползунок прогресса в ползунок прогресса, цвет которого зависит от настроения вашего трека. Затем перейдите в «Настройки» > «Настроить Amarok» и установите флажок «Показывать ползунок прогресса в панели настроения».
# Поскольку Amarok 2 не генерирует файлы настроения, вы можете следовать этому руководству (https://userbase.kde.org/Amarok/Manual/Various/Moodbar#Moodbar_File_Generation_Script), чтобы создать их самостоятельно.
######### moodbar #########
yay -S moodbar --noconfirm  # Бинарные файлы и скрипт moodbar для Amarok ; https://aur.archlinux.org/packages/moodbar ; https://aur.archlinux.org/moodbar.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/exaile/moodbar/releases ; 28.03.2024 09:26 (UTC)
######### moodbar #########
#git clone https://aur.archlinux.org/moodbar.git  # (только для чтения, нажмите, чтобы скопировать)
#cd moodbar
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf moodbar
#rm -Rf moodbar
  echo ""
  echo " Посмотрите информацию о версии (amarok) "
# sudo amarok --version  # Показать версию приложения
sudo pacman -Q amarok  #  Показать версию приложения ; Альтернативный метод — проверить версию установленного пакета NTP через менеджер пакетов системы.
# sudo pacman -Qs имя_пакета  # Используйте команду pacman с -Qs опцией поиска только среди установленных пакетов в системе. Она ищет указанный текст только в названиях и описаниях установленных пакетов.
# sudo pacman -Qi имя_пакета  # Эта -Qi опция отображает подробную информацию об указанном пакете. Она также показывает метаданные пакета, такие как зависимости, конфликты, дата установки, дата сборки, размер и т. д.
# sudo pacman -Si имя_пакета  # Эта -Si опция позволяет просматривать подробную информацию о любых пакетах Arch Linux. Необходимо указать точное название пакета.
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# ArchWiki Amarok:
# https://wiki.archlinux.org/title/Amarok
# https://amarok.kde.org/
# https://apps.kde.org/amarok/
# https://archlinux.org/packages/extra/x86_64/amarok/
####################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить DeaDBeeF (deadbeef) — Простой музыкальный плеер?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *В сценарии (скрипта) представлен DeaDBeeF - deadbeef 1.10.0-1 (но без русской локализации)(на момент написания). Если вы хотите установить пакет deadbeef с русской локализации deadbeef-static-1.8.4-1-x86_64.pkg.tar (это крайняя версия на русском языке). Ссылки и способ установки будет написан в сценарии (скрипта) в Справке, но она закомментирована '#', воспользуйтесь скриптом как шпаргалкой открыв в любом текстовом редакторе (там написано как скачать и установить). ${NC}"
echo -e "${MAGENTA}:: ${BOLD}DeaDBeeF (как 0xDEADBEEF) — модульный кроссплатформенный аудиоплеер, работающий в дистрибутивах GNU/Linux, macOS, Windows, *BSD, OpenSolaris и других UNIX-подобных системах. DeaDBeeF воспроизводит множество аудиоформатов, конвертирует их между собой, позволяет настраивать пользовательский интерфейс практически любым желаемым вами способом и использовать множество дополнительных плагинов, которые могут еще больше расширить его возможности. Плагины — это дополнительные компоненты, которые расширяют возможности плеера DeaDBeeF новыми функциями. Описание функций каждого плагина смотрите по адресу (https://deadbeef.sourceforge.io/plugins.html). Этот проект Лицензируется под GPL2, zlib, LGPL2.1 . ${NC}"
echo " Домашняя страница: https://deadbeef.sourceforge.io/ ; (https://deadbeef.sourceforge.io/plugins.html ; https://github.com/DeaDBeeF-Player/deadbeef ; https://aur.archlinux.org/packages/deadbeef). "
echo -e "${BLUE}:: ${NC}Функции: Играет почти всё, что вы ему подкинете: Mp3, ogg vorbis, flac, ape, wv/iso.wv, wav, m4a/m4b/mp4 (aac и alac), mpc, tta, cd audio и многие другие Nsf, ay, vtx, vgm/vgz, spc и многие другие популярные форматы чиптюна (chiptune formats). SID с поддержкой базы данных длин песен HVSC для sid. Модули трекера - mod, s3m, it, xm и т. д. И еще больше форматов с использованием FFMPEG. Довольно хорошо читает и пишет теги. Чтение и запись тегов ID3v1, ID3v2.2, ID3v2.3, ID3v2.4, APEv2, Xing/Info, VorbisComments, а также чтение многих других форматов тегов/метаданных в большинстве поддерживаемых форматов. Автоматическое определение набора символов для тегов ID3, отличных от Unicode, — поддерживает cp1251, iso8859–1, а теперь и китайский cp936 (опционально), а также SHIFT-JIS и MS-DOS CP866 для выбранных форматов. Теги Unicode также полностью поддерживаются (как utf8, так и ucs2). Высококачественный редактор тегов с поддержкой настраиваемых полей. Очень хорошая поддержка Cuesheet, автоматически разбивающая альбомы на треки. Поддержка Cuesheet (файлов .cue), включая определение/конвертацию кодировки. Встроенные и внешние. Интеллектуальная эвристика для сопоставления аудиофайлов с файлами контрольных таблиц. Кроме того, информацию о главах можно извлекать и использовать из выбранных форматов, таких как аудиокниги m4b, файлы ogg и т. д. Прямой подход к организации вашей музыки. Ваши файлы добавляются в плеер напрямую из файловой системы. Несколько плейлистов с использованием вкладок или браузера плейлистов. Сортируйте и группируйте треки в любом желаемом порядке, используя расширенные скрипты форматирования заголовков, совместимые с Foobar2000. "
echo -e "${CYAN}:: ${NC}Нужен ли дополнительный басовый удар? 18-полосный графический эквалайзер и другие DSP-плагины. Высоконастраиваемый конвейер DSP с множеством доступных плагинов. Другие приятные мелочи! Воспроизведение без пауз для правильно закодированных файлов. Replaygain - включая сканер! А как насчет обложек альбомов? Вы можете включить отображение обложки альбома (см. страницу справки в плеере, как это сделать). Его можно загрузить из файлов изображений или из тегов аудиофайлов. Файлы изображений можно автоматически загружать с различных веб-сервисов. Сетевые возможности! Поддержка потокового радио для выбранных форматов и транспортов. Поддерживаются большинство популярных форматов, таких как MP3, OGG, AAC, WMA. Протоколы Shoutcast/Icecast и MMS поддерживаются «из коробки». Быстро конвертируйте вашу музыку в нужный вам формат. DeaDBeeF поставляется с расширенным плагином Converter, который позволяет перекодировать файлы в другие форматы. Особенно полезно для переноса музыки на мобильные устройства на большинстве современных платформ. Вы даже можете предварительно обработать файлы перед конвертацией — например, понизить частоту дискретизации или применить эквалайзер. Для наименования файлов доступно форматирование заголовков. При желании структуру папок можно сохранить. "
echo -e "${CYAN}:: ${NC}Установка DeaDBeeF (deadbeef), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/deadbeef.git), (https://aur.archlinux.org/packages/deadbeef) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_deadbeef  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_deadbeef" =~ [^10] ]]
do
    :
done
if [[ $in_deadbeef == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_deadbeef == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) DeaDBeeF (deadbeef) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
# sudo pacman -S --noconfirm --needed curl  # Инструмент командной строки и библиотека для передачи данных с помощью URL-адресов. https://archlinux.org/packages/core/x86_64/curl/
# sudo pacman -S --noconfirm --needed git  # Быстрая распределенная система контроля версий. https://archlinux.org/packages/extra/x86_64/git/
sudo pacman -S --noconfirm --needed alsa-lib  # Альтернативная реализация поддержки звука в Linux ; https://archlinux.org/packages/extra/x86_64/alsa-lib/ ; https://www.alsa-project.org/ ; Обеспечивает: libasound.so=2-64, libatopology.so=2-64 ; 2025-04-14 20:27 UTC
sudo pacman -S --noconfirm --needed gtk3  # Мультиплатформенный набор графических инструментов на основе GObject ; https://archlinux.org/packages/extra/x86_64/gtk3/ ; https://archlinux.org/packages/extra/x86_64/gtk3/ ; Обеспечивает: gtk3-print-backends, libgailutil-3.so=0-64, libgdk-3.so=0-64, libgtk-3.so=0-64 ; Заменяет: gtk3-print-backends<=3.22.26-1 ; Конфликты: с gtk3-print-backends ; 2025-08-10 14:21 UTC
sudo pacman -S --noconfirm --needed jansson  # Библиотека C для кодирования, декодирования и управления данными JSON ; https://archlinux.org/packages/core/x86_64/jansson/ ; https://www.digip.org/jansson/ ; 2025-03-31 20:07 UTC
sudo pacman -S --noconfirm --needed libdispatch  # Комплексная поддержка одновременного выполнения кода на многоядерном оборудовании ; https://archlinux.org/packages/extra/x86_64/libdispatch/ ; https://apple.github.io/swift-corelibs-libdispatch ; Обеспечивает: libblocksruntime ; 2025-04-01 17:55 UTC
sudo pacman -S --noconfirm --needed clang  # Интерфейс семейства языков C для LLVM ; https://archlinux.org/packages/extra/x86_64/clang/ ; https://clang.llvm.org/ ; Обеспечивает: clang-analyzer=20.1.8, clang-tools-extra=20.1.8 ; Заменяет: clang-analyzer, clang-tools-extra ; Конфликты: с clang-analyzer, clang-tools-extra ; 2025-07-15 21:01 UTC
sudo pacman -S --noconfirm --needed faad2  # Бесплатный декодер Advanced Audio (AAC) ; https://archlinux.org/packages/extra/x86_64/faad2/ ; https://github.com/knik0/faad2 ; Обеспечивает: faad, libfaad.so=2-64, libfaad_drm.so=2-64 ; 2025-03-04 09:01 UTC
#sudo pacman -S --noconfirm --needed vlc-plugin-faad2  # Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагин FAAD2 AAC ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-faad2/ ; https://www.videolan.org/vlc/ ; 2025-07-23 20:53 UTC
sudo pacman -S --noconfirm --needed ffmpeg  # Комплексное решение для записи, преобразования и потоковой передачи аудио и видео ; https://archlinux.org/packages/extra/x86_64/ffmpeg/ ; https://ffmpeg.org/ ; Обеспечивает: libavcodec.so=61-64, libavdevice.so=61-64, libavfilter.so=10-64, libavformat.so=61-64, libavutil.so=59-64, Подробнее… (https://archlinux.org/packages/extra/x86_64/ffmpeg/#); 2025-07-17 06:59 UTC
sudo pacman -S --noconfirm --needed flac  # Бесплатный аудиокодек без потерь ; https://archlinux.org/packages/extra/x86_64/flac/ ; https://xiph.org/flac/ ; Обеспечивает: libFLAC++.so=11-64, libFLAC.so=14-64 ; 2025-02-21 19:56 UTC
sudo pacman -S --noconfirm --needed imlib2  # Библиотека, которая выполняет загрузку и сохранение файлов изображений, а также рендеринг, манипуляцию и поддержку произвольных полигонов ; https://archlinux.org/packages/extra/x86_64/imlib2/ ; https://sourceforge.net/projects/enlightenment/ ; 2025-04-07 15:12 UTC
sudo pacman -S --noconfirm --needed intltool  # Коллекция инструментов интернационализации ; https://archlinux.org/packages/extra/any/intltool/ ; https://launchpad.net/intltool ; 2020-06-21 15:27 UTC
sudo pacman -S --noconfirm --needed libcddb  # Библиотека, реализующая различные протоколы (CDDBP, HTTP, SMTP) для доступа к данным на сервере CDDB (https://gnudb.org) ; https://archlinux.org/packages/extra/x86_64/libcddb/ ; https://sourceforge.net/projects/libcddb/ ; 2022-12-09 07:45 UTC
sudo pacman -S --noconfirm --needed libcdio  # Библиотека ввода и управления компакт-дисками GNU ; https://archlinux.org/packages/extra/x86_64/libcdio/ ; https://www.gnu.org/software/libcdio/ ; 2025-01-12 02:14 UTC
sudo pacman -S --noconfirm --needed libmad  # Высококачественный аудиодекодер MPEG ; https://archlinux.org/packages/extra/x86_64/libmad/ ; https://www.underbit.com/products/mad/ ; 2023-02-18 21:54 UTC
sudo pacman -S --noconfirm --needed libpipewire  # Аудио/видео маршрутизатор и процессор с малой задержкой — клиентская библиотека ; https://archlinux.org/packages/extra/x86_64/libpipewire/ ; https://pipewire.org/ ; Обеспечивает: libpipewire-0.3.so=0-64 ; 2025-07-26 01:14 UTC
sudo pacman -S --noconfirm --needed lib32-libpipewire  # Аудио/видео маршрутизатор и процессор с малой задержкой — 32-бит — клиентская библиотека ; https://archlinux.org/packages/multilib/x86_64/lib32-libpipewire/ ; https://pipewire.org/ ; Обеспечивает: libpipewire-0.3.so=0-32 ; 2025-07-26 01:13 UTC
sudo pacman -S --noconfirm --needed libpulse  # Функциональный универсальный звуковой сервер (клиентская библиотека) ; https://archlinux.org/packages/extra/x86_64/libpulse/ ; https://www.freedesktop.org/wiki/Software/PulseAudio/ ; Обеспечивает: libpulse-mainloop-glib.so=0-64, libpulse-simple.so=0-64, libpulse.so=0-64 ; 2024-12-07 17:14 UTC
#sudo pacman -S --noconfirm --needed lib32-libpulse  # Функциональный универсальный звуковой сервер (32-битные клиентские библиотеки) ; https://archlinux.org/packages/multilib/x86_64/lib32-libpulse/ ; https://www.freedesktop.org/wiki/Software/PulseAudio/ ; Обеспечивает: lib32-pulseaudio=17.0+r43+g3e2bb8a1e ; Заменяет: lib32-pulseaudio ; Конфликты: с lib32-pulseaudio ; 2024-12-07 17:12 UTC
sudo pacman -S --noconfirm --needed libsamplerate # Библиотека преобразования частоты дискретизации звука ; https://archlinux.org/packages/extra/x86_64/libsamplerate/ ; https://libsndfile.github.io/libsamplerate/ ; Обеспечивает: libsamplerate.so=0-64 ; 2024-07-12 21:15 UTC
sudo pacman -S --noconfirm --needed lib32-libsamplerate  # Библиотека преобразования частоты дискретизации звука ; https://archlinux.org/packages/multilib/x86_64/lib32-libsamplerate/ ; https://libsndfile.github.io/libsamplerate/ ; Обеспечивает: libsamplerate.so=0-32 ; 2024-09-07 11:54 UTC
sudo pacman -S --noconfirm --needed libsndfile  # Библиотека AC для чтения и записи файлов, содержащих сэмплированные аудиоданные ; https://archlinux.org/packages/extra/x86_64/libsndfile/ ; https://libsndfile.github.io/libsndfile/ ; Обеспечивает: libsndfile.so=1-64 ; 2025-02-21 19:56 UTC
sudo pacman -S --noconfirm --needed lib32-libsndfile  # Библиотека AC для чтения и записи файлов, содержащих сэмплированные аудиоданные (32 бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-libsndfile/ ; https://libsndfile.github.io/libsndfile/ ; Обеспечивает: libsndfile.so=1-32 ; 2025-02-21 19:55 UTC
sudo pacman -S --noconfirm --needed python-soundfile  # Библиотека Python для чтения и записи аудиофайлов с использованием libsndfile, CFFI и NumPy ; https://archlinux.org/packages/extra/any/python-soundfile/ ; https://github.com/bastibe/python-soundfile ; 2024-12-22 13:43 UTC
sudo pacman -S --noconfirm --needed libvorbis  # Эталонная реализация аудиоформата Ogg Vorbis ; https://archlinux.org/packages/extra/x86_64/libvorbis/ ; https://www.xiph.org/vorbis/ ; Обеспечивает: libvorbis.so=0-64, libvorbisenc.so=2-64, libvorbisfile.so=3-64 ; 2025-01-27 23:00 UTC
sudo pacman -S --noconfirm --needed lib32-libvorbis  # Эталонная реализация аудиоформата Ogg Vorbis (32 бита) ; https://archlinux.org/packages/multilib/x86_64/lib32-libvorbis/ ; https://www.xiph.org/vorbis/ ; Обеспечивает: libvorbis.so=0-32, libvorbisenc.so=2-32, libvorbisfile.so=3-32 ; 2025-01-27 23:00 UTC
sudo pacman -S --noconfirm --needed libvorbis-docs  # Эталонная реализация аудиоформата Ogg Vorbis (документация) ; https://archlinux.org/packages/extra/x86_64/libvorbis-docs/ ; https://www.xiph.org/vorbis/ ; 2025-01-27 23:00 UTC
sudo pacman -S --noconfirm --needed libx11  # Клиентская Библиотека управления сеансами X11 ; https://archlinux.org/packages/extra/x86_64/libsm/ ; https://xorg.freedesktop.org/ ; 2025-03-10 13:48 UTC
sudo pacman -S --noconfirm --needed lib32-libsm  # Библиотека управления сеансами X11 (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-libsm/ ; https://xorg.freedesktop.org/ ; 2024-09-07 10:16 UTC
sudo pacman -S --noconfirm --needed mpg123  # (необязательно) – для воспроизведения MP1/MP2/MP3 ; Консольный проигрыватель MPEG Audio Player в реальном времени для уровней 1, 2 и 3 ; https://archlinux.org/packages/extra/x86_64/mpg123/ ; https://mpg123.de/ ; Обеспечивает: libmpg123.so=0-64, libout123.so=0-64, libsyn123.so=0-64 ; 28 июля 2025 г. 18:47 UTC
sudo pacman -S --noconfirm --needed lib32-mpg123  # (необязательно) – для воспроизведения MP1/MP2/MP3 ; Консольный проигрыватель MPEG Audio Player в реальном времени для уровней 1, 2 и 3 (32 бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-mpg123/ ; https://mpg123.de/ ; Обеспечивает: libmpg123.so=0-32, libout123.so=0-32, libsyn123.so=0-32 ; 2025-08-08 09:49 UTC
# sudo pacman -S --noconfirm --needed vlc-plugin-mpg123  # (необязательно) – для воспроизведения MP1/MP2/MP3 ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагин MPG1/2/3 ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-mpg123/ ; https://www.videolan.org/vlc/ ; 2025-07-23 20:53 UTC
sudo pacman -S --noconfirm --needed opus  # (необязательно) – для плагина opus ; Полностью открытый, бесплатный, очень универсальный аудиокодек ; https://archlinux.org/packages/extra/x86_64/opus/ ; https://www.opus-codec.org/ ; Обеспечивает: libopus.so=0-64 ; 2024-04-17 21:45 UTC
sudo pacman -S --noconfirm --needed opusfile  # (необязательно) – для плагина opus ; Библиотека для открытия, поиска и декодирования файлов .opus ; https://archlinux.org/packages/extra/x86_64/opusfile/ ; https://opus-codec.org/ ; 2024-07-13 02:06 UTC
sudo pacman -S --noconfirm --needed opus-tools  # Коллекция инструментов для аудиокодека Opus ; https://wiki.xiph.org/Opus-tools ; https://archlinux.org/packages/extra/x86_64/opus-tools/ ; 2025-02-21 19:56 UTC
sudo pacman -S --noconfirm --needed pulseaudio  # (необязательно) – для выходного плагина PulseAudio ; Функциональный универсальный звуковой сервер ; https://archlinux.org/packages/extra/x86_64/pulseaudio/ ; https://archlinux.org/packages/extra/x86_64/pulseaudio/ ; https://www.freedesktop.org/wiki/Software/PulseAudio/ ; Обеспечивает: pulse-native-провайдер ; Заменяет: pulseaudio-gconf<=11.1, pulseaudio-xen<=9.0 ; Конфликты: с  ; Обратные конфликты:  ; 2024-12-07 17:14 UTC
sudo pacman -S --noconfirm --needed wavpack  # (необязательно) – для плагина wavpack ; Формат сжатия аудио с режимами сжатия без потерь, с потерями и гибридным ; https://archlinux.org/packages/extra/x86_64/wavpack/ ; https://www.wavpack.com/ ; 2025-01-28 20:19 UTC
sudo pacman -S --noconfirm --needed lib32-wavpack  # (необязательно) – для плагина wavpack ; Формат сжатия аудио с режимами сжатия без потерь, с потерями и гибридным (32 бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-wavpack/ ; http://www.wavpack.com/ ; 2025-01-30 21:23 UTC
sudo pacman -S --noconfirm --needed yasm  # (необязательно) – требуется для сборки частей сборки плагина ffap ; Переписанный NASM для поддержки нескольких синтаксисов (NASM, TASM, GAS и т. д.) ; https://archlinux.org/packages/extra/x86_64/yasm/ ; https://www.tortall.net/projects/yasm/ ; 2025-05-19 22:39 UTC
sudo pacman -S --noconfirm --needed zlib # (необязательно) – для плагина Audio Overload (psf, psf2 и т. д.), GME (для vgz) ; Библиотека сжатия, реализующая метод сжатия deflate, используемый в gzip и PKZIP ; https://archlinux.org/packages/core/x86_64/zlib/ ; https://www.zlib.net/ ; 2024-05-03 07:02 UTC
sudo pacman -S --noconfirm --needed libzip # (необязательно) – для плагина vfs_zip ; Библиотека C для чтения, создания и изменения zip-архивов ; https://archlinux.org/packages/extra/x86_64/libzip/ ; https://libzip.org/ ; Обеспечивает: libzip.so=5-64 ; 2025-05-25 07:16 UTC
# sudo pacman -S --noconfirm --needed
# sudo pacman -S --noconfirm --needed
# sudo pacman -S --noconfirm --needed
# sudo pacman -R
# sudo pacman -R  --noconfirm  # --noconfirm   не спрашивать каких-либо подтверждений
################ DeaDBeeF (deadbeef) AUR ##############
############ deadbeef ##########
yay -S deadbeef --noconfirm  # Модульный аудиоплеер GTK для GNU/Linux ; https://aur.archlinux.org/packages/deadbeef ;  ; https://github.com/DeaDBeeF-Player/deadbeef ; 2025-04-02 22:05 (UTC)
############ deadbeef ##########
#echo""
#echo " Установка DeaDBeeF (Модульный аудиоплеер GTK для GNU/Linux) "
#git clone https://aur.archlinux.org/deadbeef.git   # (только для чтения, нажмите, чтобы скопировать) https://aur.archlinux.org/packages/git-hub
#cd deadbeef
# makepkg -fsri
#makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
#rm -Rf deadbeef  # удаляем директорию сборки
# rm -rf deadbeef
  echo ""
  echo " Установка дополнительных плагинов "
  echo " НЕ устанавивать эти дополнительные плагины, Если установлена старая версия 'deadbeef-static-1.8.4-1-x86_64'  "
########### deadbeef-plugin-discord-git ############
yay -S deadbeef-plugin-discord-git --noconfirm  # Плагин DeaDBeeF Discord для расширенного присутствия (Плагин Discord Rich Presence отображает текущий воспроизводимый трек в вашем статусе Discord) ; Плагин подключается к Discord через Discord Rich Presence API, дополнительная аутентификация не требуется. Вы можете настроить отображаемую информацию в настройках плагина https://deadbeef.sourceforge.io/plugins.html ; https://aur.archlinux.org/packages/deadbeef-plugin-discord-git ; https://aur.archlinux.org/deadbeef-plugin-discord-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/kuba160/ddb_discord_presence ; 2024-11-02 03:11 (UTC)
########### deadbeef-plugin-discord-git ############
#git clone https://aur.archlinux.org/deadbeef-plugin-discord-git.git  # (только для чтения, нажмите, чтобы скопировать)
#cd deadbeef-plugin-discord-git
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf deadbeef-plugin-discord-git
#rm -Rf deadbeef-plugin-discord-git
########### deadbeef-plugin-statusnotifier ############
yay -S deadbeef-plugin-statusnotifier --noconfirm  # Плагин для DeaDBeeF, который заменяет значок в трее по умолчанию на тот, который поддерживает протокол StatusNotifierIitem ; https://aur.archlinux.org/packages/deadbeef-plugin-statusnotifier ; https://aur.archlinux.org/deadbeef-plugin-statusnotifier.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/vovochka404/deadbeef-statusnotifier-plugin ; 2025-05-25 10:40 (UTC)
### Этот плагин нацелен на реализацию StatusNotifierItem для DeaDBeeF. Он призван заменить стандартный значок в трее в средах рабочего стола, поддерживающих протокол StatusNotifierIitem. Он также предназначен для предоставления значка в трее для deadbeef в средах рабочего стола, где старые значки xmbedded больше не поддерживаются, например, KDE Plasma 5, GNOME (3+), Cinnamon и т. д.
########### deadbeef-plugin-statusnotifier ############
#git clone https://aur.archlinux.org/deadbeef-plugin-statusnotifier.git  # (только для чтения, нажмите, чтобы скопировать)
#cd deadbeef-plugin-statusnotifier
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf deadbeef-plugin-statusnotifier
#rm -Rf deadbeef-plugin-statusnotifier
  echo ""
  echo " Посмотрите информацию о версии (deadbeef) "
sudo /opt/deadbeef/bin/deadbeef --version # Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
### DeaDBeeF (deadbeef) — Простой музыкальный плеер
# https://deadbeef.sourceforge.io/
# https://deadbeef.sourceforge.io/plugins.html
# https://github.com/DeaDBeeF-Player/deadbeef
# https://github.com/UnitedRPMs/deadbeef
# https://aur.archlinux.org/packages/deadbeef
# https://aur.archlinux.org/deadbeef.git
# Плагины — это дополнительные компоненты, которые расширяют возможности плеера DeaDBeeF новыми функциями.
# Описание функций каждого плагина смотрите по адресу (https://deadbeef.sourceforge.io/plugins.html).
### В сценарии (скрипта) представлен DeaDBeeF - deadbeef 1.10.0-1 (но без русской локализации)(на момент написания). Если вы хотите установить пакет deadbeef с русской локализации deadbeef-static-1.8.4-1-x86_64.pkg.tar (это крайняя версия на русском языке).
# Как установить deadbeef с русской локализации deadbeef-static-1.8.4-1-x86_64.pkg.tar
# 1. Для начала скачайте пакет deadbeef-static-1.8.4-1-x86_64.pkg.tar
# Ссылки и способ установки: (на момент написания Ссылки работают!)
# Пакет: deadbeef-static-1.8.4-1-x86_64.pkg.tar
# https://sourceforge.net/projects/deadbeef/files/travis/linux/1.8.4/deadbeef-static-1.8.4-1-x86_64.pkg.tar.xz/download
# https://sourceforge.net/projects/deadbeef/files/travis/linux/1.8.4/
# https://pkgs.org/download/deadbeef
# 2. Устанавливаем зависимости прописанные в сценарии (скрипта), но пока не установливайте дополнительных плагинов из AUR!
# Так как их зависимостью является сам deadbeef!
# Далее когда все зависимости установлены можно приступить к установке пакета deadbeef-static-1.8.4-1-x86_64.pkg.tar
# Можно установить через терминал с помощью pacman Например:
# sudo pacman -U deadbeef-static-1.8.4-1-x86_64.pkg.tar (или укажить полный путь к пакету установки)
# ИЛИ с помощью Pamac GUI , НАЖАВ ПКМ (Открыть с помощью и выбираем установщик пакетов Archlinux)
# Останется только установить плагины (если таковые нужны) и настроить под свои предпочтения...
# *Важно! НЕ Устанавливайте плагины (deadbeef-plugin-discord-git и deadbeef-plugin-statusnotifier) из сценария скрипта,
# Они предназначены для пакета deadbeef 1.10.0-1 или более новой версии...
#####################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Amberol (amberol) — Музыкальный проигрыватель?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Хотя в мире музыки доминируют потоковые сервисы, это не помешало разработчикам создавать музыкальные плееры для настольных компьютеров. Ищете что-то простое для воспроизведения музыки без лишних функций? ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Amberol — простой музыкальный проигрыватель, который хорошо интегрируется с GNOME в Linux (просто воспроизводит музыку и ничего больше). Amberol — отлично подходит для воспроизведения локальной музыки. Главное достоинство — адаптивный интерфейс, основанный на обложках альбомов. В Amberol нет дополнительных интересных (и полезных) функций, таких как генерация обложек альбомов, редактирование метаданных, отображение текстов песен или плейлистов, а также управление библиотекой. Вряд ли эти функции будут добавлены в будущих версиях. Amberol просто хочет воспроизводить музыку. Amberol написан на Rust и GTK, как и большинство новых приложений GNOME. Адаптивный интерфейс меняет цвет в зависимости от цвета воспроизводимого альбома. Эффект градиента придаёт ему современный и элегантный вид, который, несомненно, станет частью ваших скриншотов в Linux. Разрабатывается в рамках проекта: GNOME; Исходный код: Open Source (открыт); Языки программирования: Rust; Библиотеки: GTK; Приложение переведено на русский язык. Этот проект Лицензируется под GPL-3.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://apps.gnome.org/Amberol/ ; (https://apps.gnome.org/ru/app/io.bassi.Amberol/ ; https://github.com/adamjatim/amberol ; https://archlinux.org/packages/extra/x86_64/amberol/). "
echo -e "${BLUE}:: ${NC}Текущие возможности и особенности: Адаптивный пользовательский интерфейс. Изменение цвета пользовательского интерфейса с помощью обложки альбома. Поддержка добавления папок с музыкой и песнями, а также очистку плейлиста. Функции воспроизведения: воспроизведение/пауза, перемотка назад, переключение треков (следующий/предыдущий), случайное воспроизведение, повтор, изменение громкости. Поддержка перетаскивания для постановки песен в очередь. Интеграция MPRIS. Показать/скрыть плейлист. Поддержка сочетаний клавиш. Поскольку пользовательский интерфейс не имеет традиционной панели управления и меню, это придает приложению унифицированный вид. Он автоматически создаёт плейлист из файлов, имеющихся в добавленной вами папке. Он отображается в левой боковой панели. Продолжительность воспроизведения всего плейлиста отображается в левом верхнем углу. Нажав на значок «правильного» плейлиста, вы можете выбрать песни и удалить их из плейлиста. При желании вы можете скрыть боковую панель плейлиста. "
echo -e "${CYAN}:: ${NC}Amberol предлагает несколько дополнительных вариантов воспроизведения музыки. Вы можете включить режим случайного воспроизведения, чтобы музыка воспроизводилась в случайном порядке. Также можно поставить песню на повтор и слушать её, пока она вам не надоест. Прогресс воспроизведения песен отображается в интерфейсе. Плеер хорошо интегрируется с кнопками управления мультимедиа на клавиатуре. Вы можете воспроизводить/приостанавливать воспроизведение и переключать треки с помощью специальных клавиш управления мультимедиа (если они есть в вашей системе). Меню панели управления в нижней части экрана позволяет добавить файл или папку, а также отображает доступные сочетания клавиш. Здесь вы также можете отключить изменение цвета пользовательского интерфейса в соответствии с обложкой альбома. При первом запуске программа предложит вам добавить музыкальные файлы или папки. Вы также можете перетаскивать файлы. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_amberol  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_amberol" =~ [^10] ]]
do
    :
done
if [[ $in_amberol == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_amberol == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Amberol (amberol) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
############ amberol ##############
sudo pacman -S --noconfirm --needed amberol  # Небольшой и простой звуковой и музыкальный проигрыватель, хорошо интегрированный с GNOME ; https://archlinux.org/packages/extra/x86_64/amberol/ ; https://apps.gnome.org/Amberol/ ; https://github.com/adamjatim/amberol ; 2025-07-30 21:50 UTC
  echo ""
  echo " Посмотрите информацию о версии (amberol) "
sudo pacman -Q amberol  #  Показать версию приложения ; Альтернативный метод — проверить версию установленного пакета NTP через менеджер пакетов системы.
# sudo pacman -Qs имя_пакета  # Используйте команду pacman с -Qs опцией поиска только среди установленных пакетов в системе. Она ищет указанный текст только в названиях и описаниях установленных пакетов.
# sudo pacman -Qi имя_пакета  # Эта -Qi опция отображает подробную информацию об указанном пакете. Она также показывает метаданные пакета, такие как зависимости, конфликты, дата установки, дата сборки, размер и т. д.
# sudo pacman -Si имя_пакета  # Эта -Si опция позволяет просматривать подробную информацию о любых пакетах Arch Linux. Необходимо указать точное название пакета.
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# Amberol — Музыкальный проигрыватель:
# https://apps.gnome.org/Amberol/
# https://apps.gnome.org/ru/app/io.bassi.Amberol/
# https://github.com/adamjatim/amberol
# https://archlinux.org/packages/extra/x86_64/amberol/
####################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить KEW (/kjuː/) (kew) — Музыкальный плеер командной строки?"
echo -e "${YELLOW}==> Примечание! ${BOLD}*Кто-то называет прослушивание музыки своей страстью, а кто-то – средством снятия стресса или частью повседневной жизни. В любом виде прослушивание музыки стало неотъемлемой частью нашей жизни. Музыка играет разные роли в нашей жизни. Если раньше люди слушали музыку по радио, то у нынешнего поколения для этого есть iPod, смартфоны, ПК и другие гаджеты. Если говорить о ПК, то для воспроизведения выбранных нами песен или списков воспроизведения у нас есть специальное программное обеспечение, называемое музыкальными плеерами. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}KEW (/kjuː/) — это музыкальный плеер командной строки, разработанный для среды Linux, позволяющий пользователям слушать музыку прямо в терминале. Он поддерживает различные аудиоформаты, включая MP3, FLAC и OGG, и обладает такими возможностями, как создание плейлистов, воспроизведение без пробелов и поиск в библиотеке по частичным названиям. Этот проект Лицензируется Только GPL-2.0. ${NC}"
echo " Домашняя страница: https://github.com/ravachol/kew ; (https://aur.archlinux.org/packages/kew ; https://aur.archlinux.org/packages/kew-git). "
echo -e "${BLUE}:: ${NC}Функции: Поиск в музыкальной библиотеке по части названий. Создает список воспроизведения на основе соответствующего каталога. Управляйте плеером с помощью кнопок «Предыдущая», «Следующая» и «Пауза». Редактируйте плейлист, добавляя и удаляя песни. Воспроизведение без пауз (между файлами одного формата и типа). Поддерживает аудиоформаты MP3, FLAC, MPEG-4/M4A (AAC), OPUS, OGG, Webm и WAV. Поддерживает события рабочего стола через MPRIS. Конфиденциально, kew не собирает никаких данных. "
echo -e "${CYAN}:: ${NC}Пользователи могут управлять воспроизведением с помощью простых команд и настраивать параметры с помощью файла конфигурации. Инструмент подчеркивает конфиденциальность, так как не собирает данные пользователя, что делает его подходящим выбором для тех, кто ищет легкий и эффективный музыкальный плеер. *Для корректного отображения изображений рекомендуется использовать терминал с поддержкой sixel (или эквивалент), например Konsole или kitty. Полный список поддерживаемых терминалов смотрите на этой странице: Sixels in Terminal (https://www.arewesixelyet.com/). "
echo -e "${CYAN}:: ${NC}Установка Kew (kew) и (kew-git), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/kew.git), (https://aur.archlinux.org/packages/kew-git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить KEW (kew),   2 - Установить KEW (kew-git),

    0 - НЕТ - Пропустить установку: " in_kew  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_kew" =~ [^120] ]]
do
    :
done
if [[ $in_kew == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_kew == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) KEW (kew) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
### Установка зависимостей:
# sudo pacman -Syu --noconfirm --needed pkg-config faad2 taglib fftw git gcc make chafa glib2 opus opusfile libvorbis libogg
sudo pacman -S --noconfirm --needed pkgconf  # (необязательно) ; Набор инструментов для компиляции и компоновки метаданных пакетов ; https://archlinux.org/packages/core/x86_64/pkgconf/ ; https://github.com/pkgconf/pkgconf ; Обеспечивает: libpkgconf.so=7-64, pkg-config, pkgconfig ; Заменяет: pkg-config ; Конфликты: pkg-config ; 2025-06-26 22:54 UTC
sudo pacman -S --noconfirm --needed gcc  # (необязательно) ; Коллекция компиляторов GNU — интерфейсы C и C++ ; https://archlinux.org/packages/core/x86_64/gcc/ ; https://gcc.gnu.org/ ; Обеспечивает: gcc-multilib ; Заменяет: gcc-multilib ; 2025-08-14 14:22 UTC
sudo pacman -S --noconfirm --needed fftw  # Библиотека для вычисления дискретного преобразования Фурье (ДПФ) ; https://archlinux.org/packages/extra/x86_64/fftw/ ; http://www.fftw.org/ ; Обеспечивает: libfftw3.so=3-64, libfftw3_omp.so=3-64, libfftw3_threads.so=3-64, libfftw3f.so=3-64, libfftw3f_omp.so=3-64 ; 2024-05-01 09:21 UTC
sudo pacman -S --noconfirm --needed chafa  # — вывод изображения в формате ASCII-арта ; Конвертер изображений в текст, поддерживающий широкий спектр символов и палитр, прозрачности, анимации и т. д. ; https://archlinux.org/packages/extra/x86_64/chafa/ ; https://hpjansson.org/chafa/ ; Обеспечивает: libchafa.so=0-64 ; 2025-08-01 18:46 UTC
sudo pacman -S --noconfirm --needed glibc  # Библиотека GNU C ; https://archlinux.org/packages/core/x86_64/glibc/ ; https://www.gnu.org/software/libc ; 2025-08-01 21:44 UTC
sudo pacman -S --noconfirm --needed glib2  # Базовая библиотека низкого уровня ; https://archlinux.org/packages/gnome-unstable/x86_64/glib2/ ; https://gitlab.gnome.org/GNOME/glib ; Обеспечивает:  libgio-2.0.so=0-64, libgirepository-2.0.so=0-64, libglib-2.0.so=0-64, libgmodule-2.0.so=0-64, libgobject-2.0.so=0-64, libgthread-2.0.so=0-64 ; 2025-07-24 14:23 UTC
sudo pacman -S --noconfirm --needed libogg  # Библиотека битового потока и кадрирования Ogg ; https://archlinux.org/packages/extra/x86_64/libogg/ ; https://www.xiph.org/ogg/ ; 2025-07-14 22:59 UTC ; 2025-07-14 22:59 UTC
sudo pacman -S --noconfirm --needed lib32-libogg  # Библиотека битового потока и кадрирования Ogg (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-libogg/ ; https://www.xiph.org/ogg/ ; Обеспечивает: libogg.so=0-32 ; 2025-08-05 02:04 UTC
sudo pacman -S --noconfirm --needed libvorbis  # Эталонная реализация аудиоформата Ogg Vorbis ; https://archlinux.org/packages/extra/x86_64/libvorbis/ ; https://www.xiph.org/vorbis/ ; Обеспечивает: libvorbis.so=0-64, libvorbisenc.so=2-64, libvorbisfile.so=3-64 ; 2025-01-27 23:00 UTC
sudo pacman -S --noconfirm --needed lib32-libvorbis  # Эталонная реализация аудиоформата Ogg Vorbis (32 бита) ; https://archlinux.org/packages/multilib/x86_64/lib32-libvorbis/ ; https://www.xiph.org/vorbis/ ; Обеспечивает: libvorbis.so=0-32, libvorbisenc.so=2-32, libvorbisfile.so=3-32 ; 2025-01-27 23:00 UTC
sudo pacman -S --noconfirm --needed opus  # – для плагина opus ; Полностью открытый, бесплатный, очень универсальный аудиокодек ; https://archlinux.org/packages/extra/x86_64/opus/ ; https://www.opus-codec.org/ ; Обеспечивает: libopus.so=0-64 ; 2024-04-17 21:45 UTC
sudo pacman -S --noconfirm --needed lib32-opus  # Полностью открытый, бесплатный, очень универсальный аудиокодек (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-opus/ ; https://www.opus-codec.org/ Обеспечивает: libopus.so=0-32 ; 2024-04-17 21:45 UTC
sudo pacman -S --noconfirm --needed opusfile  # – для плагина opus ; Библиотека для открытия, поиска и декодирования файлов .opus ; https://archlinux.org/packages/extra/x86_64/opusfile/ ; https://opus-codec.org/ ; 2024-07-13 02:06 UTC
sudo pacman -S --noconfirm --needed opus-tools  # Коллекция инструментов для аудиокодека Opus ; https://wiki.xiph.org/Opus-tools ; https://archlinux.org/packages/extra/x86_64/opus-tools/ ; 2025-02-21 19:56 UTC
sudo pacman -S --noconfirm --needed taglib  # (необязательно) – для использования плагина musepack ; Библиотека для чтения и редактирования метаданных нескольких популярных аудиоформатов ; https://archlinux.org/packages/extra/x86_64/taglib/ ; https://taglib.github.io/ ; 2025-06-30 06:37 UTC
sudo pacman -S --noconfirm --needed lib32-taglib  # (необязательно) – для использования плагина musepack ; Библиотека для чтения и редактирования метаданных нескольких популярных аудиоформатов (32 бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-taglib/ ; https://developer.kde.org/~wheeler/taglib.html ; 2024-09-13 22:12 UTC
sudo pacman -S --noconfirm --needed faad2  # (необязательно) — декодирование AAC ; Бесплатный декодер Advanced Audio (AAC) ; https://archlinux.org/packages/extra/x86_64/faad2/ ; https://github.com/knik0/faad2 ; Обеспечивает: faad, libfaad.so=2-64, libfaad_drm.so=2-64 ; 2025-03-04 09:01 UTC
# Faad2 необязателен - По умолчанию система сборки автоматически определяет его faad2 наличие и включает его, если он найден.
########### kew ###########
yay -S kew --noconfirm  # Терминальный музыкальный проигрыватель ; https://aur.archlinux.org/packages/kew ; https://aur.archlinux.org/kew.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/ravachol/kew ; Заменяет: cue-music-command ; https://github.com/ravachol/kew/archive/v3.4.1.tar.gz ; Конфликты: kew-git ; 2025-08-19 15:51 (UTC)
########### kew ###########
#git clone https://aur.archlinux.org/kew.git  # (только для чтения, нажмите, чтобы скопировать)
#cd kew
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf kew
#rm -Rf kew
  echo ""
  echo " Посмотрите информацию о версии (kew) "
kew --version  # Показать версию приложения
sudo pacman -Q kew  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_kew == 2 ]]; then
  echo ""
  echo " Установка утилиты (пакета) KEW (kew-git) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
### Установка зависимостей:
# sudo pacman -Syu --noconfirm --needed pkg-config faad2 taglib fftw git gcc make chafa glib2 opus opusfile libvorbis libogg
sudo pacman -S --noconfirm --needed pkgconf  # (необязательно) ; Набор инструментов для компиляции и компоновки метаданных пакетов ; https://archlinux.org/packages/core/x86_64/pkgconf/ ; https://github.com/pkgconf/pkgconf ; Обеспечивает: libpkgconf.so=7-64, pkg-config, pkgconfig ; Заменяет: pkg-config ; Конфликты: pkg-config ; 2025-06-26 22:54 UTC
sudo pacman -S --noconfirm --needed gcc  # (необязательно) ; Коллекция компиляторов GNU — интерфейсы C и C++ ; https://archlinux.org/packages/core/x86_64/gcc/ ; https://gcc.gnu.org/ ; Обеспечивает: gcc-multilib ; Заменяет: gcc-multilib ; 2025-08-14 14:22 UTC
sudo pacman -S --noconfirm --needed fftw  # Библиотека для вычисления дискретного преобразования Фурье (ДПФ) ; https://archlinux.org/packages/extra/x86_64/fftw/ ; http://www.fftw.org/ ; Обеспечивает: libfftw3.so=3-64, libfftw3_omp.so=3-64, libfftw3_threads.so=3-64, libfftw3f.so=3-64, libfftw3f_omp.so=3-64 ; 2024-05-01 09:21 UTC
sudo pacman -S --noconfirm --needed chafa  # — вывод изображения в формате ASCII-арта ; Конвертер изображений в текст, поддерживающий широкий спектр символов и палитр, прозрачности, анимации и т. д. ; https://archlinux.org/packages/extra/x86_64/chafa/ ; https://hpjansson.org/chafa/ ; Обеспечивает: libchafa.so=0-64 ; 2025-08-01 18:46 UTC
sudo pacman -S --noconfirm --needed glibc  # Библиотека GNU C ; https://archlinux.org/packages/core/x86_64/glibc/ ; https://www.gnu.org/software/libc ; 2025-08-01 21:44 UTC
sudo pacman -S --noconfirm --needed glib2  # Базовая библиотека низкого уровня ; https://archlinux.org/packages/gnome-unstable/x86_64/glib2/ ; https://gitlab.gnome.org/GNOME/glib ; Обеспечивает:  libgio-2.0.so=0-64, libgirepository-2.0.so=0-64, libglib-2.0.so=0-64, libgmodule-2.0.so=0-64, libgobject-2.0.so=0-64, libgthread-2.0.so=0-64 ; 2025-07-24 14:23 UTC
sudo pacman -S --noconfirm --needed libogg  # Библиотека битового потока и кадрирования Ogg ; https://archlinux.org/packages/extra/x86_64/libogg/ ; https://www.xiph.org/ogg/ ; 2025-07-14 22:59 UTC ; 2025-07-14 22:59 UTC
sudo pacman -S --noconfirm --needed lib32-libogg  # Библиотека битового потока и кадрирования Ogg (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-libogg/ ; https://www.xiph.org/ogg/ ; Обеспечивает: libogg.so=0-32 ; 2025-08-05 02:04 UTC
sudo pacman -S --noconfirm --needed libvorbis  # Эталонная реализация аудиоформата Ogg Vorbis ; https://archlinux.org/packages/extra/x86_64/libvorbis/ ; https://www.xiph.org/vorbis/ ; Обеспечивает: libvorbis.so=0-64, libvorbisenc.so=2-64, libvorbisfile.so=3-64 ; 2025-01-27 23:00 UTC
sudo pacman -S --noconfirm --needed lib32-libvorbis  # Эталонная реализация аудиоформата Ogg Vorbis (32 бита) ; https://archlinux.org/packages/multilib/x86_64/lib32-libvorbis/ ; https://www.xiph.org/vorbis/ ; Обеспечивает: libvorbis.so=0-32, libvorbisenc.so=2-32, libvorbisfile.so=3-32 ; 2025-01-27 23:00 UTC
sudo pacman -S --noconfirm --needed opus  # – для плагина opus ; Полностью открытый, бесплатный, очень универсальный аудиокодек ; https://archlinux.org/packages/extra/x86_64/opus/ ; https://www.opus-codec.org/ ; Обеспечивает: libopus.so=0-64 ; 2024-04-17 21:45 UTC
sudo pacman -S --noconfirm --needed lib32-opus  # Полностью открытый, бесплатный, очень универсальный аудиокодек (32-бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-opus/ ; https://www.opus-codec.org/ Обеспечивает: libopus.so=0-32 ; 2024-04-17 21:45 UTC
sudo pacman -S --noconfirm --needed opusfile  # – для плагина opus ; Библиотека для открытия, поиска и декодирования файлов .opus ; https://archlinux.org/packages/extra/x86_64/opusfile/ ; https://opus-codec.org/ ; 2024-07-13 02:06 UTC
sudo pacman -S --noconfirm --needed opus-tools  # Коллекция инструментов для аудиокодека Opus ; https://wiki.xiph.org/Opus-tools ; https://archlinux.org/packages/extra/x86_64/opus-tools/ ; 2025-02-21 19:56 UTC
sudo pacman -S --noconfirm --needed taglib  # (необязательно) – для использования плагина musepack ; Библиотека для чтения и редактирования метаданных нескольких популярных аудиоформатов ; https://archlinux.org/packages/extra/x86_64/taglib/ ; https://taglib.github.io/ ; 2025-06-30 06:37 UTC
sudo pacman -S --noconfirm --needed lib32-taglib  # (необязательно) – для использования плагина musepack ; Библиотека для чтения и редактирования метаданных нескольких популярных аудиоформатов (32 бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-taglib/ ; https://developer.kde.org/~wheeler/taglib.html ; 2024-09-13 22:12 UTC
sudo pacman -S --noconfirm --needed faad2  # (необязательно) — декодирование AAC ; Бесплатный декодер Advanced Audio (AAC) ; https://archlinux.org/packages/extra/x86_64/faad2/ ; https://github.com/knik0/faad2 ; Обеспечивает: faad, libfaad.so=2-64, libfaad_drm.so=2-64 ; 2025-03-04 09:01 UTC
# Faad2 необязателен - По умолчанию система сборки автоматически определяет его faad2 наличие и включает его, если он найден.
########### kew-git ###########
yay -S kew-git --noconfirm  #  ; https://aur.archlinux.org/packages/kew-git  ; https://aur.archlinux.org/kew-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/ravachol/kew ; git+https://github.com/ravachol/kew ; Конфликты: kew ; Заменяет: cue-git ; 2025-08-21 18:32 (UTC)
########### kew-git ###########
#git clone https://aur.archlinux.org/kew-git.git  # (только для чтения, нажмите, чтобы скопировать)
#cd kew-git
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf kew-git
#rm -Rf kew-git
  echo ""
  echo " Посмотрите информацию о версии (kew) "
kew --version  # Показать версию приложения
sudo pacman -Q kew-git  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# KEW (/kjuː/) (kew) — это терминальный музыкальный проигрыватель.
# https://github.com/ravachol/kew
# https://aur.archlinux.org/packages/kew
# https://aur.archlinux.org/kew.git
# https://aur.archlinux.org/packages/kew-git
# https://aur.archlinux.org/kew-git.git (только для чтения, нажмите, чтобы скопировать)
### Использование:
# Запустите kew. Сначала он поможет вам указать путь к папке с музыкой, а затем покажет её содержимое.
# kew также можно приказать воспроизвести определённую музыку из командной строки. Программа автоматически создаёт плейлист на основе части названия трека или каталога:
# kew cure great - Эта команда воспроизводит все песни из каталога «The Cure Greatest Hits», если он есть в вашей музыкальной библиотеке.
# kew возвращает первый каталог или файл, имя которого совпадает с указанной строкой. Лучше всего это работает, если ваша музыкальная библиотека организована следующим образом: папка исполнителя -> папка(и) альбома -> трек(и).
### Некоторые примеры:
# kew (starting kew with no arguments opens the library view where you can choose what to play)
# kew all (plays all songs, up to 20 000, in your library, shuffled)
# kew albums (plays all albums, up to 2000, randomly one after the other)
# kew moonlight son (finds and plays moonlight sonata)
# kew moon (finds and plays moonlight sonata)
# kew beet (finds and plays all music files under "beethoven" directory)
# kew dir <album name> (sometimes, if names collide, it's necessary to specify it's a directory you want)
# kew song <song> (or a song)
# kew list <playlist> (or a playlist)
# kew shuffle <album name> (shuffles the playlist. shuffle needs to come first.)
# kew artistA:artistB:artistC (plays all three artists, shuffled)
# kew --help, -? or -h
# kew --version or -v
# kew --nocover
# kew --noui (completely hides the UI)
# kew -q <song>, --quitonstop (exits after finishing playing the playlist)
# kew -e <song>, --exact (specifies you want an exact (but not case sensitive) match, of for instance an album)
# kew . loads kew favorites.m3u
# kew path "/home/joe/Musik/" (changes the path)
# Вставьте одинарные кавычки внутри кавычек "guns n' roses".
### Просмотры:
# Добавьте песни в плейлист в представлении «Библиотека» F3.
# Просмотрите плейлист и выберите песни в окне просмотра плейлиста F2.
# Информацию о песне и обложку смотрите в разделе «Просмотр дорожек» F4.
# Поиск музыки в Поисковом представлении F5.
# См. справку в разделе «Просмотр справки» F7.
# Вы можете выбрать всю музыку, нажав на заголовок «МУЗЫКАЛЬНАЯ БИБЛИОТЕКА» в верхней части окна «Библиотека».
### Привязки клавиш:
# Enter для выбора или повторного воспроизведения песни.
# Используйте клавиши +(или =) -для регулировки громкости.
# Для переключения треков используйте клавиши <, >или h.l
# Space или pправая кнопка мыши для воспроизведения или паузы.
# Alt+s остановиться.
# F2или Shift+z(macOS/Android) для отображения/скрытия списка воспроизведения.
# F3или Shift+x(macOS/Android) для отображения/скрытия вида библиотеки.
# F4или Shift+c(macOS/Android) для отображения/скрытия вида трека.
# F5или Shift+v(macOS/Android) для отображения/скрытия представления поиска.
# F6или Shift+b(macOS/Android) для отображения/скрытия вида назначенных клавиш.
# u для обновления библиотеки.
# v для переключения визуализатора спектра.
# i переключаться между использованием обычной цветовой схемы и цветами, полученными из обложки трека.
# b для переключения обложек альбомов, нарисованных в формате ASCII или в виде обычного изображения.
# r для повтора текущей песни после воспроизведения.
# s для перемешивания плейлиста.
# a искать назад.
# d стремиться вперед.
# x сохранить текущий загруженный плейлист в файл m3u в вашей музыкальной папке.
# Tab для перехода к следующему виду.
# Shift+Tab чтобы переключиться на предыдущий вид.
# Backspace чтобы очистить плейлист.
# Delete для удаления одной записи из плейлиста.
# t, gдля перемещения песен вверх или вниз по плейлисту.
# цифра + Gили Enter для перехода к определенному номеру песни в плейлисте.
# .для добавления текущей воспроизводимой песни в kew favorites.m3u (запустите с помощью «kew .»).
# Esc бросить курить.
# Конфигурация: kew создаст файл конфигурации kewrc в папке kew в каталоге конфигурации по умолчанию, например, ~/.config/kew или ~/Library/Preferences/kew в macOS. Там вы можете изменить некоторые настройки, например, назначения клавиш и цвета по умолчанию для приложения. Чтобы отредактировать этот файл, сначала закройте kew.
# Избранные плейлисты: Чтобы добавить песню в избранное, нажмите «.» во время её воспроизведения. Песня будет добавлена в плейлист «kew favorites.m3u». Затем вы можете воспроизвести этот плейлист, набрав «kew .» или «kew list kew favorites».
# Шрифты для ботаников: Кью выглядит лучше со шрифтами Nerd Fonts: https://www.nerdfonts.com/ .
################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить CMus (С* Music Player) (cmus) — Консольный музыкальный плеер?"
echo -e "${YELLOW}==> Примечание! ${BOLD}*cmus был разработан для работы только с текстовым пользовательским интерфейсом, что позволило сократить ресурсы, необходимые для запуска приложения на старых компьютерах, а также на системах, где не установлен X Window System. Скорость работы и эффективность консольного приложения не могут не отразиться на пользовательском интерфейсе, который не отличается особым блеском. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}CMus (С* Music Player) — консольный музыкальный плеер для Linux, работающий в терминале. CMus написан на языке программирования C (отсюда происходит и название плеера — CMus). Консольный базис позволяет Cmus быстро загружаться даже при большом количестве песен. Он поддерживает различные аудиоформаты, включая Ogg, MP3, WAV, MPEG-4/AAC и WMA. Кроме того, Cmus может управляться с помощью программы cmus-remote и, как известно, работает на многих Unix-подобных операционных системах, таких как FreeBSD, OpenBSD и Cygwin. Этот проект Лицензируется Только GPL-2.0. ${NC}"
echo " Домашняя страница: https://cmus.github.io/ ; (https://archlinux.org/packages/extra/x86_64/cmus/ ; https://itshaman.ru/category/cmus/ ; https://itsfoss.com/cmus-linux-terminal-music-player/). "
echo -e "${BLUE}:: ${NC}Особенности Cmus: Добавлена поддержка многих аудиоформатов, включая MP3, MPEG, WMA, ALAC, Ogg Vorbis, FLAC, WavPack, Musepack, Wav, TTA, SHN и MOD. Более быстрый запуск при работе с тысячами треков. Поддержка непрерывного воспроизведения и ReplayGain. Передача Ogg и MP3 треков с Icecast и Shoutcast. Сильные фильтры музыкальной библиотеки и фильтрация в реальном времени. Очередь воспроизведения и отличная работа с компиляциями. Простой в использовании браузер каталогов и настраиваемые цвета с динамическими привязками клавиш. Добавлен режим поиска в стиле Vi и командный режим с завершением на Tab. Легко управляется с помощью команды cmus-remote (сокет UNIX или TCP/IP). Работает на Unix-подобных системах, включая Linux, OS X, FreeBSD NetBSD, OpenBSD и Cygwin. Клавиши для управления воспроизведением: cmus предоставляет множество клавиш для управления воспроизведением, вот некоторые основные клавиши cmus для управления воспроизведением: Переключение воспроизведения/паузы. Воспроизведение следующей дорожки. Воспроизвести предыдущую дорожку. Остановить воспроизведение. Очистить список воспроизведения. Переключить режим тасования. Переключить режим повтора или : Увеличить громкость. Для получения справки по использованию программы воспользуйтесь man: man cmus-tutorial; man cmus; man cmus-remote . "
echo -e "${CYAN}:: ${NC}Программа поддерживает все основные аудио-форматы, включая MP3, OGG, FLAC, WAV, MP4, Audio CD и другие. CMus поддерживает работу с плейлистами, фильтрацию и поиск по плейлистам. Поддерживается потоковое воспроизведение. Есть возможность использовать подписки Last.fm и Libre.fm (через скрипты). Управление CMus осуществляется с помощью команд, вводимых с клавиатуры. Режим ввода команд схож со стилем Vi. Чтобы ввести команду нужно нажать двоеточие (:), а затем вводить команду. Поддерживается автодополнение и пролистывание команд клавишей Tab. Программа может работать с очень большими плейлистами. На сайте разработчиков указано, что CMus мгновенно запускается даже с тысячами аудио-файлов. Интерфейс у CMus простой и довольно понятный. Можно настраивать цвета и шрифты. Возможности программы можно расширить с помощью скриптов (см. официальный WiKi https://github.com/cmus/cmus/wiki). "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_cmus  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_cmus" =~ [^10] ]]
do
    :
done
if [[ $in_cmus == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_cmus == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) CMus (С* Music Player) (cmus) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########### cmus ###########
sudo pacman -S --noconfirm --needed cmus  # Многофункциональный музыкальный проигрыватель на базе ncurses ; https://archlinux.org/packages/extra/x86_64/cmus/ ; https://cmus.github.io/ ; https://itshaman.ru/category/cmus/ ; https://itsfoss.com/cmus-linux-terminal-music-player/ ; https://itshaman.ru/it-programmy-dlya-linux/4178/cmus-konechnyi-terminalnyi-audiopleer-dlya-linux ; 2025-04-16 03:42 UTC
  echo ""
  echo " Посмотрите информацию о версии (cmus) "
cmus --version  # Показать версию приложения
sudo pacman -Q cmus  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# CMus (С* Music Player) (cmus):
# https://cmus.github.io/
# https://itshaman.ru/category/cmus/
# https://archlinux.org/packages/extra/x86_64/cmus/
# https://itshaman.ru/it-programmy-dlya-linux/4178/cmus-konechnyi-terminalnyi-audiopleer-dlya-linux
# https://itsfoss.com/cmus-linux-terminal-music-player/
### После завершения установки вы можете запустить cmus, набрав cmus в терминале, который запустится и откроет вид альбома/артиста. Добавление музыки в cmus – простой процесс, просто нажмите клавишу 5 на клавиатуре, чтобы переключиться в режим просмотра библиотеки. Выберите папку с помощью клавиш со стрелками и нажмите , чтобы перейти в каталог, где хранятся все ваши аудиофайлы. Выберите папку с помощью клавиш со стрелками и нажмите Enter, чтобы перейти в каталог, где хранятся все ваши аудиофайлы. Для добавления аудиофайлов в библиотеку используйте клавиши со стрелками для выбора файла или папки и нажмите клавишу A, которая переместит вас на следующую строку, что позволяет быстро добавить много файлов или папок. Начните добавлять файлы или папки, нажав A на вашей библиотеке. После добавления музыкальных файлов сохраните их, набрав: save в командной строке cmus и нажав Enter.
### Клавиши для управления воспроизведением:
# cmus предоставляет множество клавиш для управления воспроизведением, вот некоторые основные клавиши cmus для управления воспроизведением:
# Space: Переключение воспроизведения/паузы.
# N: Воспроизведение следующей дорожки.
# U: Воспроизвести предыдущую дорожку.
# Z: Остановить воспроизведение.
# X: Очистить список воспроизведения.
# S: Переключить режим тасования.
# R: Переключить режим повтора.
# < или >: Увеличить громкость.
####################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить MPD (mpd) - Серверное приложение для воспроизведения музыки?"
echo -e "${YELLOW}==> Примечание! ${BOLD}*Поговорим о универсальном MPD: Демон музыкального проигрывателя по оригинальному названию на английском языке. Согласно ArchLinux Wiki, MPD это аудиоплеер, который управляет архитектурой сервер-клиент. MPD он работает в фоновом режиме как демон, управляет списками воспроизведения и базой данных и использует очень мало ресурсов. Для использования графического интерфейса требуется дополнительный клиент. Считаю, что это отличный сервис из-за широты возможностей его использования и особенно из-за низкого потребления. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Music Player Daemon (MPD) — музыкальный проигрыватель с клиент-серверной архитектурой, который воспроизводит музыку из указанного каталога. Воспроизведением управляют при помощи клиента. Управлять сервером (демоном) можно с любой машины из сети, но слушать музыку можно и на своём компьютере, если программу-клиент MPD настроить на подключение к локальному хосту (localhost). Этот проект Лицензируется под BSD-2-Clause, GPL-2.0-или-более-поздняя, ISC, LGPL-2.1-только. ${NC}"
echo " Домашняя страница: https://www.musicpd.org/ ; (https://github.com/MusicPlayerDaemon/MPD ; https://archlinux.org/packages/extra/x86_64/mpd/). "
echo -e "${BLUE}:: ${NC}Такая технология имеет ряд преимуществ. Для работы MPD не нужна X Window System, поэтому перезапуск X или закрытие программы-клиента не влияет на проигрывание (есть и клиенты, которые могут работать в командной строке, например, mpc и ncmpc); на сервере с MPD может даже не быть монитора. Воспроизведением можно управлять с других компьютеров, а также мобильных устройств (есть клиентские приложения для iOS, Android, Symbian и многих других платформ). Управлять воспроизведением музыки можно не только через локальную сеть, но и через Интернет (конфигурационный файл позволяет задать, на каких именно сетевых интерфейсах должен работать сервер). Даже если установка клиентского приложения на устройство, с которого необходимо управлять воспроизведением, по каким-то причинам невозможна, то остаётся возможность установить такое клиентское приложение, к которому можно обращаться с других узлов через веб-браузер. MPD использует базу данных (как и некоторые другие медиаплееры), чтобы хранить основную информацию о музыкальных файлах (название трека, исполнителя, название альбома и пр.). Как только демон запущен, база данных будет полностью сохранена в оперативной памяти, и нет никакой необходимости обращаться к диску с целью поиска песни и прочтения тегов аудиофайла. Демон для воспроизведения музыки различных форматов. Музыка воспроизводится через аудиоустройство сервера. Демон хранит информацию обо всей доступной музыке, и эту информацию можно легко искать и извлекать. Управление проигрывателем, извлечение информации и управление плейлистами можно осуществлять удаленно. MPD (mpd) *БУДЕТ установлен вместе с пакетом (mpc) - Минималистичный интерфейс командной строки для MPD. "
echo -e "${CYAN}:: ${NC}*NCurses Music Player Client (Plus Plus) пакет ncmpcpp – многофункциональный MPD-клиент на базе ncurses, вдохновлённый ncmpc. Проект официально находится в режиме обслуживания. Я (Анджей Рыбчак) всё ещё пользуюсь им ежедневно, но для меня он уже полностью функционален, и у меня очень мало времени на отслеживание ошибок и открытые запросы на включение изменений. Никаких новых, существенных функций ожидать не стоит (по крайней мере, от меня). Однако, если обнаружатся серьёзные ошибки или проект полностью перестанет компилироваться из-за новых, несовместимых версий зависимостей, это будет исправлено. *Основные характеристики: редактор тегов, редактор плейлистов, простая в использовании поисковая система, медиабиблиотека, визуализатор музыки, возможность извлечения информации об исполнителе из last.fm , новый режим отображения, альтернативный пользовательский интерфейс, возможность просматривать и добавлять файлы из-за пределов музыкального каталога MPD… и множество других мелких функций. Дополнительные функции можно включить, указав их при настройке. Например, чтобы включить запуск визуализатора ./configure --enable-visualizer. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_mpd  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_mpd" =~ [^10] ]]
do
    :
done
if [[ $in_mpd == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_mpd == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Music Player Daemon (MPD) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########### mpd ############
sudo pacman -S --noconfirm --needed mpd # Гибкое, мощное серверное приложение для воспроизведения музыки https://archlinux.org/packages/extra/x86_64/mpd/ ; https://github.com/MusicPlayerDaemon/MPD ; https://www.musicpd.org/ ; 2025-07-31 21:53 UTC
sudo pacman -S --noconfirm --needed mpc  # Минималистичный интерфейс командной строки для MPD ; https://www.musicpd.org/clients/mpc/ ; https://archlinux.org/packages/extra/x86_64/mpc/ ; 2023-12-22 19:49 UTC
# sudo pacman -S --noconfirm --needed ncmpcpp  # Функциональный MPD-клиент на базе ncurses, вдохновленный ncmpc - Практически точный клон ncmpc с некоторыми новыми функциями: https://wiki.archlinux.org/title/Ncmpcpp ; https://archlinux.org/packages/extra/x86_64/ncmpcpp/ ; https://github.com/ncmpcpp/ncmpcpp ; 2025-05-02 22:28 UTC
# sudo pacman -S --noconfirm --needed ncmpc  # Полнофункциональный клиент MPD, работающий в терминале ; https://archlinux.org/packages/extra/x86_64/ncmpc/ ; https://www.musicpd.org/clients/ncmpc/ ; 2025-02-18 19:58 UTC
  echo ""
  echo " Посмотрите информацию о версии (mpd) "
# mpd --version  # Показать версию приложения
sudo pacman -Q mpd  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
### Music Player Daemon (MPD)
# https://www.musicpd.org/
# https://github.com/MusicPlayerDaemon/MPD
# https://archlinux.org/packages/extra/x86_64/mpd/
# NCurses Music Player Client (Plus Plus)
# https://github.com/ncmpcpp/ncmpcpp
# Настройка MPD (mpd) и NCurses Music Player Client (Plus Plus) пакет ncmpcpp
# https://blog.desdelinux.net/ru/mpd-%D1%83%D0%BD%D0%B8%D0%B2%D0%B5%D1%80%D1%81%D0%B0%D0%BB%D1%8C%D0%BD%D1%8B%D0%B9-%D0%B4%D1%8C%D1%8F%D0%B2%D0%BE%D0%BB-%D0%B4%D0%BB%D1%8F-%D0%BC%D1%83%D0%B7%D1%8B%D0%BA%D0%B8/
#####################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Sonata (sonata) — Графический GTK+3 клиент для MPD?"
echo -e "${YELLOW}==> Примечание! ${BOLD}*Sonata изначально была ответвлением проекта Pygmy и распространяется по лицензии GPLv3 или более поздней. Спасибо Эндрю Конклингу и его коллегам за их кропотливую работу над Pygmy! ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Sonata — это элегантный и интуитивно понятный интерфейс на GTK+ для управления вашей музыкальной коллекцией через Music Player Daemon (MPD). Большинство действий доступны через всплывающие меню, вызываемые правой кнопкой мыши. Sonata написана с использованием языка программирования Python и использует инструментарий GTK 3. В развёрнутом виде интерфейс с вкладками включает текущий плейлист, информацию о текущей песне, вашу библиотеку (по папкам, жанрам, исполнителям или альбомам), сохранённые плейлисты и любые потоки (поддерживаются форматы pls/m3u). Вы можете изменить порядок вкладок, перетаскивая их, и скрыть любую из них с помощью всплывающего меню. Главное окно можно свернуть в мини- окно или развернуть, щелкнув по текущей песне (со значком > рядом с ней). Этот проект Лицензируется под GPL3. ${NC}"
echo " Домашняя страница: https://github.com/multani/sonata ; (https://aur.archlinux.org/packages/sonata ; https://www.nongnu.org/sonata/documentation.html). "
echo -e "${BLUE}:: ${NC}Sonata включающий в себя: Развернутые и свернутые виды, полноэкранный режим обложек альбомов. Автоматическое удаленное и локальное создание обложек альбомов. Просмотр библиотеки по папкам или по жанру/исполнителю/альбому. Настраиваемые пользователем столбцы. Автоматическое получение текстов песен и обложек. Поддержка плейлистов и потоковой передачи. Поддержка редактирования тегов песен. Копирование файлов методом перетаскивания. Всплывающее уведомление. Поиск в библиотеках и плейлистах, фильтрация по мере ввода текста. Поддержка Audioscrobbler (Last.fm) 1.2 . Несколько профилей MPD. Удобно для клавиатуры. Поддержка мультимедийных клавиш. Управление командной строкой. Доступно на 24 языках. "
echo -e "${CYAN}:: ${NC}Основные части интерфейса: *Обложка альбома: Здесь с помощью всплывающего меню вы можете выбрать удаленный или локальный файл изображения или перейти к полноэкранному просмотру обложки альбома. *Управление воспроизведением: Sonata передаёт команды воспроизведения в MPD. Вы можете осуществлять перемотку по текущему треку, нажимая на индикатор выполнения. Уровень громкости задаётся в файле конфигурации MPD. *Настройки: Здесь вы можете настроить Sonata по своему вкусу. Вы также можете добавить профили подключения к удалённым серверам MPD, а также активировать поддержку аудиоскробблинга ( Last.fm ), кроссфейдинга треков в MPD и файла статуса текущего воспроизведения. *Текущая вкладка: MPD воспроизводит песни из текущего плейлиста. Вы можете добавлять треки из библиотеки, плейлистов или потоков. Вы также можете сохранять треки в плейлист. Нажатие / (или просто начало ввода текста) открывает текстовый фильтр для треков. *Вкладка «Информация»: Информация о воспроизводимом в данный момент треке содержит теги песен, информацию об альбоме и тексты песен. *Вкладка «Библиотека»: Это библиотека ваших музыкальных файлов, о которой знает MPD. Верхняя папка указывается в файле конфигурации MPD, и вы можете использовать команду «Обновить» во всплывающем меню, чтобы MPD проверил наличие изменений. Если файлы находятся локально, здесь можно открыть редактор тегов. Щелкнув значок в левом нижнем углу, вы можете выбрать просмотр библиотеки, начиная с верхней папки, или из списка жанров, исполнителей или альбомов. Выбрав тип поиска в нижнем центре и введя текст в текстовое поле в правом нижнем углу, вы можете искать треки. *Вкладка «Плейлисты»: В MPD есть папка с плейлистами. Здесь вы можете переименовывать и удалять существующие плейлисты. *Вкладка «Потоки»: Sonata хранит для вас список интернет-потоков. Вы можете управлять записями здесь. Имя можно выбрать произвольно, URL-адрес потока должен указывать либо непосредственно на поток, который может воспроизводить MPD, либо на документ m3u/pls со списком таких потоков. *Значок состояния в трее: Значок состояния в системном трее (если он есть на панелях вашего рабочего стола) позволяет отображать и скрывать главное окно Sonata щелчком мыши. Колесо прокрутки управляет громкостью. Всплывающее меню содержит элементы управления воспроизведением, а также команду выхода из Sonata. *Редактор тегов: Вы можете выбрать один или несколько файлов на вкладках «Текущий» и «Библиотека» и редактировать их метатеги в Sonata, если это локальные файлы. "
echo -e "${CYAN}:: ${NC}Установка Sonata (sonata) и (sonata-git), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/sonata.git), (https://aur.archlinux.org/sonata-git.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой !"
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_sonata  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_sonata" =~ [^10] ]]
do
    :
done
if [[ $in_sonata == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_sonata == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Sonata (sonata) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########## sonata ##########
yay -S sonata --noconfirm  # Элегантный музыкальный клиент GTK+3 для MPD ; https://aur.archlinux.org/packages/sonata ; https://aur.archlinux.org/sonata.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/multani/sonata ; https://github.com/multani/sonata/archive/refs/tags/v1.7.1.tar.gz ; 2025-05-04 17:38 (UTC)
# yay -S sonata-git --noconfirm  # Элегантный музыкальный клиент GTK+3 для MPD (версия Git) ; https://aur.archlinux.org/packages/sonata-git ; https://aur.archlinux.org/sonata-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/multani/sonata ; git+https://github.com/multani/sonata.git ; Конфликты: sonata ; Обеспечивает: sonata ; 2022-04-06 16:04 (UTC)
########## sonata ##########
#git clone https://aur.archlinux.org/sonata.git  # (только для чтения, нажмите, чтобы скопировать)
#cd sonata
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf sonata
#rm -Rf sonata
  echo ""
  echo " Посмотрите информацию о версии (sonata) "
# sonata --version  # Показать версию приложения
sudo pacman -Q sonata  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# Sonata (sonata):
# https://github.com/multani/sonata
# https://aur.archlinux.org/packages/sonata
# https://aur.archlinux.org/sonata.git
# https://github.com/multani/sonata/archive/refs/tags/v1.7.1.tar.gz
# https://www.nongnu.org/sonata/documentation.html
# Официальную документацию вы можете найти на сайте Sonata:
# http://www.nongnu.org/sonata/documentation.html
# Вы можете отправлять запросы на новые функции или сообщать об ошибках на Github по адресу:
# https://github.com/multani/sonata/issues
# Часто задаваемые вопросы и ответы о Sonata хранятся на вики-странице MPD Client:Sonata/FAQ
# http://mpd.wikia.com/wiki/Client:Sonata/FAQ
# Соната:
# https://blog.desdelinux.net/ru/mpd-%D1%83%D0%BD%D0%B8%D0%B2%D0%B5%D1%80%D1%81%D0%B0%D0%BB%D1%8C%D0%BD%D1%8B%D0%B9-%D0%B4%D1%8C%D1%8F%D0%B2%D0%BE%D0%BB-%D0%B4%D0%BB%D1%8F-%D0%BC%D1%83%D0%B7%D1%8B%D0%BA%D0%B8/
# Теперь с сонатой очень легко. Выполняем, щелкаем правой кнопкой мыши на любом сайте
# *Там, где это возможно, они должны создать свою папку «Музыка». И то же имя пользователя, которое они использовали в mpd.conf.
# *Как вы увидите, я использую порт 8888 в захвате, это то, что во время захвата я тестировал другой порт на основе конфигурации conky. Я рекомендую вам использовать 6600, который идет по умолчанию во всех.
# Как только это будет сделано, мы сохраняем и закрываем конфигурацию, переходим на вкладку «Библиотека», и они должны увидеть музыкальную коллекцию. Если его не видно, перезапустите программу.
####################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Cantata (cantata) — Графический (Qt6) клиент для MPD?"
echo -e "${MAGENTA}:: ${BOLD}Cantata — клиент консольного аудиоплеера MPD для Linux. Он написан на Qt и обладает хорошим функционалом, приятным интерфейсом и удобным управлением, интеграция с рабочим окружением и многое другое. Что такое MPD? Music Player Daemon (MPD) — музыкальный проигрыватель с клиент-серверной архитектурой, который воспроизводит музыку из указанного каталога. Воспроизведением управляют при помощи клиента. Управлять сервером (демоном) можно с любой машины из сети, но слушать музыку можно и на своём компьютере, если программу MPD настроить на подключение к локальному хосту. ${NC}"
echo " Домашняя страница: https://github.com/nullobsi/cantata ; (https://aur.archlinux.org/packages/cantata?all_deps=1#pkgdeps ; https://aur.archlinux.org/packages/cantata-git). "
echo -e "${BLUE}:: ${NC}Основные особенности Cantata: поддерживает несколько платформ; запускает все форматы аудиофайлов; поддерживает воспроизведение без пауз, есть перекрестное затухание; музыку можно транслировать из различных сервисов, таких как Dirble, Icecast, SHOUTcast и Tunein; множество настроек для визуальной части интерфейса. Из недостатков программы стоит отметить, что она не до конца переведена на русский язык. "
echo -e "${CYAN}:: ${NC}Графический (Qt6) клиент для MPD, поддерживающий следующие функции: Поддерживает Linux, macOS, Windows и Haiku. ПРИМЕЧАНИЕ: только Linux активно поддерживается с версии 2.3.3 . Несколько коллекций MPD. Широкие возможности настройки макета. Песни (опционально) сгруппированы по альбомам в очереди воспроизведения. Контекстное представление для отображения информации об исполнителе, альбоме и песне текущего трека. Простой редактор тегов. Органайзер файлов — используйте теги для организации файлов и папок. Возможность расчета тегов ReplyGain. (Только для Linux и при наличии установленных соответствующих библиотек). Динамические плейлисты. Умные плейлисты. Онлайн-сервисы: Jamendo, Magnatune, SoundCloud и Подкасты. Поддержка радиотрансляций — с возможностью поиска трансляций через TuneIn, ShoutCast или Dirble. Поддержка USB-накопителей и устройств MTP (Только для Linux и при наличии соответствующих библиотек). Копирование и воспроизведение аудио-CD (Только для Linux и при наличии установленных соответствующих библиотек). Воспроизведение песен не в формате MPD — через простой встроенный HTTP-сервер. Интерфейс MPRISv2 DBUS. Поддержка рейтингов. Поддержка «разделов». Cantata начиналась как ответвление QtMPC, однако код (и пользовательский интерфейс) теперь сильно отличается от QtMPC. Для более подробной информации, пожалуйста, обратитесь к основному README (https://raw.githubusercontent.com/CDrummond/cantata/master/README). "
echo -e "${YELLOW}==> Примечание! ${BOLD} *Это личный форк CDrummond/cantata, который сейчас зархивирован. Включает работу из fenuks/cantata и Qt6 PR. Графический (Qt6) клиент для MPD, поддерживающий следующие функции: Поддерживает Linux, macOS, Windows и Haiku. Несколько коллекций MPD. Широкие возможности настройки макета. Песни (опционально) сгруппированы по альбомам в очереди воспроизведения. Контекстное представление для отображения информации об исполнителе, альбоме и песне текущего трека. Простой редактор тегов. Органайзер файлов — используйте теги для организации файлов и папок. Возможность расчета тегов ReplyGain (Только для Linux и при наличии установленных соответствующих библиотек). Динамические плейлисты. Умные плейлисты. Онлайн-сервисы: Jamendo, Magnatune, SoundCloud и Подкасты. Поддержка радиотрансляций — с возможностью поиска трансляций через TuneIn, ShoutCast или Dirble. Поддержка USB-накопителей и устройств MTP (Только для Linux и при наличии соответствующих библиотек). Копирование и воспроизведение аудио-CD (Только для Linux и при наличии установленных соответствующих библиотек). Воспроизведение песен не в формате MPD — через простой встроенный HTTP-сервер. Интерфейс MPRISv2 DBUS. Поддержка рейтингов. Поддержка «разделов». Cantata начиналась как ответвление QtMPC, однако код (и пользовательский интерфейс) теперь сильно отличается от QtMPC. Для более подробной информации, пожалуйста, обратитесь к основному README (https://raw.githubusercontent.com/nullobsi/cantata/master/README). ${NC}"
echo -e "${CYAN}:: ${NC}Установка Cantata (cantata) и (cantata-git), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/cantata.git), (https://aur.archlinux.org/cantata-git.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить Cantata (cantata),  2 - Установить Cantata (cantata-git),   0 - НЕТ - Пропустить установку: " in_cantata  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_cantata" =~ [^120] ]]
do
    :
done
if [[ $in_cantata == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_cantata == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Cantata (cantata) (Qt6) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
########### mpd ############
sudo pacman -S --noconfirm --needed mpd  # (необязательно) — Воспроизведение ; Гибкое, мощное серверное приложение для воспроизведения музыки https://archlinux.org/packages/extra/x86_64/mpd/ ; https://github.com/MusicPlayerDaemon/MPD ; https://www.musicpd.org/ ; 2025-07-31 21:53 UTC
sudo pacman -S --noconfirm --needed perl-uri  # (необязательно) – Динамический плейлист ; Унифицированные идентификаторы ресурсов (абсолютные и относительные) ; https://archlinux.org/packages/extra/any/perl-uri/ ; https://search.cpan.org/dist/URI/ ; 2025-07-16 18:22 UTC
########## cantata ##########
yay -S cantata --noconfirm  # Графический клиент Qt6 для Music Player Daemon (MPD), форк nullobsi ; https://aur.archlinux.org/packages/cantata?all_deps=1#pkgdeps ; https://aur.archlinux.org/cantata.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/nullobsi/cantata ; git+https://github.com/nullobsi/cantata.git#tag=v3.3.1 ; 2025-08-25 21:58 (UTC) Смотрите Зависимости !
########## cantata ##########
#git clone https://aur.archlinux.org/cantata.git   # (только для чтения, нажмите, чтобы скопировать)
#cd cantata
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf cantata
#rm -Rf cantata
  echo ""
  echo " Посмотрите информацию о версии (cantata) "
sudo pacman -Q cantata  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_cantata == 2 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Cantata (cantata-git) (Qt6) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) для мониторинга (lm_sensors ; hddtemp) "
############ Зависимости ##############
########### mpd ############
sudo pacman -S --noconfirm --needed mpd  # (необязательно) — Воспроизведение ; Гибкое, мощное серверное приложение для воспроизведения музыки https://archlinux.org/packages/extra/x86_64/mpd/ ; https://github.com/MusicPlayerDaemon/MPD ; https://www.musicpd.org/ ; 2025-07-31 21:53 UTC
sudo pacman -S --noconfirm --needed perl-uri  # (необязательно) – Динамический плейлист ; Унифицированные идентификаторы ресурсов (абсолютные и относительные) ; https://archlinux.org/packages/extra/any/perl-uri/ ; https://search.cpan.org/dist/URI/ ; 2025-07-16 18:22 UTC
############ cantata-git #########
yay -S cantata-git --noconfirm  # Графический клиент Qt6 для Music Player Daemon (MPD), форк nullobsi ; https://aur.archlinux.org/packages/cantata-git?all_deps=1#pkgdeps ; https://aur.archlinux.org/cantata-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/nullobsi/cantata ; Конфликты: с cantata ; Обеспечивает: cantata ; 2024-08-19 20:59 (UTC) ; Смотрите Зависимости !
############ cantata-git #########
#git clone https://aur.archlinux.org/packages/cantata-git   # (только для чтения, нажмите, чтобы скопировать)
#cd cantata-git
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf cantata-git
#rm -Rf cantata-git
  echo ""
  echo " Посмотрите информацию о версии (cantata) "
sudo pacman -Q cantata-git  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Beets (beets) — Менеджер музыкальной библиотеки?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Цель Beets — привести вашу музыкальную коллекцию в порядок раз и навсегда. Он каталогизирует её, автоматически обновляя метаданные по мере её поступления. Затем он предоставляет набор инструментов для управления вашей музыкой и доступа к ней. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Beets — мощный и гибкий менеджер и тегировщик музыкальных библиотек. Он разработан для автоматизации организации и управления метаданными музыкальных коллекций, предлагая интерфейс командной строки и богатую экосистему плагинов для настройки и расширения функциональности. Где же на помощь приходит Beets? Если ваша музыкальная коллекция находится в плачевном состоянии: отсутствуют или неполные данные о треках, метаданные, дубликаты треков, отсутствующие треки, то Beets может стать отличным решением. Помимо метаданных, программа также извлекает обложки альбомов, тексты песен, перекодирует аудио в различные форматы и многое другое. Эта библиотека разработана с учётом максимальной гибкости. Beets — популярная программа, хорошо поддерживаемая в репозиториях дистрибутива. Этот проект Лицензируется под MIT. ${NC}"
echo " Домашняя страница: https://beets.io/ ; (https://github.com/beetbox/beets ; https://archlinux.org/packages/extra/any/beets/). "
echo -e "${BLUE}:: ${NC}Поскольку Beets разработан как библиотека, он способен на практически любые действия с вашей музыкальной коллекцией. Благодаря плагинам Beets становится панацеей: Получите или рассчитайте все метаданные, которые вам могут понадобиться: обложки альбомов , тексты песен , жанры , темпы , уровни ReplayGain или акустические отпечатки. Получите метаданные с MusicBrainz , Discogs и Beatport . Или угадывайте метаданные по названиям файлов песен или их акустическим отпечаткам. Перекодируйте аудио в любой удобный вам формат. Проверьте свою библиотеку на наличие дубликатов треков и альбомов или альбомов с отсутствующими треками. Удалите ненужные теги, оставленные другими, менее эффективными инструментами. Встраивайте и извлекайте обложки альбомов из метаданных файлов. Просматривайте свою музыкальную библиотеку графически через веб-браузер и воспроизводите ее в любом браузере, поддерживающем HTML5 Audio. Анализируйте метаданные музыкальных файлов из командной строки. Слушайте свою библиотеку с помощью музыкального проигрывателя, который поддерживает протокол MPD и работает с потрясающим разнообразием интерфейсов. *Плюсы: Широкие возможности настройки благодаря широкому спектру плагинов и параметров конфигурации. Точная автоматическая маркировка метаданных с использованием нескольких источников. Гибкие схемы именования и организации файлов. Активное сообщество и регулярные обновления. *Минусы: Крутая кривая обучения для расширенных функций и настроек. Интерфейс командной строки может показаться пугающим для нетехнических пользователей. Может быть медленным при обработке больших библиотек. Некоторые функции требуют дополнительной настройки или внешних зависимостей. "
echo -e "${CYAN}:: ${NC}Осталось ещё кое-что сделать. Приложение легко настраивается через файл config.yaml, который в Linux находится по адресу ~/.config/beets/config.yaml. Мне нужно было создать этот файл самостоятельно с помощью команды: 'beet config -e' И вам настоятельно рекомендуется создать этот файл. Не могу описать даже малую часть параметров, которые можно задать в конфигурационном файле, поскольку у Beets настолько обширная система настроек, что позволяет настраивать практически каждый аспект его работы. На это ушёл бы месяц воскресений! Но вам определённо захочется определить параметры для музыкального каталога, музыкальной библиотеки, задать значения по умолчанию для функции импорта, а также указать программе, какие плагины использовать, например, необходимые плагины для fetchart и lyrics. Чтобы начать работу с beets, ознакомьтесь с руководством «Начало работы» (https://beets.readthedocs.io/en/stable/guides/main.html#). "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_beets  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_beets" =~ [^10] ]]
do
    :
done
if [[ $in_beets == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_beets == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Beets (beets) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed chromaprint  # (опционально) — плагин Chromaprint/Acoustid ; Библиотека для извлечения отпечатков пальцев из любого аудиоисточника ; https://archlinux.org/packages/extra/x86_64/chromaprint/ ; https://acoustid.org/chromaprint ; Обеспечивает:  libchromaprint.so=1-64 ; 2025-03-14 10:45 UTC
sudo pacman -S --noconfirm --needed python-flask  # (опционально) — веб-плагин ; Микрофреймворк для веб-разработки на Python ; https://archlinux.org/packages/extra/any/python-flask/ ; https://flask.palletsprojects.com/ ; 2025-05-17 11:18 UTC
sudo pacman -S --noconfirm --needed python-librosa  # (опционально) — плагин AutoBPM ; Библиотека Python для анализа музыки и аудио ; https://archlinux.org/packages/extra/any/python-librosa/ ; https://librosa.org/ ; 2025-07-23 08:25 UTC
###################  Зависимости необязательные ##############
sudo pacman -S --noconfirm --needed python-beautifulsoup4  # (необязательно) — плагин для текстов песен ; HTML/XML-парсер Python, предназначенный для быстрых проектов, таких как анализ экрана ; https://archlinux.org/packages/extra/any/python-beautifulsoup4/ ; https://www.crummy.com/software/BeautifulSoup/ ; 2025-08-09 09:09 UTC
sudo pacman -S --noconfirm --needed python-discogs-client  # (необязательно) — плагин Discogs ; Клиент Python для API Discogs ; https://archlinux.org/packages/extra/any/python-discogs-client/ ; https://github.com/joalla/discogs_client ; 2025-03-14 10:54 UTC
sudo pacman -S --noconfirm --needed python-gobject  # (необязательно) — плагин ReplayGain ; Привязки Python для GLib/GObject/GIO/GTK ; https://archlinux.org/packages/extra/x86_64/python-gobject/ ; https://pygobject.gnome.org/ ; Обеспечивает: pygobject-devel=3.52.3 ; Заменяет:  pygobject-devel<=3.36.1-1 ; Конфликты: с pygobject-devel ; 2025-03-24 03:58 UTC
sudo pacman -S --noconfirm --needed python-langdetect  # (необязательно) — плагин для текстов песен ; Библиотека определения языка, перенесенная из библиотеки определения языка Google ; https://archlinux.org/packages/extra/any/python-langdetect/ ; https://github.com/Mimino666/langdetect ; 2025-07-23 08:53 UTC
#sudo pacman -S --noconfirm --needed python-mpd2  # (необязательно) — плагин MPDStats ; Библиотека Python, предоставляющая клиентский интерфейс для демона музыкального проигрывателя ; https://archlinux.org/packages/extra/any/python-mpd2/ ; https://github.com/Mic92/python-mpd2 ; 2024-12-22 13:42 UTC
sudo pacman -S --noconfirm --needed python-pyacoustid  # (необязательно) — плагин Chromaprint/Acoustid ; Привязки для акустической дактилоскопии Chromaprint и API Acoustid ; https://archlinux.org/packages/extra/any/python-pyacoustid/ ; https://github.com/beetbox/pyacoustid ; 2024-12-22 13:25 UTC
sudo pacman -S --noconfirm --needed python-pylast  # (необязательно) — плагин LastGenre ; Интерфейс Python для Last.fm и Libre.fm ; https://archlinux.org/packages/extra/any/python-pylast/ ; https://github.com/pylast/pylast ; 2025-03-14 11:00 UTC
sudo pacman -S --noconfirm --needed python-requests  # (необязательно) — плагины Chromaprint/Acoustid, BPD, FetchArt, Lyrics ; Python HTTP для людей ; https://archlinux.org/packages/extra/any/python-requests/ ; https://requests.readthedocs.io/ ; 2025-06-09 17:59 UTC
sudo pacman -S --noconfirm --needed python-requests-oauthlib  # (необязательно) — плагин Beatport ; Первоклассная поддержка библиотеки OAuth для запросов ; https://archlinux.org/packages/extra/any/python-requests-oauthlib/ ; https://pypi.python.org/pypi/requests-oauthlib ; 2024-12-22 13:43 UTC
sudo pacman -S --noconfirm --needed python-xdg  # ( python-pyxdg ) (необязательно) — плагин миниатюр ; Библиотека Python для доступа к стандартам freedesktop.org ; https://archlinux.org/packages/extra/any/python-pyxdg/ ; http://freedesktop.org/Software/pyxdg ; Обеспечивает:  python-xdg ; Заменяет: python-xdg<0.26-5 ; Конфликты: python-xdg ; 2024-12-22 13:53 UTC
############ beets ##############
sudo pacman -S --noconfirm --needed beets  # Гибкий менеджер музыкальной библиотеки и тегер ; https://archlinux.org/packages/extra/any/beets/ ; https://beets.io/ ; 2025-08-14 19:20 UTC
  echo ""
  echo " Создать файл конфигурации Beets (config.yaml) "
  echo " Файл будет находится в директории home по адресу ~/.config/beets/config.yaml "
beet config -e
  echo ""
  echo " Посмотрите информацию о версии (beets) "
sudo pacman -Q beets  # Показать версию приложения
# beet --version  # Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# Beets - ArchWiki
# https://wiki.archlinux.org/title/Beets
# https://wiki.archlinux.org/title/Beets#Plugins
# https://www.youtube.com/watch?v=ZaqJmjM23D0&t=1s
# Чтобы начать работу с beets, ознакомьтесь с руководством «Начало работы»:
# https://beets.readthedocs.io/en/stable/guides/main.html#
# https://beets.io/
# https://github.com/beetbox/beets
# https://archlinux.org/packages/extra/any/beets/
# Получить помощь и общие сведения:
# Команда beet и её подкоманды ( например , import, list, и т.д. ) поддерживают -h/--helpфлаг для вывода справки. С помощью флага можно вывести список включённых/загруженных плагинов beet version. С помощью флага можно включить подробный вывод для отладки -vv. Кроме того, с помощью флага можно обеспечить поведение по умолчанию без загруженных плагинов только для одной команды --plugin="".
################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Cozy (cozy-audiobooks) - Проигрыватель аудиокниг?"
echo -e "${MAGENTA}:: ${BOLD}Cozy — современный проигрыватель аудиокниг для Linux. Программа Cozy, с современным пользовательским интерфейсом, разработана специально для прослушивания аудиокниг. Переходите на Matrix (https://matrix.to/#/#cozy:gnome.org), чтобы присоединиться к обсуждению. Matrix — открытая сеть для безопасной, децентрализованной связи. ${NC}"
echo " Домашняя страница: https://github.com/geigi/cozy ; (https://cozy.sh/ ; https://aur.archlinux.org/packages/cozy-audiobooks). "
echo -e "${MAGENTA}:: ${BOLD}Основные функции Cozy: Импортируйте все ваши аудиокниги в Cozy для удобного просмотра; Сортируйте ваши аудиокниги по автору, читателю и названию; Помнит вашу позицию воспроизведения; Таймер сна; Контроль скорости воспроизведения (Управление скоростью воспроизведения для каждой книги индивидуально); Поиск в вашей библиотеке. Автономный режим! Это позволяет хранить аудиокнигу на внутреннем хранилище, если аудиокниги хранятся на внешнем или сетевом диске. Идеально для прослушивания на ходу! Добавить несколько мест хранения; Drag & Drop для импорта новых аудиокниг. Поддержка DRM бесплатно mp3, m4b, m4a (aac, ALAC,…), flac, ogg, wav файлы без DRM-защиты. Интеграция с Mpris (медиа-клавиши и информация о воспроизведении для среды рабочего стола). ${NC}"
echo -e "${CYAN}:: ${NC}Cozy доступен для установки как пакет Flatpak. По окончании установки, вы найдёте Cozy поиском в системном меню приложений."
echo -e "${CYAN}:: ${NC}Установка Cozy (cozy-audiobooks) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/cozy-audiobooks.git), (https://aur.archlinux.org/packages/cozy-audiobooks)  - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_cozy  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
  mkdir ~/CozyAudioBooks  # Директория для работы с аудиокнигами
  mkdir ~/CozyAudioBooks/audiobooks
######## Зависимости ############
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
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
echo -e "${BLUE}:: ${NC}Установить Shortwave (shortwave) - Интернет-радио?"
echo -e "${MAGENTA}:: ${BOLD}Shortwave — это интернет-радиоплеер, предоставляющий доступ к базе данных станций, содержащей более 30 000 станций. ${NC}"
echo " Домашняя страница: https://gitlab.gnome.org/World/Shortwave ; (https://aur.archlinux.org/packages/shortwave). "
echo -e "${MAGENTA}:: ${BOLD}Почему его называют Shortwave «коротковолновым»? Коротковолновые сигналы имеют очень большой радиус действия из-за их очень хороших отражательных свойств. Благодаря большому радиусу действия их можно принимать практически в любой точке мира. То же самое относится и к интернет-радиостанциям, которые также можно принимать практически в любой точке мира. Вот почему мы решили назвать проект «Коротковолновый», потому что интернет-радиостанции и коротковолновые радиостанции имеют много общих характеристик. ${NC}"
echo " Возможности: Огромная база радиостанций. Простой поиск радиостанций. Создание списка избранных радиостанций. Автоматическое распознавание песен. Воспроизведение аудио на поддерживаемых устройствах (например, Google Chromecasts). Интеграция со средой GNOME. Мини-режим проигрывателя. Поддержка горячих клавиш. Исходный код: Open Source (открыт); Языки программирования: Rust; Библиотеки: GTK; Лицензия: GNU GPL; Приложение переведено на русский язык. "
echo -e "${CYAN}:: ${NC}Установка Shortwave (shortwave) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/shortwave.git), (https://aur.archlinux.org/packages/shortwave) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! ♫ "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_shortwave  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_shortwave" =~ [^10] ]]
do
    :
done
if [[ $in_shortwave == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_shortwave == 1 ]]; then
  echo ""
  echo " Установка Shortwave (shortwave) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
########### shortwave ##########
yay -S shortwave --noconfirm  # Найдите и слушайте интернет-радиостанции ; https://aur.archlinux.org/shortwave.git (только для чтения, нажмите, чтобы скопировать) ; https://gitlab.gnome.org/World/Shortwave ; https://aur.archlinux.org/packages/shortwave ; 2023-02-08 16:20 (UTC)
#git clone https://aur.archlinux.org/shortwave.git   # (только для чтения, нажмите, чтобы скопировать)
#cd shortwave
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf shortwave
#rm -Rf shortwave
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##########
# Я приятно удивлен: у меня это сработало.
# Я использовал папку ~/.cache/yay/shortwave/ (я использую yay как установщик пакетов), и makepkg -sfi прошел гладко.
# Теперь shortwave снова работает. Спасибо @FabioLolix.
##############

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Goodvibes (goodvibes) - Интернет-радио?"
echo -e "${MAGENTA}:: ${BOLD}Goodvibes — это легкий интернет-радиоплеер для для прослушивания интернет-радио в GNU/Linux. Сохраняйте любимые станции, включайте их, вот и все. Нет функции поиска радиостанций, вам придется вводить URL аудиопотока самостоятельно. Не очень удобно, я знаю, но сделать лучше не так просто. ${NC}"
echo " Домашняя страница: https://gitlab.com/goodvibes/goodvibes ; (https://aur.archlinux.org/packages/goodvibes). "
echo -e "${MAGENTA}:: ${BOLD}Goodvibes имеет простой интерфейс. Из коробки имеется небольшой список радиостанций, который при желании можно удалить и добавить только нужные станции. На главном окне кроме списка радиостанций имеются также кнопки - воспроизведения; остановки; переключения каналов; воспроизведения в случайном порядке; повтора; регулировки громкости. ${NC}"
echo " Возможности: Проигрывание интернет-радиостанций. Предустановленный список радиостанций. Поддержка мультимедиа клавиш. Уведомления на рабочем столе. Программу можно использовать через командную строку. Поддержка MPRIS2 (Media Player Remote Interfacing Specification). Возможность интеграции в Conky. Имеется поддержка: горячих клавиш клавиатуры; уведомлений на рабочем столе. Исходный код: Open Source (открыт); Языки программирования: C; Библиотеки: GStreamer; GTK; Лицензия: GNU GPL v3; Приложение переведено на русский язык. "
echo -e "${CYAN}:: ${NC}Установка Goodvibes (goodvibes) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/goodvibes.git), (https://aur.archlinux.org/packages/goodvibes) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! ♫ "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_goodvibes  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_goodvibes" =~ [^10] ]]
do
    :
done
if [[ $in_goodvibes == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_goodvibes == 1 ]]; then
  echo ""
  echo " Установка Goodvibes (goodvibes) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
#sudo pacman -S --noconfirm --needed glib2-devel  # Базовая библиотека низкого уровня - файлы разработки ; https://gitlab.gnome.org/GNOME/glib ; https://archlinux.org/packages/core/x86_64/glib2-devel/ ; 26 августа 2024 г., 22:01 UTC
########## Зависимости ###########
sudo pacman -S --noconfirm --needed meson  # Высокопроизводительная система сборки ; https://mesonbuild.com/ ; https://archlinux.org/packages/extra/any/meson/ ; 27 июля 2024 г., 16:47 UTC
sudo pacman -S --noconfirm --needed meson-python  # Meson PEP 517 Python бэкэнд сборки ; https://github.com/mesonbuild/meson-python ; https://archlinux.org/packages/extra/any/meson-python/ ; 29 апреля 2024 г., 22:37 UTC
######## goodvibes ############
yay -S goodvibes --noconfirm  # Легкий интернет-радиоплеер ; https://aur.archlinux.org/goodvibes.git (только для чтения, нажмите, чтобы скопировать) ; https://gitlab.com/goodvibes/goodvibes ; https://aur.archlinux.org/packages/goodvibes ; https://gitlab.com/goodvibes/goodvibes/-/archive/v0.8.0/goodvibes-v0.8.0.tar.gz ; 2024-05-06 11:42 (UTC)
#git clone https://aur.archlinux.org/goodvibes.gi   # (только для чтения, нажмите, чтобы скопировать)
#cd goodvibes
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf goodvibes
#rm -Rf goodvibes
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Интернет-радио плеер RadioTray?"
echo -e "${MAGENTA}:: ${BOLD}Radio Tray (рус.Радио лоток) - проигрыватель потокового онлайн радио, предназначенный для прослушивания интернет-радиостанций в операционных системах Linux. (https://radiotray.wordpress.com/) ${NC}"
echo " Radio Tray не является полнофункциональным музыкальным плеером, уже существует множество отличных музыкальных плееров. Однако было необходимо простое приложение с минимальным интерфейсом только для прослушивания онлайн-радио, не загружая другие плееры типа Amorok или Rhythmbox, а также веб-браузер, тем самым экономя системные ресурсы компьютера и энергопотребление ноутбуков. И это единственная цель Radio Tray. Radio Tray это бесплатное программное обеспечение, работающее под лицензией GPL"
echo " Функции: воспроизводит большинство медиаформатов (на основе библиотек gstreamer); поддержка перетаскивания закладок; легко использовать; поддерживает формат плейлиста PLS (Shoutcast/Icecast); поддерживает формат плейлиста M3U; поддерживает форматы плейлистов ASX, WAX и WVX... расширяемый плагинами. "
echo -e "${MAGENTA}:: ${BOLD}Radiotray-NG (рус.Радио лоток) - улучшенная версия проигрывателя (radiotray) потокового онлайн радио, предназначенный для прослушивания интернет-радиостанций в операционных системах Linux. (https://github.com/ebruck/radiotray-ng) ${NC}"
echo " Предисловие от автора Radiotray-NG: Как один из первых участников проекта RadioTray, я понял, что он не получает должного внимания и, вероятно, мертв. Многие из используемых технологий перешли в новые версии, и ошибки начали накапливаться. Я делал все возможное, чтобы помочь пользователям, но требовалось начать все заново. Представленная здесь версия — это то, чего «я» хотел от RadioTray. "
echo " Целями Radiotray-NG были: Улучшенная обработка ошибок и восстановление gstreamer. Исправление некорректного формата закладок RadioTray. Встроил единственный плагин RadioTray, который, как я чувствовал, мне был нужен — это таймер выключения. Поддержка значков уведомлений для каждой станции/группы. Лучший анализ метаданных потока и опциональное отображение большего количества информации о потоке. Немного больше внимания к деталям и форматированию уведомлений. "
echo -e "${CYAN}:: ${NC}Установка RadioTray (radiotray) и (radiotray-ng), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/radiotray.git), (https://aur.archlinux.org/radiotray-ng.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
# Установка пакета (radiotray) - Закомментирована (двойной ##), если Вам нужен именно этот пакет, то раскомментируйте строки его установки, а строки установки пакета (radiotray-ng) - закомментируйте.
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить RadioTray,    2 - *Да установить Radiotray-NG,    0 - НЕТ - Пропустить установку: " in_radiotray  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_radiotray" =~ [^120] ]]
do
    :
done
if [[ $in_radiotray == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_radiotray == 1 ]]; then
  echo ""
  echo " Установка Интернет-радио RadioTray "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
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
elif [[ $in_radiotray == 2 ]]; then
  echo ""
  echo " Установка Интернет-радио Radiotray-NG "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
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
#yay -S python-strenum --noconfirm # Перечисление Python, которое наследуется от str ; https://aur.archlinux.org/python-strenum.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/irgeek/StrEnum ; https://aur.archlinux.org/packages/python-strenum
#yay -S radiotray-ng-mpris --noconfirm # Скрипт-оболочка для Radiotray-NG, предоставляющий интерфейс MPRIS2 ; https://aur.archlinux.org/radiotray-ng-mpris.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/IngoMeyer441/radiotray-ng-mpris ; https://aur.archlinux.org/packages/radiotray-ng-mpris ; Radiotray-NG MPRIS — это оболочка для Radiotray-NG, позволяющая добавить интерфейс MPRIS2 , который хорошо интегрируется со средами рабочего стола (например, GNOME , KDE или XFCE ) или независимыми от рабочего стола инструментами управления музыкальными проигрывателями, такими как playerctl .
#yay -S python-mpris_server --noconfirm # Интегрируйте поддержку MPRIS Media Player в свое приложение ; https://aur.archlinux.org/python-mpris_server.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/alexdelorenzo/mpris_server ; https://github.com/alexdelorenzo/mpris_server
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
echo -e "${BLUE}:: ${NC}Установить Blanket (blanket) — Улучшайте концентрацию внимания и повышайте продуктивность?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Улучшайте концентрацию внимания и повышайте продуктивность, слушая разные звуки. Blanket (Одеяло) также может помочь вам заснуть в шумной обстановке. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Blanket — приложение для Linux, предназначенное для воспроизведения фоновых звуков окружающей среды. Blanket - это приложение на Python для воспроизведения различных фоновых шумов, которое повышает вашу продуктивность, помогая сосредоточиться или, наоборот, заснуть. Цель: помочь сосредоточиться, повысить продуктивность или заснуть в шумном окружении. Это приложение содержит звуки ветра, дождя, шторма, птиц, города, поезда, камина летняя ночь, звуки кафе, розовый шум, белый шум и другие. Эти звуки постепенно добавляются в приложение и их можно микшировать, причём, с разным уровнем громности. Например, интересным получается микс ветра, волн и лодки. По сути, это плеер и в комплекте файлы ogg. Но, как уже было сказано, с возможностью микширования с разной громкостью и в любых комбинациях. Можно загружать свои файлы. Позводяет выбрать ogg, flac, mp3 и wav. Приложение умеет "шуметь" в фоне, то есть, окно программы можно совсем закрыть. В Gnome можно управлять им из панели при помощи, например,  Mpris Indicator Button - устанавливается как расширение. Нужно только в настройках указать "Keep playing when closed" и вуаля. Разработано Rafael Mardojai CM. Этот проект Лицензируется под GPL-3.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://apps.gnome.org/Blanket/ ; (https://github.com/rafaelmardojai/blanket/ ; https://archlinux.org/packages/extra/any/blanket/). "
echo -e "${BLUE}:: ${NC}Функции: Возможность комбинировать звуки с разным уровнем громкости. Например, можно создать микс ветра, волн и лодки. Настройка громкости для каждого звука. Добавление своих звуковых файлов — помимо встроенной коллекции, можно загружать файлы в форматах ogg, flac, mp3 и wav. Автозапуск в фоновом режиме — окно программы можно закрыть, а громкость можно контролировать из иконки звука в системном трее. Сохранение профиля — можно сохранить микс звуков как новый пресет, чтобы воспроизводить его при следующем запуске. "
echo -e "${CYAN}:: ${NC}Отзывы: Некоторые положительные стороны, отмеченные пользователями: приложение работает офлайн, не требует подключения к интернету; звуки, которые воспроизводит Blanket, помогают сосредоточиться. Есть и недостатки: некоторые пользователи считают, что диапазон звуков, включённый в приложение, не всегда обширен, как в похожих приложениях на других системах. Жаль, звуков маловато. Но, в принципе, вполне достаточно и этих. И нужно помнить, что приложение свободное и звуки, соответсвенно, тоже. На своё усмотрение можно добавлять любые. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_blanket  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_blanket" =~ [^10] ]]
do
    :
done
if [[ $in_blanket == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_blanket == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Blanket (blanket) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
######### blanket ############
sudo pacman -S --noconfirm --needed blanket  # Улучшите концентрацию внимания и повысьте производительность, слушая разные звуки ; https://archlinux.org/packages/extra/any/blanket/ ; https://apps.gnome.org/Blanket/ ; https://github.com/rafaelmardojai/blanket/ ; 2025-07-31 22:04 UTC
  echo ""
  echo " Посмотрите информацию о версии (blanket) "
sudo pacman -Q blanket  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########

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
    1 - Установить Spotify (spotify-launcher),   2 - *Установить Spotify (spotify) из (AUR-yay),

    0 - НЕТ - Пропустить установку: " in_spotify  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_spotify" =~ [^120] ]]
do
    :
done
if [[ $in_spotify == 0 ]]; then
echo ""
echo " Установка пропущена "
elif [[ $in_spotify == 1 ]]; then
echo ""
echo " Установка Spotify (spotify-launcher) "
echo " Этот пакет управляет установкой для каждого пользователя в вашем домашнем каталоге, позволяя Spotify обновляться независимо от pacman (аналогично тому, как Spotify обновляется самостоятельно в других операционных системах) "
echo " Spotify (spotify-launcher) имеет бесплатный клиент для Linux, но запрещает его повторное распространение, поэтому это свободно распространяемая программа с открытым исходным кодом, которая управляет установкой Spotify в вашей домашней папке с официального сервера релизов Spotify."
echo " После установки запустите приложение из меню приложений "
# sudo pacman -S --help
# sudo pacman -Syy  # обновление баз пакмэна (pacman)
#sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
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
elif [[ $in_spotify == 2 ]]; then
  echo ""
  echo " Установка Установка Spotify (spotify) + дополнения "
# sudo pacman -S --help
# sudo pacman -Syy  # обновление баз пакмэна (pacman)
#sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
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
# https://itshaman.ru/articles/5402/21-luchshii-muzykalnyi-pleer-dlya-linux-na-segodnyashnii-den
##################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить GMPT - (клиент MP3-плеера для устройств на базе MTP)?"
echo -e "${MAGENTA}:: ${BOLD}GMPT - это Простой клиент MP3-плеера для устройств на базе MTP. Что такое МТР? MTP = Media Transfer Protocol. MTP принят большинством основных MP3 и Производители мобильных телефонов как способ общения с устройствами загрузка/выгрузка файлов на/с ПК. ${NC}"
echo " Домашняя страница: http://gmtp.sourceforge.net/ ; (https://github.com/alessio/gmtp ; https://archlinux.org/packages/extra/x86_64/gmtp/). Смотреть http://en.wikipedia.org/wiki/Media_Transfer_Protocol для получения дополнительной информации. "
echo -e "${MAGENTA}:: ${BOLD}gMTP — это простой и легкий интерфейс к функциям, предоставляемым libmtp, который позволяет пользователям управлять файлами, хранящимися на любом музыкальном проигрывателе MTP, поддерживаемом библиотеками, включая те, которые оснащены несколькими устройствами хранения (например, мобильные телефоны). Поддерживает интерфейс Drag'n'Drop для загрузка/выгрузка файлов. ${NC}"
echo " Особенности программы: Он не предоставляет сложных функций, таких как управление плейлистами, а просто упрощает передачу файлов с устройств и на устройства, позволяя пользователям загружать, скачивать и удалять файлы на устройстве с помощью быстрого и простого в использовании графического интерфейса. "
echo " gMTP поддерживает: Загрузка, скачивание, удаление, переименование и перемещение файлов по мере необходимости. Поддержка Drag'n'Drop для загрузки файлов на устройство. Создание и удаление папок. Управление обложками альбомов. Поддержка метаданных для аудиофайлов MP3, WMA, OGG и FLAC, гарантирующая правильную информацию о дорожке на вашем медиаплеере при загрузке аудиофайлов. Поддержка именования устройств. Базовое создание, редактирование и удаление плейлистов. Возможность импорта и экспорта плейлистов в формате *.m3u. Для других нужд, таких как управление вашей аудиоколлекцией или копирование компакт-дисков, я предлагаю вам рассмотреть другое полнофункциональное медиаприложение. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_gmtp  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_gmtp" =~ [^10] ]]
do
    :
done
if [[ $in_gmtp == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_gmtp == 1 ]]; then
  echo ""
  echo " Установка GMPT "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed gmtp  # Простой клиент MP3-плеера для устройств на базе MTP ; http://gmtp.sourceforge.net/ ; https://github.com/alessio/gmtp ; https://archlinux.org/packages/extra/x86_64/gmtp/
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Nicotine+ - (графический клиент для одноранговой сети Soulseek)?"
echo -e "${MAGENTA}:: ${BOLD}Nicotine+ - это Аналог soulseek (Nicotine+ — графический клиент для одноранговой сети Soulseek). Soulseek — это бесплатная сеть обмена файлами без рекламы и шпионского ПО для Windows, Mac и Linux. Наши комнаты, поисковая система и система корреляции поиска облегчают вам поиск людей со схожими интересами и делают новые открытия! ${NC}"
echo " SoulSeek - P2P-сеть предназначеная прежде всего для передачи музыкальных файлов. Это не означает, что она не дает возможности обмениваться файлами других типов. Однако интересующий вас аудиофайл вы найдете здесь с большей вероятностью, чем, например, игру или фотографию. Делиться своими файлами в SoulSeek не обязательно, но желательно. Дело в том, что, когда вы начинаете загрузку файла у кого-то из пользователей, он видит, кто и что у него копирует. И вполне возможно, он захочет посмотреть, что интересного есть у вас. Не обнаружив ни одного открытого ресурса, он может обидеться и занести вас в Ban List, то есть в список пользователей, которые больше никогда у него ничего не смогут скачать."
echo " Домашняя страница: https://nicotine-plus.org/ ; (https://github.com/Nicotine-Plus/nicotine-plus ; https://archlinux.org/packages/extra/any/nicotine+/ ; http://www.slsknet.org/news/). "
echo -e "${MAGENTA}:: ${BOLD}Nicotine+ — Свободный графический клиент Nicotine+ для файлообменной P2P-сети Soulseek. Nicotine+ стремится быть удобной, свободной альтернативой с открытым исходным кодом официальному клиенту Soulseek, предоставляя дополнительную функциональность и сохраняя при этом совместимость с протоколом Soulseek. ${NC}"
echo " Особенности программы: Nicotine+ написан на Python и использует GTK для графического пользовательского интерфейса. Nicotine+ стремится стать легкой, приятной, бесплатной и открытой (FOSS) альтернативой официальному клиенту Soulseek, а также предлагающей полный набор функций. Подключаясь к серверу Soulseek по умолчанию, вы соглашаетесь соблюдать правила и условия обслуживания Soulseek. Soulseek — это незашифрованный протокол, не предназначенный для безопасной связи. "
echo " Nicotine+ — это бесплатное программное обеспечение с открытым исходным кодом, выпущенное на условиях GNU Public License v3 или более поздней версии. Nicotine+ существует благодаря своей основной команде , переводчикам и участникам. Команда Nicotine+ не собирает никаких данных, используемых или хранимых клиентом. Различные политики могут применяться к данным, отправляемым на сервер Soulseek по умолчанию, который не управляется командой Nicotine+. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_soulseek  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_soulseek" =~ [^10] ]]
do
    :
done
if [[ $in_soulseek == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_soulseek == 1 ]]; then
  echo ""
  echo " Установка Nicotine+ "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed nicotine+  # Клиент Soulseek для обмена музыкой, написанный на Python ; https://github.com/Nicotine-Plus/nicotine-plus ; https://archlinux.org/packages/extra/any/nicotine+/ ; https://nicotine-plus.org/
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Smplayer (smplayer) — Мультимедиа плеер?"
echo -e "${YELLOW}==> Примечание! ${BOLD}*Свободный и имеет открытые исходные коды, медиапроигрыватель со встроенными кодеками. Воспроизводит аудио и видео любого формата. Теперь и с поддержкой Chromecast! ${NC}"
echo -e "${MAGENTA}:: ${BOLD}SMPlayer — мультимедиа плеер для Linux с простым интерфейсом. Поддерживаются практически все видео и аудио форматы файлов. Он не требует внешних кодеков. Просто установите SMPlayer и вы сможете воспроизводить любые форматы без необходимости искать и устанавливать пакеты кодеков. Одна из наиболее интересных возможностей SMPlayer — запоминание настроек каждого воспроизведённого файла. Например, вы начали смотреть фильм, но нужно срочно куда-то отойти… Не волнуйтесь, когда вы снова откроете фильм — воспроизведение продолжится с того же момента и с теми же настройками: звуковая дорожка, субтитры, громкость… SMPlayer поддерживает множество функций. Например, можно повернуть видео на 90 градусов прямо во время просмотра, можно изменить скорость просмотра видео, уменьшить или увеличить размер, изменить соотношение сторон видео, применить различные эффекты, настроить звук, субтитры, сделать скриншот из видео и многое другое. SMPlayer поддерживает большинство известных форматов и кодеков: avi, mp4, mkv, mpeg, mov, divx, h.264… Вы можете воспроизводить их все благодаря встроенным кодекам. Не нужно искать и устанавливать сторонние кодеков. Смотрите список всех поддерживаемых форматов: (https://www.smplayer.info/ru/supported-formats-and-codecs). SMPlayer может воспроизводить видео с YouTube, так же доступно дополнение, позволяющее искать видео на YouTube. SMPlayer поставляется с несколькими обложками и темами значков, так что вы легко можете изменить внешний вид проигрывателя. SMPlayer может находить и скачивать субтитры с opensubtitles.org (http://www.opensubtitles.org/). SMPlayer предлагает множество дополнительных функций, таких как фильтры видео и аудио, изменение скорости воспроизведения, подстройка задержки звука и субтитров, эквалайзер видео и другие. Также поддерживаются устройства 2 в 1 с сенсорными экранами (https://www.smplayer.info/ru/new-features). SMPlayer переведён на более чем 30 языков, включая русский, китайский, украинский, немецкий, французский и другие… SMPlayer доступен для Windows, Linux и macOS. SMPlayer совместим с Windows XP/2003/Vista/Server 2008/7/8/10. Языки программирования: C; C++. Библиотеки: Qt. Этот проект Лицензируется под GPL. ${NC}"
echo " Домашняя страница: https://www.smplayer.info/ ; (https://archlinux.org/packages/extra/x86_64/smplayer/). "
echo -e "${BLUE}:: ${NC}SMPlayer — графическая оболочка (GUI) для удостоенного наград MPlayer, способного воспроизводить практически все известные форматы видео и аудио.  MPlayer (The Movie Player) — мультимедиа проигрыватель для Linux. MPlayer поддерживает очень большое количество как музыкальных, так и видео форматов. «Голая» версия программы не имеет графического интерфейса, а работает через консоль. Теперь SMPlayer поддерживает MPV (https://www.smplayer.info/ru/mpv). "
echo -e "${CYAN}:: ${NC}Интерфейс у SMPlayer простой и удобный. Главное окно содержит две панели управления — сверху и снизу и главное меню в верхней части окна. Отдельно можно включить показ списка воспроизведения. Он может размещаться внизу внутри главного окна, а также как отдельное окно на экране. Поддерживаются скины (темы оформления) и темы иконок. Одной из интересных функций программы является то, что для каждого файла она запоминает позицию, на которой вы закончили его просмотр. То есть, если, например, вы закрыли видео-файл, а на следующий день снова его открыли, то SMPlayer начнет проигрывание с той позиции, на которой вы закрыли файл в прошлый раз. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_smplayer  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_smplayer" =~ [^10] ]]
do
    :
done
if [[ $in_smplayer == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_smplayer == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Smplayer (smplayer) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -S --noconfirm --needed smplayer smplayer-skins smplayer-themes  # Медиаплеер со встроенными кодеками, который может воспроизводить практически все видео и аудио форматы; Скины для SMPlayer; Темы для SMPlayer; *** Приложение, позволяющее просматривать, искать и воспроизводить видео на YouTube - отсутствует.
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed mpv  # Бесплатный, открытый и кроссплатформенный медиаплеер ; https://archlinux.org/packages/extra/x86_64/mpv/ ; https://mpv.io/ ; Обеспечивает: libmpv.so=2-64 ; 2025-07-29 22:37 UTC
sudo pacman -S --noconfirm --needed mpv-mpris  # Плагин MPRIS для MPV ; https://archlinux.org/packages/extra/x86_64/mpv-mpris/ ; https://github.com/hoyon/mpv-mpris ; 2024-11-07 20:02 UTC
sudo pacman -S --noconfirm --needed mpv-shim-default-shaders  # Предварительно настроенный набор шейдеров MPV и конфигураций для медиа-клиентов MPV Shim ; https://archlinux.org/packages/extra/any/mpv-shim-default-shaders/ ; https://github.com/iwalton3/default-shader-pack ; 2024-09-15 19:59 UTC
sudo pacman -S --noconfirm --needed jellyfin-mpv-shim  # Транслировать медиафайлы из мобильных и веб-приложений Jellyfin на MPV ; https://archlinux.org/packages/extra/any/jellyfin-mpv-shim/ ; https://github.com/jellyfin/jellyfin-mpv-shim ; 2025-03-18 17:11 UTC
sudo pacman -S --noconfirm --needed python-mpv-jsonipc  # API Python для MPV с использованием JSON IPC ; https://archlinux.org/packages/extra/any/python-mpv-jsonipc/ ; https://github.com/iwalton3/python-mpv-jsonipc ; 2025-03-30 18:16 UTC
sudo pacman -S --noconfirm --needed mplayer # Медиаплеер для Linux ; http://www.mplayerhq.hu/ ; https://archlinux.org/packages/extra/x86_64/mplayer/ ; 2025-04-24 17:56 UTC
sudo pacman -S --noconfirm --needed yt-dlp  # (необязательно) — видео и трансляции на YouTube ; Форк youtube-dl с дополнительными функциями и исправлениями ; https://archlinux.org/packages/extra/any/yt-dlp/ ; https://github.com/yt-dlp/yt-dlp ; 2025-08-28 08:31 UTC
############ smplayer #############
sudo pacman -S --noconfirm --needed smplayer  #  Медиаплеер со встроенными кодеками, который может воспроизводить практически все видео и аудио форматы ; https://www.smplayer.info/ ; https://archlinux.org/packages/extra/x86_64/smplayer/ ; 2025-06-09 08:36 UTC
sudo pacman -S --noconfirm --needed smplayer-skins  # Скины для SMPlayer ; https://smplayer.info/ ; https://archlinux.org/packages/extra/any/smplayer-skins/ ; 2024-07-13 21:54 UTC
sudo pacman -S --noconfirm --needed optipng  # Сжимает PNG-файлы до меньшего размера без потери информации ; https://archlinux.org/packages/extra/x86_64/optipng/ ; http://optipng.sourceforge.net/ ; 2025-05-25 07:04 UTC
#sudo pacman -S --noconfirm --needed smplayer-themes  # (необязательно) — коллекция тем иконок ; Темы для SMPlayer ; https://www.smplayer.info/ ; https://archlinux.org/packages/extra/any/smplayer-themes/ ; 2024-07-13 21:54 UTC
  echo ""
  echo " Посмотрите информацию о версии (smplayer) "
# smplayer --version  # Показать версию приложения
sudo pacman -Q smplayer  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
### Настройка SMPlayer:
# https://help.ubuntu.ru/wiki/smplayer
### После того как мы все установили, открываем SMPlayer:
# Настройки → Быстродействие → Допускать выпадение кадров отключаем.
# Настройки → Быстродействие → Потоков декодирования выставляем значение равное количеству ядер вашего процессора.
# Так же можно отключить петлевой фильтр, но это скажется на качестве:
# Настройки → Быстродействие → Петлевой фильтр → Пропускать (всегда).
# Отключение двойной буферизации может повысить производительность, но вызвать мерцание субтитров:
# Настройки → Основные → Видео → Двойная буферизация отключаем.
# Уже этого достаточно для плавного воспроизведения на компьютерах с многоядерным процессором.
# Пункты, которые написаны выше, обязательны к выполнению, даже не для HD-видео.
#####################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить VLC (vlc) - Многоплатформенный Проигрыватель для Linux?"
echo -e "${YELLOW}==> Примечание! ${BOLD}*Это отличный плеер и даже больше чем плеер, который может заменить несколько разных программ. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}VLC (Video LAN Client) — универсальный проигрыватель аудио и видео файлов для Linux. VLC media player — VLC — бесплатный и свободный кросс-платформенный медиаплеер и медиаплатформа с открытым исходным кодом. VLC воспроизводит множество мультимедийных файлов, а также DVD, Audio CD, VCD и сетевые трансляции. Изначально программа называлась VideоLAN, но была переименована. Полное название: VLC media player. Этот проект Лицензируется под GPL-2.0 или более поздняя версия, LGPL-2.1 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://www.videolan.org/vlc/ ; (https://archlinux.org/packages/extra/x86_64/vlc/). "
echo -e "${BLUE}:: ${NC}Возможности: Поддержка аппаратного декодирования. Поддержка практически всех видео и аудио форматов. Применение видео и аудио фильтров и эффектов. Поддержка субтитров. Изменение скорости воспроизведения. Выбор аудиорожки. Синхронизация субтитров. Синхронизация дорожек. Выбор режима стерео. Устранение чересстрочности (деинтерлейсинг). Создание снимков (скриншотов) видео. Поддержка расширений (модулей). Настройка интерфейса (изменение элементов панели инструментов). Проигрывание поврежденных файлов. И другие. "
echo -e "${CYAN}:: ${NC}*Поддерживаемые форматы: Форматы: MPEG (ES,PS,TS,PVA,MP3); AVI; ASF / WMV / WMA; MP4 / MOV / 3GP; OGG / OGM / Annodex; Matroska (MKV); Real; WAV (including DTS); Raw Audio: DTS; AAC; AC3/A52; Raw DV; FLAC; FLV (Flash); MXF; Nut; Standard MIDI / SMF; Creative™ Voice. *Видео кодеки: MPEG-1/2; DivX® (1/2/3/4/5/6); MPEG-4 ASP, XviD; 3ivX D4; H.261; H.263 / H.263i; H.264 / MPEG-4 AVC; Cinepak; Theora; Dirac / VC-2; MJPEG (A/B); WMV 1/2; WMV 3 / WMV-9 / VC-1; Sorenson 1/3; DV; On2 VP3/VP5/VP6; Indeo Video v3 (IV32); Real Video (1/2/3/4). *Аудио кодеки: MPEG Layer 1/2; MP3 - MPEG Layer 3; AAC - MPEG-4 part3; Vorbis; AC3 - A/52; E-AC-3; MLP / TrueHD>3; DTS; WMA 1/2; WMA 3; FLAC; ALAC; Speex; Musepack / MPC; ATRAC 3; Wavpack; Mod; TrueAudio; APE; Real Audio; Alaw/µlaw; AMR (3GPP); MIDI; LPCM; ADPCM; QCELP; DV Audio; QDM2/QDMC; MACE. *Специальные форматы: DVD; Text files (MicroDVD SubRIP SubViewer SSA1-5 SAMI VPlayer); Closed captions; Vobsub; Universal Subtitle Format (USF); SVCD / CVD; DVB; OGM; CMML; Kate; ID3 tags; APEv2; Vorbis comment. *Input Media: UDP/RTP Unicast; UDP/RTP Multicast; HTTP / FTP; MMS; TCP/RTP Unicast; DCCP/RTP Unicast; File; DVD Video; Video CD / VCD; SVCD; Audio CD (no DTS-CD); DVB (Satellite Digital TV Cable TV); MPEG encoder; Video acquisition. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_vlc  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_vlc" =~ [^10] ]]
do
    :
done
if [[ $in_vlc == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_vlc == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) VLC (vlc) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed faad2  # Бесплатный декодер Advanced Audio (AAC) ; https://archlinux.org/packages/extra/x86_64/faad2/ ; https://github.com/knik0/faad2 ; Обеспечивает: faad, libfaad.so=2-64, libfaad_drm.so=2-64 ; 2025-03-04 09:01 UTC
sudo pacman -S --noconfirm --needed mpg123  # (необязательно) – для воспроизведения MP1/MP2/MP3 ; Консольный проигрыватель MPEG Audio Player в реальном времени для уровней 1, 2 и 3 ; https://archlinux.org/packages/extra/x86_64/mpg123/ ; https://mpg123.de/ ; Обеспечивает: libmpg123.so=0-64, libout123.so=0-64, libsyn123.so=0-64 ; 28 июля 2025 г. 18:47 UTC
sudo pacman -S --noconfirm --needed lib32-mpg123  # (необязательно) – для воспроизведения MP1/MP2/MP3 ; Консольный проигрыватель MPEG Audio Player в реальном времени для уровней 1, 2 и 3 (32 бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-mpg123/ ; https://mpg123.de/ ; Обеспечивает: libmpg123.so=0-32, libout123.so=0-32, libsyn123.so=0-32 ; 2025-08-08 09:49 UTC
########### vlc #############
sudo pacman -S --noconfirm --needed vlc  # Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом ; https://archlinux.org/packages/extra/x86_64/vlc/ ; https://www.videolan.org/vlc/ ; Заменяет: vlc-plugin ; Конфликты: vlc-plugin ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed libvlc  # Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — библиотека ; https://archlinux.org/packages/extra/x86_64/libvlc/ ; https://www.videolan.org/vlc/ ; Обеспечивает: libvlc.so=5-64, libvlccore.so=9-64 ; 2025-08-26 22:16 UTC
############# vlc-cli ###############
sudo pacman -S --noconfirm --needed vlc-plugins-base  # Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — базовые плагины ; https://archlinux.org/packages/extra/x86_64/vlc-plugins-base/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-cli  # (необязательно) ;  Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — интерфейс командной строки ; https://archlinux.org/packages/extra/x86_64/vlc-cli/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
################  vlc-gui-qt ############
sudo pacman -S --noconfirm --needed vlc-plugin-lua  # Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагины для скриптов Lua ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-lua/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-pulse  # Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагины PulseAudio ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-pulse/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugins-video-output  # (необязательно) ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагины для вывода видео ; https://archlinux.org/packages/extra/x86_64/vlc-plugins-video-output/ ; https://www.videolan.org/vlc/ ; Обеспечивает: libvlc_vdpau.so=0-64, libvlc_xcb_events.so=0-64 ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-ffmpeg  # (необязательно) - for FFMPEG support ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагины FFMPEG ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-ffmpeg/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-gui-qt  # Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — Qt GUI ; https://archlinux.org/packages/extra/x86_64/vlc-gui-qt/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
#################
  echo ""
  echo " Установка дополнительных утилит (пакетов) плагинов "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed vlc-plugin-libsecret  # (необязательно) — для поддержки libsecret/gnome-keyring в Gnome ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагин libsecret/gnome-keyring ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-libsecret/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-avahi  # Мультиплатформенный проигрыватель MPEG, VCD/DVD и DivX — плагин mDNS/DNS-SD ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-avahi/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
#sudo pacman -S --noconfirm --needed vlc-plugin-alsa  # Многоплатформенный проигрыватель MPEG, VCD/DVD и DivX — плагины ALSA ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-alsa/ ; https://www.videolan.org/vlc/ ; 2025-07-08 20:26 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-matroska  # Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагин Matroska ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-matroska/ ; https://www.videolan.org/vlc/ ; 2025-07-23 20:53 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-x264  # (опционально) — для поддержки кодирования H264/AVC ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — кодирование H264/AVC ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-x264/ ; https://www.videolan.org/vlc/ ; 2025-07-23 20:53 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-x265  # (опционально) — для поддержки кодирования H265/HEVC ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — кодирование H265/HEVC ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-x265/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-opus  # Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагин Opus ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-opus/ ; https://www.videolan.org/vlc/ ; 2025-07-23 20:53 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-ffmpeg  # (опционально) — для доступа на основе FFMPEG, кодека, демультиплексора, пакетизатора, VDPAU, поддержки цветности видео и видеофильтра ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагины FFMPEG ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-ffmpeg/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-live555  # (опционально) — для поддержки доступа к потоку RTP/RTSP ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — клиентский плагин RTP/RSTP live555 ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-live555/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-dvb  # (опционально) — для доступа к DVB, поддержки мультиплексирования и демультиплексирования ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагины DVB ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-dvb/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
############ Зависимости необязательные ##############
sudo pacman -S --noconfirm --needed vlc-plugin-dvd  # (необязательно) — для поддержки доступа к DVD ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагины для DVD ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-dvd/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-gstreamer  # (необязательно) — для поддержки кодека GStreamer ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагин GStreamer ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-gstreamer/ ; https://www.videolan.org/vlc/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-mad  # (необязательно) — для поддержки аудиофильтра MPEG Audio Decoder ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагин MPEG Audio Decoder ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-mad/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-mpeg2  # (необязательно) — для поддержки кодека MPEG2 ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагин MPEG2 ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-mpeg2/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-mtp  # (необязательно) — для доступа к устройствам MTP и поддержки их обнаружения ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагины MTP ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-mtp/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-quicksync  # (необязательно) — для поддержки кодека Intel QuickSync H264/H262 ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагин Intel QuickSync ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-quicksync/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-samplerate  # (необязательно) — для поддержки аудиофильтра частоты дискретизации ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагин частоты дискретизации ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-samplerate/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-sdl  # (необязательно) — для поддержки кодека SDL ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагин SDL ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-sdl/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-sftp  # (необязательно) — для поддержки доступа SFTP ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагин SFTP ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-sftp/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-smb  # (необязательно) — для поддержки доступа SMB ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагин SMB ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-smb/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-soxr  # (необязательно) — для поддержки аудиофильтра SoX Resampler ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагин SoX Resampler ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-soxr/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-srt  # (необязательно) — для поддержки файлов субтитров SRT ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — поддержка файлов субтитров SRT ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-srt/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-svg  # (необязательно) — для поддержки кодека SVG и рендерера текста ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагины SVG ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-svg/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
sudo pacman -S --noconfirm --needed vlc-plugin-udev  # (необязательно) — для поддержки обнаружения служб ALSA с помощью udev ; Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — плагин udev ; https://archlinux.org/packages/extra/x86_64/vlc-plugin-udev/ ; https://www.videolan.org/vlc/ ; 2025-08-26 22:17 UTC
########## vlc-plugins-all ############
#sudo pacman -S --noconfirm --needed vlc-plugins-all  # Бесплатный кроссплатформенный медиаплеер и фреймворк с открытым исходным кодом — все плагины ; https://archlinux.org/packages/extra/x86_64/vlc-plugins-all/ ; https://www.videolan.org/vlc/ ; 2025-07-23 20:53 UTC
############# Дополнения ##################
# sudo pacman -S --noconfirm --needed playerctl  # Контроллер и библиотека медиаплеера mpris для Spotify, VLC, Audacious, BMP, XMMS2 и других. https://github.com/altdesktop/playerctl ; https://archlinux.org/packages/extra/x86_64/playerctl/ ; https://www.videolan.org/ ; https://www.videolan.org/vlc/download-archlinux.html ; Aug. 7, 2024, 2:52 a.m. UTC
#sudo pacman -S --noconfirm --needed syncplay  # Синхронизируйте просмотр фильмов на mplayer2, vlc, mpv и mpc-hc на многих компьютерах ; http://syncplay.pl/ ; https://archlinux.org/packages/extra/any/syncplay/ ; 29 апреля 2024 г., 22:37 UTC
#sudo pacman -S --noconfirm --needed phonon-qt6-vlc  # Бэкэнд Phonon VLC для Qt6 ; https://community.kde.org/Phonon ; https://archlinux.org/packages/extra/x86_64/phonon-qt6-vlc/ ; Ноябрь 10, 2023, 13:56 по всемирному координированному времени
#sudo pacman -S --noconfirm --needed phonon-qt5-vlc  # Бэкэнд Phonon VLC для Qt5 ; https://community.kde.org/Phonon ; https://archlinux.org/packages/extra/x86_64/phonon-qt5-vlc/ ; Ноябрь 10, 2023, 13:56 по всемирному координированному времени
  echo ""
  echo " Посмотрите информацию о версии (vlc) "
# vlc --version  # Показать версию приложения
sudo pacman -Q vlc  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить дополнения для проигрыватель VLC, если таковой был вами установлен?"
echo -e "${MAGENTA}:: ${BOLD}В сценарии (скрипте) представлены несколько утилит: ${NC}"
echo " VLC TuneIn Radio (vlc-tunein-radio) - скрипт (сценарий) LUA Service Discovery для VLC 2.x и 3.x, предназначен для прослушивания интернет-радиостанций в операционных системах Linux. "
echo " VLC Pause Click Plugin (vlc-pause-click-plugin) - плагин для VLC, который приостанавливает / воспроизводит видео по щелчку мыши. Может быть настроена для хорошей работы с двойным щелчком в полноэкранном режиме, включив в настройках параметр - Предотвратить запуск паузы / воспроизведения при двойном щелчке. По умолчанию вместо этого он приостанавливается при каждом щелчке."
echo " Домашняя страница: https://github.com/diegofn/TuneIn-Radio-VLC ; (https://github.com/nurupo/vlc-pause-click-plugin ; https://aur.archlinux.org/packages/vlc-pause-click-plugin ; https://aur.archlinux.org/packages/vlc-tunein-radio ; https://aur.archlinux.org/packages/vlc-plugin-ytdl-git ; https://git.remlab.net/gitweb/?p=vlc-plugin-ytdl.git;a=blob;f=README). "
echo -e "${CYAN}:: ${NC}Установка  VLC TuneIn Radio (vlc-tunein-radio), и VLC Pause Click Plugin (vlc-pause-click-plugin) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/vlc-tunein-radio.git), (https://aur.archlinux.org/vlc-pause-click-plugin.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить действие: " vlc_plugin  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$vlc_plugin" =~ [^10] ]]
do
    :
done
if [[ $vlc_plugin == 0 ]]; then
echo ""
echo " Установка дополнительных пакетов для проигрыватель VLC пропущена "
elif [[ $vlc_plugin == 1 ]]; then
echo ""
echo " Установка дополнительных пакетов для проигрыватель VLC "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
############ vlc-tunein-radio ##########
yay -S vlc-tunein-radio --noconfirm  # Скрипт TuneIn Radio LUA для VLC 2.x,3.x ; https://aur.archlinux.org/vlc-tunein-radio.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/diegofn/TuneIn-Radio-VLC ; https://aur.archlinux.org/packages/vlc-tunein-radio ; 2020-07-24 06:37 (UTC)
############ vlc-tunein-radio ##########
#git clone https://aur.archlinux.org/vlc-tunein-radio.git   # Скрипт TuneIn Radio LUA для VLC 2.x,3.x
#cd vlc-tunein-radio
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf vlc-tunein-radio
#rm -Rf vlc-tunein-radio
echo ""
echo " Установка VLC TuneIn Radio (vlc-tunein-radio) выполнена "
############ vlc-pause-click-plugin ##########
yay -S vlc-pause-click-plugin --noconfirm  # Плагин для VLC, который приостанавливает / воспроизводит видео по щелчку мыши ; https://aur.archlinux.org/vlc-pause-click-plugin.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/nurupo/vlc-pause-click-plugin ; https://aur.archlinux.org/packages/vlc-pause-click-plugin ; https://github.com/nurupo/vlc-pause-click-plugin/archive/2.2.0.tar.gz ; 2020-05-20 08:17 (UTC)
############ vlc-pause-click-plugin ##########
#git clone https://aur.archlinux.org/vlc-pause-click-plugin.git  # (только для чтения, нажмите, чтобы скопировать)
#cd vlc-pause-click-plugin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf vlc-pause-click-plugin
#rm -Rf vlc-pause-click-plugin
echo ""
echo " Установка VLC Pause Click Plugin (vlc-pause-click-plugin) выполнена "
############ vlc-plugin-ytdl-git ##########
sudo pacman -S --noconfirm --needed yt-dlp  # Форк youtube-dl с дополнительными функциями и исправлениями ; https://archlinux.org/packages/extra/any/yt-dlp/ ; https://github.com/yt-dlp/yt-dlp
yay -S vlc-plugin-ytdl-git --noconfirm  # Плагин VLC для youtube-dl ; https://aur.archlinux.org/vlc-plugin-ytdl-git.git (только для чтения, нажмите, чтобы скопировать) ; https://git.remlab.net/gitweb/?p=vlc-plugin-ytdl.git;a=blob;f=README ; https://aur.archlinux.org/packages/vlc-plugin-ytdl-git ; Конфликты:  vlc-plugin-ytdl ; 2023-01-12 23:12 (UTC)
#git clone https://aur.archlinux.org/vlc-plugin-ytdl-git.git
#cd vlc-plugin-ytdl-git
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf vlc-plugin-ytdl-git
#rm -Rf vlc-plugin-ytdl-git
echo ""
echo " Установка YT-DLP plug-in for LibVLC (vlc-plugin-ytdl-git) выполнена "
fi
######### Справка ###########
# https://github.com/diegofn/TuneIn-Radio-VLC
# https://github.com/nurupo/vlc-pause-click-plugin
# https://aur.archlinux.org/packages/vlc-pause-click-plugin
# https://aur.archlinux.org/packages/vlc-tunein-radio
# https://aur.archlinux.org/packages/vlc-plugin-ytdl-git
# https://git.remlab.net/gitweb/?p=vlc-plugin-ytdl.git;a=blob;f=README
# Делаем Play и Pause кликом мыши в плеере vlc - Видео
# https://www.youtube.com/watch?v=G05VGD2_jGo&t=1s
##############################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Celluloid (celluloid) - Простой интерфейс GTK+ для MPV?"
echo -e "${MAGENTA}:: ${BOLD}Celluloid (ранее GNOME MPV) — это простой GTK+-фронтенд для mpv. Он нацелен на простоту использования при сохранении высокого уровня настраиваемости. Celluloid - это медиаплеер для Linux. Это интерфейс к командной строке приложения MPV, который может обрабатывать множество видео- и аудиоформатов. Кроме того, приложение Celluloid поддерживает MPRIS (управление клавишами мультимедиа) и позволяет пользователям управлять воспроизведением прямо с клавиатуры. ${NC}"
echo " Домашняя страница: https://celluloid-player.github.io/ ; (https://archlinux.org/packages/extra/x86_64/celluloid/). "
echo -e "${MAGENTA}:: ${BOLD}Дизайн Celluloid соответствует GNOME Human Interface Guidelines, но может быть адаптирован и для других систем, не использующих клиентские декорации (CSD). Он основан на библиотеке mpv и GTK. По умолчанию плейлист скрыт. Чтобы отобразить плейлист, щелкните пункт меню «Плейлист» или нажмите F9. Файлы можно добавлять, перетаскивая файлы или URI в плейлист. Перетаскивание файлов или URI в область видео заменит содержимое плейлиста. Файлы плейлистов или онлайн-плейлисты (например, плейлист YouTube) будут автоматически развернуты в отдельные элементы при загрузке. Элементы в плейлисте можно переупорядочивать с помощью перетаскивания. Чтобы удалить элементы из плейлиста, выберите элемент, щелкнув по нему, а затем нажмите кнопку удаления на клавиатуре. ${NC}"
echo -e "${BLUE}:: ${NC}Функции: Celluloid может использовать файлы конфигурации mpv как есть. Сочетания клавиш можно настроить с помощью входного файла конфигурации mpv. Celluloid реализует интерфейс MPRIS D-Bus. Это обеспечивает лучшую интеграцию с настольными средами, имеющими совместимые клиенты MPRIS. Он поддерживает плейлисты и элементы управления медиаплеером MPRIS2. Записи в плейлисте можно легко добавлять, удалять или переупорядочивать с помощью операций перетаскивания. Целлулоид полностью функционален на Wayland. Исходный код: Open Source (открыт); Языки программирования: C; Библиотеки: GTK; Лицензия: GNU GPL; Приложение переведено на русский язык. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_celluloid  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_celluloid" =~ [^10] ]]
do
    :
done
if [[ $in_celluloid == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_celluloid == 1 ]]; then
  echo ""
  echo " Установка Celluloid (celluloid) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed mpv  # Бесплатный, открытый и кроссплатформенный медиаплеер ; https://archlinux.org/packages/extra/x86_64/mpv/ ; https://mpv.io/ ; Обеспечивает: libmpv.so=2-64 ; 2025-07-29 22:37 UTC
sudo pacman -S --noconfirm --needed mpv-mpris  # Плагин MPRIS для MPV ; https://archlinux.org/packages/extra/x86_64/mpv-mpris/ ; https://github.com/hoyon/mpv-mpris ; 2024-11-07 20:02 UTC
sudo pacman -S --noconfirm --needed mpv-shim-default-shaders  # Предварительно настроенный набор шейдеров MPV и конфигураций для медиа-клиентов MPV Shim ; https://archlinux.org/packages/extra/any/mpv-shim-default-shaders/ ; https://github.com/iwalton3/default-shader-pack ; 2024-09-15 19:59 UTC
sudo pacman -S --noconfirm --needed jellyfin-mpv-shim  # Транслировать медиафайлы из мобильных и веб-приложений Jellyfin на MPV ; https://archlinux.org/packages/extra/any/jellyfin-mpv-shim/ ; https://github.com/jellyfin/jellyfin-mpv-shim ; 2025-03-18 17:11 UTC
sudo pacman -S --noconfirm --needed python-mpv-jsonipc  # API Python для MPV с использованием JSON IPC ; https://archlinux.org/packages/extra/any/python-mpv-jsonipc/ ; https://github.com/iwalton3/python-mpv-jsonipc ; 2025-03-30 18:16 UTC
sudo pacman -S --noconfirm --needed yt-dlp  # (необязательно) — видео и трансляции на YouTube ; Форк youtube-dl с дополнительными функциями и исправлениями ; https://archlinux.org/packages/extra/any/yt-dlp/ ; https://github.com/yt-dlp/yt-dlp ; Aug. 8, 2024, 3:05 p.m. UTC
############ celluloid ##############
sudo pacman -S --noconfirm --needed celluloid # Простой интерфейс GTK+ для mpv ; https://celluloid-player.github.io/ ; https://archlinux.org/packages/extra/x86_64/celluloid/ ; https://github.com/celluloid-player/celluloid ; Заменяет gnome-mpv ; 2025-06-08 13:46 UTC
# sudo pacman -Rcns celluloid  # Чтобы удалить celluloid в Arch Linux
  echo ""
  echo " Посмотрите информацию о версии (celluloid) "
sudo pacman -Q celluloid  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Parole (parole) — Плеер без наворотов?"
echo -e "${MAGENTA}:: ${BOLD}Parole - это современный, мультимедийный проигрыватель для проигрывания видео и аудио файлов, бесплатный с открытым исходным кодом для графической среды Xfce. Parole основан на фреймворке GStreamer и написан так, чтобы хорошо вписываться в рабочий стол Xfce. К основным характеристикам можно отнести легкость и, в особенности, поддержку наиболее популярных форматов видео и аудиофайлов, а также возможность управления воспроизведением DVD Video. Среди наиболее популярных форматов, которые мы можем воспроизводить с помощью Parole media player, вы найдете: AVI, MP4, MPGE, MKV, WMV, FLV, MP3, AAC, WMA и многие другие. Исходный код: Open Source (открыт). Языки программирования: C. Библиотеки: GStreamer. Приложение переведено на русский язык. Этот проект Лицензируется под GPL-2.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://docs.xfce.org/apps/parole/start ; (https://archlinux.org/packages/extra/x86_64/parole/ ; https://github.com/xfce-mirror/parole ; https://docs.xfce.org/apps/parole/plugins ; https://docs.xfce.org/apps/parole/command-line). "
echo -e "${BLUE}:: ${NC}Возможности: Поддерживает большое количество форматов видео и аудио (все форматы поддерживаемые GStreamer); Parole позволяет воспроизводить DVD/CD, VCD диски, образы дисков; Поддержка потокового вещания (поддержка прямых трансляций); Поддерживаются субтитры на различных языках; Parole может быть интегрирован в файловый менеджер Thunar; Есть возможность включения повтора как отдельного файла так и всего списка воспроизведения; Имеется возможность изменить соотношение сторон; Поддержка полноэкранного режима; В боковой панели справа показываются список воспроизведения; Имеется режим “Мини”; Поддержка плейлистов; Функции воспроизведения: воспроизведение/пауза, переключение треков, перемотка, изменение/выключение громкости, повтор, воспроизведение в случайном порядке; Есть возможность включить/выключить отключение хранителя экрана на время проигрывания; Имеется возможность включить/выключить визуализацию при воспроизведении аудио;Существует возможность настроить баланс цвета; Поддержка плагинов: интеграция с системным треем, уведомления, поддержка MPRIS2; Поддержка сочетаний (горячих) клавиш. "
echo -e "${CYAN}:: ${NC}Parole расширяется с помощью плагинов. Он поддерживает плагины, с помощью которых мы можем еще больше улучшить его работу , что позволяет нам получить лучший опыт использования этого проигрывателя. Плагины: В настоящее время Parole включает в себя следующие плагины: Notify , который показывает уведомления (с помощью libnotify) об изменениях треков. Значок на панели задач , позволяющий свернуть Parole в системный трей, где также можно управлять воспроизведением. MPRIS2 , который позволяет осуществлять удаленное управление; например, с помощью расширения «индикатор медиаплеера» Gnome3 или звукового меню Ubuntu. Подробнее о плагинах для Parole читайте здесь (https://docs.xfce.org/apps/parole/plugins). "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_parole  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_parole" =~ [^10] ]]
do
    :
done
if [[ $in_parole == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_parole == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Parole (parole) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
####### parole  ##########
sudo pacman -S --noconfirm --needed parole  # Современный медиаплеер на базе фреймворка GStreamer ; https://archlinux.org/packages/extra/x86_64/parole/ ; https://docs.xfce.org/apps/parole/start ; https://github.com/xfce-mirror/parole ; https://docs.xfce.org/apps/parole/plugins ; https://docs.xfce.org/apps/parole/command-line ; Группы: xfce4-goodies ; 2025-05-22 05:32 UTC
  echo ""
  echo " Установка дополнительных утилит (пакетов) плагины "
######## Parole Plugins ########
sudo pacman -S --noconfirm --needed gst-plugins-base-libs  # Фреймворк мультимедийного графа - основа ; https://archlinux.org/packages/extra/x86_64/gst-plugins-base-libs/ ; https://gstreamer.freedesktop.org/ ; 2025-08-08 06:45 UTC
sudo pacman -S --noconfirm --needed lib32-gst-plugins-base-libs  # Мультимедийный граф-фреймворк (32-бит) - базовый ; https://archlinux.org/packages/multilib/x86_64/lib32-gst-plugins-base-libs/ ; https://gstreamer.freedesktop.org/ ; 2025-08-08 06:45 UTC
sudo pacman -S --noconfirm --needed gst-plugins-base  # Фреймворк мультимедийного графа - базовые плагины ; https://archlinux.org/packages/extra/x86_64/gst-plugins-base/ ; https://gstreamer.freedesktop.org/ ; 2025-08-08 06:45 UTC
sudo pacman -S --noconfirm --needed lib32-gst-plugins-base  # Мультимедийный граф-фреймворк (32-бит) - базовые плагины ; https://archlinux.org/packages/multilib/x86_64/lib32-gst-plugins-base/ ; https://gstreamer.freedesktop.org/ ; 2025-08-08 06:45 UTC
sudo pacman -S --noconfirm --needed gst-plugins-good  #  Это GStreamer, мультимедийный фреймворк для потоковой передачи мультимедиа - хорошие плагины ; https://gstreamer.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/gst-plugins-good/ ; 2025-08-08 06:45 UTC
sudo pacman -S --noconfirm --needed lib32-gst-plugins-good  # Мультимедийный граф-фреймворк (32-бит) - хорошие плагины ; https://archlinux.org/packages/multilib/x86_64/lib32-gst-plugins-good/ ; https://gstreamer.freedesktop.org/ ; 2025-08-08 06:45 UTC
sudo pacman -S --noconfirm --needed grilo  # Фреймворк, обеспечивающий доступ к различным источникам мультимедийного контента ; https://archlinux.org/packages/extra/x86_64/grilo/ ; https://wiki.gnome.org/Projects/Grilo ; Обеспечивает: libgrilo-0.3.so=0-64, libgrlnet-0.3.so=0-64, libgrlpls-0.3.so=0-64 ; 2025-06-13 22:55 UTC
sudo pacman -S --noconfirm --needed grilo-plugins  # (необязательно) — плагин Grilo для медиа-браузера ; Коллекция плагинов для фреймворка Grilo ; https://archlinux.org/packages/extra/x86_64/grilo-plugins/ ; https://gitlab.gnome.org/GNOME/grilo-plugins ; 2025-06-25 09:26 UTC
sudo pacman -S --noconfirm --needed gst-libav  # (необязательно) — дополнительные медиакодеки ; Фреймворк мультимедийных графов — плагин libav ; https://archlinux.org/packages/extra/x86_64/gst-libav/ ; https://gstreamer.freedesktop.org/ ; Обеспечивает: gst-ffmpeg=1.26.5-1 ; 2025-08-08 06:45 UTC
sudo pacman -S --noconfirm --needed gst-plugins-bad  # (необязательно) — Дополнительные медиакодеки ; Мультимедийный граф-фреймворк — плохие плагины ; https://archlinux.org/packages/extra/x86_64/gst-plugins-bad/ ; https://gstreamer.freedesktop.org/ ; 2025-08-08 06:45 UTC
sudo pacman -S --noconfirm --needed gst-plugins-ugly  # (необязательно) — Дополнительные медиакодеки ; Фреймворк мультимедийных графов — уродливые плагины ; https://archlinux.org/packages/extra/x86_64/gst-plugins-ugly/ ; https://gstreamer.freedesktop.org/ ; 2025-08-08 06:45 UTC
sudo pacman -S --noconfirm --needed libdmapsharing  # (необязательно) — плагин DAAP Music Sharing ; Библиотека, реализующая семейство протоколов DMAP ; https://archlinux.org/packages/extra/x86_64/libdmapsharing/ ; https://www.flyn.org/projects/libdmapsharing/index.html ; Обеспечивает: libdmapsharing-4.0.so=3-64 ; 2023-07-30 01:24 UTC
  echo ""
  echo " Посмотрите информацию о версии (parole) "
# sudo parole --version  # Показать версию приложения
sudo pacman -Q parole  #  Показать версию приложения ; Альтернативный метод — проверить версию установленного пакета NTP через менеджер пакетов системы.
# sudo pacman -Qs имя_пакета  # Используйте команду pacman с -Qs опцией поиска только среди установленных пакетов в системе. Она ищет указанный текст только в названиях и описаниях установленных пакетов.
# sudo pacman -Qi имя_пакета  # Эта -Qi опция отображает подробную информацию об указанном пакете. Она также показывает метаданные пакета, такие как зависимости, конфликты, дата установки, дата сборки, размер и т. д.
# sudo pacman -Si имя_пакета  # Эта -Si опция позволяет просматривать подробную информацию о любых пакетах Arch Linux. Необходимо указать точное название пакета.
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# https://archlinux.org/packages/extra/x86_64/parole/
# https://docs.xfce.org/apps/parole/start
# https://github.com/xfce-mirror/parole
# https://docs.xfce.org/apps/parole/plugins
# https://docs.xfce.org/apps/parole/command-line
#######################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить QMPlay2 (Qt Media Player 2) (qmplay2) — Аудио и видеопроигрыватель?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Рекомендую попробовать тем, кто испытывает проблемы с открытием редких форматов и/или имеет слабое железо. На странице описана установка для множества дистрибутивов и сборка из исходников. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}QMPlay2 — это видео- и аудиоплеер. Он воспроизводит все форматы, поддерживаемые FFmpeg и libmodplug (включая J2B и SFX). Также поддерживает Audio CD, RAW-файлы, музыку из Rayman 2 и чиптюны. Включает YouTube и браузер MyFreeMP3. Внешний вид: Внешне программа абсолютно не примечательна, скорее наоборот — интерфейс топорный, очень похоже на KMail. Есть выбор стиля в настройках (Breeze, Oxygen, Window, Fusion), переключение между тёмным и светлым оформлением происходит автоматически, в зависимости от настроек системы. Плюсом является то, что интерфейс динамический, то есть панели можно включать/отключать и размещать по желанию, закрепить удобный вариант. Поддержка работы с профилями для быстрой смены настроек. Программа так бы и осталась безликой, если не множество настроек по работе с железом: Настройки отрисовщика (поддержка видеокарты для ускорения); Приоритет вывода аудио: PipeWire, PulseAudio, ALSA. Если вы используете собственную конфигурацию ALSA asound.conf, .asoundrc вам также следует добавить: defaults.namehint.!showall on в файл конфигурации. В противном случае добавленные устройства могут быть не видны! Приоритет декодеров. Во вкладке «Модули» есть выбор устройства воспроизведения, аппаратное декодирование и ещё много возможностей в виде галочек, в которых я не сильно понимаю; Вкладки «Субтитры» и «Экранное меню» не активны у меня; В последней вкладке «Видеофильтры» устранение черезстрочности и прочее. Этот проект Лицензируется под LGPL. ${NC}"
echo " Домашняя страница: https://github.com/zaps166/QMPlay2 ; (https://aur.archlinux.org/packages/qmplay2). "
echo -e "${BLUE}:: ${NC}Кроме списка воспроизведения есть эквалайзер, что ныне редкость. Может воспроизводить все форматы, поддерживаемые FFmpeg, libmodplug (включая J2B и SFX). Также поддерживает Audio CD, необработанные файлы, музыку Rayman 2 и чиптюны. Содержит браузер YouTube и MyFreeMP3. Среди настроек разные соотношения сторон и настройка аудиоканалов (моно, стерео, 4.0, 5.1 и 7.1). Утверждается, что программа работает с YouTube, для чего нужна поддержка yt-dlp. Но у меня это завести не получилось. По нажатию ЛКМ пауза, а ПКМ открывает меню, так что его можно скрыть. QMPlay2 поддерживает аппаратное декодирование видео: Vulkan Video, CUVID (только NVIDIA), DXVA2 (Windows), D3D11VA (Vulkan, Windows), VA-API (только Linux/BSD) и VideoToolBox (только macOS). Аппаратное ускорение по умолчанию отключено, но его можно включить в разделе «Настройки» -> «Настройки воспроизведения»: переместить аппаратно-ускоренный декодер в список декодеров наверх, применить настройки. "
echo -e "${CYAN}:: ${NC}YouTube: Вы можете изменить качество звука и видео по умолчанию для контента YouTube. Нажмите на значок «Настройки» слева от строки поиска, измените порядок приоритетов качества звука и/или видео и примените изменения. Если выбранное качество не найдено в контенте YouTube, QMPlay2 попытается использовать следующее качество в списке. Видео с YouTube не работают без внешнего ПО "yt-dlp", поэтому QMPlay2 загрузит его автоматически. Вы можете удалить загруженный "yt-dlp" в настройках. QMPlay2 поддерживает сферический вид на выходах OpenGL и Vulkan. Вы можете смотреть, например, сферические видео с YouTube, нажав Ctrl+3. Также можно включить сферический вид в меню: «Воспроизведение» -> «Видеофильтры» -> «Сферический вид». "
echo -e "${CYAN}:: ${NC}Установка QMPlay2 (qmplay2) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/qmplay2.git), (https://aur.archlinux.org/packages/qmplay2) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_qmplay  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_qmplay" =~ [^10] ]]
do
    :
done
if [[ $in_qmplay == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_qmplay == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) QMPlay2 (Qt Media Player 2) (qmplay2) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########### qmplay2 #############
yay -S qmplay2 --noconfirm  # QMPlay2 — видео- и аудиоплеер, способный воспроизводить большинство форматов и кодеков ; https://aur.archlinux.org/packages/qmplay2 ; https://aur.archlinux.org/qmplay2.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/zaps166/QMPlay2 ; 2025-06-27 16:29 (UTC)
######## ИЛИ #########
# yay -S qmplay2-appimage --noconfirm  # Видео- и аудиоплеер, способный воспроизводить большинство форматов и кодеков ; https://aur.archlinux.org/packages/qmplay2-appimage ; https://aur.archlinux.org/qmplay2-appimage.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/zaps166/QMPlay2 ; Конфликты: с qmplay2 ; Обеспечивает: qmplay2 ; 28 июня 2025 г. 09:12 (UTC)
# yay -S qmplay2-git --noconfirm  # QMPlay2 — видео- и аудиоплеер, способный воспроизводить большинство форматов и кодеков ; https://aur.archlinux.org/packages/qmplay2-git ; https://aur.archlinux.org/qmplay2-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/zaps166/QMPlay2 ; Конфликты: qmplay2 ; Обеспечивает: qmplay2 ; 28 июня 2025 г. 08:06 (UTC)
########### qmplay2 #############
#git clone https://aur.archlinux.org/qmplay2.git  # (только для чтения, нажмите, чтобы скопировать)
#cd qmplay2
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf qmplay2
#rm -Rf qmplay2
  echo ""
  echo " Посмотрите информацию о версии (qmplay2) "
sudo pacman -Q qmplay2  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Hypnotix (hypnotix) - Просмотра IPTV (прямых трансляций, фильмов и сериалов)?"
echo -e "${MAGENTA}:: ${BOLD}Hypnotix — это приложение для потоковой передачи IPTV с поддержкой прямых трансляций (прямого эфира ТВ), фильмов и сериалов. Справка: Hypnotix не предоставляет контент или телевизионные каналы, это плеер. Hypnotix поставляется с предварительно настроенным поставщиком IPTV под названием Free-TV. Free IPTV — проект с более 2000 телеканалов, которые можно смотреть бесплатно и законно. ${NC}"
echo " Домашняя страница: https://github.com/linuxmint/hypnotix ; (https://aur.archlinux.org/packages/hypnotix). "
echo -e "${MAGENTA}:: ${BOLD}Он имеет простой интерфейс и использует пакет libmpv для облегченного потокового вещания. Каналы классифицируются по странам и поддерживает воспроизведение из нескольких источников, таких как URL-адреса M3U и API Xtream. По умолчанию поставляется с одним пейлистом, который удобно разбит по странам. Но вы туда можете загрузить сколько угодно плейлистов. В интернете вы найдете еще по запросу плейлист для IPTV. Повторюсь! Hypnotix не предоставляет контент или телеканалы, это приложение-плеер, которое транслирует потоки от провайдеров IPTV. По умолчанию Hypnotix настроен на работу с одним провайдером IPTV под названием Free-TV: https://github.com/Free-TV/IPTV . Этот поставщик был выбран, поскольку он удовлетворял следующим критериям: Включает только бесплатный, легальный, общедоступный контент. Группирует телеканалы по странам. Не содержит контента для взрослых. По вопросам, связанным с телеканалами и медиаконтентом, следует обращаться непосредственно к соответствующему провайдеру. Примечание: Вы можете свободно удалить Free-TV из Hypnotix, если вы им не пользуетесь, или добавить любого другого провайдера, к которому у вас есть доступ, или локальные плейлисты M3U. ${NC}"
echo -e "${CYAN}:: ${NC}Функции: Есть возможность просматривать Интернет-тв и прослушивать радио; Имеется большое количество телеканалов и радиостанций, в том числе и русскоязычных; Есть возможность добавить вручную интернет-каналы и радиостанции: программа Hypnotix поддерживает поставщиков IPTV, использующих URL-адрес M3U, API Xtream или локальный список воспроизведения M3U; Поддержка просмотра в полноэкранном и оконном режиме; Функции воспроизведения: воспроизведение/пауза, перемотка, изменение громкости. Совместимость с Wayland. "
echo -e "${CYAN}:: ${NC}Установка Hypnotix (hypnotix) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/hypnotix.git), (https://aur.archlinux.org/packages/hypnotix) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_hypnotix  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_hypnotix" =~ [^10] ]]
do
    :
done
if [[ $in_hypnotix == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_hypnotix == 1 ]]; then
  echo ""
  echo " Установка Hypnotix (hypnotix) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
########## Зависимости ###########
########## circle-flags ###########
yay -S circle-flags --noconfirm  # Коллекция круглых флагов в формате SVG ; https://aur.archlinux.org/circle-flags.git (только для чтения, нажмите, чтобы скопировать) ; http://packages.linuxmint.com/pool/main/c/circle-flags ; https://aur.archlinux.org/packages/circle-flags ; http://packages.linuxmint.com/pool/main/c/circle-flags/circle-flags_2.6.2.tar.xz ; 2023-09-23 00:31 (UTC)
####### python-cinemagoer ##########
yay -S python-cinemagoer --noconfirm  # Привязки Python для Internet Movie Database (IMDb) ; https://aur.archlinux.org/python-cinemagoer.git (только для чтения, нажмите, чтобы скопировать) ; https://cinemagoer.github.io/ ; https://aur.archlinux.org/packages/python-cinemagoer ; https://github.com/cinemagoer/cinemagoer/archive/refs/tags/2023.05.01.tar.gz ; Конфликты: с python-imdbpy ; Смотрите Зависимости !
######## hypnotix ###########
yay -S hypnotix --noconfirm  # Приложение для потоковой передачи IPTV с поддержкой прямых трансляций, фильмов и сериалов ; https://aur.archlinux.org/hypnotix.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/linuxmint/hypnotix ; https://aur.archlinux.org/packages/hypnotix ; https://github.com/linuxmint/hypnotix/archive/refs/tags/4.6.tar.gz ; 2024-07-21 18:08 (UTC) ; Смотрите Зависимости !
#yay -Sa --noconfirm hypnotix
#git clone https://aur.archlinux.org/hypnotix.git   # (только для чтения, нажмите, чтобы скопировать)
#cd hypnotix
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf hypnotix
#rm -Rf hypnotix
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
######### Справка #########
# Совместимость с Wayland:
# Если вы используете Wayland, перейдите в настройки Hypnotix и добавьте следующее в список параметров MPV:
# vo=x11
# Запустите Hypnotix с помощью:
# GDK_BACKEND=x11 hypnotix
############################

clear
echo ""
echo -e "${BLUE}:: ${NC}YoutubeDl (youtube-dl) - Инструмент для загрузки видео из командной строки для Linux?"
echo -e "${MAGENTA}:: ${BOLD}YoutubeDl — это небольшой инструмент командной строки на основе Python, который позволяет загружать видео с YouTube.com, Dailymotion, Google Video, Photobucket, Facebook, Yahoo, Metacafe, Depositfiles и еще нескольких похожих сайтов. Он написан на pygtk и требует запуска интерпретатора Python для этой программы, он не ограничен платформой. Для youtube-dl требуется интерпретатор Python (2.6, 2.7 или 3.2+), и она не привязана к платформе. Мы также предоставляем исполняемый файл Windows, который включает Python. youtube-dl должен работать в вашей Unix-системе, в Windows или в Mac OS X. Она выпущена в общественное достояние, что означает, что вы можете изменять ее, распространять или использовать по своему усмотрению. Примечание: В вашей системе должны быть установлены пакеты curl или wget для загрузки файла youtube-dl последней версии. ${NC}"
echo " Домашняя страница: https://aur.archlinux.org/packages/youtube-dl ; (https://ytdl-org.github.io/youtube-dl/), (https://ytdl-org.github.io/youtube-dl/supportedsites.html), (https://github.com/ytdl-org/youtube-dl/blob/master/README.md#readme) "
echo -e "${MAGENTA}:: ${BOLD} Недавно на YouTube-dl добавлена ​​поддержка загрузки видео для 17 новых веб-сайтов: brightcove.com, auengine.com, RingTV, instagram.com, Jukebox, 3sat, CSpan, Statigr.am, traileraddict.com, hotnewhiphop.com, wat.tv, tu.tv, gamespot.com, tudou.com, Wimp.com, archive.org и break.com . youtube-dl также позволяет выбрать конкретный доступный формат качества видео для загрузки или позволить самой программе автоматически загружать видео более высокого качества с сайта. Он также поддерживает загрузку плейлистов для конкретного пользователя, опции для добавления пользовательского или оригинального заголовка к загруженному видеофайлу, поддержка прокси и многое другое. ${NC}"
echo " Инструмент youtube-dl поддерживает возобновление прерванных загрузок. Если youtube-dl будет остановлен (например, с помощью Ctrl-C или из-за потери подключения к Интернету) в середине загрузки, вы можете просто перезапустить его с тем же URL-адресом видео YouTube. Он автоматически возобновит незавершенную загрузку, пока в текущем каталоге есть частичная загрузка. Это означает, что вам не нужны менеджеры загрузок в Linux только для возобновления загрузок. "
echo " Выводы: Утилита youtube-dl пригодится всем, кто хочет скачивать музыку и видео с сайтов, где такая функция не предусмотрена. У неё множество гибких настроек и всего лишь один минус — отсутствие полноценной графической оболочки. В менеджере приложений Ubuntu можно найти Gydl — оболочку youtube-dl с очень обрезанным набором возможностей, в целом её работоспособность оставляет желать лучшего. 🚧 Внимание! Загрузка видео с веб-сайтов может противоречить их политике. Вам решать, загружать ли видео. Кроме того, для этого инструмента нет релиза из-за различных проблем с авторскими правами в прошлом. "
echo -e "${CYAN}:: ${NC}Установка YoutubeDl (youtube-dl) проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/youtube-dl), (https://aur.archlinux.org/youtube-dl.git) - собирается и устанавливается. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_youtubedl  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_youtubedl" =~ [^10] ]]
do
    :
done
if [[ $in_youtubedl == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_youtubedl == 1 ]]; then
  echo ""
  echo " Установка YoutubeDl (youtube-dl) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
############### Зависимости ###############
sudo pacman -S --noconfirm --needed python  # Язык программирования Python ; https://archlinux.org/packages/core/x86_64/python/ ; https://www.python.org/ ; Обеспечивает: python-externally-managed, python3 ; Заменяет: python-externally-managed, python3 ; 2025-06-23 18:22 UTC
sudo pacman -S --noconfirm --needed python-setuptools  # Простая загрузка, сборка, установка, обновление и удаление пакетов Python ; https://archlinux.org/packages/extra/any/python-setuptools/ ; https://pypi.org/project/setuptools/ ; Обеспечивает: python-distribute ; Заменяет: python-distribute ; 2025-06-01 02:32 UTC
sudo pacman -S --noconfirm --needed atomicparsley  # Программа командной строки для чтения, анализа и настройки метаданных в файлах MPEG-4 ; https://archlinux.org/packages/extra/x86_64/atomicparsley/ ; https://github.com/wez/atomicparsley ; 2024-07-22 02:07 UTC
sudo pacman -S --noconfirm --needed ffmpeg  # Комплексное решение для записи, конвертации и потоковой передачи аудио и видео ; https://archlinux.org/packages/extra/x86_64/ffmpeg/ ; https://ffmpeg.org/ ; Обеспечивает:  libavcodec.so=61-64, libavdevice.so=61-64, libavfilter.so=10-64, libavformat.so=61-64, libavutil.so=59-64, Подробнее… (https://archlinux.org/packages/extra/x86_64/ffmpeg/#); 2025-06-10 07:19 UTC
sudo pacman -S --noconfirm --needed python-pycryptodome  # Коллекция криптографических алгоритмов и протоколов, реализованных для использования из Python 3 ; https://archlinux.org/packages/extra/x86_64/python-pycryptodome/ ; https://www.pycryptodome.org/ ; Обеспечивает: python-crypto ; Заменяет: python-crypto ; Конфликты: с python-crypto ; 2025-05-22 19:06 UTC
sudo pacman -S --noconfirm --needed rtmpdump  # Набор инструментов для RTMP-потоков ; https://archlinux.org/packages/extra/x86_64/rtmpdump/ ; https://rtmpdump.mplayerhq.hu/ ; Обеспечивает: librtmp.so=1-64 ; 2024-03-05 21:51 UTC
########### zenity ##########
sudo pacman -S --noconfirm --needed zenity  # Отображение графических диалоговых окон из сценариев оболочки ; https://archlinux.org/packages/extra/x86_64/zenity/ ; https://gitlab.gnome.org/GNOME/zenity ; 2025-03-22 14:55 UTC
########### youtube-dl ############
### *Нужно импортировать ключи youtube-#dl: (требуется для: youtube-#dl-2021.12.17-4)
# gpg --recv-keys ED7F5BF46B3BBED81C87368E2C393E0F18A9236D
# ED7F5BF46B3BBED81C87368E2C393E0F18A9236D требуется для: youtube-#dl-2021.12.17-4
#curl 'https://aur.archlinux.org/cgit/aur.git/plain/keys/pgp/ED7F5BF46B3BBED81C87368E2C393E0F18A9236D.asc?h=youtube-#dl' | gpg --import
########### youtube-dl ############
yay -S youtube-dl --noconfirm  # Программа командной строки для загрузки видео с YouTube.com и еще нескольких сайтов ; https://aur.archlinux.org/packages/youtube-dl ; https://aur.archlinux.org/youtube-dl.git (только для чтения, нажмите, чтобы скопировать) ; https://ytdl-org.github.io/youtube-dl/ ; https://ytdl-org.github.io/youtube-dl/supportedsites.html ; https://github.com/ytdl-org/youtube-dl/blob/master/README.md#readme ;
########### youtube-dl ############
#git clone https://aur.archlinux.org/youtube-dl.git  # (только для чтения, нажмите, чтобы скопировать)
#cd youtube-dl
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf youtube-dl
#rm -Rf youtube-dl
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############### Справка ############
# Как пользоваться Youtube-dl
# https://losst.pro/kak-polzovatsya-youtube-dl
# https://github.com/ytdl-org/youtube-dl
# https://itsfoss.com/download-youtube-linux/
# Для успешного использования утилиты необходимо правильно записывать команды в терминале. Синтаксис утилиты прост:
# $ youtube-dl опции URL-адрес
# Основные опции:
# -U, --update — установка обновлений;
# --dump-user-agent — просмотр идентификационных данных, отсылаемых утилитой на веб-сервер;
# --abort-on-error — отменить загрузку следующих видео из списка (плейлиста) в случае какой-либо ошибки;
# --list-extractors — просмотреть список сайтов, с которых можно скачивать файлы;
# --extractor-descriptions — список сайтов с примечаниями;
# --playlist-start n — начать загрузку плейлиста с файла под номером n;
# --max-downloads — остановить работу утилиты после загрузки n-ного количества файлов;
# -i, --ignore-errors — продолжить скачивание, если работа утилиты «застопорилась» из-за ошибки (например, очередное видео из плейлиста оказалось недоступным);
# --proxy URL — использование прокси-серверов (HTTP/HTTPS/SOCKS);
# --geo-verification-proxy URL — использование прокси для создания фейковой геолокации (требуется, если перечень стран, где видео доступно для просмотра, ограничен);
# --mark-watched — отметить видео просмотренными (также существует опция с противоположным действием --no-mark-watched; обе опции действительны только для youtube);
# --min-filesize SIZE, --max-filesize SIZE — не загружать видео, если его размер меньше или больше заданного;
# --date DATE — загружать только видео, которые были выложены на сервер в заданную дату (также существуют опции --datebefore DATE для загрузки видео, которые были выложены до указанной даты, и --dateafter DATE для загрузки видео, которые были выложены после указанной даты);
# --no-playlist — загружать только видео, если по указанному адресу расположены и видео, и плейлист (также есть опция --only-playlist, которая при аналогичных обстоятельствах позволяет загрузить только плейлист);
# --include-ads — скачивать видео вместе с рекламой;
# -r, --limit-rate — ограничение скорости скачивания;
#--buffer-size — установка размера фрагментов, записываемых в буфер;
# --playlist-reverse — начать загрузку видео с конца плейлиста;
# --playlist-random — загружать видео из плейлиста в случайном порядке;
# --id — использовать в качестве названия видео его id-номер;
# -w, --no-overwrites — не перезаписывать файлы;
# -c, --continue — --no-continue;
# --write-description — сохранить описание видео в файл .description;
# --no-warnings — игнорировать предупреждения;
# --no-check-certificate — не проверять, действителен ли сертификат безопасности для указанного сайта;
# -F, --list-formats — показать все доступные форматы файлов для указанного видео или плейлиста;
# --write-sub — сохранять файл с субтитрами.
# С полным перечнем опций можно ознакомиться, выполнив в терминале одну из следующих команд:
# man youtube-dl
# youtube-dl -h
# Загрузка видео определённого формата и качества
# По умолчанию утилита youtube-dl загружает видео и аудио в наилучшем качестве изо всех доступных вариантов. Однако при загрузке видео и музыки из YouTube у вас есть возможность выбрать, какое качество звука и изображения вы хотите получить:
# best – наилучшее качество видео и аудио;
# worst – наихудшее качество видео и аудио;
# bestvideo – наилучшее качество видео;
# worstvideo – наихудшее качество видео;
# bestaudio – наилучшее качество аудио;
# worstaudio – наихудшее качество аудио.
# Пропишите желаемый вариант в тексте команды после опции -f. Например, для наилучшего качества видео и аудио одновременно, запись будет выглядеть так:
# youtube-dl -f best URL-adress
##############################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить YoutubeDownloader (ytdownloader) - Приложение для загрузки видео и аудио с сотен сайтов?"
echo -e "${MAGENTA}:: ${BOLD}YoutubeDownloader - это простой GUI для youtube-dl работает на linux. Целью было получить высококачественный звук и видео с помощью ffmepg, где это необходимо. YT-DLP (yt-dlp) — это многофункциональный командный загрузчик аудио/видео с поддержкой тысяч сайтов. Проект представляет собой ответвление youtube-dl, основанное на ныне неактивном youtube-dlc . ${NC}"
echo " ytDownloader (ранее известный как Youtube Downloader Plus) позволяет загружать видео и аудио разного качества с сотен популярных сайтов, включая, но не ограничиваясь, Youtube, Facebook, Instagram, Tiktok, Twitter, Twitch и т. д. "
echo " Обзор: Поддержка загрузки с сотен сайтов, включая Youtube, Facebook, Instagram, Tiktok, Twitter и других, благодаря yt-dlp; При скачивании видео или аудио можно выбрать качество и определённую часть (указать начало и конец); Поддержка скачивания плейлистов и субтитров; Можно выбрать место загрузки; В настройка можно выбрать: предпочтительное качество видео, видеокодек и аудиоформат; Доступные режимы: светлый и тёмный; Нет никаких трекеров или рекламы. "
echo " Функции: Загружайте видео (со звуком) или только аудио с YouTube, Vimeo и других платформ простым перетаскиванием URL-адреса из браузера в список. Можно загрузить видео с разных сайтов (таких как Youtube, Vimeo, Rumble и (German Broadcasting) Mediatheks). Нажмите кнопку «Загрузить», чтобы загрузить список или отдельные URL-адреса. Кроме того, URL-адрес можно ввести вручную с помощью значка «плюс». URL-адреса в списке можно сохранять и восстанавливать. Во время загрузки кнопка «Загрузить» превращается в кнопку «Прервать», что позволяет остановить загрузку во время ее выполнения. Двойной щелчок по загруженной записи начнет ее воспроизведение с помощью аудио/видеоплеера по умолчанию. Через контекстное меню можно удалять записи, открывать папки или загружать файлы повторно (принудительно). Множественный выбор с помощью «CRTL+A» . Также можно запустить через терминал с помощью "ytgui" . Настройки: Нажав на значок «clogwheel», вы можете задать целевые каталоги для видео и аудио по отдельности, а также качество загрузки. "
echo " Существует 3 варианта качества видео: Контейнер MP4 в основном даст хороший результат, но обычно не лучший. Контейнер MKV может принимать буквально любой кодек. Поскольку youtube часто использует контейнер webm с кодеками vp9 и opus, это будет выбор для лучшего качества. Режим «auto» не будет передавать запросы на слияние в youtube-dl, поэтому в зависимости от доступных данных на выходе будет либо контейнер MKV, либо webm. Изменить бэкэнд. Если yt-dl предоставляется вашим дистрибутивом, он не может быть обновлен этим приложением. Однако предоставляется локальная версия yt-dl, которую можно активировать кнопкой «переключатель» рядом с «Updater». Кнопка переключателя не отображается, если дистрибутив не предоставил yt-dl — используется внутренне предоставленный blob python. "
echo -e "${CYAN}:: ${NC}Установка YoutubeDownloader (ytdownloader), YoutubeDownloader (ytdownloader-gui), и YoutubeDownloader (ytdownloader-gui-bin) проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/https://aur.archlinux.org/packages/ytdownloader), (https://aur.archlinux.org/packages/ytdownloader-gui), (https://aur.archlinux.org/packages/ytdownloader-gui-bin) - собирается и устанавливается. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить YoutubeDownloader (ytdownloader),      2 - Установить YoutubeDownloader (ytdownloader-gui),

    3 - Установить YoutubeDownloader (ytdownloader-gui-bin),   0 - НЕТ - Пропустить действие: " ytdownloader  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$ytdownloader" =~ [^1230] ]]
do
    :
done
if [[ $ytdownloader == 0 ]]; then
echo ""
echo " Установка пакетов пропущена "
elif [[ $ytdownloader == 1 ]]; then
echo ""
echo " Установка YoutubeDownloader (ytdownloader) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
############### Зависимости ###############
sudo pacman -S --noconfirm --needed python  # Язык программирования Python ; https://archlinux.org/packages/core/x86_64/python/ ; https://www.python.org/ ; Обеспечивает: python-externally-managed, python3 ; Заменяет: python-externally-managed, python3 ; 2025-06-23 18:22 UTC
sudo pacman -S --noconfirm --needed python-gobject  # Привязки Python для GLib/GObject/GIO/GTK ; https://archlinux.org/packages/extra/x86_64/python-gobject/ ; https://pygobject.gnome.org/ ; Обеспечивает: pygobject-devel=3.52.3 ; Заменяет: pygobject-devel<=3.36.1-1 ; Конфликты: с pygobject-devel ; 2025-03-24 03:58 UTC
sudo pacman -S --noconfirm --needed ffmpeg  # Комплексное решение для записи, конвертации и потоковой передачи аудио и видео ; https://archlinux.org/packages/extra/x86_64/ffmpeg/ ; https://ffmpeg.org/ ; Обеспечивает:  libavcodec.so=61-64, libavdevice.so=61-64, libavfilter.so=10-64, libavformat.so=61-64, libavutil.so=59-64, Подробнее… (https://archlinux.org/packages/extra/x86_64/ffmpeg/#); 2025-06-10 07:19 UTC
sudo pacman -S --noconfirm --needed yt-dlp  # Форк youtube-dl с дополнительными функциями и исправлениями ; https://archlinux.org/packages/extra/any/yt-dlp/ ; https://github.com/yt-dlp/yt-dlp ; 2025-06-10 06:56 UTC
############ ytdownloader ########
yay -S ytdownloader --noconfirm  # GKT3 frontend для yt-dlp (активная ветка youtube-dl) с фокусом на лучшее аудио и видео. Использует ffmpeg для объединения аудио и видео ; https://aur.archlinux.org/packages/ytdownloader ; https://aur.archlinux.org/ytdownloader.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/kanehekili/YoutubeDownloader ; https://github.com/kanehekili/YoutubeDownloader/releases/download/1.4.7/ytdownloader1.4.7.tar ; 2024-09-12 20:54 (UTC)
########### ytdownloader ############
#git clone https://aur.archlinux.org/youtube-dl.git  # (только для чтения, нажмите, чтобы скопировать)
#cd ytdownloader
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ytdownloader
#rm -Rf ytdownloader
echo ""
echo " Установка YoutubeDownloader (ytdownloader) выполнена "
elif [[ $ytdownloader == 2 ]]; then
echo ""
echo " Установка YoutubeDownloader (ytdownloader-gui) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
############### Зависимости ###############
sudo pacman -S --noconfirm --needed electron  # Мета-пакет, предоставляющий последнюю доступную стабильную сборку Electron ; https://archlinux.org/packages/extra/any/electron/ ; https://electronjs.org/ ; 2025-05-05 13:35 UTC
sudo pacman -S --noconfirm --needed ffmpeg  # Комплексное решение для записи, конвертации и потоковой передачи аудио и видео ; https://archlinux.org/packages/extra/x86_64/ffmpeg/ ; https://ffmpeg.org/ ; Обеспечивает:  libavcodec.so=61-64, libavdevice.so=61-64, libavfilter.so=10-64, libavformat.so=61-64, libavutil.so=59-64, Подробнее… (https://archlinux.org/packages/extra/x86_64/ffmpeg/#); 2025-06-10 07:19 UTC
sudo pacman -S --noconfirm --needed yt-dlp  # Форк youtube-dl с дополнительными функциями и исправлениями ; https://archlinux.org/packages/extra/any/yt-dlp/ ; https://github.com/yt-dlp/yt-dlp ; 2025-06-10 06:56 UTC
sudo pacman -S --noconfirm --needed git  # Быстрая распределенная система контроля версий ; https://archlinux.org/packages/extra/x86_64/git/ ; https://git-scm.com/ ; 2025-06-17 13:37 UTC
sudo pacman -S --noconfirm --needed jq  # Процессор командной строки JSON ; https://archlinux.org/packages/extra/x86_64/jq/ ; https://jqlang.github.io/jq/ ; 2025-07-01 20:06 UTC
sudo pacman -S --noconfirm --needed npm  # Менеджер пакетов JavaScript ; https://archlinux.org/packages/extra/any/npm/ ; https://www.npmjs.com/ ; 2025-06-13 00:34 UTC
sudo pacman -S --noconfirm --needed sed  # Редактор потока GNU ; https://archlinux.org/packages/core/x86_64/sed/ ; https://www.gnu.org/software/sed/ ; 2023-03-05 20:39 UTC
############ ytdownloader-gui ########
yay -S ytdownloader-gui --noconfirm  # Загрузчик видео с графическим интерфейсом, поддерживающий сотни сайтов ; https://aur.archlinux.org/packages/ytdownloader-gui ; https://aur.archlinux.org/ytdownloader-gui.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/aandrew-me/ytDownloader ; https://github.com/aandrew-me/ytDownloader/archive/refs/tags/v3.19.0.tar.gz ; https://aur.archlinux.org/cgit/aur.git/tree/ytdownloader-gui.sh?h=ytdownloader-gui ; Конфликты: ytdownloader-gui ; 2025-02-09 18:04 (UTC)
########### ytdownloader-gui ############
#git clone https://aur.archlinux.org/ytdownloader-gui.git  # (только для чтения, нажмите, чтобы скопировать)
#cd ytdownloader-gui
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ytdownloader-gui
#rm -Rf ytdownloader-gui
echo ""
echo " Установка YoutubeDownloader (ytdownloader-gui) выполнена "
elif [[ $ytdownloader == 3 ]]; then
echo ""
echo " Установка YoutubeDownloader (ytdownloader-gui-bin) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
############### Зависимости ###############
sudo pacman -S --noconfirm --needed python  # Язык программирования Python ; https://archlinux.org/packages/core/x86_64/python/ ; https://www.python.org/ ; Обеспечивает: python-externally-managed, python3 ; Заменяет: python-externally-managed, python3 ; 2025-06-23 18:22 UTC
sudo pacman -S --noconfirm --needed nodejs  # Событийный ввод-вывод для V8 javascript («Текущий» выпуск) ; https://archlinux.org/packages/extra/x86_64/nodejs/ ; https://nodejs.org/ ; Обратные конфликты:  nodejs-lts-iron , nodejs-lts-jod ; 2025-06-29 13:28 UTC
sudo pacman -S --noconfirm --needed ffmpeg  # Комплексное решение для записи, конвертации и потоковой передачи аудио и видео ; https://archlinux.org/packages/extra/x86_64/ffmpeg/ ; https://ffmpeg.org/ ; Обеспечивает:  libavcodec.so=61-64, libavdevice.so=61-64, libavfilter.so=10-64, libavformat.so=61-64, libavutil.so=59-64, Подробнее… (https://archlinux.org/packages/extra/x86_64/ffmpeg/#); 2025-06-10 07:19 UTC
sudo pacman -S --noconfirm --needed yt-dlp  # Форк youtube-dl с дополнительными функциями и исправлениями ; https://archlinux.org/packages/extra/any/yt-dlp/ ; https://github.com/yt-dlp/yt-dlp ; 2025-06-10 06:56 UTC
############ electron30 ########
yay -S electron30 --noconfirm  # Создавайте кроссплатформенные настольные приложения с использованием веб-технологий ; https://aur.archlinux.org/packages/electron30 ; https://aur.archlinux.org/electron30.git (только для чтения, нажмите, чтобы скопировать) ; https://electronjs.org/ ; 2025-05-05 15:10 (UTC)
############ electron30 ########
#git clone https://aur.archlinux.org/electron30.git  # (только для чтения, нажмите, чтобы скопировать)
#cd electron30
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf electron30
#rm -Rf electron30
######## ИЛИ electron30-bin ########
### Если вы хотите сэкономить место на диске и время, используйте этот electron30-binпакет или включите мой личный пользовательский репозиторий (см. Arch wiki) с этим пакетом, который будет периодически собираться заранее.
### electron30 — это зависимость для меня, но electron30-bin тоже работает. Поэтому я скачал его перед обновлением системы. Сделайте это, если хотите избежать загрузки полного репозитория chromium.
#yay -S electron30-bin --noconfirm  # Создавайте кроссплатформенные настольные приложения с использованием веб-технологий — готовые решения ; https://aur.archlinux.org/packages/electron30-bin ; https://aur.archlinux.org/electron30-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://electronjs.org/ ; Конфликты: с electron30 ; Обеспечивает: electron30 ; 2025-04-21 10:43 (UTC)
########### electron30-bin #############
#git clone https://aur.archlinux.org/electron30-bin.git  # (только для чтения, нажмите, чтобы скопировать)
#cd electron30-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf electron30-bin
#rm -Rf electron30-bin
############ ytdownloader-gui-bin ########
yay -S ytdownloader-gui-bin --noconfirm  # GKT3 frontend для yt-dlp (активная ветка youtube-dl) с фокусом на лучшее аудио и видео. Использует ffmpeg для объединения аудио и видео ; https://aur.archlinux.org/packages/ytdownloader ; https://aur.archlinux.org/ytdownloader.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/kanehekili/YoutubeDownloader ; https://github.com/kanehekili/YoutubeDownloader/releases/download/1.4.7/ytdownloader1.4.7.tar ; 2024-09-12 20:54 (UTC)
########### ytdownloader-gui-bin ############
#git clone https://aur.archlinux.org/ytdownloader-gui-bin.git  # (только для чтения, нажмите, чтобы скопировать)
#cd ytdownloader-gui-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ytdownloader-gui-bin
#rm -Rf ytdownloader-gui-bin
echo ""
echo " Установка YoutubeDownloader (ytdownloader-gui) выполнена "
fi
############# Справка ##########
# curl -L https://github.com/yt-dlp/yt-dlp/raw/master/public.key | gpg --import
# gpg --verify SHA2-256SUMS.sig SHA2-256SUMS
# gpg --verify SHA2-512SUMS.sig SHA2-512SUMS
# Как установить(Руководство):
# Загрузите текущую версию YtDownloader*.tar здесь (https://github.com/kanehekili/YoutubeDownloader/releases/download/1.4.5/YtDownloader1.4.5.tar)
# Распакуйте его и выполните команду sudo ./install.sh в распакованной папке.
# Установка просто копирует файл рабочего стола и несколько скриптов Python в /opt/ytdownloader
# ffmpeg будет установлен, если менеджер пакетов распознается (спасибо @fischer-felix), дополнительная библиотека python должна быть уже установлена
################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить FreeTube (freetube) — Частный клиент YouTube?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *FreeTube сейчас находится в стадии бета-тестирования. Хотя приложение должно работать без проблем для большинства пользователей, в нём всё ещё есть ошибки и недостающие функции, требующие исправления. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}FreeTube — полнофункциональный JavaScript (Node.js) / Electron (React.js) графический YouTube-клиент созданный с учётом требований конфиденциальности (YouTube privacy player). Смотрите YouTube без рекламы и не позволяйте Google отслеживать вас с помощью файлов cookie и JavaScript. Доступно для Windows (10 и более поздних версий), Mac (macOS 11 и более поздних версий) и Linux благодаря Electron. Большинство видеороликов на YouTube можно свободно просматривать, но запутанные и регулярно изменяемые правила использования сервиса, ссылки на нарушения авторских прав (неизвестно чьих), ролики удаляются и блокируются в некоторых странах, также Google по собственному усмотрению подвергает цензуре отдельные каналы, блокирует учётные записи и без согласия пользователей проводит сбор персональных данных. Этот проект Лицензируется под AGPL-3.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://freetubeapp.io/ ; (https://github.com/FreeTubeApp/FreeTube ; https://aur.archlinux.org/packages/freetube ; https://aur.archlinux.org/packages/freetube-bin). "
echo -e "${BLUE}:: ${NC}Функции: Смотрите видео без рекламы. Используйте YouTube без отслеживания Google с помощью файлов cookie и JavaScript. Два API-интерфейса экстрактора на выбор (встроенный или Invidious). Подписывайтесь на каналы без учетной записи. Подключитесь к внешнему прокси-серверу, такому как Tor. Просмотр и поиск по локальным подпискам, плейлистам и истории. Организуйте свои подписки в «Профили», чтобы создать более целевую ленту. Экспорт и импорт подписок. В тренде на YouTube. Главы на YouTube. Самая популярная страница видео на основе набора Invidious. SponsorBlock. ДеЭрроу. Открывайте видео из браузера прямо в FreeTube (с расширением). Смотрите видео с помощью внешнего плеера. Полная поддержка тем. Сделайте скриншот видео. Несколько окон. Мини-плеер (картинка в картинке). Сочетания клавиш. Возможность показывать только семейный контент. Показывать/скрывать функции или элементы в приложении с помощью настроек, исключающих отвлечение внимания. Посмотреть сообщения на канале. "
echo -e "${CYAN}:: ${NC}FreeTube сделан на основе Invidious API (свободный веб-фронтенд, YouTube-клиент) написанный на языке программирования Crystal и использующего базу данных PostgreSQL, не применяя официального YouTube API, вместо этого использует его исходный код на предмет получения необходимой информации (подобно реализованному в youtube-dl), обрабатывая большинство запросов через прокси-сервер, что положительно отражается на уровне анонимности пользователя. FreeTube позволяет наиболее безопасно пользоваться видеохостингом, без показа рекламы и не позволяя Google отслеживать действия с помощью JavaScript и Cookie файлов. Пользовательский интерфейс FreeTube имеет дизайн максимально похожий на веб-версию YouTube, доступно множество настроек, светлая и тёмная тема оформления, а также три разновидности плеера. FreeTube может работать через прокси и через TOR, просмотр возможен в отдельном окне мини-плеера, можно задать настройки воспроизведения "по умолчанию" (скорость, качество, субтитры и пр), копировать в буфер обмена ссылки на видео-ролики и многое другое... "
echo -e "${RED} *Важно! ${NC}Настоятельно рекомендуется использовать VPN или Tor, чтобы скрыть свой IP-адрес при использовании FreeTube. Подписываться на каналы FreeTube позволяет без использования учётной записи Google, поддерживает поиск по YouTube, фильтрация результатов и открытие прямых ссылок. Все пользовательские данные хранятся локально (подписки, избранное и история) и никуда не отправляются. Для удобства FreeTube поддерживает создание профилей с разными наборами подписок и настроек, возможен импорт своих подписок из учётной записи YouTube и экспорт своих подписок в файл базы данных (freetube-subscriptions-2020-05-15.db). Расширения для браузера: Следующие расширения открывают ссылки YouTube непосредственно в FreeTube: LibRedirect (https://libredirect.github.io/), LibRedirect автоматически перенаправляет ссылки YouTube на FreeTube, RedirectTube (https://github.com/MStankiewiczOfficial/RedirectTube). "
echo -e "${CYAN}:: ${NC}Установка FreeTube (freetube) и (freetube-bin), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/freetube.git), (https://aur.archlinux.org/freetube-bin.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить FreeTube (freetube),    2 - Установить FreeTube (freetube-bin),

    0 - НЕТ - Пропустить установку: " in_freetube  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_freetube" =~ [^120] ]]
do
    :
done
if [[ $in_freetube == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_freetube == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) FreeTube (freetube) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed electron37  # Создавайте кроссплатформенные десктопные приложения с использованием веб-технологий ; https://archlinux.org/packages/extra/x86_64/electron37/ ; https://electronjs.org/ ; 2025-08-09 23:04 UTC
sudo pacman -S --noconfirm --needed nodejs  # Событийный ввод-вывод для JavaScript V8 («Текущий» выпуск) ; https://archlinux.org/packages/extra/x86_64/nodejs/ ; https://nodejs.org/ ; Обратные конфликты:  nodejs-lts-iron , nodejs-lts-jod ; 28 августа 2025 г. 03:22 UTC
sudo pacman -S --noconfirm --needed npm  # Менеджер пакетов JavaScript ; https://archlinux.org/packages/extra/any/npm/ ; https://www.npmjs.com/ ; 2025-07-31 01:28 UTC
sudo pacman -S --noconfirm --needed yarn  # (необязательно) ; Быстрое, надежное и безопасное управление зависимостями  ; https://archlinux.org/packages/extra/any/yarn/ ; https://classic.yarnpkg.com/ ; 2024-07-11 00:04 UTC
########### freetube ############
yay -S freetube --noconfirm  # Открытый исходный код проигрывателя YouTube для ПК, созданный с учетом конфиденциальности ; https://aur.archlinux.org/packages/freetube ; https://aur.archlinux.org/freetube.git (только для чтения, нажмите, чтобы скопировать) ; https://freetubeapp.io/ ; https://github.com/FreeTubeApp/FreeTube/archive/v0.23.8-beta.tar.gz ; https://aur.archlinux.org/cgit/aur.git/tree/freetube.desktop?h=freetube ; https://aur.archlinux.org/cgit/aur.git/tree/freetube.sh?h=freetube ; 2025-08-23 15:05 (UTC)
########### freetube ############
#git clone https://aur.archlinux.org/freetube.git  # (только для чтения, нажмите, чтобы скопировать)
#cd freetube
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf freetube
#rm -Rf freetube
  echo ""
  echo " Посмотрите информацию о версии (freetube) "
sudo pacman -Q freetube  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_freetube == 2 ]]; then
  echo ""
  echo " Установка утилиты (пакета) FreeTube (freetube-bin) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed ttf-liberation  # Семейство шрифтов, нацеленное на метрическую совместимость с Arial, Times New Roman и Courier New ; https://archlinux.org/packages/extra/any/ttf-liberation/ ; https://github.com/liberationfonts/liberation-fonts ; Обеспечивает: ttf-font ; 2024-07-12 23:57 UTC
########### freetube-bin ############
yay -S freetube-bin --noconfirm  # Открытый настольный проигрыватель YouTube, созданный с учетом конфиденциальности ; https://aur.archlinux.org/packages/freetube-bin ; https://aur.archlinux.org/freetube-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/FreeTubeApp/FreeTube ; https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.8-beta/freetube_0.23.8_beta_amd64.deb ; Конфликты: freetube ; Обеспечивает: freetube ; 2025-08-23 15:36 (UTC)
########### freetube-bin ############
#git clone https://aur.archlinux.org/freetube-bin.git  # (только для чтения, нажмите, чтобы скопировать)
#cd freetube-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf freetube-bin
#rm -Rf freetube-bin
  echo ""
  echo " Посмотрите информацию о версии (freetube) "
sudo pacman -Q freetube  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##########

clear
echo ""
echo -e "${BLUE}:: ${NC}Gydl (Graphical Youtube-dl, YT-DLP) (gydl-git) - Графическая оболочка для программ yt-dlp и youtube-dl?"
echo -e "${MAGENTA}:: ${BOLD}Gydl (Graphical Youtube-dl, YT-DLP) — это графический интерфейс, работающий как оболочка для уже известного инструмента Youtube-dl и yt-dlp, позволяющий загружать видео и аудио более простым способом, а также обладающий большинством базовых технологических функций. Этот инструмент был разработан  Янником Хауптвогелем с использованием  Python 3 и GTK + 3, его работа очень проста: нам просто нужно ввести URL-адрес видео на YouTube, а затем выбрать, хотим ли мы загрузить видео или аудио, затем мы можем выбрать выходной формат и качество. Наконец, мы нажимаем кнопку загрузки и ждем, пока инструмент загрузит видео. Если вы решили использовать данный вариант пакета, вам не нужно устанавливать youtube-dl, yt-dlp или ffmpeg в вашу систему (их установка уже будет прописана в скрипте установки). В настоящее время gydl имеет установочные пакеты только для Arch Linux и производных, они находятся в репозитории AUR. ${NC}"
echo " Домашняя страница: https://aur.archlinux.org/packages/gydl-git ; (https://github.com/JannikHv/gydl), (https://github.com/ytdl-org/youtube-dl), (https://github.com/yt-dlp/yt-dlp#readme) "
echo -e "${MAGENTA}:: ${BOLD} Интерфейс всегда использует технологию Youtube-dl, его задача — предоставить простой и удобный доступ к каждой из функций, предлагаемых Youtube-dl. Его дизайн прост и использует опыт, основанный на диалоге, обрабатывает сообщения надлежащим образом и идеально подходит для всех тех, кто хочет быть вдали от терминала, но хочет загружать видео YouTube на Linux. Он разработан с учетом диалогового опыта. Это обеспечивает быструю и легкую загрузку видео или аудио без помех. Большое спасибо разработчикам yt-dlp! От автора проекта: Уважаемые пользователи, В настоящее время Gydl находится в таком состоянии, что его не имеет смысла улучшать/развивать каким-либо образом. В настоящее время у меня нет ресурсов для самостоятельной разработки Gydl — отсюда и количество открытых вопросов. Я планирую сохранить Gydl в его нынешнем виде и полностью переписать его не позднее, чем через полгода. Стабильные релизы размещены также на Flathub. Пакеты Flatpak поддерживают несколько дистрибутивов и изолированы. ${NC}"
echo " Использование: При использовании Gydl у вас есть возможность загрузить видео с YouTube в формате видео или аудио. Каждый из этих вариантов имеет текстовое поле, а также два выпадающих списка для управления качеством и форматом. При нажатии кнопки «Загрузить» вы можете столкнуться с тремя сценариями: Загрузка завершена — когда загрузка успешно завершена. Неудачная загрузка — если был введен неверный URL-адрес или возникли подобные ошибки. Ошибка подключения — не удалось установить подключение к Интернету. Эти диалоги будут представлены вам в виде маленьких окон. Обратите внимание, что не все комбинации настроек будут работать. "
echo " Выводы: Инструмент получает реинжиниринг кода и миграцию на язык C, поэтому в ближайшие дни он, вероятно, получит полное обновление как в своей структуре, так и в своем графическом интерфейсе. Теперь, если вы в настоящее время используете Arch Linux или производные и хотите насладиться графическим интерфейсом для youtube-dl, сейчас самое время это сделать, поскольку, согласно моим тестам, инструмент был очень стабильным, эффективным и простым в использовании. Несмотря на то, что на GitHub и других платформах можно найти большое количество графических интерфейсов youtube-dl, большинство из них плохо работают или уже не активно развиваются. "
echo -e "${CYAN}:: ${NC}Установка Gydl (gydl-git) проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/gydl-git), (https://aur.archlinux.org/gydl-git.git) - собирается и устанавливается. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_gydl  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_gydl" =~ [^10] ]]
do
    :
done
if [[ $in_gydl == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_gydl == 1 ]]; then
  echo ""
  echo " Установка Gydl (gydl-git) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
############### Зависимости ###############
sudo pacman -S --noconfirm --needed gtk3  # Мультиплатформенный набор инструментов графического интерфейса на основе GObject ; https://archlinux.org/packages/extra/x86_64/gtk3/ ; https://www.gtk.org/ ; Заменяет: gtk3-print-backends<=3.22.26-1 ; Конфликты: с gtk3-print-backends ; 2025-05-14 00:11 UTC
sudo pacman -S --noconfirm --needed python  # Язык программирования Python ; https://archlinux.org/packages/core/x86_64/python/ ; https://www.python.org/ ; Обеспечивает: python-externally-managed, python3 ; Заменяет: python-externally-managed, python3 ; 2025-06-23 18:22 UTC
sudo pacman -S --noconfirm --needed python-gobject  # Привязки Python для GLib/GObject/GIO/GTK ; https://archlinux.org/packages/extra/x86_64/python-gobject/ ; https://pygobject.gnome.org/ ; Заменяет: pygobject-devel<=3.36.1-1 ; Конфликты: с pygobject-devel ; 2025-03-24 03:58 UTC
sudo pacman -S --noconfirm --needed python-setuptools  # Простая загрузка, сборка, установка, обновление и удаление пакетов Python ; https://archlinux.org/packages/extra/any/python-setuptools/ ; https://pypi.org/project/setuptools/ ; Обеспечивает: python-distribute ; Заменяет: python-distribute ; 2025-06-01 02:32 UTC
sudo pacman -S --noconfirm --needed atomicparsley  # Программа командной строки для чтения, анализа и настройки метаданных в файлах MPEG-4 ; https://archlinux.org/packages/extra/x86_64/atomicparsley/ ; https://github.com/wez/atomicparsley ; 2024-07-22 02:07 UTC
sudo pacman -S --noconfirm --needed python-pycryptodome  # Коллекция криптографических алгоритмов и протоколов, реализованных для использования из Python 3 ; https://archlinux.org/packages/extra/x86_64/python-pycryptodome/ ; https://www.pycryptodome.org/ ; Обеспечивает: python-crypto ; Заменяет: python-crypto ; Конфликты: с python-crypto ; 2025-05-22 19:06 UTC
sudo pacman -S --noconfirm --needed rtmpdump  # Набор инструментов для RTMP-потоков ; https://archlinux.org/packages/extra/x86_64/rtmpdump/ ; https://rtmpdump.mplayerhq.hu/ ; Обеспечивает: librtmp.so=1-64 ; 2024-03-05 21:51 UTC
sudo pacman -S --noconfirm --needed git  # Быстрая распределенная система контроля версий ; https://archlinux.org/packages/extra/x86_64/git/ ; https://git-scm.com/ ; 2025-06-17 13:37 UTC
sudo pacman -S --noconfirm --needed meson  # Высокопроизводительная система сборки ; https://archlinux.org/packages/extra/any/meson/ ; https://mesonbuild.com/ ; 2025-06-18 15:10 UTC
sudo pacman -S --noconfirm --needed ffmpeg  # Комплексное решение для записи, конвертации и потоковой передачи аудио и видео ; https://archlinux.org/packages/extra/x86_64/ffmpeg/ ; https://ffmpeg.org/ ; Обеспечивает:  libavcodec.so=61-64, libavdevice.so=61-64, libavfilter.so=10-64, libavformat.so=61-64, libavutil.so=59-64, Подробнее… (https://archlinux.org/packages/extra/x86_64/ffmpeg/#); 2025-06-10 07:19 UTC
########### yt-dlp ############
sudo pacman -S --noconfirm --needed yt-dlp  # Форк youtube-dl с дополнительными функциями и исправлениями ; https://archlinux.org/packages/extra/any/yt-dlp/ ; https://github.com/yt-dlp/yt-dlp ; 2025-06-10 06:56 UTC
########### zenity ##########
sudo pacman -S --noconfirm --needed zenity  # Отображение графических диалоговых окон из сценариев оболочки ; https://archlinux.org/packages/extra/x86_64/zenity/ ; https://gitlab.gnome.org/GNOME/zenity ; 2025-03-22 14:55 UTC
########### youtube-dl ############
yay -S youtube-dl --noconfirm  # Программа командной строки для загрузки видео с YouTube.com и еще нескольких сайтов ; https://aur.archlinux.org/packages/youtube-dl ; https://aur.archlinux.org/youtube-dl.git (только для чтения, нажмите, чтобы скопировать) ; https://ytdl-org.github.io/youtube-dl/ ; https://ytdl-org.github.io/youtube-dl/supportedsites.html ; https://github.com/ytdl-org/youtube-dl/blob/master/README.md#readme ;
########### youtube-dl ############
#git clone https://aur.archlinux.org/youtube-dl.git  # (только для чтения, нажмите, чтобы скопировать)
#cd youtube-dl
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf youtube-dl
#rm -Rf youtube-dl
########### gydl-git ############
yay -S gydl-git --noconfirm  # Gydl (Graphical Youtube-dl) — это графическая оболочка вокруг уже существующей программы youtube-dl ; https://aur.archlinux.org/packages/gydl-git ; https://aur.archlinux.org/gydl-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/JannikHv/gydl ; Конфликты: с gydl ; 2021-06-04 18:14 (UTC)
########### gydl-git ############
#git clone https://aur.archlinux.org/gydl-git.git  # (только для чтения, нажмите, чтобы скопировать)
#cd gydl-git
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gydl-git
#rm -Rf gydl-git
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Musictube (musictube) — Потоковый музыкальный проигрыватель (плеер) YouTube?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Слушайте миллионы песен с YouTube так же удобно, как на обычном плеере. Musictube воспроизводит треки альбомов в их оригинальном порядке и добавляет обложки, фотографии исполнителей и тексты песен. MusicTube — неофициальное приложение YouTube Music для ПК с некоторыми дополнениями, которые я считаю необходимыми, в частности, клавишами управления мультимедиа и системными уведомлениями. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Musictube — удобный Qt медиаплеер для прослушивания музыки и просмотра видеороликов с YouTube. Musictube имеет аналогичный многим медиаплеерам пользовательский интерфейс, позволяя пользователю в удобной форме искать и прослушивать музыку. Musictube не только проигрывает музыку с YouTube, но и автоматически предоставляет данные об исполнителе. Можно увидеть обложку альбома, данные о альбоме и композиции. Вся информация берётся с Last.fm, при наличии регистрации на сервисе можно включить скробблинг (scrobbling). Musictube создан только для прослушивания целых альбомов и дискографий, сохранение композиций в приложении не предусмотрено. В демонстрационной версии доступно только до десяти композиций в списке воспроизведения, а так же невозможно сохранение и коррекция плейлистов. ***Работает демоверсия в течении двадцати дней. Этот проект Лицензируется под custom: 'Авторское право (c) Флавио Тордини <flavio.tordini@gmail.com>. Все права защищены'. Лицензия: Proprietary/Коммерческая (US$ 6.99). ${NC}"
echo " Домашняя страница: https://flavio.tordini.org/musictube ; (https://aur.archlinux.org/packages/musictube). "
echo -e "${BLUE}:: ${NC}Функции: Musictube может воспроизводить полные альбомы или даже дискографии миллионов исполнителей, представленных на YouTube. Не ограничивайтесь оригинальной студийной версией. Послушайте живое выступление или неожиданную кавер-версию. Musictube располагает полностью редактируемым плейлистом, который можно заполнить за считанные секунды и воспроизводить часами. Вы всегда можете открыть видео в виде миниатюры или в полноэкранном режиме. Удобно для официальных музыкальных клипов, живых выступлений и каверов. "
echo -e "${CYAN}:: ${NC}Musictube описывается как «Слушайте миллионы песен на YouTube удобным способом, почти как на обычном плеере. Musictube воспроизводит треки альбомов в их оригинальном порядке и добавляет обложки альбомов, фотографии исполнителей и тексты песен». Musictube — это сервис потоковой передачи музыки в категории аудио и музыки. Существует более 100 альтернатив Musictube для различных платформ, включая веб-приложения, приложения для Android, iPhone, iPad и Windows. Лучшая альтернатива Musictube —Spotify, который бесплатный. Другие отличные приложения, такие как Musictube, SoundCloud, Deezer, PandoraиYouTube Music. "
echo -e "${CYAN}:: ${NC}Установка Musictube (musictube) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/musictube.git), (https://aur.archlinux.org/packages/musictube) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_musictube  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_musictube" =~ [^10] ]]
do
    :
done
if [[ $in_musictube == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_musictube == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Musictube (musictube) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed mpv  # Бесплатный, открытый и кроссплатформенный медиаплеер ; https://archlinux.org/packages/extra/x86_64/mpv/ ; https://mpv.io/ ; Обеспечивает: libmpv.so=2-64 ; 2025-07-29 22:37 UTC
sudo pacman -S --noconfirm --needed qt5-declarative  # Классы для языков QML и JavaScript ; https://archlinux.org/packages/extra/x86_64/qt5-declarative/ ; https://www.qt.io/ ; Группы: qt5 ; Конфликты: с qtchooser ; 2025-05-23 19:02 UTC
sudo pacman -S --noconfirm --needed qt5-x11extras  # Предоставляет платформенно-специфичные API для X11 ; https://archlinux.org/packages/extra/x86_64/qt5-x11extras/ ; https://www.qt.io/ ; Группы: qt5 ; 2025-05-23 19:02 UTC
######### musictube ########
yay -S musictube --noconfirm  # Потоковый музыкальный проигрыватель YouTube ; https://aur.archlinux.org/packages/musictube ; https://aur.archlinux.org/musictube.git (только для чтения, нажмите, чтобы скопировать) ; https://flavio.tordini.org/musictube ; https://flavio.tordini.org/files/musictube/musictube.deb ; 2024-07-26 11:22 (UTC)
######### musictube ########
#git clone https://aur.archlinux.org/musictube.git  # (только для чтения, нажмите, чтобы скопировать)
#cd musictube
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf musictube
#rm -Rf musictube
### Исходный deb-файл был изменён, но сохранил тот же номер. Внутренняя структура изменилась (.xz на .zst).
# Новый sha256 — «c0993bc31a5e528e39b57f2ac604de7c35c73bd292b191502c74d2bb30abe453», команда извлечения — «unzstd data.tar.zst && bsdtar -xf data.tar -C "$pkgdir".
##########################
  echo ""
  echo " Посмотрите информацию о версии (musictube) "
sudo pacman -Q musictube  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#######

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Kodi (kodi) - Медиа-центр, домашний кинотеатр?"
echo -e "${MAGENTA}:: ${BOLD}Kodi — бесплатный медиа-центр. Поддерживает проигрывание видео, аудио, потокового видео, стриминговые сервисы, запуск игр и многое другое. Разработкой занимается организация XBMC Foundation. Исходное название Xbox Media Player (XBMP). В качестве официального названия принято XBMС. Программа переименована в Kodi. Первые версии программы появились в 2002 году. Изначально программа разрабатывалась, как самостоятельное приложение под игровую приставку Xbox первого поколения и называлась Xbox Media Player. ${NC}"
echo " Домашняя страница: https://kodi.tv/ ; (https://archlinux.org/packages/extra/x86_64/kodi/ ). "
echo -e "${MAGENTA}:: ${BOLD}У вас есть смарт-телевизор? Вы еще ничего не видели! Kodi заткнет ваш смарт-телевизор. Kodi воспроизводит практически все виды медиа, которые вы можете найти, и выглядит при этом великолепно! Вот лишь несколько вещей, в которых Kodi преуспевает: Ваша музыкальная коллекция никогда не выглядела так хорошо! Поддержка практически всех форматов, плейлистов, миксов для вечеринок и многого другого. Намного лучше, чем стопка DVD на полке. Kodi оживит вашу коллекцию фильмов с помощью иллюстраций, актеров, жанров и многого другого. Идеально подходит для просмотра запоем или для случайного просмотра любимого шоу. Kodi организует все ваше телевидение как ничто другое. Kodi — лучший способ поделиться своими фотографиями на самом большом экране в доме с помощью персонального слайд-шоу. Kodi позволяет вам смотреть и записывать живое ТВ с помощью простого в использовании интерфейса. Он работает с рядом популярных бэкэндов, включая MediaPortal, MythTV, NextPVR, Tvheadend и многие другие. Kodi не только для пассивных развлекательных медиа. Вы также можете играть в игры на Kodi. Выбирайте из большого количества эмуляторов или даже играйте в отдельную игру. Есть даже обширная поддержка игровых контроллеров. ${NC}"
echo " Возможности: Может использоваться в качестве медиа-центра, домашнего кинотеатра, смарт-тв. Поддержка большого числа графических, звуковых, видео форматов. Поддерживает доступ и проигрывание медиа со стриминговых сервисов, включая YouTube, Spotify и многие другие. Live TV. Поддержка Web интерфейса. Запуск сторонних программ. Поддержка управления с помощью пультов дистанционного управления (телевизионные пульты, пульты от приставок и другие). Поддержка скинов (тем оформления). Открытый API. Поддержка плагинов, скриптов. Kodi работает под Linux, Windows, MacOS и под другие операционные системы. Также есть версии для iOS и Android. Есть сборки для одноплатного компьютера Raspberry Pi. Разработка под контролем организации XBMC Foundation. Исходный код: Open Source (открыт); Языки программирования: C++; Лицензия: GNU GPL v2; Приложение переведено на русский язык. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_kodi  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_kodi" =~ [^10] ]]
do
    :
done
if [[ $in_kodi == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_kodi == 1 ]]; then
  echo ""
  echo " Установка Kodi (kodi) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed kodi  # Программный медиаплеер и развлекательный центр для цифровых медиа (gl renderer) ; https://kodi.tv/ ; https://archlinux.org/packages/extra/x86_64/kodi/ ; Конфликты: с kodi-gles ; 31 июля 2024 г., 12:55 UTC ; https://archlinux.org/packages/?sort=&q=Kodi&maintainer=&flagged=
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить DJV Imaging (djv) - Просмотр киноформатов?"
echo -e "${MAGENTA}:: ${BOLD}DJV Imaging — узкоспециализированная профессиональная программа для просмотра «тяжелых» форматов, применяемых в киноиндустрии. Поддерживает точное управление кадрами и коррекцию цвета. ${NC}"
echo " Домашняя страница: https://darbyjohnston.github.io/DJV/ ; (https://aur.archlinux.org/packages/djv). "
echo -e "${MAGENTA}:: ${BOLD}DJV Imaging является узко специализированным, продвинутым просмотрщиком профессионального уровня. Он ориентирован на специалистов в области VFX. Основная функция программы состоит в просмотре секвенций кадров. Вьювер нацелен на работу с файлами 32-битной глубины, тяжелых форматов EXR, TIFF, TGA. Позволяет на лету измерять цвет пикселя, с его координатами. Поддерживает цветовые профили Linear и ACES. Позволяет менять экспозицию, оттенок, работать с гаммой и уровнями, для проверки материала. По своей сути, DJV Imaging является бесплатным, функциональным аналогом коммерческого стандарта в индустрии RV-Shotgun Software. ${NC}"
echo -e "${CYAN}:: ${NC}Возможности: Воспроизведение в реальном времени последовательностей изображений и фильмов. Поддержка стандартных отраслевых форматов файлов, включая Cineon, DPX, OpenEXR и QuickTime. Утилиты командной строки для пакетной обработки. Исходный код: Open Source (предоставляется по открытой лицензии BSD); Языки программирования: C; C++; Доступно для Linux, Apple macOS и Microsoft Windows. "
echo -e "${CYAN}:: ${NC}Установка DJV Imaging (djv) и (djv-git), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/djv.git), (https://aur.archlinux.org/djv-git.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить DJV Imaging (djv),   2 - Установить DJV Imaging (djv-git) 😃,

    0 - НЕТ - Пропустить установку: " in_djv  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_djv" =~ [^120] ]]
do
    :
done
if [[ $in_djv == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_djv == 1 ]]; then
  echo ""
  echo " Установка DJV Imaging (djv) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
######## Зависимости ##############
yay -S opencolorio1 --noconfirm  # Фреймворк управления цветом для визуальных эффектов и анимации ; https://aur.archlinux.org/opencolorio1.git (только для чтения, нажмите, чтобы скопировать) ; https://opencolorio.org/ ; https://aur.archlinux.org/packages/opencolorio1 ; 2021-11-15 12:53 (UTC) ; https://github.com/bartoszek/aur-post ; https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/v1.1.1.tar.gz
######## djv #######
yay -S djv --noconfirm  # Профессиональное программное обеспечение для обзора медиа для визуальных эффектов, анимации и кинопроизводства ; https://aur.archlinux.org/djv.git (только для чтения, нажмите, чтобы скопировать) ; http://djv.sourceforge.net/ ; https://aur.archlinux.org/packages/djv ; 2023-07-30 17:02 (UTC)
# После понижения до rtaudio 5.2.0 с помощью пакета rtaudio5-exp aur он успешно собирается на моей системе.
#git clone https://aur.archlinux.org/djv.git   # (только для чтения, нажмите, чтобы скопировать)
#cd djv
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf djv
#rm -Rf djv
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_djv == 2 ]]; then
  echo ""
  echo " Установка DJV Imaging (djv-git) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
######## djv-git #######
yay -S djv-git --noconfirm  # Профессиональное программное обеспечение для обзора медиа для визуальных эффектов, анимации и кинопроизводства ; https://aur.archlinux.org/djv-git.git (только для чтения, нажмите, чтобы скопировать) ;  https://github.com/darbyjohnston/DJV ; https://aur.archlinux.org/packages/djv-git ; 2024-08-11 17:39 (UTC) ; Конфликты: с djv
#git clone https://aur.archlinux.org/djv-git.git   # (только для чтения, нажмите, чтобы скопировать)
#cd djv-git
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf djv-git
#rm -Rf djv-git
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
###########

clear
echo -e "${MAGENTA}
  <<< Установка утилит для редактирования и запись аудио в Archlinux >>> ${NC}"
# Installing utilities for editing and recording audio in Archlinux
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Audacity (audacity) - Редактирования и запись аудио?"
echo -e "${MAGENTA}:: ${BOLD}Audacity — одно из самых известных бесплатных программ для записи и редактирования аудио с открытым исходным кодом. Хотя это не только диктофон, его возможности охватывают многие потребности в записи аудио. Audacity - это безупречный звуковой рекордер для Linux, который универсален и предлагает свои услуги бесплатно. Благодаря своей безупречной функциональности Audacity можно использовать для редактирования и производства аудио. Он имеет высокоинтуитивный интерфейс, который предпочитают как любители, так и профессионалы в этой области. Вы можете легко подключить звук от встроенного или подключенного микрофона. Audacity — это простой в использовании многодорожечный аудиоредактор и рекордер для Windows, macOS, GNU/Linux и других операционных систем. Многие сторонние плагины также были разработаны для Audacity благодаря его открытому исходному коду. ${NC}"
echo " Домашняя страница: https://www.audacityteam.org/ ; (https://archlinux.org/packages/extra/x86_64/audacity/). "
echo -e "${MAGENTA}:: ${BOLD}Некоторые возможности, которые предоставляет эта кросс-платформа: Вы можете выполнять тонкие манипуляции со звуком с помощью продвинутых навыков редактирования. Поддерживаемое качество звука - 16-битное, 24-битное и 32-битное. Audacity предлагает поддержку плагинов VST, LADSPA и Nyquist. Вы можете найти ему применение при оцифровке пластинок, кассет и записи подкастов. ${NC}"
echo " Audacity имеет ряд ключевых особенностей: поддерживает многодорожечную запись; обрабатывает различные аудиоформаты; кроссплатформенная совместимость и возможности редактирования; различные эффекты и плагины для дальнейшего улучшения. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_audacity  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_audacity" =~ [^10] ]]
do
    :
done
if [[ $in_audacity == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_audacity == 1 ]]; then
  echo ""
  echo " Установка Audacity (audacity) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########### audacity ############
sudo pacman -S --noconfirm --needed audacity  # Программа, позволяющая манипулировать сигналами цифрового звука https://archlinux.org/packages/extra/x86_64/audacity/ ; https://www.audacityteam.org/ ; Обеспечивает: ladspa-host, lv2-host, vamp-host, vst-host, vst3-host ; 2025-08-06 16:58 UTC
########### tenacity ############
# sudo pacman -S --noconfirm --needed tenacity  # Простой в использовании многодорожечный аудиоредактор и рекордер, созданный на основе Audacity ; Группы: pro-audio (https://archlinux.org/groups/x86_64/pro-audio/) ; https://archlinux.org/packages/extra/x86_64/tenacity/ ; https://tenacityaudio.org/ ; 2025-02-21 19:56 UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить LMMS (Linux MultiMedia Studio) - (для создания музыки на компьютере)?"
echo -e "${MAGENTA}:: ${BOLD}LMMS (ранее Linux MultiMedia Studio) - это бесплатная кроссплатформенная альтернатива коммерческим программам, таким как FL Studio®, которые позволяют вам создавать музыку на вашем компьютере. Это включает в себя создание мелодий и битов, синтез и микширование звуков, а также аранжировку сэмплов. Вы можете развлекаться с вашей MIDI-клавиатурой и многим другим; все это в удобном и современном. ${NC}"
echo " Домашняя страница: https://lmms.io/ ; (https://github.com/LMMS/lmms ; https://archlinux.org/packages/extra/x86_64/lmms/) "
echo -e "${MAGENTA}:: ${BOLD}Функции: Song-Editor для сочинения песен; Pattern-Editor для создания ритмов и паттернов; Простой в использовании Piano-Roll для редактирования паттернов и мелодий; Микшер с неограниченным количеством каналов микшера и произвольным количеством эффектов; Множество мощных инструментов и плагинов эффектов прямо из коробки; Полная автоматизация на основе определяемых пользователем путей и управляемые компьютером источники автоматизации; Совместимость со многими стандартами, такими как SoundFont2, VST(i), LADSPA, GUS Patches, а также полная поддержка MIDI; Импорт и экспорт MIDI-файлов а также может читать и записывать индивидуальные пресеты и темы. ${NC}"
echo " Особенности программы: LMMS принимает исправления для soundfonts и GUS, а также поддерживает простой плагин Linux Audio Developer's Simple Plugin API (LADSPA) и LV2 (единственная ветка master, с 24.05.2020). Он может использовать плагины VST в Win32, Win64 или Wine32. Версии nightly поддерживают LinuxVST.  "
echo " Аудио можно экспортировать в форматы Ogg, FLAC, MP3 и WAV. Проекты могут быть сохранены в сжатом MMPZ формате файла или в несжатом MMP формате файла. LMMS на 100% свободный проект с открытым исходным кодом (Open Source), движимый усилиями сообщества. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_lmms  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_lmms" =~ [^10] ]]
do
    :
done
if [[ $in_lmms == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_lmms == 1 ]]; then
  echo ""
  echo " Установка LMMS (Linux MultiMedia Studio) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed lmms  # Linux MultiMedia Studio — программа для создания музыки на компьютере ; https://lmms.io/ ; https://github.com/LMMS/lmms ; https://archlinux.org/packages/extra/x86_64/lmms/ ; Группы: pro-audio (https://archlinux.org/groups/x86_64/pro-audio/) ; 2025-07-27 22:39 UTC
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить MP3Gain (mp3gain) - Утилита для выравнивания громкости аудиофайлов?"
echo -e "${BLUE}:: ${NC}Установить Графический интерфейс пользователя (GUI) для MP3Gain (easymp3gain-gtk2) - (позволяет изменять уровень громкости файлов mp3, ogg, mp4)?"
echo -e "${MAGENTA}:: ${BOLD}MP3Gain - это программа, которая поможет вам выровнять уровень громкости MP3 или M3U файлов. Ей очень легко пользоваться, независимо от опыта. Первая версия появилась 29 марта 2002 года. Графический интерфейс пользователя (GUI) для MP3Gain, VorbisGain и AACGain (позволяет изменять уровень громкости файлов mp3, ogg, mp4). Лицензия GPL-2.0 ${NC}"
echo " Домашняя страница: https://sourceforge.net/projects/mp3gain/ ; (https://aur.archlinux.org/packages/mp3gain). "
echo -e "${MAGENTA}:: ${BOLD}Программа состоит из двух частей: базовой части (бэк-энда), которая непосредственно осуществляет действия с MP3-файлами, является общей для всех вариантов использования и работает в режиме командной строки, а также из опциональной GUI-надстройки к ней, написанной на Visual Basic и привычной большинству пользователей под Windows. Программой легко пользоваться, плюс она переведена на множество языков, включая русский. Справка по работе с программой # закомментирована в сценарии (скрипта) установки - Ознакомтесь! ${NC}"
echo -e "${CYAN}:: ${NC}Достоинства: Возможность пакетного анализа и обработки файлов. Нормализация происходит по алгоритму Lossless Gain Adjustment без перекодировки файла, а значит без потери качества. Можно нормализовывать один и тот же файл множество раз без риска его испортить. Возможность применения нормализации только к выделенному в окне треку. Программа записывает изменения громкости в файл в виде APEv2-тегов, благодаря чему сохраняется возможность отмены последних сделанных изменений. Также есть возможность изменять файл напрямую, но в этом случае отменить действия автоматически будет уже невозможно. Сохранение даты создания файла. Сохранение ID3-тегов, в том числе и обложек альбомов. Возможность сохранить результаты предыдущего анализа, а затем применить их для последующей нормализации. Ведение лог-файлов. Многоязычный интерфейс, поддержка 28 языков (Russian - https://mp3gain.sourceforge.net/help/mp3gain-russian.zip). Полностью локализованное справочное руководство, которое можно скачать на официальном сайте (https://mp3gain.sourceforge.net/).  "
echo -e "${CYAN}:: ${NC}Установка MP3Gain (mp3gain) и (easymp3gain-gtk2), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/mp3gain.git), (https://aur.archlinux.org/easymp3gain-gtk2.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_mp3gain  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)
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
# sudo pacman -S --noconfirm --needed aacgain  # for AAC suport
# yay -S aacgain-cvs --noconfirm  # Регулирует громкость музыкальных файлов (mp4/m4a/QT/mp3) с помощью алгоритма ReplayGain ; https://aur.archlinux.org/packages/aacgain-cvs ; https://aur.archlinux.org/aacgain-cvs.git (только для чтения, нажмите, чтобы скопировать) ; http://altosdesign.com/aacgain ; Конфликты: с aacgain ; 2021-07-25 19:36 (UTC)
########### vorbisgain ###############
sudo pacman -S --noconfirm --needed libvorbis  # Референсная реализация аудиоформата Ogg Vorbis ; https://archlinux.org/packages/extra/x86_64/libvorbis/ ; https://www.xiph.org/vorbis/ ; Обеспечивает: libvorbis.so=0-64, libvorbisenc.so=2-64, libvorbisfile.so=3-64 ; 2025-01-27 23:00 UTC
yay -S vorbisgain --noconfirm  # Утилита, вычисляющая значения ReplayGain для файлов Ogg Vorbis ; https://aur.archlinux.org/packages/vorbisgain ; https://aur.archlinux.org/vorbisgain.git (только для чтения, нажмите, чтобы скопировать) ; https://sjeng.org/vorbisgain.html ; 2024-09-09 17:31 (UTC)
# git clone https://aur.archlinux.org/vorbisgain.git  # (только для чтения, нажмите, чтобы скопировать)
# cd vorbisgain
# makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf vorbisgain
# rm -Rf vorbisgain
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
######## easymp3gain-qt4-bin ############
# yay -S easymp3gain-qt4-bin --noconfirm  # Графический пользовательский интерфейс Qt (GUI) для MP3Gain, VorbisGain и AACGain (двоичный пакет) ; https://aur.archlinux.org/packages/easymp3gain-qt4-bin ; https://aur.archlinux.org/easymp3gain-qt4-bin.git (только для чтения, нажмите, чтобы скопировать) ; http://easymp3gain.sourceforge.net/ ; Конфликты: с easymp3gain-gtk2, easymp3gain-gtk2-bin, easymp3gain-qt4 ; Обеспечивает: easymp3gain ; https://sourceforge.net/projects/easymp3gain/files/easymp3gain%20i386/easymp3gain-0.5.0/easymp3gain-qt4_0.5.0_i386.tar.gz ; https://sourceforge.net/projects/easymp3gain/files/easymp3gain%20x86_64/easymp3gain-0.5.0/easymp3gain-qt4_0.5.0_amd64.tar.gz ; 2020-02-29 13:33 (UTC)
# git clone https://aur.archlinux.org/easymp3gain-qt4-bin.git  # (только для чтения, нажмите, чтобы скопировать)
# cd easymp3gain-qt4-bin
# makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf easymp3gain-qt4-bin
# rm -Rf easymp3gain-qt4-bin
######## Зависимости ############
# qt4 AUR - https://aur.archlinux.org/packages/qt4 ;
# qt4pas AUR - https://aur.archlinux.org/packages/qt4pas ;
# aacgain ( aacgain-cvs AUR ) (необязательно) – для поддержки AAC - https://aur.archlinux.org/packages/aacgain-cvs
# mp3gain AUR (опционально) – для поддержки MP3 - https://aur.archlinux.org/packages/mp3gain
# vorbisgain AUR (необязательно) – для поддержки OGG - https://aur.archlinux.org/packages/vorbisgain
##################################
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
echo -e "${BLUE}:: ${NC}Установить MP3 Diags (mp3diags) - Восстановление и ремонт MP3?"
echo -e "${MAGENTA}:: ${BOLD}MP3 Diags — это приложение с графическим интерфейсом (GUI), позволяющее конечным пользователям распознавать ошибки в MP3 файлах, устранять их и осуществлять некоторые другие изменения (например, добавлять информацию о треках). Также утилита позволяет пользователю "заглянуть внутрь" MP3 файлов. ${NC}"
echo " Домашняя страница: https://mp3diags.sourceforge.net/; (https://aur.archlinux.org/packages/mp3diags). "
echo -e "${MAGENTA}:: ${BOLD}В отличие от некоторых других программ, предназначенных для выполнения одной конкретной задачи (например, исправление заголовков VBR, или поиск обложек для альбомов), MP3 Diags — универсальное решение, способное распознать более пятидесяти различных проблем в MP3 файлах и предоставить средства для устранения многих из них. Список проблем, с которыми поможет разобраться MP3 Diags более чем внушительный: неправильные/дублирующие теги, неверная кодировка тегов (неанглийские символы), неверная длительность/некорректная перемотка в плеере (переменный битрейт), не-аудиоданные внутри аудиопотока, неизвестные/неподдерживаемые/пустые аудиопотоки, а также «улучшение» качества, нормализация громкости и многое другое, всего около пятидесяти пунктов. ${NC}"
echo -e "${BLUE}:: ${NC}Основные возможности программы MP3 Diags: Диагностика более 50 типов проблем: Программа находит и помогает устранить более 50 различных типов ошибок в MP3-файлах, таких как поврежденные теги, битые заголовки и неправильные данные. Исправление неполных тегов: Помогает выявить и исправить неполные или поврежденные теги в MP3-файлах. Редактор тегов: Позволяет редактировать метаданные файлов, включая название, исполнителя, альбом, год выпуска и другие параметры. Инструмент для переименования файлов: Обеспечивает возможность автоматического переименования файлов в соответствии с заданными правилами. Решение для проблем с нормализацией звука: Нормализует уровень звука в MP3-файлах для оптимального звучания. Работа с обложками: Программа помогает добавлять, изменять или исправлять обложки альбомов в MP3-файлах. Гибкость и универсальность: Обеспечивает решение множества проблем, связанных с качеством и метаданными MP3-файлов, что делает ее удобной для работы с большой коллекцией музыки. Поддержка разных типов ошибок: MP3 Diags находит и помогает исправить такие ошибки, как битые теги, заголовки и недостающая информация о треке. Полный контроль над MP3-файлами: Программа предоставляет все необходимые инструменты для работы с MP3, от диагностики до исправления ошибок и улучшения качества. "
echo -e "${CYAN}:: ${NC}Установка Monitorix MP3 Diags (mp3diags) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/mp3diags.git), (https://aur.archlinux.org/packages/mp3diags) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_mp3diags  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_mp3diags" =~ [^10] ]]
do
    :
done
if [[ $in_mp3diags == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_mp3diags == 1 ]]; then
  echo ""
  echo " Установка MP3 Diags (mp3diags) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
######## Зависимости ############
sudo pacman -S --noconfirm --needed boost-libs  # Бесплатные рецензируемые переносимые исходные библиотеки C++ (библиотеки времени выполнения) ; https://www.boost.org/ ; https://archlinux.org/packages/extra/x86_64/boost-libs/
sudo pacman -S --noconfirm --needed boost  # Бесплатные рецензируемые переносимые исходные библиотеки C++ (заголовочные файлы для разработки) ; https://www.boost.org/ ; https://archlinux.org/packages/extra/x86_64/boost/
######## mp3diags ############
yay -S mp3diags --noconfirm  # Найти и исправить проблемы в файлах MP3. Включает теггер ; https://mp3diags.sourceforge.net/ ; https://aur.archlinux.org/packages/mp3diags ; https://github.com/mciobanu/mp3diags/archive/refs/tags/1.5.03.tar.gz
# git clone https://aur.archlinux.org/mp3diags.git  # (только для чтения, нажмите, чтобы скопировать)
# cd mp3diags
# makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf mp3diags
# rm -Rf mp3diags
# MP3 Diags находит проблемы в файлах MP3 и помогает пользователю исправить многие из них. Он проверяет как аудиочасть (информация VBR, качество, нормализация), так и теги, содержащие информацию о треке (ID3). Он имеет редактор тегов, который может загружать информацию об альбоме (включая обложку) из MusicBrainz и Discogs, а также вставлять данные из буфера обмена. Информация о треке также может быть извлечена из имени файла. Другим компонентом является переименователь файлов, который может переименовывать файлы на основе полей в их теге ID3V2 (исполнитель, номер трека, альбом, жанр и т. д.).
# Для более подробной информации посетите https://mp3diags.sf.net/unstable и https://mp3diags.blogspot.com/ ; https://htmlpreview.github.io/?https://raw.githubusercontent.com/mciobanu/mp3diags/master/doc/html/110_first_run.html ; https://mp3diags.sourceforge.net/030_users_guide.html ; https://github.com/mciobanu/mp3diags
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить MP3Info (mp3info) — Просмотрщик технической информации MP3 и редактор тегов ID3 1.x?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Проект начат Рикардо Церкейро (Ricardo Cerqueira), в январе 2000 года основным разработчиком стал Седрик Теффт (Cedric Tefft) и сейчас продолжает курировать проект. На сайте проекта доступны два неофициальных скрипта использующих консольную версию MP3Info для группового переименования MP3-файлов и генерации M3U плейлиста из каталога аудиофайлов. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}MP3Info — небольшая консольная Curses / Ncurses утилита для просмотра технической информации о MP3-файлах и редактирования ID3-тегов. MP3Info также может отображать различные технические характеристики MP3-файла, включая время воспроизведения, битрейт, частоту дискретизации и другие атрибуты, в предопределенном или указанном пользователем формате вывода. MP3Info разработан под Linux, но должен работать на большинстве версий UN*X. В текстовую версию включена графическая версия (щёлкните здесь , чтобы увидеть скриншот), требующая библиотеки GTK2 (gtk2). Консольная версия работает в режиме командной строки и интерактивном режиме curses. Для интерактивного режима требуется библиотека curses или ncurses. Этот проект Лицензируется под GNU General Public License version 2.0 (GPLv2). ${NC}"
echo " Домашняя страница: https://ibiblio.org/mp3info/ ; (https://archlinux.org/packages/extra/x86_64/mp3info/). "
echo -e "${BLUE}:: ${NC}Метаданные / Теги — это информативные метки в аудио/видео/графических файлах требующееся для описания файла, а так же поиска нужного файла по названию, автору, году выпуска, альбому и/или комментарию. Метаданные предоставляются в соответствии с одним из форматов (наборов полей). ID3 (IDentify an MP3) — формат метаданных (тегов) наиболее часто используемый в аудио-файлах в формате MP3 (MPEG-1/2/2.5 Layer 3). Содержащиеся в формате данные (название, альбом, исполнитель и пр) используются различными приложениями (плеерами, каталогизаторами и пр) и аппаратными проигрывателями для отображении информации о файле. "
echo -e "${CYAN}:: ${NC}MP3Info отображает практически всю техническую информацию о MP3-файлах (размер, время воспроизведения, битрейт и др) в заданном пользователем формате вывода. Редактирование ID3-тегов осуществляется из командной строки или в интерактивном режиме (у пользователя запрашивается подтверждение каждого действия). "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_mp3info  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_mp3info" =~ [^10] ]]
do
    :
done
if [[ $in_mp3info == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_mp3info == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) MP3Info (mp3info) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) (ncurses ; gtk2) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed ncurses  # Библиотека эмуляции проклятий System V Release 4.0 ; https://archlinux.org/packages/core/x86_64/ncurses/ ; https://invisible-island.net/ncurses/ncurses.html ; Обеспечивает: libformw.so=6-64, libmenuw.so=6-64, libncurses++w.so=6-64, libncursesw.so=6-64, libpanelw.so=6-64 ; Заменяет: alacritty-terminfo, rio-terminfo, wezterm-terminfo ; 2025-05-11 10:20 UTC
sudo pacman -S --noconfirm --needed gtk2  # (необязательно) - запустить графический интерфейс gmp3info ; Мультиплатформенный набор инструментов для создания графического интерфейса на основе GObject (устаревший) ; https://archlinux.org/packages/extra/x86_64/gtk2/ ; https://www.gtk.org/ ; Обеспечивает: libgailutil.so=18-64, libgdk-x11-2.0.so=0-64, libgtk-x11-2.0.so=0-64 ; 2024-09-09 21:32 UTC
########### mp3info ##########
sudo pacman -S --noconfirm --needed mp3info  # Просмотрщик технической информации MP3 и редактор тегов ID3 1.x ; https://archlinux.org/packages/extra/x86_64/mp3info/ ; https://ibiblio.org/mp3info/ ; 2023-05-19 17:06 UTC
  echo ""
  echo " Посмотрите информацию о версии (mp3info) "
sudo pacman -Q mp3info  #  Показать версию приложения ; Альтернативный метод — проверить версию установленного пакета NTP через менеджер пакетов системы.
# sudo pacman -Qs имя_пакета  # Используйте команду pacman с -Qs опцией поиска только среди установленных пакетов в системе. Она ищет указанный текст только в названиях и описаниях установленных пакетов.
# sudo pacman -Qi имя_пакета  # Эта -Qi опция отображает подробную информацию об указанном пакете. Она также показывает метаданные пакета, такие как зависимости, конфликты, дата установки, дата сборки, размер и т. д.
# sudo pacman -Si имя_пакета  # Эта -Si опция позволяет просматривать подробную информацию о любых пакетах Arch Linux. Необходимо указать точное название пакета.
# mp3info --version  # Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить MKVToolnix (mkvtoolnix-cli) (mkvtoolnix-gui) — Набор инструментов для создания, редактирования и проверки файлов Matroska?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *MKV — это формат файла для видео высокой чёткости. Он обеспечивает более богатое качество воспроизведения по сравнению с другими форматами файлов, поэтому многие популярные сайты потокового вещания считают его предпочтительным форматом. Matroska — это новый формат контейнера мультимедиа, основанный на EBML (Extensible Binary Meta Language), разновидности двоичного XML. Эти инструменты позволяют манипулировать файлами Matroska. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}MKVToolnix — это бесплатный набор инструментов с открытым исходным кодом для создания, редактирования и проверки файлов Matroska (.mkv). Он поддерживает различные форматы видео, аудио и субтитров, что делает его идеальным инструментом для управления медиаконтентом. MKVToolnix — набор инструментов для медиа-контейнера Matroska от Морица Бункуса, включая mkvmerge. Он позволяет изменить содержимое медиафайла без его пересжатия. А именно: добавлять, извлекать, удалять звуковые дорожки и субтитры и редактировать (разбивать/объединять) видео файлы. Инструмент MKVToolnix представляет собой сочетание командной строки и графического интерфейса, благодаря чему выполнение таких распространённых задач, как извлечение потоков из файлов MKV, слияние нескольких потоков и разделение файлов MKV, становится проще простого. Хотя в приложение встроено множество инструментов, стоит отметить mkvmerge, mkvextract, mkvinfo, mmg и mkvpropedit. MKVtoolnix GUI был разработан Морицем Бункусом в 2003 году с использованием языков программирования Ruby и C++ и выпущен под лицензией GNU GPLv2. Это легковесное и многофункциональное приложение. Этот проект Лицензируется Только GPL-2.0 . ${NC}"
echo " Домашняя страница: https://mkvtoolnix.download/  ; (https://en.wikipedia.org/wiki/MKVToolNix ; https://mkvtoolnix.org/source/). "
echo -e "${BLUE}:: ${NC}Компоненты: MKVToolNix GUI - графический интерфейс Qt для mkvmerge. mkvmerge - объединяет мультимедийные потоки в файл Matroska (инструмент для создания файлов Matroska из других форматов). mkvinfo - перечисляет все элементы, содержащиеся в файле Matroska (позволяет получить информацию о треках в файле Matroska). mkvextract - извлекает определенные части из файла Matroska в другие форматы. mkvpropedit - позволяет анализировать и изменять некоторые свойства файла Matroska. "
echo -e "${CYAN}:: ${NC}Теперь давайте рассмотрим возможности приложения-редактора mkvtoolnix gui (mkvmerge gui): Это кроссплатформенное приложение, работающее под управлением основных операционных систем: Linux, Microsoft Windows, macOS, FreeBSD. Это приложение поддерживает различные форматы видеофайлов, например MPEG, MP4, AVI и т. д. MKVtoolnix gui (mkvmerge gui) поддерживает почти 19 языков. Поддерживаемые форматы аудиофайлов: MP3, AAC, WAV, FLAC и т. д. Доступно как для 32-битных, так и для 64-битных операционных систем. Разделение и объединение файлов MKV. Поддерживаемые форматы субтитров: SSA, SRT и т. д. Более подробную информацию и функции вы можете найти на официальном сайте (https://mkvtoolnix.download/). "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_mkvtoolnix  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_mkvtoolnix" =~ [^10] ]]
do
    :
done
if [[ $in_mkvtoolnix == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_mkvtoolnix == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) MKVToolnix (mkvtoolnix-cli) (mkvtoolnix-gui) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########## mkvtoolnix-cli ############
sudo pacman -S --noconfirm --needed mkvtoolnix-cli  # Набор инструментов для создания, редактирования и проверки файлов Matroska ; https://archlinux.org/packages/extra/x86_64/mkvtoolnix-cli/ ; https://mkvtoolnix.download/ ; 2025-08-14 14:22 UTC
########## mkvtoolnix-gui ############
sudo pacman -S --noconfirm --needed mkvtoolnix-gui  # Набор инструментов для создания, редактирования и проверки файлов Matroska ; https://archlinux.org/packages/extra/x86_64/mkvtoolnix-gui/ ; https://mkvtoolnix.download/ ; 2025-08-14 14:22 UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# MKVToolnix (mkvtoolnix-cli) (mkvtoolnix-gui)
# https://mkvtoolnix.download/
# https://en.wikipedia.org/wiki/MKVToolNix
# https://mkvtoolnix.org/source/
####################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Ardour (ardour) - Запись и обработка звука (редактирование и микширование) звука?"
echo -e "${MAGENTA}:: ${BOLD}Ardour — программа для профессиональной записи и обработки звука. Поддерживает запись звука с различных источников, микширование, редактирование, мастеринг, плагины и так далее. Ardour — это открытый исходный код, совместная работа всемирной команды, включающей музыкантов, программистов и профессиональных звукорежиссеров. Разработка прозрачна — любой может наблюдать за нашей работой по мере ее выполнения. ${NC}"
echo " Домашняя страница: https://ardour.org/ ; (https://archlinux.org/packages/extra/x86_64/ardour/). "
echo -e "${MAGENTA}:: ${BOLD}Основная группа пользователей Ardour: люди, которые хотят записывать, редактировать, микшировать и мастерить аудио и MIDI-проекты. Когда вам нужен полный контроль над вашими инструментами, когда ограничения других проектов мешают, когда вы планируете потратить часы или дни на работу над сессией, Ardour поможет вам сделать так, как вы хотите. Быть лучшим инструментом для записи талантливых исполнителей на настоящих инструментах всегда было главным приоритетом для Ardour. Вместо того, чтобы сосредоточиться на электронных и поп-музыкальных идиомах, Ardour выходит за рамки, чтобы поощрять творческий процесс оставаться там, где он всегда был: музыкант, играющий на тщательно спроектированном и хорошо сделанном инструменте. Точная синхронизация сэмплов и общее управление транспортом с помощью инструментов воспроизведения видео позволяют Ardour предоставлять быструю и естественную среду для создания и редактирования саундтреков к кино- и видеопроектам. Аранжируйте аудио и MIDI, используя те же инструменты и тот же рабочий процесс. Используйте внешние аппаратные синтезаторы или программные инструменты в качестве источников звука. От звукового дизайна до электроакустической композиции и плотного многодорожечного редактирования MIDI, Ardour может помочь. Список источников Ardour позволяет легко организовывать и перемещаться даже по большим объемам клипов и лент. Несколько режимов ряби делают редактирование как простых двухмикрофонных эпизодов, так и функций с большим объемом записи на ленту легким. Интегрированный поиск freesound.org обеспечивает легкий доступ к тысячам клипов и джинглов. Любое количество дорожек и шин. Нелинейный монтаж. Неразрушающая (и разрушающая!) запись. Любая битовая глубина, любая частота дискретизации. Десятки форматов файлов. ${NC}"
echo -e "${BLUE}:: ${NC}Дополнительные возможности Ardour включают: Запись звука. Многоканальная запись. Наложение эффектов. Микширование. Произвольное количество звуковых дорожек. Редактирование аудио. Обрезка, перемещение фрагментов, изменение темпа, копирование, вставка, удаление, выравнивание и другие действия. Неограниченная история действий с возможностью повтора и отмены. История сохраняется после закрытия проекта. Импорт и экспорт звуковых файлов. Поддержка MIDI-дорожек. Работа с аудио-дорожками видео. Извлечение звуковой дорожки из видео. Контроль синхронизации видео и звука. Поддержка плагинов. Исходный код: Open Source (открыт); Языки программирования: C++; Библиотеки: GTK; Лицензия: GNU GPL. Доступна для Linux, Windows и MacOS. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_ardour  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_ardour" =~ [^10] ]]
do
    :
done
if [[ $in_ardour == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_ardour == 1 ]]; then
  echo ""
  echo " Установка Ardour (ardour) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed ardour  # Профессиональная цифровая звуковая рабочая станция ; https://ardour.org/ ; https://archlinux.org/packages/extra/x86_64/ardour/ ; 15 апреля 2024 г., 21:34 UTC ; Обеспечивает: ladspa-host, lv2-host, vamp-host, vst-host, vst3-host
sudo pacman -S --noconfirm --needed harvid  # HTTP Ardour Video Daemon (harvid декодирует неподвижные изображения из видеофайлов и передает их через HTTP) ; https://x42.github.io/harvid/ ; https://archlinux.org/packages/extra/x86_64/harvid/ ; June 21, 2024, 7:50 p.m. UTC
# Предполагаемое применение harvid — эффективное предоставление данных с точностью до кадра и работа в качестве кэша второго уровня для рендеринга временной шкалы видео в Ardour , но этим он не ограничивается: у него есть приложения для любой задачи, требующей высокопроизводительного процессора извлечения изображений с точностью до кадра.
# При использовании с Ardour, Ardour автоматически запустит сервер при открытии видео. Вы также можете запустить harvid вручную. В любом случае он будет по умолчанию прослушивать запросы на http://localhost:1554/, и вы сможете взаимодействовать с ним с помощью любого веб-браузера.
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Audio-recorder (audio-recorder) - Приложение для записи звука?"
echo -e "${MAGENTA}:: ${BOLD}Audio-recorder - бесплатный аудиорекордер для Linux. Эта удивительная программа позволяет вам записывать любимую музыку и аудио в файл. Она может записывать аудио со звуковой карты вашей системы, микрофонов, браузеров, веб-камер и т. д. Проще говоря: если что-то воспроизводится через ваши динамики, вы можете это записать. ${NC}"
echo " Домашняя страница: https://launchpad.net/~audio-recorder ; (https://aur.archlinux.org/packages/audio-recorder). "
echo -e "${MAGENTA}:: ${BOLD}Эта программа поддерживает несколько аудиоформатов (выходных), таких как OGG audio, FLAC, MP3 и WAV. Позволяет выбрать записывающее устройство, например микрофон, веб-камеру, выход звуковой карты (запись звука с громкоговорителей) и т. д. ${NC}"
echo -e "${CYAN}:: ${NC}Он имеет расширенный таймер, который может: Начинать, останавливать или приостанавливать запись в заданное время. Начинать, останавливать или приостанавливать запись по истечении определенного периода времени. Останавливаться, когда размер записанного файла превышает ограничение. Начинать запись по голосу или звуку (пользователь может установить пороговое значение звука). Останавливать или приостанавливать запись по «тишине» (пользователь может установить пороговое значение звука и задержку). Запись может автоматически контролироваться совместимыми с MPRIS2 медиаплеерами. Ссылка: http:// specifications. freedesktop. org/mpris- spec/latest/ (MPRIS2 spec). "
echo -e "${CYAN}:: ${NC}Установка Audio-recorder (audio-recorder) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/audio-recorder.git), (https://aur.archlinux.org/packages/audio-recorder) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_audiorecorder  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_audiorecorder" =~ [^10] ]]
do
    :
done
if [[ $in_audiorecorder == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_audiorecorder == 1 ]]; then
  echo ""
  echo " Установка Audio-recorder (audio-recorder) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
####### audio-recorder ########
yay -S audio-recorder --noconfirm  # Приложение для записи звука ; https://aur.archlinux.org/audio-recorder.git ; https://launchpad.net/~audio-recorder ; https://aur.archlinux.org/packages/audio-recorder ; https://launchpad.net/~audio-recorder/+archive/ubuntu/ppa/+sourcefiles/audio-recorder/3.3.4~jammy/audio-recorder_3.3.4~jammy.tar.gz ; 2024-04-24 15:18 (UTC) ; Смотрите Зависимости !
#git clone https://aur.archlinux.org/audio-recorder.git   # (только для чтения, нажмите, чтобы скопировать)
#cd audio-recorder
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf audio-recorder
#rm -Rf audio-recorder
# yay -Rns audio-recorder  # * (Необязательно) Удалите на Arch с помощью YAY
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить SoundRecorder (gnome-sound-recorder) или (krecorder) - Простой и современный диктофон?"
echo -e "${MAGENTA}:: ${BOLD}SoundRecorder (GNOME Sound Recorder) — простое и легкое приложение для записи звука, разработанное специально для среды рабочего стола GNOME , которая широко используется в различных дистрибутивах Linux. Он предлагает нам простой способ захвата звука с помощью микрофона системы или других доступных источников входного сигнала. ${NC}"
echo " Домашняя страница: https://wiki.gnome.org/Apps/SoundRecorder ; (https://apps.kde.org/krecorder/ ; https://archlinux.org/packages/extra/any/gnome-sound-recorder/). "
echo -e "${MAGENTA}:: ${BOLD}Recorder KDE — простое кроссплатформенное приложение для записи звука. Если вы хотите записать голос за кадром через микрофон вашего компьютера, вы можете использовать GNOME Sound Recorder или Audacity. Использовать GNOME Sound Recorder легко, но ему не хватает функций. Audacity может показаться сложным поначалу, но у него достаточно функций для записи профессионального уровня. Однако я не буду вдаваться в эти подробности в этом руководстве. GNOME Sound Recorder работает с микрофоном. Есть еще один инструмент под названием Audio Recorder, и вы можете использовать его для записи потоковой музыки (из Spotify, YouTube, интернет-радио, Skype и большинства других источников) помимо микрофонного ввода. ${NC}"
echo -e "${BLUE}:: ${NC}После установки вы сможете найти его в системном меню и начать работу оттуда. Прежде чем начать использовать его, убедитесь, что в системных настройках выбран правильный источник входного сигнала. Нажмите на кнопку записи, и запись звука начнется мгновенно. Во время записи у вас есть возможность приостановить, остановить или отменить запись. Ваши записи сохраняются и доступны из самого интерфейса приложения. Нажмите на сохраненные записи, чтобы выделить их. Вы можете воспроизвести записи повторно или удалить их. Вы можете сохранить их в другом месте, нажав кнопку сохранения/загрузки. Вы также можете переименовать записи, используя кнопку редактирования. Вы можете выбрать формат записи MP3, FLAC и еще пару форматов. Более того, мы можем изменить настройки, нажав на опцию «Настройки» в раскрывающемся списке в правом верхнем углу. В настройках можно настроить различные параметры, такие как предпочтительный формат экспорта или режим по умолчанию. По умолчанию GNOME Sound Recorder экспортирует аудиозаписи в формате Ogg Vorbis, но также поддерживает MP3, FLAC, NOV и Opus . Кроме того, мы можем регулировать громкость микрофона и системы. Это дает нам простой способ контролировать уровень громкости каждого во время записи. GNOME Sound Recorder имеет ряд важных функций: простой и удобный интерфейс предлагающий всего две опции:; поддержка нескольких аудиоформатов; режимы записи моно и стерео. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить SoundRecorder GNOME (gnome-sound-recorder),     2 - Установить Recorder KDE (krecorder),

    0 - НЕТ - Пропустить установку: " in_recorder  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_recorder" =~ [^120] ]]
do
    :
done
if [[ $in_recorder == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_recorder == 1 ]]; then
  echo ""
  echo " Установка SoundRecorder (gnome-sound-recorder) "
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
sudo pacman -S --noconfirm --needed lm_sensors  # (необязательно) - температура процессора ; Коллекция инструментов пользовательского пространства для общего доступа к SMBus и мониторинга оборудования ; https://archlinux.org/packages/extra/x86_64/lm_sensors/ ; https://hwmon.wiki.kernel.org/lm_sensors ; Обеспечивает: libsensors.so=5-64 ; 2025-05-14 05:28 UTC
############ gnome-sound-recorder ##############
sudo pacman -S --noconfirm --needed gnome-sound-recorder  #  Утилита для простой записи звука с рабочего стола GNOME ; https://wiki.gnome.org/Apps/SoundRecorder ; https://archlinux.org/packages/extra/any/gnome-sound-recorder/ ; 12 июля 2024 г., 16:26 UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_recorder == 2 ]]; then
  echo ""
  echo " Установка Recorder (krecorder) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
sudo pacman -S --noconfirm --needed lm_sensors  # (необязательно) - температура процессора ; Коллекция инструментов пользовательского пространства для общего доступа к SMBus и мониторинга оборудования ; https://archlinux.org/packages/extra/x86_64/lm_sensors/ ; https://hwmon.wiki.kernel.org/lm_sensors ; Обеспечивает: libsensors.so=5-64 ; 2025-05-14 05:28 UTC
############ krecorder ##############
sudo pacman -S --noconfirm --needed krecorder  # Аудиорекордер для Plasma Mobile и других платформ ; https://apps.kde.org/krecorder/ ; https://archlinux.org/packages/kde-unstable/x86_64/krecorder/ ; 15 августа 2024 г., 21:02 UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo -e "${MAGENTA}
  <<< Установка утилит для получения сведений о медиафайлах в Archlinux >>> ${NC}"
# Installing utilities to get information about media files in Archlinux
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Media-player-info — Данные о плеерах?"
echo -e "${MAGENTA}:: ${BOLD}Media-Player-Info — это репозиторий файлов данных, описывающих возможности старых USB-медиаплееров, которые пока не используют MTP, а используют протокол USB Mass Storage. Эти файлы содержат информацию о поддерживаемых форматах файлов и структуре каталогов, которые можно использовать для добавления музыки на эти устройства, поддерживаемых форматах файлов и т. д. Раньше эти возможности предоставлялись HAL в файле 10-usb-music-players.fdi, но теперь HAL устарел , поэтому информация предоставляется в виде отдельного пакета. Файлы данных, описывающие возможности медиаплеера, для систем после HAL. ${NC}"
echo " Домашняя страница: https://www.freedesktop.org/wiki/Software/media-player-info/ ; (https://gitlab.freedesktop.org/media-player-info/media-player-info ; https://archlinux.org/packages/extra/any/media-player-info/). "
echo -e "${MAGENTA}:: ${BOLD}Возможности музыкального проигрывателя описаны в файлах .mpi (которые являются файлами типа .ini), которые вы можете найти в media-players/ . Эти файлы mpi используются для генерации базы данных udev hwdb и правил udev, которые затем связывают ID_MEDIA_PLAYERатрибут с устройствами медиаплеера. Этот атрибут указывает имя файла .mpi, который будет использоваться для определения возможностей устройства. Затем .mpi можно найти в $XDG_DATA_DIRS/media-player-info (см.спецификацию базового каталога XDG https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html для получения дополнительной информации). И файлы mpi, и сгенерированные udev hdwb/rules должны быть установлены в системе. Последние сопоставляют только устройства медиаплееров и устанавливают. ${NC}"
echo -e "${BLUE}:: ${NC}ID_MEDIA_PLAYER свойство udev на устройстве, которое указывает на файл mpi. Приложения, которым нужна подробная информация о медиаплеерах (например, поддерживаемые ими аудиоформаты), должны проанализировать этот файл и извлечь из него все необходимое. Информация о медиаплеере не включена напрямую в базу данных udev, потому что она нужна не многим приложениям, и потому что мы не хотели повторять те же ошибки, что и HAL, и включать все в свою базу данных. Данные хранятся в файлах *.mpi (в формате ini-файлов), вместе с правилами udev для идентификации этих устройств. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " i_mediain  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_mediain" =~ [^10] ]]
do
    :
done
if [[ $i_mediain == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_mediain == 1 ]]; then
  echo ""
  echo " Установка Media-player-info (media-player-info) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed media-player-info  # Файлы данных, описывающие возможности медиаплеера для систем post-HAL... https://archlinux.org/packages/extra/any/media-player-info/ ; https://www.freedesktop.org/wiki/Software/media-player-info/ ; https://github.com/OpenMandrivaAssociation/media-player-info ; 12 июля 2024 г., 23:03 UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить MediaInfo (mediainfo) и (mediainfo-gui) - Информация о медиафайлах?"
echo -e "${MAGENTA}:: ${BOLD}MediaInfo — небольшая консольная программа для просмотра различной «специальной» информации о медиафайлах, такой как битрейт, соотношение сторон, частота кадров, кодеки, субтитры, каналы, частота дискретизации, теги и т.п. Поддерживаются огромное количество аудио, видео, графических форматов и кодеков, несколько способов отображения (простой, HTML, текст), есть возможность сохранить полученные данные в файл. Программа распространяется на условиях лицензии GPL, есть версии для Linux, Windows и Mac, доступен исходный код. Для MediaInfo существует графический интерфейс (на английском). ${NC}"
echo " Домашняя страница: https://mediaarea.net/ ; (https://archlinux.org/packages/extra/x86_64/mediainfo/ ; https://archlinux.org/packages/extra/x86_64/mediainfo-gui/). "
echo -e "${MAGENTA}:: ${BOLD}Возможности MediaInfo включают в себя: Читает множество форматов видео и аудио файлов. Просмотр информации в различных форматах (текст, таблица, дерево, HTML...). Настройте эти форматы просмотра. Экспортируйте информацию в формате текста, CSV, HTML... Доступны версии с графическим пользовательским интерфейсом, интерфейсом командной строки или библиотекой (.dll/.so/.dylib). Интеграция с оболочкой (перетаскивание и контекстное меню). Интернационализация: отображение любого языка в любой операционной системе. Это программное обеспечение с открытым исходным кодом , что означает, что конечные пользователи и разработчики имеют свободу изучать, улучшать и распространять программу ( лицензия в стиле BSD ). ${NC}"
echo " Отображение данных MediaInfo включает в себя: Контейнер: формат, профиль, коммерческое название формата, продолжительность, общий битрейт, приложение и библиотека записи, название, автор, режиссер, альбом, номер трека, дата, продолжительность... Видео: формат, идентификатор кодека, соотношение сторон, частота кадров, скорость передачи данных, цветовое пространство, цветовая субдискретизация, битовая глубина, тип сканирования, порядок сканирования... Аудио: формат, идентификатор кодека, частота дискретизации, каналы, битовая глубина, язык, битрейт... Текст: формат, идентификатор кодека, язык субтитров... Главы: количество глав, список глав... Аналитика MediaInfo включает в себя: комментарии Vorbis, теги APE... Видео: MPEG-1/2 Video, H.263, MPEG-4 Visual (включая DivX, XviD), H.264/AVC, H.265/HEVC, FFV1... Аудио: MPEG Audio (включая MP3), AC3, DTS, AAC, Dolby E, AES3, FLAC... Субтитры: CEA-608, CEA-708, DTVCC, SCTE-20, SCTE-128, ATSC/53, CDP, DVB-субтитры, телетекст, SRT, SSA, ASS, SAMI... Для получения информации, достаточно запустить MediaInfo и перетащить нужный файл в окно программы, либо выполнить в терминале: mediainfo /путь/к/файлу/my_video.ogv ; где вместо «/путь/к/файлу/» — полный путь к вашему файлу, а вместо «my_video.ogv» — название интересующего файла. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " i_mediainfo  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_mediainfo" =~ [^10] ]]
do
    :
done
if [[ $i_mediainfo == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_mediainfo == 1 ]]; then
  echo ""
  echo " Установка MediaInfo (mediainfo) и MediaInfo-GUI (mediainfo-gui) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
sudo pacman -S --noconfirm --needed libmediainfo  # Общая библиотека для MediaInfo ; https://mediaarea.net/ ; https://archlinux.org/packages/extra/x86_64/libmediainfo/ ; 29 июня 2024 г., 8:40 утра UTC
sudo pacman -S --noconfirm --needed mediainfo  # Предоставляет техническую и теговую информацию о видео или аудио файле (интерфейс командной строки) https://archlinux.org/packages/extra/x86_64/mediainfo/ ; https://mediaarea.net/ ; https://mediaarea.net/en/MediaInfo ; 29 июня 2024 г., 8:40 утра UTC
sudo pacman -S --noconfirm --needed mediainfo-gui  # Предоставляет техническую и теговую информацию о видео или аудио файле (интерфейс GUI) https://archlinux.org/packages/extra/x86_64/mediainfo-gui/ ; https://mediaarea.net/ ; June 29, 2024, 8:40 a.m. UTC
sudo pacman -S --noconfirm --needed python-pymediainfo  # Обертка Python вокруг библиотеки MediaInfo ; https://github.com/sbraz/pymediainfo/ ; https://archlinux.org/packages/extra/any/python-pymediainfo/ ; April 27, 2024, 10:21 a.m. UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo -e "${MAGENTA}
  <<< Установка программ для редактирования тегов аудио (файлов) в Archlinux >>> ${NC}"
# Installing programs for editing audio tags (files) in Archlinux
echo ""
echo -e "${BLUE}:: ${NC}Установить EasyTAG - (для просмотра и редактирования тегов в аудиофайлах)?"
echo -e "${MAGENTA}:: ${BOLD}EasyTAG - это бесплатная и с открытым исходным кодом, мультиплатформенная программа для просмотра и редактирования тегов аудиофайлов - MP3, MP4/AAC, FLAC, Ogg и других. ${NC}"
echo " Домашняя страница: https://wiki.gnome.org/Apps/EasyTAG ; (https://archlinux.org/packages/extra/x86_64/easytag/). "
echo -e "${MAGENTA}:: ${BOLD}Описание: Просмотр, редактирование, запись тегов MP3, файлов MP2 (тег ID3 с изображениями), файлов FLAC (тег FLAC Vorbis), файлов Ogg Opus (тег Ogg Vorbis), Ogg Speex (тег Ogg Vorbis), файлов Ogg Vorbis (тег Ogg Vorbis) ), MP4 / AAC (тег MP4 / AAC), MusePack, аудиофайлы Monkey’s Audio и файлы WavPack (тег APE); Можно редактировать дополнительные поля тегов: название, исполнитель, альбом, номер диска, год, номер дорожки, комментарий, композитор, оригинальный исполнитель / исполнитель, авторское право, URL, имя кодировщика и прикрепленное изображение; Автоматическая маркировка: имя файла и каталог для автоматического заполнения полей (маски); Возможность переименовывать файлы и каталоги из тега (используя маски) или путем загрузки текстового файла; Обрабатывать выбранные файлы выбранного каталога; Возможность просмотра подкаталогов; Рекурсия для пометки, удаления, переименования, сохранения…; Можно установить поле (исполнитель, название, …) для всех других файлов; Чтение и отображение информации заголовка файла (битрейт, время,…); Автоматическое завершение даты, если введена частичная; Отменить и повторить последние изменения; Возможность обрабатывать поля тега и имени файла (конвертировать буквы в верхний, нижний регистр,…; Возможность открыть каталог или файл с помощью внешней программы; Поддержка CDDB с использованием серверов Freedb.org и Gnudb.org (ручной и автоматический поиск); Древовидный браузер или просмотр по исполнителю и альбому; Список для выбора файлов; Окно генератора списка воспроизведения; Окно поиска файла; Простой и понятный интерфейс с поддержкой русского языка. ${NC}"
echo " Программа имеет автоматический режим для пакетной обработки файлов. EasyTag может использоваться для перекодирование тегов в другие кодировки (например, в UTF-8). Для настройки EasyTAG - смотрите справку в скрипте установки!... "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_easytag  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_easytag" =~ [^10] ]]
do
    :
done
if [[ $in_easytag == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_easytag == 1 ]]; then
  echo ""
  echo " Установка EasyTAG "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
############ easytag ##############
sudo pacman -S --noconfirm --needed easytag  # Простое приложение для просмотра и редактирования тегов в аудиофайлах ; https://wiki.gnome.org/Apps/EasyTAG ; https://archlinux.org/packages/extra/x86_64/easytag/ ; 2025-08-04 17:14 UTC
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ######################
### Для настройки EasyTAG выполните следующие действия:
### Во вкладке «Настройки тегов ID3» установите следующие значения:
### в подразделе «ID3v2 tags» поставьте галочку «Записывать тег ID3v2» и в «Charset» выберите значение «UTF8»;
### в подразделе «ID3v1 tags» поставьте галочку «Записывать тег ID3v1.х» и в «Charset» выберите значение «Кириллица (Windows 1251)»;
### в подразделе «Character Set for reading ID3t tags» поставьте галочку и выберите в выпадающем меню «Кириллица (Windows 1251)».
### В левом части экрана «Дерево» выберите директорию с музыкой. Начнётся сканирование, подождите его окончание.
### Нажмите 2 кнопки: выделите все файлы и сохраните их.
### После этого останется только обновить базу музыкальных файлов в аудиопроигрывателе.
### Скрипты предназначены для запуска через терминал, для их выполнения необходимо открыть терминал Ctrl+Alt+T, перейти в каталог с музыкой:
### cd ~/Музыка
### и выполните одну из приведенных ниже команд:
### find -iname '*.mp3' -print0 | xargs -0 mid3iconv -eCP1251 --remove-v1
### (https://help.ubuntu.ru/wiki/%D0%BA%D0%BE%D0%B4%D0%B8%D1%80%D0%BE%D0%B2%D0%BA%D0%B0_%D1%82%D0%B5%D0%B3%D0%BE%D0%B2_%D0%B0%D1%83%D0%B4%D0%B8%D0%BE%D1%84%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2)
### https://translated.turbopages.org/proxy_u/en-ru.ru.110c15a9-6689c9d7-2f815890-74722d776562/https/www.tutorialspoint.com/easytag-a-tool-for-viewing-and-editing-tags-in-audio-and-video-files
############################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Kid3 - (для просмотра и редактирования тегов в аудиофайлах)?"
echo -e "${MAGENTA}:: ${BOLD}Kid3 - это бесплатная с открытым исходным кодом, программа для массового (пакетного и ручного) редактирования тегов у аудио-файлов в автоматическом режиме. Kid3 поддерживает множество аудио-форматов (MP3, Ogg, FLAC, WMA, WAV и другие). ${NC}"
echo " Домашняя страница: https://kid3.kde.org/ ; (https://archlinux.org/packages/extra/x86_64/kid3/ ; https://archlinux.org/packages/extra/x86_64/kid3-common/ ; https://archlinux.org/packages/extra/x86_64/kid3-qt/). "
echo -e "${MAGENTA}:: ${BOLD}Описание: Редактирование тегов ID3v1.1; Отредактируйте все кадры ID3v2.3 и ID3v2.4; Преобразование между тегами ID3v1.1, ID3v2.3 и ID3v2.4; Есть возможность редактирования тегов в форматах: MP3, Ogg/Vorbis, DSF, FLAC, MPC, MP4 / AAC, MP2, Opus, Speex, TrueAudio, WavPack, WMA, WAV, AIFF и модулях трекера (MOD, S3M, IT, XM); Имеется возможность массового редактирования тегов, например: художник, альбом, год и жанр всех файлов альбома, как правило, имеют одинаковые значения и могут быть установлены вместе; Есть возможность создания: тегов из имён файлов, тегов из содержимого полей тегов, имён файлов из тегов; Переименование и создание каталогов из тегов; Создание плейлистов (списков воспроизведения); Автоматическое преобразование верхнего и нижнего регистра и замена строк; Импорт информации об альбоме из gnudb.org, TrackType.org, MusicBrainz, Discogs, Amazon и других источников; Экспорт тегов в CSV, HTML, плейлисты, Kover XML и в другие форматы; Редактирование синхронизированных текстов песен и кодов синхронизации событий, импорт и экспорт файлов LRC; Автоматизация задач с помощью QML/JavaScript, D-Bus или интерфейса командной строки. Простой и понятный интерфейс с поддержкой русского языка.${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить Kid3 (KDE),   2 - *Да установить Kid3 (Qt) (без KDE зависимостей),

    3 - Да установить Kid3 (CLI) (без графического интерфейса),   0 - НЕТ - Пропустить установку: " in_kid3  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_kid3" =~ [^1230] ]]
do
    :
done
if [[ $in_kid3 == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_kid3 == 1 ]]; then
  echo ""
  echo " Установка Kid3 (KDE) "
sudo pacman -S --noconfirm --needed kid3  # Редактор тегов MP3, Ogg/Vorbis и FLAC, версия KDE ; https://kid3.kde.org/ ; https://archlinux.org/packages/extra/x86_64/kid3/
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_kid3 == 2 ]]; then
  echo ""
  echo " Установка Kid3 (Qt) (без KDE зависимостей) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed kid3-qt  # Редактор тегов MP3, Ogg/Vorbis и FLAC, версия Qt ; https://kid3.kde.org/ ; https://archlinux.org/packages/extra/x86_64/kid3-qt/
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_kid3 == 3 ]]; then
  echo ""
  echo " Установка Kid3 (CLI) (без графического интерфейса) "
sudo pacman -S --noconfirm --needed kid3-common  # Редактор тегов MP3, Ogg/Vorbis и FLAC, CLI-версия и общие файлы ; https://kid3.kde.org/ ; https://archlinux.org/packages/extra/x86_64/kid3-common/ (без графического интерфейса, работающую из командной строки)
echo " Установка утилит (пакетов) выполнена "
fi
#############

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить MP3Unicode (mp3unicode) - Утилита командной строки для преобразования тегов ID3 ​​в файлах mp3?"
echo -e "${MAGENTA}:: ${BOLD}MP3Unicode — это утилита командной строки для преобразования тегов ID3 ​​в файлах mp3 между различными кодировками. ${NC}"
echo " Домашняя страница: http://mp3unicode.sourceforge.net ; (https://taglib.github.io/ ; https://archlinux.org/packages/extra/x86_64/mp3unicode/). "
echo -e "${MAGENTA}:: ${BOLD}MP3Unicode прочитает тег id3v2 (или тег id3v1, если id3v2 отсутствует) из файла, преобразует
текстовые поля в теге из в Unicode и запишет тег id3v2 обратно, удаление тега id3v1. ${NC}"
echo " Например: mp3unicode --source-encoding CP1255 --id3v1-encoding none --id3v2-encoding файл unicode.mp3 "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_mp3unicode  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_mp3unicode" =~ [^10] ]]
do
    :
done
if [[ $in_mp3unicode == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_mp3unicode == 1 ]]; then
  echo ""
  echo " Установка MP3Unicode (mp3unicode) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed taglib  # Библиотека для чтения и редактирования метаданных нескольких популярных аудиоформатов ; https://taglib.github.io/ ; https://archlinux.org/packages/extra/x86_64/taglib/ ; 24 августа 2024 г., 9:03 UTC
sudo pacman -S --noconfirm --needed mp3unicode  # Утилита командной строки для преобразования тегов ID3 ​​в файлах mp3 между различными кодировками ; https://github.com/alonbl/mp3unicode ; http://mp3unicode.sourceforge.net/) ; https://archlinux.org/packages/extra/x86_64/mp3unicode/ ; 29 января 2024 г., 14:50 UTC
# Страница руководства - https://mp3unicode.sourceforge.net/manpage.html
####### Команда ###################
# mp3unicode --source-encoding cp1251 --id3v1-encoding none --id3v2-encoding unicode *.mp3
######### ПРИМЕР: #######
# mp3unicode --source-encoding cp1251 --id3v1-encoding none --id3v2-encoding unicode file.mp3
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
###########

clear
echo -e "${MAGENTA}
  <<< Установка утилит для Редактирования файлов субтитров в Archlinux >>> ${NC}"
# Installing utilities for Editing subtitle files in Archlinux
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Aegisub — Редактор текстовых файлов субтитров (Расширенный редактор субтитров)?"
echo " Aegisub — это бесплатный кроссплатформенный инструмент с открытым исходным кодом для создания и изменения субтитров. Aegisub позволяет быстро и легко синхронизировать субтитры со звуком и имеет множество мощных инструментов для их стилизации, включая встроенный предварительный просмотр видео в реальном времени. Лицензии с открытым исходным кодом в стиле BSD. "
echo " Первоначально созданный как инструмент для упрощения процесса набора текста, особенно в аниме-фэнсабах, Aegisub превратился в полноценный, гибко настраиваемый редактор субтитров. Он включает в себя множество удобных инструментов, которые помогут вам с хронометражем, набором текста, редактированием и переводом субтитров, а также мощную среду для написания скриптов под названием Automation (первоначально предназначенную в основном для создания эффектов караоке, теперь Automation можно использовать и для других целей, включая создание макросов и различных других удобных инструментов). "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " i_aegisub  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_aegisub" =~ [^10] ]]
do
    :
done
if [[ $i_aegisub == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_aegisub == 1 ]]; then
  echo ""
  echo " Установка Aegisub — Универсальный редактор субтитров "
sudo pacman -S --noconfirm --needed aegisub  # Универсальный редактор субтитров с поддержкой ASS/SSA ; http://www.aegisub.org/ ; https://archlinux.org/packages/extra/x86_64/aegisub/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Subtitle Editor — Редактор субтитров?"
echo " Subtitle Editor — это инструмент GTK+3 для редактирования субтитров для GNU/Linux/*BSD. Его можно использовать для новых субтитров или как инструмент для преобразования, редактирования, исправления и улучшения существующих субтитров. Эта программа также показывает звуковые волны, что упрощает синхронизацию субтитров с голосами. Subtitle Editor — это бесплатное программное обеспечение, распространяемое по лицензии GNU General Public License (GPL3)."
echo " Функции: Действительно прост в использовании; Интерфейс с несколькими документами; Отменить/Повторить; Поддержка интернационализации; Перетаскивание; Видеоплеер, интегрированный в главное окно (на основе GStreamer); Возможность предварительного просмотра с помощью внешнего видеоплеера (используя MPlayer или другой); Может использоваться для хронометража ; Генерация и отображение формы волны; Генерация и отображение ключевых кадров; Может использоваться для перевода; Показывает субтитры поверх видео; Редактирование; Редактор стиля; Проверка орфографии; Исправление текста (пробелы вокруг знаков препинания, заглавные буквы, пустой подзаголовок…); Проверка ошибок (перекрытие, слишком короткая или длинная продолжительность…); Преобразование частоты кадров; Редактировать время и кадры; Масштаб субтитров; Раздельные или объединенные субтитры; Разделенные или объединенные документы; Отредактируйте текст и настройте время (начало, конец); Переместить субтитры; Найти и заменить (поддержка регулярных выражений); Сортировать субтитры; Эффект пишущей машинки; Множество инструментов для хронометража и редактирования. "
echo " Поддерживаемые форматы: Adobe Encore DVD; Расширенная подстанция Альфа; Встроенный тайм-код (BITC); МикроDVD; МПЛ2; MPsub (субтитры MPlayer); СБВ; SubRip; Подстанция Альфа; SubViewer 2.0; Формат синхронизированного создания текста (TTAF); Обычный текст. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " i_subtitleeditor  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_subtitleeditor" =~ [^10] ]]
do
    :
done
if [[ $i_subtitleeditor == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_subtitleeditor == 1 ]]; then
  echo ""
  echo " Установка Subtitle Editor — Инструмент GTK+3 для редактирования субтитров "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
############# Зависимости #################
yay -S gstreamermm --noconfirm  # Интерфейс C++ для GStreamer ; https://aur.archlinux.org/packages/gstreamermm ; https://aur.archlinux.org/gstreamermm.git (только для чтения, нажмите, чтобы скопировать) ; https://gstreamer.freedesktop.org/bindings/cplusplus.html ; https://ftp.gnome.org/pub/GNOME/sources/gstreamermm/1.10/gstreamermm-1.10.0.tar.xz ; 2024-09-09 16:59 (UTC)
# git clone https://aur.archlinux.org/gstreamermm.git  # (только для чтения, нажмите, чтобы скопировать)
# cd gstreamermm
# makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gstreamermm
# rm -Rf gstreamermm
################ Справка по установке ###################
# Чтобы это установить, мне пришлось настроить PKGBUILD:
#prepare() {
#cd $pkgbase-$pkgver
# Fix the formatting error in configure.ac
#sed -i '/enable_unittests=\$have_gtest)/ { s/enable_unittests=\$have_gtest)/enable_unittests=\$have_gtest])/; n; s/^\s*])$/)/; }' configure.ac
# Fix gstreamer/gstreamermm/register.h
# Due to changes in glib's atomic API and how it interacts with C++ compilers
# especially since recent versions of glib (and gcc or clang) are stricter
# about the use of volatile types with atomic functions.
#sed -i 's/static volatile gsize/static gsize/' gstreamer/gstreamermm/register.h
#NOCONFIGURE=1 ./autogen.sh
#}
#########################
yay -S gstreamermm-docs --noconfirm  # Интерфейс C++ для GStreamer (документация) ; https://aur.archlinux.org/packages/gstreamermm-docs ; https://gstreamer.freedesktop.org/bindings/cplusplus.html ; https://ftp.gnome.org/pub/GNOME/sources/gstreamermm/1.10/gstreamermm-1.10.0.tar.xz ; 2024-09-09 16:59 (UTC)
# git clone https://aur.archlinux.org/gstreamermm.git  # (только для чтения, нажмите, чтобы скопировать)
# cd gstreamermm-docs
# makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gstreamermm-docs
# rm -Rf gstreamermm-docs
################ Справка по установке ###################
# Чтобы это установить, мне пришлось настроить PKGBUILD:
#prepare() {
#cd $pkgbase-$pkgver
# Fix the formatting error in configure.ac
#sed -i '/enable_unittests=\$have_gtest)/ { s/enable_unittests=\$have_gtest)/enable_unittests=\$have_gtest])/; n; s/^\s*])$/)/; }' configure.ac
# Fix gstreamer/gstreamermm/register.h
# Due to changes in glib's atomic API and how it interacts with C++ compilers
# especially since recent versions of glib (and gcc or clang) are stricter
# about the use of volatile types with atomic functions.
#sed -i 's/static volatile gsize/static gsize/' gstreamer/gstreamermm/register.h
#NOCONFIGURE=1 ./autogen.sh
#}
#########################
########### subtitleeditor ################
yay -S subtitleeditor --noconfirm  # Инструмент GTK+3 для редактирования субтитров для GNU/Linux/*BSD ; https://aur.archlinux.org/packages/subtitleeditor ; https://aur.archlinux.org/subtitleeditor.git (только для чтения, нажмите, чтобы скопировать) ; https://kitone.github.io/subtitleeditor/ ; https://github.com/kitone/subtitleeditor/releases/download/0.54.0/subtitleeditor-0.54.0.tar.gz ; 2024-09-08 16:50 (UTC)
# git clone https://aur.archlinux.org/subtitleeditor.git  # (только для чтения, нажмите, чтобы скопировать)
# cd subtitleeditor
# makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf subtitleeditor
# rm -Rf subtitleeditor
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Gaupol — Редактор текстовых файлов субтитров?"
echo " Gaupol — редактор текстовых файлов субтитров. Он помогает вам с такими задачами, как создание и перевод субтитров, синхронизация субтитров для соответствия видео и исправление распространенных ошибок. Gaupol включает встроенный видеоплеер, а также поддерживает запуск внешнего. Gaupol доступен для Linux, выпущен как свободное программное обеспечение под лицензией GNU General Public License (GPL). "
echo " Интерфейс приложения не богат на настройки, но можно установить ширину и высоту главного окна по желаемому размеру, что позволит легко разместить приложение рядом с видеопроигрывателем или любым другим полезным инструментом. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " i_gaupol  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_gaupol" =~ [^10] ]]
do
    :
done
if [[ $i_gaupol == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_gaupol == 1 ]]; then
  echo ""
  echo " Установка Gaupol — Редактор текстовых файлов субтитров "
sudo pacman -S --noconfirm --needed gaupol  # Редактор текстовых субтитров https://archlinux.org/packages/extra/any/gaupol/ ; https://otsaloma.io/gaupol/ ; https://github.com/otsaloma/gaupol/tree/master/doc
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############ Справка ##################
# Редактор текстовых файлов субтитров, который поддерживает несколько форматов файлов субтитров и предоставляет средства для создания, редактирования и перевода субтитров и времени субтитров для соответствия видео.
# Gaupol — редактор текстовых файлов субтитров. Он помогает вам с такими задачами, как создание и перевод субтитров, синхронизация субтитров для соответствия видео и исправление распространенных ошибок. Gaupol включает встроенный видеоплеер, а также поддерживает запуск внешнего. Gaupol доступен для Linux, выпущен как свободное программное обеспечение под лицензией GNU General Public License (GPL).
# Интерфейс приложения не богат на настройки, но можно установить ширину и высоту главного окна по желаемому размеру, что позволит легко разместить приложение рядом с видеопроигрывателем или любым другим полезным инструментом.
# Приложение позволяет открывать более одного файла субтитров благодаря интерфейсу с вкладками.
# Во время работы над проектами субтитров можно использовать свой собственный видеоплеер во время перевода или синхронизации.
##########################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить QNapi — для автоматического получения субтитров для заданного файла фильма?"
echo " QNapi — это бесплатное программное обеспечение для автоматического получения субтитров для заданного файла фильма. Оно использует онлайн-базы данных, такие как NapiProjekt, OpenSubtitles и Napisy24. Оно основано на библиотеке Qt5, поэтому его можно запустить на любой поддерживаемой операционной системе, включая Windows, OSX и Linux. https://github.com/QNapi/qnapi. "
echo " QNapi — работает в двух режимах: GUI и CLI. Вы можете загрузить субтитры, просто указав пути к файлам фильмов в качестве аргументов программы, или использовать графический интерфейс и выполнить такое действие там. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " i_qnapi  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_qnapi" =~ [^10] ]]
do
    :
done
if [[ $i_qnapi == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_qnapi == 1 ]]; then
  echo ""
  echo " Установка QNapi — для автоматического получения субтитров для заданного файла фильма "
sudo pacman -S --noconfirm --needed qnapi  # Инструмент для загрузки субтитров к фильмам
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############ Справка ##################
# Qt-клиент для загрузки субтитров к фильмам из NapiProjekt, OpenSubtitles, Napisy24
# QNapi — это бесплатное программное обеспечение для автоматического получения субтитров для заданного файла фильма. Оно использует онлайн-базы данных, такие как NapiProjekt, OpenSubtitles и Napisy24. Оно основано на библиотеке Qt5, поэтому его можно запустить на любой поддерживаемой операционной системе, включая Windows, OSX и Linux. https://github.com/QNapi/qnapi
# QNapi распространяется в соответствии с лицензией GNU General Public License v2 или более поздней версии.
# qnapi — это программное обеспечение для автоматической загрузки и сопоставления субтитров для файлов фильмов. Оно может использовать такие сервисы, как napiprojekt.pl, napisy24.pl и opensubtitles.com.
# qnapi работает в двух режимах: GUI и CLI. Вы можете загрузить субтитры, просто указав пути к файлам фильмов в качестве аргументов программы, или использовать графический интерфейс и выполнить такое действие там.
# АРГУМЕНТЫ:
# -c, --console Загрузить субтитры с помощью консоли
# -q, --quiet Загрузить субтитры тихо, без отображения
# сообщений или окон (подразумевается -d)
# -s, --show-list Показать список субтитров (работает только с -c)
# -d, --dont-show-list Не показывать список субтитров
# (работает только с -c)
# -l, --lang [код] Предпочтительный язык субтитров
# -lb,--lang-backup [код] Альтернативный язык субтитров
# -f, --format [формат] Выбор формата целевого файла субтитров
# (mDVD,MPL2,SRT,TMP)
# -e, --extension [расш.] Выбор расширения целевого файла субтитров
# -o, --options Показать параметры программы (только GUI)
# -h, --help Показать текст справки
# -hl,--help-languages ​​Список доступных языков субтитров
##########################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Subdl — Инструмент командной строки для загрузки субтитров с opensubtitles.org?"
echo " Subdl — это инструмент командной строки для загрузки субтитров с opensubtitles.org (поддерживает только поиск на основе хеша). Subdl — это бесплатное программное обеспечение, распространяемое по лицензии GNU General Public License (GPL3). subdl написан на Python. Официальная поддержка subdl, похоже, прекращена. Этот сайт (https://github.com/alexanderwink/subdl) предназначен для будущего использования subdl с поддержкой, управляемой сообществом. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " i_subdl  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_subdl" =~ [^10] ]]
do
    :
done
if [[ $i_subdl == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_subdl == 1 ]]; then
  echo ""
  echo " Установка Subdl — Инструмент командной строки для загрузки субтитров "
sudo pacman -S --noconfirm --needed subdl  # Инструмент командной строки для загрузки субтитров с opensubtitles.org ; https://github.com/alexanderwink/subdl ; https://archlinux.org/packages/extra/any/subdl/ ; https://subdl.com/
# subdl -h
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############

clear
echo -e "${CYAN}
  <<< Установка утилит для копирования и записи аудио и данных на CD-R/CD-RW на CD-R/CD-RW в системе Arch Linux >>> ${NC}"
# Installing utilities for copying and burning audio and data to CD-R/CD-RW to CD-R/CD-RW in the ArchLinux system
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Sound Juicer - (для копирования компакт-дисков)?"
echo -e "${MAGENTA}:: ${BOLD}Sound Juicer (CD-риппер)- это официальная программа для записи компакт-дисков GNOME. Она основана на GTK, GStreamer и libburnia для чтения и записи оптических дисков. Он может извлекать звуковые дорожки с оптических аудиодисков и преобразовывать их в аудиофайлы, которые могут воспроизводиться персональным компьютером или цифровым аудиоплеером. ${NC}"
echo " Sound Juicer - поддерживает копирование в любой аудиокодек , поддерживаемый плагином GStreamer , например Opus , MP3 , Ogg Vorbis , FLAC и несжатые форматы PCM . Версии после 2.12 реализуют возможность воспроизведения компакт-дисков. Последние версии создают форматы с потерями с настройками GStreamer по умолчанию. "
echo " Домашняя страница: https://wiki.gnome.org/Apps/SoundJuicer ; (https://archlinux.org/packages/extra/x86_64/sound-juicer/). "
echo -e "${MAGENTA}:: ${BOLD}Sound Juicer разработан так, чтобы быть простым в использовании и работать с минимальным вмешательством пользователя. Например, если компьютер подключен к Интернету , он автоматически попытается получить информацию о треках из свободно доступного сервиса MusicBrainz. Sound Juicer является бесплатным программным обеспечением с открытым исходным кодом в соответствии с условиями GNU GPL. Начиная с версии 2.10 он является официальной частью GNOME. ${NC}"
echo " Особенности программы: Чтобы скопировать CD с помощью Sound Juicer, просто вставьте аудио CD; Sound Juicer должен запуститься автоматически. В качестве альтернативы вы можете выбрать Sound Juicer из Приложения --> Звук и видео --> Audio CD Extractor. По умолчанию CD будет закодирован в Ogg Формат Vorbis, свободный формат. Если вы хотите скопировать CD в несвободный формат, такой как MP3 или AAC, вам потребуется установить дополнительное программное обеспечение. "
echo " Прочитайте пользовательскую документацию в автономном режиме, выбрав «Справка» в меню приложения. Меню позволяют получить доступ к функциям, недоступным через параметры командной строки. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_soundjuicer  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_soundjuicer" =~ [^10] ]]
do
    :
done
if [[ $in_soundjuicer == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_soundjuicer == 1 ]]; then
  echo ""
  echo " Установка Sound Juicer "
sudo pacman -S --noconfirm --needed sound-juicer  # Удобный и простой в использовании экстрактор аудио-CD для GNOME ; https://wiki.gnome.org/Apps/SoundJuicer ; https://archlinux.org/packages/extra/x86_64/sound-juicer/
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Mp3Splt-project - (для для разделения аудиофайлов)?"
echo -e "${MAGENTA}:: ${BOLD}Mp3Splt-project (Mp3splt-gtk) - это бесплатная кроссплатформенная утилита для разделения аудиофайлов mp3, ogg vorbis и FLAC, выбирая начальную и конечную временную позицию без декодирования. Очень полезно для разделения больших файлов mp3/ogg vorbis/FLAC для создания меньших файлов или для разделения целых альбомов для получения оригинальных треков. ${NC}"
echo " Если вы хотите разделить альбом, вы можете вручную выбрать точки разделения и имена файлов или получить их автоматически из CDDB (интернет или локальный файл) или из файлов .cue. Поддерживает также автоматическое разделение тишины, которое можно использовать также для настройки точек разделения cddb/cue. Также доступна обрезка с использованием обнаружения тишины. Вы можете извлекать треки из файлов Mp3Wrap или AlbumWrap за несколько секунд. Для файлов mp3 поддерживаются теги ID3v1 и ID3v2. "
echo " Домашняя страница: http://mp3splt.sourceforge.net/ ; (https://archlinux.org/packages/extra/x86_64/mp3splt-gtk/). "
echo -e "${MAGENTA}:: ${BOLD}Mp3splt-project разделен на 3 части: libmp3splt, mp3splt и mp3splt-gtk. Более подробную информацию смотрите: https://mp3splt.sourceforge.net/mp3splt_page/about.php . ${NC}"
echo " Особенности программы: Libmp3splt — это библиотека, созданная на основе mp3splt версии 2.1c. Libmp3splt не является потокобезопасной. Mp3splt — это программа командной строки из проекта mp3splt. Общие характеристики mp3splt: разделение файлов mp3, ogg vorbis и FLAC от начального времени до конечного без декодирования; рекурсивное разделение нескольких файлов; Поддержка тегов ID3v1 и ID3v2 для файлов mp3 (используя libid3tag), поддержка комментариев vorbis; разделить альбом с помощью точек разделения с сервера freedb.org; разделить альбом с помощью локального файла .XMCD, .CDDB или .CUE; поддержка файлов меток audacity; разделение автоматически с обнаружением тишины; обрезка с использованием обнаружения тишины; разделен на фиксированный промежуток времени; разделены на равные по времени треки; разделенные файлы, созданные с помощью Mp3Wrap или AlbumWrap; разделить объединенные файлы mp3; поддержка mp3 VBR (переменный битрейт); указать выходной каталог для разделенных файлов. "
echo " Mp3splt-gtk — это графический интерфейс GTK3, использующий libmp3splt. Возможности mp3splt-gtk: интегрированный плеер с использованием gstreamer; поддержка Snackamp и Audacious Control; расширенная полоса прогресса масштабирования с амплитудной волной и точками разделения. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_mp3splt  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_mp3splt" =~ [^10] ]]
do
    :
done
if [[ $in_mp3splt == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_mp3splt == 1 ]]; then
  echo ""
  echo " Установка Mp3Splt-project "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed libid3tag  # Библиотека манипуляции тегами ID3 ; https://codeberg.org/tenacityteam/libid3tag ; https://archlinux.org/packages/extra/x86_64/libid3tag/
sudo pacman -S --noconfirm --needed libmad  # Высококачественный аудиодекодер MPEG ; https://www.underbit.com/products/mad/ ; https://archlinux.org/packages/extra/x86_64/libmad/
sudo pacman -S --noconfirm --needed libvorbis  # Референсная реализация аудиоформата Ogg Vorbis ; https://www.xiph.org/vorbis/ ; https://archlinux.org/packages/extra/x86_64/libvorbis/
sudo pacman -S --noconfirm --needed pcre  # Устаревшая библиотека, реализующая регулярные выражения в стиле Perl 5 ; https://www.pcre.org/ ; https://archlinux.org/packages/core/x86_64/pcre/
sudo pacman -S --noconfirm --needed libtool  # Универсальный скрипт поддержки библиотеки ; https://www.gnu.org/software/libtool ; https://archlinux.org/packages/core/x86_64/libtool/
############ libaudclient #############
yay -S libaudclient --noconfirm  # Устаревшая клиентская библиотека D-Bus для Audacious ; https://aur.archlinux.org/packages/libaudclient ; https://aur.archlinux.org/libaudclient.git (только для чтения, нажмите, чтобы скопировать) ; https://audacious-media-player.org/ ; https://distfiles.audacious-media-player.org/libaudclient-3.5-rc2.tar.bz2 ; 2025-02-27 14:21 (UTC)
#git clone https://aur.archlinux.org/libaudclient.git  # (только для чтения, нажмите, чтобы скопировать)
#cd libaudclient
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf libaudclient
#rm -Rf libaudclient
############ libmp3splt #############
yay -S libmp3splt --noconfirm  # Библиотека для разделения файлов mp3 и ogg без декодирования ; https://aur.archlinux.org/libmp3splt.git (только для чтения, нажмите, чтобы скопировать) http://mp3splt.sourceforge.net/ ; https://aur.archlinux.org/packages/libmp3splt ; 2025-05-18 11:54 (UTC)
#git clone https://aur.archlinux.org/libmp3splt.git  # (только для чтения, нажмите, чтобы скопировать)
#cd libmp3splt
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf libmp3splt
#rm -Rf libmp3splt
########### mp3splt ##############
yay -S mp3splt --noconfirm  # Инструмент командной строки для разделения файлов mp3 и ogg без декодирования ; https://aur.archlinux.org/mp3splt.git (только для чтения, нажмите, чтобы скопировать) ; http://mp3splt.sourceforge.net/ ; https://aur.archlinux.org/packages/mp3splt
#git clone https://aur.archlinux.org/mp3splt.git  # (только для чтения, нажмите, чтобы скопировать)
#cd mp3splt
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf mp3splt
#rm -Rf mp3splt
########## mp3splt-gtk ##############
yay -S mp3splt-gtk --noconfirm  # Разделение файлов mp3, ogg и flac без декодирования — GTK3 GUI ; https://aur.archlinux.org/packages/mp3splt-gtk ; https://aur.archlinux.org/mp3splt-gtk.git (только для чтения, нажмите, чтобы скопировать) ; https://mp3splt.sourceforge.net/ ; https://github.com/mp3splt/mp3splt/archive/4b48268258c478993bd43703c0cdb0962b79f85f.tar.gz ; 2025-06-03 18:18 (UTC)
#git clone https://aur.archlinux.org/mp3splt-gtk.git  # (только для чтения, нажмите, чтобы скопировать)
#cd mp3splt-gtk
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf mp3splt-gtk
#rm -Rf mp3splt-gtk
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Cdrdao (cdrdao) - Запись аудио и данных на CD-R/CD-RW?"
echo -e "${MAGENTA}:: ${BOLD}CDRDAO - Disk-At-Once запись аудио и данных на CD-R/CD-RW. Cdrdao записывает аудио или данные на CD-R в режиме disk-at-once (DAO) на основе текстового описания содержимого CD ( toc-файл https://cdrdao.sourceforge.net/example.html#toc-file-example). Преимущества записи Disk-At-Once (DAO): Запись в режиме disk-at-once записывает весь диск, т. е. лид-ин, одну или несколько дорожек и лид-аут, за один шаг. Обычно используемый режим track-at-once (TAO) записывает каждую дорожку независимо, что требует блоков ссылок между двумя дорожками. Старые модели CD-рекордеров принудительно делали двухсекундную паузу (предзазор) между двумя дорожками, тогда как новые модели позволяют регулировать длительность паузы в режиме TAO, сокращая количество блоков ссылок до минимального количества. Однако с TAO обычно невозможно определить данные, которые записываются в предзазоры. Но именно эта функция делает запись аудио CD интересной, например, путем создания скрытых бонусных дорожек или вступлений дорожек в предзазорах, как это обычно бывает на коммерческих CD. Наконец, запись DAO является единственным способом записи данных в неиспользуемые подканалы RW, например, для CD-G или CD-TEXT. ${NC}"
echo " Домашняя страница: https://cdrdao.sourceforge.net/ ; (https://archlinux.org/packages/extra/x86_64/cdrdao/ ; https://cdrdao.sourceforge.net/gcdmaster/). "
echo -e "${MAGENTA}:: ${BOLD}Также у программы Cdrdao - GCDMASTER (Gnome CD Master) — Графический интерфейс к cdrdao для создания аудио-CD (Простой и эффективный мастеринг компакт-дисков). Gnome CD Master — это графический интерфейс для создания аудиодисков и их записи с помощью cdrdao. Основная идея этого GUI заключается в поддержании непрерывного потока аудиоданных, который может состоять из нескольких аудиофайлов. В аудиопотоке можно использовать только части аудиофайлов, что является основной идеей для возможности неразрушающего вырезания. Например, если вы вырезаете несколько сэмплов в середине аудиофайла, результатом будет часть, которая начинается в начале аудиофайла и заканчивается в начале вырезанной области, и вторая часть, которая начинается в конце вырезанной области и доходит до конца аудиофайла. Конечно, все это скрыто графическим интерфейсом, и вы увидите только результат. ${NC}"
echo " Функции Cdrdao (cdrdao): Полный контроль над длиной и содержимым pre-gaps (областей пауз между треками). Pre-gaps могут быть полностью опущены, например, для разделения живых записей на треки. Контроль над данными подканалов, такими как: номер по каталогу; копирование, предыскажение, 2-/4-канальные флаги; Код ISRC; индексные знаки; Поддержка точного копирования аудио, данных и смешанного режима компакт-дисков. Поддержка записи подканала RW. Треки могут состоять из разных аудиофайлов, поддерживающих неразрушающую резку. Принимает аудиофайлы WAVE и необработанные аудиофайлы. Чтение и запись CD-TEXT с помощью приводов, которые поддерживают эту функцию. Доступ к CDDB для автоматического создания данных CD-TEXT. Поддержка копирования «на лету». Кроссплатформенный! "
echo " Функции Gnome CD Master: Простой в использовании графический интерфейс. Поддержка нескольких проектов. Воспроизведение образов аудио-CD. Легкий сброс компакт-дисков на диск. Копирование с CD на CD. Составление новых аудио компакт-дисков из wav-файлов. Графическая вставка меток дорожек (для разделения живых записей). Простая модификация CD-TEXT. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_cdrdao  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_cdrdao" =~ [^10] ]]
do
    :
done
if [[ $in_cdrdao == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_cdrdao == 1 ]]; then
  echo ""
  echo " Установка Cdrdao (cdrdao) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed cdrdao  # Записывает аудио / данные CD-R в режиме disk-at-once (DAO) ; http://cdrdao.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/cdrdao/ ; https://cdrdao.sourceforge.net/gcdmaster/ ; 12 июля 2024 г., 2:07 UTC
  echo ""
  echo " Установка GCDMASTER (Gnome CD Master) (gcdmaster) "
sudo pacman -S --noconfirm --needed gcdmaster  # Графический интерфейс к cdrdao для создания аудио-CD (Простой и эффективный мастеринг компакт-дисков) ; https://archlinux.org/packages/extra/x86_64/gcdmaster/ ; http://cdrdao.sourceforge.net/ ; 2024-08-25 07:01 UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить DVDStyler (для создания DVD-дисков)?"
echo -e "${MAGENTA}:: ${BOLD}DVDStyler — это кроссплатформенное бесплатное приложение для создания DVD-дисков профессионального качества. Оно позволяет не только записывать видеофайлы на DVD, которые можно воспроизводить практически на любом автономном DVD-плеере, но и создавать индивидуально оформленные меню DVD. Это программное обеспечение с открытым исходным кодом, которое полностью бесплатно. ${NC}"
echo " Функции: создавать и записывать видео на DVD с интерактивными меню; создайте собственное меню DVD или выберите одно из готовых шаблонов меню; создать слайд-шоу из фотографий; добавить несколько субтитров и звуковых дорожек; поддержка AVI, MOV, MP4, MPEG, OGG, WMV и других форматов файлов (https://www.dvdstyler.org/components/content/81); поддержка MPEG-2, MPEG-4, DivX, Xvid, MP2, MP3, AC-3 и других аудио- и видеоформатов; поддержка многоядерного процессора; использовать файлы MPEG и VOB без перекодирования, см. FAQ (http://sourceforge.net/p/dvdstyler/wiki/FAQVob/); поместить файлы с разным аудио/видео форматом на один DVD (поддержка набора заголовков); удобный интерфейс с поддержкой перетаскивания; гибкое создание меню на основе масштабируемой векторной графики; импорт файла изображения для фона; размещайте кнопки, текст, изображения и другие графические объекты в любом месте экрана меню; изменить шрифт/цвет и другие параметры кнопок и графических объектов; масштабировать любую кнопку или графический объект; копировать любой объект меню или все меню; настройка навигации с помощью сценариев DVD; Более подробную информацию смотрите в разделе «Документы» (https://www.dvdstyler.org/en/documents). "
echo " Домашняя страница: https://www.dvdstyler.org/ ; https://www.dvdstyler.org/en/ ; https://archlinux.org/packages/extra/x86_64/dvdstyler/). "
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют функция пропуска установки уже установленных пакетов! ${NC}"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " i_dvdstyler  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_dvdstyler" =~ [^10] ]]
do
    :
done
if [[ $i_dvdstyler == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_dvdstyler == 1 ]]; then
  echo ""
  echo " Установка DVDStyler "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed cdrtools  # Портативное программное обеспечение командной строки для записи CD/DVD/BluRay ; https://sourceforge.net/projects/cdrtools/ ; https://archlinux.org/packages/extra/x86_64/cdrtools/
sudo pacman -S --noconfirm --needed dvd+rw-tools  # инструменты для записи DVD ; http://fy.chalmers.se/~appro/linux/DVD+RW ; https://archlinux.org/packages/extra/x86_64/dvd+rw-tools/
sudo pacman -S --noconfirm --needed dvdauthor  # Инструменты для создания DVD ; http://dvdauthor.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/dvdauthor/
sudo pacman -S --noconfirm --needed ffmpeg4.4  # Комплексное решение для записи, конвертации и потоковой передачи аудио и видео ; https://ffmpeg.org/ ; https://archlinux.org/packages/extra/x86_64/ffmpeg4.4/
sudo pacman -S --noconfirm --needed wxsvg  # Библиотека C++ для создания, обработки и рендеринга SVG-файлов ; https://archlinux.org/packages/extra/x86_64/wxsvg/ ; http://wxsvg.sourceforge.net/ ; 2024-11-07 20:03 UTC
sudo pacman -S --noconfirm --needed dvdstyler  # Приложение для создания DVD-дисков профессионального качества ; https://www.dvdstyler.org/ ; https://archlinux.org/packages/extra/x86_64/dvdstyler/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##################

clear
echo -e "${MAGENTA}
  <<< Установка программ для обработки видео и аудио в Archlinux >>> ${NC}"
# Installing video and audio processing software in Archlinux
clear
echo ""
echo -e "${BLUE}:: ${NC}Установить OpenShot (нелинейный видеоредактор)?"
echo -e "${MAGENTA}:: ${BOLD}OpenShot - это свободный нелинейный видеоредактор, отмеченный наградами с открытым исходным кодом. Он конечно уступает Davinci resolve, но, для того что бы сделать видеомонтаж например для ютуб, его вполне хватит. ${NC}"
echo " OpenShot был разработан с помощью Python, GTK и MLT Framework. "
echo " Основные возможности программы: Программа использует библиотеку FFmpeg и поддерживает большое количество мультимедиа-форматов. Анимация по ключевым кадрам (Keyframe анимация). Интеграция с рабочим столом. Возможность перетаскивать файлы в окно программы из внешнего файлового менеджера. Неограниченное количество видео-дорожек (слоев). Поддержка операций масштабирования, обрезки, вращения и других. Поддержка ускорения, замедления видео. Более 400 эффектов переходов. Более 40 шаблонов для создания надписей (заголовков). Трехмерные анимированные заголовки. Видео-эффекты. Яркость, насыщенность, хромакей и много других. Возможность покадровой навигации по видео. Поддержка и редактирование аудио. Отоборажение формы аудио-дорожки (waveform, форма волны). Возможность отсоединить аудио-дорожку от видео. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " i_openshot  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_openshot" =~ [^10] ]]
do
    :
done
if [[ $i_openshot == 0 ]]; then
  echo ""
  echo " Установка утилит (пакетов) пропущена "
elif [[ $i_openshot == 1 ]]; then
  echo ""
  echo " Установка OpenShot (нелинейный видеоредактор) "
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
  sudo pacman -S --noconfirm --needed frei0r-plugins  # Коллекция плагинов видеоэффектов, которые можно использовать с различным программным обеспечением для редактирования и обработки видео ; https://frei0r.dyne.org/ ; https://archlinux.org/packages/extra/x86_64/frei0r-plugins/ ; 2025-07-02 16:42 UTC
  sudo pacman -S --noconfirm --needed libopenshot-audio-docs  # Высококачественная библиотека редактирования и воспроизведения аудио, используемая libopenshot. - документация ; https://archlinux.org/packages/extra/x86_64/libopenshot-audio-docs/ ; https://github.com/openshot/libopenshot-audio ; 2024-12-25 09:16 UTC
  sudo pacman -S --noconfirm --needed libopenshot-audio  # Высококачественная библиотека редактирования и воспроизведения аудио, используемая libopenshot ; https://archlinux.org/packages/extra/x86_64/libopenshot-audio/ ; https://github.com/openshot/libopenshot-audio ; Обеспечивает: libopenshot-audio.so=10-64 ; 2024-12-25 09:16 UTC
  sudo pacman -S --noconfirm --needed libopenshot  # Редактирование видео, анимация и библиотека воспроизведения для C++, Python и Ruby ; https://archlinux.org/packages/extra/x86_64/libopenshot/ ; https://github.com/openshot/libopenshot ; Обеспечивает: libopenshot.so=27-64 ; 2025-07-02 16:42 UTC
  sudo pacman -S --noconfirm --needed openshot  # Бесплатный видеоредактор с открытым исходным кодом, удостоенный наград ; https://www.openshot.org/ ; https://archlinux.org/packages/extra/any/openshot/ ; 2024-12-25 09:15 UTC
  echo ""
  echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить HandBrake (Многопоточный видео транскодер)?"
echo -e "${MAGENTA}:: ${BOLD}HandBrake — это инструмент с открытым исходным кодом, созданный добровольцами для конвертации видео практически из любого формата в ряд современных, широко поддерживаемых кодеков. ${NC}"
echo " Причины, по которым вам понравится HandBrake: Конвертируйте видео практически из любого формата; Бесплатно и с открытым исходным кодом; Мультиплатформенность (Windows, Mac и Linux)... "
echo " Начните работу с HandBrake за считанные секунды, выбрав профиль, оптимизированный для вашего устройства, или выберите универсальный профиль для стандартных или высококачественных преобразований... "
echo " HandBrake — программа, предназначенная для конвертирования файлов из большинства видео форматов в MP4 (M4V), MKV и WebM. Поддерживает применение фильтров, работу с файлами субтитров, редактирование тегов. Работа с программой HandBrake строится следующим образом. Пользователь выбирает файл источник (Source), указывает параметры конвертирования видео (видео, аудио, субтитры) и запускает процесс конвертации. Файлы можно поместить в очередь (Queue). В программе доступны предустановленные настройки для iPod, iPhone, iPad и других устройств. "
echo " Возможности: Готовые пресеты для конвертации видео в различные форматы и под различные устройства. Поддержка различных источников видео: обычные мультимедиа файлы, DVD- и BluRay-образы (без защиты от копирования). Выходные форматы: MP4 (.M4V), MKV, WebM. Кодировщики видео: AV1, H.265, H.264, MPEG-4, MPEG-2, VP8, VP9. Поддержка аппаратного ускорения. Кодировщики аудио: AAC / HE-AAC, MP3, FLAC, AC3, E-AC3, Opus, Vorbis. Audio Pass-Through: AC-3, E-AC3, FLAC, DTS, DTS-HD, TrueHD, AAC, Opus, MP3, MP2. Поддержка работы с файлами субтитров (VobSub, Closed Captions CEA-608, SSA, SRT). Применение фильтров к видео. Поддержка VFR (Variable Frame Rate) и CFR (Constant Frame Rate). Live-превью видео. Пакетная обработка и поддержка очереди файлов. Поддержка работы без графического интерфейса (через командную строку). И многое другое. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " i_handbrake  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_handbrake" =~ [^10] ]]
do
    :
done
if [[ $i_handbrake == 0 ]]; then
  echo ""
  echo " Установка утилит (пакетов) пропущена "
elif [[ $i_handbrake == 1 ]]; then
  echo ""
  echo " Установка HandBrake (Многопоточный видео транскодер) "
  sudo pacman -Syy  # обновление баз пакмэна (pacman)
  sudo pacman -S --noconfirm --needed handbrake-cli  # Многопоточный видеотранскодер (CLI) ; https://archlinux.org/packages/extra/x86_64/handbrake-cli/ ; https://handbrake.fr/ ; 2025-08-09 21:22 UTC
  sudo pacman -S --noconfirm --needed handbrake  # Многопоточный видео транскодер ; https://handbrake.fr/ ; https://archlinux.org/packages/extra/x86_64/handbrake/ ; 2025-08-09 21:22 UTC
  echo ""
  echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить MP4Joiner (MP4Splitter) (mp4joiner) — Набор графических инструментов для работы с файлами MP4?"
echo -e "${YELLOW}==> Примечание! ${BOLD}*MP4Tools это собрание простых бесплатных приложений для соединения и разрезания MP4 файлов. MP4Tools — это набор бесплатных, кроссплатформенных, графическихинструментов для работы с MP4-файлами. Он содержит следующие приложения: MP4Joiner  — бесплатное приложение, позволяющее объединять несколько файлов MP4 в один без перекодирования и потери качества. MP4Splitter — бесплатное приложение, позволяющее разделить файл MP4 на несколько файлов без перекодирования и потери качества. Это программное обеспечение с открытым исходным кодом, которое полностью бесплатно. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}MP4Joiner — маленькое C++ / wxWidgets графическое приложение позволяющее соединить несколько файлов формата MP4 в один. MP4Joiner - бесплатный софт, запустив который вы сможете объединить любое количество MP4 файлов между собой без необходимости их перекодировать, соответственно в качестве вы ничего не потеряете. Порядок соединения файлов зависит от расположения их в списке, соединяются файлы без перекодировки и потери качества. Поддержку формата MP4 (MPEG-4) обеспечивается мультимедийным фреймворком GPAC (Free Software multimedia framework). MP4Splitter - программа также не требует от вас денег и была создана для того, чтобы разделить MP4 файл на нужное вам количество частей, при этом перекодирование также не будет и в качестве также ничего не потеряете. Собственно это все, что вы получите, если вдруг стало интересно попробовать, то можете смело качать, Русская поддержка между прочим есть, но не думаю, что она тут реально нужна, ведь понятно и так. Этот проект Лицензируется под GPL. ${NC}"
echo " Домашняя страница: https://www.mp4joiner.org/ ; (https://sourceforge.net/projects/mp4joiner/ ; https://aur.archlinux.org/packages/mp4joiner). "
echo -e "${BLUE}:: ${NC}MP4Tools выделяется своей скоростью обработки файлов MP4, так как не требует повторного кодирования видео и аудиоданных при объединении или разделении. Это позволяет значительно сократить время обработки по сравнению с такими редакторами, как Adobe Premiere Pro, Final Cut Pro, Sony Vegas, и DaVinci Resolve. Объединение или разделение двух 1 Гб MP4 файлов в MP4Tools занимает всего несколько минут, в то время как в других редакторах это может занять часы. "
echo -e "${CYAN}:: ${NC}Специальный алгоритм MP4Tools позволяет работать с файлами без изменения их качества и без необходимости в мощном оборудовании. Это достигается путем добавления или удаления файловых заголовков, а также путем объединения или разделения видео- и аудиоданных без изменения их исходного качества. *Как объединять или разделять файлы MP4 без потери качества: Вот как использовать MP4Tools/MP4Joiner для объединения файлов MP4: Запустите инструмент MP4Joiner. Добавьте файлы MP4, которые вы хотите объединить. Нажмите кнопку "Объединить/Join". Звук должен быть абсолютно одинаковым, иначе файлы MP4 не склеятся. В остальном — очень хороший инструмент для склейки! *Вот как использовать MP4Tools/MP4Splitter для разделения файлов MP4: Запустите инструмент MP4Splitter. Добавьте файл MP4, который вы хотите разделить. Выберите, как вы хотите разделить файл. Вы можете разделить его по времени, по размеру или по количеству файлов. Нажмите кнопку "Разделить/Start splitting". "
echo -e "${CYAN}:: ${NC}Установка MP4Joiner (MP4Splitter) (mp4joiner) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/mp4joiner.git), (https://aur.archlinux.org/packages/mp4joiner) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_mp4joiner  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_mp4joiner" =~ [^10] ]]
do
    :
done
if [[ $in_mp4joiner == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_mp4joiner == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) MP4Joiner (MP4Splitter) (mp4joiner) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed gpac  # Мультимедийный фреймворк на основе стандарта MPEG-4 Systems (https://github.com/gpac/gpac) ; https://archlinux.org/packages/extra/x86_64/gpac/ ; https://gpac.wp.imt.fr/ ; Обеспечивает: libgpac.so=12-64 ; 2024-07-28 14:12 UTC
sudo pacman -S --noconfirm --needed wxsvg  # Библиотека C++ для создания, обработки и рендеринга SVG-файлов ; https://archlinux.org/packages/extra/x86_64/wxsvg/ ; http://wxsvg.sourceforge.net/ ; https://sourceforge.net/projects/mp4joiner/postdownload ; 2024-11-07 20:03 UTC
############# mp4joiner ##########
yay -S mp4joiner --noconfirm  # Коллекция инструментов для работы с файлами MP4 ; https://aur.archlinux.org/packages/mp4joiner ; https://aur.archlinux.org/mp4joiner.git (только для чтения, нажмите, чтобы скопировать) ; https://www.mp4joiner.org/ ; 2023-04-12 09:26 (UTC)
############# mp4joiner ##########
#git clone https://aur.archlinux.org/mp4joiner.git  # (только для чтения, нажмите, чтобы скопировать)
#cd mp4joiner
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf mp4joiner
#rm -Rf mp4joiner
  echo ""
  echo " Посмотрите информацию о версии (psensor) "
sudo pacman -Q mp4joiner  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# Сделать:
# mp4joiner.desktop
# mp4splitter.desktop
# https://aur.archlinux.org/cgit/aur.git/tree/mp4joiner.desktop?h=mp4joiner
# https://aur.archlinux.org/cgit/aur.git/tree/mp4splitter.desktop?h=mp4joiner
####################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Kdenlive (для редактирования видео)?"
echo -e "${MAGENTA}:: ${BOLD}Kdenlive - это приложение для редактирования видео с поддержкой множества аудио- и видеоформатов. Оно предлагает расширенные функции редактирования, множество эффектов и переходов, цветокоррекцию, инструменты для постобработки аудио и субтитров. Кроме того, оно обеспечивает гибкость для рендеринга практически в любой формат по вашему выбору. ${NC}"
echo " Функции: Вложенные последовательности ; Настраиваемый интерфейс и сочетания клавиш ; Индикаторы: гистограмма, вектороскоп, RGB-парад, осциллограф и аудиометр ; Редактирование прокси ; Бесплатные онлайн-ресурсы и шаблоны ; Отслеживание движения ; Инструменты на базе искусственного интеллекта (https://apps.kde.org/ru/kdenlive/ ; https://github.com/KDE/kdenlive). "
echo " Kdenlive — с открытым исходным кодом, основанное на MLT Framework и KDE Frameworks 6. Оно распространяется в соответствии с лицензией GNU General Public License версии 3 или любой более поздней версии, принятой проектом KDE. "
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют функция пропуска установки уже установленных пакетов! ${NC}"
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " i_kdenlive  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_kdenlive" =~ [^10] ]]
do
    :
done
if [[ $i_kdenlive == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_kdenlive == 1 ]]; then
  echo ""
  echo " Установка Kdenlive "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
  sudo pacman -S --noconfirm --needed frei0r-plugins  # Коллекция плагинов видеоэффектов, которые можно использовать с различным программным обеспечением для редактирования и обработки видео ; https://frei0r.dyne.org/ ; https://archlinux.org/packages/extra/x86_64/frei0r-plugins/ ; 2025-07-02 16:42 UTC
sudo pacman -S --noconfirm --needed kdenlive  # Нелинейный видеоредактор для Linux, использующий видеофреймворк MLT ; https://apps.kde.org/kdenlive/ ; https://archlinux.org/packages/extra/x86_64/kdenlive/ ; 2025-08-16 11:01 UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Shotcut (shotcut) - Видео-монтаж?"
echo -e "${MAGENTA}:: ${BOLD}Shotcut — бесплатная, кроссплатформенная программа для нелинейного видео-монтажа на базе Qt под Linux. Shotcut — это FOSS (Free and Open Source Software) инструмент для редактирования видео, который можно использовать в операционных системах Linux, macOS и Windows. Этот инструмент для редактирования видео поддерживает различные форматы файлов, а также может работать как портативное приложение с внешнего диска. Более того, он также позволяет вам захватывать экран или даже видео в реальном времени с помощью веб-камеры. ${NC}"
echo " Домашняя страница: https://www.shotcut.org/ ; (https://archlinux.org/packages/extra/x86_64/shotcut/). "
echo -e "${MAGENTA}:: ${BOLD}Программа обладает большим количеством возможностей и позволяет создавать видео-ролики различной степени сложности. Если сравнивать Shotcut с другими программами видео-монтажа под Linux, то Shotcut однозначно будет занимать верхние строчки по своим возможностям и удобству. Интерфейс Shotcut выполнен довольно удобно и функционально. Вы можете включать и отключать различные интерфейсные док-панели. В целом интерфейс похож на стиль программ видео-монтажа и не должен вызывать сложностей. Есть область просмотра, шкала времени (аудио и видео дорожки) и множество дополнительных подключаемых панелей (все панели можно включить через меню Вид). Через меню Настройки->Тема можно выбрать темную или светлую тему. ${NC}"
echo " Выборочно отметим: Программа поддерживает все основные форматы видео, аудио и файлов изображений (используются библиотеки FFmpeg). Поддерживается 4K видео. Раздельное редактирование аудио и видео дорожек. Различные инструменты для работы со звуковыми дорожками. Позволяет захватывать видео или звук с внешнего источника. Имеет встроенные генераторы шума, цвета и счетчиков. Имеет большой набор различных видео-фильтров, а также переходов. Поддерживается изменение скорости видео и аудио, авто-поворот, а также разворачивание (reverse). Поддерживается экспорт в различные видео-форматы, а также покадровый экспорт в виде файлов изображений. Работа с несколькими мониторами. И многое другое. Полный список возможностей программы можно посмотреть на официальном сайте (https://www.shotcut.org/). "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_shotcut  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_shotcut" =~ [^10] ]]
do
    :
done
if [[ $in_shotcut == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_shotcut == 1 ]]; then
  echo ""
  echo " Установка Shotcut (shotcut) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed bigsh0t  # Коллекция плагинов frei0r для VR-видео с поддержкой Shotcut ; https://bitbucket.org/leo_sutic/bigsh0t ; https://archlinux.org/packages/extra/x86_64/bigsh0t/ ; 16 апреля 2024 г., 17:49 UTC
sudo pacman -S --noconfirm --needed frei0r-plugins  # Коллекция плагинов видеоэффектов, которые можно использовать с различным программным обеспечением для редактирования и обработки видео ; https://frei0r.dyne.org/ ; https://archlinux.org/packages/extra/x86_64/frei0r-plugins/ ; 2025-07-02 16:42 UTC
sudo pacman -S --noconfirm --needed shotcut  # Кроссплатформенный видеоредактор на базе Qt ; https://www.shotcut.org/ ; https://archlinux.org/packages/extra/x86_64/shotcut/ ; 29 июня 2024 г., 10:00 UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
######### Справка ##############
# Системные требования для установки Shotcut:
# Оперативная память: не менее 4 ГБ для SD, 8 ГБ для HD и 16 ГБ для 4K
# Процессор: x86-64 Intel или AMD; как минимум одно ядро ​​2 ГГц для SD, 2 ядра для HD и 4 ядра для 4K
# Диск: Не менее 2 ГБ свободного места на диске, чем больше, тем лучше 🙂
# Графический процессор: графическая карта с поддержкой OpenGL 2.0 или выше.
# 64-битный Linux с glibc версии не ниже 2.13
# Mint 20+, Ubuntu/Pop!_OS 20.04+, Debian 11+, Fedora 32+, Manjaro 20.2+, MX Linux 21+, элементарная ОС 6+
###########################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Avidemux (avidemux) - Редактор и конвертер видео?"
echo -e "${MAGENTA}:: ${BOLD}Avidemux — бесплатный видеоредактор, разработанный для простых задач по резке, фильтрации и кодированию. Программа позволяет обрезать (вырезать) фрагменты видео, конвертировать видео, накладывать фильтры и т.д. Он поддерживает множество типов файлов, включая AVI, совместимые с DVD файлы MPEG, MP4 и ASF, используя различные кодеки. В программу включено большое количество видео-фильтров. Поддерживается множество видео и аудио форматов. Задачи можно автоматизировать с помощью проектов, очереди заданий и мощных возможностей скриптинга. ${NC}"
echo " Домашняя страница: http://fixounet.free.fr/avidemux/ ; (https://archlinux.org/packages/extra/x86_64/avidemux-cli/ ; https://archlinux.org/packages/extra/x86_64/avidemux-qt/). "
echo -e "${MAGENTA}:: ${BOLD}Шаги для достижения этого просты: Нажмите «Открыть видео» и выберите файл. Переместите маркер положения, где должен начинаться новый клип. Используйте кнопки A и B для установки начальной и конечной точек. Нажмите кнопку с изображением ножниц, чтобы разрезать клип. Повторите в других местах, выделите интересные разделы. Щелкните правой кнопкой мыши по нарезанным фрагментам и выберите «Копировать» > «Вставить» , чтобы переместить их на временную шкалу. Подталкивание клипов упорядочивает их последовательно! Предварительный просмотр обеспечивает плавные переходы между объединенными клипами. Если все устраивает, сохраните видео для экспорта! ${NC}"
echo " Особенности: Возможность резать по ключевым кадрам без перекодирования, что пока нет в других бесплатных утилитах. Поддержка нелинейного монтажа видео, визуальных эффектов, и транскодирования. Поддержка мультиплексирования (мультиплексирование) и демультиплексирование. Поддержка субтитров популярных форматов: SUB, SSA, ASS, SRT. Имеет мощные возможности создания сценариев. Множественные варианты фильтрации: автоматическое изменение размера, сглаживание, деинтерлейсинг, сдвиги цветности и т.д. Поставляется с GUI (графическим пользовательским интерфейсом) и интерфейсом командной строки. Поставляется с GUI (графическим пользовательским интерфейсом) и интерфейсом командной строки. Поддерживаются различные форматы вывода: MKV, Flash, AVI, MPEG-1 / 2, OGM, MP4 и т.д. Avidemux доступен для Linux, BSD, Mac OS X и Microsoft Windows по лицензии GNU GPL. Программа была написана с нуля Mean, но также использовался код других людей и проектов. Патчи, переводы и даже сообщения об ошибках всегда приветствуются. Исходный код: Open Source (открыт); Языки программирования: C; C++; Библиотеки: Qt; Лицензия: GNU GPL; Приложение переведено на русский язык. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить Avidemux-Cli (avidemux-cli),     2 - Установить Avidemux-QT (avidemux-qt)(Заменяет: avidemux-gtk),

    0 - НЕТ - Пропустить установку: " in_avidemux  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_avidemux" =~ [^120] ]]
do
    :
done
if [[ $in_avidemux == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_avidemux == 1 ]]; then
  echo ""
  echo " Установка Avidemux (avidemux-cli) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
####### Avidemux-Cli (Command Line Interface) ##########
sudo pacman -S --noconfirm --needed avidemux-cli  # Графический инструмент для редактирования видео (фильтрация/перекодирование/разделение) с графическим интерфейсом (cli) ; http://fixounet.free.fr/avidemux/ ; https://archlinux.org/packages/extra/x86_64/avidemux-cli/ ; 21 июня 2024 г., 19:50 UTC ; https://archlinux.org/packages/extra/x86_64/avidemux-qt/ ; https://archlinux.org/packages/extra/x86_64/avidemux/ ; 2025-06-15 19:01 UTC
#sudo pacman -Rcns avidemux-cli  # Чтобы удалить avidemux-cli в Arch Linux
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_avidemux == 2 ]]; then
  echo ""
  echo " Установка Avidemux (avidemux-qt) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
########## Avidemux-(QT version) ############
sudo pacman -S --noconfirm --needed avidemux-qt  # Графический инструмент для редактирования видео (фильтрация/перекодирование/разделение) - Qt GUI ; http://fixounet.free.fr/avidemux/ ; https://archlinux.org/packages/extra/x86_64/avidemux-qt/ ; 21 июня 2024 г., 19:50 UTC ; Заменяет: avidemux-gtk ; https://archlinux.org/packages/extra/x86_64/avidemux/ ; 2025-06-15 19:01 UTC
#sudo pacman -Rcns avidemux-qt  # Чтобы удалить avidemux-qt в Arch Linux
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#######################
# Примеры Конвертации и Кодирование: Использование командной строки
# Чтобы получить актуальный список команд и параметров, просто выполните avidemux --help.
# Конвертация файла AVI в VCD
# Кодирование звука с помощью lavcodec: avidemux2 --load input.avi --audio-process --audio-normalize --audio-resample 44100 --audio-codec MP2 --audio-bitrate 224 --output-format PS --video-process --vcd-res --video-codec VCD --save output.mpg --quit
# Кодирование звука с помощью toolame: avidemux2 --load input.avi --audio-process --audio-normalize --audio-resample 44100 --audio-codec TOOLAME --audio-bitrate 224 --output-format PS --video-process --vcd-res --video-codec VCD --save output.mpg --quit
# Перекодирование саундтрека в MP3 VBR
# Сначала сохраните аудио в формате wav avidemux --load input.avi --audio-process --audio-normalize --audio-resample --save-uncompressed-audio /tmp/videocd.wav
# Затем закодируйте его с помощью lame: lame /tmp/videocd.wav -vbr -v -V 4 ​​/tmp/videocd.mp3
# Перезагрузите mp3 и сохраните avi: avidemux --load input.avi --external-mp3 /tmp/videocd.mp3 --audio-map --save /tmp/new.avi
# Аудиокарта очень важна, так как мы сгенерировали VBR mp3. В противном случае ожидайте асинхронного большого времени!.
# Это всего лишь пример того, как можно кодировать в mp3 vbr, используя непосредственно графический интерфейс.
#######################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить DaVinci Resolve (davinci-resolve) - Редактирование видео?"
echo -e "${MAGENTA}:: ${BOLD}DaVinci Resolve — это профессиональная программа для цветокоррекции, монтажа и обработки видео. Разработала программу австралийская компания Blackmagic Design, известная прежде всего благодаря своим кинокамерам и прочему оборудованию для кино- и видеопроизводства. 👊 *Примечание! Программа работает только с проприетарными видеодрайверами Nvidia и AMD. По большей части DaVinci Resolve оптимизирована под Nvidia, поэтому убедитесь что у вас установлена последняя версия видеодрайвера. ${NC}"
echo " Домашняя страница: https://www.blackmagicdesign.com/support/family/davinci-resolve-and-fusion ; (https://aur.archlinux.org/packages/davinci-resolve?all_deps=1#pkgdeps). "
echo -e "${MAGENTA}:: ${BOLD}Благодаря широчайшему функционалу, сочетающему в одной программе редактирование, цветокоррекцию, визуальные эффекты, анимационную графику и постобработку звука, DaVinci Resolve широко используется в кинопроизводстве, на телевидении и в видеопродакшене. Использовать DaVinci Resolve для видеомонтажа в индустрии стали относительно недавно, хотя до этого программа и зарекомендовала себя в качестве одного из самых мощных инструментов для цветокоррекции. За последние годы DaVinci Resolve выросла в полноценный видеоредактор с огромным количеством возможностей. ${NC}"
echo " Прежде чем что-либо загружать, убедитесь, что ваше устройство поддерживает DaVinci Resolve. Поскольку он разработан для создания и редактирования видео высокого уровня, он несовместим с вашими обычными машинами. Минимальные требования для Linux: 32 ГБ ОЗУ; Дискретный графический процессор с поддержкой OpenCL 1.2 или CUDA 11, а также имеющий не менее 2 ГБ видеопамяти; Драйвер графического процессора, поддерживающий NVIDIA или AMD; Blackmagic Design Desktop Video 10.4.1 или более поздняя версия; Минимум CentOS 7.3; Процессор AMD Ryzen 7 или Intel Core i7; Быстрый SSD (твердотельный накопитель)! Совет: если вы просто редактируете свои видео, вы можете использовать YouTube или VLC для выполнения этой работы. "
echo -e "${CYAN}:: ${NC}Установка DaVinci Resolve (davinci-resolve) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_davinci  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_davinci" =~ [^10] ]]
do
    :
done
if [[ $in_davinci == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_davinci == 1 ]]; then
  echo ""
  echo " Установка DaVinci Resolve (davinci-resolve) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pamac build davinci-resolve  # Установка через пакмэна (pacman)
########### davinci-resolve #############
yay -S davinci-resolve --noconfirm  # Профессиональный программный пакет для постпроизводства аудио/видео от Blackmagic Design ; https://www.blackmagicdesign.com/support/family/davinci-resolve-and-fusion ; https://aur.archlinux.org/davinci-resolve.git (только для чтения, нажмите, чтобы скопировать) ; 2024-06-19 20:45 (UTC) ; Конфликты: с davinci-resolve-beta, davinci-resolve-studio, davinci-resolve-studio-beta ; Смотрите Зависимости !
#git clone https://aur.archlinux.org/davinci-resolve.git   # (только для чтения, нажмите, чтобы скопировать)
#cd davinci-resolve
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf davinci-resolve
#rm -Rf davinci-resolve
########### davinci-resolve-studio #############
# yay -S davinci-resolve-studio --noconfirm  # Профессиональный программный пакет для постпроизводства аудио/видео от Blackmagic Design. Студийная версия, требуется лицензионный ключ или лицензионный ключ ; https://www.blackmagicdesign.com/support/family/davinci-resolve-and-fusion ; https://aur.archlinux.org/davinci-resolve-studio.git (только для чтения, нажмите, чтобы скопировать) ; https://aur.archlinux.org/packages/davinci-resolve-studio ; https://swr.cloud.blackmagicdesign.com/DaVinciResolve/v18.6.6/DaVinci_Resolve_Studio_18.6.6_Linux.zip?verify=1718829978-icdm9AdbCPjAag798lKsFF0sA%2B4B6CwuvpJFRV2Xx2s%3D ; 2024-06-19 20:46 (UTC) ; Конфликты: с davinci-resolve-beta, davinci-resolve, davinci-resolve-beta, davinci-resolve-studio-beta ; Смотрите Зависимости !
########### davinconv Создано Gohny #############
# yay -S davinconv --noconfirm  # Простой скрипт, написанный на bash, для конвертации видео с помощью ffmpeg в формат, поддерживаемый Davinci Resolve для Linux ; https://github.com/gohny/davinconv ; https://aur.archlinux.org/davinconv.git (только для чтения, нажмите, чтобы скопировать) ; https://aur.archlinux.org/packages/davinconv ; https://github.com/gohny/davinconv/archive/refs/tags/0.1.0.tar.gz ; 2023-12-22 21:07 (UTC) ; Конвертированные видео хранятся в:~/Videos/davinconv/
# sudo pacman -Rsnu davinconv  # Удалить davinconvс помощью pacman
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo -e "${MAGENTA}
  <<< Установка утилит для Конвертирования мультимедиа файлов в Archlinux >>> ${NC}"
# Installing utilities for Converting multimedia files to Archlinux
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить SoundConverter - (для конвертирования звуковых-аудио файлов)?"
echo -e "${MAGENTA}:: ${BOLD}SoundConverter - Аудио конвертер - это простая и удобная программа для конвертирования звуковых-аудио файлов из одного формата в другой. В качестве исходных файлов, могут быть как аудио, так и видео файлы различных форматов ogg, aac, mp3, flac, wav, avi, mpeg, mov, m4a, ac3, dts, alac, mpc и т.д. Преобразовывать аудио файлы можно в следующие форматы mp3, wav, ogg, m4a, flac. ${NC}"
echo " Домашняя страница: https://soundconverter.org/ ; (https://archlinux.org/packages/extra/any/soundconverter/). "
echo -e "${MAGENTA}:: ${BOLD}Интерфейс программы лаконичный и понятный. Пользоваться программой очень просто. Сначала нужно указать параметры конвертирования в меню Edit(Редактирование)->Параметры. Здесь же можно задать формат выходного файла, качество, скорость (cbr, abr, vbr), результирующую папку и формат имени файла. Затем в программе нажать Добавить файл или Добавить папку и нажать кнопку Преобразовать. Начнется преобразование файлов из одного формата в другой. ${NC}"
echo " Быстрое, многопоточное преобразование - обрабатывает огромное количество файлов в рекордное время. Наконец-то используйте все эти ядра для ускорения конвертации. Он также может извлекать аудио из видео. "
echo " Мощное автоматизированное переименование имён файлов и создать папки в соответствии с тегами. Зачем делать скучные задачи, когда можно просто нажать кнопку? SoundConverter — ведущий конвертер аудиофайлов для рабочего стола GNOME. Он читает все, что может прочитать GStreamer (Ogg Vorbis, AAC, MP3, FLAC, WAV, AVI, MPEG, MOV, M4A, AC3, DTS, ALAC, MPC, Shorten, APE, SID, MOD, XM, S3M и т. д.), и записывает в файлы Opus, Ogg Vorbis, FLAC, WAV, AAC и MP3 или использует любой аудиопрофиль GNOME."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_soundconv  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_soundconv" =~ [^10] ]]
do
    :
done
if [[ $in_soundconv == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_soundconv == 1 ]]; then
  echo ""
  echo " Установка SoundConverter "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed soundconverter  # Простое приложение-конвертер звука для GNOME ;https://soundconverter.org/ ; https://archlinux.org/packages/extra/any/soundconverter/ ; 2025-07-27 15:42 UTC
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Curlew (curlew) - Медиа конвертер для Linux?"
echo -e "${MAGENTA}:: ${BOLD}Curlew Multimedia Converter - бесплатный, с открытым исходным кодом и простой в использовании мультимедийный конвертер для Linux. Он зависит от FFmpeg / avconv и написан на Python и GTK3. ${NC}"
echo " Домашняя страница: https://curlew.sourceforge.io/ ; (https://aur.archlinux.org/packages/curlew). "
echo -e "${MAGENTA}:: ${BOLD}Curlew является интерфейсом известного медиаконвертера на базе FFmpeg CLI с множеством вариантов использования, включая скрытие / отображение расширенных параметров, настройку скоростей передачи и форматов вывода, перетаскивание для добавления выбранных файлов для преобразования, и т.п.. Curlew экспортирует ваш транскодированный медиаконтент в папку ~ / Видео по умолчанию, но, конечно, это можно изменить с панели «Дополнительно», где вы также можете найти варианты встраивания субтитров, обрезки, качества видео, разделения файлов и битрейта аудио. ${NC}"
echo " Особенности Curlew: Интуитивно понятный графический интерфейс пользователя, совместимый с системными темами. Показать / скрыть дополнительные параметры. Поддерживает преобразование в более чем 100 различных форматов. Отображает метаданные файла (продолжительность, оставшееся время, предполагаемый размер, значение прогресса). Отображение сведений о файле с использованием mediainfo. Предварительный просмотр файлов перед конверсией. Слияние субтитров с видео. Преобразование только определенных частей файлов. Поддерживает видеосъемку и панорамирование. Отображать сведения об ошибках в случае, если они существуют. Автоматизация выключения ПК или приостановка после завершения процесса преобразования. Отображение миниатюры видео. Разрешает, пропустить или удалить файл во время процесса конверсии. Одна из недостающих функций - возможность устанавливать разные параметры преобразования для каждого файла в группе файлов, выбранных для преобразования. Например, вы не можете выбрать 5 mp3-файлов и преобразовать их в разные форматы одновременно. Надеюсь, эта функция скоро придет в Curlew. "
echo -e "${CYAN}:: ${NC}Установка Curlew (curlew) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_curlew  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_curlew" =~ [^10] ]]
do
    :
done
if [[ $in_curlew == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_curlew == 1 ]]; then
  echo ""
  echo " Установка Curlew (curlew) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
########## curlew ###########
sudo pacman -S --noconfirm --needed python-pymediainfo
yay -S curlew --noconfirm  # Простой в использовании, бесплатный и открытый исходный код конвертера мультимедиа для Linux на Python ; https://aur.archlinux.org/curlew.git (только для чтения, нажмите, чтобы скопировать) ; https://curlew.sourceforge.io/ ; https://aur.archlinux.org/packages/curlew ; http://downloads.sourceforge.net/project/curlew/curlew-0.2.5/curlew-0.2.5.tar.gz ; 2024-04-16 12:09 (UTC)
#git clone https://aur.archlinux.org/curlew.git   # (только для чтения, нажмите, чтобы скопировать)
#cd curlew
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf curlew
#rm -Rf curlew
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Ciano - (для конвертации мультимедиа файлов)?"
echo -e "${MAGENTA}:: ${BOLD}Ciano — это приложение для конвертации мультимедиа на рабочем столе, отвечающее за конвертацию видео, музыки и изображений. Изначально созданное для обеспечения наилучшего опыта в Elementary OS, Ciano использует крупнейшие инструменты конвертации: FFmpeg и ImageMagick и разработано на языке программирования Vala. ${NC}"
echo " Домашняя страница: https://robertsanseries.github.io/ciano/ ; (https://archlinux.org/packages/extra/x86_64/ciano/). "
echo -e "${MAGENTA}:: ${BOLD}Ciano, ориентированный на простоту, предлагает новый подход к использованию FFmpeg, без необходимости написания кода командной строки. ${NC}"
echo " Особенности программы: поддержка многих кодеков и контейнеров; возможность конвертации нескольких файлов одновременно; определение выходной папки; поддержка уведомлений о завершении действия и возникновении ошибок при конвертации; возможность закрытия приложения в любое время с помощью Ctrl + Q; поддержка пакетов для elementary OS и Debian/Ubuntu. "
echo " Конверсия: Конвертируйте и обрабатывайте множество медиафайлов с помощью FFmpeg без каких-либо знаний. Форматы медиа: Поддержка множества кодеков и контейнеров, таких как MPEG4, MPEG, FLV, AVI, OGG, GIF, VOB, MP3, WMA и многих других. Конвертируйте несколько файлов одновременно. Множественный выбор и конвертация файлов. В код не включены двоичные файлы FFmpeg и ImageMagick, чтобы соответствовать законам и лицензиям обоих инструментов, которые могут различаться в зависимости от страны. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_ciano  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_ciano" =~ [^10] ]]
do
    :
done
if [[ $in_ciano == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_ciano == 1 ]]; then
  echo ""
  echo " Установка Ciano (ciano) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed ciano  # Конвертер мультимедийных файлов, ориентированный на простоту ; https://robertsanseries.github.io/ciano/ ; https://archlinux.org/packages/extra/x86_64/ciano/
echo " Установка утилит (пакетов) выполнена "
fi
###########

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Transmageddon (для конвертирования видео файлов между различными форматами)?"
echo -e "${MAGENTA}:: ${BOLD}Transmageddon Video Converter - это простое приложение на Python для перекодирования видео в форматы
поддерживается GStreamer. ${NC}"
echo " Transmageddon — это видеотранскодер для систем Linux и Unix, созданный с использованием GStreamer. Он поддерживает практически любой формат в качестве входных данных и может генерировать очень большой массив выходных файлов. Целью приложения было помочь людям создавать файлы, которые им нужны для воспроизведения на мобильных устройствах, а также людям, не имеющим большого опыта работы с мультимедиа, создавать мультимедийные файлы, не прибегая к использованию инструментов командной строки с неуклюжим синтаксисом. (http://www.linuxrising.org/ ; https://github.com/tvataire/transmageddon). "
echo " Transmageddon должен работать с любыми правильно реализованными плагинами кодеков, будь то аппаратные плагины или фирменные, но я не могу ничего обещать так как я не могу их протестировать. В настоящее время видео конвертер Transmageddon поддерживает следующее: Контейнеры: Ogg, Matroska, AVI, MPEG TS, flv, QuickTime, MPEG4, 3GPP, MXT. Аудио кодеки: Vorbis, FLAC, MP3, AAC, AC3, Speex, Celt. Видео кодеки: Theora, Dirac, H264, MPEG2, MPEG4 / DivX5, xvid, DnxHD. Рекомендовано для поддержки DVD: lsdvd; libdvdread; libdvdcss. "
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют функция пропуска установки уже установленных пакетов! ${NC}"
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " i_transmageddon  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_transmageddon" =~ [^10] ]]
do
    :
done
if [[ $i_transmageddon == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_transmageddon == 1 ]]; then
  echo ""
  echo " Установка Transmageddon Video Converter "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
############ Библиотека для чтения DVD видеодисков ##############
sudo pacman -S --noconfirm --needed libdvdcss  # Портативная библиотека абстракций для расшифровки DVD ; https://www.videolan.org/developers/libdvdcss.html ; https://archlinux.org/packages/extra/x86_64/libdvdcss/
sudo pacman -S --noconfirm --needed libdvdread  # Библиотека для чтения DVD видеодисков ; https://www.videolan.org/developers/libdvdnav.html ; https://archlinux.org/packages/extra/x86_64/libdvdread/
sudo pacman -S --noconfirm --needed lsdvd  # Консольное приложение, отображающее содержимое DVD ; https://sourceforge.net/projects/lsdvd/ ; https://archlinux.org/packages/extra/x86_64/lsdvd/
############ Transmageddon Video Converter ##############
sudo pacman -S --noconfirm --needed transmageddon  # Простое приложение на Python для перекодирования видео в форматы, поддерживаемые GStreamer ; http://www.linuxrising.org/ ; https://archlinux.org/packages/extra/any/transmageddon/ ; https://github.com/tvataire/transmageddon ; 2025-07-31 20:00 UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить FF Multi Converter - (для преобразования различных форматов файлов: аудио, видео, изображений и документов)?"
echo -e "${MAGENTA}:: ${BOLD}FF Multi Converter - это полезный инструмент с графическим интерфейсом, которое позволяет конвертировать аудио/видео файлы в различные форматы, документы в несколько форматов и изображения в наиболее используемые форматы. Очень часто исходные информационные материалы (файлы) не соответствуют требованиям для конечной задачи их создания, тогда и возникает необходимость конвертирования — преобразования одного формата файла в другой. Одним из лучших приложений этого плана является FF Multi Converter. FF-Multi-Converter использует FFmpeg для конвертации аудио/видео файлов, unoconv для конвертации документов и утилиту ImageMagick для конвертации изображений. Основная цель этого приложения — предложить наиболее популярные типы мультимедиа в одном приложении и предоставить различные варианты конвертации для них легко через довольно простой в использовании графический интерфейс, вы найдете это приложение очень удобным и полезным. Оно написано с использованием Python3 и PyQt5, выпущено под лицензией GNU General Public License (GPL V3). Язык интерфейса: мультиязычный, включая русский. ${NC}"
echo " Домашняя страница: https://sites.google.com/site/ffmulticonverter/ ; (https://aur.archlinux.org/ffmulticonverter.git). "
echo -e "${MAGENTA}:: ${BOLD}Функции:Конвертация для нескольких форматов файлов. Очень простой в использовании интерфейс. Доступ к общим параметрам конвертации. Управление аудио/видео пресетами ffmpeg. Параметры сохранения и именования файлов. Многоязычность — более 20 языков. ${NC}"
echo " Поддерживаемые форматы - Форматы аудио/видео: aac; ac3; afc; aiff; amr; asf; au; avi; dvd; flac; flv; mka; mkv; mmf; mov; mp3; mp4; mpg; ogg; ogv; psp; rm; spx; vob; wav; webm; wma; wmv; и другие, поддерживаемые ffmpeg. Форматы изображений: bmp; cgm; dpx; emf; eps; fpx; gif; jbig; jng; jpeg; mrsid; p7; pdf; picon; png; ppm; psd; rad; tga; tif; webp; xpm. Форматы файлов документов: doc --> (odt, pdf); html --> (odt); odp --> (pdf, ppt); ods --> (pdf); odt --> (doc, html, pdf, rtf, sxw, txt, xml); ppt --> (odp); rtf --> (odt); sdw --> (odt); sxw --> (odt); txt --> (odt); xls --> (ods); xml --> (doc, odt, pdf). "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить FF Multi Converter (ffmulticonverter),   2 - Установить FF Multi Converter (ffmulticonverter-git),

    0 - НЕТ - Пропустить установку: " in_ffmulticonverter  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_ffmulticonverter" =~ [^120] ]]
do
    :
done
if [[ $in_ffmulticonverter == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_ffmulticonverter == 1 ]]; then
  echo ""
  echo " Установка FF Multi Converter (ffmulticonverter) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed python-pyqt5  # Набор привязок Python для инструментария Qt5 ; https://riverbankcomputing.com/software/pyqt/intro ; https://archlinux.org/packages/extra/x86_64/python-pyqt5/
sudo pacman -S --noconfirm --needed ffmpeg  # Комплексное решение для записи, конвертации и потоковой передачи аудио и видео ; https://ffmpeg.org/ ; https://archlinux.org/packages/extra/x86_64/ffmpeg/
sudo pacman -S --noconfirm --needed imagemagick  # Программа для просмотра и обработки изображений ; Его можно использовать для создания, редактирования, компоновки или преобразования растровых изображений, и он поддерживает широкий спектр форматов файлов , включая JPEG, PNG, GIF, TIFF и Ultra HDR. ; https://www.imagemagick.org/ ; https://archlinux.org/packages/extra/x86_64/imagemagick/
sudo pacman -S --noconfirm --needed unoconv  # Конвертер документов на базе Libreoffice ; http://dag.wiee.rs/home-made/unoconv ; https://archlinux.org/packages/extra/any/unoconv/
########### ffmulticonverter #############
yay -S ffmulticonverter --noconfirm  # Конвертируйте аудио, видео, изображения и файлы документов между всеми популярными форматами ; https://aur.archlinux.org/ffmulticonverter.git (только для чтения, нажмите, чтобы скопировать) ; https://sites.google.com/site/ffmulticonverter/ ; https://aur.archlinux.org/packages/ffmulticonverter ; Конфликты: с ffmulticonverter-git ; https://github.com/ilstam/FF-Multi-Converter ; 2016-06-30 22:57 (UTC)
# git clone https://aur.archlinux.org/ffmulticonverter.git   # (только для чтения, нажмите, чтобы скопировать)
# cd  ffmulticonverter
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf  ffmulticonverter
# rm -Rf  ffmulticonverter
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_ffmulticonverter == 2 ]]; then
  echo ""
  echo " Установка FF Multi Converter (ffmulticonverter-git) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
######## ffmulticonverter-git ##################
sudo pacman -S --noconfirm --needed python-pyqt5  # Набор привязок Python для инструментария Qt5 ; https://riverbankcomputing.com/software/pyqt/intro ; https://archlinux.org/packages/extra/x86_64/python-pyqt5/
sudo pacman -S --noconfirm --needed git  # быстрая распределенная система контроля версий ; https://git-scm.com/ ; https://archlinux.org/packages/extra/x86_64/git/
sudo pacman -S --noconfirm --needed ffmpeg  # Комплексное решение для записи, конвертации и потоковой передачи аудио и видео ; https://ffmpeg.org/ ; https://archlinux.org/packages/extra/x86_64/ffmpeg/
sudo pacman -S --noconfirm --needed imagemagick  # Программа для просмотра и обработки изображений ; Его можно использовать для создания, редактирования, компоновки или преобразования растровых изображений, и он поддерживает широкий спектр форматов файлов , включая JPEG, PNG, GIF, TIFF и Ultra HDR. ; https://www.imagemagick.org/ ; https://archlinux.org/packages/extra/x86_64/imagemagick/
sudo pacman -S --noconfirm --needed unoconv  # Конвертер документов на базе Libreoffice ; http://dag.wiee.rs/home-made/unoconv ; https://archlinux.org/packages/extra/any/unoconv/
yay -S ffmulticonverter-git --noconfirm  # Конвертируйте аудио, видео, изображения и файлы документов между всеми популярными форматами ; https://aur.archlinux.org/ffmulticonverter-git.git (только для чтения, нажмите, чтобы скопировать) ; https://sites.google.com/site/ffmulticonverter/ ; https://aur.archlinux.org/packages/ffmulticonverter-git ; Конфликты: с ffmulticonverter ; https://github.com/ilstam/FF-Multi-Converter ; 2021-12-22 21:59 (UTC)
# git clone https://aur.archlinux.org/ffmulticonverter-git.git   # (только для чтения, нажмите, чтобы скопировать)
# cd  ffmulticonverter-git
#makepkg -fsri
# makepkg -si
# makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
# pwd    # покажет в какой директории мы находимся
# cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf  ffmulticonverter-git
# rm -Rf  ffmulticonverter-git
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ######################
# Это приложение, которое также можно загрузить с https://sourceforge.net/projects/ffmulticonv/. Оно размещено в OnWorks для того, чтобы его можно было запустить онлайн самым простым способом из одной из наших бесплатных операционных систем.
#############################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить WinFF (winff-common) — Конвертер видео?"
echo -e "${MAGENTA}:: ${BOLD}WinFF — бесплатная программа для конвертации видео из одного формата в другой. Фактически WinFF — это простой в использовании графический интерфейс (GUI) для командной строки видео конвертера Ffmpeg. Проект является ведущим мультимедийным фреймворком, способным декодировать, кодировать, перекодировать. Он поддерживает самые малоизвестные и древние форматы. Независимо от того, кем они были разработаны: сообществом или корпорацией. Также WinFF может преобразовать видео в аудио файл (получить звуковую дорожку). ${NC}"
echo " Домашняя страница: https://github.com/WinFF/winff/ ; (https://ffmpeg.org/ ; https://aur.archlinux.org/packages/winff-common ; https://aur.archlinux.org/packages/winff-gtk2 ; https://aur.archlinux.org/packages/winff-gtk3 ; https://aur.archlinux.org/packages/winff-qt5 ; https://aur.archlinux.org/packages/winff-qt6 ; https://aur.archlinux.org/packages/winff-git). "
echo -e "${MAGENTA}:: ${BOLD}В программе уже настроено несколько предустановленных параметров для различного формата видео, в котором можно преобразовать исходные файлы. Конвертер Ffmpeg может работать с несколькими файлами и несколькими форматах одновременно. WinFF поддерживает ОС Windows 95, 98, NT, 2000, XP, Vista, Windows 7, Windows 8, Windows 10, а также Debian, Ubuntu, RedHat, openSUSE и другие дистрибутивы, основанные на GNU/Linux. Программа переведена на русский язык. Разработчик https://ffmpeg.org/ ${NC}"
echo " Возможности преобразования: AVI →DVD , AVI → FLV , AVI → MPG , AVI → WMV , AVI → XviD , DivX → DVD ,  DivX → FLV , DivX → MPG , DivX → WMV ,FLV → AVI , FLV → DVD , FLV → FLV ,  FLV → MPG , FLV → WMV, MPG → AVI , MPG → FLV , MPG → WMV ,  VOB → AVI , VOB → FLV , VOB → MPG , VOB → WMV , WMV → AVI , WMV → DVD , WMV → MPG , WMV → XviD и т.д. "
echo -e "${CYAN}:: ${NC}Установка WinFF (winff-common) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить WinFF (winff-common),  2 - *Установить WinFF (winff-gtk2),  3 - Установить WinFF (winff-gtk3),

    4 - Установить WinFF (winff-qt5),  5 - Установить WinFF (winff-qt6),  6 - Установить WinFF (winff-git),

    0 - НЕТ - Пропустить установку: " in_winff  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_winff" =~ [^1234560] ]]
do
    :
done
if [[ $in_winff == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_winff == 1 ]]; then
  echo ""
  echo " Установка WinFF (winff-common) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
########### winff-common ###########
yay -S winff-common --noconfirm  # GUI для ffmpeg, написанный на Lazarus ; https://aur.archlinux.org/winff.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/WinFF/winff/ ; https://aur.archlinux.org/packages/winff-common ; git+https://github.com/WinFF/winff.git#tag=winff-1.6.4 ; 2024-06-02 22:32 (UTC) ; Смотрите Зависимости !
#git clone https://aur.archlinux.org/winff.git   # (только для чтения, нажмите, чтобы скопировать)
#cd winff-common
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf winff-common
#rm -Rf winff-common
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_winff == 2 ]]; then
  echo ""
  echo " Установка WinFF (winff-gtk2) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
########## Зависимости ###########
########### winff-common ###########
yay -S winff-common --noconfirm  # GUI для ffmpeg, написанный на Lazarus ; https://aur.archlinux.org/winff.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/WinFF/winff/ ; https://aur.archlinux.org/packages/winff-common ; git+https://github.com/WinFF/winff.git#tag=winff-1.6.4 ; 2024-06-02 22:32 (UTC) ; Смотрите Зависимости !
#git clone https://aur.archlinux.org/winff.git   # (только для чтения, нажмите, чтобы скопировать)
#cd winff-common
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf winff-common
#rm -Rf winff-common
######### winff-gtk2 #######
yay -S winff-gtk2 --noconfirm  # GUI для ffmpeg, написанный на Lazarus ; https://aur.archlinux.org/winff.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/WinFF/winff/ ; https://aur.archlinux.org/packages/winff-gtk2 ; git+https://github.com/WinFF/winff.git#tag=winff-1.6.4 ; 2024-06-02 22:32 (UTC) ; Смотрите Зависимости !
#git clone https://aur.archlinux.org/winff.git   # (только для чтения, нажмите, чтобы скопировать)
#cd winff-gtk2
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf winff-gtk2
#rm -Rf winff-gtk2
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_winff == 3 ]]; then
  echo ""
  echo " Установка WinFF (winff-gtk3) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
########## Зависимости ###########
########### winff-common ###########
yay -S winff-common --noconfirm  # GUI для ffmpeg, написанный на Lazarus ; https://aur.archlinux.org/winff.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/WinFF/winff/ ; https://aur.archlinux.org/packages/winff-common ; git+https://github.com/WinFF/winff.git#tag=winff-1.6.4 ; 2024-06-02 22:32 (UTC) ; Смотрите Зависимости !
#git clone https://aur.archlinux.org/winff.git   # (только для чтения, нажмите, чтобы скопировать)
#cd winff-common
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf winff-common
#rm -Rf winff-common
######### winff-gtk3 #######
yay -S winff-gtk3 --noconfirm  # GUI для ffmpeg, написанный на Lazarus ; https://aur.archlinux.org/winff.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/WinFF/winff/ ; https://aur.archlinux.org/packages/winff-gtk3 ; git+https://github.com/WinFF/winff.git#tag=winff-1.6.4 ; 2024-06-02 22:32 (UTC) ; Смотрите Зависимости !
#git clone https://aur.archlinux.org/winff.git   # (только для чтения, нажмите, чтобы скопировать)
#cd winff-gtk3
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf winff-gtk3
#rm -Rf winff-gtk3
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_winff == 4 ]]; then
  echo ""
  echo " Установка WinFF (winff-qt5) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
########## Зависимости ###########
########### winff-common ###########
yay -S winff-common --noconfirm  # GUI для ffmpeg, написанный на Lazarus ; https://aur.archlinux.org/winff.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/WinFF/winff/ ; https://aur.archlinux.org/packages/winff-common ; git+https://github.com/WinFF/winff.git#tag=winff-1.6.4 ; 2024-06-02 22:32 (UTC) ; Смотрите Зависимости !
#git clone https://aur.archlinux.org/winff.git   # (только для чтения, нажмите, чтобы скопировать)
#cd winff-common
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf winff-common
#rm -Rf winff-common
######### winff-qt5 #######
yay -S winff-qt5 --noconfirm  # GUI для ffmpeg, написанный на Lazarus ; https://aur.archlinux.org/winff.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/WinFF/winff/ ; https://aur.archlinux.org/packages/winff-qt5 ; git+https://github.com/WinFF/winff.git#tag=winff-1.6.4 ; 2024-06-02 22:32 (UTC) ; Смотрите Зависимости !
#git clone https://aur.archlinux.org/winff.git   # (только для чтения, нажмите, чтобы скопировать)
#cd winff-qt5
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf winff-qt5
#rm -Rf winff-qt5
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_winff == 5 ]]; then
  echo ""
  echo " Установка WinFF (winff-qt6) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
########## Зависимости ###########
########### winff-common ###########
yay -S winff-common --noconfirm  # GUI для ffmpeg, написанный на Lazarus ; https://aur.archlinux.org/winff.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/WinFF/winff/ ; https://aur.archlinux.org/packages/winff-common ; git+https://github.com/WinFF/winff.git#tag=winff-1.6.4 ; 2024-06-02 22:32 (UTC) ; Смотрите Зависимости !
#git clone https://aur.archlinux.org/winff.git   # (только для чтения, нажмите, чтобы скопировать)
#cd winff-common
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf winff-common
#rm -Rf winff-common
######### winff-qt6 #######
yay -S winff-qt6 --noconfirm  # GUI для ffmpeg, написанный на Lazarus ; https://aur.archlinux.org/winff.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/WinFF/winff/ ; https://aur.archlinux.org/packages/winff-qt6 ; git+https://github.com/WinFF/winff.git#tag=winff-1.6.4 ; 2024-06-02 22:32 (UTC) ; Смотрите Зависимости !
#git clone https://aur.archlinux.org/winff.git   # (только для чтения, нажмите, чтобы скопировать)
#cd winff-qt6
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf winff-qt6
#rm -Rf winff-qt6
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_winff == 6 ]]; then
  echo ""
  echo " Установка WinFF (winff-git) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
########### winff-common ###########
yay -S winff-git --noconfirm  # Фронтенд FFmpeg, написанный на Free Pascal с использованием Lazarus (Qt6) ; https://aur.archlinux.org/winff-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/WinFF/winff ; https://aur.archlinux.org/packages/winff-git ; 2024-06-03 02:31 (UTC) ; Конфликты: с winff, winff-common ; Смотрите Зависимости !
#git clone https://aur.archlinux.org/winff-git.git   # (только для чтения, нажмите, чтобы скопировать)
#cd winff-git
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf winff-git
#rm -Rf winff-git
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##### Справка ########
# Запуск:
# Меню - Аудио и видео - WinFF
# Настройка:
# В программе переходим: Правка - Настройки - Linux
# В поле путь к FFmpeg указываем /usr/bin/avconv (так как сейчас в репозиториях Ubuntu заменили ffmpeg на avconv - это форк ffmpeg, его создали разработчики ffmpeg)
# В поле путь к ffplay можно указать: /usr/bin/avplay или /usr/bin/mediainfo-gui
# Для сохранения настроек нажимаем на окей.
# Нажимаем вверху кнопку Настройки, чтобы появились вкладки для редактирования настроек конвертирования.
# Добавляем пресеты:
# В программе переходим: Файл - Импортировать параметры
# Выбираем файл /usr/share/winff/presets-libavcodec53.xml и нажимаем открыть.
# Соглашаемся когда будут всплывать сообщения (их будет около 20), это связано с тем, что некоторые пресеты уже установлены.
# Приступаем к конвертированию
# Нажимаем на кнопку добавить, выбираем исходный файл, выбираем ниже категорию пресетов, еще ниже сам пресет.
# Переходим на вкладку видео, выбираем 2 прохода для более качественного конвертирования, указываем размер видео изображения, соотношение сторон (4:3 или 16:9), битрейт
# Переходим на вкладку аудио, указываем битрейт, 2 канала для стерео
# Переходим в Настройки - Показывать сценарий перед запуском (настройка сохраняется до закрытия программы)
# Нажимаем на кнопку преобразовать.
# Откроется окно с командой для конвертирования через avconv, проверяем или просто нажимаем начать.
# Если после конвертирования в видео наблюдаются линии лесенкой, тогда включите функцию Деинтерлейсинг, и заново сконвертируйте видео.
# Справка:
# Также смотрите: документацию на официальных сайтах - Libav:libav (avconv) и FFmpeg:ffmpeg
# мануал по avconv, выполните в терминале: man avconv
# русскоязычная статья по FFmpeg: help.ubuntu.ru/wiki/ffmpeg
# контейнеры, выполните в терминале: avconv -formats
# кодеки, выполните в терминале: avconv - codecs
#------------------
# Во время использования программы возникла следующая проблема. Программа ничего не конвертировала, а в консоль выскакивало следующее сообщение об ошибке:
# x-terminal-emulator: error: Additional unexpected arguments found: ['&']
# Usage: x-terminal-emulator [options]
# Лечится следующим образом. В программе выбираете пункт меню Правка->Настройки, далее открываете вкладку Linux и в поле «Параметры терминала (Terminal options)» вписываете «-x» вместо «-e».
# Хорошая прога, давно искал конвертер для линуха) кстати пользователям Linux Mint нужно наоборот оставить в настройках параметр -е чтобы все работало
# Не совсем так. У меня Минт, но мне нужно выставлять -x, так как у меня не "родной" эмулятор терминала.
#################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Metadata Cleaner (metadata-cleaner) - Просмотр и очистка метаданных?"
echo -e "${MAGENTA}:: ${BOLD}Metadata Cleaner — это утилита для просмотра и удаления метаданных у графических, музыкальных и видео файлов. Позволяет быстро просматривать и удалять скрытые данные, включая EXIF, ID3-теги и так далее. ${NC}"
echo " Домашняя страница: https://apps.gnome.org/ru/ ; (https://archlinux.org/packages/extra/any/metadata-cleaner/). "
echo -e "${MAGENTA}:: ${BOLD}Metadata Cleaner имеет простой графический интерфейс на GTK в стилистике GNOME. В основном окне в левой колонке выводится список файлов, в правой колонке таблица с метаданными. Поддерживается импорт отдельных файлов и папок с файлами. Добавляйте файлы по отдельности или папку целиком, перетаскивайте курсором, есть горячие клавиши. Работает с картинками, видео- и аудиофайлами. Для применения в консоли справка по “mat2 -h”. Я ставил из репозиториев, доступно через Flathub. Ссылка на страницу проекта есть на gitlab, но она не рабочая. ${NC}"
echo " Метаданные в файле могут многое рассказать о вас. Камеры записывают данные о том, когда и где была сделана фотография и какая камера использовалась. Офисные приложения автоматически добавляют информацию об авторе и компании в документы и электронные таблицы. Это конфиденциальная информация, и вы, возможно, не захотите ее раскрывать. Этот инструмент позволяет просматривать метаданные в ваших файлах и по возможности избавляться от них. Под капотом он использует mat2 (https://0xacab.org/jvoisin/mat2) для анализа и удаления метаданных. mat2 сочетает в себе обе функции: и покажет скрытую информацию, и позволяет её удалить. Очистка скрытой информации о файле позволяет ещё и уменьшить вес файла. Исходный код: Open Source (открыт) ; Языки программирования: Python; Библиотеки: GTK; Лицензия: GNU GPL . "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_metadata  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_metadata" =~ [^10] ]]
do
    :
done
if [[ $in_metadata == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_metadata == 1 ]]; then
  echo ""
  echo " Установка Metadata Cleaner (metadata-cleaner) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed mat2  # Инструмент удаления метаданных, поддерживающий широкий спектр распространенных форматов файлов ; https://archlinux.org/packages/extra/any/mat2/ ; https://0xacab.org/jvoisin/mat2 ; https://github.com/tpet/mat2 ; 2025-01-11 14:38 UTC
sudo pacman -S --noconfirm --needed metadata-cleaner  # Приложение Python GTK для просмотра и очистки метаданных в файлах с использованием mat2 ; https://archlinux.org/packages/extra/any/metadata-cleaner/ ; https://apps.gnome.org/MetadataCleaner/ ; https://gitlab.com/rmnvgr/metadata-cleaner/ ; https://0xacab.org/jvoisin/mat2 ; 2024-12-22 13:52 UTC
# sudo pacman -Rcns metadata-cleaner  # Чтобы удалить Metadata Cleaner в Arch Linux
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
######### Справка ############
# Metadata Cleaner доступен в виде Flatpak на Flathub:
# Установка:
# flatpak install flathub fr.romainvigier.MetadataCleaner
# Запуск:
# flatpak run fr.romainvigier.MetadataCleaner
# Metadata Cleaner на GitHub
# https://gitlab.com/rmnvgr/metadata-cleaner/
# https://0xacab.org/jvoisin/mat2
# https://github.com/tpet/mat2
# Метаданные и конфиденциальность
# Метаданные состоят из информации, которая характеризует данные. Метаданные используются для предоставления документации для продуктов данных. По сути, метаданные отвечают на вопросы кто, что, когда, где, почему и как о каждом аспекте данных, которые документируются.
# Метаданные в файле могут многое рассказать о вас. Камеры записывают данные о том, когда была сделана фотография и какая камера использовалась. Документы Office, такие как PDF или Office, автоматически добавляют информацию об авторе и компании в документы и электронные таблицы. Возможно, вы не хотите раскрывать эту информацию.
# Именно в этом и заключается задача MAT2: избавиться, насколько это возможно, от метаданных.
# MAT2 предоставляет как инструмент командной строки, так и графический пользовательский интерфейс через расширение для Nautilus, файлового менеджера по умолчанию в GNOME.
#######################################

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
echo -e "${BLUE}:: ${NC}Если хотите установить дополнительный софт (пакеты), из AUR - через (yay), тогда после перезагрузки и входа в систему выполните команду:"
echo -e "${YELLOW}==> ${CYAN}git clone https://github.com/MarcMilany/archmy_2020.git ${NC}"
echo -e "${CYAN}:: ${NC}Цель скрипта (multimedia_prog_aur) - это установка мультимедиа софта (пакетов), плагинов находящихся в AUR."
echo -e "${CYAN}:: ${NC}Скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска служб."
echo -e "${GREEN}
  <<< Желаю Вам удачи во всех начинаниях, верных и точных решений! >>> ${NC}"
echo ""
echo -e "${RED}### ${BLUE}########################################################### ${RED}### ${NC}"
echo -e "${RED}==> ${BOLD}Выходим из установленной системы ${NC}"
echo -e "${BLUE}:: ${BOLD}Теперь вам надо ввести (exit) reboot, чтобы перезагрузиться ${NC}"
sleep 03
exit
exit

### end of script