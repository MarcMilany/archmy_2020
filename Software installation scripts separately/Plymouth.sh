#!/usr/bin/env bash
# Install script Plymouth
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget 
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 
apptitle="Arch Linux Fast Install v2.4 LegasyBIOS - Version: 2024.07.31.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

PLYMOUTH_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
  <<< Установка утилит (пакетов) Plymouth обеспечивающий загрузки системы без бегущих надписей (логов) на экране в Archlinux >>> ${NC}"
# Installing Plymouth utilities (packages) that provides system downloads without running labels (logs) on the screen in Archlinux
echo ""
echo -e "${YELLOW}==> Примечание! ${BOLD} *Linux — не самая известная операционная система (ОС), когда речь заходит о визуальной составляющей. Тем не менее существуют различные варианты настройки, которые делают использование дистрибутивов Linux более наглядным и динамичным. Один из таких вариантов — изменение графики загрузки и завершения работы. Основная идея Plymouth — кастомизация. Что касается графики, то она в основном настраивается с помощью тем. ${NC}"
sleep 09
clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Plymouth (plymouth) — Графический загрузочный экран-заставка?"
echo -e "${YELLOW}==> Примечание! ${BOLD}*Если вы устанавливаете Arch Linux с нуля и загружаете некоторые рабочие столы, такие как GNOME и KDE, ни один из них не предоставляет Plymouth. Потому что это отдельная программа, и установка Arch на «голое железо» не упаковывает ее. Основная идея — убрать мерцание или стену прокручивающихся текстов во время загрузки Linux с помощью красивой графической анимации. Это помогает пользователям быстрее дождаться появления экрана входа в систему во время загрузки. Программа имеет резервный текстовый режим на случай, если графическая анимация не загрузится. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Plymouth — это приложение, которое запускается на самом раннем этапе процесса загрузки (даже до монтирования корневой файловой системы!) и обеспечивает графическую анимацию загрузки, пока процесс загрузки происходит в фоновом режиме. Plymouth — это проект из Fedora, обеспечивающий загрузку системы без бегущих надписей (логов) на экране. Он базируется на kernel mode setting (KMS, установка разрешения и глубины цвета на уровне ядра) для обеспечения родного разрешения экрана на раннем этапе загрузки, после чего отображает привлекательный загрузочный экран вплоть до этапа выбора пользователя. Этот проект Лицензируется под GPL-2.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://www.freedesktop.org/wiki/Software/Plymouth/ ; (https://archlinux.org/packages/extra/x86_64/plymouth/ ; https://aur.archlinux.org/packages/plymouth-git). "
echo -e "${BLUE}:: ${NC}Он предназначен для работы на системах с драйверами, устанавливающими режим DRM . Идея заключается в том, что на раннем этапе загрузки устанавливается собственный режим компьютера, Plymouth использует его и сохраняет его на протяжении всей загрузки, вплоть до запуска X и после него. В идеале цель — полностью избавиться от мерцания во время загрузки. Для систем, не имеющих драйверов настроек режима DRM, plymouth возвращается к текстовому режиму (он также может использовать устаревший интерфейс /dev/fb). В текстовом или графическом режиме сообщения загрузки полностью скрыты. После монтирования корневой файловой системы в режиме чтения и записи сообщения сохраняются в /var/log/boot.log. Кроме того, пользователь может просмотреть сообщения в любой момент загрузки, нажав клавишу ESC. Plymouth поддерживает различные темы-заставки, которые аналогичны заставкам, но появляются во время загрузки. В комплект поставки Plymouth входит несколько примеров тем, но большинство дистрибутивов, использующих Plymouth, поставляются с индивидуальной настройкой. Plymouth ещё не завершён. Он всё ещё находится в стадии активной разработки, но уже используется в нескольких популярных дистрибутивах, включая Fedora, Mandriva, Ubuntu и другие. Подробнее см. на странице дистрибутивов. "
echo -e "${CYAN}:: ${NC}Пакет plymouth поставляется с двумя двоичными файлами: '/sbin/plymouthd' и '/bin/plymouth'. Первый, plymouthd, берёт на себя всю основную работу. Он регистрирует сеанс и показывает заставку. Второй, /bin/plymouth, — это интерфейс управления plymouthd. Он поддерживает такие функции, как plymouth show-splash или plymouth ask-for-password, которые запускают соответствующее действие в plymouthd. *Plymouth на самом деле не предназначен для сборки из исходного кода конечными пользователями. Для его корректной работы необходима интеграция с дистрибутивом. Поскольку он запускается так рано, его необходимо поместить в начальный RAM-диск дистрибутива, и дистрибутив должен передавать plymouth информацию о ходе загрузки. "
echo -e "${CYAN}:: ${NC}Установка Plymouth (plymouth-git), а Также темы для plymouth (plymouth-theme-arch-os),(plymouth-theme-aregression) (plymouth-theme-monoarch) и т.д., проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/plymouth-git.git), (https://aur.archlinux.org/plymouth-theme-arch-os.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить Plymouth (plymouth),     2 - Установить Plymouth (plymouth-git),

    0 - НЕТ - Пропустить установку: " in_plymouth  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_plymouth" =~ [^120] ]]
do
    :
done
if [[ $in_plymouth == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_plymouth == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Plymouth (plymouth) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
############# plymouth ##########
sudo pacman -S --noconfirm --needed plymouth  # Графический загрузочный экран-заставка ; https://archlinux.org/packages/extra/x86_64/plymouth/ ; https://www.freedesktop.org/wiki/Software/Plymouth/ ; 2025-07-25 08:50 UTC
  echo ""
  echo " Установка дополнительных утилит (пакетов) plymouth-theme "
################# Основные темы для Plymouth #######################
########### plymouth-theme-arch-os ###############
yay -S plymouth-theme-arch-os --noconfirm  # Тема Arch OS для Plymouth ; https://aur.archlinux.org/packages/plymouth-theme-arch-os ; https://aur.archlinux.org/plymouth-theme-arch-os.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/murkl/plymouth-theme-arch-os ; git+https://github.com/murkl/plymouth-theme-arch-os.git ; 2024-08-21 08:55 (UTC)
########### plymouth-theme-arch-os ###############
#git clone https://aur.archlinux.org/plymouth-theme-arch-os.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plymouth-theme-arch-os
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plymouth-theme-arch-os
#rm -Rf plymouth-theme-arch-os   # удаляем директорию сборки
########### plymouth-theme-aregression ###############
yay -S plymouth-theme-aregression --noconfirm  # Элегантный индикатор загрузки Plymouth ; https://aur.archlinux.org/packages/plymouth-theme-aregression ; https://aur.archlinux.org/plymouth-theme-aregression.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/yozachar/plymouth-theme-aregression ; https://github.com/yozachar/plymouth-theme-aregression/archive/v2.1.0.tar.gz ; 2024-04-16 14:15 (UTC)
########### plymouth-theme-aregression ###############
#git clone https://aur.archlinux.org/plymouth-theme-aregression.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plymouth-theme-aregression
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plymouth-theme-aregression
#rm -Rf plymouth-theme-aregression   # удаляем директорию сборки
########### plymouth-theme-monoarch ###############
yay -S plymouth-theme-monoarch --noconfirm  # Монохромная тема Arch Linux для Плимута ; https://aur.archlinux.org/packages/plymouth-theme-monoarch ; https://aur.archlinux.org/plymouth-theme-monoarch.git (только для чтения, нажмите, чтобы скопировать) ; https://farsil.github.io/monoarch/ ; https://github.com/farsil/monoarch/archive/0.1.tar.gz ; https://aur.archlinux.org/cgit/aur.git/tree/plymouth-theme-monoarch.install?h=plymouth-theme-monoarch ; 2016-10-20 17:43 (UTC)
########### plymouth-theme-monoarch ###############
#git clone https://aur.archlinux.org/plymouth-theme-monoarch.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plymouth-theme-monoarch
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plymouth-theme-monoarch
#rm -Rf plymouth-theme-monoarch   # удаляем директорию сборки
########### plymouth-theme-neat ###############
yay -S plymouth-theme-neat --noconfirm  # Тема Plymouth для Arch Linux с поддержкой HiDPI ; https://aur.archlinux.org/packages/plymouth-theme-neat ; https://aur.archlinux.org/plymouth-theme-neat.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/neetly/plymouth-theme-neat ; git+https://github.com/neetly/plymouth-theme-neat.git#tag=v0.1.0 ; 2022-11-28 12:00 (UTC)
########### plymouth-theme-neat ###############
#git clone https://aur.archlinux.org/plymouth-theme-neat.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plymouth-theme-neat
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plymouth-theme-neat
#rm -Rf plymouth-theme-neat   # удаляем директорию сборки
### Тема Plymouth для Arch Linux с поддержкой HiDPI
# paru -S --needed plymouth-theme-neat
# sudo plymouth-set-default-theme neat
# echo "DeviceScale=1" | sudo tee -a /etc/plymouth/plymouthd.conf
# sudo mkinitcpio -P
################# Дополнительные темы для Plymouth #######################
########### plymouth-theme-archlinux ###############
yay -S plymouth-theme-archlinux  #  Тема Plymouth для Arch Linux (аналог Manjaro) ; https://aur.archlinux.org/packages/plymouth-theme-archlinux ; https://aur.archlinux.org/plymouth-theme-archlinux.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/onurbbr/plymouth-theme-archlinux ; git+https://github.com/onurbbr/plymouth-theme-archlinux.git ; 2022-03-25 21:28 (UTC)
########### plymouth-theme-archlinux ###############
#git clone https://aur.archlinux.org/plymouth-theme-archlinux.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plymouth-theme-archlinux
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plymouth-theme-archlinux
#rm -Rf plymouth-theme-archlinux   # удаляем директорию сборки
########### plymouth-theme-arch-logo ###############
yay -S plymouth-theme-arch-logo --noconfirm  # Ремейк темы ubuntu-logo Plymouth, основанный на теме debian-logo, но с логотипом Arch Linux ; https://aur.archlinux.org/packages/plymouth-theme-arch-logo ; https://aur.archlinux.org/plymouth-theme-arch-logo.git (только для чтения, нажмите, чтобы скопировать) ; https://www.gnome-look.org/content/show.php/Arch-logo+plymouth?content=141697 ; https://aur.archlinux.org/cgit/aur.git/tree/plymouth-theme-arch-logo.tar.gz?h=plymouth-theme-arch-logo ; 2024-12-08 11:02 (UTC)
########### plymouth-theme-arch-logo ###############
#git clone https://aur.archlinux.org/plymouth-theme-arch-logo.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plymouth-theme-arch-logo
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plymouth-theme-arch-logo
#rm -Rf plymouth-theme-arch-logo   # удаляем директорию сборки
########### plymouth-theme-russia ###############
yay -S plymouth-theme-russia --noconfirm  # Заставка с гербом России для Плимута ; https://aur.archlinux.org/packages/plymouth-theme-russia ; https://aur.archlinux.org/plymouth-theme-russia.git (только для чтения, нажмите, чтобы скопировать) ; https://notabug.org/Thr0TT1e/russia-theme-plymouth ; git+https://notabug.org/Thr0TT1e/russia-theme-plymouth.git ; 2024-10-29 13:41 (UTC)
########### plymouth-theme-russia ###############
#git clone https://aur.archlinux.org/plymouth-theme-russia.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plymouth-theme-russia
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plymouth-theme-russia
#rm -Rf plymouth-theme-russia   # удаляем директорию сборки
########### plymouth-theme-arch-darwin ###############
yay -S plymouth-theme-arch-darwin --noconfirm  # Заставка Arch Linux для Plymouth ; https://aur.archlinux.org/packages/plymouth-theme-arch-darwin ; https://aur.archlinux.org/plymouth-theme-arch-darwin.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/armoredvortex/plymouth-theme-arch-darwin ; git+https://github.com/armoredvortex/plymouth-theme-arch-darwin.git ; 2022-04-09 08:50 (UTC)
########### plymouth-theme-arch-darwin ###############
#git clone https://aur.archlinux.org/plymouth-theme-arch-darwin.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plymouth-theme-arch-darwin
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plymouth-theme-arch-darwin
#rm -Rf plymouth-theme-arch-darwin   # удаляем директорию сборки
####################################
#  echo ""
# echo " Установка дополнительных утилит (пакетов) plymouth-theme для KDE Plasma Desktop "
########### breeze-plymouth ###############
#sudo pacman -S --noconfirm --needed breeze-plymouth  # Тема Plymouth для визуального стиля Breeze для Plasma Desktop ; https://archlinux.org/packages/extra/x86_64/breeze-plymouth/ ; https://kde.org/plasma-desktop/ ; Группы: plasma ; 2025-08-05 22:10 UTC
#sudo pacman -S --noconfirm --needed plymouth-kcm  # KCM будет управлять темой Plymouth (Boot) ; https://archlinux.org/packages/extra/x86_64/plymouth-kcm/ ; https://kde.org/plasma-desktop/ ; Группы: plasma ; 2025-08-05 22:10 UTC
#########################
  echo ""
  echo " Посмотрите информацию о версии (plymouth) "
# plymouth --version  # Показать версию приложения
sudo pacman -Q plymouth  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_plymouth == 2 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Plymouth (plymouth-git) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
########### plymouth-git ###############
yay -S plymouth-git --noconfirm  # Графический загрузочный экран-заставка (версия git) ; https://aur.archlinux.org/packages/plymouth-git ; https://aur.archlinux.org/plymouth-git.git (только для чтения, нажмите, чтобы скопировать) ; https://www.freedesktop.org/wiki/Software/Plymouth/ ; git+https://gitlab.freedesktop.org/plymouth/plymouth.git ; https://aur.archlinux.org/cgit/aur.git/tree/mkinitcpio-generate-shutdown-ramfs-plymouth.conf?h=plymouth-git ; https://aur.archlinux.org/cgit/aur.git/tree/plymouth-shutdown.initcpio_install?h=plymouth-git ; https://aur.archlinux.org/cgit/aur.git/tree/plymouth.initcpio_hook?h=plymouth-git ; https://aur.archlinux.org/cgit/aur.git/tree/plymouth.initcpio_install?h=plymouth-git ; https://aur.archlinux.org/cgit/aur.git/tree/plymouthd.conf.patch?h=plymouth-git ; Конфликты: с plymouth ; Обеспечивает: plymouth ; 2025-08-03 14:16 (UTC)
########### plymouth-git ###############
#git clone https://aur.archlinux.org/plymouth-git.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plymouth-git
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plymouth-git
#rm -Rf plymouth-git   # удаляем директорию сборки
  echo ""
  echo " Установка дополнительных утилит (пакетов) plymouth-theme "
################# Основные темы для Plymouth #######################
########### plymouth-theme-arch-os ###############
yay -S plymouth-theme-arch-os --noconfirm  # Тема Arch OS для Plymouth ; https://aur.archlinux.org/packages/plymouth-theme-arch-os ; https://aur.archlinux.org/plymouth-theme-arch-os.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/murkl/plymouth-theme-arch-os ; git+https://github.com/murkl/plymouth-theme-arch-os.git ; 2024-08-21 08:55 (UTC)
########### plymouth-theme-arch-os ###############
#git clone https://aur.archlinux.org/plymouth-theme-arch-os.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plymouth-theme-arch-os
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plymouth-theme-arch-os
#rm -Rf plymouth-theme-arch-os   # удаляем директорию сборки
########### plymouth-theme-aregression ###############
yay -S plymouth-theme-aregression --noconfirm  # Элегантный индикатор загрузки Plymouth ; https://aur.archlinux.org/packages/plymouth-theme-aregression ; https://aur.archlinux.org/plymouth-theme-aregression.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/yozachar/plymouth-theme-aregression ; https://github.com/yozachar/plymouth-theme-aregression/archive/v2.1.0.tar.gz ; 2024-04-16 14:15 (UTC)
########### plymouth-theme-aregression ###############
#git clone https://aur.archlinux.org/plymouth-theme-aregression.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plymouth-theme-aregression
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plymouth-theme-aregression
#rm -Rf plymouth-theme-aregression   # удаляем директорию сборки
########### plymouth-theme-monoarch ###############
yay -S plymouth-theme-monoarch --noconfirm  # Монохромная тема Arch Linux для Плимута ; https://aur.archlinux.org/packages/plymouth-theme-monoarch ; https://aur.archlinux.org/plymouth-theme-monoarch.git (только для чтения, нажмите, чтобы скопировать) ; https://farsil.github.io/monoarch/ ; https://github.com/farsil/monoarch/archive/0.1.tar.gz ; https://aur.archlinux.org/cgit/aur.git/tree/plymouth-theme-monoarch.install?h=plymouth-theme-monoarch ; 2016-10-20 17:43 (UTC)
########### plymouth-theme-monoarch ###############
#git clone https://aur.archlinux.org/plymouth-theme-monoarch.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plymouth-theme-monoarch
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plymouth-theme-monoarch
#rm -Rf plymouth-theme-monoarch   # удаляем директорию сборки
########### plymouth-theme-neat ###############
yay -S plymouth-theme-neat --noconfirm  # Тема Plymouth для Arch Linux с поддержкой HiDPI ; https://aur.archlinux.org/packages/plymouth-theme-neat ; https://aur.archlinux.org/plymouth-theme-neat.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/neetly/plymouth-theme-neat ; git+https://github.com/neetly/plymouth-theme-neat.git#tag=v0.1.0 ; 2022-11-28 12:00 (UTC)
########### plymouth-theme-neat ###############
#git clone https://aur.archlinux.org/plymouth-theme-neat.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plymouth-theme-neat
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plymouth-theme-neat
#rm -Rf plymouth-theme-neat   # удаляем директорию сборки
### Тема Plymouth для Arch Linux с поддержкой HiDPI
# paru -S --needed plymouth-theme-neat
# sudo plymouth-set-default-theme neat
# echo "DeviceScale=1" | sudo tee -a /etc/plymouth/plymouthd.conf
# sudo mkinitcpio -P
################# Дополнительные темы для Plymouth #######################
########### plymouth-theme-archlinux ###############
yay -S plymouth-theme-archlinux  #  Тема Plymouth для Arch Linux (аналог Manjaro) ; https://aur.archlinux.org/packages/plymouth-theme-archlinux ; https://aur.archlinux.org/plymouth-theme-archlinux.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/onurbbr/plymouth-theme-archlinux ; git+https://github.com/onurbbr/plymouth-theme-archlinux.git ; 2022-03-25 21:28 (UTC)
########### plymouth-theme-archlinux ###############
#git clone https://aur.archlinux.org/plymouth-theme-archlinux.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plymouth-theme-archlinux
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plymouth-theme-archlinux
#rm -Rf plymouth-theme-archlinux   # удаляем директорию сборки
########### plymouth-theme-arch-logo ###############
yay -S plymouth-theme-arch-logo --noconfirm  # Ремейк темы ubuntu-logo Plymouth, основанный на теме debian-logo, но с логотипом Arch Linux ; https://aur.archlinux.org/packages/plymouth-theme-arch-logo ; https://aur.archlinux.org/plymouth-theme-arch-logo.git (только для чтения, нажмите, чтобы скопировать) ; https://www.gnome-look.org/content/show.php/Arch-logo+plymouth?content=141697 ; https://aur.archlinux.org/cgit/aur.git/tree/plymouth-theme-arch-logo.tar.gz?h=plymouth-theme-arch-logo ; 2024-12-08 11:02 (UTC)
########### plymouth-theme-arch-logo ###############
#git clone https://aur.archlinux.org/plymouth-theme-arch-logo.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plymouth-theme-arch-logo
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plymouth-theme-arch-logo
#rm -Rf plymouth-theme-arch-logo   # удаляем директорию сборки
########### plymouth-theme-russia ###############
yay -S plymouth-theme-russia --noconfirm  # Заставка с гербом России для Плимута ; https://aur.archlinux.org/packages/plymouth-theme-russia ; https://aur.archlinux.org/plymouth-theme-russia.git (только для чтения, нажмите, чтобы скопировать) ; https://notabug.org/Thr0TT1e/russia-theme-plymouth ; git+https://notabug.org/Thr0TT1e/russia-theme-plymouth.git ; 2024-10-29 13:41 (UTC)
########### plymouth-theme-russia ###############
#git clone https://aur.archlinux.org/plymouth-theme-russia.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plymouth-theme-russia
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plymouth-theme-russia
#rm -Rf plymouth-theme-russia   # удаляем директорию сборки
########### plymouth-theme-arch-darwin ###############
yay -S plymouth-theme-arch-darwin --noconfirm  # Заставка Arch Linux для Plymouth ; https://aur.archlinux.org/packages/plymouth-theme-arch-darwin ; https://aur.archlinux.org/plymouth-theme-arch-darwin.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/armoredvortex/plymouth-theme-arch-darwin ; git+https://github.com/armoredvortex/plymouth-theme-arch-darwin.git ; 2022-04-09 08:50 (UTC)
########### plymouth-theme-arch-darwin ###############
#git clone https://aur.archlinux.org/plymouth-theme-arch-darwin.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plymouth-theme-arch-darwin
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plymouth-theme-arch-darwin
#rm -Rf plymouth-theme-arch-darwin   # удаляем директорию сборки
################################################
########### plymouth-theme-endeavoros ###############
### Рекомендуемый способ использования этой темы в EndeavourOS — использование этой темы с plymouth-git пакетом AUR, который является более новым и имеет больше функций (включая поддержку состояния Capslock).
########### plymouth-theme-endeavoros ###############
yay -S plymouth-theme-endeavoros --noconfirm  # Тема Plymouth для EndeavourOS ; https://aur.archlinux.org/packages/plymouth-theme-endeavouros ; https://aur.archlinux.org/plymouth-theme-endeavouros.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/tomaspinho/plymouth-endeavouros ; git+https://github.com/tomaspinho/plymouth-endeavouros.git ; 2024-01-25 22:06 (UTC)
########### plymouth-theme-endeavoros ###############
#git clone https://aur.archlinux.org/plymouth-theme-endeavouros.git  # (только для чтения, нажмите, чтобы скопировать)
#cd plymouth-theme-endeavoros
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf plymouth-theme-endeavoros
#rm -Rf plymouth-theme-endeavoros   # удаляем директорию сборки
###############
### plymouth-theme-endeavoros
# Тема Plymouth с обоями и цветовой схемой EndeavourOS.
# Поддерживает диалоговое окно ввода пароля, ход загрузки, состояние Caps Lock и т. д.
# Установка: Рекомендуемый способ использования этой темы в EndeavourOS — использование этой темы с plymouth-gitпакетом AUR, который является более новым и имеет больше функций (включая поддержку состояния Capslock).
# # Install theme and the recommended version of Plymouth
# yay -Sy plymouth-git plymouth-theme-endeavouros
# Добавьте параметр ядра "splash", чтобы при загрузке отображался Plymouth
# sudo sed -i '$ s/$/ splash/' /etc/kernel/cmdline
# Таким образом, Plymouth и тема будут немедленно установлены в вашу initramfs для следующей загрузки.
# В будущих обновлениях ядра Plymouth и эта тема будут включены автоматически.
# sudo reinstall-kernels
####################################
#  echo ""
# echo " Установка дополнительных утилит (пакетов) plymouth-theme для KDE Plasma Desktop "
########### breeze-plymouth ###############
#sudo pacman -S --noconfirm --needed breeze-plymouth  # Тема Plymouth для визуального стиля Breeze для Plasma Desktop ; https://archlinux.org/packages/extra/x86_64/breeze-plymouth/ ; https://kde.org/plasma-desktop/ ; Группы: plasma ; 2025-08-05 22:10 UTC
#sudo pacman -S --noconfirm --needed plymouth-kcm  # KCM будет управлять темой Plymouth (Boot) ; https://archlinux.org/packages/extra/x86_64/plymouth-kcm/ ; https://kde.org/plasma-desktop/ ; Группы: plasma ; 2025-08-05 22:10 UTC
#########################
  echo ""
  echo " Посмотрите информацию о версии (plymouth) "
# plymouth --version  # Показать версию приложения
sudo pacman -Q plymouth  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
### Plymouth (plymouth):
# https://www.freedesktop.org/wiki/Software/Plymouth/
# https://archlinux.org/packages/extra/x86_64/plymouth/
# https://aur.archlinux.org/packages/plymouth-git
# Установка и настройка Plymouth:
# https://wiki.archlinux.org/title/Plymouth
# https://github.com/greg-js/arch-wiki-md-repo/blob/master/wiki/_content/russian/Plymouth%20(russian).md
# https://www.freedesktop.org/wiki/Software/Plymouth/
# Plymouth Themes:
# https://www.gnome-look.org/browse?cat=108&ord=latest
# https://store.kde.org/browse?cat=108&ord=latest
# https://www.gnome-look.org/browse/
# https://www.xfce-look.org/browse/
# https://store.kde.org/browse/
####################################
sleep 03

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
### end of script
# <<< Делайте выводы сами! >>>