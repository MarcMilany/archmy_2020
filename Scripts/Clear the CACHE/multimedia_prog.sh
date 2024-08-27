#!/bin/bash
# loadkeys ru
# setfont cyr-sun16
# clear
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

apptitle="Arch Linux Fast Install v2.4 LegasyBIOS - Version: 2024.07.31.00.40.38 (GPLv3)"
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
В процессе работы сценария (скрипта) Вам будут задаваться вопросы на установку той, или иной утилиты (пакета) - будьте внимательными! Устанавливаемый софт (пакеты), шрифты - скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. Так же присутствует софт (пакеты), шрифты - устанавливаемый из пользовательского репозитория 'AUR'-'yay', собираются и устанавливаются. Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска необходимых служб. В любой ситуации выбор всегда за вами. Вы либо гуляете под дождем, либо просто под ним мокнете.${RED}

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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed qmmp  # Аудиоплеер на Qt5-6 ; https://archlinux.org/packages/extra/x86_64/qmmp/ ; http://qmmp.ylsoftware.com/ ; June 21, 2024, 7:51 p.m. UTC
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_audacious  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
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
sudo pacman -S --noconfirm --needed playerctl  # Контроллер и библиотека медиаплеера mpris для Spotify, VLC, Audacious, BMP, XMMS2 и других. https://github.com/altdesktop/playerctl ; https://archlinux.org/packages/extra/x86_64/playerctl/
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
echo -e "${BLUE}:: ${NC}Установить CMus (С* Music Player) (cmus) — Консольный музыкальный плеер?"
echo -e "${MAGENTA}:: ${BOLD}CMus (С* Music Player) — консольный музыкальный плеер для Linux, работающий в терминале. CMus написан на языке программирования C (отсюда происходит и название плеера — CMus). ${NC}"
echo " Домашняя страница: https://cmus.github.io/ ; (https://archlinux.org/packages/extra/x86_64/cmus/). "  
echo -e "${MAGENTA}:: ${BOLD}CMus маленький, быстрый и минималистичный консольный аудио-плеер. Программа поддерживает все основные аудио-форматы, включая MP3, OGG, FLAC, WAV, MP4, Audio CD и другие. CMus поддерживает работу с плейлистами, фильтрацию и поиск по плейлистам. Поддерживается потоковое воспроизведение. Есть возможность использовать подписки Last.fm и Libre.fm (через скрипты). Управление CMus осуществляется с помощью команд, вводимых с клавиатуры. Режим ввода команд схож со стилем Vi. Чтобы ввести команду нужно нажать двоеточие (:), а затем вводить команду. Поддерживается автодополнение и пролистывание команд клавишей Tab. Программа может работать с очень большими плейлистами. На сайте разработчиков указано, что CMus мгновенно запускается даже с тысячами аудио-файлов. Интерфейс у CMus простой и довольно понятный. Можно настраивать цвета и шрифты. Возможности программы можно расширить с помощью скриптов (см. официальный WiKi https://github.com/cmus/cmus/wiki). ${NC}"
echo " Особенности Cmus: Добавлена поддержка многих аудиоформатов, включая MP3, MPEG, WMA, ALAC, Ogg Vorbis, FLAC, WavPack, Musepack, Wav, TTA, SHN и MOD. Более быстрый запуск при работе с тысячами треков. Поддержка непрерывного воспроизведения и ReplayGain. Передача Ogg и MP3 треков с Icecast и Shoutcast. Сильные фильтры музыкальной библиотеки и фильтрация в реальном времени. Очередь воспроизведения и отличная работа с компиляциями. Простой в использовании браузер каталогов и настраиваемые цвета с динамическими привязками клавиш. Добавлен режим поиска в стиле Vi и командный режим с завершением на . Легко управляется с помощью команды cmus-remote (сокет UNIX или TCP/IP). Работает на Unix-подобных системах, включая Linux, OS X, FreeBSD NetBSD, OpenBSD и Cygwin. Клавиши для управления воспроизведением: cmus предоставляет множество клавиш для управления воспроизведением, вот некоторые основные клавиши cmus для управления воспроизведением: Переключение воспроизведения/паузы. Воспроизведение следующей дорожки. Воспроизвести предыдущую дорожку. Остановить воспроизведение. Очистить список воспроизведения. Переключить режим тасования. Переключить режим повтора или : Увеличить громкость. "
echo " Для получения справки по использованию программы воспользуйтесь man: man cmus-tutorial; man cmus; man cmus-remote " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_cmus  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
  echo " Установка CMus (С* Music Player) (cmus) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed cmus  # Многофункциональный музыкальный проигрыватель на базе ncurses https://man.archlinux.org/man/extra/cmus/cmus.1.en ; June 23, 2024, 10:25 p.m. UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить MPD (mpd) - Серверное приложение для воспроизведения музыки??"
echo -e "${MAGENTA}:: ${BOLD}Music Player Daemon (MPD) — музыкальный проигрыватель с клиент-серверной архитектурой, который воспроизводит музыку из указанного каталога. Воспроизведением управляют при помощи клиента. Управлять сервером (демоном) можно с любой машины из сети, но слушать музыку можно и на своём компьютере, если программу-клиент MPD настроить на подключение к локальному хосту (localhost). ${NC}"
echo " Домашняя страница: https://github.com/MusicPlayerDaemon/MPD ; (https://archlinux.org/packages/extra/x86_64/mpd/). "  
echo -e "${MAGENTA}:: ${BOLD}Такая технология имеет ряд преимуществ. Для работы MPD не нужна X Window System, поэтому перезапуск X или закрытие программы-клиента не влияет на проигрывание (есть и клиенты, которые могут работать в командной строке, например, mpc и ncmpc); на сервере с MPD может даже не быть монитора. Воспроизведением можно управлять с других компьютеров, а также мобильных устройств (есть клиентские приложения для iOS, Android, Symbian и многих других платформ). Управлять воспроизведением музыки можно не только через локальную сеть, но и через Интернет (конфигурационный файл позволяет задать, на каких именно сетевых интерфейсах должен работать сервер). Даже если установка клиентского приложения на устройство, с которого необходимо управлять воспроизведением, по каким-то причинам невозможна, то остаётся возможность установить такое клиентское приложение, к которому можно обращаться с других узлов через веб-браузер. MPD использует базу данных (как и некоторые другие медиаплееры), чтобы хранить основную информацию о музыкальных файлах (название трека, исполнителя, название альбома и пр.). Как только демон запущен, база данных будет полностью сохранена в оперативной памяти, и нет никакой необходимости обращаться к диску с целью поиска песни и прочтения тегов аудиофайла. Демон для воспроизведения музыки различных форматов. Музыка воспроизводится через аудиоустройство сервера. Демон хранит информацию обо всей доступной музыке, и эту информацию можно легко искать и извлекать. Управление проигрывателем, извлечение информации и управление плейлистами можно осуществлять удаленно. MPD выпускается под лицензией GNU General Public License версии 2 и распространяется в файле COPYING. ${NC}"
echo " MPD (mpd) *БУДЕТ установлен вместе с пакетом (mpc) - Минималистичный интерфейс командной строки для MPD " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_mpd  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_mpd" =~ [^10] ]]
do
    :
done
if [[ $i_mpd == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_mpd == 1 ]]; then
  echo ""
  echo " Установка Music Player Daemon (MPD) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)   
sudo pacman -S --noconfirm --needed mpd # Гибкое, мощное серверное приложение для воспроизведения музыки https://archlinux.org/packages/extra/x86_64/mpd/ ; https://github.com/MusicPlayerDaemon/MPD
sudo pacman -S --noconfirm --needed mpc  # Минималистичный интерфейс командной строки для MPD ; https://www.musicpd.org/clients/mpc/ ; https://archlinux.org/packages/extra/x86_64/mpc/ ; 22 декабря 2023 г., 19:49 UT
# sudo pacman -S --noconfirm --needed ncmpcpp  # Функциональный клиент MPD - Практически точный клон ncmpc с некоторыми новыми функциями https://wiki.archlinux.org/title/Ncmpcpp
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

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
  mkdir ~/CozyAudioBooks  # Директория для работы с аудиокнигами
  mkdir ~/CozyAudioBooks/audiobooks
######## Зависимости ############
sudo pacman -Syy  # обновление баз пакмэна (pacman)
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
elif [[ $in_spotify == 2 ]]; then
  echo ""    
  echo " Установка Установка Spotify (spotify) + дополнения "
# sudo pacman -S --help
# sudo pacman -Syy  # обновление баз пакмэна (pacman)
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_gmtp  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
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
echo -e "${BLUE}:: ${NC}Установить Smplayer (smplayer) - Мультимедиа плеер?"
echo -e "${MAGENTA}:: ${BOLD}SMPlayer — мультимедиа плеер для Linux с простым интерфейсом. Поддерживаются практически все видео и аудио форматы файлов. SMPlayer поддерживает множество функций. Например, можно повернуть видео на 90 градусов прямо во время просмотра, можно изменить скорость просмотра видео, уменьшить или увеличить размер, изменить соотношение сторон видео, применить различные эффекты, настроить звук, субтитры, сделать скриншот из видео и многое другое. ${NC}"
echo " Домашняя страница: https://www.smplayer.info/ ; (https://archlinux.org/packages/extra/x86_64/smplayer/). "  
echo -e "${MAGENTA}:: ${BOLD}Интерфейс у SMPlayer простой и удобный. Главное окно содержит две панели управления — сверху и снизу и главное меню в верхней части окна. Отдельно можно включить показ списка воспроизведения. Он может размещаться внизу внутри главного окна, а также как отдельное окно на экране. Поддерживаются скины (темы оформления) и темы иконок. Одной из интересных функций программы является то, что для каждого файла она запоминает позицию, на которой вы закончили его просмотр. То есть, если, например, вы закрыли видео-файл, а на следующий день снова его открыли, то SMPlayer начнет проигрывание с той позиции, на которой вы закрыли файл в прошлый раз.  ${NC}"
echo " При установке SMPlayer сразу устанавливаются все необходимые кодеки. При установке SMPlayer сразу устанавливаются все необходимые кодеки, что очень удобно. SMPlayer основан на программе MPlayer. Фактически он является интерфейсом для проигрывателя MPlayer (frontend оболочкой). MPlayer (The Movie Player) — мультимедиа проигрыватель для Linux. MPlayer поддерживает очень большое количество как музыкальных, так и видео форматов. «Голая» версия программы не имеет графического интерфейса, а работает через консоль. Исходный код: Open Source (открыт); Языки программирования: C; C++; Библиотеки: Qt; Лицензия: GNU GPL v2; Приложение переведено на русский язык. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_smplayer  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_smplayer" =~ [^10] ]]
do
    :
done
if [[ $i_smplayer == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_smplayer == 1 ]]; then
  echo ""
  echo " Установка Smplayer (smplayer) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)   
# sudo pacman -S --noconfirm --needed smplayer smplayer-skins smplayer-themes  # Медиаплеер со встроенными кодеками, который может воспроизводить практически все видео и аудио форматы; Скины для SMPlayer; Темы для SMPlayer; *** Приложение, позволяющее просматривать, искать и воспроизводить видео на YouTube - отсутствует.
sudo pacman -S --noconfirm --needed mplayer # Медиаплеер для Linux ; http://www.mplayerhq.hu/ ; https://archlinux.org/packages/extra/x86_64/mplayer/ ; June 21, 2024, 7:51 p.m. UTC
sudo pacman -S --noconfirm --needed yt-dlp  # Форк youtube-dl с дополнительными функциями и исправлениями ; https://archlinux.org/packages/extra/any/yt-dlp/ ; https://github.com/yt-dlp/yt-dlp ; Aug. 8, 2024, 3:05 p.m. UTC
sudo pacman -S --noconfirm --needed smplayer  #  Медиаплеер со встроенными кодеками, который может воспроизводить практически все видео и аудио форматы ; https://www.smplayer.info/ ; https://archlinux.org/packages/extra/x86_64/smplayer/ ; May 20, 2024, 9:11 a.m. UTC
sudo pacman -S --noconfirm --needed smplayer-skins  # Скины для SMPlayer ; https://smplayer.info/ ; https://archlinux.org/packages/extra/any/smplayer-skins/ ; July 13, 2024, 9:54 p.m. UTC
sudo pacman -S --noconfirm --needed smplayer-themes  # Темы для SMPlayer ; https://www.smplayer.info/ ; https://archlinux.org/packages/extra/any/smplayer-themes/ ; July 13, 2024, 9:54 p.m. UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить VLC (vlc) - Многоплатформенный Проигрыватель для Linux?"
echo -e "${MAGENTA}:: ${BOLD}VLC — универсальный проигрыватель аудио и видео файлов для Linux. VLC media player — VLC — бесплатный и свободный кросс-платформенный медиаплеер и медиаплатформа с открытым исходным кодом. VLC воспроизводит множество мультимедийных файлов, а также DVD, Audio CD, VCD и сетевые трансляции. Изначально программа называлась VideоLAN, но была переименована. Полное название: VLC media player. ${NC}"
echo " Домашняя страница: https://www.videolan.org/vlc/ ; (https://archlinux.org/packages/extra/x86_64/vlc/). "  
echo -e "${MAGENTA}:: ${BOLD}Возможности: Поддержка аппаратного декодирования. Поддержка практически всех видео и аудио форматов. Применение видео и аудио фильтров и эффектов. Поддержка субтитров. Изменение скорости воспроизведения. Выбор аудиорожки. Синхронизация субтитров. Синхронизация дорожек. Выбор режима стерео. Устранение чересстрочности (деинтерлейсинг). Создание снимков (скриншотов) видео. Поддержка расширений (модулей). Настройка интерфейса (изменение элементов панели инструментов). Проигрывание поврежденных файлов. И другие. ${NC}"
echo " Поддерживаемые форматы: Форматы: MPEG (ES,PS,TS,PVA,MP3); AVI; ASF / WMV / WMA; MP4 / MOV / 3GP; OGG / OGM / Annodex; Matroska (MKV); Real; WAV (including DTS); Raw Audio: DTS; AAC; AC3/A52; Raw DV; FLAC; FLV (Flash); MXF; Nut; Standard MIDI / SMF; Creative™ Voice. " 
echo " Видео кодеки: MPEG-1/2; DivX® (1/2/3/4/5/6); MPEG-4 ASP, XviD; 3ivX D4; H.261; H.263 / H.263i; H.264 / MPEG-4 AVC; Cinepak; Theora; Dirac / VC-2; MJPEG (A/B); WMV 1/2; WMV 3 / WMV-9 / VC-1; Sorenson 1/3; DV; On2 VP3/VP5/VP6; Indeo Video v3 (IV32); Real Video (1/2/3/4). "
echo " Аудио кодеки: MPEG Layer 1/2; MP3 - MPEG Layer 3; AAC - MPEG-4 part3; Vorbis; AC3 - A/52; E-AC-3; MLP / TrueHD>3; DTS; WMA 1/2; WMA 3; FLAC; ALAC; Speex; Musepack / MPC; ATRAC 3; Wavpack; Mod; TrueAudio; APE; Real Audio; Alaw/µlaw; AMR (3GPP); MIDI; LPCM; ADPCM; QCELP; DV Audio; QDM2/QDMC; MACE. "
echo " Специальные форматы: DVD; Text files (MicroDVD SubRIP SubViewer SSA1-5 SAMI VPlayer); Closed captions; Vobsub; Universal Subtitle Format (USF); SVCD / CVD; DVB; OGM; CMML; Kate; ID3 tags; APEv2; Vorbis comment. "
echo " Input Media: UDP/RTP Unicast; UDP/RTP Multicast; HTTP / FTP; MMS; TCP/RTP Unicast; DCCP/RTP Unicast; File; DVD Video; Video CD / VCD; SVCD; Audio CD (no DTS-CD); DVB (Satellite Digital TV Cable TV); MPEG encoder; Video acquisition. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_vlc  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_vlc" =~ [^10] ]]
do
    :
done
if [[ $i_vlc == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_vlc == 1 ]]; then
  echo ""
  echo " Установка VLC (vlc) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)    
sudo pacman -S --noconfirm --needed vlc  # Многоплатформенный проигрыватель MPEG, VCD / DVD и DivX
# sudo pacman -S --noconfirm --needed playerctl  # Контроллер и библиотека медиаплеера mpris для Spotify, VLC, Audacious, BMP, XMMS2 и других. https://github.com/altdesktop/playerctl ; https://archlinux.org/packages/extra/x86_64/playerctl/ ; https://www.videolan.org/ ; https://www.videolan.org/vlc/download-archlinux.html ; Aug. 7, 2024, 2:52 a.m. UTC
#sudo pacman -S --noconfirm --needed syncplay  # Синхронизируйте просмотр фильмов на mplayer2, vlc, mpv и mpc-hc на многих компьютерах ; http://syncplay.pl/ ; https://archlinux.org/packages/extra/any/syncplay/ ; 29 апреля 2024 г., 22:37 UTC
#sudo pacman -S --noconfirm --needed phonon-qt6-vlc  # Бэкэнд Phonon VLC для Qt6 ; https://community.kde.org/Phonon ; https://archlinux.org/packages/extra/x86_64/phonon-qt6-vlc/ ; Ноябрь 10, 2023, 13:56 по всемирному координированному времени
#sudo pacman -S --noconfirm --needed phonon-qt5-vlc  # Бэкэнд Phonon VLC для Qt5 ; https://community.kde.org/Phonon ; https://archlinux.org/packages/extra/x86_64/phonon-qt5-vlc/ ; Ноябрь 10, 2023, 13:56 по всемирному координированному времени
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить дополнения для проигрыватель VLC, если таковой был вами установлен?" 
echo -e "${MAGENTA}:: ${BOLD}В сценарии (скрипте) представлены несколько утилит: ${NC}"
echo " VLC TuneIn Radio (vlc-tunein-radio) - скрипт (сценарий) LUA Service Discovery для VLC 2.x и 3.x, предназначен для прослушивания интернет-радиостанций в операционных системах Linux. " 
echo " VLC Pause Click Plugin (vlc-pause-click-plugin) - плагин для VLC, который приостанавливает / воспроизводит видео по щелчку мыши. Может быть настроена для хорошей работы с двойным щелчком в полноэкранном режиме, включив в настройках параметр - Предотвратить запуск паузы / воспроизведения при двойном щелчке. По умолчанию вместо этого он приостанавливается при каждом щелчке." 
echo -e "${CYAN}:: ${NC}Установка VLC TuneIn Radio (vlc-tunein-radio), и VLC Pause Click Plugin (vlc-pause-click-plugin) проходит через сборку из исходников. То есть установка производиться с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/packages/vlc-tunein-radio/), (https://aur.archlinux.org/packages/vlc-pause-click-plugin/) - собирается и устанавливается. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " vlc_plugin  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
yay -S vlc-tunein-radio --noconfirm  # Скрипт TuneIn Radio LUA для VLC 2.x,3.x ; https://aur.archlinux.org/vlc-tunein-radio.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/diegofn/TuneIn-Radio-VLC ; https://aur.archlinux.org/packages/vlc-tunein-radio
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
yay -S vlc-pause-click-plugin --noconfirm  # Плагин для VLC, который приостанавливает / воспроизводит видео по щелчку мыши ; https://aur.archlinux.org/vlc-pause-click-plugin.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/nurupo/vlc-pause-click-plugin ; https://aur.archlinux.org/packages/vlc-pause-click-plugin
#git clone https://aur.archlinux.org/vlc-pause-click-plugin.git  # Плагин для VLC, который приостанавливает / воспроизводит видео по щелчку мыши
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
yay -S vlc-plugin-ytdl-git --noconfirm  # Плагин VLC для youtube-dl ; https://aur.archlinux.org/vlc-plugin-ytdl-git.git (только для чтения, нажмите, чтобы скопировать) ; https://git.remlab.net/gitweb/?p=vlc-plugin-ytdl.git;a=blob;f=README ; https://aur.archlinux.org/packages/vlc-plugin-ytdl-git ; Конфликты:  vlc-plugin-ytdl
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
#-----------------------------
# https://github.com/diegofn/TuneIn-Radio-VLC
# https://github.com/nurupo/vlc-pause-click-plugin
# Делаем Play и Pause кликом мыши в плеере vlc - Видео
# https://www.youtube.com/watch?v=G05VGD2_jGo&t=1s
##############################################

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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
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
echo " Возможности: Воспроизведение в реальном времени последовательностей изображений и фильмов. Поддержка стандартных отраслевых форматов файлов, включая Cineon, DPX, OpenEXR и QuickTime. Утилиты командной строки для пакетной обработки. Исходный код: Open Source (предоставляется по открытой лицензии BSD); Языки программирования: C; C++; Доступно для Linux, Apple macOS и Microsoft Windows. " 
echo -e "${CYAN}:: ${NC}Установка DJV Imaging (djv) (djv-git) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_audacity  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed audacity  # Программа, позволяющая манипулировать сигналами цифрового звука https://archlinux.org/packages/extra/x86_64/audacity/ ; https://www.audacityteam.org/
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
sudo pacman -S --noconfirm --needed lmms  # Linux MultiMedia Studio — программа для создания музыки на компьютере ; https://lmms.io/ ; https://github.com/LMMS/lmms ; https://archlinux.org/packages/extra/x86_64/lmms/ 
echo " Установка утилит (пакетов) выполнена "
fi

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
echo -e "${BLUE}:: ${NC}Установить Ardour (ardour) - Запись и обработка звука (редактирование и микширование) звука?"
echo -e "${MAGENTA}:: ${BOLD}Ardour — программа для профессиональной записи и обработки звука. Поддерживает запись звука с различных источников, микширование, редактирование, мастеринг, плагины и так далее. Ardour — это открытый исходный код, совместная работа всемирной команды, включающей музыкантов, программистов и профессиональных звукорежиссеров. Разработка прозрачна — любой может наблюдать за нашей работой по мере ее выполнения. ${NC}"
echo " Домашняя страница: https://ardour.org/ ; (https://archlinux.org/packages/extra/x86_64/ardour/). "  
echo -e "${MAGENTA}:: ${BOLD}Основная группа пользователей Ardour: люди, которые хотят записывать, редактировать, микшировать и мастерить аудио и MIDI-проекты. Когда вам нужен полный контроль над вашими инструментами, когда ограничения других проектов мешают, когда вы планируете потратить часы или дни на работу над сессией, Ardour поможет вам сделать так, как вы хотите. Быть лучшим инструментом для записи талантливых исполнителей на настоящих инструментах всегда было главным приоритетом для Ardour. Вместо того, чтобы сосредоточиться на электронных и поп-музыкальных идиомах, Ardour выходит за рамки, чтобы поощрять творческий процесс оставаться там, где он всегда был: музыкант, играющий на тщательно спроектированном и хорошо сделанном инструменте. Точная синхронизация сэмплов и общее управление транспортом с помощью инструментов воспроизведения видео позволяют Ardour предоставлять быструю и естественную среду для создания и редактирования саундтреков к кино- и видеопроектам. Аранжируйте аудио и MIDI, используя те же инструменты и тот же рабочий процесс. Используйте внешние аппаратные синтезаторы или программные инструменты в качестве источников звука. От звукового дизайна до электроакустической композиции и плотного многодорожечного редактирования MIDI, Ardour может помочь. Список источников Ardour позволяет легко организовывать и перемещаться даже по большим объемам клипов и лент. Несколько режимов ряби делают редактирование как простых двухмикрофонных эпизодов, так и функций с большим объемом записи на ленту легким. Интегрированный поиск freesound.org обеспечивает легкий доступ к тысячам клипов и джинглов. Любое количество дорожек и шин. Нелинейный монтаж. Неразрушающая (и разрушающая!) запись. Любая битовая глубина, любая частота дискретизации. Десятки форматов файлов. ${NC}"
echo " Дополнительные возможности Ardour включают: Запись звука. Многоканальная запись. Наложение эффектов. Микширование. Произвольное количество звуковых дорожек. Редактирование аудио. Обрезка, перемещение фрагментов, изменение темпа, копирование, вставка, удаление, выравнивание и другие действия. Неограниченная история действий с возможностью повтора и отмены. История сохраняется после закрытия проекта. Импорт и экспорт звуковых файлов. Поддержка MIDI-дорожек. Работа с аудио-дорожками видео. Извлечение звуковой дорожки из видео. Контроль синхронизации видео и звука. Поддержка плагинов. Исходный код: Open Source (открыт); Языки программирования: C++; Библиотеки: GTK; Лицензия: GNU GPL. Доступна для Linux, Windows и MacOS. " 
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed ardour  # Профессиональная цифровая звуковая рабочая станция ; https://ardour.org/ ; https://archlinux.org/packages/extra/x86_64/ardour/ ; 15 апреля 2024 г., 21:34 UTC ; Обеспечивает: ladspa-host, lv2-host, vamp-host, vst-host, vst3-host
sudo pacman -S --noconfirm --needed harvid  # HTTP Ardour Video Daemon (harvid декодирует неподвижные изображения из видеофайлов и передает их через HTTP) ; https://x42.github.io/harvid/ ; https://archlinux.org/packages/extra/x86_64/harvid/ ; June 21, 2024, 7:50 p.m. UTC
# Предполагаемое применение harvid — эффективное предоставление данных с точностью до кадра и работа в качестве кэша второго уровня для рендеринга временной шкалы видео в Ardour , но этим он не ограничивается: у него есть приложения для любой задачи, требующей высокопроизводительного процессора извлечения изображений с точностью до кадра.
# При использовании с Ardour, Ardour автоматически запустит сервер при открытии видео. Вы также можете запустить harvid вручную. В любом случае он будет по умолчанию прослушивать запросы на http://localhost:1554/, и вы сможете взаимодействовать с ним с помощью любого веб-браузера.
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить SoundRecorder (gnome-sound-recorder) или (krecorder) - Простой и современный диктофон?"
echo -e "${MAGENTA}:: ${BOLD}SoundRecorder (GNOME Sound Recorder) — простое и легкое приложение для записи звука, разработанное специально для среды рабочего стола GNOME , которая широко используется в различных дистрибутивах Linux. Он предлагает нам простой способ захвата звука с помощью микрофона системы или других доступных источников входного сигнала. ${NC}"
echo " Домашняя страница: https://wiki.gnome.org/Apps/SoundRecorder ; (https://apps.kde.org/krecorder/ ; https://archlinux.org/packages/extra/any/gnome-sound-recorder/). "  
echo -e "${MAGENTA}:: ${BOLD}Recorder KDE — простое кроссплатформенное приложение для записи звука. Если вы хотите записать голос за кадром через микрофон вашего компьютера, вы можете использовать GNOME Sound Recorder или Audacity. Использовать GNOME Sound Recorder легко, но ему не хватает функций. Audacity может показаться сложным поначалу, но у него достаточно функций для записи профессионального уровня. Однако я не буду вдаваться в эти подробности в этом руководстве. GNOME Sound Recorder работает с микрофоном. Есть еще один инструмент под названием Audio Recorder, и вы можете использовать его для записи потоковой музыки (из Spotify, YouTube, интернет-радио, Skype и большинства других источников) помимо микрофонного ввода. ${NC}"
echo " После установки вы сможете найти его в системном меню и начать работу оттуда. Прежде чем начать использовать его, убедитесь, что в системных настройках выбран правильный источник входного сигнала. Нажмите на кнопку записи, и запись звука начнется мгновенно. Во время записи у вас есть возможность приостановить, остановить или отменить запись. Ваши записи сохраняются и доступны из самого интерфейса приложения. Нажмите на сохраненные записи, чтобы выделить их. Вы можете воспроизвести записи повторно или удалить их. Вы можете сохранить их в другом месте, нажав кнопку сохранения/загрузки. Вы также можете переименовать записи, используя кнопку редактирования. Вы можете выбрать формат записи MP3, FLAC и еще пару форматов. Более того, мы можем изменить настройки, нажав на опцию «Настройки» в раскрывающемся списке в правом верхнем углу. В настройках можно настроить различные параметры, такие как предпочтительный формат экспорта или режим по умолчанию. По умолчанию GNOME Sound Recorder экспортирует аудиозаписи в формате Ogg Vorbis, но также поддерживает MP3, FLAC, NOV и Opus . Кроме того, мы можем регулировать громкость микрофона и системы. Это дает нам простой способ контролировать уровень громкости каждого во время записи. GNOME Sound Recorder имеет ряд важных функций: простой и удобный интерфейс предлагающий всего две опции:; поддержка нескольких аудиоформатов; режимы записи моно и стерео." 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить SoundRecorder GNOME (gnome-sound-recorder),     2 - Установить Recorder KDE (krecorder),

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
sudo pacman -S --noconfirm --needed gnome-sound-recorder  #  Утилита для простой записи звука с рабочего стола GNOME ; https://wiki.gnome.org/Apps/SoundRecorder ; https://archlinux.org/packages/extra/any/gnome-sound-recorder/ ; 12 июля 2024 г., 16:26 UTC
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_recorder == 2 ]]; then
  echo ""
  echo " Установка Recorder (krecorder) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
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
echo " ID_MEDIA_PLAYER свойство udev на устройстве, которое указывает на файл mpi. Приложения, которым нужна подробная информация о медиаплеерах (например, поддерживаемые ими аудиоформаты), должны проанализировать этот файл и извлечь из него все необходимое. Информация о медиаплеере не включена напрямую в базу данных udev, потому что она нужна не многим приложениям, и потому что мы не хотели повторять те же ошибки, что и HAL, и включать все в свою базу данных. Данные хранятся в файлах *.mpi (в формате ini-файлов), вместе с правилами udev для идентификации этих устройств. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_mediain  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_mediainfo  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_easytag  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
sudo pacman -S --noconfirm --needed easytag  # Простое приложение для просмотра и редактирования тегов в аудиофайлах ; https://wiki.gnome.org/Apps/EasyTAG ; https://archlinux.org/packages/extra/x86_64/easytag/
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
    1 - Да установить Kid3 (KDE),   2 - Да установить Kid3 (Qt) (без KDE зависимостей),  

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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_aegisub  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_subtitleeditor  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
sudo pacman -S --noconfirm --needed subtitleeditor  # Инструмент GTK+3 для редактирования субтитров для GNU/Linux/*BSD ; https://kitone.github.io/subtitleeditor/ ; https://archlinux.org/packages/extra/x86_64/subtitleeditor/
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_gaupol  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_qnapi  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_subdl  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_soundjuicer  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_mp3splt  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
############ libmp3splt #############
yay -S libmp3splt --noconfirm  # Библиотека для разделения файлов mp3 и ogg без декодирования ; https://aur.archlinux.org/libmp3splt.git (только для чтения, нажмите, чтобы скопировать) http://mp3splt.sourceforge.net/ ; https://aur.archlinux.org/packages/libmp3splt
#git clone https://aur.archlinux.org/libmp3splt.git
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
#git clone https://aur.archlinux.org/mp3splt.git
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
sudo pacman -S --noconfirm --needed mp3splt-gtk  # Разделить файлы mp3 и ogg без декодирования ; http://mp3splt.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/mp3splt-gtk/
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_cdrdao  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed cdrdao  # Записывает аудио / данные CD-R в режиме disk-at-once (DAO) ; http://cdrdao.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/cdrdao/ ; https://cdrdao.sourceforge.net/gcdmaster/ ; 12 июля 2024 г., 2:07 UTC
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_dvdstyler  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed cdrtools  # Портативное программное обеспечение командной строки для записи CD/DVD/BluRay ; https://sourceforge.net/projects/cdrtools/ ; https://archlinux.org/packages/extra/x86_64/cdrtools/
sudo pacman -S --noconfirm --needed dvd+rw-tools  # инструменты для записи DVD ; http://fy.chalmers.se/~appro/linux/DVD+RW ; https://archlinux.org/packages/extra/x86_64/dvd+rw-tools/
sudo pacman -S --noconfirm --needed dvdauthor  # Инструменты для создания DVD ; http://dvdauthor.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/dvdauthor/
sudo pacman -S --noconfirm --needed ffmpeg4.4  # Комплексное решение для записи, конвертации и потоковой передачи аудио и видео ; https://ffmpeg.org/ ; https://archlinux.org/packages/extra/x86_64/ffmpeg4.4/
sudo pacman -S --noconfirm --needed wxsvg  # Библиотека C++ для создания, обработки и рендеринга файлов SVG ; http://wxsvg.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/wxsvg/
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_openshot  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
  sudo pacman -S --noconfirm --needed openshot  # Бесплатный видеоредактор с открытым исходным кодом, удостоенный наград ; https://www.openshot.org/ ; https://archlinux.org/packages/extra/any/openshot/
  sudo pacman -S --noconfirm --needed frei0r-plugins  # Коллекция плагинов видеоэффектов, которые можно использовать с различным программным обеспечением для редактирования и обработки видео ; https://frei0r.dyne.org/ ; https://archlinux.org/packages/extra/x86_64/frei0r-plugins/
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_handbrake  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
  sudo pacman -S --noconfirm --needed handbrake  # Многопоточный видео транскодер ; https://handbrake.fr/ ; https://archlinux.org/packages/extra/x86_64/handbrake/
  echo ""
  echo " Установка утилит (пакетов) выполнена "
fi

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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_kdenlive  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
sudo pacman -S --noconfirm --needed kdenlive  # Нелинейный видеоредактор для Linux, использующий видеофреймворк MLT ; https://apps.kde.org/kdenlive/ ; https://archlinux.org/packages/extra/x86_64/kdenlive/
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
sudo pacman -S --noconfirm --needed avidemux-cli  # Графический инструмент для редактирования видео (фильтрация/перекодирование/разделение) с графическим интерфейсом (cli) ; http://fixounet.free.fr/avidemux/ ; https://archlinux.org/packages/extra/x86_64/avidemux-cli/ ; 21 июня 2024 г., 19:50 UTC ; https://archlinux.org/packages/extra/x86_64/avidemux-qt/ ; https://archlinux.org/packages/extra/x86_64/avidemux/
#sudo pacman -Rcns avidemux-cli  # Чтобы удалить avidemux-cli в Arch Linux
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_avidemux == 2 ]]; then
  echo ""
  echo " Установка Avidemux (avidemux-qt) "
sudo pacman -Syy  # обновление баз пакмэна (pacman) 
########## Avidemux-(QT version) ############
sudo pacman -S --noconfirm --needed avidemux-qt  # Графический инструмент для редактирования видео (фильтрация/перекодирование/разделение) - Qt GUI ; http://fixounet.free.fr/avidemux/ ; https://archlinux.org/packages/extra/x86_64/avidemux-qt/ ; 21 июня 2024 г., 19:50 UTC ; Заменяет: avidemux-gtk ; https://archlinux.org/packages/extra/x86_64/avidemux/
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
###########

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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_soundconv  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
sudo pacman -S --noconfirm --needed soundconverter  # Простое приложение-конвертер звука для GNOME ;https://soundconverter.org/ ; https://archlinux.org/packages/extra/any/soundconverter/
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_ciano  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_transmageddon  # sends right after the keypress; # отправляет сразу после нажатия клавиши
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
sudo pacman -S --noconfirm --needed transmageddon  # Простое приложение на Python для перекодирования видео в форматы, поддерживаемые GStreamer ; http://www.linuxrising.org/ ; https://archlinux.org/packages/extra/any/transmageddon/ ; https://github.com/tvataire/transmageddon
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
    1 - Установить FF Multi Converter (ffmulticonverter),   2 - Установить FF Multi Converter (ffmulticonverter-git),  

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
yay -S ffmulticonverter --noconfirm  # Конвертируйте аудио, видео, изображения и файлы документов между всеми популярными форматами ; https://aur.archlinux.org/ffmulticonverter.git (только для чтения, нажмите, чтобы скопировать) ; https://sites.google.com/site/ffmulticonverter/ ; https://aur.archlinux.org/packages/ffmulticonverter ; Конфликты: с ffmulticonverter-git ; https://github.com/ilstam/FF-Multi-Converter
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
yay -S ffmulticonverter-git --noconfirm  # Конвертируйте аудио, видео, изображения и файлы документов между всеми популярными форматами ; https://aur.archlinux.org/ffmulticonverter-git.git (только для чтения, нажмите, чтобы скопировать) ; https://sites.google.com/site/ffmulticonverter/ ; https://aur.archlinux.org/packages/ffmulticonverter-git ; Конфликты: с ffmulticonverter ; https://github.com/ilstam/FF-Multi-Converter
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