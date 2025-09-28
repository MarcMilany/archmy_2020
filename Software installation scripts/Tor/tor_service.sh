#!/usr/bin/env bash
# Install script Mugshot
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

TOR_SERVICE="russian"  # Installer default language (Язык установки по умолчанию)

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
  <<< Установка утилит (пакетов) для Управления и анализа сетевого трафика в Archlinux 💻📡🌐 >>> ${NC}"
# Installing utilities (packages) for Managing and analyzing network traffic in Archlinux
echo ""
echo -e "${YELLOW}==> Примечание! ${BOLD} *Большинство людей очень щепетильно относятся к своей конфиденциальности, и им не нравится, когда их контролируют правительства, народы, организации и т.д.. Группа людей также может проживать в странах, где социальные сети и некоторые веб-сайты заблокированы, и им что-то нужно анонимно искать и скачивать в сети. Когда вы обычно посещаете веб-сайт, ваш компьютер устанавливает прямое TCP-соединение с сервером этого веб-сайта. Любой, кто следит за вашим интернетом, может прочитать TCP-пакет. Он может узнать, какой сайт вы посещаете и ваш IP-адрес, а также порт, к которому вы подключаетесь. Если вы используете HTTPS, никто не узнает, что именно было отправлено. Но иногда злоумышленнику достаточно знать лишь, к кому вы подключаетесь. Используя Tor, ваш компьютер никогда не взаимодействует с сервером напрямую. Tor создаёт запутанный путь через три узла Tor и отправляет данные по этому каналу. ${NC}"
sleep 15

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Tor (service)(tor) Torsocks (torsocks) — Сетевые утилиты (для конфиденциальности в сети)?"
echo -e "${YELLOW}==> Примечание! ${BOLD}*Tor – инструмент для анонимности, используемый людьми, стремящимися к приватности и борющимися с цензурой в интернете. Со временем Tor стал весьма и весьма неплохо справляться со своей задачей. Поэтому безопасность, стабильность и скорость этой сети критически важны для людей, рассчитывающих на неё. На самом высоком уровне Tor работает, перекидывая соединение вашего компьютера с целевыми (например, google.com) через несколько компьютеров-посредников, или ретрансляторов (relay). ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Tor (The Onion Router) — реализация второго поколения "луковой маршрутизации", технология анонимного обмена информацией через сеть Интернет. Эта система (технология) позволяет установить анонимное сетевое соединение защищённое от прослушивания и помогает защититься от различного рода сетевой слежки. С помощью Tor пользователи могут сохранять анонимность при посещении веб-сайтов, публикации материалов, отправке сообщений и при работе с другими приложениями, использующими протокол TCP. Tor является мультиплатформенным, поэтому вы можете использовать его на всех Gnu / Linux, Windows и Mac. Есть два случая, в которых вы можете использовать Tor: один - вам нужно установить мост для своей службы Tor, потому что в некоторых странах служба Tor может не быть использована, поэтому нам нужно протестировать некоторые мосты, а в другом случае вам просто нужно запустить этот сервис в Arch Linux. Этот проект Лицензируется под BSD-3-Clause, только LGPL-3.0, MIT. ${NC}"
echo " Домашняя страница: https://www.torproject.org/download/tor/ ; (https://gitlab.torproject.org/tpo/core/torsocks ; https://archlinux.org/packages/extra/x86_64/tor/ ; https://archlinux.org/packages/extra/x86_64/torsocks/). "
echo -e "${BLUE}:: ${NC}Функции: Использование Tor — отличный способ сохранить анонимность в интернете. Tor абсолютно бесплатен и настраивается всего за несколько минут. Вы сможете получить полный контроль над своим Tor-соединением, если потратите немного времени на понимание того, как работает порт управления, как мы показали в этой статье. Вы сможете обеспечить маскировку всей своей исходящей интернет-активности, независимо от того, используете ли вы веб-браузер или выполняете команды через терминал. Конечно, другие приложения также можно настроить для использования Tor, достаточно лишь настроить их на подключение к вашему локальному хосту SOCKS. "
echo -e "${CYAN}:: ${NC}*Что такое Torsocks? Torsocks позволяет вам безопасно использовать большинство приложений с Tor. Он обеспечивает безопасную обработку DNS-запросов и явно отклоняет любой трафик, отличный от TCP, от используемого вами приложения. Torsocks — это разделяемая библиотека ELF, которая загружается перед всеми остальными. Библиотека переопределяет все необходимые вызовы функций libc для интернет-коммуникаций, такие как connect или gethostbyname. Этот процесс прозрачен для пользователя, и если torsocks обнаруживает любую связь, которая не может пройти через сеть Tor, например, трафик UDP, соединение отклоняется. Если по какой-либо причине torsocks не может предоставить гарантию анонимности Tor вашему приложению, torsocks заставит приложение выйти и остановить все. *ProxyChains — это программа UNIX, которая перехватывает функции libc, связанные с сетью и перенаправляет соединения через SOCKS4a/5 или HTTP-прокси. Поддерживает только TCP (без UDP/ICMP и т. д.). "
echo -e "${YELLOW} Примечание! ${BOLD} *Если вы хотите запустить Tor с мостом obfs3, вам следует отредактировать текстовый файл «Torrc» (/etc/tor/torrc). Чтобы запустите службу Tor: (sudo systemctl start tor.service), далее нужно узнать статус Tor, готов сервис к работе: (sudo systemctl status tor.service). Теперь нужно добавить Tor в службы запуска, которые будут загружены после запуска Systemd, поэтому используйте эту команду и включите службу Tor: (sudo systemctl enable tor.service). По умолчанию Tor работает на порту 9050. ${NC}"
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - *Установить службы Tor Torsocks и тд...,     0 - НЕТ - Пропустить установку: " in_torify  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_torify" =~ [^10] ]]
do
    :
done
if [[ $in_torify == 0 ]]; then
  echo ""
  echo " Установка Сетевые утилиты, Tor Torsocks и тд... пропущена "
elif [[ $in_torify == 1 ]]; then
  echo ""
  echo " Установка утилит (пакетов) Tor Torsocks и тд... "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
################ прокси-сервер Tor #############
# sudo pacman -S --noconfirm --needed tor nyx torsocks gnu-netcat proxychains-ng
sudo pacman -S --noconfirm --needed tor  # Анонимизирующая оверлейная сеть ; https://archlinux.org/packages/extra/x86_64/tor/ ; https://www.torproject.org/download/tor/ ; 2025-07-17 13:33 UTC
  echo ""
  echo " Установка дополнительных утилит (пакетов) "
############ Зависимости ##############
sudo pacman -S --noconfirm --needed nyx  # Монитор состояния командной строки для Tor ; С его помощью вы можете получить подробную информацию в реальном времени о вашем ретрансляторе, такую как использование полосы пропускания, соединения, журналы и многое другое ; https://nyx.torproject.org/ ; https://archlinux.org/packages/extra/any/nyx/ ; 2024-12-22 13:52 UTC
sudo pacman -S --noconfirm --needed torsocks  # (необязательно) - для торифирования ; Оболочка для безопасной торификации приложений ; https://gitlab.torproject.org/tpo/core/torsocks ; https://archlinux.org/packages/extra/x86_64/torsocks/ ; https://archlinux.org/packages/extra/x86_64/torsocks/files/ ; 2023-05-19 17:21 UTC
sudo pacman -S --noconfirm --needed --noprogressbar --quiet proxychains-ng  # Предварительный загрузчик, позволяющий перенаправлять TCP-трафик существующих динамически связанных программ через один или несколько SOCKS- или HTTP-прокси ; https://github.com/rofl0r/proxychains-ng ; https://archlinux.org/packages/extra/x86_64/proxychains-ng/ ; Обеспечивает: proxychains ; Заменяет: proxychains ; Конфликты: с proxychains ; 2024-04-02 21:40 UTC
############# gnu-netcat ##################
yay -S gnu-netcat --noconfirm  # GNU-переписывание netcat, приложения сетевого конвейера ; https://aur.archlinux.org/packages/gnu-netcat ; https://aur.archlinux.org/gnu-netcat.git (только для чтения, нажмите, чтобы скопировать) ; http://netcat.sourceforge.net/ ; Обеспечивает: netcat ; Заменяет: netcat ; Обратные конфликты: с openbsd-netcat ; 2025-07-17 11:59 UTC
############# gnu-netcat ##################
#git clone https://aur.archlinux.org/gnu-netcat.git  # (только для чтения, нажмите, чтобы скопировать)
#cd gnu-netcat
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf gnu-netcat
#rm -Rf gnu-netcat
################
  echo ""
  echo " Посмотрите информацию о версии (psensor) "
# tor --version  # Показать версию приложения
sudo pacman -Q tor  #  Показать версию приложения
# torsocks --version  # Показать версию приложения
sudo pacman -Q torsocks  #  Показать версию приложения
sleep 03
  echo ""
  echo " Установка Сетевые утилиты, Tor Torsocks и тд... выполнена "
fi
sleep 03
############ Справка #####################
# tor-сервис (tor-service)
# Настраиваемая конфигурация Tor и файл службы systemd
# https://github.com/steampug/tor-service
# https://github.com/steampug/tor-service.git
##########################################

clear
echo ""
echo -e "${BLUE}:: ${NC}Установить Obfs4-Obfourscator (obfs4proxy) — Подключаемый транспортный прокси-сервер?"
echo -e "${YELLOW}==> Примечание! ${BOLD} *Это ни на что не похожий протокол обфускации, который включает в себя идеи и концепции из протокола ScrambleSuit Филиппа Винтера. Название obfs было выбрано в первую очередь потому, что оно было короче, а с точки зрения происхождения протокола obfs4 гораздо ближе к ScrambleSuit, чем obfs2/obfs3. ${NC}"
echo -e "${MAGENTA}:: ${BOLD}Obfs4-Obfourscator — подключаемый транспортный прокси-сервер, написанный на Go (этот пакет собран мной для тех, кто живет в странах с цензурой Tor и не может скачать исходный код в пакете obfs4proxy). Заметные различия между ScrambleSuit и obfs4: При обмене данными всегда происходит полный обмен ключами (нет такого понятия, как сеанс). При обмене данными по билету. Для подтверждения связи используется протокол ntor проекта Tor с открытыми ключами, запутанными с помощью сопоставления Elligator 2. При шифровании на канальном уровне используются секретные блоки NaCl (Poly1305/XSalsa20). В качестве дополнительного бонуса obfs4proxy также поддерживает работу в качестве клиента obfs2/3 и моста, что упрощает переход на новый протокол. Этот проект Лицензируется под BCD. ${NC}"
echo " Домашняя страница: https://gitlab.com/yawning/obfs4 ; (https://aur.archlinux.org/packages/obfs4proxy ; https://aur.archlinux.org/packages/obfs4proxy-bin). "
echo -e "${BLUE}:: ${NC}*Почему бы не расширить ScrambleSuit? Это мой протокол, и я могу запутать его, если захочу. Поскольку многие изменения касаются процесса подтверждения связи, расширять ScrambleSuit не имело смысла, поскольку написание серверной реализации, которая поддерживала бы оба варианта подтверждения связи и при этом не была бы неприлично медленной, является нетривиальной задачей. "
echo -e "${CYAN}:: ${NC}*Советы и рекомендации: В современных системах Linux можно привязать obfs4proxy к зарезервированным портам (<=1024), даже если они не запущены от имени пользователя root, предоставив возможность CAP_NET_BIND_SERVICE с помощью setcap: # setcap 'cap_net_bind_service=+ep' /usr/local/bin/obfs4proxy . obfs4proxy также может выступать в качестве клиента или сервера obfs2 и obfs3.  Соответствующим образом измените строки ClientTransportPlugin и ServerTransportPlugin в torrc. obfs4proxy также может выступать в качестве клиента ScrambleSuit.  Соответствующим образом отрегулируйте строку ClientTransportPlugin в torrc. Автоматически сгенерированные параметры моста obfs4 помещаются в DataDir/pt_state/obfs4_state.json.  Для упрощения развертывания строка моста на стороне клиента записывается в DataDir/pt_state/obfs4_bridgeline.txt. "
echo -e "${CYAN}:: ${NC}Установка Obfs4-Obfourscator (obfs4proxy) и (obfs4proxy-bin), проходит через сборку из исходников, которые устанавливаются из 'AUR' через 'yay' в зависимости от вашего выбора. Также в сценарии (скрипта) прописана установка с помощью git clone, PKGBUILD, makepkg - скачивается с сайта 'Arch Linux' (https://aur.archlinux.org/obfs4proxy.git), (https://aur.archlinux.org/obfs4proxy-bin.git) - собирается и устанавливается. Но эта функция закомментирована # , если нужно раскомментируйте или воспользуйтесь сценарием (скрипта) как шпаргалкой ! "
echo -e "${YELLOW} Примечание! ${BOLD} *Будьте внимательны! Процесс установки был прописан полностью автоматическим. В данной опции выбор всегда остаётся за вами. ${NC}"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Установить Obfs4-Obfourscator (obfs4proxy),  2 - Установить Obfs4-Obfourscator (obfs4proxy-bin),

    0 - НЕТ - Пропустить установку: " in_obfourscator  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_obfourscator" =~ [^120] ]]
do
    :
done
if [[ $in_obfourscator == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_obfourscator == 1 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Obfs4-Obfourscator (obfs4proxy) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) для прокси-сервера "
############ Зависимости ##############
################ прокси-сервер Tor #############
# sudo pacman -S --noconfirm --needed tor nyx torsocks gnu-netcat proxychains-ng
sudo pacman -S --noconfirm --needed tor  # Анонимизирующая оверлейная сеть ; https://archlinux.org/packages/extra/x86_64/tor/ ; https://www.torproject.org/download/tor/ ; 2025-07-17 13:33 UTC
########### obfs4proxy ###########
yay -S obfs4proxy --noconfirm  # Обфурскатор — подключаемый транспортный прокси, написанный на Go ; https://aur.archlinux.org/packages/obfs4proxy ; https://aur.archlinux.org/obfs4proxy.git (только для чтения, нажмите, чтобы скопировать) ; https://gitlab.com/yawning/obfs4 ; https://gitlab.com/yawning/obfs4/-/archive/obfs4proxy-0.0.14/obfs4-obfs4proxy-0.0.14.tar.bz2 ; 2025-05-20 13:30 (UTC)
########### obfs4proxy ###########
#git clone https://aur.archlinux.org/obfs4proxy.git  # (только для чтения, нажмите, чтобы скопировать)
#cd obfs4proxy
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf obfs4proxy
#rm -Rf obfs4proxy
  echo ""
  echo " Посмотрите информацию о версии (psensor) "
# obfs4proxy --version  # Показать версию приложения
sudo pacman -Q obfs4proxy  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
elif [[ $in_psensor == 2 ]]; then
  echo ""
  echo " Установка утилиты (пакета) Obfs4-Obfourscator (obfs4proxy-bin) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -Syyu  # --noconfirm --needed  # -y – обновить списки пакетов из репозиториев ; -u – обновить пакеты ; Ключ -Syyu является наиболее часто используемой опцией и служит для обновления системы и всех установленных пакетов
  echo ""
  echo " Установка дополнительных утилит (пакетов) для прокси-сервера "
############ Зависимости ##############
################ прокси-сервер Tor #############
# sudo pacman -S --noconfirm --needed tor nyx torsocks gnu-netcat proxychains-ng
sudo pacman -S --noconfirm --needed tor  # Анонимизирующая оверлейная сеть ; https://archlinux.org/packages/extra/x86_64/tor/ ; https://www.torproject.org/download/tor/ ; 2025-07-17 13:33 UTC
########### obfs4proxy-bin ###########
yay -S obfs4proxy-bin --noconfirm  # Obfourscator — подключаемый транспортный прокси-сервер, написанный на Go (этот пакет собран мной для тех, кто живет в странах с цензурой Tor и не может скачать исходный код в пакете obfs4proxy) ; https://aur.archlinux.org/packages/obfs4proxy-bin ; https://aur.archlinux.org/obfs4proxy-bin.git (только для чтения, нажмите, чтобы скопировать) ; https://gitlab.com/yawning/obfs4 ; Конфликты: obfs4proxy ; https://github.com/molaeiali/obfs4proxy-bin/raw/master/files.tar.xz ; 2022-09-09 12:04 (UTC)
########### obfs4proxy-bin ###########
#git clone https://aur.archlinux.org/obfs4proxy-bin.git  # (только для чтения, нажмите, чтобы скопировать)
#cd obfs4proxy-bin
# makepkg -fsri
# makepkg -si
#makepkg -si --noconfirm    #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf obfs4proxy-bin
#rm -Rf obfs4proxy-bin
  echo ""
  echo " Посмотрите информацию о версии (psensor) "
# obfs4proxy --version  # Показать версию приложения
sudo pacman -Q obfs4proxy  #  Показать версию приложения
sleep 03
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##############
### Для установки скопируйте файл ./obfs4proxy/obfsproxy в постоянное местоположение:
# (Например, /usr/local/bin)
# Конфигурация torrc на стороне клиента:
# ClientTransportPlugin obfs4 exec /usr/local/bin/obfs4proxy
# Конфигурация torrc на стороне моста:
# Действует как мостовой ретранслятор.
# BridgeRelay 1
# Включить расширенный ORPort
# Автоматический экспорт:
# Используйте obfs4proxy для обеспечения протокола obfs4.
# Подключите сервер к obfs4 exec /usr/local/bin/obfs4proxy.
# (Необязательно) Прослушивать указанный адрес/порт для подключения по obfs4 в качестве
# вместо автоматического выбора порта.
#ServerTransportListenAddr obfs4 0.0.0.0:443
###################################


clear
echo ""
echo -e "${GREEN}==> ${NC}Добавляем в автозагрузку Tor (tor.service) для конфиденциальности в сети?"
#echo 'Добавляем в автозагрузку Tor (tor.service) для для конфиденциальности в сети?'
echo -e "${YELLOW}:: ${BOLD}Запускаем сервис (tor.service), если таковой был вами установлен. ${NC}"
echo -e "${CYAN}:: ${NC}Вы сможете выполнить запуск (tor.service) позже, воспользовавшись скриптом как шпаргалкой!"
echo " Будьте внимательны! В любой ситуации выбор всегда остаётся за вами. "
# Be careful! In any situation, the choice is always yours.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... (😃) "
# If you doubt your actions, think again...
echo ""
while
#echo " Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter") "
#read -p " 1 - Да добавляем, 0 - НЕТ - Пропустить действие: " prog_set  # To confirm the input actions, click 'Enter' ; # Чтобы подтвердить действия ввода, нажмите кнопку 'Ввод' ("Enter")
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да добавляем,     0 - НЕТ - Пропустить действие: " auto_tor  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$auto_tor" =~ [^10] ]]
do
    :
done
if [[ $auto_tor == 0 ]]; then
echo ""
echo " Tor (service) не включен в автозагрузку, при необходиости это можно будет сделать. "
elif [[ $auto_tor == 1 ]]; then
  echo ""
  echo " Добавляем в автозагрузку Tor (tor.service) "
# sudo systemctl enable --now tor.service  # Запустить службу Tor
  sudo systemctl enable tor.service  # Добавляем в автозагрузку (tor.service), которые будут загружены после запуска Systemd
  sudo systemctl start tor.service  # запустите службу Tor
# sudo systemctl status tor.service  # статус сервиса tor
# sudo systemctl enable --now tor  #  включить и запустить демон Tor
# sudo journalctl -xeu tor  # лог сервиса tor
echo " Tor (tor.service) успешно добавлен в автозагрузку "
fi
############ Справка #####################
# Остановка сервиса tor:
# sudo systemctl start tor
# sudo systemctl stop tor
# Использование торсов:
# После установки torsocks просто запустите его следующим образом:
# $ torsocks [application]
# Так, например, вы можете использовать ssh для some.ssh.com, выполнив:
# $ torsocks ssh username@some.ssh.com
# Вы можете использовать библиотеку torsocks без предоставленного скрипта:
# $ LD_PRELOAD=/full/path/to/libtorsocks.so your_app
# Через некоторое время запустите эту команду, чтобы узнать, готов Tor или нет:
# $ sudo systemctl status tor.service
# По умолчанию Tor работает на порту 9050. Проверьте это.
#  $ systemctl status tor.service
#  $ ss -nlt
# Тестовое сетевое соединение Tor
# Проверьте ваш текущий публичный IP-адрес
#  $ wget -qO - https://api.ipify.org; echo
# Торифицируйте команду через torsocks
#  $ torsocks wget -qO - https://api.ipify.org; echo
#  $ ## # # должен показывать другой IP-адрес
# Торифицируйте свою оболочку:
# торифицировать оболочку, выдать
#  $ источник torsocks на
#  $ wget -qO - https://api.ipify.org; echo
#  $ # # необходимо показать IP-адрес узла Tor
# Чтобы включить его torsocks навсегда для всех новых оболочек, добавьте его в.bashrc
#  $ echo ". torsocks on" >> ~/.bashrc
#  $ source torsocks on
# Если вы хотите выключить torsocks, попробуйте
#  $ source torsocks off
# Включить порт управления Tor:
# Добавьте к вашему/etc/tor/torrc
#    ControlPort 9051
# Установить пароль управления Tor
# Преобразуйте свой пароль из обычного текста в хэш:
#  $ set +o history # сбросить историю bash
#  $ tor --hash-password ваш_пароль
#  $ set -o history #  установить историю bash
# Добавьте этот хэш к вашему/etc/tor/torrc
#  HashedControlPassword your_hash  # ваш_хэш
# Перезапуск tor
#  $ sudo systemctl restart tor.service
# Проверьте статус порта 9051
#   $ ss -nlt
# Чтобы проверить ваше tor использование
# $ echo -e 'PROTOCOLINFO\r\n' | nc 127.0.0.1 9051
###   echo -e ' ИНФОРМАЦИЯ О ПРОТОКОЛЕ\r\n '  | nc 127.0.0.1 9051
# Чтобы запросить новый канал (IP-адрес) от Tor, используйте
#  $ set +o history
#  $ echo -e 'AUTHENTICATE "my-tor-password"\r\nsignal NEWNYM\r\nQUIT' | nc 127.0.0.1 9051
###   echo -e ' АУТЕНТИФИКАЦИЯ "my-tor-password"\r\nsignal NEWNYM\r\nВЫЙТИ '  | nc 127.0.0.1 9051
#  $ set -o history
####################################

Мосты

По сути, мосты – непубликуемые в общем доступе узлы. Пользователи, оказавшиеся за стеной цензуры, могут использовать их для доступа в сеть Tor. Но если они не публикуются, как пользователи знают, где их искать? Не нужен ли какой-нибудь особый список? Поговорим о нём позже, но коротко говоря, да – есть список мостов, которым занимаются разработчики проекта.

Просто он не публичный. Вместо этого пользователи могут получать небольшой список мостов, чтобы соединиться с остальной частью сети. Этот список, BridgeDB, выдаёт пользователям только по нескольку мостов за раз. Это разумно, так как много мостов сразу им и не нужно.


Tor Bridges
https://t.me/s/tor_bridges
https://bridges.torproject.org/bridges/?transport=obfs4
https://t.me/GetBridgesBot

2025-08-31:


obfs4 45.136.229.31:9091 E1CE388BE6A02D1D4B791487F60624B54096CCC2 cert=vSiW4HJJeg1hR1MVW/8ENz2uQNIQpKC9LkPSzGSExzjOBiPgc7QL/9sG5kAP/juB4NhVYg iat-mode=0

obfs4 185.177.207.149:8443 69E9E63C529D8A48D7AD9F7828C02973C4C80042 cert=Ww+My19m46C3iGCKmc9NYd5cjrsDVmJCEzwr0jnrsdsE4w0kj4dPBSzz4vSu276P0sOJHQ iat-mode=0

obfs4 51.75.25.151:9003 B669C827EB059C3CBCCC50710F5EE97E5E4B23CA cert=hgyMuXRakoQ/rKJ3kUH8seAE3ovad26fpo4IKIPuB+38KOy03u6MeDxq2Ij/wVNDnda8fg iat-mode=0

obfs4 188.68.43.140:8172 E5B78CFB1C98BE61B9B3ABB02BDE9B58F2202734 cert=YglA5CTmyDRZmA26n6QM0+bC4ZRvZP8KMpBepBUDknINvv8nrVOeOw3vhL5jMtbcDtHWZA iat-mode=0

obfs4 45.76.193.103:4399 2920F0F64AE0DC64B67D9EF4A27312E372477908 cert=FB/VBJY2nnupmSyX83Hpye3NW4DmpfHMVXsZ+BWgR2NBqoALFAJtrMsVmy0b7R3ggVx9ZQ iat-mode=0

obfs4 185.177.207.90:12346 238AACEB6CC10CCB1A8382DE626229EFD2791B8F cert=p9L6+25s8bnfkye1ZxFeAE4mAGY7DH4Gaj7dxngIIzP9BtqrHHwZXdjMK0RVIQ34C7aqZw iat-mode=2




2025-08-31:

obfs4 75.49.198.211:443 802FB37ED43DCE3C247A22BD4131006DF6032CD2 cert=3Wki90hpktv2ZGBAIu82pGLrv1HsDEr1GlMo0NF+fqu6PBTmT6WD9P0A1iUNYQRoUNFKAQ iat-mode=0
obfs4 112.119.55.9:53540 F8C666DE8CC24BCDC13F71B821D2AC6C1BB1ADB9 cert=KzkElf/urMb1lysk+Wa9l9oNN4ozBOekJa62J07IP1Gu8S1lR8UxolwvC42HSirdQlrGBQ iat-mode=0

obfs4 77.128.112.133:587 AD8771A1DDE6676F19EB3BF8FE953D3E9C8CA3B0 cert=b748riEUUYw5OgV6Wy3MUMyv9U+dPgNAzgI7wU7ZaHsU50znHjGs3w6gvGMFv3vQyDMWMw iat-mode=0
obfs4 178.196.147.159:995 E4BFB6D0104B39023047F0DBEC6968D342C663B7 cert=7XQJE7iuQybP8HkddKOz7Xj8XACzbwEXS1dITzCJeVA9khBS0C22vTZYtLjVv6AhEeinGg iat-mode=1


webtunnel [2001:db8:17e6:8669:9ae4:38cc:f71c:9577]:443 BF4A979C77EA858ED0726EDB8891CB8FB317187D url=https://galleria.bm-dataprotect.ch ver=0.0.3
webtunnel [2001:db8:5985:711a:a60e:61a0:1260:b42e]:443 58DA67BD879E9239FCD4A590E25118BB2118CB3C url=https://fdmf.ch/QCjqMFJumKjWgB7BFaOc04dN ver=0.0.1




obfs4 185.177.207.86:12346 A6EFFD0D25DC63A68F9B724CCD83F10D33958757 cert=p9L6+25s8bnfkye1ZxFeAE4mAGY7DH4Gaj7dxngIIzP9BtqrHHwZXdjMK0RVIQ34C7aqZw iat-mode=2

obfs4 88.133.248.4:3479 3AE8AD626474EAB411AC237C3A16635CB2A336EB cert=VKKdzBVgZwtBqAkHMjlsY2aOUla4KqaEblEu8p4O/JBnlopE1egEH0/ei+ogugGf9JCZPQ iat-mode=0

obfs4 5.230.119.38:22333 8B920DA77C4078FBCF0491BB39B3B974EA973ACF cert=i5KyaS5ctKWLnxAz6CGaoWra/Ig3pelT/7yZ34T9//VRms3oABHk946MKNB2IcK175UGJw iat-mode=0

obfs4 194.247.182.114:443 C7A993F4767B9A62D554C3089AAC358E1F7677BD cert=uwgXz5kvB7jTOajOlZRvEIrxlbbJE2Ssax7WcJBx3AbcNjaC2BSB4hApbhtGRDiGpYy1EA iat-mode=0

obfs4 185.193.67.227:4561 A1AEF219B883CCB9383317FA310826122034F513 cert=4Y2jNuZXxStIrVZxPQLuwFlRMnzEFRd0uTFAuUd2PWEcjYRzekE66ENUOqT8KpRn5oO/Ug iat-mode=0

obfs4 172.81.181.254:3690 544DC031B0C808FCE698E20FBBCC5620F5F09981 cert=tuyUC1aAqLFdPA0eoNWsgRbQQ39P4XUzAbCybjoyw0OrHK8NP5UARc88DF1tMejQHtKQIg iat-mode=0


Official Bridge Bot: @GetBridgesBot
Official Tor Project Support: @TorProjectSupportBot
Get Tor Browser: @GetTor_Bot
👍
9

###############################


sudo nano /etc/tor/torrc - правим конфиг (ВНИМАНИЕ в этом файле НУЖНО ВСТАВИТЬ IP АДРЕС Raspberry + добавить obfs4 прокси которые мы получили, удалить полностью строку в этом nano "блокноте" это кнопка "F9")

##Вставляем все это в /etc/tor/torrc от начала до конца "Всю портянку прям с комментариями на кириллице.

SOCKSPort 192.168.XX.Y:9977

## Это ваш прокси SOCKS5 вида IP:Port. Меняем XX.Y на ваш IP адрес Raspberry в локальной сети полученным устройством (например ifconfig, или смотреть на роутере\свитче, или где угодно, мы то уже правим конфиг к этому моменту, ставили пакеты.. Вы его должны знать, меняем порт на нужный вам)

SOCKSPolicy accept 192.168.XX.0/16

## Тут тоже нужно поменять на вашу подсеть 192.168.XX.0/16 - где XX верное в Вашем случае

RunAsDaemon 1

DataDirectory /var/lib/tor

StrictNodes 1

ClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy

UseBridges 1

ExcludeExitNodes {RU},{UA},{AM},{KG},{BY}

## Перечисляем символические имена стран, узлы из которых не хотим использовать в качестве выходных (в примере это Россия, Украина, Белоруссия)

ExcludeNodes {RU},{UA},{AM},{KG},{BY}

## Эта опция исключает ноды на любых стадиях при составлении маршрута, то есть указанные ноды не могут использоваться для входной, промежуточной или выходной ноды.

## И вот тут мы вставляем прокси которые мы набрали чуть выше. Не забываем что фразу "Bridge" вставляем перед каждой прокси.

## Эти что ниже обязательно удалить, это пример и вставить ваш составленный список.

bridge obfs4 185.177.207.210:11210 044defca9726828cae0f880dfedb6d957006087a cert=mlcpy31wgw9vs1tqdcxgiyzaaq6rcdwvw50klpdak/4mzva+wekmlzqrqatcbump2y36tq iat-mode=1

bridge obfs4 188.121.98.35:3312 59c83853c391991814c238e99b7c0c7a0efa9d16 cert=/qxxb1tpclw75azw7i1uvshzxzh0cnyfayxhthhbn03vx8oot2bxikb6ww+cqt+zackjvg iat-mode=0

Закрываем Ctrl+S и Ctrl+X (Смотри на язык раскладки, иначе не применится)

sudo systemctl enable tor.service (Запуск)

sudo systemctl enable tor (Запуск)

sudo update-rc.d -f tor remove && sudo update-rc.d -f tor defaults (Запуск)

sudo systemctl restart tor (Рестарт сервисов TOR)

sudo systemctl restart tor@default.service (Рестарт сервисов TOR)

sudo systemctl status tor (Cмотрим статус TOR, если Active: failed - красный, то не работает и что-то сделали не так! Active: active (exited) - хорошо. Служба должна работать после перезагрузки)

sudo systemctl status tor@default.service (Active: active (running) - хорошо, остальное нет. Служба должна работать после перезагрузки)

journalctl -exft Tor (Ищем строку Bootstrapped 100% (done): Done (Если она есть тор работает!) После установки мне удобно смотреть старт через эту команду, что происходит)

NYX (запускаем мониторинг если нужно для наглядности)

Переходим в браузер. Все описанное выше запустило нам прокси тор, можно ставить прокси в браузер!
Ставим в CHROME расширение "Антизапрет":

https://chromewebstore.google.com/detail/обход-блокировок-рунета/npgcnondjocldhldegnakemclmfkngch?utm_source=ext_app_menu
Тык

Ставим галочки, нажимаем плюсик.

Добавляем сайты которые нужно проксировать, или через вон те две стрелочки туда-сюда вносим их сразу списком

Проверяем работу сайтов.

Я проверяю через whoer.net + сайты Onion:
http://check.torproject.org (Должно быть желтым, зелёным не знаю как настроить что полностью функционально было)
http://a4ygisnerpgtc5ayerl22pll6cls3oyj54qgpm7qrmb66xrxts6y3lyd.onion/index.html - Сайт TOR
https://old.reddittorjg6rue252oqsxryoxengawnmo46qy4kyii5wtqnwfj4ooad.onion/ - Reddit
https://onion.center/cgi/out.cgi?i=22 - ФЛИБУСТА!

Готово! Дальше по желанию. Есть что поменять\добавить напишите. Все что я находил на гитхабе\сети, либо не актуальное и не обновляет из репозиториев, либо не работает, либо не работает в наших реалиях, либо просто кусок команд, и поди разберись. Городить докеры "аля проще" я не захотел, тут наглядно и просто. Это сможет сделать ну просто любой по формату далее-далее-далее.

Моя цель дальше сделать скрипт на .sh по подобию:
 https://github.com/martinkubecka/quickToRelay/blob/main/quickToRelay.sh








https://linuxconfig.org/install-tor-proxy-on-ubuntu-20-04-linux
https://vk.com/wall-129498031_34687

Tor (Русский)
https://wiki.archlinux.org/title/Tor_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
https://bridges.torproject.org/bridges?transport=obfs4
yay -S obfs4proxy

tor --version
Лицензия(и):  BSD-3-Clause, только LGPL-3.0, MIT
https://archlinux.org/packages/extra/x86_64/tor/
https://www.torproject.org/download/tor/
2025-07-17 13:33 UTC

Настройка прокси-сервера Tor на Arch Linux
https://gist.github.com/valyakuttan/ce4afb62288120cd5ecef0fde4ea63c4
https://linuxconfig.org/install-tor-proxy-on-ubuntu-20-04-linux

Для начала нам нужно установить Tor в нашей системе. Откройте терминал и введите следующую команду для установки:
Установитьtor
     $ sudo pacman -S tor
     $ # # nyx обеспечивает мониторинг состояния терминала для получения информации об использовании полосы пропускания, сведениях о соединении и т. д.
     $ sudo pacman -S nyx
     $ # # torsocks безопасно торифицирует приложения
     $ sudo pacman -S torsocks

Запустить службу Tor
     $ sudo systemctl enable --now tor.service  # Запустить службу Tor

По умолчанию Tor работает на порту 9050. Вы можете убедиться, что Tor работает корректно, выполнив ss команду в терминале:
По умолчанию Tor работает на порту 9050. Проверьте это.
$ systemctl status tor.service
$ ss -nlt

Еще один быстрый способ проверить, установлен ли Tor, и узнать, какую версию вы используете, — это выполнить следующую команду:
$ tor --version
Версия Tor 0.4.2.7.

Давайте посмотрим, как работает Tor, и убедимся, что он работает так, как задумано. Для этого мы получим внешний IP-адрес из сети Tor. Для начала проверьте свой текущий IP-адрес:
Тестовое сетевое соединение Tor
Проверьте свой текущий публичный IP-адрес
$ wget -qO - https://api.ipify.org ;  echo
wget -qO - https://api.ipify.org; echo

Затем мы выполним ту же команду, но добавим к ней префикс torsocks. Таким образом, команда будет запущена через наш клиент Tor.
Торифицируйте команду через torsocks
$ torsocks wget -qO - https://api.ipify.org ;  echo
torsocks wget -qO - https://api.ipify.org; echo
$ # # должен показывать другой IP-адрес
Теперь вы должны увидеть другой IP-адрес. Это означает, что наш запрос успешно прошёл через сеть Tor.



Как «торифицировать» свою оболочку
Очевидно, что добавление префикса к каждой команде, связанной с сетью, torsocksбыстро надоест. Если вы хотите использовать сеть Tor по умолчанию для команд оболочки, вы можете использовать торификатор оболочки с помощью следующей команды:
Торифицируйте свою оболочку
торифицировать оболочку, выдать: Режим Tor активирован. Каждая команда будет торифицирована для этой оболочки.
source torsocks on
$ source torsocks on

Чтобы убедиться, что это сработало, попробуйте получить свой IP-адрес без использования torsocksпрефикса команды:
$ wget -qO - https://api.ipify.org ;  echo
$ # # необходимо показать IP-адрес узла Tor
Посмотрите, как меняется наш IP-адрес при использовании префикса команды torsocks.

Оболочка, работающая в режиме торификации, будет активна только в текущем сеансе. При открытии новых терминалов или перезагрузке компьютера оболочка по умолчанию вернётся к обычному подключению. Чтобы включить её torsocksпостоянно для всех новых сеансов оболочки и после перезагрузки, используйте следующую команду:
$ echo ". torsocks on" >> ~/.bashrc
Чтобы включить его torsocks постоянно для всех новых оболочек, добавьте его в.bashrc
$ echo  " . torsocks on "  >>  ~ /.bashrc

Если вам нужно torsocksснова выключить режим, просто введите:
Если вы хотите выключить torsocks, попробуйте
 $ source torsocks off
Режим Tor деактивирован. Команда больше не будет проходить через Tor.


Включить порт управления Tor
Добавьте к вашему/etc/tor/torrc

ControlPort 9051

Установить пароль управления Tor
Преобразуйте свой пароль из обычного текста в хеш

$ set +o history  # сбросить историю bash
$ tor --hash-password  # your_password  ваш_пароль
$ set -o history # установить историю bash

Добавьте этот хэш к вашему/etc/tor/torrc

HashedControlPassword ваш_хэш
HashedControlPassword your_hash

Перезапуск tor
$ sudo systemctl restart tor.service

Проверьте состояние порта 9051
$ ss -nlt

Проверьте свой torпорт управления
Установить gnu-netcat
$ sudo pacman -S gnu-netcat

Чтобы проверить ваше tor использование
$ echo -e ' ПРОТОКОЛИНОВАЯ\r\n '  | нк 127.0.0.1 9051

$ echo -e 'PROTOCOLINFO\r\n' | nc 127.0.0.1 9051

Чтобы запросить новый канал (IP-адрес) от Tor, используйте
$ set +o history
$ echo -e ' АУТЕНТИФИКАЦИЯ "my-tor-password"\r\nsignal NEWNYM\r\nВЫЙТИ '  | nc 127.0.0.1 9051
$ set -o history

$ set +o history
$ echo -e 'AUTHENTICATE "my-tor-password"\r\nsignal NEWNYM\r\nQUIT' | nc 127.0.0.1 9051
$ set -o history

Также есть эта команда для анонимности firefox:

$ torify firefox

После ввода этих настроек нажмите «ОК». Вы можете убедиться, что изменения вступили в силу, перейдя на сайт, например, IP Chicken, чтобы убедиться, что вы подключены к сети Tor. Рекомендуется выполнять это действие каждый раз, когда вы хотите быть абсолютно уверены в анонимности своего сёрфинга.
https://ipchicken.com/

Here are your bridge lines:

obfs4 71.214.160.134:29003 47E05016F24C7C3947ED3AB80AF224363118302F cert=ColKK1RnQXuaCGyiTZ6AhsKGGaPkQOYrNZ/l/AgZiwsc66AwR3+41yJnVXZJ0YnBIP12CA iat-mode=0
obfs4 185.85.87.222:443 24479DC0282DECD4EE9EDD6017B25EDDD217AAF1 cert=A4npStLmm2JEMPOAvtn8U0BJ5VGdDA2S+7pd4/aIutCi/t5HaKEvEfqkpj6cvF2kKm8VGQ iat-mode=0

################################




https://wttr.in/

torsocks curl wttr.in
Weather report: Amsterdam, Netherlands

     \  /       Partly cloudy
   _ /"".-.     +7(5) °C
     \_(   ).   ↘ 15 km/h
     /(___(__)  10 km
                0.5 mm

  Я не в Амстердаме, так почему же он показал мне погоду для Амстердама? Потому что там находится выходной узел Tor. Если я изменю URL-адрес для погоды с torsocks curl wttr.inна torsocks curl wttr.in/chicago, я получу погоду для Чикаго. Это всего лишь очень простой пример использования torsock с curl.

wget работает по тому же принципу. Давайте скачаем электронную версию Конституции США от Project Gutenberg в формате epub.

torsocks wget https://www.gutenberg.org/ebooks/5.epub.noimages -O uscontitution.epub
--2024-01-05 09:01:50--  https://www.gutenberg.org/ebooks/5.epub.noimages
Resolving www.gutenberg.org (www.gutenberg.org)... 152.19.134.47, 2610:28:3090:3000:0:bad:cafe:47
Connecting to www.gutenberg.org (www.gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://www.gutenberg.org/cache/epub/5/pg5.epub [following]
--2024-01-05 09:01:50--  https://www.gutenberg.org/cache/epub/5/pg5.epub
Reusing existing connection to www.gutenberg.org:443.
HTTP request sent, awaiting response... 200 OK
Length: 69326 (68K) [application/epub+zip]
Saving to: ‘uscontitution.epub’

uscontitution.epub                              100%[======================================================================================================>]  67,70K  --.-KB/s    in 0,05s

2024-01-05 09:01:50 (1,25 MB/s) - ‘uscontitution.epub’ saved [69326/69326]

В этом примере я просто использовал wget в качестве загрузчика для URL-адреса электронной книги и использовал флаг -O, чтобы указать имя файла, в котором я хочу ее сохранить.

И последнее: если сайт, к которому вы хотите применить curl, wget или любой другой инструмент или приложение, не поддерживает пользователей Tor, то этот метод не сработает. Нет простого способа обойти блокировку IP-адресов.

Не работает если в файле /etc/tor/torsocks.conf сделать так, как написано в нем самом, чтоб он слушал не локалхост а внешний интерфейс:
Код: [Выделить]
#TorAddress 127.0.0.1
#TorPort 9050
TorAddress 192.168.1.11
TorPort 9050
# Set Torsocks to accept inbound connections. If set to 1, listen() and
# accept() will be allowed to be used with non localhost address. (Default: 0)
AllowInbound 1
Сканирование портов показывает что как висел на 127.0.0.1:9050, так и продолжает, и на внешнем не появляется.
Если не так то как делать?

TorAddress 0.0.0.0
netstat -tln | grep 9050

Затем вы можете, выполнив команду:

sudo systemctl enable --now tor  #  включить и запустить демон Tor






##################

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

# -------------------------------------------------

# Если в системе не установлены необходимые зависимости, makepkg предупредит вас об этом и отменит сборку. Если задать флаг -s/--syncdeps, то makepkg самостоятельно установит недостающие зависимости и соберёт пакет.
# $ makepkg --syncdeps

# ---------------------------------------------------
# URL-адрес клона Git:  https://aur.archlinux.org/mugshot.git (только чтение, нажмите, чтобы скопировать)
# База пакета:  mugshot
# Описание: Программа для обновления личных данных пользователя
# Восходящий URL-адрес: https://github.com/bluesabre/mugshot
# Лицензии: GPLv3
# Отправитель:  None
# Сопровождающий: twa022
# Последний упаковщик:  twa022
# Голоса: 101
# Популярность: 0,46
# Впервые отправлено: 2014-10-06 21:37 (UTC)
#Последнее обновление: 2022-09-06 01:38 (UTC)
# --------------------------------------#
# checkrebuild -v
# foreign mugshot
# /usr/lib/python3.11/ is owned by mugshot 0.4.3-3
# ------------------------------------#
# <<< Делайте выводы сами! >>>

