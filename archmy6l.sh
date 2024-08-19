#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! ####
apptitle="Arch Linux Fast Install v2.4 LegasyBIOS - Version: 2024.07.31.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя
###
BROWSER_PROG_LANG="russian"  # Installer default language (Язык установки по умолчанию)
ARCHMY5L_LANG="russian"  # Installer default language (Язык установки по умолчанию)
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
###############################
### Warning (Предупреждение)
_warning_banner() {
    echo -e "${YELLOW}
   ====================== ♥ Предупреждение ======================
${NC}
Цель сценария (скрипта) - это установка первоначально необходимого софта (пакетов) и запуск необходимых служб.
Смысл в том, что все изменения вы делаете предварительно в самом скрипте и получаете возможность быстрой установки утилит (пакетов), которые Вы решили установить (при условии, что Вы его изменили под себя, в противном случае скрипт установит софт (пакеты) прописанный изначально.
В процессе работы сценария (скрипта) Вам будут задаваться вопросы на установку той, или иной утилиты (пакета) - будьте внимательными! В скрипте есть утилиты (пакеты), которые устанавливаются из 'AUR'. Это 'Pacman gui' или 'Octopi', в зависимости от вашего выбора, и т.д.. Сам же 'AUR'-'yay' или 'pikaur' - скачивается с сайта 'Arch Linux', собирается и устанавливается. Остальной софт (пакеты) скачивается и устанавливается из 'Официальных репозиториев Arch Linux'. Если Вы сомневаетесь в своих действиях, скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска необходимых служб. В любой ситуации выбор всегда за вами. Вы либо гуляете под дождем, либо просто под ним мокнете.${RED}

  ***************************** ВНИМАНИЕ! *****************************
${NC}
Автор не несёт ответственности за любое нанесение вреда при использовании скрипта.
Вы используйте его на свой страх и риск, или изменяйте под свои личные нужды.
В данный момент сценарий (скрипта) находится в процессе доработки по прописыванию устанавливаемого софта (пакетов), и небольшой корректировке (Воен. Внесение поправок в наводку орудий по результатам наблюдений с наблюдательных пунктов).

${BLUE}===> ******************************************************* ${NC}"
}
###
### Display banner (Дисплей баннер)
_warning_banner
###
sleep 15
#echo ""
#echo -e "${MAGENTA}==> ${BOLD}Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети. ${NC}"
#echo 'Если у Вас беспроводное соединение, запустите nmtui и подключитесь к сети.'
# If you have a wireless connection, launch nmtui and connect to the network.
##################
clear
echo -e "${GREEN}
  <<< Начинается установка первоначально необходимого софта (пакетов) и запуск необходимых служб для системы Arch Linux >>>
${NC}"
# Installation of utilities (packages) for the Arch Linux system begins
echo -e "${BLUE}:: ${NC}Установка и настройка начата в $(date +%T)"
#echo "Установка и настройка начата в $(date +%T)"
# Installation and configuration started in $(date +%T)
###
echo ""
echo -e "${GREEN}=> ${NC}Для проверки интернета можно пропинговать какой-либо сервис"
#echo 'Для проверки интернета можно пропинговать какой-либо сервис'
# To check the Internet, you can ping a service
ping -c 2 archlinux.org  # Утилита ping - это очень простой инструмент для диагностики сети
# ping google.com -W 2 -c 1
## ping -l 3 ya.ru
###
echo -e "${CYAN}==> ${NC}Если пинг идёт едем дальше ... :)"
#echo 'Если пинг идёт едем дальше ... :)'
# If the ping goes we go further ... :)
sleep 1
###
echo ""
echo -e "${MAGENTA}==> ${NC}Давайте проверим наш часовой пояс ... :)"
#echo 'Давайте проверим наш часовой пояс ... :)'
# Let's check our time zone ... :)
timedatectl | grep "Time zone"
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Если NetworkManager запущен смотрим состояние интерфейсов"
#echo "Если NetworkManager запущен смотрим состояние интерфейсов"
# If NetworkManager is running look at the state of the interfaces
# Первым делом нужно запустить NetworkManager:
# sudo systemctl start NetworkManager
# Если NetworkManager запущен смотрим состояние интерфейсов (с помощью - nmcli):
nmcli general status
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Посмотреть имя хоста"
# View host name
nmcli general hostname
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Получаем состояние интерфейсов"
# Getting the state of interfaces
nmcli device status
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Смотрим список доступных подключений"
# See the list of available connections
nmcli connection show
sleep 1
###
echo ""
echo -e "${BLUE}:: ${NC}Смотрим состояние wifi подключения"
# Looking at the status of the wifi connection
nmcli radio wifi
sleep 1
## ---------------------------------------
## Посмотреть список доступных сетей wifi:
# nmcli device wifi list
## Теперь включаем:
# nmcli radio wifi on
## Или отключаем:
# nmcli radio wifi off
## Команда для подключения к новой сети wifi выглядит не намного сложнее. Например, давайте подключимся к сети TP-Link с паролем 12345678:
## nmcli device wifi connect "TP-Link" password 12345678 name "TP-Link Wifi"
## Если всё прошло хорошо, то вы получите уже привычное сообщение про создание подключения с именем TP-Link Wifi и это имя в дальнейшем можно использовать для редактирования этого подключения и управления им, как описано выше.
## ---------------------------------------
###
echo ""
echo -e "${BLUE}:: ${NC}Посмотрим данные о нашем соединение с помощью IPinfo..."
#echo " Посмотрим данные о нашем соединение с помощью IPinfo..."
# Let's look at the data about our connection using IP info...
echo -e "${CYAN}=> ${NC}С помощью IPinfo вы можете точно определять местонахождение ваших пользователей, настраивать их взаимодействие, предотвращать мошенничество, обеспечивать соответствие и многое другое."
echo " Надежный источник данных IP-адресов (https://ipinfo.io/) "
wget http://ipinfo.io/ip -qO -
sleep 03
###
echo ""
echo -e "${BLUE}:: ${NC}Узнаем версию и данные о релизе Arch'a ... :) "
#echo "Узнаем версию и данные о релизе Arch'a ... :)"
# Find out the version and release data for Arch ... :)
cat /proc/version
cat /etc/lsb-release.old
sleep 02
####################
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
################

clear
echo -e "${MAGENTA}
  <<< Установка утилит (пакетов) Веб-браузеров и медиа-плагинов в Archlinux >>> ${NC}"
# Installing Web Browser utilities (packages) in Archlinux
#clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Firefox Browser (firefox) - Браузер от Mozilla?"
echo -e "${MAGENTA}:: ${BOLD}Firefox — популярный интернет-браузер. Свободный веб-браузер, ориентированный на приватность и безопасность в Интернете. Многие дистрибутивы Linux поставляются с Firefox, предварительно установленным через их менеджер пакетов и установленным в качестве браузера по умолчанию. Разработчик: некоммерческая организация Mozilla Corporation и Mozilla Foundation. Первый тестовый выпуск программы появился 23 сентября 2002 г и назывался Phoenix. ${NC}"
echo " Домашняя страница: https://www.mozilla.org/firefox/ ; (https://archlinux.org/packages/extra/x86_64/firefox/). "  
echo -e "${MAGENTA}:: ${BOLD}В новой версии браузера Mozilla Firefox обновился движок – улучшилось качество отображения сайтов, возросла скорость их загрузки, совместимость со стандартами. Firefox содержит массу крупных и мелких улучшений интерфейса и, как следствие, работать стало намного комфортнее и удобней. Mozilla Firefox включает в себя серьёзные инструменты защищающие вас от мошенников и зловредных программ, а также лёгкие способы отличить хороших парней от плохих, такие как, например, проверка подлинности сайта одним щелчком. Также, благодаря открытому процессу разработки, тысячи экспертов по безопасности со всего мира круглые сутки работают над тем, чтобы вы (и ваша персональная информация) были в безопасности. ${NC}"
echo " Возможности: Синхронизация между устройствами. Настраиваемый внешний вид. Поддержка тем оформления. Поддержка дополнений (плагинов). Закладки (синхронизируются). Приватный просмотр. Блокировка рекламных трекеров. Управление паролями. Настройки безопасности. Режим просмотра видео «Картинка в картинке». У Firefox есть множество дополнений, которые помогут вам настроить его точно под свои нужды. Исходный код: Open Source (открыт); Языки программирования: C ; C++ ; JavaScript ; Rust ; Лицензия: Mozilla Public License; Приложение переведено на русский язык. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_firefox  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_firefox" =~ [^10] ]]
do
    :
done
if [[ $in_firefox == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_firefox == 1 ]]; then
echo ""
echo " Установка веб-браузера Firefox (firefox) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
#sudo pacman -S firefox firefox-i18n-ru firefox-spell-ru --noconfirm
sudo pacman -S --noconfirm --needed firefox  # Автономный веб-браузер от mozilla.org ; https://www.mozilla.org/firefox/ ; https://archlinux.org/packages/extra/x86_64/firefox/
sudo pacman -S --noconfirm --needed firefox-i18n-ru  # Русский языковой пакет для Firefox ; https://www.mozilla.org/firefox/ ; https://archlinux.org/packages/extra/any/firefox-i18n-ru/
sudo pacman -S --noconfirm --needed firefox-spell-ru  # Русский словарь проверки орфографии для Firefox ; https://addons.mozilla.org/firefox/dictionaries/ ; https://archlinux.org/packages/extra-testing/any/firefox-spell-ru/
sudo pacman -S --noconfirm --needed firefox-ublock-origin  # Надстройка эффективного блокировщика для различных браузеров. Быстрый, мощный и компактный ; https://github.com/gorhill/uBlock ; https://archlinux.org/packages/extra/any/firefox-ublock-origin/
sudo pacman -S --noconfirm --needed firefox-adblock-plus  # Расширение для Firefox, которое блокирует рекламу и баннеры ; https://adblockplus.org/ ; https://archlinux.org/packages/extra/any/firefox-adblock-plus/
sudo pacman -S --noconfirm --needed firefox-dark-reader # Инвертирует яркость веб-страниц и снижает нагрузку на глаза при просмотре веб-страниц ; https://darkreader.org/ ; https://archlinux.org/packages/extra/any/firefox-dark-reader/
sudo pacman -S --noconfirm --needed firefox-noscript  # Расширение для Firefox, которое отключает JavaScript ; https://noscript.net/ ; https://archlinux.org/packages/extra/any/firefox-noscript/
#sudo pacman -S --noconfirm --needed firefox-i18n-en-us  # Английский (США) языковой пакет для Firefox
# sudo pacman -S --noconfirm --needed firefox-developer-edition firefox-developer-edition-i18n-ru firefox-spell-ru  # Версия для разработчиков
# yay -S firefox-extension-arch-search --noconfirm  #   Набор веб-расширений, добавляющих ArchLinux (система отслеживания ошибок, форум, пакеты, вики, AUR) в качестве поисковой системы в браузер Firefox (на панель поиска Firefox) ; https://aur.archlinux.org/firefox-extension-arch-search.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/noraj/firefox-extension-arch-search ; https://aur.archlinux.org/packages/firefox-extension-arch-search
# pikaur -S firefox-extension-arch-search
# mkdir ~/.mozilla
# mkdir -p ~/.mozilla/firefox
# firefox -P
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############## Справка ##############
# Firefox - ArchWiki
# https://wiki.archlinux.org/title/Firefox
# Установка Firefox на Linux
# https://support.mozilla.com/ru/kb/ustanovka-firefox-na-linux
# Как настроить DNS over HTTPS в Firefox
# https://www.comss.ru/page.php?id=4950
########### Дополнение ##############
# ДЛЯ Mozilla - firefox
# KeePassXC-Browser (от KeePassXC Team); https://addons.mozilla.org/ru/firefox/addon/keepassxc-browser/
# ДЛЯ Google-chrome & Chromium
# KeePassXC-Browser (Официальный плагин браузера для менеджера паролей KeePassXC https://keepassxc.org) ; https://chromewebstore.google.com/detail/keepassxc-browser/oboonakemofpalcgghocfoadofidjkkk
# Лучше всего компьютеры умеют хранить информацию. Не тратьте время на запоминание и ввод паролей. KeePassXC может безопасно хранить ваши пароли и автоматически вводить их на ваших повседневных веб-сайтах и ​​в приложениях. Политика конфиденциальности: https://keepassxc.org/privacy/#privacy-keepassxc
#-----------------------------------------
# EPUBReader для Firefox (EPUBReader от epubreader)
# https://addons.mozilla.org/ru/firefox/addon/epubreader/
# EPUBReader позволяет нам читать электронные книги прямо в Firefox, просто нажимая на ссылку, указывающую на файл EPUB.
# Однако, несмотря на удобство, процесс установки EPUBReader вызывает опасения относительно конфиденциальности, поскольку запрашивает разрешения, что может быть тревожным сигналом для пользователей, обеспокоенных своей конфиденциальностью и безопасностью в Интернете...
#-----------------------------------------
# TWP - Translate Web Pages (от Filipe Dev)
# https://addons.mozilla.org/ru/firefox/addon/traduzir-paginas-web/
# Переводите страницу в режиме реального времени с помощью Google или Яндекс.
# Необязательно открывать новые вкладки. Теперь работает и с расширением NoScript.
#-------------------------------------
# В firefox используйте расширение FoxyProxy, или в параметрах сети укажите только SOCKS5.
# В настройках расширения, Добавить новый SOCKS5, ip: 127.0.0.1, port: 9050
#-----------------------
# PassFF - Дополнение, позволяющее пользователям менеджера паролей Unix «pass» (см. https://www.passwordstore.org/ ) получать доступ к своему хранилищу паролей из Firefox.
# https://addons.mozilla.org/ru/firefox/addon/passff/
####### Хост-приложение для WebExtension PassFF ###########
# sudo pacman -S --noconfirm --needed pass  # Безопасное хранение, извлечение, генерация и синхронизация паролей ; https://www.passwordstore.org/ ; https://archlinux.org/packages/extra/any/pass/ ; консольный вариант PASS — простой bash-скрипт для любителей терминала. https://www.passwordstore.org/
# sudo pacman -S --noconfirm --needed passff-host  # PassFF — собственное приложение для обмена сообщениями для Firefox, Chromium, Chrome, Vivaldi ; https://github.com/passff/passff-host ; https://archlinux.org/packages/extra/any/passff-host/ Хост-приложение для WebExtension PassFF ;
###########################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Chromium (chromium) - Веб-браузер?"
echo -e "${MAGENTA}:: ${BOLD}Chromium — это бесплатный, популярный браузер с открытым исходным кодом, разрабатываемый компанией Google. По утверждению разработчиков, Chromium предназначен для предоставления пользователям быстрого, безопасного и надёжного доступа в Интернет, а также удобной платформы для веб-приложений. Функциональность Chromium схожа с другими популярными браузерами. Изначально Chromium был создан в 2008 году компанией Google. Программный код Chromium позволяет изменять и добавлять компоненты браузера. Chromium используется в качестве базы для создания других популярных браузеров. На основе Chromium созданы браузеры: Google Chrome; Vivaldi; Яндекс Браузер; Opera; Brave; Microsoft Edge; И многие другие. ${NC}"
echo " Домашняя страница: https://www.chromium.org/Home ; (https://archlinux.org/packages/extra/x86_64/chromium/). "  
echo -e "${MAGENTA}:: ${BOLD}Зачем устанавливать Chromium на Linux? Вы можете захотеть установить Chromium на свою систему Linux по нескольким причинам. Во-первых, Chromium обеспечивает лучшую защиту конфиденциальности по сравнению с другими веб-браузерами. В отличие от Google Chrome, Chromium не отслеживает данные о просмотре, поэтому ваша информация остается конфиденциальной. Во-вторых, Chromium легкий и быстрый. В отличие от других веб-браузеров, которые потребляют значительные системные ресурсы, Chromium разработан для использования минимальных ресурсов, что делает его идеальным для компьютеров с низкими мощностями. Наконец, Chromium предлагает улучшенную совместимость с веб-стандартами. Поскольку Chromium является проектом с открытым исходным кодом, он поддерживает широкий спектр веб-стандартов, что упрощает использование веб-приложений и доступ к веб-сайтам. Одним из ключевых преимуществ Chromium перед другими веб-браузерами является его настраиваемость. Пользователи могут легко добавлять расширения и плагины для улучшения своего опыта просмотра, от блокировщиков рекламы и менеджеров паролей до загрузчиков видео и инструментов разработчика. ${NC}"
echo " Chromium совместим со всеми операционными системами, т. е. Linux, Windows, Mac и т. д. Исходный код: Open Source (открыт); Языки программирования: C; C++; Java; Приложение переведено на русский язык. В Linux Chromium можно установить с помощью системного пакетного менеджера. Будет установлена версия, которая была актуальной на момент выпуска дистрибутива, плюс обновления безопасности, если они были. Также можно установить Chromium с помощью snap-пакета. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_chromium  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_chromium" =~ [^10] ]]
do
    :
done
if [[ $in_chromium == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_chromium == 1 ]]; then
  echo ""
  echo " Установка веб-браузера Chromium (chromium) "
sudo pacman -S --noconfirm --needed chromium  # Веб-браузер, созданный для скорости, простоты и безопасности ; https://www.chromium.org/Home ; https://archlinux.org/packages/extra/x86_64/chromium/
# yay -S chromium-widevine --noconfirm  # Плагин для браузера, предназначенный для просмотра премиум-видеоконтента ; https://aur.archlinux.org/chromium-widevine.git (только для чтения, нажмите, чтобы скопировать) ; https://www.widevine.com/ ; https://aur.archlinux.org/packages/chromium-widevine ; Widevine обеспечивает надежную защиту премиум-контента, используя бесплатные стандартизированные решения для сервисов OTT и CAS ; https://github.com/Evangelions/chromium-widevine
echo -e "${BLUE}:: ${NC}Пропишем конфиг (chromium-flags.conf) для chromium "  
echo " Создать файл chromium-flags.conf в домашней директории ~/.config/ "
touch ~/.config/chromium-flags.conf   # Создать файл chromium-flags.conf в ~/.config/
echo " Пропишем конфигурации в chromium-flags.conf "
cat > ~/.config/chromium-flags.conf << EOF
--ignore-gpu-blacklist
--enable-gpu-rasterization
--enable-native-gpu-memory-buffers
--enable-zero-copy
--disable-gpu-driver-bug-workarounds
--extension-mime-request-handling=always-prompt-for-install
EOF
############
echo " Для начала сделаем его бэкап ~/.config/chromium-flags.conf "
cp ~/.config/chromium-flags.conf  ~/.config/chromium-flags.conf.back
echo " Просмотреть содержимое файла ~/.config/chromium-flags.conf "
#ls -l ~/.config/chromium-flags.conf   # ls — выводит список папок и файлов в текущей директории
cat ~/.config/chromium-flags.conf  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 3
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
###### Настройки браузера #########
# https://wiki.archlinux.org/title/Chromium
# https://anzix.github.io/posts/ultimate-ungoogled-chromium-guide/
# Chromium запустите с флагом:
# chromium --proxy-server='socks://127.0.0.1:9050' &
# ДЛЯ Google-chrome & Chromium
# KeePassXC-Browser (Официальный плагин браузера для менеджера паролей KeePassXC https://keepassxc.org) ; https://chromewebstore.google.com/detail/keepassxc-browser/oboonakemofpalcgghocfoadofidjkkk
# Лучше всего компьютеры умеют хранить информацию. Не тратьте время на запоминание и ввод паролей. KeePassXC может безопасно хранить ваши пароли и автоматически вводить их на ваших повседневных веб-сайтах и ​​в приложениях. Политика конфиденциальности: https://keepassxc.org/privacy/#privacy-keepassxc
####### Хост-приложение для WebExtension PassFF ###########
# sudo pacman -S --noconfirm --needed pass  # Безопасное хранение, извлечение, генерация и синхронизация паролей ; https://www.passwordstore.org/ ; https://archlinux.org/packages/extra/any/pass/ ; консольный вариант PASS — простой bash-скрипт для любителей терминала. https://www.passwordstore.org/
# sudo pacman -S --noconfirm --needed passff-host  # PassFF — собственное приложение для обмена сообщениями для Firefox, Chromium, Chrome, Vivaldi ; https://github.com/passff/passff-host ; https://archlinux.org/packages/extra/any/passff-host/ Хост-приложение для WebExtension PassFF ; 
###################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Google Chrome - Популярный веб-браузер от Google для Linux?"
echo -e "${MAGENTA}:: ${BOLD}Google Chrome — браузер, программа для просмотра интернет-страниц, от компании Google на основе свободного браузера Chromium и движка Blink. Сейчас это самый популярный браузер в мире. ${NC}"
echo " Домашняя страница: https://www.google.com/chrome ; (https://aur.archlinux.org/packages/google-chrome ; https://aur.archlinux.org/packages/google-chrome-dev). "  
echo -e "${MAGENTA}:: ${BOLD}Chrome создан для эффективной работы. Режимы энергосбережения и экономии памяти помогут вам стать продуктивнее. Инструменты Chrome помогают управлять открытыми вкладками. Организуйте свою работу в браузере, чтобы повысить эффективность: группируйте вкладки, присваивайте им метки и цвета. Chrome совместим с разными устройствами и платформами. Вам будет удобно работать в нем, чем бы вы ни пользовались. Обновления Chrome выходят каждые четыре недели. Мы постоянно добавляем в браузер новые функции и делаем его быстрее и безопаснее. ${NC}"
echo " Основные возможности браузера Google Chrome: Поддержка большого количества вкладок. Поддержка расширений. Доступно более 150000 расширений. Запоминание паролей и платежных данных. Максимальная интеграция с поиском Google. Встроенный блокировщик рекламы. Быстрый перевод сайтов на другие языки через Google Translate. Синхронизация через аккаунт Google. Синхронизация истории, закладок и других данных. Защита от вредоносных сайтов. Интеллектуальная защита от фишинга. Поддержка тем оформления. Инструменты разработчика (веб-инспектор). Регулярные обновления, исправления ошибок и устранение уязвимостей. " 
echo " Google Chrome использует Chromium в качестве базы. Сначала все основные изменения вносятся в Chromium, тестируются и только потом стабильные версии используются в Google Chrome. При выпуске релизов Google Chrome используются стабильные версии Chromium. Содержит закрытые компоненты (проприетарные). Периодически отправляет отчеты об использовании (статистику) и отчеты о сбоях в Google (можно отключить). Включает компонент автоматического обновления (Google Update). "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить Google Chrome (google-chrome) (Stable channel),   2 - Установить Google Chrome (google-chrome-dev) (Dev Channel),    

    0 - НЕТ - Пропустить установку: " g_chrome  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$g_chrome" =~ [^120] ]]
do
    :
done
if [[ $g_chrome == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $g_chrome == 1 ]]; then
  echo ""
  echo " Установка Google Chrome (google-chrome) (Stable channel) "
sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов   
yay -S google-chrome --noconfirm  # Популярный веб-браузер от Google (Стабильный канал) ; https://aur.archlinux.org/google-chrome.git (только для чтения, нажмите, чтобы скопировать) ; https://www.google.com/chrome ; https://aur.archlinux.org/packages/google-chrome
######## google-chrome ############
#git clone https://aur.archlinux.org/google-chrome.git
#cd google-chrome
# makepkg -fsri
# makepkg -si  
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений 
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf google-chrome
#rm -Rf google-chrome
echo -e "${BLUE}:: ${NC}Пропишем конфиг (chrome-flags.conf) для google-chrome "  
echo " Создать файл chrome-flags.conf в домашней директории ~/.config/ "
touch ~/.config/chrome-flags.conf   # Создать файл chrome-flags.conf в ~/.config/
echo " Пропишем конфигурации в chrome-flags.conf "
cat > ~/.config/chrome-flags.conf << EOF
# WARNING: VA-API does not work with the Chrome package when using the native Wayland backend.
--ignore-gpu-blacklist
--enable-gpu-rasterization
--enable-native-gpu-memory-buffers
--enable-zero-copy
--disable-gpu-driver-bug-workarounds
--extension-mime-request-handling=always-prompt-for-install
EOF
############
echo " Для начала сделаем его бэкап ~/.config/chrome-flags.conf "
cp ~/.config/chrome-flags.conf  ~/.config/chrome-flags.conf.back
echo " Просмотреть содержимое файла ~/.config/chrome-flags.conf "
#ls -l ~/.config/chrome-flags.conf   # ls — выводит список папок и файлов в текущей директории
cat ~/.config/chrome-flags.conf  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 3
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $g_chrome == 2 ]]; then
  echo ""
  echo " Установка Google Chrome (google-chrome-dev) (Dev Channel) "
sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов   
yay -S google-chrome-dev --noconfirm  # Популярный веб-браузер от Google (Dev Channel) ; https://aur.archlinux.org/google-chrome-dev.git (только для чтения, нажмите, чтобы скопировать) ; https://www.google.com/chrome ; https://aur.archlinux.org/packages/google-chrome-dev  
######## google-chrome-dev ############
#git clone https://aur.archlinux.org/google-chrome-dev.git
#cd google-chrome-dev
# makepkg -fsri
# makepkg -si  
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений 
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf google-chrome-dev
#rm -Rf google-chrome-dev
echo -e "${BLUE}:: ${NC}Пропишем конфиг (chrome-flags.conf) для google-chrome "  
echo " Создать файл chrome-flags.conf в домашней директории ~/.config/ "
touch ~/.config/chrome-flags.conf   # Создать файл chrome-flags.conf в ~/.config/
echo " Пропишем конфигурации в chromium-flags.conf "
cat > ~/.config/chrome-flags.conf << EOF
# WARNING: VA-API does not work with the Chrome package when using the native Wayland backend.
--ignore-gpu-blacklist
--enable-gpu-rasterization
--enable-native-gpu-memory-buffers
--enable-zero-copy
--disable-gpu-driver-bug-workarounds
--extension-mime-request-handling=always-prompt-for-install
EOF
############
echo " Для начала сделаем его бэкап ~/.config/chrome-flags.conf "
cp ~/.config/chrome-flags.conf  ~/.config/chrome-flags.conf.back
echo " Просмотреть содержимое файла ~/.config/chrome-flags.conf "
#ls -l ~/.config/chrome-flags.conf   # ls — выводит список папок и файлов в текущей директории
cat ~/.config/chrome-flags.conf  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 3
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#########################
# Chromium запустите с флагом.
# chromium --proxy-server='socks://127.0.0.1:9050' &
# yay -S chromedriver --noconfirm  # Автономный сервер, реализующий стандарт W3C WebDriver (для Google Chrome) ; https://aur.archlinux.org/chromedriver.git (только для чтения, нажмите, чтобы скопировать) ; https://chromedriver.chromium.org/ ; https://aur.archlinux.org/packages/chromedriver
# ChromeDriver — это автономный сервер, реализующий стандарт W3C WebDriver . WebDriver — это инструмент с открытым исходным кодом, созданный для автоматического тестирования веб-приложений во многих браузерах. Его интерфейс позволяет контролировать и самоанализ пользовательских агентов локально или удаленно, используя возможности.
# Возможности — это независимый от языка набор пар ключ-значение, используемый для определения желаемых функций и поведения сеанса WebDriver. Возможности обычно передаются в качестве аргумента при создании экземпляра WebDriver и могут использоваться для указания настроек браузера, таких как имя браузера, версия и стратегия загрузки страницы.
#-------------------------
# yay -S pt-plugin-plus-git --noconfirm  # Плагин для браузера Microsoft Edge, Google Chrome, Firefox (веб-расширения), который в основном используется для облегчения загрузки PT station ; https://aur.archlinux.org/pt-plugin-plus-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/pt-plugins/PT-Plugin-Plus ; https://aur.archlinux.org/packages/pt-plugin-plus-git
# PT Assistant Plus — это подключаемый модуль браузера (веб-расширение) для Google Chrome и Firefox.
# Он в основном используется для облегчения загрузки исходных данных со станций PT. С помощью сервера загрузки (например, Transmission, µTorrent и т. д.) указанный торрент можно загрузить одним щелчком мыши.
###### Настройки браузера #########
### https://wiki.archlinux.org/title/Chromium
### https://anzix.github.io/posts/ultimate-ungoogled-chromium-guide/
# ДЛЯ Google-chrome & Chromium
# KeePassXC-Browser (Официальный плагин браузера для менеджера паролей KeePassXC https://keepassxc.org) ; https://chromewebstore.google.com/detail/keepassxc-browser/oboonakemofpalcgghocfoadofidjkkk
# Лучше всего компьютеры умеют хранить информацию. Не тратьте время на запоминание и ввод паролей. KeePassXC может безопасно хранить ваши пароли и автоматически вводить их на ваших повседневных веб-сайтах и ​​в приложениях. Политика конфиденциальности: https://keepassxc.org/privacy/#privacy-keepassxc
####### Хост-приложение для WebExtension PassFF ###########
# sudo pacman -S --noconfirm --needed pass  # Безопасное хранение, извлечение, генерация и синхронизация паролей ; https://www.passwordstore.org/ ; https://archlinux.org/packages/extra/any/pass/ ; консольный вариант PASS — простой bash-скрипт для любителей терминала. https://www.passwordstore.org/
# sudo pacman -S --noconfirm --needed passff-host  # PassFF — собственное приложение для обмена сообщениями для Firefox, Chromium, Chrome, Vivaldi ; https://github.com/passff/passff-host ; https://archlinux.org/packages/extra/any/passff-host/ Хост-приложение для WebExtension PassFF ;
###################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Vivaldi Browser (vivaldi) - Функциональный браузер с защитой от отслеживания?"
echo -e "${MAGENTA}:: ${BOLD}Vivaldi — Функциональный браузер с защитой от отслеживания, с большим количеством настроек и дополнительными возможностями. Над разработкой Vivaldi работает компания Vivaldi Techonolgies. Компания была основана в 2014 году Йоном Стефенсоном, который является одним из основателей Opera Software. Vivaldi основан на движке Chromium. Используется свободный движок для отображения веб-страниц Blink, который также используется в других браузерах, например, Opera и Google Chrome. Vivaldi наследует часть функций браузера Opera, но при этом обладает и другими интересными возможностями. В качестве технологии защиты от отслеживания задействовано решение DuckDuckGo Tracker Radar. Программа не является полностью Open Source продуктом. Основная кодовая база открыта, но есть часть проприетарных компонентов. Исходный код: Закрыт (проприетарный); Языки программирования: C++; Приложение переведено на русский язык. ${NC}"
echo " Домашняя страница: https://vivaldi.com/ ; (https://archlinux.org/packages/extra/x86_64/vivaldi/). "  
echo -e "${MAGENTA}:: ${BOLD}Возможности и особенности: Много настроек по сравнению с другими браузерами. Встроенная блокировка рекламы. Защита от отслеживания. Настраиваемый внешний вид и поведение. Поддержка тем оформления. Автоматическое подсвечивание вкладок и строки адреса цветом веб-сайта. Группировка вкладок. Боковая панель. Визуальные вкладки с миниатюрами страниц. Возможность выбора позиции размещения вкладок (сверху, справа, снизу или слева). Менеджер заметок. Встроенная функция создания скриншотов веб-страниц. Менеджер закладок (с возможностью задания коротких имен закладок для быстрого доступа к сайтам). Веб-панели для быстрого доступа к важным функциям или сайтам. Быстрые команды (управление с помощью коротких текстовых команд). Управление жестами мыши. Сохранение списков открытых вкладок для последующего быстрого доступа к ним (сессии). Поддержка горячих клавиш с возможностью настройки. ${NC}"
echo " Интерфейс: Vivaldi обладает приятным и легким интерфейсом. Интерфейс можно настраивать. Важным функциональным элементом Vivaldi является боковая панель. Она содержит несколько вкладок, которые также можно настраивать. Через нее можно получить доступ к панели закладок, загрузкам, истории, заметкам. Когда установка будет завершена, Vivaldi можно запустить из главного меню (раздел Интернет). Можно запустить программу из командной строки, выполнив команду: vivaldi . " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_vivaldi  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_vivaldi" =~ [^10] ]]
do
    :
done
if [[ $in_vivaldi == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_vivaldi == 1 ]]; then
  echo ""
  echo " Установка Vivaldi Browser (vivaldi) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed vivaldi  # Продвинутый браузер, созданный для опытных пользователей ; https://vivaldi.com/ ; https://archlinux.org/packages/extra/x86_64/vivaldi/ ; 
sudo pacman -S --noconfirm --needed vivaldi-ffmpeg-codecs  # Дополнительная поддержка фирменных кодеков для vivaldi ; https://ffmpeg.org/ ; https://archlinux.org/packages/extra/x86_64/vivaldi-ffmpeg-codecs/ ; FFmpeg теперь реализует собственный декодер xHE-AAC.
####### Хост-приложение для WebExtension PassFF ###########
sudo pacman -S --noconfirm --needed pass  # Безопасное хранение, извлечение, генерация и синхронизация паролей ; https://www.passwordstore.org/ ; https://archlinux.org/packages/extra/any/pass/ ; консольный вариант PASS — простой bash-скрипт для любителей терминала. https://www.passwordstore.org/
sudo pacman -S --noconfirm --needed passff-host  # PassFF — собственное приложение для обмена сообщениями для Firefox, Chromium, Chrome, Vivaldi ; https://github.com/passff/passff-host ; https://archlinux.org/packages/extra/any/passff-host/ Хост-приложение для WebExtension PassFF 
######## vivaldi-update-ffmpeg-hook ############
yay -S vivaldi-update-ffmpeg-hook --noconfirm  # Подключитесь для автоматического включения воспроизведения фирменных медиафайлов ; https://aur.archlinux.org/vivaldi-update-ffmpeg-hook.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/KucharczykL/vivaldi-update-ffmpeg-hook ; https://aur.archlinux.org/packages/vivaldi-update-ffmpeg-hook ; 
# Это просто другой подход к поддержанию актуальности кодеков ffmpeg. В случае vivaldi-codecs-ffmpeg-extra-bin и vivaldi-snapshot-ffmpeg-codecsваши кодеки обновляются, когда сопровождающий пакета понимает, что они устарели, и отправляет обновление в AUR. В случае «этого» пакета и vivaldi-arm-bin(ARM-версия Vivaldi) отдельный скрипт или хук после установки/обновления pacmanвызывается каждый раз, когда Vivaldi устанавливается/обновляется. Хотя первый подход может показаться лучше, «этот» подход работает довольно хорошо из-за цикла обновления Vivaldi (в котором выходит около 2–4 новых релизов в месяц). Кроме того, «этот» подход более автоматизирован и означает, что вы полагаетесь только на частоту обновления одного пакета AUR, а не на два... колебания и обходные пути.
# Когда я создавал этот пакет, после каждого обновления мне приходилось вручную запускать "/opt/vivaldi/update-ffmpeg", иначе видео не работали. Если воспроизведение видео работает после обновления даже без его запуска, то этот пакет больше не нужен.
######## vivaldi-snapshot-ffmpeg-codecs ############
# yay -S vivaldi-snapshot-ffmpeg-codecs --noconfirm  # 2024-08-16 14:14 (UTC) ; Дополнительная поддержка фирменных кодеков для vivaldi ; https://aur.archlinux.org/vivaldi-snapshot-ffmpeg-codecs.git (только для чтения, нажмите, чтобы скопировать) ; https://ffmpeg.org/ ; https://aur.archlinux.org/packages/vivaldi-snapshot-ffmpeg-codecs
######## vivaldi-multiarch-bin ############
# yay -S vivaldi-multiarch-bin --noconfirm  # Продвинутый браузер, созданный для опытных пользователей. Включает все поддерживаемые архитектуры ; https://aur.archlinux.org/vivaldi-multiarch-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://aur.archlinux.org/packages/vivaldi-multiarch-bin ; https://vivaldi.com/ ; Конфликты: с vivaldi
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############### Справка и Дополнения ##################
# Vivaldi Browser
# https://vivaldi.com/ru/
# https://wiki.archlinux.jp/index.php/Vivaldi
# Флаги также можно писать на отдельных строках для удобства чтения. Однако это не обязательно.
# vivaldi-stable.conf - Ниже приведен пример файла, который отключает аппаратный медиа-ключ браузера :
# ~/.config/vivaldi-stable.conf
# --disable-features=Processing of hardware media keys
# yay -S vivaldi-codecs-ffmpeg-extra-bin --noconfirm  # Готовый пакет кодеков ffmpeg для Vivaldi ; https://aur.archlinux.org/vivaldi-codecs-ffmpeg-extra-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://packages.ubuntu.com/bionic/amd64/chromium-codecs-ffmpeg-extra/download ; https://aur.archlinux.org/packages/vivaldi-codecs-ffmpeg-extra-bin ; Конфликты: с vivaldi-codecs-ffmpeg-extra-bin-arm64, vivaldi-codecs-ffmpeg-extra-bin-rpi, vivaldi-ffmpeg-codecs
# yay -S vivaldi-autoinject-custom-js-ui --noconfirm  # Управлять пользовательскими модами js UI для веб-браузера vivaldi ; https://aur.archlinux.org/vivaldi-autoinject-custom-js-ui.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/budlabs/vivaldi-autoinject-custom-js-ui ; https://aur.archlinux.org/packages/vivaldi-autoinject-custom-js-ui ; Чтобы вручную добавить пользовательские модификации JavaScript в веб-браузер Vivaldi необходимо выполнить следующие действия: Добавьте файл javascript в каталог ресурсов vivaldis (в Arch это /opt/vivaldi/resources/vivaldi) ; Добавьте запись в файл window.html (до vivaldi 6.2: browser.html) в том же каталоге.
####################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Opera (opera) - Веб-браузер?"
echo -e "${MAGENTA}:: ${BOLD}Opera - Графический веб-браузер, с открытым исходным кодом, основанный на движке Blink, быстрый, безопасный и простой в использовании браузер, теперь со встроенным блокировщиком рекламы, функцией экономии заряда батареи и бесплатным VPN, разработанный Opera Software. В браузере Opera есть все необходимое для конфиденциальной и безопасной работы в интернете. Opera - это один из самых лучших браузеров для персонального компьютера. Раньше разработчики поддерживали собственный движок, но потом приняли решение перейти на движок Chromium. Разработка браузера началась в 1994 году в норвежской компании под названием Opera Software. Теперь разработка перешла в руки китайской компании. ${NC}"
echo " Домашняя страница: https://www.opera.com/ ; (https://aur.archlinux.org/packages/opera). "  
echo -e "${MAGENTA}:: ${BOLD}Некоторые возможности и особенности программы: Встроенные функции блокировки рекламы. Встроенный бесплатный VPN. Синхронизация данных между устройствами. Боковая панель. Поиск по вкладкам. Объединение групп вкладок в собственные "пространства". Встроенные мессенджеры. Персонализированные новости. Инструмент для создания скриншотов. Opera Flow - быстрый доступ к сохраненным файлам, ссылкам, заметкам с любого устройства. Просмотр видео в отдельном всплывающем окне. Закладки. Импорт закладок. Функция экономии заряда аккумулятора для ноутбуков. Встроенный Twitter клиент. Конвертер единиц. Доступ к Instagram через боковую панель и т.д... ${NC}"
echo " Браузер Opera не включен в официальные репозитории дистрибутива, поскольку не распространяется с открытым исходным кодом. По умолчанию подключение через VPN не активировано, но вы можете его очень просто включить. Для этого откройте Настройки, пролистайте вниз и кликните по ссылке Дополнительно. Затем найдите пункт VPN и поставьте флажок включить VPN: Затем вы увидите значок VPN в адресной строке. Если ее цвет оранжевый, это значит, что вы не подключены к VPN. Синий цвет индикатора означает, что браузер уже в безопасности. Вы можете выбрать одну из доступных стран. " 
echo -e "${CYAN}:: ${NC}Установка Opera (opera) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! Также можно установить Opera с помощью snap-пакета. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_opera  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_opera" =~ [^10] ]]
do
    :
done
if [[ $in_opera == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_opera == 1 ]]; then
  echo ""
  echo " Установка веб-браузера Opera (opera) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)   
# yay -S opera opera-ffmpeg-codecs --noconfirm
######### opera ##########
yay -S opera --noconfirm  # Быстрый и безопасный веб-браузер ; https://aur.archlinux.org/opera.git (только для чтения, нажмите, чтобы скопировать) ; https://www.opera.com/ ; https://aur.archlinux.org/packages/opera
#git clone https://aur.archlinux.org/opera.git  # (только для чтения, нажмите, чтобы скопировать)
#cd opera
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf opera 
#rm -Rf opera
######### opera-ffmpeg-codecs ##########
yay -S opera-ffmpeg-codecs --noconfirm  # Дополнительная поддержка проприетарных кодеков для оперы ; https://aur.archlinux.org/opera-ffmpeg-codecs.git (только для чтения, нажмите, чтобы скопировать) ; https://ffmpeg.org/ ; https://aur.archlinux.org/packages/opera-ffmpeg-codecs
#git clone https://aur.archlinux.org/opera-ffmpeg-codecs.git   # (только для чтения, нажмите, чтобы скопировать)
#cd ffmpeg-codecs
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf ffmpeg-codecs 
#rm -Rf ffmpeg-codecs
######### opera-ffmpeg-codecs-bin ##########
#yay -S opera-ffmpeg-codecs-bin --noconfirm  # Дополнительная поддержка фирменных кодеков для Opera, извлеченных непосредственно из snap-файла chromium-ffmpeg ; https://aur.archlinux.org/opera-ffmpeg-codecs-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://snapcraft.io/chromium-ffmpeg/ ; https://aur.archlinux.org/packages/opera-ffmpeg-codecs-bin
#git clone https://aur.archlinux.org/opera-ffmpeg-codecs-bin.git   # (только для чтения, нажмите, чтобы скопировать)
#cd opera-ffmpeg-codecs-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf opera-ffmpeg-codecs-bin 
#rm -Rf opera-ffmpeg-codecs-bin
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Brave Browser (brave-bin) - Безопасный браузер с надежной основой?"
echo -e "${MAGENTA}:: ${BOLD}Brave — это бесплатный кроссплатформенный веб-браузер с открытым исходным кодом, разработанный и поддерживаемый Brave Software Incorporation. С Brave вы можете сохранить конфиденциальность своей активности в Интернете, автоматически отключив трекеры веб-сайтов и заблокировав рекламу. Он создан на основе Chromium, который является версией Google Chrome с открытым исходным кодом. Он в основном написан на языке программирования C++ и был впервые выпущен в 2016 году по лицензии MPL-2. Вы можете загрузить его практически для всех основных операционных систем, включая Android, iOS, macOS, Windows и Linux. Brave поддерживается на 64-битных архитектурах AMD/Intel (amd64 / x86_64) и ARM (arm64 / aarch64). Браузер достаточно динамично развивается и некоторые его сервисы могут уходить на доработку. Стоит отметить, на работу в интернете это никак не влияет. ${NC}"
echo " Домашняя страница: https://brave.com/ ; (https://aur.archlinux.org/packages/brave-bin). "  
echo -e "${MAGENTA}:: ${BOLD}Одной из ключевых особенностей Brave является встроенный кошелек, который позволяет управлять криптоактивами прямо из браузера. Браузер Brave — конфиденциальная альтернатива Chrome. Brave НЕ: блокчейн браузер, анонимный браузер, быстрее остальных браузеров. Brave = (Google Chrome + блокировщик рекламы и скриптов + новый опыт отношений между пользователем и интернетом + криптовалюта) — (рекламные трекеры и big data). ${NC}"
echo " Вознаграждения Brave: Brave Rewards относится к вознаграждениям BAT, которые вы получаете при просмотре рекламы. Мне нравится то, что у вас будет возможность собирать эти криптовалюты и затем отправлять их своим любимым художникам и создателям контента в качестве своего рода чаевых. Shields: это функция блокировки рекламы в Brave Browser, которая предотвращает отслеживание вашей информации и увеличивает скорость просмотра веб-страниц. Интеграция TOR: Это дополнительный шаг вперёд в обеспечении конфиденциальности и защиты. Вместо типичного режима инкогнито, Brave интегрирует TOR в свою систему, чтобы вы могли испытать абсолютно неуязвимый опыт сёрфинга в интернете. Режим инкогнито в других браузерах обеспечивает лишь частичную неуязвимость. В то время как с TOR вы получаете настоящую анонимность. "
echo -e "${CYAN}:: ${NC}Установка Brave (brave-bin) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "  
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить Brave Browser (brave-bin),    2 - Установить Brave Browser (brave-nightly-bin), 

    0 - НЕТ - Пропустить установку: " in_brave  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_brave" =~ [^120] ]]
do
    :
done
if [[ $in_brave == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_brave == 1 ]]; then
  echo ""
  echo " Установка Brave Browser (brave-bin) "
sudo pacman -Syu  # Обновите и модернизируйте свою работающую систему
# sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
yay -S brave-bin --noconfirm  # Веб-браузер, который по умолчанию блокирует рекламу и трекеры (бинарная версия) ; https://aur.archlinux.org/brave-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://brave.com/ ; https://aur.archlinux.org/packages/brave-bin ; Конфликты: с brave !!! ; Блокируйте рекламу. Экономьте данные. И получайте гораздо более быстрые веб-страницы. Просто переключив браузер.
####### brave-bin ############
#git clone https://aur.archlinux.org/sublime-text-4.git   # (только для чтения, нажмите, чтобы скопировать)
#cd brave-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf brave-bin 
#rm -Rf brave-bin
##### brave-extension-bitwarden-git ###########
# yay -S brave-extension-bitwarden-git --noconfirm  # Расширение браузера Bitwarden (Bitwarden Client) для Brave ; https://aur.archlinux.org/extension-bitwarden-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/bitwarden/clients ; https://aur.archlinux.org/packages/brave-extension-bitwarden-git ; Конфликты: с brave-extension-bitwarden !!!
##### python-adblock ###########
sudo pacman -S --noconfirm --needed python-adblock  # Библиотека Brave AdBlock на Python ; https://github.com/ArniDagur/python-adblock ; https://archlinux.org/packages/extra/x86_64/python-adblock/ ; Оболочка Python для библиотеки блокировки рекламы Brave, написанная на Rust.
brave --version  # Проверьте установку, проверив версию сборки
# yay -Sua  # Обновление Brave
# sudo pacman -Rs brave-bin  # Удалить Brave из Arch
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_brave == 2 ]]; then
  echo ""
  echo " Установка Brave Browser (brave-nightly-bin) "
  echo " Nightly — это ранняя, непроверенная версия с неполными функциями, которые находятся в разработке "
sudo pacman -Syu  # Обновите и модернизируйте свою работающую систему  
##### brave-nightly-bin ###########
# sudo curl -fsSLo /usr/share/keyrings/brave-browser-nightly-archive-keyring.gpg https://brave-browser-apt-nightly.s3.brave.com/brave-browser-nightly-archive-keyring.gpg
yay -S brave-nightly-bin --noconfirm  # Веб-браузер, который по умолчанию блокирует рекламу и трекеры (ежедневный бинарный выпуск) ; https://aur.archlinux.org/brave-nightly-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://brave.com/download-nightly ; https://aur.archlinux.org/packages/brave-nightly-bin ; Nightly — это ранняя, непроверенная версия с неполными функциями, которые находятся в разработке.
#git clone https://aur.archlinux.org/brave-nightly-bin.git    # (только для чтения, нажмите, чтобы скопировать)
#cd brave-nightly-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf brave-nightly-bin 
#rm -Rf brave-nightly-bin
####### brave-beta-bin ############
# sudo curl -fsSLo /usr/share/keyrings/brave-browser-beta-archive-keyring.gpg https://brave-browser-apt-beta.s3.brave.com/brave-browser-beta-archive-keyring.gpg
# yay -S brave-beta-bin --noconfirm  # Веб-браузер, который по умолчанию блокирует рекламу и трекеры (бета-версия двоичного кода) ; https://aur.archlinux.org/brave-beta-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://brave.com/download-beta ; https://aur.archlinux.org/packages/brave-beta-bin
##### brave-extension-bitwarden-git ###########
# yay -S brave-extension-bitwarden-git --noconfirm  # Расширение браузера Bitwarden (Bitwarden Client) для Brave ; https://aur.archlinux.org/extension-bitwarden-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/bitwarden/clients ; https://aur.archlinux.org/packages/brave-extension-bitwarden-git ; Конфликты: с brave-extension-bitwarden !!!
##### python-adblock ###########
sudo pacman -S --noconfirm --needed python-adblock  # Библиотека Brave AdBlock на Python ; https://github.com/ArniDagur/python-adblock ; https://archlinux.org/packages/extra/x86_64/python-adblock/ ; Оболочка Python для библиотеки блокировки рекламы Brave, написанная на Rust.
brave --version  # Проверьте установку, проверив версию сборки
# yay -Sua  # Обновление Brave
# sudo pacman -Rs brave-bin  # Удалить Brave из Arch
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#########################
# Фонд Brave с открытым исходным кодом основан на публичной лицензии Mozilla Public License (MPL). Это та же лицензия, что и у других продуктов Mozilla, таких как Firefox и Thunderbird. Однако некоторые из включенных расширений браузера, такие как HTTPS Everywhere и Privacy Badger, работают под разными лицензиями с открытым исходным кодом —версиями GNU General Public License (GPL). 
# Установка Brave Browser в Manjaro
# sudo pacman -Syu  # Обновите и модернизируйте свою работающую систему
# sudo pacman -S brave-browser  # установите brave из репозитория Arch с помощью менеджера пакетов Pacman
# sudo pacman -S brave-browser-beta
# brave --version
# sudo pacman -Rncs brave-browser  # Чтобы полностью удалить Brave с вашего компьютера
#----------------------
# sudo pacman -S --needed git && git clone https://aur.archlinux.org/brave-dev-bin.git && cd brave-dev-bin && makepkg -si
# sudo pacman -S --needed git && git clone https://aur.archlinux.org/brave-beta-bin.git && cd brave-beta-bin && makepkg -si
# sudo pacman -S --needed git && git clone https://aur.archlinux.org/brave-nightly-bin.git && cd brave-nightly-bin && makepkg -si
##########################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Яндекс.Браузер (yandex-browser) - Браузер от Яндекс?"
echo -e "${MAGENTA}:: ${BOLD}Яндекс.Браузер — популярный веб-обозреватель от российских разработчиков. Его активно используют не только обладатели операционных систем Windows, но и устанавливают на дистрибутивы, основанные на ядре Linux. Яндекс Браузер — это бесплатный браузер от компании «Яндекс». Программа работает на движке Blink, который также используется в браузере Chromium. Разработчики выпустили версии браузера для Windows, Mac и Linux. Различия между Яндекс Браузером и Chromium незначительные. Яндекс Browser подходит простым пользователям, которые хотят пользоваться браузером с защитой от рекламы, потенциально опасных сайтов и кражи данных. Chromium подойдёт разработчикам веб-браузеров и операционных систем. Яндекс Браузер постепенно набирает популярность даже среди тех, кто пользуется Linux. ${NC}"
echo " Домашняя страница: https://browser.yandex.com/ ; (https://aur.archlinux.org/packages/yandex-browser). "  
echo -e "${MAGENTA}:: ${BOLD}Догое время компания Яндекс занимается разработкой и развитием собственного браузера. ${NC}"
echo " Преимущества Яндекс Браузера для Linux: Безопасность: Yandex Browser защищает данные пользователя и блокирует рекламу. Синхронизация данных с разных устройств. С разрешения пользователя браузер запоминает логины и пароли, банковские карты и синхронизирует закладки между устройствами. Голосовой помощник. Яндекс Алиса быстро находит информацию по голосовому запросу. Пользователь настраивает браузер на свой вкус. Можно выбрать готовый фон из подборки или добавить собственную картинку. В браузер добавлен искусственный интеллект, который: пересказывает видео и страницы; делает перевод видео с иностранного языка; пишет тексты; обрабатывает запрос через картинку; исправляет ошибки в тексте. Доступ к заблокированным ресурсам. Браузер от Яндекса предоставляет доступ к веб-страницам банков и сервисов, которые недоступны в других браузерах или удалены из магазинов приложений. Яндекс для Linux регулярно анонсирует и загружает обновления, а также исправляет ошибки для комфортной работы пользователей. Версия Yandex Browser для системы Линукс имеет незначительные отличия в функционале, если сравнивать с версией для Виндовс, но базовый функционал присутствует в неизменном виде. Иногда дистрибутив ищут на английском языке. В таком случае запрос выглядит следующим образом: Yandex Browser for Linux. " 
echo -e "${CYAN}:: ${NC}Установка Яндекс.Браузер (yandex-browser) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить Yandex.Browser (yandex-browser),   2 - Установить Yandex.Browser (yandex-browser-corporate),  

    0 - НЕТ - Пропустить установку: " in_yandex  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_yandex" =~ [^120] ]]
do
    :
done
if [[ $in_yandex == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_yandex == 1 ]]; then
  echo ""
  echo " Установка Яндекс Browser (yandex-browser) "
sudo pacman -Syy  # обновление баз пакмэна (pacman) 
########### yandex-browser ########
yay -S yandex-browser --noconfirm  # 2024-07-05 08:45 (UTC) ; Веб-браузер от Яндекс.Браузер — это браузер, сочетающий в себе минималистичный дизайн и современные технологии, которые делают работу в Интернете быстрее, безопаснее и проще ; https://aur.archlinux.org/yandex-browser.git (только для чтения, нажмите, чтобы скопировать) ; https://browser.yandex.com/ ; https://aur.archlinux.org/packages/yandex-browser ; Конфликты: с yandex-browser, yandex-browser-stable ; Данный пакет является переcборкой официального пакета для Debian-подобных систем с учётом особенностей Arch-подобных систем. Сопровождающий этого пакета не вносит никаких изменений в браузер. Сопровождающий этого пакета не связан с компанией Яндекс. В случае возникновения ошибок в работе браузера, обращайтесь в официальную техподдержку Яндекс.
#git clone https://aur.archlinux.org/yandex-browser.git   # (только для чтения, нажмите, чтобы скопировать)
#cd yandex-browser
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf yandex-browser 
#rm -Rf yandex-browser
# * (Необязательно) Удалите yandex-browser на Arch с помощью YAY
# yay -Rns yandex-browser
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_yandex == 2 ]]; then
  echo ""
  echo " Установка Яндекс Browser (yandex-browser-corporate) "
sudo pacman -Syy  # обновление баз пакмэна (pacman) 
########### yandex-browser-corporate ########
# Если по ссылке https://repo.yandex.ru/yandex-browser/deb/pool/main/y/yandex-browser-corporate/ есть новая версия, просьба отметить как устаревшим.
# https://repo.yandex.ru/yandex-browser/deb/pool/main/y/yandex-browser-corporate/yandex-browser-corporate_24.6.4.669-1_amd64.deb
yay -S yandex-browser-corporate --noconfirm  # 2024-07-13 19:13 (UTC) ; Веб-браузер от Яндекс.Браузер — это браузер, сочетающий в себе минималистичный дизайн и современные технологии, которые делают работу в Интернете быстрее, безопаснее и проще ; https://aur.archlinux.org/yandex-browser-corporate.git (только для чтения, нажмите, чтобы скопировать) ; https://browser.yandex.com/ ; https://aur.archlinux.org/packages/yandex-browser-corporate ; Конфликты: с yandex-browser, yandex-browser-beta ; Смотрите Зависимости ! 
#git clone https://aur.archlinux.org/yandex-browser-corporate.git   # (только для чтения, нажмите, чтобы скопировать)
#cd yandex-browser-corporate
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf yandex-browser-corporate 
#rm -Rf yandex-browser-corporate
# * (Необязательно) Удалите yandex-browser на Arch с помощью YAY
# yay -Rns yandex-browser-corporate
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
######################
########### yandex-browser-ffmpeg-codecs-update-hook ########
# Похоже, и yandex-browser, и yandex-browser-beta наконец-то разобрались со своими кодеками, так что этот пакет больше не нужен.
# yay -S yandex-browser-ffmpeg-codecs-update-hook --noconfirm  # alpm-hook для автоматического обновления кодеков ffmpeg браузера yandex при обновлении пакета ; https://aur.archlinux.org/yandex-browser-ffmpeg-codecs-update-hook.git (только для чтения, нажмите, чтобы скопировать) ; https://aur.archlinux.org/packages/yandex-browser-ffmpeg-codecs-update-hook ; Конфликты: с yandex-browser-ffmpeg-codecs, yandex-libffmpeg ; Смотрите Зависимости !
########### yandex-browser-ffmpeg-codecs-opera ########
# Этот пакет устарел и не будет поддерживаться. Вместо этого используйте yandex-browser-ffmpeg-codecs-update-hook .
# yay -S yandex-browser-ffmpeg-codecs-opera --noconfirm  # Символическая ссылка на пакет opera-ffmpeg-codecs для использования с yandex-browser ; https://aur.archlinux.org/yandex-browser-ffmpeg-codecs-opera.git (только для чтения, нажмите, чтобы скопировать) ; https://www.archlinux.org/packages/community/x86_64/opera-ffmpeg-codecs/ ; https://aur.archlinux.org/packages/yandex-browser-ffmpeg-codecs-opera ; Конфликты: с yandex-browser-ffmpeg-codecs ; Смотрите Зависимости !
#############################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Midori Browser (midori) - Легковесный браузер?"
echo -e "${MAGENTA}:: ${BOLD}Midori — браузер для Linux, обладающий небольшим количеством базовых функций, но при этом является легковесным и быстрым. Midori Browser — легкий, быстрый и безопасный браузер, который защищает и любит заботиться о вашей конфиденциальности и безопасности ваших данных. Наслаждайтесь тысячами дополнений, блокировщиком рекламы и многим другим. Midori изначально использует код Gecko/Firefox в проекте Floorp Browser. Оба проекта Midori и Floorp сотрудничают для улучшения и предоставления исключительного пользовательского опыта, со значительными различиями. Позже, по мере выпуска обновлений, исходный код будет дифференцирован, но оба проекта продолжат сотрудничать. ${NC}"
echo " Домашняя страница: http://midori-browser.org/ ; (https://aur.archlinux.org/midori.git ; https://aur.archlinux.org/midori-bin.git). "  
echo -e "${MAGENTA}:: ${BOLD}Браузер Midori поддерживает вкладки, управление закладками, управление Cookie, настраиваемый поиск, AdBlock для блокировки рекламы на веб-страницах, жесты мышью и другое. Интерфейс Midori стандартен для браузеров и не должен вызвать никаких сложностей. Девиз Midori Browser — полная конфиденциальность, потому что мы не шпионим за вами, мы не продаем навязчивую рекламу, мы не создаем ваши профили, потому что мы предоставляем вам инструменты, такие как VPN. Мы предоставляем вам лучшую поисковую систему, ориентированную на конфиденциальность, потому что мы ничего не знаем о вас. Мы говорим о полной конфиденциальности, потому что вы являетесь владельцем своей информации. ${NC}"
echo " Облегченный браузер Midori теперь интегрирует облачное хранилище, поэтому вы не используете место на своем устройстве, мы предоставляем вам 15 ГБ бесплатного хранилища. Хотя Midori все еще находится на стадии разработки, он уже интегрирует мощный VPN для защиты вашей конфиденциальности во время просмотра веб-страниц. Midori был создан максимально настраиваемым: вы можете изменять все визуальные аспекты Midori, значки и функции. Поддерживается HTML5 и CSS3. Браузер развивается, разработчики дополняют его новым функционалом и исправляют ошибки. Midori основан на движке WebkitGTK+ и GTK+. Название браузера в переводе с японского означает — зеленый. Midori является браузером по умолчанию в рабочей среде Xfce. Последнюю версию Midori Browser можно загрузить с официального сайта: Astian.org или со страницы релизов Gitlab. "
echo -e "${CYAN}:: ${NC}Установка Midori Browser (midori) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить Midori Browser (midori),    2 - Установить Midori Browser (midori-bin) (ветка Firefox от Astian),  

    0 - НЕТ - Пропустить установку: " in_midori  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_midori" =~ [^120] ]]
do
    :
done
if [[ $in_midori == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_midori == 1 ]]; then
  echo ""
  echo " Установка Midori Browser (midori) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)   
yay -S midori --noconfirm  # Веб-браузер на основе Floorp ; https://aur.archlinux.org/midori.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/goastian/midori-desktop ; https://aur.archlinux.org/packages/midori
# yay -S midori-git --noconfirm  # Веб-браузер на основе Floorp ; https://aur.archlinux.org/midori-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/goastian/midori-desktop ; https://aur.archlinux.org/packages/midori-git ; Конфликты: с midori !!!
######### midori #########
#git clone https://aur.archlinux.org/midori.git   # (только для чтения, нажмите, чтобы скопировать)
#cd midori
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf midori
#rm -Rf midori
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_midori == 2 ]]; then
  echo ""
  echo " Установка  Midori Browser (midori-bin) (ветка Firefox от Astian) "
yay -S midori-bin --noconfirm  # Браузерная ветка Floorp, ветка Firefox от Astian ; https://aur.archlinux.org/midori-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://astian.org/midori-browser/ ; Конфликты: с midori !!!
######### midori-bin #########
#git clone https://aur.archlinux.org/midori-bin.git   # (только для чтения, нажмите, чтобы скопировать)
#cd midori-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf midori-bin 
#rm -Rf midori-bin
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить W3M (w3m) - Консольный браузер?"
echo -e "${MAGENTA}:: ${BOLD}W3M — консольный текстовый браузер, который работает из терминала. Поддерживает вкладки, вывод изображений, открытие локальных html-файлов. ${NC}"
echo " Домашняя страница: https://salsa.debian.org/debian/w3m ; (https://www.archlinux.org/packages/extra/x86_64/w3m/). "  
echo -e "${MAGENTA}:: ${BOLD}W3M (w3m) - является не только веб-браузером но и может служить приложением для просмотра локальных веб-страниц, HTML и текстовых документов (Pagers - функционально аналогичен more, less или most). У веб-браузера имеется множество дополнительных опций, однако они необязательны, достаточно (в качестве опции) задать адрес веб-сайта, например: w3m google.com и жму на кнопку Enter для его запуска. ${NC}"
echo " Основные возможности программы: Поддержка вкладок. Поддержка таблиц. Поддержка закладок. Поддержка стартовой страницы. Большое количество настроек. Поддержка большого количества горячих клавиш. Поддержка мыши. Вывод изображений (если поддерживается эмулятором терминала). Контекстное меню (открывается нажатием правой кнопкой мыши). Поддерживается открытие HTML файлов и текстовых документов. Одной из особенностей данного браузера является поддержка вывода изображений, но работает она не во всех терминалах. Например, в gnome-terminal не работает, в xterm работает. Для поддержки изображений необходимо устанавливать дополнительный пакет w3m-img. Программа переведена на русский язык. " 
echo " w3m – консольный браузер, созданный в 1995 году. В нем реализовано не так много функций, как в аналогичных приложениях. Это базовый набор, содержащий следующие возможности: обработка таблиц и куки, но только опционально; показ изображений на странице (при загрузке встроенного пакета); наличие контекстного меню; возможность одновременной загрузки нескольких вкладок; работа в интерфейсе Emacs; отображение документа, переданного через поток stdin; поддержка работы с мышью через консоли xterm или gpm. В настройке он не нуждается, так как функционал его, как я и говорила, максимально прост. Лишь для отображения изображения необходимо будет использовать не стандартную командную строку «Терминал», а стороннее приложение. Но об этом позже. Целью создания консольных браузеров было обеспечение надежности и конфиденциальности при просмотре информации в сети. Сейчас графические приложения стали куда более безопасными, но и текстовые браузеры до сих пор не потеряли своей актуальности. W3m чаще всего используется в Linux при невозможности загрузки X-сервера. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_w3m  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_w3m" =~ [^10] ]]
do
    :
done
if [[ $in_w3m == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_w3m == 1 ]]; then
  echo ""
  echo " Установка W3M (w3m) - Консольный браузер "
sudo pacman -Syy  # обновление баз пакмэна (pacman)   
sudo pacman -S --noconfirm --needed w3m  # Текстовый веб-браузер, а также пейджер ; https://salsa.debian.org/debian/w3m ; https://archlinux.org/packages/extra/x86_64/w3m/ ; w3m — это пейджер с возможностью WWW. Это пейджер, но его можно использовать как текстовый WWW-браузер.
# Некоторые веб-страницы не очень хорошо работают с w3m, будь то потому, что они используют много javascript или CSS для отображения большей части своего контента. Очень часто вам придется прокручивать несколько страниц, чтобы добраться до начала статьи.
# yay -S rdrview-git --noconfirm  # Инструмент командной строки для извлечения основного контента с веб-страницы ; https://aur.archlinux.org/rdrview-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/eafer/rdrview ; https://aur.archlinux.org/packages/rdrview-git ; Конфликты: с rdrview ; Инструмент командной строки для извлечения основного контента с веб-страницы, как это делает функция "Reader View" большинства современных браузеров. Он предназначен для использования с терминальными RSS-ридерами, чтобы сделать статьи более читаемыми в веб-браузерах, таких как lynx. Код тесно адаптирован из версии Firefox , и ожидается, что вывод будет в основном эквивалентным.
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#######################
# W3m - ArchWiki https://wiki.archlinux.org/title/W3m
# Браузер w3m – настройка и использование - https://tehnichka.pro/about-browser-w3m/
# w3m является не только веб-браузером но и может служить приложением для просмотра локальных веб-страниц, HTML и текстовых документов (Pagers - функционально аналогичен more, less или most). У веб-браузера имеется множество дополнительных опций, однако они необязательны, достаточно (в качестве опции) задать адрес веб-сайта, например: w3m https://pingvinus.ru
# w3m имеет множество настроек, задать параметры можно правкой конфигурационных файлов (располагаются в каталоге ~/.w3m) и из диалога настройки. Для более удобного использования веб-браузера (запуска без ввода адреса веб-сайта) ему можно задать "Домашнюю страницу", для этого нужно в файле:
# ~/.bash_aliases
# Добавить алиас (встроенную команду): alias w3m='w3m адрес-сайта.ru'
##### Некоторые базовые горячие клавиши при работе с w3m #######
# Управлять браузером можно полностью с клавиатуры:
# Shift+H — вывести список поддерживаемых горячих клавиш.
# o — открыть настройки.
# Tab — перемещение курсора по ссылкам на странице.
# Enter — перейти по ссылке.
# Shift+U — открыть адресную строку для ввода URL.
# Shift+B — переход назад.
# Shift+T — открыть новую вкладку.
# Shift+[ и Shift+] — переключение между вкладками.
###################################################

clear
echo -e "${MAGENTA}
  <<< Установка утилит (пакетов) BitTorrent-клиентов в Archlinux >>> ${NC}"
# Installing BitTorrent client utilities (packages) in Archlinux
#clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Transmission (transmission-gtk transmission-cli) - Бесплатный клиент BitTorrent (GTK+ GUI)?" 
echo -e "${CYAN}:: Предисловие! ${NC}Transmission разработан для простого и мощного использования. Мы установили значения по умолчанию, чтобы они просто работали, и требуется всего несколько щелчков, чтобы настроить расширенные функции, такие как просмотр каталогов, списки блокировки плохих пиров и веб-интерфейс. Обе версии GUI, transmission-gtk и transmission-qt , могут функционировать автономно без формального внутреннего демона. Версии GUI настроены на работу из коробки, но пользователь может захотеть изменить некоторые настройки. Путь по умолчанию к файлам конфигурации GUI — ~/.config/transmission. Руководство по параметрам конфигурации можно найти на Github (https://github.com/transmission/transmission/blob/main/docs/Editing-Configuration-Files.md) Transmission. (https://transmissionbt.com/ ; https://transmissionbt.ru/download.html); Transmission (https://wiki.archlinux.org/title/Transmission) "
echo -e "${MAGENTA}:: ${BOLD}Transmission — это BitTorrent клиент для Linux с простым и удобным интерфейсом. ${NC}"
echo -e "${MAGENTA}=> ${NC}Transmission является одной из самых простых в использовании программ для скачивания торрентов. Программа проста в обращении и не вызовет сложностей даже у новичков. Позволяет скачивать и создавать торренты, управлять скоростью приема и передачи, выставлять приоритеты. При скачивании торрентов можно сделать выборочное скачивание, то есть указать какие файлы или папки необходимо загрузить. (😃)"
echo " Настройка Transmission выполняется в едином окне. Так же можно выполнить настройки каждой отдельной раздачи. Transmission может работать в качестве демона в фоновом режиме и запускаться из командной строки. Программа доступна с интерфейсами основанными на GTK (пакет transmission-gtk) и на Qt (пакет transmission-qt). " 
echo -e "${YELLOW}:: Примечание! ${NC}Функции: В отличие от других клиентов, Transmission уникально поддерживает встроенные системы, такие как NAS, персональные серверы, HTPC и Raspberry Pi. Поддержка плагина Kodi отличает Transmission от остальных существующих клиентов BitTorrent, и поддержка RSS-каналов здесь тоже является преимуществом. Плюсы: Полнофункциональный клиент; Кроссплатформенная совместимость; Чистый интерфейс; Специальное приложение для встроенных устройств. Минусы: Не хватает встроенной поисковой системы; Нет поддержки прокси-сервера. "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_transmission  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_transmission" =~ [^10] ]]
do
    :
done 
if [[ $i_transmission == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_transmission == 1 ]]; then
  echo ""  
  echo " Установка BitTorrent-клиента Transmission (GTK+) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)   
sudo pacman -S --noconfirm --needed transmission-gtk transmission-cli  # Быстрый, простой и бесплатный клиент BitTorrent (GTK+ GUI), Быстрый, простой и бесплатный клиент BitTorrent (инструменты CLI, демон и веб-клиент); http://www.transmissionbt.com/ ; https://archlinux.org/packages/extra/x86_64/transmission-gtk/ ; https://archlinux.org/packages/extra/x86_64/transmission-cli/
#sudo pacman -S --noconfirm --needed transmission-qt transmission-cli  # графический интерфейс Qt 5, и демон, с CLI ; http://www.transmissionbt.com/; https://archlinux.org/packages/extra/x86_64/transmission-qt/ ; https://archlinux.org/packages/extra/x86_64/transmission-cli/
#sudo pacman -S --noconfirm --needed transmission-remote-gtk transmission-cli  # графический интерфейс GTK 3 для демона, и демон, с CLI 
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
# ------------------------------------
# Transmission-cli - демон с интерфейсами CLI и веб-клиента ( http: // localhost: 9091 ).
# Transmission-remote-cli - Интерфейс Curses для демона.
# Transmission-gtk - пакет GTK + 3.
# Transmission-qt - пакет Qt5.
# Transmission-remote-gtk - Графический интерфейс GTK 3
####################################

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить qBittorrent (qbittorrent) - Усовершенствованный клиент BitTorrent (Qt)?" 
echo -e "${CYAN}:: Предисловие! ${NC}С появлением скоростного интернета и различных стриминговых сервисов торренты теряют свою привлекательность, но они все ещё остаются актуальными для загрузки образов операционных систем (https://www.qbittorrent.org/ ; https://archlinux.org/packages/extra/x86_64/qbittorrent/ ; https://wiki.archlinux.org/title/QBittorrent) "
echo -e "${MAGENTA}:: ${BOLD}qBittorrent - это один из самых популярных свободных торрент клиентов с открытым исходным кодом для Linux. Программа поддерживает такие платформы, как Linux, Windows, MacOS и FreeBSD. Написан на С++ с использованием библиотеки QT и потому кроссплатформенный. Интерфейс программы напоминает uTorrent, зато здесь нет рекламы и поддерживаются такие BitTorrent расширения как DHT, peer exchange и полное шифрование. Кроме того, программой можно пользоваться через веб-интерфейс удаленно. ${NC}"
echo -e "${MAGENTA}=> ${NC}Среди явных особенностей qBittorrent хочу отметить его сходство с аналогичными клиентами для ОС Microsoft Windows: µTorrent и BitTorrent. Сходство не случайное, потому что qBittorrent также функционален и быстр как его аналоги. (😃)"
echo " Главное окно программы содержит список торрентов, представленный в виде таблицы. Колонки таблицы можно включать и отключать. Слева расположены категории для фильтрации. При нажатии на какой-либо торрент из списка можно просматривать различную статистику. Сверху расположена горизонтальная панель управления с кнопками и меню программы. " 
echo -e "${YELLOW}:: Примечание! ${NC}Функции: Хорошо адаптированный и расширяемый механизм поиска Search Engine; Одновременный поиск на большинстве известных поисковых сайтах системы BitTorrent; Возможность поиска по заданным категориям (e.g. Books(Книги), Music(Музыка), Movies(Фильмы)); Поддержка всех расширений Bittorrent; DHT, Peer Exchange, полное шифрование, Magnet/BitComet URIs, и т.д.; Возможность удаленного управления через веб-интерфейс; Практически идентичный пользовательский интерфейс полностью написанный на Ajax; Продвинутое управление трекерами, peerами и torrent-файлами; Постановка в очередь и установка приоритетов торрентов; Возможность выбора содержимого и установка приоритетов для скачивания; Поддержка перенаправления портов, используя UPnP / NAT-PMP; Доступен на приблизительно 25-ти языках (поддержка Unicode); Создание торрент-файлов; Продвинутая поддержка RSS с учетом фильтров на скачивание (включая регулярные выражения); Планировщик (scheduler) скорости скачивания/раздачи; IP-фильтрация (совместимость с eMule и PeerGuardian); IPv6 поддерживается. Ну и конечно он совершенно бесплатен! А это значит, что в его интерфейсе вы не встретите никакой нервирующей рекламы и все рабочее пространство будет отображать процессы загрузки/раздачи файлов. Лицензия: GNU GPL v2 . Приложение переведено на русский язык. "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_qbittorrent  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_qbittorrent" =~ [^10] ]]
do
    :
done 
if [[ $i_qbittorrent == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_qbittorrent == 1 ]]; then
  echo ""  
  echo " Установка BitTorrent-клиента qBittorrent (Qt) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)   
sudo pacman -S --noconfirm --needed qbittorrent  # Расширенный клиент BitTorrent, написанный на C++, на основе инструментария Qt и libtorrent-rasterbar ; https://www.qbittorrent.org/ ; https://archlinux.org/packages/extra/x86_64/qbittorrent/ ; клиент для обмена файлами в P2P сетях.
#sudo pacman -S --noconfirm --needed qbittorrent-nox  # Расширенный клиент BitTorrent, написанный на C++, на основе инструментария Qt и libtorrent-rasterbar, без графического интерфейса ; https://www.qbittorrent.org/ ; https://archlinux.org/packages/extra/x86_64/qbittorrent-nox/
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
####### Справка ########
# Файл конфигурации создается при ~/.config/qBittorrent/qBittorrent.conf первом запуске программы.
# Если вы установите qbittorrent-nox , вы получите шаблон юнита systemd qbittorrent-nox@.service. QBittorrent будет работать от имени определенного пользователя, если вы включите/запустите , см. также [1] . qbittorrent-nox@username.service
# QBittorrent будет запущен от имени пользователя username. Папкой загрузки по умолчанию будет каталог пользователя Downloads, но это можно будет перенастроить позже.
# Если вы запускаете его как доступную службу, создайте пользователя с именем qbittorrent и запустите его под этим именем, а также перезапустите службу при выходе, так как в программе есть кнопка выхода.
# Для изменения настроек (например, порта) можно добавить переменную окружения (для порта это QBT_WEBUI_PORT), используя файл drop-in для его systemd unit. Запустите, qbittorrent-nox --helpчтобы узнать больше о других переменных окружения (эта информация не указана в руководстве).
# По умолчанию qBittorrent будет прослушивать все интерфейсы на порту 8080. Таким образом, он доступен по адресу http://HOST_IP:8080.
# Примечание: HTTPS по умолчанию не включен, поэтому https://HOST_IP:8080недоступен.
# Разрешить доступ без имени пользователя и пароля:
# В домашней среде часто желательно разрешить доступ к веб-интерфейсу без ввода имени пользователя и пароля. Это можно настроить в самом веб-интерфейсе после входа с использованием имени пользователя и пароля по умолчанию.
# Либо, чтобы избежать входа в систему в первый раз, добавьте этот раздел в ~/.config/qBittorrent/qBittorrent.conf:
# [Preferences]
# WebUI\AuthSubnetWhitelist=192.168.1.0/24
# WebUI\AuthSubnetWhitelistEnabled=true
# WebUI\UseUPnP=false
# Вышеуказанные элементы конфигурации будут:
# Разрешить клиентам, входящим в систему с адреса 192.168.1.x, получать доступ к веб-интерфейсу без необходимости ввода имени пользователя и пароля.
# Отключите UPnP для веб-интерфейса, чтобы веб-интерфейс не был доступен из-за пределов сети.
# После этого перезагрузите qbittorrent-nox@username.service.
# Обратитесь к вики qbittorrent : https://github.com/qbittorrent/qBittorrent/wiki/NGINX-Reverse-Proxy-for-Web-UI ; https://wiki.archlinux.org/title/QBittorrent
# Список известных тем qBittorrent: https://github.com/qbittorrent/qBittorrent/wiki/List-of-known-qBittorrent-themes
# Как использовать пользовательские темы пользовательского интерфейса - https://github.com/qbittorrent/qBittorrent/wiki/How-to-use-custom-UI-themes
#####################################

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Deluge (deluge) - BitTorrent-клиент (GTK)?" 
echo -e "${CYAN}:: Предисловие! ${NC}Deluge — полнофункциональный клиент BitTorrent для Linux, OS X, Unix и Windows. Он использует libtorrent в своем бэкэнде и имеет несколько пользовательских интерфейсов, включая: GTK+, веб и консоль. Он был разработан с использованием клиент-серверной модели с демон-процессом, который обрабатывает всю активность BitTorrent. Демон Deluge может работать на машинах без монитора, а пользовательские интерфейсы могут подключаться удаленно с любой платформы. (https://deluge-torrent.org/ ; https://archlinux.org/packages/extra/any/deluge/); Deluge (https://wiki.archlinux.org/title/Deluge) "
echo -e "${MAGENTA}:: ${BOLD}Deluge — это полнофункциональное приложение BitTorrent, написанное на Python 3. Оно обладает множеством функций, включая, помимо прочего: модель клиент/сервер, поддержку DHT, magnet-ссылки, систему плагинов, поддержку UPnP, полнопотоковое шифрование, поддержку прокси и три различных клиентских приложения. Когда серверный демон запущен, пользователи могут подключаться к нему через консольный клиент, графический интерфейс на основе GTK или веб-интерфейс. Полный список функций можно просмотреть здесь (https://dev.deluge-torrent.org/wiki/About). ${NC}"
echo -e "${MAGENTA}=> ${NC}Deluge обладает богатой коллекцией плагинов; фактически, большая часть функциональности Deluge доступна в виде плагинов. Deluge был создан с намерением быть легким и ненавязчивым. Мы считаем, что загрузка не должна быть основной задачей на вашем компьютере и, следовательно, не должна монополизировать системные ресурсы. (😃)"
echo " Deluge не предназначен для какой-либо одной среды рабочего стола и будет отлично работать в GNOME, KDE, XFCE и других. Deluge является свободным программным обеспечением и распространяется по лицензии GNU General Public License . " 
echo -e "${YELLOW}:: Примечание! ${NC}Функции: Deluge обладает широким спектром функций, включая: Разделение ядра и пользовательского интерфейса позволяет Deluge работать как демон. Веб-интерфейс: Пользовательский интерфейс консоли; GTK+ пользовательский интерфейс. Шифрование протокола BitTorrent: Основная линия DHT; Локальное обнаружение одноранговых сетей (также известное как LSD); Расширение протокола FAST; Пиринговый обмен µTorrent; UPnP и NAT-PMP; Поддержка прокси; Частные торренты; Глобальные и торрент-лимиты скорости; Настраиваемый планировщик пропускной способности; Защита паролем; RSS (через плагин)... И многое другое! "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_deluge  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_deluge " =~ [^10] ]]
do
    :
done 
if [[ $i_deluge  == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_deluge  == 1 ]]; then
  echo ""  
  echo " Установка BitTorrent-клиента Deluge (GTK) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)   
sudo pacman -S --noconfirm --needed deluge  # Клиент BitTorrent с несколькими пользовательскими интерфейсами в модели клиент/сервер ; https://deluge-torrent.org/ ; https://archlinux.org/packages/extra/any/deluge/
# sudo pacman -S --noconfirm --needed deluge-gtk  # GTK UI для Deluge ; https://deluge-torrent.org/ ; https://archlinux.org/packages/extra/any/deluge-gtk/ ; Заменяет: deluge<2.0.4.dev23+g2f1c008a2-2 ; Обязательно прочтите и установите необязательные зависимости для клиента gtk deluge-gtk, чтобы включить уведомления рабочего стола и уведомления appindicator.
# sudo pacman -Rcns deluge
# deluge -v
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
####### Справка ########
# https://wiki.archlinux.org/title/Deluge
########################

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить KTorrent (ktorrent) — клиент BitTorrent для KDE (Qt)?" 
echo -e "${CYAN}:: Предисловие! ${NC}Чтобы иметь возможность отображать любую информацию о файлах, сидах, личере и текущих трекерах, установите дополнительную зависимость geoip (https://archlinux.org/packages/extra/x86_64/geoip/). Рекомендуется включить DHT в настройках, чтобы избежать низкой скорости и малого количества сидов. (https://apps.kde.org/ktorrent/ ; https://archlinux.org/packages/extra/x86_64/ktorrent/); KTorrent (https://wiki.archlinux.org/title/Ktorrent) "
echo -e "${MAGENTA}:: ${BOLD}KTorrent — это приложение BitTorrent от KDE, которое позволяет загружать файлы с использованием протокола BitTorrent. Оно позволяет запускать несколько торрентов одновременно и поставляется с расширенными функциями, что делает его полнофункциональным клиентом для BitTorrent. ${NC}"
echo -e "${MAGENTA}=> ${NC}Примечание: По умолчанию программа может не загружать торренты с «rutracker». Для решения этой проблемы можно прописать прокси в настройках. (😃)"
echo " Поддерживает все основные возможности по скачиванию торрентов. " 
echo -e "${YELLOW}:: Примечание! ${NC}Функции: Очередь торрентов; Глобальные и индивидуальные ограничения скорости торрентов; Предварительный просмотр определенных типов файлов, встроенный (видео и аудио); Импорт частично или полностью загруженных файлов; Приоритет файлов для многофайловых торрентов; Выборочная загрузка многофайловых торрентов; Выкидывать/банить пиров с помощью дополнительного диалогового окна IP-фильтра для целей составления списка/редактирования; Поддержка UDP-трекера; Поддержка приватных трекеров и торрентов; Поддержка обмена пиринговыми данными µTorrent; Поддержка шифрования протокола (совместимо с Azureus); Поддержка создания торрентов без трекеров; Поддержка распределенных хеш-таблиц (DHT, основная версия); Поддержка UPnP для автоматической переадресации портов в локальной сети с динамически назначаемыми хостами; Поддержка веб-сидов; Интеграция в системный трей; Поддержка аутентификации трекера; Подключение через прокси; Помимо встроенных функций, для KTorrent доступны некоторые плагины... И многое другое! "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_ktorrent  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_ktorrent " =~ [^10] ]]
do
    :
done 
if [[ $i_ktorrent  == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_ktorrent  == 1 ]]; then
  echo ""  
  echo " Установка KTorrent — клиент BitTorrent для KDE (Qt) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)   
sudo pacman -S --noconfirm --needed geoip # Библиотека и утилиты для преобразования IP-адресов стран без DNS на языке C ; https://www.maxmind.com/app/c ; https://archlinux.org/packages/extra/x86_64/geoip/
sudo pacman -S --noconfirm --needed geoip-database  # База данных стран GeoIP (на основе данных GeoLite2, созданных MaxMind) ; https://mailfud.org/geoip-legacy/ ; https://archlinux.org/packages/extra/any/geoip-database/
# sudo pacman -S --noconfirm --needed geoip-database-extra  # Базы данных GeoIP legacy city/ASN (на основе данных GeoLite2, созданных MaxMind) ; https://mailfud.org/geoip-legacy/ ; https://archlinux.org/packages/extra/any/geoip-database-extra/
sudo pacman -S --noconfirm --needed ktorrent  # Мощный клиент BitTorrent для KDE ; https://apps.kde.org/ktorrent/ ; https://archlinux.org/packages/extra/x86_64/ktorrent/ ; https://pingvinus.ru/program/ktorrent
# yay -S ktorrent-git --noconfirm  # Мощный клиент BitTorrent. (Версия GIT) ; https://aur.archlinux.org/ktorrent-git.git (только для чтения, нажмите, чтобы скопировать) ; https://apps.kde.org/ktorrent ; https://aur.archlinux.org/packages/ktorrent-git ; Конфликты: с ktorrent ; Требуется [kde-unstable], пока kf6 не попал в [extra]
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
####### Справка ########
# KTorrent — клиент BitTorrent для KDE  https://wiki.archlinux.org/title/Ktorrent
# Невозможно увидеть некоторые инструменты нижней панели.
# Чтобы иметь возможность отображать любую информацию о файлах, сидах, личере и текущих трекерах, установите дополнительную зависимость geoip . Рекомендуется включить DHT в настройках, чтобы избежать низкой скорости и малого количества сидов.
# Скрипт для управления в командной строке
# Поскольку KTorrent — это приложение только с графическим интерфейсом, к счастью, у него есть интерфейс DBUS, поэтому вы можете использовать скрипты для управления им в командной строке (т. е. из SSH). Подробности см. в следующем ответе на форуме linuxquestions (https://www.linuxquestions.org/questions/linux-software-2/terminal-commands-for-ktorrent-4175441715/#post4851070).
#########################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Vuze - Azureus (vuze) - Продвинутый BitTorrent-клиент?"
echo -e "${MAGENTA}:: ${BOLD}Vuze (ранее Azureus) - чрезвычайно мощный и настраиваемый BitTorrent-клиент. Поиск и загрузка торрент-файлов. Воспроизводите, конвертируйте и перекодируйте видео и музыку для воспроизведения на многих устройствах, таких как PSP, Iso, XBox, PS3, iTunes (iPhone, ipad, Apple TV). Vuze свободное кроссплатформенное программное обеспечение для работы с файлообменными сетями по протоколу BitTorrent с поддержкой анонимного обмена данными по протоколам I2P, Tor и Nodezilla. Написан на языке Java. Функции графической оболочки выполняет библиотека SWT. Программа поддерживает все основные функции присущие Torrent-клиентам. Помимо этого поддерживается проигрывание медиа файлов прямо из программы (встроенный медиа-плеер, 1080p), есть встроенный поиск торрентов с различных ресурсов, поддерживаются различные механизмы для ускоренной загрузки торрентов. Обладает множеством разнообразных функций и возможностями по управлению заданиями. ${NC}"
echo " Домашняя страница: http://www.vuze.com/ ; (http://plugins.vuze.com/ ; https://aur.archlinux.org/packages/vuze). "  
echo -e "${MAGENTA}:: ${BOLD}Vuze позволяет перемещать или проигрывать медиа-файлы (посредством видео-потока) на различных устройствах (iPhone, iPod, iPad, Xbox 360, Playstation 3, PSP и TiVo). Достаточно просто перетащить файл мышкой на соответсвующий пункт меню в программе. Также программой можно управлять удаленно с Android устройства. Для этого существует специальное приложение — Vuze Remote. Разработчики считают, что это (цитата) "самое мощное в мире приложение для битторентовых сетей". Программа написана на языке Java и может работать в Linux, Windows и MacOS. ${NC}"
echo " Среди возможностей можно отметить: определение скоростных ограничений на закачку, как для одного потока, так и для всех одновременно; продвинутые правила отбора; настройка дискового кэша; использование одного порта для всех потоков; возможность использования прокси для Tracker и Peer коммуникаций; быстрое восстановление прерванной загрузки; поддержка шифрации трафика для обхода защиты провайдеров, которые блокирует всю деятельность P2P сетей; возможность параллельного запуска нескольких копий для полной загрузки канала; удобный, настраиваемый пользовательский интерфейс; IRC плагин для быстрой помощи; мощная система организации доступа к файлам; многочисленные плагины, призванные существенно облегчить индивидуальную настройку программы. Полный перечень возможностей доступен на официальной странице программы (http://www.vuze.com/). Для запуска потребуется установить Java. " 
echo -e "${CYAN}:: ${NC}Установка Vuze - Azureus (vuze) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_vuze  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_vuze" =~ [^10] ]]
do
    :
done
if [[ $in_vuze == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_vuze == 1 ]]; then
  echo ""
  echo " Установка Vuze - Azureus (vuze) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
######## vuze ###########
yay -S vuze --noconfirm  # Многофункциональный клиент BitTorrent на базе Java (ранее назывался «Azureus») ; https://aur.archlinux.org/vuze.git  (только для чтения, нажмите, чтобы скопировать) ; https://sourceforge.net/projects/azureus/ ; https://aur.archlinux.org/packages/vuze ; Смотрите Зависимости! Для запуска потребуется установить Java.
#git clone https://aur.archlinux.org/vuze.git   # (только для чтения, нажмите, чтобы скопировать)
#cd vuze
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf vuze 
#rm -Rf vuze
######## vuze-extreme-mod ###########
# yay -S vuze-extreme-mod --noconfirm  # Модифицированная версия клиента Vuze BitTorrent с возможностью множественной подмены ; https://aur.archlinux.org/vuze-extreme-mod.git (только для чтения, нажмите, чтобы скопировать) ; http://www.sb-innovation.de/f41/ ; https://aur.archlinux.org/packages/vuze-extreme-mod ; http://downloads.sourceforge.net/azureus/vuze/Vuze_5750/Vuze_5750_linux.tar.bz2 ; http://www.sb-innovation.de/attachments/f41/17559d1488493507-vuze-extreme-mod-sb-innovation-5-7-5-0-vpem_5750-00.zip
######## vuze-plugin-mldht ###########
yay -S vuze-plugin-mldht --noconfirm  # Плагин для альтернативной реализации распределенной хэш-таблицы (DHT), используемой µTorrent ; https://aur.archlinux.org/vuze-plugin-mldht.git (только для чтения, нажмите, чтобы скопировать) ; http://plugins.vuze.com/details/mlDHT ; https://aur.archlinux.org/packages/vuze-plugin-mldht ; http://plugins.vuze.com/plugins/mlDHT_1.5.9.jar
######## vuze-plugin-countrylocator ###########
yay -S vuze-plugin-countrylocator --noconfirm  # Плагин для включения флагов стран на вкладке «Пирсы» ; https://aur.archlinux.org/vuze-plugin-countrylocator.git (только для чтения, нажмите, чтобы скопировать) ; http://plugins.vuze.com/details/CountryLocator ; https://aur.archlinux.org/packages/vuze-plugin-countrylocator ; http://plugins.vuze.com/plugins/CountryLocator_1.8.9.jar
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############## Справка ###########
# Vuze (Azureus) - http://www.vuze.com/ 
#  Plugins - http://plugins.vuze.com/ 
###### Установка из архива ##########
# Для запуска потребуется установить Java.
# Я скачал с официального сайта архив с программой
# https://sourceforge.net/projects/azureus/
# wget https://downloads.sourceforge.net/azureus/vuze/Vuze_5760/Vuze_5760_linux.tar.bz2
# Далее необходимо его распаковать, для этого выполняем команду:
# Vuze_5760_linux.tar  (На момент написания) (можно переименовать в archive.tar)
# tar xvjf archive.tar.bz2
# tar xvjf archive.tar
# Перейти в директорию, в которую был распакован архив
# cd vuze
# И выполнить файл vuze:
# ./vuze
#######################

clear
echo "" 
echo -e "${BLUE}:: ${NC}Установить Tixati (tixati) — Torrent-клиент?" 
echo -e "${CYAN}:: Предисловие! ${NC}Установка Tixati (tixati) проходит через сборку из исходников. То есть установка производиться с помощью git clone (https://aur.archlinux.org/tixati.git), PKGBUILD, makepkg - скачивается с сайта 'Arch Linux - AUR' (https://aur.archlinux.org/packages/tixati) - собирается и устанавливается. (😃)"
echo -e "${MAGENTA}:: ${BOLD}Tixati — бесплатный torrent-клиент для Linux. Разработчики заявляют, что программа использует ультра-быстрые алгоритмы для загрузки торрентов и сверхэффективный выбор пиров. Поддерживаются необходимые функции для управления загрузками — изменение приоритета закачек, изменение скорости скачивания. Для каждого Torrent’а можно просмотреть множество дополнительной информации: скорость, различные графики, подробный список пиров и так далее. ${NC}"
echo -e "${MAGENTA}=> ${NC}Tixati — это новая и мощная P2P-система. Программа поддерживает Magnet, DHT и PEX ссылки. Программа доступна для Linux и Windows. Также есть Portable версия, которая может запускаться с внешнего носителя (с флешки) без установки. Tixati не переведена на русский язык, но интерфейс не должен вызвать каких-либо сложностей. "
echo " 100% бесплатная, простая и удобная в использовании Bittorrent-клиент; (https://www.tixati.com/). " 
echo -e "${YELLOW}:: Примечание! ${NC}Функции: Tixati намного лучше остальных: Простота и удобство использования. Сверхбыстрые алгоритмы загрузки. Поддержка DHT, PEX и Magnet Link. Простая и быстрая установка — без Java и .net. Сверхэффективный выбор одноранговых узлов и блокировка. Шифрование соединения RC4 для дополнительной безопасности. Подробное управление пропускной способностью и построение графиков. UDP-подключения одноранговых узлов и устранение неполадок в маршрутизаторе NAT. Расширенные функции, такие как RSS, фильтрация IP-адресов, планировщик событий. НЕ СОДЕРЖИТ шпионских программ и рекламы (ОТСУТСТВИЕ ерунды)! Как настроить программу - (на English) https://www.tixati.com/optimize/ "
echo -e "${CYAN}:: ${NC}Установка Tixati (tixati) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! " 
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_tixati  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_tixati " =~ [^10] ]]
do
    :
done 
if [[ $i_tixati  == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_tixati  == 1 ]]; then
  echo ""  
  echo " Установка Tixati Torrent-клиент "
sudo pacman -Syy  # обновление баз пакмэна (pacman)   
yay -S tixati --noconfirm  # Tixati - это программа для однорангового обмена файлами, использующая популярный протокол BitTorrent ; https://aur.archlinux.org/tixati.git (только для чтения, нажмите, чтобы скопировать) ; http://www.tixati.com/ ; https://aur.archlinux.org/packages/tixati ; https://www.tixati.com/news/
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
####### Справка ########
# Tixati можно легко перевести на другие языки, используя простой языковой файл, который представляет собой текстовый файл, содержащий ключевые фразы и их переведенные эквиваленты.
# Языковой файл можно загрузить, нажав главную кнопку «Справка» и выбрав «Переключить язык» в меню.
# Чтобы найти языковые файлы или разместить свои собственные, посетите форум языков . 🔍 (https://support.tixati.com/language)(https://forum.tixati.com/languages)
# Русский перевод - Вариант "истинно русский"  https://forum.tixati.com/languages/4
# Сначала загрузите прикрепленный файл .txt по ссылке выше
# 1) Обновите до последней версии
# 2) В главном окне нажмите на знак вопроса «?» -> Switch Language ( Переключить язык).
# 3) Нажмите на иконку папки и выберите файл Tixati-ru-poehali.txt (это же надо сделать для обновления перевода из изменённого файла)
# 4) Перезапустите Tixati
# Более полное описание перевода и его мотивации можно найти на форуме русскоязычного трекера (начиная с Ru, заканчивая tracker) в теме: «Tixati - продвинутый клиент для Windows и Linux», страница 9 (опубликовано всего несколько минут назад)
# Настраиваем Tixati: Как настроить программу - (на English) https://www.tixati.com/optimize/
#########################

clear
echo -e "${MAGENTA}
  <<< Установка Программ для обмена мгновенными сообщениями (IM-месенджеры для Linux) в Archlinux >>> ${NC}"
# Installing Instant messaging Software (IM messengers for Linux) in Archlinux
# clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Pidgin (pidgin) - Клиент обмена сообщениями (мессенджер)?"
#echo -e "${BLUE}:: ${NC}Установить Pidgin (pidgin) - Клиент обмена сообщениями (мессенджер)?"
#echo 'Установить Pidgin (pidgin) - Клиент обмена сообщениями (мессенджер)?'
# Install Pidgin (pidgin) - Messaging Client (messenger)?
echo -e "${MAGENTA}:: ${BOLD}Pidgin (Мессенджер) - Многопротокольный клиент обмена мгновенными сообщениями. Pidgin — универсальный модульный Instant Messaging (IM) клиент для Linux. Один из самых популярных IM-месенджеров. Pidgin поддерживает большое количество протоколов. Изначально Pidgin назывался Gaim. ${NC}"
echo " Домашняя страница: https://www.pidgin.im/ ; (https://pidgin.im/ ; https://archlinux.org/packages/extra/x86_64/pidgin/) "
echo -e "${CYAN}:: ${NC}Pidgin - это чат-программа, которая позволяет вам одновременно входить в учетные записи в нескольких чат-сетях. Это означает, что Вы можете общаться с друзьями на XMPP и сидеть в IRC-канале одновременно."
echo " Модульный клиент мгновенного обмена сообщениями на основе библиотеки libpurple. Поддерживает наиболее популярные протоколы. Распространяется на условиях GNU General Public License. Позволяет сохранять комментарии к пользователям из контакт‐листа. Может объединять несколько контактов в один метаконтакт. "
echo " Возможности - Поддерживаемые протоколы: Jabber/XMPP; Bonjour; Gadu-Gadu; IRC; Novell GroupWise Messenger; Lotus Sametime; SILC; SIMPLE; Zephyr; Поддержку дополнительных протоколов можно подключить с помощью плагинов. С версии 2.12.0 удалена поддержка протоколов: MSN, MySpace, Mxit, Yahoo. Клиент имеет модульную структуру и позволяет одним кликом мыши подключать и отключать модули (плагины). Исходный код: Open Source (открыт); Языки программирования: C; Библиотеки: GTK; Лицензия: GNU GPL; Приложение переведено на русский язык. "
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " prog_chat  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_chat" =~ [^10] ]]
do
    :
done
if [[ $prog_chat == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $prog_chat == 1 ]]; then
  echo ""
  echo " Установка Pidgin (pidgin) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
# sudo pacman -S --noconfirm --needed pidgin pidgin-hotkeys pidgin-otr # Клиент обмена мгновенными сообщениями ; 
sudo pacman -S --noconfirm --needed pidgin  # Клиент обмена мгновенными сообщениями ; https://www.pidgin.im/ ; https://pidgin.im/ ; https://archlinux.org/packages/extra/x86_64/pidgin/
sudo pacman -S --noconfirm --needed pidgin-hotkeys  # Плагин Pidgin, позволяющий определять глобальные горячие клавиши ; http://pidgin-hotkeys.sourceforge.net ; https://archlinux.org/packages/extra/x86_64/pidgin-hotkeys/
######### Плагины ############
sudo pacman -S --noconfirm --needed pidgin-otr  # Плагин для обмена сообщениями Off-the-Record для Pidgin ; https://www.cypherpunks.ca/otr/ ; https://archlinux.org/packages/extra/x86_64/pidgin-otr/
sudo pacman -S --noconfirm --needed libpurple  # Библиотека IM, извлеченная из Pidgin ; https://pidgin.im/ ; https://archlinux.org/packages/extra/x86_64/libpurple/
sudo pacman -S --noconfirm --needed libpurple-lurch  # Плагин для libpurple (Pidgin, Adium и т.д.), реализующий OMEMO (используя axolotl) ; https://github.com/gkdr/lurch ; https://archlinux.org/packages/extra/x86_64/libpurple-lurch/
sudo pacman -S --noconfirm --needed pidgin-talkfilters  # Реализует GNU talkfilters в чатах pidgin ; https://keep.imfreedom.org/pidgin/purple-plugin-pack/ ; https://archlinux.org/packages/extra/x86_64/pidgin-talkfilters/
sudo pacman -S --noconfirm --needed pidgin-kwallet  # Плагин KWallet для Pidgin ; https://www.linux-apps.com/content/show.php/Pidgin+KWallet+Plugin?content=127136 ; https://archlinux.org/packages/extra/x86_64/pidgin-kwallet/
sudo pacman -S --noconfirm --needed pidgin-xmpp-receipts  # Этот плагин pidgin реализует уведомления о доставке сообщений XMPP (XEP-0184) ; https://devel.kondorgulasch.de/pidgin-xmpp-receipts/ ; https://archlinux.org/packages/extra/x86_64/pidgin-xmpp-receipts/
  echo " Установка утилит (пакетов) чтобы весь ваш текст не отображался как неправильный "
sudo pacman -S --noconfirm --needed aspell  # Проверка орфографии, призванная в конечном итоге заменить Ispell ; http://aspell.net/ ; https://archlinux.org/packages/extra/x86_64/aspell/
sudo pacman -S --noconfirm --needed purple-plugin-pack  # Плагины для libpurple и производных клиентов обмена мгновенными сообщениями ; Он позволяет переключаться между несколькими языками ; https://keep.imfreedom.org/pidgin/purple-plugin-pack ; https://archlinux.org/packages/extra/x86_64/purple-plugin-pack/
######### Минимальная версия Pidgin #############
# yay -S pidgin-mini --noconfirm  # Минимальная версия Pidgin для здравомыслящих пользователей XMPP/IRC ; https://aur.archlinux.org/pidgin-mini.git (только для чтения, нажмите, чтобы скопировать) ; http://pidgin.im/ ; https://aur.archlinux.org/packages/pidgin-mini; Конфликты: с libpurple, pidgin
##########  pidgin-extprefs ###############
yay -S pidgin-extprefs --noconfirm  # Плагин добавляет дополнительные настройки для pidgin ; https://aur.archlinux.org/pidgin-extprefs.git (только для чтения, нажмите, чтобы скопировать) ; http://gaim-extprefs.sourceforge.net/ ; https://aur.archlinux.org/packages/pidgin-extprefs ; https://downloads.sourceforge.net/sourceforge/gaim-extprefs/pidgin-extprefs-0.7.tar.gz
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############ Справка и Дополнения ##########
# Mozilla Thunderbird
# https://www.thunderbird.net/ru/
# Pidgin (Мессенджер)
# https://www.pidgin.im/
# https://wiki.archlinux.org/title/Pidgin
#############################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Telegram Desktop (telegram-desktop) - Популярный мессенджер?"
echo -e "${MAGENTA}:: ${BOLD}Telegram Messenger — программа для обмена мгновенными сообщениями доступная для всех популярных операционных систем, включая мобильные. Позволяет обмениваться текстовыми сообщениями, изображениями, видео, аудио и документами. Основными пользователями программы Telegram являются пользователи мобильный устройств — iOS и Android. Telegram доступен также под Linux, Windows, Mac OS X, Chrome app, Firefox OS, Windows Phone. Существует Web-версия Telegram, которая работает прямо в браузере. Есть версия Telegram CLI (Linux Command-line interface for Telegram). В первую очередь известен благодаря шифрованию и защите личных данных пользователей. Telegram Desktop - это официальное приложение Telegram для настольных операционных систем. ${NC}"
echo " Домашняя страница: https://desktop.telegram.org/ ; (https://archlinux.org/packages/extra/x86_64/telegram-desktop/). "  
echo -e "${MAGENTA}:: ${BOLD}Основателем проекта является Павел Дуров, бывший гендиректор и один из создателей социальной сети ВКонтакте. 'Telegram Desktop' - является прямой реализацией веб-сайта Telegram. Бесплатный (никаких платных подписок) мессенджер от компании Павла Дурова. ${NC}"
echo " Из особенностей мессенджера Telegram стоит отметить: мгновенная доставка сообщений, использование алгоритмов шифрования для защиты переписки, групповые чаты, объединение чатов в папки, полная синхронизация между устройствами. " 
echo -e "${MAGENTA}:: ${BOLD}При первом запуске Telegram необходимо ввести свой телефонный номер, на который прийдет СМС сообщение с кодом активации. Если вы уже использовали Телеграм на другом устройстве, то все ваши контакты мгновенно отобразятся.
Из программы также можно выполнить настройки своего профиля. Есть возможность автоматического обновления программы. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Напомним, что недавно в России разблокировали Telegram. Хотя почти никто и не прекращал им пользоваться, разблокировка принесла несколько хороших побочных эффектов. Один из которых — множество интернет-сайтов, которые были недоступны в следствии некорректной блокировки IP-адресов Telegram, стали доступны. В частности, популярный в Linux среде ресурс www.gnome-look.org теперь работает свободно. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_telegram  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_telegram" =~ [^10] ]]
do
    :
done
if [[ $i_telegram == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_telegram == 1 ]]; then
  echo ""
  echo " Установка Telegram Messenger (telegram-desktop) "
sudo pacman -Syy  # обновление баз пакмэна (pacman) 
sudo pacman -S --noconfirm --needed ttf-opensans  # Шрифт без засечек, заказанный Google ; https://fonts.google.com/specimen/Open+Sans ; https://archlinux.org/packages/extra/any/ttf-opensans/ ; Помечено как устаревшее 15 марта 2024 г.  
sudo pacman -S --noconfirm --needed telegram-desktop  # Официальный клиент Telegram Desktop ; https://desktop.telegram.org/ ; https://archlinux.org/packages/extra/x86_64/telegram-desktop/
########## telegram-desktop-bin ##############
# yay -S telegram-desktop-bin --noconfirm  # Официальная настольная версия приложения для обмена сообщениями Telegram - Статические двоичные файлы ; https://aur.archlinux.org/telegram-desktop-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/telegramdesktop/tdesktop ; https://aur.archlinux.org/packages/telegram-desktop-bin ; Конфликты: с telegram-desktop ; Это полный исходный код и инструкции по сборке официального настольного клиента мессенджера Telegram , основанного на API Telegram и защищенном протоколе MTProto .
########## libunity ##############
# yay -S libunity --noconfirm  # Библиотека для инструментирования и интеграции со всеми аспектами оболочки Unity ; https://aur.archlinux.org/libunity.git (только для чтения, нажмите, чтобы скопировать) ; https://launchpad.net/libunity ; https://aur.archlinux.org/packages/libunity ; Примечание: Это не библиотека, используемая в реализации оболочки Unity ( lp:unity не компонуется с ней), а библиотека, предназначенная для клиентов, желающих выполнить глубокую интеграцию с оболочкой Unity.
# Счётчик непрочитанных сообщений для Telegram Desktop: По умолчанию, количество непрочитанных сообщений будет отображаться только на иконке Telegram Desktop в системном трее. Если же вы хотите также включить счётчик непосредственно на иконке самого приложения, можно задействовать интеграцию значков Unity, которая поддерживается как в GNOME, так и в KDE Plasma. Для этого нужно установить libunityAUR и запустить Telegram Desktop с переменной окружения XDG_CURRENT_DESKTOP со значением Unity. Например, скопируйте файл .desktop в ~/.local/share/applications/ и измените строку Exec для запуска Telegram Desktop с вышеуказанной переменной окружения.
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Discord (discord) - Чат для геймеров?"
echo -e "${MAGENTA}:: ${BOLD}Discord - это проприетарное кроссплатформенное универсальное приложение для голосового, текстового и видео чатов общения. Изначально Discord ориентировался преимущественно на игровую аудиторию, но потом получил более широкое распространение. ${NC}" 
echo " Домашняя страница: https://discord.com/ ; (https://discordapp.com/; https://archlinux.org/packages/extra/x86_64/discord/) "
echo -e "${MAGENTA}:: ${BOLD}Возможности: Голосовые конференции (VoIP). Текстовые чаты. Публичные и приватные чаты. Видео чаты. Возможность отправки файлов, картинок, вставка ссылок в сообщения (с возможностью предпросмотра). Форматирование текста. Смайлики. Режим Push-to-Talk («нажми и говори»). Режим «Cтримера» (Streamer Mode). Настраиваемый внешний вид. Интеграция с социальными сервисами. Браузерная версия и клиенты для мобильных систем. ${NC}"
echo " 'Discord' - специально разработан для геймеров; однако у многих сообществ с открытым исходным кодом также есть официальные серверы Discord. https://discord.com/open-source . Discord можно использовать через веб-браузер или настольное приложение, созданное с помощью Electron (https://github.com/electron/electron). Программа разрабатывается организацией Discord Inc (изначально Hammer & Chisel). Исходный код: Закрыт (проприетарный); Языки программирования: Elixir; JavaScript; React; Rust; Приложение переведено на русский язык. "
echo -e "${YELLOW}:: Примечание! ${NC}Вы можете самостоятельно установить discord на arch linux. Загрузите файл discard с расширением .tar.gz с официального сайта (https://discord.com/download). Затем извлеките его с помощью tar-xvzf filename. Далее измените свой каталог на вновь извлеченный каталог и сделайте имя файла Discord исполняемым с помощью команды chmod +x Discord. Наконец, выполните команду ./Discord, чтобы запустить discord."
echo " Ссылка на видео: - https://www.youtube.com/watch?v=bbVbFWVsbWQ&t=0s (Install discord on manjaro or arch linux) "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_discord  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_discord" =~ [^10] ]]
do
    :
done
if [[ $i_discord == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_discord == 1 ]]; then
  echo ""
  echo " Установка Discord (discord) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed python-pypresence  # Библиотека-оболочка Discord RPC и Rich Presence ; https://github.com/qwertyquerty/pypresence ; https://archlinux.org/packages/extra-testing/any/python-pypresence/ ; Rich Presence позволяет отображать значимые данные в профиле пользователя Discord о том, чем он занимается в вашей игре или приложении. Выбор отображаемых данных зависит от вас — будь то счет пользователя, продолжительность игры в вашу игру, то, что он слушает на вашей платформе, или что-то еще.
sudo pacman -S --noconfirm --needed discord  # Единый голосовой и текстовый чат для геймеров ; https://discord.com/ ; https://archlinux.org/packages/extra/x86_64/discord/ ; https://wiki.archlinux.org/title/Discord
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Signal (signal-desktop) - Мессенджер с шифрованием?"
echo -e "${MAGENTA}:: ${BOLD}Signal — приложение-мессенджер, главный акцент в котором — конфиденциальность и безопасность. Signal — программа для обмена мгновенными сообщениями, совершения аудио и видео звонков. Приложение появилось в июле 2014 и называлось TextSecure, имело лишь функцию обмена мгновенными сообщениями. В феврале 2018 года был создан некоммерческий фонд Signal Foundation. Signal использует сквозное шифрование «Signal Protocol», разработанное Open Whisper Systems. Signal Private Messenger для Linux - Отправляйте высококачественные групповые, текстовые, голосовые, видео, документальные и графические сообщения в любую точку мира без платы за SMS или MMS. ${NC}"
echo " Домашняя страница: https://signal.org/ ; (https://archlinux.org/packages/extra/x86_64/signal-desktop/). "  
echo -e "${MAGENTA}:: ${BOLD}Современное сквозное шифрование (на основе протокола Signal с открытым исходным кодом) обеспечивает безопасность ваших разговоров. Конфиденциальность — это не необязательный режим — это просто способ работы Signal. Каждое сообщение, каждый звонок, каждый раз. Делитесь текстом, голосовыми сообщениями, фотографиями, видео, GIF-файлами и файлами бесплатно. Signal использует подключение к данным вашего телефона, чтобы вы могли избежать сборов за SMS и MMS. Совершайте кристально чистые голосовые и видеозвонки людям, живущим на другом конце города или за океаном, без платы за междугороднюю связь. Групповые чаты позволяют легко оставаться на связи с семьей, друзьями и коллегами. В Signal нет рекламы, нет аффилированных маркетологов и нет жуткого отслеживания. ${NC}"
echo " Основные особенности и возможности: Клиенты для всех популярных операционных систем, включая мобильные. Обмен сообщениями, звонки, видеозвонки. Передача текстовых сообщений, изображений, видео и других файлов. Групповые чаты. Сквозное шифрование сообщений и звонков. Отсутствие трекеров и рекламы. Signal — независимая некоммерческая организация. Исходный код: Open Source (открыт); Языки программирования: C; Java; Лицензия: GNU GPL v3; Приложение переведено на русский язык. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_signal  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_signal" =~ [^10] ]]
do
    :
done
if [[ $in_signal == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_signal == 1 ]]; then
  echo ""
  echo " Установка Signal (signal-desktop) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S signal-desktop --noconfirm  # Signal Private Messenger для Linux (Отправляйте высококачественные групповые, текстовые, голосовые, видео, документальные и графические сообщения в любую точку мира без платы за SMS или MMS) ; https://signal.org/ ; https://archlinux.org/packages/extra/x86_64/signal-desktop/ ; https://www.signal.org/ru/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить HexChat (hexchat) - Простой Чат?"
echo -e "${MAGENTA}:: ${BOLD}HexChat — это мультиплатформенный, простой, бесплатный IRC-клиент (Internet Relay Chat) на основе XChat, но в отличие от XChat он полностью бесплатен как для Windows, так и для Unix-подобных систем. Поскольку XChat имеет открытый исходный код, он абсолютно легален. Для получения дополнительной информации, пожалуйста, прочтите предысторию Shareware. В 2004 году версия XChat под Windows стала распространяться по модели shareware (30 дней тестовый период). Изначально HexChat называлась XChat-WDK, который в свою очередь был преемником freakschat. ${NC}"
echo " Домашняя страница: https://hexchat.github.io/ ; (https://archlinux.org/packages/extra/x86_64/hexchat/). "  
echo -e "${MAGENTA}:: ${BOLD}Интерфейс HexChat простой и понятный. Главное окно программы разделено на три части. Слева располагается список каналов (дерево чатов), между которыми вы можете переключаться. Справа список пользователей. Основную часть занимает непосредственно окно чата. HexChat обладает множеством настроек. Функциональность HexChat можно расширить с помощью скриптов на Python и Perl. Вы можете настроить внешний вид программы (изменить цвета, включать выключать управляющие элементы, настроить параметры отображения чата)(https://hexchat.github.io/themes.html) ${NC}"
echo " Функции: Простой в использовании и настраиваемый интерфейс; Кроссплатформенность на Windows и Unix-подобных ОС; Широкие возможности написания скриптов на Lua, Python и Perl; Переведено на несколько языков; Полностью открытый исходный код и активно разрабатывается; Мультисеть с автоматическим подключением, присоединением и идентификацией; Проверка орфографии, прокси, SASL, поддержка DCC и многое другое. Исходный код: Open Source (открыт); Языки программирования: C; Библиотеки: GTK; Лицензия: GNU GPL; Программа переведена на русский язык доступна для Linux (Unix-like систем) и Windows. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_hexchat  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_hexchat" =~ [^10] ]]
do
    :
done
if [[ $in_hexchat == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_hexchat == 1 ]]; then
  echo ""
  echo " Установка HexChat (hexchat) "
sudo pacman -Syy  # обновление баз пакмэна (pacman) 
sudo pacman -S --noconfirm --needed hexchat  # Популярный и простой в использовании графический IRC (чат)-клиент ; https://hexchat.github.io/ ; https://archlinux.org/packages/extra/x86_64/hexchat/ ; https://hexchat.readthedocs.io/en/latest/ ; https://hexchat.github.io/themes.html ; https://man.archlinux.org/man/extra/hexchat/hexchat.1.en
######## hexchat-git ###########
# yay -S hexchat-git --noconfirm  # IRC-клиент на базе GTK+ ; https://aur.archlinux.org/hexchat-git.git (только для чтения, нажмите, чтобы скопировать) ; https://aur.archlinux.org/packages/hexchat-git ; https://hexchat.github.io/ ; git+https://github.com/hexchat/hexchat.git ; Конфликты: с hexchat, hexchat-lua-git !
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Konversation (konversation) - IRC-клиент?"
echo -e "${MAGENTA}:: ${BOLD}Konversation — IRC клиент (Internet Relay Chat), разрабатываемый в рамках проекта KDE. Konversation — это удобный клиент Internet Relay Chat (IRC) от KDE. Он обеспечивает легкий доступ к стандартным сетям IRC, таким как Libera (https://libera.chat/), где можно найти каналы KDE IRC. Libera Chat (libera.chat) - IRC-сеть для проектов бесплатного программного обеспечения с открытым исходным кодом, основанная бывшими сотрудниками Freenode после того, как контроль над последней получил Эндрю Ли. ${NC}"
echo " Домашняя страница: https://konversation.kde.org/ ; (https://archlinux.org/packages/kde-unstable/x86_64/konversation/). "  
echo -e "${MAGENTA}:: ${BOLD}Пользователи IRC могут обмениваться файлами с другими пользователями в сети. Прямой клиент-клиент (DCC) — это тип обмена файлами между равноправными пользователями, использующий сервер IRC для установления связи с целью обмена файлами или выполнения нерелейных чатов. Типичный сеанс DCC выполняется независимо от сервера IRC после его установки. Konversation имеет один из лучших пользовательских интерфейсов среди всех клиентов IRC. Пользовательский интерфейс очень удобен и прост в использовании для новичков. Konversation очень настраиваемый. Создавайте псевдонимы команд, меняйте настройки по умолчанию, выбирайте положение вкладок по умолчанию и многое другое доступно в параметрах. И многое другое! ${NC}"
echo " Функции: Стандартные функции IRC; Поддержка SSL-сервера; Поддержка закладок; Простой в использовании графический пользовательский интерфейс; Несколько серверов и каналов в одном окне; Передача файлов DCC; Несколько идентификаторов для разных серверов; Оформление текста и цвета; Отображение уведомлений на экране; Автоматическое определение UTF-8; Поддержка кодирования по каналам; Поддержка тем для иконок ников; Широкие возможности настройки и т.д... Некоторые возможности и особенности Konversation: Поддержка SSL. Поддержка закладок. Простой интерфейс. Поддержка нескольких серверов и каналов в одном окне. Пересылка файлов посредством Direct Client-to-Client (DDC). Поддержка всплывающих уведомлений на рабочем столе. Автоматическое определение кодировки UTF-8. Задание кодировки для каждого канала отдельно. Большое число настроек. Поддержка тем. Интеграция с адресной книгой KDE. И другие... Konversation поддерживает популярные платформы, такие как Linux, Windows и FreeBSD. Это клиент IRC по умолчанию во многих известных дистрибутивах Linux, таких как openSUSE, KDE-версия Fedora и Kubuntu. Разрабатывается в рамках проекта KDE. Язык программирования: C++; Библиотеки: Qt; Лицензия: GPLv2. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_konversation  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_konversation" =~ [^10] ]]
do
    :
done
if [[ $in_konversation == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_konversation == 1 ]]; then
  echo ""
  echo " Установка Konversation (konversation) "
sudo pacman -Syy  # обновление баз пакмэна (pacman) 
sudo pacman -S --noconfirm --needed konversation  # Удобный и полнофункциональный IRC-клиент ; https://konversation.kde.org/ ; https://apps.kde.org/konversation/ ; https://archlinux.org/packages/kde-unstable/x86_64/konversation/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Franz (franz) - Все мессенджеры в одном месте?"
echo -e "${MAGENTA}:: ${BOLD}Franz — программа, которая позволяет использовать одновременно несколько мессенджеров и интернет-сервисов из одной программы — Telegram, VK, WhatsApp, Facebook Messenger и другие. То есть это что-то вроде агрегатора мессенджеров. Его еще называют менеджером чатов. Franz по сути является браузером, в котором каждый сервис — это веб-вкладка с интерфейсом из официальной странички каждого мессенджера. Программа переведена на русский язык. Распространение: бесплатно, Open Source. Программа доступна для Linux, Windows и MacOS. ${NC}"
echo " Домашняя страница: https://meetfranz.com/ ; (https://meetfranz.com/services ; https://aur.archlinux.org/packages/franz) "  
echo -e "${MAGENTA}:: ${BOLD}После запуска приложения нам будет предложено выбрать и «обозвать» каждую вкладку социальных сервисов. Далее проходим предельно простой процесс авторизации, опять же из веб-интерфейсов официальных страничек сервисов, и приступаем к использованию. Новые сообщения отображаются во вкладках. Имеется уникальный звук входящих уведомлений, который ни с чем не спутаешь. Присутствует бейджик с количеством пропущенных сообщений на иконке каждого сервиса, что очень удобно. Одним из главных позитивных моментов Franz является возможность добавления неограниченного количества аккаунтов одного и того же сервиса. Franz поддерживает 64 службы чата и объединяет их в одно приложение. ${NC}"
echo " Поддерживается довольно большое количество сервисов, вот некоторые из них: Telegram; VK; WhatsApp; Facebook Messenger; Google Hangouts; Skype; Slack; ICQ и другие. Помимо мессенджеров можно добавлять другие интерент-сервисы: Gmail; Google Calendar; Pocket; Todoist и так далее... Каждый сервис можно использовать под различными логинами. Таким образом, вы можете добавлять в программу несколько аккаунтов одного сервиса. Поддержки аудио или видео звонков нет. Они выполняются уже через ваш браузер. При первом запуске программы необходимо создать учетную запись Franz. Это позволяет вам устанавливать программу на различных компьютерах и синхронизировать ваши настройки. При каждой новой установке программы на новом компьютере вам не нужно будет добавлять каждый сервис повторно. Имена пользователей и пароли не синхронизируются! Для каждого добавленного сервиса можно установить свою иконку. " 
echo -e "${CYAN}:: ${NC}Установка Franz (franz) и (franz-bin) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить Franz (franz),      2 - Установить Franz (franz-bin),     0 - НЕТ - Пропустить установку: " in_franz  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_franz" =~ [^120] ]]
do
    :
done
if [[ $in_franz == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_franz == 1 ]]; then
  echo ""
  echo " Установка Franz (franz) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
######### Зависимости ##########
sudo pacman -S --noconfirm --needed expac  # Утилита извлечения данных alpm (база данных pacman) ; https://github.com/falconindy/expac ; https://archlinux.org/packages/extra/x86_64/expac/
yay -S electron25 --noconfirm  # Создавайте кроссплатформенные настольные приложения с использованием веб-технологий ; https://aur.archlinux.org/electron25.git (только для чтения, нажмите, чтобы скопировать) ; https://electronjs.org/ ; https://aur.archlinux.org/packages/electron25 
yay -S nvm --noconfirm  # Node Version Manager — простой bash-скрипт для управления несколькими активными версиями node.js ; https://aur.archlinux.org/nvm.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/nvm-sh/nvm ; https://aur.archlinux.org/packages/nvm
######### franz ###########
yay -S franz --noconfirm  # Бесплатное приложение для обмена сообщениями для таких сервисов, как WhatsApp, Slack, Messenger и многих других ; https://aur.archlinux.org/franz.git (только для чтения, нажмите, чтобы скопировать) ; https://meetfranz.com/ ; https://aur.archlinux.org/packages/franz
# git clone https://aur.archlinux.org/franz.git ~/franz ; cd ~/franz ; makepkg -si
#git clone https://aur.archlinux.org/franz.git   # (только для чтения, нажмите, чтобы скопировать)
#cd franz
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf franz 
#rm -Rf franz
# yay -Rns franz  # * (Необязательно) Удалите franz в Arch с помощью YAY
####### franz-wayland ##########
# yay -S franz-wayland --noconfirm  # Приложение для обмена сообщениями для таких сервисов, как WhatsApp, Slack, Messenger и многих других ; https://aur.archlinux.org/franz-wayland.git (только для чтения, нажмите, чтобы скопировать) ; https://meetfranz.com/ ; https://aur.archlinux.org/packages/franz-wayland ; Конфликты: с franz ; 2024-08-17 16:47 (UTC)
# yay -Rns franz-wayland  # * (Необязательно) Удалите franz в Arch с помощью YAY
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_franz == 2 ]]; then
  echo ""
  echo " Установка Franz (franz-bin) "
######### franz-bin ###########  
yay -S franz-bin --noconfirm  # Franz — бесплатное приложение для обмена сообщениями в таких сервисах, как WhatsApp, Slack, Messenger и многих других ; https://aur.archlinux.org/franz-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://meetfranz.com/ ; https://aur.archlinux.org/packages/franz-bin ; Конфликты: с franz ; https://github.com/meetfranz/franz/releases/download/v5.10.0/franz_5.10.0_amd64.deb ; 2023-09-04 08:42 (UTC)
#git clone https://aur.archlinux.org/franz-bin.git   # (только для чтения, нажмите, чтобы скопировать)
#cd franz-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf franz-bin 
#rm -Rf franz-bin 
# yay -Rns franz-bin  # * (Необязательно) Удалите franz в Arch с помощью YAY
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
###########################
# Примечание! Если во время обновления вы получили следующую ошибку:
# error: failed to commit transaction (conflicting files)
# franz-bin: /usr/bin/franz exists in filesystem
# Просто сделайте:
# sudo pacman -Rcs franz-bin
# sudo rm /usr/bin/franz
# И снова установите franz-bin .
# Проблема в том, что в предыдущей версии /usr/bin/franzбыл создан файлом установки, это плохая идея, потому что система пакетов не знает, кто владеет этим файлом. Это исправлено в текущей версии.
##################################

clear
echo -e "${MAGENTA}
  <<< Установка Программ для общения посредством микрофона и веб-камеры (Интернет-телефония для Linux) в Archlinux >>> ${NC}"
# Installing programs for communication via microphone and webcam (Internet telephony for Linux) in Archlinux
# clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Скайп (или Skype) (skypeforlinux-bin) - Клиент Голосового и видео общения?"
echo -e "${MAGENTA}:: ${BOLD}Skype — бесплатная программа, которая позволяет общаться через сеть интернет со своими коллегами, друзьями, родственниками и другими пользователями по всему миру посредством микрофона и веб-камеры — простое и удобное голосовое общение между людьми. Skype также предоставляет платные услуги, такие как звонки на обычные и сотовые телефоны и отправку SMS... Программа разработана компанией Skype Limited. ${NC}"
echo " Домашняя страница: http://www.skype.com/ ; (https://aur.archlinux.org/packages/skypeforlinux-bin). "  
echo -e "${MAGENTA}:: ${BOLD}Программа позволяет: Вести индивидуальную переписку, обмениваться сообщениями с коллегой по работе, так же как и в других программах вида ICQ, QIP или Jabber. Вы можете дозвониться до друга из соседнего города и просто разговаривать, как будто вы общаетесь по телефону. Если у вас есть веб-камера, микрофон и наушники, то вы можете проводить видеоконференцию, видеть собеседника, слышать его и отвечать. Можно сказать, это видеотелефон, но на самом деле информация передается через интернет, и вы платите не за минуты, а за количество отправленных и полученных мегабайт. Программа Skype (Скайп) позволяет звонить вашему партнеру на мобильный телефон, стационарный телефон, отправлять смс-сообщения на мобильный телефон. При этом вы не встаете из-за компьютера, выбираете выгодный для вас тариф и платите меньше. С помощью скайпа вы можете дозвониться в любую точку планеты, при этом звонки со Skype на Skype будут совершенно бесплатны. В случае, если у вас срочная командировка и нет возможности открыть программу Скайп, вы можете переадресовать звонки и текстовые сообщения. Отличие Скайпа от других программ (те же ICQ, QIP или Jabber) состоит в том, что вы можете разговаривать в чате как с одним человеком, так и сразу с несколькими десятками людей, которых вы пригласите в свой чат. Skype позволяет пересылать файлы, вести записную книжку, получать новости, заходить на другие конференции, тема которых вам интересна, также позволяет осуществлять поиск информации, не закрывая программы, с помощью панели инструментов Google (панель инструментов настраивается при установке программы). ${NC}"
echo " Skype доступен для Linux, Windows, Mac OS X, а также для мобильных ОС. Исходный код: Закрыт (проприетарный). Skype для Linux полностью переведен на русский язык. " 
echo -e "${CYAN}:: ${NC}Установка Skype (skypeforlinux-bin) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_skype  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_skype" =~ [^10] ]]
do
    :
done
if [[ $in_skype == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_skype == 1 ]]; then
  echo ""
  echo " Установка Skype (skypeforlinux-bin) "
  echo " После завершения процесса установки вы можете запустить Skype, выбрав его в системном меню или введя команду skypeforlinux в терминале "  
sudo pacman -Syy  # обновление баз пакмэна (pacman)
########### skypeforlinux-bin ###########
yay -S skypeforlinux-bin --noconfirm  #  Skype для Linux ; https://aur.archlinux.org/skypeforlinux-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://www.skype.com/ ; https://aur.archlinux.org/packages/skypeforlinux-bin ; 2024-08-08 10:01 (UTC) ; skypeforlinux-8.125.0.201-x86_64.snap - https://api.snapcraft.io/api/v1/snaps/download/QRDEfjn4WJYnm0FzDKwqqRZZI77awQEV_353.snap
#git clone https://aur.archlinux.org/skypeforlinux-bin.git   # (только для чтения, нажмите, чтобы скопировать)
#sudo chmod a+w skypeforlinux-bin  # Чтобы установить Skype, вам необходимо изменить права доступа к файлам
#cd skypeforlinux-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf skypeforlinux-bin 
#rm -Rf skypeforlinux-bin
# yay -Rns skypeforlinux-bin  # * (Необязательно) Удалите skype-call-recorder на Arch с помощью YAY
########### skype-secure ###########
#yay -S skype-secure --noconfirm  # Ограничение доступа к Skype для Linux ; https://aur.archlinux.org/skype-secure.git (только для чтения, нажмите, чтобы скопировать) ; https://wiki.archlinux.org/index.php/skype#Restricting_Skype_access ; https://aur.archlinux.org/packages/skype-secure ; 2018-05-17 19:39 (UTC)
######### hdx-realtime-media-engine ############
# У меня есть патч, который должен исправить проблемы с поддержкой USB здесь. Буду признателен, если кто-то протестирует, пожалуйста :)
# https://github.com/itsjfx/aur-icaclient/commit/df4867af67ff5ea44a9aa3a014f9d998683b4078.patch
# Обязательно запустите службу ctxusbd и добавьте свои USB-устройства в белый список в /opt/Citrix/ICAClient/usb.conf, если необходимо.
# К сожалению, нам все еще необходимо создать следующую символическую ссылку для /opt/Citrix/ICAClient/util/HdxRtcEngine для разрешения всех зависимостей:
# sudo ln -s /usr/lib/libunwind.so /usr/lib/libunwind.so.1
#yay -S icaclient --noconfirm  # Приложение Citrix Workspace (также известное как ICAClient, Citrix Receiver) ; https://aur.archlinux.org/icaclient.git (только для чтения, нажмите, чтобы скопировать) ; https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html ; https://aur.archlinux.org/packages/icaclient ; 2024-06-12 20:31 (UTC)
# yay -S hdx-realtime-media-engine --noconfirm  # Плагин для Citrix Receiver для поддержки четких и ясных аудио- и видеозвонков высокой четкости, особенно с Microsoft Skype® для бизнеса ; https://aur.archlinux.org/hdx-realtime-media-engine.git (только для чтения, нажмите, чтобы скопировать) ; https://www.citrix.com/downloads/workspace-app/additional-client-software/hdx-realtime-media-engine-29700.html ; https://aur.archlinux.org/packages/hdx-realtime-media-engine ; 2024-08-07 06:23 (UTC)
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Skype Call Recorder (skype-call-recorder) - Запись звонков Skype в Linux?"
echo -e "${MAGENTA}:: ${BOLD}Skype Call Recorder представляет собой небольшую утилиту для Linux, с открытым исходным кодом, которая позволяет записывать ваши разговоры с собеседником в Skype на Linux. Приложение может записывать все аудио звонки Skype автоматически, либо по запросу. По умолчанию при новом вызове, Skype Call Recorder будет спрашивать: хотите ли вы записать его, но вы можете настроить приложение для автоматической записи всех вызовов или установить его для записи разговора с конкретным абонентом, а также выбрать формат файла для записи. ${NC}"
echo " Домашняя страница: http://atdot.ch/scr/ ; (https://aur.archlinux.org/packages/skype-call-recorder). "  
echo -e "${MAGENTA}:: ${BOLD}Важно: В некоторых странах запись звонков Skype является незаконной, если у вас нет явного разрешения всех участников! 😃 Обязательно сначала спросите разрешение на запись. Возможности Skype Call Recorder: запись разговоров автоматически/вручную; запись звонков Skype в формате MP3, Ogg Vorbis или WAV; автоматическая запись разговора Skype каждого абонента отдельно; разделять стерео запись. Полностью бесплатен (свободен от слова «свобода»), выпущен под лицензией GNU GPL. ${NC}"
echo " После установки запускаем Skype Call Recorder, Skype сообщит, что другое приложение пытается получить доступ к Skype API, разрешаем этот доступ навсегда. Skype Call Recorder должен появиться в меню вашего рабочего стола в категории Utilities (или Accessories ). Если он не отображается в меню, вам, возможно, придется перезагрузить компьютер. Если он все еще не работает, вам придется вручную добавить его или запустить, вызвав 'skype-call-recorder'. После запуска вы увидите значок в системном трее. Этот значок серый, пока соединение со Skype не установлено; при подключении к Skype он станет цветным. Щелкните его, чтобы выполнить действия, такие как открытие диалогового окна настроек или запуск/остановка вызовов. Активируйте пункт Запомнить выбор и нажмите Да. По умолчанию все звонки сохраняются в директории ~/Skype Calls, для каждого контакта создается отдельная поддиректория. Стоит отметить еще одну особенность: разговоры записываются таким образом, что один собеседник будет записываться на левый канал, а второй - на правый канал (то есть, если проще сказать, в левом динамике один собеседник - в правом другой) 👉👈 . " 
echo -e "${CYAN}:: ${NC}Установка Skype Call Recorder (skype-call-recorder) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_recorder  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_recorder" =~ [^10] ]]
do
    :
done
if [[ $in_recorder == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_recorder == 1 ]]; then
  echo ""
  echo " Установка Skype Call Recorder (skype-call-recorder) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
############ Зависимости ###############
sudo pacman -S --noconfirm --needed id3lib  # Библиотека для чтения, записи и обработки тегов ID3v1 и ID3v2 ; http://id3lib.sourceforge.net/ ; https://archlinux.org/packages/extra/x86_64/id3lib/ ; July 2, 2024, 9:40 p.m. UTC
# sudo pacman -S --noconfirm --needed kdelibs4support  # Помощь в портировании от KDELibs4 ; https://community.kde.org/Frameworks ; https://archlinux.org/packages/extra/x86_64/kdelibs4support/ ; 19 мая 2024 г., 16:52 UTC
# yay -S kdelibs --noconfirm  # Основные библиотеки KDE ; https://aur.archlinux.org/kdelibs.git (только для чтения, нажмите, чтобы скопировать) ; https://www.kde.org/ ; https://aur.archlinux.org/packages/kdelibs ; 2023-08-02 18:40 (UTC)
yay -S qt4 --noconfirm  # Кроссплатформенное приложение и фреймворк пользовательского интерфейса ; https://aur.archlinux.org/qt4.git (только для чтения, нажмите, чтобы скопировать) ; https://www.qt.io/ ; https://aur.archlinux.org/packages/qt4?all_deps=1#pkgdeps ; 2024-06-26 19:25 (UTC) ; Конфликты: с qt ; Заменяет: qt 
# yay -S qt4 --noconfirm --needed  # Кроссплатформенное приложение и фреймворк пользовательского интерфейса ; Qt - это самый быстрый и умный способ создания ведущего в отрасли программного обеспечения, которое нравится пользователям.
######### skype-call-recorder ############
yay -S skype-call-recorder --noconfirm  # Записывайте звонки Skype в файлы MP3, Ogg Vorbis или WAV ; https://aur.archlinux.org/skype-call-recorder.git (только для чтения, нажмите, чтобы скопировать) ; http://atdot.ch/scr/ ; https://aur.archlinux.org/packages/skype-call-recorder ; 2017-05-11 19:04 (UTC)
#git clone https://aur.archlinux.org/skype-call-recorder.git   # (только для чтения, нажмите, чтобы скопировать)
# sudo chmod a+w skype-call-recorder  # вам необходимо изменить права доступа к файлам
#cd skype-call-recorder
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf skype-call-recorder 
#rm -Rf skype-call-recorder
# yay -Rns skype-call-recorder  # * (Необязательно) Удалите skype-call-recorder на Arch с помощью YAY
mkdir ~/Skype Calls  # # Общая директория, на машине
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить VK Мессенджер (vk-messenger) - Офицальный клиент Вконтакте для Linux?"
echo -e "${MAGENTA}:: ${BOLD}VK Мессенджер — бесплатное и быстрое приложение для общения. Будьте на связи с друзьями и знакомыми в чатах и звонка. VK Мессенджер – официальное приложение Вконтакте (vk.com) для удобного общения с помощью мгновенных сообщений, голосовых и видеозвонков с поддержкой компьютеров Windows, Mac, Linux и мобильных устройств. VK Мессенджер – это отличный способ всегда быть на связи. Приложение разработано для комфортного общения с друзьями и коллегами с помощью мгновенных сообщений, голосовых и видеозвонков, обмена голосовыми сообщениями и фотографиями, а также отправки документов и файлов и привычным образом не запуская веб-браузер. Внешне и функционально практически идентичен Диалогам из соцсети. ${NC}"
echo " Домашняя страница: https://vk.com/messenger ; (https://vk.me/app ; https://aur.archlinux.org/packages/vk-messenger). "  
echo -e "${MAGENTA}:: ${BOLD}VK мессенджер (бывший Сферум) - приложение для обмена текстовыми и голосовыми сообщениями, звонков, удобного доступа к контактам и функций для приватного общения, включая создание фантомных чатов и отправку исчезающих сообщений. Также поддерживает бизнес-уведомления. Включает в себя Сферум - защищенную платформу для организации учебного процесса, дающую возможность коммуницировать всем её участникам различными способами. ${NC}"
echo " Возможности VK Messenger: Обмен текстовыми сообщениями; Обмен медиа файлами и стикерами; Общение в приватных и групповых чатах; Отображение превьюшек медиа файлов в чате; Воспроизведение видео во всплывающем окне без перехода в веб-браузер; Поиск диалогов; Поиск по истории сообщений; Очистка истории сообщений; Блокировка пользователей; Настройка уведомлений; Масштабирование интерфейса; Сворачивание в трей; Поддержка прокси...  Диалоги можно объединять в групповые беседы, в которых могут участвовать до 500 человек. Функция автообновления позволит всегда пользоваться актуальной версией приложения с новыми возможностями. " 
echo -e "${CYAN}:: ${NC}Установка VK Messenger (vk-messenger) и (vk-messenger-bin) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить VK Messenger (vk-messenger),    2 - Установить VK Messenger (vk-messenger-bin),  

    0 - НЕТ - Пропустить установку: " in_vk_messenger  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_vk_messenger" =~ [^120] ]]
do
    :
done
if [[ $in_vk_messenger == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_vk_messenger == 1 ]]; then
  echo ""
  echo " Установка VK Messenger (vk-messenger) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
####### vk-messenger ########## 
yay -S vk-messenger --noconfirm  # ВКонтакте Мессенджер для Linux ; https://aur.archlinux.org/vk-messenger.git (только для чтения, нажмите, чтобы скопировать) ; https://vk.com/messenger ; https://aur.archlinux.org/packages/vk-messenger ; 2024-06-11 08:11 (UTC) ; https://upload.object2.vk-apps.com/vk-me-desktop-dev-5837a06d-5f28-484a-ac22-045903cb1b1a/latest/vk-messenger.rpm
# git clone https://aur.archlinux.org/vk-messenger.git ~/vk-messenger ; cd ~/vk-messenger ; makepkg -si
#git clone https://aur.archlinux.org/vk-messenger.git   # (только для чтения, нажмите, чтобы скопировать)
#cd vk-messenger
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf vk-messenger 
#rm -Rf vk-messenger  # Необязательно (очистить кэш после установки)
# yay -Rns vk-messenger  # * (Необязательно) Удалите vk-messenger на Arch с помощью YAY 
####### vk-messenger (new) ##########
# Продолжение репозитория https://aur.archlinux.org/packages/vk-messenger . Сопровождающий пакетов игнорирует обновления, поэтому я решил взять ответственность на себя (https://github.com/hinqiwame/vk-messenger) .
# yay -S vk-messenger --noconfirm  # ВКонтакте Мессенджер для Linux ; https://aur.archlinux.org/vk-messenger.git (только для чтения, нажмите, чтобы скопировать) ; https://vk.com/messenger ; https://aur.archlinux.org/packages/vk-messenger ; 2024-06-11 08:11 (UTC) ; https://upload.object2.vk-apps.com/vk-me-desktop-dev-5837a06d-5f28-484a-ac22-045903cb1b1a/latest/vk-messenger.rpm
#git clone https://github.com/hinqiwame/vk-messenger   # (только для чтения, нажмите, чтобы скопировать)
#cd vk-messenger
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf vk-messenger 
#rm -Rf vk-messenger  # Необязательно (очистить кэш после установки)
# yay -Rns vk-messenger  # * (Необязательно) Удалите vk-messenger на Arch с помощью YAY 
####### vk-messenger-appimage ##########
# yay -S vk-messenger-appimage --noconfirm  # VK Messenger для Linux в формате пакета appimage ; https://aur.archlinux.org/vk-messenger-appimage.git (только для чтения, нажмите, чтобы скопировать) ; https://vk.me/app ; https://aur.archlinux.org/packages/vk-messenger-appimage ; 2024-06-08 19:15 (UTC) ; Заменяет: vk-messenger ; https://upload.object2.vk-apps.com/vk-me-desktop-dev-5837a06d-5f28-484a-ac22-045903cb1b1a/latest/vk-messenger.AppImage
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_vk_messenger == 2 ]]; then
  echo ""
  echo " Установка VK Messenger (vk-messenger-bin) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
############ Зависимости ###############
# sudo pacman -S --noconfirm --needed pulse-native-provider  # Звуковой сервер PulseAudio (поставщик по умолчанию) ; https://pipewire.org/ ; https://archlinux.org/packages/extra/x86_64/pulse-native-provider/ ; 15 августа 2024 г., 18:36 UTC
####### vk-messenger-bin ########## 
yay -S vk-messenger-bin --noconfirm  # VK Messenger для Linux из пакета rpm ; https://aur.archlinux.org/vk-messenger-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://vk.me/app ; https://aur.archlinux.org/packages/vk-messenger-bin ; 2024-06-08 19:08 (UTC) ; Заменяет: vk-messenger, vk-messenger-appimage ; https://upload.object2.vk-apps.com/vk-me-desktop-dev-5837a06d-5f28-484a-ac22-045903cb1b1a/latest/vk-messenger.rpm
# Пожалуйста, используйте pulse-native-provider вместо pulseaudio. Смотрите https://gitlab.archlinux.org/archlinux/packaging/packages/pipewire/-/issues/10
#git clone https://aur.archlinux.org/vk-messenger-bin.git   # (только для чтения, нажмите, чтобы скопировать)
#cd vk-messenger-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf vk-messenger-bin 
#rm -Rf vk-messenger-bin  # Необязательно (очистить кэш после установки)
# yay -Rns vk-messenger-bin  # * (Необязательно) Удалите vk-messenger-bin на Arch с помощью YAY 
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Viber (viber) - Обмена сообщениями и звонками VoIP?"
echo -e "${MAGENTA}:: ${BOLD}Viber - это бесплатное и безопасное приложение для звонков и массажа для мобильных устройств и настольных компьютеров. Его можно использовать для совершения бесплатных телефонных звонков, отправки текстовых сообщений, фотографий, стикеров и видеозвонков по технологии передачи голоса по интернет-протоколу (VOIP). Особенность Viber в том, что он бесплатный и без рекламы. Viber можно использовать практически на всех телефонах и настольных ОС. На одну часть Skype, на другую WhatsApp - Viber объединяет в себе традиционные функции IP телефонии, зашифрованные сообщения, эмодзи и стикеры. ${NC}"
echo " Домашняя страница: https://www.viber.com/ ; (https://aur.archlinux.org/packages/viber?all_deps=1#pkgdeps). "  
echo -e "${MAGENTA}:: ${BOLD}Бесплатная программа Viber является аналогом таких известных приложений, как Skype, WhatsApp, и позволяет организовывать аудио- и видеосвязь по всему миру через глобальную сеть интернет. Это обеспечивает ей довольно крупную популярность среди пользователей. Существует множество различных версий Viber для разных мобильных платформ, различных моделей устройств, и недавно была выпущена новая версия Viber для Linux платформ, в дополнение к стандартной Windows-версии. ${NC}"
echo " Некоторые функции Viber: регистрация не обязательна, только на мобильном; отправка сообщений; голосовые и видеозвонки; групповые чаты групповые чаты, звонки могут общаться сразу несколько участников; участие в сообществах; обмен наклейками и GIF-файлами; создание собственных наклеек и GIF-файлов; удаление и редактирование виденных сообщений; установка исчезающих сообщений (саморазрушение); синхронизация контактов из телефонной книги мобильного; переадресация вызовов (между устройствами); видеозвонки (между компьютерами); HD-качество звонков; сквозное шифрование по умолчанию. Как и WhatsApp, Viber использует номер мобильного телефона в качестве "аккаунта", а не привычный логин (что означает, если у вас нет мобильного устройства - вы не сможете им пользоваться). " 
echo -e "${CYAN}:: ${NC}Установка Viber (viber) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_viber  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_viber" =~ [^10] ]]
do
    :
done
if [[ $in_viber == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_viber == 1 ]]; then
  echo ""
  echo " Установка Viber (viber) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
############ Зависимости ###############
sudo pacman -S --noconfirm --needed numactl  # Простая поддержка политики NUMA ; https://github.com/numactl/numactl ; https://archlinux.org/packages/extra/x86_64/numactl/ ; 7 февраля 2024 г., 17:34 UTC
############ viber ###############
yay -S viber --noconfirm  # Запатентованное кроссплатформенное программное обеспечение для обмена мгновенными сообщениями и VoIP ; https://aur.archlinux.org/viber.git (только для чтения, нажмите, чтобы скопировать) ; https://www.viber.com/ ; https://www.viber.com/ru/ ; https://aur.archlinux.org/packages/viber?all_deps=1#pkgdeps ; 2024-07-31 20:30 (UTC) ; https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb
#git clone https://aur.archlinux.org/viber.git   # (только для чтения, нажмите, чтобы скопировать)
#cd viber
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf viber 
#rm -Rf viber  # Необязательно (очистить кэш после установки)
# yay -Rns viber  # * (Необязательно) Удалите viber на Arch с помощью YAY 
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
######### Справка ###########
# Проблема «ошибки сегментации (сброса ядра) Viber» все еще сохраняется
# венгерская страница предлагает решение: выполните эту команду:
# sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
# Чтобы включить эту функцию, используйте следующую команду:
# sudo sysctl -w ядро.apparmor_restrict_unprivileged_unconfined=1
# sudo sysctl -w ядро.apparmor_restrict_unprivileged_userns=1
# А если вы хотите отключить его, выполните следующие две команды:
# sudo sysctl -w ядро.apparmor_restrict_unprivileged_unconfined=0
# sudo sysctl -w ядро.apparmor_restrict_unprivileged_userns=0
# ----------------------
# Чтобы загрузить официальный клиент Viber: Открываем терминал.
# Вводим туда команду wget http://download.cdn.viber.com/cdn/desktop/Linux/viber.deb.
# Давайте посмотрим, как мы можем установить Viber в системе Linux.
# Установите приложение Viber в 64-разрядную систему Linux (CLI):
# wget -c download.cdn.viber.com/cdn/desktop/Linux/Viber.zip
# unzip Viber.zip
# cd Viber
# ./Viber.sh  
# Создать симлинк в общедоступное место (по аналогии с zoom-ом):
# ln -s /opt/viber/Viber /usr/bin/viber
# после чего поправить прямо файл меню, заменив в /usr/share/applications/viber.desktop строку:
# Exec=/opt/viber/Viber %u
# на:
# Exec=proxychains viber %u
###############################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить WhatsApp (whatsapp-for-linux) - Обмен сообщениями (IM) и передачи голоса по IP (VoIP)?"
echo -e "${MAGENTA}:: ${BOLD}WhatsApp — это бесплатное приложение для простого обмена сообщениями. WhatsApp — это мобильный сервис мгновенного обмена сообщениями, принадлежащий Meta, с сквозным шифрованием. Для работы требуется активный номер мобильного телефона и подключение к данным. ${NC}"
echo " Домашняя страница: https://web.whatsapp.com/ ; (https://github.com/eneshecan/whatsapp-for-linux). "  
echo -e "${MAGENTA}:: ${BOLD}Официального клиента WhatsApp для Linux нет, и корпорация Цукерберга Meta (ранее Facebook) предприняла строгую попытку запретить сторонние клиенты и плагины, использующие их протокол. Возможно, вам захочется вообще отказаться от WhatsApp в пользу более открытых служб обмена мгновенными сообщениями, таких как XMPP, signal-desktop, Telegram или Matrix. Но к счастью, не так давно, группа энтузиастов выпустила вполне приличную версию этого мессенджера для Linux - WhatsApp for Linux. ${NC}"
echo " WhatsApp для Linux поддерживает следующие функции: обмен текстовыми и голосовыми сообщениями, фотографиями и файлами с людьми из списка контактов; создание групп для общения с несколькими собеседниками сразу; отправка временных сообщений, ручное удаление их у себя и у собеседника, просмотр информации о времени доставки и прочтения; блокировка нежелательных контактов сразу на всех устройствах; архивирование и полное удаление чатов также со всех устройств сразу; аудио и видео звонки не поддерживаются. Для подписки на услугу вам понадобится номер мобильного телефона. Итак! Берём в руки наш телефончик и, следуя инструкции с Welcome-приветствия нашего WhatsApp for Linux, открываем WhatsApp в нашем телефоне и тыкаем... Авторизация в таких программах происходит точно также, как и в браузерной версии – с помощью QR-кода. " 
echo -e "${CYAN}:: ${NC}Установка WhatsApp (whatsapp-for-linux) и (whatsapp-for-linux-bin) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить WhatsApp (whatsapp-for-linux),     2 - Установить WhatsApp (whatsapp-for-linux-bin),  

    0 - НЕТ - Пропустить установку: " in_whatsapp  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_whatsapp" =~ [^120] ]]
do
    :
done
if [[ $in_whatsapp == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_whatsapp == 1 ]]; then
  echo ""
  echo " Установка WhatsApp (whatsapp-for-linux) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
############ Зависимости ###############
sudo pacman -S --noconfirm --needed gtkmm3  # Привязки C++ для GTK+ 3 ; https://www.gtkmm.org/ ; https://archlinux.org/packages/extra/x86_64/gtkmm3/ ; 17 марта 2024 г., 15:58 UTC
sudo pacman -S --noconfirm --needed libayatana-appindicator  # Общая библиотека индикаторов приложений Ayatana ; https://github.com/AyatanaIndicators/libayatana-appindicator ; https://archlinux.org/packages/extra/x86_64/libayatana-appindicator/ ; Октябрь. 13, 2023, 16:06 по всемирному координированному времени
sudo pacman -S --noconfirm --needed libcanberra  # Небольшая и легкая реализация спецификации звуковой темы XDG ; https://0pointer.net/lennart/projects/libcanberra/ ; https://archlinux.org/packages/extra/x86_64/libcanberra/ ; 12 июля 2024 г., 19:39 UTC
sudo pacman -S --noconfirm --needed webkit2gtk  # Движок веб-контента для GTK ; https://webkitgtk.org/ ; https://archlinux.org/packages/extra/x86_64/webkit2gtk/ ; 16 августа 2024 г., 0:16 UTC
sudo pacman -S --noconfirm --needed hunspell  # Библиотека и программа для проверки орфографии и морфологического анализатора ; https://github.com/hunspell/hunspell ; https://archlinux.org/packages/extra/x86_64/hunspell/
sudo pacman -S --noconfirm --needed hunspell-ru  # Русский словарь для Hunspell ; https://cgit.freedesktop.org/libreoffice/dictionaries/tree/ru_RU ; https://archlinux.org/packages/extra/any/hunspell-ru/
############ whatsapp-for-linux ###############
yay -S whatsapp-for-linux --noconfirm  # WhatsApp для Linux — неофициальное настольное приложение WhatsApp, написанное на C++ с помощью библиотек gtkmm и WebKitGtk. Посетите вики для получения более подробной информации ; https://aur.archlinux.org/whatsapp-for-linux.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/eneshecan/whatsapp-for-linux ; https://aur.archlinux.org/packages/whatsapp-for-linux ; 2024-04-26 08:01 (UTC)
#git clone https://aur.archlinux.org/whatsapp-for-linux.git   # (только для чтения, нажмите, чтобы скопировать)
#cd whatsapp-for-linux
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf whatsapp-for-linux 
#rm -Rf whatsapp-for-linux  # Необязательно (очистить кэш после установки)
# yay -Rns whatsapp-for-linux  # * (Необязательно) Удалите whatsapp-for-linux на Arch с помощью YAY 
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_whatsapp == 2 ]]; then
  echo ""
  echo " Установка WhatsApp (whatsapp-for-linux-bin) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
############ Зависимости ###############
sudo pacman -S --noconfirm --needed gtkmm3  # Привязки C++ для GTK+ 3 ; https://www.gtkmm.org/ ; https://archlinux.org/packages/extra/x86_64/gtkmm3/ ; 17 марта 2024 г., 15:58 UTC
sudo pacman -S --noconfirm --needed libayatana-appindicator  # Общая библиотека индикаторов приложений Ayatana ; https://github.com/AyatanaIndicators/libayatana-appindicator ; https://archlinux.org/packages/extra/x86_64/libayatana-appindicator/ ; Октябрь. 13, 2023, 16:06 по всемирному координированному времени
sudo pacman -S --noconfirm --needed libcanberra  # Небольшая и легкая реализация спецификации звуковой темы XDG ; https://0pointer.net/lennart/projects/libcanberra/ ; https://archlinux.org/packages/extra/x86_64/libcanberra/ ; 12 июля 2024 г., 19:39 UTC
#sudo pacman -S --noconfirm --needed libsigc++  # Каркас обратного вызова для C++ ; https://libsigcplusplus.github.io/libsigcplusplus/ ; https://archlinux.org/packages/extra/x86_64/libsigc++/ ; Октябрь. 1 декабря 2023 г., 12:06 по всемирному координированному времени
sudo pacman -S --noconfirm --needed webkit2gtk-4.1  # Движок веб-контента для GTK ; https://webkitgtk.org/ ; https://archlinux.org/packages/extra/x86_64/webkit2gtk-4.1/ ; 16 августа 2024 г., 0:16 UTC
############ whatsapp-for-linux-bin ###############
yay -S whatsapp-for-linux-bin --noconfirm  # Неофициальное настольное приложение WhatsApp для Linux ; https://aur.archlinux.org/whatsapp-for-linux-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/eneshecan/whatsapp-for-linux ; https://aur.archlinux.org/packages/whatsapp-for-linux-bin ; Конфликты: whatsapp-for-linux ; 2024-04-25 08:34 (UTC)
#git clone https://aur.archlinux.org/whatsapp-for-linux-bin.git   # (только для чтения, нажмите, чтобы скопировать)
#cd whatsapp-for-linux-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf whatsapp-for-linux-bin 
#rm -Rf whatsapp-for-linux-bin  # Необязательно (очистить кэш после установки)
# yay -Rns whatsapp-for-linux-bin  # * (Необязательно) Удалите whatsapp-for-linux-bin на Arch с помощью YAY 
echo ""
echo " Установка утилит (пакетов) выполнена "
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Teamviewer (teamviewer) - Быстрое и безопасное подключения к другой системе?"
echo -e "${MAGENTA}:: ${BOLD}TeamViewer - это приложение для удаленного управления рабочего стола, совместного использования рабочего стола, проведения онлайн-собраний, веб-конференций и передачи файлов между компьютерами, которое в основном используется для быстрого и безопасного подключения к другой системе. Оно позволяет удаленно подключаться к чьему-либо рабочему столу, передавать файлы, обмениваться экранами и проводить видеоконференции. Он чрезвычайно популярен благодаря своей простоте и удобству использования. В основном он используется для оказания технической поддержки удаленным компьютерам. ${NC}"
echo " Домашняя страница: http://www.teamviewer.com/ ; (https://aur.archlinux.org/packages/teamviewer). "  
echo -e "${MAGENTA}:: ${BOLD}Это кроссплатформенное программное обеспечение, доступное для Windows, Mac OS X, Linux, iOS и Android, а также с поддержкой веб-браузера. Хотя TeamViewer является проприетарным программным обеспечением, оно бесплатно для некоммерческого использования и предлагает практически все, что может предложить платная версия. TeamViewer - это одно из первых решений для доступа к рабочему столу и совместной работы через Интернет без необходимости выделения специального сервера и маршрутизируемого (”белого”) IP-адреса. По понятным юридическим причинам Arch Linux не распространяет Teamviewer. В результате пользователи должны установить программное обеспечение через AUR .  ${NC}"
echo " Функции TeamViewer: Позволяет осуществлять Дистанционное (удаленное) управление системой. Поддерживает видеоконференции, групповые вызовы и общий доступ к рабочему столу. Для безопасного соединения используется 256-битная кодировка сеанса AES и 2048-битный обмен ключами RSA. Функция Wake-on-LAN позволяет удаленно включать компьютер. Поддерживает перезагрузку вашей системы или серверов в пути. Возможность Переключаться между несколькими экранами легко. Он предлагает множество других функций, с которыми вы можете ознакомиться на его официальной странице (http://www.teamviewer.com/). При первом запуске TeamViewer вам будет предложено настроить безопасный пароль и учетную запись. Рекомендуется указать надежный пароль для предотвращения несанкционированного удаленного доступа. Запишите случайно сгенерированный идентификатор TeamViewer. Вам нужно будет предоставить его клиентам, чтобы разрешить входящие соединения. " 
echo -e "${CYAN}:: ${NC}Установка Teamviewer (teamviewer) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_teamviewer  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_teamviewer" =~ [^10] ]]
do
    :
done
if [[ $in_teamviewer == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_teamviewer == 1 ]]; then
  echo ""
  echo " Установка Teamviewer (teamviewer) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
############ Зависимости ###############
# Примечание! В вашем файле /etc/pacman.conf должен быть включен репозиторий с несколькими библиотеками , иначе Teamviewer не создаст нужную версию. 
# sudo pacman -S lib32-libpng12 lib32-dbus lib32-libxinerama lib32-libjpeg6-turbo lib32-libxtst
# sudo pacman -S --noconfirm --needed lib32-libpng12 lib32-dbus lib32-libxinerama lib32-libjpeg6-turbo lib32-libxtst
sudo pacman -S --noconfirm --needed lib32-libpng12  # Коллекция процедур, используемых для создания графических файлов формата PNG ; http://www.libpng.org/pub/png/libpng.html ; https://archlinux.org/packages/multilib/x86_64/lib32-libpng12/ ; 25 мая 2020 г., 16:21 UTC 
sudo pacman -S --noconfirm --needed lib32-dbus  # Система шины сообщений Freedesktop.org - 32 бита ; https://wiki.freedesktop.org/www/Software/dbus/ ; https://archlinux.org/packages/multilib/x86_64/lib32-dbus/ ; 9 января 2024 г., 16:57 UTC
sudo pacman -S --noconfirm --needed lib32-libxinerama  # Библиотека расширения X11 Xinerama (32-бит) ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/multilib/x86_64/lib32-libxinerama/ ; Октябрь. 31, 2022, 23:23 по всемирному координированному времени
sudo pacman -S --noconfirm --needed lib32-libjpeg6-turbo  # Производная libjpeg с ускоренным базовым сжатием и декомпрессией JPEG ; https://libjpeg-turbo.org/ ; https://archlinux.org/packages/multilib/x86_64/lib32-libjpeg6-turbo/ ; 25 мая 2020 г., 16:18 UTC
sudo pacman -S --noconfirm --needed lib32-libxtst  # Тестирование X11 — библиотека расширения ресурсов (32-бит) ; https://xorg.freedesktop.org/ ; https://archlinux.org/packages/multilib/x86_64/lib32-libxtst/ ; 6 августа 2024 г., 22:44 UTC
############ Зависимости teamviewer ###############
sudo pacman -S --noconfirm --needed qt5-declarative  # Классы для языков QML и JavaScript ; https://www.qt.io/ ; https://archlinux.org/packages/extra/x86_64/qt5-declarative/ ; 29 мая 2024 г., 17:02 UTC
sudo pacman -S --noconfirm --needed qt5-quickcontrols  # Многоразовые элементы управления пользовательским интерфейсом на основе Qt Quick для создания классических пользовательских интерфейсов в стиле настольного компьютера ; https://www.qt.io/ ; https://archlinux.org/packages/extra/x86_64/qt5-quickcontrols/ ; May 29, 2024, 5:02 p.m. UTC
sudo pacman -S --noconfirm --needed qt5-svg  # Классы для отображения содержимого SVG-файлов ; https://www.qt.io/ ; https://archlinux.org/packages/extra/x86_64/qt5-svg/ ; 29 мая 2024 г., 17:02 UTC
sudo pacman -S --noconfirm --needed qt5-webengine  # Обеспечивает поддержку веб-приложений с использованием проекта браузера Chromium ; https://www.qt.io/ ; https://archlinux.org/packages/extra/x86_64/qt5-webengine/ ; 26 июля 2024 г., 17:12 UTC
sudo pacman -S --noconfirm --needed qt5-x11extras  # Предоставляет API-интерфейсы для X11, специфичные для платформы ; https://www.qt.io/ ; https://archlinux.org/packages/extra/x86_64/qt5-x11extras/ ; 29 мая 2024 г., 17:02 UTC
############ teamviewer ###############
yay -S teamviewer --noconfirm  # Универсальное программное обеспечение для удаленной поддержки и онлайн-встреч ; https://aur.archlinux.org/teamviewer.git (только для чтения, нажмите, чтобы скопировать) ; http://www.teamviewer.com/ ; https://aur.archlinux.org/packages/teamviewer ; Конфликты: с teamviewer-beta ; 2024-06-29 11:04 (UTC)
#git clone https://aur.archlinux.org/teamviewer.git   # (только для чтения, нажмите, чтобы скопировать)
#cd teamviewer
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf teamviewer 
#rm -Rf teamviewer  # Необязательно (очистить кэш после установки)
# yay -Rns teamviewer  # * (Необязательно) Удалите teamviewer на Arch с помощью YAY
#######################
# sudo systemctl enable teamviewerd
# sudo systemctl start teamviewerd
# sudo systemctl --system daemon-reload  # если его необходимо перезапустить
# Если TeamViewer не обнаруживает демон teamviewerd, вы можете переустановить демон следующим образом:
# sudo teamviewer --daemon enable
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
##################
# Если зависимости отсутствуют, сначала установите необходимые пакеты из репозиториев Arch.
# wget https://download.teamviewer.com/download/linux/teamviewer_amd64.tar.xz
# tar -xf teamviewer_15.17.5.tar.xz
# cd teamviewer
# chmod +x tv-setup
# sudo ./tv-setup install
# Обходной путь для startx
# Создать чат /etc/systemd/system/getty@tty1.service.d/getty@tty1.service-drop-in.conf   
# [Service]
# Environment=XDG_SESSION_TYPE=x11
####################

clear
echo ""
echo -e "${GREEN}==> ${NC}Запустить и добавить в автозапуск сервис TeamViewer'a (teamviewerd)?"
echo -e "${BLUE}:: ${NC}Если только << TeamViewer >> БЫЛ вами установлен в систему Archlinux!"
# Launch and add the Teamviewer service (teamviewer) to autorun?
echo -e "${YELLOW}:: ${BOLD}Работа TeamViewer требует запущенного сервиса teamviewerd. TeamViwer15 умеет при установке корректно прописывать сервис в системах с systemd. Если у вас SysV init, и/или что-то не сработало, то инитскрипт для SysV init и service-файл для systemd лежат в /opt/teamviewer/tv_bin/script, что-то из них надо скопировать (или сделать символьную ссылку) в соответствующее место. Всегда запускайте TeamViewer в среде рабочего стола, такой как GNOME / KDE и т.д. В противном случае он не найдет дисплей для отображения окна TeamViewer! ${NC}"
echo -e "${CYAN}:: ${NC}Вы сможете выполнить запуск сервиса TeamViewer'a (teamviewerd) позже, воспользовавшись скриптом как шпаргалкой! (😃)"
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами. "
# Be careful! In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да запускаем и добавляем,     0 - НЕТ - Пропустить действие: " set_teamviewer  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$set_teamviewer" =~ [^10] ]]
do
    :
done
if [[ $set_teamviewer == 0 ]]; then
  echo ""
  echo "  Запуск и добавление в автозапуск сервиса TeamViewer'a (teamviewerd) пропущено "
elif [[ $set_teamviewer == 1 ]]; then
  echo ""
  echo " Запускаем сервис TeamViewer'a (teamviewerd) "
sudo systemctl start teamviewerd
echo " Добавляем в автозапуск сервис TeamViewer'a (teamviewerd) "
sudo systemctl enable teamviewerd
# sudo systemctl --system daemon-reload  # если его необходимо перезапустить
# Если TeamViewer не обнаруживает демон teamviewerd, вы можете переустановить демон следующим образом:
# sudo teamviewer --daemon enable
echo ""
echo " «Да будет так!!! Благодарю Тебя, Вселенная!», и вы увидите, как это начнет действовать мгновенно!))) "
sleep 2
fi
####################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Mumble (mumble) - Голосовой чат (связь по по IP (VoIP) клиент и сервер)?"
echo -e "${MAGENTA}:: ${BOLD}Mumble - это приложение для организации голосового чата, обеспечивающая низкую задержку и высокое качество связи, написанная на основе Qt и Opus. Проект является свободным, исходный код официальных клиентов и серверов открыты. Поддерживаются все основные операционные системы: Linux, MacOS и Windows, а также iOS и Android. Хорошую популярность имеет веб-клиент Mumble, который позволяет пользоваться голосовым чатом через веб-браузер. Mumble был первым VoIP-приложением, которое установило настоящую голосовую связь с низкой задержкой более десяти лет назад. Но низкая задержка и игры — не единственные сферы его применения. В Mumble есть два модуля: клиент (mumble) и Официальный сервер Mumble называется (murmur). Клиент работает на Windows, Linux, FreeBSD, OpenBSD и macOS, а сервер должен работать на всем, на что можно установить Qt.${NC}"
echo " Домашняя страница: https://www.mumble.info/ ; (https://archlinux.org/packages/extra/x86_64/mumble/). "  
echo -e "${MAGENTA}:: ${BOLD}Mumble имеет нормальные дэфолты для обычных пользователей и очень гибкие настройки для продвинутых. Основные возможности и особенности программы: Mumble включает серверную и клиентскую части. Минимальные задержки при передаче голоса. Высокое качество звука. Широко используется геймерами. Поддерживает автоматическое приглушение и увеличение громкости звука в играх в зависимости от расположения собеседников (позиционирование звука). Зашифрованная передача данных. Поддержка большого количества одновременных голосовых участников (более 100). Разграничение прав доступа. ${NC}"
echo " Также из соображений безопасности будет установлен пакет << i2pd >> в качестве I2P-роутера. (I2P Daemon) это полнофункциональная реализация I2P клиента на языке C++ . I2P (Невидимый Интернет Протокол) это универсальный анонимный сетевой уровень. Все соединения через I2P анонимны и используют сквозное (end-to-end) шифрование, участники не раскрывают свои настоящие IP адреса. Подобные сети обычно используются для анонимных peer-to-peer приложений (файлообмен, криптовалюты) и для анонимных клиент-серверных приложений (вебсайты, мессенджеры, чат-серверы). I2P позволяет людям со всего мира общаться и делиться информацией без ограничений 🔮 "
echo -e "${CYAN}:: ${NC}Установка Mumble сервер (mumble-server) проходит через сборку из AUR (yay). Если хотите можете собрать пакет через - git clone, PKGBUILD, makepkg - эта функция тоже прописана в сценарии скрипта, НО # закомментирована! " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить Mumble клиент (mumble),     2 - Установить Mumble сервер (mumble-server),

    0 - НЕТ - Пропустить установку: " in_mumble  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_mumble" =~ [^120] ]]
do
    :
done
if [[ $in_mumble == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_mumble == 1 ]]; then
  echo ""
  echo " Установка Mumble клиент (mumble) + I2P Daemon (i2pd) "
  echo " I2P - Невидимый Интернет Протокол. Мы строим сеть, которая позволяет людям общаться и обмениваться информацией без искусственных преград. Без цензуры. Без нарушений права на частную жизнь. Сеть без границ. Сделаем мир лучше! "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
########## mumble ############
sudo pacman -S --noconfirm --needed mumble  # Программное обеспечение для голосового чата высокого качества с открытым исходным кодом и низкой задержкой (клиент) ; https://www.mumble.info/ ; https://archlinux.org/packages/extra/x86_64/mumble/ ; 7 августа 2024 г., 2:51 UTC
########## mumble-git ############
# yay -S mumble-git --noconfirm  # Программное обеспечение для голосового чата высокого качества с открытым исходным кодом и низкой задержкой (версия git) ; https://www.mumble.info/ ; https://aur.archlinux.org/mumble-git.git (только для чтения, нажмите, чтобы скопировать) ; https://aur.archlinux.org/packages/mumble-git ; 2024-01-21 10:35 (UTC) ; Конфликты: с mumble
######### i2pd ##########
sudo pacman -S --noconfirm --needed i2pd  # Полнофункциональная реализация маршрутизатора I2P на языке C++ ; https://i2pd.website/ ; https://archlinux.org/packages/extra/x86_64/i2pd/ ; 6 августа 2024 г., 23:35 UTC
  echo ""
  echo " Время создать клиентские туннели! Для I2P Daemon (i2pd) "
  echo " При подключении к серверу указываем локальный адрес и порт, заданные в клиентском туннеле (127.0.0.1, 64738) "
  echo " После старта I2P-роутера требуется немного времени для создания туннелей, поэтому будьте готовы подождать минуту! "
  echo " Создать каталог (папку) tunnels.conf.d в /etc/i2pd/  "
#sudo mkdir /etc/i2pd/tunnels.conf.d   # Создать каталог /etc/i2pd/tunnels.conf.d
sudo mkdir -p /etc/i2pd/tunnels.conf.d   # Создать каталог /etc/i2pd/tunnels.conf.d
echo " Чтобы не засорять основной конфигурационный файл туннелей, создадим новый конфиг в директории /etc/i2pd/tunnels.conf.d/ "
echo " Создать файл mumble-client.conf в /etc/i2pd/tunnels.conf.d/ "
sudo touch /etc/i2pd/tunnels.conf.d/mumble-client.conf   # Создать файл /etc/i2pd/tunnels.conf.d/mumble-client.conf
ls -l /etc/i2pd   # ls — выводит список папок и файлов в текущей директории
sleep 1
echo " Теперь самое интересное - конфигурация туннелей I2P. Mumble использует протокол UDP для передачи потокового звука и TCP для управляющих команд, но в случае неполадок с UDP-соединением умеет работать без него. Правда, такой режим работы ощутимо дискомфортнее из-за задержек. Создадим два серверных туннеля: один для UDP, другой для TCP. "
echo " Пропишем Конфигурации I2P Daemon (i2pd) в /etc/i2pd/tunnels.conf.d/mumble-client.conf "
> /etc/i2pd/tunnels.conf.d/mumble-client.conf
cat <<EOF >>/etc/i2pd/tunnels.conf.d/mumble-client.conf
[mumble-client-tcp]
type = client
address = 127.0.0.1
port = 64738
destination = plpu63ftpi5wdr42ew7thndoyaclrjqmcmngu2az4tahfqtfjoxa.b32.i2p
destinationport = 64738
inbound.length = 1
outbound.length = 1
i2p.streaming.initialAckDelay = 20
crypto.ratchet.inboundTags = 500
keys = transient-mumble

[mumble-client-udp]
type = udpclient
address = 127.0.0.1
port = 64738
destination = plpu63ftpi5wdr42ew7thndoyaclrjqmcmngu2az4tahfqtfjoxa.b32.i2p
destinationport = 64738
keys = transient-mumble

EOF
###################
echo " Сделаем бэкап /etc/i2pd/tunnels.conf.d/mumble-client.conf "
echo " mumble-client.conf - Это будет основной файл настройки I2P Daemon (i2pd) для Mumble клиент (mumble) "
#cp /etc/i2pd/tunnels.conf.d/mumble-client.conf  /etc/i2pd/tunnels.conf.d/mumble-client.conf.back
sudo cp -v /etc/i2pd/tunnels.conf.d/mumble-client.conf  /etc/i2pd/tunnels.conf.d/mumble-client.conf.back_`date +"%d.%m.%y_%H-%M"` 
echo ""
echo " Просмотреть содержимое файла /etc/resolvconf/resolv.conf.d/base "
cat /etc/i2pd/tunnels.conf.d/mumble-client.conf  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 3
# Если вы используете брандмауэр , вам необходимо открыть порты TCP и UDP 64738. В зависимости от вашей сети вам также может потребоваться установить статический IP-адрес, переадресацию портов и т. д.
# sudo ufw allow 64738/tcp  # (Mumble)
# sudo ufw allow 64738/udp  # пользовательский Mumble-порт (например, порт 64738)
# Для подключения вам нужно будет узнать IP-адрес вашего сервера. Если вы не знаете IP-адрес вашего сервера, войдите/ssh на ваш сервер и введите эту команду:
# ip -s a  # простой способ проверить ip в linux
# curl ifconfig.io  # выведет только одну строку, которая будет IP-адресом вашего сервера.
# sudo pacman -Rs mumble  # В случае возникновения ошибок при установке пакета попробуйте выполнить команду ниже и повторите предыдущие команды.
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_mumble == 2 ]]; then
  echo ""
  echo " Установка Mumble сервер (mumble-server) + I2P Daemon (i2pd) "
  echo " I2P - Невидимый Интернет Протокол. Мы строим сеть, которая позволяет людям общаться и обмениваться информацией без искусственных преград. Без цензуры. Без нарушений права на частную жизнь. Сеть без границ. Сделаем мир лучше! "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
########## mumble-server ############
sudo pacman -S --noconfirm --needed mumble-server  # Программное обеспечение для голосового чата высокого качества с открытым исходным кодом и низкой задержкой (сервер) ; https://www.mumble.info/ ; https://archlinux.org/packages/extra/x86_64/mumble-server/ ; 7 августа 2024 г., 2:51 UTC ; Конфликты: с murmur<1.5
########## murmur-git ############
# yay -S murmur-git --noconfirm  # Программное обеспечение для голосового чата высокого качества с открытым исходным кодом и низкой задержкой (версия git) ; https://www.mumble.info/ ; https://aur.archlinux.org/murmur-git.git (только для чтения, нажмите, чтобы скопировать) ; https://aur.archlinux.org/packages/murmur-git ; 2022-06-17 16:04 (UTC) ; Конфликты: с murmur, murmur-ice, murmur-static
########## umurmur ############
# sudo pacman -S --noconfirm --needed umurmur  # Минималистичный сервер Mumble ; https://github.com/umurmur/umurmur ; https://archlinux.org/packages/extra/x86_64/umurmur/ ; 22 июня 2024 г., 7:24 утра UTC ; uMurmur — это минималистичный сервер Mumble, в первую очередь ориентированный на работу на встраиваемых компьютерах, таких как маршрутизаторы, с открытой ОС, например OpenWRT. Серверная часть Mumble называется Murmur, отсюда и название uMurmur. Он доступен в виде предварительно скомпилированного пакета для довольно большого количества дистрибутивов. Проверьте репозиторий пакетов вашего дистрибутива. 
######### i2pd ##########
sudo pacman -S --noconfirm --needed i2pd  # Полнофункциональная реализация маршрутизатора I2P на языке C++ ; https://i2pd.website/ ; https://archlinux.org/packages/extra/x86_64/i2pd/ ; 6 августа 2024 г., 23:35 UTC
  echo ""
  echo " Время создать клиентские туннели! Для I2P Daemon (i2pd) "
  echo " При подключении к серверу указываем локальный адрес и порт, заданные в клиентском туннеле (127.0.0.1, 64738) "
  echo " После старта I2P-роутера требуется немного времени для создания туннелей, поэтому будьте готовы подождать минуту! "
  echo " Создать каталог (папку) tunnels.conf.d в /etc/i2pd/  "
#sudo mkdir /etc/i2pd/tunnels.conf.d   # Создать каталог /etc/i2pd/tunnels.conf.d
sudo mkdir -p /etc/i2pd/tunnels.conf.d   # Создать каталог /etc/i2pd/tunnels.conf.d
echo " Чтобы не засорять основной конфигурационный файл туннелей, создадим новый конфиг в директории /etc/i2pd/tunnels.conf.d/ "
echo " Создать файл mumble-server.conf в /etc/i2pd/tunnels.conf.d/ "
sudo touch /etc/i2pd/tunnels.conf.d/mumble-server.conf   # Создать файл /etc/i2pd/tunnels.conf.d/mumble-server.conf
ls -l /etc/i2pd   # ls — выводит список папок и файлов в текущей директории
sleep 1
echo " Теперь самое интересное - конфигурация туннелей I2P. Mumble использует протокол UDP для передачи потокового звука и TCP для управляющих команд, но в случае неполадок с UDP-соединением умеет работать без него. Правда, такой режим работы ощутимо дискомфортнее из-за задержек. Создадим два серверных туннеля: один для UDP, другой для TCP. "
echo " Пропишем Конфигурации I2P Daemon (i2pd) в /etc/i2pd/tunnels.conf.d/mumble-server.conf "
> /etc/i2pd/tunnels.conf.d/mumble-server.conf
cat <<EOF >>/etc/i2pd/tunnels.conf.d/mumble-server.conf
[mumble-server-tcp]
type = server
host = 127.0.0.1
port = 64738
inport = 64738
inbound.length = 1
outbound.length = 1
i2p.streaming.initialAckDelay = 20
crypto.ratchet.inboundTags = 500
keys = mumble.dat

[mumble-server-udp]
type = udpserver
host = 127.0.0.1
address = 127.0.0.1
port = 64738
inport = 64738
keys = mumble.dat

EOF
###################
echo " Сделаем бэкап /etc/i2pd/tunnels.conf.d/mumble-server.conf "
echo " mumble-server.conf - Это будет основной файл настройки I2P Daemon (i2pd) для Mumble сервер (mumble-server) "
sudo cp -v /etc/i2pd/tunnels.conf.d/mumble-server.conf  /etc/i2pd/tunnels.conf.d/mumble-server.conf.back_`date +"%d.%m.%y_%H-%M"` 
echo ""
echo " Просмотреть содержимое файла /etc/etc/i2pd/tunnels.conf.d/mumble-server.conf "
cat /etc/i2pd/tunnels.conf.d/mumble-server.conf  # cat читает данные из файла или стандартного ввода и выводит их на экран
sleep 3
# Если вы используете брандмауэр , вам необходимо открыть порты TCP и UDP 64738. В зависимости от вашей сети вам также может потребоваться установить статический IP-адрес, переадресацию портов и т. д.
# sudo ufw allow 64738/tcp  # (Mumble)
# sudo ufw allow 64738/udp  # пользовательский Mumble-порт (например, порт 64738)
# Для подключения вам нужно будет узнать IP-адрес вашего сервера. Если вы не знаете IP-адрес вашего сервера, войдите/ssh на ваш сервер и введите эту команду:
# ip -s a  # простой способ проверить ip в linux
# curl ifconfig.io  # выведет только одну строку, которая будет IP-адресом вашего сервера.
echo ""
echo " Добавляем в автозапуск сервис Mumble сервер (mumble-server.service) "
sudo systemctl enable mumble-server.service   # Добавляем в автозапуск сервис mumble-server.service
echo " Запускаем сервис Mumble сервер (mumble-server.service) "
sudo systemctl start mumble-server.service  # Включить сервис mumble-server.service
echo " Если все прошло гладко, у вас должен быть работающий сервер Murmur "
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
########## Справка и Дополнения ##########
# Mumble — приложение для голосового общения. VoIP клиент и сервер.
# https://www.mumble.com/
# https://mumble.ru/
# https://www.mumble.info/
# https://github.com/mumble-voip/mumble
# https://archlinux.org/packages/extra/x86_64/mumble/
# https://docs.vultr.com/setup-mumble-server-on-arch-linux
# https://wiki.archlinux.org/title/Mumble
# I2P - Сеть без границ  
# https://i2pd.website/
# https://github.com/PurpleI2P/i2pdbrowser/releases/latest
# Настройка клиента Mumble
# https://mumble.ru/forum/viewtopic.php?t=26
# https://habr.com/ru/articles/577364/
# SSL/TLS
# Получите либо самоподписанный сертификат, как описано в OpenSSL , либо публично доверенный сертификат от Lets Encrypt .
# Отредактируйте mumble-server.ini и укажите, где находятся ваш ключ и сертификат:
# sudo nano /etc/mumble-server.ini
# /etc/mumble/mumble-server.ini
# sslCert=/etc/letsencrypt/live/$domain/cert.pem
# sslKey=/etc/letsencrypt/live/$domain/privkey.pem
# sslCA=/etc/letsencrypt/live/$domain/fullchain.pem
# Совет: SIGUSR1 может использоваться для динамической перезагрузки настроек SSL, начиная с версии 1.3.0 .
# Например, если используется модуль certbot systemd , добавление этого в конец строки ExecStartв файле модуля приведет к перезагрузке сертификата после выдачи нового:
# --deploy-hook "/usr/bin/killall -SIGUSR1 mumble-server"
# Для подключения вам нужно будет узнать IP-адрес вашего сервера. Если вы не знаете IP-адрес вашего сервера, войдите/ssh на ваш сервер и введите эту команду:
# ip -s a  # простой способ проверить ip в linux
# curl ifconfig.io  # выведет только одну строку, которая будет IP-адресом вашего сервера.
#########################










##########################
clear
echo -e "${CYAN}
  <<< Установка Менеджера закачек (Диспетчер загрузок) для системы Arch Linux >>> ${NC}"
# Installing the download manager for the Arch Linux system
echo ""
echo -e "${BLUE}:: ${NC}Установить uGet Download Manager (менеджер загрузок)?"
echo -e "${MAGENTA}:: ${BOLD}uGet - это универсальный менеджер закачек, который сочетает в себе легкое использование ресурсов с очень мощным набором функций: поддерживает докачку файлов, сортировку по группам, закачку через торренты и мета-ссылки (с помощью плагина aria2). Это отличный менеджер загрузок с большим количеством функций. ${NC}"
echo " Домашняя страница: https://ugetdm.com/ ; (https://archlinux.org/packages/extra/x86_64/uget/). "
echo -e "${MAGENTA}:: ${BOLD}Отслеживайте различные типы файлов, и всякий раз, когда вы добавляете их в буфер обмена, uGet будет спрашивать, хотите ли вы загрузить эти файлы. – также работает с пакетными загрузками. Пакетная загрузка позволяет пользователю добавлять неограниченное количество файлов в очередь для автоматической загрузки. Несколько зеркал позволяют вам загружать один файл с множества разных серверов, объединяя их после завершения. uGet поддерживает несколько протоколов для загрузки. ${NC}"
echo " Скачивайте файлы несколькими сегментами, чтобы увеличить скорость загрузки. uGet поддерживает до 16 одновременных подключений на одну загрузку. Помещает загрузки в очередь для одновременной загрузки любого количества файлов в зависимости от предпочтений пользователя для каждой категории. Приостановка и возобновление загрузки позволяет временно приостанавливать загрузку, не начиная ее с самого начала. "
echo " Отмечу возможность создавать категории для закачек, чтобы было удобнее разбираться в загруженных файлах. Каждую категорию можно настроить определенным образом. В uGet есть простой планировщик, который позволяет установить часы и дни, в которые программа может скачивать файлы. Это удобно, если у вас почасовая тарификация трафика или, например, вы хотите запускать все закачки ночью. Иконка программы добавляется в область задач (трей). При клике на нее всплывает вспомогательное меню. uGet полностью переведен на русский язык и доступен для Linux и Windows (есть portable версия программы). "
echo " uGet разработан таким образом, что он автоматически настраивает свой внешний вид на основе цветовой схемы и значков операционной системы, на которой он установлен. uGet мгновенно работает со светлыми, темными и гибридными темами благодаря этому механизму настройки. uGet предлагает интеграцию браузера благодаря расширению сообщества «uget-chrome-wrapper». Это расширение поддерживает Firefox, Google Chrome, Chromium, Opera и Vivaldi. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_uget  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_uget" =~ [^10] ]]
do
    :
done
if [[ $in_uget == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_uget == 1 ]]; then
  echo ""
  echo " Установка uGet (менеджер загрузок) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed gstreamer  # Мультимедийная графическая структура - ядро ; https://gstreamer.freedesktop.org/ ; https://archlinux.org/packages/extra/x86_64/gstreamer/
sudo pacman -S --noconfirm --needed libnotify  # Библиотека для отправки уведомлений на рабочий стол ; https://gitlab.gnome.org/GNOME/libnotify ; https://archlinux.org/packages/extra/x86_64/libnotify/
sudo pacman -S --noconfirm --needed aria2  # это легкая многопротокольная и многоисточниковая утилита загрузки командной строки. Она поддерживает HTTP/HTTPS,FTP,SFTP, BitTorrent и Metalink ; https://aria2.github.io/ ; https://archlinux.org/packages/extra/x86_64/aria2/
sudo pacman -S --noconfirm --needed intltool  # Коллекция инструментов интернационализации ; https://launchpad.net/intltool ; https://archlinux.org/packages/extra/any/intltool/
sudo pacman -S --noconfirm --needed uget  # Менеджер загрузок GTK с классификацией загрузок и импортом HTML ; https://ugetdm.com/ ; https://archlinux.org/packages/extra/x86_64/uget/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
###############

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Steadyflow - Диспетчер загрузок?"
echo -e "${MAGENTA}:: ${BOLD}Steadyflow (Постоянный поток) - это менеджер закачек для Linux (диспетчер загрузок) на основе GTK+, который стремится к минимализму, простоте использования и чистой, гибкой кодовой базе. Он должен быть простым в управлении, будь то из графического интерфейса, командной строки или D-Bus. ${NC}"
echo " Домашняя страница: https://launchpad.net/steadyflow ; (https://archlinux.org/packages/extra/x86_64/steadyflow/). "  
echo -e "${MAGENTA}:: ${BOLD}Steadyflow Простой менеджер закачек для Linux. Имеет очень простой легковесный интерфейс и самую минимальную функциональность. Поддерживаются основные протоколы FTP, HTTP, HTTPS, SMB. В настройках можно выставить поведение при завершении загрузки, а также настроить уведомления. Программа использует библиотеки GTK+. ${NC}"
echo " Главное окно программы содержит управляющие кнопки и список закачек (загрузок). Вы можете добавить новую загрузку, приостановить/запустить/удалить, выполнить поиск по списку. В настройках можно выставить поведение при завершении загрузки (ничего не делать, открывать файл), а также настроить уведомления. На текущий момент другой функциональности не представлено. Доступно контекстное меню при клике правой кнопкой мыши на иконке приложения на Лаунчере. Для браузера Chromium / Google Chrome существует плагин, который добавляет в контекстное меню пункт «Download with Steadyflow» (скачать через Steadyflow). Про добавлении новой загрузки, Steadyflow автоматически подставляет адрес файла из буфера обмена (если в буфере находится URL файла). Автор Steadyflow — Майя Кожева <sikon@ubuntu.com>. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_steadyflow  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_steadyflow" =~ [^10] ]]
do
    :
done
if [[ $in_steadyflow == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_steadyflow == 1 ]]; then
  echo ""
  echo " Установка Steadyflow "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed steadyflow  # Простой менеджер загрузок для GNOME GTK+; https://launchpad.net/steadyflow ; https://archlinux.org/packages/extra/x86_64/steadyflow/ ; https://man.archlinux.org/man/steadyflow.1.en ; https://www.youtube.com/watch?v=QAw27ldV3wE
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
######### Справка ##################
# Steadyflow : A Simple Download Manager For Linux Mint /Ubuntu
# https://www.youtube.com/watch?v=QAw27ldV3wE
######################
# Steadyflow добавить [url] : steadyflow add [url]
# Добавить файл для загрузки. Если url не указан, заполняет диалог добавления содержимым буфера обмена, если это допустимый URL.
# Для браузера Chromium / Google Chrome существует плагин, который добавляет в контекстное меню пункт «Download with Steadyflow» (скачать через Steadyflow). Про добавлении новой загрузки, Steadyflow автоматически подставляет адрес файла из буфера обмена (если в буфере находится URL файла).
# Расширение для Chromium/Google Chrome можно найти по адресу:  https:/ /launchpad. net/chromeflow .
# Автор Steadyflow — Майя Кожева <sikon@ubuntu.com>.
################################


clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Kget - Менеджер загрузок?"
echo -e "${MAGENTA}:: ${BOLD}KGet — универсальный и удобный менеджер загрузок. Распространяется согласно GNU General Public License. По умолчанию используется для Konqueror. ${NC}"
echo " Домашняя страница: Kget https://apps.kde.org/kget/ ; (https://archlinux.org/packages/extra/x86_64/kget/). "  
echo -e "${MAGENTA}:: ${BOLD}Поклонники сообщества KDE должны серьезно подумать о KGet. Этот удобный для новичков менеджер загрузок в сочетании с KDE-проектом упорядочат ваши загрузки, но не перегрузит вас категориями или настройками. Как и в случае с другими менеджерами, приостановка и возобновление загрузки входит в стандартную комплектацию. Он хорошо интегрируется с Conqueror, браузером KDE по умолчанию. Он также поставляется с поддержкой загрузок по FTP и BitTorrent, поэтому может быть хорошей альтернативой стандартным BitTorrent-клиентам, таким как Transmission или Deluge. ${NC}"
echo " Функции: Загрузка файлов из источников FTP и HTTP(S). Приостановка и возобновление загрузки файлов, а также возможность перезапуска загрузки. Сообщает много информации о текущих и ожидающих загрузки файлах. Встраивание в системный трей. Интеграция с веб-браузером Konqueror. Поддержка Metalink, которая содержит несколько URL-адресов для загрузки, а также контрольные суммы и другую информацию. " 
echo " Настройки: открываем программу закладка «Настройки», выбираем вкладку «Сеть». Выбираем количество загрузок, в нашем случае не более 2х. Далее выбираем вкладку «модули» и убираем все галочки кроме выделенных. На вкладке справа «многопоточная загрузка» нажимаем значёк ключа чтобы войти в настройки и выбираем количество потоков — 1 дабы не было проблем с загрузкой. Применяем настройки и можем тестировать. В углу экрана появится значёк винчестера с зелёной стрелкой. Прямо на этот значёк можно и перетягивать свои ссылки, и после вопроса о месте сохранения файла начнётся загрузка. Всё, можно пользоваться :-) "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_kget  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_kget" =~ [^10] ]]
do
    :
done
if [[ $in_kget == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_kget == 1 ]]; then
  echo ""
  echo " Установка Kget "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed kget  # Менеджер загрузок ; https://apps.kde.org/kget/ ; https://archlinux.org/packages/extra/x86_64/kget/
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#############

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Persepolis Download Manager - Менеджер закачек?"
echo -e "${MAGENTA}:: ${BOLD}Persepolis Download Manager — кроссплатформенный менеджер закачек. Предназначена для скачивания файлов из интернета. Позволяет настроить закачки по расписанию. Persepolis — это менеджер загрузок и графический интерфейс для aria2. Он написан на Python. Persepolis — это пример свободного программного обеспечения с открытым исходным кодом. Он разработан для дистрибутивов GNU/Linux, BSD, macOS и Microsoft Windows. Вы можете присоединиться к участникам Persepolis и помочь нам с его разработкой. Программа представляет собой интерфейс для библиотеки управления загрузкой файлов aria2. ${NC}"
echo " Домашняя страница: Kget https://persepolisdm.github.io/ ; (https://archlinux.org/packages/extra/any/persepolis/). "  
echo -e "${MAGENTA}:: ${BOLD}Основные возможности программы Persepolis Download Manager: Организация списка загрузок. Размещение загрузок по категориям (по очередям). Загрузка файлов по расписанию. Выбор времени начала запуска и времени завершения скачивания. Прерывание и дозакачка файлов. Поддержка импорта закачек путем перетаскивания ссылок из браузера (Drag & Drop). Загрузка видео с видео-сервисов (через пункт меню Video Finder) ( с Youtube, Vimeo, DailyMotion, ...). Поддержка тем оформления. ${NC}"
echo " Индивидуальные настройки для каждого файла: Настройка Proxy; Имя пользователя и пароль для доступа; Ограничение скорости; Результирующая директория; Количество одновременных соединений; Закачка по расписанию; Передача параметров Referrer, Header, User agent, Load cookies. Persepolis действует как диспетчер загрузки, скачивая файлы по одному, и идеально подходит, если вы хотите загружать файлы в большом количестве за одну ночь. Он позволяет возобновлять любые приостановленные или прерванные загрузки и, с расширениями для Chrome и Firefox, интегрируется напрямую в существующие браузеры. " 
echo " Интерфейс и внешний вид: Главное окно программы в левой части содержит список категорий закачек (очередей). Справа расположена таблица со списком закачек в выбранной категории. Сверху расположена панель управления с кнопками и меню (в зависимости от настроек меню может быть сгруппировано в отдельную кнопку панели управления). Программа поддерживает смену тем оформления. Программа не переведена на русский язык. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_persepolis  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_persepolis" =~ [^10] ]]
do
    :
done
if [[ $in_persepolis == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_persepolis == 1 ]]; then
  echo ""
  echo " Установка Persepolis Download Manager "
sudo pacman -Syy  # обновление баз пакмэна (pacman)  
sudo pacman -S --noconfirm --needed aria2  # это легкая многопротокольная и многоисточниковая утилита загрузки командной строки. Она поддерживает HTTP/HTTPS,FTP,SFTP, BitTorrent и Metalink ; https://aria2.github.io/ ; https://archlinux.org/packages/extra/
sudo pacman -S --noconfirm --needed ffmpeg  # Комплексное решение для записи, конвертации и потоковой передачи аудио и видео ; https://ffmpeg.org/ ; https://archlinux.org/packages/extra/x86_64/ffmpeg/
sudo pacman -S --noconfirm --needed libnotify  # Библиотека для отправки уведомлений на рабочий стол ; https://gitlab.gnome.org/GNOME/libnotify ; https://archlinux.org/packages/extra/x86_64/libnotify/
sudo pacman -S --noconfirm --needed libpulse  # Многофункциональный универсальный звуковой сервер (клиентская библиотека) ; https://www.freedesktop.org/wiki/Software/PulseAudio/ ; https://archlinux.org/packages/extra/x86_64/libpulse/
sudo pacman -S --noconfirm --needed pyside6  # Позволяет использовать API Qt6 в приложениях Python ; https://www.qt.io/ ; https://archlinux.org/packages/extra/x86_64/pyside6/
sudo pacman -S --noconfirm --needed python-psutil  # Кроссплатформенный модуль процессов и системных утилит для Python ; https://github.com/giampaolo/psutil ; https://archlinux.org/packages/extra/x86_64/python-psutil/
sudo pacman -S --noconfirm --needed python-setproctitle  # Позволяет процессу Python изменять название своего процесса ; https://github.com/dvarrazzo/py-setproctitle ; https://archlinux.org/packages/extra/x86_64/python-setproctitle/
sudo pacman -S --noconfirm --needed yt-dlp  # Форк youtube-dl с дополнительными функциями и исправлениями ; https://github.com/yt-dlp/yt-dlp ; https://archlinux.org/packages/extra/any/yt-dlp/
sudo pacman -S --noconfirm --needed persepolis  # Интерфейс Qt для менеджера загрузок aria2 ; https://persepolisdm.github.io/ ; https://archlinux.org/packages/extra/any/persepolis/
# yay -S persepolis-git --noconfirm  # Интерфейс Qt для менеджера загрузок aria2 (версия Github) ; https://aur.archlinux.org/persepolis-git.git (только для чтения, нажмите, чтобы скопировать) ; https://persepolisdm.github.io/ ; https://aur.archlinux.org/packages/persepolis-git
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#############
# Запустить программу можно из главного меню вашего дистрибутива или из командной строки, выполнив:
# persepolis
# Persepolis Download Manager 4.1.0
# https://www.youtube.com/watch?v=QHdMShFgzhQ
############################



clear
echo -e "${CYAN}
  <<< Обновление информации о шрифтах >>> ${NC}"
# Updating font information and creating a backup of grub.cfg and grub files.

echo ""
echo -e "${BLUE}:: ${NC}Обновим информацию о шрифтах"
#echo 'Обновим информацию о шрифтах'
# Update information about fonts
sudo fc-cache -f -v

clear
echo -e "${CYAN}
  <<< Очистка кэша pacman, и Удаление всех пакетов-сирот (неиспользуемых зависимостей) >>>
${NC}"
# Clearing the pacman cache, and Removing unused dependencies.
echo ""
echo -e "${YELLOW}==> Примечание: ${NC}Если! Вы сейчас устанавливали "AUR Helper"-'yay' (не yay-bin), а также Snap (пакет snapd) вместе с ними установилась зависимость 'go' - (Основные инструменты компилятора для языка программирования Go), который весит 559,0 МБ. Так, что если вам не нужна зависимость 'go', для дальнейшей сборки пакетов в установленной системе СОВЕТУЮ удалить её. В случае, если "AUR"-'yay', Snap (пакет snapd) НЕ БЫЛИ установлены, или зависимость 'go' была удалена ранее, то пропустите этот шаг."
echo ""
echo -e "${BLUE}:: ${BOLD}Удаление зависимости 'go' после установки "AUR Helper"-'yay', Snap (пакет snapd). ${NC}"
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да удалить зависимость 'go',     0 - Нет пропустить этот шаг: " rm_tool  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$rm_tool" =~ [^10] ]]
do
    :
done
if [[ $rm_tool == 0 ]]; then
  echo ""
echo " Удаление зависимости 'go' пропущено "
elif [[ $rm_tool == 1 ]]; then
echo ""
# sudo pacman -Rs go
#pacman -Rs go
sudo pacman --noconfirm -Rs go    # --noconfirm  --не спрашивать каких-либо подтверждений
 echo ""
 echo " Удаление зависимость 'go' выполнено "
fi

### Clean pacman cache (Очистить кэш pacman) ####
clear
echo ""
echo -e "${BLUE}:: ${BOLD}Очистка кэша pacman 'pacman -Sc' ${NC}"
echo -e "${CYAN}=> ${NC}Очистка кэша неустановленных пакетов (оставив последние версии оных), и репозиториев..."
sudo pacman --noconfirm -Sc  # Очистка кэша неустановленных пакетов (оставив последние версии оных) # --noconfirm  -не спрашивать каких-либо подтверждений

echo ""
echo -e "${CYAN}=> ${NC}Удалить кэш ВСЕХ установленных пакетов 'pacman -Scc' (высвобождая место на диске)?"
echo " Процесс удаления кэша ВСЕХ установленных пакетов - НЕ был прописан полностью автоматическим, и было принято решение дать возможность пользователю сделать выбор! "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да удалить кэш,     0 - Нет пропустить этот шаг: " rm_cache  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$rm_cache" =~ [^10] ]]
do
    :
done
if [[ $rm_cache == 0 ]]; then
echo ""
echo " Удаление кэша ВСЕХ установленных пакетов пропущено "
elif [[ $rm_cache == 1 ]]; then
sudo pacman -Scc  # Удалит кеш всех пакетов (можно раз в неделю вручную запускать команду)
#sudo pacman --noconfirm -Scc  # --noconfirm  --не спрашивать каких-либо подтверждений
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Посмотрим список всех пакетов-сирот (которые не используются ни одной программой)"
#echo " Посмотрим список всех пакетов-сирот "
# echo 'Список всех пакетов-сирот'
# List of all orphan packages
sudo pacman -Qdt  # Посмотреть, какие пакеты не используются ничем в системе
#sudo pacman -Qdtq  # Посмотреть, какие пакеты не используются ничем в системе(показать меньше информации для запроса и поиска)
# -----------------------------------
# -Q --query  # Запрос к базе данных
# -d, --deps  # список пакетов, установленных как зависимости
# -t, --unrequired  # список пакетов не (опционально) требуемых
# какими-либо пакетами (-tt для игнорирования optdepends)
# -q, --quiet  # показать меньше информации для запроса и поиска
# ------------------------------------
sleep 3

echo ""
echo -e "${CYAN}=> ${NC}Удаление всех пакетов-сирот (неиспользуемых зависимостей) 'pacman -Qdtq'..."
echo " Процесс удаления всех пакетов-сирот (неиспользуемых зависимостей) - НЕ был прописан полностью автоматическим, и было принято решение дать возможность пользователю сделать выбор. "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Если Вы сомневаетесь в своих действиях, ещё раз обдумайте..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да удалить все пакеты-сироты,     0 - Нет пропустить этот шаг: " rm_orphans  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$rm_orphans" =~ [^10] ]]
do
    :
done
if [[ $rm_orphans == 0 ]]; then
echo ""
echo " Удаление всех пакетов-сирот (неиспользуемых зависимостей) пропущено "
elif [[ $rm_orphans == 1 ]]; then
echo ""
echo " Удаление всех пакетов-сирот (неиспользуемых зависимостей) "
#sudo pacman --noconfirm -Rcsn $(pacman -Qdtq)  # --noconfirm (не спрашивать каких-либо подтверждений), -R --remove (Удалить пакет(ы) из системы), -c, --cascade (удалить пакеты и все пакеты, которые зависят от них), -s, --recursive (удалить ненужные зависимости), -n, --nosave (удалить конфигурационные файлы)
sudo pacman -Rsn $(pacman -Qdtq) && rm -rf ~/.cache/thumbnails/* && rm -rf ~/.build/*
#sudo pacman -Rsn $(pacman -Qqtd)  # удаляет пакеты-сироты (которые не используются ни одной программой)
#sudo rm -rf ~/.cache/thumbnails/*  # удаляет миниатюры фото, которые накапливаются в системе
#sudo rm -rf ~/.build/*  #
# или эта команда:
# sudo pacman -Rsn $(pacman -Qdtq)
### fc-cache -vf
# sudo pacman -Scc && sudo pacman -Rsn $(pacman -Qdtq) && rm -rf ~/.cache/thumbnails/* && rm -rf ~/.build/*
echo ""
echo " Удаление всех пакетов-сирот (неиспользуемых зависимостей) выполнено "
fi

echo ""
echo -e "${BLUE}:: ${NC}Удаление созданной папки (downloads), и скрипта установки программ (archmy3l)"
#echo " Удаление созданной папки (downloads), и скрипта установки программ (archmy3l) "
#echo ' Удаление созданной папки (downloads), и скрипта установки программ (archmy3l) '
# Deleting the created folder (downloads) and the program installation script (archmy3l)
echo -e "${YELLOW}==> Примечание: ${NC}Если таковая (папка) была создана изначально!"
# If it was created initially!
echo " Будьте внимательны! Процесс удаления, был прописан полностью автоматическим. "
# Be careful! Removal process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again...
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да удалить папку (downloads),     0 - Нет пропустить этот шаг: " rm_down  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$rm_down" =~ [^10] ]]
do
    :
done
if [[ $rm_down == 0 ]]; then
echo ""
echo " Удаление пропущено "
elif [[ $rm_down == 1 ]]; then
echo ""
echo " Удаление папки (downloads), и скрипта установки программ (archmy3l) "
sudo rm -R ~/downloads/  # Если таковая (папка) была создана изначально
sudo rm -rf ~/archmy3l  # Если скрипт не был перемещён в другую директорию
echo " Удаление выполнено "
fi

clear
echo -e "${CYAN}
  <<< Посмотрим и Сохраним список установленного софта (пакетов) >>>
${NC}"
# Let's see and Save the list of installed software (packages).

echo ""
echo -e "${BLUE}:: ${NC}Посмотрим список установленного софта (пакетов)?"
#echo " Посмотрим список Установленного софта (пакетов) "
# echo 'Список Установленного софта (пакетов)'
# List of Installed software (packages)
echo " Список пакетов для просмотра - будет доступен (по времени) в течении 1-ой минуты! "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Вы можете пропустить это действие..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да вывести список софта (пакетов),     0 - Нет пропустить этот шаг: " t_list  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_list" =~ [^10] ]]
do
    :
done
if [[ $t_list == 0 ]]; then
echo ""
echo " Вывод списка установленного софта (пакетов) пропущен "
elif [[ $t_list == 1 ]]; then
echo ""
echo " Список установленного софта (пакетов) "
echo ""
sudo pacman -Qqe  # -Q --query  # Запрос к базе данных; -q, --quiet  # показать меньше информации для запроса и поиска; -e, --explicit  # список явно установленных пакетов (фильтр)
echo ""
sleep 60
fi

clear
echo ""
echo -e "${BLUE}:: ${NC}Сохранить список Установленного софта (пакетов)?"
#echo " Сохранить список Установленного софта (пакетов)? "
# Save a list of Installed software (packages)?
echo -e "${CYAN}=> ${NC}В домашней директории пользователя будет создана папка (pkglist), в которой будут созданы и сохранены .txt списки установленного софта (пакетов)..."
echo " Список пакетов будет создан как в подробном, так и в кратком виде - (подробно: pkglist_full.txt; .pkglist.txt; кратко: pkglist.txt; aurlist.txt) "
echo " В дальнейшем Вы можете удалить папку (pkglist), без последствий! "
echo -e "${YELLOW}==> ${NC} Будьте внимательны! Вы можете пропустить это действие..."
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да сохранить список софта (пакетов),     0 - Нет пропустить этот шаг: " set_pkglist  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$set_pkglist" =~ [^10] ]]
do
    :
done
if [[ $set_pkglist == 0 ]]; then
echo ""
echo " Сохранение списка установленного софта (пакетов) пропущено "
elif [[ $set_pkglist == 1 ]]; then
echo ""
echo " Создадим папку (pkglist) в домашней директории "
mkdir ~/pkglist
echo " Сохранение списка установленного софта (пакетов). Подробно "
LANG=C pacman -Sl | awk '/\[installed\]$/ {print $1 "/" $2 "-" $3}' > ~/pkglist/pkglist_full.txt
LANG=C pacman -Sl | awk '/\[installed\]$/ {print $2}' > ~/pkglist/.pkglist.txt
echo " Сохранение списка установленного софта (пакетов). Кратко "
sudo pacman -Qqe > ~/pkglist/pkglist.txt
sudo pacman -Qqm > ~/pkglist/aurlist.txt
echo " Сохранение списка установленного софта (пакетов) выполнено "
fi
###########################################
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
echo -e "${CYAN}:: ${NC}Цель скрипта (archmy4l) - это установка софта (пакетов), включая установку софта (пакетов) из 'AUR'-'yay', и запуск необходимых служб."
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
#fi
#clear
# Успех
#Success
#echo "Установка завершена! Перезагрузить."
#echo "Installation complete! Reboot."
##### Шпаргалка запуска необходимых служб #####
### sudo systemctl enable NetworkManager
### sudo systemctl enable bluetooth
### sudo systemctl enable cups.service
### sudo systemctl enable sshd
### sudo systemctl enable avahi-daemon
### sudo systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
### sudo systemctl enable reflector.timer
### sudo systemctl enable fstrim.timer
### sudo systemctl enable libvirtd
### sudo systemctl enable firewalld
### sudo systemctl enable acpid
###**************************
### sudo systemctl disable NetworkManager-wait-online.service
### sudo systemctl disable lvm2-monitor.service
### sudo systemctl disable bluetooth.service
### sudo systemctl disable ModemManager.service
### sudo systemctl disable smartmontools.service
### sudo systemctl disable motd-news.service
### sudo systemctl disable vboxautostart-service
###-------------------------------------------------
### end of script