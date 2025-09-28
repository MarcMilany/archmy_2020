#!/usr/bin/env bash
# Install script Caffeine
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

CAFFEINE_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
echo ""
echo -e "${BLUE}:: ${NC}Установить Caffeine-ng (caffeine-systray) (caffeine-ng) — Отключить Хранитель экрана (экранная заставка, screensaver, скринсейвер) — не дает заставке появляться или системе переходить в спящий режим при просмотре видео (фильмов) или (youtube)?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Хранитель экрана (экранная заставка, screensaver, скринсейвер) — системная утилита которая через заданное время простоя компьютера заменяет статическое изображение рабочего стола динамическим (или полностью черным). Хранители экрана используются как в качестве развлечения так и как мера безопасности (защита отключения заставки паролем). ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Caffeine-ng (caffeine-systray) — небольшое Python / GTK графическое приложение для предотвращения активации экранной заставки и режима пониженного энергопотребления. Caffeine (caffeine-ng) - это маленький демон, который сидит в вашем системном трее и не дает заставке появляться или системе переходить в спящий режим. Он делает это, когда приложение разворачивается на весь экран (например, youtube) или когда вы нажимаете на значок в системном трее (что вы можете сделать, например, когда читаете). Caffeine-ng интегрируется в область уведомлений (опционально) и автоматически отключает хранитель экрана во время работы любого заданного в настройках процесса (группы процессов), в список активации (~/.config/caffeine/whitelist.txt) можно добавлять любое приложение (процесс). Этот проект Лицензируется под GPL-3.0 или более поздняя версия. ${NC}"
echo " Домашняя страница: https://gitlab.com/hobarrera/caffeine-ng ; (https://github.com/hobarrera/caffeine-ng ; https://codeberg.org/WhyNotHugo/caffeine-ng ; https://aur.archlinux.org/packages/caffeine-ng ; https://aur.archlinux.org/packages/caffeine-ng-git). "
echo -e "${BLUE}:: ${NC}Особенности: у Caffeine имеется также пользовательский интерфейс - Caffeine indicator, после активации которого из меню приложений, в системном трее отображается значок программы, с возможностью активациии/деактивации утилиты вручную. *Функции: Ручное управление Caffeine необходимо в том случае, когда вы хотите отключить срабатывание экранной заставки в обычном режиме системы, т.е. не обязательно при просмотре видео. "
echo -e "${CYAN}:: ${NC}Caffeine-ng является форком Caffeine 2.4, так как в более поздних версиях приложения удалена функция добавления значка в область уведомлений (трей/systray), позволяющего вручную отключать хранитель экрана, ориентируясь только на автоматическое обнаружение заданных процессов, что являлось спорным преимуществом. Основной целью создания Caffeine-ng является устранение "наиболее спорных" проблем оригинального проекта и реализация недостающих но востребованных функций, дальнейшая развитие приложения будет происходить в рамках самостоятельного проекта. "
echo -e "${CYAN}:: ${NC}Установка Caffeine (caffeine-ng) и (caffeine-ng-git), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/caffeine-ng.git), (https://aur.archlinux.org/caffeine-ng-git.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить Caffeine (caffeine-ng),     2 - Установить Caffeine (caffeine-ng-git),

    0 - НЕТ - Пропустить установку: " in_caffeine  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_caffeine" =~ [^120] ]]
do
    :
done
if [[ $in_caffeine == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_caffeine == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Caffeine (caffeine-ng) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed xfconf  # (необязательно) – поддержка режима представления Xfce ; Система хранения конфигурации на базе D-Bus ; https://archlinux.org/packages/extra/x86_64/xfconf/ ; https://docs.xfce.org/xfce/xfconf/start ; 2024-12-25 18:54 UTC
########### python-ewmh ###############
yay -S python-ewmh --noconfirm  # Реализация EWMH (Расширенные подсказки оконного менеджера) на Python ; https://aur.archlinux.org/python-ewmh.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/parkouss/pyewmh/ ; https://aur.archlinux.org/packages/python-ewmh ; 2024-05-19 18:23 (UTC)
########### python-ewmh ###############
#git clone https://aur.archlinux.org/python-ewmh.git  # (только для чтения, нажмите, чтобы скопировать)
#cd python-ewmh
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf python-ewmh
#rm -Rf python-ewmh   # удаляем директорию сборки
########### python-pulsectl ###############
yay -S python-pulsectl --noconfirm  # Интерфейс высокого уровня Python и привязки на основе ctypes для PulseAudio (libpulse) ; https://aur.archlinux.org/python-pulsectl.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/mk-fg/python-pulse-control ; https://aur.archlinux.org/packages/python-pulsectl ; Конфликты: python-pulse-control ; 2025-03-24 15:17 (UTC)
########### python-pulsectl ###############
#git clone https://aur.archlinux.org/python-pulsectl.git  # (только для чтения, нажмите, чтобы скопировать)
#cd python-pulsectl
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf python-pulsectl
#rm -Rf python-pulsectl   # удаляем директорию сборки
########### caffeine-ng ###############
yay -S caffeine-ng --noconfirm  # Приложение строки состояния способно временно блокировать заставку и спящий режим ; https://aur.archlinux.org/caffeine-ng.git (только для чтения, нажмите, чтобы скопировать) ; https://codeberg.org/WhyNotHugo/caffeine-ng ; https://aur.archlinux.org/packages/caffeine-ng ; https://codeberg.org/attachments/6da08199-604f-4f0f-b9dd-c50efe587965 ; Конфликты: caffeine, caffeine-bzr, caffeine-oneclick, caffeine-systray ; Обеспечивает: caffeine, caffeine-bzr, caffeine-oneclick, caffeine-systray ; Заменяет: caffeine-oneclick, caffeine-systray ; 2024-09-24 00:34 (UTC)
########### caffeine-ng ###############
#git clone https://aur.archlinux.org/caffeine-ng.git  # (только для чтения, нажмите, чтобы скопировать)
#cd caffeine-ng
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf caffeine-ng
#rm -Rf caffeine-ng   # удаляем директорию сборки
  echo ""
  echo " Посмотрите информацию о версии (caffeine) "
# caffeine-ng --version  # Показать версию приложения
sudo pacman -Q caffeine  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_caffeine == 2 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Caffeine (caffeine-ng-git) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости необязательные ##############
sudo pacman -S --noconfirm --needed libappindicator-gtk3  # (необязательно) – оригинальная, ныне неподдерживаемая библиотека, сохранена как optdepends для обратной совместимости ; Разрешить приложениям расширять меню с помощью индикаторов Ayatana в Unity, KDE или Systray (библиотека GTK+ 3) ; https://archlinux.org/packages/extra/x86_64/libappindicator-gtk3/ ; https://launchpad.net/libappindicator ; 2024-07-15 09:19 UTC
sudo pacman -S --noconfirm --needed lib32-libappindicator-gtk3  # (необязательно) – оригинальная, ныне неподдерживаемая библиотека, сохранена как optdepends для обратной совместимости ; Разрешить приложениям расширять меню с помощью индикаторов Ayatana в Unity, KDE или Systray (32-бит) (библиотека GTK+ 3) ; https://archlinux.org/packages/multilib/x86_64/lib32-libappindicator-gtk3/ ; https://launchpad.net/libappindicator ; 2024-05-11 13:57 UTC
sudo pacman -S --noconfirm --needed xfconf  # (необязательно) – поддержка режима представления Xfce ; Система хранения конфигурации на базе D-Bus ; https://archlinux.org/packages/extra/x86_64/xfconf/ ; https://docs.xfce.org/xfce/xfconf/start ; 2024-12-25 18:54 UTC
############ Зависимости ##############
########### python-ewmh ###############
yay -S python-ewmh --noconfirm  # Реализация EWMH (Расширенные подсказки оконного менеджера) на Python ; https://aur.archlinux.org/python-ewmh.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/parkouss/pyewmh/ ; https://aur.archlinux.org/packages/python-ewmh ; 2024-05-19 18:23 (UTC)
########### python-ewmh ###############
#git clone https://aur.archlinux.org/python-ewmh.git  # (только для чтения, нажмите, чтобы скопировать)
#cd python-ewmh
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf python-ewmh
#rm -Rf python-ewmh   # удаляем директорию сборки
########### python-pulsectl ###############
yay -S python-pulsectl --noconfirm  # Интерфейс высокого уровня Python и привязки на основе ctypes для PulseAudio (libpulse) ; https://aur.archlinux.org/python-pulsectl.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/mk-fg/python-pulse-control ; https://aur.archlinux.org/packages/python-pulsectl ; Конфликты: python-pulse-control ; 2025-03-24 15:17 (UTC)
########### python-pulsectl ###############
#git clone https://aur.archlinux.org/python-pulsectl.git  # (только для чтения, нажмите, чтобы скопировать)
#cd python-pulsectl
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf python-pulsectl
#rm -Rf python-pulsectl   # удаляем директорию сборки
########### caffeine-ng-git ###############
yay -S caffeine-ng-git --noconfirm  # Приложение строки состояния способно временно блокировать заставку и спящий режим ; https://aur.archlinux.org/packages/caffeine-ng-git ; https://aur.archlinux.org/caffeine-ng-git.git (только для чтения, нажмите, чтобы скопировать) ; https://codeberg.org/WhyNotHugo/caffeine-ng ; Конфликты: caffeine, caffeine-bzr, caffeine-ng, caffeine-ng-regex ; Обеспечивает: caffeine, caffeine-bzr, caffeine-ng, caffeine-ng-regex ; 2025-03-13 09:51 (UTC)
########### caffeine-ng-git ###############
#git clone https://aur.archlinux.org/caffeine-ng-git.git  # (только для чтения, нажмите, чтобы скопировать)
#cd caffeine-ng-git
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf caffeine-ng-git
#rm -Rf caffeine-ng-git   # удаляем директорию сборки
####################
  echo ""
  echo " Посмотрите информацию о версии (caffeine) "
# caffeine-ng --version  # Показать версию приложения
sudo pacman -Q caffeine  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
# sudo pacman -S --noconfirm --needed gnome-shell-extension-caffeine  # Расширение для GNOME Shell для отключения заставки и автоматического перехода в режим ожидания ; https://github.com/eonpatapon/gnome-shell-extension-caffeine ; https://archlinux.org/packages/extra/any/gnome-shell-extension-caffeine/
# Страница руководства в настоящее время находится в usr/share/man/man1/caffeine/caffeine.1.gz. Правильное местоположение должно быть в usr/share/man/man1/caffeine.1.gz.
# При использовании man-dbпакета возвращается сообщение «Нет ручного ввода для кофеина» при man caffeineвыполнении.
###################################
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

