#!/usr/bin/env bash
# Install script Docker
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

Docker_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
echo -e "${BLUE}:: ${NC}Установить Docker (docker) - Упакуйте, отправьте и запустите любое приложение в виде легкого контейнера?"
echo -e "${MAGENTA}:: ${BOLD}Docker — это платформа с открытым исходным кодом, которая упрощает процесс разработки, доставки и запуска приложений с помощью технологии контейнеризации. Контейнеры позволяют разработчикам упаковывать приложение со всеми его зависимостями в стандартизированный блок для разработки программного обеспечения. Docker обеспечивает дополнительный уровень абстракции и автоматизации виртуализации на уровне операционной системы в Linux и Windows. Он широко используется для обеспечения согласованных сред от разработки до производства, поддержки архитектур микросервисов и повышения масштабируемости и эффективности развертывания программного обеспечения. Docker не нуждается в представлении тем, кто работает с контейнерными приложениями. Он уже используется сотнями предприятий и разработчиков по всему миру. 🔮 ${NC}"
echo " Домашняя страница: https://www.docker.com/ ; (https://wiki.archlinux.org/title/Docker ; https://archlinux.org/packages/extra/x86_64/docker/ ; https://archlinux.org/packages/extra/x86_64/docker-compose/). "  
echo -e "${MAGENTA}:: ${BOLD}В своем ядре docker позволяет запускать практически любое приложение, безопасно изолированное в контейнере. Безопасная изоляция позволяет вам запускать на одном хосте много контейнеров одновременно. Легковесная природа контейнера, который запускается без дополнительной нагрузки гипервизора, позволяет вам добиваться больше от вашего железа. Платформа и средства контейнерной виртуализации могут быть полезны в следующих случаях: упаковывание вашего приложения (и так же используемых компонент) в docker контейнеры; раздача и доставка этих контейнеров вашим командам для разработки и тестирования; выкладывания этих контейнеров на ваши продакшены, как в дата центры так и в облака. ${NC}"
echo " Для чего я могу использовать docker? Быстрое выкладывание ваших приложений: Docker прекрасно подходит для организации цикла разработки. Docker позволяет разработчикам использовать локальные контейнеры с приложениями и сервисами. Что в последствии позволяет интегрироваться с процессом постоянной интеграции и выкладывания (continuous integration and deployment workflow). Более простое выкладывание и разворачивание: Основанная на контейнерах docker платформа позволят легко портировать вашу полезную нагрузку. Docker контейнеры могут работать на вашей локальной машине, как реальной так и на виртуальной машине в дата центре, так и в облаке. Портируемость и легковесная природа docker позволяет легко динамически управлять вашей нагрузкой. Вы можете использовать docker, чтобы развернуть или погасить ваше приложение или сервисы. Скорость docker позволяет делать это почти в режиме реального времени. Высокие нагрузки и больше полезных нагрузок: Docker легковесен и быстр. Он предоставляет устойчивую, рентабельную альтернативу виртуальным машинам на основе гипервизора. Он особенно полезен в условиях высоких нагрузок, например, при создания собственного облака или платформа-как-сервис (platform-as-service). Но он так же полезен для маленьких и средних приложений, когда вам хочется получать больше из имеющихся ресурсов. Главные компоненты Docker - Docker состоит из двух главных компонент: Docker: платформа виртуализации с открытым кодом; Docker Hub: наша платформа-как-сервис для распространения и управления docker контейнерами. Примечание! Docker распространяется по Apache 2.0 лицензии. Docker использует архитектуру клиент-сервер. Docker клиент общается с демоном Docker, который берет на себя тяжесть создания, запуска, распределения ваших контейнеров. Оба, клиент и сервер могут работать на одной системе, вы можете подключить клиент к удаленному демону docker. Клиент и сервер общаются через сокет или через RESTful API. " 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да установить,     0 - НЕТ - Пропустить установку: " in_docker  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$in_docker" =~ [^10] ]]
do
    :
done
if [[ $in_docker == 0 ]]; then
echo ""
echo " Установка утилит (пакетов) пропущена "
elif [[ $in_docker == 1 ]]; then
  echo ""
  echo " Установка Docker (docker) "
sudo pacman -Syy  # обновление баз пакмэна (pacman)
# sudo pacman -S --noconfirm --needed docker docker-compose
########## Зависимости ###########
sudo pacman -S --noconfirm --needed docker-buildx  # Плагин Docker CLI для расширенных возможностей сборки с помощью BuildKit ; https://github.com/docker/buildx ; https://archlinux.org/packages/extra/x86_64/docker-buildx/ ; 25 июля 2024 г., 16:31 UTC ; 
# Основные характеристики: Знакомый пользовательский интерфейс отdocker build. Полные возможности BuildKit с драйвером контейнера. Поддержка нескольких экземпляров конструктора. Многоузловые сборки для кроссплатформенных образов. Поддержка сборки Compose. Высокоуровневые конструкции сборки ( bake). Поддержка драйверов внутри контейнера (Docker и Kubernetes).
sudo pacman -S --noconfirm --needed docker-scan  # Docker Scan — это интерфейс командной строки для запуска обнаружения уязвимостей в файлах Dockerfiles и образах Docker ; https://github.com/docker/scan-cli-plugin ; https://archlinux.org/packages/extra/x86_64/docker-scan/ ; 4 июля 2024 г., 14:49 UTC ; Чтобы продолжить изучение уязвимостей ваших изображений и многих других функций, используйте новую docker scoutкоманду. Запустите docker scout --helpили узнайте больше на https://docs.docker.com/engine/reference/commandline/scout/
######### Docker ########
sudo pacman -S --noconfirm --needed docker  # Упакуйте, отправьте и запустите любое приложение в виде легкого контейнера ; https://www.docker.com/ ; https://archlinux.org/packages/extra/x86_64/docker/ ; 30 августа 2024 г., 4:54 UTC ; Смотрите Зависимости ! 
sudo pacman -S --noconfirm --needed docker-compose  # Быстрые, изолированные среды разработки с использованием Docker ; https://www.docker.com/ ; https://archlinux.org/packages/extra/x86_64/docker-compose/ ; 16 августа 2024 г., 13:34 UTC ;  Смотрите Зависимости !  
### Docker помогает разработчикам создавать, совместно использовать, запускать и проверять приложения где угодно — без утомительной настройки среды или управления.
### https://wiki.archlinux.org/title/Docker_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
### https://itshaman.ru/articles/3048/ustanovka-docker-na-arch-linux
# или yay -S docker-git  # Упакуйте, отправьте и запустите любое приложение в виде легкого контейнера ; https://aur.archlinux.org/docker-git.git (только для чтения, нажмите, чтобы скопировать); https://github.com/docker/docker ; https://aur.archlinux.org/packages/docker-git 
  echo " Проверьте версию Docker "
docker version
  echo ""
  echo " Запуск демона Docker (docker.service) (Стартуем сервис Docker) "
sudo systemctl start docker.service  # Запуск демона Docker
# sudo systemctl start containerd.service
  echo " Включить службу Docker (docker.service) в автозагрузку "
  echo " Разрешаем запуск сервиса docker при старте системы "
echo " Вы можете просто начать выполнять команды docker. Вам больше не нужно будет вручную запускать службу docker."  
sudo systemctl enable docker.service
# sudo systemctl enable containerd.service
# sudo systemctl disable docker.service
# Чтобы отключить это поведение, используйте вместо него disable .
# sudo systemctl disable docker.service
# sudo systemctl disable containerd.service
# sudo systemctl status docker
  echo ""
  echo " [Опционально] Создайте группу Docker "
sudo groupadd docker  # Создайте группу Docker  
  echo ""
  echo " [Опционально] добавляем текущего пользователя в группу Docker "
  echo " Для возможности запуска Docker-команд без прав суперпользователя "  
# groupadd: group 'docker' already exists
# sudo gpasswd -a username docker
# usermod -a -G docker $USERNAME
sudo usermod -aG docker $USER
#  echo " [Опционально] добавляем свою сеть для Docker "
# sudo docker network create -d bridge evilcorp  # Работа с сетью (Networking) в Docker
echo " Чтобы вышеуказанное изменение вступило в силу, необходимо выйти из системы (или закрыть терминал) и снова войти в нее "
echo " Если вы не хотите этого делать, воспользуйтесь следующей командой: "
newgrp docker  # Чтобы обновления в группах вступили в силу
  echo ""
  echo " Проверка установки Docker (Проверяем, всё ли ок) "
  echo " Для проверки установки docker есть небольшой образ docker, предоставленный самим docker "
  echo " Запустите его и посмотрите, все ли работает: "
  echo " Если в терминале появились сообщения, то вы успешно установили Docker на Arch Linux! "
# docker run -it --rm archlinux bash -c "echo hello world"  # Следующая команда загружает последний образ Arch Linux и использует его для запуска программы Hello World в контейнере 
docker run hello-world  # Для проверки установки docker
sleep 05
echo ""
echo " Установка утилит (пакетов) выполнена "
fi
#########
# Если вы изначально запускали команды CLI Docker с помощью sudo перед добавлением пользователя в группу docker , вы можете увидеть следующую ошибку, которая указывает на то, что ваш каталог ~/.docker/ был создан с неправильными разрешениями из-за команд sudo .
# WARNING: Error loading config file: /home/user/.docker/config.json -
# stat /home/user/.docker/config.json: permission denied
# Чтобы устранить эту проблему, либо удалите каталог ~/.docker/ (он создаётся автоматически, но все пользовательские настройки теряются), либо измените его владельца и разрешения с помощью следующих команд:
# sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
# sudo chmod g+rwx "$HOME/.docker" -R
# Удалите каталоги хранения Docker:
# sudo rm -rf /var/lib/docker 
# sudo rm -rf /var/lib/containerd
# https://runebook.dev/ru/docs/docker/engine/install/linux-postinstall/index
# https://medium.com/webbdev/docker-bbb3de0f02c3
##################
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

