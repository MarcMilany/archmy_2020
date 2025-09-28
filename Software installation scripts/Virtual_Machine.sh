#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! ####
apptitle="Arch Linux Fast Install v2.5 LegasyBIOS - Version: 2025.09.24.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя
###
VIRTUAL_MACHINE_LANG="russian"  # Installer default language (Язык установки по умолчанию)
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

clear
echo -e "${MAGENTA}
  <<< Установка Java JDK средство разработки и среда для создания Java-приложений в Archlinux >>> ${NC}"
# Installing Java JDK is a development tool and environment for creating Java applications in Archlinux
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить OpenJDK Java 8/24 (jre8-openjdk)(jre-openjdk) — Полная среда выполнения OpenJDK Java?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Установка OpenJDK в Linux — это простой процесс, который гарантирует наличие всех необходимых инструментов для разработки и запуска приложений Java. Независимо от того, являетесь ли вы новичком в изучении Java или опытным разработчиком, OpenJDK станет надёжной платформой для ваших проектов. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}*OpenJDK Java 8 — Полная среда выполнения OpenJDK Java 8 в неё входят (java-environment-common java-runtime-common jre8-openjdk-headless jdk8-openjdk jre8-openjdk). А также дополнительные утилиты (пакеты): npm - Менеджер пакетов для javascript, semver - Парсер семантической версии, используемый npm и пакеты - openjdk8-doc, openjdk8-src - эти два пакета закомментированы #. Также присутствует пакет из AUR: java8-openjfx - Платформа клиентских приложений Java OpenJFX 8 (реализация JavaFX с открытым исходным кодом) - он тоже закомментирован #. *OpenJDK Java 24 — Это также полная среда выполнения OpenJDK Java 24 в неё входят (jre-openjdk) на данный момент нынешней версии jre (решил добавить в сценарий для поддержки). Этот проект Лицензируется под LicenseRef-Java. ${NC}"
echo " Домашняя страница: https://openjdk.org/ ; ( https://openjdk.java.net/ ; https://archlinux.org/packages/extra/x86_64/jre8-openjdk/ ; https://archlinux.org/packages/extra/x86_64/jre-openjdk/). "
echo -e "${BLUE}:: ${NC}*JRE (Java Runtime Environment) — это среда выполнения Java. Она предоставляет минимальные требования для выполнения приложения Java. JRE включает в себя JVM, библиотеки классов Java и другие модули, которые помогают JVM в выполнении программы. Среда выполнения Java (JRE) предоставляет библиотеки, виртуальную машину Java и другие компоненты для запуска апплетов и приложений, написанных на языке программирования Java. Кроме того, в состав JRE входят две ключевые технологии развертывания: Java Plug-in, которая позволяет запускать апплеты в популярных браузерах, и Java Web Start, которая позволяет развертывать автономные приложения в сети. Она также является основой для технологий платформы Java 2 Enterprise Edition (J2EE) для разработки и развертывания корпоративного программного обеспечения. JRE не содержит инструментов и утилит, таких как компиляторы или отладчики, для разработки апплетов и приложений. "
echo -e "${CYAN}:: ${NC}*JDK (Java Development Kit) — это расширенная версия JRE, которая содержит всё, что есть в JRE, а также такие инструменты, как компиляторы и отладчики, необходимые для разработки апплетов и приложений. JDK — это набор инструментов для разработки программного обеспечения на языке Java. Он включает в себя всё необходимое для написания, компиляции, отладки и выполнения Java-программ. "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить установку: " in_jdk  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_jdk" =~ [^10] ]]
do
    :
done
if [[ $in_jdk == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_jdk == 1 ]]; then
  echo ""
  echo " Установка утилит (пакетов) OpenJDK Java 8 (jre8-openjdk) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
# sudo pacman -S --noconfirm --needed java-environment-common java-runtime-common jre8-openjdk-headless jdk8-openjdk jre8-openjdk
sudo pacman -S --noconfirm --needed java-environment-common  # Общие файлы для комплектов разработки Java ; https://archlinux.org/packages/extra/any/java-environment-common/ ; https://www.archlinux.org/packages/extra/any/java-common/ ; Базовый пакет: java-common ; 2025-01-18 09:49 UTC
sudo pacman -S --noconfirm --needed java-runtime-common  # Общие файлы для сред выполнения Java ; https://www.archlinux.org/packages/extra/any/java-common/ ; https://archlinux.org/packages/extra/any/java-runtime-common/ ; 2025-01-18 09:49 UTC
sudo pacman -S --noconfirm --needed jre8-openjdk-headless  # OpenJDK Java 8 автономная среда выполнения ; https://openjdk.java.net/ ; https://archlinux.org/packages/extra/x86_64/jre8-openjdk-headless/ ; Обеспечивает: java-runtime-headless=8, java-runtime-headless-openjdk=8 ; Заменяет: jre8-openjdk-headless-wm ; 2025-07-16 15:45 UTC
sudo pacman -S --noconfirm --needed jdk8-openjdk  # Комплект разработчика OpenJDK Java 8 ; https://openjdk.java.net/ ; https://archlinux.org/packages/extra/x86_64/jdk8-openjdk/ ; Обеспечивает:  java-environment=8, java-environment-openjdk=8 ; Заменяет: jdk8-openjdk-wm ; 2025-07-16 15:45 UTC
############ jre8-openjdk ##############
sudo pacman -S --noconfirm --needed jre8-openjdk  # Полная среда выполнения OpenJDK Java 8 ; https://openjdk.java.net/ ; https://archlinux.org/packages/extra/x86_64/jre8-openjdk/ ; Обеспечивает: java-runtime=8, java-runtime-openjdk=8 ; Заменяет: jre8-openjdk-wm ; 2025-07-16 15:45 UTC
  echo ""
  echo -e "${BLUE}:: ${NC}Установка Полной среды выполнения OpenJDK Java 24 (jre-openjdk) "
######## Полная среда выполнения OpenJDK Java 24 ( jre-openjdk ) ##############
# https://openjdk.java.net/
# https://archlinux.org/packages/extra/x86_64/jre-openjdk/
sudo pacman -S --noconfirm --needed jre-openjdk  # Полная среда выполнения OpenJDK Java 24 ; https://archlinux.org/packages/extra/x86_64/jre-openjdk/ ; https://openjdk.java.net/ ; Обеспечивает: java-runtime=24, java-runtime-headless=24, java-runtime-headless-openjdk=24, java-runtime-openjdk=24, jre24-openjdk=24.0.2.u12-1, jre24-openjdk-headless=24.0.2.u12-1 ; Конфликты: с jdk-openjdk , jre-openjdk-headless ; Обратные конфликты: с jdk-openjdk , jre-openjdk-headless ; 2025-07-15 21:18 UTC
######### ИЛИ ###########
#  echo ""
#  echo -e "${BLUE}:: ${NC}Установка Комплекта разработки OpenJDK Java 24 (jdk-openjdk) "
######## Комплект разработки OpenJDK Java 24 ( jdk-openjdk ) ##############
# https://openjdk.java.net/
# https://archlinux.org/packages/extra/x86_64/jdk-openjdk/
# sudo pacman -S --noconfirm --needed jdk-openjdk  # Комплект разработки OpenJDK Java 24 ; https://archlinux.org/packages/extra/x86_64/jdk-openjdk/ ; https://openjdk.java.net/ ; Обеспечивает: java-environment=24, java-environment-openjdk=24, java-runtime=24, java-runtime-headless=24, java-runtime-headless-openjdk=24, Подробнее…(https://archlinux.org/packages/extra/x86_64/jdk-openjdk/#) ; Конфликты: с jre-openjdk , jre-openjdk-headless ; Обратные конфликты: с jre-openjdk , jre-openjdk-headless ; 2025-07-15 21:18 UTC
############################
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости необязательные ##############
########## gvfs необязательно ###############
sudo pacman -S --noconfirm --needed gvfs  # (необязательно) — открывает ссылки, например гиперссылки ; Реализация виртуальной файловой системы для GIO ; https://archlinux.org/packages/extra/x86_64/gvfs/ ; Разделенные пакеты:  gvfs-afc , gvfs-dnssd , gvfs-goa , gvfs-google , gvfs-gphoto2 ; Заменяет: gvfs-afp, gvfs-obexftp ; 2025-06-14 16:09 UTC
# sudo pacman -S --noconfirm --needed openjdk8-doc  # Документация OpenJDK Java 8 ; https://archlinux.org/packages/extra/x86_64/openjdk8-doc/ ; https://openjdk.java.net/ ; 2025-07-16 15:45 UTC
# sudo pacman -S --noconfirm --needed openjdk8-src  # Исходные коды OpenJDK Java 8 ; https://archlinux.org/packages/extra/x86_64/openjdk8-src/ ; https://openjdk.java.net/ ; 2025-07-16 15:45 UTC
############ Менеджер пакетов для javascript ############
# sudo pacman -S --noconfirm --needed npm semver  # Менеджер пакетов для javascript ; Семантический анализатор версий, используемый npm
sudo pacman -S --noconfirm --needed npm  # Менеджер пакетов для javascript ; https://archlinux.org/packages/extra/any/npm/ ; https://www.npmjs.com/ ; 2025-07-31 01:28 UTC
sudo pacman -S --noconfirm --needed semver  # Семантический анализатор версий, используемый npm ; https://archlinux.org/packages/extra/any/semver/ ; https://github.com/npm/node-semver ; 2025-05-17 14:25 UTC
#  echo ""
#  echo -e "${BLUE}:: ${NC}Установка Java8 пакета (java8-openjfx) из AUR "
################## java8-openjfx ############## Недостающие зависимости: -> python2
# yay -S java8-openjfx --noconfirm  # Платформа клиентских приложений Java OpenJFX 8 (реализация JavaFX с открытым исходным кодом) ; https://aur.archlinux.org/java8-openjfx.git (только для чтения, нажмите, чтобы скопировать) ; https://wiki.openjdk.java.net/display/OpenJFX/Main ; https://aur.archlinux.org/packages/java8-openjfx ; Обеспечивает: java-openjfx ; 2025-06-10 08:28 (UTC)
#git clone https://aur.archlinux.org/java8-openjfx.git  # (только для чтения, нажмите, чтобы скопировать)
#cd java8-openjfx
#makepkg -fsri
#makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
#rm -Rf java8-openjfx  # удаляем директорию сборки
# rm -rf java8-openjfx
echo ""
echo " Установка утилит (пакетов) выполнена "
sleep 01
fi
############# Справка ##############
# OpenJDK Java 8/24:
# https://openjdk.org/
# https://openjdk.java.net/
# https://archlinux.org/packages/extra/x86_64/jre8-openjdk/
# https://archlinux.org/packages/extra/x86_64/jre-openjdk/
# https://archlinux.org/packages/extra/x86_64/jre-openjdk/
# https://archlinux.org/packages/extra/x86_64/jdk-openjdk/
####################################

clear
echo -e "${MAGENTA}
  <<< Установка программного обеспечения (пакетов) для создания виртуальных машин в Archlinux >>> ${NC}"
# Installing software (packages) for creating virtual machines in Archlinux
echo ""
echo -e "${GREEN}==> ${NC}Установить Oracle VM VirtualBox (для виртуализации рабочих столов)?"
#echo -e "${BLUE}:: ${NC}Установить Oracle VM VirtualBox (для виртуализации рабочих столов)"
#echo 'Установить Oracle VM VirtualBox (для виртуализации рабочих столов)?'
# Install Oracle VM VirtualBox (for desktop virtualization)?
echo -e "${MAGENTA}:: ${NC}VirtualBox — это средство, позволяющее создавать на ПК виртуальную машину со своей собственной операционной системой. VirtualBox — это мощный продукт виртуализации x86 и AMD64/Intel64 для корпоративного и домашнего использования. VirtualBox — это не только чрезвычайно многофункциональный, высокопроизводительный продукт для корпоративных клиентов, но и единственное профессиональное решение, которое свободно доступно как программное обеспечение с открытым исходным кодом в соответствии с условиями GNU General Public License (GPL) версии 3."
echo " В настоящее время VirtualBox работает на хостах Windows, Linux, macOS и Solaris и поддерживает большое количество гостевых операционных систем, включая, помимо прочего, Windows (NT 4.0, 2000, XP, Server 2003, Vista, 7, 8, Windows 10 и Windows 11), DOS/Windows 3.x, Linux (2.4, 2.6, 3.x, 4.x, 5.x и 6.x), Solaris и OpenSolaris, OS/2, OpenBSD, NetBSD и FreeBSD. "
echo " Всем виртуальным машинам выделяется пространство на физическом диске. Их операционные системы называются гостевыми, а ОС физического ПК — хостовой. (😃) "
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующий вариант: ${NC}"
echo -e "${MAGENTA}:: ${NC}VM VirtualBox - virtualbox - Мощная виртуализация x86 как для корпоративного, так и для домашнего использования ; virtualbox-host-dkms - Источники модулей ядра VirtualBox Host ; linux-headers или linux-lts-headers (для ядра lts как у меня) - Заголовки и скрипты для сборки модулей для ядра Linux-LTC, если у вас ядро (linux) - то раскомментируйте пакет (linux-headers)! "
echo " Также присутствует пакет из AUR - virtualbox-ext-oracle - Пакет расширений Oracle VM VirtualBox - НЕ закомментирован # (https://aur.archlinux.org/virtualbox-ext-oracle.git) "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить VM VirtualBox,      0 - НЕТ - Пропустить установку: " in_virtualbox  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_virtualbox" =~ [^10] ]]
do
    :
done
if [[ $in_virtualbox == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_virtualbox == 1 ]]; then
  echo ""
  echo " Установка Oracle VM VirtualBox "
sudo pacman -Syu  # Обновим вашу систему (базу данных пакетов)
############ Oracle VM VirtualBox ################
sudo pacman -S --noconfirm --needed virtualbox  # Мощная виртуализация x86 как для корпоративного, так и для домашнего использования ; https://www.virtualbox.org/
# sudo pacman -S --noconfirm --needed virtualbox-host-modules-arch  # для ядра linux - Модули ядра хоста Virtualbox для Arch Kernel (ошибка: не удалось подготовить транзакцию (конфликтующие зависимости:  virtualbox-host-modules-arch and virtualbox-host-dkms)
# sudo pacman -Qs virtualbox  # -s — поиск пакета ; Команда для поиска только среди установленных пакетов: pacman -Qs [имя_пакета] ;
sudo pacman -S --noconfirm --needed virtualbox-host-dkms  # для других ядер - Источники модулей ядра VirtualBox Host
# sudo pacman -S --noconfirm --needed linux-headers  # Заголовки и скрипты для сборки модулей для ядра Linux
#sudo pacman -S --noconfirm --needed linux-lts-headers  # Заголовки и скрипты для сборки модулей для ядра Linux-LTC
### Что касается моего подхода к использованию linux-lts ядра, я следовал руководству Arch Linux и установил linux-lts-headers вместо linux-headers.
sudo pacman -S --noconfirm --needed linux-zen-headers  # Заголовки и скрипты для сборки модулей для ядра Linux ZEN ; https://github.com/zen-kernel/zen-kernel ; https://archlinux.org/packages/extra/x86_64/linux-zen-headers/ ; https://www.kernel.org/doc/html/latest/
### !!! Необязательно !!!!
# sudo pacman -S --noconfirm --needed rdesktop  # Клиент с открытым исходным кодом для служб удаленного рабочего стола Windows
### Настройка гостевых дополнений на виртуалке.
#sudo pacman -S --noconfirm --needed virtualbox-guest-utils  # Утилиты пользовательского пространства VirtualBox Guest
#sudo pacman -S --noconfirm --needed linux-headers  # Заголовки и скрипты для сборки модулей для ядра Linux
#sudo pacman -S --noconfirm --needed virtualbox-guest-dkms  # Исходники модулей ядра VirtualBox Guest
sudo pacman -S --noconfirm --needed virtualbox-guest-iso  # Официальный ISO-образ VirtualBox Guest Additions
########## Пакет расширений VirtualBox ############
sudo pacman -S --noconfirm --needed virtualbox-ext-vnc  # Пакет расширений VirtualBox VNC ; https://archlinux.org/packages/extra/x86_64/virtualbox-ext-vnc/ ; https://virtualbox.org/ ; 2025-07-15 20:45 UTC
sudo pacman -S --noconfirm --needed virtualbox-sdk  # Комплект разработчика программного обеспечения VirtualBox (SDK) ; https://archlinux.org/packages/extra/x86_64/virtualbox-sdk/ ; https://virtualbox.org/
echo " Установка обязательного модуля ядра (vboxdrv) для VirtualBox, который должен быть загружен перед запуском любой виртуальной машины. "
sudo modprobe vboxdrv  # Загрузка обязательного модуля ядра
#sudo modprobe -a vboxdrv
###sudo service vboxdrv setup
### `Модуль vboxdrv` — это модуль ядра, который обеспечивает поддержку программного обеспечения виртуализации VirtualBox. Он необходим для запуска виртуальных машин в системе Linux. `Модуль vboxdrv` включен в установочный пакет VirtualBox. Однако он не устанавливается автоматически при установке VirtualBox. Вам необходимо вручную установить `модуль vboxdrv`, если вы хотите использовать VirtualBox в своей системе Linux.
# sudo lsmod | grep vboxdrv  # проверить, загружен ли `модуль vboxdrv`
# sudo modprobe -l vboxdrv  # проверить зависимости модулей ядра
# sudo modinfo vboxdrv  # проверить версию модуля ядра
# ls /etc/modprobe.d/  # Это выведет список всех файлов в каталоге `/etc/modprobe.d/`
# ls /etc/modules-load.d/  # Это выведет список всех файлов в каталоге `/etc/modules-load.d/`
#sudo /sbin/lsmod | grep vboxdrv  # Проверьте, включен ли модуль ядра VirtualBox
#sudo /sbin/modprobe -a vboxdrv   # Если модуль `vboxdrv` не включен, то вы можете включить его
#sudo cat /etc/modprobe.d/blacklist.conf  # Проверьте, что модуль ядра VirtualBox не занесен в черный список
#sudo sed -i ‘/vboxdrv/d’ /etc/modprobe.d/blacklist.conf  # Если модуль `vboxdrv` занесен в черный список, то вы можете удалить его из черного списка
#sudo /sbin/lsmod | grep -v vboxdrv  # Проверьте, не конфликтует ли модуль ядра VirtualBox с другим модулем ядра
#sudo /sbin/rcvboxdrv -h  # Выгрузка модулей
#sudo /sbin/rcvboxdrv -h  # вы можете запустить это
echo " Установка модулей ядра (vboxguest); (vboxsf); (vboxvideo) Гостевые дополнения для VirtualBox "
sudo modprobe -a vboxguest vboxsf vboxvideo
# sudo modprobe vboxguest  #
# sudo modprobe vboxsf  #
# sudo modprobe vboxvideo  #
### VirtualBox: modprobe не может найти vboxguest, vboxsf, vboxvideo
### Вы можете использовать uname -r, чтобы найти строку версии вашего ядра.
### 6.6.40-1-lts
### После повторного запуска modprobe все должно заработать
### depmod 6.6.40-1-lts-ARCH
echo " Установка модулей ядра (vboxnetadp) (vboxnetflt) для расширенных конфигурациях VirtualBox "
sudo modprobe -a vboxnetadp vboxnetflt
# sudo modprobe vboxnetadp  # нужен для создания интерфейса хоста в глобальных настройках VirtualBox
# sudo modprobe vboxnetflt  # нужен для запуска виртуальной машины с использованием этого сетевого интерфейса
# sudo pacman -Ql virtualbox-guest-modules   # чтобы узнать, где находятся модули
# sudo pacman -S --noconfirm --needed
echo -e "${BLUE}:: ${NC}Установка пакета (virtualbox-ext-oracle) из AUR "
echo " Установка Virtualbox Extension Pack для дополнительных функций, которые недоступны по умолчанию "
################## virtualbox-ext-oracle ##############
# yay -S virtualbox-ext-oracle --noconfirm  # Пакет расширений Oracle VM VirtualBox ; https://aur.archlinux.org/virtualbox-ext-oracle.git (только для чтения, нажмите, чтобы скопировать) ; https://www.virtualbox.org/ ; https://aur.archlinux.org/packages/virtualbox-ext-oracle ; https://download.virtualbox.org/virtualbox/7.1.12/Oracle_VirtualBox_Extension_Pack-7.1.12.vbox-extpack ; 2025-07-15 20:26 (UTC)
## yay -S virtualbox-ext-oracle-dev --noconfirm  # Пакет расширений Oracle VM VirtualBox для версии Virtualbox dev ; https://aur.archlinux.org/virtualbox-ext-oracle-dev.git (только для чтения, нажмите, чтобы скопировать) ; https://www.virtualbox.org/ ; https://aur.archlinux.org/packages/virtualbox-ext-oracle-dev ; https://www.virtualbox.org/download/testcase/Oracle_VM_VirtualBox_Extension_Pack-7.0.97-161435.vbox-extpack ; 2024-02-02 21:49 (UTC)
git clone https://aur.archlinux.org/virtualbox-ext-oracle.git   # (только для чтения, нажмите, чтобы скопировать) https://aur.archlinux.org/packages/gtkhash
cd virtualbox-ext-oracle
#makepkg -fsri
makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
pwd    # покажет в какой директории мы находимся
cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
rm -Rf virtualbox-ext-oracle  # удаляем директорию сборки
# rm -rf virtualbox-ext-oracle
echo " Установим Графический интерфейс пользователя основан на QT "
sudo pacman -S --noconfirm --needed qt5-x11extras  # Предоставляет API-интерфейсы для X11, специфичные для платформы ; https://www.qt.io/ ; https://archlinux.org/packages/extra/x86_64/qt5-x11extras/ (только для пользователей Arch Linux) ; 2025-05-23 19:02 UTC
echo -e "${BLUE}:: ${NC}Добавим учетную запись пользователя в группу пользователей vbox "
echo " Чтобы предоставить себе разрешения для доступа VirtualBox к общим папкам и USB устройствам "
### sudo gpasswd -a имя_пользователя vboxusers  (sudo gpasswd -a [имя пользователя] vboxusers) - Не забудьте указать свое имя пользователя вместо username поля.
sudo gpasswd -a $USER vboxusers
#sudo gpasswd -a $username vboxusers
#sudo gpasswd -a alex vboxusers
echo -e "${BLUE}:: ${NC}Добавим записи о модули ядра (vboxdrv) в файлик virtualbox.conf (/etc/modules-load.d/virtualbox.conf) "
echo " Чтобы загрузить модуль VirtualBox во время загрузки "
### Чтобы загрузить модуль VirtualBox во время загрузки, обратитесь к разделу Kernel_modules#Loading и создайте файл *.conf со строкой:
# sudo sed -i 'vboxdrv' /etc/modules-load.d/virtualbox.conf
echo -e "vboxdrv\nvboxguest\nvboxsf\nvboxvideo\nvboxnetadp\nvboxnetflt" | sudo tee /etc/modules-load.d/virtualbox.conf
# в расположении (in location) /etc/modules-load.d/virtualbox.conf
#sudo su
#touch /etc/modules-load.d/virtualbox.conf
#echo "vboxdrv" > /etc/modules-load.d/virtualbox.conf
#echo "vboxguest" >> /etc/modules-load.d/virtualbox.conf
#echo "vboxsf" >> /etc/modules-load.d/virtualbox.conf
#echo "vboxnetadp" >> /etc/modules-load.d/virtualbox.conf
#echo "vboxnetflt" >> /etc/modules-load.d/virtualbox.conf
echo ""
echo " Просмотри внесённые изменения в virtualbox.conf "
cat /etc/modules-load.d/virtualbox.conf
sleep 1
echo " Создадим общую и дополнительные директории (папки) , для работы на виртуалке "
### mkdir /home/<user>/vboxshare
mkdir ~/vboxshare  # Общая директория, на машине
# mkdir ~/VboxShare
mkdir ~/VirtualBoxVMs  # Директория для работы
mkdir ~/VboxClient   # Директория для сетевых машин
########## Общая директория, на виртуалке ############
### sudo mount -t vboxsf -o uid=1000,gid=1000 sharename /home/<user>/vboxshare  # При соблюдении предварительных условий мы можем подключить эти общие папки вручную
# sudo mount -t vboxsf -o rw,uid=1000,gid=1000 vboxshare vboxshare
### Войдите в виртуальную машину с учетной записью root
### Проверьте, существует ли группа vboxsf
# group vboxsf /etc/group
### Проверьте, нет ли пользователя в группе vboxsf
### id -Имя пользователя
### Автоматическое монтирование с помощью Virtual Box Manager
### В случае, если мы включили автоматическое монтирование при создании общей папки из Virtual Box Manager, эти общие папки будут автоматически смонтированы в гостевой папке с точкой монтирования /media/sf_<имя_папки>. Чтобы получить доступ к этим папкам, пользователи в гостевой системе должны быть членами группы vboxsf.
### Добавьте пользователя Имя пользователя в группу vboxsf
### sudo usermod -Имя пользователя в vboxsf
#sudo usermod -aG vboxsf $USER
### Гостю потребуется перезагрузить компьютер, чтобы добавить новую группу.
### Проверьте еще раз группы пользователей
### id -Имя пользователя
### Перезагрузитесь и войдите в систему под именем пользователя!
echo ""
echo " Установка утилит (пакетов) выполнена "
sleep 01
fi
############## Справка #############
### Следующие модули требуются только в расширенных конфигурациях:
# vboxnetadp и vboxnetflt оба нужны, когда вы собираетесь использовать функцию мостовой или только хостовой сети . Точнее, vboxnetadp нужен для создания интерфейса хоста в глобальных настройках VirtualBox и vboxnetflt нужен для запуска виртуальной машины с использованием этого сетевого интерфейса.
# Примечание: Если модули ядра VirtualBox были загружены в ядро ​​во время обновления модулей, вам необходимо перезагрузить их вручную, чтобы использовать новую обновленную версию. Для этого запустите vboxreload как root.
# Arch Wiki Virtualbox
# https://wiki.archlinux.org/index.php/VirtualBox_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
# Подробные инструкции по использованию VirtualBox см. в официальной документации VirtualBox (https://www.virtualbox.org/manual/UserManual.html)
####################################

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Gnome Boxes (gnome-boxes) - Инструмент для работы с виртуальными машинами?"
# Install Gnome Boxes (gnome-boxes), a tool for working with virtual machines?
echo -e "${MAGENTA}=> ${BOLD}GNOME Boxes (gnome-boxes) — это графическая программа среды рабочего стола GNOME, инструмент виртуализации для создания и управления виртуальными машинами, а также доступа к удаленным системам. Использует QEMU и KVM (инструменты виртуализации), с которыми работает libvirt — программа для управления, функционирующая как демон, то есть работа визуально libvirt не видна, как и qemu, и kvm. Виртуализация стала проще - Выберите операционную систему и позвольте Boxes загрузить и установить ее для вас на виртуальной машине. Boxes работает с локальными ISO-файлами или предлагает их загрузить и установить из сети. На выбор обширный список: начиная с более известных (OpenSUSE, Ubuntu, Manjaro и т.д.) и заканчивая вариантами для подготовленных пользователей (семейство BSD, Alt, Nix и др). Доступны различные версии и варианты для лёгкой загрузки прямо в окне программы без необходимости скачивать образы отдельно, есть GNOME OS Nightly для тестирования новой версии. Кроме создания виртуалок, подключение к удалённому рабочему столу, адреса могут начинаться со spice://, rdp://, ssh:// или vnc://. Программа крайне простая, минимум настроек, не позволяет многого реализовать. Но при этом нет тонких и запутывающих настроек. Как и другие программы Gnome, поддерживает управление горячими клавишами. Для уже созданных виртуальных машин в свойствах: изменить выделенные ресурсы, монитор использования железа, подключить внешние устройства и создание снимков текущей системы на случай отката. На странице программы много дополнительной информации. ${NC}"
echo -e "${YELLOW}:: ${NC}Особенности: Создание виртуальных машин из образов операционной системы (например, ISO-образа). Можно выбрать готовый образ или загрузить ОС из списка — в этом случае она будет автоматически загружена из сети. Функции: Загружайте свободно распространяемые операционные системы ; Автоматически устанавливайте CentOS Stream, Debian, Fedora, Microsoft Windows, openSUSE, Red Hat Enterprise Linux и Ubuntu ; Создавайте виртуальные машины из образов операционной системы несколькими щелчками мыши ; Ограничивайте ресурсы (память и хранилище), которые ваши виртуальные машины потребляют из вашей системы ; Делайте моментальные снимки виртуальных машин для восстановления предыдущих состояний ; Перенаправляйте USB-устройства с физической машины на виртуальные машины ; 3D-ускорение для некоторых поддерживаемых операционных систем ; Автоматическое изменение размера дисплеев виртуальных машин в соответствии с размером окна ; Обменивайтесь буфером обмена между вашей системой и виртуальными машинами ; Предоставляйте виртуальным машинам общий доступ к файлам, сбросив их из файлового менеджера в окно Boxes ; Настраивайте общие папки между вашей системой и виртуальными машинами. Разработчик: проект GNOME ; Сайт: apps.gnome.org/Boxes/ ; Языки программирования: Vala ; Исходный код: Open Source (открыт) ; Лицензия: GNU LGPL-2.1+. Приложение доступно в официальных репозиториях дистрибутивов Linux на базе GNOME. Также можно установить Boxes через Flatpak. Однако в версии Flatpak отсутствует функция, позволяющая виртуальным машинам получать доступ к USB-накопителям. "
echo -e "${CYAN}:: ${NC}Boxes фокусируется на том, чтобы всё работало «из коробки» с минимальным участием пользователя. Есть и негативные отзывы: некоторые пользователи считают, что Boxes слишком жёсткий, и сбрасывает ручные конфигурации, если они не соответствуют ожиданиям. Домашняя страница: (https://wiki.gnome.org/Apps/Boxes). "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить действие: " i_boxes  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_boxes" =~ [^10] ]]
do
    :
done
if [[ $i_boxes == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_boxes == 1 ]]; then
echo ""
echo " Установка Gnome Boxes (gnome-boxes) "
#sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
##### gnome-boxes ######
sudo pacman -S --noconfirm --needed gnome-boxes  # Простое приложение GNOME для доступа к виртуальным системам ; https://archlinux.org/packages/extra/x86_64/gnome-boxes/  ; https://apps.gnome.org/Boxes/ ; 2025-09-22 17:11 UTC
echo ""
echo " Установка Gnome Boxes выполнена "
echo " Желательно перезагрузить систему для применения изменений "
sleep 01
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Virtual Machine Manager (virt-manager) - Управление виртуальными машинами?"
# Install Virtual Machine Manager (virt-manager) - Virtual Machine Management?
echo -e "${MAGENTA}=> ${BOLD}Virtual Machine Manager (virt-manager) — графическая оболочка для управления виртуальными машинами (фронтенд для libvirt). Обычно используется в качестве графического интерфейса для QEMU+KVM. Приложение virt-manager — это пользовательский интерфейс рабочего стола для управления виртуальными машинами через libvirt. Оно в первую очередь предназначено для виртуальных машин KVM, но также может управлять Xen и LXC (контейнерами Linux). Это более навороченный и сложный вариант, имеющий много настроек, менюшек и возможностей, для изощрённых пользователей, пройти ряд шагов при создании ВМ, изменение настроек для уже созданных. Оно предоставляет сводную информацию о запущенных доменах, их производительности и статистике использования ресурсов в режиме реального времени. Мастера позволяют создавать новые домены, а также настраивать и корректировать распределение ресурсов домена и виртуальное оборудование. Встроенный клиент VNC и SPICE предоставляет полноценную графическую консоль для гостевого домена. ${NC}"
echo -e "${YELLOW}:: ${NC}Проект libvirt: это набор инструментов для управления платформами виртуализации, доступен из C, Python, Perl, Go и других языков, лицензировано по лицензиям с открытым исходным кодом, поддерживает KVM , Hypervisor.framework , QEMU , Xen , Virtuozzo , VMware ESX , LXC , BHyve и другие. Предназначен для Linux, FreeBSD, Windows и macOS, используется многими приложениями. "
echo " О вспомогательных инструментах virt-manager: virt-install — это инструмент командной строки, который обеспечивает простой способ установки операционных систем на виртуальные машины. virt-viewer — это лёгкий пользовательский интерфейс для взаимодействия с графическим дисплеем виртуализированной гостевой ОС. Он поддерживает VNC или SPICE и использует libvirt для поиска информации о графическом подключении. virt-clone — это утилита командной строки для клонирования существующих неактивных гостевых систем. Она копирует образы дисков и определяет конфигурацию с новым именем, UUID и MAC-адресом, указывающими на скопированные диски. virt-xml — это инструмент командной строки для простого редактирования XML-файла домена libvirt с использованием параметров командной строки virt-install. virt-bootstrap — это инструмент командной строки, обеспечивающий простой способ настройки корневой файловой системы для контейнеров на основе libvirt. "
echo -e "${CYAN}:: ${NC}Некоторые возможности: Перенести виртуальные диски на другой диск; Значок в области уведомлений, либо его отсутствие; График потребления; Импорт виртуальных дисков из других программ; Создание снимков ВМ; Для подключения сторонних устройств в гостевую ОС в окне с запущенной ОС выбрать меню «Виртуальная машина», пункт «Перенаправление USB». Разработчик: Red Hat; Исходный код: Open Source (открыт); Языки программирования: Python; Лицензия: GNU GPL. Домашняя страница: (https://virt-manager.org/ ; https://libvirt.org/ ; https://libosinfo.org/ ; https://www.qemu.org/). "
echo -e "${CYAN}:: ${NC}Основные шаги в процессе: 1. Добавить соединение, где нужно выбрать гипервизор; 2. Выбрать источник: 2.1. Локальный ISO; 2.2. Сетевая установка; 2.3. Импорт образа диска; 2.4. Ручная установка. 3. Указать источник и семейство; 4. Выделить ресурсы; 5. На последнем этапе название и выбор сети. Тут можно отметить «Проверить конфигурацию перед установкой», что выведет окно со всем оборудованием и настройками. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
echo " Проверить архитектуру вашей системы "
uname -m
echo ""
echo " Прежде чем приступить к установке, убедитесь, что ваша система поддерживает аппаратную виртуализацию "
echo " Вы должны увидеть это VT-x для процессоров Intel или AMD-VAMD "
echo " Включите виртуализацию в BIOS/UEFI "
echo " Перезагрузите систему и войдите в настройки BIOS/UEFI. Найдите такие параметры, как «Технология виртуализации Intel» или «Режим SVM», и убедитесь, что они включены! "
echo " Проверим поддержку виртуализации: "
#lscpu | grep Virtualization
echo ""
echo " В качестве альтернативы проверьте наличие флагов vmx или svm: "
echo " Если результат больше 0, ваш процессор поддерживает виртуализацию "
egrep -c '(vmx|svm)' /proc/cpuinfo
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить действие: " i_virt  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_virt" =~ [^10] ]]
do
    :
done
if [[ $i_virt == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_virt == 1 ]]; then
  echo ""
  echo " Установка Virtual Machine Manager (virt-manager) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
##### virt-manager ######
sudo pacman -S --noconfirm --needed virt-install # Инструмент командной строки для создания новых гостевых систем контейнеров KVM, Xen или Linux с использованием гипервизора libvirt ; https://archlinux.org/packages/extra/any/virt-install/ ; https://virt-manager.org/ ; https://virt-manager.org/ ; 2024-12-22 13:20 UTC
sudo pacman -S --noconfirm --needed virt-viewer  # Легкий интерфейс для взаимодействия с графическим дисплеем виртуализированной гостевой ОС ; https://archlinux.org/packages/extra/x86_64/virt-viewer/ ; https://gitlab.com/virt-viewer/virt-viewer ; Заменяет: virtviewer ; 2025-04-30 17:36 UTC . Virt Viewer предоставляет графический просмотрщик для отображения гостевой ОС. В настоящее время он поддерживает гостевые ОС, использующие протоколы VNC и SPICE. Поддержка дополнительных протоколов может быть реализована в будущем по мере необходимости. Virt Viewer может подключаться напрямую как к локальной, так и к удалённой гостевой ОС, при необходимости используя шифрование SSL/TLS. Virt Viewer — это приложение GTK3. Virt Viewer 3.0 был последним релизом, поддерживающим GTK2. Virt Viewer использует виджет GTK-VNC (>= 0.4.0) для отображения протокола VNC.
###########
sudo pacman -S --noconfirm --needed libvirt-dbus  # Оболочка вокруг API libvirt, предоставляющая высокоуровневый объектно-ориентированный API, лучше подходящий для приложений на базе dbus ; https://archlinux.org/packages/extra/x86_64/libvirt-dbus/ ; https://libvirt.org/dbus.html ; 2025-01-01 12:27 UTC
sudo pacman -S --noconfirm --needed cockpit-machines  # Cockpit UI для виртуальных машин ; https://archlinux.org/packages/extra/any/cockpit-machines/ ; https://github.com/cockpit-project/cockpit-machines ; 2025-07-09 19:23 UTC
sudo pacman -S --noconfirm --needed virt-manager  # Настольный пользовательский интерфейс для управления виртуальными машинами ; https://archlinux.org/packages/extra/any/virt-manager/ ; https://virt-manager.org/ ; 2024-12-22 13:20 UTC
### sudo systemctl enable libvirtd  # Вы можете включить его автоматический запуск при загрузке
######## Дополнения для virt-manager ###########
sudo pacman -S libvirt  # API для управления движками виртуализации (openvz, kvm, qemu, virtualbox, xen и т. д.) ; https://archlinux.org/packages/extra/x86_64/libvirt/ ; https://libvirt.org/ ; Обеспечивает: libvirt=11.5.0, libvirt-admin.so=0-64, libvirt-lxc.so=0-64, libvirt-qemu.so=0-64, libvirt.so=0-64 ; 2025-07-03 21:50 UTC
sudo pacman -S --noconfirm --needed dnsmasq  # Легкий, простой в настройке DNS-пересылатель и DHCP-сервер ; https://archlinux.org/packages/extra/x86_64/dnsmasq/ ; http://www.thekelleys.org.uk/dnsmasq/doc.html ; 2025-03-22 18:51 UTC
sudo pacman -S --noconfirm --needed vde2   # Виртуальный распределенный Ethernet для эмуляторов типа qemu ; https://archlinux.org/packages/extra/x86_64/vde2/ ; https://github.com/virtualsquare/vde-2 ; Обеспечивает: libvdehist.so=0-64, libvdemgmt.so=0-64, libvdeplug.so=3-64, libvdesnmp.so=0-64 ; 2025-01-08 23:55 UTC
sudo pacman -S --noconfirm --needed bridge-utils  # Утилиты для настройки Ethernet-моста Linux ; https://archlinux.org/packages/extra/x86_64/bridge-utils/ ; https://wiki.linuxfoundation.org/networking/bridge ; 2024-03-05 15:32 UTC
#?sudo pacman -S --noconfirm --needed openbsd-netcat  # Швейцарский армейский нож TCP/IP. Вариант OpenBSD ; https://archlinux.org/packages/extra/x86_64/openbsd-netcat/ ; https://salsa.debian.org/debian/netcat-openbsd ; 2025-07-17 12:41 UTC . Вариант OpenBSD (Важно конфликтует с gnu-netcat - GNU переписывает netcat, приложение для создания сетевых трубопроводов). Простая утилита Unix, которая считывает и записывает данные через сетевые соединения с использованием протоколов TCP или UDP. Этот пакет содержит переписанную версию netcat для OpenBSD, включая поддержку IPv6, прокси-серверов и сокетов Unix.
# sudo pacman -S --noconfirm --needed gnu-netcat  # GNU переписывает netcat, приложение для создания сетевых трубопроводов (приложения сетевого конвейера) ; сетевая утилита, которая считывает и записывает данные через сетевые соединения, используя протокол TCP/IP ; http://netcat.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/gnu-netcat/
sudo pacman -S --noconfirm --needed edk2-ovmf  # Прошивка для виртуальных машин (x86_64, i686) ; https://archlinux.org/packages/extra/any/edk2-ovmf/ ; https://github.com/tianocore/tianocore.github.io/wiki/OVMF ; Обеспечивает: ovmf ; Заменяет: ovmf ; Конфликты: с ovmf ; 28.11.2024 11:28 UTC . OVMF — это проект на основе EDK II , обеспечивающий поддержку UEFI для виртуальных машин. OVMF содержит пример прошивки UEFI для QEMU и KVM .
sudo pacman -S --noconfirm --needed swtpm  # Эмулятор TPM на базе Libtpms с сокетом, символьным устройством и интерфейсом Linux CUSE ; https://archlinux.org/packages/extra/x86_64/swtpm/ ; https://github.com/stefanberger/swtpm ; 2025-05-11 06:12 UTC
sudo pacman -S --noconfirm --needed guestfs-tools  # Инструменты для доступа и изменения образов гостевых дисков ; https://archlinux.org/packages/extra/x86_64/guestfs-tools/ ; https://libguestfs.org/ ; 2025-06-23 10:16 UTC
sudo pacman -S --noconfirm --needed libosinfo  # API библиотеки на основе GObject для управления информацией об операционных системах, гипервизорах и (виртуальных) аппаратных устройствах, которые они могут поддерживать ; https://archlinux.org/packages/extra/x86_64/libosinfo/ ; https://libosinfo.org/ ; 2025-04-30 17:34 UTC
sudo pacman -S --noconfirm --needed tuned  # Демон, осуществляющий мониторинг и адаптивную настройку устройств в системе ; https://archlinux.org/packages/extra/any/tuned/ ; https://github.com/redhat-performance/tuned ; 2025-02-04 08:08 UTC
sudo pacman -S --noconfirm --needed libguestfs  # Доступ к образам дисков виртуальной машины и их изменение ; https://archlinux.org/packages/extra/x86_64/libguestfs/ ; https://libguestfs.org/ ; Обеспечивает: libguestfs-gobject-1.0.so=0-64, libguestfs.so=0-64 ; 2025-07-16 18:23 UTC
############################################
########## virt-bootstrap-git #############
########## Зависимости #################
########## libselinux ###########
yay -S libselinux --noconfirm  # Библиотека SELinux и простые утилиты ; https://aur.archlinux.org/packages/libselinux ; https://aur.archlinux.org/libselinux.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/SELinuxProject/selinux ; Конфликты: с selinux-usr-libselinux ; Обеспечивает: libselinux.so, selinux-usr-libselinux ; 2025-03-02 20:33 (UTC)
########## libselinux ###########
#git clone https://aur.archlinux.org/libselinux.git  # (только для чтения, нажмите, чтобы скопировать)
#cd libselinux
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf libselinux
#rm -Rf libselinux
########## libvirt-sandbox #############
yay -S libvirt-sandbox --noconfirm  # Набор инструментов для песочницы приложений ; https://aur.archlinux.org/packages/libvirt-sandbox ; https://aur.archlinux.org/libvirt-sandbox.git (только для чтения, нажмите, чтобы скопировать) ; http://sandbox.libvirt.org/ ; 2023-08-01 11:24 (UTC
########## libvirt-sandbox #############
#git clone https://aur.archlinux.org/libvirt-sandbox.git  # (только для чтения, нажмите, чтобы скопировать)
#cd libvirt-sandbox
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf libvirt-sandbox
#rm -Rf libvirt-sandbox
########## virt-bootstrap-git ##########
yay -S virt-bootstrap-git --noconfirm  # Инструмент для создания корневой файловой системы контейнеров на базе libvirt ; https://aur.archlinux.org/packages/virt-bootstrap-git; https://aur.archlinux.org/virt-bootstrap-git.git (только для чтения, нажмите, чтобы скопировать) ; Конфликты: с virt-bootstrap ; Обеспечивает: virt-bootstrap ; 2020-07-07 14:03 (UTC)
########## virt-bootstrap-git ##########
#git clone https://aur.archlinux.org/virt-bootstrap-git.git  # (только для чтения, нажмите, чтобы скопировать)
#cd virt-bootstrap-git
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf virt-bootstrap-git
#rm -Rf virt-bootstrap-git
#############################
echo ""
echo " Узнать Версию программы virt-manager "
# virt-manager --version  # Узнать Версию программы, можно и с помощью (терминала)
sudo pacman -Q virt-manager  # Узнать Версию программы
sleep 03
echo ""
echo " Добавляет пользователя в группу libvirt "
echo " Пример: sudo gpasswd -a ИМЯ_ПОЛЬЗОВАТЕЛЯ libvirt "
sudo gpasswd -a $USER libvirt  # Команда gpasswd -a $USER libvirt в Linux добавляет пользователя в группу libvirt. Это необходимо, так как только root и пользователи этой группы могут использовать виртуальные машины KVM (Kernel Virtual Module).
sudo gpasswd -a $USER kvm   # Команда sudo gpasswd -a $USER kvm добавляет пользователя в группу kvm. Это может быть необходимо при настройке виртуализации KVM, например, на Arch Linux, где нужно обеспечить доступ пользователя к управлению виртуальными машинами. KVM — технология аппаратной виртуализации, поддерживаемая процессорами с технологиями Intel VT-x и AMD-V. KVM превращает ядро Linux в гипервизор, предоставляя виртуальным машинам доступ к реальным ресурсам сервера, но изолируя их друг от друга.
echo " Добавить текущего пользователя в группу libvirt,kvm "
echo " Для запуска виртуальных машин без прав root "
sudo usermod -aG libvirt,kvm $USER  # Добавить текущего пользователя в группу libvirt,kvm, которая имеет разрешение на захват на интерфейсах без необходимости использования sudo
# sudo usermod -a -G libvirt,kvm $USER
#echo ""
#echo " Включить его автоматический запуск при загрузке "
#sudo systemctl enable libvirtd.service
#sudo systemctl start libvirtd.service
#echo ""
#echo " Проверка, что демон виртуализации – libvirt-daemon – работает: "
#sudo systemctl status libvirtd.service
#echo ""
#echo " Проверка, загружены ли модули KVM: "
#lsmod | grep -i kvm  # Проверка, загружены ли модули KVM
echo ""
echo " Установка Virtual Machine Manager выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установить QEMU (qemu) и KVM (VM на базе ядра) - Виртуальная машина (эмулятор)?"
# Install QEMU (qemu) and KVM (Core-based VM) - Virtual Machine (Emulator)?
echo -e "${MAGENTA}=> ${BOLD}QEMU (быстрый эмулятор) и KVM (виртуальная машина на базе ядра) вместе предлагают мощное и эффективное решение для виртуализации для пользователей Linux. В Arch Linux — минималистичном, передовом дистрибутиве, разработанном для продвинутых пользователей — настройка QEMU/KVM открывает целый мир возможностей: от тестирования различных операционных сред до создания сложных виртуальных лабораторий. ${NC}"
echo -e "${YELLOW}:: ${NC}QEMU — это универсальный эмулятор машин и виртуализатор с открытым исходным кодом. При использовании в качестве виртуализатора он достигает производительности, близкой к нативной, выполняя гостевой код непосредственно на центральном процессоре с помощью модуля ядра KVM . KVM превращает вашу машину Linux в гипервизор типа 1, используя расширения аппаратной виртуализации, такие как Intel VT-x или AMD-V. Эта технология встроена в ядро Linux и требует минимальной настройки. Вместе QEMU и KVM позволяют пользователям создавать и запускать виртуальные машины с хорошей производительностью, поддержкой широкого спектра гостевых операционных систем и интеграцией с графическими инструментами, такими как virt-manager . Два режима работы: Полная эмуляция системы (System-mode) — программа создаёт автономную виртуальную машину со своей основной и периферийной системами. Эмуляция пользовательского режима (User-mode) — QEMU запускает на одном процессоре процессы, скомпилированные для другого процессора.  "
echo " О вспомогательных инструментах virt-manager: virt-install — это инструмент командной строки, который обеспечивает простой способ установки операционных систем на виртуальные машины. virt-viewer — это лёгкий пользовательский интерфейс для взаимодействия с графическим дисплеем виртуализированной гостевой ОС. Он поддерживает VNC или SPICE и использует libvirt для поиска информации о графическом подключении. virt-clone — это утилита командной строки для клонирования существующих неактивных гостевых систем. Она копирует образы дисков и определяет конфигурацию с новым именем, UUID и MAC-адресом, указывающими на скопированные диски. virt-xml — это инструмент командной строки для простого редактирования XML-файла домена libvirt с использованием параметров командной строки virt-install. virt-bootstrap — это инструмент командной строки, обеспечивающий простой способ настройки корневой файловой системы для контейнеров на основе libvirt. "
echo -e "${CYAN}:: ${NC}Некоторые возможности: Эмуляция хост-системы (CPU, память, устройства) для запуска-гостевых операционных систем. Поддержка виртуализации KVM, Xen, Hax, Hypervisor.Framework для исполнения гостевых-систем непосредственно на CPU. Эмуляция в режиме «User mode» для запуска приложений, скомпилированнных под один CPU, на другом CPU. В данном режиме всегда выполняется эмуляция CPU. Домашняя страница: (https://virt-manager.org/ ; https://libvirt.org/ ; https://libosinfo.org/ ; https://www.qemu.org/ ; https://wiki.qemu.org/Main_Page ; https://www.qemu.org/documentation/ ; https://gitlab.com/qemu-project/qemu/-/tree/master/docs). "
echo -e "${CYAN}:: ${NC}Кроссплатформенность: QEMU работает на разных операционных системах: Linux, Windows, macOS, а также на Android. Поддержка аппаратной виртуализации. Например, Intel VT и AMD SVM на x86-совместимых процессорах Intel и AMD. Автор программы — французский программист Фабрис Беллар (фр. Fabrice Bellard), создатель популярной библиотеки libavcodec, которую используют такие известные программы, как FFmpeg, ffdshow, MPlayer, VideoLAN и др. Разработчик(и): Паоло Бонзини, Ричард Хендерсон и Питер Мэйделл; Исходный код: Open Source (открыт); Языки программирования: C; Лицензия: GNU GPL 2. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
echo " Проверить архитектуру вашей системы "
uname -m
sleep 03
echo ""
echo " Прежде чем приступить к установке, убедитесь, что ваша система поддерживает аппаратную виртуализацию "
echo " Вы должны увидеть это VT-x для процессоров Intel или AMD-VAMD "
echo " Включите виртуализацию в BIOS/UEFI "
echo " Перезагрузите систему и войдите в настройки BIOS/UEFI. Найдите такие параметры, как «Технология виртуализации Intel» или «Режим SVM», и убедитесь, что они включены! "
echo " Проверим поддержку виртуализации: "
#lscpu | grep Virtualization
# LC_ALL=C lscpu | grep Virtualization
sleep 03
echo ""
echo " В качестве альтернативы проверьте наличие флагов vmx или svm: "
echo " Если результат больше 0, ваш процессор поддерживает виртуализацию "
egrep -c '(vmx|svm)' /proc/cpuinfo
sleep 03
echo " Проверим есть ли модуль ядра для запуска KVM (что ваше ядро включает модули KVM): "
echo " Проверим есть ли на выхлопе параметры CONFIG_KVM_AMD (или CONFIG_KVM_INTEL, у меня оба параметра =m ), должны быть равны y или m, если это так, замечательно, переходим к установке пакетов. (y= Да (всегда установлено); m= Загружаемый модуль )) "
zgrep CONFIG_KVM /proc/config.gz
sleep 03
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Да установить,     0 - НЕТ - Пропустить действие: " i_qemu  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_qemu" =~ [^10] ]]
do
    :
done
if [[ $i_qemu == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_qemu == 1 ]]; then
  echo ""
  echo " Установка QEMU (qemu) и KVM (VM на базе ядра) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
##### qemu ######
sudo pacman -S --noconfirm --needed qemu # Универсальный компьютерный эмулятор и виртуализатор с открытым исходным кодом ; https://archlinux.org/packages/extra/x86_64/qemu/ ; https://wiki.archlinux.org/title/QEMU
sudo pacman -S --noconfirm --needed qemu-full # Полная настройка QEMU ; https://archlinux.org/packages/extra/x86_64/qemu-full/ ; https://www.qemu.org/ ; Обеспечивает: qemu=10.0.2 ; 2025-07-08 20:27 UTC
sudo pacman -S --noconfirm --needed qemu-guest-agent  # Гостевой агент QEMU ; https://archlinux.org/packages/extra/x86_64/qemu-guest-agent/ ; https://www.qemu.org/ ; 2025-07-08 20:27 UTC
###yay -S qemu-arch-extra-git --noconfirm  # QEMU для зарубежных архитектур. Git-версия ; https://aur.archlinux.org/packages/qemu-arch-extra-git ; https://aur.archlinux.org/qemu-git.git (только для чтения, нажмите, чтобы скопировать) ; https://wiki.qemu.org/ ; Конфликты: с qemu-arch-extra, qemu-emulators-full ; Обеспечивает: qemu-arch-extra ; 2025-06-22 15:55 (UTC)
### ИЛИ qemu-base для версии без GUI и qemu-desktop для версии только с эмуляцией x86_64 по умолчанию
#sudo pacman -S --noconfirm --needed qemu-base  # Базовая настройка QEMU для безголовых сред ; https://archlinux.org/packages/extra/x86_64/qemu-base/ ; https://www.qemu.org/ ; Обеспечивает: qemu=10.0.2 ; 2025-07-08 20:27 UTC
#sudo pacman -S --noconfirm --needed qemu-desktop  # Настройка QEMU для окружения рабочего стола ; https://archlinux.org/packages/extra/x86_64/qemu-desktop/ ;  Обеспечивает: qemu=10.0.2 ; 2025-07-08 20:27 UTC
######## Дополнения для QEMU ###########
sudo pacman -S --noconfirm --needed qemu-block-gluster  # Драйвер блока QEMU Gluster ; https://archlinux.org/packages/extra/x86_64/qemu-block-gluster/ ; https://www.qemu.org/ ; https://wiki.archlinux.org/title/Glusterfs ; 2025-07-08 20:27 UTC
sudo pacman -S --noconfirm --needed qemu-block-iscsi  # Драйвер блока iSCSI QEMU ; https://archlinux.org/packages/extra/x86_64/qemu-block-iscsi/ ; https://www.qemu.org/ ; 2025-07-08 20:27 UTC
### Альтернативно, qemu-user-static существует в виде пользовательского режима и статического варианта.
# sudo pacman -S --noconfirm --needed qemu-user-static  # Эмуляция статического пользовательского режима QEMU ; https://archlinux.org/packages/extra/x86_64/qemu-user-static/ ; https://www.qemu.org/ ; 2025-07-08 20:27 UTC
  echo ""
  echo " Установка Virtual Machine Manager (virt-manager) "
##### virt-manager ######
sudo pacman -S --noconfirm --needed virt-install # Инструмент командной строки для создания новых гостевых систем контейнеров KVM, Xen или Linux с использованием гипервизора libvirt ; https://archlinux.org/packages/extra/any/virt-install/ ; https://virt-manager.org/ ; https://virt-manager.org/ ; 2024-12-22 13:20 UTC
sudo pacman -S --noconfirm --needed virt-viewer  # Легкий интерфейс для взаимодействия с графическим дисплеем виртуализированной гостевой ОС ; https://archlinux.org/packages/extra/x86_64/virt-viewer/ ; https://gitlab.com/virt-viewer/virt-viewer ; Заменяет: virtviewer ; 2025-04-30 17:36 UTC . Virt Viewer предоставляет графический просмотрщик для отображения гостевой ОС. В настоящее время он поддерживает гостевые ОС, использующие протоколы VNC и SPICE. Поддержка дополнительных протоколов может быть реализована в будущем по мере необходимости. Virt Viewer может подключаться напрямую как к локальной, так и к удалённой гостевой ОС, при необходимости используя шифрование SSL/TLS. Virt Viewer — это приложение GTK3. Virt Viewer 3.0 был последним релизом, поддерживающим GTK2. Virt Viewer использует виджет GTK-VNC (>= 0.4.0) для отображения протокола VNC.
###########
sudo pacman -S libvirt  # API для управления движками виртуализации (openvz, kvm, qemu, virtualbox, xen и т. д.) ; https://archlinux.org/packages/extra/x86_64/libvirt/ ; https://libvirt.org/ ; Обеспечивает: libvirt=11.5.0, libvirt-admin.so=0-64, libvirt-lxc.so=0-64, libvirt-qemu.so=0-64, libvirt.so=0-64 ; 2025-07-03 21:50 UTC
sudo pacman -S --noconfirm --needed libvirt-dbus  # Оболочка вокруг API libvirt, предоставляющая высокоуровневый объектно-ориентированный API, лучше подходящий для приложений на базе dbus ; https://archlinux.org/packages/extra/x86_64/libvirt-dbus/ ; https://libvirt.org/dbus.html ; 2025-01-01 12:27 UTC
sudo pacman -S --noconfirm --needed cockpit-machines  # Cockpit UI для виртуальных машин ; https://archlinux.org/packages/extra/any/cockpit-machines/ ; https://github.com/cockpit-project/cockpit-machines ; 2025-07-09 19:23 UTC
sudo pacman -S --noconfirm --needed virt-manager  # Настольный пользовательский интерфейс для управления виртуальными машинами ; https://archlinux.org/packages/extra/any/virt-manager/ ; https://virt-manager.org/ ; 2024-12-22 13:20 UTC
### sudo systemctl enable libvirtd  # Вы можете включить его автоматический запуск при загрузке
######## Дополнения для virt-manager ###########
sudo pacman -S --noconfirm --needed dnsmasq  # Легкий, простой в настройке DNS-пересылатель и DHCP-сервер ; https://archlinux.org/packages/extra/x86_64/dnsmasq/ ; http://www.thekelleys.org.uk/dnsmasq/doc.html ; 2025-03-22 18:51 UTC
sudo pacman -S --noconfirm --needed vde2   # Виртуальный распределенный Ethernet для эмуляторов типа qemu ; https://archlinux.org/packages/extra/x86_64/vde2/ ; https://github.com/virtualsquare/vde-2 ; Обеспечивает: libvdehist.so=0-64, libvdemgmt.so=0-64, libvdeplug.so=3-64, libvdesnmp.so=0-64 ; 2025-01-08 23:55 UTC
sudo pacman -S --noconfirm --needed bridge-utils  # Утилиты для настройки Ethernet-моста Linux ; https://archlinux.org/packages/extra/x86_64/bridge-utils/ ; https://wiki.linuxfoundation.org/networking/bridge ; 2024-03-05 15:32 UTC
#?sudo pacman -S --noconfirm --needed openbsd-netcat  # Швейцарский армейский нож TCP/IP. Вариант OpenBSD ; https://archlinux.org/packages/extra/x86_64/openbsd-netcat/ ; https://salsa.debian.org/debian/netcat-openbsd ; 2025-07-17 12:41 UTC . Вариант OpenBSD (Важно конфликтует с gnu-netcat - GNU переписывает netcat, приложение для создания сетевых трубопроводов). Простая утилита Unix, которая считывает и записывает данные через сетевые соединения с использованием протоколов TCP или UDP. Этот пакет содержит переписанную версию netcat для OpenBSD, включая поддержку IPv6, прокси-серверов и сокетов Unix.
# sudo pacman -S --noconfirm --needed gnu-netcat  # GNU переписывает netcat, приложение для создания сетевых трубопроводов (приложения сетевого конвейера) ; сетевая утилита, которая считывает и записывает данные через сетевые соединения, используя протокол TCP/IP ; http://netcat.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/gnu-netcat/
sudo pacman -S --noconfirm --needed edk2-ovmf  # Прошивка для виртуальных машин (x86_64, i686) ; https://archlinux.org/packages/extra/any/edk2-ovmf/ ; https://github.com/tianocore/tianocore.github.io/wiki/OVMF ; Обеспечивает: ovmf ; Заменяет: ovmf ; Конфликты: с ovmf ; 28.11.2024 11:28 UTC . OVMF — это проект на основе EDK II , обеспечивающий поддержку UEFI для виртуальных машин. OVMF содержит пример прошивки UEFI для QEMU и KVM .
sudo pacman -S --noconfirm --needed swtpm  # Эмулятор TPM на базе Libtpms с сокетом, символьным устройством и интерфейсом Linux CUSE ; https://archlinux.org/packages/extra/x86_64/swtpm/ ; https://github.com/stefanberger/swtpm ; 2025-05-11 06:12 UTC
sudo pacman -S --noconfirm --needed guestfs-tools  # Инструменты для доступа и изменения образов гостевых дисков ; https://archlinux.org/packages/extra/x86_64/guestfs-tools/ ; https://libguestfs.org/ ; 2025-06-23 10:16 UTC
sudo pacman -S --noconfirm --needed libosinfo  # API библиотеки на основе GObject для управления информацией об операционных системах, гипервизорах и (виртуальных) аппаратных устройствах, которые они могут поддерживать ; https://archlinux.org/packages/extra/x86_64/libosinfo/ ; https://libosinfo.org/ ; 2025-04-30 17:34 UTC
sudo pacman -S --noconfirm --needed tuned  # Демон, осуществляющий мониторинг и адаптивную настройку устройств в системе ; https://archlinux.org/packages/extra/any/tuned/ ; https://github.com/redhat-performance/tuned ; 2025-02-04 08:08 UTC
sudo pacman -S --noconfirm --needed libguestfs  # Доступ к образам дисков виртуальной машины и их изменение ; https://archlinux.org/packages/extra/x86_64/libguestfs/ ; https://libguestfs.org/ ; Обеспечивает: libguestfs-gobject-1.0.so=0-64, libguestfs.so=0-64 ; 2025-07-16 18:23 UTC
sudo pacman -S --noconfirm --needed ebtables  # Ebtables используется для настройки, обслуживания и проверки таблиц правил Ethernet-фреймов в ядре Linux. Он аналогичен iptables, но работает на уровне MAC, а не IP ;
### Ebtables — средство для фильтрации пакетов для программных мостов Linux. ebtables похоже на iptables, но отличается тем, что работает преимущественно не на третьем, а на втором уровне сетевого стека.
#sudo pacman -S --noconfirm --needed iptables  # Инструмент управления пакетами ядра Linux (использующий устаревший интерфейс) ; https://archlinux.org/packages/core/x86_64/iptables/ ; https://www.netfilter.org/projects/iptables/index.html ; Обеспечивает: libip4tc.so=2-64, libip6tc.so=2-64, libipq.so=0-64, libxtables.so=12-64 ; Обратные конфликты: iptables-nft ; 2025-03-31 16:30 UTC
### iptables — это программа командной строки пользовательского пространства, используемая для настройки набора правил фильтрации пакетов в Linux 2.4.x и более поздних версиях. Она предназначена для системных администраторов. Поскольку преобразование сетевых адресов также настраивается из набора правил фильтрации пакетов, для этого также используется iptables . Пакет iptables также включает ip6tables . ip6tables используется для настройки фильтра пакетов IPv6.
############################################
echo ""
echo " Узнать Версию программы virt-manager "
# virt-manager --version  # Узнать Версию программы, можно и с помощью (терминала)
sudo pacman -Q virt-manager  # Узнать Версию программы
sleep 03
echo ""
echo " Добавляет пользователя в группу libvirt "
echo " Пример: sudo gpasswd -a ИМЯ_ПОЛЬЗОВАТЕЛЯ libvirt "
sudo gpasswd -a $USER libvirt  # Команда gpasswd -a $USER libvirt в Linux добавляет пользователя в группу libvirt. Это необходимо, так как только root и пользователи этой группы могут использовать виртуальные машины KVM (Kernel Virtual Module).
sudo gpasswd -a $USER kvm   # Команда sudo gpasswd -a $USER kvm добавляет пользователя в группу kvm. Это может быть необходимо при настройке виртуализации KVM, например, на Arch Linux, где нужно обеспечить доступ пользователя к управлению виртуальными машинами. KVM — технология аппаратной виртуализации, поддерживаемая процессорами с технологиями Intel VT-x и AMD-V. KVM превращает ядро Linux в гипервизор, предоставляя виртуальным машинам доступ к реальным ресурсам сервера, но изолируя их друг от друга.
echo " Добавить текущего пользователя в группу libvirt,kvm "
echo " Для запуска виртуальных машин без прав root "
sudo usermod -aG libvirt,kvm $USER  # Добавить текущего пользователя в группу libvirt,kvm, которая имеет разрешение на захват на интерфейсах без необходимости использования sudo
# sudo usermod -a -G libvirt,kvm $USER
echo ""
echo " Включить его автоматический запуск при загрузке "
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
#sudo systemctl enable --now libvirtd.service
#sudo systemctl restart libvirtd.service
#sudo systemctl status libvirtd.service
echo ""
echo " Проверка, что демон виртуализации – libvirt-daemon – работает: "
sudo systemctl status libvirtd.service
echo ""
echo " Проверка, загружены ли модули KVM: "
lsmod | grep -i kvm  # Проверка, загружены ли модули KVM
echo ""
echo " Установка Virtual Machine Manager выполнена "
echo " Желательно перезагрузить систему для применения изменений "
fi
############# Справка ##############
### В принципе эти команды можно было бы запустить после правки libvirtd.conf, ну да ладно, потом перезапустим демона. И так включаем libvirtd как сервис, далее запускаем его ну и для проверки посмотрим его статус, из скрина видим сервис работает корректно
# sudo systemctl enable libvirtd.service
# sudo systemctl start libvirtd.service
# sudo systemctl status libvirtd.service
### перейдем к правке libvirtd.conf, надо раскоментировать два параметра:
# etc/libvirt/libvirtd.conf
# unix_sock_group = "libvirt"
# unix_sock_rw_perms = "0770"
# на всякий случай можно удостовериться проверив следующие командой в каких группах состоит наш пользователь
# groups $USER
### ну и перезапускаем сервис, смотрим статус сервиса
# sudo systemctl restart libvirtd.service
# sudo systemctl status libvirtd.service
### Настройка среды виртуализации
# После установки рекомендуется проверить и настроить среду виртуализации.
# 1. Проверьте модули KVM
# lsmod | grep kvm
# Вы должны увидеть либо kvm_intel, либо kvm_amd в зависимости от вашего процессора.
# Если модули не загружены, вы можете загрузить их вручную:
# sudo modprobe kvm
# sudo modprobe kvm_intel   # For Intel
# or
# sudo modprobe kvm_amd     # For AMD
# Чтобы обеспечить загрузку этих модулей при загрузке, добавьте их в /etc/modules-load.d/kvm.conf:
# echo -e "kvm\nkvm_intel" | sudo tee /etc/modules-load.d/kvm.conf
# or for AMD:
# echo -e "kvm\nkvm_amd" | sudo tee /etc/modules-load.d/kvm.conf
# 2. Проверка сети libvirt
# Проверьте, что виртуальная сеть по умолчанию доступна и активна:
# virsh net-list --all
# Если неактивен, активируйте его:
# virsh net-start default
# virsh net-autostart default
# Создание и управление виртуальными машинами с помощью Virt-Manager
# virt-manager — это графический интерфейс, который значительно упрощает управление виртуальными машинами.
################
### 1. Запустить Virt-Manager
# virt-manager
# Вы увидите понятный интерфейс, в котором вы сможете добавлять и управлять виртуальными машинами.
# 2. Создайте новую виртуальную машину
# Шаги:
# Нажмите кнопку «Создать новую виртуальную машину» .
# Выберите способ установки ОС:
# ISO-образ
# Сетевая установка
# PXE-загрузка
# Импортировать существующий образ диска
# Выберите ISO-образ или путь к установочному носителю.
# Назначьте ресурсы ЦП и памяти.
# Создайте или выберите виртуальный диск.
# Настройте сеть (NAT по умолчанию или пользовательский мост).
# Проверьте настройки и нажмите «Готово» , чтобы запустить виртуальную машину.
# 3. Доступ к виртуальным машинам и их использование
# Используйте virt-viewer или встроенный просмотрщик для взаимодействия с вашими виртуальными машинами. Вы можете приостанавливать, перезагружать, делать снимки и клонировать виртуальные машины из интерфейса virt-manager.
#####################################

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