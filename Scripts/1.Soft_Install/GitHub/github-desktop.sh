#!/usr/bin/env bash
# Install script github-desktop
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

GITHUB-DESKTOP_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
echo -e "${MAGENTA}
  <<< Установка дополнительного программного обеспечения (пакетов) для Разработки в Archlinux >>> ${NC}"
# Installing additional software (packages) for development in Archlinux
echo ""
echo -e "${GREEN}==> ${NC}Установить GitHub Desktop (github-desktop) - (GUI) онлайн-платформа разработки?"
#echo -e "${BLUE}:: ${NC}Установить GitHub Desktop (github-desktop) - (GUI) онлайн-платформа разработки?"
# Install GitHub Desktop (github-desktop) - an online development platform (GUI)?
echo -e "${MAGENTA}:: ${BOLD}GitHub Desktop — это приложение с открытым исходным кодом, которое позволяет вам взаимодействовать с GitHub через графический пользовательский интерфейс (GUI) вместо того, чтобы полагаться на командную строку или веб-браузер. GitHub Desktop мотивирует вас и вашу команду работать вместе, применяя лучшие практики с Git и GitHub. ${NC}"
echo " Домашняя страница: https://desktop.github.com/ ; (https://aur.archlinux.org/packages/github-desktop ; https://aur.archlinux.org/packages/github-desktop-bin). "  
echo -e "${MAGENTA}:: ${BOLD}Git — это система контроля версий, которая помогает вам управлять кодом и отслеживать его, а GitHub — это облачная хостинговая платформа, которая позволяет разработчикам управлять своими репозиториями Git. GitHub — это онлайн-платформа разработки с открытым исходным кодом. Кроме того, разработчики используют GitHub для отслеживания, хранения и совместной работы над проектами дизайна приложений. Разработчики могут загружать свои файлы кода и работать с другими разработчиками над проектами с открытым исходным кодом. GitHub также является сайтом социальной сети, который позволяет разработчикам открыто общаться, сотрудничать и продвигать свои идеи. GitHub Desktop — это приложение с открытым исходным кодом, которое позволяет вам взаимодействовать с GitHub через графический пользовательский интерфейс (GUI) вместо того, чтобы полагаться на командную строку или веб-браузер. GitHub Desktop мотивирует вас и вашу команду работать вместе, применяя лучшие практики с Git и GitHub. GitHub Desktop позволяет разработчикам активировать такие команды , как создание репозитория, запросы на извлечение и коммиты, всего одним щелчком мыши. Это дополнительное удобство добавляет дополнительный элемент гибкости в работу с Git и сотрудничество с другими разработчиками. ${NC}"
echo " Осталось только аутентифицировать свой аккаунт. Нажмите «Файл» на панели навигации, перейдите в «Параметры», выберите «Учетные записи» и пройдите аутентификацию. Готово! " 
echo -e "${CYAN}:: ${NC}Установка GitHub Desktop (github-desktop) и (github-desktop-bin) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить GitHub Desktop (github-desktop),    2 - Установить GitHub Desktop *(github-desktop-bin), 

    0 - НЕТ - Пропустить установку: " in_rapid  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_rapid" =~ [^120] ]]
do
    :
done
if [[ $in_rapid == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_rapid == 1 ]]; then
  echo ""
  echo " Установка GitHub Desktop (github-desktop) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
########## Зависимости ###########
sudo pacman -S --noconfirm --needed wget curl git  # Сетевая утилита для извлечения файлов из Интернета, Быстрая распределенная система контроля версий, Инструмент командной строки и библиотека для передачи данных с помощью URL-адресов.
### ошибка: не удалось подготовить транзакцию (конфликтующие зависимости)
### :: nodejs-lts-iron-20.15.0-1 and nodejs-22.3.0-1 are in conflict
sudo pacman -R nodejs  # Событийный ввод-вывод для JavaScript V8. https://archlinux.org/packages/extra/x86_64/nodejs/
# sudo pacman -R nodejs --noconfirm 
###  --noconfirm   не спрашивать каких-либо подтверждений
sudo pacman -S --noconfirm --needed libsecret  # Библиотека для хранения и извлечения паролей и других секретов. https://archlinux.org/packages/core/x86_64/libsecret/ ; Feb. 23, 2024, 10:28 p.m. UTC
sudo pacman -S --noconfirm --needed libxss  # Библиотека расширений X11 Screen Saver. https://archlinux.org/packages/extra/x86_64/libxss/ ; July 3, 2024, 7:24 p.m. UTC
sudo pacman -S --noconfirm --needed nspr  # Портативная среда выполнения Netscape. https://archlinux.org/packages/core/x86_64/nspr/ ; June 8, 2024, 10:45 p.m. UTC
sudo pacman -S --noconfirm --needed nss  # Службы сетевой безопасности. https://archlinux.org/packages/core/x86_64/nss/ ; Aug. 4, 2024, 5:27 p.m. UTC
sudo pacman -S --noconfirm --needed unzip  # Для извлечения и просмотра файлов в архивах .zip . https://archlinux.org/packages/extra/x86_64/unzip/ ; June 8, 2024, 8:15 p.m. UTC ; http://infozip.sourceforge.net/UnZip.html
sudo pacman -S --noconfirm --needed nodejs-lts-iron  # Событийный ввод-вывод для V8 javascript (выпуск LTS: Iron). https://archlinux.org/packages/extra/x86_64/nodejs-lts-iron/ ; July 24, 2024, 8:54 p.m. UTC ; Помечено как устаревшее 21 августа 2024 г. ; Конфликты: с nodejs
sudo pacman -S --noconfirm --needed npm  # Менеджер пакетов для JavaScript. https://archlinux.org/packages/extra/any/npm/ ; July 10, 2024, 5:50 p.m. UTC ; https://www.npmjs.com/
sudo pacman -S --noconfirm --needed xorg-server-xvfb  # X-сервер виртуального фреймбуфера. https://archlinux.org/packages/extra/x86_64/xorg-server-xvfb/ ; https://xorg.freedesktop.org/ ; April 12, 2024, 6:27 p.m. UTC
sudo pacman -S --noconfirm --needed yarn  # Быстрое, надежное и безопасное управление зависимостями. https://archlinux.org/packages/extra/any/yarn/ ; https://classic.yarnpkg.com/ ; July 11, 2024, 12:04 a.m. UTC
sudo pacman -S --noconfirm --needed github-cli  # Интерфейс командной строки GitHub ; https://github.com/cli/cli ; https://archlinux.org/packages/extra/x86_64/github-cli/ ; 20 августа 2024 г., 19:09 UTC
sudo pacman -S --noconfirm --needed hub  # cli-интерфейс для Github ; https://hub.github.com/ ; https://archlinux.org/packages/extra/x86_64/hub/ ; 12 июля 2024 г., 18:00 по всемирному координированному времени
############# GitHub Desktop ################
# sudo pamac build github-desktop  # Установка через пакмэна (pacman)
yay -S github-desktop --noconfirm  # Графический интерфейс для управления Git и GitHub ; https://aur.archlinux.org/github-desktop.git (только для чтения, нажмите, чтобы скопировать); https://desktop.github.com/ ; 2024-08-12 08:14 (UTC) ; Смотрите Зависимости !
############# GitHub Desktop ################
#git clone https://aur.archlinux.org/github-desktop.git  # (только для чтения, нажмите, чтобы скопировать) 
#cd github-desktop 
#makepkg -fsri  
#makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)  
#rm -Rf github-desktop  # удаляем директорию сборки
# rm -rf github-desktop 
mkdir ~/GitHub
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_rapid == 2 ]]; then
  echo ""
  echo " Установка GitHub Desktop (github-desktop-bin) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
########## Зависимости ###########
sudo pacman -S --noconfirm --needed wget curl git  # Сетевая утилита для извлечения файлов из Интернета, Быстрая распределенная система контроля версий, Инструмент командной строки и библиотека для передачи данных с помощью URL-адресов.
sudo pacman -S --noconfirm --needed libsecret  # Библиотека для хранения и извлечения паролей и других секретов. https://archlinux.org/packages/core/x86_64/libsecret/ ; Feb. 23, 2024, 10:28 p.m. UTC
sudo pacman -S --noconfirm --needed libxss  # Библиотека расширений X11 Screen Saver. https://archlinux.org/packages/extra/x86_64/libxss/ ; July 3, 2024, 7:24 p.m. UTC
sudo pacman -S --noconfirm --needed nspr  # Портативная среда выполнения Netscape. https://archlinux.org/packages/core/x86_64/nspr/ ; June 8, 2024, 10:45 p.m. UTC
sudo pacman -S --noconfirm --needed nss  # Службы сетевой безопасности. https://archlinux.org/packages/core/x86_64/nss/ ; Aug. 4, 2024, 5:27 p.m. UTC
sudo pacman -S --noconfirm --needed unzip  # Для извлечения и просмотра файлов в архивах .zip . https://archlinux.org/packages/extra/x86_64/unzip/ ; June 8, 2024, 8:15 p.m. UTC ; http://infozip.sourceforge.net/UnZip.html
sudo pacman -S --noconfirm --needed hub  # cli-интерфейс для Github ; https://hub.github.com/ ; https://archlinux.org/packages/extra/x86_64/hub/ ; 12 июля 2024 г., 18:00 по всемирному координированному времени
############# GitHub Desktop-bin ################
# sudo pamac github-desktop-bin  # Установка через пакмэна (pacman)
yay -S github-desktop-bin --noconfirm  # Графический интерфейс для управления Git и GitHub ; https://aur.archlinux.org/github-desktop-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://desktop.github.com/ ; https://aur.archlinux.org/packages/github-desktop-bin ; 2024-08-15 02:22 (UTC) ; Конфликты: с github-desktop ; Смотрите Зависимости !
############# GitHub Desktop ################
#git clone https://aur.archlinux.org/github-desktop-bin.git   # (только для чтения, нажмите, чтобы скопировать) 
#cd github-desktop-bin
#makepkg -fsri  
#makepkg -si --noconfirm  #-не спрашивать каких-либо подтверждений
# makepkg -si
#makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)  
#rm -Rf github-desktop-bin  # удаляем директорию сборки
# rm -rf github-desktop-bin 
mkdir ~/GitHub
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##################
sleep 3

clear
echo -e "${CYAN}
  <<< Справка по GitHub Desktop для системы Arch Linux >>> ${NC}"
# Installation of utilities (packages) for the Arch Linux system begins
echo ""
echo -e "${MAGENTA}:: ${BOLD}Нажмите на значок "GitHub Desktop" в меню приложений и откройте приложение.
 При первом открытии приложения вы увидите диалоговое окно. Если у вас уже есть учетная запись GitHub, нажмите кнопку «Войти на GitHub.com». Если у вас уже есть учетная запись GitHub, нажмите кнопку «Войти на GitHub Enterprise». Однако, если вы новый пользователь и хотите создать свою первую учетную запись, нажмите ссылку «Создать бесплатную учетную запись», но если вы не заинтересованы в создании или доступе к своей учетной записи, просто нажмите ссылку «Пропустить шаг».           
 Если вы решили создать бесплатную учетную запись, нажмите на ссылку «создать бесплатную учетную запись». Вы увидите следующую страницу. Затем нажмите на кнопку «создать учетную запись» после заполнения обязательных полей.
 Вы увидите следующую страницу. Нажмите «авторизовать рабочий стол», чтобы включить перечисленные функции на вашем рабочем столе.
 После нажатия кнопки «authorize desktop» вы увидите всплывающее окно, запрашивающее разрешение github.com открыть ссылку «x-github-desktop-dev-auth». Затем нажмите кнопку «Choose Application».
 Выберите приложение «GitHub Desktop» в следующем окне и нажмите «Открыть ссылку».
 Когда вы откроете установленное приложение GitHub Desktop, вы увидите следующую форму, которую вы используете для настройки Git. Вы увидите имя пользователя учетной записи GitHub и адрес электронной почты, которые были установлены при создании учетной записи GitHub. Нажмите «Продолжить», чтобы настроить Git для идентификации коммитов, сделанных пользователем.
 Если вы правильно настроили GitHub Desktop, вы увидите следующее. Нажмите «Готово» и вуаля! Вы завершили настройку Ubuntu GitHub Desktop!
 *Учебное пособие по GitHub Desktop: как использовать GitHub Desktop? https://www.simplilearn.com/how-to-use-github-desktop-tutorial-article  ${NC}"
sleep 7

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