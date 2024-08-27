#!/usr/bin/env bash
# Install script Cloud_Storage
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

Cloud_Storage_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
########

clear
echo -e "${CYAN}
  <<< Установка Облачных хранилищ (для ваших файлов) в системе Arch Linux >>> ${NC}"
# Installing Cloud Storage (for your files) on an Arch Linux system
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить MEGASync (megasync) - Облако MEGA на вашем рабочем столе?"
echo -e "${MAGENTA}:: ${BOLD}MEGAsync — это платформенно-независимая программа, которая работает на Linux, Windows и macOS. Как и Dropbox, MEGA Cloud Drive позволяет своим пользователям синхронизировать файлы и папки между MEGA Cloud Drive и локальной системой. Все изменения, внесенные в файлы на MEGA Cloud Drive, будут автоматически отражены на вашем локальном компьютере, и наоборот. Простая автоматизированная синхронизация и резервное копирование между вашими компьютерами и вашим облачным диском MEGA. Не забудьте о причине, по которой вы используете облачное хранилище, вам также могут понадобиться решения для резервного копирования, которые недоступны в облачном хранилище. ${NC}"
echo " Домашняя страница: https://mega.nz/ (https://github.com/meganz/MEGAsync/ ; https://aur.archlinux.org/packages/megasync) "  
echo -e "${MAGENTA}:: ${BOLD}MEGA  — один из  немногих поставщиков услуг облачного хранения с собственным клиентом Linux. Благодаря шифрованию с нулевым разглашением он является хорошим выбором облачного сервиса для всех типов пользователей Linux. MEGA утверждает, что обеспечивает сквозное шифрование и, таким образом, сохраняет конфиденциальность ваших данных. Ключ шифрования хранится у пользователя, а не у поставщика облачных услуг, утверждает MEGA. ${NC}"
echo " Некоторые ключевые особенности облачного сервиса MEGA: Uo до 20 ГБ бесплатного облачного хранилища; Дополнительное облачное хранилище от 4,99 евро в месяц за 400 ГБ; Сквозное шифрование с нулевым разглашением; Доступно в веб-браузере; Версионность файлов; Безопасный обмен файлами; Параметры приватного чата; Автоматическая загрузка камеры со смартфонов; Просмотрщик фотографий и видеоплеер в веб-браузере; Выборочная синхронизация для приложений; Транслируйте медиа на свой любимый плеер; Удалённые данные хранятся в течение 30 дней. " 
echo -e "${CYAN}:: ${NC}Установка MEGASync (megasync) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_megasync  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_megasync" =~ [^10] ]]
do
    :
done
if [[ $in_megasync == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_megasync == 1 ]]; then
  echo ""
  echo " Установка MEGASync (megasync) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
#sudo pacman -S --noconfirm --needed megatools  # CLI для МЕГА ; https://megatools.megous.com/ ; https://archlinux.org/packages/extra/x86_64/megatools/ ; 1 мая 2024 г., 15:21 UTC
####### megasync ##########
yay -S megasync --noconfirm  # Официальное приложение MEGA для ПК для синхронизации с MEGA Cloud Drive ; https://aur.archlinux.org/megasync.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/meganz/MEGAsync/ ; https://aur.archlinux.org/packages/megasync ; 2024-08-14 21:02 (UTC)
#git clone https://aur.archlinux.org/megasync.git   # (только для чтения, нажмите, чтобы скопировать)
#cd megasync
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf megasync 
#rm -Rf megasync
####### megasync-bin ##########
# yay -S megasync-bin --noconfirm  #  Простая автоматическая синхронизация между вашими компьютерами и вашим облачным диском MEGA ; https://aur.archlinux.org/megasync-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://mega.nz/#sync ; https://aur.archlinux.org/packages/megasync-bin ; 2024-08-13 14:53 (UTC) ; Конфликты: с megasync, megatools ; https://mega.nz/linux/repo/Arch_Extra/x86_64/megasync-5.4.1-1-x86_64.pkg.tar.zst
########### thunar-megasync-bin ###########
# yay -S thunar-megasync-bin --noconfirm  # Управление облачным диском MEGA с помощью файлового менеджера Thunar ; https://aur.archlinux.org/thunar-megasync-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://mega.nz/ ; https://aur.archlinux.org/packages/thunar-megasync-bin ; 2024-03-02 11:27 (UTC) ; Конфликты: с thunar-gtk3-megasync, thunar-megasync ; Смотрите Зависимости !
########### dolphin-megasync-bin ###########
# yay -S dolphin-megasync-bin --noconfirm  # Расширение для файловых менеджеров на базе KDE для взаимодействия с Megasync ; https://aur.archlinux.org/dolphin-megasync-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://mega.nz/ ; https://aur.archlinux.org/packages/dolphin-megasync-bin ; 2024-07-06 16:05 (UTC ; Конфликты: с dolphin-megasync, dolphin-megasync-git ; Смотрите Зависимости !
########### nautilus-megasync ###########
# yay -S nautilus-megasync --noconfirm  # Загрузите файлы в свой аккаунт Mega из Nautilus ; https://aur.archlinux.org/nautilus-megasync.git (только для чтения, нажмите, чтобы скопировать) ; https://mega.io/desktop#downloadapps ; https://aur.archlinux.org/packages/nautilus-megasync ; 2023-08-14 12:38 (UTC)
mkdir ~/MEGASync
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Yandex Disk (yandex-disk) - Облачный сервис?"
echo -e "${MAGENTA}:: ${BOLD}Яндекс Диск — это надежное облачное хранилище для ваших файлов, принадлежащий компании Яндекс, позволяющий пользователям хранить свои данные на серверах в «облаке» и передавать их другим пользователям в Интернете. Основное назначение сервиса — синхронизация файлов между различными устройствами. Вы можете работать с файлами на Диске с любого устройства, подключенного к интернету. На Диске ваши файлы в безопасности — используйте их в любое время! ${NC}"
echo " Домашняя страница: http://disk.yandex.ru/ ; (https://aur.archlinux.org/packages/yandex-disk ; https://aur.archlinux.org/packages/yandex-disk-indicator). "  
echo -e "${MAGENTA}:: ${BOLD}«Яндекс Диск» — часть экосистемы «Яндекс 360», где есть почта, аналог Microsoft Office, календарь, заметки и система видеосвязи «Телемост». Все это управляется одной учетной записью «Яндекс ID». Отдельных тарифов для «Диска» нет, поэтому подписчик сразу получает несколько сервисов. Одно из ключевых преимуществ сервиса — расширенные возможности загрузки файлов. Например, на платных тарифах можно загружать файлы объемом более 1 Гб, а еще есть автоматическая загрузка мультимедиа: все фото и видео сразу отправляются в отдельный раздел диска и не занимают общее место в хранилище. Также в сервисе хорошо работает поиск. Достаточно написать, что должно быть на фото, — и система найдет подходящие файлы. Это удобно, если в хранилище много изображений, но они не рассортированы по тематике. ${NC}"
echo " У сервиса простой интерфейс без тонких настроек. Разобраться в нем легко, а в бесплатной версии четверть экрана занимает реклама других сервисов «Яндекса». Поиск сервиса не всегда распознает детали, например конкретную марку автомобиля, но совсем неподходящие фото не покажет. «Яндекс Диск» есть на всех основных платформах. Набор функций может немного различаться, но все основные операции с файлами спокойно выполняются даже из мобильного браузера. При работе с сервисом иногда встречаются технические сложности. Так, изображения могут не открываться в браузере, файлы порой не с первого раза перемещаются между папками или не удаляются. При этом сервис не показывает, в чем ошибка, а только сообщает об общем сбое. Скорость загрузки и скачивания при этом стабильная, но не очень высокая — 1—2,5 Мбит/с. «Яндекс» рекомендует использовать фирменные приложения, чтобы скорость была выше, но существенных изменений в тестах я не заметил. "
echo -e "${CYAN}:: ${NC}Установка Яндекс Диск (yandex-disk) и (yandex-disk-indicator) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_yadisk  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_yadisk" =~ [^10] ]]
do
    :
done
if [[ $in_yadisk == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_yadisk == 1 ]]; then
  echo ""
  echo " Установка Яндекс Диск (yandex-disk) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
########### yandex-disk #########
yay -S yandex-disk --noconfirm  # Яндекс.Диск хранит ваши файлы всегда под рукой ; https://aur.archlinux.org/yandex-disk.git (только для чтения, нажмите, чтобы скопировать) ; http://disk.yandex.ru/ ; https://repo.yandex.ru/yandex-disk/deb/pool/main/y/yandex-disk/yandex-disk_0.1.6.1080_amd64.deb ; https://aur.archlinux.org/cgit/aur.git/tree/yandex-disk.install?h=yandex-disk ; 2024-02-12 10:54 (UTC)
#git clone https://aur.archlinux.org/yandex-disk.git   # (только для чтения, нажмите, чтобы скопировать)
#cd yandex-disk
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf yandex-disk
#rm -Rf yandex-disk
########### yandex-disk-indicator #########
yay -S yandex-disk-indicator --noconfirm  # Панель индикатора (GUI) для CLI-клиента ЯндексДиска для Linux ; https://aur.archlinux.org/yandex-disk-indicator.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/slytomcat/yandex-disk-indicator/ ; https://aur.archlinux.org/packages/yandex-disk-indicator ; https://github.com/slytomcat/yandex-disk-indicator/archive/1.12.2.tar.gz ; 2023-10-15 17:55 (UTC)
#git clone https://aur.archlinux.org/yandex-disk-indicator.git   # (только для чтения, нажмите, чтобы скопировать)
#cd yandex-disk-indicator
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf yandex-disk-indicator
#rm -Rf yandex-disk-indicator
mkdir ~/Yandex.Disk
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Cozy Drive for Desktop (cozy-desktop) - Синхронизация файлов для Cozy Cloud на рабочем столе?"
echo -e "${MAGENTA}:: ${BOLD}Cozy - это облачная служба синхронизации, похожая на Dropbox , Google Drive и другие. Когда пользователи подписываются на сервис, они получают 5 ГБ свободного места для хранения данных. Пользователи могут получить доступ к своей учетной записи Cozy на различных платформах. Официально сервис поддерживает Mac, Windows и Linux, а также мобильные платформы, такие как iOS и Android. *Примечание: чтобы использовать Cozy в Linux, вы должны создать бесплатную учетную запись. Перейдите на официальный сайт, найдите «Создать уютный дом бесплатно» и выберите его, чтобы начать работу. Cozy Drive for Desktop позволяет вам синхронизировать файлы, хранящиеся в вашем Cozy, с вашим ноутбуком и/или настольным компьютером. Он копирует ваши файлы на ваш жесткий диск и применяет внесенные вами изменения на других синхронизированных устройствах и на вашем онлайн-Cozy. ${NC}"
echo " Домашняя страница: https://cozy.io/en/ ; (https://cozy-labs.github.io/cozy-desktop/). "  
echo -e "${MAGENTA}:: ${BOLD}Одна группа разработчиков решила, что лучшим компромиссом будет запилить своё собственное персональное облако с блекджеком и шлюхами, календарём и контактами. В результате появился Cozy Cloud — решение с открытым исходным кодом, доступное любому желающему. Cozy Drive для настольных компьютеров разработан компанией Cozy Cloud и распространяется по лицензии AGPL v3 . ${NC}"
echo " Cozy можно перевести, как «уютный». Это действительно этакий уютный личный кабинет в котором вы можете: хранить и синхронизировать свои контакты; хранить и синхронизировать свои документы, фотографии и иные файлы; публиковать файлы, документы, фотографии; хранить и делиться своими визитными карточками; вести список дел (органайзер); вести календарь; управлять своими финансами; управлять своей почтой и многое другое — просто подключите нужный плагин. И это все будет на вашем личном сервере. Никто не будет сканировать ваши данные, чтобы таргетировать рекламу. Вы можете разместить свои данные в той стране, в которой захотите, в том дата-центе и у того хостера, которому доверяете. Проект активно живёт, обновляется и дополняется. К нему уже написано множество плагинов на все случаи жизни с возможностью установки в один клик. Кроме того, разработчики готовят к релизу обновлённый Cozy Cloud, который будет и красивее, и функциональнее. Обещают, что обновится можно будет из текущей версии. У Cozy действительно большие цели. Они пытаются создать платформу, на которой вы сможете развернуть любой понравившийся вам облачный сервис. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_cozyd  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_cozyd" =~ [^10] ]]
do
    :
done
if [[ $in_cozyd == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_cozyd == 1 ]]; then
  echo ""
  echo " Установка Cozy Cloud Sync (cozy-desktop) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed cozy-desktop  # Синхронизация файлов для Cozy Cloud на рабочем столе ; https://cozy-labs.github.io/cozy-desktop/ ; https://archlinux.org/packages/extra/x86_64/cozy-desktop/ ; Dec. 23, 2023, 8:24 p.m. UTC ; https://translated.turbopages.org/proxy_u/en-ru.ru.1e0c8595-66c6abbe-b58d88d5-74722d776562/https/github.com/cozy-labs/cozy-desktop/blob/master/doc/usage/linux.md
# sudo pacman -Rcns cozy-desktop
# Все ваши данные Cozy Drive в Linux находятся в папке ~ / Cozy Drive . Если вам нужно добавить новые файлы и папки в эту область, но вы не знаете, как это сделать, вот что нужно сделать.
mkdir ~/Cozy Drive
# После завершения установки запустите сервис Cozy Cloud:
# sudo systemctl start cozy.service
# Включите Cozy Cloud для запуска при загрузке:
# sudo systemctl enable cozy.service
############ cozy-stack ##########
# sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -S --noconfirm --needed cozy-stack  # Цифровой дом: объединяет все ваши веб-сервисы в одном частном пространстве – компонент Stack ; https://cozy.io/ ; https://archlinux.org/packages/extra/x86_64/cozy-stack/ ; 9 июня 2024 г., 22:27 UTC
# Запуск стека: На этом этапе вам следует запустить/включить демон cozy-stack.service.
# sudo systemctl start cozy-stack.service  # Запустите сервис Cozy Cloud
# sudo systemctl enable cozy-stack.service  # Включите Cozy Cloud для запуска при загрузке
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
######### Справка #############
# Cozy Cloud Sync
# https://cozy.io/en/download/
# https://wiki.archlinux.org/title/Cozy
# Чтобы отобразить настройки приложения и список недавно синхронизированных файлов, вы можете либо запустить приложение снова (т. Е. Оно просто откроет окно приложения, поскольку одновременно может запускаться только один экземпляр), либо нажать на значок системного трея. Если в вашей системе установлен libappindicator, нажатие левой кнопкой мыши не будет иметь никакого эффекта, поэтому вам нужно щелкнуть правой кнопкой мыши по значку, а затем выбрать пункт меню Показать приложение.
# libappindicator  - https://archlinux.org/packages/?sort=&q=libappindicator&maintainer=&flagged=
# После завершения установки запустите сервис Cozy Cloud:
# sudo systemctl start cozy.service
# Включите Cozy Cloud для запуска при загрузке:
# sudo systemctl enable cozy.service
##################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Dropbox (dropbox) - Синхронизация файлов?"
echo -e "${MAGENTA}:: ${BOLD}Dropbox — файловый хостинг компании Dropbox Inc., включающий персональное облачное хранилище, синхронизацию файлов и программу-клиент. Штаб-квартира компании расположена в Сан-Франциско. Dropbox - один из самых популярных облачных сервисов, который позволяет хранить, синхронизировать файлы и обмениваться ими через Интернет. ${NC}"
echo " Домашняя страница: https://www.dropbox.com/ ; (https://aur.archlinux.org/packages/dropbox ; https://wiki.archlinux.org/title/Dropbox). "  
echo -e "${MAGENTA}:: ${BOLD}Dropbox представляет собой папку на вашем компьютере, которая является «облачной», все данные в ней синхронизируются в реальном времени. Все файлы, которые вы поместите в нее, автоматически закачиваются на сервер Dropbox. Как только вы делаете изменения в каких-либо файлах, измененные файлы моментально закачиваются на сервер. Затем, вы с другого компьютера можете запустить Dropbox, на нем также создается папка для ваших файлов, и происходит автоматическая синхронизация файлов с сервером. Т.е. изменения, сделанные на одном компьютере, отобразятся на другом. Более того, все ваши файлы вы можете посмотреть через веб-интерфейс. ${NC}"
echo " Преимущества Dropbox: Удобный интерфейс и простой процесс настройки. Эффективная синхронизация файлов, гарантирующая быстрое распространение изменений на всех устройствах. Функции совместной работы, такие как обмен файлами и групповые папки, делают его пригодным как для личного, так и для делового использования. " 
echo " Основные функции и возможности Dropbox включают: Хранение файлов: Пользователи могут загружать файлы любого типа и размера в своё облачное хранилище Dropbox, чтобы иметь к ним доступ в любое время и с любого устройства с подключением к интернету. Синхронизация: Dropbox синхронизирует файлы между всеми устройствами пользователя, где установлено приложение. Это означает, что изменения, сделанные в файле на одном устройстве, автоматически отражаются на всех других устройствах. Обмен файлами: Пользователи могут делиться файлами или папками с другими людьми, даже если они не являются пользователями Dropbox. Это делается путём создания ссылки на файл или папку. Версии файлов и восстановление: Dropbox сохраняет историю изменений файлов, что позволяет восстанавливать предыдущие версии файлов или файлы, которые были случайно удалены. Безопасность: Обеспечивается защита данных с помощью шифрования как в процессе передачи данных, так и при их хранении на серверах. "
echo -e "${CYAN}:: ${NC}Установка Dropbox (dropbox) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_dropbox  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_dropbox" =~ [^10] ]]
do
    :
done
if [[ $in_dropbox == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_dropbox == 1 ]]; then
  echo ""
  echo " Установка Dropbox (dropbox) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
sudo pacman -S --noconfirm --needed python-gpgme  # Привязки Python для GPGme ; https://www.gnupg.org/related_software/gpgme/ ; https://archlinux.org/packages/core/x86_64/python-gpgme/ ; 21 июля 2024 г., 7:32 UTC
# Перед первым запуском dropbox AUR обязательно установите python-gpgme . В противном случае программа не сможет подписать двоичные файлы и проверить подписи при следующем запуске. По какой-то причине dropbox AUR не пометил этот пакет как обязательную зависимость, но он все еще таковой является.
# GnuPG Made Easy (GPGME) — это библиотека, разработанная для упрощения доступа к GnuPG для приложений. Она предоставляет API High-Level Crypto для шифрования, дешифрования, подписи, проверки подписи и управления ключами. В настоящее время она использует бэкэнд OpenPGP от GnuPG по умолчанию, но API не ограничивается этим движком. Фактически, мы уже разработали бэкэнд для CMS (S/MIME).
##### dropbox ########
#yay -S dropbox --noconfirm  # Бесплатный сервис, позволяющий вам переносить свои фотографии, документы и видео куда угодно и легко делиться ими ; https://www.dropbox.com/ ; https://aur.archlinux.org/dropbox.git (только для чтения, нажмите, чтобы скопировать) ; 2024-08-12 14:54 (UTC) ; https://linux.dropbox.com/fedora/rpm-public-key.asc
git clone https://aur.archlinux.org/dropbox.git   # (только для чтения, нажмите, чтобы скопировать)
cd dropbox
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf dropbox 
rm -Rf dropbox
##### dropbox-cli ########
# yay -S dropbox-cli --noconfirm  # Интерфейс командной строки для Dropbox ; https://aur.archlinux.org/dropbox-cli.git (только для чтения, нажмите, чтобы скопировать) ; https://www.dropbox.com/ ; https://aur.archlinux.org/packages/dropbox-cli ;  2024-04-21 22:34 (UTC) ; Смотрите Зависимости !
# Начиная с версии 2024.04.17-1 dropbox-cli собирается из исходного кода nautilus-dropbox, поскольку в настоящее время исходный файл dropbox.py не соответствует последнему выпуску в https://linux.dropbox.com/packages/
# Для тех, кто ищет PKGBUILD: https://aur.archlinux.org/packages/dropbox-cli
##### thunar-dropbox ########
# yay -S thunar-dropbox --noconfirm  # Плагин для Thunar, добавляющий элементы контекстного меню для Dropbox ; https://aur.archlinux.org/thunar-dropbox.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/Jeinzi/thunar-dropbox ; https://github.com/Jeinzi/thunar-dropbox/archive/0.3.1.zip ; 2019-07-27 22:43 (UTC) ; Смотрите Зависимости ! thunar; cmake; git.
#git clone https://aur.archlinux.org/thunar-dropbox.git   # (только для чтения, нажмите, чтобы скопировать)
#cd thunar-dropbox
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf thunar-dropbox 
#rm -Rf thunar-dropbox
######## dolphin-plugins ###########
# sudo pacman -S --noconfirm --needed dolphin-plugins  # Дополнительные плагины Dolphin ; https://apps.kde.org/dolphin_plugins/ ; https://archlinux.org/packages/kde-unstable/x86_64/dolphin-plugins/ ; 15 августа 2024 г., 21:02 UTC
######## nautilus-dropbox ###########
# yay -S nautilus-dropbox --noconfirm  # Расширение Dropbox Nautilus ; https://aur.archlinux.org/nautilus-dropbox.git (только для чтения, нажмите, чтобы скопировать) ; https://www.dropbox.com/ ; https://aur.archlinux.org/packages/nautilus-dropbox ; https://github.com/dropbox/nautilus-dropbox.git ; 2022-12-11 06:02 (UTC) ; Смотрите Зависимости !
# При этом устанавливается плагин, который интегрирует Dropbox в файловый менеджер Nautilus. После установки может появится сообщение: Nautilus Restart Required Dropbox requires Nautilus to be restarted to function properly. и вам нужно нажать на кнопку Restart Nautilus.
##### Оформление ###########
######## dropbox-light-icons-git ###########
# yay -S dropbox-light-icons-git --noconfirm  # Светлые значки Dropbox для темных панелей ; https://aur.archlinux.org/dropbox-light-icons-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/subosito/dropbox-light-icons ; https://aur.archlinux.org/packages/dropbox-light-icons-git ; git://github.com/subosito/dropbox-light-icons.git ; 2017-03-12 15:41 (UTC) ; Конфликты: с dropbox-kfilebox-icons, dropbox-plasma-dark-icons-git, dropbox-plasma-light-icons-git ; Смотрите Зависимости !
#git clone https://aur.archlinux.org/dropbox-light-icons-git.git   # (только для чтения, нажмите, чтобы скопировать)
#cd dropbox-light-icons-git
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf dropbox-light-icons-git
#rm -Rf dropbox-light-icons-git
########## adapta-nokto-dropbox-icons ######
# yay -S adapta-nokto-dropbox-icons --noconfirm  # Иконки Dropbox PNG, созданные из файлов Papirus Adapta Nokto SVG ; https://aur.archlinux.org/adapta-nokto-dropbox-icons.git (только для чтения, нажмите, чтобы скопировать) ; https://aur.archlinux.org/packages/adapta-nokto-dropbox-icons ; 2018-07-02 20:53 (UTC) ; Смотрите Зависимости ! imagemagick; papirus-icon-theme 
######## dropbox-kde-systray-icons ############
# yay -S dropbox-kde-systray-icons --noconfirm  # Значки системного трея Dropbox, которые лучше подходят для KDE ; https://aur.archlinux.org/dropbox-kde-systray-icons.git (только для чтения, нажмите, чтобы скопировать) ; https://www.opendesktop.org/c/1466612163 ; https://aur.archlinux.org/packages/dropbox-kde-systray-icons ; 2019-01-05 00:52 (UTC) ; Смотрите Зависимости !
mkdir ~/Dropbox
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
######## Справка #############
# Dropbox (dropbox) - https://www.dropbox.com/
# https://aur.archlinux.org/packages/dropbox
# https://aur.archlinux.org/packages/thunar-dropbox-git
# https://wiki.archlinux.org/title/Dropbox
# https://aur.archlinux.org/packages?O=0&SeB=nd&K=dropbox&outdated=&SB=p&SO=d&PP=50&submit=Go
# Выполните следующую команду в случае возникновения ошибок во время «Проверки подписей исходных файлов с помощью gpg...»
# gpg --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E
# Кроме того, вы можете загрузить открытый ключ Dropbox с https://linux.dropbox.com/fedora/rpm-public-key.asc 
# и импортировать его с помощью:
# gpg --import rpm-public-key.asc
# Вы можете проверить, успешно ли импортированы ключи или нет, используя вывод gpg -k. Вы должны найти что-то вроде этого:
# pub   rsa2048 2010-02-11 [SC]
#       1C61A2656FB57B7E4DE0F4C1FC918B335044912E
# uid   [ unknown] Dropbox Automatic Signing Key <linux@dropbox.com>
# Инструкцию по установке Dropbox в Ubuntu вы можете также почитать на https://www.getdropbox.com/downloading?os=lnx
# Установка Dropbox на компьютер без монитора через командную строку
# Демон Dropbox работает только на 64-разрядных серверах Linux. Чтобы установить его, выполните указанную ниже команду в терминале Linux.
# cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
# После этого запустите демон Dropbox из вновь созданной папки .dropbox-dist.
# ~/.dropbox-dist/dropboxd
# Если вы используете программу Dropbox на своем сервере впервые, то при создании нового аккаунта или добавлении сервера в существующий аккаунт вам будет необходимо скопировать и вставить ссылку в рабочий браузер. После этого в вашем домашнем каталоге будет создана папка Dropbox. Чтобы управлять программой Dropbox из командной строки, скачайте этот сценарий Python . Для простого доступа поместите символическую ссылку на сценарий в любой позиции системной переменной PATH.
# После установки и настройки Dropbox вы можете начать использовать его для синхронизации и обмена файлами. 
# Вот несколько полезных команд:
# dropbox start: Запустите Dropbox
# dropbox start -i  : Запустите мастер настройки Dropbox
# dropbox status: Проверьте статус синхронизации Dropbox.
# dropbox filestatus: Проверьте статус отдельных файлов.
# dropbox exclude add [directory]: Исключить каталог из синхронизации Dropbox.
# dropbox exclude remove [directory]: Удалить каталог из списка исключений.
# dropbox sharelink [file]: Создание ссылки для общего доступа к файлу.
# killall dropbox : чтобы завершить все лишние процессы Dropbox
# dropbox stop : Если Dropbox не отображается на панели, но попытка запустить его из меню «Приложения» не работает, вы можете попробовать выполнить в окне терминала следующее, И тогда вы сможете запустить Dropbox из меню «Приложения».
###############################
sleep 3

clear
echo -e "${GREEN}
  <<< Поздравляем! Установка софта (пакетов) завершена! >>> ${NC}"
# Congratulations! Installation is complete.
#echo -e "${GREEN}==> ${NC}Установка завершена!"
#echo 'Установка завершена!'
# The installation is now complete!
echo ""
echo -e "${YELLOW}==> ${NC}Желательно перезагрузить систему для применения изменений"
#echo 'Желательно перезагрузить систему для применения изменений'
# It is advisable to restart the system to apply the changes
echo -e "${BLUE}:: ${BOLD}Посмотрим дату и время ... для проверки времени ${NC}"
date  # Посмотрим дату и время без характеристик для проверки времени
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'  # одновременно отображает дату и часовой пояс

echo -e "${BLUE}:: ${BOLD}Отобразить время работы системы ... ${NC}"
uptime

echo -e "${YELLOW}==> ...${NC}"
echo -e "${BLUE}:: ${NC}Если хотите установить дополнительный софт (пакеты), тогда после перезагрузки и входа в систему выполните команду:"
echo -e "${YELLOW}==> ${CYAN}wget git.io/archmy5l && sh archmy5l ${NC}"
# Команды по установке :
# wget git.io/archmy4l
# sh archmy4l
# wget git.io/archmy4 && sh archmy4l --noconfirm
echo -e "${CYAN}:: ${NC}Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов."
echo -e "${GREEN}
  <<< Желаю Вам удачи во всех начинаниях, верных и точных решений! >>> ${NC}"
echo ""
echo -e "${GREEN}
  <<< ♥ Либо ты идешь вперед... либо в зад. >>> ${NC}"
#echo '♥ Либо ты идешь вперед... либо в зад.'
# ♥ Either you go forward... or you go up your ass.
# ===============================================
echo -e "${RED}### ${BLUE}########################################################### ${RED}### ${NC}"
echo -e "${RED}==> ${BOLD}Выходим из установленной системы ${NC}"

echo -e "${BLUE}:: ${BOLD}Теперь вам надо ввести exit, затем перезагрузить систему ${NC}"
echo ""
echo " Установка завершена для выхода введите >> exit << "
#exit(0)  # означает чистый выход без каких-либо ошибок (проблем)
#exit(1)  # означает, что была какая-то ошибка (проблема), и именно поэтому программа выходит
#exit

# -------------------------------------------------

# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps

# ---------------------------------------------------

#
# https://aur.archlinux.org/packages/github-desktop/
# Графический интерфейс для управления Git и GitHub.
# База пакета: github-desktop
# URL восходящего направления:	https://desktop.github.com
# Git Clone URL: https://aur.archlinux.org/github-desktop.git  (только для чтения, нажмите, чтобы скопировать)
# Популярность:	1,59
# Первый отправленный:	2017-07-22 21:26
# Последнее обновление:	2020-09-14 00:41

# https://aur.archlinux.org/packages/git-hub/
# Интерфейс командной строки Git для GitHub
# База пакета: github
# URL восходящего направления:	https://github.com/sociantic-tsunami/git-hub
# Git Clone URL: https://aur.archlinux.org/git-hub.git  (только для чтения, нажмите, чтобы скопировать)
# Популярность:	0,000000
# Первый отправленный:	2013-09-20 14:24
# Последнее обновление:	2020-01-15 10:44

# <<< Делайте выводы сами! >>>
#
### end of script