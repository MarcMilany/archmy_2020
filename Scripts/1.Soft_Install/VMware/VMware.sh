#!/usr/bin/env bash
# Install script VMware
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

VMware_LANG="russian"  # Installer default language (Язык установки по умолчанию)

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
echo -e "${BLUE}:: ${NC}Установить VMware® Workstation Pro (vmware-workstation) для создания нескольких виртуальных компьютеров в одной системе?" 
echo -e "${CYAN}:: Примечание! ${NC}VMware прекратила поддержку ряда ЦП, включая ранние ЦП Intel Core i7, начиная с версии 14. Проверьте требования к процессорам (https://docs.vmware.com/en/VMware-Workstation-Pro/14.0/com.vmware.ws.using.doc/GUID-BBD199AA-C346-4334-9F56-5A42F7328594.html) для хост-систем и убедитесь, что технология виртуализации для вашего ЦП (AMD-V или VT-x) включена в вашей прошивке BIOS/UEFI. Если ваш ЦП не поддерживается в более новых версиях, вы можете использовать vmware-workstation12 из AUR (https://aur.archlinux.org/packages/vmware-workstation12) "
echo -e "${MAGENTA}:: ${BOLD}VMware® Workstation - это популярная программа для создания нескольких виртуальных компьютеров в одной системе. Предназначена в первую очередь для программистов и системных администраторов, которым необходимо протестировать приложения, работающие в различных средах. Собственная технология VMware MultipleWorlds дает возможность изолировать операционные системы и приложения в рамках создаваемых виртуальных машин. При этом в распоряжении каждой виртуальной машины оказывается стандартный компьютер с собственным процессором и памятью. ${NC}"
echo -e "${MAGENTA}=> ${NC}VMware® Workstation Pro (vmware-workstation) - устанавливается из пользовательского репозитория 'AUR'-'yay' (https://aur.archlinux.org/vmware-workstation.git), собираются и устанавливаются. Конфликты: с vmware-modules-dkms, vmware-ovftool, vmware-patch, vmware-systemd-services "
echo " Основные возможности: Одновременный запуск нескольких гостевых операционных систем на одном компьютере; Запуск виртуальной машины в окнах рабочего стола основной операционной системы и на полный экран;  Установка виртуальных машин без пере-разбиения дисков; Запуск уже установленных на компьютере ОС без их переустановки или пере-конфигурирования; Запуск приложений операционной системы Windows на компьютере с ОС Linux и наоборот; Создание и тестирование приложений одновременно для разных систем; Запуск клиент-серверных и веб-приложений на одном ПК; Запуск на одном ПК нескольких виртуальных компьютеров и моделирование работы локальной сети  и ещё много других функций... " 
echo -e "${YELLOW}:: Примечание! ${NC}В сценарии скрипта заложено 2 (два) варианта: 1 - Пакет VMware (vmware-workstation)(VMware Workstation 17 Pro 17.5.2 Build 23775571) - на момент написания. И 2 (ой) - Пакет VMware (vmware-workstation12) для тех у кого прекратилась поддержка ряда ЦП (информация в Примечание!). Второй вариан # закомментирован - если нужно раскомментируйте установку (vmware-workstation12), а Пакет VMware (vmware-workstation) - наоборот # # закомментируйте. "
echo "" 
while  
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Да установить,     0 - НЕТ - Пропустить установку: " i_vmware  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_vmware" =~ [^10] ]]
do
    :
done 
if [[ $i_vmware == 0 ]]; then 
echo ""   
echo " Установка утилит (пакетов) пропущена "
elif [[ $i_vmware == 1 ]]; then
  echo ""  
  echo " Установка VMware® Workstation Pro "
####### Установите правильные зависимости: ##############
sudo pacman -S --noconfirm --needed fuse2  # Интерфейс для программ пользовательского пространства для экспорта файловой системы в ядро ​​Linux ; https://github.com/libfuse/libfuse ; https://archlinux.org/packages/extra/x86_64/fuse2/ ; Конфликты: fuse
sudo pacman -S --noconfirm --needed gtkmm  # Привязки C++ для GTK+ 2 (для графического интерфейса) ; http://www.gtkmm.org/ ; https://archlinux.org/packages/extra/x86_64/gtkmm/
#sudo pacman -S --noconfirm --needed linux-headers  # Заголовки и скрипты для сборки модулей ядра Linux (для компиляции модуля) ; https://github.com/archlinux/linux ; https://archlinux.org/packages/core-testing/x86_64/linux-headers/
sudo pacman -S --noconfirm --needed linux-lts-headers  # Заголовки и скрипты для сборки модулей для ядра LTS Linux (для компиляции модуля) ; https://www.kernel.org/ ; https://archlinux.org/packages/core-testing/x86_64/linux-lts-headers/
#sudo pacman -S --noconfirm --needed linux-zen-headers  # Заголовки и скрипты для сборки модулей для ядра Linux ZEN (для компиляции модуля) ; https://github.com/zen-kernel/zen-kernel ; https://archlinux.org/packages/extra-testing/x86_64/linux-zen-headers/
sudo pacman -S --noconfirm --needed ncurses  # Библиотека эмуляции проклятий System V Release 4.0 ; https://invisible-island.net/ncurses/ncurses.html ; https://archlinux.org/packages/core/x86_64/ncurses/
#yay -S ncurses5-compat-libs --noconfirm  # System V Release 4.0 библиотека эмуляции curses, ABI 5 (ncurses5-compat-libs AUR для старых версий VMware) - требуется для --console установщика ; https://aur.archlinux.org/ncurses5-compat-libs.git (только для чтения, нажмите, чтобы скопировать) ; http://invisible-island.net/ncurses/ncurses.html ; https://aur.archlinux.org/packages/ncurses5-compat-libs
sudo pacman -S --noconfirm --needed libcanberra  # Небольшая и легкая реализация спецификации звуковой темы XDG (для звуков событий) ; https://0pointer.net/lennart/projects/libcanberra/ ; https://archlinux.org/packages/extra/x86_64/libcanberra/
sudo pacman -S --noconfirm --needed pcsclite  # Библиотека промежуточного программного обеспечения для смарт-карт архитектуры PC/SC ; https://pcsclite.apdu.fr/ ; https://archlinux.org/packages/extra/x86_64/pcsclite/
######## Пакет VMware ###########
yay -S vmware-workstation --noconfirm  # Отраслевой стандарт для запуска нескольких операционных систем в качестве виртуальных машин на одном ПК с Linux ; https://aur.archlinux.org/vmware-workstation.git (только для чтения, нажмите, чтобы скопировать) ; https://www.vmware.com/products/workstation-for-linux.html ; https://aur.archlinux.org/packages/vmware-workstation 
# Конфликты: с vmware-modules-dkms, vmware-ovftool, vmware-patch, vmware-systemd-services
# yay -Rns vmware-workstation  # Удалите vmware-workstation в Arch с помощью YAY
####################################
# git clone https://aur.archlinux.org/vmware-workstation.git ~/vmware-workstation   # Клонировать git vmware-workstation локально
#git clone https://aur.archlinux.org/vmware-workstation.git 
# cd ~/vmware-workstation  # Перейдите в папку ~/vmware-workstation и установите его
#cd vmware-workstation
# makepkg -si
#makepkg -si --noconfirm   #--не спрашивать каких-либо подтверждений
# makepkg -si --skipinteg
#pwd    # покажет в какой директории мы находимся
#cd ..   # поднимаемся на уровень выше (выходим из папки сборки)
# rm -rf vmware-workstation
#rm -Rf vmware-workstation   # удаляем директорию сборки 
######## Пакет VMware 12 ###########
# yay -S vmware-workstation12 --noconfirm  # Отраслевой стандарт для запуска нескольких операционных систем в качестве виртуальных машин на одном ПК с Linux ; https://aur.archlinux.org/vmware-workstation12.git (только для чтения, нажмите, чтобы скопировать) ; https://www.vmware.com/products/workstation-for-linux.html ; https://aur.archlinux.org/packages/vmware-workstation12
# Конфликты: с vmware-modules-dkms, vmware-ovftool, vmware-patch, vmware-systemd-services, vmware-workstation
echo " Включите некоторые из следующих служб (по желанию) "
######## Затем, по желанию, включите некоторые из следующих служб: ################
echo " Для vmware-workstation AUR сначала запустите vmware-networks-configuration.service генерацию /etc/vmware/networking "
sudo systemctl start vmware-networks-configuration.service  # Для vmware-workstation AUR сначала запустите vmware-networks-configuration.service генерацию /etc/vmware/networking
echo " Для гостевого сетевого доступа (в противном случае вы получите сообщение об ошибке could no connect 'ethernet 0' to virtual network и не сможете использовать vmware-netcfg ) "
sudo systemctl start vmware-networks.service  # для гостевого сетевого доступа (в противном случае вы получите сообщение об ошибке could no connect 'ethernet 0' to virtual network и не сможете использовать vmware-netcfg )
echo " Для подключения USB-устройств к гостевому "
sudo systemctl start vmware-usbarbitrator.service  # для подключения USB-устройств к гостевому
#echo " Для совместного использования виртуальных машин (недоступно с версии 16) "
#sudo systemctl start vmware-hostd.service  # для совместного использования виртуальных машин (недоступно с версии 16)
echo " Загрузить модули VMware "
sudo modprobe -a vmw_vmci vmmon
echo ""   
echo " Установка утилит (пакетов) выполнена "
fi
############# Справка ##########
# VMware: https://wiki.archlinux.org/title/VMware
# VMware® Workstation 17 Pro 17.5.2 Build 23775571
# VMware® Workstation 17  Pro
# 17.5.2 build-23775571
# https://github.com/hegdepavankumar/VMware-Workstation-Pro-17-Licence-Keys
# Недавно добавленные ключи...
# Number  Keys  Availability
# 1 MC60H-DWHD5-H80U9-6V85M-8280D Active +++  Работает !!!
# 2 4A4RR-813DK-M81A9-4U35H-06KND Active
# 3 NZ4RR-FTK5H-H81C1-Q30QH-1V2LA Active
# 4 JU090-6039P-08409-8J0QH-2YR7F Active
# 5 4Y09U-AJK97-089Z0-A3054-83KLA Active
# 6 4C21U-2KK9Q-M8130-4V2QH-CF810 Active
# 7 HY45K-8KK96-MJ8E0-0UCQ4-0UH72 Active
# 8 JC0D8-F93E4-HJ9Q9-088N6-96A7F Active
# 9 NG0RK-2DK9L-HJDF8-1LAXP-1ARQ0 Active
# 10  0U2J0-2E19P-HJEX1-132Q2-8AKK6 Active
# https://kak.kornev-online.net/FILES/KAK%20-%20VMware%20Workstation%20Pro%204.x-17.x%20Universal%20License%20Keys%20collection.pdf
# VMware Workstation 17.x.x MC60H-DWHD5-H80U9-6V85M-8280D
# Внимание !!!
# VMware сделала свои продукты VMware Workstation Pro и VMware Fusion Pro бесплатными для персонального использования.
# После регистрации учетной записи VMware и установки Workstation Pro или Fusion вас встретит экран, спрашивающий, используете ли вы продукт для личного использования или в коммерческой среде.
# Если вы используете продукт в коммерческих целях, необходимо ввести приобретенный лицензионный ключ. Однако для личных пользователей достаточно выбрать соответствующую опцию (Use VMware Workstation 17 for Personal Use или Use VMware Fusion 13 for Personal Use), и продукт установится со всеми стандартными функциями без ограничений.
##################################
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

