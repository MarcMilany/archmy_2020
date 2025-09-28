#!/usr/bin/env bash
# Install script Mugshot
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget 
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 
apptitle="Arch Linux Fast Install v2.5 LegasyBIOS - Version: 2025.07.31.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

MOC="russian"  # Installer default language (Язык установки по умолчанию)

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
###############

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

echo ""    
echo " Обновим базы данных пакетов... "
###  sudo pacman -Sy
sudo pacman -Syy  # обновление баз пакмэна (pacman) 
echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

clear
echo -e "${MAGENTA}
  <<< Установка утилит (пакетов) Музыкальных проигрывателей командной строки (консоли) в Archlinux 🎵🎶 🎼 🎤 🎧 >>> ${NC}"
# Installing utilities (packages) Command-line music players (consoles) in Archlinux
echo ""
echo -e "${YELLOW}==> Примечание! ${BOLD} *Музыкальные проигрыватели командной строки потребляют меньше системных ресурсов, чем графические проигрыватели. Вот некоторые из них которые вам следует рассмотреть для установки.
    В Linux есть мощная командная строка, и это важная утилита для выполнения основных операций в операционной системе Linux. Это особенно полезно для административных задач системного уровня, таких как установка или удаление программного обеспечения, операции с папками или файлами, управление пользователями и многое другое.
    Командная строка Linux также предоставляет уникальную и не очень известную функцию музыкального проигрывателя. Вы можете слушать свою любимую музыку с помощью музыкальных проигрывателей, основанных на командной строке.
    Эти музыкальные проигрыватели работают быстро и потребляют меньше памяти по сравнению с приложениями с графическим интерфейсом. Итак, давайте рассмотрим некоторые из лучших вариантов для музыкальных проигрывателей командной строки. ${NC}"
sleep 09

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить MOC (Music On Console) (moc-pulse) (moc-pulse-svn) — Консольный аудиоплеер?"
echo -e "${YELLOW}==> Примечание! ${BOLD}*Хотите воспроизводить локальную музыку из терминала или командной строки в Linux? С помощью MOC это довольно просто! Проект был начат Дэмианом Пьетрасом, а в настоящее время разработка поддерживается Джоном Фицджеральдом. Разрабатывается с целью быть мощным и простым в использовании, внешним видом и некоторым расположением окон похож на интерфейс консольного файлового менеджера Midnight Commander. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}MOC (Music On Console) — это лёгкий, минималистичный консольный аудиоплеер для LINUX/UNIX-подобных операционных систем, основанный на библиотеке ncurses, похожий на MPD. Он основан на интерфейсе командной строки, и вы можете использовать клавиатуру для просмотра ваших аудиофайлов. Вы можете перейти в каталог и воспроизвести аудиофайлы оттуда с помощью MOC. Он предоставляет простой и удобный интерфейс командной строки с деревом папок слева, списком воспроизведения справа и текущим воспроизведением внизу. MOC работает гладко, несмотря на нагрузку на систему или ввод-вывод, потому что, по словам команды разработчиков, он *Использует выходной буфер в отдельном потоке. Это обеспечивает воспроизведение без пауз, поскольку следующий воспроизводимый файл достигается во время воспроизведения текущего файла. MOC поддерживает все основные аудиоформаты, а также работает в фоновом режиме, чтобы вы могли выполнять другие задачи в своей системе. Вы можете нажать кнопку Q, чтобы свернуть проигрыватель MOC, а также изменить его тему, используя различные цветовые схемы. Приложение потребляет мало памяти, поэтому вы не будете испытывать никаких задержек во время воспроизведения. Для улучшения вашего музыкального восприятия в нем также есть эквалайзер и микшер. Кроме того, MOC позволяет назначать сочетания клавиш для различных операций музыкального проигрывателя. И поскольку он имеет открытый исходный код, он бесплатный для всех. Этот проект Лицензируется под GPL-2.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://moc.daper.net/ ; (https://github.com/jonsafari/mocp?tab=readme-ov-file#keyboard-shortcuts ; https://aur.archlinux.org/packages/moc-pulse ; https://aur.archlinux.org/packages/moc-pulse-svn ; https://github.com/wimstefan/mocp-themes ; https://aur.archlinux.org/packages/mocp-themes-git). "
echo -e "${BLUE}:: ${NC}Функции: Главные особенности MOC: Вы будете удивлены, насколько эффективен музыкальный проигрыватель MOC. Встроенный простой эквалайзер. Микшер, который можно подключить к внешнему микшеру. Варианты темы. Полностью настраиваемое сопоставление клавиш. Поддержка интернет-потоков. Поиск в меню (списке воспроизведения или каталоге) как Ms в Midnight Commander. Поиск по плейлистам и каталогам. Преобразование набора символов с помощью iconv(). Типы выходов JACK , ALSA , SNDIO и OSS. Поддерживаются интернет-трансляции (Icecast, Shoutcast). Поддерживаемые форматы файлов: mp3, Ogg Vorbis, FLAC, Musepack, Speex, WAVE, AIFF, AU (и другие менее популярные форматы, поддерживаемые libsndfile. Поддержка новых форматов находится в стадии разработки. "
echo -e "${CYAN}:: ${NC}Проигрыватель прост в настройке, есть поддержка ALSA, OSS или JACK. Поддерживает команды оболочки, имеет легконастраиваемые цветовые схемы, настройка интерфейса (к примеру, можно изменить расположение панелей по своему вкусу). MOC может работать только с одним плей-листом (который поддерживает формат m3u). Достаточно выбрать файл в каталоге с помощью меню, аналогичного Midnight Commander, и MOC начнёт воспроизводить все файлы в этом каталоге, начиная с выбранного. Нет необходимости создавать плейлисты, как в других плеерах. Если вы хотите объединить несколько файлов из одного или нескольких каталогов в один плейлист, вы можете это сделать. Плейлист будет сохранен между прослушиваниями, или вы можете сохранить его в формате m3u для загрузки в любое время. MOC воспроизводится плавно, независимо от нагрузки на систему или систему ввода-вывода, поскольку использует выходной буфер в отдельном потоке. Задержек между файлами не возникает, поскольку следующий воспроизводимый файл предварительно кэшируется во время воспроизведения текущего. *Нужна консоль, где запущен MOC, для более важных дел? Нужно закрыть эмулятор X-терминала? Не нужно останавливать игру — просто нажмите Q, и интерфейс отсоединится, а сервер останется работающим. Вы можете подключить его позже или подключить один интерфейс в консоли, а другой в эмуляторе X-терминала — не нужно переключаться только для воспроизведения другого файла. Бинарный файл носит название «mocp» для запуска «MOC Player», так как существует конфликт с утилитой Qt, которая имеет схожее название «moc». Тем, кто не знаком с CLI MOC, он может показаться утомительным в использовании, но поверьте, это не так. Запустите его в терминале, выполнив команду: $ mocp . С помощью клавиатуры перейдите в папку с музыкой и нажмите Enter , чтобы начать воспроизведение трека. MOC автоматически воспроизведёт все треки из этой папки, поэтому вам не нужно создавать плейлист. Однако у вас есть возможность объединить музыкальные файлы из разных каталогов в один плейлист, и даже если ваши плейлисты будут автоматически сохраняться, вы можете сохранить их как файлы m3u и загружать, когда захотите. "
echo -e "${CYAN}:: ${NC}Установка MOC (Music On Console) (moc-pulse) и (moc-pulse-svn), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/moc-pulse.git), (https://aur.archlinux.org/moc-pulse-svn.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить MOC (Music On Console) (moc-pulse),   2 - *Установить MOC (Music On Console) (moc-pulse-svn),

    0 - НЕТ - Пропустить установку: " in_moc  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_moc" =~ [^120] ]]
do
    :
done
if [[ $in_moc == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_moc == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) MOC (Music On Console) (moc-pulse)  "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed libid3tag  # Библиотека манипуляции тегами ID3 ; https://archlinux.org/packages/extra/x86_64/libid3tag/ ; https://codeberg.org/tenacityteam/libid3tag ; 2024-03-07 11:57 UTC
sudo pacman -S --noconfirm --needed lib32-libid3tag  # Библиотека для id3-тегирования, lib32 ; https://archlinux.org/packages/multilib/x86_64/lib32-libid3tag/ ; https://www.underbit.com/products/mad/ ; 2024-05-04 11:02 UTC
sudo pacman -S --noconfirm --needed faad2  # (необязательно) – для использования плагина aac ;  Бесплатный декодер Advanced Audio (AAC) ; https://archlinux.org/packages/extra/x86_64/faad2/ ; https://github.com/knik0/faad2 ; Обеспечивает: faad, libfaad.so=2-64, libfaad_drm.so=2-64 ; 2025-03-04 09:01 UTC
sudo pacman -S --noconfirm --needed ffmpeg4.4  # (необязательно) – для использования плагина ffmpeg ; Комплексное решение для записи, конвертации и потоковой передачи аудио и видео ; https://ffmpeg.org/ ; https://archlinux.org/packages/extra/x86_64/ffmpeg4.4/ ; Обеспечивает: libavcodec.so=58-64, libavdevice.so=58-64, libavfilter.so=7-64, libavformat.so=58-64, libavutil.so=56-64 ; 2025-08-14 20:44 UTC
sudo pacman -S --noconfirm --needed libmodplug  # (необязательно) — для использования плагина modplug ; Библиотека воспроизведения MOD ; https://archlinux.org/packages/extra/x86_64/libmodplug/ ; http://modplug-xmms.sourceforge.net/ ; 2024-07-12 20:59 UTC
sudo pacman -S --noconfirm --needed lib32-libmodplug  # (необязательно) — для использования плагина modplug ; Библиотека воспроизведения MOD ; https://archlinux.org/packages/multilib/x86_64/lib32-libmodplug/ ; http://modplug-xmms.sourceforge.net/ ; 2024-09-07 10:12 UTC
sudo pacman -S --noconfirm --needed libmpcdec  # (необязательно) – для использования плагина musepack ; Библиотека декодирования MusePack ; https://archlinux.org/packages/extra/x86_64/libmpcdec/ ; https://musepack.net/ ; 2024-07-07 22:05 UTC ; Musepack — это формат сжатия аудио с акцентом на высокое качество. Он не является форматом сжатия без потерь, но разработан для обеспечения прозрачности, поэтому вы не услышите разницы между исходным WAV-файлом и гораздо меньшим MPC-файлом.
sudo pacman -S --noconfirm --needed libsamplerate # (необязательно) – для передискретизации звука ; Библиотека преобразования частоты дискретизации звука ; https://archlinux.org/packages/extra/x86_64/libsamplerate/ ; https://libsndfile.github.io/libsamplerate/ ; Обеспечивает: libsamplerate.so=0-64 ; 2024-07-12 21:15 UTC
sudo pacman -S --noconfirm --needed lib32-libsamplerate  # (необязательно) – для передискретизации звука ; Библиотека преобразования частоты дискретизации звука ; https://archlinux.org/packages/multilib/x86_64/lib32-libsamplerate/ ; https://libsndfile.github.io/libsamplerate/ ; Обеспечивает: libsamplerate.so=0-32 ; 2024-09-07 11:54 UTC
### Если установлено pulseaudio: установить пакет pulse-native-provider
#sudo pacman -S --noconfirm --needed pulse-native-provider  # (необязательно) — для использования плагина pulseaudio ; Звуковой сервер PulseAudio (поставщик по умолчанию) ; https://archlinux.org/packages/extra/x86_64/pulse-native-provider/ ; https://pipewire.org/ ; 2025-07-26 01:14 UTC
### Если установлено pipewire: установить пакет pipewire-pulse
# sudo pacman -S --noconfirm --needed pipewire-pulse  # (необязательно) — для использования плагина pulseaudio ; Аудио/видео маршрутизатор и процессор с малой задержкой — замена PulseAudio ; Аудио/видео маршрутизатор и процессор с малой задержкой — замена PulseAudio ; https://archlinux.org/packages/extra/x86_64/pipewire-pulse/ ; https://pipewire.org/ ; Обеспечивает: pulse-native-provider ; Конфликты: pulseaudio ; Обратные конфликты: с pulseaudio ; 2025-07-26 01:14 UTC
sudo pacman -S --noconfirm --needed speexdsp  # (необязательно) – для использования плагина speex ; Библиотека DSP, полученная из Speex ; https://archlinux.org/packages/extra/x86_64/speexdsp/ ; https://www.speex.org/ ; Обеспечивает: libspeexdsp.so=1-64 ; 2024-07-13 23:23 UTC
sudo pacman -S --noconfirm --needed speex  # (необязательно) – для использования плагина speex ; Бесплатный кодек для свободы слова ; https://archlinux.org/packages/extra/x86_64/speex/ ; https://www.speex.org/ ; 2024-07-13 23:23 UTC ; это формат сжатия аудио, разработанный для работы с речью. Проект Speex направлен на снижение барьера входа для голосовых приложений, предоставляя бесплатную альтернативу дорогостоящим проприетарным речевым кодекам.
sudo pacman -S --noconfirm --needed taglib  # (необязательно) – для использования плагина musepack ; Библиотека для чтения и редактирования метаданных нескольких популярных аудиоформатов ; https://archlinux.org/packages/extra/x86_64/taglib/ ; https://taglib.github.io/ ; 2025-06-30 06:37 UTC
sudo pacman -S --noconfirm --needed lib32-taglib  # (необязательно) – для использования плагина musepack ; Библиотека для чтения и редактирования метаданных нескольких популярных аудиоформатов (32 бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-taglib/ ; https://developer.kde.org/~wheeler/taglib.html ; 2024-09-13 22:12 UTC
sudo pacman -S --noconfirm --needed wavpack  # (необязательно) – для использования плагина wavpack ; Формат сжатия звука с режимами сжатия без потерь, с потерями и гибридным сжатием ; https://archlinux.org/packages/extra/x86_64/wavpack/ ; https://www.wavpack.com/ ; 2025-01-28 20:19 UTC
sudo pacman -S --noconfirm --needed lib32-wavpack  # (необязательно) – для использования плагина wavpack ; Формат сжатия аудио с режимами сжатия без потерь, с потерями и гибридным (32 бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-wavpack/ ; http://www.wavpack.com/ ; 2025-01-30 21:23 UTC
########## sidplay2-libs ############
yay -S sidplay2-libs --noconfirm  # (необязательно) — для использования плагина SID ; Новое поколение эмуляции SID ; https://aur.archlinux.org/packages/sidplay2-libs ; https://aur.archlinux.org/sidplay2-libs.git (только для чтения, нажмите, чтобы скопировать) ; http://sidplay2.sourceforge.net/ ; https://downloads.sourceforge.net/sidplay2/sidplay-libs-2.1.1.tar.gz ; 2021-05-30 17:02 (UTC)
########## sidplay2-libs ############
#git clone https://aur.archlinux.org/sidplay2-libs.git  # (только для чтения, нажмите, чтобы скопировать)
#cd sidplay2-libs
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf sidplay2-libs
#rm -Rf sidplay2-libs
### Sidplay 2 — вторая версия серии Sidplay, изначально разработанная Михаэлем Швендтом. Эта версия написана Саймоном Уайтом и обеспечивает точность воспроизведения цикла для улучшенного воспроизведения звука. Sidplay 2 воспроизводит все моно- и стереоформаты C64.
########## moc-pulse ############
yay -S moc-pulse --noconfirm  # Консольный аудиоплеер ncurses с поддержкой PulseAudio ; https://aur.archlinux.org/packages/moc-pulse?all_deps=1#pkgdeps ; https://aur.archlinux.org/moc-pulse.git (только для чтения, нажмите, чтобы скопировать) ; https://moc.daper.net/ ; https://ftp.daper.net/pub/soft/moc/stable/moc-2.5.2.tar.bz2 ; 2025-05-30 08:41 (UTC)
########## moc-pulse ############
#git clone https://aur.archlinux.org/moc-pulse.git  # (только для чтения, нажмите, чтобы скопировать)
#cd moc-pulse
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf moc-pulse
#rm -Rf moc-pulse
  echo ""
  echo " Установка Коллекции тем для музыки на консольном плеере "
########## mocp-themes-git ############
yay -S mocp-themes-git --noconfirm  # Коллекция тем для музыки на консольном плеере ; https://aur.archlinux.org/packages/mocp-themes-git ; https://aur.archlinux.org/mocp-themes-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/wimstefan/mocp-themes ; git+https://github.com/wimstefan/mocp-themes ; Обеспечивает: mocp-themes ; 2025-01-07 17:12 (UTC)
########## mocp-themes-git ############
#git clone https://aur.archlinux.org/mocp-themes-git.git  # (только для чтения, нажмите, чтобы скопировать)
#cd mocp-themes-git
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf mocp-themes-git
#rm -Rf mocp-themes-git
########################
  echo ""
  echo " Посмотрите информацию о версии (moc) "
mocp --version  # Показать версию приложения
sudo pacman -Q moc-pulse  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_moc == 2 ]]; then
  echo ""
  echo " Установка утилиты (пакета) MOC (Music On Console) (moc-pulse-svn)  "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed libid3tag  # Библиотека манипуляции тегами ID3 ; https://archlinux.org/packages/extra/x86_64/libid3tag/ ; https://codeberg.org/tenacityteam/libid3tag ; 2024-03-07 11:57 UTC
sudo pacman -S --noconfirm --needed lib32-libid3tag  # Библиотека для id3-тегирования, lib32 ; https://archlinux.org/packages/multilib/x86_64/lib32-libid3tag/ ; https://www.underbit.com/products/mad/ ; 2024-05-04 11:02 UTC
sudo pacman -S --noconfirm --needed faad2  # (необязательно) – для использования плагина aac ;  Бесплатный декодер Advanced Audio (AAC) ; https://archlinux.org/packages/extra/x86_64/faad2/ ; https://github.com/knik0/faad2 ; Обеспечивает: faad, libfaad.so=2-64, libfaad_drm.so=2-64 ; 2025-03-04 09:01 UTC
sudo pacman -S --noconfirm --needed ffmpeg4.4  # (необязательно) – для использования плагина ffmpeg ; Комплексное решение для записи, конвертации и потоковой передачи аудио и видео ; https://ffmpeg.org/ ; https://archlinux.org/packages/extra/x86_64/ffmpeg4.4/ ; Обеспечивает: libavcodec.so=58-64, libavdevice.so=58-64, libavfilter.so=7-64, libavformat.so=58-64, libavutil.so=56-64 ; 2025-08-14 20:44 UTC
sudo pacman -S --noconfirm --needed libmodplug  # (необязательно) — для использования плагина modplug ; Библиотека воспроизведения MOD ; https://archlinux.org/packages/extra/x86_64/libmodplug/ ; http://modplug-xmms.sourceforge.net/ ; 2024-07-12 20:59 UTC
sudo pacman -S --noconfirm --needed lib32-libmodplug  # (необязательно) — для использования плагина modplug ; Библиотека воспроизведения MOD ; https://archlinux.org/packages/multilib/x86_64/lib32-libmodplug/ ; http://modplug-xmms.sourceforge.net/ ; 2024-09-07 10:12 UTC
sudo pacman -S --noconfirm --needed libmpcdec  # (необязательно) – для использования плагина musepack ; Библиотека декодирования MusePack ; https://archlinux.org/packages/extra/x86_64/libmpcdec/ ; https://musepack.net/ ; 2024-07-07 22:05 UTC ; Musepack — это формат сжатия аудио с акцентом на высокое качество. Он не является форматом сжатия без потерь, но разработан для обеспечения прозрачности, поэтому вы не услышите разницы между исходным WAV-файлом и гораздо меньшим MPC-файлом.
sudo pacman -S --noconfirm --needed libsamplerate # (необязательно) – для передискретизации звука ; Библиотека преобразования частоты дискретизации звука ; https://archlinux.org/packages/extra/x86_64/libsamplerate/ ; https://libsndfile.github.io/libsamplerate/ ; Обеспечивает: libsamplerate.so=0-64 ; 2024-07-12 21:15 UTC
sudo pacman -S --noconfirm --needed lib32-libsamplerate  # (необязательно) – для передискретизации звука ; Библиотека преобразования частоты дискретизации звука ; https://archlinux.org/packages/multilib/x86_64/lib32-libsamplerate/ ; https://libsndfile.github.io/libsamplerate/ ; Обеспечивает: libsamplerate.so=0-32 ; 2024-09-07 11:54 UTC
### Если установлено pulseaudio: установить пакет pulse-native-provider
#sudo pacman -S --noconfirm --needed pulse-native-provider  # (необязательно) — для использования плагина pulseaudio ; Звуковой сервер PulseAudio (поставщик по умолчанию) ; https://archlinux.org/packages/extra/x86_64/pulse-native-provider/ ; https://pipewire.org/ ; 2025-07-26 01:14 UTC
### Если установлено pipewire: установить пакет pipewire-pulse
# sudo pacman -S --noconfirm --needed pipewire-pulse  # (необязательно) — для использования плагина pulseaudio ; Аудио/видео маршрутизатор и процессор с малой задержкой — замена PulseAudio ; Аудио/видео маршрутизатор и процессор с малой задержкой — замена PulseAudio ; https://archlinux.org/packages/extra/x86_64/pipewire-pulse/ ; https://pipewire.org/ ; Обеспечивает: pulse-native-provider ; Конфликты: pulseaudio ; Обратные конфликты: с pulseaudio ; 2025-07-26 01:14 UTC
sudo pacman -S --noconfirm --needed speexdsp  # (необязательно) – для использования плагина speex ; Библиотека DSP, полученная из Speex ; https://archlinux.org/packages/extra/x86_64/speexdsp/ ; https://www.speex.org/ ; Обеспечивает: libspeexdsp.so=1-64 ; 2024-07-13 23:23 UTC
sudo pacman -S --noconfirm --needed speex  # (необязательно) – для использования плагина speex ; Бесплатный кодек для свободы слова ; https://archlinux.org/packages/extra/x86_64/speex/ ; https://www.speex.org/ ; 2024-07-13 23:23 UTC ; это формат сжатия аудио, разработанный для работы с речью. Проект Speex направлен на снижение барьера входа для голосовых приложений, предоставляя бесплатную альтернативу дорогостоящим проприетарным речевым кодекам.
sudo pacman -S --noconfirm --needed taglib  # (необязательно) – для использования плагина musepack ; Библиотека для чтения и редактирования метаданных нескольких популярных аудиоформатов ; https://archlinux.org/packages/extra/x86_64/taglib/ ; https://taglib.github.io/ ; 2025-06-30 06:37 UTC
sudo pacman -S --noconfirm --needed lib32-taglib  # (необязательно) – для использования плагина musepack ; Библиотека для чтения и редактирования метаданных нескольких популярных аудиоформатов (32 бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-taglib/ ; https://developer.kde.org/~wheeler/taglib.html ; 2024-09-13 22:12 UTC
sudo pacman -S --noconfirm --needed wavpack  # (необязательно) – для использования плагина wavpack ; Формат сжатия звука с режимами сжатия без потерь, с потерями и гибридным сжатием ; https://archlinux.org/packages/extra/x86_64/wavpack/ ; https://www.wavpack.com/ ; 2025-01-28 20:19 UTC
sudo pacman -S --noconfirm --needed lib32-wavpack  # (необязательно) – для использования плагина wavpack ; Формат сжатия аудио с режимами сжатия без потерь, с потерями и гибридным (32 бит) ; https://archlinux.org/packages/multilib/x86_64/lib32-wavpack/ ; http://www.wavpack.com/ ; 2025-01-30 21:23 UTC
########## sidplay2-libs ############
yay -S sidplay2-libs --noconfirm  # (необязательно) — для использования плагина SID ; Новое поколение эмуляции SID ; https://aur.archlinux.org/packages/sidplay2-libs ; https://aur.archlinux.org/sidplay2-libs.git (только для чтения, нажмите, чтобы скопировать) ; http://sidplay2.sourceforge.net/ ; https://downloads.sourceforge.net/sidplay2/sidplay-libs-2.1.1.tar.gz ; 2021-05-30 17:02 (UTC)
########## sidplay2-libs ############
#git clone https://aur.archlinux.org/sidplay2-libs.git  # (только для чтения, нажмите, чтобы скопировать)
#cd sidplay2-libs
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf sidplay2-libs
#rm -Rf sidplay2-libs
### Sidplay 2 — вторая версия серии Sidplay, изначально разработанная Михаэлем Швендтом. Эта версия написана Саймоном Уайтом и обеспечивает точность воспроизведения цикла для улучшенного воспроизведения звука. Sidplay 2 воспроизводит все моно- и стереоформаты C64.
########## moc-pulse-svn ############
yay -S moc-pulse-svn --noconfirm  # Консольный аудиоплеер ncurses с поддержкой pulseaudio (SVN) ; https://aur.archlinux.org/packages/moc-pulse-svn ; https://aur.archlinux.org/moc-pulse-svn.git (только для чтения, нажмите, чтобы скопировать) ; http://moc.daper.net/ ; svn://daper.net/moc/trunk ; Конфликты: moc ; Обеспечивает: moc ; 2025-05-30 08:44 (UTC)
########## moc-pulse-svn ############
#git clone https://aur.archlinux.org/moc-pulse-svn.git  # (только для чтения, нажмите, чтобы скопировать)
#cd moc-pulse-svn
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf moc-pulse-svn
#rm -Rf moc-pulse-svn
  echo ""
  echo " Установка Коллекции тем для музыки на консольном плеере "
########## mocp-themes-git ############
yay -S mocp-themes-git --noconfirm  # Коллекция тем для музыки на консольном плеере ; https://aur.archlinux.org/packages/mocp-themes-git ; https://aur.archlinux.org/mocp-themes-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/wimstefan/mocp-themes ; git+https://github.com/wimstefan/mocp-themes ; Обеспечивает: mocp-themes ; 2025-01-07 17:12 (UTC)
########## mocp-themes-git ############
#git clone https://aur.archlinux.org/mocp-themes-git.git  # (только для чтения, нажмите, чтобы скопировать)
#cd mocp-themes-git
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf mocp-themes-git
#rm -Rf mocp-themes-git
##########################
  echo ""
  echo " Посмотрите информацию о версии (moc) "
mocp --version  # Показать версию приложения
sudo pacman -Q moc-pulse-svn  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
### MOCP - Music On Console Player
# https://help.ubuntu.ru/wiki/mocp
# Сайт проекта — http://moc.daper.net/
# Официальная документация:
# https://moc.daper.net/documentation
# MOC - Music On Console:
# https://wiki.archlinux.org/title/MOC
# https://github.com/jonsafari/mocp
# Этот файл представляет собой лишь краткое описание MOC, более подробную информацию можно найти на домашней странице:
# ( http://moc.daper.net/documentation ).
### Помните, что MOC работает плавно, не мешая другим терминалам и операциям ввода-вывода? Нажмите кнопку Q, чтобы вернуться в окно терминала, не выключая MOC. Когда вы захотите вернуться в интерфейс MOC, введите mocp
# $ mocp — запуск плеера (сервер и клиент)
# moc — Двухпанельный плеер.
# Левая панель — файловый менеджер
# Правая панель — текущий плэйлист
# Tab — Навигация между панелями
### Сочетания клавиш: Для Xfce перейдите в раздел Settings -> Keyboard -> Application Shortcuts, а затем добавьте сочетания клавиш с командами, такими как mocp --next, и другими, перечисленными в разделе mocp --help. Я считаю, что наиболее полезные сочетания клавиш предназначены для следующих действий:
# mocp --toggle-pause- Воспроизведение/пауза
# mocp --toggle shuffle- Включить/выключить перемешивание
# mocp --next- Перейти к следующей песне
# mocp --previous- Перейти к предыдущей песне
# mocp --seek +5- Перейти на 5 секунд вперед
# mocp --seek -5- Перейти на 5 секунд назад
# проигрывать файлы можно как из файлового менеджера, так и из плэйлиста
### А теперь разберемся с плэйлистами:
# a — Добавить файл для воспроизведения в плэйлист
# A (Shift+a) — рекурсивное добавление в плэйлист, те все музыкальные файлы, находящиеся в папке будут добавлены в плэйлист
# moc — обладает удобнейшим редактором плэйлиста - музыкальные файлы, добавленные в плэйлист, проигрываются в порядке, в котором они находятся
# u — переместить файл выше в плэйлисте
# j — переместить файл ниже в плэйлисте
# d — удалить файл из плэйлиста
# V (Shift+v) — сохранить плэйлист
# C (Ctrl+c) — очистить плэйлист
# moc очень удобный и функционалный
# ENTER — запустить шарманку
# n — воспроизвести следующий трек
# b — воспроизвести предыдущий трек
# > (Shift+.) сделать громкость больше
# < (Shift+,) сделать громкость меньше
# p — пауза в проигрывании (снять паузу — повторное нажатие p)
# s — остановить проигрыватель (начать проигрывание — ENTER)
# moc обладает режимами проигрывания:
# S (Shift+s) — включает режим Shuffle — проигрывание плэйлиста в случайном порядке
# R (Shift+r) — включает режим Repeat — циклическое воспроизведение плэйлиста
# h — справка по командам moc
# Сочетания клавиш MOC:
# p– платная музыка
# b– предыдущий трек
# n– следующий трек
# q– скрыть интерфейс MOC
# Полный список команд можно просмотреть, нажав "h"на клавиатуре и открыв меню справки.
# Управление плеером осуществляется нажатием буквенных клавишь клавиатуры:
# Q (Shift+q) — закрытие сервера и клиента moc
# q — закрытие клиента moc, сервер при этом, продолжит проигрывание.so
### Использование тем: Да, темы есть, потому что люди их хотели. :)
# Темы могут изменять все цвета и только цвета. Пример файла темы с подробным описанием прилагается (themes/example_theme) и является внешним видом MOC по умолчанию.
# Файлы тем должны быть помещены в каталог ~/.moc/themes/ или $(datadir)/moc/themes/ (например, /usr/local/share/moc/themes) и могут быть выбраны с помощью параметров конфигурации темы или параметра командной строки -T (см. страницу руководства и пример файла конфигурации).
# Подборку примеров тем можно найти в /usr/share/moc/themes/, установка mocp-themes-git AUR добавляет еще больше тем.
# Поскольку темы — это всего лишь текстовые файлы, создавать новые легко. Пользовательские темы принимаются в формате ~/.moc/themes/.
# Обязательно укажите информацию о версии и ревизии (ее можно получить, выполнив команду «mocp --version»).
# Адаптировал этот заброшенный пакет (mocp-themes-git) из AUR и исправил каталог скриншотов.
# luntik2012 прокомментировал 2023-01-05 22:42 (UTC)
# cp: -r не указано; каталог «Скриншоты» пропущен
# исправление: cp -r * "${pkgdir}/usr/share/moc/themes"
########################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Фронтенды (Front-ends): (mocicon), (exo-player) — Интерфейс для проигрывателя MOC?"
echo -e "${YELLOW}==> Примечание! ${BOLD}*Графическое управление: Возможность управления проигрывателем напрямую, без какого-либо интерфейса, можно использовать с применением творческого подхода. Можно назначить команды на комбинации клавиш (или использовать мультимедиа-кнопки клавиатуры при наличии таковых), можно поискать (или написать) какой-нибудь плагин к чему-нибудь… ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Фронтенды (Front-ends)(frontend): MocIcon (mocicon) — апплет панели GTK /GTK2 для управления MOC. MocIcon — это простой значок приложения «Музыка в консоли» в трее. Вдохновленный Moc-Tray, я решил написать его на C, поскольку Perl не такой лёгкий язык, как C, и не очень подходит для лёгкого использования на десктопе. Приложение написано с использованием инструментария GTK+ и имеет очень небольшой объём компиляции (менее 100 строк кода). Я стараюсь минимизировать потребление памяти, но значки и GTK занимают почти всю память. *Комментарий одного из пользователей: *Работает с ошибками. На панели XFCE нет значка, но есть пустое место. Щёлкаешь по нему, и запуск mocp реагирует. Ошибки в терминале: Не удаётся загрузить плагин libaac_decoder: файл не найден. Не удаётся загрузить плагин libffmpeg_decoder: файл не найден. Не удаётся загрузить плагин libwavpack_decoder: файл не найден. eXo (exo-player) — Qt-интерфейс для MOC, поддерживает скробблинг. Найдите и откройте индикатор либо из меню «Пуск», либо из обзора «Действия» в зависимости от среды вашего рабочего стола. После этого вы увидите апплет в области уведомлений. Если плеер moc не запустился, нажмите кнопку « Player », чтобы запустить его. Используйте кнопку « Add » для добавления песен и наслаждайтесь музыкой с помощью кнопок управления. ПРИМЕЧАНИЕ: Воспроизведение музыки не остановится даже после закрытия индикатора без нажатия кнопки «Стоп». Qt-интерфейс для проигрывателя MOC (Music on Console). Сочетание eXo и MOC даёт вам современный, но при этом очень минималистичный аудиоплеер. Этот проект Лицензируется под BSD, GPL-3.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://mocicon.sourceforge.net/ ; (https://github.com/loimu/exo ; https://aur.archlinux.org/packages/mocicon/ ; https://aur.archlinux.org/packages/exo-player/). "
echo -e "${BLUE}:: ${NC}Функции MocIcon (mocicon): Базовый значок GTK+ в трее; запуск/остановка сервера; кнопки воспроизведения/паузы; пропустить/вернуть песни назад; запустить mocp в xterm; интеграция уведомлений и отправки; иконки в меню; более простая схема клика; левый щелчок для паузы/воспроизведения; щелкните правой кнопкой мыши для вызова обычного меню; средний щелчок для уведомления-отправки. В процессе/Не начато: Очистка кода всегда необходима, наведение курсора на текущую песню (теперь это щелчок средней кнопкой мыши, а не наведение курсора), выбор плейлиста и базовая поддержка. "
echo -e "${CYAN}:: ${NC}Функции eXo (exo-player): Текст песни из интернета. Фоновый режим. Интерфейсы DBus и MPRISv2. Обеспечивает управление мультимедиа в среде рабочего стола. Скробблинг на last.fm (необязательно). Закладки для радиопередач. OSD-уведомления. Дополнительная поддержка CMus. Дополнительная поддержка клиента Spotify (ограниченная функциональность, только скробблинг). Дополнительную информацию о параметрах командной строки см. (man exo). "
echo -e "${CYAN}:: ${NC}Установка Фронтендов: (mocicon) и (exo-player), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/mocicon.git), (https://aur.archlinux.org/exo-player.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить MOCicon (mocicon),    2 - Установить eXo (exo-player),

    0 - НЕТ - Пропустить установку: " in_frontend  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_frontend" =~ [^120] ]]
do
    :
done
if [[ $in_frontend == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_frontend == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) MOCicon (mocicon) — апплет панели GTK /GTK2 для управления MOC "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########## mocicon ############
yay -S mocicon --noconfirm  # Апплет панели GTK, позволяющий управлять MOC (музыкой на консоли) ; https://aur.archlinux.org/packages/mocicon ; https://aur.archlinux.org/mocicon.git (только для чтения, нажмите, чтобы скопировать) ; http://mocicon.sourceforge.net/ ; 2015-08-15 16:14 (UTC)
########## mocicon ############
#git clone https://aur.archlinux.org/mocicon.git  # (только для чтения, нажмите, чтобы скопировать)
#cd mocicon
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf mocicon
#rm -Rf mocicon
###################
  echo ""
  echo " Посмотрите информацию о версии (mocicon) "
sudo pacman -Q mocicon  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_frontend == 2 ]]; then
  echo ""
  echo " Установка утилиты (пакета) eXo (exo-player) — Qt-интерфейс для MOC "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed python-notify2  # (необязательно) – для moc-osd ; Интерфейс Python для уведомлений DBus ; https://archlinux.org/packages/extra/any/python-notify2/ ; https://bitbucket.org/takluyver/pynotify2 ; 2024-12-22 13:09 UTC
########## exo-player ############
yay -S exo-player --noconfirm  # Интерфейс Qt для проигрывателя MOC (музыка на консоли) ; https://aur.archlinux.org/packages/exo-player ; https://aur.archlinux.org/exo-player.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/loimu/exo ; git+https://github.com/loimu/exo.git#tag=v0.9.0 ; 2025-06-28 11:53 (UTC)
########## exo-player ############
#git clone https://aur.archlinux.org/exo-player.git  # (только для чтения, нажмите, чтобы скопировать)
#cd exo-player
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf exo-player
#rm -Rf exo-player
###################
  echo ""
  echo " Посмотрите информацию о версии (exo-player) "
sudo pacman -Q exo-player  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
### eXo project:
# https://github.com/loimu/exo
# Qt-интерфейс для проигрывателя MOC (Music on Console). Сочетание eXo и MOC даёт вам современный, но при этом очень минималистичный аудиоплеер.
### Фоновый режим (не требуется графический интерфейс или X-сессия).
# Базовый бег (Basic running):
# exo -d 2>/tmp/exo_errors.log &
# (Повторная) аутентификация Scrobbler
# exo --force-reauth
### Закрытие приложения:
# qdbus org.mpris.MediaPlayer2.exo\
#  /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Quit
# или
# pkill -2 exo
### Советы:
# Создайте глобальную горячую клавишу, чтобы в любой момент увидеть текст песни, назначив указанную ниже команду нужному сочетанию клавиш.
# qdbus local.exo_player /exo local.exo_player.showLyricsWindow
####################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Scrobbler (mocp-scrobbler) — Скробблер Last.fm (и Libre.fm) для MOC?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Скробблер статистки прослушивания для Last FM. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}mocp-scrobbler — это скробблер Last.fm (и Libre.fm) для MOC с поддержкой уведомлений о текущем воспроизведении, демонизации и кэширования. Работает только на Python 3. Этот проект Лицензируется под GPL. ${NC}"
echo " Домашняя страница: https://github.com/fluxid/mocp-scrobbler ; (https://www.last.fm/ ; https://aur.archlinux.org/packages/mocp-scrobbler ; https://github.com/HelpMeImInHell/lastfm-scrobbler/blob/main/README.md). "
echo -e "${BLUE}:: ${NC}*Как это работает? Скробблер отслеживает сессии мини-плеера и подписывается на их события. Единовременно в мини-плеере может быть несколько сессий для нескольких приложений/плееров. Поэтому в скробблере существует фильтрация сессий по идентификатору приложения плеера. По умолчанию в скробблер заложен идентификатор standalone-приложения Яндекс.Музыки ru.yandex.desktop.music. Этот параметр можно изменить в настройках (Settings -> Advanced settings -> Observed application). Изначально нужного приложения может не быть в списке. Чтобы оно там появилось, нужно запустить плеер и начать воспроизведение. После открыть настройки снова. "
echo -e "${CYAN}:: ${NC}Для начала работы скробблера необходимо авторизоваться под своей учетной записью Last FM (File -> Log in). Скробблер не требует и не хранит логин и пароль. Вместо это он открывает браузер, где нужно разрешить доступ скробблера к учетной записи. В браузере нужно подтвердить доступ, и только после этого нажать OK в всплывающем окне скробблера. Далее скробблер получает (и сохраняет) идентификатор сессии, который в дальнейшем используется для запросов к API Last FM от лица пользователя. После получения идентификатора сессии начинается отслеживание сессий мини-плеера. Скробблер отслеживает события: предыдущий/следующий трек; пауза/воспроизведение; изменение текущей позиции на воспроизводимом треке в самом плеере (при условии, что плеер передает информацию о текущей позиции на треке). На данный момент в своей работе скробблер использует следующие эндпоинты API Last FM (не включая эндпоинты, необходимые для аутентификации): track.updateNowPlaying - обновить информацию о текущем воспроизводимом треке. Это не скробблинг трека; track.scrobble - скробблинг трека; Оба эндпоинта вызываются через настраиваемый промежуток времени. "
echo -e "${CYAN}:: ${NC}Установка mocp-scrobbler.py (для Python3) (mocp-scrobbler) проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/mocp-scrobbler.git), (https://aur.archlinux.org/packages/mocp-scrobbler) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_scrobbler  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_scrobbler" =~ [^10] ]]
do
    :
done
if [[ $in_scrobbler == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_scrobbler == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Psensor (psensor) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########## mocp-themes-git ############
yay -S mocp-scrobbler --noconfirm  # Скробблер Last.fm (и Libre.fm) для MOC с поддержкой уведомлений о текущем воспроизведении, демонизации и кэширования. Работает только на Python 3; https://aur.archlinux.org/packages/mocp-scrobbler ; https://aur.archlinux.org/mocp-scrobbler.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/fluxid/mocp-scrobbler ; https://raw.githubusercontent.com/fluxid/mocp-scrobbler/master/mocp-scrobbler.py ; https://aur.archlinux.org/cgit/aur.git/tree/config.example?h=mocp-scrobbler ; 2015-06-15 18:06 (UTC)
########## mmocp-scrobbler ############
#git clone https://aur.archlinux.org/mocp-scrobbler.git  # (только для чтения, нажмите, чтобы скопировать)
#cd mocp-scrobbler
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf mocp-scrobbler
#rm -Rf mocp-scrobbler
### Примечание!
# Чтобы использовать Libre.fm вместо Last.fm, измените hostnameс post.audioscrobbler.comна turtle.libre.fm.
# Скопируйте файл примера в каталог конфигурации пользователя:
sudo mkdir ~/.mocpscrob/
#sudo cp /usr/share/doc/mocp-scrobbler/config.example ~/.mocpscrob/config
  echo ""
  echo " Посмотрите информацию о версии (moc) "
mocp --version  # Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
### Last.fm:
# https://www.last.fm/
# https://www.last.fm/join
### mocp-scrobbler.py
# https://github.com/fluxid/mocp-scrobbler
# https://aur.archlinux.org/packages/mocp-scrobbler
# https://aur.archlinux.org/mocp-scrobbler.git
### Примечание!
# Чтобы использовать Libre.fm вместо Last.fm, измените hostnameс post.audioscrobbler.comна turtle.libre.fm.
# Скопируйте файл примера в каталог конфигурации пользователя:
# mkdir ~/.mocpscrob/
# cp /usr/share/doc/mocp-scrobbler/config.example ~/.mocpscrob/config
# mocp-scrobbler.py (для Python3) https://github.com/fluxid/mocp-scrobbler
# Скробблер Last.fm для аудиоплеера MOC с поддержкой уведомлений о текущем воспроизведении, демонизации и кэширования. Для работы требуется только Python 3 и ничего больше.
# Работает с интернет-трансляциями (только с правильно настроенными тегами — обычно это трансляции Icecast). Скробблинг происходит на 90% трека или при смене трека/остановке, если воспроизведено хотя бы 50% или полминуты. Также поддерживается скробблинг зацикленных треков.
# % python3 mocp-scrobbler.py --help
# mocp-scrobbler.py 0.2
### Usage:
#  mocp-scrobbler.py [--daemon] [--offline] [--verbose | --quiet] [--config=FILE]
#   mocp-scrobbler.py --kill [--verbose | --quiet]
# -c, --config=FILE  Use this file instead of default config
#  -d, --daemon       Run in background, messages will be written to log file
#  -k, --kill         Kill existing scrobbler instance and exit
#  -o, --offline      Don't connect to service, put everything in cache
#  -q, --quiet        Write only errors to console/log
#  -v, --verbose      Write more messages to console/log
### Установка:
# Установка выполняется вручную. Просто добавьте этот скрипт Python в переменную $PATH. Настраивать MOC ничего не нужно. Перед запуском необходимо создать файл конфигурации, ~/.mocpscrob/config , который должен выглядеть следующим образом:
# [scrobbler]
# login=YOUR_LASTFM_LOGIN
# password=YOUR_PASSWORD
# streams=true
# hostname=post.audioscrobbler.com
### password Будет заменён password_md5 при первом запуске. Его значение будет соответствовать исходному значению, хешированному с помощью алгоритма MD5. Если вы хотите сменить пароль, просто добавьте passwordего ещё раз — password_md5он будет заменён.
# streams и hostname не являются обязательными, а данные значения являются значениями по умолчанию.
# streams Включает скробблинг при прослушивании интернет-потоков. Если работает некорректно, установите значение false.
# hostname может быть полезно, если вы хотите использовать другой сервис скробблинга, например libre.fm (turtle.libre.fm).
# Кэш, pidfile и логи размещаются в ~/.mocpscrob/.
# Вместо запуска в режиме демона вы можете запустить его в GNU Screen:
# % screen -dR scrob mocp-scrobbler.py -v
### Поиск неисправностей:
# Прежде чем сообщать об ошибках, пожалуйста, проверьте следующее:
# Убедитесь, что вы используете Python версии не ниже 3.1 (я не тестировал его на Python 3.0)
# Проверьте, mocp -iвыводит ли информация о том, какой трек воспроизводится в данный момент.
# Часто задаваемые вопросы
# А как насчет других игроков?
# Возможно в будущем, но как другой проект.
# А как насчет Python 2.x?
# Извините, не поддерживается. Старый код можно найти в old-python2теге. В нём есть небольшие ошибки, так что будьте готовы.
# А как насчет скробблинга API 2?
# Есть некоторый интерес к использованию этого скрипта gobblerдля libre.fm, который, насколько мне известно, пока не поддерживает новый API, так что...
#####################################

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
### Расширения/полезные скрипты:
# https://github.com/cmus/cmus/wiki
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

sleep 2
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
### end of script"